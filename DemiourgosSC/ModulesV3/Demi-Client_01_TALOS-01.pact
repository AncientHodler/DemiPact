;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module TALOS-01 GOV
    ;;  
    ;;{G1}
    (defconst G-MD_TALOS            (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst DALOS|SC_NAME         DALOS.DALOS|SC_NAME)
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|TALOS_ADMIN))
    )
    (defcap GOV|TALOS_ADMIN ()
        (enforce-guard G-MD_TALOS)
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    ;;{P3}
    ;;{P4}
    (defun P|A_Define ()
        (DALOS.P|A_Add
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (DPTF.P|A_Add
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (DPMF.P|A_Add
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (ATSI.P|A_Add
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (ATSM.P|A_Add
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (VESTING.P|A_Add
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (BRANDING.P|A_Add
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
    (defun DALOS|C_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        (with-capability (S)
            (DALOS.DALOS|C_DeployStandardAccount account guard kadena public)
            (LIQUIDFUEL.C_Fuel DALOS|SC_NAME)
        )
    )
    (defun DALOS|C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        (with-capability (S)
            (DALOS.DALOS|C_DeploySmartAccount account guard kadena sovereign public)
            (LIQUIDFUEL.C_Fuel DALOS|SC_NAME)
        )
    )
    (defun DPTF|C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
        (with-capability (S)
            (let
                (
                    (output:[string] (DPTF.DPTF|C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause))
                )
                (LIQUIDFUEL.C_Fuel DALOS|SC_NAME)
                output
            )
        )
    )
    (defun DPTF|C_ToggleFeeLock (patron:string id:string toggle:bool)
        (with-capability (S)
            (DPTF.DPTF|C_ToggleFeeLock patron id toggle)
            (LIQUIDFUEL.C_Fuel DALOS|SC_NAME)
        )
    )
    (defun DPTF|C_UpgradeBranding (patron:string id:string months:integer)
        (with-capability (S)
            (BRANDING.BRD|C_Upgrade patron id true months)
            (LIQUIDFUEL.C_Fuel DALOS|SC_NAME)
        )
    )
    (defun DPMF|C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        (with-capability (S)
            (let
                (
                    (output:[string] (DPMF.DPMF|C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role))
                )
                (LIQUIDFUEL.C_Fuel DALOS|SC_NAME)
                output
            )
        )
    )
    (defun DPMF|C_UpgradeBranding (patron:string id:string months:integer)
        (with-capability (S)
            (BRANDING.BRD|C_Upgrade patron id false months)
            (LIQUIDFUEL.C_Fuel DALOS|SC_NAME)
        )
    )
    (defun ATS|C_Issue:[string] (patron:string account:string atspair:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string] rbt-nfr:[bool])
        (with-capability (S)
            (let
                (
                    (output:[string] (ATSI.ATSI|C_Issue patron account atspair index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr))
                )
                (LIQUIDFUEL.C_Fuel DALOS|SC_NAME)
                output
            )
        )
    )
    (defun ATS|C_ToggleParameterLock (patron:string atspair:string toggle:bool)
        (with-capability (S)
            (ATSM.ATSM|C_ToggleParameterLock patron atspair toggle)
            (LIQUIDFUEL.C_Fuel DALOS|SC_NAME)
        )
    )
    (defun VST|C_CreateVestingLink:string (patron:string dptf:string)
        (with-capability (S)
            (let
                (
                    (output:string (VESTING.VST|C_CreateVestingLink patron dptf))
                )
                (LIQUIDFUEL.C_Fuel DALOS|SC_NAME)
                output
            )
        )
    )
    (defun VST|C_CoilAndVest:decimal (patron:string coiler-vester:string atspair:string coil-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        (let
            (
                (c-rbt:string (ATS.ATS|UR_ColdRewardBearingToken atspair))
                (c-rbt-amount:decimal (ATS.ATS|URC_RBT atspair coil-token amount))
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
                (c-rbt1-amount:decimal (ATS.ATS|URC_RBT atspair1 curl-token amount))
                (c-rbt2:string (ATS.ATS|UR_ColdRewardBearingToken atspair2))
                (c-rbt2-amount:decimal (ATS.ATS|URC_RBT atspair2 c-rbt1 c-rbt1-amount))
            )
            (ATSM.ATSM|C_Curl patron curler-vester atspair1 atspair2 curl-token amount)
            (VESTING.VST|C_Vest patron curler-vester target-account c-rbt2 c-rbt2-amount offset duration milestones)
            c-rbt2-amount
        )
    )
    ;;{16}
    ;;
)