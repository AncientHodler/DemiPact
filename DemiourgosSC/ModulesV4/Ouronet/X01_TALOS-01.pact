;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module TS01 GOV
    @doc "TALOS Administrator and Client Module for Stage 1"
    ;;
    (implements OuronetPolicy)
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
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|TFT:module{OuronetPolicy} TFT)
            )
            (ref-P|DALOS::P|A_Add 
                "TS01|Summoner"
                (create-capability-guard (P|TS))
            )
            (ref-P|BRD::P|A_Add 
                "TS01|Summoner"
                (create-capability-guard (P|TS))
            )
            (ref-P|DPTF::P|A_Add 
                "TS01|Summoner"
                (create-capability-guard (P|TS))
            )
            (ref-P|ATS::P|A_Add 
                "TS01|Summoner"
                (create-capability-guard (P|TS))
            )
            (ref-P|TFT::P|A_Add 
                "TS01|Summoner"
                (create-capability-guard (P|TS))
            )
        )
    )
    ;;
    ;;{DALOS_Administrator}
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
    (defun DALOS|A_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        @doc "Deploys a Smart Ouronet Account in Administrator Mode, without collection KDA"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::A_DeploySmartdAccount account guard kadena sovereign public)
            )
        )
    )
    (defun IGNIS|A_Toggle (native:bool toggle:bool)
        @doc "Toggles Ouronet Gas Collection \
        \ <native> true is KDA Collection for Specific Usage Actions \
        \ <native> false is IGNIS Collection for Client Functions"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::IGNIS|A_Toggle native toggle)
            )
        )
    )
    (defun IGNIS|A_SetSourcePrice (price:decimal)
        @doc "Sets OUROBOROS Price in $. Used in Compresion and Sublimation"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|TS)
                (ref-DALOS::IGNIS|A_SetSourcePrice price)
            )
        )
    )
    ;;{BRD_Administrator}
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
    ;;{DALOS_Client}
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
        ;;
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
    (defun DPTF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles <burn-role> for a DPTF Token <id> on a specific <account>"
        (let
            (
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (P|TS)
                (ref-ATS::C_ToggleBurnRole patron id account toggle)
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
                (ref-ATS::C_ToggleFeeExemptionRole patron id account toggle)
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
                (ref-ATS::ToggleMintRole patron id account toggle)
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
    (defun DPTF|C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
        @doc "Issues a new DPTF Token in Bulk, can also be used to issue a single DPTF \
        \ Outputs a string list with the issed DPTF IDs"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-ORBR:module{Ouroboros} OUROBOROS)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause)
                (ref-ORBR::C_Fuel (ref-DALOS::GOV|DALOS|SC_NAME))
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
                (ref-DPTF::SetMinMove patron id min-move-value)
            )
        )
    )
    (defun C_ToggleFee (patron:string id:string toggle:bool)
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
    (defun DPTF|C_ToggleFeeLock (patron:string id:string toggle:bool)
        @doc "Toggles DPTF Fee Settings Lock"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-ORBR:module{Ouroboros} OUROBOROS)
            )
            (with-capability (P|TS)
                (ref-DPTF::C_ToggleFeeLock patron id toggle)
                (ref-ORBR::C_Fuel (ref-DALOS::GOV|DALOS|SC_NAME))
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
)