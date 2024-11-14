(module OUROAUX GOVERNANCE
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
    (defun DALOS|A_Initialise (patron:string)
        @doc "Main administrative function that initialises the DALOS Virtual Blockchain"
        (with-capability (OUROBOROS.DEMIURGOI)
            ;;Smart DALOS Account Deployment
            ;;Deploy the <Ouroboros> Smart DALOS Account
            ;;Deploy the <DalosAutostake> Smart DALOS Account
            ;;Deploy the <DalosVesting> Smart DALOS Account
            ;;Deploy the <GasTanker> Smart DALOS Account
            ;:Deploy the <Liquidizer> Smart DALOS Account
            (OUROBOROS.DALOS|C_DeploySmartAccount OUROBOROS.DPTF|SC_NAME (keyset-ref-guard OUROBOROS.DPTF|SC_KEY) OUROBOROS.DPTF|SC_KDA-NAME patron)
            (OUROBOROS.DALOS|C_DeploySmartAccount OUROBOROS.ATS|SC_NAME (keyset-ref-guard OUROBOROS.DPTF|SC_KEY) OUROBOROS.ATS|SC_KDA-NAME patron)
            (OUROBOROS.DALOS|C_DeploySmartAccount OUROBOROS.VST|SC_NAME (keyset-ref-guard OUROBOROS.DPTF|SC_KEY) OUROBOROS.VST|SC_KDA-NAME patron)
            (OUROBOROS.DALOS|C_DeploySmartAccount OUROBOROS.GAS|SC_NAME (keyset-ref-guard OUROBOROS.DPTF|SC_KEY) OUROBOROS.GAS|SC_KDA-NAME patron)
            (OUROBOROS.DALOS|C_DeploySmartAccount OUROBOROS.LIQUID|SC_NAME (keyset-ref-guard OUROBOROS.DPTF|SC_KEY) OUROBOROS.LIQUID|SC_KDA-NAME patron)

            ;;Update Smart Account Governors, possible since all of them were created with the same Guard
            (OUROBOROS.DALOS|C_UpdateSmartAccountGovernor patron OUROBOROS.DPTF|SC_NAME "free.OUROBOROS.")
            (OUROBOROS.DALOS|C_UpdateSmartAccountGovernor patron OUROBOROS.ATS|SC_NAME "free.OUROBOROS.")
            (OUROBOROS.DALOS|C_UpdateSmartAccountGovernor patron OUROBOROS.VST|SC_NAME "free.OUROBOROS.")
            (OUROBOROS.DALOS|C_UpdateSmartAccountGovernor patron OUROBOROS.GAS|SC_NAME "free.OUROBOROS.")
            (OUROBOROS.DALOS|C_UpdateSmartAccountGovernor patron OUROBOROS.LIQUID|SC_NAME "free.OUROBOROS.")

            ;;Change Smart Account Guard with their respective Guard
            (OUROBOROS.DALOS|C_RotateGuard patron OUROBOROS.ATS|SC_NAME (keyset-ref-guard OUROBOROS.ATS|SC_KEY) false)
            (OUROBOROS.DALOS|C_RotateGuard patron OUROBOROS.VST|SC_NAME (keyset-ref-guard OUROBOROS.VST|SC_KEY) false)
            (OUROBOROS.DALOS|C_RotateGuard patron OUROBOROS.GAS|SC_NAME (keyset-ref-guard OUROBOROS.GAS|SC_KEY) false)
            (OUROBOROS.DALOS|C_RotateGuard patron OUROBOROS.LIQUID|SC_NAME (keyset-ref-guard OUROBOROS.LIQUID|SC_KEY) false)

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
            ;(enforce-guard (OUROBOROS.DALOS|UR_AccountGuard patron))
            (let*
                (
                    (core-tf:[string]
                        (OUROBOROS.DPTF|CM_Issue
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
                    , "gas-id"                  : GasID
                    , "ats-gas-source-id"       : AurynID
                    , "elite-ats-gas-source-id" : EliteAurynID
                    , "wrapped-kda-id"          : WrappedKadenaID
                    , "liquid-kda-id"           : StakedKadenaID
                    }
                )
        
        ;;Issue needed DPTF Accounts OURO and GAS DPTF Account for the GAS-Tanker
                (OUROBOROS.DPTF-DPMF|C_DeployAccount OuroID OUROBOROS.GAS|SC_NAME true)
                (OUROBOROS.DPTF-DPMF|C_DeployAccount GasID OUROBOROS.GAS|SC_NAME true)
                (OUROBOROS.DPTF-DPMF|C_DeployAccount WrappedKadenaID OUROBOROS.LIQUID|SC_NAME true)
                (OUROBOROS.DPTF-DPMF|C_DeployAccount StakedKadenaID OUROBOROS.LIQUID|SC_NAME true)
        ;;Set-up Auryn and Elite-Auryn
                ;(enforce-guard (OUROBOROS.DALOS|UR_AccountGuard patron))
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
        
        ;(enforce-guard (create-capability-guard (OUROBOROS.DALOS|IZ_ACCOUNT_SMART patron false)))
        ;(enforce-guard (create-capability-guard (OUROBOROS.DALOS|IZ_ACCOUNT_SMART client false)))
        ;(enforce-guard (create-capability-guard (OUROBOROS.DALOS|IZ_ACCOUNT_SMART target false)))

        ;(enforce-guard (create-user-guard (OUROBOROS.DALOS|CAP|StandardAccount patron)))
        ;(enforce-guard (create-user-guard (OUROBOROS.DALOS|CAP|StandardAccount client)))
        ;(enforce-guard (create-user-guard (OUROBOROS.DALOS|CAP|StandardAccount target)))

        (OUROBOROS.DALOS|CAP|StandardAccount patron)
        (OUROBOROS.DALOS|CAP|StandardAccount client)
        (OUROBOROS.DALOS|CAP|StandardAccount target)
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
                (OUROBOROS.DPTF|C_Transmute patron ouro-id OUROBOROS.GAS|SC_NAME ouro-fee-amount)
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
        (OUROBOROS.DALOS|CAP|StandardAccount patron)
        (OUROBOROS.DALOS|CAP|StandardAccount client)
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
                (OUROBOROS.DPTF|C_Transmute patron ouro-id OUROBOROS.GAS|SC_NAME ouro-fee-amount)
                ouro-remainder-amount
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
                (c-rbt:string (OUROBOROS.ATS|UR_ColdRewardBearingToken atspair))
                (c-rbt-amount:decimal (OUROBOROS.ATS|C_Coil patron coiler-vester atspair coil-token amount))
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
                (c-rbt2:string (OUROBOROS.ATS|UR_ColdRewardBearingToken atspair2))
                (c-rbt2-amount:decimal (OUROBOROS.ATS|C_Curl patron curler-vester atspair1 atspair2 curl-token amount))
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
        (OUROBOROS.VST|CAP|Existance id true true)
        (OUROBOROS.VST|CAP|Active id (OUROBOROS.DPTF-DPMF|UR_Vesting id true))
    )
    (defcap VST|CULL (patron:string culler:string id:string nonce:integer)
        (OUROBOROS.VST|CAP|Existance id false true)
        (OUROBOROS.VST|CAP|Active (OUROBOROS.DPTF-DPMF|UR_Vesting id false) id)
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

