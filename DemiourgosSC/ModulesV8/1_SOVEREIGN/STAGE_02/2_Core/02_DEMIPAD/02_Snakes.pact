(interface SaleSnakesV2
    ;;
    ;;  [UR]
    ;;
    (defun UR_AssetID ())
    (defun UR_DollarSharePrice:decimal ())
    (defun UR_NonceSaleAvailability:integer (nonce:integer))
    ;;
    ;;  [URC]
    ;;
    (defun URC_NonceValueInShares:integer (nonce:integer))
    (defun URC_ShareCosts:object{DemiourgosLaunchpadV2.Costs} ())
    (defun URC_NonceCosts:object{DemiourgosLaunchpadV2.Costs} (nonce:integer))
    (defun URC_NonceAmountCosts:object{DemiourgosLaunchpadV2.Costs} (nonce:integer amount:integer))
    ;;
    ;;  [A+C]
    ;;
    (defun A_UpdateSharePrice (price:decimal))
    (defun C_Acquire (patron:string buyer:string nonce:integer amount:integer iz-native:bool))
    ;;
)
(module DEMIPAD-SNAKES GOV
    @doc "Module defining the Sale Mechanics for Demiourgos Share Holder Collection"
    ;;
    (implements OuronetPolicyV1)
    (implements SaleSnakesV2)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_SNAKES                    (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    (defconst DEMIPAD|SC_NAME                  (GOV|DEMIPAD|SC_NAME))
    ;;{G2}
    (defcap GOV ()                             (compose-capability (GOV|SNAKES_ADMIN)))
    (defcap GOV|SNAKES_ADMIN ()                (enforce-guard GOV|MD_SNAKES))
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
    (defcap P|SNAKES|CALLER ()
        true
    )
    (defcap P|SNAKES|REMOTE-GOV ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|SNAKES|CALLER))
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
        (with-capability (GOV|SNAKES_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|SNAKES_ADMIN)
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
                (ref-P|DPDC-T:module{OuronetPolicyV1} DPDC-T)
                (ref-P|DPAD:module{OuronetPolicyV1} DEMIPAD)
                (mg:guard (create-capability-guard (P|SNAKES|CALLER)))
            )
            (ref-P|DPAD::P|A_Add
                "SNAKES|RemoteGov"
                (create-capability-guard (P|SNAKES|REMOTE-GOV))
            )
            (ref-P|DPDC-T::P|A_AddIMP mg)
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
    (defschema SNAKES|PropertiesSchema
        asset-id:string
    )
    ;;{2}
    (deftable SNAKES|T|Properties:{SNAKES|PropertiesSchema})
    ;;{3}
    (defun SNAKES|Info ()                   (at 0 ["Shareholders"]))
    (defconst SNAKES|INFO                   (SNAKES|Info))
    (defun CT_Bar ()                        (let ((ref-U|CT:module{OuronetConstantsV1} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                           (CT_Bar))
    
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
    (defcap SNAKES|C>INITIALISE ()
        @event
        (compose-capability (GOV|SNAKES_ADMIN))
    )
    (defcap SNAKES|ACQUIRE (nonce:integer amount:integer)
        @event
        (let
            (
                (available-supply-to-acquire:integer (UR_NonceSaleAvailability nonce))
            )
            (enforce (<= amount available-supply-to-acquire) "Insufficient Assets for Acquisiton!")
            (compose-capability (P|SNAKES|CALLER))
            (compose-capability (P|SNAKES|REMOTE-GOV))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_AssetID ()
        (at "asset-id" (read SNAKES|T|Properties SNAKES|INFO ["asset-id"]))
    )
    (defun UR_DollarSharePrice:decimal ()
        (let
            (
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
            )
            (at "price-per-share-in-dollars" (ref-DEMIPAD::UR_Price (UR_AssetID)))
        )
    )
    (defun UR_NonceSaleAvailability:integer (nonce:integer)
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                (lpad:string (ref-DEMIPAD::GOV|DEMIPAD|SC_NAME))
                (asset:string (UR_AssetID))
            )
            (ref-DPDC::UR_AccountNonceSupply lpad asset true nonce)
        )
    )
    ;;{F1}  [URC]
    (defun URC_NonceValueInShares:integer (nonce:integer)
        (if (= nonce 1)
            1
            (let
                (
                    (ref-EQUITY:module{Equity} EQUITY)
                    (asset:string (UR_AssetID))
                    (tier:integer (- nonce 1))
                )
                (ref-EQUITY::URC_SingleSharePerMillions asset tier)
            )
        )
    )
    (defun URC_ShareCosts:object{DemiourgosLaunchpadV2.Costs} ()
        (let
            (
                (ref-U|CT|DIA:module{DiaKdaPidV1} U|CT)
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                ;;
                (share-pid:decimal (UR_DollarSharePrice))
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                ;;
                (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                (wkda-prec:integer (ref-DPTF::UR_Decimals wkda-id))
            )
            (ref-DEMIPAD::UDC_Costs
                share-pid
                (floor (/ share-pid kda-pid) wkda-prec)
            )
        )
    )
    (defun URC_NonceCosts:object{DemiourgosLaunchpadV2.Costs} (nonce:integer)
        (let
            (
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                ;;
                (share-costs:object{DemiourgosLaunchpadV2.Costs} (URC_ShareCosts))
                (nonce-value-in-shares:integer (URC_NonceValueInShares nonce))
                ;;
                (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                (wkda-prec:integer (ref-DPTF::UR_Decimals wkda-id))
            )
            (ref-DEMIPAD::UDC_Costs
                (floor (* (at "pid" share-costs) (dec nonce-value-in-shares)) 2)
                (floor (* (at "wkda" share-costs) (dec nonce-value-in-shares)) wkda-prec)
            )
        )
    )
    (defun URC_NonceAmountCosts:object{DemiourgosLaunchpadV2.Costs} (nonce:integer amount:integer)
        (let
            (
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                ;;
                (nonce-costs:object{DemiourgosLaunchpadV2.Costs} (URC_NonceCosts nonce))
                ;;
                (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                (wkda-prec:integer (ref-DPTF::UR_Decimals wkda-id))
            )
            (ref-DEMIPAD::UDC_Costs
                (floor (* (at "pid" nonce-costs) (dec amount)) 2)
                (floor (* (at "wkda" nonce-costs) (dec amount)) wkda-prec)
            )
        )
    )
    (defun URC_Acquire:[string]
        (buyer:string nonce:integer amount:integer iz-native:bool)
        (let
            (
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                (asset-id:string (UR_AssetID))
                (type:integer (if iz-native 0 1))
                (pid:decimal (at "pid" (URC_NonceAmountCosts nonce amount)))
            )
            (ref-DEMIPAD::URC_Acquire buyer asset-id pid type)
        )
    )
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun A_UpdateSharePrice (price:decimal)
        @doc "Updates the Share Price"
        (let
            (
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                (asset:string (UR_AssetID))
            )
            (ref-DEMIPAD::A_DefinePrice asset
                {"price-per-share-in-dollars" : price}
            )
        )
    )
    ;;{F6}  [C]
    (defun C_Acquire (patron:string buyer:string nonce:integer amount:integer iz-native:bool)
        @doc "Nonce 1 are Pure Shares, Nonces 2-8 are Tier 1-7 PackageShares \
            \ When <iz-native> is set to true, Native KDA is used for buy, which must be wrapped to WKDA"
        (with-capability (SNAKES|ACQUIRE nonce amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV1} INFO-ZERO)
                    (ref-DPDC-T:module{DpdcTransferV1} DPDC-T)
                    (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                    ;;
                    (asset:string (UR_AssetID))
                    (costs:object{DemiourgosLaunchpadV2.Costs} (URC_NonceAmountCosts nonce amount))
                    (pid:decimal (at "pid" costs))
                    (type:integer (if iz-native 0 1))
                    (ico1:object{IgnisCollectorV1.OutputCumulator}
                        (ref-DEMIPAD::C_Deposit buyer asset pid type false)
                    )
                    (ico2:object{IgnisCollectorV1.OutputCumulator}
                        (ref-DPDC-T::C_Transfer [asset] [true] DEMIPAD|SC_NAME buyer [[nonce]] [[amount]] true)
                    )
                    (sb:string (ref-I|OURONET::OI|UC_ShortAccount buyer))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2] [])
                )
                (format "User {} succesfuly acquired {} Nonce {} {} SFTs" [sb amount nonce asset])
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)
(create-table SNAKES|T|Properties)