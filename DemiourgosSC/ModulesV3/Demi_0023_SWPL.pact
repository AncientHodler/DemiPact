;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module SWPL GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_SWPL           (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_SWPL           (keyset-ref-guard SWP.SWP|SC_KEY))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|SWPL_ADMIN))
    )
    (defcap GOV|SWPL_ADMIN ()
        (enforce-one
            "SWPL Swapper Admin not satisfed"
            [
                (enforce-guard GOV|MD_SWPL)
                (enforce-guard GOV|SC_SWPL)
            ]
        )
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    (defcap P|SWPL|CALLER ()
        true
    )
    (defcap P|SWPL|REMOTE-GOV ()
        true
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|SWPL_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        true
        (SWP.P|A_Add
            "SWPL|Caller"
            (create-capability-guard (P|SWPL|CALLER))
        )
        (SWP.P|A_Add
            "SWPL|RemoteSwapGovernor"
            (create-capability-guard (P|SWPL|REMOTE-GOV))
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
    ;;{5}
    ;;{6}
    ;;{7}
    (defcap SWPL|C>ADD_LQ (swpair:string input-amounts:[decimal])
        @event
        (let*
            (
                (can-add:bool (SWP.SWP|UR_CanAdd swpair))
                (pool-token-ids:[string] (SWP.SWP|UR_PoolTokens swpair))
                (l0:integer (length input-amounts))
                (l1:integer (length pool-token-ids))
                (lengths:[integer] [l0 l1])
            )
            (UTILS.UTILS|UEV_EnforceUniformIntegerList lengths)
            (SWP.SWP|UEV_id swpair)
            (map
                (lambda 
                    (idx:integer)
                    (if (> (at idx input-amounts) 0.0)
                        (DPTF.DPTF|UEV_Amount (at idx pool-token-ids) (at idx input-amounts))
                        true
                    )
                )
                (enumerate 0 (- l0 1))
            )
            (enforce can-add "Pool is inactive: cannot add or remove liqudity!")
        )
        (compose-capability (P|SWPL|REMOTE-GOV))
        (compose-capability (P|SWPL|CALLER))
    )
    (defcap SWPL|C>RM_LQ (swpair:string lp-amount:decimal)
        @event
        (let*
            (
                (can-add:bool (SWP.SWP|UR_CanAdd swpair))
                (lp-id:string (SWP.SWP|UR_TokenLP swpair))
                (pool-lp-amount:decimal (DPTF.DPTF|UR_Supply lp-id))
            )
            (DPTF.DPTF|UEV_Amount lp-id lp-amount)
            (SWP.SWP|UEV_id swpair)
            (enforce (<= lp-amount pool-lp-amount) (format "{} is an invalid LP Amount for removing Liquidity" [lp-amount]))
            (enforce can-add "Pool is inactive: cannot add or remove liqudity!")
        )
        (compose-capability (P|SWPL|REMOTE-GOV))
            (compose-capability (P|SWPL|CALLER))
    )

    ;;
    ;;{8}
    ;;{9}
    ;;{10}
    ;;{11}
    ;;{12}
    ;;{13}
    (defun SWPL|URC_AddLiquidityIgnisCost:decimal (swpair:string input-amounts:[decimal])
        (let
            (
                (med:decimal (DALOS.DALOS|UR_UsagePrice "ignis|medium"))
                (liq:decimal (DALOS.DALOS|UR_UsagePrice "ignis|swp-liquidity"))
                (iz-balanced:bool (SWPLC.SWPLC|URC_AreAmountsBalanced swpair input-amounts))
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
    ;;
    ;;{14}
    ;;{15}
    (defun SWPL|C_AddBalancedLiquidity:decimal (patron:string account:string swpair:string input-id:string input-amount:decimal)
        (SWPL|C_AddLiquidity patron account swpair (SWPLC.SWPLC|URC_BalancedLiquidity swpair input-id input-amount))          
    )
    (defun SWPL|C_AddLiquidity:decimal (patron:string account:string swpair:string input-amounts:[decimal])
        (with-capability (SWPL|C>ADD_LQ swpair input-amounts)
            (let*
                (
                    (read-lp-supply:decimal (SWPLC.SWPLC|URC_LpCapacity swpair))
                    (ignis-cost:decimal (SWPL|URC_AddLiquidityIgnisCost swpair input-amounts))
                    (additional-ignis-cost:decimal
                        (if (= read-lp-supply 0.0)
                            (DALOS.DALOS|UR_UsagePrice "ignis|biggest")
                            0.0
                        )
                    )
                    (final-ignis-cost:decimal (+ ignis-cost additional-ignis-cost))
                    (gw:[decimal] (SWP.SWP|UR_GenesisWeigths swpair))
                )
                (DALOS.IGNIS|C_Collect patron patron final-ignis-cost)
                (if (= read-lp-supply 0.0)
                    (SWP.SWP|X_ModifyWeights swpair gw)
                    true
                )
                (let*
                    (
                        (pool-token-ids:[string] (SWP.SWP|UR_PoolTokens swpair))
                        (lp-id:string (SWP.SWP|UR_TokenLP swpair))
                        (lp-amount:decimal (SWPLC.SWPLC|URC_LpAmount swpair input-amounts))
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
                    (DPTF.DPTF|C_Mint patron lp-id SWP.SWP|SC_NAME lp-amount false)
                    (TFT.DPTF|C_Transfer patron lp-id SWP.SWP|SC_NAME account lp-amount true)
                    lp-amount
                )
            )
        )
    )
    (defun SWPL|C_RemoveLiquidity:[decimal] (patron:string account:string swpair:string lp-amount:decimal)
        (with-capability (SWPL|C>RM_LQ swpair lp-amount)
            (let*
                (
                    (pool-token-ids:[string] (SWP.SWP|UR_PoolTokens swpair))
                    (lp-id:string (SWP.SWP|UR_TokenLP swpair))
                    (pt-output-amounts:[decimal] (SWPLC.SWPLC|URC_LpBreakAmounts swpair lp-amount))
                    (pt-current-amounts:[decimal] (SWP.SWP|UR_PoolTokenSupplies swpair))
                    (pt-new-amounts:[decimal] (zip (-) pt-current-amounts pt-output-amounts))
                )
                (TFT.DPTF|C_Transfer patron lp-id account SWP.SWP|SC_NAME lp-amount true)
                (DPTF.DPTF|C_Burn patron lp-id SWP.SWP|SC_NAME lp-amount)
                (TFT.DPTF|C_MultiTransfer patron pool-token-ids SWP.SWP|SC_NAME account pt-output-amounts true)
                (SWP.SWP|X_UpdateSupplies swpair pt-new-amounts)
                pt-output-amounts
            )
        )
    )
    ;;{16}
)

(create-table P|T)