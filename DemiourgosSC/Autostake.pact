(module DH_SC_Autostake GOVERNANCE
    @doc "DH_SC_Autostake is the Demiourgos.Holdings Smart-Contract for Autostake of Ouroboros and Auryn Tokens \
    \ It manages the Coil|Curl functions for Ouroboros|Auryn|Elite-Auryn, and the generator of Auryndex"

    ;;CONSTANTS
    ;;Smart-Contract Key and Name Definitions
    (defconst SC_KEY "free.DH_SC_Autostake_Key")
    (defconst SC_NAME "Snake_Autostake")

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
    (defconst BAR DPTS.BAR)
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
        vested-elite-auryn-id:string
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
    (defcap AUTOSTAKE_INIT ()
        (compose-capability (AUTOSTAKE_MASTER))
        (compose-capability (AUTOSTAKE_GENESIS))
    )
    (defcap AUTOSTAKE_MASTER ()
        (enforce-one
            "Either Demiourgos Trinity or Vesting Key can perform Vesting"
            [
                (compose-capability (AUTOSTAKE_ADMIN))
                (compose-capability (DPTS.DPTS_ADMIN))
            ]
        )
    )
    (defcap AUTOSTAKE_ADMIN ()
        (enforce-guard (keyset-ref-guard SC_KEY))
    )
    (defcap AUTOSTAKE_GENESIS ()
        @doc "Ensure AutostakeLedger is empty. This allows for Autostake initialisation \
            \ IF Autostake was already initialise, re-initialising it wont work a second time"

        (with-default-read AutostakeLedger AUTOSTAKEHOLDINGS
            { "resident-ouro" : 0.0 }
            { "resident-ouro" := ro }
            (enforce (= ro 0.0) (format "Autostake Holdings already have {} Resident Ouroboros" [ro]))
        )
    )
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
    ;;      CORE                                                                                                                                        ;;
    ;;                                                                                                                                                  ;;
    ;;      GOVERNANCE                              Module Governance Capability                                                                        ;;
    ;;      AUTOSTAKE_INIT                          Module Initialisation Capability                                                                    ;;
    ;;      AUTOSTAKE_MASTER                        Module Mastery Capability                                                                           ;;
    ;;      AUTOSTAKE_ADMIN                         Module Admin Capability                                                                             ;;
    ;;      AUTOSTAKE_GENESIS                       Module Genesis Capability                                                                           ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      BASIC                                                                                                                                       ;;
    ;;      UPDATE_AURYNZ                           Capability required to update Auryns Data (UncoilLedger and Elitetracker)                           ;;
    ;;      SNAKE_TOKEN_OWNERSHIP                   Capability enforcing Snake Token Account Ownership                                                  ;;
    ;;      UPDATE_UNCOIL_LEDGER                    Capability to update the UncoilLedger                                                               ;;
    ;;      UPDATE_ELITE_TRACKER                    Capability to update the EliteTracker                                                               ;;
    ;;      UPDATE_AUTOSTAKE_LEDGER                 Capability to pdate the AutostakeLedger                                                             ;;
    ;;      UNCOIL-LEDGER_BALANCE                   Enforces Decimal as Uncoil Ledger Valid Decimal                                                     ;;
    ;;      UNCOIL-LEDGER_MANAGING-POSITION         Enforces Integer as Uncoil Ledger Elite-Auryn Uncoil optional position                              ;;
    ;;      UNCOIL-LEDGER_MANAGING-TIER             Enforces Integer as Uncoil Ledger Elite-Auryn Uncoil optional position                              ;;
    ;;      CULL_EXECUTOR                           Capability required to Cull UncoilLedger cullable positions                                         ;;
    ;;      CULLABLE                                Capability that enforces Auryn|Elite-Auryn Uncoil Position is cullable for <account>                ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      COMPOSED                                                                                                                                    ;;
    ;;                                                                                                                                                  ;;
    ;;      BURN_OUROBOROS                          Capability required to burn Ouroboros                                                               ;;
    ;;      BURN_AURYN                              Capability required to burn Auryn                                                                   ;;
    ;;      BURN_ELITE-AURYN                        Capability required to burn Elite-Auryn                                                             ;;
    ;;      MINT_OUROBOROS                          Capability required to mint Ouroboros                                                               ;;
    ;;      MINT_AURYN                              Capability required to mint Auryn                                                                   ;;
    ;;      MINT_ELITE-AURYN                        Capability required to mint Elite-Auryn                                                             ;;
    ;;                                                                                                                                                  ;;
    ;;      COIL_OUROBOROS                          Capability required for Coil of Ouroboros                                                           ;;
    ;;      FUEL_OUROBOROS                          Capability required for Autostake Fueling                                                           ;;
    ;;      COIL-AURYN                              Capability required for Coil of Auryn                                                               ;;
    ;;      CURL-OUROBOROS                          Capability required for Curl of Ouroboros                                                           ;;
    ;;      UNCOIL-AURYN                            Capability required for Uncoil of Auryn                                                             ;;
    ;;      CULL_OUROBOROS                          Capability required for Cull of Ouroboros                                                           ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;
    ;;      CAPABILITIES
    ;;
    ;;      BASIC
    ;;
    (defcap UPDATE_AURYNZ (account:string)
        (compose-capability (SNAKE_TOKEN_OWNERSHIP account))
        (compose-capability (UPDATE_UNCOIL_LEDGER))
        (compose-capability (UPDATE_ELITE_TRACKER))
    )
    (defcap SNAKE_TOKEN_OWNERSHIP (account:string)
        (let
            (
                (iz-sc:bool (at 0 (DPTS.U_GetDPTSAccountType account)))
            )
            (if (= iz-sc true)
                true
                (enforce-one
                    (format "Account ownership is not enforced for {} Account" [account])
                    [
                        (compose-capability (DPTF.DPTF_ACCOUNT_OWNER (U_OuroborosID) account))
                        (compose-capability (DPTF.DPTF_ACCOUNT_OWNER (U_AurynID) account))
                        (compose-capability (DPTF.DPTF_ACCOUNT_OWNER (U_EliteAurynID) account))
                        (compose-capability (DPMF.DPMF_ACCOUNT_OWNER (U_VEliteAurynID) account))
                    ]
                )
            )

        ) 
    )
    (defcap UPDATE_UNCOIL_LEDGER ()
        @doc "Capability for managing update or Uncoil Ledger"
        true
    )
    (defcap UPDATE_ELITE_TRACKER ()
        @doc "Capability for managing update or Elite Tracker"
        true
    )
    (defcap UPDATE_AUTOSTAKE_LEDGER()
        true
    )
    (defcap UNCOIL-LEDGER_BALANCE (balance:decimal)
        @doc "Enforces Decimal as Uncoil Ledger Valid Decimal"
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
    (defcap CULL_EXECUTOR ()
        true    
    )
    (defcap CULLABLE (account:string position:integer elite:bool)
        @doc "Capability that enforce Auryn|Elite-Auryn Uncoil Position is cullable for Account"

        (enforce (contains position (enumerate 1 7)) "Invalid Position for culling!")
        (let*
            (
                (lp:integer (- position 1))
                (cull-boolean-slice:[bool] (U_CanCullUncoil account elite))
                (cull:bool (at lp cull-boolean-slice))
            )
            (if (= elite false)
                (enforce (= cull true) (format "Auryn Uncoil position {} is not cullable for DPTF Account {}" [position account]))
                (enforce (= cull true) (format "Elite-Auryn Uncoil position {} is not cullable for DPTF Account {}" [position account]))
            )
        )
        (compose-capability (UPDATE_UNCOIL_LEDGER))
    )
    ;;
    ;;---------------------------------------------------------------------------------------------------------
    ;;
    ;;      COMPOSED
    ;;
    (defcap BURN_OUROBOROS (ouro-identifier:string ignis-identifier:string account:string ouro-burn-amount:decimal)
        (compose-capability (DPTF.DPTF_BURN ouro-identifier account ouro-burn-amount))
        (compose-capability (DPTF.DPTF_MINT ignis-identifier account (U_ComputeIgnisMintAmount ouro-burn-amount)))
    )
    (defcap BURN_AURYN (auryn-identifier:string account:string auryn-amount:decimal)
        (compose-capability (DPTF.DPTF_BURN auryn-identifier account auryn-amount))
    )
    (defcap BURN_ELITE-AURYN (elite-auryn-identifier:string account:string elite-auryn-amount:decimal)
        (compose-capability (DPTF.DPTF_BURN elite-auryn-identifier account elite-auryn-amount))
    )
    (defcap MINT_OUROBOROS (ouro-identifier:string account:string ouro-amount:decimal)
        (compose-capability (DPTF.DPTF_MINT ouro-identifier account ouro-amount))
    )
    (defcap MINT_AURYN (auryn-identifier:string account:string auryn-amount:decimal)
        (compose-capability (DPTF.DPTF_MINT auryn-identifier account auryn-amount))
    )
    (defcap MINT_ELITE-AURYN (elite-auryn-identifier:string account:string elite-auryn-amount:decimal)
        (compose-capability (DPTF.DPTF_MINT elite-auryn-identifier account elite-auryn-amount))
    )
    (defcap COIL_OUROBOROS(client:string ouro-input-amount:decimal)

    (let 
        (
            (auryn-computed-amount:decimal (U_ComputeOuroCoil ouro-input-amount))
        )
    ;;0]Any Client can perform <C_CoilOuroboros>; Smart DPTS Accounts arent required to provide their guards
        (compose-capability (DPTF.DPTF_CLIENT (U_OuroborosID) client))
    ;;1]<client> Account transfers as method <OURO|Ouroboros> to the <Snake_Autostake> Account for coiling(autostaking)
        (compose-capability (DPTF.TRANSFER_DPTF (U_OuroborosID) client SC_NAME ouro-input-amount true))
    ;;2]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (+)
        (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
    ;;3]<Snake_Autostake> Account mints <AURYN|Auryn>
        (compose-capability (MINT_AURYN (U_AurynID) SC_NAME (U_ComputeOuroCoil ouro-input-amount)))
    ;;4]<Snake_Autostake> Account transfers as method <AURYN|Auryn> to <client> Account
        (compose-capability (DPTF.TRANSFER_DPTF (U_AurynID) SC_NAME client auryn-computed-amount true))  
    ;;5]<UncoilLedger> and <EliteTracker> are updated with the operation
        (compose-capability (UPDATE_AURYNZ client))
    )

    
    )
    (defcap FUEL_OUROBOROS(client:string ouro-input-amount:decimal)
    ;;0]Any Client can perform <C_FuelOuroboros>; Smart DPTS Accounts arent required to provide their guards
        (compose-capability (DPTF.DPTF_CLIENT (U_OuroborosID) client))
    ;;1]<client> Account transfers as method <OURO|Ouroboros> to the <Snake_Autostake> Account, for fueling (fueling does not generate <AURYN|Auryn>)
        (compose-capability (DPTF.TRANSFER_DPTF (U_OuroborosID) client SC_NAME ouro-input-amount true))
    ;;2]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (+)
        (compose-capability (UPDATE_AUTOSTAKE_LEDGER))  
    )
    (defcap COIL_AURYN(client:string auryn-input-amount:decimal)
    ;;0]Any Client can perform <C_CoilAuryn>; Smart DPTS Accounts arent required to provide their guards
        (compose-capability (DPTF.DPTF_CLIENT (U_AurynID) client))
    ;;1]<client> Account transfers as method <AURYN|Auryn> to the <Snake_Autostake> Account for coiling(autostkaing)
        (compose-capability (DPTF.TRANSFER_DPTF (U_AurynID) client SC_NAME auryn-input-amount true))
    ;;2]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-auryn> (+)
        (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
    ;;3]<Snake_Autostake> Account mints <EAURYN|Elite-Auryn>
        (compose-capability (MINT_ELITE-AURYN (U_EliteAurynID) SC_NAME auryn-input-amount))
    ;;4]<Snake_Autostake> Account transfers as method <EAURYN|Elite-Auryn> to <client> Account
        (compose-capability (DPTF.TRANSFER_DPTF (U_EliteAurynID) SC_NAME client auryn-input-amount true))
    ;;5]<UncoilLedger> and <EliteTracker> are updated with the operation
        (compose-capability (UPDATE_AURYNZ client))
    )
    (defcap CURL_OUROBOROS(client:string ouro-input-amount:decimal)
        (let 
            (
                (auryn-computed-amount:decimal (U_ComputeOuroCoil ouro-input-amount))
            )
    ;;0]Any Client can perform <C_CurlOuroboros>; Smart DPTS Accounts arent required to provide their guards
        (compose-capability (DPTF.DPTF_CLIENT (U_OuroborosID) client))
    ;;1]<client> Account transfers as method <OURO|Ouroboros> to the <Snake_Autostake> Account for curling (double-coiling) 
        (compose-capability (DPTF.TRANSFER_DPTF (U_OuroborosID) client SC_NAME ouro-input-amount true))
    ;;2]<Snake_Autostake> Account mints <AURYN|Auryn>
        (compose-capability (MINT_AURYN (U_AurynID) SC_NAME auryn-computed-amount))
    ;;3]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (+)|<resident-auryn> (+)
        (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
    ;;4]<Snake_Autostake> Account mints <EAURYN|Elite-Auryn>
        (compose-capability (MINT_ELITE-AURYN (U_EliteAurynID) SC_NAME auryn-computed-amount))
    ;;5]<Snake_Autostake> Account transfers as method <EAURYN|Elite-Auryn> to <client> Account
        (compose-capability (DPTF.TRANSFER_DPTF (U_EliteAurynID) SC_NAME client auryn-computed-amount true))
    ;;6]<UncoilLedger> and <EliteTracker> are updated with the operation
        (compose-capability (UPDATE_AURYNZ client))
        )
    )
    (defcap UNCOIL_AURYN(client:string auryn-input-amount:decimal)
        (let*
            (
                (uncoil-position:integer (U_GetUncoilPosition client false))
                (uncoil-data:[decimal] (U_ComputeAurynUncoil auryn-input-amount uncoil-position))
                (ouro-burn-fee-amount:decimal (at 2 uncoil-data))
            )
    ;;0]Any Client can perform <C_UncoilAuryn>; Smart DPTS Accounts arent required to provide their guards
        (compose-capability (DPTF.DPTF_CLIENT (U_AurynID) client))
    ;;1]<UncoilLedger> and <EliteTracker> are updated with the operation; <UncoilLedger> must exist for operation
        (compose-capability (UPDATE_AURYNZ client))
    ;;2]<client> Account transfers as method <AURYN|Auryn> to <Snake_Autostake> Account for burning
        (compose-capability (DPTF.TRANSFER_DPTF (U_AurynID) client SC_NAME auryn-input-amount true))
    ;;3]<Snake_Autostake> Account burns the whole <AURYN|Auryn> transferred
        (compose-capability (BURN_AURYN (U_AurynID) SC_NAME auryn-input-amount))
    ;;4)<Snake_Autostake> Account burns <OURO|Ouroboros> as uncoil fee (burning <OURO|Ouroboros automatically mints <IGNIS|Ignis>)
        (compose-capability (BURN_OUROBOROS (U_OuroborosID) (U_IgnisID) SC_NAME ouro-burn-fee-amount))
    ;;5]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (-)|<unbonding-ouro> (+)
        (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
    ;;6*]<Snake_Autostake> Account updates <UncoilLedger>
        (compose-capability (UPDATE_UNCOIL_LEDGER)) ;;Capability already granted by (UPDATE_AURYNZ)
        )        
    )
    (defcap CULL_OUROBOROS(client:string culled-amount:decimal)
    ;;0]Any Client can perform <C_CullOuroboros>; Smart DPTS Accounts arent required to provide their guards
        (compose-capability (DPTF.DPTF_CLIENT (U_OuroborosID) client))
    ;;1]Snake_Autostake> Account transfers as method culled  <OURO|Ouroboros> to <client> Account
        (compose-capability (DPTF.TRANSFER_DPTF (U_OuroborosID) SC_NAME client culled-amount true))
    ;;2]<Snake_Autostake> Account updates <AutostakeLedger>|<unbonding-ouro> (-)
        (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
    )
    
    ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      PRIMARY Functions                       Stand-Alone Functions                                                                               ;;
    ;;                                                                                                                                                  ;;
    ;;      0)UTILITY                               Free Functions: can can be called by anyone. (Compute|Print|Read Functions)                         ;;
    ;;                                                  No Key|Guard required.                                                                          ;;
    ;;      1)ADMINISTRATOR                         Administrator Functions: can only be called by module administrator.                                ;;
    ;;                                                  Module Key|Guard required.                                                                      ;;
    ;;      2)CLIENT                                Client Functions: can be called by any DPMF Account.                                                ;;
    ;;                                                  Usually Client Key|Guard is required.                                                           ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      SECONDARY Functions                                                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;      3)AUXILIARY                             Auxiliary Functions: cannot be called on their own.                                                 ;;
    ;;                                                  Are Part of Client Function                                                                     ;;
    ;;                                                                                                                                                  ;;      
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      Functions Names are prefixed, so that they may be better visualised and understood.                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;      UTILITY                                 U_FunctionName                                                                                      ;;
    ;;      UTILITY AUXILIARY                       UX_FunctionName                                                                                     ;;
    ;;      ADMINISTRATION                          A_FunctionName                                                                                      ;;
    ;;      CLIENT                                  C_FunctionName                                                                                      ;;
    ;;      AUXILIARY                               X_FunctionName                                                                                      ;;
    ;;      AUXILIARY UTILITY                       XU_FunctionName                                                                                     ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      UTILITY FUNCTIONS                                                                                                                           ;;
    ;;                                                                                                                                                  ;;
    ;;==================ELITE_ACCOUNT===============                                                                                                    ;;                                  ;;
    ;;      U_ComputeElite                          Computes Elite Account Data                                                                         ;;
    ;;      U_PrintElite                            Prints Elite Account Data                                                                           ;;
    ;;      U_GetEliteTierClass                     Returns Demiourgos Elite Account Tier Class                                                         ;;
    ;;      U_GetEliteTierName                      Returns Demiourgos Elite Account Tier Name                                                          ;;
    ;;      U_GetMajorEliteTier                     Returns Demiourgos Elite Account Major Tier                                                         ;;
    ;;      U_GetMinorEliteTier                     Returns Demiourgos Elite Account Minor Tier                                                         ;;
    ;;      U_GetDEB                                Returns Demiourgos Elite Account Bonus (DEB)                                                        ;;
    ;;      UX_GetEliteTier                         Core Function that returns Major or Minor Elite Tier                                                ;;
    ;;      UX_GetEliteAurynzBalance                Returns Total Elite Auryn Balance (True and Meta Fungible)                                          ;;
    ;;==================IDENTIFIERS=================                                                                                                    ;;
    ;;      U_OuroborosID                           Returns as string the Ouroboros id                                                                  ;;
    ;;      U_AurynID                               Returns as string the Auryn id                                                                      ;;
    ;;      U_EliteAurynID                          Returns as string the Elite-Auryn id                                                                ;;
    ;;      U_IgnisID                               Returns as string the Ignis id                                                                      ;;
    ;;      U_VEliteAurynID                         Returns as string the Vested Elite-Auryn id                                                         ;;
    ;;==================AUTOSTAKE-LEDGER============                                                                                                    ;;
    ;;      U_GetResidentOuro                       Returns as decimal the amount of Resident Ouroboros                                                 ;;
    ;;      U_GetUnbondingOuro                      Returns as decimal the amount of Unbonding Ouroboros                                                ;;
    ;;      U_GetResidentAuryn                      Returns as decimal the amount of Resident Auryn                                                     ;;
    ;;      U_GetUnbondingAuryn                     Returns as decimal the amount of Unbonding Auryn                                                    ;;
    ;;      U_GetAuryndex                           Returns the value of Auryndex with 24 decimals                                                      ;;
    ;;==================COMPUTATIONS================                                                                                                    ;;
    ;;      U_ComputeIgnisMintAmount                Computes Ignis Mint amount from Ouro-burn-amount                                                    ;;
    ;;      U_ComputeOuroCoil                       Computes Ouro Coil Data: Outputs Auryn Output Amount                                                ;;
    ;;      U_ComputeAurynUncoil                    Computes Auryn Uncoil Data: Outputs Decimal List                                                    ;;
    ;;      U_ComputeAurynUncoilFeePromile          Computes Auryn Uncoil Fee Promile                                                                   ;;
    ;;      U_ComputeUncoilDuration                 Computes Auryn or Elite-Auryn Uncoil Duration in Hours for client                                   ;;
    ;;      U_ComputeCullTime                       Computes Cull Time for Auryn or Elite-Auryn using Tx present time                                   ;;
    ;;      U_ComputeTotalCull                      Computes the sum of all balances that are cullable for Account                                      ;;
    ;;==================UNCOIL-LEDGER_READINGS======                                                                                                    ;;
    ;;      U_GetUncoilAmount                       Reads UncoilLedger and outputs Uncoil Balance for Account and Position                              ;;
    ;;      U_GetCullAmount                         Reads UncoilLedger and outputs the Cull Balance for Account and Position                            ;;
    ;;      U_GetUncoilPosition                     Gets best Auryn or Elite-Auryn uncoil Position                                                      ;;
    ;;      U_CanCullUncoil                         Reads UncoilLedger and outputs a boolean list with cullable positions                               ;;
    ;;      UX_GetZeroPosition                      Returns best uncoil position from a list of balances                                                ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      ADMINISTRATOR FUNCTIONS                                                                                                                     ;;
    ;;                                                                                                                                                  ;;
    ;;      A_InitialiseAutostake                   Initialises the Autostake Smart-Contract                                                            ;;
    ;;      A_SaveVestedEliteAurynID                Saves Vested Elite Auryn ID in the Trinity Table                                                    ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      CLIENT FUNCTIONS                                                                                                                            ;;
    ;;                                                                                                                                                  ;;
    ;;      C_UpdateAurynzData                      Updates Data pertaining to Demiourgos Elite Account                                                 ;;
    ;;==================Coil|Curl|Fuel==============                                                                                                    ;;
    ;;      C_CoilOuroboros                         Coils Ouroboros, staking it into the Autostake Pool, generating Auryn                               ;;
    ;;      C_FuelOuroboros                         Fuels the Autostake Pool with Ouroboros, increasing the Auryndex                                    ;;
    ;;      C_CoilAuryn                             Coils Auryn, securing it into the Autostake Pool, generating Elite-Auryn                            ;;
    ;;      C_CurlOuroboros                         Curls Ouroboros, then Curls Auryn in a single Function                                              ;;
    ;;==================AURYN-UNCOIL================                                                                                                    ;;
    ;;      C_UncoilAuryn                           Initiates Auryn Uncoil - does not work if all Auryn Uncoil positions are occupied                   ;;
    ;;      C_CullOuroboros                         Culls all cullable Auryn Uncoil Positions collecting Ouroboros                                      ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      AUXILIARY FUNCTIONS                                                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================MINT|BURN-SNAKE-TOKENS======                                                                                                    ;;
    ;;      X_BurnOuroboros                         Burns Ouroboros and generates Ignis at 100x capacity                                                ;;
    ;;      X_BurnAuryn                             Burns Auryn                                                                                         ;;
    ;;      X_BurnEliteAuryn                        Burns EliteAuryn                                                                                    ;;
    ;;      X_MintOuroboros                         Mints Ouroboros                                                                                     ;;
    ;;      X_MintAuryn                             Mints Auryn                                                                                         ;;
    ;;      X_MintEliteAuryn                        Mints EliteAuryn                                                                                    ;;
    ;;==================UPDATE-AUTOSTAKE-LEDGER=====                                                                                                    ;;
    ;;      X_UpdateResidentOuro                    Updates the Resident Ouro in the Autostake Ledger                                                   ;;
    ;;      X_UpdateResidentAuryn                   Updates the Resident Auryn in the Autostake Ledger                                                  ;;
    ;;      X_UpdateUnbondingOuro                   Updates the Unbonding Ouro in the Autostake Ledger                                                  ;;
    ;;      X_UpdateUnbondingAuryn                  Updates the Unbonding Auryn in the Autostake Ledger                                                 ;;
    ;;==================CULL========================                                                                                                    ;;
    ;;      X_CullUncoilAll                         Processes all Uncoils positions for culling purposes for Account                                    ;;
    ;;      X_ExecuteCull                           Processes an Uncoil Position for culling purposes for Account                                       ;;
    ;;      X_CullUncoilSingle                      Culls Uncoil position for Auryn-Uncoil or Elite-Auryn-Uncoil                                        ;;
    ;;==================UNCOIL-LEDGER|ELITE_TRACKER=                                                                                                    ;;
    ;;      X_UpdateUncoilLedger                    Updates Uncoil Ledgers with New Uncoil Data                                                         ;;
    ;;      X_InitialiseUncoilLedger                Initialises Uncoil Ledger for Account                                                               ;;
    ;;      X_UpdateUncoilLedgerWithElite           Updates Elite-Auryn Uncoil Ledger positions based on Major Elite Tier                               ;;
    ;;      X_UpdateEliteTracker                    Updates Elite-Account Information which tracks Elite-Auryn Ammounts                                 ;;
    ;;                                                                                                                                                  ;;
    ;;      XU_ManageEliteUncoilPositionWithTier    Manages Elite Auryn uncoil position based on Major Elite Tier Value                                 ;;
    ;;      XU_MakeHexaBooleanList                  Creates a list of 6 bolean values depending based on Major Elite Tier Value                         ;;
    ;;      XU_ToggleEliteUncoilPosition            Opens or Closes Elite Auryn Uncoil Position depending on input parameters                           ;;
    ;;      XU_CheckPositionState                   Check Uncoil position state                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;
    ;;      UTILITY FUNCTIONS
    ;;
    ;;==================ELITE_ACCOUNT===============
    ;;      U_ComputeElite|U_PrintElite
    ;;      U_GetEliteTierClass|U_GetEliteTierName|U_GetMajorEliteTier|U_GetMinorEliteTier
    ;;      U_GetDEB|UX_GetEliteTier|UX_GetEliteAurynzBalance
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
    (defun U_PrintElite (account:string)
        @doc "Prints Elite Account Data"
        (with-default-read EliteTracker account
            { "class" : C1, "name" : N00, "tier" : "0.0" , "deb" : (at 0 DEB)}
            { "class" := c, "name" := n, "tier" := t, "deb" := d }
            (format "Account {}: Class = {}; Name = {}; Tier = {}; DEB = {};" [account c n t d])
        )
    )
    (defun U_GetEliteTierClass:decimal (account:string)

        (DPTS.U_ValidateAccount account)
        (let*
            (
                (eab:decimal (UX_GetEliteAurynzBalance account))
                (elite:object{EliteAccountSchema} (U_ComputeElite eab))
                (deb (at "class" elite))
            )
            deb
        ) 
    )
    (defun U_GetEliteTierName:decimal (account:string)
        (DPTS.U_ValidateAccount account)
        (let*
            (
                (eab:decimal (UX_GetEliteAurynzBalance account))
                (elite:object{EliteAccountSchema} (U_ComputeElite eab))
                (deb (at "name" elite))
            )
            deb
        ) 
    )
    (defun U_GetMajorEliteTier:integer (account:string)
        @doc "Gets Major Elite Tier for Account"

        (DPTS.U_ValidateAccount account)
        (UX_GetEliteTier account true)
    )
    (defun U_GetMinorEliteTier:integer (account:string)
        @doc "Gets Minor Elite Tier for Account"

        (DPTS.U_ValidateAccount account)
        (UX_GetEliteTier account false)
    )
    (defun U_GetDEB:decimal (account:string)

        (DPTS.U_ValidateAccount account)
        (let*
            (
                (eab:decimal (UX_GetEliteAurynzBalance account))
                (elite:object{EliteAccountSchema} (U_ComputeElite eab))
                (deb (at "deb" elite))
            )
            deb
        ) 
    )
    (defun UX_GetEliteTier:integer (account:string major:bool)
        @doc "Core Function that returns Major or Minor Elite Tier"

        (DPTS.U_ValidateAccount account)
        (let*
            (
                (eab:decimal (UX_GetEliteAurynzBalance account))
                (elite:object{EliteAccountSchema} (U_ComputeElite eab))
                (elite-tier:string (at "tier" elite))
                (major-elite-tier:integer (str-to-int (take 1 elite-tier)))
                (minor-elite-tier:integer (str-to-int (take -1 elite-tier)))
            )
            (if (= major true)
                major-elite-tier
                minor-elite-tier
            ) 
        )
    )
    (defun UX_GetEliteAurynzBalance:decimal (account:string)

        (DPTS.U_ValidateAccount account)
        (let
            (
                (eab:decimal (DPTF.U_GetAccountTrueFungibleSupply (U_EliteAurynID) account))
                (veab:decimal (DPMF.U_GetAccountMetaFungibleSupply (U_VEliteAurynID) account))
            )
            (+ eab veab)
        )
    )
    ;;==================IDENTIFIERS=================
    ;;      U_OuroborosID|U_AurynID|U_EliteAurynID|U_IgnisID|U_VEliteAurynID
    ;;
    (defun U_OuroborosID:string ()
        @doc "Returns as string the Ouroboros id"
        (at "ouro-id" (read TrinityTable TRINITY ["ouro-id"]))
    )
    (defun U_AurynID:string ()
        @doc "Returns as string the Auryn id"
        (at "auryn-id" (read TrinityTable TRINITY ["auryn-id"]))
    )
    (defun U_EliteAurynID:string ()
        @doc "Returns as string the Elite-Auryn id"
        (at "elite-auryn-id" (read TrinityTable TRINITY ["elite-auryn-id"]))
    )
    (defun U_IgnisID:string ()
        @doc "Returns as string the Ignis id"
        (at "ignis-id" (read TrinityTable TRINITY ["ignis-id"]))
    )
    (defun U_VEliteAurynID:string ()
        @doc "Returns as string the Ignis id"
        (at "vested-elite-auryn-id" (read TrinityTable TRINITY ["vested-elite-auryn-id"]))
    )
    ;;==================AUTOSTAKE-LEDGER============
    ;;      U_GetResidentOuro| U_GetUnbondingOuro|U_GetResidentAuryn|U_GetUnbondingAuryn
    ;;      U_GetAuryndex
    ;;
    (defun U_GetResidentOuro:decimal ()
        @doc "Returns as decimal the amount of Resident Ouroboros"
        (at "resident-ouro" (read AutostakeLedger AUTOSTAKEHOLDINGS ["resident-ouro"]))
    )
    (defun U_GetUnbondingOuro:decimal ()
        @doc "Returns as decimal the amount of Unbonding Ouroboros"
        (at "unbonding-ouro" (read AutostakeLedger AUTOSTAKEHOLDINGS ["unbonding-ouro"]))
    )
    (defun U_GetResidentAuryn:decimal ()
        @doc "Returns as decimal the amount of Resident Auryn"
        (at "resident-auryn" (read AutostakeLedger AUTOSTAKEHOLDINGS ["resident-auryn"]))
    )
    (defun U_GetUnbondingAuryn:decimal ()
        @doc "Returns as decimal the amount of Unbonding Auryn"
        (at "unbonding-auryn" (read AutostakeLedger AUTOSTAKEHOLDINGS ["unbonding-auryn"]))
    )
    (defun U_GetAuryndex:decimal ()
        @doc "Returns the value of Auryndex with 24 decimals"
        (let
            (
                (auryn-supply:decimal (DPTF.U_GetTrueFungibleSupply (U_AurynID)))
                (r-ouro-supply:decimal (U_GetResidentOuro))
            )
            (if
                (= auryn-supply 0.0)
                (floor 0.0 24)
                (floor (/ r-ouro-supply auryn-supply) 24)
            )
        )
    )


    ;;==================COMPUTATIONS================
    ;;
    ;;      U_ComputeIgnisMintAmount|U_ComputeOuroCoil|U_ComputeAurynUncoil|U_ComputeAurynUncoilFeePromile
    ;;      U_ComputeUncoilDuration|U_ComputeCullTime|U_ComputeTotalCull
    ;;
    (defun U_ComputeIgnisMintAmount:decimal (ouro-burn-amount:decimal)
        @doc "Computes Ignis Mint amount from Ouro-burn-amount"
        (let*
            (
                (ignis-decimals:integer (DPTF.U_GetTrueFungibleDecimals (U_IgnisID)))
                (ignis-mint-amount:decimal (floor (* ouro-burn-amount 100.0) ignis-decimals))
            )
            ignis-mint-amount
        )   
    )
    (defun U_ComputeOuroCoil:decimal (ouro-input-amount:decimal)
        @doc "Compute Ouroboros Coil Data. This amount includes: \
        \ Auryn Output Amount as decimal via Auryndex"

        (let
            (
                (auryndex:decimal (U_GetAuryndex))
                (r-ouro-supply:decimal (U_GetResidentOuro))
                (auryndecimals:integer (DPTF.U_GetTrueFungibleDecimals (U_AurynID)))
            )
            (if (= auryndex 0.0)
                ouro-input-amount
                (floor (/ ouro-input-amount auryndex) auryndecimals)
            )
        )
    )
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
                (ouro-decimals:integer (DPTF.U_GetTrueFungibleDecimals (U_OuroborosID)))
                (auryndex:decimal (U_GetAuryndex))
                (ouro-redeem:decimal (floor (* auryn-input-amount auryndex) ouro-decimals))
                (uncoil-fee-promile:decimal (U_ComputeAurynUncoilFeePromile auryn-input-amount position))
                (ouro-burn-fee:decimal (floor (* (/ uncoil-fee-promile 1000.0) ouro-redeem) ouro-decimals))
                (ouro-output:decimal (- ouro-redeem ouro-burn-fee))
            )
            [ouro-redeem ouro-output ouro-burn-fee uncoil-fee-promile]
        )
    )
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
    (defun U_ComputeUncoilDuration:integer (client:string elite:bool)
        @doc "Computes Auryn or Elite-Auryn Uncoil Duration in Hours for client \
        \ The boolean Elite selects between Auryn (false) and Elite-Auryn (true)"

        (let*
            (
                (eab:decimal (DPTF.U_GetAccountTrueFungibleSupply (U_EliteAurynID) client))
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
    (defun U_ComputeTotalCull:decimal (account:string elite:bool)
        @doc "Computes the sum of all balances that are cullable for Account \
        \ Can be used for either Auryn or Elite-Auryn (via boolean elite) \
        \ Similar to X_CullUncoilAll, but does not cull positions, \
        \ Only reads cullable balances and adds them up"

        (let*
            (
                (cull-boolean-slice:[bool] (U_CanCullUncoil account elite))
                (d1:decimal (U_GetCullAmount (at 0 cull-boolean-slice) account 1 elite))
                (d2:decimal (U_GetCullAmount (at 1 cull-boolean-slice) account 2 elite))
                (d3:decimal (U_GetCullAmount (at 2 cull-boolean-slice) account 3 elite))
                (d4:decimal (U_GetCullAmount (at 3 cull-boolean-slice) account 4 elite))
                (d5:decimal (U_GetCullAmount (at 4 cull-boolean-slice) account 5 elite))
                (d6:decimal (U_GetCullAmount (at 5 cull-boolean-slice) account 6 elite))
                (d7:decimal (U_GetCullAmount (at 6 cull-boolean-slice) account 7 elite))
                (valid-culled-balances:[decimal] [d1 d2 d3 d4 d5 d6 d7])
            )
            (fold (+) 0.0 valid-culled-balances)
        )
    )
    ;;==================UNCOIL-LEDGER_READINGS======
    ;;
    ;;      U_GetUncoilAmount|U_GetCullAmount|U_GetUncoilPosition
    ;;      U_CanCullUncoil|UX_GetZeroPosition
    ;;
    (defun U_GetUncoilAmount:decimal (account:string position:integer elite:bool)
        @doc "Reads UncoilLedger and outputs Uncoil Balance for Account and Position \
            \ Boolen elite toggle betwen Ouro balances (Auryn Uncoil) and Auryn balances (Elite-Auryn Uncoil)"

        (with-read UncoilLedger account
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

                    (o1v3:decimal (at "eau-ab" o1))
                    (o2v3:decimal (at "eau-ab" o2))
                    (o3v3:decimal (at "eau-ab" o3))
                    (o4v3:decimal (at "eau-ab" o4))
                    (o5v3:decimal (at "eau-ab" o5))
                    (o6v3:decimal (at "eau-ab" o6))
                    (o7v3:decimal (at "eau-ab" o7))

                    (ab1:decimal (if (= o1v3 -1.0) 0.0 o1v3))
                    (ab2:decimal (if (= o2v3 -1.0) 0.0 o2v3))
                    (ab3:decimal (if (= o3v3 -1.0) 0.0 o3v3))
                    (ab4:decimal (if (= o4v3 -1.0) 0.0 o4v3))
                    (ab5:decimal (if (= o5v3 -1.0) 0.0 o5v3))
                    (ab6:decimal (if (= o6v3 -1.0) 0.0 o6v3))
                    (ab7:decimal (if (= o7v3 -1.0) 0.0 o7v3))
                    
                )
                ;;Return Uncoil Ammount
                (cond
                    ((and (= position 1)(= elite false)) ob1)
                    ((and (= position 1)(= elite true)) ab1)

                    ((and (= position 2)(= elite false)) ob2)
                    ((and (= position 2)(= elite true)) ab2)

                    ((and (= position 3)(= elite false)) ob3)
                    ((and (= position 3)(= elite true)) ab3)

                    ((and (= position 4)(= elite false)) ob4)
                    ((and (= position 4)(= elite true)) ab4)

                    ((and (= position 5)(= elite false)) ob5)
                    ((and (= position 5)(= elite true)) ab5)

                    ((and (= position 6)(= elite false)) ob6)
                    ((and (= position 6)(= elite true)) ab6)

                    ((and (= position 7)(= elite false)) ob7)
                    ab7
                )
            )
        )
    )
    (defun U_GetCullAmount:decimal (cullable:bool account:string position:integer elite:bool)
        @doc "Reads UncoilLedger and outputs the Cull Balance for Account \
            \ Can be used for either Auryn or Elite-Auryn (via boolean elite) \
            \ The Cull Amount represents a cullable UncoilLedger Uncoil Balance Amount"

        (if (= cullable true)
            (with-capability (CULLABLE account position elite)
                (U_GetUncoilAmount account position elite)
            )
            0.0
        )
    )
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
                    (UX_GetZeroPosition ouroborosbalancelist)
                    (UX_GetZeroPosition aurynbalancelist)
                )
            )
        )
    )
    (defun U_CanCullUncoil:[bool] (account:string elite:bool)
        @doc "Reads UncoilLedger and outputs a boolean list with cullable positions \
        \ True means position is cullable, False means it is not cullable \
        \ Boolean Elite toggles between Auryn Uncoil and Elite-Auryn Uncoil output"

        (with-read UncoilLedger account
            { "P1" := o1, "P2" := o2, "P3" := o3, "P4" := o4, "P5" := o5, "P6" := o6, "P7" := o7 }
            (let*
                (
                    (present-time:time (at "block-time" (chain-data)))

                    (o1v1:decimal (at "au-ob" o1))
                    (o2v1:decimal (at "au-ob" o2))
                    (o3v1:decimal (at "au-ob" o3))
                    (o4v1:decimal (at "au-ob" o4))
                    (o5v1:decimal (at "au-ob" o5))
                    (o6v1:decimal (at "au-ob" o6))
                    (o7v1:decimal (at "au-ob" o7))
                    
                    (o1v2:time (at "ae" o1))
                    (o2v2:time (at "ae" o2))
                    (o3v2:time (at "ae" o3))
                    (o4v2:time (at "ae" o4))
                    (o5v2:time (at "ae" o5))
                    (o6v2:time (at "ae" o6))
                    (o7v2:time (at "ae" o7))

                    (o1v3:decimal (at "eau-ab" o1))
                    (o2v3:decimal (at "eau-ab" o2))
                    (o3v3:decimal (at "eau-ab" o3))
                    (o4v3:decimal (at "eau-ab" o4))
                    (o5v3:decimal (at "eau-ab" o5))
                    (o6v3:decimal (at "eau-ab" o6))
                    (o7v3:decimal (at "eau-ab" o7))
                    
                    (o1v4:time (at "eae" o1))
                    (o2v4:time (at "eae" o2))
                    (o3v4:time (at "eae" o3))
                    (o4v4:time (at "eae" o4))
                    (o5v4:time (at "eae" o5))
                    (o6v4:time (at "eae" o6))
                    (o7v4:time (at "eae" o7))

                    (t1:decimal (diff-time present-time o1v2))
                    (t2:decimal (diff-time present-time o2v2))
                    (t3:decimal (diff-time present-time o3v2))
                    (t4:decimal (diff-time present-time o4v2))
                    (t5:decimal (diff-time present-time o5v2))
                    (t6:decimal (diff-time present-time o6v2))
                    (t7:decimal (diff-time present-time o7v2))

                    (et1:decimal (diff-time present-time o1v4))
                    (et2:decimal (diff-time present-time o2v4))
                    (et3:decimal (diff-time present-time o3v4))
                    (et4:decimal (diff-time present-time o4v4))
                    (et5:decimal (diff-time present-time o5v4))
                    (et6:decimal (diff-time present-time o6v4))
                    (et7:decimal (diff-time present-time o7v4))

                    (b1:bool (if (and (> o1v1 0.0)(>= t1 0.0)) true false))
                    (b2:bool (if (and (> o2v1 0.0)(>= t2 0.0)) true false))
                    (b3:bool (if (and (> o3v1 0.0)(>= t3 0.0)) true false))
                    (b4:bool (if (and (> o4v1 0.0)(>= t4 0.0)) true false))
                    (b5:bool (if (and (> o5v1 0.0)(>= t5 0.0)) true false))
                    (b6:bool (if (and (> o6v1 0.0)(>= t6 0.0)) true false))
                    (b7:bool (if (and (> o7v1 0.0)(>= t7 0.0)) true false))

                    (eb1:bool (if (and (> o1v3 0.0)(>= et1 0.0)) true false))
                    (eb2:bool (if (and (> o2v3 0.0)(>= et2 0.0)) true false))
                    (eb3:bool (if (and (> o3v3 0.0)(>= et3 0.0)) true false))
                    (eb4:bool (if (and (> o4v3 0.0)(>= et4 0.0)) true false))
                    (eb5:bool (if (and (> o5v3 0.0)(>= et5 0.0)) true false))
                    (eb6:bool (if (and (> o6v3 0.0)(>= et6 0.0)) true false))
                    (eb7:bool (if (and (> o7v3 0.0)(>= et7 0.0)) true false))
                )
                (if (= elite false)
                    [b1 b2 b3 b4 b5 b6 b7]
                    [eb1 eb2 eb3 eb4 eb5 eb6 eb7]
                )
            )
        )
    )
    (defun UX_GetZeroPosition:integer (inputlist:[decimal])
        @doc "Returns best uncoil position from a list of balances \
        \ Best position is the first position with a 0.0 value. \
        \ First position is considered 1. When no more position are available, returns -1"

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
                        (enumerate 0 (- (length inputlist) 1))      ;;list  
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
        @doc "Initialises the Autostake Smart-Contract \
        \ Returns the ids of Auryn, Elite-Auryn, Ignis in a list of strings"
        (DPTF.U_ValidateTrueFungibleIdentifier ouro-id)

        ;;Initialise the Autostake DPTS Account as a Smart Account
        ;;Necesary because it needs to operate as a MultiverX Smart Contract
        (DPTS.C_DeploySmartDPTSAccount SC_NAME (keyset-ref-guard SC_KEY))

        (with-capability (AUTOSTAKE_INIT)
            ;;Issue Auryns Token
            (let
                (
                    (AurynID:string 
                        (DPTF.C_IssueTrueFungible
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
                        )
                    )
                    (EliteAurynID:string 
                        (DPTF.C_IssueTrueFungible
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
                        )
                    )
                    (IgnisID:string 
                        (DPTF.C_IssueTrueFungible
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
                        )
                    )
                )
                ;;Issue OURO DPTF Account for the AutostakePool
                (DPTF.C_DeployTrueFungibleAccount ouro-id SC_NAME (keyset-ref-guard SC_KEY))
                ;;SetTrinityTable
                (insert TrinityTable TRINITY
                    {"ouro-id"                      : ouro-id
                    ,"auryn-id"                     : AurynID
                    ,"elite-auryn-id"               : EliteAurynID
                    ,"ignis-id"                     : IgnisID
                    ,"vested-elite-auryn-id"        : ""}
                )
                ;;SetAutostakeTable
                (insert AutostakeLedger AUTOSTAKEHOLDINGS
                    {"resident-ouro"                : 0.0
                    ,"unbonding-ouro"               : 0.0
                    ,"resident-auryn"               : 0.0
                    ,"unbonding-auryn"              : 0.0}  
                )
                ;;SetTokenRoles
                (DPTF.C_SetBurnRole AurynID SC_NAME)
                (DPTF.C_SetBurnRole EliteAurynID SC_NAME)

                (DPTF.C_SetMintRole AurynID SC_NAME)
                (DPTF.C_SetMintRole EliteAurynID SC_NAME)
                (DPTF.C_SetMintRole IgnisID SC_NAME)

                (DPTF.C_SetTransferRole AurynID SC_NAME)
                (DPTF.C_SetTransferRole EliteAurynID SC_NAME)

                [AurynID EliteAurynID IgnisID]
            )
        )
    )
    (defun A_SaveVestedEliteAurynID (id:string)
    @doc "Saves the Vested Elite Auryn Id"

        (with-capability (AUTOSTAKE_ADMIN)
            (with-read TrinityTable TRINITY
                {"ouro-id"                      := o-id
                ,"auryn-id"                     := a-id
                ,"elite-auryn-id"               := ea-id
                ,"ignis-id"                     := i-id
                ,"vested-elite-auryn-id"        := vea-id}
                (write TrinityTable TRINITY
                    {"ouro-id"                  : o-id
                    ,"auryn-id"                 : a-id
                    ,"elite-auryn-id"           : ea-id
                    ,"ignis-id"                 : i-id
                    ,"vested-elite-auryn-id"    : id}
                )
            )
        )
    )
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      CLIENT FUNCTIONS
    ;;
    ;;      C_UpdateAurynzData
    ;;
    (defun C_UpdateAurynzData (account:string)
        @doc "Updates Data pertaining to Demiourgos Elite Account"

        ;;0]Any Snake Token Account Owner can update his Demiourgos Elite Account
        (with-capability (UPDATE_AURYNZ account)
            (let
                (
                    (major:integer (U_GetMajorEliteTier account))
                )
                (X_InitialiseUncoilLedger account)      ;works when not exist
                (if (not (or (= major 0) (= major 1)))
                    ;works because it was created above. Executed 
                    (X_UpdateUncoilLedgerWithElite account major) 
                    "No Update required for Uncoil Ledger on Elite"
                )
                (X_UpdateEliteTracker account)          ;works because Balance get is made with default read
            )
        )
    )
    ;;
    ;;==================Coil|Curl|Fuel==============
    ;;      C_CoilOuroboros|C_FuelOuroboros
    ;;      C_CoilAuryn|C_CurlOuroboros
    ;;
    (defun C_CoilOuroboros:decimal (client:string ouro-input-amount:decimal)
        @doc "Coils Ouroboros, staking it into the Autostake Pool, generating Auryn \
            \ Returns as decimal amount of generated Auryn"
    
        (let
            (
                (auryn-output-amount:decimal (U_ComputeOuroCoil ouro-input-amount))
                (client-guard:guard (DPTF.U_GetAccountTrueFungibleGuard (U_OuroborosID) client))
            )
    ;;0]Any Client can perform <C_CoilOuroboros>; Smart DPTS Accounts arent required to provide their guards
        (with-capability (COIL_OUROBOROS client ouro-input-amount)
    ;;1]<client> Account transfers as method <OURO|Ouroboros> to the <Snake_Autostake> Account for coiling(autostaking)
        (DPTF.X_MethodicTransferTrueFungible (U_OuroborosID) client SC_NAME ouro-input-amount)
    ;;2]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (+)
        (X_UpdateResidentOuro ouro-input-amount true)
    ;;3]<Snake_Autostake> Account mints <AURYN|Auryn>
        (X_MintAuryn auryn-output-amount)
    ;;4]<Snake_Autostake> Account transfers as method <AURYN|Auryn> to <client> Account           
        (DPTF.X_MethodicTransferTrueFungibleAnew (U_AurynID) SC_NAME client client-guard auryn-output-amount)
    ;;5]<UncoilLedger> and <EliteTracker> are updated with the operation
        (C_UpdateAurynzData client)
            )
            auryn-output-amount
        )
    )
    (defun C_FuelOuroboros (client:string ouro-input-amount:decimal)
        @doc "Fuels Ouroboros to the Autostake Pool, increasing Auryndex"

    ;;0]Any Client can perform <C_FuelOuroboros>; Smart DPTS Accounts arent required to provide their guards
        (with-capability (FUEL_OUROBOROS client ouro-input-amount)
    ;;1]<client> Account transfers as method <OURO|Ouroboros> to the <Snake_Autostake> Account, for fueling (fueling does not generate <AURYN|Auryn>)
        (DPTF.X_MethodicTransferTrueFungible (U_OuroborosID) client SC_NAME ouro-input-amount)
    ;;2]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (+)
        (X_UpdateResidentOuro ouro-input-amount true)
        )
    )
    (defun C_CoilAuryn (client:string auryn-input-amount:decimal)
        @doc "Coils Auryn, securing it into the Autostake Pool, generating Elite-Auryn"

    ;;0]Any Client can perform <C_CoilAuryn>; Smart DPTS Accounts arent required to provide their guards
        (with-capability (COIL_AURYN client auryn-input-amount)
            (let
                (
                    (client-guard:guard (DPTF.U_GetAccountTrueFungibleGuard (U_AurynID) client))
                )
    ;;1]<client> Account transfers as method <AURYN|Auryn> to the <Snake_Autostake> Account for coiling(autostkaing)
        (DPTF.X_MethodicTransferTrueFungible (U_AurynID) client SC_NAME auryn-input-amount)
    ;;2]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-auryn> (+)
        (X_UpdateResidentAuryn auryn-input-amount true)
    ;;3]<Snake_Autostake> Account mints <EAURYN|Elite-Auryn>
        (X_MintEliteAuryn auryn-input-amount)
    ;;4]<Snake_Autostake> Account transfers as method <EAURYN|Elite-Auryn> to <client> Account
        (DPTF.X_MethodicTransferTrueFungibleAnew (U_EliteAurynID) SC_NAME client client-guard auryn-input-amount)
    ;;5]<UncoilLedger> and <EliteTracker> are updated with the operation
        (C_UpdateAurynzData client) 
            )
        )
    )
    (defun C_CurlOuroboros:decimal (client:string ouro-input-amount:decimal)
        @doc "Curls Ouroboros, then Curls Auryn in a single Function"

    ;;0]Any Client can perform <C_CurlOuroboros>; Smart DPTS Accounts arent required to provide their guards
        (with-capability (CURL_OUROBOROS client ouro-input-amount)
            (let
                (
                    (auryn-output-amount:decimal (U_ComputeOuroCoil ouro-input-amount))
                    (client-guard:guard (DPTF.U_GetAccountTrueFungibleGuard (U_OuroborosID) client))
                )  
    ;;1]<client> Account transfers as method <OURO|Ouroboros> to the <Snake_Autostake> Account for curling (double-coiling) 
        (DPTF.X_MethodicTransferTrueFungible (U_OuroborosID) client SC_NAME ouro-input-amount)
    ;;2]<Snake_Autostake> Account mints <AURYN|Auryn>
        (X_MintAuryn auryn-output-amount)
    ;;3]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (+)|<resident-auryn> (+)
        (X_UpdateResidentOuro ouro-input-amount true)
        (X_UpdateResidentAuryn auryn-output-amount true)
    ;;4]<Snake_Autostake> Account mints <EAURYN|Elite-Auryn>
        (X_MintEliteAuryn auryn-output-amount)
    ;;5]<Snake_Autostake> Account transfers as method <EAURYN|Elite-Auryn> to <client> Account
        (DPTF.X_MethodicTransferTrueFungibleAnew (U_EliteAurynID) SC_NAME client client-guard auryn-output-amount)
    ;;6]<UncoilLedger> and <EliteTracker> are updated with the operation
        (C_UpdateAurynzData client)  
                auryn-output-amount 
            )
        )
    )
    ;;
    ;;==================AURYN-UNCOIL================
    ;;      C_UncoilAuryn|C_CullOuroboros
    ;;
    (defun C_UncoilAuryn (client:string auryn-input-amount:decimal)
        @doc "Uncoils Auryn, generating Ouroboros for client and IGNIS for Autostake \
        \ Uses the best(cheapest) uncoil Position. This is determined automatically \
        \ and must not be entered as a parameter. When no position is available, function fails."
        
    ;;0]Any Client can perform <C_UncoilAuryn>; Smart DPTS Accounts arent required to provide their guards
        (with-capability (UNCOIL_AURYN client auryn-input-amount)
    ;;1]<UncoilLedger> and <EliteTracker> are updated with the operation; <UncoilLedger> must exist for operation
        (C_UpdateAurynzData client)
            (let*
                (
                    (uncoil-position:integer (U_GetUncoilPosition client false))
                    (uncoil-data:[decimal] (U_ComputeAurynUncoil auryn-input-amount uncoil-position))
                    (ouro-redeem-amount:decimal (at 0 uncoil-data))
                    (ouro-output-amount:decimal (at 1 uncoil-data))
                    (ouro-burn-fee-amount:decimal (at 2 uncoil-data))
                    (cull-time:time (U_ComputeCullTime client false))
                )
    ;;Enforces a position is free for update, otherwise uncoil cannot execute. If no positions is free, position is returned as -1
        (enforce (!= uncoil-position -1) "No more Auryn Uncoil Positions")
    ;;2]<client> Account transfers as method <AURYN|Auryn> to <Snake_Autostake> Account for burning
        (DPTF.X_MethodicTransferTrueFungible (U_AurynID) client SC_NAME auryn-input-amount)
    ;;3]<Snake_Autostake> Account burns the whole <AURYN|Auryn> transferred
        (X_BurnAuryn auryn-input-amount)
    ;;4)<Snake_Autostake> Account burns <OURO|Ouroboros> as uncoil fee (burning <OURO|Ouroboros automatically mints <IGNIS|Ignis>)
        (X_BurnOuroboros ouro-burn-fee-amount)
    ;;5]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (-)|<unbonding-ouro> (+)
        (X_UpdateResidentOuro ouro-redeem-amount false)
        (X_UpdateUnbondingOuro ouro-output-amount true)
    ;;6]<Snake_Autostake> Account updates <UncoilLedger>
        (X_UpdateUncoilLedger client uncoil-position ouro-output-amount cull-time false)
            )
        )
    )
    (defun C_CullOuroboros (client:string)
        @doc "Culls all cullable Auryn Uncoil Positions, collecting Ouroboros \
        \ Fails if no cullable positions exist, or if no entry for account in UncoilLedger exist"


        (with-capability (CULL_EXECUTOR)
            (let
                (
                    (culled-amount:decimal (X_CullUncoilAll client false))
                    (client-guard:guard (DPTF.U_GetAccountTrueFungibleGuard (U_AurynID) client))
                )
    ;;0]Any Client can perform <C_CullOuroboros>; Smart DPTS Accounts arent required to provide their guards
        (with-capability (CULL_OUROBOROS client culled-amount)
    ;;1]Snake_Autostake> Account transfers as method culled  <OURO|Ouroboros> to <client> Account
        (DPTF.X_MethodicTransferTrueFungibleAnew (U_OuroborosID) SC_NAME client client-guard culled-amount)
    ;;2]<Snake_Autostake> Account updates <AutostakeLedger>|<unbonding-ouro> (-)
        (X_UpdateUnbondingOuro culled-amount false)
                )
            )
        )
    )
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      AUXILIARY FUNCTIONS
    ;;
    ;;==================MINT|BURN-SNAKE-TOKENS======
    ;;      X_BurnOuroboros|X_BurnAuryn|X_BurnEliteAuryn
    ;;      X_MintOuroboros|X_MintAuryn|X_MintEliteAuryn
    ;;
    (defun X_BurnOuroboros (amount:decimal)
        @doc "Burns Ouroboros and generates Ignis at 100x capacity"
        (require-capability (BURN_OUROBOROS (U_OuroborosID) (U_IgnisID) SC_NAME amount))
        (DPTF.C_Burn (U_OuroborosID) SC_NAME amount)
        (DPTF.C_Mint (U_IgnisID) SC_NAME (U_ComputeIgnisMintAmount amount))
    )
    (defun X_BurnAuryn (amount:decimal)
        @doc "Burns Auryn"
        (require-capability (BURN_AURYN (U_AurynID) SC_NAME amount))
        (DPTF.C_Burn (U_AurynID) SC_NAME amount)
    )
    (defun X_BurnEliteAuryn (amount:decimal)
        @doc "Burns Elite-Auryn"
        (require-capability (BURN_ELITE-AURYN (U_EliteAurynID) SC_NAME amount))
        (DPTF.C_Burn (U_EliteAurynID) SC_NAME amount)
    )
    (defun X_MintOuroboros (amount:decimal)
        @doc "Mints Ouroboros"
        (require-capability (MINT_OUROBOROS (U_OuroborosID) SC_NAME amount))
        (DPTF.C_Mint (U_OuroborosID) SC_NAME amount)
    )
    (defun X_MintAuryn (amount:decimal)
        @doc "Mints Auryn"
        (require-capability (MINT_AURYN (U_AurynID) SC_NAME amount))
        (DPTF.C_Mint (U_AurynID) SC_NAME amount)
    )
    (defun X_MintEliteAuryn (amount:decimal)
        @doc "Mints Elite-Auryn"
        (require-capability (MINT_ELITE-AURYN (U_EliteAurynID) SC_NAME amount))
        (DPTF.C_Mint (U_EliteAurynID) SC_NAME amount)
    )
    ;;
    ;;==================UPDATE-AUTOSTAKE-LEDGER=====
    ;;      X_UpdateResidentOuro|X_UpdateResidentAuryn
    ;;      X_UpdateUnbondingOuro|X_UpdateUnbondingAuryn
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
    ;;==================CULL========================
    ;;      X_CullUncoilAll|X_ExecuteCull|X_CullUncoilSingle
    ;;
    (defun X_CullUncoilAll:decimal (account:string elite:bool)
        @doc "Processes all Uncoils positions for culling purposes for Account \
        \ Returns the sum of all culled positions"
        (let*
            (
                (cull-boolean-slice:[bool] (U_CanCullUncoil account elite))
                (d1:decimal (X_ExecuteCull (at 0 cull-boolean-slice) account 1 elite))
                (d2:decimal (X_ExecuteCull (at 1 cull-boolean-slice) account 2 elite))
                (d3:decimal (X_ExecuteCull (at 2 cull-boolean-slice) account 3 elite))
                (d4:decimal (X_ExecuteCull (at 3 cull-boolean-slice) account 4 elite))
                (d5:decimal (X_ExecuteCull (at 4 cull-boolean-slice) account 5 elite))
                (d6:decimal (X_ExecuteCull (at 5 cull-boolean-slice) account 6 elite))
                (d7:decimal (X_ExecuteCull (at 6 cull-boolean-slice) account 7 elite))
                (culled-balances:[decimal] [d1 d2 d3 d4 d5 d6 d7])
            )
            (fold (+) 0.0 culled-balances)
        )
    )
    (defun X_ExecuteCull:decimal (cullable:bool account:string position:integer elite:bool)
        @doc "Processes an Uncoil Position for culling purposes for Account \
        \ Can be used for either Auryn or Elite-Auryn (via boolean elite) \
        \ Boolean cullable informs the function if the position is cullable \
        \ If the position is cullable, it will be culled. \
        \ If the position is not cullable, decimal zero is returned"

        (require-capability (CULL_EXECUTOR))
        (if (= cullable true)
            (with-capability (CULLABLE account position elite)
                (X_CullUncoilSingle account position elite)
            )
            0.0
        )
    )
    (defun X_CullUncoilSingle:decimal (account:string position:integer elite:bool)
        @doc "Culls Uncoil position for Auryn-Uncoil or Elite-Auryn-Uncoil\
        \ Culling Position means clearing the Uncoil Ledger and outputting culled amount as decimal"

        (require-capability (CULLABLE account position elite))
        (with-read UncoilLedger account
            { "P1" := o1, "P2" := o2, "P3" := o3, "P4" := o4, "P5" := o5, "P6" := o6, "P7" := o7 }
            (let*
                (
                    (o1v1:decimal (at "au-ob" o1))
                    (o2v1:decimal (at "au-ob" o2))
                    (o3v1:decimal (at "au-ob" o3))
                    (o4v1:decimal (at "au-ob" o4))
                    (o5v1:decimal (at "au-ob" o5))
                    (o6v1:decimal (at "au-ob" o6))
                    (o7v1:decimal (at "au-ob" o7))

                    (o1v3:decimal (at "eau-ab" o1))
                    (o2v3:decimal (at "eau-ab" o2))
                    (o3v3:decimal (at "eau-ab" o3))
                    (o4v3:decimal (at "eau-ab" o4))
                    (o5v3:decimal (at "eau-ab" o5))
                    (o6v3:decimal (at "eau-ab" o6))
                    (o7v3:decimal (at "eau-ab" o7))
                    
                    (major:integer (U_GetMajorEliteTier account))

                    (update-time:time (if (< major position) ANTITIME NULLTIME))
                    (update-balance:decimal (if (< major position) -1.0 0.0))
                )
                ;; tier < position => ANTITIME
                ;; tier = position => NULLTIME
                ;; tier > position => NULLTIME

                ;;Clear Position on UncoilLedger
                (cond
                    ((and (= position 1)(= elite false)) (X_UpdateUncoilLedger account 1 0.0 NULLTIME false))
                    ((and (= position 1)(= elite true)) (X_UpdateUncoilLedger account 1 0.0 NULLTIME true))

                    ((and (= position 2)(= elite false)) (X_UpdateUncoilLedger account 2 0.0 NULLTIME false))
                    ((and (= position 2)(= elite true)) (X_UpdateUncoilLedger account 2 update-balance update-time true))

                    ((and (= position 3)(= elite false)) (X_UpdateUncoilLedger account 3 0.0 NULLTIME false))
                    ((and (= position 3)(= elite true)) (X_UpdateUncoilLedger account 3 update-balance update-time true))

                    ((and (= position 4)(= elite false)) (X_UpdateUncoilLedger account 4 0.0 NULLTIME false))
                    ((and (= position 4)(= elite true)) (X_UpdateUncoilLedger account 4 update-balance update-time true))

                    ((and (= position 5)(= elite false)) (X_UpdateUncoilLedger account 5 0.0 NULLTIME false))
                    ((and (= position 5)(= elite true)) (X_UpdateUncoilLedger account 5 update-balance update-time true))

                    ((and (= position 6)(= elite false)) (X_UpdateUncoilLedger account 6 0.0 NULLTIME false))
                    ((and (= position 6)(= elite true)) (X_UpdateUncoilLedger account 6 update-balance update-time true))

                    ((and (= position 7)(= elite false)) (X_UpdateUncoilLedger account 7 0.0 NULLTIME false))
                    ((and (= position 7)(= elite true)) (X_UpdateUncoilLedger account 7 update-balance update-time true))
                    "No"
                )

                ;;Return Culled Amount
                (cond
                    ((and (= position 1)(= elite false)) o1v1)
                    ((and (= position 1)(= elite true)) o1v3)

                    ((and (= position 2)(= elite false)) o2v1)
                    ((and (= position 2)(= elite true)) o2v3)

                    ((and (= position 3)(= elite false)) o3v1)
                    ((and (= position 3)(= elite true)) o3v3)

                    ((and (= position 4)(= elite false)) o4v1)
                    ((and (= position 4)(= elite true)) o4v3)

                    ((and (= position 5)(= elite false)) o5v1)
                    ((and (= position 5)(= elite true)) o5v3)

                    ((and (= position 6)(= elite false)) o6v1)
                    ((and (= position 6)(= elite true)) o6v3)

                    ((and (= position 7)(= elite false)) o7v1)
                    o7v3
                )
                
            )
        )
    )
    ;;
    ;;==================UNCOIL-LEDGER|ELITE_TRACKER=
    ;;      X_UpdateUncoilLedger
    ;;      X_InitialiseUncoilLedger|X_UpdateUncoilLedgerWithElite|X_UpdateEliteTracker
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
    (defun X_UpdateUncoilLedgerWithElite (account:string major-elite-tier:integer)
        @doc "Updates Elite-Auryn Uncoil Ledger opening positions based on Major Elite Tier"
        (require-capability (UPDATE_UNCOIL_LEDGER))
        (with-capability (UNCOIL-LEDGER_MANAGING-TIER major-elite-tier)
            (XU_ManageEliteUncoilPositionWithTier account major-elite-tier)
        ) 
    )
    (defun X_UpdateEliteTracker (account:string)
        @doc "Updates Elite-Account Information which tracks Elite-Auryn Ammounts"
        (require-capability (UPDATE_ELITE_TRACKER))

        (let*
            (
                (iz-sc:bool (at 0 (DPTS.U_GetDPTSAccountType account)))
                (eab:decimal (UX_GetEliteAurynzBalance account))
                (elite:object{EliteAccountSchema} (U_ComputeElite eab))
                (elite-tier-class (at "class" elite))
                (elite-tier-name (at "name" elite))
                (elite-tier (at "tier" elite))
                (deb (at "deb" elite))
            )
            (if (= iz-sc false)
                (write EliteTracker account
                    { "class"   : elite-tier-class
                    , "name"    : elite-tier-name
                    , "tier"    : elite-tier
                    , "deb"     : deb
                    }  
                )
                (format "Account {} cannot be tracked in the Elite Tracker since it is a Smart DPTS Account"[account])
            )
           
        )
    )
    ;;
    ;;      XU_ManageEliteUncoilPositionWithTier|XU_MakeHexaBooleanList
    ;;      XU_ToggleEliteUncoilPosition|XU_CheckPositionState
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
    (defun XU_ToggleEliteUncoilPosition (account:string position:integer toggle:bool)
        @doc "Opens Elite Auryn Uncoil Position if is closed; If it is already opened or in use, leave as is. \
            \ Closes Elite Auryn Uncoil Position if it is opened; If it is already closed or in use, leave as is. \
            \ Opening or Closing is done via the boolean trigged toggle. True will execute opening, False closing \
            \ Assumes Uncoil Ledger already exists for account "

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
(create-table UncoilLedger)
(create-table EliteTracker)
(create-table AutostakeLedger)