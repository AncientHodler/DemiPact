(module DPDC-NP GOV
    ;;
    (implements OuronetPolicy)
    (implements DpdcNonceProperties)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-NP        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|DPDC-NP_ADMIN)))
    (defcap GOV|DPDC-NP_ADMIN ()    (enforce-guard GOV|MD_DPDC-NP))
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
    (defcap P|DPDC-NP|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC-NP|CALLER))
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
        (with-capability (GOV|DPDC-NP_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC-NP_ADMIN)
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
                (mg:guard (create-capability-guard (P|DPDC-NP|CALLER)))
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
    (defcap DPDC|S>NONCE-UPDATE (id:string sft-or-nft:bool account:string nonce:integer)
        (UEV_CanUpdateON id sft-or-nft account)
        (UEV_NonceManagement id sft-or-nft account nonce)
    )
    (defcap DPDC|S>NONCE-ROYALTY-UPDATE (id:string sft-or-nft:bool account:string nonce:integer)
        (UEV_CanUpdateRoyaltiesON id sft-or-nft account)
        (UEV_NonceManagement id sft-or-nft account nonce)
    )
    ;;{C3}
    ;;{C4}
    (defcap DPDC|C>SET-NONCE-SCORE (id:string sft-or-nft:bool account:string nonce:integer score:decimal)
        @event
        (UEV_Score score)
        (compose-capability (DPDC|S>NONCE-UPDATE id sft-or-nft account nonce))
    )
    (defcap DPDC|C>SET-NONCE-META-DATA (id:string sft-or-nft:bool account:string nonce:integer)
        @event
        (compose-capability (DPDC|S>NONCE-UPDATE id sft-or-nft account nonce))
    )
    (defcap DPDC|C>SET-NAME-OR-DESCRIPTION (id:string sft-or-nft:bool account:string nonce:integer)
        @event
        (compose-capability (DPDC|S>NONCE-UPDATE id sft-or-nft account nonce))
    )
    (defcap DPDC|C>SET-ROYALTY (id:string sft-or-nft:bool account:string nonce:integer royalty:decimal)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_Royalty royalty)
            (compose-capability (DPDC|S>NONCE-ROYALTY-UPDATE id sft-or-nft account nonce))
        )
    )
    (defcap DPDC|C>SET-IGNIS-ROYALTY (id:string sft-or-nft:bool account:string nonce:integer ignis-royalty:decimal)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_IgnisRoyalty ignis-royalty)
            (compose-capability (DPDC|S>NONCE-ROYALTY-UPDATE id sft-or-nft account nonce))
        )
    )
    (defcap DPDC|C>SET-NONCE-URI (id:string sft-or-nft:bool account:string nonce:integer)
        @event
        (UEV_CanUpdateUriON id sft-or-nft account)
        (UEV_NonceManagement id sft-or-nft account nonce)
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_NonceManagement (id:string sft-or-nft:bool account:string nonce:integer)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (ref-DPDC::UEV_Nonce id sft-or-nft nonce)
            (ref-DPDC::CAP_Owner id sft-or-nft)
        )
    )
    (defun UEV_CanUpdateON (id:string sft-or-nft:bool account:string)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (x:bool (ref-DPDC::UR_CA|R-Update id sft-or-nft account))
            )
            (enforce x (format "{} Collection {} Nonces cannot be Updated while using the {} Ouronet Account" [(if sft-or-nft "SFT" "NFT") id account]))
        )
    )
    (defun UEV_CanUpdateRoyaltiesON (id:string sft-or-nft:bool account:string)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (x:bool (ref-DPDC::UR_CA|R-ModifyRoyalties id sft-or-nft account))
            )
            (enforce x (format "{} Collection {} Nonces Royalties cannot be Updated while using the {} Ouronet Account" [(if sft-or-nft "SFT" "NFT") id account]))
        )
    )
    (defun UEV_CanUpdateUriON (id:string sft-or-nft:bool account:string)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (x:bool (ref-DPDC::UR_CA|R-SetUri id sft-or-nft account))
            )
            (enforce x (format "{} Collection {} Nonces Uris cannot be Updated while using the {} Ouronet Account" [(if sft-or-nft "SFT" "NFT") id account]))
        )
    )
    (defun UEV_Score (score:decimal)
        (enforce
            (= (floor score 24) score)
            (format "The score {} can have up to 24 decimals precision" [score])
        )
        (enforce 
            (and (>= score -1.0) (<= score 100000000000.0))
            "Score must be lower than 100 billion"
        )
    )
    ;;{F3}  [UDC]
    (defun URDC_NewNonceElement:object{Dpdc.DPDC|NonceElementSchema}
        (
            id:string sft-or-nft:bool nonce:integer
            input-nonce-data:object{Dpdc.DC|DataSchema}
        )
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (if (< nonce 0)
                (+
                    {"split-data" : input-nonce-data}
                    (remove "split-data" (ref-DPDC::UR_NonceElement id sft-or-nft nonce))
                )
                (+
                    {"nonce-data" : input-nonce-data}
                    (remove "nonce-data" (ref-DPDC::UR_NonceElement id sft-or-nft nonce))
                )
            )
        )
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_UpdateNonceRoyalty:object{IgnisCollector.OutputCumulator}
        (id:string sft-or-nft:bool account:string nonce:integer royalty:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC|C>SET-ROYALTY id sft-or-nft account nonce royalty)
                (XI_UpdateNonceRoyalty id sft-or-nft account nonce true royalty)
                (ref-IGNIS::IC|UDC_SmallestCumulator account)
            )
        )
    )
    (defun C_UpdateNonceIgnisRoyalty:object{IgnisCollector.OutputCumulator}
        (id:string sft-or-nft:bool account:string nonce:integer ignis-royalty:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC|C>SET-IGNIS-ROYALTY id sft-or-nft account nonce ignis-royalty)
                (XI_UpdateNonceRoyalty id sft-or-nft account nonce false ignis-royalty)
                (ref-IGNIS::IC|UDC_SmallestCumulator account)
            )
        )
    )
    (defun C_UpdateNonceNameOrDescription:object{IgnisCollector.OutputCumulator}
        (id:string sft-or-nft:bool account:string nonce:integer name-or-description:bool name-description:string)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC|C>SET-NAME-OR-DESCRIPTION id sft-or-nft account nonce)
                (XI_UpdateNonceNoD id sft-or-nft account nonce name-or-description name-description)
                (ref-IGNIS::IC|UDC_SmallestCumulator account)
            )
        )
    )
    (defun C_UpdateNonceScore:object{IgnisCollector.OutputCumulator}
        (id:string sft-or-nft:bool account:string nonce:integer score:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC|C>SET-NONCE-SCORE id sft-or-nft account nonce score)
                (XI_UpdateNonceScore id sft-or-nft account nonce score)
                (ref-IGNIS::IC|UDC_SmallestCumulator account)
            )
        )
    )
    (defun C_UpdateNonceMetadata:object{IgnisCollector.OutputCumulator}
        (id:string sft-or-nft:bool account:string nonce:integer meta-data:[object])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC|C>SET-NONCE-META-DATA id sft-or-nft account nonce)
                (XI_UpdateNonceMetaData id sft-or-nft account nonce meta-data)
                (ref-IGNIS::IC|UDC_SmallestCumulator account)
            )
        )
    )
    (defun C_UpdateNonceUri:object{IgnisCollector.OutputCumulator}
        (
            id:string sft-or-nft:bool account:string nonce:integer
            ay:object{Dpdc.DC|URI|Type}
            u1:object{Dpdc.DC|URI|Schema}
            u2:object{Dpdc.DC|URI|Schema}
            u3:object{Dpdc.DC|URI|Schema}
        )
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC|C>SET-NONCE-URI id sft-or-nft account nonce)
                (XI_UpdateNonceUri id sft-or-nft account nonce ay u1 u2 u3)
                (ref-IGNIS::IC|UDC_SmallestCumulator account)
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_UpdateNonceUri
        (
            id:string sft-or-nft:bool account:string nonce:integer
            ay:object{Dpdc.DC|URI|Type}
            u1:object{Dpdc.DC|URI|Schema}
            u2:object{Dpdc.DC|URI|Schema}
            u3:object{Dpdc.DC|URI|Schema}
        )
        (require-capability (DPDC|C>SET-NONCE-URI id sft-or-nft account nonce))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{Dpdc} DPDC)
                (np:integer (ref-DPDC::UR_GetNoncePosition id sft-or-nft nonce))
                ;;
                (nonce-data-new:object{Dpdc.DC|DataSchema}
                    (+
                        {"uri-tertiary" : u3}
                        (+
                            {"uri-secondary" : u2}
                            (+
                                {"uri-primary" : u1}
                                (+
                                    {"asset-type" : ay}
                                    (remove "asset-type" (ref-DPDC::UR_NonceData id sft-or-nft nonce))
                                )
                            )
                        )
                    ) 
                )
                (new-nonce-element:object{Dpdc.DPDC|NonceElementSchema}
                    (URDC_NewNonceElement id sft-or-nft nonce nonce-data-new)
                )
            )
            (ref-DPDC::XE_UP|SftOrNft id sft-or-nft
                (ref-U|LST::UC_ReplaceAt
                    (ref-DPDC::UR_ElementsSFT id)
                    np
                    new-nonce-element
                )
            )
        )
    )
    (defun XI_UpdateNonceRoyalty 
        (id:string sft-or-nft:bool account:string nonce:integer r-or-ir:bool royalty-value:decimal)
        (if r-or-ir
            (require-capability (DPDC|C>SET-ROYALTY id sft-or-nft account nonce royalty-value))
            (require-capability (DPDC|C>SET-IGNIS-ROYALTY id sft-or-nft account nonce royalty-value))
        )
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{Dpdc} DPDC)
                (np:integer (ref-DPDC::UR_GetNoncePosition id sft-or-nft nonce))
                ;;
                (nonce-data-new:object{Dpdc.DC|DataSchema}
                    (if r-or-ir
                        (+
                            {"royalty" : royalty-value}
                            (remove "royalty" (ref-DPDC::UR_NonceData id sft-or-nft nonce))
                        )
                        (+
                            {"ignis" : royalty-value}
                            (remove "ignis" (ref-DPDC::UR_NonceData id sft-or-nft nonce))
                        )
                    ) 
                )
                (new-nonce-element:object{Dpdc.DPDC|NonceElementSchema}
                    (URDC_NewNonceElement id sft-or-nft nonce nonce-data-new)
                )
            )
            (ref-DPDC::XE_UP|SftOrNft id sft-or-nft
                (ref-U|LST::UC_ReplaceAt
                    (ref-DPDC::UR_ElementsSFT id)
                    np
                    new-nonce-element
                )
            )
        )
    )
    (defun XI_UpdateNonceNoD (id:string sft-or-nft:bool account:string nonce:integer name-or-description:bool name-description:string)
        (require-capability (DPDC|C>SET-NAME-OR-DESCRIPTION id sft-or-nft account nonce))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{Dpdc} DPDC)
                (np:integer (ref-DPDC::UR_GetNoncePosition id sft-or-nft nonce))
                ;;
                (nonce-data-new:object{Dpdc.DC|DataSchema}
                    (if name-or-description
                        (+
                            {"name" : name-description}
                            (remove "name" (ref-DPDC::UR_NonceData id sft-or-nft nonce))
                        )
                        (+
                            {"description" : name-description}
                            (remove "description" (ref-DPDC::UR_NonceData id sft-or-nft nonce))
                        )
                    ) 
                )
                (new-nonce-element:object{Dpdc.DPDC|NonceElementSchema}
                    (URDC_NewNonceElement id sft-or-nft nonce nonce-data-new)
                )
            )
            (ref-DPDC::XE_UP|SftOrNft id sft-or-nft
                (ref-U|LST::UC_ReplaceAt
                    (ref-DPDC::UR_ElementsSFT id)
                    np
                    new-nonce-element
                )
            )
        )
    )
    (defun XI_UpdateNonceScore (id:string sft-or-nft:bool account:string nonce:integer score:decimal)
        (require-capability (DPDC|C>SET-NONCE-SCORE id sft-or-nft account nonce score))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{Dpdc} DPDC)
                (np:integer (ref-DPDC::UR_GetNoncePosition id sft-or-nft nonce))
                ;;
                (nonce-metadata-score:[object] [(ref-DPDC::UDC_Score score)])
                (nonce-metadata-custom:[object] (ref-DPDC::UR_NonceMetaDataCustom id sft-or-nft nonce))
                (nonce-metadata-new:[object] (+ nonce-metadata-score nonce-metadata-custom))
                (nonce-data-new:object{Dpdc.DC|DataSchema}
                    (+
                        {"meta-data" : nonce-metadata-new}
                        (remove "meta-data" (ref-DPDC::UR_NonceData id sft-or-nft nonce))
                    )
                )
                (new-nonce-element:object{Dpdc.DPDC|NonceElementSchema}
                    (URDC_NewNonceElement id sft-or-nft nonce nonce-data-new)
                )
            )
            (ref-DPDC::XE_UP|SftOrNft id sft-or-nft
                (ref-U|LST::UC_ReplaceAt
                    (ref-DPDC::UR_ElementsSFT id)
                    np
                    new-nonce-element
                )
            )
        )
    )
    (defun XI_UpdateNonceMetaData (id:string sft-or-nft:bool account:string nonce:integer meta-data:[object])
        (require-capability (DPDC|C>SET-NONCE-META-DATA id sft-or-nft account nonce))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{Dpdc} DPDC)
                (np:integer (ref-DPDC::UR_GetNoncePosition id sft-or-nft nonce))
                ;;
                (nonce-score:decimal (ref-DPDC::UR_NonceScore id sft-or-nft nonce))
                (nonce-metadata-score:[object] [(ref-DPDC::UDC_Score nonce-score)])
                (nonce-metadata-new:[object] (+ nonce-metadata-score meta-data))
                (nonce-data-new:object{Dpdc.DC|DataSchema}
                    (+
                        {"meta-data" : nonce-metadata-new}
                        (remove "meta-data" (ref-DPDC::UR_NonceData id sft-or-nft nonce))
                    )
                )
                (new-nonce-element:object{Dpdc.DPDC|NonceElementSchema}
                    (URDC_NewNonceElement id sft-or-nft nonce nonce-data-new)
                )
            )
            (ref-DPDC::XE_UP|SftOrNft id sft-or-nft
                (ref-U|LST::UC_ReplaceAt
                    (ref-DPDC::UR_ElementsSFT id)
                    np
                    new-nonce-element
                )
            )
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)