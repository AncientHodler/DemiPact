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
    (defcap P|SWPU|REMOTE-GOV ()
        true
    )
    (defcap P|SWPU|CALLER ()
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
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|SWP:module{OuronetPolicy} SWP)
            )
            (ref-P|DPTF::P|A_Add
                "SWPU|Caller"
                (create-capability-guard (P|SWPU|CALLER))
            )
            (ref-P|TFT::P|A_Add
                "SWPU|Caller"
                (create-capability-guard (P|SWPU|CALLER))
            )
            (ref-P|SWP::P|A_Add
                "SWPU|RemoteSwpGov"
                (create-capability-guard (P|SWPU|REMOTE-GOV))
            )
            (ref-P|SWP::P|A_Add
                "SWPU|Caller"
                (create-capability-guard (P|SWPU|CALLER))
            )
        )
    )
    ;;
    ;;{1}
    (defschema Hopper
        nodes:[string]
        edges:[string]
        output-values:[decimal]
    )
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
    (defconst BAR                   (CT_Bar))
    ;;
    ;;{C1}
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap SWPL|C>ADD_LQ (swpair:string input-amounts:[decimal])
        @event
        (let
            (
                (ref-U|DEC:module{OuronetDecimals} U|DEC)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Swapper} SWP)
                (can-add:bool (ref-SWP::UR_CanAdd swpair))
                (pool-token-ids:[string] (ref-SWP::UR_PoolTokens swpair))
                (l0:integer (length input-amounts))
                (l1:integer (length pool-token-ids))
                (lengths:[integer] [l0 l1])
            )
            (ref-U|DEC::UEV_UniformList lengths)
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
    ;;{F0}
    ;;{F1}
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
                (ref-U|DEC:module{OuronetDecimals} U|DEC)
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
            (ref-U|DEC::UEV_UniformList lengths)
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
                (ref-U|DEC:module{OuronetDecimals} U|DEC)
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
            (ref-U|DEC::UEV_UniformLis lengths)
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
    (defun SWPSC|URC_Hopper:object{Hopper} (hopper-input-id:string hopper-output-id:string hopper-input-amount:decimal)
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
                (fl:[object{Hopper}]
                    (fold
                        (lambda
                            (acc:[object{Hopper}] idx:integer)
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
    )
    (defun SWPSC|URC_BestEdge:string (ia:decimal i:string o:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-SWPT:module{SwapTracer} SWPT)
                (edges:[string] (ref-SWPT::URC_Edges i o))
                (svl:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (ref-U|LST::UC_AppendLast 
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
    ;;{F2}
    ;;{F3}
    ;;{F4}
    ;;
    ;;{F5}
    ;;{F6}
    (defun SWPL|C_AddBalancedLiquidity:decimal (patron:string account:string swpair:string input-id:string input-amount:decimal)
        (SWPL|C_AddLiquidity patron account swpair (SWPLC|URC_BalancedLiquidity swpair input-id input-amount))          
    )
    (defun SWPL|C_AddLiquidity:decimal (patron:string account:string swpair:string input-amounts:[decimal])
        (with-capability (SWPL|C>ADD_LQ swpair input-amounts)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (ref-SWP:module{Swapper} SWP)
                    (swp-sc:string (ref-SWP::GOV|SWP|SC_KDA-NAME))
                    (read-lp-supply:decimal (SWPLC|URC_LpCapacity swpair))
                    (ignis-cost:decimal (SWPLC|URC_AddLiquidityIgnisCost swpair input-amounts))
                    (additional-ignis-cost:decimal
                        (if (= read-lp-supply 0.0)
                            (ref-DALOS::UR_UsagePrice "ignis|biggest")
                            0.0
                        )
                    )
                    (final-ignis-cost:decimal (+ ignis-cost additional-ignis-cost))
                    (gw:[decimal] (ref-SWP::UR_GenesisWeigths swpair))
                )
                (DALOS.IGNIS|C_Collect patron patron final-ignis-cost)
                (if (= read-lp-supply 0.0)
                    (ref-SWP::X_ModifyWeights swpair gw)
                    true
                )
                (let
                    (
                        (pool-token-ids:[string] (ref-SWP::UR_PoolTokens swpair))
                        (lp-id:string (ref-SWP::UR_TokenLP swpair))
                        (lp-amount:decimal (SWPLC|URC_LpAmount swpair input-amounts))
                        (pt-current-amounts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                        (pt-new-amounts:[decimal] (zip (+) pt-current-amounts input-amounts))
                    )
                    (map
                        (lambda 
                            (idx:integer)
                            (if (> (at idx input-amounts) 0.0)
                                (ref-TFT::C_Transfer patron (at idx pool-token-ids) account swp-sc (at idx input-amounts) true)
                                true
                            )
                        )
                        (enumerate 0 (- (length input-amounts) 1))
                    )
                    (ref-SWP::X_UpdateSupplies swpair pt-new-amounts)
                    (ref-DPTF::C_Mint patron lp-id swp-sc lp-amount false)
                    (ref-TFT::C_Transfer patron lp-id swp-sc account lp-amount true)
                    lp-amount
                )
            )
        )
    )
    (defun SWPL|C_RemoveLiquidity:[decimal] (patron:string account:string swpair:string lp-amount:decimal)
        (with-capability (SWPL|C>RM_LQ swpair lp-amount)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (ref-SWP:module{Swapper} SWP)
                    (swp-sc:string (ref-SWP::GOV|SWP|SC_KDA-NAME))
                    (pool-token-ids:[string] (ref-SWP::UR_PoolTokens swpair))
                    (lp-id:string (ref-SWP::UR_TokenLP swpair))
                    (pt-output-amounts:[decimal] (SWPLC|URC_LpBreakAmounts swpair lp-amount))
                    (pt-current-amounts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                    (pt-new-amounts:[decimal] (zip (-) pt-current-amounts pt-output-amounts))
                )
                (ref-TFT::C_Transfer patron lp-id account swp-sc lp-amount true)
                (ref-DPTF::C_Burn patron lp-id swp-sc lp-amount)
                (ref-TFT::C_MultiTransfer patron pool-token-ids swp-sc account pt-output-amounts true)
                (ref-SWP::X_UpdateSupplies swpair pt-new-amounts)
                pt-output-amounts
            )
        )
    )
    ;;{F7}
    ;;
    ;;
    ;;
    ;;
    ;;
    ;;
    (defun SWPS|C_MultiSwap
        (
            patron:string
            account:string
            swpair:string
            input-ids:[string]
            input-amounts:[decimal]
            output-id:string
        )
        (with-capability (SWPS|C>SWAP swpair input-ids input-amounts output-id)
            (let
                (
                    ;;refs
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-U|DALOS:module{UtilityDalos} U|DALOS)
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
                (ref-SWP::X_UpdateSupplies swpair updated-supplies)
                ;;2] Moves all Input IDs to SWP|SC_NAME via MultiTransfer
                (ref-TFT::C_MultiTransfer patron input-ids account swp-sc input-amounts true)
                ;;3] Moves Outputs to their designated places
                ;;3.1]  If special fee is zero, move only remainder to client.
                ;;3.2]  If special fee is non zero, additionaly move special fee to special fee targets via BulkTransfer
                (if (= special-fee 0.0)
                    (ref-TFT::C_Transfer patron output-id swp-sc account remainder-output true)
                    (let
                        (
                            (ref-U|SWP:module{UtilitySwp} U|SWP)
                            (sft:[string] (ref-SWP::UR_SpecialFeeTargets swpair))
                            (sftp:[decimal] (ref-SWP::UR_SpecialFeeTargetsProportions swpair))
                            (sf-outputs:[decimal] (ref-U|SWP::UC_SpecialFeeOutputs sftp special-output op))
                        )
                        (ref-TFT::C_BulkTransfer patron output-id swp-sc (+ sft [account]) (+ sf-outputs [remainder-output]) true)
                    )
                )
                ;;3.3]  If non zero, use boost output to boost Kadena Liquid Index
                (if (!= boost-fee 0.0)
                    (SWPS|X_PumpLiquidIndex patron output-id boost-output)
                    true
                )
            )
        )
    )
    (defun SWPS|X_PumpLiquidIndex (patron:string id:string amount:decimal)
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
                        (h-obj:object{Hopper} (SWPSC|URC_Hopper id dlk amount))
                        (path-to-dlk:[string] (at "nodes" h-obj))
                        (edges:[string] (at "edges" h-obj))
                        (ovs:[decimal] (at "output-values" h-obj))
                        (final-boost-output:decimal (at 0 (take -1 ovs)))
                    )
                    (ref-DPTF::C_Burn patron dlk swp-sc final-boost-output)
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
                                (ref-SWP::X_UpdateSupply hop first-id (+ f-id-hop-a first-amount))
                                (ref-SWP::X_UpdateSupply hop second-id (- s-id-hop-a second-amount))
                            )
                        )
                        (enumerate 0 (- (length edges) 1))
                    )
                )
            )
        )
    )
)

