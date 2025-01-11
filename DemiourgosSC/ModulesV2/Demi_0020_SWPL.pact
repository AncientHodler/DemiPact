(module SWPL GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (SWPL-ADMIN))
    )
    (defcap SWPL-ADMIN ()
        (enforce-one
            "SWPL Swapper Admin not satisfed"
            [
                (enforce-guard G-MD_SWPL)
                (enforce-guard G-SC_SWPL)
            ]
        )
    )

    (defconst G-MD_SWPL   (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_SWPL   (keyset-ref-guard SWP.SWP|SC_KEY))
    ;;
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
    (defun SWPL|UC_AddLiquidityIgnisCost:decimal (swpair:string input-amounts:[decimal])
        (let
            (
                (med:decimal (DALOS.DALOS|UR_UsagePrice "ignis|medium"))
                (liq:decimal (DALOS.DALOS|UR_UsagePrice "ignis|swp-liquidity"))
                (iz-balanced:bool (SWPLC.SWPLC|UC_AreAmountsBalanced swpair input-amounts))
                (n:decimal (dec (length (SWP.SWP|UR_PoolTokens swpair))))
                (m:decimal (dec (length (UTILS.LIST|UC_RemoveItem input-amounts 0.0))))
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
    (defun SWPL|C_AddBalancedLiquidity:decimal (patron:string account:string swpair:string input-id:string input-amount:decimal)
        (SWPL|C_AddLiquidity patron account swpair (SWPLC.SWPLC|UC_BalancedLiquidity swpair input-id input-amount))          
    )
    (defun SWPL|C_AddLiquidity:decimal (patron:string account:string swpair:string input-amounts:[decimal])
        (with-capability (SWPL|ADD_LIQUIDITY swpair input-amounts)
            (let*
                (
                    (ignis-cost:decimal (SWPL|UC_AddLiquidityIgnisCost swpair input-amounts))
                    (pool-token-ids:[string] (SWP.SWP|UR_PoolTokens swpair))
                    (lp-id:string (SWP.SWP|UR_TokenLP swpair))
                    (lp-amount:decimal (SWPLC.SWPLC|UC_LpAmount swpair input-amounts))
                    (pt-current-amounts:[decimal] (SWP.SWP|UR_PoolTokenSupplies swpair))
                    (pt-new-amounts:[decimal] (zip (+) pt-current-amounts input-amounts))
                )
                (DALOS.IGNIS|C_Collect patron patron ignis-cost)
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
                    (pt-output-amounts:[decimal] (SWPLC.SWPLC|UC_LpBreakAmounts swpair lp-amount))
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