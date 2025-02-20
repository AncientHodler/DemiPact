;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface Ouroboros
    @doc "Exposes Functions related to the OUROBOROS Module"
    ;;
    (defun GOV|ORBR|SC_KDA-NAME ())
    (defun GOV|ORBR|GUARD ())
    ;;
    (defun URC_Compress:[decimal] (ignis-amount:decimal))
    (defun URC_Sublimate:decimal (ouro-amount:decimal))
    ;;
    (defun UEV_AccountsAsStandard (accounts:[string]))
    (defun UEV_Exchange ())
    ;;
    (defun C_Compress:object{OuronetDalos.IgnisCumulator} (patron:string client:string ignis-amount:decimal))
    (defun C_Fuel:object{OuronetDalos.IgnisCumulator} (patron:string))
    (defun C_Sublimate:object{OuronetDalos.IgnisCumulator} (patron:string client:string target:string ouro-amount:decimal))
    (defun C_WithdrawFees:object{OuronetDalos.IgnisCumulator} (patron:string id:string target:string))
)
(module OUROBOROS GOV
    ;;
    (implements OuronetPolicy)
    (implements Ouroboros)
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
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|OuroborosKey ()      (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|OuroborosKey)))
    (defun GOV|ORBR|SC_NAME ()      (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|OUROBOROS|SC_NAME)))
    (defun GOV|ORBR|SC_KDA-NAME ()  (create-principal (GOV|ORBR|GUARD)))
    (defun GOV|ORBR|GUARD ()        (create-capability-guard (ORBR|NATIVE-AUTOMATIC)))
    (defun OUROBOROS|SetGovernor (patron:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|ORBR|CALLER)
                (ref-DALOS::C_RotateGovernor
                    patron
                    ORBR|SC_NAME
                    (create-capability-guard (ORBR|GOV))
                )
            )
        )
    )
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    ;;{P3}
    (defcap P|ORBR|CALLER ()
        true
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|ORBR_ADMIN)
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
                (ref-P|LIQUID:module{OuronetPolicy} LIQUID)
            )
            (ref-P|DALOS::P|A_Add 
                "OUROBOROS|<"
                (create-capability-guard (P|ORBR|CALLER))
            )
            (ref-P|BRD::P|A_Add 
                "OUROBOROS|<"
                (create-capability-guard (P|ORBR|CALLER))
            )
            (ref-P|DPTF::P|A_Add 
                "OUROBOROS|<"
                (create-capability-guard (P|ORBR|CALLER))
            )
            (ref-P|DPMF::P|A_Add 
                "OUROBOROS|<"
                (create-capability-guard (P|ORBR|CALLER))
            )
            (ref-P|ATS::P|A_Add 
                "OUROBOROS|<"
                (create-capability-guard (P|ORBR|CALLER))
            )
            (ref-P|TFT::P|A_Add 
                "OUROBOROS|<"
                (create-capability-guard (P|ORBR|CALLER))
            )
            (ref-P|ATSU::P|A_Add 
                "OUROBOROS|<"
                (create-capability-guard (P|ORBR|CALLER))
            )
            (ref-P|VST::P|A_Add 
                "OUROBOROS|<"
                (create-capability-guard (P|ORBR|CALLER))
            )
            (ref-P|LIQUID::P|A_Add 
                "OUROBOROS|<"
                (create-capability-guard (P|ORBR|CALLER))
            )
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defun CT_EmptyIgnisCumulator ()(let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::DALOS|EmptyIgCum)))
    (defconst BAR                   (CT_Bar))
    (defconst EIC                   (CT_EmptyIgnisCumulator))
    ;;
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
    (defcap IGNIS|C>SUBLIMATE (patron:string client:string target:string)
        @event
        (UEV_AccountsAsStandard [patron client target])
        (UEV_Exchange)
        (compose-capability (ORBR|GOV))
        (compose-capability (P|ORBR|CALLER))
    )
    (defcap IGNIS|C>COMPRESS (patron:string client:string)
        @event
        (UEV_AccountsAsStandard [patron client])
        (UEV_Exchange)
        (compose-capability (ORBR|GOV))
        (compose-capability (P|ORBR|CALLER))
    )
    (defcap OUROBOROS|C>WITHDRAW (patron:string id:string target:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DALOS::UEV_EnforceAccountType target false)
            (ref-DPTF::CAP_Owner id)
            (compose-capability (ORBR|GOV))
            (compose-capability (P|ORBR|CALLER))
        )
    )
    ;;
    ;;{F0}
    ;;{F1}
    (defun URC_Compress:[decimal] (ignis-amount:decimal)
        (let
            (
                (ref-U|ATS:module{UtilityAts} U|ATS)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (enforce (= (floor ignis-amount 0) ignis-amount) "Only whole Units of GAS(Ignis) can be compressed")
            (enforce (>= ignis-amount 1.00) "Only amounts greater than or equal to 1.0 can be used to compress gas")
            (ref-DPTF::UEV_Amount (ref-DALOS::UR_IgnisID) ignis-amount)
            (let
                (
                    (ouro-id:string (ref-DALOS::UR_OuroborosID))
                    (ouro-price:decimal (ref-DALOS::UR_OuroborosPrice))
                    (ouro-price-used:decimal (if (<= ouro-price 1.00) 1.00 ouro-price))
                    (ouro-precision:integer (ref-DPTF::R_Decimals ouro-id))
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
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
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
    ;;{F2}
    (defun UEV_AccountsAsStandard (accounts:[string])
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (map
                (lambda
                    (account:string)
                    (ref-DALOS::UEV_EnforceAccountType account false)
                )
                accounts
            )
        )
    )
    (defun UEV_Exchange ()
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
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
    ;;{F3}
    ;;{F4}
    ;;
    ;;{F5}
    ;;{F6}
    (defun C_Compress:object{OuronetDalos.IgnisCumulator} (patron:string client:string ignis-amount:decimal)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-TFT:module{TrueFungibleTransfer} TFT)
                (orbr-sc:string ORBR|SC_NAME)

                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                (ignis-id:string (ref-DALOS::UR_IgnisID))
                (ignis-to-ouro:[decimal] (URC_Compress ignis-amount))
                (ouro-remainder-amount:decimal (at 0 ignis-to-ouro))
                (total-ouro:decimal (fold (+) 0.0 ignis-to-ouro))
            )
            (with-capability (IGNIS|C>COMPRESS patron client)
                (let
                    (
                        (ico1:object{OuronetDalos.IgnisCumulator}
                            (ref-TFT::XB_FeelesTransfer patron ignis-id client orbr-sc ignis-amount true)
                        )
                        (ico2:object{OuronetDalos.IgnisCumulator}
                            (ref-DPTF::C_Burn patron ignis-id orbr-sc ignis-amount)
                        )
                        (ico3:object{OuronetDalos.IgnisCumulator}
                            (ref-DPTF::C_Mint patron ouro-id orbr-sc ouro-remainder-amount false)
                        )
                        (ico4:object{OuronetDalos.IgnisCumulator}
                            (ref-TFT::XB_FeelesTransfer patron ouro-id orbr-sc client ouro-remainder-amount true)
                        )
                    )
                ;;01]Client sends GAS(Ignis) <ignis-amount> to the Ouroboros Smart DALOS Account
                    ;via ico1
                ;;02]Ouroboros burns GAS(Ignis) <ignis-amount>
                    ;via ico2
                ;;03]Ouroboros mints OURO <ouro-remainder-amount>
                    ;via ico3
                ;;04]Ouroboros transfers OURO <ouro-remainder-amount> to <client>
                    ;via ico4
                ;;05]Output ICO
                    (ref-DALOS::UDC_CompressICO [ico1 ico2 ico3 ico4] [ouro-remainder-amount])
                )
            )
        )
    )
    (defun C_Fuel:object{OuronetDalos.IgnisCumulator} (patron:string)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (P|UR "SWPU|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-coin:module{fungible-v2} coin)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-ATSU:module{AutostakeUsage} ATSU)
                (ref-LIQUID:module{KadenaLiquidStaking} LIQUID)
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
                            (let
                                (
                                    (ico1:object{OuronetDalos.IgnisCumulator}
                                        (ref-LIQUID::C_WrapKadena patron orb-sc present-kda-balance)
                                    )
                                    (ico2:object{OuronetDalos.IgnisCumulator}
                                        (ref-ATSU::C_Fuel patron orb-sc liquid-idx w-kda present-kda-balance)
                                    )
                                )
                                (ref-DALOS::UDC_CompressICO [ico1 ico2] [])
                            )
                        )
                        EIC
                    )
                )
                EIC
            )
        )
    )
    (defun C_Sublimate:object{OuronetDalos.IgnisCumulator} (patron:string client:string target:string ouro-amount:decimal)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-U|ATS:module{UtilityAts} U|ATS)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-TFT:module{TrueFungibleTransfer} TFT)
                (orbr-sc:string ORBR|SC_NAME)

                (ignis-id:string (ref-DALOS::UR_IgnisID))
                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                (ouro-precision:integer (ref-DPTF::UR_Decimals ouro-id))

                (ouro-split:[decimal] (ref-U|ATS::UC_PromilleSplit 10.0 ouro-amount ouro-precision))
                (ouro-remainder-amount:decimal (at 0 ouro-split))
                (ignis-amount:decimal (URC_Sublimate ouro-remainder-amount))
            )
            (with-capability (IGNIS|C>SUBLIMATE patron client target)
                (let
                    (
                        (ico1:object{OuronetDalos.IgnisCumulator}
                            (ref-TFT::XB_FeelesTransfer patron ouro-id client orbr-sc ouro-amount true)
                        )
                        (ico2:object{OuronetDalos.IgnisCumulator}
                            (ref-DPTF::C_Burn patron ouro-id orbr-sc ouro-amount)
                        )
                        (ico3:object{OuronetDalos.IgnisCumulator}
                            (ref-DPTF::C_Mint patron ignis-id orbr-sc ignis-amount false)
                        )
                        (ico4:object{OuronetDalos.IgnisCumulator}
                            (ref-TFT::XB_FeelesTransfer patron ignis-id orbr-sc target ignis-amount true)
                        )
                    )
                ;;01]Client sends OURO <ouro-amount> to the Ouroboros Smart DALOS Account
                    ;via ico1
                ;;02]Ouroboros burns OURO <ouro-amount>
                    ;via ico2
                ;;03]Ouroboros mints GAS(Ignis) <ignis-amount>
                    ;via ico3
                ;;04]Ouroboros transfers GAS(Ignis) <ignis-amount> to <target>
                    ;via ico4
                ;;05]Output ICO
                    (ref-DALOS::UDC_CompressICO [ico1 ico2 ico3 ico4] [ignis-amount])
                )
            )
        )
    )
    (defun C_WithdrawFees:object{OuronetDalos.IgnisCumulator} (patron:string id:string target:string)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-TFT:module{TrueFungibleTransfer} TFT)
                (orbr-sc:string ORBR|SC_NAME)
                (withdraw-amount:decimal (ref-DPTF::UR_AccountSupply id orbr-sc))
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                (ico1:object{OuronetDalos.IgnisCumulator}
                    (ref-DALOS::UDC_Cumulator price trigger [])
                )
            )
            (enforce (> withdraw-amount 0.0) (format "There are no {} fees to be withdrawn from {}" [id orbr-sc]))
            (with-capability (OUROBOROS|C>WITHDRAW patron id target)
                (let
                    (
                        (ico2:object{OuronetDalos.IgnisCumulator}
                            (ref-TFT::XB_FeelesTransfer patron id orbr-sc target withdraw-amount true)
                        )
                    )
                ;;01]Patron withdraws Fees from Ouroboros Smart DALOS Account to a target Normal DALOS Account
                    ;via ico2
                ;;01]Output ICO
                    (ref-DALOS::UDC_CompressICO [ico1 ico2] [])
                )
            )
        )
    )
)

(create-table P|T)
