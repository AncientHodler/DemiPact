(interface SaleCustodians
    ;;
    (defun A_InitialiseSaleModule (patron:string asset-id:string price:decimal))
    ;;
    (defun C_Acquire (patron:string buyer:string nonce:integer amount:integer iz-native:bool))
    ;;
)
(module PAD-CUSTODIANS GOV
    @doc "Module defining the Sale Mechanics for Demiourgos Share Holder Collection"
    ;;
    (implements OuronetPolicy)
    (implements SaleCustodians)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_PAD-CUSTODIANS         (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|PAD-CUSTODIANS_ADMIN)))
    (defcap GOV|PAD-CUSTODIANS_ADMIN ()     (enforce-guard GOV|MD_PAD-CUSTODIANS))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;; [Keys]
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|LaunchpadKey ()              (+ (GOV|NS_Use) ".dh_sc_mb-keyset"))
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
                (ref-P|LPAD:module{OuronetPolicy} LAUNCHPAD)
                (mg:guard (create-capability-guard (P|PAD-CUSTODIANS|CALLER)))
            )
            (ref-P|LPAD::P|A_Add
                "PAD-CUSTODIANS|RemoteGov"
                (create-capability-guard (P|PAD-CUSTODIANS|REMOTE-GOV))
            )
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
    (deftable PAD-CUSTODIANS|PropertiesTable:{PAD-CUSTODIANS|PropertiesSchema})
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
    (defcap PAD-CUSTODIANS|ACQUIRE ()
        @event
        (compose-capability (P|PAD-CUSTODIANS|CALLER))
        (compose-capability (P|PAD-CUSTODIANS|REMOTE-GOV))
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
    (defun UR_ASSET ()
        (at "asset-id" (read PAD-CUSTODIANS|PropertiesTable PAD-CUSTODIANS|INFO ["asset-id"]))
    )
    (defun UR_QuitessencePrice:decimal ()
        (let
            (
                (ref-LPAD:module{Launchpad} LAUNCHPAD)
                (asset:string (UR_ASSET))
            )
            (at "quintessence-price" (ref-LPAD::UR_Price asset))
        )
    )
    (defun UR_NonceSaleAvailability:integer (nonce:integer)
        (UEV_AcquisitionNonce nonce)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-LPAD:module{Launchpad} LAUNCHPAD)
                (lpad:string (ref-LPAD::GOV|LAUNCHPAD|SC_NAME))
                (asset:string (UR_ASSET))
            )
            (ref-DPDC::UR_AccountNonceSupply lpad asset true nonce)
        )
    )
    ;;{F1}  [URC]
    (defun URC_KadenaQuintessencePrice:decimal ()
        (let
            (
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                ;;
                (q-pid:decimal (UR_QuitessencePrice))
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                (wkda-prec:integer (ref-DPTF::UR_Decimals wkda-id))
            )
            (floor (/ q-pid kda-pid) wkda-prec)
        )
    )
    (defun URC_KadenaNoncePrice:decimal (nonce:integer)
        (UEV_AcquisitionNonce nonce)
        (let
            (
                (nq:integer (UC_NonceQuintessence nonce))
                (kqp:decimal (URC_KadenaQuintessencePrice))
            )
            (* (dec nq) kqp)
        )
    )
    (defun URC_KadenaNonceAmountPrice (nonce:integer amount:integer)
        (* (dec amount) (URC_KadenaNoncePrice nonce))
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
    (defun A_InitialiseSaleModule (patron:string asset-id:string price:decimal)
        (with-capability (PAD-CUSTODIANS|C>INITIALISE)
            (let
                (
                    (ref-LPAD:module{Launchpad} LAUNCHPAD)
                )
            ;;1]Store the <asset-id> for easier later retrieval (to be done in local table)
                (XI_I|AssetId asset-id)
            ;;2]Register <asset-id> with the LAUNCHPAD
                (ref-LPAD::A_RegisterAssetToLaunchpad patron asset-id [false true])
            ;;3]Update <asset-id> price on the launchpad
                (ref-LPAD::A_DefinePrice asset-id {"quitessence-price" : price})
            ;;4]Enable LAUNCHPAD module communication via required guards
                ;(P|A_Define)                                   ;;only for later added Sale Assets
            ;;5]Gain Acces to LAUNCHPAD|SC_NAME by updating its Governor with a guard defined at ;;4]
                ;;5.1]Update LAUNCHPA Module with a new <LAUNCHPAD|SetGovernor> function
                ;;5.2]Run update Function (for later modules)
                ;(ref-LPAD::LAUNCHPAD|SetGovernor patron)       ;;only for later added Sale Assets
            )
        )
        ;;6]Fuel Launchpad with Assets (must be done separately)
        ;;7]Enable ASSET acquisition (must be done separately)
    )
    (defun A_UpdatePricePerShare (price:decimal)
        @doc "Updates the Price per Share for the"
        (let
            (
                (ref-LPAD:module{Launchpad} LAUNCHPAD)
                (asset:string (UR_ASSET))
            )
            (ref-LPAD::A_DefinePrice asset
                {"quintessence-price" : price}
            )
        )
    )
    ;;{F6}  [C]
    (defun C_Acquire (patron:string buyer:string nonce:integer amount:integer iz-native:bool)
        @doc "Only Nonce -3 -2 -1 can be used, and these are Bronze/Silver/Golden Fragment Nonces"
        (with-capability (PAD-CUSTODIANS|ACQUIRE)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                    (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                    (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
                    (ref-LPAD:module{Launchpad} LAUNCHPAD)
                    ;;
                    (lpad:string (ref-LPAD::GOV|LAUNCHPAD|SC_NAME))
                    (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                    (asset:string (UR_ASSET))
                    ;;
                    (aquisition-price:decimal (URC_KadenaNonceAmountPrice nonce amount))
                    (sa-b:string (ref-I|OURONET::OI|UC_ShortAccount buyer))
                )
                ;;1]Wrap the needed Kadena Amount if <iz-native> tag is <true>
                (if iz-native
                    (ref-TS01-C2::LQD|C_WrapKadena patron buyer aquisition-price)
                    true
                )
                ;;2]Move the WKDA to <lpad> and Register the Sale in the Launchpad
                (ref-TS01-C1::DPTF|C_Transfer patron wkda-id buyer lpad aquisition-price true)
                (ref-LPAD::XE_RegisterSale asset aquisition-price)
                ;;3]Move acquired ASSET to buyer
                (ref-TS02-C1::DPSF|C_TransferNonce patron asset lpad buyer nonce amount true)
                ;;4]Finalisation String
                (format "Account {} succesfully acquired {} {} Nonce {}" [sa-b amount asset nonce])
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_I|AssetId (asset-id:string)
        (require-capability (GOV|PAD-CUSTODIANS_ADMIN))
        (insert PAD-CUSTODIANS|PropertiesTable PAD-CUSTODIANS|INFO
            {"asset-id"     : asset-id}
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)
(create-table PAD-CUSTODIANS|PropertiesTable)