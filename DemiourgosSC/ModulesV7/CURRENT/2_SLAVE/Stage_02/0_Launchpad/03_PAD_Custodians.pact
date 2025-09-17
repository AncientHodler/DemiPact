(interface SaleCustodians
    ;;
    ;;  [UC]
    ;;
    (defun UC_NonceQuintessence:integer (nonce:integer validation:bool))
    ;;
    ;;  [UR]
    ;;
    (defun UR_AssetID ())
    (defun UR_QuitessencePrice:decimal ())
    (defun UR_NonceSaleAvailability:integer (nonce:integer))
    ;;
    ;;  [URC]
    ;;
    (defun URC_QuintessenceCosts:object{Launchpad.Costs} ())
    (defun URC_NonceCosts:object{Launchpad.Costs} (nonce:integer))
    (defun URC_NonceAmountCosts:object{Launchpad.Costs} (nonce:integer amount:integer))
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_AcquisitionNonce (nonce:integer))
    (defun UEV_ConditionalAcquisitionNonce (nonce:integer validation:bool))
    ;;
    ;;  [A+C]
    ;;
    (defun A_UpdateQuintessencePrice (price:decimal))
    (defun C_Acquire (patron:string buyer:string nonce:integer amount:integer iz-native:bool))
)
(module PAD-CUSTODIANS GOV
    @doc "Module defining the Sale Mechanics for Ouronet Custodians Collection"
    ;;
    (implements OuronetPolicy)
    (implements SaleCustodians)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_PAD-CUSTODIANS            (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    (defconst LPAD|SC_NAME                     (GOV|LPAD|SC_NAME))
    ;;{G2}
    (defcap GOV ()                             (compose-capability (GOV|PAD-CUSTODIANS_ADMIN)))
    (defcap GOV|PAD-CUSTODIANS_ADMIN ()        (enforce-guard GOV|MD_PAD-CUSTODIANS))
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
    (defcap P|PAD-CUSTODIANS|CALLER ()
        true
    )
    (defcap P|PAD-CUSTODIANS|REMOTE-GOV ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|PAD-CUSTODIANS|CALLER))
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
        (with-capability (GOV|PAD-CUSTODIANS_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|PAD-CUSTODIANS_ADMIN)
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
                (mg:guard (create-capability-guard (P|PAD-CUSTODIANS|CALLER)))
            )
            (ref-P|LPAD::P|A_Add
                "PAD-CUSTODIANS|RemoteGov"
                (create-capability-guard (P|PAD-CUSTODIANS|REMOTE-GOV))
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
    (defschema PAD-CUSTODIANS|PropertiesSchema
        asset-id:string
    )
    ;;{2}
    (deftable PAD-CUSTODIANS|T|Properties:{PAD-CUSTODIANS|PropertiesSchema})
    ;;{3}
    (defun PAD-CUSTODIANS|Info ()                   (at 0 ["Custodians"]))
    (defconst PAD-CUSTODIANS|INFO                   (PAD-CUSTODIANS|Info))
    (defun CT_Bar ()                                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                                   (CT_Bar))
    
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
    (defcap PAD-CUSTODIANS|C>INITIALISE ()
        @event
        (compose-capability (GOV|PAD-CUSTODIANS_ADMIN))
    )
    (defcap PAD-CUSTODIANS|ACQUIRE (nonce:integer amount:integer)
        @event
        (let
            (
                (available-supply-to-acquire:integer (UR_NonceSaleAvailability nonce))
            )
            (enforce (<= amount available-supply-to-acquire) "Insufficient Assets for Acquisiton!")
            (compose-capability (P|PAD-CUSTODIANS|CALLER))
            (compose-capability (P|PAD-CUSTODIANS|REMOTE-GOV))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_NonceQuintessence:integer (nonce:integer validation:bool)
        (UEV_ConditionalAcquisitionNonce nonce validation)
        (if (= nonce -3)
            1
            (if (= nonce 2)
                10
                100
            )
        )
    )
    ;;{F0}  [UR]
    (defun UR_AssetID ()
        (at "asset-id" (read PAD-CUSTODIANS|T|Properties PAD-CUSTODIANS|INFO ["asset-id"]))
    )
    (defun UR_QuitessencePrice:decimal ()
        (let
            (
                (ref-LPAD:module{Launchpad} LAUNCHPAD)
            )
            (at "quintessence-price" (ref-LPAD::UR_Price (UR_AssetID)))
        )
    )
    (defun UR_NonceSaleAvailability:integer (nonce:integer)
        (UEV_AcquisitionNonce nonce)
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
    (defun URC_QuintessenceCosts:object{Launchpad.Costs} ()
        (let
            (
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-LPAD:module{Launchpad} LAUNCHPAD)
                ;;
                (q-pid:decimal (UR_QuitessencePrice))
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                ;;
                (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                (wkda-prec:integer (ref-DPTF::UR_Decimals wkda-id))
            )
            (ref-LPAD::UDC_Costs
                q-pid
                (floor (/ q-pid kda-pid) wkda-prec)
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
                (q-costs:object{Launchpad.Costs} (URC_QuintessenceCosts))
                (nonce-value-in-quintessence:integer (UC_NonceQuintessence nonce))
                ;;
                (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                (wkda-prec:integer (ref-DPTF::UR_Decimals wkda-id))
            )
            (ref-LPAD::UDC_Costs
                (floor (* (at "pid" q-costs) (dec nonce-value-in-quintessence)) 2)
                (floor (* (at "wkda" q-costs) (dec nonce-value-in-quintessence)) wkda-prec)
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
    (defun UEV_AcquisitionNonce (nonce:integer)
        (let
            (
                (acquisition-nonces:[integer] [-3 -2 -1])
                (iz-acquisition-nonce:bool (contains nonce acquisition-nonces))
            )
            (enforce iz-acquisition-nonce "Invalid Custodian Acquisition Nonce")
        )
    )
    (defun UEV_ConditionalAcquisitionNonce (nonce:integer validation:bool)
        (if validation
            (UEV_AcquisitionNonce nonce)
            true
        )
    )
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun A_UpdateQuintessencePrice (price:decimal)
        @doc "Updates the Quintessence Price"
        (let
            (
                (ref-LPAD:module{Launchpad} LAUNCHPAD)
                (asset:string (UR_AssetID))
            )
            (ref-LPAD::A_DefinePrice asset
                {"quintessence-price" : price}
            )
        )
    )
    ;;{F6}  [C]
    (defun C_Acquire (patron:string buyer:string nonce:integer amount:integer iz-native:bool)
        @doc "Only Nonce -3 -2 -1 can be used, and these are Bronze/Silver/Golden Fragment Nonces"
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
    ;;{F7}  [X]
    (defun XI_I|AssetId (asset-id:string)
        (require-capability (GOV|PAD-CUSTODIANS_ADMIN))
        (insert PAD-CUSTODIANS|T|Properties PAD-CUSTODIANS|INFO
            {"asset-id"     : asset-id}
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)
(create-table PAD-CUSTODIANS|T|Properties)