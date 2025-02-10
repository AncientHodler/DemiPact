;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface TalosStageOne
    ;;
    ;;ADMIN Functions
    (defun DALOS|A_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun DALOS|A_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun DALOS|A_IgnisToggle (native:bool toggle:bool))
    (defun DALOS|A_SetIgnisSourcePrice (price:decimal))
    (defun DALOS|A_UpdatePublicKey (account:string new-public:string))
    (defun DALOS|A_UpdateUsagePrice (action:string new-price:decimal))
    ;;
    ;;
    (defun BRD|A_Live (entity-id:string))
    (defun BRD|A_SetFlag (entity-id:string flag:integer))
    ;;
    ;;
    (defun ORBR|A_Fuel (patron:string))
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
    (defun DPTF|C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool]))
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
    (defun DPMF|C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool]))
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
    (defun ATS|C_Issue:[string] (patron:string account:string ats:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string] rbt-nfr:[bool]))
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
    (defun VST|C_CoilAndVest:decimal (patron:string coiler-vester:string ats:string coil-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer))
    (defun VST|C_CreateVestingLink:string (patron:string dptf:string))
    (defun VST|C_Cull (patron:string culler:string id:string nonce:integer))
    (defun VST|C_CurlAndVest:decimal (patron:string curler-vester:string ats1:string ats2:string curl-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer))
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
    (defun SWP|C_IssueStable:[string] (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal amp:decimal p:bool))
    (defun SWP|C_IssueStandard:[string] (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal p:bool))
    (defun SWP|C_IssueWeighted:[string] (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool))
    (defun SWP|C_ModifyCanChangeOwner (patron:string swpair:string new-boolean:bool))
    (defun SWP|C_ModifyWeights (patron:string swpair:string new-weights:[decimal]))
    (defun SWP|C_RotateGovernor (patron:string swpair:string new-gov:guard))
    (defun SWP|C_ToggleAddOrSwap (patron:string swpair:string toggle:bool add-or-swap:bool))
    (defun SWP|C_ToggleSpecialMode (patron:string swpair:string))
    (defun SWP|C_UpdateAmplifier (patron:string swpair:string amp:decimal))
    (defun SWP|C_UpdateFee (patron:string swpair:string new-fee:decimal lp-or-special:bool))
    (defun SWP|C_UpdateLP (patron:string swpair:string lp-token:string add-or-remove:bool))
    (defun SWP|C_UpdateSpecialFeeTargets (patron:string swpair:string targets:[object{Swapper.FeeSplit}]))
    ;;
    (defun SWP|C_AddBalancedLiquidity:decimal (patron:string account:string swpair:string input-id:string input-amount:decimal))
    (defun SWP|C_AddLiquidity:decimal (patron:string account:string swpair:string input-amounts:[decimal]))
    (defun SWP|C_RemoveLiquidity:[decimal] (patron:string account:string swpair:string lp-amount:decimal))
    (defun SWP|C_MultiSwap (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string))
    ;;
    ;;(defun XI_Collect (iz-collect:bool))
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
    ;;{P3}
    (defcap P|TS ()
        true
    )
    (defcap P|F ()
        (compose-capability (P|TS))
        (compose-capability (GOV|TS01_ADMIN))
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|TS01_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
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
            )
            (ref-P|DALOS::P|A_Add 
                "TALOS-01"
                (create-capability-guard (P|TS))
            )
            (ref-P|BRD::P|A_Add 
                "TALOS-01"
                (create-capability-guard (P|TS))
            )
            (ref-P|DPTF::P|A_Add 
                "TALOS-01"
                (create-capability-guard (P|TS))
            )
            (ref-P|DPMF::P|A_Add 
                "TALOS-01"
                (create-capability-guard (P|TS))
            )
            (ref-P|ATS::P|A_Add 
                "TALOS-01"
                (create-capability-guard (P|TS))
            )
            (ref-P|TFT::P|A_Add 
                "TALOS-01"
                (create-capability-guard (P|TS))
            )
            (ref-P|ATSU::P|A_Add 
                "TALOS-01"
                (create-capability-guard (P|TS))
            )
            (ref-P|VST::P|A_Add 
                "TALOS-01"
                (create-capability-guard (P|TS))
            )
            (ref-P|LIQUID::P|A_Add 
                "TALOS-01"
                (create-capability-guard (P|TS))
            )
            (ref-P|ORBR::P|A_Add 
                "TALOS-01"
                (create-capability-guard (P|TS))
            )
            (ref-P|SWPT::P|A_Add 
                "TALOS-01"
                (create-capability-guard (P|TS))
            )
            (ref-P|SWP::P|A_Add 
                "TALOS-01"
                (create-capability-guard (P|TS))
            )
            (ref-P|SWPU::P|A_Add 
                "TALOS-01"
                (create-capability-guard (P|TS))
            )
        )
    )
    (defun P|UEV_SIP (type:string)
        true
    )
    ;;
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
    (defun ORBR|A_Fuel (patron:string)
        @doc "Uses up all collected Native KDA on the Ouroboros Account, wraps it, and fuels the Kadena Liquid Index \
            \ Transaction fee must be paid for by the Ouronet Gas Station, so that all available balance may be used. \
            \ Is Part of all the Functions that collect native KDA as fee, \
            \ boosting the KDA Liquid Index, from 15% of the collected KDA \
            \ As Stand-Alone Function, can only be used by the Admin. \
            \ In normal condition, there is no need for using it on itself, as all collected KDA is automatically used up \
            \ by implementing this function at the end of those funtions that collect the KDA."
        ;;
        (let
            (
                (ref-ORBR:module{Ouroboros} OUROBOROS)
            )
            (with-capability (P|F)
                (ref-ORBR::C_Fuel patron)
            )
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
            )
            (with-capability (P|TS)
                (ref-DALOS::C_ControlSmartAccount patron account payable-as-smart-contract payable-by-smart-contract payable-by-method)
            )
        )
    )
    (defun DALOS|C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        @doc "Deploys a Standard Ouronet Account, taxing for KDA"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::C_DeploySmartdAccount account guard kadena sovereign public)
            )
        )
    )
    (defun DALOS|C_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        @doc "Deploys a Standard Ouronet Account, taxing for KDA"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::C_DeployStandardAccount account guard kadena public)
            )
        )
    )
    (defun DALOS|C_RotateGovernor (patron:string account:string governor:guard)
        @doc "Rotates the governor of a Smart Ouronet Account \
        \ The Governor acts as a governing entity for the Smart Ouronet Account allowing fine control of its assets"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::C_RotateGovernor patron account governor)
            )
        )
    )
    (defun DALOS|C_RotateGuard (patron:string account:string new-guard:guard safe:bool)
        @doc "Rotates the guard of an Ouronet Safe. Boolean <safe> also enforces the <new-guard>"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::C_RotateGuard patron account new-guard safe)
            )
        )
    )
    (defun DALOS|C_RotateKadena (patron:string account:string kadena:string)
        @doc "Rotates the KDA Account attached to an Ouronet Account. \
        \ The attached KDA Account is the account that makes KDA Payments for specific Ouronet Actions"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::C_RotateKadena patron account kadena)
            )
        )
    )
    (defun DALOS|C_RotateSovereign (patron:string account:string new-sovereign:string)
        @doc "Rotates the Sovereign of a Smart Ouronet Account \
        \ The Sovereign of a Smart Ouronet Account acts as its owner, allowing dominion over its assets"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::C_RotateSovereign patron account new-sovereign)
            )
        )
    )
    ;;{DPTF_Client}
    (defun DPTF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for DPTF Token <entity-id> costing 100 IGNIS"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_UpdatePendingBranding patron entity-id logo description website social)
            )
        )
    )
    (defun DPTF|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Upgrades Branding for DPTF Token, making it a premium Branding. \
            \ Also sets pending-branding to live branding if its branding is not live yet"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-ORBR:module{Ouroboros} OUROBOROS)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_UpgradeBranding patron entity-id months)
                (ref-ORBR::C_Fuel (ref-DALOS::GOV|DALOS|SC_NAME))
            )
        )
    )
    ;;
    (defun DPTF|C_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Executes a Bulk DPTF Transfer, sending one DPTF, to multiple receivers, each with its own amount"
        (let
            (
                (ref-P|TFT:module{OuronetPolicy} TFT)
            )
            (with-capability (P|TS)
                (ref-P|TFT::C_BulkTransfer patron id sender receiver-lst transfer-amount-lst method)
            )
        )
    )
    (defun DPTF|C_Burn (patron:string id:string account:string amount:decimal)
        @doc "Burns a DPTF Token from an account"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_Burn patron id account amount)
            )
        )
    )
    (defun DPTF|C_ClearDispo (patron:string account:string)
        @doc "Clears OURO Dispo by levereging existing Elite-Auryn"
        (let
            (
                (ref-P|TFT:module{OuronetPolicy} TFT)
            )
            (with-capability (P|TS)
                (ref-P|TFT::C_ClearDispo patron account)
            )
        )
    )
    (defun DPTF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool)
        @doc "Controls the properties of a DPTF Token \
            \ <can-change-owner> <can-upgrade> <can-add-special-role> <can-freeze> <can-wipe> <can-pause>"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_Control patron id cco cu casr cf cw cp)
            )
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
    (defun DPTF|C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
        @doc "Issues a new DPTF Token in Bulk, can also be used to issue a single DPTF \
        \ Outputs a string list with the issed DPTF IDs"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-ORBR:module{Ouroboros} OUROBOROS)
                    (output:[string] (ref-DPTF::C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause))
                )
                (ref-ORBR::C_Fuel (ref-DALOS::GOV|DALOS|SC_NAME))
                output
            )
        )
    )
    (defun DPTF|C_Mint (patron:string id:string account:string amount:decimal origin:bool)
        @doc "Mints a DPTF Token"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_Mint patron id account amount origin)
            )
        )
    )
    (defun DPTF|C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @doc "Executes a DPTF MultiTransfer, sending multiple DPTF, each with its own amount, to a single receiver"
        (let
            (
                (ref-P|TFT:module{OuronetPolicy} TFT)
            )
            (with-capability (P|TS)
                (ref-P|TFT::C_MultiTransfer patron id-lst sender receiver transfer-amount-lst method)
            )
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
            )
            (with-capability (P|TS)
                (ref-DPTF::C_RotateOwnership patron id new-owner)
            )
        )
    )
    (defun DPTF|C_SetFee (patron:string id:string fee:decimal)
        @doc "Sets a transfer fee for the DPTF Token"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_SetFee patron id fee)
            )
        )
    )
    (defun DPTF|C_SetFeeTarget (patron:string id:string target:string)
        @doc "Sets the Fee Collection Target for a DPTF"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_SetFeeTarget patron id target)
            )
        )
    )
    (defun DPTF|C_SetMinMove (patron:string id:string min-move-value:decimal)
        @doc "Sets the minimum amount needed to transfer a DPTF Token"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_SetMinMove patron id min-move-value)
            )
        )
    )
    (defun DPTF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <burn-role> for a DPTF Token <id> on a specific <account>"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|TS)
                (ref-ATS::DPTF|C_ToggleBurnRole patron id account toggle)
            )
        )
    )
    (defun DPTF|C_ToggleFee (patron:string id:string toggle:bool)
        @doc "Toggles Fee collection for a DPTF Token. When a DPTF Token is setup with a transfer fee, \
            \ it will come in effect only when the toggle is on(true)"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_ToggleFee patron id toggle)
            )
        )
    )
    (defun DPTF|C_ToggleFeeExemptionRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <fee-exemption-role> for a DPTF Token <id> on a specific <account>"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|TS)
                (ref-ATS::DPTF|C_ToggleFeeExemptionRole patron id account toggle)
            )
        )
    )
    (defun DPTF|C_ToggleFeeLock (patron:string id:string toggle:bool)
        @doc "Toggles DPTF Fee Settings Lock"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (collect:bool
                    (with-capability (P|TS)
                        (ref-DPTF::C_ToggleFeeLock patron id toggle)
                    )
                )
            )
            (with-capability (SECURE)
                (XI_Collect collect)
            )
        )
    )
    (defun DPTF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Toggles Freezing of a DPTF Account"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_ToggleFreezeAccount patron id account toggle)
            )
        )
    )
    (defun DPTF|C_ToggleMintRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <mint-role> for a DPTF Token <id> on a specific <account>"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|TS)
                (ref-ATS::DPTF|C_ToggleMintRole patron id account toggle)
            )
        )
    )
    (defun DPTF|C_TogglePause (patron:string id:string toggle:bool)
        @doc "Toggles Pause for a DPTF Token"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_TogglePause patron id toggle)
            )
        )
    )
    (defun DPTF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <transfer-role> for a DPTF Token <id> on a specific <account>"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_ToggleTransferRole patron id account toggle)
            )
        )
    )
    (defun DPTF|C_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Transfers a DPTF Token from <sender> to <receiver>"
        (let
            (
                (ref-P|TFT:module{OuronetPolicy} TFT)
            )
            (with-capability (P|TS)
                (ref-P|TFT::C_Transfer patron id sender receiver transfer-amount method)
            )
        )
    )
    (defun DPTF|C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal)
        @doc "Transmutes a DPTF Token. Transmuting behaves follows the same mechanics of a DPTF Fee Processing \
        \ without counting as DPTF Fee in the DPTF Fee Counter"
        (let
            (
                (ref-P|TFT:module{OuronetPolicy} TFT)
            )
            (with-capability (P|TS)
                (ref-P|TFT::C_Transmute patron id transmuter transmute-amount)
            )
        )
    )
    (defun DPTF|C_Wipe (patron:string id:string atbw:string)
        @doc "Wipes a DPTF Token from a given account"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_Wipe patron id atbw)
            )
        )
    )
    ;;{DPMF_Client}
    (defun DPMF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for DPMF Token <entity-id> costing 150 IGNIS"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_UpdatePendingBranding patron entity-id logo description website social)
            )
        )
    )
    (defun DPMF|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ref-ORBR:module{Ouroboros} OUROBOROS)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_UpgradeBranding patron entity-id months)
                (ref-ORBR::C_Fuel (ref-DALOS::GOV|DALOS|SC_NAME))
            )
        )
    )
    ;;
    (defun DPMF|C_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_AddQuantity patron id nonce account amount)
            )
        )
    )
    (defun DPMF|C_Burn (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_Burn patron id nonce account amount)
            )
        )
    )
    (defun DPMF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool)
        @doc "Similar to its DPTF Variant, has an extra boolean trigger for <can-transfer-nft-create-role>"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_Control patron id cco cu casr cf cw cp ctncr)
            )
        )
    )
    (defun DPMF|C_Create:integer (patron:string id:string account:string meta-data:[object])
        @doc "Creates a DPMF Token (id must already be issued), only creating a new DPMF nonce, without adding quantity"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_Create patron id account meta-data)
            )
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
    (defun DPMF|C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (ref-ORBR:module{Ouroboros} OUROBOROS)
                    (output:[string] (ref-DPMF::C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role))
                )
                (ref-ORBR::C_Fuel (ref-DALOS::GOV|DALOS|SC_NAME))
                output
            )
        )
    )
    (defun DPMF|C_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object])
        @doc "Mints a DPMF Token, creating it and adding quantity to it"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_Mint patron id account amount meta-data)
            )
        )
    )
    (defun DPMF|C_MoveCreateRole (patron:string id:string receiver:string)
        @doc "Moves <create-role> for a DPMF Token <id> to <receiver> \
        \ Only a single account may have this role"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|TS)
                (ref-ATS::DPMF|C_MoveCreateRole patron id receiver)
            )
        )
    )
    (defun DPMF|C_MultiBatchTransfer (patron:string id:string nonces:[integer] sender:string receiver:string method:bool)
        @doc "Executes a MultiBatch transfer, transfering multiple DPMF nonces in single function"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_MultiBatchTransfer patron id nonces sender receiver method)
            )
        )
    )
    (defun DPMF|C_RotateOwnership (patron:string id:string new-owner:string)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_RotateOwnership patron id new-owner)
            )
        )
    )
    (defun DPMF|C_SingleBatchTransfer (patron:string id:string nonce:integer sender:string receiver:string method:bool)
        @doc "Executes a single Batch Transfer, transfering the whole nonce amount"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_SingleBatchTransfer patron id nonce sender receiver method)
            )
        )
    )
    (defun DPMF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <add-quantity-role> for a DPMF Token <id> on a specific <account>"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|TS)
                (ref-ATS::DPMF|C_ToggleAddQuantityRole patron id account toggle)
            )
        )
    )
    (defun DPMF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <burn-role> for a DPMF Token <id> on a specific <account>"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|TS)
                (ref-ATS::DPMF|C_ToggleBurnRole patron id account toggle)
            )
        )
    )
    (defun DPMF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_ToggleFreezeAccount patron id account toggle)
            )
        )
    )
    (defun DPMF|C_TogglePause (patron:string id:string toggle:bool)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_TogglePause patron id toggle)
            )
        )
    )
    (defun DPMF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_ToggleTransferRole patron id account toggle)
            )
        )
    )
    (defun DPMF|C_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Transfers a DPMF Token, trasnfering an amount smaller than or equal to DPMF nonce amount"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_Transfer patron id nonce sender receiver transfer-amount method)
            )
        )
    )
    (defun DPMF|C_Wipe (patron:string id:string atbw:string)
        @doc "Similar to its DPTF Variant"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|TS)
                (ref-DPMF::C_Wipe patron id atbw)
            )
        )
    )
    ;;{ATS_Client}
    (defun ATS|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for ATSPair <entity-id> costing 500 IGNIS"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|TS)
                (ref-ATS::C_UpdatePendingBranding patron entity-id logo description website social)
            )
        )
    )
    (defun ATS|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Similar to its DPTF|DPMF Variant"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATS:module{Autostake} ATS)
                (ref-ORBR:module{Ouroboros} OUROBOROS)
            )
            (with-capability (P|TS)
                (ref-ATS::C_UpgradeBranding patron entity-id months)
                (ref-ORBR::C_Fuel (ref-DALOS::GOV|DALOS|SC_NAME))
            )
        )
    )
    ;;
    (defun ATS|C_AddHotRBT (patron:string ats:string hot-rbt:string)
        @doc "Adds a Hot-RBT to an ATS-Pair \
        \ Must be a DPMF Token and cannot be a Vested counterpart of a DPTF Token"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_AddHotRBT patron ats hot-rbt)
            )
        )
    )
    (defun ATS|C_AddSecondary (patron:string ats:string reward-token:string rt-nfr:bool)
        @doc "Adds a Secondary RT to an ATSPair"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_AddSecondary patron ats reward-token rt-nfr)
            )
        )
    )
    (defun ATS|C_Coil:decimal (patron:string coiler:string ats:string rt:string amount:decimal)
        @doc "Coils an RT Token from a specific ATSPair, generating a RBT Token"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_Coil patron coiler ats rt amount)
            )
        )
    )
    (defun ATS|C_ColdRecovery (patron:string recoverer:string ats:string ra:decimal)
        @doc "Recovers Cold-RBT, disolving it, generating cullable RTs in the future."
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_ColdRecovery patron recoverer ats ra)
            )
        )
    )
    (defun ATS|C_Cull:[decimal] (patron:string culler:string ats:string)
        @doc "Culls an ATSPair, extracting RTs that are cullable"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_Cull patron culler ats)
            )
        )
    )
    (defun ATS|C_Curl:decimal (patron:string curler:string ats1:string ats2:string rt:string amount:decimal)
        @doc "Curls an RT Token from a specific ATSPair, and the subsequent generated RBT Token, is curled again in a second ATSPair, \
            \ outputing the RBT in from this second ATSPair. Works only if the RBT in the first ATSPair is RT in the second ATSPair"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_Curl patron curler ats1 ats2 rt amount)
            )
        )
    )
    (defun ATS|C_Fuel (patron:string fueler:string ats:string reward-token:string amount:decimal)
        @doc "Fuels an ATSPair with RT Tokens, increasing its Index"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_Fuel patron fueler ats reward-token amount)
            )
        )
    )
    (defun ATS|C_HotRecovery (patron:string recoverer:string ats:string ra:decimal)
        @doc "Converts a Cold-RBT to a Hot-RBT, preparing it for Hot Recovery"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_HotRecovery patron recoverer ats ra)
            )
        )
    )
    (defun ATS|C_Issue:[string] (patron:string account:string ats:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string] rbt-nfr:[bool])
        @doc "Issues and Autostake Pair"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-ATS:module{Autostake} ATS)
                    (ref-ORBR:module{Ouroboros} OUROBOROS)
                    (output:[string] (ref-ATS::C_Issue patron account ats index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr))
                )
                (ref-ORBR::C_Fuel (ref-DALOS::GOV|DALOS|SC_NAME))
                output
            )
        )
    )
    (defun ATS|C_KickStart:decimal (patron:string kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal)
        @doc "Kickstarst an ATSPair, so that it starts at a given Index \
            \ Can only be done on a freshly created ATSPair"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_KickStart patron kickstarter ats rt-amounts rbt-request-amount)
            )
        )
    )
    (defun ATS|C_ModifyCanChangeOwner (patron:string ats:string new-boolean:bool)
        @doc "Modifies <can-change-owner> for the ATSPair"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_ModifyCanChangeOwner patron ats new-boolean)
            )
        )
    )
    (defun ATS|C_RecoverHotRBT (patron:string recoverer:string id:string nonce:integer amount:decimal)
        @doc "Recovers a Hot-RBT, converting back to Cold-RBT, \
            \ using an amount smaller than or equal to DPMF Nonce amount"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_RecoverHotRBT patron recoverer id nonce amount)
            )
        )
    )
    (defun ATS|C_RecoverWholeRBTBatch (patron:string recoverer:string id:string nonce:integer)
        @doc "Recovers a Hot-RBT, converting back to Cold-RBT, \
            \ using the whole DPMF nonce amount"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_RecoverWholeRBTBatch patron recoverer id nonce)
            )
        )
    )
    (defun ATS|C_Redeem (patron:string redeemer:string id:string nonce:integer)
        @doc "Redeems a Hot-RBT, recovering RTs"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_Redeem patron redeemer id nonce)
            )
        )
    )
    (defun ATS|C_RemoveSecondary (patron:string remover:string ats:string reward-token:string)
        @doc "Removes a Secondary RT from an ATSPair. \
            \ Only secondary RTs that were added after ATSPair creation can be removed. \
            \ Removing an RT this way must be done by adding the primary RT back into the Pool."
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_RemoveSecondary patron remover ats reward-token)
            )
        )
    )
    (defun ATS|C_RotateOwnership (patron:string ats:string new-owner:string)
        @doc "Rotates ATSPair Ownership"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_RotateOwnership patron ats new-owner)
            )
        )
    )
    (defun ATS|C_SetColdFee (patron:string ats:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        @doc "Sets ATSPair Cold Recovery Fee"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_SetColdFee patron ats fee-positions fee-thresholds fee-array)
            )
        )
    )
    (defun ATS|C_SetCRD (patron:string ats:string soft-or-hard:bool base:integer growth:integer)
        @doc "Sets ATSPair Cold Recovery Duration"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_SetCRD patron ats soft-or-hard base growth)
            )
        )
    )
    (defun ATS|C_SetHotFee (patron:string ats:string promile:decimal decay:integer)
        @doc "Sets ATSPair Hot Recovery Fee"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_SetHotFee patron ats promile decay)
            )
        )
    )
    (defun ATS|C_Syphon (patron:string syphon-target:string ats:string syphon-amounts:[decimal])
        @doc "Syphons from an ATS Pair, extracting RTs and decreasing ATSPair Index. \
            \ Syphoning can be executed until the set up Syphon limit is achieved"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_Syphon patron syphon-target ats syphon-amounts)
            )
        )
    )
    (defun ATS|C_ToggleElite (patron:string ats:string toggle:bool)
        @doc "Toggles ATSPair Elite Functionality"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_ToggleElite patron ats toggle)
            )
        )
    )
    (defun ATS|C_ToggleFeeSettings (patron:string ats:string toggle:bool fee-switch:integer)
        @doc "Toggles ATSPair Fee Settings"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|TS)
                (ref-ATS::C_ToggleFeeSettings patron ats toggle fee-switch)
            )
        )
    )
    (defun ATS|C_ToggleParameterLock (patron:string ats:string toggle:bool)
        @doc "Toggle ATSPair Parameter Lock"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ref-ORBR:module{Ouroboros} OUROBOROS)
                (collect:bool
                    (with-capability (P|TS)
                        (ref-ATSU::C_ToggleParameterLock patron ats toggle)
                    )
                )
            )
            (with-capability (SECURE)
                (XI_Collect collect)
            )
        )
    )
    (defun ATS|C_ToggleSyphoning (patron:string ats:string toggle:bool)
        @doc "Toggles ATSPair syphoning capability"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_ToggleSyphoning patron ats toggle)
            )
        )
    )
    (defun ATS|C_TurnRecoveryOff (patron:string ats:string cold-or-hot:bool)
        @doc "Turns ATSPair Recovery off"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|TS)
                (ref-ATS::C_TurnRecoveryOff patron ats cold-or-hot)
            )
        )
    )
    (defun ATS|C_TurnRecoveryOn (patron:string ats:string cold-or-hot:bool)
        @doc "Turns ATSPair Cold or Hot Recovery On"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_TurnRecoveryOn patron ats cold-or-hot)
            )
        )
    )
    (defun ATS|C_UpdateSyphon (patron:string ats:string syphon:decimal)
        @doc "Updates Syphone Value, the decimal ATS-Index, until the ATSPair can be syphoned"
        (let
            (
                (ref-ATSU:module{AutostakeUsage} ATSU)
            )
            (with-capability (P|TS)
                (ref-ATSU::C_UpdateSyphon patron ats syphon)
            )
        )
    )
    ;;{VST_Client}
    (defun VST|C_CoilAndVest:decimal (patron:string coiler-vester:string ats:string coil-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        @doc "Coils a DPTF Token and Vests its output to <target-account> \
            \ Requires that: \
            \ *]Input DPTF is part of an ATSPair, the <ats> \
            \ *]That the Cold-RBT of <ats> has a vested counterpart \
            \ \
            \ Outputs the resulted Vested Cold-RBT Amount"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ref-VST:module{Vesting} VST)
                (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                (c-rbt-amount:decimal (ref-ATS::URC_RBT ats coil-token amount))
            )
            (ref-ATSU::C_Coil patron coiler-vester ats coil-token amount)
            (ref-VST::C_Vest patron coiler-vester target-account c-rbt c-rbt-amount offset duration milestones)
            c-rbt-amount
        )
    )
    (defun VST|C_CreateVestingLink:string (patron:string dptf:string)
        @doc "Creates a Vested Link; \
            \ A Vested Link, means, issuing a DPMF as a vested counterpart for a DPTF \
            \ The Vested Link is immutable, meaning, this DPMF will always act as a vested counterpart for the DPTF Token, \
            \ and will be recorded as such in both the DPTF and DPMF Token Properties."
        (let
            (
                (ref-VST:module{Vesting} VST)
            )
            (with-capability (P|TS)
                (ref-VST::C_CreateVestingLink patron dptf)
            )
        )
    )
    (defun VST|C_Cull (patron:string culler:string id:string nonce:integer)
        @doc "Culls the Vested Token, recovering its original non vested DPTF counterpart."
        (let
            (
                (ref-VST:module{Vesting} VST)
            )
            (with-capability (P|TS)
                (ref-VST::C_Cull patron culler id nonce)
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
        (let*
            (
                (ref-ATS:module{Autostake} ATS)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ref-VST:module{Vesting} VST)
                (c-rbt1:string (ref-ATS::UR_ColdRewardBearingToken ats1))
                (c-rbt1-amount:decimal (ref-ATS::URC_RBT ats1 curl-token amount))
                (c-rbt2:string (ref-ATS::UR_ColdRewardBearingToken ats2))
                (c-rbt2-amount:decimal (ref-ATS::URC_RBT ats2 c-rbt1 c-rbt1-amount))
            )
            (ref-ATSU::C_Curl patron curler-vester ats1 ats2 curl-token amount)
            (ref-VST::C_Vest patron curler-vester target-account c-rbt2 c-rbt2-amount offset duration milestones)
            c-rbt2-amount
        )
    )
    (defun VST|C_Vest (patron:string vester:string target-account:string id:string amount:decimal offset:integer duration:integer milestones:integer)
        @doc "Vests a DPTF Token, issuing a Vested Token"
        (let
            (
                (ref-VST:module{Vesting} VST)
            )
            (with-capability (P|TS)
                (ref-VST::C_Vest patron vester target-account id amount offset duration milestones)
            )
        )
    )
    ;;{LIQUID_Client}
    (defun LQD|C_UnwrapKadena (patron:string unwrapper:string amount:decimal)
        @doc "Unwraps DPTF Kadena to Native Kadena"
        (let
            (
                (ref-LIQUID:module{KadenaLiquidStaking} LIQUID)
            )
            (with-capability (P|TS)
                (ref-LIQUID::C_UnwrapKadena patron unwrapper amount)
            )
        )
    )
    (defun LQD|C_WrapKadena (patron:string wrapper:string amount:decimal)
        @doc "Wraps Native Kadena to DPTF Kadena"
        (let
            (
                (ref-LIQUID:module{KadenaLiquidStaking} LIQUID)
            )
            (with-capability (P|TS)
                (ref-LIQUID::C_WrapKadena patron wrapper amount)
            )
        )
    )
    ;;{OUROBOROS_Client}
    (defun ORBR|C_Compress:decimal (patron:string client:string ignis-amount:decimal)
        @doc "Compresses IGNIS - Ouronet Gas Token, generating OUROBOROS \
                \ Only whole IGNIS Amounts greater than or equal to 1.0 can be used for compression \
                \ Similar to Sublimation, the output amount is dependent on OUROBOROS price, set at a minimum of 1$ \
                \ Compression costs 1.5% in output fees, the OUROBOROS Fee is transmuted \
                \ Transmutation is set to increase Auryn Index"
        (let
            (
                (ref-ORBR:module{Ouroboros} OUROBOROS)
            )
            (with-capability (P|TS)
                (ref-ORBR::C_Compress patron client ignis-amount)
            )
        )
    )
    (defun ORBR|C_Sublimate:decimal (patron:string client:string target:string ouro-amount:decimal)
        @doc "Sublimates OUROBOROS, generating Ouronet Gas, in form of IGNIS Token \
                \ A minimum amount of 1 input OUROBOROS is required. Amount of IGNIS generated depends on OUROBOROS Price in $, \
                \ with the minimum value being set at 1$ (in case the actual value is lower than 1$ \
                \ Prior to computing the Ignis Amount, a fee of 1% is deducted. This OURO amount is transmuted. \
                \ Transmutation is set to increase Auryn Index."
        (let
            (
                (ref-ORBR:module{Ouroboros} OUROBOROS)
            )
            (with-capability (P|TS)
                (ref-ORBR::C_Sublimate patron client target ouro-amount)
            )
        )
    )
    (defun ORBR|C_WithdrawFees (patron:string id:string target:string)
        @doc "Withdraws collected DPTF Fees collected in standard mode \
        \ DPTF Fees collected in standard mode cumullate on the OUROBOROS Smart Account \
        \ Only the Token Owner can withdraw these fees."
        (let
            (
                (ref-ORBR:module{Ouroboros} OUROBOROS)
            )
            (with-capability (P|TS)
                (ref-ORBR::C_WithdrawFees patron id target)
            )
        )
    )
    ;;{Swapper_Client}
    (defun SWP|C_ChangeOwnership (patron:string swpair:string new-owner:string)
        @doc "Changes Ownership of an SWPair"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (P|TS)
                (ref-SWP::C_ChangeOwnership patron swpair new-owner)
            )
        )
    )
    (defun SWP|C_IssueStable:[string] (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal amp:decimal p:bool)
        @doc "Issues a Stable Liquidity Pool. First Token in the liquidity Pool must have a connection to a principal Token \
        \ Stable Pools have the S designation. \
        \ Stable Pools can be created with up to 7 Tokens, and have by design equal weighting. \
        \ The <p> boolean defines if The Pool is a Principal Pools. \
        \ Principal Pools are always on, and cant be disabled by low-liquidity."
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-SWP:module{Swapper} SWP)
                    (ref-ORBR:module{Ouroboros} OUROBOROS)
                    (weights:[decimal] (make-list (length pool-tokens) 1.0))
                    (output:[string] (ref-SWP::C_Issue patron account pool-tokens fee-lp weights amp p))
                )
                (ref-ORBR::C_Fuel (ref-DALOS::GOV|DALOS|SC_NAME))
                output
            )
        ) 
    )
    (defun SWP|C_IssueStandard:[string] (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal p:bool)
        @doc "Issues a Standard, Constant Product Pool. \
            \ Constant Product Pools have the P Designation, and they are by design equal weigthed \
            \ Can also be created with up to 7 Tokens, also the <p> boolean determines if its a Principal Pool or not \
            \ The First Token must be a Principal Token"
        (SWP|C_IssueStable patron account pool-tokens fee-lp -1.0 p)
    )
    (defun SWP|C_IssueWeighted:[string] (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool)
        @doc "Issues a Weigthed Constant Liquidity Pool \
            \ Weigthed Pools have the W Designation, and the weights can be changed at will. \
            \ Can also be created with up to 7 Tokens, <p> boolean determines if its a Principal Pool or not \
            \ The First Token must also be a Principal Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-SWP:module{Swapper} SWP)
                    (ref-ORBR:module{Ouroboros} OUROBOROS)
                    (output:[string] (ref-SWP::C_Issue patron account pool-tokens fee-lp weights -1.0 p))
                )
                (ref-ORBR::C_Fuel (ref-DALOS::GOV|DALOS|SC_NAME))
                output
            )          
        )
    )
    (defun SWP|C_ModifyCanChangeOwner (patron:string swpair:string new-boolean:bool)
        @doc "Modifies the <can-change-owner> parameter of an SWPair"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (P|TS)
                (ref-SWP::C_ModifyCanChangeOwner patron swpair new-boolean)
            )
        )
    )
    (defun SWP|C_ModifyWeights (patron:string swpair:string new-weights:[decimal])
        @doc "Modify weights for an SWPair. Works only for W Pools"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (P|TS)
                (ref-SWP::C_ModifyWeights patron swpair new-weights)
            )
        )
    )
    (defun SWP|C_RotateGovernor (patron:string swpair:string new-gov:guard)
        @doc "Rotates the Governor for an Swpair \
            \ The Governor is enforced when Pool is in Special Mode"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (P|TS)
                (ref-SWP::C_RotateGovernor patron swpair new-gov)
            )
        )
    )
    (defun SWP|C_ToggleAddOrSwap (patron:string swpair:string toggle:bool add-or-swap:bool)
        @doc "When <toggle> is <true>, ensures required Mint, Burn, Transfer Roles are set, if not, set them. \
            \ The Roles are: \
            \ Mint and Burn Roles for LP Token (requires LP Token Ownership) \
            \ Fee Exemption Roles for all Tokens of an S-Pool, or \
            \ for all Tokens of a W- or P-Pool, except its first Token (which is principal) \
            \ Roles are needed to SWP|SC_NAME"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (P|TS)
                (ref-SWP::C_ToggleAddOrSwap patron swpair toggle add-or-swap)
            )
        )
    )
    (defun SWP|C_ToggleFeeLock (patron:string swpair:string toggle:bool)
        @doc "Locks the SPWPair fees in place. Modifying the SWPair fees requires them to be unlocked \
            \ Unlocking costs KDA and is financially discouraged"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
                (collect:bool
                    (with-capability (P|TS)
                        (ref-SWP::C_ToggleFeeLock patron swpair toggle)
                    )
                )
            )
            (with-capability (SECURE)
                (XI_Collect collect)
            )
        )
    )
    (defun SWP|C_ToggleSpecialMode (patron:string swpair:string)
        @doc "Toggles Special Mode for an SWPair \
            \ When Special Mode is on, SWPair Governor is enforced when adding or removing Liquidity \
            \ This allows for example, for coding special rules when adding liquidity, in a separate module \
            \ That provides the governing permissions, that is, adding liquidity can only be executed following this special rules \
            \ This allows for example, to add Liquidity Tokens using Meta-Tokens, as a functionality example"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (P|TS)
                (ref-SWP::C_ToggleSpecialMode patron swpair)
            )
        )
    )
    (defun SWP|C_UpdateAmplifier (patron:string swpair:string amp:decimal)
        @doc "Updates Amplifier Value; Only works on S-Pools (Stable Pools)"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (P|TS)
                (ref-SWP::C_UpdateAmplifier patron swpair amp)
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
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (P|TS)
                (ref-SWP::C_UpdateFee patron swpair new-fee lp-or-special)
            )
        )
    )
    (defun SWP|C_UpdateLP (patron:string swpair:string lp-token:string add-or-remove:bool)
        @doc "Updates the LP Tokens of an swpair"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (P|TS)
                (ref-SWP::C_UpdateLP patron swpair lp-token add-or-remove)
            )
        )
    )
    (defun SWP|C_UpdateSpecialFeeTargets (patron:string swpair:string targets:[object{Swapper.FeeSplit}])
        @doc "Updates the Special Fee Targets, along with their Split, for an SWPair"
        (let
            (
                (ref-SWP:module{Swapper} SWP)
            )
            (with-capability (P|TS)
                (ref-SWP::C_UpdateSpecialFeeTargets patron swpair targets)
            )
        )
    )
    ;;
    (defun SWP|C_AddBalancedLiquidity:decimal (patron:string account:string swpair:string input-id:string input-amount:decimal)
        @doc "Using input only an <input-id> and its <input-amount> \
            \ Adds Liquidity in a balanced mode, on the <swpair>"
        (let
            (
                (ref-SWPU:module{SwapperUsage} SWPU)
            )
            (with-capability (P|TS)
                (ref-SWPU::SWPL|C_AddBalancedLiquidity patron account swpair input-id input-amount)
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
        (let
            (
                (ref-SWPU:module{SwapperUsage} SWPU)
            )
            (with-capability (P|TS)
                (ref-SWPU::SWPL|C_AddLiquidity patron account swpair input-amounts)
            )
        )
    )
    (defun SWP|C_RemoveLiquidity:[decimal] (patron:string account:string swpair:string lp-amount:decimal)
        @doc "Removes Liquidity from a Liquidity Pool \
            \ Removing Liquidty is always done at the current Token Ratio. \
            \ Removing Liquidty complety leaving the pool exactly empty (0.0 tokens) is fully supported"
        (let
            (
                (ref-SWPU:module{SwapperUsage} SWPU)
            )
            (with-capability (P|TS)
                (ref-SWPU::SWPL|C_RemoveLiquidity patron account swpair lp-amount)
            )
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
        )
        @doc "Executes a Swap between one or multiple input tokens to an output token, on an <swpair> \
            \ Up to <n-1> input ids can be used for a swap, where <n> is the number of pool Tokens"
        (let
            (
                (ref-SWPU:module{SwapperUsage} SWPU)
            )
            (with-capability (P|TS)
                (ref-SWPU::SWPS|C_MultiSwap patron account swpair input-ids input-amounts output-id)
            )
        )
    )
    ;;
    (defun XI_Collect (iz-collect:bool)
        (require-capability (SECURE))
        (if iz-collect
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-ORBR:module{Ouroboros} OUROBOROS)
                )
                (with-capability (P|TS)
                    (ref-ORBR::C_Fuel (ref-DALOS::GOV|DALOS|SC_NAME))
                )
            )
            true
        )
    )

)

(create-table P|T)