;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module TFT GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_TFT            (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|TFT_ADMIN))
    )
    (defcap GOV|TFT_ADMIN ()
        (enforce-guard GOV|MD_TFT)
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    (defcap P|T|UF ()
        true
    )
    (defcap P|DPTF|DEBIT ()
        true
    )
    (defcap P|DPTF|CREDIT ()
        true
    )
    (defcap P|DALOS|UP_ELT ()
        true
    )
    (defcap P|ATS|UP_ROU ()
        true
    )
    (defcap P|DPTF|BURN ()
        true
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|TFT_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        (DALOS.P|A_Add 
            "TFT|UpdElite"
            (create-capability-guard (P|DALOS|UP_ELT))
        )
        (DPTF.P|A_Add 
            "TFT|DbTF"
            (create-capability-guard (P|DPTF|DEBIT))
        )
        (DPTF.P|A_Add 
            "TFT|CrTF"
            (create-capability-guard (P|DPTF|CREDIT))
        )
        (DPTF.P|A_Add 
            "TFT|UpFees"
            (create-capability-guard (P|T|UF))
        )
        (DPTF.P|A_Add
            "TFT|BrTF"
            (create-capability-guard (P|DPTF|BURN))
        )
        (ATS.P|A_Add
            "TFT|UpdateROU"
            (create-capability-guard (P|ATS|UP_ROU))
        )
    )
    
    ;;
    ;;{1}
    (defschema DPTF|ID-Amount
        id:string
        amount:decimal
    )
    (defschema DPTF|Receiver-Amount
        receiver:string
        amount:decimal
    )
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
    (defcap SECURE ()
        true
    )
    (defcap DALOS|EXECUTOR ()
        true
    )
    (defcap DPTF|CPF_CREDIT-FEE ()
        true
    )
    (defcap DPTF|CPF_STILL-FEE ()
        true
    )
    (defcap DPTF|CPF_BURN-FEE ()
        true
    )
    ;;{5}
    ;;{6}
    ;;{7}
    (defcap DPTF|C>TRANSFER (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @event
        (DALOS.DALOS|CAP_EnforceAccountOwnership sender)
        (if (and method (DALOS.DALOS|UR_AccountType receiver))
            (DALOS.DALOS|CAP_EnforceAccountOwnership receiver)
            true
        )
        (DPTF.DPTF|UEV_Amount id transfer-amount)
        (if (not (DPTF.DPTF|URC_TrFeeMinExc id sender receiver))
            (DPTF.DPTF|UEV_EnforceMinimumAmount id transfer-amount)
            true
        )
        (DALOS.DALOS|UEV_EnforceTransferability sender receiver method)
        (DPTF.DPTF|UEV_PauseState id false)
        (DPTF.DPTF|UEV_AccountFreezeState id sender false)
        (DPTF.DPTF|UEV_AccountFreezeState id receiver false)
        (if 
            (and 
                (> (DPTF.DPTF|UR_TransferRoleAmount id) 0) 
                (not (or (= sender DALOS.OUROBOROS|SC_NAME)(= sender DALOS.DALOS|SC_NAME)))
            )
            (let
                (
                    (s:bool (DPTF.DPTF|UR_AccountRoleTransfer id sender))
                    (r:bool (DPTF.DPTF|UR_AccountRoleTransfer id receiver))
                )
                (enforce-one
                    (format "Neither the sender {} nor the receiver {} have an active transfer role" [sender receiver])
                    [
                        (enforce (= s true) (format "TR doesnt check for sender {}" [sender]))
                        (enforce (= r true) (format "TR doesnt check for receiver {}" [receiver]))
                    ]

                )
            )
            (format "No transfer restrictions for {} from {} to {}" [id sender receiver])
        )
        (compose-capability (DPTF|C>CREDIT_PRIMARY-FEE))
        (compose-capability (P|DPTF|DEBIT))
        (compose-capability (P|DPTF|CREDIT))
        (compose-capability (P|DALOS|UP_ELT))
        (compose-capability (P|T|UF))
    )
    (defcap DPTF|C>CREDIT_PRIMARY-FEE ()
        (compose-capability (P|ATS|UP_ROU))
        (compose-capability (DPTF|CPF_CREDIT-FEE))
        (compose-capability (DPTF|CPF_STILL-FEE))
        (compose-capability (DPTF|CPF_BURN-FEE))
        (compose-capability (P|DPTF|CREDIT))
        (compose-capability (P|DPTF|BURN))
    )
    (defcap DPTF|C>TRANSMUTE ()
        (compose-capability (P|DPTF|DEBIT))
        (compose-capability (DPTF|C>CREDIT_PRIMARY-FEE))
    )
    ;;
    ;;{8}
    ;;{9}
    (defun DPTF|UDC_Pair_ID-Amount:[object{DPTF|ID-Amount}] (id-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (id-length:integer (length id-lst))
                (amount-length:integer (length transfer-amount-lst))
            )
            (enforce (= id-length amount-length) "ID and Transfer-Amount Lists are not of equal length")
            (zip (lambda (x:string y:decimal) { "id": x, "amount": y }) id-lst transfer-amount-lst)
        )
    )
    (defun DPTF|UDC_Pair_Receiver-Amount:[object{DPTF|Receiver-Amount}] (receiver-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (receiver-length:integer (length receiver-lst))
                (amount-length:integer (length transfer-amount-lst))
            )
            (enforce (= receiver-length amount-length) "Receiver and Transfer-Amount Lists are not of equal length")
            (zip (lambda (x:string y:decimal) { "receiver": x, "amount": y }) receiver-lst transfer-amount-lst)
        )
    )
    ;;{10}
    (defun DPTF|UEV_AmountCheck:bool (id:string amount:decimal)
        (let*
            (
                (decimals:integer (DPTF.DPTF|UR_Decimals id))
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
                (and acc (DPTF|UEV_AmountCheck (at "id" item) (at "amount" item)))
            )
            true
            (DPTF|UDC_Pair_ID-Amount id-lst transfer-amount-lst)
        )
    )
    (defun DPTF|UEV_Pair_Receiver-Amount:bool (id:string receiver-lst:[string] transfer-amount-lst:[decimal])
        (DPTF.DPTF|UEV_id id)
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
                (DPTF|UDC_Pair_Receiver-Amount receiver-lst transfer-amount-lst)
            )
            (fold
                (lambda
                    (acc:bool item:object{DPTF|Receiver-Amount})
                    (let*
                        (
                            (transfer-amount:decimal (at "amount" item))
                            (check:bool (DPTF|UEV_AmountCheck id transfer-amount))
                        )
                        (and acc check)
                    )
                )
                true
                (DPTF|UDC_Pair_Receiver-Amount receiver-lst transfer-amount-lst)
            )
        )
    )
    ;;{11}
    (defun TFT|CPF_RT-RBT:[decimal] (id:string native-fee-amount:decimal)
        (let*
            (
                (rt-ats-pairs:[string] (DPTF.DPTF|UR_RewardToken id))
                (rbt-ats-pairs:[string] (DPTF.DPTF|UR_RewardBearingToken id))
                (length-rt:integer (length rt-ats-pairs))
                (length-rbt:integer (length rbt-ats-pairs))
                (rt-boolean:[bool] (TFT|NFR-Boolean_RT-RBT id rt-ats-pairs true))
                (rbt-boolean:[bool] (TFT|NFR-Boolean_RT-RBT id rbt-ats-pairs false))
                (rt-milestones:integer (length (UTILS.LIST|UC_Search rt-boolean true)))
                (rbt-milestones:integer (length (UTILS.LIST|UC_Search rbt-boolean true)))
                (milestones:integer (+ rt-milestones rbt-milestones))
            )
            (if (!= milestones 0)
                (let*
                    (
                        (truths:[bool] (+ rt-boolean rbt-boolean))
                        (split-with-truths:[decimal] (TFT|UC_BooleanDecimalCombiner id native-fee-amount milestones truths))
                    )
                    (if (!= rt-milestones 0)
                        (let
                            (
                                (credit-sum:decimal
                                    (fold
                                        (lambda
                                            (acc:decimal index:integer)
                                            (if (at index rt-boolean)
                                                (do
                                                    (ATS.ATS|X_UpdateRoU (at index rt-ats-pairs) id true true (at index split-with-truths))
                                                    (+ acc (at index split-with-truths))
                                                )
                                                acc
                                            )
                                        )
                                        0.0
                                        (enumerate 0 (- (length rt-ats-pairs) 1))
                                    )
                                )
                            )
                            (if (= credit-sum 0.0)
                                [0.0 0.0 native-fee-amount]
                                [0.0 credit-sum (- native-fee-amount credit-sum)]
                            )
                        )
                        [0.0 0.0 native-fee-amount]
                    )
                )
                [native-fee-amount 0.0 0.0]
            )
        )
    )
    (defun TFT|CPF_RBT:decimal (id:string native-fee-amount:decimal)
        (let*
            (
                (ats-pairs:[string] (DPTF.DPTF|UR_RewardBearingToken id))
                (ats-pairs-bool:[bool] (TFT|NFR-Boolean_RT-RBT id ats-pairs false))
                (milestones:integer (length (UTILS.LIST|UC_Search ats-pairs-bool true)))
            )
            (if (!= milestones 0)
                0.0
                native-fee-amount
            )
        )
    )
    (defun TFT|CPF_RT:decimal (id:string native-fee-amount:decimal)
        (let*
            (
                (ats-pairs:[string] (DPTF.DPTF|UR_RewardToken id))
                (ats-pairs-bool:[bool] (TFT|NFR-Boolean_RT-RBT id ats-pairs true))
                (milestones:integer (length (UTILS.LIST|UC_Search ats-pairs-bool true)))  
            )
            (if (!= milestones 0)
                (let*
                    (
                        (rt-split-with-boolean:[decimal] (TFT|UC_BooleanDecimalCombiner id native-fee-amount milestones ats-pairs-bool))
                        (number-of-zeroes:integer (length (UTILS.LIST|UC_Search rt-split-with-boolean 0.0)))
                    )
                    (map
                        (lambda
                            (index:integer)
                            (if (at index ats-pairs-bool)
                                (ATS.ATS|X_UpdateRoU (at index ats-pairs) id true true (at index rt-split-with-boolean))
                                true
                            )
                        )
                        (enumerate 0 (- (length ats-pairs) 1))
                    )
                    0.0
                )
                native-fee-amount
            )
        )
    )
    (defun TFT|NFR-Boolean_RT-RBT:[bool] (id:string ats-pairs:[string] rt-or-rbt:bool)
        @doc "Makes a [bool] using RT or RBT <nfr> values from a list of ATS Pair"
        (fold
            (lambda
                (acc:[bool] index:integer)
                (if rt-or-rbt
                    (if (ATS.ATS|UR_RT-Data (at index ats-pairs) id 1)
                        (UTILS.LIST|UC_AppendLast acc true)
                        (UTILS.LIST|UC_AppendLast acc false)
                    )
                    (if (ATS.ATS|UR_ColdNativeFeeRedirection (at index ats-pairs))
                        (UTILS.LIST|UC_AppendLast acc true)
                        (UTILS.LIST|UC_AppendLast acc false)
                    )
                )
            )
            []
            (enumerate 0 (- (length ats-pairs) 1))
        )
    )
    (defun TFT|UC_BooleanDecimalCombiner:[decimal] (id:string amount:decimal milestones:integer boolean:[bool])
        (UTILS.ATS|UC_SplitBalanceWithBooleans (DPTF.DPTF|UR_Decimals id) amount milestones boolean)
    )
    ;;{12}
    (defun DPTF-DPMF-ATS|UR_TableKeys:[string] (position:integer poi:bool)
        (UTILS.UTILS|UEV_PositionalVariable position 3 "Invalid Ownership Position")
        (if poi
            (if (= position 1)
                (DPTF.DPTF|UR_P-KEYS)
                (if (= position 2)
                    (DPMF.DPMF|UR_P-KEYS)
                    (ATS.ATS|UR_P-KEYS)
                )
            )
            (if (= position 1)
                (DPTF.DPTF|UR_KEYS)
                (if (= position 2)
                    (DPMF.DPMF|UR_KEYS)
                    (ATS.ATS|UR_KEYS)
                )
            )
        )
    )
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
            (do
                (if (= table-to-query 1)
                    (DPTF.DPTF|UEV_id account-or-token-id)
                    (if (= table-to-query 2)
                        (DPMF.DPMF|UEV_id account-or-token-id)
                        (ATS.ATS|UEV_id account-or-token-id) 
                    )
                )
            )
        )
        (let*
            (
                (keyz:[string] (DPTF-DPMF-ATS|UR_TableKeys table-to-query false))
                (listoflists:[[string]] (map (lambda (x:string) (UTILS.LIST|UC_SplitString UTILS.BAR x)) keyz))
                (output:[string] (UTILS.DALOS|UC_Filterid listoflists account-or-token-id))
            )
            output
        )
    )
    ;;{13}
    ;;
    ;;{14}
    ;;{15}
    (defun DPTF|C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal)
        (with-capability (DPTF|C>TRANSMUTE)
            (DPTF|X_Transmute id transmuter transmute-amount)
            (if (not (and (= id (DALOS.DALOS|UR_UnityID))(>= transmute-amount 10)))
                (DALOS.IGNIS|C_CollectWT patron transmuter (DALOS.DALOS|UR_UsagePrice "ignis|smallest") (DALOS.IGNIS|URC_ZeroGAS id transmuter))
                true
            )
        )
    )
    (defun DPTF|C_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (with-capability (DPTF|C>TRANSFER id sender receiver transfer-amount method)
            (DPTF|X_Transfer id sender receiver transfer-amount method)
            (if (not (and (= id (DALOS.DALOS|UR_UnityID))(>= transfer-amount 10)))
                (DALOS.IGNIS|C_CollectWT patron sender (DALOS.DALOS|UR_UsagePrice "ignis|smallest") (DALOS.IGNIS|URC_ZeroGAZ id sender receiver))
                true
            )
        )
    )
    (defun DPTF|C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        (with-capability (SECURE)
            (let
                (
                    (pair-validation:bool (DPTF|UEV_Pair_ID-Amount id-lst transfer-amount-lst))
                )
                (enforce (= pair-validation true) "Input Lists <id-lst>|<transfer-amount-lst> cannot make a valid pair list for Multi Transfer Processing")
                (let
                    (
                        (pair:[object{DPTF|ID-Amount}] (DPTF|UDC_Pair_ID-Amount id-lst transfer-amount-lst))
                    )
                    (map (lambda (x:object{DPTF|ID-Amount}) (DPTF|X_MultiTransferPaired patron sender receiver x method)) pair)
                )
            )
        )
    )
    (defun DPTF|C_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        (with-capability (SECURE)
            (let
                (
                    (pair-validation:bool (DPTF|UEV_Pair_Receiver-Amount id receiver-lst transfer-amount-lst))
                )
                (enforce (= pair-validation true) "Input Lists <receiver-lst>|<transfer-amount-lst> cannot make a valid pair list with the <id> for Bulk Transfer Processing")
                (let
                    (
                        (pair:[object{DPTF|Receiver-Amount}] (DPTF|UDC_Pair_Receiver-Amount receiver-lst transfer-amount-lst))
                    )
                    (map (lambda (x:object{DPTF|Receiver-Amount}) (DPTF|X_BulkTransferPaired patron id sender x method)) pair)
                )
            )
        )
    )
    ;;{16}
    (defun DPTF|X_Transmute (id:string transmuter:string transmute-amount:decimal)
        (require-capability (DPTF|C>TRANSMUTE))
        (DPTF.DPTF|X_DebitStandard id transmuter transmute-amount)
        (DPTF|X_CreditPrimaryFee id transmute-amount false)
    )
    (defun DPTF|X_Transfer (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (require-capability (DPTF|C>TRANSFER id sender receiver transfer-amount method))
        (DPTF.DPTF|X_DebitStandard id sender transfer-amount)
        (let*
            (
                (ea-id:string (DALOS.DALOS|UR_EliteAurynID))
                (fee-toggle:bool (DPTF.DPTF|UR_FeeToggle id))
                (iz-exception:bool (DPTF.DPTF|URC_TrFeeMinExc id sender receiver))
                (fees:[decimal] (DPTF.DPTF|URC_Fee id transfer-amount))
                (primary-fee:decimal (at 0 fees))
                (secondary-fee:decimal (at 1 fees))
                (remainder:decimal (at 2 fees))
                (iz-full-credit:bool 
                    (or 
                        (or 
                            (= fee-toggle false) 
                            (= iz-exception true)
                        ) 
                        (= primary-fee 0.0)
                    )
                )
            )
            (if iz-full-credit
                (DPTF.DPTF|X_Credit id receiver transfer-amount)
                (if (= secondary-fee 0.0)
                    (do
                        (DPTF|X_CreditPrimaryFee id primary-fee true)
                        (DPTF.DPTF|X_Credit id receiver remainder)
                    )
                    (do
                        (DPTF|X_CreditPrimaryFee id primary-fee true)
                        (DPTF.DPTF|X_Credit id DALOS.DALOS|SC_NAME secondary-fee)
                        (DPTF.DPTF|X_UpdateFeeVolume id secondary-fee false)
                        (DPTF.DPTF|X_Credit id receiver remainder)
                    )
                )
            )
            (DPMF.BASIS|X_UpdateElite id sender receiver)
        )
    )
    (defun DPTF|X_CreditPrimaryFee (id:string pf:decimal native:bool)
        (let
            (
                (rt:bool (DPTF.DPTF|URC_IzRT id))
                (rbt:bool (DPTF.DPTF|URC_IzRBT id))
                (target:string (DPTF.DPTF|UR_FeeTarget id))
            )
            (if (and rt rbt)
                (let*
                    (
                        (v:[decimal] (TFT|CPF_RT-RBT id pf))
                        (v1:decimal (at 0 v))
                        (v2:decimal (at 1 v))
                        (v3:decimal (at 2 v))
                    )
                    (DPTF|X_CPF_StillFee id target v1)
                    (DPTF|X_CPF_CreditFee id target v2)
                    (DPTF|X_CPF_BurnFee id target v3)
                )
                (if rt
                    (let*
                        (
                            (v1:decimal (TFT|CPF_RT id pf))
                            (v2:decimal (- pf v1))
                        )
                        (DPTF|X_CPF_StillFee id target v1)
                        (DPTF|X_CPF_CreditFee id target v2)
                    )
                    (if rbt
                        (let*
                            (
                                (v1:decimal (TFT|CPF_RBT id pf))
                                (v2:decimal (- pf v1))
                            )
                            (DPTF|X_CPF_StillFee id target v1)
                            (DPTF|X_CPF_BurnFee id target v2)
                        )
                        (DPTF.DPTF|X_Credit id target pf false)
                    )
                )
            )
        )
        (if native
            (DPTF.DPTF|X_UpdateFeeVolume id pf true)
            true
        )
    )
    (defun DPTF|X_CPF_StillFee (id:string target:string still-fee:decimal)
        (require-capability (DPTF|CPF_STILL-FEE))
        (if (!= still-fee 0.0)
            (DPTF.DPTF|X_Credit id target still-fee)
            true
        )
    )
    (defun DPTF|X_CPF_BurnFee (id:string target:string burn-fee:decimal)
        (require-capability (DPTF|CPF_BURN-FEE))
        (if (!= burn-fee 0.0)
            (do
                (DPTF.DPTF|X_Credit id ATS.ATS|SC_NAME burn-fee)
                (DPTF.DPTF|X_Burn id ATS.ATS|SC_NAME burn-fee)
            )
            true
        )
    )
    (defun DPTF|X_CPF_CreditFee (id:string target:string credit-fee:decimal)
        (require-capability (DPTF|CPF_CREDIT-FEE))
        (if (!= credit-fee 0.0)
            (DPTF.DPTF|X_Credit id ATS.ATS|SC_NAME credit-fee)
            true
        )
    )
    (defun DPTF|X_MultiTransferPaired (patron:string sender:string receiver:string id-amount-pair:object{DPTF|ID-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (id:string (at "id" id-amount-pair))
                (amount:decimal (at "amount" id-amount-pair))
            )
            (DPTF|C_Transfer patron id sender receiver amount method)
        )
    )
    (defun DPTF|X_BulkTransferPaired (patron:string id:string sender:string receiver-amount-pair:object{DPTF|Receiver-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (receiver:string (at "receiver" receiver-amount-pair))
                (amount:decimal (at "amount" receiver-amount-pair))
            )
            (DPTF|C_Transfer patron id sender receiver amount method)
        )
    )
)

(create-table P|T)