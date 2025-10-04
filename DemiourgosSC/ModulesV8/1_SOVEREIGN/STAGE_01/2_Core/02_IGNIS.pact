
(module IGNIS GOV
    ;;
    (implements OuronetPolicy)
    (implements IgnisCollectorV2)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_IGNIS                  (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|IGNIS_ADMIN)))
    (defcap GOV|IGNIS_ADMIN ()              (enforce-guard GOV|MD_IGNIS))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::P|Info)))
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
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (mg:guard (create-capability-guard (P|IGNIS|CALLER)))
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
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                        (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                           (CT_Bar))
    ;;
    (defconst DALOS|SC_NAME                 (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|DALOS|SC_NAME)))
    (defconst OUROBOROS|SC_NAME             (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|OUROBOROS|SC_NAME)))
    (defconst GAS_QUARTER 0.25)
    (defconst GAS_EXCEPTION
        [
            DALOS|SC_NAME
            OUROBOROS|SC_NAME
        ]
    )
    (defun DALOS|EmptyOutputCumulatorV2:object{IgnisCollectorV2.OutputCumulator} ()
        {"cumulator-chain"      :
            [
                {"ignis"        : 0.0
                ,"interactor"   : BAR}
            ]
        ,"output"               : []}
    )
    (defconst EMPTY_CC
        [
            {
                "ignis-prices" : [],
                "interactors" : []
            }
        ]
    )
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap SECURE ()
        true
    )
    (defcap IGNIS|S>DISCOUNT (patron:string idp:string)
        @event
        true
    )
    (defcap IGNIS|S>FREE ()
        @event
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap IGNIS|C>DC (patron:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (compose-capability (IGNIS|S>DISCOUNT patron (UDC_MakeIDP (ref-DALOS::URC_IgnisGasDiscount patron))))
            (compose-capability (P|IGNIS|CALLER))
        )
    )
    (defcap IGNIS|C>COLLECT (patron:string interactor:string amount:decimal)
        @event
        (UEV_Patron patron)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (first:string (take 1 interactor))
                (sigma:string "Σ")
                (tanker:string (ref-DALOS::UR_Tanker))
            )
            (enforce-one
                "Invalid Interactor"
                [
                    (enforce (= interactor BAR) "Interactor is invalid")
                    (enforce (= first sigma) "Invalid Smart Account as interactor")
                ]
            )
            (if (= interactor BAR)
                (compose-capability (IGNIS|C>TRANSFER patron tanker amount))
                (compose-capability (IGNIS|C>TRANSFER patron interactor amount))
            )
            (compose-capability (P|IGNIS|CALLER))
        )
    )
    (defcap IGNIS|C>TRANSFER (sender:string receiver:string ta:decimal)
        (enforce (!= sender receiver) "Sender and Receiver must be different")
        (UEV_TwentyFourPrecision ta)
        (enforce (> ta 0.0) "Cannot debit|credit 0.0 or negative GAS amounts")
        (compose-capability (IGNIS|C>DEBIT sender ta))
        (compose-capability (IGNIS|C>CREDIT receiver))
    )
    (defcap IGNIS|C>DEBIT (sender:string ta:decimal)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (read-gas:decimal (ref-DALOS::UR_TF_AccountSupply sender false))
            )
            (enforce (<= ta read-gas) "Insufficient GAS for GAS-Debiting")
            (ref-DALOS::UEV_EnforceAccountExists sender)
            (ref-DALOS::UEV_EnforceAccountType sender false)
            (compose-capability (SECURE))
        )
    )
    (defcap IGNIS|C>CREDIT (receiver:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::UEV_EnforceAccountExists receiver)
            (compose-capability (SECURE))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun URC_Exception (account:string)
        (contains account GAS_EXCEPTION)
    )
    (defun URC_ZeroEliteGAZ (sender:string receiver:string)
        (let
            (
                (t1:bool (URC_Exception sender))
                (t2:bool (URC_Exception receiver))
            )
            (or t1 t2)
        )
    )
    (defun URC_ZeroGAZ:bool (id:string sender:string receiver:string)
        (let
            (
                (t1:bool (URC_ZeroGAS id sender))
                (t2:bool (URC_Exception receiver))
            )
            (or t1 t2)
        )
    )
    (defun URC_ZeroGAS:bool (id:string sender:string)
        (let
            (
                (t1:bool (URC_IsVirtualGasZeroAbsolutely id))
                (t2:bool (URC_Exception sender))
            )
            (or t1 t2)
        )
    )
    (defun URC_IsVirtualGasZeroAbsolutely:bool (id:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (t1:bool (URC_IsVirtualGasZero))
                (gas-id:string (ref-DALOS::UR_IgnisID))
                (t2:bool (if (or (= gas-id BAR)(= id gas-id)) true false))
            )
            (or t1 t2)
        )
    )
    (defun URC_IsVirtualGasZero:bool ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (if (ref-DALOS::UR_VirtualToggle)
                false
                true
            )
        ) 
    )
    (defun URC_IsNativeGasZero:bool ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (if (ref-DALOS::UR_NativeToggle)
                false
                true
            )
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_TwentyFourPrecision (amount:decimal)
        @doc "Enforces a 24 Precision, for use with IGNIS Token."
        (enforce
            (= (floor amount 24) amount)
            (format "The GAS Amount of {} is not a valid GAS Amount decimal wise" [amount])
        )
    )
    (defun UEV_Patron (patron:string)
        @doc "Capability that ensures a DALOS account can act as gas payer, enforcing all necesarry restrictions"
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (if (ref-DALOS::UR_AccountType patron)
                (do
                    (enforce (= patron DALOS|SC_NAME) "Only the DALOS Account can be a Smart Patron")
                    (ref-DALOS::CAP_EnforceAccountOwnership DALOS|SC_NAME)
                )
                (ref-DALOS::CAP_EnforceAccountOwnership patron)
            )
        )
    )
    ;;{F3}  [UDC]
    (defun UDC_MakeIDP:string (ignis-discount:decimal)
        (format "{}{}" [(* (- 1.0 ignis-discount) 100.0) "%"])
    )
    (defun UDC_ConstructOutputCumulator:object{IgnisCollectorV2.OutputCumulator}
        (price:decimal active-account:string trigger:bool output-lst:list)
        (UDC_MakeOutputCumulator
            [
                (UDC_MakeModularCumulator
                    price
                    active-account
                    trigger
                )
            ]
            output-lst
        )
    )
    (defun UDC_BrandingCumulator:object{IgnisCollectorV2.OutputCumulator}
        (active-account:string multiplier:decimal)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (UDC_ConstructOutputCumulator
                (* multiplier (ref-DALOS::UR_UsagePrice "ignis|branding"))
                active-account
                (URC_IsVirtualGasZero)
                []
            )
        )
    )
    (defun UDC_SmallestCumulator:object{IgnisCollectorV2.OutputCumulator}
        (active-account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (UDC_ConstructOutputCumulator
                (ref-DALOS::UR_UsagePrice "ignis|smallest")
                active-account
                (URC_IsVirtualGasZero)
                []
            )
        )
    )
    (defun UDC_SmallCumulator:object{IgnisCollectorV2.OutputCumulator}
        (active-account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (UDC_ConstructOutputCumulator
                (ref-DALOS::UR_UsagePrice "ignis|small")
                active-account
                (URC_IsVirtualGasZero)
                []
            )
        )
    )
    (defun UDC_MediumCumulator:object{IgnisCollectorV2.OutputCumulator}
        (active-account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (UDC_ConstructOutputCumulator
                (ref-DALOS::UR_UsagePrice "ignis|medium")
                active-account
                (URC_IsVirtualGasZero)
                []
            )
        )
    )
    (defun UDC_BigCumulator:object{IgnisCollectorV2.OutputCumulator}
        (active-account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (UDC_ConstructOutputCumulator
                (ref-DALOS::UR_UsagePrice "ignis|big")
                active-account
                (URC_IsVirtualGasZero)
                []
            )
        )
    )
    (defun UDC_BiggestCumulator:object{IgnisCollectorV2.OutputCumulator}
        (active-account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (UDC_ConstructOutputCumulator
                (ref-DALOS::UR_UsagePrice "ignis|biggest")
                active-account
                (URC_IsVirtualGasZero)
                []
            )
        )
    )
    (defun UDC_CustomCodeCumulator:object{IgnisCollectorV2.OutputCumulator} ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (UDC_ConstructOutputCumulator
                (* 5.0 (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                (at 1 (ref-DALOS::UR_DemiurgoiID))
                (URC_IsVirtualGasZero)
                []
            )
        )
    )
    ;;
    (defun UDC_MakeModularCumulator:object{IgnisCollectorV2.ModularCumulator}
        (price:decimal active-account:string trigger:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (interactor:string
                    (if (ref-DALOS::UR_AccountType active-account)
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
    (defun UDC_MakeOutputCumulator:object{IgnisCollectorV2.OutputCumulator}
        (input-modular-cumulator-chain:[object{IgnisCollectorV2.ModularCumulator}] output-lst:list)
        {"cumulator-chain"  : input-modular-cumulator-chain
        ,"output"           : output-lst}
    )
    (defun UDC_ConcatenateOutputCumulators:object{IgnisCollectorV2.OutputCumulator}
        (input-output-cumulator-chain:[object{IgnisCollectorV2.OutputCumulator}] new-output-lst:list)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (folded-obj:[[object{IgnisCollectorV2.ModularCumulator}]]
                    (fold
                        (lambda
                            (acc:[[object{IgnisCollectorV2.ModularCumulator}]] idx:integer)
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
    (defun UDC_CompressOutputCumulator:object{IgnisCollectorV2.CompressedCumulator}
        (input-output-cumulator:object{IgnisCollectorV2.OutputCumulator})
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (cumulator-chain-input:[object{IgnisCollectorV2.ModularCumulator}] 
                    (at "cumulator-chain" input-output-cumulator)
                )
                (folded-obj:[object{IgnisCollectorV2.CompressedCumulator}]
                    (fold
                        (lambda
                            (acc:[object{IgnisCollectorV2.CompressedCumulator}] idx:integer)
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
    (defun UDC_PrimeIgnisCumulator:object{IgnisCollectorV2.PrimedCumulator}
        (patron:string input:object{IgnisCollectorV2.CompressedCumulator})
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-U|LST:module{StringProcessor} U|LST)
                (fll:integer (length (at "ignis-prices" input)))
                (ignis-discount:decimal (ref-DALOS::URC_IgnisGasDiscount patron))
                (folded-obj:[object{IgnisCollectorV2.CompressedCumulator}]
                    (fold
                        (lambda
                            (acc:[object{IgnisCollectorV2.CompressedCumulator}] idx:integer)
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
    (defun C_Collect
        (patron:string input-output-cumulator:object{IgnisCollectorV2.OutputCumulator})
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (compressed-cumulator:object{IgnisCollectorV2.CompressedCumulator}
                    (UDC_CompressOutputCumulator input-output-cumulator)
                )
                (primed-cumulator:object{IgnisCollectorV2.PrimedCumulator}
                    (UDC_PrimeIgnisCumulator patron compressed-cumulator)
                )
                (ignis-prices:[decimal] (at "ignis-prices" (at "primed-cumulator" primed-cumulator)))
                (ignis-sum:decimal (fold (+) 0.0 ignis-prices))
                (iz-gassles-patron:bool (ref-DALOS::UR_AccountType patron))
            )
            (if (and (!= ignis-sum 0.0) (not iz-gassles-patron))
                (with-capability (IGNIS|C>DC patron)
                    (let
                        (
                            (icl:integer (length ignis-prices))
                            (primed-collector:object{IgnisCollectorV2.CompressedCumulator} 
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
                        (ref-DALOS::XE_IncrementOuronetAccountNonce patron)
                    )
                )
                (with-capability (IGNIS|S>FREE)
                    true
                )
            )
        )
    )
    (defun KDA|C_Collect (sender:string amount:decimal)
        (KDA|C_CollectWT sender amount (URC_IsNativeGasZero))
    )
    (defun KDA|C_CollectWT (sender:string amount:decimal trigger:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (split-discounted-kda:[decimal] (ref-DALOS::URC_SplitKDAPrices sender amount))
                (am0:decimal (at 0 split-discounted-kda))
                (am1:decimal (at 1 split-discounted-kda))
                (am2:decimal (at 2 split-discounted-kda))
                (am3:decimal (at 3 split-discounted-kda))
                (kda-sender:string (ref-DALOS::UR_AccountKadena sender))
                (demiurgoi:[string] (ref-DALOS::UR_DemiurgoiID))
                (kda-cto:string (ref-DALOS::UR_AccountKadena (at 1 demiurgoi)))
                (kda-hov:string (ref-DALOS::UR_AccountKadena (at 2 demiurgoi)))
                (kda-ouroboros:string (ref-DALOS::UR_AccountKadena OUROBOROS|SC_NAME))
                (kda-dalos:string (ref-DALOS::UR_AccountKadena DALOS|SC_NAME))
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
    (defun XI_IgnisCollector (patron:string interactor:string amount:decimal)
        (require-capability (IGNIS|C>COLLECT patron interactor amount))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (collector:string
                    (if (= interactor BAR)
                        (ref-DALOS::UR_Tanker)
                        interactor
                    )
                )
            )
            (ref-DALOS::XE_IgnisIncrement false amount)
            (XI_IgnisTransfer patron collector amount)
        )
    )
    (defun XI_IgnisTransfer (sender:string receiver:string ta:decimal)
        (require-capability (IGNIS|C>TRANSFER sender receiver ta))
        (XI_IgnisDebit sender ta)
        (XI_IgnisCredit receiver ta)
    )
    (defun XI_IgnisDebit (sender:string ta:decimal)
        (require-capability (IGNIS|C>DEBIT sender ta))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::XB_UpdateBalance sender false 
                (- (ref-DALOS::UR_TF_AccountSupply sender false) ta)
            )
        )
    )
    (defun XI_IgnisCredit (receiver:string ta:decimal)
        (require-capability (IGNIS|C>CREDIT receiver))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::XB_UpdateBalance receiver false 
                (+ (ref-DALOS::UR_TF_AccountSupply receiver false) ta)
            )
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)