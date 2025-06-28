(module DPDC-MNG GOV
    ;;
    (implements OuronetPolicy)
    (implements DpdcManagement)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-MNG               (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPDC-MNG_ADMIN)))
    (defcap GOV|DPDC-MNG_ADMIN ()           (enforce-guard GOV|MD_DPDC-MNG))
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
    (defcap P|DPDC-MNG|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC-MNG|CALLER))
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
        (with-capability (GOV|DPDC-MNG_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC-MNG_ADMIN)
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
                (mg:guard (create-capability-guard (P|DPDC-MNG|CALLER)))
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
    (defcap DPDC-MNG|S>CTRL (id:string son:bool)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::CAP_Owner id son)
            (ref-DPDC::UEV_CanUpgradeON id son)
        )
    )
    (defcap DPDC-MNG|S>TG_PAUSE (id:string son:bool toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (if toggle
                (ref-DPDC::UEV_CanPauseON id son)
                true
            )
            (ref-DPDC::CAP_Owner id son)
            (ref-DPDC::UEV_PauseState id son (not toggle))
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
    (defun C_Control:object{IgnisCollector.OutputCumulator}
        (id:string son:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (owner:string (ref-DPDC::UR_OwnerKonto id son))
            )
            (with-capability (DPDC-MNG|S>CTRL id son)
                (XI_Control id son cu cco ccc casr ctncr cf cw cp)
                (if son
                    (ref-IGNIS::IC|UDC_BigCumulator owner)
                    (ref-IGNIS::IC|UDC_BiggestCumulator owner)
                )
            )
        )
    )
    ;;
    (defun C_TogglePause:object{IgnisCollector.OutputCumulator}
        (id:string son:bool toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC-MNG|S>TG_PAUSE id son toggle)
                (XI_TogglePause id son toggle)
                (ref-IGNIS::IC|UDC_MediumCumulator (ref-DPDC::UR_OwnerKonto id son))
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_Control (id:string son:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        (require-capability (DPDC-MNG|S>CTRL id son))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::XE_U|Specs id son 
                (ref-DPDC::UDC_Control id son cu cco ccc casr ctncr cf cw cp)
            )
        )
    )
    (defun XI_TogglePause (id:string son:bool toggle:bool)
        (require-capability (DPDC-MNG|S>TG_PAUSE id son toggle))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::XE_U|IsPaused id son toggle)
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)