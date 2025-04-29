(interface DemiourgosPactDigitalCollectibles-CreateDestroy
    @doc "Hold Exported Functions from the DPDC-DestroyCreate Module"
    ;;
    (defun C_Create:object{OuronetDalosV2.OutputCumulatorV2}
        (
            patron:string id:string amount:integer
            royalty:decimal ignis:decimal description:string meta-data:[object]
            image-t:bool audio-t:bool video-t:bool document-t:bool archive-t:bool model-t:bool exotic-t:bool
            image-s1:string audio-s1:string video-s1:string document-s1:string archive-s1:string model-s1:string exotic-s1:string
            image-s2:string audio-s2:string video-s2:string document-s2:string archive-s2:string model-s2:string exotic-s2:string
            image-s3:string audio-s3:string video-s3:string document-s3:string archive-s3:string model-s3:string exotic-s3:string
        )
    )
)

(module DPDC-CD GOV
    ;;
    (implements OuronetPolicy)
    (implements DemiourgosPactDigitalCollectibles-CreateDestroy)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-CD        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|DPDC-CD_ADMIN)))
    (defcap GOV|DPDC-CD_ADMIN ()    (enforce-guard GOV|MD_DPDC-CD))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV2} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|DPDC-CD|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC-CD|CALLER))
        (compose-capability (SECURE))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV2} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|DPDC-CD_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC-CD_ADMIN)
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
                (mg:guard (create-capability-guard (P|DPDC-CD|CALLER)))
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
    (defcap DPSF|S>CREATE (id:string royalty:decimal ignis:decimal)
        @event
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                (ref-DALOS:module{OuronetDalosV2} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (ignis-id:string (ref-DALOS::UR_IgnisID))
                (ignis-decimals:integer (ref-DALOS::UR_Decimals ignis-id))
            )
            (enforce
                (= (floor ignis ignis-decimals) ignis)
                (format "{} is not conform with the {} prec." [ignis ignis-id])
            )
            (ref-U|DALOS::UEV_Fee royalty)
        )
    )
    (defcap DPSF|S>CREDIT (id:string nonce:integer)
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (enforce (!= nonce 0) "Nonce 0 cant be used for operation")
            (ref-DPDC::UEV_NonceExists id true nonce)
        )
    )
    (defcap DPNF|S>CREDIT (id:string nonce:integer)
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (enforce (!= nonce 0) "Nonce 0 cant be used for operation")
            (ref-DPDC::UEV_NonceExists id false nonce)
        )
    )
    (defcap DPSF|S>DEBIT (id:string account:string nonce:integer amount:integer)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (existing-nonces:[integer] (ref-DPDC::UR_CA|OwnedNonces id true account))
                (existing-nonces-balances:[integer] (ref-DPDC::UR_CA|NoncesBalances id account))
                (nonce-position:integer (at 0 (ref-U|LST::UC_Search existing-nonces nonce)))
                (current-nonce-supply:integer (at nonce-position existing-nonces-balances))
            )
            (enforce (!= nonce 0) "Nonce 0 cant be used for operation")
            (ref-DPDC::UEV_NonceExists id true nonce)
            (enforce (<= amount current-nonce-supply) (format "Debiting SFT {} is not allowed with {} amount" [id amount]))
        )
    )
    (defcap DPNF|S>DEBIT (id:string account:string nonce:integer)
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (existing-nonces:[integer] (ref-DPDC::UR_CA|OwnedNonces id false account))
                (iz-nonce-present:bool (contains nonce existing-nonces))
            )
            (enforce (!= nonce 0) "Nonce 0 cant be used for operation")
            (ref-DPDC::UEV_NonceExists id false nonce)
            (enforce iz-nonce-present (format "NFT {} nonce {} is not Present on Account {}" [id nonce account]))
        )
    )
    ;;{C3}
    ;;{C4}
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
    ;;{F6}  [C]
    (defun C_Create:object{OuronetDalosV2.OutputCumulatorV2}
        (
            patron:string id:string amount:integer
            royalty:decimal ignis:decimal description:string meta-data:[object]
            image-t:bool audio-t:bool video-t:bool document-t:bool archive-t:bool model-t:bool exotic-t:bool
            image-s1:string audio-s1:string video-s1:string document-s1:string archive-s1:string model-s1:string exotic-s1:string
            image-s2:string audio-s2:string video-s2:string document-s2:string archive-s2:string model-s2:string exotic-s2:string
            image-s3:string audio-s3:string video-s3:string document-s3:string archive-s3:string model-s3:string exotic-s3:string
        )
        @doc "Creates a new SFT Collection element of amount <amount>, on the <creator> account"
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (creator:string (ref-DPDC::UR_CreatorKonto id))
                (new-nonce:integer (+ (ref-DPDC::UR_NoncesUsed id true) 1))
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|smallest"))
                (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
            )
            ;;Adds Entry in the Properties Table
            (with-capability (DPSF|S>CREATE id royalty ignis)
                (XI_CreateSemiFungibleNonce
                    id true amount
                    royalty ignis description meta-data
                    image-t audio-t video-t document-t archive-t model-t exotic-t
                    image-s1 audio-s1 video-s1 document-s1 archive-s1 model-s1 exotic-s1
                    image-s2 audio-s2 video-s2 document-s2 archive-s2 model-s2 exotic-s2
                    image-s3 audio-s3 video-s3 document-s3 archive-s3 model-s3 exotic-s3
                )
            )
            ;;Adds Entry in the Balance Table for the Creator
            (with-capability (DPSF|S>CREDIT id new-nonce)
                (XI_CreditSFT id creator new-nonce amount)
            )
            (ref-DALOS::UDC_ConstructOutputCumulatorV2 price (ref-DPDC::UR_OwnerKonto id true) trigger [])
        )
    )
    ;;{F7}  [X]
    (defun XI_CreateSemiFungibleNonce
        (
            id:string sft-or-nft:bool amount:integer
            royalty:decimal ignis:decimal description:string meta-data:[object]
            image-t:bool audio-t:bool video-t:bool document-t:bool archive-t:bool model-t:bool exotic-t:bool
            image-s1:string audio-s1:string video-s1:string document-s1:string archive-s1:string model-s1:string exotic-s1:string
            image-s2:string audio-s2:string video-s2:string document-s2:string archive-s2:string model-s2:string exotic-s2:string
            image-s3:string audio-s3:string video-s3:string document-s3:string archive-s3:string model-s3:string exotic-s3:string
        )
        (require-capability (DPSF|S>CREATE id royalty ignis))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (uri-type:object{DemiourgosPactDigitalCollectibles.DC|URI|Type}
                    (ref-DPDC::UDC_UriType image-t audio-t video-t document-t archive-t model-t exotic-t)
                )
                (uri-primary:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
                    (ref-DPDC::UDC_UriString image-s1 audio-s1 video-s1 document-s1 archive-s1 model-s1 exotic-s1)
                )
                (uri-secondary:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
                    (ref-DPDC::UDC_UriString image-s2 audio-s2 video-s2 document-s2 archive-s2 model-s2 exotic-s2)
                )
                (uri-tertiary:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
                    (ref-DPDC::UDC_UriString image-s3 audio-s3 video-s3 document-s3 archive-s3 model-s3 exotic-s3)
                )
                (collectible-data:object{DemiourgosPactDigitalCollectibles.DC|DataSchema}
                    (ref-DPDC::UDC_DataDC
                        royalty ignis description meta-data
                        uri-type uri-primary uri-secondary uri-tertiary
                    )
                )
                (new-nonce:integer (+ (ref-DPDC::UR_NoncesUsed id sft-or-nft) 1))
                (collectible:object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}
                    (ref-DPDC::UDC_NonceElement new-nonce amount collectible-data)
                )
                (current-existing-nonces:[object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}]
                    (if sft-or-nft
                        (ref-DPDC::UR_ElementsSFT id)
                        (ref-DPDC::UR_ElementsNFT id)
                    )
                )
                (new-nonces:[object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}]
                    (ref-U|LST::UC_AppL current-existing-nonces collectible)
                )
            )
            (ref-DPDC::XB_UP|Specs id sft-or-nft new-nonces)
        )
    )
    (defun XI_CreditSFT (id:string account:string nonce:integer amount:integer)
        @doc "Credits <amount> of SFT <id> and <nonce> to <account>, only Adding Entry in the Balance Table"
        (require-capability (DPSF|S>CREDIT id nonce))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (existing-nonces:[integer] (ref-DPDC::UR_CA|OwnedNonces id true account))
                (existing-nonces-balances:[integer] (ref-DPDC::UR_CA|NoncesBalances id account))
                (iz-nonce-present:bool (contains nonce existing-nonces))
                ;;
            )
            (ref-DPDC::XI_DeployAccountWNE id true account)
            (if iz-nonce-present
                (let
                    (
                        (nonce-position:integer (at 0 (ref-U|LST::UC_Search existing-nonces nonce)))
                        (current-nonce-supply:integer (at nonce-position existing-nonces-balances))
                        (updated-balance:integer (+ current-nonce-supply amount))
                        (updated-nonces-balances:[integer] (ref-U|LST::UC_ReplaceAt existing-nonces-balances nonce-position updated-balance))
                    )
                    (ref-DPDC::XB_UAD|NoncesBalances id account updated-nonces-balances)
                )
                (let
                    (
                        (updated-nonces:[integer] (ref-U|LST::UC_AppL existing-nonces nonce))
                        (updated-nonces-balances:[integer] (ref-U|LST::UC_AppL existing-nonces-balances amount))
                    )
                    (ref-DPDC::XB_UAD|OwnedNonces id true account updated-nonces)
                    (ref-DPDC::XB_UAD|NoncesBalances id account updated-nonces-balances)
                )
            )
        )
    )
    (defun XI_DebitSFT (id:string account:string nonce:integer amount:integer)
        @doc "Debits <amount> of SFT <id> and <nonce> from <account>"
        (require-capability (DPSF|S>DEBIT id account nonce amount))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
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
                    (ref-DPDC::XB_UAD|NoncesBalances id account updated-nonces-balances)
                )
                (let
                    (
                        (updated-nonces:[integer] (ref-U|LST::UC_RemoveItemAt existing-nonces nonce-position))
                        (updated-nonces-balances:[integer] (ref-U|LST::UC_RemoveItemAt existing-nonces-balances nonce-position))
                    )
                    (ref-DPDC::XB_UAD|OwnedNonces id true account updated-nonces)
                    (ref-DPDC::XB_UAD|NoncesBalances id account updated-nonces-balances)
                )
            )
        )
    )
    (defun XI_CreditNFT (id:string account:string nonce:integer)
        @doc "Credits NFT <id> and <nonce> to <account>"
        (require-capability (DPNF|S>CREDIT id nonce))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (existing-nonces:[integer] (ref-DPDC::UR_CA|OwnedNonces id false account))
                (updated-nonces:[integer] (ref-U|LST::UC_AppL existing-nonces nonce))
            )
            (ref-DPDC::XI_DeployAccountWNE id true account)
            (ref-DPDC::XB_UAD|OwnedNonces id false account updated-nonces)
        )
    )
    (defun XI_DebitNFT (id:string account:string nonce:integer)
        @doc "Debit NFT <id> and <nonce> from <account>"
        (require-capability (DPNF|S>DEBIT id nonce account))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (existing-nonces:[integer] (ref-DPDC::UR_CA|OwnedNonces id false account))
                ;;
                (nonce-position:integer (at 0 (ref-U|LST::UC_Search existing-nonces nonce)))
                (updated-nonces:[integer] (ref-U|LST::UC_RemoveItemAt existing-nonces nonce-position))
            )
            (ref-DPDC::XB_UAD|OwnedNonces id false account updated-nonces)
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)