;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
;;  DPDC Interfaces
;;
(interface DpdcUdcV1
    @doc "Exposes Collectables UDC Constructors"
    ;;
    ;;  [1]
    ;;
    (defschema DPDC|Properties
        id:string
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
        set-classes-used:integer
    )
    ;;
    ;;  [2]
    ;;
    (defschema DPDC|NonceElement
        nonce-class:integer                 ;;Class 0 for Primordial Nonces, non-zero for Composite Nonces
                                            ;;For Composite Nonces, <nonce-class> is the <set-class>
        nonce-value:integer                 ;;Nonce Value of the Collection Element.
        nonce-supply:integer                ;;Collection Element Supply; Always 1 for NFT, even when burned or wiped.
        nonce-holder:string                 ;;Stores the <OuronetAccount> holding the Nonce
                                            ;;Only Applies to NFT Nonces, SFT Nonces cant have an unique Holder, and would store BAR instead (unmodifieable for SFTs)
                                            ;;For an NFT, storing <BAR> here, means the nonce is inactivated.
                                            ;;Once an NFT Nonce is inactivated, in can only be activated again bz the Colletion owner if its <nonce-class> is 0
                                            ;;This Creates the NFT on the Creator Account
        ;;
        nonce-data:object{DPDC|NonceData}   ;;Data of the Nonce Element
        split-data:object{DPDC|NonceData}   ;;Data of the Nonce Fragment Elements
    )
    (defschema DPDC|NonceData
        royalty:decimal
        ignis:decimal
        name:string
        description:string
        meta-data:object{NonceMetaData}
        asset-type:object{URI|Type}
        uri-primary:object{URI|Data}
        uri-secondary:object{URI|Data}
        uri-tertiary:object{URI|Data}
    )
    (defschema NonceMetaData
        score:decimal
        composition:[integer]
        meta-data:object
    )
    (defschema URI|Type
        image:bool
        audio:bool
        video:bool
        document:bool
        archive:bool
        model:bool
        exotic:bool
    )
    (defschema URI|Data
        image:string
        audio:string
        video:string
        document:string
        archive:string
        model:string
        exotic:string
    )
    ;;
    ;;  [3]
    ;;
    (defschema DPDC|VerumRoles
        a-frozen:[string]
        r-exemption:[string]
        r-nft-add-quantity:[string]
        r-nft-burn:[string]
        r-nft-create:string
        r-nft-recreate:string
        r-nft-update:[string]
        r-modify-creator:[string]
        r-modify-royalties:[string]
        r-set-new-uri:string
        r-transfer:[string]
    )
    ;;
    ;;  [4]
    ;;
    ;;DPSF
    (defschema DPSF|AccountRoles
        @doc "Key = <DPSF-id> + BAR + <account>"
        roles:object{AccountRoles}
        role-nft-add-quantity:bool
        ;;
        ;;ForSelect, store Key Make-up
        id:string
        account:string
    )
    ;;DPNF
    (defschema DPNF|AccountRoles
        @doc "Key = <account> + BAR + <DPNF-id>"
        roles:object{AccountRoles}
        ;;
        ;;ForSelect, store Key Make-up
        id:string
        account:string
    )
    (defschema AccountRoles
        frozen:bool                         ;; multiple
        role-exemption:bool                 ;; multiple
        role-nft-burn:bool                  ;; multiple
        role-nft-create:bool                ;; single       ;;new
        role-nft-recreate:bool              ;; single       ;;whole nonce-data
        role-nft-update:bool                ;; multiple     ;;name, description, score, meta-data
        role-modify-creator:bool            ;; multiple     ;;change-cretor-account
        role-modify-royalties:bool          ;; multiple     ;;royalty ignis-royalty
        role-set-new-uri:bool               ;; single       ;;uri
        role-transfer:bool                  ;; multiple
    )
    ;;
    ;;  [5]
    ;;
    (defschema DPDC|AccountSupply
        @doc "Key = <account> + BAR + <DPSF|DPNF-id> + BAR + <nonce>"
        account:string
        id:string
        nonce:integer
        supply:integer
    )
    ;;
    ;;  [6]
    ;;
    (defschema DPDC|Set
        set-class:integer
        set-name:string
        set-score-multiplier:decimal        ;;Stores Set NFT Score Multiplier, default to 1.0
        nonce-of-set:integer                ;;Saves the Nonce of the Set; 
                                            ;;Only for SFT, since they get their own nonce at definition
                                            ;;For NFT has no use and is filled with 0
        ;;                                  
        iz-active:bool                      ;;Inactive Sets cannot be composed, but can be decomposed
        primordial:bool                     ;;primordial sets are composed of specific class 0 nonces
        composite:bool                      ;;composite  sets are composed of non-specific class non-zero nonces
                                            ;;if both are true, the set is hybrid, and then both of the field below
                                            ;;would have to be filled with correct data.
        ;;
        primordial-set-definition:[object{DPDC|AllowedNonceForSetPosition}]
        ;;If <primordial> is true, a valid object will be stored here, otherwise [[0]] will be stored
        composite-set-definition:[object{DPDC|AllowedClassForSetPosition}]
        ;;If <composite> is true, a valid object will be stored here, otherwise [[-1]] will be stored
        ;;
        nonce-data:object{DPDC|NonceData}   ;;Data for the Set Nonce
        split-data:object{DPDC|NonceData}   ;;Data for the Fragment of the Set Nonce
    )
    (defschema DPDC|AllowedNonceForSetPosition
        allowed-nonces:[integer]
    )
    (defschema DPDC|AllowedClassForSetPosition
        allowed-sclass:integer
    )
    ;;
    ;;  [UDC]
    ;;
    ;;  [1]
    ;;
    (defun UDC_DPDC|Properties:object{DPDC|Properties}
        (
            a:string b:string c:string d:string e:string
            f:bool g:bool h:bool i:bool
            j:bool k:bool l:bool m:bool
            n:bool o:integer p:integer
        )
    )
    ;;
    ;;  [2]
    ;;
    (defun UDC_NonceElement:object{DPDC|NonceElement} 
        (   
            a:integer b:integer c:integer d:string
            e:object{DPDC|NonceData}
            f:object{DPDC|NonceData}
        )
    )
    (defun UDC_NonceData:object{DPDC|NonceData} 
        (
            a:decimal b:decimal c:string d:string 
            e:object{NonceMetaData}
            f:object{URI|Type}
            g:object{URI|Data}
            h:object{URI|Data}
            i:object{URI|Data}
        )
    )
    (defun UDC_NonceMetaData:object{NonceMetaData} (a:decimal b:[integer] c:object))
    (defun UDC_URI|Type:object{URI|Type} (a:bool b:bool c:bool d:bool e:bool f:bool g:bool))
    (defun UDC_URI|Data:object{URI|Data} (a:string b:string c:string d:string e:string f:string g:string))
    ;;
    ;;  [3]
    ;;
    (defun UDC_DPDC|VerumRoles:object{DPDC|VerumRoles} 
        (a:[string] b:[string] c:[string] d:[string] e:string f:string g:[string] h:[string] i:[string] j:string k:[string])
    )
    ;;
    ;;  [4]
    ;;
    (defun UDC_DPSF|AccountRoles:object{DPSF|AccountRoles} (a:object{AccountRoles} b:bool c:string d:string))
    (defun UDC_DPNF|AccountRoles:object{DPNF|AccountRoles} (a:object{AccountRoles} b:string c:string))
    (defun UDC_AccountRoles:object{AccountRoles} (a:bool b:bool c:bool d:bool e:bool f:bool g:bool h:bool i:bool j:bool))
    ;;
    ;;  [5]
    ;;
    (defun UDC_DPDC|AccountSupply:object{DPDC|AccountSupply}  (a:string b:string c:integer d:integer))
    ;;
    ;;  [6]
    ;;
    
    (defun C:object{DPDC|AllowedClassForSetPosition}  (a:integer))
    (defun N:object{DPDC|AllowedNonceForSetPosition}  (a:[integer]))
    (defun S:object{DPDC|Set}
        (
            a:integer b:string c:decimal d:integer e:bool f:bool g:bool
            h:[object{DPDC|AllowedNonceForSetPosition}]
            i:[object{DPDC|AllowedClassForSetPosition}]
            j:object{DPDC|NonceData}
            k:object{DPDC|NonceData}
        )
    )
    ;;
    ;;  [CUSTOM]
    ;;
    ;;  [2]
    (defun UDC_ZeroNonceElement:object{DPDC|NonceElement} ())
    (defun UDC_NoMetaData:object{NonceMetaData} ())
    (defun UDC_MetaData:object{NonceMetaData} (meta-data:object))
    (defun UDC_ScoreMetaData:object{NonceMetaData} (score:decimal meta-data:object))
    (defun UDC_ZeroURI|Type:object{URI|Type} ())
    (defun UDC_ZeroURI|Data:object{URI|Data} ())
    ;;  [6]
    (defun UDC_NoPrimordialSet:[object{DPDC|AllowedNonceForSetPosition}] ())
    (defun UDC_NoCompositeSet:[object{DPDC|AllowedClassForSetPosition}] ())
)
;;
(interface DpdcV1
    @doc "Exposes Collectables Functions"
    (defun GOV|DPDC|SC_NAME ())
    ;;
    ;;  [UR]
    ;;
    ;;  [1]
    (defun UR_Properties:object{DpdcUdcV1.DPDC|Properties} (id:string son:bool))
    (defun UR_OwnerKonto:string (id:string son:bool))
    (defun UR_CreatorKonto:string (id:string son:bool))
    (defun UR_Name:string (id:string son:bool))
    (defun UR_Ticker:string (id:string son:bool))
    (defun UR_CanUpgrade:bool (id:string son:bool))
    (defun UR_CanChangeOwner:bool (id:string son:bool))
    (defun UR_CanChangeCreator:bool (id:string son:bool))
    (defun UR_CanAddSpecialRole:bool (id:string son:bool))
    (defun UR_CanTransferNftCreateRole:bool (id:string son:bool))
    (defun UR_CanFreeze:bool (id:string son:bool))
    (defun UR_CanWipe:bool (id:string son:bool))
    (defun UR_CanPause:bool (id:string son:bool))
    (defun UR_IsPaused:bool (id:string son:bool))
    (defun UR_NoncesUsed:integer (id:string son:bool))
    (defun UR_SetClassesUsed:integer (id:string son:bool))
    ;;  [2]
    (defun UR_NonceElement:object{DpdcUdcV1.DPDC|NonceElement} (id:string son:bool nonce:integer))
    (defun UR_NonceClass:integer (id:string son:bool nonce:integer))
    (defun UR_NonceValue:integer (id:string son:bool nonce:integer))
    (defun UR_NonceSupply:integer (id:string son:bool nonce:integer))
    (defun UR_NonceHolder:string (id:string son:bool nonce:integer))
    (defun UR_NativeNonceData:object{DpdcUdcV1.DPDC|NonceData} (id:string son:bool nonce:integer))
    (defun UR_SplitNonceData:object{DpdcUdcV1.DPDC|NonceData} (id:string son:bool nonce:integer))
    (defun UR_NonceData:object{DpdcUdcV1.DPDC|NonceData} (id:string son:bool nonce:integer))
    ;;  [2.1]
    (defun UR_N|Royalty:decimal (n:object{DpdcUdcV1.DPDC|NonceData}))
    (defun UR_N|IgnisRoyalty:decimal (n:object{DpdcUdcV1.DPDC|NonceData}))
    (defun UR_N|Name:string (n:object{DpdcUdcV1.DPDC|NonceData}))
    (defun UR_N|Description:string (n:object{DpdcUdcV1.DPDC|NonceData}))
    (defun UR_N|MetaData:object{DpdcUdcV1.NonceMetaData} (n:object{DpdcUdcV1.DPDC|NonceData}))
    (defun UR_N|AssetType:object{DpdcUdcV1.URI|Type} (n:object{DpdcUdcV1.DPDC|NonceData}))
    (defun UR_N|Primary:object{DpdcUdcV1.URI|Data} (n:object{DpdcUdcV1.DPDC|NonceData}))
    (defun UR_N|Secondary:object{DpdcUdcV1.URI|Data} (n:object{DpdcUdcV1.DPDC|NonceData}))
    (defun UR_N|Tertiary:object{DpdcUdcV1.URI|Data} (n:object{DpdcUdcV1.DPDC|NonceData}))
    ;;  [2.1.1]
    (defun UR_N|RawScore:decimal (n:object{DpdcUdcV1.DPDC|NonceData}))
    (defun UR_N|Composition:[integer] (n:object{DpdcUdcV1.DPDC|NonceData}))
    (defun UR_N|RawMetaData:object (n:object{DpdcUdcV1.DPDC|NonceData}))
    ;;  [3]
    (defun UR_VerumRoles:object{DpdcUdcV1.DPDC|VerumRoles} (id:string son:bool))
    (defun UR_Verum1:[string] (id:string son:bool))
    (defun UR_Verum2:[string] (id:string son:bool))
    (defun UR_Verum3:[string] (id:string son:bool))
    (defun UR_Verum4:[string] (id:string son:bool))
    (defun UR_Verum5:string (id:string son:bool))
    (defun UR_Verum6:string (id:string son:bool))
    (defun UR_Verum7:[string] (id:string son:bool))
    (defun UR_Verum8:[string] (id:string son:bool))
    (defun UR_Verum9:[string] (id:string son:bool))
    (defun UR_Verum10:string (id:string son:bool))
    (defun UR_Verum11:[string] (id:string son:bool))
    (defun UR_GetSingleVerum:string (id:string son:bool rp:integer))
    (defun UR_GetVerumChain:[string] (id:string son:bool rp:integer))
    ;;  [4]
    (defun UR_IzAccount:bool (account:string id:string son:bool))
    (defun UR_CA|R:object{DpdcUdcV1.AccountRoles} (id:string son:bool account:string))
    (defun UR_CA|R-AddQuantity:bool (id:string account:string))
    (defun UR_CA|R-Frozen:bool (id:string son:bool account:string))
    (defun UR_CA|R-Exemption:bool (id:string son:bool account:string))
    (defun UR_CA|R-Burn:bool (id:string son:bool account:string))
    (defun UR_CA|R-Create:bool (id:string son:bool account:string))
    (defun UR_CA|R-Recreate:bool (id:string son:bool account:string))
    (defun UR_CA|R-Update:bool (id:string son:bool account:string))
    (defun UR_CA|R-ModifyCreator:bool (id:string son:bool account:string))
    (defun UR_CA|R-ModifyRoyalties:bool (id:string son:bool account:string))
    (defun UR_CA|R-SetUri:bool (id:string son:bool account:string))
    (defun UR_CA|R-Transfer:bool (id:string son:bool account:string))
    ;;  [5]
    (defun UR_AccountSupply:object{DpdcUdcV1.DPDC|AccountSupply} (account:string id:string son:bool nonce:integer))
    (defun UR_AccountNonceSupply:integer (account:string id:string son:bool nonce:integer))
    (defun UR_AccountNoncesSupplies:[integer] (account:string id:string son:bool nonces:[integer]))
    ;;
    (defun URD_HeldCollectables:[string] (account:string son:bool))
    (defun URD_ExistingCollectables:[string] (dpdc:string son:bool))
    (defun URD_OwnedCollectables:[string] (account:string son:bool))
    (defun URD_AccountNonces:[integer] (account:string id:string son:bool))
    (defun URD_AccountNoncesWithSupplies:[object] (account:string id:string son:bool))
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_id (id:string son:bool))
    (defun UEV_NonceMapper (id:string son:bool nonces:[integer]))
    (defun UEV_Nonce (id:string son:bool nonce:integer))
        ;;
    (defun UEV_CanUpgradeON (id:string son:bool))
    (defun UEV_CanPauseON (id:string son:bool))
    (defun UEV_CanAddSpecialRoleON (id:string son:bool))
    (defun UEV_ToggleSpecialRole (id:string son:bool toggle:bool))
    (defun UEV_CanFreezeON (id:string son:bool))
    (defun UEV_PauseState (id:string son:bool state:bool))
    (defun UEV_AccountAddQuantityState (id:string account:string state:bool))
    (defun UEV_AccountFreezeState (id:string son:bool account:string state:bool))
    (defun UEV_AccountExemptionState (id:string son:bool account:string state:bool))
    (defun UEV_AccountBurnState (id:string son:bool account:string state:bool))
    (defun UEV_AccountUpdateState (id:string son:bool account:string state:bool))
    (defun UEV_AccountModifyCreatorState (id:string son:bool account:string state:bool))
    (defun UEV_AccountModifyRoyaltiesState (id:string son:bool account:string state:bool))
    (defun UEV_AccountTransferState (id:string son:bool account:string state:bool))
    (defun UEV_AccountCreateState (id:string son:bool account:string state:bool))
    (defun UEV_AccountRecreateState (id:string son:bool account:string state:bool))
    (defun UEV_AccountSetUriState (id:string son:bool account:string state:bool))
    (defun UEV_Royalty (royalty:decimal))
    (defun UEV_IgnisRoyalty (royalty:decimal))
    (defun UEV_NftNonceExistance (id:string nonce:integer existance:bool))
    (defun UEV_NonceQuantityInclusion (account:string id:string son:bool nonce:integer amount:integer))
    (defun UEV_NonceQuantityInclusionMapper (account:string id:string son:bool nonces:[integer] amounts:[integer]))
    ;;
    ;; [UDC]
    ;;
    (defun UDC_Control:object{DpdcUdcV1.DPDC|Properties} (id:string son:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool))
    ;;
    ;;  [CAP]
    ;;
    (defun CAP_Owner (id:string son:bool))
    (defun CAP_Creator (id:string son:bool))
    ;;
    ;;  [X]
    ;;
    ;; [<AccountsTable> Writings] [0]
    ;;
    (defun XB_DeployAccountSFT
        (
            account:string id:string
            input-rnaq:bool f:bool re:bool rnb:bool rnc:bool rnr:bool
            rnu:bool rmc:bool rmr:bool rsnu:bool rt:bool
        )
    )
    (defun XB_DeployAccountNFT 
        (
            account:string id:string
            f:bool re:bool rnb:bool rnc:bool rnr:bool
            rnu:bool rmc:bool rmr:bool rsnu:bool rt:bool
        )
    )
    (defun XE_DeployAccountWNE (account:string id:string son:bool))
    (defun XE_U|Rnaq (id:string account:string toggle))
    (defun XI_U|AccountRoles (id:string son:bool account:string new-roles:object{DpdcUdcV1.AccountRoles}))
    ;;
    ;; [<PropertiesTable> Writings] [1]
    ;;
    (defun XE_I|Collection (id:string son:bool idp:object{DpdcUdcV1.DPDC|Properties}))
    (defun XE_U|Specs (id:string son:bool specs:object{DpdcUdcV1.DPDC|Properties}))
    (defun XE_U|IsPaused (id:string son:bool toggle:bool))
    (defun XE_U|NoncesUsed (id:string son:bool new-nv:integer))
    (defun XE_U|SetClassesUsed (id:string son:bool new-nsc:integer))
    ;;
    ;; [<NoncesTable> Writings] [2]
    ;;
    (defun XE_I|CollectionElement (id:string son:bool nonce-value:integer ned:object{DpdcUdcV1.DPDC|NonceElement}))
    (defun XE_U|NonceSupply (id:string nonce-value:integer new-supply:integer))
    (defun XE_U|NonceHolder (id:string nonce-value:integer new-holder-account:string))
    (defun XE_U|NonceOrSplitData (id:string son:bool nonce-value:integer nos:bool nd:object{DpdcUdcV1.DPDC|NonceData}))
    ;;
    ;; [<VerumRolesTable> Writings] [3]
    ;;
    (defun XE_I|VerumRoles (id:string son:bool verum-chain:object{DpdcUdcV1.DPDC|VerumRoles}))
    ;;
    ;;  [Indirect Writings]
    ;;
    (defun XE_U|Frozen (id:string son:bool account:string toggle:bool))
    (defun XE_U|Exemption (id:string son:bool account:string toggle:bool))
    (defun XE_U|Burn (id:string son:bool account:string toggle:bool))
    (defun XE_U|Create (id:string son:bool account:string toggle:bool))
    (defun XE_U|Recreate (id:string son:bool account:string toggle:bool))
    (defun XE_U|Update (id:string son:bool account:string toggle:bool))
    (defun XE_U|ModifyCreator (id:string son:bool account:string toggle:bool))
    (defun XE_U|ModifyRoyalties (id:string son:bool account:string toggle:bool))
    (defun XE_U|SetNewUri (id:string son:bool account:string toggle:bool))
    (defun XE_U|Transfer (id:string son:bool account:string toggle:bool))
    (defun XE_U|VerumRoles (id:string son:bool rp:integer aor:bool account:string))
    ;;
    ;; [<AccountSuppliesTable> Writings] [4]
    ;;
    (defun XE_W|Supply (account:string id:string son:bool nonce-value:integer amount:integer))
)
;;
(interface DpdcCreateV1
    @doc "Exposes Collectables Create Functions, containining the Credit and Debit Variants"
    ;;
    ;;  [UC]
    ;;
    (defun UC_AndTruths:bool (truths:[bool]))
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_NonceDataForCreation (ind:object{DpdcUdcV1.DPDC|NonceData}))
    (defun UEV_NonceType (nonce:integer fragments-or-native:bool))
    (defun UEV_NonceTypeMapper (nonces:[integer] fragments-or-native:bool))
    (defun UEV_HybridNonces:object{OuronetIntegersV1.SplitIntegers} (nonces:[integer]))
    ;;
    ;;  [C]
    ;;
    (defun C_CreateNewNonce:object{IgnisCollectorV1.OutputCumulator}
        (
            id:string son:bool nonce-class:integer amount:integer
            input-nonce-data:object{DpdcUdcV1.DPDC|NonceData} sft-set-mode:bool
        )
    )
    (defun C_CreateNewNonces:object{IgnisCollectorV1.OutputCumulator}
        (
            id:string son:bool amounts:[integer]
            input-nonce-datas:[object{DpdcUdcV1.DPDC|NonceData}]
        )
    )
    ;;
    ;;  [X]
    ;;
    (defun XE_CreditSFT-FragmentNonce (account:string id:string nonce:integer amount:integer))
    (defun XE_CreditNFT-FragmentNonce (account:string id:string nonce:integer amount:integer))
    (defun XE_DebitSFT-FragmentNonce (account:string id:string nonce:integer amount:integer wipe-mode:bool))
    (defun XE_DebitNFT-FragmentNonce (account:string id:string nonce:integer amount:integer wipe-mode:bool))
    ;;
    (defun XB_CreditSFT-Nonce (account:string id:string nonce:integer amount:integer))
    (defun XB_CreditNFT-Nonce (account:string id:string nonce:integer amount:integer))
    (defun XE_DebitSFT-Nonce (account:string id:string nonce:integer amount:integer wipe-mode:bool))
    (defun XE_DebitNFT-Nonce (account:string id:string nonce:integer amount:integer wipe-mode:bool))
    ;;
    (defun XE_CreditSFT-FragmentNonces (account:string id:string nonces:[integer] amounts:[integer]))
    (defun XE_CreditNFT-FragmentNonces (account:string id:string nonces:[integer] amounts:[integer]))
    (defun XE_DebitSFT-FragmentNonces (account:string id:string nonces:[integer] amounts:[integer] wipe-mode:bool))
    (defun XE_DebitNFT-FragmentNonces (account:string id:string nonces:[integer] amounts:[integer] wipe-mode:bool))
    ;;
    (defun XB_CreditSFT-Nonces (account:string id:string nonces:[integer] amounts:[integer]))
    (defun XB_CreditNFT-Nonces (account:string id:string nonces:[integer] amounts:[integer]))
    (defun XE_DebitSFT-Nonces (account:string id:string nonces:[integer] amounts:[integer] wipe-mode:bool))
    (defun XE_DebitNFT-Nonces (account:string id:string nonces:[integer] amounts:[integer] wipe-mode:bool))
    ;;
    (defun XE_CreditSFT-HybridNonces (account:string id:string nonces:[integer] amounts:[integer]))
    (defun XE_CreditNFT-HybridNonces (account:string id:string nonces:[integer] amounts:[integer]))
    (defun XE_DebitSFT-HybridNonces (account:string id:string nonces:[integer] amounts:[integer]))
    (defun XE_DebitNFT-HybridNonces (account:string id:string nonces:[integer] amounts:[integer]))
    ;;
)
;;
(interface DpdcIssueV1
    @doc "Exposes Collectables Issue Functions"
    ;;
    ;;  [C]
    ;;
    (defun C_DeployAccountSFT (account:string id:string))
    (defun C_DeployAccountNFT (account:string id:string))
    (defun C_IssueDigitalCollection:object{IgnisCollectorV1.OutputCumulator}
        (
            patron:string son:bool
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
            iz-special:bool
        )
    )
    ;;
)
;;
(interface DpdcRolesV1
    @doc "Exposes Collectables Role Functions"
    ;;
    ;;  [C]
    ;;
    (defun C_ToggleAddQuantityRole:object{IgnisCollectorV1.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_ToggleFreezeAccount:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool account:string toggle:bool))
    (defun C_ToggleExemptionRole:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool account:string toggle:bool))
    (defun C_ToggleBurnRole:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool account:string toggle:bool))
    (defun C_ToggleUpdateRole:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool account:string toggle:bool))
    (defun C_ToggleModifyCreatorRole:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool account:string toggle:bool))
    (defun C_ToggleModifyRoyaltiesRole:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool account:string toggle:bool))
    (defun C_ToggleTransferRole:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool account:string toggle:bool))
    (defun C_MoveCreateRole:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool new-account:string))
    (defun C_MoveRecreateRole:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool new-account:string))
    (defun C_MoveSetUriRole:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool new-account:string))
)
;;
(interface DpdcManagementV1
    @doc "Exposes Collectables Management Functions"
    ;;
    (defschema RemovableNonces
        @doc "Removable Nonces are Class 0 Nonces held by a given Account with greater than 0 supply \
        \ Given an <account>, a dpdc <id>, and a list of <nonces>, they can be filtered to Removable Nonces"
        r-nonces:[integer]
        r-amounts:[integer]
    )
    ;;
    ;; [C]
    ;;
    (defun C_Control:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool))
    (defun C_TogglePause:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool toggle:bool))
    ;;
    ;;  [CREDIT-SINGLE]
    ;;  [SFT]
    (defun C_AddQuantity:object{IgnisCollectorV1.OutputCumulator} (account:string id:string nonce:integer amount:integer))
    ;;  [NFT]
    (defun C_RespawnNFT:object{IgnisCollectorV1.OutputCumulator} (account:string id:string nonce:integer))
    ;;
    ;;  [DEBIT-SINGLE]
    ;;  [SFT]
    (defun C_BurnSFT:object{IgnisCollectorV1.OutputCumulator} (account:string id:string nonce:integer amount:integer))
    (defun C_WipeSlim:object{IgnisCollectorV1.OutputCumulator} (account:string id:string nonce:integer amount:integer))
    ;;  [NFT]
    (defun C_BurnNFT:object{IgnisCollectorV1.OutputCumulator} (account:string id:string nonce:integer))
    ;;  [SFT+NFT]
    (defun C_WipeNonce:object{IgnisCollectorV1.OutputCumulator} (account:string id:string son:bool nonce:integer))
    ;;
    ;;  [DEBIT-MULTIPLE]
    ;;  [SFT+NFT]
    (defun C_WipeHeavy:object{IgnisCollectorV1.OutputCumulator} (account:string id:string son:bool))
    (defun C_WipePure:object{IgnisCollectorV1.OutputCumulator} (account:string id:string son:bool removable-nonces-obj:object{RemovableNonces}))
    (defun C_WipeClean:object{IgnisCollectorV1.OutputCumulator} (account:string id:string son:bool nonces:[integer]))
    (defun C_WipeDirty:object{IgnisCollectorV1.OutputCumulator} (account:string id:string son:bool nonces:[integer]))
)
;;
;;
(interface DpdcTransferV1
    @doc "Exposes Collectables Transfer Functions"
    ;;
    ;;  [Schemas]
    ;;
    (defschema AggregatedRoyalties
        creators:[string]
        ignis-royalties:[decimal]
    )
    ;;
    (defun UC_AndTruths:bool (truths:[bool]))
    ;;
    ;;  [URC]
    ;;
    (defun URC_TransferRoleChecker:bool (id:string son:bool sender:string))
    (defun URC_SummedIgnisRoyalty:decimal (sender:string id:string son:bool nonces:[integer] amounts:[integer]))
    (defun URC_TotalTransferPrice:decimal (id:string son:bool nonces:[integer] amounts:[integer]))
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_TransferRoles (id:string son:bool sender:string receiver:string))
    (defun UEV_TransferRoleChecker (trc:bool s:bool r:bool))
    (defun UEV_AmountsForTransfer (id:string son:bool nonces:[integer] amounts:[integer]))
    ;;
    ;;  [UDC]
    ;;
    (defun UDC_MultiTransferCumulator:object{IgnisCollectorV1.OutputCumulator} (ids:[string] sons:[bool] sender:string receiver:string nonces-array:[[integer]] amounts-array:[[integer]]))
    ;;
    ;;  [C]
    ;;
    (defun C_RepurposeCollectable:object{IgnisCollectorV1.OutputCumulator}
        (id:string son:bool repurpose-from:string repurpose-to:string nonces:[integer] amounts:[integer])
    )
    (defun C_Transfer:object{IgnisCollectorV1.OutputCumulator} (ids:[string] sons:[bool] sender:string receiver:string nonces-array:[[integer]] amounts-array:[[integer]] method:bool))
    (defun C_IgnisRoyaltyCollector:object{AggregatedRoyalties} (patron:string sender:string ids:[string] sons:[bool] nonces-array:[[integer]] amounts-array:[[integer]]))
)
;;
(interface DpdcSetsV1
    @doc "Exposes Collectables Set related Functions"
    ;;
    ;;  [UR]
    ;;
    (defun UR_Set:object{DpdcUdcV1.DPDC|Set} (id:string son:bool set-class:integer))
    (defun UR_SetClass:integer (id:string son:bool set-class:integer))
    (defun UR_SetName:string (id:string son:bool set-class:integer))
    (defun UR_SetMultiplier:decimal (id:string son:bool set-class:integer))
    (defun UR_NonceOfSet:integer (id:string set-class:integer))
    (defun UR_IzSetActive:bool (id:string son:bool set-class:integer))
    (defun UR_IzSetPrimordial:bool (id:string son:bool set-class:integer))
    (defun UR_IzSetComposite:bool (id:string son:bool set-class:integer))
    (defun UR_PSD:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}] (id:string son:bool set-class:integer))
    (defun UR_CSD:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}] (id:string son:bool set-class:integer))
    (defun UR_SetNonceData:object{DpdcUdcV1.DPDC|NonceData} (id:string son:bool set-class:integer))
    (defun UR_SetSplitData:object{DpdcUdcV1.DPDC|NonceData} (id:string son:bool set-class:integer))
    (defun UR_N|Score:decimal (id:string son:bool nonce:integer))
    ;;
    ;;  [URC]
    ;;
    (defun URC_PrimordialOrComposite:[bool] (id:string son:bool set-class:integer))
    (defun URC_NoncesSummedScore:decimal (id:string son:bool nonces:[integer]))
    (defun URC_SemiFungibleConstituents:[integer] (id:string set-class:integer))
    (defun URC_NonFungibleConstituents:[integer] (id:string nonce:integer))
    ;;
    ;;  [UEV]
    ;;
    
        ;;
    (defun UEV_PrimordialSetDefinition (id:string son:bool set-definition:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}]))
    (defun UEV_PrimordialSetElement (son:bool element:object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}))
    (defun UEV_CompositeSetDefinition (id:string son:bool set-definition:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}]))
    (defun UEV_SetClass (id:string son:bool set-class:integer))
    (defun UEV_IzSetClassFragmented:bool (id:string son:bool set-class:integer))
    (defun UEV_Fragmentation (id:string son:bool set-class:integer))
    (defun UEV_SetActiveState (id:string son:bool set-class:integer state:bool))
        ;;
    (defun UEV_NoncesForSetClass (id:string son:bool nonces:[integer] set-class:integer))
    (defun UEV_Primordial (nonces:[integer] psd:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}]))
    (defun UEV_Composite (id:string son:bool nonces:[integer] csd:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}]))
    ;;
    ;;  [C]
    ;;
    (defun C_MakeSemiFungibleSet:object{IgnisCollectorV1.OutputCumulator} (account:string id:string nonces:[integer] set-class:integer how-many-sets:integer))
    (defun C_BreakSemiFungibleSet:object{IgnisCollectorV1.OutputCumulator} (account:string id:string nonce:integer how-many-sets:integer))
    (defun C_MakeNonFungibleSet:object{IgnisCollectorV1.OutputCumulator} (account:string id:string nonces:[integer] set-class:integer))
    (defun C_BreakNonFungibleSet:object{IgnisCollectorV1.OutputCumulator} (account:string id:string nonce:integer))
        ;;
    (defun C_DefinePrimordialSet:object{IgnisCollectorV1.OutputCumulator}
        (
            id:string son:bool set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdcV1.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdcV1.DPDC|NonceData}
        )
    )
    (defun C_DefineCompositeSet:object{IgnisCollectorV1.OutputCumulator}
        (
            id:string son:bool set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdcV1.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdcV1.DPDC|NonceData}
        )
    )
    (defun C_EnableSetClassFragmentation:object{IgnisCollectorV1.OutputCumulator}
        (
            id:string son:bool set-class:integer
            fragmentation-ind:object{DpdcUdcV1.DPDC|NonceData}
        )
    )
    (defun C_ToggleSet:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool set-class:integer toggle:bool))
    (defun C_RenameSet:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool set-class:integer new-name:string))
    (defun C_UpdateSetMultiplier:object{IgnisCollectorV1.OutputCumulator} (id:string son:bool set-class:integer new-multiplier:decimal))
    ;;
    (defun XB_U|NonceOrSplitData (id:string son:bool set-class:integer nos:bool nd:object{DpdcUdcV1.DPDC|NonceData}))
)
;;
(interface DpdcFragmentsV1
    @doc "Exposes Collectables Fragmentation related Functions"
    ;;
    ;; [UEV]
    ;;
    (defun UEV_IzNonceFragmented:bool (id:string son:bool nonce:integer))
    (defun UEV_Fragmentation (id:string son:bool nonce:integer))
    ;;
    ;; [C]
    ;;
    (defun C_RepurposeCollectableFragments:object{IgnisCollectorV1.OutputCumulator}
        (id:string son:bool repurpose-from:string repurpose-to:string fragment-nonces:[integer] fragment-amounts:[integer])
    )
    (defun C_MakeFragments:object{IgnisCollectorV1.OutputCumulator} (account:string id:string son:bool nonce:integer amount:integer))
    (defun C_MergeFragments:object{IgnisCollectorV1.OutputCumulator} (account:string id:string son:bool nonce:integer amount:integer))
    (defun C_EnableNonceFragmentation:object{IgnisCollectorV1.OutputCumulator}
        (
            id:string son:bool nonce:integer
            fragmentation-ind:object{DpdcUdcV1.DPDC|NonceData}
        )
    )
)
;;

