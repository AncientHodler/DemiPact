;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface SwapperUsage
    @doc "Exposes Adding|Removing Liquidty and Swapping Functions of the SWP Module"
    (defschema Slippage
        expected-output-amount:decimal
        output-precision:integer
        slippage-percent:decimal
    )
    (defschema Hopper
        nodes:[string]
        edges:[string]
        output-values:[decimal]
    )
    ;;
    (defun SWPS|UC_SlippageMinMax:[decimal] (input:object{Slippage}))
    ;;
    (defun URC_SingleWorthDWK (id:string))
    (defun URC_WorthDWK (id:string amount:decimal))
    (defun URC_PoolWorthDWK:decimal (swpair:string))
    ;;
    (defun SWPLC|URC_AreAmountsBalanced:bool (swpair:string input-amounts:[decimal]))
    (defun SWPLC|URC_LpCapacity:decimal (swpair:string))
    (defun SWPLC|URC_BalancedLiquidity:[decimal] (swpair:string input-id:string input-amount:decimal))
    (defun SWPLC|URC_SymetricLpAmount:decimal (swpair:string input-id:string input-amount:decimal))
    (defun SWPLC|URC_LpBreakAmounts:[decimal] (swpair:string input-lp-amount:decimal))
    (defun SWPLC|URC_LpAmount:decimal (swpair:string input-amounts:[decimal]))
    (defun SWPLC|URC_WP_LpAmount:decimal (swpair:string input-amounts:[decimal]))
    (defun SWPLC|URC_S_LpAmount:decimal (swpair:string input-amounts:[decimal]))
    (defun SWPLC|URC_AddLiquidityIgnisCost:decimal (swpair:string input-amounts:[decimal]))
    ;;
    (defun SWPSC|URC_Swap:decimal (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string))
    (defun SWPSC|URC_ProductSwap:decimal (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string))
    (defun SWPSC|URC_StableSwap:decimal (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string))
    (defun SWPSC|URC_BestEdge:string (ia:decimal i:string o:string))
    (defun SWPSC|URC_Hopper:object{Hopper} (hopper-input-id:string hopper-output-id:string hopper-input-amount:decimal))
    ;;
    (defun SPWS|UDC_SlippageObject:object{Slippage} (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage-value:decimal))
    ;;
    (defun SWPI|C_Issue:object{OuronetDalos.IgnisCumulator} (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool))
    (defun SWPI|C_IssueStableMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal amp:decimal p:bool))
    (defun SWPI|C_IssueStandardMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal p:bool))
    (defun SWPI|C_IssueWeightedMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool))
    (defpact SWPI|C_IssueMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool))
    ;;
    (defun C_ToggleAddLiquidity:object{OuronetDalos.IgnisCumulator} (patron:string swpair:string toggle:bool))
    (defun C_ToggleSwapCapability:object{OuronetDalos.IgnisCumulator} (patron:string swpair:string toggle:bool))
    ;;
    (defun SWPL|C_AddBalancedLiquidity:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-id:string input-amount:decimal))
    (defun SWPL|C_AddLiquidity:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-amounts:[decimal]))
    (defun SWPL|C_RemoveLiquidity:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string lp-amount:decimal))
    ;;
    (defun SWPS|C_SimpleSwap:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string slippage:object{Slippage}))
    (defun SWPS|C_SimpleSwapNoSlippage:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string))
    (defun SWPS|C_MultiSwap:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:object{Slippage}))
    (defun SWPS|C_MultiSwapNoSlippage:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string))
)
(module SWPU GOV
    ;;
    (implements OuronetPolicy)
    (implements SwapperUsage)
    ;;{G1}
    (defconst GOV|MD_SWPU           (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|SWPU_ADMIN)))
    (defcap GOV|SWPU_ADMIN ()       (enforce-guard GOV|MD_SWPU))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
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
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|SWPU_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
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
            )
            (ref-P|DALOS::P|A_Add 
                "SWPU|<"
                (create-capability-guard (P|SWPU|CALLER))
            )
            (ref-P|BRD::P|A_Add 
                "SWPU|<"
                (create-capability-guard (P|SWPU|CALLER))
            )
            (ref-P|DPTF::P|A_Add 
                "SWPU|<"
                (create-capability-guard (P|SWPU|CALLER))
            )
            (ref-P|DPMF::P|A_Add 
                "SWPU|<"
                (create-capability-guard (P|SWPU|CALLER))
            )
            (ref-P|ATS::P|A_Add 
                "SWPU|<"
                (create-capability-guard (P|SWPU|CALLER))
            )
            (ref-P|TFT::P|A_Add 
                "SWPU|<"
                (create-capability-guard (P|SWPU|CALLER))
            )
            (ref-P|ATSU::P|A_Add
                "SWPU|<"
                (create-capability-guard (P|SWPU|CALLER))
            )
            (ref-P|VST::P|A_Add 
                "SWPU|<"
                (create-capability-guard (P|SWPU|CALLER))
            )
            (ref-P|LIQUID::P|A_Add 
                "SWPU|<"
                (create-capability-guard (P|SWPU|CALLER))
            )
            (ref-P|ORBR::P|A_Add 
                "SWPU|<"
                (create-capability-guard (P|SWPU|CALLER))
            )
            (ref-P|SWPT::P|A_Add 
                "SWPU|<"
                (create-capability-guard (P|SWPU|CALLER))
            )
            (ref-P|SWP::P|A_Add 
                "SWPU|<"
                (create-capability-guard (P|SWPU|CALLER))
            )
            (ref-P|DALOS::P|A_Add 
                "SWPU|RemoteDalosGov"
                (create-capability-guard (P|SWPU|REMOTE-GOV))
            )
            (ref-P|SWP::P|A_Add
                "SWPU|RemoteSwpGov"
                (create-capability-guard (P|SWPU|REMOTE-GOV))
            )
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    (defconst EMPTY_HOPPER
        [
            {
                "nodes" : [],
                "edges" : [],
                "output-values" : []
            }
        ]
    )
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defun CT_EmptyIgnisCumulator ()(let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::DALOS|EmptyIgCum)))
    (defconst BAR                   (CT_Bar))
    (defconst EIC                   (CT_EmptyIgnisCumulator))
    ;;
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap SWPI|C>ISSUE (account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        @event
        (SWPI|UEV_Issue account pool-tokens fee-lp weights amp p)
        (compose-capability (SWPI|X>ISSUE p))
    )
    (defcap SWPI|C>PACT-ISSUE (p:bool)
        @event
        (compose-capability (SWPI|X>ISSUE p))
    )
    (defcap SWPI|X>ISSUE (p:bool)
        (compose-capability (P|SWPU|CALLER))
        (compose-capability (P|SWPU|REMOTE-GOV))
        (if p
            (compose-capability (GOV|SWPU_ADMIN))
            true
        )
    )
    ;;
    (defcap SPW|C>TOGGLE-SWAP (swpair:string toggle:bool)
        (if toggle
            (let
                (
                    (ref-SWP:module{Swapper} SWP)
                    (pool-worth:decimal (URC_PoolWorthDWK swpair))
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
    (defcap SWPL|C>ADD_LQ (swpair:string input-amounts:[decimal])
        @event
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Swapper} SWP)
                (can-add:bool (ref-SWP::UR_CanAdd swpair))
                (pool-token-ids:[string] (ref-SWP::UR_PoolTokens swpair))
                (l0:integer (length input-amounts))
                (l1:integer (length pool-token-ids))
                (lengths:[integer] [l0 l1])
            )
            (ref-U|INT::UEV_UniformList lengths)
            (ref-SWP::UEV_id swpair)
            (map
                (lambda 
                    (idx:integer)
                    (if (> (at idx input-amounts) 0.0)
                        (ref-DPTF::UEV_Amount (at idx pool-token-ids) (at idx input-amounts))
                        true
                    )
                )
                (enumerate 0 (- l0 1))
            )
            (enforce can-add "Pool is inactive: cannot add or remove liqudity!")
        )
        (compose-capability (P|DT))
        (compose-capability (SECURE))
    )
    (defcap SWPL|C>RM_LQ (swpair:string lp-amount:decimal)
        @event
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Swapper} SWP)
                (can-add:bool (ref-SWP::UR_CanAdd swpair))
                (lp-id:string (ref-SWP::UR_TokenLP swpair))
                (pool-lp-amount:decimal (ref-DPTF::UR_Supply lp-id))
            )
            (ref-DPTF::UEV_Amount lp-id lp-amount)
            (ref-SWP::UEV_id swpair)
            (enforce (<= lp-amount pool-lp-amount) (format "{} is an invalid LP Amount for removing Liquidity" [lp-amount]))
            (enforce can-add "Pool is inactive: cannot add or remove liqudity!")
        )
        (compose-capability (P|DT))
        (compose-capability (SECURE))
    )
    (defcap SWPS|C>PUMP_LQ-IDX ()
        @event
        (compose-capability (P|SWPU|CALLER))
    )
    (defcap SWPS|C>SWAP (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        @event
        (let
            (
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Swapper} SWP)
                (l1:integer (length input-ids))
                (l2:integer (length input-amounts))
                (can-swap:bool (ref-SWP::UR_CanSwap swpair))
                (izo:bool (ref-U|SWP::UC_IzOnPool output-id swpair))
            )
            (ref-SWP::UEV_id swpair)
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
            (compose-capability (P|SWPU|REMOTE-GOV))
            (compose-capability (SWPS|C>PUMP_LQ-IDX))
        )
    )
    ;;
    ;;{FC}
    (defun SWPS|UC_SlippageMinMax:[decimal] (input:object{Slippage})
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
    ;;{F0}
    ;;{F1}
    (defun URC_SingleWorthDWK (id:string)
        (URC_WorthDWK id 1.0)
    )
    (defun URC_WorthDWK (id:string amount:decimal)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (dwk:string (ref-DALOS::UR_WrappedKadenaID))
                (dlk:string (ref-DALOS::UR_LiquidKadenaID))
            )
            (if (= id dwk)
                amount
                (if (= id dlk)
                    (let
                        (
                            (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                            (ref-ATS:module{Autostake} ATS)
                            (ats-pairs-with-dlk-id:[string] (ref-DPTF::UR_RewardBearingToken dlk))
                            (kdaliquindex:string (at 0 ats-pairs-with-dlk-id))
                            (index-value:decimal (ref-ATS::URC_Index kdaliquindex))
                            (dlk-prec:integer (ref-DPTF::UR_Decimals dlk))
                        )
                        (floor (* amount index-value) dlk-prec)
                    )
                    (let
                        (
                            (h-obj:object{SwapperUsage.Hopper} (SWPSC|URC_Hopper id dwk amount))
                            (ovs:[decimal] (at "output-values" h-obj))
                        )
                        (at 0 (take -1 ovs))
                    )
                )
            )
        )
    )
    (defun URC_PoolWorthDWK:decimal (swpair:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Swapper} SWP)
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (pool-token-supplies:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (how-many:integer (length pool-tokens))
                (first-token:string (at 0 pool-tokens))
                (first-token-supply:decimal (at 0 pool-token-supplies))
                (first-token-precision:integer (ref-DPTF::UR_Decimals first-token))
                (pool-type:string (take 1 swpair))
                (first-weigth:decimal (at 0 (ref-SWP::UR_Weigths swpair)))
                (first-worth:decimal (URC_WorthDWK first-token first-token-supply))
            )
            (if (or (= pool-type "S") (= pool-type "P"))
                (floor (* (dec how-many) first-worth) first-token-precision)
                (floor (/ first-worth first-weigth) first-token-precision)
            )
        )
    )
    (defun SWPLC|URC_AreAmountsBalanced:bool (swpair:string input-amounts:[decimal])
        @doc "Determines if <input-amounts> are balanced accoriding to <swpair>"
        (let
            (
                (sum:decimal (fold (+) 0.0 input-amounts))
            )
            (enforce (> sum 0.0) "At least a single input value must be greater than zero!")
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-SWP:module{Swapper} SWP)
                    (positive-amounts:[decimal] (ref-U|LST::UC_RemoveItem input-amounts 0.0))
                    (first-positive-amount:decimal (at 0 positive-amounts))
                    (positive-amounts-positions:[integer] (ref-U|LST::UC_Search input-amounts first-positive-amount))
                    (first-positive-position:integer (at 0 positive-amounts-positions))
                    (first-positive-id:string (at first-positive-position (ref-SWP::UR_PoolTokens swpair)))
                    (balanced-amounts:[decimal] (SWPLC|URC_BalancedLiquidity swpair first-positive-id first-positive-amount))
                )
                (if (= balanced-amounts input-amounts)
                    true
                    false
                )
            )
        )
    )
    (defun SWPLC|URC_LpCapacity:decimal (swpair:string)
        @doc "Computes the LP Capacity of a Given Swap Pair"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Swapper} SWP)
                (token-lp:string (ref-SWP::UR_TokenLP swpair))
                (token-lps:[string] (ref-SWP::UR_TokenLPS swpair))
                (token-lp-supply:decimal (ref-DPTF::UR_Supply token-lp))
            )
            (ref-SWP::UEV_id swpair)
            (if (= token-lps [BAR])
                token-lp-supply
                (let
                    (
                        (token-lps-supplies:[decimal]
                            (fold
                                (lambda
                                    (acc:[decimal] idx:integer)
                                    (ref-U|LST::UC_AppL 
                                        acc 
                                        (ref-DPTF::UR_Supply (at idx token-lps))
                                    )
                                )
                                []
                                (enumerate 0 (- (length token-lps) 1))
                            )
                        )
                        (sum:decimal (fold (+) 0.0 token-lps-supplies))
                    )
                    (+ token-lp-supply sum)
                )
            )
        )
    )
    (defun SWPLC|URC_BalancedLiquidity:[decimal] (swpair:string input-id:string input-amount:decimal)
        @doc "Outputs the amount of tokens, for given <input-id> and <input-amount> that are needed to add Balanced Liquidity"
        (let
            (
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Swapper} SWP)
                (pool-token-ids:[string] (ref-SWP::UR_PoolTokens swpair))
                (iz-on-pool:bool (ref-SWP::UEV_CheckAgainst [input-id] pool-token-ids))
            )
            (ref-SWP::UEV_id swpair)
            (ref-DPTF::UEV_Amount input-id input-amount)
            (enforce iz-on-pool (format "Input Token {} is not part of the Pool {} Tokens" [input-id swpair]))
            (let
                (
                    (input-position:integer (ref-SWP::UR_PoolTokenPosition swpair input-id))
                    (input-precision:integer (ref-DPTF::UR_Decimals input-id))
                    (X:[decimal]
                        (if (= (SWPLC|URC_LpCapacity swpair) 0.0)
                            (ref-SWP::UR_PoolGenesisSupplies swpair)
                            (ref-SWP::UR_PoolTokenSupplies swpair)
                        )
                    )
                    (Xp:[integer] (ref-SWP::UR_PoolTokenPrecisions swpair))
                )
                (ref-U|SWP::UC_BalancedLiquidity input-amount input-position input-precision X Xp)
            )
        )
    )
    (defun SWPLC|URC_SymetricLpAmount:decimal (swpair:string input-id:string input-amount:decimal)
        @doc "Computes the Amount of LP resulted, if balanced Liquidity (derived from <input-id> and <input-amount>) \
        \ were to be added to an <swpair>"
        (let
            (
                (pt:string (take 1 swpair))
            )
            (if (or (= pt "W")(= pt "P"))
                (SWPLC|URC_WP_LpAmount swpair (SWPLC|URC_BalancedLiquidity swpair input-id input-amount))
                (SWPLC|URC_S_LpAmount swpair (SWPLC|URC_BalancedLiquidity swpair input-id input-amount))
            )
        )   
    )
    (defun SWPLC|URC_LpBreakAmounts:[decimal] (swpair:string input-lp-amount:decimal)
        @doc "Computes the Pool Token Amounts that result from removing <input-lp-amount> of LP Token"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-SWP:module{Swapper} SWP)
                (lp-supply:decimal (SWPLC|URC_LpCapacity swpair))
                (ratio:decimal (floor (/ input-lp-amount lp-supply) 24))
                (pool-token-supplies:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (pool-token-precisions:[integer] (ref-SWP::UR_PoolTokenPrecisions swpair))
            )
            (if (= input-lp-amount lp-supply)
                pool-token-supplies
                (fold
                    (lambda
                        (acc:[decimal] idx:integer)
                        (ref-U|LST::UC_AppL 
                            acc 
                            (floor (* ratio (at idx pool-token-supplies)) (at idx pool-token-precisions))
                        )
                    )
                    []
                    (enumerate 0 (- (length pool-token-supplies) 1))
                )
            )
        )
    )
    (defun SWPLC|URC_LpAmount:decimal (swpair:string input-amounts:[decimal])
        @doc "Computes the LP Amount resulting from adding Liquidity with <input-amount> Tokens on <swpair> Pool"
        (let
            (
                (pt:string (take 1 swpair))
            )
            (if (or (= pt "W")(= pt "P"))
                (SWPLC|URC_WP_LpAmount swpair input-amounts)
                (SWPLC|URC_S_LpAmount swpair input-amounts)
            )
        )
    )
    (defun SWPLC|URC_WP_LpAmount:decimal (swpair:string input-amounts:[decimal])
        @doc "Computes the LP Amount you get on a Constant Product Weigthed or non-Weigthed Pool, when adding the <input-amounts> of Pool Tokens as Liquidity \
        \ The <input-amounts> must contain amounts for all pool tokens, using 0.0 for Pool Tokens that arent being used \
        \ The pool token order is used for the <input-amounts> variable; \
        \ There is no Liquidity fee when computing the amount for a Constant Product Weigthed Pool, since it has no concept of balance."
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|VST:module{UtilityVst} U|VST)
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Swapper} SWP)
                (pt:string (take 1 swpair))
                (lp-prec:integer (ref-DPTF::UR_Decimals (ref-SWP::UR_TokenLP swpair)))
                (read-lp-supply:decimal (SWPLC|URC_LpCapacity swpair))
                (lp-supply:decimal 
                    (if (= read-lp-supply 0.0)
                        10000000.0
                        read-lp-supply
                    )
                )
                (pool-token-supplies:[decimal] 
                    (if (= read-lp-supply 0.0)
                        (ref-SWP::UR_PoolGenesisSupplies swpair)
                        (ref-SWP::UR_PoolTokenSupplies swpair)
                    )
                )
                (li:integer (length input-amounts))
                (lc:integer (length pool-token-supplies))
                (iz-balanced:bool (SWPLC|URC_AreAmountsBalanced swpair input-amounts))
            )
            (enforce (or (= pt "W")(= pt "P")) "Only for W or P Pools")
            (enforce (= li lc) "Incorrect Pool Token Ammounts")
            (ref-SWP::UEV_id swpair)
            (if iz-balanced
                (ref-U|SWP::UC_LP input-amounts pool-token-supplies lp-supply lp-prec)
                (let
                    (
                        (percent-lst:[decimal]
                            (if (= pt "W")
                                (if (= read-lp-supply 0.0)
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
                                    (let
                                        (
                                            (token-percent:decimal (floor (/ (at idx input-amounts) (at idx pool-token-supplies)) 24))
                                            (lp-amount:decimal (floor (fold (*) 1.0 [token-percent (at idx percent-lst) lp-supply]) lp-prec))
                                        )
                                        (ref-U|LST::UC_AppL 
                                            acc 
                                            lp-amount
                                        )
                                    )
                                )
                                []
                                (enumerate 0 (- li 1))
                            )
                        )
                    )
                    (fold (+) 0.0 lp-amounts)
                )
            )
        )
    )
    (defun SWPLC|URC_S_LpAmount:decimal (swpair:string input-amounts:[decimal])
        @doc "Computes the LP Amount you get on a Stable Pool, when adding the <input-amounts> of Pool Tokens as Liquidity \
        \ The <input-amounts> must contain amounts for all pool tokens, using 0.0 for Pool Tokens that arent being used \
        \ The pool token order is used for the <input-amounts> variable; \
        \ Liquidity Fee is hardcoded at 1%."
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Swapper} SWP)
                (pt:string (take 1 swpair))
                (lp-prec:integer (ref-DPTF::UR_Decimals (ref-SWP::UR_TokenLP swpair)))
                (read-lp-supply:decimal (SWPLC|URC_LpCapacity swpair))
                (lp-supply:decimal 
                    (if (= read-lp-supply 0.0)
                        10000000.0
                        read-lp-supply
                    )
                )
                (pool-token-supplies:[decimal] 
                    (if (= read-lp-supply 0.0)
                        (ref-SWP::UR_PoolGenesisSupplies swpair)
                        (ref-SWP::UR_PoolTokenSupplies swpair)
                    )
                )
                (liquidity-fee:decimal (/ (ref-SWP::URC_LiquidityFee swpair) 1000.0))
                (pool-token-supplies:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (li:integer (length input-amounts))
                (lc:integer (length pool-token-supplies))
                (iz-balanced:bool (SWPLC|URC_AreAmountsBalanced swpair input-amounts))
            )
            (enforce (= pt "S") "Only for S Pools")
            (enforce (= li lc) "Incorrect Pool Token Ammounts")
            (ref-SWP::UEV_id swpair)
            (if iz-balanced
                (ref-U|SWP::UC_LP input-amounts pool-token-supplies lp-supply lp-prec)
                (let
                    (
                        (amp:decimal (ref-SWP::UR_Amplifier swpair))
                        (new-balances:[decimal] (zip (+) pool-token-supplies input-amounts))
                        (d0:decimal (ref-U|SWP::UC_ComputeD amp pool-token-supplies))
                        (d1:decimal (ref-U|SWP::UC_ComputeD amp new-balances))
                        (dr:decimal (floor (/ d1 d0) 24))
                        (Xp:[integer] (ref-SWP::UR_PoolTokenPrecisions swpair))
                        (adjusted-balances:[decimal]
                            (fold
                                (lambda
                                    (acc:[decimal] idx:integer)
                                    (let
                                        (
                                            (ideal:decimal (floor (* (at idx pool-token-supplies) dr) (at idx Xp)))
                                            (diff:decimal (abs (- (at idx new-balances) ideal)))
                                            (diff-fee:decimal (floor (* diff liquidity-fee) (at idx Xp)))
                                            (adjusted:decimal (- (at idx new-balances) diff-fee))
                                        )
                                        (ref-U|LST::UC_AppL 
                                            acc 
                                            adjusted
                                        )
                                    )
                                )
                                []
                                (enumerate 0 (- li 1))
                            )
                        )
                    )
                    (floor (/ (* (- (ref-U|SWP::UC_ComputeD amp adjusted-balances) d0) lp-supply) d0) lp-prec)
                )
            )
        )
    )
    (defun SWPLC|URC_AddLiquidityIgnisCost:decimal (swpair:string input-amounts:[decimal])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-SWP:module{Swapper} SWP)
                (med:decimal (ref-DALOS::UR_UsagePrice "ignis|medium"))
                (liq:decimal (ref-DALOS::UR_UsagePrice "ignis|swp-liquidity"))
                (iz-balanced:bool (SWPLC|URC_AreAmountsBalanced swpair input-amounts))
                (n:decimal (dec (length (ref-SWP::UR_PoolTokens swpair))))
                (m:decimal (dec (length (ref-U|LST::UC_RemoveItem input-amounts 0.0))))
            )
            (if iz-balanced
                med
                (if (= m n)
                    (* liq n)
                    (* liq (- n m))
                )
            )
        )
    )
    (defun SWPSC|URC_Swap:decimal (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (let
            (
                (ref-SWP:module{Swapper} SWP)
                (A:decimal (ref-SWP::UR_Amplifier swpair))
            )
            (if (= A -1.0)
                (SWPSC|URC_ProductSwap swpair input-ids input-amounts output-id)
                (SWPSC|URC_StableSwap swpair input-ids input-amounts output-id)
            )
        )
    )
    (defun SWPSC|URC_ProductSwap:decimal (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Swapper} SWP)
                (X:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (op:integer (ref-SWP::UR_PoolTokenPosition swpair output-id))
                (o-prec:integer (ref-DPTF::UR_Decimals output-id))
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (l1:integer (length input-ids))
                (l2:integer (length input-amounts))
                (l3:integer (length pool-tokens))
                (lengths:[integer] [l1 l2])
                (iz-on-pool:bool (ref-SWP::UEV_CheckAgainst input-ids pool-tokens))
                (t1:bool (contains output-id input-ids))
                (t2:bool (contains output-id pool-tokens))
                (ip:[integer]
                    (fold
                        (lambda
                            (acc:[integer] idx:integer)
                            (ref-U|LST::UC_AppL 
                                acc 
                                (ref-SWP::UR_PoolTokenPosition swpair (at idx input-ids))
                            )
                        )
                        []
                        (enumerate 0 (- l1 1))
                    )
                )
                (w:[decimal] (ref-SWP::UR_Weigths swpair))
            )
            (ref-U|INT::UEV_UniformList lengths)
            (enforce iz-on-pool "Input Tokens are not part of the pool")
            (enforce t2 "OutputID is not part of Swpair Tokens")
            (enforce (not t1) "Output-ID cannot be within the Input-IDs")
            (enforce (and (>= l2 1) (< l2 l3)) "Incorrect amount of swap Tokens")
            (map
                (lambda
                    (idx:integer)
                    (ref-DPTF::UEV_Amount (at idx input-ids) (at idx input-amounts))
                )
                (enumerate 0 (- l1 1))
            )
            (ref-U|SWP::UC_ComputeWP X input-amounts ip op o-prec w)
        )
    )
    (defun SWPSC|URC_StableSwap:decimal (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Swapper} SWP)
                (A:decimal (ref-SWP::UR_Amplifier swpair))
                (X:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (l1:integer (length input-ids))
                (l2:integer (length input-amounts))
                (lengths:[integer] [l1 l2])
                (iz-on-pool:bool (ref-SWP::UEV_CheckAgainst input-ids pool-tokens))
                (t1:bool (contains output-id input-ids))
                (t2:bool (contains output-id pool-tokens))
            )
            (ref-U|INT::UEV_UniformList lengths)
            (enforce iz-on-pool "Input Tokens are not part of the pool")
            (enforce t2 "OutputID is not part of Swpair Tokens")
            (enforce (not t1) "Output-ID cannot be within the Input-IDs")
            (enforce (= l1 1) "Only a single Input can be used in Stable Swap")
            (let
                (
                    (input-amount:decimal (at 0 input-amounts))
                    (input-id:string (at 0 input-ids))
                    (ip:integer (ref-SWP::UR_PoolTokenPosition swpair input-id))
                    (op:integer (ref-SWP::UR_PoolTokenPosition swpair output-id))
                    (o-prec:integer (ref-DPTF::UR_Decimals output-id))
                )
                (ref-U|SWP::UC_ComputeY A X input-amount ip op o-prec)
            )
        ) 
    )
    (defun SWPSC|URC_BestEdge:string (ia:decimal i:string o:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-SWPT:module{SwapTracer} SWPT)
                (ref-SWP:module{Swapper} SWP)
                (principals:[string] (ref-SWP::UR_Principals))
                (edges:[string] (ref-SWPT::URC_Edges i o principals))
                (svl:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (ref-U|LST::UC_AppL
                                acc
                                (SWPSC|URC_Swap (at idx edges) [i] [ia] o)
                            )
                        )
                        []
                        (enumerate 0 (- (length edges) 1))
                    )
                )
                (sp:integer
                    (fold
                        (lambda
                            (acc:integer idx:integer)
                            (if (= idx 0)
                                acc
                                (if (< (at idx svl) (at acc svl))
                                    idx
                                    acc
                                )
                            )
                        )
                        0
                        (enumerate 0 (- (length svl) 1))
                    )
                )
            )
            (at sp edges)
        )
    )
    (defun SWPSC|URC_Hopper:object{SwapperUsage.Hopper} (hopper-input-id:string hopper-output-id:string hopper-input-amount:decimal)
        @doc "Creates a Hopper Object, by computing \
        \ 1] The trace between <hopper-input-id> and <hopper-output-id>, the <nodes> \
        \ 2] The hops between them, the <edges> as the cheapest available edge from all available \
        \ 3] The best <output> values using said best <edges>, given the <hopper-input-amount>"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-SWPT:module{SwapTracer} SWPT)
                (ref-SWP:module{Swapper} SWP)
                (swpairs:[string] (ref-SWP::URC_Swpairs))
                (principal-lst:[string] (ref-SWP::UR_Principals))
                (nodes:[string] (ref-SWPT::URC_ComputeGraphPath hopper-input-id hopper-output-id swpairs principal-lst))
            )
            (if (!= nodes [BAR])
                (let
                    (
                        (fl:[object{SwapperUsage.Hopper}]
                            (fold
                                (lambda
                                    (acc:[object{SwapperUsage.Hopper}] idx:integer)
                                    (ref-U|LST::UC_ReplaceAt
                                        acc
                                        0
                                        (let
                                            (
                                                (input:decimal
                                                    (if (= idx 0)
                                                        hopper-input-amount
                                                        (at 0 (take -1 (at "output-values" (at 0 acc))))
                                                    )
                                                )
                                                (i-id:string (at idx nodes))
                                                (o-id:string (at (+ idx 1) nodes))
                                                (best-edge:string (SWPSC|URC_BestEdge input i-id o-id))
                                                (output:decimal (SWPSC|URC_Swap best-edge [i-id] [input] o-id))
                                            )
                                            {
                                                "nodes"         : nodes,
                                                "edges"         : (ref-U|LST::UC_AppL (at "edges" (at 0 acc)) best-edge),
                                                "output-values" : (ref-U|LST::UC_AppL (at "output-values" (at 0 acc)) output)
                                            }
                                        )
                                    )
                                )
                                EMPTY_HOPPER
                                (enumerate 0 (- (length nodes) 2))
                            )
                        )
                    )
                    (at 0 fl)
                )
                (at 0 EMPTY_HOPPER)
            )
        )
    )
    ;;{F2}
    (defun SWPI|UEV_Issue
        (account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-SWP:module{Swapper} SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (fee-precision:integer (ref-U|CT::CT_FEE_PRECISION))
                (principals:[string] (ref-SWP::UR_Principals))
                (l1:integer (length pool-tokens))
                (l2:integer (length weights))
                (ws:decimal (fold (+) 0.0 weights))
                (pt-ids:[string] (ref-SWP::UC_ExtractTokens pool-tokens))
                (ptte:[string]
                    (if (= amp -1.0)
                        (drop 1 pt-ids)
                        pt-ids
                    )
                )
                (first-pool-token:string (at 0 pt-ids))
                (iz-principal:bool (contains first-pool-token principals))
                (contains-principals:bool
                    (fold
                        (lambda
                            (acc:bool idx:integer)
                            (or
                                acc
                                (contains (at idx pt-ids) principals)
                            )
                        )
                        false
                        (enumerate 0 (- (length pt-ids) 1))
                    )
                )
            )
            ;;Functions
            (ref-SWP::UEV_PoolFee fee-lp)
            (ref-SWP::UEV_New pt-ids weights amp)
            ;;Mappings
            (map
                (lambda
                    (id:string)
                    (ref-DPTF::CAP_Owner id)
                )
                ptte
            )
            (map
                (lambda
                    (w:decimal)
                    (= (floor w fee-precision) w)
                )
                weights
            )

            ;;Enforcements
            (enforce (!= principals [BAR]) "Principals must be defined before a Swap Pair can be issued")
            (enforce (or (= amp -1.0) (>= amp 1.0)) "Invalid amp value")
            (enforce (and (>= l1 2) (<= l1 7)) "2 - 7 Tokens can be used to create a Swap Pair")
            (enforce (= l1 l2) "Number of weigths does not concide with the pool-tokens Number")
            (enforce-one
                "Invalid Weight Values"
                [
                    (enforce (= ws 1.0) "Weights must add to exactly 1.0")
                    (enforce (= ws (dec l1)) "Weights must all be 1.0")
                ]
            )
            ;;Ifs
            ;;On a W or P pool, first Pool Token must be a Principal Token
            (if (= amp -1.0)
                (enforce iz-principal "1st Token is not a Principal")
                true
            )
            ;;If a Stable Pool is to be created and none of its Tokens are Principal Tokens, 
            ;;  its first Token must have a connection to DLK present via existing pools.
            (if (and (> amp 0.0) (not contains-principals))
                (let
                    (
                        (ref-DALOS:module{OuronetDalos} DALOS)
                        (dlk:string (ref-DALOS::UR_LiquidKadenaID))
                        (h-obj:object{SwapperUsage.Hopper} (SWPSC|URC_Hopper first-pool-token dlk 1.0))
                    )
                    (enforce 
                        (!= h-obj (at 0 EMPTY_HOPPER))
                        (format "No connection to DLK detected for {}. Create a W or P Pool first with it!" [first-pool-token])
                    )
                )
                true
            )
            ;;If pool is not a principal pool, its initial liquidity must be worth at least <spawn-limit>
            (if (not p)
                (let
                    (
                        (ref-U|SWP:module{UtilitySwp} U|SWP)
                        (pt-amounts:[decimal] (ref-SWP::UC_ExtractTokenSupplies pool-tokens))
                        (first-pool-token-amount:decimal (at 0 pt-amounts))
                        (prefix:string (ref-U|SWP::UC_Prefix weights amp))
                        (how-many:integer (length pool-tokens))
                        (first-worth:decimal (URC_WorthDWK first-pool-token first-pool-token-amount))
                        (pool-worth-with-input-tokens-in-dwk:decimal
                            (if (or (= prefix "S") (= prefix "P"))
                                (* (dec how-many) first-worth)
                                (* (at 0 weights) first-worth)
                            )
                        )
                        (spawn-limit:decimal (ref-SWP::UR_SpawnLimit))
                    )
                    (enforce (>= pool-worth-with-input-tokens-in-dwk spawn-limit) "More liquidity is needed to open a new pool!")
                )
                true
            )
            (format "Validation prior to pool creation executed succesfully {}" ["!"])
        )
    )
    ;;{F3}
    (defun SPWS|UDC_SlippageObject:object{Slippage} (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage-value:decimal)
        @doc "Makes a Slippage Object from <input amounts>"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (op:integer (ref-DPTF::UR_Decimals output-id))
                (expected:decimal (SWPSC|URC_Swap swpair input-ids input-amounts output-id))
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
                "Slippage must be greater than 0.0 and maximum 50.0"
            )
            {"expected-output-amount"   : expected
            ,"output-precision"         : op
            ,"slippage-percent"         : slippage-value}
        )
    )
    ;;{F4}
    ;;
    ;;{F5}
    ;;{F6}
    (defun SWPI|C_Issue:object{OuronetDalos.IgnisCumulator} (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        @doc "Issues a new SWPair (Liquidty Pool)"
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (SWPI|C>ISSUE account pool-tokens fee-lp weights amp p)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-BRD:module{Branding} BRD)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (ref-SWPT:module{SwapTracer} SWPT)
                    (ref-SWP:module{Swapper} SWP)
                    (swp-sc:string (ref-DALOS::GOV|SWP|SC_NAME))
                    (kda-dptf-cost:decimal (ref-DALOS::UR_UsagePrice "dptf"))
                    (kda-swp-cost:decimal (ref-DALOS::UR_UsagePrice "swp"))
                    (kda-costs:decimal (+ kda-dptf-cost kda-swp-cost))
                    (gas-swp-cost:decimal (ref-DALOS::UR_UsagePrice "ignis|swp-issue"))
                    (pool-token-ids:[string] (ref-SWP::UC_ExtractTokens pool-tokens))
                    (pool-token-amounts:[decimal] (ref-SWP::UC_ExtractTokenSupplies pool-tokens))
                    (lp-name-ticker:[string] (ref-SWP::URC_LpComposer pool-tokens weights amp))
                    (ico:object{OuronetDalos.IgnisCumulator} 
                        (ref-DPTF::XE_IssueLP patron account (at 0 lp-name-ticker) (at 1 lp-name-ticker))
                    )
                    (token-lp:string (at 0 (at "output" ico)))
                    (swpair:string (ref-SWP::XE_Issue account pool-tokens token-lp fee-lp weights amp p))
                )
                (ref-BRD::XE_Issue swpair)
                (let
                    (
                        (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                        (ico1:object{OuronetDalos.IgnisCumulator}
                            (ref-TFT::XE_FeelesMultiTransfer patron pool-token-ids account swp-sc pool-token-amounts true)
                        )
                        (ico2:object{OuronetDalos.IgnisCumulator}
                            (ref-DPTF::C_Mint patron token-lp swp-sc 10000000.0 true)
                        )
                        (ico3:object{OuronetDalos.IgnisCumulator}
                            (ref-TFT::XB_FeelesTransfer patron token-lp swp-sc account 10000000.0 true)
                        )
                        (ico4:object{OuronetDalos.IgnisCumulator}
                            (ref-DALOS::UDC_Cumulator gas-swp-cost trigger [])
                        )
                    )
                    (ref-SWPT::X_MultiPathTracer swpair (ref-SWP::UR_Principals))
                    (ref-DALOS::KDA|C_Collect patron kda-costs)
                    (ref-DALOS::UDC_CompressICO [ico ico1 ico2 ico3 ico4] [swpair token-lp])
                )
            )
        )
    )
    (defun SWPI|C_IssueStableMultiStep
        (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal amp:decimal p:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (SWPI|C_IssueMultiStep
            patron account pool-tokens fee-lp
            (make-list (length pool-tokens) 1.0)
            amp p
        )
    )
    (defun SWPI|C_IssueStandardMultiStep
        (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal p:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (SWPI|C_IssueMultiStep
            patron account pool-tokens fee-lp
            (make-list (length pool-tokens) 1.0)
            -1.0 p
        )
    )
    (defun SWPI|C_IssueWeightedMultiStep
        (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (SWPI|C_IssueMultiStep
            patron account pool-tokens fee-lp
            weights
            -1.0 p
        )
    )
    (defpact SWPI|C_IssueMultiStep
        (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        ;;Issues an SWPair, as MultiStep Transaction, to be used in case <SWPI|C_Issue> cant fit inside one TX.
        ;;
        ;;Step 1 Validation
        (step
            (SWPI|UEV_Issue account pool-tokens fee-lp weights amp p)
        )
        ;;Step 2 Ignis Collection and KDA Fuel Processing
        (step
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (ref-SWP:module{Swapper} SWP)
                    (pool-token-ids:[string] (ref-SWP::UC_ExtractTokens pool-tokens))
                    (pool-token-amounts:[decimal] (ref-SWP::UC_ExtractTokenSupplies pool-tokens))
                    (swp-sc:string (ref-DALOS::GOV|SWP|SC_NAME))

                    (swp-issue:decimal (ref-DALOS::UR_UsagePrice "ignis|swp-issue"))
                    (lp-token-issue:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                    (origin-mint:decimal (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                    (lp-transfer:decimal (ref-DALOS::UR_UsagePrice "ignis|smallest"))
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-TFT::UDC_MultiTransferICO pool-token-ids pool-token-amounts account swp-sc)
                    )
                    (multi-transfer:decimal (ref-DALOS::UDC_AddICO [ico]))
                    (ignis-costs:[decimal]
                        [swp-issue lp-token-issue origin-mint lp-transfer multi-transfer]
                    )
                    (sum-ignis:decimal (fold (+) 0.0 ignis-costs))

                    (kda-dptf-cost:decimal (ref-DALOS::UR_UsagePrice "dptf"))
                    (kda-swp-cost:decimal (ref-DALOS::UR_UsagePrice "swp"))
                    (kda-costs:decimal (+ kda-dptf-cost kda-swp-cost))
                )
                (ref-DALOS::IGNIS|C_Collect patron account sum-ignis)
                (ref-DALOS::KDA|C_Collect patron kda-costs)
                (let
                    (
                        (ref-DALOS:module{OuronetDalos} DALOS)
                        (ref-ORBR:module{Ouroboros} OUROBOROS)
                        (auto-fuel:bool (ref-DALOS::UR_AutoFuel))
                        (gasless-patron:string (ref-DALOS::GOV|DALOS|SC_NAME))
                    )
                    (if auto-fuel
                        (do
                            (with-capability (P|DT)
                                (ref-ORBR::C_Fuel gasless-patron)
                            )
                            (format "{} IGNIS and {} KDA collected (raising DLK Index) succesfully." [sum-ignis kda-costs])
                        )
                        (format "{} IGNIS collected, with {} KDA collected (in reserves) succesfully" [sum-ignis kda-costs])
                    )
                    
                )
            )
        )
        ;;Step 3 Issuance
        (step
            (with-capability (SWPI|C>PACT-ISSUE p)
                (let
                    (
                        (ref-DALOS:module{OuronetDalos} DALOS)
                        (ref-BRD:module{Branding} BRD)
                        (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                        (ref-TFT:module{TrueFungibleTransfer} TFT)
                        (ref-SWPT:module{SwapTracer} SWPT)
                        (ref-SWP:module{Swapper} SWP)
                        (principals:[string] (ref-SWP::UR_Principals))
                        (swp-sc:string (ref-DALOS::GOV|SWP|SC_NAME))
                        (pool-token-ids:[string] (ref-SWP::UC_ExtractTokens pool-tokens))
                        (pool-token-amounts:[decimal] (ref-SWP::UC_ExtractTokenSupplies pool-tokens))
                        (lp-name-ticker:[string] (ref-SWP::URC_LpComposer pool-tokens weights amp))
                        (lp-name:string (at 0 lp-name-ticker))
                        (lp-ticker:string (at 1 lp-name-ticker))
                        (ico:object{OuronetDalos.IgnisCumulator} 
                            (ref-DPTF::XE_IssueLP patron account lp-name lp-ticker)
                        )
                        (token-lp:string (at 0 (at "output" ico)))
                        (swpair:string (ref-SWP::XE_Issue account pool-tokens token-lp fee-lp weights amp p))
                    )
                    (ref-BRD::XE_Issue swpair)
                    (ref-TFT::XE_FeelesMultiTransfer patron pool-token-ids account swp-sc pool-token-amounts true)
                    (ref-DPTF::C_Mint patron token-lp swp-sc 10000000.0 true)
                    (ref-TFT::XB_FeelesTransfer patron token-lp swp-sc account 10000000.0 true)
                    (ref-SWPT::X_MultiPathTracer swpair principals)
                    (format "Swpair with ID {} and LP Token {} ID created succesfully" [swpair token-lp])
                )
            )
        )
    )
    ;;
    (defun C_ToggleAddLiquidity:object{OuronetDalos.IgnisCumulator} (patron:string swpair:string toggle:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (P|SWPU|CALLER)
                (ref-SWP::C_ToggleAddOrSwap patron swpair toggle true)
            )
        )
    )
    (defun C_ToggleSwapCapability:object{OuronetDalos.IgnisCumulator} (patron:string swpair:string toggle:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (SPW|C>TOGGLE-SWAP swpair toggle)
                (ref-SWP::C_ToggleAddOrSwap patron swpair toggle false)
            )
        )
    )
    ;;
    (defun SWPL|C_AddBalancedLiquidity:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-id:string input-amount:decimal)
        (enforce-guard (P|UR "TALOS-01"))
        (SWPL|C_AddLiquidity patron account swpair (SWPLC|URC_BalancedLiquidity swpair input-id input-amount))          
    )
    (defun SWPL|C_AddLiquidity:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-amounts:[decimal])
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (SWPL|C>ADD_LQ swpair input-amounts)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (ref-SWP:module{Swapper} SWP)
                    (swp-sc:string (ref-SWP::GOV|SWP|SC_NAME))
                    (read-lp-supply:decimal (SWPLC|URC_LpCapacity swpair))
                    (ignis-cost:decimal (SWPLC|URC_AddLiquidityIgnisCost swpair input-amounts))
                    (additional-ignis-cost:decimal
                        (if (= read-lp-supply 0.0)
                            (ref-DALOS::UR_UsagePrice "ignis|biggest")
                            0.0
                        )
                    )
                    (price:decimal (+ ignis-cost additional-ignis-cost))
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                    (gw:[decimal] (ref-SWP::UR_GenesisWeigths swpair))
                    (pool-token-ids:[string] (ref-SWP::UR_PoolTokens swpair))
                    (lp-id:string (ref-SWP::UR_TokenLP swpair))
                    (lp-amount:decimal (SWPLC|URC_LpAmount swpair input-amounts))
                    (pt-current-amounts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                    (pt-new-amounts:[decimal] (zip (+) pt-current-amounts input-amounts))

                    (ico0:object{OuronetDalos.IgnisCumulator}
                        (ref-DALOS::UDC_Cumulator price trigger [])
                    )
                    (ico1:[object{OuronetDalos.IgnisCumulator}]
                        (fold
                            (lambda
                                (acc:[object{OuronetDalos.IgnisCumulator}] idx:integer)
                                (ref-U|LST::UC_AppL 
                                    acc
                                    (if (> (at idx input-amounts) 0.0)
                                        (ref-TFT::XB_FeelesTransfer patron (at idx pool-token-ids) account swp-sc (at idx input-amounts) true)
                                        EIC
                                    )
                                )
                            )
                            []
                            (enumerate 0 (- (length input-amounts) 1))
                        )
                    )
                    (ico2:object{OuronetDalos.IgnisCumulator}
                        (ref-DPTF::C_Mint patron lp-id swp-sc lp-amount false)
                    )
                    (ico3:object{OuronetDalos.IgnisCumulator}
                        (ref-TFT::XB_FeelesTransfer patron lp-id swp-sc account lp-amount true)
                    )
                )
                (if (= read-lp-supply 0.0)
                    (ref-SWP::XB_ModifyWeights swpair gw)
                    true
                )
                (ref-SWP::XE_UpdateSupplies swpair pt-new-amounts)
                (XI_AutonomousSwapManagement swpair)
                (ref-DALOS::UDC_CompressICO (fold (+) [] [[ico0] ico1 [ico2] [ico3]]) [lp-amount])
            )
        )
    )
    (defun SWPL|C_RemoveLiquidity:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string lp-amount:decimal)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (SWPL|C>RM_LQ swpair lp-amount)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (ref-SWP:module{Swapper} SWP)
                    (swp-sc:string (ref-SWP::GOV|SWP|SC_KDA-NAME))
                    (pool-token-ids:[string] (ref-SWP::UR_PoolTokens swpair))
                    (lp-id:string (ref-SWP::UR_TokenLP swpair))
                    (pt-output-amounts:[decimal] (SWPLC|URC_LpBreakAmounts swpair lp-amount))
                    (pt-current-amounts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                    (pt-new-amounts:[decimal] (zip (-) pt-current-amounts pt-output-amounts))
                    (token-issue:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                    (price:decimal (* 2.0 token-issue))
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                    (ico0:object{OuronetDalos.IgnisCumulator}
                        (ref-DALOS::UDC_Cumulator price trigger [])
                    )
                    (ico1:object{OuronetDalos.IgnisCumulator}
                        (ref-TFT::XB_FeelesTransfer patron lp-id account swp-sc lp-amount true)
                    )
                    (ico2:object{OuronetDalos.IgnisCumulator}
                        (ref-DPTF::C_Burn patron lp-id swp-sc lp-amount)
                    )
                    (ico3:object{OuronetDalos.IgnisCumulator}
                        (ref-TFT::XE_FeelesMultiTransfer patron pool-token-ids swp-sc account pt-output-amounts true)
                    )
                )
                (ref-SWP::XE_UpdateSupplies swpair pt-new-amounts)
                (XI_AutonomousSwapManagement swpair)
                (ref-DALOS::UDC_CompressICO [ico0 ico1 ico2 ico3] pt-output-amounts)
            )
        )
    )
    ;;
    (defun SWPS|C_SimpleSwap:object{OuronetDalos.IgnisCumulator}
        (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string slippage:object{Slippage})
        (SWPS|C_MultiSwap patron account swpair [input-id] [input-amount] output-id slippage)
    )
    (defun SWPS|C_SimpleSwapNoSlippage:object{OuronetDalos.IgnisCumulator}
        (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string)
        (SWPS|C_MultiSwapNoSlippage patron account swpair [input-id] [input-amount] output-id)
    )
    (defun SWPS|C_MultiSwap:object{OuronetDalos.IgnisCumulator}
        (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:object{Slippage})
        (with-capability (SECURE)
            (let
                (
                    ;;Get Max Theoretical Output Amount <max-toa> and compute Slippage
                    (max-toa:decimal (SWPSC|URC_Swap swpair input-ids input-amounts output-id))
                    (min-max:[decimal] (SWPS|UC_SlippageMinMax slippage))
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
                    (SWPS|X_MultiSwap patron account swpair input-ids input-amounts output-id)
                    {"price"    : 0.0
                    ,"trigger"  : false
                    ,"output"   : [exceed-message]}
                )
            )
        )
    )
    (defun SWPS|C_MultiSwapNoSlippage:object{OuronetDalos.IgnisCumulator} 
        (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (with-capability (SECURE)
            (SWPS|X_MultiSwap patron account swpair input-ids input-amounts output-id)
        )
    )
    (defun SWPS|X_MultiSwap:object{OuronetDalos.IgnisCumulator}
        (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (require-capability (SECURE))
        (with-capability (SWPS|C>SWAP swpair input-ids input-amounts output-id)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                    (ref-U|SWP:module{UtilitySwp} U|SWP)
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (ref-SWP:module{Swapper} SWP)

                    ;;Get <output-id> Output-Precision <op> and SWP|SC_NAME
                    (op:integer (ref-DPTF::UR_Decimals output-id))
                    (swp-sc:string (ref-DALOS::GOV|SWP|SC_NAME))

                    ;;Get Pool Fees
                    (lb:bool (ref-SWP::UR_LiquidBoost))
                    (lp-fee:decimal (ref-SWP::UR_FeeLP swpair))
                    (boost-fee:decimal (if lb lp-fee 0.0))
                    (special-fee:decimal (ref-SWP::UR_FeeSP swpair))

                    ;;Apply Elite Account Reduction to fees
                    (major:integer (ref-DALOS::UR_Elite-Tier-Major patron))
                    (minor:integer (ref-DALOS::UR_Elite-Tier-Minor patron))
                    (f1:decimal (ref-U|DALOS::UC_GasCost lp-fee major minor false))
                    (f2:decimal (ref-U|DALOS::UC_GasCost boost-fee major minor false))
                    (f3:decimal (ref-U|DALOS::UC_GasCost special-fee major minor false))

                    ;;From the input amounts, compute FeeSharesExcludingLpFee <fselp>
                    (fselp:decimal (- 1000.0 f1))
                    (input-amounts-for-swap:[decimal]
                        (fold
                            (lambda
                                (acc:[decimal] idx:integer)
                                (ref-U|LST::UC_AppL
                                    acc
                                    (floor 
                                        (* (at idx input-amounts) (/ fselp 1000.0)) 
                                        (ref-DPTF::UR_Decimals (at idx input-ids))
                                    )
                                )
                            )
                            []
                            (enumerate 0 (- (length input-amounts) 1))
                        )
                    )

                    ;;LP-shares are left in pool increasing value of SWPairs LP Token
                    ;;Total-Swap-Output-Amount <tsoa> is computed without them, then splited into 3 parts: boost, special, remainder
                    (tsoa:decimal (SWPSC|URC_Swap swpair input-ids input-amounts-for-swap output-id))
                    (boost-output:decimal (floor (* (/ f2 fselp) tsoa) op))
                    (special-output:decimal (floor (* (/ f3 fselp) tsoa) op))
                    (remainder-output:decimal (- tsoa (+ boost-output special-output)))
                    ;;Computes updated Pool Supplies values, adding the <input-amounts> and subtracting <tsoa>
                    ;;ID Values that are neither Input-IDs nor Output ID are left as is.
                    (pool-token-ids:[string] (ref-SWP::UR_PoolTokens swpair))
                    (pool-token-supplies:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                    (updated-supplies:[decimal]
                        (fold
                            (lambda
                                (acc:[decimal] idx:integer)
                                (ref-U|LST::UC_AppL
                                    acc
                                    (let
                                        (
                                            (id:string (at idx pool-token-ids))
                                            (amount:decimal (at idx pool-token-supplies))
                                            (iz-on-input:bool (contains id input-ids))
                                            (iz-output:bool (= id output-id))
                                        )
                                        (if iz-output
                                            (- amount tsoa)
                                            (if iz-on-input
                                                (+ 
                                                    amount
                                                    (at (at 0 (ref-U|LST::UC_Search input-ids id)) input-amounts)
                                                )
                                                amount
                                            )
                                        )
                                    )
                                )
                            )
                            []
                            (enumerate 0 (- (length pool-token-supplies) 1))
                        )
                    )
                )
                ;;1] Updates Pool Token Supplies
                (ref-SWP::XE_UpdateSupplies swpair updated-supplies)
                ;;2] Moves all Input IDs to SWP|SC_NAME via MultiTransfer (ico1)
                (let
                    (
                        (ico1:object{OuronetDalos.IgnisCumulator}
                            (ref-TFT::XE_FeelesMultiTransfer patron input-ids account swp-sc input-amounts true)
                        )
                        (ico2:object{OuronetDalos.IgnisCumulator}
                            (if (= special-fee 0.0)
                                (ref-TFT::XB_FeelesTransfer patron output-id swp-sc account remainder-output true)
                                (ref-TFT::XE_FeelesBulkTransfer 
                                    patron 
                                    output-id 
                                    swp-sc 
                                    (+ 
                                        (ref-SWP::UR_SpecialFeeTargets swpair) 
                                        [account]
                                    )
                                    (+
                                        (ref-U|SWP::UC_SpecialFeeOutputs 
                                            (ref-SWP::UR_SpecialFeeTargetsProportions swpair) 
                                            special-output 
                                            op
                                        ) 
                                        [remainder-output]
                                    )
                                    true
                                )
                            )
                        )
                        (ico3:object{OuronetDalos.IgnisCumulator}
                            (if (!= boost-fee 0.0)
                                (XI_PumpLiquidIndex patron output-id boost-output)
                                EIC
                            )
                        )
                    )
                    (ref-DALOS::UDC_CompressICO [ico1 ico2 ico3] [remainder-output])
                )
                ;;3] Moves Outputs to their designated places
                ;;3.1]  If special fee is zero, move only remainder to client.
                ;;3.2]  If special fee is non zero, additionaly move special fee to special fee targets via BulkTransfer (ico2)
                ;;3.3]  If non zero, use boost output to boost Kadena Liquid Index (ico3)
            )
        )
    )
    ;;{F7}
    (defun XI_PumpLiquidIndex:object{OuronetDalos.IgnisCumulator} (patron:string id:string amount:decimal)
        (require-capability (SWPS|C>PUMP_LQ-IDX))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Swapper} SWP)
                (swp-sc:string (ref-DALOS::GOV|SWP|SC_NAME))
                (dlk:string (ref-DALOS::UR_LiquidKadenaID))
            )
            (if (= id dlk)
            ;;1] If id is dlk, burn it directly
                (ref-DPTF::C_Burn patron dlk swp-sc amount)
            ;;2] If id is not dlk, compute via Hopper the equivalent dlk amount that must be burned.
            ;;3] Then update all Token Supplies of the hopped pools that served to compute the DLK amount
            ;;      as if the id was smart-swapped with no fees to dlk.
                (let
                    (
                        (h-obj:object{SwapperUsage.Hopper} (SWPSC|URC_Hopper id dlk amount))
                        (path-to-dlk:[string] (at "nodes" h-obj))
                        (edges:[string] (at "edges" h-obj))
                        (ovs:[decimal] (at "output-values" h-obj))
                        (final-boost-output:decimal (at 0 (take -1 ovs)))
                        (ico:object{OuronetDalos.IgnisCumulator}
                            (ref-DPTF::C_Burn patron dlk swp-sc final-boost-output)
                        )
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
                        (enumerate 0 (- (length edges) 1))
                    )
                    ico
                )
            )
        )
    )
    (defun XI_AutonomousSwapManagement (swpair:string)
        (require-capability (SECURE))
        (let
            (
                (ref-SWP:module{Swapper} SWP)
                (pool-worth:decimal (URC_PoolWorthDWK swpair))
                (inactive-limit:decimal (ref-SWP::UR_InactiveLimit))
            )
            (with-capability (P|SWPU|CALLER)
                (if (< pool-worth inactive-limit)
                    (ref-SWP::XE_CanAddOrSwapToggle swpair false false)
                    (ref-SWP::XE_CanAddOrSwapToggle swpair true false)
                )
            )
        )
    )
)

(create-table P|T)