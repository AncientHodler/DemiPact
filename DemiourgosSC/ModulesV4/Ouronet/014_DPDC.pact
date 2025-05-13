(module DPDC GOV
    ;;
    (implements OuronetPolicy)
    (implements BrandingUsageV6)
    (implements DemiourgosPactDigitalCollectibles)
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
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;; [Keys]
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|CollectiblesKey ()           (+ (GOV|NS_Use) ".dh_sc_dpdc-keyset"))
    ;;
    ;; [SC-Names]
    (defun GOV|DPDC|SC_NAME ()              (at 0 ["Σ.μЖâAáпδÃàźфнMAŸôIÌjȘЛδεЬÍБЮoзξ4κΩøΠÒçѺłœщÌĘчoãueUøVlßHšδLτε£σž£ЙLÛòCÎcďьčfğÅηвČïnÊвÞIwÇÝмÉŠвRмWć5íЮzGWYвьżΨπûEÃdйdGЫŁŤČçПχĘŚślьЙŤğLУ0SýЭψȘÔÜнìÆkČѺȘÍÍΛ4шεнÄtИςȘ4"]))
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
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::P|Info)))
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
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (mg:guard (create-capability-guard (P|DPDC|CALLER)))
            )
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
    ;;DPSF
    (defschema DPSF|PropertiesSchema
        @doc "Key = <DPSF id>"
        exist:bool
        sft:[object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}]
        sft-specs:object{DemiourgosPactDigitalCollectibles.DPDC|PropertiesSchema}
        sft-sets:[object{DemiourgosPactDigitalCollectibles.DPDC|Set}]
        existing-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
    )
    (defschema DPSF|BalanceSchema
        @doc "Key = <DPSF id> + BAR + <account>"
        exist:bool
        owned-nonces:[integer]
        nonces-balances:[integer]
        ;;
        roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
        role-nft-add-quantity:bool
    )
    ;;DPNF
    (defschema DPNF|PropertiesSchema
        @doc "Key = <DPNF id>"
        exist:bool
        nft:[object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}]
        nft-specs:object{DemiourgosPactDigitalCollectibles.DPDC|PropertiesSchema}
        nft-sets:[object{DemiourgosPactDigitalCollectibles.DPDC|Set}]
        existing-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
    )
    (defschema DPNF|BalanceSchema
        @doc "Key = <DPSF id> + BAR + <account>"
        exist:bool
        owned-nonces:[integer]
        ;;
        roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
    )
    ;;{2}
    (deftable DPSF|PropertiesTable:{DPSF|PropertiesSchema})
    (deftable DPNF|PropertiesTable:{DPNF|PropertiesSchema})
    (deftable DPSF|BalanceTable:{DPSF|BalanceSchema})
    (deftable DPNF|BalanceTable:{DPNF|BalanceSchema})
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
    (defcap DPDC|C>UPDATE-BRD (entity-id:string sft-or-nft:bool)
        @event
        (CAP_Owner entity-id sft-or-nft)
        (compose-capability (P|DPDC|CALLER))
    )
    (defcap DPDC|C>UPGRADE-BRD (entity-id:string sft-or-nft:bool)
        @event
        (CAP_Owner entity-id sft-or-nft)
        (compose-capability (P|DPDC|CALLER))
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun DPDC|UR_FilterKeysForInfo:[string] (account-or-token-id:string sft-or-nft:bool mode:bool)
        @doc "Returns a List of either: \
        \           Direct-Mode(true):      <account-or-token-id> is <account> Name: \
        \                                   Returns Semi-Fungible or Non-Fungible held by Account <account> OR \
        \           Inverse-Mode(false):    <account-or-token-id> is DPSF|DPNF Designation Name \
        \                                   Returns Accounts that exist for a specific Semi-Fungible or Non-Fungible \
        \           MODE Boolean is only used for validation, \
        \ Accesing the DPSF or DPNF Collection table is done via the <sft-or-nft> boolean"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (ref-DALOS:module{OuronetDalosV3} DALOS)
            )
            (if mode
                (ref-DALOS::GLYPH|UEV_DalosAccount account-or-token-id)
                (UEV_id account-or-token-id sft-or-nft)
            )
            (let
                (
                    (keyz:[string]
                        (if sft-or-nft
                            (keys DPSF|BalanceTable)
                            (keys DPNF|BalanceTable)
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
    ;;Read Nonces
    (defun UR_NonceElement:object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}
        (id:string sft-or-nft:bool nonce:integer)
        (if sft-or-nft
            (at nonce (UR_ElementsSFT id))
            (at nonce (UR_ElementsNFT id))
        )
    )
    (defun UR_NonceValue:integer (id:string sft-or-nft:bool nonce:integer)
        (at "nonce-value" (UR_NonceElement id sft-or-nft (abs nonce)))
    )
    (defun UR_NonceSetClass:integer (id:string sft-or-nft:bool nonce:integer)
        ;(UEV_Nonce id sft-or-nft nonce)
        (at "nonce-set-class" (UR_NonceElement id sft-or-nft (abs nonce)))
    )
    (defun UR_NonceSupply:integer (id:string sft-or-nft:bool nonce:integer)
        ;(UEV_Nonce id sft-or-nft nonce)
        (if (< nonce 0)
            FRG
            (at "nonce-supply" (UR_NonceElement id sft-or-nft nonce))
        )
    )
    (defun UR_NonceData:object{DemiourgosPactDigitalCollectibles.DC|DataSchema}
        (id:string sft-or-nft:bool nonce:integer)
        ;(UEV_Nonce id sft-or-nft nonce)
        (if (< nonce 0)
            (at "split-data" (UR_NonceElement id sft-or-nft (abs nonce)))
            (at "nonce-data" (UR_NonceElement id sft-or-nft nonce))
        )
    )
    ;;
    (defun UR_NonceRoyalty:decimal (id:string sft-or-nft:bool nonce:integer)
        (at "royalty" (UR_NonceData id sft-or-nft nonce))
    )
    (defun UR_NonceIgnis:decimal (id:string sft-or-nft:bool nonce:integer)
        (at "ignis" (UR_NonceData id sft-or-nft nonce))
    )
    (defun UR_NonceName:string (id:string sft-or-nft:bool nonce:integer)
        (at "name" (UR_NonceData id sft-or-nft nonce))
    )
    (defun UR_NonceDescription:string (id:string sft-or-nft:bool nonce:integer)
        (at "description" (UR_NonceData id sft-or-nft nonce))
    )
    (defun UR_NonceMetaDataRaw:[object] (id:string sft-or-nft:bool nonce:integer)
        (at "meta-data" (UR_NonceData id sft-or-nft nonce))
    )
    (defun UR_NonceMetaDataCustom:[object] (id:string sft-or-nft:bool nonce:integer)
        (drop 1 (UR_NonceMetaDataRaw id sft-or-nft nonce))
    )
    (defun UR_NonceScore:decimal (id:string sft-or-nft:bool nonce:integer)
        (at "score" (at 0 (UR_NonceMetaDataRaw id sft-or-nft nonce)))
    )
    (defun UR_NonceAssetType:object{DemiourgosPactDigitalCollectibles.DC|URI|Type} 
        (id:string sft-or-nft:bool nonce:integer)
        (at "asset-type" (UR_NonceData id sft-or-nft nonce))
    )
    (defun UR_NonceUriOne:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
        (id:string sft-or-nft:bool nonce:integer)
        (at "uri-primary" (UR_NonceData id sft-or-nft nonce))
    )
    (defun UR_NonceUriTwo:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema} 
        (id:string sft-or-nft:bool nonce:integer)
        (at "uri-secondary" (UR_NonceData id sft-or-nft nonce))
    )
    
    (defun UR_NonceUriThree:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema} 
        (id:string sft-or-nft:bool nonce:integer)
        (at "uri-tertiary" (UR_NonceData id sft-or-nft nonce))
    )
    ;;Read Specs
    (defun UR_C|Exists:bool (id:string sft-or-nft:bool)
        (if sft-or-nft
            (with-default-read DPSF|PropertiesTable id
                { "exist" : false}
                { "exist" := e }
                e
            )
            (with-default-read DPNF|PropertiesTable id
                { "exist" : false}
                { "exist" := e }
                e
            )
        )
    )
    (defun UR_ElementsSFT:[object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}] 
        (id:string)
        (at "sft" (read DPSF|PropertiesTable id ["sft"]))
    )
    (defun UR_ElementsNFT:[object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}] 
        (id:string)
        (at "nft" (read DPNF|PropertiesTable id ["nft"]))
    )
    (defun UR_CollectionSpecs:object{DemiourgosPactDigitalCollectibles.DPDC|PropertiesSchema}
        (id:string sft-or-nft:bool)
        (if sft-or-nft
            (at "sft-specs" (read DPSF|PropertiesTable id ["sft-specs"]))
            (at "nft-specs" (read DPNF|PropertiesTable id ["nft-specs"]))
        )
    )
    (defun UR_CollectionSets:[object{DemiourgosPactDigitalCollectibles.DPDC|Set}]
        (id:string sft-or-nft:bool)
        (if sft-or-nft
            (at "sft-sets" (read DPSF|PropertiesTable id ["sft-sets"]))
            (at "nft-sets" (read DPNF|PropertiesTable id ["nft-sets"]))
        )
    )
    (defun UR_CollectionRoles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
        (id:string sft-or-nft:bool)
        (if sft-or-nft
            (at "existing-roles" (read DPSF|PropertiesTable id ["existing-roles"]))
            (at "existing-roles" (read DPNF|PropertiesTable id ["existing-roles"]))
        )
    )
    ;;
    (defun UR_OwnerKonto:string (id:string sft-or-nft:bool)
        (at "owner-konto" (UR_CollectionSpecs id sft-or-nft))
    )
    (defun UR_CreatorKonto:string (id:string sft-or-nft:bool)
        (at "creator-konto" (UR_CollectionSpecs id sft-or-nft))
    )
    (defun UR_Name:string (id:string sft-or-nft:bool)
        (at "name" (UR_CollectionSpecs id sft-or-nft))
    )
    (defun UR_Ticker:string (id:string sft-or-nft:bool)
        (at "ticker" (UR_CollectionSpecs id sft-or-nft))
    )
    (defun UR_CanUpgrade:bool (id:string sft-or-nft:bool)
        (at "can-upgrade" (UR_CollectionSpecs id sft-or-nft))
    )
    (defun UR_CanChangeOwner:bool (id:string sft-or-nft:bool)
        (at "can-change-owner" (UR_CollectionSpecs id sft-or-nft))
    )
    (defun UR_CanChangeCreator:bool (id:string sft-or-nft:bool)
        (at "can-change-creator" (UR_CollectionSpecs id sft-or-nft))

    )
    (defun UR_CanAddSpecialRole:bool (id:string sft-or-nft:bool)
        (at "can-add-special-role" (UR_CollectionSpecs id sft-or-nft))
    )
    (defun UR_CanTransferNftCreateRole:bool (id:string sft-or-nft:bool)
        (at "can-transfer-nft-create-role" (UR_CollectionSpecs id sft-or-nft))
    )
    (defun UR_CanFreeze:bool (id:string sft-or-nft:bool)
        (at "can-freeze" (UR_CollectionSpecs id sft-or-nft))
    )
    (defun UR_CanWipe:bool (id:string sft-or-nft:bool)
        (at "can-wipe" (UR_CollectionSpecs id sft-or-nft))
    )
    (defun UR_CanPause:bool (id:string sft-or-nft:bool)
        (at "can-pause" (UR_CollectionSpecs id sft-or-nft))
    )
    (defun UR_IsPaused:bool (id:string sft-or-nft:bool)
        (at "is-paused" (UR_CollectionSpecs id sft-or-nft))
    )
    (defun UR_NoncesUsed:integer (id:string sft-or-nft:bool)
        (at "nonces-used" (UR_CollectionSpecs id sft-or-nft))
    )
    ;;Read Existing Roles
    (defun UR_ER-AddQuantity:[string] (id:string)
        (at "r-nft-add-quantity" (at "existing-roles" (read DPSF|PropertiesTable id ["existing-roles"])))
    )
    (defun UR_ER-Frozen:[string] (id:string sft-or-nft:bool)
        (at "a-frozen" (UR_CollectionRoles id sft-or-nft))
    )
    (defun UR_ER-Exemption:[string] (id:string sft-or-nft:bool)
        (at "r-exemption" (UR_CollectionRoles id sft-or-nft))
    )
    (defun UR_ER-Burn:[string] (id:string sft-or-nft:bool)
        (at "r-nft-burn" (UR_CollectionRoles id sft-or-nft))
    )
    (defun UR_ER-Create:[string] (id:string sft-or-nft:bool)
        (at "r-nft-create" (UR_CollectionRoles id sft-or-nft))
    )
    (defun UR_ER-Recreate:[string] (id:string sft-or-nft:bool)
        (at "r-nft-recreate" (UR_CollectionRoles id sft-or-nft))
    )
    (defun UR_ER-Update:[string] (id:string sft-or-nft:bool)
        (at "r-nft-update" (UR_CollectionRoles id sft-or-nft))
    )
    (defun UR_ER-ModifyCreator:[string] (id:string sft-or-nft:bool)
        (at "r-modify-creator" (UR_CollectionRoles id sft-or-nft))
    )
    (defun UR_ER-ModifyRoyalties:[string] (id:string sft-or-nft:bool)
        (at "r-modify-royalties" (UR_CollectionRoles id sft-or-nft))
    )
    (defun UR_ER-SetUri:[string] (id:string sft-or-nft:bool)
        (at "r-set-new-uri" (UR_CollectionRoles id sft-or-nft))
    )
    (defun UR_ER-Transfer:[string] (id:string sft-or-nft:bool)
        (at "r-transfer" (UR_CollectionRoles id sft-or-nft))
    )
    ;;User Account Reads
    (defun UR_CA|Exists:bool (id:string sft-or-nft:bool account:string)
        (if sft-or-nft
            (with-default-read DPSF|BalanceTable (concat [id BAR account])
                { "exist" : false}
                { "exist" := e }
                e
            )
            (with-default-read DPNF|BalanceTable (concat [id BAR account])
                { "exist" : false}
                { "exist" := e }
                e
            )
        )
    )
    (defun UR_CA|OwnedNonces:[integer] (id:string sft-or-nft:bool account:string)
        (if sft-or-nft
            (at "owned-nonces" (read DPSF|BalanceTable (concat [id BAR account]) ["owned-nonces"]))
            (at "owned-nonces" (read DPNF|BalanceTable (concat [id BAR account]) ["owned-nonces"]))
        )
    )
    (defun UR_CA|NoncesBalances:[integer] (id:string account:string)
        (at "nonces-balances" (read DPSF|BalanceTable (concat [id BAR account]) ["nonces-balances"]))
    )
    (defun UR_CA|R:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
        (id:string sft-or-nft:bool account:string)
        (if sft-or-nft
            (at "roles" (read DPSF|BalanceTable (concat [id BAR account]) ["roles"]))
            (at "roles" (read DPNF|BalanceTable (concat [id BAR account]) ["roles"]))
        )
    )
    ;;
    (defun UR_CA|R-AddQuantity:bool (id:string account:string)
        (with-default-read DPSF|BalanceTable (concat [id BAR account])
            { "role-nft-add-quantity" : false}
            { "role-nft-add-quantity" := rnaq }
            rnaq
        )
    )
    (defun UR_CA|R-Frozen:bool (id:string sft-or-nft:bool account:string)
        (at "frozen" (UR_CA|R id sft-or-nft account))
    )
    (defun UR_CA|R-Exemption:bool (id:string sft-or-nft:bool account:string)
        (at "role-exemption" (UR_CA|R id sft-or-nft account))
    )
    (defun UR_CA|R-Burn:bool (id:string sft-or-nft:bool account:string)
        (at "role-nft-burn" (UR_CA|R id sft-or-nft account))
    )
    (defun UR_CA|R-Create:bool (id:string sft-or-nft:bool account:string)
        (at "role-nft-create" (UR_CA|R id sft-or-nft account))
    )
    (defun UR_CA|R-Recreate:bool (id:string sft-or-nft:bool account:string)
        (at "role-nft-recreate" (UR_CA|R id sft-or-nft account))
    )
    (defun UR_CA|R-Update:bool (id:string sft-or-nft:bool account:string)
        (at "role-nft-update" (UR_CA|R id sft-or-nft account))
    )
    (defun UR_CA|R-ModifyCreator:bool (id:string sft-or-nft:bool account:string)
        (at "role-modify-creator" (UR_CA|R id sft-or-nft account))
    )
    (defun UR_CA|R-ModifyRoyalties:bool (id:string sft-or-nft:bool account:string)
        (at "role-modify-royalties" (UR_CA|R id sft-or-nft account))
    )
    (defun UR_CA|R-SetUri:bool (id:string sft-or-nft:bool account:string)
        (at "role-set-new-uri" (UR_CA|R id sft-or-nft account))
    )
    (defun UR_CA|R-Transfer:bool (id:string sft-or-nft:bool account:string)
        (at "role-transfer" (UR_CA|R id sft-or-nft account))
    )
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_id (id:string sft-or-nft:bool)
        (if sft-or-nft
            (with-default-read DPSF|PropertiesTable id
                { "exist"   : false }
                { "exist"   := e }
                (enforce e (format "DPSF ID {} does not exist" [id]))
            )
            (with-default-read DPNF|PropertiesTable id
                { "exist"   : false }
                { "exist"   := e }
                (enforce e (format "DPNF ID {} does not exist" [id]))
            )
        )
    )
    (defun UEV_Nonce (id:string sft-or-nft:bool nonce:integer)
        (let
            (
                (nv:integer (UR_NonceValue id sft-or-nft nonce))
            )
            (enforce (!= nonce 0) "Invalid Nonce Value")
            (if (> nonce 0)
                (enforce (= nonce nv) "Invalid DPDC Data Set")
                (let
                    (
                        (iz-fragmented:bool (UEV_IzNonceFragmented id sft-or-nft (abs nonce)))
                    )
                    (enforce iz-fragmented "Negative Nonce doesnt exist, as no split-data is detected!")
                    (enforce (= (abs nonce) nv) "Invalid DPDC Data Set")
                )  
            )
        )
    )
    (defun UEV_IzNonceFragmented:bool (id:string sft-or-nft:bool nonce:integer)
        (enforce (> nonce 0) "Only greater than 0 nonces can be checked for fragmentation")
        (let
            (
                (split-nonce-data:object{DemiourgosPactDigitalCollectibles.DC|DataSchema}
                    (at "split-data" (UR_NonceElement id sft-or-nft nonce))
                )
                (empty-nonce-data:object{DemiourgosPactDigitalCollectibles.DC|DataSchema}
                    (UDC_EmptyDataDC)
                )
            )
            (if (@= split-nonce-data empty-nonce-data)
                true
                false
            )
        )
    )
    (defun UEV_CanUpgradeON (id:string sft-or-nft:bool)
        (let
            (
                (x:bool (UR_CanUpgrade id sft-or-nft))
            )
            (enforce x (format "{} properties cannot be upgraded" [id]))
        )
    )
    (defun UEV_CanPauseON (id:string sft-or-nft:bool)
        (let
            (
                (x:bool (UR_CanPause id sft-or-nft))
            )
            (enforce x (format "{} cannot be paused" [id]))
        )
    )
    (defun UEV_CanAddSpecialRoleON (id:string sft-or-nft:bool)
        (let
            (
                (x:bool (UR_CanAddSpecialRole id sft-or-nft))
            )
            (enforce x (format "For {} no special roles can be added" [id]))
        )
    )
    (defun UEV_ToggleSpecialRole (id:string sft-or-nft:bool toggle:bool)
        (if toggle
            (UEV_CanAddSpecialRoleON id sft-or-nft)
            true
        )
    )
    (defun UEV_CanFreezeON (id:string sft-or-nft:bool)
        (let
            (
                (x:bool (UR_CanFreeze id sft-or-nft))
            )
            (enforce x (format "{} cannot be freezed" [id]))
        )
    )

    (defun UEV_PauseState (id:string sft-or-nft:bool state:bool)
        (let
            (
                (x:bool (UR_IsPaused id sft-or-nft)) ;;false
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
    (defun UEV_AccountFreezeState (id:string sft-or-nft:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Frozen id sft-or-nft account))
            )
            (enforce (= x state) (format "Frozen for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountExemptionState (id:string sft-or-nft:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Exemption id sft-or-nft account))
            )
            (enforce (= x state) (format "Exemption Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountBurnState (id:string sft-or-nft:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Burn id sft-or-nft account))
            )
            (enforce (= x state) (format "NFT Burn Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountUpdateState (id:string sft-or-nft:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Update id sft-or-nft account))
            )
            (enforce (= x state) (format "NFT Update Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountModifyCreatorState (id:string sft-or-nft:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-ModifyCreator id sft-or-nft account))
            )
            (enforce (= x state) (format "Modify Creator Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountModifyRoyaltiesState (id:string sft-or-nft:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-ModifyRoyalties id sft-or-nft account))
            )
            (enforce (= x state) (format "Modify Royalties Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountTransferState (id:string sft-or-nft:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Transfer id sft-or-nft account))
            )
            (enforce (= x state) (format "Transfer Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountCreateState (id:string sft-or-nft:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Create id sft-or-nft account))
            )
            (enforce (= x state) (format "Create Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountRecreateState (id:string sft-or-nft:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Recreate id sft-or-nft account))
            )
            (enforce (= x state) (format "Recreate Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountSetUriState (id:string sft-or-nft:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-SetUri id sft-or-nft account))
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
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
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
    ;;{F3}  [UDC]
    ;;Properties UDCs
    (defun UDC_AllProperties:object{DPSF|PropertiesSchema}
        (   
            sft-or-nft:bool a:bool 
            b:[object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}]
            c:object{DemiourgosPactDigitalCollectibles.DPDC|PropertiesSchema}
            d:[object{DemiourgosPactDigitalCollectibles.DPDC|Set}]
            e:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
        )
        @doc "Does not appear in Interface"
        (if sft-or-nft
            {"exist"            : a
            ,"sft"              : b
            ,"sft-specs"        : c
            ,"sft-sets"         : d
            ,"existing-roles"   : e}
            {"exist"            : a
            ,"nft"              : b
            ,"nft-specs"        : c
            ,"nft-sets"         : d
            ,"existing-roles"   : e}
        )
    )
    (defun UDC_Properties:object{DemiourgosPactDigitalCollectibles.DPDC|PropertiesSchema}
        (
            owner-konto:string creator-konto:string name:string ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
            is-paused:bool nonces-used:integer
        )
        {"owner-konto"                  : owner-konto
        ,"creator-konto"                : creator-konto
        ,"name"                         : name
        ,"ticker"                       : ticker
        ,"can-upgrade"                  : can-upgrade
        ,"can-change-owner"             : can-change-owner
        ,"can-change-creator"           : can-change-creator
        ,"can-add-special-role"         : can-add-special-role
        ,"can-transfer-nft-create-role" : can-transfer-nft-create-role
        ,"can-freeze"                   : can-freeze
        ,"can-wipe"                     : can-wipe
        ,"can-pause"                    : can-pause
        ,"is-paused"                    : is-paused
        ,"nonces-used"                  : nonces-used}
    )
    (defun UDC_Control:object{DemiourgosPactDigitalCollectibles.DPDC|PropertiesSchema}
        (id:string sft-or-nft:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        (UDC_Properties
            (UR_OwnerKonto id sft-or-nft)
            (UR_CreatorKonto id sft-or-nft)
            (UR_Name id sft-or-nft)
            (UR_Ticker id sft-or-nft)
            cu cco ccc casr ctncr cf cw cp
            (UR_IsPaused id sft-or-nft)
            (UR_NoncesUsed id sft-or-nft)
        )
    )
    (defun UDC_ExistingRoles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
        (a:[string] b:[string] c:[string] d:[string] e:[string] f:[string] g:[string] h:[string] i:[string] j:[string] k:[string])
        {"a-frozen"                 : a
        ,"r-exemption"              : b
        ,"r-nft-add-quantity"       : c
        ,"r-nft-burn"               : d
        ,"r-nft-create"             : e
        ,"r-nft-recreate"           : f
        ,"r-nft-update"             : g
        ,"r-modify-creator"         : h
        ,"r-modify-royalties"       : i
        ,"r-set-new-uri"            : j
        ,"r-transfer"               : k}
    )
    ;;Account UDCs
    (defun UDC_AllBalanceSFT:object{DPSF|BalanceSchema}
        (
            a:bool b:[integer] c:[integer]
            d:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema} e:bool
        )
        @doc "Does not appear in Interface"
        {"exist"                    : a
        ,"owned-nonces"             : b
        ,"nonces-balances"          : c
        ,"roles"                    : d
        ,"role-nft-add-quantity"    : e}
    )
    (defun UDC_AllBalanceNFT:object{DPNF|BalanceSchema}
        (
            a:bool b:[integer] 
            c:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
        )
        @doc "Does not appear in Interface"
        {"exist"                    : a
        ,"owned-nonces"             : b
        ,"roles"                    : c}
    )
    (defun UDC_AccountRoles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema} 
        (f:bool re:bool rnb:bool rnc:bool rnr:bool rnu:bool rmc:bool rmr:bool rsnu:bool rt:bool)
        {"frozen"                       : f
        ,"role-exemption"               : re
        ,"role-nft-burn"                : rnb
        ,"role-nft-create"              : rnc
        ,"role-nft-recreate"            : rnr
        ,"role-nft-update"              : rnu
        ,"role-modify-creator"          : rmc
        ,"role-modify-royalties"        : rmr
        ,"role-set-new-uri"             : rsnu
        ,"role-transfer"                : rt}
    )
    (defun UDC_NonceElement:object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema} 
        (   
            a:integer b:integer c:integer 
            d:object{DemiourgosPactDigitalCollectibles.DC|DataSchema}
            e:object{DemiourgosPactDigitalCollectibles.DC|DataSchema}
        )
        {"nonce-set-class"  : a
        ,"nonce-value"      : b
        ,"nonce-supply"     : c
        ,"nonce-data"       : d
        ,"split-data"       : e}
    )
    (defun UDC_DataDC:object{DemiourgosPactDigitalCollectibles.DC|DataSchema} 
        (
            royalty:decimal ignis:decimal name:string description:string meta-data:[object]
            asset-type:object{DemiourgosPactDigitalCollectibles.DC|URI|Type}
            uri-primary:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
            uri-secondary:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
            uri-tertiary:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
        )
        {"royalty"          : royalty
        ,"ignis"            : ignis
        ,"name"             : name
        ,"description"      : description
        ,"meta-data"        : meta-data
        ,"asset-type"       : asset-type
        ,"uri-primary"      : uri-primary
        ,"uri-secondary"    : uri-secondary
        ,"uri-tertiary"     : uri-tertiary}
    )
    (defun UDC_UriType:object{DemiourgosPactDigitalCollectibles.DC|URI|Type}
        (a:bool b:bool c:bool d:bool e:bool f:bool g:bool)
        {"image"    : a
        ,"audio"    : b
        ,"video"    : c
        ,"document" : d
        ,"archive"  : e
        ,"model"    : f
        ,"exotic"   : g}
    )
    (defun UDC_UriString:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
        (a:string b:string c:string d:string e:string f:string g:string)
        {"image"    : a
        ,"audio"    : b
        ,"video"    : c
        ,"document" : d
        ,"archive"  : e
        ,"model"    : f
        ,"exotic"   : g}
    )
    ;;
    (defun UDC_SetSingleElement:object{DemiourgosPactDigitalCollectibles.DPDC|SetSingleElement}
        (set-class:integer set-nonce:integer)
        {"set-class"    : set-class
        ,"set-nonce"    : set-nonce}
    )
    (defun UDC_SetElement:object{DemiourgosPactDigitalCollectibles.DPDC|SetElement}
        (input:[object{DemiourgosPactDigitalCollectibles.DPDC|SetSingleElement}])
        {"set-element"  : input}
    )
    (defun UDC_Set:object{DemiourgosPactDigitalCollectibles.DPDC|Set}
        (   
            class:integer name:string active:bool
            set:[object{DemiourgosPactDigitalCollectibles.DPDC|SetElement}]
        )
        {"class"    : class
        ,"name"     : name
        ,"active"   : active
        ,"set"      : set}
    )
    (defun UDC_Score:object{DemiourgosPactDigitalCollectibles.DPDC|Score} (score:decimal)
        {"score"    : score}
    )
    ;;Empty UDCs
    (defun UDC_NonceZeroElement:object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema} ()
        (UDC_NonceElement 0 0 0 (UDC_EmptyDataDC) (UDC_EmptyDataDC))
    )
    (defun UDC_EmptyDataDC:object{DemiourgosPactDigitalCollectibles.DC|DataSchema} ()
        (let
            (
                (z:decimal 0.0)
                (eut:object{DemiourgosPactDigitalCollectibles.DC|URI|Type} (UDC_EmptyUriType))
                (eus:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema} (UDC_EmptyUriString))
            )
            (UDC_DataDC z z BAR BAR [{}] eut eus eus eus)
        )
    )
    (defun UDC_EmptyUriType:object{DemiourgosPactDigitalCollectibles.DC|URI|Type} ()
        (UDC_UriType false false false false false false false)
    )
    (defun UDC_EmptyUriString:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema} ()
        (UDC_UriString BAR BAR BAR BAR BAR BAR BAR)
    )
    (defun UDC_ZeroSet:object{DemiourgosPactDigitalCollectibles.DPDC|Set} ()
        {"class"    : 0
        ,"name"     : "ZERO"
        ,"active"   : false
        ,"set"      : [{"set-element" : [(UDC_SetSingleElement 0 0)]}]}
    )
    (defun UDC_NoScore:object{DemiourgosPactDigitalCollectibles.DPDC|Score} ()
        (UDC_Score -1.0)
    )
    ;;
    ;;{F4}  [CAP]
    (defun CAP_Owner (id:string sft-or-nft:bool)
        @doc "Enforces DPSF or DPNF Token ID Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (UR_OwnerKonto id sft-or-nft))
        )
    )
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_UpdatePendingBranding:object{OuronetDalosV3.OutputCumulatorV2}
        (entity-id:string sft-or-nft:bool logo:string description:string website:string social:[object{Branding.SocialSchema}])
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-BRD:module{Branding} BRD)
                (owner:string (UR_OwnerKonto entity-id sft-or-nft))
                (multiplier:decimal (if sft-or-nft 4.0 5.0))
            )
            (with-capability (DPDC|C>UPDATE-BRD entity-id sft-or-nft)
                (ref-BRD::XE_UpdatePendingBranding entity-id logo description website social)
                (ref-DALOS::UDC_BrandingCumulatorV2 owner multiplier)
            )
        )
    )
    (defun C_UpgradeBranding (patron:string entity-id:string sft-or-nft:bool months:integer)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-BRD:module{Branding} BRD)
                (owner:string (UR_OwnerKonto entity-id sft-or-nft))
                (kda-payment:decimal
                    (with-capability (DPDC|C>UPGRADE-BRD entity-id sft-or-nft)
                        (ref-BRD::XE_UpgradeBranding entity-id owner months)
                    )
                )
            )
            (ref-DALOS::KDA|C_CollectWT patron kda-payment false)
        )
    )
    ;;
    (defun C_DeployAccountSFT (id:string account:string)
        (XB_DeployAccountSFT id account false false false false false false false false false false false)
    )
    (defun C_DeployAccountNFT (id:string account:string)
        (XB_DeployAccountNFT id account false false false false false false false false false false)
    )
    ;;
    ;;{F7}  [X]
    (defun XE_InsertNewCollection
        (   
            id:string sft-or-nft:bool
            b:[object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}]
            c:object{DemiourgosPactDigitalCollectibles.DPDC|PropertiesSchema}
            d:[object{DemiourgosPactDigitalCollectibles.DPDC|Set}]
            e:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
        )
        (UEV_IMC)
        (if sft-or-nft
            (insert DPSF|PropertiesTable id
                (UDC_AllProperties sft-or-nft true b c d e)
            )
            (insert DPNF|PropertiesTable id
                (UDC_AllProperties sft-or-nft true b c d e)
            )
        )
    )
    ;;Pure Update Functions
    (defun XE_UP|SftOrNft (id:string sft-or-nft:bool sft-and-nft:[object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}])
        (UEV_IMC)
        (if sft-or-nft
            (update DPSF|PropertiesTable id
                { "sft"                 : sft-and-nft}
            )
            (update DPNF|PropertiesTable id
                { "nft"                 : sft-and-nft}
            )
        )
    )
    (defun XB_UP|Specs (id:string sft-or-nft:bool specs:object{DemiourgosPactDigitalCollectibles.DPDC|PropertiesSchema})
        (UEV_IMC)
        (if sft-or-nft
            (update DPSF|PropertiesTable id
                { "sft-specs"           : specs}
            )
            (update DPNF|PropertiesTable id
                { "nft-specs"           : specs}
            )
        )
    )
    (defun XB_UP|Sets (id:string sft-or-nft:bool sets:[object{DemiourgosPactDigitalCollectibles.DPDC|Set}])
        (UEV_IMC)
        (if sft-or-nft
            (update DPSF|PropertiesTable id
                { "sft-sets"            : sets}
            )
            (update DPNF|PropertiesTable id
                { "nft-sets"            : sets}
            )
        )
    )
    (defun XB_UP|ExistingRoles (id:string sft-or-nft:bool er:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema})
        (UEV_IMC)
        (if sft-or-nft
            (update DPSF|PropertiesTable id
                { "existing-roles"      : er}
            )
            (update DPNF|PropertiesTable id
                { "existing-roles"      : er}
            )
        )
    )
    ;;
    (defun XE_UAD|OwnedNonces (id:string sft-or-nft:bool account:string owned-nonces:[integer])
        (UEV_IMC)
        (if sft-or-nft
            (update DPSF|BalanceTable (concat [id BAR account])
                { "owned-nonces"        : owned-nonces}
            )
            (update DPNF|BalanceTable (concat [id BAR account])
                { "owned-nonces"        : owned-nonces}
            )
        )
    )
    (defun XE_UAD|NoncesBalances (id:string account:string nonces-balances:[integer])
        (UEV_IMC)
        (update DPSF|BalanceTable (concat [id BAR account])
            { "nonces-balances"         : nonces-balances}
        )
    )
    (defun XB_UAD|Roles (id:string sft-or-nft:bool account:string roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema})
        (UEV_IMC)
        (if sft-or-nft
            (update DPSF|BalanceTable (concat [id BAR account])
                { "roles"               : roles}
            )
            (update DPNF|BalanceTable (concat [id BAR account])
                { "roles"               : roles}
            )
        )
    )
    (defun XB_UAD|Rnaq (id:string account:string role-nft-add-quantity:bool)
        (UEV_IMC)
        (update DPSF|BalanceTable (concat [id BAR account])
            { "role-nft-add-quantity"   : role-nft-add-quantity}
        )
    )
    ;;
    (defun XB_DeployAccountSFT
        (
            id:string account:string
            input-rnaq:bool f:bool re:bool rnb:bool rnc:bool rnr:bool
            rnu:bool rmc:bool rmr:bool rsnu:bool rt:bool
        )
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id true)
            (with-default-read DPSF|BalanceTable (concat [id BAR account])
                (UDC_AllBalanceSFT true [0] [0] (UDC_AccountRoles f re rnb rnc rnr rnu rmc rmr rsnu rt) input-rnaq)
                {"exist"                        := e
                ,"owned-nonces"                 := on
                ,"nonces-balances"              := nb
                ,"roles"                        := r
                ,"role-nft-add-quantity"        := rnaq}
                (write DPSF|BalanceTable (concat [id BAR account])
                    (UDC_AllBalanceSFT e on nb r rnaq)
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
                (ref-DALOS:module{OuronetDalosV3} DALOS)
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id false)
            (with-default-read DPNF|BalanceTable (concat [id BAR account])
                (UDC_AllBalanceNFT true [0] (UDC_AccountRoles f re rnb rnc rnr rnu rmc rmr rsnu rt))
                {"exist"                        := e
                ,"owned-nonces"                 := on
                ,"roles"                        := r}
                (write DPNF|BalanceTable (concat [id BAR account])
                    (UDC_AllBalanceNFT e on r)
                )
            )
        )
    )
    (defun XE_DeployAccountWNE (id:string sft-or-nft:bool account:string)
        (let
            (
                (collection-account-exists:bool (UR_CA|Exists id sft-or-nft account))
            )
            (if (not collection-account-exists)
                (if sft-or-nft
                    (C_DeployAccountSFT id account)
                    (C_DeployAccountNFT id account)
                )
                true
            )
        )
    )
    ;;Interal Auxiliary
    
    ;;
)

(create-table P|T)
(create-table P|MT)
(create-table DPSF|PropertiesTable)
(create-table DPSF|BalanceTable)
(create-table DPNF|PropertiesTable)
(create-table DPNF|BalanceTable)