(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module TALOS|ATS4 GOVERNANCE
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
        (ATSM.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (SUMMONER))
        )
    )
    ;;
    (defun C_ChangeOwnership (patron:string atspair:string new-owner:string)
        @doc "Moves ATS <atspair> Ownership to <new-owner> DALOS Account"   
        (with-capability (S)
            (ATSM.ATSM|C_ChangeOwnership patron atspair new-owner)
        )
    )
    (defun C_ToggleParameterLock (patron:string atspair:string toggle:bool)
        @doc "Sets the <parameter-lock> for the ATS Pair <atspair> to <toggle> \
            \ Unlocking <parameter-toggle> (setting it to false) comes with specific restrictions: \
            \       As many unlocks can be executed for a ATS Pair as needed \
            \       The Cost for unlock is (1000 IGNIS + 10 KDA )*(0 + <unlocks>)"
        (with-capability (S)
            (ATSM.ATSM|C_ToggleParameterLock patron atspair toggle)
            (TALOS|OUROBOROS.C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    (defun C_UpdateSyphon (patron:string atspair:string syphon:decimal)
        @doc "Updates the Syphon Index. The Syphon Index represents the minimum ATS-Pair Index until syphoning is allowed"
        (with-capability (S)
            (ATSM.ATSM|C_UpdateSyphon patron atspair syphon)
        )
    )
    (defun C_ToggleSyphoning (patron:string atspair:string toggle:bool)
        @doc "Toggles syphoning, which allows or disallows syphoning mechanic for ATS-Pairs"
        (with-capability (S)
            (ATSM.ATSM|C_ToggleSyphoning patron atspair toggle)
        )
    )
    (defun C_SetCRD (patron:string atspair:string soft-or-hard:bool base:integer growth:integer)
        @doc "Sets the Cold Recovery Duration based on input parameters"
        (with-capability (S)
            (ATSM.ATSM|C_SetCRD patron atspair soft-or-hard base growth)
        )
    )
    (defun C_SetColdFee (patron:string atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        @doc "Sets Cold Recovery fee parameters"
        (with-capability (S)
            (ATSM.ATSM|C_SetColdFee patron atspair fee-positions fee-thresholds fee-array)
        )
    )
    (defun C_SetHotFee (patron:string atspair:string promile:decimal decay:integer)
        @doc "Sets Hot Recovery fee parameters"
        (with-capability (S)
            (ATSM.ATSM|C_SetHotFee patron atspair promile decay)
        )
    )
    (defun C_ToggleElite (patron:string atspair:string toggle:bool)
        @doc "Toggles <c-elite-mode> to <toggle>"
        (with-capability (S)
            (ATSM.ATSM|C_ToggleElite patron atspair toggle)
        )
    )
    (defun C_TurnRecoveryOn (patron:string atspair:string cold-or-hot:bool)
        @doc "Turns <cold-recovery> or <hot-recovery> on"
        (with-capability (S)
            (ATSM.ATSM|C_TurnRecoveryOn patron atspair cold-or-hot)
        )
    )
    (defun C_AddSecondary (patron:string atspair:string reward-token:string rt-nfr:bool)
        @doc "Add a secondary Reward Token for the ATS Pair <atspair>"
        (with-capability (S)
            (ATSM.ATSM|C_AddSecondary patron atspair reward-token rt-nfr)
        )
    )
    (defun C_AddHotRBT (patron:string atspair:string hot-rbt:string)
        @doc "Add a DPMF as <h-rbt> for the ATS Pair <atspair>"
        (with-capability (S)
            (ATSM.ATSM|C_AddHotRBT patron atspair hot-rbt)
        )
    )
    (defun C_Fuel (patron:string fueler:string atspair:string reward-token:string amount:decimal)
        @doc "Client Function for fueling an ATS Pair"
        (with-capability (S)
            (ATSM.ATSM|C_Fuel patron fueler atspair reward-token amount)
        )
    )
    (defun C_Coil:decimal (patron:string coiler:string atspair:string rt:string amount:decimal)
        @doc "Autostakes <rt> to the <atspair> ATS-Pair, receiving RBT"
        (with-capability (S)
            (ATSM.ATSM|C_Coil patron coiler atspair rt amount)
        )
    )
    (defun C_Curl:decimal (patron:string curler:string atspair1:string atspair2:string rt:string amount:decimal)
        @doc "Autostakes <rt> token twice using <atspair1> and <atspair2> \
            \ <rt> must be RBT in <atspair1> and RT in <atspair2> for this to work"
        (with-capability (S)
            (ATSM.ATSM|C_Curl patron curler atspair1 atspair2 rt amount)
        )
    )
    (defun C_KickStart (patron:string kickstarter:string atspair:string rt-amounts:[decimal] rbt-request-amount:decimal)
        @doc "Kickstarts <atspair> with a specific amount of Reward-Tokens, \
            \ while asking in retunr for a specific amount of Reward-Bearing-Tokens \
            \ thus efectively starting the <atspair> at a specific predefined Index"
        (with-capability (S)
            (ATSM.ATSM|C_KickStart patron kickstarter atspair rt-amounts rbt-request-amount)
        )
    )
    (defun C_Syphon (patron:string syphon-target:string atspair:string syphon-amounts:[decimal])
        @doc "Syphons Reward Tokens from <atspair> to <syphon-target>, reducing its Index \
            \ Syphons all RTs simultaneously, in their existing ratio."
        (with-capability (S)
            (ATSM.ATSM|C_Syphon patron syphon-target atspair syphon-amounts)
        )
    )
    (defun C_RemoveSecondary (patron:string remover:string atspair:string reward-token:string)
        @doc "Removes a secondary Reward-Toke from its ATS Pair \
            \ Secondary Reward Tokens are Reward-Tokens added after the ATS-Pair Creation, \
            \ therefor the Primal Reward Token, (the reward Token the ATS-Pair was created with), cannopt be removed."
        (with-capability (S)
            (ATSM.ATSM|C_RemoveSecondary patron remover atspair reward-token)
        )
    )
)