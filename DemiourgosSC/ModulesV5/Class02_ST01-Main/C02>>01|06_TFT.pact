;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module TFT GOV
    ;;
    (implements OuronetPolicy)
    (implements TrueFungibleTransferV7)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_TFT            (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TFT_ADMIN)))
    (defcap GOV|TFT_ADMIN ()        (enforce-guard GOV|MD_TFT))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
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
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|TFT_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|TFT_ADMIN)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (dg:guard (create-capability-guard (SECURE)))
                )
                (with-default-read P|MT P|I
                    {"m-policies" : [dg]}
                    {"m-policies" := mp}
                    (write P|MT P|I
                        {"m-policies" : (ref-U|LST::UC_AppL mp policy-guard)}
                    )
                )
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
                (mg:guard (create-capability-guard (P|TFT|CALLER)))
            )
            (ref-P|DALOS::P|A_Add
                "TFT|RemoteDalosGov"
                (create-capability-guard (P|DALOS|REMOTE-GOV))
            )
            (ref-P|ATS::P|A_Add
                "TFT|RemoteAtsGov"
                (create-capability-guard (P|ATS|REMOTE-GOV))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|DPMF::P|A_AddIMP mg)
            (ref-P|ATS::P|A_AddIMP mg)
        )
    )
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
            )
            (ref-U|G::UEV_Any (P|UR_IMP))
        )
    )
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defun CT_EmptyCumulator        ()(let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::DALOS|EmptyOutputCumulatorV2)))
    (defconst BAR                   (CT_Bar))
    (defconst EOC                   (CT_EmptyCumulator))
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap DPTF|C>CLEAR-DISPO (account:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                (ouro-amount:decimal (ref-DALOS::UR_TF_AccountSupply account true))
                (treasury:string (at 0 (ref-DALOS::UR_DemiurgoiID)))
                (account-type:bool (ref-DALOS::UR_AccountType account))
            )
            (enforce (< ouro-amount 0.0) "Dispo Clear requires Negative OURO")
            (enforce (not account-type) "Standard Dispo can only be cleared on Standard Ouronet Accounts")
            (compose-capability (P|DALOS|REMOTE-GOV))
            (compose-capability (P|ATS|REMOTE-GOV))
            (compose-capability (P|SECURE-CALLER))
        )
    )
    (defcap DPTF|C>TRANSMUTE (id:string transmuter:string amount:decimal)
        @event
        (UEV_TrueFungibleAsEliteAuryn id false)
        (compose-capability (DPTF|C>X-TRANSMUTE id transmuter amount))
    )
    (defcap DPTF|C>ELITE-TRANSMUTE (id:string transmuter:string amount:decimal)
        @event
        (UEV_TrueFungibleAsEliteAuryn id true)
        (UEV_DispoLocker id transmuter)
        (compose-capability (DPTF|C>X-TRANSMUTE id transmuter amount))
    )
    (defcap DPTF|C>X-TRANSMUTE (id:string transmuter:string amount:decimal) 
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (t-type:bool (ref-DALOS::UR_AccountType transmuter))
                (iz-exemp:bool (ref-DPTF::UR_AccountRoleFeeExemption id transmuter))
            )
            (ref-DALOS::CAP_EnforceAccountOwnership transmuter)
            (ref-DPTF::UEV_Amount id amount)
            (ref-DPTF::UEV_PauseState id false)
            (ref-DPTF::UEV_AccountFreezeState id transmuter false)
            (UEV_Minimum id amount)
            (enforce (not iz-exemp) "Accounts with fee exemption cannot transmute")
            (enforce (not t-type) "Only Standard Ouronet Accounts can transmute DPTFs")
            (if (> (ref-DPTF::UR_TransferRoleAmount id) 0)
                (let
                    (
                        (t:bool (ref-DPTF::UR_AccountRoleTransfer id transmuter))
                    )
                    (enforce t (format "For transmuting, Transmuter {} must have the transfer Role on, when TransferRoleAmount is > 0" [transmuter]))
                )
                true
            )
            (compose-capability (P|SECURE-CALLER))
        )
    )
    ;;
    (defcap DPTF|C>CLASS-1-TRANSFER 
        (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @event
        (UEV_IzSimpleTransfer id sender receiver transfer-amount true)
        (UEV_AreTrueFungiblesEliteAurynz id false)
        (UEV_TrueFungibleAsUnity id false)
        (compose-capability (DPTF|C>X-TRANSFER id sender receiver transfer-amount method))
    )
    (defcap DPTF|C>CLASS-1-TRANSFER-UNITY
        (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @event
        (UEV_IzSimpleTransfer id sender receiver transfer-amount true)
        (UEV_AreTrueFungiblesEliteAurynz id false)
        (UEV_TrueFungibleAsUnity id true)
        (compose-capability (DPTF|C>X-TRANSFER id sender receiver transfer-amount method))
    )
    (defcap DPTF|C>CLASS-2-TRANSFER
        (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @event
        (UEV_IzSimpleTransfer id sender receiver transfer-amount false)
        (UEV_AreTrueFungiblesEliteAurynz id false)
        (UEV_TrueFungibleAsUnity id false)
        (UEV_Minimum id transfer-amount)
        (compose-capability (DPTF|C>X-TRANSFER id sender receiver transfer-amount method))
    )
    (defcap DPTF|C>CLASS-2-TRANSFER-UNITY
        (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @event
        (UEV_IzSimpleTransfer id sender receiver transfer-amount false)
        (UEV_AreTrueFungiblesEliteAurynz id false)
        (UEV_TrueFungibleAsUnity id true)
        (UEV_Minimum id transfer-amount)
        (compose-capability (DPTF|C>X-TRANSFER id sender receiver transfer-amount method))
    )
    (defcap DPTF|C>CLASS-2-TRANSFER-ELITE
        (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @event
        (UEV_IzSimpleTransfer id sender receiver transfer-amount true)
        (UEV_AreTrueFungiblesEliteAurynz id true)
        (UEV_DispoLocker id sender)
        (compose-capability (DPTF|C>X-TRANSFER id sender receiver transfer-amount method))
    )
    (defcap DPTF|C>CLASS-3-TRANSFER-ELITE
        (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @event
        (UEV_IzSimpleTransfer id sender receiver transfer-amount false)
        (UEV_AreTrueFungiblesEliteAurynz id true)
        (UEV_DispoLocker id sender)
        (UEV_Minimum id transfer-amount)
        (compose-capability (DPTF|C>X-TRANSFER id sender receiver transfer-amount method))
    )
    ;;
    (defcap DPTF|C>X-TRANSFER
        (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
            )
            (if (and method (ref-DALOS::UR_AccountType receiver))
                (ref-DALOS::CAP_EnforceAccountOwnership receiver)
                true
            )
            (ref-DALOS::CAP_EnforceAccountOwnership sender);
            (ref-DALOS::UEV_EnforceTransferability sender receiver method) ;;x
            (ref-DPTF::UEV_Amount id transfer-amount) ;;x
            (ref-DPTF::UEV_PauseState id false);
            (ref-DPTF::UEV_AccountFreezeState id sender false);
            (ref-DPTF::UEV_AccountFreezeState id receiver false) ;;x
            (UEV_TransferRolesSimple id sender receiver) ;;x
            (compose-capability (P|SECURE-CALLER))
        )
    )
    ;;Bulk
    ;;
    (defcap DPTF|C>CLASS-0-BULK (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @event
        (UEV_VTT id true)
        (UEV_TrueFungibleAsUnity id false)
        (if (not (URC_IzSimpleTransferForBulk id sender))
            (UEV_MinimumMapperForBulk id transfer-amount-lst)
            true
        )
        (compose-capability (DPTF|C>X-BULK-TRANSFER id sender receiver-lst transfer-amount-lst))
    )
    (defcap DPTF|C>CLASS-0-BULK-UNITY (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @event
        (UEV_VTT id true)
        (UEV_TrueFungibleAsUnity id true)
        (if (not (URC_IzSimpleTransferForBulk id sender))
            (UEV_MinimumMapperForBulk id transfer-amount-lst)
            true
        )
        (compose-capability (DPTF|C>X-BULK-TRANSFER id sender receiver-lst transfer-amount-lst))
    )
    (defcap DPTF|C>CLASS-1-BULK (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @event
        (UEV_VTT id false)
        (UEV_IzSimpleTransferForBulk id sender true)
        (compose-capability (DPTF|C>X-BULK-TRANSFER id sender receiver-lst transfer-amount-lst))
    )
    (defcap DPTF|C>CLASS-2-BULK (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @event
        (UEV_VTT id false)
        (UEV_IzSimpleTransferForBulk id sender false)
        (UEV_MinimumMapperForBulk id transfer-amount-lst)
        (compose-capability (DPTF|C>X-BULK-TRANSFER id sender receiver-lst transfer-amount-lst))
    )
    (defcap DPTF|C>CLASS-2-BULK-ELITE (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @event
        (UEV_VTT id false)
        (UEV_DispoLocker id sender)
        (UEV_AreTrueFungiblesEliteAurynz id true)
        (UEV_IzSimpleTransferForBulk id sender true)
        (compose-capability (DPTF|C>X-BULK-TRANSFER id sender receiver-lst transfer-amount-lst))
    )
    (defcap DPTF|C>CLASS-3-BULK-ELITE (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @event
        (UEV_VTT id false)
        (UEV_DispoLocker id sender)
        (UEV_AreTrueFungiblesEliteAurynz id true)
        (UEV_IzSimpleTransferForBulk id sender false)
        (compose-capability (DPTF|C>X-BULK-TRANSFER id sender receiver-lst transfer-amount-lst))
    )
    ;;
    (defcap DPTF|C>X-BULK-TRANSFER
        (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        (UEV_BulkTransfer id sender receiver-lst transfer-amount-lst)
        (compose-capability (P|SECURE-CALLER))
    )
    ;;Multi
    (defcap DPTF|C>MULTI-TRANSFER
        (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @event
        (compose-capability (DPTF|C>X-MULTI-TRANSFER id-lst sender receiver transfer-amount-lst method))
    )
    (defcap DPTF|C>X-MULTI-TRANSFER
        (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        (UEV_MultiTransfer id-lst sender receiver transfer-amount-lst method)
        (compose-capability (P|SECURE-CALLER))
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_TransferCumulator:object{IgnisCollector.OutputCumulator}
        (type:integer id:string sender:string receiver:string)
        (cond
            ((contains type [1 2]) (UDC_SmallTransferCumulator id sender receiver))
            ((contains type [3 4 5]) (UDC_MediumTransferCumulator id sender receiver))
            ((= type 6) (UDC_LargeTransferCumulator sender receiver))
            EOC
        )
    )
    (defun UC_BulkRemainders:[decimal] (id:string transfer-amount-lst:[decimal])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
            )
            (fold
                (lambda
                    (acc:[decimal] idx:integer)
                    (ref-U|LST::UC_AppL acc (at 2 (ref-DPTF::URC_Fee id (at idx transfer-amount-lst))))
                )
                []
                (enumerate 0 (- (length transfer-amount-lst) 1))
            )
        )
    )
    (defun UC_BulkFees:[decimal] (id:string transfer-amount-lst:[decimal])
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
            )
            (fold
                (lambda
                    (acc:[decimal] idx:integer)
                    (zip (+) acc (ref-DPTF::URC_Fee id (at idx transfer-amount-lst)))
                )
                [0.0 0.0 0.0]
                (enumerate 0 (- (length transfer-amount-lst) 1))
            )
        )
    )
    (defun UC_ContainsEliteAurynz:bool (id-lst:[string])
        (fold
            (lambda
                (acc:bool idx:integer)
                (or acc (URC_AreTrueFungiblesEliteAurynz (at idx id-lst)))
            )
            false
            (enumerate 0 (- (length id-lst) 1))
        )
    )
    ;;{F0}  [UR]
    (defun DPTF-DPMF-ATS|UR_OwnedTokens (account:string table-to-query:integer)
        @doc "Returns a List of DPTF, DPMF or ATS-Unstaking-Accounts that exist for <account> \
        \ <table-to-query>: 1 = DPTF, 2 = DPMF, 3 = ATS-Unstaking-Accounts"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                (ref-ATS:module{AutostakeV4} ATS)
            )
            (ref-U|INT::UEV_PositionalVariable table-to-query 3 "Invalid Ownership Position")
            (let
                (
                    (keyz:[string] (DPTF-DPMF-ATS|UR_TableKeys table-to-query true))
                    (owners-lst:[string]
                        (fold
                            (lambda
                                (acc:[string] item:string)
                                (ref-U|LST::UC_AppL
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
                    (l:integer (length owner-pos))
                )
                (if (!= l 0)
                    (fold
                        (lambda
                            (acc:[string] idx:integer)
                            (ref-U|LST::UC_AppL acc (at (at idx owner-pos) keyz))
                        )
                        []
                        (enumerate 0 (- (length owner-pos) 1))
                    )
                    []
                )
            )
        )
    )
    (defun DPTF|URC_GetOwnedSupplies (id:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-U|LST:module{StringProcessor} U|LST)
                (accounts:[string] (DPTF-DPMF-ATS|UR_FilterKeysForInfo id 1 false))
                (l:integer (length accounts))
            )
            (fold
                (lambda
                    (acc:[decimal] idx:integer)
                    (ref-U|LST::UC_AppL acc (ref-DPTF::UR_AccountSupply id (at idx accounts)))
                )
                []
                (enumerate 0 (- l 1))
            )
        )
    )
    (defun DPTF-DPMF-ATS|UR_FilterKeysForInfo:[string] (account-or-token-id:string table-to-query:integer mode:bool)
        @doc "Returns a List of either: \
            \       Direct-Mode(true):      <account-or-token-id> is <account> Name: \
            \                               Returns True-Fungible, Meta-Fungible IDs or ATS-Pairs held by Account <account> OR \
            \       Inverse-Mode(false):    <account-or-token-id> is DPTF|DPMF|ATS-Pair Designation Name \
            \                               Returns Accounts that exists for a specific True-Fungible, Meta-Fungible or ATS-Pair \
            \       MODE Boolean is only used for proper validation, to accees the needed table, use the proper integer: \
            \ Table-to-query: \
            \ 1 (DPTF|BalanceTable), 2(DPMF|BalanceTable), 3(ATS|Ledger)"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                (ref-ATS:module{AutostakeV4} ATS)
            )
            (ref-U|INT::UEV_PositionalVariable table-to-query 3 "Table To Query can only be 1 2 or 3")
            (if mode
                (ref-DALOS::GLYPH|UEV_DalosAccount account-or-token-id)
                (if (= table-to-query 1)
                    (ref-DPTF::UEV_id account-or-token-id)
                    (if (= table-to-query 2)
                        (ref-DPMF::UEV_id account-or-token-id)
                        (ref-ATS::UEV_id account-or-token-id)
                    )
                )
            )
            (let
                (
                    (keyz:[string] (DPTF-DPMF-ATS|UR_TableKeys table-to-query false))
                    (listoflists:[[string]] (map (lambda (x:string) (ref-U|LST::UC_SplitString BAR x)) keyz))
                    (output:[string]
                        (if mode
                            (ref-U|DALOS::UC_DirectFilterId listoflists account-or-token-id)
                            (ref-U|DALOS::UC_InverseFilterId listoflists account-or-token-id)
                        )
                        
                    )
                )
                output
            )
        )
    )
    (defun DPTF-DPMF-ATS|UR_TableKeys:[string] (position:integer poi:bool)
        (let
            (
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                (ref-ATS:module{AutostakeV4} ATS)
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
    ;;{F1}  [URC]
    (defun ATS|URC_RT-Unbonding (atspair:string reward-token:string)
        @doc "Computes the Unbonding Amount existing for a given <reward-token> of an <atspair>; \
        \ Similar to (ATS.UR_RT-Data atspair reward-token 3); \
        \ Instead of reading the Data directly from the ATS Pair, scans all Unstaking Accounts for <reward-token> \
        \ and adds found balances up. \
        \ Output of these 2 functions must match to the last decimal."
        (let
            (
                (ref-ATS:module{AutostakeV4} ATS)
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
    (defun URC_MinimumOuro:decimal (account:string)
        @doc "Computes the minimum Negative Ouroboros amount an Account is able to overconsume \
        \ Using the Standard Dispo mechanics"
        (let
            (
                (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (dispo-data:object{UtilityDptf.DispoData} (UDC_GetDispoData account))
                (max-dispo:decimal (ref-U|DPTF::UC_OuroDispo dispo-data))
                (account-type:bool (ref-DALOS::UR_AccountType account))
            )
            (if account-type
                0.0
                (- 0.0 max-dispo)
            )
        )
    )
    (defun URC_VirtualOuro:decimal (account:string)
        @doc "Computes the Account Virtual Ouro. \
            \ The Virtual Ouro is the maximum Ouro the Account is able to spend"
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                (ouro:decimal (ref-DPTF::UR_AccountSupply ouro-id account))
                (smart-treasury:string (at 0 (ref-DALOS::UR_DemiurgoiID)))
                (zero:decimal 
                    (if (= account smart-treasury)
                        (ref-DPTF::URC_TreasuryLowestDispo)
                        (URC_MinimumOuro account)
                    )
                ) 
            )
            (+ (abs zero) ouro)
        )
    )
    ;;
    (defun URC_ReceiverAmount:decimal (id:string sender:string receiver:string amount:decimal)
        @doc "Computes the amount the <receiver> gets"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                ;;
                (tc:integer (URC_TransferClasses id sender receiver amount))
            )
            (if (contains tc [1 2 5])
                amount
                (at 2 (ref-DPTF::URC_Fee id amount))
            )
        )
    )
    (defun URC_UnityTransferIgnisPrice (transfer-amount:decimal)
        @doc "UNITY will only be used with Complex Transfers, as it will have a VTT"
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (if (<= transfer-amount 10.0) (ref-DALOS::UR_UsagePrice "ignis|small") 0.0)
        )
    )
    (defun URC_TransferClasses:integer (id:string sender:string receiver:string amount:decimal)
        @doc "Computes the Transfer Class \
        \ Class 1   : [DPTF|C>CLASS-1-TRANSFER]         [1]     Simple (T)\
        \           : [DPTF|C>CLASS-1-TRANSFER-UNITY]   [2]     Free Unity (T) \
        \ Class 2   : [DPTF|C>CLASS-2-TRANSFER]         [3]     Complex (T + F) \
        \           : [DPTF|C>CLASS-2-TRANSFER-UNITY]   [4]     Unity (T + F) \
        \           : [DPTF|C>CLASS-2-TRANSFER-ELITE]   [5]     Free Elite (T + U) \
        \ Class 3   : [DPTF|C>CLASS-3-TRANSFER-ELITE]   [6]     Elite (T + F + U)"
        (let
            (
                (iz-simple-transfer:bool (URC_IzSimpleTransfer id sender receiver amount))
                (are-e:bool (URC_AreTrueFungiblesEliteAurynz id))
                (iz-un:bool (URC_IzTrueFungibleUnity id))
            )
            (if iz-simple-transfer
                (if are-e 5 (if iz-un 2 1))
                (if are-e 6 (if iz-un 4 3))
            )
        )
    )
    (defun URC_TransferClassesForBulk:integer
        (id:string sender:string)
        @doc "Computes the Bulk Transfer Class, assuming Elite Auryns will never have VTT \
        \ Class 0   : VTT (Volumetric Transfer Tax) Class \
        \           : [DPTF|C>CLASS-0-BULK]             [1]     (T + vF) Variable Fee \
        \           : [DPTF|C>CLASS-0-BULK-UNITY]       [2]     (T + vF) Variable Fee Unity \
        \ Class 1   : [DPTF|C>CLASS-1-BULK]             [3]     (T) No Fee \
        \ Class 2   : [DPTF|C>CLASS-2-BULK]             [4]     (T + F) With Fee \
        \           : [DPTF|C>CLASS-2-BULK-ELITE]       [5]     (T + U) No Fee + Update Elite \
        \ Class 3   : [DPTF|C>CLASS-3-BULK-ELITE]       [6]     (T + F + U) With Fee + Update"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (fee-promile:decimal (ref-DPTF::UR_FeePromile id))
                (iz-un:bool (URC_IzTrueFungibleUnity id))
            )
            (if (= -1.0 fee-promile)
                (if iz-un 2 1)
                (let
                    (
                        (iz-simple-transfer-for-bulk:bool (URC_IzSimpleTransferForBulk id sender))
                        (are-e:bool (URC_AreTrueFungiblesEliteAurynz id))
                    )
                    (if iz-simple-transfer-for-bulk
                        (if are-e 5 3)
                        (if are-e 6 4)
                    )
                )
            )
        )
    )
    (defun URC_IzSimpleTransferForBulk:bool
        (id:string sender:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (fee-toggle:bool (ref-DPTF::UR_FeeToggle id))
                (fee-promile:decimal (ref-DPTF::UR_FeePromile id))
                (fee-unlocks:integer (ref-DPTF::UR_FeeUnlocks id))
            )
            (cond
                ((not fee-toggle) true)
                ((and (= fee-promile 0.0) (= fee-unlocks 0)) true)
                ((ref-DPTF::UR_AccountRoleFeeExemption id sender) true)
                ((= sender (ref-DPTF::UR_Konto id)) true)
                false
            )
        )
    )
    (defun URC_IzSimpleTransfer:bool (id:string sender:string receiver:string amount:decimal)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (fee-toggle:bool (ref-DPTF::UR_FeeToggle id))
                (fee-promile:decimal (ref-DPTF::UR_FeePromile id))
                (fee-unlocks:integer (ref-DPTF::UR_FeeUnlocks id))
            )
            (cond
                ((not fee-toggle) true)
                ((and (= fee-promile 0.0) (= fee-unlocks 0)) true)
                ((fold (and) true [(= fee-promile -1.0) (= fee-unlocks 0) (< amount 10.0)]) true)
                ((ref-DPTF::UR_AccountRoleFeeExemption id sender) true)
                ((= sender (ref-DPTF::UR_Konto id)) true)
                ((ref-DPTF::UR_AccountRoleFeeExemption id receiver) true)
                ((= receiver (ref-DALOS::GOV|OUROBOROS|SC_NAME)) true)
                ((= receiver (ref-DALOS::GOV|DALOS|SC_NAME)) true)
                ((= sender (ref-DALOS::GOV|OUROBOROS|SC_NAME)) true)
                ((= sender (ref-DALOS::GOV|DALOS|SC_NAME)) true)
                ((= receiver (ref-DPTF::UR_Konto id)) true)
                false
            )
        )
    )
    (defun URC_IzTrueFungibleEliteAuryn:bool (id:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
            )
            (if (= id ea-id) true false)
        )
    )
    (defun URC_IzTrueFungibleUnity:bool (id:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (u-id:string (ref-DALOS::UR_UnityID))
            )
            (if (= id u-id) true false)
        )
    )
    (defun URC_AreTrueFungiblesEliteAurynz:bool (id:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
                (fea:string (ref-DPTF::UR_Frozen ea-id))
                (rea:string (ref-DPTF::UR_Reservation ea-id))
            )
            (contains id [ea-id fea rea])
        )
    )
    (defun URC_TransferRoleChecker:bool (id:string sender:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
                (tra:integer (ref-DPTF::UR_TransferRoleAmount id))
            )
            (and
                (> tra 0)
                (not (or (= sender ouroboros) (= sender dalos)))
            )
        )
    )
    ;;
    (defun URCX_CPF_RT-RBT:[decimal] (id:string native-fee-amount:decimal)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-ATS:module{AutostakeV4} ATS)
                (rt-ats-pairs:[string] (ref-DPTF::UR_RewardToken id))
                (rbt-ats-pairs:[string] (ref-DPTF::UR_RewardBearingToken id))
                (length-rt:integer (length rt-ats-pairs))
                (length-rbt:integer (length rbt-ats-pairs))
                (rt-boolean:[bool] (URCX_NFR-Boolean_RT-RBT id rt-ats-pairs true))
                (rbt-boolean:[bool] (URCX_NFR-Boolean_RT-RBT id rbt-ats-pairs false))
                (rt-milestones:integer (length (ref-U|LST::UC_Search rt-boolean true)))
                (rbt-milestones:integer (length (ref-U|LST::UC_Search rbt-boolean true)))
                (milestones:integer (+ rt-milestones rbt-milestones))
            )
            (if (!= milestones 0)
                (let
                    (
                        (truths:[bool] (+ rt-boolean rbt-boolean))
                        (split-with-truths:[decimal] (URCX_BooleanDecimalCombiner id native-fee-amount milestones truths))
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
    (defun URCX_CPF_RBT:decimal (id:string native-fee-amount:decimal)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ats-pairs:[string] (ref-DPTF::UR_RewardBearingToken id))
                (ats-pairs-bool:[bool] (URCX_NFR-Boolean_RT-RBT id ats-pairs false))
                (milestones:integer (length (ref-U|LST::UC_Search ats-pairs-bool true)))
            )
            (if (!= milestones 0)
                0.0
                native-fee-amount
            )
        )
    )
    (defun URCX_CPF_RT:decimal (id:string native-fee-amount:decimal)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-ATS:module{AutostakeV4} ATS)
                (ats-pairs:[string] (ref-DPTF::UR_RewardToken id))
                (ats-pairs-bool:[bool] (URCX_NFR-Boolean_RT-RBT id ats-pairs true))
                (milestones:integer (length (ref-U|LST::UC_Search ats-pairs-bool true)))
            )
            (if (!= milestones 0)
                (let
                    (
                        (rt-split-with-boolean:[decimal] (URCX_BooleanDecimalCombiner id native-fee-amount milestones ats-pairs-bool))
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
    (defun URCX_NFR-Boolean_RT-RBT:[bool] (id:string ats-pairs:[string] rt-or-rbt:bool)
        @doc "Makes a [bool] using RT or RBT <nfr> values from a list of ATS Pair"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-ATS:module{AutostakeV4} ATS)
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
    (defun URCX_BooleanDecimalCombiner:[decimal] (id:string amount:decimal milestones:integer boolean:[bool])
        (let
            (
                (ref-U|ATS:module{UtilityAts} U|ATS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (prec:integer (ref-DPTF::UR_Decimals id))
            )
            (ref-U|ATS::UC_SplitBalanceWithBooleans prec amount milestones boolean)
        )
    )
    ;;
    ;;{F2}  [UEV]
    (defun UEV_IzSimpleTransfer (id:string sender:string receiver:string amount:decimal iz-or-not:bool)
        (let
            (
                (iz-simple-transfer:bool (URC_IzSimpleTransfer id sender receiver amount))
            )
            (enforce (= iz-simple-transfer iz-or-not) (format "Simple Transfer as {} is invalid for input Parameters" [iz-or-not]))
        )
    )
    (defun UEV_IzSimpleTransferForBulk (id:string sender:string iz-or-not:bool)
        (let
            (
                (iz-simple-transfer:bool (URC_IzSimpleTransferForBulk id sender))
            )
            (enforce (= iz-simple-transfer iz-or-not) (format "Simple Transfer as {} is invalid for input Parameters" [iz-or-not]))
        )
    )
    (defun UEV_AreTrueFungiblesEliteAurynz (id:string iz-or-not:bool)
        (let
            (
                (are-tf-ea:bool (URC_AreTrueFungiblesEliteAurynz id))
            )
            (enforce (= are-tf-ea iz-or-not) "True Fungible is not EA Class")
        )
    )
    (defun UEV_TrueFungibleAsEliteAuryn:bool (id:string iz-or-not:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (iz-ea:bool (URC_IzTrueFungibleEliteAuryn id))
            )
            (enforce (= iz-ea iz-or-not) (format "ID {} isnt the Elite Auryn ID"))
        )
    )
    (defun UEV_TrueFungibleAsUnity:bool (id:string iz-or-not:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (iz-u:bool (URC_IzTrueFungibleUnity id))
            )
            (enforce (= iz-u iz-or-not) (format "ID {} isnt the Unity ID"))
        )
    )
    (defun UEV_Minimum (id:string amount:decimal)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (min-move-read:decimal (ref-DPTF::UR_MinMove id))
                (precision:integer (ref-DPTF::UR_Decimals id))
                (min-move:decimal
                    (if (= min-move-read -1.0)
                        (floor (/ 1.0 (^ 10.0 (dec precision))) precision)
                        min-move-read
                    )
                )
            )
            (enforce (>= amount min-move) (format "{} is not a valid {} min move amount" [amount id]))
        )
    )
    (defun UEV_DispoLocker (id:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (type:bool (ref-DALOS::UR_AccountType account))
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
                (ouro-amount:decimal (ref-DALOS::UR_TF_AccountSupply account true))
            )
            (if (and (= id ea-id) (not type))
                (enforce (not (< ouro-amount 0.0)) "When Account has negative OURO, Elite-Auryn is dispo-locked and cannot be moved")
                true
            )
        )
    )
    (defun UEV_VTT (id:string iz-vtt:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (fee-promile:decimal (ref-DPTF::UR_FeePromile id))
            )
            (if iz-vtt
                (enforce (= fee-promile -1.0) "VTT required for exec")
                (enforce (>= fee-promile 0.0) "Normal Fee required for exec")
            )
        )
    )
    (defun UEV_TransferRolesComplex (id:string sender:string receiver:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (direct-transfer-role-amount:integer (ref-DPTF::UR_TransferRoleAmount id))
                (id-transfer-roles:[string] (ref-DPTF::UR_Roles id 4))
                (litr:integer (length id-transfer-roles))
                (indirect-transfer-role-amount:integer 
                    (if (and (= litr 1) (= id-transfer-roles [BAR]))
                        0
                        litr
                    )
                )
            )
            (enforce (= direct-transfer-role-amount indirect-transfer-role-amount) "Incompatible Transfer Roles Detected for Transfer")
            (UEV_TransferRolesSimple id sender receiver)
        )
    )
    (defun UEV_TransferRolesSimple (id:string sender:string receiver:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (trc:bool (URC_TransferRoleChecker id sender))
                (s:bool (ref-DPTF::UR_AccountRoleTransfer id sender))
                (r:bool (ref-DPTF::UR_AccountRoleTransfer id receiver))
            )
            (UEV_TransferRoleChecker trc s r)
        )
    )
    (defun UEV_TransferRoleChecker (trc:bool s:bool r:bool)
        (if
            trc
            (enforce-one
                "Invalid TR"
                [
                    (enforce s "Invalid TR Sender")
                    (enforce r "Invalid TR Receiver")
                ]
            )
            true
        )
    )
    ;;Bulk
    (defun UEV_BulkTransfer
        (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (s:bool (ref-DPTF::UR_AccountRoleTransfer id sender))
                (l1:integer (length receiver-lst))
                (l2:integer (length transfer-amount-lst))
            )
            (ref-U|LST::UC_IzUnique receiver-lst)
            (enforce (= l1 l2) "Invalid Bulk Transfer Lists")
            ;;Single Data
            (ref-DALOS::CAP_EnforceAccountOwnership sender)
            (ref-DPTF::UEV_PauseState id false)
            (ref-DPTF::UEV_AccountFreezeState id sender false)
            ;;Multi Data (Mapper)
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (receiver:string (at idx receiver-lst))
                            (ta:decimal (at idx transfer-amount-lst))
                            (r:bool (ref-DPTF::UR_AccountRoleTransfer id receiver))
                            (r-type:bool (ref-DALOS::UR_AccountType receiver))
                        )
                        ;(ref-DALOS::UEV_EnforceTransferability sender receiver method)
                        (ref-DPTF::UEV_AccountFreezeState id receiver false)
                        (ref-DPTF::UEV_Amount id ta)
                        (UEV_TransferRolesSimple id sender receiver)
                        (enforce (not r-type) "Bulk Transfer does not work to target Smart Ouronet Account")
                    )
                )
                (enumerate 0 (- l2 1))
            )
        )
    )
    (defun UEV_MinimumMapperForBulk
        (id:string transfer-amount-lst:[decimal])
        (map
            (lambda
                (idx:integer)
                (UEV_Minimum id (at idx transfer-amount-lst))
            )
            (enumerate 0 (- (length transfer-amount-lst) 1))
        )
    )
    ;;Multi
    (defun UEV_MultiTransfer
        (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @doc "LIMITS: Supports Up to 10 Complex plus 1 Elite, or 20 when all are Simple"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
                (has-ea:bool (contains ea-id id-lst))
                (l1:integer (length id-lst))
                (l2:integer (length transfer-amount-lst))
            )
            ;;
            (ref-U|LST::UC_IzUnique id-lst)
            (enforce (= l1 l2) "Invalid Multi Transfer Lists")
            ;;Single Data
            ;;DispoLocker used once, not for every id.
            (if has-ea
                (UEV_DispoLocker ea-id sender)
                true
            )
            (ref-DALOS::CAP_EnforceAccountOwnership sender)
            (ref-DALOS::UEV_EnforceTransferability sender receiver method)
            (if (and method (ref-DALOS::UR_AccountType receiver))
                (ref-DALOS::CAP_EnforceAccountOwnership receiver)
                true
            )
            ;;Multi Data (Mapper)
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (id:string (at idx id-lst))
                            (ta:decimal (at idx transfer-amount-lst))
                            (trc:bool (URC_TransferRoleChecker id sender))
                        )
                        ;(ref-DALOS::UEV_EnforceTransferability sender receiver method)
                        (ref-DPTF::UEV_PauseState id false)
                        (ref-DPTF::UEV_AccountFreezeState id sender false)
                        (ref-DPTF::UEV_AccountFreezeState id receiver false)
                        (ref-DPTF::UEV_Amount id ta)
                        (UEV_TransferRolesSimple id sender receiver)
                    )
                )
                (enumerate 0 (- l2 1))
            )
        )
    )
    ;;{F3}  [UDC]
    (defun UDC_SmallTransmuteCumulator:object{IgnisCollector.OutputCumulator}
        (id:string transmuter:string)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-IGNIS::IC|UDC_ConstructOutputCumulator
                (ref-DALOS::UR_UsagePrice "ignis|small") transmuter
                (ref-IGNIS::IC|URC_IsVirtualGasZeroAbsolutely id) []
            )
        )
    )
    (defun UDC_LargeTransmuteCumulator:object{IgnisCollector.OutputCumulator}
        (id:string transmuter:string)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-IGNIS::IC|UDC_ConstructOutputCumulator
                (ref-DALOS::UR_UsagePrice "ignis|medium") transmuter
                (ref-IGNIS::IC|URC_IsVirtualGasZeroAbsolutely id) []
            )
        )
    )
    ;;
    (defun UDC_UnityTransferCumulator:object{IgnisCollector.OutputCumulator}
        (sender:string receiver:string amount:decimal)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (price:decimal
                    (if (< amount 10.0)
                        (ref-DALOS::UR_UsagePrice "ignis|smallest")
                        0.0
                    )
                )
            )
            (ref-IGNIS::IC|UDC_ConstructOutputCumulator
                price sender
                (ref-IGNIS::IC|URC_ZeroEliteGAZ sender receiver) []
            )
        )
    )
    (defun UDC_SmallTransferCumulator:object{IgnisCollector.OutputCumulator}
        (id:string sender:string receiver:string)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-IGNIS::IC|UDC_ConstructOutputCumulator
                (ref-DALOS::UR_UsagePrice "ignis|smallest")  sender
                (ref-IGNIS::IC|URC_ZeroGAZ id sender receiver) []
            )
        )
    )
    (defun UDC_MediumTransferCumulator:object{IgnisCollector.OutputCumulator}
        (id:string sender:string receiver:string)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-IGNIS::IC|UDC_ConstructOutputCumulator
                (ref-DALOS::UR_UsagePrice "ignis|small") sender
                (ref-IGNIS::IC|URC_ZeroGAZ id sender receiver) []
            )
        )
    )
    (defun UDC_LargeTransferCumulator:object{IgnisCollector.OutputCumulator}
        (sender:string receiver:string)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-IGNIS::IC|UDC_ConstructOutputCumulator
                (ref-DALOS::UR_UsagePrice "ignis|medium") sender
                (ref-IGNIS::IC|URC_ZeroEliteGAZ sender receiver) []
            )
        )
    )
    (defun UDC_EliteExchangeCumulator:object{IgnisCollector.OutputCumulator}
        (sender:string smart-intermediary:string amplifier:integer)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (dec-amp:decimal (dec amplifier))
            )
            (ref-IGNIS::IC|UDC_ConstructOutputCumulator
                (* dec-amp (ref-DALOS::UR_UsagePrice "ignis|medium")) sender
                (ref-IGNIS::IC|URC_ZeroEliteGAZ sender smart-intermediary) []
            )
        )
    )
    (defun UDC_GetDispoData:object{UtilityDptf.DispoData} (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-ATS:module{AutostakeV4} ATS)
                (a-id:string (ref-DALOS::UR_AurynID))
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                (auryndex:string (at 0 (ref-DPTF::UR_RewardToken ouro-id)))
                (elite-auryndex:string (at 0 (ref-DPTF::UR_RewardToken a-id)))
            )
            {"elite-auryn-amount"   : (ref-DPTF::UR_AccountSupply ea-id account)
            ,"auryndex-value"       : (ref-ATS::URC_Index auryndex)
            ,"elite-auryndex-value" : (ref-ATS::URC_Index elite-auryndex)
            ,"major-tier"           : (ref-DALOS::UR_Elite-Tier-Major account)
            ,"minor-tier"           : (ref-DALOS::UR_Elite-Tier-Minor account)
            ,"ouroboros-precision"  : (ref-DPTF::UR_Decimals ouro-id)}
        )
    )
    ;;Multi
    (defun UDC_MultiTransferCumulator:object{IgnisCollector.OutputCumulator}
        (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (l:integer (length id-lst))
                (folded-obj:[object{IgnisCollector.OutputCumulator}]
                    (fold
                        (lambda
                            (acc:[object{IgnisCollector.OutputCumulator}] idx:integer)
                            (let
                                (
                                    (id:string (at idx id-lst))
                                    (transfer-amount:decimal (at idx transfer-amount-lst))
                                    (what-type:integer (URC_TransferClasses id sender receiver transfer-amount))
                                    (ico:object{IgnisCollector.OutputCumulator}
                                        (UC_TransferCumulator what-type id sender receiver)
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
            (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators folded-obj [])
        )
    )
    ;;Bulk
    (defun UDC_MultiBulkTransferCumulator:object{IgnisCollector.OutputCumulator}
        (id-lst:[string] sender:string receiver-array:[[string]] transfer-amount-array:[[decimal]])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (l:integer (length id-lst))
                (folded-obj:[object{IgnisCollector.OutputCumulator}]
                    (fold
                        (lambda
                            (acc:[object{IgnisCollector.OutputCumulator}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                (UDC_BulkTransferCumulator
                                    (at idx id-lst)
                                    sender
                                    (at idx receiver-array)
                                    (at idx transfer-amount-array)
                                )
                            )
                        )
                        []
                        (enumerate 0 (- l 1))
                    )
                )
            )
            (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators folded-obj [])
        )
    )
    (defun UDC_BulkTransferCumulator:object{IgnisCollector.OutputCumulator}
        (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (what-type:integer (URC_TransferClassesForBulk id sender))
                (size:integer (length receiver-lst))
            )
            (cond
                ((contains what-type [1 4 5]) (UDC_ComplexBulkTransferCumulator id sender size))
                ((= what-type 2) (UDC_UnityBulkTransferCumulator sender receiver-lst transfer-amount-lst))
                ((= what-type 3) (UDC_SimpleBulkTransferCumulator id sender size))
                ((= what-type 6) (UDC_EliteBulkTransferCumulator id sender size))
                EOC
            )
        )
    )
    ;;
    (defun UDC_UnityBulkTransferCumulator:object{IgnisCollector.OutputCumulator}
        (sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (l:integer (length receiver-lst))
                (folded-obj:[object{IgnisCollector.OutputCumulator}]
                    (fold
                        (lambda
                            (acc:[object{IgnisCollector.OutputCumulator}] idx:integer)
                            (let
                                (
                                    (transfer-amount:decimal (at idx transfer-amount-lst))
                                    (receiver:string (at idx receiver-lst))
                                    (ico:object{IgnisCollector.OutputCumulator}
                                        (UDC_UnityTransferCumulator sender receiver transfer-amount)
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
            (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators folded-obj [])
        )
    )
    (defun UDC_SimpleBulkTransferCumulator:object{IgnisCollector.OutputCumulator}
        (id:string sender:string size:integer)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (UDCX_BulkTransferCumulator id sender size (ref-DALOS::UR_UsagePrice "ignis|smallest"))
        )
    )
    (defun UDC_ComplexBulkTransferCumulator:object{IgnisCollector.OutputCumulator}
        (id:string sender:string size:integer)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (UDCX_BulkTransferCumulator id sender size (ref-DALOS::UR_UsagePrice "ignis|small"))
        )
    )
    (defun UDC_EliteBulkTransferCumulator:object{IgnisCollector.OutputCumulator}
        (id:string sender:string size:integer)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (UDCX_BulkTransferCumulator id sender size (ref-DALOS::UR_UsagePrice "ignis|medium"))
        )
    )
    (defun UDCX_BulkTransferCumulator:object{IgnisCollector.OutputCumulator}
        (id:string sender:string size:integer price:decimal)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (l-dec:decimal (dec size))
            )
            (ref-IGNIS::IC|UDC_ConstructOutputCumulator
                (* l-dec price) sender
                (ref-IGNIS::IC|URC_ZeroGAS id sender ) []
            )
        )
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;Clear Dispo
    (defun C_ClearDispo:object{IgnisCollector.OutputCumulator}
        (account:string)
        (UEV_IMC)
        (with-capability (DPTF|C>CLEAR-DISPO account)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                    (ref-ATS:module{AutostakeV4} ATS)
                    ;;
                    (ouro-id:string (ref-DALOS::UR_OuroborosID))
                    (a-id:string (ref-DALOS::UR_AurynID))
                    (ea-id:string (ref-DALOS::UR_EliteAurynID))
                    (ouro-amount:decimal (abs (ref-DPTF::UR_AccountSupply ouro-id account)))
                    (account-ea-supply:decimal (ref-DPTF::UR_AccountSupply ea-id account))
                    (frozen-state:bool (ref-DPTF::UR_AccountFrozenState ea-id account))
                    ;;
                    (auryndex:string (at 0 (ref-DPTF::UR_RewardToken ouro-id)))
                    (elite-auryndex:string (at 0 (ref-DPTF::UR_RewardToken a-id)))
                    (auryndex-value:decimal (ref-ATS::URC_Index auryndex))
                    (elite-auryndex-value:decimal (ref-ATS::URC_Index elite-auryndex))
                    ;;
                    (o-prec:integer (ref-DPTF::UR_Decimals ouro-id))
                    (a-prec:integer (ref-DPTF::UR_Decimals a-id))
                    (ea-prec:integer (ref-DPTF::UR_Decimals ea-id))
                    ;;
                    (burn-auryn-amount:decimal (floor (/ ouro-amount auryndex-value) a-prec))
                    (burn-elite-auryn-amount:decimal (floor (/ burn-auryn-amount elite-auryndex-value) ea-prec))
                    (total-ea:decimal (floor (* burn-elite-auryn-amount 2.5) ea-prec))
                    (ats-sc:string (ref-DALOS::GOV|ATS|SC_NAME))
                    ;;
                    ;;Ignis Cumulation
                    (ico1:object{IgnisCollector.OutputCumulator}
                        (if (not frozen-state)
                            (ref-DPTF::C_ToggleFreezeAccount ea-id account true)
                            EOC
                        )
                    )
                    (ico2:object{IgnisCollector.OutputCumulator}
                        (ref-DPTF::C_WipePartial ea-id account total-ea)
                    )
                    (ico3:object{IgnisCollector.OutputCumulator}
                        (ref-DPTF::C_ToggleFreezeAccount ea-id account false)
                    )
                    (ico4:object{IgnisCollector.OutputCumulator}
                        (ref-DPTF::C_Burn a-id ats-sc burn-auryn-amount)
                    )
                    (ico5:object{IgnisCollector.OutputCumulator}
                        (ref-DPTF::C_Burn ouro-id ats-sc ouro-amount)
                    )
                )
            ;;1] Freeze EA on account
                ;;via ico1
            ;;2] Partial Wipe EA on account
                ;;via ico2
            ;;3] Unfreeze EA on account
                ;;via ico3
            ;;4] <ATS|SC-NAME> burns <burn-auryn-amount> Auryn amount and decrease Resident Amount by it on <elite-auryndex>
                ;via ico4
                (ref-ATS::XE_UpdateRoU elite-auryndex a-id true false burn-auryn-amount)
            ;;5] <ATS|SC-NAME> burns <ouro-amount> OURO amount and decrease Resident Amount by it on <auryndex>
                ;;via ico5
                (ref-ATS::XE_UpdateRoU auryndex ouro-id true false ouro-amount)
            ;;6] Finally clears dispo setting OURO <acount> amount to zero
                (ref-DALOS::XE_ClearDispo account)
            ;;7] Updating Elite Account and Constructing the Output: Pleasure doing business with you !
                (XI_DirectUpdateEliteAccount account)
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3  ico4 ico5] [])
            )
        )
    )
    ;;Transmute
    (defun C_Transmute:object{IgnisCollector.OutputCumulator}
        (id:string transmuter:string transmute-amount:decimal)
        (UEV_IMC)
        (let
            (
                (iz-ea:bool (URC_IzTrueFungibleEliteAuryn id))
            )
            (if iz-ea
                (with-capability (DPTF|C>ELITE-TRANSMUTE id transmuter transmute-amount)
                    (XI_Transmute id transmuter transmute-amount)
                    (XI_DirectUpdateEliteAccount transmuter)
                    (UDC_LargeTransmuteCumulator id transmuter)
                )
                (with-capability (DPTF|C>TRANSMUTE id transmuter transmute-amount)
                    (XI_Transmute id transmuter transmute-amount)
                    (UDC_SmallTransmuteCumulator id transmuter)
                )
            )
        )
    )
    ;;Transfer
    (defun C_Transfer:object{IgnisCollector.OutputCumulator}
        (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (UEV_IMC)
        (let
            (
                (what-type:integer (URC_TransferClasses id sender receiver transfer-amount))
            )
            (cond
                ((= what-type 1) 
                    (with-capability (DPTF|C>CLASS-1-TRANSFER id sender receiver transfer-amount method)
                        (XI_SimpleTransfer id sender receiver transfer-amount method)
                    )
                )
                ((= what-type 2) 
                    (with-capability (DPTF|C>CLASS-1-TRANSFER-UNITY id sender receiver transfer-amount method)
                        (XI_SimpleTransfer id sender receiver transfer-amount method)
                    )
                )
                ((= what-type 3) 
                    (with-capability (DPTF|C>CLASS-2-TRANSFER id sender receiver transfer-amount method)
                        (XI_ComplexTransfer id sender receiver transfer-amount method)
                    )
                )
                ((= what-type 4) 
                    (with-capability (DPTF|C>CLASS-2-TRANSFER-UNITY id sender receiver transfer-amount method)
                        (XI_ComplexTransfer id sender receiver transfer-amount method)
                    )
                )
                ((= what-type 5) 
                    (with-capability (DPTF|C>CLASS-2-TRANSFER-ELITE id sender receiver transfer-amount method)    
                        (XI_SimpleTransfer id sender receiver transfer-amount method)
                        (XI_DynamicUpdateEliteAccount sender)
                        (XI_DynamicUpdateEliteAccount receiver)
                    )
                )
                ((= what-type 6) 
                    (with-capability (DPTF|C>CLASS-3-TRANSFER-ELITE id sender receiver transfer-amount method)   
                        (XI_ComplexTransfer id sender receiver transfer-amount method)
                        (XI_DynamicUpdateEliteAccount sender)
                        (XI_DynamicUpdateEliteAccount receiver)
                    )
                )
                true
            )
            (UC_TransferCumulator what-type id sender receiver)
        )
    )
    ;;Multi Transfer
    (defun C_MultiTransfer:object{IgnisCollector.OutputCumulator}
        (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        (UEV_IMC)
        (with-capability (DPTF|C>MULTI-TRANSFER id-lst sender receiver transfer-amount-lst method)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (dispo-data:object{UtilityDptf.DispoData} (UDC_GetDispoData sender))
                    (contains-eazs:bool (UC_ContainsEliteAurynz id-lst))
                    (l:integer (length id-lst))
                    (folded-obj:[object{IgnisCollector.OutputCumulator}]
                        (fold
                            (lambda
                                (acc:[object{IgnisCollector.OutputCumulator}] idx:integer)
                                (let
                                    (
                                        (id:string (at idx id-lst))
                                        (transfer-amount:decimal (at idx transfer-amount-lst))
                                        (what-type:integer (URC_TransferClasses id sender receiver transfer-amount))
                                        (ico:object{IgnisCollector.OutputCumulator}
                                            (UC_TransferCumulator what-type id sender receiver)
                                        )
                                        (iz-simple-transfer:bool (URC_IzSimpleTransfer id sender receiver transfer-amount))
                                    )
                                    ;;Debit
                                    (ref-DPTF::XB_DebitStandard id sender transfer-amount dispo-data)
                                    ;;Credit
                                    (if iz-simple-transfer
                                        (ref-DPTF::XB_Credit id receiver transfer-amount)
                                        (XI_ComplexCredit id receiver transfer-amount)
                                    )
                                    (ref-U|LST::UC_AppL acc ico)
                                )
                            )
                            []
                            (enumerate 0 (- l 1))
                        )
                    )
                )
                (if contains-eazs
                    (do
                        (XI_DynamicUpdateEliteAccount sender)
                        (XI_DynamicUpdateEliteAccount receiver)
                    )
                    true
                )
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators folded-obj [])
            )
        )
    )
    ;;Bulk Transfer
    (defun C_MultiBulkTransfer:object{IgnisCollector.OutputCumulator}
        (id-lst:[string] sender:string receiver-array:[[string]] transfer-amount-array:[[decimal]])
        (UEV_IMC)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (dispo-data:object{UtilityDptf.DispoData} (UDC_GetDispoData sender))
                (l:integer (length id-lst))
                (folded-obj:[object{IgnisCollector.OutputCumulator}]
                    (fold
                        (lambda
                            (acc:[object{IgnisCollector.OutputCumulator}] idx:integer)
                            (let
                                (
                                    (id:string (at idx id-lst))
                                    (receiver-lst:[string] (at idx receiver-array))
                                    (transfer-amount-lst:[decimal] (at idx transfer-amount-array))
                                    (size:integer (length receiver-lst))
                                    (what-type:integer (URC_TransferClassesForBulk id sender))
                                    (total-debit:decimal (fold (+) 0.0 transfer-amount-lst))
                                    (ico:object{IgnisCollector.OutputCumulator}
                                        (cond
                                            ((contains what-type [1 4 5]) (UDC_ComplexBulkTransferCumulator id sender size))
                                            ((= what-type 2) (UDC_UnityBulkTransferCumulator sender receiver-lst transfer-amount-lst))
                                            ((= what-type 3) (UDC_SimpleBulkTransferCumulator id sender size))
                                            ((= what-type 6) (UDC_EliteBulkTransferCumulator id sender size))
                                            EOC
                                        )
                                    )
                                )
                                ;;Debit
                                (ref-DPTF::XB_DebitStandard id sender total-debit dispo-data)
                                ;;Credit
                                (cond
                                    ((= what-type 1) 
                                        (with-capability (DPTF|C>CLASS-0-BULK id sender receiver-lst transfer-amount-lst) 
                                            (XI_BulkCredit id receiver-lst transfer-amount-lst true false)
                                        )
                                    )
                                    ((= what-type 2) 
                                        (with-capability (DPTF|C>CLASS-0-BULK-UNITY id sender receiver-lst transfer-amount-lst)
                                            (XI_BulkCredit id receiver-lst transfer-amount-lst true false)
                                        )
                                    )
                                    ((= what-type 3) 
                                        (with-capability (DPTF|C>CLASS-1-BULK id sender receiver-lst transfer-amount-lst)
                                            (XI_BulkCredit id receiver-lst transfer-amount-lst false false)
                                        )
                                    )
                                    ((= what-type 4) 
                                        (with-capability (DPTF|C>CLASS-2-BULK id sender receiver-lst transfer-amount-lst)
                                            (XI_BulkCredit id receiver-lst transfer-amount-lst true false)
                                        )
                                    )
                                    ((= what-type 5) 
                                        (with-capability (DPTF|C>CLASS-2-BULK-ELITE id sender receiver-lst transfer-amount-lst)    
                                            (XI_BulkCredit id receiver-lst transfer-amount-lst false true)
                                        )
                                    )
                                    ((= what-type 6) 
                                        (with-capability (DPTF|C>CLASS-3-BULK-ELITE id sender receiver-lst transfer-amount-lst)    
                                            (XI_BulkCredit id receiver-lst transfer-amount-lst true true)
                                        )
                                    )
                                    true
                                )
                                (ref-U|LST::UC_AppL acc ico)
                            )
                        )
                        []
                        (enumerate 0 (- l 1))
                    )
                )
            )
            (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators folded-obj [])
        )
    )
    ;;{F7}  [X]
    (defun XI_Transmute (id:string transmuter:string transmute-amount:decimal)
        (require-capability (DPTF|C>X-TRANSMUTE id transmuter transmute-amount))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (dispo-data:object{UtilityDptf.DispoData} (UDC_GetDispoData transmuter))
            )
            (ref-DPTF::XB_DebitStandard id transmuter transmute-amount dispo-data)
            (XI_CreditPrimaryFee id transmute-amount false)
        )
    )
    ;;
    (defun XI_SimpleTransfer (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (require-capability (DPTF|C>X-TRANSFER id sender receiver transfer-amount method))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (dispo-data:object{UtilityDptf.DispoData} (UDC_GetDispoData sender))
            )
            (ref-DPTF::XB_DebitStandard id sender transfer-amount dispo-data)
            (ref-DPTF::XB_Credit id receiver transfer-amount)
        )
    )
    (defun XI_ComplexTransfer (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (require-capability (DPTF|C>X-TRANSFER id sender receiver transfer-amount method))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (dispo-data:object{UtilityDptf.DispoData} (UDC_GetDispoData sender))
            )
            (ref-DPTF::XB_DebitStandard id sender transfer-amount dispo-data)
            (XI_ComplexCredit id receiver transfer-amount)
        )
    )
    (defun XI_ComplexCredit (id:string receiver:string transfer-amount:decimal)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
                (fees:[decimal] (ref-DPTF::URC_Fee id transfer-amount))
                (primary-fee:decimal (at 0 fees))
                (secondary-fee:decimal (at 1 fees))
                (remainder:decimal (at 2 fees))
            )
            (if (!= primary-fee 0.0)
                (XI_CreditPrimaryFee id primary-fee true)
                true
            )
            (if (!= secondary-fee 0.0)
                (do
                    (ref-DPTF::XB_Credit id dalos secondary-fee)
                    (ref-DPTF::XE_UpdateFeeVolume id secondary-fee false)
                )
                true
            )
            (ref-DPTF::XB_Credit id receiver remainder)
        )
    )
    (defun XI_DynamicUpdateEliteAccount (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (type:bool (ref-DALOS::UR_AccountType account))
            )
            (if (not type)
                (XI_DirectUpdateEliteAccount account)
                true
            )
        )
    )
    (defun XI_DirectUpdateEliteAccount (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                (elite-aurynz:decimal (ref-DPMF::URC_EliteAurynzSupply account))
            )
            (ref-DALOS::XE_UpdateElite account elite-aurynz)
        )
    )
    ;;
    (defun XI_BulkCredit
        (id:string receiver-lst:[string] transfer-amount-lst:[decimal] complexity:bool elite:bool)
        (require-capability (SECURE))
        (let
            (
                (size:integer (length receiver-lst))
            )
            (if (not complexity)
                (do
                    (XI_BulkCreditAmounts id receiver-lst transfer-amount-lst)
                    (if elite (XI_BulkUpdateElite receiver-lst) true)
                )
                (let
                    (
                        (ref-DALOS:module{OuronetDalosV4} DALOS)
                        (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                        (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
                        (fees:[decimal] (UC_BulkFees id transfer-amount-lst))
                        (primary-fee:decimal (at 0 fees))
                        (secondary-fee:decimal (at 1 fees))
                        (bulk-remainders:[decimal] (UC_BulkRemainders id transfer-amount-lst))
                    )
                    (if (!= primary-fee 0.0)
                        (XI_CreditPrimaryFee id primary-fee true)
                        true
                    )
                    (if (!= secondary-fee 0.0)
                        (do
                            (ref-DPTF::XB_Credit id dalos secondary-fee)
                            (ref-DPTF::XE_UpdateFeeVolume id secondary-fee false)
                        )
                        true
                    )
                    (XI_BulkCreditAmounts id receiver-lst bulk-remainders)
                    (if elite (XI_BulkUpdateElite receiver-lst) true)
                )
            )
        )
    )
    (defun XI_BulkCreditAmounts (id:string receiver-lst:[string] amounts:[decimal])
        (require-capability (SECURE))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
            )
            (map
                (lambda
                    (idx:integer)
                    (ref-DPTF::XB_Credit id (at idx receiver-lst) (at idx amounts))
                )
                (enumerate 0 (- (length receiver-lst) 1))
            )
        )
    )
    (defun XI_BulkUpdateElite (receiver-lst:[string])
        (require-capability (SECURE))
        (map
            (lambda
                (idx:integer)
                (XI_DirectUpdateEliteAccount (at idx receiver-lst))
            )
            (enumerate 0 (- (length receiver-lst) 1))
        )
    )
    ;;  [Aux Credit-Primary-Fee]
    (defun XI_CreditPrimaryFee (id:string pf:decimal native:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (rt:bool (ref-DPTF::URC_IzRT id))
                (rbt:bool (ref-DPTF::URC_IzRBT id))
                (target:string (ref-DPTF::UR_FeeTarget id))
            )
            (if (and rt rbt)
                (let
                    (
                        (v:[decimal] (URCX_CPF_RT-RBT id pf))
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
                            (v1:decimal (URCX_CPF_RT id pf))
                            (v2:decimal (- pf v1))
                        )
                        (XI_CPF_StillFee id target v1)
                        (XI_CPF_CreditFee id target v2)
                    )
                    (if rbt
                        (let
                            (
                                (v1:decimal (URCX_CPF_RBT id pf))
                                (v2:decimal (- pf v1))
                            )
                            (XI_CPF_StillFee id target v1)
                            (XI_CPF_BurnFee id target v2)
                        )
                        (ref-DPTF::XB_Credit id target pf)
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-ATS:module{AutostakeV4} ATS)
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-ATS:module{AutostakeV4} ATS)
                (ats:string (ref-ATS::GOV|ATS|SC_NAME))
            )
            (if (!= credit-fee 0.0)
                (ref-DPTF::XB_Credit id ats credit-fee)
                true
            )
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)