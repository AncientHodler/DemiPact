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

        owner:guard                         ;;Guard of the Token Owner, Account that created the DPMF Token
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

        unit:[object]                       ;;Stores NFT Data in a list of Objects that use the MetaFungible schema
        guard:guard                         ;;Stores Guard for DPFS Account
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
    (defconst MFKEY1 "nonce")               ;;integer
    (defconst MFKEY2 "balance")             ;;decimal
    (defconst MFKEY3 "meta-data")           ;;object
    (defconst MFKEYS [MFKEY1 MFKEY2 MFKEY3])
    (defconst MFTYP1 "integer")
    (defconst MFTYP2 "decimal")
    (defconst MFTYP3 "[*]")
    (defconst MFTYP4 "object:*")
    (defconst MFTYP5 "[<a>]")
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
    ;;      DPMF_INCREASE_NONCE                     Capability required to update |nonce| in the DPMF-PropertiesTable                                   ;;
    ;;      DPMF_UPDATE-ROLE-TRANSFER-AMOUNT        Capability required to update |transfer-role-amount| for Identifier <identifier>                    ;;
    ;;      DPMF_UPDATE-CREATE-ROLE-ACCOUNT         Capability required to update |create-role-account| for Identifier <identifier>                     ;;
    ;;      DPMF_UPDATE-ROLE-NFT-CREATE             Capability required to update |role-nft-create| for Identifier <identifier> on Account <account>    ;;
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
    ;;==================WITH-GAS====================                                                                                                    ;;
    ;;      DPMF-GAS_OWNERSHIP-CHANGE               GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_CONTROL                        GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_PAUSE                          GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_UNPAUSE                        GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_FREEZE_ACCOUNT                 GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_UNFREEZE_ACCOUNT               GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_SET_ADD-QUANTITY-ROLE          GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_SET_BURN-ROLE                  GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_SET_TRANSFER-ROLE              GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_MOVE_CREATE-ROLE               GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_UNSET_ADD-QUANTITY-ROLE        GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_UNSET_BURN-ROLE                GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_UNSET_TRANSFER-ROLE            GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_MINT                           GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_CREATE                         GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_ADD-QUANTITY                   GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_BURN                           GAS Collection Variant of Capability                                                                ;;
    ;;      DPMF-GAS_WIPE                           GAS Collection Variant of Capability                                                                ;;
    ;;==================CONTROL=====================                                                                                                    ;;
    ;;      DPMF_OWNERSHIP-CHANGE                   Capability required for changing DPMF Token Ownership                                               ;;
    ;;      DPMF_CONTROL                            Capability required for managing DPMF Properties                                                    ;;
    ;;      DPMF_PAUSE                              Capability required to Pause a DPMF                                                                 ;;
    ;;      DPMF_UNPAUSE                            Capability required to Unpause a DPMF                                                               ;;
    ;;      DPMF_FREEZE_ACCOUNT                     Capability required to Freeze a DPMF Account                                                        ;;
    ;;      DPMF_UNFREEZE_ACCOUNT                   Capability required to Unfreeze a DPMF Account                                                      ;;
    ;;==================SET=========================                                                                                                    ;;
    ;;      DPMF_SET_ADD-QUANTITY-ROLE              Capability required to Set Add-Quantity Role for DPMF Account                                       ;;
    ;;      DPMF_SET_BURN-ROLE                      Capability required to Set Burn Role for DPMF Account                                               ;;
    ;;      DPMF_SET_TRANSFER-ROLE                  Capability required to Set Transfer Role for DPMF Account                                           ;;
    ;;      DPMF_MOVE_CREATE-ROLE                   Capability required to Change Create Role to another DPMF Account                                   ;;
    ;;==================UNSET=======================                                                                                                    ;;
    ;;      DPMF_UNSET_ADD-QUANTITY-ROLE            Capability required to Unset Add-Quantity Role for DPMF Account                                     ;;
    ;;      DPMF_UNSET_BURN-ROLE                    Capability required to Unset Burn Role for a DPMF Account                                           ;;
    ;;      DPMF_UNSET_TRANSFER-ROLE                Capability required to Unset Transfer Role for a DPMF Account                                       ;;
    ;;==================CREATE======================                                                                                                    ;;
    ;;      DPMF_MINT                               Capability required to mint a DPMF Token                                                            ;;
    ;;      DPMF_CREATE                             Capability that allows creation of a new MetaFungilbe nonce                                         ;;
    ;;      DPMF_ADD-QUANTITY                       Capability required to add-quantity for a DPMF Token                                                ;;
    ;;==================DESTROY=====================                                                                                                    ;;
    ;;      DPMF_BURN                               Capability required to burn a DPMF Token                                                            ;;
    ;;      DPMF_WIPE                               Capability required to Wipe all DPMF Tokens from a DPMF account                                     ;;
    ;;=================CORE=========================                                                                                                    ;;
    ;;      CREDIT_DPMF                             Capability to perform crediting operations with DPMF Tokens                                         ;;
    ;;      DEBIT_DPMF                              Capability to perform debiting operations on Normal DPTS Account types with DPMF Tokens             ;;
    ;;      DEBIT_DPMF_SC                           Capability to perform debiting operations on Smart(Contract) DPTS Account types with DPMF Tokens    ;;
    ;;      TRANSFER_DPMF                           Capability for transfer between 2 DPTS accounts for a specific DPMF Token identifier                ;;
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
    ;;      DPMF_OWNER|DPMF_CAN-CHANGE-OWNER_ON|DPMF_CAN-UPGRADE_ON|DPMF_CAN-ADD-SPECIAL-ROLE_ON
    ;;      DPMF_CAN-FREEZE_ON|DPMF_CAN-WIPE_ON|DPMF_CAN-PAUSE_ON|DPMF_IS-PAUSED_ON|DPMF_IS-PAUSED_OF
    ;;      DPMF_CAN-TRANSFER-NFT-CREATE-ROLE_ON|DPMF_UPDATE_SUPPLY|DPMF_INCREASE_NONCE
    ;;      DPMF_UPDATE_TRANSFER-ROLE-AMOUNT|DPMF_UPDATE-ROLE-NFT-CREATE|DPMF_UPDATE-CREATE-ROLE-ACCOUNT
    ;;
    (defcap DPMF_OWNER (identifier:string)
        @doc "Enforces DPMF Token Ownership"
        (enforce-guard (UR_MetaFungibleOwner identifier))
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
    (defcap DPMF_IS-PAUSED_ON (identifier:string)
        @doc "Enforces that the DPMF Token is paused"
        (let
            (
                (x:bool (UR_MetaFungibleIsPaused identifier))
            )
            (enforce (= x true) (format "DPMF Token {} is already unpaused" [identifier])
            )
        )
    )
    (defcap DPMF_IS-PAUSED_OFF (identifier:string)
        @doc "Enforces that the DPMF Token is not paused"
        (let
            (
                (x:bool (UR_MetaFungibleIsPaused identifier))
            )
            (enforce (= x false) (format "DPMF Token {} is already paused" [identifier])
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
    (defcap DPMF_UPDATE_SUPPLY (identifier:string amount:decimal) 
        @doc "Capability required to update DPMF Supply"
        (UV_MetaFungibleAmount identifier amount)
        true
    )
    (defcap DPMF_INCREASE_NONCE ()
        @doc "Capability required to update |nonce| in the DPMF-PropertiesTable"
        true
    )
    (defcap DPMF_UPDATE-ROLE-TRANSFER-AMOUNT (identifier:string)
        @doc "Capability required to update |role-transfer-amount| for Identifier <identifier>"
        (UV_MetaFungibleIdentifier identifier)
    )
    (defcap DPMF_UPDATE-CREATE-ROLE-ACCOUNT (identifier:string recipient:string)
        @doc "Capability required to update |create-role-account| for Identifier <identifier>"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account recipient)
        (compose-capability (DPMF_OWNER identifier))
    )
    (defcap DPMF_UPDATE-ROLE-NFT-CREATE (identifier:string account:string)
        @doc "Capability required to update |role-nft-create| for Identifier <identifier> on Account <account>"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
    )
    ;;======DPMF-BALANCES-TABLE-MANAGEMENT==========
    ;;
    ;;      DPMF_ACCOUNT_EXIST|DPMF_ACCOUNT_OWNER
    ;;      DPMF_ACCOUNT_ADD-QUANTITY_ON|DPMF_ACCOUNT_ADD-QUANTITY_OFF
    ;;      DPMF_ACCOUNT_BURN_ON|DPMF_ACCOUNT_BURN_OFF
    ;;      DPMF_ACCOUNT_CREATE_ON|DPMF_ACCOUNT_CREATE_OFF
    ;;      DPMF_ACCOUNT_TRANSFER_ON|DPMF_ACCOUNT_TRANSFER_OFF
    ;;      DPMF_ACCOUNT_FREEZE_ON|DPMF_ACCOUNT_FREEZE_OFF
    ;;
    (defcap DPMF_ACCOUNT_EXIST (identifier:string account:string)
        @doc "Enforces that the DPMF Account <account> exists for Token <identifier>"
        (with-default-read DPMF-BalancesTable (concat [identifier BAR account])
            { "balance" : -1.0}
            { "balance" := b}
            (enforce (>= b 0.0) (format "The DPMF Account {} for the Token {} doesnt exist" [account identifier]))
        )
    )
    (defcap DPMF_ACCOUNT_OWNER (identifier:string account:string)
        @doc "Enforces DPMF Account Ownership"
        (enforce-guard (UR_AccountMetaFungibleGuard identifier account))
    )
    (defcap DPMF_ACCOUNT_ADD-QUANTITY_ON (identifier:string account:string)
        @doc "Enforces DPMF Account has add-quantity role on"
        (let
            (
                (x:bool (UR_AccountMetaFungibleRoleNFTAQ identifier account))
            )
            (enforce (= x true) (format "Account {} isnt allowed to add quantity for DPMF {} Token" [account identifier])
            )
        )
    )
    (defcap DPMF_ACCOUNT_ADD-QUANTITY_OFF (identifier:string account:string)
        @doc "Enforces DPMF Account has add-quantity role off"
        (let
            (
                (x:bool (UR_AccountMetaFungibleRoleNFTAQ identifier account))
            )
            (enforce (= x false) (format "Account {} is allowed to add quantity for DPMF {} Token" [account identifier])
            )
        )
    )
    (defcap DPMF_ACCOUNT_BURN_ON (identifier:string account:string)
        @doc "Enforces DPMF Account has burn role on"
        (let
            (
                (x:bool (UR_AccountMetaFungibleRoleBurn identifier account))
            )
            (enforce (= x true) (format "Account {} isnt allowed to burn DPMF {} Token" [account identifier])
            )
        )
    )
    (defcap DPMF_ACCOUNT_BURN_OFF (identifier:string account:string)
        @doc "Enforces DPMF Account has burn role off"
        (let
            (
                (x:bool (UR_AccountMetaFungibleRoleBurn identifier account))
            )
            (enforce (= x false) (format "Account {} is allowed to burn DPTF {} Token" [account identifier])
            )
        )
    )
    (defcap DPMF_ACCOUNT_CREATE_ON (identifier:string account:string)
        @doc "Enforces DPMF Account has create role on"
        (let
            (
                (x:bool (UR_AccountMetaFungibleRoleCreate identifier account))
            )
            (enforce (= x true) (format "Account {} isnt allowed to create DPMF {} Token" [account identifier])
            )
        )
    )
    (defcap DPMF_ACCOUNT_CREATE_OFF (identifier:string account:string)
        @doc "Enforces DPMF Account has create role off"
        (let
            (
                (x:bool (UR_AccountMetaFungibleRoleCreate identifier account))
            )
            (enforce (= x false) (format "Account {} is allowed to create DPTF {} Token" [account identifier])
            )
        )
    )
    (defcap DPMF_ACCOUNT_TRANSFER_ON (identifier:string account:string)
        @doc "Enforces DPMF Account has transfer role on"
        (let
            (
                (x:bool (UR_AccountMetaFungibleRoleTransfer identifier account))
            )
            (enforce (= x true) (format "Account {} doesnt have a valid transfer role for DPMF {} Token" [account identifier])
            )
        )
    )
    (defcap DPMF_ACCOUNT_TRANSFER_OFF (identifier:string account:string)
        @doc "Enforces DPMF Account has transfer role off"
        (let
            (
                (x:bool (UR_AccountMetaFungibleRoleTransfer identifier account))
            )
            (enforce (= x false) (format "Account {} has a valid transfer role for DPMF {} Token" [account identifier])
            )
        )
    )
    (defcap DPMF_ACCOUNT_FREEZE_ON (identifier:string account:string)
        @doc "Enforces DPMF Account is frozen"
        (let
            (
                (x:bool (UR_AccountMetaFungibleFrozenState identifier account))
            )
            (enforce (= x true) (format "Account {} isnt frozen for DPMF {} Token" [account identifier])
            )
        )
    )
    (defcap DPMF_ACCOUNT_FREEZE_OFF (identifier:string account:string)
        @doc "Enforces DPMF Account is not frozen"
        (let
            (
                (x:bool (UR_AccountMetaFungibleFrozenState identifier account))
            )
            (enforce (= x false) (format "Account {} is frozen for DPMF {} Token" [account identifier])
            )
        )
    )
    ;;---------------------------------------------;;
    ;;                                             ;;
    ;;      COMPOSED                               ;;
    ;;                                             ;;
    ;;==================CONTROL======================
    ;;
    ;;      DPMF_OWNERSHIP-CHANGE|DPMF_CONTROL
    ;;      DPMF_PAUSE|DPMF_UNPAUSE|
    ;;      DPMF_FREEZE_ACCOUNT|DPMF_UNFREEZE_ACCOUNT
    ;;
    (defcap DPMF_OWNERSHIP-CHANGE (identifier:string new-owner:string)
        @doc "Capability required for changing DPMF Token Ownership"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account new-owner)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-CHANGE-OWNER_ON identifier))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_CONTROL (identifier:string)
        @doc "Capability required for managing DPMF Properties"
        (UV_MetaFungibleIdentifier identifier)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-UPGRADE_ON identifier))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_PAUSE (identifier:string)
        @doc "Capability required to Pause a DPMF Token"
        (UV_MetaFungibleIdentifier identifier)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-PAUSE_ON identifier))
        (compose-capability (DPMF_IS-PAUSED_OFF identifier))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_UNPAUSE (identifier:string)
        @doc "Capability required to Unpause a DPMF Token"
        (UV_MetaFungibleIdentifier identifier)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-PAUSE_ON identifier))
        (compose-capability (DPMF_IS-PAUSED_ON identifier))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_FREEZE_ACCOUNT (identifier:string account:string)
        @doc "Capability required to Freeze a DPMF Account"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-FREEZE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_FREEZE_OFF identifier account))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_UNFREEZE_ACCOUNT (identifier:string account:string)
        @doc "Capability required to Unfreeze a DPMF Account"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-FREEZE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_FREEZE_ON identifier account))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    ;;==================SET=========================
    ;;
    ;;      DPMF_MOVE_CREATE-ROLE|DPMF_SET_ADD-QUANTITY-ROLE|
    ;;      DPMF_SET_BURN-ROLE|DPMF_SET_TRANSFER-ROLE
    ;;
    (defcap DPMF_MOVE_CREATE-ROLE (identifier:string sender:string receiver:string)
        @doc "Capability required to Change Create Role to another DPMF Account"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_SenderWithReceiver sender receiver)

        (compose-capability (DPMF_UPDATE-CREATE-ROLE-ACCOUNT identifier receiver))
        ;;contains (compose-capability (DPMF_OWNER identifier))

        (compose-capability (DPMF_CAN-TRANSFER-NFT-CREATE-ROLE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_CREATE_ON identifier sender))
        (compose-capability (DPMF_ACCOUNT_CREATE_OFF identifier receiver))
        
        (compose-capability (DPMF_UPDATE-ROLE-NFT-CREATE identifier sender))
        (compose-capability (DPMF_UPDATE-ROLE-NFT-CREATE identifier receiver))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_SET_ADD-QUANTITY-ROLE (identifier:string account:string)
        @doc "Capability required to Set Add-Quantity Role for DPMF Account"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_ADD-QUANTITY_OFF identifier account))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_SET_BURN-ROLE (identifier:string account:string)
        @doc "Capability required to Set Burn Role for DPMF Account"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_BURN_OFF identifier account))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_SET_TRANSFER-ROLE (identifier:string account:string)
        @doc "Capability required to Set Transfer Role for DPMF Account"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_TRANSFER_OFF identifier account))
        (compose-capability (DPMF_UPDATE-ROLE-TRANSFER-AMOUNT identifier))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    ;;==================UNSET========================
    ;;
    ;;      DPMF_UNSET_ADD-QUANTITY-ROLE|DPMF_UNSET_BURN-ROLE|DPMF_UNSET_TRANSFER-ROLE
    ;;
    (defcap DPMF_UNSET_ADD-QUANTITY-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Add-Quantity Role for DPMF Account"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_ACCOUNT_ADD-QUANTITY_ON identifier account))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_UNSET_BURN-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Burn Role for DPMF Account"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_ACCOUNT_BURN_ON identifier account))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_UNSET_TRANSFER-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Transfer Role for DPMF Account"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_ACCOUNT_TRANSFER_ON identifier account))
        (compose-capability (DPMF_UPDATE-ROLE-TRANSFER-AMOUNT identifier))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    ;;==================CREATE=======================
    ;;
    ;;      DPMF_MINT|DPMF_CREATE|DPMF_ADD-QUANTITY
    ;;
    (defcap DPMF_MINT (identifier:string account:string amount:decimal)
        @doc "Capability required to mint a DPMF Token \
        \ Smart-Contract Account type doesnt require their guard|key"
        (UV_MetaFungibleAmount identifier amount)
        (OUROBOROS.UV_DPTS-Account account)
        (compose-capability (DPMF_CREATE identifier account))
        (compose-capability (DPMF_ADD-QUANTITY identifier account amount))
    )
    (defcap DPMF_CREATE (identifier:string account:string)
        @doc "Capability that allows creation of a new MetaFungilbe nonce \
        \ This creates a MetaFungible with zero quantity"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (compose-capability (DPMF_CLIENT identifier account))
        (compose-capability (DPMF_ACCOUNT_CREATE_ON identifier account))
        (compose-capability (DPMF_INCREASE_NONCE))
    )
    (defcap DPMF_ADD-QUANTITY (identifier:string account:string amount:decimal)
        @doc "Capability required to add-quantity for a DPMF Token \
        \ Smart-Contract Account type doesnt require their guard|key"
        (UV_MetaFungibleAmount identifier amount)
        (OUROBOROS.UV_DPTS-Account account)

        (compose-capability (DPMF_CLIENT identifier account))
        (compose-capability (DPMF_ACCOUNT_ADD-QUANTITY_ON identifier account))
        (compose-capability (CREDIT_DPMF identifier account))
        (compose-capability (DPMF_UPDATE_SUPPLY identifier amount))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    ;;==================DESTROY======================
    ;;
    ;;      DPMF_BURN|DPMF_WIPE
    ;;
    (defcap DPMF_BURN (identifier:string nonce:integer account:string amount:decimal)
        @doc "Capability required to burn a DPMF Token locally \
        \ Smart-Contract Account type doesnt require their guard|key"
        (UV_MetaFungibleAmount identifier amount)
        (OUROBOROS.UV_DPTS-Account account)
        (compose-capability (DPMF_ACCOUNT_BURN_ON identifier account))
        (compose-capability (DEBIT_DPMF identifier account))
        (compose-capability (DPMF_UPDATE_SUPPLY identifier amount))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap DPMF_WIPE (identifier:string account:string amount:decimal)
        @doc "Capability required to Wipe all DPMF Tokens from a DPMF account"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-WIPE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_FREEZE_ON identifier account))
        (compose-capability (DPMF_UPDATE_SUPPLY identifier amount))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: COMPOSED CAPABILITIES           ;;
    ;;                                            ;;
    ;;==================TRANSFER==================== 
    ;;
    ;;      ABSOLUTE_METHODIC_TRANSFER|TRANSFER_DPMF_GAS-PATRON
    ;;      TRANSFER_DPMF_GAS|TRANSFER_DPMF|
    ;;
    (defcap ABSOLUTE_METHODIC_TRANSFER (initiator:string identifier:string sender:string receiver:string transfer-amount:decimal)
        (let
            (
                (gas-toggle:bool (OUROBOROS.UR_GasToggle))
                (gas-id:string (OUROBOROS.UR_GasID))
            )
            (if (= gas-toggle false)
                (compose-capability (TRANSFER_DPMF_GAS-PATRON initiator identifier sender receiver transfer-amount true))
                (compose-capability (TRANSFER_DPMF_GAS initiator identifier sender receiver transfer-amount true OUROBOROS.GAS_SMALLEST))
            )
        )
    )
    (defcap TRANSFER_DPMF_GAS-PATRON (initiator:string identifier:string sender:string receiver:string transfer-amount:decimal)
        (compose-capability (TRANSFER_DPMF identifier sender receiver transfer-amount true))
        (compose-capability (OUROBOROS.GAS_PATRON initiator))
    )
    (defcap TRANSFER_DPMF_GAS 
        (
            initiator:string
            identifier:string 
            sender:string 
            receiver:string 
            transfer-amount:decimal 
            method:bool
            gas-amount:decimal
        )
        (compose-capability (TRANSFER_DPMF identifier sender receiver transfer-amount method))
        (compose-capability (OUROBOROS.GAS_COLLECTION initiator sender gas-amount))
    )
    (defcap TRANSFER_DPMF 
        (
            identifier:string 
            sender:string 
            receiver:string 
            transfer-amount:decimal 
            method:bool
        )
        @doc "Capability for transfer between 2 DPTS accounts for a specific DPMF Token identifier"
        (UV_MetaFungibleAmount identifier transfer-amount)
        (OUROBOROS.UV_SenderWithReceiver sender receiver)

        ;;Checks pause and freeze statuses
        (compose-capability (DPMF_IS-PAUSED_OFF identifier))
        (compose-capability (DPMF_ACCOUNT_FREEZE_OFF identifier sender))
        (compose-capability (DPMF_ACCOUNT_FREEZE_OFF identifier receiver))

        ;;Checks transfer roles of sender and receiver
        (with-read DPMF-PropertiesTable identifier
            { "role-transfer-amount" := rta }
            (if (!= rta 0)
                ;;if true
                (enforce-one
                    (format "Neither the sender {} nor the receiver {} have an active transfer role" [sender receiver])
                    [
                        (compose-capability (DPMF_ACCOUNT_TRANSFER_ON identifier sender))
                        (compose-capability (DPMF_ACCOUNT_TRANSFER_ON identifier receiver))
                    ]
                )
                ;;if false
                (format "No transfer Role restrictions exist for Token {}" [identifier])
            )
        )
        ;;Checks transferability between Normal and Smart DPTS Account Types
        (compose-capability (OUROBOROS.SC_TRANSFERABILITY sender receiver method))
        ;;Add Debit and Credit capabilities
        (compose-capability (DEBIT_DPMF identifier sender))  
        (compose-capability (CREDIT_DPMF identifier receiver))
        ;;Add Nonce increase capability
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    ;;=================CORE==========================
    (defcap CREDIT_DPMF (identifier:string account:string)
        @doc "Capability to perform crediting operations with DPMF Tokens"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
    )
    (defcap DEBIT_DPMF (identifier:string account:string)
        @doc "Capability to perform debiting operations on a Normal DPTS Account type for a DPMF Token"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)                

        (compose-capability (DPMF_CLIENT identifier account))
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
    ;;      UR_AccountMetaFungibleGuard             Returns Account <account> Meta Fungible <identifier> Guard                                          ;;
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
    ;;      UV_ObjectListAsMetaFungibleList         Enforces that a list of Objects contains Objects conform to the MetaFungible Schema                 ;;
    ;;      UV_ObjectAsMetaFungible                 Enforces that an Object is conform to the MetaFungible Schema                                       ;;
    ;;      UV_ObjectAsNonceBalancePair             Enforces that an Object is a pair of nonce and balances                                             ;;
    ;;==================Composition=================                                                                                                    ;;
    ;;      UC_ComposeMetaFungible                   Composes a MetaFungible object from <nonce>, <balance> and <meta-data>                             ;;
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
    ;;3     C_Pause                                 Pause MetaFungible <identifier>                                                                     ;;
    ;;3     C_Unpause                               Unpause MetaFungible <identifier>                                                                   ;;
    ;;4     C_FreezeAccount                         Freeze MetaFungile <identifier> on DPMF Account <account>                                           ;;
    ;;4     C_UnfreezeAccount                       Unfreeze MetaFungile <identifier> on DPMF Account <account>                                         ;;
    ;;==================SET=========================                                                                                                    ;;
    ;;2     C_MoveCreateRole                        Moves |role-nft-create| from <sender> to <receiver> DPMF Account for MetaFungible <identifier>      ;;
    ;;2     C_SetAddQuantityRole                    Sets |role-nft-add-quantity| to true for MetaFungible <identifier> and DPMF Account <account>       ;;
    ;;2     C_SetBurnRole                           Sets |role-nft-burn| to true for MetaFungible <identifier> and DPMF Account <account>               ;;
    ;;2     C_SetTransferRole                       Sets |role-transfer| to true for MetaFungible <identifier> and DPMF Account <account>               ;;
    ;;==================UNSET=======================                                                                                                    ;;
    ;;2     C_UnsetAddQuantityRole                  Sets |role-nft-add-quantity| to false for MetaFungible <identifier> and DPMF Account <account>      ;;
    ;;2     C_UnsetBurnRole                         Sets |role-nft-burn| to false for MetaFungible <identifier> and DPMF Account <account>              ;;
    ;;2     C_UnsetTransferRole                     Sets |role-transfer| to false for MetaFungible <identifier> and DPMF Account <account>              ;;
    ;;==================CREATE======================                                                                                                    ;;
    ;;15    C_IssueMetaFungible                     Issues a new MetaFungible                                                                           ;;
    ;;      C_DeployMetaFungibleAccount             Creates a new DPMF Account for MetaFungible <identifier> and Account <account>                      ;;
    ;;3     C_Mint                                  Mints <amount> <identifier> MetaFungibles with <meta-data> meta-data for DPMF Account <account>     ;;
    ;;2     C_Create                                Creates a 0 balance <identifier> MetaFungible with <meta-data> meta-data for DPMF Account <account> ;;
    ;;2     C_AddQuantity                           Adds <amount> quantity to existing MetaFungible <identifer> and <nonce> for DPMF Account <account>  ;;
    ;;==================DESTROY=====================                                                                                                    ;;
    ;;2     C_Burn                                  Burns <amount> <identifier>-<nonce> MetaFungible on DPMF Account <account>                          ;;
    ;;5     C_Wipe                                  Wipes the whole supply of <identifier> MetaFungible of a frozen DPMF Account <account>              ;;
    ;;==================TRANSFER====================                                                                                                    ;;
    ;;1     C_TransferMetaFungible                  Transfers <identifier>-<nonce> MetaFungible from <sender> to <receiver> DPMF Account                ;;
    ;;1     C_TransferMetaFungibleAnew              Same as |C_TransferMetaFungible| but with DPMF Account creation                                     ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      AUXILIARY FUNCTIONS                                                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================TRANSFER====================                                                                                                    ;;
    ;;      X_TransferMetaFungible                  Transfers <identifier>|<nonce> MetaFungible from <sender> to <receiver> DPMF Account without GAS    ;;
    ;;      X_TransferMetaFungibleAnew              Similar to |X_TransferMetaFungible| but with DPMF Account creation                                  ;;
    ;:=================METHODIC-TRANSFER===========                                                                                                     ;;
    ;;      XC_MethodicTransferMetaFungible         Similar to |C_TransferMetaFungible| but methodic for Smart-DPTS Account type operation              ;;
    ;;      XC_MethodicTransferMetaFungibleAnew     Similar to |C_TransferMetaFungibleAnew| but methodic for Smart-DPTS Account type operation          ;;
    ;;      X_MethodicTransferMetaFungibleWithGAS   Similar to |X_MethodicTransferMetaFungible| but with GAS                                            ;;
    ;;      X_MethodicTransferMetaFungible          Similar to |X_TransferMetaFungible| but methodic for Smart-DPTS Account type operation              ;;
    ;;      X_MethodicTransferMetaFungibleAnewWithGAS Similar to |X_MethodicTransferMetaFungibleAnew| but with GAS                                      ;;
    ;;      X_MethodicTransferMetaFungibleAnew      Similar to |X_TransferMetaFungibleAnew| but methodic for Smart-DPTS Account type operation          ;;
    ;;==================CREDIT|DEBIT================                                                                                                    ;;
    ;;      X_Create                                Auxiliary Function that creates a MetaFungible                                                      ;;
    ;;      X_AddQuantity                           Auxiliary Function that adds quantity for an existing MetaFungible                                  ;;
    ;;      X_Credit                                Auxiliary Function that credits a MetaFungible to a DPMF Account                                    ;;
    ;;      X_Debit                                 Auxiliary Function that debits a MetaFungible from a DPMF Account                                   ;;
    ;;      X_DebitPaired                           Auxiliary Helper Function designed for making |X_DebitMultiple| possible, which is needed for Wiping;;
    ;;      X_DebitMultiple                         Auxiliary Function needed for Wiping                                                                ;;
    ;;==================UPDATE======================                                                                                                    ;;
    ;;      X_UpdateSupply                          Updates <identifier> MetaFungible supply. Boolean <direction> used for increase|decrease            ;;
    ;;      X_IncrementNonce                        Increments <identifier> MetaFungible nonce.                                                         ;;
    ;;      X_UpdateRoleTransferAmount              Updates <role-transfer-amount> for Token <identifier>                                               ;;
    ;;      X_UpdateCreateRoleAccount               Updates <create-role-account> for Token <identifier> with the new Account <recipient>               ;;
    ;;      X_UpdateRoleNFTCreate                   Updates |role-nft-create| for Token <identifier> on Account <account>                               ;;
    ;;==================AUXILIARY===================                                                                                                    ;;
    ;;      X_ChangeOwnership                       Auxiliary function required in the main function                                                    ;;
    ;;      X_Control                               Auxiliary function required in the main function                                                    ;;
    ;;      X_Pause                                 Auxiliary function required in the main function                                                    ;;
    ;;      X_Unpause                               Auxiliary function required in the main function                                                    ;;
    ;;      X_FreezeAccount                         Auxiliary function required in the main function                                                    ;;
    ;;      X_UnfreezeAccount                       Auxiliary function required in the main function                                                    ;;
    ;;      X_MoveCreateRole                        Auxiliary function required in the main function                                                    ;;
    ;;      X_SetAddQuantityRole                    Auxiliary function required in the main function                                                    ;;
    ;;      X_SetBurnRole                           Auxiliary function required in the main function                                                    ;;
    ;;      X_SetTransferRole                       Auxiliary function required in the main function                                                    ;;
    ;;      X_UnsetAddQuantityRole                  Auxiliary function required in the main function                                                    ;;
    ;;      X_UnsetBurnRole                         Auxiliary function required in the main function                                                    ;;
    ;;      X_UnsetTransferRole                     Auxiliary function required in the main function                                                    ;;
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
    ;;      UR_AccountMetaFungibleSupply|UR_AccountMetaFungibleUnit|UR_AccountMetaFungibleGuard
    ;;      UR_AccountMetaFungibleRoleNFTAQ|UR_AccountMetaFungibleRoleBurn|UR_AccountMetaFungibleRoleCreate
    ;;      UR_AccountMetaFungibleRoleTransfer|UR_AccountMetaFungibleFrozenState
    ;;
    ;;      
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
                    (unit-validation:bool (UV_ObjectListAsMetaFungibleList read-unit))
                )
                (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                (let 
                    (
                        (result 
                            (fold
                                (lambda 
                                    (acc:decimal item:object)
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
    )
    (defcap UR_AccountMetaFungibleUnit:[object] (identifier:string account:string)
        @doc "Returns Account <account> Meta Fungible <identifier> Unit"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (at "unit" (read DPMF-BalancesTable (concat [identifier BAR account]) ["unit"]))
    )
    (defun UR_AccountMetaFungibleGuard:guard (identifier:string account:string)
        @doc "Returns Account <account> Meta Fungible <identifier> Guard"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (at "guard" (read DPMF-BalancesTable (concat [identifier BAR account]) ["guard"]))
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
                    (unit-validation:bool (UV_ObjectListAsMetaFungibleList read-unit))
                )
                (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                (let 
                    (
                        (result 
                            (fold
                                (lambda 
                                    (acc:[decimal] item:object)
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
                    (unit-validation:bool (UV_ObjectListAsMetaFungibleList read-unit))
                )
                (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                (let 
                    (
                        (result 
                            (fold
                                (lambda 
                                    (acc:[integer] item:object)
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
                    (unit-validation:bool (UV_ObjectListAsMetaFungibleList read-unit))
                )
                (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                (let 
                    (
                        (result-balance:decimal
                            (fold
                                (lambda 
                                    (acc:decimal item:object)
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
                    (unit-validation:bool (UV_ObjectListAsMetaFungibleList read-unit))
                )
                (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                (let 
                    (
                        (result-meta-data
                            (fold
                                (lambda 
                                    (acc item:object)
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
    )
    ;;
    ;;==================TRUE-FUNGIBLE-INFO==========
    ;;
    ;;      UR_MetaFungibleOwner|UR_MetaFungibleKonto|UR_MetaFungibleName|UR_MetaFungibleTicker|UR_MetaFungibleDecimals
    ;;      UR_MetaFungibleCanChangeOwner|UR_MetaFungibleCanUpgrade|UR_MetaFungibleCanAddSpecialRole
    ;;      UR_MetaFungibleCanFreeze|UR_MetaFungibleCanWipe|UR_MetaFungibleCanPause|UR_MetaFungibleIsPaused
    ;;      UR_MetaFungibleSupply|UR_MetaFungibleCreateRoleAccount|UR_MetaFungibleTransferRoleAmount|UR_MetaFungibleNoncesUsed
    ;;
    (defun UR_MetaFungibleOwner:guard (identifier:string)
        @doc "Returns Meta Fungible <identifier> Owner"
        (UV_MetaFungibleIdentifier identifier)
        (at "owner" (read DPMF-PropertiesTable identifier ["owner"]))
    )
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
    ;;      UV_ObjectListAsMetaFungibleList|UV_ObjectAsMetaFungible|UV_ObjectAsNonceBalancePair
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
    (defun UV_ObjectListAsMetaFungibleList:bool (mflst:[object])
        @doc "Validates that a list of Objects contains Objects conform to the MetaFungible SCHEMA"
        (let 
            (
                (result 
                    (fold
                        (lambda 
                            (acc:bool item:object)
                            (let
                                (
                                    (iz-meta-fungible:bool (UV_ObjectAsMetaFungible item))
                                )
                                (enforce (= iz-meta-fungible true) "Item is not of Meta-Fungible type")
                                (and acc iz-meta-fungible)
                            )
                        )
                        true
                        mflst
                    )
                )
            )
            result
        )
    )
    (defun UV_ObjectAsMetaFungible:bool (obj:object)
        (let
            (
                (object-validation:bool (OUROBOROS.UV_Object obj (length MFKEYS) MFKEYS))
                (nonce-val:integer (at MFKEY1 obj))
                (balance-val:decimal (at MFKEY2 obj))
                (meta-data-val:[object] (at MFKEY3 obj))
            )
            (enforce (= object-validation true) "Object is of incorect format to be a MetaFungible")
            (enforce (= (typeof nonce-val) MFTYP1) "Invalid nonce type")
            (enforce (= (typeof balance-val) MFTYP2) "Invalid balance type")
            (enforce (= (typeof meta-data-val) MFTYP3) "Invalid meta-data type")
        )
    )
    (defun UV_ObjectAsNonceBalancePair:bool (obj:object)
        @doc "Validates that an Object is a pair of nonce and balances"
        (let*
            (
                (two-lst:[string] (take 2 MFKEYS))
                (object-validation:bool (OUROBOROS.UV_Object obj (length two-lst) two-lst))
                (nonce-val:decimal (at MFKEY1 obj))
                (balance-val:decimal (at MFKEY2 obj))
            )
            (enforce (= object-validation true) "Object is of incorect format to be a Nonce-Balance Pair")
            (enforce (= (typeof nonce-val) MFTYP1) "Invalid nonce type")
            (enforce (= (typeof balance-val) MFTYP2) "Invalid balance type")
        )
    )
    ;;
    ;;==================Composition=================
    ;;
    ;;      UC_ComposeMetaFungible
    ;;
    (defun UC_ComposeMetaFungible:object (nonce:integer balance:decimal meta-data:[object])
        @doc "Composes a MetaFungible object from <nonce>, <balance> and <meta-data>"
        {"nonce" : nonce, "balance": balance, "meta-data" : meta-data}
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
    ;;      C_Pause|C_Unpause|C_FreezeAccount|C_UnfreezeAccount
    ;;
    (defun C_ChangeOwnership (identifier:string new-owner:string  new-owner-guard:guard)
        @doc "Moves DPMF <identifier> Token Ownership to <new-owner> DPMF Account"

        (with-capability (DPMF_OWNERSHIP-CHANGE identifier new-owner)
            (update DPMF-PropertiesTable identifier
                {"owner"                            : new-owner-guard
                ,"owner-konto"                      : new-owner}
            )
            (OUROBOROS.X_IncrementNonce (UR_MetaFungibleKonto identifier))
        )
    )
    (defun C_Control
        (
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

        (with-capability (DPMF_CONTROL identifier)
            (update DPMF-PropertiesTable identifier
                {"can-change-owner"                 : can-change-owner
                ,"can-upgrade"                      : can-upgrade
                ,"can-add-special-role"             : can-add-special-role
                ,"can-freeze"                       : can-freeze
                ,"can-wipe"                         : can-wipe
                ,"can-pause"                        : can-pause
                ,"can-transfer-nft-create-role"     : can-transfer-nft-create-role}
            )
            (OUROBOROS.X_IncrementNonce (UR_MetaFungibleKonto identifier))
        ) 
    )
    (defun C_Pause (identifier:string)
        @doc "Pause MetaFungible <identifier>"

        (with-capability (DPMF_PAUSE identifier)
            (update DPMF-PropertiesTable identifier { "is-paused" : true})
            (OUROBOROS.X_IncrementNonce (UR_MetaFungibleKonto identifier))
        )
    )
    (defun C_Unpause (identifier:string)
        @doc "Unpause MetaFungible <identifier>"

        (with-capability (DPMF_UNPAUSE identifier)
            (update DPMF-PropertiesTable identifier { "is-paused" : false})
            (OUROBOROS.X_IncrementNonce (UR_MetaFungibleKonto identifier))
        )
    )
    (defun C_FreezeAccount (identifier:string account:string)
        @doc "Freeze MetaFungile <identifier> on DPMF Account <account>"

        (with-capability (DPMF_FREEZE_ACCOUNT identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account]) { "frozen" : true})
            (OUROBOROS.X_IncrementNonce (UR_MetaFungibleKonto identifier))
        )
    )
    (defun C_UnfreezeAccount (identifier:string account:string)
        @doc "Unfreeze MetaFungile <identifier> on DPMF Account <account>"

        (with-capability (DPMF_UNFREEZE_ACCOUNT identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account]) { "frozen" : false})
            (OUROBOROS.X_IncrementNonce (UR_MetaFungibleKonto identifier))
        )
    )
    ;;
    ;;==================SET========================= 
    ;;
    ;;      C_MoveCreateRole|C_SetAddQuantityRole
    ;;      C_SetBurnRole|C_SetTransferRole
    ;;
    (defun C_MoveCreateRole (identifier:string sender:string receiver:string receiver-guard:guard)
        @doc "Moves |role-nft-create| from <sender> to <receiver> DPMF Account for MetaFungible <identifier> \
            \ Only a single DPMF Account can have the |role-nft-create| \
            \ Afterwards the receiver DPMF Account can crete new Meta Fungibles \ 
            \ Fails if the target DPMF Account doesnt exist"

        (with-capability (DPMF_MOVE_CREATE-ROLE identifier sender receiver)
            (X_UpdateRoleNFTCreate identifier sender false)
            (X_UpdateCreateRoleAccount identifier receiver)
            ;;Since the DPMF-Properties Table is already updated with the receiver as create-role-account
            ;;When the receiver doesnt have a DPMF Account, attempting to deploy the DPMF Account for the receiver
            ;;Will executed the deployment with role-nft-create automatically set to true
            (C_DeployMetaFungibleAccount identifier receiver receiver-guard)
            ;;However, if the receiver already has a DPMF Account, a simple update is required.
            ;;This doesnt change anything if the DPMF account was freshly deployed anew from above.
            (X_UpdateRoleNFTCreate identifier receiver true)
            (OUROBOROS.X_IncrementNonce (UR_MetaFungibleKonto identifier))
        )
    )
    (defun C_SetAddQuantityRole (identifier:string account:string)
        @doc "Sets |role-nft-add-quantity| to true for MetaFungible <identifier> and DPMF Account <account> \
            \ Afterwards Account <account> can increase quantity for existing MetaFungibles"

        (with-capability (DPMF_SET_ADD-QUANTITY-ROLE identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account])
                {"role-nft-add-quantity" : true}
            )
            (OUROBOROS.X_IncrementNonce (UR_MetaFungibleKonto identifier))
        )
    )
    (defun C_SetBurnRole (identifier:string account:string)
        @doc "Sets |role-nft-burn| to true for MetaFungible <identifier> and DPMF Account <account> \
            \ Afterwards Account <account> can burn existing MetaFungibles"

        (with-capability (DPMF_SET_BURN-ROLE identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account])
                {"role-nft-burn" : true}
            )
            (OUROBOROS.X_IncrementNonce (UR_MetaFungibleKonto identifier))
        )
    )
    (defun C_SetTransferRole (identifier:string account:string)
        @doc "Sets |role-transfer| to true for MetaFungible <identifier> and DPMF Account <account> \
            \ If at least one DPMF Account has the |role-transfer|set to true, then all normal transfer are restricted \
            \ Transfer will only work towards DPMF Accounts with |role-trasnfer| true, \
            \ while these DPMF Accounts can transfer MetaFungibles unrestricted to any other DPMF Account"

        (with-capability (DPMF_SET_TRANSFER-ROLE identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account])
                {"role-transfer" : true}
            )
            (X_UpdateRoleTransferAmount identifier true)
            (OUROBOROS.X_IncrementNonce (UR_MetaFungibleKonto identifier))
        )
    )
    ;;
    ;;==================UNSET=======================
    ;;
    ;;      C_UnsetAddQuantityRole|C_UnsetBurnRole|C_UnsetTransferRole
    ;;
    (defun C_UnsetAddQuantityRole (identifier:string account:string)
        @doc "Sets |role-nft-add-quantity| to false for MetaFungible <identifier> and DPMF Account <account> \
            \ Afterwards Account <account> can no longer increase quantity for existing MetaFungibles"

        (with-capability (DPMF_UNSET_ADD-QUANTITY-ROLE identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account])
                {"role-nft-add-quantity" : false}
            )
            (OUROBOROS.X_IncrementNonce (UR_MetaFungibleKonto identifier))
        )
    )
    (defun C_UnsetBurnRole (identifier:string account:string)
        @doc "Sets |role-nft-burn| to false for MetaFungible <identifier> and DPMF Account <account> \
            \ Afterwards Account <account> can no longer burn existing MetaFungibles"

        (with-capability (DPMF_UNSET_BURN-ROLE identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account])
                {"role-nft-burn" : false}
            )
            (OUROBOROS.X_IncrementNonce (UR_MetaFungibleKonto identifier))
        )
    )
    (defun C_UnsetTransferRole (identifier:string account:string)
        @doc "Sets |role-transfer| to false for MetaFungible <identifier> and DPMF Account <account> \
            \ If at least one DPMF Account has the |role-transfer|set to true, then all normal transfer are restricted \
            \ Transfer will only work towards DPMF Accounts with |role-trasnfer| true, \
            \ while these DPMF Accounts can transfer MetaFungibles unrestricted to any other DPMF Account"

        (with-capability (DPMF_UNSET_TRANSFER-ROLE identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account])
                {"role-transfer" : false}
            )
            (X_UpdateRoleTransferAmount identifier false)
            (OUROBOROS.X_IncrementNonce (UR_MetaFungibleKonto identifier))
        )
    )
    ;;
    ;;==================CREATE====================== 
    ;;
    ;;      C_IssueMetaFungible|C_DeployMetaFungibleAccount
    ;;      C_Mint|C_Create|C_AddQuantity
    ;;
    (defun C_IssueMetaFungible:string 
        (
            account:string 
            owner:guard 
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
        (OUROBOROS.UV_DPTS-Name name)
        ;; Enforce Ticker is part of identifier variable
        (OUROBOROS.UV_DPTS-Decimals decimals)

        (with-capability (OUROBOROS.DPTS_INCREASE-NONCE)
            (let
                (
                    (identifier (OUROBOROS.UC_MakeIdentifier ticker))
                )
                ;; Add New Entries in the DPMF-PropertyTable
                ;; Since the Entry uses insert command, the KEY uniquness is ensured, since it will fail if key already exists.
                ;; Entry is initialised with "is-paused" set to off(false).
                ;; Entry is initialised with a supply of 0.0 (decimal)
                ;; Entry is initiated with "create-role-account" as the Issuer Account
                ;; Entry is initiated with o to role-transfer-amount, since no Account will transfer role upon creation.
                (insert DPMF-PropertiesTable identifier
                    {"owner"                : owner
                    ,"owner-konto"          : account
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
                ;;Makes a new DPMF Account for the Token Issuer.
                (C_DeployMetaFungibleAccount identifier account owner)
                ;;Increases DPTS nonce with Operation
                (OUROBOROS.X_IncrementNonce account)
                ;;Returns the unique DPMF Token Identifier
                identifier
            )
        )
        
    )
    (defun C_DeployMetaFungibleAccount (identifier:string account:string guard:guard)
        @doc "Creates a new DPMF Account for Metafungible <identifier> and Account <account> \
            \ If a DPMF Account already exists for <identifier> and <account>, it remains as is \
            \ \
            \ A Standard DPTS Account is also created, if one doesnt exist \
            \ If a DPTS Account exists, its type remains unchanged"
        (UV_MetaFungibleIdentifier identifier)
        (OUROBOROS.UV_DPTS-Account account)
        (OUROBOROS.UV_EnforceReserved account guard)

        ;;Automatically creates a Standard DPTS Account for <account> if one doesnt exists
        ;;If a DPTS Account exists for <account>, it remains as is
        (OUROBOROS.C_DeployStandardDPTSAccount account guard)

        ;;Creates new Entry in the DPMF-BalancesTable for <identifier>|<account>
        ;;If Entry exists, no changes are being done
        (let*
            (
                (create-role-account:string (UR_MetaFungibleCreateRoleAccount identifier))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF-BalancesTable (concat [identifier BAR account])
                { "unit" : [NEUTRAL_META-FUNGIBLE]
                , "guard" : guard
                , "role-nft-add-quantity" : false
                , "role-nft-burn" : false
                , "role-nft-create" : role-nft-create-boolean
                , "role-transfer" : false
                , "frozen" : false}
                { "unit" := u
                , "guard" := g
                , "role-nft-add-quantity" := rnaq
                , "role-nft-burn" := rb
                , "role-nft-create" := rnc
                , "role-transfer" := rt
                , "frozen" := f }
                (write DPMF-BalancesTable (concat [identifier BAR account])
                    { "unit"                        : u
                    , "guard"                       : g
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
    (defun C_Mint:integer (identifier:string account:string amount:decimal meta-data:[object])
        @doc "Mints <amount> <identifier> MetaFungibles with <meta-data> meta-data for DPMF Account <account> \
            \ Both |role-nft-create| and |role-nft-add-quantity| are required for minting"

        (let
            (
                (iz-sc:bool (OUROBOROS.UR_DPTS-AccountType account))
                (g:guard (UR_AccountMetaFungibleGuard identifier account))
                (new-nonce:integer (+ (UR_MetaFungibleNoncesUsed identifier) 1))
            )
            (if (= iz-sc true)
                (X_Mint identifier account amount meta-data)
                (with-capability (DPMF_MINT identifier account amount)
                    (X_CreateCore identifier account g meta-data)
                    (X_AddQuantityCore identifier new-nonce account amount)
                    (X_UpdateSupply identifier amount true)
                    (OUROBOROS.X_IncrementNonce account)
                )
            )
            new-nonce
        )
    )
    (defun C_Create:integer (identifier:string account:string meta-data:[object])
        @doc "Creates a 0.0 balance <identifier> MetaFungible with <meta-data> meta-data for DPMF Account <account>"

        (let
            (
                (iz-sc:bool (OUROBOROS.UR_DPTS-AccountType account))
                (g:guard (UR_AccountMetaFungibleGuard identifier account))
                (new-nonce:integer (+ (UR_MetaFungibleNoncesUsed identifier) 1))
            )
            (if (= iz-sc true)
                (X_Create identifier account meta-data)
                (with-capability (DPMF_CREATE identifier account)
                    (X_CreateCore identifier account g meta-data)
                    (OUROBOROS.X_IncrementNonce account)
                )
            )
            new-nonce
        )
    )
    (defun C_AddQuantity (identifier:string nonce:integer account:string amount:decimal)
        @doc "Adds <amount> quantity to existing Metafungible <identifer> and <nonce> for DPMF Account <account>"


        (let
            (
                (iz-sc:bool (OUROBOROS.UR_DPTS-AccountType account))
            )
            (if (= iz-sc true)
                (X_AddQuantity identifier nonce account amount)
                (with-capability (DPMF_ADD-QUANTITY identifier account amount)
                    (X_AddQuantityCore identifier nonce account amount)
                    (X_UpdateSupply identifier amount true)
                    (OUROBOROS.X_IncrementNonce account)
                )
            )
        )
    )
    ;;
    ;;==================DESTROY=====================
    ;;
    ;;      C_Burn|C_Wipe
    ;;
    (defun C_Burn (identifier:string nonce:integer account:string amount:decimal)
        @doc "Burns <amount> <identifier>-<nonce> MetaFungible on DPMF Account <account>"

        ;;IF DPTS Account is Smart, use X Auxiliary Function, requiring the Capability
        ;;Else (if DPTS Account is Normal), execute code granting the Capability
        (let
            (
                (iz-sc:bool (OUROBOROS.UR_DPTS-AccountType account))
            )
            (if (= iz-sc true)
                (X_Burn identifier nonce account amount)
                (with-capability (DPMF_BURN identifier nonce account amount)
                    (X_Debit identifier nonce account amount false)
                    (X_UpdateSupply identifier amount false)
                    (OUROBOROS.X_IncrementNonce account)
                )
            )
        )
    )
    (defun C_Wipe (identifier:string account:string)
        @doc "Wipes the whole supply of <identifier> MetaFungible of a frozen DPMF Account <account>"

        (let*
            (
                (nonce-lst:[integer] (UR_AccountMetaFungibleNonces identifier account))
                (balance-lst:[decimal] (UR_AccountMetaFungibleBalances identifier account))
                (balance-sum:decimal (fold (+) 0.0 balance-lst))
            )
            (with-capability (DPMF_WIPE identifier account balance-sum)
                (X_DebitMultiple identifier nonce-lst account balance-lst)
                (X_UpdateSupply identifier balance-sum false)
                (OUROBOROS.X_IncrementNonce (UR_MetaFungibleKonto identifier))
            )
        )
    )
    ;;
    ;;==================TRANSFER====================
    ;;
    ;;      C_TransferMetaFungible|C_TransferMetaFungibleAnew
    ;;
    (defun C_TransferMetaFungible (initiator:string identifier:string nonce:integer sender:string receiver:string amount:decimal)
        @doc "Transfers <identifier>-<nonce> Metafungible from <sender> to <receiver> DPMF Account\
            \ Fails if <receiver> DPMF Account doesnt exist"

        (with-capability (OUROBOROS.GAS_PATRON initiator)
            (let
                (
                    (gas-toggle:bool (OUROBOROS.UR_GasToggle))
                    (gas-id:string (OUROBOROS.UR_GasID))
                    (gas-amount:decimal OUROBOROS.GAS_SMALLEST)
                )
                (if (= gas-toggle false)
                    (with-capability (TRANSFER_DPMF identifier sender receiver amount false)
                        (X_TransferMetaFungible initiator identifier nonce sender receiver amount)
                    )
                    (with-capability (TRANSFER_DPMF_GAS initiator identifier sender receiver amount false gas-amount)
                        (OUROBOROS.X_CollectGAS initiator sender gas-amount)
                        (X_TransferMetaFungible initiator identifier nonce sender receiver amount)
                    )
                )
            )
        )
    )
    (defun C_TransferMetaFungibleAnew (initiator:string identifier:string nonce:integer sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "Same as |C_TransferMetaFungible| but with DPMF Account creation \
            \ This means <receiver> DPMF Account will be created by the transfer function"

        
        (with-capability (OUROBOROS.GAS_PATRON initiator)
            (let
                (
                    (gas-toggle:bool (OUROBOROS.UR_GasToggle))
                    (gas-id:string (OUROBOROS.UR_GasID))
                    (gas-amount:decimal OUROBOROS.GAS_SMALLEST)
                )
                (if (= gas-toggle false)
                    (with-capability (TRANSFER_DPMF identifier sender receiver amount false)
                        (X_TransferMetaFungibleAnew initiator identifier nonce sender receiver receiver-guard amount)
                    )
                    (with-capability (TRANSFER_DPMF_GAS initiator identifier sender receiver amount false gas-amount)
                        (OUROBOROS.X_CollectGAS initiator sender gas-amount)
                        (X_TransferMetaFungibleAnew initiator identifier nonce sender receiver receiver-guard amount)
                    )
                )
            )
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPMF: AUXILIARY FUNCTIONS             ;;
    ;;                                            ;;
    ;;==================TRANSFER====================
    ;;
    ;;      X_TransferMetaFungible|X_TransferMetaFungibleAnew
    ;;
    (defun X_TransferMetaFungible (initiator:string identifier:string nonce:integer sender:string receiver:string amount:decimal)
        @doc "Transfers <identifier>|<nonce> MetaFungible from <sender> to <receiver> DPMF Account without GAS"
        (require-capability (OUROBOROS.GAS_PATRON initiator))
        (require-capability (TRANSFER_DPMF identifier sender receiver amount false))
        (let
            (
                (rg:guard (UR_AccountMetaFungibleGuard identifier receiver))
                (current-nonce-meta-data (UR_AccountMetaFungibleMetaData identifier nonce sender))
            )
            (X_Debit identifier nonce sender amount false)
            (X_Credit identifier nonce current-nonce-meta-data receiver rg amount)
            (OUROBOROS.X_IncrementNonce sender)
        )
    )
    (defun X_TransferMetaFungibleAnew (initiator:string identifier:string nonce:integer sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "Similar to |X_TransferMetaFungible| but with DPMF Account creation"
        (require-capability (OUROBOROS.GAS_PATRON initiator))
        (require-capability (TRANSFER_DPMF identifier sender receiver amount false))
        (let
            (
                (current-nonce-meta-data (UR_AccountMetaFungibleMetaData identifier nonce sender))
            )
            (X_Debit identifier nonce sender amount false)
            (X_Credit identifier nonce current-nonce-meta-data receiver receiver-guard amount)
            (OUROBOROS.X_IncrementNonce sender)
        )
    )
    ;==================METHODIC-TRANSFER===========
    ;;
    ;;      XC_MethodicTransferMetaFungible|XC_MetodicTransferMetaFungibleAnew
    ;;      X_MethodicTransferMetaFungileWithGAS|X_MethodicTransferMetaFungible
    ;;      X_MethodicTransferMetaFungileAnewWithGAS|X_MethodicTransferMetaFungibleAnew
    ;;
    (defun XC_MethodicTransferMetaFungible (initiator:string identifier:string nonce:integer sender:string receiver:string transfer-amount:decimal)
        @doc "Methodic transfers <identifier>-<nonce> Metafungible from <sender> to <receiver> DPMF Account \
        \ Fails if <receiver> DPMF Account doesnt exist. \
        \ \
        \ Methodic Transfers cannot be called directly. They are to be used within external Modules \
        \ as transfer means when operating with Smart DPTS Account Types. \
        \ \
        \ This is because initiators can trigger transfers to be executed towards and from Smart DPTS Account types,\
        \ as described in the module's code, without them having the need to provide the Smart DPTS Accounts guard \
        \ \
        \ Designed to emulate MultiverX Smart-Contract payable Write-Points \
        \ Here the |payable Write-Points| are the external module functions that make use of this function \
        \ \
        \ Similar to |C_TransferMetaFungible| but methodic for Smart-DPTS Account type operation"

        (with-capability (OUROBOROS.GAS_PATRON initiator)
            (let
                (
                    (gas-toggle:bool (OUROBOROS.UR_GasToggle))
                    (gas-id:string (OUROBOROS.UR_GasID))
                    (gas-amount:decimal OUROBOROS.GAS_SMALLEST)
                )
                (if (= gas-toggle false)
                    ;;cap: (TRANSFER_DPMF identifier sender receiver transfer-amount true)
                    (X_MethodicTransferMetaFungible initiator identifier nonce sender receiver transfer-amount)
                    ;;cap: (TRANSFER_DPMF_GAS client identifier sender receiver transfer-amount true gas-amount)
                    (X_MethodicTransferMetaFungibleWithGAS initiator identifier nonce sender receiver transfer-amount gas-amount)
                )
            )
        )
    )
    (defun XC_MethodicTransferMetaFungibleAnew (initiator:string identifier:string nonce:integer sender:string receiver:string receiver-guard:guard transfer-amount:decimal)
        @doc "Similar to |C_TransferMetaFungibleAnew| but methodic for Smart-DPTS Account type operation"
        (with-capability (OUROBOROS.GAS_PATRON initiator)
            (let
                (
                    (gas-toggle:bool (OUROBOROS.UR_GasToggle))
                    (gas-id:string (OUROBOROS.UR_GasID))
                    (gas-amount:decimal OUROBOROS.GAS_SMALLEST)
                )
                (if (= gas-toggle false)
                    ;;cap: (TRANSFER_DPMF identifier sender receiver transfer-amount true)
                    (X_MethodicTransferMetaFungibleAnew initiator identifier nonce sender receiver receiver-guard transfer-amount)
                    ;;cap: (TRANSFER_DPMF_GAS initiator identifier sender receiver transfer-amount true gas-amount)
                    (X_MethodicTransferMetaFungibleAnewWithGAS initiator identifier nonce sender receiver receiver-guard transfer-amount gas-amount)
                )
            )
        )
    )
    (defun X_MethodicTransferMetaFungibleWithGAS (initiator:string identifier:string nonce:integer sender:string receiver:string transfer-amount:decimal  gas-amount:decimal)
        @doc "Similar to |X_MethodicTransferMetaFungible| but with GAS"
        (require-capability (OUROBOROS.GAS_PATRON initiator))
        (require-capability (TRANSFER_DPMF_GAS initiator identifier sender receiver transfer-amount true gas-amount))
        (OUROBOROS.X_CollectGAS initiator sender gas-amount)
        (X_MethodicTransferMetaFungible initiator identifier nonce sender receiver transfer-amount)
    )
    (defun X_MethodicTransferMetaFungible  (initiator:string identifier:string nonce:integer sender:string receiver:string transfer-amount:decimal)
        @doc "Similar to |X_TransferMetaFungible| but methodic for Smart-DPTS Account type operation"

        (require-capability (OUROBOROS.GAS_PATRON initiator))
        (require-capability (TRANSFER_DPMF identifier sender receiver transfer-amount true))
        (let
            (
                (rg:guard (UR_AccountMetaFungibleGuard identifier receiver))
                (current-nonce-meta-data (UR_AccountMetaFungibleMetaData identifier nonce sender))
            )
            (X_Debit identifier nonce sender transfer-amount false)
            (X_Credit identifier nonce current-nonce-meta-data receiver rg transfer-amount)
            (OUROBOROS.X_IncrementNonce sender)
        )
    )
    (defun X_MethodicTransferMetaFungibleAnewWithGAS (initiator:string identifier:string nonce:integer sender:string receiver:string receiver-guard:guard transfer-amount:decimal  gas-amount:decimal)
        @doc "Similar to |X_MethodicTransferMetaFungibleAnew| but with GAS"
        (require-capability (OUROBOROS.GAS_PATRON initiator))
        (require-capability (TRANSFER_DPMF_GAS initiator identifier sender receiver transfer-amount true gas-amount))
        (OUROBOROS.X_CollectGAS initiator sender gas-amount)
        (X_MethodicTransferMetaFungibleAnew initiator identifier nonce sender receiver receiver-guard transfer-amount)
    )
    (defun X_MethodicTransferMetaFungibleAnew  (initiator:string identifier:string nonce:integer sender:string receiver:string receiver-guard:guard transfer-amount:decimal)
        @doc "Similar to |X_TransferMetaFungibleAnew| but methodic for Smart-DPTS Account type operation"

        (require-capability (OUROBOROS.GAS_PATRON initiator))
        (require-capability (TRANSFER_DPMF identifier sender receiver transfer-amount true))
        (let
            (
                (current-nonce-meta-data (UR_AccountMetaFungibleMetaData identifier nonce sender))
            )
            (X_Debit identifier nonce sender transfer-amount false)
            (X_Credit identifier nonce current-nonce-meta-data receiver receiver-guard transfer-amount)
            (OUROBOROS.X_IncrementNonce sender)
        )
    )
    ;;----------------------------------------------
    ;;                                            ;;
    ;;      AUXILIARY FUNCTIONS                   ;;
    ;;                                            ;;
    ;;==================MINT BURN===================
    ;;
    ;;      X_Mint|X_Create|X_AddQuantity|X_Burn
    ;;
    (defun X_Mint (identifier:string account:string amount:decimal meta-data:[object])
        @doc "Mints <amount> <identifier> MetaFungibles with <meta-data> meta-data for DPMF Account <account> \
            \ as Auxiliary Function requiring the needed capability"

        (require-capability (DPMF_MINT identifier account amount))
        (let*
            (
                (g:guard (UR_AccountMetaFungibleGuard identifier account))
                (new-nonce:integer (+ (UR_MetaFungibleNoncesUsed identifier) 1))
            )
            (X_CreateCore identifier account g meta-data)
            (X_AddQuantityCore identifier new-nonce account amount)
            (X_UpdateSupply identifier amount true)
            (OUROBOROS.X_IncrementNonce account)
        )
    )
    (defun X_Create (identifier:string account:string meta-data:[object])
        @doc "Creates a 0.0 balance <identifier> MetaFungible with <meta-data> meta-data for DPMF Account <account> \
            \ as Auxiliary Function requiring the needed capability"

        (require-capability (DPMF_CREATE identifier account))
        (let*
            (
                (g:guard (UR_AccountMetaFungibleGuard identifier account))
            )
            (X_CreateCore identifier account g meta-data)
            (OUROBOROS.X_IncrementNonce account)
        )
    )
    (defun X_AddQuantity (identifier:string nonce:integer account:string amount:decimal)
        @doc "Adds <amount> quantity to existing Metafungible <identifer> and <nonce> for DPMF Account <account> \
            \ as Auxiliary Function requiring the needed capability"
        (require-capability (DPMF_ADD-QUANTITY identifier account amount))
        (X_AddQuantityCore identifier nonce account amount)
        (X_UpdateSupply identifier amount true)
        (OUROBOROS.X_IncrementNonce account)
    )
    (defun X_Burn (identifier:string nonce:integer account:string amount:decimal)
    @doc "Burns <amount> <identifier>-<nonce> MetaFungible on DPMF Account <account> \
        \ as Auxiliary Function requiring the needed capability"
        (require-capability (DPMF_BURN identifier nonce account amount))
        (X_Debit identifier nonce account amount false)
        (X_UpdateSupply identifier amount false)
        (OUROBOROS.X_IncrementNonce account)
    )
    ;;==================TRANSFER====================
    ;;
    ;;      X_MethodicTransferMetaFungible|X_MethodicTransferMetaFungibleAnew
    ;;

    ;;
    ;;==================CREDIT|DEBIT================ 
    ;;
    ;;      X_CreateCore|X_AddQuantityCore|X_Credit
    ;;      X_Debit|X_DebitPaired|X_DebitMultiple
    ;;
    (defun X_CreateCore (identifier:string account:string guard:guard meta-data:[object])
        @doc "Auxiliary Function that creates a MetaFungible \
            \ Returns as integer the nonce of the newly created MetaFungible"

        (let*
            (
                (new-nonce:integer (+ (UR_MetaFungibleNoncesUsed identifier) 1))
                (create-role-account:string (UR_MetaFungibleCreateRoleAccount identifier))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (require-capability (DPMF_CREATE identifier account))
            (with-default-read DPMF-BalancesTable (concat [identifier BAR account])
                { "unit" : [NEUTRAL_META-FUNGIBLE]
                , "guard" : guard
                , "role-nft-add-quantity" : false
                , "role-nft-burn" : false
                , "role-nft-create" : role-nft-create-boolean
                , "role-transfer" : false
                , "frozen" : false}
                { "unit" := u
                , "guard" := retg
                , "role-nft-add-quantity" := rnaq
                , "role-nft-burn" := rb
                , "role-nft-create" := rnc
                , "role-transfer" := rt
                , "frozen" := f}
                ; we don't want to overwrite an existing guard with the user-supplied one
                (enforce (= retg guard) "Account guards do not match !")
                (let*
                    (
                        (unit-validation:bool (UV_ObjectListAsMetaFungibleList u))
                        (meta-fungible:object (UC_ComposeMetaFungible new-nonce 0.0 meta-data))
                        (appended-meta-fungible:[object] (OUROBOROS.UC_AppendLast u meta-fungible))
                    )
                    (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                    ;; First, a new DPTS Account is created for Account <account>. 
                    ;; If DPTS Account exists for <account>, nothing is modified
                    (OUROBOROS.C_DeployStandardDPTSAccount account guard)
                    (write DPMF-BalancesTable (concat [identifier BAR account])
                        { "unit"                        : appended-meta-fungible
                        , "guard"                       : retg
                        , "role-nft-add-quantity"       : rnaq
                        , "role-nft-burn"               : rb
                        , "role-nft-create"             : rnc
                        , "role-transfer"               : rt
                        , "frozen"                      : f}
                    )
                )
                (X_IncrementNonce identifier)
            )
        )
    )
    (defun X_AddQuantityCore (identifier:string nonce:integer account:string amount:decimal)
        @doc "Auxiliary Function that adds quantity for an existing Metafungible \
            \ Assumes <identifier> and <nonce> exist on DPMF Account"

        (require-capability (DPMF_ADD-QUANTITY identifier account amount))

        (with-read DPMF-BalancesTable (concat [identifier BAR account])
            { "unit" := unit }
            (let*
                (
                    (unit-validation:bool (UV_ObjectListAsMetaFungibleList unit))
                    (current-nonce-balance:decimal (UR_AccountMetaFungibleBalance identifier nonce account))
                    (current-nonce-meta-data (UR_AccountMetaFungibleMetaData identifier nonce account))
                    (updated-balance:decimal (+ current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object (UC_ComposeMetaFungible nonce current-nonce-balance current-nonce-meta-data))
                    (updated-meta-fungible:object (UC_ComposeMetaFungible nonce updated-balance current-nonce-meta-data))
                    (processed-unit:[object] (OUROBOROS.UC_ReplaceItem unit meta-fungible-to-be-replaced updated-meta-fungible))
                )
                (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                (update DPMF-BalancesTable (concat [identifier BAR account])
                    {"unit" : processed-unit}    
                )
            )
        )
    )
    (defun X_Credit (identifier:string nonce:integer meta-data:[object] account:string account-guard:guard amount:decimal)
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
                , "guard" : account-guard
                , "role-nft-add-quantity" : false
                , "role-nft-burn" : false
                , "role-nft-create" : role-nft-create-boolean
                , "role-transfer" : false
                , "frozen" : false}
                { "unit" := unit
                , "guard" := retg
                , "role-nft-add-quantity" := rnaq
                , "role-nft-burn" := rb
                , "role-nft-create" := rnc
                , "role-transfer" := rt
                , "frozen" := f}
                ; we don't want to overwrite an existing guard with the user-supplied one
                (enforce (= retg account-guard) "Account guards do not match !")
                ;; OLD is-new variable:
                ;; (is-new:bool (if (= unit [NEGATIVE_META-FUNGIBLE]) (OUROBOROS.UV_EnforceReserved account account-guard) false))
                (let*
                    (
                        (next-unit (if (= unit [NEGATIVE_META-FUNGIBLE]) [NEUTRAL_META-FUNGIBLE] unit))
                        (unit-validation:bool (UV_ObjectListAsMetaFungibleList next-unit))
                        (is-new:bool (if (= unit [NEGATIVE_META-FUNGIBLE]) true false))
                        (current-nonce-balance:decimal (UR_AccountMetaFungibleBalance identifier nonce account))
                        (credited-balance:decimal (+ current-nonce-balance amount))
                        (present-meta-fungible:object (UC_ComposeMetaFungible nonce current-nonce-balance meta-data))
                        (credited-meta-fungible:object (UC_ComposeMetaFungible nonce credited-balance meta-data))
                        (processed-unit-with-replace:[object] (OUROBOROS.UC_ReplaceItem next-unit present-meta-fungible credited-meta-fungible))
                        (processed-unit-with-append:[object] (OUROBOROS.UC_AppendLast next-unit credited-meta-fungible))
                    )
                    (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                    (enforce (> amount 0.0) "Crediting amount must be greater than zero")
                    ;; First, a new DPTS Account is created for Account <account>. 
                    ;; If DPTS Account exists for <account>, nothing is modified
                    (OUROBOROS.C_DeployStandardDPTSAccount account account-guard)
                    ;; Make the Write in the account
                    (if (= current-nonce-balance 0.0)
                        ;;Remove Metafungible
                        (write DPMF-BalancesTable (concat [identifier BAR account])
                            { "unit"                        : processed-unit-with-append
                            , "guard"                       : retg
                            , "role-nft-add-quantity"       : (if is-new false rnaq)
                            , "role-nft-burn"               : (if is-new false rb)
                            , "role-nft-create"             : (if is-new role-nft-create-boolean rnc)
                            , "role-transfer"               : (if is-new false rt)
                            , "frozen"                      : (if is-new false f)}
                        )
                        ;;Replace Metafungible
                        (write DPMF-BalancesTable (concat [identifier BAR account])
                            { "unit"                        : processed-unit-with-replace
                            , "guard"                       : retg
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
            ,"guard"                                := g
            ,"role-nft-add-quantity"                := rnaq
            ,"role-nft-burn"                        := rnb
            ,"role-nft-create"                      := rnc
            ,"role-transfer"                        := rt
            ,"frozen"                               := f}
            (let*
                (
                    (unit-validation:bool (UV_ObjectListAsMetaFungibleList unit))
                    (current-nonce-balance:decimal (UR_AccountMetaFungibleBalance identifier nonce account))
                    (current-nonce-meta-data (UR_AccountMetaFungibleMetaData identifier nonce account))
                    (debited-balance:decimal (- current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object (UC_ComposeMetaFungible nonce current-nonce-balance current-nonce-meta-data))
                    (debited-meta-fungible:object (UC_ComposeMetaFungible nonce debited-balance current-nonce-meta-data))
                    (processed-unit-with-remove:[object] (OUROBOROS.UC_RemoveItem unit meta-fungible-to-be-replaced))
                    (processed-unit-with-replace:[object] (OUROBOROS.UC_ReplaceItem unit meta-fungible-to-be-replaced debited-meta-fungible))
                )
                (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                (enforce (>= debited-balance 0.0) "Insufficient Funds for debiting")
                (if (= debited-balance 0.0)
                    ;;Remove Metafungible
                    (update DPMF-BalancesTable (concat [identifier BAR account])
                        {"unit"                     : processed-unit-with-remove
                        ,"guard"                    : g
                        ,"role-nft-add-quantity"    : rnaq
                        ,"role-nft-burn"            : rnb
                        ,"role-nft-create"          : rnc
                        ,"role-transfer"            : rt
                        ,"frozen"                   : f}
                    )
                    ;;Replace Metafungible
                    (update DPMF-BalancesTable (concat [identifier BAR account])
                        {"unit"                     : processed-unit-with-replace
                        ,"guard"                    : g
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
    (defun X_DebitPaired (identifier:string account:string nonce-balance-obj:object)
        @doc "Helper Function designed for making |X_DebitMultiple| possible, which is needed for Wiping \
            \ Same a |X_Debit| but the nonce and balance are composed into a singular <nonce-balance-obj> object \
            \ Within |X_DebitPaired|, |X_Debit| is called using true <admin> boolean \
            \ which is needed when MetaFungible debitation is executed by DPMF Owner (admin) on another DPMF Account \
            \ as part of the Wiping Process, where the DPMF Account key|guard isnt required"

        (let
            (
                (iz-nonce-balance-pair:bool (UV_ObjectAsNonceBalancePair nonce-balance-obj))
            )
            (enforce (= iz-nonce-balance-pair true) "Object is not of Nonce Balance Pair")
            (let
                (
                    (nonce:integer (at "nonce" nonce-balance-obj))
                    (balance:decimal (at "balance" nonce-balance-obj))
                )
                (X_Debit identifier nonce account balance true)
            )
        )
    )
    (defun X_DebitMultiple (identifier:string nonce-lst:[integer] account:string balance-lst:[decimal])
        @doc "Auxiliary Function needed for Wiping \
            \ Executes |X_Debit| on a list of nonces and balances via its helper Function |X_DebitPaired|"

        (let
            (
                (nonce-balance-obj-lst:[object] (zip (lambda (x:integer y:decimal) { "nonce": x, "balance": y }) nonce-lst balance-lst))
            )
            (map (lambda (x:object) (X_DebitPaired identifier account x)) nonce-balance-obj-lst)
        )
    )
    ;;
    ;;==================UPDATE======================
    ;;
    ;;      X_UpdateSupply|X_IncrementNonce
    ;;      X_UpdateRoleTransferAmount|X_UpdateCreateRoleAccount|X_UpdateRoleNFTCreate
    ;;
    (defun X_UpdateSupply (identifier:string amount:decimal direction:bool)
        @doc "Updates <identifier> MetaFungible supply. Boolean <direction> used for increase|decrease"

        (require-capability (DPMF_UPDATE_SUPPLY identifier amount))
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
        (require-capability (DPMF_UPDATE-ROLE-TRANSFER-AMOUNT identifier))
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
    (defun X_UpdateCreateRoleAccount (identifier:string recipient:string)
        @doc "Updates <create-role-account> for Token <identifier> with the new Account <recipient>"
        (require-capability (DPMF_UPDATE-CREATE-ROLE-ACCOUNT identifier recipient))
        (update DPMF-PropertiesTable identifier
            {"create-role-account" : recipient}
        )
    )
    (defun X_UpdateRoleNFTCreate (identifier:string account:string update:bool)
        @doc "Updates |role-nft-create| for Token <identifier> on Account <account>"
        (require-capability (DPMF_UPDATE-ROLE-NFT-CREATE identifier account))
        (update DPMF-BalancesTable (concat [identifier BAR account])
                {"role-nft-create" : update}
        )
    )
)

(create-table DPMF-PropertiesTable)
(create-table DPMF-BalancesTable)