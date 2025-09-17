(interface DemiourgosLaunchpad
    ;;
    ;;  [Schemas]
    ;;
    (defschema Costs
        pid:decimal
        wkda:decimal
    )
    ;;
    (defschema DEMIPAD|Properties
        direct-injection:bool
        resident-wkda:decimal
        resident-lkda:decimal
        resident-ouro:decimal
    )
    (defschema DEMIPAD|Holdings
        total-dollarz-raised:decimal
        total-wkda-raised:decimal
        total-lkda-raised:decimal
        total-ouro-raised:decimal
        funds-wkda:decimal
        funds-lkda:decimal
        funds-ouro:decimal
        ;;
        iz-lkda:bool
        iz-ouro:bool
        ;;
        fungibility:[bool]
        open-for-business:bool
        price:object
        retrieval:bool
    )
    (defschema DEMIPAD|Prices
        receiver-one:string
        receiver-two:string
        receiver-three:string
        receiver-four:string
        amount-one:decimal
        amount-two:decimal
        amount-three:decimal
        amount-four:decimal
        enviroment-amount:decimal
        coding-amount:decimal
        remainder-amount:decimal
    )
    (defschema RoyaltyInterval
        "Schema for fee intervals"
        start:decimal
        end:decimal
        fee-promille:decimal
    )
    ;;
    (defun GOV|DEMIPAD|SC_NAME ())
    ;;
    ;;
    (defun UC_Type:string (asset-id:string fungibility:[bool]))
    (defun UC_GenerateRoyaltyIntervals:[object{RoyaltyInterval}] ())
    (defun UC_ComputeDepositRoyalty:decimal (current-balance:decimal deposit-amount:decimal))
    (defun UC_LaunchpadEnviromentSplit:[decimal] (amount-in-kda:decimal))
    ;;
    ;;  [UR]
    ;;
    (defun UR_LaunchpadState:object{DEMIPAD|Properties} ())
    (defun UR_DirectInjection:bool ())
    (defun UR_WKDA:decimal ())
    (defun UR_LKDA:decimal ())
    (defun UR_OURO:decimal ())
        ;;
    (defun UR_AssetState:object{DEMIPAD|Holdings} (asset-id:string))
    (defun UR_TotalDollarzRaised:decimal (asset-id:string))
    (defun UR_TotalWKDARaised:decimal (asset-id:string))
    (defun UR_TotalLKDARaised:decimal (asset-id:string))
    (defun UR_TotalOURORaised:decimal (asset-id:string))
    (defun UR_WKDA|Funds:decimal (asset-id:string))
    (defun UR_LKDA|Funds:decimal (asset-id:string))
    (defun UR_OURO|Funds:decimal (asset-id:string))
        ;;
    (defun UR_IzLKDA:bool (asset-id:string))
    (defun UR_IzOURO:bool (asset-id:string))
    (defun UR_Fungibility:[bool] (asset-id:string))
    (defun UR_OpenForBusiness:bool (asset-id:string))
    (defun UR_Price:object (asset-id:string))
    (defun UR_Retrieval:bool (asset-id:string))
    (defun UR_CheckRegistration:bool (asset-id:string))
    ;;
    ;;  [URC]
    ;;
    (defun URC_Prices:object{DEMIPAD|Prices} (asset-id:string amount-in-dollars:decimal type:integer))
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_AssetFungibility (asset-id:string fungibility-to-check:[bool]))
    (defun UEV_Fungibility (fungibility:[bool]))
    ;;
    ;;  [UDC]
    ;;
    (defun UDC_Costs:object{Costs} (a:decimal b:decimal))
    (defun UDC_DEMIPAD|Holdings:object{DEMIPAD|Holdings}
        (
            a:decimal b:decimal c:decimal d:decimal
            e:decimal f:decimal g:decimal
            h:bool i:bool
            j:[bool] k:bool l:object m:bool
        )
    )
    (defun UDC_LaunchpadPrices:object{DEMIPAD|Prices}
        (
            a:string b:string c:string d:string
            e:decimal f:decimal g:decimal h:decimal
            j:decimal k:decimal l:decimal
        )
    )
    ;;
    ;;  [CAP]
    ;;
    (defun CAP_Owner (asset-id:string))
    ;;
    ;;  [A]
    ;;
    (defun A_RegisterAssetToLaunchpad (patron:string asset-id:string fungibility:[bool]))
    (defun A_ToggleOpenForBusiness (asset-id:string toggle:bool))
    (defun A_DefinePrice (asset-id:string price:object))
    (defun A_ToggleRetrieval (asset-id:string toggle:bool))
    ;;
    ;;  [C]
    ;;
    (defun C_Deposit:object{IgnisCollector.OutputCumulator}
        (donor:string asset-id:string amount-in-dollars:decimal type:integer direct-injection:bool)
    )
    (defun C_Withdraw (patron:string asset-id:string type:integer destination:string)
    )
    ;;
    (defun C_TransmitTrueFungible (patron:string client:string asset-id:string amount:decimal fuel-or-retrieve:bool))
    (defun C_TransmitOrtoFungible (patron:string client:string asset-id:string nonces:[integer] fuel-or-retrieve:bool))
    (defun C_TransmitSemiFungibles:object{IgnisCollectorV2.OutputCumulator} 
        (client:string asset-id:string nonces:[integer] amounts:[integer] fuel-or-retrieve:bool)
    )
    (defun C_TransmitNonFungibles:object{IgnisCollectorV2.OutputCumulator}
        (client:string asset-id:string nonces:[integer] amounts:[integer] fuel-or-retrieve:bool)
    )
    ;;
)
(module DEMIPAD GOV
    @doc "Demiourgos Launchpad, is a permissioned Launchpad operated by Demiourgos.Holdings  \
        \ allowing the Company to sell Assets (DPTFs, DPMFs, DPSFs and DPNFs) \
        \ \
        \ HOW IT WORKS: \
        \ The Launchpad Admin registers an Asset for Sale, this Asset is then Permanently registered to the Launchpad \
        \ Sale is executed via Functions, in Modules created by Demiourgos Holdings, specific to each Asset \
        \ \
        \ For Sale, both Native KDA and WKDA are accepted, but also LKDA or OURO \
        \ \
        \ Of the incoming funds, there is an up 15% Retained Royalty by the Launchpad \
        \ The Royalty Decreases going as low as 0.3% the more an asset sales for. \
        \ One THIRD goes to the Enviroment as Native KDA (Unwrap would be executed if WKDA Input is used): \
        \       = 0.5% to Ouronet Gas Station \
        \       = 1.0% to Demiourgos.Holdings Treasury \
        \       = 1.5% to Launchpad Maintanance \
        \       = 2.0% to Liquid Staking \
        \ TWO THIRDS is injected to Coding Division Pot when acquisitions pool are coming Live \
        \       Until then, it will be retained in the Pool as WKDA \
        \ \
        \ If Assets are Sold for LKDA or OURO, then 5% of the value, must be supplied as Native Kadena to satisfy the Enviroment \
        \ \
        \ Remaining 85% can be withdrawed by Asset Owner or Creator (for SFTs and NFTs), or Launchpad Admin \
        \ \
        \ Launchpad Admin can update <open-for-business>, <price> and <retrieval> for each registered Asset \
        \ \
        \ <open-for-business>   = Determines if the Asset is on sale and if it can be bought by those that want to acquire it \
        \ <price> object        = Holds information regarding the Sale Price. This is then used by the Individual Asset Modules in the Sale Function \
        \ <retrieval> parameter = Defines if Asset Owners or Creators can withdraw their Assets from the Launchpad (default false) \
        \                       If set to <false> the only way to retrieve Assets is to execute a buy(sale). \
        \ \
        \ Each Asset has its own Sale Module, that defines the logic of the Buy Functions, allowing for individual custom logic to be implemented for each Sale \
        \ Which is the reason this is a permissioned Launchpad, as each Sale can have its own specific logic regarding Asset Acquisition \
        \ \
        \ \
        \ \
        \ Since this is a Permissioned Launchpad, creted by Demiourogs, it allows for using Internal Client Functions, (not from Talos Module) \
        \ To concatenate IGNIS Collection (meaning a single IGNIS collection is executed, instead of multiple, as it were the case, had Client Functions from Talos Module been used)"
    ;;
    (implements OuronetPolicy)
    (implements DemiourgosLaunchpad)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DEMIPAD                (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    (defconst DEMIPAD|SC_KEY                (GOV|LaunchpadKey))
    (defconst DEMIPAD|SC_NAME               (GOV|DEMIPAD|SC_NAME))
    (defconst MB|SC_KDA-NAME                "k:35d7f82a7754d10fc1128d199aadb51cb1461f0eb52f4fa89790a44434f12ed8")
    ;;Mainnet ==>                            k:2d4c9cd8d1bd30d9156b65c1259d2be9689f068927d8fee19bfb695619436e01
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DEMIPAD_ADMIN)))
    (defcap GOV|DEMIPAD_ADMIN ()            (enforce-guard GOV|MD_DEMIPAD))
    (defcap DEMIPAD|GOV ()
        @doc "Governor Capability for the DEMIPAD Smart DALOS Account"
        true
    )
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;; [Keys]
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|LaunchpadKey ()              (+ (GOV|NS_Use) ".dh_sc_mb-keyset"))
    ;;
    ;; [SC-Names]
    (defun GOV|DEMIPAD|SC_NAME ()           (at 0 ["Σ.Îäć$ЬчýφVεÎÿůпΨÖůηüηŞйnюŽXΣşpЩß5ςĂκ£RäbE₳èËłŹŘYшÆgлoюýRαѺÑÏρζt∇ŹÏýжIŒațэVÞÛщŹЭδźvëȘĂтPЖÃÇЭiërđÈÝДÖšжzČđзUĚĂsкιnãñOÔIKпŞΛI₳zÄû$ρśθ6ΨЬпYпĞHöÝйÏюşí2ćщÞΔΔŻTж€₿ŞhTțŽ"]))
    ;;
    ;; [PBLs]
    (defun GOV|DEMIPAD|PBL ()               (at 0 ["9F.gGCkuc2wMAnFAjuFphikftLdl6qFqBD4yfeMEe9u65yMqf4r340Jd6dphh1d7E1cE20btMwl4HJ2cBEMvp209GA1eD4syB96hu4nmpFbB7dKnJEMz4p8fGLcmhvrBCfDmM0axnGin8qedl5vDtwbgL3l1aK5BsmjkEEJartqCH8qG8ialtjxwCcIMf50t2lkeww6Dct5LlmmLG25FmfpcgnwMMnkJl4Gfn9gwoA6vm0jKebjhodeJLjxnh9L11ss8f26866dqv1tEphxFFqutGetH4Itj3rHkrcrGsnlqpf4gfJp94b0gBwIBe4vCj6ha8jm6kd3f8B6pEaJtkJ3fbs6rCcGibltz1BAMn0vvKME5ddFyGBnzssk1s2s0vFzwxs6vjC61Ma2l1xDxqdg1thAk2u01hDiGndLhzK73HAfgtk7bxscn0qKhymG6JAqnEFt282pyHAq5nIthK9bA8nH76x7FEpLz4eK9tLIBsyjb8M5DxaeEei6pEnLxFCAg7ulacgtjjpjMiAaqhpmM1jEHqjt4G85q4L33zrME7whgIkIpIgwnF2qKd4"]))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|DEMIPAD|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DEMIPAD|CALLER))
        (compose-capability (SECURE))
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
        (with-capability (GOV|DEMIPAD_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DEMIPAD_ADMIN)
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
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|LIQUID:module{OuronetPolicy} LIQUID)
                (ref-P|DPDC:module{OuronetPolicy} DPDC)
                (ref-P|DPDC-T:module{OuronetPolicy} DPDC-T)
                (mg:guard (create-capability-guard (P|DEMIPAD|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|LIQUID::P|A_AddIMP mg)
            (ref-P|DPDC::P|A_AddIMP mg)
            (ref-P|DPDC-T::P|A_AddIMP mg)
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
    (deftable DEMIPAD|T|Properties:{DemiourgosLaunchpad.DEMIPAD|Properties})
    (deftable DEMIPAD|T|Ledger:{DemiourgosLaunchpad.DEMIPAD|Holdings})
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defun CT_EmptyCumulator ()     (let ((ref-IGNIS:module{IgnisCollectorV2} IGNIS)) (ref-IGNIS::DALOS|EmptyOutputCumulatorV2)))
    (defconst BAR                   (CT_Bar))
    (defconst EOC                   (CT_EmptyCumulator))
    (defconst TF                    [true true])
    (defconst OF                    [true false])
    (defconst SF                    [false true])
    (defconst NF                    [false false])
    ;;
    (defconst PP                    "Launchpad-Properties")
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
    (defcap DEMIPAD|C>REGISTER (asset-id:string fungibility:[bool])
        @event
        (UEV_Fungibility fungibility)
        (compose-capability (DEMIPAD|C>SECURE-ADMIN))
    )
    (defcap DEMIPAD|C>SECURE-ADMIN ()
        (compose-capability (GOV|DEMIPAD_ADMIN))
        (compose-capability (SECURE))
    )
    ;;
    (defcap DEMIPAD|C>TOGGLE-SALE (asset-id:string toggle:bool)
        @event
        (let
            (
                (ofb:bool (UR_OpenForBusiness asset-id))
            )
            (enforce (!= toggle ofb) (format "Open for business is already {} for Asset {}" [toggle asset-id]))
            (compose-capability (DEMIPAD|C>SECURE-ADMIN))
        )
    )
    (defcap DEMIPAD|C>DEFINE-PRICE (asset-id:string price:object)
        @event
        (compose-capability (DEMIPAD|C>SECURE-ADMIN))
    )
    (defcap DEMIPAD|C>TOGGLE-RETRIEVAL (asset-id:string toggle:bool)
        @event
        (let
            (
                (rtr:bool (UR_Retrieval asset-id))
            )
            (enforce (!= toggle rtr) (format "Retrieval is already {} for Asset {}" [toggle asset-id]))
            (compose-capability (DEMIPAD|C>SECURE-ADMIN))
        )
    )
    ;;
    ;;
    (defcap DEMIPAD|C>FUEL-TRUE-FUNGIBLE (asset-id:string)
        @event
        (compose-capability (DEMIPAD|C>REGISTERED-ACCESS-BY-TYPE asset-id [true true]))
    )
    (defcap DEMIPAD|C>FUEL-ORTO-FUNGIBLE (asset-id:string)
        @event
        (compose-capability (DEMIPAD|C>REGISTERED-ACCESS-BY-TYPE asset-id [true false]))
    )
    (defcap DEMIPAD|C>FUEL-SEMI-FUNGIBLE (asset-id:string)
        @event
        (compose-capability (DEMIPAD|C>REGISTERED-ACCESS-BY-TYPE asset-id [false true]))
    )
    (defcap DEMIPAD|C>FUEL-NON-FUNGIBLE (asset-id:string)
        @event
        (compose-capability (DEMIPAD|C>REGISTERED-ACCESS-BY-TYPE asset-id [false false]))
    )
    ;;
    (defcap DEMIPAD|C>RETRIEVE-TRUE-FUNGIBLE (asset-id:string)
        @event
        (compose-capability (DEMIPAD|C>REGISTERED-ACCESS-BY-TYPE asset-id [true true]))
    )
    (defcap DEMIPAD|C>RETRIEVE-ORTO-FUNGIBLE (asset-id:string)
        @event
        (compose-capability (DEMIPAD|C>REGISTERED-ACCESS-BY-TYPE asset-id [true false]))
    )
    (defcap DEMIPAD|C>RETRIEVE-SEMI-FUNGIBLE (asset-id:string)
        @event
        (compose-capability (DEMIPAD|C>REGISTERED-ACCESS-BY-TYPE asset-id [false true]))
    )
    (defcap DEMIPAD|C>RETRIEVE-NON-FUNGIBLE (asset-id:string)
        @event
        (compose-capability (DEMIPAD|C>REGISTERED-ACCESS-BY-TYPE asset-id [false false]))
    )
    ;;
    (defcap DEMIPAD|C>REGISTERED-ACCESS-BY-TYPE (asset-id:string fungibility:[bool])
        (compose-capability (DEMIPAD|C>REGISTERED-ACCESS asset-id))
        (UEV_AssetFungibility asset-id fungibility)
    )
    ;;
    (defcap DEMIPAD|C>REGISTERED-ACCESS (asset-id:string)
        @doc "Fails is <asset-id> is not registered to Launchpad"
        (enforce-one
            (format "Only LPAD Admin or {} Owner|Creator may acces the Launchpad" [asset-id])
            [
                (enforce-guard (create-user-guard (CAP_Owner asset-id)))
                (enforce-guard GOV|MD_DEMIPAD)
            ]
        )
        (compose-capability (DEMIPAD|GOV))
    )
    ;;Deposti and Withdrawal
    (defcap DEMIPAD|C>DEPOSIT (donor:string asset-id:string amount-in-dollars:decimal type:integer direct-injection:bool)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (iz-type:bool (contains type [0 1 2 3]))
                (read-direct-injection:bool (UR_DirectInjection))
                (iz-registered:bool (UR_CheckRegistration asset-id))
                (ofb:bool (UR_OpenForBusiness asset-id))
                (iz-lkda:bool (UR_IzLKDA asset-id))
                (iz-ouro:bool (UR_IzOURO asset-id))
            )
            ;;Validate <donor> to be Standard Ouronet Account
            (ref-DALOS::UEV_EnforceAccountType donor false)
            ;;Validate <asset-id> to be a Launchpad registered Asset
            (enforce iz-registered (format "Asset {} is not registered to the Demiourgos Lauchpad. Deposit unallowed" [asset-id]))
            ;;Validate the <amount-in-dollars> to be greater than zero with 3 decimals
            (enforce
                (and
                    (= (floor amount-in-dollars 2) amount-in-dollars)
                    (> amount-in-dollars 0.0)
                )
                "Invalid Dollar Amount for Deposit"
            )
            ;;Validate <type> to be either 0, 1, 2 or 3, and that the required Token Deposit is turned on
            (enforce iz-type "Invalid Deposit type")
            (if (not (or (= type 0) (= type 1)))
                (if (= type 2)
                    (enforce iz-lkda "LKDA Deposits must be turned on for exec")
                    (enforce iz-ouro "LKDA Deposits must be turned on for exec")
                )
                true
            )
            ;;If <direct-injection> is used, it must be turned on.
            (if direct-injection
                (enforce read-direct-injection "Direct Injection is not yet available")
                true
            )
            ;;<open-for-business> must be turned on to allow Deposits
            (enforce ofb (format "{} is not open for business, to allow deposits"))
            ;;Acces Capabilities
            (compose-capability (DEMIPAD|GOV))
            (compose-capability (P|SECURE-CALLER))
        )
    )
    (defcap DEMIPAD|C>WITHDRAW (asset-id:string type:integer retrieval-amount:decimal destination:string )
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (iz-type:bool (contains type [1 2 3]))
            )
            ;;Validate <type> to be either 0, 1, 2 or 3, and that the required Token Deposit is turned on
            (enforce iz-type "Invalid Withdrawal type")
            ;;Validate <retrieval-amount> to be non-zero
            (enforce 
                (> retrieval-amount 0.0) 
                (format "There is nothing to retrieve for Asset-Id {} and Token Type {} ({})." 
                    [
                        asset-id
                        type
                        (if (= type 1) "WKDA" (if (= type 2) "LKDA" "OURO"))
                    ]
                )
            )
            ;;Validate <destination> to be Standard Ouronet Account
            (ref-DALOS::UEV_EnforceAccountType destination false)
            ;;Only <asset-id> Owner|Creator, or Launchpad Admin can retrieve Launchpad Funds
            (compose-capability (DEMIPAD|C>REGISTERED-ACCESS asset-id))
        )
    )
    ;;
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_Type:string (asset-id:string fungibility:[bool])
        (cond
            ((= fungibility TF) "True Fungible")
            ((= fungibility OF) "Orto-Fungible")
            ((= fungibility SF) "Semi-Fungible")
            ((= fungibility NF) "Non-Fungible")
            ""
        )
    )
    (defun UC_GenerateRoyaltyIntervals:[object{DemiourgosLaunchpad.RoyaltyInterval}] ()
        @doc "Generate list of fee intervals until fee reaches 3 promille"
        (let* 
            (
                (first-interval-size:decimal 10000.0)
                (initial-increment:decimal 5000.0)
                (fee-decrement:decimal 3.0)
                (min-fee:decimal 3.0)
            )
            (fold
                (lambda 
                    (acc:[object{DemiourgosLaunchpad.RoyaltyInterval}] idx:integer)
                    (let* 
                        (
                            (start:decimal
                                (if (= idx 0)
                                    0.0
                                    (at "end" (at 0 (take -1 acc)))
                                )
                            )
                            (increment-velocity:decimal 
                                (if (= idx 0)
                                    0.0
                                    (+ initial-increment (* 100.0 (dec (- idx 1)))))
                                )
                                
                            (prev-interval-size:decimal
                                (if (= idx 0)
                                    first-interval-size
                                    (-
                                        (at "end" (at 0 (take -1 acc)))
                                        (at "start" (at 0 (take -1 acc)))
                                    )
                                )
                            )
                            (increment:decimal (+ increment-velocity prev-interval-size))
                            (end:decimal 
                                (if (= idx 0)
                                    first-interval-size
                                    (+ start increment)
                                )
                            )
                            (fee-promille (- 150.0 (* fee-decrement (dec idx))))
                        )
                        (if (>= fee-promille min-fee)
                            (+ acc [{"start": start, "end": end, "fee-promille": fee-promille}])
                            acc
                        )
                    )
                )
                []
                (enumerate 0 49)
            )
        )
    )
    (defun UC_ComputeDepositRoyalty:decimal (current-balance:decimal deposit-amount:decimal)
        @doc "Compute fee for a deposit given current balance and deposit amount"
        (enforce (>= current-balance 0.0) "Current balance must be non-negative")
        (enforce (>= deposit-amount 0.0) "Deposit amount must be non-negative")
        (let* 
            (
                (deposit-start:decimal current-balance)
                (deposit-end:decimal (+ current-balance deposit-amount))
                (intervals:[object{DemiourgosLaunchpad.RoyaltyInterval}] (UC_GenerateRoyaltyIntervals))
                (last-interval:object{DemiourgosLaunchpad.RoyaltyInterval} (at (- (length intervals) 1) intervals) )
                (last-interval-end:decimal (at "end" last-interval))
                (min-fee:decimal (at "fee-promille" last-interval))
                (min-fee-rate:decimal (/ min-fee 1000.0))
            )
            (+
                ;;Interval Fees
                (fold
                    (lambda (total-fee:decimal interval:object{RoyaltyInterval})
                        (let 
                            (
                                (interval-start (at "start" interval))
                                (interval-end (at "end" interval))
                                (fee-rate (/ (at "fee-promille" interval) 1000.0))
                            )
                            (if (and (< deposit-start interval-end) (> deposit-end interval-start))
                                (+ 
                                    total-fee
                                    (* 
                                        fee-rate
                                        (- 
                                            (if (<= deposit-end interval-end) deposit-end interval-end)
                                            (if (>= deposit-start interval-start) deposit-start interval-start)
                                        )
                                    )
                                )
                                total-fee
                            )
                        )
                    )
                    0.0
                    intervals
                )
                ;;Beyond Fees
                (if (> deposit-end last-interval-end)
                    (* 
                        min-fee-rate
                        (- 
                            deposit-end 
                            (if (>= deposit-start last-interval-end) deposit-start last-interval-end)
                        )
                    )
                    0.0
                )
            )
        )
    )

    
    (defun UC_LaunchpadEnviromentSplit:[decimal] (amount-in-kda:decimal)
        @doc "Outputs the Launchpad Enviroment Split, whic is a \
        \ 10%, 20%, 30%, 40% Split, outputed as a 4 element list."
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
            )
            (ref-U|DALOS::UC_TenTwentyThirtyFourtySplit amount-in-kda kda-prec)
        )
    )
    ;;{F0}  [UR]
    (defun UR_LaunchpadState:object{DemiourgosLaunchpad.DEMIPAD|Properties} ()
        (read DEMIPAD|T|Properties PP)
    )
    (defun UR_DirectInjection:bool ()
        (at "direct-injection" (UR_LaunchpadState))
    )
    (defun UR_WKDA:decimal ()
        (at "resident-wkda" (UR_LaunchpadState))
    )
    (defun UR_LKDA:decimal ()
        (at "resident-lkda" (UR_LaunchpadState))
    )
    (defun UR_OURO:decimal ()
        (at "resident-ouro" (UR_LaunchpadState))
    )
    ;;
    (defun UR_AssetState:object{DemiourgosLaunchpad.DEMIPAD|Holdings} (asset-id:string)
        (read DEMIPAD|T|Ledger asset-id)
    )
    (defun UR_TotalDollarzRaised:decimal (asset-id:string)
        (at "total-dollarz-raised" (read DEMIPAD|T|Ledger asset-id ["total-dollarz-raised"]))
    )
    (defun UR_TotalRaised:decimal (asset-id:string type:integer)
        (enforce (contains type [1 2 3]) "Invalid Read Type")
        (cond
            ((= type 1) (UR_TotalWKDARaised asset-id))
            ((= type 2) (UR_TotalLKDARaised asset-id))
            ((= type 3) (UR_TotalOURORaised asset-id))
            0.0
        )
    )
    (defun UR_Funds:decimal (asset-id:string type:integer)
        (enforce (contains type [1 2 3]) "Invalid Read Type")
        (cond
            ((= type 1) (UR_WKDA|Funds asset-id))
            ((= type 2) (UR_LKDA|Funds asset-id))
            ((= type 3) (UR_OURO|Funds asset-id))
            0.0
        )
    )
    (defun UR_TotalWKDARaised:decimal (asset-id:string)
        (at "total-wkda-raised" (read DEMIPAD|T|Ledger asset-id ["total-wkda-raised"]))
    )
    (defun UR_TotalLKDARaised:decimal (asset-id:string)
        (at "total-lkda-raised" (read DEMIPAD|T|Ledger asset-id ["total-lkda-raised"]))
    )
    (defun UR_TotalOURORaised:decimal (asset-id:string)
        (at "total-ouro-raised" (read DEMIPAD|T|Ledger asset-id ["total-ouro-raised"]))
    )
    (defun UR_WKDA|Funds:decimal (asset-id:string)
        (at "funds-wkda" (read DEMIPAD|T|Ledger asset-id ["funds-wkda"]))
    )
    (defun UR_LKDA|Funds:decimal (asset-id:string)
        (at "funds-lkda" (read DEMIPAD|T|Ledger asset-id ["funds-lkda"]))
    )
    (defun UR_OURO|Funds:decimal (asset-id:string)
        (at "funds-ouro" (read DEMIPAD|T|Ledger asset-id ["funds-ouro"]))
    )
    ;;
    (defun UR_IzLKDA:bool (asset-id:string)
        (at "iz-lkda" (read DEMIPAD|T|Ledger asset-id ["iz-lkda"]))
    )
    (defun UR_IzOURO:bool (asset-id:string)
        (at "iz-ouro" (read DEMIPAD|T|Ledger asset-id ["iz-ouro"]))
    )
    (defun UR_Fungibility:[bool] (asset-id:string)
        (at "fungibility" (read DEMIPAD|T|Ledger asset-id ["fungibility"]))
    )
    (defun UR_OpenForBusiness:bool (asset-id:string)
        (at "open-for-business" (read DEMIPAD|T|Ledger asset-id ["open-for-business"]))
    )
    (defun UR_Price:object (asset-id:string)
        (at "price" (read DEMIPAD|T|Ledger asset-id ["price"]))
    )
    (defun UR_Retrieval:bool (asset-id:string)
        (at "retrieval" (read DEMIPAD|T|Ledger asset-id ["retrieval"]))
    )
    ;;
    (defun UR_CheckRegistration:bool (asset-id:string)
        (try
            false
            (with-read DEMIPAD|T|Ledger asset-id 
                { "price" := dummy }
                true
            )
        )
    )
    ;;{F1}  [URC]
    (defun URC_Prices:object{DemiourgosLaunchpad.DEMIPAD|Prices} 
        (asset-id:string amount-in-dollars:decimal type:integer)
        (let
            (
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (ref-SWPI:module{SwapperIssueV3} SWPI)
                ;;
                (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                (lkda-id:string (ref-DALOS::UR_LiquidKadenaID))
                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                ;;
                (wkda-prec:integer (ref-DPTF::UR_Decimals wkda-id))
                (lkda-prec:integer (ref-DPTF::UR_Decimals lkda-id))
                (ouro-prec:integer (ref-DPTF::UR_Decimals ouro-id))
                ;;
                (total-dollarz-raised:decimal (UR_TotalDollarzRaised asset-id))
                (deposit-royalty:decimal (UC_ComputeDepositRoyalty total-dollarz-raised amount-in-dollars))
                (five-percent-dollarz:decimal (floor (/ deposit-royalty 3.0) 5))
                (ten-percent-dollarz:decimal (- deposit-royalty five-percent-dollarz))
                (remainder-percent-dollarz:decimal (- amount-in-dollars deposit-royalty))

                ;;
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                (wkda-pid:decimal (ref-SWPI::URC_TokenDollarPrice wkda-id kda-pid))
                (lkda-pid:decimal (ref-SWPI::URC_TokenDollarPrice lkda-id kda-pid))
                (ouro-pid:decimal (ref-SWPI::URC_OuroPrimordialPrice))
                ;;
                (five-percent-dollarz-as-kda:decimal (floor (/ five-percent-dollarz wkda-pid) wkda-prec))
                (env-split:[decimal] (UC_LaunchpadEnviromentSplit five-percent-dollarz-as-kda))
                ;;
                (type-pid:decimal 
                    (if (or (= type 0) (= type 1))
                        wkda-pid
                        (if (= type 2)
                            lkda-pid
                            ouro-pid
                        )
                    )
                )
                (type-prec:integer
                    (if (or (= type 0) (= type 1))
                        wkda-prec
                        (if (= type 2)
                            lkda-prec
                            ouro-prec
                        )
                    )
                )
            )
            (UDC_LaunchpadPrices
                ;;Enviroment Split with native KDA amounts
                (ref-DALOS::UR_AccountKadena (ref-DALOS::GOV|DALOS|SC_NAME))      ;;Gas-Station 10%
                (ref-DALOS::UR_AccountKadena (at 2 (ref-DALOS::UR_DemiurgoiID)))  ;;HOV 20%
                (ref-DALOS::UR_AccountKadena (at 1 (ref-DALOS::UR_DemiurgoiID)))  ;;CTO 30%
                (ref-DALOS::UR_AccountKadena (ref-DALOS::GOV|OUROBOROS|SC_NAME))  ;;Liquid Staking 40%
                (at 0 env-split)
                (at 1 env-split)
                (at 2 env-split)
                (at 3 env-split)
                ;;Total Enviroment Amount in native KDA
                five-percent-dollarz-as-kda
                ;;CodingDivision and Remainder Split in WKDA, LKDA or OURO, depending on <type>
                (floor (/ ten-percent-dollarz type-pid) type-prec)
                (floor (/ remainder-percent-dollarz type-pid) type-prec)
            )
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_AssetFungibility (asset-id:string fungibility-to-check:[bool])
        (let
            (
                (type:string (UC_Type asset-id fungibility-to-check))
                (fungibility:[bool] (UR_Fungibility asset-id))
            )
            (enforce (= fungibility fungibility-to-check) (format "ID {} fungibility as {} is invalid" [asset-id type]))
        )
    )
    (defun UEV_Fungibility (fungibility:[bool])
        (let
            (
                (l:integer (length fungibility))
            )
            (enforce (= l 2) "Invalid Fungibility variable")
        )
    )
    ;;{F3}  [UDC]
    (defun UDC_Costs:object{DemiourgosLaunchpad.Costs} 
        (a:decimal b:decimal)
        {"pid"  : a
        ,"wkda" : b}
    )
    (defun UDC_DEMIPAD|Holdings:object{DemiourgosLaunchpad.DEMIPAD|Holdings}
        (
            a:decimal b:decimal c:decimal d:decimal
            e:decimal f:decimal g:decimal
            h:bool i:bool
            j:[bool] k:bool l:object m:bool
        )
        {"total-dollarz-raised"         : a
        ,"total-wkda-raised"            : b
        ,"total-lkda-raised"            : c
        ,"total-ouro-raised"            : d
        ,"funds-wkda"                   : e
        ,"funds-lkda"                   : f
        ,"funds-ouro"                   : g
        ;;
        ,"iz-lkda"                      : h
        ,"iz-ouro"                      : i
        ;;
        ,"fungibility"                  : j
        ,"open-for-business"            : k
        ,"price"                        : l
        ,"retrieval"                    : m
        }
    )
    (defun UDC_LaunchpadPrices:object{DemiourgosLaunchpad.DEMIPAD|Prices}
        (
            a:string b:string c:string d:string
            e:decimal f:decimal g:decimal h:decimal
            j:decimal k:decimal l:decimal
        )
        {"receiver-one"         : a
        ,"receiver-two"         : b
        ,"receiver-three"       : c
        ,"receiver-four"        : d
        ,"amount-one"           : e
        ,"amount-two"           : f
        ,"amount-three"         : g
        ,"amount-four"          : h
        ,"enviroment-amount"    : j
        ,"coding-amount"        : k
        ,"remainder-amount"     : l}
    )
    ;;{F4}  [CAP]
    (defun CAP_Owner (asset-id:string)
        @doc "Enforces <asset-id> ownership \
        \ Automaticaly enforces <asset-id> is registered, via <UR_Fungibility>"
        (let
            (
                (fungibility:[bool] (UR_Fungibility asset-id))
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (cond
                ((= fungibility TF) (ref-DPTF::CAP_Owner asset-id))
                ((= fungibility OF) (ref-DPOF::CAP_Owner asset-id))
                ((= fungibility SF) (ref-DPDC::CAP_OwnerOrCreator asset-id true))
                ((= fungibility NF) (ref-DPDC::CAP_OwnerOrCreator asset-id false))
                true
            )
        )
    )
    ;;
    ;;{F5}  [A]
    (defun A_RegisterAssetToLaunchpad (patron:string asset-id:string fungibility:[bool])
        (UEV_IMC)
        (with-capability (DEMIPAD|C>REGISTER asset-id fungibility)
            (XI_RegisterAsset asset-id fungibility)
            (format "{} {} registered succesfuly to Demiourgos Launchpad!" [(UC_Type asset-id fungibility) asset-id])
        )
    )
    ;;
    (defun A_ToggleOpenForBusiness (asset-id:string toggle:bool)
        (UEV_IMC)
        (with-capability (DEMIPAD|C>TOGGLE-SALE asset-id toggle)
            (XI_U|OpenForBusiness asset-id toggle)
            (format "Asset {} sale succesfully toggled to {}" [asset-id toggle])
        )
    )
    (defun A_DefinePrice (asset-id:string price:object)
        (UEV_IMC)
        (with-capability (DEMIPAD|C>DEFINE-PRICE asset-id price)
            (XI_U|Price asset-id price)
            (format "Asset {} price succesfully updated with the Price Object {}" [asset-id price])
        )
    )
    (defun A_ToggleRetrieval (asset-id:string toggle:bool)
        (UEV_IMC)
        (with-capability (DEMIPAD|C>TOGGLE-RETRIEVAL asset-id toggle)
            (XI_U|Retrieval asset-id toggle)
            (format "Asset {} Retrieval succesfuly set to {}" [asset-id toggle])
        )
    )
    ;;{F6}  [C]
    (defun C_Deposit:object{IgnisCollector.OutputCumulator}
        (donor:string asset-id:string amount-in-dollars:decimal type:integer direct-injection:bool)
        @doc "Deposits Funds into the Launchpad, for a registered Asset \
            \ Type 0 = Native Kadena \
            \ Type 1 = WKDA \
            \ Type 2 = LKDA \
            \ Type 3 = OURO \
            \ \
            \ Outputs: \
            \ <type 0> = KDA Split ENV + WKDA for CD (needs wrapping) + WKDA for Sale (needs wrapping) \
            \ <type 1> = KDA Split ENV (needs unwrapping) + WKDA for CD + WKDA for Sale \
            \ <type 2> = KDA Split ENV + LKDA for CD + LKDA for Sale \
            \ <type 3> = KDA Split ENV + OURO for CD + OURO for Sale "
        (UEV_IMC)
        (with-capability (DEMIPAD|C>DEPOSIT donor asset-id amount-in-dollars type direct-injection)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV5} DALOS)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    (ref-LIQUID:module{KadenaLiquidStakingV5} LIQUID)
                    ;;
                    (prices:object{DemiourgosLaunchpad.DEMIPAD|Prices}  (URC_Prices asset-id amount-in-dollars type))
                    (working-id:string
                        (if (or (= type 0) (= type 1))
                            (ref-DALOS::UR_WrappedKadenaID)
                            (if (= type 2)
                                (ref-DALOS::UR_LiquidKadenaID)
                                (ref-DALOS::UR_OuroborosID)
                            )
                        )
                    )
                    ;;
                    (env:decimal (at "enviroment-amount" prices))
                    (cod:decimal (at "coding-amount" prices))
                    (rem:decimal (at "remainder-amount" prices))
                    ;;
                    (ico1:object{IgnisCollector.OutputCumulator}
                        (if (= type 1)
                            (ref-LIQUID::C_UnwrapKadena donor env)
                            EOC
                        )
                    )
                    (ico2:object{IgnisCollector.OutputCumulator}
                        (if (not direct-injection)
                            (ref-TFT::C_Transfer working-id donor DEMIPAD|SC_NAME (+ cod rem) true)
                            EOC
                            ;;When AQP LIVE, to be replaced by:
                            ;;(ref-AQP::C_Inject <pool-id> <working-id> <cod> <injection-type>)
                            ;;(ref-TFT::C_Transfer working-id donor DEMIPAD|SC_NAME rem true)
                        )
                    )
                )
                ;;1]Satisfy Enviroment (Kadena was Unwraped prior if <type> = 1)
                (XI_SatisfyEnviroment donor prices)
                ;;2]Update Internal Launchpad with deposit Data
                    ;;2.1]When (not direct-injection) save <cod> amount in Launchpad Properties
                (if (not direct-injection)
                    ;;Update Resident Amounts in DEMIPAD|Properties (they may be later injected to Acquisition Pool)
                    (XI_DepositResidents prices type)
                    true
                )
                    ;;2.2]Save <rem> in <DEMIPAD|T|Ledger> (so that it may be withdrawed by Asset Seller)
                (XI_DepositForAsset asset-id amount-in-dollars rem type)
                ;;3]Output Cumulator
                (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2] [])
            )
        )
    )
    (defun C_Withdraw
        (patron:string asset-id:string type:integer destination:string)
        @doc "Withdraws all cumulated Tokens in the Launchpad, gathered through sale \
        \ Type 1 = WKDA \
        \ Type 2 = LKDA \
        \ Type 3 = OURO "
        (UEV_IMC)
        (let
            (
                (retrieval-amount:decimal (UR_Funds asset-id type))
            )
            (with-capability (DEMIPAD|C>WITHDRAW asset-id type retrieval-amount destination)
                (let
                    (
                        (ref-DALOS:module{OuronetDalosV5} DALOS)
                        (ref-TS01-C1:module{TalosStageOne_ClientOneV5} TS01-C1)
                        (working-id:string
                            (if (= type 1)
                                (ref-DALOS::UR_WrappedKadenaID)
                                (if (= type 2)
                                    (ref-DALOS::UR_LiquidKadenaID)
                                    (ref-DALOS::UR_OuroborosID)
                                )
                            )
                        )
                    )
                    ;;1]Withdraw Tokens to Destination
                    (ref-TS01-C1::DPTF|C_Transfer patron working-id DEMIPAD|SC_NAME destination retrieval-amount true)
                    ;;2]Reset Holdings to 0.0 after withdrawal
                    (XI_U|Funds asset-id 0.0 type)
                )
            )
        )
    )
    ;;Fuel|Retrieve Assets to|from Launchpad to be made after Upgrade.
    (defun C_TransmitTrueFungible (patron:string client:string asset-id:string amount:decimal fuel-or-retrieve:bool)
        (UEV_IMC)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-TS01-C1:module{TalosStageOne_ClientOneV5} TS01-C1)
                (lpad:string DEMIPAD|SC_NAME)
                (sa-s:string (ref-I|OURONET::OI|UC_ShortAccount client))
            )
            (if fuel-or-retrieve
                (with-capability (DEMIPAD|C>FUEL-TRUE-FUNGIBLE asset-id)
                    (ref-TS01-C1::DPTF|C_Transfer patron asset-id client lpad amount true)
                    (format "Succesfuly fueled {} {} to Demiourgos Launchpad from Account {}" [amount asset-id sa-s])
                )
                (with-capability (DEMIPAD|C>RETRIEVE-TRUE-FUNGIBLE asset-id)
                    (ref-TS01-C1::DPTF|C_Transfer patron asset-id lpad client amount true)
                    (format "Succesfuly retrieved {} {} from Demiourgos Launchpad to Account {}" [amount asset-id sa-s])
                )
            )
        )
    )
    (defun C_TransmitOrtoFungible (patron:string client:string asset-id:string nonces:[integer] fuel-or-retrieve:bool)
        (UEV_IMC)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-TS01-C1:module{TalosStageOne_ClientOneV5} TS01-C1)
                (lpad:string DEMIPAD|SC_NAME)
                (sa-s:string (ref-I|OURONET::OI|UC_ShortAccount client))
            )
            (if fuel-or-retrieve
                (with-capability (DEMIPAD|C>FUEL-ORTO-FUNGIBLE asset-id)
                    (ref-TS01-C1::DPOF|C_Transfer patron asset-id nonces client lpad true)
                    (format "Succesfuly fueled {} Nonces {} to Demiourgos Launchpad from Account {}" [asset-id nonces sa-s])
                )
                (with-capability (DEMIPAD|C>RETRIEVE-ORTO-FUNGIBLE asset-id)
                    (ref-TS01-C1::DPOF|C_Transfer patron asset-id nonces lpad client true)
                    (format "Succesfuly retrieved {} Nonces {} from Demiourgos Launchpad to Account {}" [asset-id nonces sa-s])
                )
            )
        )
    )
    (defun C_TransmitSemiFungibles:object{IgnisCollectorV2.OutputCumulator}
        (client:string asset-id:string nonces:[integer] amounts:[integer] fuel-or-retrieve:bool)
        (UEV_IMC)
        (with-capability (P|SECURE-CALLER)
            (X_TransmitCollectables client asset-id true nonces amounts fuel-or-retrieve)
        )
    )
    (defun C_TransmitNonFungibles:object{IgnisCollectorV2.OutputCumulator}
        (client:string asset-id:string nonces:[integer] amounts:[integer] fuel-or-retrieve:bool)
        (UEV_IMC)
        (with-capability (P|SECURE-CALLER)
            (X_TransmitCollectables client asset-id false nonces amounts fuel-or-retrieve)
        )
    )
    ;;
    ;;{F7}  [X]
    ;;
    (defun XI_RegisterAsset (asset-id:string fungibility:[bool])
        (require-capability (SECURE))
        (insert DEMIPAD|T|Ledger asset-id 
            (UDC_DEMIPAD|Holdings 
                0.0 0.0 0.0 0.0
                0.0 0.0 0.0
                false false
                fungibility false {} false
            )
        )
    )
    (defun XI_U|TotalDollarzRaised (asset-id:string value:decimal)
        (require-capability (SECURE))
        (update DEMIPAD|T|Ledger asset-id {"total-dollarz-raised" : value})
    )
    (defun XI_U|TotalRaised (asset-id:string value:decimal type:integer)
        (cond
            ((= type 1) (XI_U|TotalWKDARaised asset-id value))
            ((= type 2) (XI_U|TotalLKDARaised asset-id value))
            ((= type 3) (XI_U|TotalOURORaised asset-id value))
            true
        )
    )
    (defun XI_U|Funds (asset-id:string value:decimal type:integer)
        (cond
            ((= type 1) (XI_U|FundsWKDA asset-id value))
            ((= type 2) (XI_U|FundsLKDA asset-id value))
            ((= type 3) (XI_U|FundsOURO asset-id value))
            true
        )
    )
    (defun XI_U|TotalWKDARaised (asset-id:string value:decimal)
        (require-capability (SECURE))
        (update DEMIPAD|T|Ledger asset-id {"total-wkda-raised" : value})
    )
    (defun XI_U|TotalLKDARaised (asset-id:string value:decimal)
        (require-capability (SECURE))
        (update DEMIPAD|T|Ledger asset-id {"total-lkda-raised" : value})
    )
    (defun XI_U|TotalOURORaised (asset-id:string value:decimal)
        (require-capability (SECURE))
        (update DEMIPAD|T|Ledger asset-id {"total-ouro-raised" : value})
    )
    
    (defun XI_U|FundsWKDA (asset-id:string value:decimal)
        (require-capability (SECURE))
        (update DEMIPAD|T|Ledger asset-id {"funds-wkda" : value})
    )
    (defun XI_U|FundsLKDA (asset-id:string value:decimal)
        (require-capability (SECURE))
        (update DEMIPAD|T|Ledger asset-id {"funds-lkda" : value})
    )
    (defun XI_U|FundsOURO (asset-id:string value:decimal)
        (require-capability (SECURE))
        (update DEMIPAD|T|Ledger asset-id {"funds-ouro" : value})
    )
    ;;
    (defun XI_U|OpenForBusiness (asset-id:string toggle:bool)
        (require-capability (SECURE))
        (update DEMIPAD|T|Ledger asset-id {"open-for-business" : toggle})
    )
    (defun XI_U|Price (asset-id:string price:object)
        (require-capability (SECURE))
        (update DEMIPAD|T|Ledger asset-id {"price" : price})
    )
    (defun XI_U|Retrieval (asset-id:string retrieval:bool)
        (require-capability (SECURE))
        (update DEMIPAD|T|Ledger asset-id {"retrieval" : retrieval})
    )
    ;;
    (defun XI_W|DirectInjection (value:decimal)
        (require-capability (SECURE))
        (update DEMIPAD|T|Properties PP {"direct-injection" : value})
    )
    (defun XI_U|WKDA (value:decimal)
        (require-capability (SECURE))
        (update DEMIPAD|T|Properties PP {"resident-wkda" : value})
    )
    (defun XI_U|LKDA (value:decimal)
        (require-capability (SECURE))
        (update DEMIPAD|T|Properties PP {"resident-lkda" : value})
    )
    (defun XI_U|OURO (value:decimal)
        (require-capability (SECURE))
        (update DEMIPAD|T|Properties PP {"resident-ouro" : value})
    )
    ;;
    (defun XI_SatisfyEnviroment (donor:string prices:object{DemiourgosLaunchpad.DEMIPAD|Prices})
        (require-capability (SECURE))
        (let
            (
                (ref-coin:module{fungible-v2} coin)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                ;;
                (donor-kda:string (ref-DALOS::UR_AccountKadena donor))
            )
            (ref-coin::transfer donor-kda (at "receiver-one" prices)    (at "amount-one" prices))       ;;for GasStation
            (ref-coin::transfer donor-kda (at "receiver-two" prices)    (at "amount-two" prices))       ;;for HOV
            (ref-coin::transfer donor-kda (at "receiver-three" prices)  (at "amount-three" prices))     ;;for CTO
            (ref-coin::transfer donor-kda (at "receiver-four" prices)   (at "amount-four" prices))      ;;for LQ-St
        )
    )
    (defun XI_DepositResidents (prices:object{DemiourgosLaunchpad.DEMIPAD|Prices} type:integer)
        (require-capability (SECURE))
        (with-capability (SECURE)
            (if (or (= type 0) (= type 1))
                (XI_U|WKDA (at "coding-amount" prices))
                (if (= type 2)
                    (XI_U|LKDA (at "coding-amount" prices))
                    (XI_U|OURO (at "coding-amount" prices))
                )
            )
        ) 
    )
    (defun XI_DepositForAsset 
        (asset-id:string amount-in-dollars:decimal remainder:decimal type:integer)
        (XI_U|TotalDollarzRaised asset-id (+ (UR_TotalDollarzRaised asset-id) amount-in-dollars))
        (XI_U|TotalRaised asset-id (+ remainder (UR_TotalRaised asset-id type)) type)
        (XI_U|Funds asset-id (+ remainder (UR_Funds asset-id type)) type)
    )
    ;;
    (defun X_TransmitCollectables:object{IgnisCollectorV2.OutputCumulator}
        (client:string asset-id:string son:bool nonces:[integer] amounts:[integer] fuel-or-retrieve:bool)
        (require-capability (SECURE))
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-DPDC-T:module{DpdcTransfer} DPDC-T)
                (lpad:string DEMIPAD|SC_NAME)
                (sa-s:string (ref-I|OURONET::OI|UC_ShortAccount client))
            )
            (if fuel-or-retrieve
                (with-capability (DEMIPAD|C>FUEL-SEMI-FUNGIBLE asset-id)
                    (ref-DPDC-T::C_Transfer asset-id son client lpad nonces amounts true)
                )
                (with-capability (DEMIPAD|C>RETRIEVE-SEMI-FUNGIBLE asset-id)
                    (ref-DPDC-T::C_Transfer asset-id son lpad client nonces amounts true)
                )
            )
        )
    )
    
)

(create-table P|T)
(create-table P|MT)
(create-table DEMIPAD|T|Ledger)
(create-table DEMIPAD|T|Properties)