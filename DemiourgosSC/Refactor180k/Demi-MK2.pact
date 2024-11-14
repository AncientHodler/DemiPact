(module DEMI_002 GOVERNANCE
    @doc "The OURO2 Module contains functions that are part of the OUROBOROS Submodules \
    \ which arent mandatory to exist in the main OUROBOROS module (dont need circular dependencies) \
    \ \
    \ \
    \ [MULTI] [1]MULTI Submodule \
    \ contains multi usage functions \
    \ \
    \ \
    \ [T] [2]DPTF Submodule \
    \ contains multi usage functions \
    \ \
    \ \
    \ [M] [3]DPMF Submodule \
    \ contains multi usage functions \
    \ \
    \ \
    \ [G] [4]GAS Submodule \
    \ contains client functions \
    \ \
    \ \
    \ [A] [5]ATS Submodule \
    \ contains cold and hot recovery functions \
    \ \
    \ \
    \ [V] [6]VST Submodule \
    \ contains further client vesting functions"

    (defcap GOVERNANCE ()
        (compose-capability (DEMIURGOI))
    )
    (defcap DEMIURGOI ()
        (enforce-guard DEMI_001.G_DEMIURGOI)
    )
    (defcap COMPOSE ()
        @doc "Capability used to compose multiple functions in an IF statement"
        true
    )
;;  1]CONSTANTS Definitions
    (defconst NULLTIME (time "1984-10-11T11:10:00Z"))
    (defconst ANTITIME (time "1983-08-07T11:10:00Z"))
;;  2]SCHEMAS Definitions
    ;;[T] DPTF Schemas
    (defschema DPTF|ID-Amount
        @doc "Schema for ID-Amount Pair, used in Multi DPTF Transfers"
        id:string
        amount:decimal
    )
    (defschema DPTF|Receiver-Amount
        @doc "Schema for Receiver-Amount Pair, used in Bulk DPTF Transfers"
        receiver:string
        amount:decimal
    )
    ;;[A] ATS Schemas
    
    ;;[V] VST Schemas
    (defschema VST|MetaDataSchema
        release-amount:decimal
        release-date:time
    )
