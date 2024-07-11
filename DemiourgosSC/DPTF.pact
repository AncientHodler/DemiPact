(module DPTF GOVERNANCE
    @doc "Core_DPTF is the Demiourgos.Holdings Module for the management of DPTF Tokens \
    \ DPTF-Tokens = Demiourgos Pact True Fungible Tokens \
    \ DPTF-Tokens mimic the functionality of the ESDT Token introduced by MultiversX (former Elrond) Blockchain"

    ;;CONSTANTS
    ;;Smart-Contract Key and Name Definitions
    (defconst SC_KEY "free.DH-Master-Keyset")
    (defconst SC_NAME "Demiourgos-Pact-True-Fungible")
    (defconst BAR DPTS.BAR)

    ;;Schema Definitions
    ;;Demiourgos Pact TRUE Fungible Token Standard - DPTF
    (defschema DPTF-PropertiesSchema
        @doc "Schema for DPTF Token (True Fungibles) Properties \
        \ Key for Table is DPTF Token Identifier. This ensure a unique entry per Token Identifier"

        owner:guard                         ;;Guard of the Token Owner, Account that created the DPTF Token
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

        supply:decimal                      ;;Stores the Token Total Supply
        origin-mint:bool                    ;;If true, Origin Supply has already been minted
        origin-mint-amount:decimal          ;;Store the Token's Origin Mint Amount

        role-transfer-amount:integer        ;;Stores how many accounts have Transfer Roles for the Token.
    )
    (defschema DPTF-BalanceSchema
        @doc "Schema that Stores Account Balances for DPTF Tokens (True Fungibles)\
        \ Key for the Table is a string composed of: \
        \ <DPTF Identifier> + BAR + <account> \
        \ This ensure a single entry per DPTF Identifier per account."

        balance:decimal                     ;;Stores DPFS balance for Account
        guard:guard                         ;;Stores Guard for DPFS Account
        ;;Special Roles
        role-burn:bool                      ;;when true, Account can burn DPTF Tokens locally
        role-mint:bool                      ;;when true, Account can mint DPTF Tokens locally
        role-transfer:bool                  ;;when true, Transfer is restricted. Only accounts with true Transfer Role
                                            ;;can transfer token, while all other accounts can only transfer to such accounts
        ;;States
        frozen:bool                         ;;Determines wheter Account is frozen for DPTF Token Identifier
    )
    ;;TABLES Definitions
    (deftable DPTF-PropertiesTable:{DPTF-PropertiesSchema})
    (deftable DPTF-BalancesTable:{DPTF-BalanceSchema})
    ;;
    ;;=======================================================================================================
    ;;
    ;;Governance and Administration CAPABILITIES
    ;;
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
        \ Set to DPTF_ADMIN so that only Module Key can enact an upgrade"
        false
    )
    (defcap DPTF_ADMIN ()
        (enforce-guard (keyset-ref-guard SC_KEY))
    )
    ;;=======================================================================================================
    ;;
    ;;      CAPABILITIES
    ;;
    ;;      BASIC                           Basic Capabilities represent singular capability Definitions
    ;;      COMPOSED                        Composed Capabilities are made of one or multiple Basic Capabilities
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      BASIC
    ;;
    ;;======DPTF-PROPERTIES-TABLE-MANAGEMENT======== 
    ;;      DPTF_OWNER                              Enforces DPTF Token Ownership
    ;;      DPTF_CAN-UPGRADE_ON                     Enforces DPTF Token upgrade-ability
    ;;      DPTF_CAN-ADD-SPECIAL-ROLE_ON            Enforces Token Property as true
    ;;      DPTF_CAN-FREEZE_ON                      Enforces Token Property as true
    ;;      DPTF_CAN-WIPE_ON                        Enforces Token Property as true
    ;;      DPTF_CAN-PAUSE_ON                       Enforces Token Property as true
    ;;      DPTF_IS-PAUSED_ON                       Enforces that the DPTF Token is paused
    ;;      DPTF_IS-PAUSED_OF                       Enforces that the DPTF Token is not paused
    ;;      UPDATE_DPTF_SUPPLY                      Capability required to update DPTF Supply
    ;;======DPTF-BALANCES-TABLE-MANAGEMENT==========
    ;;      DPTF_ACCOUNT_OWNER                      Enforces DPTF Account Ownership
    ;;      DPTF_ACCOUNT_BURN_ON                    Enforces DPTF Account has burn role on
    ;;      DPTF_ACCOUNT_BURN_OFF                   Enforces DPTF Account has burn role off
    ;;      DPTF_ACCOUNT_MINT_ON                    Enforces DPTF Account has mint role on
    ;;      DPTF_ACCOUNT_MINT_OFF                   Enforces DPTF Account has mint role off
    ;;      DPTF_ACCOUNT_TRANSFER_ON                Enforces DPTF Account has transfer role on
    ;;      DPTF_ACCOUNT_TRANSFER_OFF               Enforces DPTF Account has transfer role off
    ;;      DPTF_ACCOUNT_TRANSFER_DEFAULT           Transfer role capabilty required for uncreated receivers
    ;;      DPTF_ACCOUNT_FREEZE_ON                  Enforces DPTF Account is frozen
    ;;      DPTF_ACCOUNT_FREEZE_OFF                 Enforces DPTF Account is not frozen
    ;;      DPTF_ORGIN_VIRGIN                       Enforces Origin Mint hasn't been executed
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      COMPOSED
    ;;
    ;;==================CONTROL===================== 
    ;;      DPTF_CONTROL                            Capability required for managing DPTF Properties
    ;;      DPTF_PAUSE                              Capability required to Pause a DPTF
    ;;      DPTF_UNPAUSE                            Capability required to Unpause a DPTF
    ;;      DPTF_FREEZE_ACCOUNT                     Capability required to Freeze a DPTF Account
    ;;      DPTF_UNFREEZE_ACCOUNT                   Capability required to Unfreeze a DPTF Account
    ;;==================SET========================= 
    ;;      DPTF_SET_BURN-ROLE                      Capability required to Set Burn Role for DPTF Account
    ;;      DPTF_SET_MINT-ROLE                      Capability required to Set Mint Role for DPTF Account
    ;;      DPTF_SET_TRANSFER-ROLE                  Capability required to Set Transfer Role for DPTF Account
    ;;==================UNSET=======================
    ;;      DPTF_UNSET_BURN-ROLE                    Capability required to Unset Burn Role for a DPTF Account
    ;;      DPTF_UNSET_MINT-ROLE                    Capability required to Unset Mint Role for a DPTF Account
    ;;      DPTF_UNSET_TRANSFER-ROLE                Capability required to Unset Transfer Role for a DPTF Account
    ;;==================CREATE======================
    ;;      DPTF_MINT_ORIGIN                        Capability required to mint the Origin DPTF Mint Supply
    ;;      DPTF_MINT                               Capability required to mint a DPTF Token
    ;;      DPTF_MINT_SMART                         Capability required to mint a DPTF Token by a Smart DPTS Account
    ;;      DPTF_MINT_STANDARD                      Capability required to mint a DPTF Token by a Standard DPTS Account 
    ;;==================DESTROY=====================
    ;;      DPTF_BURN                               Capability required to burn a DPTF Token
    ;;      DPTF_BURN_SMART                         Capability required to burn a DPTF Token by a Smart DPTS Account
    ;;      DPTF_BURN_STANDARD                      Capability required to burn a DPTF Token by a Standard DPTS Account 
    ;;      DPTF_WIPE                               Capability required to Wipe a DPTF Token Balance from a DPTF account
    ;;=================CORE========================= 
    ;;      CREDIT_DPTF                             Capability to perform crediting operations with DPTF Tokens
    ;;      DEBIT_DPTF                              Capability to perform debiting operations on Normal DPTS Account types with DPTF Tokens
    ;;      DEBIT_DPTF_SC                           Capability to perform debiting operations on Smart(Contract) DPTS Account types with DPTF Tokens
    ;;      TRANSFER_DPTF                           Capability for transfer between 2 DPTS accounts for a specific DPTF Token identifier   
    ;;
    ;;========================================================================================================
    ;;
    ;;======DPTF-PROPERTIES-TABLE-MANAGEMENT======== 
    (defcap DPTF_OWNER (identifier:string)
        @doc "Enforces DPTF Token Ownership"
        (with-read DPTF-PropertiesTable identifier
            { "owner" := owg }
            (enforce-guard owg)
        )
    )
    (defcap DPTF_CAN-UPGRADE_ON (identifier:string)
        @doc "Enforces DPTF Token upgrade-ability"
        (with-read DPTF-PropertiesTable identifier
            { "can-upgrade" := cu }
            (enforce (= cu true) (format "DPTF Token {} properties cannot be upgraded" [identifier]))
        )
    )
    (defcap DPTF_CAN-ADD-SPECIAL-ROLE_ON (identifier:string)
        @doc "Enforces DPTF Token Property as true"
        (with-read DPTF-PropertiesTable identifier
            { "can-add-special-role" := casr }
            (enforce (= casr true) (format "For DPTF Token {} no special roles can be added" [identifier]))
        )
    )
    (defcap DPTF_CAN-FREEZE_ON (identifier:string)
        @doc "Enforces DPTF Token Property as true"
        (with-read DPTF-PropertiesTable identifier
            { "can-freeze" := cf }
            (enforce (= cf true) (format "DPTF Token {} cannot be freezed" [identifier]))
        )
    )
    (defcap DPTF_CAN-WIPE_ON (identifier:string)
        @doc "Enforces DPTF Token Property as true"
        (with-read DPTF-PropertiesTable identifier
            { "can-wipe" := cw }
            (enforce (= cw true) (format "DPTF Token {} cannot be wiped" [identifier]))
        )
    )
    (defcap DPTF_CAN-PAUSE_ON (identifier:string)
        @doc "Enforces DPTF Token Property as true"
        (with-read DPTF-PropertiesTable identifier
            { "can-pause" := cp }
            (enforce (= cp true) (format "DPTF Token {} cannot be paused" [identifier]))
        )
    )
    (defcap DPTF_IS-PAUSED_ON (identifier:string)
        @doc "Enforces that the DPTF Token is paused"
        (with-read DPTF-PropertiesTable identifier
            { "is-paused" := ip }
            (enforce (= ip true) (format "DPTF Token {} is already unpaused" [identifier]))
        )
    )
    (defcap DPTF_IS-PAUSED_OFF (identifier:string)
        @doc "Enforces that the DPTF Token is not paused"
        (with-read DPTF-PropertiesTable identifier
            { "is-paused" := ip }
            (enforce (= ip false) (format "DPTF Token {} is already paused" [identifier]))
        )
    )
    (defcap UPDATE_DPTF_SUPPLY (identifier:string amount:decimal) 
        @doc "Capability required to update DPTF Supply"
        (U_ValidateTrueFungibleAmount identifier amount)
    )
    ;;======DPTF-BALANCES-TABLE-MANAGEMENT==========
    (defcap DPTF_ACCOUNT_OWNER (identifier:string account:string)
        @doc "Enforces DPTF Account Ownership"
        (with-read DPTF-BalancesTable (concat [identifier BAR account])
            { "guard" := g }
            (enforce-guard g)
        )
    )
    (defcap DPTF_ACCOUNT_BURN_ON (identifier:string account:string)
        @doc "Enforces DPTF Account has burn role on"
        (with-read DPTF-BalancesTable (concat [identifier BAR account])
            { "role-burn" := rb }
            (enforce (= rb true) (format "DPTF {} Account isnt allowed to burn" [account]))
        )
    )
    (defcap DPTF_ACCOUNT_BURN_OFF (identifier:string account:string)
        @doc "Enforces DPTF Account has burn role off"
        (with-read DPTF-BalancesTable (concat [identifier BAR account])
            { "role-burn" := rb }
            (enforce (= rb false) (format "DPTF {} Account is allowed to burn" [account]))
        )
    )
    (defcap DPTF_ACCOUNT_MINT_ON (identifier:string account:string)
        @doc "Enforces DPTF Account has mint role on"
        (with-read DPTF-BalancesTable (concat [identifier BAR account])
            { "role-mint" := rm }
            (enforce (= rm true) (format "DPTF {} Account isnt allowed to mint" [account]))
        )
    )
    (defcap DPTF_ACCOUNT_MINT_OFF (identifier:string account:string)
        @doc "Enforces DPTF Account has mint role on"
        (with-read DPTF-BalancesTable (concat [identifier BAR account])
            { "role-mint" := rm }
            (enforce (= rm false) (format "DPTF {} Account is allowed to mint" [account]))
        )
    )
    (defcap DPTF_ACCOUNT_TRANSFER_ON (identifier:string account:string)
        @doc "Enforces DPTF Account has transfer role on"
        (with-default-read DPTF-BalancesTable (concat [identifier BAR account])
            { "role-transfer" : false }
            { "role-transfer" := rt }
            (enforce (= rt true) (format "Transfer Role is not valid for DPTF {} Account" [account]))
        )
    )
    (defcap DPTF_ACCOUNT_TRANSFER_OFF (identifier:string account:string)
        @doc "Enforces DPTF Account has transfer role on"
        (with-read DPTF-BalancesTable (concat [identifier BAR account])
            { "role-transfer" := rt }
            (enforce (= rt false) (format "DPTF {} Account has transfer role" [account]))
        )
    )
    (defcap DPTF_ACCOUNT_TRANSFER_DEFAULT ()
        @doc "Transfer role capabilty required for uncreated receivers"
        true
    )
    (defcap DPTF_ACCOUNT_FREEZE_ON (identifier:string account:string)
        @doc "Enforces DPTF Account is frozen"
        (with-read DPTF-BalancesTable (concat [identifier BAR account])
            { "frozen" := f }
            (enforce (= f true) (format "DPTF {} Account isnt frozen" [account]))
        )
    )
    (defcap DPTF_ACCOUNT_FREEZE_OFF (identifier:string account:string)
        @doc "Enforces DPTF Account is not frozen"
        (with-default-read DPTF-BalancesTable (concat [identifier BAR account])
            { "frozen" : false}
            { "frozen" := f }
            (enforce (= f false) (format "DPTF {} Account is frozen" [account]))
        )
    )
    (defcap DPTF_ORIGIN_VIRGIN (identifier:string)
        @doc "Enforces Origin Mint hasn't been executed"
        (with-read DPTF-PropertiesTable identifier
            { "origin-mint" := om, "origin-mint-amount" := oma}
            (enforce (and (= om false)(= oma 0.0)) (format "Origin Mint for DPTF {} cannot be executed any more !" [identifier]))
        )
    )
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      COMPOSED
    ;;
    ;;==================CONTROL===================== 
    (defcap DPTF_CONTROL (identifier:string)
        @doc "Capability required for managing DPTF Properties"
        (U_ValidateTrueFungibleIdentifier identifier)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-UPGRADE_ON identifier))
    )
    (defcap DPTF_PAUSE (identifier:string)
        @doc "Capability required to Pause a DPTF Token"
        (U_ValidateTrueFungibleIdentifier identifier)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-PAUSE_ON identifier))
        (compose-capability (DPTF_IS-PAUSED_OFF identifier))
    )
    (defcap DPTF_UNPAUSE (identifier:string)
        @doc "Capability required to Unpause a DPTF Token"
        (U_ValidateTrueFungibleIdentifier identifier)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-PAUSE_ON identifier))
        (compose-capability (DPTF_IS-PAUSED_ON identifier))
    )
    (defcap DPTF_FREEZE_ACCOUNT (identifier:string account:string)
        @doc "Capability required to Freeze a DPTF Account"
        (U_ValidateTrueFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-FREEZE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_FREEZE_OFF identifier account))
    )
    (defcap DPTF_UNFREEZE_ACCOUNT (identifier:string account:string)
        @doc "Capability required to Unfreeze a DPTF Account"
        (U_ValidateTrueFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-FREEZE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_FREEZE_ON identifier account))
    )
    ;;==================SET=========================
    (defcap DPTF_SET_BURN-ROLE (identifier:string account:string)
        @doc "Capability required to Set Burn Role for DPTF Account"
        (U_ValidateTrueFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_BURN_OFF identifier account))
    )
    (defcap DPTF_SET_MINT-ROLE (identifier:string account:string)
        @doc "Capability required to Set Mint Role for DPTF Account"
        (U_ValidateTrueFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_MINT_OFF identifier account))
    )
    (defcap DPTF_SET_TRANSFER-ROLE (identifier:string account:string)
        @doc "Capability required to Set Transfer Role for DPTF Account"
        (U_ValidateTrueFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_TRANSFER_OFF identifier account))
    )
    ;;==================UNSET=======================
    (defcap DPTF_UNSET_BURN-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Burn Role for DPTF Account"
        (U_ValidateTrueFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_ACCOUNT_BURN_ON identifier account))
    )
    (defcap DPTF_UNSET_MINT-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Mint Role for DPTF Account"
        (U_ValidateTrueFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_ACCOUNT_MINT_ON identifier account))
    )
    (defcap DPTF_UNSET_TRANSFER-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Transfer Role for DPTF Account"
        (U_ValidateTrueFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_ACCOUNT_TRANSFER_ON identifier account))
    )
    ;;==================CREATE======================
    (defcap DPTF_MINT_ORIGIN (identifier:string account:string amount:decimal)
        @doc "Capability required to mint the Origin DPTF Mint Supply"
        (U_ValidateTrueFungibleAmount identifier amount)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_ACCOUNT_OWNER identifier account))
        (compose-capability (DPTF_ORIGIN_VIRGIN identifier))
        (compose-capability (CREDIT_DPTF account))
        (compose-capability (UPDATE_DPTF_SUPPLY identifier amount))
    )
    (defcap DPTF_MINT (identifier:string account:string amount:decimal)
        @doc "Capability required to mint a DPTF Token locally \
            \ Smart-Contract Account type doesnt require their guard|key"
        (U_ValidateTrueFungibleAmount identifier amount)
        (DPTS.U_ValidateAccount account)
        (let
            (
                (iz-sc:bool (at 0 (DPTS.U_GetDPTSAccountType account)))
            )
            (if (= iz-sc true)
                (compose-capability (DPTF_MINT_SMART identifier account amount))
                (compose-capability (DPTF_MINT_STANDARD identifier account amount))
            )
        )
    )
    (defcap DPTF_MINT_SMART (identifier:string account:string amount:decimal)
        (compose-capability (DPTF_ACCOUNT_MINT_ON identifier account))
        (compose-capability (CREDIT_DPTF account))
        (compose-capability (UPDATE_DPTF_SUPPLY identifier amount))
    )
    (defcap DPTF_MINT_STANDARD (identifier:string account:string amount:decimal)
        (compose-capability (DPTF_ACCOUNT_OWNER identifier account))
        (compose-capability (DPTF_ACCOUNT_MINT_ON identifier account))
        (compose-capability (CREDIT_DPTF account))
        (compose-capability (UPDATE_DPTF_SUPPLY identifier amount))
    )
    ;;==================DESTROY=====================
    (defcap DPTF_BURN (identifier:string account:string amount:decimal)
        @doc "Capability required to burn a DPTF Token locally \
            \ Smart-Contract Account type doesnt require their guard|key"
        (U_ValidateTrueFungibleAmount identifier amount)
        (DPTS.U_ValidateAccount account)
        (let
            (
                (iz-sc:bool (at 0 (DPTS.U_GetDPTSAccountType account)))
            )
            (if (= iz-sc true)
                (compose-capability (DPTF_BURN_SMART identifier account amount))
                (compose-capability (DPTF_BURN_STANDARD identifier account amount))
            )
        )
    )
    (defcap DPTF_BURN_SMART (identifier:string account:string amount:decimal)
        (compose-capability (DPTF_ACCOUNT_BURN_ON identifier account))
        (compose-capability (DEBIT_DPTF_SC account))
        (compose-capability (UPDATE_DPTF_SUPPLY identifier amount))
    )
    (defcap DPTF_BURN_STANDARD (identifier:string account:string amount:decimal)
        (compose-capability (DPTF_ACCOUNT_OWNER identifier account))
        (compose-capability (DPTF_ACCOUNT_BURN_ON identifier account))
        (compose-capability (DEBIT_DPTF identifier account))
        (compose-capability (UPDATE_DPTF_SUPPLY identifier amount))
    )
    (defcap DPTF_WIPE (identifier:string account:string amount:decimal)
        @doc "Capability required to Wipe a DPTF Token Balance from a DPTF account"
        (U_ValidateTrueFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-WIPE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_FREEZE_ON identifier account))
        (compose-capability (UPDATE_DPTF_SUPPLY identifier amount))
    )
    ;;=================CORE=========================
    (defcap CREDIT_DPTF (account:string)
        @doc "Capability to perform crediting operations with DPTF Tokens"
        true
        ;;Isnt needed since DPTS.U_ValidateSenderReceiver is used which has DPTS.U_ValidateAccount
        ;;DPTS.U_ValidateAccount enforces already length account is greater than ACCOUNT_ID_MIN_LENGTH (3)
        ;;(enforce (!= account "") "Invalid receiver account")
    )
    (defcap DEBIT_DPTF (identifier:string account:string)
        @doc "Capability to perform debiting operations on a Normal DPTS Account type for a DPTF Token"
        (enforce-guard 
            (at "guard" 
                (read DPTF-BalancesTable (concat [identifier BAR account]) ["guard"])
            )
        )
        ;;Isnt needed since DPTS.U_ValidateSenderReceiver is used which has DPTS.U_ValidateAccount
        ;;DPTS.U_ValidateAccount enforces already length account is greater than ACCOUNT_ID_MIN_LENGTH (3)
        ;;(enforce (!= account "") "Invalid sender account")
    )
    (defcap DEBIT_DPTF_SC ()
        @doc "Capability to perform debiting operations on a Smart(Contract) DPTS Account type for a DPTF Token\
        \ Does not enforce account guard."
        true
        ;;Isnt needed since DPTS.U_ValidateSenderReceiver is used which has DPTS.U_ValidateAccount
        ;;DPTS.U_ValidateAccount enforces already length account is greater than ACCOUNT_ID_MIN_LENGTH (3)
        ;;(enforce (!= account "") "Invalid sender account")
    )
    (defcap TRANSFER_DPTF (identifier:string sender:string receiver:string amount:decimal method:bool)
        @doc "Capability for transfer between 2 DPTS accounts for a specific DPTF Token identifier"

        ;;These 3 Validation make obsolete every other similar Validation in other functions
        ;;Becuase them other functions cant be called on their own, but with transfer functions
        ;;That require this capability, which brings us to these Validations
        (U_ValidateTrueFungibleAmount identifier amount)
        (DPTS.U_ValidateSenderReceiver sender receiver)

        (compose-capability (DPTF_IS-PAUSED_OFF identifier))
        (compose-capability (DPTF_ACCOUNT_FREEZE_OFF identifier sender))
        (compose-capability (DPTF_ACCOUNT_FREEZE_OFF identifier receiver))
        (with-read DPTF-PropertiesTable identifier
            { "role-transfer-amount" := rta }
            (if (!= rta 0)
                ;;if true
                (or
                    (compose-capability (DPTF_ACCOUNT_TRANSFER_ON identifier sender))
                    (compose-capability (DPTF_ACCOUNT_TRANSFER_ON identifier receiver))
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
                (compose-capability (DEBIT_DPTF_SC sender))
                (compose-capability (DEBIT_DPTF identifier sender))
            )
        )   
        (compose-capability (CREDIT_DPTF receiver))
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
    ;;      U_GetAccountTrueFungibles               Returns a List of Truefungible Identifiers held by DPTF Accounts <account>                          ;;
    ;;      U_GetAccountTrueFungibleSupply          Returns total Supply for TrueFungible <identifier> held by DPTF Account <account>                   ;;
    ;;      U_GetAccountTrueFungibleGuard           Returns the Guard of a TrueFungible <identifier> held by DPMF Account <account>                     ;;
    ;;==================TF-INFO=====================                                                                                                    ;;
    ;;      U_GetTrueFungibleSupply                 Returns Total existent Supply for TrueFungible <identifier>                                         ;;
    ;;      U_GetTrueFungibleDecimals               Returns the number of Decimals the TrueFungible <identifier> was created with                       ;;
    ;;==================VALIDATIONS=================                                                                                                    ;;
    ;;      U_ValidateTrueFungibleAmount            Enforces the Amount <amount> is positive its decimal size conform for TrueFungible <identifier>     ;;
    ;;      U_ValidateTrueFungibleIdentifier        Enforces the TrueFungible <identifier> exists                                                       ;;
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
    ;;
    ;;      UTILITY FUNCTIONS
    ;;
    ;;==================ACCOUNT-INFO================ 
    ;;
    ;;      U_GetAccountTrueFungibles
    ;;
    (defun U_GetAccountTrueFungibles:[string] (account:string)
        @doc "Returns a List of Truefungible Identifiers held by DPTF Accounts <account>"
        (DPTS.U_ValidateAccount account)

        (let*
            (
                (keyz:[string] (keys DPTF-BalancesTable))
                (listoflists:[[string]] (map (lambda (x:string) (DPTS.U_SplitString DPTS.BAR x)) keyz))
                (dptf-account-tokens:[string] (DPTS.U_FilterIdentifier listoflists account))
            )
            dptf-account-tokens
        )
    )
    ;;
    ;;      U_GetAccountTrueFungibleSupply
    ;;
    (defun U_GetAccountTrueFungibleSupply:decimal (identifier:string account:string)
        @doc "Returns total Supply for TrueFungible <identifier> held by DPTF Account <account>"
        (U_ValidateTrueFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)

        (with-default-read DPTF-BalancesTable (concat [identifier BAR account])
            { "balance" : 0.0 }
            { "balance" := b}
            b
        )
    )
    ;;
    ;;      U_GetAccountTrueFungibleGuard
    ;;
    (defun U_GetAccountTrueFungibleGuard:guard (identifier:string account:string)
        @doc "Return <identifier> DPTF Token Decimal size"
        (U_ValidateTrueFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)

        (at "guard" (read DPTF-BalancesTable (concat [identifier BAR account]) ["guard"]))
    )
    ;;
    ;;==================TF-INFO===================== 
    ;;
    ;;      U_GetTrueFungibleSupply 
    ;;
    (defun U_GetTrueFungibleSupply:decimal (identifier:string)
        @doc "Returns Total existent Supply for TrueFungible <identifier> "
        (U_ValidateTrueFungibleIdentifier identifier)

        (at "supply" (read DPTF-PropertiesTable identifier ["supply"]))
    )
    ;;
    ;;      U_GetTrueFungibleDecimals
    ;;
    (defun U_GetTrueFungibleDecimals:integer (identifier:string)
        @doc "Return <identifier> DPTF Token Decimal size"
        (U_ValidateTrueFungibleIdentifier identifier)

        (at "decimals" (read DPTF-PropertiesTable identifier ["decimals"]))
    )
    ;;
    ;;==================VALIDATIONS=================
    ;;
    ;;      U_ValidateTrueFungibleAmount
    ;;
    (defun U_ValidateTrueFungibleAmount (identifier:string amount:decimal)
        @doc "Enforce the minimum denomination for a specific DPTF identifier \
        \ and ensure the amount is greater than zero"
        (U_ValidateTrueFungibleIdentifier identifier)

        (with-read DPTF-PropertiesTable identifier
            { "decimals" := d }
            (enforce
                (= (floor amount d) amount)
                (format "The amount of {} does not conform with the {} number decimals." [amount identifier])
            )
            (enforce
                (> amount 0.0)
                (format "The amount of {} is not a Valid Transaction amount" [amount])
            )
        )
    )
    ;;
    ;;      U_ValidateTrueFungibleIdentifier
    ;;
    (defun U_ValidateTrueFungibleIdentifier (identifier:string)
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
    ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      ADMINISTRATION FUNCTIONS                                                                                                                    ;;
    ;;                                                                                                                                                  ;;
    ;;      NO ADMINISTRATOR FUNCTIONS                                                                                                                  ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;
    ;;      CLIENT FUNCTIONS
    ;;
    ;;
    ;;==================CONTROL=====================
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
    ;;
    ;;      C_Pause
    ;;
    (defun C_Pause (identifier:string)
        @doc "Pause TrueFungible <identifier>"

        (with-capability (DPTF_PAUSE identifier)
            (update DPTF-PropertiesTable identifier { "is-paused" : true})
        )
    )
    ;;
    ;;      C_Unpause
    ;;
    (defun C_Unpause (identifier:string)
        @doc "Unpause TrueFungible <identifier>"

        (with-capability (DPTF_UNPAUSE identifier)
            (update DPTF-PropertiesTable identifier { "is-paused" : false})
        )
    )
    ;;
    ;;      C_FreezeAccount
    ;;
    (defun C_FreezeAccount (identifier:string account:string)
        @doc "Freeze TrueFungile <identifier> on DPTF Account <account>"

        (with-capability (DPTF_FREEZE_ACCOUNT identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account]) { "frozen" : true})
        )
    )
    ;;
    ;;      C_UnfreezeAccount 
    ;;
    (defun C_Unfreezeccount (identifier:string account:string)
        @doc "Unfreeze TrueFungile <identifier> on DPTF Account <account>"

        (with-capability (DPTF_UNFREEZE_ACCOUNT identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account]) { "frozen" : false})
        )
    )
    ;;
    ;;==================SET========================= 
    ;;
    ;;      C_SetBurnRole
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
    ;;
    ;;      C_SetMintRole
    ;;
    (defun C_SetMintRole (identifier:string account:string)
        @doc "Sets |role-mint| to true for TrueFungible <identifier> and DPTF Account <account> \
            \ Afterwards Account <account> can mint TrueFungible"

        (with-capability (DPTF_SET_MINT-ROLE identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"role-mint" : true}
            )
        )
    )
    ;;
    ;;      C_SetTransferRole
    ;;
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
    )
    ;;
    ;;==================UNSET=======================
    ;;
    ;;      C_UnsetBurnRole 
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
    ;;
    ;;      C_UnsetMintRole
    ;;
    (defun C_UnsetMintRole (identifier:string account:string)
        @doc "Sets |role-mint| to false for TrueFungible <identifier> and DPTF Account <account> \
            \ Afterwards Account <account> can no longer mint existing TrueFungible"

        (with-capability (DPTF_UNSET_MINT-ROLE identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"role-mint" : false}
            )
        )
    )
    ;;
    ;;      C_UnsetTransferRole
    ;;
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
    )
    ;;
    ;;==================CREATE====================== 
    ;;
    ;;      C_IssueTrueFungible
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
        (DPTS.U_ValidateTokenName name)
        ;; Enforce Ticker is part of identifier variable below
        (DPTS.U_ValidateDecimals decimals)

        (let
            (
                (identifier (DPTS.U_MakeDPTSIdentifier ticker))
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
    ;;
    ;;      C_DeployTrueFungibleAccount
    ;;
    (defun C_DeployTrueFungibleAccount (identifier:string account:string guard:guard)
        @doc "Creates a new DPTF Account for TrueFungible <identifier> and Account <account> \
            \ If a DPTF Account already exists for <identifier> and <account>, it remains as is \
            \ \
            \ A Standard DPTS Account is also created, if one doesnt exist \
            \ If a DPTS Account exists, its type remains unchanged"
        (U_ValidateTrueFungibleIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (DPTS.U_EnforceReserved account guard)

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
    ;;
    ;;      C_MintOrigin
    ;;
    (defun C_MintOrigin (identifier:string account:string amount:decimal)
        @doc "Mints <amount> <identifier> TrueFungible for DPTF Account <account> as initial mint amount"

        (with-capability (DPTF_MINT_ORIGIN identifier account amount)
            (with-read DPTF-BalancesTable (concat [identifier BAR account])
                { "guard" := g }
                (X_Credit identifier account g amount)
            )
            (update DPTF-PropertiesTable identifier { "origin-mint" : false, "origin-mint-amount" : amount})
            (X_UpdateSupply identifier amount true)
        )
    )
    ;;
    ;;      C_Mint
    ;;
    (defun C_Mint (identifier:string account:string amount:decimal)
        @doc "Mints <amount> <identifier> TrueFungible for DPTF Account <account>"

        (with-capability (DPTF_MINT identifier account amount)
            (with-read DPTF-BalancesTable (concat [identifier BAR account])
                { "guard" := g }
                (X_Credit identifier account g amount)
            )
            (X_UpdateSupply identifier amount true)
        )
    )
    ;;
    ;;==================DESTROY=====================
    ;;
    ;;      C_Burn
    ;;
    (defun C_Burn (identifier:string account:string amount:decimal)
        @doc "Burns <amount> <identifier> TrueFungible on DPTF Account <account>"

        (with-capability (DPTF_BURN identifier account amount)
            (X_Debit identifier account amount false)
            (X_UpdateSupply identifier amount false)
        )
    )
    ;;
    ;;      C_Wipe
    ;;
    (defun C_Wipe (identifier:string account:string)
        @doc "Wipes the whole supply of <identifier> TrueFungible of a frozen DPTF Account <account>"

        (let
            (
                (amount:decimal (U_GetAccountTrueFungibleSupply identifier account))
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
    ;;      C_TransferTrueFungible
    ;;
    (defun C_TransferTrueFungible (identifier:string sender:string receiver:string amount:decimal)
        @doc "Transfers <identifier> TrueFungible from <sender> to <receiver> DPMF Account \
            \ Fails if <receiver> DPMF Account doesnt exist"

        (with-capability (TRANSFER_DPTF identifier sender receiver amount false)
            (with-read DPTF-BalancesTable (concat [identifier BAR receiver])
                { "guard" := guard }
                (X_Debit identifier sender amount false)
                (X_Credit identifier receiver guard amount)
            )
        )
    )
    ;;
    ;;      C_TransferTrueFungibleAnew
    ;;
    (defun C_TransferTrueFungibleAnew (identifier:string sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "Same as |C_TransferTrueFungible| but with DPTF Account creation \
        \ This means <receiver> DPMF Account will be created by the transfer function"
        (with-capability (TRANSFER_DPTF identifier sender receiver amount false)
            (X_Debit identifier sender amount false)
            (X_Credit identifier receiver receiver-guard amount)
        )
    )
    ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      AUXILIARY FUNCTIONS                                                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================TRANSFER====================
    ;;
    ;;      X_MethodicTransferTrueFungible
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
        (with-read DPTF-BalancesTable (concat [identifier BAR receiver])
                { "guard" := guard }
                (X_Debit identifier sender amount)
                (X_Credit identifier receiver guard amount)
        )    
    )
    ;;
    ;;      X_MethodicTransferTrueFungibleAnew
    ;;
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
    ;;      X_Credit
    ;;
    (defun X_Credit (identifier:string account:string guard:guard amount:decimal)
        @doc "Auxiliary Function that credits a TrueFungible to a DPTF Account"

        ;;Capability Required for Credit
        (require-capability (CREDIT_DPTF account))
        (with-default-read DPTF-BalancesTable (concat [identifier BAR account])
            { "balance" : -1.0, "guard" : guard, "role-burn" : false, "role-mint" : false, "role-transfer" : false, "frozen" : false}
            { "balance" := balance, "guard" := retg, "role-burn" := rb, "role-mint" := rm, "role-transfer" := rt, "frozen" := fr }
            ; we don't want to overwrite an existing guard with the user-supplied one
            (enforce (= retg guard) "Account guards do not match !")
            (let
                (
                    (is-new:bool (if (= balance -1.0) (DPTS.U_EnforceReserved account guard) false))
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
                    , "role-burn"       : (if is-new false rb)
                    , "role-mint"       : (if is-new false rm)
                    , "role-transfer"   : (if is-new false rt)
                    , "frozen"          : (if is-new false fr)}
                )
            )
        )
    )
    ;;
    ;;      X_Debit
    ;;
    (defun X_Debit (identifier:string account:string amount:decimal admin:bool)
        @doc "Auxiliary Function that debits a TrueFungible from a DPTF Account \
            \ \
            \ true <admin> boolean is used when debiting is executed as a part of wiping by the DPTF Owner \
            \ otherwise, for normal debiting operations, false <admin> boolean must be used"

        ;;Capability Required for Debit is called within the let body
        (let
            (
                (iz-sc:bool (at 0 (DPTS.U_GetDPTSAccountType account)))
            )
            (if (= admin true)
                (require-capability (DPTF_OWNER identifier))
                (if (= iz-sc true)
                    (require-capability (DEBIT_DPTF_SC account))
                    (require-capability (DEBIT_DPTF identifier account))
                )
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
    )
    ;;
    ;;==================UPDATE======================
    ;;
    ;;      X_UpdateSupply 
    ;;
    (defun X_UpdateSupply (identifier:string amount:decimal direction:bool)
        @doc "Updates <identifier> TrueFungible supply. Boolean <direction> used for increase|decrease"
        
        (require-capability (UPDATE_DPTF_SUPPLY identifier amount))
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