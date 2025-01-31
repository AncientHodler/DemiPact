;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module LIQUIDFUEL GOV
    (use coin)
    ;;  
    ;;{G1}
    (defconst GOV|MD_LIQUIDFUEL     (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_LIQUIDFUEL     (keyset-ref-guard OUROBOROS|SC_KEY))

    (defconst OUROBOROS|SC_KEY      (+ UTILS.NS_USE ".dh_sc_ouroboros-keyset"))
    (defconst OUROBOROS|SC_NAME     DALOS.OUROBOROS|SC_NAME)
    (defconst OUROBOROS|SC_KDA-NAME (create-principal OUROBOROS|GUARD))
    (defconst OUROBOROS|GUARD       (create-capability-guard (OUROBOROS|NATIVE-AUTOMATIC)))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|LIQUIDFUEL_ADMIN))
    )
    (defcap GOV|LIQUIDFUEL_ADMIN ()
        (enforce-one
            "OUROBOROS Admin not satisfed"
            [
                (enforce-guard GOV|MD_LIQUIDFUEL)
                (enforce-guard GOV|SC_LIQUIDFUEL)
            ]
        )
    )
    (defcap OUROBOROS|GOV ()
        @doc "Governor Capability for the Ouroboros Smart DALOS Account"
        true
    )
    (defcap OUROBOROS|NATIVE-AUTOMATIC ()
        @doc "Autonomic management of <kadena-konto> of OUROBOROS Smart Account"
        true
    )
    ;;{G3}
    (defun OUROBOROS|SetGovernor (patron:string)
        (DALOS.DALOS|C_RotateGovernor
            patron
            OUROBOROS|SC_NAME
            (UTILS.GUARD|UEV_Any
                [
                    (create-capability-guard (OUROBOROS|GOV))
                    (P|UR "OUROBOROS|RemoteGovernor")
                ]
            )
        )
    )
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|LIQUIDFUEL_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        true
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
    (defcap COMPOSE ()
        true
    )
    ;;{5}
    ;;{6}
    ;;{7}
    (defcap LIQUIDFUEL|C>ADMIN_FUEL ()
        @event
        (compose-capability (OUROBOROS|GOV))
        (compose-capability (OUROBOROS|NATIVE-AUTOMATIC))
    )
    ;;
    ;;{8}
    ;;{9}
    ;;{10}
    ;;{11}
    ;;{12}
    ;;{13}
    ;;
    ;;{14}
    ;;{15}
    (defun C_Fuel (patron:string)
        (with-capability (LIQUIDFUEL|C>ADMIN_FUEL)
            (let
                (
                    (present-kda-balance:decimal (at "balance" (coin.details (DALOS.DALOS|UR_AccountKadena OUROBOROS|SC_NAME))))
                    (w-kda:string (DALOS.DALOS|UR_WrappedKadenaID))
                )
                (if (!= w-kda UTILS.BAR)
                    (let*
                        (
                            (w-kda-as-rt:[string] (DPTF.DPTF|UR_RewardToken w-kda))
                            (liquid-idx:string (at 0 w-kda-as-rt))
                        )
                        (if (> present-kda-balance 0.0)
                            (with-capability (COMPOSE)
                                (install-capability (coin.TRANSFER OUROBOROS|SC_KDA-NAME LIQUID.LIQUID|SC_KDA-NAME present-kda-balance))
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
    ;;{16}
)

(create-table P|T)