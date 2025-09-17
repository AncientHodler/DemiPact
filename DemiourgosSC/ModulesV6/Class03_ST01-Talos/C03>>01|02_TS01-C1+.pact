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
(module TS01-C1 GOV
    @doc "TALOS Stage 1 Client Functiones Part 1"
    ;;
    (implements OuronetPolicy)
    (implements TalosStageOne_ClientOneV4)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_TS01-C1        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TS01-C1_ADMIN)))
    (defcap GOV|TS01-C1_ADMIN ()    (enforce-guard GOV|MD_TS01-C1))
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
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                (mg:guard (create-capability-guard (P|TALOS-SUMMONER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|DPMF::P|A_AddIMP mg)
            (ref-P|ATS::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
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
    ;;  [DALOS_Client]
    (defun DALOS|C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool)
        @doc "Controls Smart Ouronet Account properties via boolean triggers"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-I|DALOS:module{DalosInfoV2} DALOS)
                    (info:object{OuronetInfoV2.ClientInfo} 
                        (ref-I|DALOS::DALOS-INFO|URC_ControlSmartAccount patron account)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DALOS::C_ControlSmartAccount account payable-as-smart-contract payable-by-smart-contract payable-by-method)
                )
                (at 0 (at "post-text" info))
            )
        )
    )
    (defun DALOS|C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        @doc "Deploys a Standard Ouronet Account, taxing for KDA"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ref-I|DALOS:module{DalosInfoV2} DALOS)
                    (info:object{OuronetInfoV2.ClientInfo}
                        (ref-I|DALOS::DALOS-INFO|URC_DeploySmartAccount account)
                    )
                )
                (ref-DALOS::C_DeploySmartAccount account guard kadena sovereign public)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at 0 (at "post-text" info))
            )
        )
    )
    (defun DALOS|C_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        @doc "Deploys a Standard Ouronet Account, taxing for KDA"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ref-I|DALOS:module{DalosInfoV2} DALOS)
                    (info:object{OuronetInfoV2.ClientInfo}
                        (ref-I|DALOS::DALOS-INFO|URC_DeployStandardAccount account)
                    )
                )
                (ref-DALOS::C_DeployStandardAccount account guard kadena public)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at 0 (at "post-text" info))
            )
        )
    )
    (defun DALOS|C_RotateGovernor (patron:string account:string governor:guard)
        @doc "Rotates the governor of a Smart Ouronet Account \
        \ The Governor acts as a governing entity for the Smart Ouronet Account allowing fine control of its assets"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-I|DALOS:module{DalosInfoV2} DALOS)
                    (info:object{OuronetInfoV2.ClientInfo}
                        (ref-I|DALOS::DALOS-INFO|URC_RotateGovernor patron account)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DALOS::C_RotateGovernor account governor)
                )
                (at 0 (at "post-text" info))
            )
        )
    )
    (defun DALOS|C_RotateGuard (patron:string account:string new-guard:guard safe:bool)
        @doc "Rotates the guard of an Ouronet Safe. Boolean <safe> also enforces the <new-guard>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-I|DALOS:module{DalosInfoV2} DALOS)
                    (info:object{OuronetInfoV2.ClientInfo}
                        (ref-I|DALOS::DALOS-INFO|URC_RotateGuard patron account)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DALOS::C_RotateGuard account new-guard safe)
                )
                (at 0 (at "post-text" info))
            )
        )
    )
    (defun DALOS|C_RotateKadena (patron:string account:string kadena:string)
        @doc "Rotates the KDA Account attached to an Ouronet Account. \
        \ The attached KDA Account is the account that makes KDA Payments for specific Ouronet Actions"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-I|DALOS:module{DalosInfoV2} DALOS)
                    (info:object{OuronetInfoV2.ClientInfo}
                        (ref-I|DALOS::DALOS-INFO|URC_RotateKadena patron account)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DALOS::C_RotateKadena account kadena)
                )
                (at 0 (at "post-text" info))
            )
        )
    )
    (defun DALOS|C_RotateSovereign (patron:string account:string new-sovereign:string)
        @doc "Rotates the Sovereign of a Smart Ouronet Account \
        \ The Sovereign of a Smart Ouronet Account acts as its owner, allowing dominion over its assets"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-I|DALOS:module{DalosInfoV2} DALOS)
                    (info:object{OuronetInfoV2.ClientInfo}
                        (ref-I|DALOS::DALOS-INFO|URC_RotateSovereign patron account)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DALOS::C_RotateSovereign account new-sovereign)
                )
                (at 0 (at "post-text" info))
            )
        )
    )
    (defun DALOS|C_UpdateEliteAccount (patron:string account:string)
        @doc "Manualy Updates the Demiourgos Elite Account for one Ouronet Account in case of emergency. \
        \ Can be used without account ownership by anyone."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-I|DALOS:module{DalosInfoV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                    (ea-id:string (ref-DALOS::EliteAurynID))
                    (info:object{OuronetInfoV2.ClientInfo}
                        (ref-I|DALOS::DALOS-INFO|URC_UpdateEliteAccount patron account)
                    )
                )
                (ref-DPMF::XB_UpdateEliteSingle ea-id account)
                (ref-IGNIS::IC|C_Collect patron
                    (ref-IGNIS::IC|UDC_SmallCumulator patron)
                )
                (at 0 (at "post-text" info))
            )
        )
    )
    (defun DALOS|C_UpdateEliteAccountSquared (patron:string sender:string receiver:string)
        @doc "Manualy Updates the Demiourgos Elite Account for two Ouronet Accounts in case of emergency. \
        \ Can be used without account ownership by anyone."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-I|DALOS:module{DalosInfoV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                    (ea-id:string (ref-DALOS::EliteAurynID))
                    (info:object{OuronetInfoV2.ClientInfo}
                        (ref-I|DALOS::DALOS-INFO|URC_UpdateEliteAccountSquared patron sender receiver)
                    )
                )
                (ref-DPMF::XB_UpdateElite ea-id sender receiver)
                (ref-IGNIS::IC|C_Collect patron
                    (ref-IGNIS::IC|UDC_MediumCumulator patron)
                )
                (at 0 (at "post-text" info))
            )
        )
    )
    ;;  [DPTF_Client]
    (defun DPTF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for DPTF Token <entity-id> costing 100 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-B|DPTF:module{BrandingUsageV7} DPTF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-B|DPTF::C_UpdatePendingBranding entity-id logo description website social)
                )
                (format "Pending Branding for DPTF {} updated succesfully" [entity-id])
            )
        )
    )
    (defun DPTF|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Upgrades Branding for DPTF Token, making it a premium Branding. \
            \ Also sets pending-branding to live branding if its branding is not live yet"
        (with-capability (P|TS)
            (let
                (
                    (ref-B|DPTF:module{BrandingUsageV7} DPTF)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                )
                (ref-B|DPTF::C_UpgradeBranding patron entity-id months)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (format "DPTF {} succesfully upgraded for {} months(s)!" [entity-id months])
            )
        )
    )
    ;;
    (defun DPTF|C_Burn (patron:string id:string account:string amount:decimal)
        @doc "Burns a DPTF Token from an account"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_Burn id account amount)
                )
                (format "Succesfully burned {} {} on Account {}" [amount id sa])
            )
        )
    )
    (defun DPTF|C_ClearDispo (patron:string account:string)
        @doc "Clears OURO Dispo by levereging existing Elite-Auryn"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV7} TFT)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-TFT::C_ClearDispo account)
                )
            )
        )
    )
    (defun DPTF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool)
        @doc "Controls the properties of a DPTF Token \
            \ <can-change-owner> <can-upgrade> <can-add-special-role> <can-freeze> <can-wipe> <can-pause>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_Control id cco cu casr cf cw cp)
                )
                (format "Succesfully controlled Properties of {}" [id])
            )
        )
    )
    (defun DPTF|C_DeployAccount (patron:string id:string account:string)
        @doc "Deploys a DPTF Account"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
                )
                (ref-DPTF::C_DeployAccount id account)
                (ref-IGNIS::IC|C_Collect patron
                    (ref-IGNIS::IC|UDC_SmallCumulator account)
                )
                (format "DPTF {} added to {} Ouronet Account succesfully!" [id sa])
            )
        )
    )
    (defun DPTF|C_DonateFees (patron:string id:string)
        @doc "Sets the Fee Collection target to the DALOS|SC_NAME \
        \ When DPTF Fees collect here, the will be earned by Ouronet Custodians"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount (ref-DALOS::GOV|DALOS|SC_NAME)))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_SetFeeTarget id (ref-DALOS::GOV|DALOS|SC_NAME))
                )
                (format "Fee Collection succesfully set to {}" [sa])
            )
        )
    )
    (defun DPTF|C_Issue:list (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
        @doc "Issues a new DPTF Token in Bulk, can also be used to issue a single DPTF \
        \ Outputs a string list with the issed DPTF IDs"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-DPTF::C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at "output" ico)
            )
        )
    )
    (defun DPTF|C_Mint (patron:string id:string account:string amount:decimal origin:bool)
        @doc "Mints a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_Mint id account amount origin)
                )
                (if origin
                    (format "Succesfully premined {} {} on Account {}" [amount id sa])
                    (format "Succesfully minted {} {} on Account {}" [amount id sa])
                )
            )
        )
    )
    
    (defun DPTF|C_ResetFeeTarget (patron:string id:string)
        @doc "Sets the Fee Collection target to the OUROBOROS|SC_NAME \
        \ Fees can then be collected by <DPTF|C_WithdrawFees>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount (ref-DALOS::GOV|OUROBOROS|SC_NAME)))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_SetFeeTarget id (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                )
                (format "Fee Collection succesfully set to {}" [sa])
            )
        )
    )
    (defun DPTF|C_RotateOwnership (patron:string id:string new-owner:string)
        @doc "Rotates DPTF ID Ownership"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount new-owner))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_RotateOwnership id new-owner)
                )
                (format "ID {} Ownership succesfully set to {}" [id sa])
            )
        )
    )
    (defun DPTF|C_SetFee (patron:string id:string fee:decimal)
        @doc "Sets a transfer fee for the DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_SetFee id fee)
                )
                (format "Fee Promille succesfully set to {} Promille for {}" [fee id])
            )
        )
    )
    (defun DPTF|C_SetFeeTarget (patron:string id:string target:string)
        @doc "Sets the Fee Collection Target for a DPTF"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount target))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_SetFeeTarget id target)
                )
                (format "Fee Target succesfully set for {} to {}" [id sa])
            )
        )
    )
    (defun DPTF|C_SetMinMove (patron:string id:string min-move-value:decimal)
        @doc "Sets the minimum amount needed to transfer a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_SetMinMove id min-move-value)
                )
                (format "MinMove Value succesfully set for {} to {}" [id min-move-value])
            )
        )
    )
    (defun DPTF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <burn-role> for a DPTF Token <id> on a specific <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATS:module{AutostakeV4} ATS)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATS::DPTF|C_ToggleBurnRole id account toggle)
                )
            )
        )
    )
    (defun DPTF|C_ToggleFee (patron:string id:string toggle:bool)
        @doc "Toggles Fee collection for a DPTF Token. When a DPTF Token is setup with a transfer fee, \
            \ it will come in effect only when the toggle is on(true)"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_ToggleFee id toggle)
                )
                (if toggle
                    (format "Fee Collection activated succesfully for {}" [id])
                    (format "Fee Collection deactivated succesfully for {}" [id])
                )
            )
        )
    )
    (defun DPTF|C_ToggleFeeExemptionRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <fee-exemption-role> for a DPTF Token <id> on a specific <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATS:module{AutostakeV4} ATS)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATS::DPTF|C_ToggleFeeExemptionRole id account toggle)
                )
            )
        )
    )
    (defun DPTF|C_ToggleFeeLock (patron:string id:string toggle:bool)
        @doc "Toggles DPTF Fee Settings Lock"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-DPTF::C_ToggleFeeLock patron id toggle)
                    )
                    (collect:bool (at 0 (at "output" ico)))
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XE_ConditionalFuelKDA collect)
                (if toggle
                    (format "Fee Settings succesfully locked for {}" [id])
                    (format "Fee Settings succesfully unlocked  for {}" [id])
                )
            )
        )
    )
    (defun DPTF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Toggles Freezing of a DPTF Account"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_ToggleFreezeAccount id account toggle)
                )
                (if toggle
                    (format "Account {} succesfully frozen for {}" [sa id])
                    (format "Account {} succesfuly unfrozen for {}" [sa id])
                )
            )
        )
    )
    (defun DPTF|C_ToggleMintRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <mint-role> for a DPTF Token <id> on a specific <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATS:module{AutostakeV4} ATS)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATS::DPTF|C_ToggleMintRole id account toggle)
                )
            )
        )
    )
    (defun DPTF|C_TogglePause (patron:string id:string toggle:bool)
        @doc "Toggles Pause for a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_TogglePause id toggle)
                )
                (if toggle
                    (format "ID {} succesfully pauses" [id])
                    (format "ID {} succesfully unpauses" [id])
                )
            )
        )
    )
    (defun DPTF|C_ToggleReservation (patron:string id:string toggle:bool)
        @doc "Toggles Reservations for a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_ToggleReservation id toggle)
                )
                (if toggle
                    (format "Reservations succesfully opened for {}" [id])
                    (format "Reservations succesfully closed for {}" [id])
                )
            )
        )
    )
    (defun DPTF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <transfer-role> for a DPTF Token <id> on a specific <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_ToggleTransferRole id account toggle)
                )
                (if toggle
                    (format "Transfer Role succesfuly added for {} to {}" [id sa])
                    (format "Transfer Role succesfuly removed for {} to {}" [id sa])
                )
            )
        )
    )
    (defun DPTF|C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal)
        @doc "Transmutes a DPTF Token. Transmuting Uses the whole amount as it if were Primary Fee \
        \ without adding to the Primary Fee Counter. \
        \ Thus it can either be collected to the Fee Target Collector \
        \ or to increase Autostake Indices, if the Id is part of any Autostake Pools \
        \ (and these have the neccesary setting set up in the  required manner) \
        \ Only works for DPTFs that have been setup up with transfer fees. \
        \ One of 3 Variants is automatically chosen for transmutation \
        \   Simple  >> For DPTFs that are not Elite Auryn Class \
        \   Elite   >> For Elite Auryn Class DPTFs that require Elite Account Update"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV7} TFT)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-TFT::C_Transmute id transmuter transmute-amount)
                )
            )
        )
    )
    ;;
    (defun DPTF|C_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Transfers a DPTF Token from <sender> to <receiver>, using the <transfer-amount> and <method> \
        \ It autonomously choose between the 6 Transfer Variants spread over 3 Classes. \
        \ \
        \   Class 1 >> 1 IGNIS Cost \
        \           [CX_Class1Transfer]             Transfers a DPTF with no transfer Fees (also for VTT amounts < 10.0) \
        \           [CX_Class1TransferUnity]        Transfers UNITY with no transfer Fees (amount < 10.0) \
        \   Class 2 >> 2 IGNIS Cost \
        \           [CX_Class2Transfer]             Transfer a DPTF with a transfer Fee \
        \           [CX_Class2TransferUnity]        Transfers Unity with transfer Fee \
        \           [CX_Class2TransferElite]        Transfers EA Class DPTFs with no Fees \
        \   Class 3 >> 3 IGNIS Cost \
        \           [CX_Class3TransferElite]        Transfers EA Class DPTFs with transfer Fees"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV7} TFT)
                    (receiver-amount:decimal (ref-TFT::URC_ReceiverAmount id sender receiver transfer-amount))
                    (sa-s:string (ref-I|OURONET::OI|UC_ShortAccount sender))
                    (sa-r:string (ref-I|OURONET::OI|UC_ShortAccount receiver))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-TFT::C_Transfer id sender receiver transfer-amount method)
                )
                (if (= receiver-amount transfer-amount)
                    (format "Succesfully transfered {} {} from {} to {}, moving the Full Amount to the Receiver" [transfer-amount id sa-s sa-r])
                    (format "Succesfully transfered {} {} from {} to {}, moving only {} to the Receiver due to DPTF Fee Settings" [transfer-amount id sa-s sa-r receiver-amount])
                )
            )
        )
    )
    ;;
    (defun DPTF|C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @doc "Transfers Multiple DPTF Tokens from one sender to another, each token having its own amount specified \
        \ Receiver, as it is only one, can also be a Smart Ouronet Account \
        \ 150k Gas can support between 10 and 20 Transfers, depending on DPTF Token (Simple, Complex, Elite, Unity)"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV7} TFT)
                    (sa-s:string (ref-I|OURONET::OI|UC_ShortAccount sender))
                    (sa-r:string (ref-I|OURONET::OI|UC_ShortAccount receiver))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-TFT::C_MultiTransfer id-lst sender receiver transfer-amount-lst method)
                )
                (format "Succesfully multi-transfered {} DPTFs from {} to {}" [(length id-lst) sa-s sa-r])
            )
        )
    )
    ;;
    (defun DPTF|C_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @doc "Transfers a DPTF in Bulk, from 1 sender to multiple receivers, each with its own amount \
        \ Because <receivers> cannot be Smart Ouronet Accounts, no <method> parameter is needed \
        \ When the Token <id> is set up with a Transfer Fee, and its receiver is on the receiver list, \
        \ it is not exempted from the transfer fee, as is normally the case \
        \ \
        \ It autonomously choose between the 6 Transfer Variants spread over 4 Classes. \
        \ \
        \   Class 0 >> VTT (Volumetric Transfer Tax) Class: (1xL IGNIS or Variable IGNIS Cost for UNITY)\
        \           [CX_Class0BulkTransfer]         Bulk Transfers DPTFs with VTT \
        \           [CX_Class0BulkTransferUnity]    Bulk Transfers UNITY, which also has VTT \
        \   Class 1 >> 1xL IGNIS Cost \
        \           [CX_Class1BulkTransfer]         Bulk Transfers DPTFs with no transfer Fees \
        \   Class 2 >> 2xL IGNIS Cost \
        \           [CX_Class2BulkTransfer]         Bulk Transfers DPTFs with transfer Fees \
        \           [CX_Class2BulkTransferElite]    Bulk Transfers Elite Auryn Class DPTFs with no Transfer Fees \
        \   Class 3 >> 3xL IGNIS Cost \
        \           [CX_Class3BulkTransferElite]    Bulk Transfers Elite Auryn Class DPTFs with Transfer Fees"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV7} TFT)
                    (sa-s:string (ref-I|OURONET::OI|UC_ShortAccount sender))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-TFT::C_MultiBulkTransfer [id] sender [receiver-lst] [transfer-amount-lst])
                )
                (format "Succesfully bulk-transfered {} DPTF from {} to {} Receivers" [id sa-s (length receiver-lst)])
            )
        )
    )
    (defun DPTF|C_MultiBulkTransfer (patron:string id:[string] sender:string receiver-array:[[string]] transfer-amount-array:[[decimal]])
        @doc "Executes Multiple Bulk Transfers in a single Function"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV7} TFT)
                    (sa-s:string (ref-I|OURONET::OI|UC_ShortAccount sender))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-TFT::C_MultiBulkTransfer id sender receiver-array transfer-amount-array)
                )
                (format "Succesfully multi-bulk-transfered {} DPTFs from Sender {} to {} Individual Receiver Lists" [(length id) sa-s (length receiver-array)])
            )
        )
    )
    (defun DPTF|C_Wipe (patron:string id:string atbw:string)
        @doc "Wipes a DPTF Token from a given account in its entirety \
        \ Only works for positive existing amounts"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount atbw))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_Wipe id atbw)
                )
                ;;Update Elite Account
                (ref-DPMF::XB_UpdateEliteSingle id atbw)
                (format "Succesfully wiped all {} from account {}" [id sa])
            )
        )
    )
    (defun DPTF|C_WipePartial (patron:string id:string atbw:string amtbw:decimal)
        @doc "Similar to <DPTF|C_Wipe>, but doesnt wipe the whole existing amount"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount atbw))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPTF::C_WipePartial id atbw amtbw)
                )
                ;;Update Elite Account
                (ref-DPMF::XB_UpdateEliteSingle id atbw)
                (format "Succesfully wiped {} {} from account {}" [amtbw id sa])
            )
        )
    )
    ;;  [DPMF_Client]
    (defun DPMF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for DPMF Token <entity-id> costing 150 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-B|DPMF:module{BrandingUsageV7} DPMF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-B|DPMF::C_UpdatePendingBranding entity-id logo description website social)
                )
                (format "Pending Branding for DPMF {} updated succesfully" [entity-id])
            )
        )
    )
    (defun DPMF|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-B|DPMF:module{BrandingUsageV7} DPMF)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                )
                (ref-B|DPMF::C_UpgradeBranding patron entity-id months)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (format "DPMF {} succesfully upgraded for {} months(s)!" [entity-id months])
            )
        )
    )
    ;;
    (defun DPMF|C_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPMF::C_AddQuantity id nonce account amount)
                )
                (format "Succesfully increased DPMF {} nonce {} quantity on Account {} by {}" [id nonce sa amount])
            )
        )
    )
    (defun DPMF|C_Burn (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPMF::C_Burn id nonce account amount)
                )
                (format "Succesfully burned {} Units of DPMF {} Nonce {} on Account {}" [amount id nonce sa])
            )
        )
    )
    (defun DPMF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool)
        @doc "Similar to its DPTF Variant, has an extra boolean trigger for <can-transfer-nft-create-role>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPMF::C_Control id cco cu casr cf cw cp ctncr)
                )
                (format "Succesfully controlled DPMF {} Boolean Properties" [id])
            )
        )
    )
    (defun DPMF|C_Create (patron:string id:string account:string meta-data:[object])
        @doc "Creates a DPMF Token (id must already be issued), only creating a new DPMF nonce, without adding quantity"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (with-capability (P|TS)
                            (ref-DPMF::C_Create id account meta-data)
                        )
                    )
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (format "Succesfully created a new Batch with nonce {} for DPMF {} on Account {}" [id (at 0 (at "output" ico)) sa])
            )
        )
    )
    (defun DPMF|C_DeployAccount (patron:string id:string account:string)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
                )
                (ref-DPMF::C_DeployAccount id account)
                (ref-IGNIS::IC|C_Collect patron
                    (ref-IGNIS::IC|UDC_SmallCumulator account)
                )
                (format "Succesfully deployed a New DPMF Account for DPMF {} on Ouronet Account {}" [id sa])
            )
        )
    )
    (defun DPMF|C_Issue:list (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-DPMF::C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at "output" ico)
            )
        )
    )
    (defun DPMF|C_Mint (patron:string id:string account:string amount:decimal meta-data:[object])
        @doc "Mints a DPMF Token, creating it and adding quantity to it \
        \ Outputs the nonce of the created DPMF"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (with-capability (P|TS)
                            (ref-DPMF::C_Mint id account amount meta-data)
                        )
                    )
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (format "Succesfully minted {} {} on Account {}, on the new Nonce {}" [amount id sa (at 0 (at "output" ico))])
            )
        )
    )
    (defun DPMF|C_MoveCreateRole (patron:string id:string receiver:string)
        @doc "Moves <create-role> for a DPMF Token <id> to <receiver> \
        \ Only a single account may have this role"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATS:module{AutostakeV4} ATS)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATS::DPMF|C_MoveCreateRole id receiver)
                )
            )
        )
    )
    (defun DPMF|C_MultiBatchTransfer (patron:string id:string nonces:[integer] sender:string receiver:string method:bool)
        @doc "Executes a MultiBatch transfer, transfering multiple DPMF nonces in single function"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPMF::C_MultiBatchTransfer id nonces sender receiver method)
                )
            )
        )
    )
    (defun DPMF|C_RotateOwnership (patron:string id:string new-owner:string)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPMF::C_RotateOwnership id new-owner)
                )
            )
        )
    )
    (defun DPMF|C_SingleBatchTransfer (patron:string id:string nonce:integer sender:string receiver:string method:bool)
        @doc "Executes a single Batch Transfer, transfering the whole nonce amount"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPMF::C_SingleBatchTransfer id nonce sender receiver method)
                )
            )
        )
    )
    (defun DPMF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <add-quantity-role> for a DPMF Token <id> on a specific <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATS:module{AutostakeV4} ATS)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATS::DPMF|C_ToggleAddQuantityRole id account toggle)
                )
            )
        )
    )
    (defun DPMF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <burn-role> for a DPMF Token <id> on a specific <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATS:module{AutostakeV4} ATS)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-ATS::DPMF|C_ToggleBurnRole id account toggle)
                )
            )
        )
    )
    (defun DPMF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPMF::C_ToggleFreezeAccount id account toggle)
                )
            )
        )
    )
    (defun DPMF|C_TogglePause (patron:string id:string toggle:bool)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPMF::C_TogglePause id toggle)
                )
            )
        )
    )
    (defun DPMF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPMF::C_ToggleTransferRole id account toggle)
                )
            )
        )
    )
    (defun DPMF|C_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Transfers a DPMF Token, trasnfering an amount smaller than or equal to DPMF nonce amount"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPMF::C_Transfer id nonce sender receiver transfer-amount method)
                )
            )
        )
    )
    (defun DPMF|C_Wipe (patron:string id:string atbw:string)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPMF::C_Wipe id atbw)
                )
                ;;Update Elite Account
                (ref-DPMF::XB_UpdateEliteSingle id atbw)
            )
        )
    )
    (defun DPMF|C_WipePartial (patron:string id:string atbw:string nonces:[integer])
        @doc "Similar to <DPMF|C_Wipe>, but only wipes selected nonces"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPMF::C_WipePartial id atbw nonces)
                )
                ;;Update Elite Account
                (ref-DPMF::XB_UpdateEliteSingle id atbw)
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)