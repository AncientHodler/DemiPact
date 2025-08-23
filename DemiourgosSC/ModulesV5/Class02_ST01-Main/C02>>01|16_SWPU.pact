;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module SWPU GOV
    ;;
    (implements OuronetPolicy)
    (implements SwapperUsageV4)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_SWPU           (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst SWP|SC_NAME           (GOV|SWP|SC_NAME))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|SWPU_ADMIN)))
    (defcap GOV|SWPU_ADMIN ()       (enforce-guard GOV|MD_SWPU))
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
    (defcap P|SWPU|CALLER ()
        true
    )
    (defcap P|SWPU|REMOTE-GOV ()
        true
    )
    (defcap P|DT ()
        (compose-capability (P|SWPU|REMOTE-GOV))
        (compose-capability (P|SWPU|CALLER))
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
        (with-capability (GOV|SWPU_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|SWPU_ADMIN)
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
                (ref-U|G:module{OuronetGuards} U|G)
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|ATSU:module{OuronetPolicy} ATSU)
                (ref-P|VST:module{OuronetPolicy} VST)
                (ref-P|LIQUID:module{OuronetPolicy} LIQUID)
                (ref-P|ORBR:module{OuronetPolicy} OUROBOROS)
                (ref-P|SWPT:module{OuronetPolicy} SWPT)
                (ref-P|SWP:module{OuronetPolicy} SWP)
                (mg:guard (create-capability-guard (P|SWPU|CALLER)))
            )
            (ref-P|DALOS::P|A_Add
                "SWPU|RemoteDalosGov"
                (create-capability-guard (P|SWPU|REMOTE-GOV))
            )
            (ref-P|VST::P|A_Add
                "SWPU|RemoteSwpGov"
                (create-capability-guard (P|SWPU|REMOTE-GOV))
            )
            (ref-P|SWP::P|A_Add
                "SWPU|RemoteSwpGov"
                (create-capability-guard (P|SWPU|REMOTE-GOV))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|DPMF::P|A_AddIMP mg)
            (ref-P|ATS::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|ATSU::P|A_AddIMP mg)
            (ref-P|VST::P|A_AddIMP mg)
            (ref-P|LIQUID::P|A_AddIMP mg)
            (ref-P|ORBR::P|A_AddIMP mg)
            (ref-P|SWPT::P|A_AddIMP mg)
            (ref-P|SWP::P|A_AddIMP mg)
        )
    )
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
                (mp:[guard] (P|UR_IMP))
                (g:guard (ref-U|G::UEV_GuardOfAny mp))
            )
            (enforce-guard g)
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
    (defcap SWPU|S>FEED-SPECIAL-TARGETS 
        (id:string total-amount:decimal targets:[string] target-proportions:[decimal] target-amounts:[decimal])
        @event
        true
    )
    (defcap SWPU|S>LIQUID-BOOST (id:string total-amount:decimal idx-increment:decimal)
        @event
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap SPWU|C>TOGGLE-SWAP (swpair:string toggle:bool)
        (if toggle
            (let
                (
                    (ref-SWP:module{SwapperV4} SWP)
                    (ref-SWPI:module{SwapperIssueV2} SWPI)
                    (pool-worth:decimal (at 0 (ref-SWPI::URC_PoolValue swpair)))
                    (inactive-limit:decimal (ref-SWP::UR_InactiveLimit))
                )
                (enforce
                    (> pool-worth inactive-limit)
                    (format "Pool {} cannot have its Swap Functionality turned on because its worth is {} DWK, and a {} DWK Value is required for swap" [swpair pool-worth inactive-limit])
                )
            )
            true
        )
        (compose-capability (P|SWPU|CALLER))
    )
    (defcap SWPU|OPU|C>SINGL-SWAP-WITH-SLIPPAGE
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:decimal)
        @event
        (compose-capability (SWPU|X>SWAP swpair dsid))
        true
    )
    (defcap SWPU|OPU|C>SINGL-SWAP-NO-SLIPPAGE
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:decimal)
        @event
        (compose-capability (SWPU|X>SWAP swpair dsid))
        true
    )
    (defcap SWPU|OPU|C>MULTI-SWAP-WITH-SLIPPAGE
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:decimal)
        @event
        (compose-capability (SWPU|X>SWAP swpair dsid))
        true
    )
    (defcap SWPU|OPU|C>MULTI-SWAP-NO-SLIPPAGE
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:decimal)
        @event
        (compose-capability (SWPU|X>SWAP swpair dsid))
        true
    )
    (defcap SWPU|C>SINGL-SWAP-WITH-SLIPPAGE
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:decimal)
        @event
        (compose-capability (SWPU|X>SWAP swpair dsid))
        true
    )
    (defcap SWPU|C>SINGL-SWAP-NO-SLIPPAGE
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:decimal)
        @event
        (compose-capability (SWPU|X>SWAP swpair dsid))
        true
    )
    (defcap SWPU|C>MULTI-SWAP-WITH-SLIPPAGE
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:decimal)
        @event
        (compose-capability (SWPU|X>SWAP swpair dsid))
        true
    )
    (defcap SWPU|C>MULTI-SWAP-NO-SLIPPAGE
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:decimal)
        @event
        (compose-capability (SWPU|X>SWAP swpair dsid))
        true
    )
    (defcap SWPU|X>SWAP (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData})
        (let
            (
                ;;Unwrap Object Data
                (input-ids:[string] (at "input-ids" dsid))
                (input-amounts:[decimal] (at "input-amounts" dsid))
                (output-id:string (at "output-id" dsid))
                ;;
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                (l1:integer (length input-ids))
                (l2:integer (length input-amounts))
                (can-swap:bool (ref-SWP::UR_CanSwap swpair))
                (izo:bool (ref-U|SWP::UC_IzOnPool output-id swpair))
            )
            (enforce izo (format "{} is not part of SwapPool {}" [output-id swpair]))
            (enforce can-swap (format "Pool {} swap functionality is inactive: cannot Swap Tokens" [swpair]))
            (enforce (= l1 l2) "Invalid input Values")
            (map
                (lambda
                    (idx:integer)
                    (let*
                        (
                            (id:string (at idx input-ids))
                            (amount:decimal (at idx input-amounts))
                            (iop:bool (ref-U|SWP::UC_IzOnPool id swpair))
                        )
                        (enforce iop (format "Input Token id {} is not part of Liquidity Pool {}" [id swpair]))
                        (ref-DPTF::UEV_Amount id amount)
                    )
                )
                (enumerate 0 (- l1 1))
            )
            (compose-capability (P|DT))
            (compose-capability (SECURE))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_SlippageMinMax:[decimal] (input:object{SwapperUsageV4.Slippage})
        (let
            (
                (expected:decimal (at "expected-output-amount" input))
                (o-prec:integer (at "output-precision" input))
                (sp:decimal (at "slippage-percent" input))
                (slippage:decimal (floor (/ sp 100.0) 4))
                (plus-minus-value:decimal (floor (* slippage expected) o-prec))
                (min:decimal (- expected plus-minus-value))
                (max:decimal (+ expected plus-minus-value))
            )
            [min max]
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    (defun UDC_Slippage:object{SwapperUsageV4.Slippage}
        (a:decimal b:integer c:decimal)
        {"expected-output-amount"   : a
        ,"output-precision"         : b
        ,"slippage-percent"         : c}
    )
    (defun UDC_SlippageObject:object{SwapperUsageV4.Slippage}
        (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage-value:decimal)
        @doc "Makes a Slippage Object from <input amounts>"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-SWPI:module{SwapperIssueV2} SWPI)
                (o-prec:integer (ref-DPTF::UR_Decimals (at "output-id" dsid)))
                (expected:decimal (ref-SWPI::URC_Swap swpair dsid false))
            )
            (enforce
                (= (floor slippage-value 2) slippage-value)
                (format "{} is not slippage conform decimal wise (max 2 decimals allowed)" [slippage-value])
            )
            (enforce
                (and
                    (> slippage-value 0.0)
                    (<= slippage-value 50.0)
                )
                "Slippage must be greater than 0.0 and maximum 50.0, or -1.0 for no slippage"
            )
            (UDC_Slippage expected o-prec slippage-value)
        )
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_ToggleSwapCapability:object{IgnisCollector.OutputCumulator}
        (swpair:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
            )
            (with-capability (SPWU|C>TOGGLE-SWAP swpair toggle)
                (ref-SWP::C_ToggleAddOrSwap swpair toggle false)
            )
        )
    )
    (defun C_Swap:object{IgnisCollector.OutputCumulator}
        (account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:decimal kda-pid:decimal)
        (UEV_IMC)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWP:module{SwapperV4} SWP)
                (dsid:object{UtilitySwpV2.DirectSwapInputData}
                    (ref-U|SWP::UDC_DirectSwapInputData input-ids input-amounts output-id)
                )
                (pp:string (ref-SWP::UR_PrimordialPool))
                (l:integer (length input-ids))
                (s-or-m:bool (if (= l 1) true false))
            )
            (if (= swpair pp)
                (if s-or-m
                    (if (!= slippage -1.0)
                        (with-capability (SWPU|OPU|C>SINGL-SWAP-WITH-SLIPPAGE account swpair dsid slippage)
                            (XI|KDA-PID_Swap account swpair dsid slippage kda-pid)
                        )
                        (with-capability (SWPU|OPU|C>SINGL-SWAP-NO-SLIPPAGE account swpair dsid slippage)
                            (XI|KDA-PID_Swap account swpair dsid slippage kda-pid)
                        )
                    )
                    (if (!= slippage -1.0)
                        (with-capability (SWPU|OPU|C>MULTI-SWAP-WITH-SLIPPAGE account swpair dsid slippage)
                            (XI|KDA-PID_Swap account swpair dsid slippage kda-pid)
                        )
                        (with-capability (SWPU|OPU|C>MULTI-SWAP-NO-SLIPPAGE account swpair dsid slippage)
                            (XI|KDA-PID_Swap account swpair dsid slippage kda-pid)
                        )
                    )
                )
                (if s-or-m
                    (if (!= slippage -1.0)
                        (with-capability (SWPU|C>SINGL-SWAP-WITH-SLIPPAGE account swpair dsid slippage)
                            (XI|KDA-PID_Swap account swpair dsid slippage -1.0)
                        )
                        (with-capability (SWPU|C>SINGL-SWAP-NO-SLIPPAGE account swpair dsid slippage)
                            (XI|KDA-PID_Swap account swpair dsid slippage -1.0)
                        )
                    )
                    (if (!= slippage -1.0)
                        (with-capability (SWPU|C>MULTI-SWAP-WITH-SLIPPAGE account swpair dsid slippage)
                            (XI|KDA-PID_Swap account swpair dsid slippage -1.0)
                        )
                        (with-capability (SWPU|C>MULTI-SWAP-NO-SLIPPAGE account swpair dsid slippage)
                            (XI|KDA-PID_Swap account swpair dsid slippage -1.0)
                        )
                    )
                )
            )
        )
    )
    ;;{F7}
    (defun XI|KDA-PID_Swap:object{IgnisCollector.OutputCumulator}
        (
            account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData}
            slippage:decimal kda-pid:decimal
        )
        (let
            (
                (ico:object{IgnisCollector.OutputCumulator}
                    (if (= slippage -1.0)
                        (XI_Swap account swpair dsid)
                        (let
                            (
                                (ref-SWPI:module{SwapperIssueV2} SWPI)
                                ;;
                                (max-toa:decimal (ref-SWPI::URC_Swap swpair dsid true))
                                (min-max:[decimal] (UC_SlippageMinMax (UDC_SlippageObject swpair dsid slippage)))
                                (min:decimal (at 0 min-max))
                                (max:decimal (at 1 min-max))
                                (exceed-message:string
                                    (format
                                        "Expected Output of {} out of Slippage bounds min of {} - max of {}"
                                        [max-toa min max]
                                    )
                                )
                            )
                            (if
                                (and
                                    (>= max-toa min)
                                    (<= max-toa max)
                                )
                                (XI_Swap account swpair dsid)
                                {"cumulator-chain"      :
                                    [
                                        {"ignis"        : 0.0
                                        ,"interactor"   : BAR}
                                    ]
                                ,"output"               : [exceed-message]}
                            )
                        )
                    )
                )
            )
            (if (> kda-pid 0.0)
                (XI|KDA-PID_OPU swpair kda-pid)
                true
            )
            ico
        )
    )
    (defun XI_Swap:object{IgnisCollector.OutputCumulator}
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData})
        (require-capability (SWPU|X>SWAP swpair dsid))
        (let
            (
                ;;Unwrap Object Data
                (input-ids:[string] (at "input-ids" dsid))
                (input-amounts:[decimal] (at "input-amounts" dsid))
                (output-id:string (at "output-id" dsid))
                ;;
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-TFT:module{TrueFungibleTransferV7} TFT)
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPI:module{SwapperIssueV2} SWPI)
                (ref-SWPL:module{SwapperLiquidity} SWPL)
                (ref-SWPLC:module{SwapperLiquidityClient} SWPLC)
                ;;
                ;;
                (pool-type:string (ref-U|SWP::UC_PoolType swpair))
                (fees:object{UtilitySwpV2.SwapFeez} (ref-SWPL::UDC_PoolFees swpair))
                (A:decimal (ref-SWP::UR_Amplifier swpair))
                (X:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (X-prec:[integer] (ref-SWP::UR_PoolTokenPrecisions swpair))
                (input-positions:[integer] (ref-SWPI::URC_PoolTokenPositions swpair input-ids))
                (output-position:integer (ref-SWP::UR_PoolTokenPosition swpair output-id))
                (W:[decimal] (ref-SWP::UR_Weigths swpair))
                ;;
                ;;Do Swap Computation and Unwrap Object Data
                (dtso:object{UtilitySwpV2.DirectTaxedSwapOutput}
                    (ref-SWPI::UC_BareboneSwapWithFeez account pool-type dsid fees A X X-prec input-positions output-position W)
                )
                (lp-fuel:[decimal] (at "lp-fuel" dtso))
                (o-id-special:decimal (at "o-id-special" dtso))
                (o-id-liquid:decimal (at "o-id-liquid" dtso))
                (o-id-netto:decimal (at "o-id-netto" dtso))
                ;;
                (ico1:object{IgnisCollector.OutputCumulator}
                    (ref-TFT::C_MultiTransfer input-ids account SWP|SC_NAME input-amounts true)
                )
                (ico2:object{IgnisCollector.OutputCumulator}
                    (ref-SWPLC::C_Fuel account swpair lp-fuel false false)
                )
                (pt-amounts-after-fuel-update:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (dra:[decimal] (ref-SWPI::URC_DirectRefillAmounts swpair input-ids input-amounts))
                (dra-o:[decimal] (ref-SWPI::URC_DirectRefillAmounts swpair [output-id] [(fold (+) 0.0 [o-id-special o-id-liquid o-id-netto])]))
                (remaining-amounts-for-update:[decimal] (zip (-) (zip (-) dra lp-fuel) dra-o))
                (new-balances:[decimal] (zip (+) pt-amounts-after-fuel-update remaining-amounts-for-update))
                (ico3:object{IgnisCollector.OutputCumulator}
                    (if (!= o-id-special 0.0)
                        (let
                            (
                                (o-prec:integer (at output-position X-prec))
                                (special-fee-targets:[string] (ref-SWP::UR_SpecialFeeTargets swpair))
                                (target-proportions:[decimal] (ref-SWP::UR_SpecialFeeTargetsProportions swpair))
                                (target-amounts:[decimal] (ref-U|SWP::UC_SpecialFeeOutputs target-proportions o-id-special o-prec))
                            )
                            (with-capability (SWPU|S>FEED-SPECIAL-TARGETS output-id o-id-special special-fee-targets target-proportions target-amounts)
                                (ref-TFT::C_MultiBulkTransfer
                                    [output-id]
                                    SWP|SC_NAME
                                    [(+ [account] special-fee-targets)]
                                    [(+ [o-id-netto] target-amounts)]
                                )
                            )
                        )
                        (ref-TFT::C_Transfer output-id SWP|SC_NAME account o-id-netto true)
                    )
                )
            )
            ;;Execute Swap Exchange
            ;;1]Move all Input Tokens to SWP|SC_NAME via ico1
            ;;2]Fuel the <swpair> increasing LP Value, scaling with swpair <fee-lp> via ico2
            ;;3]Update <swpair> with the remaining Pool Token Amounts
            (ref-SWP::XE_UpdateSupplies swpair new-balances)
            ;;4]Handle Swap Client and Special Targets, if they exist, via ico3
            ;;5]Handle Liquid Boost via output-ico
            (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators 
                [
                    ico1 ico2 ico3
                    (if (!= o-id-liquid 0.0)
                        (XI_LiquidIndexPump output-id o-id-liquid)
                        EOC
                    )
                ] 
                [o-id-netto]
            )
        )
    )
    (defun XI_LiquidIndexPump:object{IgnisCollector.OutputCumulator}
        (id:string amount:decimal)
        (require-capability (SECURE))
        (let
            (
                (ico:object{IgnisCollector.OutputCumulator}
                    (XI_RawLiquidPump id amount)
                )
                (raw-liquid-pump-data:list (at "output" ico))
                (increment:decimal (at 0 raw-liquid-pump-data))
            )
            (with-capability (SWPU|S>LIQUID-BOOST id amount increment)
                (XI_Pumpdate raw-liquid-pump-data)
            )
            ico
        )
    )
    (defun XI_RawLiquidPump:object{IgnisCollector.OutputCumulator} 
        (id:string amount:decimal)
        @doc "Operation that pumps LiquidIndex, returns the Pump Increment in the output object \
            \ Can be used for a Pool Token that already exists in the SWP|SC_NAME"
        (require-capability (SECURE))
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-ATS:module{AutostakeV4} ATS)
                ;;
                (lkda:string (ref-DALOS::UR_LiquidKadenaID))
                (liquidindex:string (at 0 (ref-DPTF::UR_RewardBearingToken lkda)))
                (lqi:decimal (ref-ATS::URC_Index liquidindex))
            )
            (if (= id lkda)
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators 
                    [(ref-DPTF::C_Burn lkda SWP|SC_NAME amount)] 
                    [(- (ref-ATS::URC_Index liquidindex) lqi)]
                )
                (let
                    (
                        (ref-SWPI:module{SwapperIssueV2} SWPI)
                        ;;
                        (h-obj:object{SwapperIssueV2.Hopper} (ref-SWPI::URC_Hopper id lkda amount))
                        (path-to-lkda:[string] (at "nodes" h-obj))
                        (edges:[string] (at "edges" h-obj))
                        (ovs:[decimal] (at "output-values" h-obj))
                        (final-boost-output:decimal (at 0 (take -1 ovs)))
                        (ico:object{IgnisCollector.OutputCumulator}
                            (ref-DPTF::C_Burn lkda SWP|SC_NAME final-boost-output)
                        )
                    )
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators 
                        [ico] 
                        [(- (ref-ATS::URC_Index liquidindex) lqi) path-to-lkda edges ovs amount]
                    )
                )
            )
        )
    )
    (defun XI_Pumpdate (raw-liquid-pump-data:list)
        (require-capability (SECURE))
        (if (= (length raw-liquid-pump-data) 5)
            (let
                (
                    (ref-SWP:module{SwapperV4} SWP)
                    (path-to-dlk:[string] (at 1 raw-liquid-pump-data))
                    (edges:[string] (at 2 raw-liquid-pump-data))
                    (ovs:[decimal] (at 3 raw-liquid-pump-data))
                    (amount:decimal (at 4 raw-liquid-pump-data))
                    (le:integer (length edges))
                )
                (map
                    (lambda
                        (idx:integer)
                        (let
                            (
                                (first-id:string (at idx path-to-dlk))
                                (second-id:string (at (+ idx 1) path-to-dlk))
                                (hop:string (at idx edges))
                                (first-amount:decimal
                                    (if (= idx 0)
                                        amount
                                        (at (- idx 1) ovs)
                                    )
                                )
                                (second-amount:decimal (at idx ovs))
                                (f-id-hop-a:decimal (ref-SWP::UR_PoolTokenSupply hop first-id))
                                (s-id-hop-a:decimal (ref-SWP::UR_PoolTokenSupply hop second-id))
                            )
                            (ref-SWP::XE_UpdateSupply hop first-id (+ f-id-hop-a first-amount))
                            (ref-SWP::XE_UpdateSupply hop second-id (- s-id-hop-a second-amount))
                        )
                    )
                    (enumerate 0 (- le 1))
                )
            )
            true
        )
    )
    (defun XI|KDA-PID_OPU (swpair:string kda-pid:decimal)
        @doc "If <swpair> is primordial, <ouro-auto-price-via-swaps> is true, and \
            \ Ouro price moves more that 1 promile, update price"
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (iz-auto:bool (ref-DALOS::UR_OuroAutoPriceUpdate))
            )
            (if iz-auto
                (let
                    (
                        (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                        (ref-SWPI:module{SwapperIssueV2} SWPI)
                        (ouro-id:string (ref-DALOS::UR_OuroborosID))
                        (ouro-prec:integer (ref-DPTF::UR_Decimals ouro-id))
                        (stored-ouro-price:decimal (ref-DALOS::UR_OuroborosPrice))
                        (current-ouro-price:decimal (ref-SWPI::URC_OuroPrimordialPrice))
                        (dev:decimal 0.001)
                        (min:decimal (floor (* stored-ouro-price (- 1.0 dev)) ouro-prec))
                        (max:decimal (floor (* stored-ouro-price (+ 1.0 dev)) ouro-prec))
                        (iz-update:bool
                            (if (or (< current-ouro-price min) (> current-ouro-price max))
                                true false
                            )
                        )
                    )
                    (if iz-update
                        (ref-DALOS::XB_UpdateOuroPrice current-ouro-price)
                        true
                    )
                )
                true
            )
        )
    )
)

(create-table P|T)
(create-table P|MT)