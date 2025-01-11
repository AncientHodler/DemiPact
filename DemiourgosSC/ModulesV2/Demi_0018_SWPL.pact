(module SWPL GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (SWPL-ADMIN))
    )
    (defcap SWPL-ADMIN ()
        (enforce-one
            "SWPL Autostake Admin not satisfed"
            [
                (enforce-guard G-MD_SWPL)
                (enforce-guard G-SC_SWPL)
            ]
        )
    )

    (defconst G-MD_SWPL   (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_SWPL   (keyset-ref-guard SWP.SWP|SC_KEY))

    (defcap COMPOSE ()
        true
    )
    (defcap SECURE ()
        true
    )
    (defcap P|SWPL|CALLER ()
        true
    )
    (defcap P|SWPL|REMOTE-GOV ()
        true
    )
    ;;
    (defun A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (SWPL-ADMIN)
            (write PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun C_ReadPolicy:guard (policy-name:string)
        (at "policy" (read PoliciesTable policy-name ["policy"]))
    )
    (defun DefinePolicies ()
        true
        (SWP.A_AddPolicy
            "SWPL|Caller"
            (create-capability-guard (P|SWPL|CALLER))
        )
        (SWP.A_AddPolicy
            "SWPL|RemoteSwapGovernor"
            (create-capability-guard (P|SWPL|REMOTE-GOV))
        )
    )
    (deftable PoliciesTable:{DALOS.PolicySchema})
    ;;
    (defun SWPL|UC_AreAmountsBalanced:bool (swpair:string input-amounts:[decimal])
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
                    (balanced-amounts:[decimal] (SWPL|UC_BalancedLiquidity swpair first-positive-id first-positive-amount))
                )
                (if (= balanced-amounts input-amounts)
                    true
                    false
                )
            )
        )
    )
    (defun SWPL|UC_LpCapacity:decimal (swpair:string)
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
    (defun SWPL|UC_BalancedLiquidity:[decimal] (swpair:string input-id:string input-amount:decimal)
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
                        (if (= (SWPL|UC_LpCapacity swpair) 0.0)
                            (SWP.SWP|UR_PoolGenesisSupply swpair)
                            (SWP.SWP|UR_PoolTokenSupplies swpair)
                        )
                    )
                    (Xp:[integer] (SWP.SWP|UR_PoolTokenPrecisions swpair))
                )
                (UTILS.SWP|UC_BalancedLiquidity input-amount input-position input-precision X Xp)
            )
        )
    )
    (defun SWPL|UC_SymetricLpAmount:decimal (swpair:string input-id:string input-amount:decimal)
        @doc "Computes the Amount of LP resulted, if balanced Liquidity (derived from <input-id> and <input-amount>) \
        \ were to be added to a Constant Product Pool"
        (if (= (take 1 swpair) "P")
            (SWPL|UC_P_LpAmount swpair (SWPL|UC_BalancedLiquidity swpair input-id input-amount))
            (SWPL|UC_S_LpAmount swpair (SWPL|UC_BalancedLiquidity swpair input-id input-amount))
        )
    )
    ;;
    (defun SWPL|UC_LpBreakAmounts:[decimal] (swpair:string input-lp-amount:decimal)
        @doc "Computes the Pool Token Amounts that result from removing <input-lp-amount> of LP Token"
        (let*
            (
                (lp-supply:decimal (SWPL|UC_LpCapacity swpair))
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
    (defun SWPL|UC_LpAmount:decimal (swpair:string input-amounts:[decimal])
        @doc "Computes the LP Amount resulting from adding Liquidity with <input-amount> Tokens on <swpair> Pool"
        (if (= (take 1 swpair) "P")
            (SWPL|UC_P_LpAmount swpair input-amounts)
            (SWPL|UC_S_LpAmount swpair input-amounts)
        )
    )
    (defun SWPL|UC_P_LpAmount:decimal (swpair:string input-amounts:[decimal])
        @doc "Computes the LP Amount you get on a Constant Product Pool, when adding the <input-amounts> of Pool Tokens as Liquidity \
        \ The <input-amounts> must contain amounts for all pool tokens, using 0.0 for Pool Tokens that arent being used \
        \ The pool token order is used for the <input-amounts> variable; \
        \ There is no Liquidity fee when computing the amount for a Constant Product Pool, since it has no concept of balance."
        (let*
            (
                (lp-prec:integer (BASIS.DPTF-DPMF|UR_Decimals (SWP.SWP|UR_TokenLP swpair) true))
                (read-lp-supply:decimal (SWPL|UC_LpCapacity swpair))
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
                (iz-balanced:bool (SWPL|UC_AreAmountsBalanced swpair input-amounts))
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
    (defun SWPL|UC_S_LpAmount:decimal (swpair:string input-amounts:[decimal])
        @doc "Computes the LP Amount you get on a Stable Pool, when adding the <input-amounts> of Pool Tokens as Liquidity \
        \ The <input-amounts> must contain amounts for all pool tokens, using 0.0 for Pool Tokens that arent being used \
        \ The pool token order is used for the <input-amounts> variable; \
        \ Liquidity Fee is hardcoded at 1%."
        (let*
            (
                (lp-prec:integer (BASIS.DPTF-DPMF|UR_Decimals (SWP.SWP|UR_TokenLP swpair) true))
                (read-lp-supply:decimal (SWPL|UC_LpCapacity swpair))
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
                (iz-balanced:bool (SWPL|UC_AreAmountsBalanced swpair input-amounts))
            )
            (enforce (= li lc) "Incorrect Pool Token Ammounts")
            (SWP.SWP|UEV_id swpair)
            (if iz-balanced
                (floor (* (/ (at 0 input-amounts) (at 0 pool-token-supplies)) lp-supply) lp-prec)
                (let*
                    (
                        (amp:decimal (SWP.SWP|UR_Amplifier swpair))
                        (new-balances:[decimal] (zip (+) pool-token-supplies input-amounts))
                        (d0:decimal (UTILS.SWP|UCC_ComputeD amp pool-token-supplies))
                        (d1:decimal (UTILS.SWP|UCC_ComputeD amp new-balances))
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
                    (floor (/ (* (- (UTILS.SWP|UCC_ComputeD amp adjusted-balances) d0) lp-supply) d0) lp-prec)
                )
            )
        )
    )
    ;;[CAP]
    (defcap SWPL|ADD_LIQUIDITY (swpair:string input-amounts:[decimal])
        (let*
            (
                (can-add:bool (SWP.SWP|UR_CanAdd swpair))
                (pool-token-ids:[string] (SWP.SWP|UR_PoolTokens swpair))
                (l0:integer (length input-amounts))
                (l1:integer (length pool-token-ids))
                (lengths:[integer] [l0 l1])
            )
            (compose-capability (P|SWPL|REMOTE-GOV))
            (compose-capability (P|SWPL|CALLER))
            (UTILS.UTILS|UEV_EnforceUniformIntegerList lengths)
            (SWP.SWP|UEV_id swpair)
            (map
                (lambda 
                    (idx:integer)
                    (if (> (at idx input-amounts) 0.0)
                        (BASIS.DPTF-DPMF|UEV_Amount (at idx pool-token-ids) (at idx input-amounts) true)
                        true
                    )
                )
                (enumerate 0 (- l0 1))
            )
            (enforce can-add "Pool is inactive: cannot add or remove liqudity!")
        )
    )
    (defcap SWPL|REMOVE_LIQUIDITY (swpair:string lp-amount:decimal)
        (let*
            (
                (can-add:bool (SWP.SWP|UR_CanAdd swpair))
                (lp-id:string (SWP.SWP|UR_TokenLP swpair))
                (pool-lp-amount:decimal (BASIS.DPTF-DPMF|UR_Supply lp-id true))
            )
            (compose-capability (P|SWPL|REMOTE-GOV))
            (compose-capability (P|SWPL|CALLER))
            (BASIS.DPTF-DPMF|UEV_Amount lp-id lp-amount true)
            (SWP.SWP|UEV_id swpair)
            (enforce (<= lp-amount pool-lp-amount) (format "{} is an invalid LP Amount for removing Liquidity" [lp-amount]))
            (enforce can-add "Pool is inactive: cannot add or remove liqudity!")
        )
    )
    ;;[C]
    (defun SWPL|C_AddLiquidity:decimal (patron:string account:string swpair:string input-amounts:[decimal])
        (with-capability (SWPL|ADD_LIQUIDITY swpair input-amounts)
            (let*
                (
                    (pool-token-ids:[string] (SWP.SWP|UR_PoolTokens swpair))
                    (lp-id:string (SWP.SWP|UR_TokenLP swpair))
                    (lp-amount:decimal (SWPL|UC_LpAmount swpair input-amounts))
                    (pt-current-amounts:[decimal] (SWP.SWP|UR_PoolTokenSupplies swpair))
                    (pt-new-amounts:[decimal] (zip (+) pt-current-amounts input-amounts))
                )
                (map
                    (lambda 
                        (idx:integer)
                        (if (> (at idx input-amounts) 0.0)
                            (TFT.DPTF|C_Transfer patron (at idx pool-token-ids) account SWP.SWP|SC_NAME (at idx input-amounts) true)
                            true
                        )
                    )
                    (enumerate 0 (- (length input-amounts) 1))
                )
                (SWP.SWP|X_UpdateSupplies swpair pt-new-amounts)
                (BASIS.DPTF|C_Mint patron lp-id SWP.SWP|SC_NAME lp-amount false)
                (TFT.DPTF|C_Transfer patron lp-id SWP.SWP|SC_NAME account lp-amount true)
                lp-amount
            )
        )
    )
    (defun SWPL|C_RemoveLiquidity:[decimal] (patron:string account:string swpair:string lp-amount:decimal)
        (with-capability (SWPL|REMOVE_LIQUIDITY swpair lp-amount)
            (let*
                (
                    (pool-token-ids:[string] (SWP.SWP|UR_PoolTokens swpair))
                    (lp-id:string (SWP.SWP|UR_TokenLP swpair))
                    (pt-output-amounts:[decimal] (SWPL|UC_LpBreakAmounts swpair lp-amount))
                    (pt-current-amounts:[decimal] (SWP.SWP|UR_PoolTokenSupplies swpair))
                    (pt-new-amounts:[decimal] (zip (-) pt-current-amounts pt-output-amounts))
                )
                (TFT.DPTF|C_Transfer patron lp-id account SWP.SWP|SC_NAME lp-amount true)
                (BASIS.DPTF|C_Burn patron lp-id SWP.SWP|SC_NAME lp-amount)
                (TFT.DPTF|C_MultiTransfer patron pool-token-ids SWP.SWP|SC_NAME account pt-output-amounts true)
                (SWP.SWP|X_UpdateSupplies swpair pt-new-amounts)
                pt-output-amounts
            )
        )
    )
)

(create-table PoliciesTable)