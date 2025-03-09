(interface TalosStageOne_ClientTwo
    ;;
    ;;ATS (Autostake) Functions
    (defun ATS|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])) ;d
    (defun ATS|C_UpgradeBranding (patron:string entity-id:string months:integer)) ;d
    ;;
    (defun ATS|C_AddHotRBT (patron:string ats:string hot-rbt:string)) ;d
    (defun ATS|C_AddSecondary (patron:string ats:string reward-token:string rt-nfr:bool)) ;d
    (defun ATS|C_Coil:decimal (patron:string coiler:string ats:string rt:string amount:decimal)) ;d
    (defun ATS|C_ColdRecovery (patron:string recoverer:string ats:string ra:decimal)) ;d
    (defun ATS|C_Cull:[decimal] (patron:string culler:string ats:string)) ;d
    (defun ATS|C_Curl:decimal (patron:string curler:string ats1:string ats2:string rt:string amount:decimal)) ;d
    (defun ATS|C_Fuel (patron:string fueler:string ats:string reward-token:string amount:decimal)) ;d
    (defun ATS|C_HotRecovery (patron:string recoverer:string ats:string ra:decimal)) ;d
    (defun ATS|C_Issue:list (patron:string account:string ats:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string] rbt-nfr:[bool])) ;d
    (defun ATS|C_KickStart:decimal (patron:string kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal)) ;d
    (defun ATS|C_ModifyCanChangeOwner (patron:string ats:string new-boolean:bool)) ;d
    (defun ATS|C_RecoverHotRBT (patron:string recoverer:string id:string nonce:integer amount:decimal)) ;d
    (defun ATS|C_RecoverWholeRBTBatch (patron:string recoverer:string id:string nonce:integer)) ;d
    (defun ATS|C_Redeem (patron:string redeemer:string id:string nonce:integer)) ;d
    (defun ATS|C_RemoveSecondary (patron:string remover:string ats:string reward-token:string))
    (defun ATS|C_RotateOwnership (patron:string ats:string new-owner:string)) ;d
    (defun ATS|C_SetColdFee (patron:string ats:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])) ;d
    (defun ATS|C_SetCRD (patron:string ats:string soft-or-hard:bool base:integer growth:integer)) ;d
    (defun ATS|C_SetHotFee (patron:string ats:string promile:decimal decay:integer)) ;d
    (defun ATS|C_Syphon (patron:string syphon-target:string ats:string syphon-amounts:[decimal])) ;d
    (defun ATS|C_ToggleElite (patron:string ats:string toggle:bool)) ;d
    (defun ATS|C_ToggleFeeSettings (patron:string ats:string toggle:bool fee-switch:integer)) ;d
    (defun ATS|C_ToggleParameterLock (patron:string ats:string toggle:bool)) ;d
    (defun ATS|C_ToggleSyphoning (patron:string ats:string toggle:bool)) ;d
    (defun ATS|C_TurnRecoveryOff (patron:string ats:string cold-or-hot:bool)) ;d
    (defun ATS|C_TurnRecoveryOn (patron:string ats:string cold-or-hot:bool)) ;d
    (defun ATS|C_UpdateSyphon (patron:string ats:string syphon:decimal)) ;d
    ;;
    ;;
    ;;VST (Vesting) Functions
    (defun VST|C_CreateFrozenLink:string (patron:string dptf:string)) ;d
    (defun VST|C_CreateReservationLink:string (patron:string dptf:string)) ;d
    (defun VST|C_CreateVestingLink:string (patron:string dptf:string)) ;d
    (defun VST|C_CreateSleepingLink:string (patron:string dptf:string)) ;d
    ;;Frozen
    (defun VST|C_Freeze (patron:string freezer:string freeze-output:string dptf:string amount:decimal)) ;d
    (defun VST|C_RepurposeFrozen (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string)) ;d
    (defun VST|C_ToggleTransferRoleFrozenDPTF (patron:string s-dptf:string target:string toggle:bool)) ;d
    ;;Reservation
    (defun VST|C_Reserve (patron:string reserver:string dptf:string amount:decimal)) ;d
    (defun VST|C_Unreserve (patron:string unreserver:string r-dptf:string amount:decimal)) ;d
    (defun VST|C_RepurposeReserved (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string)) ;d
    (defun VST|C_ToggleTransferRoleReservedDPTF (patron:string s-dptf:string target:string toggle:bool)) ;d
    ;;Vesting
    (defun VST|C_Unvest (patron:string culler:string dpmf:string nonce:integer)) ;d
    (defun VST|C_Vest (patron:string vester:string target-account:string dptf:string amount:decimal offset:integer duration:integer milestones:integer)) ;d
    (defun VST|C_RepurposeVested (patron:string dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string))
    (defun VST|C_CoilAndVest:decimal (patron:string coiler-vester:string ats:string coil-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)) ;d
    (defun VST|C_CurlAndVest:decimal (patron:string curler-vester:string ats1:string ats2:string curl-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)) ;d
    ;;Sleeping
    (defun VST|C_Merge(patron:string merger:string dpmf:string nonces:[integer])) ;d
    (defun VST|C_MergeAll(patron:string merger:string dpmf:string)) ;d
    (defun VST|C_Sleep (patron:string sleeper:string target-account:string dptf:string amount:decimal duration:integer)) ;d
    (defun VST|C_Unsleep (patron:string unsleeper:string dpmf:string nonce:integer)) ;d
    (defun VST|C_RepurposeSleeping (patron:string dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)) ;d
    (defun VST|C_RepurposeMerge (patron:string dpmf-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string)) ;d
    (defun VST|C_RepurposeMergeAll (patron:string dpmf-to-repurpose:string repurpose-from:string repurpose-to:string)) ;d
    (defun VST|C_ToggleTransferRoleSleepingDPMF (patron:string s-dpmf:string target:string toggle:bool)) ;d
    ;;
    ;;
    ;;LQD (Liquid-Staking KDA) Functions
    (defun LQD|C_UnwrapKadena (patron:string unwrapper:string amount:decimal)) ;d
    (defun LQD|C_WrapKadena (patron:string wrapper:string amount:decimal)) ;d
    ;;
    ;;
    ;;ORBR (Ouroboros) Functions
    (defun ORBR|C_Compress:decimal (patron:string client:string ignis-amount:decimal))
    (defun ORBR|C_Sublimate:decimal (patron:string client:string target:string ouro-amount:decimal)) ;d
    (defun ORBR|C_WithdrawFees (patron:string id:string target:string))
    ;;
    ;;
    ;;SWP (Swap-Pair) Functions
    (defun SWP|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])) ;d
    (defun SWP|C_UpgradeBranding (patron:string entity-id:string months:integer)) ;d
    (defun SWP|C_UpdatePendingBrandingLPs (patron:string swpair:string entity-pos:integer logo:string description:string website:string social:[object{Branding.SocialSchema}])) ;d
    (defun SWP|C_UpgradeBrandingLPs (patron:string swpair:string entity-pos:integer months:integer)) ;d
    ;;
    (defun SWP|C_ChangeOwnership (patron:string swpair:string new-owner:string)) ;d
    (defun SWP|C_EnableFrozenLP:string (patron:string swpair:string)) ;d
    (defun SWP|C_EnableSleepingLP:string (patron:string swpair:string)) ;d
    ;;Issue
    (defun SWP|C_IssueStable:list (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal amp:decimal p:bool)) ;d
    (defun SWP|C_IssueStandard:list (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal p:bool)) ;d
    (defun SWP|C_IssueWeighted:list (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool)) ;d
    ;;Management
    (defun SWP|C_ModifyCanChangeOwner (patron:string swpair:string new-boolean:bool)) ;d
    (defun SWP|C_ModifyWeights (patron:string swpair:string new-weights:[decimal])) ;d
    (defun SWP|C_ToggleAddLiquidity (patron:string swpair:string toggle:bool)) ;d
    (defun SWP|C_ToggleSwapCapability (patron:string swpair:string toggle:bool)) ;d
    (defun SWP|C_UpdateAmplifier (patron:string swpair:string amp:decimal)) ;d
    (defun SWP|C_UpdateFee (patron:string swpair:string new-fee:decimal lp-or-special:bool)) ;d
    (defun SWP|C_UpdateSpecialFeeTargets (patron:string swpair:string targets:[object{Swapper.FeeSplit}])) ;d
    ;;Liquidity
    (defun SWP|C_AddBalancedLiquidity:decimal (patron:string account:string swpair:string input-id:string input-amount:decimal)) ;d
    (defun SWP|C_AddFrozenLiquidity:decimal (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal)) ;d
    (defun SWP|C_AddSleepingLiquidity:decimal (patron:string account:string swpair:string sleeping-dpmf:string nonce:integer)) ;d
    (defun SWP|C_AddLiquidity:decimal (patron:string account:string swpair:string input-amounts:[decimal])) ;d
    (defun SWP|C_RemoveLiquidity:list (patron:string account:string swpair:string lp-amount:decimal)) ;d
    ;;Swap
    (defun SWP|C_MultiSwap:decimal (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:object{SwapperUsage.Slippage})) ;d
    (defun SWP|C_MultiSwapNoSlippage:decimal (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)) ;d
    (defun SWP|C_SimpleSwap:decimal (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string slippage:object{SwapperUsage.Slippage})) ;d
    (defun SWP|C_SimpleSwapNoSlippage:decimal (patron:string account:string swpair:string input-id:string input-amount:decimal output-id:string)) ;d

)
(module TS01-C2 GOV
    @doc "TALOS Administrator and Client Module for Stage 1"
    ;;
    (implements OuronetPolicy)
    (implements TalosStageOne_ClientTwo)
    ;;{G1}
    (defconst GOV|MD_TS01-C2        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TS01-C1_ADMIN)))
    (defcap GOV|TS01-C1_ADMIN ()    (enforce-guard GOV|MD_TS01-C2))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|TS ()
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
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
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::P|Info)))
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
                (ref-P|SWPU:module{OuronetPolicy} SWPU)
                (ref-P|TS01-A:module{TalosStageOne_Admin} TS01-A)
                (mg:guard (create-capability-guard (P|TALOS-SUMMONER)))
            )
            (ref-P|ATS::P|A_AddIMP mg)
            (ref-P|ATSU::P|A_AddIMP mg)
            (ref-P|VST::P|A_AddIMP mg)
            (ref-P|LIQUID::P|A_AddIMP mg)
            (ref-P|ORBR::P|A_AddIMP mg)
            (ref-P|SWPT::P|A_AddIMP mg)
            (ref-P|SWP::P|A_AddIMP mg)
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
    ;;{3}
    (defun TALOS|Gassless ()        (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|DALOS|SC_NAME)))
    (defconst GASSLES-PATRON        (TALOS|Gassless))
    (defcap SECURE ()
        true
    )
    ;;
    ;;
    ;;
    ;;{ATS_Client}
    (defun ATS|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for ATSPair <entity-id> costing 500 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto entity-id) 
                    [(ref-ATS::C_UpdatePendingBranding patron entity-id logo description website social)]
                )
            )
        )
    )
    (defun ATS|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Similar to its DPTF, DPMF Variants"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-ATS::C_UpgradeBranding patron entity-id months)
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
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) 
                    [(ref-ATSU::C_AddHotRBT patron ats hot-rbt)]
                )
            )
        )
    )
    (defun ATS|C_AddSecondary (patron:string ats:string reward-token:string rt-nfr:bool)
        @doc "Adds a Secondary RT to an ATSPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) 
                    [(ref-ATSU::C_AddSecondary patron ats reward-token rt-nfr)]
                )
            )
        )
    )
    (defun ATS|C_Coil:decimal (patron:string coiler:string ats:string rt:string amount:decimal)
        @doc "Coils an RT Token from a specific ATSPair, generating a RBT Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-ATSU::C_Coil patron coiler ats rt amount)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron coiler [ico])
                (at 0 (at "output" ico))
            )
        )
    )
    (defun ATS|C_ColdRecovery (patron:string recoverer:string ats:string ra:decimal)
        @doc "Recovers Cold-RBT, disolving it, generating cullable RTs in the future."
        (with-capability (P|TS)
            (let
                (
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron recoverer 
                    [(ref-ATSU::C_ColdRecovery patron recoverer ats ra)]
                )
            )
        )
    )
    (defun ATS|C_Cull:[decimal] (patron:string culler:string ats:string)
        @doc "Culls an ATSPair, extracting RTs that are cullable"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-ATSU::C_Cull patron culler ats)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron culler [ico])
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
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-ATSU::C_Curl patron curler ats1 ats2 rt amount)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron curler [ico])
                (at 0 (at "output" ico))
            )
        )
    )
    (defun ATS|C_Fuel (patron:string fueler:string ats:string reward-token:string amount:decimal)
        @doc "Fuels an ATSPair with RT Tokens, increasing its Index"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron fueler 
                    [(ref-ATSU::C_Fuel patron fueler ats reward-token amount)]
                )
            )
        )
    )
    (defun ATS|C_HotRecovery (patron:string recoverer:string ats:string ra:decimal)
        @doc "Converts a Cold-RBT to a Hot-RBT, preparing it for Hot Recovery"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron recoverer 
                    [(ref-ATSU::C_HotRecovery patron recoverer ats ra)]
                )
            )
        )
    )
    (defun ATS|C_Issue:list (patron:string account:string ats:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string] rbt-nfr:[bool])
        @doc "Issues and Autostake Pair"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-ATS::C_Issue patron account ats index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron account [ico])
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
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-ATSU::C_KickStart patron kickstarter ats rt-amounts rbt-request-amount)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron kickstarter [ico])
                (at 0 (at "output" ico))
            )
        )
    )
    (defun ATS|C_ModifyCanChangeOwner (patron:string ats:string new-boolean:bool)
        @doc "Modifies <can-change-owner> for the ATSPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) 
                    [(ref-ATSU::C_ModifyCanChangeOwner patron ats new-boolean)]
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
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron recoverer 
                    [(ref-ATSU::C_RecoverHotRBT patron recoverer id nonce amount)]
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
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron recoverer 
                    [(ref-ATSU::C_RecoverWholeRBTBatch patron recoverer id nonce)]
                )
            )
        )
    )
    (defun ATS|C_Redeem (patron:string redeemer:string id:string nonce:integer)
        @doc "Redeems a Hot-RBT, recovering RTs"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron redeemer 
                    [(ref-ATSU::C_Redeem patron redeemer id nonce)]
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
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron remover 
                    [(ref-ATSU::C_RemoveSecondary patron remover ats reward-token)]
                )
            )
        )
    )
    (defun ATS|C_RotateOwnership (patron:string ats:string new-owner:string)
        @doc "Rotates ATSPair Ownership"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) 
                    [(ref-ATSU::C_RotateOwnership patron ats new-owner)]
                )
            )
        )
    )
    (defun ATS|C_SetColdFee (patron:string ats:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        @doc "Sets ATSPair Cold Recovery Fee"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) 
                    [(ref-ATSU::C_SetColdFee patron ats fee-positions fee-thresholds fee-array)]
                )
            )
        )
    )
    (defun ATS|C_SetCRD (patron:string ats:string soft-or-hard:bool base:integer growth:integer)
        @doc "Sets ATSPair Cold Recovery Duration"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) 
                    [(ref-ATSU::C_SetCRD patron ats soft-or-hard base growth)]
                )
            )
        )
    )
    (defun ATS|C_SetHotFee (patron:string ats:string promile:decimal decay:integer)
        @doc "Sets ATSPair Hot Recovery Fee"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) 
                    [(ref-ATSU::C_SetHotFee patron ats promile decay)]
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
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) 
                    [(ref-ATSU::C_Syphon patron syphon-target ats syphon-amounts)]
                )
            )
        )
    )
    (defun ATS|C_ToggleElite (patron:string ats:string toggle:bool)
        @doc "Toggles ATSPair Elite Functionality"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) 
                    [(ref-ATSU::C_ToggleElite patron ats toggle)]
                )
            )
        )
    )
    (defun ATS|C_ToggleFeeSettings (patron:string ats:string toggle:bool fee-switch:integer)
        @doc "Toggles ATSPair Fee Settings"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) 
                    [(ref-ATS::C_ToggleFeeSettings patron ats toggle fee-switch)]
                )
            )
        )
    )
    (defun ATS|C_ToggleParameterLock (patron:string ats:string toggle:bool)
        @doc "Toggle ATSPair Parameter Lock"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-ATSU::C_ToggleParameterLock patron ats toggle)
                    )
                    (collect:bool (at 0 (at "output" ico)))
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) [ico])
                (ref-TS01-A::XE_ConditionalFuelKDA collect)
            )
        )
    )
    (defun ATS|C_ToggleSyphoning (patron:string ats:string toggle:bool)
        @doc "Toggles ATSPair syphoning capability"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) 
                    [(ref-ATSU::C_ToggleSyphoning patron ats toggle)]
                )
            )
        )
    )
    (defun ATS|C_TurnRecoveryOff (patron:string ats:string cold-or-hot:bool)
        @doc "Turns ATSPair Recovery off"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) 
                    [(ref-ATS::C_TurnRecoveryOff patron ats cold-or-hot)]
                )
            )
        )
    )
    (defun ATS|C_TurnRecoveryOn (patron:string ats:string cold-or-hot:bool)
        @doc "Turns ATSPair Cold or Hot Recovery On"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) 
                    [(ref-ATSU::C_TurnRecoveryOn patron ats cold-or-hot)]
                )
            )
        )
    )
    (defun ATS|C_UpdateSyphon (patron:string ats:string syphon:decimal)
        @doc "Updates Syphone Value, the decimal ATS-Index, until the ATSPair can be syphoned"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-ATS::UR_OwnerKonto ats) 
                    [(ref-ATSU::C_UpdateSyphon patron ats syphon)]
                )
            )
        )
    )
    ;;{VST_Client}
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
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-VST::C_CreateFrozenLink patron dptf)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-DPTF::UR_Konto dptf) [ico])
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
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-VST::C_CreateReservationLink patron dptf)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-DPTF::UR_Konto dptf) [ico])
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
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-VST::C_CreateVestingLink patron dptf)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-DPTF::UR_Konto dptf) [ico])
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
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-VST::C_CreateSleepingLink patron dptf)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-DPTF::UR_Konto dptf) [ico])
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    ;;Freezing
    (defun VST|C_Freeze (patron:string freezer:string freeze-output:string dptf:string amount:decimal)
        @doc "Freezes a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron freezer 
                    (ref-VST::C_Freeze patron freezer freeze-output dptf amount)
                )
            )
        )
    )
    (defun VST|C_RepurposeFrozen (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        @doc "Repurposes a Frozen DPTF to another account"
        (with-capability (P|TS)
            (let
                (
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron repurpose-from 
                    (ref-VST::C_RepurposeFrozen patron dptf-to-repurpose repurpose-from repurpose-to)
                )
            )
        )
    )
    (defun VST|C_ToggleTransferRoleFrozenDPTF (patron:string s-dptf:string target:string toggle:bool)
        @doc "Toggles Transfer Role for a Frozen DPTF"
        (with-capability (P|TS)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-DPTF::UR_Konto s-dptf) 
                    [(ref-VST::C_ToggleTransferRoleFrozenDPTF patron s-dptf target toggle)]
                )
            )
        )
    )
    ;;Reserving
    (defun VST|C_Reserve (patron:string reserver:string dptf:string amount:decimal)
        @doc "Reserves a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron reserver 
                    (ref-VST::C_Reserve patron reserver dptf amount)
                )
            )
        )
    )
    (defun VST|C_Unreserve (patron:string unreserver:string r-dptf:string amount:decimal)
        @doc "Unreserves a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron unreserver 
                    (ref-VST::C_Unreserve patron unreserver r-dptf amount)
                )
            )
        )
    )
    (defun VST|C_RepurposeReserved (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        @doc "Repurposes a Reserved DPTF to another account"
        (with-capability (P|TS)
            (let
                (
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron repurpose-from 
                    (ref-VST::C_RepurposeReserved patron dptf-to-repurpose repurpose-from repurpose-to)
                )
            )
        )
    )
    (defun VST|C_ToggleTransferRoleReservedDPTF (patron:string s-dptf:string target:string toggle:bool)
        @doc "Toggles Transfer Role for a Reserved DPTF"
        (with-capability (P|TS)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-DPTF::UR_Konto s-dptf) 
                    [(ref-VST::C_ToggleTransferRoleReservedDPTF patron s-dptf target toggle)]
                )
            )
        )
    )
    ;;Vesting
    (defun VST|C_Unvest (patron:string culler:string dpmf:string nonce:integer)
        @doc "Culls the Vested DPMF Token, recovering its DPTF counterpart."
        (with-capability (P|TS)
            (let
                (
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron culler 
                    (ref-VST::C_Unvest patron culler dpmf nonce)
                )
            )
        )
    )
    (defun VST|C_Vest (patron:string vester:string target-account:string dptf:string amount:decimal offset:integer duration:integer milestones:integer)
        @doc "Vests a DPTF Token, generating ist Vested DPMF Counterspart"
        (with-capability (P|TS)
            (let
                (
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron vester 
                    (ref-VST::C_Vest patron vester target-account dptf amount offset duration milestones)
                )
            )
        )
    )
    (defun VST|C_RepurposeVested (patron:string dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        @doc "Repurposes a Vested DPMF to another account"
        (with-capability (P|TS)
            (let
                (
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron repurpose-from 
                    (ref-VST::C_RepurposeVested patron dpmf-to-repurpose nonce repurpose-from repurpose-to)
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
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                    (c-rbt-amount:decimal (ref-ATS::URC_RBT ats coil-token amount))
                )
                (ref-TS01-A::XE_IgnisCollect patron coiler-vester 
                    (+
                        [(ref-ATSU::C_Coil patron coiler-vester ats coil-token amount)]
                        (ref-VST::C_Vest patron coiler-vester target-account c-rbt c-rbt-amount offset duration milestones)
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
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ATSU:module{AutostakeUsage} ATSU)
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (c-rbt1:string (ref-ATS::UR_ColdRewardBearingToken ats1))
                    (c-rbt1-amount:decimal (ref-ATS::URC_RBT ats1 curl-token amount))
                    (c-rbt2:string (ref-ATS::UR_ColdRewardBearingToken ats2))
                    (c-rbt2-amount:decimal (ref-ATS::URC_RBT ats2 c-rbt1 c-rbt1-amount))
                )
                (ref-TS01-A::XE_IgnisCollect patron curler-vester 
                    (+
                        [(ref-ATSU::C_Curl patron curler-vester ats1 ats2 curl-token amount)]
                        (ref-VST::C_Vest patron curler-vester target-account c-rbt2 c-rbt2-amount offset duration milestones)
                    )
                )
                c-rbt2-amount
            )
        )
    )
    ;;Sleeping
    (defun VST|C_Merge(patron:string merger:string dpmf:string nonces:[integer])
        @doc "Merges selected sleeping Tokens of an account, \
            \ releasing them if expired sleeping dpmfs exist within the selected tokens \
            \ Up to 30 existing Batches can be merged this way."
        (with-capability (P|TS)
            (let
                (
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron merger 
                    (ref-VST::C_Merge patron merger dpmf nonces)
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
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron merger 
                    (ref-VST::C_MergeAll patron merger dpmf)
                )
            )
        )
    )
    (defun VST|C_Sleep (patron:string sleeper:string target-account:string dptf:string amount:decimal duration:integer)
        @doc "Sleeps a DPTF Token, generating ist Sleeping DPMF Counterspart"
        (with-capability (P|TS)
            (let
                (
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron sleeper 
                    (ref-VST::C_Sleep patron sleeper target-account dptf amount duration)
                )
            )
        )
    )
    (defun VST|C_Unsleep (patron:string unsleeper:string dpmf:string nonce:integer)
        @doc "Culls the Sleeping DPMF Token, recovering its DPTF counterpart."
        (with-capability (P|TS)
            (let
                (
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron unsleeper 
                    (ref-VST::C_Unsleep patron unsleeper dpmf nonce)
                )
            )
        )
    )
    (defun VST|C_RepurposeSleeping (patron:string dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        @doc "Repurposes a single Sleeping DPMF from <repurpose-from> to <repurpose-to>"
        (with-capability (P|TS)
            (let
                (
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron repurpose-from 
                    (ref-VST::C_RepurposeSleeping patron dpmf-to-repurpose nonce repurpose-from repurpose-to)
                )
            )
        )
    )
    (defun VST|C_RepurposeMerge (patron:string dpmf-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string)
        @doc "Repurposes multiple Sleeping DPMFs (up to 30) from <repurpose-from> to <repurpose-to>"
        (with-capability (P|TS)
            (let
                (
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron repurpose-from 
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
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron repurpose-from 
                    (ref-VST::C_RepurposeMergeAll patron dpmf-to-repurpose repurpose-from repurpose-to)
                )
            )
        )
    )
    (defun VST|C_ToggleTransferRoleSleepingDPMF (patron:string s-dpmf:string target:string toggle:bool)
        @doc "Toggles Transfer Role for a Sleeping DPMF"
        (with-capability (P|TS)
            (let
                (
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (ref-VST:module{Vesting} VST)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-DPMF::UR_Konto s-dpmf) 
                    [(ref-VST::C_ToggleTransferRoleSleepingDPMF patron s-dpmf target toggle)]
                )
            )
        )
    )
    ;;{LIQUID_Client}
    (defun LQD|C_UnwrapKadena (patron:string unwrapper:string amount:decimal)
        @doc "Unwraps DPTF Kadena to Native Kadena"
        (with-capability (P|TS)
            (let
                (
                    (ref-LIQUID:module{KadenaLiquidStaking} LIQUID)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron unwrapper 
                    (ref-LIQUID::C_UnwrapKadena patron unwrapper amount)
                )
            )
        )
    )
    (defun LQD|C_WrapKadena (patron:string wrapper:string amount:decimal)
        @doc "Wraps Native Kadena to DPTF Kadena"
        (with-capability (P|TS)
            (let
                (
                    (ref-LIQUID:module{KadenaLiquidStaking} LIQUID)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron wrapper 
                    (ref-LIQUID::C_WrapKadena patron wrapper amount)
                )
            )
        )
    )
    ;;{OUROBOROS_Client}
    (defun ORBR|C_Compress:decimal (patron:string client:string ignis-amount:decimal)
        @doc "Compresses IGNIS - Ouronet Gas Token, generating OUROBOROS \
            \ Only whole IGNIS Amounts greater than or equal to 1.0 can be used for compression \
            \ Similar to Sublimation, the output amount is dependent on OUROBOROS price, set at a minimum of 1$ \
            \ Compression has 98.5% efficiency, 1.5% is lost as fees."
        (with-capability (P|TS)
            (let
                (
                    (ref-ORBR:module{Ouroboros} OUROBOROS)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-ORBR::C_Compress patron client ignis-amount)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron client [ico])
                (at 0 (at "output" ico))
            )
        )
    )
    (defun ORBR|C_Sublimate:decimal (patron:string client:string target:string ouro-amount:decimal)
        @doc "Sublimates OUROBOROS, generating Ouronet Gas, in form of IGNIS Token \
            \ A minimum amount of 1 input OUROBOROS is required. Amount of IGNIS generated depends on OUROBOROS Price in $, \
            \ with the minimum value being set at 1$ (in case the actual value is lower than 1$ \
            \ Ignis is generated for 99% of the input Ouroboros amount, thus Sublimation has a fee of 1%"
        (with-capability (P|TS)
            (let
                (
                    (ref-ORBR:module{Ouroboros} OUROBOROS)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-ORBR::C_Sublimate patron client target ouro-amount)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron client [ico])
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
                    (ref-ORBR:module{Ouroboros} OUROBOROS)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-DPTF::UR_Konto id) 
                    [(ref-ORBR::C_WithdrawFees patron id target)]
                )
            )
        )
    )
    ;;{Swapper_Client}
    (defun SWP|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for SWPair Token <entity-id> costing 400 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWP:module{Swapper} SWP)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-SWP::UR_OwnerKonto entity-id) 
                    [(ref-SWP::C_UpdatePendingBranding patron entity-id logo description website social)]
                )
            )
        )
    )
    (defun SWP|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Similar to its DPTF, DPMF, ATS Variants"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWP:module{Swapper} SWP)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-SWP::C_UpgradeBranding patron entity-id months)
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
                    (ref-SWP:module{Swapper} SWP)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) 
                    [(ref-SWP::C_UpdatePendingBrandingLPs patron swpair entity-pos logo description website social)]
                )
            )
        )
    )
    (defun SWP|C_UpgradeBrandingLPs (patron:string swpair:string entity-pos:integer months:integer)
        @doc "Similar to its DPTF, DPMF, ATS SWP Variants, but for SWPair LPs"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWP:module{Swapper} SWP)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-SWP::C_UpgradeBrandingLPs patron swpair entity-pos months)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    (defun SWP|C_ChangeOwnership (patron:string swpair:string new-owner:string)
        @doc "Changes Ownership of an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWP:module{Swapper} SWP)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) 
                    [(ref-SWP::C_ChangeOwnership patron swpair new-owner)]
                )
            )
        )
    )
    (defun SWP|C_EnableFrozenLP:string (patron:string swpair:string)
        @doc "Enables the posibility of using Frozen Tokens to add Liquidity for an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWP:module{Swapper} SWP)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWP::C_EnableFrozenLP patron swpair)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) [ico])
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
                    (ref-SWP:module{Swapper} SWP)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWP::C_EnableSleepingLP patron swpair)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) [ico])
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun SWP|C_IssueStable:list (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal amp:decimal p:bool)
        @doc "Issues a Stable Liquidity Pool. First Token in the liquidity Pool must have a connection to a principal Token \
            \ Stable Pools have the S designation. \
            \ Stable Pools can be created with up to 7 Tokens, and have by design equal weighting. \
            \ The <p> boolean defines if The Pool is a Principal Pools. \
            \ Principal Pools are always on, and cant be disabled by low-liquidity."
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-SWPU:module{SwapperUsage} SWPU)
                    (ref-ORBR:module{Ouroboros} OUROBOROS)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (weights:[decimal] (make-list (length pool-tokens) 1.0))
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWPU::SWPI|C_Issue patron account pool-tokens fee-lp weights amp p)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron account [ico])
                (ref-TS01-A::XB_DynamicFuelKDA)
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
        (with-capability (P|TS)
            (let
                (
                    (ref-SWPU:module{SwapperUsage} SWPU)
                    (ref-ORBR:module{Ouroboros} OUROBOROS)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWPU::SWPI|C_Issue patron account pool-tokens fee-lp weights -1.0 p)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron account [ico])
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
                    (ref-SWP:module{Swapper} SWP)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) 
                    [(ref-SWP::C_ModifyCanChangeOwner patron swpair new-boolean)]
                )
            )
        )
    )
    (defun SWP|C_ModifyWeights (patron:string swpair:string new-weights:[decimal])
        @doc "Modify weights for an SWPair. Works only for W Pools"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWP:module{Swapper} SWP)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) 
                    [(ref-SWP::C_ModifyWeights patron swpair new-weights)]
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
                    (ref-SWP:module{Swapper} SWP)
                    (ref-SWPU:module{SwapperUsage} SWPU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) 
                    [(ref-SWPU::C_ToggleAddLiquidity patron swpair toggle)]
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
                    (ref-SWP:module{Swapper} SWP)
                    (ref-SWPU:module{SwapperUsage} SWPU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) 
                    [(ref-SWPU::C_ToggleSwapCapability patron swpair toggle)]
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
                    (ref-SWP:module{Swapper} SWP)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWP::C_ToggleFeeLock patron swpair toggle)
                    )
                    (collect:bool (at 0 (at "output" ico)))
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) [ico])
                (ref-TS01-A::XE_ConditionalFuelKDA collect)
            )
        )
    )
    (defun SWP|C_UpdateAmplifier (patron:string swpair:string amp:decimal)
        @doc "Updates Amplifier Value; Only works on S-Pools (Stable Pools)"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWP:module{Swapper} SWP)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) 
                    [(ref-SWP::C_UpdateAmplifier patron swpair amp)]
                )
            )
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
        (with-capability (P|TS)
            (let
                (
                    (ref-SWP:module{Swapper} SWP)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) 
                    [(ref-SWP::C_UpdateFee patron swpair new-fee lp-or-special)]
                )
            )
        )
    )
    (defun SWP|C_UpdateSpecialFeeTargets (patron:string swpair:string targets:[object{Swapper.FeeSplit}])
        @doc "Updates the Special Fee Targets, along with their Split, for an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWP:module{Swapper} SWP)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                )
                (ref-TS01-A::XE_IgnisCollect patron (ref-SWP::UR_OwnerKonto swpair) 
                    [(ref-SWP::C_UpdateSpecialFeeTargets patron swpair targets)]
                )
            )
        )
    )
    ;;
    (defun SWP|C_AddBalancedLiquidity:decimal (patron:string account:string swpair:string input-id:string input-amount:decimal)
        @doc "Using input only an <input-id> and its <input-amount> \
            \ Adds Liquidity in a balanced mode, on the <swpair>"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWPU:module{SwapperUsage} SWPU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWPU::SWPL|C_AddBalancedLiquidity patron account swpair input-id input-amount)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron account [ico])
                (at 0 (at "output" ico))
            )
        )
    )
    (defun SWP|C_AddFrozenLiquidity:decimal (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal)
        @doc "Adds liquidity with a <frozen-dptf> Token to an <swpair>"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWPU:module{SwapperUsage} SWPU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWPU::SWPL|C_AddFrozenLiquidity patron account swpair frozen-dptf input-amount)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron account [ico])
                (at 0 (at "output" ico))
            )
        )
    )
    (defun SWP|C_AddSleepingLiquidity:decimal (patron:string account:string swpair:string sleeping-dpmf:string nonce:integer)
        @doc "Adds liquidity with a <sleeping-dpmf> Token to an <swpair>"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWPU:module{SwapperUsage} SWPU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWPU::SWPL|C_AddSleepingLiquidity patron account swpair sleeping-dpmf nonce)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron account [ico])
                (at 0 (at "output" ico))
            )
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
        (with-capability (P|TS)
            (let
                (
                    (ref-SWPU:module{SwapperUsage} SWPU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWPU::SWPL|C_AddLiquidity patron account swpair input-amounts)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron account [ico])
                (at 0 (at "output" ico))
            )
        )
    )
    (defun SWP|C_RemoveLiquidity:list (patron:string account:string swpair:string lp-amount:decimal)
        @doc "Removes Liquidity from a Liquidity Pool \
            \ Removing Liquidty is always done at the current Token Ratio. \
            \ Removing Liquidty complety leaving the pool exactly empty (0.0 tokens) is fully supported"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWPU:module{SwapperUsage} SWPU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWPU::SWPL|C_RemoveLiquidity patron account swpair lp-amount)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron account [ico])
                (at "output" ico)
            )
        )
    )
    (defun SWP|C_MultiSwap:decimal
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
        (with-capability (P|TS)
            (let
                (
                    (ref-SWPU:module{SwapperUsage} SWPU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWPU::SWPS|C_MultiSwap patron account swpair input-ids input-amounts output-id slippage)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron account [ico])
                (at 0 (at "output" ico))
            )
        )
    )
    (defun SWP|C_MultiSwapNoSlippage:decimal
        (
            patron:string
            account:string
            swpair:string
            input-ids:[string]
            input-amounts:[decimal]
            output-id:string
        )
        @doc "Same as <SWP|C_MultiSwap>, but with no Slippage Protection"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWPU:module{SwapperUsage} SWPU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWPU::SWPS|C_MultiSwapNoSlippage patron account swpair input-ids input-amounts output-id)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron account [ico])
                (at 0 (at "output" ico))
            )
        )
        
    )
    (defun SWP|C_SimpleSwap:decimal
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
        (with-capability (P|TS)
            (let
                (
                    (ref-SWPU:module{SwapperUsage} SWPU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWPU::SWPS|C_SimpleSwap patron account swpair input-id input-amount output-id slippage)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron account [ico])
                (at 0 (at "output" ico))
            )
        )
    )
    (defun SWP|C_SimpleSwapNoSlippage:decimal
        (
            patron:string
            account:string
            swpair:string
            input-id:string
            input-amount:decimal
            output-id:string
        )
        @doc "Same as <SWP|C_SimpleSwap>, but with no Slippage Protection"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWPU:module{SwapperUsage} SWPU)
                    (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-SWPU::SWPS|C_SimpleSwapNoSlippage patron account swpair input-id input-amount output-id)
                    )
                )
                (ref-TS01-A::XE_IgnisCollect patron account [ico])
                (at 0 (at "output" ico))
            )
        )
    )
)

(create-table P|T)
(create-table P|MT)