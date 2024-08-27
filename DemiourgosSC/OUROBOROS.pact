(module OUROBOROS GOVERNANCE
    @doc "OUROBOROS is the Demiourgos.Holdings Core Module that defines the OUROBOROS Network Virtual Blockchain \
        \ \
        \ \
        \ It consists of 3 Submodules, that must coexist in the same module, in order to solve the |chicken-egg| problem \
        \ that appears when attepting to simulate GAS Functionality on this <Virtual Blockchain> \
        \ \
        \ \
        \ Sub-Module 1 - DPTS \
        \ \
        \ DPTS or Demiourgos-Pact-Token Standard is a Pact based Token Standard created by Demiourgos.Holdings \
        \ that mimics the token functionalities that exist on MultiversX (former Elrond) Blockchain. \
        \ The DPTS Submodule manages the functionality of the so called DPTS Account, that operates hierachically \
        \ above the 4 Token Types: True-Fungible (DPTF), Meta-Fungible(DPMF), Semi-Fungible(DPSF), and Non-Fungible(DPNF) \
        \ \
        \ \
        \ Sub-Module 2 - DPTF \
        \ \
        \ DPTF or Demiourgos-Pact-True-Fungible is the DPTS for True-Fungibles \
        \ DPTF Tokens mimic the functionality of the ESDT Tokens introduced by MultiversX (former Elrond) Blockchain \
        \ \
        \ \
        \ Sub-Module 3 - VGAS \
        \ \
        \ The VGAS submodule is in charge of the GAS related data. Information stored through this submodule defines \
        \ which DPTF Token acts as <Virtual-GAS> and wheter or not VirtualGas collection is toggled ON or OFF \
        \ \
        \ \
        \ \
        \ The remaining Modules for Meta-Fungible(DPMF), Semi-Fungible(DPSF), and Non-Fungible(DPNF) \
        \ are their own independent modules, and are constructed in the same manner the DPTF Sub-Module is constructed \
        \ \
        \ Demiourgos Pact Meta Fungible Token Standard          DPMF Token Standard \
        \ Demiourgos Pact Semi Fungible Token Standard          DPSF Token Standard \
        \ Demiourgos Pact Non  Fungible Token Standard          DPNF Token Standard "

    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
            \ Set to DPTS_ADMIN so that only Module Key can enact an upgrade"
        false
    )
    (defcap OUROBOROS_ADMIN ()
        @doc "Capability enforcing the OUROBOROS Administrator"

        (enforce-guard (keyset-ref-guard SC_KEY))
    )
    (defcap GAS_INIT_SET-ROLES (patron:string gas-id:string gas-source-id account:string)
        @doc "Capability needed when setting Roles within the GAS Initialisation Function"
        (compose-capability (DPTF_SET_BURN-ROLE_CORE gas-id account))
        (compose-capability (DPTF_SET_MINT-ROLE_CORE gas-id account))
        (compose-capability (DPTF_SET_BURN-ROLE_CORE gas-source-id account))
        (compose-capability (DPTF_SET_MINT-ROLE_CORE gas-source-id account))
        (compose-capability (DPTS_INCREASE-NONCE))
        (compose-capability (PATRON patron))
    )
    (defcap DPTS_CLIENT (account:string)
        @doc "Capability that enforces the ownership of a DPTS Account if it is a Standard DPTS Account"
        (UV_DPTS-Account account)

        (let
            (
                (iz-sc:bool (UR_DPTS-AccountType account))
            )
            (if (= iz-sc true)
                true
                (compose-capability (DPTS_ACCOUNT_OWNER account))
            )
        )
    )
    (defcap DPTS_METHODIC (client:string method:bool)
        (if (= method true)
            (compose-capability (IZ_DPTS_ACCOUNT_SMART client true))
            (compose-capability (DPTS_ACCOUNT_OWNER client))
        )
    )
    (defcap DPTF_CLIENT (identifier:string account:string)
        @doc "Capability that enforces the ownership of a DPTF Token Account if its underlying DPTS Account is a Standard DPTS Account"
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)

        (let
            (
                (iz-sc:bool (UR_DPTS-AccountType account))
            )
            (if (= iz-sc true)
                true
                (compose-capability (DPTF_ACCOUNT_OWNER identifier account))
            )
        )
    )
    ;;Smart-Contract Key and Name Definitions
    (defconst SC_KEY "free.DH-Master-Keyset")
    (defconst SC_NAME "Ouroboros")

    (defconst SC_KEY_GAS "free.DH-GAS-Keyset")
    (defconst SC_NAME_GAS "Gas-Tanker")

    (defconst CTO "ChiefTechnologyOfficer")
    (defconst HOV "HeadOfVision")

    (defun CollectBlockchainFuel (patron:string amount:decimal)
        @doc "Collects Blockchain Fuel in KDA"
        (UV_DPTS-Account patron)

        (let*
            (
                (precision:integer coin.MINIMUM_PRECISION)
                (five:decimal (floor (* amount 0.05) precision))
                (ten:decimal (* five 2.0))
                (rest:decimal (- amount ten))
            )
            (coin.transfer patron CTO five)
            (coin.transfer patron HOV five)
            (coin.transfer patron SC_NAME_GAS rest)
        )
    )

    ;; Capability Categories
    ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      CAPABILITIES                                                                                                                                ;;
    ;;                                                                                                                                                  ;;
    ;;      CORE                                    Module Core Capabilities                                                                            ;;
    ;;      BASIC                                   Basic Capabilities represent singular capability Definitions                                        ;;
    ;;      COMPOSED                                Composed Capabilities are made of one or multiple Basic Capabilities                                ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;


    ;; Functions Categories
    ;;
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
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;;
;;                                                                                                                                                          ;;
;;                                                                                                                                                          ;;
;;                                                                    Sub-Module 1                                                                          ;;
;;                                                                        DPTS                                                                              ;;
;;                                                                                                                                                          ;;
;;                                                                                                                                                          ;;
;;                                                                                                                                                          ;;
;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;1]CONSTANTS Definitions
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
    ;;Demiourgos Pact Token Standard - DPTS
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
    ;;      DPTS: BASIC CAPABILITIES                Description                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==============================================                                                                                                    ;;
    ;;      DPTS_ACCOUNT_OWNER                      Enforces DPTS Account Ownership                                                                     ;;
    ;;      IZ_DPTS_ACOUNT_SMART                    Enforces That a DPTS Account is of a Smart DPTS Account                                             ;;
    ;;      SC_TRANSFERABILITY                      Enforce correct transferability between DPTS Accounts                                               ;;
    ;;      DPTS_INCREASE-NONCE                     Capability required to increment the DPTS nonce                                                     ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      DPTS: COMPOSED CAPABILITIES             Description                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==============================================                                                                                                    ;;
    ;;      CONTROL-SMART-ACCOUNT                  Capability needed for the <C_ControlSmartAccount> to execute                                         ;;                                                   ;;
    ;;      CONTROL-SMART-ACCOUNT_CORE             Core Capability to Control a Smart-Account                                                           ;;                                            ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;==============================================
    ;;                                            ;;
    ;;      DPTS: BASIC CAPABILITIES              ;;
    ;;                                            ;;
    ;;==============================================
    ;;
    ;;      DPTS_ACCOUNT_EXIST|DPTS_ACCOUNT_OWNER|IZ_DPTS_ACOUNT_SMART
    ;;      SC_TRANSFERABILITY|DPTS_INCREASE-NONCE
    ;;
    (defcap DPTS_ACCOUNT_EXIST (account:string)
        @doc "Enforces that a DPTS Account exists"
        (UV_DPTS-Account account)
        (let
            (
                (dpts-account-type:bool (UR_DPTS-AccountType account))
            )
            (enforce-one
                (format "DPTS Account {} does not exist !" [account])
                [
                    (enforce (= dpts-account-type true) (format "Account {} is a Normal DPTS Account - Crediting will execute" [account]))
                    (enforce (= dpts-account-type false) (format "Account {} is a Smart DPTS Account - Crediting will execute" [account]))
                ]
            )
        )
    )
    (defcap DPTS_ACCOUNT_OWNER (account:string)
        @doc "Enforces DPTS Account Ownership"
        (UV_DPTS-Account account)

        (enforce-guard (UR_DPTS-AccountGuard account))
    )
    (defcap IZ_DPTS_ACCOUNT_SMART (account:string smart:bool)
        @doc "Enforces that a DPTS Account is either Normal (<smart> boolean false) or Smart (<smart> boolean true)"
        (UV_DPTS-Account account)

        (let
            (
                (x:bool (UR_DPTS-AccountType account))
            )
            (if (= smart true)
                (enforce (= x true) (format "Account {} is not a SC Account, when it should have been, for the operation to execute" [account]))
                (enforce (= x false) (format "Account {} is a SC Account, when it shouldnt have been, for the operation to execute" [account]))
            )
        )
    )
    (defcap SC_TRANSFERABILITY (sender:string receiver:string method:bool)
        @doc "Enforce correct transferability when dealing with Smart(Contract) DPTS Account types \
            \ When Method is set to true, transferability is always ensured"
        (UV_SenderWithReceiver sender receiver)

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
    ;;==============================================
    ;;                                            ;;
    ;;      DPTS: COMPOSED CAPABILITIES           ;;
    ;;                                            ;;
    ;;==============================================
    ;;
    ;;      CONTROL-SMART-ACCOUNT|CONTROL-SMART-ACCOUNT_CORE
    ;;
    (defcap CONTROL-SMART-ACCOUNT (patron:string account:string)
        @doc "Capability needed for the <C_ControlSmartAccount> to execute"

        (compose-capability (CONTROL-SMART-ACCOUNT_CORE account))
        (compose-capability (GAS_COLLECTION patron account GAS_SMALL))
        (compose-capability (DPTS_INCREASE-NONCE))
    )
    (defcap CONTROL-SMART-ACCOUNT_CORE (account:string)
        @doc "Core Capability to Control a Smart-Account"
        (compose-capability (DPTS_ACCOUNT_OWNER account))     
        (compose-capability (IZ_DPTS_ACCOUNT_SMART account true))
        
    )
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      DPTS: UTILITY FUNCTIONS                 Description                                                                                         ;;
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
    ;;==================MULTI-VALIDATIONS===========                                                                                                    ;;
    ;;      UV_DPTS-Account_Two                     Validates 2 DPTS Accounts
    ;;      UV_DPTS-Account_Three                   Validates 3 DPTS Accounts
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
    ;;      DPTS: ADMINISTRATION FUNCTIONS                                                                                                              ;;
    ;;                                                                                                                                                  ;;
    ;;      NO ADMINISTRATOR FUNCTIONS                                                                                                                  ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      DPTS: CLIENT FUNCTIONS                  Description                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================CONTROL=====================                                                                                                    ;;
    ;;      C_DeployStandardDPTSAccount             Deploys a Standard DPTS Account                                                                     ;;
    ;;      C_DeploySmartDPTSAccount                Deploys a Smart DPTS Account                                                                        ;;
    ;;2     C_ControlSmartAccount                   Manages a Smart DPTS Account                                                                        ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      DPTS: AUXILIARY FUNCTIONS               Description                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==============================================                                                                                                    ;;
    ;;      X_IncrementNonce                        Increments <identifier> DPTS Account nonce                                                          ;;
    ;;      X_UpdateSmartAccountParameters          Updates DPTS Account Parameters                                                                     ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;==============================================
    ;;                                            ;;
    ;;      DPTS: UTILITY FUNCTIONS               ;;
    ;;                                            ;;
    ;;==================ACCOUNT-INFO================
    ;;
    ;;      UR_DPTS-AccountGuard|UR_DPTS-AccountProperties
    ;;      UR_DPTS-AccountType|UR_DPTS-AccountPayableAs|UR_DPTS-AccountPayableBy
    ;;      UR_DPTS-AccountNonce|UP_DPTS-AccountProperties
    ;;
    (defun UR_DPTS-AccountGuard:guard (account:string)
        @doc "Returns DPTS Account <account> Guard"
        (UV_DPTS-Account account)

        (at "guard" (read DPTS-AccountTable account ["guard"]))
    )
    (defun UR_DPTS-AccountProperties:[bool] (account:string)
        @doc "Returns a boolean list with DPTS Account Type properties"
        (UV_DPTS-Account account)

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
        (UV_DPTS-Account account)

        (with-default-read DPTS-AccountTable account
            { "nonce" : 0 }
            { "nonce" := n }
            n
        )
    )
    (defun UP_DPTS-AccountProperties (account:string)
        @doc "Prints DPTS Account <account> Properties"
        (UV_DPTS-Account account)

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
    ;;==============================================
    ;;                                            ;;
    ;;      DPTS: UTILITY FUNCTIONS               ;;
    ;;                                            ;;
    ;;==================COMPUTING===================
    ;;
    ;;      UC_DPTS-AccountsTransferability|UC_FilterIdentifier
    ;;      UC_MakeIdentifier|UC_MakeMVXNonce
    ;;
    (defun UC_DPTS-AccountsTransferability:bool (sender:string receiver:string)
        @doc "Computes transferability between 2 DPTS Accounts, <sender> and <receiver>"
        (UV_DPTS-Account sender)
        (UV_DPTS-Account receiver)

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
        (UV_DPTS-Account account)

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
        (UV_DPTS-Ticker ticker)

        (let
            (
                (dash "-")
                (twelve (take 12 (at "prev-block-hash" (chain-data))))
            )
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
    ;;==============================================
    ;;                                            ;;
    ;;      DPTS: UTILITY FUNCTIONS               ;;
    ;;                                            ;;
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
    (defun UC_DPTS-AccountCheck:bool (account:string)
        @doc "Checks if a DPTS Account ID is valid (meets charset and length requirements), returning true if it is and false if it isnt"

        (let*
            (
                (t1:bool (is-charset ACCOUNT_ID_CHARSET account))
                (t2:bool (not (contains account ACCOUNT_ID_PROHIBITED_CHARACTER)))
                (t3:bool (and t1 t2))
                (account-length:integer (length account))
                (t4:bool (>= account-length ACCOUNT_ID_MIN_LENGTH))
                (t5:bool (<= account-length ACCOUNT_ID_MAX_LENGTH))
                (t6:bool (and t4 t5))
                (t7:bool (and t3 t6))
            )
            t7
        )
    )
    (defun UV_DPTS-Decimals:bool (decimals:integer)
        @doc "Enforces the decimal size is DPTS precision conform"

        (enforce
            (and
                (>= decimals DPTS_MIN_PRECISION)
                (<= decimals DPTS_MAX_PRECISION)
            )
            "Decimal Size is not between 2 and 24 as per DPTS Standard!"
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
            (enforce (= obj-size keys-number) "Object Keys are not of the required amount")
            (enforce (= contains-keys true) "Not all Keys appear in the Object")
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTS: UTILITY FUNCTIONS               ;;
    ;;                                            ;;
    ;;==================VALIDATIONS=================
    ;;
    ;;      UV_DPTS-Account_Two|UV_DPTS-Account_Three
    ;;
    (defun UV_DPTS-Account_Two (account-one:string account-two:string)
        @doc "Validates 2 DPTS Accounts"
        (UV_DPTS-Account account-one)
        (UV_DPTS-Account account-two)
    )
    (defun UV_DPTS-Account_Three (account-one:string account-two:string account-three:string)
        @doc "Validates 2 DPTS Accounts"
        (UV_DPTS-Account account-one)
        (UV_DPTS-Account account-two)
        (UV_DPTS-Account account-three)
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTS: UTILITY FUNCTIONS               ;;
    ;;                                            ;;
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
            (if (= ":" (take -1 pfx)) 
                (take 1 pfx) 
                ""
            )
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTS: UTILITY FUNCTIONS               ;;
    ;;                                            ;;
    ;;==================LIST-OPERATIONS=============
    ;;
    ;;      UC_SplitString|UC_Search|UC_ReplaceItem|UC_RemoveItem
    ;;      UC_FirstListElement|UC_SecondListElement|UC_LastListElement
    ;;      UC_InsertFirst|UC_AppendLast
    ;;      UV_EnforceNotEmpty|UV_IsNotEmpty
    ;;
    ;;      NO special VALIDATION needed
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
    ;;==============================================
    ;;                                            ;;
    ;;      DPTS: ADMINISTRATION FUNCTIONS        ;;
    ;;                                            ;;
    ;;      NO ADMINISTRATOR FUNCTIONS            ;;
    ;;                                            ;;
    ;;==============================================
    ;;                                            ;;
    ;;      DPTS: CLIENT FUNCTIONS                ;;
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
            \ If a DPTS Account already exists, function will fail, due to usage of insert"
        (UV_DPTS-Account account)
        (UV_EnforceReserved account guard)

        (insert DPTS-AccountTable account
            { "guard"                       : guard
            , "smart-contract"              : false
            , "payable-as-smart-contract"   : false
            , "payable-by-smart-contract"   : false
            , "nonce"                       : 0
            }  
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
    (defun C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool)
        @doc "Manages Smart DPTS Account Type via boolean triggers"
        (let
            (
                (ZG:bool (UR_GasToggle))
            )
            (with-capability (CONTROL-SMART-ACCOUNT patron account)
                (if (= ZG false)
                    (X_CollectGAS patron account GAS_SMALL)
                    true
                )
                (X_UpdateSmartAccountParameters account payable-as-smart-contract payable-by-smart-contract)
                (X_IncrementNonce patron)
            )
        )
        
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTS: AUXILIARY FUNCTIONS             ;;
    ;;                                            ;;
    ;;==============================================
    ;;
    ;;      X_IncrementNonce|X_UpdateSmartAccountParameters
    ;;
    (defun X_IncrementNonce (client:string)
        @doc "Increments DPTS Account nonce, which store how many txs the DPTS Account executed"
        (UV_DPTS-Account client)
        (require-capability (DPTS_INCREASE-NONCE))
        (with-read DPTS-AccountTable client
            { "nonce" := n }
            (update DPTS-AccountTable client { "nonce" : (+ n 1)})
        )
    )
    (defun X_UpdateSmartAccountParameters (account:string payable-as-smart-contract:bool payable-by-smart-contract:bool)
        @doc "Updates DPTS Account Parameters"
        (require-capability (CONTROL-SMART-ACCOUNT_CORE account))
        (update DPTS-AccountTable account
            {"payable-as-smart-contract"    : payable-as-smart-contract
            ,"payable-by-smart-contract"    : payable-by-smart-contract}
        )
    )
    
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;;
;;                                                                                                                                                          ;;
;;                                                                                                                                                          ;;
;;                                                                    Sub-Module 2                                                                          ;;
;;                                                         DPTF - Demiourgos Pact True Fungible                                                             ;;
;;                                                                                                                                                          ;;
;;                                                                                                                                                          ;;
;;                                                                                                                                                          ;;
;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;    
    ;;1]CONSTANTS Definitions - None
    ;;2]SCHEMAS Definitions
    ;;Demiourgos Pact TRUE Fungible Token Standard - DPTF
    (defschema DPTF-PropertiesSchema
        @doc "Schema for DPTF Token (True Fungibles) Properties \
            \ Key for Table is DPTF Token Identifier. This ensure a unique entry per Token Identifier"

        owner-konto:string                          ;;Account of the Token Owner, Account that created the DPTF Token
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
        ;;Supply
        supply:decimal                              ;;Stores the Token Total Supply
        origin-mint:bool                            ;;If true, Origin Supply has already been minted
        origin-mint-amount:decimal                  ;;Store the Token's Origin Mint Amount
        ;;Transfer-Role-Amount
        role-transfer-amount:integer                ;;Stores how many accounts have Transfer Roles for the Token.
    )
    (defschema DPTF-BalanceSchema
        @doc "Schema that Stores Account Balances for DPTF Tokens (True Fungibles)\
            \ Key for the Table is a string composed of: \
            \ <DPTF Identifier> + BAR + <account> \
            \ This ensure a single entry per DPTF Identifier per account."

        balance:decimal                             ;;Stores DPTF balance for Account
        ;;Special Roles
        role-burn:bool                              ;;when true, Account can burn DPTF Tokens locally
        role-mint:bool                              ;;when true, Account can mint DPTF Tokens locally
        role-transfer:bool                          ;;when true, Transfer is restricted. Only accounts with true Transfer Role
                                                    ;;can transfer the token, while all other accounts can only transfer to such accounts.
        ;;States
        frozen:bool                                 ;;Determines wheter Account is frozen for DPTF Token Identifier
    )
    (defschema ID-Amount_Schema
        id:string
        amount:decimal
    )
    (defschema Receiver-Amount_Schema
        receiver:string
        amount:decimal
    )
    ;;3]TABLES Definitions
    (deftable DPTF-PropertiesTable:{DPTF-PropertiesSchema})
    (deftable DPTF-BalancesTable:{DPTF-BalanceSchema})
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      DPTF: BASIC CAPABILITIES                Description                                                                                         ;;
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
    ;;      UPDATE-ROLE-TRANSFER-AMOUNT             Capability required to update DPTF Transfer-Role-Amount                                             ;;
    ;;======DPTF-BALANCES-TABLE-MANAGEMENT==========                                                                                                    ;;
    ;;      DPTF_ACCOUNT_EXIST                      Enforces that the DPTF Account <account> exists for Token <identifier>                              ;;
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
    ;;      DPTF: COMPOSED CAPABILITIES             Description                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================CONTROL=====================                                                                                                    ;;
    ;;      DPTF_OWNERSHIP-CHANGE                   Capability required to EXECUTE <C_ChangeOwnership> Function                                         ;;
    ;;      DPTF_OWNERSHIP-CHANGE_CORE              Core Capability required for for changing DPTF Ownership                                            ;;
    ;;      DPTF_CONTROL                            Capability required to EXECUTE <C_Control> Function                                                 ;;
    ;;      DPTF_CONTROL_CORE                       Core Capability required for managing DPTF Properties                                               ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DPTF_TOGGLE_PAUSE                       Capability required to EXECUTE <C_TogglePause> Function                                             ;;
    ;;      DPTF_PAUSE                              Capability required to pause a DPTF account                                                         ;;
    ;;      DPTF_PAUSE_CORE                         Core Capability required to pause a DPTF account                                                    ;;
    ;;      DPTF_UNPAUSE                            Capability required to unpause a DPTF account                                                       ;;
    ;;      DPTF_UNPAUSE_CORE                       Core Capability required to unpause a DPTF account                                                  ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DPTF_TOGGLE_FREEZE-ACCOUNT              Capability required to EXECUTE <C_ToggleFreezeAccount> Function                                     ;;
    ;;      DPTF_FREEZE-ACCOUNT                     Capability required to freeze a DPTF account                                                        ;;
    ;;      DPTF_FREEZE-ACCOUNT_CORE                Core Capability required to freeze a DPTF account                                                   ;;
    ;;      DPTF_UNFREEZE-ACCOUNT                   Capability required to unfreeze a DPTF account                                                      ;;
    ;;      DPTF_UNFREEZE-ACCOUNT_CORE              Core Capability required to unfreeze a DPTF account                                                 ;;
    ;;==================SET|UNSET===================                                                                                                    ;;
    ;;      DPTF_TOGGLE_BURN-ROLE                   Capability required to EXECUTE <C_ToggleBurnRole> Function                                          ;;
    ;;      DPTF_SET_BURN-ROLE                      Capability required to set Burn-Role to a DPTF account for a DPTF Token                             ;;
    ;;      DPTF_SET_BURN-ROLE_CORE                 Core Capability required to set Burn-Role to a DPTF account for a DPTF Token                        ;;
    ;;      DPTF_UNSET_BURN-ROLE                    Capability required to unset Burn-Role to a DPTF account for a DPTF Token                           ;;
    ;;      DPTF_UNSET_BURN-ROLE_CORE               Core Capability required to unset Burn-Role to a DPTF account for a DPTF Token                      ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DPTF_TOGGLE_MINT-ROLE                   Capability required to EXECUTE <C_ToggleMintRole> Function                                          ;;
    ;;      DPTF_SET_MINT-ROLE                      Capability required to set Mint-Role to a DPTF account for a DPTF Token                             ;;
    ;;      DPTF_SET_MINT-ROLE_CORE                 Core Capability required to set Mint-Role to a DPTF account for a DPTF Token                        ;;
    ;;      DPTF_UNSET_MINT-ROLE                    Capability required to unset Mint-Role to a DPTF account for a DPTF Token                           ;;
    ;;      DPTF_UNSET_MINT-ROLE_CORE               Core Capability required to unset Mint-Role to a DPTF account for a DPTF Token                      ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DPTF_TOGGLE_TRANSFER-ROLE               Capability required to EXECUTE <C_ToggleTransferRole> Function                                      ;;
    ;;      DPTF_SET_TRANSFER-ROLE                  Capability required to set Transfer-Role to a DPTF account for a DPTF Token                         ;;
    ;;      DPTF_SET_TRANSFER-ROLE_CORE             Core Capability required to set Transfer-Role to a DPTF account for a DPTF Token                    ;;
    ;;      DPTF_UNSET_TRANSFER-ROLE                Capability required to unset Transfer-Role to a DPTF account for a DPTF Token                       ;;
    ;;      DPTF_UNSET_TRANSFER-ROLE_CORE           Core Capability required to unset Transfer-Role to a DPTF account for a DPTF Token                  ;;
    ;;==================CREATE======================                                                                                                    ;;
    ;;      DPTF_ISSUE                              Capability required to EXECUTE a <C_IssueTrueFungible> Function                                     ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DPTF_MINT                               Capability required to EXECUTE <C_Mint> Function                                                    ;;
    ;;      DPTF_MINT-ORIGIN                        Capability required to mint the premine for a DPTF Token                                            ;;
    ;;      DPTF_MINT-ORIGIN_CORE                   Core Capability required to mint the premine for a DPTF Token                                       ;;
    ;;      DPTF_MINT-STANDARD                      Capability required to mint a DPTF Token in a standard manner                                       ;;
    ;;      DPTF_MINT-STANDARD_CORE                 Core Capability required to mint a DPTF Token in a standard manner                                  ;;
    ;;==================DESTROY=====================                                                                                                    ;;
    ;;      DPTF_BURN                               Capability required to EXECUTE <C_Burn> Function                                                    ;;
    ;;      DPTF_BURN_CORE                          Core Capability required to burn a DPTF Token in a standard manner                                  ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DPTF_WIPE                               Capability required to EXECUTE <C_Wipe> Function                                                    ;;
    ;;      DPTF_WIPE_CORE                          Core Capability required to Wipe a DPTF Token Balance from a DPTF account                           ;;
    ;;==================TRANSFER====================                                                                                                    ;;
    ;;      GAS_MOVER                               Capability required for moving GAS                                                                  ;;
    ;;      TRANSFER_DPTF                           Main DPTF Transfer Capability                                                                       ;;
    ;;      TRANSFER_DPTF_CORE                      Core Capability for transfer between 2 DPTS accounts for a specific DPTF Token identifier           ;;
    ;;==================CORE========================                                                                                                    ;;
    ;;      CREDIT_DPTF                             Capability to perform crediting operations with DPTF Tokens                                         ;;
    ;;      DEBIT_DPTF                              Capability to perform debiting operations on Normal DPTS Account types with DPTF Tokens             ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: BASIC CAPABILITIES              ;;
    ;;                                            ;;
    ;;======DPTF-PROPERTIES-TABLE-MANAGEMENT========
    ;;
    ;;      DPTF_OWNER
    ;;      DPTF_CAN-CHANGE-OWNER_ON|DPTF_CAN-UPGRADE_ON|DPTF_CAN-ADD-SPECIAL-ROLE_ON
    ;;      DPTF_CAN-FREEZE_ON|DPTF_CAN-WIPE_ON|DPTF_CAN-PAUSE_ON|DPTF_IS-PAUSED_ON|DPTF_IS-PAUSED_OF
    ;;      DPTF_UPDATE_SUPPLY|UPDATE-ROLE-TRANSFER-AMOUNT
    ;;
    (defcap DPTF_OWNER (identifier:string)
        @doc "Enforces DPTF Token Ownership"
        (UV_TrueFungibleIdentifier identifier)

        (let*
            (
                (owner-konto:string (UR_TrueFungibleKonto identifier))
                (dpts-guard:guard (UR_DPTS-AccountGuard owner-konto))
            )
            (enforce-guard dpts-guard)
        )
        
    )
    (defcap DPTF_CAN-CHANGE-OWNER_ON (identifier:string)
        @doc "Enforces DPTF Token ownership is changeble"
        (UV_TrueFungibleIdentifier identifier)

        (let
            (
                (x:bool (UR_TrueFungibleCanChangeOwner identifier))
            )
            (enforce (= x true) (format "DPTF Token {} ownership cannot be changed" [identifier]))
        )
    )
    (defcap DPTF_CAN-UPGRADE_ON (identifier:string)
        @doc "Enforces DPTF Token is upgradeable"
        (UV_TrueFungibleIdentifier identifier)

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
        (UV_TrueFungibleIdentifier identifier)

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
        (UV_TrueFungibleIdentifier identifier)

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
        (UV_TrueFungibleIdentifier identifier)

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
        (UV_TrueFungibleIdentifier identifier)

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
        (UV_TrueFungibleIdentifier identifier)
        
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
        (UV_TrueFungibleIdentifier identifier)

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
        (UV_TrueFungibleIdentifier identifier)

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
    (defcap DPTF_UPDATE_SUPPLY () 
        @doc "Capability required to update DPTF Supply"
        true
    )
    (defcap UPDATE-ROLE_TRANSFER-AMOUNT ()
        @doc "Capability required to update DPTF Transfer-Role-Amount"
        true
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: BASIC CAPABILITIES              ;;
    ;;                                            ;;
    ;;======DPTF-BALANCES-TABLE-MANAGEMENT==========
    ;;
    ;;      DPTF_ACCOUNT_EXISTANCE|DPTF_ACCOUNT_OWNER
    ;;      DPTF_ACCOUNT_BURN_ON|DPTF_ACCOUNT_BURN_OFF
    ;;      DPTF_ACCOUNT_MINT_ON|DPTF_ACCOUNT_MINT_OFF
    ;;      DPTF_ACCOUNT_TRANSFER_ON|DPTF_ACCOUNT_TRANSFER_OFF
    ;;      DPTF_ACCOUNT_FREEZE_ON|DPTF_ACCOUNT_FREEZE_OFF
    ;;
    (defcap DPTF_ACCOUNT_EXISTANCE (identifier:string account:string existance:bool)
        @doc"Enforces <existance> Existance for the DPMF Token Account <identifier>|<account>"
        (let
            (
                (existance-check:bool (UR_AccountTrueFungibleExist identifier account))
            )
            (enforce (= existance-check existance) (format "{} Existance isnt verified for the DPTF Token Account <{}>|<{}}>" [existance identifier account]))
        )
    )
    (defcap DPTF_ACCOUNT_OWNER (identifier:string account:string)
        @doc "Enforces DPTF Account Ownership"
        (UV_TrueFungibleIdentifier identifier)
        (compose-capability (DPTS_ACCOUNT_OWNER account))
    )
    (defcap DPTF_ACCOUNT_BURN_ON (identifier:string account:string)
        @doc "Enforces DPTF Account has burn role on"
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)
        
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
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)
        
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
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)
        
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
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)
        
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
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)
        
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
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)

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
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)

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
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)

        (let
            (
                (x:bool (UR_AccountTrueFungibleFrozenState identifier account))
            )
            (enforce (= x false) (format "Account {} is frozen for DPTF {} Token" [account identifier])
            )
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: COMPOSED CAPABILITIES           ;;
    ;;                                            ;;
    ;;==================CONTROL=====================
    ;;
    ;;      DPTF_OWNERSHIP-CHANGE|DPTF_OWNERSHIP-CHANGE_CORE|DPTF_CONTROL|DPTF_CONTROL_CORE
    ;;      DPTF_TOGGLE_PAUSE|DPTF_PAUSE|DPTF_PAUSE_CORE|DPTF_UNPAUSE|DPTF_UNPAUSE_CORE
    ;;      DPTF_TOGGLE_FREEZE-ACCOUNT|DPTF_FREEZE-ACCOUNT|DPTF_FREEZE-ACCOUNT_CORE|DPTF_UNFREEZE-ACCOUNT|DPTF_UNFREEZE-ACCOUNT_CORE
    ;;
    (defcap DPTF_OWNERSHIP-CHANGE (patron:string identifier:string new-owner:string)
        (let
            (
                (current-owner-account:string (UR_TrueFungibleKonto identifier))
            )
            (compose-capability (DPTF_OWNERSHIP-CHANGE_CORE identifier new-owner))
            (compose-capability (GAS_COLLECTION patron current-owner-account GAS_BIGGEST))
            (compose-capability (DPTS_INCREASE-NONCE))
        )
    )
    (defcap DPTF_OWNERSHIP-CHANGE_CORE (identifier:string new-owner:string)
        (let
            (
                (current-owner-account:string (UR_TrueFungibleKonto identifier))
            )
            (UV_SenderWithReceiver current-owner-account new-owner)
            (compose-capability (DPTF_OWNER identifier))
            (compose-capability (DPTF_CAN-CHANGE-OWNER_ON identifier))
        )
    )
    (defcap DPTF_CONTROL (patron:string identifier:string)
        (let
            (
                (current-owner-account:string (UR_TrueFungibleKonto identifier))
            )
            (compose-capability (DPTF_CONTROL_CORE identifier))
            (compose-capability (GAS_COLLECTION patron current-owner-account GAS_SMALL))
            (compose-capability (DPTS_INCREASE-NONCE)) 
        )
        
    )
    (defcap DPTF_CONTROL_CORE (identifier:string)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-UPGRADE_ON identifier))
    )
    (defcap DPTF_TOGGLE_PAUSE (patron:string identifier:string toggle:bool)
        (if (= toggle true)
            (compose-capability (DPTF_PAUSE patron identifier))
            (compose-capability (DPTF_UNPAUSE patron identifier))
        )
    )
    (defcap DPTF_PAUSE (patron:string identifier:string)
        (compose-capability (DPTF_PAUSE_CORE identifier))
        (compose-capability (GAS_COLLECTION patron patron GAS_MEDIUM))
        (compose-capability (DPTS_INCREASE-NONCE)) 
    )

    (defcap DPTF_PAUSE_CORE (identifier:string)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-PAUSE_ON identifier))
        (compose-capability (DPTF_IS-PAUSED_OFF identifier))
    )
    (defcap DPTF_UNPAUSE (patron:string identifier:string)
        (compose-capability (DPTF_UNPAUSE_CORE identifier))
        (compose-capability (GAS_COLLECTION patron patron GAS_MEDIUM))
        (compose-capability (DPTS_INCREASE-NONCE)) 
    )

    (defcap DPTF_UNPAUSE_CORE (identifier:string)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-PAUSE_ON identifier))
        (compose-capability (DPTF_IS-PAUSED_ON identifier))
    )
    (defcap DPTF_TOGGLE_FREEZE-ACCOUNT (patron:string identifier:string account:string toggle:bool)
        (if (= toggle true)
            (compose-capability (DPTF_FREEZE-ACCOUNT patron identifier account))
            (compose-capability (DPTF_UNFREEZE-ACCOUNT patron identifier account))
        )
    )
    (defcap DPTF_FREEZE-ACCOUNT (patron:string identifier:string account:string)
        (compose-capability (DPTF_FREEZE-ACCOUNT_CORE identifier account))
        (compose-capability (GAS_COLLECTION patron account GAS_BIG))
        (compose-capability (DPTS_INCREASE-NONCE))
    )
    (defcap DPTF_FREEZE-ACCOUNT_CORE (identifier:string account:string)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-FREEZE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_FREEZE_OFF identifier account))

    )
    (defcap DPTF_UNFREEZE-ACCOUNT (patron:string identifier:string account:string)
        (compose-capability (DPTF_UNFREEZE-ACCOUNT_CORE identifier account))
        (compose-capability (GAS_COLLECTION patron account GAS_BIG))
        (compose-capability (DPTS_INCREASE-NONCE))
    )
    (defcap DPTF_UNFREEZE-ACCOUNT_CORE (identifier:string account:string)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-FREEZE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_FREEZE_ON identifier account))

    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: COMPOSED CAPABILITIES           ;;
    ;;                                            ;;
    ;;==================UNSET=======================
    ;;
    ;;      DPTF_TOGGLE_BURN-ROLE|DPTF_SET_BURN-ROLE|DPTF_SET_BURN-ROLE_CORE|DPTF_UNSET_BURN-ROLE|DPTF_UNSET_BURN-ROLE_CORE
    ;;      DPTF_TOGGLE_MINT-ROLE|DPTF_SET_MINT-ROLE|DPTF_SET_MINT-ROLE_CORE|DPTF_UNSET_MINT-ROLE|DPTF_UNSET_MINT-ROLE_CORE
    ;;      DPTF_TOGGLE_TRANSFER-ROLE|DPTF_SET_TRANSFER-ROLE|DPTF_SET_TRANSFER-ROLE_CORE|DPTF_UNSET_TRANSFER-ROLE|DPTF_UNSET_TRANSFER-ROLE_CORE
    ;;
    (defcap DPTF_TOGGLE_BURN-ROLE (patron:string identifier:string account:string toggle:bool)
        (if (= toggle true)
            (compose-capability (DPTF_SET_BURN-ROLE patron identifier account))
            (compose-capability (DPTF_UNSET_BURN-ROLE patron identifier account))
        )
    )
    (defcap DPTF_SET_BURN-ROLE (patron:string identifier:string account:string)
        (compose-capability (DPTF_SET_BURN-ROLE_CORE identifier account))    
        (compose-capability (GAS_COLLECTION patron account GAS_SMALL))
        (compose-capability (DPTS_INCREASE-NONCE))
    )
    (defcap DPTF_SET_BURN-ROLE_CORE (identifier:string account:string)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_BURN_OFF identifier account))
    )
    (defcap DPTF_UNSET_BURN-ROLE (patron:string identifier:string account:string)
        (compose-capability (DPTF_UNSET_BURN-ROLE_CORE identifier account))    
        (compose-capability (GAS_COLLECTION patron account GAS_SMALL))
        (compose-capability (DPTS_INCREASE-NONCE))
    )
    (defcap DPTF_UNSET_BURN-ROLE_CORE (identifier:string account:string)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_ACCOUNT_BURN_ON identifier account))
    )
    (defcap DPTF_TOGGLE_MINT-ROLE (patron:string identifier:string account:string toggle:bool)
        (if (= toggle true)
            (compose-capability (DPTF_SET_MINT-ROLE patron identifier account))
            (compose-capability (DPTF_UNSET_MINT-ROLE patron identifier account))
        )
    )
    (defcap DPTF_SET_MINT-ROLE (patron:string identifier:string account:string)
        (compose-capability (DPTF_SET_MINT-ROLE_CORE identifier account))    
        (compose-capability (GAS_COLLECTION patron account GAS_SMALL))
        (compose-capability (DPTS_INCREASE-NONCE))
    )
    (defcap DPTF_SET_MINT-ROLE_CORE (identifier:string account:string)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_MINT_OFF identifier account))
    )   
    (defcap DPTF_UNSET_MINT-ROLE (patron:string identifier:string account:string)
        (compose-capability (DPTF_UNSET_MINT-ROLE_CORE identifier account))    
        (compose-capability (GAS_COLLECTION patron account GAS_SMALL))
        (compose-capability (DPTS_INCREASE-NONCE))
    )
    (defcap DPTF_UNSET_MINT-ROLE_CORE (identifier:string account:string)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_ACCOUNT_MINT_ON identifier account))
    )
    (defcap DPTF_TOGGLE_TRANSFER-ROLE (patron:string identifier:string account:string toggle:bool)
        (if (= toggle true)
            (compose-capability (DPTF_SET_TRANSFER-ROLE patron identifier account))
            (compose-capability (DPTF_UNSET_TRANSFER-ROLE patron identifier account))
        )
    )
    (defcap DPTF_SET_TRANSFER-ROLE (patron:string identifier:string account:string)
        (compose-capability (DPTF_SET_TRANSFER-ROLE_CORE identifier account))    
        (compose-capability (GAS_COLLECTION patron account GAS_SMALL))
        (compose-capability (UPDATE-ROLE_TRANSFER-AMOUNT))
        (compose-capability (DPTS_INCREASE-NONCE))
    )
    (defcap DPTF_SET_TRANSFER-ROLE_CORE (identifier:string account:string)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-ADD-SPECIAL-ROLE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_TRANSFER_OFF identifier account))
    )
    (defcap DPTF_UNSET_TRANSFER-ROLE (patron:string identifier:string account:string)
        (compose-capability (DPTF_UNSET_TRANSFER-ROLE_CORE identifier account))    
        (compose-capability (GAS_COLLECTION patron account GAS_SMALL))
        (compose-capability (UPDATE-ROLE_TRANSFER-AMOUNT))
        (compose-capability (DPTS_INCREASE-NONCE))
    )
    (defcap DPTF_UNSET_TRANSFER-ROLE_CORE (identifier:string account:string)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_ACCOUNT_TRANSFER_ON identifier account))
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: COMPOSED CAPABILITIES           ;;
    ;;                                            ;;
    ;;==================CREATE======================
    ;;
    ;;      DPTF_ISSUE
    ;;      DPTF_MINT_ORIGIN|DPTF_MINT
    ;;
    (defcap DPTF_ISSUE (patron:string client:string)
        @doc "Capability required to issue a DPTF Token"
        (UV_DPTS-Account patron)
        (UV_DPTS-Account client)
        (let
            (
                (gas-id:string (UR_GasID))
            )
            (if (!= gas-id "GAS")
                (compose-capability (GAS_COLLECTION patron client GAS_ISSUE))
                true
            )
            (compose-capability (DPTS_INCREASE-NONCE))
        )
    )
    (defcap DPTF_MINT (patron:string identifier:string client:string amount:decimal origin:bool method:bool)
        @doc "Master Mint capability, required to mint DPTF Tokens, both as Origin and as Standard Mint"
        (if (= origin true)
            (compose-capability (DPTF_MINT-ORIGIN patron identifier client amount method))
            (compose-capability (DPTF_MINT-STANDARD patron identifier client amount method))
        )
    )
    (defcap DPTF_MINT-ORIGIN (patron:string identifier:string client:string amount:decimal method:bool)
        @doc "Capability required to mint the Origin DPTF Mint Supply"
        (compose-capability (DPTS_METHODIC client method))
        (compose-capability (GAS_PATRON patron identifier client GAS_BIGGEST))
        (compose-capability (DPTF_MINT-ORIGIN_CORE identifier client amount))
        (compose-capability (DPTS_INCREASE-NONCE))
    )

    (defcap DPTF_MINT-ORIGIN_CORE (identifier:string account:string amount:decimal)
        @doc "Core Capability required to mint the Origin DPTF Mint Supply"
        (UV_TrueFungibleAmount identifier amount)
        (compose-capability (DPTF_ORIGIN_VIRGIN identifier))
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (CREDIT_DPTF identifier account))
        (compose-capability (DPTF_UPDATE_SUPPLY))
    )

    (defcap DPTF_MINT-STANDARD (patron:string identifier:string client:string amount:decimal method:bool)
        @doc "Capability required to mint a DPTF Token"                
        (compose-capability (DPTS_METHODIC client method))
        (compose-capability (GAS_PATRON patron identifier client GAS_SMALL))
        (compose-capability (DPTF_MINT-STANDARD_CORE identifier client amount))
        (compose-capability (DPTS_INCREASE-NONCE))
    )
    (defcap DPTF_MINT-STANDARD_CORE (identifier:string client:string amount:decimal)
        @doc "Core Capability required to mint a DPTF Token"
        (UV_TrueFungibleAmount identifier amount)
        (compose-capability (DPTF_ACCOUNT_MINT_ON identifier client))
        (compose-capability (CREDIT_DPTF identifier client))
        (compose-capability (DPTF_UPDATE_SUPPLY))
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: COMPOSED CAPABILITIES           ;;
    ;;                                            ;;
    ;;==================DESTROY=====================
    ;;
    ;;      DPTF_BURN|DPTF_BURN_CORE
    ;;      DPTF_WIPE|DPTF_WIPE_CORE
    ;;
    (defcap DPTF_BURN (patron:string identifier:string client:string amount:decimal method:bool)
        @doc "Capability required to burn a DPTF Token"
        (compose-capability (DPTS_METHODIC client method))
        (compose-capability (GAS_PATRON patron identifier client GAS_SMALL))
        (compose-capability (DPTF_BURN_CORE identifier client amount))
        (compose-capability (DPTS_INCREASE-NONCE))
    )

    (defcap DPTF_BURN_CORE (identifier:string client:string amount:decimal)
        @doc "Core Capability required to burn a DPTF Token"
        (UV_TrueFungibleAmount identifier amount)
        (compose-capability (DPTF_ACCOUNT_BURN_ON identifier client))
        (compose-capability (DEBIT_DPTF identifier client))
        (compose-capability (DPTF_UPDATE_SUPPLY))
    )
    
    (defcap DPTF_WIPE (patron:string identifier:string account-to-be-wiped:string)
        @doc "Core Capability required to Wipe a DPTF Token Balance from a DPTF account"
        (compose-capability (GAS_PATRON patron identifier account-to-be-wiped GAS_BIGGEST))
        (compose-capability (DPTF_WIPE_CORE identifier account-to-be-wiped))
        (compose-capability (DPTS_INCREASE-NONCE))
    )
    (defcap DPTF_WIPE_CORE (identifier:string account-to-be-wiped:string)
        @doc "Core Capability required to Wipe a DPTF Token Balance from a DPTF account"
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account-to-be-wiped)
        (compose-capability (DPTF_OWNER identifier))
        (compose-capability (DPTF_CAN-WIPE_ON identifier))
        (compose-capability (DPTF_ACCOUNT_FREEZE_ON identifier account-to-be-wiped))
        (compose-capability (DPTF_UPDATE_SUPPLY))
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: COMPOSED CAPABILITIES           ;;
    ;;                                            ;;
    ;;==================TRANSFER==================== 
    ;;
    ;;      GAS_MOVER|TRANSFER_DPTF|TRANSFER_DPTF_CORE
    ;;
    (defcap GAS_MOVER (sender:string receiver:string amount:decimal)
        @doc "Capability required for moving GAS"
        (let
            (
                (gas-id:string (UR_GasID))
            )
            (compose-capability (TRANSFER_DPTF_CORE gas-id sender receiver amount))
            (compose-capability (SC_TRANSFERABILITY sender receiver true))
        )
    )
    (defcap TRANSFER_DPTF (patron:string identifier:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Main DPTF Transfer Capability"
        (enforce-one
            (format "No permission available to transfer from Account {}" [sender])
            [
                (compose-capability (DPTS_METHODIC sender method))
                (compose-capability (DPTS_METHODIC receiver method))
            ]
        )
        (compose-capability (GAZ_PATRON patron identifier sender receiver GAS_SMALLEST))
        (compose-capability (TRANSFER_DPTF_CORE identifier sender receiver transfer-amount))
        (compose-capability (SC_TRANSFERABILITY sender receiver method))
        (compose-capability (DPTS_INCREASE-NONCE))
    )
    (defcap TRANSFER_DPTF_CORE (identifier:string sender:string receiver:string transfer-amount:decimal)
        @doc "Core Capability for transfer between 2 DPTS accounts for a specific DPTF Token identifier"

        (UV_TrueFungibleAmount identifier transfer-amount)
        (UV_SenderWithReceiver sender receiver)

        ;;Checks pause and freeze statuses
        (compose-capability (DPTF_IS-PAUSED_OFF identifier))
        (compose-capability (DPTF_ACCOUNT_FREEZE_OFF identifier sender))
        (compose-capability (DPTF_ACCOUNT_FREEZE_OFF identifier receiver))

        ;;Checks transfer roles of sender and receiver
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

        ;;Add Debit and Credit capabilities
        (compose-capability (DEBIT_DPTF identifier sender))  
        (compose-capability (CREDIT_DPTF identifier receiver))
    )
    
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: COMPOSED CAPABILITIES           ;;
    ;;                                            ;;
    ;;=================CORE=========================
    ;;
    ;;      CREDIT_DPTF|DEBIT_DPTF
    ;;
    (defcap CREDIT_DPTF (identifier:string account:string)
        @doc "Capability to perform crediting operations with DPTF Tokens"
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)
        (compose-capability (DPTS_ACCOUNT_EXIST account))
    )
    (defcap DEBIT_DPTF (identifier:string account:string)
        @doc "Capability to perform debiting operations on a Normal DPTS Account type for a DPTF Token"
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)
        (compose-capability (DPTF_CLIENT identifier account))
    )
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      DPTF: UTILITY FUNCTIONS                 Description                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================ACCOUNT-INFO================                                                                                                    ;;
    ;;      UR_AccountTrueFungibleExist             Checks if DPTF Account <account> exists for DPTF Token id <identifier>                              ;;
    ;;      UR_AccountTrueFungibles                 Returns a List of Truefungible Identifiers held by DPTF Accounts <account>                          ;;
    ;;      UR_AccountTrueFungibleSupply            Returns Account <account> True Fungible <identifier> Supply                                         ;;
    ;;      UR_AccountTrueFungibleRoleBurn          Returns Account <account> True Fungible <identifier> Burn Role                                      ;;
    ;;      UR_AccountTrueFungibleRoleMint          Returns Account <account> True Fungible <identifier> Mint Role                                      ;;
    ;;      UR_AccountTrueFungibleRoleTransfer      Returns Account <account> True Fungible <identifier> Transfer Role                                  ;;
    ;;      UR_AccountTrueFungibleFrozenState       Returns Account <account> True Fungible <identifier> Frozen State                                   ;;
    ;;==================TRUE-FUNGIBLE-INFO==========                                                                                                    ;;
    ;;      UR_TrueFungibleKonto                    Returns True Fungible <identifier> Owner Account                                                    ;;
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
    ;;      UC_TrueFungibleAmountCheck              Checks if the supplied amount is valid with the decimal denomination of the identifier              ;;
    ;;      UV_TrueFungibleIdentifier               Enforces the TrueFungible <identifier> exists                                                       ;;
    ;;==================MULTI-TRANSFER==============                                                                                                    ;;
    ;;      UC_ID-Amount_Pair                       Creates an ID-Amount Pair (used in Multi DPTF Transfer)                                             ;;
    ;;      UV_ID-Amount_Pair                       Checks an ID-Amount Pair to be conform so that a Multi DPTF Transfer can properly take place        ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      DPTF: ADMINISTRATION FUNCTIONS                                                                                                              ;;
    ;;                                                                                                                                                  ;;
    ;;      NO ADMINISTRATOR FUNCTIONS                                                                                                                  ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      DPTF: CLIENT FUNCTIONS                  Description                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================CONTROL=====================                                                                                                    ;;
    ;;5     C_ChangeOwnership                       Moves DPTF <identifier> Token Ownership to <new-owner> DPTF Account                                 ;;
    ;;2     C_Control                               Controls TrueFungible <identifier> Properties using 7 boolean control triggers                      ;;
    ;;3     C_TogglePause                           Pause/Unpause TrueFungible <identifier> via the boolean <toggle>                                    ;;
    ;;4     C_ToggleFreezeAccount                   Freeze/Unfreeze via boolean <toggle> TrueFungile <identifier> on DPTF Account <account>             ;;
    ;;==================SET=========================                                                                                                    ;;
    ;;2     C_ToggleBurnRole                        Sets |role-burn| to <toggle> boolean for TrueFungible <identifier> and DPTF Account <account>       ;;
    ;;2     C_ToggleMintRole                        Sets |role-mint| to <toggle> boolean for TrueFungible <identifier> and DPTF Account <account>       ;;
    ;;2     C_ToggleTransferRole                    Sets |role-transfer| to <toggle> boolean for TrueFungible <identifier> and DPTF Account <account>   ;;
    ;;==================CREATE======================                                                                                                    ;;
    ;;15    C_IssueTrueFungible                     Issues a new TrueFungible                                                                           ;;
    ;;      C_DeployTrueFungibleAccount             Creates a new DPTF Account for TrueFungible <identifier> and Account <account>                      ;;
    ;;5|2   C_Mint                                  Mints <amount> <identifier> TrueFungible for DPTF Account <account>: Origin|Normal (5|2 GAS cost)   ;;                                ;;
    ;;5|2   CX_Mint                                 Methodic, similar to |C_Mint| for Smart-DPTS Account type operation                                 ;;
    ;;==================DESTROY=====================                                                                                                    ;;
    ;;2     C_Burn                                  Burns <amount> <identifier> TrueFungible on DPTF Account <account>                                  ;;
    ;;2     CX_Burn                                 Methodic, similar to |C_Burn| for Smart-DPTS Account type operation                                 ;;
    ;;5     C_Wipe                                  Wipes the whole supply of <identifier> TrueFungible of a frozen DPTF Account <account>              ;;
    ;;==================TRANSFER====================                                                                                                    ;;
    ;;1     C_TransferTrueFungible                  Transfers <identifier> TrueFungible from <sender> to <receiver> DPTF Account                        ;;
    ;;------------------METHODIC-TRANSFER---------------------------------------------------------------------------------------------------------------;;
    ;;1     CX_TransferTrueFungible                 Methodic, Similar to |C_TransferTrueFungible| for Smart-DPTS Account type operation                 ;;
    ;;==================MULTI-TRANSFER==============                                                                                                    ;;
    ;;      C_MultiTransferTrueFungible             Executes a Multi DPTF transfer using 2 separate lists of multiple IDs|Transfer-amounts              ;;
    ;;      C_BulkTransferTrueFungible              Executes a Bulk DPTF transfer using 2 separate lists of multiple Receivers|Transfer-amounts         ;;                                                                                                                                   ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      DPTF: AUXILIARY FUNCTIONS               Description                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================TRANSFER====================                                                                                                    ;;
    ;;      X_TransferTrueFungible                  Transfers <identifier> TrueFungible from <sender> to <receiver> DPTF Account without GAS            ;;
    ;;==================MULTI-TRANSFER==============                                                                                                    ;;
    ;;      X_MultiTransferTrueFungiblePaired       Helper Function needed for making a Multi DPTF Transfer possible                                    ;;
    ;;      X_BulkTransferTrueFungiblePaired        Helper Function needed for making a Bulk DPTF Transfer possible                                     ;;
    ;;==================CREDIT|DEBIT================                                                                                                    ;;
    ;;      X_Credit                                Auxiliary Function that credits a TrueFungible to a DPTF Account                                    ;;
    ;;      X_Debit                                 Auxiliary Function that debits a TrueFungible from a DPTF Account                                   ;;
    ;;==================UPDATE======================                                                                                                    ;;
    ;;      X_UpdateSupply                          Updates <identifier> TrueFungible supply. Boolean <direction> used for increase|decrease            ;;
    ;;      X_UpdateRoleTransferAmount              Updates <role-transfer-amount> for Token <identifier>                                               ;;
    ;;==================AUXILIARY===================                                                                                                    ;;
    ;;      X_ChangeOwnership                       Auxiliary function required in the main function                                                    ;;
    ;;      X_Control                               Auxiliary function required in the main function                                                    ;;
    ;;      X_TogglePause                           Auxiliary function required in the main function                                                    ;;
    ;;      X_ToggleFreezeAccount                   Auxiliary function required in the main function                                                    ;;
    ;;      X_ToggleBurnRole                        Auxiliary function required in the main function                                                    ;;
    ;;      X_ToggleMintRole                        Auxiliary function required in the main function                                                    ;;
    ;;      X_ToggleTransferRole                    Auxiliary function required in the main function                                                    ;;
    ;;      X_IssueTrueFungible                     Auxiliary function required in the main function                                                    ;;
    ;;      X_Mint                                  Auxiliary function required in the main function                                                    ;;
    ;;      X_Burn                                  Auxiliary function required in the main function                                                    ;;
    ;;      X_Wipe                                  Auxiliary function required in the main function                                                    ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: UTILITY FUNCTIONS               ;;
    ;;                                            ;;
    ;;==================ACCOUNT-INFO================
    ;;
    ;;      UR_AccountTrueFungibleExist|UR_AccountTrueFungibles
    ;;      UR_AccountTrueFungibleSupply
    ;;      UR_AccountTrueFungibleRoleBurn|UR_AccountTrueFungibleRoleMint
    ;;      UR_AccountTrueFungibleRoleTransfer|UR_AccountTrueFungibleFrozenState
    ;;
    (defun UR_AccountTrueFungibleExist:bool (identifier:string account:string)
        @doc "Checks if DPTF Account <account> exists for DPTF Token id <identifier>"
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)

        (with-default-read DPTF-BalancesTable (concat [identifier BAR account])
            { "balance" : -1.0 }
            { "balance" := b}
            (if (= b -1.0)
                false
                true
            )
        )
    )
    (defun UR_AccountTrueFungibles:[string] (account:string)
        @doc "Returns a List of Truefungible Identifiers held by DPTF Accounts <account>"
        (UV_DPTS-Account account)

        (let*
            (
                (keyz:[string] (keys DPTF-BalancesTable))
                (listoflists:[[string]] (map (lambda (x:string) (UC_SplitString BAR x)) keyz))
                (dptf-account-tokens:[string] (UC_FilterIdentifier listoflists account))
            )
            dptf-account-tokens
        )
    )
    (defun UR_AccountTrueFungibleSupply:decimal (identifier:string account:string)
        @doc "Returns Account <account> True Fungible <identifier> Supply"
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)

        (with-default-read DPTF-BalancesTable (concat [identifier BAR account])
            { "balance" : 0.0 }
            { "balance" := b}
            b
        )
    )
    (defun UR_AccountTrueFungibleRoleBurn:bool (identifier:string account:string)
        @doc "Returns Account <account> True Fungible <identifier> Burn Role"
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)

        (at "role-burn" (read DPTF-BalancesTable (concat [identifier BAR account]) ["role-burn"]))
    )
    (defun UR_AccountTrueFungibleRoleMint:bool (identifier:string account:string)
        @doc "Returns Account <account> True Fungible <identifier> Mint Role"
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)

        (at "role-mint" (read DPTF-BalancesTable (concat [identifier BAR account]) ["role-mint"]))
    )
    (defun UR_AccountTrueFungibleRoleTransfer:bool (identifier:string account:string)
        @doc "Returns Account <account> True Fungible <identifier> Transfer Role \
            \ with-default-read assumes the role is always false for not existing accounts \
            \ Needed for Transfer Anew functions"
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)

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
        (UV_DPTS-Account account)

        (with-default-read DPTF-BalancesTable (concat [identifier BAR account])
            { "frozen" : false}
            { "frozen" := fr }
            fr
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: UTILITY FUNCTIONS               ;;
    ;;                                            ;;
    ;;==================TRUE-FUNGIBLE-INFO==========
    ;;
    ;;      UR_TrueFungibleKonto|UR_TrueFungibleName|UR_TrueFungibleTicker|UR_TrueFungibleDecimals
    ;;      UR_TrueFungibleCanChangeOwner|UR_TrueFungibleCanUpgrade|UR_TrueFungibleCanAddSpecialRole
    ;;      UR_TrueFungibleCanFreeze|UR_TrueFungibleCanWipe|UR_TrueFungibleCanPause|UR_TrueFungibleIsPaused
    ;;      UR_TrueFungibleSupply|UR_TrueFungibleOriginMint|UR_TrueFungibleOriginAmount|UR_TrueFungibleTransferRoleAmount
    ;;
    (defun UR_TrueFungibleKonto:string (identifier:string)
        @doc "Returns True Fungible <identifier> Account"
        (UV_TrueFungibleIdentifier identifier)
        (at "owner-konto" (read DPTF-PropertiesTable identifier ["owner-konto"]))
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
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: UTILITY FUNCTIONS               ;;
    ;;                                            ;;
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
    (defun UC_TrueFungibleAmountCheck:bool (identifier:string amount:decimal)
        @doc "Checks if the supplied amount is valid with the decimal denomination of the identifier \
        \ and if the amount is greater than zero. \
        \ Does not use enforcements, it produces a simple check. If everything checks out, returns true, if not false \
        \ Does not use enforcements "

        (let*
            (
                (decimals:integer (UR_TrueFungibleDecimals identifier))
                (decimal-check:bool (if (= (floor amount decimals) amount) true false))
                (positivity-check:bool (if (> amount 0.0) true false))
                (result:bool (and decimal-check positivity-check))
            )
            result
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
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: UTILITY FUNCTIONS               ;;
    ;;                                            ;;
    ;;==================MULTI-TRANSFER==============
    ;;
    ;;      UC_ID-Amount_Pair|UV_ID-Amount_Pair
    ;;
    (defun UC_ID-Amount_Pair:[object{ID-Amount_Schema}] (id-lst:[string] transfer-amount-lst:[decimal])
        @doc "Creates an ID-Amount Pair (used in Multi DPTF Transfer)"
        (let
            (
                (id-length:integer (length id-lst))
                (amount-length:integer (length transfer-amount-lst))
            )
            (enforce (= id-length amount-length) "ID and Transfer-Amount Lists are not of equal length")
            (zip (lambda (x:string y:decimal) { "id": x, "amount": y }) id-lst transfer-amount-lst)
        )
    )
    (defun UC_Receiver-Amount_Pair:[object{Receiver-Amount_Schema}] (receiver-lst:[string] transfer-amount-lst:[decimal])
        @doc "Create a Receiver-Amount Pair (used in Bulk DPTF Transfer"
        (let
            (
                (receiver-length:integer (length receiver-lst))
                (amount-length:integer (length transfer-amount-lst))
            )
            (enforce (= receiver-length amount-length) "Receiver and Transfer-Amount Lists are not of equal length")
            (zip (lambda (x:string y:decimal) { "receiver": x, "amount": y }) receiver-lst transfer-amount-lst)
        )
    )
    (defun UV_Receiver-Amount_Pair:bool (identifier:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @doc "Checks an Receiver-Amount pair to be conform with a token identifier for Bulk Transfer purposes"
        (UV_TrueFungibleIdentifier identifier)

        (let*
            (
                (receiver-amount-object-lst:[object{Receiver-Amount_Schema}] (UC_Receiver-Amount_Pair receiver-lst transfer-amount-lst))
                (account-check:bool
                    (fold
                        (lambda
                            (acc:bool item:object{Receiver-Amount_Schema})
                            (let*
                                (
                                    (receiver-account:string (at "receiver" item))
                                    (receiver-check:bool (UC_DPTS-AccountCheck receiver-account))
                                )
                                (and acc receiver-check)
                            )
                        )
                        true
                        receiver-amount-object-lst
                    )
                )
                (id-amount-check:bool
                    (fold
                        (lambda
                            (acc:bool item:object{Receiver-Amount_Schema})
                            (let*
                                (
                                    (transfer-amount:decimal (at "amount" item))
                                    (check:bool (UC_TrueFungibleAmountCheck identifier transfer-amount))
                                )
                                (and acc check)
                            )
                        )
                        true
                        receiver-amount-object-lst
                    )
                )
            )
            (and account-check id-amount-check)
        )
    )
    (defun UV_ID-Amount_Pair:bool (id-lst:[string] transfer-amount-lst:[decimal])
        @doc "Checks an ID-Amount Pair to be conform so that a Multi DPTF Transfer can properly take place"
        (let*
            (
                (id-amount-object-lst:[object{ID-Amount_Schema}] (UC_ID-Amount_Pair id-lst transfer-amount-lst))
                (result
                    (fold
                        (lambda
                            (acc:bool item:object{ID-Amount_Schema})
                            (let*
                                (
                                    (id:string (at "id" item))
                                    (amount:decimal (at "amount" item))
                                    (check:bool (UC_TrueFungibleAmountCheck id amount))
                                )
                                (and acc check)
                            )
                        )
                        true
                        id-amount-object-lst
                    )
                )
            )
            result
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: ADMINISTRATION FUNCTIONS        ;;
    ;;                                            ;;
    ;;      NO ADMINISTRATOR FUNCTIONS            ;;
    ;;                                            ;;
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: CLIENT FUNCTIONS                ;;
    ;;                                            ;;
    ;;==================CONTROL=====================
    ;;
    ;;      C_ChangeOwnership|C_Control
    ;;      C_TogglePause|C_ToggleFreezeAccount
    ;;
    (defun C_ChangeOwnership (patron:string identifier:string new-owner:string)
        @doc "Moves DPTF <identifier> Token Ownership to <new-owner> DPTF Account"
        (let
            (
                (ZG:bool (UR_GasToggle))
                (current-owner-account:string (UR_TrueFungibleKonto identifier))
            )
            (with-capability (DPTF_OWNERSHIP-CHANGE patron identifier new-owner)
                (if (= ZG false)
                    (X_CollectGAS patron current-owner-account GAS_BIGGEST)
                    true
                )
                (X_ChangeOwnership patron identifier new-owner)
                (X_IncrementNonce patron)
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
        )
        @doc "Controls TrueFungible <identifier> Properties using 7 boolean control triggers \
            \ Setting the <can-upgrade> property to false disables all future Control of Properties"

        (let
            (
                (ZG:bool (UR_GasToggle))
                (current-owner-account:string (UR_TrueFungibleKonto identifier))
            )
            (with-capability (DPTF_CONTROL patron identifier)
                (if (= ZG false)
                    (X_CollectGAS patron current-owner-account GAS_SMALL)
                    true
                )
                (X_Control patron identifier can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause)
                (X_IncrementNonce patron)
            )
        )
    )
    (defun C_TogglePause (patron:string identifier:string toggle:bool)
        @doc "Pause/Unpause TrueFungible <identifier> via the boolean <toggle>"
        (let
            (
                (ZG:bool (UR_GasToggle))
            )
            (with-capability (DPTF_TOGGLE_PAUSE patron identifier toggle)
                (if (= ZG false)
                    (X_CollectGAS patron patron GAS_MEDIUM)
                    true
                )
                (X_TogglePause identifier toggle)
                (X_IncrementNonce patron)
            )
        )
    )
    (defun C_ToggleFreezeAccount (patron:string identifier:string account:string toggle:bool)
        @doc "Freeze/Unfreeze via boolean <toggle> TrueFungile <identifier> on DPTF Account <account>"
        (let
            (
                (ZG:bool (UR_GasToggle))
            )
            (with-capability (DPTF_TOGGLE_FREEZE-ACCOUNT patron identifier account toggle)
                (if (= ZG false)
                    (X_CollectGAS patron account GAS_BIG)
                    true
                )
                (X_ToggleFreezeAccount identifier account toggle)
                (X_IncrementNonce patron)
            )
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: CLIENT FUNCTIONS                ;;
    ;;                                            ;;
    ;;==================UNSET=======================
    ;;
    ;;      C_ToggleBurnRole|C_ToggleMintRole|C_ToggleTransferRole
    ;;
    (defun C_ToggleBurnRole (patron:string identifier:string account:string toggle:bool)
        @doc "Sets |role-burn| to <toggle> boolean for TrueFungible <identifier> and DPTF Account <account> \
            \ Afterwards Account <account> can either burn or no longer burn existing TrueFungible"

        (let
            (
                (ZG:bool (UR_GasToggle))
            )
            (with-capability (DPTF_TOGGLE_BURN-ROLE patron identifier account toggle)
                (if (= ZG false)
                    (X_CollectGAS patron account GAS_SMALL)
                    true
                )
                (X_ToggleBurnRole identifier account toggle)
                (X_IncrementNonce patron)
            )
        )
    )
    (defun C_ToggleMintRole (patron:string identifier:string account:string toggle:bool)
        @doc "Sets |role-mint| to <toggle> boolean for TrueFungible <identifier> and DPTF Account <account> \
            \ Afterwards Account <account> can either mint or no longer mint existing TrueFungible"

        (let
            (
                (ZG:bool (UR_GasToggle))
            )
            (with-capability (DPTF_TOGGLE_MINT-ROLE patron identifier account toggle)
                (if (= ZG false)
                    (X_CollectGAS patron account GAS_SMALL)
                    true
                )
                (X_ToggleMintRole identifier account toggle)
                (X_IncrementNonce patron)
            )
        )
    )
    (defun C_ToggleTransferRole (patron:string identifier:string account:string toggle:bool)
        @doc "Sets |role-transfer| to <toggle> boolean for TrueFungible <identifier> and DPTF Account <account> \
            \ If at least one DPTF Account has the |role-transfer|set to true, then all normal transfer are restricted \
            \ Transfer will only work towards DPTF Accounts with |role-trasnfer| true, \
            \ while these DPTF Accounts can transfer the TrueFungible unrestricted to any other DPTF Account"

        (let
            (
                (ZG:bool (UR_GasToggle))
            )
            (with-capability (DPTF_TOGGLE_TRANSFER-ROLE patron identifier account toggle)
                (if (= ZG false)
                    (X_CollectGAS patron account GAS_SMALL)
                    true
                )
                (X_ToggleTransferRole identifier account toggle)
                (X_UpdateRoleTransferAmount identifier toggle)
                (X_IncrementNonce patron)
            )
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: CLIENT FUNCTIONS                ;;
    ;;                                            ;;
    ;;==================CREATE====================== 
    ;;
    ;;      C_IssueTrueFungible|C_DeployTrueFungibleAccount
    ;;      C_Mint
    ;;
    (defun C_IssueTrueFungible:string 
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
        )
        @doc "Issue a new TrueFungible \
            \ This creates an entry into the DPTF-PropertiesTable \
            \ Such an entry means the DPTF Token has been created. Function outputs as string the Token-Identifier \
            \ Token Identifier is formed from ticker, followed by a dash, \ 
            \ followed by the first 12 characters of the previous block hash to ensure uniqueness. \
            \ \
            \ Furthermore, The issuer creates a Standard DPTF Account for himself, as the first Account of this DPTF Token \
            \ By default, DPTF Account creation also creates a Standard DPTS Account, if it doesnt exist"
        (UV_DPTS-Account account)
        (UV_DPTS-Decimals decimals)
        (UV_DPTS-Name name)
        (UV_DPTS-Ticker ticker)

        (let
            (
                (ZG:bool (UR_GasToggle))
            )
            (with-capability (DPTF_ISSUE patron account)
                (let
                    (
                        (spawn-id:string (X_IssueTrueFungible patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause))
                    )
                    (if (= ZG true)
                        (X_CollectGAS patron account GAS_ISSUE)
                        true
                    )
                    (X_IncrementNonce patron)
                    spawn-id
                )
                
            )
        )
    )
    (defun C_DeployTrueFungibleAccount (identifier:string account:string)
        @doc "Creates a new DPTF Account for TrueFungible <identifier> and Account <account> \
            \ If a DPTF Account already exists for <identifier> and <account>, it remains as is \
            \ \
            \ A Standard DPTS Account is also created, if one doesnt exist \
            \ If a DPTS Account exists, its type remains unchanged"
        (UV_TrueFungibleIdentifier identifier)
        (UV_DPTS-Account account)

        ;;Creates new Entry in the DPTF-BalancesTable for <identifier>|<account>
        ;;If Entry exists, no changes are being done
        (with-default-read DPTF-BalancesTable (concat [identifier BAR account])
            { "balance" : 0.0
            , "role-burn" : false
            , "role-mint" : false
            , "role-transfer" : false
            , "frozen" : false}
            { "balance" := b
            , "role-burn" := rb
            , "role-mint" := rm
            , "role-transfer" := rt
            , "frozen" := f }
            (write DPTF-BalancesTable (concat [identifier BAR account])
                { "balance"                     : b
                , "role-burn"                   : rb
                , "role-mint"                   : rm
                , "role-transfer"               : rt
                , "frozen"                      : f
                } 
            )
        )
    )
    (defun C_Mint (patron:string identifier:string account:string amount:decimal origin:bool)
        @doc "Mints <amount> <identifier> TrueFungible for DPTF Account <account> \
            \ \
            \ Boolean <origin> toggles between Normal Mint and Origin Mint \
            \ Normal Mint must use a false boolean \
            \ \
            \ Origin Mint reffers to the Initial Mint Amount when a True Fungibile is issued \
            \ Does not require Mint Role, but can be executed only once, after Token issuance \
            \ and only when its emmision is zero (right after issuance) \
            \ \
            \ Normal mint (false <origin> boolean = 2 GAS cost (GAS_SMALL) \
            \ Origin mint (true <origin> boolean = 5 GAS cost (GAS_BIGGEST) "

        (let
            (
                (ZG:bool (UC_ZeroGAS identifier account))
            )
            (with-capability (DPTF_MINT patron identifier account amount origin false)
                (if (= ZG false)
                    (X_CollectGAS patron account GAS_SMALL)
                    true
                )
                (X_Mint identifier account amount origin)
                (X_IncrementNonce account)
            )
        )
    )
    (defun CX_Mint(patron:string identifier:string account:string amount:decimal origin:bool)
        @doc "Methodic, similar to |C_Mint| for Smart-DPTS Account type operation"
        
        (let
            (
                (ZG:bool (UC_ZeroGAS identifier account))
            )
            (require-capability (DPTF_MINT patron identifier account amount origin true))
            (if (and (= origin false) (= ZG false))
                (X_CollectGAS patron account GAS_SMALL)
                (if (and (= origin true) (= ZG false))
                    (X_CollectGAS patron account GAS_BIGGEST)
                    true
                )
            )
            (X_Mint identifier account amount origin)
            (X_IncrementNonce account)
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: CLIENT FUNCTIONS                ;;
    ;;                                            ;;
    ;;==================DESTROY=====================
    ;;
    ;;      C_Burn|C_Wipe
    ;;
    (defun C_Burn (patron:string identifier:string account:string amount:decimal)
        @doc "Burns <amount> <identifier> TrueFungible on DPTF Account <account>"
        (let
            (
                (ZG:bool (UC_ZeroGAS identifier account))
            )
            (with-capability (DPTF_BURN patron identifier account amount false)
                (if (= ZG false)
                    (X_CollectGAS patron account GAS_SMALL)
                    true
                )
                (X_Burn identifier account amount)
                (X_IncrementNonce account)
            )
        )
    )
    (defun CX_Burn (patron:string identifier:string account:string amount:decimal)
        @doc "Methodic, similar to |C_Burn| for Smart-DPTS Account type operation"
        (require-capability (DPTF_BURN patron identifier account amount true))
        (let
            (
                (ZG:bool (UC_ZeroGAS identifier account))
            )
            (if (= ZG false)
                (X_CollectGAS patron account GAS_SMALL)
                true
            )
            (X_Burn identifier account amount)
            (X_IncrementNonce account)
        )
    )
    (defun C_Wipe (patron:string identifier:string account-to-be-wiped:string)
        @doc "Wipes the whole supply of <identifier> TrueFungible of a frozen DPTF Account <account>"

        (let
            (
                (ZG:bool (UC_ZeroGAS identifier account-to-be-wiped))
            )
            (with-capability (DPTF_WIPE patron identifier account-to-be-wiped)
                (if (= ZG false)
                    (X_CollectGAS patron account-to-be-wiped GAS_BIGGEST)
                    true
                )
                (X_Wipe identifier account-to-be-wiped)
                (X_IncrementNonce patron)
            )
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: CLIENT FUNCTIONS                ;;
    ;;                                            ;;
    ;;==================TRANSFER====================
    ;;
    ;;      C_TransferTrueFungible
    ;;
    (defun C_TransferTrueFungible (patron:string identifier:string sender:string receiver:string transfer-amount:decimal)
        @doc "Transfers <identifier> TrueFungible from <sender> to <receiver> DPTF Account, using boolean <anew> as input \
            \ If target DPTF account doesnt exist, boolean <anew> must be set to true"

        (with-capability (TRANSFER_DPTF patron identifier sender receiver transfer-amount false)
            (let
                (
                    (ZG:bool (UC_ZeroGAZ identifier sender receiver))
                )
                (if (= ZG false)
                    (X_CollectGAS patron sender GAS_SMALLEST)
                    true
                )
                (X_TransferTrueFungible identifier sender receiver transfer-amount)
                (X_IncrementNonce sender)
            )
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: CLIENT FUNCTIONS                ;;
    ;;                                            ;;
    ;;==================METHODIC-TRANSFER===========
    ;;
    ;;      CX_TransferTrueFungible
    ;;
    (defun CX_TransferTrueFungible (patron:string identifier:string sender:string receiver:string transfer-amount:decimal)
        @doc "Methodic, Similar to |C_TransferTrueFungible| for Smart-DPTS Account type operation"
        (require-capability (TRANSFER_DPTF patron identifier sender receiver transfer-amount true))
        (let
            (
                (ZG:bool (UC_ZeroGAZ identifier sender receiver))
            )
            (if (= ZG false)
                (X_CollectGAS patron sender GAS_SMALLEST)
                true
            )
            (X_TransferTrueFungible identifier sender receiver transfer-amount)
            (X_IncrementNonce sender)
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: CLIENT FUNCTIONS                ;;
    ;;                                            ;;
    ;;==================MULTI-TRANSFER==============
    ;;
    ;;      C_MultiTransferTrueFungible|C_BulkTransferTrueFungible
    ;;
    (defun C_MultiTransferTrueFungible (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal])
        @doc "Executes a Multi DPTF transfer using 2 separate lists of multiple IDs and multiple transfer amounts"

        (let
            (
                (pair-validation:bool (UV_ID-Amount_Pair id-lst transfer-amount-lst))
            )
            (enforce (= pair-validation true) "Input Lists <id-lst>|<transfer-amount-lst> cannot make a valid pair list for Multi Transfer Processing")
            (let
                (
                    (pair:[object{ID-Amount_Schema}] (UC_ID-Amount_Pair id-lst transfer-amount-lst))
                )
                (map (lambda (x:object{ID-Amount_Schema}) (X_MultiTransferTrueFungiblePaired patron sender receiver x)) pair)
            )
        )
    )
    (defun C_BulkTransferTrueFungible (patron:string identifier:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @doc "Executes a Bulk DPTF transfer using 2 separate lists of multiple Receivers and multiple transfer amounts"

        (let
            (
                (pair-validation:bool (UV_Receiver-Amount_Pair identifier receiver-lst transfer-amount-lst))
            )
            (enforce (= pair-validation true) "Input Lists <receiver-lst>|<transfer-amount-lst> cannot make a valid pair list with the <identifier> for Bulk Transfer Processing")
            (let
                (
                    (pair:[object{Receiver-Amount_Schema}] (UC_Receiver-Amount_Pair receiver-lst transfer-amount-lst))
                )
                (map (lambda (x:object{Receiver-Amount_Schema}) (X_BulkTransferTrueFungiblePaired patron identifier sender x)) pair)
            )
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: AUXILIARY FUNCTIONS             ;;
    ;;                                            ;;
    ;;==================TRANSFER====================
    ;;
    ;;      X_TransferTrueFungible
    ;;
    (defun X_TransferTrueFungible (identifier:string sender:string receiver:string transfer-amount:decimal)
        (enforce-one
            (format "Transfer Capabilities not satisfied from Account {} to Account {}" [sender receiver])
            [
                (enforce-one
                    (format "No permission available to transfer from Account {}" [sender])
                    [
                        (require-capability (IZ_DPTS_ACCOUNT_SMART sender true))
                        (require-capability (DPTS_ACCOUNT_OWNER sender))
                    ]
                )
                (enforce-one
                    (format "No permission available to transfer from Account {}" [receiver])
                    [
                        (require-capability (IZ_DPTS_ACCOUNT_SMART receiver true))
                        (require-capability (DPTS_ACCOUNT_OWNER receiver))
                    ]
                )
            ]
        )
        (require-capability (TRANSFER_DPTF_CORE identifier sender receiver transfer-amount))
        (X_Debit identifier sender transfer-amount false)
        (X_Credit identifier receiver transfer-amount)
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: AUXILIARY FUNCTIONS             ;;
    ;;                                            ;;
    ;;==================MULTI-TRANSFER============== 
    ;;
    ;;      X_MultiTransferTrueFungiblePaired
    ;;
    (defun X_MultiTransferTrueFungiblePaired (patron:string sender:string receiver:string id-amount-pair:object{ID-Amount_Schema})
        @doc "Helper Function needed for making a Multi DPTF Transfer possible"

        (let
            (
                (id:string (at "id" id-amount-pair))
                (amount:decimal (at "amount" id-amount-pair))
            )
            (C_TransferTrueFungible patron id sender receiver amount)
        )
    )
    (defun X_BulkTransferTrueFungiblePaired (patron:string identifier:string sender:string receiver-amount-pair:object{Receiver-Amount_Schema})
        @doc "Helper Function needed for making a Bulk DPTF Transfer possible"

        (let
            (
                (receiver:string (at "receiver" receiver-amount-pair))
                (amount:decimal (at "amount" receiver-amount-pair))
            )
            (C_TransferTrueFungible patron identifier sender receiver amount)
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: AUXILIARY FUNCTIONS             ;;
    ;;                                            ;;
    ;;==================CREDIT|DEBIT================ 
    ;;
    ;;      X_Credit|X_Debit
    ;;
    (defun X_Credit (identifier:string account:string amount:decimal)
        @doc "Auxiliary Function that credits a TrueFungible to a DPTF Account \
        \ If a DPTF Account for the Token ID <identifier> doesnt exist, it will be created \
        \ However if a DPTS Account (Standard or Smart) doesnt exit for <account>, function will fail, \
        \ since a DPTS Account is mandatory for a DPTF Account creation"

        ;;Capability Required for Credit
        (require-capability (CREDIT_DPTF identifier account))

        ;;Checks if a DPTF Account Exists, if it doesnt a new one is created with the credited amount
        ;;If it exists, a write operation is executed, writing an updated amount
        (let
            (
                (dptf-account-exist:bool (UR_AccountTrueFungibleExist identifier account))
            )
            (enforce (> amount 0.0) "Crediting amount must be greater than zero")
            (if (= dptf-account-exist false)
                (insert DPTF-BalancesTable (concat [identifier BAR account])
                    { "balance"                     : amount
                    , "role-burn"                   : false
                    , "role-mint"                   : false
                    , "role-transfer"               : false
                    , "frozen"                      : false
                    }
                )
                (with-read DPTF-BalancesTable (concat [identifier BAR account])
                    { "balance" := b
                    , "role-burn" := rb
                    , "role-mint" := rm
                    , "role-transfer" := rt
                    , "frozen" := f }
                    (write DPTF-BalancesTable (concat [identifier BAR account])
                        { "balance"                     : (+ b amount)
                        , "role-burn"                   : rb
                        , "role-mint"                   : rm
                        , "role-transfer"               : rt
                        , "frozen"                      : f
                        } 
                    )
                )
            )
        )
    )
    (defun X_Debit (identifier:string account:string amount:decimal admin:bool)
        @doc "Auxiliary Function that debits a TrueFungible from a DPTF Account \
            \ \
            \ true <admin> boolean is used when debiting is executed as a part of wiping by the DPTF Owner \
            \ otherwise, for normal debiting operations, false <admin> boolean must be used"

        ;;Capability Required for Debit is called within the <if> body
        (if (= admin true)
            (require-capability (DPTF_OWNER identifier))
            (require-capability (DEBIT_DPTF identifier account))
        )

        (with-read DPTF-BalancesTable (concat [identifier BAR account])
            { "balance" := balance }
            (enforce (<= amount balance) "Insufficient Funds for debiting")
            (update DPTF-BalancesTable (concat [identifier BAR account])
                {"balance" : (- balance amount)}    
            )
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: AUXILIARY FUNCTIONS             ;;
    ;;                                            ;;
    ;;==================UPDATE======================
    ;;
    ;;      X_UpdateSupply|X_UpdateRoleTransferAmount
    ;;
    (defun X_UpdateSupply (identifier:string amount:decimal direction:bool)
        @doc "Updates <identifier> TrueFungible supply. Boolean <direction> used for increase|decrease"
        (UV_TrueFungibleAmount identifier amount)

        (require-capability (DPTF_UPDATE_SUPPLY))
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
    (defun X_UpdateRoleTransferAmount (identifier:string direction:bool)
        @doc "Updates <role-transfer-amount> for Token <identifier>"

        (require-capability (UPDATE-ROLE_TRANSFER-AMOUNT))
        (if (= direction true)
            (with-read DPTF-PropertiesTable identifier
                { "role-transfer-amount" := rta }
                (update DPTF-PropertiesTable identifier
                    {"role-transfer-amount" : (+ rta 1)}
                )
            )
            (with-read DPTF-PropertiesTable identifier
                { "role-transfer-amount" := rta }
                (update DPTF-PropertiesTable identifier
                    {"role-transfer-amount" : (- rta 1)}
                )
            )
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      DPTF: AUXILIARY FUNCTIONS             ;;
    ;;                                            ;;
    ;;==================AUXILIARY=================== 
    ;;
    ;;      X_UpdateSupply|X_UpdateRoleTransferAmount
    ;;
    (defun X_ChangeOwnership (patron:string identifier:string new-owner:string)
        (require-capability (DPTF_OWNERSHIP-CHANGE_CORE identifier new-owner))
        (update DPTF-PropertiesTable identifier
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
        )
        (require-capability (DPTF_CONTROL_CORE identifier))
        (update DPTF-PropertiesTable identifier
            {"can-change-owner"                 : can-change-owner
            ,"can-upgrade"                      : can-upgrade
            ,"can-add-special-role"             : can-add-special-role
            ,"can-freeze"                       : can-freeze
            ,"can-wipe"                         : can-wipe
            ,"can-pause"                        : can-pause}
        )
    )

    (defun X_TogglePause (identifier:string toggle:bool)
        (if (= toggle true)
            (require-capability (DPTF_PAUSE_CORE identifier))
            (require-capability (DPTF_UNPAUSE_CORE identifier))
        )
        (update DPTF-PropertiesTable identifier
            { "is-paused" : toggle}
        )
    )
    (defun X_ToggleFreezeAccount (identifier:string account:string toggle:bool)
        (if (= toggle true)
            (require-capability (DPTF_FREEZE-ACCOUNT_CORE identifier account))
            (require-capability (DPTF_UNFREEZE-ACCOUNT_CORE identifier account))
        )
        (update DPTF-BalancesTable (concat [identifier BAR account])
            { "frozen" : toggle}
        )
    )
    (defun X_ToggleBurnRole (identifier:string account:string toggle:bool)
        (if (= toggle true)
            (require-capability (DPTF_SET_BURN-ROLE_CORE identifier account))
            (require-capability (DPTF_UNSET_BURN-ROLE_CORE identifier account))
        )
        (update DPTF-BalancesTable (concat [identifier BAR account])
            {"role-burn" : toggle}
        )
    )
    (defun X_ToggleMintRole (identifier:string account:string toggle:bool)
        (if (= toggle true)
            (require-capability (DPTF_SET_MINT-ROLE_CORE identifier account))
            (require-capability (DPTF_UNSET_MINT-ROLE_CORE identifier account))
        )
        (update DPTF-BalancesTable (concat [identifier BAR account])
            {"role-mint" : toggle}
        )
    )
    (defun X_ToggleTransferRole (identifier:string account:string toggle:bool)
        (if (= toggle true)
            (require-capability (DPTF_SET_TRANSFER-ROLE_CORE identifier account))
            (require-capability (DPTF_UNSET_TRANSFER-ROLE_CORE identifier account))
        )
        (update DPTF-BalancesTable (concat [identifier BAR account])
            {"role-transfer" : toggle}
        )
    )
    (defun X_IssueTrueFungible:string
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
        )
        (require-capability (DPTF_ISSUE patron account))
        (let
            (
                (identifier:string (UC_MakeIdentifier ticker))
            )
            ;; Add New Entries in the DPTF-PropertyTable
            ;; Since the Entry uses insert command, the KEY uniquness is ensured, since it will fail if key already exists.
            ;; Entry is initialised with <is-paused> set to off(false).
            ;; Entry is initialised with a <supply> of 0.0 (decimal)
            ;; Entry is initialised with a false switch on the <origin-mint>, meaning origin mint hasnt been executed
            ;; Entry is initialised with an <origin-mint-amount> of 0.0, meaning origin mint hasnt been executed
            ;; Entry is initiated with 0 to <role-transfer-amount>, since no Account has transfer role upon creation.
            (insert DPTF-PropertiesTable identifier
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
                ,"supply"               : 0.0
                ,"origin-mint"          : false
                ,"origin-mint-amount"   : 0.0
                ,"role-transfer-amount" : 0}
            )
            ;;Makes a new DPTF Account for the Token Issuer and returns identifier
            (C_DeployTrueFungibleAccount identifier account)
            identifier
        )
    )
    (defun X_Mint (identifier:string account:string amount:decimal origin:bool)
        (enforce-one
            (if (= origin true)
                (format "No permission valid to mint premine(origin) for DPTF Token {} on Account {}" [identifier account])
                (format "No permission available to mint with Account {}" [account])
            )
            [
                (require-capability (IZ_DPTS_ACCOUNT_SMART account true))
                (require-capability (DPTS_ACCOUNT_OWNER account))
            ]
        )
        (if (= origin true)
            (require-capability (DPTF_MINT-ORIGIN_CORE identifier account amount))
            (require-capability (DPTF_MINT-STANDARD_CORE identifier account amount))
        )
        (X_Credit identifier account amount)
            (X_UpdateSupply identifier amount true)
            (if (= origin true)
                (update DPTF-PropertiesTable identifier
                    { "origin-mint" : false
                    , "origin-mint-amount" : amount}
                )
                true
            )
    )
    (defun X_Burn (identifier:string account:string amount:decimal)
        (enforce-one
            (format "No permission available to burn with Account {}" [account])
            [
                (require-capability (IZ_DPTS_ACCOUNT_SMART account true))
                (require-capability (DPTS_ACCOUNT_OWNER account))
            ]
        )
        (require-capability (DPTF_BURN_CORE identifier account amount))
        (X_Debit identifier account amount false)
        (X_UpdateSupply identifier amount false)
    )
    (defun X_Wipe (identifier:string account-to-be-wiped:string)
        (require-capability (DPTF_WIPE_CORE identifier account-to-be-wiped))
        (let
            (
                (amount-to-be-wiped:decimal (UR_AccountTrueFungibleSupply identifier account-to-be-wiped))
            )
            (X_Debit identifier account-to-be-wiped amount-to-be-wiped true)
            (X_UpdateSupply identifier amount-to-be-wiped false)
        )
        
    )
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;;
;;                                                                                                                                                          ;;
;;                                                                                                                                                          ;;
;;                                                           DPTF_PATRON-CALLER      VGAS - Virtual Gas                                                                       ;;
;;                                                                                                                                                          ;;
;;                                                                                                                                                          ;;
;;                                                                                                                                                          ;;
;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;1]CONSTANTS Definitions - None
    ;;GAS-COSTS
    (defconst GAS_QUARTER 0.25)                     ;;Percentual Amount earned by Smart DPTS Accounts via Gas Collection
    (defconst GAS_SMALLEST 1.00)
    (defconst GAS_SMALL 2.00)
    (defconst GAS_MEDIUM 3.00)
    (defconst GAS_BIG 4.00)
    (defconst GAS_BIGGEST 5.00)
    (defconst GAS_ISSUE 15.00)
    ;;TABLE-KEYS
    (defconst VGD "VirtualGasData")
    ;;2]SCHEMAS Definitions
    (defschema DPTS-vGAS
        @doc "Schema that stores DPTF Identifier for the Gas Token of the Virtual Blockchain \
        \ The boolean <vgastg> toggles wheter or not the virtual gas is enabled or not"

        gassid:string                               ;;GAS Source Token ID, Example OURO
        gasspr:decimal                              ;;GAS Source Price in Dollars
        vgasid:string                               ;;GAS Token ID, Example GAS
        vgastg:bool                                 ;;Collection Toggle
        gaspot:string                               ;;Smart DPTS Account that is a <vgasid> DPTF Account that collects GAS
        gastpr:decimal                              ;;GAS Token Price in cents
        gasspent:decimal                            ;;Stores amount og Gas Spent on the blockchain
    )
    ;;3]TABLES Definitions
    (deftable VGASTable:{DPTS-vGAS})
    

    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      VGAS: BASIC CAPABILITIES                Description                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==============================================                                                                                                    ;;
    ;;      GAS_IS_ON                               Enforces Gas is turned ON                                                                           ;;
    ;;      GAS_IS_OFF                              Enforces Gas is turned OFF and Gas IDs are set so that turning ON can be executed                   ;;
    ;;      INCREMENT_GAS-SPENT                     Capability required to increment Gas Spent                                                          ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      VGAS: COMPOSED CAPABILITIES             Description                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================GAS-CONTROL=================                                                                                                    ;;
    ;;      UPDATE_GAS-ID                           Capability Required to update GAS id                                                                ;;
    ;;      GAS_TURN_ON                             Capability that allows to turn on Gas collection                                                    ;;
    ;;      GAS_TURN_OFF                            Capability that allows to turn off Gas collection                                                   ;;
    ;;==================GAS-HANDLING================                                                                                                    ;;
    ;;      GAS_PATRON                              Capability required for a client to ge a gas patron (the gas payer)                                 ;;
    ;;      MAKE_GAS                                Capability required to produce GAS                                                                  ;;
    ;;      COMPRESS_GAS                            Capability required to compress GAS                                                                 ;;
    ;;      GAS_COLLECTION                          Capability required to collect GAS                                                                  ;;
    ;;      GAS_COLLECTER_NORMAL                    Capability required to collect GAS when Normal DPTS accounts are involved as clients                ;;
    ;;      GAS_COLLECTER_SMART                     Capability required to collect GAS when Smart DPTS accounts are involved as clients                 ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;==============================================
    ;;                                            ;;
    ;;      VGAS: BASIC CAPABILITIES              ;;
    ;;                                            ;;
    ;;==============================================
    ;;
    ;;      GAS_TOGGLE|GAS_ID_OFF|GAS_ID_ON
    ;;
    (defcap GAS_IS_ON ()
        @doc "Enforces Gas is turned ON"

        (let
            (
                (t:bool (UR_GasToggle))
            )
            (enforce (= t true) "Gas is not turned on !")
        )
    )
    (defcap GAS_IS_OFF ()
        @doc "Enforces Gas is turned OFF and Gas IDs are set so that turning ON can be executed"

        (let
            (
                (t:bool (UR_GasToggle))
                (current-gas-source-id:string (UR_GasSourceID))
                (current-gas-id:string (UR_GasID))
            )
            (enforce (= t false) "Gas is not turned off !")
            (enforce (!= current-gas-source-id "") "Gas-Source-ID hasnt been set for the Gas to be turned ON")
            (enforce (!= current-gas-id "") "Gas-ID hasnt been set for the Gas to be turned ON")
            (enforce (!= current-gas-source-id current-gas-id) "Gas-Source-ID must be different for the Gas-ID for the Gas to be turned ON")
        )  
    )
    (defcap INCREMENT_GAS-SPENT ()
        @doc "Capability Required to increment the GAS spent"
        true
    )
    ;;==============================================
    ;;                                            ;;
    ;;      VGAS: COMPOSED CAPABILITIES           ;;
    ;;                                            ;;
    ;;==================GAS-CONTROL=================
    ;;
    ;;      UPDATE_GAS-ID
    ;;      GAS_TURN_ON|GAS_TURN_OFF
    ;;
    (defcap UPDATE_GAS-ID (identifier:string)
        (UV_TrueFungibleIdentifier identifier)
        (compose-capability (OUROBOROS_ADMIN))
    )
    (defcap GAS_TURN_ON ()
        (compose-capability (OUROBOROS_ADMIN))
        (compose-capability (GAS_IS_OFF))
    )
    (defcap GAS_TURN_OFF ()
        (compose-capability (OUROBOROS_ADMIN))
        (compose-capability (GAS_IS_ON))
    )
    ;;==================GAS-HANDLING================ 
    ;;
    ;;      GAS_PATRON|MAKE_GAS|COMPRESS_GAS|GAS_COLLECTION
    ;;      GAS_COLLECTER_NORMAL|GAS_COLLECTER_SMART
    ;;
    

    (defcap GAS_PATRON (patron:string identifier:string client:string gas-amount:decimal)
        (let
            (
                (ZG:bool (UC_ZeroGAS identifier client))
            )
            (if (= ZG false)
                (compose-capability (GAS_COLLECTION patron client gas-amount))
                true
            ) 
        )
    )
    (defcap GAZ_PATRON (patron:string identifier:string client:string target:string gas-amount:decimal)
        (let
            (
                (ZG:bool (UC_ZeroGAZ identifier client target))
            )
            (if (= ZG false)
                (compose-capability (GAS_COLLECTION patron client gas-amount))
                true
            )
        )
    )
    (defcap PATRON (patron:string)
        @doc "Capability that ensures a DPTS account can act as gas payer, also enforcing its Guard"
            (UV_DPTS-Account patron)
            (compose-capability (IZ_DPTS_ACCOUNT_SMART patron false))
            (compose-capability (DPTS_ACCOUNT_OWNER patron))
    )
    (defcap MAKE_GAS (client:string gas-source-amount:decimal)
        (let*
            (
                (gas-source-id:string (UR_GasSourceID))
                (gas-id:string (UR_GasID))
                (gas-amount:decimal (UC_GasMake gas-source-amount))
            )
        ;;01]Any client that is a Normal DPTS Account can perform GAS creation. Gas creation is always GAS free.
        (compose-capability (IZ_DPTS_ACCOUNT_SMART client false))
        ;;02]Deploy DPTF GAS Account for client (in case no DPTF GAS account exists for client)
        (compose-capability (DPTF_CLIENT gas-source-id client))
        ;;03]Client sends Gas-Source-id to the GAS Smart Contract
        (compose-capability (TRANSFER_DPTF client gas-source-id client SC_NAME_GAS gas-source-amount true))
        ;;04]Smart Contract burns GAS-Source-ID without generating IGNIS
        (compose-capability (DPTF_BURN client gas-source-id SC_NAME_GAS gas-source-amount true))
        ;;05]GAS Smart Contract mints GAS
        (compose-capability (DPTF_MINT client gas-id SC_NAME_GAS gas-amount false true))
        ;;06]GAS Smart Contract transfers GAS to client
        (compose-capability (TRANSFER_DPTF client gas-id SC_NAME_GAS client gas-amount true))
        )
    )
    (defcap COMPRESS_GAS (client:string gas-amount:decimal)
        ;;Enforce only whole amounts of GAS are used for compression
        (enforce (= (floor gas-amount 0) gas-amount) "Only whole Units of Gas can be compressed")
        (let*
            (
                (gas-id:string (UR_GasID))
                (gas-source-id:string (UR_GasSourceID))
                (gas-source-amount:decimal (UC_GasCompress gas-amount))
            )
            ;;01]Any client that is a Normal DPTS Account can perform GAS compression. Gas compression is always GAS free.
            (compose-capability (IZ_DPTS_ACCOUNT_SMART client false))
            ;;02]Deploy DPTF GAS-Source Account for client (in case no DPTF Gas-Source account exists for client)
            (compose-capability (DPTF_CLIENT gas-id client))
            ;;03]Client sends GAS to the GAS Smart Contract: <XC_MethodicTransferTrueFungible> can be used since no GAS costs is uncurred when transferring GAS tokens
            (compose-capability (TRANSFER_DPTF client gas-id client SC_NAME_GAS gas-amount true))
            ;;04]GAS Smart Contract burns GAS: no GAS costs are involved when burning GAS Token
            (compose-capability (DPTF_BURN client gas-id SC_NAME_GAS gas-amount true))
            ;;05]GAS Smart Contract mints Gas-Source Token: <X_Mint> must be used to mint without GAS costs
            (compose-capability (DPTF_MINT client gas-source-id SC_NAME_GAS gas-source-amount false true))
            ;;06]GAS Smart Contract transfers Gas-Source to client: <X_MethodicTransferTrueFungible> must be used so as to not incurr GAS fees for this transfer
            (compose-capability (TRANSFER_DPTF client gas-source-id SC_NAME_GAS client gas-source-amount true))
        )
    )
    (defcap GAS_COLLECTION (patron:string sender:string amount:decimal)
        @doc "Capability required to collect GAS"
        (UV_DPTS-Account sender)

        (compose-capability (PATRON patron))
        (let
            (
                (sender-type:bool (UR_DPTS-AccountType sender))
            )
            (if (= sender-type false)
                (compose-capability (GAS_COLLECTER_NORMAL patron amount))
                (compose-capability (GAS_COLLECTER_SMART patron sender amount))
            )
        )
    )
    (defcap GAS_COLLECTER_NORMAL (patron:string amount:decimal)
        @doc "Capability required to collect GAS when Normal DPTS accounts are involved as clients"
        (UV_DPTS-Account patron)

        (let
            (
                (gas-id:string (UR_GasID))
            )
            (UV_TrueFungibleAmount gas-id amount)
            (compose-capability (GAS_MOVER patron (UR_GasPot) amount))
            (compose-capability (INCREMENT_GAS-SPENT))
        )
    )
    (defcap GAS_COLLECTER_SMART (patron:string sender:string amount:decimal)
        @doc "Capability required to collect GAS when Smart DPTS accounts are involved as clients"
        (UV_DPTS-Account patron)
        (UV_DPTS-Account sender)
        ;;03]Validate <amount> as a GAS amount
        (let
            (
                (gas-id:string (UR_GasID))
            )
            (UV_TrueFungibleAmount gas-id amount)
            (let*
                (
                    (gas-pot:string (UR_GasPot))
                    (quarter:decimal (* amount GAS_QUARTER))
                    (rest:decimal (- amount quarter))
                    
                )
                (compose-capability (GAS_MOVER patron gas-pot rest))
                (compose-capability (GAS_MOVER patron sender quarter))
                (compose-capability (INCREMENT_GAS-SPENT))
            )
        )
    )
    
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      VGAS: UTILITY FUNCTIONS                 Description                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================VGAS-INFO===================                                                                                                    ;;
    ;;      UR_GasSourceID                          Returns as string the Gas-Source Identifier                                                         ;;
    ;;      UR_GasSourcePrice                       Returns as decimal the Gas-Source Price                                                             ;;
    ;;      UR_GasID                                Returns as string the Gas Identifier                                                                ;;
    ;;      UR_GasToggle                            Returns as boolean the Gas Toggle State                                                             ;;
    ;;      UR_GasPot                               Returns as string the Gas Pot Account                                                               ;;
    ;;      UR_GasPrice                             Returns as decimal the Gas Price in Cents                                                           ;;
    ;;      UR_GasSpent                             Returns the amount of Gas spent                                                                     ;;
    ;;      UC_GasMake                              Computes amount of GAS that can be made from the input <gas-source-amount>                          ;;
    ;;      UC_GasCompress                          Computes amount of Gas Source that can be created from an input amount <gas-amount> of GAS          ;;
    ;;      UC_ZeroGAZ                              Expanded Capability verifying if GAS cost is zero                                                   ;;
    ;;      UC_ZeroGAS                              Simple Capability verifying if GAS cost is zero                                                     ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      VGAS: ADMINISTRATION FUNCTIONS          Description                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==============================================                                                                                                    ;;
    ;;      A_InitialiseGAS                         Initialises the VGAS Table                                                                          ;;
    ;;      A_SetGasIdentifier                      Sets the Gas-Source|Gas Identifier for the Virtual Blockchain                                       ;;
    ;;      A_SetGasSourcePrice                     Sets the Gas Source Price, which determines how much GAS can be created from Gas Source Token       ;;
    ;;      A_SetGasPrice                           Sets the Gas Price in cents, which determines how much GAS can be created from Gas Source Token     ;;
    ;;      A_TurnGasOn                             Turns Gas collection ON                                                                             ;;
    ;;      A_TurnGasOff                            Turns Gas collection OFF                                                                            ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      VGAS: CLIENT FUNCTIONS                  Description                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;      C_MakeGAS                               Generates GAS from GAS Source Token via GAS Making|Creation                                         ;;
    ;;      C_CompressGAS                           Generates Gas-Source from GAS Token via GAS Compression                                             ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      VGAS: AUXILIARY FUNCTIONS               Description                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================VGAS-TABLE-UPDATES==========                                                                                                    ;;
    ;;      X_UpdateGasSourceID                     Updates Gas Source ID                                                                               ;;
    ;;      X_UpdateGasSourcePrice                  Updates Gas Source Price                                                                            ;;
    ;;      X_UpdateGasID                           Updates Gas ID                                                                                      ;;
    ;;      X_UpdateGasToggle                       Updates Gas Collection State                                                                        ;;
    ;;      X_UpdateGasPot                          Updates Gas Pot Account                                                                             ;;
    ;;      X_UpdateGasPrice                        Updates Gas Price in cents                                                                          ;;
    ;;==================VGAS-COLLECTION=============                                                                                                    ;;
    ;;      X_CollectGAS                            Collects GAS                                                                                        ;;
    ;;      X_CollectGasNormal                      Collects GAS when a normal DPTS Account is involved                                                 ;;
    ;;      X_CollectGasSmart                       Collects GAS when a smart DPTS Account is involved                                                  ;;
    ;;      X_TransferGAS                           Transfers GAS from sender to receiver                                                               ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;==============================================
    ;;                                            ;;
    ;;      VGAS: UTILITY FUNCTIONS               ;;
    ;;                                            ;;
    ;;==================VGAS-INFO===================
    ;;
    ;;      UR_GasSourceID|UR_GasSourcePrice|UR_GasID|UR_GasToggle|UR_GasPot|UR_GasPrice|UR_GasSpent
    ;;      UC_GasMake|UC_GasCompress|UC_ZeroGAZ|UC_ZeroGAS
    ;;
    (defun UR_GasSourceID:string ()
        @doc "Returns as string the Gas-Source Identifier"
        (at "gassid" (read VGASTable VGD ["gassid"]))
    )
    (defun UR_GasSourcePrice:decimal ()
        @doc "Returns as decimal the Gas-Source Price"
        (at "gasspr" (read VGASTable VGD ["gasspr"]))
    )
    (defun UR_GasID:string ()
        @doc "Returns as string the Gas Identifier"
        (with-default-read VGASTable VGD
            {"vgasid" : "GAS"}
            {"vgasid" := gas-id}
            gas-id
        )
    )
    (defun UR_GasToggle:bool ()
        @doc "Returns as boolean the Gas Toggle State"
        (with-default-read VGASTable VGD
            {"vgastg" : false}
            {"vgastg" := tg}
            tg
        )
    )
    (defun UR_GasPot:string ()
        @doc "Returns as string the Gas Pot Account"
        (at "gaspot" (read VGASTable VGD ["gaspot"]))
    )
    (defun UR_GasPrice:decimal ()
        @doc "Returns as decimal the Gas Price in Cents"
        (at "gastpr" (read VGASTable VGD ["gastpr"]))
    )
    (defun UR_GasSpent:decimal ()
        @doc "Returns as decimal the amount of Gas Spent"
        (at "gasspent" (read VGASTable VGD ["gasspent"]))
    )
    (defun UC_GasMake (gas-source-amount:decimal)
        @doc "Computes amount of GAS that can be made from the input <gas-source-amount>"
        (let*
            (
                (gas-source-id:string (UR_GasSourceID))
                (gas-source-decimals:integer (UR_TrueFungibleDecimals gas-source-id))
                (gas-source-price:decimal (UR_GasSourcePrice))
                (gas-source-price-used:decimal (if (<= gas-source-price 1.00) 1.00 gas-source-price))
                (gas-price-in-cents:decimal (UR_GasPrice))
                (gas-units-in-a-dollar:decimal (floor (/ 100.0 gas-price-in-cents) 3))
                (gas-amount:decimal (floor (* (* gas-source-price-used gas-units-in-a-dollar) gas-source-amount) 0))
            )
            (UV_TrueFungibleAmount gas-source-id gas-source-amount)
            gas-amount
        )
    )
    (defun UC_GasCompress (gas-amount:decimal)
        @doc "Computes amount of Gas Source that can be created from an input amount <gas-amount> of GAS"
        ;;Enforce only whole amounts of GAS are used for compression
        (enforce (= (floor gas-amount 0) gas-amount) "Only whole Units of Gas can be compressed")
        (let*
            (
                (gas-source-id:string (UR_GasSourceID))
                (gas-source-price:decimal (UR_GasSourcePrice))
                (gas-price-in-cents:decimal (UR_GasPrice))
                (gas-source-price-used:decimal (if (<= gas-source-price 1.00) 1.00 gas-source-price))
                (gas-cents:decimal (floor (* gas-amount gas-price-in-cents) 3))
                (cents-in-one-gas-source:decimal (floor (* gas-source-price-used 100.0) 3))
                (gas-source-decimals:integer (UR_TrueFungibleDecimals gas-source-id))
                (gas-source-mint-amount:decimal (floor (/ gas-cents cents-in-one-gas-source) gas-source-decimals))
            )
            gas-source-mint-amount
        )
    )
    (defun UC_ZeroGAZ:bool (identifier:string sender:string receiver:string)
        @doc "Returns true if GAS cost is Zero, otherwise returns false"

        (let*
            (
                (t1:bool (UC_ZeroGAS identifier sender))
                (t2:bool (if (= receiver SC_NAME_GAS) true false))
            )
            (or t1 t2)
        )
    )
    (defun UC_ZeroGAS:bool (identifier:string sender:string)
        @doc "Returns true if GAS cost is Zero, otherwise returns false"

        (let*
            (
                (t1:bool (UC_Zero sender))
                (gas-id:string (UR_GasID))
                (t2:bool (if (or (= gas-id "GAS")(= identifier gas-id)) true false))
            )
            (or t1 t2)
        )
    )
    (defun UC_Zero:bool (sender:string)
        (let
            (
                (gas-toggle:bool (UR_GasToggle))
                (t1:bool (if (= sender SC_NAME_GAS) true false))
            )
            (or gas-toggle t1)
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      VGAS: ADMINISTRATION FUNCTIONS        ;;
    ;;                                            ;;
    ;;==============================================
    ;;
    ;;      A_InitialiseGAS|A_SetVGasID|A_ChangeVGasID
    ;;      A_TurnGasOn|A_TurnGasOff
    ;;
    (defun A_InitialiseGAS:string (patron:string gas-source-id:string)
        @doc "Initialises the Virtual Gas Smart-Contract \
        \ Returns the Gas ID as string"
        (UV_TrueFungibleIdentifier gas-source-id)

        ;;Initialise the <Gas-Tanker> DPTS Account as a Smart Account
        ;;Necesary because it needs to operate as a MultiverX Smart Contract
        (C_DeploySmartDPTSAccount SC_NAME_GAS (keyset-ref-guard SC_KEY_GAS))

        (with-capability (OUROBOROS_ADMIN)
            ;;Issue GAS Token by the DPTS Account
            (let
                (
                    (GasID:string
                        (C_IssueTrueFungible
                            patron
                            SC_NAME_GAS
                            "Gas"
                            "GAS"
                            2
                            true    ;;can-change-owner
                            true    ;;can-upgrade
                            true    ;;can-add-special-role
                            true    ;;can-freeze
                            false   ;;can-wipe
                            true    ;;can-pause
                        )
                    )
                )
                ;;Set VGASTable
                (insert VGASTable VGD
                    {"gassid"           : gas-source-id
                    ,"gasspr"           : 0.0
                    ,"vgasid"           : GasID
                    ,"vgastg"           : false
                    ,"gaspot"           : SC_NAME_GAS
                    ,"gastpr"           : 1.0
                    ,"gasspent"         : 0.0}
                )
                ;;Issue OURO DPTF Account for the GAS-Tanker
                (OUROBOROS.C_DeployTrueFungibleAccount gas-source-id SC_NAME_GAS)
                ;;Set Token Roles
                (with-capability (GAS_INIT_SET-ROLES patron GasID gas-source-id SC_NAME_GAS)
                    ;;BURN Roles
                    (X_ToggleBurnRole GasID SC_NAME_GAS true)
                    (X_IncrementNonce patron)
                    (X_ToggleBurnRole gas-source-id SC_NAME_GAS true)
                    (X_IncrementNonce patron)
                    ;;MINT Roles
                    (X_ToggleMintRole GasID SC_NAME_GAS true)
                    (X_IncrementNonce patron)
                    (X_ToggleMintRole gas-source-id SC_NAME_GAS true)
                    (X_IncrementNonce patron)
                )
                GasID
            )
        )
    )
    (defun A_SetGasIdentifier (identifier:string source:bool)
        @doc "Sets the Gas-Source|Gas Identifier for the Virtual Blockchain \
            \ Boolean <source> determines wheter Gas-Source ID or GAS Id is set"
        (UV_TrueFungibleIdentifier identifier)

        (with-capability (UPDATE_GAS-ID identifier)
            (if (= source true)
                (X_UpdateGasSourceID identifier)
                (X_UpdateGasID identifier)
            )
        )
    )
    (defun A_SetGasSourcePrice (price:decimal)
        @doc "Sets the Gas Source Price in (dollars)$, which determines how much GAS can be created from Gas Source Token"
        (with-capability (OUROBOROS_ADMIN)
            (X_UpdateGasSourcePrice price)
        )
    )
    (defun A_SetGasPrice (price:decimal)
        @doc "Sets the Gas Price in cents(¢), which determines how much GAS can be created from Gas Source Token"
        (with-capability (OUROBOROS_ADMIN)
            (X_UpdateGasPrice price)
        )
    )
    (defun A_TurnGasOn ()
        @doc "Turns Gas collection ON"
        (with-capability (GAS_TURN_ON)
            (X_UpdateGasToggle true)
        )
    )
    (defun A_TurnGasOff ()
        @doc "Turns Gas collection OFF"
        (with-capability (GAS_TURN_OFF)
            (X_UpdateGasToggle false)
        )
    )
    ;;==============================================
    ;;                                            ;;
    ;;      VGAS: CLIENT FUNCTIONS                ;;
    ;;                                            ;;
    ;;==============================================
    ;;
    ;;      C_MakeGAS|C_CompressGAS
    ;;
    (defun C_MakeGAS:decimal (client:string gas-source-amount:decimal)
        @doc "Generates GAS from GAS Source Token via GAS Making|Creation\
        \ GAS generation is GAS free. \
        \ Gas Source Price is set at a minimum 1$. Uses Gas Price \
        \ Gas Amount generated is alway integer (even though itself is of decimal type)"

        ;;01]Any client that is a Normal DPTS Account can perform GAS creation. Gas creation is always GAS free.
        ;;02]Deploy DPTF GAS Account for client (in case no DPTF GAS account exists for client)
        (let*
            (
                (gas-id:string (UR_GasID))
                (gas-source-id:string (UR_GasSourceID))
            )
            (C_DeployTrueFungibleAccount gas-id client)
            (with-capability (MAKE_GAS client gas-source-amount)
            (let
                (
                    (gas-amount:decimal (UC_GasMake gas-source-amount))
                )
        ;;03]Client sends Gas-Source-id to the GAS Smart Contract; <X_MethodicTransferTrueFungible> must be used so as to not incurr GAS fees for this transfer
                (CX_TransferTrueFungible client gas-source-id client SC_NAME_GAS gas-source-amount)
        ;;04]Smart Contract burns GAS-Source-ID without generating IGNIS, without needing GAS
                (CX_Burn client gas-source-id SC_NAME_GAS gas-source-amount)
        ;;05]GAS Smart Contract mints GAS, without needing GAS (already built in within the C_Mint function)
                (CX_Mint client gas-id SC_NAME_GAS gas-amount false)
        ;;06]GAS Smart Contract transfers GAS to client
                (CX_TransferTrueFungible client gas-id SC_NAME_GAS client gas-amount)
                gas-amount
                )
            )
        )
    )
    (defun C_CompressGAS (client:string gas-amount:decimal)
        @doc "Generates Gas-Source from GAS Token via GAS Compression \
            \ GAS compression is GAS free. \
            \ Gas Source Price is set at a minimum 1$. Uses Gas Price \
            \ Input GAS amount must always be integer/whole (even though itself is of decimal type)"
        
        ;;01]Any client can perform GAS Compression. GAS compression is always GAS free
        ;;02]Deploy DPTF GAS-Source Account for client (in case no DPTF Gas-Source account exists for client)
        (let*
            (
                (gas-source-id:string (UR_GasSourceID))
                (gas-id:string (UR_GasID))
            )
            (C_DeployTrueFungibleAccount gas-source-id client)
            (with-capability (COMPRESS_GAS client gas-amount)
                (let
                    (
                        (gas-source-amount:decimal (UC_GasCompress gas-amount))
                    )
        ;;03]Client sends GAS to the GAS Smart Contract: <CX_TransferTrueFungible> can be used since no GAS costs is uncurred when transferring GAS tokens
                    (CX_TransferTrueFungible client gas-id client SC_NAME_GAS gas-amount)
        ;;04]GAS Smart Contract burns GAS: <C_Burn> can be used since burning GAS costs no GAS
                    (CX_Burn client gas-id SC_NAME_GAS gas-amount)
        ;;05]GAS Smart Contract mints Gas-Source Token: <X_Mint> must be used to mint without GAS costs
                    (CX_Mint client gas-source-id SC_NAME_GAS gas-source-amount false)
        ;;06]GAS Smart Contract transfers Gas-Source to client: <X_MethodicTransferTrueFungible> must be used so as to not incurr GAS fees for this transfer
                    (CX_TransferTrueFungible client gas-source-id SC_NAME_GAS client gas-source-amount)
                )
            )
        )
    )
    ;;                                            ;;
    ;;      VGAS: AUXILIARY FUNCTIONS             ;;
    ;;                                            ;;
    ;;==============================================
    ;;
    ;;      X_UpdateGasSourceID|X_UpdateGasSourcePrice
    ;;      X_UpdateGasID|X_UpdateGasToggle
    ;;
    (defun X_UpdateGasSourceID (identifier:string)
        @doc "Updates Gas Source ID"
        (require-capability (UPDATE_GAS-ID identifier))
        (update VGASTable VGD
            {"gassid" : identifier}
        )
    )
    (defun X_UpdateGasSourcePrice (price:decimal)
        (require-capability (OUROBOROS_ADMIN))
        (update VGASTable VGD
            {"gasspr" : price}
        )
    )
    (defun X_UpdateGasID (identifier:string)
        @doc "Updates Gas ID"
        (require-capability (UPDATE_GAS-ID identifier))
        (update VGASTable VGD
            {"vgasid" : identifier}
        )
    )
    (defun X_UpdateGasToggle (toggle:bool)
        @doc "Updates Gas Collection State"
        (require-capability (OUROBOROS_ADMIN))
        (update VGASTable VGD
            {"vgastg" : toggle}
        )
    )
    (defun X_UpdateGasPot (account:string)
        @doc "Updates Gas Pot Account"
        (require-capability (OUROBOROS_ADMIN))
        (update VGASTable VGD
            {"gaspot" : account}
        )
    )
    (defun X_UpdateGasPrice (price:decimal)
        @doc "Updates Gas Price in cents"
        (require-capability (OUROBOROS_ADMIN))
        (update VGASTable VGD
            {"gastpr" : price}
        )
    )
    (defun X_IncrementGasSpent (increment:decimal)
        (require-capability (INCREMENT_GAS-SPENT))
        (let
            (
                (current-gas-spent:decimal (UR_GasSpent))
            )
            (update VGASTable VGD
                {"gasspent" : (+ current-gas-spent increment)}
            )
        )
    )
    ;;==============================================
    ;;
    ;;      X_CollectGAS|X_CollectGasNormal|X_CollectGasSmart|X_TransferGAS
    ;;
    (defun X_CollectGAS (patron:string sender:string amount:decimal)
        @doc "Collects GAS"
        (require-capability (GAS_COLLECTION patron sender amount))
        (let
            (
                (sender-type:bool (UR_DPTS-AccountType sender))
            )
            (if (= sender-type false)
                (X_CollectGasNormal patron amount)
                (X_CollectGasSmart patron sender amount)
            )
        )
    )
    (defun X_CollectGasNormal (patron:string amount:decimal)
        @doc "Collects GAS when a normal DPTS Account is involved"
        (require-capability (GAS_COLLECTER_NORMAL patron amount))
        (X_TransferGAS patron (UR_GasPot) amount)
        (X_IncrementGasSpent amount)
    )
    (defun X_CollectGasSmart (patron:string sender:string amount:decimal)
        @doc "Collects GAS when a smart DPTS Account is involved"
        (require-capability (GAS_COLLECTER_SMART patron sender amount))
        (let*
            (
                (gas-pot:string (UR_GasPot))
                (quarter:decimal (* amount GAS_QUARTER))
                (rest:decimal (- amount quarter))                
            )
            (X_TransferGAS patron gas-pot rest)
            (X_TransferGAS patron sender quarter)
            (X_IncrementGasSpent amount)
        )
    )
    (defun X_TransferGAS (gas-sender:string gas-receiver:string gas-amount:decimal)
        @doc "Transfers GAS from sender to receiver"
        (require-capability (GAS_MOVER gas-sender gas-receiver gas-amount))
        (let
            (
                (gas-id:string (UR_GasID))
            )
            (C_DeployTrueFungibleAccount gas-id gas-receiver)
            (X_Debit gas-id gas-sender gas-amount false)
            (X_Credit gas-id gas-receiver gas-amount)
        )            
    )
)
 
(create-table DPTS-AccountTable)
(create-table DPTF-PropertiesTable)
(create-table DPTF-BalancesTable)
(create-table VGASTable)