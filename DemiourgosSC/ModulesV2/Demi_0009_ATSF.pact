;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module ATSF GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (ATSF-ADMIN))
    )
    (defcap ATSF-ADMIN ()
        (enforce-one
            "ATSF Autostake Admin not satisfed"
            [
                (enforce-guard G-MD_ATSF)
                (enforce-guard G-SC_ATSF)
            ]
        )
    )

    (defconst G-MD_ATSF   (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_ATSF   (keyset-ref-guard ATS.ATS|SC_KEY))

    (defcap COMPOSE ()
        true
    )
    (defcap SECURE ()
        true
    )

    (defun A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (ATSF-ADMIN)
            (write PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun C_ReadPolicy:guard (policy-name:string)
        (at "policy" (read PoliciesTable policy-name ["policy"]))
    )
    
    (defcap P|ATSF|REMOTE-GOV ()
        true
    )
    (defcap P|ATSF|UPDATE_ROU ()
        true
    )
    ;;
    (defun DefinePolicies ()
        (ATS.A_AddPolicy
            "ATSF|UpdateROU"
            (create-capability-guard (P|ATSF|UPDATE_ROU))
        )
        (ATS.A_AddPolicy
            "ATSF|RemoteAutostakeGovernor"
            (create-capability-guard (P|ATSF|REMOTE-GOV))
        )
    )

    (deftable PoliciesTable:{DALOS.PolicySchema})
    ;;
    ;;Usage
    (defcap ATSF|FUEL (atspair:string reward-token:string)
        @event
        (ATS.ATS|UEV_RewardTokenExistance atspair reward-token true)
        (compose-capability (P|ATSF|UPDATE_ROU))
        (compose-capability (P|ATSF|REMOTE-GOV))
        (let
            (
                (index:decimal (ATS.ATS|UC_Index atspair))
            )
            (enforce (>= index 0.1) "Fueling cannot take place on a negative Index")
        )
    )
    (defun ATSF|C_Fuel (patron:string fueler:string atspair:string reward-token:string amount:decimal)
        (with-capability (ATSF|FUEL atspair reward-token)
            (TFT.DPTF|C_Transfer patron reward-token fueler ATS.ATS|SC_NAME amount true)
            (ATS.ATS|XO_UpdateRoU atspair reward-token true true amount)
        )
    )
)

(create-table PoliciesTable)