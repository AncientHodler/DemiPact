(module SWPL GOV
    @doc "Exposes Liquidity Functions"
    ;;
    (implements OuronetPolicy)
    (implements BrandingUsageV7)
    (implements SwapperLiquidity)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_SWPL           (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst SWP|SC_NAME           (GOV|SWP|SC_NAME))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|SWPL_ADMIN)))
    (defcap GOV|SWPL_ADMIN ()       (enforce-guard GOV|MD_SWPL))
    ;;
    (defun GOV|SWP|SC_NAME ()       (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|SWP|SC_NAME)))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|SWPL|CALLER ()
        true
    )
    (defcap P|SWPL|REMOTE-GOV ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|SWPL|CALLER))
        (compose-capability (SECURE))
    )
    (defcap P|DT ()
        (compose-capability (P|SWPL|REMOTE-GOV))
        (compose-capability (P|SWPL|CALLER))
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
        (with-capability (GOV|SWPL_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|SWPL_ADMIN)
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
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|VST:module{OuronetPolicy} VST)
                (ref-P|SWP:module{OuronetPolicy} SWP)
                (mg:guard (create-capability-guard (P|SWPL|CALLER)))
            )
            (ref-P|VST::P|A_Add
                "SWPL|RemoteSwpGov"
                (create-capability-guard (P|SWPL|REMOTE-GOV))
            )
            (ref-P|SWP::P|A_Add
                "SWPL|RemoteSwpGov"
                (create-capability-guard (P|SWPL|REMOTE-GOV))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|DPMF::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|SWP::P|A_AddIMP mg)
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
    (defcap SWPL|S>ASYMMETRIC-LQ-GASEOUS-TAX (text:string)
        @event
        true
    )
    (defcap SWPL|S>ASYMMETRIC-LQ-DEFICIT-TAX (text:string)
        @event
        true
    )
    (defcap SWPL|S>ASYMMETRIC-LQ-FUELING-TAX (text:string)
        @event
        true
    )
    (defcap SWPL|S>ASYMMETRIC-LQ-SPECIAL-TAX (text:string)
        @event
        true
    )
    (defcap SWPL|S>ASYMMETRIC-LQ-LQBOOST-TAX (text:string)
        @event
        true
    )
    (defcap SWPL|S>ADD_ASYMMETRIC-LQ (account:string swpair:string input-amounts:[decimal])
        @event
        true
    )
    (defcap SWPL|S>ADD_BALANCED-LQ (account:string swpair:string input-amounts:[decimal])
        @event
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap SWPL|C>UPDATE-BRD (swpair:string)
        @event
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
            )
            (ref-SWP::CAP_Owner swpair)
            (compose-capability (P|SWPL|CALLER))
        )
    )
    (defcap SWPU|C>UPGRADE-BRD (swpair:string)
        @event
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
            )
            (ref-SWP::CAP_Owner swpair)
            (compose-capability (P|SWPL|CALLER))
        )
    )
    ;;
    (defcap SWPL|C>INDIRECT-FUEL
        (account:string swpair:string id-lst:[string] transfer-amount-lst:[decimal])
        @event
        (compose-capability (P|SWPL|CALLER))
    )
    (defcap SWPL|C>DIRECT-FUEL
        (account:string swpair:string id-lst:[string] transfer-amount-lst:[decimal])
        @event
        (compose-capability (P|DT))
    )
    ;;
    (defcap SWPL|C>ADD-STANDARD-LQ (swpair:string ld:object{SwapperLiquidity.LiquidityData})
        @event
        (compose-capability (SWPL|C>X-ADD-LQ swpair ld))
    )
    (defcap SWPL|C>ADD-ICED-LQ (swpair:string ld:object{SwapperLiquidity.LiquidityData})
        @event
        (compose-capability (SWPL|C-ADD-CHILLED-LQ swpair ld))
    )
    (defcap SWPL|C>ADD-GLACIAL-LQ (swpair:string ld:object{SwapperLiquidity.LiquidityData})
        @event
        (compose-capability (SWPL|C-ADD-CHILLED-LQ swpair ld))
    )
    (defcap SWPL|C>ADD-FROZEN-LQ (swpair:string frozen-dptf:string ld:object{SwapperLiquidity.LiquidityData})
        @event
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (dptf:string (ref-DPTF::UR_Frozen frozen-dptf))
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (iz-frozen-dptf-compatible:bool (contains dptf pool-tokens))
            )
            (enforce iz-frozen-dptf-compatible (format "Frozen-DPTF {} isnt't compatible with Swpair {}" [frozen-dptf swpair]))
            (compose-capability (SWPL|C-ADD-CHILLED-LQ swpair ld))
        )
    )
    (defcap SWPL|C>ADD-SLEEPING-LQ (account:string swpair:string sleeping-dpmf:string nonce:integer ld:object{SwapperLiquidity.LiquidityData})
        @event
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (ref-VST:module{VestingV4} VST)
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (dptf:string (ref-DPMF::UR_Sleeping sleeping-dpmf))
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (iz-sleeping-dpmf-compatible:bool (contains dptf pool-tokens))
            )
            (enforce iz-sleeping-dpmf-compatible (format "Sleeping-DPMF {} isnt't compatible with Swpair {}" [sleeping-dpmf swpair]))
            (ref-DPMF::UEV_NoncesToAccount sleeping-dpmf account [nonce])
            (ref-VST::UEV_StillHasSleeping account sleeping-dpmf nonce)
            (compose-capability (SWPL|C-ADD-DORMANT-LQ swpair ld))
        )
    )
    (defcap SWPL|C-ADD-DORMANT-LQ (swpair:string ld:object{SwapperLiquidity.LiquidityData})
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                (iz-sleeping:bool (ref-SWP::UR_IzSleepingLP swpair))
            )
            (enforce iz-sleeping (format "Sleeping LP Functionality is not enabled on Swpair {}" [swpair]))
            (compose-capability (SWPL|C>X-ADD-LQ swpair ld))
        )
    )
    (defcap SWPL|C-ADD-CHILLED-LQ (swpair:string ld:object{SwapperLiquidity.LiquidityData})
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                (iz-frozen:bool (ref-SWP::UR_IzFrozenLP swpair))
                (iz-asymmetric:bool (at "iz-asymmetric" (at "sorted-lq-type" ld)))
            )
            (enforce iz-asymmetric "Chilled Liquidity can only be added when asymtric liquidity exists")
            (enforce iz-frozen (format "Frozen LP Functionality is not enabled on Swpair {}" [swpair]))
            (compose-capability (SWPL|C>X-ADD-LQ swpair ld))
        )
    )
    (defcap SWPL|C>X-ADD-LQ (swpair:string ld:object{SwapperLiquidity.LiquidityData})
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                (can-add:bool (ref-SWP::UR_CanAdd swpair))
                (read-lp-supply:decimal (ref-SWP::URC_LpCapacity swpair))
                (iz-asymmetric:bool (at "iz-asymmetric" (at "sorted-lq-type" ld)))
                (iz-balanced:bool (at "iz-balanced" (at "sorted-lq-type" ld)))
                (iz-asymmetric-allowed:bool (ref-SWP::UR_Asymetric))
            )
            (if iz-asymmetric
                (enforce iz-asymmetric-allowed "Asymetric Liquidity Addition isn't enabled by an Ouronet Administrator")
                true
            )
            (if (= read-lp-supply 0.0)
                (enforce iz-balanced
                    "Liquidity Addition on an empty Pool must have a Balanced Part present!"
                )
                true
            )
            (enforce can-add (format "Liquidity Adding and Removal isn't enabled on pool {}" [swpair]))
            (compose-capability (P|DT))
            (compose-capability (SECURE))
        )
    )
    ;;
    (defcap SWPL|C>REMOVE_LQ (swpair:string lp-amount:decimal)
        @event
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (can-add:bool (ref-SWP::UR_CanAdd swpair))
                (lp-id:string (ref-SWP::UR_TokenLP swpair))
                (pool-lp-amount:decimal (ref-DPTF::UR_Supply lp-id))
            )
            (ref-DPTF::UEV_Amount lp-id lp-amount)
            (enforce (<= lp-amount pool-lp-amount) (format "{} is an invalid LP Amount for removing Liquidity" [lp-amount]))
            (enforce can-add (format "Liquidity Adding and Removal isn't enabled on pool {}" [swpair]))
            (compose-capability (P|DT))
            (compose-capability (SECURE))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_DetermineLiquidity:object{SwapperLiquidity.LiquiditySplitType}
        (input-lqs:object{SwapperLiquidity.LiquiditySplit})
        (UDC_LiquiditySplitType
            (!= (at "balanced" input-lqs) (make-list (length (at "balanced" input-lqs)) 0.0))
            (!= (at "asymmetric" input-lqs) (make-list (length (at "asymmetric" input-lqs)) 0.0))
        )
    )
    ;;
    
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun URC|KDA-PID:decimal ()
        ;;(at "value" (n_bfb76eab37bf8c84359d6552a1d96a309e030b71.dia-oracle.get-value "KDA/USD"))
        1.0
    )
    (defun URC|KDA-PID_LpToIgnis:decimal (swpair:string amount:decimal kda-pid:decimal)
        (let
            (
                (ref-SWPI:module{SwapperIssue} SWPI)
                ;;
                (ignis-prec:integer (URC_IgnisPrecision))
                (pool-value:[decimal] (ref-SWPI::URC_PoolValue swpair))
                (lp-value-in-dwk:decimal (at 1 pool-value))
            )
            (floor (fold (*) 1.0 [amount lp-value-in-dwk kda-pid]) 2)
        )
    )
    (defun URC|KDA-PID_TokenToIgnis (id:string amount:decimal kda-pid:decimal)
        (let
            (
                (ref-SWPI:module{SwapperIssue} SWPI)
                ;;
                (ignis-prec:integer (URC_IgnisPrecision))
                (a-price:decimal (ref-SWPI::URC_TokenDollarPrice id kda-pid))
            )
            (floor (fold (*) 1.0 [100.0 a-price amount]) ignis-prec)
        )
    )
    (defun URC|KDA-PID_CompleteLiquidityAdditionData:object{SwapperLiquidity.CompleteLiquidityAdditionData}
        (
            account:string swpair:string ld:object{SwapperLiquidity.LiquidityData} 
            asymmetric-collection:bool gaseous-collection:bool kda-pid:decimal
        )
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (iz-asymmetric:bool (at "iz-asymmetric" (at "sorted-lq-type" ld)))
                (balanced-liquidity:[decimal] (at "balanced" (at "sorted-lq" ld)))
                (asymmetric-liquidity:[decimal] (at "asymmetric" (at "sorted-lq" ld)))
                (total-input-liquidity:[decimal] (zip (+) balanced-liquidity asymmetric-liquidity))
                ;;
                (balanced-lp-amount:decimal (at "balanced" ld))
                ;;
                ;;General Variables
                (pt-ids:[string] (ref-SWP::UR_PoolTokens swpair))
            )
            (if iz-asymmetric
                (let
                    (
                        (asymmetric-lp-amount:decimal (at "asymmetric" ld))
                        (asymmetric-lp-fee-amount:decimal (at "asymmetric-fee" ld))
                        (asymmetric-deviation:decimal (UEV_Liquidity swpair ld))
                        (computed-gaseous-fee:decimal (URC|KDA-PID_LpToIgnis swpair asymmetric-lp-fee-amount kda-pid))
                        (raw-gaseous-fee:decimal
                            (if (< computed-gaseous-fee 10.0)
                                10.0
                                (dec (ceiling computed-gaseous-fee))
                            )
                        )
                        (gaseous-ignis-fee:decimal
                            (if gaseous-collection
                                raw-gaseous-fee
                                0.0
                            )
                        )
                        (gaseous-text:string
                            (format "~{} LP out of a total ~{} Asym-LP, covered by {} IGNIS (as GAS), as Asym-Liq.-Fee"
                                [(floor asymmetric-lp-fee-amount 4) (floor asymmetric-lp-amount 4) gaseous-ignis-fee]
                            )
                        )
                    )
                    (if asymmetric-collection
                        ;;Asymmetric Liquidity With Asymetric TAX Collection
                        (let
                            (
                                ;;Compute Asymetric Tax
                                (asymmetric-tax:object{SwapperLiquidity.AsymmetricTax} (URC_AsymmetricTax account swpair ld))
                                ;;
                                (a-id:string (at 0 pt-ids))
                                (a-prec:integer (ref-DPTF::UR_Decimals a-id))
                                ;;
                                ;;<ASYMMETRIC-LQ-DEFICIT-TAX>
                                (tad-diff-fillup:decimal (+ asymmetric-deviation 0.5))
                                (tad-diff:decimal (at "tad-diff" asymmetric-tax))
                                (tad-diff-fillup-as-a:decimal (floor (* tad-diff tad-diff-fillup) a-prec))
                                (raw-deficit-ignis-tax:decimal (URC|KDA-PID_TokenToIgnis a-id tad-diff-fillup-as-a kda-pid))
                                (deficit-ignis-tax:decimal
                                    (if (< raw-deficit-ignis-tax 100.0)
                                        100.0 (ceiling raw-deficit-ignis-tax 2)
                                    )
                                )
                                ;;
                                ;;ASYMMETRIC-LQ-FUELING-TAX
                                (relinquish-lp:decimal (at "fuel-to-lp" asymmetric-tax))
                                ;;
                                ;;ASYMMETRIC-LQ-SPECIAL-TAX
                                (special-as-a:decimal (at "special" asymmetric-tax))
                                (raw-special-ignis-tax:decimal (URC|KDA-PID_TokenToIgnis a-id special-as-a kda-pid))
                                (special-ignis-tax:decimal
                                    (if (< raw-special-ignis-tax 50.0)
                                        50.0 (ceiling raw-special-ignis-tax 2)
                                    )
                                )
                                ;;
                                ;;ASYMMETRIC-LQ-LQBOOST-TAX
                                (boost-as-a:decimal (at "special" asymmetric-tax))
                                (raw-lqboost-ignis-tax:decimal (URC|KDA-PID_TokenToIgnis a-id boost-as-a kda-pid))
                                (lqboost-ignis-tax:decimal
                                    (if (< raw-lqboost-ignis-tax 1.0)
                                        50.0 (dec (ceiling raw-lqboost-ignis-tax))
                                    )
                                )
                            )
                            (UDC_CompleteLiquidityAdditionData
                                total-input-liquidity
                                balanced-liquidity
                                asymmetric-liquidity
                                asymmetric-deviation
                                ;;
                                (- (+ balanced-lp-amount asymmetric-lp-amount) relinquish-lp)
                                0.0
                                ;;
                                (fold (+) 0.0 [deficit-ignis-tax special-ignis-tax lqboost-ignis-tax])
                                ;;
                                gaseous-ignis-fee
                                deficit-ignis-tax
                                special-ignis-tax
                                lqboost-ignis-tax
                                relinquish-lp
                                ;;
                                gaseous-text
                                (format "{} IGNIS costs for a Deviation of ~{}%, as Asym-Liq.-Deficit-Tax}"
                                    [deficit-ignis-tax (floor (* 100.0 asymmetric-deviation) 4)]
                                )
                                (format "{} IGNIS credited to Special Targets, as Asym-Liq.-Special-Tax"
                                    [special-ignis-tax]
                                )
                                (format "{} IGNIS fueling LKDA LiquidIndex, as Asym-Liq.LqBoost-Tax"
                                    [lqboost-ignis-tax]
                                )
                                (format "Relinquish ~{} LP increasing LP Value, as Asym-Liq.-Fueling-Tax"
                                    [(floor relinquish-lp 4)]
                                )
                            )
                        )
                        ;;Asymmetric Liquidity Without Asymetric TAX Collection
                        (UDC_CompleteLiquidityAdditionData
                            total-input-liquidity
                            balanced-liquidity
                            asymmetric-liquidity
                            asymmetric-deviation
                            ;;
                            (if gaseous-collection
                                (+ balanced-lp-amount asymmetric-lp-fee-amount)
                                balanced-lp-amount
                            )
                            (if gaseous-collection
                                (- asymmetric-lp-amount asymmetric-lp-fee-amount)
                                asymmetric-lp-amount
                            )
                            ;;
                            0.0
                            ;;
                            gaseous-ignis-fee
                            0.0
                            0.0
                            0.0
                            0.0
                            ;;
                            (if gaseous-collection
                                gaseous-text
                                (format "Credited ~{} LP out of a total ~{} Asym-LP, with no IGNIS Asym-Liq.-Fee"
                                    [(floor asymmetric-lp-fee-amount 4) (floor asymmetric-lp-amount 4)]
                                )
                            )
                            (format "Asymmetric Deviation ~{}%: no Asym-Liq.-Deficit-Tax"
                                [(floor (* 100.0 asymmetric-deviation) 4)]
                            )
                            "Without Asym-Liq.-Special-Tax"
                            "Without Asym-Liq.-LqBoost-Tax"
                            "Without Asym-Liq.-Fueling-Tax"
                        )
                    )
                )
                (UDC_CompleteLiquidityAdditionData
                    total-input-liquidity
                    balanced-liquidity
                    asymmetric-liquidity
                    0.0
                    ;;
                    balanced-lp-amount
                    0.0
                    ;;
                    0.0
                    ;;
                    0.0
                    0.0
                    0.0
                    0.0
                    0.0
                    ;;
                    (format "Balanced-Liquidity, ({} IGNIS as Asym-Liq.-Fee)" [0.0])
                    (format "Balanced-Liquidity, ({} IGNIS as Asym-Liq.-Deficit-Tax)" [0.0])
                    (format "Balanced-Liquidity, ({} IGNIS as Asym-Liq.-Special-Tax)" [0.0])
                    (format "Balanced-Liquidity, ({} IGNIS as Asym-Liq.-LqBoost-Tax)" [0.0])
                    (format "Balanced-Liquidity, ({} LP relinquished as Asym-Liq.-Fueling-Tax)" [0.0])
                )
            )
        )
    )
    (defun URC_TokenPrecision (id:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
            )
            (ref-DPTF::UR_Decimals id)
        )
    )
    (defun URC_IgnisPrecision ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (URC_TokenPrecision (ref-DALOS::UR_IgnisID))
        )
    )
    ;;
    (defun URC_EntityPosToID:string (swpair:string entity-pos:integer)
        @doc "For the LP Branding Functions"
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-SWP:module{SwapperV4} SWP)
            )
            (ref-U|INT::UEV_PositionalVariable entity-pos 3 "Invalid entity position")
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (lp-id:string (ref-SWP::UR_TokenLP swpair))
                )
                (if (= entity-pos 1)
                    lp-id
                    (if (= entity-pos 2)
                        (ref-DPTF::UR_Frozen lp-id)
                        (ref-DPTF::UR_Sleeping lp-id)
                    )
                )
            )
        )
    )
    ;;
    (defun URC_Liquidity:object{SwapperLiquidity.LiquidityData} (swpair:string input-amounts:[decimal])
        @doc "Computes the LP amounts, valid for all 3 pool types, outputing a TripleLP object containing: \
        \ 1st Value: A Liquidity Split Object, containing the Liquidity Split \
        \ 2nd Value: The Type of Liquidity existing in the input \
        \ 3rd Value: LP for the Balanced Part \
        \ 4th Value: Full LP for the asymmetric Part \
        \ 5th Value: LP Amount as Liquidity Fee for the asymmetric Part"
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (sorted-lq:object{SwapperLiquidity.LiquiditySplit} (URC_SortLiquidity swpair input-amounts))
                (sorted-lq-type:object{SwapperLiquidity.LiquiditySplitType} (UC_DetermineLiquidity sorted-lq))
                (balanced-lq:[decimal] (at "balanced" sorted-lq))
                (asymmetric-lq:[decimal] (at "asymmetric" sorted-lq))
                (iz-balanced:bool (at "iz-balanced" sorted-lq-type))
                (iz-asymmetric:bool (at "iz-asymmetric" sorted-lq-type))
                ;;
                (current-lp-supply:decimal (ref-SWP::URC_LpCapacity swpair))
                (lp-supply:decimal
                    (if (= current-lp-supply 0.0)
                        10000000.0
                        current-lp-supply
                    )
                )
                (pool-token-supplies:[decimal]
                    (if (= current-lp-supply 0.0)
                        (ref-SWP::UR_PoolGenesisSupplies swpair)
                        (ref-SWP::UR_PoolTokenSupplies swpair)
                    )
                )
                (lcd:object{SwapperLiquidity.LiquidityComputationData}
                    (UDC_LiquidityComputationData
                        (length input-amounts)
                        (ref-U|SWP::UC_PoolType swpair)
                        (ref-DPTF::UR_Decimals (ref-SWP::UR_TokenLP swpair))
                        current-lp-supply
                        lp-supply
                        pool-token-supplies
                    )
                )
                ;;Balanced Liq Computation
                (x:decimal 
                    (if iz-balanced
                        (URCX_BalancedLP lcd balanced-lq)
                        0.0
                    )
                )
                ;;asymmetric Liq Computation
                (y-with-z:[decimal]
                    (if iz-asymmetric
                        (let
                            (
                                (asymmetric-lp:[decimal] (URCX_AsymmetricLP swpair asymmetric-lq lcd))
                                (full-lp:decimal (at 0 asymmetric-lp))
                                (taxd-lp:decimal (at 1 asymmetric-lp))
                            )
                            [full-lp (- full-lp taxd-lp)]
                        )
                        [0.0 0.0]
                    )
                )
            )
            (UDC_LiquidityData
                sorted-lq
                sorted-lq-type
                x
                (at 0 y-with-z)
                (at 1 y-with-z)
            )
        )
    )
    (defun URCX_BalancedLP:decimal (lcd:object{SwapperLiquidity.LiquidityComputationData} balanced-lq:[decimal])
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
            )
            (ref-U|SWP::UC_LP 
                balanced-lq 
                (at "pool-token-supplies" lcd)
                (at "lp-supply" lcd)
                (at "lp-prec" lcd)
            )
        )
    )
    (defun URCX_AsymmetricLP:[decimal] (swpair:string asymmetric-lq:[decimal] lcd:object{SwapperLiquidity.LiquidityComputationData})
        @doc "Computes the Full LP (at 0) and Reduced LP (at 1) from Liquidity Fee for asymmetric-liquidity"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|VST:module{UtilityVst} U|VST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (li:integer (at "li" lcd))
                (pool-type:string (at "pool-type" lcd))
                (lp-prec:integer (at "lp-prec" lcd))
                (current-lp-supply:decimal (at "current-lp-supply" lcd))
                (lp-supply:decimal (at "lp-supply" lcd))
                (pool-token-supplies:[decimal] (at "pool-token-supplies" lcd))
                ;;
                ;;Compute Full LP for asymmetric Liq
                (percent-lst:[decimal]
                    (if (= pool-type "W")
                        (if (= current-lp-supply 0.0)
                            (ref-SWP::UR_GenesisWeigths swpair)
                            (ref-SWP::UR_Weigths swpair)
                        )
                        (ref-U|VST::UC_SplitBalanceForVesting 24 1.0 li)
                    )
                )
                (lp-amounts:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (ref-U|LST::UC_AppL 
                                acc 
                                (floor 
                                    (fold (*) 1.0 [(/ (at idx asymmetric-lq) (at idx pool-token-supplies)) (at idx percent-lst) lp-supply]) 
                                    lp-prec
                                )
                            )
                        )
                        []
                        (enumerate 0 (- li 1))
                    )
                )
                (full-asymmetric-lp:decimal (fold (+) 0.0 lp-amounts))
                ;;Compute Taxed LP for asymmetric Liq
                (liquidity-fee:decimal (/ (ref-SWP::URC_LiquidityFee swpair) 1000.0))
                (amp:decimal (ref-SWP::UR_Amplifier swpair))
                (new-balances:[decimal] (zip (+) pool-token-supplies asymmetric-lq))
                (d0:decimal
                    (if (= pool-type "S")
                        (ref-U|SWP::UC_ComputeD amp pool-token-supplies)
                        5040000.0
                    )
                )
                (d1:decimal
                    (if (= pool-type "S")
                        (ref-U|SWP::UC_ComputeD amp new-balances)
                        (+ 5040000.0 (URCXX_D1forWP swpair pool-token-supplies asymmetric-lq))
                    )
                )
                (dr:decimal (floor (/ d0 d1) 24))
                (Xp:[integer] (ref-SWP::UR_PoolTokenPrecisions swpair))
                (adjusted-balances:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (ref-U|LST::UC_AppL
                                acc
                                (- 
                                    (at idx new-balances) 
                                    (floor 
                                        (* 
                                            (abs 
                                                (- 
                                                    (at idx new-balances) 
                                                    (floor 
                                                        (* 
                                                            (at idx pool-token-supplies)
                                                            dr
                                                        ) 
                                                        (at idx Xp)
                                                    )
                                                )
                                            )
                                            liquidity-fee
                                        )
                                        (at idx Xp)
                                    )
                                )
                            )
                        )
                        []
                        (enumerate 0 (- li 1))
                    )
                )
                (taxed-asymmetric-lp:decimal
                    (floor 
                        (/ 
                            (* 
                                (-
                                    (if (= pool-type "S")
                                        (ref-U|SWP::UC_ComputeD amp adjusted-balances) 
                                        (URCXX_D1forWP swpair pool-token-supplies adjusted-balances)
                                    )
                                    d0
                                ) 
                                lp-supply
                            ) 
                            d0
                        ) 
                        lp-prec
                    )
                )
            )
            [full-asymmetric-lp taxed-asymmetric-lp]
        )
    )
    (defun URCXX_D1forWP:decimal (swpair:string current:[decimal] input:[decimal])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWP:module{SwapperV4} SWP)
                (pool-type:string (ref-U|SWP::UC_PoolType swpair))
                (how-many:decimal (dec (length current)))
                (weigths:[decimal] (ref-SWP::UR_Weigths swpair))
                (vpt:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (ref-U|LST::UC_AppL 
                                acc 
                                (floor 
                                    (/ 
                                        (if (= pool-type "P")
                                            (/ 5040000.0 how-many)
                                            (* 5040000.0 (at idx weigths))
                                        )
                                        (at idx current)
                                    ) 
                                    24
                                )
                            )
                        )
                        []
                        (enumerate 0 (- (length current) 1))
                    )
                )
                (input-values:[decimal] (zip (lambda (x:decimal y:decimal) (* x y)) input vpt))
            )
            (fold (+) 0.0 input-values)
        )
    )
    (defun URC_AsymmetricTax:object{SwapperLiquidity.AsymmetricTax}
        (account:string swpair:string ld:object{SwapperLiquidity.LiquidityData})
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPI:module{SwapperIssue} SWPI)
                ;;
                ;;Unwrap Object Data
                (iz-balanced:bool (at "iz-balanced" (at "sorted-lq-type" ld)))
                (iz-asymmetric:bool (at "iz-asymmetric" (at "sorted-lq-type" ld)))
            )
            (if (and iz-balanced (not iz-asymmetric))
                (UDC_AsymmetricTax 0.0 0.0 0.0 0.0 0.0 0.0)
                (let
                    (
                        (balanced-liquidity:[decimal] (at "balanced" (at "sorted-lq" ld)))
                        (asymmetric-liquidity:[decimal] (at "asymmetric" (at "sorted-lq" ld)))
                        (balanced-lp-amount:decimal (at "balanced" ld))
                        (asymmetric-lp-amount:decimal (at "asymmetric" ld))
                        (asymmetric-lp-fee-amount:decimal (at "asymmetric-fee" ld))
                        (lp-amount:decimal (+ balanced-lp-amount asymmetric-lp-amount))
                        ;;
                        ;;Get Data to Construct the Virtual Swapper
                        (pool-token-supplies:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                        (lp-supply:decimal (ref-SWP::URC_LpCapacity swpair))
                        (virtual-pool-token-supplies:[decimal] 
                            (if iz-balanced
                                (zip (+) pool-token-supplies balanced-liquidity)
                                pool-token-supplies
                            )
                        )
                        (virtual-lp-supply:decimal
                            (if iz-balanced
                                (+ lp-supply balanced-lp-amount)
                                lp-supply
                            )
                        )
                        (w:[decimal] (ref-SWP::UR_Weigths swpair))
                        (lp-prec:integer (ref-DPTF::UR_Decimals (ref-SWP::UR_TokenLP swpair)))
                        ;;
                        ;;Construct the Virtual Swapper and get asymmetric-Break-Amounts <aba>
                        ;;<aba> is the Output Liquidity one would get by removing LP made with asymmetric Liquidity
                        ;;<aba> is computed on top of <pool-liq> + <input-balanced-lq>
                        ;;<aba> is the base for computing the AsymmetricTax
                        ;;
                        (aba:[decimal]
                            (URC_CustomLpBreakAmounts swpair virtual-pool-token-supplies virtual-lp-supply asymmetric-lp-amount)
                        )
                        (first-bonus-amount:decimal (at 0 aba))
                        (fba-filled:[decimal] (ref-SWPI::URC_IndirectRefillAmounts virtual-pool-token-supplies [0] [first-bonus-amount]))
                        (account-starting-liq:[decimal] (zip (-) asymmetric-liquidity fba-filled))
                        (vse:object{UtilitySwpV2.VirtualSwapEngine}
                            (UDC_VirtualSwapEngineSwpair 
                                account account-starting-liq
                                swpair virtual-pool-token-supplies
                            )
                        )
                        (a-prec:integer (at 0 (at "v-prec" vse)))
                        ;;
                        ;;Preparing first Virtual Swap;
                        ;;
                        ;;Step 1 - in computing the asymmetric Tax
                        ;;<asymmetric-liquidity> except the the amount for the first token <df-asymmetric-liquidity>
                        ;;is virtualy swapped into the Pools First Token.
                        ;;If Amounts for the first Token exist in the <asymmetric-liquidity>, they are kept as such
                        ;;Therefore, after Step 1, a certain amount of First Token Amount is returned into the virtual account of the VSE
                        ;;
                        ;;Step 2 - computes how much of the 1st Pool Token would be neeeded to swap into the
                        ;;Pool Token Amounts existing in <aba>. This efectively mimics a swap from First Pool Token into the <aba> amounts
                        ;;Reverse Swap computation is used for this.
                        ;;
                        ;;Since there is a Swap in Step 1, and multiple more swap in Step 2, the fee thus leverages:
                        ;;      Pool Fees
                        ;;      Pool Liquidity Depth
                        ;;The nature of the computation for the asymmetric Fee, makes the fee more expensive than an effective swap.
                        ;;      The logic for this is to deincentivize asymmetric Liquidity Addition, not only by making it expensive
                        ;;      But also to tie it into the Swap Behaviour of the Pool, 
                        ;;      so as not to undermine the natural Swap Mechanism itself.
                        ;;
                        (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                        (first-pt:string (at 0 pool-tokens))
                        (df-pool-tokens:[string] (drop 1 pool-tokens))
                        (df-asymmetric-liquidity:[decimal] (drop 1 asymmetric-liquidity))
                        (df-asymmetric-liquidity-no-zeroes:[decimal] (ref-U|LST::UC_RemoveItem df-asymmetric-liquidity 0.0))
                        (df-pool-tokens-no-zeroes:[string]
                            (fold
                                (lambda
                                    (acc:[string] idx:integer)
                                    (if (!= (at idx df-asymmetric-liquidity) 0.0)
                                        (ref-U|LST::UC_AppL
                                            acc
                                            (at idx df-pool-tokens)
                                        )
                                        acc
                                    )
                                )
                                []
                                (enumerate 0 (- (length df-pool-tokens) 1))
                            )
                        )
                        (l1:integer (length df-asymmetric-liquidity-no-zeroes))
                        (swap-no1-data:object{UtilitySwpV2.DirectSwapInputData}
                            (ref-U|SWP::UDC_DirectSwapInputData
                                df-pool-tokens-no-zeroes
                                df-asymmetric-liquidity-no-zeroes
                                (at 0 pool-tokens)
                            )
                        )
                        ;;
                        ;;First Virtual Swap
                        (vse1:object{UtilitySwpV2.VirtualSwapEngine}
                            (if (!= l1 0)
                                (ref-SWPI::UC_VirtualSwap vse swap-no1-data)
                                vse
                            )
                        )
                        (vse2:object{UtilitySwpV2.VirtualSwapEngine}
                            (UCX_Step2AsymmetricTaxVirtualSwapper 
                                vse1 first-pt df-pool-tokens (drop 1 aba)
                            )
                        )
                        ;;Get Needed Virtual Swap Values
                        (token-a-deficit:decimal (abs (at 0 (at "account-supply" vse2))))
                        
                        (fuel:[decimal] (at "fuel" vse2))
                        (special:[decimal] (at "special" vse2))
                        (boost:[decimal] (at "boost" vse2))
                        ;;
                        ;;Get Share Values on <virtual-pool-token-supplies>
                        (shares:[decimal] (ref-SWPI::UC_PoolShares virtual-pool-token-supplies w))
                        (a-share:decimal (at 0 shares))
                        (tad-shares:decimal (floor (* token-a-deficit a-share) 24))

                        (fuel-shares:decimal (floor (fold (+) 0.0 (zip (*) fuel shares)) 24))
                        (special-shares:decimal (floor (fold (+) 0.0 (zip (*) special shares)) 24))
                        (boost-shares:decimal (floor (fold (+) 0.0 (zip (*) boost shares)) 24))
                        (fee-shares:decimal (fold (+) 0.0 [fuel-shares special-shares boost-shares]))
                        (diff-shares:decimal (- tad-shares fee-shares))
                        ;;
                        (fuel-as-a:decimal (floor (/ fuel-shares a-share) a-prec))
                        (special-as-a:decimal (floor (/ special-shares a-share) a-prec))
                        (boost-as-a:decimal (floor (/ boost-shares a-share) a-prec))
                        (tad-diff:decimal (- token-a-deficit (fold (+) 0.0 [fuel-as-a special-as-a boost-as-a])))
                        ;;
                        ;;Get Fuel Shares as LP
                        (fuel-to-lp:decimal (floor (/ (* virtual-lp-supply fuel-shares) 5040000.0) lp-prec))
                    )
                    (UDC_AsymmetricTax
                        token-a-deficit
                        tad-diff
                        fuel-as-a
                        special-as-a
                        boost-as-a
                        fuel-to-lp
                    )
                )
            )
        )
    )
    (defun UCX_Step2AsymmetricTaxVirtualSwapper:object{UtilitySwpV2.VirtualSwapEngine}
        (vse:object{UtilitySwpV2.VirtualSwapEngine} first-token-id:string liq-ids:[string] liq-amounts:[decimal])
        (let
            (
                (l1:integer (length liq-ids))
                (l2:integer (length liq-amounts))
            )
            (if (and (= l1 l2) (= l1 0))
                vse
                (let
                    (
                        (ref-U|LST:module{StringProcessor} U|LST)
                        (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                        (ref-SWPI:module{SwapperIssue} SWPI)
                        ;;
                        ;;Unwrap VSE Object Data for fixed Variables
                        (account:string (at "account" vse))
                        (pool-type:string (ref-U|SWP::UC_PoolType (at "swpair" vse)))
                        (fees:object{UtilitySwpV2.SwapFeez} (at "F" vse))
                        (A:decimal (at "A" vse))
                        (X-prec:[integer] (at "v-prec" vse))
                        (v-tokens:[string] (at "v-tokens" vse))
                        (W:[decimal] (at "W" vse))
                        ;;
                        (vse-single-chain:[object{UtilitySwpV2.VirtualSwapEngine}]
                            (fold
                                (lambda
                                    (acc:[object{UtilitySwpV2.VirtualSwapEngine}] idx:integer)
                                    (let
                                        (
                                            (prev-vse:object{UtilitySwpV2.VirtualSwapEngine} (at 0 acc))
                                            (id:string (at idx liq-ids))
                                            (amount:decimal (at idx liq-amounts))
                                            ;;
                                            ;;Unwrap VSE Object Data for mutable Variables
                                            (X:[decimal] (at "X" prev-vse))
                                            (output-position:integer (at 0 (ref-U|LST::UC_Search v-tokens id)))
                                            ;;
                                            (rsid:object{UtilitySwpV2.ReverseSwapInputData}
                                                (ref-U|SWP::UDC_ReverseSwapInputData
                                                    id amount first-token-id
                                                )
                                            )
                                            (itso:object{UtilitySwpV2.InverseTaxedSwapOutput}
                                                (ref-SWPI::UC_InverseBareboneSwapWithFeez
                                                    account pool-type rsid fees A X X-prec output-position 0 W
                                                )
                                            )
                                            (input-amount:decimal (at "i-id-brutto" itso))
                                            ;;
                                            (dsid:object{UtilitySwpV2.DirectSwapInputData}
                                                (ref-U|SWP::UDC_DirectSwapInputData
                                                    [first-token-id]
                                                    [input-amount]
                                                    id
                                                )
                                            )
                                            (new-vse:object{UtilitySwpV2.VirtualSwapEngine}
                                                (ref-SWPI::UC_VirtualSwap prev-vse dsid)
                                            )
                                        )
                                        (ref-U|LST::UC_ReplaceAt acc 0 new-vse)
                                    )
                                )
                                [vse]
                                (enumerate 0 (- l1 1))
                            )
                        )
                    )
                    (at 0 vse-single-chain)
                )
            )
        )
    )
    (defun URC_SortLiquidity:object{SwapperLiquidity.LiquiditySplit} (swpair:string input-amounts:[decimal])
        @doc "Sorts Liquidity into a balanced part and an asymmetric part"
        (let
            (
                (iz-balanced:bool (URC_AreAmountsBalanced swpair input-amounts))
            )
            (if iz-balanced
                (UDC_LiquiditySplit
                    input-amounts
                    (make-list (length input-amounts) 0.0)
                )
                (let
                    (
                        (has-zeroes:bool (contains 0.0 input-amounts))
                    )
                    (if has-zeroes
                        (UDC_LiquiditySplit
                            (make-list (length input-amounts) 0.0)
                            input-amounts
                        )
                        (let
                            (
                                (ref-SWP:module{SwapperV4} SWP)
                                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                                (balanced-chain:[decimal]
                                    (fold
                                        (lambda
                                            (acc:[decimal] idx:integer)
                                            (let
                                                (
        
                                                    (input-id:string (at idx pool-tokens))
                                                    (input-amount:decimal (at idx input-amounts))
                                                    (balanced-lq:[decimal] (URC_BalancedLiquidity swpair input-id input-amount false))
                                                    (iz-it-fitting:bool
                                                        (fold
                                                            (lambda
                                                                (acc:bool idxx:integer)
                                                                (let
                                                                    (
                                                                        (element:decimal (at idxx balanced-lq))
                                                                        (iz-smaller:bool (<= element (at idxx input-amounts)))
                                                                    )
                                                                    (and acc iz-smaller)
                                                                )
                                                            )
                                                            true
                                                            (enumerate 0 (- (length balanced-lq) 1))
                                                        )
                                                    )
                                                )
                                                (if iz-it-fitting
                                                    balanced-lq
                                                    acc
                                                )
                                            )
                                        )
                                        []
                                        (enumerate 0 (- (length input-amounts) 1))
                                    )
                                )
                            )
                            (UDC_LiquiditySplit
                                balanced-chain
                                (zip (-) input-amounts balanced-chain)
                            )
                        )
                    )
                )
            )
        )
    )
    ;;
    (defun URC_AreAmountsBalanced:bool (swpair:string input-amounts:[decimal])
        @doc "Determines if <input-amounts> are balanced according to <swpair>"
        (let
            (
                (sum:decimal (fold (+) 0.0 input-amounts))
            )
            (enforce (> sum 0.0) "At least a single input value must be greater than zero!")
            (let
                (
                    (has-zeroes:bool (contains 0.0 input-amounts))
                )
                (if has-zeroes
                    false
                    (let
                        (
                            (ref-U|LST:module{StringProcessor} U|LST)
                            (ref-SWPI:module{SwapperIssue} SWPI)
                            (positive-amounts:[decimal] (ref-U|LST::UC_RemoveItem input-amounts 0.0))
                            (positive-ids:[string] (ref-SWPI::URC_TrimIdsWithZeroAmounts swpair input-amounts))
                        )
                        (fold
                            (lambda
                                (acc:bool idx:integer)
                                (let
                                    (
                                        (amount:decimal (at idx positive-amounts))
                                        (id:string (at idx positive-ids))
                                        (computed-balance:[decimal] (URC_BalancedLiquidity swpair id amount false))
                                        (checks:bool (= input-amounts computed-balance))
                                    )
                                    (or acc checks)
                                )
                            )
                            false
                            (enumerate 0 (- (length positive-amounts) 1))

                        )
                    )
                )
            )
        )
    )
    (defun URC_BalancedLiquidity:[decimal] (swpair:string input-id:string input-amount:decimal with-validation:bool)
        @doc "Computes the amounts of Balanced Liquidity from one <input-id> with an <input-amount> on a given <swpair> \
        \ <with-validation> specifies if additional validation should also be executed to validate the inputs."
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (input-position:integer (ref-SWP::UR_PoolTokenPosition swpair input-id))
                (input-precision:integer (ref-DPTF::UR_Decimals input-id))
                (X:[decimal]
                    (if (= (ref-SWP::URC_LpCapacity swpair) 0.0)
                        (ref-SWP::UR_PoolGenesisSupplies swpair)
                        (ref-SWP::UR_PoolTokenSupplies swpair)
                    )
                )
                (Xp:[integer] (ref-SWP::UR_PoolTokenPrecisions swpair))
            )
            (if with-validation
                (UEV_BalancedLiquidity swpair input-id input-amount)
                true
            )
            (ref-U|SWP::UC_BalancedLiquidity input-amount input-position input-precision X Xp)
        )
    )
    (defun URC_LpBreakAmounts:[decimal] (swpair:string input-lp-amount:decimal)
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                (pool-token-supplies:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (lp-supply:decimal (ref-SWP::URC_LpCapacity swpair))
            )
            (URC_CustomLpBreakAmounts swpair pool-token-supplies lp-supply input-lp-amount)
        )
    )
    (defun URC_CustomLpBreakAmounts:[decimal]
        (swpair:string swpair-pool-token-supplies:[decimal] swpair-lp-supply:decimal input-lp-amount:decimal)
        @doc "Computes the Pool Token Amounts that result from removing <input-lp-amount> of LP Token \
        \ Using Custom values for PoolTokenSupplies and PoolLPSupply"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-SWP:module{SwapperV4} SWP)
                (ratio:decimal (floor (/ input-lp-amount swpair-lp-supply) 24))
                (pool-token-precisions:[integer] (ref-SWP::UR_PoolTokenPrecisions swpair))
                (l1:integer (length swpair-pool-token-supplies))
                (l2:integer (length pool-token-precisions))
            )
            ;;Validation of inputs
            (enforce 
                (and
                    (<= input-lp-amount swpair-lp-supply)
                    (= l1 l2)
                )
                "Invalid Input Data for Break LP Computation"
            )
            (if (= input-lp-amount swpair-lp-supply)
                swpair-pool-token-supplies
                (fold
                    (lambda
                        (acc:[decimal] idx:integer)
                        (ref-U|LST::UC_AppL
                            acc
                            (floor (* ratio (at idx swpair-pool-token-supplies)) (at idx pool-token-precisions))
                        )
                    )
                    []
                    (enumerate 0 (- (length swpair-pool-token-supplies) 1))
                )
            )
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_Liquidity:decimal
        (swpair:string ld:object{SwapperLiquidity.LiquidityData})
            @doc "Validates the asymmetric Liquidity amount, if it exists within the LD Object. \
            \ Validation means that it doesent produce a Share Deviation \
            \ greater than 40% of the Maximum Pool Deviation \
            \ Maximum Pool Deviation is given by its token Size \
            \ and is given by the formula (n-1)/n \
            \ The Deviation is computed on existing <swpair> liquidity, plus \
            \ any balanced-liq, should it exist within the <ld> \
            \ Outputs the Share deviation <ld> would produce on the <swpair> \
            \ If no asymmetric liq exists within the LD, then outputs zero, as no Deviation would occur"
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                ;;Unwrap Object Data
                (balanced-liquidity:[decimal] (at "balanced" (at "sorted-lq" ld)))
                (asymmetric-liquidity:[decimal] (at "asymmetric" (at "sorted-lq" ld)))
                (iz-balanced:bool (at "iz-balanced" (at "sorted-lq-type" ld)))
                (iz-asymmetric:bool (at "iz-asymmetric" (at "sorted-lq-type" ld)))
                ;;
                ;;Get Data to Construct the Virtual Swapper
                (pool-token-supplies:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (lp-supply:decimal (ref-SWP::URC_LpCapacity swpair))
                (virtual-pool-token-supplies:[decimal] 
                    (if iz-balanced
                        (zip (+) pool-token-supplies balanced-liquidity)
                        pool-token-supplies
                    )
                )
            )
            (if (not iz-asymmetric)
                0.0
                (let
                    (
                        (ref-SWPI:module{SwapperIssue} SWPI)
                        ;;
                        (w:[decimal] (ref-SWP::UR_Weigths swpair))
                        (n:decimal (dec (length w)))
                        (max-dev:decimal (floor (* 0.4 (/ (- n 1.0) n)) 24))
                        (dev:decimal (ref-SWPI::UC_DeviationInValueShares virtual-pool-token-supplies asymmetric-liquidity w))
                    )
                    (enforce (<= dev max-dev) (format "asymmetric Liqudity incurrs {} deviation, which is greater than the maximum allowed deviation of {}" [dev max-dev]))
                    dev
                )
            )
        )
    )
    (defun UEV_BalancedLiquidity (swpair:string input-id:string input-amount:decimal)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (iz-on-pool:bool (contains input-id pool-tokens))
            )
            (enforce iz-on-pool (format "Token {} is not part of SWPair {}" [input-id swpair]))
            (ref-DPTF::UEV_Amount input-id input-amount)
        )
    )
    (defun UEV_InputsForLP (swpair:string input-amounts:[decimal])
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (l1:integer (length input-amounts))
                (l2:integer (length pool-tokens))
                (sum:decimal (fold (+) 0.0 input-amounts))
            )
            (enforce (= l1 l2) "Invalid input amounts")
            (enforce (>= sum 0.0) "Input amounts Sum must be greater than zero")
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (amount:decimal (at idx input-amounts))
                            (pool-token:string (at idx pool-tokens))
                        )
                        (enforce (>= amount 0.0) "Amounts must be greater or equal to zero")
                        (if (> amount 0.0)
                            (ref-DPTF::UEV_Amount pool-token amount)
                            true
                        )
                    )
                )
                (enumerate 0 (- l1 1))
            )
        )
    )
    ;;{F3}  [UDC]
    (defun UDC_VirtualSwapEngineSwpair:object{UtilitySwpV2.VirtualSwapEngine}
        (account:string account-liq:[decimal] swpair:string pool-liq:[decimal])
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                (A:decimal (ref-SWP::UR_Amplifier swpair))
                (W:[decimal] (ref-SWP::UR_Weigths swpair))
            )
            (UDC_VirtualSwapEngine
                account account-liq swpair pool-liq
                A W (UDC_PoolFees swpair)
            )
        )
    )
    (defun UDC_VirtualSwapEngine:object{UtilitySwpV2.VirtualSwapEngine}
        (
            account:string account-liq:[decimal] swpair:string starting-liq:[decimal]
            A:decimal W:[decimal] F:object{UtilitySwpV2.SwapFeez}
        )
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWP:module{SwapperV4} SWP)
                (pool-tokens:[string] (ref-U|SWP::UC_TokensFromSwpairString swpair))
                (zero-lst:[decimal] (make-list (length pool-tokens) 0.0))
            )
            (ref-U|SWP::UDC_VirtualSwapEngine
                pool-tokens
                (ref-SWP::UC_PoolTokenPrecisions swpair)
                account account-liq swpair starting-liq
                A W F
                zero-lst zero-lst zero-lst []
            )
        )
    )
    (defun UDC_PoolFees:object{UtilitySwpV2.SwapFeez} (swpair:string)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWP:module{SwapperV4} SWP)
                (lb:bool (ref-SWP::UR_LiquidBoost))
                (lp-fee:decimal (ref-SWP::UR_FeeLP swpair))
                (special-fee:decimal (ref-SWP::UR_FeeSP swpair))
                (boost-fee:decimal (if lb lp-fee 0.0))
            )
            (ref-U|SWP::UDC_SwapFeez lp-fee special-fee boost-fee)
        )
    )
    (defun UDC_OutputLP:object{SwapperLiquidity.OutputLP} (a:decimal b:decimal)
        {"primary"                  : a
        ,"secondary"                : b}
    )
    (defun UDC_LiquiditySplit:object{SwapperLiquidity.LiquiditySplit} (a:[decimal] b:[decimal])
        {"balanced"                 : a
        ,"asymmetric"               : b}
    )
    (defun UDC_LiquiditySplitType:object{SwapperLiquidity.LiquiditySplitType} (a:bool b:bool)
        {"iz-balanced"              : a
        ,"iz-asymmetric"            : b}
    )
    (defun UDC_LiquidityData:object{SwapperLiquidity.LiquidityData}
        (a:object{SwapperLiquidity.LiquiditySplit} b:object{SwapperLiquidity.LiquiditySplitType} c:decimal d:decimal e:decimal)
        {"sorted-lq"                : a
        ,"sorted-lq-type"           : b
        ,"balanced"                 : c
        ,"asymmetric"               : d
        ,"asymmetric-fee"           : e}
    )
    (defun UDC_LiquidityComputationData:object{SwapperLiquidity.LiquidityComputationData}
        (a:integer b:string c:integer d:decimal e:decimal f:[decimal])
        {"li"                       : a
        ,"pool-type"                : b
        ,"lp-prec"                  : c
        ,"current-lp-supply"        : d
        ,"lp-supply"                : e
        ,"pool-token-supplies"      : f}
    )
    (defun UDC_AsymmetricTax:object{SwapperLiquidity.AsymmetricTax}
        (a:decimal b:decimal c:decimal d:decimal e:decimal f:decimal)
        {"tad"                      : a
        ,"tad-diff"                 : b
        ,"fuel"                     : c
        ,"special"                  : d
        ,"boost"                    : e
        ,"fuel-to-lp"               : f}
    )
    (defun UDC_CompleteLiquidityAdditionData:object{SwapperLiquidity.CompleteLiquidityAdditionData}
        (
            a:[decimal] b:[decimal] c:[decimal] d:decimal
            e:decimal f:decimal
            g:decimal
            h:decimal i:decimal j:decimal k:decimal l:decimal
            m:string n:string o:string p:string q:string
        )
        {"total-input-liquidity"        : a
        ,"balanced-liquidity"           : b
        ,"asymmetric-liquidity"         : c
        ,"asymmetric-deviation"         : d
        ;;
        ,"primary-lp"                   : e
        ,"secondary-lp"                 : f
        ;;
        ,"total-ignis-tax-needed"       : g
        ;;
        ,"gaseous-ignis-fee"            : h
        ,"deficit-ignis-tax"            : i
        ,"special-ignis-tax"            : j
        ,"lqboost-ignis-tax"            : k
        ,"relinquish-lp"                : l
        ;;
        ,"gaseous-text"                 : m
        ,"deficit-text"                 : n
        ,"special-text"                 : o
        ,"lqboost-text"                 : p
        ,"fueling-text"                 : q}
    )
    (defun UDC_PoolState:object{SwapperLiquidity.PoolState}
        (a:[decimal] b:decimal)
        {"X"                : a
        ,"LP"               : b}
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;LP DPTF Branding
    (defun C_UpdatePendingBrandingLPs:object{IgnisCollector.OutputCumulator}
        (swpair:string entity-pos:integer logo:string description:string website:string social:[object{Branding.SocialSchema}])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-BRD:module{Branding} BRD)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (entity-id:string (URC_EntityPosToID swpair entity-pos))
                (entity-owner:string
                    (if (= entity-pos 3)
                        (ref-DPMF::UR_Konto entity-id)
                        (ref-DPTF::UR_Konto entity-id)
                    )
                )
            )
            (with-capability (SWPL|C>UPDATE-BRD swpair)
                (ref-BRD::XE_UpdatePendingBranding entity-id logo description website social)
                (ref-IGNIS::IC|UDC_BrandingCumulator entity-owner 2.0)
            )
        )
    )
    (defun C_UpgradeBrandingLPs (patron:string swpair:string entity-pos:integer months:integer)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-BRD:module{Branding} BRD)
                (ref-SWP:module{SwapperV4} SWP)
                (owner:string (ref-SWP::UR_OwnerKonto swpair))
                (entity-id:string (URC_EntityPosToID swpair entity-pos))
                (kda-payment:decimal
                    (with-capability (SWPU|C>UPGRADE-BRD swpair)
                        (ref-BRD::XE_UpgradeBranding entity-id owner months)
                    )
                )
            )
            (ref-DALOS::KDA|C_CollectWT patron kda-payment false)
        )
    )
    ;;LQ Functions
    (defun C_ToggleAddLiquidity:object{IgnisCollector.OutputCumulator}
        (swpair:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
            )
            (with-capability (P|SWPL|CALLER)
                (ref-SWP::C_ToggleAddOrSwap swpair toggle true)
            )
        )
    )
    (defun C_Fuel:object{IgnisCollector.OutputCumulator}
        (account:string swpair:string input-amounts:[decimal] direct-or-indirect:bool validation:bool)
        (UEV_IMC)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPI:module{SwapperIssue} SWPI)
                ;;
                (pt-current-amounts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (has-zeros:bool (contains 0.0 input-amounts))
                (input-ids-for-transfer:[string]
                    (if has-zeros
                        (ref-SWPI::URC_TrimIdsWithZeroAmounts swpair input-amounts)
                        pool-tokens
                    )
                )
                (input-amounts-for-transfer:[decimal]
                    (if has-zeros
                        (ref-U|LST::UC_RemoveItem input-amounts 0.0)
                        input-amounts
                    )
                )
                (new-balances:[decimal] 
                    (zip (+) pt-current-amounts input-amounts)
                )
            )
            (if validation
                (UEV_InputsForLP swpair input-amounts)
                true
            )
            (if direct-or-indirect
                (with-capability (SWPL|C>DIRECT-FUEL account swpair input-ids-for-transfer input-amounts-for-transfer)
                    (ref-SWP::XE_UpdateSupplies swpair new-balances)
                    (ref-TFT::C_MultiTransfer input-ids-for-transfer account SWP|SC_NAME input-amounts-for-transfer true)
                )
                (with-capability (SWPL|C>INDIRECT-FUEL account swpair input-ids-for-transfer input-amounts-for-transfer)
                    (ref-SWP::XE_UpdateSupplies swpair new-balances)
                    EOC
                )
            )
        )
    )
    (defun C|KDA-PID_AddStandardLiquidity:object{IgnisCollector.OutputCumulator}
        (account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UEV_IMC)
        (let
            (
                (ld:object{SwapperLiquidity.LiquidityData}
                    (URC_Liquidity swpair input-amounts)
                )
            )
            (with-capability (SWPL|C>ADD-STANDARD-LQ swpair ld)
                (let
                    (
                        (ref-IGNIS:module{IgnisCollector} DALOS)
                        (ref-TFT:module{TrueFungibleTransferV6} TFT)
                        (ref-SWP:module{SwapperV4} SWP)
                        ;;
                        (lp-id:string (ref-SWP::UR_TokenLP swpair))
                        ;;
                        ;;Compute Liquidity Addition Data
                        (clad:object{SwapperLiquidity.CompleteLiquidityAdditionData}
                            (URC|KDA-PID_CompleteLiquidityAdditionData account swpair ld true true kda-pid)
                        )
                        ;;
                        (ico1:object{IgnisCollector.OutputCumulator}
                            (XB|KDA-PID_AddLiqudity account swpair true true kda-pid ld clad)
                        )
                        (native-lp-transfer-amount:decimal (at "primary-lp" clad))
                        (ico2:object{IgnisCollector.OutputCumulator}
                            (ref-TFT::C_Transfer lp-id SWP|SC_NAME account native-lp-transfer-amount true)
                        )
                    )
                    ;;Autonomous Swap Mangement
                    (XI_AutonomousSwapManagement swpair)
                    ;;Output Cumulator
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2] [native-lp-transfer-amount])
                )
            )
        )
    )
    (defun C|KDA-PID_AddIcedLiquidity:object{IgnisCollector.OutputCumulator}
        (account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UEV_IMC)
        (let
            (
                (ld:object{SwapperLiquidity.LiquidityData}
                    (URC_Liquidity swpair input-amounts)
                )
            )
            (with-capability (SWPL|C>ADD-ICED-LQ swpair ld)
                (let
                    (
                        (ref-IGNIS:module{IgnisCollector} DALOS)
                        (ref-TFT:module{TrueFungibleTransferV6} TFT)
                        (ref-VST:module{VestingV4} VST)
                        (ref-SWP:module{SwapperV4} SWP)
                        ;;
                        (lp-id:string (ref-SWP::UR_TokenLP swpair))
                        ;;
                        ;;Compute Liquidity Addition Data
                        (clad:object{SwapperLiquidity.CompleteLiquidityAdditionData}
                            (URC|KDA-PID_CompleteLiquidityAdditionData account swpair ld false true kda-pid)
                        )
                        ;;
                        (ico1:object{IgnisCollector.OutputCumulator}
                            (XB|KDA-PID_AddLiqudity account swpair false true kda-pid ld clad)
                        )
                        (native-lp-transfer-amount:decimal (at "primary-lp" clad))
                        (frozen-lp-transfer-amount:decimal (at "secondary-lp" clad))
                        (ico2:object{IgnisCollector.OutputCumulator}
                            (ref-TFT::C_Transfer lp-id SWP|SC_NAME account native-lp-transfer-amount true)
                        )
                        (ico3:object{IgnisCollector.OutputCumulator}
                            (ref-VST::C_Freeze SWP|SC_NAME account lp-id frozen-lp-transfer-amount)
                        )
                    )
                    ;;Autonomous Swap Mangement
                    (XI_AutonomousSwapManagement swpair)
                    ;;Output Cumulator
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3] [native-lp-transfer-amount frozen-lp-transfer-amount])
                )
            )
        )
    )
    (defun C|KDA-PID_AddGlacialLiquidity:object{IgnisCollector.OutputCumulator}
        (account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UEV_IMC)
        (let
            (
                (ld:object{SwapperLiquidity.LiquidityData}
                    (URC_Liquidity swpair input-amounts)
                )
            )
            (with-capability (SWPL|C>ADD-GLACIAL-LQ swpair ld)
                (let
                    (
                        (ref-IGNIS:module{IgnisCollector} DALOS)
                        (ref-TFT:module{TrueFungibleTransferV6} TFT)
                        (ref-VST:module{VestingV4} VST)
                        (ref-SWP:module{SwapperV4} SWP)
                        ;;
                        (lp-id:string (ref-SWP::UR_TokenLP swpair))
                        (ld:object{SwapperLiquidity.LiquidityData}
                            (URC_Liquidity swpair input-amounts)
                        )
                        ;;
                        ;;Compute Liquidity Addition Data
                        (clad:object{SwapperLiquidity.CompleteLiquidityAdditionData}
                            (URC|KDA-PID_CompleteLiquidityAdditionData account swpair ld false false kda-pid)
                        )
                        ;;
                        (ico1:object{IgnisCollector.OutputCumulator}
                            (XB|KDA-PID_AddLiqudity account swpair false false kda-pid ld clad)
                        )
                        (native-lp-transfer-amount:decimal (at "primary-lp" clad))
                        (frozen-lp-transfer-amount:decimal (at "secondary-lp" clad))
                        (ico2:object{IgnisCollector.OutputCumulator}
                            (ref-TFT::C_Transfer lp-id SWP|SC_NAME account native-lp-transfer-amount true)
                        )
                        (ico3:object{IgnisCollector.OutputCumulator}
                            (ref-VST::C_Freeze SWP|SC_NAME account lp-id frozen-lp-transfer-amount)
                        )
                    )
                    ;;Autonomous Swap Mangement
                    (XI_AutonomousSwapManagement swpair)
                    ;;Output Cumulator
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3] [native-lp-transfer-amount frozen-lp-transfer-amount])
                )
            )
        )
    )
    (defun C|KDA-PID_AddFrozenLiquidity:object{IgnisCollector.OutputCumulator}
        (account:string swpair:string frozen-dptf:string input-amount:decimal kda-pid:decimal)
        (UEV_IMC)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (dptf:string (ref-DPTF::UR_Frozen frozen-dptf))
                (ptp:integer (ref-SWP::UR_PoolTokenPosition swpair dptf))
                (lq-lst:[decimal] (ref-U|SWP::UC_MakeLiquidityList swpair ptp input-amount))
                (ld:object{SwapperLiquidity.LiquidityData}
                    (URC_Liquidity swpair lq-lst)
                )
            )
            (with-capability (SWPL|C>ADD-FROZEN-LQ swpair frozen-dptf ld)
                (let
                    (
                        (ref-IGNIS:module{IgnisCollector} DALOS)
                        (ref-DALOS:module{OuronetDalosV4} DALOS)
                        (ref-TFT:module{TrueFungibleTransferV6} TFT)
                        (ref-VST:module{VestingV4} VST)
                        ;;
                        (vst-sc:string (ref-DALOS::GOV|VST|SC_NAME))
                        (ignis-id:string (ref-DALOS::UR_IgnisID))
                        (lp-id:string (ref-SWP::UR_TokenLP swpair))
                        ;;
                        (ico1:object{IgnisCollector.OutputCumulator}
                            (ref-TFT::C_Transfer frozen-dptf account vst-sc input-amount true)
                        )
                        (ico2:object{IgnisCollector.OutputCumulator}
                            (ref-DPTF::C_Burn frozen-dptf vst-sc input-amount)
                        )
                        ;;
                        ;;Compute Liquidity Addition Data
                        (clad:object{SwapperLiquidity.CompleteLiquidityAdditionData}
                            (URC|KDA-PID_CompleteLiquidityAdditionData vst-sc swpair ld false false kda-pid)
                        )
                        ;;
                        (ico3:object{IgnisCollector.OutputCumulator}
                            (XB|KDA-PID_AddLiqudity vst-sc swpair false false kda-pid ld clad)
                        )
                        (frozen-lp-transfer-amount:decimal (at "secondary-lp" clad))
                        (ico4:object{IgnisCollector.OutputCumulator}
                            (ref-VST::C_Freeze SWP|SC_NAME account lp-id frozen-lp-transfer-amount)
                        )
                    )
                    ;;Autonomous Swap Mangement
                    (XI_AutonomousSwapManagement swpair)
                    ;;Output Cumulator
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3 ico4] [frozen-lp-transfer-amount])
                )
            )
        )
    )
    (defun C|KDA-PID_AddSleepingLiquidity:object{IgnisCollector.OutputCumulator}
        (account:string swpair:string sleeping-dpmf:string nonce:integer kda-pid:decimal)
        (UEV_IMC)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (dptf:string (ref-DPMF::UR_Sleeping sleeping-dpmf))
                (ptp:integer (ref-SWP::UR_PoolTokenPosition swpair dptf))
                (batch-amount:decimal (ref-DPMF::UR_AccountNonceBalance sleeping-dpmf nonce account))
                (lq-lst:[decimal] (ref-U|SWP::UC_MakeLiquidityList swpair ptp batch-amount))
                (ld:object{SwapperLiquidity.LiquidityData}
                    (URC_Liquidity swpair lq-lst)
                )
            )
            (with-capability (SWPL|C>ADD-SLEEPING-LQ account swpair sleeping-dpmf nonce ld)
                (let
                    (
                        (ref-IGNIS:module{IgnisCollector} DALOS)
                        (ref-DALOS:module{OuronetDalosV4} DALOS)
                        (ref-VST:module{VestingV4} VST)
                        ;;
                        (vst-sc:string (ref-DALOS::GOV|VST|SC_NAME))
                        (ignis-id:string (ref-DALOS::UR_IgnisID))
                        (lp-id:string (ref-SWP::UR_TokenLP swpair))
                        ;;
                        (nonce-md:[object] (ref-DPMF::UR_AccountNonceMetaData sleeping-dpmf nonce account))
                        (release-date:time (at "release-date" (at 0 nonce-md)))
                        (present-time:time (at "block-time" (chain-data)))
                        (dt:integer (floor (diff-time release-date present-time)))
                        ;;
                        (ico1:object{IgnisCollector.OutputCumulator}
                            (ref-DPMF::C_SingleBatchTransfer sleeping-dpmf nonce account vst-sc true)
                        )
                        (ico2:object{IgnisCollector.OutputCumulator}
                            (ref-DPMF::C_Burn sleeping-dpmf nonce vst-sc batch-amount)
                        )
                        ;;
                        ;;Compute Liquidity Addition Data
                        (clad:object{SwapperLiquidity.CompleteLiquidityAdditionData}
                            (URC|KDA-PID_CompleteLiquidityAdditionData vst-sc swpair ld true true kda-pid)
                        )
                        ;;
                        ;;MOVE IGNIS to vst-sc
                        (ico3:object{IgnisCollector.OutputCumulator}
                            (ref-TFT::C_Transfer ignis-id account vst-sc (at "total-ignis-tax-needed" clad) true)
                        )
                        ;;
                        (ico4:object{IgnisCollector.OutputCumulator}
                            (XB|KDA-PID_AddLiqudity vst-sc swpair true true kda-pid ld clad)
                        )
                        (sleeping-lp-transfer-amount:decimal (at "primary-lp" clad))
                        (ico5:object{IgnisCollector.OutputCumulator}
                            (ref-VST::C_Sleep SWP|SC_NAME account lp-id sleeping-lp-transfer-amount dt)
                        )
                    )
                    ;;Autonomous Swap Mangement
                    (XI_AutonomousSwapManagement swpair)
                    ;;Output Cumulator
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3 ico4] [sleeping-lp-transfer-amount])
                )
            )
        )
    )
    ;;
    (defun C_RemoveLiquidity:object{IgnisCollector.OutputCumulator}
        (account:string swpair:string lp-amount:decimal)
        @doc "Removes <swpair> Liquidity using <lp-amount> of LP Tokens \
            \ Always returns all Pool Tokens at current Pool Token Ratio"
        ;;
        (UEV_IMC)
        (with-capability (SWPL|C>REMOVE_LQ swpair lp-amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (ref-SWP:module{SwapperV4} SWP)
                    ;;
                    (pool-token-ids:[string] (ref-SWP::UR_PoolTokens swpair))
                    (lp-id:string (ref-SWP::UR_TokenLP swpair))
                    (pt-output-amounts:[decimal] (URC_LpBreakAmounts swpair lp-amount))
                    (pt-current-amounts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                    (pt-new-amounts:[decimal] (zip (-) pt-current-amounts pt-output-amounts))
                    ;;
                    ;;Removing Liquidity requires a flat fee of 10$ in Ignis
                    ;;This deincentivizes frequent Liquidity removals
                    ;;
                    (flat-ignis-lq-rm-fee:decimal 1000.0)
                    (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                    (ico-flat:object{IgnisCollector.OutputCumulator}
                        (ref-IGNIS::IC|UDC_ConstructOutputCumulator flat-ignis-lq-rm-fee SWP|SC_NAME trigger [])
                    )
                    ;;
                    (ico1:object{IgnisCollector.OutputCumulator}
                        (ref-TFT::C_Transfer lp-id account SWP|SC_NAME lp-amount true)
                    )
                    (ico2:object{IgnisCollector.OutputCumulator}
                        (ref-DPTF::C_Burn lp-id SWP|SC_NAME lp-amount)
                    )
                    (ico3:object{IgnisCollector.OutputCumulator}
                        (ref-TFT::C_MultiTransfer pool-token-ids SWP|SC_NAME account pt-output-amounts true)
                    )
                )
                ;;Updates Pool Supplies
                (ref-SWP::XE_UpdateSupplies swpair pt-new-amounts)
                ;;Autonomous Swap Mangement
                (XI_AutonomousSwapManagement swpair)
                ;;Output Cumulator
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico-flat ico1 ico2 ico3] pt-output-amounts)
            )
        )
    )
    ;;{F7}  [X]
    ;;
    (defun XB|KDA-PID_AddLiqudity:object{IgnisCollector.OutputCumulator}
        (
            account:string swpair:string asymmetric-collection:bool gaseous-collection:bool kda-pid:decimal
            ld:object{SwapperLiquidity.LiquidityData} clad:object{SwapperLiquidity.CompleteLiquidityAdditionData}
        )
        (UEV_IMC)
        ;(require-capability (SWPL|C>X-ADD-LQ swpair ld))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPI:module{SwapperIssue} SWPI)
                ;;
                ;;Unwrap Object Data
                (balanced-liquidity:[decimal] (at "balanced" (at "sorted-lq" ld)))
                (asymmetric-liquidity:[decimal] (at "asymmetric" (at "sorted-lq" ld)))
                (iz-balanced:bool (at "iz-balanced" (at "sorted-lq-type" ld)))
                (iz-asymmetric:bool (at "iz-asymmetric" (at "sorted-lq-type" ld)))
                (total-input-liquidity:[decimal] (at "total-input-liquidity" clad))
                ;;
                ;;Compute initial Variables
                (lp-id:string (ref-SWP::UR_TokenLP swpair))
                (gw:[decimal] (ref-SWP::UR_GenesisWeigths swpair))
                (read-lp-supply:decimal (ref-SWP::URC_LpCapacity swpair))
                (pt-current-amounts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                ;;
                ;;Create <ico-flat>
                (flat-ignis-lq-fee:decimal 1000.0)
                (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                (ico-flat:object{IgnisCollector.OutputCumulator}
                    (ref-IGNIS::IC|UDC_ConstructOutputCumulator flat-ignis-lq-fee SWP|SC_NAME trigger [])
                )
                ;;Initial Transfer IDs and Amounts
                (input-ids-for-transfer:[string]
                    (if (and (not iz-balanced) iz-asymmetric)
                        (ref-SWPI::URC_TrimIdsWithZeroAmounts swpair total-input-liquidity)
                        (ref-SWP::UR_PoolTokens swpair)
                    )
                )
                (input-amounts-for-transfer:[decimal]
                    (if (and (not iz-balanced) iz-asymmetric)
                        (ref-U|LST::UC_RemoveItem total-input-liquidity 0.0)
                        total-input-liquidity
                    )
                )
                ;;
                ;;Compute New Pool Amounts
                (pt-amounts-with-balanced:[decimal] 
                    (zip (+) pt-current-amounts balanced-liquidity)
                )
                (pt-amounts-with-asymmetric:[decimal] 
                    (zip (+) pt-amounts-with-balanced asymmetric-liquidity)
                )
            )
            (if iz-asymmetric
                (let
                    (
                        (gaseous-ignis-fee:decimal (at "gaseous-ignis-fee" clad))
                        (ico-gaseous:object{IgnisCollector.OutputCumulator}
                            (if gaseous-collection
                                (ref-IGNIS::IC|UDC_ConstructOutputCumulator gaseous-ignis-fee SWP|SC_NAME trigger [])
                                EOC
                            )
                        )
                    )
                    (if iz-balanced
                        (with-capability (SWPL|S>ADD_BALANCED-LQ account swpair balanced-liquidity)
                            (with-capability (SWPL|S>ADD_ASYMMETRIC-LQ account swpair asymmetric-liquidity)
                                (ref-SWP::XE_UpdateSupplies swpair pt-amounts-with-asymmetric)
                                (if (= read-lp-supply 0.0)
                                    (ref-SWP::XB_ModifyWeights swpair gw)
                                    true
                                )
                            )
                        )
                        (with-capability (SWPL|S>ADD_ASYMMETRIC-LQ account swpair asymmetric-liquidity)
                            (ref-SWP::XE_UpdateSupplies swpair pt-amounts-with-asymmetric)
                        )
                    )
                    (with-capability (SWPL|S>ASYMMETRIC-LQ-GASEOUS-TAX (at "gaseous-text" clad)) true)
                    (if asymmetric-collection
                        ;;Asymmetric Liquidity With Asymetric TAX Collection
                        (let
                            (
                                (ref-U|LST:module{StringProcessor} U|LST)
                                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                                (ref-DALOS:module{OuronetDalosV4} DALOS)
                                (ref-ORBR:module{OuroborosV3} OUROBOROS)
                                (ref-SWPI:module{SwapperIssue} SWPI)
                                ;;
                                (ignis-id:string (ref-DALOS::UR_IgnisID))
                                (ignis-prec:integer (ref-DPTF::UR_Decimals ignis-id))
                                (deficit-ignis-tax:decimal (at "deficit-ignis-tax" clad))
                                (special-ignis-tax:decimal (at "special-ignis-tax" clad))
                                (lqboost-ignis-tax:decimal (at "lqboost-ignis-tax" clad))
                                (relinquish-lp:decimal (at "relinquish-lp" clad))
                                (primary-lp-amount:decimal (at "primary-lp" clad))
                                    ;;
                                (primordial-swpair:string (ref-SWP::UR_PrimordialPool))
                                (primordial-supplies:[decimal] (ref-SWP::UR_PoolTokenSupplies primordial-swpair))
                                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                                (lkda-id:string (ref-DALOS::UR_LiquidKadenaID))
                                (ouro-mint-amount:decimal (at 0 (ref-ORBR::URC_Compress lqboost-ignis-tax)))
                                (dsid:object{UtilitySwpV2.DirectSwapInputData}
                                    (ref-U|SWP::UDC_DirectSwapInputData
                                        [ouro-id]
                                        [ouro-mint-amount]
                                        lkda-id
                                    )
                                )
                                (lkda-burn-amount:decimal (ref-SWPI::URC_Swap primordial-swpair dsid false))
                                ;;
                                (ignis-swp:decimal (fold (+) 0.0 [deficit-ignis-tax special-ignis-tax lqboost-ignis-tax]))
                                (secondary-ids-for-transfer:[string] (ref-U|LST::UC_InsertFirst input-ids-for-transfer ignis-id))
                                (secondary-amounts-for-transfer:[decimal] (ref-U|LST::UC_InsertFirst input-amounts-for-transfer ignis-swp))
                                ;;
                                ;;Construct ICOz
                                (ico1:object{IgnisCollector.OutputCumulator}
                                    (ref-TFT::C_MultiTransfer secondary-ids-for-transfer account SWP|SC_NAME secondary-amounts-for-transfer true)
                                )
                                (ico2:object{IgnisCollector.OutputCumulator}
                                    (ref-DPTF::C_Mint lp-id SWP|SC_NAME primary-lp-amount false)
                                )
                                (ico3:object{IgnisCollector.OutputCumulator}
                                    (ref-TFT::C_MultiBulkTransfer
                                        [ignis-id]
                                        SWP|SC_NAME
                                        [(ref-SWP::UR_SpecialFeeTargets swpair)]
                                        [
                                            (ref-U|SWP::UC_SpecialFeeOutputs
                                                (ref-SWP::UR_SpecialFeeTargetsProportions swpair)
                                                special-ignis-tax
                                                ignis-prec
                                            )
                                        ]
                                    )
                                )
                                (ico4:object{IgnisCollector.OutputCumulator}
                                    (ref-DPTF::C_Burn ignis-id SWP|SC_NAME lqboost-ignis-tax)
                                )
                                (ico5:object{IgnisCollector.OutputCumulator}
                                    (ref-DPTF::C_Mint ouro-id SWP|SC_NAME ouro-mint-amount false)
                                )
                                (ico6:object{IgnisCollector.OutputCumulator}
                                    (ref-DPTF::C_Burn lkda-id SWP|SC_NAME lkda-burn-amount)
                                )
                            )
                            (ref-SWP::XE_UpdateSupplies 
                                primordial-swpair 
                                (zip (+) primordial-supplies [(- 0.0 lkda-burn-amount) ouro-mint-amount 0.0])
                            )
                            (with-capability (SWPL|S>ASYMMETRIC-LQ-DEFICIT-TAX (at "deficit-text" clad)) true)
                            (with-capability (SWPL|S>ASYMMETRIC-LQ-FUELING-TAX (at "fueling-text" clad)) true)
                            (with-capability (SWPL|S>ASYMMETRIC-LQ-SPECIAL-TAX (at "special-text" clad)) true)
                            (with-capability (SWPL|S>ASYMMETRIC-LQ-LQBOOST-TAX (at "lqboost-text" clad)) true)
                            (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico-flat ico-gaseous ico1 ico2 ico3 ico4 ico5 ico6] [])
                        )
                        ;;Asymmetric Liquidity Without Asymetric TAX Collection
                        (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                            [
                                ico-flat ico-gaseous 
                                (ref-TFT::C_MultiTransfer input-ids-for-transfer account SWP|SC_NAME input-amounts-for-transfer true)
                                (ref-DPTF::C_Mint lp-id SWP|SC_NAME (+ (at "primary-lp" clad)(at "secondary-lp" clad)) false)
                            ]
                            []
                        )
                    )
                )
                ;;Balanced Liqudity Only
                (with-capability (SWPL|S>ADD_BALANCED-LQ account swpair balanced-liquidity)
                    (if (= read-lp-supply 0.0)
                        (ref-SWP::XB_ModifyWeights swpair gw)
                        true
                    )
                    (ref-SWP::XE_UpdateSupplies swpair pt-amounts-with-balanced)
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators 
                        [
                            ico-flat
                            (ref-TFT::C_MultiTransfer input-ids-for-transfer account SWP|SC_NAME input-amounts-for-transfer true)
                            (ref-DPTF::C_Mint lp-id SWP|SC_NAME (at "primary-lp" clad) false)
                        ]
                        []
                    )
                )
            )
        )
    )
    (defun XI_AutonomousSwapManagement (swpair:string)
        (UEV_IMC)
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPI:module{SwapperIssue} SWPI)
                (pool-worth:decimal (at 0 (ref-SWPI::URC_PoolValue swpair)))
                (inactive-limit:decimal (ref-SWP::UR_InactiveLimit))
            )
            (with-capability (P|SWPL|CALLER)
                (if (< pool-worth inactive-limit)
                    (ref-SWP::XE_CanAddOrSwapToggle swpair false false)
                    (ref-SWP::XE_CanAddOrSwapToggle swpair true false)
                )
            )
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)