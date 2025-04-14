(interface TalosStageOne_ClientOne
    ;;
    ;;DALOS Functions
    (defun DALOS|C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool))
    (defun DALOS|C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun DALOS|C_DeployStandardAccount (account:string guard:guard kadena:string public:string)) ;i
    (defun DALOS|C_RotateGovernor (patron:string account:string governor:guard)) ;i
    (defun DALOS|C_RotateGuard (patron:string account:string new-guard:guard safe:bool))
    (defun DALOS|C_RotateKadena (patron:string account:string kadena:string))
    (defun DALOS|C_RotateSovereign (patron:string account:string new-sovereign:string))
    ;;
    ;;
    ;;DPTF (Demiourgos Pact True Fungible) Functions
    (defun DPTF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun DPTF|C_UpgradeBranding (patron:string entity-id:string months:integer))
    ;;
    (defun DPTF|C_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool))
    (defun DPTF|C_ExemptionBulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool))
    (defun DPTF|C_Burn (patron:string id:string account:string amount:decimal))
    (defun DPTF|C_ClearDispo (patron:string account:string))
    (defun DPTF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool))
    (defun DPTF|C_DeployAccount (id:string account:string))
    (defun DPTF|C_DonateFees (patron:string id:string))
    (defun DPTF|C_Issue:list (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool]))
    (defun DPTF|C_Mint (patron:string id:string account:string amount:decimal origin:bool))
    (defun DPTF|C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
    (defun DPTF|C_ExemptionMultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
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
    (defun DPTF|C_ExemptionTransfer (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool))
    (defun DPTF|C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal))
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
    (defun DPMF|C_Create:integer (patron:string id:string account:string meta-data:[object]))
    (defun DPMF|C_DeployAccount (id:string account:string)) ;i
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
)
(module TS01-C1 GOV
    @doc "TALOS Stage 1 Client Functiones Part 1"
    ;;
    (implements OuronetPolicy)
    (implements TalosStageOne_ClientOne)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_TS01-C1        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TS01-C1_ADMIN)))
    (defcap GOV|TS01-C1_ADMIN ()    (enforce-guard GOV|MD_TS01-C1))
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
    (defcap P|TS ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
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
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV2} DALOS)) (ref-DALOS::P|Info)))
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
                (ref-P|TS01-A:module{TalosStageOne_AdminV2} TS01-A)
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
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DALOS::C_ControlSmartAccount patron account payable-as-smart-contract payable-by-smart-contract payable-by-method)
                )
            )
        )
    )
    (defun DALOS|C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        @doc "Deploys a Standard Ouronet Account, taxing for KDA"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-TS01-A:module{TalosStageOne_AdminV2} TS01-A)
                )
                (ref-DALOS::C_DeploySmartAccount account guard kadena sovereign public)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    (defun DALOS|C_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        @doc "Deploys a Standard Ouronet Account, taxing for KDA"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-TS01-A:module{TalosStageOne_AdminV2} TS01-A)
                )
                (ref-DALOS::C_DeployStandardAccount account guard kadena public)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    (defun DALOS|C_RotateGovernor (patron:string account:string governor:guard)
        @doc "Rotates the governor of a Smart Ouronet Account \
        \ The Governor acts as a governing entity for the Smart Ouronet Account allowing fine control of its assets"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DALOS::C_RotateGovernor patron account governor)
                )
            )
        )
    )
    (defun DALOS|C_RotateGuard (patron:string account:string new-guard:guard safe:bool)
        @doc "Rotates the guard of an Ouronet Safe. Boolean <safe> also enforces the <new-guard>"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DALOS::C_RotateGuard patron account new-guard safe)
                )
            )
        )
    )
    (defun DALOS|C_RotateKadena (patron:string account:string kadena:string)
        @doc "Rotates the KDA Account attached to an Ouronet Account. \
        \ The attached KDA Account is the account that makes KDA Payments for specific Ouronet Actions"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DALOS::C_RotateKadena patron account kadena)
                )
            )
        )
    )
    (defun DALOS|C_RotateSovereign (patron:string account:string new-sovereign:string)
        @doc "Rotates the Sovereign of a Smart Ouronet Account \
        \ The Sovereign of a Smart Ouronet Account acts as its owner, allowing dominion over its assets"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DALOS::C_RotateSovereign patron account new-sovereign)
                )
            )
        )
    )
    ;;  [DPTF_Client]
    (defun DPTF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for DPTF Token <entity-id> costing 100 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{BrandingUsageV2} DPTF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_UpdatePendingBranding patron entity-id logo description website social)
                )
            )
        )
    )
    (defun DPTF|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Upgrades Branding for DPTF Token, making it a premium Branding. \
            \ Also sets pending-branding to live branding if its branding is not live yet"
        (with-capability (P|TS)
            (let
                (
                    (ref-DPTF:module{BrandingUsageV2} DPTF)
                    (ref-TS01-A:module{TalosStageOne_AdminV2} TS01-A)
                )
                (ref-DPTF::C_UpgradeBranding patron entity-id months)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    ;;
    (defun DPTF|C_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Executes a Bulk DPTF Transfer, sending one DPTF, to multiple receivers, each with its own amount \
        \ Always enforces <min-move> amount, and <receiver-lst> must all be Standard Ouronet Accounts, \
        \ as it cant send to Smart Ouronet Account recipients. \
        \ Works for 12 Recipients when using DPTFs, or 8 Recipients when using Elite-Auryn"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV2} TFT)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-TFT::C_BulkTransfer patron id sender receiver-lst transfer-amount-lst method)
                )
            )
        )
    )
    (defun DPTF|C_ExemptionBulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Similar to <DPTF|C_ExemptionTransfer> but for Bulk-Transfers"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV2} TFT)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-TFT::C_ExemptionBulkTransfer patron id sender receiver-lst transfer-amount-lst method)
                )
            )
        )
    )
    (defun DPTF|C_Burn (patron:string id:string account:string amount:decimal)
        @doc "Burns a DPTF Token from an account"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_Burn patron id account amount)
                )
            )
        )
    )
    (defun DPTF|C_ClearDispo (patron:string account:string)
        @doc "Clears OURO Dispo by levereging existing Elite-Auryn"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV2} TFT)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-TFT::C_ClearDispo patron account)
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
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_Control patron id cco cu casr cf cw cp)
                )
            )
        )
    )
    (defun DPTF|C_DeployAccount (id:string account:string)
        @doc "Deploys a DPTF Account"
        (with-capability (P|TS)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                )
                (ref-DPTF::C_DeployAccount id account)
            )
        )
    )
    (defun DPTF|C_DonateFees (patron:string id:string)
        @doc "Sets the Fee Collection target to the DALOS|SC_NAME \
        \ When DPTF Fees collect here, the will be earned by Ouronet Custodians"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_SetFeeTarget patron id (ref-DALOS::GOV|DALOS|SC_NAME))
                )
            )
        )
    )
    (defun DPTF|C_Issue:list (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
        @doc "Issues a new DPTF Token in Bulk, can also be used to issue a single DPTF \
        \ Outputs a string list with the issed DPTF IDs"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                    (ref-TS01-A:module{TalosStageOne_AdminV2} TS01-A)
                    (ico:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-DPTF::C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause)
                    )
                )
                (ref-DALOS::IGNIS|C_Collect patron ico)
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
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_Mint patron id account amount origin)
                )
            )
        )
    )
    (defun DPTF|C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @doc "Executes a DPTF MultiTransfer, sending multiple DPTF, each with its own amount, to a single receiver \
            \ Works for up to 12 Tokens in a single TX."
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV2} TFT)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-TFT::C_MultiTransfer patron id-lst sender receiver transfer-amount-lst method)
                )
            )
        )
    )
    (defun DPTF|C_ExemptionMultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @doc "Similar to <DPTF|C_ExemptionTransfer> but for Multi-Transfers"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV2} TFT)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-TFT::C_ExemptionMultiTransfer patron id-lst sender receiver transfer-amount-lst method)
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
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_SetFeeTarget patron id (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                )
            )
        )
    )
    (defun DPTF|C_RotateOwnership (patron:string id:string new-owner:string)
        @doc "Rotates DPTF ID Ownership"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_RotateOwnership patron id new-owner)
                )
            )
        )
    )
    (defun DPTF|C_SetFee (patron:string id:string fee:decimal)
        @doc "Sets a transfer fee for the DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_SetFee patron id fee)
                )
            )
        )
    )
    (defun DPTF|C_SetFeeTarget (patron:string id:string target:string)
        @doc "Sets the Fee Collection Target for a DPTF"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_SetFeeTarget patron id target)
                )
            )
        )
    )
    (defun DPTF|C_SetMinMove (patron:string id:string min-move-value:decimal)
        @doc "Sets the minimum amount needed to transfer a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_SetMinMove patron id min-move-value)
                )
            )
        )
    )
    (defun DPTF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <burn-role> for a DPTF Token <id> on a specific <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-ATS:module{AutostakeV2} ATS)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-ATS::DPTF|C_ToggleBurnRole patron id account toggle)
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
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_ToggleFee patron id toggle)
                )
            )
        )
    )
    (defun DPTF|C_ToggleFeeExemptionRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <fee-exemption-role> for a DPTF Token <id> on a specific <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-ATS:module{AutostakeV2} ATS)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-ATS::DPTF|C_ToggleFeeExemptionRole patron id account toggle)
                )
            )
        )
    )
    (defun DPTF|C_ToggleFeeLock (patron:string id:string toggle:bool)
        @doc "Toggles DPTF Fee Settings Lock"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                    (ref-TS01-A:module{TalosStageOne_AdminV2} TS01-A)
                    (ico:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-DPTF::C_ToggleFeeLock patron id toggle)
                    )
                    (collect:bool (at 0 (at "output" ico)))
                )
                (ref-DALOS::IGNIS|C_Collect patron ico)
                (ref-TS01-A::XE_ConditionalFuelKDA collect)
            )
        )
    )
    (defun DPTF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Toggles Freezing of a DPTF Account"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_ToggleFreezeAccount patron id account toggle)
                )
            )
        )
    )
    (defun DPTF|C_ToggleMintRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <mint-role> for a DPTF Token <id> on a specific <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-ATS:module{AutostakeV2} ATS)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-ATS::DPTF|C_ToggleMintRole patron id account toggle)
                )
            )
        )
    )
    (defun DPTF|C_TogglePause (patron:string id:string toggle:bool)
        @doc "Toggles Pause for a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_TogglePause patron id toggle)
                )
            )
        )
    )
    (defun DPTF|C_ToggleReservation (patron:string id:string toggle:bool)
        @doc "Toggles Reservations for a DPTF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                    (ref-TS01-A:module{TalosStageOne_AdminV2} TS01-A)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_ToggleReservation patron id toggle)
                )
            )
        )
    )
    (defun DPTF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <transfer-role> for a DPTF Token <id> on a specific <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_ToggleTransferRole patron id account toggle)
                )
            )
        )
    )
    (defun DPTF|C_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Transfers a DPTF Token from <sender> to <receiver>, with all checks in place"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV2} TFT)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-TFT::C_Transfer patron id sender receiver transfer-amount method)
                )
            )
        )
    )
    (defun DPTF|C_ExemptionTransfer (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Transfers a DPTF Token from <sender> to <receiver>, \
        \ when either <sender> or <receiver> has <fee-exemption-role> set to true for DPTF <id> \
        \ Is Faster than <DPTF|C_Transfer> due to trimmed execution logic, and should be used whenever possible, \
        \ if the proper conditions are met"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV2} TFT)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-TFT::C_ExemptionTransfer patron id sender receiver transfer-amount method)
                )
            )
        )
    )
    (defun DPTF|C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal)
        @doc "Transmutes a DPTF Token. Transmuting behaves follows the same mechanics of a DPTF Fee Processing \
        \ without counting as DPTF Fee in the DPTF Fee Counter"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV2} TFT)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-TFT::C_Transmute patron id transmuter transmute-amount)
                )
            )
        )
    )
    (defun DPTF|C_Wipe (patron:string id:string atbw:string)
        @doc "Wipes a DPTF Token from a given account in its entirety \
        \ Only works for positive existing amounts"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                    (ref-TS01-A:module{TalosStageOne_AdminV2} TS01-A)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    [(ref-DPTF::C_Wipe patron id atbw)]
                )
            )
        )
    )
    (defun DPTF|C_WipePartial (patron:string id:string atbw:string amtbw:decimal)
        @doc "Similar to <DPTF|C_Wipe>, but doesnt wipe the whole existing amount"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV2} DPTF)
                    (ref-TS01-A:module{TalosStageOne_AdminV2} TS01-A)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPTF::C_WipePartial patron id atbw amtbw)
                )
            )
        )
    )
    ;;  [DPMF_Client]
    (defun DPMF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for DPMF Token <entity-id> costing 150 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{BrandingUsageV2} DPMF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPMF::C_UpdatePendingBranding patron entity-id logo description website social)
                )
            )
        )
    )
    (defun DPMF|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-DPMF:module{BrandingUsageV2} DPMF)
                    (ref-TS01-A:module{TalosStageOne_AdminV2} TS01-A)
                )
                (ref-DPMF::C_UpgradeBranding patron entity-id months)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    ;;
    (defun DPMF|C_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPMF::C_AddQuantity patron id nonce account amount)
                )
            )
        )
    )
    (defun DPMF|C_Burn (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPMF::C_Burn patron id nonce account amount)
                )
            )
        )
    )
    (defun DPMF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool)
        @doc "Similar to its DPTF Variant, has an extra boolean trigger for <can-transfer-nft-create-role>"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPMF::C_Control patron id cco cu casr cf cw cp ctncr)
                )
            )
        )
    )
    (defun DPMF|C_Create:integer (patron:string id:string account:string meta-data:[object])
        @doc "Creates a DPMF Token (id must already be issued), only creating a new DPMF nonce, without adding quantity"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                    (ico:object{OuronetDalosV2.OutputCumulatorV2}
                        (with-capability (P|TS)
                            (ref-DPMF::C_Create patron id account meta-data)
                        )
                    )
                )
                (ref-DALOS::IGNIS|C_Collect patron ico)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun DPMF|C_DeployAccount (id:string account:string)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                    (ref-TS01-A:module{TalosStageOne_AdminV2} TS01-A)
                )
                (ref-DPMF::C_DeployAccount id account)
            )
        )
    )
    (defun DPMF|C_Issue:list (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                    (ref-TS01-A:module{TalosStageOne_AdminV2} TS01-A)
                    (ico:object{OuronetDalosV2.OutputCumulatorV2}
                        (ref-DPMF::C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role)
                    )
                )
                (ref-DALOS::IGNIS|C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at "output" ico)
            )
        )
    )
    (defun DPMF|C_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object])
        @doc "Mints a DPMF Token, creating it and adding quantity to it \
        \ Outputs the nonce of the created DPMF"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                    (ico:object{OuronetDalosV2.OutputCumulatorV2}
                        (with-capability (P|TS)
                            (ref-DPMF::C_Mint patron id account amount meta-data)
                        )
                    )
                )
                (ref-DALOS::IGNIS|C_Collect patron ico)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun DPMF|C_MoveCreateRole (patron:string id:string receiver:string)
        @doc "Moves <create-role> for a DPMF Token <id> to <receiver> \
        \ Only a single account may have this role"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-ATS:module{AutostakeV2} ATS)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-ATS::DPMF|C_MoveCreateRole patron id receiver)
                )
            )
        )
    )
    (defun DPMF|C_MultiBatchTransfer (patron:string id:string nonces:[integer] sender:string receiver:string method:bool)
        @doc "Executes a MultiBatch transfer, transfering multiple DPMF nonces in single function"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPMF::C_MultiBatchTransfer patron id nonces sender receiver method)
                )
            )
        )
    )
    (defun DPMF|C_RotateOwnership (patron:string id:string new-owner:string)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPMF::C_RotateOwnership patron id new-owner)
                )
            )
        )
    )
    (defun DPMF|C_SingleBatchTransfer (patron:string id:string nonce:integer sender:string receiver:string method:bool)
        @doc "Executes a single Batch Transfer, transfering the whole nonce amount"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPMF::C_SingleBatchTransfer patron id nonce sender receiver method)
                )
            )
        )
    )
    (defun DPMF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <add-quantity-role> for a DPMF Token <id> on a specific <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-ATS:module{AutostakeV2} ATS)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-ATS::DPMF|C_ToggleAddQuantityRole patron id account toggle)
                )
            )
        )
    )
    (defun DPMF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <burn-role> for a DPMF Token <id> on a specific <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-ATS:module{AutostakeV2} ATS)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-ATS::DPMF|C_ToggleBurnRole patron id account toggle)
                )
            )
        )
    )
    (defun DPMF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                    (ref-TS01-A:module{TalosStageOne_AdminV2} TS01-A)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPMF::C_ToggleFreezeAccount patron id account toggle)
                )
            )
        )
    )
    (defun DPMF|C_TogglePause (patron:string id:string toggle:bool)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                    (ref-TS01-A:module{TalosStageOne_AdminV2} TS01-A)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPMF::C_TogglePause patron id toggle)
                )
            )
        )
    )
    (defun DPMF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPMF::C_ToggleTransferRole patron id account toggle)
                )
            )
        )
    )
    (defun DPMF|C_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Transfers a DPMF Token, trasnfering an amount smaller than or equal to DPMF nonce amount"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPMF::C_Transfer patron id nonce sender receiver transfer-amount method)
                )
            )
        )
    )
    (defun DPMF|C_Wipe (patron:string id:string atbw:string)
        @doc "Similar to its DPTF Variant"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPMF::C_Wipe patron id atbw)
                )
            )
        )
    )
    (defun DPMF|C_WipePartial (patron:string id:string atbw:string nonces:[integer])
        @doc "Similar to <DPMF|C_Wipe>, but only wipes selected nonces"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV2} DPMF)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPMF::C_WipePartial patron id atbw nonces)
                )
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)