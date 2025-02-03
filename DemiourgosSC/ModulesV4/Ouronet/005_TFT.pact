;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module TFT GOV
    ;;
    (implements OuronetPolicy)
    (implements TrueFungibleTransfer)
    ;;{G1}
    (defconst GOV|MD_TFT            (keyset-ref-guard DALOS|DEMIURGOI))
    (defconst DALOS|DEMIURGOI       (GOV|Demiurgoi))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|TFT_ADMIN))
    )
    (defcap GOV|TFT_ADMIN ()
        (enforce-guard GOV|MD_TFT)
    )
    ;;{G3}
    (defun GOV|Demiurgoi ()
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::GOV|Demiurgoi)
        )
    )
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
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
        (let
            (
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
            )
            (ref-P|DALOS::P|A_Add 
                "TFT|UpdateElite"
                (create-capability-guard (P|DALOS|UP_ELT))
            )
            (ref-P|DPTF::P|A_Add 
                "TFT|Debit"
                (create-capability-guard (P|DPTF|DEBIT))
            )
            (ref-P|DPTF::P|A_Add 
                "TFT|Credit"
                (create-capability-guard (P|DPTF|CREDIT))
            )
            (ref-P|DPTF::P|A_Add 
                "TFT|UpdateFees"
                (create-capability-guard (P|T|UF))
            )
            (ref-P|DPTF::P|A_Add
                "TFT|Burn"
                (create-capability-guard (P|DPTF|BURN))
            )
            (ref-P|ATS::P|A_Add
                "TFT|UpdateROU"
                (create-capability-guard (P|ATS|UP_ROU))
            )
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
    (defun CT_Bar ()
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
            )
            (ref-U|CT::CT_BAR)
        )
    )
    (defconst BAR (CT_Bar))
    ;;
    ;;{C1}
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
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap DPTF|C>TRANSFER (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
            )
            (ref-DALOS::CAP_EnforceAccountOwnership sender)
            (if (and method (ref-DALOS::UR_AccountType receiver))
                (ref-DALOS::CAP_EnforceAccountOwnership receiver)
                true
            )
            (ref-DPTF::UEV_Amount id transfer-amount)
            (if (not (ref-DPTF::URC_TrFeeMinExc id sender receiver))
                (ref-DPTF::UEV_EnforceMinimumAmount id transfer-amount)
                true
            )
            (ref-DALOS::UEV_EnforceTransferability sender receiver method)
            (ref-DPTF::UEV_PauseState id false)
            (ref-DPTF::UEV_AccountFreezeState id sender false)
            (ref-DPTF::UEV_AccountFreezeState id receiver false)
            (if 
                (and 
                    (> (ref-DPTF::UR_TransferRoleAmount id) 0) 
                    (not (or (= sender ouroboros)(= sender dalos)))
                )
                (let
                    (
                        (s:bool (ref-DPTF::UR_AccountRoleTransfer id sender))
                        (r:bool (ref-DPTF::UR_AccountRoleTransfer id receiver))
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
    ;;{F0}
    (defun DPTF-DPMF-ATS|UR_TableKeys:[string] (position:integer poi:bool)
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ref-ATS:module{Autostake} ATS)
            )
            (ref-U|INT::UEV_PositionalVariable position 3 "Invalid Ownership Position")
            (if poi
                (if (= position 1)
                    (ref-DPTF::UR_P-KEYS)
                    (if (= position 2)
                        (ref-DPMF::UR_P-KEYS)
                        (ref-ATS::UR_P-KEYS)
                    )
                )
                (if (= position 1)
                    (ref-DPTF::UR_KEYS)
                    (if (= position 2)
                        (ref-DPMF::UR_KEYS)
                        (ref-ATS::UR_KEYS)
                    )
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
            \ 1 (DPTF|BalanceTable), 2(DPMF|BalanceTable), 3(ATS|Ledger)"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-U|DALOS:module{Ouronet4Dalos} U|DALOS)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ref-ATS:module{Autostake} ATS)
            )
            (ref-U|INT::UEV_PositionalVariable table-to-query 3 "Table To Query can only be 1 2 or 3")
            (if mode
                (ref-DALOS::GLYPH|UEV_DalosAccount account-or-token-id)
                (do
                    (if (= table-to-query 1)
                        (ref-DPTF::UEV_id account-or-token-id)
                        (if (= table-to-query 2)
                            (ref-DPMF::UEV_id account-or-token-id)
                            (ref-ATS::UEV_id account-or-token-id) 
                        )
                    )
                )
            )
            (let*
                (
                    (keyz:[string] (DPTF-DPMF-ATS|UR_TableKeys table-to-query false))
                    (listoflists:[[string]] (map (lambda (x:string) (ref-U|LST::UC_SplitString BAR x)) keyz))
                    (output:[string] (ref-U|DALOS::UC_FilterId listoflists account-or-token-id))
                )
                output
            )
        )
        
    )
    ;;{F1}
    (defun URC_CPF_RT-RBT:[decimal] (id:string native-fee-amount:decimal)
        (let*
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-ATS:module{Autostake} ATS)
                (rt-ats-pairs:[string] (ref-DPTF::UR_RewardToken id))
                (rbt-ats-pairs:[string] (ref-DPTF::UR_RewardBearingToken id))
                (length-rt:integer (length rt-ats-pairs))
                (length-rbt:integer (length rbt-ats-pairs))
                (rt-boolean:[bool] (URC_NFR-Boolean_RT-RBT id rt-ats-pairs true))
                (rbt-boolean:[bool] (URC_NFR-Boolean_RT-RBT id rbt-ats-pairs false))
                (rt-milestones:integer (length (ref-U|LST::UC_Search rt-boolean true)))
                (rbt-milestones:integer (length (ref-U|LST::UC_Search rbt-boolean true)))
                (milestones:integer (+ rt-milestones rbt-milestones))
            )
            (if (!= milestones 0)
                (let*
                    (
                        (truths:[bool] (+ rt-boolean rbt-boolean))
                        (split-with-truths:[decimal] (URC_BooleanDecimalCombiner id native-fee-amount milestones truths))
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
                                                    (ref-ATS::X_UpdateRoU (at index rt-ats-pairs) id true true (at index split-with-truths))
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
    (defun URC_CPF_RBT:decimal (id:string native-fee-amount:decimal)
        (let*
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ats-pairs:[string] (ref-DPTF::UR_RewardBearingToken id))
                (ats-pairs-bool:[bool] (URC_NFR-Boolean_RT-RBT id ats-pairs false))
                (milestones:integer (length (ref-U|LST::UC_Search ats-pairs-bool true)))
            )
            (if (!= milestones 0)
                0.0
                native-fee-amount
            )
        )
    )
    (defun URC_CPF_RT:decimal (id:string native-fee-amount:decimal)
        (let*
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-ATS:module{Autostake} ATS)
                (ats-pairs:[string] (ref-DPTF::UR_RewardToken id))
                (ats-pairs-bool:[bool] (URC_NFR-Boolean_RT-RBT id ats-pairs true))
                (milestones:integer (length (ref-U|LST::UC_Search ats-pairs-bool true)))  
            )
            (if (!= milestones 0)
                (let*
                    (
                        (rt-split-with-boolean:[decimal] (URC_BooleanDecimalCombiner id native-fee-amount milestones ats-pairs-bool))
                        (number-of-zeroes:integer (length (ref-U|LST::UC_Search rt-split-with-boolean 0.0)))
                    )
                    (map
                        (lambda
                            (index:integer)
                            (if (at index ats-pairs-bool)
                                (ref-ATS::X_UpdateRoU (at index ats-pairs) id true true (at index rt-split-with-boolean))
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
    (defun URC_NFR-Boolean_RT-RBT:[bool] (id:string ats-pairs:[string] rt-or-rbt:bool)
        @doc "Makes a [bool] using RT or RBT <nfr> values from a list of ATS Pair"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-ATS:module{Autostake} ATS)
            )
            (fold
                (lambda
                    (acc:[bool] index:integer)
                    (if rt-or-rbt
                        (if (ref-ATS::UR_RT-Data (at index ats-pairs) id 1)
                            (ref-U|LST::UC_AppL acc true)
                            (ref-U|LST::UC_AppL acc false)
                        )
                        (if (ref-ATS::UR_ColdNativeFeeRedirection (at index ats-pairs))
                            (ref-U|LST::UC_AppL acc true)
                            (ref-U|LST::UC_AppL acc false)
                        )
                    )
                )
                []
                (enumerate 0 (- (length ats-pairs) 1))
            )
        )
    )
    (defun URC_BooleanDecimalCombiner:[decimal] (id:string amount:decimal milestones:integer boolean:[bool])
        (let
            (
                (ref-U|ATS:module{Ouronet4Ats} U|ATS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (prec:integer (ref-DPTF::UR_Decimals id))
            )
            (ref-U|ATS::UC_SplitBalanceWithBooleans prec amount milestones boolean)
        )
    )
    ;;{F2}
    (defun UEV_AmountCheck:bool (id:string amount:decimal)
        (let*
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (decimals:integer (ref-DPTF::UR_Decimals id))
                (decimal-check:bool (if (= (floor amount decimals) amount) true false))
                (positivity-check:bool (if (> amount 0.0) true false))
                (result:bool (and decimal-check positivity-check))
            )
            result
        )
    )
    (defun UEV_Pair_ID-Amount:bool (id-lst:[string] transfer-amount-lst:[decimal])
        (fold
            (lambda
                (acc:bool item:object{DPTF|ID-Amount})
                (and acc (UEV_AmountCheck (at "id" item) (at "amount" item)))
            )
            true
            (UDC_Pair_ID-Amount id-lst transfer-amount-lst)
        )
    )
    (defun UEV_Pair_Receiver-Amount:bool (id:string receiver-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DPTF::UEV_id id)
            (and
                (fold
                    (lambda
                        (acc:bool item:object{DPTF|Receiver-Amount})
                        (let*
                            (
                                (receiver-account:string (at "receiver" item))
                                (receiver-check:bool (ref-DALOS::GLYPH|UEV_DalosAccountCheck receiver-account))
                            )
                            (and acc receiver-check)
                        )
                    )
                    true
                    (UDC_Pair_Receiver-Amount receiver-lst transfer-amount-lst)
                )
                (fold
                    (lambda
                        (acc:bool item:object{DPTF|Receiver-Amount})
                        (let*
                            (
                                (transfer-amount:decimal (at "amount" item))
                                (check:bool (UEV_AmountCheck id transfer-amount))
                            )
                            (and acc check)
                        )
                    )
                    true
                    (UDC_Pair_Receiver-Amount receiver-lst transfer-amount-lst)
                )
            )
        )
    )
    ;;{F3}
    (defun UDC_Pair_ID-Amount:[object{DPTF|ID-Amount}] (id-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (id-length:integer (length id-lst))
                (amount-length:integer (length transfer-amount-lst))
            )
            (enforce (= id-length amount-length) "ID and Transfer-Amount Lists are not of equal length")
            (zip (lambda (x:string y:decimal) { "id": x, "amount": y }) id-lst transfer-amount-lst)
        )
    )
    (defun UDC_Pair_Receiver-Amount:[object{DPTF|Receiver-Amount}] (receiver-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (receiver-length:integer (length receiver-lst))
                (amount-length:integer (length transfer-amount-lst))
            )
            (enforce (= receiver-length amount-length) "Receiver and Transfer-Amount Lists are not of equal length")
            (zip (lambda (x:string y:decimal) { "receiver": x, "amount": y }) receiver-lst transfer-amount-lst)
        )
    )
    ;;{F4}
    ;;
    ;;{F5}
    ;;{F6}
    (defun C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal)
        @doc "Transmutes a DPTF Token. Transmuting behaves as fee collection, without counting as such \
            \ Therefore Transmuting, pumps the Index of all ATS Pair the Token is Part of, if proper fee settings are set up in said ATSPairs"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|C>TRANSMUTE)
                (X_Transmute id transmuter transmute-amount)
                (if (not (and (= id (ref-DALOS::UR_UnityID))(>= transmute-amount 10)))
                    (ref-DALOS::IGNIS|C_CollectWT patron transmuter (ref-DALOS::DALOS|UR_UsagePrice "ignis|smallest") (ref-DALOS::IGNIS|URC_ZeroGAS id transmuter))
                    true
                )
            )
        )
    )
    (defun C_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Transfers a DPTF Token"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|C>TRANSFER id sender receiver transfer-amount method)
                (X_Transfer id sender receiver transfer-amount method)
                (if (not (and (= id (ref-DALOS::UR_UnityID))(>= transfer-amount 10)))
                    (ref-DALOS::IGNIS|C_CollectWT patron sender (ref-DALOS::UR_UsagePrice "ignis|smallest") (ref-DALOS::IGNIS|URC_ZeroGAZ id sender receiver))
                    true
                )
            )
        )
    )
    (defun C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @doc "Executes a DPTF MultiTransfer, sending multiple DPTF, each with its own amount, to a single receiver"
        (with-capability (SECURE)
            (let
                (
                    (pair-validation:bool (UEV_Pair_ID-Amount id-lst transfer-amount-lst))
                )
                (enforce (= pair-validation true) "Input Lists <id-lst>|<transfer-amount-lst> cannot make a valid pair list for Multi Transfer Processing")
                (let
                    (
                        (pair:[object{DPTF|ID-Amount}] (UDC_Pair_ID-Amount id-lst transfer-amount-lst))
                    )
                    (map (lambda (x:object{DPTF|ID-Amount}) (X_MultiTransferPaired patron sender receiver x method)) pair)
                )
            )
        )
    )
    (defun C_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Executes a Bulk DPTF Transfer, sending one DPTF, to multiple receivers, each with its own amount"
        (with-capability (SECURE)
            (let
                (
                    (pair-validation:bool (UEV_Pair_Receiver-Amount id receiver-lst transfer-amount-lst))
                )
                (enforce (= pair-validation true) "Input Lists <receiver-lst>|<transfer-amount-lst> cannot make a valid pair list with the <id> for Bulk Transfer Processing")
                (let
                    (
                        (pair:[object{DPTF|Receiver-Amount}] (UDC_Pair_Receiver-Amount receiver-lst transfer-amount-lst))
                    )
                    (map (lambda (x:object{DPTF|Receiver-Amount}) (X_BulkTransferPaired patron id sender x method)) pair)
                )
            )
        )
    )
    ;;{F7}
    (defun X_Transmute (id:string transmuter:string transmute-amount:decimal)
        (require-capability (DPTF|C>TRANSMUTE))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DPTF::X_DebitStandard id transmuter transmute-amount)
            (X_CreditPrimaryFee id transmute-amount false)
        )
    )
    (defun X_Transfer (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (require-capability (DPTF|C>TRANSFER id sender receiver transfer-amount method))
        (let*
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
                (fee-toggle:bool (ref-DPTF::UR_FeeToggle id))
                (iz-exception:bool (ref-DPTF::URC_TrFeeMinExc id sender receiver))
                (fees:[decimal] (ref-DPTF::URC_Fee id transfer-amount))
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
            (ref-DPTF::X_DebitStandard id sender transfer-amount)
            (if iz-full-credit
                (ref-DPTF::X_Credit id receiver transfer-amount)
                (if (= secondary-fee 0.0)
                    (do
                        (X_CreditPrimaryFee id primary-fee true)
                        (ref-DPTF::X_Credit id receiver remainder)
                    )
                    (do
                        (X_CreditPrimaryFee id primary-fee true)
                        (ref-DPTF::X_Credit id dalos secondary-fee)
                        (ref-DPTF::X_UpdateFeeVolume id secondary-fee false)
                        (ref-DPTF::X_Credit id receiver remainder)
                    )
                )
            )
            (ref-DPMF::X_UpdateElite id sender receiver)
        )
    )
    (defun X_CreditPrimaryFee (id:string pf:decimal native:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (rt:bool (ref-DPTF::URC_IzRT id))
                (rbt:bool (ref-DPTF::URC_IzRBT id))
                (target:string (ref-DPTF::UR_FeeTarget id))
            )
            (if (and rt rbt)
                (let*
                    (
                        (v:[decimal] (URC_CPF_RT-RBT id pf))
                        (v1:decimal (at 0 v))
                        (v2:decimal (at 1 v))
                        (v3:decimal (at 2 v))
                    )
                    (X_CPF_StillFee id target v1)
                    (X_CPF_CreditFee id target v2)
                    (X_CPF_BurnFee id target v3)
                )
                (if rt
                    (let*
                        (
                            (v1:decimal (URC_CPF_RT id pf))
                            (v2:decimal (- pf v1))
                        )
                        (X_CPF_StillFee id target v1)
                        (X_CPF_CreditFee id target v2)
                    )
                    (if rbt
                        (let*
                            (
                                (v1:decimal (URC_CPF_RBT id pf))
                                (v2:decimal (- pf v1))
                            )
                            (X_CPF_StillFee id target v1)
                            (X_CPF_BurnFee id target v2)
                        )
                        (ref-DPTF::X_Credit id target pf false)
                    )
                )
            )
            (if native
                (ref-DPTF::X_UpdateFeeVolume id pf true)
                true
            )
        )
    )
    (defun X_CPF_StillFee (id:string target:string still-fee:decimal)
        (require-capability (DPTF|CPF_STILL-FEE))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (if (!= still-fee 0.0)
                (ref-DPTF::X_Credit id target still-fee)
                true
            )
        )
    )
    (defun X_CPF_BurnFee (id:string target:string burn-fee:decimal)
        (require-capability (DPTF|CPF_BURN-FEE))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-ATS:module{Autostake} ATS)
                (ats:string (ref-ATS::GOV|ATS|SC_NAME))
            )
            (if (!= burn-fee 0.0)
                (do
                    (ref-DPTF::X_Credit id ats burn-fee)
                    (ref-DPTF::X_Burn id ats burn-fee)
                )
                true
            )
        )
    )
    (defun X_CPF_CreditFee (id:string target:string credit-fee:decimal)
        (require-capability (DPTF|CPF_CREDIT-FEE))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-ATS:module{Autostake} ATS)
                (ats:string (ref-ATS::GOV|ATS|SC_NAME))
            )
            (if (!= credit-fee 0.0)
                (ref-DPTF::X_Credit id ats credit-fee)
                true
            )
        )
    )
    (defun X_MultiTransferPaired (patron:string sender:string receiver:string id-amount-pair:object{DPTF|ID-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (id:string (at "id" id-amount-pair))
                (amount:decimal (at "amount" id-amount-pair))
            )
            (C_Transfer patron id sender receiver amount method)
        )
    )
    (defun X_BulkTransferPaired (patron:string id:string sender:string receiver-amount-pair:object{DPTF|Receiver-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (receiver:string (at "receiver" receiver-amount-pair))
                (amount:decimal (at "amount" receiver-amount-pair))
            )
            (C_Transfer patron id sender receiver amount method)
        )
    )
)

(create-table P|T)