(module OUROBOROS GOVERNANCE

    (defcap GOVERNANCE ()
        (compose-capability (OUROBOROS-ADMIN))
    )
    (defcap OUROBOROS-ADMIN ()
        (enforce-guard G_OUROBOROS)
        (enforce-one
            "Vesting Admin not satisfed"
            [
                (enforce-guard DALOS.G_DALOS)
                (enforce-guard G_OUROBOROS)
            ]
        )
    )
    (defconst G_OUROBOROS (keyset-ref-guard OUROBOROS|SC_KEY))
    (defconst OUROBOROS|SC_KEY "free.DH_SC_Ouroboros-Keyset")
    (defconst OUROBOROS|SC_NAME DALOS.OUROBOROS|SC_NAME)
    (defconst OUROBOROS|SC_KDA-NAME (create-principal OUROBOROS|GUARD))

    (use free.UTILS)
    (use free.DALOS)
    (use free.BASIS)
    (use free.AUTOSTAKE)
    (use free.LIQUID)

    (defcap COMPOSE ()
        true
    )
    (defcap SECURE ()
        true
    )
    ;;
    (defcap SUMMONER ()
        true
    )
    (defcap P|DPTF|UPDATE_RT ()
        true
    )
    (defcap P|ATS|REMOTE-GOV ()
        true
    )
    (defcap P|ATS|RESHAPE ()
        true
    )
    (defcap P|ATS|RM_SECONDARY_RT ()
        true
    )
    (defcap P|ATS|UPDATE_ROU ()
        true
    )
    ;;
    (defun OUROBOROS|DefinePolicies ()
        (DALOS.A_AddPolicy
            "OUROBOROS|Summoner"
            (create-capability-guard (SUMMONER))
        )
        (BASIS.A_AddPolicy
            "OUROBOROS|Summoner"
            (create-capability-guard (SUMMONER))
        )
        (BASIS.A_AddPolicy
            "OUROBOROS|UpdateRewardToken"
            (create-capability-guard (P|DPTF|UPDATE_RT))
        )
        (AUTOSTAKE.A_AddPolicy
            "OUROBOROS|Summoner"
            (create-capability-guard (SUMMONER))
        )
        (AUTOSTAKE.A_AddPolicy
            "OUROBOROS|RemoteAutostakeGovernor"
            (create-capability-guard (P|ATS|REMOTE-GOV))
        )
        (AUTOSTAKE.A_AddPolicy
            "OUROBOROS|ReshapeUnstakeAccount"
            (create-capability-guard (P|ATS|RESHAPE))
        )
        (AUTOSTAKE.A_AddPolicy
            "OUROBOROS|RemoveSecondaryRT"
            (create-capability-guard (P|ATS|RM_SECONDARY_RT))
        )
        (AUTOSTAKE.A_AddPolicy
            "OUROBOROS|UpdateROU"
            (create-capability-guard (P|ATS|UPDATE_ROU))
        )
    )
    ;;
    (defcap OUROBOROS|GOV ()
        @doc "Autostake Module Governor Capability for its Smart DALOS Account"
        true
    )
    (defun OUROBOROS|SetGovernor (patron:string)
        (with-capability (SUMMONER)
            (DALOS.DALOS|CO_RotateGovernor
                patron
                OUROBOROS|SC_NAME
                (create-capability-guard (OUROBOROS|GOV))
            )
        )
    )
    (defcap OUROBOROS|NATIVE-AUTOMATIC ()
        @doc "Capability needed for auto management of the <kadena-konto> associated with the Ouroboros Smart DALOS Account"
        true
    )
    (defconst OUROBOROS|GUARD (create-capability-guard (OUROBOROS|NATIVE-AUTOMATIC)))
    ;;P
    (defun A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (OUROBOROS-ADMIN)
            (write OUROB|PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun C_ReadPolicy:guard (policy-name:string)
        (at "policy" (read OUROB|PoliciesTable policy-name ["policy"]))
    )
    ;;
    (defconst NULLTIME (time "1984-10-11T11:10:00Z"))
    (defconst ANTITIME (time "1983-08-07T11:10:00Z"))
    ;;
    (defschema OUROB|PolicySchema
        policy:guard
    )
    (defschema DPTF|ID-Amount
        id:string
        amount:decimal
    )
    (defschema DPTF|Receiver-Amount
        receiver:string
        amount:decimal
    )
    (defschema VST|MetaDataSchema
        release-amount:decimal
        release-date:time
    )

    (deftable OUROB|PoliciesTable:{OUROB|PolicySchema})
    ;;
    ;;            BASIS+AUTOSTAKE   Submodule
    ;;[UEV]
    (defun DPTF-DPMF|UEV_AmountCheck:bool (id:string amount:decimal token-type:bool)
        (let*
            (
                (decimals:integer (BASIS.DPTF-DPMF|UR_Decimals id token-type))
                (decimal-check:bool (if (= (floor amount decimals) amount) true false))
                (positivity-check:bool (if (> amount 0.0) true false))
                (result:bool (and decimal-check positivity-check))
            )
            result
        )
    )
    (defun DPTF|UEV_Pair_ID-Amount:bool (id-lst:[string] transfer-amount-lst:[decimal])
        (fold
            (lambda
                (acc:bool item:object{DPTF|ID-Amount})
                (and acc (DPTF-DPMF|UEV_AmountCheck (at "id" item) (at "amount" item) true))
            )
            true
            (DPTF|UCC_Pair_ID-Amount id-lst transfer-amount-lst)
        )
    )
    (defun DPTF|UEV_Pair_Receiver-Amount:bool (id:string receiver-lst:[string] transfer-amount-lst:[decimal])
        (BASIS.DPTF-DPMF|UEV_id id true)
        (and
            (fold
                (lambda
                    (acc:bool item:object{DPTF|Receiver-Amount})
                    (let*
                        (
                            (receiver-account:string (at "receiver" item))
                            (receiver-check:bool (DALOS.GLYPH|UEV_DalosAccountCheck receiver-account))
                        )
                        (and acc receiver-check)
                    )
                )
                true
                (DPTF|UCC_Pair_Receiver-Amount receiver-lst transfer-amount-lst)
            )
            (fold
                (lambda
                    (acc:bool item:object{DPTF|Receiver-Amount})
                    (let*
                        (
                            (transfer-amount:decimal (at "amount" item))
                            (check:bool (DPTF-DPMF|UEV_AmountCheck id transfer-amount true))
                        )
                        (and acc check)
                    )
                )
                true
                (DPTF|UCC_Pair_Receiver-Amount receiver-lst transfer-amount-lst)
            )
        )
    )
    ;;[CAP]
    (defcap ATS|REDEEM (redeemer:string id:string)
        @event
        (compose-capability (P|ATS|REMOTE-GOV))
        (compose-capability (P|ATS|UPDATE_ROU))
        (compose-capability (SUMMONER))
        (compose-capability (SECURE))
        (BASIS.DPTF-DPMF|UEV_id id false)
        (DALOS.DALOS|UEV_EnforceAccountType redeemer false)
        (let
            (
                (iz-rbt:bool (BASIS.ATS|UC_IzRBT id false))
                
            )
            (enforce iz-rbt "Invalid Hot-RBT")
        )
    )
    (defcap ATS|SYPHON (atspair:string syphon-amounts:[decimal])
        @event
        (compose-capability (P|ATS|REMOTE-GOV))
        (compose-capability (P|ATS|UPDATE_ROU))
        (compose-capability (SUMMONER))
        (AUTOSTAKE.ATS|CAP_Owner atspair)
        (AUTOSTAKE.ATS|UEV_SyphoningState atspair true)
        (let*
            (
                (rt-lst:[string] (AUTOSTAKE.ATS|UR_RewardTokenList atspair))
                (l0:integer (length syphon-amounts))
                (l1:integer (length rt-lst))
                (max-syphon:[decimal] (AUTOSTAKE.ATS|URC_MaxSyphon atspair))
                (max-syphon-sum:decimal (fold (+) 0.0 max-syphon))
                (input-syphon-sum:decimal (fold (+) 0.0 syphon-amounts))

                (resident-amounts:[decimal] (AUTOSTAKE.ATS|UR_RoUAmountList atspair true))
                (supply-check:[bool] (zip (lambda (x:decimal y:decimal) (<= x y)) syphon-amounts resident-amounts))
                (tr-nr:integer (length (LIST|UC_Search supply-check true)))
            )
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
        )
    )
    (defcap ATS|KICKSTART (kickstarter:string atspair:string rt-amounts:[decimal] rbt-request-amount:decimal)
        @event
        (compose-capability (P|ATS|REMOTE-GOV))
        (compose-capability (P|ATS|UPDATE_ROU))
        (compose-capability (SUMMONER))
        (compose-capability (SECURE))
        (let*
            (
                (index:decimal (ATS|UC_Index atspair))
                (rt-lst:[string] (AUTOSTAKE.ATS|UR_RewardTokenList atspair))
                (l1:integer (length rt-amounts))
                (l2:integer (length rt-lst))
                (owner:string (AUTOSTAKE.ATS|UR_OwnerKonto atspair))

            )
            (enforce (= index -1.0) "Kickstarting can only be done on ATS-Pairs with -1 Index")
            (enforce (= l1 l2) "RT-Amounts list does not correspond with the Number of the ATS-Pair Reward Tokens")
            (enforce (> rbt-request-amount 0.0) "RBT Request Amount must be greater than zero!")
            (DALOS.DALOS|CAP_EnforceAccountOwnership owner)
            (DALOS.DALOS|UEV_EnforceAccountType kickstarter false)
        )
    )
    (defcap ATS|RECOVER (recoverer:string id:string nonce:integer amount:decimal)
        @event
        (compose-capability (P|ATS|REMOTE-GOV))
        (compose-capability (SUMMONER))
        (BASIS.DPTF-DPMF|UEV_id id false)
        (DALOS.DALOS|UEV_EnforceAccountType recoverer false)
        (let
            (
                (iz-rbt:bool (BASIS.ATS|UC_IzRBT id false))
                (nonce-max-amount:decimal (BASIS.DPMF|UR_AccountBatchSupply id nonce recoverer))
                
            )
            (enforce iz-rbt "Invalid Hot-RBT")
            (enforce (>= nonce-max-amount amount) "Recovery Amount surpasses Batch Balance")
        )
    )
    (defcap ATS|REMOVE_SECONDARY (atspair:string reward-token:string)
        @event
        (compose-capability (P|ATS|REMOTE-GOV))
        (compose-capability (P|ATS|UPDATE_ROU))
        (compose-capability (P|ATS|RESHAPE))
        (compose-capability (P|ATS|RM_SECONDARY_RT))
        (compose-capability (P|DPTF|UPDATE_RT))
        (compose-capability (SUMMONER))
        (AUTOSTAKE.ATS|CAP_Owner atspair)
        (AUTOSTAKE.ATS|UEV_UpdateColdAndHot atspair)
        (AUTOSTAKE.ATS|UEV_ParameterLockState atspair false)
        (let
            (
                (rt-position:integer (AUTOSTAKE.ATS|UC_RewardTokenPosition atspair reward-token))
            )
            (enforce (> rt-position 0) "Primal RT cannot be removed")
        )
    )
    ;;[UR]
    (defun DPTF-DPMF-ATS|UR_FilterKeysForInfo:[string] (account-or-token-id:string table-to-query:integer mode:bool)
        @doc "Returns a List of either: \
            \       Direct-Mode(true):      <account-or-token-id> is <account> Name: \
            \                               Returns True-Fungible, Meta-Fungible IDs or ATS-Pairs held by an Accounts <account> OR \
            \       Inverse-Mode(false):    <account-or-token-id> is DPTF|DPMF|ATS-Pair Designation Name \
            \                               Returns Accounts that exists for a specific True-Fungible, Meta-Fungible or ATS-Pair \
            \       MODE Boolean is only used for proper validation, to accees the needed table, use the proper integer: \
            \ Table-to-query: \
            \ 1 (DPTF|BalanceTable), 2(DPMF|BalanceTable), 3(ATS|Ledger) "
        (UTILS.UTILS|UEV_PositionalVariable table-to-query 3 "Table To Query can only be 1 2 or 3")
        (if mode
            (DALOS.GLYPH|UEV_DalosAccount account-or-token-id)
            (with-capability (COMPOSE)
                (if (= table-to-query 1)
                    (BASIS.DPTF-DPMF|UEV_id account-or-token-id true)
                    (if (= table-to-query 2)
                        (BASIS.DPTF-DPMF|UEV_id account-or-token-id false)
                        (AUTOSTAKE.ATS|UEV_id account-or-token-id) 
                    )
                )
            )
        )
        (let*
            (
                (keyz:[string]
                    (if (= table-to-query 1)
                        (BASIS.DPTF|KEYS)
                        (if (= table-to-query 2)
                            (BASIS.DPMF|KEYS)
                            (AUTOSTAKE.ATS|KEYS)
                        )
                    )
                )
                (listoflists:[[string]] (map (lambda (x:string) (UTILS.LIST|UC_SplitString UTILS.BAR x)) keyz))
                (output:[string] (UTILS.DALOS|UC_Filterid listoflists account-or-token-id))
            )
            output
        )
    )
    ;;[URC] & [UC]
    (defun ATS|UC_RT-Unbonding (atspair:string reward-token:string)
        (AUTOSTAKE.ATS|UEV_RewardTokenExistance atspair reward-token true)
        (fold
            (lambda
                (acc:decimal account:string)
                (+ acc (AUTOSTAKE.ATS|UC_AccountUnbondingBalance atspair account reward-token))
            )
            0.0
            (DPTF-DPMF-ATS|UR_FilterKeysForInfo atspair 3 false)
        )
    )
    ;;[UCC]
    (defun DPTF|UCC_Pair_ID-Amount:[object{DPTF|ID-Amount}] (id-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (id-length:integer (length id-lst))
                (amount-length:integer (length transfer-amount-lst))
            )
            (enforce (= id-length amount-length) "ID and Transfer-Amount Lists are not of equal length")
            (zip (lambda (x:string y:decimal) { "id": x, "amount": y }) id-lst transfer-amount-lst)
        )
    )
    (defun DPTF|UCC_Pair_Receiver-Amount:[object{DPTF|Receiver-Amount}] (receiver-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (receiver-length:integer (length receiver-lst))
                (amount-length:integer (length transfer-amount-lst))
            )
            (enforce (= receiver-length amount-length) "Receiver and Transfer-Amount Lists are not of equal length")
            (zip (lambda (x:string y:decimal) { "receiver": x, "amount": y }) receiver-lst transfer-amount-lst)
        )
    )
    ;;[C]
    (defun ATS|CO_KickStart (patron:string kickstarter:string atspair:string rt-amounts:[decimal] rbt-request-amount:decimal)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (ATS|CP_KickStart patron kickstarter atspair rt-amounts rbt-request-amount)
        )
    )
    (defun ATS|CP_KickStart (patron:string kickstarter:string atspair:string rt-amounts:[decimal] rbt-request-amount:decimal)
        (require-capability (SECURE))
        (with-capability (ATS|KICKSTART kickstarter atspair rt-amounts rbt-request-amount)
            (let
                (
                    (rbt-id:string (AUTOSTAKE.ATS|UR_ColdRewardBearingToken atspair))
                    (rt-lst:[string] (AUTOSTAKE.ATS|UR_RewardTokenList atspair))
                )
                (DPTF|XP_MultiTransfer patron rt-lst kickstarter AUTOSTAKE.ATS|SC_NAME rt-amounts true)
                (map
                    (lambda
                        (rto:object{DPTF|ID-Amount})
                        (AUTOSTAKE.ATS|XO_UpdateRoU atspair (at "id" rto) true true (at "amount" rto))
                    )
                    (zip (lambda (x:string y:decimal) { "id":x, "amount":y}) rt-lst rt-amounts)
                )
                (BASIS.DPTF|CO_Mint patron rbt-id AUTOSTAKE.ATS|SC_NAME rbt-request-amount false)
                (AUTOSTAKE.DPTF|CO_Transfer patron rbt-id ATS|SC_NAME kickstarter rbt-request-amount true)
            )
        )
    )
    (defun ATS|CO_Syphon (patron:string syphon-target:string atspair:string syphon-amounts:[decimal])
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (ATS|CP_Syphon patron syphon-target atspair syphon-amounts)
        )
    )
    (defun ATS|CP_Syphon (patron:string syphon-target:string atspair:string syphon-amounts:[decimal])
        (require-capability (SECURE))
        (with-capability (ATS|SYPHON atspair syphon-amounts)
            (let
                (
                    (rt-lst:[string] (AUTOSTAKE.ATS|UR_RewardTokenList atspair))
                )
                (map
                    (lambda
                        (index:integer)
                        (if (> (at index syphon-amounts) 0.0)
                            (with-capability (COMPOSE)
                                (AUTOSTAKE.DPTF|CO_Transfer patron (at index rt-lst) AUTOSTAKE.ATS|SC_NAME syphon-target (at index syphon-amounts) true)
                                (ATS|XO_UpdateRoU atspair (at index rt-lst) true false (at index syphon-amounts))
                            )
                            true
                        )
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
            )
        )
    )
    (defun ATS|CO_Redeem (patron:string redeemer:string id:string nonce:integer)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (ATS|CP_Redeem patron redeemer id nonce)
        )
    )
    (defun ATS|CP_Redeem (patron:string redeemer:string id:string nonce:integer)
        (require-capability (SECURE))
        (with-capability (ATS|REDEEM redeemer id)
            (let*
                (
                    (precision:integer (BASIS.DPTF-DPMF|UR_Decimals id false))
                    (current-nonce-balance:decimal (BASIS.DPMF|UR_AccountBatchSupply id nonce redeemer))
                    (meta-data (BASIS.DPMF|UR_AccountBatchMetaData id nonce redeemer))

                    (birth-date:time (at "mint-time" (at 0 meta-data)))
                    (present-time:time (at "block-time" (chain-data)))
                    (elapsed-time:decimal (diff-time present-time birth-date))

                    (atspair:string (BASIS.DPMF|UR_RewardBearingToken id))
                    (rt-lst:[string] (AUTOSTAKE.ATS|UR_RewardTokenList atspair))
                    (h-promile:decimal (AUTOSTAKE.ATS|UR_HotRecoveryStartingFeePromile atspair))
                    (h-decay:integer (AUTOSTAKE.ATS|UR_HotRecoveryDecayPeriod atspair))
                    (h-fr:bool (AUTOSTAKE.ATS|UR_HotRecoveryFeeRedirection atspair))

                    (total-time:decimal (* 86400.0 (dec h-decay)))
                    (end-time:time (add-time birth-date (hours (* 24 h-decay))))
                    (earned-rbt:decimal
                        (if (>= elapsed-time total-time)
                            current-nonce-balance
                            (floor (* current-nonce-balance (/ (- 1000.0 (* h-promile (- 1.0 (/ elapsed-time total-time)))) 1000.0)) precision)
                        )
                    )
                    (total-rts:[decimal] (AUTOSTAKE.ATS|UC_RTSplitAmounts atspair current-nonce-balance))
                    (earned-rts:[decimal] (AUTOSTAKE.ATS|UC_RTSplitAmounts atspair earned-rbt))
                    (fee-rts:[decimal] (zip (lambda (x:decimal y:decimal) (- x y)) total-rts earned-rts))
                )
            ;;1]Redeemer sends the whole Hot-Rbt to ATS|SC_NAME
                (BASIS.DPMF|CO_Transfer patron id nonce redeemer AUTOSTAKE.ATS|SC_NAME current-nonce-balance true)
            ;;2]ATS|SC_NAME burns the whole Hot-RBT
                (BASIS.DPMF|CO_Burn patron id nonce AUTOSTAKE.ATS|SC_NAME current-nonce-balance)
            ;;3]ATS|SC_NAME transfers the proper amount of RT(s) to the Redeemer, and update RoU
                (DPTF|XP_MultiTransfer patron rt-lst AUTOSTAKE.ATS|SC_NAME redeemer earned-rts true)
                (map
                    (lambda
                        (index:integer)
                        (ATS|XO_UpdateRoU atspair (at index rt-lst) true false (at index earned-rts))
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
            ;;4]And the Hot-FeeRediraction is accounted for
                (if (and (not h-fr) (!= earned-rbt current-nonce-balance))
                    (map
                        (lambda
                            (index:integer)
                            (BASIS.DPTF|CO_Burn patron (at index rt-lst) AUTOSTAKE.ATS|SC_NAME (at index fee-rts))
                        )
                        (enumerate 0 (- (length rt-lst) 1))
                    )
                    true
                )
            )
        )
    )
    (defun ATS|CO_RecoverWholeRBTBatch (patron:string recoverer:string id:string nonce:integer)
        (let
            (
                (nonce-max-amount:decimal (BASIS.DPMF|UR_AccountBatchSupply id nonce recoverer))
            )
            (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
            (with-capability (SECURE)
                (ATS|CP_RecoverHotRBT patron recoverer id nonce nonce-max-amount)
            )
        )
    )
    (defun ATS|CO_RecoverHotRBT (patron:string recoverer:string id:string nonce:integer amount:decimal)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (ATS|CP_RecoverHotRBT patron recoverer id nonce amount)
        )
    )
    (defun ATS|CP_RecoverHotRBT (patron:string recoverer:string id:string nonce:integer amount:decimal)
        (require-capability (SECURE))
        (with-capability (ATS|RECOVER recoverer id nonce amount)
            (let*
                (
                    (atspair:string (BASIS.DPMF|UR_RewardBearingToken id))
                    (c-rbt:string (AUTOSTAKE.ATS|UR_ColdRewardBearingToken atspair))
                )
            ;;1]Recover sends HotRBT to ATS|SC_NAME
                (BASIS.DPMF|CO_Transfer patron id nonce recoverer AUTOSTAKE.ATS|SC_NAME amount true)
            ;;2]ATS|SC_NAME burns Hot RBT
                (BASIS.DPMF|CO_Burn patron id nonce AUTOSTAKE.ATS|SC_NAME amount)
            ;;3]ATS|SC_NAME mints Cold RBT
                (BASIS.DPTF|CO_Mint patron c-rbt ATS|SC_NAME amount false)
            ;;4]ATS|SC_Name transfer Cold RBT to recoverer
                (AUTOSTAKE.DPTF|CO_Transfer patron c-rbt ATS|SC_NAME recoverer amount true)
            )
        ) 
    )
    (defun ATS|CO_RemoveSecondary (patron:string remover:string atspair:string reward-token:string)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (ATS|CP_RemoveSecondary patron remover atspair reward-token)
        )
    )
    (defun ATS|CP_RemoveSecondary (patron:string remover:string atspair:string reward-token:string)
        (require-capability (SECURE))
        (with-capability (ATS|REMOVE_SECONDARY atspair reward-token)
            (let*
                (
                    (rt-lst:[string] (AUTOSTAKE.ATS|UR_RewardTokenList atspair))
                    (remove-position:integer (at 0 (UTILS.LIST|UC_Search rt-lst reward-token)))
                    (primal-rt:string (at 0 rt-lst))
                    (resident-sum:decimal (at remove-position (AUTOSTAKE.ATS|UR_RoUAmountList atspair true)))
                    (unbound-sum:decimal (at remove-position (AUTOSTAKE.ATS|UR_RoUAmountList atspair false)))
                    (remove-sum:decimal (+ resident-sum unbound-sum))

                    (accounts-with-atspair-data:[string] (DPTF-DPMF-ATS|UR_FilterKeysForInfo atspair 3 false))
                )
            ;;1]The RT to be removed, is transfered to the remover, from the ATS|SC_NAME
                (AUTOSTAKE.DPTF|CO_Transfer patron reward-token ATS|SC_NAME remover remove-sum true)
            ;;2]The amount removed is added back as Primal-RT
                (AUTOSTAKE.DPTF|CO_Transfer patron primal-rt remover ATS|SC_NAME remove-sum true)
            ;;3]ROU Table is updated with the new DATA, now as primal RT
                (AUTOSTAKE.ATS|XO_UpdateRoU atspair primal-rt true true resident-sum)
                (AUTOSTAKE.ATS|XO_UpdateRoU atspair primal-rt false true unbound-sum)
            ;;4]Client Accounts are modified to remove the RT Token and update balances with Primal RT
                (map
                    (lambda
                        (kontos:string)
                        (AUTOSTAKE.ATS|XO_ReshapeUnstakeAccount atspair kontos remove-position)
                    )
                    accounts-with-atspair-data
                )
            ;;5]Actually Remove the RT from the ATS-Pair
                (AUTOSTAKE.ATS|XO_RemoveSecondary atspair reward-token)
            ;;6]Update Data in the DPTF Token Properties
                (BASIS.DPTF|XO_UpdateRewardToken atspair reward-token false)
            )
        )
    )
    (defun DPTF|CO_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (DPTF|XP_MultiTransfer patron id-lst sender receiver transfer-amount-lst method)
        )
    )
    (defun DPTF|CO_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (DPTF|XP_BulkTransfer patron id sender receiver-lst transfer-amount-lst method)
        )
    )
    (defun DPMF|CO_SingleBatchTransfer (patron:string id:string nonce:integer sender:string receiver:string method:bool)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (DPMF|XP_SingleBatchTransfer patron id nonce sender receiver method)
        )
    )
    (defun DPMF|CO_MultiBatchTransfer (patron:string id:string nonces:[integer] sender:string receiver:string method:bool)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (DPMF|XP_MultiBatchTransfer patron id nonces sender receiver method)
        )
    )
    ;;[X]
    (defun DPTF|XP_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        (require-capability (SECURE))
        (with-capability (SUMMONER)
            (let
                (
                    (pair-validation:bool (DPTF|UEV_Pair_ID-Amount id-lst transfer-amount-lst))
                )
                (enforce (= pair-validation true) "Input Lists <id-lst>|<transfer-amount-lst> cannot make a valid pair list for Multi Transfer Processing")
                (let
                    (
                        (pair:[object{DPTF|ID-Amount}] (DPTF|UCC_Pair_ID-Amount id-lst transfer-amount-lst))
                    )
                    (map (lambda (x:object{DPTF|ID-Amount}) (DPTF|X_MultiTransferPaired patron sender receiver x method)) pair)
                )
            )
        )
    )
    (defun DPTF|X_MultiTransferPaired (patron:string sender:string receiver:string id-amount-pair:object{DPTF|ID-Amount} method:bool)
        (let
            (
                (id:string (at "id" id-amount-pair))
                (amount:decimal (at "amount" id-amount-pair))
            )
            (AUTOSTAKE.DPTF|CO_Transfer patron id sender receiver amount method)
        )
    )
    (defun DPTF|XP_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        (require-capability (SECURE))
        (with-capability (SUMMONER)
            (let
                (
                    (pair-validation:bool (DPTF|UEV_Pair_Receiver-Amount id receiver-lst transfer-amount-lst))
                )
                (enforce (= pair-validation true) "Input Lists <receiver-lst>|<transfer-amount-lst> cannot make a valid pair list with the <id> for Bulk Transfer Processing")
                (let
                    (
                        (pair:[object{DPTF|Receiver-Amount}] (DPTF|UCC_Pair_Receiver-Amount receiver-lst transfer-amount-lst))
                    )
                    (map (lambda (x:object{DPTF|Receiver-Amount}) (DPTF|X_BulkTransferPaired patron id sender x method)) pair)
                )
            )
        )
    )
    (defun DPTF|X_BulkTransferPaired (patron:string id:string sender:string receiver-amount-pair:object{DPTF|Receiver-Amount} method:bool)
        (let
            (
                (receiver:string (at "receiver" receiver-amount-pair))
                (amount:decimal (at "amount" receiver-amount-pair))
            )
            (AUTOSTAKE.DPTF|CO_Transfer patron id sender receiver amount method)
        )
    )
    (defun DPMF|XP_MultiBatchTransfer (patron:string id:string nonces:[integer] sender:string receiver:string method:bool)
        (let*
            (
                (account-nonces:[integer] (BASIS.DPMF|UR_AccountNonces id sender))
                (contains-all:bool (UTILS.UTILS|UEV_ContainsAll account-nonces nonces))
            )
            (enforce contains-all "Invalid Nonce List for DPTf Multi Batch Transfer")
            (map
                (lambda
                    (single-nonce:integer)
                    (DPMF|XP_SingleBatchTransfer patron id single-nonce sender receiver method)
                )
                nonces
            )
        )
    )
    (defun DPMF|XP_SingleBatchTransfer (patron:string id:string nonce:integer sender:string receiver:string method:bool)
        (require-capability (SECURE))
        (let
            (
                (balance:decimal (BASIS.DPMF|UR_AccountBatchSupply id nonce))
            )
            (BASIS.DPMF|CO_Transfer patron id nonce sender receiver balance method)
        )
    )
    ;;
    ;;            OUROBOROS         Submodule
    ;;[UEV]
    (defun DALOS|UEV_Live ()
        (let
            (
                (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                (gas-id:string (DALOS.DALOS|UR_IgnisID))
            )
            (enforce (!= ouro-id UTILS.BAR) "Ouroboros is not set")
            (enforce (!= gas-id UTILS.BAR) "Ignis is not set")
        )
    )
    (defun IGNIS|UEV_Exchange ()
        (DALOS|UEV_Live)
        (let*
            (
                (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                (gas-id:string (DALOS.DALOS|UR_IgnisID))
                (o-rm:bool (BASIS.DPTF|UR_AccountRoleMint ouro-id OUROBOROS|SC_NAME))
                (o-rb:bool (BASIS.DPTF-DPMF|UR_AccountRoleBurn ouro-id OUROBOROS|SC_NAME true))
                (t1:bool (and o-rm o-rb))
                (g-rm:bool (BASIS.DPTF|UR_AccountRoleMint gas-id OUROBOROS|SC_NAME))
                (g-rb:bool (BASIS.DPTF-DPMF|UR_AccountRoleBurn gas-id OUROBOROS|SC_NAME true))
                (t2:bool (and g-rm g-rb))
                (t3:bool (and t1 t2))
            )
            (enforce t3 "Permission invalid for Ignis Exchange")
        )
    )
    ;;[CAP]
    (defcap IGNIS|SUBLIMATE (patron:string client:string target:string)
        @event
        (compose-capability (OUROBOROS|GOV))
        (compose-capability (SUMMONER))
        (IGNIS|UEV_Exchange)
        (DALOS.DALOS|UEV_EnforceAccountType patron false)
        (DALOS.DALOS|UEV_EnforceAccountType client false)
        (DALOS.DALOS|UEV_EnforceAccountType target false)
    )
    (defcap IGNIS|COMPRESS (patron:string client:string)
        @event
        (compose-capability (OUROBOROS|GOV))
        (compose-capability (SUMMONER))
        (IGNIS|UEV_Exchange)
        (DALOS.DALOS|UEV_EnforceAccountType patron false)
        (DALOS.DALOS|UEV_EnforceAccountType client false)
    )
    (defcap OUROBOROS|WITHDRAW (patron:string id:string target:string)
        @event
        (compose-capability (OUROBOROS|GOV))
        (compose-capability (SUMMONER))
        (BASIS.DPTF-DPMF|CAP_Owner id true)
        (DALOS.DALOS|UEV_EnforceAccountType target false)
    )
    (defcap OUROBOROS|ADMIN_FUEL ()
        @event
        (compose-capability (OUROBOROS|GOV))
        (compose-capability (SUMMONER))
        (compose-capability (OUROBOROS|NATIVE-AUTOMATIC))
    )
    ;;[URC] & [UC]
    (defun IGNIS|UC_Sublimate:decimal (ouro-amount:decimal)
        (enforce (>= ouro-amount 1.00) "Only amounts greater than or equal to 1.0 can be used to make gas!")
        (let
            (
                (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                
            )
            (BASIS.DPTF-DPMF|UEV_Amount ouro-id ouro-amount true)
            (let*
                (
                    (ouro-price:decimal (DALOS.DALOS|UR_OuroborosPrice))
                    (ouro-price-used:decimal (if (<= ouro-price 1.00) 1.00 ouro-price))
                    (ignis-id:string (DALOS.DALOS|UR_IgnisID))
                )
                (enforce (!= ignis-id UTILS.BAR) "Gas Token isnt properly set")
                (let*
                    (
                        (ignis-precision:integer (BASIS.DPTF-DPMF|UR_Decimals ignis-id true))
                        (raw-ignis-amount-per-unit:decimal (floor (* ouro-price-used 100.0) ignis-precision))
                        (raw-ignis-amount:decimal (floor (* raw-ignis-amount-per-unit ouro-amount) ignis-precision))
                        (output-ignis-amount:decimal (floor raw-ignis-amount 0))
                    )
                    output-ignis-amount
                )
            )
        )
    )
    (defun IGNIS|UC_Compress (ignis-amount:decimal)
        (enforce (= (floor ignis-amount 0) ignis-amount) "Only whole Units of GAS(Ignis) can be compressed")
        (enforce (>= ignis-amount 1.00) "Only amounts greater than or equal to 1.0 can be used to compress gas")
        (let*
            (
                (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                (ouro-price:decimal (DALOS.DALOS|UR_OuroborosPrice))
                (ouro-price-used:decimal (if (<= ouro-price 1.00) 1.00 ouro-price))
                (ignis-id:string (DALOS.DALOS|UR_IgnisID))
            )
            (BASIS.DPTF-DPMF|UEV_Amount ignis-id ignis-amount true)
            (let*
                (
                    (ouro-precision:integer (BASIS.DPTF-DPMF|UR_Decimals ouro-id true))
                    (raw-ouro-amount:decimal (floor (/ ignis-amount (* ouro-price-used 100.0)) ouro-precision))
                    (promile-split:[decimal] (UTILS.ATS|UC_PromilleSplit 15.0 raw-ouro-amount ouro-precision))
                    (ouro-remainder-amount:decimal (floor (at 0 promile-split) ouro-precision))
                    (ouro-fee-amount:decimal (at 1 promile-split))
                )
                [ouro-remainder-amount ouro-fee-amount]
            )
        )
    )
    ;;[C]
    (defun OUROBOROS|CO_FuelLiquidStakingFromReserves (patron:string)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (OUROBOROS|CP_FuelLiquidStakingFromReserves  patron)
        )
    )
    (defun OUROBOROS|CP_FuelLiquidStakingFromReserves (patron:string)
        (require-capability (SECURE))
        (with-capability (OUROBOROS|ADMIN_FUEL)
            (let*
                (
                    (present-kda-balance:decimal (at "balance" (coin.details (DALOS|UR_AccountKadena OUROBOROS|SC_NAME))))
                    (w-kda:string (DALOS.DALOS|UR_WrappedKadenaID))
                    (w-kda-as-rt:[string] (BASIS.DPTF|UR_RewardToken w-kda))
                    (liquid-idx:string (at 0 w-kda-as-rt))
                )
                (if (> present-kda-balance 0.0)
                    (with-capability (COMPOSE)
                ;;Use existing Native Kadena Stock for wrapping int DWK
                        (LIQUID.LIQUID|CO_WrapKadena patron OUROBOROS|SC_NAME present-kda-balance)
                ;;Use the generated DWK to fuel its Autostake Pair
                        (AUTOSTAKE.ATS|CO_Fuel patron OUROBOROS|SC_NAME liquid-idx w-kda present-kda-balance)
                    )
                    true
                )
            )
        )
    )
    (defun OUROBOROS|CO_WithdrawFees (patron:string id:string target:string)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (OUROBOROS|CP_WithdrawFees patron id target)
        )
    )
    (defun OUROBOROS|CP_WithdrawFees (patron:string id:string target:string)
        (require-capability (SECURE))
        (with-capability (OUROBOROS|WITHDRAW patron id target)
            (let
                (
                    (withdraw-amount:decimal (BASIS.DPTF-DPMF|UR_AccountSupply id OUROBOROS|SC_NAME true))
                )
                (enforce (> withdraw-amount 0.0) (format "There are no {} fees to be withdrawn from {}" [id OUROBOROS|SC_NAME]))
            ;;1]Patron withdraws Fees from Ouroboros Smart DALOS Account to a target Normal DALOS Account
                (AUTOSTAKE.DPTF|CO_Transfer patron id OUROBOROS|SC_NAME target withdraw-amount true)
            )
        )
    )
    (defun IGNIS|CO_Sublimate:decimal (patron:string client:string target:string ouro-amount:decimal)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (IGNIS|CP_Sublimate patron client target ouro-amount)
        )
    )
    (defun IGNIS|CP_Sublimate:decimal (patron:string client:string target:string ouro-amount:decimal)
        (require-capability (SECURE))
        (with-capability (IGNIS|SUBLIMATE patron client target)
            (let*
                (
                    (ignis-id:string (DALOS.DALOS|UR_IgnisID))
                    (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                    (ouro-precision:integer (BASIS.DPTF-DPMF|UR_Decimals ouro-id true))
                    (ouro-split:[decimal] (UTILS.ATS|UC_PromilleSplit 10.0 ouro-amount ouro-precision))
                    (ouro-remainder-amount:decimal (at 0 ouro-split))
                    (ouro-fee-amount:decimal (at 1 ouro-split))
                    (ignis-amount:decimal (IGNIS|UC_Sublimate ouro-remainder-amount))
                )
            ;;01]Client sends OURO <ouro-amount> to the Ouroboros Smart DALOS Account
                (AUTOSTAKE.DPTF|CO_Transfer patron ouro-id client OUROBOROS|SC_NAME ouro-amount true)
            ;;02]Ouroboros burns OURO <ouro-remainder-amount>
                (BASIS.DPTF|CO_Burn patron ouro-id OUROBOROS|SC_NAME ouro-remainder-amount)
            ;;03]Ouroboros mints GAS(Ignis) <ignis-amount>
                (BASIS.DPTF|CO_Mint patron ignis-id OUROBOROS|SC_NAME ignis-amount false)
            ;;04]Ouroboros transfers GAS(Ignis) <ignis-amount> to <target>
                (AUTOSTAKE.DPTF|CO_Transfer patron ignis-id OUROBOROS|SC_NAME target ignis-amount true)
            ;;05]Ouroboros transmutes OURO <ouro-fee-amount>
                (AUTOSTAKE.DPTF|CO_Transmute patron ouro-id OUROBOROS|SC_NAME ouro-fee-amount)
                ignis-amount
            )
        )
    )
    (defun IGNIS|CO_Compress:decimal (patron:string client:string ignis-amount:decimal)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (IGNIS|CP_Compress patron client ignis-amount)
        )
    )
    (defun IGNIS|CP_Compress:decimal (patron:string client:string ignis-amount:decimal)
        (require-capability (SECURE))
        (with-capability (IGNIS|COMPRESS patron client)
            (let*
                (
                    (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                    (ignis-id:string (DALOS.DALOS|UR_IgnisID))
                    (ignis-to-ouro:[decimal] (IGNIS|UC_Compress ignis-amount))
                    (ouro-remainder-amount:decimal (at 0 ignis-to-ouro))
                    (ouro-fee-amount:decimal (at 1 ignis-to-ouro))
                    (total-ouro:decimal (+ ouro-remainder-amount ouro-fee-amount))
                )
            ;;01]Client sends GAS(Ignis) <ignis-amount> to the Ouroboros Smart DALOS Account
                (AUTOSTAKE.DPTF|CO_Transfer patron ignis-id client OUROBOROS|SC_NAME ignis-amount true)
            ;;02]Ouroboros burns GAS(Ignis) <ignis-amount>
                (BASIS.DPTF|CO_Burn patron ignis-id OUROBOROS|SC_NAME ignis-amount)
            ;;03]Ouroboros mints OURO <total-ouro>
                (BASIS.DPTF|CO_Mint patron ouro-id OUROBOROS|SC_NAME total-ouro false)
            ;;04]Ouroboros transfers OURO <ouro-remainder-amount> to <client>
                (AUTOSTAKE.DPTF|CO_Transfer patron ouro-id OUROBOROS|SC_NAME client ouro-remainder-amount true)
            ;;05]Ouroboros transmutes OURO <ouro-fee-amount>
                (AUTOSTAKE.DPTF|CO_Transmute patron ouro-id OUROBOROS|SC_NAME ouro-fee-amount)
                ouro-remainder-amount
            )
        )
    )
    ;;========[P] PRINT-FUNCTIONS==============================================;;
    (defun DALOS|UP_AccountProperties (account:string)
        (let* 
            (
                (p:[bool] (DALOS.DALOS|UR_AccountProperties account))
                (a:bool (at 0 p))
                (b:bool (at 1 p))
                (c:bool (at 2 p))
            )
            (if (= a true)
                (format "Account {} is a Smart Account: Payable: {}; Payable by Smart Account: {}." [account b c])
                (format "Account {} is a Normal Account" [account])
            )
        )
    )
    (defun ATS|UP_P0 (atspair:string account:string)
        (format "{}|{} P0: {}" [atspair account (AUTOSTAKE.ATS|UR_P0 atspair account)])
    )
    (defun ATS|UP_P1 (atspair:string account:string)
        (format "{}|{} P1: {}" [atspair account (AUTOSTAKE.ATS|UR_P1-7 atspair account 1)])
    )
    (defun ATS|UP_P2 (atspair:string account:string)
        (format "{}|{} P2: {}" [atspair account (AUTOSTAKE.ATS|UR_P1-7 atspair account 2)])
    )
    (defun ATS|UP_P3 (atspair:string account:string)
        (format "{}|{} P3: {}" [atspair account (AUTOSTAKE.ATS|UR_P1-7 atspair account 3)])
    )
    (defun ATS|UP_P4 (atspair:string account:string)
        (format "{}|{} P4: {}" [atspair account (AUTOSTAKE.ATS|UR_P1-7 atspair account 4)])
    )
    (defun ATS|UP_P5 (atspair:string account:string)
        (format "{}|{} P5: {}" [atspair account (AUTOSTAKE.ATS|UR_P1-7 atspair account 5)])
    )
    (defun ATS|UP_P6 (atspair:string account:string)
        (format "{}|{} P6: {}" [atspair account (AUTOSTAKE.ATS|UR_P1-7 atspair account 6)])
    )
    (defun ATS|UP_P7 (atspair:string account:string)
        (format "{}|{} P7: {}" [atspair account (AUTOSTAKE.ATS|UR_P1-7 atspair account 7)])
    )
)
(create-table OUROB|PoliciesTable)