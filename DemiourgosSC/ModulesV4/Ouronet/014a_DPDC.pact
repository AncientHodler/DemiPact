(interface DemiourgosPactDigitalCollectibles
    @doc "Holds Schema for Digital Collectibles, these being the DPSF and DPNF"
    (defschema DPDC|PropertiesSchema
        owner-konto:string
        creator-konto:string
        name:string
        ticker:string
        ;;
        can-upgrade:bool
        can-change-owner:bool
        can-change-creator:bool
        can-add-special-role:bool
        can-transfer-nft-create-role:bool
        can-freeze:bool
        can-wipe:bool
        can-pause:bool
        ;;
        is-paused:bool
        nonces-used:integer
    )
    (defschema DPDC|RolesSchema
        frozen:bool                     ;; multiple
        role-exemption:bool             ;; multiple
        role-nft-burn:bool              ;; multiple
        role-nft-create:bool            ;; single
        role-nft-recreate:bool          ;; single
        role-nft-update:bool            ;; multiple
        role-modify-creator:bool        ;; multiple
        role-modify-royalties:bool      ;; multiple
        role-set-new-uri:bool           ;; single
        role-transfer:bool              ;; multiple
    )
    (defschema DPDC|RolesStorageSchema
        a-frozen:[string]
        r-exemption:[string]
        r-nft-add-quantity:[string]
        r-nft-burn:[string]
        r-nft-create:[string]
        r-nft-recreate:[string]
        r-nft-update:[string]
        r-modify-creator:[string]
        r-modify-royalties:[string]
        r-set-new-uri:[string]
        r-transfer:[string]
    )
    ;;
    (defschema DC|DataSchema
        royalty:decimal
        ignis:decimal
        description:string
        meta-data:[object]
        asset-type:object{DC|URI|Type}
        uri-primary:object{DC|URI|Schema}
        uri-secondary:object{DC|URI|Schema}
        uri-tertiary:object{DC|URI|Schema}
    )
    (defschema DC|URI|Schema
        image:string
        audio:string
        video:string
        document:string
        archive:string
        model:string
        exotic:string
    )
    (defschema DC|URI|Type
        image:bool
        audio:bool
        video:bool
        document:bool
        archive:bool
        model:bool
        exotic:bool
    )
    (defschema DPDC|NonceElementSchema
        nonce-value:integer
        nonce-supply:integer
        nonce-data:object{DC|DataSchema}
    )
    ;;
    ;;
    (defun UR_NonceSupply:integer (dpsf-id:string nonce:integer))
    (defun UR_NonceRoyalty:decimal (id:string sft-or-nft:bool nonce:integer))
    (defun UR_NonceIgnis:decimal (id:string sft-or-nft:bool nonce:integer))
    (defun UR_NonceDescription:string (id:string sft-or-nft:bool nonce:integer))
    (defun UR_NonceMetaData:[object] (id:string sft-or-nft:bool nonce:integer))
    (defun UR_NonceAssetType:object{DC|URI|Type} (id:string sft-or-nft:bool nonce:integer))
    (defun UR_NonceUriOne:object{DC|URI|Schema} (id:string sft-or-nft:bool nonce:integer))
    (defun UR_NonceUriTwo:object{DC|URI|Schema} (id:string sft-or-nft:bool nonce:integer))
    (defun UR_NonceUriThree:object{DC|URI|Schema} (id:string sft-or-nft:bool nonce:integer))
    ;;
    (defun UR_C|Exists:bool (id:string sft-or-nft:bool))
    (defun UR_ElementsSFT:[object{DPDC|NonceElementSchema}] (id:string))
    (defun UR_ElementsNFT:[object{DPDC|NonceElementSchema}] (id:string))
    (defun UR_CollectionSpecs:object{DPDC|PropertiesSchema} (id:string sft-or-nft:bool))
    (defun UR_CollectionRoles:object{DPDC|RolesStorageSchema} (id:string sft-or-nft:bool))
        ;;
    (defun UR_OwnerKonto:string (id:string sft-or-nft:bool))
    (defun UR_CreatorKonto:string (id:string sft-or-nft:bool))
    (defun UR_Name:string (id:string sft-or-nft:bool))
    (defun UR_Ticker:string (id:string sft-or-nft:bool))
    (defun UR_CanUpgrade:bool (id:string sft-or-nft:bool))
    (defun UR_CanChangeOwner:bool (id:string sft-or-nft:bool))
    (defun UR_CanChangeCreator:bool (id:string sft-or-nft:bool))
    (defun UR_CanAddSpecialRole:bool (id:string sft-or-nft:bool))
    (defun UR_CanTransferNftCreateRole:bool (id:string sft-or-nft:bool))
    (defun UR_CanFreeze:bool (id:string sft-or-nft:bool))
    (defun UR_CanWipe:bool (id:string sft-or-nft:bool))
    (defun UR_CanPause:bool (id:string sft-or-nft:bool))
    (defun UR_IsPaused:bool (id:string sft-or-nft:bool))
    (defun UR_NoncesUsed:integer (id:string sft-or-nft:bool))
    ;;
    (defun UR_ER-AddQuantity:[string] (id:string))
    (defun UR_ER-Frozen:[string] (id:string sft-or-nft:bool))
    (defun UR_ER-Exemption:[string] (id:string sft-or-nft:bool))
    (defun UR_ER-Burn:[string] (id:string sft-or-nft:bool))
    (defun UR_ER-Create:[string] (id:string sft-or-nft:bool))
    (defun UR_ER-Recreate:[string] (id:string sft-or-nft:bool))
    (defun UR_ER-Update:[string] (id:string sft-or-nft:bool))
    (defun UR_ER-ModifyCreator:[string] (id:string sft-or-nft:bool))
    (defun UR_ER-ModifyRoyalties:[string] (id:string sft-or-nft:bool))
    (defun UR_ER-SetUri:[string] (id:string sft-or-nft:bool))
    (defun UR_ER-Transfer:[string] (id:string sft-or-nft:bool))
    ;;
    (defun UR_CA|Exists:bool (id:string sft-or-nft:bool account:string))
    (defun UR_CA|OwnedNonces:[integer] (id:string sft-or-nft:bool account:string))
    (defun UR_CA|NoncesBalances:[integer] (id:string account:string))
    (defun UR_CA|R:object{DPDC|RolesSchema} (id:string sft-or-nft:bool account:string))
        ;;
    (defun UR_CA|R-AddQuantity:bool (id:string account:string))
    (defun UR_CA|R-Frozen:bool (id:string sft-or-nft:bool account:string))
    (defun UR_CA|R-Exemption:bool (id:string sft-or-nft:bool account:string))
    (defun UR_CA|R-Burn:bool (id:string sft-or-nft:bool account:string))
    (defun UR_CA|R-Create:bool (id:string sft-or-nft:bool account:string))
    (defun UR_CA|R-Recreate:bool (id:string sft-or-nft:bool account:string))
    (defun UR_CA|R-Update:bool (id:string sft-or-nft:bool account:string))
    (defun UR_CA|R-ModifyCreator:bool (id:string sft-or-nft:bool account:string))
    (defun UR_CA|R-ModifyRoyalties:bool (id:string sft-or-nft:bool account:string))
    (defun UR_CA|R-SetUri:bool (id:string sft-or-nft:bool account:string))
    (defun UR_CA|R-Transfer:bool (id:string sft-or-nft:bool account:string))
    ;;
    
    ;;
    (defun UEV_id (id:string sft-or-nft:bool))
    (defun UEV_Nonce (id:string sft-or-nft:bool nonce:integer))
    (defun UEV_NonceExists (id:string sft-or-nft:bool nonce:integer))
    (defun UEV_CanUpgradeON (id:string sft-or-nft:bool))
    (defun UEV_CanPauseON (id:string sft-or-nft:bool))
    (defun UEV_CanAddSpecialRoleON (id:string sft-or-nft:bool))
    (defun UEV_ToggleSpecialRole (id:string sft-or-nft:bool toggle:bool))
    (defun UEV_PauseState (id:string sft-or-nft:bool state:bool))
    (defun UEV_AccountAddQuantityState (id:string account:string state:bool))
    (defun UEV_AccountFreezeState (id:string sft-or-nft:bool account:string state:bool))
    (defun UEV_AccountExemptionState (id:string sft-or-nft:bool account:string state:bool))
    (defun UEV_AccountBurnState (id:string sft-or-nft:bool account:string state:bool))
    (defun UEV_AccountUpdateState (id:string sft-or-nft:bool account:string state:bool))
    (defun UEV_AccountModifyCreatorState (id:string sft-or-nft:bool account:string state:bool))
    (defun UEV_AccountModifyRoyaltiesState (id:string sft-or-nft:bool account:string state:bool))
    (defun UEV_AccountTransferState (id:string sft-or-nft:bool account:string state:bool))
    (defun UEV_AccountCreateState (id:string sft-or-nft:bool account:string state:bool))
    (defun UEV_AccountRecreateState (id:string sft-or-nft:bool account:string state:bool))
    (defun UEV_AccountSetUriState (id:string sft-or-nft:bool account:string state:bool))
    ;;
    (defun UDC_Properties:object{DPDC|PropertiesSchema}
        (
            owner-konto:string creator-konto:string name:string ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
            is-paused:bool nonces-used:integer
        )
    )
    (defun UDC_Control:object{DPDC|PropertiesSchema} (id:string sft-or-nft:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool))
    (defun UDC_ExistingRoles:object{DPDC|RolesStorageSchema} (a:[string] b:[string] c:[string] d:[string] e:[string] f:[string] g:[string] h:[string] i:[string] j:[string]))
        ;;Account UDCs
    (defun UDC_AccountRoles:object{DPDC|RolesSchema} (f:bool rnb:bool rnc:bool rnr:bool rnu:bool rmc:bool rmr:bool rsnu:bool rt:bool))
    (defun UDC_NonceElement:object{DPDC|NonceElementSchema} (a:integer b:integer c:object{DC|DataSchema}))
    (defun UDC_DataDC:object{DC|DataSchema} (royalty:decimal ignis:decimal description:string meta-data:[object] asset-type:object{DC|URI|Type} uri-primary:object{DC|URI|Schema} uri-secondary:object{DC|URI|Schema} uri-tertiary:object{DC|URI|Schema}))
    (defun UDC_UriType:object{DC|URI|Type} (a:bool b:bool c:bool d:bool e:bool f:bool g:bool))
    (defun UDC_UriString:object{DC|URI|Schema} (a:string b:string c:string d:string e:string f:string g:string))
        ;;Empty UDCs
    (defun UDC_NonceZeroElement:object{DPDC|NonceElementSchema} ())
    (defun UDC_EmptyDataDC:object{DC|DataSchema} ())
    (defun UDC_EmptyUriType:object{DC|URI|Type} ())
    (defun UDC_EmptyUriString:object{DC|URI|Schema} ())

    ;;
    (defun CAP_Owner (id:string sft-or-nft:bool))
    ;;
    ;;
    (defun C_Control:object{OuronetDalosV2.OutputCumulatorV2} (patron:string id:string sft-or-nft:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool))
    (defun C_DeployAccountSFT (id:string account:string))
    (defun C_DeployAccountNFT (id:string account:string))
    (defun C_IssueDigitalCollection:object{OuronetDalosV2.OutputCumulatorV2}
        (
            patron:string sft-or-nft:bool
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
    )
    (defun C_TogglePause:object{OuronetDalosV2.OutputCumulatorV2} (patron:string id:string sft-or-nft:bool toggle:bool))
    (defun C_ToggleAddQuantityRole:object{OuronetDalosV2.OutputCumulatorV2} (patron:string id:string account:string toggle:bool))
    (defun C_ToggleFreezeAccount:object{OuronetDalosV2.OutputCumulatorV2} (patron:string id:string sft-or-nft:bool account:string toggle:bool))
    (defun C_ToggleExemptionRole:object{OuronetDalosV2.OutputCumulatorV2} (patron:string id:string sft-or-nft:bool account:string toggle:bool))
    (defun C_ToggleBurnRole:object{OuronetDalosV2.OutputCumulatorV2} (patron:string id:string sft-or-nft:bool account:string toggle:bool))
    (defun C_ToggleUpdateRole:object{OuronetDalosV2.OutputCumulatorV2} (patron:string id:string sft-or-nft:bool account:string toggle:bool))
    (defun C_ToggleModifyCreatorRole:object{OuronetDalosV2.OutputCumulatorV2} (patron:string id:string sft-or-nft:bool account:string toggle:bool))
    (defun C_ToggleModifyRoyaltiesRole:object{OuronetDalosV2.OutputCumulatorV2} (patron:string id:string sft-or-nft:bool account:string toggle:bool))
    (defun C_ToggleTransferRole:object{OuronetDalosV2.OutputCumulatorV2} (patron:string id:string sft-or-nft:bool account:string toggle:bool))
    (defun C_MoveCreateRole:object{OuronetDalosV2.OutputCumulatorV2} (patron:string id:string sft-or-nft:bool new-account:string))
    (defun C_MoveRecreateRole:object{OuronetDalosV2.OutputCumulatorV2} (patron:string id:string sft-or-nft:bool new-account:string))
    (defun C_MoveSetUriRole:object{OuronetDalosV2.OutputCumulatorV2} (patron:string id:string sft-or-nft:bool new-account:string))
    ;;
    (defun XB_UP|SftOrNft (id:string sft-or-nft:bool sft-and-nft:[object{DPDC|NonceElementSchema}]))
    (defun XB_UP|Specs (id:string sft-or-nft:bool specs:object{DPDC|PropertiesSchema}))
    (defun XB_UP|ExistingRoles (id:string sft-or-nft:bool er:object{DPDC|RolesStorageSchema}))
        ;;
    (defun XB_UAD|OwnedNonces (id:string sft-or-nft:bool account:string owned-nonces:[integer]))
    (defun XB_UAD|NoncesBalances (id:string account:string nonces-balances:[integer]))
    (defun XB_UAD|Roles (id:string sft-or-nft:bool account:string roles:object{DPDC|RolesSchema}))
    (defun XB_UAD|Rnaq (id:string account:string role-nft-add-quantity:bool))
)