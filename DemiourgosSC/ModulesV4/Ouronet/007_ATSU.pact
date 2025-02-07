;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module ATSU GOV
    ;;
    (implements OuronetPolicy)
    (implements AutostakeUsage)
    ;;{G1}
    (defconst GOV|MD_ATSU           (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_ATSU           (keyset-ref-guard (GOV|AutostakeKey)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|ATSC_ADMIN)))
    (defcap GOV|ATSC_ADMIN ()
        (enforce-one
            "ATSU Autostake Admin not satisfed"
            [
                (enforce-guard GOV|MD_ATSU)
                (enforce-guard GOV|SC_ATSU)
            ]
        )
    )
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|AutostakeKey ()      (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|AutostakeKey)))
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    ;;{P3}
    (defcap P|ATSU|REMOTE-GOV ()
        true
    )
    (defcap P|ATSU|CALLER ()
        true
    )
    (defcap P|ATSU|UPDATE_ROU ()
        true
    )
    (defcap P|TT ()
        (compose-capability (P|DT1))
        (compose-capability (P|ATSU|CALLER))
    )
    (defcap P|DT1 ()
        (compose-capability (P|ATSU|REMOTE-GOV))
        (compose-capability (P|ATSU|UPDATE_ROU))
    )
    (defcap P|DT2 ()
        (compose-capability (P|ATSU|REMOTE-GOV))
        (compose-capability (P|ATSU|CALLER))
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|ATSC_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        (let
            (
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|TFT:module{OuronetPolicy} TFT)
            )
            (ref-P|DPTF::P|A_Add
                "ATSU|Caller"
                (create-capability-guard (P|ATSU|CALLER))
            )
            (ref-P|DPMF::P|A_Add
                "ATSU|Caller"
                (create-capability-guard (P|ATSU|CALLER))
            )
            (ref-P|ATS::P|A_Add
                "ATSU|RemoteAtsGov"
                (create-capability-guard (P|ATSU|REMOTE-GOV))
            )
            (ref-P|ATS::P|A_Add
                "ATSU|Caller"
                (create-capability-guard (P|ATSU|CALLER))
            )
            (ref-P|ATS::P|A_Add
                "ATSU|UpdateROU"
                (create-capability-guard (P|ATSU|UPDATE_ROU))
            )
            (ref-P|TFT::P|A_Add
                "ATSU|Caller"
                (create-capability-guard (P|ATSU|CALLER))
            )
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{C1}
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap ATSC|C>COLD_REC (recoverer:string ats:string ra:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership recoverer)
            (ref-ATS::UEV_RecoveryState ats true true)
            (compose-capability (P|TT))
            (compose-capability (ATSC|C>DEPLOY ats recoverer))
        )
    )
    (defcap ATSC|C>CULL (culler:string ats:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership culler)
            (ref-ATS::UEV_id ats)
            (compose-capability (P|TT))
            (compose-capability (ATSC|C>NORM_LEDGER ats culler))
        )
    )
    (defcap ATSC|C>DEPLOY (ats:string acc:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
            )
            (ref-DALOS::UEV_EnforceAccountExists acc)
            (ref-ATS::UEV_id ats)
            (compose-capability (ATSC|C>NORM_LEDGER ats acc))
        )
    )
    (defcap ATSC|C>NORM_LEDGER (ats:string acc:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
                (dalos-admin:guard GOV|MD_ATSU)
                (autos-admin:guard GOV|SC_ATSU)
                (acc-g:guard (ref-DALOS::UR_AccountGuard acc))
                (sov:string (ref-DALOS::UR_AccountSovereign acc))
                (sov-g:guard (ref-DALOS::UR_AccountGuard sov))
                (gov-g:guard (ref-DALOS::UR_AccountGovernor acc))
            )
            (ref-ATS::UEV_id ats)
            (enforce-one
                "Invalid permission for normalizing ATS|Ledger Account Operations"
                [
                    (enforce-guard dalos-admin)
                    (enforce-guard autos-admin)
                    (enforce-guard acc-g)
                    (enforce-guard sov-g)
                    (enforce-guard gov-g)
                ]
            )
            (compose-capability (P|ATSU|CALLER))
        )
    )
    (defcap ATSH|C>HOT_REC (recoverer:string ats:string ra:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership recoverer)
            (ref-ATS::UEV_id ats)
            (ref-ATS::UEV_RecoveryState ats true false)
            (compose-capability (P|DT2))
        )
    )
    (defcap ATSH|C>REDEEM (redeemer:string id:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (iz-rbt:bool (ref-DPMF::URC_IzRBT id))
            )
            (ref-DALOS::UEV_EnforceAccountType redeemer false)
            (ref-DPMF::UEV_id id)
            (enforce iz-rbt "Invalid Hot-RBT")
            (compose-capability (P|TT))
        )
    )
    (defcap ATSH|C>RECOVER (recoverer:string id:string nonce:integer amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (iz-rbt:bool (ref-DPMF::URC_IzRBT id))
                (nonce-max-amount:decimal (ref-DPMF::UR_AccountBatchSupply id nonce recoverer))
            )
            (ref-DALOS::UEV_EnforceAccountType recoverer false)
            (ref-DPMF::UEV_id id)
            (enforce iz-rbt "Invalid Hot-RBT")
            (enforce (>= nonce-max-amount amount) "Recovery Amount surpasses Batch Balance")
            (compose-capability (P|DT2))
        )
    )
    (defcap ATSU|C>RM_SCND (ats:string reward-token:string)
        @event
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (ref-ATS::CAP_Owner ats)
            (ref-ATS::UEV_UpdateColdAndHot ats)
            (ref-ATS::UEV_ParameterLockState ats false)
            (let
                (
                    (rt-position:integer (ref-ATS::URC_RewardTokenPosition ats reward-token))
                )
                (enforce (> rt-position 0) "Primal RT cannot be removed")
            )
            (compose-capability (P|TT))
        )
    )
    (defcap ATSU|C>COIL_OR_CURL (ats:string coil-token:string)
        @event
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (ref-ATS::UEV_RewardTokenExistance ats coil-token true)
            (compose-capability (P|DT1))
        )
    )
    (defcap ATSF|C>FUEL (atspair:string reward-token:string)
        @event
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (index:decimal (ref-ATS::URC_Index atspair))
            )
            (ref-ATS::UEV_RewardTokenExistance atspair reward-token true)
            (enforce (>= index 0.1) "Fueling cannot take place on a negative Index")
            (compose-capability (P|DT1))
        )
    )
    (defcap ATSU|C>SYPHON (ats:string syphon-amounts:[decimal])
        @event
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-U|LST:module{StringProcessor} U|LST)
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                (l0:integer (length syphon-amounts))
                (l1:integer (length rt-lst))
                (max-syphon:[decimal] (ref-ATS::URC_MaxSyphon ats))
                (max-syphon-sum:decimal (fold (+) 0.0 max-syphon))
                (input-syphon-sum:decimal (fold (+) 0.0 syphon-amounts))

                (resident-amounts:[decimal] (ref-ATS::UR_RoUAmountList ats true))
                (supply-check:[bool] (zip (lambda (x:decimal y:decimal) (<= x y)) syphon-amounts resident-amounts))
                (tr-nr:integer (length (ref-U|LST::UC_Search supply-check true)))
            )
            (ref-ATS::CAP_Owner ats)
            (ref-ATS::UEV_SyphoningState ats true)
            (enforce (= l0 l1) "Invalid Amounts of Syphon Values")
            (enforce (> input-syphon-sum 0.0) "Invalid Syphon Amounts")
            (map
                (lambda
                    (sv:decimal)
                    (enforce (>= sv 0.0) "Unallowed Negative Syphon Values Detected !")
                )
                syphon-amounts
            )
            (enforce (<= input-syphon-sum max-syphon-sum) "Syphon Amounts surpassing pairs Syphon-Index")
            (enforce (= l0 tr-nr) "Invalid syphon amounts surpassing present resident Amounts")
            (compose-capability (P|TT))
        )
    )
    (defcap ATSU|C>KICKSTART (kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
                (index:decimal (ref-ATS::URC_Index ats))
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                (l1:integer (length rt-amounts))
                (l2:integer (length rt-lst))
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (ref-ATS::UR_OwnerKonto ats))
            (ref-DALOS::UEV_EnforceAccountType kickstarter false)
            (enforce (= index -1.0) "Kickstarting can only be done on ATS-Pairs with -1 Index")
            (enforce (= l1 l2) "RT-Amounts list does not correspond with the Number of the ATS-Pair Reward Tokens")
            (enforce (> rbt-request-amount 0.0) "RBT Request Amount must be greater than zero!")
            (compose-capability (P|TT))
        )
    )
    ;;
    ;;{F0}
    ;;{F1}
    ;;{F2}
    ;;{F3}
    ;;{F4}
    ;;
    ;;{F5}
    ;;{F6}
    (defun C_ColdRecovery (patron:string recoverer:string ats:string ra:decimal)
        @doc "Recovers Cold-RBT, disolving it, generating cullable RTs in the future."
        (with-capability (ATSC|C>COLD_REC recoverer ats ra)
            (X_DeployAccount ats recoverer)
            (let
                (
                    (ref-U|ATS:module{UtilityAts} U|ATS)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-ATS:module{Autostake} ATS)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                    (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                    (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                    (c-rbt-precision:integer (ref-DPTF::UR_Decimals c-rbt))
                    (usable-position:integer (ref-ATS::URC_WhichPosition ats ra recoverer))
                    (fee-promile:decimal (ref-ATS::URC_ColdRecoveryFee ats ra usable-position))
                    (c-rbt-fee-split:[decimal] (ref-U|ATS::UC_PromilleSplit fee-promile ra c-rbt-precision))
                    (c-fr:bool (ref-ATS::UR_ColdRecoveryFeeRedirection ats))
                    (cull-time:time (ref-ATS::URC_CullColdRecoveryTime ats recoverer))
                    ;;for false
                    (ng-c-fr:[decimal] (ref-ATS::URC_RTSplitAmounts ats (at 1 c-rbt-fee-split)))            ;;fee
                    ;;for true
                    (positive-c-fr:[decimal] (ref-ATS::URC_RTSplitAmounts ats (at 0 c-rbt-fee-split)))      ;;remainder
                )
                (ref-TFT::C_Transfer patron c-rbt recoverer ats-sc ra true)
                (ref-DPTF::C_Burn patron c-rbt ats-sc ra)
                (map
                    (lambda
                        (index:integer)
                        (ref-ATS::X_UpdateRoU ats (at index rt-lst) false true (at index positive-c-fr))
                        (ref-ATS::X_UpdateRoU ats (at index rt-lst) true false (at index positive-c-fr))
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
                (if (not c-fr)
                    (map
                        (lambda
                            (index:integer)
                            (ref-DPTF::C_Burn patron (at index rt-lst) ats-sc (at index ng-c-fr))
                        )
                        (enumerate 0 (- (length rt-lst) 1))
                    )
                    true
                )
                (X_StoreUnstakeObject ats recoverer usable-position 
                    { "reward-tokens"   : positive-c-fr 
                    , "cull-time"       : cull-time}
                )
            )
            (X_Normalize ats recoverer)
        )
    )
    (defun C_Cull:[decimal] (patron:string culler:string ats:string)
        @doc "Culls an ATSPair, extracting RTs that are cullable"
        (with-capability (ATSC|C>CULL culler ats)
            (let
                (
                    (ref-U|DEC:module{OuronetDecimals} U|DEC)
                    (ref-ATS:module{Autostake} ATS)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                    (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                    (c0:[decimal] (X_MultiCull ats culler))
                    (c1:[decimal] (X_SingleCull ats culler 1))
                    (c2:[decimal] (X_SingleCull ats culler 2))
                    (c3:[decimal] (X_SingleCull ats culler 3))
                    (c4:[decimal] (X_SingleCull ats culler 4))
                    (c5:[decimal] (X_SingleCull ats culler 5))
                    (c6:[decimal] (X_SingleCull ats culler 6))
                    (c7:[decimal] (X_SingleCull ats culler 7))
                    (ca:[[decimal]] [c0 c1 c2 c3 c4 c5 c6 c7])
                    (cw:[decimal] (ref-U|DEC::UC_AddHybridArray ca))
                )
                (map
                    (lambda
                        (idx:integer)
                        (if (!= (at idx cw) 0.0)
                            (do
                                (ref-ATS::X_UpdateRoU ats (at idx rt-lst) false false (at idx cw))
                                (ref-TFT::C_Transfer patron (at idx rt-lst) ats-sc culler (at idx cw) true)
                            )
                            true
                        )
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
                (X_Normalize ats culler)
                cw
            )
        )
    )
    (defun C_HotRecovery (patron:string recoverer:string ats:string ra:decimal)
        @doc "Converts a Cold-RBT to a Hot-RBT, preparing it for Hot Recovery"
        (with-capability (ATSH|C>HOT_REC recoverer ats ra)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (ref-ATS:module{Autostake} ATS)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))

                    (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                    (h-rbt:string (ref-ATS::UR_HotRewardBearingToken ats))
                    (present-time:time (at "block-time" (chain-data)))
                    (meta-data-obj:object{Autostake.ATS|Hot} { "mint-time" : present-time})
                    (meta-data:[object] [meta-data-obj])
                    (new-nonce:integer (+ (ref-DPMF::UR_NoncesUsed h-rbt) 1))
                )
                (ref-TFT::C_Transfer patron c-rbt recoverer ats-sc ra true)
                (ref-DPTF::C_Burn patron c-rbt ats-sc ra)
                (ref-DPMF::C_Mint patron h-rbt ats-sc ra meta-data)
                (ref-DPMF::C_Transfer patron h-rbt new-nonce ats-sc recoverer ra true)
            )
        )
    )
    (defun C_Redeem (patron:string redeemer:string id:string nonce:integer)
        @doc "Redeems a Hot-RBT, recovering RTs"
        (with-capability (ATSH|C>REDEEM redeemer id)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (ref-ATS:module{Autostake} ATS)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))

                    (precision:integer (ref-DPMF::UR_Decimals id))
                    (current-nonce-balance:decimal (ref-DPMF::UR_AccountBatchSupply id nonce redeemer))
                    (meta-data (ref-DPMF::UR_AccountBatchMetaData id nonce redeemer))

                    (birth-date:time (at "mint-time" (at 0 meta-data)))
                    (present-time:time (at "block-time" (chain-data)))
                    (elapsed-time:decimal (diff-time present-time birth-date))

                    (ats:string (ref-DPMF::UR_RewardBearingToken id))
                    (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                    (h-promile:decimal (ref-ATS::UR_HotRecoveryStartingFeePromile ats))
                    (h-decay:integer (ref-ATS::UR_HotRecoveryDecayPeriod ats))
                    (h-fr:bool (ref-ATS::UR_HotRecoveryFeeRedirection ats))

                    (total-time:decimal (* 86400.0 (dec h-decay)))
                    (end-time:time (add-time birth-date (hours (* 24 h-decay))))
                    (earned-rbt:decimal
                        (if (>= elapsed-time total-time)
                            current-nonce-balance
                            (floor (* current-nonce-balance (/ (- 1000.0 (* h-promile (- 1.0 (/ elapsed-time total-time)))) 1000.0)) precision)
                        )
                    )
                    (total-rts:[decimal] (ref-ATS::URC_RTSplitAmounts ats current-nonce-balance))
                    (earned-rts:[decimal] (ref-ATS::URC_RTSplitAmounts ats earned-rbt))
                    (fee-rts:[decimal] (zip (lambda (x:decimal y:decimal) (- x y)) total-rts earned-rts))
                )
                (ref-DPMF::C_Transfer patron id nonce redeemer ats-sc current-nonce-balance true)
                (ref-DPMF::C_Burn patron id nonce ats-sc current-nonce-balance)

                (ref-TFT::C_MultiTransfer patron rt-lst ats-sc redeemer earned-rts true)
                (map
                    (lambda
                        (index:integer)
                        (ref-ATS::X_UpdateRoU ats (at index rt-lst) true false (at index earned-rts))
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
                (if (and (not h-fr) (!= earned-rbt current-nonce-balance))
                    (map
                        (lambda
                            (index:integer)
                            (do
                                (ref-DPTF::C_Burn patron (at index rt-lst) ats-sc (at index fee-rts))
                                (ref-ATS::X_UpdateRoU ats (at index rt-lst) true false (at index fee-rts))
                            )
                        )
                        (enumerate 0 (- (length rt-lst) 1))
                    )
                    true
                )
            )
        )
    )
    (defun C_RecoverWholeRBTBatch (patron:string recoverer:string id:string nonce:integer)
        @doc "Recovers a Hot-RBT, converting back to Cold-RBT, using the whole DPMF nonce amount"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (C_RecoverHotRBT patron recoverer id nonce (ref-DPMF::UR_AccountBatchSupply id nonce recoverer))
        )
    )
    (defun C_RecoverHotRBT (patron:string recoverer:string id:string nonce:integer amount:decimal)
        @doc "Recovers a Hot-RBT, converting back to Cold-RBT, using an amount smaller than or equal to DPMF Nonce amount"
        (with-capability (ATSH|C>RECOVER recoverer id nonce amount)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (ref-ATS:module{Autostake} ATS)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                    (ats:string (ref-DPMF::UR_RewardBearingToken id))
                    (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                )
                (ref-DPMF::C_Transfer patron id nonce recoverer ats-sc amount true)
                (ref-DPMF::C_Burn patron id nonce ats-sc amount)
                (ref-DPTF::C_Mint patron c-rbt ats-sc amount false)
                (ref-TFT::C_Transfer patron c-rbt ats-sc recoverer amount true)
            )
        )
    )
    (defun C_RotateOwnership (patron:string ats:string new-owner:string)
        @doc "Rotates ATSPair Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::X_ChangeOwnership ats new-owner)
                (ref-DALOS::IGNIS|C_Collect patron (ref-ATS::UR_OwnerKonto ats) (ref-DALOS::UR_UsagePrice "ignis|biggest"))
            )
        )
    )
    (defun C_ModifyCanChangeOwner (patron:string ats:string new-boolean:bool)
        @doc "Modifies <can-change-owner> for the ATSPair"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::X_ModifyCanChangeOwner ats new-boolean)
                (ref-DALOS::IGNIS|C_Collect patron (ref-ATS::UR_OwnerKonto ats) (ref-DALOS::UR_UsagePrice "ignis|biggest"))
            )
        )
    )
    (defun C_ToggleParameterLock (patron:string ats:string toggle:bool)
        @doc "Toggle ATSPair Parameter Lock"
        (enforce-guard (P|UR "TALOS|Summoner"))
        (with-capability (P|ATSU|CALLER)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-ATS:module{Autostake} ATS)
                    (ats-owner:string (ref-ATS::UR_OwnerKonto ats))
                    (g1:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                    (toggle-costs:[decimal] (ref-ATS::X_ToggleParameterLock ats toggle))
                    (g2:decimal (at 0 toggle-costs))
                    (gas-costs:decimal (+ g1 g2))
                    (kda-costs:decimal (at 1 toggle-costs))
                )
                (ref-DALOS::IGNIS|C_Collect patron ats-owner gas-costs)
                (if (> kda-costs 0.0)
                    (do
                        (ref-ATS::X_IncrementParameterUnlocks ats)
                        (ref-DALOS::KDA|C_Collect patron kda-costs)
                    )
                    true
                )
            )
        )
    )
    (defun C_UpdateSyphon (patron:string ats:string syphon:decimal)
        @doc "Updates Syphone Value, representing the Decimal Index, until ATSPair can be syphoned"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::X_UpdateSyphon ats syphon)
                (ref-DALOS::IGNIS|C_Collect patron (ref-ATS::UR_OwnerKonto ats) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_ToggleSyphoning (patron:string ats:string toggle:bool)
        @doc "Toggles ATSPair syphoning capability"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::X_ToggleSyphoning ats toggle)
                (ref-DALOS::IGNIS|C_Collect patron (ref-ATS::UR_OwnerKonto ats) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_SetCRD (patron:string ats:string soft-or-hard:bool base:integer growth:integer)
        @doc "Sets ATSPair Cold Recovery Duration"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::X_SetCRD ats soft-or-hard base growth)
                (ref-DALOS::IGNIS|C_Collect patron (ref-ATS::UR_OwnerKonto ats) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        ) 
    )
    (defun C_SetColdFee (patron:string ats:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        @doc "Sets ATSPair Cold Recovery Fee"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::X_SetColdFee ats fee-positions fee-thresholds fee-array)
                (ref-DALOS::IGNIS|C_Collect patron (ref-ATS::UR_OwnerKonto ats) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_SetHotFee (patron:string ats:string promile:decimal decay:integer)
        @doc "Sets ATSPair Hot Recovery Fee"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::X_SetHotFee ats promile decay)
                (ref-DALOS::IGNIS|C_Collect patron (ref-ATS::UR_OwnerKonto ats) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_ToggleElite (patron:string ats:string toggle:bool)
        @doc "Toggles ATSPair Elite Functionality"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::X_ToggleElite ats toggle)
                (ref-DALOS::IGNIS|C_Collect patron (ref-ATS::UR_OwnerKonto ats) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_TurnRecoveryOn (patron:string ats:string cold-or-hot:bool)
        @doc "Turns ATSPair Cold or Hot Recovery On"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::X_TurnRecoveryOn ats cold-or-hot)
                (ref-ATS::XC_EnsureActivationRoles patron ats cold-or-hot)
                (ref-DALOS::IGNIS|C_Collect patron (ref-ATS::UR_OwnerKonto ats) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_AddSecondary (patron:string ats:string reward-token:string rt-nfr:bool)
        @doc "Adds a Secondary RT to an ATSPair"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-ATS:module{Autostake} ATS)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
            )
            (with-capability (P|ATSU|CALLER)
                (ref-DPTF::C_DeployAccount reward-token ats-sc)
                (ref-ATS::|X_AddSecondary ats reward-token rt-nfr)
                (ref-DPTF::X_UpdateRewardToken ats reward-token true)
                (ref-ATS::XC_EnsureActivationRoles patron ats true)
                (if (ref-ATS::URC_IzPresentHotRBT ats)
                    (ref-ATS::XC_EnsureActivationRoles patron ats false)
                    true
                )
                (ref-DALOS::IGNIS|C_Collect patron (ref-ATS::UR_OwnerKonto ats) (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
            )
        )
    )
    (defun C_RemoveSecondary (patron:string remover:string ats:string reward-token:string)
        @doc "Removes a Secondary RT from an ATSPair. Only secondary RTs that were added after ATSPair creation can be removed. \
        \ Removing an RT this way must be done by adding the primary RT back into the Pool."
        (with-capability (ATSU|C>RM_SCND ats reward-token)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-ATS:module{Autostake} ATS)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))

                    (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                    (remove-position:integer (at 0 (ref-U|LST::UC_Search rt-lst reward-token)))
                    (primal-rt:string (at 0 rt-lst))
                    (resident-sum:decimal (at remove-position (ref-ATS::UR_RoUAmountList ats true)))
                    (unbound-sum:decimal (at remove-position (ref-ATS::UR_RoUAmountList ats false)))
                    (remove-sum:decimal (+ resident-sum unbound-sum))
                    (accounts-with-ats-data:[string] (ref-TFT::DPTF-DPMF-ATS|UR_FilterKeysForInfo ats 3 false))
                )
            ;;1]The RT to be removed, is transfered to the remover, from the ATS|SC_NAME
                (ref-TFT::C_Transfer patron reward-token ats-sc remover remove-sum true)
            ;;2]The amount removed is added back as Primal-RT
                (ref-TFT::C_Transfer patron primal-rt remover ats-sc remove-sum true)
            ;;3]ROU Table is updated with the new DATA, now as primal RT
                (ref-ATS::X_UpdateRoU ats primal-rt true true resident-sum)
                (ref-ATS::X_UpdateRoU ats primal-rt false true unbound-sum)
            ;;4]Client Accounts are modified to remove the RT Token and update balances with Primal RT
                (map
                    (lambda
                        (kontos:string)
                        (ref-ATS::X_ReshapeUnstakeAccount ats kontos remove-position)
                    )
                    accounts-with-ats-data
                )
            ;;5]Actually Remove the RT from the ATS-Pair
                (ref-ATS::X_RemoveSecondary ats reward-token)
            ;;6]Update Data in the DPTF Token Properties
                (ref-DPTF::X_UpdateRewardToken ats reward-token false)
            )
        )
    )
    (defun C_AddHotRBT (patron:string ats:string hot-rbt:string)
        @doc "Adds a Hot-RBT to an ATS-Pair. A Hot-RBT must be a DPMF Token and cannot be a Vested counterpart of a DPTF Token"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ref-ATS:module{Autostake} ATS)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
            )
            (with-capability (P|ATSU|CALLER)
                (ref-DPMF::C_DeployAccount hot-rbt ats-sc)
                (ref-DPMF::X_UpdateRewardBearingToken ats hot-rbt)
                (ref-ATS::X_AddHotRBT ats hot-rbt)
                (ref-ATS::XC_EnsureActivationRoles patron ats false)
                (ref-DALOS::IGNIS|C_Collect patron (ref-ATS::UR_OwnerKonto ats) (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
            )
        )
    )
    (defun C_Fuel (patron:string fueler:string atspair:string reward-token:string amount:decimal)
        @doc "Fuels an ATSPair with RT Tokens, increasing its Index"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-TFT:module{TrueFungibleTransfer} TFT)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
            )
            (with-capability (ATSF|C>FUEL atspair reward-token)
                (ref-TFT::C_Transfer patron reward-token fueler ats-sc amount true)
                (ref-ATS::X_UpdateRoU atspair reward-token true true amount)
            )
        )
    )
    (defun C_Syphon (patron:string syphon-target:string ats:string syphon-amounts:[decimal])
        @doc "Syphons from an ATS Pair, extracting RTs and decreasing ATSPair Index. \
            \ Syphoning can be executed until the set up Syphon limit is achieved"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
                (ref-TFT:module{TrueFungibleTransfer} TFT)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
            )
            (with-capability (ATSU|C>SYPHON ats syphon-amounts)
                (map
                    (lambda
                        (index:integer)
                        (if (> (at index syphon-amounts) 0.0)
                            (do
                                (ref-TFT::C_Transfer patron (at index rt-lst) ats-sc syphon-target (at index syphon-amounts) true)
                                (ref-ATS::X_UpdateRoU ats (at index rt-lst) true false (at index syphon-amounts))
                            )
                            true
                        )
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
            )
        )
    )
    (defun C_KickStart:decimal (patron:string kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal)
        @doc "Kickstarst an ATSPair, so that it starts at a given Index \
        \ Can only be done on a freshly created ATSPair"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-TFT:module{TrueFungibleTransfer} TFT)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                (rbt-id:string (ref-ATS::UR_ColdRewardBearingToken ats))
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
            )
            (with-capability (ATSU|C>KICKSTART kickstarter ats rt-amounts rbt-request-amount)
                (map
                    (lambda
                        (index:integer)
                        (do
                            (ref-TFT::C_Transfer patron (at index rt-lst) kickstarter ats-sc (at index rt-amounts) true)
                            (ref-ATS::X_UpdateRoU ats (at index rt-lst) true true (at index rt-amounts))
                        )
                        
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
                (ref-DPTF::C_Mint patron rbt-id ats-sc rbt-request-amount false)
                (ref-TFT::C_Transfer patron rbt-id ats-sc kickstarter rbt-request-amount true)
                (ref-ATS::URC_Index ats)
            )
        )
    )
    (defun C_Coil:decimal (patron:string coiler:string ats:string rt:string amount:decimal)
        @doc "Coils an RT Token from a specific ATSPair, generating a RBT Token"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-TFT:module{TrueFungibleTransfer} TFT)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                (c-rbt-amount:decimal (ref-ATS::URC_RBT ats rt amount))
            )
            (with-capability (ATSU|C>COIL_OR_CURL ats rt)
                (ref-TFT::C_Transfer patron rt coiler ats-sc amount true)
                (ref-ATS::X_UpdateRoU ats rt true true amount)
                (ref-DPTF::C_Mint patron c-rbt ats-sc c-rbt-amount false)
                (ref-TFT::C_Transfer patron c-rbt ats-sc coiler c-rbt-amount true)
                c-rbt-amount
            )
        )
    )
    (defun C_Curl:decimal (patron:string curler:string ats1:string ats2:string rt:string amount:decimal)
        @doc "Curls an RT Token from a specific ATSPair, and the subsequent generated RBT Token, is curled again in a second ATSPair, \
        \ outputing the RBT in from this second ATSPair. Works only if the RBT in the first ATSPair is RT in the second ATSPair"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-TFT:module{TrueFungibleTransfer} TFT)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                (c-rbt1:string (ref-ATS::UR_ColdRewardBearingToken ats1))
                (c-rbt1-amount:decimal (ref-ATS::URC_RBT ats1 rt amount))
                (c-rbt2:string (ref-ATS::UR_ColdRewardBearingToken ats2))
                (c-rbt2-amount:decimal (ref-ATS::URC_RBT ats2 c-rbt1 c-rbt1-amount))
            )
            (with-capability (ATSU|C>COIL_OR_CURL ats1 rt)
                (ref-TFT::C_Transfer patron rt curler ats-sc amount true)
                (ref-ATS::X_UpdateRoU ats1 rt true true amount)
                (ref-DPTF::C_Mint patron c-rbt1 ats-sc c-rbt1-amount false)
                (ref-ATS::X_UpdateRoU ats2 c-rbt1 true true c-rbt1-amount)
                (ref-DPTF::C_Mint patron c-rbt2 ats-sc c-rbt2-amount false)
                (ref-TFT::C_Transfer patron c-rbt2 ats-sc curler c-rbt2-amount true)
                c-rbt2-amount
            )
        )
    )
    ;;{F7}
    (defun X_MultiCull:[decimal] (ats:string acc:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|DEC:module{OuronetDecimals} U|DEC)
                (ref-ATS:module{Autostake} ATS)
                (zr:object{UtilityAts.Awo} (ref-ATS::UDC_MakeZeroUnstakeObject ats))
                (ng:object{UtilityAts.Awo} (ref-ATS::UDC_MakeNegativeUnstakeObject ats))
                (p0:[object{UtilityAts.Awo}] (ref-ATS::UR_P0 ats acc))
                (p0l:integer (length p0))
                (boolean-lst:[bool]
                    (fold
                        (lambda
                            (acc:[bool] item:object{UtilityAts.Awo})
                            (ref-U|LST::UC_AppL acc (ref-ATS::UC_IzCullable item))
                        )
                        []
                        p0
                    )
                )
                (zr-output:[decimal] (make-list (length (ref-ATS::UR_RewardTokens ats)) 0.0))
                (cullables:[integer] (ref-U|LST::UC_Search boolean-lst true))
                (immutables:[integer] (ref-U|LST::UC_Search boolean-lst false))
                (how-many-cullables:integer (length cullables))
            )
            (if (= how-many-cullables 0)
                zr-output
                (let
                    (
                        (after-cull:[object{UtilityAts.Awo}]
                            (if (< how-many-cullables p0l)
                                (fold
                                    (lambda
                                        (acc:[object{UtilityAts.Awo}] idx:integer)
                                        (ref-U|LST::UC_AppL acc (at (at idx immutables) p0))
                                    )
                                    []
                                    (enumerate 0 (- (length immutables) 1))
                                )
                                [zr]
                            )
                        )
                        (to-be-culled:[object{UtilityAts.Awo}]
                            (fold
                                (lambda
                                    (acc:[object{UtilityAts.Awo}] idx:integer)
                                    (ref-U|LST::UC_AppL acc (at (at idx cullables) p0))
                                )
                                []
                                (enumerate 0 (- (length cullables) 1))
                            )
                        )
                        (culled-values:[[decimal]]
                            (fold
                                (lambda
                                    (acc:[[decimal]] idx:integer)
                                    (ref-U|LST::UC_AppL acc (ref-ATS::URC_CullValue ats (at idx to-be-culled)))
                                )
                                []
                                (enumerate 0 (- (length to-be-culled) 1))
                            )
                        )
                        (summed-culled-values:[decimal] (ref-U|DEC::UC_AddHybridArray culled-values))
                    )
                    (ref-ATS::X_UpP0 ats acc after-cull)
                    summed-culled-values
                )
            )
        )
    )
    (defun X_SingleCull:[decimal] (ats:string acc:string position:integer)
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                (l:integer (length rt-lst))
                (empty:[decimal] (make-list l 0.0))
                (zr:object{UtilityAts.Awo} (ref-ATS::UDC_MakeZeroUnstakeObject ats))
                (unstake-obj:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc position))
                (rt-amounts:[decimal] (at "reward-tokens" unstake-obj))
                (cull-output:[decimal] (ref-ATS::URC_CullValue ats unstake-obj))
            )
            (if (!= cull-output empty)
                (X_StoreUnstakeObject ats acc position zr)
                true
            )
            cull-output
        )
    )
    (defun X_StoreUnstakeObject (ats:string acc:string position:integer obj:object{UtilityAts.Awo})
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-ATS:module{Autostake} ATS)
                (p0:[object{UtilityAts.Awo}] (ref-ATS::UR_P0 ats acc))
            )
            (if (= position -1)
                (if (and 
                        (= (length p0) 1)
                        (= 
                            (at 0 p0) 
                            (ref-ATS::UDC_MakeZeroUnstakeObject ats)
                        )
                    )
                    (ref-ATS::X_UpP0 ats acc [obj])
                    (ref-ATS::X_UpP0 ats acc (ref-U|LST::UC_AppL p0 obj))
                )
                (cond
                    ((= position 1) (ref-ATS::X_UpP1 ats acc obj))
                    ((= position 2) (ref-ATS::X_UpP2 ats acc obj))
                    ((= position 3) (ref-ATS::X_UpP3 ats acc obj))
                    ((= position 4) (ref-ATS::X_UpP4 ats acc obj))
                    ((= position 5) (ref-ATS::X_UpP5 ats acc obj))
                    ((= position 6) (ref-ATS::X_UpP6 ats acc obj))
                    ((= position 7) (ref-ATS::X_UpP7 ats acc obj))
                    true
                )
            )
        )
    )
    (defun X_DeployAccount (ats:string acc:string)
        (require-capability (ATSC|C>DEPLOY ats acc))
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (ref-ATS::X_SpawnAutostakeAccount ats acc)
            (X_Normalize ats acc)
        )
    )
    (defun X_Normalize (ats:string acc:string)
        (require-capability (ATSC|C>NORM_LEDGER ats acc))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
                (p0:[object{UtilityAts.Awo}] (ref-ATS::UR_P0 ats acc))
                (p1:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc 1))
                (p2:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc 2))
                (p3:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc 3))
                (p4:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc 4))
                (p5:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc 5))
                (p6:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc 6))
                (p7:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc 7))
                (zr:object{UtilityAts.Awo} (ref-ATS::UDC_MakeZeroUnstakeObject ats))
                (ng:object{UtilityAts.Awo} (ref-ATS::UDC_MakeNegativeUnstakeObject ats))
                (positions:integer (ref-ATS::UR_ColdRecoveryPositions ats))
                (elite:bool (ref-ATS::UR_EliteMode ats))
                (major-tier:integer (ref-DALOS::UR_Elite-Tier-Major acc))
                (p0-znn:[object{UtilityAts.Awo}] (if (and (!= p0 [zr]) (!= p0 [ng])) p0 [ng]))
                (p0-znz:[object{UtilityAts.Awo}] (if (and (!= p0 [zr]) (!= p0 [ng])) p0 [zr]))
                (p1-znn:object{UtilityAts.Awo} (if (and (!= p1 zr) (!= p1 ng)) p1 ng))
                (p1-znz:object{UtilityAts.Awo} (if (and (!= p1 zr) (!= p1 ng)) p1 zr))
                (p2-znn:object{UtilityAts.Awo} (if (and (!= p2 zr) (!= p2 ng)) p2 ng))
                (p2-znz:object{UtilityAts.Awo} (if (and (!= p2 zr) (!= p2 ng)) p2 zr))
                (p3-znn:object{UtilityAts.Awo} (if (and (!= p3 zr) (!= p3 ng)) p3 ng))
                (p3-znz:object{UtilityAts.Awo} (if (and (!= p3 zr) (!= p3 ng)) p3 zr))
                (p4-znn:object{UtilityAts.Awo} (if (and (!= p4 zr) (!= p4 ng)) p4 ng))
                (p4-znz:object{UtilityAts.Awo} (if (and (!= p4 zr) (!= p4 ng)) p4 zr))
                (p5-znn:object{UtilityAts.Awo} (if (and (!= p5 zr) (!= p5 ng)) p5 ng))
                (p5-znz:object{UtilityAts.Awo} (if (and (!= p5 zr) (!= p5 ng)) p5 zr))
                (p6-znn:object{UtilityAts.Awo} (if (and (!= p6 zr) (!= p6 ng)) p6 ng))
                (p6-znz:object{UtilityAts.Awo} (if (and (!= p6 zr) (!= p6 ng)) p6 zr))
                (p7-znn:object{UtilityAts.Awo} (if (and (!= p7 zr) (!= p7 ng)) p7 ng))
                (p7-znz:object{UtilityAts.Awo} (if (and (!= p7 zr) (!= p7 ng)) p7 zr))
                (p2-zne:object{UtilityAts.Awo} (if (and (!= p2 zr) (!= p2 ng)) p2 (if (>= major-tier 2) zr ng)))
                (p3-zne:object{UtilityAts.Awo} (if (and (!= p3 zr) (!= p3 ng)) p3 (if (>= major-tier 3) zr ng)))
                (p4-zne:object{UtilityAts.Awo} (if (and (!= p4 zr) (!= p4 ng)) p4 (if (>= major-tier 4) zr ng)))
                (p5-zne:object{UtilityAts.Awo} (if (and (!= p5 zr) (!= p5 ng)) p5 (if (>= major-tier 5) zr ng)))
                (p6-zne:object{UtilityAts.Awo} (if (and (!= p6 zr) (!= p6 ng)) p6 (if (>= major-tier 6) zr ng)))
                (p7-zne:object{UtilityAts.Awo} (if (and (!= p7 zr) (!= p7 ng)) p7 (if (>= major-tier 7) zr ng)))
            )
            (cond
                ((= positions -1) (X_UUP ats acc [p0-znz p1-znn p2-znn p3-znn p4-znn p5-znn p6-znn p7-znn]))
                ((= positions 1) (X_UUP ats acc [p0-znn p1-znz p2-znn p3-znn p4-znn p5-znn p6-znn p7-znn]))
                ((= positions 2) (X_UUP ats acc [p0-znn p1-znz p2-znz p3-znn p4-znn p5-znn p6-znn p7-znn]))
                ((= positions 3) (X_UUP ats acc [p0-znn p1-znz p2-znz p3-znz p4-znn p5-znn p6-znn p7-znn]))
                ((= positions 4) (X_UUP ats acc [p0-znn p1-znz p2-znz p3-znz p4-znz p5-znn p6-znn p7-znn]))
                ((= positions 5) (X_UUP ats acc [p0-znn p1-znz p2-znz p3-znz p4-znz p5-znz p6-znn p7-znn]))
                ((= positions 6) (X_UUP ats acc [p0-znn p1-znz p2-znz p3-znz p4-znz p5-znz p6-znz p7-znn]))
                ((not elite) (X_UUP ats acc [p0-znn p1-znz p2-znz p3-znz p4-znz p5-znz p6-znz p7-znz]))
                (elite (X_UUP ats acc [p0-znn p1-znz p2-zne p3-zne p4-zne p5-zne p6-zne p7-zne]))
                true
            )
        )
    )
    (defun X_UUP (ats:string acc:string data:[object{UtilityAts.Awo}])
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (enforce (= (length data) 8) "Invalid Data Length")
            (ref-ATS::X_UpP0 ats acc (at 0 data))
            (ref-ATS::X_UpP1 ats acc (at 1 data))
            (ref-ATS::X_UpP2 ats acc (at 2 data))
            (ref-ATS::X_UpP3 ats acc (at 3 data))
            (ref-ATS::X_UpP4 ats acc (at 4 data))
            (ref-ATS::X_UpP5 ats acc (at 5 data))
            (ref-ATS::X_UpP6 ats acc (at 6 data))
            (ref-ATS::X_UpP7 ats acc (at 7 data))
        )
    )
)

(create-table P|T)