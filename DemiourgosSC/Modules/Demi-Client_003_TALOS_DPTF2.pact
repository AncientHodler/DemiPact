;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module TALOS|DPTF2 GOVERNANCE
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
            "TALOS|T|Summoner"
            (create-capability-guard (SUMMONER))
        )
        (BRANDING.A_AddPolicy
            "TALOS|T|Summoner"
            (create-capability-guard (SUMMONER))
        )
    )
    (defun C_UpdateBranding (patron:string id:string logo:string description:string website:string social:[object{DALOS.SocialSchema}])
        @doc "100 IGNIS Cost"
        (with-capability (S)
            (BRANDING.DPTF-DPMF|C_UpdateBranding patron id true logo description website social)
        )
    )
    (defun C_UpgradeBranding (patron:string id:string months:integer)
        @doc "Upgrades branding"
        (with-capability (S)
            (BRANDING.BRD|C_UpgradeBranding patron id true months)
            (TALOS|OUROBOROS.C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    
    (defun C_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal)
        @doc "Transfers a DPTF Token from <sender> to <receiver>"
        (with-capability (S)
            (TFT.DPTF|C_Transfer patron id sender receiver transfer-amount false)
        )
    )
    (defun CM_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal)
        @doc "Methodic"
        (with-capability (S)
            (TFT.DPTF|C_Transfer patron id sender receiver transfer-amount true)
        )
    )
    (defun C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal])
        @doc "Transfers multiple different DPTFs each with its own amount from a <sender> to a <receiver>"
        (with-capability (S)
            (TFT.DPTF|X_MultiTransfer patron id-lst sender receiver transfer-amount-lst false)
        )
    )
    (defun CM_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal])
        @doc "Methodic"
        (with-capability (S)
            (TFT.DPTF|X_MultiTransfer patron id-lst sender receiver transfer-amount-lst true)
        )
    )
    (defun C_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @doc "Transfers a single DPTF Token to multiple receivers, in bulk"
        (with-capability (S)
            (TFT.DPTF|X_BulkTransfer patron id sender receiver-lst transfer-amount-lst false)
        )
    )
    (defun CM_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @doc "Methodic"
        (with-capability (S)
            (TFT.DPTF|X_BulkTransfer patron id sender receiver-lst transfer-amount-lst true)
        )
    )
    (defun C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal)
        @doc "Transmutes a DPTF Token"
        (with-capability (S)
            (TFT.DPTF|C_Transmute patron id transmuter transmute-amount)
        )
    )
)