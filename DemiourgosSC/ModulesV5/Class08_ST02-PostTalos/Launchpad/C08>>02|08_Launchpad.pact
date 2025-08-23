(interface Launchpad
    (defschema LAUNCHPAD|Holdings
        total-wkda-sales:decimal
        current-wkda-sale-holdings:decimal
        fungibility:[bool]
        open-for-business:bool
        price:object
        retrieval:bool
    )
    ;;
    (defun GOV|LAUNCHPAD|SC_NAME ())
    (defun LAUNCHPAD|SetGovernor (patron:string))
    ;;
    ;;
    (defun UC_Type:string (asset-id:string fungibility:[bool] validation:bool))
    (defun UC_LaunchpadSplit:[decimal] (wkda-amount:decimal))
    (defun UC_LiquidSplit:[decimal] (lkda-amount:decimal))
    ;;
    ;;  [UR]
    ;;
    (defun UR_Total:decimal (asset-id:string))
    (defun UR_Holdings:decimal (asset-id:string))
    (defun UR_Fungibility:[bool] (asset-id:string))
    (defun UR_OpenForBusiness:bool (asset-id:string))
    (defun UR_Price:object (asset-id:string))
    (defun UR_Retrieval:bool (asset-id:string))
    (defun UR_CheckRegistration:bool (asset-id:string))
    ;;
    ;;  [URC]
    ;;
    (defun URC_BeneficiaryAccount:string (asset-id:string))
    (defun URC_AssetGuard:guard (asset-id:string fungibility:[bool] validation:bool))
    (defun URC_CollectibleGuard (asset-id:string son:bool))
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_FungibilityCheck (asset-id:string fungibility-to-check:[bool]))
    (defun UEV_ConditionalFungibility (fungibility:[bool] validation:bool))
    (defun UEV_Fungibility (fungibility:[bool]))
    (defun UEV_AssetOwnership (asset-id:string fungibility:[bool] validation:bool))
    ;;
    ;;  [UDC]
    ;;
    (defun UDC_LAUNCHPAD|Holdings (a:decimal b:decimal c:[bool] d:bool e:object f:bool))
    ;;
    ;;  [A]
    ;;
    (defun A_RegisterAssetToLaunchpad (patron:string asset-id:string fungibility:[bool]))
    (defun A_ToggleOpenForBusiness (asset-id:string toggle:bool))
    (defun A_DefinePrice (asset-id:string price:object))
    (defun A_ToggleRetrieval (asset-id:string toggle:bool))
    (defun A_Collect (patron:string asset-id:string))
    ;;
    ;;  [C]
    ;;
    (defun C_DeployLpadAccount (patron:string asset-id:string fungibility:[bool]))
    ;;
    (defun C_FuelTrueFungible (patron:string sender:string asset-id:string amount:decimal))
    (defun C_FuelMetaFungible (patron:string sender:string asset-id:string nonce:integer))
    (defun C_FuelSemiFungible (patron:string sender:string asset-id:string nonce:integer amount:integer))
    (defun C_FuelNonFungible (patron:string sender:string asset-id:string nonce:integer amount:integer))
    ;;
    (defun C_Withdraw (patron:string asset-id:string))
    ;;
    ;;  [X]
    ;;
    (defun XE_RegisterSale (asset-id:string wkda-amount:decimal))
)
(module LAUNCHPAD GOV
    @doc "Demiourgos Launchpad, is a permissioned Launchpad operated by Demiourgos.Holdings  \
        \ allowing the Company to sell Assets (DPTFs, DPMFs, DPSFs and DPNFs) \
        \ \
        \ HOW IT WORKS: \
        \ The Launchpad Admin registers an Asset for Sale, this Asset is then Permanently registered to the Launchpad \
        \ Sale is executed via Functions, in Modules created by Demiourgos Holdings, specific to each Asset \
        \ \
        \ The Launchpad retains the amount of WKDA each Asset has sold for in total, and the current WKDA holdings for a given Asset. \
        \ Either the Launchpad Admin (all Assets) or the Asset Owner (True and Meta-Fungibles) or Asset Creator (Semi and Non-Fungibles) can withdraw the WKDA Funds. \
        \ 10% of Funds are retained by the Launchpad, and withdrawal is executed towards the Asset Owner (True and Meta-Fungibles) or Asset Creator (Semi and Non-Fungibles) \
        \ \
        \ Launchpad Admin can update <open-for-business>, <price> and <retrieval> for each registered Asset \
        \ \
        \ <open-for-business> determines if the Asset is on sale and if it can be bought by those that want to acquire it \
        \ The <price> object holds information regarding the Sale Price. This is then used by the Individual Asset Modules in the Sale Function \
        \ The <retrieval> parameter defines if Asset Owners or Creators can withdraw their Assets from the Launchpad (default false) \
        \       If set to <false> the only way to retrieve Assets is to buy them. \
        \ \
        \ Each Asset has its own Sale Module, that defines the logic of the Buy Functions, allowing for individual custom logic to be implemented for each Sale \
        \ Which is the reason this is a permissioned Launchpad, as each Sale can have its own specific logic regarding Asset Acquisition"
    ;;
    (implements OuronetPolicy)
    (implements Launchpad)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_LAUNCHPAD              (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    (defconst LAUNCHPAD|SC_KEY              (GOV|LaunchpadKey))
    (defconst LAUNCHPAD|SC_NAME             (GOV|LAUNCHPAD|SC_NAME))
    (defconst MB|SC_KDA-NAME                "k:35d7f82a7754d10fc1128d199aadb51cb1461f0eb52f4fa89790a44434f12ed8")
    ;;Mainnet ==>                            k:2d4c9cd8d1bd30d9156b65c1259d2be9689f068927d8fee19bfb695619436e01
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|LAUNCHPAD_ADMIN)))
    (defcap GOV|LAUNCHPAD_ADMIN ()          (enforce-guard GOV|MD_LAUNCHPAD))
    (defcap LAUNCHPAD|GOV ()
        @doc "Governor Capability for the LAUNCHPAD Smart DALOS Account"
        true
    )
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;; [Keys]
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|LaunchpadKey ()              (+ (GOV|NS_Use) ".dh_sc_mb-keyset"))
    ;;
    ;; [SC-Names]
    (defun GOV|LAUNCHPAD|SC_NAME ()         (at 0 ["Σ.Îäć$ЬчýφVεÎÿůпΨÖůηüηŞйnюŽXΣşpЩß5ςĂκ£RäbE₳èËłŹŘYшÆgлoюýRαѺÑÏρζt∇ŹÏýжIŒațэVÞÛщŹЭδźvëȘĂтPЖÃÇЭiërđÈÝДÖšжzČđзUĚĂsкιnãñOÔIKпŞΛI₳zÄû$ρśθ6ΨЬпYпĞHöÝйÏюşí2ćщÞΔΔŻTж€₿ŞhTțŽ"]))
    ;;
    (defun LAUNCHPAD|SetGovernor (patron:string)
        (with-capability (P|LAUNCHPAD|CALLER)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-U|G:module{OuronetGuards} U|G)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-DALOS::C_RotateGovernor
                            LAUNCHPAD|SC_NAME
                            (ref-U|G::UEV_GuardOfAny
                                [
                                    (create-capability-guard (LAUNCHPAD|GOV))
                                    (P|UR "PAD-SH|RemoteGov")
                                    (P|UR "PAD-CUSTODIANS|RemoteGov")
                                ]
                            )
                        )
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
            )
        )
    )
    ;; [PBLs]
    (defun GOV|LAUNCHPAD|PBL ()             (at 0 ["9F.gGCkuc2wMAnFAjuFphikftLdl6qFqBD4yfeMEe9u65yMqf4r340Jd6dphh1d7E1cE20btMwl4HJ2cBEMvp209GA1eD4syB96hu4nmpFbB7dKnJEMz4p8fGLcmhvrBCfDmM0axnGin8qedl5vDtwbgL3l1aK5BsmjkEEJartqCH8qG8ialtjxwCcIMf50t2lkeww6Dct5LlmmLG25FmfpcgnwMMnkJl4Gfn9gwoA6vm0jKebjhodeJLjxnh9L11ss8f26866dqv1tEphxFFqutGetH4Itj3rHkrcrGsnlqpf4gfJp94b0gBwIBe4vCj6ha8jm6kd3f8B6pEaJtkJ3fbs6rCcGibltz1BAMn0vvKME5ddFyGBnzssk1s2s0vFzwxs6vjC61Ma2l1xDxqdg1thAk2u01hDiGndLhzK73HAfgtk7bxscn0qKhymG6JAqnEFt282pyHAq5nIthK9bA8nH76x7FEpLz4eK9tLIBsyjb8M5DxaeEei6pEnLxFCAg7ulacgtjjpjMiAaqhpmM1jEHqjt4G85q4L33zrME7whgIkIpIgwnF2qKd4"]))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|LAUNCHPAD|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|LAUNCHPAD|CALLER))
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
        (with-capability (GOV|LAUNCHPAD_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|LAUNCHPAD_ADMIN)
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
                (ref-P|DPDC:module{OuronetPolicy} DPDC)
                (mg:guard (create-capability-guard (P|LAUNCHPAD|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|DPDC::P|A_AddIMP mg)
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
    (deftable LAUNCHPAD|T|Ledger:{Launchpad.LAUNCHPAD|Holdings})
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    (defconst TF                    [true true])
    (defconst MF                    [true false])
    (defconst SF                    [false true])
    (defconst NF                    [false false])
    ;;
    (defconst DCTO                  "Ѻ.CЭΞŸNGúůρhãmИΘÛ¢₳šШдìAÚwŚGýηЗПAÊУÔȘřŽÍζЗηmΔφDmcдΛъ₳tĂýăŮsПÞ$öœGθeBŽvąαÃfçл¢ĎĆď$şbsЦэΘNÄëÍĂνуãöž¥àZjÆůšÁœôñχŽâЩåτâн4μфAOçĎΓuЗŮnøЙãĚè6Дżîþż$цÑûρψŻïZÉλûæřΨeèÎígςeL")
    (defconst DHOV                  "Ѻ.ÍăüÙÜЦżΦF₿ÈшÕóñĐĞGюѺλωÇțnθòoйEςк₱0дş3ôPpxŞțqgЖ€šωbэočΞìČ5òżŁdŒИöùЪøŤяжλзÜ2ßżpĄγïčѺöэěτČэεSčDõžЩУЧÀ₳ŚàЪЙĎpЗΣ2ÃлτíČнÙyéÕãďWŹŘĘźσПåbã€éѺι€ΓφŠ₱ŽyWcy5ŘòmČ₿nβÁ¢¥NЙëOι")
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
    (defcap LAUNCHPAD|C>SECURE-ADMIN ()
        (compose-capability (GOV|LAUNCHPAD_ADMIN))
        (compose-capability (SECURE))
    )
    ;;
    (defcap LAUNCHPAD|C>REGISTER (asset-id:string fungibility:[bool])
        @event
        (UEV_Fungibility fungibility)
        (compose-capability (LAUNCHPAD|C>SECURE-ADMIN))
    )
    ;;
    (defcap LAUNCHPAD|C>TOGGLE-SALE (asset-id:string toggle:bool)
        @event
        (let
            (
                (ofb:bool (UR_OpenForBusiness asset-id))
            )
            (enforce (!= toggle ofb) (format "Open for business is already {} for Asset {}" [toggle asset-id]))
            (compose-capability (LAUNCHPAD|C>SECURE-ADMIN))
        )
    )
    (defcap LAUNCHPAD|C>DEFINE-PRICE (asset-id:string price:object)
        @event
        (compose-capability (LAUNCHPAD|C>SECURE-ADMIN))
    )
    (defcap LAUNCHPAD|C>TOGGLE-RETRIEVAL (asset-id:string toggle:bool)
        @event
        (let
            (
                (rtr:bool (UR_Retrieval asset-id))
            )
            (enforce (!= toggle rtr) (format "Retrieval is already {} for Asset {}" [toggle asset-id]))
            (compose-capability (LAUNCHPAD|C>SECURE-ADMIN))
        )
    )
    ;;
    (defcap LAUNCHPAD|C>FUEL-TRUE-FUNGIBLE (asset-id:string)
        @event
        (compose-capability (LAUNCHPAD|C>FUNGIBLE-ACCES asset-id [true true]))
    )
    (defcap LAUNCHPAD|C>FUEL-META-FUNGIBLE (asset-id:string)
        @event
        (compose-capability (LAUNCHPAD|C>FUNGIBLE-ACCES asset-id [true false]))
    )
    (defcap LAUNCHPAD|C>FUEL-SEMI-FUNGIBLE (asset-id:string)
        @event
        (compose-capability (LAUNCHPAD|C>FUNGIBLE-ACCES asset-id [false true]))
    )
    (defcap LAUNCHPAD|C>FUEL-NON-FUNGIBLE (asset-id:string)
        @event
        (compose-capability (LAUNCHPAD|C>FUNGIBLE-ACCES asset-id [false false]))
    )
    ;;
    (defcap LAUNCHPAD|C>FUNGIBLE-ACCES (asset-id:string fungibility:[bool])
        (compose-capability (LAUNCHPAD|C>REGISTERED-ACCES asset-id))
        (UEV_FungibilityCheck asset-id fungibility)
    )
    (defcap LAUNCHPAD|C>REGISTERED-ACCES (asset-id:string)
        (compose-capability (LAUNCHPAD|C>IZ-REGISTERED asset-id))
        (compose-capability (LAUNCHPAD|C>ACCESS asset-id))
    )
    (defcap LAUNCHPAD|C>IZ-REGISTERED (asset-id:string)
        (let
            (
                (iz-registered:bool (UR_CheckRegistration asset-id))
            )
            ;;1]Asset must be registered to launchpad
            (enforce iz-registered (format "ID {} is not a Demiourgos Launchpad registered Asset" [asset-id]))
        )
    )
    (defcap LAUNCHPAD|C>ACCESS (asset-id:string)
        (let
            (
                (fungibility:[bool] (UR_Fungibility asset-id))
                (type:string (UC_Type asset-id fungibility false))
                (asset-id-guard:guard (URC_AssetGuard asset-id fungibility true))
            )
            ;;1]Either asset-id owner or lpad administrator can fuel the launchpad with the asset
            (enforce-one
                (format "Only LPAD Admin or {} Owner may Fuel the Launchpad with the {}" [asset-id type])
                [
                    (enforce-guard asset-id-guard)
                    (enforce-guard GOV|MD_LAUNCHPAD)
                ]
            )
            ;;2]Compose LPAD Ownership to allow transfer to the LPAD Smart Ouronet Account
            ;;Composes a capability that is used as Guard set up as LPAD Governor
            (compose-capability (LAUNCHPAD|GOV))
        )
    )
    ;;
    (defcap LAUNCHPAD|C>SALE (asset-id:string wkda-amount:decimal)
        @event
        (compose-capability (SECURE))
    )
    ;;needs redone
    (defcap LAUNCHPAD|C>WITHDRAWAL (asset-id:string admin-mode:bool)
        @event
        (if admin-mode
            (enforce-guard GOV|MD_LAUNCHPAD)
            true
        )
        (compose-capability (SECURE))
        (compose-capability (LAUNCHPAD|C>REGISTERED-ACCES asset-id))
    )
    ;;
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_Type:string (asset-id:string fungibility:[bool] validation:bool)
        (UEV_ConditionalFungibility fungibility validation)
        (cond
            ((= fungibility TF) "True Fungible")
            ((= fungibility MF) "Meta-Fungible")
            ((= fungibility SF) "Semi-Fungible")
            ((= fungibility NF) "Non-Fungible")
            ""
        )
    )
    (defun UC_LaunchpadSplit:[decimal] (wkda-amount:decimal)
        @doc "Split a WKDA Amount using the LaunchpadSplit \
            \ Outputs 4 values [90% 5% 2.5% 2.5%] \
            \ All amounts added up will sum to the input amount"
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                (wkda-prec:integer (ref-DPTF::UR_Decimals wkda-id))
                ;;
                ;;2.5%
                (v1:decimal (floor (/ wkda-amount 40.0) wkda-prec))
                (v2:decimal (* v1 2.0))
                (v3:decimal (- wkda-amount (fold (+) 0.0 [v1 v1 v2])))
            )
            [v3 v2 v1 v1]
        )
    )
    (defun UC_LiquidSplit:[decimal] (lkda-amount:decimal)
        @doc "Split an LKDA amount into two equal parts, that when summed up, equal the input"
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (lkda-id:string (ref-DALOS::UR_LiquidKadenaID))
                (lkda-prec:integer (ref-DPTF::UR_Decimals lkda-id))
                (v1:decimal (floor (/ lkda-amount 2.0) lkda-prec))
                (v2:decimal (- lkda-amount v1))
            )
            [v1 v2]
        )
    )
    ;;{F0}  [UR]
    (defun UR_Total:decimal (asset-id:string)
        (at "total-wkda-sales" (read LAUNCHPAD|T|Ledger asset-id ["total-wkda-sales"]))
    )
    (defun UR_Holdings:decimal (asset-id:string)
        (at "current-wkda-sale-holdings" (read LAUNCHPAD|T|Ledger asset-id ["current-wkda-sale-holdings"]))
    )
    (defun UR_Fungibility:[bool] (asset-id:string)
        (at "fungibility" (read LAUNCHPAD|T|Ledger asset-id ["fungibility"]))
    )
    (defun UR_OpenForBusiness:bool (asset-id:string)
        (at "open-for-business" (read LAUNCHPAD|T|Ledger asset-id ["open-for-business"]))
    )
    (defun UR_Price:object (asset-id:string)
        (at "price" (read LAUNCHPAD|T|Ledger asset-id ["price"]))
    )
    (defun UR_Retrieval:bool (asset-id:string)
        (at "retrieval" (read LAUNCHPAD|T|Ledger asset-id ["retrieval"]))
    )
    ;;
    (defun UR_CheckRegistration:bool (asset-id:string)
        (try
            false
            (with-read LAUNCHPAD|T|Ledger asset-id 
                { "total-wkda-sales" := dummy }
                true
            )
        )
    )
    ;;{F1}  [URC]
    (defun URC_BeneficiaryAccount:string (asset-id:string)
        @doc "Returns the Asset Beneficiary Account. It is the Owner for True and Meta-F \
            \ and Collection-Owner for Semi and Non-Fungibles"
        (let
            (
                (fungibility:[bool] (UR_Fungibility asset-id))
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (if (= fungibility TF)
                ;;DPTF
                (ref-DPTF::UR_Konto asset-id)
                (if (= fungibility SF)
                    ;;DPSF
                    (ref-DPDC::UR_CreatorKonto asset-id true)
                    (if (= fungibility NF)
                        ;;DPNF
                        (ref-DPDC::UR_CreatorKonto asset-id false)
                        ;;DPMF
                        (ref-DPMF::UR_Konto asset-id)
                    )
                )
            )
        )
    )
    (defun URC_AssetGuard:guard (asset-id:string fungibility:[bool] validation:bool)
        @doc "Returns the guard of the asset-id owner for TF and MF \
        \ or a composed guard owner and creator for SF and NF"
        (UEV_ConditionalFungibility fungibility validation)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
            )
            (if (= fungibility TF)
                ;;DPTF
                (ref-DALOS::UR_AccountGuard (ref-DPTF::UR_Konto asset-id))
                (if (= fungibility SF)
                    ;;DPSF
                    (URC_CollectibleGuard asset-id true)
                    (if (= fungibility NF)
                        ;;DPNF
                        (URC_CollectibleGuard asset-id false)
                        ;;DPMF
                        (ref-DALOS::UR_AccountGuard (ref-DPMF::UR_Konto asset-id))
                    )
                )
            )
        )
    )
    (defun URC_CollectibleGuard (asset-id:string son:bool)
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (if son
                (ref-U|G::UEV_GuardOfAny
                    [
                        (ref-DALOS::UR_AccountGuard (ref-DPDC::UR_OwnerKonto asset-id true))
                        (ref-DALOS::UR_AccountGuard (ref-DPDC::UR_CreatorKonto asset-id true))
                    ]
                )
                (ref-U|G::UEV_GuardOfAny
                    [
                        (ref-DALOS::UR_AccountGuard (ref-DPDC::UR_OwnerKonto asset-id false))
                        (ref-DALOS::UR_AccountGuard (ref-DPDC::UR_CreatorKonto asset-id false))
                    ]
                )
            )
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_FungibilityCheck (asset-id:string fungibility-to-check:[bool])
        (let
            (
                (type:string (UC_Type asset-id fungibility-to-check true))
                (fungibility:[bool] (UR_Fungibility asset-id))
            )
            (enforce (= fungibility fungibility-to-check) (format "ID {} fungibility as {} is invalid" [asset-id type]))
        )
    )
    (defun UEV_ConditionalFungibility (fungibility:[bool] validation:bool)
        (if validation
            (UEV_Fungibility fungibility)
            true
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
    (defun UEV_AssetOwnership (asset-id:string fungibility:[bool] validation:bool)
        (enforce-guard (URC_AssetGuard asset-id fungibility validation))
    )
    ;;{F3}  [UDC]
    (defun UDC_LAUNCHPAD|Holdings (a:decimal b:decimal c:[bool] d:bool e:object f:bool)
        {"total-wkda-sales"             : a
        ,"current-wkda-sale-holdings"   : b
        ,"fungibility"                  : c
        ,"open-for-business"            : d
        ,"price"                        : e
        ,"retrieval"                    : f
        }
    )
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
        (C_DeployLpadAccount patron asset-id fungibility)
        (with-capability (LAUNCHPAD|C>REGISTER asset-id fungibility)
            (XI_RegisterAsset asset-id fungibility)
            (format "{} {} registered succesfuly to Demiourgos Launchpad!" [(UC_Type asset-id fungibility false) asset-id])
        )
    )
    ;;
    (defun A_ToggleOpenForBusiness (asset-id:string toggle:bool)
        (with-capability (LAUNCHPAD|C>TOGGLE-SALE asset-id toggle)
            (XI_U|OpenForBusiness asset-id toggle)
            (format "Asset {} sale succesfully toggled to {}" [asset-id toggle])
        )
    )
    (defun A_DefinePrice (asset-id:string price:object)
        (with-capability (LAUNCHPAD|C>DEFINE-PRICE asset-id price)
            (XI_U|Price asset-id price)
            (format "Asset {} price succesfully updated with the Price Object {}" [asset-id price])
        )
    )
    (defun A_ToggleRetrieval (asset-id:string toggle:bool)
        (with-capability (LAUNCHPAD|C>TOGGLE-RETRIEVAL asset-id toggle)
            (XI_U|Retrieval asset-id toggle)
            (format "Asset {} Retrieval succesfuly set to {}" [asset-id toggle])
        )
    )
    (defun A_Collect (patron:string asset-id:string)
        @doc "Collect sale funds, can only be done by the Admin, with no prio coiling"
        (with-capability (LAUNCHPAD|C>WITHDRAWAL asset-id true)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                    (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                    ;;
                    (holdings:decimal (UR_Holdings asset-id))
                    (split:[decimal] (UC_LaunchpadSplit holdings))
                    (wkda-receiver:decimal (at 0 split))
                    (wkda-liquid:decimal (at 1 split))
                    (wkda-cto:decimal (at 2 split))
                    (wkda-hov:decimal (at 3 split))
                    ;;
                    (lpad:string LAUNCHPAD|SC_NAME)
                    (receiver:string (URC_BeneficiaryAccount asset-id))
                    ;;
                    (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                    (lkda-index:string (at 0 (ref-DPTF::UR_RewardToken wkda-id)))
                )
                ;;1]Fuel KadenaLiquidStaking with 5%
                (ref-TS01-C2::ATS|C_Fuel patron lpad lkda-index wkda-id wkda-liquid)
                ;;2]Transfer the Rest to the Beneficiaries
                (ref-TS01-C1::DPTF|C_BulkTransfer patron wkda-id lpad
                    [receiver DCTO DHOV]
                    [wkda-receiver wkda-cto wkda-hov]
                )
                ;;3]Update Holdings for <asset-id>
                (XI_U|Holdings asset-id 0.0)
            )
        )
    )
    ;;{F6}  [C]
    (defun C_DeployLpadAccount (patron:string asset-id:string fungibility:[bool])
        (let
            (
                (lpad:string LAUNCHPAD|SC_NAME)
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
            )
            (cond
                ((= fungibility TF) (ref-TS01-C1::DPTF|C_DeployAccount patron asset-id lpad))
                ((= fungibility MF) (ref-TS01-C1::DPMF|C_DeployAccount patron asset-id lpad))
                ((= fungibility SF) (ref-TS02-C1::DPSF|C_DeployAccount patron lpad asset-id))
                ((= fungibility NF) (ref-TS02-C2::DPNF|C_DeployAccount patron lpad asset-id))
                true
            )
        )
    )
    ;;Fuel Assets for Sale
    (defun C_FuelTrueFungible (patron:string sender:string asset-id:string amount:decimal)
        (with-capability (LAUNCHPAD|C>FUEL-TRUE-FUNGIBLE asset-id)
            (let
                (
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                    (lpad:string LAUNCHPAD|SC_NAME)
                    (sa-s:string (ref-I|OURONET::OI|UC_ShortAccount sender))
                )
                ;;1]Transfer <asset-id> with <amount> to <lpad>
                (ref-TS01-C1::DPTF|C_Transfer patron asset-id sender lpad amount true)
                (format "Succesfuly fuelled {} {} to Demiourgos Launchpad from Sender {}" [amount asset-id sa-s])
            )
        )
    )
    (defun C_FuelMetaFungible (patron:string sender:string asset-id:string nonce:integer)
        @doc "Can only fuel the Launchpad with a complete nonce"
        (with-capability (LAUNCHPAD|C>FUEL-META-FUNGIBLE asset-id)
            (let
                (
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                    (lpad:string LAUNCHPAD|SC_NAME)
                    (sa-s:string (ref-I|OURONET::OI|UC_ShortAccount sender))
                )
                ;;1]Transfer <asset-id> with <amount> to <lpad>
                (ref-TS01-C1::DPMF|C_SingleBatchTransfer patron asset-id nonce sender lpad true)
                (format "Succesfuly fuelled {} Nonce {} to Demiourgos Launchpad from Sender {}" [asset-id nonce sa-s])
            )
        )
    )
    (defun C_FuelSemiFungible (patron:string sender:string asset-id:string nonce:integer amount:integer)
        (with-capability (SECURE)
            (X_FuelCollectables patron sender asset-id nonce true amount)
        )
    )
    (defun C_FuelNonFungible (patron:string sender:string asset-id:string nonce:integer amount:integer)
        @doc "Amount is required becuase fueling with negative nonces is also allowed"
        (with-capability (SECURE)
            (X_FuelCollectables patron sender asset-id nonce false amount)
        )
    )
    ;;
    (defun C_Withdraw (patron:string asset-id:string)
        @doc "Collect sale funds, can only be done by both Admin and Asset Manager, with WKDA Coiling"
        (with-capability (LAUNCHPAD|C>WITHDRAWAL asset-id false)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                    (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                    ;;
                    (holdings:decimal (UR_Holdings asset-id))
                    (split:[decimal] (UC_LaunchpadSplit holdings))
                    (wkda-receiver:decimal (at 0 split))
                    (wkda-liquid:decimal (at 1 split))
                    (wkda-cto:decimal (at 2 split))
                    (wkda-hov:decimal (at 3 split))
                    (wkda-coil:decimal (+ wkda-cto wkda-hov))
                    ;;
                    (lpad:string LAUNCHPAD|SC_NAME)
                    (receiver:string (URC_BeneficiaryAccount asset-id))
                    ;;
                    (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                    (lkda-index:string (at 0 (ref-DPTF::UR_RewardToken wkda-id)))
                    (lkda-id:string (ref-DALOS::UR_LiquidKadenaID))
                    ;;
                    (coil-amount:decimal
                        ;;1]Coil 5% of WKDA to LKDA
                        (ref-TS01-C2::ATS|C_Coil patron lpad lkda-index wkda-id wkda-coil)
                    )
                    (split-two:[decimal] (UC_LiquidSplit coil-amount))
                    (lkda-cto:decimal (at 0 split-two))
                    (lkda-hov:decimal (at 1 split-two))
                )
                ;;2]Fuel KadenaLiquidStaking with 5% of WKDA
                (ref-TS01-C2::ATS|C_Fuel patron lpad lkda-index wkda-id wkda-liquid)
                ;;3]Transfer the 90% of WKDA to the <receiver>
                (ref-TS01-C1::DPTF|C_Transfer patron wkda-id lpad receiver wkda-receiver true)
                ;;4]Transfer LKDA to CTO and HOV
                (ref-TS01-C1::DPTF|C_BulkTransfer patron lkda-id lpad
                    [DCTO DHOV]
                    [lkda-cto lkda-hov]
                )
                ;;3]Update Holdings for <asset-id>
                (XI_U|Holdings asset-id 0.0)
            )
        )
    )
    ;;
    ;;{F7}  [X]
    (defun XE_RegisterSale (asset-id:string wkda-amount:decimal)
        (UEV_IMC)
        (with-capability (LAUNCHPAD|C>SALE asset-id wkda-amount)
            (let
                (
                    (total:decimal (UR_Total asset-id))
                    (holdings:decimal (UR_Holdings asset-id))
                )
                (XI_U|Total asset-id (+ total wkda-amount))
                (XI_U|Holdings asset-id (+ holdings wkda-amount))
            )
        )
    )
    ;;
    (defun XI_RegisterAsset (asset-id:string fungibility:[bool])
        (require-capability (SECURE))
        (insert LAUNCHPAD|T|Ledger asset-id (UDC_LAUNCHPAD|Holdings 0.0 0.0 fungibility false {} false))
    )
    (defun XI_U|Total (asset-id:string total-value:decimal)
        (require-capability (SECURE))
        (update LAUNCHPAD|T|Ledger asset-id {"total-wkda-sales" : total-value})
    )
    (defun XI_U|Holdings (asset-id:string holdings-value:decimal)
        (require-capability (SECURE))
        (update LAUNCHPAD|T|Ledger asset-id {"current-wkda-sale-holdings" : holdings-value})
    )
    (defun XI_U|OpenForBusiness (asset-id:string toggle:bool)
        (require-capability (SECURE))
        (update LAUNCHPAD|T|Ledger asset-id {"open-for-business" : toggle})
    )
    (defun XI_U|Price (asset-id:string price:object)
        (require-capability (SECURE))
        (update LAUNCHPAD|T|Ledger asset-id {"price" : price})
    )
    (defun XI_U|Retrieval (asset-id:string retrieval:bool)
        (require-capability (SECURE))
        (update LAUNCHPAD|T|Ledger asset-id {"retrieval" : retrieval})
    )
    ;;
    (defun X_FuelCollectables (patron:string sender:string asset-id:string nonce:integer son:bool amount:integer)
        @doc "Fuel Collectable to Launchpad"
        (require-capability (SECURE))
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
                (lpad:string LAUNCHPAD|SC_NAME)
                (sa-s:string (ref-I|OURONET::OI|UC_ShortAccount sender))
            )
            ;;1]Transfer <asset-id> and <nonce> with <amount> to <lpad>
            (if son
                (with-capability (LAUNCHPAD|C>FUEL-SEMI-FUNGIBLE asset-id)
                    (ref-TS02-C1::DPSF|C_TransferNonce patron asset-id sender lpad nonce amount true)
                )
                (with-capability (LAUNCHPAD|C>FUEL-NON-FUNGIBLE asset-id)
                    (ref-TS02-C2::DPNF|C_TransferNonce patron asset-id sender lpad nonce amount true)
                )
            )
            (format "Succesfuly fuelled {} {} Nonce {} to Demiourgos Launchpad from Sender {}" [amount asset-id nonce sa-s])
        )
    )
)

(create-table P|T)
(create-table P|MT)
(create-table LAUNCHPAD|T|Ledger)