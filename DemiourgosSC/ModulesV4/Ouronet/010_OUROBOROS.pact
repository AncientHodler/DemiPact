;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface Ouroboros
    @doc "Exposes Functions related to the OUROBOROS Module"
    ;;
    (defun GOV|ORBR|SC_KDA-NAME ())
    (defun GOV|ORBR|GUARD ())
    ;;
    (defun URC_ProjectedKdaLiquindex:[decimal] ())
    (defun URC_Compress:[decimal] (ignis-amount:decimal))
    (defun URC_Sublimate:decimal (ouro-amount:decimal))
    ;;
    (defun UEV_AccountsAsStandard (accounts:[string]))
    (defun UEV_Exchange ())
    ;;
    (defun C_Compress:object{OuronetDalos.IgnisCumulator} (patron:string client:string ignis-amount:decimal))
    (defun C_Fuel:[object{OuronetDalos.IgnisCumulator}] (patron:string))
    (defun C_Sublimate:object{OuronetDalos.IgnisCumulator} (patron:string client:string target:string ouro-amount:decimal))
    (defun C_WithdrawFees:object{OuronetDalos.IgnisCumulator} (patron:string id:string target:string))
)
(interface OuroborosV2
    @doc "Exposes Functions related to the OUROBOROS Module \
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts"
    ;;
    (defun OUROBOROS|SetGovernor (patron:string))
    ;;
    ;;
    (defun GOV|ORBR|SC_KDA-NAME ())
    (defun GOV|ORBR|GUARD ())
    ;;
    ;;
    (defun URC_ProjectedKdaLiquindex:[decimal] ())
    (defun URC_Compress:[decimal] (ignis-amount:decimal))
    (defun URC_Sublimate:decimal (ouro-amount:decimal))
    ;;
    (defun UEV_AccountsAsStandard (accounts:[string]))
    (defun UEV_Exchange ())
    ;;
    ;;
    (defun C_Compress:object{OuronetDalosV2.OutputCumulatorV2} (patron:string client:string ignis-amount:decimal))
    (defun C_Fuel:object{OuronetDalosV2.OutputCumulatorV2} (patron:string))
    (defun C_Sublimate:object{OuronetDalosV2.OutputCumulatorV2} (patron:string client:string target:string ouro-amount:decimal))
    (defun C_WithdrawFees:object{OuronetDalosV2.OutputCumulatorV2} (patron:string id:string target:string))
)
(interface OuroborosV3
    @doc "Exposes Functions related to the OUROBOROS Module \
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
        \ \
        \ V3 Removes <patron> input variable where it is not needed and removes <UEV_AccountsAsStandard>"
    ;;
    (defun OUROBOROS|SetGovernor (patron:string))
    ;;
    ;;
    (defun GOV|ORBR|SC_KDA-NAME ())
    (defun GOV|ORBR|GUARD ())
    ;;
    ;;
    (defun URC_ProjectedKdaLiquindex:[decimal] ())
    (defun URC_Compress:[decimal] (ignis-amount:decimal))
    (defun URC_Sublimate:decimal (ouro-amount:decimal))
    ;;
    (defun UEV_Exchange ())
    ;;
    ;;
    (defun C_Compress:object{OuronetDalosV3.OutputCumulatorV2} (client:string ignis-amount:decimal))
    (defun C_Fuel:object{OuronetDalosV3.OutputCumulatorV2} ())
    (defun C_Sublimate:object{OuronetDalosV3.OutputCumulatorV2} (client:string target:string ouro-amount:decimal))
    (defun C_WithdrawFees:object{OuronetDalosV3.OutputCumulatorV2} (id:string target:string))
)
(module OUROBOROS GOV
    ;;
    (implements OuronetPolicy)
    (implements OuroborosV3)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_ORBR           (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_ORBR           (keyset-ref-guard ORBR|SC_KEY))
    ;;
    (defconst ORBR|SC_KEY           (GOV|OuroborosKey))
    (defconst ORBR|SC_NAME          (GOV|ORBR|SC_NAME))
    (defconst ORBR|SC_KDA-NAME      (GOV|ORBR|SC_KDA-NAME))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|ORBR_ADMIN)))
    (defcap GOV|ORBR_ADMIN ()
        (enforce-one
            "ORBR Admin not satisfed"
            [
                (enforce-guard GOV|MD_ORBR)
                (enforce-guard GOV|SC_ORBR)
            ]
        )
    )
    (defcap ORBR|GOV ()
        @doc "Governor Capability for the Ouroboros Smart DALOS Account"
        true
    )
    (defcap ORBR|NATIVE-AUTOMATIC ()
        @doc "Autonomic management of <kadena-konto> of OUROBOROS Smart Account"
        true
    )
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|OuroborosKey ()      (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::GOV|OuroborosKey)))
    (defun GOV|ORBR|SC_NAME ()      (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::GOV|OUROBOROS|SC_NAME)))
    (defun GOV|ORBR|SC_KDA-NAME ()  (create-principal (GOV|ORBR|GUARD)))
    (defun GOV|ORBR|GUARD ()        (create-capability-guard (ORBR|NATIVE-AUTOMATIC)))
    (defun OUROBOROS|SetGovernor (patron:string)
        (with-capability (P|ORBR|CALLER)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ico:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-DALOS::C_RotateGovernor
                            ORBR|SC_NAME
                            (create-capability-guard (ORBR|GOV))
                        )
                    )
                )
                (ref-DALOS::IGNIS|C_Collect patron ico)
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
    (defcap P|ORBR|CALLER ()
        true
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|ORBR_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|ORBR_ADMIN)
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
                (ref-P|LIQUID:module{OuronetPolicy} LIQUID)
                (mg:guard (create-capability-guard (P|ORBR|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|DPMF::P|A_AddIMP mg)
            (ref-P|ATS::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|ATSU::P|A_AddIMP mg)
            (ref-P|VST::P|A_AddIMP mg)
            (ref-P|LIQUID::P|A_AddIMP mg)
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
    (defun CT_EmptyCumulator        ()(let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::DALOS|EmptyOutputCumulatorV2)))
    (defconst BAR                   (CT_Bar))
    (defconst EOC                   (CT_EmptyCumulator))
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
    (defcap LIQUIDFUEL|C>ADMIN_FUEL ()
        @event
        (compose-capability (ORBR|GOV))
        (compose-capability (ORBR|NATIVE-AUTOMATIC))
        (compose-capability (P|ORBR|CALLER))
    )
    (defcap IGNIS|C>SUBLIMATE (client:string target:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
            )
            (ref-DALOS::UEV_EnforceAccountType target false)
            (compose-capability (IGNIS|C>CONVERT client))
        )
    )
    (defcap IGNIS|C>COMPRESS (client:string)
        @event
        (compose-capability (IGNIS|C>CONVERT client))
    )
    (defcap IGNIS|C>CONVERT(client:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
            )
            (ref-DALOS::UEV_EnforceAccountType client false)
            (UEV_Exchange)
            (compose-capability (ORBR|GOV))
            (compose-capability (P|ORBR|CALLER))
        )
    )
    (defcap OUROBOROS|C>WITHDRAW (id:string target:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
            )
            (ref-DALOS::UEV_EnforceAccountType target false)
            (ref-DPTF::CAP_Owner id)
            (compose-capability (ORBR|GOV))
            (compose-capability (P|ORBR|CALLER))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun URC_ProjectedKdaLiquindex:[decimal] ()
        @doc "Computes the Projected KDA Liquindex, considering KDA amount in reserves ready to be used as Fuel"
        (let
            (
                (ref-coin:module{fungible-v2} coin)
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-ATS:module{AutostakeV3} ATS)
                (orb-sc ORBR|SC_NAME)
                (present-kda-balance:decimal (ref-coin::get-balance (ref-DALOS::UR_AccountKadena orb-sc)))
                (w-kda:string (ref-DALOS::UR_WrappedKadenaID))
                (w-kda-as-rt:[string] (ref-DPTF::UR_RewardToken w-kda))
                (liquid-idx:string (at 0 w-kda-as-rt))
                (present-index-value:decimal (ref-ATS::URC_Index liquid-idx))

                (p:integer (ref-ATS::UR_IndexDecimals liquid-idx))
                (rs:decimal (ref-ATS::URC_ResidentSum liquid-idx))
                (projected-sum:decimal (+ rs present-kda-balance))
                (rbt-supply:decimal (ref-ATS::URC_PairRBTSupply liquid-idx))
                (projected-index-value:decimal
                    (if
                        (= rbt-supply 0.0)
                        -1.0
                        (floor (/ projected-sum rbt-supply) p)
                    )
                )
            )
            [present-index-value projected-index-value present-kda-balance]
        )
    )
    (defun URC_Compress:[decimal] (ignis-amount:decimal)
        (let
            (
                (ref-U|ATS:module{UtilityAts} U|ATS)
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
            )
            (enforce (= (floor ignis-amount 0) ignis-amount) "Only whole Units of GAS(Ignis) can be compressed")
            (enforce (>= ignis-amount 1.00) "Only amounts greater than or equal to 1.0 can be used to compress gas")
            (ref-DPTF::UEV_Amount (ref-DALOS::UR_IgnisID) ignis-amount)
            (let
                (
                    (ouro-id:string (ref-DALOS::UR_OuroborosID))
                    (ouro-price:decimal (ref-DALOS::UR_OuroborosPrice))
                    (ouro-price-used:decimal (if (<= ouro-price 1.00) 1.00 ouro-price))
                    (ouro-precision:integer (ref-DPTF::UR_Decimals ouro-id))
                    (raw-ouro-amount:decimal (floor (/ ignis-amount (* ouro-price-used 100.0)) ouro-precision))
                    (promile-split:[decimal] (ref-U|ATS::UC_PromilleSplit 15.0 raw-ouro-amount ouro-precision))
                    (ouro-remainder-amount:decimal (floor (at 0 promile-split) ouro-precision))
                    (ouro-fee-amount:decimal (at 1 promile-split))
                )
                [ouro-remainder-amount ouro-fee-amount]
            )
        )
    )
    (defun URC_Sublimate:decimal (ouro-amount:decimal)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
            )
            (enforce (>= ouro-amount 0.99) "Only amounts greater than or equal to 1.0 (1% conversion fee included) can be used to make gas!")
            (ref-DPTF::UEV_Amount (ref-DALOS::UR_OuroborosID) ouro-amount)
            (let
                (
                    (ouro-price:decimal (ref-DALOS::UR_OuroborosPrice))
                    (ouro-price-used:decimal (if (<= ouro-price 1.00) 1.00 ouro-price))
                    (ignis-id:string (ref-DALOS::UR_IgnisID))
                )
                (enforce (!= ignis-id BAR) "Gas Token isnt properly set")
                (let
                    (
                        (ignis-precision:integer (ref-DPTF::UR_Decimals ignis-id))
                        (raw-ignis-amount-per-unit:decimal (floor (* ouro-price-used 100.0) ignis-precision))
                        (raw-ignis-amount:decimal (floor (* raw-ignis-amount-per-unit ouro-amount) ignis-precision))
                        (output-ignis-amount:decimal (floor raw-ignis-amount 0))
                    )
                    output-ignis-amount
                )
            )
        )

    )
    ;;{F2}  [UEV]
    (defun UEV_Exchange ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (orb-sc ORBR|SC_NAME)

                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                (gas-id:string (ref-DALOS::UR_IgnisID))
                (o-rm:bool (ref-DPTF::UR_AccountRoleMint ouro-id orb-sc))
                (o-rb:bool (ref-DPTF::UR_AccountRoleBurn ouro-id orb-sc))
                (t1:bool (and o-rm o-rb))
                (g-rm:bool (ref-DPTF::UR_AccountRoleMint gas-id orb-sc))
                (g-rb:bool (ref-DPTF::UR_AccountRoleBurn gas-id orb-sc))
                (t2:bool (and g-rm g-rb))
                (t3:bool (and t1 t2))
            )
            ;;Checks Ouroboros and Ignis are properly set up
            (enforce (!= ouro-id BAR) "Ouroboros is not set")
            (enforce (!= gas-id BAR) "Ignis is not set")
            ;;Checks Exchange Permission
            (enforce t3 "Permission invalid for Ignis Exchange")
        )
    )
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_Compress:object{OuronetDalosV3.OutputCumulatorV2}
        (client:string ignis-amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                (orbr-sc:string ORBR|SC_NAME)
                ;;
                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                (ignis-id:string (ref-DALOS::UR_IgnisID))
                (ignis-to-ouro:[decimal] (URC_Compress ignis-amount))
                (ouro-remainder-amount:decimal (at 0 ignis-to-ouro))
                (total-ouro:decimal (fold (+) 0.0 ignis-to-ouro))
            )
            (with-capability (IGNIS|C>COMPRESS client)
                (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2
                    [
                        ;;01]Client sends GAS(Ignis) <ignis-amount> to the Ouroboros Smart Ouronet Account
                        (ref-TFT::C_Transfer ignis-id client orbr-sc ignis-amount true)
                        ;;02]Ouroboros burns GAS(Ignis) <ignis-amount>
                        (ref-DPTF::C_Burn ignis-id orbr-sc ignis-amount)
                        ;;03]Ouroboros mints OURO <ouro-remainder-amount>
                        (ref-DPTF::C_Mint ouro-id orbr-sc ouro-remainder-amount false)
                        ;;04]Ouroboros transfers OURO <ouro-remainder-amount> to <client>
                        (ref-TFT::C_Transfer ouro-id orbr-sc client ouro-remainder-amount true)
                    ]
                    [ouro-remainder-amount]
                )
            )
        )
    )
    (defun C_Fuel:object{OuronetDalosV3.OutputCumulatorV2} ()
        (UEV_IMC)
        (let
            (
                (ref-coin:module{fungible-v2} coin)
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-ATSU:module{AutostakeUsageV3} ATSU)
                (ref-LIQUID:module{KadenaLiquidStakingV3} LIQUID)
                (orb-sc ORBR|SC_NAME)
                (orb-kda ORBR|SC_KDA-NAME)
                (lq-kda (ref-LIQUID::GOV|LIQUID|SC_KDA-NAME))
                (present-kda-balance:decimal (ref-coin::get-balance (ref-DALOS::UR_AccountKadena orb-sc)))
                (w-kda:string (ref-DALOS::UR_WrappedKadenaID))
            )
            (if (!= w-kda BAR)
                (let
                    (
                        (w-kda-as-rt:[string] (ref-DPTF::UR_RewardToken w-kda))
                        (liquid-idx:string (at 0 w-kda-as-rt))
                    )
                    (if (> present-kda-balance 0.0)
                        (with-capability (LIQUIDFUEL|C>ADMIN_FUEL)
                            (install-capability (ref-coin::TRANSFER orb-kda lq-kda present-kda-balance))
                            (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2
                                [
                                    (ref-LIQUID::C_WrapKadena orb-sc present-kda-balance)
                                    (ref-ATSU::C_Fuel orb-sc liquid-idx w-kda present-kda-balance)
                                ]
                                []
                            )
                        )
                        EOC
                    )
                )
                EOC
            )
        )
    )
    (defun C_Sublimate:object{OuronetDalosV3.OutputCumulatorV2}
        (client:string target:string ouro-amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-U|ATS:module{UtilityAts} U|ATS)
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                (orbr-sc:string ORBR|SC_NAME)
                ;;
                (ignis-id:string (ref-DALOS::UR_IgnisID))
                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                (ouro-precision:integer (ref-DPTF::UR_Decimals ouro-id))
                ;;
                (ouro-split:[decimal] (ref-U|ATS::UC_PromilleSplit 10.0 ouro-amount ouro-precision))
                (ouro-remainder-amount:decimal (at 0 ouro-split))
                (ignis-amount:decimal (URC_Sublimate ouro-remainder-amount))
            )
            (with-capability (IGNIS|C>SUBLIMATE client target)
                (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2
                    [
                        ;;01]Client sends OURO <ouro-amount> to the Ouroboros Smart Ouronet Account
                        (ref-TFT::C_Transfer ouro-id client orbr-sc ouro-amount true)
                        ;;02]Ouroboros burns OURO <ouro-amount>
                        (ref-DPTF::C_Burn ouro-id orbr-sc ouro-amount)
                        ;;03]Ouroboros mints GAS(Ignis) <ignis-amount>
                        (ref-DPTF::C_Mint ignis-id orbr-sc ignis-amount false)
                        ;;04]Ouroboros transfers GAS(Ignis) <ignis-amount> to <target>
                        (ref-TFT::C_Transfer ignis-id orbr-sc target ignis-amount true)
                    ]
                    [ignis-amount]
                )
            )
        )
    )
    (defun C_WithdrawFees:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string target:string)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                (orbr-sc:string ORBR|SC_NAME)
                (withdraw-amount:decimal (ref-DPTF::UR_AccountSupply id orbr-sc))
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
            )
            (enforce (> withdraw-amount 0.0) (format "There are no {} fees to be withdrawn from {}" [id orbr-sc]))
            (with-capability (OUROBOROS|C>WITHDRAW id target)
                (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2
                    [
                        ;;00]Compose base withdraw IGNIS Price
                        (ref-DALOS::UDC_ConstructOutputCumulatorV2 price orbr-sc trigger [])
                        ;;01]Patron withdraws Fees from Ouroboros Smart DALOS Account to a target Normal Ouronet Account
                        (ref-TFT::C_Transfer id orbr-sc target withdraw-amount true)
                    ]
                    []
                )
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)
