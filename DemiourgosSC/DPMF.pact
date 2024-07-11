(module DPMF GOVERNANCE
    @doc "Core_DPMF is the Demiourgos.Holdings Module for the management of DPMF Tokens \
    \ DPMF-Tokens = Demiourgos Pact Meta Fungible Tokens \
    \ DPMF-Tokens mimic the functionality of the Meta-ESDT Token introduced by MultiversX (former Elrond) Blockchain"


    ;;CONSTANTS
    ;;Smart-Contract Key and Name Definitions
    (defconst SC_KEY "free.DH-Master-Keyset")
    (defconst SC_NAME "Demiourgos-Pact-Meta-Fungible")
    (defconst BAR DPTS.BAR)

    ;;Schema Definitions
    ;;Demiourgos Pact META Fungible Token Standard - DPMF
    (defschema DPMF-PropertiesSchema
        @doc "Schema for DPMF Token (MEta Fungibles) Properties \
        \ Key for Table is DPMF Token Identifier. This ensure a unique entry per Token Identifier"

        owner:guard                         ;;Guard of the Token Owner, Account that created the DPMF Token
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
    (defschema MetaFungible
        @doc "Schema that Stores MetaFungible Data \
        \ The MetaFungible Schema is not used directly anywhere, but rather indirectly \
        \ Through Object Validations such that they fit this schema \
        \ As such, it it written here for displaying purposes"

        nonce:integer
        balance:decimal
        meta-data:object
    )
    ;;TABLES Definitions
    (deftable DPMF-PropertiesTable:{DPMF-PropertiesSchema})
    (deftable DPMF-BalancesTable:{DPMF-BalanceSchema})
    ;;Neutral MetaFungible Definition
    (defconst NEUTRAL_META-FUNGIBLE
        { "nonce": 0
        , "balance": 0.0
        , "meta-data": {} }
    )

    ;;
    ;;=======================================================================================================
    ;;
    ;;Governance and Administration CAPABILITIES
    ;;
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
        \ Set to DPMF_ADMIN so that only Module Key can enact an upgrade"
        false
    )
    (defcap DPMF_ADMIN ()
        (enforce-guard (keyset-ref-guard SC_KEY))
    )
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      CAPABILITIES                                                                                                                                ;;
    ;;                                                                                                                                                  ;;
    ;;      BASIC                                   Basic Capabilities represent singular capability Definitions                                        ;;
    ;;      COMPOSED                                Composed Capabilities are made of one or multiple Basic Capabilities                                ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      BASIC                                                                                                                                       ;;
    ;;                                                                                                                                                  ;;
    ;;======DPMF-PROPERTIES-TABLE-MANAGEMENT========                                                                                                    ;;
    ;;      DPMF_OWNER                              Enforces DPMF Token Ownership                                                                       ;;
    ;;      DPMF_CAN-UPGRADE_ON                     Enforces DPMF Token upgrade-ability                                                                 ;;
    ;;      DPMF_CAN-ADD-SPECIAL-ROLE_ON            Enforces Token Property as true                                                                     ;;
    ;;      DPMF_CAN-FREEZE_ON                      Enforces Token Property as true                                                                     ;;
    ;;      DPMF_CAN-WIPE_ON                        Enforces Token Property as true                                                                     ;;
    ;;      DPMF_CAN-PAUSE_ON                       Enforces Token Property as true                                                                     ;;
    ;;      DPMF_IS-PAUSED_ON                       Enforces that the DPMF Token is paused                                                              ;;
    ;;      DPMF_IS-PAUSED_OF                       Enforces that the DPMF Token is not paused                                                          ;;
    ;;      DPMF_CAN-TRANSFER-NFT-CREATE-ROLE_ON    Enforces DPMF Token Property as true                                                                ;;
    ;;      UPDATE_DPMF_SUPPLY                      Capability required to update DPMF Supply                                                           ;;
    ;;      DPMF_INCREASE_NONCE                     Capability required to update DPMF Nonce in the DPMF-PropertiesTable                                ;;
    ;;======DPMF-BALANCES-TABLE-MANAGEMENT==========                                                                                                    ;;
    ;;      DPMF_ACCOUNT_OWNER                      Enforces DPMF Account Ownership                                                                     ;;
    ;;      DPMF_ACCOUNT_ADD-QUANTITY_ON            Enforces DPMF Account has add-quantity role on                                                      ;;
    ;;      DPMF_ACCOUNT_ADD-QUANTITY_OFF           Enforces DPMF Account has add-quantity role off                                                     ;;
    ;;      DPMF_ACCOUNT_BURN_ON                    Enforces DPMF Account has burn role on                                                              ;;
    ;;      DPMF_ACCOUNT_BURN_OFF                   Enforces DPMF Account has burn role off                                                             ;;
    ;;      DPMF_ACCOUNT_CREATE_ON                  Enforces DPMF Account has create role on                                                            ;;
    ;;      DPMF_ACCOUNT_CREATE_OFF                 Enforces DPMF Account has create role off                                                           ;;
    ;;      DPMF_ACCOUNT_TRANSFER_ON                Enforces DPMF Account has transfer role on                                                          ;;
    ;;      DPMF_ACCOUNT_TRANSFER_OFF               Enforces DPMF Account has transfer role off                                                         ;;
    ;;      DPMF_ACCOUNT_TRANSFER_DEFAULT           Transfer role capabilty required for uncreated receivers                                            ;;
    ;;      DPMF_ACCOUNT_FREEZE_ON                  Enforces DPMF Account is frozen                                                                     ;;
    ;;      DPMF_ACCOUNT_FREEZE_OFF                 Enforces DPMF Account is not frozen                                                                 ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      COMPOSED                                                                                                                                    ;;
    ;;                                                                                                                                                  ;;
    ;;==================CONTROL=====================                                                                                                    ;;
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
    ;;==================UNSET========================                                                                                                   ;;
    ;;      DPMF_UNSET_ADD-QUANTITY-ROLE            Capability required to Unset Add-Quantity Role for DPMF Account                                     ;;
    ;;      DPMF_UNSET_BURN-ROLE                    Capability required to Unset Burn Role for a DPMF Account                                           ;;
    ;;      DPMF_UNSET_TRANSFER-ROLE                Capability required to Unset Transfer Role for a DPMF Account                                       ;;
    ;;==================CREATE=======================                                                                                                   ;;
    ;;      DPMF_MINT                               Capability required to mint a DPMF Token                                                            ;;
    ;;      DPMF_CREATE                             Capability that allows creation of a new MetaFungilbe nonce                                         ;;
    ;;      DPMF_CREATE_SMART                       Capability that allows creation of a new MetaFungilbe nonce by a Smart DPTS Account                 ;;
    ;;      DPMF_CREATE_STANDARD                    Capability that allows creation of a new MetaFungilbe nonce by a Standard DPTS Account              ;;
    ;;      DPMF_ADD-QUANTITY                       Capability required to add-quantity for a DPMF Token                                                ;;
    ;;      DPMF_ADD-QUANTITY_SMART                 Capability required to add-quantity for a DPMF Token by a Smart DPTS Account                        ;;
    ;;      DPMF_ADD-QUANTITY_STANDARD              Capability required to add-quantity for a DPMF Token by a Standard DPTS Account                     ;;
    ;;==================DESTROY======================                                                                                                   ;;
    ;;      DPMF_BURN                               Capability required to burn a DPMF Token                                                            ;;
    ;;      DPMF_BURN_SMART                         Capability required to burn a DPMF Token by a Smart DPTS Account                                    ;;
    ;;      DPMF_BURN_STANDARD                      Capability required to burn a DPMF Token by a Standard DPTS Account                                 ;;
    ;;      DPMF_WIPE                               Capability required to Wipe all DPMF Tokens from a DPMF account                                     ;;
    ;;=================CORE==========================                                                                                                   ;;
    ;;      CREDIT_DPMF                             Capability to perform crediting operations with DPMF Tokens                                         ;;
    ;;      DEBIT_DPMF                              Capability to perform debiting operations on Normal DPTS Account types with DPMF Tokens             ;;
    ;;      DEBIT_DPMF_SC                           Capability to perform debiting operations on Smart(Contract) DPTS Account types with DPMF Tokens    ;;
    ;;      TRANSFER_DPMF                           Capability for transfer between 2 DPTS accounts for a specific DPMF Token identifier                ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;

    ;;======DPMF-PROPERTIES-TABLE-MANAGEMENT========
    (defcap DPMF_OWNER (identifier:string)
        @doc "Enforces DPMF Token Ownership"
        (with-read DPMF-PropertiesTable identifier
            { "owner" := owg }
            (enforce-guard owg)
        )
    )
    (defcap DPMF_CAN-UPGRADE_ON (identifier:string)
        @doc "Enforces DPMF Token upgrade-ability"
        (with-read DPMF-PropertiesTable identifier
            { "can-upgrade" := cu }
            (enforce (= cu true) (format "DPMF Token {} properties cannot be upgraded" [identifier]))
        )
    )
    (defcap DPMF_CAN-ADD-SPECIAL-ROLE_ON (identifier:string)
        @doc "Enforces DPMF Token Property as true"
        (with-read DPMF-PropertiesTable identifier
            { "can-add-special-role" := casr }
            (enforce (= casr true) (format "For DPMF Token {} no special roles can be added" [identifier]))
        )
    )
    (defcap DPMF_CAN-FREEZE_ON (identifier:string)
        @doc "Enforces DPMF Token Property as true"
        (with-read DPMF-PropertiesTable identifier
            { "can-freeze" := cf }
            (enforce (= cf true) (format "DPMF Token {} cannot be freezed" [identifier]))
        )
    )
    (defcap DPMF_CAN-WIPE_ON (identifier:string)
        @doc "Enforces DPMF Token Property as true"
        (with-read DPMF-PropertiesTable identifier
            { "can-wipe" := cw }
            (enforce (= cw true) (format "DPMF Token {} cannot be wiped" [identifier]))
        )
    )
    (defcap DPMF_CAN-PAUSE_ON (identifier:string)
        @doc "Enforces DPMF Token Property as true"
        (with-read DPMF-PropertiesTable identifier
            { "can-pause" := cp }
            (enforce (= cp true) (format "DPMF Token {} cannot be paused" [identifier]))
        )
    )
    (defcap DPMF_IS-PAUSED_ON (identifier:string)
        @doc "Enforces that the DPMF Token is paused"
        (with-read DPMF-PropertiesTable identifier
            { "is-paused" := ip }
            (enforce (= ip true) (format "DPMF Token {} is already unpaused" [identifier]))
        )
    )
    (defcap DPMF_IS-PAUSED_OFF (identifier:string)
        @doc "Enforces that the DPMF Token is not paused"
        (with-read DPMF-PropertiesTable identifier
            { "is-paused" := ip }
            (enforce (= ip false) (format "DPMF Token {} is already paused" [identifier]))
        )
    )
    (defcap DPMF_CAN-TRANSFER-NFT-CREATE-ROLE_ON (identifier:string)
        @doc "Enforces DPMF Token Property as true"
        (with-read DPMF-PropertiesTable identifier
            { "can-transfer-nft-create-role" := ctncr }
            (enforce (= ctncr true) (format "DPMF Token {} cannot have its creation role transfered" [identifier]))
        )
    )
    (defcap UPDATE_DPMF_SUPPLY (identifier:string amount:decimal)
        @doc "Capability required to update DPMF Supply"
        (U_ValidateMetaFungibleAmount identifier amount)
    )
    (defcap DPMF_INCREASE_NONCE ()
        @doc "Capability required to update DPMF Nonce in the DPMF-PropertiesTable"
        true
    )
    ;;======DPMF-BALANCES-TABLE-MANAGEMENT==========
    (defcap DPMF_ACCOUNT_OWNER (identifier:string account:string)
        @doc "Enforces DPMF Account Ownership"
        (with-read DPMF-BalancesTable (concat [identifier BAR account])
            { "guard" := g }
            (enforce-guard g)
        )
    )
    (defcap DPMF_ACCOUNT_ADD-QUANTITY_ON (identifier:string account:string)
        @doc "Enforces DPMF Account has add-quantity role on"
        (with-read DPMF-BalancesTable (concat [identifier BAR account])
            { "role-nft-add-quantity" := rnaq }
            (enforce (= rnaq true) (format "DPMF {} Account isnt allowed to add quantity" [account]))
        )
    )
    (defcap DPMF_ACCOUNT_ADD-QUANTITY_OFF (identifier:string account:string)
        @doc "Enforces DPMF Account has add-quantity role off"
        (with-read DPMF-BalancesTable (concat [identifier BAR account])
            { "role-nft-add-quantity" := rnaq }
            (enforce (= rnaq false) (format "DPMF {} Account is allowed to add quantity" [account]))
        )
    )
    (defcap DPMF_ACCOUNT_BURN_ON (identifier:string account:string)
        @doc "Enforces DPMF Account has burn role on"
        (with-read DPMF-BalancesTable (concat [identifier BAR account])
            { "role-nft-burn" := rnb }
            (enforce (= rnb true) (format "DPMF {} Account isnt allowed to burn" [account]))
        )
    )
    (defcap DPMF_ACCOUNT_BURN_OFF (identifier:string account:string)
        @doc "Enforces DPMF Account has burn role off"
        (with-read DPMF-BalancesTable (concat [identifier BAR account])
            { "role-nft-burn" := rnb }
            (enforce (= rnb false) (format "DPMF {} Account is allowed to burn" [account]))
        )
    )
    (defcap DPMF_ACCOUNT_CREATE_ON (identifier:string account:string)
        @doc "Enforces DPMF Account has create role on"
        (with-read DPMF-BalancesTable (concat [identifier BAR account])
            { "role-nft-create" := rnc }
            (enforce (= rnc true) (format "DPMF {} Account isnt allowed to create {} Meta-Fungible" [account identifier]))
        )
    )
    (defcap DPMF_ACCOUNT_CREATE_OFF (identifier:string account:string)
        @doc "Enforces DPMF Account has create role off"
        (with-read DPMF-BalancesTable (concat [identifier BAR account])
            { "role-nft-create" := rnc }
            (enforce (= rnc false) (format "DPMF {} Account is allowed to create {} Meta-Fungible" [account identifier]))
        )
    )
    (defcap DPMF_ACCOUNT_TRANSFER_ON (identifier:string account:string)
        @doc "Enforces DPMF Account has transfer role on"
        (with-default-read DPMF-BalancesTable (concat [identifier BAR account])
            { "role-transfer" : false }
            { "role-transfer" := rt }
            (enforce (= rt true) (format "Transfer Role is not valid for DPMF {} Account" [account]))
        )
    )
    (defcap DPMF_ACCOUNT_TRANSFER_OFF (identifier:string account:string)
        @doc "Enforces DPMF Account has transfer role on"
        (with-read DPMF-BalancesTable (concat [identifier BAR account])
            { "role-transfer" := rt }
            (enforce (= rt false) (format "DPMF {} Account has transfer role" [account]))
        )
    )
    (defcap DPMF_ACCOUNT_TRANSFER_DEFAULT ()
        @doc "Transfer role capabilty required for uncreated receivers"
        true
    )
    (defcap DPMF_ACCOUNT_FREEZE_ON (identifier:string account:string)
        @doc "Enforces DPMF Account is frozen"
        (with-read DPMF-BalancesTable (concat [identifier BAR account])
            { "frozen" := f }
            (enforce (= f true) (format "DPMF {} Account isnt frozen" [account]))
        )
    )
    (defcap DPMF_ACCOUNT_FREEZE_OFF (identifier:string account:string)
        @doc "Enforces DPMF Account is not frozen"
        (with-default-read DPMF-BalancesTable (concat [identifier BAR account])
            { "frozen" : false}
            { "frozen" := f }
            (enforce (= f false) (format "DPMF {} Account is frozen" [account]))
        )
    )
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      COMPOSED
    ;;
    ;;==================CONTROL===================== 
    (defcap DPMF_CONTROL (identifier:string)
        @doc "Capability required for managing DPMF Properties"
        (U_ValidateMetaFungibleIdentifier identifier)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-UPGRADE_ON identifier))
    )
    (defcap DPMF_PAUSE (identifier:string)
        @doc "Capability required to Pause a DPMF Token"
        (U_ValidateMetaFungibleIdentifier identifier)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-PAUSE_ON identifier))
        (compose-capability (DPMF_IS-PAUSED_OFF identifier))
    )
    (defcap DPMF_UNPAUSE (identifier:string)
        @doc "Capability required to Unpause a DPMF Token"
        (U_ValidateMetaFungibleIdentifier identifier)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-PAUSE_ON identifier))
        (compose-capability (DPMF_IS-PAUSED_ON identifier))
    )
    (defcap DPMF_FREEZE_ACCOUNT (identifier:string account:string)
        @doc "Capability required to Freeze a DPMF Account"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-FREEZE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_FREEZE_OFF identifier account))
    )
    (defcap DPMF_UNFREEZE_ACCOUNT (identifier:string account:string)
        @doc "Capability required to Unfreeze a DPMF Account"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-FREEZE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_FREEZE_ON identifier account))
    )
    ;;==================SET=========================
    (defcap DPMF_SET_ADD-QUANTITY-ROLE (identifier:string account:string)
        @doc "Capability required to Set Add-Quantity Role for DPMF Account"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_ADD-QUANTITY_OFF identifier account))
    )
    (defcap DPMF_SET_BURN-ROLE (identifier:string account:string)
        @doc "Capability required to Set Burn Role for DPMF Account"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_BURN_OFF identifier account))
    )
    (defcap DPMF_SET_TRANSFER-ROLE (identifier:string account:string)
        @doc "Capability required to Set Transfer Role for DPMF Account"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_TRANSFER_OFF identifier account))
    )
    (defcap DPMF_MOVE_CREATE-ROLE (identifier:string sender:string receiver:string)
        @doc "Capability required to Change Create Role to another DPMF Account"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateSenderReceiver sender receiver)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-TRANSFER-NFT-CREATE-ROLE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_CREATE_ON identifier sender))
        (compose-capability (DPMF_ACCOUNT_CREATE_OFF identifier receiver))
    )
    ;;==================UNSET========================
    (defcap DPMF_UNSET_ADD-QUANTITY-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Add-Quantity Role for DPMF Account"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_ACCOUNT_ADD-QUANTITY_ON identifier account))
    )
    (defcap DPMF_UNSET_BURN-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Burn Role for DPMF Account"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_ACCOUNT_BURN_ON identifier account))
    )
    (defcap DPMF_UNSET_TRANSFER-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Transfer Role for DPMF Account"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_ACCOUNT_TRANSFER_ON identifier account))
    )
    ;;==================CREATE=======================
    (defcap DPMF_MINT (identifier:string account:string amount:decimal)
        @doc "Capability required to mint a DPMF Token \
        \ Smart-Contract Account type doesnt require their guard|key"
        (U_ValidateMetaFungibleAmount identifier amount)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPMF_CREATE identifier account))
        (compose-capability (DPMF_ADD-QUANTITY identifier account amount))
    )
    (defcap DPMF_CREATE (identifier:string account:string)
        @doc "Capability that allows creation of a new MetaFungilbe nonce \
        \ This creates a MetaFungible with zero quantity"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (let
            (
                (iz-sc:bool (at 0 (DPTS.U_GetDPTSAccountType account)))
            )
            (if (= iz-sc true)
                (compose-capability (DPMF_CREATE_SMART identifier account))
                (compose-capability (DPMF_CREATE_STANDARD identifier account))
            )
        )
        (compose-capability (DPMF_ACCOUNT_CREATE_ON identifier account))
    )
    (defcap DPMF_CREATE_SMART (identifier:string account:string)
        @doc "Capability that allows creation of a new MetaFungilbe nonce by a Smart DPTS Account"
        (compose-capability (DPMF_ACCOUNT_CREATE_ON identifier account))
        (compose-capability (DPMF_INCREASE_NONCE))
    )
    (defcap DPMF_CREATE_STANDARD (identifier:string account:string)
        @doc "Capability that allows creation of a new MetaFungilbe nonce by a Standard DPTS Account"
        (compose-capability (DPMF_ACCOUNT_OWNER identifier account))
        (compose-capability (DPMF_ACCOUNT_CREATE_ON identifier account))
        (compose-capability (DPMF_INCREASE_NONCE))
    )
    (defcap DPMF_ADD-QUANTITY (identifier:string account:string amount:decimal)
        @doc "Capability required to add-quantity for a DPMF Token \
        \ Smart-Contract Account type doesnt require their guard|key"
        (U_ValidateMetaFungibleAmount identifier amount)
        (DPTS.U_ValidateAccount account)
        (let
            (
                (iz-sc:bool (at 0 (DPTS.U_GetDPTSAccountType account)))
            )
            (if (= iz-sc true)
                (compose-capability (DPMF_ADD-QUANTITY_SMART identifier account amount))
                (compose-capability (DPMF_ADD-QUANTITY_STANDARD identifier account amount))
            )
        )
    )
    (defcap DPMF_ADD-QUANTITY_SMART (identifier:string account:string amount:decimal)
        @doc "Capability required to add-quantity for a DPMF Token by a Smart DPTS Account"
        (compose-capability (DPMF_ACCOUNT_ADD-QUANTITY_ON identifier account))
        (compose-capability (CREDIT_DPMF))
        (compose-capability (UPDATE_DPMF_SUPPLY identifier amount))
    )
    (defcap DPMF_ADD-QUANTITY_STANDARD (identifier:string account:string amount:decimal)
        @doc "Capability required to add-quantity for a DPMF Token by a Standard DPTS Account"
        (compose-capability (DPMF_ACCOUNT_OWNER identifier account))
        (compose-capability (DPMF_ACCOUNT_ADD-QUANTITY_ON identifier account))
        (compose-capability (CREDIT_DPMF))
        (compose-capability (UPDATE_DPMF_SUPPLY identifier amount))
    )
    ;;==================DESTROY======================
    (defcap DPMF_BURN (identifier:string nonce:integer account:string amount:decimal)
        @doc "Capability required to burn a DPMF Token locally \
        \ Smart-Contract Account type doesnt require their guard|key"
        (U_ValidateMetaFungibleAmount identifier amount)
        (DPTS.U_ValidateAccount account)
        (let
            (
                (iz-sc:bool (at 0 (DPTS.U_GetDPTSAccountType account)))
            )
            (if (= iz-sc true)
                (compose-capability (DPMF_BURN_SMART identifier account amount))
                (compose-capability (DPMF_BURN_STANDARD identifier account amount))
            )
        )
    )
    (defcap DPMF_BURN_SMART (identifier:string account:string amount:decimal)
        @doc " Capability required to burn a DPMF Token by a Smart DPTS Account"
        (compose-capability (DPMF_ACCOUNT_BURN_ON identifier account))
        (compose-capability (DEBIT_DPMF_SC))
        (compose-capability (UPDATE_DPMF_SUPPLY identifier amount))
    )
    (defcap DPMF_BURN_STANDARD (identifier:string account:string amount:decimal)
        @doc "Capability required to burn a DPMF Token by a Standard DPTS Account"
        (compose-capability (DPMF_ACCOUNT_OWNER identifier account))
        (compose-capability (DPMF_ACCOUNT_BURN_ON identifier account))
        (compose-capability (DEBIT_DPMF identifier account))
        (compose-capability (UPDATE_DPMF_SUPPLY identifier amount))
    )
    (defcap DPMF_WIPE (identifier:string account:string amount:decimal)
        @doc "Capability required to Wipe all DPMF Tokens from a DPMF account"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPMF_OWNER identifier))
        (compose-capability (DPMF_CAN-WIPE_ON identifier))
        (compose-capability (DPMF_ACCOUNT_FREEZE_ON identifier account))
        (compose-capability (UPDATE_DPMF_SUPPLY identifier amount))
    )
    ;;=================CORE==========================
    (defcap CREDIT_DPMF ()
        @doc "Capability to perform crediting operations with DPMF Tokens"
        true
        ;;Isnt needed since DPTS.U_ValidateSenderReceiver is used which has DPTS.U_ValidateAccount
        ;;DPTS.U_ValidateAccount enforces already length account is greater than ACCOUNT_ID_MIN_LENGTH (3)
        ;;(enforce (!= account "") "Invalid receiver account")
    )
    (defcap DEBIT_DPMF (identifier:string account:string)
        @doc "Capability to perform debiting operations on a Normal DPTS Account type for a DPMF Token"
        (enforce-guard 
            (at "guard" 
                (read DPMF-BalancesTable (concat [identifier BAR account]) ["guard"])
            )
        )
        ;;Isnt needed since DPTS.U_ValidateSenderReceiver is used which has DPTS.U_ValidateAccount
        ;;DPTS.U_ValidateAccount enforces already length account is greater than ACCOUNT_ID_MIN_LENGTH (3)
        ;;(enforce (!= account "") "Invalid sender account")
    )
    (defcap DEBIT_DPMF_SC ()
        @doc "Capability to perform debiting operations on a Smart(Contract) DPTS Account type for a DPMF Token\
        \ Does not enforce account guard."
        true
        ;;Isnt needed since DPTS.U_ValidateSenderReceiver is used which has DPTS.U_ValidateAccount
        ;;DPTS.U_ValidateAccount enforces already length account is greater than ACCOUNT_ID_MIN_LENGTH (3)
        ;;(enforce (!= account "") "Invalid sender account")
    )

    (defcap TRANSFER_DPMF 
        (
            identifier:string 
            nonce:integer 
            sender:string 
            receiver:string 
            amount:decimal 
            method:bool
        )
        @doc "Capability for transfer between 2 DPTS accounts for a specific DPMF Token identifier"
        (U_ValidateMetaFungibleAmount identifier amount)
        (DPTS.U_ValidateSenderReceiver sender receiver)

        (compose-capability (DPMF_IS-PAUSED_OFF identifier))
        (compose-capability (DPMF_ACCOUNT_FREEZE_OFF identifier sender))
        (compose-capability (DPMF_ACCOUNT_FREEZE_OFF identifier receiver))
        (with-read DPMF-PropertiesTable identifier
            { "role-transfer-amount" := rta }
            (if (!= rta 0)
                ;;if true
                (or
                    (compose-capability (DPMF_ACCOUNT_TRANSFER_ON identifier sender))
                    (compose-capability (DPMF_ACCOUNT_TRANSFER_ON identifier receiver))
                )
                ;;if false
                (format "No transfer Role restrictions exist for Token {}" [identifier])
            )
        )
        (compose-capability (DPTS.SC_TRANSFERABILITY sender receiver method))
        (let
            (
                (iz-sc:bool (at 0 (DPTS.U_GetDPTSAccountType sender)))
            )
            (if (and (= iz-sc true) (= method true))
                (compose-capability (DEBIT_DPMF_SC sender))
                (compose-capability (DEBIT_DPMF identifier sender))
            )
        )   
        (compose-capability (CREDIT_DPMF))
    )
    ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      PRIMARY Functions                       Stand-Alone Functions                                                                               ;;
    ;;                                                                                                                                                  ;;
    ;;      0)UTILITY                               Free Functions: can can be called by anyone.                                                        ;;
    ;;                                                  No Key|Guard required.                                                                          ;;
    ;;      1)ADMINISTRATOR                         Administrator Functions: can only be called by module administrator.                                ;;
    ;;                                                  Module Key|Guard required.                                                                      ;;
    ;;      2)CLIENT                                Client Functions: can be called by any DPMF Account.                                                ;;
    ;;                                                  Usually Client Key|Guard is required.                                                           ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      SECONDARY Functions                                                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;      3)AUXILIARY                             Auxiliary Functions: cannot be called on their own.                                                 ;;
    ;;                                                  Are Part of Client Function                                                                     ;;
    ;;                                                                                                                                                  ;;      
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      Functions Names are prefixed, so that they may be better visualised and understood.                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;      UTILITY                                 U_FunctionName                                                                                      ;;
    ;;      ADMINISTRATION                          A_FunctionName                                                                                      ;;
    ;;      CLIENT                                  C_FunctionName                                                                                      ;;
    ;;      AUXILIARY                               X_FunctionName                                                                                      ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      UTILITY FUNCTIONS                                                                                                                           ;;
    ;;                                                                                                                                                  ;;
    ;;==================ACCOUNT-INFO================                                                                                                    ;;
    ;;      U_GetAccountMetaFungibles               Returns a List of Metafungible Identifiers held by DPMF Accounts <account>                          ;;
    ;;      U_GetAccountMetaFungibleSupply          Returns total Supply for MetaFungible <identifier> (all nonces) held by DPMF Account <account>      ;;
    ;;      U_GetAccountMetaFungibleBalances        Returns a list of Balances that exist for MetaFungible <identifier> held by DPMF Account <account>  ;;
    ;;      U_GetAccountMetaFungibleNonces          Returns a list of Nonces that exist for MetaFungible <identifier> held by DPMF Account <account>    ;;
    ;;      U_GetAccountMetaFungibleBalance         Returns the balance of a MetaFungible (<identifier> and <nonce>) held by DPMF Account <account>     ;;
    ;;      U_GetAccountMetaFungibleMetaData        Returns the meta-data of a MetaFungible (<identifier> and <nonce>) held by DPMF Account <account>   ;;
    ;;      U_GetAccountMetaFungibleGuard           Returns the Guard of a MetaFungible <identifier> held by DPMF Account <account>                     ;;
    ;;==================MF-INFO=====================                                                                                                    ;;
    ;;      U_GetMetaFungibleSupply                 Returns Total existent Supply for MetaFungible <identifier>                                         ;;
    ;;      U_GetMetaFungibleDecimals               Returns the number of Decimals the MetaFungible <identifier> was created with                       ;;
    ;;      U_GetMetaFungibleLastNonce              Returns the Last Nonce in use for MetaFungible <identifier>                                         ;;
    ;;      U_GetMetaFungibleCreateRoleAccount      Returns the Account that has the current create-role for MetaFungible <identifier>                  ;;
    ;;==================VALIDATIONS=================                                                                                                    ;;
    ;;      U_ValidateMetaFungibleAmount            Enforces the Amount <amount> is positive its decimal size conform for MetaFungible <identifier>     ;;
    ;;      U_ValidateMetaFungibleIdentifier        Enforces the MetaFungible <identifier> exists                                                       ;;
    ;;      U_ValidateObjectListAsMetaFungibleList  Validates that a list of Objects contains Objects conform to the MetaFungible Schema                ;;
    ;;      U_ValidateObjectAsMetaFungible          Validates that an Object is conform to the MetaFungible Schema                                      ;;
    ;;      U_ValidateObjectAsNonceBalancePair      Validates that an Object is a pair of nonce and balances                                            ;;
    ;;      U_ComposeMetaFungible                   Composes a MetaFungible object from <nonce>, <balance> and <meta-data>                              ;;
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
    ;;      C_Control                               Controls MetaFungible <identifier> Properties using 7 boolean control triggers                      ;;
    ;;      C_Pause                                 Pause MetaFungible <identifier>                                                                     ;;
    ;;      C_Unpause                               Unpause MetaFungible <identifier>                                                                   ;;
    ;;      C_FreezeAccount                         Freeze MetaFungile <identifier> on DPMF Account <account>                                           ;;
    ;;      C_UnfreezeAccount                       Unfreeze MetaFungile <identifier> on DPMF Account <account>                                         ;;
    ;;==================SET=========================                                                                                                    ;;
    ;;      C_MoveCreateRole                        Moves |role-nft-create| from <sender> to <receiver> DPMF Account for MetaFungible <identifier>      ;;
    ;;      C_SetAddQuantityRole                    Sets |role-nft-add-quantity| to true for MetaFungible <identifier> and DPMF Account <account>       ;;
    ;;      C_SetBurnRole                           Sets |role-nft-burn| to true for MetaFungible <identifier> and DPMF Account <account>               ;;
    ;;      C_SetTransferRole                       Sets |role-transfer| to true for MetaFungible <identifier> and DPMF Account <account>               ;;
    ;;==================UNSET========================                                                                                                   ;;
    ;;      C_UnsetAddQuantityRole                  Sets |role-nft-add-quantity| to false for MetaFungible <identifier> and DPMF Account <account>      ;;
    ;;      C_UnsetBurnRole                         Sets |role-nft-burn| to false for MetaFungible <identifier> and DPMF Account <account>              ;;
    ;;      C_UnsetTransferRole                     Sets |role-transfer| to false for MetaFungible <identifier> and DPMF Account <account>              ;;
    ;;==================CREATE=======================                                                                                                   ;;
    ;;      C_IssueMetaFungible                     Issues a new MetaFungible                                                                           ;;
    ;;      C_DeployMetaFungibleAccount             Creates a new DPMF Account for Metafungible <identifier> and Account <account>                      ;;
    ;;      C_Mint                                  Mints <amount> <identifier> MetaFungibles with <meta-data> meta-data for DPMF Account <account>     ;;
    ;;      C_Create                                Creates a 0 balance <identifier> MetaFungible with <meta-data> meta-data for DPMF Account <account> ;;
    ;;      C_AddQuantity                           Adds <amount> quantity to existing Metafungible <identifer> and <nonce> for DPMF Account <account>  ;;
    ;;==================DESTROY=====================                                                                                                    ;;
    ;;      C_Burn                                  Burns <amount> <identifier>-<nonce> MetaFungible on DPMF Account <account>                          ;;
    ;;      C_Wipe                                  Wipes the whole supply of <identifier> MetaFungible on the frozen DPMF Account <account>            ;;
    ;;==================TRANSFER====================                                                                                                    ;;
    ;;      C_TransferMetaFungible                  Transfers <identifier>-<nonce> Metafungible from <sender> to <receiver> DPMF Account                ;;
    ;;      C_TransferMetaFungibleAnew              Same as |C_TransferMetaFungible| but with DPMF Account creation                                     ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      AUXILIARY FUNCTIONS                                                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================TRANSFER====================                                                                                                    ;;
    ;;      X_MethodicTransferMetaFungible          Methodic transfers <identifier>-<nonce> Metafungible from <sender> to <receiver> DPMF Account       ;;
    ;;      X_MethodicTransferDPMFAnew              Same as |X_MethodicTransferMetaFungible| but with DPMF Account creation                             ;;
    ;;==================CREDIT|DEBIT================                                                                                                    ;;
    ;;      X_Create                                Auxiliary Function that creates a MetaFungible                                                      ;;
    ;;      X_AddQuantity                           Auxiliary Function that adds quantity for an existing Metafungible                                  ;;
    ;;      X_Credit                                Auxiliary Function that credit a MetaFungible to a DPMF Account                                     ;;
    ;;      X_Debit                                 Auxiliary Function that debits a MetaFungible from a DPMF Account                                   ;;
    ;;      X_DebitPaired                           Auxiliary Helper Function designed for making |X_DebitMultiple| possible, which is needed for Wiping;;
    ;;      X_DebitMultiple                         Auxiliary Function neede for Wiping                                                                 ;;
    ;;==================UPDATE======================                                                                                                    ;;
    ;;      X_UpdateSupply                          Updates <identifier> MetaFungible supply. Boolean <direction> used for increase|decrease            ;;
    ;;      X_IncrementNonce                        Increments <identifier> MetaFungible nonce.                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;
    ;;      UTILITY FUNCTIONS
    ;;
    ;;      U_GetAccountMetaFungibles 
    ;;
    (defun U_GetAccountMetaFungibles:[string] (account:string)
        @doc "Returns a List of Metafungible Identifiers held by DPMF Accounts <account>"
        (DPTS.U_ValidateAccount account)

        (let*
            (
                (keyz:[string] (keys DPMF-BalancesTable))
                (listoflists:[[string]] (map (lambda (x:string) (DPTS.U_SplitString DPTS.BAR x)) keyz))
                (dpmf-account-tokens:[string] (DPTS.U_FilterIdentifier listoflists account))
            )
            dpmf-account-tokens
        )
    )
    ;;
    ;;      U_GetAccountMetaFungibleSupply
    ;;
    (defun U_GetAccountMetaFungibleSupply:decimal (identifier:string account:string)
        @doc "Returns total Supply for MetaFungible <identifier> (all nonces) held by DPMF Account <account>"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)

        (with-default-read DPMF-BalancesTable (concat [identifier BAR  account])
            { "unit" : [NEUTRAL_META-FUNGIBLE] }
            { "unit" := read-unit}
            (let
                (
                    (unit-validation:bool (U_ValidateObjectListAsMetaFungibleList read-unit))
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
    ;;
    ;;      U_GetAccountMetaFungibleBalances
    ;;
    (defun U_GetAccountMetaFungibleBalances:[decimal] (identifier:string account:string)
        @doc "Returns a list of Balances that exist for MetaFungible <identifier> on DPMF Account <account>\
        \ Needed for Mass Debiting"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)

        (with-default-read DPMF-BalancesTable (concat [identifier BAR  account])
            { "unit" : [NEUTRAL_META-FUNGIBLE] }
            { "unit" := read-unit}
            (let
                (
                    (unit-validation:bool (U_ValidateObjectListAsMetaFungibleList read-unit))
                )
                (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                (let 
                    (
                        (result 
                            (fold
                                (lambda 
                                    (acc:[decimal] item:object)
                                    (if (!= (at "balance" item) 0.0)
                                            (DPTS.UX_AppendLast acc (at "balance" item))
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
    ;;
    ;;      U_GetAccountMetaFungibleNonces
    ;;
    (defun U_GetAccountMetaFungibleNonces:[integer] (identifier:string account:string)
        @doc "Returns a list of Nonces that exist for MetaFungible <identifier> held by DPMF Account <account>"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)

        (with-default-read DPMF-BalancesTable (concat [identifier BAR  account])
            { "unit" : [NEUTRAL_META-FUNGIBLE] }
            { "unit" := read-unit}
            (let
                (
                    (unit-validation:bool (U_ValidateObjectListAsMetaFungibleList read-unit))
                )
                (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                (let 
                    (
                        (result 
                            (fold
                                (lambda 
                                    (acc:[integer] item:object)
                                    (if (!= (at "nonce" item) 0)
                                            (DPTS.UX_AppendLast acc (at "nonce" item))
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
    ;;
    ;;      U_GetAccountMetaFungibleBalance
    ;;
    (defun U_GetAccountMetaFungibleBalance:decimal (identifier:string nonce:integer account:string)
        @doc " Returns the balance of a MetaFungible (<identifier> and <nonce>) held by DPMF Account <account>"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)

        (with-default-read DPMF-BalancesTable (concat [identifier BAR  account])
            { "unit" : [NEUTRAL_META-FUNGIBLE] }
            { "unit" := read-unit}
            (let
                (
                    (unit-validation:bool (U_ValidateObjectListAsMetaFungibleList read-unit))
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
    ;;
    ;;      U_GetAccountMetaFungibleMetaData
    ;;
    (defun U_GetAccountMetaFungibleMetaData:object (identifier:string nonce:integer account:string)
        @doc "Returns the meta-data of a MetaFungible (<identifier> and <nonce>) held by DPMF Account <account>"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)

        (with-default-read DPMF-BalancesTable (concat [identifier BAR  account])
            { "unit" : [NEUTRAL_META-FUNGIBLE] }
            { "unit" := read-unit}
            (let
                (
                    (unit-validation:bool (U_ValidateObjectListAsMetaFungibleList read-unit))
                )
                (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                (let 
                    (
                        (result-meta-data:object
                            (fold
                                (lambda 
                                    (acc:object item:object)
                                    (let
                                        (
                                            (nonce-val:integer (at "nonce" item))
                                            (meta-data-val:object (at "meta-data" item))
                                        )
                                        (if (= nonce-val nonce)
                                            meta-data-val
                                            acc
                                        )
                                    )
                                )
                                {}
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
    ;;      U_GetAccountMetaFungibleGuard
    ;;
    (defun U_GetAccountMetaFungibleGuard:guard (identifier:string account:string)
        @doc "Return <identifier> DPMF Token Decimal size"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)

        (at "guard" (read DPMF-BalancesTable (concat [identifier BAR account]) ["guard"]))
    )
    ;;
    ;;      U_GetMetaFungibleSupply 
    ;;
    (defun U_GetMetaFungibleSupply:decimal (identifier:string)
        @doc "Returns Total existent Supply for MetaFungible <identifier>"
        (U_ValidateMetaFungibleIdentifier identifier)

        (at "supply" (read DPMF-PropertiesTable identifier ["supply"]))
    )
    ;;
    ;;      U_GetMetaFungibleDecimals
    ;;
    (defun U_GetMetaFungibleDecimals:integer (identifier:string)
        @doc "Returns the number of Decimals the MetaFungible <identifier> was created with"
        (U_ValidateMetaFungibleIdentifier identifier)

        (at "decimals" (read DPMF-PropertiesTable identifier ["decimals"]))
    )

    ;;
    ;;      U_GetMetaFungibleLastNonce
    ;;
    (defun U_GetMetaFungibleLastNonce:integer (identifier:string)
        @doc "Returns the Last Nonce in use for MetaFungible <identifier>"
        (U_ValidateMetaFungibleIdentifier identifier)

        (at "nonces-used" (read DPMF-PropertiesTable identifier ["nonces-used"]))
    )
    ;;
    ;;      U_GetMetaFungibleCreateRoleAccount
    ;;
    (defun U_GetMetaFungibleCreateRoleAccount:string (identifier:string)
        @doc "Returns the Account that has the current create-role for MetaFungible <identifier>"
        (U_ValidateMetaFungibleIdentifier identifier)

        (at "create-role-account" (read DPMF-PropertiesTable identifier ["create-role-account"]))
    )
    ;;
    ;;      U_ValidateMetaFungibleAmount
    ;;
    (defun U_ValidateMetaFungibleAmount (identifier:string amount:decimal)
        @doc "Enforces the Amount <amount> is positive its decimal size conform for MetaFungible <identifier>"
        (U_ValidateMetaFungibleIdentifier identifier)

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
    ;;
    ;;      U_ValidateIdentifier
    ;;
    (defun U_ValidateMetaFungibleIdentifier (identifier:string)
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
    ;;      U_ValidateObjectListAsMetaFungibleList
    ;;
    (defun U_ValidateObjectListAsMetaFungibleList:bool (mflst:[object])
        @doc "Validates that a list of Objects contains Objects conform to the MetaFungible Schema"
        (let 
            (
                (result 
                    (fold
                        (lambda 
                            (acc:bool item:object)
                            (let
                                (
                                    (iz-meta-fungible:bool (U_ValidateObjectAsMetaFungible item))
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
    ;;
    ;;      U_ValidateObjectAsMetaFungible
    ;;
    (defun U_ValidateObjectAsMetaFungible:bool (obj:object)
        @doc "Validates that an Object is conform to the MetaFungible Schema"
        (let*
            (
                (exist-nonce:bool (contains "nonce" obj))
                (exist-balance:bool (contains "balance" obj))
                (exist-meta-data:bool (contains "meta-data" obj))
                (exist-keys:bool (and (and (= exist-nonce true)(= exist-balance true))(= exist-meta-data true)))
            )
            (if (= exist-keys true)
                (let
                    (
                        (nonce-val:integer (at "nonce" obj))
                        (balance-val:decimal (at "balance" obj))
                        (meta-data-val:object (at "meta-data" obj))
                        (obj-size:integer (length obj))
                    )
                    (enforce (= (typeof nonce-val) "integer") "Invalid nonce type")
                    (enforce (= (typeof balance-val) "decimal") "Invalid balance type")
                    (enforce (= (typeof meta-data-val) "object:*") "Invalid meta-data type")
                    (enforce (= obj-size 3) "Invalid length for object")
                )
                false
            )
        )
    )
    ;;
    ;;      U_ValidateObjectAsNonceBalancePair
    ;;
    (defun U_ValidateObjectAsNonceBalancePair:bool (obj:object)
        @doc "Validates that an Object is a pair of nonce and balances"
        (let*
            (
                (exist-nonce:bool (contains "nonce" obj))
                (exist-balance:bool (contains "balance" obj))
                (exist-keys:bool (and (= exist-nonce true)(= exist-balance true)))
            )
            (if (= exist-keys true)
                (let
                    (
                        (nonce-val:integer (at "nonce" obj))
                        (balance-val:decimal (at "balance" obj))
                        (obj-size:integer (length obj))
                    )
                    (enforce (= (typeof nonce-val) "integer") "Invalid nonce type")
                    (enforce (= (typeof balance-val) "decimal") "Invalid balance type")
                    (enforce (= obj-size 2) "Invalid length for object")
                )
                false
            )
        )
    )
    ;;
    ;;      U_ComposeMetaFungible
    ;;
    (defun U_ComposeMetaFungible:object (nonce:integer balance:decimal meta-data:object)
        @doc "Composes a MetaFungible object from <nonce>, <balance> and <meta-data>"

        {"nonce" : nonce, "balance" : balance, "meta-data" : meta-data}
    )
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      ADMINSTRATION FUNCTIONS
    ;;
    ;;      NO ADMINISTRATOR FUNCTIONS 
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      CLIENT FUNCTIONS
    ;;
    ;;      C_Control
    ;;
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
            \ Setting the <can-upgrade> property to off(false) \
            \ disables all future Control of Properties"

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
        ) 
    )
    ;;
    ;;      C_PauseDPMF
    ;;
    (defun C_Pause (identifier:string)
        @doc "Pause MetaFungible <identifier>"

        (with-capability (DPMF_PAUSE identifier)
            (update DPMF-PropertiesTable identifier { "is-paused" : true})
        )
    )
    ;;
    ;;      C_UnpauseDPMF
    ;;
    (defun C_Unpause (identifier:string)
        @doc "Unpause MetaFungible <identifier>"

        (with-capability (DPMF_UNPAUSE identifier)
            (update DPMF-PropertiesTable identifier { "is-paused" : false})
        )
    )
    ;;
    ;;      C_FreezeAccount
    ;;
    (defun C_FreezeAccount (identifier:string account:string)
        @doc "Freeze MetaFungile <identifier> on DPMF Account <account>"

        (with-capability (DPMF_FREEZE_ACCOUNT identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account]) { "frozen" : true})
        )
    )
    ;;
    ;;      C_UnfreezeDPMFAccount 
    ;;
    (defun C_UnfreezeDPMFAccount (identifier:string account:string)
        @doc "Unfreeze MetaFungile <identifier> on DPMF Account <account>"

        (with-capability (DPMF_UNFREEZE_ACCOUNT identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account]) { "frozen" : false})
        )
    )
    ;;
    ;;      C_MoveCreateRole
    ;;
    (defun C_MoveCreateRole (identifier:string sender:string receiver:string receiver-guard:guard)
        @doc "Moves |role-nft-create| from <sender> to <receiver> DPMF Account for MetaFungible <identifier> \
            \ Only a single DPMF Account can have the |role-nft-create| \
            \ Afterwards the receiver DPMF Account can crete new Meta Fungibles \ 
            \ Fails if the target DPMF Account doesnt exist"

        (with-capability (DPMF_MOVE_CREATE-ROLE identifier sender receiver)
            (update DPMF-BalancesTable (concat [identifier BAR sender])
                {"role-nft-create" : false}
            )
            (update DPMF-PropertiesTable identifier
                {"create-role-account" : receiver}
            
            )
            ;;Since the DPMF-Properties Table is already updated with the receiver as create-role-account
            ;;When the receiver doesnt have a DPMF Account, attempting to deploy the DPMF Account for the receiver
            ;;Will executed the deployment with role-nft-create automatically set to true
            (C_DeployMetaFungibleAccount identifier receiver receiver-guard)
            ;;However, if the receiver already has a DPMF Account, a simple update is required.
            ;;This doesnt change anything is the DPMF account was freshly deployed anew from above.
            (update DPMF-BalancesTable (concat [identifier BAR receiver])
                {"role-nft-create" : true}
            )
        )
    )
    ;;
    ;;      C_SetAddQuantityRole
    ;;
    (defun C_SetAddQuantityRole (identifier:string account:string)
        @doc "Sets |role-nft-add-quantity| to true for MetaFungible <identifier> and DPMF Account <account> \
            \ Afterwards Account <account> can increase quantity for existing MetaFungibles"

        (with-capability (DPMF_SET_ADD-QUANTITY-ROLE identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account])
                {"role-nft-add-quantity" : true}
            )
        )
    )
    ;;
    ;;      C_SetBurnRole
    ;;
    (defun C_SetBurnRole (identifier:string account:string)
        @doc "Sets |role-nft-burn| to true for MetaFungible <identifier> and DPMF Account <account> \
            \ Afterwards Account <account> can burn existing MetaFungibles"

        (with-capability (DPMF_SET_BURN-ROLE identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account])
                {"role-nft-burn" : true}
            )
        )
    )
    ;;
    ;;      C_SetTransferRole
    ;;
    (defun C_SetTransferRole (identifier:string account:string)
        @doc "Sets |role-transfer| to true for MetaFungible <identifier> and DPMF Account <account> \
            \ If at least one DPMF Account has the transfer role on, then all normal transfer are restricted\
            \ Transfer will only work towards DPMF Accounts with |role-trasnfer| on, \
            \ while these DPMF Account can transfer DPMF Tokens unrestricted to any other DPMF Account"

        (with-capability (DPMF_SET_TRANSFER-ROLE identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account])
                {"role-transfer" : true}
            )
        )
    )

    ;;
    ;;      C_UnsetAddQuantityRole
    ;;
    (defun C_UnsetAddQuantityRole (identifier:string account:string)
        @doc "Sets |role-nft-add-quantity| to false for MetaFungible <identifier> and DPMF Account <account> \
            \ Afterwards Account <account> can no longer increase quantity for existing MetaFungibles"

        (with-capability (DPMF_UNSET_ADD-QUANTITY-ROLE identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account])
                {"role-nft-add-quantity" : false}
            )
        )
    )
    ;;
    ;;      C_UnsetBurnRole 
    ;;
    (defun C_UnsetBurnRole (identifier:string account:string)
        @doc "Sets |role-nft-burn| to false for MetaFungible <identifier> and DPMF Account <account> \
            \ Afterwards Account <account> can no longer burn existing MetaFungibles"

        (with-capability (DPMF_UNSET_BURN-ROLE identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account])
                {"role-nft-burn" : false}
            )
        )
    )
    ;;
    ;;      C_UnsetTransferRole
    ;;
    (defun C_UnsetTransferRole (identifier:string account:string)
        @doc "Sets |role-transfer| to false for MetaFungible <identifier> and DPMF Account <account> \
            \ If at least one DPMF Account has the transfer role on, then all normal transfer are restricted \
            \ Transfer will only work towards DPMF Accounts with |role-trasnfer| on, \
            \ while these DPMF Account can transfer DPMF Tokens unrestricted to any other DPMF Account"

        (with-capability (DPMF_UNSET_TRANSFER-ROLE identifier account)
            (update DPMF-BalancesTable (concat [identifier BAR account])
                {"role-transfer" : false}
            )
        )
    )
    ;;      C_IssueMetaFungible
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
        (DPTS.U_ValidateTokenName name)
        ;; Enforce Ticker is part of identifier variable
        (DPTS.U_ValidateDecimals decimals)

        (let
            (
                (identifier (DPTS.U_MakeDPTSIdentifier ticker))
            )
            ;; Add New Entries in the DPMF-PropertyTable
            ;; Since the Entry uses insert command, the KEY uniquness is ensured, since it will fail if key already exists.
            ;; Entry is initialised with "is-paused" set to off(false).
            ;; Entry is initialised with a supply of 0.0 (decimal)
            ;; Entry is initiated with "create-role-account" as the Issuer Account
            ;; Entry is initiated with o to role-transfer-amount, since no Account will transfer role upon creation.
            (insert DPMF-PropertiesTable identifier
                {"owner"                : owner
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
            ;; Returns the unique DPMF Token Identifier
            identifier
        )
    )
    ;;
    ;;      C_DeployMetaFungibleAccount
    ;;
    (defun C_DeployMetaFungibleAccount (identifier:string account:string guard:guard)
        @doc "Creates a new DPMF Account for Metafungible <identifier> and Account <account> \
            \ If a DPMF Account already exists for <identifier> and <account>, it remains as is \
            \ \
            \ A Standard DPTS Account is also created, if one doesnt exist \
            \ If a DPTS Account exists, its type remains unchanged"
        (U_ValidateMetaFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (DPTS.U_EnforceReserved account guard)

        ;;Automatically creates a Standard DPTS Account for <account> if one doesnt exists
        ;;If a DPTS Account exists for <account>, it remains as is
        (DPTS.C_DeployStandardDPTSAccount account guard)

        ;;Creates new Entry in the DPMF-BalancesTable for <identifier>|<account>
        ;;If Entry exists, no changes are being done
        (let*
            (
                (create-role-account:string (U_GetMetaFungibleCreateRoleAccount identifier))
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
    ;;
    ;;      C_Mint
    ;;
    (defun C_Mint (identifier:string account:string amount:decimal meta-data:object)
        @doc "Mints <amount> <identifier> MetaFungibles with <meta-data> meta-data for DPMF Account <account> \
            \ Both |role-nft-create| and |role-nft-add-quantity| are required for minting"

        (with-capability (DPMF_MINT identifier account amount)
            (with-read DPMF-BalancesTable (concat [identifier BAR account])
                { "guard" := g }
                (let
                    (
                        (new-nonce:integer (X_Create identifier account g meta-data))
                    )
                    ;;Add-Quantity for the DPMF Token (needs function)
                    (X_AddQuantity identifier new-nonce account amount)
                    ;;Update DPMF Supply
                    (X_UpdateSupply identifier amount true)
                )
            )
        )
    )
    ;;
    ;;      C_Create
    ;;
    (defun C_Create:integer (identifier:string account:string meta-data:object)
        @doc "Creates a 0.0 balance <identifier> MetaFungible with <meta-data> meta-data for DPMF Account <account>"

        (with-capability (DPMF_CREATE identifier account)
            (with-read DPMF-BalancesTable (concat [identifier BAR account])
                { "guard" := g }
                ;;Create DPMF Token (needs function)
                (X_Create identifier account g meta-data)
            )
        )
    )
    ;;
    ;;      C_AddQuantity
    ;;
    (defun C_AddQuantity (identifier:string nonce:integer account:string amount:decimal)
        @doc "Adds <amount> quantity to existing Metafungible <identifer> and <nonce> for DPMF Account <account>"

        (with-capability (DPMF_ADD-QUANTITY identifier account amount)
            (X_AddQuantity identifier nonce account amount)
            ;;Update DPMF Supply
            (X_UpdateSupply identifier amount true)
        )
    )
    ;;
    ;;      C_Burn
    ;;
    (defun C_Burn (identifier:string nonce:integer account:string amount:decimal)
        @doc "Burns <amount> <identifier>-<nonce> MetaFungible on DPMF Account <account>"

        (with-capability (DPMF_BURN identifier nonce account amount)
            (X_Debit identifier nonce account amount false)
            (X_UpdateSupply identifier amount false)
        )
    )
    ;;
    ;;      C_WipeDPMF
    ;;
    (defun C_Wipe (identifier:string account:string)
        @doc "Wipes the whole supply of <identifier> MetaFungible on the frozen DPMF Account <account>"

        (let*
            (
                (nonce-lst:[integer] (U_GetAccountMetaFungibleNonces identifier account))
                (balance-lst:[decimal] (U_GetAccountMetaFungibleBalances identifier account))
                (balance-sum:decimal (fold (+) 0.0 balance-lst))
            )
            (with-capability (DPMF_WIPE identifier account balance-sum)
                (X_DebitMultiple identifier nonce-lst account balance-lst)
                (X_UpdateSupply identifier balance-sum false)
            )
        )
    )
    ;;
    ;;      C_TransferMetaFungible
    ;;
    (defun C_TransferMetaFungible (identifier:string nonce:integer sender:string receiver:string amount:decimal)
        @doc "Transfers <identifier>-<nonce> Metafungible from <sender> to <receiver> DPMF Account\
            \ Fails if <receiver> DPMF Account doesnt exist."

        (with-capability (TRANSFER_DPMF identifier nonce sender receiver amount false)
            (let
                (
                    (current-nonce-meta-data:object (U_GetAccountMetaFungibleMetaData identifier nonce sender))
                )
                (X_Debit identifier nonce sender amount false)
                (with-read DPMF-BalancesTable (concat [identifier BAR receiver])
                    { "guard" := guard }
                    (X_Credit identifier nonce current-nonce-meta-data receiver guard amount)
                )
            )
        )
    )
    ;;
    ;;      C_TransferMetaFungibleAnew
    ;;
    (defun C_TransferMetaFungibleAnew (identifier:string nonce:integer sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "Same as |C_TransferMetaFungible| but with DPMF Account creation \
            \ This means <receiver> DPMF Account will be created by the transfer function"

        (with-capability (TRANSFER_DPMF identifier nonce sender receiver amount false)
            (let
                (
                    (current-nonce-meta-data:object (U_GetAccountMetaFungibleMetaData identifier nonce sender))
                )
                (X_Debit identifier nonce sender amount false)
                (X_Credit identifier nonce current-nonce-meta-data receiver receiver-guard amount)
            )
        )
    )

    ;;
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      AUXILIARY FUNCTIONS
    ;;
    ;;      X_MethodicTransferMetaFungible 
    ;;
    (defun X_MethodicTransferMetaFungible  (identifier:string nonce:integer sender:string receiver:string amount:decimal)
        @doc "Methodic transfers <identifier>-<nonce> Metafungible from <sender> to <receiver> DPMF Account \
            \ Fails if <receiver> DPMF Account doesnt exist. \
            \ \
            \ Methodic Transfers cannot be called directly. Thery are to be used within external Modules \
            \ as transfer means when operating with Smart DPTS Account Types. \
            \ \
            \ This is because clients can trigger transfers to be executed towards and from Smart DPTS Account types,\
            \ as described in the module's code, without them having the need to provide the Smart DPTS Accounts guard \
            \ \
            \ Designed to emulate MultiverX Smart-Contract payable Write-Points \
            \ Here the |payable Write-Points| are the external module functions that make use of this function."

        (require-capability (TRANSFER_DPMF identifier nonce sender receiver amount true))
        (let
            (
                (current-nonce-meta-data:object (U_GetAccountMetaFungibleMetaData identifier nonce sender))
            )
            (X_Debit identifier nonce sender amount false)
            (with-read DPMF-BalancesTable (concat [identifier BAR receiver])
                { "guard" := guard }
                (X_Credit identifier nonce current-nonce-meta-data receiver guard amount)
            )
        )
    )
    ;;
    ;;      X_TransferDPMFAnew
    ;;
    (defun X_MethodicTransferDPMFAnew (identifier:string nonce:integer sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "Same as |X_MethodicTransferMetaFungible| but with DPMF Account creation \
            \ This means <receiver> DPMF Account will be created by the transfer function "
        
        (require-capability (TRANSFER_DPMF identifier nonce sender receiver amount true))
        (let
            (
                (current-nonce-meta-data:object (U_GetAccountMetaFungibleMetaData identifier nonce sender))
            )
            (X_Debit identifier nonce sender amount false)
            (X_Credit identifier nonce current-nonce-meta-data receiver receiver-guard amount)
        )
    )
    ;;
    ;;      X_Create
    ;;
    (defun X_Create:integer (identifier:string account:string guard:guard meta-data:object)
        @doc "Auxiliary Function that creates a MetaFungible \
            \ Returns as integer the nonce of the newly created MetaFungible"

        (let*
            (
                (new-nonce:integer (+ (U_GetMetaFungibleLastNonce identifier) 1))
                (create-role-account:string (U_GetMetaFungibleCreateRoleAccount identifier))
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
                        (unit-validation:bool (U_ValidateObjectListAsMetaFungibleList u))
                        (is-new:bool (if (= u [NEUTRAL_META-FUNGIBLE]) (DPTS.U_EnforceReserved account guard) false))
                        (meta-fungible:object (U_ComposeMetaFungible new-nonce 0.0 meta-data))
                        (appended-meta-fungible:[object] (DPTS.UX_AppendLast u meta-fungible))
                    )
                    (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                    ;; First, a new DPTS Account is created for Account <account>. 
                    ;; If DPTS Account exists for <account>, nothing is modified
                    (DPTS.C_DeployStandardDPTSAccount account guard)
                    (write DPMF-BalancesTable (concat [identifier BAR account])
                        { "unit"                        : appended-meta-fungible
                        , "guard"                       : retg
                        , "role-nft-add-quantity"       : (if is-new false rnaq)
                        , "role-nft-burn"               : (if is-new false rb)
                        , "role-nft-create"             : (if is-new role-nft-create-boolean rnc)
                        , "role-transfer"               : (if is-new false rt)
                        , "frozen"                      : (if is-new false f)}
                    )
                )
                (X_IncrementNonce identifier)
            )
            new-nonce
        )
    )
    ;;
    ;;      X_AddQuantity
    ;;
    (defun X_AddQuantity (identifier:string nonce:integer account:string amount:decimal)
        @doc "Auxiliary Function that adds quantity for an existing Metafungible \
            \ Assumes <identifier> and <nonce> exist on DPMF Account"

        (require-capability (DPMF_ADD-QUANTITY identifier account amount))
        (with-read DPMF-BalancesTable (concat [identifier BAR account])
            { "unit" := unit }

            (let*
                (
                    (unit-validation:bool (U_ValidateObjectListAsMetaFungibleList unit))
                    (current-nonce-balance:decimal (U_GetAccountMetaFungibleBalance identifier nonce account))
                    (current-nonce-meta-data:object (U_GetAccountMetaFungibleMetaData identifier nonce account))
                    (updated-balance:decimal (+ current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object (U_ComposeMetaFungible nonce current-nonce-balance current-nonce-meta-data))
                    (updated-meta-fungible:object (U_ComposeMetaFungible nonce updated-balance current-nonce-meta-data))
                    (processed-unit:[object] (DPTS.U_ReplaceItem unit meta-fungible-to-be-replaced updated-meta-fungible))
                )
                (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                (update DPMF-BalancesTable (concat [identifier BAR account])
                    {"unit" : processed-unit}    
                )
            )
        )  
    )
    ;;
    ;;      X_Credit
    ;;
    (defun X_Credit (identifier:string nonce:integer meta-data:object account:string account-guard:guard amount:decimal)
        @doc "Auxiliary Function that credit a MetaFungible to a DPMF Account \
            \ Also creates a new DPMF Account if it doesnt exist. \
            \ If account already has DPMF nonce, it is simply increased \
            \ If account doesnt have DPMF nonce, it is added"
        (require-capability (CREDIT_DPMF))

        (let*
            (
                (create-role-account:string (U_GetMetaFungibleCreateRoleAccount identifier))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF-BalancesTable (concat [identifier BAR account])
                { "unit" : [NEUTRAL_META-FUNGIBLE]
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
                (let*
                    (
                        (unit-validation:bool (U_ValidateObjectListAsMetaFungibleList unit))
                        (is-new:bool (if (= unit [NEUTRAL_META-FUNGIBLE]) (DPTS.U_EnforceReserved account account-guard) false))
                        (current-nonce-balance:decimal (U_GetAccountMetaFungibleBalance identifier nonce account))
                        (credited-balance:decimal (+ current-nonce-balance amount))
                        (present-meta-fungible:object (U_ComposeMetaFungible nonce current-nonce-balance meta-data))
                        (credited-meta-fungible:object (U_ComposeMetaFungible nonce credited-balance meta-data))
                        (processed-unit-with-replace:[object] (DPTS.U_ReplaceItem unit present-meta-fungible credited-meta-fungible))
                        (processed-unit-with-append:[object] (DPTS.UX_AppendLast unit credited-meta-fungible))
                    )
                    (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                    (enforce (> amount 0.0) "Crediting amount must be greater than zero")
                    ;; First, a new DPTS Account is created for Account <account>. 
                    ;; If DPTS Account exists for <account>, nothing is modified
                    (DPTS.C_DeployStandardDPTSAccount account account-guard)
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
    ;;
    ;;      X_Credit
    ;;
    (defun X_Debit (identifier:string nonce:integer account:string amount:decimal admin:bool)
        @doc "Auxiliary Function that debits a MetaFungible from a DPMF Account \
            \ If the amount is equal to the whole nonce amount, the whole MetaFungible is removed \
            \ \
            \ true <admin> boolean is used when debiting is executed as a part of wiping by the DPMF Owner \
            \ otherwise, for normal debiting operations, false <admin> boolean must be used"
        ;; No Validation of Inputs required as this is auxiliary function
        ;; and as such cannot be called on its own

        ;;Capability Required for Debit
        (let
            (
                (iz-sc:bool (at 0 (DPTS.U_GetDPTSAccountType account)))
            )
            (if (= admin true)
                (require-capability (DPMF_OWNER identifier))
                (if (= iz-sc true)
                    (require-capability (DEBIT_DPMF_SC account))
                    (require-capability (DEBIT_DPMF identifier account))
                )
            )
            
            (with-read DPMF-BalancesTable (concat [identifier BAR account])
                { "unit" := unit  }
                (let*
                    (
                        (unit-validation:bool (U_ValidateObjectListAsMetaFungibleList unit))
                        (current-nonce-balance:decimal (U_GetAccountMetaFungibleBalance identifier nonce account))
                        (current-nonce-meta-data:object (U_GetAccountMetaFungibleMetaData identifier nonce account))
                        (debited-balance:decimal (- current-nonce-balance amount))
                        (meta-fungible-to-be-replaced:object (U_ComposeMetaFungible nonce current-nonce-balance current-nonce-meta-data))
                        (debited-meta-fungible:object (U_ComposeMetaFungible nonce debited-balance current-nonce-meta-data))
                        (processed-unit-with-remove:[object] (DPTS.U_RemoveItem unit meta-fungible-to-be-replaced))
                        (processed-unit-with-replace:[object] (DPTS.U_ReplaceItem unit meta-fungible-to-be-replaced debited-meta-fungible))
                    )
                    (enforce (= unit-validation true) "Unit is a not a list of Meta-Fungibles")
                    (enforce (>= debited-balance 0.0) "Insufficient Funds for debiting")
                    (if (= debited-balance 0.0)
                        ;;Remove Metafungible
                        (update DPMF-BalancesTable (concat [identifier BAR account])
                            {"unit" : processed-unit-with-remove}    
                        )
                        ;;Replace Metafungible
                        (update DPMF-BalancesTable (concat [identifier BAR account])
                            {"unit" : processed-unit-with-replace}    
                        )
                    )
                )
            )     
        )
    )
    ;;
    ;;      X_DebitPaired
    ;;
    (defun X_DebitPaired (identifier:string account:string nonce-balance-obj:object)
        @doc "Helper Function designed for making |X_DebitMultiple| possible, which is needed for Wiping \
            \ Same a |X_Debit| but the nonce and balance are composed into a singular <nonce-balance-obj> object \
            \ Within |X_DebitPaired|, |X_Debit| is called using true <admin> boolean \
            \ which is needed when MetaFungible debitation is executed by DPMF Owner (admin) on another DPMF Account \
            \ as part of the Wiping Process, where the DPMF Account key|guard isnt required"

        (let
            (
                (iz-nonce-balance-pair:bool (U_ValidateObjectAsNonceBalancePair nonce-balance-obj))
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
    ;;
    ;;      X_DebitMultiple
    ;;
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
    ;;      X_UpdateSupply
    ;;
    (defun X_UpdateSupply (identifier:string amount:decimal direction:bool)
        @doc "Updates <identifier> MetaFungible supply. Boolean <direction> used for increase|decrease"

        (require-capability (UPDATE_DPMF_SUPPLY identifier amount))
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
    ;;
    ;;      X_UpdateSupply
    ;;
    (defun X_IncrementNonce (identifier:string)
        @doc "Increments <identifier> MetaFungible nonce."

        (require-capability (DPMF_INCREASE_NONCE))
        (with-read DPMF-PropertiesTable identifier
            { "nonces-used" := nu }
            (update DPMF-PropertiesTable identifier { "nonces-used" : (+ nu 1)})
        )
    )
)

(create-table DPMF-PropertiesTable)
(create-table DPMF-BalancesTable)