;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module TALOS-02 GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_TALOS          (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst DALOS|SC_NAME         DALOS.DALOS|SC_NAME)
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|TALOS_ADMIN))
    )
    (defcap GOV|TALOS_ADMIN ()
        (enforce-guard GOV|MD_TALOS)
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    ;;{P3}
    ;;{P4}
    (defun P|A_Define ()
        (SWPI.P|A_Add
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
    (defun SWP|C_IssueStandard:[string] (patron:string account:string pool-tokens:[object{SWP.SWP|PoolTokens}] fee-lp:decimal)
        (SWP|C_IssueStable patron account pool-tokens fee-lp -1.0)
    )
    (defun SWP|C_IssueWeighted:[string] (patron:string account:string pool-tokens:[object{SWP.SWP|PoolTokens}] fee-lp:decimal weights:[decimal])
        (with-capability (S)
            (let
                (
                    (output:[string] (SWPI.SWPI|C_Issue patron account pool-tokens fee-lp weights -1.0))
                )
                (LIQUIDFUEL.C_Fuel DALOS|SC_NAME)
                output
            )
        )
    )
    (defun SWP|C_IssueStable:[string] (patron:string account:string pool-tokens:[object{SWP.SWP|PoolTokens}] fee-lp:decimal amp:decimal)
        (with-capability (S)
            (let*
                (
                    (weights:[decimal] (make-list (length pool-tokens) 1.0))
                    (output:[string] (SWPI.SWPI|C_Issue patron account pool-tokens fee-lp weights amp))
                )
                (LIQUIDFUEL.C_Fuel DALOS|SC_NAME)
                output
            )
        )
    )
    ;;{16}
)