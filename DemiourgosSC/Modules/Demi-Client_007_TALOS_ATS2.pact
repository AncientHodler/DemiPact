;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module TALOS|ATS2 GOVERNANCE
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
        (ATSC.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (SUMMONER))
        )
    )
    ;;
    (defun C_ColdRecovery (patron:string recoverer:string atspair:string ra:decimal)
        @doc "Executes Cold Recovery for <ats-pair> by <recoverer> with the <ra> amount of Cold-Reward-Bearing-Token"
        (with-capability (S)
            (ATSC.ATSC|C_ColdRecovery patron recoverer atspair ra)
        )
    )
    (defun C_Cull:[decimal] (patron:string culler:string atspair:string)
        @doc "Culls <atspair> for <culler>. Culling returns all elapsed past Cold-Recoveries executed by <culler> \
            \ Returns culled values. If no cullable values exists, returns a list of zeros, since nothing has been culled"
        (with-capability (S)
            (ATSC.ATSC|C_Cull patron culler atspair)
        )
    )
)