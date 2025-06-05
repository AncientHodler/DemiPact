(interface TalosStageOne_ClientTwoV3
    @doc "V2 Removes <patron> input variable where it is not needed \
        \ V3 brings the improved liquidity engine, two 2 liquidity addition types \
        \ and improved Swap Logistics"
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
    (defun SWP|C_AddLiquidity:string (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun SWP|C_AddIcedLiquidity:string (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun SWP|C_AddGlacialLiquidity:string (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun SWP|C_AddFrozenLiquidity:string (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal kda-pid:decimal))
    (defun SWP|C_AddSleepingLiquidity:string (patron:string account:string swpair:string sleeping-dpmf:string nonce:integer kda-pid:decimal))
    (defun SWP|C_RemoveLiquidity:list (patron:string account:string swpair:string lp-amount:decimal))
    ;;Swap
    (defun SWP|C_SingleSwapWithSlippage (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string slippage:decimal))
    (defun SWP|C_SingleSwapNoSlippage (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string))
    (defun SWP|C_MultiSwapWithSlippage (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:decimal))
    (defun SWP|C_MultiSwapNoSlippage (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string))
)
(module TS01-C2 GOV
    @doc "TALOS Administrator and Client Module for Stage 1"
    ;;
    (implements OuronetPolicy)
    (implements TalosStageOne_ClientTwoV3)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_TS01-C2        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TS01-C1_ADMIN)))
    (defcap GOV|TS01-C1_ADMIN ()    (enforce-guard GOV|MD_TS01-C2))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|TS ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (gap:bool (ref-DALOS::UR_GAP))
            )
            (enforce (not gap) "While Global Administrative Pause is online, no client Functions can be executed")
            (compose-capability (P|TALOS-SUMMONER))
        )
    )
    (defcap P|TALOS-SUMMONER ()
        @doc "Talos Summoner Capability"
        true
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|TS01-C1_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|TS01-C1_ADMIN)
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
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|ATSU:module{OuronetPolicy} ATSU)
                (ref-P|VST:module{OuronetPolicy} VST)
                (ref-P|LIQUID:module{OuronetPolicy} LIQUID)
                (ref-P|ORBR:module{OuronetPolicy} OUROBOROS)
                (ref-P|SWPT:module{OuronetPolicy} SWPT)
                (ref-P|SWP:module{OuronetPolicy} SWP)
                (ref-P|SWPI:module{OuronetPolicy} SWPI)
                (ref-P|SWPL:module{OuronetPolicy} SWPL)
                (ref-P|SWPU:module{OuronetPolicy} SWPU)
                (ref-P|TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                (mg:guard (create-capability-guard (P|TALOS-SUMMONER)))
            )
            (ref-P|ATS::P|A_AddIMP mg)
            (ref-P|ATSU::P|A_AddIMP mg)
            (ref-P|VST::P|A_AddIMP mg)
            (ref-P|LIQUID::P|A_AddIMP mg)
            (ref-P|ORBR::P|A_AddIMP mg)

            (ref-P|SWPT::P|A_AddIMP mg)
            (ref-P|SWP::P|A_AddIMP mg)
            (ref-P|SWPI::P|A_AddIMP mg)
            (ref-P|SWPL::P|A_AddIMP mg)
            (ref-P|SWPU::P|A_AddIMP mg)
            (ref-P|TS01-A::P|A_AddIMP mg)
        )
    )
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
            )
            (ref-U|G::UEV_Any (P|UR_IMP))
        )
    )
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    ;;{2}
    ;;{3}
    (defun CT_KdaPid ()             (let ((ref-U|CT|DIA:module{DiaKdaPid} U|CT)) (ref-U|CT|DIA::UR|KDA-PID)))
    (defconst KDAPID                (CT_KdaPid))
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
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;  [ATS_Client]
    (defun ATS|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for ATSPair <entity-id> costing 500 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-B|ATS:module{BrandingUsageV6} ATS)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-B|ATS::C_UpdatePendingBranding entity-id logo description website social)
                )
            )
        )
    )
    (defun ATS|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Similar to its DPTF, DPMF Variants"
        (with-capability (P|TS)
            (let
                (
                    (ref-B|ATS:module{BrandingUsageV6} ATS)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                )
                (ref-B|ATS::C_UpgradeBranding patron entity-id months)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    ;;
    (defun ATS|C_AddHotRBT (patron:string ats:string hot-rbt:string)
        @doc "Adds a Hot-RBT to an ATS-Pair \
        \ Must be a DPMF Token and cannot be a Vested counterpart of a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_AddHotRBT ats hot-rbt)
                )
            )
        )
    )
    (defun ATS|C_AddSecondary (patron:string ats:string reward-token:string rt-nfr:bool)
        @doc "Adds a Secondary RT to an ATSPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_AddSecondary ats reward-token rt-nfr)
                )
            )
        )
    )
    (defun ATS|C_Coil:decimal (patron:string coiler:string ats:string rt:string amount:decimal)
        @doc "Coils an RT Token from a specific ATSPair, generating a RBT Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-ATSU::C_Coil coiler ats rt amount)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun ATS|C_ColdRecovery (patron:string recoverer:string ats:string ra:decimal)
        @doc "Recovers Cold-RBT, disolving it, generating cullable RTs in the future."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_ColdRecovery recoverer ats ra)
                )
            )
        )
    )
    (defun ATS|C_Cull:[decimal] (patron:string culler:string ats:string)
        @doc "Culls an ATSPair, extracting RTs that are cullable"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-ATSU::C_Cull culler ats)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (at "output" ico)
            )
        )
    )
    (defun ATS|C_Curl:decimal (patron:string curler:string ats1:string ats2:string rt:string amount:decimal)
        @doc "Curls an RT Token from a specific ATSPair, and the subsequent generated RBT Token, is curled again in a second ATSPair, \
            \ outputing the RBT in from this second ATSPair. Works only if the RBT in the first ATSPair is RT in the second ATSPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-ATSU::C_Curl curler ats1 ats2 rt amount)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun ATS|C_Fuel (patron:string fueler:string ats:string reward-token:string amount:decimal)
        @doc "Fuels an ATSPair with RT Tokens, increasing its Index"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_Fuel fueler ats reward-token amount)
                )
            )
        )
    )
    (defun ATS|C_HotRecovery (patron:string recoverer:string ats:string ra:decimal)
        @doc "Converts a Cold-RBT to a Hot-RBT, preparing it for Hot Recovery"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_HotRecovery recoverer ats ra)
                )
            )
        )
    )
    (defun ATS|C_Issue:list (patron:string account:string ats:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string] rbt-nfr:[bool])
        @doc "Issues and Autostake Pair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATS:module{AutostakeV3} ATS)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-ATS::C_Issue patron account ats index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at "output" ico)
            )
        )
    )
    (defun ATS|C_KickStart:decimal (patron:string kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal)
        @doc "Kickstarst an ATSPair, so that it starts at a given Index \
            \ Can only be done on a freshly created ATSPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-ATSU::C_KickStart kickstarter ats rt-amounts rbt-request-amount)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun ATS|C_ModifyCanChangeOwner (patron:string ats:string new-boolean:bool)
        @doc "Modifies <can-change-owner> for the ATSPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_ModifyCanChangeOwner ats new-boolean)
                )
            )
        )
    )
    (defun ATS|C_RecoverHotRBT (patron:string recoverer:string id:string nonce:integer amount:decimal)
        @doc "Recovers a Hot-RBT, converting back to Cold-RBT, \
            \ using an amount smaller than or equal to DPMF Nonce amount"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_RecoverHotRBT recoverer id nonce amount)
                )
            )
        )
    )
    (defun ATS|C_RecoverWholeRBTBatch (patron:string recoverer:string id:string nonce:integer)
        @doc "Recovers a Hot-RBT, converting back to Cold-RBT, \
            \ using the whole DPMF nonce amount"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_RecoverWholeRBTBatch recoverer id nonce)
                )
            )
        )
    )
    (defun ATS|C_Redeem (patron:string redeemer:string id:string nonce:integer)
        @doc "Redeems a Hot-RBT, recovering RTs"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_Redeem redeemer id nonce)
                )
            )
        )
    )
    (defun ATS|C_RemoveSecondary (patron:string remover:string ats:string reward-token:string)
        @doc "Removes a Secondary RT from an ATSPair. \
            \ Only secondary RTs that were added after ATSPair creation can be removed. \
            \ Removing an RT this way must be done by adding the primary RT back into the Pool."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_RemoveSecondary remover ats reward-token)
                )
            )
        )
    )
    (defun ATS|C_RotateOwnership (patron:string ats:string new-owner:string)
        @doc "Rotates ATSPair Ownership"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_RotateOwnership ats new-owner)
                )
            )
        )
    )
    (defun ATS|C_SetColdFee (patron:string ats:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        @doc "Sets ATSPair Cold Recovery Fee"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_SetColdFee ats fee-positions fee-thresholds fee-array)
                )
            )
        )
    )
    (defun ATS|C_SetCRD (patron:string ats:string soft-or-hard:bool base:integer growth:integer)
        @doc "Sets ATSPair Cold Recovery Duration"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_SetCRD ats soft-or-hard base growth)
                )
            )
        )
    )
    (defun ATS|C_SetHotFee (patron:string ats:string promile:decimal decay:integer)
        @doc "Sets ATSPair Hot Recovery Fee"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_SetHotFee ats promile decay)
                )
            )
        )
    )
    (defun ATS|C_Syphon (patron:string syphon-target:string ats:string syphon-amounts:[decimal])
        @doc "Syphons from an ATS Pair, extracting RTs and decreasing ATSPair Index. \
            \ Syphoning can be executed until the set up Syphon limit is achieved"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_Syphon syphon-target ats syphon-amounts)
                )
            )
        )
    )
    (defun ATS|C_ToggleElite (patron:string ats:string toggle:bool)
        @doc "Toggles ATSPair Elite Functionality"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_ToggleElite ats toggle)
                )
            )
        )
    )
    (defun ATS|C_ToggleFeeSettings (patron:string ats:string toggle:bool fee-switch:integer)
        @doc "Toggles ATSPair Fee Settings"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATS:module{AutostakeV3} ATS)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATS::C_ToggleFeeSettings ats toggle fee-switch)
                )
            )
        )
    )
    (defun ATS|C_ToggleParameterLock (patron:string ats:string toggle:bool)
        @doc "Toggle ATSPair Parameter Lock"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-ATSU::C_ToggleParameterLock patron ats toggle)
                    )
                    (collect:bool (at 0 (at "output" ico)))
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XE_ConditionalFuelKDA collect)
            )
        )
    )
    (defun ATS|C_ToggleSyphoning (patron:string ats:string toggle:bool)
        @doc "Toggles ATSPair syphoning capability"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_ToggleSyphoning ats toggle)
                )
            )
        )
    )
    (defun ATS|C_TurnRecoveryOff (patron:string ats:string cold-or-hot:bool)
        @doc "Turns ATSPair Recovery off"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATS:module{AutostakeV3} ATS)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATS::C_TurnRecoveryOff ats cold-or-hot)
                )
            )
        )
    )
    (defun ATS|C_TurnRecoveryOn (patron:string ats:string cold-or-hot:bool)
        @doc "Turns ATSPair Cold or Hot Recovery On"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_TurnRecoveryOn ats cold-or-hot)
                )
            )
        )
    )
    (defun ATS|C_UpdateSyphon (patron:string ats:string syphon:decimal)
        @doc "Updates Syphone Value, the decimal ATS-Index, until the ATSPair can be syphoned"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATSU::C_UpdateSyphon ats syphon)
                )
            )
        )
    )
    ;;  [VST_Client]
    (defun VST|C_CreateFrozenLink:string (patron:string dptf:string)
        @doc "Creates a Frozen Link, issuing a Special-DPTF as a frozen counterpart for another DPTF \
            \ A Frozen Link is immutable, and noted in the Token Properties of both DPTFs \
            \ A Special DPTF of the Frozen variety, is used for implementing the FROZEN Functionality for a DPTF Token \
            \ So called FROZEN Tokens are meant to be frozen on the account holding them, and only be used by that account, \
            \ for specific purposes only, defined by the <dptf> owner, which is also the owner of the Frozen Token. \
            \ Frozen Tokens can never be converted back to the original <dptf> Token they were created from \
            \ \
            \ Only the <dptf> owner can create Frozen Tokens to Target Accounts, \
            \ or designate other Smart Ouronet Accounts to create them \
            \ \
            \ Frozen Tokens can be used to add Swpair Liquidity, as if they were the initial <dptf> token \
            \ This can be done, when this functionality is turned on for the Swpair, and using a Frozen Token for adding Liquidity \
            \ generates a Frozen LP Token, which behaves similarly to the Frozen Token \
            \ that is, it can never be converted back to the SWPairs native LP, locking liquidity in place \
            \ Existing LPs can also be frozen, permanently locking liquidity \
            \ \
            \ VESTA will be the first Token that will be making use of this functionality"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-VST::C_CreateFrozenLink patron dptf)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun VST|C_CreateReservationLink:string (patron:string dptf:string)
        @doc "Creates a Reservation Link, issuing a Special-DPTF as a reserved counterpart for another DPTF \
            \ A Reservation Link is immutable, and noted in the Token Properties of both DPTFs \
            \ A Special DPTF of the Reserved variety, is used for implementing the RESERVED Functionality for a DPTF Token \
            \ So called RESERVED Tokens are meant to be frozen on the account holding them, and only be used by that account, \
            \ for specific purposes only, defined by the <dptf> owner, which is also the owner of the Reserved Token. \
            \ Reserved Tokens can never be converted back to the original <dptf> Token they were created from \
            \ \
            \ As opposed to frozen tokens, where only the <dptf> owner can generate them or designated Ouronet Accounts, \
            \ Reserved Tokens can be generated by clients, using as input the <dptf> Token, only when reservations are open by the <dptf> owner \
            \ That is, the <dptf> owner dictates when clients can generate reserved tokens from the input <dptf>, \
            \ and as such, reserved tokens can be used for special discounts when sales are planned with the main <dptf> Token, \
            \ as if they were the main <dptf> token. \
            \ \
            \ Reserved Tokens cannot be used to add liquidty on any Swpair. \
            \ \
            \ OURO will be the first Token that will be making use of this functionality"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-VST::C_CreateReservationLink patron dptf)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun VST|C_CreateVestingLink:string (patron:string dptf:string)
        @doc "Creates a Vesting Link, issuing a Special-DPMF as a vested counterpart for another DPTF \
            \ A Vesting Link is immutable, and noted in the Token Properties of both the DPTF and the Special DPMF \
            \ A Special DPMF of the Vested variety, is used for implementing the Vesting Functionality for a DPTF Token \
            \ The <dptf> owner has the ability to vest its <dptf> token into a vested counterpart \
            \ specifying a target account, an offset, a duration and a number of milestones as vesting parameters \
            \ \
            \ The Target account receives the vested token, and according to its input vested parameters, \
            \ can revert it back to the <dptf> counterpart, as vesting intervals expire \
            \ \
            \ Vested Tokens cannot be used to add liquidity on any Swpair \
            \ \
            \ If a Vested Counterpart is created for a Token that is a Cold-RBT in an ATS Pair, \
            \ the RT owner of that ATS Pair can <coil>|<curl> the RT Token, and subsequently <vest> the output Hot-RBT token, \
            \ thus creating an additional layer of locking, for the input <RT> token, by converting it in a Vested Hot-RBT \
            \ OURO, AURYN and ELITE-AURYN will be the first Tokens that will make use of this functionality"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-VST::C_CreateVestingLink patron dptf)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun VST|C_CreateSleepingLink:string (patron:string dptf:string)
        @doc "Creates a Sleeping Link, issuing a Special-DPMF as a sleeping counterpart for another DPTF \
            \ A Sleeping Link is immutable, and noted in the Token Properties of both the DPTF and the Special DPMF \
            \ A Special DPMF of the Sleeping variety, is used for implementing the Sleeping Functionality for a DPTF Token \
            \ A Sleeping DPMF is similar to a vested Token, however it has a single period after which it can be converted \
            \ in its entirety, at once, into the initial <dptf> \
            \ As opposed to Vested DPMF Tokens, multiple Sleeping DPMF Tokens, can be unified into a single Sleeping Token \
            \ using a weigthed mean to determine the final time when it can be converted back to the initial <dptf> \
            \ \
            \ As oposed to Vested Tokens, Sleeping Tokens can be used to add Swpair Liquidity, as if they were the initial <dptf> token \
            \ This can be done, when this functionality is turned on for the Swpair, and using a Sleeping Token for adding Liquidity \
            \ generates a Sleeping LP Token, which behaves similarly to the Sleeping Token, inheriting its sleeping date, \
            \ that is, it can be converted back to the SWPairs native LP, when its sleeping interval expires \
            \ Existing LPs can also be put to sleep, locking liquidity for a given period \
            \ \
            \ VESTA will be the first Token that will be making use of this functionality"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-VST::C_CreateSleepingLink patron dptf)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    ;;  [VST Freezing]
    (defun VST|C_Freeze (patron:string freezer:string freeze-output:string dptf:string amount:decimal)
        @doc "Freezes a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_Freeze freezer freeze-output dptf amount)
                )
            )
        )
    )
    (defun VST|C_RepurposeFrozen (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        @doc "Repurposes a Frozen DPTF to another account"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_RepurposeFrozen dptf-to-repurpose repurpose-from repurpose-to)
                )
            )
        )
    )
    (defun VST|C_ToggleTransferRoleFrozenDPTF (patron:string s-dptf:string target:string toggle:bool)
        @doc "Toggles Transfer Role for a Frozen DPTF"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_ToggleTransferRoleFrozenDPTF s-dptf target toggle)
                )
            )
        )
    )
    ;;  [VST Reserving]
    (defun VST|C_Reserve (patron:string reserver:string dptf:string amount:decimal)
        @doc "Reserves a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_Reserve reserver dptf amount)
                )
            )
        )
    )
    (defun VST|C_Unreserve (patron:string unreserver:string r-dptf:string amount:decimal)
        @doc "Unreserves a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_Unreserve unreserver r-dptf amount)
                )
            )
        )
    )
    (defun VST|C_RepurposeReserved (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        @doc "Repurposes a Reserved DPTF to another account"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_RepurposeReserved dptf-to-repurpose repurpose-from repurpose-to)
                )
            )
        )
    )
    (defun VST|C_ToggleTransferRoleReservedDPTF (patron:string s-dptf:string target:string toggle:bool)
        @doc "Toggles Transfer Role for a Reserved DPTF"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_ToggleTransferRoleReservedDPTF s-dptf target toggle)
                )
            )
        )
    )
    ;;  [VST Vesting]
    (defun VST|C_Unvest (patron:string culler:string dpmf:string nonce:integer)
        @doc "Culls the Vested DPMF Token, recovering its DPTF counterpart."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_Unvest culler dpmf nonce)
                )
            )
        )
    )
    (defun VST|C_Vest (patron:string vester:string target-account:string dptf:string amount:decimal offset:integer duration:integer milestones:integer)
        @doc "Vests a DPTF Token, generating ist Vested DPMF Counterspart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_Vest vester target-account dptf amount offset duration milestones)
                )
            )
        )
    )
    (defun VST|C_RepurposeVested (patron:string dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        @doc "Repurposes a Vested DPMF to another account"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_RepurposeVested dpmf-to-repurpose nonce repurpose-from repurpose-to)
                )
            )
        )
    )
    (defun VST|C_CoilAndVest:decimal (patron:string coiler-vester:string ats:string coil-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        @doc "Coils a DPTF Token and Vests its output to <target-account> \
            \ Requires that: \
            \ *]Input DPTF is part of an ATSPair, the <ats> \
            \ *]That the Cold-RBT of <ats> has a vested counterpart \
            \ \
            \ Outputs the resulted Vested Cold-RBT Amount"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATS:module{AutostakeV3} ATS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                    (ref-VST:module{VestingV3} VST)
                    (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                    (c-rbt-amount:decimal (ref-ATS::URC_RBT ats coil-token amount))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                        [
                            (ref-ATSU::C_Coil coiler-vester ats coil-token amount)
                            (ref-VST::C_Vest coiler-vester target-account c-rbt c-rbt-amount offset duration milestones)
                        ]
                        []
                    )
                )
                c-rbt-amount
            )
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
        (with-capability (P|TS)
            (let*
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATS:module{AutostakeV3} ATS)
                    (ref-ATSU:module{AutostakeUsageV3} ATSU)
                    (ref-VST:module{VestingV3} VST)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (c-rbt1:string (ref-ATS::UR_ColdRewardBearingToken ats1))
                    (c-rbt1-amount:decimal (ref-ATS::URC_RBT ats1 curl-token amount))
                    (c-rbt2:string (ref-ATS::UR_ColdRewardBearingToken ats2))
                    (c-rbt2-amount:decimal (ref-ATS::URC_RBT ats2 c-rbt1 c-rbt1-amount))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                        [
                            (ref-ATSU::C_Curl curler-vester ats1 ats2 curl-token amount)
                            (ref-VST::C_Vest curler-vester target-account c-rbt2 c-rbt2-amount offset duration milestones)
                        ]
                        []
                    )
                )
                c-rbt2-amount
            )
        )
    )
    ;;  [VST Sleeping]
    (defun VST|C_Merge(patron:string merger:string dpmf:string nonces:[integer])
        @doc "Merges selected sleeping Tokens of an account, \
            \ releasing them if expired sleeping dpmfs exist within the selected tokens \
            \ Up to 30 existing Batches can be merged this way."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_Merge merger dpmf nonces)
                )
            )
        )
    )
    (defun VST|C_MergeAll(patron:string merger:string dpmf:string)
        @doc "Merges all sleeping Tokens of an account, \
            \ releasing them if expired sleeping dpmfs exist on account \
            \ Up to 30 existing Batches can be merged this way \
            \ If more than 35 Batches exist on <merger>, <VST|C_Merge> must be used to merge individual batches,\
            \ to reduce their number, such that mergim them all can fit within a single TX."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_MergeAll merger dpmf)
                )
            )
        )
    )
    (defun VST|C_Sleep (patron:string sleeper:string target-account:string dptf:string amount:decimal duration:integer)
        @doc "Sleeps a DPTF Token, generating ist Sleeping DPMF Counterspart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_Sleep sleeper target-account dptf amount duration)
                )
            )
        )
    )
    (defun VST|C_Unsleep (patron:string unsleeper:string dpmf:string nonce:integer)
        @doc "Culls the Sleeping DPMF Token, recovering its DPTF counterpart."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_Unsleep unsleeper dpmf nonce)
                )
            )
        )
    )
    (defun VST|C_RepurposeSleeping (patron:string dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        @doc "Repurposes a single Sleeping DPMF from <repurpose-from> to <repurpose-to>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_RepurposeSleeping dpmf-to-repurpose nonce repurpose-from repurpose-to)
                )
            )
        )
    )
    (defun VST|C_RepurposeMerge (patron:string dpmf-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string)
        @doc "Repurposes multiple Sleeping DPMFs (up to 30) from <repurpose-from> to <repurpose-to>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_RepurposeMerge patron dpmf-to-repurpose nonces repurpose-from repurpose-to)
                )
            )
        )
    )
    (defun VST|C_RepurposeMergeAll (patron:string dpmf-to-repurpose:string repurpose-from:string repurpose-to:string)
        @doc "Repurposes all Sleeping DPMFs (up to 30, more wont fit in a tx) from <repurpose-from> to <repurpose-to>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_RepurposeMergeAll dpmf-to-repurpose repurpose-from repurpose-to)
                )
            )
        )
    )
    (defun VST|C_ToggleTransferRoleSleepingDPMF (patron:string s-dpmf:string target:string toggle:bool)
        @doc "Toggles Transfer Role for a Sleeping DPMF"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-VST:module{VestingV3} VST)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-VST::C_ToggleTransferRoleSleepingDPMF s-dpmf target toggle)
                )
            )
        )
    )
    ;;  [LIQUID_Client]
    (defun LQD|C_UnwrapKadena (patron:string unwrapper:string amount:decimal)
        @doc "Unwraps DPTF Kadena to Native Kadena"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-LIQUID:module{KadenaLiquidStakingV3} LIQUID)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-LIQUID::C_UnwrapKadena unwrapper amount)
                )
            )
        )
    )
    (defun LQD|C_WrapKadena (patron:string wrapper:string amount:decimal)
        @doc "Wraps Native Kadena to DPTF Kadena"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-LIQUID:module{KadenaLiquidStakingV3} LIQUID)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-LIQUID::C_WrapKadena wrapper amount)
                )
            )
        )
    )
    ;;  [OUROBOROS_Client]
    (defun ORBR|C_Compress:decimal (client:string ignis-amount:decimal)
        @doc "Compresses IGNIS - Ouronet Gas Token, generating OUROBOROS \
            \ Only whole IGNIS Amounts greater than or equal to 1.0 can be used for compression \
            \ Similar to Sublimation, the output amount is dependent on OUROBOROS price, set at a minimum of 1$ \
            \ Compression has 98.5% efficiency, 1.5% is lost as fees."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ORBR:module{OuroborosV3} OUROBOROS)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-ORBR::C_Compress client ignis-amount)
                    )
                )
                (at 0 (at "output" ico))
            )
        )
    )
    (defun ORBR|C_Sublimate:decimal (client:string target:string ouro-amount:decimal)
        @doc "Sublimates OUROBOROS, generating Ouronet Gas, in form of IGNIS Token \
            \ A minimum amount of 1 input OUROBOROS is required. Amount of IGNIS generated depends on OUROBOROS Price in $, \
            \ with the minimum value being set at 1$ (in case the actual value is lower than 1$ \
            \ Ignis is generated for 99% of the input Ouroboros amount, thus Sublimation has a fee of 1%"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ORBR:module{OuroborosV3} OUROBOROS)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-ORBR::C_Sublimate client target ouro-amount)
                    )
                )
                (at 0 (at "output" ico))
            )
        )
    )
    (defun ORBR|C_WithdrawFees (patron:string id:string target:string)
        @doc "Withdraws collected DPTF Fees collected in standard mode \
        \ DPTF Fees collected in standard mode cumullate on the OUROBOROS Smart Account \
        \ Only the Token Owner can withdraw these fees."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ORBR:module{OuroborosV3} OUROBOROS)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ORBR::C_WithdrawFees id target)
                )
            )
        )
    )
    ;;  [Swapper_Client]
    (defun SWP|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for SWPair Token <entity-id> costing 400 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-B|SWP:module{BrandingUsageV6} SWP)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-B|SWP::C_UpdatePendingBranding entity-id logo description website social)
                )
            )
        )
    )
    (defun SWP|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Similar to its DPTF, DPMF, ATS Variants"
        (with-capability (P|TS)
            (let
                (
                    (ref-B|SWP:module{BrandingUsageV6} SWP)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                )
                (ref-B|SWP::C_UpgradeBranding patron entity-id months)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    (defun SWP|C_UpdatePendingBrandingLPs (patron:string swpair:string entity-pos:integer logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for SWPair LPs (Native LP, Frozen LP or Sleeping LP) Token <entity-id> costing 200 IGNIS \
            \ <entity-pos> 1 = LP Token will be used \
            \ <entity-pos> 2 = Frozen-LP Token will be used \
            \ <entity-pos> 3 = Sleeping-LP Token will be used"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-B|SWPL:module{BrandingUsageV7} SWPL)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-B|SWPL::C_UpdatePendingBrandingLPs swpair entity-pos logo description website social)
                )
            )
        )
    )
    (defun SWP|C_UpgradeBrandingLPs (patron:string swpair:string entity-pos:integer months:integer)
        @doc "Similar to its DPTF, DPMF, ATS SWP Variants, but for SWPair LPs"
        (with-capability (P|TS)
            (let
                (
                    (ref-B|SWPL:module{BrandingUsageV7} SWPL)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                )
                (ref-B|SWPL::C_UpgradeBrandingLPs patron swpair entity-pos months)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    (defun SWP|C_ChangeOwnership (patron:string swpair:string new-owner:string)
        @doc "Changes Ownership of an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWP:module{SwapperV4} SWP)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-SWP::C_ChangeOwnership swpair new-owner)
                )
            )
        )
    )
    (defun SWP|C_EnableFrozenLP:string (patron:string swpair:string)
        @doc "Enables the posibility of using Frozen Tokens to add Liquidity for an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWP:module{SwapperV4} SWP)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-SWP::C_EnableFrozenLP patron swpair)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun SWP|C_EnableSleepingLP:string (patron:string swpair:string)
        @doc "Enables the posibility of using Sleeping Tokens to add Liquidity for an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWP:module{SwapperV4} SWP)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-SWP::C_EnableSleepingLP patron swpair)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun SWP|C_IssueStable:list (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal amp:decimal p:bool)
        @doc "Issues a Stable Liquidity Pool. First Token in the liquidity Pool must have a connection to a principal Token \
            \ Stable Pools have the S designation. \
            \ Stable Pools can be created with up to 7 Tokens, and have by design equal weighting. \
            \ The <p> boolean defines if The Pool is a Principal Pools. \
            \ Principal Pools are always on, and cant be disabled by low-liquidity."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWPI:module{SwapperIssue} SWPI)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (weights:[decimal] (make-list (length pool-tokens) 1.0))
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-SWPI::C_Issue patron account pool-tokens fee-lp weights amp p)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at "output" ico)
            )
        )
    )
    (defun SWP|C_IssueStandard:list (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal p:bool)
        @doc "Issues a Standard, Constant Product Pool. \
            \ Constant Product Pools have the P Designation, and they are by design equal weigthed \
            \ Can also be created with up to 7 Tokens, also the <p> boolean determines if its a Principal Pool or not \
            \ The First Token must be a Principal Token"
        (SWP|C_IssueStable patron account pool-tokens fee-lp -1.0 p)
    )
    (defun SWP|C_IssueWeighted:list (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool)
        @doc "Issues a Weigthed Constant Liquidity Pool \
            \ Weigthed Pools have the W Designation, and the weights can be changed at will. \
            \ Can also be created with up to 7 Tokens, <p> boolean determines if its a Principal Pool or not \
            \ The First Token must also be a Principal Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWPI:module{SwapperIssue} SWPI)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-SWPI::C_Issue patron account pool-tokens fee-lp weights -1.0 p)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at "output" ico)
            )
        )
    )
    (defun SWP|C_ModifyCanChangeOwner (patron:string swpair:string new-boolean:bool)
        @doc "Modifies the <can-change-owner> parameter of an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWP:module{SwapperV4} SWP)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-SWP::C_ModifyCanChangeOwner swpair new-boolean)
                )
            )
        )
    )
    (defun SWP|C_ModifyWeights (patron:string swpair:string new-weights:[decimal])
        @doc "Modify weights for an SWPair. Works only for W Pools"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWP:module{SwapperV4} SWP)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-SWP::C_ModifyWeights swpair new-weights)
                )
            )
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
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWPL:module{SwapperLiquidity} SWPL)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-SWPL::C_ToggleAddLiquidity swpair toggle)
                )
            )
        )
    )
    (defun SWP|C_ToggleSwapCapability (patron:string swpair:string toggle:bool)
        @doc "Toggle on or off the Functionality of swapping for an <swpair> \
            \ When <toggle> is <true>, same setup for roles is executed as for <SWP|C_ToggleAddLiquidity> \
            \ \
            \ <On> Toggle can only be executed is <swpair> surpasses <(ref-SWP::UR_InactiveLimit)> \
            \ \
            \ Requires <swpair> ownership"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWPU:module{SwapperUsageV4} SWPU)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-SWPU::C_ToggleSwapCapability swpair toggle)
                )
            )
        )
    )
    (defun SWP|C_ToggleFeeLock (patron:string swpair:string toggle:bool)
        @doc "Locks the SPWPair fees in place. Modifying the SWPair fees requires them to be unlocked \
            \ Unlocking costs KDA and is financially discouraged"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWP:module{SwapperV4} SWP)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-SWP::C_ToggleFeeLock patron swpair toggle)
                    )
                    (collect:bool (at 0 (at "output" ico)))
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XE_ConditionalFuelKDA collect)
            )
        )
    )
    (defun SWP|C_UpdateAmplifier (patron:string swpair:string amp:decimal)
        @doc "Updates Amplifier Value; Only works on S-Pools (Stable Pools)"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWP:module{SwapperV4} SWP)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-SWP::C_UpdateAmplifier swpair amp)
                )
            )
        )
    )
    (defun SWP|C_UpdateFee (patron:string swpair:string new-fee:decimal lp-or-special:bool)
        @doc "Updates Fees Values for an SWPair \
            \ The <lp-or-special> boolean defines whether its the LP-Fee or Special-Fee that is changed \
            \ THe LP Fee is the amount of Swap Output kept by the Liquidity Pool, increasing the Value of its LP Token(s) \
            \ The Special-Fee is the Fee that is collected to the Special-Fee-Targets \
            \ The Fee must be between 0.0001 - 320.0 (promile, that would be 32%) \
            \ When <liquid-boost>, an universal SWP Parameter (that can be set only by the admin) is set to true \
            \   an amount equal to the LP-Fee is also used to boost the Liquid Kadena Index \
            \   which is why the fee must be capped at close a third of 100% (320 promile in this case)"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWP:module{SwapperV4} SWP)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-SWP::C_UpdateFee swpair new-fee lp-or-special)
                )
            )
        )
    )
    (defun SWP|C_UpdateSpecialFeeTargets (patron:string swpair:string targets:[object{SwapperV4.FeeSplit}])
        @doc "Updates the Special Fee Targets, along with their Split, for an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWP:module{SwapperV4} SWP)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-SWP::C_UpdateSpecialFeeTargets swpair targets)
                )
            )
        )
    )
    ;;
    (defun SWP|C_Fuel
        (patron:string account:string swpair:string input-amounts:[decimal])
        @doc "Fuels the <swpair> with <input-amounts> of Tokens. \
        \ Must contain values for all pool tokens, with zero for Tokens that arent used \
        \ Fueling increases Liquidity without issuing LP, therefore increasing LP Value"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWPL:module{SwapperLiquidity} SWPL)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-SWPL::C_Fuel account swpair input-amounts true true)
                )
            )
        )
    )
    (defun SWP|C_AddLiquidity:string (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        @doc "Adds Liquidity using <input-amounts> on <swpair>, in its default Standard Mode. \
            \ Must Contain 0.0 for Tokens not used; Pool Token Order must be followed for desired <input-amounts> \
            \ 1000 IGNIS Flat Fee Cost for adding liquidity to deincentivize addition of small values \
            \ \
            \ Liquidity can also be added on a completely empty pool, \
            \ if no asymetric liquidity exists in the <input-amounts> \
            \ In this case, the original Token Ratios are used, the SWPair was created with. \
            \ \
            \ DEFAULT MODE \
            \ \
            \ If Asymmetric LP is detected, further IGNIS costs are enforced \
            \ <ignis-gaseous-tax>, <deficit-ignis-tax>, <boost-ignis-tax> \
            \ Also a specific quantity of LP is relinquished as <fuel-lp-tax>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWPL:module{SwapperLiquidity} SWPL)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-SWPL::C|KDA-PID_AddStandardLiquidity account swpair input-amounts kda-pid)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (format "Generated {} Native LP Tokens for Swpair {}"
                    [(at 0 (at "output" ico)) swpair]
                )
            )
        )
    )
    (defun SWP|C_AddIcedLiquidity:string (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        @doc "Same as <SWP|C_AddLiquidity>, but using ICED Mode \
            \ \
            \ ICED MODE \
            \ Returns a part of the <asymmetric-lp-amount> as Frozen LP \
            \ <Swpair> must be enabled for Frozen LP for this feature \
            \ Only works when asymetric-liquidity exists in <input-amounts> \
            \ if <input-amounts> have balanced-liquidity, Native LP is returned for it \
            \ \
            \ In ICED MODE, only the IGNIS <ignis-gaseous-tax> is paid \
            \ Therefore the <asymmetric-lp-fee-amount> is returned as native LP \
            \ While the rest of the <asymmetric-lp-amount> is returned as Frozen LP"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWPL:module{SwapperLiquidity} SWPL)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-SWPL::C|KDA-PID_AddIcedLiquidity account swpair input-amounts kda-pid)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (format "Generated {} Native and {} Frozen LP Tokens for Swpair {}"
                    [(at 0 (at "output" ico)) (at 1 (at "output" ico)) swpair]
                )
            )
        )
    )
    (defun SWP|C_AddGlacialLiquidity:string (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        @doc "Same as <SWP|C_AddLiquidity>, but using GLACIAL Mode \
            \ \
            \ GLACIAL MODE \
            \ Returns all of the <asymmetric-lp-amount> as Frozen LP \
            \ <Swpair> must be enabled for Frozen LP for this feature \
            \ Only works when asymetric-liquidity exists in <input-amounts> \
            \ if <input-amounts> have balanced-liquidity, Native LP is returned for it \
            \ \
            \ In GLACIAL MODE, no further IGNIS taxes are paid"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWPL:module{SwapperLiquidity} SWPL)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-SWPL::C|KDA-PID_AddGlacialLiquidity account swpair input-amounts kda-pid)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (format "Generated {} Native and {} Frozen LP Tokens for Swpair {}"
                    [(at 0 (at "output" ico)) (at 1 (at "output" ico)) swpair]
                )
            )
        )
    )
    (defun SWP|C_AddFrozenLiquidity:string (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal kda-pid:decimal)
        @doc "Adds Liquidity using a single <input-amount> of a single <frozen-dptf> \
            \ Since this is an asymetric-liquidity-amount, it is bound by max. deviation rules \
            \ 1000 IGNIS Flat Fee Cost for adding liquidity. \
            \ \
            \ FROZEN MODE \
            \ Returns all LP Tokens as Frozen LP Tokens \
            \ <Swpair> must be enabled for Frozen LP for this feature \
            \ Also, a frozen link for one of the <swpair> Pool Tokens must have been previously created."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWPL:module{SwapperLiquidity} SWPL)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-SWPL::C|KDA-PID_AddFrozenLiquidity account swpair frozen-dptf input-amount kda-pid)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (format "Generated {} Frozen LP Tokens for Swpair {}"
                    [(at 0 (at "output" ico)) swpair]
                )
            )
        )
    )
    (defun SWP|C_AddSleepingLiquidity:string (patron:string account:string swpair:string sleeping-dpmf:string nonce:integer kda-pid:decimal)
        @doc "Adds Liquidity using a single <input-amount> of a single <sleeping-dpmf> \
        \ Since this is an asymetric-liquidity-amount, it is bound by max. deviation rules \
        \ 1000 IGNIS Flat Fee Cost for adding liquidity. \
        \ \
        \ SLEEPING MODE \
        \ Returns all LP Tokens as Sleeping LP tokens \
        \ <Swpair> must be enabled for Sleeping LP for this feature \
        \ Also, a sleeping link for one of the <swpair> Pool Tokens must have been previously created."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWPL:module{SwapperLiquidity} SWPL)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-SWPL::C|KDA-PID_AddSleepingLiquidity account swpair sleeping-dpmf nonce kda-pid)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (format "Generated {} Leeping LP Tokens for Swpair {}"
                    [(at 0 (at "output" ico)) swpair]
                )  
            )
        )
    )
    (defun SWP|C_RemoveLiquidity:list (patron:string account:string swpair:string lp-amount:decimal)
        @doc "Removes <swpair> Liquidity using <lp-amount> of LP Tokens \
            \ Always returns all Pool Tokens at current Pool Token Ratio \
            \ Removing Liquidty complety leaving the pool exactly empty (0.0 tokens) is fully supported"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWPL:module{SwapperLiquidity} SWPL)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-SWPL::C_RemoveLiquidity account swpair lp-amount)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (at "output" ico)
            )
        )
    )
    ;;Swaps
    (defun SWP|C_SingleSwapWithSlippage
        (
            patron:string
            account:string
            swpair:string
            input-id:string
            input-amount:decimal
            output-id:string
            slippage:decimal
        )
        @doc "Executes A Swap from <input-id> with <input-amount> to <output-id> with <slippage>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWPU:module{SwapperUsageV4} SWPU)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-SWPU::C_Swap account swpair [input-id] [input-amount] output-id slippage KDAPID)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun SWP|C_SingleSwapNoSlippage
        (
            patron:string
            account:string
            swpair:string
            input-id:string
            input-amount:decimal
            output-id:string
        )
        @doc "Executes A Swap from <input-id> with <input-amount> to <output-id> without slippage"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWPU:module{SwapperUsageV4} SWPU)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-SWPU::C_Swap account swpair [input-id] [input-amount] output-id -1.0 KDAPID)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun SWP|C_MultiSwapWithSlippage
        (
            patron:string
            account:string
            swpair:string
            input-ids:[string]
            input-amounts:[decimal]
            output-id:string
            slippage:decimal
        )
        @doc "Executes A Swap from <input-ids> with <input-amounts> to <output-id> with <slippage>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWPU:module{SwapperUsageV4} SWPU)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-SWPU::C_Swap account swpair input-ids input-amounts output-id slippage KDAPID)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (at 0 (at "output" ico))
            )
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
        @doc "Executes A Swap from <input-id> with <input-amount> to <output-id> without slippage"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-SWPU:module{SwapperUsageV4} SWPU)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-SWPU::C_Swap account swpair input-ids input-amounts output-id -1.0 KDAPID)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (at 0 (at "output" ico))
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)