;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module LIQUID GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_LIQUID         (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_LIQUID         (keyset-ref-guard LIQUID|SC_KEY))

    (defconst LIQUID|SC_KEY         (+ UTILS.NS_USE ".dh_sc_kadenaliquidstaking-keyset"))
    (defconst LIQUID|SC_NAME        DALOS.LIQUID|SC_NAME)
    (defconst LIQUID|SC_KDA-NAME    (create-principal LIQUID|GUARD))
    (defconst LIQUID|GUARD          (create-capability-guard (LIQUID|NATIVE-AUTOMATIC)))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|LIQUID_ADMIN))
    )
    (defcap GOV|LIQUID_ADMIN ()
        (enforce-one
            "LIQUID Admin not satisfed"
            [
                (enforce-guard GOV|MD_LIQUID)
                (enforce-guard GOV|SC_LIQUID)
            ]
        )
    )
    (defcap LIQUID|GOV ()
        @doc "Governor Capability for the Liquid Smart DALOS Account"
        true
    )
    (defcap LIQUID|NATIVE-AUTOMATIC ()
        @doc "Autonomic management of <kadena-konto> of LIQUID Smart Account"
        true
    )
    ;;{G3}
    (defun LIQUID|SetGovernor (patron:string)
        (DALOS.DALOS|C_RotateGovernor
            patron
            LIQUID|SC_NAME
            (create-capability-guard (LIQUID|GOV))
        )
    )
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        @doc "Reads the guard of a stored policy"
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|LIQUID_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()              
        true
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
    ;;{5}
    ;;{6}
    (defcap LIQUID|F>LIVE ()
        @doc "Capability that enforces Liquid Staking is live with an existing Autostake Pair"
        (LIQUID|CAP_IzLiquidStakingLive)
    )
    ;;{7}
    (defcap LIQUID|C>WRAP ()
        @doc "Capability needed to wrap KDA to DWK"
        @event
        (compose-capability (LIQUID|GOV))
        (compose-capability (LIQUID|F>LIVE))
    )
    (defcap LIQUID|C>UNWRAP ()
        @doc "Capability needed to unwrap KDA to DWK"
        @event
        (compose-capability (LIQUID|GOV))
        (compose-capability (LIQUID|F>LIVE))
        (compose-capability (LIQUID|NATIVE-AUTOMATIC))
    )
    ;;
    ;;{8}
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
                    (w-kda-as-rt:[string] (DPTF.DPTF|UR_RewardToken w-kda))
                    (l-kda-as-rbt:[string] (DPTF.DPTF|UR_RewardBearingToken l-kda))
                )
                (enforce (= (length w-kda-as-rt) 1) "Wrapped-Kadena cannot ever be part of another ATS-Pair")
                (enforce (= (length l-kda-as-rbt) 1) "Liquid-Kadena cannot ever be part of another ATS-Pair")
                (enforce (= (at 0 w-kda-as-rt) (at 0 l-kda-as-rbt)) "Wrappedn and Liquid Kadena are not part of the same ASTS Pair")
            )
        )
    )
    ;;{9}
    ;;{10}
    ;;{11}
    ;;{12}
    ;;{13}
    ;;
    ;;{14}
    ;;{15}
    (defun LIQUID|C_WrapKadena (patron:string wrapper:string amount:decimal)
        (with-capability (LIQUID|C>WRAP)
            (let
                (
                    (kadena-patron:string (DALOS.DALOS|UR_AccountKadena wrapper))
                    (w-kda-id:string (DALOS.DALOS|UR_WrappedKadenaID))
                )
                (DALOS.DALOS|C_TransferDalosFuel kadena-patron LIQUID|SC_KDA-NAME amount)
                (DPTF.DPTF|C_Mint patron w-kda-id LIQUID|SC_NAME amount false)
                (TFT.DPTF|C_Transfer patron w-kda-id LIQUID|SC_NAME wrapper amount true)
            )
        )
    )
    (defun LIQUID|C_UnwrapKadena (patron:string unwrapper:string amount:string)
        (with-capability (LIQUID|C>UNWRAP)
            (let
                (
                    (kadena-patron:string (DALOS.DALOS|UR_AccountKadena unwrapper))
                    (w-kda-id:string (DALOS.DALOS|UR_WrappedKadenaID))
                )
                (TFT.DPTF|C_Transfer patron w-kda-id unwrapper LIQUID|SC_NAME amount true)
                (DPTF.DPTF|C_Burn patron w-kda-id)
                (DALOS.DALOS|C_TransferDalosFuel LIQUID|SC_KDA-NAME kadena-patron amount)
            )
        )
    )
    ;;{16}
)

(create-table P|T)