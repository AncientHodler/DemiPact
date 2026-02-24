(interface Sparks
    ;;
    ;;  [UR]
    ;;
    (defun UR_SparkID:string ())
    (defun UR_IzOpenForBusiness:bool ())
    (defun UR_FrozenSparkID:string ())
    (defun UR_Sparks (account:string))
    ;;
    ;;  [URC]
    ;;
    (defun URC_GetMaxBuy:integer (account:string native:bool))
    (defun URC_SparkCost:decimal ())
    (defun URC_SparkRedemptionCost:decimal ())
    (defun URC_AccountRedemptionAmount:decimal (account:string))
    ;;
    ;;  [C]
    ;;
    (defun C_BuySparks (patron:string buyer:string sparks-amount:integer iz-native:bool))
    (defun C_RedemAllSparks (patron:string redemption-payer:string account-to-redeem:string))
    (defun C_RedemFewSparks (patron:string redemption-payer:string account-to-redeem:string redemption-quantity:integer))
    ;;
)
(interface SparksV2
    ;;
    ;;  [UR]
    ;;
    (defun UR_SparkID:string ())
    (defun UR_IzOpenForBusiness:bool ())
    (defun UR_FrozenSparkID:string ())
    (defun UR_Sparks (account:string))
    ;;
    ;;  [URC]
    ;;
    (defun URC_GetMaxBuy:integer (account:string native:bool))
    (defun URC_SparkCost:decimal ())
    (defun URC_SparkRedemptionCost:decimal ())
    (defun URC_AccountRedemptionAmount:decimal (account:string))
    ;;
    ;;  [C]
    ;;
    (defun C_BuySparks (patron:string buyer:string sparks-amount:integer iz-native:bool))
    (defun C_RedemAllSparks (patron:string redemption-payer:string account-to-redeem:string))
    (defun C_RedemFewSparks (patron:string redemption-payer:string account-to-redeem:string redemption-quantity:decimal))
    ;;
)
(interface SparksV3
    ;;
    ;;  [UR]
    ;;
    (defun UR_SparkID:string ())
    (defun UR_IzOpenForBusiness:bool ())
    (defun UR_FrozenSparkID:string ())
    (defun UR_Sparks (account:string))
    ;;
    ;;  [URC]
    ;;
    (defun URC_GetMaxBuy:integer (account:string native:bool))
    (defun URC_SparkCost:decimal ())
    (defun URC_SparkRedemptionCost:decimal ())
    (defun URC_AccountRedemptionAmount:decimal (account:string))
    ;;
    ;;  [C]
    ;;
    (defun C_BuySparks (patron:string buyer:string sparks-amount:integer iz-native:bool))
    (defun C_RedemAllSparks (patron:string redemption-payer:string account-to-redeem:string))
    (defun C_CustomRedemAllSparks (patron:string redemption-payer:string account-to-redeem:string custom-kda-pid:decimal))
    (defun C_RedemFewSparks (patron:string redemption-payer:string account-to-redeem:string redemption-quantity:decimal))
    (defun C_CustomRedemFewSparks (patron:string redemption-payer:string account-to-redeem:string redemption-quantity:decimal custom-kda-pid:decimal))
    ;;
)
(module DEMIPAD-SPARK GOV
    ;;
    (implements OuronetPolicyV1)
    (implements SparksV3)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_SPARK                     (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    (defconst DEMIPAD|SC_NAME                  (GOV|DEMIPAD|SC_NAME))
    ;;{G2}
    (defcap GOV ()                             (compose-capability (GOV|SPARK_ADMIN)))
    (defcap GOV|SPARK_ADMIN ()                 (enforce-guard GOV|MD_SPARK))
    ;;{G3}
    (defun GOV|Demiurgoi ()                    (let ((ref-DALOS:module{OuronetDalosV1} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|DEMIPAD|SC_NAME ()              (let ((ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)) (ref-DEMIPAD::GOV|DEMIPAD|SC_NAME)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicyV1.P|S})
    (deftable P|MT:{OuronetPolicyV1.P|MS})
    ;;{P3}
    (defcap P|SPARK|CALLER ()
        true
    )
    (defcap P|PAD-SPARK|REMOTE-GOV ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|SPARK|CALLER))
        (compose-capability (SECURE))
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
        (with-capability (GOV|SPARK_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|SPARK_ADMIN)
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
                (ref-P|DPTF:module{OuronetPolicyV1} DPTF)
                (ref-P|TFT:module{OuronetPolicyV1} TFT)
                (ref-P|VST:module{OuronetPolicyV1} VST)
                (ref-P|DPAD:module{OuronetPolicyV1} DEMIPAD)
                (mg:guard (create-capability-guard (P|SPARK|CALLER)))
            )
            (ref-P|DPAD::P|A_Add
                "SPARK|RemoteGov"
                (create-capability-guard (P|PAD-SPARK|REMOTE-GOV))
            )
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|VST::P|A_AddIMP mg)
            (ref-P|DPAD::P|A_AddIMP mg)
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
    (defschema SPARK|PropertiesSchema
        spark-id:string
    )
    ;;{2}
    (deftable SPARK|T|Properties:{SPARK|PropertiesSchema})
    ;;{3}
    (defun SPARK|Info ()                        (at 0 ["spark-data-key"]))
    (defconst SPARK|INFO                        (SPARK|Info))
    (defun CT_Bar ()                            (let ((ref-U|CT:module{OuronetConstantsV1} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                               (CT_Bar))
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
    (defcap SPARK|C>BUY (sparks-amount:integer)
        @event
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (spark-id:string (UR_SparkID))
                (remaining-supply:decimal (ref-DPTF::UR_AccountSupply spark-id DEMIPAD|SC_NAME))
                (amount:decimal (dec sparks-amount))
            )
            (enforce (<= amount remaining-supply) "Remaining Amount surpassed!")
            (compose-capability (P|PAD-SPARK|REMOTE-GOV))
            (compose-capability (P|SECURE-CALLER))
        )
    )
    (defcap SPARK|C>REEDEM-ALL (account-to-redeem:string)
        @event
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (spark-id:string (UR_SparkID))
                (supply:decimal (ref-DPTF::UR_AccountSupply spark-id account-to-redeem))
            )
            (compose-capability (SPARK|C>X_REEDEM account-to-redeem supply))
        )
    )
    (defcap SPARK|C>REEDEM-FEW (account-to-redeem:string redemption-quantity:decimal)
        @event
        (compose-capability (SPARK|C>X_REEDEM account-to-redeem redemption-quantity))
    )
    (defcap SPARK|C>X_REEDEM (account-to-redeem:string redemption-quantity:decimal)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (spark-id:string (UR_SparkID))
                (supply:decimal (ref-DPTF::UR_AccountSupply spark-id account-to-redeem))
            )
            (ref-DPTF::CAP_Owner spark-id)
            (enforce 
                (and
                    (> redemption-quantity 0.0)
                    (<= redemption-quantity supply)
                )
                "Invalid Redemmption Amount"
            )
            (compose-capability (P|SECURE-CALLER))
            (compose-capability (P|PAD-SPARK|REMOTE-GOV))
            (compose-capability (GOV|SPARK_ADMIN))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_SparkID:string ()
        (at "spark-id" (read SPARK|T|Properties SPARK|INFO ["spark-id"]))
    )
    (defun UR_BoostPromille:decimal ()
        (let
            (
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
            )
            (at "boost" (ref-DEMIPAD::UR_Price (UR_SparkID)))
        )
    )
    (defun UR_IzOpenForBusiness:bool ()
        (let
            (
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
            )
            (ref-DEMIPAD::UR_OpenForBusiness (UR_SparkID))
        )
    )
    (defun UR_FrozenSparkID:string ()
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
            )
            (ref-DPTF::UR_Frozen (UR_SparkID))
        )
    )
    (defun UR_Sparks (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (spark-id:string (UR_SparkID))
                (f-spark-id:string (UR_FrozenSparkID))
            )
            {"spark-id"         : spark-id
            ,"f-spark-id"       : f-spark-id
            ,"spark-supply"     : (ref-DPTF::UR_AccountSupply spark-id account)
            ,"f-spark-supply"   : (ref-DPTF::UR_AccountSupply f-spark-id account)
            ;;
            ,"iz-sale"          : (UR_IzOpenForBusiness)
            ,"boost-promile"    : (UR_BoostPromille)
            ;;
            ,"left-for-sale"    : (ref-DPTF::UR_AccountSupply spark-id DEMIPAD|SC_NAME)
            ,"sparks-supply"    : (ref-DPTF::UR_Supply spark-id)
            ,"f-sparks-supply"  : (ref-DPTF::UR_Supply f-spark-id)
            ;;
            ,"kda-spark-cost"   : (URC_SparkCost)
            ,"redemption-value" : (URC_SparkRedemptionCost)
            ;;
            ,"native-max"       : (URC_GetMaxBuy account true)
            ,"wkda-max"         : (URC_GetMaxBuy account false)
            ;;
            ,"account-ignis"    : (ref-DPTF::UR_AccountSupply (ref-DALOS::UR_IgnisID) account)
            ,"ignis-collection" : (ref-DALOS::UR_VirtualToggle)}
        )
    )
    ;;{F1}  [URC]
    (defun URC_GetMaxBuy:integer (account:string native:bool)
        @doc "Returns the maximum amount of Tokens that can still be bought \
            \ Considering the amount left, and the User Funds"
        (let
            (
                (ref-coin:module{fungible-v2} coin)

                (ref-U|CT:module{OuronetConstantsV1} U|CT)
                (ref-U|CT|DIA:module{DiaKdaPidV1} U|CT)
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                ;;
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                ;;
                (k-account:string (ref-DALOS::UR_AccountKadena account))
                (wkda:string (ref-DALOS::UR_WrappedKadenaID))
                (spark-id:string (UR_SparkID))
                (spark-price:decimal (at "pid" (ref-DEMIPAD::UR_Price spark-id)))
                (still-for-sale:decimal (ref-DPTF::UR_AccountSupply spark-id DEMIPAD|SC_NAME))
                ;;
                (client-kadena-supply:decimal
                    (if native
                        (ref-coin::get-balance k-account)
                        (ref-DPTF::UR_AccountSupply wkda account)
                    )
                )
                (client-kadena-value-in-dollarz:decimal (floor (* client-kadena-supply kda-pid) 2))
                (can-buy-with-client-supply:decimal (floor (/ client-kadena-value-in-dollarz spark-price)))
            )
            (floor
                (if (<= can-buy-with-client-supply still-for-sale)
                    can-buy-with-client-supply
                    still-for-sale
                )
            )
        )
    )
    (defun URC_SparkCost:decimal ()
        @doc "Returns the amount of KDA that is needed to pay for one Token"
        (let
            (
                (ref-U|CT:module{OuronetConstantsV1} U|CT)
                (ref-U|CT|DIA:module{DiaKdaPidV1} U|CT)
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                ;;
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                ;;
                (spark-id:string (UR_SparkID))
                (spark-price:decimal (at "pid" (ref-DEMIPAD::UR_Price spark-id)))
            )
            (floor (/ spark-price kda-pid) kda-prec)
        )
    )
    (defun URC_SparkRedemptionCost:decimal ()
        @doc "Returns the amount of KDA|WKDA a single Token can be redeemed for."
        (let
            (
                (ref-U|CT:module{OuronetConstantsV1} U|CT)
                (ref-U|CT|DIA:module{DiaKdaPidV1} U|CT)
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                (boost:decimal (UR_BoostPromille))
            )
            (floor (/ (+ 1.0 (/ boost 1000.0)) kda-pid) kda-prec)
        )
    )
    (defun URC_CustomSparkRedemptionCost:decimal (custom-kda-pid:decimal)
        @doc "Returns the amount of KDA|WKDA a single Token can be redeemed for."
        (let
            (
                (ref-U|CT:module{OuronetConstantsV1} U|CT)
                (ref-U|CT|DIA:module{DiaKdaPidV1} U|CT)
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                (boost:decimal (UR_BoostPromille))
            )
            (floor (/ (+ 1.0 (/ boost 1000.0)) custom-kda-pid) kda-prec)
        )
    )
    (defun URC_AccountRedemptionAmount:decimal (account:string)
        @doc "Returns Account Redemption Amount"
        (let
            (
                (ref-U|CT:module{OuronetConstantsV1} U|CT)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (spark-id:string (UR_SparkID))
                (supply:decimal (ref-DPTF::UR_AccountSupply spark-id account))
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                (rc:decimal (URC_SparkRedemptionCost))
            )
            (floor (* supply rc) kda-prec)
        )
    )
    (defun URC_SparkAmountCosts:object{DemiourgosLaunchpadV2.Costs} (amount:integer)
        (let
            (
                (ref-U|CT:module{OuronetConstantsV1} U|CT)
                (ref-U|CT|DIA:module{DiaKdaPidV1} U|CT)
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                ;;
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                ;;
                (spark-id:string (UR_SparkID))
                (spark-price:decimal (at "pid" (ref-DEMIPAD::UR_Price spark-id)))
            )
            (ref-DEMIPAD::UDC_Costs
                (* (dec amount) spark-price)
                (floor (* (/ spark-price kda-pid) (dec amount)) kda-prec)
            )
        )
    )
    (defun URC_Acquire:[string]
        (buyer:string amount:integer iz-native:bool)
        (let
            (
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                (asset-id:string (UR_SparkID))
                (type:integer (if iz-native 0 1))
                (pid:decimal (at "pid" (URC_SparkAmountCosts amount)))
            )
            (ref-DEMIPAD::URC_Acquire buyer asset-id pid type)
        )
    )
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_BuySparks (patron:string buyer:string sparks-amount:integer iz-native:bool)
        (UEV_IMC)
        (with-capability (SPARK|C>BUY sparks-amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV1} INFO-ZERO)
                    (ref-TFT:module{TrueFungibleTransferV1} TFT)
                    (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                    ;;
                    (spark-id:string (UR_SparkID))
                    (costs:object{DemiourgosLaunchpadV2.Costs} (URC_SparkAmountCosts sparks-amount))
                    (pid:decimal (at "pid" costs))
                    (type:integer (if iz-native 0 1))
                    (ico1:object{IgnisCollectorV1.OutputCumulator}
                        (ref-DEMIPAD::C_Deposit buyer spark-id pid type false)
                    )
                    (ico2:object{IgnisCollectorV1.OutputCumulator}
                        (ref-TFT::C_Transfer spark-id DEMIPAD|SC_NAME buyer (dec sparks-amount) true)
                    )
                    (sb:string (ref-I|OURONET::OI|UC_ShortAccount buyer))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2] [])
                )
                (format "User {} succesfuly acquired {} {} Tokens" [sb sparks-amount spark-id])
            )
        )
    )
    (defun C_RedemAllSparks (patron:string redemption-payer:string account-to-redeem:string)
        (with-capability (SPARK|C>REEDEM-ALL account-to-redeem)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                    (spark-id:string (UR_SparkID))
                    (supply:decimal (ref-DPTF::UR_AccountSupply spark-id account-to-redeem))
                )
                (XI_RedeemSparks patron redemption-payer account-to-redeem supply)
            )
        )
    )
    (defun C_CustomRedemAllSparks (patron:string redemption-payer:string account-to-redeem:string custom-kda-pid:decimal)
        (with-capability (SPARK|C>REEDEM-ALL account-to-redeem)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                    (spark-id:string (UR_SparkID))
                    (supply:decimal (ref-DPTF::UR_AccountSupply spark-id account-to-redeem))
                )
                (XI_CustomRedeemSparks patron redemption-payer account-to-redeem supply custom-kda-pid)
            )
        )
    )
    (defun C_RedemFewSparks (patron:string redemption-payer:string account-to-redeem:string redemption-quantity:decimal)
        (with-capability (SPARK|C>REEDEM-FEW account-to-redeem redemption-quantity)
            (XI_RedeemSparks patron redemption-payer account-to-redeem redemption-quantity)
        )
    )
    (defun C_CustomRedemFewSparks (patron:string redemption-payer:string account-to-redeem:string redemption-quantity:decimal custom-kda-pid:decimal)
        (with-capability (SPARK|C>REEDEM-FEW account-to-redeem redemption-quantity)
            (XI_CustomRedeemSparks patron redemption-payer account-to-redeem redemption-quantity custom-kda-pid)
        )
    )
    ;;{F7}  [X]
    (defun XI_RedeemSparks 
        (patron:string redemption-payer:string account-to-redeem:string redemption-quantity:decimal)
        (require-capability (SECURE))
        (let
            (
                (ref-U|CT:module{OuronetConstantsV1} U|CT)
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-I|OURONET:module{OuronetInfoV1} INFO-ZERO)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (ref-TFT:module{TrueFungibleTransferV1} TFT)
                (ref-VST:module{VestingV1} VST)
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                ;;
                (spark-id:string (UR_SparkID))
                (spark-redemption-cost:decimal (URC_SparkRedemptionCost))
                (redemption-value:decimal (floor (* spark-redemption-cost redemption-quantity) kda-prec))
                (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                (sa-atr:string (ref-I|OURONET::OI|UC_ShortAccount account-to-redeem))
            )
            (ref-IGNIS::C_Collect patron
                (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                    [
                        ;;1]Move Wrapped Kadena to Target
                        (ref-TFT::C_Transfer wkda-id redemption-payer account-to-redeem redemption-value true)
                        ;;2]Freeze <account-to-redeem>
                        (ref-DPTF::C_ToggleFreezeAccount spark-id account-to-redeem true)
                        ;;3]Partial Wipe <spark-id>
                        (ref-DPTF::C_WipeSlim spark-id account-to-redeem redemption-quantity)
                        ;;4]Unfreeze <account-to-redeem>
                        (ref-DPTF::C_ToggleFreezeAccount spark-id account-to-redeem false)
                        ;;5]Remint wiped amount to <DEMIPAD|SC_NAME>
                        (ref-DPTF::C_Mint spark-id DEMIPAD|SC_NAME redemption-quantity false)
                        ;;6]Freeze it to back to <account-to-redeem>
                        (ref-VST::C_Freeze DEMIPAD|SC_NAME account-to-redeem spark-id redemption-quantity)
                    ]
                    []
                )
            )
            (format "Succesfully Redeemed {} {} for {} {} on Account {}"
                [redemption-quantity spark-id redemption-value wkda-id sa-atr]
            )
        )
    )
    (defun XI_CustomRedeemSparks 
        (patron:string redemption-payer:string account-to-redeem:string redemption-quantity:decimal custom-kda-pid:decimal)
        (require-capability (SECURE))
        (let
            (
                (ref-U|CT:module{OuronetConstantsV1} U|CT)
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-I|OURONET:module{OuronetInfoV1} INFO-ZERO)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (ref-TFT:module{TrueFungibleTransferV1} TFT)
                (ref-VST:module{VestingV1} VST)
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                ;;
                (spark-id:string (UR_SparkID))
                (spark-redemption-cost:decimal (URC_CustomSparkRedemptionCost custom-kda-pid))
                (redemption-value:decimal (floor (* spark-redemption-cost redemption-quantity) kda-prec))
                (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                (sa-atr:string (ref-I|OURONET::OI|UC_ShortAccount account-to-redeem))
            )
            (ref-IGNIS::C_Collect patron
                (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                    [
                        ;;1]Move Wrapped Kadena to Target
                        (ref-TFT::C_Transfer wkda-id redemption-payer account-to-redeem redemption-value true)
                        ;;2]Freeze <account-to-redeem>
                        (ref-DPTF::C_ToggleFreezeAccount spark-id account-to-redeem true)
                        ;;3]Partial Wipe <spark-id>
                        (ref-DPTF::C_WipeSlim spark-id account-to-redeem redemption-quantity)
                        ;;4]Unfreeze <account-to-redeem>
                        (ref-DPTF::C_ToggleFreezeAccount spark-id account-to-redeem false)
                        ;;5]Remint wiped amount to <DEMIPAD|SC_NAME>
                        (ref-DPTF::C_Mint spark-id DEMIPAD|SC_NAME redemption-quantity false)
                        ;;6]Freeze it to back to <account-to-redeem>
                        (ref-VST::C_Freeze DEMIPAD|SC_NAME account-to-redeem spark-id redemption-quantity)
                    ]
                    []
                )
            )
            (format "Succesfully Redeemed {} {} for {} {} on Account {}"
                [redemption-quantity spark-id redemption-value wkda-id sa-atr]
            )
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)
(create-table SPARK|T|Properties)