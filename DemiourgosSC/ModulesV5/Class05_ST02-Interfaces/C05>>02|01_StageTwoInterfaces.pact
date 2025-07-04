;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
;;  DPDC Interfaces
;;
(interface DpdcUdc
    ;;DPSF
    (defschema DPSF|Account
        @doc "Key = <DPSF-id> + BAR + <account>"
        iz:bool
        holdings:[object{DPSF|NonceBalance}]
        fragments:[object{DPSF|NonceBalance}]
        roles:object{AccountRoles}
        role-nft-add-quantity:bool
    )
    (defschema DPSF|NonceBalance
        nonce:integer
        supply:integer
    )
    ;;DPNF
    (defschema DPNF|Account
        @doc "Key = <DPNF-id> + BAR + <account>"
        iz:bool
        holdings:[integer]
        fragments:[object{DPSF|NonceBalance}]
        roles:object{AccountRoles}
    )
    ;;
    ;;  [0]
    ;;
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
    ;;  [1]
    ;;
    (defschema DPDC|Properties
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
        nonce-value:integer                 ;;Nonce Value of the Collection Element.
        nonce-supply:integer                ;;Collection Element Supply
        ;;
        iz-active:bool                      ;;Inactive Nonces effectively dont exist;
                                            ;;SFTs always have this set to true, and it cannot be changed to false
                                            ;;Only used for NFTs to signal zero supply, since NFTs always have a supply of 1.
                                            ;;Once an NFT Nonce is inactived, it can only be activated again by the Collection owner
                                            ;;If it has a <nonce-class> of 0 only. This creates the NFT on the Creator Account.
        ;;
        nonce-data:object{DPDC|NonceData}   ;;Data of the Nonce Element
        split-data:object{DPDC|NonceData}   ;;Data of the Nonce Fragment Elements
    )
    (defschema DPDC|NonceData
        royalty:decimal
        ignis:decimal
        name:string
        description:string
        meta-data:[object]
        asset-type:object{URI|Type}
        uri-primary:object{URI|Data}
        uri-secondary:object{URI|Data}
        uri-tertiary:object{URI|Data}
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
    (defschema DPDC|NonceScore
        score:decimal
    )
    ;;
    ;;  [3]
    ;;
    (defschema DPDC|Set
        set-class:integer
        set-name:string
        ;;                                  
        iz-active:bool                      ;;Inactive Sets cannot be composed, but can be decomposed
        primordial:bool                     ;;primordial sets are composed of specific class 0 nonces
        composite:bool                      ;;composite  sets are composed of non-specific class non-zero nonces
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
    ;;  [4]
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
    ;;  [UDC]
    ;;
    ;;
    ;;  [0]
    ;;
    (defun UDC_DPSF|Account:object{DPSF|Account} (a:bool b:[object{DPSF|NonceBalance}] c:[object{DPSF|NonceBalance}] d:object{AccountRoles} e:bool))
    (defun UDC_DPSF|NonceBalance:object{DPSF|NonceBalance} (a:integer b:integer))
    (defun UDC_DPNF|Account:object{DPNF|Account} (a:bool b:[integer] c:[object{DPSF|NonceBalance}] d:object{AccountRoles}))
    (defun UDC_AccountRoles:object{AccountRoles} (a:bool b:bool c:bool d:bool e:bool f:bool g:bool h:bool i:bool j:bool))
    ;;
    ;;  [1]
    ;;
    (defun UDC_DPDC|Properties:object{DPDC|Properties}
        (
            a:string b:string c:string d:string
            e:bool f:bool g:bool h:bool
            i:bool j:bool k:bool l:bool
            m:bool n:integer o:integer
        )
    )
    ;;
    ;;  [2]
    ;;
    (defun UDC_NonceElement:object{DPDC|NonceElement} 
        (   
            a:integer b:integer c:integer d:bool
            e:object{DPDC|NonceData}
            f:object{DPDC|NonceData}
        )
    )
    (defun UDC_NonceData:object{DPDC|NonceData} 
        (
            a:decimal b:decimal c:string d:string e:[object]
            f:object{URI|Type}
            g:object{URI|Data}
            h:object{URI|Data}
            i:object{URI|Data}
        )
    )
    (defun UDC_URI|Type:object{URI|Type} (a:bool b:bool c:bool d:bool e:bool f:bool g:bool))
    (defun UDC_URI|Data:object{URI|Data} (a:string b:string c:string d:string e:string f:string g:string))
    (defun UDC_Score:object{DPDC|NonceScore} (a:decimal))
    ;;
    ;;  [3]
    ;;
    (defun UDC_DPDC|Set:object{DPDC|Set}
        (
            a:integer b:string c:bool d:bool e:bool
            f:[object{DPDC|AllowedNonceForSetPosition}]
            g:[object{DPDC|AllowedClassForSetPosition}]
            i:object{DPDC|NonceData}
            j:object{DPDC|NonceData}
        )
    )
    (defun UDC_DPDC|AllowedClassForSetPosition:object{DPDC|AllowedClassForSetPosition}  (a:integer))
    (defun UDC_DPDC|AllowedNonceForSetPosition:object{DPDC|AllowedNonceForSetPosition}  (a:[integer]))
    ;;
    ;;  [4]
    ;;
    (defun UDC_DPDC|VerumRoles:object{DPDC|VerumRoles} 
        (a:[string] b:[string] c:[string] d:[string] e:string f:string g:[string] h:[string] i:[string] j:string k:[string])
    )
    ;;
    ;;  [CUSTOM]
    ;;
    ;;  [0]
    (defun UDC_ZeroNBO:object{DPSF|NonceBalance} ())
    ;;  [2]
    (defun UDC_ZeroNonceElement:object{DPDC|NonceElement} ())
    (defun UDC_ZeroNonceData:object{DPDC|NonceData} ())
    (defun UDC_ZeroURI|Type:object{URI|Type} ())
    (defun UDC_ZeroURI|Data:object{URI|Data} ())
    (defun UDC_NoScore:object{DPDC|NonceScore} ())
    ;;  [3]
    (defun UDC_NoPrimordialSet:[object{DPDC|AllowedNonceForSetPosition}] ())
    (defun UDC_NoCompositeSet:[object{DPDC|AllowedClassForSetPosition}] ())
)
;;
(interface Dpdc
    @doc "Holds Schema for Digital Collectibles, these being the DPSF and DPNF"
    ;;
    ;;  [UR]
    ;;
    (defun UR_Properties:object{DPDC|Properties} (id:string son:bool))
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
        ;;
    (defun UR_NonceElement:object{DPDC|NonceElement} (id:string son:bool nonce:integer))
    (defun UR_NonceClass:integer (id:string son:bool nonce:integer))
    (defun UR_NonceValue:integer (id:string son:bool nonce:integer))
    (defun UR_NonceSupply:integer (id:string son:bool nonce:integer))
    (defun UR_IzNonFungibleNonceActive:bool (id:string nonce:integer))
    (defun UR_NonceData:object{DPDC|NonceData} (id:string son:bool nonce:integer))
    (defun UR_SplitData:object{DPDC|NonceData} (id:string son:bool nonce:integer))
        ;;
    (defun UR_N|Royalty:decimal (n:object{DPDC|NonceData}))
    (defun UR_N|IgnisRoyalty:decimal (n:object{DPDC|NonceData}))
    (defun UR_N|Name:string (n:object{DPDC|NonceData}))
    (defun UR_N|Description:string (n:object{DPDC|NonceData}))
    (defun UR_N|MetaData:[object] (n:object{DPDC|NonceData}))
    (defun UR_N|AssetType:object{URI|Type} (n:object{DPDC|NonceData}))
    (defun UR_N|Primary:object{URI|Data} (n:object{DPDC|NonceData}))
    (defun UR_N|Secondary:object{URI|Data} (n:object{DPDC|NonceData}))
    (defun UR_N|Tertiary:object{URI|Data} (n:object{DPDC|NonceData}))
        ;;
    (defun UR_VerumRoles:object{DPDC|VerumRoles} (id:string son:bool))
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

    (defun UR_IzAccount:bool (id:string son:bool account:string))
    (defun UR_NonFungibleAccountHoldings:[integer] (id:string account:string))
    (defun UR_CA|R:object{AccountRoles} (id:string son:bool account:string))
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
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_id (id:string son:bool))
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
    ;;
    ;; [UDC]
    ;;
    (defun UDC_Control:object{DPDC|Properties} (id:string son:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool))
    ;;
    ;;  [CAP]
    ;;
    (defun CAP_Owner (id:string son:bool))
    ;;
    ;;  [X]
    ;;
    ;; [<AccountsTable> Writings] [0]
    ;;
    (defun XB_DeployAccountSFT
        (
            id:string account:string
            input-rnaq:bool f:bool re:bool rnb:bool rnc:bool rnr:bool
            rnu:bool rmc:bool rmr:bool rsnu:bool rt:bool
        )
    )
    (defun XB_DeployAccountNFT 
        (
            id:string account:string
            f:bool re:bool rnb:bool rnc:bool rnr:bool
            rnu:bool rmc:bool rmr:bool rsnu:bool rt:bool
        )
    )
    (defun XE_DeployAccountWNE (id:string son:bool account:string))
    (defun XE_U|SFT-Holdings (id:string account:string holdings:[object{DpdcUdc.DPSF|NonceBalance}]))
    (defun XE_U|NFT-Holdings (id:string account:string holdings:[integer]))
    (defun XE_U|DPDC-Fragments (id:string son:bool account:string fragments:[object{DpdcUdc.DPSF|NonceBalance}]))
    (defun XE_U|Rnaq (id:string account:string toggle))
    (defun XI_U|AccountRoles (id:string son:bool account:string new-roles:object{DpdcUdc.AccountRoles}))
    ;;
    ;; [<PropertiesTable> Writings] [1]
    ;;
    (defun XE_I|Collection (id:string son:bool idp:object{DpdcUdc.DPDC|Properties}))
    (defun XE_U|Specs (id:string son:bool specs:object{DpdcUdc.DPDC|Properties}))
    (defun XE_U|IsPaused (id:string son:bool toggle:bool))
    (defun XE_U|NoncesUsed (id:string son:bool new-nv:integer))
    (defun XE_U|SetClassesUsed (id:string son:bool new-nsc:integer))
    ;;
    ;; [<NoncesTable> Writings] [2]
    ;;
    (defun XE_I|CollectionElement (id:string son:bool nonce-value:integer ned:object{DpdcUdc.DPDC|NonceElement}))
    (defun XE_U|NonceOrSplitData (id:string son:bool nonce-value:integer nd:object{DpdcUdc.DPDC|NonceData} nos:bool))
    ;;
    ;; [<VerumRolesTable> Writings] [4]
    ;;
    (defun XE_I|VerumRoles (id:string son:bool verum-chain:object{DpdcUdc.DPDC|VerumRoles}))
    ;;
    ;;
    ;;
    (defun XE_U|Frozen (id:string son:bool account:string toggle))
    (defun XE_U|Exemption (id:string son:bool account:string toggle))
    (defun XE_U|Burn (id:string son:bool account:string toggle))
    (defun XE_U|Create (id:string son:bool account:string toggle))
    (defun XE_U|Recreate (id:string son:bool account:string toggle))
    (defun XE_U|Update (id:string son:bool account:string toggle))
    (defun XE_U|ModifyCreator (id:string son:bool account:string toggle))
    (defun XE_U|ModifyRoyalties (id:string son:bool account:string toggle))
    (defun XE_U|SetNewUri (id:string son:bool account:string toggle))
    (defun XE_U|Transfer (id:string son:bool account:string toggle))
    (defun XE_U|VerumRoles (id:string son:bool rp:integer aor:bool account:string))
)
;;
(interface DpdcCreate
    @doc "Holds the Create Functions, which also include the Credit and Debit Functions"
    ;;
    ;;  [UC]
    ;;
    (defun UC_CreditOrDebitNonceObject:[object{DpdcUdc.DPSF|NonceBalance}] (input-nbo:[object{DpdcUdc.DPSF|NonceBalance}] nonces-to-modify:[integer] amounts-to-modify-with:[integer] credit-or-debit:bool))
    (defun UC_AndTruths:bool (truths:[bool]))
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_NonceDataForCreation (ind:object{DpdcUdc.DPDC|NonceData}))
    (defun UEV_NonceType (nonce:integer fragments-or-native:bool))
    (defun UEV_NonceInclusion (id:string son:bool account:string nonce:integer fragments-or-native:bool))
    (defun UEV_Quantity (id:string son:bool account:string nonce:integer amount:integer))
    (defun UEV_NonceTypeMapper (nonces:[integer] fragments-or-native:bool))
    (defun UEV_NonceInclusionMapper (id:string son:bool account:string nonces:[integer] fragments-or-native:bool))
    (defun UEV_QuantityMapper (id:string son:bool account:string nonces:[integer] amounts:[integer]))
    (defun UEV_HybridNonces:object{OuronetIntegersV2.SplitIntegers} (nonces:[integer]))
    ;;
    ;;  [C]
    ;;
    (defun C_CreateNewNonce:object{IgnisCollector.OutputCumulator}
        (
            id:string son:bool nonce-class:integer amount:integer
            input-nonce-data:object{DpdcUdc.DPDC|NonceData} sft-set-mode:bool
        )
    )
    (defun C_CreateNewNonces:object{IgnisCollector.OutputCumulator}
        (
            id:string son:bool amounts:[integer]
            input-nonce-datas:[object{DpdcUdc.DPDC|NonceData}]
        )
    )
    ;;
    ;;  [X]
    ;;
    (defun XE_CreditSFT-FragmentNonce (id:string account:string nonce:integer amount:integer))
    (defun XE_CreditNFT-FragmentNonce (id:string account:string nonce:integer amount:integer))
    (defun XE_DebitSFT-FragmentNonce (id:string account:string nonce:integer amount:integer))
    (defun XE_DebitNFT-FragmentNonce (id:string account:string nonce:integer amount:integer))
    ;;
    (defun XB_CreditSFT-Nonce (id:string account:string nonce:integer amount:integer))
    (defun XB_CreditNFT-Nonce (id:string account:string nonce:integer amount:integer))
    (defun XE_DebitSFT-Nonce (id:string account:string nonce:integer amount:integer))
    (defun XE_DebitNFT-Nonce (id:string account:string nonce:integer amount:integer))
    ;;
    (defun XE_CreditSFT-FragmentNonces (id:string account:string nonces:[integer] amounts:[integer]))
    (defun XE_CreditNFT-FragmentNonces (id:string account:string nonces:[integer] amounts:[integer]))
    (defun XE_DebitSFT-FragmentNonces (id:string account:string nonces:[integer] amounts:[integer]))
    (defun XE_DebitNFT-FragmentNonces (id:string account:string nonces:[integer] amounts:[integer]))
    ;;
    (defun XB_CreditSFT-Nonces (id:string account:string nonces:[integer] amounts:[integer]))
    (defun XB_CreditNFT-Nonces (id:string account:string nonces:[integer] amounts:[integer]))
    (defun XE_DebitSFT-Nonces (id:string account:string nonces:[integer] amounts:[integer]))
    (defun XE_DebitNFT-Nonces (id:string account:string nonces:[integer] amounts:[integer]))
    ;;
    (defun XE_CreditSFT-HybridNonces (id:string account:string nonces:[integer] amounts:[integer]))
    (defun XE_CreditNFT-HybridNonces (id:string account:string nonces:[integer] amounts:[integer]))
    (defun XE_DebitSFT-HybridNonces (id:string account:string nonces:[integer] amounts:[integer]))
    (defun XE_DebitNFT-HybridNonces (id:string account:string nonces:[integer] amounts:[integer]))
    ;;
)
;;
(interface DpdcIssue
    @doc "Holds Issuing Functions"
    ;;
    ;;  [C]
    ;;
    (defun C_DeployAccountSFT (id:string account:string))
    (defun C_DeployAccountNFT (id:string account:string))
    (defun C_IssueDigitalCollection:object{IgnisCollector.OutputCumulator}
        (
            patron:string son:bool
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
    )
    ;;
)
;;
(interface DpdcRoles
    @doc "Holds Dpdc Roles Functions"
    ;;
    ;;  [C]
    ;;
    (defun C_ToggleAddQuantityRole:object{IgnisCollector.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_ToggleFreezeAccount:object{IgnisCollector.OutputCumulator} (id:string son:bool account:string toggle:bool))
    (defun C_ToggleExemptionRole:object{IgnisCollector.OutputCumulator} (id:string son:bool account:string toggle:bool))
    (defun C_ToggleBurnRole:object{IgnisCollector.OutputCumulator} (id:string son:bool account:string toggle:bool))
    (defun C_ToggleUpdateRole:object{IgnisCollector.OutputCumulator} (id:string son:bool account:string toggle:bool))
    (defun C_ToggleModifyCreatorRole:object{IgnisCollector.OutputCumulator} (id:string son:bool account:string toggle:bool))
    (defun C_ToggleModifyRoyaltiesRole:object{IgnisCollector.OutputCumulator} (id:string son:bool account:string toggle:bool))
    (defun C_ToggleTransferRole:object{IgnisCollector.OutputCumulator} (id:string son:bool account:string toggle:bool))
    (defun C_MoveCreateRole:object{IgnisCollector.OutputCumulator} (id:string son:bool new-account:string))
    (defun C_MoveRecreateRole:object{IgnisCollector.OutputCumulator} (id:string son:bool new-account:string))
    (defun C_MoveSetUriRole:object{IgnisCollector.OutputCumulator} (id:string son:bool new-account:string))
)
;;
(interface DpdcManagement
    @doc "Holds Dpdc Management Functions"
    ;;
    ;; [C]
    ;;
    (defun C_Control:object{IgnisCollector.OutputCumulator} (id:string son:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool))
    (defun C_TogglePause:object{IgnisCollector.OutputCumulator} (id:string son:bool toggle:bool))
)
;;
;;
;(interface DpdcTransfer
;    
;)
;;
(interface DpdcSets
    @doc "Holds Dpdc Set Related Functions"
    ;;
    ;;  [UR]
    ;;
    (defun UR_Set:object{DPDC|Set} (id:string son:bool set-class:integer))
    (defun UR_SetClass:integer (id:string son:bool set-class:integer))
    (defun UR_SetName:string (id:string son:bool set-class:integer))
    (defun UR_IzSetActive:bool (id:string son:bool set-class:integer))
    (defun UR_IzSetPrimordial:bool (id:string son:bool set-class:integer))
    (defun UR_IzSetComposite:bool (id:string son:bool set-class:integer))
    (defun UR_PSD:[object{DPDC|AllowedNonceForSetPosition}] (id:string son:bool set-class:integer))
    (defun UR_CSD:[object{DPDC|AllowedClassForSetPosition}] (id:string son:bool set-class:integer))
    (defun UR_SetNonceData:object{DPDC|NonceData} (id:string son:bool set-class:integer))
    (defun UR_SetSplitData:object{DPDC|NonceData} (id:string son:bool set-class:integer))
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_PrimordialSetDefinition (id:string son:bool set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]))
    (defun UEV_CompositeSetDefinition (id:string son:bool set-definition:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]))
    (defun UEV_SetClass (id:string son:bool set-class:integer))
    (defun UEV_IzSetClassFragmented:bool (id:string son:bool set-class:integer))
    (defun UEV_Fragmentation (id:string son:bool set-class:integer))
    (defun UEV_SetActiveState (id:string son:bool set-class:integer state:bool))
    ;;
    ;;  [C]
    ;;
    (defun C_DefinePrimordialSet:object{IgnisCollector.OutputCumulator}
        (
            id:string son:bool set-name:string
            set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun C_DefineCompositeSet:object{IgnisCollector.OutputCumulator}
        (
            id:string son:bool set-name:string
            set-definition:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun C_EnableSetClassFragmentation:object{IgnisCollector.OutputCumulator}
        (
            id:string son:bool set-class:integer
            fragmentation-ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun C_ToggleSet:object{IgnisCollector.OutputCumulator} (id:string son:bool set-class:integer toggle:bool))
    (defun C_RenameSet:object{IgnisCollector.OutputCumulator} (id:string son:bool set-class:integer new-name:string))
    ;;
)
;;
(interface DpdcFragments
    @doc "Holds Dpdc Fragmentation Related Functions"
    ;;
    ;; [UEV]
    ;;
    (defun UEV_IzNonceFragmented:bool (id:string son:bool nonce:integer))
    (defun UEV_Fragmentation (id:string son:bool nonce:integer))
    ;;
    ;; [C]
    ;;
    (defun C_EnableNonceFragmentation:object{IgnisCollector.OutputCumulator}
        (
            id:string son:bool nonce:integer
            fragmentation-ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
)
;;
(interface DpdcNonce
    @doc "Contains exported Functions from DPDC-UtilityTwo Module"
    ;;
    ;; [UR]
    ;;
    (defun UR_Nonce:object{DpdcUdc.DPDC|NonceData} (id:string son:bool nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool))
    ;;
    ;; [UEV]
    ;;
    (defun UEV_NonceDataUpdater (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool))
    (defun UEV_RoleNftRecreateON (id:string son:bool account:string))
    (defun UEV_RoleNftUpdateON (id:string son:bool account:string))
    (defun UEV_RoleModifyRoyaltiesON (id:string son:bool account:string))
    (defun UEV_RoleSetNewUriON (id:string son:bool account:string))
    (defun UEV_Score (score:decimal))
    ;;
    ;; [C]
    ;;
    (defun C_UpdateNonce (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData}))
    (defun C_UpdateNonceRoyalty (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool royalty-value:decimal))
    (defun C_UpdateNonceIgnisRoyalty (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool royalty-value:decimal))
    (defun C_UpdateNonceName (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool name:string))
    (defun C_UpdateNonceDescription (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool description:string))
    (defun C_UpdateNonceScore (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool score:decimal))
    (defun C_UpdateNonceMetaData (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool meta-data:[object]))
    (defun C_UpdateNonceURI
        (
            id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool
            ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}
        )
    )
)