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
    (deftable DPSF|SetsTable:{DpdcUdc.DPDC|Set})                ;;Key = <DPSF-id> + BAR + <set-class>
    ;;
    (deftable DPNF|SetsTable:{DpdcUdc.DPDC|Set})                ;;Key = <DPNF-id> + BAR + <set-class>
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
    (defcap DPDC-S|C>DEFINE-PRIMORDIAL 
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
    (defcap DPDC-S|C>DEFINE-COMPOSITE 
        (
            id:string son:bool
            set-definition:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]
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
            (UEV_CompositeSetDefinition id son set-definition)
            (compose-capability (P|SECURE-CALLER))
        )
    )
    (defcap DPDC-S|C>ENABLE-FRAGMENTATION
        (
            id:string son:bool set-class:integer
            fragmentation-ind:object{DpdcUdc.DPDC|NonceData}
        )
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                (iz-fragmented:bool (UEV_IzSetClassFragmented id son set-class))
            )
            (enforce (not iz-fragmented) "Set Class must not be fragmented in order to enable fragmentation for it !")
            (UEV_SetClass id son set-class)
            (ref-DPDC::CAP_Owner id son)
            (ref-DPDC-C::UEV_NonceDataForCreation fragmentation-ind)
            (compose-capability (SECURE))
        )
    )
    (defcap DPDC-S|C>TOGGLE (id:string son:bool set-class:integer toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (UEV_SetActiveState id son set-class (not toggle))
            (ref-DPDC::CAP_Owner id son)
            (compose-capability (SECURE))
        )
    )
    (defcap DPDC-S|C>RENAME (id:string son:bool set-class:integer new-name:string)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (current-name:string (UR_SetName id son set-class))
            )
            (enforce (!= new-name current-name) (format "The Set Name of <{}> must be different from the current name of <{}> for operation" [new-name current-name]))
            (UEV_SetActiveState id son set-class true)
            (ref-DPDC::CAP_Owner id son)
            (compose-capability (SECURE))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;; [Set]
    (defun UR_Set:object{DpdcUdc.DPDC|Set} (id:string son:bool set-class:integer)
        (if son
            (read DPSF|SetsTable (concat [id BAR (format "{}" [set-class])]))
            (read DPNF|SetsTable (concat [id BAR (format "{}" [set-class])]))
        )
    )
    (defun UR_SetClass:integer (id:string son:bool set-class:integer)
        (at "set-class" (UR_Set id son set-class))
    )
    (defun UR_SetName:string (id:string son:bool set-class:integer)
        (at "set-name" (UR_Set id son set-class))
    )
    (defun UR_IzSetActive:bool (id:string son:bool set-class:integer)
        (at "iz-active" (UR_Set id son set-class))
    )
    (defun UR_IzSetPrimordial:bool (id:string son:bool set-class:integer)
        (at "iz-primordial" (UR_Set id son set-class))
    )
    (defun UR_IzSetComposite:bool (id:string son:bool set-class:integer)
        (at "iz-composite" (UR_Set id son set-class))
    )
    (defun UR_PSD:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
        (id:string son:bool set-class:integer)
        (at "primordial-set-definition" (UR_Set id son set-class))
    )
    (defun UR_CSD:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}] 
        (id:string son:bool set-class:integer)
        (at "composite-set-definition" (UR_Set id son set-class))
    )
    (defun UR_SetNonceData:object{DpdcUdc.DPDC|NonceData} (id:string son:bool set-class:integer)
        (at "nonce-data" (UR_Set id son set-class))
    )
    (defun UR_SetSplitData:object{DpdcUdc.DPDC|NonceData} (id:string son:bool set-class:integer)
        (at "split-data" (UR_Set id son set-class))
    )
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_PrimordialSetDefinition (id:string son:bool set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}])
        (let
            (
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (ref-DPDC:module{Dpdc} DPDC)
                (nonces-used-in-set-definition:[integer]
                    (fold
                        (lambda
                            (acc:[integer] idx:integer)
                            (+ acc (at "allowed-nonces" (at idx set-definition)))
                        )
                        []
                        (enumerate 0 (- (length set-definition) 1))
                    )
                )
                (max:integer (ref-U|INT::UC_MaxInteger (distinct nonces-used-in-set-definition)))
                (nu:integer (ref-DPDC::UR_NoncesUsed id son))
            )
            (enforce (<= max nu) "Invalid Set-Definition for a Primordial Set with non existent Nonces")
        )
    )
    (defun UEV_CompositeSetDefinition (id:string son:bool set-definition:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}])
        (let
            (
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (ref-DPDC:module{Dpdc} DPDC)
                (set-classes-used-in-set-definition:[integer]
                    (fold
                        (lambda
                            (acc:[integer] idx:integer)
                            (+ acc [(at "allowed-sclass" (at idx set-definition))])
                        )
                        []
                        (enumerate 0 (- (length set-definition) 1))
                    )
                )
                (max:integer (ref-U|INT::UC_MaxInteger (distinct set-classes-used-in-set-definition)))
                (scu:integer (ref-DPDC::UR_SetClassesUsed id son))
            )
            (enforce (<= max scu) "Invalid Set-Definition for a Composite Set with non existent Set-Classes")
        )
    )
    (defun UEV_SetClass (id:string son:bool set-class:integer)
        (let
            (
                (sc:integer (UR_SetClass id son set-class))
            )
            (enforce (> set-class 0) "Invalid Set-Class Value")
            (enforce (= set-class sc) "Invalid DPDC Set Data")
        )
    )
    (defun UEV_IzSetClassFragmented:bool (id:string son:bool set-class:integer)
        (enforce (> set-class 0) "Only greater than 0 set-classes can be checked for fragmentation")
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (sd:object{DpdcUdc.DPDC|NonceData} (UR_SetSplitData id son set-class))
                (zd:object{DpdcUdc.DPDC|NonceData} (ref-DPDC-UDC::UDC_ZeroNonceData))
            )
            (if (!= sd zd) true false)
        )
    )
    (defun UEV_Fragmentation (id:string son:bool set-class:integer)
        (let
            (
                (iz-fragmented:bool (UEV_IzSetClassFragmented id son set-class))
            )
            (enforce iz-fragmented "Set-Class must be fragmented for operation")
        )
    )
    (defun UEV_SetActiveState (id:string son:bool set-class:integer state:bool)
        (let
            (
                (x:bool (UR_IzSetActive id son set-class))
            )
            (enforce (= x state) (format "Set Class {} of {} ID {} must be set to {} for operation" [set-class (if son "SFT" "NFT") id state]))
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
        (with-capability (DPDC-S|C>DEFINE-PRIMORDIAL id son set-definition ind)
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
    (defun C_DefineCompositeSet:object{IgnisCollector.OutputCumulator}
        (
            id:string son:bool set-name:string
            set-definition:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
        (UEV_IMC)
        (with-capability (DPDC-S|C>DEFINE-COMPOSITE id son set-definition ind)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-DPDC:module{Dpdc} DPDC)
                    (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                    ;;
                    (creator:string (ref-DPDC::UR_CreatorKonto id true))
                    (price:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                    (set-class:integer (XI_CompositeSet id son set-name set-definition ind))
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
    (defun C_EnableSetClassFragmentation:object{IgnisCollector.OutputCumulator}
        (
            id:string son:bool set-class:integer
            fragmentation-ind:object{DpdcUdc.DPDC|NonceData}
        )
        (UEV_IMC)
        (with-capability (DPDC-S|C>ENABLE-FRAGMENTATION id son set-class fragmentation-ind)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC:module{Dpdc} DPDC)
                )
                (XI_FragmentSetClass id son set-class fragmentation-ind)
                (ref-IGNIS::IC|UDC_BiggestCumulator (ref-DPDC::UR_CreatorKonto id son))
            )
        )
    )
    (defun C_ToggleSet:object{IgnisCollector.OutputCumulator} (id:string son:bool set-class:integer toggle:bool)
        (UEV_IMC)
        (with-capability (DPDC-S|C>TOGGLE id son set-class toggle)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC:module{Dpdc} DPDC)
                )
                (XI_ToggleSetClass id son set-class toggle)
                (ref-IGNIS::IC|UDC_BiggestCumulator (ref-DPDC::UR_CreatorKonto id son))
            )
        )
    )
    (defun C_RenameSet:object{IgnisCollector.OutputCumulator} (id:string son:bool set-class:integer new-name:string)
        (UEV_IMC)
        (with-capability (DPDC-S|C>RENAME id son set-class new-name)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC:module{Dpdc} DPDC)
                )
                (XI_RenameSet id son set-class new-name)
                (ref-IGNIS::IC|UDC_SmallCumulator (ref-DPDC::UR_CreatorKonto id son))
            )
        )
    )
    ;;(defun C_UpdateSet) ;;cannot be done. For a new composition, a new set must be defined and previous set must be disabled.
    ;;{F7}  [X]
    (defun XI_PrimordialSet:integer
        (
            id:string son:bool set-name:string
            set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
        (require-capability (DPDC-S|C>DEFINE-PRIMORDIAL id son set-definition ind))
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-DPDC:module{Dpdc} DPDC)
                (set-classes-used:integer (ref-DPDC::UR_SetClassesUsed id son))
                (set-class:integer (+ set-classes-used 1))
            )
            (XI_I|CollectionSet id son set-class
                (ref-DPDC-UDC::UDC_DPDC|Set
                    set-class
                    set-name
                    true
                    true
                    false
                    set-definition
                    (ref-DPDC-UDC::UDC_NoCompositeSet)
                    ind
                    (ref-DPDC-UDC::UDC_ZeroNonceData)
                )
            )
            (ref-DPDC::XE_U|SetClassesUsed id son set-class)
            set-class
        )
    )
    (defun XI_CompositeSet:integer
        (
            id:string son:bool set-name:string
            set-definition:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
        (require-capability (DPDC-S|C>DEFINE-COMPOSITE id son set-definition ind))
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-DPDC:module{Dpdc} DPDC)
                (set-classes-used:integer (ref-DPDC::UR_SetClassesUsed id son))
                (set-class:integer (+ set-classes-used 1))
            )
            (XI_I|CollectionSet id son set-class
                (ref-DPDC-UDC::UDC_DPDC|Set
                    set-class
                    set-name
                    true
                    false
                    true
                    (ref-DPDC-UDC::UDC_NoPrimordialSet)
                    set-definition
                    ind
                    (ref-DPDC-UDC::UDC_ZeroNonceData)
                )
            )
            (ref-DPDC::XE_U|SetClassesUsed id son set-class)
            set-class
        )
    )
    (defun XI_FragmentSetClass
        (id:string son:bool set-class:integer fragmentation-ind:object{DpdcUdc.DPDC|NonceData})
        (require-capability (DPDC-S|C>ENABLE-FRAGMENTATION id son set-class fragmentation-ind))
        (XB_U|NonceOrSplitData id son set-class fragmentation-ind false)
    )
    (defun XI_ToggleSetClass (id:string son:bool set-class:integer toggle:bool)
        (require-capability (DPDC-S|C>TOGGLE id son set-class toggle))
        (XI_U|IzActive id son set-class toggle)
    )
    (defun XI_RenameSet (id:string son:bool set-class:integer new-name:string)
        (require-capability (DPDC-S|C>RENAME id son set-class new-name))
        (XI_U|SetName id son set-class new-name)
    )
    ;;
    ;; [<SetsTable> Writings] [3]
    (defun XI_I|CollectionSet (id:string son:bool set-class:integer set:object{DpdcUdc.DPDC|Set})
        (require-capability (SECURE))
        (if son
            (insert DPSF|SetsTable (concat [id BAR (format "{}" [set-class])]) set)
            (insert DPNF|SetsTable (concat [id BAR (format "{}" [set-class])]) set)
        )
    )
    (defun XB_U|NonceOrSplitData (id:string son:bool set-class:integer nd:object{DpdcUdc.DPDC|NonceData} nos:bool)
        (require-capability (SECURE))
        (if nos
            (if son
                (update DPSF|SetsTable (concat [id BAR (format "{}" [set-class])]) {"nonce-data" : nd})
                (update DPNF|SetsTable (concat [id BAR (format "{}" [set-class])]) {"nonce-data" : nd})
            )
            (if son
                (update DPSF|SetsTable (concat [id BAR (format "{}" [set-class])]) {"split-data" : nd})
                (update DPNF|SetsTable (concat [id BAR (format "{}" [set-class])]) {"split-data" : nd})
            )
        )  
    )
    (defun XI_U|IzActive (id:string son:bool set-class:integer toggle:bool)
        (require-capability (SECURE))
        (if son
            (update DPSF|SetsTable (concat [id BAR (format "{}" [set-class])]) {"iz-active" : toggle})
            (update DPNF|SetsTable (concat [id BAR (format "{}" [set-class])]) {"iz-active" : toggle})
        )
    )
    (defun XI_U|SetName (id:string son:bool set-class:integer new-name:string)
        (require-capability (SECURE))
        (if son
            (update DPSF|SetsTable (concat [id BAR (format "{}" [set-class])]) {"set-name" : new-name})
            (update DPNF|SetsTable (concat [id BAR (format "{}" [set-class])]) {"set-name" : new-name})
        )
    )
)

(create-table P|T)
(create-table P|MT)
;;DPSF
(create-table DPSF|SetsTable)
;;DPNF
(create-table DPNF|SetsTable)