;;  3]TABLES Definitions
    
    ;;
    ;;
    ;;
    ;;Multi-Modules; [1] DALOS - |DPTF|DPMF|ATS -  DPTF-DPMF Combined Submodule
    ;;
    ;;
    ;;
    (defun DPTF-DPMF-ATS|UR_FilterKeysForInfo:[string] (account-or-token-id:string table-to-query:integer mode:bool)
        @doc "Returns a List of either: \
            \       Direct-Mode(true):      <account-or-token-id> is <account> Name: \
            \                               Returns True-Fungible, Meta-Fungible IDs or ATS-Pairs held by an Accounts <account> OR \
            \       Inverse-Mode(false):    <account-or-token-id> is DPTF|DPMF|ATS-Pair Designation Name \
            \                               Returns Accounts that exists for a specific True-Fungible, Meta-Fungible or ATS-Pair \
            \       MODE Boolean is only used for proper validation, to accees the needed table, use the proper integer: \
            \ Table-to-query: \
            \ 1 (DPTF|BalanceTable), 2(DPMF|BalanceTable), 3(ATS|Ledger) "

        ;;Enforces that only integer 1 2 3 can be used as input for the <table-to-query> variable.
        (UTILITY.DALOS|UV_PositionalVariable table-to-query 3 "Table To Query can only be 1 2 or 3")
        (if (= mode true)
            (UTILITY.DALOS|UV_Account account-or-token-id)
            (with-capability (COMPOSE)
                (if (= table-to-query 1)
                    (DEMI_001.DPTF-DPMF|UVE_id account-or-token-id true)
                    (if (= table-to-query 2)
                        (DEMI_001.DPTF-DPMF|UVE_id account-or-token-id false)
                        (DEMI_001.ATS|UVE_id account-or-token-id) 
                    )
                )
            )
        )
        (let*
            (
                (keyz:[string]
                    (if (= table-to-query 1)
                        (DEMI_001.DPTF|KEYS)
                        (if (= table-to-query 2)
                            (DEMI_001.DPMF|KEYS)
                            (DEMI_001.ATS|KEYS)
                        )
                    )
                )
                (listoflists:[[string]] (map (lambda (x:string) (UTILITY.UC_SplitString UTILITY.BAR x)) keyz))
                (output:[string] (DALOS|UC_Filterid listoflists account-or-token-id))
            )
            output
        )
    )
    (defun DALOS|UC_Filterid:[string] (listoflists:[[string]] account:string)
        @doc "Helper Function needed for returning DALOS ids for Account <account>"
        (UTILITY.DALOS|UV_Account account)
        (UTILITY.DALOS|UC_Filterid listoflists account)
    )
    (defun DALOS|UP_AccountProperties (account:string)
        @doc "Prints DALOS Account <account> Properties"
        (DEMI_001.DALOS|UVE_id account)
        (let* 
            (
                (p:[bool] (DEMI_001.DALOS|UR_AccountProperties account))
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

    (defun DALOS|A_Initialise (patron:string)
        @doc "Main administrative function that initialises the DALOS Virtual Blockchain"
        (with-capability (DEMIURGOI)
            ;;Smart DALOS Account Deployment
            ;;Deploy the <Ouroboros> Smart DALOS Account
            ;;Deploy the <DalosAutostake> Smart DALOS Account
            ;;Deploy the <DalosVesting> Smart DALOS Account
            ;;Deploy the <GasTanker> Smart DALOS Account
            ;:Deploy the <Liquidizer> Smart DALOS Account
            (DEMI_001.DALOS|C_DeploySmartAccount DEMI_001.DPTF|SC_NAME (keyset-ref-guard DEMI_001.DPTF|SC_KEY) DEMI_001.DPTF|SC_KDA-NAME patron)
            (DEMI_001.DALOS|C_DeploySmartAccount DEMI_001.ATS|SC_NAME (keyset-ref-guard DEMI_001.DPTF|SC_KEY) DEMI_001.ATS|SC_KDA-NAME patron)
            (DEMI_001.DALOS|C_DeploySmartAccount DEMI_001.VST|SC_NAME (keyset-ref-guard DEMI_001.DPTF|SC_KEY) DEMI_001.VST|SC_KDA-NAME patron)
            (DEMI_001.DALOS|C_DeploySmartAccount DEMI_001.GAS|SC_NAME (keyset-ref-guard DEMI_001.DPTF|SC_KEY) DEMI_001.GAS|SC_KDA-NAME patron)
            (DEMI_001.DALOS|C_DeploySmartAccount DEMI_001.LIQUID|SC_NAME (keyset-ref-guard DEMI_001.DPTF|SC_KEY) DEMI_001.LIQUID|SC_KDA-NAME patron)

            ;;Update Smart Account Governors, possible since all of them were created with the same Guard
            (DEMI_001.DALOS|C_UpdateSmartAccountGovernor patron DEMI_001.DPTF|SC_NAME "free.DEMI_001.")
            (DEMI_001.DALOS|C_UpdateSmartAccountGovernor patron DEMI_001.ATS|SC_NAME "free.DEMI_001.")
            (DEMI_001.DALOS|C_UpdateSmartAccountGovernor patron DEMI_001.VST|SC_NAME "free.DEMI_001.")
            (DEMI_001.DALOS|C_UpdateSmartAccountGovernor patron DEMI_001.GAS|SC_NAME "free.DEMI_001.")
            (DEMI_001.DALOS|C_UpdateSmartAccountGovernor patron DEMI_001.LIQUID|SC_NAME "free.DEMI_001.")

            ;;Change Smart Account Guard with their respective Guard
            (DEMI_001.DALOS|C_RotateGuard patron DEMI_001.ATS|SC_NAME (keyset-ref-guard DEMI_001.ATS|SC_KEY) false)
            (DEMI_001.DALOS|C_RotateGuard patron DEMI_001.VST|SC_NAME (keyset-ref-guard DEMI_001.VST|SC_KEY) false)
            (DEMI_001.DALOS|C_RotateGuard patron DEMI_001.GAS|SC_NAME (keyset-ref-guard DEMI_001.GAS|SC_KEY) false)
            (DEMI_001.DALOS|C_RotateGuard patron DEMI_001.LIQUID|SC_NAME (keyset-ref-guard DEMI_001.LIQUID|SC_KEY) false)

            ;;Insert Functions for populating needed Tables with Data:
            ;;Insert Blank Info in The DALOS|PropertiesTable to be updated afterwards.
            (insert DEMI_001.DALOS|PropertiesTable DEMI_001.DALOS|INFO
                {"unity-id"                 : UTILITY.BAR
                ,"gas-source-id"            : UTILITY.BAR
                ,"gas-source-id-price"      : 0.0
                ,"gas-id"                   : UTILITY.BAR
                ,"ats-gas-source-id"        : UTILITY.BAR
                ,"elite-ats-gas-source-id"  : UTILITY.BAR
                ,"wrapped-kda-id"           : UTILITY.BAR
                ,"liquid-kda-id"            : UTILITY.BAR}
            )
             ;;Add Dalos Prices
            (insert DEMI_001.DALOS|PricesTable DEMI_001.DALOS|PRICES
                {"standard"                 : 10.0
                ,"smart"                    : 20.0
                ,"dptf"                     : 200.0
                ,"dpmf"                     : 300.0
                ,"dpsf"                     : 400.0
                ,"dpnf"                     : 500.0
                ,"blue"                     : 25.0}
            )
            ;;Set GAS|PropertiesTable
            (insert DEMI_001.GAS|PropertiesTable DEMI_001.GAS|VGD
                {"virtual-gas-tank"         : DEMI_001.GAS|SC_NAME
                ,"virtual-gas-toggle"       : false
                ,"virtual-gas-spent"        : 0.0
                ,"native-gas-toggle"        : false
                ,"native-gas-spent"         : 0.0}
            )

            ;;Main LET Function that Issues Tokens and Sets them up in the proper manner.
            ;;Returns a string list made of two parts:
            ;;  1st part is a list with the Core-True-Fungible-IDs
            ;;  2nd part is a list with the Index Names of the creted Autostake Pairs
            ;(enforce-guard (DEMI_001.DALOS|UR_AccountGuard patron))
            (let*
                (
                    (core-tf:[string]
                        (DEMI_001.DPTF|CM_Issue
                            patron
                            DEMI_001.DPTF|SC_NAME
                            ["Ouroboros" "Auryn" "EliteAuryn" "Ignis" "DalosWrappedKadena" "DalosLiquidKadena"]
                            ["OURO" "AURYN" "ELITEAURYN" "GAS" "DWK" "DLK"]
                            [24 24 24 24 24 24]
                            [true true true true true true]         ;;can change owner
                            [true true true true true true]         ;;can upgrade
                            [true true true true true true]         ;;can can-add-special-role
                            [true false false true false false]     ;;can-freeze
                            [true false false false false false]    ;;can-wipe
                            [true false false true false false]     ;;can pause
                        )
                    )
                    (OuroID:string (at 0 core-tf))
                    (AurynID:string (at 1 core-tf))
                    (EliteAurynID:string (at 2 core-tf))
                    (GasID:string (at 3 core-tf))
                    (WrappedKadenaID:string (at 4 core-tf))
                    (StakedKadenaID:string (at 5 core-tf))
                )
        ;;Update created Tables with new Data
                ;;Update DalosProperties Table with new info
                (update DEMI_001.DALOS|PropertiesTable DEMI_001.DALOS|INFO
                    { "gas-source-id"           : OuroID
                    , "gas-id"                  : GasID
                    , "ats-gas-source-id"       : AurynID
                    , "elite-ats-gas-source-id" : EliteAurynID
                    , "wrapped-kda-id"          : WrappedKadenaID
                    , "liquid-kda-id"           : StakedKadenaID
                    }
                )
        
        ;;Issue needed DPTF Accounts OURO and GAS DPTF Account for the GAS-Tanker
                (DEMI_001.DPTF-DPMF|C_DeployAccount OuroID DEMI_001.GAS|SC_NAME true)
                (DEMI_001.DPTF-DPMF|C_DeployAccount GasID DEMI_001.GAS|SC_NAME true)
                (DEMI_001.DPTF-DPMF|C_DeployAccount WrappedKadenaID DEMI_001.LIQUID|SC_NAME true)
                (DEMI_001.DPTF-DPMF|C_DeployAccount StakedKadenaID DEMI_001.LIQUID|SC_NAME true)
        ;;Set-up Auryn and Elite-Auryn
                ;(enforce-guard (DEMI_001.DALOS|UR_AccountGuard patron))
                (DEMI_001.DPTF|C_SetFee patron AurynID UTILITY.AURYN_FEE)
                (DEMI_001.DPTF|C_SetFee patron EliteAurynID UTILITY.ELITE-AURYN_FEE)
                (DEMI_001.DPTF|C_ToggleFee patron AurynID true)
                (DEMI_001.DPTF|C_ToggleFee patron EliteAurynID true)
                (DEMI_001.DPTF|C_ToggleFeeLock patron AurynID true)
                (DEMI_001.DPTF|C_ToggleFeeLock patron EliteAurynID true)
        ;;Set-up GAS Initialisation Parameters:
            ;;Setting DPTF Gas Token Special Parameters
                (DEMI_001.DPTF|C_SetMinMove patron GasID 1000.0)
                (DEMI_001.DPTF|C_SetFee patron GasID -1.0)
                (DEMI_001.DPTF|C_SetFeeTarget patron GasID DEMI_001.GAS|SC_NAME)
                (DEMI_001.DPTF|C_ToggleFee patron GasID true)
                (DEMI_001.DPTF|C_ToggleFeeLock patron GasID true)    
            ;;Set Token Roles
                (DEMI_001.DPTF-DPMF|C_ToggleBurnRole patron GasID DEMI_001.GAS|SC_NAME true true)
                (DEMI_001.DPTF|C_ToggleMintRole patron GasID DEMI_001.GAS|SC_NAME true)
                (DEMI_001.DPTF-DPMF|C_ToggleBurnRole patron OuroID DEMI_001.GAS|SC_NAME true true)
                (DEMI_001.DPTF|C_ToggleMintRole patron OuroID DEMI_001.GAS|SC_NAME true)
        ;;Set-up Kadena Liquid Staking Initialisation Parameters
            ;;Set Volumetric Fees
                (DEMI_001.DPTF|C_SetFee patron StakedKadenaID -1.0)
                (DEMI_001.DPTF|C_ToggleFee patron StakedKadenaID true)
                (DEMI_001.DPTF|C_ToggleFeeLock patron StakedKadenaID true)
            ;;Set Token Roles
                (DEMI_001.DPTF-DPMF|C_ToggleBurnRole patron WrappedKadenaID DEMI_001.LIQUID|SC_NAME true true)
                (DEMI_001.DPTF|C_ToggleMintRole patron WrappedKadenaID DEMI_001.LIQUID|SC_NAME true)
        ;;Created Vested Snake Tokens
                (DEMI_001.VST|C_CreateVestingLink patron OuroID)
                (DEMI_001.VST|C_CreateVestingLink patron AurynID)
                (DEMI_001.VST|C_CreateVestingLink patron EliteAurynID)
        ;;2nd Let Function that creates the ATS-Pairs
                (let*
                    (
                        (Auryndex:string
                            (DEMI_001.ATS|C_Issue
                                patron
                                patron
                                "Auryndex"
                                24
                                OuroID
                                true
                                AurynID
                                false
                            )
                        )
                        (Elite-Auryndex:string
                            (DEMI_001.ATS|C_Issue
                                patron
                                patron
                                "EliteAuryndex"
                                24
                                AurynID
                                true
                                EliteAurynID
                                true
                            )
                        )
                        (Kadena-Liquid-Index:string
                            (DEMI_001.ATS|C_Issue
                                patron
                                patron
                                "Kadindex"
                                24
                                WrappedKadenaID
                                false
                                StakedKadenaID
                                true
                            )
                        )
                        (core-idx:[string] [Auryndex Elite-Auryndex Kadena-Liquid-Index])
                    )
        ;;Setting Up Autostake Pairs
            ;;Set-up <Auryndex> Autostake-Pair
                    (DEMI_001.ATS|C_SetColdFee patron Auryndex
                        7
                        [50.0 100.0 200.0 350.0 550.0 800.0]
                        [
                            [8.0 7.0 6.0 5.0 4.0 3.0 2.0]
                            [9.0 8.0 7.0 6.0 5.0 4.0 3.0]
                            [10.0 9.0 8.0 7.0 6.0 5.0 4.0]
                            [11.0 10.0 9.0 8.0 7.0 6.0 5.0]
                            [12.0 11.0 10.0 9.0 8.0 7.0 6.0]
                            [13.0 12.0 11.0 10.0 9.0 8.0 7.0]
                            [14.0 13.0 12.0 11.0 10.0 9.0 8.0]
                        ]
                    )
                    (DEMI_001.ATS|C_TurnRecoveryOn patron Auryndex true)
            ;;Set-up <Elite-Auryndex> Autostake-Pair
                    (DEMI_001.ATS|C_SetColdFee patron Elite-Auryndex 7 [0.0] [[0.0]])
                    (DEMI_001.ATS|C_SetCRD patron Elite-Auryndex false 360 24)
                    (DEMI_001.ATS|C_ToggleElite patron Elite-Auryndex true)
                    (DEMI_001.ATS|C_TurnRecoveryOn patron Elite-Auryndex true)
            ;;Set <Kadena-Liquid-Index> Autostake-Pair
                    (DEMI_001.ATS|C_SetColdFee patron Kadena-Liquid-Index -1 [0.0] [[0.0]])
                    (DEMI_001.ATS|C_SetCRD patron Kadena-Liquid-Index false 12 6)
                    (DEMI_001.ATS|C_TurnRecoveryOn patron Kadena-Liquid-Index true)

            ;;Change TrueFungibles Ownership to their respective Smart DALOS Accounts
                    (DEMI_001.DPTF-DPMF|C_ChangeOwnership patron GasID DEMI_001.GAS|SC_NAME true)
                    (DEMI_001.DPTF-DPMF|C_ChangeOwnership patron WrappedKadenaID DEMI_001.LIQUID|SC_NAME true)
                    (DEMI_001.DPTF-DPMF|C_ChangeOwnership patron StakedKadenaID DEMI_001.LIQUID|SC_NAME true)
        ;;Returns a list composed of Token-IDs and ATS-Pair IDs that were created.
                    (+ core-tf core-idx)
                )
            )
        )
    )
    ;;How to set Fee for a DPTF
    ;(DEMI_001.DPTF|C_SetFee patron OuroID 150.0)
    ;(DEMI_001.DPTF|C_ToggleFee patron OuroID true)
    ;(DEMI_001.DPTF|C_ToggleFeeLock patron OuroID true)
    
    (defun DPTF-DPMF|UC_AmountCheck:bool (id:string amount:decimal token-type:bool)
        @doc "Checks if the supplied amount is valid with the decimal denomination of the id \
        \ and if the amount is greater than zero. \
        \ Does not use enforcements, If everything checks out, returns true, if not false"
        (let*
            (
                (decimals:integer (DEMI_001.DPTF-DPMF|UR_Decimals id token-type))
                (decimal-check:bool (if (= (floor amount decimals) amount) true false))
                (positivity-check:bool (if (> amount 0.0) true false))
                (result:bool (and decimal-check positivity-check))
            )
            result
        )
    )
    ;;
    ;;
    ;;
    ;;Demiourgos-Pact-True-Fungible; [2] DPTF Submodule
    ;;
    ;;
    ;;
    ;;3.2]    [T] DPTF Functions
    ;;3.2.1]  [T]   DPTF Utility Functions
    ;;3.2.1.4][T]           Composing
    (defun DPTF|UC_Pair_ID-Amount:[object{DPTF|ID-Amount}] (id-lst:[string] transfer-amount-lst:[decimal])
        @doc "Creates an ID-Amount Pair (used in a Multi DPTF Transfer)"
        (let
            (
                (id-length:integer (length id-lst))
                (amount-length:integer (length transfer-amount-lst))
            )
            (enforce (= id-length amount-length) "ID and Transfer-Amount Lists are not of equal length")
            (zip (lambda (x:string y:decimal) { "id": x, "amount": y }) id-lst transfer-amount-lst)
        )
    )
    (defun DPTF|UC_Pair_Receiver-Amount:[object{DPTF|Receiver-Amount}] (receiver-lst:[string] transfer-amount-lst:[decimal])
        @doc "Create a Receiver-Amount Pair (used in Bulk DPTF Transfer)"
        (let
            (
                (receiver-length:integer (length receiver-lst))
                (amount-length:integer (length transfer-amount-lst))
            )
            (enforce (= receiver-length amount-length) "Receiver and Transfer-Amount Lists are not of equal length")
            (zip (lambda (x:string y:decimal) { "receiver": x, "amount": y }) receiver-lst transfer-amount-lst)
        )
    )
    ;;3.2.1.5][T]           Validations
    (defun DPTF|UV_Pair_ID-Amount:bool (id-lst:[string] transfer-amount-lst:[decimal])
        @doc "Checks an ID-Amount Pair to be conform so that a Multi DPTF Transfer can properly take place"
        (fold
            (lambda
                (acc:bool item:object{DPTF|ID-Amount})
                (and acc (DPTF-DPMF|UC_AmountCheck (at "id" item) (at "amount" item) true))
            )
            true
            (DPTF|UC_Pair_ID-Amount id-lst transfer-amount-lst)
        )
    )
    (defun DPTF|UV_Pair_Receiver-Amount:bool (id:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @doc "Checks an Receiver-Amount pair to be conform with a token id for Bulk Transfer purposes"
        (DEMI_001.DPTF-DPMF|UVE_id id true)
        (and
            (fold
                (lambda
                    (acc:bool item:object{DPTF|Receiver-Amount})
                    (let*
                        (
                            (receiver-account:string (at "receiver" item))
                            (receiver-check:bool (UTILITY.DALOS|UC_AccountCheck receiver-account))
                        )
                        (and acc receiver-check)
                    )
                )
                true
                (DPTF|UC_Pair_Receiver-Amount receiver-lst transfer-amount-lst)
            )
            (fold
                (lambda
                    (acc:bool item:object{DPTF|Receiver-Amount})
                    (let*
                        (
                            (transfer-amount:decimal (at "amount" item))
                            (check:bool (DPTF-DPMF|UC_AmountCheck id transfer-amount true))
                        )
                        (and acc check)
                    )
                )
                true
                (DPTF|UC_Pair_Receiver-Amount receiver-lst transfer-amount-lst)
            )
        )
    )
    ;;3.2.3]  [T]   DPTF Client Functions
    ;;3.2.3.6][T]           Multi-(Issue and Transfer)
    ;;No Multi Issue
    (defun DPTF|C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal])
        @doc "Executes a Multi DPTF transfer using 2 lists of multiple IDs and multiple transfer amounts"
        (let
            (
                (pair-validation:bool (DPTF|UV_Pair_ID-Amount id-lst transfer-amount-lst))
            )
            (enforce (= pair-validation true) "Input Lists <id-lst>|<transfer-amount-lst> cannot make a valid pair list for Multi Transfer Processing")
            (let
                (
                    (pair:[object{DPTF|ID-Amount}] (DPTF|UC_Pair_ID-Amount id-lst transfer-amount-lst))
                )
                (map (lambda (x:object{DPTF|ID-Amount}) (DPTF|X_MultiTransferPaired patron sender receiver x)) pair)
            )
        )
    )
    (defun DPTF|C_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @doc "Executes a Bulk DPTF transfer using 2 lists of multiple Receivers and multiple transfer amounts"
        (let
            (
                (pair-validation:bool (DPTF|UV_Pair_Receiver-Amount id receiver-lst transfer-amount-lst))
            )
            (enforce (= pair-validation true) "Input Lists <receiver-lst>|<transfer-amount-lst> cannot make a valid pair list with the <id> for Bulk Transfer Processing")
            (let
                (
                    (pair:[object{DPTF|Receiver-Amount}] (DPTF|UC_Pair_Receiver-Amount receiver-lst transfer-amount-lst))
                )
                (map (lambda (x:object{DPTF|Receiver-Amount}) (DPTF|X_BulkTransferPaired patron id sender x)) pair)
            )
        )
    )
    ;;3.2.4.4][T]           Remainder-Aux
    (defun DPTF|X_MultiTransferPaired (patron:string sender:string receiver:string id-amount-pair:object{DPTF|ID-Amount})
        @doc "Helper Function needed for making a Multi DPTF Transfer possible"
        (let
            (
                (id:string (at "id" id-amount-pair))
                (amount:decimal (at "amount" id-amount-pair))
            )
            (DEMI_001.DPTF|C_Transfer patron id sender receiver amount)
        )
    )
    (defun DPTF|X_BulkTransferPaired (patron:string id:string sender:string receiver-amount-pair:object{DPTF|Receiver-Amount})
        @doc "Helper Function needed for making a Bulk DPTF Transfer possible"

        (let
            (
                (receiver:string (at "receiver" receiver-amount-pair))
                (amount:decimal (at "amount" receiver-amount-pair))
            )
            (DEMI_001.DPTF|C_Transfer patron id sender receiver amount)
        )
    )
    ;;
    ;;
    ;;
    ;;Demiourgos-Pact-MEta-Fungible; [3] DPMF Submodule
    ;;
    ;;
    ;;
    ;;4.2.2]  [M]   DPMF Client Functions
    ;;4.2.2.6][T]           Multi-(Issue)
    ;;NONE
    ;;
    ;;
    ;;
    ;;GAS; [4] GAS Submodule
    ;;
    ;;
    ;;
    ;;5.1]    [G] GAS Capabilities
    ;;5.1.2]  [G]   GAS Composed Capabilities
    ;;5.1.2.3][G]           Client Capabilities
    ;NONE           
    ;;5.2]    [G] GAS Functions
    ;;5.2.1]  [G]   GAS Utility Functions
    ;;5.2.1.3][G]           Computing
    (defun GAS|UC_Sublimate:decimal (ouro-amount:decimal)
        @doc "Computes how much GAS(Ignis) can be generated from <ouro-amount> Ouroboros"
        (enforce (>= ouro-amount 1.00) "Only amounts greater than or equal to 1.0 can be used to make gas!")
        (let
            (
                (ouro-id:string (DEMI_001.DALOS|UR_OuroborosID))
                
            )
            (DEMI_001.DPTF-DPMF|UV_Amount ouro-id ouro-amount true)
            (let*
                (
                    (ouro-price:decimal (DEMI_001.DALOS|UR_OuroborosPrice))
                    (ouro-price-used:decimal (if (<= ouro-price 1.00) 1.00 ouro-price))
                    (ignis-id:string (DEMI_001.DALOS|UR_IgnisID))
                )
                (enforce (!= ignis-id UTILITY.BAR) "Gas Token isnt properly set")
                (let*
                    (
                        (ignis-precision:integer (DEMI_001.DPTF-DPMF|UR_Decimals ignis-id true))
                        (raw-ignis-amount-per-unit:decimal (floor (* ouro-price-used 100.0) ignis-precision))
                        (raw-ignis-amount:decimal (floor (* raw-ignis-amount-per-unit ouro-amount) ignis-precision))
                        (output-ignis-amount:decimal (floor raw-ignis-amount 0))
                    )
                    output-ignis-amount
                )
            )
        )
    )
    (defun GAS|UC_Compress (ignis-amount:decimal)
        @doc "Computes how much Ouroboros can be generated from <ignis-amount> GAS(Ignis)"
        ;;Enforce only whole amounts of GAS(Ignis) are used for compression
        (enforce (= (floor ignis-amount 0) ignis-amount) "Only whole Units of GAS(Ignis) can be compressed")
        (enforce (>= ignis-amount 1.00) "Only amounts greater than or equal to 1.0 can be used to compress gas")
        (let*
            (
                (ouro-id:string (DEMI_001.DALOS|UR_OuroborosID))
                (ouro-price:decimal (DEMI_001.DALOS|UR_OuroborosPrice))
                (ouro-price-used:decimal (if (<= ouro-price 1.00) 1.00 ouro-price))
                (ignis-id:string (DEMI_001.DALOS|UR_IgnisID))
            )
            (DEMI_001.DPTF-DPMF|UV_Amount ignis-id ignis-amount true)
            (let*
                (
                    (ouro-precision:integer (DEMI_001.DPTF-DPMF|UR_Decimals ouro-id true))
                    (raw-ouro-amount:decimal (floor (/ ignis-amount (* ouro-price-used 100.0)) ouro-precision))
                    (promile-split:[decimal] (UTILITY.UC_PromilleSplit 15.0 raw-ouro-amount ouro-precision))
                    (ouro-remainder-amount:decimal (floor (at 0 promile-split) 0))
                    (ouro-fee-amount:decimal (at 1 promile-split))
                )
                [ouro-remainder-amount ouro-fee-amount]
            )
        )
    )
    ;;5.2.3]  [G]   GAS Client Functions
    (defun GAS|C_Sublimate:decimal (patron:string client:string target:string ouro-amount:decimal)
        @doc "Generates GAS(Ignis) from Ouroboros via Sublimation by <client> to <target> \
            \ This means ANY Standard DALOS Account can generate GAS(Ignis) for any other Standard DALOS Account \
            \ Smart DALOS Accounts cannot be used as <client> or <target> \
            \ Ouroboros sublimation costs no GAS(Ignis) \
            \ Ouroboros Price is set at a minimum 1$ \
            \ GAS(Ignis) is generated always in whole amounts (ex 1.0 2.0 etc) (even though itself is of decimal type) \
            \ Returns the amount of GAS(Ignis) generated"
        ;;01]<patron>, <client> and <target> must be Standard DALOS Accounts
        (DEMI_001.DALOS|Enforce_AccountType patron false)
        (DEMI_001.DALOS|Enforce_AccountType patron false)
        (DEMI_001.DALOS|Enforce_AccountType target false)
        (let*
            (
                (ignis-id:string (DEMI_001.DALOS|UR_IgnisID))
                (ouro-id:string (DEMI_001.DALOS|UR_OuroborosID))
                (ignis-target-exist:bool (DEMI_001.DPTF-DPMF|UR_AccountExist ignis-id target true))
            )
            (if (= ignis-target-exist false)
        ;;02]Deploys DPTF GAS(Ignis) Account for client
                (DEMI_001.DPTF-DPMF|C_DeployAccount ignis-id target true)
                true
            )
            (let*
                (
                    (ouro-precision:integer (DEMI_001.DPTF-DPMF|UR_Decimals ouro-id true))
                    (ouro-split:[decimal] (UTILITY.UC_PromilleSplit 10.0 ouro-amount ouro-precision))
                    (ouro-remainder-amount:decimal (at 0 ouro-split))
                    (ouro-fee-amount:decimal (at 1 ouro-split))
                    (ignis-amount:decimal (GAS|UC_Sublimate ouro-remainder-amount))
                )
        ;;03]Client sends Ouroboros <ouro-amount> to the GasTanker
                (DEMI_001.DPTF|CX_Transfer patron ouro-id client DEMI_001.GAS|SC_NAME ouro-amount)
        ;;04]GasTanker burns Ouroboros <ouro-remainder-amount>
                (DEMI_001.DPTF|CX_Burn patron ouro-id DEMI_001.GAS|SC_NAME ouro-remainder-amount)
        ;;05]GasTanker mints GAS(Ignis) <ignis-amount>
                (DEMI_001.DPTF|CX_Mint patron ignis-id DEMI_001.GAS|SC_NAME ignis-amount false)
        ;;06]GasTanker transfers GAS(Ignis) <ignis-amount> to <target>
                (DEMI_001.DPTF|CX_Transfer patron ignis-id DEMI_001.GAS|SC_NAME target ignis-amount)
        ;;07]Gas Tanker Transmutes Ouroboros <ouro-fee-amount>
                (DEMI_001.DPTF|C_Transmute patron ouro-id DEMI_001.GAS|SC_NAME ouro-fee-amount)
                ignis-amount
            )
        )
    )
    (defun GAS|C_Compress:decimal (patron:string client:string ignis-amount:decimal)
        @doc "Generates Ouroboros from GAS(Ignis) via Compression by <client> for itself \
            \ Any Standard DALOS Accounts can compress GAS(Ignis) \
            \ GAS(Ignis) compression costs no GAS(Ignis) \
            \ Ouroboros Price is set at a minimum 1$ \
            \ Can only compress whole amounts of GAS(Ignis) \
            \ Returns the amount of Ouroboros generated"
        ;;01]<patron> and <client> must be Standard DALOS Accounts
        (DEMI_001.DALOS|Enforce_AccountType patron false)
        (DEMI_001.DALOS|Enforce_AccountType client false)
        (let*
            (
                (ouro-id:string (DEMI_001.DALOS|UR_OuroborosID))
                (ignis-id:string (DEMI_001.DALOS|UR_IgnisID))
                (ouro-client-exist:bool (DEMI_001.DPTF-DPMF|UR_AccountExist ouro-id client true))
            )
            (if (= ouro-client-exist false)
        ;;02]Deploys DPTF Ouroboros Account for client
                (DEMI_001.DPTF-DPMF|C_DeployAccount ouro-id client true)
                true
            )
            (let*
                (
                    (ignis-to-ouro:[decimal] (GAS|UC_Compress ignis-amount))
                    (ouro-remainder-amount:decimal (at 0 ignis-to-ouro))
                    (ouro-fee-amount:decimal (at 1 ignis-to-ouro))
                    (total-ouro:decimal (+ ouro-remainder-amount ouro-fee-amount))
                )
    ;;03]Client sends GAS(Ignis) <ignis-amount> to the GasTanker
                (DEMI_001.DPTF|CX_Transfer patron ignis-id client DEMI_001.GAS|SC_NAME ignis-amount)
    ;;04]GasTanker burns GAS(Ignis) <ignis-amount>
                (DEMI_001.DPTF|CX_Burn patron ignis-id DEMI_001.GAS|SC_NAME ignis-amount)
    ;;05]GasTanker mints Ouroboros <total-ouro>
                (DEMI_001.DPTF|CX_Mint patron ouro-id DEMI_001.GAS|SC_NAME total-ouro false)
    ;;06]GAS Smart Contract transfers Ouroboros <ouro-remainder-amount> to <client>
                (DEMI_001.DPTF|CX_Transfer patron ouro-id DEMI_001.GAS|SC_NAME client ouro-remainder-amount)
    ;;07]Gas Tanker Transmutes Ouroboros <ouro-fee-amount>
                (DEMI_001.DPTF|C_Transmute patron ouro-id DEMI_001.GAS|SC_NAME ouro-fee-amount)
                ouro-remainder-amount
            )
        )
    )
    ;;
    ;;
    ;;
    ;;AUTOSTAKE; [5] ATS Submodule
    (defun ATS|UC_RT-Unbonding (atspair:string reward-token:string)
        @doc "Computes the Total Unbonding amount for a given <reward-token> of a given <atspair> \
        \ Result-wise identical to reading it via <DEMI_001.ATS|UR_RT-Data> option 3, except this is done by computation"
        (DEMI_001.ATS|RewardTokenExistance atspair reward-token true)
        (fold
            (lambda
                (acc:decimal account:string)
                (+ acc (DEMI_001.ATS|UC_AccountUnbondingBalance atspair account reward-token))
            )
            0.0
            (DPTF-DPMF-ATS|UR_FilterKeysForInfo atspair 3 false)
        )
    )
    ;;
    ;;
    ;;
    ;;6.1]    [A] ATS Capabilities
    ;;6.1.1]  [A]   ATS Basic Capabilities
    ;;6.1.1.1][A]           <ATS|Ledger> Table Management
    ;;NONE
    ;;6.2]    [A] ATS Functions
    ;;6.2.1]  [A]   ATS Utility Functions
    ;;6.2.1.5][A]           ATS|Ledger Info
    
    ;;6.2.1.6][A]           ATS|Ledger Computing
    ;;NONE
    ;;6.2.1.7][A]           ATS|Ledger Composing
    ;;NONE
    ;;6.2.3]  [A]   ATS Client Functions
    (defun ATS|C_CoilAndVest:decimal (patron:string coiler-vester:string atspair:string coil-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        @doc "Autostakes <coil-token> and outputs its vested counterpart when it exists, to the <target-account> \
        \ Fails if the c-rbt doesnt have an active vesting counterpart"
        ;;<Coiler-Vester> coils the <coil-token> using the <atspair>
        ;;<Coiler-Vester> vests the resulted RBT directly to <target-account>
        (let
            (
                (c-rbt:string (DEMI_001.ATS|UR_ColdRewardBearingToken atspair))
                (c-rbt-amount:decimal (DEMI_001.ATS|C_Coil patron coiler-vester atspair coil-token amount))
            )
            (VST|C_Vest patron coiler-vester target-account c-rbt c-rbt-amount offset duration milestones)
            c-rbt-amount
        )
    )
    (defun ATS|C_CurlAndVest:decimal (patron:string curler-vester:string atspair1:string atspair2:string curl-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        @doc "Autostakes <curl-token> twice and outputs its vested counterpart when it exists, to the <target-account> \
        \ Fails if the c-rbt of <atspair2> doesnt have an active vesting counterpart"
        (let
            (
                (c-rbt2:string (DEMI_001.ATS|UR_ColdRewardBearingToken atspair2))
                (c-rbt2-amount:decimal (DEMI_001.ATS|C_Curl patron curler-vester atspair1 atspair2 curl-token amount))
            )
            (VST|C_Vest patron curler-vester target-account c-rbt2 c-rbt2-amount offset duration milestones)
            c-rbt2-amount
        )
    )
    ;;6.2.3.3][A]           Destroy
    ;;NONE
    ;;6.2.4]  [A]   ATS Aux Functions
    ;;6.2.4.1][A]           ATS|Ledger Aux
    ;;NONE
    ;;
    ;;
    ;;
    ;;VESTING; [6] VST Submodule
    ;;
    ;;
    ;;
    ;;8.1]    [V] VST Capabilities
    ;;8.1.2]  [V]   VST Composed Capabilities
    (defcap VST|VEST (patron:string vester:string target-account:string id:string amount:decimal)
        (DEMI_001.VST|Existance id true true)
        (DEMI_001.VST|Active id (DEMI_001.DPTF-DPMF|UR_Vesting id true))
    )
    (defcap VST|CULL (patron:string culler:string id:string nonce:integer)
        (DEMI_001.VST|Existance id false true)
        (DEMI_001.VST|Active (DEMI_001.DPTF-DPMF|UR_Vesting id false) id)
    )
    ;;8.2]    [V] VST Functions
    ;;8.2.1]  [V]   VST Utility Functions
    ;;8.2.1.1][V]           Computing|Composing
    (defun VST|UV_HasVesting (id:string token-type:bool)
        @doc "Validates <id> as bein part of a vested token pair"
        (let
            (
                (has-vesting:bool (DEMI_001.VST|UC_HasVesting id token-type))
            )
            (enforce (= has-vesting true) (format "Token {} is not part of a vesting-pair"[id]))
        )
    )
    (defun VST|UC_SplitBalanceForVesting:[decimal] (id:string amount:decimal milestones:integer)
        @doc "Splits an Amount according to vesting parameters"
        (UTILITY.VST|UC_SplitBalanceForVesting (DEMI_001.DPTF-DPMF|UR_Decimals id true) amount milestones)
    )
    (defun VST|UC_MakeVestingDateList:[time] (offset:integer duration:integer milestones:integer)
        @doc "Makes a Times list with unvesting milestones according to vesting parameters"
        (UTILITY.VST|UC_MakeVestingDateList offset duration milestones)
    )
    (defun VST|UC_ComposeVestingMetaData:[object{VST|MetaDataSchema}] (id:string amount:decimal offset:integer duration:integer milestones:integer)
        @doc "Creates Vesting MetaData"
        (DEMI_001.DPTF-DPMF|UV_Amount id amount true)
        (UTILITY.VST|UV_MilestoneWithTime offset duration milestones)
        (let*
            (
                (amount-lst:[decimal] (VST|UC_SplitBalanceForVesting id amount milestones))
                (date-lst:[time] (VST|UC_MakeVestingDateList offset duration milestones))
                (meta-data:[object{VST|MetaDataSchema}] (zip (lambda (x:decimal y:time) { "release-amount": x, "release-date": y }) amount-lst date-lst))
            )
            meta-data
        )
    )
    (defun VST|UC_CullMetaDataAmount:decimal (client:string id:string nonce:integer)
        @doc "Returns the amount that a cull on a Vested Token would produce"
        (VST|UV_HasVesting id false)
        (let*
            (
                (meta-data:[object{VST|MetaDataSchema}] (DEMI_001.DPMF|UR_AccountBatchMetaData id nonce client))
                (culled-amount:decimal
                    (fold
                        (lambda
                            (acc:decimal item:object{VST|MetaDataSchema})
                            (let*
                                (
                                    (balance:decimal (at "release-amount" item))
                                    (date:time (at "release-date" item))
                                    (present-time:time (at "block-time" (chain-data)))
                                    (t:decimal (diff-time present-time date))
                                )
                                (if (>= t 0.0)
                                    (+ acc balance)
                                    acc
                                )
                            )
                        )
                        0.0
                        meta-data
                    )
                )
            )
            culled-amount
        )
    )
    (defun VST|UC_CullMetaDataObject:[object{VST|MetaDataSchema}] (client:string id:string nonce:integer)
        @doc "Returns the meta-data that a cull on a Vested Token would produce"
        (VST|UV_HasVesting id false)
        (let*
            (
                (meta-data:[object{VST|MetaDataSchema}] (DEMI_001.DPMF|UR_AccountBatchMetaData id nonce client))
                (culled-object:[object{VST|MetaDataSchema}]
                    (fold
                        (lambda
                            (acc:[object{VST|MetaDataSchema}] item:object{VST|MetaDataSchema})
                            (let*
                                (
                                    (date:time (at "release-date" item))
                                    (present-time:time (at "block-time" (chain-data)))
                                    (t:decimal (diff-time present-time date))
                                )
                                (if (< t 0.0)
                                    (UTILITY.UC_AppendLast acc item)
                                    acc
                                )
                            )
                        )
                        []
                        meta-data
                    )
                )
            )
            culled-object
        )
    )
    ;;8.2.3]  [V]   VST Client Functions
    (defun VST|C_Vest (patron:string vester:string target-account:string id:string amount:decimal offset:integer duration:integer milestones:integer)
        @doc "Vests <id> given input parameters to its DPMF Vesting Counterpart to <target-account>"
        (with-capability (VST|VEST  patron vester target-account id amount)
            (let*
                (
                    (dpmf-id:string (DEMI_001.DPTF-DPMF|UR_Vesting id true))
                    (meta-data:string (VST|UC_ComposeVestingMetaData id amount offset duration milestones))
                    (nonce:integer (DEMI_001.DPMF|CX_Mint patron dpmf-id DEMI_001.VST|SC_NAME amount meta-data))
                )
                (DEMI_001.DPTF|CX_Transfer patron id vester DEMI_001.VST|SC_NAME amount)
                (DEMI_001.DPMF|CX_Transfer patron dpmf-id nonce DEMI_001.VST|SC_NAME target-account amount)
            )
        )
    )
    (defun VST|C_Cull (patron:string culler:string id:string nonce:integer)
        @doc "Client Function that culls a Vested Token"
        (with-capability (VST|CULL patron culler id nonce)
            (let*
                (
                    (dptf-id:string (DEMI_001.DPTF-DPMF|UR_Vesting id false))
                    (initial-amount:decimal (DEMI_001.DPMF|UR_AccountBatchSupply id nonce culler))
                    (culled-amount:decimal (VST|UC_CullMetaDataAmount culler id nonce))
                    (return-amount:decimal (- initial-amount culled-amount))
                )
                (if (= return-amount 0.0)
                    (DEMI_001.DPTF|CX_Transfer patron dptf-id DEMI_001.VST|SC_NAME culler initial-amount)
                    (let*
                        (
                            (remaining-vesting-meta-data:[object{VST|MetaDataSchema}] (VST|UC_CullMetaDataObject culler id nonce))
                            (new-nonce:integer (DEMI_001.DPMF|CX_Mint patron id DEMI_001.VST|SC_NAME return-amount remaining-vesting-meta-data))
                        )
                        (DEMI_001.DPTF|CX_Transfer patron dptf-id DEMI_001.VST|SC_NAME culler culled-amount)
                        (DEMI_001.DPMF|CX_Transfer patron id new-nonce DEMI_001.VST|SC_NAME culler return-amount)
                    )
                )
                (DEMI_001.DPMF|CX_Transfer patron id nonce culler DEMI_001.VST|SC_NAME initial-amount)
                (DEMI_001.DPMF|CX_Burn patron id nonce DEMI_001.VST|SC_NAME initial-amount)
            )
        )
    )
)

