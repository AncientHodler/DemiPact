;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module LIQUIDFUEL GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (LIQUIDFUEL-ADMIN))
    )
    (defcap LIQUIDFUEL-ADMIN ()
        (enforce-one
            "OUROBOROS Admin not satisfed"
            [
                (enforce-guard G-MD_LIQUIDFUEL)
                (enforce-guard G-SC_LIQUIDFUEL)
            ]
        )
    )

    (defconst G-MD_LIQUIDFUEL (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_LIQUIDFUEL (keyset-ref-guard OUROBOROS|SC_KEY))

    (defconst OUROBOROS|SC_KEY
        (+ UTILS.NS_USE ".dh_sc_ouroboros-keyset")
    )
    (defconst OUROBOROS|SC_NAME DALOS.OUROBOROS|SC_NAME)
    (defconst OUROBOROS|SC_KDA-NAME (create-principal OUROBOROS|GUARD))

    (defcap COMPOSE ()
        true
    )
    (defcap SUMMONER ()
        true
    )
    ;;
    (defun DefinePolicies ()
        true
    )
    ;;
    (defcap OUROBOROS|GOV ()
        @doc "Ouroboros Module Governor Capability for its Smart DALOS Account"
        true
    )
    (defun OUROBOROS|SetGovernor (patron:string)
        (DALOS.DALOS|C_RotateGovernor
            patron
            OUROBOROS|SC_NAME
            (UTILS.GUARD|UEV_Any
                [
                    (create-capability-guard (OUROBOROS|GOV))
                    (C_ReadPolicy "OUROBOROS|RemoteGovernor")
                ]
            )
        )
    )
    (defcap OUROBOROS|NATIVE-AUTOMATIC ()
        @doc "Capability needed for auto management of the <kadena-konto> associated with the Ouroboros Smart DALOS Account"
        true
    )
    (defconst OUROBOROS|GUARD (create-capability-guard (OUROBOROS|NATIVE-AUTOMATIC)))
    ;;P
    (defun A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (LIQUIDFUEL-ADMIN)
            (write PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun C_ReadPolicy:guard (policy-name:string)
        (at "policy" (read PoliciesTable policy-name ["policy"]))
    )
    (deftable PoliciesTable:{DALOS.PolicySchema})
    ;;
    ;;[CAP]
    (defcap LIQUIDFUEL|ADMIN_FUEL ()
        @event
        (compose-capability (OUROBOROS|GOV))
        (compose-capability (OUROBOROS|NATIVE-AUTOMATIC))
    )
    ;;[C]
    (defun C_Fuel (patron:string)
        (with-capability (LIQUIDFUEL|ADMIN_FUEL)
            (let
                (
                    (present-kda-balance:decimal (at "balance" (coin.details (DALOS.DALOS|UR_AccountKadena OUROBOROS|SC_NAME))))
                    (w-kda:string (DALOS.DALOS|UR_WrappedKadenaID))
                )
                (if (!= w-kda UTILS.BAR)
                    (let*
                        (
                            (w-kda-as-rt:[string] (BASIS.DPTF|UR_RewardToken w-kda))
                            (liquid-idx:string (at 0 w-kda-as-rt))
                        )
                        (if (> present-kda-balance 0.0)
                            (with-capability (COMPOSE)
                                (LIQUID.LIQUID|C_WrapKadena patron OUROBOROS|SC_NAME present-kda-balance)
                                (ATSF.ATSF|C_Fuel patron OUROBOROS|SC_NAME liquid-idx w-kda present-kda-balance)
                            )
                            true
                        )
                    )
                    true
                )
            )
        )
    )
)

(create-table PoliciesTable)