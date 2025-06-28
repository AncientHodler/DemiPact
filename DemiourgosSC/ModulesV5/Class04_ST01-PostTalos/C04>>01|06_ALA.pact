(interface AutonomicLiquidityAdder
    (defun UC_CDP:decimal (current-price:decimal wanted-price:decimal dayz:integer))
    (defun UC_ComputeDailyBoostPromile:decimal (starting-price:decimal ending-price:decimal))
    
    ;;
    (defun URC_DepletionOverpletion:[decimal] (swpair:string))
    (defun URC_ExtraValueNeeded (daily-promille:decimal))
    (defun URC_ValueToKadenaz:[decimal] (value:decimal))
)
(module ALA GOV
    ;;
    (implements OuronetPolicy)
    (implements AutonomicLiquidityAdder)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_ALA                    (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|ALA_ADMIN)))
    (defcap GOV|ALA_ADMIN ()                (enforce-guard GOV|MD_ALA))
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
    (defcap P|ALA|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|ALA|CALLER))
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
        (with-capability (GOV|ALA_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|ALA_ADMIN)
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
                (mg:guard (create-capability-guard (P|ALA|CALLER)))
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
    (defschema ALA|PropertiesSchema
        daily-boost-promile:decimal
    )
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
    ;;{C3}
    ;;{C4}
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_CDP:decimal (current-price:decimal wanted-price:decimal dayz:integer)
        (floor (* (- (^ (/ wanted-price current-price) (/ 1.0 (dec dayz))) 1.0) 1000.0) 12)
    )
    (defun UC_ComputeDailyBoostPromile:decimal (starting-price:decimal ending-price:decimal)
        (UC_CDP starting-price ending-price 365)
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun URC_DepletionOverpletion:[decimal] (swpair:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|VST:module{UtilityVst} U|VST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-SWP:module{SwapperV4} SWP)
                (ref-DSP:module{DeployerDispenserV6} DSP)
                ;;
                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                (pool-type:string (ref-U|SWP::UC_PoolType swpair))
                (pts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (pt-ids:[string] (ref-SWP::UR_PoolTokens swpair))
                (w:[decimal] (ref-SWP::UR_Weigths swpair))
                (ew:[decimal] (ref-U|VST::UC_SplitBalanceForVesting 4 1.0 (length pts)))
                (uw:[decimal]
                    (if (or (= pool-type "S") (= pool-type "P"))
                        ew w
                    )
                )
                (pt-pid:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                (if (= (at idx pt-ids) ouro-id)
                                    (ref-DSP::URC_OuroPrimordialPrice)
                                    (ref-DSP::URC_TokenDollarPrice (at idx pt-ids))
                                )
                            )
                        )
                        []
                        (enumerate 0 (- (length pt-ids) 1))
                    )
                )
                (pts-pid:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                (floor (* (at idx pts) (at idx pt-pid)) 24)
                            )
                        )
                        []
                        (enumerate 0 (- (length pt-ids) 1))
                    )
                )
                (pool-value:decimal (fold (+) 0.0 pts-pid))
                (expected-pts-pid:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                (floor (* pool-value (at idx uw)) 24)
                            )
                        )
                        []
                        (enumerate 0 (- (length pt-ids) 1))
                    )
                )
            )
            (fold
                (lambda
                    (acc:[decimal] idx:integer)
                    (ref-U|LST::UC_AppL acc
                        (dec (floor (- (at idx pts-pid) (at idx expected-pts-pid))))
                    )
                )
                []
                (enumerate 0 (- (length pts-pid) 1))
            )
            ;(zip (-) pts-pid expected-pts-pid)
        )
    )
    (defun URC_ExtraValueNeeded (daily-promille:decimal)
        (let
            (
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPI:module{SwapperIssueV2} SWPI)
                ;;
                ;;
                (primordial:string (ref-SWP::UR_PrimordialPool))
                (pts:[decimal] (ref-SWP::UR_PoolTokenSupplies primordial))
                (ouro-supply:decimal (at 1 pts))
                ;;
                (ouro-price:decimal (ref-SWPI::URC_OuroPrimordialPrice))
            )
            (floor (fold (*) 1.0 [(/ daily-promille 1000.0) ouro-price ouro-supply]) 24)
        )
    )
    (defun URC_ValueToKadenaz:[decimal] (value:decimal)
        (let
            (
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-ATS:module{AutostakeV4} ATS)
                ;;
                (prec:integer 24)
                (lkda:string (ref-DALOS::UR_LiquidKadenaID))
                (lq-index:string (at 0 (ref-DPTF::UR_RewardBearingToken lkda)))
                (lq-index-value:decimal (ref-ATS::URC_Index lq-index))
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                ;;
                (wkda-value:decimal (floor (/ value kda-pid) prec))
                (half-one:decimal (floor (/ wkda-value 2.0) prec))
                (half-two:decimal (- wkda-value half-one))
                ;;
                (lkda-value:decimal (floor (/ half-one lq-index-value) prec))
            )
            [lkda-value half-two]
        )
    )
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)