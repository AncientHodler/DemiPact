;(namespace n_e096dec549c18b706547e425df9ac0571ebd00b0)
(module TALOS|VST GOVERNANCE
    ;(use n_e096dec549c18b706547e425df9ac0571ebd00b0.ATSM)
    ;(use n_e096dec549c18b706547e425df9ac0571ebd00b0.VESTING)
    (use ATSM)
    (use VESTING)

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
        (VESTING.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (SUMMONER))
        )
    )
    ;;        [5] Client Usage FUNCTIONS
    ;;
    (defun C_CreateVestingLink:string (patron:string dptf:string)
        @doc "Creates an immutable Vesting Pair between the input DPTF Token and a DPMF Token that will be created by this function \
            \ Incurrs the necessary costs for issuing a DPMF Token"
        (with-capability (S)
            (let
                (
                    (output:string (VESTING.VST|C_CreateVestingLink patron dptf))
                )
                (TALOS|OUROBOROS.C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
                output
            )
        )
    )
    (defun C_Vest (patron:string vester:string target-account:string id:string amount:decimal offset:integer duration:integer milestones:integer)
        @doc "Vests <id> given input parameters to its DPMF Vesting Counterpart to <target-account>"
        (with-capability (S)
            (VESTING.VST|C_Vest patron vester target-account id amount offset duration milestones)
        )
    )
    (defun C_CoilAndVest:decimal (patron:string coiler-vester:string atspair:string coil-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        @doc "Autostakes <coil-token> and outputs its vested counterpart, to the <target-account> \
            \ Fails if the c-rbt doesnt have an active vesting counterpart"
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
    (defun C_CurlAndVest:decimal (patron:string curler-vester:string atspair1:string atspair2:string curl-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        @doc "Autostakes <curl-token> twice and outputs its vested counterpart when it exists, to the <target-account> \
            \ Fails if the c-rbt of <atspair2> doesnt have an active vesting counterpart"
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
    (defun C_Cull (patron:string culler:string id:string nonce:integer)
        @doc "Culls a DPMF representing a Vested Token \
        \ Culling returns to culler any amounts that can be released by the Vesting Schedule as DPTF Tokens"
        (with-capability (S)
            (VESTING.VST|C_Cull patron culler id nonce)
        )
    )
)