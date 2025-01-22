;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module SWPS GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_SWPS           (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_SWPS           (keyset-ref-guard SWP.SWP|SC_KEY))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|SWPS_ADMIN))
    )
    (defcap GOV|SWPS_ADMIN ()
        (enforce-one
            "SWPS Swapper Admin not satisfed"
            [
                (enforce-guard GOV|MD_SWPS)
                (enforce-guard GOV|SC_SWPS)
            ]
        )
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    (defcap P|SWPS|CALLER ()
        true
    )
    (defcap P|SWPS|REMOTE-GOV ()
        true
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|SWPS_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        true
        (SWP.P|A_Add
            "SWPS|Caller"
            (create-capability-guard (P|SWPS|CALLER))
        )
        (SWP.P|A_Add
            "SWPS|RemoteSwapGovernor"
            (create-capability-guard (P|SWPS|REMOTE-GOV))
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
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
    ;;{16}
)

(create-table P|T)