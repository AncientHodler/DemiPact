(module SWPM GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (SWPM-ADMIN))
    )
    (defcap SWPM-ADMIN ()
        (enforce-one
            "SWPM Autostake Admin not satisfed"
            [
                (enforce-guard G-MD_SWPM)
                (enforce-guard G-SC_SWPM)
            ]
        )
    )

    (defconst G-MD_SWPM   (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_SWPM   (keyset-ref-guard SWP.SWP|SC_KEY))

    (defcap COMPOSE ()
        true
    )
    (defcap SECURE ()
        true
    )
    (defcap P|SWPM|CALLER ()
        true
    )
    ;;
    (defun A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (SWPM-ADMIN)
            (write PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun C_ReadPolicy:guard (policy-name:string)
        (at "policy" (read PoliciesTable policy-name ["policy"]))
    )
    (defun DefinePolicies ()
        (SWP.A_AddPolicy
            "SWPM|Caller"
            (create-capability-guard (P|SWPM|CALLER))
        )
    )
    (deftable PoliciesTable:{DALOS.PolicySchema})
    ;;
    (defun SWPM|C_ChangeOwnership (patron:string swpair:string new-owner:string)
        (with-capability (P|SWPM|CALLER)
            (SWP.SWP|X_ChangeOwnership swpair new-owner)
            (DALOS.IGNIS|C_Collect patron (SWP.SWP|UR_OwnerKonto swpair) (DALOS.DALOS|UR_UsagePrice "ignis|biggest"))
        )
    )
    (defun SWPM|C_ModifyCanChangeOwner (patron:string swpair:string new-boolean:bool)
        (with-capability (P|SWPM|CALLER)
            (SWP.SWP|X_ModifyCanChangeOwner swpair new-boolean)
            (DALOS.IGNIS|C_Collect patron (SWP.SWP|UR_OwnerKonto swpair) (DALOS.DALOS|UR_UsagePrice "ignis|biggest"))
        )
    )
    (defun SWPM|C_ToggleAddorSwap (patron:string swpair:string toggle:bool add-or-swap:bool)
        (with-capability (P|SWPM|CALLER)
            (SWP.SWP|X_CanAddOrSwapToggle swpair toggle add-or-swap)
            (DALOS.IGNIS|C_Collect patron (SWP.SWP|UR_OwnerKonto swpair) (DALOS.DALOS|UR_UsagePrice "ignis|medium"))
        )
    )
    (defun SWPM|C_ToggleFeeLock (patron:string swpair:string toggle:bool)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (P|SWPM|CALLER)
            (let*
                (
                    (swpair-owner:string (SWP.SWP|UR_OwnerKonto swpair))
                    (g1:decimal (DALOS.DALOS|UR_UsagePrice "ignis|small"))
                    (toggle-costs:[decimal] (SWP.SWP|X_ToggleFeeLock swpair toggle))
                    (g2:decimal (at 0 toggle-costs))
                    (gas-costs:decimal (+ g1 g2))
                    (kda-costs:decimal (at 1 toggle-costs))
                )
                (DALOS.IGNIS|C_Collect patron swpair-owner gas-costs)
                (if (> kda-costs 0.0)
                    (with-capability (COMPOSE)
                        (SWP.SWP|X_IncrementFeeUnlocks swpair)
                        (DALOS.KDA|C_Collect patron kda-costs)
                    )
                    true
                )
            )
        )
    )
    ;;
    
)

(create-table PoliciesTable)