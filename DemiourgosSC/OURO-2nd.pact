(module OURO2 GOVERNANCE
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
        @doc "Set to false for non-upgradeability; \
            \ Remove Comment below so that only ADMIN (<free.DH_Master-Keyset>) can enact an upgrade"
        true
        ;(compose-capability (OUROBOROS.DEMIURGOI))
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
    (defschema ATS|BalanceSchema
        @doc "Schema that Stores ATS Unstake Information for ATS Pairs (True Fungibles)\
            \ Key for the Table is a string composed of: <ATS-Pair> + UTILITY.BAR + <account> \
            \ This ensure a single entry per ATS Pair per account."
        P0:[object{ATS|Unstake}]
        P1:object{ATS|Unstake}
        P2:object{ATS|Unstake}
        P3:object{ATS|Unstake}
        P4:object{ATS|Unstake}
        P5:object{ATS|Unstake}
        P6:object{ATS|Unstake}
        P7:object{ATS|Unstake}
    )
    (defschema ATS|Unstake
        reward-tokens:[decimal]
        cull-time:time
    )
    (defschema ATS|Hot
        mint-time:time
    )
    ;;[V] VST Schemas
    (defschema VST|MetaDataSchema
        release-amount:decimal
        release-date:time
    )
;;  3]TABLES Definitions
    (deftable ATS|Ledger:{ATS|BalanceSchema})
    ;;
    ;;
    ;;
    ;;Multi-Modules; [1] DALOS - |DPTF|DPMF|ATS -  DPTF-DPMF Combined Submodule
    ;;
    ;;
    ;;
    (defun DALOS|UC_Filterid:[string] (listoflists:[[string]] account:string)
        @doc "Helper Function needed for returning DALOS ids for Account <account>"
        (UTILITY.DALOS|UV_Account account)
        (UTILITY.DALOS|UC_Filterid listoflists account)
    )
    (defun DALOS|A_Initialise (patron:string)
        @doc "Main administrative function that initialises the DALOS Virtual Blockchain"
        (with-capability (OUROBOROS.DEMIURGOI)
            ;;Smart DALOS Account Deployment
            ;;Deploy the <Ouroboros> Smart DALOS Account
            ;;Deploy the <DalosAutostake> Smart DALOS Account
            ;;Deploy the <DalosVesting> Smart DALOS Account
            ;;Deploy the <GasTanker> Smart DALOS Account
            ;:Deploy the <Liquidizer> Smart DALOS Account
            (OUROBOROS.DALOS|C_DeploySmartAccount OUROBOROS.DPTF|SC_NAME (keyset-ref-guard OUROBOROS.DPTF|SC_KEY) OUROBOROS.DPTF|SC_KDA-NAME)
            (OUROBOROS.DALOS|C_DeploySmartAccount OUROBOROS.ATS|SC_NAME (keyset-ref-guard OUROBOROS.ATS|SC_KEY) OUROBOROS.ATS|SC_KDA-NAME)            
            (OUROBOROS.DALOS|C_DeploySmartAccount OUROBOROS.VST|SC_NAME (keyset-ref-guard OUROBOROS.VST|SC_KEY) OUROBOROS.VST|SC_KDA-NAME)            
            (OUROBOROS.DALOS|C_DeploySmartAccount OUROBOROS.GAS|SC_NAME (keyset-ref-guard OUROBOROS.GAS|SC_KEY) OUROBOROS.GAS|SC_KDA-NAME)            
            (OUROBOROS.DALOS|C_DeploySmartAccount OUROBOROS.LIQUID|SC_NAME (keyset-ref-guard OUROBOROS.LIQUID|SC_KEY) OUROBOROS.LIQUID|SC_KDA-NAME)

            ;;Insert Functions for populating needed Tables with Data:
            ;;Insert Blank Info in The DALOS|PropertiesTable to be updated afterwards.
            (insert OUROBOROS.DALOS|PropertiesTable OUROBOROS.DALOS|INFO
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
            (insert OUROBOROS.DALOS|PricesTable OUROBOROS.DALOS|PRICES
                {"standard"                 : 10.0
                ,"smart"                    : 20.0
                ,"dptf"                     : 200.0
                ,"dpmf"                     : 300.0
                ,"dpsf"                     : 400.0
                ,"dpnf"                     : 500.0
                ,"blue"                     : 25.0}
            )
            ;;Set GAS|PropertiesTable
            (insert OUROBOROS.GAS|PropertiesTable OUROBOROS.GAS|VGD
                {"virtual-gas-tank"         : OUROBOROS.GAS|SC_NAME
                ,"virtual-gas-toggle"       : false
                ,"virtual-gas-spent"        : 0.0
                ,"native-gas-toggle"        : false
                ,"native-gas-spent"         : 0.0}
            )

            ;;Main LET Function that Issues Tokens and Sets them up in the proper manner.
            ;;Returns a string list made of two parts:
            ;;  1st part is a list with the Core-True-Fungible-IDs
            ;;  2nd part is a list with the Index Names of the creted Autostake Pairs
            (enforce-guard (OUROBOROS.DALOS|UR_AccountGuard patron))
            (let*
                (
                    (core-tf:[string]
                        (DPTF|CM_Issue
                            patron
                            OUROBOROS.DPTF|SC_NAME
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
                (update OUROBOROS.DALOS|PropertiesTable OUROBOROS.DALOS|INFO
                    { "gas-source-id"           : OuroID
                    , "ats-gas-source-id"       : AurynID
                    , "elite-ats-gas-source-id" : EliteAurynID
                    , "wrapped-kda-id"          : WrappedKadenaID
                    , "liquid-kda-id"           : StakedKadenaID
                    }
                )
            ;;Update Gas ID
                (update OUROBOROS.DALOS|PropertiesTable OUROBOROS.DALOS|INFO
                    { "gas-id" : GasID }
                )
        ;;Issue needed DPTF Accounts OURO and GAS DPTF Account for the GAS-Tanker
                (OUROBOROS.DPTF-DPMF|C_DeployAccount OuroID OUROBOROS.GAS|SC_NAME true)
                (OUROBOROS.DPTF-DPMF|C_DeployAccount GasID OUROBOROS.GAS|SC_NAME true)
                (OUROBOROS.DPTF-DPMF|C_DeployAccount WrappedKadenaID OUROBOROS.LIQUID|SC_NAME true)
                (OUROBOROS.DPTF-DPMF|C_DeployAccount StakedKadenaID OUROBOROS.LIQUID|SC_NAME true)
        ;;Set-up Auryn and Elite-Auryn
                (enforce-guard (OUROBOROS.DALOS|UR_AccountGuard patron))
                (OUROBOROS.DPTF|C_SetFee patron AurynID UTILITY.AURYN_FEE)
                (OUROBOROS.DPTF|C_SetFee patron EliteAurynID UTILITY.ELITE-AURYN_FEE)
                (OUROBOROS.DPTF|C_ToggleFee patron AurynID true)
                (OUROBOROS.DPTF|C_ToggleFee patron EliteAurynID true)
                (OUROBOROS.DPTF|C_ToggleFeeLock patron AurynID true)
                (OUROBOROS.DPTF|C_ToggleFeeLock patron EliteAurynID true)
        ;;Set-up GAS Initialisation Parameters:
            ;;Setting DPTF Gas Token Special Parameters
                (OUROBOROS.DPTF|C_SetMinMove patron GasID 1000.0)
                (OUROBOROS.DPTF|C_SetFee patron GasID -1.0)
                (OUROBOROS.DPTF|C_SetFeeTarget patron GasID OUROBOROS.GAS|SC_NAME)
                (OUROBOROS.DPTF|C_ToggleFee patron GasID true)
                (OUROBOROS.DPTF|C_ToggleFeeLock patron GasID true)    
            ;;Set Token Roles
                (OUROBOROS.DPTF-DPMF|C_ToggleBurnRole patron GasID OUROBOROS.GAS|SC_NAME true true)
                (OUROBOROS.DPTF|C_ToggleMintRole patron GasID OUROBOROS.GAS|SC_NAME true)
                (OUROBOROS.DPTF-DPMF|C_ToggleBurnRole patron OuroID OUROBOROS.GAS|SC_NAME true true)
                (OUROBOROS.DPTF|C_ToggleMintRole patron OuroID OUROBOROS.GAS|SC_NAME true)
        ;;Set-up Kadena Liquid Staking Initialisation Parameters
            ;;Set Volumetric Fees
                (OUROBOROS.DPTF|C_SetFee patron StakedKadenaID -1.0)
                (OUROBOROS.DPTF|C_ToggleFee patron StakedKadenaID true)
                (OUROBOROS.DPTF|C_ToggleFeeLock patron StakedKadenaID true)
            ;;Set Token Roles
                (OUROBOROS.DPTF-DPMF|C_ToggleBurnRole patron WrappedKadenaID OUROBOROS.LIQUID|SC_NAME true true)
                (OUROBOROS.DPTF|C_ToggleMintRole patron WrappedKadenaID OUROBOROS.LIQUID|SC_NAME true)
        ;;Created Vested Snake Tokens
                (OUROBOROS.VST|C_CreateVestingLink patron OuroID)
                (OUROBOROS.VST|C_CreateVestingLink patron AurynID)
                (OUROBOROS.VST|C_CreateVestingLink patron EliteAurynID)
        ;;2nd Let Function that creates the ATS-Pairs
                (let*
                    (
                        (Auryndex:string
                            (OUROBOROS.ATS|C_Issue
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
                            (OUROBOROS.ATS|C_Issue
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
                            (OUROBOROS.ATS|C_Issue
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
                    (OUROBOROS.ATS|C_SetColdFee patron Auryndex
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
                    (OUROBOROS.ATS|C_TurnRecoveryOn patron Auryndex true)
            ;;Set-up <Elite-Auryndex> Autostake-Pair
                    (OUROBOROS.ATS|C_SetColdFee patron Elite-Auryndex 7 [0.0] [[0.0]])
                    (OUROBOROS.ATS|C_SetCRD patron Elite-Auryndex false 360 24)
                    (OUROBOROS.ATS|C_ToggleElite patron Elite-Auryndex true)
                    (OUROBOROS.ATS|C_TurnRecoveryOn patron Elite-Auryndex true)
            ;;Set <Kadena-Liquid-Index> Autostake-Pair
                    (OUROBOROS.ATS|C_SetColdFee patron Kadena-Liquid-Index -1 [0.0] [[0.0]])
                    (OUROBOROS.ATS|C_SetCRD patron Kadena-Liquid-Index false 12 6)
                    (OUROBOROS.ATS|C_TurnRecoveryOn patron Kadena-Liquid-Index true)

            ;;Change TrueFungibles Ownership to their respective Smart DALOS Accounts
                    (OUROBOROS.DPTF-DPMF|C_ChangeOwnership patron GasID OUROBOROS.GAS|SC_NAME true)
                    (OUROBOROS.DPTF-DPMF|C_ChangeOwnership patron WrappedKadenaID OUROBOROS.LIQUID|SC_NAME true)
                    (OUROBOROS.DPTF-DPMF|C_ChangeOwnership patron StakedKadenaID OUROBOROS.LIQUID|SC_NAME true)
        ;;Returns a list composed of Token-IDs and ATS-Pair IDs that were created.
                    (+ core-tf core-idx)
                )
            )
        )
    )
    ;;How to set Fee for a DPTF
    ;(OUROBOROS.DPTF|C_SetFee patron OuroID 150.0)
    ;(OUROBOROS.DPTF|C_ToggleFee patron OuroID true)
    ;(OUROBOROS.DPTF|C_ToggleFeeLock patron OuroID true)
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
                    (OUROBOROS.DPTF-DPMF|UVE_id account-or-token-id true)
                    (if (= table-to-query 2)
                        (OUROBOROS.DPTF-DPMF|UVE_id account-or-token-id false)
                        (OUROBOROS.ATS|UVE_id account-or-token-id) 
                    )
                )
            )
        )
        (let*
            (
                (keyz:[string]
                    (if (= table-to-query 1)
                        (keys OUROBOROS.DPTF|BalanceTable)
                        (if (= table-to-query 2)
                            (keys OUROBOROS.DPMF|BalanceTable)
                            (keys ATS|Ledger)
                        )
                    )
                )
                (listoflists:[[string]] (map (lambda (x:string) (UTILITY.UC_SplitString UTILITY.BAR x)) keyz))
                (output:[string] (DALOS|UC_Filterid listoflists account-or-token-id))
            )
            output
        )
    )
    (defun DPTF-DPMF|UC_AmountCheck:bool (id:string amount:decimal token-type:bool)
        @doc "Checks if the supplied amount is valid with the decimal denomination of the id \
        \ and if the amount is greater than zero. \
        \ Does not use enforcements, If everything checks out, returns true, if not false"
        (let*
            (
                (decimals:integer (OUROBOROS.DPTF-DPMF|UR_Decimals id token-type))
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
        (OUROBOROS.DPTF-DPMF|UVE_id id true)
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
    (defun DPTF|CM_Issue:[string]
        (
            patron:string
            account:string
            name:[string]
            ticker:[string]
            decimals:[integer]
            can-change-owner:[bool]
            can-upgrade:[bool]
            can-add-special-role:[bool]
            can-freeze:[bool]
            can-wipe:[bool]
            can-pause:[bool]
        )
        @doc "Issues Multiple DPTF Tokens at once"
        
        (let*
            (
                (l1:integer (length name))
                (l2:integer (length ticker))
                (l3:integer (length decimals))
                (l4:integer (length can-change-owner))
                (l5:integer (length can-upgrade))
                (l6:integer (length can-add-special-role))
                (l7:integer (length can-freeze))
                (l8:integer (length can-wipe))
                (l9:integer (length can-pause))
                (lengths:[integer] [l1 l2 l3 l4 l5 l6 l7 l8 l9])
                (tf-cost:decimal (OUROBOROS.DALOS|UR_True))
                (gas-costs:decimal (* (dec l1) UTILITY.GAS_ISSUE))
                (kda-costs:decimal (* (dec l1) tf-cost))
            )
            (UTILITY.UV_EnforceUniformIntegerList lengths)
            ;;(install-capability (OUROBOROS.DPTF-DPMF|ISSUE patron OUROBOROS.DPTF|SC_NAME true 6))
            (with-capability (OUROBOROS.DPTF-DPMF|ISSUE patron account true l1)
                (if (not (OUROBOROS.GAS|UC_SubZero))
                    (OUROBOROS.GAS|X_Collect patron account gas-costs)
                    true
                )
                (if (not (OUROBOROS.GAS|UC_NativeSubZero))
                    (OUROBOROS.GAS|X_CollectDalosFuel patron kda-costs)
                    true
                )
                (fold
                    (lambda
                        (acc:[string] index:integer)
                        (let
                            (
                                (id:string
                                    (OUROBOROS.DPTF|X_Issue 
                                        l1 
                                        patron 
                                        account 
                                        (at index name)
                                        (at index ticker)
                                        (at index decimals)
                                        (at index can-change-owner)
                                        (at index can-upgrade)
                                        (at index can-add-special-role)
                                        (at index can-freeze)
                                        (at index can-wipe) 
                                        (at index can-pause)
                                    )
                                )
                            )
                            (OUROBOROS.DALOS|X_IncrementNonce patron)
                            (UTILITY.UC_AppendLast acc id)
                        )
                    )
                    []
                    (enumerate 0 (- (length name) 1))
                )
            )
        )
    )
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
            (OUROBOROS.DPTF|C_Transfer patron id sender receiver amount)
        )
    )
    (defun DPTF|X_BulkTransferPaired (patron:string id:string sender:string receiver-amount-pair:object{DPTF|Receiver-Amount})
        @doc "Helper Function needed for making a Bulk DPTF Transfer possible"

        (let
            (
                (receiver:string (at "receiver" receiver-amount-pair))
                (amount:decimal (at "amount" receiver-amount-pair))
            )
            (OUROBOROS.DPTF|C_Transfer patron id sender receiver amount)
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
    (defun DPMF|CM_Issue:[string]
        (
            patron:string
            account:string
            name:[string]
            ticker:[string]
            decimals:[integer]
            can-change-owner:[bool]
            can-upgrade:[bool]
            can-add-special-role:[bool]
            can-freeze:[bool]
            can-wipe:[bool]
            can-pause:[bool]
            can-transfer-nft-create-role:[bool]
        )
        @doc "Issues Multiple DPTF Tokens at once"
        (let*
            (
                (l1:integer (length name))
                (l2:integer (length ticker))
                (l3:integer (length decimals))
                (l4:integer (length can-change-owner))
                (l5:integer (length can-upgrade))
                (l6:integer (length can-add-special-role))
                (l7:integer (length can-freeze))
                (l8:integer (length can-wipe))
                (l9:integer (length can-pause))
                (l0:integer (length can-transfer-nft-create-role))
                (lengths:[integer] [l1 l2 l3 l4 l5 l6 l7 l8 l9 l0])
                (tf-cost:decimal (OUROBOROS.DALOS|UR_Meta))
                (gas-costs:decimal (* (dec l1) UTILITY.GAS_ISSUE))
                (kda-costs:decimal (* (dec l1) tf-cost))
            )
            (UTILITY.UV_EnforceUniformIntegerList lengths)
            (with-capability (OUROBOROS.DPTF-DPMF|ISSUE patron account false l1)
                (if (not (OUROBOROS.GAS|UC_SubZero))
                    (OUROBOROS.GAS|X_Collect patron account gas-costs)
                    true
                )
                (if (not (OUROBOROS.GAS|UC_NativeSubZero))
                    (OUROBOROS.GAS|X_CollectDalosFuel patron kda-costs)
                    true
                )
                (fold
                    (lambda
                        (acc:[string] index:integer)
                        (let
                            (
                                (id:string
                                    (OUROBOROS.DPMF|X_Issue 
                                        l1 
                                        patron 
                                        account 
                                        (at index name)
                                        (at index ticker)
                                        (at index decimals)
                                        (at index can-change-owner)
                                        (at index can-upgrade)
                                        (at index can-add-special-role)
                                        (at index can-freeze)
                                        (at index can-wipe) 
                                        (at index can-pause)
                                        (at index can-transfer-nft-create-role)
                                    )
                                )
                            )
                            (OUROBOROS.DALOS|X_IncrementNonce patron)
                            (UTILITY.UC_AppendLast acc id)
                        )
                    )
                    []
                    (enumerate 0 (- (length name) 1))
                )
            )
        )
    )
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
    (defcap GAS|SUBLIMATE (patron:string client:string target:string ouro-amount:decimal)
        @doc "Capability required to produce GAS"
        (let*
            (
                (ouro-id:string (OUROBOROS.DALOS|UR_OuroborosID))
                (ignis-id:string (OUROBOROS.DALOS|UR_IgnisID))
                (ouro-precision:integer (OUROBOROS.DPTF-DPMF|UR_Decimals ouro-id true))
                (ouro-split:[decimal] (UTILITY.UC_PromilleSplit 10.0 ouro-amount ouro-precision))
                (ouro-remainder-amount:decimal (at 0 ouro-split))
                (ouro-fee-amount:decimal (at 1 ouro-split))
                (ignis-amount:decimal (GAS|UC_Sublimate ouro-remainder-amount))
            )
        ;;01]<patron>, <client> and <target> must be Standard DALOS Accounts
            (compose-capability (OUROBOROS.DALOS|IZ_ACCOUNT_SMART patron false))
            (compose-capability (OUROBOROS.DALOS|IZ_ACCOUNT_SMART client false))
            (compose-capability (OUROBOROS.DALOS|IZ_ACCOUNT_SMART target false))
        ;;02]Deploys DPTF GAS(Ignis) Account for client
            (compose-capability (OUROBOROS.DALOS|ACCOUNT_OWNER client))
        ;;03]Client sends Ouroboros <ouro-amount> to the GasTanker
            (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron ouro-id client OUROBOROS.GAS|SC_NAME ouro-amount true true))
        ;;04]GasTanker burns Ouroboros <ouro-remainder-amount>
            (compose-capability (OUROBOROS.DPTF-DPMF|BURN patron ouro-id OUROBOROS.GAS|SC_NAME ouro-remainder-amount true true))
        ;;05]GasTanker mints GAS(Ignis) <ignis-amount>
            (compose-capability (OUROBOROS.DPTF|MINT patron ignis-id OUROBOROS.GAS|SC_NAME ignis-amount false true))
        ;;06]GasTanker transfers GAS(Ignis) <ignis-amount> to <target>
            (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron ignis-id OUROBOROS.GAS|SC_NAME target ignis-amount true true))
        ;;07]Gas Tanker Transmutes Ouroboros <ouro-fee-amount>
            (compose-capability (OUROBOROS.DPTF|TRANSMUTE ouro-id OUROBOROS.GAS|SC_NAME))
        )
    )
    (defcap GAS|COMPRESS (patron:string client:string ignis-amount:decimal)
        @doc "Capability required to compress GAS"
        ;;Enforce only whole amounts of GAS are used for compression
        (enforce (= (floor ignis-amount 0) ignis-amount) "Only whole Units of Gas can be compressed")
        (let*
            (
                (ignis-id:string (OUROBOROS.DALOS|UR_IgnisID))
                (ouro-id:string (OUROBOROS.DALOS|UR_OuroborosID))
                (ignis-to-ouro:[decimal] (GAS|UC_Compress ignis-amount))
                (ouro-remainder-amount:decimal (at 0 ignis-to-ouro))
                (ouro-fee-amount:decimal (at 1 ignis-to-ouro))
                (total-ouro:decimal (+ ouro-remainder-amount ouro-fee-amount))
            )
        ;;01]<patron> and <client> must be Standard DALOS Accounts
            (compose-capability (OUROBOROS.DALOS|IZ_ACCOUNT_SMART patron false))
            (compose-capability (OUROBOROS.DALOS|IZ_ACCOUNT_SMART client false))
        ;;02]Deploys DPTF Ouroboros Account for client
            (compose-capability (OUROBOROS.DALOS|ACCOUNT_OWNER client))
        ;;03]Client sends GAS(Ignis) <ignis-amount> to the GasTanker
            (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron ignis-id client OUROBOROS.GAS|SC_NAME ignis-amount true true))
        ;;04]GasTanker burns GAS(Ignis) <ignis-amount>
            (compose-capability (OUROBOROS.DPTF-DPMF|BURN patron ignis-id OUROBOROS.GAS|SC_NAME ignis-amount true true))
        ;;05]GasTanker mints Ouroboros <total-ouro>
            (compose-capability (OUROBOROS.DPTF|MINT patron ouro-id OUROBOROS.GAS|SC_NAME total-ouro false true))
        ;;06]GAS Smart Contract transfers Ouroboros <ouro-remainder-amount> to <client>
            (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron ouro-id OUROBOROS.GAS|SC_NAME client ouro-remainder-amount true true))
        ;;07]Gas Tanker Transmutes Ouroboros <ouro-fee-amount>
            (compose-capability (OUROBOROS.DPTF|TRANSMUTE ouro-id OUROBOROS.GAS|SC_NAME))
        )
    )
    ;;5.2]    [G] GAS Functions
    ;;5.2.1]  [G]   GAS Utility Functions
    ;;5.2.1.3][G]           Computing
    (defun GAS|UC_Sublimate:decimal (ouro-amount:decimal)
        @doc "Computes how much GAS(Ignis) can be generated from <ouro-amount> Ouroboros"
        (enforce (>= ouro-amount 1.00) "Only amounts greater than or equal to 1.0 can be used to make gas!")
        (let
            (
                (ouro-id:string (OUROBOROS.DALOS|UR_OuroborosID))
                
            )
            (OUROBOROS.DPTF-DPMF|UV_Amount ouro-id ouro-amount true)
            (let*
                (
                    (ouro-price:decimal (OUROBOROS.DALOS|UR_OuroborosPrice))
                    (ouro-price-used:decimal (if (<= ouro-price 1.00) 1.00 ouro-price))
                    (ignis-id:string (OUROBOROS.DALOS|UR_IgnisID))
                )
                (enforce (!= ignis-id UTILITY.BAR) "Gas Token isnt properly set")
                (let*
                    (
                        (ignis-precision:integer (OUROBOROS.DPTF-DPMF|UR_Decimals ignis-id true))
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
                (ouro-id:string (OUROBOROS.DALOS|UR_OuroborosID))
                (ouro-price:decimal (OUROBOROS.DALOS|UR_OuroborosPrice))
                (ouro-price-used:decimal (if (<= ouro-price 1.00) 1.00 ouro-price))
                (ignis-id:string (OUROBOROS.DALOS|UR_IgnisID))
            )
            (OUROBOROS.DPTF-DPMF|UV_Amount ignis-id ignis-amount true)
            (let*
                (
                    (ouro-precision:integer (OUROBOROS.DPTF-DPMF|UR_Decimals ouro-id true))
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
        (let*
            (
                (ignis-id:string (OUROBOROS.DALOS|UR_IgnisID))
                (ouro-id:string (OUROBOROS.DALOS|UR_OuroborosID))
                (ignis-target-exist:bool (OUROBOROS.DPTF-DPMF|UR_AccountExist ignis-id target true))
            )
            (if (= ignis-target-exist false)
        ;;02]Deploys DPTF GAS(Ignis) Account for client
                (OUROBOROS.DPTF-DPMF|C_DeployAccount ignis-id target true)
                true
            )
            (with-capability (GAS|SUBLIMATE patron client target ouro-amount)
            (let*
                (
                    (ouro-precision:integer (OUROBOROS.DPTF-DPMF|UR_Decimals ouro-id true))
                    (ouro-split:[decimal] (UTILITY.UC_PromilleSplit 10.0 ouro-amount ouro-precision))
                    (ouro-remainder-amount:decimal (at 0 ouro-split))
                    (ouro-fee-amount:decimal (at 1 ouro-split))
                    (ignis-amount:decimal (GAS|UC_Sublimate ouro-remainder-amount))
                )
        ;;03]Client sends Ouroboros <ouro-amount> to the GasTanker
                (OUROBOROS.DPTF|CX_Transfer patron ouro-id client OUROBOROS.GAS|SC_NAME ouro-amount)
        ;;04]GasTanker burns Ouroboros <ouro-remainder-amount>
                (OUROBOROS.DPTF|CX_Burn patron ouro-id OUROBOROS.GAS|SC_NAME ouro-remainder-amount)
        ;;05]GasTanker mints GAS(Ignis) <ignis-amount>
                (OUROBOROS.DPTF|CX_Mint patron ignis-id OUROBOROS.GAS|SC_NAME ignis-amount false)
        ;;06]GasTanker transfers GAS(Ignis) <ignis-amount> to <target>
                (OUROBOROS.DPTF|CX_Transfer patron ignis-id OUROBOROS.GAS|SC_NAME target ignis-amount)
        ;;07]Gas Tanker Transmutes Ouroboros <ouro-fee-amount>
                (OUROBOROS.DPTF|X_Transmute ouro-id OUROBOROS.GAS|SC_NAME ouro-fee-amount)
                ignis-amount
                )
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
        (let*
            (
                (ouro-id:string (OUROBOROS.DALOS|UR_OuroborosID))
                (ignis-id:string (OUROBOROS.DALOS|UR_IgnisID))
                (ouro-client-exist:bool (OUROBOROS.DPTF-DPMF|UR_AccountExist ouro-id client true))
            )
            (if (= ouro-client-exist false)
        ;;02]Deploys DPTF Ouroboros Account for client
                (OUROBOROS.DPTF-DPMF|C_DeployAccount ouro-id client true)
                true
            )
            (with-capability (GAS|COMPRESS patron client ignis-amount)
                (let*
                    (
                        (ignis-to-ouro:[decimal] (GAS|UC_Compress ignis-amount))
                        (ouro-remainder-amount:decimal (at 0 ignis-to-ouro))
                        (ouro-fee-amount:decimal (at 1 ignis-to-ouro))
                        (total-ouro:decimal (+ ouro-remainder-amount ouro-fee-amount))
                    )
        ;;03]Client sends GAS(Ignis) <ignis-amount> to the GasTanker
                    (OUROBOROS.DPTF|CX_Transfer patron ignis-id client OUROBOROS.GAS|SC_NAME ignis-amount)
        ;;04]GasTanker burns GAS(Ignis) <ignis-amount>
                    (OUROBOROS.DPTF|CX_Burn patron ignis-id OUROBOROS.GAS|SC_NAME ignis-amount)
        ;;05]GasTanker mints Ouroboros <total-ouro>
                    (OUROBOROS.DPTF|CX_Mint patron ouro-id OUROBOROS.GAS|SC_NAME total-ouro false)
        ;;06]GAS Smart Contract transfers Ouroboros <ouro-remainder-amount> to <client>
                    (OUROBOROS.DPTF|CX_Transfer patron ouro-id OUROBOROS.GAS|SC_NAME client ouro-remainder-amount)
        ;;07]Gas Tanker Transmutes Ouroboros <ouro-fee-amount>
                    (OUROBOROS.DPTF|X_Transmute ouro-id OUROBOROS.GAS|SC_NAME ouro-fee-amount)
                    ouro-remainder-amount
                )
            )
        )
    )
    ;;
    ;;
    ;;
    ;;AUTOSTAKE; [5] ATS Submodule
    ;;
    ;;
    ;;
    ;;6.1]    [A] ATS Capabilities
    ;;6.1.1]  [A]   ATS Basic Capabilities
    ;;6.1.1.1][A]           <ATS|Ledger> Table Management
    (defcap ATS|HOT_RECOVERY (patron:string recoverer:string atspair:string ra:decimal)
        @doc "Capability required to execute cold or hot recovery"
        (compose-capability (OUROBOROS.ATS|EXIST atspair))
        (let
            (
                (c-rbt:string (OUROBOROS.ATS|UR_ColdRewardBearingToken atspair))
                (h-rbt:string (OUROBOROS.ATS|UR_HotRewardBearingToken atspair))
            )
            (compose-capability (OUROBOROS.DALOS|ACCOUNT_OWNER recoverer))
            (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron c-rbt recoverer OUROBOROS.ATS|SC_NAME ra true true))
            (compose-capability (OUROBOROS.DPTF-DPMF|BURN patron c-rbt OUROBOROS.ATS|SC_NAME ra true true))
            (compose-capability (OUROBOROS.DPMF|MINT patron h-rbt OUROBOROS.ATS|SC_NAME ra true))
            (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron h-rbt OUROBOROS.ATS|SC_NAME recoverer ra true false))
            (compose-capability (OUROBOROS.ATS|RECOVERY_STATE atspair true false))
        )
    )
    (defcap ATS|COLD_RECOVERY (patron:string recoverer:string atspair:string ra:decimal)
        (compose-capability (OUROBOROS.ATS|EXIST atspair))
        (let
            (
                (c-rbt:string (OUROBOROS.ATS|UR_ColdRewardBearingToken atspair))
            )
            (compose-capability (OUROBOROS.DALOS|ACCOUNT_OWNER recoverer))
            (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron c-rbt recoverer OUROBOROS.ATS|SC_NAME ra true true))
            (compose-capability (OUROBOROS.DPTF-DPMF|BURN patron c-rbt OUROBOROS.ATS|SC_NAME ra true true))
            (compose-capability (OUROBOROS.ATS|UPDATE_ROU))
            (compose-capability (ATS|UPDATE_LEDGER))
            (compose-capability (ATS|DEPLOY atspair recoverer))
            (compose-capability (OUROBOROS.ATS|RECOVERY_STATE atspair true true))
        )
    )
    (defcap ATS|DEPLOY (atspair:string account:string)
        (compose-capability (OUROBOROS.ATS|EXIST atspair))
        (compose-capability (OUROBOROS.DALOS|EXIST account))
        (compose-capability (ATS|NORMALIZE_LEDGER atspair account))
    )
    (defcap ATS|NORMALIZE_LEDGER (atspair:string account:string)
        @doc "Capability needed to normalize an ATS|Ledger Account \
        \ Normalizing an ATS|Ledger Account updates it it according to the <atspair> <c-positions> and <c-elite-mode> parameters \
        \ Existing entries are left as they are"
        (compose-capability (OUROBOROS.ATS|EXIST atspair))
        (enforce-one
            "Keyset not valid for KadenaLiquidStaking Smart DALOS Account Operations"
            [
                (enforce-guard (keyset-ref-guard OUROBOROS.DALOS|DEMIURGOI))
                (enforce-guard (OUROBOROS.DALOS|UR_AccountGuard account))
            ]
        )
    )
    (defcap ATS|CULL (culler:string atspair:string)
        (compose-capability (OUROBOROS.ATS|EXIST atspair))
        (compose-capability (OUROBOROS.DALOS|ACCOUNT_OWNER culler))
        (compose-capability (OUROBOROS.ATS|UPDATE_ROU))
        (compose-capability (ATS|NORMALIZE_LEDGER atspair culler))
        (compose-capability (ATS|UPDATE_LEDGER))
    )
    (defcap ATS|UPDATE_LEDGER ()
        @doc "Cap required to update entries in the ATS|Ledger"
        true
    )
    ;;6.2]    [A] ATS Functions
    ;;6.2.1]  [A]   ATS Utility Functions
    ;;6.2.1.5][A]           ATS|Ledger Info
    (defun ATS|UP_P0 (atspair:string account:string)
        (format "{}|{} P0: {}" [atspair account (ATS|UR_P0 atspair account)])
    )
    (defun ATS|UP_P1 (atspair:string account:string)
        (format "{}|{} P1: {}" [atspair account (ATS|UR_P1-7 atspair account 1)])
    )
    (defun ATS|UP_P2 (atspair:string account:string)
        (format "{}|{} P2: {}" [atspair account (ATS|UR_P1-7 atspair account 2)])
    )
    (defun ATS|UP_P3 (atspair:string account:string)
        (format "{}|{} P3: {}" [atspair account (ATS|UR_P1-7 atspair account 3)])
    )
    (defun ATS|UP_P4 (atspair:string account:string)
        (format "{}|{} P4: {}" [atspair account (ATS|UR_P1-7 atspair account 4)])
    )
    (defun ATS|UP_P5 (atspair:string account:string)
        (format "{}|{} P5: {}" [atspair account (ATS|UR_P1-7 atspair account 5)])
    )
    (defun ATS|UP_P6 (atspair:string account:string)
        (format "{}|{} P6: {}" [atspair account (ATS|UR_P1-7 atspair account 6)])
    )
    (defun ATS|UP_P7 (atspair:string account:string)
        (format "{}|{} P7: {}" [atspair account (ATS|UR_P1-7 atspair account 7)])
    )
    (defun ATS|UR_P0:[object{ATS|Unstake}] (atspair:string account:string)
        @doc "Returns the <P0> of an ATS-UnstakingAccount"
        (UTILITY.DALOS|UV_UniqueAccount atspair)
        (UTILITY.DALOS|UV_Account account)
        (at "P0" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P0"]))
    )
    (defun ATS|UC_IzCullable:bool (input:object{ATS|Unstake})
        @doc "Computes if Unstake Object is cullable"
        (let*
            (
                (present-time:time (at "block-time" (chain-data)))
                (stored-time:time (at "cull-time" input))
                (diff:decimal (diff-time present-time stored-time))
            )
            (if (>= diff 0.0)
                true
                false
            )
        )
    )
    (defun ATS|UC_CullValue:[decimal] (input:object{ATS|Unstake})
        @doc "Returns the value of a cull object."
        (let*
            (
                (rt-amounts:[decimal] (at "reward-tokens" input))
                (l:integer (length rt-amounts))
                (iz:bool (ATS|UC_IzCullable input))
            )
            (if iz
                rt-amounts
                (make-list l 0.0)
            )
        )
    )
    (defun ATS|UR_P1-7:object{ATS|Unstake} (atspair:string account:string position:integer)
        @doc "Returns the <P1> through <P7> of an ATS-UnstakingAccount"
        (UTILITY.DALOS|UV_UniqueAccount atspair)
        (UTILITY.DALOS|UV_Account account)
        (UTILITY.DALOS|UV_PositionalVariable position 7 "Invalid Position Number")
        (cond
            ((= position 1) (at "P1" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P1"])))
            ((= position 2) (at "P2" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P2"])))
            ((= position 3) (at "P3" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P3"])))
            ((= position 4) (at "P4" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P4"])))
            ((= position 5) (at "P5" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P5"])))
            ((= position 6) (at "P6" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P6"])))
            ((= position 7) (at "P7" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P7"])))
            true
        )
    )
    (defun ATS|URX_UnstakeObjectUnbondingValue (atspair:string reward-token:string io:object{ATS|Unstake})
        @doc "Special Helper Function needed for <ATS|UC_AccountUnbondingBalance>"
        (let*
            (
                (rtp:integer (OUROBOROS.ATS|UC_RewardTokenPosition atspair reward-token))
                (rt:[decimal] (at "reward-tokens" io))
                (rb:decimal (at rtp rt))
            )
            (if (= rb -1.0)
                0.0
                rb
            )
        )
    )
    (defun ATS|UC_AccountUnbondingBalance (atspair:string account:string reward-token:string)
        @doc "Returns by computation the Total Unbonding value tied to an ATS-UnstakeAccount (defined with <atspair> and <account>) \
            \ for a given Reward-Token (which is a Reward-Token of the given <atspair>)"
        (+
            (fold
                (lambda
                    (acc:decimal item:object{ATS|Unstake})
                    (+ acc (ATS|URX_UnstakeObjectUnbondingValue atspair reward-token item))
                )
                0.0
                (ATS|UR_P0 atspair account)
            )
            (fold
                (lambda
                    (acc:decimal item:integer)
                    (+ acc (ATS|URX_UnstakeObjectUnbondingValue atspair reward-token (ATS|UR_P1-7 atspair account item)))
                )
                0.0
                (enumerate 1 7)
            )
        )
    )
    (defun ATS|UC_RT-Unbonding (atspair:string reward-token:string)
        @doc "Computes the Total Unbonding amount for a given <reward-token> of a given <atspair> \
        \ Result-wise identical to reading it via <OUROBOROS.ATS|UR_RT-Data> option 3, except this is done by computation"
        (with-capability (OUROBOROS.ATS|RT_EXISTANCE atspair reward-token true)
            (fold
                (lambda
                    (acc:decimal account:string)
                    (+ acc (ATS|UC_AccountUnbondingBalance atspair account reward-token))
                )
                0.0
                (DPTF-DPMF-ATS|UR_FilterKeysForInfo atspair 3 false)
            )
        )
    )
    (defun ATS|UR_RtPrecisions:[integer] (atspair:string)
        @doc "Returns a list of integers representing precisions of RBT Tokens of <atspair>"
        (fold
            (lambda
                (acc:[integer] rt:string)
                (UTILITY.UC_AppendLast acc (OUROBOROS.DPTF-DPMF|UR_Decimals rt true))
            )
            []
            (OUROBOROS.ATS|UR_RewardTokenList atspair)
        )
    )
    ;;6.2.1.6][A]           ATS|Ledger Computing
    (defun ATS|UC_WhichPosition:integer (atspair:string c-rbt-amount:decimal account:string)
        @doc "Computes which position can be used for Cold Recovery, given input parameters. \
        \ Returning 0 means no position is available for cold recovery"
        (let
            (
                (elite:bool (OUROBOROS.ATS|UR_EliteMode atspair))
            )
            (if elite
                (ATS|UC_ElitePosition atspair c-rbt-amount account)
                (ATS|UC_NonElitePosition atspair account)
            )
        )
    )
    (defun ATS|UC_ElitePosition:integer (atspair:string c-rbt-amount:decimal account:string)
        @doc "Computes which position can be used for cold recovery when <c-elite-mode> is true"
        (let
            (
                (positions:integer (OUROBOROS.ATS|UR_ColdRecoveryPositions atspair))
                (c-rbt:string (OUROBOROS.ATS|UR_ColdRewardBearingToken atspair))
                (ea-id:string (OUROBOROS.DALOS|UR_EliteAurynID))
            )
            (if (!= ea-id UTILITY.BAR)
                ;elite auryn is defind
                (let*
                    (
                        (iz-ea-id:bool (if (= ea-id c-rbt) true false))
                        (pstate:[integer] (ATS|UC_PSL atspair account))
                        (met:integer (OUROBOROS.DALOS|UR_Elite-Tier-Major account))
                        (ea-supply:decimal (OUROBOROS.DPTF-DPMF|UR_AccountSupply ea-id account true))
                        (t-ea-supply:decimal (OUROBOROS.DALOS|UR_EliteAurynzSupply account))
                        (virtual-met:integer (str-to-int (take 1 (at "tier" (UTILITY.ATS|UC_Elite (- t-ea-supply c-rbt-amount))))))
                        (available:[integer] (if iz-ea-id (take virtual-met pstate) (take met pstate)))
                        (search-res:[integer] (UTILITY.UC_Search available 1))
                    )
                    (if iz-ea-id
                        (enforce (<= c-rbt-amount ea-supply) "Amount of EA used for Cold Recovery cannot be greater than what exists on Account")
                        true
                    )
                    (if (= (length search-res) 0)
                        0
                        (+ (at 0 search-res) 1)
                    )
                )
                ;elite-auryn is not defined
                (ATS|UC_NonElitePosition atspair account)
            )
        )
    )
    (defun ATS|UC_NonElitePosition:integer (atspair:string account:string)
        @doc "Computes which position can be used for cold recovery when <c-elite-mode> is false"
        (let
            (
                (positions:integer (OUROBOROS.ATS|UR_ColdRecoveryPositions atspair))
            )
            (if (= positions -1)
                -1
                (let*
                    (
                        (pstate:[integer] (ATS|UC_PSL atspair account))
                        (available:[integer] (take positions pstate))
                        (search-res:[integer] (UTILITY.UC_Search available 1))
                    )
                    (if (= (length search-res) 0)
                        0
                        (+ (at 0 search-res) 1)
                    )
                )
            )
        )
    )
    (defun ATS|UC_PSL:[integer] (atspair:string account:string)
        @doc "Creates a list of position states"
        (let
            (
                (p1s:integer (ATS|UC_PositionState atspair account 1))
                (p2s:integer (ATS|UC_PositionState atspair account 2))
                (p3s:integer (ATS|UC_PositionState atspair account 3))
                (p4s:integer (ATS|UC_PositionState atspair account 4))
                (p5s:integer (ATS|UC_PositionState atspair account 5))
                (p6s:integer (ATS|UC_PositionState atspair account 6))
                (p7s:integer (ATS|UC_PositionState atspair account 7))
            )
            [p1s p2s p3s p4s p5s p6s p7s]
        )
    )
    (defun ATS|UC_PositionState:integer (atspair:string account:string position:integer)
        @doc "Computes position state"
        (UTILITY.DALOS|UV_PositionalVariable position 7 "Input Position out of bounds")
        (with-read ATS|Ledger (concat [atspair UTILITY.BAR account])
            { "P1"  := p1 , "P2"  := p2 , "P3"  := p3, "P4"  := p4, "P5"  := p5, "P6"  := p6, "P7"  := p7 }
            (let
                (
                    (ps1:integer (ATS|UC_PositionalObjectState atspair p1))
                    (ps2:integer (ATS|UC_PositionalObjectState atspair p2))
                    (ps3:integer (ATS|UC_PositionalObjectState atspair p3))
                    (ps4:integer (ATS|UC_PositionalObjectState atspair p4))
                    (ps5:integer (ATS|UC_PositionalObjectState atspair p5))
                    (ps6:integer (ATS|UC_PositionalObjectState atspair p6))
                    (ps7:integer (ATS|UC_PositionalObjectState atspair p7))
                )
                (cond
                    ((= position 1) ps1)
                    ((= position 2) ps2)
                    ((= position 3) ps3)
                    ((= position 4) ps4)
                    ((= position 5) ps5)
                    ((= position 6) ps6)
                    ps7
                )
            )
        )
    )
    (defun ATS|UC_PositionalObjectState:integer (atspair:string input-obj:object{ATS|Unstake})
        @doc "Checks cold recovery position object state: \
        \ occupied(0), opened(1), closed (-1)"
        (let
            (
                (zero:object{ATS|Unstake} (ATS|UC_MakeZeroUnstakeObject atspair))
                (negative:object{ATS|Unstake} (ATS|UC_MakeNegativeUnstakeObject atspair))
            )
            (if (= input-obj zero)
                1
                (if (= input-obj negative)
                    -1
                    0
                )
            )
        )
    )
    (defun ATS|UC_ColdRecoveryFee (atspair:string c-rbt-amount:decimal input-position:integer)
        @doc "Computes the Cold Recovery fee of an <atspair>, given an input <c-rbt-amount> of Cold-Reward-Bearing-Token \
        \ and an input position <input-position> on which the cold recovery takes place."
        (let*
            (
                (ats-positions:integer (OUROBOROS.ATS|UR_ColdRecoveryPositions atspair))
                (ats-limit-values:[decimal] (OUROBOROS.ATS|UR_ColdRecoveryFeeThresholds atspair))
                (ats-limits:integer (length ats-limit-values))
                (ats-fee-array:[[decimal]] (OUROBOROS.ATS|UR_ColdRecoveryFeeTable atspair))
                (ats-fee-array-length:integer (length ats-fee-array))
                (ats-fee-array-length-length:integer (length (at 0 ats-fee-array)))
                (zc1:bool (if (= ats-limits 1) true false))
                (zc2:bool (if (= (at 0 ats-limit-values) 0.0) true false))
                (zc3:bool (and zc1 zc2))
                (zc4:bool (if (= ats-fee-array-length 1) true false))
                (zc5:bool (if (= ats-fee-array-length-length 1) true false))
                (zc6:bool (and zc4 zc5))
                (zc7:bool (if (= (at 0 (at 0 ats-fee-array)) 0.0) true false))
                (zc8:bool (and zc6 zc7))
                (zc9:bool (and zc3 zc8))
            )
            (enforce (<= input-position ats-positions) "Input position out of bounds")
            (if zc9
                0.0
                (let
                    (
                        (limit:integer
                            (fold
                                (lambda
                                    (acc:integer tv:decimal)
                                    (if (< c-rbt-amount tv)
                                        acc
                                        (+ acc 1)
                                    )
                                )
                                0
                                ats-limit-values
                            )
                        )
                        (qlst:[decimal] 
                            (if (= input-position -1)
                                (at 0 ats-fee-array)
                                (at (- input-position 1) ats-fee-array)
                            )
                        )
                    )
                    (at limit qlst)
                )
            )
        )
    )
    (defun ATS|UC_CullColdRecoveryTime:time (atspair:string account:string)
        @doc "Computes the Cull Time for the <atspair> and <account> \
        \ The Cull Time is the unavoidable time that must elapse in order to complete a Cold Recovery in any ATS-Pair \
        \ The Cull Time depends on ATS-Pair parameters, and DALOS Elite Account Tier"
        (let*
            (
                (minor:integer (OUROBOROS.DALOS|UR_Elite-Tier-Minor account))
                (major:integer (OUROBOROS.DALOS|UR_Elite-Tier-Major account))
                (mtier:integer (* minor major))
                (crd:[integer] (OUROBOROS.ATS|UR_ColdRecoveryDuration atspair))
                (h:integer (at mtier crd))
                (present-time:time (at "block-time" (chain-data)))
            )
            (add-time present-time (hours h))
        )
    )
    (defun ATS|UC_RTSplitAmounts:[decimal] (atspair:string rbt-amount:decimal)
        @doc "Splits a RBT value, the <rbt-amount>, using following inputs: \
            \ Reward-Bearing-Token supply <rbt-supply> of an <atspair> (read below) \
            \ The <index> of the <atspair> (read below) \
            \ A list <resident-amounts> respresenting amounts of resident Reward-Tokens of the <atpsair> \
            \ A list <rt-precision-lst> representing the precision of these Reward-Tokens \
            \ \
            \ Resulting a decimal list of Reward-Token Values coresponding to the input <rbt-amount> \
            \ The Actual computation takes place in the UTILITY Module in the <UC_SplitByIndexedRBT> Function"
        (let
            (
                (rbt-supply:decimal (OUROBOROS.ATS|UC_PairRBTSupply atspair))
                (index:decimal (OUROBOROS.ATS|UC_Index atspair))
                (resident-amounts:[decimal] (OUROBOROS.ATS|UR_RoUAmountList atspair true))
                (rt-precision-lst:[integer] (ATS|UR_RtPrecisions atspair))
            )
            (enforce (<= rbt-amount rbt-supply) "Cannot compute for amounts greater than the pairs rbt supply")
            (UTILITY.UC_SplitByIndexedRBT rbt-amount rbt-supply index resident-amounts rt-precision-lst)
        )
    )
    ;;6.2.1.7][A]           ATS|Ledger Composing
    (defun ATS|UC_MakeUnstakeObject:object{ATS|Unstake} (atspair:string time:time)
        @doc "Creates an unstake object"
        { "reward-tokens"   : (make-list (length (OUROBOROS.ATS|UR_RewardTokenList atspair)) 0.0)
        , "cull-time"       : time}
    )
    (defun ATS|UC_MakeZeroUnstakeObject:object{ATS|Unstake} (atspair:string)
        @doc "Generates an Empty Unstake Object. Empty means position is opened for use"
        (ATS|UC_MakeUnstakeObject atspair NULLTIME)
    )
    (defun ATS|UC_MakeNegativeUnstakeObject:object{ATS|Unstake} (atspair:string)
        @doc "Generates a Nmpty Unstake Object. Negative means position is closed and cannot be used for unstaking"
        (ATS|UC_MakeUnstakeObject atspair ANTITIME)
    )
    ;;6.2.3]  [A]   ATS Client Functions
    (defun ATS|C_CoilAndVest:decimal (patron:string coiler-vester:string atspair:string coil-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        @doc "Autostakes <coil-token> and outputs its vested counterpart when it exists, to the <target-account>"
        (with-capability (OUROBOROS.ATS|COIL_NO-RETURN patron coiler-vester atspair coil-token amount)
            (let
                (
                    (c-rbt:string (OUROBOROS.ATS|UR_ColdRewardBearingToken atspair))
                    (c-rbt-amount:decimal (OUROBOROS.ATS|UC_RBT atspair coil-token amount))
                )
                (OUROBOROS.DPTF|CX_Transfer patron coil-token coiler-vester OUROBOROS.ATS|SC_NAME amount)
                (OUROBOROS.ATS|X_UpdateRoU atspair coil-token true true amount)
                (OUROBOROS.DPTF|CX_Mint patron c-rbt OUROBOROS.ATS|SC_NAME c-rbt-amount false)
                (VST|C_Vest patron OUROBOROS.ATS|SC_NAME target-account c-rbt c-rbt-amount offset duration milestones)
                c-rbt-amount
            )
        )
    )
    (defun ATS|C_HotRecovery (patron:string recoverer:string atspair:string ra:decimal)
        @doc "Executes Hot Recovery for <ats-pair> by <recoverer> with the <ra> amount of Cold-Reward-Bearing-Token"
        (with-capability (ATS|HOT_RECOVERY patron recoverer atspair ra)
            (let*
                (
                    (c-rbt:string (OUROBOROS.ATS|UR_ColdRewardBearingToken atspair))
                    (h-rbt:string (OUROBOROS.ATS|UR_HotRewardBearingToken atspair))
                    (present-time:time (at "block-time" (chain-data)))
                    (meta-data-obj:object{ATS|Hot} { "mint-time" : present-time})
                    (meta-data:[object] [meta-data-obj])
                    (new-nonce:integer (+ (OUROBOROS.DPMF|UR_NoncesUsed h-rbt) 1))
                )
            ;;1]Recoverer transfers c-rbt to the ATS|SC_NAME
                (OUROBOROS.DPTF|CX_Transfer patron c-rbt recoverer OUROBOROS.ATS|SC_NAME ra)
            ;;2]ATS|SC_NAME burns c-rbt
                (OUROBOROS.DPTF|CX_Burn patron c-rbt OUROBOROS.ATS|SC_NAME ra)
            ;;3]ATS|SC_NAME mints h-rbt
                (OUROBOROS.DPMF|CX_Mint patron h-rbt OUROBOROS.ATS|SC_NAME ra meta-data)
            ;;4]ATS|SC_NAME transfers h-rbt to recoverer
                (OUROBOROS.DPMF|CX_Transfer patron h-rbt new-nonce OUROBOROS.ATS|SC_NAME recoverer ra)
            )
        )
    )
    (defun ATS|C_ColdRecovery (patron:string recoverer:string atspair:string ra:decimal)
        @doc "Executes Cold Recovery for <ats-pair> by <recoverer> with the <ra> amount of Cold-Reward-Bearing-Token"
        (with-capability (ATS|COLD_RECOVERY patron recoverer atspair ra)
            (ATS|X_DeployAccount atspair recoverer)
            (let*
                (
                    (rt-lst:[string] (OUROBOROS.ATS|UR_RewardTokenList atspair))
                    (c-rbt:string (OUROBOROS.ATS|UR_ColdRewardBearingToken atspair))
                    (c-rbt-precision:integer (OUROBOROS.DPTF-DPMF|UR_Decimals c-rbt true))
                    (usable-position:integer (ATS|UC_WhichPosition atspair ra recoverer))
                    (fee-promile:decimal (ATS|UC_ColdRecoveryFee atspair ra usable-position))
                    (c-rbt-fee-split:[decimal] (UTILITY.UC_PromilleSplit fee-promile ra c-rbt-precision))
                    (c-fr:bool (OUROBOROS.ATS|UR_ColdRecoveryFeeRedirection atspair))
                    (cull-time:time (ATS|UC_CullColdRecoveryTime atspair recoverer))

                    ;;for false
                    (standard-split:[decimal] (ATS|UC_RTSplitAmounts atspair ra))
                    (rt-precision-lst:[integer] (ATS|UR_RtPrecisions atspair))
                    (negative-c-fr:[[decimal]] (UTILITY.UC_ListPromileSplit fee-promile standard-split rt-precision-lst))

                    ;;for true
                    (positive-c-fr:[decimal] (ATS|UC_RTSplitAmounts atspair (at 0 c-rbt-fee-split)))

                )
            ;;1]Recoverer transfers c-rbt to the ATS|SC_NAME
                (OUROBOROS.DPTF|CX_Transfer patron c-rbt recoverer OUROBOROS.ATS|SC_NAME ra)
            ;;2]ATS|SC_NAME burns c-rbt and handles c-fr
                (OUROBOROS.DPTF|CX_Burn patron c-rbt OUROBOROS.ATS|SC_NAME ra)
            ;;3]ATS|Pairs is updated with the proper information (unbonding RTs), while burning any fee RTs if needed
                (if c-fr
                    (map
                        (lambda
                            (index:integer)
                            (OUROBOROS.ATS|X_UpdateRoU atspair (at index rt-lst) false true (at index positive-c-fr))
                            (OUROBOROS.ATS|X_UpdateRoU atspair (at index rt-lst) true false (at index positive-c-fr))
                        )
                        (enumerate 0 (- (length rt-lst) 1))
                    )
                    (with-capability (COMPOSE)
                        (map
                            (lambda
                                (index:integer)
                                (OUROBOROS.ATS|X_UpdateRoU atspair (at index rt-lst) false true (at index (at 0 negative-c-fr)))
                                (OUROBOROS.ATS|X_UpdateRoU atspair (at index rt-lst) true false (at index (at 0 negative-c-fr)))
                            )
                            (enumerate 0 (- (length rt-lst) 1))
                        )
                        (map
                            (lambda
                                (index:integer)
                                (with-capability (OUROBOROS.DPTF-DPMF|BURN patron (at index rt-lst) OUROBOROS.ATS|SC_NAME (at index (at 1 negative-c-fr)) true true)
                                    (OUROBOROS.DPTF|CX_Burn patron (at index rt-lst) OUROBOROS.ATS|SC_NAME (at index (at 1 negative-c-fr)))
                                )
                            )
                            (enumerate 0 (- (length rt-lst) 1))
                        )
                    )
                )
            ;;4]ATS|Ledger is updated with the proper information
                (if c-fr
                    (ATS|X_StoreUnstakeObject atspair recoverer usable-position 
                        { "reward-tokens"   : positive-c-fr 
                        , "cull-time"       : cull-time}
                    )
                    (ATS|X_StoreUnstakeObject atspair recoverer usable-position 
                        { "reward-tokens"   : (at 0 negative-c-fr) 
                        , "cull-time"       : cull-time}
                    )
                )
            )
            (ATS|X_Normalize atspair recoverer)
        )
    )
    (defun ATS|C_Cull:[decimal] (patron:string culler:string atspair:string)
        @doc "Culls <atspair> for <culler>. Culling returns all elapsed past Cold-Recoveries executed by <culler> \
        \ Returns culled values. If no cullable values exists, returns a list o zeros, since nothing has been culled"
        (with-capability (ATS|CULL culler atspair)
            (let*
                (
                    (rt-lst:[string] (OUROBOROS.ATS|UR_RewardTokenList atspair))
                    (c0:[decimal] (ATS|X_MultiCull atspair culler))
                    (c1:[decimal] (ATS|X_SingleCull atspair culler 1))
                    (c2:[decimal] (ATS|X_SingleCull atspair culler 2))
                    (c3:[decimal] (ATS|X_SingleCull atspair culler 3))
                    (c4:[decimal] (ATS|X_SingleCull atspair culler 4))
                    (c5:[decimal] (ATS|X_SingleCull atspair culler 5))
                    (c6:[decimal] (ATS|X_SingleCull atspair culler 6))
                    (c7:[decimal] (ATS|X_SingleCull atspair culler 7))
                    (ca:[[decimal]] [c0 c1 c2 c3 c4 c5 c6 c7])
                    (cw:[decimal] (UTILITY.UC_AddArray ca))
                )
                (map
                    (lambda
                        (idx:integer)
                        (if (!= (at idx cw) 0.0)
                            (with-capability (COMPOSE)
                                (OUROBOROS.ATS|X_UpdateRoU atspair (at idx rt-lst) false false (at idx cw))
                                (with-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron (at idx rt-lst) OUROBOROS.ATS|SC_NAME culler (at idx cw) true true)
                                    (OUROBOROS.DPTF|CX_Transfer patron (at idx rt-lst) OUROBOROS.ATS|SC_NAME culler (at idx cw))
                                )
                            )
                            true
                        )
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
                (ATS|X_Normalize atspair culler)
                cw
            )
        )
    )
    ;;6.2.3.3][A]           Destroy
    ;;NEEDS FINALISATION
    (defun ATS|C_RemoveSecondary (patron:string atspair:string reward-token:string)
        @doc "Removes a secondary Reward from its ATS Pair"
        (with-capability (OUROBOROS.ATS|REMOVE_SECONDARY patron atspair reward-token)
            (if (not (OUROBOROS.GAS|UC_SubZero))
                (OUROBOROS.GAS|X_Collect patron (OUROBOROS.ATS|UR_OwnerKonto atspair) UTILITY.GAS_ISSUE)
                true
            )
            (OUROBOROS.ATS|X_RemoveSecondary atspair reward-token)
            (OUROBOROS.DALOS|X_IncrementNonce patron)
            (OUROBOROS.DPTF|X_UpdateRewardToken atspair reward-token false)
            ;;Unbonding if it exists for pair, must be returned to users
            ;;Resident, if it exists, must be replaced with primary.
        )
    )
    ;;6.2.4]  [A]   ATS Aux Functions
    ;;6.2.4.1][A]           ATS|Ledger Aux
    (defun ATS|X_StoreUnstakeObjectList (atspair:string account:string obj:[object{ATS|Unstake}])
        @doc "Stores a new Unstake Object on Position -1 for <atspair> and <account> \
        \ Always assumes ATS-Unstake Account defined by <atspair>|<account> exists "
        (require-capability (ATS|UPDATE_LEDGER))
        (update ATS|Ledger (concat [atspair UTILITY.BAR account])
            { "P0" : obj}
        )
    )
    (defun ATS|X_StoreUnstakeObject (atspair:string account:string position:integer obj:object{ATS|Unstake})
        @doc "Updates entry in the ATS|Ledger with <obj> on <position> for <atspair> and <account> \
        \ Always assumes ATS-Unstake Account defined by <atspair>|<account> exists \
        \ For Position -1 it appends the object. \
        \ For Position 1 to 7, it simply replaces the object"
        (require-capability (ATS|UPDATE_LEDGER))
        (with-read ATS|Ledger (concat [atspair UTILITY.BAR account])
            { "P0"  := p0 , "P1"  := p1 , "P2"  := p2 , "P3"  := p3, "P4"  := p4, "P5"  := p5, "P6"  := p6, "P7"  := p7 }
            (if (= position -1)
                (if (and 
                        (= (length p0) 1)
                        (= 
                            (at 0 p0) 
                            (ATS|UC_MakeZeroUnstakeObject atspair)
                        )
                    )
                    (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                        { "P0"  : [obj]}
                    )
                    (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                        { "P0"  : (UTILITY.UC_AppendLast p0 obj)}
                    )
                )
                (if (= position 1)
                    (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                        { "P1"  : obj}
                    )
                    (if (= position 2)
                        (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                            { "P2"  : obj}
                        )
                        (if (= position 3)
                            (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                { "P3"  : obj}
                            )
                            (if (= position 4)
                                (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                    { "P4"  : obj}
                                )
                                (if (= position 5)
                                    (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                        { "P5"  : obj}
                                    )
                                    (if (= position 6)
                                        (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                            { "P6"  : obj}
                                        )
                                        (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                            { "P7"  : obj}
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    (defun ATS|X_DeployAccount (atspair:string account:string)
        @doc "Deploys an ATS|Ledger (Unstaking) Account for <atspair> and <account> and normalizes it"
        (require-capability (ATS|DEPLOY atspair account))
        (let
            (
                (zero:object{ATS|Unstake} (ATS|UC_MakeZeroUnstakeObject atspair))
                (negative:object{ATS|Unstake} (ATS|UC_MakeNegativeUnstakeObject atspair))
            )
            (with-default-read ATS|Ledger (concat [atspair UTILITY.BAR account])
                { "P0"  : [zero]
                , "P1"  : negative
                , "P2"  : negative
                , "P3"  : negative
                , "P4"  : negative
                , "P5"  : negative
                , "P6"  : negative
                , "P7"  : negative
                }
                { "P0"  := p0
                , "P1"  := p1
                , "P2"  := p2
                , "P3"  := p3
                , "P4"  := p4
                , "P5"  := p5
                , "P6"  := p6
                , "P7"  := p7
                }
                (write ATS|Ledger (concat [atspair UTILITY.BAR account])
                    { "P0"  : p0
                    , "P1"  : p1
                    , "P2"  : p2
                    , "P3"  : p3
                    , "P4"  : p4
                    , "P5"  : p5
                    , "P6"  : p6
                    , "P7"  : p7
                    }
                )
            )
        )
        (ATS|X_Normalize atspair account)
    )
    (defun ATS|X_Normalize (atspair:string account:string)
        @doc "Normalize an existing ATS-UnstakeAccount \
        \ Normalizing means updating the unstaking positions according to existing <atspair> parameters"
        (require-capability (ATS|NORMALIZE_LEDGER atspair account))
        (with-read ATS|Ledger (concat [atspair UTILITY.BAR account])
            { "P0"  := p0 , "P1"  := p1 , "P2"  := p2 , "P3"  := p3, "P4"  := p4, "P5"  := p5, "P6"  := p6, "P7"  := p7 }
            (let
                (
                    (zero:object{ATS|Unstake} (ATS|UC_MakeZeroUnstakeObject atspair))
                    (negative:object{ATS|Unstake} (ATS|UC_MakeNegativeUnstakeObject atspair))
                    (positions:integer (OUROBOROS.ATS|UR_ColdRecoveryPositions atspair))
                    (elite:bool (OUROBOROS.ATS|UR_EliteMode atspair))
                    (major-tier:integer (OUROBOROS.DALOS|UR_Elite-Tier-Major account))
                )
                (if (= positions -1)
                    (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                        {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [zero] )
                        ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 negative)
                        ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 negative)
                        ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 negative)
                        ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 negative)
                        ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 negative)
                        ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                        ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                        }
                    )
                    (if (= positions 1)
                        (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                            {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                            ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                            ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 negative)
                            ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 negative)
                            ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 negative)
                            ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 negative)
                            ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                            ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                            }
                        )
                        (if (= positions 2)
                            (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 negative)
                                ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 negative)
                                ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 negative)
                                ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                                ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                                }
                            )
                            (if (= positions 3)
                                (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                    {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                    ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                    ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                    ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 zero)
                                    ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 negative)
                                    ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 negative)
                                    ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                                    ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                                    }
                                )
                                (if (= positions 4)
                                    (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                        {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                        ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                        ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                        ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 zero)
                                        ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 zero)
                                        ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 negative)
                                        ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                                        ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                                        }
                                    )
                                    (if (= positions 5)
                                        (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                            {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                            ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                            ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                            ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 zero)
                                            ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 zero)
                                            ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 zero)
                                            ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                                            ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                                            }
                                        )
                                        (if (= positions 6)
                                            (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                                {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                                ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                                ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                                ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 zero)
                                                ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 zero)
                                                ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 zero)
                                                ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 zero)
                                                ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                                                }
                                            )
                                            (if (not elite)
                                                (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                                    {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                                    ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                                    ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                                    ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 zero)
                                                    ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 zero)
                                                    ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 zero)
                                                    ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 zero)
                                                    ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 zero)
                                                    }
                                                )
                                                (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                                    {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                                    ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                                    ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 (if (>= major-tier 2) zero negative))
                                                    ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 (if (>= major-tier 3) zero negative))
                                                    ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 (if (>= major-tier 4) zero negative))
                                                    ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 (if (>= major-tier 5) zero negative))
                                                    ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 (if (>= major-tier 6) zero negative))
                                                    ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 (if (>= major-tier 7) zero negative))
                                                    }
                                                )
                                            ) 
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            ) 
        )
    )
    (defun ATS|X_SingleCull:[decimal] (atspair:string account:string position:integer)
        @doc "Culls a single ATS Position, returning the culled amounts"
        (let*
            (
                (zero:object{ATS|Unstake} (ATS|UC_MakeZeroUnstakeObject atspair))
                (unstake-obj:object{ATS|Unstake} (ATS|UR_P1-7 atspair account position))
                (rt-amounts:[decimal] (at "reward-tokens" unstake-obj))
                (l:integer (length rt-amounts))
                (empty:[decimal] (make-list l 0.0))
                (cull-output:[decimal] (ATS|UC_CullValue unstake-obj))
            )
            (if (!= cull-output empty)
                (ATS|X_StoreUnstakeObject atspair account position zero)
                true
            )
            cull-output
        )
    )
    (defun ATS|X_MultiCull:[decimal] (atspair:string account:string)
        @doc "Culls the -1 ATS Position for <atspair> and <account>"
        (let*
            (
                (zero:object{ATS|Unstake} (ATS|UC_MakeZeroUnstakeObject atspair))
                (negative:object{ATS|Unstake} (ATS|UC_MakeNegativeUnstakeObject atspair))
                (p0:[object{ATS|Unstake}] (ATS|UR_P0 atspair account))
                (p0l:integer (length p0))
                (bl:[bool]
                    (fold
                        (lambda
                            (acc:[bool] item:object{ATS|Unstake})
                            (UTILITY.UC_AppendLast acc (ATS|UC_IzCullable item))
                        )
                        []
                        p0
                    )
                )
                (zero-output:[decimal] (make-list (length (OUROBOROS.ATS|UR_RewardTokenList atspair)) 0.0))
                (cullables:[integer] (UTILITY.UC_Search bl true))
                (immutables:[integer] (UTILITY.UC_Search bl false))
                (how-many-cullables:integer (length cullables))
            )
            (if (= how-many-cullables 0)
                zero-output
                (let*
                    (
                        (after-cull:[object{ATS|Unstake}]
                            (if (< how-many-cullables p0l)
                                (fold
                                    (lambda
                                        (acc:[object{ATS|Unstake}] idx:integer)
                                        (UTILITY.UC_AppendLast acc (at (at idx immutables) p0))
                                    )
                                    []
                                    (enumerate 0 (- (length immutables) 1))
                                )
                                [zero]
                            )
                        )
                        (to-be-culled:[object{ATS|Unstake}]
                            (fold
                                (lambda
                                    (acc:[object{ATS|Unstake}] idx:integer)
                                    (UTILITY.UC_AppendLast acc (at (at idx cullables) p0))
                                )
                                []
                                (enumerate 0 (- (length cullables) 1))
                            )
                        )
                        (culled-values:[[decimal]]
                            (fold
                                (lambda
                                    (acc:[[decimal]] idx:integer)
                                    (UTILITY.UC_AppendLast acc (ATS|UC_CullValue (at idx to-be-culled)))
                                )
                                []
                                (enumerate 0 (- (length to-be-culled) 1))
                            )
                        )
                        (summed-culled-values:[decimal] (UTILITY.UC_AddArray culled-values))
                    )
                    (ATS|X_StoreUnstakeObjectList atspair account after-cull)
                    summed-culled-values
                )
            )
        )
    )
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
        (compose-capability (OUROBOROS.VST|EXISTANCE id true true))
        (compose-capability (OUROBOROS.VST|ACTIVE id (OUROBOROS.DPTF-DPMF|UR_Vesting id true)))
        (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron id vester OUROBOROS.VST|SC_NAME amount true true))
        (compose-capability (OUROBOROS.DPMF|MINT patron (OUROBOROS.DPTF-DPMF|UR_Vesting id true) OUROBOROS.VST|SC_NAME amount true))
        (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron (OUROBOROS.DPTF-DPMF|UR_Vesting id true) OUROBOROS.VST|SC_NAME target-account amount true false))
    )
    (defcap VST|CULL (patron:string culler:string id:string nonce:integer)
        (compose-capability (OUROBOROS.VST|EXISTANCE id false true))
        (compose-capability (OUROBOROS.VST|ACTIVE (OUROBOROS.DPTF-DPMF|UR_Vesting id false) id))
        (let*
            (
                (dptf-id:string (OUROBOROS.DPTF-DPMF|UR_Vesting id false))
                (initial-amount:decimal (OUROBOROS.DPMF|UR_AccountBatchSupply id nonce culler))
                (culled-amount:decimal (VST|UC_CullMetaDataAmount culler id nonce))
                (return-amount:decimal (- initial-amount culled-amount))
            )
            (if (= return-amount 0.0)
                (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron dptf-id OUROBOROS.VST|SC_NAME culler initial-amount true true))
                (compose-capability (OUROBOROS.DPMF|MINT patron id OUROBOROS.VST|SC_NAME return-amount true))
            )
            (if (!= return-amount 0.0)
                (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron dptf-id OUROBOROS.VST|SC_NAME culler culled-amount true true))
                true
            )
            (if (!= return-amount 0.0)
                (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron id OUROBOROS.VST|SC_NAME culler return-amount true false))
                true
            )
            (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron id culler OUROBOROS.VST|SC_NAME initial-amount true false))
            (compose-capability (OUROBOROS.DPTF-DPMF|BURN patron id OUROBOROS.VST|SC_NAME initial-amount true false))
        )
    )
    ;;8.2]    [V] VST Functions
    ;;8.2.1]  [V]   VST Utility Functions
    ;;8.2.1.1][V]           Computing|Composing
    (defun VST|UV_HasVesting (id:string token-type:bool)
        @doc "Validates <id> as bein part of a vested token pair"
        (let
            (
                (has-vesting:bool (OUROBOROS.VST|UC_HasVesting id token-type))
            )
            (enforce (= has-vesting true) (format "Token {} is not part of a vesting-pair"[id]))
        )
    )
    (defun VST|UC_SplitBalanceForVesting:[decimal] (id:string amount:decimal milestones:integer)
        @doc "Splits an Amount according to vesting parameters"
        (UTILITY.VST|UC_SplitBalanceForVesting (OUROBOROS.DPTF-DPMF|UR_Decimals id true) amount milestones)
    )
    (defun VST|UC_MakeVestingDateList:[time] (offset:integer duration:integer milestones:integer)
        @doc "Makes a Times list with unvesting milestones according to vesting parameters"
        (UTILITY.VST|UC_MakeVestingDateList offset duration milestones)
    )
    (defun VST|UC_ComposeVestingMetaData:[object{VST|MetaDataSchema}] (id:string amount:decimal offset:integer duration:integer milestones:integer)
        @doc "Creates Vesting MetaData"
        (OUROBOROS.DPTF-DPMF|UV_Amount id amount true)
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
                (meta-data:[object{VST|MetaDataSchema}] (OUROBOROS.DPMF|UR_AccountBatchMetaData id nonce client))
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
                (meta-data:[object{VST|MetaDataSchema}] (OUROBOROS.DPMF|UR_AccountBatchMetaData id nonce client))
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
                    (dpmf-id:string (OUROBOROS.DPTF-DPMF|UR_Vesting id true))
                    (meta-data:string (VST|UC_ComposeVestingMetaData id amount offset duration milestones))
                    (nonce:integer (OUROBOROS.DPMF|CX_Mint patron dpmf-id OUROBOROS.VST|SC_NAME amount meta-data))
                )
                (OUROBOROS.DPTF|CX_Transfer patron id vester OUROBOROS.VST|SC_NAME amount)
                (OUROBOROS.DPMF|CX_Transfer patron dpmf-id nonce OUROBOROS.VST|SC_NAME target-account amount)
            )
        )
    )
    (defun VST|C_Cull (patron:string culler:string id:string nonce:integer)
        @doc "Client Function that culls a Vested Token"
        (with-capability (VST|CULL patron culler id nonce)
            (let*
                (
                    (dptf-id:string (OUROBOROS.DPTF-DPMF|UR_Vesting id false))
                    (initial-amount:decimal (OUROBOROS.DPMF|UR_AccountBatchSupply id nonce culler))
                    (culled-amount:decimal (VST|UC_CullMetaDataAmount culler id nonce))
                    (return-amount:decimal (- initial-amount culled-amount))
                )
                (if (= return-amount 0.0)
                    (OUROBOROS.DPTF|CX_Transfer patron dptf-id OUROBOROS.VST|SC_NAME culler initial-amount)
                    (let*
                        (
                            (remaining-vesting-meta-data:[object{VST|MetaDataSchema}] (VST|UC_CullMetaDataObject culler id nonce))
                            (new-nonce:integer (OUROBOROS.DPMF|CX_Mint patron id OUROBOROS.VST|SC_NAME return-amount remaining-vesting-meta-data))
                        )
                        (OUROBOROS.DPTF|CX_Transfer patron dptf-id OUROBOROS.VST|SC_NAME culler culled-amount)
                        (OUROBOROS.DPMF|CX_Transfer patron id new-nonce OUROBOROS.VST|SC_NAME culler return-amount)
                    )
                )
                (OUROBOROS.DPMF|CX_Transfer patron id nonce culler OUROBOROS.VST|SC_NAME initial-amount)
                (OUROBOROS.DPMF|CX_Burn patron id nonce OUROBOROS.VST|SC_NAME initial-amount)
            )
        )
    )
)

(create-table ATS|Ledger)