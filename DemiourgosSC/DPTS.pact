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

    ;;0]GOVERNANCE-ADMIN
    ;;
    ;;      GOVERNANCE|DPTS_ADMIN
    ;;
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
        \ Set to DPTS_ADMIN so that only Module Key can enact an upgrade"
        false
    )
    (defcap DPTS_ADMIN ()
        (enforce-guard (keyset-ref-guard SC_KEY))
    )

    ;;1]CONSTANTS Definitions
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

    ;;2]SCHEMAS Definitions
    (defschema DPTS-AccountSchema
        @doc "Schema that stores Account Type information \
        \ Account type means if the Account is a Standard DPTS Account \
        \ or if the Account is tagged as a Smart-Contract Account \ 
        \ Smart Contract Account Types have different logic for transfers."
        guard:guard                         ;;Guard of the DPTS account
        smart-contract:bool                 ;;when true Account is of Smart-Contract type, otherwise is Normal DPTS Account
        payable-as-smart-contract:bool      ;;when true, the Smart-Contract Account is payable by Normal DPTS Accounts
        payable-by-smart-contract:bool      ;;when true, the Smart-Contract Account is payable by Smart-Contract DPTS Accounts
        nonce:integer                       ;;store how many transactions the account executed
    )

    ;;3]TABLES Definitions
    (deftable DPTS-AccountTable:{DPTS-AccountSchema})

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
    ;;      BASIC                                                                                                                                       ;;
    ;;                                                                                                                                                  ;;
    ;;      IZ_DPTS_ACOUNT                          Enforces That a DPTS Account exists                                                                 ;;
    ;;      IZ_DPTS_ACOUNT_SMART                    Enforces That a DPTS Account is of a Smart DPTS Account                                             ;;
    ;;      SC_TRANSFERABILITY                      Enforce correct transferability between DPTS Accounts                                               ;;
    ;;      DPTS_INCREASE-NONCE                     Capability required to increment the DPTS nonce                                                     ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;


    ;;==============================================
    ;;                                            ;;
    ;;      CAPABILITIES                          ;;
    ;;                                            ;;
    ;;      BASIC                                 ;;
    ;;                                            ;;
    ;-----------------------------------------------
    ;;
    (defcap IZ_DPTS_ACOUNT (account:string)
        (with-read DPTS-AccountTable account
            { "smart-contract" := sc }
            (enforce (or (= sc true)(= sc false)) (format "DPTS Account {} doesnt exist!" [account]) )   
        )
    )
    (defcap IZ_DPTS_ACCOUNT_SMART (account:string)
        @doc "Enforces DPTS Account is of Smart-Contract Type"
        (let
            (
                (x:bool (UR_DPTS-AccountType account))
            )
            (enforce (= x true) (format "Account {} is not a SC Account" [account])
            )
        )
    )
    (defcap SC_TRANSFERABILITY (sender:string receiver:string method:bool)
        @doc "Enforce correct transferability when dealing with Smart(Contract) DPTS Account types \
        \ When Method is set to true, transferability is always ensured"  
        (let
            (
                (compare:bool (UC_DPTS-AccountsTransferability sender receiver))
            )
            (if (= method false)
                (enforce (= compare true) "Transferability to Smart(Contract) DPTS Account type not satisfied")
                (enforce true "Transferability enforced as Method")
            )
        )
    )
    (defcap DPTS_INCREASE-NONCE ()
        @doc "Capability required to increment the DPTS nonce"
        true
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
    ;;      UR_DPTS-AccountGuard                    Returns DPTS Account <account> Guard                                                                ;;
    ;;      UR_DPTS-AccountProperties               Returns a boolean list with DPTS Account Type Properties                                            ;;
    ;;      UR_DPTS-AccountType                     Returns DPTS Account <account> Boolean type                                                         ;;
    ;;      UR_DPTS-AccountPayableAs                Returns DPTS Account <account> Boolean payables-as-smart-contract                                   ;;
    ;;      UR_DPTS-AccountPayableBy                Returns DPTS Account <account> Boolean payables-by-smart-contract                                   ;;
    ;;      UR_DPTS-AccountNonce                    Returns DPTS Account <account> nonce value                                                          ;;
    ;;      UP_DPTS-AccountProperties               Prints DPTS Account <account> Properties                                                            ;;
    ;;==================COMPUTING===================                                                                                                    ;;
    ;;      UC_DPTS-AccountsTransferability         Computes transferability between 2 DPTS Accounts, <sender> and <receiver>                           ;;
    ;;      UC_FilterIdentifier                     Helper Function needed for returning DPTS identifiers for Account <account>                         ;;
    ;;      UC_MakeIdentifier                       Creates a DPTS Idendifier                                                                           ;;
    ;;      UC_MakeMVXNonce                         Creates a MultiversX specific NFT nonce from an integer                                             ;;
    ;;==================VALIDATIONS=================                                                                                                    ;;
    ;;      UV_SenderWithReceiver                   Validates Account <sender> with Account <receiver> for Transfer                                     ;;
    ;;      UV_DPTS-Account                         Enforces that Account <account> ID meets charset and length requirements                            ;;
    ;;      UV_DPTS-Decimals                        Enforces correct decimal value for a given DPTS identifier                                          ;;
    ;;      UV_DPTS-Name                            Enforces the DPTS Token Name conform as per DPTS standards                                          ;;
    ;;      UV_DPTS-Ticker                          Enforces the DPTS Token Ticker conform as per DPTS standards                                        ;;
    ;;      UV_Object                               Validates that an Object has the required size and keys                                             ;;
    ;;==================STRINGS-CHECKS==============                                                                                                    ;;
    ;;      UC_IzStringANC                          Checks if a string is alphanumeric with or without Uppercase Only                                   ;;
    ;;      UC_IzCharacterANC                       Checks if a character is alphanumeric with or without Uppercase Only                                ;;
    ;;      UV_EnforceReserved                      Enforce reserved account name protocols                                                             ;;
    ;;      UV_CheckReserved                        Checks account for reserved name                                                                    ;;
    ;;==================LIST-OPERATIONS=============                                                                                                    ;;
    ;;      UC_SplitString                          Splits a string unsing a single string as splitter                                                  ;;
    ;;      UC_Search                               Search an item into the list and returns a list of index                                            ;;
    ;;      UC_ReplaceItem                          Replace each occurrence of old-item by new-item                                                     ;;
    ;;      UC_RemoveItem                           Remove an item from a list                                                                          ;;
    ;;      UC_FirstListElement                     Returns the first item of a list                                                                    ;;
    ;;      UC_SecondListElement                    Returns the second item of a list                                                                   ;;
    ;;      UC_LastListElement                      Returns the last item of the list                                                                   ;;
    ;;      UC_InsertFirst                          Insert an item at the left of the list                                                              ;;
    ;;      UC_AppendLast                           Append an item at the end of the list                                                               ;;
    ;;      UV_EnforceNotEmpty                      Verify and Enforces that a list is not empty                                                        ;;
    ;;      UV_IsNotEmpty                           Return true if the list is not empty                                                                ;;
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
    ;;      C_DeployStandardDPTSAccount     Deploys a Standard DPTS Account                                                                             ;;
    ;;      C_DeploySmartDPTSAccount        Deploys a Smart DPTS Account                                                                                ;;
    ;;      C_ControlSmartAccount           Manages a Smart DPTS Account                                                                                ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      AUXILIARY FUNCTIONS                                                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;      X_IncrementNonce                Increments <identifier> DPTS Account nonce                                                                  ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;


    ;;==============================================
    ;;                                            ;;
    ;;      UTILITY FUNCTIONS                     ;;
    ;;                                            ;;
    ;;==================ACCOUNT-INFO================
    ;;
    ;;      UR_DPTS-AccountGuard|UR_DPTS-AccountProperties
    ;;      UR_DPTS-AccountType|UR_DPTS-AccountPayableAs|UR_DPTS-AccountPayableBy
    ;;      UR_DPTS-AccountNonce|UP_DPTS-AccountProperties
    ;;
    (defun UR_AccountTrueFungibleGuard:guard (account:string)
        @doc "Returns DPTS Account <account> Guard"
        (DPTS.UV_DPTS-Account account)
        (at "guard" (read DPTS-AccountTable account ["guard"]))
    )
    (defun UR_DPTS-AccountProperties:[bool] (account:string)
        @doc "Returns a boolean list with DPTS Account Type properties"
        (with-default-read DPTS-AccountTable account
            { "smart-contract" : false, "payable-as-smart-contract" : false, "payable-by-smart-contract" : false}
            { "smart-contract" := sc, "payable-as-smart-contract" := pasc, "payable-by-smart-contract" := pbsc }
            [sc pasc pbsc]
        )
    )
    (defun UR_DPTS-AccountType:bool (account:string)
        @doc "Returns DPTS Account <account> Boolean type"
        (at 0 (UR_DPTS-AccountProperties account))
    )
    (defun UR_DPTS-AccountAccountPayableAs:bool (account:string)
        @doc "Returns DPTS Account <account> Boolean payables-as-smart-contract"
        (at 1 (UR_DPTS-AccountProperties account))
    )
    (defun UR_DPTS-AccountAccountPayableBy:bool (account:string)
        @doc "Returns DPTS Account <account> Boolean payables-by-smart-contract"
        (at 2 (UR_DPTS-AccountProperties account))
    )
    (defun UR_DPTS-AccountNonce:integer (account:string)
        @doc "Returns DPTS Account <account> nonce value"
        (with-default-read DPTS-AccountTable account
            { "nonce" : 0 }
            { "nonce" := n }
            n
        )
    )
    (defun UP_DPTS-AccountProperties (account:string)
        @doc "Prints DPTS Account <account> Properties"
        (let* 
            (
                (p:[bool] (UR_DPTS-AccountProperties account))
                (a:bool (at 0 p))
                (b:bool (at 1 p))
                (c:bool (at 2 p))
            )
            (if (= a true)
                (format "Account {} is a Smart Account: Payable: {}; Payable by Smart Account: {}." [account b c])
                (format "Account {} is a Normal Account" [account])
            )
        )
    )
    ;;
    ;;==================COMPUTING===================
    ;;
    ;;      UC_DPTS-AccountsTransferability|UC_FilterIdentifier
    ;;      UC_MakeIdentifier|UC_MakeMVXNonce
    ;;
    (defun UC_DPTS-AccountsTransferability:bool (sender:string receiver:string)
        @doc "Computes transferability between 2 DPTS Accounts, <sender> and <receiver>"
        (let*
            (
                (typea:[bool] (UR_DPTS-AccountProperties sender))
                (typeb:[bool] (UR_DPTS-AccountProperties receiver))
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
    (defun UC_FilterIdentifier:[string] (listoflists:[[string]] account:string)
        @doc "Helper Function needed for returning DPTS identifiers for Account <account>"

        (let 
            (
                (result
                    (fold
                        (lambda 
                            (acc:[string] item:[string])
                            (if (= (UC_LastListElement item) account)
                                (UC_AppendLast acc (UC_FirstListElement item))
                                acc
                            )
                        )
                        []
                        listoflists
                    )
                )
            )
            result
        )
    )
    (defun UC_MakeIdentifier:string (ticker:string)
        @doc "Creates a DPTS Idendifier \ 
            \ using the first 12 Characters of the prev-block-hash of (chain-data) as randomness source"

        (let
            (
                (dash "-")
                (twelve (take 12 (at "prev-block-hash" (chain-data))))
            )
            (UV_DPTS-Ticker ticker)
            (concat [ticker dash twelve])
        )
    )
    (defun UC_MakeMVXNonce:string (nonce:integer)
        @doc "Creates a MultiversX specific NFT nonce from an integer"
        (let*
            (
                (hexa:string (int-to-str 16 nonce))
                (hexalength:integer (length hexa))
            )
            (if (= (mod hexalength 2) 1 )
                (concat ["0" hexa])
                hexa
            )
        )
    )
    ;;
    ;;==================VALIDATIONS=================
    ;;
    ;;      UV_SenderWithReceive|UV_DPTS-Account|UV_DPTS-Decimals
    ;;      UV_DPTS-Name|UV_DPTS-Ticker|UV_Object
    ;;
    (defun UV_SenderWithReceiver (sender:string receiver:string)
        @doc "Validates Account <sender> with Account <receiver> for Transfer"
            (UV_DPTS-Account sender)
            (UV_DPTS-Account receiver)
            (enforce (!= sender receiver) "Sender and Receiver must be different")
    )
    (defun UV_DPTS-Account (account:string)
        @doc "Enforces that Account <account> ID meets charset and length requirements"
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
    (defun UV_DPTS-Decimals:bool (decimals:integer)
        @doc "Enforces correct decimal value for a given DPTS identifier"
        (enforce
            (and
                (>= decimals DPTS_MIN_PRECISION)
                (<= decimals DPTS_MAX_PRECISION)
            )
            "Decimal Size is not between 2 and 24 as pe DPTS Standard!"
        )
    )
    (defun UV_DPTS-Name:bool (name:string)
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
                (UC_IzStringANC name false)
                "Token Name is not AlphaNumeric!"
            )
        )    
    )
    (defun UV_DPTS-Ticker:bool (ticker:string)
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
                (UC_IzStringANC ticker true)
                "Token Ticker is not Alphanumeric with Capitals Only!"
            )
        )
    )
    (defun UV_Object:bool (obj:object obj-size:integer obj-keys:[string])
        @doc "Validates that an Object has the required size and keys"

        (let
            (
                (keys-number:integer (length obj-keys))
                (contains-keys:bool 
                    (fold
                        (lambda 
                            (acc:bool key:string)
                            (and acc (contains key obj))
                        )
                        true
                        obj-keys
                    )
                )
            )
            (enforce (= obj-size keys-number) "Object Keys are not of the reuired amount")
            (enforce (= contains-keys true) "Not all Keys appear in the Object")
        )

    )
    ;;
    ;;==================STRINGS-CHECKS==============
    ;;
    ;;      UC_IzStringANC|UC_IzCharacterANC
    ;;      UV_EnforceReserved|UV_CheckReserved
    ;;
    (defun UC_IzStringANC:bool (s:string capital:bool)
        @doc "Checks if a string is alphanumeric with or without Uppercase Only \
        \ Uppercase Only toggle is used by setting the capital boolean to true"

        (fold
            (lambda                                                         ;1st part of the Fold Function the Lambda
                (acc:bool c:string)                                         ;input variables of the lambda
                (and acc (UC_IzCharacterANC c capital))                     ;operation of the input variables
            )
            true                                                            ;2nd part of the Fold Function, the initial accumulator value
            (str-to-list s)                                                 ;3rd part of the Fold Function, the List upon which the Lambda is executed
        )
    )
    (defun UC_IzCharacterANC:bool (c:string capital:bool)
        @doc "Checks if a character is alphanumeric with or without Uppercase Only"
        (let*
            (
                (c1 (or (contains c CAPITAL_LETTERS)(contains c NUMBERS)))
                (c2 (or c1 (contains c NON_CAPITAL_LETTERS) ))
            )
            (if (= capital true) c1 c2)
        )
    )
    (defun UV_EnforceReserved:bool (account:string guard:guard)
        @doc "Enforce reserved account name protocols"
        (if 
            (validate-principal guard account)
            true
            (let 
                (
                    (r (UV_CheckReserved account))
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
    (defun UV_CheckReserved:string (account:string)
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
    ;;==================LIST-OPERATIONS=============
    ;;
    ;;      UC_SplitString|UC_Search|UC_ReplaceItem|UC_RemoveItem
    ;;      UC_FirstListElement|UC_SecondListElement|UC_LastListElement
    ;;      UC_InsertFirst|UC_AppendLast
    ;;      UV_EnforceNotEmpty|UV_IsNotEmpty
    ;;
    (defun UC_SplitString:[string] (splitter:string splitee:string)
        @doc "Splits a string unsing a single string as splitter"
        (if (= 0 (length splitee))
            [] ;If the string is empty return a zero length list
            (let* 
                (
                    (sep-pos (UC_Search (str-to-list splitee) splitter))
                    (substart (map (+ 1) (UC_InsertFirst sep-pos -1)))
                    (sublen  (zip (-) (UC_AppendLast sep-pos 10000000) substart))
                    (cut (lambda (start len) (take len (drop start splitee))))
                )
                (zip (cut) substart sublen)
            )
        )
    )
    (defun UC_Search:[integer] (searchee:list item)
        @doc "Search an item into the list and returns a list of index"
        ;; Save gas if item is not in list => use the native contains to return empty
        (if (contains item searchee)
            (let 
                (
                    (indexes (enumerate 0 (length searchee)))
                    (match (lambda (v i) (if (= item v) i -1)))
                )
                (UC_RemoveItem (zip (match) searchee indexes) -1)
            )
            []
        )
    )
    (defun UC_ReplaceItem:list (in:list old-item new-item)
        @doc "Replace each occurrence of old-item by new-item"
        (map (lambda (x) (if (= x old-item) new-item x)) in)
    )
    (defun UC_RemoveItem:list (in:list item)
        @doc "Remove an item from a list"
        (filter (!= item) in)
    )
    (defun UC_FirstListElement (in:list)
        @doc "Returns the first item of a list"
        (UV_EnforceNotEmpty in)
        (at 0 in)
    )
    (defun UC_SecondListElement (in:list)
        @doc "Returns the second item of a list"
        (UV_EnforceNotEmpty in)
        (at 1 in)
    )
    (defun UC_LastListElement (in:list)
        @doc "Returns the last item of the list"
        (UV_EnforceNotEmpty in)
        (at (- (length in) 1) in)
    )
    (defun UC_InsertFirst:list (in:list item)
        @doc "Insert an item at the left of the list"
        (+ [item] in)
    )
    (defun UC_AppendLast:list (in:list item)
        @doc "Append an item at the end of the list"
        (+ in [item])
    )
    (defun UV_EnforceNotEmpty:bool (x:list)
        @doc "Verify and Enforces that a list is not empty"
        (enforce (UV_IsNotEmpty x) "List cannot be empty")
    )
    (defun UV_IsNotEmpty:bool (x:list)
        @doc "Return true if the list is not empty"
        (< 0 (length x))
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
    ;;      C_DeployStandardDPTSAccount|C_DeploySmartDPTSAccount
    ;;      C_ControlSmartAccount
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
        (UV_DPTS-Account account)
        (UV_EnforceReserved account guard)

        (with-default-read DPTS-AccountTable account
            { "guard" : guard, "smart-contract" : false, "payable-as-smart-contract" : false, "payable-by-smart-contract" : false, "nonce" : 0 }
            { "guard" := g, "smart-contract" := sc, "payable-as-smart-contract" := pasc, "payable-by-smart-contract" := pbsc, "nonce" := n }
            (write DPTS-AccountTable account
                { "guard"                       : g
                , "smart-contract"              : sc
                , "payable-as-smart-contract"   : pasc
                , "payable-by-smart-contract"   : pbsc
                , "nonce"                       : n
                }  
            )
        )
    )
    (defun C_DeploySmartDPTSAccount (account:string guard:guard)
        @doc "Deploys a Smart DPTS Account. \
        \ Before any DPTF, DPMF, DPSF, DPNF Token can be created, \
        \ a Standard or Smart DPTS Account must be deployed \
        \ Equivalent to creating a new ERD Smart-Contract Address \
        \ \
        \ OWNERSHIP and CONTROL \
        \ As opossed to MVX SmartAccount ERDs, a smart DPTS Account isnt owned by another Normal DPTS Account \
        \ Instead it is its own owner. This brings several advantages: \
        \ Issuance of Tokens and Tokens owned by a SmartDPTS Account can be managed directly: \
        \ (Pause, Freeze, Wipe, SetAndUnset of Transfer Roles) \
        \ As opossed to MVX SmartAccount ERDs, where token management cannot be managed directly, \
        \ but only indirectly through WritePoints that need to be created. \
        \ \
        \ SmartDPTS Accounts cannot Burn and Mint tokens directly, but only indirectly through Functions created in their own modules, \
        \ with these functions providing the required capabilities \
        \ \
        \ Client Functions of Modules of Smart DPTS Account must use for Token Transfers the Methodic Transfer DPTF/DPMF/DPSF/DPNF Functions, \
        \ while providing the required capabilities for this action \
        \ \
        \ This function must be used when deploying \
        \ what on MultiversX would be a new Smart-Contract"

        (UV_DPTS-Account account)
        (UV_EnforceReserved account guard)

        ;;Since it uses insert, the function only works if the DPTS account doesnt exist yet.
        (insert DPTS-AccountTable account
            { "guard"                       : guard
            , "smart-contract"              : true
            , "payable-as-smart-contract"   : false
            , "payable-by-smart-contract"   : true
            , "nonce"                       : 0
            }  
        )  
    )
    (defun C_ControlSmartAccount (account:string payable-as-smart-contract:bool payable-by-smart-contract:bool)
        @doc "Manages Smart DPTS Account Type via boolean triggers"
        (with-capability (IZ_DPTS_ACCOUNT_SMART account)
            (update DPTS-AccountTable account
                {"payable-as-smart-contract"    : payable-as-smart-contract
                ,"payable-by-smart-contract"    : payable-by-smart-contract}
            )
        )
    )
    ;;--------------------------------------------;;
    ;;                                            ;;
    ;;      AUXILIARY FUNCTIONS                   ;;
    ;;                                            ;;
    ;;--------------------------------------------;;
    ;;
    (defun X_IncrementNonce (client:string)
        (require-capability (DPTS_INCREASE-NONCE))
        (with-read DPTS-AccountTable client
            { "nonce" := n }
            (update DPTS-AccountTable client { "nonce" : (+ n 1)})
        )
    )

)
 
(create-table DPTS-AccountTable)