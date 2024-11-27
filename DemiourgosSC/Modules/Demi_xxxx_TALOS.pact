(module TALOS GOVERNANCE
    @doc "The TALOS Module contains all DALOS Client Functions in one place"

    (defcap GOVERNANCE ()
        (compose-capability (TALOS-ADMIN))
    )
    (defcap TALOS-ADMIN ()
        (enforce-guard G_TALOS)
    )
    (defcap OUROBOROS-ADMIN ()
        (enforce-guard G_OUROBOROS)
    )
    ;;Module Guards
    (defconst G_OUROBOROS (keyset-ref-guard OUROBOROS|DEMIURGOI))
    (defconst G_TALOS   (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    ;;Module Keys
    (defconst OUROBOROS|DEMIURGOI "free.DH_Master-Keyset")

    ;;Module Accounts Information
    ;;  DALOS
    (defconst DALOS|SC_KEY                  DALOS.DALOS|SC_KEY)
    (defconst DALOS|SC_NAME                 DALOS.DALOS|SC_NAME)
    (defconst DALOS|SC_KDA-NAME             DALOS.DALOS|SC_KDA-NAME)
    ;;  AUTOSTAKE
    (defconst ATS|SC_KEY                    AUTOSTAKE.ATS|SC_KEY)
    (defconst ATS|SC_NAME                   AUTOSTAKE.ATS|SC_NAME)
    (defconst ATS|SC_KDA-NAME               AUTOSTAKE.ATS|SC_KDA-NAME)
    ;;  VESTING
    (defconst VST|SC_KEY                    AUTOSTAKE.VST|SC_KEY)
    (defconst VST|SC_NAME                   AUTOSTAKE.VST|SC_NAME)
    (defconst VST|SC_KDA-NAME               AUTOSTAKE.VST|SC_KDA-NAME)
    ;;  LIQUID-STAKING
    (defconst LIQUID|SC_KEY                 LIQUID.LIQUID|SC_KEY)
    (defconst LIQUID|SC_NAME                DALOS.LIQUID|SC_NAME)
    (defconst LIQUID|SC_KDA-NAME            LIQUID.LIQUID|SC_KDA-NAME)
    ;;  OUROBOROS
    (defconst OUROBOROS|SC_KEY              OUROBOROS.OUROBOROS|SC_KEY)
    (defconst OUROBOROS|SC_NAME             DALOS.OUROBOROS|SC_NAME)
    (defconst OUROBOROS|SC_KDA-NAME         OUROBOROS.OUROBOROS|SC_KDA-NAME)

    ;;External Module Usage
    (use free.DALOS)
    (use free.BASIS)
    (use free.AUTOSTAKE)
    (use free.LIQUID)
    (use free.OUROBOROS)

    ;; POLICY Capabilities
    (defcap SUMMONER ()
        @doc "Policy that allows executing DALOS BASIS AUTOSTAKE LIQUID and OUROBOROS Client Functions"
        true
    )
    (defcap P|DALOS|AUTO_PATRON ()
        @doc "Policy allowing usage of the DALOS Smart Account as a patron for gassless transactions"
        true
    )
    ;;Combined Policy Capabilities
    (defcap SUMMONER||P|DALOS|AUTO_PATRON ()
        @doc "Dual Capability for simple usage"
        (compose-capability (SUMMONER))
        (compose-capability (P|DALOS|AUTO_PATRON))
    )
    (defcap SUMMONER||OUROBOROS-ADMIN ()
        @doc "Dual Capability for simple usage"
        (compose-capability (SUMMONER))
        (compose-capability (OUROBOROS-ADMIN))
    )

    ;;Policies
    (defun TALOS|DefinePolicies ()
        @doc "Add the Policies that allows running external Functions from this Module"
        (DALOS.DALOS|A_AddPolicy         ;DALOS
            "TALOS|Summoner"
            (create-capability-guard (SUMMONER))                             ;;  Required to execute Client Functions from DALOS Module
        )
        (DALOS.DALOS|A_AddPolicy
            "TALOS|AutomaticPatron"
            (create-capability-guard (P|DALOS|AUTO_PATRON))                  ;;  Gasless Patron
        )
        (BASIS.BASIS|A_AddPolicy         ;BASIS
            "TALOS|Summoner"
            (create-capability-guard (SUMMONER))                             ;;  Required to execute Client Functions from BASIS Module
        )
        (AUTOSTAKE.ATS|A_AddPolicy       ;AUTOSTAKE
            "TALOS|Summoner"
            (create-capability-guard (SUMMONER))                             ;;  Required to execute Client Functions from AUTOSTAKE Module
        )
        (LIQUID.LQD|A_AddPolicy          ;LIQUID
            "TALOS|Summoner"
            (create-capability-guard (SUMMONER))                             ;;  Required to execute Client Functions from LIQUID Module
        )
        (OUROBOROS.OUROB|A_AddPolicy     ;OUROBOROS
            "TALOS|Summoner"
            (create-capability-guard (SUMMONER))                             ;;  Required to execute Client Functions from OUROBOROS Module
        )
    )
    ;;
    ;;            TALOS             Submodule
    ;;
    ;;            FUNCTIONS         [17]
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;            Administrative Usage Functions        [A]
    (defun TALOS|A_InitialiseVirtualBlockchain (patron:string)
        @doc "Main initialisation function for the DALOS Virtual Blockchain"
        (with-capability (SUMMONER||OUROBOROS-ADMIN)
            (DALOS|X_Initialise patron)
        )
    )
    ;;        [6] Client Usage FUNCTIONS                [C]
    ;;DALOS
    (defun DALOS|C_DeployStandardAccount (account:string guard:guard kadena:string);e
        @doc "Deploys a Standard DALOS Account";e
        (with-capability (SUMMONER||P|DALOS|AUTO_PATRON)
            (DALOS.DALOS|CO_DeployStandardAccount account guard kadena)
            (OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    (defun DALOS|C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string);e
        @doc "Deploys a Smart DALOS Account";e
        (with-capability (SUMMONER||P|DALOS|AUTO_PATRON)
            (DALOS.DALOS|CO_DeploySmartAccount account guard kadena sovereign)
            (OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    (defun DALOS|C_RotateGuard (patron:string account:string new-guard:guard safe:bool);e
        @doc "Updates the Guard stored in the DALOS|AccountTable"
        (with-capability (SUMMONER)
            (DALOS.DALOS|CO_RotateGuard patron account new-guard safe)
        )
    )
    (defun DALOS|C_RotateKadena (patron:string account:string kadena:string);e
        @doc "Updates the Kadena Account stored in the DALOS|AccountTable"
        (with-capability (SUMMONER)
            (DALOS.DALOS|CO_RotateKadena patron account kadena)
        )
    )
    (defun DALOS|C_RotateSovereign (patron:string account:string new-sovereign:string);e
        @doc "Updates the Smart Account Sovereign Account \
            \ Only works for Smart DALOS Accounts"
        (with-capability (SUMMONER)
            (DALOS.DALOS|CO_RotateSovereign patron account new-sovereign)
        )
    )
    (defun DALOS|C_RotateGovernor (patron:string account:string governor:guard);e
        @doc "Updates the Smart Account Governor, which is the Governing Module \
            \ Only works for Smart DALOS Accounts"
        (with-capability (SUMMONER)
            (DALOS.DALOS|CO_RotateGovernor patron account governor)
        )
    )
    (defun DALOS|C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool);e
        @doc "Manages Smart DALOS Account Type via boolean triggers"
        (with-capability (SUMMONER)
            (DALOS|CP_ControlSmartAccount patron account payable-as-smart-contract payable-by-smart-contract payable-by-method)
        )
    )
    ;;DPTF
    (defun DPTF|C_DeployAccount (id:string account:string)
        @doc "Deploys a new DPTF Account for True-Fungible <id> and Account <account> \
            \ If a DPTF Account already exists for <id> and <account>, it remains as is. \
            \ \
            \ A DPTF Account can only be created if a coresponding DALOS Account exists."
        (with-capability (SUMMONER)
            (BASIS.DPTF-DPMF|CO_DeployAccount id account true)
        )
    )
    (defun DPTF|C_ChangeOwnership (patron:string id:string new-owner:string);e
        @doc "Moves DPTF <id> Token Ownership to <new-owner> DPTF Account"
        (with-capability (SUMMONER)
            (BASIS.DPTF-DPMF|CP_ChangeOwnership patron id new-owner true)
        )
    )
    (defun DPTF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool);e
        @doc "Freeze/Unfreeze via boolean <toggle> True-Fungible <id> on DPTF Account <account>"
        (with-capability (SUMMONER)
            (BASIS.DPTF-DPMF|CO_ToggleFreezeAccount patron id account toggle true)
        )
    )
    (defun DPTF|C_TogglePause (patron:string id:string toggle:bool);e
        @doc "Pause/Unpause True-Fungible <id> via the boolean <toggle> \
        \ Paused True Fungible cannot be transferred."
        (with-capability (SUMMONER)
            (BASIS.DPTF-DPMF|CO_TogglePause patron id toggle true)
        )
    )
    (defun DPTF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool);e
        @doc "Sets |role-burn| to <toggle> for True-Fungible <id> and DPTF Account <account>. \
            \ This determines if Account <account> can burn existing True-Fungibles."
        (with-capability (SUMMONER)
            (AUTOSTAKE.DPTF-DPMF|CO_ToggleBurnRole patron id account toggle true)
        )
    )
    (defun DPTF|C_ToggleMintRole (patron:string id:string account:string toggle:bool);e
        @doc "Sets |role-mint| to <toggle> for TrueFungible <id> and DPTF Account <account>, \
            \ allowing or revoking minting rights"
        (with-capability (SUMMONER)
            (AUTOSTAKE.DPTF|CO_ToggleMintRole patron id account toggle)
        )
    )
    (defun DPTF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool);e
        @doc "Sets |role-transfer| to <toggle> for True|Meta-Fungible <id> and DPTF|DPMF Account <account>. \
            \ If any DPTF|DPMF Account has |role-transfer| true, normal transfers are restricted. \
            \ Transfers will only be allowed to DPTF|DPMF Accounts with |role-transfer| true, \
            \ while these Accounts can transfer the True|Meta-Fungible freely to others."
        (with-capability (SUMMONER)
            (BASIS.DPTF-DPMF|CO_ToggleTransferRole patron id account toggle true)
        )
    )
    (defun DPTF|C_ToggleFeeExemptionRole (patron:string id:string account:string toggle:bool);e
        @doc "Sets |role-fee-exemption| to <toggle> for TrueFungible <id> and DPTF Account <account> \
            \ Accounts with this role true are exempt from fees when sending or receiving the token, if fee settings are active \
            \ Only Smart DALOS Accounts can have this parameter set to TRUE and become exempt from DPTF transfer fees."
        (with-capability (SUMMONER)
            (AUTOSTAKE.DPTF|CO_ToggleFeeExemptionRole patron id account toggle)
        )
    )
    (defun DPTF|C_Wipe (patron:string id:string atbw:string);e
        @doc "Wipes the whole supply of <id> True-Fungible of a frozen DPTF Account <account>"
        (with-capability (SUMMONER)
            (BASIS.DPTF-DPMF|CO_Wipe patron id atbw true)
        )
    )
    (defun DPTF|C_Burn (patron:string id:string account:string amount:decimal);e
        @doc "Burns DPTF Token <id> from <account>. <Account> needs |role-burn| set to true for <id>"
        (with-capability (SUMMONER)
            (BASIS.DPTF|CO_Burn patron id account amount)
        )
    )
    (defun DPTF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool);e
        @doc "Controls TrueFungible <id> Properties using 6 boolean control triggers \
            \ Setting the <can-upgrade> property to false disables all future Control of Properties"
        (with-capability (SUMMONER)
            (BASIS.DPTF|CO_Control patron id cco cu casr cf cw cp)
        )
    )
    (defun DPTF|C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool]);e
        @doc "Issues Multiple DPTF Tokens at once \
        \ Can also be used for issuing a single DPTF Token \
        \ Outputs a list with the IDs of the Issued Tokens \
        \ Creates DPTF Account(s) involving the DALOS Account <account> for each issued Token "
        (with-capability (SUMMONER)
            (let
                (
                    (output:[string] (BASIS.DPTF|CO_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause))
                )
                (OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
                output
            )
        )
    )
    (defun DPTF|C_Mint (patron:string id:string account:string amount:decimal origin:bool);e
        @doc "Mints DPTF Token <id> from <account>. <Account> needs |role-mint| set to true for <id> for the Generic Mint \
            \ Setting <origin> boolean to true mints the so called genesis-amount also known as premine. Minting premine does not require |role-mint| \
            \ but requires ownership of the token, and null existing supply; minting origin can only be done once, and this amount is saved in the Token Properties"
        (with-capability (SUMMONER)
            (BASIS.DPTF|CO_Mint patron id account amount origin)
        )
    )
    (defun DPTF|C_SetFee (patron:string id:string fee:decimal);e
        @doc "Sets the <fee-promile> for DPTF Token <id> to <fee> \
            \ -1.0 activates the Volumetric Transaction Tax (VTT) mechanic."
        (with-capability (SUMMONER)
            (BASIS.DPTF|CO_SetFee patron id fee)
        )
    )
    (defun DPTF|C_SetFeeTarget (patron:string id:string target:string);e
        @doc "Sets the <fee-target> for DPTF Token <id> to <target> \
            \ Default is DALOS.OUROBOROS|SC_NAME (Fee-Carrier Account) \
            \ Setting it to DALOS.DALOS|SC_NAME makes fee act like collected gas \
            \ Fees from DALOS.OUROBOROS|SC_NAME can be retrieved by the Token owner; \
            \ Fees from DALOS.DALOS|SC_NAME are distributed to DALOS Custodians."
        (with-capability (SUMMONER)
            (BASIS.DPTF|CO_SetFeeTarget patron id target)
        )          
    )
    (defun DPTF|C_SetMinMove (patron:string id:string min-move-value:decimal);e
        @doc "Sets the <min-move> for the DPTF Token <id> to <min-move-value> \
            \ This parameter represents the minimum Token Amount that can be transferred in standard conditions"
        (with-capability (SUMMONER)
            (BASIS.DPTF|CO_SetMinMove patron id min-move-value)
        )          
    )
    (defun DPTF|C_ToggleFee (patron:string id:string toggle:bool);e
        @doc "Toggles <fee-toggle> for the DPTF Token <id> to <toggle> \
            \ <fee-toggle> must be set to true for fee collection to execute"
        (with-capability (SUMMONER)
            (BASIS.DPTF|CO_ToggleFee patron id toggle)
        )          
    )
    (defun DPTF|C_ToggleFeeLock (patron:string id:string toggle:bool);e
        @doc "Sets the <fee-lock> for DPTF Token <id> to <toggle> \
            \ Unlocking (<toggle> = false) has restrictions: \
            \ - Max 7 unlocks per token \
            \ - Unlock cost: (10000 IGNIS + 100 KDA) * (fee-unlocks + 1) \
            \ - Each unlock adds a Secondary Fee collected by the <GasTanker> Smart DALOS Account \
            \ equal to the VTT * fee-unlocks, calculated by <UTILS.DPTF|UC_VolumetricTax>"
        (with-capability (SUMMONER)
            (BASIS.DPTF|CO_ToggleFeeLock patron id toggle)
            (OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    (defun DPTF|C_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal);e
        @doc "Transfers a DPTF Token from <sender> to <receiver>"
        (with-capability (SUMMONER)
            (AUTOSTAKE.DPTF|CO_Transfer patron id sender receiver transfer-amount false)
        )
    )
    (defun DPTF|CM_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal);e
        @doc "Similar to <DPTF|C_Transfer>, but methodic for use when operating with Smart DALOS Accounts"
        (with-capability (SUMMONER)
            (AUTOSTAKE.DPTF|CO_Transfer patron id sender receiver transfer-amount true)
        )
    )
    (defun DPTF|C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal]);e
        @doc "Transfers multiple different DPTFs each with its own amount from a <sender> to a <receiver>"
        (with-capability (SUMMONER)
            (OUROBOROS.DPTF|CO_MultiTransfer patron id-lst sender receiver transfer-amount-lst false)
        )
    )
    (defun DPTF|CM_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal]);e
        @doc "Methodic variant of <DPTF|C_MultiTransfer>"
        (with-capability (SUMMONER)
            (OUROBOROS.DPTF|CO_MultiTransfer patron id-lst sender receiver transfer-amount-lst true)
        )
    )
    (defun DPTF|C_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal]);e
        @doc "Transfers a single DPTF Token to multiple receivers, each with its own amount, in bulk"
        (with-capability (SUMMONER)
            (OUROBOROS.DPTF|CO_BulkTransfer patron id sender receiver-lst transfer-amount-lst false)
        )
    )
    (defun DPTF|CM_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal]);e
        @doc "Methodic variant of <DPTF|C_BulkTransfer>"
        (with-capability (SUMMONER)
            (OUROBOROS.DPTF|CO_BulkTransfer patron id sender receiver-lst transfer-amount-lst true)
        )
    )
    (defun DPTF|C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal)
        @doc "Transmutes a DPTF Token; \
            \ Transmutation behaves as a DPTF Fee Collection (without actually counting towards Native DPTF Fee Volume), \
            \   when the DPTF Token is not part of any ATS-Pair; \
            \ If the Token is part of one or multiple ATS Pairs, \
            \   the input amount will be used to strengthen those ATS-Pairs Indices"
        (with-capability (SUMMONER)
            (AUTOSTAKE.DPTF|CO_Transmute patron id transmuter transmute-amount)
        )
    )
    ;;DPMF
    (defun DPMF|C_DeployAccount (id:string account:string)
        @doc "Similar to <DPTF|C_DeployAccount>, but for DPMFs"
        (with-capability (SUMMONER)
            (BASIS.DPTF-DPMF|CO_DeployAccount id account false)
        )
    )
    (defun DPMF|C_ChangeOwnership (patron:string id:string new-owner:string);e
        @doc "Similar to <DPTF|C_ChangeOwnership>, but for DPMFs"
        (with-capability (SUMMONER)
            (BASIS.DPTF-DPMF|CP_ChangeOwnership patron id new-owner false)
        )
    )
    (defun DPMF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool);e
        @doc "Similar to <DPTF|C_ToggleFreezeAccount>, but for DPMFs"
        (with-capability (SUMMONER)
            (BASIS.DPTF-DPMF|CO_ToggleFreezeAccount patron id account toggle false)
        )
    )
    (defun DPMF|C_TogglePause (patron:string id:string toggle:bool);e
        @doc "Similar to <DPTF|C_TogglePause>, but for DPMFs"
        (with-capability (SUMMONER)
            (BASIS.DPTF-DPMF|CO_TogglePause patron id toggle false)
        )
    )
    (defun DPMF|C_MoveCreateRole (patron:string id:string receiver:string);e
        @doc "Moves |role-nft-create| from <sender> to <receiver> DPMF Account for MetaFungible <id> \
            \ Only a single DPMF Account can have the |role-nft-create| \
            \ Afterwards the receiver DPMF Account can crete new Meta Fungibles \ 
            \ Fails if the target DPMF Account doesnt exist"
        (with-capability (SUMMONER)
            (AUTOSTAKE.DPMF|CO_MoveCreateRole patron id receiver)
        )
    )
    (defun DPMF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool);e
        @doc "Sets |role-nft-add-quantity| to <toggle> boolean for MetaFungible <id> and DPMF Account <account> \
            \ Afterwards Account <account> can either add quantity or no longer add quantity to existing MetaFungible"
        (with-capability (SUMMONER)
            (AUTOSTAKE.DPMF|CO_ToggleAddQuantityRole patron id account toggle)
        )
    )
    (defun DPMF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool);e
        @doc "Similar to <DPTF|C_ToggleBurnRole>, but for DPMFs"
        (with-capability (SUMMONER)
            (AUTOSTAKE.DPTF-DPMF|CO_ToggleBurnRole patron id account toggle false)
        )
    )
    (defun DPMF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool);e
        @doc "Similar to <DPTF|C_ToggleTransferRole>, but for DPMFs"
        (with-capability (SUMMONER)
            (BASIS.DPTF-DPMF|CO_ToggleTransferRole patron id account toggle false)
        )
    )
    (defun DPMF|C_Wipe (patron:string id:string atbw:string);e
        @doc "Similar to <DPTF|C_Wipe>, but for DPMFs"
        (with-capability (SUMMONER)
            (BASIS.DPTF-DPMF|CO_Wipe patron id atbw false)
        )
    )
    (defun DPMF|C_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal);e
        @doc "Adds quantity for an existing DPMF Token"
        (with-capability (SUMMONER)
            (BASIS.DPMF|CO_AddQuantity patron id nonce account amount)
        )
    )
    (defun DPMF|C_Burn (patron:string id:string nonce:integer account:string amount:decimal);e
        @doc "Similar to <DPTF|C_Burn>, but for DPMFs"
        (with-capability (SUMMONER)
            (BASIS.DPMF|CO_Burn patron id nonce account amount)
        )
    )
    (defun DPMF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool);e
        @doc "Similar to <DPTF|C_Control>, but for DPMFs"
        (with-capability (SUMMONER)
            (BASIS.DPMF|CO_Control patron id cco cu casr cf cw cp ctncr)
        )
    )
    (defun DPMF|C_Create:integer (patron:string id:string account:string meta-data:[object]);e
        @doc "Creates a new DPMF Token with the next nonce and zero amount value, for a DPMF Token already issued."
        (with-capability (SUMMONER)
            (BASIS.DPMF|CP_Create patron id account meta-data)
        )
    )
    (defun DPMF|C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool]);e
        @doc "Similar to <DPTF|C_Issue>, but for DPMFs"
        (with-capability (SUMMONER)
            (let
                (
                    (output:[string] (BASIS.DPMF|CO_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role))
                )
                (OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
                output
            )
        )
    )
    (defun DPMF|C_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object]);e
        @doc "Mints a new DPMF Token. Minting means creating and adding supply in a single swoop."
        (with-capability (SUMMONER)
            (BASIS.DPMF|CO_Mint patron id account amount meta-data)
        )
    )
    (defun DPMF|C_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal);e
        @doc "Similar to <DPTF|C_Transfer>, but for DPMFs"
        (with-capability (SUMMONER)
            (BASIS.DPMF|CO_Transfer patron id nonce sender receiver transfer-amount false)
        )
    )
    (defun DPMF|CM_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal);e
        @doc "Methodic variant of <DPMF|C_Transfer>"
        (with-capability (SUMMONER)
            (BASIS.DPMF|CO_Transfer patron id nonce sender receiver transfer-amount true)
        )
    )
    (defun DPMF|C_SingleBatchTransfer (patron:string id:string nonce:integer sender:string receiver:string);e
        @doc "Transfers a single Batch of DPMF Tokens from sender to receiver, using all of its balance"
        (with-capability (SUMMONER)
            (OUROBOROS.DPMF|XP_SingleBatchTransfer patron id nonce sender receiver false)
        )
    )
    (defun DPMF|CM_SingleBatchTransfer (patron:string id:string nonce:integer sender:string receiver:string);e
        @doc "Methodic Variant of <DPMF|C_SingleBatchTransfer>"
        (with-capability (SUMMONER)
            (OUROBOROS.DPMF|XP_SingleBatchTransfer patron id nonce sender receiver true)
        )
    )
    (defun DPMF|C_MultiBatchTransfer (patron:string id:string nonces:[integer] sender:string receiver:string);e
        @doc "Transfers a multiple DPMF Batches of Tokens from sender to receiver, using all of their balance"
        (with-capability (SUMMONER)
            (OUROBOROS.DPMF|XP_MultiBatchTransfer patron id nonces sender receiver false)
        )
    )
    (defun DPMF|CM_MultiBatchTransfer (patron:string id:string nonces:[integer] sender:string receiver:string);e
        @doc "Methodic Variant of <DPMF|C_MultiBatchTransfer>"
        (with-capability (SUMMONER)
            (OUROBOROS.DPMF|XP_MultiBatchTransfer patron id nonces sender receiver true)
        )
    )
    ;;ATS
    (defun ATS|C_ChangeOwnership (patron:string atspair:string new-owner:string);e
        @doc "Moves ATS <atspair> Ownership to <new-owner> DALOS Account"   
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_ChangeOwnership patron atspair new-owner)
        )
    )
    (defun ATS|CP_ToggleParameterLock (patron:string atspair:string toggle:bool);e
        @doc "Sets the <parameter-lock> for the ATS Pair <atspair> to <toggle> \
            \ Unlocking <parameter-toggle> (setting it to false) comes with specific restrictions: \
            \       As many unlocks can be executed for a ATS Pair as needed \
            \       The Cost for unlock is (1000 IGNIS + 10 KDA )*(0 + <unlocks>)"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_ToggleParameterLock patron atspair toggle)
            (OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    (defun ATS|C_UpdateSyphon (patron:string atspair:string syphon:decimal);e
        @doc "Updates the Syphon Index. The Syphon Index represents the minimum ATS-Pair Index until syphoning is allowed"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_UpdateSyphon patron atspair syphon)
        )
    )
    (defun ATS|C_ToggleSyphoning (patron:string atspair:string toggle:bool);e
        @doc "Toggles syphoning, which allows or disallows syphoning mechanic for ATS-Pairs"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_ToggleSyphoning patron atspair toggle)
        )
    )
    (defun ATS|C_ToggleFeeSettings (patron:string atspair:string toggle:bool fee-switch:integer);e
        @doc "Toggles ATS Boolean Fee Parameters to <toggle> : \
            \ fee-switch = 0 : cold-native-fee-redirection (c-nfr) \
            \ fee-switch = 1 : cold-fee-redirection (c-fr) \ 
            \ fee-switch = 2 : hot-fee-redirection (h-fr)"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_ToggleFeeSettings patron atspair toggle fee-switch)
        )
    )
    (defun ATS|C_SetCRD (patron:string atspair:string soft-or-hard:bool base:integer growth:integer);e
        @doc "Sets the Cold Recovery Duration based on input parameters"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_SetCRD patron atspair soft-or-hard base growth)
        )
    )
    (defun ATS|C_SetColdFee (patron:string atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]]);e
        @doc "Sets Cold Recovery fee parameters"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_SetColdFee patron atspair fee-positions fee-thresholds fee-array)
        )
    )
    (defun ATS|C_SetHotFee (patron:string atspair:string promile:decimal decay:integer);e
        @doc "Sets Hot Recovery fee parameters"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_SetHotFee patron atspair promile decay)
        )
    )
    (defun ATS|C_ToggleElite (patron:string atspair:string toggle:bool);e
        @doc "Toggles <c-elite-mode> to <toggle>"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_ToggleElite patron atspair toggle)
        )
    )
    (defun ATS|C_TurnRecoveryOn (patron:string atspair:string cold-or-hot:bool);e
        @doc "Turns <cold-recovery> or <hot-recovery> on"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_TurnRecoveryOn patron atspair cold-or-hot)
        )
    )
    (defun ATS|C_TurnRecoveryOff (patron:string atspair:string cold-or-hot:bool);e
        @doc "Turns <cold-recovery> or <hot-recovery> off"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_TurnRecoveryOff patron atspair cold-or-hot)
        )
    )
    (defun ATS|C_Issue:string (patron:string account:string atspair:string index-decimals:integer reward-token:string rt-nfr:bool reward-bearing-token:string rbt-nfr:bool);e
        @doc "Issue a new ATS-Pair"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_Issue patron account atspair index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr)
        )
    )
    (defun ATS|C_AddSecondary (patron:string atspair:string reward-token:string rt-nfr:bool);e
        @doc "Add a secondary Reward Token for the ATS Pair <atspair>"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_AddSecondary patron atspair reward-token rt-nfr)
        )
    )
    (defun ATS|C_AddHotRBT (patron:string atspair:string hot-rbt:string);e
        @doc "Add a DPMF as <h-rbt> for the ATS Pair <atspair>"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_AddHotRBT patron atspair hot-rbt)
        )
    )
    (defun ATS|C_Fuel (patron:string fueler:string atspair:string reward-token:string amount:decimal);e
        @doc "Client Function for fueling an ATS Pair"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_Fuel patron fueler atspair reward-token amount)
        )
    )
    (defun ATS|C_Coil:decimal (patron:string coiler:string atspair:string rt:string amount:decimal);e
        @doc "Autostakes <rt> to the <atspair> ATS-Pair, receiving RBT"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_Coil patron coiler atspair rt amount)
        )
    )
    (defun ATS|C_Curl:decimal (patron:string curler:string atspair1:string atspair2:string rt:string amount:decimal);e
        @doc "Autostakes <rt> token twice using <atspair1> and <atspair2> \
            \ <rt> must be RBT in <atspair1> and RT in <atspair2> for this to work"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_Curl patron curler atspair1 atspair2 rt amount)
        )
    )
    (defun ATS|C_HotRecovery (patron:string recoverer:string atspair:string ra:decimal);e
        @doc "Executes Hot Recovery for <ats-pair> by <recoverer> with the <ra> amount of Cold-Reward-Bearing-Token"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_HotRecovery patron recoverer atspair ra)
        )
    )
    (defun ATS|C_ColdRecovery (patron:string recoverer:string atspair:string ra:decimal);e
        @doc "Executes Cold Recovery for <ats-pair> by <recoverer> with the <ra> amount of Cold-Reward-Bearing-Token"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_ColdRecovery patron recoverer atspair ra)
        )
    )
    (defun ATS|C_Cull:[decimal] (patron:string culler:string atspair:string);e
        @doc "Culls <atspair> for <culler>. Culling returns all elapsed past Cold-Recoveries executed by <culler> \
            \ Returns culled values. If no cullable values exists, returns a list of zeros, since nothing has been culled"
        (with-capability (SUMMONER)
            (AUTOSTAKE.ATS|CO_Cull patron culler atspair)
        )
    )
    (defun ATS|C_KickStart (patron:string kickstarter:string atspair:string rt-amounts:[decimal] rbt-request-amount:decimal);e
        @doc "Kickstarts <atspair> with a specific amount of Reward-Tokens, \
        \ while asking in retunr for a specific amount of Reward-Bearing-Tokens \
        \ thus efectively starting the <atspair> at a specific predefined Index"
        (with-capability (SUMMONER)
            (OUROBOROS.ATS|CO_KickStart patron kickstarter atspair rt-amounts rbt-request-amount)
        )
    )
    (defun ATS|C_Syphon (patron:string syphon-target:string atspair:string syphon-amounts:[decimal]);e
        @doc "Syphons Reward Tokens from <atspair> to <syphon-target>, reducing its Index"
        (with-capability (SUMMONER)
            (OUROBOROS.ATS|CO_Syphon patron syphon-target atspair syphon-amounts)
        )
    )
    (defun ATS|C_Redeem (patron:string redeemer:string id:string nonce:integer);e
        @doc "Redeems a Hot RBT; \
        \ Redeeming instantly returns RTs, in amounts determined by the <h-promile> and <h-decay> values."
        (with-capability (SUMMONER)
            (OUROBOROS.ATS|CO_Redeem patron redeemer id nonce)
        )
    )
    (defun ATS|C_RemoveSecondary (patron:string remover:string atspair:string reward-token:string);e
        @doc "Removes a secondary Reward-Toke from its ATS Pair \
        \ Secondary Reward Tokens are Reward-Tokens added after the ATS-Pair Creation, \
        \ therefor the Primal Reward Token, (the reward Token the ATS-Pair was created with), cannopt be removed."
        (with-capability (SUMMONER)
            (OUROBOROS.ATS|CO_RemoveSecondary patron remover atspair reward-token)
        )
    )
    ;;VST
    (defun VST|C_CreateVestingLink:string (patron:string dptf:string);e
        @doc "Creates an immutable Vesting Pair between the input DPTF Token and a DPMF Token that will be created by this function \
            \ Incurrs the necessary costs for issuing a DPMF Token"
        (with-capability (SUMMONER)
            (let
                (
                    (output:string (AUTOSTAKE.VST|CO_CreateVestingLink patron dptf))
                )
                (OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
                output
            )
        )
    )
    (defun VST|C_Vest (patron:string vester:string target-account:string id:string amount:decimal offset:integer duration:integer milestones:integer);e
        @doc "Vests <id> given input parameters to its DPMF Vesting Counterpart to <target-account>"
        (with-capability (SUMMONER)
            (AUTOSTAKE.VST|CO_Vest patron vester target-account id amount offset duration milestones)
        )
    )
    (defun VST|C_CoilAndVest:decimal (patron:string coiler-vester:string atspair:string coil-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer);e
        @doc "Autostakes <coil-token> and outputs its vested counterpart, to the <target-account> \
            \ Fails if the c-rbt doesnt have an active vesting counterpart"
        (with-capability (SUMMONER)
            (AUTOSTAKE.VST|CO_CoilAndVest patron coiler-vester atspair coil-token amount target-account offset duration milestones)
        )
    )
    (defun VST|C_CurlAndVest:decimal (patron:string curler-vester:string atspair1:string atspair2:string curl-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer);e
        @doc "Autostakes <curl-token> twice and outputs its vested counterpart when it exists, to the <target-account> \
            \ Fails if the c-rbt of <atspair2> doesnt have an active vesting counterpart"
        (with-capability (SUMMONER)
            (AUTOSTAKE.VST|CO_CurlAndVest patron curler-vester atspair1 atspair2 curl-token amount target-account offset duration milestones)
        )
    )
    (defun VST|C_Cull (patron:string culler:string id:string nonce:integer);e
        @doc "Culls a DPMF representing a Vested Token \
        \ Culling returns to culler any amounts that can be released by the Vesting Schedule as DPTF Tokens"
        (with-capability (SUMMONER)
            (AUTOSTAKE.VST|CO_Cull patron culler id nonce)
        )
    )
    ;;LQD
    (defun LQD|C_WrapKadena (patron:string wrapper:string amount:decimal);e
        @doc "Wraps native Kadena to DALOS Kadena"
        (with-capability (SUMMONER)
            (LIQUID.LIQUID|CO_WrapKadena patron wrapper amount)
        )
    )
    (defun LQD|C_UnwrapKadena (patron:string unwrapper:string amount:decimal);e
        @doc "Unwraps DALOS Kadena to native Kadena"
        (with-capability (SUMMONER)
            (LIQUID.LIQUID|CO_UnwrapKadena patron unwrapper amount)
        )
    )
    ;;OUROBOROS
    (defun OUROBOROS|C_FuelLiquidStakingFromReserves (patron:string);e
        @doc "Uses Native KDA cumulated reserves to fuel the Liquid Staking Protocol"
        (with-capability (SUMMONER)
            (OUROBOROS.OUROBOROS|CO_FuelLiquidStakingFromReserves  patron)
        )
    )
    (defun OUROBOROS|C_WithdrawFees (patron:string id:string target:string);e
        @doc "When DPTF <id> <fee-target> is left default (Ouroboros Smart DALOS Account) \
            \ and the DPTF Token is set-up with a fee, fee cumulates to the Ouroboros Smart Account \
            \ The DPTF Token Owner can then withdraw these fees."
        (with-capability (SUMMONER)
            (OUROBOROS.OUROBOROS|CO_WithdrawFees patron id target)
        )
    )
    (defun IGNIS|C_Sublimate:decimal (patron:string client:string target:string ouro-amount:decimal);e
        @doc "Generates GAS(Ignis) from Ouroboros via Sublimation by <client> to <target> \
            \ This means ANY Standard DALOS Account can generate GAS(Ignis) for any other Standard DALOS Account \
            \ Smart DALOS Accounts cannot be used as <client> or <target> \
            \ Ouroboros sublimation costs no GAS(Ignis) \
            \ Ouroboros Price is set at a minimum 1$ \
            \ GAS(Ignis) is generated always in whole amounts (ex 1.0 2.0 etc) (even though itself is of decimal type) \
            \ Returns the amount of GAS(Ignis) generated"
        (with-capability (SUMMONER)
            (OUROBOROS.IGNIS|CO_Sublimate patron client target ouro-amount)
        )
    )
    (defun IGNIS|C_Compress:decimal (patron:string client:string ignis-amount:decimal);e
        @doc "Generates Ouroboros from GAS(Ignis) via Compression by <client> for itself \
            \ Any Standard DALOS Accounts can compress GAS(Ignis) \
            \ GAS(Ignis) compression costs no GAS(Ignis) \
            \ Ouroboros Price is set at a minimum 1$ \
            \ Can only compress whole amounts of GAS(Ignis) \
            \ Returns the amount of Ouroboros generated"
        (with-capability (SUMMONER)
            (OUROBOROS.IGNIS|CO_Compress patron client ignis-amount)
        )
    )
    ;;       [57] Auxiliary Usage Functions             [X]
    (defun DALOS|X_Initialise (patron:string)
        @doc "Main administrative function that initialises the DALOS Virtual Blockchain"
        (require-capability (OUROBOROS-ADMIN))
        ;;STEP Primordial - Setting Up Policies for Inter-Module Communication
            (BASIS.BASIS|DefinePolicies)
            (AUTOSTAKE.ATS|DefinePolicies)
            (LIQUID.LIQUID|DefinePolicies)
            (OUROBOROS.OUROBOROS|DefinePolicies)
            (TALOS.TALOS|DefinePolicies)

        ;;STEP 0
        ;;Deploy the <Dalos> Smart DALOS Account
            (DALOS.DALOS|CO_DeploySmartAccount DALOS.DALOS|SC_NAME (keyset-ref-guard DALOS.DALOS|SC_KEY) DALOS.DALOS|SC_KDA-NAME patron)
        ;;Deploy the <Autostake> Smart DALOS Account
            (DALOS.DALOS|CO_DeploySmartAccount AUTOSTAKE.ATS|SC_NAME (keyset-ref-guard AUTOSTAKE.ATS|SC_KEY) AUTOSTAKE.ATS|SC_KDA-NAME patron)
            (AUTOSTAKE.ATS|SetGovernor patron)
        ;;Deploy the <Vesting> Smart DALOS Account
            (DALOS.DALOS|CO_DeploySmartAccount AUTOSTAKE.VST|SC_NAME (keyset-ref-guard AUTOSTAKE.VST|SC_KEY) AUTOSTAKE.VST|SC_KDA-NAME patron)
            (AUTOSTAKE.VST|SetGovernor patron)
        ;;Deploy the <Liquidizer> Smart DALOS Account
            (DALOS.DALOS|CO_DeploySmartAccount LIQUID.LIQUID|SC_NAME (keyset-ref-guard LIQUID.LIQUID|SC_KEY) LIQUID.LIQUID|SC_KDA-NAME patron)
            (LIQUID.LIQUID|SetGovernor patron)
        ;;Deploy the <Ouroboros> Smart DALOS Account
            (DALOS.DALOS|CO_DeploySmartAccount OUROBOROS.OUROBOROS|SC_NAME (keyset-ref-guard OUROBOROS.OUROBOROS|SC_KEY) OUROBOROS.OUROBOROS|SC_KDA-NAME patron)
            (OUROBOROS.OUROBOROS|SetGovernor patron)

        ;;STEP 1
        ;;Insert Blank Info in the DALOS|PropertiesTable (so that it can be updated afterwards)
            (insert DALOS.DALOS|PropertiesTable DALOS.DALOS|INFO
                {"demiurgoi"                : 
                    [
                        "Ѻ.CЭΞŸNGúůρhãmИΘÛ¢₳šШдìAÚwŚGýηЗПAÊУÔȘřŽÍζЗηmΔφDmcдΛъ₳tĂýăŮsПÞ$öœGθeBŽvąαÃfçл¢ĎĆď$şbsЦэΘNÄëÍĂνуãöž¥àZjÆůšÁœôñχŽâЩåτâн4μфAOçĎΓuЗŮnøЙãĚè6Дżîþż$цÑûρψŻïZÉλûæřΨeèÎígςeL"
                        "Ѻ.ÍăüÙÜЦżΦF₿ÈшÕóñĐĞGюѺλωÇțnθòoйEςк₱0дş3ôPpxŞțqgЖ€šωbэočΞìČ5òżŁdŒИöùЪøŤяжλзÜ2ßżpĄγïčѺöэěτČэεSčDõžЩУЧÀ₳ŚàЪЙĎpЗΣ2ÃлτíČнÙyéÕãďWŹŘĘźσПåbã€éѺι€ΓφŠ₱ŽyWcy5ŘòmČ₿nβÁ¢¥NЙëOι"
                    ]
                ,"unity-id"                 : UTILS.BAR
                ,"gas-source-id"            : UTILS.BAR
                ,"gas-source-id-price"      : 0.0
                ,"gas-id"                   : UTILS.BAR
                ,"ats-gas-source-id"        : UTILS.BAR
                ,"elite-ats-gas-source-id"  : UTILS.BAR
                ,"wrapped-kda-id"           : UTILS.BAR
                ,"liquid-kda-id"            : UTILS.BAR}
            )
        ;;Set Virtual Blockchain KDA Prices
            (DALOS.DALOS|A_UpdateUsagePrice "standard"      10.0)
            (DALOS.DALOS|A_UpdateUsagePrice "smart"         20.0)
            (DALOS.DALOS|A_UpdateUsagePrice "dptf"         200.0)
            (DALOS.DALOS|A_UpdateUsagePrice "dpmf"         300.0)
            (DALOS.DALOS|A_UpdateUsagePrice "dpsf"         400.0)
            (DALOS.DALOS|A_UpdateUsagePrice "dpnf"         500.0)
            (DALOS.DALOS|A_UpdateUsagePrice "blue"          25.0)
        ;;Set Information in the DALOS|GasManagementTable
            (insert DALOS.DALOS|GasManagementTable DALOS.DALOS|VGD
                {"virtual-gas-tank"         : DALOS.DALOS|SC_NAME
                ,"virtual-gas-toggle"       : false
                ,"virtual-gas-spent"        : 0.0
                ,"native-gas-toggle"        : false
                ,"native-gas-spent"         : 0.0}
            )

        ;;STEP 2
        (let*
            (
                (core-tf:[string]
                    (BASIS.DPTF|CO_Issue
                        patron
                        DALOS.DALOS|SC_NAME
                        ["Ouroboros" "Auryn" "EliteAuryn" "Ignis" "DalosWrappedKadena" "DalosLiquidKadena"]
                        ["OURO" "AURYN" "ELITEAURYN" "GAS" "DWK" "DLK"]
                        [24 24 24 24 24 24]
                        [true true true true true true]         ;;can change owner
                        [true true true true true true]         ;;can upgrade
                        [true true true true true true]         ;;can can-add-special-role
                        [true false false true false false]     ;;can-freeze
                        [true false false false false false]    ;;can-wipe
                        [true false false true false false]     ;;can pause
                    )
                )
                (OuroID:string (at 0 core-tf))
                (AurynID:string (at 1 core-tf))
                (EliteAurynID:string (at 2 core-tf))
                (GasID:string (at 3 core-tf))
                (WrappedKadenaID:string (at 4 core-tf))
                (StakedKadenaID:string (at 5 core-tf))
            )
        ;;STEP 2.1 - Update DALOS|PropertiesTable with new Data
            (update DALOS.DALOS|PropertiesTable DALOS.DALOS|INFO
                { "gas-source-id"           : OuroID
                , "gas-id"                  : GasID
                , "ats-gas-source-id"       : AurynID
                , "elite-ats-gas-source-id" : EliteAurynID
                , "wrapped-kda-id"          : WrappedKadenaID
                , "liquid-kda-id"           : StakedKadenaID
                }
            )
        ;;STEP 2.2 - Issue needed DPTF Accounts
            (DPTF|C_DeployAccount AurynID AUTOSTAKE.ATS|SC_NAME)
            (DPTF|C_DeployAccount EliteAurynID AUTOSTAKE.ATS|SC_NAME)
            (DPTF|C_DeployAccount WrappedKadenaID LIQUID.LIQUID|SC_NAME)
            (DPTF|C_DeployAccount StakedKadenaID LIQUID.LIQUID|SC_NAME)
        ;;STEP 2.3 - Set Up Auryn and Elite-Auryn
            (DPTF|C_SetFee patron AurynID UTILS.AURYN_FEE)
            (DPTF|C_SetFee patron EliteAurynID UTILS.ELITE-AURYN_FEE)
            (DPTF|C_ToggleFee patron AurynID true)
            (DPTF|C_ToggleFee patron EliteAurynID true)
            (BASIS.DPTF|CO_ToggleFeeLock patron AurynID true)
            (BASIS.DPTF|CO_ToggleFeeLock patron EliteAurynID true)
        ;;STEP 2.4 - Set Up Ignis
            ;;Setting Up Ignis Parameters
            (DPTF|C_SetMinMove patron GasID 1000.0)
            (DPTF|C_SetFee patron GasID -1.0)
            (DPTF|C_SetFeeTarget patron GasID DALOS.DALOS|SC_NAME)
            (DPTF|C_ToggleFee patron GasID true)
            (BASIS.DPTF|CO_ToggleFeeLock patron GasID true)
            ;;Setting Up Compression|Sublimation Permissions
            (DPTF|C_ToggleBurnRole patron GasID OUROBOROS.OUROBOROS|SC_NAME true)
            (DPTF|C_ToggleBurnRole patron OuroID OUROBOROS.OUROBOROS|SC_NAME true)
            (DPTF|C_ToggleMintRole patron GasID OUROBOROS.OUROBOROS|SC_NAME true)
            (DPTF|C_ToggleMintRole patron OuroID OUROBOROS.OUROBOROS|SC_NAME true)
        ;;STEP 2.5 - Set Up Liquid-Staking System
            ;;Setting Liquid Staking Tokens Parameters
            (DPTF|C_SetFee patron StakedKadenaID -1.0)
            (DPTF|C_ToggleFee patron StakedKadenaID true)
            (BASIS.DPTF|CO_ToggleFeeLock patron StakedKadenaID true)
            ;;Setting Liquid Staking Tokens Roles
            (DPTF|C_ToggleBurnRole patron WrappedKadenaID LIQUID.LIQUID|SC_NAME true)
            (DPTF|C_ToggleMintRole patron WrappedKadenaID LIQUID.LIQUID|SC_NAME true)
        ;;STEP 2.6 - Create Vesting Pairs
            (AUTOSTAKE.VST|CO_CreateVestingLink patron OuroID)
            (AUTOSTAKE.VST|CO_CreateVestingLink patron AurynID)
            (AUTOSTAKE.VST|CO_CreateVestingLink patron EliteAurynID)
        
        ;:STEP 3 - Initialises Autostake Pairs
            (let*
                (
                    (Auryndex:string
                        (ATS|C_Issue
                            patron
                            patron
                            "Auryndex"
                            24
                            OuroID
                            true
                            AurynID
                            false
                        )
                    )
                    (Elite-Auryndex:string
                        (ATS|C_Issue
                            patron
                            patron
                            "EliteAuryndex"
                            24
                            AurynID
                            true
                            EliteAurynID
                            true
                        )
                    )
                    (Kadena-Liquid-Index:string
                        (ATS|C_Issue
                            patron
                            patron
                            "Kadindex"
                            24
                            WrappedKadenaID
                            false
                            StakedKadenaID
                            true
                        )
                    )
                    (core-idx:[string] [Auryndex Elite-Auryndex Kadena-Liquid-Index])
                )
        ;;STEP 3.1 - Set Up <Auryndex> Autostake-Pair
                (ATS|C_SetColdFee patron Auryndex
                    7
                    [50.0 100.0 200.0 350.0 550.0 800.0]
                    [
                        [8.0 7.0 6.0 5.0 4.0 3.0 2.0]
                        [9.0 8.0 7.0 6.0 5.0 4.0 3.0]
                        [10.0 9.0 8.0 7.0 6.0 5.0 4.0]
                        [11.0 10.0 9.0 8.0 7.0 6.0 5.0]
                        [12.0 11.0 10.0 9.0 8.0 7.0 6.0]
                        [13.0 12.0 11.0 10.0 9.0 8.0 7.0]
                        [14.0 13.0 12.0 11.0 10.0 9.0 8.0]
                    ]
                )
                (ATS|C_TurnRecoveryOn patron Auryndex true)
        ;;STEP 3.2 - Set Up <EliteAuryndex> Autostake-Pair
                (ATS|C_SetColdFee patron Elite-Auryndex 7 [0.0] [[0.0]])
                (ATS|C_SetCRD patron Elite-Auryndex false 360 24)
                (ATS|C_ToggleElite patron Elite-Auryndex true)
                (ATS|C_TurnRecoveryOn patron Elite-Auryndex true)
        ;;STEP 3.3 - Set Up <Kadindex> Autostake-Pair
                (ATS|C_SetColdFee patron Kadena-Liquid-Index -1 [0.0] [[0.0]])
                (ATS|C_SetCRD patron Kadena-Liquid-Index false 12 6)
                (ATS|C_TurnRecoveryOn patron Kadena-Liquid-Index true)
        ;;STEP 4 - Return Token Ownership to their respective Smart DALOS Accounts
                (DPTF|C_ChangeOwnership patron AurynID AUTOSTAKE.ATS|SC_NAME)
                (DPTF|C_ChangeOwnership patron EliteAurynID AUTOSTAKE.ATS|SC_NAME)
                (DPTF|C_ChangeOwnership patron WrappedKadenaID LIQUID.LIQUID|SC_NAME)
                (DPTF|C_ChangeOwnership patron StakedKadenaID LIQUID.LIQUID|SC_NAME)
        ;;STEP 5 - Return as Output a list of all Token-IDs and ATS-Pair IDs that were created
                (+ core-tf core-idx)
            )
        )
    )
    

)