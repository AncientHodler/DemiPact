(interface AcquisitionAnchors
    (defun GOV|AQP|SC_NAME ())
    ;;
    (defun C_Issue:object{IgnisCollectorV2.OutputCumulator} (patron:string ank-name:string ank-asset:string ank-fungibility:[bool] prec:integer))
    (defun C_DefineTrueFungibleAnchor:object{IgnisCollectorV2.OutputCumulator} (anchor-id:string dptf-id:string dptf-amount:decimal promile:decimal))
    (defun C_DefineSemiFungibleAnchor:object{IgnisCollectorV2.OutputCumulator} (anchor-id:string dpsf-id:string nonce:integer promile:decimal))
    (defun C_DefineNonFungibleAnchor:object{IgnisCollectorV2.OutputCumulator} (anchor-id:string dpnf-id:string trait-key:string trait-value:string promile:decimal))
)
(module AQP-ANK GOV
    ;;
    (implements OuronetPolicy)
    (implements AcquisitionAnchors)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_AQP-ANK                (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    (defconst AQP|SC_KEY                    (GOV|AqpKey))
    (defconst AQP|SC_NAME                   (GOV|AQP|SC_NAME))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|ANK_ADMIN)))
    (defcap GOV|ANK_ADMIN ()                (enforce-guard GOV|MD_AQP-ANK))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;; [Keys]
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|AqpKey ()                    (+ (GOV|NS_Use) ".dh_sc_aqp-keyset"))
    ;;
    ;; [SC-Names]
    (defun GOV|AQP|SC_NAME ()               (at 0 ["Σ.ЖřÎzэóΣQз3ÌĄăådìÜλÅË9γğ7χûПæ0₳ПûÖŞrĄθXtFìмkщsGвÅgλąÇπЩAĚЭDíéαэБùđáżñИïПÆΣтцξsηåäялÃБц¢r6ÁíäзуμþĄĐЫîÉAćýìЧыQPнŁзßξĂйjay£üѺçRЫfУQșÏΠÜqîÔĄťß6ЗSρŠeΦñëdmûΦøШâΞýκъиřк"]))
    ;;
    ;; [PBLs]
    (defun GOV|AQP|PBL ()                   (at 0 ["9G.632vHq208xaznBw9AfwrFGmLBqkr7tqEzf2Msq389xqEknmfAk8qI5MM1MaszdgMtEBpo6rbuC09Do7F6pjc91jzy3JxI6fjCkyuIbDpDD5i8CxeCBL0dKdDu3d2uAAwl6wE6npnm4Mjxx6JhiFq1sKddsGjLH9BjHF0ljtegHrn39qIADru76Ftr9Kgxh6Ds2aj4EufG07uK9sFG38ej5vooDMr0wp8alqGdnIiJxbhmwEKEg44l8pI5LDq2EotoM2jq86x1EJ5hM4wkfhtq4ye610tkAMIdLrDD87Euk14aJgMwnrLmytzcCc3Kakrnhs8Jxy5dFeowGxzlx1bGHqfwEen0pLcd6nl9udGE9hfFucLjM1seKzv542nwzz5jrpKmvzebI4BLK00Br1ocvxs4uor2nEv2Fng1l6qAiLcbv0hMnbLDEEcLpF1bD55gw55of7H2c3ieozahorkuCe5FEkAkEAhcGwJ35HCletrbcn2Ebo0fsD0tf2zxKsbzinpcJCtpv4EF4AyyhwD1LbtEd6qsEbgyJkA2DqdGBE5Fuqudzf8082Ei88d"]))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|ANK|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|ANK|CALLER))
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
        (with-capability (GOV|ANK_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|ANK_ADMIN)
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
                (mg:guard (create-capability-guard (P|ANK|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
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
    ;;1]General Anchor Definition
    (defschema ANK|Schema
        ank-asset:string                                        ;;ID of the the Anchored Asset
        ank-fungibility:[bool]                                  ;;Stores the fungibility of the Asset the Anchor is based on.
        precision:integer                                       ;;Precision of the Anchor Variable
        ;;
        ;;Select Keys
        anchor-id:string
    )
    ;;2]Anchor Definitions; Only True, Semi and Non Fungibles can be used as AnchorDefinitions
    (defschema ANK|TF|Schema
        unit-amount:decimal
        promile:decimal                                         ;;Promile per Amount of DPTF
        ;;
        ;;Select Keys
        anchor-id:string
        dptf-id:string
    )
    (defschema ANK|SF|Schema
        nonce:integer
        nonce-promile:decimal                                   ;;Promile of Nonce
        ;;
        ;;Select Keys
        anchor-id:string
        dpsf-id:string
    )
    (defschema ANK|NF|Schema
        trait-key:string
        trait-value:string
        trait-promile:decimal                                   ;;Promile of Trait
        ;;
        ;;Select Keys
        anchor-id:string
        dpnf-id:string
    )
    ;;3]Asset Anchors
    (defschema ANK|AssetAnchors
        anchor-primary:string
        anchor-secondary:string
        anchor-tertiary:string
        anchor-quaternary:string
        anchor-quinary:string
        anchor-senary:string
        anchor-septenary:string
        ;;
        anchors:integer
        ;;
        ;;Select Keys
        asset-id:string
    )
    ;;4]Usert Anchor Values
    (defschema ANK|UserSchema
        promile:decimal                                         ;;Promile of User with Anchor
        ;;
        ;;Select Keys
        ouronet-account:string
        anchor-id:string
    )
    ;;
    ;;{2}
    (deftable ANK|T|Anchor:{ANK|Schema})                        ;;Key = <Anchor-ID>
    (deftable ANK|T|TF|Anchor:{ANK|TF|Schema})                  ;;Key = <Anchor-ID> | <DPTF-ID>
    (deftable ANK|T|SF|Anchor:{ANK|SF|Schema})                  ;;Key = <Anchor-ID> | <DPSF-ID>
    (deftable ANK|T|NF|Anchor:{ANK|NF|Schema})                  ;;Key = <Anchor-ID> | <DPNF-ID>
    ;;
    (deftable ANK|T|TF|Anchors:{ANK|AssetAnchors})              ;;Key = <DPTF-ID>
    (deftable ANK|T|SF|Anchors:{ANK|AssetAnchors})              ;;Key = <DPSF-ID>
    (deftable ANK|T|NF|Anchors:{ANK|AssetAnchors})              ;;Key = <DPNF-ID>
    ;;
    (deftable ANK|T|Anchors:{ANK|UserSchema})                   ;;Key = <Ouronet-Account> | <Anchor-ID>
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    (defconst E-ANK
        {"promile"                  : 0.0
        ,"ouronet-account"          : BAR
        ,"anchor-id"                : BAR}
    )
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
    (defcap ANK|C>ISSUE (ank-name:string ank-asset:string ank-fungibility:[bool] prec:integer)
        @event
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (ref-U|ATS:module{UtilityAtsV2} U|ATS)
            )
            (ref-U|DALOS::UEV_Decimals prec)
            (ref-U|ATS::UEV_AutostakeIndex ank-name)
            (UEV_NewAssetAnchor ank-asset ank-fungibility)
            (compose-capability (SECURE))
        )
    )
    (defcap ANK|C>DEFINE-TF (anchor-id:string dptf-id:string dptf-amount:decimal promile:decimal)
        @event
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
            )
            (ref-DPTF::UEV_Amount dptf-id dptf-amount)
            (compose-capability (ANK|CX>DEFINE anchor-id promile))
        )
    )
    (defcap ANK|C>DEFINE-SF (anchor-id:string dpsf-id:string nonce:integer promile:decimal)
        @doc "Only Positive nonces can be used for Anchors; (No Fragments)"
        @event
        (let
            (
                (ref-DPDC:module{DpdcV4} DPDC)
            )
            (ref-DPDC::UEV_Nonce dpsf-id true nonce)
            (enforce (> nonce 0) "Invalid Nonce for Anchoring")
            (compose-capability (ANK|CX>DEFINE anchor-id promile))
        )
    )
    (defcap ANK|C>DEFINE-NF (anchor-id:string dpnf-id:string trait-key:string trait-value:string promile:decimal)
        @doc "Only Native Nonces can be used for Anchors; (No Fragments, no Sets)"
        @event
        (let
            (
                (ref-DPDC:module{DpdcV4} DPDC)
                
            )
            (ref-DPDC::UEV_id dpnf-id false)
            (compose-capability (ANK|CX>DEFINE anchor-id promile))
        )
    )
    (defcap ANK|CX>DEFINE (anchor-id:string promile:decimal)
        (UEV_Promile promile)
        (CAP_Owner anchor-id)
        (compose-capability (SECURE))
    )
    ;;
    (defcap ANK|C>UPDATE-TF (account:string anchor-id:string dptf-id:string dptf-amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ank-f:[bool] (UR_AnchorFungibility anchor-id))
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (ref-DPTF::UEV_Amount dptf-id dptf-amount)
            (enforce (= ank-f [true true]) "Invalid TrueFungible Anchor Fungibility !")
        )
    )
    (defcap ANK|C>UPDATE-SF (account:string anchor-id:string dpsf-id:string nonces:[integer])
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPDC:module{DpdcV4} DPDC)
                (ank-f:[bool] (UR_AnchorFungibility anchor-id))
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (ref-DPDC::UEV_NonceMapper dpsf-id true nonces)
            (enforce (= ank-f [false true]) "Invalid SemiFungible Anchor Fungibility !")
        )
    )
    (defcap ANK|C>UPDATE-NF (account:string anchor-id:string dpnf-id:string nonces:[integer])
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPDC:module{DpdcV4} DPDC)
                (ank-f:[bool] (UR_AnchorFungibility anchor-id))
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (ref-DPDC::UEV_NonceMapper dpnf-id false nonces)
            (enforce (= ank-f [false false]) "Invalid NonFungible Anchor Fungibility !")
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_Asset|AnchorKey:string (anchor-id:string asset-id:string)
        (concat [anchor-id BAR asset-id])
    )
    (defun UC_UserAnchor:string (account:string anchor-id:string)
        (concat [account BAR anchor-id])
    )
    ;;{F0}  [UR]
    ;;[1] - <ANK|T|Anchor>
    (defun UR_Anchor:object{ANK|Schema} (anchor-id:string)
        (read ANK|T|Anchor anchor-id)
    )
    (defun UR_AnchoredAsset:string (anchor-id:string)
        (at "ank-asset" (UR_Anchor anchor-id))
    )
    (defun UR_AnchorFungibility:[bool] (anchor-id:string)
        (at "ank-fungibility" (UR_Anchor anchor-id))
    )
    (defun UR_AnchorPrecision:decimal (anchor-id:string)
        (at "precision" (UR_Anchor anchor-id))
    )
    (defun UR_AnchorID:string (anchor-id:string)
        (at "anchor-id" (UR_Anchor anchor-id))
    )
    ;;2a] - <ANK|T|TF|Anchor>
    (defun UR_TF|Anchor:object{ANK|TF|Schema} (anchor-id:string dptf-id:string)
        (read ANK|T|TF|Anchor (UC_Asset|AnchorKey anchor-id dptf-id))
    )
    (defun UR_TF|Amount:decimal (anchor-id:string dptf-id:string)
        (at "unit-amount" (UR_TF|Anchor anchor-id dptf-id))
    )
    (defun UR_TF|Promile:decimal (anchor-id:string dptf-id:string)
        (at "promile" (UR_TF|Anchor anchor-id dptf-id))
    )
    (defun UR_TF|AnchorID:string (anchor-id:string dptf-id:string)
        (at "anchor-id" (UR_TF|Anchor anchor-id dptf-id))
    )
    (defun UR_TF|DptfID:string (anchor-id:string dptf-id:string)
        (at "dptf-id" (UR_TF|Anchor anchor-id dptf-id))
    )
    ;;2b] - <ANK|T|SF|Anchor>
    (defun UR_SF|Anchor:object{ANK|SF|Schema} (anchor-id:string dpsf-id:string)
        (read ANK|T|SF|Anchor (UC_Asset|AnchorKey anchor-id dpsf-id))
    )
    (defun UR_SF|Promile:decimal (anchor-id:string dpsf-id:string)
        (at "nonce-promile" (UR_SF|Anchor anchor-id dpsf-id))
    )
    (defun UR_SF|AnchorID:string (anchor-id:string dpsf-id:string)
        (at "anchor-id" (UR_SF|Anchor anchor-id dpsf-id))
    )
    (defun UR_SF|DpsfId:string (anchor-id:string dpsf-id:string)
        (at "dpsf-id" (UR_SF|Anchor anchor-id dpsf-id))
    )
    (defun UR_SF|Nonce:integer (anchor-id:string dpsf-id:string)
        (at "nonce" (UR_SF|Anchor anchor-id dpsf-id))
    )
    ;;2c] - <ANK|T|NF|Anchor>
    (defun UR_NF|Anchor:object{ANK|NF|Schema} (anchor-id:string dpnf-id:string)
        (read ANK|T|NF|Anchor (UC_Asset|AnchorKey anchor-id dpnf-id))
    )
    (defun UR_NF|Promile:decimal (anchor-id:string dpnf-id:string)
        (at "trait-promile" (UR_NF|Anchor anchor-id dpnf-id))
    )
    (defun UR_NF|AnchorID:string (anchor-id:string dpnf-id:string)
        (at "anchor-id" (UR_NF|Anchor anchor-id dpnf-id))
    )
    (defun UR_NF|DpnfID:string (anchor-id:string dpnf-id:string)
        (at "dpnf-id" (UR_NF|Anchor anchor-id dpnf-id))
    )
    (defun UR_NF|TraitKey:string (anchor-id:string dpnf-id:string)
        (at "trait-key" (UR_NF|Anchor anchor-id dpnf-id))
    )
    (defun UR_NF|TraitValue:string (anchor-id:string dpnf-id:string)
        (at "trait-value" (UR_NF|Anchor anchor-id dpnf-id))
    )
    ;;3] - <ANK|T|TF|Anchors>|<ANK|T|SF|Anchors>|<ANK|T|NF|Anchors>
    (defun UR_AssetAnchorData:object{ANK|AssetAnchors} (ank-asset:string ank-fungibility:[bool])
        (UEV_AnkFungibility ank-fungibility)
        (if (= ank-fungibility [true true])
            (UR_TF|Anchors ank-asset)
            (if (= ank-fungibility [false true])
                (UR_SF|Anchors ank-asset)
                (UR_NF|Anchors ank-asset)
            )
        )
    )
    (defun UR_TF|Anchors:object{ANK|AssetAnchors} (dptf-id:string)
        (with-default-read ANK|T|TF|Anchors dptf-id
            (UDC_AssetAnchors BAR BAR BAR BAR BAR BAR BAR 0 dptf-id)
            {"anchor-primary"       := a1
            ,"anchor-secondary"     := a2
            ,"anchor-tertiary"      := a3
            ,"anchor-quaternary"    := a4
            ,"anchor-quinary"       := a5
            ,"anchor-senary"        := a6
            ,"anchor-septenary"     := a7
            ,"anchors"              := a
            ,"asset-id"             := id}
            (UDC_AssetAnchors a1 a2 a3 a4 a5 a6 a7 a id)
        )
    )
    (defun UR_SF|Anchors:object{ANK|AssetAnchors} (dpsf-id:string)
        (with-default-read ANK|T|SF|Anchors dpsf-id
            (UDC_AssetAnchors BAR BAR BAR BAR BAR BAR BAR 0 dpsf-id)
            {"anchor-primary"       := a1
            ,"anchor-secondary"     := a2
            ,"anchor-tertiary"      := a3
            ,"anchor-quaternary"    := a4
            ,"anchor-quinary"       := a5
            ,"anchor-senary"        := a6
            ,"anchor-septenary"     := a7
            ,"anchors"              := a
            ,"asset-id"             := id}
            (UDC_AssetAnchors a1 a2 a3 a4 a5 a6 a7 a id)
        )
    )
    (defun UR_NF|Anchors:object{ANK|AssetAnchors} (dpnf-id:string)
        (with-default-read ANK|T|NF|Anchors dpnf-id
            (UDC_AssetAnchors BAR BAR BAR BAR BAR BAR BAR 0 dpnf-id)
            {"anchor-primary"       := a1
            ,"anchor-secondary"     := a2
            ,"anchor-tertiary"      := a3
            ,"anchor-quaternary"    := a4
            ,"anchor-quinary"       := a5
            ,"anchor-senary"        := a6
            ,"anchor-septenary"     := a7
            ,"anchors"              := a
            ,"asset-id"             := id}
            (UDC_AssetAnchors a1 a2 a3 a4 a5 a6 a7 a id)
        )
    )
    (defun UR_ANK|First:string (input:object{ANK|AssetAnchors})
        (at "anchor-primary" input)
    )
    (defun UR_ANK|Second:string (input:object{ANK|AssetAnchors})
        (at "anchor-secondary" input)
    )
    (defun UR_ANK|Third:string (input:object{ANK|AssetAnchors})
        (at "anchor-tertiary" input)
    )
    (defun UR_ANK|Fourth:string (input:object{ANK|AssetAnchors})
        (at "anchor-quaternary" input)
    )
    (defun UR_ANK|Fifth:string (input:object{ANK|AssetAnchors})
        (at "anchor-quinary" input)
    )
    (defun UR_ANK|Sixth:string (input:object{ANK|AssetAnchors})
        (at "anchor-senary" input)
    )
    (defun UR_ANK|Seventh:string (input:object{ANK|AssetAnchors})
        (at "anchor-septenary" input)
    )
    (defun UR_ANK|Quantity:integer (input:object{ANK|AssetAnchors})
        (at "anchors" input)
    )
    (defun UR_AssetAnchorsAssetID:string (input:object{ANK|AssetAnchors})
        (at "asset-id" input)
    )
    ;;4] - <ANK|T|Anchors>
    (defun UR_UserAnchor:object{ANK|UserSchema} (account:string anchor-id:string)
        (with-default-read ANK|T|Anchors (UC_UserAnchor account anchor-id)
            (UDC_AccountAnchor 0.0 BAR BAR)
            {"promile"                  := p
            ,"ouronet-account"          := oa
            ,"anchor-id"                := aid}
            (UDC_AccountAnchor p oa aid)
        )
    )
    (defun UR_UserAnchorPromile:decimal (account:string anchor-id:string)
        (at "promile" (UR_UserAnchor account anchor-id))
    )
    (defun UR_UserAnchorAccount:string (account:string anchor-id:string)
        (at "ouronet-account" (UR_UserAnchor account anchor-id))
    )
    (defun UR_UserAnchorID:string (account:string anchor-id:string)
        (at "anchor-id" (UR_UserAnchor account anchor-id))
    )
    ;;
    ;;{F1}  [URC]
    (defun URC_AnkAssetOwner:string (ank-asset:string ank-fungibility:[bool])
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-DPDC:module{DpdcV4} DPDC)
            )
            (UEV_AnkFungibility ank-fungibility)
            (cond
                ((= ank-fungibility [true true]) (ref-DPTF::UR_Konto ank-asset))
                ((= ank-fungibility [false true]) (ref-DPDC::UR_OwnerKonto ank-asset true))
                ((= ank-fungibility [false false]) (ref-DPDC::UR_OwnerKonto ank-asset false))
                BAR
            )
        )
    )
    (defun URC_AssetAnchorTable (ank-fungibility:[bool] validation:bool)
        (if validation
            (UEV_AnkFungibility ank-fungibility)
            true
        )
        (if (= ank-fungibility [true true])
            ANK|T|TF|Anchors
            (if (= ank-fungibility [false true])
                ANK|T|SF|Anchors
                ANK|T|NF|Anchors
            )
        )
    )
    (defun URC_ConformNonces:integer (dpnf-id:string nonces:[integer] trait-key:string trait-value:string)
        @doc "Outputs how many nonces from <nonces> have the proper MetaData Trait"
        (let
            (
                (ref-DPDC:module{DpdcV4} DPDC)
            )
            (fold
                (lambda
                    (acc:integer idx:integer)
                    (let
                        (
                            (nonce:integer (at idx nonces))
                            (nonce-meta-data:object (ref-DPDC::UR_N|RawMetaData (ref-DPDC::UR_N|MetaData (ref-DPDC::UR_NativeNonceData dpnf-id false nonce))))
                            (has-trait-key:bool (contains trait-key nonce-meta-data))
                            (output:decimal
                                (if (or (< nonce 0) (not has-trait-key))
                                    0
                                    (if (= trait-value (at trait-key nonce-meta-data))
                                        1
                                        0
                                    )
                                )
                            )
                        )
                        (+ acc output)
                    )
                )
                0
                (enumerate 0 (- (length nonces) 1))
            )
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_AnkFungibility (ank-fungibility:[bool])
        (let
            (
                (l:integer (length ank-fungibility))
            )
            (enforce (and (= l 2) (!= ank-fungibility [true false])) "Invalid Fungibility")
        )
    )
    (defun UEV_AnkAssetOwnership (ank-asset:string ank-fungibility:[bool])
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (URC_AnkAssetOwner ank-asset ank-fungibility))
        )
    )
    (defun UEV_Promile (promile:decimal)
        (enforce
            (fold (and) true 
                [
                    (> promile 0.0)                     ;;must be bigger than 0.0
                    (< promile 100000000000.0)          ;;maximum 100 billion promile
                    (= (floor promile 4) promile)       ;;max 4 decimal precision
                ]
            )
            "Invalid Promile Value"
        )
    )
    (defun UEV_UpdateTrueFungibleAnchor:decimal 
        (account:string anchor-id:string dptf-id:string dptf-amount:decimal direction:bool)
        (let
            (
                (current-promile:decimal (UR_UserAnchorPromile account anchor-id))
                (tf-ank-amount:decimal (UR_TF|Amount anchor-id dptf-id))
                (tf-ank-promile:decimal (UR_TF|Promile anchor-id dptf-id))
                (computed-promile-to-consider:decimal (floor (* tf-ank-promile (/ dptf-amount tf-ank-amount)) 4))
                (new-computed-promile:decimal
                    (if direction
                        (+ current-promile computed-promile-to-consider)
                        (- current-promile computed-promile-to-consider)
                    )
                )
            )
            (enforce (> new-computed-promile 0.0) "Newly computed promile cannot be less than 0.0")
            new-computed-promile
        )
    )
    (defun UEV_UpdateSemiFungibleAnchor:decimal
        (account:string anchor-id:string dpsf-id:string nonces:[integer] nonce-amounts:[integer] direction:bool)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (current-promile:decimal (UR_UserAnchorPromile account anchor-id))
                (sf-ank-promile:decimal (UR_SF|Promile anchor-id dpsf-id))
                (anchor-nonce:integer (UR_SF|Nonce anchor-id dpsf-id))
                (anchor-nonce-position:[integer] (ref-U|LST::UC_Search nonces anchor-nonce))
                (l:integer (length anchor-nonce-position))
                (valid-nonces:integer
                    (if (= l 0)
                        0
                        (at (at 0 anchor-nonce-position) nonce-amounts)
                    )
                )
                (computed-promile-to-consider:decimal (* (dec valid-nonces) sf-ank-promile))
                (new-computed-promile:decimal
                    (if direction
                        (+ current-promile computed-promile-to-consider)
                        (- current-promile computed-promile-to-consider)
                    )
                )
            )
            (enforce (> new-computed-promile 0.0) "Newly computed promile cannot be less than 0.0")
            new-computed-promile
        )
    )
    (defun UEV_UpdateNonFungibleAnchor:decimal
        (account:string anchor-id:string dpnf-id:string nonces:[integer] direction:bool)
        (let
            (
                (anchor-trait-key:string (UR_NF|TraitKey anchor-id dpnf-id))
                (anchor-trait-value:string (UR_NF|TraitValue anchor-id dpnf-id))
                (current-promile:decimal (UR_UserAnchorPromile account anchor-id))
                (nf-ank-promile:decimal (UR_NF|Promile anchor-id dpnf-id))
                (conform-nonces:integer (URC_ConformNonces dpnf-id nonces anchor-trait-key anchor-trait-value))
                (computed-promile-to-consider:decimal (* (dec conform-nonces) nf-ank-promile))
                (new-computed-promile:decimal
                    (if direction
                        (+ current-promile computed-promile-to-consider)
                        (- current-promile computed-promile-to-consider)
                    )
                )
            )
            (enforce (> new-computed-promile 0.0) "Newly computed promile cannot be less than 0.0")
            new-computed-promile
        )
    )
    (defun UEV_NewAssetAnchor (ank-asset:string ank-fungibility:[bool])
        (let
            (
                (quantity:integer (UR_ANK|Quantity (UR_AssetAnchorData ank-asset ank-fungibility)))
            )
            (enforce (<= quantity 6) (format "Cannot add new Anchor for Asset {} with Fungibility {}" [ank-asset ank-fungibility]))
        )
    )
    ;;{F3}  [UDC]
    (defun UDC_AssetAnchors:object{ANK|AssetAnchors}
        (a:string b:string c:string d:string e:string f:string g:string h:integer i:string)
        {"anchor-primary"       : a
        ,"anchor-secondary"     : b
        ,"anchor-tertiary"      : c
        ,"anchor-quaternary"    : d
        ,"anchor-quinary"       : e
        ,"anchor-senary"        : f
        ,"anchor-septenary"     : g
        ,"anchors"              : h
        ,"asset-id"             : i}
    )
    (defun UDC_AccountAnchor:object{ANK|UserSchema}
        (a:decimal b:string c:string)
        {"promile"              : a
        ,"ouronet-account"      : b
        ,"anchor-id"            : c}
    )
    ;;{F4}  [CAP]
    (defun CAP_Owner (anchor-id:string)
        (UEV_AnkAssetOwnership (UR_AnchoredAsset anchor-id) (UR_AnchorFungibility anchor-id))
    )
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_Issue:object{IgnisCollectorV2.OutputCumulator} 
        (patron:string ank-name:string ank-asset:string ank-fungibility:[bool] prec:integer)
        @doc "Issues an Anchor; 250 IGNIS and 10 KDA Costs"
        (UEV_IMC)
        (with-capability (ANK|C>ISSUE ank-name ank-asset ank-fungibility prec)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV6} DALOS)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (gas-costs:decimal 250.0)
                    (trigger:bool (ref-IGNIS::URC_IsVirtualGasZero))
                    (standard:decimal (ref-DALOS::UR_UsagePrice "standard"))
                    ;;
                    (asset-aqt:integer (UR_ANK|Quantity (UR_AssetAnchorData ank-asset ank-fungibility)))
                    (anchor-id:string (XI_Issue ank-name ank-asset ank-fungibility prec))
                )
                (if (!= asset-aqt 0)
                    (XI_UpdateAssetAnchors anchor-id ank-asset ank-fungibility)
                    true
                )
                (ref-IGNIS::KDA|C_Collect patron standard)
                (ref-IGNIS::UDC_ConstructOutputCumulator gas-costs AQP|SC_NAME trigger [anchor-id])
            )
        )
    )
    (defun C_DefineTrueFungibleAnchor:object{IgnisCollectorV2.OutputCumulator} 
        (anchor-id:string dptf-id:string dptf-amount:decimal promile:decimal)
        @doc "Defines a TrueFungible based Anchor - 5 IGNIS"
        (UEV_IMC)
        (with-capability (ANK|C>DEFINE-TF anchor-id dptf-id dptf-amount promile)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                )
                (XI_DefineTrueFungibleAnchor anchor-id dptf-id dptf-amount promile)
                (ref-IGNIS::UDC_BiggestCumulator AQP|SC_NAME)
            )
        )
    )
    (defun C_DefineSemiFungibleAnchor:object{IgnisCollectorV2.OutputCumulator} 
        (anchor-id:string dpsf-id:string nonce:integer promile:decimal)
        @doc "Defines a SemiFungible based Anchor - 5 IGNIS"
        (UEV_IMC)
        (with-capability (ANK|C>DEFINE-SF anchor-id dpsf-id nonce promile)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                )
                (XI_DefineSemiFungibleAnchor anchor-id dpsf-id nonce promile)
                (ref-IGNIS::UDC_BiggestCumulator AQP|SC_NAME)
            )
        )
    )
    (defun C_DefineNonFungibleAnchor:object{IgnisCollectorV2.OutputCumulator} 
        (anchor-id:string dpnf-id:string trait-key:string trait-value:string promile:decimal)
        @doc "Defines a NonFungible based Anchor - 5 IGNIS"
        (UEV_IMC)
        (with-capability (ANK|C>DEFINE-NF anchor-id dpnf-id trait-key trait-value promile)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                )
                (XI_DefineNonFungibleAnchor anchor-id dpnf-id trait-key trait-value promile)
                (ref-IGNIS::UDC_BiggestCumulator AQP|SC_NAME)
            )
        )
    )
    ;;
    ;;
    ;;{F7}  [X]
    (defun XI_Issue:string (ank-name:string ank-asset:string ank-fungibility:[bool] prec:integer)
        (require-capability (SECURE))
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                ;;
                (anchor-id:string (ref-U|DALOS::UDC_Makeid ank-name))
                (asset-aqt:integer (UR_ANK|Quantity (UR_AssetAnchorData ank-asset ank-fungibility)))
            )
            (insert ANK|T|Anchor anchor-id
                {"ank-asset"        : ank-asset
                ,"ank-fungibility"  : ank-fungibility
                ,"precision"        : prec
                ,"anchor-id"        : anchor-id
                }
            )
            (if (= asset-aqt 0)
                (let
                    (
                        (asset-anchors:object{ANK|AssetAnchors} (UDC_AssetAnchors anchor-id BAR BAR BAR BAR BAR BAR 1 ank-asset))
                    )
                    (if (= ank-fungibility [true true])
                        (insert ANK|T|TF|Anchors ank-asset asset-anchors)
                        (if (= ank-fungibility [false true])
                            (insert ANK|T|SF|Anchors ank-asset asset-anchors)
                            (insert ANK|T|NF|Anchors ank-asset asset-anchors)
                        )
                    )
                )
                true
            )
            anchor-id
        )
    )
    (defun XI_UpdateAssetAnchors (anchor-id:string ank-asset:string ank-fungibility:[bool])
        (require-capability (SECURE))
        (let
            (
                (asset-aqt:integer (UR_ANK|Quantity (UR_AssetAnchorData ank-asset ank-fungibility)))
                (table-ref (URC_AssetAnchorTable ank-fungibility false))
            )
            (if (!= asset-aqt 0)
                (cond
                    ((= asset-aqt 1) (update table-ref ank-asset {"anchor-secondary"     : anchor-id, "anchors" : 2}))
                    ((= asset-aqt 2) (update table-ref ank-asset {"anchor-tertiary"      : anchor-id, "anchors" : 3}))
                    ((= asset-aqt 3) (update table-ref ank-asset {"anchor-quaternary"    : anchor-id, "anchors" : 4}))
                    ((= asset-aqt 4) (update table-ref ank-asset {"anchor-quinary"       : anchor-id, "anchors" : 5}))
                    ((= asset-aqt 5) (update table-ref ank-asset {"anchor-senary"        : anchor-id, "anchors" : 6}))
                    ((= asset-aqt 6) (update table-ref ank-asset {"anchor-septenary"     : anchor-id, "anchors" : 7}))
                    true
                )
                true
            )
        )
    )
    (defun XI_DefineTrueFungibleAnchor (anchor-id:string dptf-id:string dptf-amount:decimal promile:decimal)
        (require-capability (SECURE))
        (insert ANK|T|TF|Anchor (UC_Asset|AnchorKey anchor-id dptf-id)
            {"unit-amount"          : dptf-amount
            ,"promile"              : promile
            ,"anchor-id"            : anchor-id
            ,"dptf-id"              : dptf-id}
        )
    )
    (defun XI_DefineSemiFungibleAnchor (anchor-id:string dpsf-id:string nonce:integer promile:decimal)
        (require-capability (SECURE))
        (insert ANK|T|SF|Anchor (UC_Asset|AnchorKey anchor-id dpsf-id)
            {"nonce-promile"        : promile
            ,"anchor-id"            : anchor-id
            ,"dpsf-id"              : dpsf-id
            ,"nonce"                : nonce
            }
        )
    )
    (defun XI_DefineNonFungibleAnchor (anchor-id:string dpnf-id:string trait-key:string trait-value:string promile:decimal)
        (require-capability (SECURE))
        (insert ANK|T|NF|Anchor (UC_Asset|AnchorKey anchor-id dpnf-id)
            {"trait-promile"        : promile
            ,"anchor-id"            : anchor-id
            ,"dpnf-id"              : dpnf-id
            ,"trait-key"            : trait-key
            ,"trait-value"          : trait-value
            }
        )
    )
    ;;
    (defun XE_UpdateTrueFungibleAnchor (account:string anchor-id:string dptf-id:string dptf-amount:decimal direction:bool)
        @doc "Updates the Anchor for a given <account> pertaining to a given <dptf-id> and <dptf-amount> \
            \ <direction> true = adds amount; <direction> false = removes amount"
        (UEV_IMC)
        (with-capability (ANK|C>UPDATE-TF account anchor-id dptf-id dptf-amount)
            (write ANK|T|Anchors (UC_UserAnchor account anchor-id)
                (UDC_AccountAnchor
                    (UEV_UpdateTrueFungibleAnchor account anchor-id dptf-id dptf-amount direction)
                    account anchor-id
                )
            )
        )
    )
    (defun XE_UpdateSemiFungibleAnchor (account:string anchor-id:string dpsf-id:string nonces:[integer] nonce-amounts:[integer] direction:bool)
        @doc "Updates the Anchor for a given <account> pertaining to a given <dpsf-id> and <nonce> with <nonce-amounts>"
        (UEV_IMC)
        (with-capability (ANK|C>UPDATE-SF account anchor-id dpsf-id nonces)
            (write ANK|T|Anchors (UC_UserAnchor account anchor-id)
                (UDC_AccountAnchor
                    (UEV_UpdateSemiFungibleAnchor account anchor-id dpsf-id nonces nonce-amounts direction)
                    account anchor-id
                )
            )
        )
    )
    (defun XE_UpdateNonFungibleAnchor (account:string anchor-id:string dpnf-id:string nonces:[integer] direction:bool)
        @doc "Updates the Anchor for a given <account> pertaining to a given <dpnf-id> and <nonce> with <nonce-amounts>"
        (UEV_IMC)
        (with-capability (ANK|C>UPDATE-NF account anchor-id dpnf-id nonces)
            (write ANK|T|Anchors (UC_UserAnchor account anchor-id)
                (UDC_AccountAnchor
                    (UEV_UpdateNonFungibleAnchor account anchor-id dpnf-id nonces direction)
                    account anchor-id
                )
            )
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)
;;
(create-table ANK|T|Anchor)
(create-table ANK|T|TF|Anchor)
(create-table ANK|T|SF|Anchor)
(create-table ANK|T|NF|Anchor)
(create-table ANK|T|TF|Anchors)
(create-table ANK|T|SF|Anchors)
(create-table ANK|T|NF|Anchors)
(create-table ANK|T|Anchors)