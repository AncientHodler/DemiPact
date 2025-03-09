(interface TalosStageOne_Admin
    ;;
    ;;DALOS Functions
    (defun DALOS|A_MigrateLiquidFunds:decimal (migration-target-kda-account:string))
    (defun DALOS|A_ToggleGAP (gap:bool))
    (defun DALOS|A_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)) ;d
    (defun DALOS|A_DeployStandardAccount (account:string guard:guard kadena:string public:string)) ;d
    (defun DALOS|A_IgnisToggle (native:bool toggle:bool)) ;d
    (defun DALOS|A_SetIgnisSourcePrice (price:decimal)) ;d
    (defun DALOS|A_SetAutoFueling (toggle:bool)) ;d
    (defun DALOS|A_UpdatePublicKey (account:string new-public:string)) ;d
    (defun DALOS|A_UpdateUsagePrice (action:string new-price:decimal)) ;d
    ;;
    ;;
    ;;BRD Functions
    (defun BRD|A_Live (entity-id:string)) ;d
    (defun BRD|A_SetFlag (entity-id:string flag:integer)) ;d
    ;;
    ;;
    ;;LIQUID Functions
    (defun LIQUID|A_MigrateLiquidFunds:decimal (migration-target-kda-account:string))
    ;;
    ;;
    ;;ORBR Functions
    (defun ORBR|A_Fuel ()) ;d
    ;;
    ;;
    ;;SWP Functions
    (defun SWP|A_UpdatePrincipal (principal:string add-or-remove:bool)) ;d
    (defun SWP|A_UpdateLimit (limit:decimal spawn:bool)) ;d
    (defun SWP|A_UpdateLiquidBoost (new-boost-variable:bool)) ;d
    ;;
    ;;
    ;;Fueling Functions
    (defun XB_DynamicFuelKDA ())
    (defun XE_IgnisCollect (patron:string account:string input-ico:[object{OuronetDalos.IgnisCumulator}]))
    (defun XE_ConditionalFuelKDA (condition:bool))
)
(module TS01-A GOV
    @doc "TALOS Stage 1 Administrator Functions \
    \ Contains All Administrator functions [DALOS BRD ORBR SWP]\
    \ Also contains Fueling Functions needed in all subsequent TALOS Modules"
    ;;
    (implements OuronetPolicy)
    (implements TalosStageOne_Admin)
    ;;{G1}
    (defconst GOV|MD_TS01-A         (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TS01-A_ADMIN)))
    (defcap GOV|TS01-A_ADMIN ()     (enforce-guard GOV|MD_TS01-A))
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
    (defcap P|ADMINISTRATIVE-SUMMONER ()
        (compose-capability (P|TS))
        (compose-capability (GOV|TS01-A_ADMIN))
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
        (with-capability (GOV|TS01-A_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|TS01-A_ADMIN)
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
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|LIQUID:module{OuronetPolicy} LIQUID)
                (ref-P|ORBR:module{OuronetPolicy} OUROBOROS)
                (ref-P|SWP:module{OuronetPolicy} SWP)
                (mg:guard (create-capability-guard (P|TS)))
            )
            (ref-P|DALOS::P|A_Add 
                "TS01-A|RemoteDalosGov"
                (create-capability-guard (P|TRG))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|LIQUID::P|A_AddIMP mg)
            (ref-P|ORBR::P|A_AddIMP mg)
            (ref-P|SWP::P|A_AddIMP mg)
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
    ;;{DALOS_Administrator}
    (defun DALOS|A_MigrateLiquidFunds:decimal (migration-target-kda-account:string)
        @doc "Migrates Ouronet Gas Station Funds, to another kda adress, \
        \ if needed due to a migration to a new namespace and new module code \
        \ Outputs the migrated amount"
        (with-capability (P|ADMINISTRATIVE-SUMMONER)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                )
                (ref-DALOS::A_MigrateLiquidFunds migration-target-kda-account)
            )
        )
    )
    (defun DALOS|A_ToggleGAP (gap:bool)
        @doc "Toggles the Global administrative Pause, the GAP, to <toggle>"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                )
                (ref-DALOS::A_ToggleGAP gap)
            )
        )
    )
    (defun DALOS|A_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        @doc "Deploys a Smart Ouronet Account in Administrator Mode, without collection KDA"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                )
                (ref-DALOS::A_DeploySmartAccount account guard kadena sovereign public)
            )
        )
        
    )
    (defun DALOS|A_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        @doc "Deploys a Standard Ouronet Account in Administrator Mode, without collection KDA"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                )
                (ref-DALOS::A_DeployStandardAccount account guard kadena public)
            )
        )
    )
    (defun DALOS|A_IgnisToggle (native:bool toggle:bool)
        @doc "Toggles Ouronet Gas Collection \
        \ <native> true is KDA Collection for Specific Usage Actions \
        \ <native> false is IGNIS Collection for Client Functions"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                )
                (ref-DALOS::A_IgnisToggle native toggle)
            )
        )
    )
    (defun DALOS|A_SetIgnisSourcePrice (price:decimal)
        @doc "Sets OUROBOROS Price in $. Used in Compresion and Sublimation"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                )
                (ref-DALOS::A_SetIgnisSourcePrice price)
            )
        )
    )
    (defun DALOS|A_SetAutoFueling (toggle:bool)
        @doc "Sets Automatic fueling of Collected KDA for the Increase of the <KdaLiquindex>"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                )
                (ref-DALOS::A_SetAutoFueling toggle)
            )
        )
    )
    (defun DALOS|A_UpdatePublicKey (account:string new-public:string)
        @doc "Updates Public Key; To be used only as failsafe by the Admin"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                )
                (ref-DALOS::A_UpdatePublicKey account new-public)
            )
        )
    )
    (defun DALOS|A_UpdateUsagePrice (action:string new-price:decimal)
        @doc "Updates specific Usage Price in KDA"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                )
                (ref-DALOS::A_UpdateUsagePrice action new-price)
            )
        )
    )
    ;;{BRD_Administrator}
    (defun BRD|A_Live (entity-id:string)
        @doc "Sets <pending-branding> for an <entity-id> to <live-branding>, reseting <pending-branding> data \
            \ Resetting <pending-branding> data does not reset its last 3 keys \
            \ Can only be done by Branding Administrator"
        (with-capability (P|TS)
            (let
                (
                    (ref-BRD:module{Branding} BRD)
                )
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
        (with-capability (P|TS)
            (let
                (
                    (ref-BRD:module{Branding} BRD)
                )
                (ref-BRD::A_SetFlag entity-id flag)
            )
        )
    )
    ;;{LIQUID_Administrator}
    (defun LIQUID|A_MigrateLiquidFunds:decimal (migration-target-kda-account:string)
        @doc "Migrates Kadena Liquid Staking KDA Funds, to another kda adress, \
        \ if needed due to a migration to a new namespace and new module code \
        \ Outputs the migrated amount"
        (with-capability (P|ADMINISTRATIVE-SUMMONER)
            (let
                (
                    (ref-LIQUID:module{KadenaLiquidStaking} LIQUID)
                )
                (ref-LIQUID::A_MigrateLiquidFunds migration-target-kda-account)
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
        (with-capability (P|ADMINISTRATIVE-SUMMONER)
            (let
                (
                    (ref-SWP:module{Swapper} SWP)
                )
                (ref-SWP::A_UpdatePrincipal principal add-or-remove)
            )
        )
    )
    (defun SWP|A_UpdateLimit (limit:decimal spawn:bool)
        @doc "Updates either the <spawn-limit> or <inactive-limit> for the SWP Module \
        \ The <spawn-limit> is the minimum number in KDA that a pool must be created with, in order to be opened for swap \
        \ The <inactive-limit> is the minimum number in KDA as total pool liquidity value, that trigger autonomic disable of the swap mechanism"
        (with-capability (P|ADMINISTRATIVE-SUMMONER)
            (let
                (
                    (ref-SWP:module{Swapper} SWP)
                )
                (ref-SWP::A_UpdateLimit limit spawn)
            )
        )

    )
    (defun SWP|A_UpdateLiquidBoost (new-boost-variable:bool)
        @doc "Updates Liquid Boost switch. When set to true, every swap is set to pump the Index for Kadena Liquid Staking"
        (with-capability (P|ADMINISTRATIVE-SUMMONER)
            (let
                (
                    (ref-SWP:module{Swapper} SWP)
                )
                (ref-SWP::A_UpdateLiquidBoost new-boost-variable)
            )
        )

    )
    ;;Fueling Functions
    (defun XB_DynamicFuelKDA ()
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (if (ref-DALOS::UR_AutoFuel)
                (with-capability (SECURE)
                    (XI_DirectFuelKDA)
                )
                true
            )
        )
    )
    ;;
    (defun XE_IgnisCollect (patron:string account:string input-ico:[object{OuronetDalos.IgnisCumulator}])
        @doc "Collects Ignis given input parameters"
        (UEV_IMC)
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
    (defun XE_ConditionalFuelKDA (condition:bool)
        (UEV_IMC)
        (if condition
            (with-capability (SECURE)
                (XB_DynamicFuelKDA)
            )
            true
        )
    )
    ;;
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
)

(create-table P|T)
(create-table P|MT)