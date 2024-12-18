;(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")
(module TALOS|DALOS GOVERNANCE
    ;(use n_e096dec549c18b706547e425df9ac0571ebd00b0.DALOS)
    (use DALOS)

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
        (DALOS.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (SUMMONER))
        )
        (DALOS.A_AddPolicy
            "TALOS|AutomaticPatron"
            (create-capability-guard (P|DALOS|AUTO_PATRON))
        )
    )
    ;;        [2] Administrator Usage FUNCTIONS
    ;;
    (defun A_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        @doc "Deploys a Standard DALOS Account in Administrator Mode"
        (with-capability (S)
            (DALOS.DALOS|A_DeployStandardAccount account guard kadena public)
        )
    )
    (defun A_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        @doc "Deploys a Smart DALOS Account in Administrator Mode"
        (with-capability (S)
            (DALOS.DALOS|A_DeploySmartAccount account guard kadena sovereign public)
        )
    )
    (defun A_ToggleGasCollection (native:bool toggle:bool)
        @doc "Toggle either native (KDA) or virtual (non-native aka IGNIS) gas collection as administrator"
        (DALOS.IGNIS|A_Toggle native toggle)
    )
    (defun A_SetBlockchainOuroPrice (price:decimal)
        @doc "Sets OURO price. This can be triggered automatically by swapping (which modifies its price), or manual, by adming"
        (DALOS.IGNIS|A_SetSourcePrice price)
    )
    (defun A_UpdatesUsagePrice (action:string new-price:decimal)
        @doc "Updates prices in KDA for specific Blockchain Related Functions (ex> issue account, issue token, etc ...)"
        (DALOS.DALOS|A_UpdateUsagePrice action new-price)
    )
    (defun A_UpdatePublicKey (account:string new-public:string)
        @doc "Updates the Public Key of an account. Troubleshooting administration function, in case an account was created with a bad public key \
        \ Until the automatisation of accounts is implemented, this function serves as backup"
        (DALOS.DALOS|A_UpdatePublicKey account new-public)
    )
    ;;        [7] Client Usage FUNCTIONS
    ;;
    (defun C_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        @doc "Deploys a Standard DALOS Account"
        (with-capability (S)
            (DALOS.DALOS|C_DeployStandardAccount account guard kadena public)
            (TALOS|OUROBOROS.C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    (defun C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        @doc "Deploys a Smart DALOS Account"
        (with-capability (S)
            (DALOS.DALOS|C_DeploySmartAccount account guard kadena sovereign public)
            (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    (defun C_RotateGuard (patron:string account:string new-guard:guard safe:bool)
        @doc "Updates the Guard stored in the DALOS|AccountTable"
        (with-capability (S)
            (DALOS.DALOS|C_RotateGuard patron account new-guard safe)
        )
    )
    (defun C_RotateKadena (patron:string account:string kadena:string)
        @doc "Updates the Kadena Account stored in the DALOS|AccountTable"
        (with-capability (S)
            (DALOS.DALOS|C_RotateKadena patron account kadena)
        )
    )
    (defun C_RotateSovereign (patron:string account:string new-sovereign:string)
        @doc "Updates the Smart Account Sovereign Account \
            \ Only works for Smart DALOS Accounts"
        (with-capability (S)
            (DALOS.DALOS|C_RotateSovereign patron account new-sovereign)
        )
    )
    (defun C_RotateGovernor (patron:string account:string governor:guard)
        @doc "Updates the Smart Account Governor, which is the Governing Module \
            \ Only works for Smart DALOS Accounts"
        (with-capability (S)
            (DALOS.DALOS|C_RotateGovernor patron account governor)
        )
    )
    (defun C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool)
        @doc "Manages Smart DALOS Account Type via boolean triggers"
        (with-capability (S)
            (DALOS.DALOS|C_ControlSmartAccount patron account payable-as-smart-contract payable-by-smart-contract payable-by-method)
        )
    )
)