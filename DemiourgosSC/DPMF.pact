(module DPMF GOVERNANCE
    @doc "Core_DPMF is the Demiourgos.Holdings Module for the management of DPMF Tokens \
    \ DPMF-Tokens = Demiourgos Pact Meta Fungible Tokens \
    \ DPMF-Tokens mimic the functionality of the Meta-ESDT Token introduced by MultiversX (former Elrond) Blockchain"


    ;;0]GOVERNANCE-ADMIN
    ;;
    ;;      GOVERNANCE|DPMF_ADMIN|DPMF_CLIENT
    ;;
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
        \ Set to DPMF_ADMIN so that only Module Key can enact an upgrade"
        false
    )
    (defcap DPMF_ADMIN ()
        (enforce-guard (keyset-ref-guard SC_KEY))
    )
    (defcap DPMF_CLIENT (identifier:string account:string)
        (let
            (
                (iz-sc:bool (OUROBOROS.UR_DPTS-AccountType account))
            )
            (if (= iz-sc true)
                true
                (compose-capability (DPMF_ACCOUNT_OWNER identifier account))
            )
        )
    )

    ;;1]CONSTANTS Definitions
    ;;Smart-Contract Key and Name Definitions
    (defconst SC_KEY "free.DH-Master-Keyset")
    (defconst SC_NAME "Demiourgos-Pact-Meta-Fungible")
    (defconst BAR OUROBOROS.BAR)

    ;;2]SCHEMA Definitions
    ;;Demiourgos Pact META Fungible Token Standard - DPMF
    (defschema DPMF-PropertiesSchema
        @doc "Schema for DPMF Token (MEta Fungibles) Properties \
        \ Key for Table is DPMF Token Identifier. This ensure a unique entry per Token Identifier"

        owner-konto:string                  ;;Account of the Token Owner, Account that created the DPMF Token
        name:string                         ;;Token Name (Alpha-Numeric 3-50 Characters Long)
        ticker:string                       ;;Token Ticker (Capital Alpha-Numeric 3-20 Characters Long)
        decimals:integer                    ;;Token Decimal Number

                                            ;;TM=Token Manager
        can-change-owner:bool               ;;Token management can be transferred to a different account                      
        can-upgrade:bool                    ;;TM may change these properties
        can-add-special-role:bool           ;;TM can assign a specific role(s)
        can-freeze:bool                     ;;TM may freeze the token balance in a specific account, preventing transfers to and from that account
        can-wipe:bool                       ;;TM may wipe out the tokens held by a frozen account, reducing the supply
        can-pause:bool                      ;;TM may prevent all transactions of the token, apart from minting and burning
        is-paused:bool                      ;;Stores state of pause/unpause for the Token
        can-transfer-nft-create-role:bool   ;;TM may change the role of creating Tokens to another account

        supply:decimal                      ;;Stores the Token Total Supply
        create-role-account:string          ;;Stores the account with the create role. A single account may have this role.

        role-transfer-amount:integer        ;;Stores how many accounts have Transfer Roles for the Token.
        nonces-used:integer                 ;;Stores how many nonces have been used already
    )
    (defschema DPMF-BalanceSchema
        @doc "Schema that Stores Account Balances for DPMF Tokens (Meta-Fungibles)\
        \ Key for the Table is a string composed of: \
        \ <DPTS Identifier> + BAR + <account> \
        \ This ensure a single entry per DPMF Identifier-and-Nonce per account.\
        \ <Nonce> is the string representation of an integer in base 10 as opposed to \
        \ MultiversX representation of the nonce which is the string representation of an integer in base 16, padded \
        \ This different <Nonce> representation is used for simplicity"

        unit:[object{MetaFungible_Schema}]  ;;Stores NFT Data in a list of Objects that use the MetaFungible schema
        ;;Special Roles
        role-nft-add-quantity:bool          ;;when true, Account can add quantity for the specific DPMF Token
        role-nft-burn:bool                  ;;when true, Account can burn DPMF Tokens locally
        role-nft-create:bool                ;;when true, Account can create DPMF Tokens locally
        role-transfer:bool                  ;;when true, Transfer is restricted. Only accounts with true Transfer Role
                                            ;;can transfer token, while all other accounts can only transfer to such accounts
        ;;States
        frozen:bool                         ;;Determines wheter Account is frozen for DPMF Token Identifier
    )
    ;;SCHEMA for MetaFungible defined as constants to be used as Object Keys
    (defschema MetaFungible_Schema
        nonce:integer
        balance:decimal
        meta-data:[object]
    )
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
    

    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      CAPABILITIES                                                                                                                                ;;
    ;;                                                                                                                                                  ;;
    ;;      CORE                                    Module Core Capabilities                                                                            ;;
    ;;      BASIC                                   Basic Capabilities represent singular capability Definitions                                        ;;
    ;;      COMPOSED                                Composed Capabilities are made of one or multiple Basic Capabilities                                ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      CORE                                                                                                                                        ;;
    ;;                                                                                                                                                  ;;
    ;;      GOVERNANCE                              Module Governance Capability                                                                        ;;
    ;;      DPMF_ADMIN                              Module Admin Capability                                                                             ;;
    ;;      DPMF_CLIENT                             Module Client Capability                                                                            ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      BASIC                                                                                                                                       ;;
    ;;                                                                                                                                                  ;;
    ;;======DPMF-PROPERTIES-TABLE-MANAGEMENT========                                                                                                    ;;
    ;;      DPMF_OWNER                              Enforces DPMF Token Ownership                                                                       ;;
    ;;      DPMF_CAN-CHANGE-OWNER_ON                Enforced DPTF Token Ownership can be changed                                                        ;;
    ;;      DPMF_CAN-UPGRADE_ON                     Enforces DPMF Token upgrade-ability                                                                 ;;
    ;;      DPMF_CAN-ADD-SPECIAL-ROLE_ON            Enforces Token Property as true                                                                     ;;
    ;;      DPMF_CAN-FREEZE_ON                      Enforces Token Property as true                                                                     ;;
    ;;      DPMF_CAN-WIPE_ON                        Enforces Token Property as true                                                                     ;;
    ;;      DPMF_CAN-PAUSE_ON                       Enforces Token Property as true                                                                     ;;
    ;;      DPMF_IS-PAUSED_ON                       Enforces that the DPMF Token is paused                                                              ;;
    ;;      DPMF_IS-PAUSED_OF                       Enforces that the DPMF Token is not paused                                                          ;;
    ;;      DPMF_CAN-TRANSFER-NFT-CREATE-ROLE_ON    Enforces DPMF Token Property as true                                                                ;;
    ;;      DPMF_UPDATE_SUPPLY                      Capability required to update DPMF Supply                                                           ;;
    ;;      DPMF_UPDATE_ROLE-TRANSFER-AMOUNT        Capability required to update |transfer-role-amount| for Identifier <identifier>                    ;;
    ;;      DPMF_INCREASE_NONCE                     Capability required to update |nonce| in the DPMF-PropertiesTable                                   ;;
    ;;======DPMF-BALANCES-TABLE-MANAGEMENT==========                                                                                                    ;;
    ;;      DPMF_ACCOUNT_EXIST                      Enforces that the DPMF Account <account> exists for Token <identifier>                              ;;
    ;;      DPMF_ACCOUNT_OWNER                      Enforces DPMF Account Ownership                                                                     ;;
    ;;      DPMF_ACCOUNT_ADD-QUANTITY_ON            Enforces DPMF Account has add-quantity role on                                                      ;;
    ;;      DPMF_ACCOUNT_ADD-QUANTITY_OFF           Enforces DPMF Account has add-quantity role off                                                     ;;
    ;;      DPMF_ACCOUNT_BURN_ON                    Enforces DPMF Account has burn role on                                                              ;;
    ;;      DPMF_ACCOUNT_BURN_OFF                   Enforces DPMF Account has burn role off                                                             ;;
    ;;      DPMF_ACCOUNT_CREATE_ON                  Enforces DPMF Account has create role on                                                            ;;
    ;;      DPMF_ACCOUNT_CREATE_OFF                 Enforces DPMF Account has create role off                                                           ;;
    ;;      DPMF_ACCOUNT_TRANSFER_ON                Enforces DPMF Account has transfer role on                                                          ;;
    ;;      DPMF_ACCOUNT_TRANSFER_OFF               Enforces DPMF Account has transfer role off                                                         ;;
    ;;      DPMF_ACCOUNT_FREEZE_ON                  Enforces DPMF Account is frozen                                                                     ;;
    ;;      DPMF_ACCOUNT_FREEZE_OFF                 Enforces DPMF Account is not frozen                                                                 ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      COMPOSED                                                                                                                                    ;;
    ;;                                                                                                                                                  ;;
    ;;      DPMF-GAS_WIPE                           GAS Collection Variant of Capability                                                                ;;
    ;;==================CONTROL=====================                                                                                                    ;;
    ;;      DPMF_OWNERSHIP-CHANGE                   Capability required to EXECUTE <C_ChangeOwnership> Function                                         ;;
    ;;      DPMF_OWNERSHIP-CHANGE_CORE              Core Capability required for for changing DPMF Ownership                                            ;;
    ;;      DPMF_CONTROL                            Capability required to EXECUTE <C_Control> Function                                                 ;;
    ;;      DPMF_CONTROL_CORE                       Core Capability required for managing DPMF Properties                                               ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DPMF_TOGGLE_PAUSE                       Capability required to EXECUTE <C_TogglePause> Function                                             ;;
    ;;      DPMF_PAUSE                              Capability required to pause a DPMF account                                                         ;;
    ;;      DPMF_PAUSE_CORE                         Core Capability required to pause a DPMF account                                                    ;;
    ;;      DPMF_UNPAUSE                            Capability required to unpause a DPMF account                                                       ;;
    ;;      DPMF_UNPAUSE_CORE                       Core Capability required to unpause a DPMF account                                                  ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DPMF_TOGGLE_FREEZE-ACCOUNT              Capability required to EXECUTE <C_ToggleFreezeAccount> Function                                     ;;
    ;;      DPMF_FREEZE-ACCOUNT                     Capability required to freeze a DPMF account                                                        ;;
    ;;      DPMF_FREEZE-ACCOUNT_CORE                Core Capability required to freeze a DPMF account                                                   ;;
    ;;      DPMF_UNFREEZE-ACCOUNT                   Capability required to unfreeze a DPMF account                                                      ;;
    ;;      DPMF_UNFREEZE-ACCOUNT_CORE              Core Capability required to unfreeze a DPMF account                                                 ;;
    ;;==================TOKEN-ROLES=================                                                                                                    ;;
    ;;      DPMF_MOVE_CREATE-ROLE                   Capability required to EXECUTE <C_MoveCreateRole> Function                                          ;;
    ;;      DPMF_MOVE_CREATE-ROLE_CORE              Core Capability required to set <role-nft-create> for a DPMF Account of a DPMF Token                ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DPMF_TOGGLE_ADD-QUANTITY-ROLE           Capability required to EXECUTE <C_ToggleAddQuantityRole> Function                                   ;;
    ;;      DPMF_SET_ADD-QUANTITY-ROLE              Capability required to set <role-nft-add-quantity> to a DPTF account for a DPMF Token               ;;
    ;;      DPMF_SET_BURN-ROLE_CORE                 Core Capability required to set <role-nft-add-quantity> to a DPTF account for a DPMF Token          ;;
    ;;      DPMF_UNSET_ADD-QUANTITY-ROLE            Capability required to unset <role-nft-add-quantity> to a DPTF account for a DPMF Token             ;;
    ;;      DPMF_UNSET_ADD-QUANTITY-ROLE_CORE       Core Capability required to unset <role-nft-add-quantity> to a DPTF account for a DPMF Token        ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DPMF_TOGGLE_BURN-ROLE                   Capability required to EXECUTE <C_ToggleBurnRole> Function                                          ;;
    ;;      DPMF_SET_BURN-ROLE                      Capability required to set <role-nft-burn> to a DPMF account for a DPMF Token                       ;;
    ;;      DPMF_SET_BURN-ROLE_CORE                 Core Capability required to set <role-nft-burn> to a DPMF account for a DPMF Token                  ;;
    ;;      DPMF_UNSET_BURN-ROLE                    Capability required to unset <role-nft-burn> to a DPMF account for a DPMF Token                     ;;
    ;;      DPMF_UNSET_BURN-ROLE_CORE               Core Capability required to unset <role-nft-burn> to a DPMF account for a DPMF Token                ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DPMF_TOGGLE_TRANSFER-ROLE               Capability required to EXECUTE <C_ToggleTransferRole> Function                                      ;;
    ;;      DPMF_SET_TRANSFER-ROLE                  Capability required to set <role-transfer> to a DPMF account for a DPMF Token                       ;;
    ;;      DPMF_SET_TRANSFER-ROLE_CORE             Core Capability required to set <role-transfer> to a DPMF account for a DPMF Token                  ;;
    ;;      DPMF_UNSET_TRANSFER-ROLE                Capability required to unset <role-transfer> to a DPMF account for a DPMF Token                     ;;
    ;;      DPMF_UNSET_TRANSFER-ROLE_CORE           Core Capability required to unset <role-transfer> to a DPMF account for a DPMF Token                ;;
    ;;==================CREATE======================                                                                                                    ;;
    ;;      DPMF_ISSUE                              Capability required to EXECUTE a <C_IssueMetaFungible> Function                                     ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DPMF_MINT                               Capability required to EXECUTE <C|CX_Mint> Function                                                 ;;
    ;;      DPMF_MINT_CORE                          Core Capability required to mint a DPMF Token                                                       ;;
    ;;      DPMF_CREATE                             Capability required to EXECUTE <C|CX_Create> Function                                               ;;
    ;;      DPMF_CREATE_CORE                        Core Capability required to create a DPTF Token                                                     ;;
    ;;      DPMF_ADD-QUANTITY                       Capability required to EXECUTE <C|CX_AddQuantity> Function                                          ;;
    ;;      DPMF_ADD-QUANTITY_CORE                  Core Capability required to add quantity for a DPMF Token                                           ;;
    ;;==================DESTROY=====================                                                                                                    ;;
    ;;      DPMF_BURN                               Capability required to EXECUTE <C|CX_Burn> Function                                                 ;;
    ;;      DPMF_BURN_CORE                          Core Capability required to burn a DPMF Token                                                       ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DPMF_WIPE                               Capability required to EXECUTE <C_Wipe> Function                                                    ;;
    ;;      DPMF_WIPE_CORE                          Core Capability required to Wipe all DPMF Tokens (balance) from a DPMF account                      ;;
    ;;==================TRANSFER====================                                                                                                    ;;
    ;;      TRANSFER_DPMF                           Main DPMF Transfer Capability                                                                       ;;
    ;;      TRANSFER_DPMF_CORE                      Core Capability for transfer between 2 DPTS accounts for a specific DPMF Token identifier           ;;
    ;;=================CORE=========================                                                                                                    ;;
    ;;      CREDIT_DPMF                             Capability to perform crediting operations with DPMF Tokens                                         ;;
    ;;      DEBIT_DPMF                              Capability to perform debiting operations on Normal DPTS Account types with DPMF Tokens             ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
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
    (defcap DPMF_OWNER (identifier:string)
        @doc "Enforces DPMF Token Ownership"
        (UV_MetaFungibleIdentifier identifier)

        (let*
            (
                (owner-konto:string (UR_MetaFungibleKonto identifier))
                (dpts-guard:guard (OUROBOROS.UR_DPTS-AccountGuard owner-konto))
            )
            (enforce-guard dpts-guard)
        )
    )
    (defcap DPMF_CAN-CHANGE-OWNER_ON (identifier:string)
        @doc "Enforces DPMF Token ownership is changeble"
        (let
            (
                (x:bool (UR_MetaFungibleCanChangeOwner identifier))
            )
            (enforce (= x true) (format "DPMF Token {} ownership cannot be changed" [identifier]))
        )
    )
    (defcap DPMF_CAN-UPGRADE_ON (identifier:string)
        @doc "Enforces DPMF Token is upgradeable"
        (let
            (
                (x:bool (UR_MetaFungibleCanUpgrade identifier))
            )
            (enforce (= x true) (format "DPMF Token {} properties cannot be upgraded" [identifier])
            )
        )
    )
    (defcap DPMF_CAN-ADD-SPECIAL-ROLE_ON (identifier:string)
        @doc "Enforces adding special roles for DPMF Token is Meta"
        (let
            (
                (x:bool (UR_MetaFungibleCanAddSpecialRole identifier))
            )
            (enforce (= x true) (format "For DPMF Token {} no special roles can be added" [identifier])
            )
        )
    )
    (defcap DPMF_CAN-FREEZE_ON (identifier:string)
        @doc "Enforces DPMF Token can be frozen"
        (let
            (
                (x:bool (UR_MetaFungibleCanFreeze identifier))
            )
            (enforce (= x true) (format "DPMF Token {} cannot be freezed" [identifier])
            )
        )
    )
    (defcap DPMF_CAN-WIPE_ON (identifier:string)
        @doc "Enforces DPMF Token Property can be wiped"
        (let
            (
                (x:bool (UR_MetaFungibleCanWipe identifier))
            )
            (enforce (= x true) (format "DPMF Token {} cannot be wiped" [identifier])
            )
        )
    )
    (defcap DPMF_CAN-PAUSE_ON (identifier:string)
        @doc "Enforces DPMF Token can be paused"
        (let
            (
                (x:bool (UR_MetaFungibleCanPause identifier))
            )
            (enforce (= x true) (format "DPMF Token {} cannot be paused" [identifier])
            )
        )
    )
    (defcap DPMF_PAUSE_STATE (identifier:string state:bool)
        @doc "Enforces DPMF Token <is-paused> to <state>"
        (UV_MetaFungibleIdentifier identifier)
        (let
            (
                (x:bool (UR_MetaFungibleIsPaused identifier))
            )
            (if (= state true)
                (enforce (= x true) (format "DPMF Token {} is already unpaused" [identifier]))
                (enforce (= x false) (format "DPMF Token {} is already paused" [identifier]))
            )
        )
    )
    (defcap DPMF_CAN-TRANSFER-NFT-CREATE-ROLE_ON (identifier:string)
        @doc "Enforces DPMF Token Property as true"
        (let
            (
                (x:bool (UR_MetaFungibleCanTransferNFTCreateRole identifier))
            )
            (enforce (= x true) (format "DPMF Token {} cannot have its create role transfered" [identifier])
            )
        )
    )
    (defcap DPMF_UPDATE_SUPPLY ()
        @doc "Capability required to update DPMF Supply"
        true
    )
    (defcap DPMF_UPDATE_ROLE-TRANSFER-AMOUNT ()
        @doc "Capability required to update |role-transfer-amount| for Identifier <identifier>"
        true
    )
    (defcap DPMF_INCREASE_NONCE ()
        @doc "Capability required to update |nonce| in the DPMF-PropertiesTable"
        true
    )
    ;;======DPMF-BALANCES-TABLE-MANAGEMENT==========
    ;;
    ;;      DPMF_ACCOUNT_EXISTANCE|DPMF_ACCOUNT_OWNER
    ;;      DPMF_ACCOUNT_ADD-QUANTITY_ON|DPMF_ACCOUNT_ADD-QUANTITY_OFF
    ;;      DPMF_ACCOUNT_BURN_ON|DPMF_ACCOUNT_BURN_OFF
    ;;      DPMF_ACCOUNT_CREATE_ON|DPMF_ACCOUNT_CREATE_OFF
    ;;      DPMF_ACCOUNT_TRANSFER_ON|DPMF_ACCOUNT_TRANSFER_OFF
    ;;      DPMF_ACCOUNT_FREEZE_ON|DPMF_ACCOUNT_FREEZE_OFF
    ;;
    (defcap DPMF_ACCOUNT_EXISTANCE (identifier:string account:string existance:bool)
        @doc "Enforces <existance> Existance for the DPMF Token Account <identifier>|<account>"
        (let
            (
                (existance-check:bool (UR_AccountMetaFungibleExist identifier account))
            )
            (enforce (= existance-check existance) (format "{} Existance isnt verified for the DPMF Token Account <{}>|<{}}>") [existance identifier account])
        )
    )
    (defcap DPMF_ACCOUNT_OWNER (identifier:string account:string)
        @doc "Enforces DPMF Account Ownership"
        (UV_MetaFungibleIdentifier identifier)
        (compose-capability (OUROBOROS.DPTS_ACCOUNT_OWNER account))
    )
    (defcap DPMF_ACCOUNT_ADD-QUANTITY_STATE (identifier:string account:string state:bool)
        @doc "Enforces DPMF Account <role-nft-add-quantity> to <state>"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (let
            (
                (x:bool (UR_AccountMetaFungibleRoleNFTAQ identifier account))
            )
            (if (= state true)
                (enforce (= x true) (format "Account {} isnt allowed to add quantity for DPMF {} Token" [account identifier]))
                (enforce (= x false) (format "Account {} is allowed to add quantity for DPMF {} Token" [account identifier]))
            )
        )
    )
    (defcap DPMF_ACCOUNT_BURN_STATE (identifier:string account:string state:bool)
        @doc "Enforces DPMF Account <role-nft-burn> to <state>"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (let
            (
                (x:bool (UR_AccountMetaFungibleRoleBurn identifier account))
            )
            (if (= state true)
                (enforce (= x true) (format "Account {} isnt allowed to burn DPMF {} Token" [account identifier]))
                (enforce (= x false) (format "Account {} is allowed to burn DPMF {} Token" [account identifier]))
            )
        )
    )
    (defcap DPMF_ACCOUNT_CREATE_STATE (identifier:string account:string state:bool)
        @doc "Enforces DPMF Account <role-nft-create> to <state>"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (let
            (
                (x:bool (UR_AccountMetaFungibleRoleCreate identifier account))
            )
            (if (= state true)
                (enforce (= x true) (format "Account {} isnt allowed to create DPMF {} Token" [account identifier]))
                (enforce (= x false) (format "Account {} is allowed to create DPMF {} Token" [account identifier]))
            )
        )
    )
    (defcap DPMF_ACCOUNT_TRANSFER_STATE (identifier:string account:string state:bool)
        @doc "Enforces DPMF Account <role-transfer> to <state>"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (let
            (
                (x:bool (UR_AccountMetaFungibleRoleTransfer identifier account))
            )
            (if (= state true)
                (enforce (= x true) (format "Account {} doesnt have a valid transfer role for DPMF {} Token" [account identifier]))
                (enforce (= x false) (format "Account {} has a valid transfer role for DPMF {} Token" [account identifier]))
            )
        )
    )
    (defcap DPMF_ACCOUNT_FREEZE_STATE (identifier:string account:string state:bool)
        @doc "Enforces DPTF Account <frozen> to <state>"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (let
            (
                (x:bool (UR_AccountMetaFungibleFrozenState identifier account))
            )
            (if (= state true)
                (enforce (= x true) (format "Account {} isnt frozen for DPMF {} Token" [account identifier]))
                (enforce (= x false) (format "Account {} is frozen for DPMF {} Token" [account identifier]))
            )
        )
    )
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
    (defcap DPMF_OWNERSHIP-CHANGE (patron:string identifier:string new-owner:string)
        @doc "Capability required to change the ownership of a DPMF Token"
        (let
            (
                (current-owner-account:string (UR_MetaFungibleKonto identifier))
            )
            (compose-capability (DPMF_OWNERSHIP-CHANGE_CORE identifier new-owner))
            (compose-capability (OUROBOROS.GAS_COLLECTION patron current-owner-account OUROBOROS.GAS_BIGGEST))
            (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
        )
    )
    (defcap DPMF_OWNERSHIP-CHANGE_CORE (identifier:string new-owner:string)
        @doc "Core Capability required to change the ownership of a DPMF Token"
        (UV_MetaFungibleIdentifier identifier)
        (let
            (
                (current-owner-account:string (UR_MetaFungibleKonto identifier))
            )
            (OUROBOROS.UV_SenderWithReceiver current-owner-account new-owner)
            (compose-capability (DPMF_OWNER identifier))
            (compose-capability (DPMF_CAN-CHANGE-OWNER_ON identifier))
        )
    )

    (defcap DPMF_CONTROL (patron:string identifier:string)
        @doc "Capability required to control a DPMF Token"
        (let
            (
                (current-owner-account:string (UR_MetaFungibleKonto identifier))
            )
            (compose-capability (DPMF_CONTROL_CORE identifier))
            (compose-capability (OUROBOROS.GAS_COLLECTION patron current-owner-account OUROBOROS.GAS_SMALL))
            (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE)) 
        )
    )
    (defcap DPMF_CONTROL_CORE (identifier:string)
        @doc "Core Capability required to control a DPMF Token"
        (UV_MetaFungibleIdentifier identifier)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-UPGRADE_ON identifier))    
    )

    (defcap DPMF_TOGGLE_PAUSE (patron:string identifier:string pause:bool)
        (compose-capability (DPMF_TOGGLE_PAUSE_CORE identifier pause))
        (compose-capability (OUROBOROS.GAS_COLLECTION patron patron OUROBOROS.GAS_MEDIUM))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE)) 
        )

    (defcap DPMF_TOGGLE_PAUSE_CORE (identifier:string pause:bool)
        (compose-capability (DPMF_OWNER identifier))
        (if (= pause true)
            (compose-capability (DPMF_CAN-PAUSE_ON identifier))
            true
        )
        (compose-capability (DPMF_PAUSE_STATE identifier (not pause)))
    )

    (defcap DPMF_FROZEN-ACCOUNT (patron:string identifier:string account:string frozen:bool)
        (compose-capability (DPMF_FROZEN-ACCOUNT_CORE identifier account frozen))
        (compose-capability (OUROBOROS.GAS_COLLECTION patron account OUROBOROS.GAS_BIG))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_FROZEN-ACCOUNT_CORE (identifier:string account:string frozen:bool)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-FREEZE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_FREEZE_STATE identifier account (not frozen)))
    )

    ;;==================TOKEN-ROLES=================
    ;;
    ;;      DPMF_MOVE_CREATE-ROLE|DPMF_MOVE_CREATE-ROLE_CORE
    ;;      DPMF_TOGGLE_ADD-QUANTITY-ROLE|DPMF_TOGGLE_ADD-QUANTITY-ROLE_CORE
    ;;      DPMF_TOGGLE_BURN-ROLE|DPMF_TOGGLE_BURN-ROLE_CORE
    ;;      DPMF_TOGGLE_TRANSFER-ROLE|DPMF_TOGGLE_TRANSFER-ROLE_CORE
    ;;
    (defcap DPMF_MOVE_CREATE-ROLE (patron:string identifier:string receiver:string)
        @doc "Capability required to move the <role-nft-create> Role"
        (let
            (
                (current-owner-account:string (UR_MetaFungibleKonto identifier))
            )
            (compose-capability (DPMF_MOVE_CREATE-ROLE_CORE identifier receiver))
            (compose-capability (OUROBOROS.GAS_COLLECTION patron current-owner-account OUROBOROS.GAS_BIGGEST))
            (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
        ) 
    )
    (defcap DPMF_MOVE_CREATE-ROLE_CORE (identifier:string receiver:string)
        @doc "Core Capability required to move the <role-nft-create> Role"
        (UV_MetaFungibleIdentifier identifier)
        (let
            (
                (current-owner-account:string (UR_MetaFungibleKonto identifier))
            )
            (OUROBOROS.UV_SenderWithReceiver current-owner-account receiver)
            (compose-capability (DPMF_OWNER identifier))
            (compose-capability (DPMF_CAN-TRANSFER-NFT-CREATE-ROLE_ON identifier))
            (compose-capability (DPMF_ACCOUNT_CREATE_STATE identifier current-owner-account true))
            (compose-capability (DPMF_ACCOUNT_CREATE_STATE identifier receiver false))
        )
    )

    (defcap DPMF_TOGGLE_ADD-QUANTITY-ROLE (patron:string identifier:string account:string toggle:bool)
        @doc "Capability required to toggle the <role-nft-add-quantity> Role"
        (compose-capability (DPMF_TOGGLE_ADD-QUANTITY-ROLE_CORE identifier account toggle))    
        (compose-capability (OUROBOROS.GAS_COLLECTION patron account OUROBOROS.GAS_SMALL))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_TOGGLE_ADD-QUANTITY-ROLE_CORE (identifier:string account:string toggle:bool)
        @doc "Core Capability required to toggle the <role-nft-add-quantity> Role"
        (compose-capability (DPMF_OWNER identifier))
        (if (= toggle true)
            (compose-capability (DPMF_CAN-ADD-SPECIAL-ROLE_ON identifier))
            true
        )
        (compose-capability (DPMF_ACCOUNT_ADD-QUANTITY_STATE identifier account (not toggle)))
    )

    (defcap DPMF_TOGGLE_BURN-ROLE (patron:string identifier:string account:string toggle:bool)
        @doc "Capability required to toggle the <role-nft-burn> Role"
        (compose-capability (DPMF_TOGGLE_BURN-ROLE_CORE identifier account toggle))    
        (compose-capability (OUROBOROS.GAS_COLLECTION patron account OUROBOROS.GAS_SMALL))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_TOGGLE_BURN-ROLE_CORE (identifier:string account:string toggle:bool)
        @doc "Core Capability required to toggle the <role-nft-burn> Role"
        (compose-capability (DPMF_OWNER identifier))
        (if (= toggle true)
            (compose-capability (DPMF_CAN-ADD-SPECIAL-ROLE_ON identifier))
            true
        )
        (compose-capability (DPMF_ACCOUNT_BURN_STATE identifier account (not toggle)))
    )

    (defcap DPMF_TOGGLE_TRANSFER-ROLE (patron:string identifier:string account:string toggle:bool)
        @doc "Capability required to toggle the <role-transfer> Role"
        (compose-capability (DPMF_TOGGLE_TRANSFER-ROLE_CORE identifier account toggle))
        (compose-capability (OUROBOROS.GAS_COLLECTION patron account OUROBOROS.GAS_SMALL))
        (compose-capability (DPMF_UPDATE_ROLE-TRANSFER-AMOUNT))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_TOGGLE_TRANSFER-ROLE_CORE (identifier:string account:string toggle:bool)
        @doc "Core Capability required to toggle the <role-transfer> Role"
        (enforce (!= account OUROBOROS.SC_NAME) (format "Capability excludes {} Account from having or removing transfer roles" [OUROBOROS.SC_NAME]))
        (enforce (!= account OUROBOROS.SC_NAME_GAS) (format "Capability excludes {} Account from having or removing transfer roles" [OUROBOROS.SC_NAME_GAS]))
        (compose-capability (DPMF_OWNER identifier))
        (if (= toggle true)
            (compose-capability (DPMF_CAN-ADD-SPECIAL-ROLE_ON identifier))
            true
        )
        (compose-capability (DPMF_ACCOUNT_TRANSFER_STATE identifier account (not toggle)))
    )
    ;;==================CREATE=======================
    ;;
    ;;      DPMF_MINT|DPMF_MINT_CORE|
    ;;      DPMF_CREATE|DPMF_CREATE_CORE
    ;;      DPMF_ADD-QUANTITY|DPMF_ADD-QUANTITY_CORE
    ;;
    (defcap DPMF_ISSUE (patron:string client:string)
        @doc "Capability required to issue a DPMF Token"
        (compose-capability (OUROBOROS.DPTF_ISSUE patron client))
    )
    (defcap DPMF_MINT (patron:string identifier:string client:string amount:decimal method:bool)
        @doc "Capability required to mint a DPMF Token"
        (compose-capability (OUROBOROS.DPTS_METHODIC client method))
        (compose-capability (OUROBOROS.GAS_PATRON patron identifier client OUROBOROS.GAS_SMALL))
        (compose-capability (DPMF_MINT_CORE identifier client amount))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_MINT_CORE (identifier:string client:string amount:decimal)
        @doc "Core Capability required to mint a DPMF Token"
        (UV_MetaFungibleAmount identifier amount)
        (OUROBOROS.UV_DPTS-Account client)
        (compose-capability (DPMF_CREATE_CORE identifier client))
        (compose-capability (DPMF_ADD-QUANTITY_CORE identifier client amount))
    )

    (defcap DPMF_CREATE (patron:string identifier:string client:string method:bool)
        @doc "Capability that allows creation of a new MetaFungilbe nonce"
        (compose-capability (OUROBOROS.DPTS_METHODIC client method))
        (compose-capability (OUROBOROS.GAS_PATRON patron identifier client OUROBOROS.GAS_SMALL))
        (compose-capability (DPMF_CREATE_CORE identifier client))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_CREATE_CORE (identifier:string client:string)
        @doc "Core Capability that allows creation of a new MetaFungilbe nonce"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account client)
        (compose-capability (DPMF_ACCOUNT_CREATE_STATE identifier client true))
        (compose-capability (DPMF_INCREASE_NONCE))
    )

    (defcap DPMF_ADD-QUANTITY (patron:string identifier:string client:string amount:decimal method:bool)
        @doc "Capability required to add-quantity for a DPMF Token"
        (UV_MetaFungibleAmount identifier amount)
        (OUROBOROS.UV_DPTS-Account client)
        (compose-capability (OUROBOROS.DPTS_METHODIC client method))
        (compose-capability (OUROBOROS.GAS_PATRON patron identifier client OUROBOROS.GAS_SMALL))
        (compose-capability (DPMF_ADD-QUANTITY_CORE identifier client))
        (compose-capability (DPMF_UPDATE_SUPPLY))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_ADD-QUANTITY_CORE (identifier:string client:string amount:decimal)
        @doc "Core Capability required to add-quantity for a DPMF Token"
        (UV_MetaFungibleAmount identifier amount)
        (OUROBOROS.UV_DPTS-Account client)
        (compose-capability (DPMF_ACCOUNT_ADD-QUANTITY_STATE identifier client true))
        (compose-capability (CREDIT_DPMF identifier client))
        (compose-capability (DPMF_UPDATE_SUPPLY))
    )
    ;;==================DESTROY======================
    ;;
    ;;      DPMF_BURN|DPMF_BURN_CORE
    ;;      DPMF_WIPE|DPMF_WIPE_CORE
    ;;
    (defcap DPMF_BURN (patron:string identifier:string client:string amount:decimal method:bool)
        @doc "Capability required to burn a DPMF Token"
        (compose-capability (OUROBOROS.DPTS_METHODIC client method))
        (compose-capability (OUROBOROS.GAS_PATRON patron identifier client OUROBOROS.GAS_SMALL))
        (compose-capability (DPMF_BURN_CORE identifier client amount))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_BURN_CORE (identifier:string client:string amount:decimal)
        @doc "Core Capability required to burn a DPMF Token"
        (UV_MetaFungibleAmount identifier amount)
        (compose-capability (DPMF_ACCOUNT_BURN_STATE identifier client true))
        (compose-capability (DEBIT_DPMF identifier client))
        (compose-capability (DPMF_UPDATE_SUPPLY))
    )
    (defcap DPMF_WIPE (patron:string identifier:string account-to-be-wiped:string)
        @doc "Core Capability required to Wipe a DPMF Token Balance from a DPMF account"
        (compose-capability (OUROBOROS.GAS_PATRON patron identifier account-to-be-wiped OUROBOROS.GAS_BIGGEST))
        (compose-capability (DPMF_WIPE_CORE identifier account-to-be-wiped))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_WIPE_CORE (identifier:string account-to-be-wiped:string)
        @doc "Core Capability required to Wipe a DPMF Token Balance from a DPMF account"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account-to-be-wiped)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-WIPE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_FREEZE_STATE identifier account-to-be-wiped true))
        (compose-capability (DPMF_UPDATE_SUPPLY))
    )
    ;;==================TRANSFER==================== 
    ;;
    ;;      TRANSFER_DPMF|TRANSFER_DPMF_CORE|
    ;;
    (defcap TRANSFER_DPMF (patron:string identifier:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Main DPMF Transfer Capability"

        (if (= method false)
            (compose-capability (OUROBOROS.DPTS_ACCOUNT_OWNER sender))
            (enforce-one
                (format "No permission available to transfer from Account {}" [sender])
                [
                    (compose-capability (OUROBOROS.DPTS_METHODIC sender method))
                    (compose-capability (OUROBOROS.DPTS_METHODIC receiver method))
                ]
            )
        )
        (compose-capability (OUROBOROS.GAS_PATRON patron identifier sender OUROBOROS.GAS_SMALLEST))
        (compose-capability (TRANSFER_DPMF_CORE identifier sender receiver transfer-amount))
        (compose-capability (OUROBOROS.SC_TRANSFERABILITY sender receiver method))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap TRANSFER_DPMF_CORE (identifier:string sender:string receiver:string transfer-amount:decimal)
        @doc "Core Capability for transfer between 2 DPTS accounts for a specific DPMF Token identifier"

        (UV_MetaFungibleAmount identifier transfer-amount)
        (OUROBOROS.UV_SenderWithReceiver sender receiver)
        (let
            (
                (transfer-role-amount:integer (UR_MetaFungibleTransferRoleAmount identifier))
            )

            ;;Checks pause and freeze statuses
            (compose-capability (DPMF_PAUSE_STATE identifier false))
            (compose-capability (DPMF_ACCOUNT_FREEZE_STATE identifier sender false))
            (compose-capability (DPMF_ACCOUNT_FREEZE_STATE identifier receiver false))

            (if (and (> transfer-role-amount 0) (not (or (= sender OUROBOROS.SC_NAME)(= sender OUROBOROS.SC_NAME_GAS))))
                ;;if true
                (enforce-one
                    (format "Neither the sender {} nor the receiver {} have an active transfer role" [sender receiver])
                    [
                        (compose-capability (DPMF_ACCOUNT_TRANSFER_STATE identifier sender true))
                        (compose-capability (DPMF_ACCOUNT_TRANSFER_STATE identifier receiver true))
                    ]
                )
                ;;if false
                (format "No transfer Role restrictions exist for Token {}" [identifier])
            )

            ;;Add Debit and Credit capabilities
            (compose-capability (DEBIT_DPMF identifier sender))  
            (compose-capability (CREDIT_DPMF identifier receiver))
        )
    )
    ;;=================CORE==========================
    ;;
    ;;      CREDIT_DPMF|DEBIT_DPMF
    ;;
    (defcap CREDIT_DPMF (identifier:string account:string)
        @doc "Capability to perform crediting operations with DPMF Tokens"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (compose-capability (OUROBOROS.DPTS_ACCOUNT_EXIST account))
    )
    (defcap DEBIT_DPMF (identifier:string account:string)
        @doc "Capability to perform debiting operations on a Normal DPTS Account type for a DPMF Token"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)                
    )
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      PRIMARY Functions                       Stand-Alone Functions                                                                               ;;
    ;;                                                                                                                                                  ;;
    ;;      0)UTILITY                               Free Functions: can can be called by anyone. (Compute|Print|Read|Validate Functions)                ;;
    ;;                                                  No Key|Guard required.                                                                          ;;
    ;;      1)ADMINISTRATOR                         Administrator Functions: can only be called by module administrator.                                ;;
    ;;                                                  DPTF_ADMIN Capability Required.                                                                 ;;
    ;;      2)CLIENT                                Client Functions: can be called by any DPMF Account.                                                ;;
    ;;                                                  DPTF_CLIENT Capability Required.                                                                ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      SECONDARY Functions                     Auxiliary Functions: cannot be called on their own                                                  ;;
    ;;                                                                                                                                                  ;;
    ;;      3)AUXILIARY                             Are Part of Client Function                                                                         ;;
    ;;                                                  Capabilities are required to use auxiliary Functions                                            ;;
    ;;                                                                                                                                                  ;;      
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      Functions Names are prefixed, so that they may be better visualised and understood.                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;      UTILITY-COMPUTE                         UC_FunctionName                                                                                     ;;
    ;;      UTILITY-PRINT                           UP_FunctionName                                                                                     ;;
    ;;      UTILITY-READ                            UR_FunctionName                                                                                     ;;
    ;;      UTILITY-VALIDATE                        UV_FunctionName                                                                                     ;;
    ;;      ADMINISTRATION                          A_FunctionName                                                                                      ;;
    ;;      CLIENT                                  C_FunctionName                                                                                      ;;
    ;;      AUXILIARY                               X_FunctionName                                                                                      ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      UTILITY FUNCTIONS                                                                                                                           ;;
    ;;                                                                                                                                                  ;;
    ;;==================ACCOUNT-INFO================                                                                                                    ;;
    ;;      UR_AccountMetaFungibles                 Returns a List of Metafungible Identifiers held by DPMF Accounts <account>                          ;;
    ;;      UR_AccountMetaFungibleSupply            Returns Account <account> Meta Fungible <identifier> Supply (all nonces)                            ;;
    ;;      UR_AccountMetaFungibleUnit              Returns Account <account> Meta Fungible <identifier> Unit                                           ;;
    ;;      UR_AccountMetaFungibleRoleNFTAQ         Returns Account <account> Meta Fungible <identifier> NFT Add Quantity Role                          ;;
    ;;      UR_AccountMetaFungibleRoleBurn          Returns Account <account> Meta Fungible <identifier> Burn Role                                      ;;
    ;;      UR_AccountMetaFungibleRoleCreate        Returns Account <account> Meta Fungible <identifier> Create Role                                    ;;
    ;;      UR_AccountMetaFungibleRoleTransfer      Returns Account <account> Meta Fungible <identifier> Transfer Role                                  ;;
    ;;      UR_AccountMetaFungibleFrozenState       Returns Account <account> Meta Fungible <identifier> Frozen State                                   ;;
    ;;==================ACCOUNT-NONCE===============                                                                                                    ;;
    ;;      UR_AccountMetaFungibleBalances          Returns a list of Balances that exist for MetaFungible <identifier> held by DPMF Account <account>  ;;
    ;;      UR_AccountMetaFungibleNonces            Returns a list of Nonces that exist for MetaFungible <identifier> held by DPMF Account <account>    ;;
    ;;      UR_AccountMetaFungibleBalance           Returns the balance of a MetaFungible (<identifier> and <nonce>) held by DPMF Account <account>     ;;
    ;;      UR_AccountMetaFungibleMetaData          Returns the meta-data of a MetaFungible (<identifier> and <nonce>) held by DPMF Account <account>   ;;
    ;;==================META-FUNGIBLE-INFO==========                                                                                                    ;;
    ;;      UR_MetaFungibleOwner                    Returns Meta Fungible <identifier> Owner                                                            ;;
    ;;      UR_MetaFungibleKonto                    Returns Meta Fungible <identifier> Account                                                          ;;
    ;;      UR_MetaFungibleName                     Returns Meta Fungible <identifier> Name                                                             ;;
    ;;      UR_MetaFungibleTicker                   Returns Meta Fungible <identifier> Ticker                                                           ;;
    ;;      UR_MetaFungibleDecimals                 Returns Meta Fungible <identifier> Decimals                                                         ;;
    ;;      UR_MetaFungibleCanChangeOwner           Returns Meta Fungible <identifier> Boolean can-change-owner                                         ;;
    ;;      UR_MetaFungibleCanUpgrade               Returns Meta Fungible <identifier> Boolean can-upgrade                                              ;;
    ;;      UR_MetaFungibleCanAddSpecialRole        Returns Meta Fungible <identifier> Boolean can-add-special-role                                     ;;
    ;;      UR_MetaFungibleCanFreeze                Returns Meta Fungible <identifier> Boolean can-freeze                                               ;;
    ;;      UR_MetaFungibleCanWipe                  Returns Meta Fungible <identifier> Boolean can-wipe                                                 ;;
    ;;      UR_MetaFungibleCanPause                 Returns Meta Fungible <identifier> Boolean can-pause                                                ;;
    ;;      UR_MetaFungibleIsPaused                 Returns Meta Fungible <identifier> Boolean is-paused                                                ;;
    ;;      UR_MetaFungibleCanTransferNFTCreateRole Returns Meta Fungible <identifier> Boolean can-transfer-nft-create-role                             ;;
    ;;      UR_MetaFungibleSupply                   Returns Meta Fungible <identifier> Total Supply                                                     ;;
    ;;      UR_MetaFungibleCreateRoleAccount        Returns Meta Fungible <identifier> Create Role Account                                              ;;
    ;;      UR_MetaFungibleTransferRoleAmount       Returns Meta Fungible <identifier> Transfer Role Amount                                             ;;
    ;;      UR_MetaFungibleNoncesUsed               Returns Meta Fungible <identifier> Used Nonces                                                      ;;
    ;;==================VALIDATIONS=================                                                                                                    ;;
    ;;      UV_MetaFungibleAmount                   Enforces the Amount <amount> is positive its decimal size conform for MetaFungible <identifier>     ;;
    ;;      UV_MetaFungibleIdentifier               Enforces the MetaFungible <identifier> exists                                                       ;;
    ;;==================Composition=================                                                                                                    ;;
    ;;      UC_ComposeMetaFungible                  Composes a MetaFungible object from <nonce>, <balance> and <meta-data>                              ;;
    ;;      UC_Nonce-Balance_Pair                   Composes a NonceBalance object from a <nonce-lst> list and <balance-lst> list                       ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      ADMINISTRATION FUNCTIONS                                                                                                                    ;;
    ;;                                                                                                                                                  ;;
    ;;      NO ADMINISTRATOR FUNCTIONS                                                                                                                  ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      CLIENT FUNCTIONS                                                                                                                            ;;
    ;;                                                                                                                                                  ;;
    ;;==================CONTROL=====================                                                                                                    ;;
    ;;5     C_ChangeOwnership                       Moves DPMF <identifier> Token Ownership to <new-owner> DPMF Account                                 ;;
    ;;2     C_Control                               Controls MetaFungible <identifier> Properties using 7 boolean control triggers                      ;;
    ;;3     C_TogglePause                           Pause/Unpause MetaFungible <identifier> via the boolean <toggle>                                    ;;
    ;;4     C_ToggleFreezeAccount                   Freeze/Unfreeze via boolean <toggle> MetaFungile <identifier> on DPMF Account <account>             ;;
    ;;==================ROLES=======================                                                                                                    ;;
    ;;5     C_MoveCreateRole                        Moves |role-nft-create| from <sender> to <receiver> DPMF Account for MetaFungible <identifier>      ;;
    ;;2     C_ToggleAddQuantityRole                 Sets |role-nft-add-quantity| to <toggle> boolean for MF <identifier> and DPMF Account <account>     ;;
    ;;2     C_ToggleBurnRole                        Sets |role-nft-burn| to <toggle> boolean for MetaFungible <identifier> and DPMF Account <account>   ;;
    ;;2     C_ToggleTransferRole                    Sets |role-transfer| to <toggle> boolean for MetaFungible <identifier> and DPMF Account <account>   ;;
    ;;==================CREATE======================                                                                                                    ;;
    ;;15    C_IssueMetaFungible                     Issues a new MetaFungible                                                                           ;;
    ;;      C_DeployMetaFungibleAccount             Creates a new DPMF Account for MetaFungible <identifier> and Account <account>                      ;;
    ;;3     C_Mint                                  Mints <amount> <identifier> MetaFungibles with <meta-data> meta-data for DPMF Account <account>     ;;
    ;;3     CX_Mint                                 Methodic, similar to |C_Mint| for Smart-DPTS Account type operation                                 ;;
    ;;2     C_Create                                Creates a 0 balance <identifier> MetaFungible with <meta-data> meta-data for DPMF Account <account> ;;
    ;;2     CX_Create                               Methodic, similar to |C_Create| for Smart-DPTS Account type operation                               ;;
    ;;2     C_AddQuantity                           Adds <amount> quantity to existing MetaFungible <identifer> and <nonce> for DPMF Account <account>  ;;
    ;;2     CX_AddQuantity                          Methodic, similar to |C_AddQuantity| for Smart-DPTS Account type operation                          ;;
    ;;==================DESTROY=====================                                                                                                    ;;
    ;;2     C_Burn                                  Burns <amount> <identifier>-<nonce> MetaFungible on DPMF Account <account>                          ;;
    ;;2     CX_Burn                                 Methodic, similar to |C_Burn| for Smart-DPTS Account type operation                                 ;;
    ;;5     C_Wipe                                  Wipes the whole supply of <identifier> MetaFungible of a frozen DPMF Account <account>              ;;
    ;;==================TRANSFER====================                                                                                                    ;;
    ;;1     C_TransferMetaFungible                  Transfers <identifier>-<nonce> MetaFungible from <sender> to <receiver> DPMF Account                ;;
    ;;1     CX_TransferMetaFungible                 Methodic, similar to |C_TransferMetaFungible| for Smart-DPTS Account type operation                 ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      AUXILIARY FUNCTIONS                                                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================TRANSFER====================                                                                                                    ;;
    ;;      X_TransferMetaFungible                  Transfers <identifier>|<nonce> MetaFungible from <sender> to <receiver> DPMF Account without GAS    ;;
    ;;==================CREDIT|DEBIT================                                                                                                    ;;
    ;;      X_Credit                                Auxiliary Function that credits a MetaFungible to a DPMF Account                                    ;;
    ;;      X_Debit                                 Auxiliary Function that debits a MetaFungible from a DPMF Account                                   ;;
    ;;      X_DebitMultiple                         Auxiliary Function needed for Wiping                                                                ;;
    ;;      X_DebitPaired                           Auxiliary Helper Function designed for making |X_DebitMultiple| possible, which is needed for Wiping;;
    ;;==================UPDATE======================                                                                                                    ;;
    ;;      X_UpdateSupply                          Updates <identifier> MetaFungible supply. Boolean <direction> used for increase|decrease            ;;
    ;;      X_IncrementNonce                        Increments <identifier> MetaFungible nonce.                                                         ;;
    ;;      X_UpdateRoleTransferAmount              Updates <role-transfer-amount> for Token <identifier>                                               ;;
    ;;==================AUXILIARY===================                                                                                                    ;;
    ;;      X_ChangeOwnership                       Auxiliary function required in the main function                                                    ;;
    ;;      X_Control                               Auxiliary function required in the main function                                                    ;;
    ;;      X_TogglePause                           Auxiliary function required in the main function                                                    ;;
    ;;      X_ToggleFreezeAccount                   Auxiliary function required in the main function                                                    ;;
    ;;      X_MoveCreateRole                        Auxiliary function required in the main function                                                    ;;
    ;;      X_ToggleAddQuantityRole                 Auxiliary function required in the main function                                                    ;;
    ;;      X_ToggleBurnRole                        Auxiliary function required in the main function                                                    ;;
    ;;      X_ToggleTransferRole                    Auxiliary function required in the main function                                                    ;;
    ;;      X_IssueMetaFungible                     Auxiliary function required in the main function                                                    ;;
    ;;      X_Mint                                  Auxiliary function required in the main function                                                    ;;
    ;;      X_Create                                Auxiliary function required in the main function                                                    ;;
    ;;      X_AddQuantity                           Auxiliary function required in the main function                                                    ;;
    ;;      X_Burn                                  Auxiliary function required in the main function                                                    ;;
    ;;      X_Wipe                                  Auxiliary function required in the main function                                                    ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
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
    (defun UR_AccountMetaFungibleExist:bool (identifier:string account:string)
        @doc "Checks if DPMF Account <account> exists for DPMF Token id <identifier>"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)

        (with-default-read DPMF-BalancesTable (concat [identifier BAR account])
            { "unit" : [NEGATIVE_META-FUNGIBLE] }
            { "unit" := u}
            (if (= u [NEGATIVE_META-FUNGIBLE])
                false
                true
            )
        )
    )      
    (defun UR_AccountMetaFungibles:[string] (account:string)
        @doc "Returns a List of Metafungible Identifiers held by DPMF Accounts <account>"
        (OUROBOROS.UV_DPTS-Account account)

        (let*
            (
                (keyz:[string] (keys DPMF-BalancesTable))
                (listoflists:[[string]] (map (lambda (x:string) (OUROBOROS.UC_SplitString OUROBOROS.BAR x)) keyz))
                (dpmf-account-tokens:[string] (OUROBOROS.UC_FilterIdentifier listoflists account))
            )
            dpmf-account-tokens
        )
    )
    (defun UR_AccountMetaFungibleSupply:decimal (identifier:string account:string)
        @doc "Returns total Supply for MetaFungible <identifier> (all nonces) held by DPMF Account <account>"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)

        (with-default-read DPMF-BalancesTable (concat [identifier BAR  account])
            { "unit" : [NEUTRAL_META-FUNGIBLE] }
            { "unit" := read-unit}
            (let 
                (
                    (result 
                        (fold
                            (lambda 
                                (acc:decimal item:object{MetaFungible_Schema})
                                (+ acc (at "balance" item))
                            )
                            0.0
                            read-unit
                        )
                    )
                )
                result
            )
        )
    )
    (defcap UR_AccountMetaFungibleUnit:[object] (identifier:string account:string)
        @doc "Returns Account <account> Meta Fungible <identifier> Unit"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (at "unit" (read DPMF-BalancesTable (concat [identifier BAR account]) ["unit"]))
    )
    (defun UR_AccountMetaFungibleRoleNFTAQ:bool (identifier:string account:string)
        @doc "Returns Account <account> Meta Fungible <identifier> NFT Add Quantity Role"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (at "role-nft-add-quantity" (read DPMF-BalancesTable (concat [identifier BAR account]) ["role-nft-add-quantity"]))
    )
    (defun UR_AccountMetaFungibleRoleBurn:bool (identifier:string account:string)
        @doc "Returns Account <account> Meta Fungible <identifier> Burn Role"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (at "role-nft-burn" (read DPMF-BalancesTable (concat [identifier BAR account]) ["role-nft-burn"]))
    )
    (defun UR_AccountMetaFungibleRoleCreate:bool (identifier:string account:string)
        @doc "Returns Account <account> Meta Fungible <identifier> Create Role"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (at "role-nft-create" (read DPMF-BalancesTable (concat [identifier BAR account]) ["role-nft-create"]))
    )
    (defun UR_AccountMetaFungibleRoleTransfer:bool (identifier:string account:string)
        @doc "Returns Account <account> Meta Fungible <identifier> Transfer Role\
            \ with-default-read assumes the role is always false for not existing accounts \
            \ Needed for Transfer Anew functions"

        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (with-default-read DPMF-BalancesTable (concat [identifier BAR account])
            { "role-transfer" : false }
            { "role-transfer" := rt }
            rt
        )
    )
    (defun UR_AccountMetaFungibleFrozenState:bool (identifier:string account:string)
        @doc "Returns Account <account> Meta Fungible <identifier> Frozen State\
            \ with-default-read assumes the role is always false for not existing accounts \
            \ Needed for Transfer Anew functions"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (with-default-read DPMF-BalancesTable (concat [identifier BAR account])
            { "frozen" : false}
            { "frozen" := fr }
            fr
        )
    )
    ;;
    ;;==================ACCOUNT-NONCE===============
    ;;
    ;;      UR_AccountMetaFungibleBalances|UR_AccountMetaFungibleNonces
    ;;      UR_AccountMetaFungibleBalance|UR_AccountMetaFungibleMetaData
    ;;
    (defun UR_AccountMetaFungibleBalances:[decimal] (identifier:string account:string)
        @doc "Returns a list of Balances that exist for MetaFungible <identifier> on DPMF Account <account>\
        \ Needed for Mass Debiting"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)

        (with-default-read DPMF-BalancesTable (concat [identifier BAR  account])
            { "unit" : [NEUTRAL_META-FUNGIBLE] }
            { "unit" := read-unit}
            (let 
                (
                    (result 
                        (fold
                            (lambda 
                                (acc:[decimal] item:object{MetaFungible_Schema})
                                (if (!= (at "balance" item) 0.0)
                                        (OUROBOROS.UC_AppendLast acc (at "balance" item))
                                        acc
                                )
                            )
                            []
                            read-unit
                        )
                    )
                )
                result
            )
        )
    )
    (defun UR_AccountMetaFungibleNonces:[integer] (identifier:string account:string)
        @doc "Returns a list of Nonces that exist for MetaFungible <identifier> held by DPMF Account <account>"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)

        (with-default-read DPMF-BalancesTable (concat [identifier BAR  account])
            { "unit" : [NEUTRAL_META-FUNGIBLE] }
            { "unit" := read-unit}
            (let 
                (
                    (result 
                        (fold
                            (lambda 
                                (acc:[integer] item:object{MetaFungible_Schema})
                                (if (!= (at "nonce" item) 0)
                                        (OUROBOROS.UC_AppendLast acc (at "nonce" item))
                                        acc
                                )
                            )
                            []
                            read-unit
                        )
                    )
                )
                result
            )
        )
    )
    (defun UR_AccountMetaFungibleBalance:decimal (identifier:string nonce:integer account:string)
        @doc " Returns the balance of a MetaFungible (<identifier> and <nonce>) held by DPMF Account <account>"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)

        (with-default-read DPMF-BalancesTable (concat [identifier BAR  account])
            { "unit" : [NEUTRAL_META-FUNGIBLE] }
            { "unit" := read-unit}
            (let 
                (
                    (result-balance:decimal
                        (fold
                            (lambda 
                                (acc:decimal item:object{MetaFungible_Schema})
                                (let
                                    (
                                        (nonce-val:integer (at "nonce" item))
                                        (balance-val:decimal (at "balance" item))
                                    )
                                    (if (= nonce-val nonce)
                                        balance-val
                                        acc
                                    )
                                )
                            )
                            0.0
                            read-unit
                        )
                    )
                )
                result-balance
            )
        )
    )
    (defun UR_AccountMetaFungibleMetaData (identifier:string nonce:integer account:string)
        @doc "Returns the meta-data of a MetaFungible (<identifier> and <nonce>) held by DPMF Account <account>"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)

        (with-default-read DPMF-BalancesTable (concat [identifier BAR  account])
            { "unit" : [NEUTRAL_META-FUNGIBLE] }
            { "unit" := read-unit}
            (let 
                (
                    (result-meta-data
                        (fold
                            (lambda 
                                (acc item:object{MetaFungible_Schema})
                                (let
                                    (
                                        (nonce-val:integer (at "nonce" item))
                                        (meta-data-val (at "meta-data" item))
                                    )
                                    (if (= nonce-val nonce)
                                        meta-data-val
                                        acc
                                    )
                                )
                            )
                            []
                            read-unit
                        )
                    )
                )
                result-meta-data
            )
        )
    )
    ;;
    ;;==================TRUE-FUNGIBLE-INFO==========
    ;;
    ;;      UR_MetaFungibleKonto|UR_MetaFungibleName|UR_MetaFungibleTicker|UR_MetaFungibleDecimals
    ;;      UR_MetaFungibleCanChangeOwner|UR_MetaFungibleCanUpgrade|UR_MetaFungibleCanAddSpecialRole
    ;;      UR_MetaFungibleCanFreeze|UR_MetaFungibleCanWipe|UR_MetaFungibleCanPause|UR_MetaFungibleIsPaused
    ;;      UR_MetaFungibleSupply|UR_MetaFungibleCreateRoleAccount|UR_MetaFungibleTransferRoleAmount|UR_MetaFungibleNoncesUsed
    ;;
    (defun UR_MetaFungibleKonto:string (identifier:string)
        @doc "Returns Meta Fungible <identifier> Account"
        (UV_MetaFungibleIdentifier identifier)
        (at "owner-konto" (read DPMF-PropertiesTable identifier ["owner-konto"]))
    )
    (defun UR_MetaFungibleName:string (identifier:string)
        @doc "Returns Meta Fungible <identifier> Name"
        (UV_MetaFungibleIdentifier identifier)
        (at "name" (read DPMF-PropertiesTable identifier ["name"]))
    )
    (defun UR_MetaFungibleTicker:string (identifier:string)
        @doc "Returns Meta Fungible <identifier> Name"
        (UV_MetaFungibleIdentifier identifier)
        (at "ticker" (read DPMF-PropertiesTable identifier ["ticker"]))
    )
    (defun UR_MetaFungibleDecimals:integer (identifier:string)
        @doc "Returns <identifier> DPMF Token Decimal size"
        (UV_MetaFungibleIdentifier identifier)
        (at "decimals" (read DPMF-PropertiesTable identifier ["decimals"]))
    )
    (defun UR_MetaFungibleCanChangeOwner:bool (identifier:string)
        @doc "Returns Meta Fungible <identifier> Boolean can-change-owner"
        (UV_MetaFungibleIdentifier identifier)
        (at "can-change-owner" (read DPMF-PropertiesTable identifier ["can-change-owner"]))
    )
    (defun UR_MetaFungibleCanUpgrade:bool (identifier:string)
        @doc "Returns Meta Fungible <identifier> Boolean can-upgrade"
        (UV_MetaFungibleIdentifier identifier)
        (at "can-upgrade" (read DPMF-PropertiesTable identifier ["can-upgrade"]))
    )
    (defun UR_MetaFungibleCanAddSpecialRole:bool (identifier:string)
        @doc "Returns Meta Fungible <identifier> Boolean can-add-special-role"
        (UV_MetaFungibleIdentifier identifier)
        (at "can-add-special-role" (read DPMF-PropertiesTable identifier ["can-add-special-role"]))
    )
    (defun UR_MetaFungibleCanFreeze:bool (identifier:string)
        @doc "Returns Meta Fungible <identifier> Boolean can-freeze"
        (UV_MetaFungibleIdentifier identifier)
        (at "can-freeze" (read DPMF-PropertiesTable identifier ["can-freeze"]))
    )
    (defun UR_MetaFungibleCanWipe:bool (identifier:string)
        @doc "Returns Meta Fungible <identifier> Boolean can-wipe"
        (UV_MetaFungibleIdentifier identifier)
        (at "can-wipe" (read DPMF-PropertiesTable identifier ["can-wipe"]))
    )
    (defun UR_MetaFungibleCanPause:bool (identifier:string)
        @doc "Returns Meta Fungible <identifier> Boolean can-pause"
        (UV_MetaFungibleIdentifier identifier)
        (at "can-pause" (read DPMF-PropertiesTable identifier ["can-pause"]))
    )
    (defun UR_MetaFungibleIsPaused:bool (identifier:string)
        @doc "Returns Meta Fungible <identifier> Boolean is-paused"
        (UV_MetaFungibleIdentifier identifier)
        (at "is-paused" (read DPMF-PropertiesTable identifier ["is-paused"]))
    )
    (defun UR_MetaFungibleCanTransferNFTCreateRole:bool (identifier:string)
        @doc "Returns Meta Fungible <identifier> Boolean can-transfer-nft-create-role"
        (UV_MetaFungibleIdentifier identifier)
        (at "can-transfer-nft-create-role" (read DPMF-PropertiesTable identifier ["can-transfer-nft-create-role"]))
    )
    (defun UR_MetaFungibleSupply:decimal (identifier:string)
        @doc "Returns Meta Fungible <identifier> Total Supply "
        (UV_MetaFungibleIdentifier identifier)
        (at "supply" (read DPMF-PropertiesTable identifier ["supply"]))
    )
    (defun UR_MetaFungibleCreateRoleAccount:string (identifier:string)
        @doc "Returns Meta Fungible <identifier> Create Role Account"
        (UV_MetaFungibleIdentifier identifier)
        (at "create-role-account" (read DPMF-PropertiesTable identifier ["create-role-account"]))
    )
    (defun UR_MetaFungibleTransferRoleAmount:integer (identifier:string)
        @doc "Returns Meta Fungible <identifier> Transfer Role Amount "
        (UV_MetaFungibleIdentifier identifier)
        (at "role-transfer-amount" (read DPMF-PropertiesTable identifier ["role-transfer-amount"]))
    )
    (defun UR_MetaFungibleNoncesUsed:integer (identifier:string)
        @doc "Returns the Last Nonce in use for MetaFungible <identifier>"
        (UV_MetaFungibleIdentifier identifier)

        (at "nonces-used" (read DPMF-PropertiesTable identifier ["nonces-used"]))
    )
    ;;
    ;;==================VALIDATIONS=================
    ;;
    ;;      UV_MetaFungibleAmount|UV_MetaFungibleIdentifier
    ;;
    (defun UV_MetaFungibleAmount (identifier:string amount:decimal)
        @doc "Enforces the Amount <amount> is positive its decimal size conform for MetaFungible <identifier>"
        (UV_MetaFungibleIdentifier identifier)

        (with-read DPMF-PropertiesTable identifier
            { "decimals" := d }
            (enforce
                (= (floor amount d) amount)
                (format "The amount of {} does not conform with the MetaFungible {} defined decimal size" [amount identifier])
            )
            (enforce
                (> amount 0.0)
                (format "The amount of {} is not a valid transfer amount" [amount])
            )
        )
    )
    (defun UV_MetaFungibleIdentifier (identifier:string)
        @doc "Enforces the MetaFungible <identifier> exists"

        (with-default-read DPMF-PropertiesTable identifier
            { "supply" : -1.0 }
            { "supply" := s }
            (enforce
                (>= s 0.0)
                (format "Identifier {} does not exist." [identifier])
            )
        )
    )
    ;;
    ;;==================Composition=================
    ;;
    ;;      UC_ComposeMetaFungible|UC_Nonce-Balance_Pair
    ;;
    (defun UC_ComposeMetaFungible:object{MetaFungible_Schema} (nonce:integer balance:decimal meta-data:[object])
        @doc "Composes a MetaFungible object from <nonce>, <balance> and <meta-data>"
        {"nonce" : nonce, "balance": balance, "meta-data" : meta-data}
    )
    (defun UC_Nonce-Balance_Pair:[object{NonceBalance_Schema}] (nonce-lst:[integer] balance-lst:[decimal])
        @doc "Composes a NonceBalance object from a <nonce-lst> list and <balance-lst> list"
        (let
            (
                (nonce-length:integer (length nonce-lst))
                (balance-length:integer (length balance-lst))
            )
            (enforce (= nonce-length balance-length) "Nonce and Balance Lists are not of equal length")
            (zip (lambda (x:integer y:decimal) { "nonce": x, "balance": y }) nonce-lst balance-lst)
        )
    )
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
    (defun C_ChangeOwnership (patron:string identifier:string new-owner:string)
        @doc "Moves DPMF <identifier> Token Ownership to <new-owner> DPMF Account"
        (let
            (
                (ZG:bool (OUROBOROS.UC_SubZero))
                (current-owner-account:string (UR_MetaFungibleKonto identifier))
            )
            (with-capability (DPMF_OWNERSHIP-CHANGE patron identifier new-owner)
                (if (= ZG false)
                    (OUROBOROS.X_CollectGAS patron current-owner-account OUROBOROS.GAS_BIGGEST)
                    true
                )
                (X_ChangeOwnership patron identifier new-owner)
                (OUROBOROS.X_IncrementNonce patron)
            )
        )
    )
    (defun C_Control
        (
            patron:string
            identifier:string
            can-change-owner:bool 
            can-upgrade:bool 
            can-add-special-role:bool 
            can-freeze:bool 
            can-wipe:bool 
            can-pause:bool
            can-transfer-nft-create-role:bool
        )
        @doc "Controls MetaFungible <identifier> Properties using 7 boolean control triggers \
            \ Setting the <can-upgrade> property to false disables all future Control of Properties"

        (let
            (
                (ZG:bool (OUROBOROS.UC_SubZero))
                (current-owner-account:string (UR_MetaFungibleKonto identifier))
            )
            (with-capability (DPMF_CONTROL patron identifier)
                (if (= ZG false)
                    (OUROBOROS.X_CollectGAS patron current-owner-account OUROBOROS.GAS_SMALL)
                    true
                )
                (X_Control patron identifier can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role)
                (OUROBOROS.X_IncrementNonce patron)
            )
        )
    )
    (defun C_TogglePause (patron:string identifier:string toggle:bool)
        @doc "Pause/Unpause MetaFungible <identifier> via the boolean <toggle>"
        (let
            (
                (ZG:bool (OUROBOROS.UC_SubZero))
            )
            (with-capability (DPMF_TOGGLE_PAUSE patron identifier toggle)
                (if (= ZG false)
                    (OUROBOROS.X_CollectGAS patron patron OUROBOROS.GAS_MEDIUM)
                    true
                )
                (X_TogglePause identifier toggle)
                (OUROBOROS.X_IncrementNonce patron)
            )
        )
    )
    (defun C_ToggleFreezeAccount (patron:string identifier:string account:string toggle:bool)
        @doc "Freeze/Unfreeze via boolean <toggle> MetaFungile <identifier> on DPMF Account <account>"
        (let
            (
                (ZG:bool (OUROBOROS.UC_SubZero))
            )
            (with-capability (DPMF_FROZEN-ACCOUNT patron identifier account toggle)
                (if (= ZG false)
                    (OUROBOROS.X_CollectGAS patron account OUROBOROS.GAS_BIG)
                    true
                )
                (X_ToggleFreezeAccount identifier account toggle)
                (OUROBOROS.X_IncrementNonce patron)
            )
        )
    )
    ;;==================ROLES======================= 
    ;;
    ;;      C_MoveCreateRole|C_ToggleAddQuantityRole
    ;;      C_ToggleBurnRole|C_ToggleTransferRole
    ;;
    (defun C_MoveCreateRole (patron:string identifier:string receiver:string)
        @doc "Moves |role-nft-create| from <sender> to <receiver> DPMF Account for MetaFungible <identifier> \
            \ Only a single DPMF Account can have the |role-nft-create| \
            \ Afterwards the receiver DPMF Account can crete new Meta Fungibles \ 
            \ Fails if the target DPMF Account doesnt exist"

        (let
            (
                (ZG:bool (OUROBOROS.UC_SubZero))
                (current-owner-account:string (UR_MetaFungibleKonto identifier))
            )
            (with-capability (DPMF_MOVE_CREATE-ROLE patron identifier receiver)
                (if (= ZG false)
                    (OUROBOROS.X_CollectGAS patron current-owner-account OUROBOROS.GAS_BIGGEST)
                    true
                )
                (X_MoveCreateRole identifier receiver)
                (OUROBOROS.X_IncrementNonce patron)
            )
        )
    )
    (defun C_ToggleAddQuantityRole (patron:string identifier:string account:string toggle:bool)
        @doc "Sets |role-nft-add-quantity| to <toggle> boolean for MetaFungible <identifier> and DPMF Account <account> \
            \ Afterwards Account <account> can either add quantity or no longer add quantity to existing MetaFungible"

        (let
            (
                (ZG:bool (OUROBOROS.UC_SubZero))
            )
            (with-capability (DPMF_TOGGLE_ADD-QUANTITY-ROLE patron identifier account toggle)
                (if (= ZG false)
                    (OUROBOROS.X_CollectGAS patron account OUROBOROS.GAS_SMALL)
                    true
                )
                (X_ToggleAddQuantityRole identifier account toggle)
                (OUROBOROS.X_IncrementNonce patron)
            )
        )
    )
    (defun C_ToggleBurnRole (patron:string identifier:string account:string toggle:bool)
        @doc "Sets |role-nft-burn| to <toggle> boolean for MetaFungible <identifier> and DPMF Account <account> \
            \ Afterwards Account <account> can either burn or no longer burn existing MetaFungible"

        (let
            (
                (ZG:bool (OUROBOROS.UC_SubZero))
            )
            (with-capability (DPMF_TOGGLE_BURN-ROLE patron identifier account toggle)
                (if (= ZG false)
                    (OUROBOROS.X_CollectGAS patron account OUROBOROS.GAS_SMALL)
                    true
                )
                (X_ToggleBurnRole identifier account toggle)
                (OUROBOROS.X_IncrementNonce patron)
            )
        )
    )
    (defun C_ToggleTransferRole (patron:string identifier:string account:string toggle:bool)
        @doc "Sets |role-transfer| to <toggle> boolean for MetaFungible <identifier> and DPMF Account <account> \
            \ If at least one DPMF Account has the |role-transfer|set to true, then all normal transfer are restricted \
            \ Transfer will only work towards DPMF Accounts with |role-trasnfer| true, \
            \ while these DPMF Accounts can transfer the MetaFungible unrestricted to any other DPMF Account"

        (let
            (
                (ZG:bool (OUROBOROS.UC_SubZero))
            )
            (with-capability (DPMF_TOGGLE_TRANSFER-ROLE patron identifier account toggle)
                (if (= ZG false)
                    (OUROBOROS.X_CollectGAS patron account OUROBOROS.GAS_SMALL)
                    true
                )
                (X_ToggleTransferRole identifier account toggle)
                (X_UpdateRoleTransferAmount identifier toggle)
                (OUROBOROS.X_IncrementNonce patron)
            )
        )
    )
    ;;==================CREATE====================== 
    ;;
    ;;      C_IssueMetaFungible|C_DeployMetaFungibleAccount
    ;;      C_Mint|CX_Mint|C_Create|CX_Create|C_AddQuantity|CX_AddQuantity
    ;;
    (defun C_IssueMetaFungible:string 
        (
            patron:string
            account:string 
            name:string 
            ticker:string 
            decimals:integer 
            can-change-owner:bool 
            can-upgrade:bool 
            can-add-special-role:bool 
            can-freeze:bool 
            can-wipe:bool 
            can-pause:bool
            can-transfer-nft-create-role:bool
        )
        @doc "Issue a new MetaFungible \
            \ This creates an entry into the DPMF-PropertiesTable \
            \ Such an entry means the DPMF Token has been created. Function outputs as string the Token-Identifier \
            \ Token Identifier is formed from ticker, followed by a dash, \ 
            \ followed by the first 12 characters of the previous block hash to ensure uniqueness. \
            \ \
            \ Furthermore, The issuer creates a Standard DPMF Account for himself, as the first Account of this DPMF Token \
            \ By default, DPMF Account creation also creates a Standard DPTS Account, if it doesnt exist"

        ;;Validations
        (OUROBOROS.UV_DPTS-Account account)
        (OUROBOROS.UV_DPTS-Decimals decimals)
        (OUROBOROS.UV_DPTS-Name name)
        (OUROBOROS.UV_DPTS-Ticker ticker)

        (let
            (
                (ZG:bool (OUROBOROS.UC_SubZero))
            )
            (with-capability (DPMF_ISSUE patron account)
                (let
                    (
                        (spawn-id:string (X_IssueMetaFungible patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role))
                    )
                    (if (= ZG false)
                        (OUROBOROS.X_CollectGAS patron account OUROBOROS.GAS_ISSUE)
                        true
                    )
                    (OUROBOROS.X_IncrementNonce patron)
                    spawn-id
                )
                
            )
        )
    )
    (defun C_DeployMetaFungibleAccount (identifier:string account:string)
        @doc "Creates a new DPMF Account for Metafungible <identifier> and Account <account> \
            \ If a DPMF Account already exists for <identifier> and <account>, it remains as is \
            \ \
            \ A Standard DPTS Account is also created, if one doesnt exist \
            \ If a DPTS Account exists, its type remains unchanged"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)

        ;;Creates new Entry in the DPMF-BalancesTable for <identifier>|<account>
        ;;If Entry exists, no changes are being done
        (let*
            (
                (create-role-account:string (UR_MetaFungibleCreateRoleAccount identifier))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF-BalancesTable (concat [identifier BAR account])
                { "unit" : [NEUTRAL_META-FUNGIBLE]
                , "role-nft-add-quantity" : false
                , "role-nft-burn" : false
                , "role-nft-create" : role-nft-create-boolean
                , "role-transfer" : false
                , "frozen" : false}
                { "unit" := u
                , "role-nft-add-quantity" := rnaq
                , "role-nft-burn" := rb
                , "role-nft-create" := rnc
                , "role-transfer" := rt
                , "frozen" := f }
                (write DPMF-BalancesTable (concat [identifier BAR account])
                    { "unit"                        : u
                    , "role-nft-add-quantity"       : rnaq
                    , "role-nft-burn"               : rb
                    , "role-nft-create"             : rnc
                    , "role-transfer"               : rt
                    , "frozen"                      : f
                    } 
                )
            )
        )
    )

    (defun C_Mint:integer (patron:string identifier:string account:string amount:decimal meta-data:[object])
        @doc "Mints <amount> <identifier> MetaFungibles with <meta-data> meta-data for DPMF Account <account> \
            \ Both |role-nft-create| and |role-nft-add-quantity| are required for minting"

        (let
            (
                (ZG:bool (OUROBOROS.UC_ZeroGAS identifier account))
            )
            (with-capability (DPMF_MINT patron identifier account amount false)
                (if (= ZG false)
                    (OUROBOROS.X_CollectGAS patron account OUROBOROS.GAS_SMALL)
                    true
                )
                (let
                    (
                        (created-nonce:integer (X_Mint identifier account amount meta-data))
                    )
                    (OUROBOROS.X_IncrementNonce account)
                    created-nonce
                )
            )
        )
    )
    (defun CX_Mint:integer (patron:string identifier:string account:string amount:decimal meta-data:[object])
        @doc "Methodic, similar to |C_Mint| for Smart-DPTS Account type operation"
        (require-capability (DPMF_MINT patron identifier account amount true))
        (let
            (
                (ZG:bool (OUROBOROS.UC_ZeroGAS identifier account))
            )
            (if (= ZG false)
                (OUROBOROS.X_CollectGAS patron account OUROBOROS.GAS_SMALL)
                true
            )
            (let
                (
                    (created-nonce:integer (X_Mint identifier account amount meta-data))
                )
                (OUROBOROS.X_IncrementNonce account)
                created-nonce
            )
        )
    )
    (defun C_Create:integer (patron:string identifier:string account:string meta-data:[object])
        @doc "Creates a 0.0 balance <identifier> MetaFungible with <meta-data> meta-data for DPMF Account <account>"
        (let
            (
                (ZG:bool (OUROBOROS.UC_ZeroGAS identifier account))
            )
            (with-capability (DPMF_CREATE patron identifier account false)
                (if (= ZG false)
                    (OUROBOROS.X_CollectGAS patron account OUROBOROS.GAS_SMALL)
                    true
                )
                (let
                    (
                        (created-nonce:integer (X_Create identifier account meta-data))
                    )
                    (OUROBOROS.X_IncrementNonce account)
                    created-nonce
                )
            )
        )
    )
    (defun CX_Create:integer (patron:string identifier:string account:string meta-data:[object])
        @doc "Methodic, similar to |C_Create| for Smart-DPTS Account type operation"
        (require-capability (DPMF_CREATE patron identifier account true))
        (let
            (
                (ZG:bool (OUROBOROS.UC_ZeroGAS identifier account))
            )
            (if (= ZG false)
                (OUROBOROS.X_CollectGAS patron account OUROBOROS.GAS_SMALL)
                true
            )
            (let
                (
                    (created-nonce:integer (X_Create identifier account meta-data))
                )
                (OUROBOROS.X_IncrementNonce account)
                created-nonce
            )
        )
    )
    (defun C_AddQuantity (patron:string identifier:string nonce:integer account:string amount:decimal)
        @doc "Adds <amount> quantity to existing Metafungible <identifer> and <nonce> for DPMF Account <account>"
        (let
            (
                (ZG:bool (OUROBOROS.UC_ZeroGAS identifier account))
            )
            (with-capability (DPMF_ADD-QUANTITY patron identifier account amount false)
                (if (= ZG false)
                    (OUROBOROS.X_CollectGAS patron account OUROBOROS.GAS_SMALL)
                    true
                )
                (X_AddQuantity identifier nonce account amount)
                (OUROBOROS.X_IncrementNonce account)
            )
        )
    )
    (defun CX_AddQuantity (patron:string identifier:string nonce:integer account:string amount:decimal)
        @doc "Methodic, similar to |C_AddQuantity| for Smart-DPTS Account type operation"
        (require-capability (DPMF_ADD-QUANTITY patron identifier account amount true))
        (let
            (
                (ZG:bool (OUROBOROS.UC_ZeroGAS identifier account))
            )
            (if (= ZG false)
                (OUROBOROS.X_CollectGAS patron account OUROBOROS.GAS_SMALL)
                true
            )
            (X_AddQuantity identifier nonce account amount)
            (OUROBOROS.X_IncrementNonce account)
        )
    )
    ;;==================DESTROY=====================
    ;;
    ;;      C_Burn|CX_Burn|C_Wipe
    ;;
    (defun C_Burn (patron:string identifier:string nonce:integer account:string amount:decimal)
        @doc "Burns <amount> <identifier>-<nonce> MetaFungible on DPMF Account <account>"
        (let
            (
                (ZG:bool (OUROBOROS.UC_ZeroGAS identifier account))
            )
            (with-capability (DPMF_BURN patron identifier account amount false)
                (if (= ZG false)
                    (OUROBOROS.X_CollectGAS patron account OUROBOROS.GAS_SMALL)
                    true
                )
                (X_Burn identifier nonce account amount)
                (OUROBOROS.X_IncrementNonce account)
            )
        )
    )
    (defun CX_Burn (patron:string identifier:string nonce:integer account:string amount:decimal)
        @doc "Methodic, similar to |C_Burn| for Smart-DPTS Account type operation"
        (require-capability (DPMF_BURN patron identifier account amount true))
        (let
            (
                (ZG:bool (OUROBOROS.UC_ZeroGAS identifier account))
            )
            (if (= ZG false)
                (OUROBOROS.X_CollectGAS patron account OUROBOROS.GAS_SMALL)
                true
            )
            (X_Burn identifier nonce account amount)
            (OUROBOROS.X_IncrementNonce account)
        )
    )
    (defun C_Wipe (patron:string identifier:string account-to-be-wiped:string)
        @doc "Wipes the whole supply of <identifier> MetaFungible of a frozen DPMF Account <account>"

        (let
            (
                (ZG:bool (OUROBOROS.UC_ZeroGAS identifier account-to-be-wiped))
            )
            (with-capability (DPMF_WIPE patron identifier account-to-be-wiped)
                (if (= ZG false)
                    (OUROBOROS.X_CollectGAS patron account-to-be-wiped OUROBOROS.GAS_BIGGEST)
                    true
                )
                (X_Wipe identifier account-to-be-wiped)
                (OUROBOROS.X_IncrementNonce patron)
            )
        )
    )
    ;;==================TRANSFER====================
    ;;
    ;;     C_TransferMetaFungible|CX_TransferMetaFungible
    ;;
    (defun C_TransferMetaFungible (patron:string identifier:string nonce:integer sender:string receiver:string transfer-amount:decimal)
        @doc "Transfers <identifier> MetaFungible with Nonce <nonce> from <sender> to <receiver> DPTF Account, using boolean <anew> as input \
            \ If target DPTF account doesnt exist, boolean <anew> must be set to true"

        (with-capability (TRANSFER_DPMF patron identifier sender receiver transfer-amount false)
            (let
                (
                    (ZG:bool (OUROBOROS.UC_ZeroGAZ identifier sender receiver))
                )
                (if (= ZG false)
                    (OUROBOROS.X_CollectGAS patron sender OUROBOROS.GAS_SMALLEST)
                    true
                )
                (X_TransferMetaFungible identifier nonce sender receiver transfer-amount)
                (OUROBOROS.X_IncrementNonce sender)
            )
        )
    )
    (defun CX_TransferMetaFungible (patron:string identifier:string nonce:integer sender:string receiver:string transfer-amount:decimal)
        @doc "Methodic, Similar to |C_TransferMetaFungible| for Smart-DPTS Account type operation"
        (require-capability (TRANSFER_DPMF patron identifier sender receiver transfer-amount true))
        (let
            (
                (ZG:bool (OUROBOROS.UC_ZeroGAZ identifier sender receiver))
            )
            (if (= ZG false)
                (OUROBOROS.X_CollectGAS patron sender OUROBOROS.GAS_SMALLEST)
                true
            )
            (X_TransferMetaFungible identifier nonce sender receiver transfer-amount)
            (OUROBOROS.X_IncrementNonce sender)
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPMF: AUXILIARY FUNCTIONS             ;;
    ;;                                            ;;
    ;;==================TRANSFER====================
    ;;
    ;;      X_TransferMetaFungible
    ;;
    (defun X_TransferMetaFungible (identifier:string nonce:integer sender:string receiver:string transfer-amount:decimal)
        (require-capability (TRANSFER_DPMF_CORE identifier sender receiver transfer-amount))
        (let
            (
                (current-nonce-meta-data (UR_AccountMetaFungibleMetaData identifier nonce sender))
            )
            (X_Debit identifier nonce sender transfer-amount false)
            (X_Credit identifier nonce current-nonce-meta-data receiver transfer-amount)
        )
    )
    ;;==================CREDIT|DEBIT================ 
    ;;
    ;;      X_Credit|X_Debit
    ;;      X_DebitPaired|X_DebitMultiple
    ;;
    (defun X_Credit (identifier:string nonce:integer meta-data:[object] account:string amount:decimal)
        @doc "Auxiliary Function that credit a MetaFungible to a DPMF Account \
            \ Also creates a new DPMF Account if it doesnt exist. \
            \ If account already has DPMF nonce, it is simply increased \
            \ If account doesnt have DPMF nonce, it is added"

        (require-capability (CREDIT_DPMF identifier account))
        (let*
            (
                (create-role-account:string (UR_MetaFungibleCreateRoleAccount identifier))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF-BalancesTable (concat [identifier BAR account])
                { "unit" : [NEGATIVE_META-FUNGIBLE]
                , "role-nft-add-quantity" : false
                , "role-nft-burn" : false
                , "role-nft-create" : role-nft-create-boolean
                , "role-transfer" : false
                , "frozen" : false}
                { "unit" := unit
                , "role-nft-add-quantity" := rnaq
                , "role-nft-burn" := rb
                , "role-nft-create" := rnc
                , "role-transfer" := rt
                , "frozen" := f}
                (let*
                    (
                        (next-unit:[object] (if (= unit [NEGATIVE_META-FUNGIBLE]) [NEUTRAL_META-FUNGIBLE] unit))
                        (is-new:bool (if (= unit [NEGATIVE_META-FUNGIBLE]) true false))
                        (current-nonce-balance:decimal (UR_AccountMetaFungibleBalance identifier nonce account))
                        (credited-balance:decimal (+ current-nonce-balance amount))
                        (present-meta-fungible:object{MetaFungible_Schema} (UC_ComposeMetaFungible nonce current-nonce-balance meta-data))
                        (credited-meta-fungible:object{MetaFungible_Schema} (UC_ComposeMetaFungible nonce credited-balance meta-data))
                        (processed-unit-with-replace:[object{MetaFungible_Schema}] (OUROBOROS.UC_ReplaceItem next-unit present-meta-fungible credited-meta-fungible))
                        (processed-unit-with-append:[object{MetaFungible_Schema}] (OUROBOROS.UC_AppendLast next-unit credited-meta-fungible))
                    )
                    (enforce (> amount 0.0) "Crediting amount must be greater than zero")
                    ;; First, a new DPTS Account is created for Account <account>. 
                    ;; If DPTS Account exists for <account>, nothing is modified
                    ;; Make the Write in the account
                    (if (= current-nonce-balance 0.0)
                        ;;Remove Metafungible
                        (write DPMF-BalancesTable (concat [identifier BAR account])
                            { "unit"                        : processed-unit-with-append
                            , "role-nft-add-quantity"       : (if is-new false rnaq)
                            , "role-nft-burn"               : (if is-new false rb)
                            , "role-nft-create"             : (if is-new role-nft-create-boolean rnc)
                            , "role-transfer"               : (if is-new false rt)
                            , "frozen"                      : (if is-new false f)}
                        )
                        ;;Replace Metafungible
                        (write DPMF-BalancesTable (concat [identifier BAR account])
                            { "unit"                        : processed-unit-with-replace
                            , "role-nft-add-quantity"       : (if is-new false rnaq)
                            , "role-nft-burn"               : (if is-new false rb)
                            , "role-nft-create"             : (if is-new role-nft-create-boolean rnc)
                            , "role-transfer"               : (if is-new false rt)
                            , "frozen"                      : (if is-new false f)}
                        )
                    )
                )
            )
        )
    )
    (defun X_Debit (identifier:string nonce:integer account:string amount:decimal admin:bool)
        @doc "Auxiliary Function that debits a MetaFungible from a DPMF Account \
            \ If the amount is equal to the whole nonce amount, the whole MetaFungible is removed \
            \ \
            \ true <admin> boolean is used when debiting is executed as a part of wiping by the DPMF Owner \
            \ otherwise, for normal debiting operations, false <admin> boolean must be used"

        (if (= admin true)
            (require-capability (DPMF_OWNER identifier))
            (require-capability (DEBIT_DPMF identifier account))
        )

        (with-read DPMF-BalancesTable (concat [identifier BAR account])
            { "unit"                                := unit  
            ,"role-nft-add-quantity"                := rnaq
            ,"role-nft-burn"                        := rnb
            ,"role-nft-create"                      := rnc
            ,"role-transfer"                        := rt
            ,"frozen"                               := f}
            (let*
                (
                    (current-nonce-balance:decimal (UR_AccountMetaFungibleBalance identifier nonce account))
                    (current-nonce-meta-data (UR_AccountMetaFungibleMetaData identifier nonce account))
                    (debited-balance:decimal (- current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object{MetaFungible_Schema} (UC_ComposeMetaFungible nonce current-nonce-balance current-nonce-meta-data))
                    (debited-meta-fungible:object{MetaFungible_Schema} (UC_ComposeMetaFungible nonce debited-balance current-nonce-meta-data))
                    (processed-unit-with-remove:[object{MetaFungible_Schema}] (OUROBOROS.UC_RemoveItem unit meta-fungible-to-be-replaced))
                    (processed-unit-with-replace:[object{MetaFungible_Schema}] (OUROBOROS.UC_ReplaceItem unit meta-fungible-to-be-replaced debited-meta-fungible))
                )
                (enforce (>= debited-balance 0.0) "Insufficient Funds for debiting")
                (if (= debited-balance 0.0)
                    ;;Remove Metafungible
                    (update DPMF-BalancesTable (concat [identifier BAR account])
                        {"unit"                     : processed-unit-with-remove
                        ,"role-nft-add-quantity"    : rnaq
                        ,"role-nft-burn"            : rnb
                        ,"role-nft-create"          : rnc
                        ,"role-transfer"            : rt
                        ,"frozen"                   : f}
                    )
                    ;;Replace Metafungible
                    (update DPMF-BalancesTable (concat [identifier BAR account])
                        {"unit"                     : processed-unit-with-replace
                        ,"role-nft-add-quantity"    : rnaq
                        ,"role-nft-burn"            : rnb
                        ,"role-nft-create"          : rnc
                        ,"role-transfer"            : rt
                        ,"frozen"                   : f}
                    )
                )
            )
        )
    )
    (defun X_DebitMultiple (identifier:string nonce-lst:[integer] account:string balance-lst:[decimal])
        @doc "Auxiliary Function needed for Wiping \
            \ Executes |X_Debit| on a list of nonces and balances via its helper Function |X_DebitPaired|"

        (let
            (
                (nonce-balance-obj-lst:[object{NonceBalance_Schema}] (UC_Nonce-Balance_Pair nonce-lst balance-lst))
            )
            (map (lambda (x:object{NonceBalance_Schema}) (X_DebitPaired identifier account x)) nonce-balance-obj-lst)
        )
    )
    (defun X_DebitPaired (identifier:string account:string nonce-balance-obj:object{NonceBalance_Schema})
        @doc "Helper Function designed for making |X_DebitMultiple| possible, which is needed for Wiping \
            \ Same a |X_Debit| but the nonce and balance are composed into a singular <nonce-balance-obj> object \
            \ Within |X_DebitPaired|, |X_Debit| is called using true <admin> boolean \
            \ which is needed when MetaFungible debitation is executed by DPMF Owner (admin) on another DPMF Account \
            \ as part of the Wiping Process"

        (let
                (
                    (nonce:integer (at "nonce" nonce-balance-obj))
                    (balance:decimal (at "balance" nonce-balance-obj))
                )
                (X_Debit identifier nonce account balance true)
            )
    )
    ;;
    ;;==================UPDATE======================
    ;;
    ;;      X_UpdateSupply|X_IncrementNonce|X_UpdateRoleTransferAmount
    ;;
    (defun X_UpdateSupply (identifier:string amount:decimal direction:bool)
        @doc "Updates <identifier> MetaFungible supply. Boolean <direction> used for increase|decrease"

        (require-capability (DPMF_UPDATE_SUPPLY))
        (if (= direction true)
            (with-read DPMF-PropertiesTable identifier
                { "supply" := s }
                (enforce (>= (+ s amount) 0.0) "DPMF Token Supply cannot be updated to negative values!")
                (update DPMF-PropertiesTable identifier { "supply" : (+ s amount)})
            )
            (with-read DPMF-PropertiesTable identifier
                { "supply" := s }
                (enforce (>= (- s amount) 0.0) "DPMF Token Supply cannot be updated to negative values!")
                (update DPMF-PropertiesTable identifier { "supply" : (- s amount)})
            )
        )
    )
    (defun X_IncrementNonce (identifier:string)
        @doc "Increments <identifier> MetaFungible nonce."

        (require-capability (DPMF_INCREASE_NONCE))
        (with-read DPMF-PropertiesTable identifier
            { "nonces-used" := nu }
            (update DPMF-PropertiesTable identifier { "nonces-used" : (+ nu 1)})
        )
    )
    (defun X_UpdateRoleTransferAmount (identifier:string direction:bool)
        @doc "Updates |role-transfer-amount| for Token <identifier>"
        (require-capability (DPMF_UPDATE_ROLE-TRANSFER-AMOUNT))
        (if (= direction true)
            (with-read DPMF-PropertiesTable identifier
                { "role-transfer-amount" := rta }
                (update DPMF-PropertiesTable identifier
                    {"role-transfer-amount" : (+ rta 1)}
                )
            )
            (with-read DPMF-PropertiesTable identifier
                { "role-transfer-amount" := rta }
                (update DPMF-PropertiesTable identifier
                    {"role-transfer-amount" : (- rta 1)}
                )
            )
        )
    )
    ;;==================AUXILIARY=================== 
    ;;
    ;;      X_ChangeOwnership|X_Control|X_TogglePause|X_ToggleFreezeAccount
    ;;      X_MoveCreateRole|X_ToggleAddQuantityRole|X_ToggleBurnRole|X_ToggleTransferRole
    ;;      X_IssueMetaFungible|X_Mint|X_Create|X_AddQuantity
    ;;      X_Burn|X_Wipe
    ;;
    (defun X_ChangeOwnership (patron:string identifier:string new-owner:string)
        (require-capability (DPMF_OWNERSHIP-CHANGE_CORE identifier new-owner))
        (update DPMF-PropertiesTable identifier
            {"owner-konto"                      : new-owner}
        )
    )
    (defun X_Control
        (
            patron:string
            identifier:string
            can-change-owner:bool 
            can-upgrade:bool 
            can-add-special-role:bool 
            can-freeze:bool 
            can-wipe:bool 
            can-pause:bool
            can-transfer-nft-create-role:bool
        )
        (require-capability (DPMF_CONTROL_CORE identifier))
        (update DPMF-PropertiesTable identifier
            {"can-change-owner"                 : can-change-owner
            ,"can-upgrade"                      : can-upgrade
            ,"can-add-special-role"             : can-add-special-role
            ,"can-freeze"                       : can-freeze
            ,"can-wipe"                         : can-wipe
            ,"can-pause"                        : can-pause
            ,"can-transfer-nft-create-role"     : can-transfer-nft-create-role}
        )
    )
    (defun X_TogglePause (identifier:string toggle:bool)
        (require-capability (DPMF_TOGGLE_PAUSE_CORE identifier toggle))
        (update DPMF-PropertiesTable identifier
            { "is-paused" : toggle}
        )
    )
    (defun X_ToggleFreezeAccount (identifier:string account:string toggle:bool)
        (require-capability (DPMF_FROZEN-ACCOUNT_CORE identifier account toggle))
        (update DPMF-BalancesTable (concat [identifier BAR account])
            { "frozen" : toggle}
        )
    )
    (defun X_MoveCreateRole (identifier:string receiver:string)
        @doc "Assumes a DPMF Account exists for the <receiver>"
        (require-capability (DPMF_MOVE_CREATE-ROLE_CORE identifier receiver))
        (update DPMF-BalancesTable (concat [identifier BAR (UR_MetaFungibleKonto identifier)])
            {"role-nft-create" : false}
        )
        (update DPMF-BalancesTable (concat [identifier BAR receiver])
            {"role-nft-create" : true}
        )
        (update DPMF-PropertiesTable identifier
            {"create-role-account" : receiver}
        )
    )
    (defun X_ToggleAddQuantityRole (identifier:string account:string toggle:bool)
        (require-capability (DPMF_TOGGLE_ADD-QUANTITY-ROLE_CORE identifier account toggle))
        (update DPMF-BalancesTable (concat [identifier BAR account])
            {"role-nft-add-quantity" : toggle}
        )
    )
    (defun X_ToggleBurnRole (identifier:string account:string toggle:bool)
        (require-capability (DPMF_TOGGLE_BURN-ROLE_CORE identifier account toggle))
        (update DPMF-BalancesTable (concat [identifier BAR account])
            {"role-nft-burn" : toggle}
        )
    )
    (defun X_ToggleTransferRole (identifier:string account:string toggle:bool)
        (require-capability (DPMF_TOGGLE_TRANSFER-ROLE_CORE identifier account toggle))
        (update DPMF-BalancesTable (concat [identifier BAR account])
            {"role-transfer" : toggle}
        )
    )
    (defun X_IssueMetaFungible:string
        (
            patron:string
            account:string 
            name:string 
            ticker:string 
            decimals:integer 
            can-change-owner:bool 
            can-upgrade:bool 
            can-add-special-role:bool 
            can-freeze:bool 
            can-wipe:bool 
            can-pause:bool
            can-transfer-nft-create-role:bool
        )
        (require-capability (DPMF_ISSUE patron account))
        (let
            (
                (identifier:string (OUROBOROS.UC_MakeIdentifier ticker))
            )
            ;; Add New Entries in the DPMF-PropertyTable
            ;; Since the Entry uses insert command, the KEY uniquness is ensured, since it will fail if key already exists.
            ;; Entry is initialised with <is-paused> set to off(false).
            ;; Entry is initialised with a <supply> of 0.0 (decimal)
            ;; Entry is initiated with <create-role-account> as the Issuer Account
            ;; Entry is initiated with 0 to <role-transfer-amount>, since no Account has transfer role upon creation.
            ;; Entry is initiated with <nonce-used> 0, because Issue function simply issues the token, without specific Token creations
            (insert DPMF-PropertiesTable identifier
                {"owner-konto"          : account
                ,"name"                 : name
                ,"ticker"               : ticker
                ,"decimals"             : decimals
                ,"can-change-owner"     : can-change-owner
                ,"can-upgrade"          : can-upgrade
                ,"can-add-special-role" : can-add-special-role
                ,"can-freeze"           : can-freeze
                ,"can-wipe"             : can-wipe
                ,"can-pause"            : can-pause
                ,"is-paused"            : false
                ,"can-transfer-nft-create-role" : can-transfer-nft-create-role
                ,"supply"               : 0.0
                ,"create-role-account"  : account
                ,"role-transfer-amount" : 0
                ,"nonces-used"          : 0}
            )
            ;;Makes a new DPMF Account for the Token Issuer and returns identifier
            (C_DeployMetaFungibleAccount identifier account)
            identifier
        )
    )
    (defun X_Mint:integer (identifier:string account:string amount:decimal meta-data:[object])
        (enforce-one
            (format "No permission available to Mint {} DPMF Token(s) {} with Meta-Data {} with Account {}" [amount identifier meta-data account])
            [
                (require-capability (OUROBOROS.IZ_DPTS_ACCOUNT_SMART account true))
                (require-capability (OUROBOROS.DPTS_ACCOUNT_OWNER account))
            ]
        )
        (require-capability (DPMF_MINT_CORE identifier account amount))
        (let
            (
                (new-nonce:integer (+ (UR_MetaFungibleNoncesUsed identifier) 1))
            )
            (X_Create identifier account meta-data)
            (X_AddQuantity identifier new-nonce account amount)
            new-nonce
        )
    )
    (defun X_Create:integer (identifier:string account:string meta-data:[object])
        @doc "Auxiliary Core Function that creates a MetaFungible"
        (enforce-one
            (format "No permission available to Create the DPMF Token {} with Meta-Data {} with Account {}" [identifier meta-data account])
            [
                (require-capability (OUROBOROS.IZ_DPTS_ACCOUNT_SMART account true))
                (require-capability (OUROBOROS.DPTS_ACCOUNT_OWNER account))
            ]
        )
        (require-capability (DPMF_CREATE_CORE identifier account))
        (let*
            (
                (new-nonce:integer (+ (UR_MetaFungibleNoncesUsed identifier) 1))
                (create-role-account:string (UR_MetaFungibleCreateRoleAccount identifier))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF-BalancesTable (concat [identifier BAR account])
                { "unit" : [NEUTRAL_META-FUNGIBLE]
                , "role-nft-add-quantity" : false
                , "role-nft-burn" : false
                , "role-nft-create" : role-nft-create-boolean
                , "role-transfer" : false
                , "frozen" : false}
                { "unit" := u
                , "role-nft-add-quantity" := rnaq
                , "role-nft-burn" := rb
                , "role-nft-create" := rnc
                , "role-transfer" := rt
                , "frozen" := f}
                (let*
                    (
                        (new-nonce:integer (+ (UR_MetaFungibleNoncesUsed identifier) 1))
                        (meta-fungible:object{MetaFungible_Schema} (UC_ComposeMetaFungible new-nonce 0.0 meta-data))
                        (appended-meta-fungible:[object{MetaFungible_Schema}] (OUROBOROS.UC_AppendLast u meta-fungible))
                    )
                    (write DPMF-BalancesTable (concat [identifier BAR account])
                        { "unit"                        : appended-meta-fungible
                        , "role-nft-add-quantity"       : rnaq
                        , "role-nft-burn"               : rb
                        , "role-nft-create"             : rnc
                        , "role-transfer"               : rt
                        , "frozen"                      : f}
                    )
                    (X_IncrementNonce identifier)
                    new-nonce
                )
            )
        )
    )
    (defun X_AddQuantity (identifier:string nonce:integer account:string amount:decimal)
        @doc "Auxiliary Core Function that adds quantity for an existing Metafungible \
            \ Assumes <identifier> and <nonce> exist on DPMF Account"

        (enforce-one
            (format "No permission available to increase the Quantity for DPTF Token {} and Nonce {} by {} with Account {}" [identifier nonce amount account])
            [
                (require-capability (OUROBOROS.IZ_DPTS_ACCOUNT_SMART account true))
                (require-capability (OUROBOROS.DPTS_ACCOUNT_OWNER account))
            ]
        )
        (require-capability (DPMF_ADD-QUANTITY_CORE identifier account amount))
        (with-read DPMF-BalancesTable (concat [identifier BAR account])
            { "unit" := unit }
            (let*
                (
                    (current-nonce-balance:decimal (UR_AccountMetaFungibleBalance identifier nonce account))
                    (current-nonce-meta-data (UR_AccountMetaFungibleMetaData identifier nonce account))
                    (updated-balance:decimal (+ current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object{MetaFungible_Schema} (UC_ComposeMetaFungible nonce current-nonce-balance current-nonce-meta-data))
                    (updated-meta-fungible:object{MetaFungible_Schema} (UC_ComposeMetaFungible nonce updated-balance current-nonce-meta-data))
                    (processed-unit:[object{MetaFungible_Schema}] (OUROBOROS.UC_ReplaceItem unit meta-fungible-to-be-replaced updated-meta-fungible))
                )
                (update DPMF-BalancesTable (concat [identifier BAR account])
                    {"unit" : processed-unit}    
                )
            )
        )
        (X_UpdateSupply identifier amount true)
    )
    (defun X_Burn (identifier:string nonce:integer account:string amount:decimal)
        (enforce-one
            (format "No permission available to burn with Account {}" [account])
            [
                (require-capability (OUROBOROS.IZ_DPTS_ACCOUNT_SMART account true))
                (require-capability (OUROBOROS.DPTS_ACCOUNT_OWNER account))
            ]
        )
        (require-capability (DPMF_BURN_CORE identifier account amount))
        (X_Debit identifier nonce account amount false)
        (X_UpdateSupply identifier amount false)
    )
    (defun X_Wipe (identifier:string account-to-be-wiped:string)
        (let*
            (
                (nonce-lst:[integer] (UR_AccountMetaFungibleNonces identifier account-to-be-wiped))
                (balance-lst:[decimal] (UR_AccountMetaFungibleBalances identifier account-to-be-wiped))
                (balance-sum:decimal (fold (+) 0.0 balance-lst))
            )
            (require-capability (DPMF_WIPE_CORE identifier account-to-be-wiped))
            (X_DebitMultiple identifier nonce-lst account-to-be-wiped balance-lst)
            (X_UpdateSupply identifier balance-sum false)
        )
    )
)

(create-table DPMF-PropertiesTable)
(create-table DPMF-BalancesTable)