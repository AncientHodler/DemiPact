;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module ATSH GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_ATSH           (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_ATSH           (keyset-ref-guard ATS.ATS|SC_KEY))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|ATSH_ADMIN))
    )
    (defcap GOV|ATSH_ADMIN ()
        (enforce-one
            "ATSH Autostake Admin not satisfed"
            [
                (enforce-guard GOV|MD_ATSH)
                (enforce-guard GOV|SC_ATSH)
            ]
        )
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    (defcap P|ATSH|REMOTE-GOV ()
        true
    )
    (defcap P|ATSH|CALLER ()
        true
    )
    (defcap P|ATSH|UPDATE_ROU ()
        true
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|ATSH_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        (ATS.P|A_Add
            "ATSH|RemoteAtsGov"
            (create-capability-guard (P|ATSH|REMOTE-GOV))
        )
        (ATS.P|A_Add
            "ATSH|UpdateROU"
            (create-capability-guard (P|ATSH|UPDATE_ROU))
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
    (defcap COMPOSE ()
        true
    )
    ;;{5}
    ;;{6}
    ;;{7}
    (defcap ATSH|C>HOT_REC (recoverer:string atspair:string ra:decimal)
        @event
        (DALOS.DALOS|CAP_EnforceAccountOwnership recoverer)
        (ATS.ATS|UEV_id atspair)
        (ATS.ATS|UEV_RecoveryState atspair true false)
        (compose-capability (P|ATSH|REMOTE-GOV))
        (compose-capability (P|ATSH|CALLER))
    )
    (defcap ATSH|C>REDEEM (redeemer:string id:string)
        @event
        (DPMF.DPMF|UEV_id id)
        (DALOS.DALOS|UEV_EnforceAccountType redeemer false)
        (compose-capability (P|ATSH|REMOTE-GOV))
        (compose-capability (P|ATSH|UPDATE_ROU))
        (compose-capability (P|ATSH|CALLER))
        (let
            (
                (iz-rbt:bool (DPMF.DPMF|URC_IzRBT id))
                
            )
            (enforce iz-rbt "Invalid Hot-RBT")
        )
    )
    (defcap ATSH|C>RECOVER (recoverer:string id:string nonce:integer amount:decimal)
        @event
        (DPMF.DPMF|UEV_id id)
        (DALOS.DALOS|UEV_EnforceAccountType recoverer false)
        (compose-capability (P|ATSH|REMOTE-GOV))
        (compose-capability (P|ATSH|CALLER))
        (let
            (
                (iz-rbt:bool (DPMF.DPMF|URC_IzRBT id))
                (nonce-max-amount:decimal (DPMF.DPMF|UR_AccountBatchSupply id nonce recoverer))
                
            )
            (enforce iz-rbt "Invalid Hot-RBT")
            (enforce (>= nonce-max-amount amount) "Recovery Amount surpasses Batch Balance")
        )
    )
    ;;
    ;;{8}
    ;;{9}
    ;;{10}
    ;;{11}
    ;;{12}
    ;;{13}
    ;;
    ;;{14}
    ;;{15}
    (defun ATSH|C_HotRecovery (patron:string recoverer:string atspair:string ra:decimal)
        (with-capability (ATSH|C>HOT_REC recoverer atspair ra)
            (let*
                (
                    (c-rbt:string (ATS.ATS|UR_ColdRewardBearingToken atspair))
                    (h-rbt:string (ATS.ATS|UR_HotRewardBearingToken atspair))
                    (present-time:time (at "block-time" (chain-data)))
                    (meta-data-obj:object{ATS.ATS|Hot} { "mint-time" : present-time})
                    (meta-data:[object] [meta-data-obj])
                    (new-nonce:integer (+ (DPMF.DPMF|UR_NoncesUsed h-rbt) 1))
                )
                (TFT.DPTF|C_Transfer patron c-rbt recoverer ATS.ATS|SC_NAME ra true)
                (DPTF.DPTF|C_Burn patron c-rbt ATS.ATS|SC_NAME ra)
                (DPMF.DPMF|C_Mint patron h-rbt ATS.ATS|SC_NAME ra meta-data)
                (DPMF.DPMF|C_Transfer patron h-rbt new-nonce ATS.ATS|SC_NAME recoverer ra true)
            )
        )
    )
    (defun ATSH|C_Redeem (patron:string redeemer:string id:string nonce:integer)
        (with-capability (ATSH|C>REDEEM redeemer id)
            (let*
                (
                    (precision:integer (DPMF.DPMF|UR_Decimals id))
                    (current-nonce-balance:decimal (DPMF.DPMF|UR_AccountBatchSupply id nonce redeemer))
                    (meta-data (DPMF.DPMF|UR_AccountBatchMetaData id nonce redeemer))

                    (birth-date:time (at "mint-time" (at 0 meta-data)))
                    (present-time:time (at "block-time" (chain-data)))
                    (elapsed-time:decimal (diff-time present-time birth-date))

                    (atspair:string (DPMF.DPMF|UR_RewardBearingToken id))
                    (rt-lst:[string] (ATS.ATS|UR_RewardTokenList atspair))
                    (h-promile:decimal (ATS.ATS|UR_HotRecoveryStartingFeePromile atspair))
                    (h-decay:integer (ATS.ATS|UR_HotRecoveryDecayPeriod atspair))
                    (h-fr:bool (ATS.ATS|UR_HotRecoveryFeeRedirection atspair))

                    (total-time:decimal (* 86400.0 (dec h-decay)))
                    (end-time:time (add-time birth-date (hours (* 24 h-decay))))
                    (earned-rbt:decimal
                        (if (>= elapsed-time total-time)
                            current-nonce-balance
                            (floor (* current-nonce-balance (/ (- 1000.0 (* h-promile (- 1.0 (/ elapsed-time total-time)))) 1000.0)) precision)
                        )
                    )
                    (total-rts:[decimal] (ATS.ATS|URC_RTSplitAmounts atspair current-nonce-balance))
                    (earned-rts:[decimal] (ATS.ATS|URC_RTSplitAmounts atspair earned-rbt))
                    (fee-rts:[decimal] (zip (lambda (x:decimal y:decimal) (- x y)) total-rts earned-rts))
                )
                (DPMF.DPMF|C_Transfer patron id nonce redeemer ATS.ATS|SC_NAME current-nonce-balance true)
                (DPMF.DPMF|C_Burn patron id nonce ATS.ATS|SC_NAME current-nonce-balance)

                (TFT.DPTF|C_MultiTransfer patron rt-lst ATS.ATS|SC_NAME redeemer earned-rts true)
                (map
                    (lambda
                        (index:integer)
                        (ATS.ATS|X_UpdateRoU atspair (at index rt-lst) true false (at index earned-rts))
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
                (if (and (not h-fr) (!= earned-rbt current-nonce-balance))
                    (map
                        (lambda
                            (index:integer)
                            (with-capability (COMPOSE)
                                (DPTF.DPTF|C_Burn patron (at index rt-lst) ATS.ATS|SC_NAME (at index fee-rts))
                                (ATS.ATS|X_UpdateRoU atspair (at index rt-lst) true false (at index fee-rts))
                            )
                        )
                        (enumerate 0 (- (length rt-lst) 1))
                    )
                    true
                )
            )
        )
    )
    (defun ATSH|C_RecoverWholeRBTBatch (patron:string recoverer:string id:string nonce:integer)
        (ATSH|C_RecoverHotRBT patron recoverer id nonce (DPMF.DPMF|UR_AccountBatchSupply id nonce recoverer))
    )
    (defun ATSH|C_RecoverHotRBT (patron:string recoverer:string id:string nonce:integer amount:decimal)
        (with-capability (ATSH|C>RECOVER recoverer id nonce amount)
            (let*
                (
                    (atspair:string (DPMF.DPMF|UR_RewardBearingToken id))
                    (c-rbt:string (ATS.ATS|UR_ColdRewardBearingToken atspair))
                )
                (DPMF.DPMF|C_Transfer patron id nonce recoverer ATS.ATS|SC_NAME amount true)
                (DPMF.DPMF|C_Burn patron id nonce ATS.ATS|SC_NAME amount)
                (DPTF.DPTF|C_Mint patron c-rbt ATS.ATS|SC_NAME amount false)
                (TFT.DPTF|C_Transfer patron c-rbt ATS.ATS|SC_NAME recoverer amount true)
            )
        )
    )
    ;;{16}
)

(create-table P|T)