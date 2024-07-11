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
    ;;      DPTF_OWNER                      Enforces DPTF Token Ownership
    ;;      DPTF_ORGIN_VIRGIN               Enforces Origin Mint hasn't been executed
    ;;      DPTF_CAN-UPGRADE_ON             Enforces DPTF Token upgrade-ability
    ;;      DPTF_CAN-ADD-SPECIAL-ROLE_ON    Enforces Token Property as true
    ;;      DPTF_CAN-FREEZE_ON              Enforces Token Property as true
    ;;      DPTF_CAN-WIPE_ON                Enforces Token Property as true
    ;;      DPTF_CAN-PAUSE_ON               Enforces Token Property as true
    ;;      DPTF_IS-PAUSED_ON               Enforces that the DPTF Token is paused
    ;;      DPTF_IS-PAUSED_OF               Enforces that the DPTF Token is not paused
    ;;      UPDATE_DPTF_SUPPLY              Capability required to update DPTF Supply
    ;;
    ;;      DPTF_ACCOUNT_OWNER              Enforces DPTF Account Ownership
    ;;      DPTF_ACCOUNT_BURN_ON            Enforces DPTF Account has burn role on
    ;;      DPTF_ACCOUNT_BURN_OFF           Enforces DPTF Account has burn role off
    ;;      DPTF_ACCOUNT_MINT_ON            Enforces DPTF Account has mint role on
    ;;      DPTF_ACCOUNT_MINT_OFF           Enforces DPTF Account has mint role off
    ;;      DPTF_ACCOUNT_TRANSFER_ON        Enforces DPTF Account has transfer role on
    ;;      DPTF_ACCOUNT_TRANSFER_OFF       Enforces DPTF Account has transfer role off
    ;;      DPTF_ACCOUNT_TRANSFER_DEFAULT   Transfer role capabilty required for uncreated receivers
    ;;      DPTF_ACCOUNT_FREEZE_ON          Enforces DPTF Account is frozen
    ;;      DPTF_ACCOUNT_FREEZE_OFF         Enforces DPTF Account is not frozen
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      COMPOSED
    ;;
    ;;      DPTF_CONTROL                    Capability required for managing DPTF Properties
    ;;      DPTF_PAUSE                      Capability required to Pause a DPTF
    ;;      DPTF_UNPAUSE                    Capability required to Unpause a DPTF
    ;;      DPTF_FREEZE_ACCOUNT             Capability required to Freeze a DPTF Account
    ;;      DPTF_UNFREEZE_ACCOUNT           Capability required to Unfreeze a DPTF Account
    ;;      DPTF_SET_BURN-ROLE              Capability required to Set Burn Role for DPTF Account
    ;;      DPTF_UNSET_BURN-ROLE            Capability required to Unset Burn Role for a DPTF Account
    ;;      DPTF_SET_TRANSFER-ROLE          Capability required to Set Transfer Role for DPTF Account
    ;;      DPTF_UNSET_TRANSFER-ROLE        Capability required to Unset Transfer Role for a DPTF Account
    ;;      DPTF_MINT_ORIGIN                Capability required to mint the Origin DPTF Mint Supply
    ;;      DPTF_MINT                       Capability required to mint a DPTF Token locally
    ;;      DPTF_BURN                       Capability required to burn a DPTF Token locally
    ;;      DPTF_WIPE                       Capability required to Wipe a DPTF Token Balance from a DPTF account
    ;;
    ;;      CREDIT_DPTF                     Capability to perform crediting operations with DPTF Tokens
    ;;      DEBIT_DPTF                      Capability to perform debiting operations on Normal DPTS Account types with DPTF Tokens
    ;;      DEBIT_DPTF_SC                   Capability to perform debiting operations on Smart(Contract) DPTS Account types with DPTF Tokens
    ;;      TRANSFER_DPTF                   Capability for transfer between 2 DPTS accounts for a specific DPTF Token identifier   
    ;;
    ;;========================================================================================================
    ;;DPTF Properties Enforcements
    (defcap DPTF_OWNER (identifier:string)
        @doc "Enforces DPTF Token Ownership"
        (with-read DPTF-PropertiesTable identifier
            { "owner" := owg }
            (enforce-guard owg)
        )
    )
    (defcap DPTF_ORIGIN_VIRGIN (identifier:string)
        @doc "Enforces Origin Mint hasn't been executed"
        (with-read DPTF-PropertiesTable identifier
            { "origin-mint" := om, "origin-mint-amount" := oma}
            (enforce (and (= om false)(= oma 0.0)) (format "Origin Mint for DPTF {} cannot be executed any more !" [identifier]))
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
        (U_ValidateDPTFAmount identifier amount)
    )
    ;;DPTF Account Properties Enforcements
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
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      COMPOSED
    ;;
    (defcap DPTF_CONTROL (identifier:string)
        @doc "Capability required for managing DPTF Properties"
        (U_ValidateDPTFIdentifier identifier)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-UPGRADE_ON identifier))
    )
    (defcap DPTF_PAUSE (identifier:string)
        @doc "Capability required to Pause a DPTF Token"
        (U_ValidateDPTFIdentifier identifier)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-PAUSE_ON identifier))
        (compose-capability (DPTF_IS-PAUSED_OFF identifier))
    )
    (defcap DPTF_UNPAUSE (identifier:string)
        @doc "Capability required to Unpause a DPTF Token"
        (U_ValidateDPTFIdentifier identifier)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-PAUSE_ON identifier))
        (compose-capability (DPTF_IS-PAUSED_ON identifier))
    )
    (defcap DPTF_FREEZE_ACCOUNT (identifier:string account:string)
        @doc "Capability required to Freeze a DPTF Account"
        (U_ValidateDPTFIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-FREEZE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_FREEZE_OFF identifier account))
    )
    (defcap DPTF_UNFREEZE_ACCOUNT (identifier:string account:string)
        @doc "Capability required to Unfreeze a DPTF Account"
        (U_ValidateDPTFIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-FREEZE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_FREEZE_ON identifier account))
    )
    (defcap DPTF_SET_BURN-ROLE (identifier:string account:string)
        @doc "Capability required to Set Burn Role for DPTF Account"
        (U_ValidateDPTFIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_BURN_OFF identifier account))
    )
    (defcap DPTF_UNSET_BURN-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Burn Role for DPTF Account"
        (U_ValidateDPTFIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_ACCOUNT_BURN_ON identifier account))
    )
    (defcap DPTF_SET_MINT-ROLE (identifier:string account:string)
        @doc "Capability required to Set Mint Role for DPTF Account"
        (U_ValidateDPTFIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_MINT_OFF identifier account))
    )
    (defcap DPTF_UNSET_MINT-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Mint Role for DPTF Account"
        (U_ValidateDPTFIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_ACCOUNT_MINT_ON identifier account))
    )
    (defcap DPTF_SET_TRANSFER-ROLE (identifier:string account:string)
        @doc "Capability required to Set Transfer Role for DPTF Account"
        (U_ValidateDPTFIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_TRANSFER_OFF identifier account))
    )
    (defcap DPTF_UNSET_TRANSFER-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Transfer Role for DPTF Account"
        (U_ValidateDPTFIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_ACCOUNT_TRANSFER_ON identifier account))
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
    (defcap DPTF_BURN (identifier:string account:string amount:decimal)
        @doc "Capability required to burn a DPTF Token locally \
            \ Smart-Contract Account type doesnt require their guard|key"
        (U_ValidateDPTFAmount identifier amount)
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
    (defcap DPTF_MINT_ORIGIN (identifier:string account:string amount:decimal)
        @doc "Capability required to mint the Origin DPTF Mint Supply"
        (U_ValidateDPTFAmount identifier amount)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_ACCOUNT_OWNER identifier account))
        (compose-capability (DPTF_ORIGIN_VIRGIN identifier))
        (compose-capability (CREDIT_DPTF account))
        (compose-capability (UPDATE_DPTF_SUPPLY identifier amount))
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
    (defcap DPTF_MINT (identifier:string account:string amount:decimal)
        @doc "Capability required to mint a DPTF Token locally \
            \ Smart-Contract Account type doesnt require their guard|key"
        (U_ValidateDPTFAmount identifier amount)
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
    (defcap DPTF_WIPE (identifier:string account:string amount:decimal)
        @doc "Capability required to Wipe a DPTF Token Balance from a DPTF account"
        (U_ValidateDPTFIdentifier identifier)
        (DPTS.U_ValidateAccount account)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-WIPE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_FREEZE_ON identifier account))
        (compose-capability (UPDATE_DPTF_SUPPLY identifier amount))
    )
    ;;Core Capabilities
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
        (U_ValidateDPTFAmount identifier amount)
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
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      COMPOSED
    ;;
    ;;=====================================================================================================
    ;;
    ;;      PRIMARY Functions               meant to be used as standalone functions
    ;;
    ;;
    ;;      0)UTILITY                       can be called by anyone without any key|guard requirement
    ;;                                      they are free functions             
    ;;      1)ADMINISTRATOR                 can only be called by the SC ownership key|guard
    ;;                                      they are administration functions
    ;;      2)CLIENT                        can be called by any "foreign" DPTF account (SC or non-SC account)
    ;;                                      they are client functions.
    ;;
    ;;-----------------------------------------------------------------------------------------------------
    ;;
    ;;      AUXILIARY Functions             not meant to be used at all as they are part of the Primary Functions
    ;;      
    ;;======================================================================================================
    ;;
    ;;      Functions Names are prefixed, so that they may be better visualised and understood.
    ;;
    ;;      UTILITY                         U_FunctionName
    ;;      ADMINISTRATION                  A_FunctionName
    ;;      CLIENT                          C_FunctionName
    ;;      AUXILIARY                       X_FunctionName
    ;;
    ;;======================================================================================================
    ;;
    ;;      UTILITY FUNCTIONS
    ;;
    ;;      U_GetAccountTokens              Returns a list of Identifiers that exist for Account
    ;;      U_GetDPTFBalance                Returns the DPTF balance for given Token Identifier and Account
    ;;      U_GetDPTFSupply                 Return DPTF Token Total Supply for given identifier
    ;;      U_GetDPTFDecimal                Return DPTF Token number of decimals
    ;;      U_ValidateDPTFAmount            Enforces denomination for a specific DPTF identifier and positivity
    ;;      U_ValidateDPTFIdentifier        Enforces Identifier existance
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      ADMINISTRATOR FUNCTIONS
    ;;
    ;;      NO ADMINISTRATOR FUNCTIONS
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      CLIENT FUNCTIONS
    ;;
    ;;      C_IssueDPTF                     Issues a new DPTF Token with specified properties
    ;;      C_DeployDPTFAccount             Creates a new DPTF Account for a given Token Identifier
    ;;      C_ControlDPTF                   Controls DPTF Token Properties via boolean triggers
    ;;      C_MintDPTFOrigin                Mints DPTF Origin Amount, the amount that is minted with creation
    ;;
    ;;      C_BurnDPTF                      Burns DPTF Tokens locally
    ;;      C_SetBurnRole                   Sets Burn Role for Token Identifier for account
    ;;      C_UnsetBurnRole                 Unsets Burn Role for Token Identifier for account
    ;;
    ;;      C_MintDPTF                      Mints DPTF Tokens locally
    ;;      C_SetMintRole                   Sets Mint Role for Token Identifier for account
    ;;      C_UnsetMintRole                 Unsets Mint Role for Token Identifier for account
    ;;
    ;;      C_SetTransferRole               Sets Transfer Role for Token Identifier for account
    ;;      C_UnsetTransferRole             Unsets Transfer Role for Token Identifier for account
    ;;
    ;;      C_WipeDPTF                      Wipes DPTF Tokens from a frozen DPTF Account
    ;;      C_FreezeDPTFAccount             Freezes DPTF Token Identifier on DPTF Account
    ;;      C_UnfreezeDPTFAccount           Unfreezes DPTF Token Identifier on DPTF Account
    ;;
    ;;      C_PauseDPTF                     Pauses DPTF Token Identifier
    ;;      C_UnpauseDPTF                   Unpauses DPTF Token Identifier
    ;;
    ;;      C_TransferDPTF                  Standard Transfer from <sender> DPTF Account to <receiver> DPTF Account, failing if target DPTF account doesnt exist
    ;;      C_TransferDPTFAnew              Standard Transfer from <sender> DPTF Account to <receiver> DPTF Account, creating new target DPTF Account if it doesnt exist
    ;;      C_MethodicTransferDPTF          Methodic Transfer from <sender> DPTF Account to <receiver> DPTF Account, failing if target DPTF account doesnt exist
    ;;      C_MethodicTransferDPTFAnew      Methodic Transfer from <sender> DPTF Account to <receiver> DPTF Account, creating new target DPTF Account if it doesnt exist
    ;;
    ;;--------------------------------------------------------------------------------------------------------
    ;;
    ;;      AUXILIARY FUNCTIONS
    ;;
    ;;      X_CreditDPTF                    Increases DPTF Token balance for Account <account> for Token <identifier>, creating a target DPTF account if it doesnt exist
    ;;      X_DebitDPTF                     Decreases DPTF Token balance for DPTF Account <account> for Token <identifier>
    ;;      X_UpdateDPTFSupply              Updates DPTF Token Supply
    ;;
    ;;========================================================================================================
    ;;
    ;;      UTILITY FUNCTIONS
    ;;
    ;;      U_GetAccountTokens 
    ;;
    (defun U_GetAccountDPTFTokens:[string] (account:string)
        @doc "Returns a list of Identifiers that exist for Account"
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
    ;;      U_GetDPTFBalance
    ;;
    (defun U_GetDPTFBalance:decimal (identifier:string account:string)
        @doc "Returns the DPTF balance for given Token Identifier and Account"
        (U_ValidateDPTFIdentifier identifier)
        (DPTS.U_ValidateAccount account)

        (with-default-read DPTF-BalancesTable (concat [identifier BAR account])
            { "balance" : 0.0 }
            { "balance" := b}
            b
        )
    )
    ;;
    ;;      U_GetDPTFSupply 
    ;;
    (defun U_GetDPTFSupply:decimal (identifier:string)
        @doc "Return <identifier> DPTF Token Total Supply"
        (U_ValidateDPTFIdentifier identifier)

        (at "supply" (read DPTF-PropertiesTable identifier ["supply"]))
    )
    ;;
    ;;      U_GetDPTFDecimals
    ;;
    (defun U_GetDPTFDecimals:integer (identifier:string)
        @doc "Return <identifier> DPTF Token Decimal size"
        (U_ValidateDPTFIdentifier identifier)

        (at "decimals" (read DPTF-PropertiesTable identifier ["decimals"]))
    )
    ;;
    ;;      U_GetDPTFAccountGuard
    ;;
    (defun U_GetDPTFAccountGuard:guard (identifier:string account:string)
        @doc "Return <identifier> DPTF Token Decimal size"
        (U_ValidateDPTFIdentifier identifier)
        (DPTS.U_ValidateAccount account)

        (at "guard" (read DPTF-BalancesTable (concat [identifier BAR account]) ["guard"]))
    )
    ;;
    ;;      U_ValidateDPTFAmount
    ;;
    (defun U_ValidateDPTFAmount (identifier:string amount:decimal)
        @doc "Enforce the minimum denomination for a specific DPTF identifier \
        \ and ensure the amount is greater than zero"
        (U_ValidateDPTFIdentifier identifier)

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
    ;;      U_ValidateIdentifier
    ;;
    (defun U_ValidateDPTFIdentifier (identifier:string)
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
    ;;      C_IssueDPTF
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
        @doc "Issue a new DPTF Token. This creates an entry into the DPTF-PropertiesTable. \
            \ Such an entry means the DPTF Token has been created. Function outputs as string the Token-Identifier \
            \ Token Identifier is formed from ticker, followed by a dash, \ 
            \ followed by the first 12 characters of the previous block hash to ensure uniqueness. \
            \ \
            \ Furthermore, The issuer creates a DPTF Account for himself, as the first Account of this DPTF Token \
            \ By default, New DPTF Account creation also creates a Standard DPTS Account, if it doesnt exist"
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
            (C_DeployDPTFAccount identifier account owner)
            ;;Returns the unique Token Identifier
            identifier
        )
    )
    ;;
    ;;      C_DeployDPTFAccount
    ;;
    (defun C_DeployDPTFAccount (identifier:string account:string guard:guard)
        @doc "Creates a new DPTF Account for a given Token Identifier \
            \ A DPTS Standard Account is also created, in case it doesnt exist \
            \ If a DPTS Account exists, it remains as is. \
            \ Function fails if DPTF Account exists for Token <identifier>"
        (U_ValidateDPTFIdentifier identifier)
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
    ;;      C_ControlDPTF
    ;;
    (defun C_ControlDPTF 
        (
            identifier:string
            can-change-owner:bool 
            can-upgrade:bool 
            can-add-special-role:bool 
            can-freeze:bool 
            can-wipe:bool 
            can-pause:bool
        )
        @doc "Manages DPTF Token Properties via boolean triggers \
            \ Setting the <can-upgrade> property to off(false) \
            \ disables all future Control of Properties"

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
    ;;      C_MintDPTFOrigin
    ;;
    (defun C_MintDPTFOrigin (identifier:string account:string amount:decimal)
        @doc "Mints DPTF Origin Amount, the amount that is minted with creation"

        (with-capability (DPTF_MINT_ORIGIN identifier account amount)
            (with-read DPTF-BalancesTable (concat [identifier BAR account])
                { "guard" := g }
                (X_CreditDPTF identifier account g amount)
            )
            (update DPTF-PropertiesTable identifier { "origin-mint" : false, "origin-mint-amount" : amount})
            (X_UpdateDPTFSupply identifier amount true)
        )
    )
    ;;
    ;;      C_BurnDPTF
    ;;
    (defun C_BurnDPTF (identifier:string account:string amount:decimal)
        @doc "Burns DPTF Tokens locally"

        (with-capability (DPTF_BURN identifier account amount)
            (X_DebitDPTF identifier account amount false)
            (X_UpdateDPTFSupply identifier amount false)
        )
    )
    ;;
    ;;      C_SetBurnRole
    ;;
    (defun C_SetBurnRole (identifier:string account:string)
        @doc "Sets Burn Role for Token Identifier for account \
            \ Then this account can burn Tokens"

        (with-capability (DPTF_SET_BURN-ROLE identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"role-burn" : true}
            )
        )
    )
    ;;
    ;;      C_UnsetBurnRole 
    ;;
    (defun C_UnsetBurnRole (identifier:string account:string)
        @doc "Unsets Burn Role for Token Identifier for account \
            \ Account can no longer burn Tokens"

        (with-capability (DPTF_UNSET_BURN-ROLE identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"role-burn" : false}
            )
        )
    )
    ;;
    ;;      C_MintDPTF 
    ;;
    (defun C_MintDPTF (identifier:string account:string amount:decimal)
        @doc "Mints DPTF Tokens locally"

        (with-capability (DPTF_MINT identifier account amount)
            (with-read DPTF-BalancesTable (concat [identifier BAR account])
                { "guard" := g }
                (X_CreditDPTF identifier account g amount)
            )
            (X_UpdateDPTFSupply identifier amount true)
        )
    )
    ;;
    ;;      C_SetMintRole
    ;;
    (defun C_SetMintRole (identifier:string account:string)
        @doc "Sets Mint Role for Token <identifier> for Account <account> \
            \ Afterwards Account <account> can mint new DPTF Tokens"

        (with-capability (DPTF_SET_MINT-ROLE identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"role-mint" : true}
            )
        )
    )
    ;;
    ;;      C_UnsetMintRole
    ;;
    (defun C_UnsetMintRole (identifier:string account:string)
        @doc "Unsets Mint Role for Token <identifier> for Account <account> \
            \ Afterwards Account <account> can no longer mint DPTF Tokens"

        (with-capability (DPTF_UNSET_MINT-ROLE identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"role-mint" : false}
            )
        )
    )
    ;;
    ;;      C_SetTransferRole
    ;;
    (defun C_SetTransferRole (identifier:string account:string)
        @doc "Sets Transfer Role for Token <identifier> for Account <account> \
            \ DPTF Tokens can only be transfered to Account <account>, \
            \ while it can transfer to any other Account"

        (with-capability (DPTF_SET_TRANSFER-ROLE identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"role-transfer" : true}
            )
        )
    )
    ;;
    ;;      C_UnsetTransferRole
    ;;
    (defun C_UnsetTransferRole (identifier:string account:string)
        @doc "Unsets Transfer Role for Token <identifier> for <account>"

        (with-capability (DPTF_UNSET_TRANSFER-ROLE identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"role-burn" : false}
            )
        )
    )
    ;;
    ;;      C_WipeDPTF
    ;;
    (defun C_WipeDPTF (identifier:string account:string)
        @doc "Wipes DPTF Tokens from a frozen Account"

        (let
            (
                (amount:decimal (U_GetDPTFBalance identifier account))
            )
            (with-capability (DPTF_WIPE identifier account amount)
                (X_DebitDPTF identifier account amount true)
                (X_UpdateDPTFSupply identifier amount false)
            )
        )
    )
    ;;
    ;;      C_FreezeDPTFAccount
    ;;
    (defun C_FreezeDPTFAccount (identifier:string account:string)
        @doc "Freezes DPTF Token <identifier> for Account <account>"

        (with-capability (DPTF_FREEZE_ACCOUNT identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account]) { "frozen" : true})
        )
    )
    ;;
    ;;      C_UnfreezeDPTFAccount 
    ;;
    (defun C_UnfreezeDPTFAccount (identifier:string account:string)
        @doc "Unfreezes DPTF Token <identifier> for Account <account>"

        (with-capability (DPTF_UNFREEZE_ACCOUNT identifier account)
            (update DPTF-BalancesTable (concat [identifier BAR account]) { "frozen" : false})
        )
    )
    ;;
    ;;      C_PauseDPTF
    ;;
    (defun C_PauseDPTF (identifier:string)
        @doc "Pauses DPTF Token <identifier>"

        (with-capability (DPTF_PAUSE identifier)
            (update DPTF-PropertiesTable identifier { "is-paused" : true})
        )
    )
    ;;
    ;;      C_UnpauseDPTF
    ;;
    (defun C_UnpauseDPTF (identifier:string)
        @doc "Unpauses DPTF Token <identifier>"

        (with-capability (DPTF_UNPAUSE identifier)
            (update DPTF-PropertiesTable identifier { "is-paused" : false})
        )
    )
    ;;
    ;;      C_TransferDPTF
    ;;
    (defun C_TransferDPTF (identifier:string sender:string receiver:string amount:decimal)
        @doc "Standard Transfer from <sender> DPTF Account to <receiver> DPTF Account, \
        \ failing if <receiver> DPTF Account doesnt exist"

        (with-capability (TRANSFER_DPTF identifier sender receiver amount false)
            (with-read DPTF-BalancesTable (concat [identifier BAR receiver])
                { "guard" := guard }
                (X_DebitDPTF identifier sender amount false)
                (X_CreditDPTF identifier receiver guard amount)
            )
        )
    )
    ;;
    ;;      C_TransferDPTFAnew
    ;;
    (defun C_TransferDPTFAnew (identifier:string sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "Standard Transfer from <sender> DPTF Account to <receiver> DPTF Account \
        \ If Target Account doesnt exist, it is created."
        (with-capability (TRANSFER_DPTF identifier sender receiver amount false)
            (X_DebitDPTF identifier sender amount false)
            (X_CreditDPTF identifier receiver receiver-guard amount)
        )
    )
    ;;
    ;;      C_MethodicTransferDPTF
    ;;
    (defun C_MethodicTransferDPTF (identifier:string sender:string receiver:string amount:decimal)
        @doc "Methodic Transfer from <sender> DPTF Account to <receiver> DPTF Account, \
        \ failing if <receiver> DPTF Account doesnt exist \
        \ Methodic means the transfer is used as a Method for Smart(Contract) DPTS Account Type operations"
        (require-capability (TRANSFER_DPTF identifier sender receiver amount true))
        (with-read DPTF-BalancesTable (concat [identifier BAR receiver])
                { "guard" := guard }
                (X_DebitDPTF identifier sender amount)
                (X_CreditDPTF identifier receiver guard amount)
        )    
    )
    ;;
    ;;      C_MethodicTransferDPTFAnew
    ;;
    (defun C_MethodicTransferDPTFAnew (identifier:string sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "Standard Transfer from <sender> DPTF Account to <receiver> DPTF Account \
        \ If Target Account doesnt exist, it is created. \
        \ Methodic means the transfer is used as a Method for Smart(Contract) DPTS Account Type operations"
        (require-capability (TRANSFER_DPTF identifier sender receiver amount true))
        (X_DebitDPTF identifier sender amount false)
        (X_CreditDPTF identifier receiver receiver-guard amount)
    )
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      AUXILIARY FUNCTIONS
    ;;
    ;;      X_CreditDPTF
    ;;
    (defun X_CreditDPTF (identifier:string account:string guard:guard amount:decimal)
        @doc "Increases DPTF Token balance for Account <account> for Token <identifier> \
        \ Also creates a new DPTF account if the target account doesnt exist"
        ;; No Validation of Inputs required as this is auxiliary function
        ;; and as such cannot be called on its own

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
                ;; if is-new=true, this actually creates a new DPTF Account and Credits it the amount
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
    ;;      X_DebitDPTF
    ;;
    (defun X_DebitDPTF (identifier:string account:string amount:decimal admin:bool)
        @doc "Decreases DPTF Token balance for Account <account> for Token <identifier>"
        ;; No Validation of Inputs required as this is auxiliary function
        ;; and as such cannot be called on its own

        ;;Capability Required for Debit
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
    ;;      X_UpdateDPTFSupply 
    ;;
    (defun X_UpdateDPTFSupply (identifier:string amount:decimal direction:bool)
        @doc "Updates DPTF Supply. Direction dictates increase or decrease"
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