(interface SaleShareholders
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
    (defun URC_ShareCosts:object{Launchpad.Costs} ())
    (defun URC_NonceCosts:object{Launchpad.Costs} (nonce:integer))
    (defun URC_NonceAmountCosts:object{Launchpad.Costs} (nonce:integer amount:integer))
    ;;
    ;;  [A+C]
    ;;
    (defun A_UpdateSharePrice (price:decimal))
    (defun C_Acquire (patron:string buyer:string nonce:integer amount:integer iz-native:bool))
    ;;
)
(module PAD-SH GOV
    @doc "Module defining the Sale Mechanics for Demiourgos Share Holder Collection"
    ;;
    (implements OuronetPolicy)
    (implements SaleShareholders)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_PAD-SH                    (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    (defconst LPAD|SC_NAME                     (GOV|LPAD|SC_NAME))
    ;;{G2}
    (defcap GOV ()                             (compose-capability (GOV|PAD-SH_ADMIN)))
    (defcap GOV|PAD-SH_ADMIN ()                (enforce-guard GOV|MD_PAD-SH))
    ;;{G3}
    (defun GOV|Demiurgoi ()                    (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|LPAD|SC_NAME ()                 (let ((ref-LPAD:module{Launchpad} LAUNCHPAD)) (ref-LPAD::GOV|LAUNCHPAD|SC_NAME)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|PAD-SH|CALLER ()
        true
    )
    (defcap P|PAD-SH|REMOTE-GOV ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|PAD-SH|CALLER))
        (compose-capability (SECURE))
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
        (with-capability (GOV|PAD-SH_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|PAD-SH_ADMIN)
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
                (ref-P|DPDC-T:module{OuronetPolicy} DPDC-T)
                (ref-P|LPAD:module{OuronetPolicy} LAUNCHPAD)
                (mg:guard (create-capability-guard (P|PAD-SH|CALLER)))
            )
            (ref-P|LPAD::P|A_Add
                "PAD-SH|RemoteGov"
                (create-capability-guard (P|PAD-SH|REMOTE-GOV))
            )
            (ref-P|DPDC-T::P|A_AddIMP mg)
            (ref-P|LPAD::P|A_AddIMP mg)
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
    (defschema PAD-SH|PropertiesSchema
        asset-id:string
    )
    ;;{2}
    (deftable PAD-SH|T|Properties:{PAD-SH|PropertiesSchema})
    ;;{3}
    (defun PAD-SH|Info ()                   (at 0 ["Shareholders"]))
    (defconst PAD-SH|INFO                   (PAD-SH|Info))
    (defun CT_Bar ()                        (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
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
    (defcap PAD-SH|C>INITIALISE ()
        @event
        (compose-capability (GOV|PAD-SH_ADMIN))
    )
    (defcap PAD-SH|ACQUIRE (nonce:integer amount:integer)
        @event
        (let
            (
                (available-supply-to-acquire:integer (UR_NonceSaleAvailability nonce))
            )
            (enforce (<= amount available-supply-to-acquire) "Insufficient Assets for Acquisiton!")
            (compose-capability (P|PAD-SH|CALLER))
            (compose-capability (P|PAD-SH|REMOTE-GOV))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_AssetID ()
        (at "asset-id" (read PAD-SH|T|Properties PAD-SH|INFO ["asset-id"]))
    )
    (defun UR_DollarSharePrice:decimal ()
        (let
            (
                (ref-LPAD:module{Launchpad} LAUNCHPAD)
            )
            (at "price-per-share-in-dollars" (ref-LPAD::UR_Price (UR_AssetID)))
        )
    )
    (defun UR_NonceSaleAvailability:integer (nonce:integer)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-LPAD:module{Launchpad} LAUNCHPAD)
                (lpad:string (ref-LPAD::GOV|LAUNCHPAD|SC_NAME))
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
    (defun URC_ShareCosts:object{Launchpad.Costs} ()
        (let
            (
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-LPAD:module{Launchpad} LAUNCHPAD)
                ;;
                (share-pid:decimal (UR_DollarSharePrice))
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                ;;
                (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                (wkda-prec:integer (ref-DPTF::UR_Decimals wkda-id))
            )
            (ref-LPAD::UDC_Costs
                share-pid
                (floor (/ share-pid kda-pid) wkda-prec)
            )
        )
    )
    (defun URC_NonceCosts:object{Launchpad.Costs} (nonce:integer)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-LPAD:module{Launchpad} LAUNCHPAD)
                ;;
                (share-costs:object{Launchpad.Costs} (URC_ShareCosts))
                (nonce-value-in-shares:integer (URC_NonceValueInShares nonce))
                ;;
                (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                (wkda-prec:integer (ref-DPTF::UR_Decimals wkda-id))
            )
            (ref-LPAD::UDC_Costs
                (floor (* (at "pid" share-costs) (dec nonce-value-in-shares)) 2)
                (floor (* (at "wkda" share-costs) (dec nonce-value-in-shares)) wkda-prec)
            )
        )
    )
    (defun URC_NonceAmountCosts:object{Launchpad.Costs} (nonce:integer amount:integer)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-LPAD:module{Launchpad} LAUNCHPAD)
                ;;
                (nonce-costs:object{Launchpad.Costs} (URC_NonceCosts nonce))
                ;;
                (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                (wkda-prec:integer (ref-DPTF::UR_Decimals wkda-id))
            )
            (ref-LPAD::UDC_Costs
                (floor (* (at "pid" nonce-costs) (dec amount)) 2)
                (floor (* (at "wkda" nonce-costs) (dec amount)) wkda-prec)
            )
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
                (ref-LPAD:module{Launchpad} LAUNCHPAD)
                (asset:string (UR_AssetID))
            )
            (ref-LPAD::A_DefinePrice asset
                {"price-per-share-in-dollars" : price}
            )
        )
    )
    ;;{F6}  [C]
    (defun C_Acquire (patron:string buyer:string nonce:integer amount:integer iz-native:bool)
        @doc "Nonce 1 are Pure Shares, Nonces 2-8 are Tier 1-7 PackageShares \
            \ When <iz-native> is set to true, Native KDA is used for buy, which must be wrapped to WKDA"
        (with-capability (PAD-SH|ACQUIRE nonce amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPDC-T:module{DpdcTransfer} DPDC-T)
                    (ref-LPAD:module{Launchpad} LAUNCHPAD)
                    ;;
                    (lpad-sc:string (ref-LPAD::GOV|LAUNCHPAD|SC_NAME))
                    (asset:string (UR_AssetID))
                    (costs:object{Launchpad.Costs} (URC_NonceAmountCosts nonce amount))
                    (pid:decimal (at "pid" costs))
                    (type:integer (if iz-native 0 1))
                    (ico1:object{IgnisCollector.OutputCumulator}
                        (ref-LPAD::C_Deposit buyer asset pid type false)
                    )
                    (ico2:object{IgnisCollector.OutputCumulator}
                        (ref-DPDC-T::C_Transfer asset true lpad-sc buyer [nonce] [amount] true)
                    )
                    (sb:string (ref-I|OURONET::OI|UC_ShortAccount buyer))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2] [])
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
(create-table PAD-SH|T|Properties)