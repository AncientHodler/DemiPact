;;
;;  [TALOS Stage One Admin]
;;
(interface TalosStageOne_AdminV4
    @doc "V2 removes <XE_IgnisCollect> with the implementation of IgnisCumulatorV2 Architecture \
        \ V3 Removes <patron> input variable where it is not needed \
        \ V4 Adds 2 more SWP Admin Functions"
    ;;
    ;;DALOS Functions
    (defun DALOS|A_MigrateLiquidFunds:decimal (migration-target-kda-account:string))
    (defun DALOS|A_ToggleOAPU (oapu:bool))
    (defun DALOS|A_ToggleGAP (gap:bool))
    (defun DALOS|A_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun DALOS|A_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun DALOS|A_IgnisToggle (native:bool toggle:bool))
    (defun DALOS|A_SetIgnisSourcePrice (price:decimal))
    (defun DALOS|A_SetAutoFueling (toggle:bool))
    (defun DALOS|A_UpdatePublicKey (account:string new-public:string))
    (defun DALOS|A_UpdateUsagePrice (action:string new-price:decimal))
    ;;
    ;;
    ;;BRD Functions
    (defun BRD|A_Live (entity-id:string))
    (defun BRD|A_SetFlag (entity-id:string flag:integer))
    ;;
    ;;
    ;;DPTF Functions
    (defun DPTF|A_UpdateTreasuryDispoParameters (type:integer tdp:decimal tds:decimal))
    (defun DPTF|A_WipeTreasuryDebt ())
    (defun DPTF|A_WipeTreasuryDebtPartial (debt-to-be-wiped:decimal))
    ;;
    ;;
    ;;LIQUID Functions
    (defun LIQUID|A_MigrateLiquidFunds:decimal (migration-target-kda-account:string))
    ;;
    ;;
    ;;ORBR Functions
    (defun ORBR|A_Fuel ())
    ;;
    ;;
    ;;SWP Functions
    (defun SWP|A_UpdatePrincipal (principal:string add-or-remove:bool))
    (defun SWP|A_UpdateLimit (limit:decimal spawn:bool))
    (defun SWP|A_UpdateLiquidBoost (new-boost-variable:bool))
    (defun SWP|A_DefinePrimordialPool (primordial-pool:string))
    (defun SWP|A_ToggleAsymetricLiquidityAddition (toggle:bool))
    ;;
    ;;
    ;;Fueling Functions
    (defun XB_DynamicFuelKDA ())
    (defun XE_ConditionalFuelKDA (condition:bool))
)
;;
;;  [TALOS Stage One Client One]
;;
(interface TalosStageOne_ClientOneV4
    @doc "Supports new TFT Architecture \
    \ V2 Adds manual Update for Elite Account Data, and IGNIS Cost for manualy creating DPTF and DPMF Account \
    \ V3 Adds MultiBulk Support, and with it, even further optimized architecture in the TFT Module \
    \ V4 remove <integer> output from 2 DPMF Function due to Info Upgrade"
    ;;
    ;;DALOS Functions
    (defun DALOS|C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool))
    (defun DALOS|C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun DALOS|C_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun DALOS|C_RotateGovernor (patron:string account:string governor:guard))
    (defun DALOS|C_RotateGuard (patron:string account:string new-guard:guard safe:bool))
    (defun DALOS|C_RotateKadena (patron:string account:string kadena:string))
    (defun DALOS|C_RotateSovereign (patron:string account:string new-sovereign:string))
    (defun DALOS|C_UpdateEliteAccount (patron:string account:string))
    (defun DALOS|C_UpdateEliteAccountSquared (patron:string sender:string receiver:string))
    ;;
    ;;
    ;;DPTF (Demiourgos Pact True Fungible) Functions
    (defun DPTF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun DPTF|C_UpgradeBranding (patron:string entity-id:string months:integer))
    ;;
    (defun DPTF|C_Burn (patron:string id:string account:string amount:decimal))
    (defun DPTF|C_ClearDispo (patron:string account:string))
    (defun DPTF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool))
    (defun DPTF|C_DeployAccount (patron:string id:string account:string))
    (defun DPTF|C_DonateFees (patron:string id:string))
    (defun DPTF|C_Issue:list (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool]))
    (defun DPTF|C_Mint (patron:string id:string account:string amount:decimal origin:bool))
    (defun DPTF|C_ResetFeeTarget (patron:string id:string))
    (defun DPTF|C_RotateOwnership (patron:string id:string new-owner:string))
    (defun DPTF|C_SetFee (patron:string id:string fee:decimal))
    (defun DPTF|C_SetFeeTarget (patron:string id:string target:string))
    (defun DPTF|C_SetMinMove (patron:string id:string min-move-value:decimal))
    (defun DPTF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool))
    (defun DPTF|C_ToggleFee (patron:string id:string toggle:bool))
    (defun DPTF|C_ToggleFeeExemptionRole (patron:string id:string account:string toggle:bool))
    (defun DPTF|C_ToggleFeeLock (patron:string id:string toggle:bool))
    (defun DPTF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool))
    (defun DPTF|C_ToggleMintRole (patron:string id:string account:string toggle:bool))
    (defun DPTF|C_TogglePause (patron:string id:string toggle:bool))
    (defun DPTF|C_ToggleReservation (patron:string id:string toggle:bool))
    (defun DPTF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool))
        ;;
    (defun DPTF|C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal))
    (defun DPTF|C_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool))
    (defun DPTF|C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
    (defun DPTF|C_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal]))
    (defun DPTF|C_MultiBulkTransfer (patron:string id:[string] sender:string receiver-array:[[string]] transfer-amount-array:[[decimal]]))
        ;;
    (defun DPTF|C_Wipe (patron:string id:string atbw:string))
    (defun DPTF|C_WipePartial (patron:string id:string atbw:string amtbw:decimal))
    ;;
    ;;
    ;;DPMF (Demiourgos Pact Meta Fungible) Functions
    (defun DPMF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun DPMF|C_UpgradeBranding (patron:string entity-id:string months:integer))
    ;;
    (defun DPMF|C_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal))
    (defun DPMF|C_Burn (patron:string id:string nonce:integer account:string amount:decimal))
    (defun DPMF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool))
    (defun DPMF|C_Create (patron:string id:string account:string meta-data:[object]))
    (defun DPMF|C_DeployAccount (patron:string id:string account:string))
    (defun DPMF|C_Issue:list (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool]))
    (defun DPMF|C_Mint (patron:string id:string account:string amount:decimal meta-data:[object]))
    (defun DPMF|C_MoveCreateRole (patron:string id:string receiver:string))
    (defun DPMF|C_MultiBatchTransfer (patron:string id:string nonces:[integer] sender:string receiver:string method:bool))
    (defun DPMF|C_RotateOwnership (patron:string id:string new-owner:string))
    (defun DPMF|C_SingleBatchTransfer (patron:string id:string nonce:integer sender:string receiver:string method:bool))
    (defun DPMF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool))
    (defun DPMF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool))
    (defun DPMF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool))
    (defun DPMF|C_TogglePause (patron:string id:string toggle:bool))
    (defun DPMF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool))
    (defun DPMF|C_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool))
    (defun DPMF|C_Wipe (patron:string id:string atbw:string))
    (defun DPMF|C_WipePartial (patron:string id:string atbw:string nonces:[integer]))
)
;;
;;  [TALOS Stage One Client Two]
;;
(interface TalosStageOne_ClientTwoV4
    @doc "V2 Removes <patron> input variable where it is not needed \
        \ V3 brings the improved liquidity engine, two more liquidity addition types \
        \ V4 removed manual kda-pid from adding liquidity functions \
        \ for a total of 5 with improved Swap Logistics"
    ;;
    ;;ATS (Autostake) Functions
    (defun ATS|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun ATS|C_UpgradeBranding (patron:string entity-id:string months:integer))
    ;;
    (defun ATS|C_AddHotRBT (patron:string ats:string hot-rbt:string))
    (defun ATS|C_AddSecondary (patron:string ats:string reward-token:string rt-nfr:bool))
    (defun ATS|C_Coil:decimal (patron:string coiler:string ats:string rt:string amount:decimal))
    (defun ATS|C_ColdRecovery (patron:string recoverer:string ats:string ra:decimal))
    (defun ATS|C_Cull:[decimal] (patron:string culler:string ats:string))
    (defun ATS|C_Curl:decimal (patron:string curler:string ats1:string ats2:string rt:string amount:decimal))
    (defun ATS|C_Fuel (patron:string fueler:string ats:string reward-token:string amount:decimal))
    (defun ATS|C_HotRecovery (patron:string recoverer:string ats:string ra:decimal))
    (defun ATS|C_Issue:list (patron:string account:string ats:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string] rbt-nfr:[bool]))
    (defun ATS|C_KickStart:decimal (patron:string kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal))
    (defun ATS|C_ModifyCanChangeOwner (patron:string ats:string new-boolean:bool))
    (defun ATS|C_RecoverHotRBT (patron:string recoverer:string id:string nonce:integer amount:decimal))
    (defun ATS|C_RecoverWholeRBTBatch (patron:string recoverer:string id:string nonce:integer))
    (defun ATS|C_Redeem (patron:string redeemer:string id:string nonce:integer))
    (defun ATS|C_RemoveSecondary (patron:string remover:string ats:string reward-token:string))
    (defun ATS|C_RotateOwnership (patron:string ats:string new-owner:string))
    (defun ATS|C_SetColdFee (patron:string ats:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]]))
    (defun ATS|C_SetCRD (patron:string ats:string soft-or-hard:bool base:integer growth:integer))
    (defun ATS|C_SetHotFee (patron:string ats:string promile:decimal decay:integer))
    (defun ATS|C_Syphon (patron:string syphon-target:string ats:string syphon-amounts:[decimal]))
    (defun ATS|C_ToggleElite (patron:string ats:string toggle:bool))
    (defun ATS|C_ToggleFeeSettings (patron:string ats:string toggle:bool fee-switch:integer))
    (defun ATS|C_ToggleParameterLock (patron:string ats:string toggle:bool))
    (defun ATS|C_ToggleSyphoning (patron:string ats:string toggle:bool))
    (defun ATS|C_TurnRecoveryOff (patron:string ats:string cold-or-hot:bool))
    (defun ATS|C_TurnRecoveryOn (patron:string ats:string cold-or-hot:bool))
    (defun ATS|C_UpdateSyphon (patron:string ats:string syphon:decimal))
    ;;
    ;;
    ;;VST (Vesting) Functions
    (defun VST|C_CreateFrozenLink:string (patron:string dptf:string))
    (defun VST|C_CreateReservationLink:string (patron:string dptf:string))
    (defun VST|C_CreateVestingLink:string (patron:string dptf:string))
    (defun VST|C_CreateSleepingLink:string (patron:string dptf:string))
    ;;Frozen
    (defun VST|C_Freeze (patron:string freezer:string freeze-output:string dptf:string amount:decimal))
    (defun VST|C_RepurposeFrozen (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string))
    (defun VST|C_ToggleTransferRoleFrozenDPTF (patron:string s-dptf:string target:string toggle:bool))
    ;;Reservation
    (defun VST|C_Reserve (patron:string reserver:string dptf:string amount:decimal))
    (defun VST|C_Unreserve (patron:string unreserver:string r-dptf:string amount:decimal))
    (defun VST|C_RepurposeReserved (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string))
    (defun VST|C_ToggleTransferRoleReservedDPTF (patron:string s-dptf:string target:string toggle:bool))
    ;;Vesting
    (defun VST|C_Unvest (patron:string culler:string dpmf:string nonce:integer))
    (defun VST|C_Vest (patron:string vester:string target-account:string dptf:string amount:decimal offset:integer duration:integer milestones:integer))
    (defun VST|C_RepurposeVested (patron:string dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string))
    (defun VST|C_CoilAndVest:decimal (patron:string coiler-vester:string ats:string coil-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer))
    (defun VST|C_CurlAndVest:decimal (patron:string curler-vester:string ats1:string ats2:string curl-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer))
    ;;Sleeping
    (defun VST|C_Merge(patron:string merger:string dpmf:string nonces:[integer]))
    (defun VST|C_MergeAll(patron:string merger:string dpmf:string))
    (defun VST|C_Sleep (patron:string sleeper:string target-account:string dptf:string amount:decimal duration:integer))
    (defun VST|C_Unsleep (patron:string unsleeper:string dpmf:string nonce:integer))
    (defun VST|C_RepurposeSleeping (patron:string dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string))
    (defun VST|C_RepurposeMerge (patron:string dpmf-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string))
    (defun VST|C_RepurposeMergeAll (patron:string dpmf-to-repurpose:string repurpose-from:string repurpose-to:string))
    (defun VST|C_ToggleTransferRoleSleepingDPMF (patron:string s-dpmf:string target:string toggle:bool))
    ;;
    ;;
    ;;LQD (Liquid-Staking KDA) Functions
    (defun LQD|C_UnwrapKadena (patron:string unwrapper:string amount:decimal))
    (defun LQD|C_WrapKadena (patron:string wrapper:string amount:decimal))
    ;;
    ;;
    ;;ORBR (Ouroboros) Functions
    (defun ORBR|C_Compress:decimal (client:string ignis-amount:decimal))
    (defun ORBR|C_Sublimate:decimal (client:string target:string ouro-amount:decimal))
    (defun ORBR|C_WithdrawFees (patron:string id:string target:string))
    ;;
    ;;
    ;;SWP (Swap-Pair) Functions
    (defun SWP|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun SWP|C_UpgradeBranding (patron:string entity-id:string months:integer))
    (defun SWP|C_UpdatePendingBrandingLPs (patron:string swpair:string entity-pos:integer logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun SWP|C_UpgradeBrandingLPs (patron:string swpair:string entity-pos:integer months:integer))
    ;;
    (defun SWP|C_ChangeOwnership (patron:string swpair:string new-owner:string))
    (defun SWP|C_EnableFrozenLP:string (patron:string swpair:string))
    (defun SWP|C_EnableSleepingLP:string (patron:string swpair:string))
    ;;Issue
    (defun SWP|C_IssueStable:list (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal amp:decimal p:bool))
    (defun SWP|C_IssueStandard:list (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal p:bool))
    (defun SWP|C_IssueWeighted:list (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool))
    ;;Management
    (defun SWP|C_ModifyCanChangeOwner (patron:string swpair:string new-boolean:bool))
    (defun SWP|C_ModifyWeights (patron:string swpair:string new-weights:[decimal]))
    (defun SWP|C_ToggleAddLiquidity (patron:string swpair:string toggle:bool))
    (defun SWP|C_ToggleSwapCapability (patron:string swpair:string toggle:bool))
    (defun SWP|C_ToggleFeeLock (patron:string swpair:string toggle:bool))
    (defun SWP|C_UpdateAmplifier (patron:string swpair:string amp:decimal))
    (defun SWP|C_UpdateFee (patron:string swpair:string new-fee:decimal lp-or-special:bool))
    (defun SWP|C_UpdateSpecialFeeTargets (patron:string swpair:string targets:[object{SwapperV4.FeeSplit}]))
    ;;Liquidity
    (defun SWP|C_AddLiquidity:string (patron:string account:string swpair:string input-amounts:[decimal]))
    (defun SWP|C_AddIcedLiquidity:string (patron:string account:string swpair:string input-amounts:[decimal]))
    (defun SWP|C_AddGlacialLiquidity:string (patron:string account:string swpair:string input-amounts:[decimal]))
    (defun SWP|C_AddFrozenLiquidity:string (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal))
    (defun SWP|C_AddSleepingLiquidity:string (patron:string account:string swpair:string sleeping-dpmf:string nonce:integer))
    (defun SWP|C_RemoveLiquidity:list (patron:string account:string swpair:string lp-amount:decimal))
    ;;Swap
    (defun SWP|C_SingleSwapWithSlippage (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string slippage:decimal))
    (defun SWP|C_SingleSwapNoSlippage (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string))
    (defun SWP|C_MultiSwapWithSlippage (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:decimal))
    (defun SWP|C_MultiSwapNoSlippage (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string))
)
;;
;;  [TALOS Stage One PactedMultistep]
;;
(interface TalosStageOne_ClientPactsV3
    @doc "Removes DPTF Bulk and Multi Transfer in Multistep, to be added later on \
    \ Due to the optimization of DPTF Transfers there are no longer needed in the near future \
    \ V3 Adds Liquidity Addition and moves all Defpacts in MTX Modules"

    ;;
    ;;
    ;;SWP (Swap-Pair) Pact Initiating Functions
    ;;Issue
    (defun SWP|C_IssueStablePool (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal amp:decimal p:bool))
    (defun SWP|C_IssueWeightedPool (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool))
    (defun SWP|C_IssueStandardPool (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal p:bool))
    ;;
    (defun SWP|C_AddStandardLiquidity (patron:string account:string swpair:string input-amounts:[decimal]))
    (defun SWP|C_AddIcedLiquidity (patron:string account:string swpair:string input-amounts:[decimal]))
    (defun SWP|C_AddGlacialLiquidity (patron:string account:string swpair:string input-amounts:[decimal]))
    (defun SWP|C_AddFrozenLiquidity (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal))
    (defun SWP|C_AddSleepingLiquidity (patron:string account:string swpair:string sleeping-dpmf:string nonce:integer))
    ;;
)