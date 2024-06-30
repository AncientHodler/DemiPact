(module DH_DPTS GOVERNANCE
    @doc "DH_DPTS is the Demiourgos.Holdings Smart-Contract for the management of DPTS.\
    \ DPTS or the Demiourgos-Pact-Token-Standard is a Pact Token Standard created by Demiourgos.Holdings \
    \ that mimics the ESDT Token standard that was introduced by MultiversX (former Elrond) Blockchain."

    ;;CONSTANTS
    ;;Smart-Contract Key and Name Definitions
    (defconst SC_KEY "free.DH-Master-Keyset")
    (defconst SC_NAME "Demiourgos-Pact-Token-Standard")
    ;;TOKEN-Restriction Constants
    (defconst DPTS_MAX_PRECISION 24)
    (defconst DPTS_MIN_PRECISION 2)
    (defconst DPTS_MIN_TOKEN_NAME_LENGTH 3)
    (defconst DPTS_MAX_TOKEN_NAME_LENGTH 50)
    (defconst DPTS_MIN_TOKEN_TICKER_LENGTH 3)
    (defconst DPTS_MAX_TOKEN_TICKER_LENGTH 20)
    ;;ACCOUNT-Restriction Constants
    (defconst ACCOUNT_ID_CHARSET CHARSET_LATIN1 "Allowed character set for account IDs.")
    (defconst ACCOUNT_ID_PROHIBITED_CHARACTER ["$" "¢" "£"])
    (defconst ACCOUNT_ID_MIN_LENGTH 3 " Minimum character length for account IDs. ")
    (defconst ACCOUNT_ID_MAX_LENGTH 256 " Maximum character length for account IDs. ")
    (defconst IASPLITTER "|")
    (defconst NUMBERS ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9"])
    (defconst CAPITAL_LETTERS ["A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"])
    (defconst NON_CAPITAL_LETTERS ["a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"])
    ;;SCHEMAS Definitions
    (defschema DPTSAccountTypeSchema
        @doc "Schema that stores Account Type information \
        \ Account type means if the Account is a Standard DPTS Account \
        \ or if the Account is tagged as a Smart-Contract Account \ 
        \ Smart Contract Account Types have different logic for transfers."
        smart-contract:bool                 ;;when true Account is of Smart-Contract type, otherwise is Normal DPTS Account
        payable-as-smart-contract:bool      ;;when true, the Smart-Contract Account is payable by Normal DPTS Accounts
        payable-by-smart-contract:bool      ;;when true, the Smart-Contract Account is payable by Smart-Contract DPTS Accounts
    )
    (defschema DPTSBalancesSchema
        @doc "Schema that Stores Account Balances for DPTS Tokens\
        \ Key for the Table is a string composed of: \
        \ <DPTS Identifier> + IASPLITTER + <account> \
        \ This ensure a single entry per DPTS Identifier per account."
        balance:decimal                     ;;Stores DPTS balance for Account
        guard:guard                         ;;Stores Guard for DPTS Account
        ;;Special Roles
        role-burn:bool                      ;;when true, Account can burn Tokens locally
        role-mint:bool                      ;;when true, Account can mint Tokens locally
        role-transfer:bool                  ;;when true, Transfer is restricted. Only accounts with true Transfer Role
                                            ;;can transfer token, while all other accounts can only transfer to such accounts
        ;;States
        frozen:bool
    )
    (defschema DPTSPropertiesSchema
        @doc "Schema for DPTS Token Properties"
        owner:guard                         ;;Guard of the Token Owner
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

        role-transfer-amount:integer;;Stores how many accounts have Transfer Roles for the Token.
    )
    ;;TABLES Definitions
    (deftable DPTSAccountTypeTable:{DPTSAccountTypeSchema})
    (deftable DPTSBalancesTable:{DPTSBalancesSchema})
    (deftable DPTSPropertiesTable:{DPTSPropertiesSchema})
    ;;
    ;;=======================================================================================================
    ;;
    ;;Governance and Administration CAPABILITIES
    ;;
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
        \ Set to DPTS_ADMIN so that only Module Key can enact an upgrade"
        false
    )
    (defcap DPTS_ADMIN ()
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
    ;;      DPTS_OWNER                      Enforces DPTS Token Ownership
    ;;      DPTS_ORGIN_VIRGIN               Enforces Origin Mint hasn't been executed
    ;;      DPTS_CAN-UPGRADE_ON             Enforces DPTS Token upgrade-ability
    ;;      DPTS_CAN-ADD-SPECIAL-ROLE_ON    Enforces Token Property as true
    ;;      DPTS_CAN-FREEZE_ON              Enforces Token Property as true
    ;;      DPTS_CAN-WIPE_ON                Enforces Token Property as true
    ;;      DPTS_CAN-PAUSE_ON               Enforces Token Property as true
    ;;      DPTS_IS-PAUSED_ON               Enforces that the DPTS Token is paused
    ;;      DPTS_IS-PAUSED_OF               Enforces that the DPTS Token is not paused
    ;;      UPDATE_DPTS_SUPPLY              Capability required to update DPTS Supply
    ;;
    ;;      IZ-SC                           Enforces DPTS Account is of Smart-Contract Type
    ;;      DPTS_ACCOUNT_OWNER              Enforces DPTS Account Ownership
    ;;      DPTS_ACCOUNT_BURN_ON            Enforces DPTS Account has burn role on
    ;;      DPTS_ACCOUNT_BURN_OFF           Enforces DPTS Account has burn role off
    ;;      DPTS_ACCOUNT_MINT_ON            Enforces DPTS Account has mint role on
    ;;      DPTS_ACCOUNT_MINT_OFF           Enforces DPTS Account has mint role off
    ;;      DPTS_ACCOUNT_TRANSFER_ON        Enforces DPTS Account has transfer role on
    ;;      DPTS_ACCOUNT_TRANSFER_OFF       Enforces DPTS Account has transfer role off
    ;;      DPTS_ACCOUNT_TRANSFER_DEFAULT   Transfer role capabilty required for uncreated receivers
    ;;      DPTS_ACCOUNT_FREEZE_ON          Enforces DPTS Account is frozen
    ;;      DPTS_ACCOUNT_FREEZE_OFF         Enforces DPTS Account is not frozen
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      COMPOSED
    ;;
    ;;      CONTROL_DPTS                    Capability required for managing DPTS Properties
    ;;      PAUSE_DPTS                      Capability required to Pause a DPTS
    ;;      UNPAUSE_DPTS                    Capability required to Unpause a DPTS
    ;;      FREEZE_DPTS                     Capability required to Freeze a DPTS Account
    ;;      UNFREEZE_DPTS                   Capability required to Unfreeze a DPTS Account
    ;;      SET_BURN-ROLE                   Capability required to Set Burn Role for DPTS Account
    ;;      UNSET_BURN-ROLE                 Capability required to Unset Burn Role for a DPTS Account
    ;;      SET_TRANSFER-ROLE               Capability required to Set Transfer Role for DPTS Account
    ;;      UNSET_TRANSFER-ROLE             Capability required to Unset Transfer Role for a DPTS Account
    ;;      MINT_DPTS_ORIGIN                Capability required to mint the Origin DPTS Mint Supply
    ;;      MINT_DPTS                       Capability required to mint a DPTS Token locally
    ;;      BURN_DPTS                       Capability required to burn a DPTS Token locally
    ;;      WIPE_DPTS                       Capability required to Wipe a DPTS Token Balance from a DPTS account
    ;;
    ;;      CREDIT_DPTS                     Capability to perform crediting operations
    ;;      DEBIT_DPTS_SC                   Capability to perform debiting operations on Smart-Contract DPTS Account types
    ;;      DEBIT_DPTS_SC                   Capability to perform debiting operations on Normal DPTS Account types
    ;;      SC_TRANSFERABILITY              Enforce correct transferability when dealing with Smart-Contract Account types
    ;;      TRANSFER_DPTS                   Capability for transfer between 2 DPTS accounts for a specific Token identifier
    ;;
    ;;========================================================================================================
    ;;
    ;;      CAPABILITIES
    ;;
    ;;      BASIC
    ;;
    (defcap DPTS_OWNER (identifier:string)
        @doc "Enforces DPTS Token Ownership"
        (with-read DPTSPropertiesTable identifier
            { "owner" := owg }
            (enforce-guard owg)
        )
    )
    (defcap DPTS_ORGIN_VIRGIN (identifier:string)
        @doc "Enforces Origin Mint hasn't been executed"
        (with-read DPTSPropertiesTable identifier
            { "origin-mint" := om, "origin-mint-amount" := oma}
            (enforce (and (= om false)(= oma 0.0)) "Origin Mint cannot be executed any more !")
        )
    )
    (defcap DPTS_CAN-UPGRADE_ON (identifier:string)
        @doc "Enforces DPTS Token upgrade-ability"
        (with-read DPTSPropertiesTable identifier
            { "can-upgrade" := cu }
            (enforce (= cu true) (format "Token {} properties cannot be upgraded" [identifier]))
        )
    )
    (defcap DPTS_CAN-ADD-SPECIAL-ROLE_ON (identifier:string)
        @doc "Enforces Token Property as true"
        (with-read DPTSPropertiesTable identifier
            { "can-add-special-role" := casr }
            (enforce (= casr true) (format "For Token {} no special roles can be added" [identifier]))
        )
    )
    (defcap DPTS_CAN-FREEZE_ON (identifier:string)
        @doc "Enforces Token Property as true"
        (with-read DPTSPropertiesTable identifier
            { "can-freeze" := cf }
            (enforce (= cf true) (format "Token {} cannot be freezed" [identifier]))
        )
    )
    (defcap DPTS_CAN-WIPE_ON (identifier:string)
        @doc "Enforces Token Property as true"
        (with-read DPTSPropertiesTable identifier
            { "can-wipe" := cw }
            (enforce (= cw true) (format "Token {} cannot be wiped" [identifier]))
        )
    )
    (defcap DPTS_CAN-PAUSE_ON (identifier:string)
        @doc "Enforces Token Property as true"
        (with-read DPTSPropertiesTable identifier
            { "can-pause" := cp }
            (enforce (= cp true) (format "Token {} cannot be paused" [identifier]))
        )
    )
    (defcap DPTS_IS-PAUSED_ON (identifier:string)
        @doc "Enforces that the DPTS Token is paused"
        (with-read DPTSPropertiesTable identifier
            { "is-paused" := ip }
            (enforce (= ip true) (format "Token {} is already unpaused" [identifier]))
        )
    )
    (defcap DPTS_IS-PAUSED_OFF (identifier:string)
        @doc "Enforces that the DPTS Token is not paused"
        (with-read DPTSPropertiesTable identifier
            { "is-paused" := ip }
            (enforce (= ip false) (format "Token {} is already paused" [identifier]))
        )
    )
    (defcap UPDATE_DPTS_SUPPLY () 
        @doc "Capability required to update DPTS Supply" 
        true
    )
    ;;DPTS Account Properties Enforcements
    (defcap IZ-SC (account:string)
        @doc "Enforces DPTS Account is of Smart-Contract Type"
        (with-read DPTSAccountTypeTable account
            { "smart-contract" := sc }
            (enforce (= sc true) (format "Accunt {} is not a SC Account" [account]))
        )
    )
    (defcap DPTS_ACCOUNT_OWNER (identifier:string account:string)
        @doc "Enforces DPTS Account Ownership"
        (with-read DPTSBalancesTable (concat [identifier IASPLITTER account])
            { "guard" := g }
            (enforce-guard g)
        )
    )
    (defcap DPTS_ACCOUNT_BURN_ON (identifier:string account:string)
        @doc "Enforces DPTS Account has burn role on"
        (with-read DPTSBalancesTable (concat [identifier IASPLITTER account])
            { "role-burn" := rb }
            (enforce (= rb true) (format "Account {} isnt allowed to burn" [account]))
        )
    )
    (defcap DPTS_ACCOUNT_BURN_OFF (identifier:string account:string)
        @doc "Enforces DPTS Account has burn role off"
        (with-read DPTSBalancesTable (concat [identifier IASPLITTER account])
            { "role-burn" := rb }
            (enforce (= rb false) (format "Account {} is allowed to burn" [account]))
        )
    )
    (defcap DPTS_ACCOUNT_MINT_ON (identifier:string account:string)
        @doc "Enforces DPTS Account has mint role on"
        (with-read DPTSBalancesTable (concat [identifier IASPLITTER account])
            { "role-mint" := rm }
            (enforce (= rm true) (format "Account {} isnt allowed to mint" [account]))
        )
    )
    (defcap DPTS_ACCOUNT_MINT_OFF (identifier:string account:string)
        @doc "Enforces DPTS Account has mint role on"
        (with-read DPTSBalancesTable (concat [identifier IASPLITTER account])
            { "role-mint" := rm }
            (enforce (= rm false) (format "Account {} is allowed to mint" [account]))
        )
    )
    (defcap DPTS_ACCOUNT_TRANSFER_ON (identifier:string account:string)
        @doc "Enforces DPTS Account has transfer role on"
        (with-default-read DPTSBalancesTable (concat [identifier IASPLITTER account])
            { "role-transfer" : false }
            { "role-transfer" := rt }
            (enforce (= rt true) (format "Transfer Role is not valid for Account {}" [account]))
        )
    )
    (defcap DPTS_ACCOUNT_TRANSFER_OFF (identifier:string account:string)
        @doc "Enforces DPTS Account has transfer role on"
        (with-read DPTSBalancesTable (concat [identifier IASPLITTER account])
            { "role-transfer" := rt }
            (enforce (= rt false) (format "Account {} has transfer role" [account]))
        )
    )
    (defcap DPTS_ACCOUNT_TRANSFER_DEFAULT ()
        @doc "Transfer role capabilty required for uncreated receivers"
        true
    )
    (defcap DPTS_ACCOUNT_FREEZE_ON (identifier:string account:string)
        @doc "Enforces DPTS Account is frozen"
        (with-read DPTSBalancesTable (concat [identifier IASPLITTER account])
            { "frozen" := f }
            (enforce (= f true) (format "Account {} isnt frozen" [account]))
        )
    )
    (defcap DPTS_ACCOUNT_FREEZE_OFF (identifier:string account:string)
        @doc "Enforces DPTS Account is not frozen"
        (with-default-read DPTSBalancesTable (concat [identifier IASPLITTER account])
            { "frozen" : false}
            { "frozen" := f }
            (enforce (= f false) (format "Account {} is frozen" [account]))
        )
    )
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      COMPOSED
    ;;
    (defcap CONTROL_DPTS (identifier)
        @doc "Capability required for managing DPTS Properties"
        (compose-capability (DPTS_OWNER identifier))
        (compose-capability (DPTS_CAN-UPGRADE_ON identifier))
    )
    (defcap PAUSE_DPTS (identifier:string)
        @doc "Capability required to Pause a DPTS"
        (compose-capability (DPTS_OWNER identifier))
        (compose-capability (DPTS_CAN-PAUSE_ON identifier))
        (compose-capability (DPTS_IS-PAUSED_OFF identifier))
    )
    (defcap UNPAUSE_DPTS (identifier:string)
        @doc "Capability required to Unpause a DPTS"
        (compose-capability (DPTS_OWNER identifier))
        (compose-capability (DPTS_CAN-PAUSE_ON identifier))
        (compose-capability (DPTS_IS-PAUSED_ON identifier))
    )
    (defcap FREEZE_DPTS_ACCOUNT (identifier:string account:string)
        @doc "Capability required to Freeze a DPTS Account"
        (compose-capability (DPTS_OWNER identifier))
        (compose-capability (DPTS_CAN-FREEZE_ON identifier))
        (compose-capability (DPTS_ACCOUNT_FREEZE_OFF identifier account))
    )
    (defcap UNFREEZE_DPTS_ACCOUNT (identifier:string account:string)
        @doc "Capability required to Unfreeze a DPTS Account"
        (compose-capability (DPTS_OWNER identifier))
        (compose-capability (DPTS_CAN-FREEZE_ON identifier))
        (compose-capability (DPTS_ACCOUNT_FREEZE_ON identifier account))
    )
    (defcap SET_BURN-ROLE (identifier:string account:string)
        @doc "Capability required to Set Burn Role for DPTS Account"
        (compose-capability (DPTS_OWNER identifier))
        (compose-capability (DPTS_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPTS_ACCOUNT_BURN_OFF identifier account))
    )
    (defcap UNSET_BURN-ROLE (identifier:string account:string)
        @doc "Capability required to Unset Burn Role for DPTS Account"
        (compose-capability (DPTS_OWNER identifier))
        (compose-capability (DPTS_ACCOUNT_BURN_ON identifier account))
    )
    (defcap SET_MINT-ROLE (identifier:string account:string)
        @doc "Capability required to Set Mint Role for DPTS Account"
        (compose-capability (DPTS_OWNER identifier))
        (compose-capability (DPTS_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPTS_ACCOUNT_MINT_OFF identifier account))
    )
    (defcap UNSET_MINT-ROLE (identifier:string account:string)
        @doc "Capability required to Set Mint Role for DPTS Account"
        (compose-capability (DPTS_OWNER identifier))
        (compose-capability (DPTS_ACCOUNT_MINT_ON identifier account))
    )
    (defcap SET_TRANSFER-ROLE (identifier:string account:string)
        @doc "Capability required to Set Transfer Role for DPTS Account"
        (compose-capability (DPTS_OWNER identifier))
        (compose-capability (DPTS_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPTS_ACCOUNT_TRANSFER_OFF identifier account))
    )
    (defcap UNSET_TRANSFER-ROLE (identifier:string account:string)
        @doc "Capability required to Set Transfer Role for DPTS Account"
        (compose-capability (DPTS_OWNER identifier))
        (compose-capability (DPTS_ACCOUNT_TRANSFER_ON identifier account))
    )
    (defcap MINT_DPTS_ORIGIN (identifier:string account:string)
        @doc "Capability required to mint the Origin DPTS Mint Supply"
        (compose-capability (DPTS_OWNER identifier))
        (compose-capability (DPTS_ACCOUNT_OWNER identifier account))
        (compose-capability (DPTS_ORGIN_VIRGIN identifier))
        (compose-capability (CREDIT_DPTS account))
        (compose-capability (UPDATE_DPTS_SUPPLY))
    )
    (defcap MINT_DPTS (identifier:string account:string)
        @doc "Capability required to mint a DPTS Token locally \
        \ Smart-Contract Account type dont require their guard|key"
        (let
            (
                (iz-sc:bool (at 0 (U_GetDPTSAccountType account)))
            )
            (if (= iz-sc true)
                (let
                    (
                        (zero:integer 0)
                    )
                    (compose-capability (DPTS_ACCOUNT_MINT_ON identifier account))
                    (compose-capability (CREDIT_DPTS account))
                    (compose-capability (UPDATE_DPTS_SUPPLY))
                )
                (let
                    (
                        (zero:integer 0)
                    )
                    (compose-capability (DPTS_ACCOUNT_OWNER identifier account))
                    (compose-capability (DPTS_ACCOUNT_MINT_ON identifier account))
                    (compose-capability (CREDIT_DPTS account))
                    (compose-capability (UPDATE_DPTS_SUPPLY))
                )
            )
        )
    )
    (defcap BURN_DPTS (identifier:string account:string)
        @doc "Capability required to burn a DPTS Token locally \
        \ Smart-Contract Account type dont require their guard|key"
        (let
            (
                (iz-sc:bool (at 0 (U_GetDPTSAccountType account)))
            )
            (if (= iz-sc true)
                (let
                    (
                        (zero:integer 0)
                    )
                    (compose-capability (DPTS_ACCOUNT_BURN_ON identifier account))
                    (compose-capability (DEBIT_DPTS_SC account))
                    (compose-capability (UPDATE_DPTS_SUPPLY))
                )
                (let
                    (
                        (zero:integer 0)
                    )
                    (compose-capability (DPTS_ACCOUNT_OWNER identifier account))
                    (compose-capability (DPTS_ACCOUNT_BURN_ON identifier account))
                    (compose-capability (DEBIT_DPTS identifier account))
                    (compose-capability (UPDATE_DPTS_SUPPLY))
                )
            )
        )
    )
    (defcap WIPE_DPTS (identifier:string account:string)
        @doc "Capability required to Wipe a DPTS Token Balance from a DPTS account"
        (compose-capability (DPTS_OWNER identifier))
        (compose-capability (DPTS_CAN-WIPE_ON identifier))
        (compose-capability (DPTS_ACCOUNT_FREEZE_ON identifier account))
        (compose-capability (DEBIT_DPTS identifier account))
        (compose-capability (UPDATE_DPTS_SUPPLY))
    )
    (defcap CREDIT_DPTS (account:string)
        @doc "Capability to perform crediting operations"
        (enforce (!= account "") "Invalid receiver account")
    )
    (defcap DEBIT_DPTS_SC (account:string)
        @doc "Capability to perform debiting operations on Smart-Contract DPTS Account types\
        \ Does not enforce account guard."
        (enforce (!= account "") "Invalid receiver account")
    )
    (defcap DEBIT_DPTS (identifier:string account:string)
        @doc "Capability to perform debiting operations on Normal DPTS Account types"
        (enforce-guard 
            (at "guard" 
                (read DPTSBalancesTable (concat [identifier IASPLITTER account]) ["guard"])
            )
        )
        (enforce (!= account "") "Invalid sender account")
    )
    (defcap SC_TRANSFERABILITY (sender:string receiver:string method:bool)
        @doc "Enforce correct transferability when dealing with Smart-Contract Account types \
        \ When Method is set to true, transferability is always ensured"  
        (let
            (
                (compare:bool (U_CheckAccountsTransferability sender receiver))
            )
            (if (= method false)
                (enforce (= compare true) "Transferability to SC not satisfied")
                (enforce true "Transferability enforced as Method")
            )
        )
    )
    (defcap TRANSFER_DPTS (identifier:string sender:string receiver:string amount:decimal method:bool)
        @doc "Capability for transfer between 2 DPTS accounts for a specific Token identifier"
        (U_ValidateIdentifier identifier)
        (U_ValidateAmount identifier amount)

        (compose-capability (DPTS_IS-PAUSED_OFF identifier))
        (compose-capability (DPTS_ACCOUNT_FREEZE_OFF identifier sender))
        (compose-capability (DPTS_ACCOUNT_FREEZE_OFF identifier receiver))
        (with-read DPTSPropertiesTable identifier
            { "role-transfer-amount" := rta }
            (if (!= rta 0)
                ;;if true
                (or
                    (compose-capability (DPTS_ACCOUNT_TRANSFER_ON identifier sender))
                    (compose-capability (DPTS_ACCOUNT_TRANSFER_ON identifier receiver))
                )
                ;;if false
                (format "No transfer Role restrictions exist for Token {}" [identifier])
            )
        )
        (compose-capability (SC_TRANSFERABILITY sender receiver method))
        (let
            (
                (iz-sc:bool (at 0 (U_GetDPTSAccountType sender)))
            )
            (if (and (= iz-sc true) (= method true))
                (compose-capability (DEBIT_DPTS_SC sender))
                (compose-capability (DEBIT_DPTS identifier sender))
            )
        )   
        (compose-capability (CREDIT_DPTS receiver))
    )
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
    ;;      2)CLIENT                        can be called by any "foreign" DPTS account (SC or non-SC account)
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
    ;;      U_GetDPTSBalance                Returns the DPTS balance for given Token Identifier and Account
    ;;      U_GetDPTSSupply                 Return DPTS Token Total Supply for given identifier
    ;;      U_GetDPTSAccountType            Returns a boolean list with DPTS Account Type properties
    ;;      U_PrintDPTSAccountType          Prints Account Type for Displaying Purposes
    ;;      U_CheckAccountsTransferability  Checks if transferability is satisfied between account for transfer roles
    ;;      U_MakeDPTSIdentifier            Creates the DPTS Identifier string
    ;;      U_ValidateAccount               Enforces that an account ID meets charset and length requirements
    ;;      U_ValidateAmount                Enforces denomination for a specific DPTS identifier and positivity
    ;;      U_ValidateIdentifier            Enforces Identifier existance
    ;;      U_EnforceDecimals               Enforces correct decimal value for a given DPTS identifier
    ;;      U_EnforceTokenName              Enforces correct DPTS Token Name specifications
    ;;      U_EnforceTickerName             Enforces correct DPTS Ticker Name specifications
    ;;      U_IzAnCapital                   Checks if a string is alphanumeric with or without Uppercase Only
    ;;      U_IzCAnCapital                  Checks if a character is alphanumeric with or without Uppercase Only
    ;;      U_EnforceReserved               Enforce reserved account name protocols
    ;;      U_CheckReserved                 Checks account for reserved name
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
    ;;      C_IssueDPTS                     Issues a new DPTS Token with specified properties
    ;;      C_MakeStandardDPTSAccount       Creates a new Standard DPTS Account for a given Token Identifier
    ;;      C_MakeSmartDPTSAccount          Creates a new Smart DPTS Account for a given Token Identifier
    ;;      C_ControlSmartAccount           Manages a Smart DPTS Account Type via boolean triggers
    ;;      C_MintDPTSOrigin                Mints DPTS Origin Amount, the amount that is minted with creation
    ;;      C_ControlDPTS                   Manages DPTS Token Properties via boolean triggers

    ;;
    ;;      C_BurnDPTS                      Burns DPTS Tokens locally
    ;;      C_SetBurnRole                   Sets Burn Role for Token Identifier for account
    ;;      C_UnsetBurnRole                 Unsets Burn Role for Token Identifier for account
    ;;
    ;;      C_MintDPTS                      Mints DPTS Tokens locally
    ;;      C_SetMintRole                   Sets Mint Role for Token Identifier for account
    ;;      C_UnsetMintRole                 Unsets Mint Role for Token Identifier for account
    ;;
    ;;      C_SetTransferRole               Sets Transfer Role for Token Identifier for account
    ;;      C_UnsetTransferRole             Unsets Transfer Role for Token Identifier for account
    ;;
    ;;      C_WipeDPTS                      Wipes DPTS Tokens from a frozen account
    ;;      C_FreezeDPTSAccount             Freezes DPTS Token Identifier on Account
    ;;      C_UnfreezeDPTSAccount           Unfreezes DPTS Token Identifier on Account
    ;;
    ;;      C_PauseDPTS                     Pauses DPTS Token Identifier
    ;;      C_UnpauseDPTS                   Unpauses DPTS Token Identifier
    ;;
    ;;      C_TransferDPTS                  Standard transfer to from DPTS Account, failing if account doesnt exist
    ;;      C_TransferDPTSAnew              Standard transfer to from DPTS Account, and target account creation
    ;;      C_MethodicTransferDPTS          Methodic transfer to from DPTS Account, failing if account doesnt exist
    ;;      C_MethodicTransferDPTSAnew      Methodic transfer to from DPTS Account, and target account creation
    ;;
    ;;--------------------------------------------------------------------------------------------------------
    ;;
    ;;      AUXILIARY FUNCTIONS
    ;;
    ;;      X_CreditDPTS                    Increases balance for Account for Token Identifier
    ;;      X_DebitDPTS                     Decreases balance for Normal Account Types for Token Identifier
    ;;      X_DebitDPTSSC                   Decreases balance for Smart-Contract Account Types for Token Identifier
    ;;      X_UpdateDPTSSupply              Updates DPTS Token Supply
    ;;
    ;;========================================================================================================
    ;;
    ;;      UTILITY FUNCTIONS
    ;;
    ;;      U_GetDPTSBalance
    ;;
    (defun U_GetDPTSBalance:decimal (identifier:string account:string)
        @doc "Returns the DPTS balance for given Token Identifier and Account"
        (U_ValidateAccount account)
        (U_ValidateIdentifier identifier)

        (with-default-read DPTSBalancesTable (concat [identifier IASPLITTER account])
            { "balance" : 0.0 }
            { "balance" := b}
            b
        )
    )
    ;;
    ;;      U_GetDPTSSupply 
    ;;
    (defun U_GetDPTSSupply:decimal (identifier:string)
        @doc "Return DPTS Token Total Supply for given identifier"
        (U_ValidateIdentifier identifier)
        (at "supply" (read DPTSPropertiesTable identifier ["supply"]))
    )
    ;;
    ;;      U_GetDPTSAccountType
    ;;
    (defun U_GetDPTSAccountType:[bool] (account:string)
        @doc "Returns a boolean list with DPTS Account Type properties"
        (with-default-read DPTSAccountTypeTable account
            { "smart-contract" : false, "payable-as-smart-contract" : false, "payable-by-smart-contract" : false }
            { "smart-contract" := sc, "payable-as-smart-contract" := pasc, "payable-by-smart-contract" := pbsc }
            [sc pasc pbsc]
        )
    )
    ;;
    ;;      U_PrintDPTSAccountType
    ;;
    (defun U_PrintDPTSAccountType (account:string)
        @doc "Prints DPTS Account type Properties"
        (let* 
            (
                (account-type:[bool] (U_GetDPTSAccountType account))
                (a:bool (at 0 account-type))
                (b:bool (at 1 account-type))
                (c:bool (at 2 account-type))
            )
            (if (= a true)
                (format "Account {} is a Smart Account: Payable: {}; Payable by Smart Account: {}." [account b c])
                (format "Account {} is a Normal Account" [account])
            )
        )
    )
    ;;
    ;;      U_CheckAccountsTransferability
    ;;
    (defun U_CheckAccountsTransferability:bool (sender:string receiver:string)
        @doc "Checks if transferability is satisfied between account for transfer roles"
        (let*
            (
                (typea:[bool] (U_GetDPTSAccountType sender))
                (typeb:[bool] (U_GetDPTSAccountType receiver))
                (ssc:bool (at 0 typea))
                (sa:bool (at 1 typea))
                (sb:bool (at 2 typea))
                (rsc:bool (at 0 typeb))
                (ra:bool (at 1 typeb))
                (rb:bool (at 2 typeb))

                (v1:[bool] [false false false])
                (v2:[bool] [true false true])
                (v3:[bool] [true true false])
                (v4:[bool] [true true true])
            )
            (cond 
                ((and (= v1 [ssc sa sb])(= v1 [rsc ra rb])) true)
                ((and (= v1 [ssc sa sb])(= v2 [rsc ra rb])) false)
                ((and (= v1 [ssc sa sb])(= v3 [rsc ra rb])) true)
                ((and (= v1 [ssc sa sb])(= v4 [rsc ra rb])) true)

                ((and (= v2 [ssc sa sb])(= v1 [rsc ra rb])) true)
                ((and (= v2 [ssc sa sb])(= v2 [rsc ra rb])) true)
                ((and (= v2 [ssc sa sb])(= v3 [rsc ra rb])) false)
                ((and (= v2 [ssc sa sb])(= v4 [rsc ra rb])) true)

                ((and (= v3 [ssc sa sb])(= v1 [rsc ra rb])) true)
                ((and (= v3 [ssc sa sb])(= v2 [rsc ra rb])) true)
                ((and (= v3 [ssc sa sb])(= v3 [rsc ra rb])) false)
                ((and (= v3 [ssc sa sb])(= v4 [rsc ra rb])) true)

                ((and (= v4 [ssc sa sb])(= v1 [rsc ra rb])) true)
                ((and (= v4 [ssc sa sb])(= v2 [rsc ra rb])) true)
                ((and (= v4 [ssc sa sb])(= v3 [rsc ra rb])) false)
                true
                ;;last condition
                ;;((and (= v4 [ssc sa sb])(= v4 [rsc ra rb])) true)
            )
        )
    )
    ;;
    ;;      U_MakeDPTSIdentifier
    ;;
    (defun U_MakeDPTSIdentifier:string (ticker:string)
        @doc "Creates the DPTS Identifier string \ 
        \ using the first 12 Characters of the prev-block-hash of (chain-data) as randomness source"
        (let
            (
                (dash "-")
                (twelve (take 12 (at "prev-block-hash" (chain-data))))
            )
            (U_EnforceTickerName ticker)
            (concat [ticker dash twelve])
        )
    )
    ;;
    ;;      U_ValidateAccount 
    ;;
    (defun U_ValidateAccount (account:string)
        @doc "Enforces that an account ID meets charset and length requirements"
        (enforce
            (is-charset ACCOUNT_ID_CHARSET account)
            (format "Account ID does not conform to the required charset: {}" [account])
        )
        (enforce
            (not (contains account ACCOUNT_ID_PROHIBITED_CHARACTER))
            (format "Account ID contained a prohibited character: {}" [account])
        )
        (let 
            (
                (al (length account))
            )
            (enforce
              (>= al ACCOUNT_ID_MIN_LENGTH)
              (format "Account ID does not conform to the min length requirement: {}" [account])
            )
            (enforce
              (<= al ACCOUNT_ID_MAX_LENGTH)
              (format "Account ID does not conform to the max length requirement: {}" [account])
            )
        )
    )
    ;;
    ;;      U_ValidateAmount
    ;;
    (defun U_ValidateAmount (identifier:string amount:decimal)
        @doc "Enforce the minimum denomination for a specific DPTS identifier \
        \ and ensure the amount is greater than zero"
        (with-read DPTSPropertiesTable identifier
            { "decimals" := d }
            (enforce
                (= (floor amount d) amount)
                (format "The amount of {} does not conform with the {} number decimals." [amount identifier])
            )
            (enforce
                (> amount 0.0)
                (format "The amount of {} is not a valid transaction amount" [amount])
            )
        )
    )
    ;;
    ;;      U_ValidateIdentifier
    ;;
    (defun U_ValidateIdentifier (identifier:string)
        @doc "Enforces Identifier existance"
        (with-default-read DPTSPropertiesTable identifier
            { "supply" : -1.0 }
            { "supply" := s }
            (enforce
                (>= s 0.0)
                (format "Identifier {} does not exist." [identifier])
            )
        )
    )
    ;;
    ;;      U_EnforceDecimals
    ;;
    (defun U_EnforceDecimals:bool (decimals:integer)
        @doc "Enforces correct decimal value for a given DPTS identifier"
        (enforce
            (and
                (>= decimals DPTS_MIN_PRECISION)
                (<= decimals DPTS_MAX_PRECISION)
            )
            "Decimal Size is not between 2 and 24 as pe DPTS Standard!"
        )
    )
    ;;
    ;;      U_EnforceTokenName
    ;;
    (defun U_EnforceTokenName:bool (name:string)
        @doc "Enforces correct DPTS Token Name specifications"
        (let
            (
                (nl (length name))
            )
            (enforce
                (and
                    (>= nl DPTS_MIN_TOKEN_NAME_LENGTH)
                    (<= nl DPTS_MAX_TOKEN_NAME_LENGTH)
                )
            "Token Name does not conform to the DPTS Name Standard for Size!"
            )
            (enforce
                (U_IzAnCapital name false)
            "Token Name is not Alphanumeric!"
            )
        )    
    )
    ;;
    ;;      U_EnforceTickerName
    ;;
    (defun U_EnforceTickerName:bool (ticker:string)
        @doc "Enforces correct DPTS Ticker Name specifications"
        (let
            (
                (tl (length ticker))
            )
            (enforce
                (and
                    (>= tl DPTS_MIN_TOKEN_TICKER_LENGTH)
                    (<= tl DPTS_MAX_TOKEN_TICKER_LENGTH)
                )
            "Token Ticker does not conform to the DPTS Ticker Standard for Size!"
            )
            (enforce
                (U_IzAnCapital ticker true)
            "Token Ticker is not Alphanumeric with Capitals Only!"
            )
        )
    )
    ;;
    ;;      U_IzAnCapital
    ;;
    (defun U_IzAnCapital:bool (s:string capital:bool)
        @doc "Checks if a string is alphanumeric with or without Uppercase Only \
        \ Uppercase Only toggle is used by setting the capital boolean to true"

        (fold
            (lambda                                                         ;1st part of the Fold Function the Lambda
                (acc:bool c:string)                                         ;input variables of the lambda
                (and acc (U_IzCAnCapital c capital))                          ;operation of the input variables
            )
            true                                                            ;2nd part of the Fold Function, the initial accumulator value
            (str-to-list s)                                                 ;3rd part of the Fold Function, the List upon which the Lambda is executed
        )
    )
    ;;
    ;;      U_IzCAnCapital
    ;;
    (defun U_IzCAnCapital:bool (c:string capital:bool)
        @doc "Checks if a character is alphanumeric with or without Uppercase Only"
        (let*
            (
                (c1 (or (contains c CAPITAL_LETTERS)(contains c NUMBERS)))
                (c2 (or c1 (contains c NON_CAPITAL_LETTERS) ))
            )
            (if (= capital true) c1 c2)
        )
    )
    ;;
    ;;      U_EnforceReserved
    ;;
    (defun U_EnforceReserved:bool (account:string guard:guard)
        @doc "Enforce reserved account name protocols"
        (if 
            (validate-principal guard account)
            true
            (let 
                (
                    (r (U_CheckReserved account))
                )
                (if 
                    (= r "")
                    true
                    (if 
                        (= r "k")
                        (enforce false "Single-key account protocol violation")
                        (enforce false (format "Reserved protocol guard violation: {}" [r]))
                    )
                )
            )
        )
    )
    ;;
    ;;      U_CheckReserved
    ;;
    (defun U_CheckReserved:string (account:string)
        @doc "Checks account for reserved name and returns type if \
        \ found or empty string. Reserved names start with a \
        \ single char and colon, e.g. 'c:foo', which would return 'c' as type."
        (let 
            (
                (pfx (take 2 account))
            )
            (if (= ":" (take -1 pfx)) (take 1 pfx) "")
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
    ;;      C_IssueDPTS
    ;;
    (defun C_IssueDPTS:string 
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
        smart:bool)
        @doc "Issue a new DPTS Token. This creates an entry into the DPTSPropertiesTable. \
        \ Such an entry means the Token has been created. Function outputs as string the Token-Identifier \
        \ Token Identifier is formed from ticker, followed by a dash, \ 
        \ followed by the first 12 characters of the previous block hash to ensure uniqueness. \
        \ \
        \ Furthermore, The issuer creates a DPTS Account for himself, as the first Account of this DPTS Token \
        \ The smart:bool determines if the DPTS Account created is a Smart Account or a Normal Account \
        \ Once a DPTS Account is created its type (Normal or Smart) is fixed and cannot be changed. \
        \ \
        \ Token Owners must use smart:false when issuing a new DPTS. \
        \ Smart-Contract Accounts must use smart:true when issuing a new DPTS"
        (let
            (
                (identifier (U_MakeDPTSIdentifier ticker))
            )
            (U_EnforceTokenName name)
            ;; Enforce Ticker is part of identifier variable
            (U_EnforceDecimals decimals)

            ;; Add New Entries in the DPTSPropertyTable
            ;; Since the Entry uses insert command, the KEY uniquness is ensured, since it will fail if key already exists.
            ;; Entry is initialised with "is-paused" set to off(false).
            ;; Entry is initialised with a supply of 0.0 (decimal)
            ;; Entry is initialised with a false switch on the origin-mint, meaning origin mint hasnt been executed
            ;; Entry is initialised with an origin-mint-amount of 0.0, meaning origin mint hasnt been executed
            (insert DPTSPropertiesTable identifier
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
            ;; Make a NEW DPTS Account for the Token Issuer
            (if (= smart false)
                ;;Makes a Normal DPTS Account for the Token Issuer/Owner
                (C_MakeStandardDPTSAccount identifier account owner)
                ;;Makes a Smart DPTS Account for the Token Issuer/Owner
                ;;Standard settings are 
                ;;  payable-as-smart-contract:false and
                ;;  payable-by-smart-contract:true
                ;;  These can be changed later with C_ControlSmartAccount Function
                (C_MakeSmartDPTSAccount identifier account owner)
            )
            
            ;; Return the unique Token Identifier
            identifier
        )
    )
    ;;
    ;;      C_MakeStandardDPTSAccount
    ;;
    (defun C_MakeStandardDPTSAccount:string (identifier:string account:string guard:guard)
        @doc "Creates a new Normal DPTS Account for a given Token Identifier \
        \ If an Account was created with the same Account|Guard for a previous Token Identifier \
        \ using this function will only create a new Account for this new Identifier, but the \
        \ Account type (Normal or Smart) will remain unchanged"
        (U_ValidateAccount account)
        (U_ValidateIdentifier identifier)
        (U_EnforceReserved account guard)
        (insert DPTSBalancesTable (concat [identifier IASPLITTER account])
            { "balance"                     : 0.0
            , "guard"                       : guard
            , "role-burn"                   : false
            , "role-mint"                   : false
            , "role-transfer"               : false
            , "frozen"                      : false
            }
        )
        (with-default-read DPTSAccountTypeTable account
            { "smart-contract" : false, "payable-as-smart-contract" : false, "payable-by-smart-contract" : false }
            { "smart-contract" := sc, "payable-as-smart-contract" := pasc, "payable-by-smart-contract" := pbsc }
            (write DPTSAccountTypeTable account
                { "smart-contract"              : sc
                , "payable-as-smart-contract"   : pasc
                , "payable-by-smart-contract"   : pbsc
                }  
            )
        )     
    )
    ;;
    ;;      C_MakeStandardDPTSAccount
    ;;
    (defun C_MakeSmartDPTSAccount:string (identifier:string account:string guard:guard)
        @doc "Creates a new DPTS Smart Account for a given Token Identifier \
        \ If an Account was created with the same Account|Guard for a previous Token Identifier \
        \ using this function will only create a new Account for this new Identifier, but the \
        \ Account type (Normal or Smart) will remain unchanged"
        (U_ValidateAccount account)
        (U_ValidateIdentifier identifier)
        (U_EnforceReserved account guard)
        (insert DPTSBalancesTable (concat [identifier IASPLITTER account])
            { "balance"                     : 0.0
            , "guard"                       : guard
            , "role-burn"                   : false
            , "role-mint"                   : false
            , "role-transfer"               : false
            , "frozen"                      : false
            }
        )
        (with-default-read DPTSAccountTypeTable account
            { "smart-contract" : true, "payable-as-smart-contract" : false, "payable-by-smart-contract" : true }
            { "smart-contract" := sc, "payable-as-smart-contract" := pasc, "payable-by-smart-contract" := pbsc }
            (write DPTSAccountTypeTable account
                { "smart-contract"              : sc
                , "payable-as-smart-contract"   : pasc
                , "payable-by-smart-contract"   : pbsc
                }  
            )
        )
    )
    ;;
    ;;      C_ControlSmartAccount
    ;;
    (defun C_ControlSmartAccount (account:string payable-as-smart-contract:bool payable-by-smart-contract:bool)
        @doc "Manages Smart-Contract DPTS Account Type via boolean triggers"
        (with-capability (IZ-SC account)
            (update DPTSAccountTypeTable account
                {"payable-as-smart-contract"    : payable-as-smart-contract
                ,"payable-by-smart-contract"    : payable-by-smart-contract}
            )
        )
    )
    ;;
    ;;      C_MintDPTSOrigin
    ;;
    (defun C_MintDPTSOrigin (identifier:string account:string amount:decimal)
        @doc "Mints DPTS Origin Amount, the amount that is minted with creation"
        (with-capability (MINT_DPTS_ORIGIN identifier account)
            (with-read DPTSBalancesTable (concat [identifier IASPLITTER account])
                { "guard" := g }
                (X_CreditDPTS identifier account g amount)
            )
            (update DPTSPropertiesTable identifier { "origin-mint" : false, "origin-mint-amount" : amount})
            (X_UpdateDPTSSupply identifier amount true)
        )
    )
    ;;
    ;;      C_ControlDPTS 
    ;;
    (defun C_ControlDPTS (identifier:integer can-change-owner:bool can-upgrade:bool can-add-special-role:bool can-freeze:bool can-wipe:bool can-pause:bool)
        @doc "Manages DPTS Token Properties via boolean triggers \
        \ Setting the <can-upgrade> property to off(false) disables all future Properties control"
        (U_ValidateIdentifier identifier)
        (with-capability (CONTROL_DPTS identifier)
            (update DPTSPropertiesTable identifier
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
    ;;      C_BurnDPTS
    ;;
    (defun C_BurnDPTS (identifier:string account:string amount:decimal)
        @doc "Burns DPTS Tokens locally"
        (with-capability (BURN_DPTS identifier account)
            (X_DebitDPTS identifier account amount)
            (X_UpdateDPTSSupply identifier amount false)
        )
    )
    ;;
    ;;      C_SetBurnRole
    ;;
    (defun C_SetBurnRole (identifier:string account:string)
        @doc "Sets Burn Role for Token Identifier for account \
        \ Then this account can burn Tokens"
        (with-capability (SET_BURN-ROLE identifier account)
            (update DPTSBalancesTable (concat [identifier IASPLITTER account])
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
        (with-capability (UNSET_BURN-ROLE identifier account)
            (update DPTSBalancesTable (concat [identifier IASPLITTER account])
                {"role-burn" : false}
            )
        )
    )
    ;;
    ;;      C_MintDPTS 
    ;;
    (defun C_MintDPTS (identifier:string account:string amount:decimal)
        @doc "Mints DPTS Tokens locally"
        (with-capability (MINT_DPTS identifier account)
            (with-read DPTSBalancesTable (concat [identifier IASPLITTER account])
                { "guard" := g }
                (X_CreditDPTS identifier account g amount)
            )
            ;(CreditDPTS identifier account guard amount)
            (X_UpdateDPTSSupply identifier amount true)
        )
    )
    ;;
    ;;      C_SetMintRole
    ;;
    (defun C_SetMintRole (identifier:string account:string)
        @doc "Sets Mint Role for Token Identifier for account \
        \ Then this account can mint Tokens"
        (with-capability (SET_MINT-ROLE identifier account)
            (update DPTSBalancesTable (concat [identifier IASPLITTER account])
                {"role-mint" : true}
            )
        )
    )
    ;;
    ;;      C_UnsetMintRole
    ;;
    (defun C_UnsetMintRole (identifier:string account:string)
        @doc "Unsets Mint Role for Token Identifier for account \
        \ Account can no longer mint Tokens"
        (with-capability (UNSET_MINT-ROLE identifier account)
            (update DPTSBalancesTable (concat [identifier IASPLITTER account])
                {"role-mint" : false}
            )
        )
    )
    ;;
    ;;      C_SetTransferRole
    ;;
    (defun C_SetTransferRole (identifier:string account:string)
        @doc "Sets Transfer Role for Token Identifier for account \
        \ Tokens can only be transfered to this account, while this account can transfer to any other account"
        (with-capability (SET_TRANSFER-ROLE identifier account)
            (update DPTSBalancesTable (concat [identifier IASPLITTER account])
                {"role-transfer" : true}
            )
        )
    )
    ;;
    ;;      C_UnsetTransferRole
    ;;
    (defun C_UnsetTransferRole (identifier:string account:string)
        @doc "Unsets Transfer Role for Token Identifier for account"
        (with-capability (UNSET_TRANSFER-ROLE identifier account)
            (update DPTSBalancesTable (concat [identifier IASPLITTER account])
                {"role-burn" : false}
            )
        )
    )
    ;;
    ;;      C_WipeDPTS
    ;;
    (defun C_WipeDPTS (identifier:string account:string)
        @doc "Wipes DPTS Tokens from a frozen account"
        (with-capability (WIPE_DPTS identifier account)
            (let
                (
                    (amount:decimal (U_GetDPTSBalance identifier account))
                )
                (X_DebitDPTS identifier account amount)
                (X_UpdateDPTSSupply identifier amount false)   
            )
        )
    )
    ;;
    ;;      C_FreezeDPTSAccount
    ;;
    (defun C_FreezeDPTSAccount (identifier:string account:string)
        @doc "Freezes DPTS Token Identifier on Account"
        (U_ValidateIdentifier identifier)
        (U_ValidateAccount account)
        (with-capability (FREEZE_DPTS_ACCOUNT identifier account)
            (update DPTSBalancesTable (concat [identifier IASPLITTER account]) { "frozen" : true})
        )
    )
    ;;
    ;;      C_UnfreezeDPTSAccount 
    ;;
    (defun C_UnfreezeDPTSAccount (identifier:string account:string)
        @doc "Unfreezes DPTS Token Identifier on Account"
        (U_ValidateIdentifier identifier)
        (U_ValidateAccount account)
        (with-capability (UNFREEZE_DPTS_ACCOUNT identifier account)
            (update DPTSBalancesTable (concat [identifier IASPLITTER account]) { "frozen" : false})
        )
    )
    ;;
    ;;      C_PauseDPTS
    ;;
    (defun C_PauseDPTS (identifier:string)
        @doc "Pauses DPTS Token Identifier"
        (U_ValidateIdentifier identifier)
        (with-capability (PAUSE_DPTS identifier)
            (update DPTSPropertiesTable identifier { "is-paused" : true})
        )
    )
    ;;
    ;;      C_UnpauseDPTS
    ;;
    (defun C_UnpauseDPTS (identifier:string)
        @doc "Unpauses DPTS Token Identifier"
        (U_ValidateIdentifier identifier)
        (with-capability (UNPAUSE_DPTS identifier)
            (update DPTSPropertiesTable identifier { "is-paused" : false})
        )
    )
    ;;
    ;;      C_TransferDPTS
    ;;
    (defun C_TransferDPTS (identifier:string sender:string receiver:string amount:decimal)
        @doc "Standard transfer to from DPTS Account, failing if account doesnt exist"
        (with-capability (TRANSFER_DPTS identifier sender receiver amount false)
            (X_DebitDPTS identifier sender amount)
            (with-read DPTSBalancesTable (concat [identifier IASPLITTER receiver])
                { "guard" := guard }
                (X_CreditDPTS identifier receiver guard amount)
            )
        )
    )
    ;;
    ;;      C_TransferDPTSAnew
    ;;
    (defun C_TransferDPTSAnew (identifier:string sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "Standard transfer to from DPTS Account, and target account creation"
        (with-capability (TRANSFER_DPTS identifier sender receiver amount false)
            (X_DebitDPTS identifier sender amount)
            (X_CreditDPTS identifier receiver receiver-guard amount)
        )
    )
    ;;
    ;;      C_MethodicTransferDPTS
    ;;
    (defun C_MethodicTransferDPTS (identifier:string sender:string receiver:string amount:decimal)
        @doc "Methodic transfer to from DPTS Account, failing if account doesnt exist \
        \ Methodic means the transfer is used as a method for Smart-Contract Account type operations"
        (require-capability (TRANSFER_DPTS identifier sender receiver amount true))
        (with-read DPTSBalancesTable (concat [identifier IASPLITTER receiver])
                { "guard" := guard }
                (X_DebitDPTS identifier sender amount)
                (X_CreditDPTS identifier receiver guard amount)
        )    
    )
    ;;
    ;;      C_MethodicTransferDPTSAnew
    ;;
    (defun C_MethodicTransferDPTSAnew (identifier:string sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "Methodic transfer to from DPTS Account, and target account creation \
        \ Methodic means the transfer is used as a method for Smart-Contract Account type operations"
        (require-capability (TRANSFER_DPTS identifier sender receiver amount true))
        (X_DebitDPTS identifier sender amount)
        (X_CreditDPTS identifier receiver receiver-guard amount)
    )
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      AUXILIARY FUNCTIONS
    ;;
    ;;      X_CreditDPTS
    ;;
    (defun X_CreditDPTS (identifier:string account:string guard:guard amount:decimal)
        @doc "Increases balance for Account for Token Identifier \
        \ Also creates a new DPTS account if the target account doesnt exist"
        ;; Validate Inputs
        (U_ValidateAccount account)
        (U_ValidateIdentifier identifier)
        (U_ValidateAmount identifier amount)

        ;;Capability Required for Credit
        (require-capability (CREDIT_DPTS account))
        (with-default-read DPTSBalancesTable (concat [identifier IASPLITTER account])
            { "balance" : -1.0, "guard" : guard, "role-burn" : false, "role-mint" : false, "role-transfer" : false, "frozen" : false}
            { "balance" := balance, "guard" := retg, "role-burn" := rb, "role-mint" := rm, "role-transfer" := rt, "frozen" := fr }
            ; we don't want to overwrite an existing guard with the user-supplied one
            (enforce (= retg guard) "Account guards do not match !")
            (let 
                (
                    (is-new (if (= balance -1.0) (U_EnforceReserved account guard) false))
                )
                ;; if is-new=true, this actually creates a new account and credits it the amount
                ;; if is-new=false, this updates the balance by increasing it with amount
                ;; this is posible because (write) works regardless of row exists for key or not in a table
                (write DPTSBalancesTable (concat [identifier IASPLITTER account])
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
    ;;      X_DebitDPTS
    ;;
    (defun X_DebitDPTS (identifier:string account:string amount:decimal)
        @doc "Decreases balance for Normal Account Types f for Token Identifier"
        ;; Validate Inputs
        (U_ValidateAccount account)
        (U_ValidateIdentifier identifier)
        (U_ValidateAmount identifier amount)

        ;;Capability Required for Debit
        (let
            (
                (iz-sc:bool (at 0 (U_GetDPTSAccountType account)))
            )
            (if (= iz-sc true)
                (require-capability (DEBIT_DPTS_SC account))
                (require-capability (DEBIT_DPTS identifier account))
            )
            (with-read DPTSBalancesTable (concat [identifier IASPLITTER account])
                { "balance" := balance }
                ; we don't want to overwrite an existing guard with the user-supplied one
                (enforce (<= amount balance) "Insufficient Funds for debiting")
                (update DPTSBalancesTable (concat [identifier IASPLITTER account])
                    {"balance" : (- balance amount)}    
                )
            )     
        )

    )
    ;;
    ;;      X_UpdateDPTSSupply 
    ;;
    (defun X_UpdateDPTSSupply (identifier:string amount:decimal direction:bool)
        ;; Validate Inputs
        (U_ValidateIdentifier identifier)
        (U_ValidateAmount identifier amount)

        (require-capability (UPDATE_DPTS_SUPPLY))
        (if (= direction true)
            (with-read DPTSPropertiesTable identifier
                { "supply" := s }
                (enforce (>= (+ s amount) 0.0) "DPTS Token Supply cannot be updated to negative values!")
                (update DPTSPropertiesTable identifier { "supply" : (+ s amount)})
            )
            (with-read DPTSPropertiesTable identifier
                { "supply" := s }
                (enforce (>= (- s amount) 0.0) "DPTS Token Supply cannot be updated to negative values!")
                (update DPTSPropertiesTable identifier { "supply" : (- s amount)})
            )
        )
    )
)
 
(create-table DPTSPropertiesTable)
(create-table DPTSBalancesTable)
(create-table DPTSAccountTypeTable)