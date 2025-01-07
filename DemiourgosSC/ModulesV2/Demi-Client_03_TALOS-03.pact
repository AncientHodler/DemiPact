(module TALOS-03 GOVERNANCE
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
            (LIQUIDFUEL.C_Fuel DALOS|SC_NAME)
        )
    )
)