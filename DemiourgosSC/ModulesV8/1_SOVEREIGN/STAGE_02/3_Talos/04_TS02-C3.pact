(module TS02-C3 GOV
    @doc "TALOS Stage 2 Client Functiones Part 3 - Acquisition Pools Functions"
    ;;
    (implements OuronetPolicy)
    (implements TalosStageTwo_ClientThree)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_TS02-C3        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TS02-C3_ADMIN)))
    (defcap GOV|TS02-C3_ADMIN ()    (enforce-guard GOV|MD_TS02-C3))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|TS ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (gap:bool (ref-DALOS::UR_GAP))
            )
            (enforce (not gap) "While Global Administrative Pause is online, no client Functions can be executed")
            (compose-capability (P|TALOS-SUMMONER))
        )
    )
    (defcap P|TALOS-SUMMONER ()
        @doc "Talos Summoner Capability"
        true
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
        (with-capability (GOV|TS02-C3_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|TS02-C3_ADMIN)
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
                (ref-P|TS01-A:module{TalosStageOne_AdminV6} TS01-A)
                (ref-P|ANK:module{OuronetPolicy} AQP-ANK)
                (ref-P|SCR:module{OuronetPolicy} AQP-SCORE)
                (ref-P|AQP:module{OuronetPolicy} AQP)
                (ref-P|FVT:module{OuronetPolicy} FVT)
                (mg:guard (create-capability-guard (P|TALOS-SUMMONER)))
            )
            (ref-P|TS01-A::P|A_AddIMP mg)
            (ref-P|ANK::P|A_AddIMP mg)
            (ref-P|SCR::P|A_AddIMP mg)
            (ref-P|AQP::P|A_AddIMP mg)
            (ref-P|FVT::P|A_AddIMP mg)
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
    (defun UC_ShortAccount:string (account:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV4} INFO-ZERO)
            )
            (ref-I|OURONET::OI|UC_ShortAccount account)
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun AQP|C_IssueAnchor:string (patron:string ank-name:string ank-asset:string ank-fungibility:[bool] prec:integer)
        @doc "Issues an Anchor. Anchor are used for score boosting"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-TS01-A:module{TalosStageOne_AdminV6} TS01-A)
                    (ref-ANK:module{AcquisitionAnchors} AQP-ANK)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-ANK::C_Issue patron ank-name ank-asset ank-fungibility prec)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun AQP|C_DefineTrueFungibleAnchor (patron:string anchor-id:string dptf-id:string dptf-amount:decimal promile:decimal)
        @doc "Defines an Anchor based on a True Fungible"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ANK:module{AcquisitionAnchors} AQP-ANK)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ANK::C_DefineTrueFungibleAnchor anchor-id dptf-id dptf-amount promile)
                )
            )
        )
    )
    (defun AQP|C_DefineSemiFungibleAnchor (patron:string anchor-id:string dpsf-id:string nonce:integer promile:decimal)
        @doc "Defines an Anchor based on a True Fungible"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ANK:module{AcquisitionAnchors} AQP-ANK)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ANK::C_DefineSemiFungibleAnchor anchor-id dpsf-id nonce promile)
                )
            )
        )
    )
    (defun AQP|C_DefineNonFungibleAnchor (patron:string anchor-id:string dpnf-id:string trait-key:string trait-value:string promile:decimal)
        @doc "Defines an Anchor based on a True Fungible"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ANK:module{AcquisitionAnchors} AQP-ANK)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ANK::C_DefineNonFungibleAnchor anchor-id dpnf-id trait-key trait-value promile)
                )
            )
        )
    )
    ;;
    ;;  [2] DPDC
    ;;
    
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)