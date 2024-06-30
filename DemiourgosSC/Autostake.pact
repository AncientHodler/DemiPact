(module DH_SC_Autostake GOVERNANCE
    @doc "DH_SC_Autostake is the Demiourgos.Holdings Smart-Contract for Autostake of Ouroboros and Auryn Tokens \
    \ It manages the Coil|Curl functions for Ouroboros|Auryn|Elite-Auryn, and the generator of Auryndex"

    ;;CONSTANTS
    ;;Smart-Contract Key and Name Definitions
    (defconst SC_KEY "free.DH_SC_Autostake_Key")
    (defconst SC_NAME "Autostake-Pool")
    (defconst ET        ;;Elite Thresholds
        [0.0 1.0 2.0 5.0 10.0 20.0 50.0 100.0 
        105.0 110.0 125.0 150.0 200.0 350.0 600.0
        610.0 620.0 650.0 700.0 800.0 1100.0 1600.0
        1650.0 1700.0 1850.0 2100.0 2600.0 4100.0 6600.0
        6700.0 6800.0 7100.0 7600.0 8600.0 11600.0 16600.0
        17100.0 17600.0 19100.0 21600.0 26600.0 41600.0 66600.0
        67600.0 68600.0 71600.0 76600.0 86600.0 116600.0 166600.0]
    )
    (defconst DEB       ;;Demiourgos Elite Bonus
        [1.0 1.01 1.02 1.03 1.04 1.05 1.06 1.07
        1.09 1.11 1.13 1.15 1.17 1.19 1.21
        1.24 1.27 1.30 1.33 1.36 1.39 1.42
        1.47 1.52 1.57 1.62 1.67 1.72 1.77
        1.85 1.93 2.01 2.09 2.17 2.25 2.33
        2.46 2.59 2.72 2.85 2.98 3.11 3.24
        3.45 3.66 3.87 4.08 4.29 4.50 4.71]
    )
    (defconst AFT       ;;Auryn Fee Thresholds
        [50.0 100.0 200.0 350.0 550.0 800.0]
    )
    (defconst AUHD      ;;Auryn Uncoil Hour Duration
        [504 480 478 476 472 468 464 460
        456 454 452 448 444 440 436
        432 430 428 424 420 416 412
        408 406 404 400 396 392 388
        384 382 380 376 372 368 364
        360 358 356 352 348 344 340
        336 330 324 318 312 306 300]
    )
    (defconst EAUHD      ;;Elite-Auryn Uncoil Hour Duration
        [1680 1512 1488 1464 1440 1416 1392 1368
        1344 1320 1296 1272 1248 1224 1200
        1176 1152 1128 1104 1080 1056 1032
        1008 984 960 936 912 888 864
        840 816 792 768 744 720 696
        672 648 624 600 576 552 528
        504 480 456 432 408 384 360]
    )
    ;;Time Constants
    (defconst NULLTIME (time "1984-10-11T11:10:00Z"))
    (defconst ANTITIME (time "1983-08-07T11:10:00Z"))
    ;;Elite Account Classes
    (defconst C1 "NOVICE")
    (defconst C2 "INVESTOR")
    (defconst C3 "ENTREPRENEUR")
    (defconst C4 "MOGUL")
    (defconst C5 "MAGNATE")
    (defconst C6 "TYCOON")
    (defconst C7 "DEMIURG")
    ;;Elite Account Names
    ;;Tier 1 - NOVICE Class
    (defconst N00 "Infidel")
    (defconst N01 "Indigent")
    (defconst N11 "Fledgling")
    (defconst N12 "Amateur")
    (defconst N13 "Beginner")
    (defconst N14 "Dabler")
    (defconst N15 "Aspirant")
    (defconst N16 "Enthusiast")
    (defconst N17 "Partner")
    ;;Tier 2 - INVESTOR Class
    (defconst N21 "Novice Investor")
    (defconst N22 "Associate Investor")
    (defconst N23 "Junior Investor")
    (defconst N24 "Senior Investor")
    (defconst N25 "Adept Investor")
    (defconst N26 "Expert Investor")
    (defconst N27 "Elite Investor")
    ;;Tier 3 - ENTREPRENEUR Class
    (defconst N31 "Novice Entrepreneur")
    (defconst N32 "Associate Entrepreneur")
    (defconst N33 "Junior Entrepreneur")
    (defconst N34 "Senior Entrepreneur")
    (defconst N35 "Adept Entrepreneur")
    (defconst N36 "Expert Entrepreneur")
    (defconst N37 "Elite Entrepreneur")
    ;;Tier 4 - MOGUL Class
    (defconst N41 "Associate Mogul")
    (defconst N42 "Junior Mogul")
    (defconst N43 "Senior Mogul")
    (defconst N44 "Adept Mogul")
    (defconst N45 "Expert Mogul")
    (defconst N46 "Elite Mogul")
    (defconst N47 "Master Mogul")
    ;;Tier 5 - MAGNATE Class
    (defconst N51 "Associate Magnate")
    (defconst N52 "Junior Magnate")
    (defconst N53 "Senior Magnate")
    (defconst N54 "Adept Magnate")
    (defconst N55 "Expert Magnate")
    (defconst N56 "Elite Magnate")
    (defconst N57 "Master Magnate")
    ;;Tier 6 - TYCOON Class
    (defconst N61 "Junior Tycoon")
    (defconst N62 "Senior Tycoon")
    (defconst N63 "Adept Tycoon")
    (defconst N64 "Expert Tycoon")
    (defconst N65 "Elite Tycoon")
    (defconst N66 "Master Tycoon")
    (defconst N67 "Grand-Master Tycoon")
    ;;Tier 6 - DEMIURG Class
    (defconst N71 "Neophyte Demiurg")
    (defconst N72 "Acolyte Demiurg")
    (defconst N73 "Adept Demiurg")
    (defconst N74 "Expert Demiurg")
    (defconst N75 "Elite Demiurg")
    (defconst N76 "Master Demiurg")
    (defconst N77 "Grand-Master Demiurg")

    ;;TABLE-KEYS
    (defconst TRINITY "TrinityIDs")
    (defconst AUTOSTAKEHOLDINGS "AutostakeHoldings")
    ;;SCHEMAS Definitions
    (defschema TrinitySchema
        ouro-id:string
        auryn-id:string
        elite-auryn-id:string
        ignis-id:string
    )
    (defschema AutostakeSchema
        resident-ouro:decimal
        unbonding-ouro:decimal
        resident-auryn:decimal
        unbonding-auryn:decimal    
    )
    (defschema EliteAccountSchema
        @doc "The Elite Account Schema that tracks Tier, TierName and DEB"
        class:string
        name:string
        tier:string
        deb:decimal
    )
    (defschema UncoilSchema
        @doc "Schema holding the Auryn/Elite-Auryn Uncoil Data"
    
        P1:object{UncoilPositionSchema}
        P2:object{UncoilPositionSchema}
        P3:object{UncoilPositionSchema}
        P4:object{UncoilPositionSchema}
        P5:object{UncoilPositionSchema}
        P6:object{UncoilPositionSchema}
        P7:object{UncoilPositionSchema}
    )
    (defschema UncoilPositionSchema
        au-ob:decimal   ;;auryn.uncoil-ouro.balance
        ae:time         ;;auryn-epoch as cull time
        eau-ab:decimal  ;;elite.auryn.uncoil-auryn.balance
        eae:time        ;;elite-auryn-epoch as cull-time
    )
    ;;TABLES Definitions
    (deftable TrinityTable:{TrinitySchema})
    (deftable AutostakeLedger:{AutostakeSchema})
    (deftable EliteTracker:{EliteAccountSchema})
    (deftable UncoilLedger:{UncoilSchema})
    ;;
    ;;=======================================================================================================
    ;;
    ;;Governance and Administration CAPABILITIES
    ;;
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
        \ Set to Autostake_Admin so that only Module Key can enact an upgrade"
        false
        ;(compose-capability (AUTOSTAKE_ADMIN))
    )
    (defcap AUTOSTAKE_ADMIN ()
        (enforce-guard (keyset-ref-guard SC_KEY))
    )
    ;;=======================================================================================================
    ;;
    ;;      CAPABILITIES
    ;;
    ;;      BASIC                   Basic Capabilities represent singular capability Definitions
    ;;      COMPOSED                Composed Capabilities are made of one or multiple Basic Capabilities
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      BASIC
    ;;
    ;;      GENESISAUTOSTAKE        Ensures Autostake Ledger is empty, which allows for initialisation
    ;;      UPDATE_AUTOSTAKE_LEDGER Capability that allows for updating of AutostakeLedger
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      COMPOSED
    ;;
    ;;      INIT-AUTOSTAKE          Required for Autostake Initialisation
    ;;      COIL_OUROBOROS          Required for Coil of Ouroboros
    ;;      FUEL_OUROBOROS          Required for Autostake Fueling
    ;;      COIL-AURYN              Required for Coil of Auryn
    ;;      CURL-OUROBOROS          Required for Curl of Ouroboros
    ;;      UNCOIL-AURYN            Required for Uncoil of Auryn
    ;;
    ;;========================================================================================================
    ;;
    ;;
    ;;
    ;;========================================================================================================
    ;;
    ;;      CAPABILITIES
    ;;
    ;;      BASIC
    ;;
    (defcap GENESISAUTOSTAKE ()
        @doc "Ensure AutostakeLedger is empty. This allows for Autostake initialisation \
        \ IF Autostake was already initialise, re-initialising it wont work a second time"
        (with-default-read AutostakeLedger AUTOSTAKEHOLDINGS
            { "resident-ouro" : 0.0 }
            { "resident-ouro" := ro }
            (enforce (= ro 0.0) (format "Autostake Holdings already have {} Resident Ouroboros" [ro]))
        )
    )
    (defcap UPDATE_AUTOSTAKE_LEDGER()
        true
    )
    ;;
    ;;
    (defcap UNCOIL-LEDGER_BALANCE (balance:decimal)
    @doc "Enforces Integer as Uncoil Ledger Epoch"
    
        (enforce
            (or
                (>= balance 0.0)
                (= balance -1.0)
            )
            "Decimal is not valid Uncoil Ledger Balance"
        )
    )
    (defcap UNCOIL-LEDGER_MANAGING-POSITION (position:integer)
        @doc "Enforces Integer as Uncoil Ledger Elite-Auryn Uncoil optional position"
        (enforce (contains position (enumerate 2 7)) "Invalid Position for managing")
    )
    (defcap UNCOIL-LEDGER_MANAGING-TIER (tier:integer)
        @doc "Enforces Integer as Uncoil Ledger Elite-Auryn Uncoil optional position"
        (enforce (contains tier (enumerate 2 7)) "Invalid Tier for Elite Uncoil Position Management and Hexa Boolean List Making")
    )
    (defcap UPDATE_ELITE_TRACKER ()
        @doc "Capability for managing update or Elite Tracker"
        true
    )
    (defcap UPDATE_UNCOIL_LEDGER ()
        @doc "Capability for managing update or Uncoil Ledger"
        true
    )
    (defcap SNAKE_TOKEN_OWNERSHIP (account:string)
        (with-read DH_DPTS.DPTSBalancesTable (concat [(U_OuroborosID) DH_DPTS.IASPLITTER account])
            { "guard" := og }
            (with-default-read DH_DPTS.DPTSBalancesTable (concat [(U_AurynID) DH_DPTS.IASPLITTER account])
                { "guard" : og }
                { "guard" := ag }
                (with-default-read DH_DPTS.DPTSBalancesTable (concat [(U_EliteAurynID) DH_DPTS.IASPLITTER account])
                    { "guard" : ag }
                    { "guard" := eag }
                    (or
                        (compose-capability (DH_DPTS.DPTS_ACCOUNT_OWNER (U_OuroborosID) account))
                        (or
                            (compose-capability (DH_DPTS.DPTS_ACCOUNT_OWNER (U_AurynID) account))
                            (compose-capability (DH_DPTS.DPTS_ACCOUNT_OWNER (U_EliteAurynID) account))
                        )
                    )
                )
            )
        )
    )
    (defcap AUXS_UTILS ()
        @doc "Capability to conduct computation required for Auxiliary Utility functions"
        true
    )
    (defcap UPDATE_AURYNZ (account:string)
        (compose-capability (SNAKE_TOKEN_OWNERSHIP account))
        (compose-capability (UPDATE_UNCOIL_LEDGER))
        (compose-capability (UPDATE_ELITE_TRACKER))
    )
    ;;
    ;;---------------------------------------------------------------------------------------------------------
    ;;
    ;;      COMPOSED
    ;;
    (defcap INIT_AUTOSTAKE ()
        (compose-capability (AUTOSTAKE_ADMIN))
        (compose-capability (GENESISAUTOSTAKE))
    )
    (defcap COIL_OUROBOROS(client:string ouro-input-amount:decimal auryn-output-amount:decimal)
    ;;Client Transfers OURO to Autostake (as method)   
        (compose-capability (DH_DPTS.TRANSFER_DPTS (U_OuroborosID) client SC_NAME ouro-input-amount true))
    ;;Autostake Updates Autostake Ledger (Resident OURO increase)
        (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
    ;;Autostake Locally mints AURYN
        (compose-capability (MINT_AURYN (U_AurynID) SC_NAME))
    ;;Autostake Transfers AURYN To Client (as method)
        (compose-capability (DH_DPTS.TRANSFER_DPTS (U_AurynID) SC_NAME client auryn-output-amount true))  
    ;;Since user receives Auryn, Autostake makes/updates Elite Account Information
        (compose-capability (UPDATE_AURYNZ client))
    )
    (defcap FUEL_OUROBOROS(client:string ouro-input-amount:decimal)
    ;;Client Transfers Ouroboros to Autostake pool efectively injecting Ouro into the Autostake pool
        (compose-capability (DH_DPTS.TRANSFER_DPTS (U_OuroborosID) client SC_NAME ouro-input-amount true))
    ;;Autostake Updates Resident Ouro Information
        (compose-capability (UPDATE_AUTOSTAKE_LEDGER))  
    )
    (defcap COIL_AURYN(client:string auryn-input-amount:decimal)
    ;;Client Transfers AURYN to Autostake (as method)
        (compose-capability (DH_DPTS.TRANSFER_DPTS (U_AurynID) client SC_NAME auryn-input-amount true))
    ;;Autostake Updates Autostake Ledger (Resident Auryn increase)
        (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
    ;;Autostake Locally mints ELITEAURYN
        (compose-capability (MINT_ELITE-AURYN (U_EliteAurynID) SC_NAME))
    ;;Autostake Transfers ELITEAURYN To Client
        (compose-capability (DH_DPTS.TRANSFER_DPTS (U_EliteAurynID) SC_NAME client auryn-input-amount true))
    ;;Since user receives Elite-Auryn, Autostake makes/updates Elite Account Information
        (compose-capability (UPDATE_AURYNZ client))
    )
    (defcap CURL_OUROBOROS(client:string ouro-input-amount:decimal)
        (let 
            (
                (auryn-computed-amount:decimal (U_ComputeOuroCoil ouro-input-amount))
            )
        ;;Client Transfers OURO to Autostake (as method)    
            (compose-capability (DH_DPTS.TRANSFER_DPTS (U_OuroborosID) client SC_NAME ouro-input-amount true))
        ;;Autostake Locally mints AURYN
            (compose-capability (MINT_AURYN (U_AurynID) SC_NAME))
        ;;Autostake Updates its internal Table (Resident Ouro and Resident Auryn)    
            (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
        ;;Autostake Locally mints ELITEAURYN
            (compose-capability (MINT_ELITE-AURYN (U_EliteAurynID) SC_NAME))
        ;;Autostake Transfers minted ELITEAURYN to client
            (compose-capability (DH_DPTS.TRANSFER_DPTS (U_EliteAurynID) SC_NAME client auryn-computed-amount true))
        ;;Since client receives Elite-Auryn, Autostake makes/updates Elite Account Information
            (compose-capability (UPDATE_AURYNZ client))
        )
    )
    (defcap UNCOIL-AURYN(client:string auryn-input-amount:decimal)
        ;;UpdateAurynzData (needed to create UncoilLedger Data in case it doesnt exist)
        (compose-capability (UPDATE_AURYNZ client))
        ;;Client Transfers AURYN to Autostake (as method) for burning
            (compose-capability (DH_DPTS.TRANSFER_DPTS (U_AurynID) client SC_NAME auryn-input-amount true))
        ;;Autostake Locally burns the whole AURYN transfered
            (compose-capability (BURN_AURYN (U_AurynID) SC_NAME))
        ;;Autostake Locally burns OURO (Ouro as uncoil fee; burning ouro automatically mints Ignis)    
            (compose-capability (BURN_OUROBOROS (U_OuroborosID) (U_IgnisID) SC_NAME))
        ;;Autostake Updates Autostake Ledger (Resident OURO decrease, Unbonding Ouro increase)    
            (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
        ;;Autostake Updates Uncoil Ledger 
            ;;Already granted by UPDATE_AURYNZ
            ;;(compose-capability (UPDATE_UNCOIL_LEDGER))
    )
    (defcap BURN_OUROBOROS (ouro-identifier:string ignis-identifier:string account:string)
        (compose-capability (DH_DPTS.BURN_DPTS ouro-identifier account))
        (compose-capability (DH_DPTS.MINT_DPTS ignis-identifier account))
    )
    (defcap BURN_AURYN (auryn-identifier:string account:string)
        (compose-capability (DH_DPTS.BURN_DPTS auryn-identifier account))
    )
    (defcap BURN_ELITE-AURYN (elite-auryn-identifier:string account:string)
        (compose-capability (DH_DPTS.BURN_DPTS elite-auryn-identifier account))
    )
    (defcap MINT_OUROBOROS (ouro-identifier:string account:string)
        (compose-capability (DH_DPTS.MINT_DPTS ouro-identifier account))
    )
    (defcap MINT_AURYN (auryn-identifier:string account:string)
        (compose-capability (DH_DPTS.MINT_DPTS auryn-identifier account))
    )
    (defcap MINT_ELITE-AURYN (elite-auryn-identifier:string account:string)
        (compose-capability (DH_DPTS.MINT_DPTS elite-auryn-identifier account))
    )
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
    ;;      AUXILIARY Functions                     not meant to be used at all as they are part of the Primary Functions
    ;;      
    ;;======================================================================================================
    ;;
    ;;      Functions Names are prefixed, so that they may be better visualised and understood.
    ;;
    ;;      UTILITY                                 U_FunctionName
    ;;      ADMINISTRATION                          A_FunctionName
    ;;      CLIENT                                  C_FunctionName
    ;;      AUXILIARY                               X_FunctionName
    ;;      AUXILIARY-UTILITY                       XU_FunctionName
    ;;
    ;;======================================================================================================
    ;;
    ;;      UTILITY FUNCTIONS
    ;;
    ;;      U_ComputeElite                          Computes Elite Account Data
    ;;      U_PrintElite                            Prints Elite Account Data
    ;;      U_OuroborosID                           Returns as string the Ouroboros id
    ;;      U_AurynID                               Returns as string the Auryn id
    ;;      U_EliteAurynID                          Returns as string the Elite-Auryn id
    ;;      U_GetResidentOuro                       Returns as decimal the amount of Resident Ouroboros
    ;;      U_GetUnbondingOuro                      Returns as decimal the amount of Unbonding Ouroboros
    ;;      U_GetResidentAuryn                      Returns as decimal the amount of Resident Auryn
    ;;      U_GetUnbondingAuryn                     Returns as decimal the amount of Unbonding Auryn
    ;;      U_GetAuryndex                           Returns the value of Auryndex with 24 decimals
    ;;
    ;;      U_ComputeOuroCoil                       Computes Ouro Coil Data: Outputs Auryn Output Amount
    ;;      U_ComputeAurynUncoil                    Computes Auryn Uncoil Data: Outputs Decimal List
    ;;      U_ComputeAurynUncoilFeePromile          Computes Auryn Uncoil Fee Promile
    ;;      U_ComputeUncoilDuration                 Computes Auryn or Elite-Auryn Uncoil Duration in Hours for client
    ;;      U_ComputeCullTime                       Computes Cull Time for Auryn or Elite-Auryn using Tx present time
    ;;      U_GetUncoilPosition                     Gets best Auryn or Elite-Auryn uncoil Position
    ;;      U_GetZeroPosition                       Returns best uncoil position from a list of balances
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      ADMINISTRATOR FUNCTIONS
    ;;
    ;;      A_InitialiseAutostake   Initialises the Autostake Smart-Contract
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      CLIENT FUNCTIONS
    ;;
    ;;      C_CoilOuroboros                         Coils Ouroboros, staking it into the Autostake Pool, generating Auryn
    ;;      C_FuelOuroboros                         Fuels the Autostake Pool with Ouroboros, increasing the Auryndex
    ;;      C_CoilAuryn                             Coils Auryn, securing it into the Autostake Pool, generating Elite-Auryn
    ;;      C_CurlOuroboros                         Curls Ouroboros, then Curls Auryn in a single Function
    ;;
    ;;--------------------------------------------------------------------------------------------------------
    ;;
    ;;      AUXILIARY FUNCTIONS
    ;;
    ;;      X_UpdateAurynzData                      Updates Data pertaining to Demiourgos Elite Account (perks for owning Elite-Auryn)
    ;;      X_InitialiseUncoilLedger                Initialises Uncoil Ledger for Account
    ;;      X_UpdateUncoilLedgerWithElite           Updates Elite-Auryn Uncoil Ledger positions based on Major Elite Tier
    ;;      X_UpdateEliteTracker                    Updates Elite-Account Information which tracks Elite-Auryn Ammounts
    ;;      X_UpdateUncoilLedger                    Updates Uncoil Ledgers with New Uncoil Data
    ;;
    ;;      X_BurnOuroboros                         Burns Ouroboros and generates Ignis at 100x capacity
    ;;      X_BurnAuryn                             Burns Auryn
    ;;      X_BurnEliteAuryn                        Burns EliteAuryn
    ;;      X_MintOuroboros                         Mints Ouroboros
    ;;      X_MintAuryn                             Mints Auryn
    ;;      X_MintEliteAuryn                        Mints EliteAuryn
    ;;
    ;;      X_UpdateResidentOuro                    Updates the Resident Ouro in the Autostake Ledger
    ;;      X_UpdateResidentAuryn                   Updates the Resident Auryn in the Autostake Ledger
    ;;      X_UpdateUnbondingOuro                   Updates the Unbonding Ouro in the Autostake Ledger
    ;;      X_UpdateUnbondingAuryn                  Updates the Unbonding Auryn in the Autostake Ledger
    ;;
    ;;      XU_ManageEliteUncoilPositionWithTier    Manages Elite Auryn uncoil position based on Major Elite Tier Value
    ;;      XU_MakeHexaBooleanList                  Creates a list of 6 bolean values depending based on Major Elite Tier Value
    ;;      XU_ToggleEliteUncoilPosition            Opens or Closes Elite Auryn Uncoil Position depending on input parameters
    ;;      XU_CheckPositionState                   Check Uncoil position state
    ;;
    ;;
    ;;========================================================================================================
    ;;
    ;;
    ;;
    ;;========================================================================================================
    ;;
    ;;      UTILITY FUNCTIONS
    ;;
    ;;      U_ComputeElite 
    ;;
    (defun U_ComputeElite:object{EliteAccountSchema} (x:decimal)
    @doc "Computes Elite Tier Name based on x as Elite-Auryn amount"
        (cond
            ;;Class Novice
            ((= x (at 0 ET)) { "class": C1, "name": N00, "tier": "0.0", "deb": (at 0 DEB)})
            ((and (> x (at 0 ET))(< x (at 1 ET))) { "class": C1, "name": N01, "tier": "0.1", "deb": (at 0 DEB)})
            ((and (>= x (at 1 ET))(< x (at 2 ET))) { "class": C1, "name": N11, "tier": "1.1", "deb": (at 1 DEB)})
            ((and (>= x (at 2 ET))(< x (at 3 ET))) { "class": C1, "name": N12, "tier": "1.2", "deb": (at 2 DEB)})
            ((and (>= x (at 3 ET))(< x (at 4 ET))) { "class": C1, "name": N13, "tier": "1.3", "deb": (at 3 DEB)})
            ((and (>= x (at 4 ET))(< x (at 5 ET))) { "class": C1, "name": N14, "tier": "1.4", "deb": (at 4 DEB)})
            ((and (>= x (at 5 ET))(< x (at 6 ET))) { "class": C1, "name": N15, "tier": "1.5", "deb": (at 5 DEB)})
            ((and (>= x (at 6 ET))(< x (at 7 ET))) { "class": C1, "name": N16, "tier": "1.6", "deb": (at 6 DEB)})
            ((and (>= x (at 7 ET))(< x (at 8 ET))) { "class": C1, "name": N17, "tier": "1.7", "deb": (at 7 DEB)})
            ;;Class INVESTOR
            ((and (>= x (at 8 ET))(< x (at 9 ET))) { "class": C2, "name": N21, "tier": "2.1", "deb": (at 8 DEB)})
            ((and (>= x (at 9 ET))(< x (at 10 ET))) { "class": C2, "name": N22, "tier": "2.2", "deb": (at 9 DEB)})
            ((and (>= x (at 10 ET))(< x (at 11 ET))) { "class": C2, "name": N23, "tier": "2.3", "deb": (at 10 DEB)})
            ((and (>= x (at 11 ET))(< x (at 12 ET))) { "class": C2, "name": N24, "tier": "2.4", "deb": (at 11 DEB)})
            ((and (>= x (at 12 ET))(< x (at 13 ET))) { "class": C2, "name": N25, "tier": "2.5", "deb": (at 12 DEB)})
            ((and (>= x (at 13 ET))(< x (at 14 ET))) { "class": C2, "name": N26, "tier": "2.6", "deb": (at 13 DEB)})
            ((and (>= x (at 14 ET))(< x (at 15 ET))) { "class": C2, "name": N27, "tier": "2.7", "deb": (at 14 DEB)})
            ;;Class ENTREPRENEUR
            ((and (>= x (at 15 ET))(< x (at 16 ET))) { "class": C3, "name": N31, "tier": "3.1", "deb": (at 15 DEB)})
            ((and (>= x (at 16 ET))(< x (at 17 ET))) { "class": C3, "name": N32, "tier": "3.2", "deb": (at 16 DEB)})
            ((and (>= x (at 17 ET))(< x (at 18 ET))) { "class": C3, "name": N33, "tier": "3.3", "deb": (at 17 DEB)})
            ((and (>= x (at 18 ET))(< x (at 19 ET))) { "class": C3, "name": N34, "tier": "3.4", "deb": (at 18 DEB)})
            ((and (>= x (at 19 ET))(< x (at 20 ET))) { "class": C3, "name": N35, "tier": "3.5", "deb": (at 19 DEB)})
            ((and (>= x (at 20 ET))(< x (at 21 ET))) { "class": C3, "name": N36, "tier": "3.6", "deb": (at 20 DEB)})
            ((and (>= x (at 21 ET))(< x (at 22 ET))) { "class": C3, "name": N37, "tier": "3.7", "deb": (at 21 DEB)})
            ;;Class MOGUL
            ((and (>= x (at 22 ET))(< x (at 23 ET))) { "class": C4, "name": N41, "tier": "4.1", "deb": (at 22 DEB)})
            ((and (>= x (at 23 ET))(< x (at 24 ET))) { "class": C4, "name": N42, "tier": "4.2", "deb": (at 23 DEB)})
            ((and (>= x (at 24 ET))(< x (at 25 ET))) { "class": C4, "name": N43, "tier": "4.3", "deb": (at 24 DEB)})
            ((and (>= x (at 25 ET))(< x (at 26 ET))) { "class": C4, "name": N44, "tier": "4.4", "deb": (at 25 DEB)})
            ((and (>= x (at 26 ET))(< x (at 27 ET))) { "class": C4, "name": N45, "tier": "4.5", "deb": (at 26 DEB)})
            ((and (>= x (at 27 ET))(< x (at 28 ET))) { "class": C4, "name": N46, "tier": "4.6", "deb": (at 27 DEB)})
            ((and (>= x (at 28 ET))(< x (at 29 ET))) { "class": C4, "name": N47, "tier": "4.7", "deb": (at 28 DEB)})
            ;;Class MAGNATE
            ((and (>= x (at 29 ET))(< x (at 30 ET))) { "class": C5, "name": N51, "tier": "5.1", "deb": (at 29 DEB)})
            ((and (>= x (at 30 ET))(< x (at 31 ET))) { "class": C5, "name": N52, "tier": "5.2", "deb": (at 30 DEB)})
            ((and (>= x (at 31 ET))(< x (at 32 ET))) { "class": C5, "name": N53, "tier": "5.3", "deb": (at 31 DEB)})
            ((and (>= x (at 32 ET))(< x (at 33 ET))) { "class": C5, "name": N54, "tier": "5.4", "deb": (at 32 DEB)})
            ((and (>= x (at 33 ET))(< x (at 34 ET))) { "class": C5, "name": N55, "tier": "5.5", "deb": (at 33 DEB)})
            ((and (>= x (at 34 ET))(< x (at 35 ET))) { "class": C5, "name": N56, "tier": "5.6", "deb": (at 34 DEB)})
            ((and (>= x (at 35 ET))(< x (at 36 ET))) { "class": C5, "name": N57, "tier": "5.7", "deb": (at 35 DEB)})
            ;;Class TYCOON
            ((and (>= x (at 36 ET))(< x (at 37 ET))) { "class": C6, "name": N61, "tier": "6.1", "deb": (at 36 DEB)})
            ((and (>= x (at 37 ET))(< x (at 38 ET))) { "class": C6, "name": N62, "tier": "6.2", "deb": (at 37 DEB)})
            ((and (>= x (at 38 ET))(< x (at 39 ET))) { "class": C6, "name": N63, "tier": "6.3", "deb": (at 38 DEB)})
            ((and (>= x (at 39 ET))(< x (at 40 ET))) { "class": C6, "name": N64, "tier": "6.4", "deb": (at 39 DEB)})
            ((and (>= x (at 40 ET))(< x (at 41 ET))) { "class": C6, "name": N65, "tier": "6.5", "deb": (at 40 DEB)})
            ((and (>= x (at 41 ET))(< x (at 42 ET))) { "class": C6, "name": N66, "tier": "6.6", "deb": (at 41 DEB)})
            ((and (>= x (at 42 ET))(< x (at 43 ET))) { "class": C6, "name": N67, "tier": "6.7", "deb": (at 42 DEB)})
            ;;Class DEMIURG
            ((and (>= x (at 43 ET))(< x (at 44 ET))) { "class": C7, "name": N71, "tier": "7.1", "deb": (at 43 DEB)})
            ((and (>= x (at 44 ET))(< x (at 45 ET))) { "class": C7, "name": N72, "tier": "7.2", "deb": (at 44 DEB)})
            ((and (>= x (at 45 ET))(< x (at 46 ET))) { "class": C7, "name": N73, "tier": "7.3", "deb": (at 45 DEB)})
            ((and (>= x (at 46 ET))(< x (at 47 ET))) { "class": C7, "name": N74, "tier": "7.4", "deb": (at 46 DEB)})
            ((and (>= x (at 47 ET))(< x (at 48 ET))) { "class": C7, "name": N75, "tier": "7.5", "deb": (at 47 DEB)})
            ((and (>= x (at 48 ET))(< x (at 49 ET))) { "class": C7, "name": N76, "tier": "7.6", "deb": (at 48 DEB)})
            { "class": C7, "name": N77, "tier": "7.7", "deb": (at 49 DEB)}
        )
    )
    ;;
    ;;      U_PrintElite
    ;;
    (defun U_PrintElite (account:string)
        @doc "Prints Elite Account Data"
        (with-default-read EliteTracker account
            { "class" : C1, "name" : N00, "tier" : "0.0" , "deb" : (at 0 DEB)}
            { "class" := c, "name" := n, "tier" := t, "deb" := d }
            (format "Account {}: Class = {}; Name = {}; Tier = {}; DEB = {};" [account c n t d])
        )
    )
    ;;
    ;;      U_OuroborosID
    ;;
    (defun U_OuroborosID:string ()
        @doc "Returns as string the Ouroboros id"
        (at "ouro-id" (read TrinityTable TRINITY ["ouro-id"]))
    )
    ;;
    ;;      U_AurynID
    ;;
    (defun U_AurynID:string ()
        @doc "Returns as string the Auryn id"
        (at "auryn-id" (read TrinityTable TRINITY ["auryn-id"]))
    )
    ;;
    ;;      U_EliteAurynID
    ;;
    (defun U_EliteAurynID:string ()
        @doc "Returns as string the Elite-Auryn id"
        (at "elite-auryn-id" (read TrinityTable TRINITY ["elite-auryn-id"]))
    )
    ;;
    ;;      U_IgnisID
    ;;
    (defun U_IgnisID:string ()
        @doc "Returns as string the Ignis id"
        (at "ignis-id" (read TrinityTable TRINITY ["ignis-id"]))
    )
    ;;
    ;;      U_GetResidentOuro
    ;;
    (defun U_GetResidentOuro:decimal ()
        @doc "Returns as decimal the amount of Resident Ouroboros"
        (at "resident-ouro" (read AutostakeLedger AUTOSTAKEHOLDINGS ["resident-ouro"]))
    )
    ;;
    ;;      U_GetUnbondingOuro
    ;;
    (defun U_GetUnbondingOuro:decimal ()
        @doc "Returns as decimal the amount of Unbonding Ouroboros"
        (at "unbonding-ouro" (read AutostakeLedger AUTOSTAKEHOLDINGS ["unbonding-ouro"]))
    )
    ;;
    ;;      U_GetResidentAuryn
    ;;
    (defun U_GetResidentAuryn:decimal ()
        @doc "Returns as decimal the amount of Resident Auryn"
        (at "resident-auryn" (read AutostakeLedger AUTOSTAKEHOLDINGS ["resident-auryn"]))
    )
    ;;
    ;;      U_GetResidentAuryn
    ;;
    (defun U_GetUnbondingAuryn:decimal ()
        @doc "Returns as decimal the amount of Unbonding Auryn"
        (at "unbonding-auryn" (read AutostakeLedger AUTOSTAKEHOLDINGS ["unbonding-auryn"]))
    )
    ;;
    ;;      U_GetAuryndex
    ;;
    (defun U_GetAuryndex:decimal ()
        @doc "Returns the value of Auryndex with 24 decimals"
        (let
            (
                (auryn-supply:decimal (DH_DPTS.U_GetDPTSSupply (U_AurynID)))
                (r-ouro-supply:decimal (U_GetResidentOuro))
            )
            (if
                (= auryn-supply 0.0)
                (floor 0.0 24)
                (floor (/ r-ouro-supply auryn-supply) 24)
            )
        )
    )
    ;;
    ;;      U_ComputeOuroCoil
    ;;
    (defun U_ComputeOuroCoil:decimal (ouro-input-amount:decimal)
        @doc "Compute Ouroboros Coil Data. This amount includes: \
        \ Auryn Output Amount as decimal via Auryndex"

        (let
            (
                (auryndex:decimal (U_GetAuryndex))
                (r-ouro-supply:decimal (U_GetResidentOuro))
                (auryndecimals:integer (at "decimals" (read DH_DPTS.DPTSPropertiesTable (U_AurynID) ["decimals"])))
            )
            (if (= auryndex 0.0)
                ouro-input-amount
                (floor (/ ouro-input-amount auryndex) auryndecimals)
            )
        )
    )
    ;;
    ;;      U_ComputeAurynUncoil
    ;;
    (defun U_ComputeAurynUncoil:[decimal] (auryn-input-amount:decimal position:integer)
        @doc "Computes Auryn Uncoil Data and outputs them into a list of decimals \
        \ [0] Ouro-Redeem-Amount := The Total Amount of Ouro resulting from uncoil \
        \ [1] Ouro-Output-Amount := Part of the Ouro-Redeem-Amount that reaches client after Auryn Uncoil is culled \
        \ [2] Ouro-Burn-Fee      := Part of the Ouro-Redeem-Amount that is burned as Auryn Uncoil fee \
        \ [3] Promile-Fee        := The Auryn Uncoil fee in promille that is applie to Auryn Uncoil transaction"

        ;;OuroRedeemAmount
        ;;OuroOutputAmount (needs Fee Percent)
        ;;OuroBurnFee (OuroRedeemAmount - OuroOutputAmount)
        ;;Fee Promille (depends on amount and position)
        (let*
            (
                (ouro-decimals:integer (at "decimals" (read DH_DPTS.DPTSPropertiesTable (U_OuroborosID) ["decimals"])))
                (auryndex:decimal (U_GetAuryndex))
                (ouro-redeem:decimal (floor (* auryn-input-amount auryndex) ouro-decimals))
                (uncoil-fee-promile:decimal (U_ComputeAurynUncoilFeePromile auryn-input-amount position))
                (ouro-burn-fee:decimal (floor (* (/ uncoil-fee-promile 1000.0) ouro-redeem) ouro-decimals))
                (ouro-output:decimal (- ouro-redeem ouro-burn-fee))
            )
            [ouro-redeem ouro-output ouro-burn-fee uncoil-fee-promile]
        )
    )
    ;;
    ;;      U_ComputeAurynUncoilFeePromile
    ;;
    (defun U_ComputeAurynUncoilFeePromile:decimal (x:decimal p:integer)
        @doc "Computes fee promile; x=auryn-input-amount, p=position"
        (let
            (
                (f1:decimal (dec (+ 7 p)))
                (f2:decimal (dec (+ 6 p)))
                (f3:decimal (dec (+ 5 p)))
                (f4:decimal (dec (+ 4 p)))
                (f5:decimal (dec (+ 3 p)))
                (f6:decimal (dec (+ 2 p)))
                (f7:decimal (dec (+ 1 p)))
            )
            (cond
                ((< x (at 0 AFT)) f1)
                ((and (>= x (at 0 AFT))(< x (at 1 AFT))) f2)
                ((and (>= x (at 1 AFT))(< x (at 2 AFT))) f3)
                ((and (>= x (at 2 AFT))(< x (at 3 AFT))) f4)
                ((and (>= x (at 3 AFT))(< x (at 4 AFT))) f5)
                ((and (>= x (at 4 AFT))(< x (at 5 AFT))) f6)
                f7
            )
        )
    ) 
    ;;
    ;;      U_ComputeUncoilDuration
    ;;
    (defun U_ComputeUncoilDuration:integer (client:string elite:bool)
        @doc "Computes Auryn or Elite-Auryn Uncoil Duration in Hours for client \
        \ The boolean Elite selects between Auryn (false) and Elite-Auryn (true)"

        (let*
            (
                (eab:decimal (DH_DPTS.U_GetDPTSBalance (U_EliteAurynID) client))
                (elite-object:object{EliteAccountSchema} (U_ComputeElite eab))
                (elite-tier:string (at "tier" elite-object))
                (major-elite-tier:integer (str-to-int (take 1 elite-tier)))
                (minor-elite-tier:integer (str-to-int (take -1 elite-tier)))
                (order:integer (+ (* (- major-elite-tier 1) 7 ) minor-elite-tier))
            )
            (if (= elite false)
                ;;Auryn Uncoil Duration
                (if (= major-elite-tier 0)
                    (at 0 AUHD)
                    (at order AUHD)
                )
                ;;Elite-Auryn Uncoil Duration
                (if (= major-elite-tier 0)
                    (at 0 EAUHD)
                    (at order EAUHD)
                )
            )
        )
    )
    ;;
    ;;      U_ComputeCullTime
    ;;
    (defun U_ComputeCullTime:time (client:string elite:bool)
        @doc "Computes Cull Time for Auryn or Elite-Auryn using Tx present time\
        \ The boolean Elite selects between Auryn (false) and Elite-Auryn (true)"

        (let
            (
                (present-time:time (at "block-time" (chain-data)))
                (auryn-uncoil-duration:integer (U_ComputeUncoilDuration client false))
                (elite-auryn-uncoil-duration:integer (U_ComputeUncoilDuration client true))
            )
            (if (= elite false)
                ;;Auryn Uncoil Duration
                (add-time present-time (hours auryn-uncoil-duration))
                ;;Elite-Auryn Uncoil Duration
                (add-time present-time (hours elite-auryn-uncoil-duration))
            )
        )
    )
    ;;
    ;;      U_GetUncoilPosition
    ;;
    (defun U_GetUncoilPosition:integer (client:string elite:bool)
        @doc "Gets best Auryn or Elite-Auryn uncoil Position \
        \ Assumes Uncoil Ledger already exits. If it doesnt, it will fail \
        \ Boolean elite trigger switches between Auryn (false) and Elite-Auryn(true)"

        (with-read UncoilLedger client
            { "P1" := o1, "P2" := o2, "P3" := o3, "P4" := o4, "P5" := o5, "P6" := o6, "P7" := o7 }
            (let*
                (
                    (ob1:decimal (at "au-ob" o1))
                    (ob2:decimal (at "au-ob" o2))
                    (ob3:decimal (at "au-ob" o3))
                    (ob4:decimal (at "au-ob" o4))
                    (ob5:decimal (at "au-ob" o5))
                    (ob6:decimal (at "au-ob" o6))
                    (ob7:decimal (at "au-ob" o7))
                    (ab1:decimal (at "eau-ab" o1))
                    (ab2:decimal (at "eau-ab" o2))
                    (ab3:decimal (at "eau-ab" o3))
                    (ab4:decimal (at "eau-ab" o4))
                    (ab5:decimal (at "eau-ab" o5))
                    (ab6:decimal (at "eau-ab" o6))
                    (ab7:decimal (at "eau-ab" o7))
                    (ouroborosbalancelist:[decimal] [ob1 ob2 ob3 ob4 ob5 ob6 ob7])
                    (aurynbalancelist:[decimal] [ab1 ab2 ab3 ab4 ab5 ab6 ab7])
                )
                (if (= elite false)
                    (U_GetZeroPosition ouroborosbalancelist)
                    (U_GetZeroPosition aurynbalancelist)
                )
            )
        )
    )
    ;;
    ;;      U_GetZeroPosition
    ;;
    (defun U_GetZeroPosition:integer (inputlist:[decimal])
        @doc "Returns best uncoil position from a list of balances \
        \ Best position is the first position with a 0.0 value. \
        \ Firt position is considered 1. When no more position are available, returns -1"

        (enforce (= (length inputlist) 7) "Uncoil balance List must be 7 elements long")
        (let
            (
                (position:integer 
                    (fold
                        (lambda
                            (accumulator:integer index:integer)     ;;lambda parameters
                            (if (and (= accumulator -1)(= (at index inputlist) 0.0))
                                index
                                accumulator
                            )                                       ;;lambda body
                        )                                           ;;lambda function
                        -1                                          ;;acumulator
                        (enumerate 0 (- (length inputlist) 1))            ;;list  
                    )
                )
            )
            (if (= position -1)
                -1
                (+ position 1)
            )
        )
    )
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      ADMINSTRATION FUNCTIONS
    ;;
    ;;      A_InitialiseAutostake 
    ;;
    (defun A_InitialiseAutostake (ouro-id:string)
        @doc "Initialises the Autostake Smart-Contract"
        (DH_DPTS.U_ValidateIdentifier ouro-id)

        (with-capability (INIT_AUTOSTAKE)
            ;;Issue Auryns Token
            (let
                (
                    (AurynID:string (DH_DPTS.C_IssueDPTS
                        SC_NAME
                        (keyset-ref-guard SC_KEY)
                        "Auryn"
                        "AURYN"
                        24
                        true    ;;can-change-owner
                        true    ;;can-upgrade
                        true    ;;can-add-special-role
                        true    ;;can-freeze
                        false   ;;can-wipe
                        false   ;;can-pause
                        true    ;;for creating a Smart Account with Issuance
                    ))
                    (EliteAurynID:string (DH_DPTS.C_IssueDPTS
                        SC_NAME
                        (keyset-ref-guard SC_KEY)
                        "EliteAuryn"
                        "ELITEAURYN"
                        24
                        true    ;;can-change-owner
                        true    ;;can-upgrade
                        true    ;;can-add-special-role
                        true    ;;can-freeze
                        false   ;;can-wipe
                        false   ;;can-pause
                        true    ;;for creating a Smart Account with Issuance
                    ))
                    (IgnisID:string (DH_DPTS.C_IssueDPTS
                        SC_NAME
                        (keyset-ref-guard SC_KEY)
                        "Ignis"
                        "IGNIS"
                        24
                        true    ;;can-change-owner
                        true    ;;can-upgrade
                        true    ;;can-add-special-role
                        true    ;;can-freeze
                        false   ;;can-wipe
                        false   ;;can-pause
                        true    ;;for creating a Smart Account with Issuance
                    ))
                )
                ;;Issue DPTS Account for AutostakePool for OURO
                (DH_DPTS.C_MakeStandardDPTSAccount ouro-id SC_NAME (keyset-ref-guard SC_KEY))
                ;;SetTrinityTable
                (insert TrinityTable TRINITY
                    {"ouro-id"                      : ouro-id
                    ,"auryn-id"                     : AurynID
                    ,"elite-auryn-id"               : EliteAurynID
                    ,"ignis-id"                     : IgnisID}
                )
                ;;SetAutostakeTable
                (insert AutostakeLedger AUTOSTAKEHOLDINGS
                    {"resident-ouro"                : 0.0
                    ,"unbonding-ouro"               : 0.0
                    ,"resident-auryn"               : 0.0
                    ,"unbonding-auryn"              : 0.0}  
                )
                ;;SetTokenRoles
                (DH_DPTS.C_SetBurnRole AurynID SC_NAME)
                (DH_DPTS.C_SetMintRole AurynID SC_NAME)
                (DH_DPTS.C_SetTransferRole AurynID SC_NAME)
                (DH_DPTS.C_SetBurnRole EliteAurynID SC_NAME)
                (DH_DPTS.C_SetMintRole EliteAurynID SC_NAME)
                (DH_DPTS.C_SetMintRole IgnisID SC_NAME)
                (DH_DPTS.C_SetTransferRole EliteAurynID SC_NAME)
                ;;Convert Autostake Account to a Smart-Contract Account and set up its properties
                (DH_DPTS.C_ControlSmartAccount SC_NAME false true)
            )    
        )
    )
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      CLIENT FUNCTIONS
    ;;

    ;;
    ;;      C_CoilOuroboros
    ;;
    (defun C_CoilOuroboros (client:string ouro-input-amount:decimal)
        @doc "Coils Ouroboros, staking it into the Autostake Pool, generating Auryn"

        (let
            (
                (auryn-output-amount:decimal (U_ComputeOuroCoil ouro-input-amount))
                (client-guard:guard (at "guard" (read DH_DPTS.DPTSBalancesTable (concat [(U_OuroborosID) DH_DPTS.IASPLITTER client]) ["guard"])))
            )
            (with-capability (COIL_OUROBOROS client ouro-input-amount auryn-output-amount)
            ;;Client Transfers OURO to Autostake (as method)
                (DH_DPTS.C_MethodicTransferDPTS (U_OuroborosID) client SC_NAME ouro-input-amount)
            ;;Autostake Updates Autostake Ledger (Resident OURO increase)
                (X_UpdateResidentOuro ouro-input-amount true)
            ;;Autostake Locally mints AURYN
                (X_MintAuryn auryn-output-amount)
            ;;Autostake Transfers AURYN To Client (as method)                
                (DH_DPTS.C_MethodicTransferDPTSAnew (U_AurynID) SC_NAME client client-guard auryn-output-amount)
            ;;Since user receives Auryn, Autostake makes/updates Elite Account Information
                (X_UpdateAurynzData client)
            )
        )
    )
    ;;
    ;;      C_FuelOuroboros
    ;;
    (defun C_FuelOuroboros (client:string ouro-input-amount:decimal)
        @doc "Fuels Ouroboros to the Autostake Pool, increasing Auryndex"
        (with-capability (FUEL_OUROBOROS client ouro-input-amount)
        ;;Client Transfers Ouroboros to Autostake pool efectively injecting Ouro into the Autostake pool
            (DH_DPTS.C_MethodicTransferDPTS (U_OuroborosID) client SC_NAME ouro-input-amount)
        ;;Autostake Updates Resident Ouro Information
            (X_UpdateResidentOuro ouro-input-amount true)
        )
    )
    ;;
    ;;      C_CoilAuryn
    ;;
    (defun C_CoilAuryn (client:string auryn-input-amount:decimal)
        @doc "Coils Auryn, securing it into the Autostake Pool, generating Elite-Auryn"
        (with-capability (COIL_AURYN client auryn-input-amount)
            (let
                (
                    (client-guard:guard (at "guard" (read DH_DPTS.DPTSBalancesTable (concat [(U_AurynID) DH_DPTS.IASPLITTER client]) ["guard"])))
                )
            ;;Client Transfers AURYN to Autostake (as method)
                (DH_DPTS.C_MethodicTransferDPTS (U_AurynID) client SC_NAME auryn-input-amount)
            ;;Autostake Updates Autostake Ledger (Resident Auryn increase)
                (X_UpdateResidentAuryn auryn-input-amount true)
            ;;Autostake Locally mints ELITEAURYN
                (X_MintEliteAuryn auryn-input-amount)
            ;;Autostake Transfers ELITEAURYN To Client
                (DH_DPTS.C_MethodicTransferDPTSAnew (U_EliteAurynID) SC_NAME client client-guard auryn-input-amount)
            ;;Since user receives Elite-Auryn, Autostake makes/updates Elite Account Information
                (X_UpdateAurynzData client) 
            )
        )
    )
    ;;
    ;;      C_CurlOuroboros
    ;;
    (defun C_CurlOuroboros (client:string ouro-input-amount:decimal)
        @doc "Curls Ouroboros, then Curls Auryn in a single Function"
        (with-capability (CURL_OUROBOROS client ouro-input-amount)
            (let
                (
                    (auryn-output-amount:decimal (U_ComputeOuroCoil ouro-input-amount))
                    (client-guard:guard (at "guard" (read DH_DPTS.DPTSBalancesTable (concat [(U_OuroborosID) DH_DPTS.IASPLITTER client]) ["guard"])))
                )  
            ;;Client Transfers OURO to Autostake (as method)
                (DH_DPTS.C_MethodicTransferDPTS (U_OuroborosID) client SC_NAME ouro-input-amount)
            ;;Autostake Locally mints AURYN
                (X_MintAuryn auryn-output-amount)
            ;;Autostake Updates its internal Table (Resident Ouro and Resident Auryn)
                (X_UpdateResidentOuro ouro-input-amount true)
                (X_UpdateResidentAuryn auryn-output-amount true)
            ;;Autostake Locally mints ELITEAURYN
                (X_MintEliteAuryn auryn-output-amount)
            ;;Autostake Transfers minted ELITEAURYN to client
                (DH_DPTS.C_MethodicTransferDPTSAnew (U_EliteAurynID) SC_NAME client client-guard auryn-output-amount)
            ;;Since client receives Elite-Auryn, Autostake makes/updates Elite Account Information
                (X_UpdateAurynzData client)   
            )
        )
    )
    ;;
    ;;      C_UncoilAuryn
    ;;
    (defun C_UncoilAuryn (client:string auryn-input-amount:decimal)
        @doc "Uncoils Auryn, generating Ouroboros for client and IGNIS for Autostake \
        \ Uses the best(cheapest) uncoil Position. This is determined automatically \
        \ and must not be entered as a parameter. When no position is available, function fails."
        
        (with-capability (UNCOIL-AURYN client auryn-input-amount)
        ;;UpdateAurynzData (needed to create UncoilLedger Data in case it doesnt exist)
            (X_UpdateAurynzData client)
            (let*
                (
                    (uncoil-position:integer (U_GetUncoilPosition client false))
                    (uncoil-data:[decimal] (U_ComputeAurynUncoil auryn-input-amount uncoil-position))
                    (ouro-redeem-amount:decimal (at 0 uncoil-data))
                    (ouro-output-amount:decimal (at 1 uncoil-data))
                    (ouro-burn-fee-amount:decimal (at 2 uncoil-data))
                    (cull-time:time (U_ComputeCullTime client false))
                    (client-guard:guard (at "guard" (read DH_DPTS.DPTSBalancesTable (concat [(U_OuroborosID) DH_DPTS.IASPLITTER client]) ["guard"])))
                )
                ;;Enforces a position is free for update, otherwise uncoil cannot execute
                    (enforce (!= uncoil-position -1) "No more Auryn Uncoil Positions")
                ;;Client Transfers AURYN to Autostake (as method) for burning
                    (DH_DPTS.C_MethodicTransferDPTS (U_AurynID) client SC_NAME auryn-input-amount)
                ;;Autostake Locally burns the whole AURYN transfered
                    (X_BurnAuryn auryn-input-amount)
                ;;Autostake Locally burns OURO (Ouro as uncoil fee; burning ouro automatically mints Ignis)
                    (X_BurnOuroboros ouro-burn-fee-amount)
                ;;Autostake Updates Autostake Ledger (Resident OURO decrease, Unbonding Ouro increase)
                    (X_UpdateResidentOuro ouro-redeem-amount false)
                    (X_UpdateUnbondingOuro ouro-output-amount true)
                ;;Autostake Updates Uncoil Ledger
                    (X_UpdateUncoilLedger client uncoil-position ouro-output-amount cull-time false)
                ;;cull-epoch.
            )
        )
    )
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      AUXILIARY FUNCTIONS
    ;;
    ;;      X_UpdateAurynzData
    ;;
    (defun X_UpdateAurynzData (account:string)
        @doc "Updates Data pertaining to Demiourgos Elite Account (perks for owning Elite-Auryn)"
        (with-capability (UPDATE_AURYNZ account)
            (let*
                (
                    (eab:decimal (DH_DPTS.U_GetDPTSBalance (U_EliteAurynID) account))
                    (elite:object{EliteAccountSchema} (U_ComputeElite eab))
                    (elite-tier:string (at "tier" elite))
                    (major-elite-tier:integer (str-to-int (take 1 elite-tier)))
                )
                (X_InitialiseUncoilLedger account)      ;works when not exist
                (if (not (or (= major-elite-tier 0) (= major-elite-tier 1)))
                    ;works because it was created above. Executed 
                    (X_UpdateUncoilLedgerWithElite account major-elite-tier) 
                    "No Update required for Uncoil Ledger on Elite"
                )
                (X_UpdateEliteTracker account)          ;works because Balance get is made with default read
            )
        )
    )
    ;;
    ;;      X_InitialiseUncoilLedger
    ;;
    (defun X_InitialiseUncoilLedger (account:string)
        @doc "Initialises Uncoil Ledger for Account \
        \ If Uncoil Ledger exists for account, it remains the same"

        (require-capability (SNAKE_TOKEN_OWNERSHIP account))
        ;;epoch, time, what time for zero
        (with-default-read UncoilLedger account
            { "P1" : { "au-ob": 0.0, "ae": NULLTIME, "eau-ab": 0.0, "eae": NULLTIME}
             ,"P2" : { "au-ob": 0.0, "ae": NULLTIME, "eau-ab": -1.0, "eae": ANTITIME}
             ,"P3" : { "au-ob": 0.0, "ae": NULLTIME, "eau-ab": -1.0, "eae": ANTITIME}
             ,"P4" : { "au-ob": 0.0, "ae": NULLTIME, "eau-ab": -1.0, "eae": ANTITIME}
             ,"P5" : { "au-ob": 0.0, "ae": NULLTIME, "eau-ab": -1.0, "eae": ANTITIME}
             ,"P6" : { "au-ob": 0.0, "ae": NULLTIME, "eau-ab": -1.0, "eae": ANTITIME}
             ,"P7" : { "au-ob": 0.0, "ae": NULLTIME, "eau-ab": -1.0, "eae": ANTITIME}
            }
            { "P1" := o1, "P2" := o2, "P3" := o3, "P4" := o4, "P5" := o5, "P6" := o6, "P7" := o7 }
            (write UncoilLedger account
                { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4, "P5" : o5, "P6" : o6, "P7" : o7 }
            )
        )
    )
    ;;
    ;;      X_UpdateUncoilLedgerWithElite
    ;;
    (defun X_UpdateUncoilLedgerWithElite (account:string major-elite-tier:integer)
        @doc "Updates Elite-Auryn Uncoil Ledger opening positions based on Major Elite Tier"
        (require-capability (UPDATE_UNCOIL_LEDGER))
        (with-capability (UNCOIL-LEDGER_MANAGING-TIER major-elite-tier)
            (XU_ManageEliteUncoilPositionWithTier account major-elite-tier)
        ) 
    )
    ;;
    ;;      X_UpdateEliteTracker
    ;;
    (defun X_UpdateEliteTracker (account:string)
        @doc "Updates Elite-Account Information which tracks Elite-Auryn Ammounts"
        (require-capability (UPDATE_ELITE_TRACKER))
        (let*
            (
                (eab:decimal (DH_DPTS.U_GetDPTSBalance (U_EliteAurynID) account))
                (elite:object{EliteAccountSchema} (U_ComputeElite eab))
                (elite-tier-class (at "class" elite))
                (elite-tier-name (at "name" elite))
                (elite-tier (at "tier" elite))
                (deb (at "deb" elite))
            )
            ;;Assumes that Account exists for Ouro, when an Elite Account Update is called.
            (require-capability (DH_DPTS.DPTS_ACCOUNT_OWNER (U_OuroborosID) account))
            (write EliteTracker account
                { "class"   : elite-tier-class
                , "name"    : elite-tier-name
                , "tier"    : elite-tier
                , "deb"     : deb
                }  
            )
        )
    )
    ;;
    ;;      X_UpdateUncoilLedger
    ;;
    (defun X_UpdateUncoilLedger (account:string position:integer balance:decimal epoch:time elite:bool)
        @doc "Updates Uncoil Ledgers which tracks uncoil Data \
        \ Assumes Uncoil Ledger has been initialised and exists for account"
        (require-capability (UPDATE_UNCOIL_LEDGER))
        
        (with-read UncoilLedger account
            { "P1" := o1, "P2" := o2, "P3" := o3, "P4" := o4, "P5" := o5, "P6" := o6, "P7" := o7 }
            (let*
                (
                    (o1v1 (at "au-ob" o1))
                    (o1v2 (at "ae" o1))
                    (o1v3 (at "eau-ab" o1))
                    (o1v4 (at "eae" o1))
                    (o1n { "au-ob":balance, "ae":epoch, "eau-ab":o1v3, "eae":o1v4})
                    (o1e { "au-ob":o1v1, "ae":o1v2, "eau-ab":balance, "eae":epoch})

                    (o2v1 (at "au-ob" o2))
                    (o2v2 (at "ae" o2))
                    (o2v3 (at "eau-ab" o2))
                    (o2v4 (at "eae" o2))
                    (o2n { "au-ob":balance, "ae":epoch, "eau-ab":o2v3, "eae":o2v4})
                    (o2e { "au-ob":o2v1, "ae":o2v2, "eau-ab":balance, "eae":epoch})

                    (o3v1 (at "au-ob" o3))
                    (o3v2 (at "ae" o3))
                    (o3v3 (at "eau-ab" o3))
                    (o3v4 (at "eae" o3))
                    (o3n { "au-ob":balance, "ae":epoch, "eau-ab":o3v3, "eae":o3v4})
                    (o3e { "au-ob":o3v1, "ae":o3v2, "eau-ab":balance, "eae":epoch})

                    (o4v1 (at "au-ob" o4))
                    (o4v2 (at "ae" o4))
                    (o4v3 (at "eau-ab" o4))
                    (o4v4 (at "eae" o4))
                    (o4n { "au-ob":balance, "ae":epoch, "eau-ab":o4v3, "eae":o4v4})
                    (o4e { "au-ob":o4v1, "ae":o4v2, "eau-ab":balance, "eae":epoch})

                    (o5v1 (at "au-ob" o5))
                    (o5v2 (at "ae" o5))
                    (o5v3 (at "eau-ab" o5))
                    (o5v4 (at "eae" o5))
                    (o5n { "au-ob":balance, "ae":epoch, "eau-ab":o5v3, "eae":o5v4})
                    (o5e { "au-ob":o5v1, "ae":o5v2, "eau-ab":balance, "eae":epoch})

                    (o6v1 (at "au-ob" o6))
                    (o6v2 (at "ae" o6))
                    (o6v3 (at "eau-ab" o6))
                    (o6v4 (at "eae" o6))
                    (o6n { "au-ob":balance, "ae":epoch, "eau-ab":o6v3, "eae":o6v4})
                    (o6e { "au-ob":o6v1, "ae":o6v2, "eau-ab":balance, "eae":epoch})

                    (o7v1 (at "au-ob" o7))
                    (o7v2 (at "ae" o7))
                    (o7v3 (at "eau-ab" o7))
                    (o7v4 (at "eae" o7))
                    (o7n { "au-ob":balance, "ae":epoch, "eau-ab":o7v3, "eae":o7v4})
                    (o7e { "au-ob":o7v1, "ae":o7v2, "eau-ab":balance, "eae":epoch})
                )
                (cond
                    (   ;;Position 1
                        (and (= position 1)(= elite false))
                        (write UncoilLedger account 
                            { "P1" : o1n, "P2" : o2, "P3" : o3, "P4" : o4, "P5" : o5, "P6" : o6, "P7" : o7 }
                        )
                    )
                    (
                        (and (= position 1)(= elite true))
                        (write UncoilLedger account
                            { "P1" : o1e, "P2" : o2, "P3" : o3, "P4" : o4, "P5" : o5, "P6" : o6, "P7" : o7 }
                        )
                    )
                    (   ;;Position 2
                        (and (= position 2)(= elite false))
                        (write UncoilLedger account
                            { "P1" : o1, "P2" : o2n, "P3" : o3, "P4" : o4, "P5" : o5, "P6" : o6, "P7" : o7 }
                        )
                    )
                    (
                        (and (= position 2)(= elite true))
                        (write UncoilLedger account
                            { "P1" : o1, "P2" : o2e, "P3" : o3, "P4" : o4, "P5" : o5, "P6" : o6, "P7" : o7 }
                        )
                    )
                    (   ;;Position 3
                        (and (= position 3)(= elite false))
                        (write UncoilLedger account
                            { "P1" : o1, "P2" : o2, "P3" : o3n, "P4" : o4, "P5" : o5, "P6" : o6, "P7" : o7 }
                        )
                    )
                    (
                        (and (= position 3)(= elite true))
                        (write UncoilLedger account
                            { "P1" : o1, "P2" : o2, "P3" : o3e, "P4" : o4, "P5" : o5, "P6" : o6, "P7" : o7 }
                        )
                    )
                    (   ;;Position 4
                        (and (= position 4)(= elite false))
                        (write UncoilLedger account
                            { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4n, "P5" : o5, "P6" : o6, "P7" : o7 }
                        )
                    )
                    (
                        (and (= position 4)(= elite true))
                        (write UncoilLedger account
                            { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4e, "P5" : o5, "P6" : o6, "P7" : o7 }
                        )
                    )
                    (   ;;Position 5
                        (and (= position 5)(= elite false))
                        (write UncoilLedger account
                            { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4, "P5" : o5n, "P6" : o6, "P7" : o7 }
                        )
                    )
                    (
                        (and (= position 5)(= elite true))
                        (write UncoilLedger account
                            { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4, "P5" : o5e, "P6" : o6, "P7" : o7 }
                        )
                    )
                    (   ;;Position 6
                        (and (= position 6)(= elite false))
                        (write UncoilLedger account
                            { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4, "P5" : o5, "P6" : o6n, "P7" : o7 }
                        )
                    )
                    (
                        (and (= position 6)(= elite true))
                        (write UncoilLedger account
                            { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4, "P5" : o5, "P6" : o6e, "P7" : o7 }
                        )
                    )
                    (   ;;Position 7
                        (and (= position 7)(= elite false))
                        (write UncoilLedger account
                            { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4, "P5" : o5, "P6" : o6, "P7" : o7n }
                        )
                    )
                    (   ;;Position 7
                        (and (= position 7)(= elite true))
                        (write UncoilLedger account
                            { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4, "P5" : o5, "P6" : o6, "P7" : o7e }
                        )
                    )
                    "Invalid Position for Update"
                )
            )
        )
    )
    ;;
    ;;      X_BurnOuroboros 
    ;;
    (defun X_BurnOuroboros (amount:decimal)
        @doc "Burns Ouroboros and generates Ignis at 100x capacity"
        (let*
            (
                (ignis-decimals:integer (at "decimals" (read DH_DPTS.DPTSPropertiesTable (U_IgnisID) ["decimals"])))
                (ignis-mint-amount:decimal (floor (* amount 100.0) ignis-decimals))
            )
            (require-capability (BURN_OUROBOROS (U_OuroborosID) (U_IgnisID) SC_NAME))
            (DH_DPTS.C_BurnDPTS (U_OuroborosID) SC_NAME amount)
            (DH_DPTS.C_MintDPTS (U_IgnisID) SC_NAME ignis-mint-amount)      
        )
    )
    ;;
    ;;      X_BurnAuryn
    ;;
    (defun X_BurnAuryn (amount:decimal)
        @doc "Burns Auryn"
        (require-capability (BURN_AURYN (U_AurynID) SC_NAME))
        (DH_DPTS.C_BurnDPTS (U_AurynID) SC_NAME amount)
    )
    ;;
    ;;      X_BurnEliteAuryn
    ;;
    (defun X_BurnEliteAuryn (amount:decimal)
        @doc "Burns Elite-Auryn"
        (require-capability (BURN_ELITE-AURYN (U_EliteAurynID) SC_NAME))
        (DH_DPTS.C_BurnDPTS (U_EliteAurynID) SC_NAME amount)
    )
    ;;
    ;;      X_MintOuro
    ;;
    (defun X_MintOuro (amount:decimal)
        @doc "Mints Ouroboros"
        (require-capability (MINT_OUROBOROS (U_OuroborosID) SC_NAME))
        (DH_DPTS.C_MintDPTS (U_OuroborosID) SC_NAME amount)
    )
    ;;
    ;;      X_MintAuryn
    ;;
    (defun X_MintAuryn (amount:decimal)
        @doc "Mints Auryn"
        (require-capability (MINT_AURYN (U_AurynID) SC_NAME))
        (DH_DPTS.C_MintDPTS (U_AurynID) SC_NAME amount)
    )
    ;;
    ;;      X_MintEliteAuryn
    ;;
    (defun X_MintEliteAuryn (amount:decimal)
        @doc "Mints Elite-Auryn"
        (require-capability (MINT_ELITE-AURYN (U_EliteAurynID) SC_NAME))
        (DH_DPTS.C_MintDPTS (U_EliteAurynID) SC_NAME amount)
    )
    ;;
    ;;      X_UpdateResidentOuro
    ;;
    (defun X_UpdateResidentOuro (amount:decimal direction:bool)
        @doc "Updates the Resident Ouro in the Autostake Ledger \
        \ Direction true increases amount, false decreases amount"

        (require-capability (UPDATE_AUTOSTAKE_LEDGER))
        (with-read AutostakeLedger AUTOSTAKEHOLDINGS
            {"resident-ouro" := ro }
            (if 
                (= direction true)
                (update AutostakeLedger AUTOSTAKEHOLDINGS { "resident-ouro" : (+ ro amount)})
                (let
                    (
                        (decrease:decimal (- ro amount)) 
                    )
                    (enforce (>= decrease 0.0) "Resident Ouro cannot become negative")
                    (update AutostakeLedger AUTOSTAKEHOLDINGS { "resident-ouro" : decrease})
                )
            )
        )
    )
    ;;
    ;;      X_UpdateResidentAuryn
    ;;
    (defun X_UpdateResidentAuryn (amount:decimal direction:bool)
        @doc "Updates the Resident Auryn in the Autostake Ledger \
        \ Direction true increases amount, false decreases amount"

        (require-capability (UPDATE_AUTOSTAKE_LEDGER))
        (with-read AutostakeLedger AUTOSTAKEHOLDINGS
            {"resident-auryn" := ra }
            (if 
                (= direction true)
                (update AutostakeLedger AUTOSTAKEHOLDINGS { "resident-auryn" : (+ ra amount)})
                (let
                    (
                        (decrease:decimal (- ra amount)) 
                    )
                    (enforce (>= decrease 0.0) "Resident Auryn cannot become negative")
                    (update AutostakeLedger AUTOSTAKEHOLDINGS { "resident-auryn" : decrease})
                )
            )
        )
    )
    ;;
    ;;      X_UpdateUnbondingOuro
    ;;
    (defun X_UpdateUnbondingOuro (amount:decimal direction:bool)
        @doc "Updates the Unbonding Ouro in the Autostake Ledger \
        \ Direction true increases amount, false decreases amount"

        (require-capability (UPDATE_AUTOSTAKE_LEDGER))
        (with-read AutostakeLedger AUTOSTAKEHOLDINGS
            {"unbonding-ouro" := uo }
            (if 
                (= direction true)
                (update AutostakeLedger AUTOSTAKEHOLDINGS { "unbonding-ouro" : (+ uo amount)})
                (let
                    (
                        (decrease:decimal (- uo amount)) 
                    )
                    (enforce (>= decrease 0.0) "Unbonding Ouro cannot become negative")
                    (update AutostakeLedger AUTOSTAKEHOLDINGS { "unbonding-ouro" : decrease})
                )
            )
        )
    )
    ;;
    ;;      X_UpdateUnbondingAuryn
    ;;
    (defun X_UpdateUnbondingAuryn (amount:decimal direction:bool)
        @doc "Updates the Unbonding Auryn in the Autostake Ledger \
        \ Direction true increases amount, false decreases amount"

        (require-capability (UPDATE_AUTOSTAKE_LEDGER))
        (with-read AutostakeLedger AUTOSTAKEHOLDINGS
            {"unbonding-auryn" := ua }
            (if 
                (= direction true)
                (update AutostakeLedger AUTOSTAKEHOLDINGS { "unbonding-auryn" : (+ ua amount)})
                (let
                    (
                        (decrease:decimal (- ua amount)) 
                    )
                    (enforce (>= decrease 0.0) "Unbonding Auryn cannot become negative")
                    (update AutostakeLedger AUTOSTAKEHOLDINGS { "unbonding-auryn" : decrease})
                )
            )
        )
    )
    ;;
    ;;      ManageEliteUncoilPositionWithTier
    ;;
    (defun XU_ManageEliteUncoilPositionWithTier(account:string tier:integer)
        @doc "Manages Elite Auryn uncoil position based on Major Elite Tier Value"
        (enforce (contains tier (enumerate 2 7)) "Invalid Tier for Elite Uncoil Position Management")
        (require-capability (UNCOIL-LEDGER_MANAGING-TIER tier))
        (let
            (
                (hexa:[bool] (XU_MakeHexaBooleanList tier))
            )
            (with-capability (UNCOIL-LEDGER_MANAGING-POSITION 2)
                (XU_ToggleEliteUncoilPosition account 2 (at 0 hexa))   ;;manages position 2
            )
            (with-capability (UNCOIL-LEDGER_MANAGING-POSITION 3)
                (XU_ToggleEliteUncoilPosition account 3 (at 1 hexa))   ;;manages position 3
            )
            (with-capability (UNCOIL-LEDGER_MANAGING-POSITION 4)
                (XU_ToggleEliteUncoilPosition account 4 (at 2 hexa))   ;;manages position 4
            )
            (with-capability (UNCOIL-LEDGER_MANAGING-POSITION 5)
                (XU_ToggleEliteUncoilPosition account 5 (at 3 hexa))   ;;manages position 5
            )
            (with-capability (UNCOIL-LEDGER_MANAGING-POSITION 6)
                (XU_ToggleEliteUncoilPosition account 6 (at 4 hexa))   ;;manages position 6
            )
            (with-capability (UNCOIL-LEDGER_MANAGING-POSITION 7)
                (XU_ToggleEliteUncoilPosition account 7 (at 5 hexa))   ;;manages position 7
            )
        )
    )
    ;;
    ;;      XU_MakeHexaBooleanList
    ;;
    (defun XU_MakeHexaBooleanList:[bool] (tier:integer)
        @doc "Creates a list of 6 bolean values depending based on Major Elite Tier Value"
        (require-capability (UNCOIL-LEDGER_MANAGING-TIER tier))
        (cond
            ((= tier 2) [true false false false false false])
            ((= tier 3) [true true false false false false])
            ((= tier 4) [true true true false false false])
            ((= tier 5) [true true true true false false])
            ((= tier 6) [true true true true true false])
            [true true true true true true]
        )
    )
    ;;
    ;;      XU_ToggleEliteUncoilPosition
    ;;
    (defun XU_ToggleEliteUncoilPosition (account:string position:integer toggle:bool)
        @doc "Opens Elite Auryn Uncoil Position if is closed; If it is already opened or in use, leave as is. \
        \ Closes Elite Auryn Uncoil Position if it is opened; If it is already closed or in use, leave as is. \
        \ Opening or Closing is done via the boolean trigged toggle. True will execute opening, False closing \
        \ Assume Uncoil Ledger already exists for account "

        ;;Enforce position is from 2 to 7
        (require-capability (UNCOIL-LEDGER_MANAGING-POSITION position))

        (with-read UncoilLedger account 
            { "P1":= o1, "P2":= o2,  "P3":= o3, "P4":= o4,  "P5":= o5,  "P6":= o6,  "P7":= o7 }  
            (let*
                (
                    (b2:decimal (at "eau-ab" o2))
                    (b3:decimal (at "eau-ab" o3))
                    (b4:decimal (at "eau-ab" o4))
                    (b5:decimal (at "eau-ab" o5))
                    (b6:decimal (at "eau-ab" o6))
                    (b7:decimal (at "eau-ab" o7))

                    (o2v1 (at "au-ob" o2))
                    (o2v2 (at "ae" o2))
                    (o2z { "au-ob":o2v1, "ae":o2v2, "eau-ab":0.0, "eae":NULLTIME})
                    (o2mo { "au-ob":o2v1, "ae":o2v2, "eau-ab":-1.0, "eae":ANTITIME})

                    (o3v1 (at "au-ob" o3))
                    (o3v2 (at "ae" o3))
                    (o3z { "au-ob":o3v1, "ae":o3v2, "eau-ab":0.0, "eae":NULLTIME})
                    (o3mo { "au-ob":o3v1, "ae":o3v2, "eau-ab":-1.0, "eae":ANTITIME})

                    (o4v1 (at "au-ob" o4))
                    (o4v2 (at "ae" o4))
                    (o4z { "au-ob":o4v1, "ae":o4v2, "eau-ab":0.0, "eae":NULLTIME})
                    (o4mo { "au-ob":o4v1, "ae":o4v2, "eau-ab":-1.0, "eae":ANTITIME})

                    (o5v1 (at "au-ob" o5))
                    (o5v2 (at "ae" o5))
                    (o5z { "au-ob":o5v1, "ae":o5v2, "eau-ab":0.0, "eae":NULLTIME})
                    (o5mo { "au-ob":o5v1, "ae":o5v2, "eau-ab":-1.0, "eae":ANTITIME})

                    (o6v1 (at "au-ob" o6))
                    (o6v2 (at "ae" o6))
                    (o6z { "au-ob":o6v1, "ae":o6v2, "eau-ab":0.0, "eae":NULLTIME})
                    (o6mo { "au-ob":o6v1, "ae":o6v2, "eau-ab":-1.0, "eae":ANTITIME})

                    (o7v1 (at "au-ob" o7))
                    (o7v2 (at "ae" o7))
                    (o7z { "au-ob":o7v1, "ae":o7v2, "eau-ab":0.0, "eae":NULLTIME})
                    (o7mo { "au-ob":o7v1, "ae":o7v2, "eau-ab":-1.0, "eae":ANTITIME})
                )
                (cond
                    (
                        (= position 2)
                        (if (= toggle true)
                            ;;Executes opening action
                            (if 
                                (= (with-capability (UNCOIL-LEDGER_BALANCE b2) (XU_CheckPositionState b2)) "closed")
                                (write UncoilLedger account
                                    { "P1" : o1, "P2" : o2z, "P3" : o3, "P4" : o4, "P5" : o5, "P6" : o6, "P7" : o7 }
                                )
                                (format "Elite-Auryn Uncoil Position {} remains unmodified for account {}" [position account])
                            )
                            ;;Executed closing action
                            (if 
                                (= (with-capability (UNCOIL-LEDGER_BALANCE b2) (XU_CheckPositionState b2)) "opened")
                                (write UncoilLedger account
                                    { "P1" : o1, "P2" : o2mo, "P3" : o3, "P4" : o4, "P5" : o5, "P6" : o6, "P7" : o7 }
                                )
                                (format "Elite-Auryn Uncoil Position {} remains unmodified for account {}" [position account])
                            )
                        )
                    )
                    (
                        (= position 3) 
                        (if (= toggle true)
                            ;;Executes opening action
                            (if 
                                (= (with-capability (UNCOIL-LEDGER_BALANCE b3) (XU_CheckPositionState b3)) "closed")
                                (write UncoilLedger account
                                    { "P1" : o1, "P2" : o2, "P3" : o3z, "P4" : o4, "P5" : o5, "P6" : o6, "P7" : o7 }
                                )
                                (format "Elite-Auryn Uncoil Position {} remains unmodified for account {}" [position account])
                            )
                            ;;Executed closing action
                            (if 
                                (= (with-capability (UNCOIL-LEDGER_BALANCE b3) (XU_CheckPositionState b3)) "opened")
                                (write UncoilLedger account
                                    { "P1" : o1, "P2" : o2, "P3" : o3mo, "P4" : o4, "P5" : o5, "P6" : o6, "P7" : o7 }
                                )
                                (format "Elite-Auryn Uncoil Position {} remains unmodified for account {}" [position account])
                            )
                        )
                    )
                    (
                        (= position 4) 
                        (if (= toggle true)
                            ;;Executes opening action
                            (if 
                                (= (with-capability (UNCOIL-LEDGER_BALANCE b4) (XU_CheckPositionState b4)) "closed")
                                (write UncoilLedger account
                                    { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4z, "P5" : o5, "P6" : o6, "P7" : o7 }
                                )
                                (format "Elite-Auryn Uncoil Position {} remains unmodified for account {}" [position account])
                            )
                            ;;Executed closing action
                            (if 
                                (= (with-capability (UNCOIL-LEDGER_BALANCE b4) (XU_CheckPositionState b4)) "opened")
                                (write UncoilLedger account
                                    { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4mo, "P5" : o5, "P6" : o6, "P7" : o7 }
                                )
                                (format "Elite-Auryn Uncoil Position {} remains unmodified for account {}" [position account])
                            )
                        )
                    )
                    (
                        (= position 5) 
                        (if (= toggle true)
                            ;;Executes opening action
                            (if 
                                (= (with-capability (UNCOIL-LEDGER_BALANCE b5) (XU_CheckPositionState b5)) "closed")
                                (write UncoilLedger account
                                    { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4, "P5" : o5z, "P6" : o6, "P7" : o7 }
                                )
                                (format "Elite-Auryn Uncoil Position {} remains unmodified for account {}" [position account])
                            )
                            ;;Executed closing action
                            (if 
                                (= (with-capability (UNCOIL-LEDGER_BALANCE b5) (XU_CheckPositionState b5)) "opened")
                                (write UncoilLedger account
                                    { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4, "P5" : o5mo, "P6" : o6, "P7" : o7 }
                                )
                                (format "Elite-Auryn Uncoil Position {} remains unmodified for account {}" [position account])
                            )
                        )
                    )
                    (
                        (= position 6) 
                        (if (= toggle true)
                            ;;Executes opening action
                            (if 
                                (= (with-capability (UNCOIL-LEDGER_BALANCE b6) (XU_CheckPositionState b6)) "closed")
                                (write UncoilLedger account
                                    { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4, "P5" : o5, "P6" : o6z, "P7" : o7 }
                                )
                                (format "Elite-Auryn Uncoil Position {} remains unmodified for account {}" [position account])
                            )
                            ;;Executed closing action
                            (if 
                                (= (with-capability (UNCOIL-LEDGER_BALANCE b6) (XU_CheckPositionState b6)) "opened")
                                (write UncoilLedger account
                                    { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4, "P5" : o5, "P6" : o6mo, "P7" : o7 }
                                )
                                (format "Elite-Auryn Uncoil Position {} remains unmodified for account {}" [position account])
                            )
                        )
                    )
                    (
                        (= position 7)
                        (if (= toggle true)
                            ;;Executes opening action
                            (if 
                                (= (with-capability (UNCOIL-LEDGER_BALANCE b7) (XU_CheckPositionState b7)) "closed")
                                (write UncoilLedger account
                                    { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4, "P5" : o5, "P6" : o6, "P7" : o7z }
                                )
                                (format "Elite-Auryn Uncoil Position {} remains unmodified for account {}" [position account])
                            )
                            ;;Executed closing action
                            (if 
                                (= (with-capability (UNCOIL-LEDGER_BALANCE b7) (XU_CheckPositionState b7)) "opened")
                                (write UncoilLedger account
                                    { "P1" : o1, "P2" : o2, "P3" : o3, "P4" : o4, "P5" : o5, "P6" : o6, "P7" : o7mo }
                                )
                                (format "Elite-Auryn Uncoil Position {} remains unmodified for account {}" [position account])
                            )
                        )
                    )
                    "Togle Elite Auryn Uncoil hasnt changed any position !"
                )
            )
        )
    )
    ;;
    ;;      XU_CheckPositionState
    ;;
    (defun XU_CheckPositionState:string (balance:decimal)
        @doc "Check Uncoil position state"
        (require-capability (UNCOIL-LEDGER_BALANCE balance))
        (cond
            ((= balance 0.0) "opened")
            ((= balance -1.0) "closed")
            "used"
        )
    )
)

(create-table TrinityTable)
(create-table AutostakeLedger)
(create-table EliteTracker)
(create-table UncoilLedger)