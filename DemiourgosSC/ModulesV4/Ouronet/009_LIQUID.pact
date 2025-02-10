;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface KadenaLiquidStaking
    @doc "Exposes the two functions needed Liquid Staking Functions, Wrap and Unwrap KDA"
    ;;
    (defun GOV|LIQUID|SC_KDA-NAME ())
    (defun GOV|LIQUID|GUARD ())

    (defun UEV_IzLiquidStakingLive ())

    (defun C_UnwrapKadena (patron:string unwrapper:string amount:string))
    (defun C_WrapKadena (patron:string wrapper:string amount:decimal))
)
(module LIQUID GOV
    ;;
    (implements OuronetPolicy)
    (implements KadenaLiquidStaking)
    ;;{G1}
    (defconst GOV|MD_LIQUID         (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_LIQUID         (keyset-ref-guard LIQUID|SC_KEY))
    ;;
    (defconst LIQUID|SC_KEY         (GOV|LiquidKey))
    (defconst LIQUID|SC_NAME        (GOV|LIQUID|SC_NAME))
    (defconst LIQUID|SC_KDA-NAME    (GOV|LIQUID|SC_KDA-NAME))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|LIQUID_ADMIN)))
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
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|LiquidKey ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|LiquidKey)))
    (defun GOV|LIQUID|SC_NAME ()    (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|LIQUID|SC_NAME)))
    (defun GOV|LIQUID|SC_KDA-NAME () (create-principal (GOV|LIQUID|GUARD)))
    (defun GOV|LIQUID|GUARD ()      (create-capability-guard (LIQUID|NATIVE-AUTOMATIC)))
    (defun LIQUID|SetGovernor (patron:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|LQD|CALLER)
                (ref-DALOS::C_RotateGovernor
                    patron
                    LIQUID|SC_NAME
                    (create-capability-guard (LIQUID|GOV))
                )
            )
        )
    )
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    ;;{P3}
    (defcap P|LQD|CALLER ()
        true
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
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
        (let
            (
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|ATSU:module{OuronetPolicy} ATSU)
                (ref-P|VST:module{OuronetPolicy} VST)
            )
            (ref-P|DALOS::P|A_Add 
                "LIQUID|<"
                (create-capability-guard (P|LQD|CALLER))
            )
            (ref-P|BRD::P|A_Add 
                "LIQUID|<"
                (create-capability-guard (P|LQD|CALLER))
            )
            (ref-P|DPTF::P|A_Add 
                "LIQUID|<"
                (create-capability-guard (P|LQD|CALLER))
            )
            (ref-P|DPMF::P|A_Add 
                "LIQUID|<"
                (create-capability-guard (P|LQD|CALLER))
            )
            (ref-P|ATS::P|A_Add 
                "LIQUID|<"
                (create-capability-guard (P|LQD|CALLER))
            )
            (ref-P|TFT::P|A_Add 
                "LIQUID|<"
                (create-capability-guard (P|LQD|CALLER))
            )
            (ref-P|ATSU::P|A_Add 
                "LIQUID|<"
                (create-capability-guard (P|LQD|CALLER))
            )
            (ref-P|VST::P|A_Add 
                "LIQUID|<"
                (create-capability-guard (P|LQD|CALLER))
            )
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    ;;
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap LIQUID|C>WRAP ()
        @doc "Capability needed to wrap KDA to DWK"
        @event
        (UEV_IzLiquidStakingLive)
        (compose-capability (LIQUID|GOV))
        (compose-capability (P|LQD|CALLER))
    )
    (defcap LIQUID|C>UNWRAP ()
        @doc "Capability needed to unwrap KDA to DWK"
        @event
        (UEV_IzLiquidStakingLive)
        (compose-capability (LIQUID|GOV))
        (compose-capability (LIQUID|NATIVE-AUTOMATIC))
        (compose-capability (P|LQD|CALLER))
    )
    ;;
    ;;{F0}
    ;;{F1}
    ;;{F2}
    (defun UEV_IzLiquidStakingLive ()
        @doc "Enforces Liquid Staking is live with an existing Autostake Pair"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (w-kda:string (ref-DALOS::UR_WrappedKadenaID))
                (l-kda:string (ref-DALOS::UR_LiquidKadenaID))
            )
            (enforce (!= w-kda BAR) "Wrapped-Kadena is not set")
            (enforce (!= l-kda BAR) "Liquid-Kadena is not set")
            (let
                (
                    (w-kda-as-rt:[string] (ref-DPTF::UR_RewardToken w-kda))
                    (l-kda-as-rbt:[string] (ref-DPTF::UR_RewardBearingToken l-kda))
                )
                (enforce (= (length w-kda-as-rt) 1) "Wrapped-Kadena cannot ever be part of another ATS-Pair")
                (enforce (= (length l-kda-as-rbt) 1) "Liquid-Kadena cannot ever be part of another ATS-Pair")
                (enforce (= (at 0 w-kda-as-rt) (at 0 l-kda-as-rbt)) "Wrapped and Liquid Kadena are not part of the same ASTS Pair")
            )
        )
    )
    ;;{F3}
    ;;{F4}
    ;;
    ;;{F5}
    ;;{F6}
    (defun C_UnwrapKadena (patron:string unwrapper:string amount:string)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-TFT:module{TrueFungibleTransfer} TFT)
                (lq-sc:string LIQUID|SC_NAME)
                (lq-kda:string LIQUID|SC_KDA-NAME)
                (kadena-patron:string (ref-DALOS::UR_AccountKadena unwrapper))
                (w-kda-id:string (ref-DALOS::UR_WrappedKadenaID))
            )
            (with-capability (LIQUID|C>UNWRAP)
                (ref-TFT::C_Transfer patron w-kda-id unwrapper lq-sc amount true)
                (ref-DPTF::C_Burn patron w-kda-id lq-sc amount)
                ;(install-capability (coin.TRANSFER LIQUID|SC_KDA-NAME kadena-patron amount))
                (ref-DALOS::C_TransferDalosFuel lq-kda kadena-patron amount)
            )
        )
    )
    (defun C_WrapKadena (patron:string wrapper:string amount:decimal)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (P|UR "OUROBOROS|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-TFT:module{TrueFungibleTransfer} TFT)
                (lq-sc:string LIQUID|SC_NAME)
                (lq-kda:string LIQUID|SC_KDA-NAME)
                (kadena-patron:string (ref-DALOS::UR_AccountKadena wrapper))
                (w-kda-id:string (ref-DALOS::UR_WrappedKadenaID))
            )
            (with-capability (LIQUID|C>WRAP)
                (ref-DALOS::C_TransferDalosFuel kadena-patron lq-kda amount)
                (ref-DPTF::C_Mint patron w-kda-id lq-sc amount false)
                (ref-TFT::C_Transfer patron w-kda-id lq-sc wrapper amount true)
            )
        )
    )
    ;;{F7}
)

(create-table P|T)