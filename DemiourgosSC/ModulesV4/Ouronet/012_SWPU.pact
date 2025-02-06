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
        true
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    ;;
    ;;{F0}
    ;;{F1}
    (defun SWPLC|URC_AreAmountsBalanced:bool (swpair:string input-amounts:[decimal])
        @doc "Determines if <input-amounts> are balanced accoriding to <swpair>"
        (let*
            (
                (sum:decimal (fold (+) 0.0 input-amounts))
            )
            (enforce (> sum 0.0) "At least a single input value must be greater than zero!")
            (let*
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-SWP:module{Autostake} SWP)
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
        (let*
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Autostake} SWP)
                (token-lp:string (ref-SWP::UR_TokenLP swpair))
                (token-lps:[string] (ref-SWP::UR_TokenLPS swpair))
                (token-lp-supply:decimal (ref-DPTF::UR_Supply token-lp))
            )
            (ref-SWP::UEV_id swpair)
            (if (= token-lps [BAR])
                token-lp-supply
                (let*
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
        (let*
            (
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Autostake} SWP)
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
        (let*
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-SWP:module{Autostake} SWP)
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
        (let*
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|VST:module{UtilityVst} U|VST)
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Autostake} SWP)
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
                (let*
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
                                    (let*
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
        (let*
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-SWP:module{Autostake} SWP)
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
                (let*
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
                                    (let*
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
    ;;{F2}
    ;;{F3}
    ;;{F4}
    ;;
    ;;{F5}
    ;;{F6}
    ;;{F7}
)

