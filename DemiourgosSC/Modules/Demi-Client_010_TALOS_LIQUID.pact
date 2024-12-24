;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module TALOS|LIQUID GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (TALOS-ADMIN))
    )
    (defcap TALOS-ADMIN ()
        (enforce-guard G-MD_TALOS)
    )
    (defconst G-MD_TALOS (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst DALOS|SC_NAME DALOS.DALOS|SC_NAME)
    (defcap SUMMONER ()
        true
    )
    (defcap P|DALOS|AUTO_PATRON ()
        true
    )
    (defcap S ()
        (compose-capability (SUMMONER))
        (compose-capability (P|DALOS|AUTO_PATRON))
    )
    (defun DefinePolicies ()
        (LIQUID.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (SUMMONER))
        )
    )
    ;;
    (defun C_WrapKadena (patron:string wrapper:string amount:decimal)
        @doc "Wraps native Kadena to DALOS Kadena"
        (with-capability (S)
            (LIQUID.LIQUID|C_WrapKadena patron wrapper amount)
        )
    )
    (defun C_UnwrapKadena (patron:string unwrapper:string amount:decimal)
        @doc "Unwraps DALOS Kadena to native Kadena"
        (with-capability (S)
            (LIQUID.LIQUID|C_UnwrapKadena patron unwrapper amount)
        )
    )
)