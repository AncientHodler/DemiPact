
(module DPDC-NM GOV
    ;;
    (implements OuronetPolicy)
    (implements DpdcNonceManagement)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-NM        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|DPDC-NM_ADMIN)))
    (defcap GOV|DPDC-NM_ADMIN ()    (enforce-guard GOV|MD_DPDC-NM))
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
    (defcap P|DPDC-NM|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC-NM|CALLER))
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
        (with-capability (GOV|DPDC-NM_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC-NM_ADMIN)
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
                (mg:guard (create-capability-guard (P|DPDC-NM|CALLER)))
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
    (defcap DPDC|S>CREATE-NONCE-OR-NONCES
        (id:string sft-or-nft:bool amount:[integer] ind:[object{Dpdc.DC|DataSchema}])
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
                (l1:integer (length amount))
                (l2:integer (length ind))
                (exist:bool (ref-DPDC::UR_C|Exists id sft-or-nft))
                (msg:string
                    (if (= l1 1)
                        "a single Nonce"
                        "multiple Nonces"
                    )
                )
            )
            (enforce (= l1 l2) (format "Incompatible Input Data for Creating {}" [msg]))
            (enforce exist (format "ID {} doesnt exist as an {} for a nonce to be created for" [id (if sft-or-nft "SFT" "NFT")]))
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (nonce-amount:integer (at idx amount))
                            (input-nonce-data:object{Dpdc.DC|DataSchema}
                                (at idx ind)
                            )
                        )
                        (UEV_NonceDataForCreation input-nonce-data)
                        ;;Amount enforcement
                        (if sft-or-nft
                            (enforce (>= nonce-amount 1) (format "For an SFT Collectable the {} must be greater or equal to 1" [amount]))
                            (enforce (= nonce-amount 1) (format "For an NFT Collectable the {} must be equal to 1" [amount]))
                        )
                    )
                )
                (enumerate 0 (- l2 1))
            )
            (ref-DPDC::CAP_Owner id sft-or-nft)
        )
    )
    ;;Credit
    (defcap DPDC|S>CREDIT-SINGLE-NONCE (id:string sft-or-nft:bool nonce:integer)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (current-nonce:integer (ref-DPDC::UR_NoncesUsed id sft-or-nft))
            )
            (enforce (!= nonce 0) "Nonce 0 cant be used for operation")
            (ref-DPDC::UEV_Nonce id sft-or-nft nonce)
        )
    )
    ;;Debit
    (defcap DPSF|S>DEBIT (id:string account:string nonce:integer amount:integer)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{Dpdc} DPDC)
                (existing-nonces:[integer] (ref-DPDC::UR_CA|OwnedNonces id true account))
                (existing-nonces-balances:[integer] (ref-DPDC::UR_CA|NoncesBalances id account))
                (nonce-position:integer (at 0 (ref-U|LST::UC_Search existing-nonces nonce)))
                (current-nonce-supply:integer (at nonce-position existing-nonces-balances))
            )
            (enforce (!= nonce 0) "Nonce 0 cant be used for operation")
            (ref-DPDC::UEV_Nonce id true nonce)
            (enforce (<= amount current-nonce-supply) (format "Debiting SFT {} is not allowed with {} amount" [id amount]))
        )
    )
    (defcap DPNF|S>DEBIT (id:string account:string nonce:integer)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (existing-nonces:[integer] (ref-DPDC::UR_CA|OwnedNonces id false account))
                (iz-nonce-present:bool (contains nonce existing-nonces))
            )
            (enforce (!= nonce 0) "Nonce 0 cant be used for operation")
            (ref-DPDC::UEV_Nonce id false nonce)
            (enforce iz-nonce-present (format "NFT {} nonce {} is not Present on Account {}" [id nonce account]))
        )
    )
    ;;{C3}
    ;;{C4}
    ;;
    (defcap DPDC|C>CREATE-NONCE
        (id:string sft-or-nft:bool amount:integer ind:object{Dpdc.DC|DataSchema})
        @event
        (compose-capability (DPDC|S>CREATE-NONCE-OR-NONCES id sft-or-nft [amount] [ind]))
    )
    (defcap DPDC|C>CREATE-NONCES
        (id:string sft-or-nft:bool amount:[integer] ind:[object{Dpdc.DC|DataSchema}])
        @event
        (let
            (
                (l1:integer (length amount))
            )
            (enforce (> l1 1) "Invalid Input variable length for a Multi Nonce Creation Capability")
            (compose-capability (DPDC|S>CREATE-NONCE-OR-NONCES id sft-or-nft amount ind))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun UEV_NonceDataForCreation (ind:object{Dpdc.DC|DataSchema})
        @doc "Validates the ind for creation of new nonce"
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
                (empty-data-dc:object{Dpdc.DC|DataSchema}
                    (ref-DPDC::UDC_EmptyDataDC)
                )
                (royalty:decimal (at "royalty" ind))
                (ignis:decimal (at "ignis" ind))
            )
            (enforce (!= empty-data-dc ind) "Incorrect Fragmentation Data")
            (ref-DPDC::UEV_Royalty royalty)     ;; Royalty can be set at -1.0 enabling Volumetric Royalty Fee.
            (ref-DPDC::UEV_IgnisRoyalty ignis)
        )
    )
    (defcap DPDC|C>FRAGMENT
        (
            id:string sft-or-nft:bool nonce:integer
            fragmentation-ind:object{Dpdc.DC|DataSchema}
        )
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
                (iz-fragmented:bool (ref-DPDC::UEV_IzNonceFragmented id sft-or-nft nonce))
                (empty-data-dc:object{Dpdc.DC|DataSchema}
                    (ref-DPDC::UDC_EmptyDataDC)
                )
            )
            (enforce (not iz-fragmented) "Nonce must not be fragmented")
            (UEV_NonceDataForCreation fragmentation-ind)
            (ref-DPDC::UEV_Nonce id sft-or-nft nonce)
            (ref-DPDC::CAP_Owner id sft-or-nft)
        )
    )
    ;;{F6}  [C]
    ;;
    (defun C_CreateNewNonce:object{IgnisCollector.OutputCumulator}
        (
            id:string sft-or-nft:bool set-class:integer amount:integer
            ind:object{Dpdc.DC|DataSchema}
        )
        (UEV_IMC)
        (with-capability (DPDC|C>CREATE-NONCE id sft-or-nft amount ind)
            (XI_CreateCollectableNonce id sft-or-nft set-class amount ind)
        )
    )
    (defun C_CreateNewNonces:object{IgnisCollector.OutputCumulator}
        (
            id:string sft-or-nft:bool amount:[integer]
            ind:[object{Dpdc.DC|DataSchema}]
        )
        (with-capability (DPDC|C>CREATE-NONCES id sft-or-nft amount ind)
            (XI_CreateCollectableNonces id sft-or-nft (make-list (length ind) 0) amount ind)
        )
    )
    (defun C_EnableNonceFragmentation:object{IgnisCollector.OutputCumulator}
        (
            id:string sft-or-nft:bool nonce:integer
            fragmentation-ind:object{Dpdc.DC|DataSchema}
        )
        (with-capability (DPDC|C>FRAGMENT id sft-or-nft nonce fragmentation-ind)
            (XI_FragmentNonce id sft-or-nft nonce fragmentation-ind)
        )
    )
    ;;{F7}  [X]
    (defun XI_CreateCollectableNonce:object{IgnisCollector.OutputCumulator}
        (
            id:string sft-or-nft:bool set-class:integer amount:integer
            ind:object{Dpdc.DC|DataSchema}
        )
        @doc "Creates a new Nonce Element for a given Digital Collection (SFT or NFT)"
        (XI_CreateCollectableNonces id sft-or-nft [set-class] [amount] [ind])
    )
    (defun XI_CreateCollectableNonces:object{IgnisCollector.OutputCumulator}
        (
            id:string sft-or-nft:bool set-class:[integer] amount:[integer]
            ind:[object{Dpdc.DC|DataSchema}]
        )
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (creator:string (ref-DPDC::UR_CreatorKonto id sft-or-nft))
                ;;
                (amounts:integer (fold (+) 0 amount))
                (smallest:decimal (ref-DALOS::UR_UsagePrice "ignis|smallest"))
                (price:decimal (* smallest (dec amounts)))
                (active-account:string (ref-DPDC::UR_OwnerKonto id sft-or-nft))
                (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                (current-nonce:integer (ref-DPDC::UR_NoncesUsed id sft-or-nft))
                (l:integer (length amount))
                (nonces-to-be-created:[integer]
                    (take (- 0 l) (enumerate 0 (+ current-nonce l)))
                )
                (collectable-names:[string]
                    (if (= l 1)
                        [(XI_SpawnNewNonce id sft-or-nft (at 0 set-class) (at 0 amount) (at 0 ind))]
                        (XI_SpawnNewNonces id sft-or-nft set-class amount ind)
                    )
                )
            )
            (map
                (lambda
                    (idx:integer)
                    (if sft-or-nft
                        (with-capability (DPDC|S>CREDIT-SINGLE-NONCE id true (at idx nonces-to-be-created))
                            (XI_CreditSFT id creator (at idx nonces-to-be-created) (at idx amount))
                        )
                        (with-capability (DPDC|S>CREDIT-SINGLE-NONCE id false (at idx nonces-to-be-created))
                            (XI_CreditNFT id creator (at idx nonces-to-be-created) (at idx amount))
                        )
                    )
                )
                (enumerate 0 (- l 1))
            )
            (ref-IGNIS::IC|UDC_ConstructOutputCumulator price active-account trigger collectable-names)
        )
    )
    ;;
    (defun XI_SpawnNewNonces:[string]
        (
            id:string sft-or-nft:bool set-class:[integer] amount:[integer]
            ind:[object{Dpdc.DC|DataSchema}]
        )
        (require-capability (DPDC|C>CREATE-NONCES id sft-or-nft amount ind))
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
                                (nonce-set-class:integer (at idx set-class))
                                (nonce-amount:integer (at idx amount))
                                (nonce-ind:object{Dpdc.DC|DataSchema} (at idx ind))
                            )
                            (ref-U|LST::UC_AppL acc
                                (XI_SpawnRawNonce id sft-or-nft nonce-set-class nonce-amount nonce-ind)
                            )
                        )
                    )
                    []
                    (enumerate 0 (- (length amount) 1))
                )
            )
        )
    )
    (defun XI_SpawnNewNonce:string
        (
            id:string sft-or-nft:bool set-class:integer amount:integer
            ind:object{Dpdc.DC|DataSchema}
        )
        (require-capability (DPDC|C>CREATE-NONCE id sft-or-nft amount ind))
        (with-capability (SECURE)
            (XI_SpawnRawNonce id sft-or-nft set-class amount ind)
        )
    )
    (defun XI_SpawnRawNonce:string
        (
            id:string sft-or-nft:bool set-class:integer amount:integer
            ind:object{Dpdc.DC|DataSchema}
        )
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
                (royalty:decimal (at "royalty" ind))
                (ignis:decimal (at "ignis" ind))
                (name:string (at "name" ind))
                (description:string (at "description" ind))
                ;;
                (score-md:[object{Dpdc.DPDC|Score}] [(ref-DPDC::UDC_NoScore)])
                (meta-data:[object] (+ score-md (at "meta-data" ind)))
                ;;
                (a-t:object{Dpdc.DC|URI|Type} (at "asset-type" ind))
                (image-t:bool (at "image" a-t))
                (audio-t:bool (at "audio" a-t))
                (video-t:bool (at "video" a-t))
                (document-t:bool (at "document" a-t))
                (archive-t:bool (at "archive" a-t))
                (model-t:bool (at "model" a-t))
                (exotic-t:bool (at "exotic" a-t))
                ;;
                (u1:object{Dpdc.DC|URI|Schema} (at "uri-primary" ind))
                (image-s1:string (at "image" u1))
                (audio-s1:string (at "audio" u1))
                (video-s1:string (at "video" u1))
                (document-s1:string (at "document" u1))
                (archive-s1:string (at "archive" u1))
                (model-s1:string (at "model" u1))
                (exotic-s1:string (at "exotic" u1))
                ;;
                (u2:object{Dpdc.DC|URI|Schema} (at "uri-secondary" ind))
                (image-s2:string (at "image" u2))
                (audio-s2:string (at "audio" u2))
                (video-s2:string (at "video" u2))
                (document-s2:string (at "document" u2))
                (archive-s2:string (at "archive" u2))
                (model-s2:string (at "model" u2))
                (exotic-s2:string (at "exotic" u2))
                ;;
                (u3:object{Dpdc.DC|URI|Schema} (at "uri-tertiary" ind))
                (image-s3:string (at "image" u3))
                (audio-s3:string (at "audio" u3))
                (video-s3:string (at "video" u3))
                (document-s3:string (at "document" u3))
                (archive-s3:string (at "archive" u3))
                (model-s3:string (at "model" u3))
                (exotic-s3:string (at "exotic" u3))
                ;;
                (uri-type:object{Dpdc.DC|URI|Type}
                    (ref-DPDC::UDC_UriType image-t audio-t video-t document-t archive-t model-t exotic-t)
                )
                (uri-primary:object{Dpdc.DC|URI|Schema}
                    (ref-DPDC::UDC_UriString image-s1 audio-s1 video-s1 document-s1 archive-s1 model-s1 exotic-s1)
                )
                (uri-secondary:object{Dpdc.DC|URI|Schema}
                    (ref-DPDC::UDC_UriString image-s2 audio-s2 video-s2 document-s2 archive-s2 model-s2 exotic-s2)
                )
                (uri-tertiary:object{Dpdc.DC|URI|Schema}
                    (ref-DPDC::UDC_UriString image-s3 audio-s3 video-s3 document-s3 archive-s3 model-s3 exotic-s3)
                )
                (collectible-data:object{Dpdc.DC|DataSchema}
                    (ref-DPDC::UDC_DataDC
                        royalty ignis name description meta-data
                        uri-type uri-primary uri-secondary uri-tertiary
                    )
                )
                (new-nonce:integer (+ (ref-DPDC::UR_NoncesUsed id sft-or-nft) 1))
                (collectible:object{Dpdc.DPDC|NonceElementSchema}
                    (ref-DPDC::UDC_NonceElement set-class new-nonce amount collectible-data (ref-DPDC::UDC_EmptyDataDC))
                )
                (current-existing-nonces:[object{Dpdc.DPDC|NonceElementSchema}]
                    (if sft-or-nft
                        (ref-DPDC::UR_ElementsSFT id)
                        (ref-DPDC::UR_ElementsNFT id)
                    )
                )
                (new-nonces:[object{Dpdc.DPDC|NonceElementSchema}]
                    (ref-U|LST::UC_AppL current-existing-nonces collectible)
                )
            )
            (ref-DPDC::XE_UP|SftOrNft id sft-or-nft new-nonces)
            (ref-DPDC::XB_UP|Specs id sft-or-nft
                (+
                    {"nonces-used" : new-nonce}
                    (remove "nonces-used" (ref-DPDC::UR_CollectionSpecs id sft-or-nft))
                )
            )
            (format "{} <{}>" [amount name])
            ;name
        )
    )
    ;;Credit
    (defun XI_CreditSFT (id:string account:string nonce:integer amount:integer)
        @doc "Credits <amount> of SFT <id> and <nonce> to <account>, only Adding Entry in the Balance Table"
        (require-capability (DPDC|S>CREDIT-SINGLE-NONCE id true nonce))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{Dpdc} DPDC)
                (existing-nonces:[integer] (ref-DPDC::UR_CA|OwnedNonces id true account))
                (existing-nonces-balances:[integer] (ref-DPDC::UR_CA|NoncesBalances id account))
                (iz-nonce-present:bool (contains nonce existing-nonces))
                ;;
            )
            (ref-DPDC::XE_DeployAccountWNE id true account)
            (if iz-nonce-present
                (let
                    (
                        (nonce-position:integer (at 0 (ref-U|LST::UC_Search existing-nonces nonce)))
                        (current-nonce-supply:integer (at nonce-position existing-nonces-balances))
                        (updated-balance:integer (+ current-nonce-supply amount))
                        (updated-nonces-balances:[integer] (ref-U|LST::UC_ReplaceAt existing-nonces-balances nonce-position updated-balance))
                    )
                    (ref-DPDC::XE_UAD|NoncesBalances id account updated-nonces-balances)
                )
                (let
                    (
                        (updated-nonces:[integer] (ref-U|LST::UC_AppL existing-nonces nonce))
                        (updated-nonces-balances:[integer] (ref-U|LST::UC_AppL existing-nonces-balances amount))
                    )
                    (ref-DPDC::XE_UAD|OwnedNonces id true account updated-nonces)
                    (ref-DPDC::XE_UAD|NoncesBalances id account updated-nonces-balances)
                )
            )
        )
    )
    (defun XI_CreditNFT (id:string account:string nonce:integer)
        @doc "Credits NFT <id> and <nonce> to <account>"
        (require-capability (DPDC|S>CREDIT-SINGLE-NONCE id false nonce))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{Dpdc} DPDC)
                (existing-nonces:[integer] (ref-DPDC::UR_CA|OwnedNonces id false account))
                (updated-nonces:[integer] (ref-U|LST::UC_AppL existing-nonces nonce))
            )
            (ref-DPDC::XE_DeployAccountWNE id true account)
            (ref-DPDC::XE_UAD|OwnedNonces id false account updated-nonces)
        )
    )
    ;;Debit
    (defun XI_DebitSFT (id:string account:string nonce:integer amount:integer)
        @doc "Debits <amount> of SFT <id> and <nonce> from <account>"
        (require-capability (DPSF|S>DEBIT id account nonce amount))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{Dpdc} DPDC)
                (existing-nonces:[integer] (ref-DPDC::UR_CA|OwnedNonces id true account))
                (existing-nonces-balances:[integer] (ref-DPDC::UR_CA|NoncesBalances id account))
                ;;
                (nonce-position:integer (at 0 (ref-U|LST::UC_Search existing-nonces nonce)))
                (current-nonce-supply:integer (at nonce-position existing-nonces-balances))
                (updated-balance:integer (- current-nonce-supply amount))
            )
            (if (!= updated-balance 0)
                (let
                    (
                        (updated-nonces-balances:[integer] (ref-U|LST::UC_ReplaceAt existing-nonces-balances nonce-position updated-balance))
                    )
                    (ref-DPDC::XE_UAD|NoncesBalances id account updated-nonces-balances)
                )
                (let
                    (
                        (updated-nonces:[integer] (ref-U|LST::UC_RemoveItemAt existing-nonces nonce-position))
                        (updated-nonces-balances:[integer] (ref-U|LST::UC_RemoveItemAt existing-nonces-balances nonce-position))
                    )
                    (ref-DPDC::XE_UAD|OwnedNonces id true account updated-nonces)
                    (ref-DPDC::XE_UAD|NoncesBalances id account updated-nonces-balances)
                )
            )
        )
    )
    (defun XI_DebitNFT (id:string account:string nonce:integer)
        @doc "Debit NFT <id> and <nonce> from <account>"
        (require-capability (DPNF|S>DEBIT id nonce account))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{Dpdc} DPDC)
                (existing-nonces:[integer] (ref-DPDC::UR_CA|OwnedNonces id false account))
                ;;
                (nonce-position:integer (at 0 (ref-U|LST::UC_Search existing-nonces nonce)))
                (updated-nonces:[integer] (ref-U|LST::UC_RemoveItemAt existing-nonces nonce-position))
            )
            (ref-DPDC::XE_UAD|OwnedNonces id false account updated-nonces)
        )
    )
    ;;
    (defun XI_FragmentNonce 
        (
            id:string sft-or-nft:bool nonce:integer
            fragmentation-ind:object{Dpdc.DC|DataSchema}
        )
        ;;START HERE
        true
    )
)

(create-table P|T)
(create-table P|MT)