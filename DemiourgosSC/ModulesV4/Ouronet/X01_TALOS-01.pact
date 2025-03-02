;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface TalosStageOne
    ;;
    ;;ADMIN Functions
    (defun DALOS|A_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun DALOS|A_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun DALOS|A_IgnisToggle (native:bool toggle:bool))
    (defun DALOS|A_SetIgnisSourcePrice (price:decimal))
    (defun DALOS|A_SetAutoFueling (toggle:bool))
    (defun DALOS|A_UpdatePublicKey (account:string new-public:string))
    (defun DALOS|A_UpdateUsagePrice (action:string new-price:decimal))
    ;;
    ;;
    (defun BRD|A_Live (entity-id:string))
    (defun BRD|A_SetFlag (entity-id:string flag:integer))
    ;;
    ;;
    (defun ORBR|A_Fuel ())
    ;;
    ;;
    (defun SWP|A_UpdatePrincipal (principal:string add-or-remove:bool))
    (defun SWP|A_UpdateLimit (limit:decimal spawn:bool))
    (defun SWP|A_UpdateLiquidBoost (new-boost-variable:bool))

    ;;CLIENT Functions
    (defun DALOS|C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool))
    (defun DALOS|C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun DALOS|C_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun DALOS|C_RotateGovernor (patron:string account:string governor:guard))
    (defun DALOS|C_RotateGuard (patron:string account:string new-guard:guard safe:bool))
    (defun DALOS|C_RotateKadena (patron:string account:string kadena:string))
    (defun DALOS|C_RotateSovereign (patron:string account:string new-sovereign:string))
    ;;
    ;;
    (defun DPTF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun DPTF|C_UpgradeBranding (patron:string entity-id:string months:integer))
    ;;
    (defun DPTF|C_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool))
    (defun DPTF|C_Burn (patron:string id:string account:string amount:decimal))
    (defun DPTF|C_ClearDispo (patron:string account:string))
    (defun DPTF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool))
    (defun DPTF|C_DeployAccount (id:string account:string))
    (defun DPTF|C_DonateFees (patron:string id:string))
    (defun DPTF|C_Issue:list (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool]))
    (defun DPTF|C_Mint (patron:string id:string account:string amount:decimal origin:bool))
    (defun DPTF|C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
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
    (defun DPTF|C_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool))
    (defun DPTF|C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal))
    (defun DPTF|C_Wipe (patron:string id:string atbw:string))
    ;;
    ;;
    (defun DPMF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun DPMF|C_UpgradeBranding (patron:string entity-id:string months:integer))
    ;;
    (defun DPMF|C_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal))
    (defun DPMF|C_Burn (patron:string id:string nonce:integer account:string amount:decimal))
    (defun DPMF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool))
    (defun DPMF|C_Create:integer (patron:string id:string account:string meta-data:[object]))
    (defun DPMF|C_DeployAccount (id:string account:string))
    (defun DPMF|C_Issue:list (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool]))
    (defun DPMF|C_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object]))
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
    ;;
    ;;
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
    (defun VST|C_CreateFrozenLink:string (patron:string dptf:string))
    (defun VST|C_CreateReservationLink:string (patron:string dptf:string))
    (defun VST|C_CreateVestingLink:string (patron:string dptf:string))
    (defun VST|C_CreateSleepingLink:string (patron:string dptf:string))
    ;;Frozen
    (defun VST|C_Freeze (patron:string freezer:string freeze-output:string dptf:string amount:decimal))
    (defun VST|C_RepurposeFrozen (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string))
    ;;Reservation
    (defun VST|C_Reserve (patron:string reserver:string dptf:string amount:decimal))
    (defun VST|C_Unreserve (patron:string unreserver:string r-dptf:string amount:decimal))
    (defun VST|C_RepurposeReserved (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string))
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
    ;;
    ;;
    (defun LQD|C_UnwrapKadena (patron:string unwrapper:string amount:decimal))
    (defun LQD|C_WrapKadena (patron:string wrapper:string amount:decimal))
    ;;
    ;;
    (defun ORBR|C_Compress:decimal (patron:string client:string ignis-amount:decimal))
    (defun ORBR|C_Sublimate:decimal (patron:string client:string target:string ouro-amount:decimal))
    (defun ORBR|C_WithdrawFees (patron:string id:string target:string))
    ;;
    ;;
    (defun SWP|C_ChangeOwnership (patron:string swpair:string new-owner:string))
    ;;
    (defun SWP|C_IssueStable:list (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal amp:decimal p:bool))
    (defun SWP|C_IssueStandard:list (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal p:bool))
    (defun SWP|C_IssueWeighted:list (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool))
    ;;
    (defun SWP|C_IssueStableMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal amp:decimal p:bool))
    (defun SWP|C_IssueStandardMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal p:bool))
    (defun SWP|C_IssueWeightedMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool))
    ;;
    (defun SWP|C_ModifyCanChangeOwner (patron:string swpair:string new-boolean:bool))
    (defun SWP|C_ModifyWeights (patron:string swpair:string new-weights:[decimal]))
    (defun SWP|C_ToggleAddLiquidity (patron:string swpair:string toggle:bool))
    (defun SWP|C_ToggleSwapCapability (patron:string swpair:string toggle:bool))
    (defun SWP|C_UpdateAmplifier (patron:string swpair:string amp:decimal))
    (defun SWP|C_UpdateFee (patron:string swpair:string new-fee:decimal lp-or-special:bool))
    (defun SWP|C_UpdateSpecialFeeTargets (patron:string swpair:string targets:[object{Swapper.FeeSplit}]))
    ;;
    (defun SWP|C_AddBalancedLiquidity:decimal (patron:string account:string swpair:string input-id:string input-amount:decimal))
    (defun SWP|C_AddLiquidity:decimal (patron:string account:string swpair:string input-amounts:[decimal]))
    (defun SWP|C_RemoveLiquidity:list (patron:string account:string swpair:string lp-amount:decimal))
    ;;
    (defun SWP|C_MultiSwap (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:object{SwapperUsage.Slippage}))
    (defun SWP|C_MultiSwapNoSlippage (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string))
    (defun SWP|C_SimpleSwap (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string slippage:object{SwapperUsage.Slippage}))
    (defun SWP|C_SimpleSwapNoSlippage (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string))
    ;;
    ;;
)
(module TS01 GOV
    @doc "TALOS Administrator and Client Module for Stage 1"
    ;;
    (implements OuronetPolicy)
    (implements TalosStageOne)
    ;;{G1}
    (defconst GOV|MD_TS01           (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TS01_ADMIN)))
    (defcap GOV|TS01_ADMIN ()       (enforce-guard GOV|MD_TS01))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|TS ()
        @doc "Talos Summoner Capability"
        true
    )
    (defcap P|TRG ()
        @doc "Talos Remote Governor Capability"
        true
    )
    (defcap P|F ()
        (compose-capability (P|TS))
        (compose-capability (GOV|TS01_ADMIN))
    )
    (defcap P|GOVERNING-SUMMONER ()
        (compose-capability (P|TS))
        (compose-capability (P|TRG))
    )
    (defcap P|SECURE-SUMMONER ()
        (compose-capability (P|TS))
        (compose-capability (SECURE))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|TS01_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|TS01_ADMIN)
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
                (ref-P|SWPU:module{OuronetPolicy} SWPU)
                (mg:guard (create-capability-guard (P|TS)))
            )
            (ref-P|DALOS::P|A_Add "TALOS-01" mg)
            (ref-P|BRD::P|A_Add "TALOS-01" mg)
            (ref-P|DPTF::P|A_Add "TALOS-01" mg)
            (ref-P|DPMF::P|A_Add "TALOS-01" mg)
            (ref-P|ATS::P|A_Add "TALOS-01" mg)
            (ref-P|TFT::P|A_Add "TALOS-01" mg)
            (ref-P|ATSU::P|A_Add "TALOS-01" mg)
            (ref-P|VST::P|A_Add "TALOS-01" mg)
            (ref-P|LIQUID::P|A_Add "TALOS-01" mg)
            (ref-P|ORBR::P|A_Add "TALOS-01" mg)
            (ref-P|SWPT::P|A_Add "TALOS-01" mg)
            (ref-P|SWP::P|A_Add "TALOS-01" mg)
            (ref-P|SWPU::P|A_Add "TALOS-01" mg)

            (ref-P|DALOS::P|A_Add 
                "TALOS-01|RemoteDalosGov"
                (create-capability-guard (P|TRG))
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
            (ref-P|SWPU::P|A_AddIMP mg)
        )
    )
    ;;
    ;;{3}
    (defun TALOS|Gassless ()        (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|DALOS|SC_NAME)))
    (defconst GASSLES-PATRON        (TALOS|Gassless))
    (defcap SECURE ()
        true
    )
    ;;
    ;;{DALOS_Administrator}
    (defun DALOS|A_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        @doc "Deploys a Smart Ouronet Account in Administrator Mode, without collection KDA"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::A_DeploySmartAccount account guard kadena sovereign public)
            )
        )
    )
    (defun DALOS|A_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        @doc "Deploys a Standard Ouronet Account in Administrator Mode, without collection KDA"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::A_DeployStandardAccount account guard kadena public)
            )
        )
    )
    (defun DALOS|A_IgnisToggle (native:bool toggle:bool)
        @doc "Toggles Ouronet Gas Collection \
        \ <native> true is KDA Collection for Specific Usage Actions \
        \ <native> false is IGNIS Collection for Client Functions"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::A_IgnisToggle native toggle)
            )
        )
    )
    (defun DALOS|A_SetIgnisSourcePrice (price:decimal)
        @doc "Sets OUROBOROS Price in $. Used in Compresion and Sublimation"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::A_SetIgnisSourcePrice price)
            )
        )
    )
    (defun DALOS|A_SetAutoFueling (toggle:bool)
        @doc "Sets Automatic fueling of Collected KDA for the Increase of the <KdaLiquindex>"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::A_SetAutoFueling toggle)
            )
        )
    )
    (defun DALOS|A_UpdatePublicKey (account:string new-public:string)
        @doc "Updates Public Key; To be used only as failsafe by the Admin"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::A_UpdatePublicKey account new-public)
            )
        )
    )
    (defun DALOS|A_UpdateUsagePrice (action:string new-price:decimal)
        @doc "Updates specific Usage Price in KDA"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::A_UpdateUsagePrice action new-price)
            )
        )
    )
    ;;{BRD_Administrator}
    (defun BRD|A_Live (entity-id:string)
        @doc "Sets <pending-branding> for an <entity-id> to <live-branding>, reseting <pending-branding> data \
            \ Resetting <pending-branding> data does not reset its last 3 keys \
            \ Can only be done by Branding Administrator"
        (let
            (
                (ref-BRD:module{Branding} BRD)
            )
            (with-capability (P|TS)
                (ref-BRD::A_Live entity-id)
            )
        )
    )
    (defun BRD|A_SetFlag (entity-id:string flag:integer)
        @doc "Forcibly (in administrator mode) sets a Branding Flag for <entity-id> \
            \ <0> Flag = Golden Flag        Premium Flag reserved for Demiourgos Entity IDs \
            \ <1> Flag = Blue Flag          Premium Flag for Entity IDs (non-Demiourgos); \
            \                               Premium Flags are paid live branded Entity-IDs that are not labeled as problematic \
            \                               Paid live branded Entity IDs can still be flaged Red by the Branding Administrator \
            \ <2> Flag = Green Flag         Standard Flag for Entity IDs (non-Demiourgos) that have their Branding set to Live \
            \ <3> Flag = Gray Flag          Default Flag for newly-issued Entity-IDs (non-Demiourgos) that dont have their Branding Live yet \
            \ <4> Flag = Red Flag           Problem Flag for Entity IDs, marking potential dangerous or scam Entity IDs"
        (let
            (
                (ref-BRD:module{Branding} BRD)
            )
            (with-capability (P|TS)
                (ref-BRD::A_SetFlag entity-id flag)
            )
        )
    )
    ;;{OUROBOROS_Administrator}
    (defun ORBR|A_Fuel ()
        @doc "Uses up all collected Native KDA on the Ouroboros Account, wraps it, and fuels the Kadena Liquid Index \
            \ Transaction fee must be paid for by the Ouronet Gas Station, so that all available balance may be used. \
            \ Is Part of all the Functions that collect native KDA as fee, \
            \ boosting the KDA Liquid Index, from 15% of the collected KDA \
            \ As Stand-Alone Function, can only be used by the Admin. \
            \ In normal condition, there is no need for using it on itself, as all collected KDA is automatically used up \
            \ by implementing this function at the end of those funtions that collect the KDA. \
            \ Dalos-Patron is the only gass"
        (with-capability (SECURE)
            (XI_DirectFuelKDA)
        )
    )
    ;;{SWP_Administrator}
    (defun SWP|A_UpdatePrincipal (principal:string add-or-remove:bool)
        @doc "Updates the principal Token List. \
        \ A principal is a token that must exist once in every W or P Swpiar, on the first position \
        \ Also, the S Pools, must have at least one Token dtied directly to a principal Token"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (P|F)
                (ref-SWP::A_UpdatePrincipal principal add-or-remove)
            )
        )
    )
    (defun SWP|A_UpdateLimit (limit:decimal spawn:bool)
        @doc "Updates either the <spawn-limit> or <inactive-limit> for the SWP Module \
        \ The <spawn-limit> is the minimum number in KDA that a pool must be created with, in order to be opened for swap \
        \ The <inactive-limit> is the minimum number in KDA as total pool liquidity value, that trigger autonomic disable of the swap mechanism"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (P|F)
                (ref-SWP::A_UpdateLimit limit spawn)
            )
        )
    )
    (defun SWP|A_UpdateLiquidBoost (new-boost-variable:bool)
        @doc "Updates Liquid Boost switch. When set to true, everyu swap is set to pump the Index for Kadena Liquid Staking"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (P|F)
                (ref-SWP::A_UpdateLiquidBoost new-boost-variable)
            )
        )
    )
    ;;{DALOS_Client}
    (defun DALOS|C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool)
        @doc "Controls Smart Ouronet Account properties via boolean triggers"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DALOS::C_ControlSmartAccount patron account payable-as-smart-contract payable-by-smart-contract payable-by-method)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
        )
    )
    (defun DALOS|C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        @doc "Deploys a Standard Ouronet Account, taxing for KDA"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|SECURE-SUMMONER)
                (ref-DALOS::C_DeploySmartAccount account guard kadena sovereign public)
                (XI_DynamicFuelKDA)
            )
        )
    )
    (defun DALOS|C_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        @doc "Deploys a Standard Ouronet Account, taxing for KDA"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ORBR:module{Ouroboros} OUROBOROS)
                (auto-fuel:bool (ref-DALOS::UR_AutoFuel))
            )
            (with-capability (P|SECURE-SUMMONER)
                (ref-DALOS::C_DeployStandardAccount account guard kadena public)
                (XI_DynamicFuelKDA)
            )
        )
    )
    (defun DALOS|C_RotateGovernor (patron:string account:string governor:guard)
        @doc "Rotates the governor of a Smart Ouronet Account \
        \ The Governor acts as a governing entity for the Smart Ouronet Account allowing fine control of its assets"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DALOS::C_RotateGovernor patron account governor)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
        )
    )
    (defun DALOS|C_RotateGuard (patron:string account:string new-guard:guard safe:bool)
        @doc "Rotates the guard of an Ouronet Safe. Boolean <safe> also enforces the <new-guard>"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DALOS::C_RotateGuard patron account new-guard safe)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
        )
    )
    (defun DALOS|C_RotateKadena (patron:string account:string kadena:string)
        @doc "Rotates the KDA Account attached to an Ouronet Account. \
        \ The attached KDA Account is the account that makes KDA Payments for specific Ouronet Actions"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DALOS::C_RotateKadena patron account kadena)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
        )
    )
    (defun DALOS|C_RotateSovereign (patron:string account:string new-sovereign:string)
        @doc "Rotates the Sovereign of a Smart Ouronet Account \
        \ The Sovereign of a Smart Ouronet Account acts as its owner, allowing dominion over its assets"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DALOS::C_RotateSovereign patron account new-sovereign)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
        )
    )
    ;;{DPTF_Client}
    (defun DPTF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for DPTF Token <entity-id> costing 100 IGNIS"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_UpdatePendingBranding patron entity-id logo description website social)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPTF::UR_Konto entity-id) [ico])
        )
    )
    (defun DPTF|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Upgrades Branding for DPTF Token, making it a premium Branding. \
            \ Also sets pending-branding to live branding if its branding is not live yet"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|SECURE-SUMMONER)
                (ref-DPTF::C_UpgradeBranding patron entity-id months)
                (XI_DynamicFuelKDA)
            )
        )
    )
    ;;
    (defun DPTF|C_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Executes a Bulk DPTF Transfer, sending one DPTF, to multiple receivers, each with its own amount \
        \ Always enforces <min-move> amount, and <receiver-lst> must all be Standard Ouronet Accounts, \
        \ as it cant send to Smart Ouronet Account recipients. \
        \ Works for 12 Recipients when using DPTFs, or 8 Recipients when using Elite-Auryn"
        (let
            (
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-P|TFT::C_BulkTransfer patron id sender receiver-lst transfer-amount-lst method)
                    )
                )
            )
            (XC_IgnisCollect patron sender [ico])
        )
    )
    (defun DPTF|C_ExemptionBulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Similar to <DPTF|C_ExemptionTransfer> but for Bulk-Transfers"
        (let
            (
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-P|TFT::C_ExemptionBulkTransfer patron id sender receiver-lst transfer-amount-lst method)
                    )
                )
            )
            (XC_IgnisCollect patron sender [ico])
        )
    )
    (defun DPTF|C_Burn (patron:string id:string account:string amount:decimal)
        @doc "Burns a DPTF Token from an account"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_Burn patron id account amount)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
        )
    )
    (defun DPTF|C_ClearDispo (patron:string account:string)
        @doc "Clears OURO Dispo by levereging existing Elite-Auryn"
        (let
            (
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-P|TFT::C_ClearDispo patron account)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
        )
    )
    (defun DPTF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool)
        @doc "Controls the properties of a DPTF Token \
            \ <can-change-owner> <can-upgrade> <can-add-special-role> <can-freeze> <can-wipe> <can-pause>"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_Control patron id cco cu casr cf cw cp)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPTF::UR_Konto id) [ico])
        )
    )
    (defun DPTF|C_DeployAccount (id:string account:string)
        @doc "Deploys a DPTF Account"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_DeployAccount id account)
            )
        )
    )
    (defun DPTF|C_DonateFees (patron:string id:string)
        @doc "Sets the Fee Collection target to the DALOS|SC_NAME \
        \ When DPTF Fees collect here, the will be earned by Ouronet Custodians"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (dalos-sc:string (ref-DALOS::GOV|DALOS|SC_NAME))
            )
            (with-capability (P|TS)
                (ref-DPTF::C_SetFeeTarget patron id dalos-sc)
            )
        )
    )
    (defun DPTF|C_Issue:list (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
        @doc "Issues a new DPTF Token in Bulk, can also be used to issue a single DPTF \
        \ Outputs a string list with the issed DPTF IDs"
        (with-capability (P|SECURE-SUMMONER)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-DPTF::C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause)
                    )
                )
                (XC_IgnisCollect patron account [ico])
                (XI_DynamicFuelKDA)
                (at "output" ico)
            )   
        )
    )
    (defun DPTF|C_Mint (patron:string id:string account:string amount:decimal origin:bool)
        @doc "Mints a DPTF Token"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_Mint patron id account amount origin)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
        )
    )
    (defun DPTF|C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @doc "Executes a DPTF MultiTransfer, sending multiple DPTF, each with its own amount, to a single receiver \
            \ Works for up to 12 Tokens in a single TX."
        (let
            (
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-P|TFT::C_MultiTransfer patron id-lst sender receiver transfer-amount-lst method)
                    )
                )
            )
            (XC_IgnisCollect patron sender [ico])
        )
    )
    (defun DPTF|C_ExemptionMultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @doc "Similar to <DPTF|C_ExemptionTransfer> but for Multi-Transfers"
        (let
            (
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-P|TFT::C_ExemptionMultiTransfer patron id-lst sender receiver transfer-amount-lst method)
                    )
                )
            )
            (XC_IgnisCollect patron sender [ico])
        )
    )
    (defun DPTF|C_ResetFeeTarget (patron:string id:string)
        @doc "Sets the Fee Collection target to the OUROBOROS|SC_NAME \
        \ Fees can then be collected by <DPTF|C_WithdrawFees>"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (orbr-sc:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
            )
            (with-capability (P|TS)
                (ref-DPTF::C_SetFeeTarget patron id orbr-sc)
            )
        )
    )
    (defun DPTF|C_RotateOwnership (patron:string id:string new-owner:string)
        @doc "Rotates DPTF ID Ownership"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_RotateOwnership patron id new-owner)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPTF::UR_Konto id) [ico])
        )
    )
    (defun DPTF|C_SetFee (patron:string id:string fee:decimal)
        @doc "Sets a transfer fee for the DPTF Token"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_SetFee patron id fee)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPTF::UR_Konto id) [ico])
        )
    )
    (defun DPTF|C_SetFeeTarget (patron:string id:string target:string)
        @doc "Sets the Fee Collection Target for a DPTF"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_SetFeeTarget patron id target)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPTF::UR_Konto id) [ico])
        )
    )
    (defun DPTF|C_SetMinMove (patron:string id:string min-move-value:decimal)
        @doc "Sets the minimum amount needed to transfer a DPTF Token"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_SetMinMove patron id min-move-value)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPTF::UR_Konto id) [ico])
        )
    )
    (defun DPTF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <burn-role> for a DPTF Token <id> on a specific <account>"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-ATS::DPTF|C_ToggleBurnRole patron id account toggle)
                    )
                )
            )
            (XC_IgnisCollect patron account ico)
        )
    )
    (defun DPTF|C_ToggleFee (patron:string id:string toggle:bool)
        @doc "Toggles Fee collection for a DPTF Token. When a DPTF Token is setup with a transfer fee, \
            \ it will come in effect only when the toggle is on(true)"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_ToggleFee patron id toggle)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPTF::UR_Konto id) [ico])
        )
    )
    (defun DPTF|C_ToggleFeeExemptionRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <fee-exemption-role> for a DPTF Token <id> on a specific <account>"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-ATS::DPTF|C_ToggleFeeExemptionRole patron id account toggle)
                    )
                )
            )
            (XC_IgnisCollect patron account ico)
        )
    )
    (defun DPTF|C_ToggleFeeLock (patron:string id:string toggle:bool)
        @doc "Toggles DPTF Fee Settings Lock"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_ToggleFeeLock patron id toggle)
                    )
                )
                (collect:bool (at 0 (at "output" ico)))
            )
            (XC_IgnisCollect patron (ref-DPTF::UR_Konto id) [ico])
            (with-capability (SECURE)
                (XI_ConditionalFuelKDA collect)
            )
        )
    )
    (defun DPTF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Toggles Freezing of a DPTF Account"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_ToggleFreezeAccount patron id account toggle)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPTF::UR_Konto id) [ico])
        )
    )
    (defun DPTF|C_ToggleMintRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <mint-role> for a DPTF Token <id> on a specific <account>"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-ATS::DPTF|C_ToggleMintRole patron id account toggle)
                    )
                )
            )
            (XC_IgnisCollect patron account ico)
        )
    )
    (defun DPTF|C_TogglePause (patron:string id:string toggle:bool)
        @doc "Toggles Pause for a DPTF Token"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_TogglePause patron id toggle)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPTF::UR_Konto id) [ico])
        )
    )
    (defun DPTF|C_ToggleReservation (patron:string id:string toggle:bool)
        @doc "Toggles Reservations for a DPTF Token"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_ToggleReservation patron id toggle)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPTF::UR_Konto id) [ico])
        )
    )

    (defun DPTF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <transfer-role> for a DPTF Token <id> on a specific <account>"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_ToggleTransferRole patron id account toggle)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
        )
    )
    (defun DPTF|C_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Transfers a DPTF Token from <sender> to <receiver>, with all checks in place"
        (let
            (
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-P|TFT::C_Transfer patron id sender receiver transfer-amount method)
                    )
                )
            )
            (XC_IgnisCollect patron sender [ico])
        )
    )
    (defun DPTF|C_ExemptionTransfer (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Transfers a DPTF Token from <sender> to <receiver>, \
        \ when either <sender> or <receiver> has <fee-exemption-role> set to true for DPTF <id> \
        \ Is Faster than <DPTF|C_Transfer> due to trimmed execution logic, and should be used whenever possible, \
        \ if the proper conditions are met"
        (let
            (
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-P|TFT::C_ExemptionTransfer patron id sender receiver transfer-amount method)
                    )
                )
            )
            (XC_IgnisCollect patron sender [ico])
        )
    )
    (defun DPTF|C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal)
        @doc "Transmutes a DPTF Token. Transmuting behaves follows the same mechanics of a DPTF Fee Processing \
        \ without counting as DPTF Fee in the DPTF Fee Counter"
        (let
            (
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-P|TFT::C_Transmute patron id transmuter transmute-amount)
                    )
                )
            )
            (XC_IgnisCollect patron transmuter [ico])
        )
    )
    (defun DPTF|C_Wipe (patron:string id:string atbw:string)
        @doc "Wipes a DPTF Token from a given account in its entirety \
        \ Only works for positive existing amounts"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_Wipe patron id atbw)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPTF::UR_Konto id) [ico])
        )
    )
    (defun DPTF|C_WipePartial (patron:string id:string atbw:string amtbw:decimal)
        @doc "Similar to <DPTF|C_Wipe>, but doesnt wipe the whole existing amount"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPTF::C_WipePartial patron id atbw amtbw)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPTF::UR_Konto id) [ico])
        )
    )
    ;;{DPMF_Client}
    (defun DPMF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for DPMF Token <entity-id> costing 150 IGNIS"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPMF::C_UpdatePendingBranding patron entity-id logo description website social)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPMF::UR_Konto entity-id) [ico])
        )
    )
    (defun DPMF|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|SECURE-SUMMONER)
                (ref-DPMF::C_UpgradeBranding patron entity-id months)
                (XI_DynamicFuelKDA)
            )
        )
    )
    ;;
    (defun DPMF|C_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPMF::C_AddQuantity patron id nonce account amount)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
        )
    )
    (defun DPMF|C_Burn (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPMF::C_Burn patron id nonce account amount)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
        )
    )
    (defun DPMF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool)
        @doc "Similar to its DPTF Variant, has an extra boolean trigger for <can-transfer-nft-create-role>"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPMF::C_Control patron id cco cu casr cf cw cp ctncr)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPMF::UR_Konto id) [ico])
        )
    )
    (defun DPMF|C_Create:integer (patron:string id:string account:string meta-data:[object])
        @doc "Creates a DPMF Token (id must already be issued), only creating a new DPMF nonce, without adding quantity"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPMF::C_Create patron id account meta-data)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
            (at 0 (at "output" ico))
        )
    )
    (defun DPMF|C_DeployAccount (id:string account:string)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_DeployAccount id account)
            )
        )
    )
    (defun DPMF|C_Issue:list (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        @doc "Similar to its DPTF Variant"
        (with-capability (P|SECURE-SUMMONER)
            (let
                (
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-DPMF::C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role)
                    )
                )
                (XC_IgnisCollect patron account [ico])
                (XI_DynamicFuelKDA)
                (at "output" ico)
            )
        )
    )
    (defun DPMF|C_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object])
        @doc "Mints a DPMF Token, creating it and adding quantity to it \
        \ Outputs the nonce of the created DPMF"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPMF::C_Mint patron id account amount meta-data)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
            (at 0 (at "output" ico))
        )
    )
    (defun DPMF|C_MoveCreateRole (patron:string id:string receiver:string)
        @doc "Moves <create-role> for a DPMF Token <id> to <receiver> \
        \ Only a single account may have this role"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ref-ATS:module{Autostake} ATS)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-ATS::DPMF|C_MoveCreateRole patron id receiver)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPMF::UR_Konto id) ico)
        )
    )
    (defun DPMF|C_MultiBatchTransfer (patron:string id:string nonces:[integer] sender:string receiver:string method:bool)
        @doc "Executes a MultiBatch transfer, transfering multiple DPMF nonces in single function"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-DPMF::C_MultiBatchTransfer patron id nonces sender receiver method)
                    )
                )
            )
            (XC_IgnisCollect patron sender ico)
        )
    )
    (defun DPMF|C_RotateOwnership (patron:string id:string new-owner:string)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPMF::C_RotateOwnership patron id new-owner)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPMF::UR_Konto id) ico)
        )
    )
    (defun DPMF|C_SingleBatchTransfer (patron:string id:string nonce:integer sender:string receiver:string method:bool)
        @doc "Executes a single Batch Transfer, transfering the whole nonce amount"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPMF::C_SingleBatchTransfer patron id nonce sender receiver method)
                    )
                )
            )
            (XC_IgnisCollect patron sender [ico])
        )
    )
    (defun DPMF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <add-quantity-role> for a DPMF Token <id> on a specific <account>"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-ATS::DPMF|C_ToggleAddQuantityRole patron id account toggle)
                    )
                )
            )
            (XC_IgnisCollect patron account ico)
        )
    )
    (defun DPMF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <burn-role> for a DPMF Token <id> on a specific <account>"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-ATS::DPMF|C_ToggleBurnRole patron id account toggle)
                    )
                )
            )
            (XC_IgnisCollect patron account ico)
        )
    )
    (defun DPMF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPMF::C_ToggleFreezeAccount patron id account toggle)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
        )
    )
    (defun DPMF|C_TogglePause (patron:string id:string toggle:bool)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPMF::C_TogglePause patron id toggle)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPMF::UR_Konto id) ico)
        )
    )
    (defun DPMF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPMF::C_ToggleTransferRole patron id account toggle)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
        )
    )
    (defun DPMF|C_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Transfers a DPMF Token, trasnfering an amount smaller than or equal to DPMF nonce amount"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPMF::C_Transfer patron id nonce sender receiver transfer-amount method)
                    )
                )
            )
            (XC_IgnisCollect patron sender [ico])
        )
    )
    (defun DPMF|C_Wipe (patron:string id:string atbw:string)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPMF::C_Wipe patron id atbw)
                    )
                )
            )
            (XC_IgnisCollect patron atbw [ico])
        )
    )
    (defun DPMF|C_WipePartial (patron:string id:string atbw:string nonces:[integer])
        @doc "Similar to <DPMF|C_Wipe>, but only wipes selected nonces"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-DPMF::C_WipePartial patron id atbw)
                    )
                )
            )
            (XC_IgnisCollect patron atbw [ico])
        )
    )
    ;;{ATS_Client}
    (defun ATS|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for ATSPair <entity-id> costing 500 IGNIS"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATS::C_UpdatePendingBranding patron entity-id logo description website social)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto entity-id) [ico])
        )
    )
    (defun ATS|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Similar to its DPTF, DPMF Variants"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|SECURE-SUMMONER)
                (ref-ATS::C_UpgradeBranding patron entity-id months)
                (XI_DynamicFuelKDA)
            )
        )
    )
    ;;
    (defun ATS|C_AddHotRBT (patron:string ats:string hot-rbt:string)
        @doc "Adds a Hot-RBT to an ATS-Pair \
        \ Must be a DPMF Token and cannot be a Vested counterpart of a DPTF Token"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_AddHotRBT patron ats hot-rbt)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
        )
    )
    (defun ATS|C_AddSecondary (patron:string ats:string reward-token:string rt-nfr:bool)
        @doc "Adds a Secondary RT to an ATSPair"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_AddSecondary patron ats reward-token rt-nfr)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
        )
    )
    (defun ATS|C_Coil:decimal (patron:string coiler:string ats:string rt:string amount:decimal)
        @doc "Coils an RT Token from a specific ATSPair, generating a RBT Token"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_Coil patron coiler ats rt amount)
                    )
                )
            )
            (XC_IgnisCollect patron coiler [ico])
            (at 0 (at "output" ico))
        )
    )
    (defun ATS|C_ColdRecovery (patron:string recoverer:string ats:string ra:decimal)
        @doc "Recovers Cold-RBT, disolving it, generating cullable RTs in the future."
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_ColdRecovery patron recoverer ats ra)
                    )
                )
            )
            (XC_IgnisCollect patron recoverer [ico])
        )
    )
    (defun ATS|C_Cull:[decimal] (patron:string culler:string ats:string)
        @doc "Culls an ATSPair, extracting RTs that are cullable"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_Cull patron culler ats)
                    )
                )
            )
            (XC_IgnisCollect patron culler [ico])
            (at "output" ico)
        )
    )
    (defun ATS|C_Curl:decimal (patron:string curler:string ats1:string ats2:string rt:string amount:decimal)
        @doc "Curls an RT Token from a specific ATSPair, and the subsequent generated RBT Token, is curled again in a second ATSPair, \
            \ outputing the RBT in from this second ATSPair. Works only if the RBT in the first ATSPair is RT in the second ATSPair"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_Curl patron curler ats1 ats2 rt amount)
                    )
                )
            )
            (XC_IgnisCollect patron curler [ico])
            (at 0 (at "output" ico))
        )
    )
    (defun ATS|C_Fuel (patron:string fueler:string ats:string reward-token:string amount:decimal)
        @doc "Fuels an ATSPair with RT Tokens, increasing its Index"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_Fuel patron fueler ats reward-token amount)
                    )
                )
            )
            (XC_IgnisCollect patron fueler [ico])
        )
    )
    (defun ATS|C_HotRecovery (patron:string recoverer:string ats:string ra:decimal)
        @doc "Converts a Cold-RBT to a Hot-RBT, preparing it for Hot Recovery"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_HotRecovery patron recoverer ats ra)
                    )
                )
            )
            (XC_IgnisCollect patron recoverer [ico])
        )
    )
    (defun ATS|C_Issue:list (patron:string account:string ats:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string] rbt-nfr:[bool])
        @doc "Issues and Autostake Pair"
        (with-capability (P|SECURE-SUMMONER)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-ATS::C_Issue patron account ats index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr)
                    )
                )
                (XC_IgnisCollect patron account [ico])
                (XI_DynamicFuelKDA)
                (at "output" ico)
            )
        )
    )
    (defun ATS|C_KickStart:decimal (patron:string kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal)
        @doc "Kickstarst an ATSPair, so that it starts at a given Index \
            \ Can only be done on a freshly created ATSPair"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_KickStart patron kickstarter ats rt-amounts rbt-request-amount)
                    )
                )
            )
            (XC_IgnisCollect patron kickstarter [ico])
            (at 0 (at "output" ico))
        )
    )
    (defun ATS|C_ModifyCanChangeOwner (patron:string ats:string new-boolean:bool)
        @doc "Modifies <can-change-owner> for the ATSPair"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_ModifyCanChangeOwner patron ats new-boolean)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
        )
    )
    (defun ATS|C_RecoverHotRBT (patron:string recoverer:string id:string nonce:integer amount:decimal)
        @doc "Recovers a Hot-RBT, converting back to Cold-RBT, \
            \ using an amount smaller than or equal to DPMF Nonce amount"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_RecoverHotRBT patron recoverer id nonce amount)
                    )
                )
            )
            (XC_IgnisCollect patron recoverer [ico])
        )
    )
    (defun ATS|C_RecoverWholeRBTBatch (patron:string recoverer:string id:string nonce:integer)
        @doc "Recovers a Hot-RBT, converting back to Cold-RBT, \
            \ using the whole DPMF nonce amount"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_RecoverWholeRBTBatch patron recoverer id nonce)
                    )
                )
            )
            (XC_IgnisCollect patron recoverer [ico])
        )
    )
    (defun ATS|C_Redeem (patron:string redeemer:string id:string nonce:integer)
        @doc "Redeems a Hot-RBT, recovering RTs"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_Redeem patron redeemer id nonce)
                    )
                )
            )
            (XC_IgnisCollect patron redeemer [ico])
        )
    )
    (defun ATS|C_RemoveSecondary (patron:string remover:string ats:string reward-token:string)
        @doc "Removes a Secondary RT from an ATSPair. \
            \ Only secondary RTs that were added after ATSPair creation can be removed. \
            \ Removing an RT this way must be done by adding the primary RT back into the Pool."
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_RemoveSecondary patron remover ats reward-token)
                    )
                )
            )
            (XC_IgnisCollect patron remover [ico])
        )
    )
    (defun ATS|C_RotateOwnership (patron:string ats:string new-owner:string)
        @doc "Rotates ATSPair Ownership"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_RotateOwnership patron ats new-owner)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
        )
    )
    (defun ATS|C_SetColdFee (patron:string ats:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        @doc "Sets ATSPair Cold Recovery Fee"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_SetColdFee patron ats fee-positions fee-thresholds fee-array)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
        )
    )
    (defun ATS|C_SetCRD (patron:string ats:string soft-or-hard:bool base:integer growth:integer)
        @doc "Sets ATSPair Cold Recovery Duration"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_SetCRD patron ats soft-or-hard base growth)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
        )
    )
    (defun ATS|C_SetHotFee (patron:string ats:string promile:decimal decay:integer)
        @doc "Sets ATSPair Hot Recovery Fee"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_SetHotFee patron ats promile decay)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
        )
    )
    (defun ATS|C_Syphon (patron:string syphon-target:string ats:string syphon-amounts:[decimal])
        @doc "Syphons from an ATS Pair, extracting RTs and decreasing ATSPair Index. \
            \ Syphoning can be executed until the set up Syphon limit is achieved"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_Syphon patron syphon-target ats syphon-amounts)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
        )
    )
    (defun ATS|C_ToggleElite (patron:string ats:string toggle:bool)
        @doc "Toggles ATSPair Elite Functionality"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_ToggleElite patron ats toggle)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
        )
    )
    (defun ATS|C_ToggleFeeSettings (patron:string ats:string toggle:bool fee-switch:integer)
        @doc "Toggles ATSPair Fee Settings"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATS::C_ToggleFeeSettings patron ats toggle fee-switch)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
        )
    )
    (defun ATS|C_ToggleParameterLock (patron:string ats:string toggle:bool)
        @doc "Toggle ATSPair Parameter Lock"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_ToggleParameterLock patron ats toggle)
                    )
                )
                (collect:bool (at 0 (at "output" ico)))
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
            (with-capability (SECURE)
                (XI_ConditionalFuelKDA collect)
            )
        )
    )
    (defun ATS|C_ToggleSyphoning (patron:string ats:string toggle:bool)
        @doc "Toggles ATSPair syphoning capability"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_ToggleSyphoning patron ats toggle)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
        )
    )
    (defun ATS|C_TurnRecoveryOff (patron:string ats:string cold-or-hot:bool)
        @doc "Turns ATSPair Recovery off"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATS::C_TurnRecoveryOff patron ats cold-or-hot)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
        )
    )
    (defun ATS|C_TurnRecoveryOn (patron:string ats:string cold-or-hot:bool)
        @doc "Turns ATSPair Cold or Hot Recovery On"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_TurnRecoveryOn patron ats cold-or-hot)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
        )
    )
    (defun ATS|C_UpdateSyphon (patron:string ats:string syphon:decimal)
        @doc "Updates Syphone Value, the decimal ATS-Index, until the ATSPair can be syphoned"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ATSU::C_UpdateSyphon patron ats syphon)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
        )
    )
    ;;{VST_Client}
    (defun VST|C_CreateFrozenLink:string (patron:string dptf:string)
        (with-capability (P|SECURE-SUMMONER)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-VST:module{Vesting} VST)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-VST::C_CreateFrozenLink patron dptf)
                    )
                )
                (XC_IgnisCollect patron (ref-DPTF::UR_Konto dptf) [ico])
                (XI_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun VST|C_CreateReservationLink:string (patron:string dptf:string)
        (with-capability (P|SECURE-SUMMONER)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-VST:module{Vesting} VST)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-VST::C_CreateReservationLink patron dptf)
                    )
                )
                (XC_IgnisCollect patron (ref-DPTF::UR_Konto dptf) [ico])
                (XI_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun VST|C_CreateVestingLink:string (patron:string dptf:string)
        (with-capability (P|SECURE-SUMMONER)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-VST:module{Vesting} VST)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-VST::C_CreateVestingLink patron dptf)
                    )
                )
                (XC_IgnisCollect patron (ref-DPTF::UR_Konto dptf) [ico])
                (XI_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun VST|C_CreateSleepingLink:string (patron:string dptf:string)
        (with-capability (P|SECURE-SUMMONER)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-VST:module{Vesting} VST)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-VST::C_CreateSleepingLink patron dptf)
                    )
                )
                (XC_IgnisCollect patron (ref-DPTF::UR_Konto dptf) [ico])
                (XI_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    ;;Freezing
    (defun VST|C_Freeze (patron:string freezer:string freeze-output:string dptf:string amount:decimal)
        @doc "Freezes a DPTF Token"
        (let
            (
                (ref-VST:module{Vesting} VST)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-VST::C_Freeze patron freezer freeze-output dptf amount)
                    )
                )
            )
            (XC_IgnisCollect patron freezer ico)
        )
    )
    (defun VST|C_RepurposeFrozen (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        @doc "Repurposes a Frozen DPTF to another account"
        (let
            (
                (ref-VST:module{Vesting} VST)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-VST::C_RepurposeFrozen patron dptf-to-repurpose repurpose-from repurpose-to)
                    )
                )
            )
            (XC_IgnisCollect patron repurpose-from ico)
        )
    )
    ;;Reserving
    (defun VST|C_Reserve (patron:string reserver:string dptf:string amount:decimal)
        @doc "Reserves a DPTF Token"
        (let
            (
                (ref-VST:module{Vesting} VST)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-VST::C_Reserve patron reserver dptf amount)
                    )
                )
            )
            (XC_IgnisCollect patron reserver ico)
        )
    )
    (defun VST|C_Unreserve (patron:string unreserver:string r-dptf:string amount:decimal)
        @doc "Unreserves a DPTF Token"
        (let
            (
                (ref-VST:module{Vesting} VST)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-VST::C_Unreserve patron unreserver r-dptf amount)
                    )
                )
            )
            (XC_IgnisCollect patron unreserver ico)
        )
    )
    (defun VST|C_RepurposeReserved (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        @doc "Repurposes a Reserved DPTF to another account"
        (let
            (
                (ref-VST:module{Vesting} VST)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-VST::C_RepurposeReserved patron dptf-to-repurpose repurpose-from repurpose-to)
                    )
                )
            )
            (XC_IgnisCollect patron repurpose-from ico)
        )
    )
    ;;Vesting
    (defun VST|C_Unvest (patron:string culler:string dpmf:string nonce:integer)
        @doc "Culls the Vested DPMF Token, recovering its DPTF counterpart."
        (let
            (
                (ref-VST:module{Vesting} VST)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-VST::C_Unvest patron culler dpmf nonce)
                    )
                )
            )
            (XC_IgnisCollect patron culler ico)
        )
    )
    (defun VST|C_Vest (patron:string vester:string target-account:string dptf:string amount:decimal offset:integer duration:integer milestones:integer)
        @doc "Vests a DPTF Token, generating ist Vested DPMF Counterspart"
        (let
            (
                (ref-VST:module{Vesting} VST)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-VST::C_Vest patron vester target-account dptf amount offset duration milestones)
                    )
                )
            )
            (XC_IgnisCollect patron vester ico)
        )
    )
    (defun VST|C_RepurposeVested (patron:string dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        @doc "Repurposes a Vested DPMF to another account"
        (let
            (
                (ref-VST:module{Vesting} VST)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-VST::C_RepurposeVested patron dpmf-to-repurpose nonce repurpose-from repurpose-to)
                    )
                )
            )
            (XC_IgnisCollect patron repurpose-from ico)
        )
    )
    (defun VST|C_CoilAndVest:decimal (patron:string coiler-vester:string ats:string coil-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        @doc "Coils a DPTF Token and Vests its output to <target-account> \
            \ Requires that: \
            \ *]Input DPTF is part of an ATSPair, the <ats> \
            \ *]That the Cold-RBT of <ats> has a vested counterpart \
            \ \
            \ Outputs the resulted Vested Cold-RBT Amount"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ref-VST:module{Vesting} VST)
                (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                (c-rbt-amount:decimal (ref-ATS::URC_RBT ats coil-token amount))
                (ico1:object{OuronetDalos.IgnisCumulator}
                    (ref-ATSU::C_Coil patron coiler-vester ats coil-token amount)
                )
                (ico2:object{OuronetDalos.IgnisCumulator}
                    (ref-VST::C_Vest patron coiler-vester target-account c-rbt c-rbt-amount offset duration milestones)
                )
                (end-ico:object{OuronetDalos.IgnisCumulator}
                    (ref-DALOS::UDC_CompressICO [ico1 ico2] [])
                )
            )
            (XC_IgnisCollect patron coiler-vester [end-ico])
            c-rbt-amount
        )
    )
    (defun VST|C_CurlAndVest:decimal (patron:string curler-vester:string ats1:string ats2:string curl-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        @doc "Same as <VST|C_CoilAndVest> but instead Curls the input Token. \
            \ Requires that : \
            \ *]Input DPTF is part of an ATSPair, the <ats1> \
            \ *]That the Cold-RBT Token of the <ats1> is RT in <ats2> \
            \ *]That Cold-RBT of <ats2> has a vested counterpat \
            \ \
            \ Outputs the resulted Vested Cold-RBT of <ats2>"
        (let*
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ref-VST:module{Vesting} VST)
                (c-rbt1:string (ref-ATS::UR_ColdRewardBearingToken ats1))
                (c-rbt1-amount:decimal (ref-ATS::URC_RBT ats1 curl-token amount))
                (c-rbt2:string (ref-ATS::UR_ColdRewardBearingToken ats2))
                (c-rbt2-amount:decimal (ref-ATS::URC_RBT ats2 c-rbt1 c-rbt1-amount))
                (ico1:object{OuronetDalos.IgnisCumulator}
                    (ref-ATSU::C_Curl patron curler-vester ats1 ats2 curl-token amount)
                )
                (ico2:object{OuronetDalos.IgnisCumulator}
                    (ref-VST::C_Vest patron curler-vester target-account c-rbt2 c-rbt2-amount offset duration milestones)
                )
                (end-ico:object{OuronetDalos.IgnisCumulator}
                    (ref-DALOS::UDC_CompressICO [ico1 ico2] [])
                )
            )
            (XC_IgnisCollect patron curler-vester [end-ico])
            c-rbt2-amount
        )
    )
    ;;Sleeping
    (defun VST|C_Merge(patron:string merger:string dpmf:string nonces:[integer])
        @doc "Merges selected sleeping Tokens of an account, \
        \ releasing them if expired sleeping dpmfs exist within the selected tokens \
        \ Up to 30 existing Batches can be merged this way."

        (let
            (
                (ref-VST:module{Vesting} VST)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-VST::C_Merge patron merger dpmf nonces)
                    )
                )
            )
            (XC_IgnisCollect patron merger ico)
        )
    )
    (defun VST|C_MergeAll(patron:string merger:string dpmf:string)
        @doc "Merges all sleeping Tokens of an account, \
        \ releasing them if expired sleeping dpmfs exist on account \
        \ Up to 30 existing Batches can be merged this way \
        \ If more than 35 Batches exist on <merger>, <VST|C_Merge> must be used to merge individual batches,\
        \ to reduce their number, such that mergim them all can fit within a single TX."

        (let
            (
                (ref-VST:module{Vesting} VST)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-VST::C_MergeAll patron merger dpmf)
                    )
                )
            )
            (XC_IgnisCollect patron merger ico)
        )
    )
    (defun VST|C_Sleep (patron:string sleeper:string target-account:string dptf:string amount:decimal duration:integer)
        @doc "Sleeps a DPTF Token, generating ist Sleeping DPMF Counterspart"
        (let
            (
                (ref-VST:module{Vesting} VST)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-VST::C_Sleep patron sleeper target-account dptf amount duration)
                    )
                )
            )
            (XC_IgnisCollect patron sleeper ico)
        )
    )
    (defun VST|C_Unsleep (patron:string unsleeper:string dpmf:string nonce:integer)
        @doc "Culls the Sleeping DPMF Token, recovering its DPTF counterpart."
        (let
            (
                (ref-VST:module{Vesting} VST)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-VST::C_Unsleep patron unsleeper dpmf nonce)
                    )
                )
            )
            (XC_IgnisCollect patron unsleeper ico)
        )
    )
    (defun VST|C_RepurposeSleeping (patron:string dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        @doc "Repurposes a single Sleeping DPMF from <repurpose-from> to <repurpose-to>"
        (let
            (
                (ref-VST:module{Vesting} VST)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-VST::C_RepurposeSleeping patron dpmf-to-repurpose nonce repurpose-from repurpose-to)
                    )
                )
            )
            (XC_IgnisCollect patron repurpose-from ico)
        )
    )
    (defun VST|C_RepurposeMerge (patron:string dpmf-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string)
        @doc "Repurposes multiple Sleeping DPMFs (up to 30) from <repurpose-from> to <repurpose-to>"
        (let
            (
                (ref-VST:module{Vesting} VST)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-VST::C_RepurposeMerge patron dpmf-to-repurpose nonces repurpose-from repurpose-to)
                    )
                )
            )
            (XC_IgnisCollect patron repurpose-from ico)
        )
    )
    (defun VST|C_RepurposeMergeAll (patron:string dpmf-to-repurpose:string repurpose-from:string repurpose-to:string)
        @doc "Repurposes all Sleeping DPMFs (up to 30, more wont fit in a tx) from <repurpose-from> to <repurpose-to>"
        (let
            (
                (ref-VST:module{Vesting} VST)
                (ico:[object{OuronetDalos.IgnisCumulator}]
                    (with-capability (P|TS)
                        (ref-VST::C_RepurposeMergeAll patron dpmf-to-repurpose repurpose-from repurpose-to)
                    )
                )
            )
            (XC_IgnisCollect patron repurpose-from ico)
        )
    )
    ;;{LIQUID_Client}
    (defun LQD|C_UnwrapKadena (patron:string unwrapper:string amount:decimal)
        @doc "Unwraps DPTF Kadena to Native Kadena"
        (let
            (
                (ref-LIQUID:module{KadenaLiquidStaking} LIQUID)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-LIQUID::C_UnwrapKadena patron unwrapper amount)
                    )
                )
            )
            (XC_IgnisCollect patron unwrapper [ico])
        )
    )
    (defun LQD|C_WrapKadena (patron:string wrapper:string amount:decimal)
        @doc "Wraps Native Kadena to DPTF Kadena"
        (let
            (
                (ref-LIQUID:module{KadenaLiquidStaking} LIQUID)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-LIQUID::C_WrapKadena patron wrapper amount)
                    )
                )
            )
            (XC_IgnisCollect patron wrapper [ico])
        )
    )
    ;;{OUROBOROS_Client}
    (defun ORBR|C_Compress:decimal (patron:string client:string ignis-amount:decimal)
        @doc "Compresses IGNIS - Ouronet Gas Token, generating OUROBOROS \
                \ Only whole IGNIS Amounts greater than or equal to 1.0 can be used for compression \
                \ Similar to Sublimation, the output amount is dependent on OUROBOROS price, set at a minimum of 1$ \
                \ Compression has 98.5% efficiency, 1.5% is lost as fees."
        (let
            (
                (ref-ORBR:module{Ouroboros} OUROBOROS)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ORBR::C_Compress patron client ignis-amount)
                    )
                )
            )
            (XC_IgnisCollect patron client [ico])
            (at 0 (at "output" ico))
        )
    )
    (defun ORBR|C_Sublimate:decimal (patron:string client:string target:string ouro-amount:decimal)
        @doc "Sublimates OUROBOROS, generating Ouronet Gas, in form of IGNIS Token \
                \ A minimum amount of 1 input OUROBOROS is required. Amount of IGNIS generated depends on OUROBOROS Price in $, \
                \ with the minimum value being set at 1$ (in case the actual value is lower than 1$ \
                \ Ignis is generated for 99% of the input Ouroboros amount, thus Sublimation has a fee of 1%"
        (let
            (
                (ref-ORBR:module{Ouroboros} OUROBOROS)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ORBR::C_Sublimate patron client target ouro-amount)
                    )
                )
            )
            (XC_IgnisCollect patron client [ico])
            (at 0 (at "output" ico))
        )
    )
    (defun ORBR|C_WithdrawFees (patron:string id:string target:string)
        @doc "Withdraws collected DPTF Fees collected in standard mode \
        \ DPTF Fees collected in standard mode cumullate on the OUROBOROS Smart Account \
        \ Only the Token Owner can withdraw these fees."
        (let
            (
                (ref-ORBR:module{Ouroboros} OUROBOROS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-ORBR::C_WithdrawFees patron id target)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-DPTF::UR_Konto id) [ico])
        )
    )
    ;;{Swapper_Client}
    (defun SWP|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for DPMF Token <entity-id> costing 400 IGNIS"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWP::C_UpdatePendingBranding patron entity-id logo description website social)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-SWP::UR_OwnerKonto entity-id) [ico])
        )
    )
    (defun SWP|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Similar to its DPTF, DPMF, ATS Variants"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (P|SECURE-SUMMONER)
                (ref-SWP::C_UpgradeBranding patron entity-id months)
                (XI_DynamicFuelKDA)
            )
        )
    )
    (defun SWP|C_ChangeOwnership (patron:string swpair:string new-owner:string)
        @doc "Changes Ownership of an SWPair"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWP::C_ChangeOwnership patron swpair new-owner)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) [ico])
        )
    )
    (defun SWP|C_IssueStable:list (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal amp:decimal p:bool)
        @doc "Issues a Stable Liquidity Pool. First Token in the liquidity Pool must have a connection to a principal Token \
        \ Stable Pools have the S designation. \
        \ Stable Pools can be created with up to 7 Tokens, and have by design equal weighting. \
        \ The <p> boolean defines if The Pool is a Principal Pools. \
        \ Principal Pools are always on, and cant be disabled by low-liquidity."
        (with-capability (P|SECURE-SUMMONER)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-SWPU:module{SwapperUsage} SWPU)
                    (ref-ORBR:module{Ouroboros} OUROBOROS)
                    (weights:[decimal] (make-list (length pool-tokens) 1.0))
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWPU::SWPI|C_Issue patron account pool-tokens fee-lp weights amp p)
                    )
                )
                (XC_IgnisCollect patron account [ico])
                (XI_DynamicFuelKDA)
                (at "output" ico)
            )
        ) 
    )
    (defun SWP|C_IssueStandard:list (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal p:bool)
        @doc "Issues a Standard, Constant Product Pool. \
            \ Constant Product Pools have the P Designation, and they are by design equal weigthed \
            \ Can also be created with up to 7 Tokens, also the <p> boolean determines if its a Principal Pool or not \
            \ The First Token must be a Principal Token"
        (SWP|C_IssueStable patron account pool-tokens fee-lp -1.0 p)
    )
    (defun SWP|C_IssueWeighted:list (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool)
        @doc "Issues a Weigthed Constant Liquidity Pool \
            \ Weigthed Pools have the W Designation, and the weights can be changed at will. \
            \ Can also be created with up to 7 Tokens, <p> boolean determines if its a Principal Pool or not \
            \ The First Token must also be a Principal Token"
        (with-capability (P|SECURE-SUMMONER)
            (let
                (
                    (ref-SWPU:module{SwapperUsage} SWPU)
                    (ref-ORBR:module{Ouroboros} OUROBOROS)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWPU::SWPI|C_Issue patron account pool-tokens fee-lp weights -1.0 p)
                    )
                )
                (XC_IgnisCollect patron account [ico])
                (XI_DynamicFuelKDA)
                (at "output" ico)
            )          
        )
    )
    (defun SWP|C_IssueStableMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal amp:decimal p:bool)
        @doc "Similar outcome to <SWP|C_IssueStable>, but over 3 <steps> (0|1|2) via <defpact> \
            \ Calling this function runs the Step 0 of 2. To finalize SWPair creation, Steps 1 and 2 must also be executed \
            \ \
            \ Step 0: Data Validation, makes sure the input data is correct for SWPair Creation \
            \ Step 1: Collects IGNIS, KDA, and fuels LiquidStaking Index with collected KDA \
            \ Step 2: Executes the actual Pool Creation, Issuing the LP Token, Creating the SWPair, minting the LP Token Supply \
            \   transfering it to its creator, and saves all other relevant data when a Pool Creation takes place"
        (let
            (
                (ref-SWPU:module{SwapperUsage} SWPU)
            )
            (with-capability (P|TS)
                (ref-SWPU::SWPI|C_IssueStableMultiStep patron account pool-tokens fee-lp amp p)
            )
        )
    )
    (defun SWP|C_IssueStandardMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal p:bool)
        @doc "Similar to <SWP|C_IssueStableMultiStep>, but issues a P (Standard) Pool"
        (let
            (
                (ref-SWPU:module{SwapperUsage} SWPU)
            )
            (with-capability (P|TS)
                (ref-SWPU::SWPI|C_IssueStandardMultiStep patron account pool-tokens fee-lp p)
            )
        )
    )
    (defun SWP|C_IssueWeightedMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool)
        @doc "Similar to <SWP|C_IssueStableMultiStep>, but issues a W (Weighted) Pool"
        (let
            (
                (ref-SWPU:module{SwapperUsage} SWPU)
            )
            (with-capability (P|TS)
                (ref-SWPU::SWPI|C_IssueWeightedMultiStep patron account pool-tokens fee-lp weights p)
            )
        )
    )
    (defun SWP|C_ModifyCanChangeOwner (patron:string swpair:string new-boolean:bool)
        @doc "Modifies the <can-change-owner> parameter of an SWPair"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWP::C_ModifyCanChangeOwner patron swpair new-boolean)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) [ico])
        )
    )
    (defun SWP|C_ModifyWeights (patron:string swpair:string new-weights:[decimal])
        @doc "Modify weights for an SWPair. Works only for W Pools"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWP::C_ModifyWeights patron swpair new-weights)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) [ico])
        )
    )
    (defun SWP|C_ToggleAddLiquidity (patron:string swpair:string toggle:bool)
        @doc "Toggle on or off the Functionality of adding liquidity for an <swpair> \
            \ When <toggle> is <true>, ensures required Mint, Burn, Transfer Roles are set, if not, set them. \
            \ The Roles are: \
            \ Mint and Burn Roles for LP Token (requires LP Token Ownership) \
            \ Fee Exemption Roles for all Tokens of an S-Pool, or \
            \ for all Tokens of a W- or P-Pool, except its first Token (which is principal) \
            \ Roles are needed to SWP|SC_NAME \
            \ \
            \ Requires <swpair> ownership"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
                (ref-SWPU:module{SwapperUsage} SWPU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWPU::C_ToggleAddLiquidity patron swpair toggle)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) [ico])
        )
    )
    (defun SWP|C_ToggleSwapCapability (patron:string swpair:string toggle:bool)
        @doc "Toggle on or off the Functionality of swapping for an <swpair> \
            \ When <toggle> is <true>, same setup for roles is executed as for <SWP|C_ToggleAddLiquidity> \
            \ \
            \ <On> Toggle can only be executed is <swpair> surpasses <(ref-SWP::UR_InactiveLimit)> \
            \ \
            \ Requires <swpair> ownership"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
                (ref-SWPU:module{SwapperUsage} SWPU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWPU::C_ToggleSwapCapability patron swpair toggle)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) [ico])
        )
    )
    (defun SWP|C_ToggleFeeLock (patron:string swpair:string toggle:bool)
        @doc "Locks the SPWPair fees in place. Modifying the SWPair fees requires them to be unlocked \
            \ Unlocking costs KDA and is financially discouraged"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWP::C_ToggleFeeLock patron swpair toggle)
                    )
                )
                (collect:bool (at 0 (at "output" ico)))
            )
            (XC_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) [ico])
            (with-capability (SECURE)
                (XI_ConditionalFuelKDA collect)
            )
        )
    )
    (defun SWP|C_UpdateAmplifier (patron:string swpair:string amp:decimal)
        @doc "Updates Amplifier Value; Only works on S-Pools (Stable Pools)"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWP::C_UpdateAmplifier patron swpair amp)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) [ico])
        )
    )
    (defun SWP|C_UpdateFee (patron:string swpair:string new-fee:decimal lp-or-special:bool)
        @doc "Updates Fees Values for an SWPair \
            \ The <lp-or-special> boolesn defines whether its the LP-Fee or Special-Fee that is changed \
            \ THe LP Fee is the amount of Swap Output kept by the Liquidity Pool, increasing the Value of its LP Token(s) \
            \ The Special-Fee is the Fee that is collected to the Special-Fee-Targets \
            \ The Fee must be between 0.0001 - 320.0 (promile, that would be 32%) \
            \ When <liquid-boost>, an universal SWP Parameter (that can be set only by the admin) is set to true \
            \   an amount equal to the LP-Fee is also used to boost the Liquid Kadena Index \
            \   which is why the fee must be capped at close a third of 100% (320 promile in this case)"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWP::C_UpdateFee patron swpair new-fee lp-or-special)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) [ico])
        )
    )
    (defun SWP|C_UpdateSpecialFeeTargets (patron:string swpair:string targets:[object{Swapper.FeeSplit}])
        @doc "Updates the Special Fee Targets, along with their Split, for an SWPair"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWP::C_UpdateSpecialFeeTargets patron swpair targets)
                    )
                )
            )
            (XC_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) [ico])
        )
    )
    ;;
    (defun SWP|C_AddBalancedLiquidity:decimal (patron:string account:string swpair:string input-id:string input-amount:decimal)
        @doc "Using input only an <input-id> and its <input-amount> \
            \ Adds Liquidity in a balanced mode, on the <swpair>"
        (let
            (
                (ref-SWPU:module{SwapperUsage} SWPU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWPU::SWPL|C_AddBalancedLiquidity patron account swpair input-id input-amount)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
            (at 0 (at "output" ico))
        )
    )
    (defun SWP|C_AddLiquidity:decimal (patron:string account:string swpair:string input-amounts:[decimal])
        @doc "Using custom <input-amounts>, add liquidity on the <swpair> \
            \ Can be used to add both asymetric and balanced liquidity \
            \ For Tokens that arent used, the decimal value must be set at 0.0 \
            \ The order of the values in <input-amounts> must correspond to the Pool Token order, \
            \ as this determines how much liquidity for which token is added \
            \ \
            \ Liquidity can also be added on an otherwise completely empty Liquidty Pool \
            \ In this case, the original Token Ratios are used, the SWPair was created with."
        (let
            (
                (ref-SWPU:module{SwapperUsage} SWPU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWPU::SWPL|C_AddLiquidity patron account swpair input-amounts)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
            (at 0 (at "output" ico))
        )
    )
    (defun SWP|C_RemoveLiquidity:list (patron:string account:string swpair:string lp-amount:decimal)
        @doc "Removes Liquidity from a Liquidity Pool \
            \ Removing Liquidty is always done at the current Token Ratio. \
            \ Removing Liquidty complety leaving the pool exactly empty (0.0 tokens) is fully supported"
        (let
            (
                (ref-SWPU:module{SwapperUsage} SWPU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWPU::SWPL|C_RemoveLiquidity patron account swpair lp-amount)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
            (at "output" ico)
        )
    )
    (defun SWP|C_MultiSwap
        (
            patron:string
            account:string
            swpair:string
            input-ids:[string]
            input-amounts:[decimal]
            output-id:string
            slippage:object{SwapperUsage.Slippage}
        )
        @doc "Executes a Swap between one or multiple input tokens to an output token, on an <swpair> \
            \ Up to <n-1> input ids can be used for a swap, where <n> is the number of pool Tokens"
        (let
            (
                (ref-SWPU:module{SwapperUsage} SWPU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWPU::SWPS|C_MultiSwap patron account swpair input-ids input-amounts output-id slippage)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
            (at 0 (at "output" ico))
        )
    )
    (defun SWP|C_MultiSwapNoSlippage
        (
            patron:string
            account:string
            swpair:string
            input-ids:[string]
            input-amounts:[decimal]
            output-id:string
        )
        @doc "Same as <SWP|C_MultiSwap>, but with no Slippage Protection"
        (let
            (
                (ref-SWPU:module{SwapperUsage} SWPU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWPU::SWPS|C_MultiSwapNoSlippage patron account swpair input-ids input-amounts output-id)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
            (at 0 (at "output" ico))
        )
    )
    (defun SWP|C_SimpleSwap
        (
            patron:string
            account:string
            swpair:string
            input-id:string
            input-amount:decimal
            output-id:string
            slippage:object{SwapperUsage.Slippage}
        )
        @doc "Executes a Swap from one Token to Another Token, unsing the input <swpair>"
        (let
            (
                (ref-SWPU:module{SwapperUsage} SWPU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWPU::SWPS|C_SimpleSwap patron account swpair input-id input-amount output-id slippage)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
            (at 0 (at "output" ico))
        )
    )
    (defun SWP|C_SimpleSwapNoSlippage
        (
            patron:string
            account:string
            swpair:string
            input-id:string
            input-amount:decimal
            output-id:string
        )
        @doc "Same as <SWP|C_SimpleSwap>, but with no Slippage Protection"
        (let
            (
                (ref-SWPU:module{SwapperUsage} SWPU)
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (P|TS)
                        (ref-SWPU::SWPS|C_SimpleSwapNoSlippage patron account swpair input-id input-amount output-id)
                    )
                )
            )
            (XC_IgnisCollect patron account [ico])
            (at 0 (at "output" ico))
        )
    )
    ;;
    (defun XC_IgnisCollect (patron:string account:string input-ico:[object{OuronetDalos.IgnisCumulator}])
        @doc "Collects Ignis given input parameters"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ignis:decimal (ref-DALOS::UDC_AddICO input-ico))
            )
            (if (!= ignis 0.0)
                (ref-DALOS::IGNIS|C_Collect patron account ignis)
                true
            )
        )
    )
    (defun XI_DirectFuelKDA ()
        (require-capability (SECURE))
        (let
            (
                (ref-ORBR:module{Ouroboros} OUROBOROS)
            )
            (with-capability (P|GOVERNING-SUMMONER)
                (ref-ORBR::C_Fuel GASSLES-PATRON)
            )
        )
    )
    (defun XI_DynamicFuelKDA ()
        (require-capability (SECURE))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (auto-fuel:bool (ref-DALOS::UR_AutoFuel))
            )
            (if auto-fuel
                (with-capability (SECURE)
                    (XI_DirectFuelKDA)
                )
                true
            )
        )
    )
    (defun XI_ConditionalFuelKDA (condition:bool)
        (require-capability (SECURE))
        (if condition
            (with-capability (SECURE)
                (XI_DynamicFuelKDA)
            )
            true
        )
    )
)

(create-table P|T)
(create-table P|MT)