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
    (defun SWP|C_IssueStandard:string (patron:string account:string pool-tokens:[object{SWP.SWP|PoolTokens}] fee-lp:decimal)
        (with-capability (S)
            (let
                (
                    (output:string (SWPM.SWPM|C_IssueStandard patron account pool-tokens fee-lp))
                )
                (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
                output
            )
        )
    )
    (defun SWP|C_IssueStable:string (patron:string account:string pool-tokens:[object{SWP.SWP|PoolTokens}] fee-lp:decimal amp:decimal)
        (with-capability (S)
            (let
                (
                    (output:string (SWPM.SWPM|C_IssueStable patron account pool-tokens fee-lp amp))
                )
                (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
                output
            )
        )
    )
)