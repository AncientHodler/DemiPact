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
    (defun UC_SlippageMinMax:[decimal] (input:object{Slippage}))
    ;;
    (defun URC_TokenDollarPrice (id:string kda-pid:decimal))
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
    (defun SWPI|UEV_Issue (account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool))
    ;;
    (defun UDC_SlippageObject:object{Slippage} (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage-value:decimal))
    ;;
    (defun SWPI|C_Issue:object{OuronetDalos.IgnisCumulator} (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool))
    (defun PS|C_IssueStableMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal amp:decimal p:bool))
    (defun PS|C_IssueStandardMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal p:bool))
    (defun PS|C_IssueWeightedMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool))
    ;;
    (defun C_ToggleAddLiquidity:object{OuronetDalos.IgnisCumulator} (patron:string swpair:string toggle:bool))
    (defun C_ToggleSwapCapability:object{OuronetDalos.IgnisCumulator} (patron:string swpair:string toggle:bool))
    ;;
    (defun SWPL|C_AddBalancedLiquidity:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-id:string input-amount:decimal))
    (defun SWPL|C_AddSleepingLiquidity:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string sleeping-dpmf:string nonce:integer))
    (defun SWPL|C_AddFrozenLiquidity:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal))
    (defun SWPL|C_AddLiquidity:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-amounts:[decimal]))
    (defun SWPL|C_RemoveLiquidity:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string lp-amount:decimal))
    ;;
    (defun SWPS|OPU|C_SimpleSwap:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string slippage:object{Slippage} kda-pid:decimal))
    (defun SWPS|OPU|C_SimpleSwapNoSlippage:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string kda-pid:decimal))
    (defun SWPS|OPU|C_MultiSwap:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:object{Slippage} kda-pid:decimal))
    (defun SWPS|OPU|C_MultiSwapNoSlippage:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string kda-pid:decimal))
    ;;
    (defun SWPS|C_SimpleSwap:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string slippage:object{Slippage}))
    (defun SWPS|C_SimpleSwapNoSlippage:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string))
    (defun SWPS|C_MultiSwap:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:object{Slippage}))
    (defun SWPS|C_MultiSwapNoSlippage:object{OuronetDalos.IgnisCumulator} (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string))
)
(interface SwapperUsageV2
    @doc "Exposes Adding|Removing Liquidty and Swapping Functions of the SWP Module\ 
    \ \
    \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
    \ Branding for LP added to the SPWU from SWP Module"
    ;;
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
    ;;
    (defun UC_SlippageMinMax:[decimal] (input:object{Slippage}))
    ;;
    (defun URC_TokenDollarPrice (id:string kda-pid:decimal))
    (defun URC_SingleWorthDWK (id:string))
    (defun URC_WorthDWK (id:string amount:decimal))
    (defun URC_PoolWorthDWK:decimal (swpair:string))
    ;;
    (defun URC_EntityPosToID:string (swpair:string entity-pos:integer))
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
    (defun SWPI|UEV_Issue (account:string pool-tokens:[object{SwapperV2.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool))
    ;;
    (defun UDC_SlippageObject:object{Slippage} (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage-value:decimal))
    ;;
    ;;
    (defun SWPI|C_Issue:object{OuronetDalosV2.OutputCumulatorV2} (patron:string account:string pool-tokens:[object{SwapperV2.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool))
    (defun PS|C_IssueStableMultiStep (patron:string account:string pool-tokens:[object{SwapperV2.PoolTokens}] fee-lp:decimal amp:decimal p:bool))
    (defun PS|C_IssueStandardMultiStep (patron:string account:string pool-tokens:[object{SwapperV2.PoolTokens}] fee-lp:decimal p:bool))
    (defun PS|C_IssueWeightedMultiStep (patron:string account:string pool-tokens:[object{SwapperV2.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool))
    ;;
    (defun C_ToggleAddLiquidity:object{OuronetDalosV2.OutputCumulatorV2} (patron:string swpair:string toggle:bool))
    (defun C_ToggleSwapCapability:object{OuronetDalosV2.OutputCumulatorV2} (patron:string swpair:string toggle:bool))
    ;;
    (defun SWPL|C_AddBalancedLiquidity:object{OuronetDalosV2.OutputCumulatorV2} (patron:string account:string swpair:string input-id:string input-amount:decimal))
    (defun SWPL|C_AddSleepingLiquidity:object{OuronetDalosV2.OutputCumulatorV2} (patron:string account:string swpair:string sleeping-dpmf:string nonce:integer))
    (defun SWPL|C_AddFrozenLiquidity:object{OuronetDalosV2.OutputCumulatorV2} (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal))
    (defun SWPL|C_AddLiquidity:object{OuronetDalosV2.OutputCumulatorV2} (patron:string account:string swpair:string input-amounts:[decimal]))
    (defun SWPL|C_RemoveLiquidity:object{OuronetDalosV2.OutputCumulatorV2} (patron:string account:string swpair:string lp-amount:decimal))
    ;;
    (defun SWPS|OPU|C_SimpleSwap:object{OuronetDalosV2.OutputCumulatorV2} (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string slippage:object{Slippage} kda-pid:decimal))
    (defun SWPS|OPU|C_SimpleSwapNoSlippage:object{OuronetDalosV2.OutputCumulatorV2} (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string kda-pid:decimal))
    (defun SWPS|OPU|C_MultiSwap:object{OuronetDalosV2.OutputCumulatorV2} (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:object{Slippage} kda-pid:decimal))
    (defun SWPS|OPU|C_MultiSwapNoSlippage:object{OuronetDalosV2.OutputCumulatorV2} (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string kda-pid:decimal))
    ;;
    (defun SWPS|C_SimpleSwap:object{OuronetDalosV2.OutputCumulatorV2} (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string slippage:object{Slippage}))
    (defun SWPS|C_SimpleSwapNoSlippage:object{OuronetDalosV2.OutputCumulatorV2} (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string))
    (defun SWPS|C_MultiSwap:object{OuronetDalosV2.OutputCumulatorV2} (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:object{Slippage}))
    (defun SWPS|C_MultiSwapNoSlippage:object{OuronetDalosV2.OutputCumulatorV2} (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string))
)
(interface SwapperUsageV3
    @doc "Exposes Adding|Removing Liquidty and Swapping Functions of the SWP Module\ 
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
        \ Branding for LP added to the SPWU from SWP Module \
        \ \
        \ V3 Removes <patron> input variable where it is not needed"
    ;;
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
    ;;
    (defun UC_SlippageMinMax:[decimal] (input:object{Slippage}))
    ;;
    (defun URC_TokenDollarPrice (id:string kda-pid:decimal))
    (defun URC_SingleWorthDWK (id:string))
    (defun URC_WorthDWK (id:string amount:decimal))
    (defun URC_PoolWorthDWK:decimal (swpair:string))
    ;;
    (defun URC_EntityPosToID:string (swpair:string entity-pos:integer))
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
    (defun SWPI|UEV_Issue (account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool))
    ;;
    (defun UDC_SlippageObject:object{Slippage} (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage-value:decimal))
    ;;
    ;;
    (defun SWPI|C_Issue:object{OuronetDalosV3.OutputCumulatorV2} (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool))
    (defun PS|C_IssueStableMultiStep (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal amp:decimal p:bool))
    (defun PS|C_IssueStandardMultiStep (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal p:bool))
    (defun PS|C_IssueWeightedMultiStep (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool))
    ;;
    (defun C_ToggleAddLiquidity:object{OuronetDalosV3.OutputCumulatorV2} (swpair:string toggle:bool))
    (defun C_ToggleSwapCapability:object{OuronetDalosV3.OutputCumulatorV2} (swpair:string toggle:bool))
    ;;
    (defun SWPL|C_AddBalancedLiquidity:object{OuronetDalosV3.OutputCumulatorV2} (account:string swpair:string input-id:string input-amount:decimal))
    (defun SWPL|C_AddSleepingLiquidity:object{OuronetDalosV3.OutputCumulatorV2} (account:string swpair:string sleeping-dpmf:string nonce:integer))
    (defun SWPL|C_AddFrozenLiquidity:object{OuronetDalosV3.OutputCumulatorV2} (account:string swpair:string frozen-dptf:string input-amount:decimal))
    (defun SWPL|C_AddLiquidity:object{OuronetDalosV3.OutputCumulatorV2} (account:string swpair:string input-amounts:[decimal]))
    (defun SWPL|C_RemoveLiquidity:object{OuronetDalosV3.OutputCumulatorV2} (account:string swpair:string lp-amount:decimal))
    ;;
    (defun SWPS|OPU|C_SimpleSwap:object{OuronetDalosV3.OutputCumulatorV2} (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string slippage:object{Slippage} kda-pid:decimal))
    (defun SWPS|OPU|C_SimpleSwapNoSlippage:object{OuronetDalosV3.OutputCumulatorV2} (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string kda-pid:decimal))
    (defun SWPS|OPU|C_MultiSwap:object{OuronetDalosV3.OutputCumulatorV2} (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:object{Slippage} kda-pid:decimal))
    (defun SWPS|OPU|C_MultiSwapNoSlippage:object{OuronetDalosV3.OutputCumulatorV2} (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string kda-pid:decimal))
    ;;
    (defun SWPS|C_SimpleSwap:object{OuronetDalosV3.OutputCumulatorV2} (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string slippage:object{Slippage}))
    (defun SWPS|C_SimpleSwapNoSlippage:object{OuronetDalosV3.OutputCumulatorV2} (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string))
    (defun SWPS|C_MultiSwap:object{OuronetDalosV3.OutputCumulatorV2} (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:object{Slippage}))
    (defun SWPS|C_MultiSwapNoSlippage:object{OuronetDalosV3.OutputCumulatorV2} (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string))
)
(interface SwapperUsageV4
    @doc "Exposes Adding|Removing Liquidty and Swapping Functions of the SWP Module\ 
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
        \ Branding for LP added to the SPWU from SWP Module \
        \ \
        \ V3 Removes <patron> input variable where it is not needed \
        \ V4 Brings SWPU Segregation into SWPI, SWPL and a new SWPU that contains only Swap related Functions \
        \ and removes <patron> from the Swapping Functions as it is not needed (hasnt been observed earlier)"
    ;;
    (defschema Slippage
        expected-output-amount:decimal
        output-precision:integer
        slippage-percent:decimal
    )
    ;;
    ;;
    (defun UC_SlippageMinMax:[decimal] (input:object{Slippage}))
    ;;
    (defun UDC_SlippageObject:object{Slippage} (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage-value:decimal))
    ;;
    ;;
    (defun C_ToggleSwapCapability:object{OuronetDalosV3.OutputCumulatorV2} (swpair:string toggle:bool))
        ;;
    (defun OPU|C_SimpleSwapNoSlippage:object{OuronetDalosV3.OutputCumulatorV2} 
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} kda-pid:decimal)
    )
    (defun OPU|C_MultiSwapNoSlippage:object{OuronetDalosV3.OutputCumulatorV2} 
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} kda-pid:decimal)
    )
    (defun OPU|C_SimpleSwap:object{OuronetDalosV3.OutputCumulatorV2} 
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:object{Slippage} kda-pid:decimal)
    )
    (defun OPU|C_MultiSwap:object{OuronetDalosV3.OutputCumulatorV2} 
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:object{Slippage} kda-pid:decimal)
    )
        ;;
    (defun C_SimpleSwapNoSlippage:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData})
    )
    (defun C_MultiSwapNoSlippage:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData})
    )
    (defun C_SimpleSwap:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:object{Slippage})
    )
    (defun C_MultiSwap:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:object{Slippage})
    )
)
(module SWPU GOV
    ;;
    (implements OuronetPolicy)
    (implements SwapperUsageV4)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_SWPU           (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|SWPU_ADMIN)))
    (defcap GOV|SWPU_ADMIN ()       (enforce-guard GOV|MD_SWPU))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::P|Info)))
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
    (defun CT_EmptyCumulator        ()(let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::DALOS|EmptyOutputCumulatorV2)))
    (defconst BAR                   (CT_Bar))
    (defconst EOC                   (CT_EmptyCumulator))
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
    (defcap SPWU|C>TOGGLE-SWAP (swpair:string toggle:bool)
        (if toggle
            (let
                (
                    (ref-SWP:module{SwapperV4} SWP)
                    (ref-SWPI:module{SwapperIssue} SWPI)
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
    
    (defcap SWPU|C>PUMP_LQ-IDX ()
        @event
        (compose-capability (P|SWPU|CALLER))
    )
    (defcap SWPU|C>SWAP (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData})
        @event
        (let
            (
                ;;Unwrap Object Data
                (input-ids:[string] (at "input-ids" dsid))
                (input-amounts:[decimal] (at "input-amounts" dsid))
                (output-id:string (at "output-id" dsid))
                ;;
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
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
            (compose-capability (SWPU|C>PUMP_LQ-IDX))
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
    (defun UDC_SlippageObject:object{SwapperUsageV4.Slippage}
        (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage-value:decimal)
        @doc "Makes a Slippage Object from <input amounts>"
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWPI:module{SwapperIssue} SWPI)
                (op:integer (ref-DPTF::UR_Decimals (at "output-id" dsid)))
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
                "Slippage must be greater than 0.0 and maximum 50.0"
            )
            {"expected-output-amount"   : expected
            ,"output-precision"         : op
            ,"slippage-percent"         : slippage-value}
        )
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_ToggleSwapCapability:object{OuronetDalosV3.OutputCumulatorV2}
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
    ;;OPU (With Autonomic Ouroboros Price Update) Swaps
    (defun OPU|C_SimpleSwapNoSlippage:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} kda-pid:decimal)
        (UEV_IMC)
        (with-capability (SECURE)
            (OPU|C_MultiSwapNoSlippage account swpair dsid kda-pid)
        )
    )
    (defun OPU|C_MultiSwapNoSlippage:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} kda-pid:decimal)
        (UEV_IMC)
        (with-capability (SECURE)
            (OPU|XI_MultiSwap account swpair dsid kda-pid)
        )
    )
    (defun OPU|C_SimpleSwap:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:object{SwapperUsageV4.Slippage} kda-pid:decimal)
        (UEV_IMC)
        (with-capability (SECURE)
            (OPU|C_MultiSwap account swpair dsid slippage kda-pid)
        )
    )
    (defun OPU|C_MultiSwap:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:object{SwapperUsageV4.Slippage} kda-pid:decimal)
        (UEV_IMC)
        (with-capability (SECURE)
            (let
                (
                    (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                    (ref-SWPI:module{SwapperIssue} SWPI)
                    ;;Get Max Theoretical Output Amount <max-toa> and compute Slippage
                    (max-toa:decimal (ref-SWPI::URC_Swap swpair dsid true))
                    (min-max:[decimal] (UC_SlippageMinMax slippage))
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
                    (OPU|XI_MultiSwap account swpair dsid kda-pid)
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
    ;;Standard Swaps (Without Autonomic Ouroborous price update)
    (defun C_SimpleSwapNoSlippage:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData})
        (UEV_IMC)
        (with-capability (SECURE)
            (C_MultiSwapNoSlippage account swpair dsid)
        )
    )
    (defun C_MultiSwapNoSlippage:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData})
        (UEV_IMC)
        (with-capability (SECURE)
            (XI_MultiSwap account swpair dsid)
        )
    )
    (defun C_SimpleSwap:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:object{SwapperUsageV4.Slippage})
        (UEV_IMC)
        (with-capability (SECURE)
            (C_MultiSwap account swpair dsid slippage)
        )
    )
    (defun C_MultiSwap:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage:object{SwapperUsageV4.Slippage})
        (UEV_IMC)
        (with-capability (SECURE)
            (let
                (
                    (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                    (ref-SWPI:module{SwapperIssue} SWPI)
                    ;;Get Max Theoretical Output Amount <max-toa> and compute Slippage
                    (max-toa:decimal (ref-SWPI::URC_Swap swpair dsid true))
                    (min-max:[decimal] (UC_SlippageMinMax slippage))
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
                    (XI_MultiSwap account swpair dsid)
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
    ;;{F7}
    (defun OPU|XI_MultiSwap:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} kda-pid:decimal)
        (let
            (
                (output:object{OuronetDalosV3.OutputCumulatorV2}
                    (XI_MultiSwap account swpair dsid)
                )
            )
            ;;4] Updates OURO Price if <ouro-auto-price-via-swaps> is true, the swap is executed in the primal swpair,
            ;;      and if price varies by more than 0.5% of the stored Ouro price.
            (XI_OuroPriceUpdater swpair kda-pid)
            output
        )
    )
    (defun XI_MultiSwap:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData})
        (require-capability (SECURE))
        (with-capability (SWPU|C>SWAP swpair dsid)
            (let
                (
                    ;;Unwrap Object Data
                    (input-ids:[string] (at "input-ids" dsid))
                    (input-amounts:[decimal] (at "input-amounts" dsid))
                    (output-id:string (at "output-id" dsid))
                    ;;
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                    (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (ref-SWP:module{SwapperV4} SWP)
                    (ref-SWPI:module{SwapperIssue} SWPI)
                    ;;
                    ;;Get <output-id> Output-Precision <op> and SWP|SC_NAME
                    (op:integer (ref-DPTF::UR_Decimals output-id))
                    (swp-sc:string (ref-DALOS::GOV|SWP|SC_NAME))

                    ;;Get Pool Fees
                    (lb:bool (ref-SWP::UR_LiquidBoost))
                    (lp-fee:decimal (ref-SWP::UR_FeeLP swpair))
                    (boost-fee:decimal (if lb lp-fee 0.0))
                    (special-fee:decimal (ref-SWP::UR_FeeSP swpair))

                    ;;Apply Elite Account Reduction to fees
                    (major:integer (ref-DALOS::UR_Elite-Tier-Major account))
                    (minor:integer (ref-DALOS::UR_Elite-Tier-Minor account))
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
                    (tsoa:decimal (ref-SWPI::URC_Swap swpair dsid true))
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
                        (ico1:object{OuronetDalosV3.OutputCumulatorV2}
                            (ref-TFT::C_MultiTransfer input-ids account swp-sc input-amounts true)
                        )
                        (ico2:object{OuronetDalosV3.OutputCumulatorV2}
                            (if (= special-fee 0.0)
                                (ref-TFT::C_Transfer output-id swp-sc account remainder-output true)
                                (ref-TFT::C_MultiBulkTransfer
                                    [output-id]
                                    swp-sc
                                    [
                                        (+
                                            (ref-SWP::UR_SpecialFeeTargets swpair)
                                            [account]
                                        )
                                    ]
                                    [
                                        (+
                                            (ref-U|SWP::UC_SpecialFeeOutputs
                                                (ref-SWP::UR_SpecialFeeTargetsProportions swpair)
                                                special-output
                                                op
                                            )
                                            [remainder-output]
                                        )
                                    ]
                                )
                            )
                        )
                        (ico3:object{OuronetDalosV3.OutputCumulatorV2}
                            (if (!= boost-fee 0.0)
                                (XI_PumpLiquidIndex output-id boost-output)
                                EOC
                            )
                        )
                    )
                    (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 [ico1 ico2 ico3] [remainder-output])
                )
                ;;3] Moves Outputs to their designated places
                ;;3.1]  If special fee is zero, move only remainder to client.
                ;;3.2]  If special fee is non zero, additionaly move special fee to special fee targets via BulkTransfer (ico2)
                ;;3.3]  If non zero, use boost output to boost Kadena Liquid Index (ico3)
            )
        )
    )
    (defun XI_PumpLiquidIndex:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string amount:decimal)
        (require-capability (SWPU|C>PUMP_LQ-IDX))
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPI:module{SwapperIssue} SWPI)
                (swp-sc:string (ref-DALOS::GOV|SWP|SC_NAME))
                (dlk:string (ref-DALOS::UR_LiquidKadenaID))
            )
            (if (= id dlk)
            ;;1] If id is dlk, burn it directly
                (ref-DPTF::C_Burn dlk swp-sc amount)
            ;;2] If id is not dlk, compute via Hopper the equivalent dlk amount that must be burned.
            ;;3] Then update all Token Supplies of the hopped pools that served to compute the DLK amount
            ;;      as if the id was smart-swapped with no fees to dlk.
                (let
                    (
                        (h-obj:object{SwapperIssue.Hopper} (ref-SWPI::URC_Hopper id dlk amount))
                        (path-to-dlk:[string] (at "nodes" h-obj))
                        (edges:[string] (at "edges" h-obj))
                        (ovs:[decimal] (at "output-values" h-obj))
                        (final-boost-output:decimal (at 0 (take -1 ovs)))
                        (ico:object{OuronetDalosV3.OutputCumulatorV2}
                            (ref-DPTF::C_Burn dlk swp-sc final-boost-output)
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
    (defun XI_OuroPriceUpdater (swpair:string kda-pid:decimal)
        @doc "Updates OURO Price if it deviates more than 0.5% from the existing stored OURO Price"
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (iz-auto:bool (ref-DALOS::UR_OuroAutoPriceUpdate))
            )
            (if iz-auto
                (let
                    (
                        (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                        (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                        (ref-SWPI:module{SwapperIssue} SWPI)
                        (dlk:string (ref-DALOS::UR_LiquidKadenaID))
                        (ouro:string (ref-DALOS::UR_OuroborosID))
                        (dwk:string (ref-DALOS::UR_WrappedKadenaID))
                        (primal-pool-id:string (ref-U|SWP::UC_PoolID [dlk ouro dwk] [0.2 0.5 0.3] -1.0))
                        (op:integer (ref-DPTF::UR_Decimals ouro))
                    )
                    (if (= swpair primal-pool-id)
                        (let
                            (
                                (stored-ouro-price:decimal (ref-DALOS::UR_OuroborosPrice))
                                (current-ouro-price:decimal (ref-SWPI::URC_TokenDollarPrice ouro kda-pid))
                                (dev:decimal 0.005)
                                (min:decimal (floor (* stored-ouro-price (- 1.0 dev)) op))
                                (max:decimal (floor (* stored-ouro-price (+ 1.0 dev)) op))
                                (iz-update:bool
                                    (if (or (< current-ouro-price min) (> current-ouro-price max))
                                        true false
                                    )
                                )

                            )
                            (if iz-update
                                (ref-DALOS::XB_UpdateOuroPrice)
                                true
                            )
                        )
                        true
                    )
                )
                true
            )
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)