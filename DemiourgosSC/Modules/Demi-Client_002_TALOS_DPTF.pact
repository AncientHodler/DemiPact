;(namespace n_e096dec549c18b706547e425df9ac0571ebd00b0)
(module TALOS|DPTF GOVERNANCE
    ;(use n_e096dec549c18b706547e425df9ac0571ebd00b0.BASIS)
    ;(use n_e096dec549c18b706547e425df9ac0571ebd00b0.TFT)
    ;(use n_e096dec549c18b706547e425df9ac0571ebd00b0.ATSI)
    ;(use n_e096dec549c18b706547e425df9ac0571ebd00b0.BRANDING)
    (use BASIS)
    (use TFT)
    (use ATSI)
    (use BRANDING)

    (defcap GOVERNANCE ()
        (compose-capability (TALOS-ADMIN))
    )
    (defcap TALOS-ADMIN ()
        (enforce-guard G-MD_TALOS)
    )
    (defconst G-MD_TALOS (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst DALOS|SC_NAME DALOS.DALOS|SC_NAME)
    (defcap SUMMONER ()
        true
    )
    (defcap P|DALOS|AUTO_PATRON ()
        true
    )
    (defcap S ()
        (compose-capability (SUMMONER))
        (compose-capability (P|DALOS|AUTO_PATRON))
    )
    (defun DefinePolicies ()
        (BASIS.A_AddPolicy
            "TALOS|T|Summoner"
            (create-capability-guard (SUMMONER))
        )
        (TFT.A_AddPolicy
            "TALOS|T|Summoner"
            (create-capability-guard (SUMMONER))
        )
        (ATSI.A_AddPolicy
            "TALOS|T|Summoner"
            (create-capability-guard (SUMMONER))
        )
        (BRANDING.A_AddPolicy
            "TALOS|T|Summoner"
            (create-capability-guard (SUMMONER))
        )
    )
    ;;       [27] Client Usage FUNCTIONS
    ;;
    (defun C_DeployAccount (id:string account:string)
        @doc "Deploys a new DPTF Account for <id> and <account> (DALOS account must exist)"
        (with-capability (S)
            (BASIS.DPTF-DPMF|C_DeployAccount id account true)
        )
    )
    (defun C_UpdateBranding (patron:string id:string logo:string description:string website:string social:[object{DALOS.SocialSchema}])
        @doc "Updates Pending-Branding with new branding data, 100 IGNIS Cost \
            \ Must be approved from DALOS Admin (moving it from Pending-Branding to Branding)"
        (with-capability (S)
            (BRANDING.DPTF-DPMF|C_UpdateBranding patron id true logo description website social)
        )
    )
    (defun C_UpgradeBranding (patron:string id:string months:integer)
        @doc "Pays KDA to upgrade to Blue Flag for Token <id>"
        (with-capability (S)
            (BRANDING.BRD|C_UpgradeBranding patron id true months)
            (TALOS|OUROBOROS.C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    (defun C_ChangeOwnership (patron:string id:string new-owner:string)
        @doc "Moves DPTF <id> Token Ownership to <new-owner> DPTF Account"
        (with-capability (S)
            (BASIS.DPTF-DPMF|C_ChangeOwnership patron id new-owner true)
        )
    )
    (defun C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Freeze/Unfreeze via boolean <toggle> <id> on DPTF <account>"
        (with-capability (S)
            (BASIS.DPTF-DPMF|C_ToggleFreezeAccount patron id account toggle true)
        )
    )
    (defun C_TogglePause (patron:string id:string toggle:bool)
        @doc "Pause/Unpause <id> via the boolean <toggle> \
        \ Paused True Fungible cannot be transferred."
        (with-capability (S)
            (BASIS.DPTF-DPMF|C_TogglePause patron id toggle true)
        )
    )
    (defun C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Sets |role-burn| to <toggle> for <id> and DPTF <account>"
        (with-capability (S)
            (ATSI.DPTF-DPMF|C_ToggleBurnRole patron id account toggle true)
        )
    )
    (defun C_ToggleMintRole (patron:string id:string account:string toggle:bool)
        @doc "Sets |role-mint| to <toggle> for <id> and DPTF <account>"
        (with-capability (S)
            (ATSI.DPTF|C_ToggleMintRole patron id account toggle)
        )
    )
    (defun C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Sets |role-transfer| to <toggle> for <id> and DPTF <account>. \
            \ When |role-transfer| is true, transfers are restricted. \
            \ and will only be allowed to DPTF Accounts with |role-transfer| true, \
            \ while these Accounts can transfer the TF freely"
        (with-capability (S)
            (BASIS.DPTF-DPMF|C_ToggleTransferRole patron id account toggle true)
        )
    )
    (defun C_ToggleFeeExemptionRole (patron:string id:string account:string toggle:bool)
        @doc "Sets |role-fee-exemption| to <toggle> for TrueFungible <id> and DPTF <account> \
            \ Only dor Smart DALOS Accounts"
        (with-capability (S)
            (ATSI.DPTF|C_ToggleFeeExemptionRole patron id account toggle)
        )
    )
    (defun C_Wipe (patron:string id:string atbw:string)
        @doc "Wipes all supply of <id> of a frozen DPTF <account>"
        (with-capability (S)
            (BASIS.DPTF-DPMF|C_Wipe patron id atbw true)
        )
    )
    (defun C_Burn (patron:string id:string account:string amount:decimal)
        @doc "Burns DPTF Token <id> from <account>. <Account> needs |role-burn| set to true for <id>"
        (with-capability (S)
            (BASIS.DPTF|C_Burn patron id account amount)
        )
    )
    (defun C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool)
        @doc "Controls TrueFungible <id> Properties using 6 boolean control triggers \
            \ A false <can-upgrade> property disables all future Control of Properties"
        (with-capability (S)
            (BASIS.DPTF|C_Control patron id cco cu casr cf cw cp)
        )
    )
    (defun C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
        @doc "Issues Multiple DPTF Tokens at once \
        \ Can also be used for issuing a single DPTF Token \
        \ Outputs a list with the IDs of the Issued Tokens \
        \ Also creates multiple DPTF Account(s)"
        (with-capability (S)
            (let
                (
                    (output:[string] (BASIS.DPTF|C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause))
                )
                (TALOS|OUROBOROS.C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
                output
            )
        )
    )
    (defun C_Mint (patron:string id:string account:string amount:decimal origin:bool)
        @doc "Mints DPTF Token <id> from <account>. <Account> needs |role-mint| set to true for <id> for the Generic Mint \
            \ True <origin> mints the premine: does not require |role-mint| \
            \ Requires token ownership with 0.0 supply; can only be done once; amount is saved in the Token Properties"
        (with-capability (S)
            (BASIS.DPTF|C_Mint patron id account amount origin)
        )
    )
    (defun C_SetFee (patron:string id:string fee:decimal)
        @doc "Sets the <fee-promile> for DPTF Token <id> to <fee> \
            \ -1.0 activates the Volumetric Transaction Tax (VTT) mechanic."
        (with-capability (S)
            (BASIS.DPTF|C_SetFee patron id fee)
        )
    )
    (defun C_SetFeeTarget (patron:string id:string target:string)
        @doc "Sets the <fee-target> for DPTF Token <id> to <target> \
            \ Default is DALOS.OUROBOROS|SC_NAME (token owner retrieval) \
            \ Setting it to DALOS.DALOS|SC_NAME makes fee act like collected gas (distributed to DALOS Custodians)"
        (with-capability (S)
            (BASIS.DPTF|C_SetFeeTarget patron id target)
        )          
    )
    (defun C_SetMinMove (patron:string id:string min-move-value:decimal)
        @doc "Sets the <min-move> for the DPTF Token <id> to <min-move-value> \
            \ Minimum that can be transfered in standard conditions"
        (with-capability (S)
            (BASIS.DPTF|C_SetMinMove patron id min-move-value)
        )          
    )
    (defun C_ToggleFee (patron:string id:string toggle:bool)
        @doc "Toggles <fee-toggle> for the DPTF Token <id> to <toggle> \
            \ <fee-toggle> must be set to true for fee collection to execute"
        (with-capability (S)
            (BASIS.DPTF|C_ToggleFee patron id toggle)
        )          
    )
    (defun C_ToggleFeeLock (patron:string id:string toggle:bool)
        @doc "Sets the <fee-lock> for DPTF Token <id> to <toggle> \
            \ Unlocking (<toggle> = false) has restrictions: \
            \ - Max 7 unlocks per token \
            \ - Unlock cost: (10000 IGNIS + 100 KDA) * (fee-unlocks + 1) \
            \ - Each unlock adds Secondary Fee collected by the <GasTanker> Account \
            \ equal to the VTT * fee-unlocks: <UTILS.DPTF|UC_VolumetricTax>"
        (with-capability (S)
            (BASIS.DPTF|C_ToggleFeeLock patron id toggle)
            (TALOS|OUROBOROS.C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    (defun C_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal)
        @doc "Transfers a DPTF Token from <sender> to <receiver>"
        (with-capability (S)
            (TFT.DPTF|C_Transfer patron id sender receiver transfer-amount false)
        )
    )
    (defun CM_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal)
        @doc "Similar to <DPTF|C_Transfer>, but methodic for use when operating with Smart DALOS Accounts"
        (with-capability (S)
            (TFT.DPTF|C_Transfer patron id sender receiver transfer-amount true)
        )
    )
    (defun C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal])
        @doc "Transfers multiple different DPTFs each with its own amount from a <sender> to a <receiver>"
        (with-capability (S)
            (TFT.DPTF|X_MultiTransfer patron id-lst sender receiver transfer-amount-lst false)
        )
    )
    (defun CM_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal])
        @doc "Methodic variant of <DPTF|C_MultiTransfer>"
        (with-capability (S)
            (TFT.DPTF|X_MultiTransfer patron id-lst sender receiver transfer-amount-lst true)
        )
    )
    (defun C_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @doc "Transfers a single DPTF Token to multiple receivers, each with its own amount, in bulk"
        (with-capability (S)
            (TFT.DPTF|X_BulkTransfer patron id sender receiver-lst transfer-amount-lst false)
        )
    )
    (defun CM_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @doc "Methodic variant of <DPTF|C_BulkTransfer>"
        (with-capability (S)
            (TFT.DPTF|X_BulkTransfer patron id sender receiver-lst transfer-amount-lst true)
        )
    )
    (defun C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal)
        @doc "Transmutes a DPTF Token; \
            \ Transmutation = DPTF Fee Collection (without counting towards Native DPTF Fee Volume), \
            \   when the DPTF Token is not part of any ATS-Pair; \
            \ If the Token is part of one or multiple ATS Pairs, \
            \   the input amount will be used to strengthen those ATS-Pairs Indices"
        (with-capability (S)
            (TFT.DPTF|C_Transmute patron id transmuter transmute-amount)
        )
    )
)