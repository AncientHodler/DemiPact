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
    (defun SPWS|UDC_SlippageObject:object{Slippage} (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage-value:decimal))
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
    (defun SWPS|UC_SlippageMinMax:[decimal] (input:object{Slippage}))
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
    (defun SPWS|UDC_SlippageObject:object{Slippage} (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage-value:decimal))
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
(module SWPU GOV
    ;;
    (implements OuronetPolicy)
    (implements BrandingUsageV3)
    (implements SwapperUsageV2)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_SWPU           (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|SWPU_ADMIN)))
    (defcap GOV|SWPU_ADMIN ()       (enforce-guard GOV|MD_SWPU))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV2} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV2} DALOS)) (ref-DALOS::P|Info)))
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
    (defun CT_EmptyCumulator        ()(let ((ref-DALOS:module{OuronetDalosV2} DALOS)) (ref-DALOS::DALOS|EmptyOutputCumulatorV2)))
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
    (defcap SWPU|C>UPDATE-BRD (swpair:string)
        @event
        (let
            (
                (ref-SWP:module{SwapperV2} SWP)
            )
            (ref-SWP::CAP_Owner swpair)
            (compose-capability (P|SWPU|CALLER))
        )
    )
    (defcap SWPU|C>UPGRADE-BRD (swpair:string)
        @event
        (let
            (
                (ref-SWP:module{SwapperV2} SWP)
            )
            (ref-SWP::CAP_Owner swpair)
            (compose-capability (P|SWPU|CALLER))
        )
    )
    (defcap SWPI|C>ISSUE (account:string pool-tokens:[object{SwapperV2.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
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
                    (ref-SWP:module{SwapperV2} SWP)
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                (ref-SWP:module{SwapperV2} SWP)
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                (ref-SWP:module{SwapperV2} SWP)
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                (ref-SWP:module{SwapperV2} SWP)
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
    (defcap SWPL|C>ADD_FROZEN-LQ (swpair:string frozen-dptf:string)
        @event
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                (ref-SWP:module{SwapperV2} SWP)
                (iz-frozen:bool (ref-SWP::UR_IzFrozenLP swpair))
                (dptf:string (ref-DPTF::UR_Frozen frozen-dptf))
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
            )
            (enforce iz-frozen (format "Frozen LP Functionality is not enabled on Swpair {}" [swpair]))
            (enforce (contains dptf pool-tokens) (format "Frozen DPTF {} incompatible with Swpair {}" [frozen-dptf swpair]))
            (compose-capability (P|DT))
        )
    )
    (defcap SWPL|C>ADD_SLEEPING-LQ (account:string swpair:string sleeping-dpmf:string nonce:integer)
        @event
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                (ref-SWP:module{SwapperV2} SWP)
                (iz-sleeping:bool (ref-SWP::UR_IzSleepingLP swpair))
                (dptf:string (ref-DPMF::UR_Sleeping sleeping-dpmf))
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
            )
            (ref-DPMF::UEV_NoncesToAccount sleeping-dpmf account [nonce])
            (let
                (
                    (nonce-md:[object] (ref-DPMF::UR_AccountNonceMetaData sleeping-dpmf nonce account))
                    (release-date:time (at "release-date" (at 0 nonce-md)))
                    (present-time:time (at "block-time" (chain-data)))
                    (dt:decimal (diff-time release-date present-time))
                )
                (enforce (> dt 0.0) (format "Sleeping must exist for Nonce {} for operation" [nonce]))
                (enforce iz-sleeping (format "Sleeping LP Functionality is not enabled on Swpair {}" [swpair]))
                (enforce (contains dptf pool-tokens) (format "Sleeping DPMF {} incompatible with Swpair {}" [sleeping-dpmf swpair]))
                (compose-capability (P|DT))
            )
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun SWPS|UC_SlippageMinMax:[decimal] (input:object{SwapperUsageV2.Slippage})
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
    (defun URC_EntityPosToID:string (swpair:string entity-pos:integer)
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-SWP:module{SwapperV2} SWP)
            )
            (ref-U|INT::UEV_PositionalVariable entity-pos 3 "Invalid entity position")
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
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
    (defun URC_TokenDollarPrice (id:string kda-pid:decimal)
        @doc "Retrieves Token Price in Dollars, via DIA Oracle that outputs KDA Price"
        ;;<kda-pid> or <kda-price-in-dollars> can be retrieved prior to the function call with:
        ;;(at "value" (n_bfb76eab37bf8c84359d6552a1d96a309e030b71.dia-oracle.get-value "KDA/USD"))
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                (id-in-kda:decimal (URC_SingleWorthDWK id))
                (id-precision:integer (ref-DPTF::UR_Decimals id))
            )
            (floor (* id-in-kda kda-pid) id-precision)
        )
    )
    (defun URC_SingleWorthDWK (id:string)
        (URC_WorthDWK id 1.0)
    )
    (defun URC_WorthDWK (id:string amount:decimal)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
                (dwk:string (ref-DALOS::UR_WrappedKadenaID))
                (dlk:string (ref-DALOS::UR_LiquidKadenaID))
            )
            (if (= id dwk)
                amount
                (if (= id dlk)
                    (let
                        (
                            (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                            (ref-ATS:module{AutostakeV2} ATS)
                            (ats-pairs-with-dlk-id:[string] (ref-DPTF::UR_RewardBearingToken dlk))
                            (kdaliquindex:string (at 0 ats-pairs-with-dlk-id))
                            (index-value:decimal (ref-ATS::URC_Index kdaliquindex))
                            (dlk-prec:integer (ref-DPTF::UR_Decimals dlk))
                        )
                        (floor (* amount index-value) dlk-prec)
                    )
                    (let
                        (
                            (h-obj:object{SwapperUsageV2.Hopper} (SWPSC|URC_Hopper id dwk amount))
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                (ref-SWP:module{SwapperV2} SWP)
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
    ;;
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
                    (ref-SWP:module{SwapperV2} SWP)
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                (ref-SWP:module{SwapperV2} SWP)
                (token-lp:string (ref-SWP::UR_TokenLP swpair))
            )
            (ref-SWP::UEV_id swpair)
            (ref-DPTF::UR_Supply token-lp)
        )
    )
    (defun SWPLC|URC_BalancedLiquidity:[decimal] (swpair:string input-id:string input-amount:decimal)
        @doc "Outputs the amount of tokens, for given <input-id> and <input-amount> that are needed to add Balanced Liquidity"
        (let
            (
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                (ref-SWP:module{SwapperV2} SWP)
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
                (ref-SWP:module{SwapperV2} SWP)
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                (ref-SWP:module{SwapperV2} SWP)
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
                                    (ref-U|LST::UC_AppL acc (floor (fold (*) 1.0 [(/ (at idx input-amounts) (at idx pool-token-supplies)) (at idx percent-lst) lp-supply]) lp-prec))
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                (ref-SWP:module{SwapperV2} SWP)
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
                (ref-DALOS:module{OuronetDalosV2} DALOS)
                (ref-SWP:module{SwapperV2} SWP)
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
    ;;
    (defun SWPSC|URC_Swap:decimal (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (let
            (
                (ref-SWP:module{SwapperV2} SWP)
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                (ref-SWP:module{SwapperV2} SWP)
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                (ref-SWP:module{SwapperV2} SWP)
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
                (ref-SWP:module{SwapperV2} SWP)
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
    (defun SWPSC|URC_Hopper:object{SwapperUsageV2.Hopper}
        (hopper-input-id:string hopper-output-id:string hopper-input-amount:decimal)
        @doc "Creates a Hopper Object, by computing \
        \ 1] The trace between <hopper-input-id> and <hopper-output-id>, the <nodes> \
        \ 2] The hops between them, the <edges> as the cheapest available edge from all available \
        \ 3] The best <output> values using said best <edges>, given the <hopper-input-amount>"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-SWPT:module{SwapTracer} SWPT)
                (ref-SWP:module{SwapperV2} SWP)
                (swpairs:[string] (ref-SWP::URC_Swpairs))
                (principal-lst:[string] (ref-SWP::UR_Principals))
                (nodes:[string] (ref-SWPT::URC_ComputeGraphPath hopper-input-id hopper-output-id swpairs principal-lst))
            )
            (if (!= nodes [BAR])
                (let
                    (
                        (fl:[object{SwapperUsageV2.Hopper}]
                            (fold
                                (lambda
                                    (acc:[object{SwapperUsageV2.Hopper}] idx:integer)
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
    ;;{F2}  [UEV]
    (defun SWPI|UEV_Issue
        (account:string pool-tokens:[object{SwapperV2.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-SWP:module{SwapperV2} SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
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
                        (ref-DALOS:module{OuronetDalosV2} DALOS)
                        (dlk:string (ref-DALOS::UR_LiquidKadenaID))
                        (h-obj:object{SwapperUsageV2.Hopper} (SWPSC|URC_Hopper first-pool-token dlk 1.0))
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
                                (/ first-worth (at 0 weights))
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
    ;;{F3}  [UDC]
    (defun SPWS|UDC_SlippageObject:object{SwapperUsageV2.Slippage}
        (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage-value:decimal)
        @doc "Makes a Slippage Object from <input amounts>"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
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
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;LP DPTF branding
    (defun C_UpdatePendingBrandingLPs:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string swpair:string entity-pos:integer logo:string description:string website:string social:[object{Branding.SocialSchema}])
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
                (ref-BRD:module{Branding} BRD)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                (entity-id:string (URC_EntityPosToID swpair entity-pos))
                (entity-owner:string
                    (if (= entity-pos 3)
                        (ref-DPMF::UR_Konto entity-id)
                        (ref-DPTF::UR_Konto entity-id)
                    )
                )
            )
            (with-capability (SWPU|C>UPDATE-BRD swpair)
                (ref-BRD::XE_UpdatePendingBranding entity-id logo description website social)
                (ref-DALOS::UDC_BrandingCumulatorV2 entity-owner 2.0)
            )
        )
    )
    (defun C_UpgradeBrandingLPs (patron:string swpair:string entity-pos:integer months:integer)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
                (ref-BRD:module{Branding} BRD)
                (ref-SWP:module{SwapperV2} SWP)
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
    ;;
    (defun SWPI|C_Issue:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string pool-tokens:[object{SwapperV2.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        @doc "Issues a new SWPair (Liquidty Pool)"
        (UEV_IMC)
        (with-capability (SWPI|C>ISSUE account pool-tokens fee-lp weights amp p)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-BRD:module{Branding} BRD)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV2} TFT)
                    (ref-SWPT:module{SwapTracer} SWPT)
                    (ref-SWP:module{SwapperV2} SWP)
                    (swp-sc:string (ref-DALOS::GOV|SWP|SC_NAME))
                    (kda-dptf-cost:decimal (ref-DALOS::UR_UsagePrice "dptf"))
                    (kda-swp-cost:decimal (ref-DALOS::UR_UsagePrice "swp"))
                    (kda-costs:decimal (+ kda-dptf-cost kda-swp-cost))
                    (gas-swp-cost:decimal (ref-DALOS::UR_UsagePrice "ignis|swp-issue"))
                    (pool-token-ids:[string] (ref-SWP::UC_ExtractTokens pool-tokens))
                    (pool-token-amounts:[decimal] (ref-SWP::UC_ExtractTokenSupplies pool-tokens))
                    (lp-name-ticker:[string] (ref-SWP::URC_LpComposer pool-tokens weights amp))
                    (ico1:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-DPTF::XE_IssueLP patron (at 0 lp-name-ticker) (at 1 lp-name-ticker))
                    )
                    (token-lp:string (at 0 (at "output" ico1)))
                    (swpair:string (ref-SWP::XE_Issue account pool-tokens token-lp fee-lp weights amp p))
                )
                (ref-BRD::XE_Issue swpair)
                (let
                    (
                        (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                        (ico2:object{OuronetDalosV2.OutputCumulatorV2}
                            (ref-TFT::XE_FeelesMultiTransfer patron pool-token-ids account swp-sc pool-token-amounts true)
                        )
                        (ico3:object{OuronetDalosV2.OutputCumulatorV2}
                            (ref-DPTF::C_Mint patron token-lp swp-sc 10000000.0 true)
                        )
                        (ico4:object{OuronetDalosV2.OutputCumulatorV2}
                            (ref-TFT::XB_FeelesTransfer patron token-lp swp-sc account 10000000.0 true)
                        )
                        (ico5:object{OuronetDalosV2.OutputCumulatorV2}
                            (ref-DALOS::UDC_ConstructOutputCumulatorV2 gas-swp-cost swp-sc trigger [])
                        )
                    )
                    (ref-SWPT::XE_MultiPathTracer swpair (ref-SWP::UR_Principals))
                    (ref-DALOS::KDA|C_Collect patron kda-costs)
                    (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 [ico1 ico2 ico3 ico4 ico5] [swpair token-lp])
                )
            )
        )
    )
    (defun PS|C_IssueStableMultiStep
        (patron:string account:string pool-tokens:[object{SwapperV2.PoolTokens}] fee-lp:decimal amp:decimal p:bool)
        (UEV_IMC)
        (SWPI|C_IssueMultiStep
            patron account pool-tokens fee-lp
            (make-list (length pool-tokens) 1.0)
            amp p
        )
    )
    (defun PS|C_IssueStandardMultiStep
        (patron:string account:string pool-tokens:[object{SwapperV2.PoolTokens}] fee-lp:decimal p:bool)
        (UEV_IMC)
        (SWPI|C_IssueMultiStep
            patron account pool-tokens fee-lp
            (make-list (length pool-tokens) 1.0)
            -1.0 p
        )
    )
    (defun PS|C_IssueWeightedMultiStep
        (patron:string account:string pool-tokens:[object{SwapperV2.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool)
        (UEV_IMC)
        (SWPI|C_IssueMultiStep
            patron account pool-tokens fee-lp
            weights
            -1.0 p
        )
    )
    ;;
    (defun C_ToggleAddLiquidity:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string swpair:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-SWP:module{SwapperV2} SWP)
            )
            (with-capability (P|SWPU|CALLER)
                (ref-SWP::C_ToggleAddOrSwap patron swpair toggle true)
            )
        )
    )
    (defun C_ToggleSwapCapability:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string swpair:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-SWP:module{SwapperV2} SWP)
            )
            (with-capability (SPW|C>TOGGLE-SWAP swpair toggle)
                (ref-SWP::C_ToggleAddOrSwap patron swpair toggle false)
            )
        )
    )
    ;;
    (defun SWPL|C_AddBalancedLiquidity:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string swpair:string input-id:string input-amount:decimal)
        (UEV_IMC)
        (SWPL|C_AddLiquidity patron account swpair (SWPLC|URC_BalancedLiquidity swpair input-id input-amount))
    )
    (defun SWPL|C_AddSleepingLiquidity:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string swpair:string sleeping-dpmf:string nonce:integer)
        (UEV_IMC)
        (with-capability (SWPL|C>ADD_SLEEPING-LQ account swpair sleeping-dpmf nonce)
            (let
                (
                    (ref-U|SWP:module{UtilitySwp} U|SWP)
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                    (ref-VST:module{VestingV2} VST)
                    (ref-SWP:module{SwapperV2} SWP)
                    (lp:string (ref-SWP::UR_TokenLP swpair))
                    (dptf:string (ref-DPMF::UR_Sleeping sleeping-dpmf))
                    (ptp:integer (ref-SWP::UR_PoolTokenPosition swpair dptf))
                    (vst-sc:string (ref-DALOS::GOV|VST|SC_NAME))
                    (batch-amount:decimal (ref-DPMF::UR_AccountNonceBalance sleeping-dpmf nonce account))
                    (lq-lst:[decimal] (ref-U|SWP::UC_MakeLiquidityList swpair ptp batch-amount))
                    (nonce-md:[object] (ref-DPMF::UR_AccountNonceMetaData sleeping-dpmf nonce account))
                    (release-date:time (at "release-date" (at 0 nonce-md)))
                    (present-time:time (at "block-time" (chain-data)))
                    (dt:integer (floor (diff-time release-date present-time)))
                    (ico1:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-DPMF::C_SingleBatchTransfer patron sleeping-dpmf nonce account vst-sc true)
                    )
                    (ico2:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-DPMF::C_Burn patron sleeping-dpmf nonce vst-sc batch-amount)
                    )
                    (ico3:object{OuronetDalosV2.OutputCumulatorV2}
                        (SWPL|C_AddLiquidity patron vst-sc swpair lq-lst)
                    )
                    (lp-amount:decimal (at 0 (at "output" ico3)))
                    (ico4:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-VST::C_Sleep patron vst-sc account lp lp-amount dt)
                    )
                )
                (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 [ico1 ico2 ico3 ico4] [lp-amount])
                ;;1]<account> sends <sleeping-dpmf> to <VST|SC_NAME>
                ;;via ico1
                ;;2]<VST|SC_NAME> burns it and releasing the base dptf, which can then be directly used to add liqudity
                ;;via ico2
                ;;3]<VST|SC_NAME> adds liquidity with the <dptf>, generating native LP
                ;;via ico3
                ;;4]<VST|SC_NAME> sleeps resulted LP to target <account>
                ;;via ico4
            )
        )
    )
    (defun SWPL|C_AddFrozenLiquidity:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal)
        (UEV_IMC)
        (with-capability (SWPL|C>ADD_FROZEN-LQ swpair frozen-dptf)
            (let
                (
                    (ref-U|SWP:module{UtilitySwp} U|SWP)
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV2} TFT)
                    (ref-VST:module{VestingV2} VST)
                    (ref-SWP:module{SwapperV2} SWP)
                    (lp:string (ref-SWP::UR_TokenLP swpair))
                    (dptf:string (ref-DPTF::UR_Frozen frozen-dptf))
                    (ptp:integer (ref-SWP::UR_PoolTokenPosition swpair dptf))
                    (vst-sc:string (ref-DALOS::GOV|VST|SC_NAME))
                    (lq-lst:[decimal] (ref-U|SWP::UC_MakeLiquidityList swpair ptp input-amount))
                    (ico1:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-TFT::XB_FeelesTransfer patron frozen-dptf account vst-sc input-amount true)
                    )
                    (ico2:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-DPTF::C_Burn patron frozen-dptf vst-sc input-amount)
                    )
                    (ico3:object{OuronetDalosV2.OutputCumulatorV2}
                        (SWPL|C_AddLiquidity patron vst-sc swpair lq-lst)
                    )
                    (lp-amount:decimal (at 0 (at "output" ico3)))
                    (ico4:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-VST::C_Freeze patron vst-sc account lp lp-amount)
                    )
                )
                (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 [ico1 ico2 ico3 ico4] [lp-amount])
                ;;1]<account> sends <frozen-dptf> to <VST|SC_NAME>
                ;;via ico1
                ;;2]<VST|SC_NAME> burns it and releasing the base dptf, which can then be directly used to add liqudity
                ;;via ico2
                ;;3]<VST|SC_NAME> adds liquidity with the <dptf>, generating native LP
                ;;via ico3
                ;;4]<VST|SC_NAME> freezes resulted LP to target <account>
                ;;via ico4
            )
        )
    )
    (defun SWPL|C_AddLiquidity:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string swpair:string input-amounts:[decimal])
        (UEV_IMC)
        (with-capability (SWPL|C>ADD_LQ swpair input-amounts)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV2} TFT)
                    (ref-SWP:module{SwapperV2} SWP)
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
                    ;;
                    (ico0:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-DALOS::UDC_ConstructOutputCumulatorV2 price swp-sc trigger [])
                    )
                    (folded-obj:[object{OuronetDalosV2.OutputCumulatorV2}]
                        (fold
                            (lambda
                                (acc:[object{OuronetDalosV2.OutputCumulatorV2}] idx:integer)
                                (ref-U|LST::UC_AppL
                                    acc
                                    (if (> (at idx input-amounts) 0.0)
                                        (ref-TFT::XB_FeelesTransfer patron (at idx pool-token-ids) account swp-sc (at idx input-amounts) true)
                                        EOC
                                    )
                                )
                            )
                            []
                            (enumerate 0 (- (length input-amounts) 1))
                        )
                    )
                    (ico1:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 folded-obj [])
                    )
                    (ico2:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-DPTF::C_Mint patron lp-id swp-sc lp-amount false)
                    )
                    (ico3:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-TFT::XB_FeelesTransfer patron lp-id swp-sc account lp-amount true)
                    )
                )
                (if (= read-lp-supply 0.0)
                    (ref-SWP::XB_ModifyWeights swpair gw)
                    true
                )
                (ref-SWP::XE_UpdateSupplies swpair pt-new-amounts)
                (XI_AutonomousSwapManagement swpair)
                (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 [ico0 ico1 ico2 ico3] [lp-amount])
            )
        )
    )
    (defun SWPL|C_RemoveLiquidity:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string swpair:string lp-amount:decimal)
        (UEV_IMC)
        (with-capability (SWPL|C>RM_LQ swpair lp-amount)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV2} TFT)
                    (ref-SWP:module{SwapperV2} SWP)
                    (swp-sc:string (ref-DALOS::GOV|SWP|SC_NAME))
                    (pool-token-ids:[string] (ref-SWP::UR_PoolTokens swpair))
                    (lp-id:string (ref-SWP::UR_TokenLP swpair))
                    (pt-output-amounts:[decimal] (SWPLC|URC_LpBreakAmounts swpair lp-amount))
                    (pt-current-amounts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                    (pt-new-amounts:[decimal] (zip (-) pt-current-amounts pt-output-amounts))
                    (token-issue:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                    (price:decimal (* 2.0 token-issue))
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                    (ico0:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-DALOS::UDC_ConstructOutputCumulatorV2 price swp-sc trigger [])
                    )
                    (ico1:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-TFT::XB_FeelesTransfer patron lp-id account swp-sc lp-amount true)
                    )
                    (ico2:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-DPTF::C_Burn patron lp-id swp-sc lp-amount)
                    )
                    (ico3:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-TFT::XE_FeelesMultiTransfer patron pool-token-ids swp-sc account pt-output-amounts true)
                    )
                )
                (ref-SWP::XE_UpdateSupplies swpair pt-new-amounts)
                (XI_AutonomousSwapManagement swpair)
                (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 [ico0 ico1 ico2 ico3] pt-output-amounts)
            )
        )
    )
    ;;
    (defun SWPS|OPU|C_SimpleSwap:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string slippage:object{SwapperUsageV2.Slippage} kda-pid:decimal)
        (UEV_IMC)
        (with-capability (SECURE)
            (SWPS|C_MultiSwap patron account swpair [input-id] [input-amount] output-id slippage kda-pid)
        )
    )
    (defun SWPS|OPU|C_SimpleSwapNoSlippage:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string kda-pid:decimal)
        (UEV_IMC)
        (with-capability (SECURE)
            (SWPS|C_MultiSwapNoSlippage patron account swpair [input-id] [input-amount] output-id kda-pid)
        )
    )
    (defun SWPS|OPU|C_MultiSwap:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:object{SwapperUsageV2.Slippage} kda-pid:decimal)
        (UEV_IMC)
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
                    (SWPS|OPU|XI_MultiSwap patron account swpair input-ids input-amounts output-id kda-pid)
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
    (defun SWPS|OPU|C_MultiSwapNoSlippage:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string kda-pid:decimal)
        (UEV_IMC)
        (with-capability (SECURE)
            (SWPS|OPU|XI_MultiSwap patron account swpair input-ids input-amounts output-id kda-pid)
        )
    )
    ;;
    (defun SWPS|C_SimpleSwap:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string slippage:object{SwapperUsageV2.Slippage})
        (UEV_IMC)
        (with-capability (SECURE)
            (SWPS|C_MultiSwap patron account swpair [input-id] [input-amount] output-id slippage)
        )
    )
    (defun SWPS|C_SimpleSwapNoSlippage:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string)
        (UEV_IMC)
        (with-capability (SECURE)
            (SWPS|C_MultiSwapNoSlippage patron account swpair [input-id] [input-amount] output-id)
        )
    )
    (defun SWPS|C_MultiSwap:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:object{SwapperUsageV2.Slippage})
        (UEV_IMC)
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
                    (SWPS|XI_MultiSwap patron account swpair input-ids input-amounts output-id)
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
    (defun SWPS|C_MultiSwapNoSlippage:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (UEV_IMC)
        (with-capability (SECURE)
            (SWPS|XI_MultiSwap patron account swpair input-ids input-amounts output-id)
        )
    )
    ;;{F7}
    (defun SWPS|OPU|XI_MultiSwap:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string kda-pid:decimal)
        (let
            (
                (output:object{OuronetDalosV2.OutputCumulatorV2}
                    (SWPS|XI_MultiSwap patron account swpair input-ids input-amounts output-id)
                )
            )
            ;;4] Updates OURO Price if <ouro-auto-price-via-swaps> is true, the swap is executed in the primal swpair,
            ;;      and if price varies by more than 0.5% of the stored Ouro price.
            (XI_OuroPriceUpdater swpair kda-pid)
            output
        )
    )
    (defun SWPS|XI_MultiSwap:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (require-capability (SECURE))
        (with-capability (SWPS|C>SWAP swpair input-ids input-amounts output-id)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                    (ref-U|SWP:module{UtilitySwp} U|SWP)
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV2} TFT)
                    (ref-SWP:module{SwapperV2} SWP)

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
                        (ico1:object{OuronetDalosV2.OutputCumulatorV2}
                            (ref-TFT::XE_FeelesMultiTransfer patron input-ids account swp-sc input-amounts true)
                        )
                        (ico2:object{OuronetDalosV2.OutputCumulatorV2}
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
                        (ico3:object{OuronetDalosV2.OutputCumulatorV2}
                            (if (!= boost-fee 0.0)
                                (XI_PumpLiquidIndex patron output-id boost-output)
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
    (defun XI_PumpLiquidIndex:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string id:string amount:decimal)
        (require-capability (SWPS|C>PUMP_LQ-IDX))
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                (ref-SWP:module{SwapperV2} SWP)
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
                        (h-obj:object{SwapperUsageV2.Hopper} (SWPSC|URC_Hopper id dlk amount))
                        (path-to-dlk:[string] (at "nodes" h-obj))
                        (edges:[string] (at "edges" h-obj))
                        (ovs:[decimal] (at "output-values" h-obj))
                        (final-boost-output:decimal (at 0 (take -1 ovs)))
                        (ico:object{OuronetDalosV2.OutputCumulatorV2}
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
                (ref-SWP:module{SwapperV2} SWP)
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
    (defun XI_OuroPriceUpdater (swpair:string kda-pid:decimal)
        @doc "Updates OURO Price if it deviates more than 0.5% from the existing stored OURO Price"
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
                (iz-auto:bool (ref-DALOS::UR_OuroAutoPriceUpdate))
            )
            (if iz-auto
                (let
                    (
                        (ref-U|SWP:module{UtilitySwp} U|SWP)
                        (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
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
                                (current-ouro-price:decimal (URC_TokenDollarPrice ouro kda-pid))
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
    ;;{F8}  [P]
    (defpact SWPI|C_IssueMultiStep
        (patron:string account:string pool-tokens:[object{SwapperV2.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
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
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV2} TFT)
                    (ref-SWP:module{SwapperV2} SWP)
                    (pool-token-ids:[string] (ref-SWP::UC_ExtractTokens pool-tokens))
                    (pool-token-amounts:[decimal] (ref-SWP::UC_ExtractTokenSupplies pool-tokens))
                    (swp-sc:string (ref-DALOS::GOV|SWP|SC_NAME))
                    ;;
                    (sum-ignis:decimal 
                        (fold (+) 0.0 
                            [
                                (ref-DALOS::UR_UsagePrice "ignis|swp-issue")
                                (ref-DALOS::UR_UsagePrice "ignis|token-issue")
                                (ref-DALOS::UR_UsagePrice "ignis|biggest")
                                (ref-DALOS::UR_UsagePrice "ignis|smallest")
                            ]
                        )
                    )
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                    ;;
                    (ico0:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-DALOS::UDC_ConstructOutputCumulatorV2 sum-ignis swp-sc trigger [])
                    )
                    (ico1:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-TFT::UDC_MultiTransferICO pool-token-ids pool-token-amounts account swp-sc)
                    )
                    ;;
                    (kda-costs:decimal 
                        (+ 
                            (ref-DALOS::UR_UsagePrice "dptf")
                            (ref-DALOS::UR_UsagePrice "swp")
                        )
                    )
                )
                ;;Collect IGNIS for Issuance
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 [ico0 ico1] [])
                )
                ;;Collect KDA for Issuance
                (ref-DALOS::KDA|C_Collect patron kda-costs)
                (let
                    (
                        (ref-ORBR:module{OuroborosV2} OUROBOROS)
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
                        (ref-DALOS:module{OuronetDalosV2} DALOS)
                        (ref-BRD:module{Branding} BRD)
                        (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                        (ref-TFT:module{TrueFungibleTransferV2} TFT)
                        (ref-SWPT:module{SwapTracer} SWPT)
                        (ref-SWP:module{SwapperV2} SWP)
                        (principals:[string] (ref-SWP::UR_Principals))
                        (swp-sc:string (ref-DALOS::GOV|SWP|SC_NAME))
                        (pool-token-ids:[string] (ref-SWP::UC_ExtractTokens pool-tokens))
                        (pool-token-amounts:[decimal] (ref-SWP::UC_ExtractTokenSupplies pool-tokens))
                        (lp-name-ticker:[string] (ref-SWP::URC_LpComposer pool-tokens weights amp))
                        (lp-name:string (at 0 lp-name-ticker))
                        (lp-ticker:string (at 1 lp-name-ticker))
                        (ico:object{OuronetDalosV2.OutputCumulatorV2}
                            (ref-DPTF::XE_IssueLP patron lp-name lp-ticker)
                        )
                        (token-lp:string (at 0 (at "output" ico)))
                        (swpair:string (ref-SWP::XE_Issue account pool-tokens token-lp fee-lp weights amp p))
                    )
                    (ref-BRD::XE_Issue swpair)
                    (ref-TFT::XE_FeelesMultiTransfer patron pool-token-ids account swp-sc pool-token-amounts true)
                    (ref-DPTF::C_Mint patron token-lp swp-sc 10000000.0 true)
                    (ref-TFT::XB_FeelesTransfer patron token-lp swp-sc account 10000000.0 true)
                    (ref-SWPT::XE_MultiPathTracer swpair principals)
                    (format "Swpair with ID {} and LP Token {} ID created succesfully" [swpair token-lp])
                )
            )
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)