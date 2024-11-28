(module LIQUID GOVERNANCE

    (defcap GOVERNANCE ()
        (compose-capability (LIQUID-ADMIN))
    )
    (defcap LIQUID-ADMIN ()
        (enforce-one
            "Vesting Admin not satisfed"
            [
                (enforce-guard DALOS.G_DALOS)
                (enforce-guard G_LIQUID)
            ]
        )
    )
    (defconst G_LIQUID   (keyset-ref-guard LIQUID|SC_KEY))

    (defconst LIQUID|SC_KEY "free.DH_SC_KadenaLiquidStaking-Keyset")
    (defconst LIQUID|SC_NAME DALOS.LIQUID|SC_NAME)
    (defconst LIQUID|SC_KDA-NAME (create-principal LIQUID|GUARD))

    (use free.UTILS)
    (use free.DALOS)
    (use free.BASIS)
    (use free.AUTOSTAKE)

    (defcap SUMMONER ()
        true
    )
    (defcap SECURE ()
        true
    )
    
    ;;Policies

    (defun A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (LIQUID-ADMIN)
            (write LQD|PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun C_ReadPolicy:guard (policy-name:string)
        @doc "Reads the guard of a stored policy"
        (at "policy" (read LQD|PoliciesTable policy-name ["policy"]))
    )

    (defun LIQUID|DefinePolicies ()
        @doc "Add the Policy that allows running external Functions from this Module"                
        (DALOS.A_AddPolicy
            "LIQUID|Summoner"
            (create-capability-guard (SUMMONER))
        )
        (BASIS.A_AddPolicy
            "LIQUID|Summoner"
            (create-capability-guard (SUMMONER))
        )
        (AUTOSTAKE.A_AddPolicy
            "LIQUID|Summoner"
            (create-capability-guard (SUMMONER))
        )
    )

    (defcap LIQUID|GOV ()
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
        true
    )
    (defconst LIQUID|GUARD (create-capability-guard (LIQUID|NATIVE-AUTOMATIC)))

    (defschema LQD|PolicySchema
        @doc "Schema that stores external policies, that are able to operate within this module"
        policy:guard
    )

    (deftable LQD|PoliciesTable:{LQD|PolicySchema})
    ;;
    ;;            LIQUID            Submodule
    ;;
    ;;[CAP]
    (defun LIQUID|CAP_IzLiquidStakingLive ()
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
    ;;[CF]
    (defcap LIQUID|CF|LIVE ()
        @doc "Capability that enforces Liquid Staking is live with an existing Autostake Pair"
        (LIQUID|CAP_IzLiquidStakingLive)
    )
    ;;[CAP]
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
    ;;[C]
    (defun LIQUID|CO_WrapKadena (patron:string wrapper:string amount:decimal)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (SECURE)
            (LIQUID|CP_WrapKadena patron wrapper amount)
        )
    )
    (defun LIQUID|CP_WrapKadena (patron:string wrapper:string amount:decimal)
        (require-capability (SECURE))
        (with-capability (LIQUID|WRAP)
            (let
                (
                    (kadena-patron:string (DALOS.DALOS|UR_AccountKadena wrapper))
                    (w-kda-id:string (DALOS.DALOS|UR_WrappedKadenaID))
                )
                (DALOS.DALOS|C_TransferDalosFuel kadena-patron LIQUID|SC_KDA-NAME amount)
                (BASIS.DPTF|CO_Mint patron w-kda-id LIQUID|SC_NAME amount false)
                (AUTOSTAKE.DPTF|CO_Transfer patron w-kda-id LIQUID|SC_NAME wrapper amount true)
            )
        )
    )
    (defun LIQUID|CO_UnwrapKadena (patron:string unwrapper:string amount:decimal)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
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
                (AUTOSTAKE.DPTF|CO_Transfer patron w-kda-id unwrapper LIQUID|SC_NAME amount true)
                (BASIS.DPTF|CO_Burn patron w-kda-id)
                (DALOS.DALOS|C_TransferDalosFuel LIQUID|SC_KDA-NAME kadena-patron amount)
            )
        )
    )
)
(create-table LQD|PoliciesTable)