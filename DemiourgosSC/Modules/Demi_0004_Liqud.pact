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
        (compose-capability (LIQUD-ADMIN))
    )
    ;;Module Governance
    (defcap LIQUD-ADMIN ()
        (enforce-guard G_LIQUD)
    )
    ;;Module Guard
    (defconst G_LIQUD   (keyset-ref-guard LIQUD|DEMIURGOI))
    ;;Module Keys
    (defconst LIQUD|DEMIURGOI "free.DH_Master-Keyset")
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
    
    ;;Policies - NONE

    ;;Module's Governor
    (defcap LIQUID|GOV ()
        @doc "Liquid-Stake Module Governor Capability for its Smart DALOS Account"
        true
    )
    (defun LIQUID|SetGovernor (patron:string)
        (DALOS.DALOS|C_RotateGovernor
            patron
            LIQUID|SC_NAME
            (create-capability-guard (LIQUID|GOV))
        )
    )
    (defcap LIQUID|NATIVE-AUTOMATIC ()
        @doc "Capability needed for auto management of the <kadena-konto> \
        \ associated with the <Liquidizer> Smart DALOS Account"
        true
    )
    (defconst LIQUID|GUARD (create-capability-guard (LIQUID|NATIVE-AUTOMATIC)))


    ;;            BASIS             Submodule
    ;;
    ;;            CAPABILITIES      <48>
    ;;            FUNCTIONS         [158]
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
        (compose-capability (LIQUID|GOV))

        (compose-capability (LIQUID|CF|LIVE))
    )
    (defcap LIQUID|UNWRAP ()
        @doc "Capability needed to unwrap KDA to DWK"
        (compose-capability (LIQUID|GOV))

        (compose-capability (LIQUID|CF|LIVE))
        (compose-capability (LIQUID|NATIVE-AUTOMATIC))
    )
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;     (NONE) Data Read FUNCTIONS                   [UR]
    ;;     (NONE) Data Read and Computation FUNCTIONS   [URC] and [UC]
    ;;     (NONE) Data Creation|Composition Functions   [UCC]
    ;;     (NONE) Administrative Usage Functions        [A]
    ;;        [2] Client Usage FUNCTIONS                [C]
    (defun LIQUID|C_WrapKadena (patron:string wrapper:string amount:decimal)
        @doc "Client Function for wrapping native Kadena to DALOS Kadena"
        (with-capability (LIQUID|WRAP)
            (let
                (
                    (kadena-patron:string (DALOS.DALOS|UR_AccountKadena wrapper))
                    (w-kda-id:string (DALOS.DALOS|UR_WrappedKadenaID))
                )
            ;;Wrapper transfers KDA to Liquid|SC_KDA-Name
                (DALOS.DALOS|C_TransferDalosFuel kadena-patron LIQUID|SC_KDA-NAME amount)
            ;;LIQUID|SC_NAME mints DWK
                (BASIS.DPTF|C_Mint patron w-kda-id LIQUID|SC_NAME amount false)
            ;;LIQUID|SC_NAME transfers DWK to wrapper
                (AUTOSTAKE.DPTF|CM_Transfer patron w-kda-id LIQUID|SC_NAME wrapper amount)
            )
        )
    )
    (defun LIQUID|C_UnwrapKadena (patron:string unwrapper:string amount:string)
        @doc "Client Function for wrapping native Kadena to DALOS Kadena"
        (with-capability (LIQUID|UNWRAP)
            (let
                (
                    (kadena-patron:string (DALOS.DALOS|UR_AccountKadena unwrapper))
                    (w-kda-id:string (DALOS.DALOS|UR_WrappedKadenaID))
                )
            ;;Unwrapper transfers DWK to LIQUID|SC_NAME
                (AUTOSTAKE.DPTF|CM_Transfer patron w-kda-id unwrapper LIQUID|SC_NAME amount)
            ;;LIQUID|SC_NAME burns DWK
                (BASIS.DPTF|C_Burn patron w-kda-id)
            ;;LIQUID|SC_NAME transfers native KDA to wrapper
                (DALOS.DALOS|C_TransferDalosFuel LIQUID|SC_KDA-NAME kadena-patron amount)
            )
        )
    )
    ;;     (NONE) Auxiliary Usage Functions             [X]
)