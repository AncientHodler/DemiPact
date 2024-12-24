;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module TALOS|DPMF GOVERNANCE
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
            "TALOS|M|Summoner"
            (create-capability-guard (SUMMONER))
        )
        (ATSI.A_AddPolicy
            "TALOS|M|Summoner"
            (create-capability-guard (SUMMONER))
        )
    )
    ;;
    (defun C_DeployAccount (id:string account:string)
        @doc "Similar to <TALOS|DPTF.C_DeployAccount>, but for DPMFs"
        (with-capability (S)
            (BASIS.DPTF-DPMF|C_DeployAccount id account false)
        )
    )
    (defun C_ChangeOwnership (patron:string id:string new-owner:string)
        @doc "Similar to <TALOS|DPTF.C_ChangeOwnership>, but for DPMFs"
        (with-capability (S)
            (BASIS.DPTF-DPMF|C_ChangeOwnership patron id new-owner false)
        )
    )
    (defun C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Similar to <TALOS|DPTF.C_ToggleFreezeAccount>, but for DPMFs"
        (with-capability (S)
            (BASIS.DPTF-DPMF|C_ToggleFreezeAccount patron id account toggle false)
        )
    )
    (defun C_TogglePause (patron:string id:string toggle:bool)
        @doc "Similar to <TALOS|DPTF.C_TogglePause>, but for DPMFs"
        (with-capability (S)
            (BASIS.DPTF-DPMF|C_TogglePause patron id toggle false)
        )
    )
    (defun C_MoveCreateRole (patron:string id:string receiver:string)
        @doc "Moves |role-nft-create| from <sender> to <receiver> DPMF Account for MetaFungible <id> \
            \ Only a single DPMF Account can have the |role-nft-create| \
            \ Afterwards the receiver DPMF Account can crete new Meta Fungibles \ 
            \ Fails if the target DPMF Account doesnt exist"
        (with-capability (S)
            (ATSI.DPMF|C_MoveCreateRole patron id receiver)
        )
    )
    (defun C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool)
        @doc "Sets |role-nft-add-quantity| to <toggle> boolean for MetaFungible <id> and DPMF Account <account> \
            \ Afterwards Account <account> can either add quantity or no longer add quantity to existing MetaFungible"
        (with-capability (S)
            (ATSI.DPMF|C_ToggleAddQuantityRole patron id account toggle)
        )
    )
    (defun C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to <TALOS|DPTF.C_ToggleBurnRole>, but for DPMFs"
        (with-capability (S)
            (ATSI.DPTF-DPMF|C_ToggleBurnRole patron id account toggle false)
        )
    )
    (defun C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to <TALOS|DPTF.C_ToggleTransferRole>, but for DPMFs"
        (with-capability (S)
            (BASIS.DPTF-DPMF|C_ToggleTransferRole patron id account toggle false)
        )
    )
    (defun C_Wipe (patron:string id:string atbw:string)
        @doc "Similar to <TALOS|DPTF.C_Wipe>, but for DPMFs"
        (with-capability (S)
            (BASIS.DPTF-DPMF|C_Wipe patron id atbw false)
        )
    )
    (defun C_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Adds quantity for an existing DPMF Token"
        (with-capability (S)
            (BASIS.DPMF|C_AddQuantity patron id nonce account amount)
        )
    )
    (defun C_Burn (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Similar to <TALOS|DPTF.C_Burn>, but for DPMFs"
        (with-capability (S)
            (BASIS.DPMF|C_Burn patron id nonce account amount)
        )
    )
    (defun C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool)
        @doc "Similar to <TALOS|DPTF.C_Control>, but for DPMFs"
        (with-capability (S)
            (BASIS.DPMF|C_Control patron id cco cu casr cf cw cp ctncr)
        )
    )
    (defun C_Create:integer (patron:string id:string account:string meta-data:[object])
        @doc "Creates a new DPMF Token with the next nonce and zero amount value, for a DPMF Token already issued."
        (with-capability (S)
            (BASIS.DPMF|C_Create patron id account meta-data)
        )
    )
    (defun C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        @doc "Similar to <TALOS|DPTF.C_Issue>, but for DPMFs"
        (with-capability (S)
            (let
                (
                    (output:[string] (BASIS.DPMF|C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role))
                )
                (TALOS|OUROBOROS.C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
                output
            )
        )
    )
    (defun C_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object])
        @doc "Mints a new DPMF Token. Minting means creating and adding supply in a single swoop."
        (with-capability (S)
            (BASIS.DPMF|C_Mint patron id account amount meta-data)
        )
    )
    (defun C_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal)
        @doc "Similar to <TALOS|DPTF.C_Transfer>, but for DPMFs"
        (with-capability (S)
            (BASIS.DPMF|C_Transfer patron id nonce sender receiver transfer-amount false)
        )
    )
    (defun CM_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal)
        @doc "Methodic variant of <DPMF|C_Transfer>"
        (with-capability (S)
            (BASIS.DPMF|C_Transfer patron id nonce sender receiver transfer-amount true)
        )
    )
)