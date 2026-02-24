(module DPDC-S GOV
    ;;
    (implements OuronetPolicyV1)
    (implements DpdcSetsV1)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-S                 (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPDC-S_ADMIN)))
    (defcap GOV|DPDC-S_ADMIN ()             (enforce-guard GOV|MD_DPDC-S))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV1} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicyV1.P|S})
    (deftable P|MT:{OuronetPolicyV1.P|MS})
    ;;{P3}
    (defcap P|DPDC-S|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC-S|CALLER))
        (compose-capability (SECURE))
    )
    (defcap P|DPDC-S|REMOTE-GOV ()
        @doc "DPDC Remote Governor Capability"
        true
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV1} DALOS)) (ref-DALOS::P|Info)))
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
                    (ref-U|LST:module{StringProcessorV1} U|LST)
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
                (ref-P|DPDC:module{OuronetPolicyV1} DPDC)
                (ref-P|DPDC-C:module{OuronetPolicyV1} DPDC-C)
                (ref-P|DPDC-T:module{OuronetPolicyV1} DPDC-T)
                (mg:guard (create-capability-guard (P|DPDC-S|CALLER)))
            )
            (ref-P|DPDC::P|A_Add
                "DPDC-S|RemoteDpdcGov"
                (create-capability-guard (P|DPDC-S|REMOTE-GOV))
            )
            (ref-P|DPDC::P|A_AddIMP mg)
            (ref-P|DPDC-C::P|A_AddIMP mg)
            (ref-P|DPDC-T::P|A_AddIMP mg)
        )
    )
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuardsV1} U|G)
            )
            (ref-U|G::UEV_Any (P|UR_IMP))
        )
    )
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    ;;{2}
    (deftable DPSF|SetsTable:{DpdcUdcV1.DPDC|Set})                ;;Key = <DPSF-id> + BAR + <set-class>
    ;;
    (deftable DPNF|SetsTable:{DpdcUdcV1.DPDC|Set})                ;;Key = <DPNF-id> + BAR + <set-class>
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstantsV1} U|CT)) (ref-U|CT::CT_BAR)))
    (defun CT_EmptyCumulator ()     (let ((ref-IGNIS:module{IgnisCollectorV1} IGNIS)) (ref-IGNIS::DALOS|EmptyOutputCumulatorV2)))
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
    (defcap DPDC-S|C>MAKE (id:string son:bool nonces:[integer] set-class:integer)
        @event
        (let
            (
                (iz-active:bool (UR_IzSetActive id son set-class))
            )
            (enforce iz-active (format "Set-Class {} is not active for Set Composition" [set-class]))
            (UEV_NoncesForSetClass id son nonces set-class)
            (compose-capability (P|DPDC-S|CALLER))
            (compose-capability (P|DPDC-S|REMOTE-GOV))
        )
    )
    (defcap DPDC-S|C>BREAK (id:string son:bool nonce:integer)
        @event
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (nonce-class:integer (ref-DPDC::UR_NonceClass id son nonce))
            )
            ;;Nonces of Inactive Sets can still be broken down.
            (enforce (!= nonce-class 0) "Only Class Non-0 Nonces can be broken Down")
            (compose-capability (P|DPDC-S|CALLER))
            (compose-capability (P|DPDC-S|REMOTE-GOV))
        )
    )
    (defcap DPDC-S|C>DEFINE-PRIMORDIAL 
        (
            id:string son:bool
            set-definition:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdcV1.DPDC|NonceData}
        )
        @event
        (UEV_PrimordialSetDefinition id son set-definition)
        (compose-capability (DPDC-S|CX>DEFINE id son ind))
    )
    (defcap DPDC-S|C>DEFINE-COMPOSITE 
        (
            id:string son:bool
            set-definition:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdcV1.DPDC|NonceData}
        )
        @event
        (UEV_CompositeSetDefinition id son set-definition)
        (compose-capability (DPDC-S|CX>DEFINE id son ind))
    )
    (defcap DPDC-S|C>DEFINE-HYBRID 
        (
            id:string son:bool
            primordial-sd:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}]
            composite-sd:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdcV1.DPDC|NonceData}
        )
        @event
        (UEV_PrimordialSetDefinition id son primordial-sd)
        (UEV_CompositeSetDefinition id son composite-sd)
        (compose-capability (DPDC-S|CX>DEFINE id son ind))
    )
    (defcap DPDC-S|CX>DEFINE (id:string son:bool ind:object{DpdcUdcV1.DPDC|NonceData})
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (ref-DPDC-C:module{DpdcCreateV1} DPDC-C)
            )
            (ref-DPDC::CAP_Owner id son)
            (ref-DPDC-C::UEV_NonceDataForCreation ind)
            (compose-capability (P|SECURE-CALLER))
        )
    )
    (defcap DPDC-S|C>ENABLE-FRAGMENTATION
        (
            id:string son:bool set-class:integer
            fragmentation-ind:object{DpdcUdcV1.DPDC|NonceData}
        )
        @event
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (ref-DPDC-C:module{DpdcCreateV1} DPDC-C)
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
                (ref-DPDC:module{DpdcV1} DPDC)
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
                (ref-DPDC:module{DpdcV1} DPDC)
                (current-name:string (UR_SetName id son set-class))
            )
            (enforce (!= new-name current-name) (format "The Set Name of <{}> must be different from the current name of <{}> for operation" [new-name current-name]))
            (UEV_SetActiveState id son set-class true)
            (ref-DPDC::CAP_Owner id son)
            (compose-capability (SECURE))
        )
    )
    (defcap DPDC-S|C>MULTIPLIER (id:string son:bool set-class:integer new-multiplier:decimal)
        @event
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (current-multiplier:string (UR_SetMultiplier id son set-class))
            )
            ;;Multiplier Precision Check, maximum 3 Precision for Set Multiplier
            (enforce
                (= (floor new-multiplier 3) new-multiplier)
                (format "Input Set-Multiplier of {} is not conform with its designed precision of only 3 decimals" [new-multiplier])
            )
            (enforce 
                (!= new-multiplier current-multiplier) 
                (format "The Set Multiplier of <{}> must be different from the current Set Multiplier of <{}> for operation" [new-multiplier current-multiplier])
            )
            (UEV_SetActiveState id son set-class true)
            (ref-DPDC::CAP_Owner id son)
            (compose-capability (SECURE))
        )
    )

    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;  [6] - [Set]
    (defun UR_Set:object{DpdcUdcV1.DPDC|Set} (id:string son:bool set-class:integer)
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
    (defun UR_SetMultiplier:decimal (id:string son:bool set-class:integer)
        (at "set-score-multiplier" (UR_Set id son set-class))
    )
    (defun UR_NonceOfSet:integer (id:string set-class:integer)
        (at "nonce-of-set" (UR_Set id true set-class))
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
    (defun UR_PSD:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}]
        (id:string son:bool set-class:integer)
        (at "primordial-set-definition" (UR_Set id son set-class))
    )
    (defun UR_CSD:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}] 
        (id:string son:bool set-class:integer)
        (at "composite-set-definition" (UR_Set id son set-class))
    )
    (defun UR_SetNonceData:object{DpdcUdcV1.DPDC|NonceData} (id:string son:bool set-class:integer)
        (at "nonce-data" (UR_Set id son set-class))
    )
    (defun UR_SetSplitData:object{DpdcUdcV1.DPDC|NonceData} (id:string son:bool set-class:integer)
        (at "split-data" (UR_Set id son set-class))
    )
    ;;
    ;;Score Read for Nonce
    (defun UR_N|Score:decimal (id:string son:bool nonce:integer)
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (nonce-class:integer (ref-DPDC::UR_NonceClass id son nonce))
                (raw-nonce-score:decimal (ref-DPDC::UR_N|RawScore (ref-DPDC::UR_NativeNonceData id son (abs nonce))))
            )
            (if (= nonce-class 0)
                (if (< nonce 0)
                    (/ raw-nonce-score 1000.0)
                    (if (= raw-nonce-score -1.0)
                        0.0
                        raw-nonce-score
                    )
                )
                (let
                    (
                        (multiplier:decimal (UR_SetMultiplier id son nonce-class))
                        (multiplied-score:decimal (* raw-nonce-score multiplier))
                    )
                    (if (< nonce 0)
                        (/ multiplied-score 1000.0)
                        (if (= multiplied-score -1000.0)
                            0.0
                            multiplied-score
                        )
                    )
                )
            )
        )
    )
    ;;{F1}  [URC]
    ;:Requires rethinking
    (defun URC_PrimordialOrComposite:[bool] (id:string son:bool set-class:integer)
        (UEV_SetClass id son set-class)
        [
            (UR_IzSetPrimordial id son set-class)
            (UR_IzSetComposite id son set-class)
        ]
    )
    (defun URC_NoncesSummedScore:decimal (id:string son:bool nonces:[integer])
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (summed-score:decimal
                    (fold
                        (lambda
                            (acc:decimal idx:integer)
                            (+ acc (ref-DPDC::UR_N|RawScore (ref-DPDC::UR_NativeNonceData id son (at idx nonces))))
                        )
                        0.0
                        (enumerate 0 (- (length nonces) 1))
                    )
                )
            )
            (if (< summed-score 0.0)
                0.0
                summed-score
            )
        )
    )
    ;;
    (defun URC_SemiFungibleConstituents:[integer] (id:string set-class:integer)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdcV1} DPDC-UDC)
                (psd:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}] (UR_PSD id true set-class))
                (csd:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}] (UR_CSD id true set-class))
                (npsd:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}] (ref-DPDC-UDC::UDC_NoPrimordialSet))
                (ncsd:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}] (ref-DPDC-UDC::UDC_NoCompositeSet))
                (l-psd:integer
                    (if (= psd npsd)
                        0
                        (length psd)
                    )
                )
                (l-csd:integer
                    (if (= csd ncsd)
                        0
                        (length csd)
                    )
                )
            )
            (if (= l-psd 0)
                ;;Composite Set
                (URCX|CSD_NonceList id csd)
                (if (= l-csd 0)
                    ;;Primordial Set
                    (URCX|PSD_FirstNoncesList psd)
                    ;;Hybrid Set
                    (+ (URCX|CSD_NonceList id csd) (URCX|PSD_FirstNoncesList psd))
                )
            )
        )
    )
    (defun URCX|PSD_FirstNoncesList:[integer] (psd:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}])
        @doc "Returns a list of Nonces that composed the PSD, only works for SFTs, \
            \ since the 1st Nonce of the <allowed-nonces> is used"
        (let
            (
                (ref-U|LST:module{StringProcessorV1} U|LST)
            )
            (fold
                (lambda
                    (acc:[integer] idx:integer)
                    (let
                        (
                            (element:object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition} (at idx psd))
                            (allowed-nonces:[integer] (at "allowed-nonces" element))
                            (first-allowed-nonce:integer (at 0 allowed-nonces))
                        )
                        (ref-U|LST::UC_AppL acc first-allowed-nonce)
                    )
                )
                []
                (enumerate 0 (- (length psd) 1))
            )
        )
    )
    (defun URCX|CSD_NonceList:[integer] (id:string csd:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}])
        @doc "Returns a list of Nonces that composed the CSD, only works for SFTs \
            \ since SFTs save the Nonce of the Set Class"
        (let
            (
                (ref-U|LST:module{StringProcessorV1} U|LST)
            )
            (fold
                (lambda
                    (acc:[integer] idx:integer)
                    (let
                        (
                            (element:object{DpdcUdcV1.DPDC|AllowedClassForSetPosition} (at idx csd))
                            (allowed-sclass:integer (at "allowed-sclass" element))
                            (nonce-of-set:integer (UR_NonceOfSet id allowed-sclass))
                        )
                        (ref-U|LST::UC_AppL acc nonce-of-set)
                    )
                )
                []
                (enumerate 0 (- (length csd) 1))
            )
        )
    )
    (defun URC_NonFungibleConstituents:[integer] (id:string nonce:integer)
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (nonce-class:integer (ref-DPDC::UR_NonceClass id false nonce))
            )
            (enforce (!= nonce-class 0) "Invalid NFT Nonce to Read Constituents")
            (ref-DPDC::UR_N|Composition (ref-DPDC::UR_NativeNonceData id false nonce))
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_PrimordialSetDefinition (id:string son:bool set-definition:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}])
        (let
            (
                (ref-U|INT:module{OuronetIntegersV1} U|INT)
                (ref-DPDC:module{DpdcV1} DPDC)
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
            (map
                (lambda
                    (idx:integer)
                    (UEV_PrimordialSetElement son (at idx set-definition))
                )
                (enumerate 0 (- (length set-definition) 1))
            )
        )
    )
    (defun UEV_PrimordialSetElement (son:bool element:object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition})
        (let
            (
                (allowed-nonces:[integer] (at "allowed-nonces" element))
                (size:integer (length allowed-nonces))
            )
            (if son
                (enforce (= size 1) "SFT Set Elements must have only 1 allowed element")
                (enforce (> size 1) "NFT Set Elements must have more than 1 allowed element")
            )
        )
    )
    (defun UEV_CompositeSetDefinition (id:string son:bool set-definition:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}])
        (let
            (
                (ref-U|INT:module{OuronetIntegersV1} U|INT)
                (ref-DPDC:module{DpdcV1} DPDC)
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
                (ref-DPDC-UDC:module{DpdcUdcV1} DPDC-UDC)
                (sd:object{DpdcUdcV1.DPDC|NonceData} (UR_SetSplitData id son set-class))
                (zd:object{DpdcUdcV1.DPDC|NonceData} (ref-DPDC-UDC::UDC_ZeroNonceData))
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
    ;;
    (defun UEV_NoncesForSetClass (id:string son:bool nonces:[integer] set-class:integer)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdcV1} DPDC-UDC)
                (psd:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}] (UR_PSD id son set-class))
                (csd:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}] (UR_CSD id son set-class))
                (npsd:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}] (ref-DPDC-UDC::UDC_NoPrimordialSet))
                (ncsd:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}] (ref-DPDC-UDC::UDC_NoCompositeSet))
                (l-psd:integer
                    (if (= psd npsd)
                        0
                        (length psd)
                    )
                )
                (l-csd:integer
                    (if (= csd ncsd)
                        0
                        (length csd)
                    )
                )
                (tl:integer (+ l-psd l-csd))
                (nl:integer (length nonces))
            )
            (enforce (= tl nl) (format "Nonces list {} are invalid for making a Set of Class {}" [nonces set-class]))
            (if (= l-psd 0)
                ;;Composite Set
                (UEV_Composite id son nonces csd)
                (if (= l-csd 0)
                    ;;Primordial Set
                    (UEV_Primordial nonces psd)
                    ;;Hybrid Set
                    (do
                        (UEV_Primordial (take l-psd nonces) psd)
                        (UEV_Composite id son (drop l-psd nonces) csd)
                    )
                )
            )
        )
    )
    (defun UEV_Primordial (nonces:[integer] psd:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}])
        (let
            (
                (l1:integer (length nonces))
                (l2:integer (length psd))
            )
            (enforce (= l1 l2) "Incompatible Input for <UEV_Composite> Validation")
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (set-element:object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition} (at idx psd))
                            (allowed-nonces:[integer] (at "allowed-nonces" set-element))
                            (nonce:integer (at idx nonces))
                            (iz-nonce-allowed:bool (contains nonce allowed-nonces))
                        )
                        (enforce iz-nonce-allowed (format "Nonce {} not compatible with Set-Element {} for Set Definition" [nonce set-element]))
                    )
                )
                (enumerate 0 (- (length psd) 1))
            )
        )
    )
    (defun UEV_Composite (id:string son:bool nonces:[integer] csd:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}])
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (l1:integer (length nonces))
                (l2:integer (length csd))
            )
            (enforce (= l1 l2) "Incompatible Input for <UEV_Composite> Validation")
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (set-element:object{DpdcUdcV1.DPDC|AllowedClassForSetPosition} (at idx csd))
                            (allowed-sclass:integer (at "allowed-sclass" set-element))
                            (nonce:integer (at idx nonces))
                            (nonce-class:integer (ref-DPDC::UR_NonceClass id son nonce))
                            (iz-nonce-allowed:bool (= nonce-class allowed-sclass))
                        )
                        (enforce iz-nonce-allowed (format "Nonce {} not compatible with Set-Element {} for Set Definition" [nonce set-element]))
                    )
                )
                (enumerate 0 (- (length csd) 1))
            )
        )
    )
    ;;
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_MakeSemiFungibleSet:object{IgnisCollectorV1.OutputCumulator}
        (account:string id:string nonces:[integer] set-class:integer how-many-sets:integer)
        (UEV_IMC)
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (ref-DPDC-C:module{DpdcCreateV1} DPDC-C)
                (ref-DPDC-T:module{DpdcTransferV1} DPDC-T)
                (dpdc:string (ref-DPDC::GOV|DPDC|SC_NAME))
                (son:bool true)
            )
            (with-capability (DPDC-S|C>MAKE id son nonces set-class)
                ;;1]SFT Set Nonce is already created with the Set Definition, 
                ;;it only needs a quantity of <how-many-sets> to be added to target <account>
                (ref-DPDC-C::XB_CreditSFT-Nonce account id (UR_NonceOfSet id set-class) how-many-sets)
                ;;2]Transfer <nonces> to <dpdc> last to return the cumulator.
                (ref-DPDC-T::C_Transfer [id] [son] account dpdc [nonces] [(make-list (length nonces) how-many-sets)] true)
            )
        )
    )
    (defun C_BreakSemiFungibleSet:object{IgnisCollectorV1.OutputCumulator}
        (account:string id:string nonce:integer how-many-sets:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DPDC:module{DpdcV1} DPDC)
                (ref-DPDC-C:module{DpdcCreateV1} DPDC-C)
                (ref-DPDC-T:module{DpdcTransferV1} DPDC-T)
                (dpdc:string (ref-DPDC::GOV|DPDC|SC_NAME))
                (son:bool true)
            )
            (with-capability (DPDC-S|C>BREAK id son nonce)
                (let
                    (
                        (ico1:object{IgnisCollectorV1.OutputCumulator}
                            ;;1]Transfer the SFT Sets from <account> to <dpdc>
                            (ref-DPDC-T::C_Transfer [id] [son] account dpdc [[nonce]] [[how-many-sets]] true)
                        )
                        (constituents:[integer] 
                            (URC_SemiFungibleConstituents id (ref-DPDC::UR_NonceClass id son nonce))
                        )
                        (ico2:object{IgnisCollectorV1.OutputCumulator}
                            ;;2]Release the Set Elements from <dpdc> to <account>
                            (ref-DPDC-T::C_Transfer [id] [son] dpdc account [constituents] [(make-list (length constituents) how-many-sets)] true)
                        )
                    )
                    ;;3]Burn the Input SFT Set Nonces
                    (ref-DPDC-C::XE_DebitSFT-Nonce dpdc id nonce how-many-sets false)
                    (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2] [])
                )
            )
        )
    )
    (defun C_MakeNonFungibleSet:object{IgnisCollectorV1.OutputCumulator}
        (account:string id:string nonces:[integer] set-class:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DPDC-UDC:module{DpdcUdcV1} DPDC-UDC)
                (ref-DPDC:module{DpdcV1} DPDC)
                (ref-DPDC-C:module{DpdcCreateV1} DPDC-C)
                (ref-DPDC-T:module{DpdcTransferV1} DPDC-T)
                (dpdc:string (ref-DPDC::GOV|DPDC|SC_NAME))
                (son:bool false)
            )
            (with-capability (DPDC-S|C>MAKE id son nonces set-class)
                (let
                    (
                        (ico1:object{IgnisCollectorV1.OutputCumulator}
                            ;;1]Transfer <nonces> to <dpdc>
                            (ref-DPDC-T::C_Transfer [id] [son] account dpdc [nonces] [(make-list (length nonces) 1)] true)
                        )
                        ;;
                        (set-nd:object{DpdcUdcV1.DPDC|NonceData} (UR_SetNonceData id son set-class))
                        (summed-score:decimal (URC_NoncesSummedScore id son nonces))
                        (spawned-nonce-md:object{DpdcUdcV1.NonceMetaData}
                            (ref-DPDC-UDC::UDC_NonceMetaData
                                summed-score
                                nonces
                                {}
                                )
                        )
                        (spawned-nd:object{DpdcUdcV1.DPDC|NonceData}
                            (+
                                {"meta-data" : spawned-nonce-md}
                                (remove "meta-data" set-nd)
                            )
                        )
                        (ico2:object{IgnisCollectorV1.OutputCumulator}
                            ;;2]When one nonce of class non-0 is created, is automatically created on <dpdc> account
                            (ref-DPDC-C::C_CreateNewNonce id son set-class 1 spawned-nd false)
                        )
                        (ico3:object{IgnisCollectorV1.OutputCumulator}
                            ;;3]Transfer new set nonce to <account>
                            (ref-DPDC-T::C_Transfer [id] [son] dpdc account [[(ref-DPDC::UR_NoncesUsed id son)]] [[1]] true)
                        )
                    )
                    (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2 ico3] [])
                )
            )
        )
    )
    (defun C_BreakNonFungibleSet:object{IgnisCollectorV1.OutputCumulator}
        (account:string id:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DPDC:module{DpdcV1} DPDC)
                (ref-DPDC-C:module{DpdcCreateV1} DPDC-C)
                (ref-DPDC-T:module{DpdcTransferV1} DPDC-T)
                (dpdc:string (ref-DPDC::GOV|DPDC|SC_NAME))
                (son:bool false)
            )
            (with-capability (DPDC-S|C>BREAK id son nonce)
                (let
                    (
                        (ico1:object{IgnisCollectorV1.OutputCumulator}
                            ;;1]Transfer the SFT|NFT from <account> to <dpdc>
                            (ref-DPDC-T::C_Transfer [id] [son] account dpdc [[nonce]] [[1]] true)
                        )
                        (constituents:[integer]
                            (URC_NonFungibleConstituents id nonce)
                        )
                        (ico2:object{IgnisCollectorV1.OutputCumulator}
                            ;;2]Release the Set Elements from <dpdc> to <account>
                            (ref-DPDC-T::C_Transfer [id] [son] dpdc account [constituents] [(make-list (length constituents) 1)] true)
                        )
                    )
                    ;;3]Burn the Input SFT Set Nonces
                    (ref-DPDC-C::XE_DebitNFT-Nonce dpdc id nonce 1 false)
                    (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2] [])
                )
            )
        )
    )
    ;;
    (defun C_DefinePrimordialSet:object{IgnisCollectorV1.OutputCumulator}
        (
            id:string son:bool set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdcV1.DPDC|NonceData}
        )
        (UEV_IMC)
        (with-capability (DPDC-S|C>DEFINE-PRIMORDIAL id son set-definition ind)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                    (ref-DALOS:module{OuronetDalosV1} DALOS)
                    (ref-DPDC:module{DpdcV1} DPDC)
                    (ref-DPDC-C:module{DpdcCreateV1} DPDC-C)
                    ;;
                    (creator:string (ref-DPDC::UR_CreatorKonto id son))
                    (price:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                    (set-class:integer (XI_PrimordialSet id son set-name score-multiplier set-definition ind))
                    (ico0:object{IgnisCollectorV1.OutputCumulator}
                        (ref-IGNIS::UDC_ConstructOutputCumulator price creator false [])
                    )
                    (ico1:object{IgnisCollectorV1.OutputCumulator}
                        (if son
                            (ref-DPDC-C::C_CreateNewNonce id son set-class 0 ind true)
                            EOC
                        )
                    )
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico0 ico1] [])
            )
        )
    )
    (defun C_DefineCompositeSet:object{IgnisCollectorV1.OutputCumulator}
        (
            id:string son:bool set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdcV1.DPDC|NonceData}
        )
        (UEV_IMC)
        (with-capability (DPDC-S|C>DEFINE-COMPOSITE id son set-definition ind)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                    (ref-DALOS:module{OuronetDalosV1} DALOS)
                    (ref-DPDC:module{DpdcV1} DPDC)
                    (ref-DPDC-C:module{DpdcCreateV1} DPDC-C)
                    ;;
                    (creator:string (ref-DPDC::UR_CreatorKonto id son))
                    (price:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                    (set-class:integer (XI_CompositeSet id son set-name score-multiplier set-definition ind))
                    (ico0:object{IgnisCollectorV1.OutputCumulator}
                        (ref-IGNIS::UDC_ConstructOutputCumulator price creator false [])
                    )
                    (ico1:object{IgnisCollectorV1.OutputCumulator}
                        (if son
                            (ref-DPDC-C::C_CreateNewNonce id son set-class 0 ind true)
                            EOC
                        )
                    )
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico0 ico1] [])
            )
        )
    )
    (defun C_DefineHybridSet:object{IgnisCollectorV1.OutputCumulator}
        (
            id:string son:bool set-name:string score-multiplier:decimal
            primordial-sd:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}]
            composite-sd:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdcV1.DPDC|NonceData}
        )
        (UEV_IMC)
        (with-capability (DPDC-S|C>DEFINE-HYBRID id son primordial-sd composite-sd ind)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                    (ref-DALOS:module{OuronetDalosV1} DALOS)
                    (ref-DPDC:module{DpdcV1} DPDC)
                    (ref-DPDC-C:module{DpdcCreateV1} DPDC-C)
                    (dpdc:string (ref-DPDC::GOV|DPDC|SC_NAME))
                    ;;
                    (creator:string (ref-DPDC::UR_CreatorKonto id son))
                    (price:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                    (set-class:integer (XI_HybridSet id son set-name score-multiplier primordial-sd composite-sd ind))
                    (ico0:object{IgnisCollectorV1.OutputCumulator}
                        (ref-IGNIS::UDC_ConstructOutputCumulator price creator false [])
                    )
                    (ico1:object{IgnisCollectorV1.OutputCumulator}
                        (if son
                            (ref-DPDC-C::C_CreateNewNonce id son set-class 0 ind true)
                            (do
                                (ref-DPDC::XE_DeployAccountWNE dpdc id false)
                                EOC
                            )
                        )
                    )
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico0 ico1] [])
            )
        )
    )
    (defun C_EnableSetClassFragmentation:object{IgnisCollectorV1.OutputCumulator}
        (
            id:string son:bool set-class:integer
            fragmentation-ind:object{DpdcUdcV1.DPDC|NonceData}
        )
        (UEV_IMC)
        (with-capability (DPDC-S|C>ENABLE-FRAGMENTATION id son set-class fragmentation-ind)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                    (ref-DPDC:module{DpdcV1} DPDC)
                )
                (XI_FragmentSetClass id son set-class fragmentation-ind)
                (ref-IGNIS::UDC_BiggestCumulator (ref-DPDC::UR_CreatorKonto id son))
            )
        )
    )
    (defun C_ToggleSet:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool set-class:integer toggle:bool)
        (UEV_IMC)
        (with-capability (DPDC-S|C>TOGGLE id son set-class toggle)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                    (ref-DPDC:module{DpdcV1} DPDC)
                )
                (XI_ToggleSetClass id son set-class toggle)
                (ref-IGNIS::UDC_BiggestCumulator (ref-DPDC::UR_CreatorKonto id son))
            )
        )
    )
    (defun C_RenameSet:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool set-class:integer new-name:string)
        (UEV_IMC)
        (with-capability (DPDC-S|C>RENAME id son set-class new-name)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                    (ref-DPDC:module{DpdcV1} DPDC)
                )
                (XI_RenameSet id son set-class new-name)
                (ref-IGNIS::UDC_SmallCumulator (ref-DPDC::UR_CreatorKonto id son))
            )
        )
    )
    (defun C_UpdateSetMultiplier:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool set-class:integer new-multiplier:decimal)
        (UEV_IMC)
        (with-capability (DPDC-S|C>MULTIPLIER id son set-class new-multiplier)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                    (ref-DPDC:module{DpdcV1} DPDC)
                )
                (XI_Multiplier id son set-class new-multiplier)
                (ref-IGNIS::UDC_SmallestCumulator (ref-DPDC::UR_CreatorKonto id son))
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_PrimordialSet:integer
        (
            id:string son:bool set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdcV1.DPDC|NonceData}
        )
        (require-capability (DPDC-S|C>DEFINE-PRIMORDIAL id son set-definition ind))
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdcV1} DPDC-UDC)
                (ref-DPDC:module{DpdcV1} DPDC)
                (set-classes-used:integer (ref-DPDC::UR_SetClassesUsed id son))
                (set-class:integer (+ set-classes-used 1))
                (nonces-used:integer (ref-DPDC::UR_NoncesUsed id son))
                (nonce-of-set:integer
                    (if son
                        (+ nonces-used 1)
                        0
                    )
                )
            )
            (XI_I|CollectionSet id son set-class
                (ref-DPDC-UDC::S
                    set-class
                    set-name
                    score-multiplier
                    nonce-of-set
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
            id:string son:bool set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdcV1.DPDC|NonceData}
        )
        (require-capability (DPDC-S|C>DEFINE-COMPOSITE id son set-definition ind))
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdcV1} DPDC-UDC)
                (ref-DPDC:module{DpdcV1} DPDC)
                (set-classes-used:integer (ref-DPDC::UR_SetClassesUsed id son))
                (set-class:integer (+ set-classes-used 1))
                (nonces-used:integer (ref-DPDC::UR_NoncesUsed id son))
                (nonce-of-set:integer
                    (if son
                        (+ nonces-used 1)
                        0
                    )
                )
            )
            (XI_I|CollectionSet id son set-class
                (ref-DPDC-UDC::S
                    set-class
                    set-name
                    score-multiplier
                    nonce-of-set
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
    (defun XI_HybridSet:integer
        (
            id:string son:bool set-name:string score-multiplier:decimal
            primordial-sd:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}]
            composite-sd:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdcV1.DPDC|NonceData}
        )
        (require-capability (DPDC-S|C>DEFINE-HYBRID id son primordial-sd composite-sd ind))
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdcV1} DPDC-UDC)
                (ref-DPDC:module{DpdcV1} DPDC)
                (set-classes-used:integer (ref-DPDC::UR_SetClassesUsed id son))
                (set-class:integer (+ set-classes-used 1))
                (nonces-used:integer (ref-DPDC::UR_NoncesUsed id son))
                (nonce-of-set:integer
                    (if son
                        (+ nonces-used 1)
                        0
                    )
                )
            )
            (XI_I|CollectionSet id son set-class
                (ref-DPDC-UDC::S
                    set-class
                    set-name
                    score-multiplier
                    nonce-of-set
                    true
                    true
                    true
                    primordial-sd
                    composite-sd
                    ind
                    (ref-DPDC-UDC::UDC_ZeroNonceData)
                )
            )
            (ref-DPDC::XE_U|SetClassesUsed id son set-class)
            set-class
        )
    )
    (defun XI_FragmentSetClass
        (id:string son:bool set-class:integer fragmentation-ind:object{DpdcUdcV1.DPDC|NonceData})
        (require-capability (DPDC-S|C>ENABLE-FRAGMENTATION id son set-class fragmentation-ind))
        (XB_U|NonceOrSplitData id son set-class false fragmentation-ind)
    )
    (defun XI_ToggleSetClass (id:string son:bool set-class:integer toggle:bool)
        (require-capability (DPDC-S|C>TOGGLE id son set-class toggle))
        (XI_U|IzActive id son set-class toggle)
    )
    (defun XI_RenameSet (id:string son:bool set-class:integer new-name:string)
        (require-capability (DPDC-S|C>RENAME id son set-class new-name))
        (XI_U|SetName id son set-class new-name)
    )
    (defun XI_Multiplier (id:string son:bool set-class:integer new-multiplier:decimal)
        (require-capability (DPDC-S|C>MULTIPLIER id son set-class new-multiplier))
        (XI_U|SetMultiplier id son set-class new-multiplier)
    )
    ;;
    ;; [<SetsTable> Writings] [3]
    (defun XI_I|CollectionSet (id:string son:bool set-class:integer set:object{DpdcUdcV1.DPDC|Set})
        (require-capability (SECURE))
        (if son
            (insert DPSF|SetsTable (concat [id BAR (format "{}" [set-class])]) set)
            (insert DPNF|SetsTable (concat [id BAR (format "{}" [set-class])]) set)
        )
    )
    (defun XB_U|NonceOrSplitData (id:string son:bool set-class:integer nos:bool nd:object{DpdcUdcV1.DPDC|NonceData})
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
    (defun XI_U|SetMultiplier (id:string son:bool set-class:integer new-multiplier:decimal)
        (require-capability (SECURE))
        (if son
            (update DPSF|SetsTable (concat [id BAR (format "{}" [set-class])]) {"set-score-multiplier" : new-multiplier})
            (update DPNF|SetsTable (concat [id BAR (format "{}" [set-class])]) {"set-score-multiplier" : new-multiplier})
        )
    )
)

(create-table P|T)
(create-table P|MT)
;;DPSF
(create-table DPSF|SetsTable)
;;DPNF
(create-table DPNF|SetsTable)