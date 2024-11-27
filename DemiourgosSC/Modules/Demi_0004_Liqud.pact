(module LIQUID GOVERNANCE
    @doc "Demiourgos 0004 Module - LIQUD (Liquid Staking Module) \
    \ Module 4 contains the Liquid Staking Functionalith built on top of the complete DPTF and DPMF implementation, \
    \ as well as on top of the Autostake Implementation, which is why it is the next module in line \
    \ \
    \ \
    \ Smart DALOS Accounts governed by the Module (1) \
    \ \
    \ 1)Liquid Staking Smart Account"

    ;;Module Governance
    (defcap GOVERNANCE ()
        (compose-capability (LIQUID-ADMIN))
    )
    ;;Module Governance
    (defcap LIQUID-ADMIN ()
        (enforce-one
            "Vesting Admin not satisfed"
            [
                (enforce-guard DALOS.G_DALOS)
                (enforce-guard G_LIQUID)
            ]
        )
    )
    ;;Module Guard
    (defconst G_LIQUID   (keyset-ref-guard LIQUID|SC_KEY))
    ;;Module Accounts Information
        ;;[L] Liquidizer Account ids for LIQUID Submodule
    (defconst LIQUID|SC_KEY "free.DH_SC_KadenaLiquidStaking-Keyset")
    (defconst LIQUID|SC_NAME DALOS.LIQUID|SC_NAME)      ;;Former Liquidizer
    ;(defconst LIQUID|SC_KDA-NAME "k:a3506391811789fe88c4b8507069016eeb9946f3cb6d0b6214e700c343187c98")
    (defconst LIQUID|SC_KDA-NAME (create-principal LIQUID|GUARD))
    ;;External Module Usage
    (use free.UTILS)
    (use free.DALOS)
    (use free.BASIS)
    (use free.AUTOSTAKE)

    ;;
    ;;
    ;;


    ;;Simple True Capabilities - NONE
    (defcap SUMMONER ()
        @doc "Policy allowing usage of Client Functions from the DALOS, BASIS and AUTOSTAKE Modules"
        true
    )
    (defcap SECURE ()
        @doc "Capability that secures Client Functions in this Module"
        true
    )
    
    ;;Policies

    (defun LQD|A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (LIQUID-ADMIN)
            (write LQD|PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun LQD|C_ReadPolicy:guard (policy-name:string)
        @doc "Reads the guard of a stored policy"
        (at "policy" (read LQD|PoliciesTable policy-name ["policy"]))
    )

    (defun LIQUID|DefinePolicies ()
        @doc "Add the Policy that allows running external Functions from this Module"                
        (DALOS.DALOS|A_AddPolicy     ;DALOS
            "LIQUID|Summoner"
            (create-capability-guard (SUMMONER))                  ;;  Required to Summon DALOS Functions
        )
        (BASIS.BASIS|A_AddPolicy     ;BASIS
            "LIQUID|Summoner"
            (create-capability-guard (SUMMONER))                  ;;  Required to Summon DALOS Functions
        )
        (AUTOSTAKE.ATS|A_AddPolicy   ;AUTOSTAKE
            "LIQUID|Summoner"
            (create-capability-guard (SUMMONER))                  ;;  Required to Summon DALOS Functions
        )
    )

    ;;Module's Governor
    (defcap LIQUID|GOV ()
        @doc "Liquid-Stake Module Governor Capability for its Smart DALOS Account"
        true
    )
    (defun LIQUID|SetGovernor (patron:string)
        (with-capability (SUMMONER)
            (DALOS.DALOS|CO_RotateGovernor
                patron
                LIQUID|SC_NAME
                (create-capability-guard (LIQUID|GOV))
            )
        )
    )
    (defcap LIQUID|NATIVE-AUTOMATIC ()
        @doc "Capability needed for auto management of the <kadena-konto> \
        \ associated with the <Liquidizer> Smart DALOS Account"
        true
    )
    (defconst LIQUID|GUARD (create-capability-guard (LIQUID|NATIVE-AUTOMATIC)))
;;  1]CONSTANTS Definitions - NONE
;;  2]SCHEMAS Definitions
    ;;[L] LQD Schemas
    (defschema LQD|PolicySchema
        @doc "Schema that stores external policies, that are able to operate within this module"
        policy:guard
    )
