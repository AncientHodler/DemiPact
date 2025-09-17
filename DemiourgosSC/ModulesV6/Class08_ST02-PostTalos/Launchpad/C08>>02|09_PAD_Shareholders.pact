(interface SaleShareholders
    ;;
    (defun A_InitialiseSaleModule (patron:string asset-id:string price:decimal))
    ;;
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
    (defconst GOV|MD_PAD-SH                 (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|PAD-SH_ADMIN)))
    (defcap GOV|PAD-SH_ADMIN ()             (enforce-guard GOV|MD_PAD-SH))
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
                (ref-P|LPAD:module{OuronetPolicy} LAUNCHPAD)
                (mg:guard (create-capability-guard (P|PAD-SH|CALLER)))
            )
            (ref-P|LPAD::P|A_Add
                "PAD-SH|RemoteGov"
                (create-capability-guard (P|PAD-SH|REMOTE-GOV))
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
    (defschema PAD-SH|PropertiesSchema
        asset-id:string
    )
    ;;{2}
    (deftable PAD-SH|PropertiesTable:{PAD-SH|PropertiesSchema})
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
    (defcap PAD-SH|ACQUIRE ()
        @event
        (compose-capability (P|PAD-SH|CALLER))
        (compose-capability (P|PAD-SH|REMOTE-GOV))
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_ASSET ()
        (at "asset-id" (read PAD-SH|PropertiesTable PAD-SH|INFO ["asset-id"]))
    )
    (defun UR_DollarSharePrice:decimal ()
        (let
            (
                (ref-LPAD:module{Launchpad} LAUNCHPAD)
                (asset:string (UR_ASSET))
            )
            (at "price-per-share-in-dollars" (ref-LPAD::UR_Price asset))
        )
    )
    (defun UR_NonceSaleAvailability:integer (nonce:integer)
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
    (defun URC_KadenaSharePrice:decimal ()
        (let
            (
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                ;;
                (share-pid:decimal (UR_DollarSharePrice))
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                (wkda-prec:integer (ref-DPTF::UR_Decimals wkda-id))
            )
            (floor (/ share-pid kda-pid) wkda-prec)
        )
    )
    (defun URC_NonceShares:integer (nonce:integer)
        (if (= nonce 1)
            1
            (let
                (
                    (ref-EQUITY:module{Equity} EQUITY)
                    (asset:string (UR_ASSET))
                    (tier:integer (- nonce 1))
                )
                (ref-EQUITY::URC_SingleSharePerMillions asset tier)
            )
        )
    )
    (defun URC_KadenaNoncePrice:decimal (nonce:integer)
        (let
            (
                (nonce-shares:integer (URC_NonceShares nonce))
                (kadena-share-price:decimal (URC_KadenaSharePrice))
            )
            (* (dec nonce-shares) kadena-share-price)
        )
    )
    (defun URC_KadenaNonceAmountPrice (nonce:integer amount:integer)
        (* (dec amount) (URC_KadenaNoncePrice nonce))
    )
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun A_InitialiseSaleModule (patron:string asset-id:string price:decimal)
        (with-capability (PAD-SH|C>INITIALISE)
            (let
                (
                    (ref-LPAD:module{Launchpad} LAUNCHPAD)
                )
            ;;1]Store the <asset-id> for easier later retrieval (to be done in local table)
                (XI_I|AssetId asset-id)
            ;;2]Register <asset-id> with the LAUNCHPAD
                (ref-LPAD::A_RegisterAssetToLaunchpad patron asset-id [false true])
            ;;3]Update <asset-id> price on the launchpad
                (ref-LPAD::A_DefinePrice asset-id {"price-per-share-in-dollars" : price})
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
                {"price-per-share-in-dollars" : price}
            )
        )
    )
    ;;{F6}  [C]
    (defun C_Acquire (patron:string buyer:string nonce:integer amount:integer iz-native:bool)
        @doc "Nonce 1 are Pure Shares, Nonces 2-8 are Tier 1-7 PackageShares \
        \ When <iz-native> is set to true, Native KDA is used for buy, which must be wrapped to WKDA"
        (with-capability (PAD-SH|ACQUIRE)
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
        (require-capability (GOV|PAD-SH_ADMIN))
        (insert PAD-SH|PropertiesTable PAD-SH|INFO
            {"asset-id"     : asset-id}
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)
(create-table PAD-SH|PropertiesTable)