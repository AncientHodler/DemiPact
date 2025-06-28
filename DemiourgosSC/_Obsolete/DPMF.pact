(module DPMF GOVERNANCE
    @doc "Core_DPMF is the Demiourgos.Holdings Module for the management of DPMF Tokens \
    \ DPMF-Tokens = Demiourgos Pact Meta Fungible Tokens \
    \ DPMF-Tokens mimic the functionality of the Meta-ESDT Token introduced by MultiversX (former Elrond) Blockchain"


    ;;0]GOVERNANCE-ADMIN
    ;;
    ;;      GOVERNANCE|DPMF_CLIENT
    ;;
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
            \ Remove Comment below so that only ADMIN (<free.DH_Master-Keyset>) can enact an upgrade"
        false
        ;;(enforce-guard (keyset-ref-guard OUROBOROS.DEMIURGOI))
    )


    ;;1]CONSTANTS Definitions
    ;;Smart-Contract Key and Name Definitions
        ;;Module Management - OUROBOROS.DEMIURGOI
        ;;DPTS Account Management for the Module: NONE

    (defconst BAR OUROBOROS.DALOS|BAR)

    ;;2]SCHEMA Definitions
    ;;Demiourgos Pact META Fungible Token Standard - DPMF

    
    ;;SCHEMA for MetaFungible defined as constants to be used as Object Keys
    
    (defschema NonceBalance_Schema
        nonce:integer
        balance:decimal
    )
    ;;Neutral MetaFungible Definition, used for existing MetaFungible Accounts that hold no tokens
    (defconst NEUTRAL_META-FUNGIBLE
        { "nonce": 0
        , "balance": 0.0
        , "meta-data": [{}] }
    )
    ;;Used for non existing MetaFungible Account
    (defconst NEGATIVE_META-FUNGIBLE
        { "nonce": -1
        , "balance": -1.0
        , "meta-data": [{}] }
    )

    ;;3]TABLES Definitions
    (deftable DPMF-PropertiesTable:{DPMF-PropertiesSchema})
    (deftable DPMF-BalancesTable:{DPMF-BalanceSchema})
    

    
    ;;==============================================
    ;;                                            ;;
    ;;      CAPABILITIES                          ;;
    ;;                                            ;;
    ;;      BASIC                                 ;;
    ;;                                            ;;
    ;;======DPMF-PROPERTIES-TABLE-MANAGEMENT========
    ;;
    ;;      DPMF_OWNER
    ;;      DPMF_CAN-CHANGE-OWNER_ON|DPMF_CAN-UPGRADE_ON|DPMF_CAN-ADD-SPECIAL-ROLE_ON
    ;;      DPMF_CAN-FREEZE_ON|DPMF_CAN-WIPE_ON|DPMF_CAN-PAUSE_ON|DPMF_IS-PAUSED_ON|DPMF_IS-PAUSED_OF
    ;;      DPMF_CAN-TRANSFER-NFT-CREATE-ROLE_ON
    ;;      DPMF_UPDATE_SUPPLY|DPMF_UPDATE_TRANSFER-ROLE-AMOUNT||DPMF_INCREASE_NONCE
    ;;
    
    ;;======DPMF-BALANCES-TABLE-MANAGEMENT==========
    ;;
    ;;      DPMF_ACCOUNT_EXISTANCE|DPMF_ACCOUNT_OWNER
    ;;      DPMF_ACCOUNT_ADD-QUANTITY_ON|DPMF_ACCOUNT_ADD-QUANTITY_OFF
    ;;      DPMF_ACCOUNT_BURN_ON|DPMF_ACCOUNT_BURN_OFF
    ;;      DPMF_ACCOUNT_CREATE_ON|DPMF_ACCOUNT_CREATE_OFF
    ;;      DPMF_ACCOUNT_TRANSFER_ON|DPMF_ACCOUNT_TRANSFER_OFF
    ;;      DPMF_ACCOUNT_FREEZE_ON|DPMF_ACCOUNT_FREEZE_OFF
    ;;
    
    ;;==============================================
    ;;                                            ;;
    ;;      DPMF: COMPOSED CAPABILITIES           ;;
    ;;                                            ;;
    ;;==================CONTROL======================
    ;;
    ;;      DPMF_OWNERSHIP-CHANGE|DPMF_OWNERSHIP-CHANGE_CORE|DPMF_CONTROL|DPMF_CONTROL_CORE
    ;;      DPMF_TOGGLE_PAUSE|DPMF_PAUSE|DPMF_PAUSE_CORE|DPMF_UNPAUSE|DPMF_UNPAUSE_CORE
    ;;      DPMF_TOGGLE_FREEZE-ACCOUNT|DPMF_FREEZE-ACCOUNT|DPMF_FREEZE-ACCOUNT_CORE|DPMF_UNFREEZE-ACCOUNT|DPMF_UNFREEZE-ACCOUNT_CORE
    ;;
    

    ;;==================TOKEN-ROLES=================
    ;;
    ;;      DPMF_MOVE_CREATE-ROLE|DPMF_MOVE_CREATE-ROLE_CORE
    ;;      DPMF_TOGGLE_ADD-QUANTITY-ROLE|DPMF_TOGGLE_ADD-QUANTITY-ROLE_CORE
    ;;      DPMF_TOGGLE_BURN-ROLE|DPMF_TOGGLE_BURN-ROLE_CORE
    ;;      DPMF_TOGGLE_TRANSFER-ROLE|DPMF_TOGGLE_TRANSFER-ROLE_CORE
    ;;
    
    ;;==================CREATE=======================
    ;;
    ;;      DPMF_MINT|DPMF_MINT_CORE|
    ;;      DPMF_CREATE|DPMF_CREATE_CORE
    ;;      DPMF_ADD-QUANTITY|DPMF_ADD-QUANTITY_CORE
    ;;
    
    ;;==================DESTROY======================
    ;;
    ;;      DPMF_BURN|DPMF_BURN_CORE
    ;;      DPMF_WIPE|DPMF_WIPE_CORE
    ;;
    
    ;;==================TRANSFER==================== 
    ;;
    ;;      TRANSFER_DPMF|TRANSFER_DPMF_CORE|
    ;;
    
    ;;=================CORE==========================
    ;;
    ;;      CREDIT_DPMF|DEBIT_DPMF
    ;;
    
    
    ;;==============================================
    ;;                                            ;;
    ;;      UTILITY FUNCTIONS                     ;;
    ;;                                            ;;
    ;;==================ACCOUNT-INFO================
    ;;
    ;;      UR_AccountMetaFungibles
    ;;      UR_AccountMetaFungibleSupply|UR_AccountMetaFungibleUnit
    ;;      UR_AccountMetaFungibleRoleNFTAQ|UR_AccountMetaFungibleRoleBurn|UR_AccountMetaFungibleRoleCreate
    ;;      UR_AccountMetaFungibleRoleTransfer|UR_AccountMetaFungibleFrozenState
    ;;
    ;;
    
    ;;
    ;;==================ACCOUNT-NONCE===============
    ;;
    ;;      UR_AccountMetaFungibleBalances|UR_AccountMetaFungibleNonces
    ;;      UR_AccountMetaFungibleBalance|UR_AccountMetaFungibleMetaData
    ;;
    
    ;;
    ;;==================TRUE-FUNGIBLE-INFO==========
    ;;
    ;;      UR_MetaFungibleKonto|UR_MetaFungibleName|UR_MetaFungibleTicker|UR_MetaFungibleDecimals
    ;;      UR_MetaFungibleCanChangeOwner|UR_MetaFungibleCanUpgrade|UR_MetaFungibleCanAddSpecialRole
    ;;      UR_MetaFungibleCanFreeze|UR_MetaFungibleCanWipe|UR_MetaFungibleCanPause|UR_MetaFungibleIsPaused
    ;;      UR_MetaFungibleSupply|UR_MetaFungibleCreateRoleAccount|UR_MetaFungibleTransferRoleAmount|UR_MetaFungibleNoncesUsed
    ;;
    
    ;;
    ;;==================VALIDATIONS=================
    ;;
    ;;      UV_MetaFungibleAmount|UV_MetaFungibleIdentifier
    ;;
    
    ;;
    ;;==================Composition=================
    ;;
    ;;      UC_ComposeMetaFungible|UC_Nonce-Balance_Pair
    ;;
    
    ;;--------------------------------------------;;
    ;;                                            ;;
    ;;      ADMINISTRATION FUNCTIONS              ;;
    ;;                                            ;;
    ;;      NO ADMINISTRATOR FUNCTIONS            ;;
    ;;                                            ;;
    ;;--------------------------------------------;;
    ;;                                            ;;
    ;;      CLIENT FUNCTIONS                      ;;
    ;;                                            ;;
    ;;                                            ;;
    ;;==================CONTROL=====================
    ;;
    ;;      C_ChangeOwnership|C_Control
    ;;      C_TogglePause|C_ToggleFreezeAccount
    ;;
    
    ;;==================ROLES======================= 
    ;;
    ;;      C_MoveCreateRole|C_ToggleAddQuantityRole
    ;;      C_ToggleBurnRole|C_ToggleTransferRole
    ;;
    
    ;;==================CREATE====================== 
    ;;
    ;;      C_IssueMetaFungible|C_DeployMetaFungibleAccount
    ;;      C_Mint|CX_Mint|C_Create|CX_Create|C_AddQuantity|CX_AddQuantity
    ;;
    
    ;;==================DESTROY=====================
    ;;
    ;;      C_Burn|CX_Burn|C_Wipe
    ;;
    
    ;;==================TRANSFER====================
    ;;
    ;;     C_TransferMetaFungible|CX_TransferMetaFungible
    ;;
    
    ;;==============================================
    ;;                                            ;;
    ;;      DPMF: AUXILIARY FUNCTIONS             ;;
    ;;                                            ;;
    ;;==================TRANSFER====================
    ;;
    ;;      X_TransferMetaFungible
    ;;
    
    ;;==================CREDIT|DEBIT================ 
    ;;
    ;;      X_Credit|X_Debit
    ;;      X_DebitPaired|X_DebitMultiple
    ;;
    
    ;;
    ;;==================UPDATE======================
    ;;
    ;;      X_UpdateSupply|X_IncrementNonce|X_UpdateRoleTransferAmount
    ;;
    
    ;;==================AUXILIARY=================== 
    ;;
    ;;      X_ChangeOwnership|X_Control|X_TogglePause|X_ToggleFreezeAccount
    ;;      X_MoveCreateRole|X_ToggleAddQuantityRole|X_ToggleBurnRole|X_ToggleTransferRole
    ;;      X_IssueMetaFungible|X_Mint|X_Create|X_AddQuantity
    ;;      X_Burn|X_Wipe
    ;;
    
)

(create-table DPMF-PropertiesTable)
(create-table DPMF-BalancesTable)