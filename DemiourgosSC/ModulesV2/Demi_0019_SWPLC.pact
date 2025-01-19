(module SWPLC GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (SWPLC-ADMIN))
    )
    (defcap SWPLC-ADMIN ()
        (enforce-one
            "SWPLC Swapper Admin not satisfed"
            [
                (enforce-guard G-MD_SWPLC)
                (enforce-guard G-SC_SWPLC)
            ]
        )
    )

    (defconst G-MD_SWPLC    (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_SWPLC    (keyset-ref-guard SWP.SWP|SC_KEY))
    ;;
    (defun SWPLC|UC_AreAmountsBalanced:bool (swpair:string input-amounts:[decimal])
        (let*
            (
                (sum:decimal (fold (+) 0.0 input-amounts))
            )
            (enforce (> sum 0.0) "At least a single input value must be greater than zero!")
            (let*
                (
                    (positive-amounts:[decimal] (UTILS.LIST|UC_RemoveItem input-amounts 0.0))
                    (first-positive-amount:decimal (at 0 positive-amounts))
                    (positive-amounts-positions:[integer] (UTILS.LIST|UC_Search input-amounts first-positive-amount))
                    (first-positive-position:integer (at 0 positive-amounts-positions))
                    (first-positive-id:string (at first-positive-position (SWP.SWP|UR_PoolTokens swpair)))
                    (balanced-amounts:[decimal] (SWPLC|UC_BalancedLiquidity swpair first-positive-id first-positive-amount))
                )
                (if (= balanced-amounts input-amounts)
                    true
                    false
                )
            )
        )
    )
    (defun SWPLC|UC_LpCapacity:decimal (swpair:string)
        @doc "Computes the LP Capacity of a Given Swap Pair"
        (let*
            (
                (token-lp:string (SWP.SWP|UR_TokenLP swpair))
                (token-lps:[string] (SWP.SWP|UR_TokenLPS swpair))
                (token-lp-supply:decimal (BASIS.DPTF-DPMF|UR_Supply token-lp true))
            )
            (SWP.SWP|UEV_id swpair)
            (if (= token-lps [UTILS.BAR])
                token-lp-supply
                (let*
                    (
                        (token-lps-supplies:[decimal]
                            (fold
                                (lambda
                                    (acc:[decimal] idx:integer)
                                    (UTILS.LIST|UC_AppendLast 
                                        acc 
                                        (BASIS.DPTF-DPMF|UR_Supply (at idx token-lps) true)
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
    (defun SWPLC|UC_BalancedLiquidity:[decimal] (swpair:string input-id:string input-amount:decimal)
        @doc "Outputs the amount of tokens, for given <input-id> and <input-amount> that are needed to add Balanced Liquidity"
        (let*
            (
                (pool-token-ids:[string] (SWP.SWP|UR_PoolTokens swpair))
                (iz-on-pool:bool (SWP.SWP|UEV_CheckAgainst [input-id] pool-token-ids))
            )
            (SWP.SWP|UEV_id swpair)
            (BASIS.DPTF-DPMF|UEV_Amount input-id input-amount true)
            (enforce iz-on-pool (format "Input Token {} is not part of the Pool {} Tokens" [input-id swpair]))
            (let
                (
                    (input-position:integer (SWP.SWP|UR_PoolTokenPosition swpair input-id))
                    (input-precision:integer (BASIS.DPTF-DPMF|UR_Decimals input-id true))
                    (X:[decimal]
                        (if (= (SWPLC|UC_LpCapacity swpair) 0.0)
                            (SWP.SWP|UR_PoolGenesisSupply swpair)
                            (SWP.SWP|UR_PoolTokenSupplies swpair)
                        )
                    )
                    (Xp:[integer] (SWP.SWP|UR_PoolTokenPrecisions swpair))
                )
                (SUT.SWP|UC_BalancedLiquidity input-amount input-position input-precision X Xp)
            )
        )
    )
    (defun SWPLC|UC_SymetricLpAmount:decimal (swpair:string input-id:string input-amount:decimal)
        @doc "Computes the Amount of LP resulted, if balanced Liquidity (derived from <input-id> and <input-amount>) \
        \ were to be added to a Constant Product Pool"
        (if (= (take 1 swpair) "P")
            (SWPLC|UC_P_LpAmount swpair (SWPLC|UC_BalancedLiquidity swpair input-id input-amount))
            (SWPLC|UC_S_LpAmount swpair (SWPLC|UC_BalancedLiquidity swpair input-id input-amount))
        )
    )
    ;;
    (defun SWPLC|UC_LpBreakAmounts:[decimal] (swpair:string input-lp-amount:decimal)
        @doc "Computes the Pool Token Amounts that result from removing <input-lp-amount> of LP Token"
        (let*
            (
                (lp-supply:decimal (SWPLC|UC_LpCapacity swpair))
                (ratio:decimal (floor (/ input-lp-amount lp-supply) 24))
                (pool-token-supplies:[decimal] (SWP.SWP|UR_PoolTokenSupplies swpair))
                (pool-token-precisions:[integer] (SWP.SWP|UR_PoolTokenPrecisions swpair))
            )
            (if (= input-lp-amount lp-supply)
                pool-token-supplies
                (fold
                    (lambda
                        (acc:[decimal] idx:integer)
                        (UTILS.LIST|UC_AppendLast 
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
    ;;
    (defun SWPLC|UC_LpAmount:decimal (swpair:string input-amounts:[decimal])
        @doc "Computes the LP Amount resulting from adding Liquidity with <input-amount> Tokens on <swpair> Pool"
        (if (= (take 1 swpair) "P")
            (SWPLC|UC_P_LpAmount swpair input-amounts)
            (SWPLC|UC_S_LpAmount swpair input-amounts)
        )
    )
    (defun SWPLC|UC_P_LpAmount:decimal (swpair:string input-amounts:[decimal])
        @doc "Computes the LP Amount you get on a Constant Product Pool, when adding the <input-amounts> of Pool Tokens as Liquidity \
        \ The <input-amounts> must contain amounts for all pool tokens, using 0.0 for Pool Tokens that arent being used \
        \ The pool token order is used for the <input-amounts> variable; \
        \ There is no Liquidity fee when computing the amount for a Constant Product Pool, since it has no concept of balance."
        (let*
            (
                (lp-prec:integer (BASIS.DPTF-DPMF|UR_Decimals (SWP.SWP|UR_TokenLP swpair) true))
                (read-lp-supply:decimal (SWPLC|UC_LpCapacity swpair))
                (lp-supply:decimal 
                    (if (= read-lp-supply 0.0)
                        10000000.0
                        read-lp-supply
                    )
                )
                (pool-token-supplies:[decimal] 
                    (if (= read-lp-supply 0.0)
                        (SWP.SWP|UR_PoolGenesisSupply swpair)
                        (SWP.SWP|UR_PoolTokenSupplies swpair)
                    )
                )
                (li:integer (length input-amounts))
                (lc:integer (length pool-token-supplies))
                (iz-balanced:bool (SWPLC|UC_AreAmountsBalanced swpair input-amounts))
            )
            (enforce (= li lc) "Incorrect Pool Token Ammounts")
            (SWP.SWP|UEV_id swpair)
            (if iz-balanced
                (floor (* (/ (at 0 input-amounts) (at 0 pool-token-supplies)) lp-supply) lp-prec)
                (let*
                    (
                        (percent-lst:[decimal] (UTILS.VST|UC_SplitBalanceForVesting 24 1.0 li))
                        (lp-amounts:[decimal]
                            (fold
                                (lambda
                                    (acc:[decimal] idx:integer)
                                    (let*
                                        (
                                            (token-percent:decimal (floor (/ (at idx input-amounts) (at idx pool-token-supplies)) 24))
                                            (lp-amount:decimal (floor (fold (*) 1.0 [token-percent (at idx percent-lst) lp-supply]) lp-prec))
                                        )
                                        (UTILS.LIST|UC_AppendLast 
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
    (defun SWPLC|UC_S_LpAmount:decimal (swpair:string input-amounts:[decimal])
        @doc "Computes the LP Amount you get on a Stable Pool, when adding the <input-amounts> of Pool Tokens as Liquidity \
        \ The <input-amounts> must contain amounts for all pool tokens, using 0.0 for Pool Tokens that arent being used \
        \ The pool token order is used for the <input-amounts> variable; \
        \ Liquidity Fee is hardcoded at 1%."
        (let*
            (
                (lp-prec:integer (BASIS.DPTF-DPMF|UR_Decimals (SWP.SWP|UR_TokenLP swpair) true))
                (read-lp-supply:decimal (SWPLC|UC_LpCapacity swpair))
                (lp-supply:decimal 
                    (if (= read-lp-supply 0.0)
                        10000000.0
                        read-lp-supply
                    )
                )
                (pool-token-supplies:[decimal] 
                    (if (= read-lp-supply 0.0)
                        (SWP.SWP|UR_PoolGenesisSupply swpair)
                        (SWP.SWP|UR_PoolTokenSupplies swpair)
                    )
                )
                (liquidity-fee:decimal (/ (SWP.SWP|UC_LiquidityFee swpair) 1000.0))
                (pool-token-supplies:[decimal] (SWP.SWP|UR_PoolTokenSupplies swpair))
                (li:integer (length input-amounts))
                (lc:integer (length pool-token-supplies))
                (iz-balanced:bool (SWPLC|UC_AreAmountsBalanced swpair input-amounts))
            )
            (enforce (= li lc) "Incorrect Pool Token Ammounts")
            (SWP.SWP|UEV_id swpair)
            (if iz-balanced
                (floor (* (/ (at 0 input-amounts) (at 0 pool-token-supplies)) lp-supply) lp-prec)
                (let*
                    (
                        (amp:decimal (SWP.SWP|UR_Amplifier swpair))
                        (new-balances:[decimal] (zip (+) pool-token-supplies input-amounts))
                        (d0:decimal (SUT.SUT|UC_ComputeD amp pool-token-supplies))
                        (d1:decimal (SUT.SUT|UC_ComputeD amp new-balances))
                        (dr:decimal (floor (/ d1 d0) 24))
                        (Xp:[integer] (SWP.SWP|UR_PoolTokenPrecisions swpair))
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
                                        (UTILS.LIST|UC_AppendLast 
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
                    (floor (/ (* (- (SUT.SUT|UC_ComputeD amp adjusted-balances) d0) lp-supply) d0) lp-prec)
                )
            )
        )
    )
)