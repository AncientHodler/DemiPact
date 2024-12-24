;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module TALOS|DPMF2 GOVERNANCE
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
        (TFT.A_AddPolicy
            "TALOS|M|Summoner"
            (create-capability-guard (SUMMONER))
        )
        (BRANDING.A_AddPolicy
            "TALOS|M|Summoner"
            (create-capability-guard (SUMMONER))
        )
    )
    ;;
    (defun C_UpdateBranding (patron:string id:string logo:string description:string website:string social:[object{DALOS.SocialSchema}])
        @doc "Similar to <TALOS|DPTF.C_UpdateBranding>, but for DPMFs"
        (with-capability (S)
            (BRANDING.DPTF-DPMF|C_UpdateBranding patron id false logo description website social)
        )
    )
    (defun C_UpgradeBranding (patron:string id:string months:integer)
        @doc "Similar to <TALOS|DPTF.C_UpgradeBranding>, but for DPMFs"
        (with-capability (S)
            (BRANDING.BRD|C_UpgradeBranding patron id false months)
            (TALOS|OUROBOROS.C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    (defun C_SingleBatchTransfer (patron:string id:string nonce:integer sender:string receiver:string)
        @doc "Transfers a single Batch of DPMF Tokens from sender to receiver, using all of its balance"
        (with-capability (S)
            (TFT.DPMF|X_SingleBatchTransfer patron id nonce sender receiver false)
        )
    )
    (defun CM_SingleBatchTransfer (patron:string id:string nonce:integer sender:string receiver:string)
        @doc "Methodic Variant of <DPMF|C_SingleBatchTransfer>"
        (with-capability (S)
            (TFT.DPMF|X_SingleBatchTransfer patron id nonce sender receiver true)
        )
    )
    (defun C_MultiBatchTransfer (patron:string id:string nonces:[integer] sender:string receiver:string)
        @doc "Transfers a multiple DPMF Batches of Tokens from sender to receiver, using all of their balance"
        (with-capability (S)
            (TFT.DPMF|X_MultiBatchTransfer patron id nonces sender receiver false)
        )
    )
    (defun CM_MultiBatchTransfer (patron:string id:string nonces:[integer] sender:string receiver:string)
        @doc "Methodic Variant of <DPMF|C_MultiBatchTransfer>"
        (with-capability (S)
            (TFT.DPMF|X_MultiBatchTransfer patron id nonces sender receiver true)
        )
    )
)