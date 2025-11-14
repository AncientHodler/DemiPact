(interface AcquisitionAnchors
    (defun GOV|AQP|SC_NAME ())
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
        precision:decimal                                       ;;Precision of the Anchor Variable
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
        nonce-promile:decimal                                   ;;Promile of Nonce
        ;;
        ;;Select Keys
        anchor-id:string
        dpsf-id:string
        nonce:integer
    )
    (defschema ANK|NF|Schema
        trait-promile:decimal                                   ;;Promile of Trait
        ;;
        ;;Select Keys
        anchor-id:string
        dpnf-id:string
        trait-key:string
        trait-value:string
    )
    ;;3]Usert Anchor Values
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
    (deftable ANK|T|SF|Anchor:{ANK|SF|Schema})                  ;;Key = <Anchor-ID> | <DPSF-ID> | <Nonce>
    (deftable ANK|T|NF|Anchor:{ANK|NF|Schema})                  ;;Key = <Anchor-ID> | <DPNF-ID> | <Trait-Key> | <Trait-Value>
    ;;
    (deftable ANK|T|Anchors:{ANK|UserSchema})                   ;;Key = <Ouronet-Account> | <Anchor-ID>
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
    (defcap ANK|C>ISSUE (ank-name:string ank-asset:string ank-fungibility:[bool] prec:integer)
        @event
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (ref-U|ATS:module{UtilityAtsV2} U|ATS)
            )
            (ref-U|ATS::UEV_AutostakeIndex ank-name)
            (UEV_AnkAssetOwnership ank-asset ank-fungibility)
            (ref-U|DALOS::UEV_Decimals prec)
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
        @event
        (let
            (
                (ref-DPDC:module{DpdcV4} DPDC)
            )
            (ref-DPDC::UEV_Nonce dpsf-id true nonce)
            (compose-capability (ANK|CX>DEFINE anchor-id promile))
        )
    )
    (defcap ANK|C>DEFINE-NF (anchor-id:string dpnf-id:string promile:decimal)
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
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_TF|AnchorKey:string (anchor-id:string dptf-id:string)
        (concat [anchor-id BAR dptf-id])
    )
    (defun UC_SF|AnchorKey:string (anchor-id:string dpsf-id:string nonce:integer)
        (concat [anchor-id BAR dpsf-id BAR (format "{}" [nonce])])
    )
    (defun UC_NF|AnchorKey:string (anchor-id:string dpnf-id:string trait-key:string trait-value:string)
        (concat [anchor-id BAR dpnf-id BAR trait-key BAR trait-value])
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
    (defun UR_TrueFungibleAnchor:object{ANK|TF|Schema} (anchor-id:string dptf-id:string)
        (read ANK|T|TF|Anchor (UC_TF|AnchorKey anchor-id dptf-id))
    )
    (defun UR_TF|Amount:decimal (anchor-id:string dptf-id:string)
        (at "unit-amount" (UR_TrueFungibleAnchor anchor-id dptf-id))
    )
    (defun UR_TF|Promile:decimal (anchor-id:string dptf-id:string)
        (at "promile" (UR_TrueFungibleAnchor anchor-id dptf-id))
    )
    (defun UR_TF|AnchorID:string (anchor-id:string dptf-id:string)
        (at "anchor-id" (UR_TrueFungibleAnchor anchor-id dptf-id))
    )
    (defun UR_TF|DptfID:string (anchor-id:string dptf-id:string)
        (at "dptf-id" (UR_TrueFungibleAnchor anchor-id dptf-id))
    )
    ;;2b] - <ANK|T|SF|Anchor>
    (defun UR_SemiFungibleAnchor:object{ANK|SF|Schema} (anchor-id:string dpsf-id:string nonce:integer)
        (read ANK|T|SF|Anchor (UC_SF|AnchorKey anchor-id dpsf-id nonce))
    )
    (defun UR_SF|Promile:decimal (anchor-id:string dpsf-id:string nonce:integer)
        (at "nonce-promile" (UR_SemiFungibleAnchor anchor-id dpsf-id nonce))
    )
    (defun UR_SF|AnchorID:string (anchor-id:string dpsf-id:string nonce:integer)
        (at "anchor-id" (UR_SemiFungibleAnchor anchor-id dpsf-id nonce))
    )
    (defun UR_SF|DpsfId:string (anchor-id:string dpsf-id:string nonce:integer)
        (at "dpsf-id" (UR_SemiFungibleAnchor anchor-id dpsf-id nonce))
    )
    (defun UR_SF|Nonce:integer (anchor-id:string dpsf-id:string nonce:integer)
        (at "nonce" (UR_SemiFungibleAnchor anchor-id dpsf-id nonce))
    )
    ;;2c] - <ANK|T|NF|Anchor>
    (defun UR_NonFungibleAnchor:object{ANK|NF|Schema} (anchor-id:string dpnf-id:string trait-key:string trait-value:string)
        (read ANK|T|NF|Anchor (UC_NF|AnchorKey anchor-id dpnf-id trait-key trait-value))
    )
    (defun UR_NF|Promile:decimal (anchor-id:string dpnf-id:string trait-key:string trait-value:string)
        (at "trait-promile" (UR_NonFungibleAnchor anchor-id dpnf-id trait-key trait-value))
    )
    (defun UR_NF|AnchorID:string (anchor-id:string dpnf-id:string trait-key:string trait-value:string)
        (at "anchor-id" (UR_NonFungibleAnchor anchor-id dpnf-id trait-key trait-value))
    )
    (defun UR_NF|DpnfID:string (anchor-id:string dpnf-id:string trait-key:string trait-value:string)
        (at "dpnf-id" (UR_NonFungibleAnchor anchor-id dpnf-id trait-key trait-value))
    )
    (defun UR_NF|TraitKey:string (anchor-id:string dpnf-id:string trait-key:string trait-value:string)
        (at "trait-key" (UR_NonFungibleAnchor anchor-id dpnf-id trait-key trait-value))
    )
    (defun UR_NF|TraitValue:string (anchor-id:string dpnf-id:string trait-key:string trait-value:string)
        (at "trait-value" (UR_NonFungibleAnchor anchor-id dpnf-id trait-key trait-value))
    )
    ;;3] - <ANK|T|Anchors>
    (defun UR_UserAnchor:object{ANK|UserSchema} (account:string anchor-id:string)
        (read ANK|T|Anchors (UC_UserAnchor account anchor-id))
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
    ;;{F3}  [UDC]
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
                    (anchor-id:string (XI_Issue ank-name ank-asset ank-fungibility prec))
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
        (with-capability (ANK|C>DEFINE-NF anchor-id dpnf-id promile)
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
            )
            (insert ANK|T|Anchor anchor-id
                {"ank-asset"        : ank-asset
                ,"ank-fungibility"  : ank-fungibility
                ,"precision"        : prec
                ,"anchor-id"        : anchor-id
                }
            )
            anchor-id
        )
    )
    (defun XI_DefineTrueFungibleAnchor (anchor-id:string dptf-id:string dptf-amount:decimal promile:decimal)
        (require-capability (SECURE))
        (insert ANK|T|TF|Anchor (UC_TF|AnchorKey anchor-id dptf-id)
            {"unit-amount"          : dptf-amount
            ,"promile"              : promile
            ,"anchor-id"            : anchor-id
            ,"dptf-id"              : dptf-id}
        )
    )
    (defun XI_DefineSemiFungibleAnchor (anchor-id:string dpsf-id:string nonce:integer promile:decimal)
        (require-capability (SECURE))
        (insert ANK|T|SF|Anchor (UC_SF|AnchorKey anchor-id dpsf-id nonce)
            {"nonce-promile"        : promile
            ,"anchor-id"            : anchor-id
            ,"dpsf-id"              : dpsf-id
            ,"nonce"                : nonce
            }
        )
    )
    (defun XI_DefineNonFungibleAnchor (anchor-id:string dpnf-id:string trait-key:string trait-value:string promile:decimal)
        (require-capability (SECURE))
        (insert ANK|T|NF|Anchor (UC_NF|AnchorKey anchor-id dpnf-id trait-key trait-value)
            {"trait-promile"        : promile
            ,"anchor-id"            : anchor-id
            ,"dpnf-id"              : dpnf-id
            ,"trait-key"            : trait-key
            ,"trait-value"          : trait-value
            }
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
(create-table ANK|T|Anchors)