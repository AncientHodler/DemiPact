;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface KadenaLiquidStakingV3
    @doc "Exposes the two functions needed Liquid Staking Functions, Wrap and Unwrap KDA \
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
        \ \
        \ V3 Removes <patron> input variable where it is not needed"
    ;;
    (defun LIQUID|SetGovernor (patron:string))
    ;;
    ;;
    (defun GOV|LIQUID|SC_KDA-NAME ())
    (defun GOV|LIQUID|GUARD ())
    ;;
    ;;
    (defun UEV_IzLiquidStakingLive ())
    ;;
    ;;
    (defun A_MigrateLiquidFunds:decimal (migration-target-kda-account:string))
    ;;
    (defun C_UnwrapKadena:object{IgnisCollector.OutputCumulator} (unwrapper:string amount:decimal))
    (defun C_WrapKadena:object{IgnisCollector.OutputCumulator} (wrapper:string amount:decimal))
)
;;Interface v4 to add
;;(defun URC_WrapKadena:list (wrap-amount:decimal))
(module LIQUID GOV
    ;;
    (implements OuronetPolicy)
    (implements KadenaLiquidStakingV3)
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
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|LiquidKey ()         (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|LiquidKey)))
    (defun GOV|LIQUID|SC_NAME ()    (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|LIQUID|SC_NAME)))
    (defun GOV|LIQUID|SC_KDA-NAME () (create-principal (GOV|LIQUID|GUARD)))
    (defun GOV|LIQUID|GUARD ()      (create-capability-guard (LIQUID|NATIVE-AUTOMATIC)))
    (defun LIQUID|SetGovernor (patron:string)
        (with-capability (P|LQD|CALLER)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-DALOS::C_RotateGovernor
                            LIQUID|SC_NAME
                            (create-capability-guard (LIQUID|GOV))
                        )
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
            )
        )
    )
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|LQD|CALLER ()
        true
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::P|Info)))
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
                    (ref-U|LST:module{StringProcessor} U|LST)
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
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|ATSU:module{OuronetPolicy} ATSU)
                (ref-P|VST:module{OuronetPolicy} VST)
                (mg:guard (create-capability-guard (P|LQD|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|DPMF::P|A_AddIMP mg)
            (ref-P|ATS::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|ATSU::P|A_AddIMP mg)
            (ref-P|VST::P|A_AddIMP mg)
        )
    )
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
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
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
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
                (ref-DALOS:module{OuronetDalosV4} DALOS)
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
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun URC_WrapKadena:list (wrap-amount:decimal)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (receiver:string (ref-DALOS::UR_AccountKadena LIQUID|SC_NAME))
            )
            [receiver wrap-amount]
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_IzLiquidStakingLive ()
        @doc "Enforces Liquid Staking is live with an existing Autostake Pair"
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
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
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
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
    (defun C_UnwrapKadena:object{IgnisCollector.OutputCumulator}
        (unwrapper:string amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-coin:module{fungible-v2} coin)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                (lq-sc:string LIQUID|SC_NAME)
                (lq-kda:string LIQUID|SC_KDA-NAME)
                (kadena-patron:string (ref-DALOS::UR_AccountKadena unwrapper))
                (w-kda-id:string (ref-DALOS::UR_WrappedKadenaID))
            )
            (with-capability (LIQUID|C>UNWRAP)
                (let
                    (
                        (output:object{IgnisCollector.OutputCumulator}
                            (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                                [
                                    (ref-TFT::C_Transfer w-kda-id unwrapper lq-sc amount true)
                                    (ref-DPTF::C_Burn w-kda-id lq-sc amount)
                                ]
                                []
                            )
                            
                        )
                    )
                    (install-capability (ref-coin::TRANSFER lq-kda kadena-patron amount))
                    (ref-DALOS::C_TransferDalosFuel lq-kda kadena-patron amount)
                    output
                )
            )
        )
    )
    (defun C_WrapKadena:object{IgnisCollector.OutputCumulator}
        (wrapper:string amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                (lq-sc:string LIQUID|SC_NAME)
                (lq-kda:string LIQUID|SC_KDA-NAME)
                (kadena-patron:string (ref-DALOS::UR_AccountKadena wrapper))
                (w-kda-id:string (ref-DALOS::UR_WrappedKadenaID))
            )
            (with-capability (LIQUID|C>WRAP)
                (let
                    (
                        (output:object{IgnisCollector.OutputCumulator}
                            (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                                [
                                    (ref-DPTF::C_Mint w-kda-id lq-sc amount false)
                                    (ref-TFT::C_Transfer w-kda-id lq-sc wrapper amount true)
                                ]
                                []
                            )
                        )
                    )
                    (ref-DALOS::C_TransferDalosFuel kadena-patron lq-kda amount)
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