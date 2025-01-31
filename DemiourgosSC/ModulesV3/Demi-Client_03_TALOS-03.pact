;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module TALOS-03 GOV
    ;;  
    ;;{G1}
    (defconst G-MD_TALOS            (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst DALOS|SC_NAME         DALOS.DALOS|SC_NAME)
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|TALOS_ADMIN))
    )
    (defcap GOV|TALOS_ADMIN ()
        (enforce-guard G-MD_TALOS)
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    ;;{P3}
    ;;{P4}
    (defun P|A_Define ()
        (SWPM.P|A_Add
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
    (defcap S ()
        true
    )
    ;;{5}
    ;;{6}
    ;;{7}
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
    (defun SWP|C_ToggleFeeLock (patron:string swpair:string toggle:bool)
        (with-capability (S)
            (SWPM.SWPM|C_ToggleFeeLock patron swpair toggle)
            (LIQUIDFUEL.C_Fuel DALOS|SC_NAME)
        )
    )
    ;;{16}
)