(interface DpdcNonceV1
    @doc "Exposes Collectables Nonce Management related Functions"
    ;;
    ;; [UR]
    ;;
    (defun UR_Nonce:object{DpdcUdcV1.DPDC|NonceData} (id:string son:bool nosc:integer nos:bool nost:bool))
    ;;
    ;; [UEV]
    ;;
    (defun UEV_NonceDataUpdater (id:string son:bool account:string nosc:integer nos:bool nost:bool))
    (defun UEV_RoleNftRecreateON (id:string son:bool account:string))
    (defun UEV_RoleNftUpdateON (id:string son:bool account:string))
    (defun UEV_RoleModifyRoyaltiesON (id:string son:bool account:string))
    (defun UEV_RoleSetNewUriON (id:string son:bool account:string))
    (defun UEV_Score (score:decimal))
    ;;
    ;; [C]
    ;;
    (defun C_UpdateNonces               (id:string son:bool account:string nosc:[integer] nos:bool nost:bool new-nonces-data:[object{DpdcUdcV1.DPDC|NonceData}]))
    (defun C_UpdateNonceRoyalty         (id:string son:bool account:string nosc:integer nos:bool nost:bool royalty-value:decimal))
    (defun C_UpdateNonceIgnisRoyalty    (id:string son:bool account:string nosc:integer nos:bool nost:bool royalty-value:decimal))
    (defun C_UpdateNonceName            (id:string son:bool account:string nosc:integer nos:bool nost:bool name:string))
    (defun C_UpdateNonceDescription     (id:string son:bool account:string nosc:integer nos:bool nost:bool description:string))
    (defun C_UpdateNonceScore           (id:string son:bool account:string nosc:integer nos:bool nost:bool score:decimal))
    (defun C_UpdateNonceMetaData        (id:string son:bool account:string nosc:integer nos:bool nost:bool meta-data:object))
    (defun C_UpdateNonceURI             (id:string son:bool account:string nosc:integer nos:bool nost:bool ay:object{DpdcUdcV1.URI|Type} u1:object{DpdcUdcV1.URI|Data} u2:object{DpdcUdcV1.URI|Data} u3:object{DpdcUdcV1.URI|Data}))
)