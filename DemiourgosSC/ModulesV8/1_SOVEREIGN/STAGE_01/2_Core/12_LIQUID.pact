;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module LIQUID GOV
    ;;
    (implements OuronetPolicyV1)
    (implements StoaLiquidStakingV1)
    ;;
    ;;<========>
    ;;GOVERNANCE
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
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV1} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|LiquidKey ()         (let ((ref-DALOS:module{OuronetDalosV1} DALOS)) (ref-DALOS::GOV|LiquidKey)))
    (defun GOV|LIQUID|SC_NAME ()    (let ((ref-DALOS:module{OuronetDalosV1} DALOS)) (ref-DALOS::GOV|LIQUID|SC_NAME)))
    (defun GOV|LIQUID|SC_KDA-NAME () (create-principal (GOV|LIQUID|GUARD)))
    (defun GOV|LIQUID|GUARD ()      (create-capability-guard (LIQUID|NATIVE-AUTOMATIC)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicyV1.P|S})
    (deftable P|MT:{OuronetPolicyV1.P|MS})
    ;;{P3}
    (defcap P|LQD|CALLER ()
        true
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV1} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|LIQUID_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|LIQUID_ADMIN)
            (let
                (
                    (ref-U|LST:module{StringProcessorV1} U|LST)
                    (dg:guard (create-capability-guard (SECURE)))
                )
                (with-default-read P|MT P|I
                    {"m-policies" : [dg]}
                    {"m-policies" := mp}
                    (write P|MT P|I
                        {"m-policies" : (ref-U|LST::UC_AppL mp policy-guard)}
                    )
                )
            )
        )
    )
    (defun P|A_Define ()
        (let
            (
                (ref-P|DALOS:module{OuronetPolicyV1} DALOS)
                (ref-P|BRD:module{OuronetPolicyV1} BRD)
                (ref-P|DPTF:module{OuronetPolicyV1} DPTF)
                ;(ref-P|DPOF:module{OuronetPolicyV1} DPOF)
                (ref-P|ATS:module{OuronetPolicyV1} ATS)
                (ref-P|TFT:module{OuronetPolicyV1} TFT)
                (ref-P|ATSU:module{OuronetPolicyV1} ATSU)
                (ref-P|VST:module{OuronetPolicyV1} VST)
                (mg:guard (create-capability-guard (P|LQD|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            ;(ref-P|DPOF::P|A_AddIMP mg)
            (ref-P|ATS::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|ATSU::P|A_AddIMP mg)
            (ref-P|VST::P|A_AddIMP mg)
        )
    )
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuardsV1} U|G)
            )
            (ref-U|G::UEV_Any (P|UR_IMP))
        )
    )
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstantsV1} U|CT)) (ref-U|CT::CT_BAR)))
    (defun LIQUID|Info ()           (at 0 ["LiquidInformation"]))
    (defconst BAR                   (CT_Bar))
    (defconst LIQUID|INFO           (LIQUID|Info))
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap GOV|MIGRATE (migration-target-kda-account:string)
        @event
        (let
            (
                (ref-coin:module{fungible-v2} coin)
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (target-balance:decimal (ref-coin::get-balance migration-target-kda-account))
                (gap:bool (ref-DALOS::UR_GAP))
            )
            (enforce gap (format "Migration can only be executed when Global Administrative Pause is offline"))
            (enforce (= target-balance 0.0) "Migration can only be executed to an empty kda account")
            (compose-capability (GOV|LIQUID_ADMIN))
            (compose-capability (LIQUID|NATIVE-AUTOMATIC))
        )
    )
    (defcap LIQUID|C>WRAP ()
        @doc "Capability needed to wrap STOA to Ouronet Wrapped Stoa"
        @event
        (compose-capability (LIQUID|CONVERTER))
    )
    (defcap LIQUID|C>UNWRAP ()
        @doc "Capability needed to unwrap STOA to Ouronet Wrapped Stoa"
        @event
        (compose-capability (LIQUID|CONVERTER))
        (compose-capability (LIQUID|NATIVE-AUTOMATIC))
    )
    (defcap LIQUID|C>UR-WRAP ()
        @doc "Capability needed to wrap URSTOA to Ouronet Wrapped UrStoa"
        @event
        (compose-capability (LIQUID|CONVERTER))
    )
    (defcap LIQUID|C>UR-UNWRAP ()
        @doc "Capability needed to unwrap URSTOA to Ouronet Wrapped UrStoa"
        @event
        (compose-capability (LIQUID|CONVERTER))
        (compose-capability (LIQUID|NATIVE-AUTOMATIC))
    )
    (defcap LIQUID|CONVERTER ()
        (UEV_IzLiquidStakingLive)
        (compose-capability (LIQUID|CALLER))
    )
    (defcap LIQUID|CALLER ()
        (compose-capability (LIQUID|GOV))
        (compose-capability (P|LQD|CALLER))
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_IzOuronetAccountRegisteredForUrstoaHoldings:bool (ouronet-account:string)
        (let
            (
                (ref-ur-coin:module{stoa-ns.ur-stoic-fungible-v1} coinn)
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (kadena-patron:string (ref-DALOS::UR_AccountKadena ouronet-account))
                (trial (try false (ref-ur-coin::UR_UR|Details kadena-patron)))
            )
            (if (= (typeof trial) "bool") false true)
        )
    )
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_IzLiquidStakingLive ()
        @doc "Enforces Liquid Staking is live with an existing Autostake Pair"
        (let
            (
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (w-kda:string (ref-DALOS::UR_WrappedStoaID))
                (l-kda:string (ref-DALOS::UR_SilverStoaID))
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
    (defun UEV_Amount (amount:decimal)
        @doc "Enforces amount to coin (Kadena) Precision, which uses 12 decimal"
        (let
            (
                (ref-U|CT:module{OuronetConstantsV1} U|CT)
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
            )
            (enforce
                (= (floor amount kda-prec) amount)
                (format "{} is not conform with KDA prec." [amount])
            )
        )
    )
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun A_MigrateLiquidFunds:decimal (migration-target-kda-account:string)
        (UEV_IMC)
        (with-capability (GOV|MIGRATE migration-target-kda-account)
            (let
                (
                    (ref-coin:module{fungible-v2} coin)    
                    (ref-DALOS:module{OuronetDalosV1} DALOS)
                    (lq-kda:string LIQUID|SC_KDA-NAME)
                    (present-kda-balance:decimal (ref-coin::get-balance lq-kda))
                )
                (install-capability (ref-coin::TRANSFER lq-kda migration-target-kda-account present-kda-balance))
                (ref-DALOS::C_TransferDalosFuel lq-kda migration-target-kda-account present-kda-balance)
                present-kda-balance
            )
        )
    )
    ;;{F6}  [C]
    (defun C_UnwrapStoa:object{IgnisCollectorV1.OutputCumulator}
        (unwrapper:string amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-coin:module{fungible-v2} coin)
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (ref-TFT:module{TrueFungibleTransferV1} TFT)
                (lq-sc:string LIQUID|SC_NAME)
                (lq-kda:string LIQUID|SC_KDA-NAME)
                (kadena-patron:string (ref-DALOS::UR_AccountKadena unwrapper))
                (w-stoa-id:string (ref-DALOS::UR_WrappedStoaID))
            )
            (with-capability (LIQUID|C>UNWRAP)
                (let
                    (
                        (output:object{IgnisCollectorV1.OutputCumulator}
                            (ref-IGNIS::UDC_ConcatenateOutputCumulators
                                [
                                    (ref-TFT::C_Transfer w-stoa-id unwrapper lq-sc amount true)
                                    (ref-DPTF::C_Burn w-stoa-id lq-sc amount)
                                ]
                                []
                            )
                            
                        )
                    )
                    ;;(install-capability (ref-coin::TRANSFER lq-kda kadena-patron amount))
                    ;;Capability is added instead in the JavaCode
                    (ref-IGNIS::C_TransferDalosFuel lq-kda kadena-patron amount)
                    output
                )
            )
        )
    )
    (defun C_WrapStoa:object{IgnisCollectorV1.OutputCumulator}
        (wrapper:string amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (ref-TFT:module{TrueFungibleTransferV1} TFT)
                (lq-sc:string LIQUID|SC_NAME)
                (lq-kda:string LIQUID|SC_KDA-NAME)
                (kadena-patron:string (ref-DALOS::UR_AccountKadena wrapper))
                (w-kda-id:string (ref-DALOS::UR_WrappedStoaID))
            )
            (with-capability (LIQUID|C>WRAP)
                (let
                    (
                        (output:object{IgnisCollectorV1.OutputCumulator}
                            (ref-IGNIS::UDC_ConcatenateOutputCumulators
                                [
                                    (ref-DPTF::C_Mint w-kda-id lq-sc amount false)
                                    (ref-TFT::C_Transfer w-kda-id lq-sc wrapper amount true)
                                ]
                                []
                            )
                        )
                    )
                    (ref-IGNIS::C_TransferDalosFuel kadena-patron lq-kda amount)
                    output
                )
            )
        )
    )
    ;;
    (defun C_RegisterOuronetAccountForUrstoaHoldings
        (ouronet-account:string guard:guard)
        
        (UEV_IMC)
        (let
            (
                (ref-ur-coin:module{stoa-ns.ur-stoic-fungible-v1} coinn)
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (kadena-patron:string (ref-DALOS::UR_AccountKadena ouronet-account))
            )
            (ref-ur-coin::C_UR|CreateAccount kadena-patron guard)
        )
    )
    (defun C_UnwrapUrStoa:object{IgnisCollectorV1.OutputCumulator}
        (unwrapper:string amount:decimal)
        @doc "Unwrapper is the Ouronet Account doing the Unwrapping. \
            \ Its attached Kadena address k:xxx must be registered in the UrStoa Account Table for this to work \
            \ If its not registered there yet, its account must be created with \
            \ <C_RegisterOuronetAccountForUrstoaHoldings>"
        (UEV_IMC)
        (let
            (
                (ref-ur-coin:module{stoa-ns.ur-stoic-fungible-v1} coinn)
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (ref-TFT:module{TrueFungibleTransferV1} TFT)
                (lq-sc:string LIQUID|SC_NAME)
                (lq-kda:string LIQUID|SC_KDA-NAME)
                (kadena-patron:string (ref-DALOS::UR_AccountKadena unwrapper))
                (w-ur-stoa-id:string (ref-DALOS::UR_UrStoaID))
            )
            (with-capability (LIQUID|C>UR-UNWRAP)
                (let
                    (
                        (output:object{IgnisCollectorV1.OutputCumulator}
                            (ref-IGNIS::UDC_ConcatenateOutputCumulators
                                [
                                    (ref-TFT::C_Transfer w-ur-stoa-id unwrapper lq-sc amount true)
                                    (ref-DPTF::C_Burn w-ur-stoa-id lq-sc amount)
                                ]
                                []
                            )
                            
                        )
                    )
                    ;;(install-capability (ref-ur-coin::UR|TRANSFER lq-kda kadena-patron amount))
                    ;;Capability is added instead in the JavaCode - NOT NEEDED because TRANSMIT is used.
                    (ref-ur-coin::C_UR|Transmit lq-kda kadena-patron amount)
                    output
                )
            )
        )
    )
    (defun C_WrapUrStoa:object{IgnisCollectorV1.OutputCumulator}
        (wrapper:string amount:decimal)
        @doc "Wrapper is the Ouronet Account doing the Wrapping. \
            \ Its attached Kadena address k:xxx must be registered in the UrStoa Account Table for this to work \
            \ If its not registered there yet, its account must be created with \
            \ <C_RegisterOuronetAccountForUrstoaHoldings>"
        (UEV_IMC)
        (let
            (
                (ref-ur-coin:module{stoa-ns.ur-stoic-fungible-v1} coinn)
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (ref-TFT:module{TrueFungibleTransferV1} TFT)
                (lq-sc:string LIQUID|SC_NAME)
                (lq-kda:string LIQUID|SC_KDA-NAME)
                (kadena-patron:string (ref-DALOS::UR_AccountKadena wrapper))
                (w-ur-stoa-id:string (ref-DALOS::UR_UrStoaID))
            )
            (with-capability (LIQUID|C>UR-WRAP)
                (let
                    (
                        (output:object{IgnisCollectorV1.OutputCumulator}
                            (ref-IGNIS::UDC_ConcatenateOutputCumulators
                                [
                                    (ref-DPTF::C_Mint w-ur-stoa-id lq-sc amount false)
                                    (ref-TFT::C_Transfer w-ur-stoa-id lq-sc wrapper amount true)
                                ]
                                []
                            )
                        )
                    )
                    (ref-ur-coin::C_UR|Transmit kadena-patron lq-kda amount)
                    output
                )
            )
        )
    )
    
    ;;{F7}  [X]
    
    ;;
)

(create-table P|T)
(create-table P|MT)