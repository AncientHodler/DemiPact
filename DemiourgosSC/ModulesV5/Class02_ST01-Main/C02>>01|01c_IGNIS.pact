(module IGNIS GOV
    ;;
    (implements OuronetPolicy)
    (implements IgnisCollector)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_IGNIS                  (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|IGNIS_ADMIN)))
    (defcap GOV|IGNIS_ADMIN ()              (enforce-guard GOV|MD_IGNIS))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|IGNIS|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|IGNIS|CALLER))
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
        (with-capability (GOV|IGNIS_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|IGNIS_ADMIN)
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
                (mg:guard (create-capability-guard (P|IGNIS|CALLER)))
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
    (defconst DALOS|SC_NAME         (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|DALOS|SC_NAME)))
    (defconst OUROBOROS|SC_NAME     (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|OUROBOROS|SC_NAME)))
    (defconst GAS_EXCEPTION
        [
            DALOS|SC_NAME
            OUROBOROS|SC_NAME
        ]
    )
    (defun DALOS|EmptyOutputCumulatorV2:object{IgnisCollector.OutputCumulator} ()
        {"cumulator-chain"      :
            [
                {"ignis"        : 0.0
                ,"interactor"   : BAR}
            ]
        ,"output"               : []}
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
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun IC|URC_Exception (account:string)
        (contains account GAS_EXCEPTION)
    )
    (defun IC|URC_ZeroEliteGAZ (sender:string receiver:string)
        (let
            (
                (t1:bool (IC|URC_Exception sender))
                (t2:bool (IC|URC_Exception receiver))
            )
            (or t1 t2)
        )
    )
    (defun IC|URC_ZeroGAZ:bool (id:string sender:string receiver:string)
        (let
            (
                (t1:bool (IC|URC_ZeroGAS id sender))
                (t2:bool (IC|URC_Exception receiver))
            )
            (or t1 t2)
        )
    )
    
    (defun IC|URC_ZeroGAS:bool (id:string sender:string)
        (let
            (
                (t1:bool (IC|URC_IsVirtualGasZeroAbsolutely id))
                (t2:bool (IC|URC_Exception sender))
            )
            (or t1 t2)
        )
    )
    (defun IC|URC_IsVirtualGasZeroAbsolutely:bool (id:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (t1:bool (IC|URC_IsVirtualGasZero))
                (gas-id:string (ref-DALOS::UR_IgnisID))
                (t2:bool (if (or (= gas-id BAR)(= id gas-id)) true false))
            )
            (or t1 t2)
        )
    )
    (defun IC|URC_IsVirtualGasZero:bool ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (if (ref-DALOS::UR_VirtualToggle)
                false
                true
            )
        ) 
    )
    (defun IC|URC_IsNativeGasZero:bool ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (if (ref-DALOS::UR_NativeToggle)
                false
                true
            )
        )
    )
    ;;{F2}  [UEV]
    (defun IC|UEV_VirtualState (state:bool)
        (let
            (
                (t:bool (UR_VirtualToggle))
            )
            (enforce (= t state) "Invalid virtual gas collection state!")
            (if (not state)
                (IC|UEV_VirtualOnCondition)
                true
            )
        )
    )
    (defun IC|UEV_VirtualOnCondition ()
        (let
            (
                (ouro-id:string (UR_OuroborosID))
                (gas-id:string (UR_IgnisID))
            )
            (enforce (!= ouro-id BAR) "OURO Id must be set for IGNIS Collection to turn ON!")
            (enforce (!= gas-id BAR) "IGNIS Id must be set for IGNIS Collection to turn ON!")
            (enforce (!= gas-id ouro-id) "OURO and IGNIS id must be different for the IGNIS Collection to turn ON!")
        )
    )
    (defun IC|UEV_NativeState (state:bool)
        (let
            (
                (t:bool (UR_NativeToggle))
            )
            (enforce (= t state) "Invalid native gas collection state!")
        )
    )
    (defun IC|UEV_Patron (patron:string)
        @doc "Capability that ensures a DALOS account can act as gas payer, enforcing all necesarry restrictions"
        (if (UR_AccountType patron)
            (do
                (enforce (= patron DALOS|SC_NAME) "Only the DALOS Account can be a Smart Patron")
                (CAP_EnforceAccountOwnership DALOS|SC_NAME)
            )
            (CAP_EnforceAccountOwnership patron)
        )
    )
    ;;{F3}  [UDC]
    (defun UDC_MakeIDP:string (ignis-discount:decimal)
        (format "{}{}" [(* (- 1.0 ignis-discount) 100.0) "%"])
    )
    (defun IC|UDC_ConstructOutputCumulator:object{IgnisCollector.OutputCumulator}
        (price:decimal active-account:string trigger:bool output-lst:list)
        (IC|UDC_MakeOutputCumulator
            [
                (IC|UDC_MakeModularCumulator
                    price
                    active-account
                    trigger
                )
            ]
            output-lst
        )
    )
    (defun IC|UDC_BrandingCumulator:object{IgnisCollector.OutputCumulator}
        (active-account:string multiplier:decimal)
        (IC|UDC_ConstructOutputCumulator
            (* multiplier (UR_UsagePrice "ignis|branding"))
            active-account
            (IC|URC_IsVirtualGasZero)
            []
        )
    )
    (defun IC|UDC_SmallestCumulator:object{IgnisCollector.OutputCumulator}
        (active-account:string)
        (IC|UDC_ConstructOutputCumulator
            (UR_UsagePrice "ignis|smallest")
            active-account
            (IC|URC_IsVirtualGasZero)
            []
        )
    )
    (defun IC|UDC_SmallCumulator:object{IgnisCollector.OutputCumulator}
        (active-account:string)
        (IC|UDC_ConstructOutputCumulator
            (UR_UsagePrice "ignis|small")
            active-account
            (IC|URC_IsVirtualGasZero)
            []
        )
    )
    (defun IC|UDC_MediumCumulator:object{IgnisCollector.OutputCumulator}
        (active-account:string)
        (IC|UDC_ConstructOutputCumulator
            (UR_UsagePrice "ignis|medium")
            active-account
            (IC|URC_IsVirtualGasZero)
            []
        )
    )
    (defun IC|UDC_BigCumulator:object{IgnisCollector.OutputCumulator}
        (active-account:string)
        (IC|UDC_ConstructOutputCumulator
            (UR_UsagePrice "ignis|big")
            active-account
            (IC|URC_IsVirtualGasZero)
            []
        )
    )
    (defun IC|UDC_BiggestCumulator:object{IgnisCollector.OutputCumulator}
        (active-account:string)
        (IC|UDC_ConstructOutputCumulator
            (UR_UsagePrice "ignis|biggest")
            active-account
            (IC|URC_IsVirtualGasZero)
            []
        )
    )
    (defun IC|UDC_CustomCodeCumulator:object{IgnisCollector.OutputCumulator}
        ()
        (IC|UDC_ConstructOutputCumulator
            (* 5.0 (UR_UsagePrice "ignis|biggest"))
            (at 1 (UR_DemiurgoiID))
            (IC|URC_IsVirtualGasZero)
            []
        )
    )
    (defun IC|UDC_MakeModularCumulator:object{IgnisCollector.ModularCumulator}
        (price:decimal active-account:string trigger:bool)
        (let
            (
                (interactor:string
                    (if (UR_AccountType active-account)
                        active-account
                        BAR
                    )
                )
            )
            (if trigger
                {"ignis"        : 0.0
                ,"interactor"   : BAR}
                {"ignis"        : price
                ,"interactor"   : interactor}
            )
        )
    )
    (defun IC|UDC_MakeOutputCumulator:object{IgnisCollector.OutputCumulator}
        (input-modular-cumulator-chain:[object{IgnisCollector.ModularCumulator}] output-lst:list)
        {"cumulator-chain"  : input-modular-cumulator-chain
        ,"output"           : output-lst}
    )
    (defun IC|UDC_ConcatenateOutputCumulators:object{IgnisCollector.OutputCumulator}
        (input-output-cumulator-chain:[object{IgnisCollector.OutputCumulator}] new-output-lst:list)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (folded-obj:[[object{IgnisCollector.ModularCumulator}]]
                    (fold
                        (lambda
                            (acc:[[object{IgnisCollector.ModularCumulator}]] idx:integer)
                            (ref-U|LST::UC_AppL
                                acc
                                (at "cumulator-chain" (at idx input-output-cumulator-chain))
                            )
                        )
                        []
                        (enumerate 0 (- (length input-output-cumulator-chain) 1))
                    )
                )
            )
            {"cumulator-chain"  : (fold (+) [] folded-obj)
            ,"output"           : new-output-lst}
        )
    )
    (defun IC|UDC_CompressOutputCumulator:object{IgnisCollector.CompressedCumulator}
        (input-output-cumulator:object{IgnisCollector.OutputCumulator})
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (cumulator-chain-input:[object{IgnisCollector.ModularCumulator}] 
                    (at "cumulator-chain" input-output-cumulator)
                )
                (folded-obj:[object{IgnisCollector.CompressedCumulator}]
                    (fold
                        (lambda
                            (acc:[object{IgnisCollector.CompressedCumulator}] idx:integer)
                            (ref-U|LST::UC_ReplaceAt
                                acc
                                0
                                (let
                                    (
                                        (read-ignis-price:decimal (at "ignis" (at idx cumulator-chain-input)))
                                        (read-interactor:string (at "interactor" (at idx cumulator-chain-input)))
                                        (interactor-search:[integer] (ref-U|LST::UC_Search (at "interactors" (at 0 acc)) read-interactor))
                                        (iz-new:bool 
                                            (if (= (length interactor-search) 0)
                                                true
                                                false
                                            )
                                        )
                                    )
                                    (if iz-new
                                        {
                                            "ignis-prices"  : (ref-U|LST::UC_AppL (at "ignis-prices" (at 0 acc)) read-ignis-price),
                                            "interactors"   : (ref-U|LST::UC_AppL (at "interactors" (at 0 acc)) read-interactor)
                                        }
                                        (let
                                            (
                                                (interactor-position-in-acc:integer (at 0 interactor-search))
                                                (ignis-amount-in-acc:decimal (at interactor-position-in-acc (at "ignis-prices" (at 0 acc))))
                                                (updated-ignis-amount:decimal (+ read-ignis-price ignis-amount-in-acc))
                                            )
                                            {
                                                "ignis-prices"  : (ref-U|LST::UC_ReplaceAt (at "ignis-prices" (at 0 acc)) interactor-position-in-acc updated-ignis-amount),
                                                "interactors"   : (at "interactors" (at 0 acc))
                                            }
                                        )
                                    )
                                )
                            )
                        )
                        EMPTY_CC
                        (enumerate 0 (- (length cumulator-chain-input) 1))
                    )
                )
            )
            (at 0 folded-obj)
        )
    )
    (defun IC|UDC_PrimeIgnisCumulator:object{IgnisCollector.PrimedCumulator}
        (patron:string input:object{IgnisCollector.CompressedCumulator})
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (fll:integer (length (at "ignis-prices" input)))
                (ignis-discount:decimal (URC_IgnisGasDiscount patron))
                (folded-obj:[object{IgnisCollector.CompressedCumulator}]
                    (fold
                        (lambda
                            (acc:[object{IgnisCollector.CompressedCumulator}] idx:integer)
                            (ref-U|LST::UC_ReplaceAt
                                acc
                                0
                                (let
                                    (
                                        (input-ignis-price:decimal (at idx (at "ignis-prices" input)))
                                        (input-ignis-price-discounted:decimal (* input-ignis-price ignis-discount))
                                        (input-interactor:string (at idx (at "interactors" input)))
                                        (iz-interactor-principal:bool
                                            (if (= input-interactor BAR)
                                                true
                                                false
                                            )
                                        )
                                        (smart-ignis-amount:decimal
                                            (if iz-interactor-principal
                                                0.0
                                                (* GAS_QUARTER input-ignis-price-discounted)
                                            )
                                        )
                                        (prime-ignis-amount:decimal (- input-ignis-price-discounted smart-ignis-amount))
                                        ;;
                                        (principal-interactor-search:[integer] (ref-U|LST::UC_Search (at "interactors" (at 0 acc)) BAR))
                                        (principal-interactor-exists:bool 
                                            (if (= (length principal-interactor-search) 0)
                                                false
                                                true
                                            )
                                        )
                                    )
                                    (if principal-interactor-exists
                                        ;;Wen principal interactor already exists
                                        (let
                                            (
                                                (principal-interactor-position:integer (at 0 principal-interactor-search))
                                                (principal-interactor-current-ignis-amount:decimal (at principal-interactor-position (at "ignis-prices" (at 0 acc))))
                                                (updated-interactor-ignis-amount:decimal (+ principal-interactor-current-ignis-amount prime-ignis-amount))
                                            )
                                            (if iz-interactor-principal
                                                ;;Wen interactor is principal
                                                {
                                                    "ignis-prices"  : (ref-U|LST::UC_ReplaceAt (at "ignis-prices" (at 0 acc)) principal-interactor-position updated-interactor-ignis-amount),
                                                    "interactors"   : (ref-U|LST::UC_AppL (at "interactors" (at 0 acc)) input-interactor)
                                                }
                                                ;;Wen interactor is not principal
                                                {
                                                    "ignis-prices"  : (ref-U|LST::UC_AppL (ref-U|LST::UC_ReplaceAt (at "ignis-prices" (at 0 acc)) principal-interactor-position updated-interactor-ignis-amount) smart-ignis-amount),
                                                    "interactors"   : (ref-U|LST::UC_AppL (at "interactors" (at 0 acc)) input-interactor)
                                                }
                                            )
                                        )
                                        ;;Wen principal interactor doesnt exit yet
                                        (if iz-interactor-principal
                                            ;;Wen interactor is principal
                                            {
                                                "ignis-prices"  : (ref-U|LST::UC_AppL (at "ignis-prices" (at 0 acc)) prime-ignis-amount),
                                                "interactors"   : (ref-U|LST::UC_AppL (at "interactors" (at 0 acc)) input-interactor)
                                            }
                                            ;;Wen interactor is not principal
                                            {
                                                "ignis-prices"  : (ref-U|LST::UC_AppL (ref-U|LST::UC_AppL (at "ignis-prices" (at 0 acc)) prime-ignis-amount) smart-ignis-amount),
                                                "interactors"   : (ref-U|LST::UC_AppL (ref-U|LST::UC_AppL (at "interactors" (at 0 acc)) BAR) input-interactor)
                                            }
                                        )
                                    )
                                )
                            )
                        )
                        EMPTY_CC
                        (enumerate 0 (- fll 1))
                    )
                )
            )
            {"primed-cumulator" : (at 0 folded-obj)}
        )
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_TransferDalosFuel (sender:string receiver:string amount:decimal)
        (let
            (
                (ref-coin:module{fungible-v2} coin)
            )
            (ref-coin::transfer sender receiver amount)
        )
    )
    (defun IC|C_Collect
        (patron:string input-output-cumulator:object{IgnisCollector.OutputCumulator})
        (let
            (
                (compressed-cumulator:object{IgnisCollector.CompressedCumulator}
                    (IC|UDC_CompressOutputCumulator input-output-cumulator)
                )
                (primed-cumulator:object{IgnisCollector.PrimedCumulator}
                    (IC|UDC_PrimeIgnisCumulator patron compressed-cumulator)
                )
                (ignis-prices:[decimal] (at "ignis-prices" (at "primed-cumulator" primed-cumulator)))
                (ignis-sum:decimal (fold (+) 0.0 ignis-prices))
                (iz-gassles-patron:bool (UR_AccountType patron))
            )
            (if (and (!= ignis-sum 0.0) (not iz-gassles-patron))
                (with-capability (IGNIS|C>DC patron)
                    (let
                        (
                            (icl:integer (length ignis-prices))
                            (primed-collector:object{IgnisCollector.CompressedCumulator} 
                                (at "primed-cumulator" primed-cumulator)
                            )
                        )
                        (map
                            (lambda
                                (idx:integer)
                                (let
                                    (
                                        (interactor:string (at idx (at "interactors" primed-collector)))
                                        (amount:decimal (at idx (at "ignis-prices" primed-collector)))
                                    )
                                    (with-capability (IGNIS|C>COLLECT patron interactor amount)
                                        (XI_IgnisCollector patron interactor amount)
                                    )
                                )
                            )
                            (enumerate 0 (- icl 1))
                        )
                        (with-read DALOS|AccountTable patron
                            { "nonce" := n }
                            (update DALOS|AccountTable patron { "nonce" : (+ n 1)})
                        )
                    )
                )
                (with-capability (IGNIS|S>FREE)
                    true
                )
            )
        )
    )
    (defun KDA|C_Collect (sender:string amount:decimal)
        (KDA|C_CollectWT sender amount (IC|URC_IsNativeGasZero))
    )
    (defun KDA|C_CollectWT (sender:string amount:decimal trigger:bool)
        (let
            (
                (split-discounted-kda:[decimal] (URC_SplitKDAPrices sender amount))
                (am0:decimal (at 0 split-discounted-kda))
                (am1:decimal (at 1 split-discounted-kda))
                (am2:decimal (at 2 split-discounted-kda))
                (am3:decimal (at 3 split-discounted-kda))
                (kda-sender:string (UR_AccountKadena sender))
                (demiurgoi:[string] (UR_DemiurgoiID))
                (kda-cto:string (UR_AccountKadena (at 1 demiurgoi)))
                (kda-hov:string (UR_AccountKadena (at 2 demiurgoi)))
                (kda-ouroboros:string (UR_AccountKadena (GOV|OUROBOROS|SC_NAME)))
                (kda-dalos:string (UR_AccountKadena DALOS|SC_NAME))
            )
            (if (not trigger)
                (do
                    (C_TransferDalosFuel kda-sender kda-hov am0)          ;;10% to Demiourgos.Holdings
                    (C_TransferDalosFuel kda-sender kda-cto am2)          ;;30% to Ouronet Maintenance
                    (C_TransferDalosFuel kda-sender kda-ouroboros am3)    ;;40% to KDA-Ouroboros (as Pitstop for LiquidKadenaIndex fueling)
                    (C_TransferDalosFuel kda-sender kda-dalos am1)        ;;20% to KDA-Dalos (Ouronet Gas Station)
                )
                (format "While Kadena Collection is {}, the {} KDA could not be collected" [trigger amount])
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)