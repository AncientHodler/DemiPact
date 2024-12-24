(module TALOS GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (TALOS-ADMIN))
    )
    (defcap TALOS-ADMIN ()
        (enforce-guard G-MD_TALOS)
    )
    (defconst G-MD_TALOS (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst DALOS|SC_NAME DALOS.DALOS|SC_NAME)

    ;;Policies
    (defcap S ()
        true
    )

    (defun DefinePolicies ()
        (DALOS.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (BASIS.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (ATSI.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (ATSM.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (VESTING.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (BRANDING.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
    )
    (defun DALOS|C_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        (with-capability (S)
            (DALOS.DALOS|C_DeployStandardAccount account guard kadena public)
            (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS.DALOS|SC_NAME)
        )
    )
    (defun DALOS|C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        (with-capability (S)
            (DALOS.DALOS|C_DeploySmartAccount account guard kadena sovereign public)
            (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    (defun DPTF|C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
        (with-capability (S)
            (let
                (
                    (output:[string] (BASIS.DPTF|C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause))
                )
                (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS.DALOS|SC_NAME)
                output
            )
        )
    )
    (defun DPTF|C_ToggleFeeLock (patron:string id:string toggle:bool)
        (with-capability (S)
            (BASIS.DPTF|C_ToggleFeeLock patron id toggle)
            (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    (defun DPTF|C_UpgradeBranding (patron:string id:string months:integer)
        (with-capability (S)
            (BRANDING.BRD|C_UpgradeBranding patron id true months)
            (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    (defun DPMF|C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        (with-capability (S)
            (let
                (
                    (output:[string] (BASIS.DPMF|C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role))
                )
                (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS.DALOS|SC_NAME)
                output
            )
        )
    )
    (defun DPMF|C_UpgradeBranding (patron:string id:string months:integer)
        (with-capability (S)
            (BRANDING.BRD|C_UpgradeBranding patron id false months)
            (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS.DALOS|SC_NAME)
        )
    )
    (defun ATS|C_Issue:[string] (patron:string account:string atspair:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string] rbt-nfr:[bool])
        (with-capability (S)
            (let
                (
                    (output:[string] (ATSI.ATSI|C_Issue patron account atspair index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr))
                )
                (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS.DALOS|SC_NAME)
                output
            )
        )
    )
    (defun ATS|C_ToggleParameterLock (patron:string atspair:string toggle:bool)
        (with-capability (S)
            (ATSM.ATSM|C_ToggleParameterLock patron atspair toggle)
            (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    (defun VST|C_CreateVestingLink:string (patron:string dptf:string)
        (with-capability (S)
            (let
                (
                    (output:string (VESTING.VST|C_CreateVestingLink patron dptf))
                )
                (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
                output
            )
        )
    )
    (defun VST|C_CoilAndVest:decimal (patron:string coiler-vester:string atspair:string coil-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        (let
            (
                (c-rbt:string (ATS.ATS|UR_ColdRewardBearingToken atspair))
                (c-rbt-amount:decimal (ATS.ATS|UC_RBT atspair coil-token amount))
            )
            (ATSM.ATSM|C_Coil patron coiler-vester atspair coil-token amount)
            (VESTING.VST|C_Vest patron coiler-vester target-account c-rbt c-rbt-amount offset duration milestones)
            c-rbt-amount
        )
    )
    (defun VST|C_CurlAndVest:decimal (patron:string curler-vester:string atspair1:string atspair2:string curl-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        (let*
            (
                (c-rbt1:string (ATS.ATS|UR_ColdRewardBearingToken atspair1))
                (c-rbt1-amount:decimal (ATS.ATS|UC_RBT atspair1 curl-token amount))
                (c-rbt2:string (ATS.ATS|UR_ColdRewardBearingToken atspair2))
                (c-rbt2-amount:decimal (ATS.ATS|UC_RBT atspair2 c-rbt1 c-rbt1-amount))
            )
            (ATSM.ATSM|C_Curl patron curler-vester atspair1 atspair2 curl-token amount)
            (VESTING.VST|C_Vest patron curler-vester target-account c-rbt2 c-rbt2-amount offset duration milestones)
            c-rbt2-amount
        )
    )
)