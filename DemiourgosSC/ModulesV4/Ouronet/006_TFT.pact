;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface TrueFungibleTransfer
    @doc "Exposes DPTF Related Transfer Functions. Due to the complex nature of the DPTF Transfer \
    \ a whole module had to be dedicated to it, as a mere DPTF Transfer has to take following parameters into account: \
    \   *] If the DPTF is part of ATS Pair, and if so, specific to its setup, how it must be handeld \
    \   *] If Transfer Fees are in place, and if so, where they must be redirected, als o tying in the ATSPair involvement \
    \   *] When handling OUROBOROS, take note of Ouro-Dispo mechanics, which tie into the Elite-Account \
    \ Also includes Multi and Bulk Transfer Functions. Commented Functions are internal module only.\
    \ No alphabetic sorting for the functions, to better observe their connections"
    ;;
    (defun DPTF-DPMF-ATS|UR_TableKeys:[string] (position:integer poi:bool))
    (defun DPTF-DPMF-ATS|UR_FilterKeysForInfo:[string] (account-or-token-id:string table-to-query:integer mode:bool))
    ;;
    (defun URC_MinimumOuro:decimal (account:string))
    ;;
    (defun UDC_GetDispoData:object{UtilityDptf.DispoData} (account:string))
    (defun UDC_BulkTransferICO:object{OuronetDalos.IgnisCumulator} (id:string transfer-amount-lst:[decimal] sender:string receiver-lst:[string]))
    (defun UDC_MultiTransferICO:object{OuronetDalos.IgnisCumulator} (id-lst:[string] transfer-amount-lst:[decimal] sender:string receiver:string))
    ;;
    (defun C_ClearDispo:object{OuronetDalos.IgnisCumulator} (patron:string account:string))
    (defun C_Transmute:object{OuronetDalos.IgnisCumulator} (patron:string id:string transmuter:string transmute-amount:decimal))
    ;;
    (defun C_Transfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool))
    (defun C_ExemptionTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool))
    (defun XB_FeelesTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool))
    ;;
    (defun C_MultiTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
    (defun C_ExemptionMultiTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
    (defun XE_FeelesMultiTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
    ;;
    (defun C_BulkTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool))
    (defun C_ExemptionBulkTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool))
    (defun XE_FeelesBulkTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool))
    ;;
    (defpact C_BulkTransfer81-160 (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool))
    (defpact C_BulkTransfer41-80 (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool))
    (defpact C_BulkTransfer13-40 (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool))
    ;;
    (defpact C_MultiTransfer41-80 (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
    (defpact C_MultiTransfer13-40 (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
)
(module TFT GOV
    ;;
    (implements OuronetPolicy)
    (implements TrueFungibleTransfer)
    ;;{G1}
    (defconst GOV|MD_TFT            (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TFT_ADMIN)))
    (defcap GOV|TFT_ADMIN ()        (enforce-guard GOV|MD_TFT))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    ;;{P3}
    (defcap P|TFT|CALLER ()
        true
    )
    (defcap P|ATS|REMOTE-GOV ()
        @doc "Autostake Remote Governor Capability"
        true
    )
    (defcap P|DALOS|REMOTE-GOV ()
        @doc "Dalos Remote Governor Capability"
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|TFT|CALLER))
        (compose-capability (SECURE))
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
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
            )
            (ref-P|DALOS::P|A_Add 
                "TFT|<"
                (create-capability-guard (P|TFT|CALLER))
            )
            (ref-P|BRD::P|A_Add 
                "TFT|<"
                (create-capability-guard (P|TFT|CALLER))
            )
            (ref-P|DPTF::P|A_Add 
                "TFT|<"
                (create-capability-guard (P|TFT|CALLER))
            )
            (ref-P|DPMF::P|A_Add 
                "TFT|<"
                (create-capability-guard (P|TFT|CALLER))
            )
            (ref-P|ATS::P|A_Add 
                "TFT|<"
                (create-capability-guard (P|TFT|CALLER))
            )
            (ref-P|DALOS::P|A_Add
                "TFT|RemoteDalosGov"
                (create-capability-guard (P|DALOS|REMOTE-GOV))
            )
            (ref-P|ATS::P|A_Add
                "TFT|RemoteAtsGov"
                (create-capability-guard (P|ATS|REMOTE-GOV))
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
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defun CT_EmptyIgnisCumulator ()(let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::DALOS|EmptyIgCum)))
    (defconst BAR                   (CT_Bar))
    (defconst EIC                   (CT_EmptyIgnisCumulator))
    ;;
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    (defcap DPTF|S>EA-DISPO-LOCKER (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ouro-amount:decimal (ref-DALOS::UR_TF_AccountSupply account true))
            )
            (enforce (not (< ouro-amount 0.0)) "When Account has negative OURO, Elite-Auryn is dispo-locked and cannot be moved")
        )
    )
    ;;{C3}
    ;;{C4}
    (defcap DPTF|C>CLEAR-DISPO (account:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                (ouro-amount:decimal (ref-DALOS::UR_TF_AccountSupply account true))
            )
            (enforce (< ouro-amount 0.0) "Dispo Clear requires Negative OURO")
            (compose-capability (P|DALOS|REMOTE-GOV))
            (compose-capability (P|ATS|REMOTE-GOV))
            (compose-capability (P|SECURE-CALLER))
        )
    )
    ;;Transmute
    (defcap DPTF|C>TRANSMUTE (id:string transmuter:string)
        @event
        (compose-capability (DPTF|C>X_TRANSMUTE id transmuter))
    )
    (defcap DPTF|C>X_TRANSMUTE (id:string transmuter:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
            )
            (if (= id ea-id)
                (compose-capability (DPTF|S>EA-DISPO-LOCKER transmuter))
                true
            )
            (compose-capability (P|SECURE-CALLER))
        )
    )
    ;;Transfer
    (defcap DPTF|C>TRANSFER (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
                (ats-sc:string (ref-DALOS::GOV|ATS|SC_NAME))
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
            (compose-capability (DPTF|C>X_TRANSMUTE id sender))
        )
    )
    ;;Bulk-Transfer
    (defcap DPTF|PACT|C>BULK-TRANSFER (id:string sender:string)
        @event
        (compose-capability (DPTF|C>X_TRANSMUTE id sender))    
    )
    (defcap DPTF|C>BULK-TRANSFER (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @event
        (UEV_BulkTransfer id sender receiver-lst transfer-amount-lst method)
        (compose-capability (DPTF|C>X_TRANSMUTE id sender))    
    )
    ;;Multi-Transfer
    (defcap DPTF|PACT|C>MULTI-TRANSFER (id-lst:[string] sender:string)
        @event
        (compose-capability (DPTF|C>X_MULTI-TRANSFER id-lst sender))
    )
    (defcap DPTF|C>MULTI-TRANSFER (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @event
        (UEV_MultiTransfer id-lst sender receiver transfer-amount-lst method)
        (compose-capability (DPTF|C>X_MULTI-TRANSFER id-lst sender))
    )
    (defcap DPTF|C>X_MULTI-TRANSFER (id-lst:[string] sender:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
            )
            (map
                (lambda
                    (idx:integer)
                    (if (!= (at idx id-lst) ea-id)
                        (compose-capability (DPTF|S>EA-DISPO-LOCKER sender))
                        true
                    )
                )
                (enumerate 0 (- (length id-lst) 1))
            )
            (compose-capability (P|SECURE-CALLER))
        )
    )
    ;;;;;;;New Multi Transfer Validation
    
    ;;
    ;;{F0}
    (defun ATS|URC_RT-Unbonding (atspair:string reward-token:string)
        @doc "Computes the Unbonding Amount existing for a given <reward-token> of an <atspair>; \
        \ Similar to (ATS.UR_RT-Data atspair reward-token 3); \
        \ Instead of reading the Data directly from the ATS Pair, scans all Unstaking Accounts for <reward-toke> \
        \ and adds found balances up. \
        \ Output of these 2 functions must match to the last decimal."
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (ref-ATS::UEV_RewardTokenExistance atspair reward-token true)
            (fold
                (lambda
                    (acc:decimal account:string)
                    (+ acc (ref-ATS::URC_AccountUnbondingBalance atspair account reward-token))
                )
                0.0
                (DPTF-DPMF-ATS|UR_FilterKeysForInfo atspair 3 false)
            )
        )
    )
    (defun DPTF-DPMF-ATS|UR_OwnedTokens (account:string table-to-query:integer)
        @doc "Returns a List of DPTF, DPMF or ATS-Unstaking-Accounts that exist for <account> \
        \ <table-to-query>: 1 = DPTF, 2 = DPMF, 3 = ATS-Unstaking-Accounts"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ref-ATS:module{Autostake} ATS)
            )
            (ref-U|INT::UEV_PositionalVariable table-to-query 3 "Invalid Ownership Position")
            (let
                (
                    (keyz:[string] (DPTF-DPMF-ATS|UR_TableKeys table-to-query true))
                    (owners-lst:[string]
                        (fold
                            (lambda
                                (acc:[string] item:string)
                                (ref-U|LST::UC_AppendLast 
                                    acc
                                    (if (= table-to-query 1)
                                        (ref-DPTF::UR_Konto item)
                                        (if (= table-to-query 2)
                                            (ref-DPMF::UR_Konto item)
                                            (ref-ATS::UR_OwnerKonto item)
                                        )
                                    )
                                )
                            )
                            []
                            keyz
                        )
                    )
                    (owner-pos:[integer] (ref-U|LST::UC_Search owners-lst account))
                )
                (fold
                    (lambda
                        (acc:[string] idx:integer)
                        (ref-U|LST::UC_AppendLast acc (at (at idx owner-pos) keyz))
                    )
                    []
                    (enumerate 0 (- (length owner-pos) 1))
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
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
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
            (let
                (
                    (keyz:[string] (DPTF-DPMF-ATS|UR_TableKeys table-to-query false))
                    (listoflists:[[string]] (map (lambda (x:string) (ref-U|LST::UC_SplitString BAR x)) keyz))
                    (output:[string] (ref-U|DALOS::UC_FilterId listoflists account-or-token-id))
                )
                output
            )
        )
    )
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
    ;;{F1}
    (defun URC_CPF_RT-RBT:[decimal] (id:string native-fee-amount:decimal)
        (let
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
                (let
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
                                                    (ref-ATS::XE_UpdateRoU (at index rt-ats-pairs) id true true (at index split-with-truths))
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
        (let
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
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-ATS:module{Autostake} ATS)
                (ats-pairs:[string] (ref-DPTF::UR_RewardToken id))
                (ats-pairs-bool:[bool] (URC_NFR-Boolean_RT-RBT id ats-pairs true))
                (milestones:integer (length (ref-U|LST::UC_Search ats-pairs-bool true)))  
            )
            (if (!= milestones 0)
                (let
                    (
                        (rt-split-with-boolean:[decimal] (URC_BooleanDecimalCombiner id native-fee-amount milestones ats-pairs-bool))
                        (number-of-zeroes:integer (length (ref-U|LST::UC_Search rt-split-with-boolean 0.0)))
                    )
                    (map
                        (lambda
                            (index:integer)
                            (if (at index ats-pairs-bool)
                                (ref-ATS::XE_UpdateRoU (at index ats-pairs) id true true (at index rt-split-with-boolean))
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
                (ref-U|ATS:module{UtilityAts} U|ATS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (prec:integer (ref-DPTF::UR_Decimals id))
            )
            (ref-U|ATS::UC_SplitBalanceWithBooleans prec amount milestones boolean)
        )
    )
    ;;{F2}
    ;;Bulk
    (defun UEV_BulkTransfer (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Complete Bulk Transfer Validations"
        (UEV_BulkTransferSingleData id sender)
        (UEV_BulkTransferMultiData id sender receiver-lst transfer-amount-lst method)
    )
    (defun UEV_BulkTransferSingleData (id:string sender:string)
        @doc "Bulk Transfer Validation for single Data"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership sender)
            (ref-DPTF::UEV_PauseState id false)
            (ref-DPTF::UEV_AccountFreezeState id sender false)
        )
    )
    (defun UEV_BulkTransferMultiData (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Bulk Transfer Validation for Multi Data"
        (UEV_BulkTransferMapper (UDC_Pair_Receiver-Amount receiver-lst transfer-amount-lst) sender id method)
    )
    (defun UEV_BulkTransferMapper (ra-obj:[object{DPTF|Receiver-Amount}] sender:string id:string method:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (tra:integer (ref-DPTF::UR_TransferRoleAmount id))
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
                (s:bool (ref-DPTF::UR_AccountRoleTransfer id sender))
                (l:integer (length ra-obj))
            )
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (receiver:string (at "receiver" (at idx ra-obj)))
                            (ta:decimal (at "amount" (at idx ra-obj)))
                            (r:bool (ref-DPTF::UR_AccountRoleTransfer id receiver))
                            (r-type:bool (ref-DALOS::UR_AccountType receiver))
                        )
                        (if
                            (and
                                (> tra 0) 
                                (not (or (= sender ouroboros)(= sender dalos)))
                            )
                            (enforce-one
                                (format "Neither the sender {} nor the receiver {} have an active transfer role" [sender receiver])
                                [
                                    (enforce (= s true) (format "TR doesnt check for sender {}" [sender]))
                                    (enforce (= r true) (format "TR doesnt check for receiver {}" [receiver]))
                                ]
        
                            )
                            (format "No transfer restrictions for {} from {} to {}" [id sender receiver])
                        )
                        (ref-DALOS::UEV_EnforceTransferability sender receiver method)
                        (ref-DPTF::UEV_Amount id ta)
                        (ref-DPTF::UEV_AccountFreezeState id receiver false)
                        (ref-DPTF::UEV_EnforceMinimumAmount id ta)
                        (enforce (not r-type) "Bulk Transfer does not work to target Smart Dalos Account")
                    )
                )
                (enumerate 0 (- l 1))
            )
        )
    )
    ;;Multi
    (defun UEV_MultiTransfer (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @doc "Complete Multi Transfer Validations"
        (UEV_MultiTransferSingleData sender receiver method)
        (UEV_MultiTransferMultiData id-lst sender receiver transfer-amount-lst)
    )
    (defun UEV_MultiTransferSingleData (sender:string receiver:string method:bool)
        @doc "Multi Transfer Validation for single Data"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (r-type:bool (ref-DALOS::UR_AccountType receiver))
            )
            (ref-DALOS::CAP_EnforceAccountOwnership sender)
            (if (and method r-type)
                (ref-DALOS::CAP_EnforceAccountOwnership receiver)
                true
            )
            (ref-DALOS::UEV_EnforceTransferability sender receiver method)
        )
    )
    (defun UEV_MultiTransferMultiData (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal])
        @doc "Multi Transfer Validation for Multi Data"
        (UEV_MultiTransferMapper (UDC_Pair_ID-Amount id-lst transfer-amount-lst) sender receiver)
    )
    (defun UEV_MultiTransferMapper (pid-obj:[object{DPTF|ID-Amount}] sender:string receiver:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (l:integer (length pid-obj))
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
            )
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (id:string (at "id" (at idx pid-obj)))
                            (ta:decimal (at "amount" (at idx pid-obj)))
                            (tra:integer (ref-DPTF::UR_TransferRoleAmount id))
                            (s:bool (ref-DPTF::UR_AccountRoleTransfer id sender))
                            (r:bool (ref-DPTF::UR_AccountRoleTransfer id receiver))
                            (iz-exception:bool (ref-DPTF::URC_TrFeeMinExc id sender receiver))
                        )
                        (if
                            (and
                                (> tra 0) 
                                (not (or (= sender ouroboros)(= sender dalos)))
                            )
                            (enforce-one
                                (format "Neither the sender {} nor the receiver {} have an active transfer role" [sender receiver])
                                [
                                    (enforce s (format "TR doesnt check for sender {}" [sender]))
                                    (enforce r (format "TR doesnt check for receiver {}" [receiver]))
                                ]
                            )
                            (format "No transfer restrictions for {} from {} to {}" [id sender receiver])
                        )
                        (if (not iz-exception)
                            (ref-DPTF::UEV_EnforceMinimumAmount id ta)
                            true
                        )
                        (ref-DPTF::UEV_Amount id ta)
                        (ref-DPTF::UEV_PauseState id false)
                        (ref-DPTF::UEV_AccountFreezeState id sender false)
                        (ref-DPTF::UEV_AccountFreezeState id receiver false)
                    )
                )
                (enumerate 0 (- l 1))
            )
        )
    )
    ;;{F3}
    (defun URC_MinimumOuro:decimal (account:string)
        @doc "Computes the minimum Negative Ouroboros amount an Account is able to overconsume"
        (let
            (
                (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                (dispo-data:object{UtilityDptf.DispoData} (UDC_GetDispoData account))
                (max-dispo:decimal (ref-U|DPTF::UC_OuroDispo dispo-data))
            )
            (- 0.0 max-dispo)
        )
    )
    (defun UDC_GetDispoData:object{UtilityDptf.DispoData} (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-ATS:module{Autostake} ATS)
                (a-id:string (ref-DALOS::UR_AurynID))
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                (auryndex:string (at 0 (ref-DPTF::UR_RewardToken ouro-id)))
                (elite-auryndex:string (at 0 (ref-DPTF::UR_RewardToken a-id)))
            )
            {"elite-auryn-amount"           :(ref-DPTF::UR_AccountSupply ea-id account)
            ,"auryndex-value"               :(ref-ATS::URC_Index auryndex)
            ,"elite-auryndex-value"         :(ref-ATS::URC_Index elite-auryndex)
            ,"major-tier"                   :(ref-DALOS::UR_Elite-Tier-Major account)
            ,"minor-tier"                   :(ref-DALOS::UR_Elite-Tier-Minor account)
            ,"ouroboros-precision"          :(ref-DPTF::UR_Decimals ouro-id)}
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
    (defun UDC_MakeBulkTransferICO:[object{OuronetDalos.IgnisCumulator}] (id:string transfer-amount-lst:[decimal] sender:string receiver-lst:[string])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (l:integer (length transfer-amount-lst))
                (smallest:decimal (ref-DALOS::UR_UsagePrice "ignis|smallest"))
            )
            (fold
                (lambda
                    (acc:[object{OuronetDalos.IgnisCumulator}] idx:integer)
                    (let
                        (
                            (transfer-amount:decimal (at idx transfer-amount-lst))
                            (receiver:string (at idx receiver-lst))
                            (price:decimal
                                (if (not (and (= id (ref-DALOS::UR_UnityID))(>= transfer-amount 10)))
                                    smallest
                                    0.0
                                )
                            )
                            (trigger:bool (ref-DALOS::IGNIS|URC_ZeroGAZ id sender receiver))
                            (ico:object{OuronetDalos.IgnisCumulator}
                                (ref-DALOS::UDC_Cumulator price trigger [])
                            )
                        )
                        (ref-U|LST::UC_AppL acc ico)
                    )
                )
                []
                (enumerate 0 (- l 1))
            )
        )
    )
    (defun UDC_MakeMultiTransferICO:[object{OuronetDalos.IgnisCumulator}] (id-lst:[string] transfer-amount-lst:[decimal] sender:string receiver:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (l:integer (length transfer-amount-lst))
                (smallest:decimal (ref-DALOS::UR_UsagePrice "ignis|smallest"))
            )
            (fold
                (lambda
                    (acc:[object{OuronetDalos.IgnisCumulator}] idx:integer)
                    (let
                        (
                            (id:string (at idx id-lst))
                            (transfer-amount:decimal (at idx transfer-amount-lst))
                            (price:decimal
                                (if (not (and (= id (ref-DALOS::UR_UnityID))(>= transfer-amount 10)))
                                    smallest
                                    0.0
                                )
                            )
                            (trigger:bool (ref-DALOS::IGNIS|URC_ZeroGAZ id sender receiver))
                            (ico:object{OuronetDalos.IgnisCumulator}
                                (ref-DALOS::UDC_Cumulator price trigger [])
                            )
                        )
                        (ref-U|LST::UC_AppL acc ico)
                    )
                )
                []
                (enumerate 0 (- l 1))
            )
        )
    )
    (defun UDC_BulkTransferICO:object{OuronetDalos.IgnisCumulator} (id:string transfer-amount-lst:[decimal] sender:string receiver-lst:[string])
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (bt-ico:[object{OuronetDalos.IgnisCumulator}] (UDC_MakeBulkTransferICO id transfer-amount-lst sender receiver-lst))
                (price:decimal (ref-DALOS::UDC_AddICO bt-ico))
                (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
            )
            (ref-DALOS::UDC_Cumulator price trigger [])
        )
    )
    (defun UDC_MultiTransferICO:object{OuronetDalos.IgnisCumulator} (id-lst:[string] transfer-amount-lst:[decimal] sender:string receiver:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (mt-ico:[object{OuronetDalos.IgnisCumulator}] (UDC_MakeMultiTransferICO id-lst transfer-amount-lst sender receiver))
                (price:decimal (ref-DALOS::UDC_AddICO mt-ico))
                (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
            )
            (ref-DALOS::UDC_Cumulator price trigger [])
        )
    )
    ;;{F4}
    ;;
    ;;{F5}
    ;;{F6}
    (defun C_ClearDispo:object{OuronetDalos.IgnisCumulator} (patron:string account:string)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (DPTF|C>CLEAR-DISPO account)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-ATS:module{Autostake} ATS)

                    (ouro-id:string (ref-DALOS::UR_OuroborosID))
                    (a-id:string (ref-DALOS::UR_AurynID))
                    (ea-id:string (ref-DALOS::UR_EliteAurynID))
                    (ouro-amount:decimal (abs (ref-DPTF::UR_AccountSupply ouro-id account)))
                    (account-ea-supply:decimal (ref-DPTF::UR_AccountSupply ea-id account))
                    (frozen-state:bool (ref-DPTF::UR_AccountFrozenState ea-id account))

                    (auryndex:string (at 0 (ref-DPTF::UR_RewardToken ouro-id)))
                    (elite-auryndex:string (at 0 (ref-DPTF::UR_RewardToken a-id)))
                    (auryndex-value:decimal (ref-ATS::URC_Index auryndex))
                    (elite-auryndex-value:decimal (ref-ATS::URC_Index elite-auryndex))

                    (o-prec:integer (ref-DPTF::UR_Decimals ouro-id))
                    (a-prec:integer (ref-DPTF::UR_Decimals a-id))
                    (ea-prec:integer (ref-DPTF::UR_Decimals ea-id))

                    (burn-auryn-amount:decimal (floor (/ ouro-amount auryndex-value) a-prec))
                    (burn-elite-auryn-amount:decimal (floor (/ burn-auryn-amount elite-auryndex-value) ea-prec))
                    (total-ea:decimal (floor (* burn-elite-auryn-amount 2.5) ea-prec))
                    (ea-remint:decimal (- account-ea-supply total-ea))
                    (ats-sc:string (ref-DALOS::GOV|ATS|SC_NAME))

                    ;;Ignis Cumulation
                    (ico1:object{OuronetDalos.IgnisCumulator}
                        (if (not frozen-state)
                            (ref-DPTF::C_ToggleFreezeAccount patron ea-id account true)
                            EIC
                        )
                    )
                    (ico2:object{OuronetDalos.IgnisCumulator}
                        (ref-DPTF::C_Wipe patron ea-id account)
                    )
                    (ico3:object{OuronetDalos.IgnisCumulator}
                        (ref-DPTF::C_Mint patron ea-id ats-sc ea-remint false)
                    )
                    (ico4:object{OuronetDalos.IgnisCumulator}
                        (ref-DPTF::C_ToggleFreezeAccount patron ea-id account false)
                    )
                    (ico5:object{OuronetDalos.IgnisCumulator}
                        (XB_FeelesTransfer patron ea-id ats-sc account ea-remint true)
                    )
                    (ico6:object{OuronetDalos.IgnisCumulator}
                        (ref-DPTF::C_Burn patron a-id ats-sc burn-auryn-amount)
                    )
                    (ico7:object{OuronetDalos.IgnisCumulator}
                        (ref-DPTF::C_Burn patron ouro-id ats-sc ouro-amount)
                    )
                )
            ;;1] Freeze EA on account
                ;;via ico1
            ;;2] Wipe EA on account
                ;;via ico2
            ;;3] Remint remaining EA
                ;;via ico3
            ;;4] Unfreeze EA on account
                ;;via ico4
            ;;5] Transfer it back to account
                ;;via ico5
            ;;6] <ATS|SC-NAME> burns <burn-auryn-amount> Auryn amount and decrease Resident Amount by it on <elite-auryndex>
                ;via ico6
                (ref-ATS::XE_UpdateRoU elite-auryndex a-id true false burn-auryn-amount)
            ;;7] <ATS|SC-NAME> burns <ouro-amount> OURO amount and decrease Resident Amount by it on <auryndex>
                ;;via ico7
                (ref-ATS::XE_UpdateRoU auryndex ouro-id true false ouro-amount)
            ;;8] Finally clears dispo setting OURO <acount> amount to zero
                (ref-DALOS::XE_ClearDispo account)
            ;;9] Pleasure doing business with you !
                (ref-DALOS::UDC_CompressICO [ico1 ico2 ico3 ico4 ico5 ico6 ico7] [])
            )
        )
    )
    ;;Client Transmute
    (defun C_Transmute:object{OuronetDalos.IgnisCumulator} (patron:string id:string transmuter:string transmute-amount:decimal)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|smallest"))
                (trigger:bool (ref-DALOS::IGNIS|URC_ZeroGAS id transmuter))
            )
            (with-capability (DPTF|C>TRANSMUTE id transmuter)
                (XI_Transmute id transmuter transmute-amount)
                (ref-DALOS::UDC_Cumulator price trigger [])
            )
        )
    )
    ;;Client Transfer
    (defun C_Transfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|smallest"))
                (trigger:bool (ref-DALOS::IGNIS|URC_ZeroGAZ id sender receiver))
            )
            (with-capability (DPTF|C>TRANSFER id sender receiver transfer-amount method)
                (XI_Transfer id sender receiver transfer-amount method)
                (ref-DALOS::UDC_Cumulator price trigger [])
            )
        )
    )
    (defun C_ExemptionTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|smallest"))
                (trigger:bool (ref-DALOS::IGNIS|URC_ZeroGAZ id sender receiver))
            )
            (with-capability (DPTF|C>TRANSFER id sender receiver transfer-amount method)
                (XI_ExemptionTransfer id sender receiver transfer-amount method)
                (ref-DALOS::UDC_Cumulator price trigger [])
            )
        )
    )
    (defun XB_FeelesTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "ATSU|<"))
                (enforce-guard (P|UR "VST|<"))
                (enforce-guard (P|UR "LIQUID|<"))
                (enforce-guard (P|UR "OUROBOROS|<"))
                (enforce-guard (P|UR "SWP|<"))
                (enforce-guard (P|UR "SWPU|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|smallest"))
                (trigger:bool (ref-DALOS::IGNIS|URC_ZeroGAZ id sender receiver))
            )
            (with-capability (DPTF|C>TRANSFER id sender receiver transfer-amount method)
                (XI_SimpleTransfer id sender receiver transfer-amount method)
                (ref-DALOS::UDC_Cumulator price trigger [])
            )
        )
    )
    ;;Client Multi Transfer
    (defun C_MultiTransferAsPactStep (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        (require-capability (SECURE))
        (with-capability (DPTF|PACT|C>MULTI-TRANSFER id-lst sender)
            (map (lambda (x:object{DPTF|ID-Amount}) (XIH_MultiTransfer sender receiver x method)) (UDC_Pair_ID-Amount id-lst transfer-amount-lst))
        )
    )
    (defun C_MultiTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (DPTF|C>MULTI-TRANSFER id-lst sender receiver transfer-amount-lst method)
            (map (lambda (x:object{DPTF|ID-Amount}) (XIH_MultiTransfer sender receiver x method)) (UDC_Pair_ID-Amount id-lst transfer-amount-lst))
            (UDC_MultiTransferICO id-lst transfer-amount-lst sender receiver)
        )
    )
    (defun C_ExemptionMultiTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (DPTF|C>MULTI-TRANSFER id-lst sender receiver transfer-amount-lst method)
            (map (lambda (x:object{DPTF|ID-Amount}) (XIH_ExemptionMultiTransfer sender receiver x method)) (UDC_Pair_ID-Amount id-lst transfer-amount-lst))
            (UDC_MultiTransferICO id-lst transfer-amount-lst sender receiver)
        )
    )    
    (defun XE_FeelesMultiTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (P|UR "ATSU|<"))
                (enforce-guard (P|UR "SWP|<"))
                (enforce-guard (P|UR "SWPU|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (with-capability (DPTF|C>MULTI-TRANSFER id-lst sender receiver transfer-amount-lst method)
            (map (lambda (x:object{DPTF|ID-Amount}) (XIH_FeelesMultiTransfer sender receiver x method)) (UDC_Pair_ID-Amount id-lst transfer-amount-lst))
            (UDC_MultiTransferICO id-lst transfer-amount-lst sender receiver)
        )
    )
    ;;Client Bulk Transfer
    (defun C_BulkTransferAsPactStep (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        (require-capability (SECURE))
        (with-capability (DPTF|PACT|C>BULK-TRANSFER id sender)
            (map (lambda (x:object{DPTF|Receiver-Amount}) (XIH_BulkTransfer id sender x method)) (UDC_Pair_Receiver-Amount receiver-lst transfer-amount-lst))
        )
    )
    (defun C_BulkTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Works"
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (DPTF|C>BULK-TRANSFER id sender receiver-lst transfer-amount-lst method)
            (map (lambda (x:object{DPTF|Receiver-Amount}) (XIH_BulkTransfer id sender x method)) (UDC_Pair_Receiver-Amount receiver-lst transfer-amount-lst))
            (UDC_BulkTransferICO id transfer-amount-lst sender receiver-lst)
        )
    )
    (defun C_ExemptionBulkTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (DPTF|C>BULK-TRANSFER id sender receiver-lst transfer-amount-lst method)
            (map (lambda (x:object{DPTF|Receiver-Amount}) (XIH_ExemptionBulkTransfer id sender x method)) (UDC_Pair_Receiver-Amount receiver-lst transfer-amount-lst))
            (UDC_BulkTransferICO id transfer-amount-lst sender receiver-lst)
        )
    )
    (defun XE_FeelesBulkTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (P|UR "SWPU|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (with-capability (DPTF|C>BULK-TRANSFER id sender receiver-lst transfer-amount-lst method)
            (map (lambda (x:object{DPTF|Receiver-Amount}) (XIH_FeelesBulkTransfer id sender x method)) (UDC_Pair_Receiver-Amount receiver-lst transfer-amount-lst))
            (UDC_BulkTransferICO id transfer-amount-lst sender receiver-lst)
        )
    )
    ;;{F7}
    ;;Auxiliary Transmute
    (defun XI_Transmute (id:string transmuter:string transmute-amount:decimal)
        (require-capability (DPTF|C>TRANSMUTE id transmuter))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (dispo-data:object{UtilityDptf.DispoData} (UDC_GetDispoData transmuter))
            )
            (ref-DPTF::XB_DebitStandard id transmuter transmute-amount dispo-data)
            (XI_CreditPrimaryFee id transmute-amount false)
        )
    )
    ;;Auxiliary Transfer
    (defun XI_Transfer (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (fee-toggle:bool (ref-DPTF::UR_FeeToggle id))
                (iz-exception:bool (ref-DPTF::URC_TrFeeMinExc id sender receiver))
                (iz-full-credit:bool 
                    (or 
                        (= fee-toggle false) 
                        (= iz-exception true)
                    )
                )
            )
            (if iz-full-credit
                (XI_SimpleTransfer id sender receiver transfer-amount method)
                (XI_ComplexTransfer id sender receiver transfer-amount method)
            )
        ) 
    )
    (defun XI_ExemptionTransfer (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (sender-fee-exemption:bool (ref-DPTF::UR_AccountRoleFeeExemption id sender))
                (receiver-fee-exemption:bool (ref-DPTF::UR_AccountRoleFeeExemption id receiver))
                (iz-exception:bool (or sender-fee-exemption receiver-fee-exemption))
            )
            (if iz-exception
                (XI_SimpleTransfer id sender receiver transfer-amount method)
                true
            )
        )
    )
    (defun XI_SimpleTransfer (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Simple Transfer no GAS"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (dispo-data:object{UtilityDptf.DispoData} (UDC_GetDispoData sender))
            )
            (ref-DPTF::XB_DebitStandard id sender transfer-amount dispo-data)
            (ref-DPTF::XB_Credit id receiver transfer-amount)
            (ref-DPMF::XB_UpdateElite id sender receiver)
        )
    )
    (defun XI_ComplexTransfer (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (dispo-data:object{UtilityDptf.DispoData} (UDC_GetDispoData sender))
            )
            (ref-DPTF::XB_DebitStandard id sender transfer-amount dispo-data)
            (XI_ComplexCredit id receiver transfer-amount)
            (ref-DPMF::XB_UpdateElite id sender receiver)
        )
    )
    (defun XI_ComplexCredit (id:string receiver:string transfer-amount:decimal)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
                (fees:[decimal] (ref-DPTF::URC_Fee id transfer-amount))
                (primary-fee:decimal (at 0 fees))
                (secondary-fee:decimal (at 1 fees))
                (remainder:decimal (at 2 fees))
            )
            (if (= secondary-fee 0.0)
                    (do
                        (XI_CreditPrimaryFee id primary-fee true)
                        (ref-DPTF::XB_Credit id receiver remainder)
                    )
                    (do
                        (XI_CreditPrimaryFee id primary-fee true)
                        (ref-DPTF::XB_Credit id dalos secondary-fee)
                        (ref-DPTF::XE_UpdateFeeVolume id secondary-fee false)
                        (ref-DPTF::XB_Credit id receiver remainder)
                    )
                )
        )
    )
    ;;Auxiliary Multi Transfer
    (defun XIH_MultiTransfer (sender:string receiver:string id-amount-pair:object{DPTF|ID-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (id:string (at "id" id-amount-pair))
                (amount:decimal (at "amount" id-amount-pair))
            )
            (XI_Transfer id sender receiver amount method)
        )
    )
    (defun XIH_ExemptionMultiTransfer (sender:string receiver:string id-amount-pair:object{DPTF|ID-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (id:string (at "id" id-amount-pair))
                (amount:decimal (at "amount" id-amount-pair))
            )
            (XI_ExemptionTransfer id sender receiver amount method)
        )
    )
    (defun XIH_FeelesMultiTransfer (sender:string receiver:string id-amount-pair:object{DPTF|ID-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (id:string (at "id" id-amount-pair))
                (amount:decimal (at "amount" id-amount-pair))
            )
            (XI_SimpleTransfer id sender receiver amount method)
        )
    )
    ;;Auxiliary Bulk Transfer
    (defun XIH_BulkTransfer (id:string sender:string receiver-amount-pair:object{DPTF|Receiver-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (receiver:string (at "receiver" receiver-amount-pair))
                (amount:decimal (at "amount" receiver-amount-pair))
            )
            (XI_Transfer id sender receiver amount method)
        )
    )
    (defun XIH_ExemptionBulkTransfer (id:string sender:string receiver-amount-pair:object{DPTF|Receiver-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (receiver:string (at "receiver" receiver-amount-pair))
                (amount:decimal (at "amount" receiver-amount-pair))
            )
            (XI_ExemptionTransfer id sender receiver amount method)
        )
    )
    (defun XIH_FeelesBulkTransfer (id:string sender:string receiver-amount-pair:object{DPTF|Receiver-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (receiver:string (at "receiver" receiver-amount-pair))
                (amount:decimal (at "amount" receiver-amount-pair))
            )
            (XI_SimpleTransfer id sender receiver amount method)
        )
    )
    ;;Auxiliary Credit Primary Fee
    (defun XI_CreditPrimaryFee (id:string pf:decimal native:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (rt:bool (ref-DPTF::URC_IzRT id))
                (rbt:bool (ref-DPTF::URC_IzRBT id))
                (target:string (ref-DPTF::UR_FeeTarget id))
            )
            (if (and rt rbt)
                (let
                    (
                        (v:[decimal] (URC_CPF_RT-RBT id pf))
                        (v1:decimal (at 0 v))
                        (v2:decimal (at 1 v))
                        (v3:decimal (at 2 v))
                    )
                    (XI_CPF_StillFee id target v1)
                    (XI_CPF_CreditFee id target v2)
                    (XI_CPF_BurnFee id target v3)
                )
                (if rt
                    (let
                        (
                            (v1:decimal (URC_CPF_RT id pf))
                            (v2:decimal (- pf v1))
                        )
                        (XI_CPF_StillFee id target v1)
                        (XI_CPF_CreditFee id target v2)
                    )
                    (if rbt
                        (let
                            (
                                (v1:decimal (URC_CPF_RBT id pf))
                                (v2:decimal (- pf v1))
                            )
                            (XI_CPF_StillFee id target v1)
                            (XI_CPF_BurnFee id target v2)
                        )
                        (ref-DPTF::XB_Credit id target pf false)
                    )
                )
            )
            (if native
                (ref-DPTF::XE_UpdateFeeVolume id pf true)
                true
            )
        )
    )
    (defun XI_CPF_StillFee (id:string target:string still-fee:decimal)
        (require-capability (SECURE))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (if (!= still-fee 0.0)
                (ref-DPTF::XB_Credit id target still-fee)
                true
            )
        )
    )
    (defun XI_CPF_BurnFee (id:string target:string burn-fee:decimal)
        (require-capability (SECURE))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-ATS:module{Autostake} ATS)
                (ats:string (ref-ATS::GOV|ATS|SC_NAME))
            )
            (if (!= burn-fee 0.0)
                (do
                    (ref-DPTF::XB_Credit id ats burn-fee)
                    (ref-DPTF::XE_Burn id ats burn-fee)
                )
                true
            )
        )
    )
    (defun XI_CPF_CreditFee (id:string target:string credit-fee:decimal)
        (require-capability (SECURE))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-ATS:module{Autostake} ATS)
                (ats:string (ref-ATS::GOV|ATS|SC_NAME))
            )
            (if (!= credit-fee 0.0)
                (ref-DPTF::XB_Credit id ats credit-fee)
                true
            )
        )
    )
    ;;Extended Bulk Transfer
    (defpact C_BulkTransfer81-160
        (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Transfer 81-160 DPTFs in Bulk or 41-80 Elite Auryns in Bulk"

        ;;Steps 0|1|2|3 Validation in 4 Steps
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (UEV_BulkTransfer 
                    id sender 
                    (take v0 receiver-lst) 
                    (take v0 transfer-amount-lst)
                    method
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                )
                (UEV_BulkTransfer 
                    id sender 
                    (take v1 (drop v0 receiver-lst)) 
                    (take v1 (drop v0 transfer-amount-lst)) 
                    method
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (+ v0 v1))
                )
                (UEV_BulkTransfer 
                    id sender 
                    (take v2 (drop v3 receiver-lst)) 
                    (take v2 (drop v3 transfer-amount-lst)) 
                    method
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v:integer (fold (+) 0 (drop -1 matrix)))
                )
                (UEV_BulkTransfer 
                    id sender 
                    (drop v receiver-lst)
                    (drop v transfer-amount-lst)
                    method
                )
            )
        )
        ;;Step 4 Collects the required IGNIS
        (step
            (XC_IgnisCollect patron sender [(UDC_BulkTransferICO id transfer-amount-lst sender receiver-lst)])
        )
        ;;Step 5|6|7|8|9|10|11|12 BulkTransfer
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep 
                        patron id sender 
                        (take v0 receiver-lst) 
                        (take v0 transfer-amount-lst) 
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep 
                        patron id sender 
                        (take v1 (drop v0 receiver-lst))
                        (take v1 (drop v0 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (+ v0 v1))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep 
                        patron id sender 
                        (take v2 (drop v3 receiver-lst))
                        (take v2 (drop v3 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (at 3 matrix))
                    (v4:integer (fold (+) 0 [v0 v1 v2]))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep 
                        patron id sender 
                        (take v3 (drop v4 receiver-lst))
                        (take v3 (drop v4 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (at 3 matrix))
                    (v4:integer (at 4 matrix))
                    (v5:integer (fold (+) 0 [v0 v1 v2 v3]))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep 
                        patron id sender 
                        (take v4 (drop v5 receiver-lst))
                        (take v4 (drop v5 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (at 3 matrix))
                    (v4:integer (at 4 matrix))
                    (v5:integer (at 5 matrix))
                    (v6:integer (fold (+) 0 [v0 v1 v2 v3 v4]))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep 
                        patron id sender 
                        (take v5 (drop v6 receiver-lst))
                        (take v5 (drop v6 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (at 3 matrix))
                    (v4:integer (at 4 matrix))
                    (v5:integer (at 5 matrix))
                    (v6:integer (at 6 matrix))
                    (v7:integer (fold (+) 0 [v0 v1 v2 v3 v4 v5]))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep 
                        patron id sender 
                        (take v6 (drop v7 receiver-lst))
                        (take v6 (drop v7 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v:integer (fold (+) 0 (drop -1 matrix)))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep 
                        patron id sender 
                        (drop v receiver-lst)
                        (drop v transfer-amount-lst)
                        method
                    )
                )
            )
        )
    )
    (defpact C_BulkTransfer41-80
        (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Transfer 41-80 DPTFs in Bulk or 21-40 Elite Auryns in Bulk"

        ;;Steps 0|1 Validation in 2 Steps
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (UEV_BulkTransfer 
                    id sender 
                    (take v0 receiver-lst) 
                    (take v0 transfer-amount-lst)
                    method
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v1:integer (at 1 matrix))
                )
                (UEV_BulkTransfer 
                    id sender 
                    (drop v1 receiver-lst)
                    (drop v1 transfer-amount-lst)
                    method
                )
            )
        )
        ;;Step 2 Collects the required IGNIS
        (step
            (XC_IgnisCollect patron sender [(UDC_BulkTransferICO id transfer-amount-lst sender receiver-lst)])
        )
        ;;Step 3|4|5|6 BulkTransfer
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep 
                        patron id sender 
                        (take v0 receiver-lst) 
                        (take v0 transfer-amount-lst) 
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep 
                        patron id sender 
                        (take v1 (drop v0 receiver-lst))
                        (take v1 (drop v0 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (+ v0 v1))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep 
                        patron id sender 
                        (take v2 (drop v3 receiver-lst))
                        (take v2 (drop v3 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v:integer (fold (+) 0 (drop -1 matrix)))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep 
                        patron id sender 
                        (drop v receiver-lst)
                        (drop v transfer-amount-lst)
                        method
                    )
                )
            )
        )
    )
    (defpact C_BulkTransfer13-40
        (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Transfer 13-40 DPTFs in Bulk or 9-20 Elite Auryns in Bulk"

        ;;Steps 0 Validation in 1 Step
        (step
            (UEV_BulkTransfer id sender receiver-lst transfer-amount-lst method)
        )
        ;;Step 1 Collects the required IGNIS
        (step
            (XC_IgnisCollect patron sender [(UDC_BulkTransferICO id transfer-amount-lst sender receiver-lst)])
        )
        ;;Step 2|3 BulkTransfer
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep 
                        patron id sender 
                        (take v0 receiver-lst) 
                        (take v0 transfer-amount-lst) 
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v1:integer (at 1 matrix))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep 
                        patron id sender 
                        (drop v1 receiver-lst)
                        (drop v1 transfer-amount-lst)
                        method
                    )
                )
            )
        )
    )
    ;;Extended Multi Transfer
    (defpact C_MultiTransfer41-80
        (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @doc "Multi Transfers 15-40 DPTFs"

        ;;Steps 0|1 Validation in 2 Steps
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (UEV_MultiTransfer
                    (take v0 id-lst)
                    sender receiver
                    (take v0 transfer-amount-lst)
                    method
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v1:integer (at 1 matrix))
                )
                (UEV_MultiTransfer 
                    (drop v1 id-lst)
                    sender receiver
                    (drop v1 transfer-amount-lst)
                    method
                )
            )
        )
        ;;Step 2 Collects the required IGNIS
        (step
            (XC_IgnisCollect patron sender [(UDC_MultiTransferICO id-lst transfer-amount-lst sender receiver)])
        )
        ;;Step 3|4|5|6 BulkTransfer
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (with-capability (SECURE)
                    (C_MultiTransferAsPactStep 
                        patron
                        (take v0 id-lst)
                        sender receiver
                        (take v0 transfer-amount-lst) 
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                )
                (with-capability (SECURE)
                    (C_MultiTransferAsPactStep 
                        patron
                        (take v1 (drop v0 id-lst))
                        sender receiver
                        (take v1 (drop v0 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (+ v0 v1))
                )
                (with-capability (SECURE)
                    (C_MultiTransferAsPactStep 
                        patron
                        (take v2 (drop v3 id-lst))
                        sender receiver
                        (take v2 (drop v3 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v:integer (fold (+) 0 (drop -1 matrix)))
                )
                (with-capability (SECURE)
                    (C_MultiTransferAsPactStep 
                        patron
                        (drop v id-lst)
                        sender receiver
                        (drop v transfer-amount-lst)
                        method

                    )
                )
            )
        )
    )
    (defpact C_MultiTransfer13-40
        (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @doc "Multi Transfers 13-40 DPTFs"

        ;;Steps 0 Validation in 1 Step
        (step
            (UEV_MultiTransfer id-lst sender receiver transfer-amount-lst method)
        )
        ;;Step 1 Collects the required IGNIS
        (step
            (XC_IgnisCollect patron sender [(UDC_MultiTransferICO id-lst transfer-amount-lst sender receiver)])
        )
        ;;Step 2|3 BulkTransfer
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (with-capability (SECURE)
                    (C_MultiTransferAsPactStep
                        patron
                        (take v0 id-lst)
                        sender receiver
                        (take v0 transfer-amount-lst) 
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v1:integer (at 1 matrix))
                )
                (with-capability (SECURE)
                    (C_MultiTransferAsPactStep 
                        patron
                        (drop v1 id-lst)
                        sender receiver
                        (drop v1 transfer-amount-lst) 
                        method
                    )
                )
            )
        )
    )

    (defun XC_IgnisCollect (patron:string account:string input-ico:[object{OuronetDalos.IgnisCumulator}])
        @doc "Collects Ignis given input parameters"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ignis:decimal (ref-DALOS::UDC_AddICO input-ico))
            )
            (if (!= ignis 0.0)
                (ref-DALOS::IGNIS|C_Collect patron account ignis)
                true
            )
        )
    )
)

(create-table P|T)