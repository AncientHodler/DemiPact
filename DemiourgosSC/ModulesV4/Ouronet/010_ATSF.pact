;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module ATSF GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_ATSF           (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_ATSF           (keyset-ref-guard ATS.ATS|SC_KEY))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|ATSF_ADMIN))
    )
    (defcap GOV|ATSF_ADMIN ()
        (enforce-one
            "ATSF Autostake Admin not satisfed"
            [
                (enforce-guard GOV|MD_ATSF)
                (enforce-guard GOV|SC_ATSF)
            ]
        )
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    (defcap P|ATSF|REMOTE-GOV ()
        true
    )
    (defcap P|ATSF|UPDATE_ROU ()
        true
    )
    ;;{P4}
    (defun C_ReadPolicy:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|ATSF_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        (ATS.P|A_Add
            "ATSF|UpdateROU"
            (create-capability-guard (P|ATSF|UPDATE_ROU))
        )
        (ATS.P|A_Add
            "ATSF|RemoteAtsGov"
            (create-capability-guard (P|ATSF|REMOTE-GOV))
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
    (defcap ATSF|C>FUEL (atspair:string reward-token:string)
        @event
        (ATS.ATS|UEV_RewardTokenExistance atspair reward-token true)
        (compose-capability (P|ATSF|REMOTE-GOV))
        (compose-capability (P|ATSF|UPDATE_ROU))
        (let
            (
                (index:decimal (ATS.ATS|URC_Index atspair))
            )
            (enforce (>= index 0.1) "Fueling cannot take place on a negative Index")
        )
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
    (defun ATSF|C_Fuel (patron:string fueler:string atspair:string reward-token:string amount:decimal)
        (with-capability (ATSF|C>FUEL atspair reward-token)
            (TFT.DPTF|C_Transfer patron reward-token fueler ATS.ATS|SC_NAME amount true)
            (ATS.ATS|X_UpdateRoU atspair reward-token true true amount)
        )
    )
    ;;{16}
)

(create-table P|T)