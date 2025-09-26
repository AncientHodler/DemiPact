(module TS02-DPAD GOV
    @doc "TALOS Stage 2 Client Functiones Part 2 - NFT Functions"
    ;;
    (implements OuronetPolicy)
    (implements TalosStageTwo_DemiPad)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_TS02-DPAD        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                   (compose-capability (GOV|TS02-DPAD_ADMIN)))
    (defcap GOV|TS02-DPAD_ADMIN ()    (enforce-guard GOV|MD_TS02-DPAD))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|TS ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (gap:bool (ref-DALOS::UR_GAP))
            )
            (enforce (not gap) "While Global Administrative Pause is online, no client Functions can be executed")
            (compose-capability (P|TALOS-SUMMONER))
        )
    )
    (defcap P|TALOS-SUMMONER ()
        @doc "Talos Summoner Capability"
        true
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|TS02-DPAD_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|TS02-DPAD_ADMIN)
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
                (ref-P|DPAD:module{OuronetPolicy} DEMIPAD)
                (ref-P|SPARK:module{OuronetPolicy} DEMIPAD-SPARK)
                (ref-P|SNAKES:module{OuronetPolicy} DEMIPAD-SNAKES)
                (ref-P|CUSTODIANS:module{OuronetPolicy} DEMIPAD-CUSTODIANS)
                (mg:guard (create-capability-guard (P|TALOS-SUMMONER)))
            )
            (ref-P|DPAD::P|A_AddIMP mg)
            (ref-P|SPARK::P|A_AddIMP mg)
            (ref-P|SNAKES::P|A_AddIMP mg)
            (ref-P|CUSTODIANS::P|A_AddIMP mg)
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
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_ShortAccount:string (account:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
            )
            (ref-I|OURONET::OI|UC_ShortAccount account)
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun A_RegisterAssetToLaunchpad (patron:string asset-id:string fungibility:[bool])
        @doc "Registers an Asset to Launchpad; \
            \ An Asset can be a DPTF, DPMF, DPSF or DPNF \
            \   Asset-type can be designated via the double-boolean <fungibility> \
            \   \
            \   DPFT >> [true true] \
            \   DPMF >> [true false] \
            \   DPSF >> [false true] \
            \   DPNF >> [false false]"
        (with-capability (P|TALOS-SUMMONER)
            (let
                (
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV5} TS01-C1)
                    (ref-TS02-C1:module{TalosStageTwo_ClientOneV3} TS02-C1)
                    (ref-TS02-C2:module{TalosStageTwo_ClientTwoV3} TS02-C2)
                    (ref-DEMIPAD:module{DemiourgosLaunchpad} DEMIPAD)
                    (lpad:string (ref-DEMIPAD::GOV|DEMIPAD|SC_NAME))
                    (tf:[bool] [true true])
                    (of:[bool] [true false])
                    (sf:[bool] [false true])
                    (nf:[bool] [false false])
                )
                (ref-DEMIPAD::A_RegisterAssetToLaunchpad patron asset-id fungibility)
                (cond
                    ((= fungibility tf) (ref-TS01-C1::DPTF|C_DeployAccount patron asset-id lpad))
                    ((= fungibility of) (ref-TS01-C1::DPOF|C_DeployAccount patron asset-id lpad))
                    ((= fungibility sf) (ref-TS02-C1::DPSF|C_DeployAccount patron lpad asset-id))
                    ((= fungibility nf) (ref-TS02-C2::DPNF|C_DeployAccount patron lpad asset-id))
                    true
                )
            )
        )
    )
    (defun A_ToggleOpenForBusiness (asset-id:string toggle:bool)
        @doc "Toggle Open For Bussines. Must be on to acquire Assets"
        (with-capability (P|TALOS-SUMMONER)
            (let
                (
                    (ref-DEMIPAD:module{DemiourgosLaunchpad} DEMIPAD)
                )
                (ref-DEMIPAD::A_ToggleOpenForBusiness asset-id toggle)
            )
        )
    )
    (defun A_DefinePrice (asset-id:string price:object)
        @doc "Updates Price Object for an Asset"
        (with-capability (P|TALOS-SUMMONER)
            (let
                (
                    (ref-DEMIPAD:module{DemiourgosLaunchpad} DEMIPAD)
                )
                (ref-DEMIPAD::A_DefinePrice asset-id price)
            )
        )
    )
    (defun A_ToggleRetrieval (asset-id:string toggle:bool)
        @doc "Retrieval ON allows Asset Owners to retrieve their Asssets that still exist on the Launchpad"
        (with-capability (P|TALOS-SUMMONER)
            (let
                (
                    (ref-DEMIPAD:module{DemiourgosLaunchpad} DEMIPAD)
                )
                (ref-DEMIPAD::A_ToggleRetrieval asset-id toggle)
            )
        )
    )
    ;;{F6}  [C]
    (defun DEMIPAD|C_Withdraw (patron:string asset-id:string type:integer destination:string)
        @doc "Withdraws all cumulated Tokens in the Launchpad, gathered through sale \
            \ Type 1 = WKDA \
            \ Type 2 = LKDA \
            \ Type 3 = OURO "
        (with-capability (P|TS)
            (let
                (
                    (ref-DEMIPAD:module{DemiourgosLaunchpad} DEMIPAD)
                )
                (ref-DEMIPAD::C_Withdraw patron asset-id type destination)
            )
        )
    )
    ;;
    (defun DEMIPAD|C_FuelTrueFungible (patron:string client:string asset-id:string amount:decimal)
        (with-capability (P|TS)
            (let
                (
                    (ref-DEMIPAD:module{DemiourgosLaunchpad} DEMIPAD)
                )
                (ref-DEMIPAD::C_TransmitTrueFungible patron client asset-id amount true)
            )      
        )
    )
    (defun DEMIPAD|C_FuelOrtoFungible (patron:string client:string asset-id:string nonces:[integer])
        (with-capability (P|TS)
            (let
                (
                    (ref-DEMIPAD:module{DemiourgosLaunchpad} DEMIPAD)
                )
                (ref-DEMIPAD::C_TransmitOrtoFungible patron client asset-id nonces true)
            )      
        )
    )
    (defun DEMIPAD|C_FuelSemiFungible (patron:string client:string asset-id:string nonces:[integer] amounts:[integer])
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-DEMIPAD:module{DemiourgosLaunchpad} DEMIPAD)
                    (c:string (ref-I|OURONET::OI|UC_ShortAccount client))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DEMIPAD::C_TransmitSemiFungibles client asset-id nonces amounts true)
                )
                (format "Succesfuly fueled {} Nonces {} with Amounts {} to Demiourgos Launchpad from Account {}" [asset-id nonces amounts c])
            )      
        )
    )
    (defun DEMIPAD|C_FuelNonFungible (patron:string client:string asset-id:string nonces:[integer] amounts:[integer])
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-DEMIPAD:module{DemiourgosLaunchpad} DEMIPAD)
                    (c:string (ref-I|OURONET::OI|UC_ShortAccount client))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DEMIPAD::C_TransmitNonFungibles client asset-id nonces amounts true)
                )
                (format "Succesfuly fueled {} Nonces {} with Amounts {} to Demiourgos Launchpad from Account {}" [asset-id nonces amounts c])
            )      
        )
    )
    ;;
    (defun DEMIPAD|C_RetrieveTrueFungible (patron:string client:string asset-id:string amount:decimal)
        (with-capability (P|TS)
            (let
                (
                    (ref-DEMIPAD:module{DemiourgosLaunchpad} DEMIPAD)
                )
                (ref-DEMIPAD::C_TransmitTrueFungible patron client asset-id amount false)
            )      
        )
    )
    (defun DEMIPAD|C_RetrieveOrtoFungible (patron:string client:string asset-id:string nonces:[integer])
        (with-capability (P|TS)
            (let
                (
                    (ref-DEMIPAD:module{DemiourgosLaunchpad} DEMIPAD)
                )
                (ref-DEMIPAD::C_TransmitOrtoFungible patron client asset-id nonces false)
            )      
        )
    )
    (defun DEMIPAD|C_RetrieveSemiFungible (patron:string client:string asset-id:string nonces:[integer] amounts:[integer])
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-DEMIPAD:module{DemiourgosLaunchpad} DEMIPAD)
                    (c:string (ref-I|OURONET::OI|UC_ShortAccount client))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DEMIPAD::C_TransmitSemiFungibles client asset-id nonces amounts false)
                )
                (format "Succesfuly retrieved {} Nonces {} with Amounts {} from Demiourgos Launchpad to Account {}" [asset-id nonces amounts c])
            )      
        )
    )
    (defun DEMIPAD|C_RetrieveNonFungible (patron:string client:string asset-id:string nonces:[integer] amounts:[integer])
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-DEMIPAD:module{DemiourgosLaunchpad} DEMIPAD)
                    (c:string (ref-I|OURONET::OI|UC_ShortAccount client))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DEMIPAD::C_TransmitNonFungibles client asset-id nonces amounts false)
                )
                (format "Succesfuly retrieved {} Nonces {} with Amounts {} from Demiourgos Launchpad to Account {}" [asset-id nonces amounts c])
            )      
        )
    )
    ;;
    ;;
    (defun SPARK|C_BuySparks (patron:string buyer:string sparks-amount:integer iz-native:bool)
        (with-capability (P|TS)
            (let
                (
                    (ref-SPARK:module{Sparks} DEMIPAD-SPARK)
                )
                (ref-SPARK::C_BuySparks patron buyer sparks-amount iz-native)
            )
        )
    )
    (defun SPARK|C_RedemAllSparks (patron:string redemption-payer:string account-to-redeem:string)
        (with-capability (P|TS)
            (let
                (
                    (ref-SPARK:module{Sparks} DEMIPAD-SPARK)
                )
                (ref-SPARK::C_RedemAllSparks patron redemption-payer account-to-redeem)
            )
        )
    )
    (defun SPARK|C_RedemFewSparks (patron:string redemption-payer:string account-to-redeem:string redemption-quantity:integer)
        (with-capability (P|TS)
            (let
                (
                    (ref-SPARK:module{Sparks} DEMIPAD-SPARK)
                )
                (ref-SPARK::C_RedemFewSparks patron redemption-payer account-to-redeem redemption-quantity)
            )
        )
    )
    ;;
    (defun SNAKES|C_Acquire (patron:string buyer:string nonce:integer amount:integer iz-native:bool)
        (with-capability (P|TS)
            (let
                (
                    (ref-SNAKES:module{SaleSnakes} DEMIPAD-SNAKES)
                )
                (ref-SNAKES::C_Acquire patron buyer nonce amount iz-native)
            )
        )
    )
    (defun CUSTODIANS|C_Acquire (patron:string buyer:string nonce:integer amount:integer iz-native:bool)
        (with-capability (P|TS)
            (let
                (
                    (ref-CUSTODIANS:module{SaleCustodians} DEMIPAD-CUSTODIANS)
                )
                (ref-CUSTODIANS::C_Acquire patron buyer nonce amount iz-native)
            )
        )
    )
    ;;
    ;;  [2] DEMIPAD
    ;;
    
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)