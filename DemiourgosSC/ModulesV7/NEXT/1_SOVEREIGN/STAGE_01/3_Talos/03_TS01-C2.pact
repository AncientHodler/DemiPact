(module TS01-C2 GOV
    @doc "TALOS Administrator and Client Module for Stage 1"
    ;;
    (implements OuronetPolicy)
    (implements TalosStageOne_ClientTwoV5)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_TS01-C2        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TS01-C1_ADMIN)))
    (defcap GOV|TS01-C1_ADMIN ()    (enforce-guard GOV|MD_TS01-C2))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
                (ref-DALOS:module{OuronetDalosV5} DALOS)
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
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::P|Info)))
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
                (ref-P|IGNIS:module{OuronetPolicy} IGNIS)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|ATSU:module{OuronetPolicy} ATSU)
                (ref-P|VST:module{OuronetPolicy} VST)
                (ref-P|LIQUID:module{OuronetPolicy} LIQUID)
                (ref-P|ORBR:module{OuronetPolicy} OUROBOROS)
                (ref-P|SWPT:module{OuronetPolicy} SWPT)
                (ref-P|SWP:module{OuronetPolicy} SWP)
                (ref-P|SWPI:module{OuronetPolicy} SWPI)
                (ref-P|SWPL:module{OuronetPolicy} SWPL)
                (ref-P|SWPLC:module{OuronetPolicy} SWPLC)
                (ref-P|SWPU:module{OuronetPolicy} SWPU)
                (ref-P|TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                (mg:guard (create-capability-guard (P|TALOS-SUMMONER)))
            )
            (ref-P|IGNIS::P|A_AddIMP mg)
            (ref-P|ATS::P|A_AddIMP mg)
            (ref-P|ATSU::P|A_AddIMP mg)
            (ref-P|VST::P|A_AddIMP mg)
            (ref-P|LIQUID::P|A_AddIMP mg)
            (ref-P|ORBR::P|A_AddIMP mg)
            ;;
            (ref-P|SWPT::P|A_AddIMP mg)
            (ref-P|SWP::P|A_AddIMP mg)
            (ref-P|SWPI::P|A_AddIMP mg)
            (ref-P|SWPL::P|A_AddIMP mg)
            (ref-P|SWPLC::P|A_AddIMP mg)
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
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
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
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-B|ATS:module{BrandingUsageV10} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-B|ATS::C_UpdatePendingBranding entity-id logo description website social)
                )
            )
        )
    )
    (defun ATS|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Similar to its DPTF, DPOF Variants"
        (with-capability (P|TS)
            (let
                (
                    (ref-B|ATS:module{BrandingUsageV10} ATS)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                )
                (ref-B|ATS::C_UpgradeBranding patron entity-id months)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    ;;
    (defun ATS|C_HOT-RBT|UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for a HOT-RBT <entity-id> costing 150 IGNIS (Standard DPOF Costs)"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_HOT-RBT|UpdatePendingBranding entity-id logo description website social)
                )
            )
        )
    )
    (defun ATS|C_HOT-RBT|UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Similar to its DPTF, DPOF Variants"
        (with-capability (P|TS)
            (let
                (
                    (ref-ATS:module{AutostakeV5} ATS)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                )
                (ref-ATS::C_HOT-RBT|UpgradeBranding patron entity-id months)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    (defun ATS|C_HOT-RBT|Repurpose (patron:string hot-rbt:string nonce:integer repurpose-to:string)
        @doc "Repurposes a Hot-Rbt to a another Account, Can only be done by atspair owner"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-ATS:module{AutostakeV5} ATS)
                    (srt:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-to))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_HOT-RBT|Repurpose hot-rbt nonce repurpose-to)
                )
                (format "Succesfully repurposed HOT-RBT {} Nonce {} to Account {}" [hot-rbt nonce srt])
            )
        )
    )
    ;;
    (defun ATS|C_Issue:list (patron:string account:string ats:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string] rbt-nfr:[bool])
        @doc "Issues and Autostake Pair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-ATS::C_Issue patron account ats index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at "output" ico)
            )
        )
    )
    (defun ATS|C_RotateOwnership (patron:string ats:string new-owner:string)
        @doc "Rotates ATSPair Ownership"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_RotateOwnership ats new-owner)
                )
                (format "Succesfully changed ownership for ATS-Pair {}" [ats])
            )
        )
    )
    (defun ATS|C_Control (patron:string ats:string can-change-owner:bool syphoning:bool hibernate:bool)
        @doc "Controls the Properties of an ATS-Pair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_Control ats can-change-owner syphoning hibernate)
                )
                (format "Succesfully controlled ATS-Pair {}" [ats])
            )
        )
    )
    (defun ATS|C_UpdateRoyalty (patron:string ats:string royalty:decimal)
        @doc "Updates the Royalty value for an ATS-Pair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_UpdateRoyalty ats royalty)
                )
                (format "Royalty for ATS-Pair {} updated Succesfully to {} Promile" [ats royalty])
            )
        )
    )
    (defun ATS|C_UpdateSyphon (patron:string ats:string syphon:decimal)
        @doc "Updates the Royalty value for an ATS-Pair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_UpdateSyphon ats syphon)
                )
                (format "Syphon Index for ATS-Pair {} updated Succesfully to {}" [ats syphon])
            )
        )
    )
    (defun ATS|C_SetHibernationFees (patron:string ats:string peak:decimal decay:decimal)
        @doc "Updates the Hibernation Fees an ATS-Pair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_SetHibernationFees ats peak decay)
                )
                (format "Hibernation Fees for ATS-Pair {} set to {} Promile-Peak and {} Promile-Decay per Day" [ats peak decay])
            )
        )
    )
    ;;
    (defun ATS|C_ToggleParameterLock (patron:string ats:string toggle:bool)
        @doc "Toggle ATSPair Parameter Lock"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-ATS::C_ToggleParameterLock patron ats toggle)
                    )
                    (collect:bool (at 0 (at "output" ico)))
                )
                (ref-IGNIS::C_Collect patron ico)
                (ref-TS01-A::XE_ConditionalFuelKDA collect)
            )
        )
    )
    (defun ATS|C_AddSecondary (patron:string ats:string reward-token:string rt-nfr:bool)
        @doc "Adds a Secondary RT to an ATSPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_AddSecondary ats reward-token rt-nfr)
                )
                (if rt-nfr
                    (format "Succesfully Added {} as a secondndary Reward Token for the ATS-Pair {} with Native-Fee-Recovery" [ats reward-token])
                    (format "Succesfully Added {} as a secondndary Reward Token for the ATS-Pair {} without Native-Fee-Recovery" [ats reward-token])
                )
                
            )
        )
    )
    ;;
    (defun ATS|C_ControlColdRecoveryFees (patron:string ats:string c-nfr:bool c-fr:bool)
        @doc "Adds a Secondary RT to an ATSPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_ControlColdRecoveryFees ats c-nfr c-fr)
                )
                (format "Succesfully controlled Cold Recovery Fees for ATS-Pair {}" [ats])
                
            )
        )
    )
    (defun ATS|C_SetColdRecoveryFees (patron:string ats:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        @doc "Adds a Secondary RT to an ATSPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_SetColdRecoveryFees ats fee-positions fee-thresholds fee-array)
                )
                (format "Succesfully set Cold Recovery Fees for ATS-Pair {}" [ats])
                
            )
        )
    )
    (defun ATS|C_SetColdRecoveryDuration (patron:string ats:string soft-or-hard:bool base:integer growth:integer)
        @doc "Adds a Secondary RT to an ATSPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_SetColdRecoveryDuration ats soft-or-hard base growth)
                )
                (format "Succesfully set Cold Recovery Duration for ATS-Pair {}" [ats])
                
            )
        )
    )
    (defun ATS|C_ToggleElite (patron:string ats:string toggle:bool)
        @doc "Toggles ATSPair Elite Functionality"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_ToggleElite ats toggle)
                )
                (if toggle
                    (format "Succesfully switched on Elite Mode for ATS-Pair {}" [ats])
                    (format "Succesfully switched off Elite Mode for ATS-Pair {}" [ats])
                )
            )
        )
    )
    (defun ATS|C_SwitchColdRecovery (patron:string ats:string toggle:bool)
        @doc "Switches on or off Cold Recovery"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_SwitchColdRecovery ats toggle)
                )
                (if toggle
                    (format "Succesfully switched on Cold Recovery for ATS-Pair {}" [ats])
                    (format "Succesfully switched off Cold Recovery for ATS-Pair {}" [ats])
                )
                
            )
        )
    )
    ;;
    (defun ATS|C_AddHotRBT (patron:string ats:string hot-rbt:string)
        @doc "Adds a Hot-RBT to an ATS-Pair immutably \
            \ Must be a non special DPOF Token with zero Supply \
            \ Ownership of this Token is transfered to the ATS|SC_NAME"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_AddHotRBT ats hot-rbt)
                )
                (format "Succesfully added DPOF {} as Hot-RBT for ATS-Pair {}" [hot-rbt ats])
            )
        )
    )
    (defun ATS|C_ControlHotRecoveryFee (patron:string ats:string h-fr:bool)
        @doc "Controls Hot Recovery Fees"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_ControlHotRecoveryFee ats h-fr)
                )
                (format "Succesfully controlled Hot-Recovery Fee for ATS-Pair {}" [ats])
            )
        )
    )
    (defun ATS|C_SetHotRecoveryFee (patron:string ats:string promile:decimal decay:integer)
        @doc "Controls Hot Recovery Fees"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_SetHotRecoveryFee ats promile decay)
                )
                (format "Succesfully set Hot-Recovery Fees for ATS-Pair {} to {} Promile and {} Days-Decay" [ats promile decay])
            )
        )
    )
    (defun ATS|C_SwitchHotRecovery (patron:string ats:string toggle:bool)
        @doc "Switches on or off Hot Recovery"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_SwitchHotRecovery ats toggle)
                )
                (if toggle
                    (format "Succesfully switched on Hot Recovery for ATS-Pair {}" [ats])
                    (format "Succesfully switched off Hot Recovery for ATS-Pair {}" [ats])
                )
                
            )
        )
    )
    ;;
    (defun ATS|C_SetDirectRecoveryFee (patron:string ats:string promile:decimal)
        @doc "Controls Direct Recovery Fees"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_SetDirectRecoveryFee ats promile)
                )
                (format "Succesfully set Direct-Recovery Fees for ATS-Pair {} to {} Promile" [ats promile])
            )
        )
    )
    (defun ATS|C_SwitchDirectRecovery (patron:string ats:string toggle:bool)
        @doc "Switches on or off Direct Recovery"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATS::C_SwitchDirectRecovery ats toggle)
                )
                (if toggle
                    (format "Succesfully switched on Direct Recovery for ATS-Pair {}" [ats])
                    (format "Succesfully switched off Direct Recovery for ATS-Pair {}" [ats])
                )
                
            )
        )
    )
    ;;
    ;;
    (defun ATS|C_RemoveSecondary (patron:string ats:string reward-token:string)
        @doc "Controls Direct Recovery Fees"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATSU:module{AutostakeUsageV5} ATSU)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATSU::C_RemoveSecondary ats reward-token)
                )
                (format "Succesfully removed RT {} from ATS-Pair" [reward-token ats])
            )
        )
    )
    (defun ATS|C_WithdrawRoyalties (patron:string ats:string target:string)
        @doc "Withdraws ATS-Pair Royalties, if non-zero"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-ATSU:module{AutostakeUsageV5} ATSU)
                    (st:string (ref-I|OURONET::OI|UC_ShortAccount target))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATSU::C_WithdrawRoyalties ats target)
                )
                (format "Succesfully withdrawn Royalties from ATS-Pair {} to Account {}" [ats st])
            )
        )
    )
    (defun ATS|C_KickStart:decimal (patron:string kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal)
        @doc "Kickstarst an ATSPair, so that it starts at a given Index \
            \ Can only be done on a freshly created ATS-Pair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATSU:module{AutostakeUsageV5} ATSU)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-ATSU::C_KickStart kickstarter ats rt-amounts rbt-request-amount)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Succesfully Kikstarted ATS-Pair to an Index of {}" [ (at 0 (at "output" ico))])
            )
        )
    )
    (defun ATS|C_Fuel (patron:string fueler:string ats:string reward-token:string amount:decimal)
        @doc "Fuels an ATSPair with RT Tokens, increasing its Index"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                    (ref-ATSU:module{AutostakeUsageV5} ATSU)
                    (prev-index:decimal (ref-ATS::URC_Index ats))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATSU::C_Fuel fueler ats reward-token amount)
                )
                (format "Succesfully fueld ATS-Pair {} increasing its index by {}"
                    [ats (- (ref-ATS::URC_Index ats) prev-index)]
                )
            )
        )
    )
    (defun ATS|C_Coil (patron:string coiler:string ats:string rt:string amount:decimal)
        @doc "Coils an RT Token from a specific ATS-Pair, generating a RBT Token \
        \ Only works if <ats> has hibernation off."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATSU:module{AutostakeUsageV5} ATSU)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-ATSU::C_Coil coiler ats rt amount)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Succesfully coiled {} {} on ATS-Pair {} generating {} RBT Tokens" [amount rt ats (at 0 (at "output" ico))])
            )
        )
    )
    (defun ATS|C_Curl (patron:string curler:string ats1:string ats2:string rt:string amount:decimal)
        @doc "Curl double coils an RT Token in 2 chained ATS-Pairs \
            \ The RBT Token of <ats1> must be RBT Token in <ats2> \
            \ Both ATS-Pairs must have hibernation off for this to work."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATSU:module{AutostakeUsageV5} ATSU)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-ATSU::C_Curl curler ats1 ats2 rt amount)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Succesfully curled {} {} on ATS-Pairs {} and {} generating {} RBT Tokens of the second ATS-Pair" 
                    [amount rt ats1 ats2 (at 0 (at "output" ico))]
                )
            )
        )
    )
    (defun ATS|C_VestedCoil (patron:string coiler-vester:string ats:string coil-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        @doc "Coils a DPTF Token and Vests its output to <target-account> \
            \ Requires that: \
            \ *]Input DPTF is part of an ATSPair, the <ats> \
            \ *]That the RBT of <ats> has a vested counterpart \
            \ \
            \ Outputs the resulted Vested Cold-RBT Amount \
            \ Only the Owner of <coil-token> can execute thi function, \
            \ as this is prerequisite for Vesting"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    (ref-ATS:module{AutostakeV5} ATS)
                    (ref-VST:module{VestingV5} VST)
                    ;;
                    (coil-data:object{AutostakeV5.CoilData} 
                        (ref-ATS::URC_RewardBearingTokenAmounts ats coil-token amount)
                    )
                    (c-rbt:string ((at "rbt-id" coil-data)))
                    (c-rbt-amount:decimal (at "rbt-amount" coil-data))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-IGNIS::UDC_ConcatenateOutputCumulators
                        [
                            (ref-ATS::C_Coil coiler-vester ats coil-token amount)
                            (ref-VST::C_Vest coiler-vester target-account c-rbt c-rbt-amount offset duration milestones)
                        ]
                        []
                    )
                )
                (format "Succesfully coiled {} {} on ATS-Pair {} generating {} Vested RBT Tokens" [amount coil-token ats c-rbt-amount])
            )
        )
    )
    (defun ATS|C_VestedCurl (patron:string curler-vester:string ats1:string ats2:string curl-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        @doc "Same as <ATS|C_VestedCoil> but instead Curls the input Token. \
            \ Requires that : \
            \ *]Input DPTF is part of an ATSPair, the <ats1> \
            \ *]That the Cold-RBT Token of the <ats1> is RT in <ats2> \
            \ *]That Cold-RBT of <ats2> has a vested counterpat \
            \ \
            \ Outputs the resulted Vested Cold-RBT of <ats2>"
        (with-capability (P|TS)
            (let*
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                    (ref-VST:module{VestingV5} VST)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    ;;
                    (coil1-data:object{AutostakeV5.CoilData} 
                        (ref-ATS::URC_RewardBearingTokenAmounts ats1 curl-token amount)
                    )
                    (coil2-data:object{AutostakeV5.CoilData} 
                        (ref-ATS::URC_RewardBearingTokenAmounts ats2 (at "rbt-id" coil1-data) (at "rbt-amount" coil1-data))
                    )
                    (c-rbt2-amount:decimal (at "rbt-amount" coil2-data))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-IGNIS::UDC_ConcatenateOutputCumulators
                        [
                            (ref-ATS::C_Curl curler-vester ats1 ats2 curl-token amount)
                            (ref-VST::C_Vest curler-vester target-account (at "rbt-id" coil2-data) c-rbt2-amount offset duration milestones)
                        ]
                        []
                    )
                )
                (format "Succesfully curled {} {} on ATS-Pair {} and {} generating {} Vested RBT Tokens of the second ATS-Pair" 
                    [amount curl-token ats1 ats2 c-rbt2-amount]
                )
            )
        )
    )
    (defun ATS|C_Constrict (patron:string constricter:string ats:string rt:string amount:decimal dayz:integer)
        @doc "Constricts an RT Token from a specific ATS-Pair, generating a RBT Token in HIbernated Form \
        \ Only works if <ats> has hibernation on."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-VST::C_Constrict constricter ats rt amount dayz)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Succesfully constricted {} {} on ATS-Pair {} generating {} Hibernated RBT Tokens" 
                    [amount rt ats (at 0 (at "output" ico))]
                )
            )
        )
    )
    (defun ATS|C_Brumate (patron:string brumator:string ats1:string ats2:string rt:string amount:decimal dayz:integer)
        @doc "Brumate double coils an RT Token in 2 chained ATS-Pairs \
            \ The RBT Token of <ats1> must be RBT Token in <ats2> \
            \ Second ATS-Pair must have hibernation on for this to work."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-VST::C_Brumate brumator ats1 ats2 rt amount dayz)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Succesfully brumated {} {} on ATS-Pairs {} and {} generating {} Hibernated RBT Tokens of the second ATS-Pair" 
                    [amount rt ats1 ats2 (at 0 (at "output" ico))]
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
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-ATSU:module{AutostakeUsageV5} ATSU)
                    (st:string (ref-I|OURONET::OI|UC_ShortAccount syphon-target))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATSU::C_Syphon syphon-target ats syphon-amounts)
                )
                (format "Succesfully syphoned {} RT Amount(s) from ATS-Pair {} to Target {}" [syphon-amounts ats st])
            )
        )
    )
    ;;
    (defun ATS|C_ColdRecovery (patron:string recoverer:string ats:string ra:decimal)
        @doc "Recovers Cold-RBT, disolving it, generating RTs cullable in the future. \
        \ Amount of RTs is determined by the ATS-Pair Index at the Cold Recovery Moment"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATSU:module{AutostakeUsageV5} ATSU)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATSU::C_ColdRecovery recoverer ats ra)
                )
                (format "Succesfully placed {} {} ATS-Pair RBT into Cold Recovery" [ra ats])
            )
        )
    )
    (defun ATS|C_Cull:[decimal] (patron:string culler:string ats:string)
        @doc "Culls an ATSPair, extracting RTs that are cullable"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATSU:module{AutostakeUsageV5} ATSU)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-ATSU::C_Cull culler ats)
                    )
                    (cw:[decimal] (at "output" ico))
                    (how-many-tokens:integer (length cw))
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Succesfully Culled {} RT(s) Tokens with amounts of {} from ATS-Pair {}" [how-many-tokens cw ats])
                
            )
        )
    )
    ;;
    (defun ATS|C_HotRecovery (patron:string recoverer:string ats:string ra:decimal)
        @doc "Converts a Cold-RBT to a Hot-RBT, preparing it for Hot Recovery"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATSU:module{AutostakeUsageV5} ATSU)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATSU::C_HotRecovery recoverer ats ra)
                )
                (format "Succesfully converted {} RBT to Hot-RBT on ATS-Pair {}" [ra ats])
            )
        )
    )
    (defun ATS|C_Reverse (patron:string recoverer:string id:string nonce:integer)
        @doc "Reverses a Hot-RBT Nonce, converting it to Cold-RBT in its entirety \
            \ as the Hot-RBT doesnt have segmentation turned on"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                    (ref-ATSU:module{AutostakeUsageV5} ATSU)
                    (ats:string (ref-DPOF::UR_RewardBearingToken id))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATSU::C_Recover recoverer id nonce)
                )
                (format "Succesfully Converted Hot-RBT {} Nonce {} back into the Native RBT of ATS-Pair {}" [id nonce ats])
            )
        )
    )
    (defun ATS|C_Redeem (patron:string redeemer:string id:string nonce:integer)
        @doc "Redeems a Hot-RBT, recovering RTs"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                    (ref-ATSU:module{AutostakeUsageV5} ATSU)
                    (ats:string (ref-DPOF::UR_RewardBearingToken id))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATSU::C_Redeem redeemer id nonce)
                )
                (format "Succesfully Redeemed Hot-RBT {} Nonce {} back in RTs for ATS-Pair {}" [id nonce ats])
            )
        )
    )
    ;;
    (defun ATS|C_DirectRecovery (patron:string recoverer:string ats:string ra:decimal)
        @doc "Directly Recovers RBT to RTs using Direct Recovery"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATSU:module{AutostakeUsageV5} ATSU)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ATSU::C_DirectRecovery recoverer ats ra)
                )
                (format "Succesfully recovered directly {} RBT Token on ATS-Pair" [ra ats])
            )
        )
    )
    ;;  [VST_Client]
    (defun VST|C_CreateFrozenLink:[string] (patron:string dptf:string)
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
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-VST::C_CreateFrozenLink patron dptf)
                    )
                    (output-id:string (at 0 (at "output" ico)))
                )
                (ref-IGNIS::C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                [
                    (format "Succesfully generated a Frozen Link for the DPTF {}, issuing the Frozen DPTF {}" 
                        [dptf output-id]
                    )
                    output-id
                ]
                
            )
        )
    )
    (defun VST|C_CreateReservationLink:[string] (patron:string dptf:string)
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
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-VST::C_CreateReservationLink patron dptf)
                    )
                    (output-id:string (at 0 (at "output" ico)))
                )
                (ref-IGNIS::C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                [
                    (format "Succesfully generated a Reservation Link for the DPTF {}, issuing the Reserved DPTF {}" 
                        [dptf output-id]
                    )
                    output-id
                ]
                
            )
        )
    )
    (defun VST|C_CreateVestingLink:[string] (patron:string dptf:string)
        @doc "Creates a Vesting Link, issuing a Special-DPOF as a vested counterpart for another DPTF \
            \ A Vesting Link is immutable, and noted in the Token Properties of both the DPTF and the Special DPOF \
            \ A Special DPOF of the Vested variety, is used for implementing the Vesting Functionality for a DPTF Token \
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
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-VST::C_CreateVestingLink patron dptf)
                    )
                    (output-id:string (at 0 (at "output" ico)))
                )
                (ref-IGNIS::C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                [
                    (format "Succesfully generated a Vesting Link for the DPTF {}, issuing the Vested DPOF {}" 
                        [dptf output-id]
                    )
                    output-id
                ]
                
            )
        )
    )
    (defun VST|C_CreateSleepingLink:[string] (patron:string dptf:string)
        @doc "Creates a Sleeping Link, issuing a Special-DPOF as a sleeping counterpart for another DPTF \
            \ A Sleeping Link is immutable, and noted in the Token Properties of both the DPTF and the Special DPOF \
            \ A Special DPOF of the Sleeping variety, is used for implementing the Sleeping Functionality for a DPTF Token \
            \ A Sleeping DPOF is similar to a vested Token, however it has a single period after which it can be converted \
            \ in its entirety, at once, into the initial <dptf> \
            \ As opposed to Vested DPOF Tokens, multiple Sleeping DPOF Tokens, can be unified into a single Sleeping Token \
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
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-VST::C_CreateSleepingLink patron dptf)
                    )
                    (output-id:string (at 0 (at "output" ico)))
                )
                (ref-IGNIS::C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                [
                    (format "Succesfully generated a Sleeping Link for the DPTF {}, issuing the Sleeping DPOF {}" 
                        [dptf output-id]
                    )
                    output-id
                ]
                
            )
        )
    )
    (defun VST|C_CreateHibernatingLink:[string] (patron:string dptf:string)
        @doc "Creates a Hibernating Link, issuing a Special-DPOF as a hibernating counterpart for another DPTF \
            \ A Hibernating Link is immutable, and noted in the Token Properties of both DPTF and the Special DPOF \
            \ A Special DPOF of the Hibernating variety, is used for implementing the Hibernating Functionality for a DPTF Token \
            \ A Hibernating DPOF is similar to a sleeping Token, with a few particularities. \
            \ It has a day granularity, and up to 100 years can be used for hibernating. \
            \ \
            \ In direct contrast to a Sleeping DPOF, which has to be waited up for it to be converted back to its original DPTF \
            \ the Hibernated DPOF can be converted on Demand back into its original DPTF, however there is a fee to do so, \
            \ if the hibernation period hasnt elaspsed. This fee decreases from 800 promile down to zero at its awakening time \
            \ The fee is automaticaly burned, and cannot be recovered by any means. \
            \ \
            \ Similarly to Sleeping DPOFs, multiple batches can be merged, using the same algoritm implemented for mergind of Sleeping DPOFs"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-VST::C_CreateHibernatingLink patron dptf)
                    )
                    (output-id:string (at 0 (at "output" ico)))
                )
                (ref-IGNIS::C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                [
                    (format "Succesfully generated a Hibernation Link for the DPTF {}, issuing the Hibernated DPTF {}" 
                        [dptf output-id]
                    )
                    output-id
                ]
            )
        )
    )
    ;;  [VST Freezing]
    (defun VST|C_Freeze (patron:string freezer:string freeze-output:string dptf:string amount:decimal)
        @doc "Freezes a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-VST:module{VestingV5} VST)
                    (sfa:string (ref-I|OURONET::OI|UC_ShortAccount freeze-output))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_Freeze freezer freeze-output dptf amount)
                )
                (format "Succesfully freeze {} DPTF {} to Account {}" [amount dptf sfa])
            )
        )
    )
    (defun VST|C_RepurposeFrozen (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        @doc "Repurposes a Frozen DPTF to another account"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-VST:module{VestingV5} VST)
                    (srf:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-from))
                    (srt:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-to))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_RepurposeFrozen dptf-to-repurpose repurpose-from repurpose-to)
                )
                (format "Succesfully repurposed Frozen DPTF {} from {} to {}" [dptf-to-repurpose srf srt])
            )
        )
    )
    (defun VST|C_ToggleTransferRoleFrozenDPTF (patron:string s-dptf:string target:string toggle:bool)
        @doc "Toggles Transfer Role for a Frozen DPTF"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_ToggleTransferRoleFrozenDPTF s-dptf target toggle)
                )
                (format "Succefully toggled Transfer Role for the Frozen DPTF {}" [s-dptf])
            )
        )
    )
    ;;  [VST Reserving]
    (defun VST|C_Reserve (patron:string reserver:string dptf:string amount:decimal)
        @doc "Reserves a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-VST:module{VestingV5} VST)
                    (sr:string (ref-I|OURONET::OI|UC_ShortAccount reserver))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_Reserve reserver dptf amount)
                )
                (format "Account {} succesfully reserved {} {} Tokens" [sr amount dptf])
            )
        )
    )
    (defun VST|C_Unreserve (patron:string unreserver:string r-dptf:string amount:decimal)
        @doc "Unreserves a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-VST:module{VestingV5} VST)
                    (su:string (ref-I|OURONET::OI|UC_ShortAccount unreserver))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_Unreserve unreserver r-dptf amount)
                )
                (format "Account {} succesfully unreserved {} {} Tokens" [su amount r-dptf])
            )
        )
    )
    (defun VST|C_RepurposeReserved (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        @doc "Repurposes a Reserved DPTF to another account"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-VST:module{VestingV5} VST)
                    (srf:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-from))
                    (srt:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-to))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_RepurposeReserved dptf-to-repurpose repurpose-from repurpose-to)
                )
                (format "Succesfully repurposed Reserved DPTF {} from {} to {}" [dptf-to-repurpose srf srt])
            )
        )
    )
    (defun VST|C_ToggleTransferRoleReservedDPTF (patron:string s-dptf:string target:string toggle:bool)
        @doc "Toggles Transfer Role for a Reserved DPTF"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_ToggleTransferRoleReservedDPTF s-dptf target toggle)
                )
                (format "Succefully toggled Transfer Role for the Reserved DPTF {}" [s-dptf])
            )
        )
    )
    ;;  [VST Vesting]
    (defun VST|C_Vest (patron:string vester:string target-account:string dptf:string amount:decimal offset:integer seconds:integer milestones:integer)
        @doc "Vests a DPTF Token, generating ist Vested DPOF Counterspart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-VST:module{VestingV5} VST)
                    (sv:string (ref-I|OURONET::OI|UC_ShortAccount vester))
                    (sta:string (ref-I|OURONET::OI|UC_ShortAccount target-account))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_Vest vester target-account dptf amount offset seconds milestones)
                )
                (format "Succesfully vested DPTF {} From Account {} to Account {}" [dptf sv sta])
            )
        )
    )
    (defun VST|C_Unvest (patron:string unvester:string dpof:string nonce:integer)
        @doc "Culls the Vested DPOF Token, recovering its DPTF counterpart."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-VST:module{VestingV5} VST)
                    (su:string (ref-I|OURONET::OI|UC_ShortAccount unvester))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_Unvest unvester dpof nonce)
                )
                (format "Succesfully unvested DPOF {} Nonce {} to Account {}" [dpof nonce su])
            )
        )
    )
    (defun VST|C_RepurposeVested (patron:string dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        @doc "Repurposes a Vested DPOF to another account"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-VST:module{VestingV5} VST)
                    (srf:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-from))
                    (srt:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-to))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_RepurposeVested dpof-to-repurpose nonce repurpose-from repurpose-to)
                )
                (format "Succesfully repurposed Vested DPTF {} Nonce {}from {} to {}" [dpof-to-repurpose nonce srf srt])
            )
        )
    )
    ;;  [VST Sleeping]
    (defun VST|C_Sleep (patron:string sleeper:string target-account:string dptf:string amount:decimal seconds:integer)
        @doc "Sleeps a DPTF Token, generating its Sleeping DPOF Counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (sta:string (ref-I|OURONET::OI|UC_ShortAccount target-account))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_Sleep sleeper target-account dptf amount seconds)
                )
                (format "Sucesfully put to Sleep {} DPTF {} on Account {} for a Duration of {} seconds." [amount dptf sta seconds])
            )
        )
    )
    (defun VST|C_Unsleep (patron:string unsleeper:string dpof:string nonce:integer)
        @doc "Culls the Sleeping DPOF Token, recovering its DPTF counterpart."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (su:string (ref-I|OURONET::OI|UC_ShortAccount unsleeper))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_Unsleep unsleeper dpof nonce)
                )
                (format "Succesfully unsleeped DPOF {} Nonce {} on Account {}" [dpof nonce su])
            )
        )
    )
    (defun VST|C_Merge(patron:string merger:string dpof:string nonces:[integer])
        @doc "Merges selected sleeping Tokens of an account, \
            \ releasing them if expired sleeping dpof-s exist within the selected tokens \
            \ Multiple existing Batches can be merged this way."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-VST:module{VestingV5} VST)
                    (sm:string (ref-I|OURONET::OI|UC_ShortAccount merger))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_Merge merger dpof nonces)
                )
                (format "Succesfully merged Sleeping DPOF {} Nonces {} to Account {}" [dpof nonces sm])
            )
        )
    )
    (defun VST|C_RepurposeMerge (patron:string dpof-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string)
        @doc "Repurposes multiple Sleeping DPOFs from <repurpose-from> to <repurpose-to>, while merging them"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (srf:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-from))
                    (srt:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-to))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_RepurposeMerge dpof-to-repurpose nonces repurpose-from repurpose-to)
                )
                (format "Succesfully repurposed and merged Sleeping DPOF {} Nonces {} from {} to {}" 
                    [dpof-to-repurpose nonces srf srt]
                )
            )
        )
    )
    (defun VST|C_RepurposeSleeping (patron:string dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        @doc "Repurposes a single Sleeping DPOF from <repurpose-from> to <repurpose-to>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (srf:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-from))
                    (srt:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-to))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_RepurposeSleeping dpof-to-repurpose nonce repurpose-from repurpose-to)
                )
                (format "Succesfully repurposed Sleeping DPOF {} Nonce {} from {} to {}" 
                    [dpof-to-repurpose nonce srf srt]
                )
            )
        )
    )
    (defun VST|C_ToggleTransferRoleSleepingDPOF (patron:string s-dpof:string target:string toggle:bool)
        @doc "Toggles Transfer Role for a Sleeping DPOF"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_ToggleTransferRoleSleepingDPOF s-dpof target toggle)
                )
                (format "Succefully toggled Transfer Role for the Sleeping DPTF {}" [s-dpof])
            )
        )
    )
    ;;  [VST Hibernating]
    (defun VST|C_Hibernate (patron:string hibernator:string target-account:string dptf:string amount:decimal dayz:integer)
        @doc "Hibernates a DPTF Token, generating its Hibernated DPOF Counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (sta:string (ref-I|OURONET::OI|UC_ShortAccount target-account))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_Hibernate hibernator target-account dptf amount dayz)
                )
                (format "Sucesfully hibernated {} DPTF {} on Account {} for a Duration of {} days." [amount dptf sta days])
            )
        )
    )
    (defun VST|C_Awake (patron:string awaker:string dpof:string nonce:integer)
        @doc "Culls the Hibernated DPOF Token, recovering its DPTF counterpart."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount awaker))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-VST::C_Awake awaker dpof nonce)
                    )
                    (output:list (at "output" ico))
                    (v1:decimal (at 0 output))
                    (v2:decimal (at 1 output))
                    (v3:decimal (at 2 output))
                )
                (ref-IGNIS::C_Collect patron ico)
                (if (= v1 0.0)
                    (format "Awakend DPOF {} Nonce {} with no Hibernation Fee, getting the Full Amount of {} back" [dpof nonce v2])
                    (format "Awakend DPOF {} Nonce {} with a Hibernation Fee of {} Promile, relinquishing {} Tokens and getting only {} Tokens back" [dpof nonce v1 v3 v2])
                )
            )
        )
    )
    (defun VST|C_Slumber (patron:string merger:string dpof:string nonces:[integer])
        @doc "Merges selected hibernated Tokens of an account, \
            \ releasing them if expired sleeping dpof-s exist within the selected tokens \
            \ Multiple existing Batches can be merged this way."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-VST:module{VestingV5} VST)
                    (sm:string (ref-I|OURONET::OI|UC_ShortAccount merger))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_Slumber merger dpof nonces)
                )
                (format "Succesfully merged Hibernated DPOF {} Nonces {} to Account {}" [dpof nonces sm])
            )
        )
    )
    (defun VST|C_RepurposeSlumber (patron:string dpof-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string)
        @doc "Repurposes multiple Hibernated DPOFs from <repurpose-from> to <repurpose-to>, while merging them"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (srf:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-from))
                    (srt:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-to))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_RepurposeSlumber dpof-to-repurpose nonces repurpose-from repurpose-to)
                )
                (format "Succesfully repurposed and merged Hibernated DPOF {} Nonces {} from {} to {}" 
                    [dpof-to-repurpose nonces srf srt]
                )
            )
        )
    )
    (defun VST|C_RepurposeHibernating (patron:string dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        @doc "Repurposes a single Hibernating DPOF from <repurpose-from> to <repurpose-to>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (srf:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-from))
                    (srt:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-to))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_RepurposeHibernating dpof-to-repurpose nonce repurpose-from repurpose-to)
                )
                (format "Succesfully repurposed Hibernated DPOF {} Nonce {} from {} to {}" 
                    [dpof-to-repurpose nonce srf srt]
                )
            )
        )
    )
    (defun VST|C_ToggleTransferRoleHibernatedDPOF (patron:string s-dpof:string target:string toggle:bool)
        @doc "Toggles Transfer Role for a Hibernated DPOF"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-VST:module{VestingV5} VST)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-VST::C_ToggleTransferRoleHibernatingDPOF s-dpof target toggle)
                )
                (format "Succefully toggled Transfer Role for the Hibernating DPTF {}" [s-dpof])
            )
        )
    )
    ;;  [LIQUID_Client]
    (defun LQD|C_UnwrapKadena (patron:string unwrapper:string amount:decimal)
        @doc "Unwraps DPTF Kadena to Native Kadena"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-LIQUID:module{KadenaLiquidStakingV5} LIQUID)
                    (su:string (ref-I|OURONET::OI|UC_ShortAccount unwrapper))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-LIQUID::C_UnwrapKadena unwrapper amount)
                )
                (format "Succesfully Unwrapped {} WKDA on Account {}" [amount su])
            )
        )
    )
    (defun LQD|C_WrapKadena (patron:string wrapper:string amount:decimal)
        @doc "Wraps Native Kadena to DPTF Kadena"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-LIQUID:module{KadenaLiquidStakingV5} LIQUID)
                    (sw:string (ref-I|OURONET::OI|UC_ShortAccount wrapper))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-LIQUID::C_WrapKadena wrapper amount)
                )
                (format "Succesfully Wrapped {} KDA on Account {}" [amount sw])
            )
        )
    )
    ;;  [OUROBOROS_Client]
    (defun ORBR|C_Compress (client:string ignis-amount:decimal)
        @doc "Compresses IGNIS - Ouronet Gas Token, generating OUROBOROS \
            \ Only whole IGNIS Amounts greater than or equal to 1.0 can be used for compression \
            \ Similar to Sublimation, the output amount is dependent on OUROBOROS price, set at a minimum of 1$ \
            \ Compression has 98.5% efficiency, 1.5% is lost as fees."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ORBR:module{OuroborosV5} OUROBOROS)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-ORBR::C_Compress client ignis-amount)
                    )
                )
                (format "Succesfully compressed {} IGNIS to {} OUROBOROS" [ignis-amount (at 0 (at "output" ico))])
            )
        )
    )
    (defun ORBR|C_Sublimate (client:string target:string ouro-amount:decimal)
        @doc "Sublimates OUROBOROS, generating Ouronet Gas, in form of IGNIS Token \
            \ A minimum amount of 1 input OUROBOROS is required. Amount of IGNIS generated depends on OUROBOROS Price in $, \
            \ with the minimum value being set at 1$ (in case the actual value is lower than 1$ \
            \ Ignis is generated for 99% of the input Ouroboros amount, thus Sublimation has a fee of 1% \
            \ Needed for Sublimating negative Amounts"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ORBR:module{OuroborosV5} OUROBOROS)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-ORBR::C_Sublimate client target ouro-amount)
                    )
                )
                (format "Succesfully sublimated {} OUROBOROS to {} IGNIS" [ouro-amount (at 0 (at "output" ico))])
            )
        )
    )
    (defun ORBR|C_SublimateV2 (client:string target:string ouro-amount:decimal)
        @doc "Sublimates OUROBOROS, generating Ouronet Gas, in form of IGNIS Token \
            \ A minimum amount of 1 input OUROBOROS is required. Amount of IGNIS generated depends on OUROBOROS Price in $, \
            \ with the minimum value being set at 1$ (in case the actual value is lower than 1$ \
            \ Ignis is generated for 99% of the input Ouroboros amount, thus Sublimation has a fee of 1% \
            \ Can be used for Sublimation when OURO Supply is Positive, also being used in Firestarter."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ORBR:module{OuroborosV5} OUROBOROS)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-ORBR::C_SublimateV2 client target ouro-amount)
                    )
                )
                (format "Succesfully sublimated {} OUROBOROS to {} IGNIS" [ouro-amount (at 0 (at "output" ico))])
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
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ORBR:module{OuroborosV5} OUROBOROS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (st:string (ref-I|OURONET::OI|UC_ShortAccount target))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-ORBR::C_WithdrawFees id target)
                )
                (format "Succesfully withdrawn DPTF Fees for DPTF {} to Account {}" [id st])
            )
        )
    )
    ;;  [Swapper_Client]
    (defun SWP|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for SWPair Token <entity-id> costing 400 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-B|SWP:module{BrandingUsageV7} SWP)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-B|SWP::C_UpdatePendingBranding entity-id logo description website social)
                )
            )
        )
    )
    (defun SWP|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Similar to its DPTF, DPOF, ATS Variants"
        (with-capability (P|TS)
            (let
                (
                    (ref-B|SWP:module{BrandingUsageV7} SWP)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
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
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-B|SWPLC:module{BrandingUsageV8} SWPLC)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-B|SWPLC::C_UpdatePendingBrandingLPs swpair entity-pos logo description website social)
                )
            )
        )
    )
    (defun SWP|C_UpgradeBrandingLPs (patron:string swpair:string entity-pos:integer months:integer)
        @doc "Similar to its DPTF, DPOF, ATS SWP Variants, but for SWPair LPs"
        (with-capability (P|TS)
            (let
                (
                    (ref-B|SWPLC:module{BrandingUsageV8} SWPLC)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                )
                (ref-B|SWPLC::C_UpgradeBrandingLPs patron swpair entity-pos months)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    (defun SWP|C_ChangeOwnership (patron:string swpair:string new-owner:string)
        @doc "Changes Ownership of an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWP:module{SwapperV5} SWP)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWP::C_ChangeOwnership swpair new-owner)
                )
                (format "Succesfully changed ownership for SWP-Pair {}" [swpair])
            )
        )
    )
    (defun SWP|C_EnableFrozenLP:string (patron:string swpair:string)
        @doc "Enables the posibility of using Frozen Tokens to add Liquidity for an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    (ref-SWP:module{SwapperV5} SWP)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    ;;
                    (lp-id:string (ref-SWP::UR_TokenLP swpair))
                    (current-frozen-link:string (ref-DPTF::UR_Frozen lp-id))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWP::C_EnableFrozenLP patron swpair)
                    )
                    (issued-frozen-lp-id:string (at 0 (at "output" ico)))
                )
                (ref-IGNIS::C_Collect patron ico)
                (if (= current-frozen-link BAR)
                    (do
                        (ref-TS01-A::XB_DynamicFuelKDA)
                        (format "Succesfully Issued Frozen LP {} and enabled Frozen LP Functionality on SWP-Pair {}" [issued-frozen-lp-id swpair])
                    )
                    (format 
                        "Succesfully enabled Frozen LP Functionality on SWP-Pair {}, without issuing a Frozen LP, as it allready exists with id {}" 
                        [swpair current-frozen-link]
                    )
                )
            )
        )
    )
    (defun SWP|C_EnableSleepingLP:string (patron:string swpair:string)
        @doc "Enables the posibility of using Sleeping Tokens to add Liquidity for an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    (ref-SWP:module{SwapperV5} SWP)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    ;;
                    (lp-id:string (ref-SWP::UR_TokenLP swpair))
                    (current-sleeping-link:string (ref-DPTF::UR_Sleeping lp-id))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWP::C_EnableSleepingLP patron swpair)
                    )
                    (issued-sleeping-lp-id:string (at 0 (at "output" ico)))
                )
                (ref-IGNIS::C_Collect patron ico)
                (if (= current-sleeping-link BAR)
                    (do
                        (ref-TS01-A::XB_DynamicFuelKDA)
                        (format "Succesfully Issued Sleeping LP {} and enabled Frozen LP Functionality on SWP-Pair {}" [issued-sleeping-lp-id swpair])
                    )
                    (format 
                        "Succesfully enabled Sleeping LP Functionality on SWP-Pair {}, without issuing a Frozen LP, as it allready exists with id {}" 
                        [swpair current-sleeping-link]
                    )
                )
            )
        )
    )
    (defun SWP|C_IssueStable:list (patron:string account:string pool-tokens:[object{SwapperV5.PoolTokens}] fee-lp:decimal amp:decimal p:bool)
        @doc "Issues a Stable Liquidity Pool. First Token in the liquidity Pool must have a connection to a principal Token \
            \ Stable Pools have the S designation. \
            \ Stable Pools can be created with up to 7 Tokens, and have by design equal weighting. \
            \ The <p> boolean defines if The Pool is a Principal Pools. \
            \ Principal Pools are always on, and cant be disabled by low-liquidity."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPI:module{SwapperIssueV3} SWPI)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    (weights:[decimal] (make-list (length pool-tokens) 1.0))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPI::C_Issue patron account pool-tokens fee-lp weights amp p)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at "output" ico)
            )
        )
    )
    (defun SWP|C_IssueStandard:list (patron:string account:string pool-tokens:[object{SwapperV5.PoolTokens}] fee-lp:decimal p:bool)
        @doc "Issues a Standard, Constant Product Pool. \
            \ Constant Product Pools have the P Designation, and they are by design equal weigthed \
            \ Can also be created with up to 7 Tokens, also the <p> boolean determines if its a Principal Pool or not \
            \ The First Token must be a Principal Token"
        (SWP|C_IssueStable patron account pool-tokens fee-lp -1.0 p)
    )
    (defun SWP|C_IssueWeighted:list (patron:string account:string pool-tokens:[object{SwapperV5.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool)
        @doc "Issues a Weigthed Constant Liquidity Pool \
            \ Weigthed Pools have the W Designation, and the weights can be changed at will. \
            \ Can also be created with up to 7 Tokens, <p> boolean determines if its a Principal Pool or not \
            \ The First Token must also be a Principal Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPI:module{SwapperIssueV3} SWPI)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPI::C_Issue patron account pool-tokens fee-lp weights -1.0 p)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
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
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWP:module{SwapperV5} SWP)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWP::C_ModifyCanChangeOwner swpair new-boolean)
                )
                (format "Succesfully updated SWP-Pair {} <can-change-owner> Parameter" [swpair])
            )
        )
    )
    (defun SWP|C_ModifyWeights (patron:string swpair:string new-weights:[decimal])
        @doc "Modify weights for an SWPair. Works only for W Pools"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWP:module{SwapperV5} SWP)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWP::C_ModifyWeights swpair new-weights)
                )
                (format "Succesfully updated SWP-Pair {} Weigths Parameter" [swpair])
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
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClient} SWPLC)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWPLC::C_ToggleAddLiquidity swpair toggle)
                )
                (format "Succesfully toggled Liquidity Provisioning for SWP-Pair" [swpair])
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
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPU:module{SwapperUsageV5} SWPU)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWPU::C_ToggleSwapCapability swpair toggle)
                )
                (format "Succesfully toggled Swap Capability for SWP-Pair" [swpair])
            )
        )
    )
    (defun SWP|C_ToggleFeeLock (patron:string swpair:string toggle:bool)
        @doc "Locks the SPWPair fees in place. Modifying the SWPair fees requires them to be unlocked \
            \ Unlocking costs KDA and is financially discouraged"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWP:module{SwapperV5} SWP)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWP::C_ToggleFeeLock patron swpair toggle)
                    )
                    (collect:bool (at 0 (at "output" ico)))
                )
                (ref-IGNIS::C_Collect patron ico)
                (ref-TS01-A::XE_ConditionalFuelKDA collect)
                (format "Succesfully toggled the Fee Lock for the SWP-Pair" [swpair])
            )
        )
    )
    (defun SWP|C_UpdateAmplifier (patron:string swpair:string amp:decimal)
        @doc "Updates Amplifier Value; Only works on S-Pools (Stable Pools)"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWP:module{SwapperV5} SWP)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWP::C_UpdateAmplifier swpair amp)
                )
                (format "Succesfully updated SWP-Pair {} Amplifier Parameter" [swpair])
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
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWP:module{SwapperV5} SWP)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWP::C_UpdateFee swpair new-fee lp-or-special)
                )
                (format "Succesfully updated SWP-Pair {} Fees" [swpair])
            )
        )
    )
    (defun SWP|C_UpdateSpecialFeeTargets (patron:string swpair:string targets:[object{SwapperV5.FeeSplit}])
        @doc "Updates the Special Fee Targets, along with their Split, for an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWP:module{SwapperV5} SWP)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWP::C_UpdateSpecialFeeTargets swpair targets)
                )
                (format "Succesfully updated SWP-Pair {} Special Fee Targets" [swpair])
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
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClientV2} SWPLC) 
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWPLC::C_Fuel account swpair input-amounts true true)
                )
                (format "Succesfully fueled SWP-Pair {} with Token Amounts {}" [swpair input-amounts])
            )
        )
    )
    (defun SWP|C_AddLiquidity:string (patron:string account:string swpair:string input-amounts:[decimal])
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
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClient} SWPLC)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPLC::C|KDA-PID_AddStandardLiquidity account swpair input-amounts kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Generated {} Native LP Tokens for Swpair {}"
                    [(at 0 (at "output" ico)) swpair]
                )
            )
        )
    )
    (defun SWP|C_AddIcedLiquidity:string (patron:string account:string swpair:string input-amounts:[decimal])
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
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClient} SWPLC)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPLC::C|KDA-PID_AddIcedLiquidity account swpair input-amounts kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Generated {} Native and {} Frozen LP Tokens for Swpair {}"
                    [(at 0 (at "output" ico)) (at 1 (at "output" ico)) swpair]
                )
            )
        )
    )
    (defun SWP|C_AddGlacialLiquidity:string (patron:string account:string swpair:string input-amounts:[decimal])
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
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClient} SWPLC)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPLC::C|KDA-PID_AddGlacialLiquidity account swpair input-amounts kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Generated {} Native and {} Frozen LP Tokens for Swpair {}"
                    [(at 0 (at "output" ico)) (at 1 (at "output" ico)) swpair]
                )
            )
        )
    )
    (defun SWP|C_AddFrozenLiquidity:string (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal)
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
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClient} SWPLC)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPLC::C|KDA-PID_AddFrozenLiquidity account swpair frozen-dptf input-amount kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Generated {} Frozen LP Tokens for Swpair {}"
                    [(at 0 (at "output" ico)) swpair]
                )
            )
        )
    )
    (defun SWP|C_AddSleepingLiquidity:string (patron:string account:string swpair:string sleeping-dpof:string nonce:integer)
        @doc "Adds Liquidity using a single <input-amount> of a single <sleeping-dpof> \
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
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClient} SWPLC)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPLC::C|KDA-PID_AddSleepingLiquidity account swpair sleeping-dpof nonce kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Generated {} Leeping LP Tokens for Swpair {}"
                    [(at 0 (at "output" ico)) swpair]
                )  
            )
        )
    )
    (defun SWP|C_RemoveLiquidity (patron:string account:string swpair:string lp-amount:decimal)
        @doc "Removes <swpair> Liquidity using <lp-amount> of LP Tokens \
            \ Always returns all Pool Tokens at current Pool Token Ratio \
            \ Removing Liquidty complety leaving the pool exactly empty (0.0 tokens) is fully supported"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClientV2} SWPLC) 
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPLC::C_RemoveLiquidity account swpair lp-amount)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Removed {} LP Tokens from SWP-Pair {}, yielding {} of all Pool Tokens" [lp-amount swpair (at "output" ico)])
            )
        )
    )
    ;;Swaps
    (defun SWP|C_Firestarter (fire-starter:string)
        @doc "Makes IGNIS for <fire-starter> using 10 native Kadenas"
        (with-capability (P|TS)
            (let
                (
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-DALOS:module{OuronetDalosV5} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    (ref-LIQUID:module{KadenaLiquidStakingV5} LIQUID)
                    (ref-ORBR:module{OuroborosV5} OUROBOROS)
                    (ref-SWP:module{SwapperV5} SWP)
                    (ref-SWPU:module{SwapperUsageV5} SWPU)
                    ;;
                    (ouro:string (ref-DALOS::UR_OuroborosID))
                    (ignis:string (ref-DALOS::UR_IgnisID))
                    (primordial:string (ref-SWP::UR_PrimordialPool))
                    (fire-starter-ignis:decimal (ref-DPTF::UR_AccountSupply ignis fire-starter))
                    (fire-starter-ouro:decimal (ref-DPTF::UR_AccountSupply ouro fire-starter))
                )
                (enforce
                    (fold (and) true
                        [
                            (< fire-starter-ouro 1.0)
                            (>= fire-starter-ouro 0.0)
                            (< fire-starter-ignis 100.0)
                        ]
                    )
                    "Only empty or allmost empty Ouronet Accounts can firestart"
                )
                (let
                    (
                        (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                        (wkda:string (ref-DALOS::UR_WrappedKadenaID))
                        (ico1:object{IgnisCollectorV2.OutputCumulator}
                            (ref-LIQUID::C_WrapKadena fire-starter 10.0)
                        )
                        (ico2:object{IgnisCollectorV2.OutputCumulator}
                            (ref-SWPU::C_Swap fire-starter primordial [wkda] [10.0] ouro -1.0 kda-pid)
                        )
                        (gained-ouro:decimal (at 0 (at "output" ico2)))
                        (ico3:object{IgnisCollectorV2.OutputCumulator}
                            (ref-ORBR::C_SublimateV2 fire-starter fire-starter gained-ouro)
                        )
                    )
                    (format "Used 10 KDA to generate {} IGNIS with no IGNIS Costs!" [(at 0 (at "output" ico3))])              
                )
            )
        )
    )
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
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPU:module{SwapperUsageV5} SWPU)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPU::C_Swap account swpair [input-id] [input-amount] output-id slippage kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Succesfully swapped input(s) to {} {}" [(at 0 (at "output" ico)) output-id])
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
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPU:module{SwapperUsageV5} SWPU)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPU::C_Swap account swpair [input-id] [input-amount] output-id -1.0 kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Succesfully swapped input(s) to {} {}" [(at 0 (at "output" ico)) output-id])
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
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPU:module{SwapperUsageV5} SWPU)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPU::C_Swap account swpair input-ids input-amounts output-id slippage kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Succesfully swapped input(s) to {} {}" [(at 0 (at "output" ico)) output-id])
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
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPU:module{SwapperUsageV5} SWPU)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPU::C_Swap account swpair input-ids input-amounts output-id -1.0 kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Succesfully swapped input(s) to {} {}" [(at 0 (at "output" ico)) output-id])
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

;(create-table P|T)
;(create-table P|MT)