(module AQP-ANK GOV
    ;;
    (implements OuronetPolicy)
    ;(implements DemiourgosPactDigitalCollectibles-UtilityPrototype)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_AQP-ANK                (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|ANK_ADMIN)))
    (defcap GOV|ANK_ADMIN ()                (enforce-guard GOV|MD_AQP-ANK))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;; [Keys]
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|CollectiblesKey ()           (+ (GOV|NS_Use) ".dh_sc_aqp-keyset"))
    ;;
    ;; [SC-Names]
    (defun GOV|AQP-ANK|SC_NAME ()           (at 0 [""]))
    ;;
    ;; [PBLs]
    (defun GOV|AQP-ANK|PBL ()               (at 0 [""]))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|AQP-ANK|CALLER ()
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
                (mg:guard (create-capability-guard (P|AQP-ANK|CALLER)))
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
    (deftable ANK|T|Anchor:{ANK|Schema})                        ;;Key = <Anchor-ID>
    (deftable ANK|T|TF|Anchor:{ANK|TF|Schema})                  ;;Key = <Anchor-ID> | <DPTF-ID>
    (deftable ANK|T|SF|Anchor:{ANK|SF|Schema})                  ;;Key = <Anchor-ID> | <DPSF-ID> | <Nonce>
    (deftable ANK|T|NF|Anchor:{ANK|SF|Schema})                  ;;Key = <Anchor-ID> | <DPNF-ID> | <Trait-Key> | <Trait-Value>
    ;;
    (deftable ANK|T|Anchors:{ANK|UserSchema})                   ;;Key = <Ouronet-Account> | <Anchor-ID>
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
    ;;
    
    ;;
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)