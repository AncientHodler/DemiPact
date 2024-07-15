(module DPTF GOVERNANCE
    @doc "Core_DPTF is the Demiourgos.Holdings Module for the management of DPTF Tokens \
    \ DPTF-Tokens = Demiourgos Pact True Fungible Tokens \
    \ DPTF-Tokens mimic the functionality of the ESDT Token introduced by MultiversX (former Elrond) Blockchain"


    ;;0]GOVERNANCE-ADMIN
    ;;
    ;;      GOVERNANCE|DPTF_ADMIN|DPTF_CLIENT
    ;;
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
        \ Set to DPTF_ADMIN so that only Module Key can enact an upgrade"
        false
    )
    (defcap DPTF_ADMIN ()
        (enforce-guard (keyset-ref-guard SC_KEY))
    )
    (defcap DPTF_CLIENT (identifier:string account:string)
        (let
            (
                (iz-sc:bool (DPTS.UR_DPTS-AccountType account))
            )
            (if (= iz-sc true)
                true
                (compose-capability (DPTF_ACCOUNT_OWNER identifier account))
            )
        )
    )

    ;;1]CONSTANTS Definitions
    ;;Smart-Contract Key and Name Definitions
    (defconst SC_KEY "free.DH-Master-Keyset")
    (defconst SC_NAME "Demiourgos-Pact-True-Fungible")
    (defconst BAR DPTS.BAR)

    ;;2]SCHEMAS Definitions
    ;;Demiourgos Pact TRUE Fungible Token Standard - DPTF
    (defschema DPTF-PropertiesSchema
        @doc "Schema for DPTF Token (True Fungibles) Properties \
        \ Key for Table is DPTF Token Identifier. This ensure a unique entry per Token Identifier"

        owner:guard                                 ;;Guard of the Token Owner, Account that created the DPTF Token
        name:string                                 ;;Token Name (Alpha-Numeric 3-50 Characters Long)
        ticker:string                               ;;Token Ticker (Capital Alpha-Numeric 3-20 Characters Long)
        decimals:integer                            ;;Token Decimal Number

                                                    ;;TM=Token Manager
        can-change-owner:bool                       ;;Token management can be transferred to a different account                      
        can-upgrade:bool                            ;;TM may change these properties
        can-add-special-role:bool                   ;;TM can assign a specific role(s)
        can-freeze:bool                             ;;TM may freeze the token balance in a specific account, preventing transfers to and from that account
        can-wipe:bool                               ;;TM may wipe out the tokens held by a frozen account, reducing the supply
        can-pause:bool                              ;;TM may prevent all transactions of the token, apart from minting and burning
        is-paused:bool                              ;;Stores state of pause/unpause for the Token

        supply:decimal                              ;;Stores the Token Total Supply
        origin-mint:bool                            ;;If true, Origin Supply has already been minted
        origin-mint-amount:decimal                  ;;Store the Token's Origin Mint Amount

        role-transfer-amount:integer                ;;Stores how many accounts have Transfer Roles for the Token.
    )
    (defschema DPTF-BalanceSchema
        @doc "Schema that Stores Account Balances for DPTF Tokens (True Fungibles)\
        \ Key for the Table is a string composed of: \
        \ <DPTF Identifier> + BAR + <account> \
        \ This ensure a single entry per DPTF Identifier per account."

        balance:decimal                             ;;Stores DPFS balance for Account
        guard:guard                                 ;;Stores Guard for DPFS Account
        ;;Special Roles
        role-burn:bool                              ;;when true, Account can burn DPTF Tokens locally
        role-mint:bool                              ;;when true, Account can mint DPTF Tokens locally
        role-transfer:bool                          ;;when true, Transfer is restricted. Only accounts with true Transfer Role
                                                    ;;can transfer token, while all other accounts can only transfer to such accounts
        ;;States
        frozen:bool                                 ;;Determines wheter Account is frozen for DPTF Token Identifier
    )
    ;;3]TABLES Definitions
    (deftable DPTF-PropertiesTable:{DPTF-PropertiesSchema})
    (deftable DPTF-BalancesTable:{DPTF-BalanceSchema})

    
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
    ;;      DPTF_ADMIN                              Module Admin Capability                                                                             ;;
    ;;      DPTF_CLIENT                             Module Client Capability                                                                            ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      BASIC                                                                                                                                       ;;
    ;;                                                                                                                                                  ;;
    ;;======DPTF-PROPERTIES-TABLE-MANAGEMENT========                                                                                                    ;;
    ;;      DPTF_OWNER                              Enforces DPTF Token Ownership                                                                       ;;
    ;;      DPTF_CAN-CHANGE-OWNER_ON                Enforced DPTF Token Ownership can be changed                                                        ;;
    ;;      DPTF_CAN-UPGRADE_ON                     Enforces DPTF Token upgrade-ability                                                                 ;;
    ;;      DPTF_CAN-ADD-SPECIAL-ROLE_ON            Enforces Token Property as true                                                                     ;;
    ;;      DPTF_CAN-FREEZE_ON                      Enforces Token Property as true                                                                     ;;
    ;;      DPTF_CAN-WIPE_ON                        Enforces Token Property as true                                                                     ;;
    ;;      DPTF_CAN-PAUSE_ON                       Enforces Token Property as true                                                                     ;;
    ;;      DPTF_IS-PAUSED_ON                       Enforces that the DPTF Token is paused                                                              ;;
    ;;      DPTF_IS-PAUSED_OF                       Enforces that the DPTF Token is not paused                                                          ;;
    ;;      DPTF_ORGIN_VIRGIN                       Enforces Origin Mint hasn't been executed                                                           ;;
    ;;      DPTF_UPDATE_SUPPLY                      Capability required to update DPTF Supply                                                           ;;
    ;;======DPTF-BALANCES-TABLE-MANAGEMENT==========                                                                                                    ;;
    ;;      DPTF_ACCOUNT_OWNER                      Enforces DPTF Account Ownership                                                                     ;;
    ;;      DPTF_ACCOUNT_BURN_ON                    Enforces DPTF Account has burn role on                                                              ;;
    ;;      DPTF_ACCOUNT_BURN_OFF                   Enforces DPTF Account has burn role off                                                             ;;
    ;;      DPTF_ACCOUNT_MINT_ON                    Enforces DPTF Account has mint role on                                                              ;;
    ;;      DPTF_ACCOUNT_MINT_OFF                   Enforces DPTF Account has mint role off                                                             ;;
    ;;      DPTF_ACCOUNT_TRANSFER_ON                Enforces DPTF Account has transfer role on                                                          ;;
    ;;      DPTF_ACCOUNT_TRANSFER_OFF               Enforces DPTF Account has transfer role off                                                         ;;
    ;;      DPTF_ACCOUNT_FREEZE_ON                  Enforces DPTF Account is frozen                                                                     ;;
    ;;      DPTF_ACCOUNT_FREEZE_OFF                 Enforces DPTF Account is not frozen                                                                 ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      COMPOSED                                                                                                                                    ;;
    ;;                                                                                                                                                  ;;
    ;;==================CONTROL=====================                                                                                                    ;;
    ;;      DPTF_OWNERSHIP-CHANGE                   Capability required for for changing DPTF Ownership                                                 ;;
    ;;      DPTF_CONTROL                            Capability required for managing DPTF Properties                                                    ;;
    ;;      DPTF_PAUSE                              Capability required to Pause a DPTF                                                                 ;;
    ;;      DPTF_UNPAUSE                            Capability required to Unpause a DPTF                                                               ;;
    ;;      DPTF_FREEZE_ACCOUNT                     Capability required to Freeze a DPTF Account                                                        ;;
    ;;      DPTF_UNFREEZE_ACCOUNT                   Capability required to Unfreeze a DPTF Account                                                      ;;
    ;;==================SET=========================                                                                                                    ;;
    ;;      DPTF_SET_BURN-ROLE                      Capability required to Set Burn Role for DPTF Account                                               ;;
    ;;      DPTF_SET_MINT-ROLE                      Capability required to Set Mint Role for DPTF Account                                               ;;
    ;;      DPTF_SET_TRANSFER-ROLE                  Capability required to Set Transfer Role for DPTF Account                                           ;;
    ;;==================UNSET=======================                                                                                                    ;;
    ;;      DPTF_UNSET_BURN-ROLE                    Capability required to Unset Burn Role for a DPTF Account                                           ;;
    ;;      DPTF_UNSET_MINT-ROLE                    Capability required to Unset Mint Role for a DPTF Account                                           ;;
    ;;      DPTF_UNSET_TRANSFER-ROLE                Capability required to Unset Transfer Role for a DPTF Account                                       ;;
    ;;==================CREATE======================                                                                                                    ;;
    ;;      DPTF_MINT_ORIGIN                        Capability required to mint the Origin DPTF Mint Supply                                             ;;
    ;;      DPTF_MINT                               Capability required to mint a DPTF Token                                                            ;;
    ;;==================DESTROY=====================                                                                                                    ;;
    ;;      DPTF_BURN                               Capability required to burn a DPTF Token                                                            ;;
    ;;      DPTF_WIPE                               Capability required to Wipe a DPTF Token Balance from a DPTF account                                ;;
    ;;=================CORE=========================                                                                                                    ;;
    ;;      CREDIT_DPTF                             Capability to perform crediting operations with DPTF Tokens                                         ;;
    ;;      DEBIT_DPTF                              Capability to perform debiting operations on Normal DPTS Account types with DPTF Tokens             ;;
    ;;      DEBIT_DPTF_SC                           Capability to perform debiting operations on Smart(Contract) DPTS Account types with DPTF Tokens    ;;
    ;;      TRANSFER_DPTF                           Capability for transfer between 2 DPTS accounts for a specific DPTF Token identifier                ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;


    ;;==============================================
    ;;                                            ;;
    ;;      CAPABILITIES                          ;;
    ;;                                            ;;
    ;;      BASIC                                 ;;
    ;;                                            ;;
    ;;======DPTF-PROPERTIES-TABLE-MANAGEMENT========
    ;;
    ;;      DPTF_OWNER|DPTF_CAN-CHANGE-OWNER_ON|DPTF_CAN-UPGRADE_ON|DPTF_CAN-ADD-SPECIAL-ROLE_ON
    ;;      DPTF_CAN-FREEZE_ON|DPTF_CAN-WIPE_ON|DPTF_CAN-PAUSE_ON|DPTF_IS-PAUSED_ON|DPTF_IS-PAUSED_OF
    ;;      DPTF_UPDATE_SUPPLY
    ;;
    (defcap DPTF_OWNER (identifier:string)
        @doc "Enforces DPTF Token Ownership"
        (enforce-guard (UR_TrueFungibleOwner identifier))
    )
    (defcap DPTF_CAN-CHANGE-OWNER_ON (identifier:string)
        @doc "Enforces DPTF Token ownership is changeble"
        (let
            (
                (x:bool (UR_TrueFungibleCanChangeOwner identifier))
            )
            (enforce (= x true) (format "DPTF Token {} ownership cannot be changed" [identifier]))
        )
    )
    (defcap DPTF_CAN-UPGRADE_ON (identifier:string)
        @doc "Enforces DPTF Token is upgradeable"
        (let
            (
                (x:bool (UR_TrueFungibleCanUpgrade identifier))
            )
            (enforce (= x true) (format "DPTF Token {} properties cannot be upgraded" [identifier])
            )
        )
    )
    (defcap DPTF_CAN-ADD-SPECIAL-ROLE_ON (identifier:string)
        @doc "Enforces adding special roles for DPTF Token is true"
        (let
            (
                (x:bool (UR_TrueFungibleCanAddSpecialRole identifier))
            )
            (enforce (= x true) (format "For DPTF Token {} no special roles can be added" [identifier])
            )
        )
    )
    (defcap DPTF_CAN-FREEZE_ON (identifier:string)
        @doc "Enforces DPTF Token can be frozen"
        (let
            (
                (x:bool (UR_TrueFungibleCanFreeze identifier))
            )
            (enforce (= x true) (format "DPTF Token {} cannot be freezed" [identifier])
            )
        )
    )
    (defcap DPTF_CAN-WIPE_ON (identifier:string)
        @doc "Enforces DPTF Token Property can be wiped"
        (let
            (
                (x:bool (UR_TrueFungibleCanWipe identifier))
            )
            (enforce (= x true) (format "DPTF Token {} cannot be wiped" [identifier])
            )
        )
    )
    (defcap DPTF_CAN-PAUSE_ON (identifier:string)
        @doc "Enforces DPTF Token can be paused"
        (let
            (
                (x:bool (UR_TrueFungibleCanPause identifier))
            )
            (enforce (= x true) (format "DPTF Token {} cannot be paused" [identifier])
            )
        )
    )
    (defcap DPTF_IS-PAUSED_ON (identifier:string)
        @doc "Enforces that the DPTF Token is paused"
        (let
            (
                (x:bool (UR_TrueFungibleIsPaused identifier))
            )
            (enforce (= x true) (format "DPTF Token {} is already unpaused" [identifier])
            )
        )
    )
    (defcap DPTF_IS-PAUSED_OFF (identifier:string)
        @doc "Enforces that the DPTF Token is not paused"
        (let
            (
                (x:bool (UR_TrueFungibleIsPaused identifier))
            )
            (enforce (= x false) (format "DPTF Token {} is already paused" [identifier])
            )
        )
    )
    (defcap DPTF_ORIGIN_VIRGIN (identifier:string)
        @doc "Enforces Origin Mint hasn't been executed"
        (let
            (
                (om:bool (UR_TrueFungibleOriginMint identifier) false)
                (oma:decimal (UR_TrueFungibleOriginAmount identifier))
            )
            (enforce
                (and (= om false) (= oma 0.0))
                (format "Origin Mint for DPTF {} cannot be executed any more !" [identifier])
            )
        )
    )
    (defcap DPTF_UPDATE_SUPPLY (identifier:string amount:decimal) 
        @doc "Capability required to update DPTF Supply"
        (UV_TrueFungibleAmount identifier amount)
        true
    )
    ;;
    ;;======DPTF-BALANCES-TABLE-MANAGEMENT==========
    ;;
    ;;      DPTF_ACCOUNT_OWNER
    ;;      DPTF_ACCOUNT_BURN_ON|DPTF_ACCOUNT_BURN_OFF
    ;;      DPTF_ACCOUNT_MINT_ON|DPTF_ACCOUNT_MINT_OFF
    ;;      DPTF_ACCOUNT_TRANSFER_ON|DPTF_ACCOUNT_TRANSFER_OFF
    ;;      DPTF_ACCOUNT_FREEZE_ON|DPTF_ACCOUNT_FREEZE_OFF
    ;;
    (defcap DPTF_ACCOUNT_OWNER (identifier:string account:string)
        @doc "Enforces DPTF Account Ownership"
        (enforce-guard (UR_AccountTrueFungibleGuard identifier account))
    )
    (defcap DPTF_ACCOUNT_BURN_ON (identifier:string account:string)
        @doc "Enforces DPTF Account has burn role on"
        (let
            (
                (x:bool (UR_AccountTrueFungibleRoleBurn identifier account))
            )
            (enforce (= x true) (format "Account {} isnt allowed to burn DPTF {} Token" [account identifier])
            )
        )
    )
    (defcap DPTF_ACCOUNT_BURN_OFF (identifier:string account:string)
        @doc "Enforces DPTF Account has burn role off"
        (let
            (
                (x:bool (UR_AccountTrueFungibleRoleBurn identifier account))
            )
            (enforce (= x false) (format "Account {} is allowed to burn DPTF {} Token" [account identifier])
            )
        )
    )
    (defcap DPTF_ACCOUNT_MINT_ON (identifier:string account:string)
        @doc "Enforces DPTF Account has mintrole on"
        (let
            (
                (x:bool (UR_AccountTrueFungibleRoleMint identifier account))
            )
            (enforce (= x true) (format "Account {} isnt allowed to mintDPTF {} Token" [account identifier])
            )
        )
    )
    (defcap DPTF_ACCOUNT_MINT_OFF (identifier:string account:string)
        @doc "Enforces DPTF Account has mint role off"
        (let
            (
                (x:bool (UR_AccountTrueFungibleRoleMint identifier account))
            )
            (enforce (= x false) (format "Account {} is allowed to mint DPTF {} Token" [account identifier])
            )
        )
    )
    (defcap DPTF_ACCOUNT_TRANSFER_ON (identifier:string account:string)
        @doc "Enforces DPTF Account has transfer role on"
        (let
            (
                (x:bool (UR_AccountTrueFungibleRoleTransfer identifier account))
            )
            (enforce (= x true) (format "Account {} doesnt have a valid transfer role for DPTF {} Token" [account identifier])
            )
        )
    )
    (defcap DPTF_ACCOUNT_TRANSFER_OFF (identifier:string account:string)
        @doc "Enforces DPTF Account has transfer role off"
        (let
            (
                (x:bool (UR_AccountTrueFungibleRoleTransfer identifier account))
            )
            (enforce (= x false) (format "Account {} has a valid transfer role for DPTF {} Token" [account identifier])
            )
        )
    )
    (defcap DPTF_ACCOUNT_FREEZE_ON (identifier:string account:string)
        @doc "Enforces DPTF Account is frozen"
        (let
            (
                (x:bool (UR_AccountTrueFungibleFrozenState identifier account))
            )
            (enforce (= x true) (format "Account {} isnt frozen for DPTF {} Token" [account identifier])
            )
        )
    )
    (defcap DPTF_ACCOUNT_FREEZE_OFF (identifier:string account:string)
        @doc "Enforces DPTF Account is not frozen"
        (let
            (
                (x:bool (UR_AccountTrueFungibleFrozenState identifier account))
            )
            (enforce (= x false) (format "Account {} is frozen for DPTF {} Token" [account identifier])
            )
        )
    )
    ;;
    ;;----------------------------------------------
    ;;                                            ;;
    ;;      COMPOSED                              ;;
    ;;                                            ;;
    ;;==================CONTROL=====================
    ;;
    ;;      DPTF_OWNERSHIP-CHANGE|DPTF_CONTROL
    ;;      DPTF_PAUSE|DPTF_UNPAUSE
    ;;      DPTF_FREEZE_ACCOUNT|DPTF_UNFREEZE_ACCOUNT
    ;;
    (defcap DPTF_OWNERSHIP-CHANGE (identifier:string new-owner:string)
        @doc "Capability required for changing DPTF Token Ownership"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account new-owner)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-CHANGE-OWNER_ON identifier))
    )
    (defcap DPTF_CONTROL (identifier:string)
        @doc "Capability required for managing DPTF Properties"
        (UV_TrueFungibleIdentifier identifier)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-UPGRADE_ON identifier))
    )
    (defcap DPTF_PAUSE (identifier:string)
        @doc "Capability required to Pause a DPTF Token"
        (UV_TrueFungibleIdentifier identifier)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-PAUSE_ON identifier))
        (compose-capability (DPTF_IS-PAUSED_OFF identifier))
    )
    (defcap DPTF_UNPAUSE (identifier:string)
        @doc "Capability required to Unpause a DPTF Token"
        (UV_TrueFungibleIdentifier identifier)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-PAUSE_ON identifier))
        (compose-capability (DPTF_IS-PAUSED_ON identifier))
    )
    (defcap DPTF_FREEZE_ACCOUNT (identifier:string account:string)
        @doc "Capability required to Freeze a DPTF Account"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-FREEZE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_FREEZE_OFF identifier account))
    )
    (defcap DPTF_UNFREEZE_ACCOUNT (identifier:string account:string)
        @doc "Capability required to Unfreeze a DPTF Account"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-FREEZE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_FREEZE_ON identifier account))
    )
    ;;
    ;;==================SET=========================
    ;;
    ;;      DPTF_SET_BURN-ROLE|DPTF_SET_MINT-ROLE|DPTF_SET_TRANSFER-ROLE
    ;;
    (defcap DPTF_SET_BURN-ROLE (identifier:string account:string)
        @doc "Capability required to Set Burn Role for DPTF Account"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_BURN_OFF identifier account))
    )
    (defcap DPTF_SET_MINT-ROLE (identifier:string account:string)
        @doc "Capability required to Set Mint Role for DPTF Account"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_MINT_OFF identifier account))
    )
    (defcap DPTF_SET_TRANSFER-ROLE (identifier:string account:string)
        @doc "Capability required to Set Transfer Role for DPTF Account"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_TRANSFER_OFF identifier account))
    )
    ;;==================UNSET=======================
    ;;
    ;;      DPTF_UNSET_BURN-ROLE|DPTF_UNSET_MINT-ROLE|DPTF_UNSET_TRANSFER-ROLE
    ;;
    (defcap DPTF_UNSET_BURN-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Burn Role for DPTF Account"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_ACCOUNT_BURN_ON identifier account))
    )
    (defcap DPTF_UNSET_MINT-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Mint Role for DPTF Account"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_ACCOUNT_MINT_ON identifier account))
    )
    (defcap DPTF_UNSET_TRANSFER-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Transfer Role for DPTF Account"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_ACCOUNT_TRANSFER_ON identifier account))
    )
    ;;==================CREATE======================
    ;;
    ;;      DPTF_MINT_ORIGIN|DPTF_MINT
    ;;
    (defcap DPTF_MINT_ORIGIN (identifier:string account:string amount:decimal)
        @doc "Capability required to mint the Origin DPTF Mint Supply"
        (UV_TrueFungibleAmount identifier amount)
        (DPTS.UV_DPTS-Account account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CLIENT identifier account))
        (compose-capability (DPTF_ORIGIN_VIRGIN identifier))
        (compose-capability (CREDIT_DPTF identifier account))
        (compose-capability (DPTF_UPDATE_SUPPLY identifier amount))
    )
    (defcap DPTF_MINT (identifier:string account:string amount:decimal)
        @doc "Capability required to mint a DPTF Token locally \
            \ Smart-Contract Account type doesnt require their guard|key"
        (UV_TrueFungibleAmount identifier amount)
        (DPTS.UV_DPTS-Account account)
        (compose-capability (DPTF_CLIENT identifier account))
        (compose-capability (DPTF_ACCOUNT_MINT_ON identifier account))
        (compose-capability (CREDIT_DPTF identifier account))
        (compose-capability (DPTF_UPDATE_SUPPLY identifier amount))
    )
    ;;==================DESTROY=====================
    ;;
    ;;      DPTF_BURN|DPTF_WIPE
    ;;
    (defcap DPTF_BURN (identifier:string account:string amount:decimal)
        @doc "Capability required to burn a DPTF Token locally \
            \ Smart-Contract Account type doesnt require their guard|key"
        (UV_TrueFungibleAmount identifier amount)
        (DPTS.UV_DPTS-Account account)
        (compose-capability (DPTF_ACCOUNT_BURN_ON identifier account))
        (compose-capability (DEBIT_DPTF identifier account))
        (compose-capability (DPTF_UPDATE_SUPPLY identifier amount))
    )

    (defcap DPTF_WIPE (identifier:string account:string amount:decimal)
        @doc "Capability required to Wipe a DPTF Token Balance from a DPTF account"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-WIPE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_FREEZE_ON identifier account))
        (compose-capability (DPTF_UPDATE_SUPPLY identifier amount))
    )
    ;;=================CORE=========================
    ;;
    ;;      CREDIT_DPTF|DEBIT_DPTF|TRANSFER_DPTF
    ;;
    (defcap CREDIT_DPTF (identifier:string account:string)
        @doc "Capability to perform crediting operations with DPTF Tokens"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
    )
    (defcap DEBIT_DPTF (identifier:string account:string)
        @doc "Capability to perform debiting operations on a Normal DPTS Account type for a DPTF Token"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)

        (compose-capability (DPTF_CLIENT identifier account))
    )
    (defcap TRANSFER_DPTF (identifier:string sender:string receiver:string amount:decimal method:bool)
        @doc "Capability for transfer between 2 DPTS accounts for a specific DPTF Token identifier"

        (UV_TrueFungibleAmount identifier amount)
        (DPTS.UV_SenderWithReceiver sender receiver)

        (compose-capability (DPTF_IS-PAUSED_OFF identifier))
        (compose-capability (DPTF_ACCOUNT_FREEZE_OFF identifier sender))
        (compose-capability (DPTF_ACCOUNT_FREEZE_OFF identifier receiver))
        (with-read DPTF-PropertiesTable identifier
            { "role-transfer-amount" := rta }
            (if (!= rta 0)
                ;;if true
                (enforce-one
                    (format "Neither the sender {} nor the receiver {} have an active transfer role" [sender receiver])
                    [
                        (compose-capability (DPTF_ACCOUNT_TRANSFER_ON identifier sender))
                        (compose-capability (DPTF_ACCOUNT_TRANSFER_ON identifier receiver))
                    ]
                )
                ;;if false
                (format "No transfer Role restrictions exist for Token {}" [identifier])
            )
        )

        (compose-capability (DPTS.SC_TRANSFERABILITY sender receiver method))
        (compose-capability (DEBIT_DPTF identifier sender))  
        (compose-capability (CREDIT_DPTF identifier receiver))
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
    ;;      UR_AccountTrueFungibles                 Returns a List of Truefungible Identifiers held by DPTF Accounts <account>                          ;;
    ;;      UR_AccountTrueFungibleSupply            Returns Account <account> True Fungible <identifier> Supply                                         ;;
    ;;      UR_AccountTrueFungibleGuard             Returns Account <account> True Fungible <identifier> Guard                                          ;;
    ;;      UR_AccountTrueFungibleRoleBurn          Returns Account <account> True Fungible <identifier> Burn Role                                      ;;
    ;;      UR_AccountTrueFungibleRoleMint          Returns Account <account> True Fungible <identifier> Mint Role                                      ;;
    ;;      UR_AccountTrueFungibleRoleTransfer      Returns Account <account> True Fungible <identifier> Transfer Role                                  ;;
    ;;      UR_AccountTrueFungibleFrozenState       Returns Account <account> True Fungible <identifier> Frozen State                                   ;;
    ;;==================TRUE-FUNGIBLE-INFO==========                                                                                                    ;;
    ;;      UR_TrueFungibleOwner                    Returns True Fungible <identifier> Owner                                                            ;;
    ;;      UR_TrueFungibleName                     Returns True Fungible <identifier> Name                                                             ;;
    ;;      UR_TrueFungibleTicker                   Returns True Fungible <identifier> Ticker                                                           ;;
    ;;      UR_TrueFungibleDecimals                 Returns True Fungible <identifier> Decimals                                                         ;;
    ;;      UR_TrueFungibleCanChangeOwner           Returns True Fungible <identifier> Boolean can-change-owner                                         ;;
    ;;      UR_TrueFungibleCanUpgrade               Returns True Fungible <identifier> Boolean can-upgrade                                              ;;
    ;;      UR_TrueFungibleCanAddSpecialRole        Returns True Fungible <identifier> Boolean can-add-special-role                                     ;;
    ;;      UR_TrueFungibleCanFreeze                Returns True Fungible <identifier> Boolean can-freeze                                               ;;
    ;;      UR_TrueFungibleCanWipe                  Returns True Fungible <identifier> Boolean can-wipe                                                 ;;
    ;;      UR_TrueFungibleCanPause                 Returns True Fungible <identifier> Boolean can-pause                                                ;;
    ;;      UR_TrueFungibleIsPaused                 Returns True Fungible <identifier> Boolean is-paused                                                ;;
    ;;      UR_TrueFungibleSupply                   Returns True Fungible <identifier> Total Supply                                                     ;;
    ;;      UR_TrueFungibleOriginMint               Returns True Fungible <identifier> Boolean origin-mint                                              ;;
    ;;      UR_TrueFungibleOriginAmount             Returns True Fungible <identifier> Origin Mint Amount                                               ;;
    ;;      UR_TrueFungibleTransferRoleAmount       Returns True Fungible <identifier> Transfer Role Amount                                             ;;
    ;;==================VALIDATIONS=================                                                                                                    ;;
    ;;      UV_TrueFungibleAmount                   Enforces the Amount <amount> is positive its decimal size conform for TrueFungible <identifier>     ;;
    ;;      UV_TrueFungibleIdentifier               Enforces the TrueFungible <identifier> exists                                                       ;;
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
    ;;      C_ChangeOwnership                       Moves DPTF <identifier> Token Ownership to <new-owner> DPTF Account                                 ;;
    ;;      C_Control                               Controls TrueFungible <identifier> Properties using 7 boolean control triggers                      ;;
    ;;      C_Pause                                 Pause TrueFungible <identifier>                                                                     ;;
    ;;      C_Unpause                               Unpause TrueFungible <identifier>                                                                   ;;
    ;;      C_FreezeAccount                         Freeze TrueFungile <identifier> on DPTF Account <account>                                           ;;
    ;;      C_UnfreezeAccount                       Unfreeze TrueFungile <identifier> on DPTF Account <account>                                         ;;
    ;;==================SET=========================                                                                                                    ;;
    ;;      C_SetBurnRole                           Sets |role-burn| to true for TrueFungible <identifier> and DPTF Account <account>                   ;;
    ;;      C_SetMintRole                           Sets |role-mint| to true for TrueFungible <identifier> and DPTF Account <account>                   ;;
    ;;      C_SetTransferRole                       Sets |role-transfer| to true for TrueFungible <identifier> and DPTF Account <account>               ;;
    ;;==================UNSET=======================                                                                                                    ;;
    ;;      C_UnsetBurnRole                         Sets |role-burn| to false for TrueFungible <identifier> and DPTF Account <account>                  ;;
    ;;      C_UnsetMintRole                         Sets |role-mint| to false for TrueFungible <identifier> and DPTF Account <account>                  ;;
    ;;      C_UnsetTransferRole                     Sets |role-transfer| to false for TrueFungible <identifier> and DPTF Account <account>              ;;
    ;;==================CREATE======================                                                                                                    ;;
    ;;      C_IssueTrueFungible                     Issues a new TrueFungible                                                                           ;;
    ;;      C_DeployTrueFungibleAccount             Creates a new DPTF Account for TrueFungible <identifier> and Account <account>                      ;;
    ;;      C_MintOrigin                            Mints <amount> <identifier> TrueFungible for DPTF Account <account> as initial mint amount          ;;
    ;;      C_Mint                                  Mints <amount> <identifier> TrueFungible for DPTF Account <account>                                 ;;
    ;;==================DESTROY=====================                                                                                                    ;;
    ;;      C_Burn                                  Burns <amount> <identifier> TrueFungible on DPTF Account <account>                                  ;;
    ;;      C_Wipe                                  Wipes the whole supply of <identifier> TrueFungible of a frozen DPTF Account <account>              ;;
    ;;==================TRANSFER====================                                                                                                    ;;
    ;;      C_TransferTrueFungible                  Transfers <identifier> TrueFungible from <sender> to <receiver> DPMF Account                        ;;
    ;;      C_TransferTrueFungibleAnew              Same as |C_TransferTrueFungible| but with DPTF Account creation                                     ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      AUXILIARY FUNCTIONS                                                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================TRANSFER====================                                                                                                    ;;
    ;;      X_MethodicTransferTrueFungible          Methodic transfers <identifier> TrueFungible from <sender> to <receiver> DPTF Account               ;;
    ;;      X_MethodicTransferTrueFungibleAnew      Same as |X_MethodicTransferMetaFungible| but with DPTF Account creation                             ;;
    ;;==================CREDIT|DEBIT================                                                                                                    ;;
    ;;      X_Credit                                Auxiliary Function that credits a TrueFungible to a DPTF Account                                    ;;
    ;;      X_Debit                                 Auxiliary Function that debits a TrueFungible from a DPTF Account                                   ;;
    ;;==================UPDATE======================                                                                                                    ;;
    ;;      X_UpdateSupply                          Updates <identifier> TrueFungible supply. Boolean <direction> used for increase|decrease            ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;


    ;;==============================================
    ;;                                            ;;
    ;;      UTILITY FUNCTIONS                     ;;
    ;;                                            ;;
    ;;==================ACCOUNT-INFO================
    ;;
    ;;      UR_AccountTrueFungibles
    ;;      UR_AccountTrueFungibleSupply|UR_AccountTrueFungibleGuard
    ;;      UR_AccountTrueFungibleRoleBurn|UR_AccountTrueFungibleRoleMint
    ;;      UR_AccountTrueFungibleRoleTransfer|UR_AccountTrueFungibleFrozenState
    ;;
    (defun UR_AccountTrueFungibles:[string] (account:string)
        @doc "Returns a List of Truefungible Identifiers held by DPTF Accounts <account>"
        (DPTS.UV_DPTS-Account account)
        (let*
            (
                (keyz:[string] (keys DPTF-BalancesTable))
                (listoflists:[[string]] (map (lambda (x:string) (DPTS.UC_SplitString DPTS.BAR x)) keyz))
                (dptf-account-tokens:[string] (DPTS.UC_FilterIdentifier listoflists account))
            )
            dptf-account-tokens
        )
    )
    (defun UR_AccountTrueFungibleSupply:decimal (identifier:string account:string)
        @doc "Returns Account <account> True Fungible <identifier> Supply"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (with-default-read DPTF-BalancesTable (concat [identifier BAR account])
            { "balance" : 0.0 }
            { "balance" := b}
            b
        )
    )
    (defun UR_AccountTrueFungibleGuard:guard (identifier:string account:string)
        @doc "Returns Account <account> True Fungible <identifier> Guard"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (at "guard" (read DPTF-BalancesTable (concat [identifier BAR account]) ["guard"]))
    )
    (defun UR_AccountTrueFungibleRoleBurn:bool (identifier:string account:string)
        @doc "Returns Account <account> True Fungible <identifier> Burn Role"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (at "role-burn" (read DPTF-BalancesTable (concat [identifier BAR account]) ["role-burn"]))
    )
    (defun UR_AccountTrueFungibleRoleMint:bool (identifier:string account:string)
        @doc "Returns Account <account> True Fungible <identifier> Mint Role"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (at "role-mint" (read DPTF-BalancesTable (concat [identifier BAR account]) ["role-mint"]))
    )
    (defun UR_AccountTrueFungibleRoleTransfer:bool (identifier:string account:string)
        @doc "Returns Account <account> True Fungible <identifier> Transfer Role \
            \ with-default-read assumes the role is always false for not existing accounts \
            \ Needed for Transfer Anew functions"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (with-default-read DPTF-BalancesTable (concat [identifier BAR account])
            { "role-transfer" : false }
            { "role-transfer" := rt }
            rt
        )
    )
    (defun UR_AccountTrueFungibleFrozenState:bool (identifier:string account:string)
        @doc "Returns Account <account> True Fungible <identifier> Frozen State\
            \ with-default-read assumes the role is always false for not existing accounts \
            \ Needed for Transfer Anew functions"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (with-default-read DPTF-BalancesTable (concat [identifier BAR account])
            { "frozen" : false}
            { "frozen" := fr }
            fr
        )
    )
    ;;
    ;;==================TRUE-FUNGIBLE-INFO==========
    ;;
    ;;      UR_TrueFungibleOwner|UR_TrueFungibleName|UR_TrueFungibleTicker|UR_TrueFungibleDecimals
    ;;      UR_TrueFungibleCanChangeOwner|UR_TrueFungibleCanUpgrade|UR_TrueFungibleCanAddSpecialRole
    ;;      UR_TrueFungibleCanFreeze|UR_TrueFungibleCanWipe|UR_TrueFungibleCanPause|UR_TrueFungibleIsPaused
    ;;      UR_TrueFungibleSupply|UR_TrueFungibleOriginMint|UR_TrueFungibleOriginAmount|UR_TrueFungibleTransferRoleAmount
    ;;
    (defun UR_TrueFungibleOwner:guard (identifier:string)
        @doc "Returns True Fungible <identifier> Owner"
        (UV_TrueFungibleIdentifier identifier)
        (at "owner" (read DPTF-PropertiesTable identifier ["owner"]))
    )
    (defun UR_TrueFungibleName:string (identifier:string)
        @doc "Returns True Fungible <identifier> Name"
        (UV_TrueFungibleIdentifier identifier)
        (at "name" (read DPTF-PropertiesTable identifier ["name"]))
    )
    (defun UR_TrueFungibleTicker:string (identifier:string)
        @doc "Returns True Fungible <identifier> Name"
        (UV_TrueFungibleIdentifier identifier)
        (at "ticker" (read DPTF-PropertiesTable identifier ["ticker"]))
    )
    (defun UR_TrueFungibleDecimals:integer (identifier:string)
        @doc "Returns <identifier> DPTF Token Decimal size"
        (UV_TrueFungibleIdentifier identifier)
        (at "decimals" (read DPTF-PropertiesTable identifier ["decimals"]))
    )
    (defun UR_TrueFungibleCanChangeOwner:bool (identifier:string)
        @doc "Returns True Fungible <identifier> Boolean can-change-owner"
        (UV_TrueFungibleIdentifier identifier)
        (at "can-change-owner" (read DPTF-PropertiesTable identifier ["can-change-owner"]))
    )
    (defun UR_TrueFungibleCanUpgrade:bool (identifier:string)
        @doc "Returns True Fungible <identifier> Boolean can-upgrade"
        (UV_TrueFungibleIdentifier identifier)
        (at "can-upgrade" (read DPTF-PropertiesTable identifier ["can-upgrade"]))
    )
    (defun UR_TrueFungibleCanAddSpecialRole:bool (identifier:string)
        @doc "Returns True Fungible <identifier> Boolean can-add-special-role"
        (UV_TrueFungibleIdentifier identifier)
        (at "can-add-special-role" (read DPTF-PropertiesTable identifier ["can-add-special-role"]))
    )
    (defun UR_TrueFungibleCanFreeze:bool (identifier:string)
        @doc "Returns True Fungible <identifier> Boolean can-freeze"
        (UV_TrueFungibleIdentifier identifier)
        (at "can-freeze" (read DPTF-PropertiesTable identifier ["can-freeze"]))
    )
    (defun UR_TrueFungibleCanWipe:bool (identifier:string)
        @doc "Returns True Fungible <identifier> Boolean can-wipe"
        (UV_TrueFungibleIdentifier identifier)
        (at "can-wipe" (read DPTF-PropertiesTable identifier ["can-wipe"]))
    )
    (defun UR_TrueFungibleCanPause:bool (identifier:string)
        @doc "Returns True Fungible <identifier> Boolean can-pause"
        (UV_TrueFungibleIdentifier identifier)
        (at "can-pause" (read DPTF-PropertiesTable identifier ["can-pause"]))
    )
    (defun UR_TrueFungibleIsPaused:bool (identifier:string)
        @doc "Returns True Fungible <identifier> Boolean is-paused"
        (UV_TrueFungibleIdentifier identifier)
        (at "is-paused" (read DPTF-PropertiesTable identifier ["is-paused"]))
    )
    (defun UR_TrueFungibleSupply:decimal (identifier:string)
        @doc "Returns True Fungible <identifier> Total Supply "
        (UV_TrueFungibleIdentifier identifier)
        (at "supply" (read DPTF-PropertiesTable identifier ["supply"]))
    )
    (defun UR_TrueFungibleOriginMint:bool (identifier:string)
        @doc "Returns True Fungible <identifier> Boolean origin-mint"
        (UV_TrueFungibleIdentifier identifier)
        (at "origin-mint" (read DPTF-PropertiesTable identifier ["origin-mint"]))
    )
    (defun UR_TrueFungibleOriginAmount:decimal (identifier:string)
        @doc "Returns True Fungible <identifier> Origin Mint Amount"
        (UV_TrueFungibleIdentifier identifier)
        (at "origin-mint-amount" (read DPTF-PropertiesTable identifier ["origin-mint-amount"]))
    )
    (defun UR_TrueFungibleTransferRoleAmount:integer (identifier:string)
        @doc "Returns True Fungible <identifier> Transfer Role Amount "
        (UV_TrueFungibleIdentifier identifier)
        (at "role-transfer-amount" (read DPTF-PropertiesTable identifier ["role-transfer-amount"]))
    )
    ;;
    ;;==================VALIDATIONS=================
    ;;
    ;;      UV_TrueFungibleAmount|UV_TrueFungibleIdentifier
    ;;
    (defun UV_TrueFungibleAmount (identifier:string amount:decimal)
        @doc "Enforce the minimum denomination for a specific DPTF identifier \
        \ and ensure the amount is greater than zero"
        (UV_TrueFungibleIdentifier identifier)

        (with-read DPTF-PropertiesTable identifier
            { "decimals" := d }
            (enforce
                (= (floor amount d) amount)
                (format "The amount of {} does not conform with the {} decimals number" [amount identifier])
            )
            (enforce
                (> amount 0.0)
                (format "The amount of {} is not a Valid Transaction amount" [amount])
            )
        )
    )
    (defun UV_TrueFungibleIdentifier (identifier:string)
        @doc "Enforces Identifier existance"
        (with-default-read DPTF-PropertiesTable identifier
            { "supply" : -1.0 }
            { "supply" := s }
            (enforce
                (>= s 0.0)
                (format "Identifier {} does not exist." [identifier])
            )
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
    ;;      C_Pause|C_Unpause|C_FreezeAccount|C_UnfreezeAccount
    ;;
    (defun C_ChangeOwnership (identifier:string new-owner:string)
        @doc "Moves DPTF <identifier> Token Ownership to <new-owner> DPTF Account"

        (with-capability (DPTF_OWNERSHIP-CHANGE identifier new-owner)
            (update DPTF-PropertiesTable identifier
                {"owner"                            : new-owner}
            )
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
        )
        @doc "Controls TrueFungible <identifier> Properties using 7 boolean control triggers \
            \ Setting the <can-upgrade> property to false disables all future Control of Properties"

        (with-capability (DPTF_CONTROL identifier)
            (update DPTF-PropertiesTable identifier
                {"can-change-owner"                 : can-change-owner
                ,"can-upgrade"                      : can-upgrade
                ,"can-add-special-role"             : can-add-special-role
                ,"can-freeze"                       : can-freeze
                ,"can-wipe"                         : can-wipe
                ,"can-pause"                        : can-pause}
            )
        ) 
    )
    (defun C_Pause (identifier:string)
        @doc "Pause TrueFungible <identifier>"

        (with-capability (DPTF_PAUSE identifier)
            (update DPTF-PropertiesTable identifier { "is-paused" : true})
        )
    )
    (defun C_Unpause (identifier:string)
        @doc "Unpause TrueFungible <identifier>"

        (with-capability (DPTF_UNPAUSE identifier)
            (update DPTF-PropertiesTable identifier { "is-paused" : false})
        )
    )
    (defun C_FreezeAccount (identifier:string account:string)
        @doc "Freeze TrueFungile <identifier> on DPTF Account <account>"

        (with-capability (DPTF_FREEZE_ACCOUNT identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account]) { "frozen" : true})
        )
    )
    (defun C_Unfreezeccount (identifier:string account:string)
        @doc "Unfreeze TrueFungile <identifier> on DPTF Account <account>"

        (with-capability (DPTF_UNFREEZE_ACCOUNT identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account]) { "frozen" : false})
        )
    )
    ;;
    ;;==================SET========================= 
    ;;
    ;;      C_SetBurnRole|C_SetMintRole|C_SetTransferRole
    ;;
    (defun C_SetBurnRole (identifier:string account:string)
        @doc "Sets |role-burn| to true for TrueFungible <identifier> and DPTF Account <account> \
            \ Afterwards Account <account> can burn existing TrueFungible"

        (with-capability (DPTF_SET_BURN-ROLE identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"role-burn" : true}
            )
        )
    )
    (defun C_SetMintRole (identifier:string account:string)
        @doc "Sets |role-mint| to true for TrueFungible <identifier> and DPTF Account <account> \
            \ Afterwards Account <account> can mint TrueFungible"

        (with-capability (DPTF_SET_MINT-ROLE identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"role-mint" : true}
            )
        )
    )
    (defun C_SetTransferRole (identifier:string account:string)
        @doc "Sets |role-transfer| to true for TrueFungible <identifier> and DPTF Account <account> \
            \ If at least one DPTF Account has the |role-transfer|set to true, then all normal transfer are restricted \
            \ Transfer will only work towards DPTF Accounts with |role-trasnfer| true, \
            \ while these DPTF Accounts can transfer the TrueFungible unrestricted to any other DPTF Account"

        (with-capability (DPTF_SET_TRANSFER-ROLE identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"role-transfer" : true}
            )
        )
        (with-read DPTF-PropertiesTable identifier
            { "role-transfer-amount" := rta }
            (update DPTF-PropertiesTable identifier
                {"role-transfer-amount" : (+ rta 1)}
            )
        )
    )
    ;;
    ;;==================UNSET=======================
    ;;
    ;;      C_UnsetBurnRole|C_UnsetMintRole|C_UnsetTransferRole
    ;;
    (defun C_UnsetBurnRole (identifier:string account:string)
        @doc "Sets |role-burn| to false for TrueFungible <identifier> and DPTF Account <account> \
            \ Afterwards Account <account> can no longer burn existing TrueFungible"

        (with-capability (DPTF_UNSET_BURN-ROLE identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"role-burn" : false}
            )
        )
    )
    (defun C_UnsetMintRole (identifier:string account:string)
        @doc "Sets |role-mint| to false for TrueFungible <identifier> and DPTF Account <account> \
            \ Afterwards Account <account> can no longer mint existing TrueFungible"

        (with-capability (DPTF_UNSET_MINT-ROLE identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"role-mint" : false}
            )
        )
    )
    (defun C_UnsetTransferRole (identifier:string account:string)
        @doc "Sets |role-transfer| to false for TrueFungible <identifier> and DPTF Account <account> \
            \ If at least one DPTF Account has the |role-transfer|set to true, then all normal transfer are restricted \
            \ Transfer will only work towards DPTF Accounts with |role-trasnfer| true, \
            \ while these DPTF Accounts can transfer the TrueFungible unrestricted to any other DPTF Account"

        (with-capability (DPTF_UNSET_TRANSFER-ROLE identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"role-burn" : false}
            )
        )
        (with-read DPTF-PropertiesTable identifier
            { "role-transfer-amount" := rta }
            (update DPTF-PropertiesTable identifier
                {"role-transfer-amount" : (- rta 1)}
            )
        )
    )
    ;;
    ;;==================CREATE====================== 
    ;;
    ;;      C_IssueTrueFungible|C_DeployTrueFungibleAccount
    ;;      C_MintOrigin|C_Mint
    ;;
    (defun C_IssueTrueFungible:string 
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
        )
        @doc "Issue a new TrueFungible \
            \ This creates an entry into the DPTF-PropertiesTable \
            \ Such an entry means the DPTF Token has been created. Function outputs as string the Token-Identifier \
            \ Token Identifier is formed from ticker, followed by a dash, \ 
            \ followed by the first 12 characters of the previous block hash to ensure uniqueness. \
            \ \
            \ Furthermore, The issuer creates a Standard DPTF Account for himself, as the first Account of this DPTF Token \
            \ By default, DPTF Account creation also creates a Standard DPTS Account, if it doesnt exist"
        (DPTS.UV_DPTS-Name name)
        ;; Enforce Ticker is part of identifier variable below
        (DPTS.UV_DPTS-Decimals decimals)

        (let
            (
                (identifier (DPTS.UC_MakeIdentifier ticker))
            )
            ;; Add New Entries in the DPTF-PropertyTable
            ;; Since the Entry uses insert command, the KEY uniquness is ensured, since it will fail if key already exists.
            ;; Entry is initialised with "is-paused" set to off(false).
            ;; Entry is initialised with a supply of 0.0 (decimal)
            ;; Entry is initialised with a false switch on the origin-mint, meaning origin mint hasnt been executed
            ;; Entry is initialised with an origin-mint-amount of 0.0, meaning origin mint hasnt been executed
            ;; Entry is initiated with o to role-transfer-amount, since no Account will transfer role upon creation.
            (insert DPTF-PropertiesTable identifier
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
                ,"supply"               : 0.0
                ,"origin-mint"          : false
                ,"origin-mint-amount"   : 0.0
                ,"role-transfer-amount" : 0}
            )
            ;;Makes a new DPTF Account for the Token Issuer.
            (C_DeployTrueFungibleAccount identifier account owner)
            ;;Returns the unique Token Identifier
            identifier
        )
    )
    (defun C_DeployTrueFungibleAccount (identifier:string account:string guard:guard)
        @doc "Creates a new DPTF Account for TrueFungible <identifier> and Account <account> \
            \ If a DPTF Account already exists for <identifier> and <account>, it remains as is \
            \ \
            \ A Standard DPTS Account is also created, if one doesnt exist \
            \ If a DPTS Account exists, its type remains unchanged"
        (UV_TrueFungibleIdentifier identifier)
        (DPTS.UV_DPTS-Account account)
        (DPTS.UV_EnforceReserved account guard)

        ;;Automatically creates a Standard DPTS Account for <account> if one doesnt exists
        ;;If a DPTS Account exists for <account>, it remains as is
        (DPTS.C_DeployStandardDPTSAccount account guard)

        ;;Creates new Entry in the DPTF-BalancesTable for <identifier>|<account>
        ;;If Entry exists, no changes are being done
        (with-default-read DPTF-BalancesTable (concat [identifier BAR account])
            { "balance" : 0.0
            , "guard" : guard
            , "role-burn" : false
            , "role-mint" : false
            , "role-transfer" : false
            , "frozen" : false}
            { "balance" := b
            , "guard" := g
            , "role-burn" := rb
            , "role-mint" := rm
            , "role-transfer" := rt
            , "frozen" := f }
            (write DPTF-BalancesTable (concat [identifier BAR account])
                { "balance"                     : b
                , "guard"                       : g
                , "role-burn"                   : rb
                , "role-mint"                   : rm
                , "role-transfer"               : rt
                , "frozen"                      : f
                } 
            )
        )
    )
    (defun C_MintOrigin (identifier:string account:string amount:decimal)
        @doc "Mints <amount> <identifier> TrueFungible for DPTF Account <account> as initial mint amount"

        (with-capability (DPTF_MINT_ORIGIN identifier account amount)
            (let
                (
                    (g:guard (UR_AccountTrueFungibleGuard identifier account))
                )
                (X_Credit identifier account g amount)
                (update DPTF-PropertiesTable identifier { "origin-mint" : false, "origin-mint-amount" : amount})
                (X_UpdateSupply identifier amount true)
            )
        )
    )
    (defun C_Mint (identifier:string account:string amount:decimal)
        @doc "Mints <amount> <identifier> TrueFungible for DPTF Account <account>"

        (with-capability (DPTF_MINT identifier account amount)
            (let
                (
                    (g:guard (UR_AccountTrueFungibleGuard identifier account))
                )
                (X_Credit identifier account g amount)
                (X_UpdateSupply identifier amount true)
            )
        )
    )
    ;;
    ;;==================DESTROY=====================
    ;;
    ;;      C_Burn|C_Wipe
    ;;
    (defun C_Burn (identifier:string account:string amount:decimal)
        @doc "Burns <amount> <identifier> TrueFungible on DPTF Account <account>"

        (with-capability (DPTF_BURN identifier account amount)
            (X_Debit identifier account amount false)
            (X_UpdateSupply identifier amount false)
        )
    )
    (defun C_Wipe (identifier:string account:string)
        @doc "Wipes the whole supply of <identifier> TrueFungible of a frozen DPTF Account <account>"

        (let
            (
                (amount:decimal (UR_AccountTrueFungibleSupply identifier account))
            )
            (with-capability (DPTF_WIPE identifier account amount)
                (X_Debit identifier account amount true)
                (X_UpdateSupply identifier amount false)
            )
        )
    )
    ;;
    ;;==================TRANSFER====================
    ;;
    ;;      C_TransferTrueFungible|C_TransferTrueFungibleAnew
    ;;
    (defun C_TransferTrueFungible (identifier:string sender:string receiver:string amount:decimal)
        @doc "Transfers <identifier> TrueFungible from <sender> to <receiver> DPMF Account \
            \ Fails if <receiver> DPMF Account doesnt exist"

        (with-capability (TRANSFER_DPTF identifier sender receiver amount false)
            (let
                (
                    (rg:guard (UR_AccountTrueFungibleGuard identifier receiver))
                )
                (X_Debit identifier sender amount false)
                (X_Credit identifier receiver rg amount)
            )
        )
    )
    (defun C_TransferTrueFungibleAnew (identifier:string sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "Same as |C_TransferTrueFungible| but with DPTF Account creation \
        \ This means <receiver> DPMF Account will be created by the transfer function"
        (with-capability (TRANSFER_DPTF identifier sender receiver amount false)
            (X_Debit identifier sender amount false)
            (X_Credit identifier receiver receiver-guard amount)
        )
    )
    

    ;;----------------------------------------------
    ;;                                            ;;
    ;;      AUXILIARY FUNCTIONS                   ;;
    ;;                                            ;;
    ;;==================TRANSFER====================
    ;;
    ;;      X_MethodicTransferTrueFungible|X_MethodicTransferTrueFungibleAnew
    ;;
    (defun X_MethodicTransferTrueFungible (identifier:string sender:string receiver:string amount:decimal)
        @doc "Methodic transfers <identifier> TrueFungible from <sender> to <receiver> DPTF Account \
            \ Fails if <receiver> DPTF Account doesnt exist. \
            \ \
            \ Methodic Transfers cannot be called directly. They are to be used within external Modules \
            \ as transfer means when operating with Smart DPTS Account Types. \
            \ \
            \ This is because clients can trigger transfers to be executed towards and from Smart DPTS Account types,\
            \ as described in the module's code, without them having the need to provide the Smart DPTS Accounts guard \
            \ \
            \ Designed to emulate MultiverX Smart-Contract payable Write-Points \
            \ Here the |payable Write-Points| are the external module functions that make use of this function"

        (require-capability (TRANSFER_DPTF identifier sender receiver amount true))
        (let
            (
                (rg:guard (UR_AccountTrueFungibleGuard identifier receiver))
            )
            (X_Debit identifier sender amount false)
            (X_Credit identifier receiver rg amount)
        )
    )
    (defun X_MethodicTransferTrueFungibleAnew (identifier:string sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "Same as |X_MethodicTransferMetaFungible| but with DPTF Account creation \
        \ This means <receiver> DPMF Account will be created by the transfer function"

        (require-capability (TRANSFER_DPTF identifier sender receiver amount true))
        (X_Debit identifier sender amount false)
        (X_Credit identifier receiver receiver-guard amount)
    )
    ;;
    ;;==================CREDIT|DEBIT================ 
    ;;
    ;;      X_Credit|X_Debit
    ;;
    (defun X_Credit (identifier:string account:string guard:guard amount:decimal)
        @doc "Auxiliary Function that credits a TrueFungible to a DPTF Account"

        ;;Capability Required for Credit
        (require-capability (CREDIT_DPTF identifier account))
        (with-default-read DPTF-BalancesTable (concat [identifier BAR account])
            { "balance" : -1.0, "guard" : guard, "role-burn" : false, "role-mint" : false, "role-transfer" : false, "frozen" : false}
            { "balance" := balance, "guard" := retg, "role-burn" := rb, "role-mint" := rm, "role-transfer" := rt, "frozen" := fr }
            ; we don't want to overwrite an existing guard with the user-supplied one
            (enforce (= retg guard) "Account guards do not match !")
            (let
                (
                    (is-new:bool (if (= balance -1.0) (DPTS.UV_EnforceReserved account guard) false))
                )
                ;; First, a new DPTS Account is created for Account <account>. 
                ;; If DPTS Account exists for <account>, nothing is modified
                (DPTS.C_DeployStandardDPTSAccount account guard)
                ;; if is-new=true, this actually creates a new DPTF Account and credits it the amount
                ;; if is-new=false, this updates the balance by increasing it with <amount>
                ;; this is posible because (write) works regardless of row exists for key or not in a table
                (write DPTF-BalancesTable (concat [identifier BAR account])
                    {"balance"          : (if is-new amount (+ balance amount))
                    ,"guard"            : retg
                    , "role-burn"       : rb
                    , "role-mint"       : rm
                    , "role-transfer"   : rt
                    , "frozen"          : fr}
                )
            )
        )
    )
    (defun X_Debit (identifier:string account:string amount:decimal admin:bool)
        @doc "Auxiliary Function that debits a TrueFungible from a DPTF Account \
            \ \
            \ true <admin> boolean is used when debiting is executed as a part of wiping by the DPTF Owner \
            \ otherwise, for normal debiting operations, false <admin> boolean must be used"

        ;;Capability Required for Debit is called within the let body

        (if (= admin true)
            (require-capability (DPTF_OWNER identifier))
            (require-capability (DEBIT_DPTF identifier account))
        )
        (with-read DPTF-BalancesTable (concat [identifier BAR account])
            { "balance" := balance }
            ; we don't want to overwrite an existing guard with the user-supplied one
            (enforce (<= amount balance) "Insufficient Funds for debiting")
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"balance" : (- balance amount)}    
            )
        )
    )
    ;;
    ;;==================UPDATE======================
    ;;
    ;;      X_UpdateSupply 
    ;;
    (defun X_UpdateSupply (identifier:string amount:decimal direction:bool)
        @doc "Updates <identifier> TrueFungible supply. Boolean <direction> used for increase|decrease"
        
        (require-capability (DPTF_UPDATE_SUPPLY identifier amount))
        (if (= direction true)
            (with-read DPTF-PropertiesTable identifier
                { "supply" := s }
                (enforce (>= (+ s amount) 0.0) "DPTF Token Supply cannot be updated to negative values!")
                (update DPTF-PropertiesTable identifier { "supply" : (+ s amount)})
            )
            (with-read DPTF-PropertiesTable identifier
                { "supply" := s }
                (enforce (>= (- s amount) 0.0) "DPTF Token Supply cannot be updated to negative values!")
                (update DPTF-PropertiesTable identifier { "supply" : (- s amount)})
            )
        )
    )
)

(create-table DPTF-PropertiesTable)
(create-table DPTF-BalancesTable)