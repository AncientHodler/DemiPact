(interface SwapTracer
    @doc "Exposes Tracer Functions, needed to compute Paths between Tokens existing on Liquidity Pools"
    ;;
    (defschema Edges
        principal:string
        swpairs:[string]
    )
    ;;
    (defun UC_PSwpairsFTO:[string] (traces:[object{Edges}] id:string principal:string principals-lst:[string]))
    (defun UC_PrincipalsFromTraces:[string] (traces:[object{Edges}]))
    ;;
    (defun UR_PathTrace:[object{Edges}] (id:string))
    ;;
    (defun URC_PathTracer:[object{Edges}] (old-path-tracer:[object{Edges}] id:string swpair:string principals-lst:[string]))
    (defun URC_ContainsPrincipals:bool (swpair:string principals-lst:[string]))
    (defun URC_ComputeGraphPath:[string] (input:string output:string swpairs:[string] principal-lst:[string]))
    (defun URC_AllGraphPaths:[[string]] (input:string output:string swpairs:[string] principal-lst:[string]))
    (defun URC_MakeGraph:[object{BreadthFirstSearch.GraphNode}] (input:string output:string swpairs:[string] principal-lst:[string]))
    (defun URC_TokenNeighbours:[string] (token-id:string principal-lst:[string]))
    (defun URC_TokenSwpairs:[string] (token-id:string principal-lst:[string]))
    (defun URC_PrincipalSwpairs:[string] (id:string principal:string principal-lst:[string]))
    (defun URC_Edges:[string] (t1:string t2:string principal-lst:[string])) ;;1
    ;;
    (defun UEV_IdAsPrincipal (id:string for-trace:bool principals-lst:[string]))
    ;;
    (defun XE_MultiPathTracer (swpair:string principals-lst:[string]))
)
;;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
(interface SwapperV4
    @doc "Exposes Swapper Related Functions, except those related to adding and swapping liquidity \
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
        \ Removes the all 4 Branding Functions from this Interface, since they are in their own interface. \
        \ The Branding for LPs moved from the SWP to SWPU Module \
        \ <URC_EntityPosToID> moved to SWPU Module \
        \ \
        \ V3 Removes <patron> input variable where it is not needed \
        \ V4 Adds Asymetric toggle, and global variable for the LKDA-OURO-WKDA Pool"
    ;;
    (defschema PoolTokens
        token-id:string
        token-supply:decimal
    )
    (defschema FeeSplit
        target:string
        value:integer
    )
    (defun SWP|Info ())
    ;;
    ;;
    (defun SWP|SetGovernor (patron:string))
    ;;
    ;;
    (defun UC_ExtractTokens:[string] (input:[object{PoolTokens}]))
    (defun UC_ExtractTokenSupplies:[decimal] (input:[object{PoolTokens}]))
    (defun UC_CustomSpecialFeeTargets:[string] (io:[object{FeeSplit}]))
    (defun UC_CustomSpecialFeeTargetsProportions:[decimal] (io:[object{FeeSplit}]))
    ;;
    (defun UR_Asymetric:bool ())
    (defun UR_Principals:[string] ())
    (defun UR_PrimordialPool:string ())
    (defun UR_LiquidBoost:bool ())
    (defun UR_SpawnLimit:decimal ())
    (defun UR_InactiveLimit:decimal ())
        ;;
    (defun UR_OwnerKonto:string (swpair:string))
    (defun UR_CanChangeOwner:bool (swpair:string))
    (defun UR_CanAdd:bool (swpair:string))
    (defun UR_CanSwap:bool (swpair:string))
    (defun UR_GenesisWeigths:[decimal] (swpair:string))
    (defun UR_Weigths:[decimal] (swpair:string))
    (defun UR_GenesisRatio:[object{PoolTokens}] (swpair:string))
    (defun UR_PoolTokenObject:[object{PoolTokens}] (swpair:string))
    (defun UR_TokenLP:string (swpair:string))
    (defun UR_FeeLP:decimal (swpair:string))
    (defun UR_FeeSP:decimal (swpair:string))
    (defun UR_FeeSPT:[object{FeeSplit}] (swpair:string))
    (defun UR_FeeLock:bool (swpair:string))
    (defun UR_FeeUnlocks:integer (swpair:string))
    (defun UR_Amplifier:decimal (swpair:string))
    (defun UR_Primality:bool (swpair:string))
    (defun UR_IzFrozenLP:bool (swpair:string))
    (defun UR_IzSleepingLP:bool (swpair:string))
    (defun UR_Pools:[string] (pool-category:string))
        ;;
    (defun UR_PoolTokens:[string] (swpair:string))
    (defun UR_PoolTokenSupplies:[decimal] (swpair:string))
    (defun UR_PoolGenesisSupplies:[decimal] (swpair:string))
    (defun UR_PoolTokenPosition:integer (swpair:string id:string))
    (defun UR_PoolTokenSupply:decimal (swpair:string id:string))
    (defun UR_PoolTokenPrecisions:[integer] (swpair:string))
    (defun UR_SpecialFeeTargets:[string] (swpair:string))
    (defun UR_SpecialFeeTargetsProportions:[decimal] (swpair:string))
    ;;
    (defun URC_LpCapacity:decimal (swpair:string))
    (defun URC_CheckID:bool (swpair:string))
    (defun URC_PoolTotalFee:decimal (swpair:string))
    (defun URC_LiquidityFee:decimal (swpair:string))
    (defun URC_Swpairs:[string] ())
    (defun URC_LpComposer:[string] (pool-tokens:[object{PoolTokens}] weights:[decimal] amp:decimal))
    ;;
    (defun UEV_FeeSplit (input:object{FeeSplit}))
    (defun UEV_id (swpair:string))
    (defun UEV_CanChangeOwnerON (swpair:string))
    (defun UEV_FeeLockState (swpair:string state:bool))
    (defun UEV_PoolFee (fee:decimal))
    (defun UEV_New (t-ids:[string] w:[decimal] amp:decimal))
    (defun UEV_CheckTwo (token-ids:[string] w:[decimal] amp:decimal))
    (defun UEV_CheckAgainstMass:bool (token-ids:[string] present-pools:[string]))
    (defun UEV_CheckAgainst:bool (token-ids:[string] pool-tokens:[string]))
    (defun UEV_FrozenLP (swpair:string state:bool))
    (defun UEV_SleepingLP (swpair:string state:bool))
    ;;
    ;;
    (defun A_UpdatePrincipal (principal:string add-or-remove:bool))
    (defun A_UpdateLimit (limit:decimal spawn:bool))
    (defun A_UpdateLiquidBoost (new-boost-variable:bool))
    (defun A_DefinePrimordialPool (primordial-pool:string))
    (defun A_ToggleAsymetricLiquidityAddition (toggle:bool))
    ;;
    (defun C_ChangeOwnership:object{IgnisCollector.OutputCumulator} (swpair:string new-owner:string))
    (defun C_EnableFrozenLP:object{IgnisCollector.OutputCumulator} (patron:string swpair:string))
    (defun C_EnableSleepingLP:object{IgnisCollector.OutputCumulator} (patron:string swpair:string))
    (defun C_ModifyCanChangeOwner:object{IgnisCollector.OutputCumulator} (swpair:string new-boolean:bool))
    (defun C_ModifyWeights:object{IgnisCollector.OutputCumulator} (swpair:string new-weights:[decimal]))
    (defun C_ToggleAddOrSwap:object{IgnisCollector.OutputCumulator} (swpair:string toggle:bool add-or-swap:bool))
    (defun C_ToggleFeeLock:object{IgnisCollector.OutputCumulator} (patron:string swpair:string toggle:bool))
    (defun C_UpdateAmplifier:object{IgnisCollector.OutputCumulator} (swpair:string amp:decimal))
    (defun C_UpdateFee:object{IgnisCollector.OutputCumulator} (swpair:string new-fee:decimal lp-or-special:bool))
    (defun C_UpdateSpecialFeeTargets:object{IgnisCollector.OutputCumulator} (swpair:string targets:[object{FeeSplit}]))
    ;;
    (defun XB_ModifyWeights (swpair:string new-weights:[decimal]))
    ;;
    (defun XE_UpdateSupplies (swpair:string new-supplies:[decimal]))
    (defun XE_UpdateSupply (swpair:string id:string new-supply:decimal))
    (defun XE_Issue:string (account:string pool-tokens:[object{PoolTokens}] token-lp:string fee-lp:decimal weights:[decimal] amp:decimal p:bool))
    (defun XE_CanAddOrSwapToggle (swpair:string toggle:bool add-or-swap:bool))
)
;;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
(interface SwapperIssue
    @doc "Exposes SWP Issuing Functions. \
    \ Also contains Swap Computation Functions, and the Hopper Function"
    ;;
    ;;
    ;;  SCHEMAS
    ;;
    (defschema Hopper
        nodes:[string]
        edges:[string]
        output-values:[decimal]    
    )
    ;;
    ;;
    ;;  [UC] Functions
    ;;
    (defun UC_DeviationInValueShares:decimal (pool-reserves:[decimal] asymmetric-liq:[decimal] w:[decimal]))
    (defun UC_DeviatedShares:[decimal] (pool-reserves:[decimal] pool-shares:[decimal] new-total-shares:decimal))
    (defun UC_PoolShares:[decimal] (pool-reserves:[decimal] w:[decimal]))
    (defun UC_VirtualSwap:object{UtilitySwpV2.VirtualSwapEngine} 
        (vse:object{UtilitySwpV2.VirtualSwapEngine} dsid:object{UtilitySwpV2.DirectSwapInputData})
    )
    (defun UC_BareboneSwapWithFeez:object{UtilitySwpV2.DirectTaxedSwapOutput}
        (
            account:string pool-type:string 
            dsid:object{UtilitySwpV2.DirectSwapInputData} fees:object{UtilitySwpV2.SwapFeez}
            A:decimal X:[decimal] X-prec:[integer] input-positions:[integer] output-position:integer weights:[decimal]
        )
    )
    (defun UC_InverseBareboneSwapWithFeez:object{UtilitySwpV2.InverseTaxedSwapOutput}
        (
            account:string pool-type:string 
            rsid:object{UtilitySwpV2.ReverseSwapInputData} fees:object{UtilitySwpV2.SwapFeez}
            A:decimal X:[decimal] X-prec:[integer] output-position:integer input-position:integer weights:[decimal]
        )
    )
    (defun UC_BareboneSwap:decimal (pool-type:string drsi:object{UtilitySwpV2.DirectRawSwapInput}))
    (defun UC_BareboneInverseSwap:decimal (pool-type:string irsi:object{UtilitySwpV2.InverseRawSwapInput}))
    (defun UC_PoolTokenPositions:[integer] (swpair:string input-ids:[string]))
    ;;
    ;;
    ;;  [URC] Functions
    ;;
    (defun URC_EliteFeeReduction:object{UtilitySwpV2.SwapFeez} (account:string fees:object{UtilitySwpV2.SwapFeez}))
    (defun URC_PoolTokenPositions:[integer] (swpair:string input-ids:[string]))
    (defun URC_DirectRawSwapInput:object{UtilitySwpV2.DirectRawSwapInput} (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData}))
    (defun URC_InverseRawSwapInput:object{UtilitySwpV2.InverseRawSwapInput} (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData}))
        ;;
    (defun URC_Swap:decimal (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} validation:bool))
    (defun URC_S-Swap:decimal (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData}))
    (defun URC_W-Swap:decimal (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData}))
    (defun URC_P-Swap:decimal (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData}))
        ;;
    (defun URC_InverseSwap:decimal (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData} validation:bool))
    (defun URC_S-InverseSwap:decimal (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData}))
    (defun URC_W-InverseSwap:decimal (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData}))
    (defun URC_P-InverseSwap (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData}))
        ;;
    (defun URC_Hopper:object{Hopper} (hopper-input-id:string hopper-output-id:string hopper-input-amount:decimal))
    (defun URC_BestEdge:string (ia:decimal i:string o:string))
        ;;
    (defun URC_TokenDollarPrice (id:string kda-pid:decimal))
    (defun URC_SingleWorthDWK (id:string))
    (defun URC_WorthDWK (id:string amount:decimal))
    (defun URC_PoolValue:[decimal] (swpair:string))
        ;;
    (defun URC_DirectRefillAmounts:[decimal] (swpair:string ids:[string] amounts:[decimal]))
    (defun URC_IndirectRefillAmounts:[decimal] (X:[decimal] positions:[integer] amounts:[decimal]))
    (defun URC_TrimIdsWithZeroAmounts:[string] (swpair:string input-amounts:[decimal]))
    ;;
    ;;
    ;;  [UEV] Functions
    ;;
    (defun UEV_SwapData (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData}))
    (defun UEV_InverseSwapData (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData}))
        ;;
    (defun UEV_Issue (account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool))
    ;;
    ;;
    ;;  [UDC] Functions
    ;;
    (defun UDC_DirectRawSwapInput:object{UtilitySwpV2.DirectRawSwapInput} 
        (dsid:object{UtilitySwpV2.DirectSwapInputData} A:decimal X:[decimal] input-positions:[integer] output-position:integer weights:[decimal])
    )
    (defun UDC_InverseRawSwapInput:object{UtilitySwpV2.InverseRawSwapInput} 
        (rsid:object{UtilitySwpV2.ReverseSwapInputData} A:decimal X:[decimal] output-position:integer input-position:integer weights:[decimal])
    )
    (defun UDC_Hopper:object{Hopper} (a:[string] b:[string] c:[decimal]))
    ;;
    ;;
    ;;  []C] Functions
    ;;
    ;;
    (defun C_Issue:object{IgnisCollector.OutputCumulator} (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool))    
)
;;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
(interface SwapperLiquidity
    @doc "Exposes Liquidity Functions;"
    ;;
    ;;
    ;;  SCHEMAS
    ;;
    (defschema OutputLP
        primary:decimal
        secondary:decimal
    )
    (defschema LiquiditySplit
        balanced:[decimal]
        asymmetric:[decimal]
    )
    (defschema LiquiditySplitType
        iz-balanced:bool
        iz-asymmetric:bool
    )
    (defschema LiquidityData
        sorted-lq:object{LiquiditySplit}
        sorted-lq-type:object{LiquiditySplitType}
        balanced:decimal
        asymmetric:decimal
        asymmetric-fee:decimal
    )
    (defschema LiquidityComputationData
        li:integer
        pool-type:string
        lp-prec:integer
        current-lp-supply:decimal
        lp-supply:decimal
        pool-token-supplies:[decimal]
    )
    (defschema AsymmetricTax
        tad:decimal                     ;;The value of Token A Deficit
        tad-diff:decimal                ;;Difference between <tad> and Fee Shares
        fuel:decimal                    ;;Token A amount as Fuel
        special:decimal                 ;;Token A amount for Special Targets
        boost:decimal                   ;;Token A amount for Boost
        fuel-to-lp:decimal              ;;Token A amount for Fuel converted to LP amounts
    )
    (defschema CompleteLiquidityAdditionData
        total-input-liquidity:[decimal]
        balanced-liquidity:[decimal]
        asymmetric-liquidity:[decimal]
        asymmetric-deviation:decimal
        ;;
        primary-lp:decimal
        secondary-lp:decimal
        ;;
        total-ignis-tax-needed:decimal
        ;;
        gaseous-ignis-fee:decimal
        deficit-ignis-tax:decimal
        special-ignis-tax:decimal
        lqboost-ignis-tax:decimal
        relinquish-lp:decimal
        ;;
        gaseous-text:string
        deficit-text:string
        special-text:string
        lqboost-text:string
        fueling-text:string
    )
    (defschema PoolState
        X:[decimal]
        LP:decimal
    )
    ;;
    ;;
    ;;  [UC] Functions
    ;;
    (defun UC_DetermineLiquidity:object{LiquiditySplitType} (input-lqs:object{LiquiditySplit}))
    ;;
    ;;
    ;;  [URC] Functions
    ;;
    (defun URC|KDA-PID:decimal ())
    (defun URC|KDA-PID_LpToIgnis:decimal (swpair:string amount:decimal kda-pid:decimal))
    (defun URC|KDA-PID_TokenToIgnis (id:string amount:decimal kda-pid:decimal))
    (defun URC|KDA-PID_CompleteLiquidityAdditionData:object{CompleteLiquidityAdditionData}
        (
            account:string swpair:string ld:object{LiquidityData} 
            asymmetric-collection:bool gaseous-collection:bool kda-pid:decimal
        )
    )
    (defun URC_TokenPrecision (id:string))
    (defun URC_IgnisPrecision ())
        ;;
    (defun URC_EntityPosToID:string (swpair:string entity-pos:integer))
        ;;
    (defun URC_Liquidity:object{LiquidityData} (swpair:string input-amounts:[decimal]))
    (defun URC_AsymmetricTax:object{AsymmetricTax} (account:string swpair:string ld:object{LiquidityData}))
    (defun URC_SortLiquidity:object{LiquiditySplit} (swpair:string input-amounts:[decimal]))
        ;;
    (defun URC_AreAmountsBalanced:bool (swpair:string input-amounts:[decimal]))
    (defun URC_BalancedLiquidity:[decimal] (swpair:string input-id:string input-amount:decimal with-validation:bool))
    (defun URC_LpBreakAmounts:[decimal] (swpair:string input-lp-amount:decimal))
    (defun URC_CustomLpBreakAmounts:[decimal] (swpair:string swpair-pool-token-supplies:[decimal] swpair-lp-supply:decimal input-lp-amount:decimal))
    ;;
    ;;
    ;;  [UEV] Functions
    ;;
    (defun UEV_Liquidity:decimal (swpair:string ld:object{LiquidityData}))
    (defun UEV_BalancedLiquidity (swpair:string input-id:string input-amount:decimal))
    (defun UEV_InputsForLP (swpair:string input-amounts:[decimal]))
    ;;
    ;;
    ;;  [UDC] Functions
    ;;
    (defun UDC_VirtualSwapEngineSwpair:object{UtilitySwpV2.VirtualSwapEngine} (account:string account-liq:[decimal] swpair:string pool-liq:[decimal]))
    (defun UDC_VirtualSwapEngine:object{UtilitySwpV2.VirtualSwapEngine}
        (
            account:string account-liq:[decimal] swpair:string starting-liq:[decimal]
            A:decimal W:[decimal] F:object{UtilitySwpV2.SwapFeez}
        )
    )
    (defun UDC_PoolFees:object{UtilitySwpV2.SwapFeez} (swpair:string))
        ;;
    (defun UDC_OutputLP:object{OutputLP} (a:decimal b:decimal))
    (defun UDC_LiquiditySplit:object{LiquiditySplit} (a:[decimal] b:[decimal]))
    (defun UDC_LiquiditySplitType:object{LiquiditySplitType} (a:bool b:bool))
    (defun UDC_LiquidityData:object{LiquidityData} (a:object{LiquiditySplit} b:object{LiquiditySplitType} c:decimal d:decimal e:decimal))
    (defun UDC_LiquidityComputationData:object{LiquidityComputationData} (a:integer b:string c:integer d:decimal e:decimal f:[decimal]))
    (defun UDC_AsymmetricTax:object{AsymmetricTax} (a:decimal b:decimal c:decimal d:decimal e:decimal f:decimal))
    ;;
    ;;
    ;;  []C] Functions
    ;;
    ;;
    (defun C_ToggleAddLiquidity:object{IgnisCollector.OutputCumulator} (swpair:string toggle:bool))
    (defun C_Fuel:object{IgnisCollector.OutputCumulator} (account:string swpair:string input-amounts:[decimal] direct-or-indirect:bool validation:bool))
        ;;
    (defun C|KDA-PID_AddStandardLiquidity:object{IgnisCollector.OutputCumulator} (account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun C|KDA-PID_AddIcedLiquidity:object{IgnisCollector.OutputCumulator} (account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun C|KDA-PID_AddGlacialLiquidity:object{IgnisCollector.OutputCumulator} (account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun C|KDA-PID_AddFrozenLiquidity:object{IgnisCollector.OutputCumulator} (account:string swpair:string frozen-dptf:string input-amount:decimal kda-pid:decimal))
    (defun C|KDA-PID_AddSleepingLiquidity:object{IgnisCollector.OutputCumulator} (account:string swpair:string sleeping-dpmf:string nonce:integer kda-pid:decimal))
        ;;
    (defun C_RemoveLiquidity:object{IgnisCollector.OutputCumulator} (account:string swpair:string lp-amount:decimal))
)
;;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
(interface SwapperUsageV4
    @doc "Exposes Adding|Removing Liquidty and Swapping Functions of the SWP Module\ 
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
        \ Branding for LP added to the SPWU from SWP Module \
        \ \
        \ V3 Removes <patron> input variable where it is not needed \
        \ V4 Brings SWPU Segregation into SWPI, SWPL and a new SWPU that contains only Swap related Functions \
        \ and improved Swap Logistics"
    ;;
    ;;
    ;;  SCHEMAS
    ;;
    (defschema Slippage
        expected-output-amount:decimal
        output-precision:integer
        slippage-percent:decimal
    )
    ;;
    ;;
    ;;  [UC] Functions
    ;;
    (defun UC_SlippageMinMax:[decimal] (input:object{Slippage}))
    ;;
    ;;
    ;;  [UDC] Functions
    ;;
    (defun UDC_Slippage:object{Slippage} (a:decimal b:integer c:decimal))
    (defun UDC_SlippageObject:object{Slippage} (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage-value:decimal))
    ;;
    ;;
    ;;  []C] Functions
    ;;
    ;;
    (defun C_ToggleSwapCapability:object{IgnisCollector.OutputCumulator} (swpair:string toggle:bool))
    (defun C_Swap:object{IgnisCollector.OutputCumulator} (account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:decimal kda-pid:decimal))
)

(interface SwapperMtx
    @doc "Exposes SWP MultiStep (via defpact) Functions."
    ;;
    ;;
    ;;  []C] Functions
    ;;
    ;;
    (defun C_IssueStablePool (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal amp:decimal p:bool))
    (defun C_IssueWeightedPool (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool))
    (defun C_IssueStandardPool (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal p:bool))
    ;;
    (defun C|KDA-PID_AddStandardLiquidity (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))

)