(module DPDC-C GOV
    ;;
    (implements OuronetPolicy)
    (implements DpdcCreateV4)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-C                 (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPDC-C_ADMIN)))
    (defcap GOV|DPDC-C_ADMIN ()             (enforce-guard GOV|MD_DPDC-C))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|DPDC-C|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC-C|CALLER))
        (compose-capability (SECURE))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|DPDC-C_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC-C_ADMIN)
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
                (ref-P|DPDC:module{OuronetPolicy} DPDC)
                (mg:guard (create-capability-guard (P|DPDC-C|CALLER)))
            )
            (ref-P|DPDC::P|A_AddIMP mg)
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
    (defconst BAR                   (CT_Bar))
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
    ;;Register Nonces
    (defcap DPDC-C|C>REGISTER-SINGLE-NONCE
        (id:string son:bool amount:integer ind:object{DpdcUdcV3.DPDC|NonceData} sft-set-mode:bool)
        @event
        (compose-capability (DPDC-C|C>REGISTER-NONCES  id son [amount] [ind] sft-set-mode))
    )
    (defcap DPDC-C|C>REGISTER-MULTIPLE-NONCES
        (id:string son:bool amounts:[integer] input-nonce-datas:[object{DpdcUdcV3.DPDC|NonceData}])
        @event
        (let
            (
                (l1:integer (length amounts))
            )
            (enforce (> l1 1) "Invalid Input variable length for a Multi Nonce Creation Capability")
            (compose-capability (DPDC-C|C>REGISTER-NONCES id son amounts input-nonce-datas false))
        )
    )
    (defcap DPDC-C|C>REGISTER-NONCES
        (id:string son:bool amounts:[integer] input-nonce-datas:[object{DpdcUdcV3.DPDC|NonceData}] sft-set-mode:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPDC:module{DpdcV5} DPDC)
                ;;
                (l1:integer (length amounts))
                (l2:integer (length input-nonce-datas))
                (msg:string
                    (if (= l1 1)
                        "a single Nonce"
                        "multiple Nonces"
                    )
                )
                (r-nft-create-account:string (ref-DPDC::UR_Verum5 id son))
            )
            (enforce (= l1 l2) (format "Incompatible Input Data for Registering {}" [msg]))
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (amount:integer (at idx amounts))
                            (input-nonce-data:object{DpdcUdcV3.DPDC|NonceData} (at idx input-nonce-datas))
                        )
                        (UEV_NonceDataForCreation input-nonce-data)
                        ;;Amount enforcement
                        (if son
                            (if sft-set-mode
                                (enforce (= amount 0) (format "When Defining an SFT Set, {} must be equal to 0" [amount]))
                                (enforce (>= amount 0) (format "For an SFT Collectable the {} must be greater or equal to 0" [amount]))
                            )
                            (enforce (= amount 1) (format "For an NFT Collectable the {} must be equal to 1" [amount]))
                        )
                    )
                )
                (enumerate 0 (- l2 1))
            )
            (ref-DALOS::CAP_EnforceAccountOwnership r-nft-create-account)
            (compose-capability (P|DPDC-C|CALLER))
        )
    )
    ;;CREDIT
    ;;Single-Credit
    (defcap DPSF|C>CREDIT-FRAGMENT-NONCE (id:string nonce:integer)
        (compose-capability (DPDC-C|C>SINGLE-CREDIT id true nonce true))
    )
    (defcap DPNF|C>CREDIT-FRAGMENT-NONCE (id:string nonce:integer)
        (compose-capability (DPDC-C|C>SINGLE-CREDIT id false nonce true))
    )
    (defcap DPSF|C>CREDIT-NONCE (id:string nonce:integer)
        (compose-capability (DPDC-C|C>SINGLE-CREDIT id true nonce false))
    )
    (defcap DPNF|C>CREDIT-NONCE (id:string nonce:integer amount:integer)
        (enforce (= amount 1) "Credit amount is must be 1 for NFTs")
        (compose-capability (DPDC-C|C>SINGLE-CREDIT id false nonce false))
    )
    (defcap DPDC-C|C>SINGLE-CREDIT (id:string son:bool nonce:integer fragments-or-native:bool)
        (let
            (
                (ref-DPDC:module{DpdcV5} DPDC)
            )
            (UEV_NonceType nonce fragments-or-native)
            (compose-capability (P|DPDC-C|CALLER))
        )
    )
    ;;
    ;;Multi-Credit
    (defcap DPSF|C>CREDIT-FRAGMENT-NONCES (id:string nonces:[integer] amounts:[integer])
        (compose-capability (DPDC-C|C>MULTI-CREDIT id true nonces amounts true))
    )
    (defcap DPNF|C>CREDIT-FRAGMENT-NONCES (id:string nonces:[integer] amounts:[integer])
        (compose-capability (DPDC-C|C>MULTI-CREDIT id false nonces amounts true))
    )
    (defcap DPSF|C>CREDIT-NONCES (id:string nonces:[integer] amounts:[integer])
        (compose-capability (DPDC-C|C>MULTI-CREDIT id true nonces amounts false))
    )
    (defcap DPNF|C>CREDIT-NONCES (id:string nonces:[integer] amounts:[integer])
        (compose-capability (DPDC-C|C>MULTI-CREDIT id false nonces amounts false))
        (enforce (= amounts (make-list (length amounts) 1)) "Invalid Amounts for NFT Crediting")
    )
    (defcap DPDC-C|C>MULTI-CREDIT (id:string son:bool nonces:[integer] amounts:[integer] fragments-or-native:bool)
        (UEV_NonceTypeMapper nonces fragments-or-native)
        (compose-capability (DPDC-C|CX>MULTI-CREDIT id son nonces amounts))
    )
    ;;
    ;;Hybrid Multi Credit
    (defcap DPSF|C>CREDIT-HYBRID-NONCES (id:string nonces:[integer] amounts:[integer])
        (compose-capability (DPDC|C>HYBRID-MULTI-CREDIT id true nonces amounts))
    )
    (defcap DPNF|C>CREDIT-HYBRID-NONCES (id:string nonces:[integer] amounts:[integer])
        (compose-capability (DPDC|C>HYBRID-MULTI-CREDIT id false nonces amounts))
    )
    (defcap DPDC|C>HYBRID-MULTI-CREDIT (id:string son:bool nonces:[integer] amounts:[integer])
        (UEV_HybridNonces nonces)
        (compose-capability (DPDC-C|CX>MULTI-CREDIT id son nonces amounts))
    )
    (defcap DPDC-C|CX>MULTI-CREDIT (id:string son:bool nonces:[integer] amounts:[integer])
        (let
            (
                (ref-DPDC:module{DpdcV5} DPDC)
                (l1:integer (length nonces))
                (l2:integer (length amounts))
            )
            (enforce (= l1 l2) (format "Nonces {} are incompatible with {} Amounts for Crediting" [nonces amounts]))
            (compose-capability (P|DPDC-C|CALLER))
        )
    )
    ;;
    ;;
    ;;DEBIT
    ;;Single Debit
    (defcap DPSF|C>DEBIT-FRAGMENT-NONCE (account:string id:string nonce:integer amount:integer wipe-mode:bool)
        (compose-capability (DPDC-C|C>SINGLE-DEBIT account id true nonce amount true wipe-mode))
    )
    (defcap DPNF|C>DEBIT-FRAGMENT-NONCE (account:string id:string nonce:integer amount:integer wipe-mode:bool)
        (compose-capability (DPDC-C|C>SINGLE-DEBIT account id false nonce amount true wipe-mode))
    )
    ;;
    (defcap DPSF|C>DEBIT-NONCE (account:string id:string nonce:integer amount:integer wipe-mode:bool)
        (compose-capability (DPDC-C|C>SINGLE-DEBIT account id true nonce amount false wipe-mode))
    )
    (defcap DPNF|C>DEBIT-NONCE (account:string id:string nonce:integer amount:integer wipe-mode:bool)
        (compose-capability (DPDC-C|C>SINGLE-DEBIT account id false nonce amount false wipe-mode))
    )
    (defcap DPDC-C|C>SINGLE-DEBIT 
        (account:string id:string son:bool nonce:integer amount:integer fragments-or-native:bool wipe-mode:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPDC:module{DpdcV5} DPDC)
            )
            (if wipe-mode
                (ref-DPDC::CAP_Owner id son)
                (ref-DALOS::CAP_EnforceAccountOwnership account)
            )
            (ref-DPDC::UEV_NonceQuantityInclusion account id son nonce amount)
            ;;
            (UEV_NonceType nonce fragments-or-native)
            ;;
            (compose-capability (P|DPDC-C|CALLER))
        )
    )
    ;;Multi-Debit
    (defcap DPSF|C>DEBIT-FRAGMENT-NONCES (account:string id:string nonces:[integer] amounts:[integer] wipe-mode:bool)
        (compose-capability (DPDC|C>MULTI-DEBIT account id true nonces amounts true wipe-mode))
    )
    (defcap DPNF|C>DEBIT-FRAGMENT-NONCES (account:string id:string nonces:[integer] amounts:[integer] wipe-mode:bool)
        (compose-capability (DPDC|C>MULTI-DEBIT account id false nonces amounts true wipe-mode))
    )
    (defcap DPSF|C>DEBIT-NONCES (account:string id:string nonces:[integer] amounts:[integer] wipe-mode:bool)
        (compose-capability (DPDC|C>MULTI-DEBIT account id true nonces amounts false wipe-mode))
    )
    (defcap DPNF|C>DEBIT-NONCES (account:string id:string nonces:[integer] amounts:[integer] wipe-mode:bool)
        (compose-capability (DPDC|C>MULTI-DEBIT account id false nonces amounts false wipe-mode))
    )
    (defcap DPDC|C>MULTI-DEBIT 
        (account:string id:string son:bool nonces:[integer] amounts:[integer] fragments-or-native:bool wipe-mode:bool)
        (let
            (
                (ref-DPDC:module{DpdcV5} DPDC)
            )
            (UEV_NonceTypeMapper nonces fragments-or-native)
            (compose-capability (DPDC|CX>MULTI-DEBIT account id son nonces amounts wipe-mode))
        )
        
    )
    ;;Hybrid Multi Debit
    (defcap DPSF|C>DEBIT-HYBRID-NONCES (account:string id:string nonces:[integer] amounts:[integer])
        (compose-capability (DPDC|CX>MULTI-DEBIT account id true nonces amounts false))
    )
    (defcap DPNF|C>DEBIT-HYBRID-NONCES (account:string id:string nonces:[integer] amounts:[integer])
        (compose-capability (DPDC|CX>MULTI-DEBIT account id false nonces amounts false))
    )
    (defcap DPDC|CX>MULTI-DEBIT 
        (account:string id:string son:bool nonces:[integer] amounts:[integer] wipe-mode:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPDC:module{DpdcV5} DPDC)
                ;;
                (l1:integer (length nonces))
                (l2:integer (length amounts))
            )
            (enforce (= l1 l2) (format "Nonces {} and Amounts {} are invalid for Operation" [nonces amounts]))
            (if wipe-mode
                (ref-DPDC::CAP_Owner id son)
                (ref-DALOS::CAP_EnforceAccountOwnership account)
            )
            (ref-DPDC::UEV_NonceQuantityInclusionMapper account id son nonces amounts)
            (compose-capability (P|DPDC-C|CALLER))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_AndTruths:bool (truths:[bool])
        (fold (and) true truths)
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_NonceDataForCreation (ind:object{DpdcUdcV3.DPDC|NonceData})
        @doc "Validates the ind for creation of new nonce"
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdcV3} DPDC-UDC)
                (ref-DPDC:module{DpdcV5} DPDC)
                ;;
                (empty-data-dc:object{DpdcUdcV3.DPDC|NonceData}
                    (ref-DPDC-UDC::UDC_ZeroNonceData)
                )
                (royalty:decimal (at "royalty" ind))
                (ignis:decimal (at "ignis" ind))
            )
            (enforce (!= empty-data-dc ind) "Incorrect Fragmentation Data")
            (ref-DPDC::UEV_Royalty royalty)     ;; Royalty can be set at -1.0 enabling Volumetric Royalty Fee.
            (ref-DPDC::UEV_IgnisRoyalty ignis)
        )
    )
    ;;
    (defun UEV_NonceType (nonce:integer fragments-or-native:bool)
        (if fragments-or-native
            (enforce (< nonce 0) "Only Negative Nonces Allowed for Operation")
            (enforce (> nonce 0) "Only Positive Nonces Allowed for Operation")
        )
    )
    ;;
    (defun UEV_NonceTypeMapper (nonces:[integer] fragments-or-native:bool)
        (map
            (lambda
                (idx:integer)
                (UEV_NonceType (at idx nonces) fragments-or-native)
            )
            (enumerate 0 (- (length nonces) 1))
        )
    )
    (defun UEV_HybridNonces:object{OuronetIntegersV2.SplitIntegers} (nonces:[integer])
        (let
            (
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                ;;
                (split-nonces:object{OuronetIntegersV2.SplitIntegers} (ref-U|INT::UC_SplitIntegerList nonces))
                (negative-nonces:[integer] (at "negative" split-nonces))
                (positive-nonces:[integer] (at "positive" split-nonces))
                (l3:integer (length negative-nonces))
                (l4:integer (length positive-nonces))
            )
            (enforce (and (!= l3 0) (!= l4 0)) (format "Nonces {} are invalid Hybrid Nonces" [nonces]))
            split-nonces
        )
    )
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_CreateNewNonce:object{IgnisCollectorV2.OutputCumulator}
        (
            id:string son:bool nonce-class:integer amount:integer
            input-nonce-data:object{DpdcUdcV3.DPDC|NonceData} sft-set-mode:bool
        )
        (UEV_IMC)
        (with-capability (DPDC-C|C>REGISTER-SINGLE-NONCE id son amount input-nonce-data sft-set-mode)
            (XI_RegisterCollectables id son [nonce-class] [amount] [input-nonce-data] sft-set-mode)
        )
    )
    (defun C_CreateNewNonces:object{IgnisCollectorV2.OutputCumulator}
        (
            id:string son:bool amounts:[integer]
            input-nonce-datas:[object{DpdcUdcV3.DPDC|NonceData}]
        )
        (UEV_IMC)
        (with-capability (DPDC-C|C>REGISTER-MULTIPLE-NONCES id son amounts input-nonce-datas)
            (XI_RegisterCollectables id son 
                (make-list (length input-nonce-datas) 0) 
                amounts input-nonce-datas false
            )
        )
    )
    ;;{F7}  [X]
    ;;T3x20
    (defun XE_CreditSFT-FragmentNonce (account:string id:string nonce:integer amount:integer)
        (UEV_IMC)
        (with-capability (DPSF|C>CREDIT-FRAGMENT-NONCE id nonce)
            (XI_CreditSFT account id [nonce] [amount])
        )
    )
    (defun XE_CreditNFT-FragmentNonce (account:string id:string nonce:integer amount:integer)
        (UEV_IMC)
        (with-capability (DPNF|C>CREDIT-FRAGMENT-NONCE id nonce)
            (XI_CreditNFT account id [nonce] [amount])
        )
    )
    (defun XE_DebitSFT-FragmentNonce (account:string id:string nonce:integer amount:integer wipe-mode:bool)
        (UEV_IMC)
        (with-capability (DPSF|C>DEBIT-FRAGMENT-NONCE account id nonce amount wipe-mode)
            (XI_DebitSFT account id [nonce] [amount] wipe-mode)
        )
    )
    (defun XE_DebitNFT-FragmentNonce (account:string id:string nonce:integer amount:integer wipe-mode:bool)
        (UEV_IMC)
        (with-capability (DPNF|C>DEBIT-FRAGMENT-NONCE account id nonce amount wipe-mode)
            (XI_DebitNFT account id [nonce] [amount] wipe-mode)
        )
    )
    ;;
    (defun XB_CreditSFT-Nonce (account:string id:string nonce:integer amount:integer)
        (UEV_IMC)
        (with-capability (DPSF|C>CREDIT-NONCE id nonce)
            (XI_CreditSFT account id [nonce] [amount])
        )
    )
    (defun XB_CreditNFT-Nonce (account:string id:string nonce:integer amount:integer)
        (UEV_IMC)
        (with-capability (DPNF|C>CREDIT-NONCE id nonce amount)
            (XI_CreditNFT account id [nonce] [amount])
        )
    )
    (defun XE_DebitSFT-Nonce (account:string id:string nonce:integer amount:integer wipe-mode:bool)
        (UEV_IMC)
        (with-capability (DPSF|C>DEBIT-NONCE account id nonce amount wipe-mode)
            (XI_DebitSFT account id [nonce] [amount] wipe-mode)
        )
    )
    (defun XE_DebitNFT-Nonce (account:string id:string nonce:integer amount:integer wipe-mode:bool)
        (UEV_IMC)
        (with-capability (DPNF|C>DEBIT-NONCE account id nonce amount wipe-mode)
            (XI_DebitNFT account id [nonce] [amount] wipe-mode)
        )
    )
    ;;
    (defun XE_CreditSFT-FragmentNonces (account:string id:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPSF|C>CREDIT-FRAGMENT-NONCES id nonces amounts)
            (XI_CreditSFT account id nonces amounts)
        )
    )
    (defun XE_CreditNFT-FragmentNonces (account:string id:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPNF|C>CREDIT-FRAGMENT-NONCES id nonces amounts)
            (XI_CreditNFT account id nonces amounts)
        )
    )
    (defun XE_DebitSFT-FragmentNonces (account:string id:string nonces:[integer] amounts:[integer] wipe-mode:bool)
        (UEV_IMC)
        (with-capability (DPSF|C>DEBIT-FRAGMENT-NONCES account id nonces amounts wipe-mode)
            (XI_DebitSFT account id nonces amounts wipe-mode)
        )
    )
    (defun XE_DebitNFT-FragmentNonces (account:string id:string nonces:[integer] amounts:[integer] wipe-mode:bool)
        (UEV_IMC)
        (with-capability (DPNF|C>DEBIT-FRAGMENT-NONCES account id nonces amounts wipe-mode)
            (XI_DebitNFT account id nonces amounts wipe-mode)
        )
    )
    ;;
    (defun XB_CreditSFT-Nonces (account:string id:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPSF|C>CREDIT-NONCES id nonces amounts)
            (XI_CreditSFT account id nonces amounts)
        )
    )
    (defun XB_CreditNFT-Nonces (account:string id:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPNF|C>CREDIT-NONCES id nonces amounts)
            (XI_CreditNFT account id nonces amounts)
        )
    )
    (defun XE_DebitSFT-Nonces (account:string id:string nonces:[integer] amounts:[integer] wipe-mode:bool)
        (UEV_IMC)
        (with-capability (DPSF|C>DEBIT-NONCES account id nonces amounts wipe-mode)
            (XI_DebitSFT account id nonces amounts wipe-mode)
        )
    )
    (defun XE_DebitNFT-Nonces (account:string id:string nonces:[integer] amounts:[integer] wipe-mode:bool)
        (UEV_IMC)
        (with-capability (DPNF|C>DEBIT-NONCES account id nonces amounts wipe-mode)
            (XI_DebitNFT account id nonces amounts wipe-mode)
        )
    )
    ;;
    (defun XE_CreditSFT-HybridNonces (account:string id:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPSF|C>CREDIT-HYBRID-NONCES id nonces amounts)
            (XI_CreditSFT account id nonces amounts)
        )
    )
    (defun XE_CreditNFT-HybridNonces (account:string id:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPNF|C>CREDIT-HYBRID-NONCES id nonces amounts)
            (XI_CreditNFT account id nonces amounts)
        )
    )
    (defun XE_DebitSFT-HybridNonces (account:string id:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPSF|C>DEBIT-HYBRID-NONCES account id nonces amounts)
            (XI_DebitSFT account id nonces amounts false)
        )
    )
    (defun XE_DebitNFT-HybridNonces (account:string id:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPNF|C>DEBIT-HYBRID-NONCES account id nonces amounts)
            (XI_DebitNFT account id nonces amounts false)
        )
    )
    ;;
    ;;T2x4
    (defun XI_CreditSFT (account:string id:string nonces:[integer] amounts:[integer])
        (XI_CreditCollectables account id true nonces amounts)
    )
    (defun XI_CreditNFT (account:string id:string nonces:[integer] amounts:[integer])
        (XI_CreditCollectables account id false nonces amounts)
    )
    ;;
    (defun XI_DebitSFT (account:string id:string nonces:[integer] amounts:[integer] wipe-mode:bool)
        (XI_DebitCollectables account id true nonces amounts wipe-mode)
    )
    (defun XI_DebitNFT (account:string id:string nonces:[integer] amounts:[integer] wipe-mode:bool)
        (XI_DebitCollectables account id false nonces amounts wipe-mode)
    )
    ;;T1x2
    (defun XI_CreditCollectables (account:string id:string son:bool nonces:[integer] amounts:[integer])
        (XI_CreditOrDebitCollectables account id son nonces amounts true false)
    )
    (defun XI_DebitCollectables (account:string id:string son:bool nonces:[integer] amounts:[integer] wipe-mode:bool)
        (XI_CreditOrDebitCollectables account id son nonces amounts false wipe-mode)
    )
    ;;T0x1
    (defun XI_CreditOrDebitCollectables (account:string id:string son:bool nonces:[integer] amounts:[integer] cod:bool wipe-mode:bool)
        (let
            (
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (ref-DPDC:module{DpdcV5} DPDC)
                ;;
                (split:object{OuronetIntegersV2.NonceSplitter} (ref-U|INT::UC_NonceSplitter nonces amounts))
                (negative-nonces:[integer] (at "negative-nonces" split))
                (positive-nonces:[integer] (at "positive-nonces" split))
                (negative-counterparts:[integer] (at "negative-counterparts" split))
                (positive-counterparts:[integer] (at "positive-counterparts" split))
                ;;
                (n0:integer (at 0 nonces))
                (a0:integer (at 0 amounts))
                (l1:integer (length nonces))
                (l2:integer (length amounts))
                (negatives:integer (length negative-nonces))
                (positives:integer (length positive-nonces))
                ;;
                (isg:bool (and (= l1 1) (= l2 1)))                  ;;iz-single
                (inn:bool (< n0 0))                                 ;;iz-nonce-negative
                (ong:bool (and (> negatives 0) (= positives 0)))    ;;only-negatives
                (onp:bool (and (> positives 0) (= negatives 0)))    ;;only-positives
            )
            (cond
                ;;SINGLE
                ;;Native Nonce
                ((UC_AndTruths [isg (not inn) cod son])                             (require-capability (DPSF|C>CREDIT-NONCE id n0)))
                ((UC_AndTruths [isg (not inn) cod (not son)])                       (require-capability (DPNF|C>CREDIT-NONCE id n0 a0)))
                ((UC_AndTruths [isg (not inn) (not cod) son])                       (require-capability (DPSF|C>DEBIT-NONCE account id n0 a0 wipe-mode)))
                ((UC_AndTruths [isg (not inn) (not cod) (not son)])                 (require-capability (DPNF|C>DEBIT-NONCE account id n0 a0 wipe-mode)))
                ;;Fragment Nonce
                ((UC_AndTruths [isg inn cod son])                                   (require-capability (DPSF|C>CREDIT-FRAGMENT-NONCE id n0)))
                ((UC_AndTruths [isg inn cod (not son)])                             (require-capability (DPNF|C>CREDIT-FRAGMENT-NONCE id n0)))
                ((UC_AndTruths [isg inn (not cod) son])                             (require-capability (DPSF|C>DEBIT-FRAGMENT-NONCE account id n0 a0 wipe-mode)))
                ((UC_AndTruths [isg inn (not cod) (not son)])                       (require-capability (DPNF|C>DEBIT-FRAGMENT-NONCE account id n0 a0 wipe-mode)))
                ;;
                ;;MULTI
                ;;Native Nonces
                ((UC_AndTruths [(not isg) (not ong) onp cod son])                   (require-capability (DPSF|C>CREDIT-NONCES id nonces amounts)))
                ((UC_AndTruths [(not isg) (not ong) onp cod (not son)])             (require-capability (DPNF|C>CREDIT-NONCES id nonces amounts)))
                ((UC_AndTruths [(not isg) (not ong) onp (not cod) son])             (require-capability (DPSF|C>DEBIT-NONCES account id nonces amounts wipe-mode)))
                ((UC_AndTruths [(not isg) (not ong) onp (not cod) (not son)])       (require-capability (DPNF|C>DEBIT-NONCES account id nonces amounts wipe-mode)))
                ;;Fragment Nonces
                ((UC_AndTruths [(not isg) ong cod son])                             (require-capability (DPSF|C>CREDIT-FRAGMENT-NONCES id nonces amounts)))
                ((UC_AndTruths [(not isg) ong cod (not son)])                       (require-capability (DPNF|C>CREDIT-FRAGMENT-NONCES id nonces amounts)))
                ((UC_AndTruths [(not isg) ong (not cod) son])                       (require-capability (DPSF|C>DEBIT-FRAGMENT-NONCES account id nonces amounts wipe-mode)))
                ((UC_AndTruths [(not isg) ong (not cod) (not son)])                 (require-capability (DPNF|C>DEBIT-FRAGMENT-NONCES account id nonces amounts wipe-mode)))
                ;;Hybrid (Native and Fragment) Nonces
                ((UC_AndTruths [(not isg) (not ong) (not onp) cod son])             (require-capability (DPSF|C>CREDIT-HYBRID-NONCES id nonces amounts)))
                ((UC_AndTruths [(not isg) (not ong) (not onp) cod (not son)])       (require-capability (DPNF|C>CREDIT-HYBRID-NONCES id nonces amounts)))
                ((UC_AndTruths [(not isg) (not ong) (not onp) (not cod) son])       (require-capability (DPSF|C>DEBIT-HYBRID-NONCES account id nonces amounts)))
                ((UC_AndTruths [(not isg) (not ong) (not onp) (not cod) (not son)]) (require-capability (DPNF|C>DEBIT-HYBRID-NONCES account id nonces amounts)))
                true
            )
            (if cod
                (ref-DPDC::XE_DeployAccountWNE account id son)
                true
            )
            (if (and (> negatives 0) (= positives 0))
                ;; only negative nonces
                (MappedCreditOrDebitDPDC account id son negative-nonces negative-counterparts cod)
                (if (and (> positives 0) (= negatives 0))
                    ;;only positive nonces
                    (if son
                        ;;If SFT
                        (MappedCreditOrDebitDPDC account id son positive-nonces positive-counterparts cod)
                        ;;If NFT
                        (if cod
                            ;;If Credit
                            (MappedUpdateOwnerNFT id positive-nonces account false)
                            ;;If Debit
                            (MappedUpdateOwnerNFT id positive-nonces account true)
                        )
                    )
                    ;;positive and negative nonces
                    (do
                        (MappedCreditOrDebitDPDC account id son negative-nonces negative-counterparts cod)
                        (if son
                            (MappedCreditOrDebitDPDC account id son positive-nonces positive-counterparts cod)
                            (if cod
                                (MappedUpdateOwnerNFT id positive-nonces account false)
                                (MappedUpdateOwnerNFT id positive-nonces account true)
                            )
                        )
                    )
                )
            )
        )
    )
    ;;
    (defun XI_RegisterCollectables:object{IgnisCollectorV2.OutputCumulator}
        (
            id:string son:bool nonce-classes:[integer] amounts:[integer]
            input-nonce-datas:[object{DpdcUdcV3.DPDC|NonceData}] sft-set-mode:bool
        )
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPDC:module{DpdcV5} DPDC)
                (owner:string (ref-DPDC::UR_OwnerKonto id son))
                ;;
                (l:integer (length amounts))
                (fnc:integer (at 0 nonce-classes))
                (isg:bool (= l 1))
                (output-account:string
                    (if (!= fnc 0)
                        (ref-DPDC::GOV|DPDC|SC_NAME)
                        (ref-DPDC::UR_Verum5 id son)
                    )
                )
                ;;
                ;;Compute Cumulator Parameters
                (nu:integer (ref-DPDC::UR_NoncesUsed id son))
                (s-amounts:integer (fold (+) 0 amounts))
                (smallest:decimal (ref-DALOS::UR_UsagePrice "ignis|smallest"))
                (ft:string (take 2 id))
                (sh:string "E|")
                (raw-price:decimal (* smallest (dec s-amounts)))
                (price:decimal
                    (if (fold (and) true [(= ft sh) son (= nu 0)])
                        (/ raw-price 1000.0)
                        raw-price
                    )
                )
                (trigger:bool (ref-IGNIS::URC_IsVirtualGasZero))
                ;;
                ;;Computing Nonces that will be generated
                (current-nonce:integer (ref-DPDC::UR_NoncesUsed id son))
                (nonces-to-be-created:[integer]
                    (take (- 0 l) (enumerate 0 (+ current-nonce l)))
                )
                (n0:integer (at 0 nonces-to-be-created))
                (a0:integer (at 0 amounts))
                ;;
                ;;Generating Collection Elements Names, by registering them
                (collectable-names:[string]
                    (if (= l 1)
                        [(XI_RegisterSingleNonce id son fnc (at 0 amounts) (at 0 input-nonce-datas) sft-set-mode)]
                        (XI_RegisterMultipleNonces id son nonce-classes amounts input-nonce-datas)
                    )
                )
            )
            ;;Credit Created Elements to <output-account>, which is either <creator-account> or <dpdc> account
            (cond
                ((UC_AndTruths [isg son ])              (XB_CreditSFT-Nonce output-account id n0 a0))
                ((UC_AndTruths [isg (not son)])         (XB_CreditNFT-Nonce output-account id n0 a0))
                ((UC_AndTruths [(not isg) son])         (XB_CreditSFT-Nonces output-account id nonces-to-be-created amounts))
                ((UC_AndTruths [(not isg) (not son)])   (XB_CreditNFT-Nonces output-account id nonces-to-be-created amounts))
                true
            )
            (ref-IGNIS::UDC_ConstructOutputCumulator price owner trigger collectable-names)
        )
    )
    (defun XI_RegisterMultipleNonces:[string]
        (
            id:string son:bool nonce-classes:[integer] amounts:[integer]
            input-nonce-datas:[object{DpdcUdcV3.DPDC|NonceData}]
        )
        (require-capability (DPDC-C|C>REGISTER-MULTIPLE-NONCES id son amounts input-nonce-datas))
        (with-capability (SECURE)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                )
                (fold
                    (lambda
                        (acc:[string] idx:integer)
                        (let
                            (
                                (nonce-class:integer (at idx nonce-classes))
                                (amount:integer (at idx amounts))
                                (input-nonce-data:object{DpdcUdcV3.DPDC|NonceData} (at idx input-nonce-datas))
                            )
                            (ref-U|LST::UC_AppL acc
                                (XI_RegisterCollectionElement id son nonce-class amount input-nonce-data)
                            )
                        )
                    )
                    []
                    (enumerate 0 (- (length amounts) 1))
                )
            )
        )
    )
    (defun XI_RegisterSingleNonce:string
        (
            id:string son:bool nonce-class:integer amount:integer
            input-nonce-data:object{DpdcUdcV3.DPDC|NonceData} sft-set-mode:bool
        )
        (require-capability (DPDC-C|C>REGISTER-SINGLE-NONCE id son amount input-nonce-data sft-set-mode))
        (with-capability (SECURE)
            (XI_RegisterCollectionElement id son nonce-class amount input-nonce-data)
        )
    )
    (defun XI_RegisterCollectionElement:string
        (
            id:string son:bool nonce-class:integer amount:integer
            input-nonce-data:object{DpdcUdcV3.DPDC|NonceData}
        )
        (require-capability (SECURE))
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV4} INFO-ZERO)
                (ref-DPDC-UDC:module{DpdcUdcV3} DPDC-UDC)
                (ref-DPDC:module{DpdcV5} DPDC)
                (new-element-nonce:integer (+ (ref-DPDC::UR_NoncesUsed id son) 1))
                (account-for-supply-registering:string (ref-DPDC::UR_Verum5 id son))
                (nonce-holder:string
                    (if son
                        BAR
                        (ref-I|OURONET::OI|UC_ShortAccount account-for-supply-registering)
                    )
                )
                (element:object{DpdcUdcV3.DPDC|NonceElement} 
                    (ref-DPDC-UDC::UDC_NonceElement
                        nonce-class
                        new-element-nonce
                        amount
                        nonce-holder
                        input-nonce-data
                        (ref-DPDC-UDC::UDC_ZeroNonceData)
                    )
                )
            )
            (ref-DPDC::XE_I|CollectionElement id son new-element-nonce element)
            (ref-DPDC::XE_U|NoncesUsed id son new-element-nonce)
            (format "{} <{}>" [amount (at "name" input-nonce-data)])
        )
    )
    ;;===========================================
    ;;
    (defun MappedUpdateOwnerNFT (id:string nonces:[integer] account:string iz-bar:bool)
        (let
            (
                (ref-DPDC:module{DpdcV5} DPDC)
                (new-owner:string
                    (if iz-bar
                        BAR
                        account
                    )
                )
                (supply:integer
                    (if iz-bar 0 1)
                )
            )
            (map
                (lambda
                    (element:integer)
                    (do
                        (ref-DPDC::XE_U|NonceHolder id element new-owner)
                        (ref-DPDC::XE_W|Supply account id false element supply)
                        ;;
                    )
                    
                )
                nonces
                ;(enumerate 0 (- (length nonces) 1))
            )
        )
    )
    ;;Must account for exist/not-exist
    (defun CreditOrDebitDPDC (account:string id:string son:bool nonce:integer amount:integer cod:bool)
        (let
            (
                (ref-DPDC:module{DpdcV5} DPDC)
                (read-current-supply:integer (ref-DPDC::UR_AccountNonceSupply account id son nonce))
                (current-supply:integer 
                    (if (= read-current-supply -1)
                        0
                        read-current-supply
                    )
                )
                (new-supply:integer
                    (if cod
                        (+ current-supply amount)
                        (- current-supply amount)
                    )
                )
            )
            (if (= current-supply 0)
                (enforce cod "Cannot Debit 0 Amounts!")
                true
            )
            (ref-DPDC::XE_W|Supply account id son nonce new-supply)
        )
    )
    (defun MappedCreditOrDebitDPDC (account:string id:string son:bool nonces:[integer] amounts:[integer] cod:bool)
        (let
            (
                (l1:integer (length nonces))
                (l2:integer (length amounts))
            )
            (enforce (= l1 l2) "Invalid <nonces> and <amounts> lengths for CreditOrDebit Operation")
            (map
                (lambda
                    (idx:integer)
                    (CreditOrDebitDPDC account id son (at idx nonces) (at idx amounts) cod)
                )
                (enumerate 0 (- l1 1))
            )
        )
    )
)

(create-table P|T)
(create-table P|MT)