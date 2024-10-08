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
        ;;(compose-capability (OUROBOROS.DEMIURGOI))
    )

    (use OUROBOROS)
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
        ;;Deploy the <Ouroboros> Smart DALOS Account
            (OUROBOROS.DALOS|C_DeploySmartAccount DPTF|SC_NAME (keyset-ref-guard DPTF|SC_KEY) DPTF|SC_KDA-NAME)
        ;;Deploy Autostake and Vesting Smart DALOS Accounts
            (with-capability (OUROBOROS.AUTOSTAKE) (OUROBOROS.ATS|AX_InitialiseAutostake patron))
            (with-capability (OUROBOROS.VESTING) (OUROBOROS.VST|AX_InitialiseVesting patron))
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
            (let*
                (
                    (OuroID:string
                        (OUROBOROS.DPTF|C_Issue
                            patron
                            OUROBOROS.DPTF|SC_NAME
                            "Ouroboros"
                            "OURO"
                            24
                            true    ;;can-change-owner
                            true    ;;can-upgrade
                            true    ;;can-add-special-role
                            true    ;;can-freeze
                            true    ;;can-wipe
                            true    ;;can-pause
                        )
                    )
                    (GasID:string       (with-capability (OUROBOROS.GAS-TANKER) (OUROBOROS.GAS|AX_InitialiseGasTanker patron OuroID)))
                    (SnakeIDs:[string]  (with-capability (OUROBOROS.OUROBOROS) (OUROBOROS.DPTF|AX_InitialiseOuroboros patron)))
                    (LiquidIDs:[string] (with-capability (OUROBOROS.LIQUID-STAKING) (OUROBOROS.LIQUID|AX_InitialiseLiquidizer patron)))
                    (Auryndex:string
                        (OUROBOROS.ATS|C_Issue
                            patron
                            patron
                            "Auryndex"
                            24
                            OuroID
                            false
                            (at 0 SnakeIDs)
                            false
                        )
                    )
                    (Elite-Auryndex:string
                        (OUROBOROS.ATS|C_Issue
                            patron
                            patron
                            "EliteAuryndex"
                            24
                            (at 0 SnakeIDs)
                            true
                            (at 1 SnakeIDs)
                            true
                        )
                    )
                    (Kadena-Liquid-Index:string
                        (OUROBOROS.ATS|C_Issue
                            patron
                            patron
                            "KdaLiqIndex"
                            24
                            (at 0 LiquidIDs)
                            false
                            (at 1 LiquidIDs)
                            true
                        )
                    )
                )   
        ;;Set-up Auryndex Pair
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
        ;;Set Elite-Auryndex Pair
                (OUROBOROS.ATS|C_SetColdFee patron Elite-Auryndex 7 [0.0] [[0.0]])
                (OUROBOROS.ATS|C_SetCRD patron Elite-Auryndex false 360 24)
                (OUROBOROS.ATS|C_ToggleElite patron Elite-Auryndex true)
                (OUROBOROS.ATS|C_TurnRecoveryOn patron Elite-Auryndex true)
        ;;Set KdaLiqIndex
                (OUROBOROS.ATS|C_SetColdFee patron Kadena-Liquid-Index -1 [0.0] [[0.0]])
                (OUROBOROS.ATS|C_SetCRD patron Kadena-Liquid-Index false 12 6)
                (OUROBOROS.ATS|C_TurnRecoveryOn patron Kadena-Liquid-Index true)
        ;;Make Vested Snake Tokens
                (OUROBOROS.VST|C_CreateVestingLink patron OuroID)
                (OUROBOROS.VST|C_CreateVestingLink patron (at 0 SnakeIDs))
                (OUROBOROS.VST|C_CreateVestingLink patron (at 1 SnakeIDs))
        ;;Burn and Mint Roles for Ouro To GAS-Tanker
                (OUROBOROS.DPTF-DPMF|C_ToggleBurnRole patron OuroID GAS|SC_NAME true true)
                (OUROBOROS.DPTF|C_ToggleMintRole patron OuroID GAS|SC_NAME true)
        ;;Update DalosProperties Table with new info
                (update OUROBOROS.DALOS|PropertiesTable OUROBOROS.DALOS|INFO
                    { "gas-source-id"           : OuroID
                    , "ats-gas-source-id"       : (at 0 SnakeIDs)
                    , "elite-ats-gas-source-id" : (at 1 SnakeIDs)
                    , "wrapped-kda-id"          : (at 0 LiquidIDs)
                    , "liquid-kda-id"           : (at 1 LiquidIDs)
                    }
                )
        ;;Autostake 1 DWK so that fueling becomes possible.
                (OUROBOROS.LIQUID|C_WrapKadena patron patron 1.0)
                (OUROBOROS.ATS|C_Coil patron patron Kadena-Liquid-Index (at 0 LiquidIDs) 1.0)
                ;;How to set Fee for a DPTF
                ;(OUROBOROS.DPTF|C_SetFee patron OuroID 150.0)
                ;(OUROBOROS.DPTF|C_ToggleFee patron OuroID true)
                ;(OUROBOROS.DPTF|C_ToggleFeeLock patron OuroID true)
                (+ (+ (+ [OuroID] [GasID]) (+ SnakeIDs LiquidIDs)) [Auryndex Elite-Auryndex Kadena-Liquid-Index])
            )
        )
    )
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
                    (OUROBOROS.DPTF-DPMF|UV_id account-or-token-id true)
                    (if (= table-to-query 2)
                        (OUROBOROS.DPTF-DPMF|UV_id account-or-token-id false)
                        (UTILITY.DALOS|UV_Account account-or-token-id) 
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
        (OUROBOROS.DPTF-DPMF|UV_id id true)
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
            (with-capability (DPTF-DPMF|ISSUE patron account true l1)
                (if (not (GAS|UC_SubZero))
                    (GAS|X_Collect patron account gas-costs)
                    true
                )
                (if (not (GAS|UC_NativeSubZero))
                    (GAS|X_CollectDalosFuel patron kda-costs)
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
            (with-capability (DPTF-DPMF|ISSUE patron account false l1)
                (if (not (GAS|UC_SubZero))
                    (GAS|X_Collect patron account gas-costs)
                    true
                )
                (if (not (GAS|UC_NativeSubZero))
                    (GAS|X_CollectDalosFuel patron kda-costs)
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
    (defcap GAS|MAKE (patron:string client:string target:string gas-source-amount:decimal)
        @doc "Capability required to produce GAS"
        (let*
            (
                (gas-source-id:string (OUROBOROS.DALOS|UR_OuroborosID))
                (gas-id:string (OUROBOROS.DALOS|UR_IgnisID))
                (gas-amount:decimal (GAS|UC_Make gas-source-amount))
            )
        ;;01]Any client that is a Standard DALOS Account can perform IGNIS(gas) creation. IGNIS(gas) creation is gas-free.
        ;;   The target account must be a Standard DALOS Account
            (compose-capability (OUROBOROS.DALOS|IZ_ACCOUNT_SMART patron false))
            (compose-capability (OUROBOROS.DALOS|IZ_ACCOUNT_SMART client false))
            (compose-capability (OUROBOROS.DALOS|IZ_ACCOUNT_SMART target false))
        ;;02]Deploy DPTF GAS Account for client (in case no DPTF GAS account exists for client)
            (compose-capability (OUROBOROS.DALOS|ACCOUNT_OWNER client))
        ;;03]Client sends Gas-Source-id to the GasTanker
            (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron gas-source-id client GAS|SC_NAME gas-source-amount true true))
        ;;04]GasTanker burns GAS-Source-ID
            (compose-capability (OUROBOROS.DPTF-DPMF|BURN patron gas-source-id GAS|SC_NAME gas-source-amount true true))
        ;;05]GasTanker mints GAS-ID
            (compose-capability (OUROBOROS.DPTF|MINT patron gas-id GAS|SC_NAME gas-amount false true))
        ;;06]GasTanker transfers GAS to target
            (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron gas-id GAS|SC_NAME target gas-amount true true))
        )
    )
    (defcap GAS|COMPRESS (patron:string client:string gas-amount:decimal)
        @doc "Capability required to produce GAS"
        ;;Enforce only whole amounts of GAS are used for compression
        (enforce (= (floor gas-amount 0) gas-amount) "Only whole Units of Gas can be compressed")
        (let*
            (
                (gas-id:string (OUROBOROS.DALOS|UR_IgnisID))
                (gas-source-id:string (OUROBOROS.DALOS|UR_OuroborosID))
                (gas-source-amount:decimal (GAS|UC_Compress gas-amount))
            )
        ;;01]Any client that is a Standard DALOS Account can perform IGNIS(gas) compression. IGNIS(gas) compression is gas-free.
        ;;   Only IGNIS(gas) held by a Standard DALOS Account can be compressed to OURO(gas-source)
            (compose-capability (OUROBOROS.DALOS|IZ_ACCOUNT_SMART patron false))
            (compose-capability (OUROBOROS.DALOS|IZ_ACCOUNT_SMART client false))
        ;;02]Deploy DPTF GAS-Source Account for client (in case no DPTF Gas-Source account exists for client)
            (compose-capability (OUROBOROS.DALOS|ACCOUNT_OWNER client))
        ;;03]Client sends Gas-id to the GasTanker
            (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron gas-id client GAS|SC_NAME gas-amount true true))
        ;;04]GasTanker burns GAS-ID
            (compose-capability (OUROBOROS.DPTF-DPMF|BURN patron gas-id GAS|SC_NAME gas-amount true true))
        ;;05]GasTanker mints GAS-Source-ID
            (compose-capability (OUROBOROS.DPTF|MINT patron gas-source-id GAS|SC_NAME gas-source-amount false true))
        ;;06]GAS Smart Contract transfers Gas-Source to client: <X_MethodicTransferTrueFungible> must be used so as to not incurr GAS fees for this transfer
            (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron gas-source-id GAS|SC_NAME client gas-source-amount true true))
        )
    )
    ;;5.2]    [G] GAS Functions
    ;;5.2.1]  [G]   GAS Utility Functions
    ;;5.2.1.3][G]           Computing
    (defun GAS|UC_Make (gas-source-amount:decimal)
        @doc "Computes amount of GAS that can be made from the input <gas-source-amount>"
        (enforce (>= gas-source-amount 1.00) "Only amounts greater than or equal to 1.0 can be used to make gas!")
        (let
            (
                (gas-source-id:string (OUROBOROS.DALOS|UR_OuroborosID))
                
            )
            (OUROBOROS.DPTF-DPMF|UV_Amount gas-source-id gas-source-amount true)
            (let*
                (
                    (gas-source-price:decimal (OUROBOROS.DALOS|UR_OuroborosPrice))
                    (gas-source-price-used:decimal (if (<= gas-source-price 1.00) 1.00 gas-source-price))
                    (gas-id:string (OUROBOROS.DALOS|UR_IgnisID))
                )
                (enforce (!= gas-id UTILITY.BAR) "Gas Token isnt properly set")
                (let*
                    (
                        (gas-decimal:integer (OUROBOROS.DPTF-DPMF|UR_Decimals gas-id true))
                        (raw-gas-amount-per-unit (floor (* gas-source-price-used 100.0) gas-decimal))
                        (raw-gas-amount:decimal (floor (* raw-gas-amount-per-unit gas-source-amount) gas-decimal))
                        (gas-amount:decimal (floor (* raw-gas-amount 0.99) 0))
                    )
                    gas-amount
                )
            )
        )
    )
    (defun GAS|UC_Compress (gas-amount:decimal)
        @doc "Computes amount of Gas-Source that can be created from an input amount <gas-amount> of GAS"
        ;;Enforce only whole amounts of GAS are used for compression
        (enforce (= (floor gas-amount 0) gas-amount) "Only whole Units of Gas can be compressed")
        (enforce (>= gas-amount 1.00) "Only amounts greater than or equal to 1.0 can be used to compress gas")
        (let*
            (
                (gas-source-id:string (OUROBOROS.DALOS|UR_OuroborosID))
                (gas-source-price:decimal (OUROBOROS.DALOS|UR_OuroborosPrice))
                (gas-source-price-used:decimal (if (<= gas-source-price 1.00) 1.00 gas-source-price))
                (gas-id:string (OUROBOROS.DALOS|UR_IgnisID))
            )
            (OUROBOROS.DPTF-DPMF|UV_Amount gas-id gas-amount true)
            (let*
                (
                    (gas-source-decimal:integer (OUROBOROS.DPTF-DPMF|UR_Decimals gas-source-id true))
                    (raw-gas-source-amount:decimal (floor (/ gas-amount (* gas-source-price-used 100.0)) gas-source-decimal))
                    (gas-source-amount:decimal (floor (* raw-gas-source-amount 0.985) gas-source-decimal))
                )
                gas-source-amount
            )
        )
    )
    ;;5.2.3]  [G]   GAS Client Functions
    (defun GAS|C_Make:decimal (patron:string client:string target:string gas-source-amount:decimal)
        @doc "Generates GAS from GAS Source Token via Making\
            \ GAS generation is GAS free. \
            \ Gas Source Price is set at a minimum 1$. Uses Gas Price \
            \ Gas Amount generated is alway integer (even though itself is of decimal type)"
        ;;01]Any client that is a Standard DALOS Account can perform IGNIS(gas) creation. IGNIS(gas) creation is gas-free.
        ;;   The target account must be a Standard DALOS Account
        (let*
            (
                (gas-id:string (OUROBOROS.DALOS|UR_IgnisID))
                (gas-source-id:string (OUROBOROS.DALOS|UR_OuroborosID))
                (gas-client-exist:bool (OUROBOROS.DPTF-DPMF|UR_AccountExist gas-id client true))
            )
            (if (= gas-client-exist false)
        ;;02]Deploy DPTF GAS Account for client (in case no DPTF GAS account exists for client)
                (OUROBOROS.DPTF-DPMF|C_DeployAccount gas-id client true)
                true
            )
            (with-capability (GAS|MAKE patron client target gas-source-amount)
            (let
                (
                    (gas-amount:decimal (GAS|UC_Make gas-source-amount))
                )
        ;;03]Client sends Gas-Source-id to the GasTanker
                (OUROBOROS.DPTF|CX_Transfer patron gas-source-id client GAS|SC_NAME gas-source-amount)
        ;;04]GasTanker burns GAS-Source-ID
                (OUROBOROS.DPTF|CX_Burn patron gas-source-id GAS|SC_NAME gas-source-amount)
        ;;05]GasTanker mints GAS-ID
                (OUROBOROS.DPTF|CX_Mint patron gas-id GAS|SC_NAME gas-amount false)
        ;;06]GasTanker transfers GAS to target
                (OUROBOROS.DPTF|CX_Transfer patron gas-id GAS|SC_NAME target gas-amount)
                gas-amount
                )
            )
        )
    )
    (defun GAS|C_Compress (patron:string client:string gas-amount:decimal)
        @doc "Generates Gas-Source(OURO) from Gas(IGNIS) via Compression \
            \ GAS compression is GAS free. \
            \ Gas Source Price is set at a minimum 1$. Uses Gas Price \
            \ Input GAS amount must always be integer/whole (even though itself is of decimal type)"
        ;;01]Any client that is a Standard DALOS Account can perform IGNIS(gas) compression. IGNIS(gas) compression is gas-free.
            ;;   Only IGNIS(gas) held by a Standard DALOS Account can be compressed to OURO(gas-source)
        (let*
            (
                (gas-source-id:string (OUROBOROS.DALOS|UR_OuroborosID))
                (gas-id:string (OUROBOROS.DALOS|UR_IgnisID))
                (gas-source-client-exist:bool (OUROBOROS.DPTF-DPMF|UR_AccountExist gas-source-id client true))
            )
            (if (= gas-source-client-exist false)
        ;;02]Deploy DPTF GAS-Source Account for client (in case no DPTF Gas-Source account exists for client)
                (OUROBOROS.DPTF-DPMF|C_DeployAccount gas-source-id client true)
                true
            )
            (with-capability (GAS|COMPRESS patron client gas-amount)
                (let
                    (
                        (gas-source-amount:decimal (GAS|UC_Compress gas-amount))
                    )
        ;;03]Client sends Gas-id to the GasTanker
                    (OUROBOROS.DPTF|CX_Transfer patron gas-id client GAS|SC_NAME gas-amount)
        ;;04]GasTanker burns GAS-ID
                    (OUROBOROS.DPTF|CX_Burn patron gas-id GAS|SC_NAME gas-amount)
        ;;05]GasTanker mints GAS-Source-ID
                    (OUROBOROS.DPTF|CX_Mint patron gas-source-id GAS|SC_NAME gas-source-amount false)
        ;;06]GasTanker transfers GAS to client
                    (OUROBOROS.DPTF|CX_Transfer patron gas-source-id GAS|SC_NAME client gas-source-amount)
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
    (defcap ATS|DEPLOY-IN-LEDGER (atspair:string account:string)
        @doc "Capability that allows ATS|Ledger Deployment"
        (compose-capability (OUROBOROS.ATS|PAIR_EXIST atspair))
        (compose-capability (OUROBOROS.DALOS|ACCOUNT_EXIST account))
    )
    (defcap ATS|NORMALIZE_LEDGER (atspair:string account:string)
        @doc "Capability needed to normalize an ATS|Ledger Account \
        \ Normalizing an ATS|Ledger Account updates it it according to the <atspair> <c-positions> and <c-elite-mode> parameters \
        \ Existing entries are left as they are"
        (enforce-one
            "Keyset not valid for KadenaLiquidStaking Smart DALOS Account Operations"
            [
                (enforce-guard (keyset-ref-guard OUROBOROS.DALOS|DEMIURGOI))
                (enforce-guard (OUROBOROS.DALOS|UR_AccountGuard account))
            ]
        )
        (compose-capability (OUROBOROS.ATS|PAIR_EXIST atspair))
    )
    (defcap ATS|UPDATE_LEDGER ()
        @doc "Cap required to update entries in the ATS|Ledger"
        true
    )
    (defcap ATS|COLD_RECOVERY (patron:string recoverer:string atspair:string ra:decimal)
        (let
            (
                (c-rbt:string (OUROBOROS.ATS|UR_ColdRewardBearingToken atspair))
            )
            (compose-capability (OUROBOROS.DPTF-DPMF|TRANSFER patron c-rbt recoverer ATS|SC_NAME ra true true))
            (compose-capability (OUROBOROS.DPTF-DPMF|BURN patron c-rbt ATS|SC_NAME ra true true))
            (compose-capability (OUROBOROS.ATS|UPDATE_ROU))
            (compose-capability (ATS|UPDATE_LEDGER))
        )
    )
    ;;6.2]    [A] ATS Functions
    ;;6.2.1]  [A]   ATS Utility Functions
    ;;6.2.1.5][A]           ATS|Ledger Info
    (defun ATS|UR_P0:[object{ATS|Unstake}] (atspair:string account:string)
        @doc "Returns the <P0> of an ATS-UnstakingAccount"
        (UTILITY.DALOS|UV_UniqueAccount atspair)
        (UTILITY.DALOS|UV_Account account)
        (at "P0" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P0"]))
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
                (UTILITY.UC_AppendLast acc (DPTF-DPMF|UR_Decimals rt true))
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
                (resident-amounts:[decimal] (OUROBOROS.ATS|UR_ResidentAmountList atspair))
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
        (ATS|UC_MakeUnstakeObject atspair NULLTIME)
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
                (OUROBOROS.DPTF|CX_Mint patron c-rbt ATS|SC_NAME c-rbt-amount false)
                (VST|C_Vest patron ATS|SC_NAME target-account c-rbt c-rbt-amount offset duration milestones)
                c-rbt-amount
            )
        )
    )
    (defun ATS|C_DeployUnstakeAccount (atspair:string account:string)
        @doc "Deploys an ATS|Ledger (Unstaking) Account for <atspair> and <account>"
        (with-capability (ATS|DEPLOY-IN-LEDGER atspair account)
            (let
                (
                    (zero:object{ATS|Unstake} (ATS|UC_MakeZeroUnstakeObject atspair))
                    (negative:object{ATS|Unstake} (ATS|UC_MakeNegativeUnstakeObject atspair))
                )
                (with-default-read ATS|Ledger (concat [atspair UTILITY.BAR account])
                    { "P0"  : [zero]
                    , "P1"  : zero
                    , "P2"  : zero
                    , "P3"  : zero
                    , "P4"  : zero
                    , "P5"  : zero
                    , "P6"  : zero
                    , "P7"  : zero
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
        )
    )
    (defun ATS|C_ColdRecovery (patron:string recoverer:string atspair:string ra:decimal)
        @doc "Executes Cold Recovery for <ats-pair> by <recoverer> with the <ra> amount of Cold-Reward-Bearing-Token"
        ;;Deploy ATS|Ledger Account for recoverer and normalize it
        (ATS|C_DeployUnstakeAccount atspair recoverer)
        (with-capability (ATS|COLD_RECOVERY patron recoverer atspair ra)
            (ATS|X_Normalize atspair recoverer)
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
                (DPTF|CX_Transfer patron c-rbt recoverer ATS|SC_NAME ra)
            ;;2]ATS|SC_NAME burns c-rbt and handles c-fr
                (DPTF|CX_Burn patron c-rbt ATS|SC_NAME ra)
            ;;3]ATS|Pairs is updated with the proper information (unbonding RTs), while burning any RTs if needed
                (if c-fr
                    (map
                        (lambda
                            (index:integer)
                            (ATS|X_UpdateRoU atspair (at index rt-lst) false true (at index positive-c-fr))
                        )
                        (enumerate 0 (- (length rt-lst) 1))
                    )
                    (with-capability (COMPOSE)
                        (map
                            (lambda
                                (index:integer)
                                (ATS|X_UpdateRoU atspair (at index rt-lst) false true (at index (at 0 negative-c-fr)))
                            )
                            (enumerate 0 (- (length rt-lst) 1))
                        )
                        (map
                            (lambda
                                (index:integer)
                                (with-capability (DPTF-DPMF|BURN patron (at index rt-lst) ATS|SC_NAME (at index (at 1 negative-c-fr)) true true)
                                    (DPTF|CX_Burn patron (at index rt-lst) ATS|SC_NAME (at index (at 1 negative-c-fr)))
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
    (defun ATS|X_StoreUnstakeObject (atspair:string account:string position:integer obj:object{ATS|Unstake})
        @doc "Updates entry in the ATS|Ledger with <obj> on <position> \
        \ Assumes input <position> is free, therefore this function is always called with a free input <position> value"
        (require-capability (ATS|UPDATE_LEDGER))
        (with-read ATS|Ledger (concat [atspair UTILITY.BAR account])
            { "P0"  := p0 , "P1"  := p1 , "P2"  := p2 , "P3"  := p3, "P4"  := p4, "P5"  := p5, "P6"  := p6, "P7"  := p7 }
            (if (= position -1)
                (if (and (length p0 1)(= (at 0 p0) (ATS|UC_MakeZeroUnstakeObject atspair)))
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
                    (positions:integer (ATS|UR_ColdRecoveryPositions atspair))
                    (elite:bool (ATS|UR_EliteMode atspair))
                    (major-tier:integer (DALOS|UR_Elite-Tier-Major account))
                )
                (if (= positions -1)
                    (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                        {"P0"       : (if (or (!= p0 [zero]) (!= p0 [negative])) p0 [zero] )
                        ,"P1"       : (if (or (!= p1 zero) (!= p1 negative)) p1 negative)
                        ,"P2"       : (if (or (!= p2 zero) (!= p2 negative)) p2 negative)
                        ,"P3"       : (if (or (!= p3 zero) (!= p3 negative)) p3 negative)
                        ,"P4"       : (if (or (!= p4 zero) (!= p4 negative)) p4 negative)
                        ,"P5"       : (if (or (!= p5 zero) (!= p5 negative)) p5 negative)
                        ,"P6"       : (if (or (!= p6 zero) (!= p6 negative)) p6 negative)
                        ,"P7"       : (if (or (!= p7 zero) (!= p7 negative)) p7 negative)
                        }
                    )
                    (if (= positions 1)
                        (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                            {"P0"       : (if (or (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                            ,"P1"       : (if (or (!= p1 zero) (!= p1 negative)) p1 zero)
                            ,"P2"       : (if (or (!= p2 zero) (!= p2 negative)) p2 negative)
                            ,"P3"       : (if (or (!= p3 zero) (!= p3 negative)) p3 negative)
                            ,"P4"       : (if (or (!= p4 zero) (!= p4 negative)) p4 negative)
                            ,"P5"       : (if (or (!= p5 zero) (!= p5 negative)) p5 negative)
                            ,"P6"       : (if (or (!= p6 zero) (!= p6 negative)) p6 negative)
                            ,"P7"       : (if (or (!= p7 zero) (!= p7 negative)) p7 negative)
                            }
                        )
                        (if (= positions 2)
                            (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                {"P0"       : (if (or (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                ,"P1"       : (if (or (!= p1 zero) (!= p1 negative)) p1 zero)
                                ,"P2"       : (if (or (!= p2 zero) (!= p2 negative)) p2 zero)
                                ,"P3"       : (if (or (!= p3 zero) (!= p3 negative)) p3 negative)
                                ,"P4"       : (if (or (!= p4 zero) (!= p4 negative)) p4 negative)
                                ,"P5"       : (if (or (!= p5 zero) (!= p5 negative)) p5 negative)
                                ,"P6"       : (if (or (!= p6 zero) (!= p6 negative)) p6 negative)
                                ,"P7"       : (if (or (!= p7 zero) (!= p7 negative)) p7 negative)
                                }
                            )
                            (if (= positions 3)
                                (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                    {"P0"       : (if (or (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                    ,"P1"       : (if (or (!= p1 zero) (!= p1 negative)) p1 zero)
                                    ,"P2"       : (if (or (!= p2 zero) (!= p2 negative)) p2 zero)
                                    ,"P3"       : (if (or (!= p3 zero) (!= p3 negative)) p3 zero)
                                    ,"P4"       : (if (or (!= p4 zero) (!= p4 negative)) p4 negative)
                                    ,"P5"       : (if (or (!= p5 zero) (!= p5 negative)) p5 negative)
                                    ,"P6"       : (if (or (!= p6 zero) (!= p6 negative)) p6 negative)
                                    ,"P7"       : (if (or (!= p7 zero) (!= p7 negative)) p7 negative)
                                    }
                                )
                                (if (= positions 4)
                                    (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                        {"P0"       : (if (or (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                        ,"P1"       : (if (or (!= p1 zero) (!= p1 negative)) p1 zero)
                                        ,"P2"       : (if (or (!= p2 zero) (!= p2 negative)) p2 zero)
                                        ,"P3"       : (if (or (!= p3 zero) (!= p3 negative)) p3 zero)
                                        ,"P4"       : (if (or (!= p4 zero) (!= p4 negative)) p4 zero)
                                        ,"P5"       : (if (or (!= p5 zero) (!= p5 negative)) p5 negative)
                                        ,"P6"       : (if (or (!= p6 zero) (!= p6 negative)) p6 negative)
                                        ,"P7"       : (if (or (!= p7 zero) (!= p7 negative)) p7 negative)
                                        }
                                    )
                                    (if (= positions 5)
                                        (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                            {"P0"       : (if (or (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                            ,"P1"       : (if (or (!= p1 zero) (!= p1 negative)) p1 zero)
                                            ,"P2"       : (if (or (!= p2 zero) (!= p2 negative)) p2 zero)
                                            ,"P3"       : (if (or (!= p3 zero) (!= p3 negative)) p3 zero)
                                            ,"P4"       : (if (or (!= p4 zero) (!= p4 negative)) p4 zero)
                                            ,"P5"       : (if (or (!= p5 zero) (!= p5 negative)) p5 zero)
                                            ,"P6"       : (if (or (!= p6 zero) (!= p6 negative)) p6 negative)
                                            ,"P7"       : (if (or (!= p7 zero) (!= p7 negative)) p7 negative)
                                            }
                                        )
                                        (if (= positions 6)
                                            (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                                {"P0"       : (if (or (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                                ,"P1"       : (if (or (!= p1 zero) (!= p1 negative)) p1 zero)
                                                ,"P2"       : (if (or (!= p2 zero) (!= p2 negative)) p2 zero)
                                                ,"P3"       : (if (or (!= p3 zero) (!= p3 negative)) p3 zero)
                                                ,"P4"       : (if (or (!= p4 zero) (!= p4 negative)) p4 zero)
                                                ,"P5"       : (if (or (!= p5 zero) (!= p5 negative)) p5 zero)
                                                ,"P6"       : (if (or (!= p6 zero) (!= p6 negative)) p6 zero)
                                                ,"P7"       : (if (or (!= p7 zero) (!= p7 negative)) p7 negative)
                                                }
                                            )
                                            (if (not elite)
                                                (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                                    {"P0"       : (if (or (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                                    ,"P1"       : (if (or (!= p1 zero) (!= p1 negative)) p1 zero)
                                                    ,"P2"       : (if (or (!= p2 zero) (!= p2 negative)) p2 zero)
                                                    ,"P3"       : (if (or (!= p3 zero) (!= p3 negative)) p3 zero)
                                                    ,"P4"       : (if (or (!= p4 zero) (!= p4 negative)) p4 zero)
                                                    ,"P5"       : (if (or (!= p5 zero) (!= p5 negative)) p5 zero)
                                                    ,"P6"       : (if (or (!= p6 zero) (!= p6 negative)) p6 zero)
                                                    ,"P7"       : (if (or (!= p7 zero) (!= p7 negative)) p7 zero)
                                                    }
                                                )
                                                (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                                    {"P0"       : (if (or (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                                    ,"P1"       : (if (or (!= p1 zero) (!= p1 negative)) p1 zero)
                                                    ,"P2"       : (if (or (!= p2 zero) (!= p2 negative)) p2 (if (>= major-tier 2) zero negative))
                                                    ,"P3"       : (if (or (!= p3 zero) (!= p3 negative)) p3 (if (>= major-tier 3) zero negative))
                                                    ,"P4"       : (if (or (!= p4 zero) (!= p4 negative)) p4 (if (>= major-tier 4) zero negative))
                                                    ,"P5"       : (if (or (!= p5 zero) (!= p5 negative)) p5 (if (>= major-tier 5) zero negative))
                                                    ,"P6"       : (if (or (!= p6 zero) (!= p6 negative)) p6 (if (>= major-tier 6) zero negative))
                                                    ,"P7"       : (if (or (!= p7 zero) (!= p7 negative)) p7 (if (>= major-tier 7) zero negative))
                                                    }
                                                )
                                                (if (>= major-tier 2) zero negative)
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
                (has-vesting:bool (VST|UC_HasVesting id token-type))
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