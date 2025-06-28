(module DPDC-S GOV
    ;;
    (implements OuronetPolicy)
    (implements DpdcSets)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-S                 (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPDC-S_ADMIN)))
    (defcap GOV|DPDC-S_ADMIN ()             (enforce-guard GOV|MD_DPDC-S))
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
    (defcap P|DPDC-S|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC-S|CALLER))
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
        (with-capability (GOV|DPDC-S_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC-S_ADMIN)
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
                (mg:guard (create-capability-guard (P|DPDC-S|CALLER)))
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
    (defun CT_EmptyCumulator        ()(let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::DALOS|EmptyOutputCumulatorV2)))
    (defconst BAR                   (CT_Bar))
    (defconst EOC                   (CT_EmptyCumulator))
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
    (defcap DPDC|C>DEFINE-PRIMORDIAL-SET 
        (
            id:string son:bool
            set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
            )
            (ref-DPDC::CAP_Owner id son)
            (ref-DPDC-C::UEV_NonceDataForCreation ind)
            (UEV_PrimordialSetDefinition id son set-definition)
            (compose-capability (P|SECURE-CALLER))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_PrimordialSetDefinition (id:string son:bool set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}])
        (let
            (
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (ref-DPDC:module{Dpdc} DPDC)
                (composed:[integer]
                    (fold
                        (lambda
                            (acc:[integer] idx:integer)
                            (+ acc (at "allowed-nonces" (at idx set-definition)))
                        )
                        []
                        (enumerate 0 (- (length set-definition) 1))
                    )
                )
                (max:integer (ref-U|INT::UC_MaxInteger (distinct composed)))
                (nu:integer (ref-DPDC::UR_NoncesUsed id son))
            )
            (enforce (<= max nu) "Invalid Set-Definition for a Primordial Set with non existent nonces")
        )
    )
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_DefinePrimordialSet:object{IgnisCollector.OutputCumulator}
        (
            id:string son:bool set-name:string
            set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
        (UEV_IMC)
        (with-capability (DPDC|C>DEFINE-PRIMORDIAL-SET id son set-definition ind)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-DPDC:module{Dpdc} DPDC)
                    (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                    ;;
                    (creator:string (ref-DPDC::UR_CreatorKonto id true))
                    (price:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                    (set-class:integer (XI_PrimordialSet id son set-name set-definition ind))
                    (ico0:object{IgnisCollector.OutputCumulator}
                        (ref-IGNIS::IC|UDC_ConstructOutputCumulator price creator false [])
                    )
                    (ico1:object{IgnisCollector.OutputCumulator}
                        (if son
                            (ref-DPDC-C::C_CreateNewNonce id son set-class 0 ind true)
                            EOC
                        )
                        
                    )
                )
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico0 ico1] [])
            )
        )
    )
    ;;(defun C_EnableSetFragmentation) ;; ??
    ;;(defun C_ToggleSet)
    ;;(defun C_UpdateSetName)
    ;;(defun C_UpdateSet)
    ;;{F7}  [X]
    (defun XI_PrimordialSet:integer
        (
            id:string son:bool set-name:string
            set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
        (require-capability (DPDC|C>DEFINE-PRIMORDIAL-SET id son set-definition ind))
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-DPDC:module{Dpdc} DPDC)
                (set-classes-used:integer (ref-DPDC::UR_SetClassesUsed id son))
                (set-class:integer (+ set-classes-used 1))
            )
            (ref-DPDC::XE_InsertCollectionSet id son set-class
                (ref-DPDC-UDC::UDC_DPDC|Set
                    set-class
                    set-name
                    true
                    true
                    false
                    set-definition
                    [(ref-DPDC-UDC::UDC_DPDC|AllowedClassForSetPosition -1)]
                    ind
                    (ref-DPDC-UDC::UDC_ZeroNonceData)
                )
            )
            (ref-DPDC::XE_U|SetClassesUsed id son set-class)
            set-class
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)