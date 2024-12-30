(module TALOS-02 GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (TALOS-ADMIN))
    )
    (defcap TALOS-ADMIN ()
        (enforce-guard G-MD_TALOS)
    )
    (defconst G-MD_TALOS (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst DALOS|SC_NAME DALOS.DALOS|SC_NAME)

    ;;Policies
    (defcap S ()
        true
    )
    (defun DefinePolicies ()
        (SWPM.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
    )
    ;;
    (defun SWP|C_ToggleFeeLock (patron:string swpair:string toggle:bool)
        (with-capability (S)
            (SWPM.SWPM|C_ToggleFeeLock patron swpair toggle)
            (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    (defun SWP|C_Issue:string (patron:string account:string token-a:string token-b:string token-a-amount:decimal token-b-amount:decimal fee-lp:decimal)
        (with-capability (S)
            (let
                (
                    (output:string (SWPM.SWPM|C_Issue patron account token-a token-b token-a-amount token-b-amount fee-lp))
                )
                (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
                output
            )
        )
    )
)