;;  3]TABLES Definitions
    ;;[L] LQD Tables
    (deftable LQD|PoliciesTable:{LQD|PolicySchema})
    ;;
    ;;            LIQUID            Submodule
    ;;
    ;;            CAPABILITIES      <3>
    ;;            FUNCTIONS         [3]
    ;;========[D] RESTRICTIONS=================================================;;
    ;;        [1] Capabilities FUNCTIONS                [CAP]
    ;;        <1> Function Based CAPABILITIES           [CF](have this tag)
    ;;            Enforcements & Validations FUNCTIONS  [UEV]
    ;;        <2> Composed CAPABILITIES                 [CC](dont have this tag)
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;            Data Read FUNCTIONS                   [UR]
    ;;            Data Read and Computation FUNCTIONS   [URC] and [UC]
    ;;            Data Creation|Composition Functions   [UCC]
    ;;            Administrative Usage Functions        [A]
    ;;        [2] Client Usage FUNCTIONS                [C]
    ;;            Auxiliary Usage Functions             [X]
    ;;=========================================================================;;
    ;;
    ;;            START
    ;;
    ;;========[D] RESTRICTIONS=================================================;;
    ;;        [1] Capabilities FUNCTIONS                [CAP]
    (defun LIQUID|CAP_IzLiquidStakingLive ()
        @doc "Enforces Liquid Staking is set-up"
        (let
            (
                (w-kda:string (DALOS.DALOS|UR_WrappedKadenaID))
                (l-kda:string (DALOS.DALOS|UR_LiquidKadenaID))
            )
            (enforce (!= w-kda UTILS.BAR) "Wrapped-Kadena is not set")
            (enforce (!= l-kda UTILS.BAR) "Liquid-Kadena is not set")
            (let
                (
                    (w-kda-as-rt:[string] (BASIS.DPTF|UR_RewardToken w-kda))
                    (l-kda-as-rbt:[string] (BASIS.DPTF|UR_RewardBearingToken l-kda))
                )
                (enforce (= (length w-kda-as-rt) 1) "Wrapped-Kadena cannot ever be part of another ATS-Pair")
                (enforce (= (length l-kda-as-rbt) 1) "Liquid-Kadena cannot ever be part of another ATS-Pair")
                (enforce (= (at 0 w-kda-as-rt) (at 0 l-kda-as-rbt)) "Wrappedn and Liquid Kadena are not part of the same ASTS Pair")
            )
        )
    )
    ;;        <1> Function Based CAPABILITIES           [CF](have this tag)
    (defcap LIQUID|CF|LIVE ()
        @doc "Capability that enforces Liquid Staking is live with an existing Autostake Pair"
        (LIQUID|CAP_IzLiquidStakingLive)
    )
    ;;     (NONE) Enforcements & Validations FUNCTIONS  [UEV]
    ;;        <2> Composed CAPABILITIES                 [CC](dont have this tag)
    (defcap LIQUID|WRAP ()
        @doc "Capability needed to wrap KDA to DWK"
        @event
        (compose-capability (LIQUID|GOV))
        (compose-capability (SUMMONER))
        (compose-capability (LIQUID|CF|LIVE))
    )
    (defcap LIQUID|UNWRAP ()
        @doc "Capability needed to unwrap KDA to DWK"
        @event
        (compose-capability (LIQUID|GOV))
        (compose-capability (LIQUID|CF|LIVE))
        (compose-capability (LIQUID|NATIVE-AUTOMATIC))
    )
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;        [2] Client Usage FUNCTIONS                [C]
    (defun LIQUID|CO_WrapKadena (patron:string wrapper:string amount:decimal)
        (enforce-guard (LQD|C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (LIQUID|CP_WrapKadena patron wrapper amount)
        )
    )
    (defun LIQUID|CP_WrapKadena (patron:string wrapper:string amount:decimal)
        @doc "Client Function for wrapping native Kadena to DALOS Kadena"
        (require-capability (SECURE))
        (with-capability (LIQUID|WRAP)
            (let
                (
                    (kadena-patron:string (DALOS.DALOS|UR_AccountKadena wrapper))
                    (w-kda-id:string (DALOS.DALOS|UR_WrappedKadenaID))
                )
            ;;Wrapper transfers KDA to Liquid|SC_KDA-Name
                (DALOS.DALOS|C_TransferDalosFuel kadena-patron LIQUID|SC_KDA-NAME amount)
            ;;LIQUID|SC_NAME mints DWK
                (BASIS.DPTF|CO_Mint patron w-kda-id LIQUID|SC_NAME amount false)
            ;;LIQUID|SC_NAME transfers DWK to wrapper
                (AUTOSTAKE.DPTF|CO_Transfer patron w-kda-id LIQUID|SC_NAME wrapper amount true)
            )
        )
    )
    (defun LIQUID|CO_UnwrapKadena (patron:string unwrapper:string amount:decimal)
        (enforce-guard (LQD|C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (LIQUID|CP_UnwrapKadena patron unwrapper amount)
        )
    )
    (defun LIQUID|CP_UnwrapKadena (patron:string unwrapper:string amount:string)
        @doc "Client Function for wrapping native Kadena to DALOS Kadena"
        (require-capability (SECURE))
        (with-capability (LIQUID|UNWRAP)
            (let
                (
                    (kadena-patron:string (DALOS.DALOS|UR_AccountKadena unwrapper))
                    (w-kda-id:string (DALOS.DALOS|UR_WrappedKadenaID))
                )
            ;;Unwrapper transfers DWK to LIQUID|SC_NAME
                (AUTOSTAKE.DPTF|CO_Transfer patron w-kda-id unwrapper LIQUID|SC_NAME amount true)
            ;;LIQUID|SC_NAME burns DWK
                (BASIS.DPTF|CO_Burn patron w-kda-id)
            ;;LIQUID|SC_NAME transfers native KDA to wrapper
                (DALOS.DALOS|C_TransferDalosFuel LIQUID|SC_KDA-NAME kadena-patron amount)
            )
        )
    )
    ;;     (NONE) Auxiliary Usage Functions             [X]
)
;;Policies Table
(create-table LQD|PoliciesTable)