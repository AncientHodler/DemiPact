(module DPDC GOV
    ;;
    (implements OuronetPolicy)
    (implements BrandingUsageV4)
    (implements DemiourgosPactDigitalCollectibles)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC           (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|DPDC_ADMIN)))
    (defcap GOV|DPDC_ADMIN ()       (enforce-guard GOV|MD_DPDC))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV2} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV2} DALOS)) (ref-DALOS::P|Info)))
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
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    ;;{C3}
    (defcap DPDC|S>CTRL (id:string sft-or-nft:bool)
        @event
        (CAP_Owner id sft-or-nft)
        (UEV_CanUpgradeON id sft-or-nft)
    )
    (defcap DPDC|S>TG_PAUSE (id:string sft-or-nft:bool toggle:bool)
        @event
        (if toggle
            (UEV_CanPauseON id sft-or-nft)
            true
        )
        (UEV_PauseState id sft-or-nft (not toggle))
        (CAP_Owner id sft-or-nft)
    )
    (defcap DPDC|S>TG_ADD-QTY-R (id:string account:string toggle:bool)
        @event
        (UEV_ToggleSpecialRole id true toggle)
        (UEV_AccountAddQuantityState id account (not toggle))
        (CAP_Owner id true)
    )
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
    (defcap DPDC|C>ISSUE (account:string creator-account:string collection-name:string collection-ticker:string)
        @event
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                (ref-DALOS:module{OuronetDalosV2} DALOS)
            )
            (ref-U|DALOS::UEV_NameOrTicker collection-name true false)
            (ref-U|DALOS::UEV_NameOrTicker collection-ticker false false)
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (ref-DALOS::UEV_EnforceAccountType creator-account false)
            (compose-capability (P|SECURE-CALLER))
        )
    )
    (defcap DPDC|C>FRZ-ACC (id:string sft-or-nft:bool account:string frozen:bool)
        @event
        (UEV_CanFreezeON id sft-or-nft)
        (UEV_AccountFreezeState id sft-or-nft account (not frozen))
        (CAP_Owner id sft-or-nft)
        (compose-capability (SECURE))
    )
    (defcap DPDC|C>TG_BURN-R (id:string sft-or-nft:bool account:string toggle:bool)
        @event
        (UEV_ToggleSpecialRole id sft-or-nft toggle)
        (UEV_AccountBurnState id sft-or-nft account (not toggle))
        (CAP_Owner id sft-or-nft)
        (compose-capability (SECURE))
    )
    (defcap DPDC|C>TG_UPDATE-R (id:string sft-or-nft:bool account:string toggle:bool)
        @event
        (UEV_ToggleSpecialRole id sft-or-nft toggle)
        (UEV_AccountUpdateState sft-or-nft id account (not toggle))
        (CAP_Owner id sft-or-nft)
        (compose-capability (SECURE))
    )
    (defcap DPDC|C>TG_MODIFY-CREATOR-R (id:string sft-or-nft:bool account:string toggle:bool)
        @event
        (UEV_ToggleSpecialRole id sft-or-nft toggle)
        (UEV_AccountModifyCreatorState id sft-or-nft account (not toggle))
        (CAP_Owner id sft-or-nft)
        (compose-capability (SECURE))
    )
    (defcap DPDC|C>TG_MODIFY-ROYALTIES-R (id:string sft-or-nft:bool account:string toggle:bool)
        @event
        (UEV_ToggleSpecialRole id sft-or-nft toggle)
        (UEV_AccountModifyRoyaltiesState id sft-or-nft account (not toggle))
        (CAP_Owner id sft-or-nft)
        (compose-capability (SECURE))
    )
    (defcap DPDC|C>TG_TRANSFER-R (id:string sft-or-nft:bool account:string toggle:bool)
        @event
        (UEV_ToggleSpecialRole id sft-or-nft toggle)
        (UEV_AccountTransferState id sft-or-nft account (not toggle))
        (CAP_Owner id sft-or-nft)
        (compose-capability (SECURE))
    )
    (defcap DPDC|C>MV_CREATE-R (id:string sft-or-nft:bool old-account:string new-account:string)
        @event
        (UEV_CanAddSpecialRoleON id sft-or-nft)
        (UEV_AccountCreateState id sft-or-nft old-account true)
        (UEV_AccountCreateState id sft-or-nft new-account false)
        (CAP_Owner id sft-or-nft)
        (compose-capability (SECURE))
    )
    (defcap DPDC|C>MV_RECREATE-R (id:string sft-or-nft:bool old-account:string new-account:string)
        @event
        (UEV_CanAddSpecialRoleON id sft-or-nft)
        (UEV_AccountRecreateState id sft-or-nft old-account true)
        (UEV_AccountRecreateState id sft-or-nft new-account false)
        (CAP_Owner id sft-or-nft)
        (compose-capability (SECURE))
    )
    (defcap DPDC|C>MV_SET-URI-R (id:string sft-or-nft:bool old-account:string new-account:string)
        @event
        (UEV_CanAddSpecialRoleON id sft-or-nft)
        (UEV_AccountSetUriState id sft-or-nft old-account true)
        (UEV_AccountSetUriState id sft-or-nft new-account false)
        (CAP_Owner id sft-or-nft)
        (compose-capability (SECURE))
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;Read Nonces
    (defun UR_NonceSupply:integer (dpsf-id:string nonce:integer)
        (UEV_Nonce dpsf-id true nonce)
        (at "nonce-supply" (at nonce (UR_ElementsSFT dpsf-id)))
    )
    (defun UR_NonceRoyalty:decimal (id:string sft-or-nft:bool nonce:integer)
        (UEV_Nonce id sft-or-nft nonce)
        (if sft-or-nft
            (at "royalty" (at "nonce-data" (at nonce (UR_ElementsSFT id))))
            (at "royalty" (at "nonce-data" (at nonce (UR_ElementsNFT id))))
        )
    )
    (defun UR_NonceIgnis:decimal (id:string sft-or-nft:bool nonce:integer)
        (UEV_Nonce id sft-or-nft nonce)
        (if sft-or-nft
            (at "ignis" (at "nonce-data" (at nonce (UR_ElementsSFT id))))
            (at "ignis" (at "nonce-data" (at nonce (UR_ElementsNFT id))))
        )
    )
    (defun UR_NonceDescription:string (id:string sft-or-nft:bool nonce:integer)
        (UEV_Nonce id sft-or-nft nonce)
        (if sft-or-nft
            (at "description" (at "nonce-data" (at nonce (UR_ElementsSFT id))))
            (at "description" (at "nonce-data" (at nonce (UR_ElementsNFT id))))
        )
    )
    (defun UR_NonceMetaData:[object] (id:string sft-or-nft:bool nonce:integer)
        (UEV_Nonce id sft-or-nft nonce)
        (if sft-or-nft
            (at "meta-data" (at "nonce-data" (at nonce (UR_ElementsSFT id))))
            (at "meta-data" (at "nonce-data" (at nonce (UR_ElementsNFT id))))
        )
    )
    (defun UR_NonceAssetType:object{DemiourgosPactDigitalCollectibles.DC|URI|Type} 
        (id:string sft-or-nft:bool nonce:integer)
        (UEV_Nonce id sft-or-nft nonce)
        (if sft-or-nft
            (at "asset-type" (at "nonce-data" (at nonce (UR_ElementsSFT id))))
            (at "asset-type" (at "nonce-data" (at nonce (UR_ElementsNFT id))))
        )
    )
    (defun UR_NonceUriOne:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
        (id:string sft-or-nft:bool nonce:integer)
        (UEV_Nonce id sft-or-nft nonce)
        (if sft-or-nft
            (at "uri-primary" (at "nonce-data" (at nonce (UR_ElementsSFT id))))
            (at "uri-primary" (at "nonce-data" (at nonce (UR_ElementsNFT id))))
        )
    )
    (defun UR_NonceUriTwo:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema} 
        (id:string sft-or-nft:bool nonce:integer)
        (UEV_Nonce id sft-or-nft nonce)
        (if sft-or-nft
            (at "uri-secondary" (at "nonce-data" (at nonce (UR_ElementsSFT id))))
            (at "uri-secondary" (at "nonce-data" (at nonce (UR_ElementsNFT id))))
        )
    )
    (defun UR_NonceUriThree:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema} 
        (id:string sft-or-nft:bool nonce:integer)
        (UEV_Nonce id sft-or-nft nonce)
        (if sft-or-nft
            (at "uri-tertiary" (at "nonce-data" (at nonce (UR_ElementsSFT id))))
            (at "uri-tertiary" (at "nonce-data" (at nonce (UR_ElementsNFT id))))
        )
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
        (enforce (!= nonce 0) "Invalid Nonce Value")
        (let
            (
                (read-nonce:integer
                    (if sft-or-nft
                        (at "nonce-value" (at nonce (UR_ElementsSFT id)))
                        (at "nonce-value" (at nonce (UR_ElementsNFT id)))
                    )
                )
            )
            (enforce (= read-nonce nonce) "Invalid DPDC Structure")
        )
    )
    (defun UEV_NonceExists (id:string sft-or-nft:bool nonce:integer)
        (let
            (
                (existing-nonces:[object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}]
                    (if sft-or-nft
                        (UR_ElementsSFT id)
                        (UR_ElementsNFT id)
                    )
                )
                (l:integer (length existing-nonces))
            )
            (enforce (< nonce l) (format "Nonce {} doesnt exist for {} {}" [nonce (if sft-or-nft "SFT" "NFT") id]))
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
                (x:bool (UR_CA|R-Recreate id sft-or-nft account))
            )
            (enforce (= x state) (format "Set Uri Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    ;;{F3}  [UDC]
    ;;Properties UDCs
    (defun UDC_AllProperties:object{DPSF|PropertiesSchema}
        (   
            sft-or-nft:bool a:bool 
            b:[object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}]
            c:object{DemiourgosPactDigitalCollectibles.DPDC|PropertiesSchema}
            d:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
        )
        @doc "Does not appear in Interface"
        (if sft-or-nft
            {"exist"            : a
            ,"sft"              : b
            ,"sft-specs"        : c
            ,"existing-roles"   : d}
            {"exist"            : a
            ,"nft"              : b
            ,"nft-specs"        : c
            ,"existing-roles"   : d}
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
        (a:[string] b:[string] c:[string] d:[string] e:[string] f:[string] g:[string] h:[string] i:[string] j:[string])
        {"a-frozen"                 : a
        ,"r-nft-add-quantity"       : b
        ,"r-nft-burn"               : c
        ,"r-nft-create"             : d
        ,"r-nft-recreate"           : e
        ,"r-nft-update"             : f
        ,"r-modify-creator"         : g
        ,"r-modify-royalties"       : h
        ,"r-set-new-uri"            : i
        ,"r-transfer"               : j}
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
        (f:bool rnb:bool rnc:bool rnr:bool rnu:bool rmc:bool rmr:bool rsnu:bool rt:bool)
        {"frozen"                       : f
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
        (a:integer b:integer c:object{DemiourgosPactDigitalCollectibles.DC|DataSchema})
        {"nonce-value"      : a
        ,"nonce-supply"     : b
        ,"nonce-data"       : c}
    )
    (defun UDC_DataDC:object{DemiourgosPactDigitalCollectibles.DC|DataSchema} 
        (
            royalty:decimal ignis:decimal description:string meta-data:[object]
            asset-type:object{DemiourgosPactDigitalCollectibles.DC|URI|Type}
            uri-primary:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
            uri-secondary:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
            uri-tertiary:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
        )
        {"royalty"          : royalty
        ,"ignis"            : ignis
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
    ;;Empty UDCs
    (defun UDC_NonceZeroElement:object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema} ()
        (UDC_NonceElement 0 0 (UDC_EmptyDataDC))
    )
    (defun UDC_EmptyDataDC:object{DemiourgosPactDigitalCollectibles.DC|DataSchema} ()
        (let
            (
                (z:decimal 0.0)
                (eut:object{DemiourgosPactDigitalCollectibles.DC|URI|Type} (UDC_EmptyUriType))
                (eus:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema} (UDC_EmptyUriString))
            )
            (UDC_DataDC z z BAR [{}] eut eus eus eus)
        )
    )
    (defun UDC_EmptyUriType:object{DemiourgosPactDigitalCollectibles.DC|URI|Type} ()
        (UDC_UriType false false false false false false false)
    )
    (defun UDC_EmptyUriString:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema} ()
        (UDC_UriString BAR BAR BAR BAR BAR BAR BAR)
    )
    ;;
    ;;{F4}  [CAP]
    (defun CAP_Owner (id:string sft-or-nft:bool)
        @doc "Enforces DPSF or DPNF Token ID Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (UR_OwnerKonto id sft-or-nft))
        )
    )
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_UpdatePendingBranding:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string entity-id:string sft-or-nft:bool logo:string description:string website:string social:[object{Branding.SocialSchema}])
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
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
                (ref-DALOS:module{OuronetDalosV2} DALOS)
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
    (defun C_Control:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string id:string sft-or-nft:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
                (owner:string (UR_OwnerKonto id sft-or-nft))
            )
            (with-capability (DPDC|S>CTRL id sft-or-nft)
                (XI_Control id sft-or-nft cu cco ccc casr ctncr cf cw cp)
                (if sft-or-nft
                    (ref-DALOS::UDC_BigCumulatorV2 owner)
                    (ref-DALOS::UDC_BiggestCumulatorV2 owner)
                )
            )
        )
    )
    (defun C_DeployAccountSFT (id:string account:string)
        (UEV_IMC)
        (with-capability (SECURE)
            (XI_DeployAccountSFT id account false false false false false false false false false false)
        )
    )
    (defun C_DeployAccountNFT (id:string account:string)
        (UEV_IMC)
        (with-capability (SECURE)
            (XI_DeployAccountNFT id account false false false false false false false false false)
        )
    )
    (defun C_IssueDigitalCollection:object{OuronetDalosV2.OutputCumulatorV2}
        (
            patron:string sft-or-nft:bool
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
        (UEV_IMC)
        (with-capability (DPDC|C>ISSUE owner-account creator-account collection-name collection-ticker)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV2} DALOS)
                    (ref-BRD:module{Branding} BRD)

                    (multiplier:decimal (if sft-or-nft 5.0 10.0))
                    (ti:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                    (ignis-price:decimal (* ti multiplier))
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))

                    (kda-cost:decimal
                        (if sft-or-nft
                            (ref-DALOS::UR_UsagePrice "dpsf")
                            (ref-DALOS::UR_UsagePrice "dpsf")
                        )
                    )
                    (id:string
                        (XI_IssueDigitalCollection
                            sft-or-nft
                            owner-account creator-account collection-name collection-ticker
                            can-upgrade can-change-owner can-change-creator can-add-special-role 
                            can-transfer-nft-create-role can-freeze can-wipe can-pause
                        )
                    )
                )
                (ref-BRD::XE_Issue id)
                ;;Deploy Collection Accounts for Owner and Creator
                (if sft-or-nft
                    (do
                        (XI_DeployAccountSFT id owner-account true false false true true false false false true false)
                        (C_DeployAccountSFT id creator-account)
                    )
                    (do
                        (XI_DeployAccountNFT id owner-account false false true true false false false true false)
                        (C_DeployAccountNFT id creator-account)
                    )
                )
                (ref-DALOS::KDA|C_Collect patron kda-cost)
                (ref-DALOS::UDC_ConstructOutputCumulatorV2 ignis-price owner-account trigger [id])
            )
        )
    )
    (defun C_TogglePause:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string id:string sft-or-nft:bool toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
            )
            (with-capability (DPDC|S>TG_PAUSE id sft-or-nft toggle)
                (XI_TogglePause id sft-or-nft toggle)
                (ref-DALOS::UDC_MediumCumulatorV2 (UR_OwnerKonto id sft-or-nft))
            )
        )
    )
    ;;Role Toggling
    (defun C_ToggleAddQuantityRole:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string id:string account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
            )
            (with-capability (SECURE)
                (XI_DeployAccountWNE id true account)
            )
            (with-capability (DPDC|S>TG_ADD-QTY-R id account toggle)
                (XI_ToggleAddQuantityRole id account toggle)
            )
            (ref-DALOS::UDC_BigCumulatorV2 (UR_OwnerKonto id true))
        )
    )
    (defun C_ToggleFreezeAccount:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string id:string sft-or-nft:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
            )
            (with-capability (SECURE)
                (XI_DeployAccountWNE id sft-or-nft account)
            )
            (with-capability (DPDC|C>FRZ-ACC id sft-or-nft account toggle)
                (XI_ToggleFreezeAccount id account toggle)
            )
            (ref-DALOS::UDC_BiggestCumulatorV2 (UR_OwnerKonto id sft-or-nft))
        )
    )
    (defun C_ToggleBurnRole:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string id:string sft-or-nft:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
            )
            (with-capability (SECURE)
                (XI_DeployAccountWNE id sft-or-nft account)
            )
            (with-capability (DPDC|C>TG_BURN-R id sft-or-nft account toggle)
                (XI_ToggleBurnRole id sft-or-nft account toggle)
            )
            (ref-DALOS::UDC_BigCumulatorV2 (UR_OwnerKonto id sft-or-nft))
        )
    )
    (defun C_ToggleUpdateRole:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string id:string sft-or-nft:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
            )
            (with-capability (SECURE)
                (XI_DeployAccountWNE id sft-or-nft account)
            )
            (with-capability (DPDC|C>TG_UPDATE-R id sft-or-nft account toggle)
                (XI_ToggleUpdateRole id sft-or-nft account toggle)
            )
            (ref-DALOS::UDC_BigCumulatorV2 (UR_OwnerKonto id sft-or-nft))
        )
    )
    (defun C_ToggleModifyCreatorRole:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string id:string sft-or-nft:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
            )
            (with-capability (SECURE)
                (XI_DeployAccountWNE id sft-or-nft account)
            )
            (with-capability (DPDC|C>TG_MODIFY-CREATOR-R id sft-or-nft account toggle)
                (XI_ToggleModifyCreatorRole id sft-or-nft account toggle)
            )
            (ref-DALOS::UDC_BigCumulatorV2 (UR_OwnerKonto id sft-or-nft))
        )
    )
    (defun C_ToggleModifyRoyaltiesRole:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string id:string sft-or-nft:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
            )
            (with-capability (SECURE)
                (XI_DeployAccountWNE id sft-or-nft account)
            )
            (with-capability (DPDC|C>TG_MODIFY-ROYALTIES-R id sft-or-nft account toggle)
                (XI_ToggleModifyRoyaltiesRole id sft-or-nft account toggle)
            )
            (ref-DALOS::UDC_BigCumulatorV2 (UR_OwnerKonto id sft-or-nft))
        )
    )
    (defun C_ToggleTransferRole:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string id:string sft-or-nft:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
            )
            (with-capability (SECURE)
                (XI_DeployAccountWNE id sft-or-nft account)
            )
            (with-capability (DPDC|C>TG_TRANSFER-R id sft-or-nft account toggle)
                (XI_ToggleTransferRole id sft-or-nft account toggle)
            )
            (ref-DALOS::UDC_BigCumulatorV2 (UR_OwnerKonto id sft-or-nft))
        )
    )
    (defun C_MoveCreateRole:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string id:string sft-or-nft:bool new-account:string)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
                (old-account:string (at 0 (UR_ER-Create id sft-or-nft)))
            )
            (with-capability (SECURE)
                (XI_DeployAccountWNE id sft-or-nft new-account)
            )
            (with-capability (DPDC|C>MV_CREATE-R id sft-or-nft old-account new-account)
                (XI_MoveCreateRole id sft-or-nft old-account new-account)
            )
            (ref-DALOS::UDC_BiggestCumulatorV2 (UR_OwnerKonto id sft-or-nft))
        )
    )
    (defun C_MoveRecreateRole:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string id:string sft-or-nft:bool new-account:string)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
                (old-account:string (at 0 (UR_ER-Recreate id sft-or-nft)))
            )
            (with-capability (SECURE)
                (XI_DeployAccountWNE id sft-or-nft new-account)
            )
            (with-capability (DPDC|C>MV_RECREATE-R id sft-or-nft old-account new-account)
                (XI_MoveRecreateRole id sft-or-nft old-account new-account)
            )
            (ref-DALOS::UDC_BiggestCumulatorV2 (UR_OwnerKonto id sft-or-nft))
        )
    )
    (defun C_MoveSetUriRole:object{OuronetDalosV2.OutputCumulatorV2}
        (patron:string id:string sft-or-nft:bool new-account:string)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
                (old-account:string (at 0 (UR_ER-SetUri id sft-or-nft)))
            )
            (with-capability (SECURE)
                (XI_DeployAccountWNE id sft-or-nft new-account)
            )
            (with-capability (DPDC|C>MV_SET-URI-R id sft-or-nft old-account new-account)
                (XI_MoveSetUriRole id sft-or-nft old-account new-account)
            )
            (ref-DALOS::UDC_BiggestCumulatorV2 (UR_OwnerKonto id sft-or-nft))
        )
    )
    ;;{F7}  [X]
    ;;Pure Update Functions
    (defun XB_UP|SftOrNft (id:string sft-or-nft:bool sft-and-nft:[object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}])
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
    (defun XB_UAD|OwnedNonces (id:string sft-or-nft:bool account:string owned-nonces:[integer])
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
    (defun XB_UAD|NoncesBalances (id:string account:string nonces-balances:[integer])
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
    ;;Interal Auxiliary
    (defun XI_DeployAccountWNE (id:string sft-or-nft:bool account:string)
        (let
            (
                (collection-account-exists:bool (UR_CA|Exists id account true))
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
    (defun XI_DeployAccountSFT 
        (
            id:string account:string
            input-rnaq:bool f:bool rnb:bool rnc:bool rnr:bool
            rnu:bool rmc:bool rmr:bool rsnu:bool rt:bool
        )
        (require-capability (SECURE))
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id true)
            (with-default-read DPSF|BalanceTable (concat [id BAR account])
                (UDC_AllBalanceSFT true [0] [0] (UDC_AccountRoles f rnb rnc rnr rnu rmc rmr rsnu rt) input-rnaq)
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
    (defun XI_DeployAccountNFT 
        (
            id:string account:string
            f:bool rnb:bool rnc:bool rnr:bool
            rnu:bool rmc:bool rmr:bool rsnu:bool rt:bool
        )
        (require-capability (SECURE))
        (let
            (
                (ref-DALOS:module{OuronetDalosV2} DALOS)
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id false)
            (with-default-read DPNF|BalanceTable (concat [id BAR account])
                (UDC_AllBalanceNFT true [0] (UDC_AccountRoles f rnb rnc rnr rnu rmc rmr rsnu rt))
                {"exist"                        := e
                ,"owned-nonces"                 := on
                ,"roles"                        := r}
                (write DPNF|BalanceTable (concat [id BAR account])
                    (UDC_AllBalanceNFT e on r)
                )
            )
        )
    )
    (defun XI_Control (id:string sft-or-nft:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        (require-capability (DPDC|S>CTRL id sft-or-nft))
        (XB_UP|Specs id sft-or-nft (UDC_Control id sft-or-nft cu cco ccc casr ctncr cf cw cp))
    )
    (defun XI_IssueDigitalCollection:string
        (
            sft-or-nft:bool
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
        (require-capability (DPDC|C>ISSUE owner-account creator-account collection-name collection-ticker))
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                (ref-DALOS:module{OuronetDalosV2} DALOS)
                (id:string (ref-U|DALOS::UDC_Makeid collection-ticker))
                (specifications:object{DemiourgosPactDigitalCollectibles.DPDC|PropertiesSchema}
                    (UDC_Properties
                        owner-account creator-account collection-name collection-ticker
                        can-upgrade can-change-owner can-change-creator can-add-special-role
                        can-transfer-nft-create-role can-freeze can-wipe can-pause
                        false 0
                    )
                )
                (existing-roles-sft:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (UDC_ExistingRoles [BAR] [owner-account] [BAR] [owner-account] [owner-account] [BAR] [BAR] [BAR] [owner-account] [BAR])
                )
                (existing-roles-nft:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (UDC_ExistingRoles [BAR] [BAR] [BAR] [owner-account] [owner-account] [BAR] [BAR] [BAR] [owner-account] [BAR])
                )
                (zne:[object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}]
                    (UDC_NonceZeroElement)
                )
            )
            (if sft-or-nft
                (insert DPSF|PropertiesTable id
                    (UDC_AllProperties true true zne specifications existing-roles-sft)
                )
                (insert DPNF|PropertiesTable id
                    (UDC_AllProperties false true zne specifications existing-roles-nft)
                )
            )
            id 
        )
    )
    (defun XI_TogglePause (id:string sft-or-nft:bool toggle:bool)
        (require-capability (DPDC|S>TG_PAUSE id sft-or-nft toggle))
        (let
            (
                (new-specs:object{DemiourgosPactDigitalCollectibles.DPDC|PropertiesSchema}
                    (+
                        {"is-paused" : toggle}
                        (remove "is-paused" (UR_CollectionSpecs id sft-or-nft))
                    )
                )
            )
            (XB_UP|Specs id sft-or-nft new-specs)
        )
    )
    ;;
    (defun XI_ToggleAddQuantityRole (id:string account:string toggle:bool)
        (require-capability (DPDC|S>TG_ADD-QTY-R id account toggle))
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                (add-q-accounts:[string] (UR_ER-AddQuantity id))
                (updated-add-q-accounts:[string] (ref-U|DALOS::UC_NewRoleList add-q-accounts account toggle))
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-nft-add-quantity" : updated-add-q-accounts}
                        (remove "r-nft-add-quantity" (UR_CollectionRoles id true))
                    )
                )
            )
            (XB_UAD|Rnaq id account toggle)
            (XB_UP|ExistingRoles id true prp-roles)
        )
    )
    (defun XI_ToggleFreezeAccount (id:string sft-or-nft:bool account:string toggle:bool)
        (require-capability (DPDC|C>FRZ-ACC id sft-or-nft account toggle))
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                ;;
                (frozen-accounts:[string] (UR_ER-Frozen id sft-or-nft))
                (updated-frozen-accounts:[string] (ref-U|DALOS::UC_NewRoleList frozen-accounts account toggle))
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"a-frozen" : updated-frozen-accounts}
                        (remove "a-frozen" (UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"frozen"   : toggle}
                        (remove "frozen" (UR_CA|R id sft-or-nft account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRoles id sft-or-nft account prp-roles acc-roles)
        )
    )
    (defun XI_ToggleBurnRole (id:string sft-or-nft:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_BURN-R id sft-or-nft account toggle))
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                ;;
                (burn-r-accounts:[string] (UR_ER-Burn id sft-or-nft))
                (updated-burn-r-accounts:[string] (ref-U|DALOS::UC_NewRoleList burn-r-accounts account toggle))
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-nft-burn" : updated-burn-r-accounts}
                        (remove "r-nft-burn" (UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-nft-burn"   : toggle}
                        (remove "role-nft-burn" (UR_CA|R id sft-or-nft account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRoles id sft-or-nft account prp-roles acc-roles)
        )
    )
    (defun XI_ToggleUpdateRole (id:string sft-or-nft:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_UPDATE-R id sft-or-nft account toggle))
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                ;;
                (update-r-accounts:[string] (UR_ER-Update id sft-or-nft))
                (updated-update-r-accounts:[string] (ref-U|DALOS::UC_NewRoleList update-r-accounts account toggle))
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-nft-update" : updated-update-r-accounts}
                        (remove "r-nft-update" (UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-nft-update"   : toggle}
                        (remove "role-nft-update" (UR_CA|R id sft-or-nft account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRoles id sft-or-nft account prp-roles acc-roles)
        )
    )
    (defun XI_ToggleModifyCreatorRole (id:string sft-or-nft:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_MODIFY-CREATOR-R id sft-or-nft account toggle))
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                ;;
                (modc-r-accounts:[string] (UR_ER-Update id sft-or-nft))
                (updated-modc-r-accounts:[string] (ref-U|DALOS::UC_NewRoleList modc-r-accounts account toggle))
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-modify-creator" : updated-modc-r-accounts}
                        (remove "r-modify-creator" (UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-modify-creator"   : toggle}
                        (remove "role-modify-creator" (UR_CA|R id sft-or-nft account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRoles id sft-or-nft account prp-roles acc-roles)
        )
    )
    (defun XI_ToggleModifyRoyaltiesRole (id:string sft-or-nft:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_MODIFY-ROYALTIES-R id sft-or-nft account toggle))
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                ;;
                (modr-r-accounts:[string] (UR_ER-ModifyRoyalties id sft-or-nft))
                (updated-modr-r-accounts:[string] (ref-U|DALOS::UC_NewRoleList modr-r-accounts account toggle))
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-modify-royalties" : updated-modr-r-accounts}
                        (remove "r-modify-royalties" (UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-modify-royalties"   : toggle}
                        (remove "role-modify-royalties" (UR_CA|R id sft-or-nft account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRoles id sft-or-nft account prp-roles acc-roles)
        )
    )
    (defun XI_ToggleTransferRole (id:string sft-or-nft:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_TRANSFER-R id sft-or-nft account toggle))
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                ;;
                (transfer-r-accounts:[string] (UR_ER-Transfer id sft-or-nft))
                (updated-transfer-r-accounts:[string] (ref-U|DALOS::UC_NewRoleList transfer-r-accounts account toggle))
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-transfer" : updated-transfer-r-accounts}
                        (remove "r-transfer" (UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-transfer"   : toggle}
                        (remove "role-transfer" (UR_CA|R id sft-or-nft account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRoles id sft-or-nft account prp-roles acc-roles)
        )
    )
    (defun XI_MoveCreateRole (id:string sft-or-nft:bool old-account:string new-account:string)
        (require-capability (DPDC|C>MV_CREATE-R id sft-or-nft old-account new-account))
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                ;;
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-create" : [new-account]}
                        (remove "r-create" (UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (old-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-nft-create"   : false}
                        (remove "role-nft-create" (UR_CA|R id sft-or-nft old-account))
                    )
                )
                (new-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-nft-create"   : true}
                        (remove "role-nft-create" (UR_CA|R id sft-or-nft new-account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRolesSingle id sft-or-nft old-account new-account prp-roles old-acc-roles new-acc-roles)
        )
    )
    (defun XI_MoveRecreateRole (id:string sft-or-nft:bool old-account:string new-account:string)
        (require-capability (DPDC|C>MV_RECREATE-R id sft-or-nft old-account new-account))
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                ;;
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-recreate" : [new-account]}
                        (remove "r-recreate" (UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (old-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-nft-recreate"   : false}
                        (remove "role-nft-recreate" (UR_CA|R id sft-or-nft old-account))
                    )
                )
                (new-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-nft-recreate"   : true}
                        (remove "role-nft-recreate" (UR_CA|R id sft-or-nft new-account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRolesSingle id sft-or-nft old-account new-account prp-roles old-acc-roles new-acc-roles)
        )
    )
    (defun XI_MoveSetUriRole (id:string sft-or-nft:bool old-account:string new-account:string)
        (require-capability (DPDC|C>MV_SET-URI-R id sft-or-nft old-account new-account))
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                ;;
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-set-new-uri" : [new-account]}
                        (remove "r-set-new-uri" (UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (old-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-set-new-uri"   : false}
                        (remove "role-set-new-uri" (UR_CA|R id sft-or-nft old-account))
                    )
                )
                (new-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-set-new-uri"   : true}
                        (remove "role-set-new-uri" (UR_CA|R id sft-or-nft new-account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRolesSingle id sft-or-nft old-account new-account prp-roles old-acc-roles new-acc-roles)
        )
    )
    (defun XI_UpdateRolesAndExistingRolesSingle
        (
            id:string sft-or-nft:bool old-account:string new-account:string
            prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
            old-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema} 
            new-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema} 
        )
        (XI_UpdateRolesAndExistingRoles id sft-or-nft new-account prp-roles new-acc-roles)
        (XB_UAD|Roles id sft-or-nft old-account old-acc-roles)
    )
    (defun XI_UpdateRolesAndExistingRoles
        (
            id:string sft-or-nft:bool account:string 
            prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
            acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema} 
        )
        (XB_UAD|Roles id sft-or-nft account acc-roles)
        (XB_UP|ExistingRoles id sft-or-nft prp-roles)
    )
    ;;
)

(create-table P|T)
(create-table P|MT)
(create-table DPSF|PropertiesTable)
(create-table DPSF|BalanceTable)
(create-table DPNF|PropertiesTable)
(create-table DPNF|BalanceTable)