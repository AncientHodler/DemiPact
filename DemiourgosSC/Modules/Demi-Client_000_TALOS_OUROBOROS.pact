;(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")
(module TALOS|OUROBOROS GOVERNANCE
    ;(use n_e096dec549c18b706547e425df9ac0571ebd00b0.OUROBOROS)
    (use OUROBOROS)

    (defcap GOVERNANCE ()
        (compose-capability (TALOS-ADMIN))
    )
    (defcap TALOS-ADMIN ()
        (enforce-guard G-MD_TALOS)
    )
    (defconst G-MD_TALOS (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst DALOS|SC_NAME                 DALOS.DALOS|SC_NAME)
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
        (OUROBOROS.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (SUMMONER))
        )
    )
    ;;        [4] Client Usage FUNCTIONS                [C]
    ;;
    (defun C_FuelLiquidStakingFromReserves (patron:string)
        @doc "Uses Native KDA cumulated reserves to fuel the Liquid Staking Protocol"
        (with-capability (S)
            (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves  patron)
        )
    )
    (defun C_WithdrawFees (patron:string id:string target:string)
        @doc "When DPTF <id> <fee-target> is left default (Ouroboros Smart DALOS Account) \
            \ and the DPTF Token is set-up with a fee, fee cumulates to the Ouroboros Smart Account \
            \ The DPTF Token Owner can then withdraw these fees."
        (with-capability (S)
            (OUROBOROS.OUROBOROS|C_WithdrawFees patron id target)
        )
    )
    (defun IGNIS|C_Sublimate:decimal (patron:string client:string target:string ouro-amount:decimal)
        @doc "Generates GAS(Ignis) from Ouroboros via Sublimation by <client> to <target> \
            \ This means ANY Standard DALOS Account can generate GAS(Ignis) for any other Standard DALOS Account \
            \ Smart DALOS Accounts cannot be used as <client> or <target> \
            \ Ouroboros sublimation costs no GAS(Ignis) \
            \ Ouroboros Price is set at a minimum 1$ \
            \ GAS(Ignis) is generated always in whole amounts (ex 1.0 2.0 etc) (even though itself is of decimal type) \
            \ Returns the amount of GAS(Ignis) generated"
        (with-capability (S)
            (OUROBOROS.IGNIS|C_Sublimate patron client target ouro-amount)
        )
    )
    (defun IGNIS|C_Compress:decimal (patron:string client:string ignis-amount:decimal)
        @doc "Generates Ouroboros from GAS(Ignis) via Compression by <client> for itself \
            \ Any Standard DALOS Accounts can compress GAS(Ignis) \
            \ GAS(Ignis) compression costs no GAS(Ignis) \
            \ Ouroboros Price is set at a minimum 1$ \
            \ Can only compress whole amounts of GAS(Ignis) \
            \ Returns the amount of Ouroboros generated"
        (with-capability (S)
            (OUROBOROS.IGNIS|C_Compress patron client ignis-amount)
        )
    )
)