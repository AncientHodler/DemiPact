;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module LIQUID GOV
    ;;
    (implements OuronetPolicy)
    (implements KadenaLiquidStakingV6)
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
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|LiquidKey ()         (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|LiquidKey)))
    (defun GOV|LIQUID|SC_NAME ()    (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|LIQUID|SC_NAME)))
    (defun GOV|LIQUID|SC_KDA-NAME () (create-principal (GOV|LIQUID|GUARD)))
    (defun GOV|LIQUID|GUARD ()      (create-capability-guard (LIQUID|NATIVE-AUTOMATIC)))
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
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::P|Info)))
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
                ;(ref-P|DPOF:module{OuronetPolicy} DPOF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|ATSU:module{OuronetPolicy} ATSU)
                (ref-P|VST:module{OuronetPolicy} VST)
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
                (ref-U|G:module{OuronetGuards} U|G)
            )
            (ref-U|G::UEV_Any (P|UR_IMP))
        )
    )
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    (defschema LIQUID|WrapperSchema
        replay:bool
        public:bool
    )
    ;;{2}
    (deftable LIQUID|Management:{LIQUID|WrapperSchema})
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
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
                (ref-DALOS:module{OuronetDalosV6} DALOS)
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
    (defcap SECURE-ADMIN ()
        (compose-capability (SECURE))
        (compose-capability (GOV|LIQUID_ADMIN))
    )
    (defcap LIQUID|C>ALLOW-WRAPPING ()
        (let
            (
                (iz-allowed:bool (UR_Public))
            )
            (enforce iz-allowed "Standard Wrapping is not enabled yet")
            (compose-capability (SECURE))
        )
    )
    (defcap LIQUID|C>ALLOW-MIGRATION ()
        (let
            (
                (iz-allowed:bool (UR_Replay))
            )
            (enforce iz-allowed "Migration Wrapping is not enabled yet")
            (compose-capability (SECURE))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_Replay:bool ()
        (at "replay" (read LIQUID|Management LIQUID|INFO ["replay"]))
    )
    (defun UR_Public:bool ()
        (at "public" (read LIQUID|Management LIQUID|INFO ["public"]))
    )
    ;;{F1}  [URC]
    ;(defun URC_WrapKadena:list (wrap-amount:decimal)
    ;    (let
    ;        (
    ;            (ref-DALOS:module{OuronetDalosV6} DALOS)
    ;            (receiver:string (ref-DALOS::UR_AccountKadena LIQUID|SC_NAME))
    ;        )
    ;        [receiver wrap-amount]
    ;    )
    ;)
    ;;{F2}  [UEV]
    (defun UEV_IzLiquidStakingLive ()
        @doc "Enforces Liquid Staking is live with an existing Autostake Pair"
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
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
    (defun UEV_Amount (amount:decimal)
        @doc "Enforces amount to coin (Kadena) Precision, which uses 12 decimal"
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
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
    (defun A_ManageWrapper (replay:bool public:bool)
        (UEV_IMC)
        (with-capability (GOV|LIQUID_ADMIN)
            (update LIQUID|Management LIQUID|INFO
                {"replay"   : replay
                ,"public"   : public}
            )
        )
    )
    (defun A_MigrateLiquidFunds:decimal (migration-target-kda-account:string)
        (UEV_IMC)
        (with-capability (GOV|MIGRATE migration-target-kda-account)
            (let
                (
                    (ref-coin:module{fungible-v2} coin)
                    (ref-DALOS:module{OuronetDalosV6} DALOS)
                    (lq-kda:string LIQUID|SC_KDA-NAME)
                    (present-kda-balance:decimal (ref-coin::get-balance lq-kda))
                )
                (install-capability (ref-coin::TRANSFER lq-kda migration-target-kda-account present-kda-balance))
                (ref-DALOS::C_TransferDalosFuel lq-kda migration-target-kda-account present-kda-balance)
                present-kda-balance
            )
        )
    )
    (defun A_WrapKadena:object{IgnisCollectorV2.OutputCumulator}
        (wrapper:string amount:decimal)
        (UEV_IMC)
        (with-capability (SECURE-ADMIN)
            (X_WrapKadena wrapper amount true)
        )
    )
    ;;{F6}  [C]
    (defun C_WrapKadenaForMigration:object{IgnisCollectorV2.OutputCumulator}
        (wrapper:string amount:decimal)
        (UEV_IMC)
        (with-capability (LIQUID|C>ALLOW-MIGRATION)
            (X_WrapKadena wrapper amount false)
        )
    )
    (defun C_WrapKadena:object{IgnisCollectorV2.OutputCumulator}
        (wrapper:string amount:decimal)
        (UEV_IMC)
        (with-capability (LIQUID|C>ALLOW-WRAPPING)
            (X_WrapKadena wrapper amount true)
        )
    )
    (defun C_UnwrapKadena:object{IgnisCollectorV2.OutputCumulator}
        (unwrapper:string amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-coin:module{fungible-v2} coin)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                (lq-sc:string LIQUID|SC_NAME)
                (lq-kda:string LIQUID|SC_KDA-NAME)
                (kadena-patron:string (ref-DALOS::UR_AccountKadena unwrapper))
                (w-kda-id:string (ref-DALOS::UR_WrappedKadenaID))
            )
            (with-capability (LIQUID|C>UNWRAP)
                (let
                    (
                        (output:object{IgnisCollectorV2.OutputCumulator}
                            (ref-IGNIS::UDC_ConcatenateOutputCumulators
                                [
                                    (ref-TFT::C_Transfer w-kda-id unwrapper lq-sc amount true)
                                    (ref-DPTF::C_Burn w-kda-id lq-sc amount)
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
    ;;{F7}  [X]
    (defun X_WrapKadena:object{IgnisCollectorV2.OutputCumulator}
        (wrapper:string amount:decimal full:bool)
        (require-capability (SECURE))
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                (lq-sc:string LIQUID|SC_NAME)
                (lq-kda:string LIQUID|SC_KDA-NAME)
                (kadena-patron:string (ref-DALOS::UR_AccountKadena wrapper))
                (w-kda-id:string (ref-DALOS::UR_WrappedKadenaID))
            )
            (with-capability (LIQUID|C>WRAP)
                (let
                    (
                        (ref-U|CT:module{OuronetConstants} U|CT)
                        (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                        (received-amount:decimal
                            (if full
                                amount
                                (floor (/ amount 10.0) kda-prec)
                            )
                        )
                        (output:object{IgnisCollectorV2.OutputCumulator}
                            (ref-IGNIS::UDC_ConcatenateOutputCumulators
                                [
                                    (ref-DPTF::C_Mint w-kda-id lq-sc received-amount false)
                                    (ref-TFT::C_Transfer w-kda-id lq-sc wrapper received-amount true)
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
)

(create-table P|T)
(create-table P|MT)
(create-table LIQUID|Management)