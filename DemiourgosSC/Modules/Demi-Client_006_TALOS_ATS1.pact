;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module TALOS|ATS1 GOVERNANCE
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
        (ATSI.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (SUMMONER))
        )
        (ATSH.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (SUMMONER))
        )
    )
    ;;
    (defun C_ToggleFeeSettings (patron:string atspair:string toggle:bool fee-switch:integer)
        @doc "Toggles ATS Boolean Fee Parameters to <toggle> : \
            \ fee-switch = 0 : cold-native-fee-redirection (c-nfr) \
            \ fee-switch = 1 : cold-fee-redirection (c-fr) \ 
            \ fee-switch = 2 : hot-fee-redirection (h-fr)"
        (with-capability (S)
            (ATSI.ATSI|C_ToggleFeeSettings patron atspair toggle fee-switch)
        )
    )
    (defun C_TurnRecoveryOff (patron:string atspair:string cold-or-hot:bool)
        @doc "Turns <cold-recovery> or <hot-recovery> off"
        (with-capability (S)
            (ATSI.ATSI|C_TurnRecoveryOff patron atspair cold-or-hot)
        )
    )
    (defun C_Issue:string (patron:string account:string atspair:string index-decimals:integer reward-token:string rt-nfr:bool reward-bearing-token:string rbt-nfr:bool)
        @doc "Issue a new ATS-Pair"
        (with-capability (S)
            (ATSI.ATSI|C_Issue patron account atspair index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr)
        )
    )
    (defun C_HotRecovery (patron:string recoverer:string atspair:string ra:decimal)
        @doc "Executes Hot Recovery for <ats-pair> by <recoverer> with the <ra> amount of Cold-Reward-Bearing-Token"
        (with-capability (S)
            (ATSH.ATSH|C_HotRecovery patron recoverer atspair ra)
        )
    )
    (defun C_Redeem (patron:string redeemer:string id:string nonce:integer)
        @doc "Redeems a Hot RBT; \
            \ Redeeming instantly returns RTs, in amounts determined by the <h-promile> and <h-decay> values."
        (with-capability (S)
            (ATSH.ATSH|C_Redeem patron redeemer id nonce)
        )
    )
    (defun C_RecoverWholeRBTBatch (patron:string recoverer:string id:string nonce:integer)
        @doc "Converts a whole batch of Hot-RBT back to its Cold-RBT Counterpart"                    
        (with-capability (S)
            (ATSH.ATSH|C_RecoverWholeRBTBatch patron recoverer id nonce)
        )
    )
    (defun C_RecoverPartialRBTBatch (patron:string recoverer:string id:string nonce:integer amount)
        @doc "Partially converts a batch of Hot-RBT back to its Cold-RBT Counterpart"                    
        (with-capability (S)
            (ATSH.ATSH|C_RecoverHotRBT patron recoverer id nonce amount)
        )
    )
)