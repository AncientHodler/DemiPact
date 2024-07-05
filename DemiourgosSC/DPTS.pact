(module DPTS GOVERNANCE
    @doc "DPTS is the Demiourgos.Holdings Smart-Contract for the management of DPTS.\
    \ DPTS or the Demiourgos-Pact-Token-Standard is a Pact Token Standard created by Demiourgos.Holdings \
    \ that mimics the Token Functionalities that were introduced by MultiversX (former Elrond) Blockchain. \
    \ \
    \ This Includes 4 types of Tokens: Fungible, Meta-Fungible, Semi-Fungible and Non-Fungible. \
    \ \
    \                                                       DPTS                \
    \ \
    \ Demiourgos Pact True Fungible Token Standard          DPTF Token Standard \
    \ Demiourgos Pact Meta Fungible Token Standard          DPMF Token Standard \
    \ Demiourgos Pact Semi Fungible Token Standard          DPSF Token Standard \
    \ Demiourgos Pact Non  Fungible Token Standard          DPNF Token Standard"

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
    (defconst BAR "|")
    (defconst NUMBERS ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9"])
    (defconst CAPITAL_LETTERS ["A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"])
    (defconst NON_CAPITAL_LETTERS ["a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"])
    ;;SCHEMAS Definitions
    (defschema DPTS-AccountSchema
        @doc "Schema that stores Account Type information \
        \ Account type means if the Account is a Standard DPTS Account \
        \ or if the Account is tagged as a Smart-Contract Account \ 
        \ Smart Contract Account Types have different logic for transfers."
        guard:guard                         ;;Guard of the DPTS account
        smart-contract:bool                 ;;when true Account is of Smart-Contract type, otherwise is Normal DPTS Account
        payable-as-smart-contract:bool      ;;when true, the Smart-Contract Account is payable by Normal DPTS Accounts
        payable-by-smart-contract:bool      ;;when true, the Smart-Contract Account is payable by Smart-Contract DPTS Accounts
    )
    ;;TABLES Definitions
    (deftable DPTS-AccountTable:{DPTS-AccountSchema})
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
    ;;      IZ_DPTS_ACOUNT                  Enforces That a DPTS Account exists
    ;;      IZ_DPTS_ACOUNT_SMART            Enforces That a DPTS Account is of a Smart DPTS Account
    ;;      SC_TRANSFERABILITY              Enforce correct transferability between DPTS Accounts
    ;;
    ;;=======================================================================================================
    ;;
    ;;      CAPABILITIES
    ;;
    ;;      BASIC                           Basic Capabilities represent singular capability Definitions
    ;;
    (defcap IZ_DPTS_ACOUNT (account:string)
        (with-read DPTS-AccountTable account
            { "smart-contract" := sc }
            (enforce (or (= sc true)(= sc false)) (format "DPTS Account {} doesnt exist!" [account]) )   
        )
    )
    (defcap IZ_DPTS_ACCOUNT_SMART (account:string)
        @doc "Enforces DPTS Account is of Smart-Contract Type"
        (with-read DPTS-AccountTable account
            { "smart-contract" := sc }
            (enforce (= sc true) (format "Account {} is not a SC Account" [account]))
        )
    )
    (defcap SC_TRANSFERABILITY (sender:string receiver:string method:bool)
        @doc "Enforce correct transferability when dealing with Smart(Contract) DPTS Account types \
        \ When Method is set to true, transferability is always ensured"  
        (let
            (
                (compare:bool (U_CheckAccountsTransferability sender receiver))
            )
            (if (= method false)
                (enforce (= compare true) "Transferability to Smart(Contract) DPTS Account type not satisfied")
                (enforce true "Transferability enforced as Method")
            )
        )
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
    ;;      U_GetDPTSAccountType            Returns a boolean list with DPTS Account Type properties
    ;;      U_PrintDPTSAccountType          Prints Account Type for Displaying Purposes
    ;;      U_CheckAccountsTransferability  Checks if transferability is satisfied between account for transfer roles
    ;;      U_MakeDPTSIdentifier            Creates the DPTS Identifier string
    ;;      U_ValidateAccount               Enforces that an account ID meets charset and length requirements
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
    ;;      C_DeployStandardDPTSAccount     Deploys a Standard DPTS Account
    ;;      C_DeploySmartDPTSAccount        Deploys a Smart DPTS Account
    ;;      C_ControlSmartAccount           Manages a Smart DPTS Account
    ;;
    ;;--------------------------------------------------------------------------------------------------------
    ;;
    ;;      AUXILIARY FUNCTIONS
    ;;
    ;;      NO AUXILIARY FUNCTIONS
    ;;
    ;;========================================================================================================
    ;;
    ;;
    ;;      U_GetDPTSAccountType
    ;;
    (defun U_GetDPTSAccountType:[bool] (account:string)
        @doc "Returns a boolean list with DPTS Account Type properties"
        (with-default-read DPTS-AccountTable account
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
    ;;      C_DeployStandardDPTSAccount
    ;;
    (defun C_DeployStandardDPTSAccount (account:string guard:guard)
        @doc "Deploys a Standard DPTS Account. \
        \ Before any DPTF|DPMF|DPFS|DPNF Token can be created and used, \
        \ a Standard or Smart DPTS Account must be deployed \
        \ Equivalent to creting a new ERD Address \
        \ \
        \ By Default a Standard DPTS Account is created automatically \
        \ when a new DPTF|DPMF|DPFS|DPNF Token Account is created or Token issued, \
        \ so there shouldnt be any need to use this function directly \
        \ \
        \ If a DPTS Account already exists, this function does no modifications "
        (U_ValidateAccount account)
        (U_EnforceReserved account guard)

        (with-default-read DPTS-AccountTable account
            { "guard" : guard, "smart-contract" : false, "payable-as-smart-contract" : false, "payable-by-smart-contract" : false }
            { "guard" := g, "smart-contract" := sc, "payable-as-smart-contract" := pasc, "payable-by-smart-contract" := pbsc }
            (write DPTS-AccountTable account
                { "guard"                       : g
                , "smart-contract"              : sc
                , "payable-as-smart-contract"   : pasc
                , "payable-by-smart-contract"   : pbsc
                }  
            )
        )
    )
    ;;
    ;;      C_DeploySmartDPTSAccount
    ;;
    (defun C_DeploySmartDPTSAccount (account:string guard:guard)
        @doc "Deploys a Smart DPTS Account. \
        \ Before any DPTF, DPMF, DPSF, DPNF Token can be created, \
        \ a Standard or Smart DPTS Account must be deployed \
        \ Equivalent to creating a new ERD Smart-Contract Address \
        \ \
        \ This function must be used when deploying \
        \ what on MultiversX would be a new Smart-Contract"

        (U_ValidateAccount account)
        (U_EnforceReserved account guard)

        (insert DPTS-AccountTable account
            { "guard"                       : guard
            , "smart-contract"              : true
            , "payable-as-smart-contract"   : false
            , "payable-by-smart-contract"   : true
            }  
        )  
    )
    ;;
    ;;      C_ControlSmartAccount
    ;;
    (defun C_ControlSmartAccount (account:string payable-as-smart-contract:bool payable-by-smart-contract:bool)
        @doc "Manages Smart DPTS Account Type via boolean triggers"
        (with-capability (IZ_DPTS_ACCOUNT_SMART account)
            (update DPTS-AccountTable account
                {"payable-as-smart-contract"    : payable-as-smart-contract
                ,"payable-by-smart-contract"    : payable-by-smart-contract}
            )
        )
    )
)
 
(create-table DPTS-AccountTable)