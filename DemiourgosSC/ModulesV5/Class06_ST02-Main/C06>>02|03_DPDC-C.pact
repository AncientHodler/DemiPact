(module DPDC-C GOV
    ;;
    (implements OuronetPolicy)
    (implements DpdcCreate)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-C                 (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPDC-C_ADMIN)))
    (defcap GOV|DPDC-C_ADMIN ()             (enforce-guard GOV|MD_DPDC-C))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::P|Info)))
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
        (id:string son:bool amount:integer ind:object{DpdcUdc.DPDC|NonceData} sft-set-mode:bool)
        @event
        (compose-capability (DPDC-C|C>REGISTER-NONCES  id son [amount] [ind] sft-set-mode))
    )
    (defcap DPDC-C|C>REGISTER-MULTIPLE-NONCES
        (id:string son:bool amounts:[integer] input-nonce-datas:[object{DpdcUdc.DPDC|NonceData}])
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
        (id:string son:bool amounts:[integer] input-nonce-datas:[object{DpdcUdc.DPDC|NonceData}] sft-set-mode:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
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
                            (input-nonce-data:object{DpdcUdc.DPDC|NonceData} (at idx input-nonce-datas))
                        )
                        (UEV_NonceDataForCreation input-nonce-data)
                        ;;Amount enforcement
                        (if son
                            (if sft-set-mode
                                (enforce (= amount 0) (format "When Defining an SFT Set, {} must be equal to 0" [amount]))
                                (enforce (>= amount 1) (format "For an SFT Collectable the {} must be greater or equal to 1" [amount]))
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
        @event
        (compose-capability (DPDC-C|C>SINGLE-CREDIT id true nonce true))
    )
    (defcap DPNF|C>CREDIT-FRAGMENT-NONCE (id:string nonce:integer)
        @event
        (compose-capability (DPDC-C|C>SINGLE-CREDIT id false nonce true))
    )
    (defcap DPSF|C>CREDIT-NONCE (id:string nonce:integer)
        @event
        (compose-capability (DPDC-C|C>SINGLE-CREDIT id true nonce false))
    )
    (defcap DPNF|C>CREDIT-NONCE (id:string nonce:integer amount:integer)
        @event
        (enforce (= amount 1) "Credit amount is must be 1 for NFTs")
        (compose-capability (DPDC-C|C>SINGLE-CREDIT id false nonce false))
    )
    (defcap DPDC-C|C>SINGLE-CREDIT (id:string son:bool nonce:integer fragments-or-native:bool)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (UEV_NonceType nonce fragments-or-native)
            (ref-DPDC::UEV_Nonce id son nonce)
            (compose-capability (P|DPDC-C|CALLER))
        )
    )
    ;;
    ;;Multi-Credit
    (defcap DPSF|C>CREDIT-FRAGMENT-NONCES (id:string nonces:[integer] amounts:[integer])
        @event
        (compose-capability (DPDC-C|C>MULTI-CREDIT id true nonces amounts true))
    )
    (defcap DPNF|C>CREDIT-FRAGMENT-NONCES (id:string nonces:[integer] amounts:[integer])
        @event
        (compose-capability (DPDC-C|C>MULTI-CREDIT id false nonces amounts true))
    )
    (defcap DPSF|C>CREDIT-NONCES (id:string nonces:[integer] amounts:[integer])
        @event
        (compose-capability (DPDC-C|C>MULTI-CREDIT id true nonces amounts false))
    )
    (defcap DPNF|C>CREDIT-NONCES (id:string nonces:[integer] amounts:[integer])
        @event
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
        @event
        (compose-capability (DPDC|C>HYBRID-MULTI-CREDIT id true nonces amounts))
    )
    (defcap DPNF|C>CREDIT-HYBRID-NONCES (id:string nonces:[integer] amounts:[integer])
        @event
        (compose-capability (DPDC|C>HYBRID-MULTI-CREDIT id false nonces amounts))
    )
    (defcap DPDC|C>HYBRID-MULTI-CREDIT (id:string son:bool nonces:[integer] amounts:[integer])
        (UEV_HybridNonces nonces)
        (compose-capability (DPDC-C|CX>MULTI-CREDIT id son nonces amounts))
    )
    (defcap DPDC-C|CX>MULTI-CREDIT (id:string son:bool nonces:[integer] amounts:[integer])
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (l1:integer (length nonces))
                (l2:integer (length amounts))
            )
            (enforce (= l1 l2) (format "Nonces {} are incompatible with {} Amounts for Crediting" [nonces amounts]))
            (ref-DPDC::UEV_NonceMapper id son nonces)
            (compose-capability (P|DPDC-C|CALLER))
        )
    )
    ;;
    ;;
    ;;DEBIT
    ;;Single Debit
    (defcap DPSF|C>DEBIT-FRAGMENT-NONCE (id:string account:string nonce:integer amount:integer)
        @event
        (compose-capability (DPDC-C|C>SINGLE-DEBIT id true account nonce amount true))
    )
    (defcap DPNF|C>DEBIT-FRAGMENT-NONCE (id:string account:string nonce:integer amount:integer)
        @event
        (compose-capability (DPDC-C|C>SINGLE-DEBIT id false account nonce amount true))
    )
    ;;
    (defcap DPSF|C>DEBIT-NONCE (id:string account:string nonce:integer amount:integer)
        @event
        (compose-capability (DPDC-C|C>SINGLE-DEBIT id true account nonce amount false))
    )
    (defcap DPNF|C>DEBIT-NONCE (id:string account:string nonce:integer amount:integer)
        @event
        (compose-capability (DPDC-C|C>SINGLE-DEBIT id false account nonce amount false))
    )
    (defcap DPDC-C|C>SINGLE-DEBIT (id:string son:bool account:string nonce:integer amount:integer fragments-or-native:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (ref-DPDC::UEV_Nonce id son nonce)
            ;;
            (UEV_NonceType nonce fragments-or-native)
            (UEV_NonceInclusion id son account nonce fragments-or-native)
            (UEV_Quantity id son account nonce amount)
            ;;
            (compose-capability (P|DPDC-C|CALLER))
        )
    )
    ;;Multi-Debit
    (defcap DPSF|C>DEBIT-FRAGMENT-NONCES (id:string account:string nonces:[integer] amounts:[integer])
        @event
        (compose-capability (DPDC|C>MULTI-DEBIT id true account nonces amounts true))
    )
    (defcap DPNF|C>DEBIT-FRAGMENT-NONCES (id:string account:string nonces:[integer] amounts:[integer])
        @event
        (compose-capability (DPDC|C>MULTI-DEBIT id false account nonces amounts true))
    )
    (defcap DPSF|C>DEBIT-NONCES (id:string account:string nonces:[integer] amounts:[integer])
        @event
        (compose-capability (DPDC|C>MULTI-DEBIT id true account nonces amounts false))
    )
    (defcap DPNF|C>DEBIT-NONCES (id:string account:string nonces:[integer] amounts:[integer])
        @event
        (compose-capability (DPDC|C>MULTI-DEBIT id false account nonces amounts false))
    )
    (defcap DPDC|C>MULTI-DEBIT (id:string son:bool account:string nonces:[integer] amounts:[integer] fragments-or-native:bool)
        (UEV_NonceTypeMapper nonces fragments-or-native)
        (UEV_NonceInclusionMapper id son account nonces fragments-or-native)
        (compose-capability (DPDC|CX>MULTI-DEBIT id son account nonces amounts))
    )
    ;;Hybrid Multi Debit
    (defcap DPSF|C>DEBIT-HYBRID-NONCES (id:string account:string nonces:[integer] amounts:[integer])
        @event
        (compose-capability (DPDC|C>HYBRID-MULTI-DEBIT id true account nonces amounts))
    )
    (defcap DPNF|C>DEBIT-HYBRID-NONCES (id:string account:string nonces:[integer] amounts:[integer])
        @event
        (compose-capability (DPDC|C>HYBRID-MULTI-DEBIT id false account nonces amounts))
    )
    (defcap DPDC|C>HYBRID-MULTI-DEBIT (id:string son:bool account:string nonces:[integer] amounts:[integer])
        (let
            (
                (split-nonces:object{OuronetIntegersV2.SplitIntegers} (UEV_HybridNonces nonces))
                (negative-nonces:[integer] (at "negative" split-nonces))
                (positive-nonces:[integer] (at "positive" split-nonces))
            )
            (UEV_NonceInclusionMapper id son account negative-nonces false)
            (UEV_NonceInclusionMapper id son account positive-nonces true)
            (compose-capability (DPDC|CX>MULTI-DEBIT id son account nonces amounts))
        )
    )
    (defcap DPDC|CX>MULTI-DEBIT (id:string son:bool account:string nonces:[integer] amounts:[integer])
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
                (l1:integer (length nonces))
                (l2:integer (length amounts))
            )
            (enforce (= l1 l2) (format "Nonces {} and Amounts {} are invalid for Operation" [nonces amounts]))
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (ref-DPDC::UEV_NonceMapper id son nonces)
            (UEV_QuantityMapper id son account nonces amounts)
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
    (defun UEV_NonceDataForCreation (ind:object{DpdcUdc.DPDC|NonceData})
        @doc "Validates the ind for creation of new nonce"
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
                (empty-data-dc:object{DpdcUdc.DPDC|NonceData}
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
    (defun UEV_NonceInclusion (id:string son:bool account:string nonce:integer fragments-or-native:bool)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
                (account-nonces:[integer] (ref-DPDC::UR_AccountNonces id son account fragments-or-native))
                (iz-contained:bool (contains nonce account-nonces))
            )
            (enforce iz-contained (format "Account {} doesnt hold Nonce {}" [account nonce]))
        )
    )
    (defun UEV_Quantity (id:string son:bool account:string nonce:integer amount:integer)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (nonce-supply:integer (ref-DPDC::UR_AccountNonceSupply id son account nonce))
            )
            (enforce 
                (<= amount nonce-supply) 
                (format "Amount of {} is not smaller than or equal to the {} for ID {} and Nonce {} on Accoumt {}" [amount nonce-supply id nonce account])
            )
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
    (defun UEV_NonceInclusionMapper (id:string son:bool account:string nonces:[integer] fragments-or-native:bool)
        (map
            (lambda
                (idx:integer)
                (UEV_NonceInclusion id son account (at idx nonces) fragments-or-native)
            )
            (enumerate 0 (- (length nonces) 1))
        )
    )
    (defun UEV_QuantityMapper (id:string son:bool account:string nonces:[integer] amounts:[integer])
        (map
            (lambda
                (idx:integer)
                (UEV_Quantity id son account (at idx nonces) (at idx amounts))
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
    (defun C_CreateNewNonce:object{IgnisCollector.OutputCumulator}
        (
            id:string son:bool nonce-class:integer amount:integer
            input-nonce-data:object{DpdcUdc.DPDC|NonceData} sft-set-mode:bool
        )
        (UEV_IMC)
        (with-capability (DPDC-C|C>REGISTER-SINGLE-NONCE id son amount input-nonce-data sft-set-mode)
            (XI_RegisterCollectables id son [nonce-class] [amount] [input-nonce-data] sft-set-mode)
        )
    )
    (defun C_CreateNewNonces:object{IgnisCollector.OutputCumulator}
        (
            id:string son:bool amounts:[integer]
            input-nonce-datas:[object{DpdcUdc.DPDC|NonceData}]
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
    (defun XE_CreditSFT-FragmentNonce (id:string account:string nonce:integer amount:integer)
        (UEV_IMC)
        (with-capability (DPSF|C>CREDIT-FRAGMENT-NONCE id nonce)
            (XI_CreditSFT id account [nonce] [amount])
        )
    )
    (defun XE_CreditNFT-FragmentNonce (id:string account:string nonce:integer amount:integer)
        (UEV_IMC)
        (with-capability (DPNF|C>CREDIT-FRAGMENT-NONCE id nonce)
            (XI_CreditNFT id account [nonce] [amount])
        )
    )
    (defun XE_DebitSFT-FragmentNonce (id:string account:string nonce:integer amount:integer)
        (UEV_IMC)
        (with-capability (DPSF|C>DEBIT-FRAGMENT-NONCE id account nonce amount)
            (XI_DebitSFT id account [nonce] [amount])
        )
    )
    (defun XE_DebitNFT-FragmentNonce (id:string account:string nonce:integer amount:integer)
        (UEV_IMC)
        (with-capability (DPNF|C>DEBIT-FRAGMENT-NONCE id account nonce amount)
            (XI_DebitNFT id account [nonce] [amount])
        )
    )
    ;;
    (defun XB_CreditSFT-Nonce (id:string account:string nonce:integer amount:integer)
        (UEV_IMC)
        (with-capability (DPSF|C>CREDIT-NONCE id nonce)
            (XI_CreditSFT id account [nonce] [amount])
        )
    )
    (defun XB_CreditNFT-Nonce (id:string account:string nonce:integer amount:integer)
        (UEV_IMC)
        (with-capability (DPNF|C>CREDIT-NONCE id nonce amount)
            (XI_CreditNFT id account [nonce] [amount])
        )
    )
    (defun XE_DebitSFT-Nonce (id:string account:string nonce:integer amount:integer)
        (UEV_IMC)
        (with-capability (DPSF|C>DEBIT-NONCE id account nonce amount)
            (XI_DebitSFT id account [nonce] [amount])
        )
    )
    (defun XE_DebitNFT-Nonce (id:string account:string nonce:integer amount:integer)
        (UEV_IMC)
        (with-capability (DPNF|C>DEBIT-NONCE id account nonce amount)
            (XI_DebitNFT id account [nonce] [amount])
        )
    )
    ;;
    (defun XE_CreditSFT-FragmentNonces (id:string account:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPSF|C>CREDIT-FRAGMENT-NONCES id nonces amounts)
            (XI_CreditSFT id account nonces amounts)
        )
    )
    (defun XE_CreditNFT-FragmentNonces (id:string account:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPNF|C>CREDIT-FRAGMENT-NONCES id nonces amounts)
            (XI_CreditNFT id account nonces amounts)
        )
    )
    (defun XE_DebitSFT-FragmentNonces (id:string account:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPSF|C>DEBIT-FRAGMENT-NONCES id account nonces amounts)
            (XI_DebitSFT id account nonces amounts)
        )
    )
    (defun XE_DebitNFT-FragmentNonces (id:string account:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPNF|C>DEBIT-FRAGMENT-NONCES id account nonces amounts)
            (XI_DebitNFT id account nonces amounts)
        )
    )
    ;;
    (defun XB_CreditSFT-Nonces (id:string account:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPSF|C>CREDIT-NONCES id nonces amounts)
            (XI_CreditSFT id account nonces amounts)
        )
    )
    (defun XB_CreditNFT-Nonces (id:string account:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPNF|C>CREDIT-NONCES id nonces amounts)
            (XI_CreditNFT id account nonces amounts)
        )
    )
    (defun XE_DebitSFT-Nonces (id:string account:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPSF|C>DEBIT-NONCES id account nonces amounts)
            (XI_DebitSFT id account nonces amounts)
        )
    )
    (defun XE_DebitNFT-Nonces (id:string account:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPNF|C>DEBIT-NONCES id account nonces amounts)
            (XI_DebitNFT id account nonces amounts)
        )
    )
    ;;
    (defun XE_CreditSFT-HybridNonces (id:string account:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPSF|C>CREDIT-HYBRID-NONCES id nonces amounts)
            (XI_CreditSFT id account nonces amounts)
        )
    )
    (defun XE_CreditNFT-HybridNonces (id:string account:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPNF|C>CREDIT-HYBRID-NONCES id nonces amounts)
            (XI_CreditNFT id account nonces amounts)
        )
    )
    (defun XE_DebitSFT-HybridNonces (id:string account:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPSF|C>DEBIT-HYBRID-NONCES id account nonces amounts)
            (XI_DebitSFT id account nonces amounts)
        )
    )
    (defun XE_DebitNFT-HybridNonces (id:string account:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPNF|C>DEBIT-HYBRID-NONCES id account nonces amounts)
            (XI_DebitNFT id account nonces amounts)
        )
    )
    ;;
    ;;T2x4
    (defun XI_CreditSFT (id:string account:string nonces:[integer] amounts:[integer])
        (XI_CreditCollectables id true account nonces amounts)
    )
    (defun XI_CreditNFT (id:string account:string nonces:[integer] amounts:[integer])
        (XI_CreditCollectables id false account nonces amounts)
    )
    ;;
    (defun XI_DebitSFT (id:string account:string nonces:[integer] amounts:[integer])
        (XI_DebitCollectables id true account nonces amounts)
    )
    (defun XI_DebitNFT (id:string account:string nonces:[integer] amounts:[integer])
        (XI_DebitCollectables id false account nonces amounts)
    )
    ;;T1x2
    (defun XI_CreditCollectables (id:string son:bool account:string nonces:[integer] amounts:[integer])
        (XI_CreditOrDebitCollectables id son account nonces amounts true)
    )
    (defun XI_DebitCollectables (id:string son:bool account:string nonces:[integer] amounts:[integer])
        (XI_CreditOrDebitCollectables id son account nonces amounts false)
    )
    ;;T0x1
    (defun XI_CreditOrDebitCollectables (id:string son:bool account:string nonces:[integer] amounts:[integer] cod:bool)
        (let
            (
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (ref-DPDC:module{Dpdc} DPDC)
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
                ((UC_AndTruths [isg (not inn) (not cod) son])                       (require-capability (DPSF|C>DEBIT-NONCE id account n0 a0)))
                ((UC_AndTruths [isg (not inn) (not cod) (not son)])                 (require-capability (DPNF|C>DEBIT-NONCE id account n0 a0)))
                ;;Fragment Nonce
                ((UC_AndTruths [isg inn cod son])                                   (require-capability (DPSF|C>CREDIT-FRAGMENT-NONCE id n0)))
                ((UC_AndTruths [isg inn cod (not son)])                             (require-capability (DPNF|C>CREDIT-FRAGMENT-NONCE id n0)))
                ((UC_AndTruths [isg inn (not cod) son])                             (require-capability (DPSF|C>DEBIT-FRAGMENT-NONCE id account n0 a0)))
                ((UC_AndTruths [isg inn (not cod) (not son)])                       (require-capability (DPNF|C>DEBIT-FRAGMENT-NONCE id account n0 a0)))
                ;;
                ;;MULTI
                ;;Native Nonces
                ((UC_AndTruths [(not isg) (not ong) onp cod son])                   (require-capability (DPSF|C>CREDIT-NONCES id nonces amounts)))
                ((UC_AndTruths [(not isg) (not ong) onp cod (not son)])             (require-capability (DPNF|C>CREDIT-NONCES id nonces amounts)))
                ((UC_AndTruths [(not isg) (not ong) onp (not cod) son])             (require-capability (DPSF|C>DEBIT-NONCES id account nonces amounts)))
                ((UC_AndTruths [(not isg) (not ong) onp (not cod) (not son)])       (require-capability (DPNF|C>DEBIT-NONCES id account nonces amounts)))
                ;;Fragment Nonces
                ((UC_AndTruths [(not isg) ong cod son])                             (require-capability (DPSF|C>CREDIT-FRAGMENT-NONCES id nonces amounts)))
                ((UC_AndTruths [(not isg) ong cod (not son)])                       (require-capability (DPNF|C>CREDIT-FRAGMENT-NONCES id nonces amounts)))
                ((UC_AndTruths [(not isg) ong (not cod) son])                       (require-capability (DPSF|C>DEBIT-FRAGMENT-NONCES id account nonces amounts)))
                ((UC_AndTruths [(not isg) ong (not cod) (not son)])                 (require-capability (DPNF|C>DEBIT-FRAGMENT-NONCES id account nonces amounts)))
                ;;Hybrid (Native and Fragment) Nonces
                ((UC_AndTruths [(not isg) (not ong) (not onp) cod son])             (require-capability (DPSF|C>CREDIT-HYBRID-NONCES id nonces amounts)))
                ((UC_AndTruths [(not isg) (not ong) (not onp) cod (not son)])       (require-capability (DPNF|C>CREDIT-HYBRID-NONCES id nonces amounts)))
                ((UC_AndTruths [(not isg) (not ong) (not onp) (not cod) son])       (require-capability (DPSF|C>DEBIT-HYBRID-NONCES id account nonces amounts)))
                ((UC_AndTruths [(not isg) (not ong) (not onp) (not cod) (not son)]) (require-capability (DPNF|C>DEBIT-HYBRID-NONCES id account nonces amounts)))
                true
            )
            (if cod
                (ref-DPDC::XE_DeployAccountWNE id son account)
                true
            )
            (with-capability (SECURE)
                (if (and (> negatives 0) (= positives 0))
                    ;; only negative nonces
                    (XI_CreditOrDebitNegatives id son account negative-nonces negative-counterparts cod)
                    (if (and (> positives 0) (= negatives 0))
                        ;;only positive nonces
                        (XI_CreditOrDebitPositives id son account positive-nonces positive-counterparts cod)
                        ;;positive and negative nonces
                        (do
                            (XI_CreditOrDebitNegatives id son account negative-nonces negative-counterparts cod)
                            (XI_CreditOrDebitPositives id son account positive-nonces positive-counterparts cod)
                        )
                    )
                )
            )
        )
    )
    ;;
    (defun XI_CreditOrDebitNegatives (id:string son:bool account:string negative-nonces:[integer] negative-counterparts:[integer] cod:bool)
        (require-capability (SECURE))
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::XE_U|DPDC-Fragments 
                id son account
                (ref-DPDC-UDC::UC_CreditOrDebitNonceObject 
                    (ref-DPDC::UR_AccountFragments id son account)
                    negative-nonces negative-counterparts cod
                )
            )
        )
        
    )
    (defun XI_CreditOrDebitPositives (id:string son:bool account:string positive-nonces:[integer] positive-counterparts:[integer] cod:bool)
        (require-capability (SECURE))
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (if son
                (ref-DPDC::XE_U|SFT-Holdings
                    id account
                    (ref-DPDC-UDC::UC_CreditOrDebitNonceObject
                        (ref-DPDC::UR_SemiFungibleAccountHoldings id account)
                        positive-nonces positive-counterparts cod
                    )
                )
                (ref-DPDC::XE_U|NFT-Holdings
                    id account
                    (if cod
                        (filter (!= 0)
                            (+
                                (ref-DPDC::UR_NonFungibleAccountHoldings id account)
                                positive-nonces
                            )
                        )
                        (filter (!= 0)
                            (fold
                                (lambda
                                    (acc:[integer] idx:integer)
                                    (ref-U|LST::UC_RemoveItem acc (at idx positive-nonces))
                                )
                                (ref-DPDC::UR_NonFungibleAccountHoldings id account)
                                (enumerate 0 (- (length positive-nonces) 1))
                            )
                        )
                    )
                )
            )
        )
    )
    ;;
    (defun XI_RegisterCollectables:object{IgnisCollector.OutputCumulator}
        (
            id:string son:bool nonce-classes:[integer] amounts:[integer]
            input-nonce-datas:[object{DpdcUdc.DPDC|NonceData}] sft-set-mode:bool
        )
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (owner:string (ref-DPDC::UR_OwnerKonto id son))
                (r-nft-create-account:string (ref-DPDC::UR_Verum5 id son))
                ;;
                ;;Compute Cumulator Parameters
                (s-amounts:integer (fold (+) 0 amounts))
                (smallest:decimal (ref-DALOS::UR_UsagePrice "ignis|smallest"))
                (price:decimal (* smallest (dec s-amounts)))
                (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                ;;
                ;;Computing Nonces that will be generated
                (current-nonce:integer (ref-DPDC::UR_NoncesUsed id son))
                (l:integer (length amounts))
                (nonces-to-be-created:[integer]
                    (take (- 0 l) (enumerate 0 (+ current-nonce l)))
                )
                (n0:integer (at 0 nonces-to-be-created))
                (a0:integer (at 0 amounts))
                ;;
                ;;Generating Collection Elements Names, by registering them
                (collectable-names:[string]
                    (if (= l 1)
                        [(XI_RegisterSingleNonce id son (at 0 nonce-classes) (at 0 amounts) (at 0 input-nonce-datas) sft-set-mode)]
                        (XI_RegisterMultipleNonces id son nonce-classes amounts input-nonce-datas)
                    )
                )
                (isg:bool (= l 1))
            )
            ;;Credit Created Elements to <r-nft-create-account>
            (cond
                ((UC_AndTruths [isg son ])              (XB_CreditSFT-Nonce id r-nft-create-account n0 a0))
                ((UC_AndTruths [isg (not son)])         (XB_CreditNFT-Nonce id r-nft-create-account n0 a0))
                ((UC_AndTruths [(not isg) son])         (XB_CreditSFT-Nonces id r-nft-create-account nonces-to-be-created amounts))
                ((UC_AndTruths [(not isg) (not son)])   (XB_CreditNFT-Nonces id r-nft-create-account nonces-to-be-created amounts))
                true
            )
            (ref-IGNIS::IC|UDC_ConstructOutputCumulator price owner trigger collectable-names)
        )
    )
    (defun XI_RegisterMultipleNonces:[string]
        (
            id:string son:bool nonce-classes:[integer] amounts:[integer]
            input-nonce-datas:[object{DpdcUdc.DPDC|NonceData}]
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
                                (input-nonce-data:object{DpdcUdc.DPDC|NonceData} (at idx input-nonce-datas))
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
            input-nonce-data:object{DpdcUdc.DPDC|NonceData} sft-set-mode:bool
        )
        (require-capability (DPDC-C|C>REGISTER-SINGLE-NONCE id son amount input-nonce-data sft-set-mode))
        (with-capability (SECURE)
            (XI_RegisterCollectionElement id son nonce-class amount input-nonce-data)
        )
    )
    (defun XI_RegisterCollectionElement:string
        (
            id:string son:bool nonce-class:integer amount:integer
            input-nonce-data:object{DpdcUdc.DPDC|NonceData}
        )
        (require-capability (SECURE))
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-DPDC:module{Dpdc} DPDC)
                (new-element-nonce:integer (+ (ref-DPDC::UR_NoncesUsed id son) 1))
                (element:object{DpdcUdc.DPDC|NonceElement} 
                    (ref-DPDC-UDC::UDC_NonceElement
                        nonce-class
                        new-element-nonce
                        amount
                        true
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
)

(create-table P|T)
(create-table P|MT)