(module DPDC GOV
    ;;
    (implements OuronetPolicy)
    (implements BrandingUsageV9)
    (implements Dpdc)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC                   (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    (defconst DPDC|SC_KEY                   (GOV|CollectiblesKey))
    (defconst DPDC|SC_NAME                  (GOV|DPDC|SC_NAME))
    (defconst DPDC|SC_KDA-NAME              "k:35d7f82a7754d10fc1128d199aadb51cb1461f0eb52f4fa89790a44434f12ed8")
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPDC_ADMIN)))
    (defcap GOV|DPDC_ADMIN ()               (enforce-guard GOV|MD_DPDC))
    (defcap DPDC|GOV ()
        @doc "Governor Capability for the DPDC Smart DALOS Account"
        true
    )
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;; [Keys]
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|CollectiblesKey ()           (+ (GOV|NS_Use) ".dh_sc_dpdc-keyset"))
    ;;
    ;; [SC-Names]
    (defun GOV|DPDC|SC_NAME ()              (at 0 ["Σ.μЖâAáпδÃàźфнMAŸôIÌjȘЛδεЬÍБЮoзξ4κΩøΠÒçѺłœщÌĘчoãueUøVlßHšδLτε£σž£ЙLÛòCÎcďьčfğÅηвČïnÊвÞIwÇÝмÉŠвRмWć5íЮzGWYвьżΨπûEÃdйdGЫŁŤČçПχĘŚślьЙŤğLУ0SýЭψȘÔÜнìÆkČѺȘÍÍΛ4шεнÄtИςȘ4"]))
    ;;
    (defun DPDC|SetGovernor (patron:string)
        (with-capability (P|DPDC|CALLER)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-U|G:module{OuronetGuards} U|G)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-DALOS::C_RotateGovernor
                            DPDC|SC_NAME
                            (ref-U|G::UEV_GuardOfAny
                                [
                                    (create-capability-guard (DPDC|GOV))
                                    (P|UR "DPDC-F|RemoteDpdcGov")
                                ]
                            )
                        )
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
            )
        )
    )
    ;;
    ;; [PBLs]
    (defun GOV|DPDC|PBL ()                  (at 0 ["9G.2j95rkomKqd207CDg5yycyKcAy1AqFhjy6D0rCr0Kbwe9E6libtveIHsAIw9F2c43v6IHILIBf62r2LD58xHE09kypyoevL62E81wHL4zj9tIyspf5df82upuBGGKmIsHGuvH86fHMMi99n0htsypL9h3dMHFCIx8ogeynkmCIghxK871rlkas8iDfce7AwAbiajr7H1LHi17mLD7aJu6m7xmcAABkhxtwb4Kqbk8xLpehakyu3AvajgJvtfeysoH67irvplA0as86Jls1r3d3oHms9Maaja9856wzybpthMGs6qDAzacE24skcA30wvm77BLhrdh0ymkl3vbJ9lG641J7ofg5K9gEbHD4ioFHLEajL28qsD4cFEhdDthDzwF8EnBBc74Dikqn9xixFap5Jxhl7D0owz5d9MDJzfjgx3jbdpD3zglsq83iC4fhcpbz3KeAi11Ig2pgIqnmwwqA0Exr5073w7lgzlrw3Ff7Co9uuxbnLuJvlFzgfGeIwM2Dmev1JskqEGK0Ck0B87iagsHFI76HC6sKnwrHnkl0sl8pAf0pbBaw9MbqLs"]))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|DPDC|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC|CALLER))
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
        (with-capability (GOV|DPDC_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC_ADMIN)
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
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (mg:guard (create-capability-guard (P|DPDC|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
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
    (deftable DPSF|PropertiesTable:{DpdcUdc.DPDC|Properties})   ;;Key = <DPSF-id>
    (deftable DPSF|NoncesTable:{DpdcUdc.DPDC|NonceElement})     ;;Key = <DSPF-id> + BAR + <nonce>
    (deftable DPSF|VerumRolesTable:{DpdcUdc.DPDC|VerumRoles})   ;;Key = <DPSF-id>
    (deftable DPSF|AccountsTable:{DpdcUdc.DPSF|Account})        ;;Key = <DPSF-id> + BAR + <account>
    ;;
    (deftable DPNF|PropertiesTable:{DpdcUdc.DPDC|Properties})   ;;Key = <DPNF-id>
    (deftable DPNF|NoncesTable:{DpdcUdc.DPDC|NonceElement})     ;;Key = <DPNF-id> + BAR + <nonce>
    (deftable DPNF|VerumRolesTable:{DpdcUdc.DPDC|VerumRoles})   ;;Key = <DPNF-id>
    (deftable DPNF|AccountsTable:{DpdcUdc.DPNF|Account})        ;;Key = <DPNF-id> + BAR + <account>
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    (defconst FRG                   1000)
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
    (defcap DPDC|C>UPDATE-BRD (entity-id:string son:bool)
        @event
        (CAP_Owner entity-id son)
        (compose-capability (P|DPDC|CALLER))
    )
    (defcap DPDC|C>UPGRADE-BRD (entity-id:string son:bool)
        @event
        (CAP_Owner entity-id son)
        (compose-capability (P|DPDC|CALLER))
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun DPDC|UR_FilterKeysForInfo:[string] (account-or-token-id:string son:bool mode:bool)
        @doc "Returns a List of either: \
        \           Direct-Mode(true):      <account-or-token-id> is <account> Name: \
        \                                   Returns Semi-Fungible or Non-Fungible held by Account <account> OR \
        \           Inverse-Mode(false):    <account-or-token-id> is DPSF|DPNF Designation Name \
        \                                   Returns Accounts that exist for a specific Semi-Fungible or Non-Fungible \
        \           MODE Boolean is only used for validation, \
        \ Accesing the DPSF or DPNF Collection table is done via the <son> boolean"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (if mode
                (ref-DALOS::GLYPH|UEV_DalosAccount account-or-token-id)
                (UEV_id account-or-token-id son)
            )
            (let
                (
                    (keyz:[string]
                        (if son
                            (keys DPSF|AccountsTable)
                            (keys DPNF|AccountsTable)
                        )
                    )
                    (listoflists:[[string]] (map (lambda (x:string) (ref-U|LST::UC_SplitString BAR x)) keyz))
                    (output:[string]
                        (if mode
                            (ref-U|DALOS::UC_DirectFilterId listoflists account-or-token-id)
                            (ref-U|DALOS::UC_InverseFilterId listoflists account-or-token-id)
                        )
                        
                    )
                )
                output
            )
        )
    )
    ;;
    ;; [Properties]
    (defun UR_Properties:object{DpdcUdc.DPDC|Properties} (id:string son:bool)
        (if son
            (read DPSF|PropertiesTable id)
            (read DPNF|PropertiesTable id)
        )
    )
    (defun UR_OwnerKonto:string (id:string son:bool)
        (at "owner-konto" (UR_Properties id son))
    )
    (defun UR_CreatorKonto:string (id:string son:bool)
        (at "creator-konto" (UR_Properties id son))
    )
    (defun UR_Name:string (id:string son:bool)
        (at "name" (UR_Properties id son))
    )
    (defun UR_Ticker:string (id:string son:bool)
        (at "ticker" (UR_Properties id son))
    )
    (defun UR_CanUpgrade:bool (id:string son:bool)
        (at "can-upgrade" (UR_Properties id son))
    )
    (defun UR_CanChangeOwner:bool (id:string son:bool)
        (at "can-change-owner" (UR_Properties id son))
    )
    (defun UR_CanChangeCreator:bool (id:string son:bool)
        (at "can-change-creator" (UR_Properties id son))
    )
    (defun UR_CanAddSpecialRole:bool (id:string son:bool)
        (at "can-add-special-role" (UR_Properties id son))
    )
    (defun UR_CanTransferNftCreateRole:bool (id:string son:bool)
        (at "can-transfer-nft-create-role" (UR_Properties id son))
    )
    (defun UR_CanFreeze:bool (id:string son:bool)
        (at "can-freeze" (UR_Properties id son))
    )
    (defun UR_CanWipe:bool (id:string son:bool)
        (at "can-wipe" (UR_Properties id son))
    )
    (defun UR_CanPause:bool (id:string son:bool)
        (at "can-pause" (UR_Properties id son))
    )
    (defun UR_IsPaused:bool (id:string son:bool)
        (at "is-paused" (UR_Properties id son))
    )
    (defun UR_NoncesUsed:integer (id:string son:bool)
        (at "nonces-used" (UR_Properties id son))
    )
    (defun UR_SetClassesUsed:integer (id:string son:bool)
        (at "set-classes-used" (UR_Properties id son))
    )
    ;; [Nonces]
    (defun UR_NonceElement:object{DpdcUdc.DPDC|NonceElement} (id:string son:bool nonce:integer)
        (if son
            (read DPSF|NoncesTable (concat [id BAR (format "{}" [nonce])]))
            (read DPNF|NoncesTable (concat [id BAR (format "{}" [nonce])]))
        )
    )
    (defun UR_NonceClass:integer (id:string son:bool nonce:integer)
        (at "nonce-class" (UR_NonceElement id son (abs nonce)))
    )
    (defun UR_NonceValue:integer (id:string son:bool nonce:integer)
        (at "nonce-value" (UR_NonceElement id son (abs nonce)))
    )
    (defun UR_NonceSupply:integer (id:string son:bool nonce:integer)
        (if (< nonce 0)
            FRG
            (at "nonce-supply" (UR_NonceElement id son (abs nonce)))
        )
    )
    (defun UR_IzNonFungibleNonceActive:bool (id:string nonce:integer)
        @doc "Check if an NFT Nonce is active. Is used for NFTs only, as all SFTs are always active by default. \
            \ And only NFT Nonces can become inactive"
        (enforce (> nonce 0) "Only higher than zero Nonces can be checked for activness")
        (at "iz-active" (UR_NonceElement id false nonce))
    )
    (defun UR_NonceData:object{DpdcUdc.DPDC|NonceData} (id:string son:bool nonce:integer)
        (if (< nonce 0)
            (UR_SplitData id son nonce)
            (at "nonce-data" (UR_NonceElement id son (abs nonce)))
        )
    )
    (defun UR_SplitData:object{DpdcUdc.DPDC|NonceData} (id:string son:bool nonce:integer)
        (at "split-data" (UR_NonceElement id son (abs nonce)))
    )
    ;;
    ;; [Nonce-Information]
    (defun UR_N|Royalty:decimal (n:object{DpdcUdc.DPDC|NonceData})
        (at "royalty" n)
    )
    (defun UR_N|IgnisRoyalty:decimal (n:object{DpdcUdc.DPDC|NonceData})
        (at "ignis" n)
    )
    (defun UR_N|Name:string (n:object{DpdcUdc.DPDC|NonceData})
        (at "name" n)
    )
    (defun UR_N|Description:string (n:object{DpdcUdc.DPDC|NonceData})
        (at "description" n)
    )
    (defun UR_N|MetaData:object{DpdcUdc.NonceMetaData} (n:object{DpdcUdc.DPDC|NonceData})
        (at "meta-data" n)
    )
    (defun UR_N|AssetType:object{DpdcUdc.URI|Type} (n:object{DpdcUdc.DPDC|NonceData})
        (at "asset-type" n)
    )
    (defun UR_N|Primary:object{DpdcUdc.URI|Data} (n:object{DpdcUdc.DPDC|NonceData})
        (at "uri-primary" n)
    )
    (defun UR_N|Secondary:object{DpdcUdc.URI|Data} (n:object{DpdcUdc.DPDC|NonceData})
        (at "uri-secondary" n)
    )
    (defun UR_N|Tertiary:object{DpdcUdc.URI|Data} (n:object{DpdcUdc.DPDC|NonceData})
        (at "uri-tertiary" n)
    )
    ;;
    (defun UR_N|RawScore:decimal (id:string son:bool nonce:integer)
        (at "score" (UR_N|MetaData (UR_NonceData id son nonce)))
    )
    (defun UR_N|Composition:[integer] (id:string son:bool nonce:integer)
        (at "composition" (UR_N|MetaData (UR_NonceData id son nonce)))
    )
    (defun UR_N|RawMetaData:[object] (id:string son:bool nonce:integer)
        (at "meta-data" (UR_N|MetaData (UR_NonceData id son nonce)))
    )
    ;; [VerumRoles]
    (defun UR_VerumRoles:object{DpdcUdc.DPDC|VerumRoles} (id:string son:bool)
        (if son
            (read DPSF|VerumRolesTable id)
            (read DPNF|VerumRolesTable id)
        )
    )
    (defun UR_Verum1:[string] (id:string son:bool)
        (at "a-frozen" (UR_VerumRoles id son))
    )
    (defun UR_Verum2:[string] (id:string son:bool)
        (at "r-exemption" (UR_VerumRoles id son))
    )
    (defun UR_Verum3:[string] (id:string son:bool)
        (at "r-nft-add-quantity" (UR_VerumRoles id son))
    )
    (defun UR_Verum4:[string] (id:string son:bool)
        (at "r-nft-burn" (UR_VerumRoles id son))
    )
    (defun UR_Verum5:string (id:string son:bool)
        (at "r-nft-create" (UR_VerumRoles id son))
    )
    (defun UR_Verum6:string (id:string son:bool)
        (at "r-nft-recreate" (UR_VerumRoles id son))
    )
    (defun UR_Verum7:[string] (id:string son:bool)
        (at "r-nft-update" (UR_VerumRoles id son))
    )
    (defun UR_Verum8:[string] (id:string son:bool)
        (at "r-modify-creator" (UR_VerumRoles id son))
    )
    (defun UR_Verum9:[string] (id:string son:bool)
        (at "r-modify-royalties" (UR_VerumRoles id son))
    )
    (defun UR_Verum10:string (id:string son:bool)
        (at "r-set-new-uri" (UR_VerumRoles id son))
    )
    (defun UR_Verum11:[string] (id:string son:bool)
        (at "r-transfer" (UR_VerumRoles id son))
    )
    (defun UR_GetSingleVerum:string (id:string son:bool rp:integer)
        (enforce (contains rp [5 6 10]) "Invalid Position for Single Verum")
        (cond
            ((= rp 5) (UR_Verum5 id son))
            ((= rp 6) (UR_Verum6 id son))
            ((= rp 10) (UR_Verum10 id son))
            BAR
        )
    )
    (defun UR_GetVerumChain:[string] (id:string son:bool rp:integer)
        (enforce (contains rp [1 2 3 4 7 8 9 11]) "Invalid Position for Multi Verum")
        (cond
            ((= rp 1) (UR_Verum1 id son))
            ((= rp 2) (UR_Verum2 id son))
            ((= rp 3) (UR_Verum3 id son))
            ((= rp 4) (UR_Verum4 id son))
            ((= rp 7) (UR_Verum7 id son))
            ((= rp 8) (UR_Verum8 id son))
            ((= rp 9) (UR_Verum9 id son))
            ((= rp 11) (UR_Verum11 id son))
            [BAR]
        )
    )
    ;; [Accounts]
    (defun UR_IzAccount:bool (id:string son:bool account:string)
        (if son
            (with-default-read DPSF|AccountsTable (concat [id BAR account])
                {"iz" : false}
                {"iz" := iz}
                iz
            )
            (with-default-read DPNF|AccountsTable (concat [id BAR account])
                {"iz" : false}
                {"iz" := iz}
                iz
            )
        )
    )
    (defun UR_AccountNonces:[integer] (id:string son:bool account:string fragments-or-native:bool)
        @doc "Outputs Requestes Account Nonces"
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
            )
            (if fragments-or-native
                (at "nonce" (ref-DPDC-UDC::UC_SplitNonceBalanceObject (UR_AccountFragments id son account)))
                (if son
                    (at "nonce" (ref-DPDC-UDC::UC_SplitNonceBalanceObject (UR_SemiFungibleAccountHoldings id account)))
                    (UR_NonFungibleAccountHoldings id account)
                )
            )
        )
    )
    (defun UR_SemiFungibleAccountHoldings:[object{DpdcUdc.DPSF|NonceBalance}] (id:string account:string)
        (at "holdings" (read DPSF|AccountsTable (concat [id BAR account]) ["holdings"]))
    )
    (defun UR_NonFungibleAccountHoldings:[integer] (id:string account:string)
        (at "holdings" (read DPNF|AccountsTable (concat [id BAR account]) ["holdings"]))
    )
    (defun UR_AccountFragments:[object{DpdcUdc.DPSF|NonceBalance}] (id:string son:bool account:string)
        (if son
            (at "fragments" (read DPSF|AccountsTable (concat [id BAR account]) ["fragments"]))
            (at "fragments" (read DPNF|AccountsTable (concat [id BAR account]) ["fragments"]))
        )
    )
    (defun UR_AccountNonceSupply:integer (id:string son:bool account:string nonce:integer)
        @doc "Returns the supply of a Nonce existing on a given account, be it SFT or NFT, positive or negative nonce"
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
            )
            (if son
                (let
                    (
                        (nbo:[object{DpdcUdc.DPSF|NonceBalance}]
                            (if (> nonce 0)
                                (UR_SemiFungibleAccountHoldings id account)
                                (UR_AccountFragments id true account)
                            )
                        )
                    )
                    (ref-DPDC-UDC::UC_SupplyFronNonceBalanceObject nbo nonce true)
                )
                (if (> nonce 0)
                    1
                    (ref-DPDC-UDC::UC_SupplyFronNonceBalanceObject (UR_AccountFragments id false account) nonce true)
                )
            )
        )
    )
    ;;
    (defun UR_CA|R:object{DpdcUdc.AccountRoles} (id:string son:bool account:string)
        (if son
            (at "roles" (read DPSF|AccountsTable (concat [id BAR account]) ["roles"]))
            (at "roles" (read DPNF|AccountsTable (concat [id BAR account]) ["roles"]))
        )
    )
    (defun UR_CA|R-AddQuantity:bool (id:string account:string)
        (with-default-read DPSF|AccountsTable (concat [id BAR account])
            { "role-nft-add-quantity" : false}
            { "role-nft-add-quantity" := rnaq }
            rnaq
        )
    )
    (defun UR_CA|R-Frozen:bool (id:string son:bool account:string)
        (at "frozen" (UR_CA|R id son account))
    )
    (defun UR_CA|R-Exemption:bool (id:string son:bool account:string)
        (at "role-exemption" (UR_CA|R id son account))
    )
    (defun UR_CA|R-Burn:bool (id:string son:bool account:string)
        (at "role-nft-burn" (UR_CA|R id son account))
    )
    (defun UR_CA|R-Create:bool (id:string son:bool account:string)
        (at "role-nft-create" (UR_CA|R id son account))
    )
    (defun UR_CA|R-Recreate:bool (id:string son:bool account:string)
        (at "role-nft-recreate" (UR_CA|R id son account))
    )
    (defun UR_CA|R-Update:bool (id:string son:bool account:string)
        (at "role-nft-update" (UR_CA|R id son account))
    )
    (defun UR_CA|R-ModifyCreator:bool (id:string son:bool account:string)
        (at "role-modify-creator" (UR_CA|R id son account))
    )
    (defun UR_CA|R-ModifyRoyalties:bool (id:string son:bool account:string)
        (at "role-modify-royalties" (UR_CA|R id son account))
    )
    (defun UR_CA|R-SetUri:bool (id:string son:bool account:string)
        (at "role-set-new-uri" (UR_CA|R id son account))
    )
    (defun UR_CA|R-Transfer:bool (id:string son:bool account:string)
        (at "role-transfer" (UR_CA|R id son account))
    )
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_id (id:string son:bool)
        (if son
            (with-default-read DPSF|PropertiesTable id
                { "nonces-used"   : -1 }
                { "nonces-used"   := ne }
                (enforce (>= ne 0) (format "DPSF ID {} does not exist" [id]))
            )
            (with-default-read DPNF|PropertiesTable id
                { "nonces-used"   : -1 }
                { "nonces-used"   := ne }
                (enforce (>= ne 0) (format "DPNF ID {} does not exist" [id]))
            )
        )
    )
    (defun UEV_NonceMapper (id:string son:bool nonces:[integer])
        (map
            (lambda
                (idx:integer)
                (UEV_Nonce id son (at idx nonces))
            )
            (enumerate 0 (- (length nonces) 1))
        )
    )
    (defun UEV_Nonce (id:string son:bool nonce:integer)
        (let
            (
                (nv:integer (UR_NonceValue id son nonce))
                (nu:integer (UR_NoncesUsed id son))
                (an:integer (abs nonce))
            )
            (enforce
                (fold (and) true [(!= an 0) (<= an nu) (= an nv)])
                "Invalid Nonce Value"
            )
        )
    )
    (defun UEV_CanUpgradeON (id:string son:bool)
        (let
            (
                (x:bool (UR_CanUpgrade id son))
            )
            (enforce x (format "{} properties cannot be upgraded" [id]))
        )
    )
    (defun UEV_CanPauseON (id:string son:bool)
        (let
            (
                (x:bool (UR_CanPause id son))
            )
            (enforce x (format "{} cannot be paused" [id]))
        )
    )
    (defun UEV_CanAddSpecialRoleON (id:string son:bool)
        (let
            (
                (x:bool (UR_CanAddSpecialRole id son))
            )
            (enforce x (format "For {} no special roles can be added" [id]))
        )
    )
    (defun UEV_ToggleSpecialRole (id:string son:bool toggle:bool)
        (if toggle
            (UEV_CanAddSpecialRoleON id son)
            true
        )
    )
    (defun UEV_CanFreezeON (id:string son:bool)
        (let
            (
                (x:bool (UR_CanFreeze id son))
            )
            (enforce x (format "{} cannot be freezed" [id]))
        )
    )
    (defun UEV_PauseState (id:string son:bool state:bool)
        (let
            (
                (x:bool (UR_IsPaused id son)) ;;false
            )
            (if state
                (enforce x (format "{} is already unpaused" [id]))
                (enforce (not x) (format "{} is already paused" [id]))
            )
        )
    )
    (defun UEV_AccountAddQuantityState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-AddQuantity id account))
            )
            (enforce (= x state) (format "Add Quantity Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountFreezeState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Frozen id son account))
            )
            (enforce (= x state) (format "Frozen for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountExemptionState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Exemption id son account))
            )
            (enforce (= x state) (format "Exemption Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountBurnState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Burn id son account))
            )
            (enforce (= x state) (format "NFT Burn Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountUpdateState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Update id son account))
            )
            (enforce (= x state) (format "NFT Update Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountModifyCreatorState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-ModifyCreator id son account))
            )
            (enforce (= x state) (format "Modify Creator Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountModifyRoyaltiesState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-ModifyRoyalties id son account))
            )
            (enforce (= x state) (format "Modify Royalties Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountTransferState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Transfer id son account))
            )
            (enforce (= x state) (format "Transfer Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountCreateState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Create id son account))
            )
            (enforce (= x state) (format "Create Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountRecreateState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Recreate id son account))
            )
            (enforce (= x state) (format "Recreate Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountSetUriState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-SetUri id son account))
            )
            (enforce (= x state) (format "Set Uri Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_Royalty (royalty:decimal)
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
            )
            (ref-U|DALOS::UEV_Fee royalty)
        )
    )
    (defun UEV_IgnisRoyalty (royalty:decimal)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                ;;
                (ignis-id:string (ref-DALOS::UR_IgnisID))
                (ignis-pr:integer (ref-DPTF::UR_Decimals ignis-id))
            )
            (enforce
                (= (floor royalty ignis-pr) royalty)
                (format "The Ignis input amount of {} is not conform with its precision" [royalty])
            )
        )
    )
    (defun UEV_NftNonceExistance (id:string nonce:integer existance:bool)
        (let
            (
                (x:bool (UR_IzNonFungibleNonceActive id nonce))
            )
            (enforce (= x existance) (format "NFT {} Nonce {} must have Existance set to {} for Operation" [id nonce existance]))
        )
    )
    ;;{F3}  [UDC]
    (defun UDC_Control:object{DpdcUdc.DPDC|Properties}
        (id:string son:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
            )
            (ref-DPDC-UDC::UDC_DPDC|Properties
                (UR_OwnerKonto id son)
                (UR_CreatorKonto id son)
                (UR_Name id son)
                (UR_Ticker id son)
                cu cco ccc casr ctncr cf cw cp
                (UR_IsPaused id son)
                (UR_NoncesUsed id son)
                (UR_SetClassesUsed id son)
            )
        )
    )
    ;;
    ;;{F4}  [CAP]
    (defun CAP_Owner (id:string son:bool)
        @doc "Enforces DPSF or DPNF Token ID Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (UR_OwnerKonto id son))
        )
    )
    (defun CAP_Creator (id:string son:bool)
        @doc "Enforces DPSF or DPNF Token ID Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (UR_CreatorKonto id son))
        )
    )
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_UpdatePendingBranding:object{IgnisCollector.OutputCumulator}
        (entity-id:string son:bool logo:string description:string website:string social:[object{Branding.SocialSchema}])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-BRD:module{Branding} BRD)
                (owner:string (UR_OwnerKonto entity-id son))
                (multiplier:decimal (if son 4.0 5.0))
            )
            (with-capability (DPDC|C>UPDATE-BRD entity-id son)
                (ref-BRD::XE_UpdatePendingBranding entity-id logo description website social)
                (ref-IGNIS::IC|UDC_BrandingCumulator owner multiplier)
            )
        )
    )
    (defun C_UpgradeBranding (patron:string entity-id:string son:bool months:integer)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-BRD:module{Branding} BRD)
                (owner:string (UR_OwnerKonto entity-id son))
                (kda-payment:decimal
                    (with-capability (DPDC|C>UPGRADE-BRD entity-id son)
                        (ref-BRD::XE_UpgradeBranding entity-id owner months)
                    )
                )
            )
            (ref-DALOS::KDA|C_CollectWT patron kda-payment false)
        )
    )
    ;;
    ;;{F7}  [X]
    ;; [<AccountsTable> Writings] [0]
    (defun XB_DeployAccountSFT
        (
            id:string account:string
            input-rnaq:bool f:bool re:bool rnb:bool rnc:bool rnr:bool
            rnu:bool rmc:bool rmr:bool rsnu:bool rt:bool
        )
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id true)
            (with-default-read DPSF|AccountsTable (concat [id BAR account])
                (ref-DPDC-UDC::UDC_DPSF|Account
                    true
                    [(ref-DPDC-UDC::UDC_ZeroNBO)]
                    [(ref-DPDC-UDC::UDC_ZeroNBO)]
                    (ref-DPDC-UDC::UDC_AccountRoles f re rnb rnc rnr rnu rmc rmr rsnu rt)
                    input-rnaq
                )
                {"iz"                       := e
                ,"holdings"                 := h
                ,"fragments"                := f
                ,"roles"                    := r
                ,"role-nft-add-quantity"    := rnaq}
                (write DPSF|AccountsTable (concat [id BAR account])
                    (ref-DPDC-UDC::UDC_DPSF|Account e h f r rnaq)
                )
            )
        )
    )
    (defun XB_DeployAccountNFT 
        (
            id:string account:string
            f:bool re:bool rnb:bool rnc:bool rnr:bool
            rnu:bool rmc:bool rmr:bool rsnu:bool rt:bool
        )
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id false)
            (with-default-read DPNF|AccountsTable (concat [id BAR account])
                (ref-DPDC-UDC::UDC_DPNF|Account
                    true
                    [0]
                    [(ref-DPDC-UDC::UDC_ZeroNBO)]
                    (ref-DPDC-UDC::UDC_AccountRoles f re rnb rnc rnr rnu rmc rmr rsnu rt)
                )
                {"iz"                       := e
                ,"holdings"                 := h
                ,"fragments"                := f
                ,"roles"                    := r}
                (write DPNF|AccountsTable (concat [id BAR account])
                    (ref-DPDC-UDC::UDC_DPNF|Account e h f r)
                )
            )
        )
    )
    (defun XE_DeployAccountWNE (id:string son:bool account:string)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (collection-account-exists:bool (ref-DPDC::UR_IzAccount id son account))
                (f:bool false)
            )
            (if (not collection-account-exists)
                (if son
                    (XB_DeployAccountSFT id account f f f f f f f f f f f)
                    (XB_DeployAccountNFT id account f f f f f f f f f f)
                )
                true
            )
        )
    )
    (defun XE_U|SFT-Holdings (id:string account:string holdings:[object{DpdcUdc.DPSF|NonceBalance}])
        (UEV_IMC)
        (update DPSF|AccountsTable (concat [id BAR account])
            {"holdings"     : holdings}
        )
    )
    (defun XE_U|NFT-Holdings (id:string account:string holdings:[integer])
        (UEV_IMC)
        (update DPNF|AccountsTable (concat [id BAR account])
            {"holdings"     : holdings}
        )
    )
    (defun XE_U|DPDC-Fragments (id:string son:bool account:string fragments:[object{DpdcUdc.DPSF|NonceBalance}])
        (UEV_IMC)
        (if son
            (update DPSF|AccountsTable (concat [id BAR account])
                {"fragments"    : fragments}
            )
            (update DPNF|AccountsTable (concat [id BAR account])
                {"fragments"    : fragments}
            )
        )
    )
    (defun XE_U|Rnaq (id:string account:string toggle)
        (UEV_IMC)
        (update DPSF|AccountsTable (concat [id BAR account])
            {"role-nft-add-quantity" : toggle}
        )
    )
    (defun XI_U|AccountRoles (id:string son:bool account:string new-roles:object{DpdcUdc.AccountRoles})
        (require-capability (SECURE))
        (if son
            (update DPSF|AccountsTable (concat [id BAR account])
                {"roles" : new-roles}
            )
            (update DPNF|AccountsTable (concat [id BAR account])
                {"roles" : new-roles}
            )
        )
    )
    ;; [<PropertiesTable> Writings] [1]
    (defun XE_I|Collection
        (id:string son:bool idp:object{DpdcUdc.DPDC|Properties})
        (UEV_IMC)
        (if son
            (insert DPSF|PropertiesTable id idp)
            (insert DPNF|PropertiesTable id idp)
        )
    )
    (defun XE_U|Specs (id:string son:bool specs:object{DpdcUdc.DPDC|Properties})
        (UEV_IMC)
        (if son
            (update DPSF|PropertiesTable id specs)
            (update DPNF|PropertiesTable id specs)
        )
    )
    (defun XE_U|IsPaused (id:string son:bool toggle:bool)
        (UEV_IMC)
        (if son
            (update DPSF|PropertiesTable id {"is-paused" : toggle})
            (update DPNF|PropertiesTable id {"is-paused" : toggle})
        )
    )
    (defun XE_U|NoncesUsed (id:string son:bool new-nv:integer)
        (UEV_IMC)
        (if son
            (update DPSF|PropertiesTable id {"nonces-used" : new-nv})
            (update DPNF|PropertiesTable id {"nonces-used" : new-nv})
        )
    )
    (defun XE_U|SetClassesUsed (id:string son:bool new-nsc:integer)
        (UEV_IMC)
        (if son
            (update DPSF|PropertiesTable id {"set-classes-used" : new-nsc})
            (update DPNF|PropertiesTable id {"set-classes-used" : new-nsc})
        )
    )
    ;; [<NoncesTable> Writings] [2]
    (defun XE_I|CollectionElement (id:string son:bool nonce-value:integer ned:object{DpdcUdc.DPDC|NonceElement})
        (UEV_IMC)
        (if son
            (insert DPSF|NoncesTable (concat [id BAR (format "{}" [nonce-value])]) ned)
            (insert DPNF|NoncesTable (concat [id BAR (format "{}" [nonce-value])]) ned)
        )
    )
    (defun XE_U|NonceSupply (id:string nonce-value:integer new-supply:integer)
        (UEV_IMC)
        (update DPSF|NoncesTable (concat [id BAR (format "{}" [nonce-value])]) {"nonce-supply" : new-supply})
    )
    (defun XE_U|NonceIzActive (id:string nonce-value:integer iz-active:bool)
        (UEV_IMC)
        (update DPNF|NoncesTable (concat [id BAR (format "{}" [nonce-value])]) {"iz-active" : iz-active})
    )
    (defun XE_U|NonceOrSplitData (id:string son:bool nonce-value:integer nos:bool nd:object{DpdcUdc.DPDC|NonceData} )
        (UEV_IMC)
        (if nos
            (if son
                (update DPSF|NoncesTable (concat [id BAR (format "{}" [nonce-value])]) {"nonce-data" : nd})
                (update DPNF|NoncesTable (concat [id BAR (format "{}" [nonce-value])]) {"nonce-data" : nd})
            )
            (if son
                (update DPSF|NoncesTable (concat [id BAR (format "{}" [nonce-value])]) {"split-data" : nd})
                (update DPNF|NoncesTable (concat [id BAR (format "{}" [nonce-value])]) {"split-data" : nd})
            )
        )
    )
    ;; [<VerumRolesTable> Writings] [4]
    (defun XE_I|VerumRoles (id:string son:bool verum-chain:object{DpdcUdc.DPDC|VerumRoles})
        (UEV_IMC)
        (if son
            (insert DPSF|VerumRolesTable id verum-chain)
            (insert DPNF|VerumRolesTable id verum-chain)
        )
    )
    (defun XI_U|VerumRole1 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|VerumRolesTable id {"a-frozen" : ul})
            (update DPNF|VerumRolesTable id {"a-frozen" : ul})
        )
    )
    (defun XI_U|VerumRole2 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|VerumRolesTable id {"r-exemption" : ul})
            (update DPNF|VerumRolesTable id {"r-exemption" : ul})
        )
    )
    (defun XI_U|VerumRole3 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|VerumRolesTable id {"r-nft-add-quantity" : ul})
            (update DPNF|VerumRolesTable id {"r-nft-add-quantity" : ul})
        )
    )
    (defun XI_U|VerumRole4 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|VerumRolesTable id {"r-nft-burn" : ul})
            (update DPNF|VerumRolesTable id {"r-nft-burn" : ul})
        )
    )
    (defun XI_U|VerumRole5 (id:string son:bool ul:string)
        (require-capability (SECURE))
        (if son
            (update DPSF|VerumRolesTable id {"r-nft-create" : ul})
            (update DPNF|VerumRolesTable id {"r-nft-create" : ul})
        )
    )
    (defun XI_U|VerumRole6 (id:string son:bool ul:string)
        (require-capability (SECURE))
        (if son
            (update DPSF|VerumRolesTable id {"r-nft-recreate" : ul})
            (update DPNF|VerumRolesTable id {"r-nft-recreate" : ul})
        )
    )
    (defun XI_U|VerumRole7 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|VerumRolesTable id {"r-nft-update" : ul})
            (update DPNF|VerumRolesTable id {"r-nft-update" : ul})
        )
    )
    (defun XI_U|VerumRole8 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|VerumRolesTable id {"r-modify-creator" : ul})
            (update DPNF|VerumRolesTable id {"r-modify-creator" : ul})
        )
    )
    (defun XI_U|VerumRole9 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|VerumRolesTable id {"r-modify-royalties" : ul})
            (update DPNF|VerumRolesTable id {"r-modify-royalties" : ul})
        )
    )
    (defun XI_U|VerumRole10 (id:string son:bool ul:string)
        (require-capability (SECURE))
        (if son
            (update DPSF|VerumRolesTable id {"r-set-new-uri" : ul})
            (update DPNF|VerumRolesTable id {"r-set-new-uri" : ul})
        )
    )
    (defun XI_U|VerumRole11 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|VerumRolesTable id {"r-transfer" : ul})
            (update DPNF|VerumRolesTable id {"r-transfer" : ul})
        )
    )
    ;;
    ;;  [Indirect Writings]
    ;;
    (defun XE_U|Frozen (id:string son:bool account:string toggle)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"frozen" : toggle}
                    (remove "frozen" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|Exemption (id:string son:bool account:string toggle)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-exemption" : toggle}
                    (remove "role-exemption" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|Burn (id:string son:bool account:string toggle)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-nft-burn" : toggle}
                    (remove "role-nft-burn" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|Create (id:string son:bool account:string toggle)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-nft-create" : toggle}
                    (remove "role-nft-create" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|Recreate (id:string son:bool account:string toggle)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-nft-recreate" : toggle}
                    (remove "role-nft-recreate" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|Update (id:string son:bool account:string toggle)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-nft-update" : toggle}
                    (remove "role-nft-update" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|ModifyCreator (id:string son:bool account:string toggle)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-modify-creator" : toggle}
                    (remove "role-modify-creator" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|ModifyRoyalties (id:string son:bool account:string toggle)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-modify-royalties" : toggle}
                    (remove "role-modify-royalties" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|SetNewUri (id:string son:bool account:string toggle)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-set-new-uri" : toggle}
                    (remove "role-set-new-uri" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|Transfer (id:string son:bool account:string toggle)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-transfer" : toggle}
                    (remove "role-transfer" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|VerumRoles (id:string son:bool rp:integer aor:bool account:string)
        (UEV_IMC)
        (if (contains rp [5 6 10])
            (if aor
                (with-capability (SECURE)
                    (cond
                        ((= rp 5) (XI_U|VerumRole5 id son account))
                        ((= rp 6) (XI_U|VerumRole6 id son account))
                        ((= rp 10) (XI_U|VerumRole10 id son account))
                        true
                    )
                )
                true
            )
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                    (current-verum-chain:[string] (UR_GetVerumChain id son rp))
                    (ul:[string] (ref-U|DALOS::UC_NewRoleList current-verum-chain account aor))
                )
                (with-capability (SECURE)
                    (cond
                        ((= rp 1) (XI_U|VerumRole1 id son ul))
                        ((= rp 2) (XI_U|VerumRole2 id son ul))
                        ((= rp 3) (XI_U|VerumRole3 id son ul))
                        ((= rp 4) (XI_U|VerumRole4 id son ul))
                        ((= rp 7) (XI_U|VerumRole7 id son ul))
                        ((= rp 8) (XI_U|VerumRole8 id son ul))
                        ((= rp 9) (XI_U|VerumRole9 id son ul))
                        ((= rp 11) (XI_U|VerumRole11 id son ul))
                        true
                    )
                )
            )
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)
;;DPSF
(create-table DPSF|PropertiesTable)
(create-table DPSF|NoncesTable)
(create-table DPSF|VerumRolesTable)
(create-table DPSF|AccountsTable)
;;DPNF
(create-table DPNF|PropertiesTable)
(create-table DPNF|NoncesTable)
(create-table DPNF|VerumRolesTable)
(create-table DPNF|AccountsTable)