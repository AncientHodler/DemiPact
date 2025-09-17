(interface TalosStageTwo_ClientOne
    @doc "Exposes Client SFT Functions"
    ;;
    ;;  [2] DPDC
    ;;
    (defun DPSF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun DPSF|C_UpgradeBranding (patron:string entity-id:string months:integer))
    ;;
    ;;  [3] DPDC-C
    ;;
    (defun DPSF|C_Create:string
        (
            patron:string id:string amount:[integer]
            input-nonce-data:[object{DpdcUdc.DPDC|NonceData}]
        )
    )
    ;;
    ;;  [4] DPDC-I
    ;;
    (defun DPSF|C_DeployAccount (patron:string account:string id:string))
    (defun DPSF|C_Issue:string 
        (
            patron:string 
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
    )
    ;;
    ;;  [5] DPDC-R
    ;;
    (defun DPSF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_ToggleExemptionRole (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_ToggleUpdateRole (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_ToggleModifyCreatorRole (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_ToggleModifyRoyaltiesRole (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_MoveCreateRole (patron:string id:string new-account:string))
    (defun DPSF|C_MoveRecreateRole (patron:string id:string new-account:string))
    (defun DPSF|C_MoveSetUriRole (patron:string id:string new-account:string))
    ;;
    ;;  [6] DPDC-MNG
    ;;
    (defun DPSF|C_Control (patron:string id:string cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool))
    (defun DPSF|C_TogglePause (patron:string id:string toggle:bool))
        ;;
    (defun DPSF|C_AddQuantity (patron:string id:string account:string nonce:integer amount:integer))
    (defun DPSF|C_Burn (patron:string id:string account:string nonce:integer amount:integer))
    (defun DPSF|C_WipeNoncePartialy (patron:string id:string account:string nonce:integer amount:integer))
    (defun DPSF|C_WipeNonce (patron:string id:string account:string nonce:integer))
        ;;
    (defun DPSF|C_WipeHeavy (patron:string account:string id:string))
    (defun DPSF|C_WipePure (patron:string account:string id:string removable-nonces-obj:object{DpdcManagement.RemovableNonces}))
    (defun DPSF|C_WipeClean (patron:string account:string id:string nonces:[integer]))
    (defun DPSF|C_WipeDirty (patron:string account:string id:string nonces:[integer]))
    ;;
    ;;  [7] DPDC-T
    ;;
    (defun DPSF|C_TransferNonce (patron:string id:string sender:string receiver:string nonce:integer amount:integer method:bool))
    (defun DPSF|C_TransferNonces (patron:string id:string sender:string receiver:string nonces:[integer] amounts:[integer] method:bool))
    ;;
    ;;  [8] DPDC-S
    ;;
    (defun DPSF|C_Make (patron:string account:string id:string nonces:[integer] set-class:integer))
    (defun DPSF|C_Break (patron:string account:string id:string nonce:integer))
    (defun DPSF|C_DefinePrimordialSet 
        (
            patron:string id:string set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun DPSF|C_DefineCompositeSet
        (
            patron:string id:string set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun DPSF|C_DefineHybridSet
        (
            patron:string id:string set-name:string score-multiplier:decimal
            primordial-sd:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            composite-sd:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun DPSF|C_EnableSetClassFragmentation
        (
            patron:string id:string set-class:integer
            fragmentation-ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun DPSF|C_ToggleSet (patron:string id:string set-class:integer toggle:bool))
    (defun DPSF|C_RenameSet (patron:string id:string set-class:integer new-name:string))
    (defun DPSF|C_UpdateSetMultiplier (patron:string id:string set-class:integer new-multiplier:decimal))
    ;;
    (defun DPSF|C_UpdateSetNonce                (patron:string id:string account:string set-class:integer nos:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData}))
    (defun DPSF|C_UpdateSetNonceRoyalty         (patron:string id:string account:string set-class:integer nos:bool royalty-value:decimal))
    (defun DPSF|C_UpdateSetNonceIgnisRoyalty    (patron:string id:string account:string set-class:integer nos:bool royalty-value:decimal))
    (defun DPSF|C_UpdateSetNonceName            (patron:string id:string account:string set-class:integer nos:bool name:string))
    (defun DPSF|C_UpdateSetNonceDescription     (patron:string id:string account:string set-class:integer nos:bool description:string))
    (defun DPSF|C_UpdateSetNonceScore           (patron:string id:string account:string set-class:integer nos:bool score:decimal))
    (defun DPSF|C_RemoveSetNonceScore           (patron:string id:string account:string set-class:integer nos:bool))
    (defun DPSF|C_UpdateSetNonceMetaData        (patron:string id:string account:string set-class:integer nos:bool meta-data:object))
    (defun DPSF|C_UpdateSetNonceURI             (patron:string id:string account:string set-class:integer nos:bool ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}))
    ;;
    ;;  [9] DPDC-F
    ;;
    (defun DPSF|C_MakeFragments (patron:string account:string id:string nonce:integer amount:integer))
    (defun DPSF|C_MergeFragments (patron:string account:string id:string nonce:integer amount:integer))
    (defun DPSF|C_EnableNonceFragmentation (patron:string id:string nonce:integer fragmentation-ind:object{DpdcUdc.DPDC|NonceData}))
    ;;
    ;;  [10] DPDC-N
    ;;
    (defun DPSF|C_UpdateNonce               (patron:string id:string account:string nonce:integer nos:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData}))
    (defun DPSF|C_UpdateNonceRoyalty        (patron:string id:string account:string nonce:integer nos:bool royalty-value:decimal))
    (defun DPSF|C_UpdateNonceIgnisRoyalty   (patron:string id:string account:string nonce:integer nos:bool royalty-value:decimal))
    (defun DPSF|C_UpdateNonceName           (patron:string id:string account:string nonce:integer nos:bool name:string))
    (defun DPSF|C_UpdateNonceDescription    (patron:string id:string account:string nonce:integer nos:bool description:string))
    (defun DPSF|C_UpdateNonceScore          (patron:string id:string account:string nonce:integer nos:bool score:decimal))
    (defun DPSF|C_RemoveNonceScore          (patron:string id:string account:string nonce:integer nos:bool))
    (defun DPSF|C_UpdateNonceMetaData       (patron:string id:string account:string nonce:integer nos:bool meta-data:object))
    (defun DPSF|C_UpdateNonceURI            (patron:string id:string account:string nonce:integer nos:bool ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}))
    ;;
    ;;
    ;;  [10] EQUITY
    ;;
    (defun DPSF|C_IssueCompany:string
        (
            patron:string creator-account:string collection-name:string collection-ticker:string
            royalty:decimal ignis-royalty:decimal ipfs-links:[string]
        )
    )
    (defun DPSF|C_MorphEquity (patron:string account:string id:string input-nonce:integer input-amount:integer output-nonce:integer))
    ;;
)

(interface TalosStageTwo_ClientTwo
    @doc "Exposes Client NFT Functions"
    ;;
    ;;  [2] DPDC
    ;;
    (defun DPNF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun DPNF|C_UpgradeBranding (patron:string entity-id:string months:integer))
    ;;
    ;;  [3] DPDC-C
    ;;
    (defun DPNF|C_Create:string
        (
            patron:string id:string
            input-nonce-data:[object{DpdcUdc.DPDC|NonceData}]
        )
    )
    ;;
    ;;  [4] DPDC-I
    ;;
    (defun DPNF|C_DeployAccount (patron:string account:string id:string))
    (defun DPNF|C_Issue:string
        (
            patron:string 
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
    )
    ;;
    ;;  [5] DPDC-R
    ;;
    (defun DPNF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool))
    (defun DPNF|C_ToggleExemptionRole (patron:string id:string account:string toggle:bool))
    (defun DPNF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool))
    (defun DPNF|C_ToggleUpdateRole (patron:string id:string account:string toggle:bool))
    (defun DPNF|C_ToggleModifyCreatorRole (patron:string id:string account:string toggle:bool))
    (defun DPNF|C_ToggleModifyRoyaltiesRole (patron:string id:string account:string toggle:bool))
    (defun DPNF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool))
    (defun DPNF|C_MoveCreateRole (patron:string id:string new-account:string))
    (defun DPNF|C_MoveRecreateRole (patron:string id:string new-account:string))
    (defun DPNF|C_MoveSetUriRole (patron:string id:string new-account:string))
    ;;
    ;;  [6] DPDC-MNG
    ;;
    (defun DPNF|C_Control (patron:string id:string cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool))
    (defun DPNF|C_TogglePause (patron:string id:string toggle:bool))
        ;;
    (defun DPNF|C_Respawn (patron:string id:string account:string nonce:integer))
    (defun DPNF|C_Burn (patron:string id:string account:string nonce:integer))
    (defun DPNF|C_WipeNonce (patron:string id:string account:string nonce:integer))
        ;;
    (defun DPNF|C_WipeHeavy (patron:string account:string id:string))
    (defun DPNF|C_WipePure (patron:string account:string id:string removable-nonces-obj:object{DpdcManagement.RemovableNonces}))
    (defun DPNF|C_WipeClean (patron:string account:string id:string nonces:[integer]))
    (defun DPNF|C_WipeDirty (patron:string account:string id:string nonces:[integer]))

    ;;
    ;;  [7] DPDC-T
    ;;
    (defun DPNF|C_TransferNonce (patron:string id:string sender:string receiver:string nonce:integer amount:integer method:bool))
    (defun DPNF|C_TransferNonces (patron:string id:string sender:string receiver:string nonces:[integer] amounts:[integer] method:bool)) 
    ;;
    ;;  [8] DPDC-S
    ;;
    (defun DPNF|C_Make (patron:string account:string id:string nonces:[integer] set-class:integer))
    (defun DPNF|C_Break (patron:string account:string id:string nonce:integer))
    (defun DPNF|C_DefinePrimordialSet 
        (
            patron:string id:string set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun DPNF|C_DefineCompositeSet
        (
            patron:string id:string set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun DPNF|C_DefineHybridSet
        (
            patron:string id:string set-name:string score-multiplier:decimal
            primordial-sd:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            composite-sd:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun DPNF|C_EnableSetClassFragmentation
        (
            patron:string id:string set-class:integer
            fragmentation-ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun DPNF|C_ToggleSet (patron:string id:string set-class:integer toggle:bool))
    (defun DPNF|C_RenameSet (patron:string id:string set-class:integer new-name:string))
    (defun DPNF|C_UpdateSetMultiplier (patron:string id:string set-class:integer new-multiplier:decimal))
    ;;
    (defun DPNF|C_UpdateSetNonce                (patron:string id:string account:string set-class:integer nos:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData}))
    (defun DPNF|C_UpdateSetNonceRoyalty         (patron:string id:string account:string set-class:integer nos:bool royalty-value:decimal))
    (defun DPNF|C_UpdateSetNonceIgnisRoyalty    (patron:string id:string account:string set-class:integer nos:bool royalty-value:decimal))
    (defun DPNF|C_UpdateSetNonceName            (patron:string id:string account:string set-class:integer nos:bool name:string))
    (defun DPNF|C_UpdateSetNonceDescription     (patron:string id:string account:string set-class:integer nos:bool description:string))
    (defun DPNF|C_UpdateSetNonceScore           (patron:string id:string account:string set-class:integer nos:bool score:decimal))
    (defun DPNF|C_RemoveSetNonceScore           (patron:string id:string account:string set-class:integer nos:bool))
    (defun DPNF|C_UpdateSetNonceMetaData        (patron:string id:string account:string set-class:integer nos:bool meta-data:object))
    (defun DPNF|C_UpdateSetNonceURI             (patron:string id:string account:string set-class:integer nos:bool ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}))
    ;;
    ;;  [9] DPDC-F
    ;;
    (defun DPNF|C_MakeFragments (patron:string account:string id:string nonce:integer amount:integer))
    (defun DPNF|C_MergeFragments (patron:string account:string id:string nonce:integer amount:integer))
    (defun DPNF|C_EnableNonceFragmentation (patron:string id:string nonce:integer fragmentation-ind:object{DpdcUdc.DPDC|NonceData}))
    ;;
    ;;  [10] DPDC-N
    ;;
    (defun DPNF|C_UpdateNonce               (patron:string id:string account:string nonce:integer nos:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData}))
    (defun DPNF|C_UpdateNonceRoyalty        (patron:string id:string account:string nonce:integer nos:bool royalty-value:decimal))
    (defun DPNF|C_UpdateNonceIgnisRoyalty   (patron:string id:string account:string nonce:integer nos:bool royalty-value:decimal))
    (defun DPNF|C_UpdateNonceName           (patron:string id:string account:string nonce:integer nos:bool name:string))
    (defun DPNF|C_UpdateNonceDescription    (patron:string id:string account:string nonce:integer nos:bool description:string))
    (defun DPNF|C_UpdateNonceScore          (patron:string id:string account:string nonce:integer nos:bool score:decimal))
    (defun DPNF|C_RemoveNonceScore          (patron:string id:string account:string nonce:integer nos:bool))
    (defun DPNF|C_UpdateNonceMetaData       (patron:string id:string account:string nonce:integer nos:bool meta-data:object))
    (defun DPNF|C_UpdateNonceURI            (patron:string id:string account:string nonce:integer nos:bool ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}))
    ;;
)

(interface TalosStageTwo_DemiPad
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
    (defun DEMIPAD|C_Withdraw (patron:string asset-id:string type:integer destination:string))
    ;;
    (defun DEMIPAD|C_FuelTrueFungible (patron:string client:string asset-id:string amount:decimal))
    (defun DEMIPAD|C_FuelOrtoFungible (patron:string client:string asset-id:string nonces:[integer]))
    (defun DEMIPAD|C_FuelSemiFungible (patron:string client:string asset-id:string nonces:[integer] amounts:[integer]))
    (defun DEMIPAD|C_FuelNonFungible (patron:string client:string asset-id:string nonces:[integer] amounts:[integer]))

    (defun DEMIPAD|C_RetrieveTrueFungible (patron:string client:string asset-id:string amount:decimal))
    (defun DEMIPAD|C_RetrieveOrtoFungible (patron:string client:string asset-id:string nonces:[integer]))
    (defun DEMIPAD|C_RetrieveSemiFungible (patron:string client:string asset-id:string nonces:[integer] amounts:[integer]))
    (defun DEMIPAD|C_RetrieveNonFungible (patron:string client:string asset-id:string nonces:[integer] amounts:[integer]))
    ;;
    (defun SPARK|C_BuySparks (patron:string buyer:string sparks-amount:integer iz-native:bool))
    (defun SPARK|C_RedemAllSparks (patron:string redemption-payer:string account-to-redeem:string))
    (defun SPARK|C_RedemFewSparks (patron:string redemption-payer:string account-to-redeem:string redemption-quantity:integer))
    (defun SNAKES|C_Acquire (patron:string buyer:string nonce:integer amount:integer iz-native:bool))
    (defun CUSTODIANS|C_Acquire (patron:string buyer:string nonce:integer amount:integer iz-native:bool))
    ;;
)