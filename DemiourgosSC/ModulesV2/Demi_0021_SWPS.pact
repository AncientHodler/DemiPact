(module SWPS GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (SWPS-ADMIN))
    )
    (defcap SWPS-ADMIN ()
        (enforce-one
            "SWPS Swapper Admin not satisfed"
            [
                (enforce-guard G-MD_SWPS)
                (enforce-guard G-SC_SWPS)
            ]
        )
    )

    (defconst G-MD_SWPS   (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_SWPS   (keyset-ref-guard SWP.SWP|SC_KEY))
    ;;
    (defcap P|SWPS|CALLER ()
        true
    )
    (defcap P|SWPS|REMOTE-GOV ()
        true
    )
    ;;
    (defun A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (SWPS-ADMIN)
            (write PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun C_ReadPolicy:guard (policy-name:string)
        (at "policy" (read PoliciesTable policy-name ["policy"]))
    )
    (defun DefinePolicies ()
        true
        (SWP.A_AddPolicy
            "SWPS|Caller"
            (create-capability-guard (P|SWPS|CALLER))
        )
        (SWP.A_AddPolicy
            "SWPS|RemoteSwapGovernor"
            (create-capability-guard (P|SWPS|REMOTE-GOV))
        )
    )
    (deftable PoliciesTable:{DALOS.PolicySchema})

)

(create-table PoliciesTable)