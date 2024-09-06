(module DH_SC_Autostake GOVERNANCE
    @doc "DH_SC_Autostake is the Demiourgos.Holdings Smart-Contract for Autostake of Ouroboros and Auryn Tokens \
    \ It manages the Coil|Curl functions for Ouroboros|Auryn|Elite-Auryn, and the generator of Auryndex"

    ;;0]GOVERNANCE-ADMIN
    ;;
    ;;      GOVERNANCE|AUTOSTAKE_ADMIN|AUTOSTAKE_MASTER
    ;;      AUTOSTAKE_INIT|AUTOSTAKE_GENESIS
    ;;
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
        \ Set to Autostake_Admin so that only Module Key can enact an upgrade"
        false
        ;(compose-capability (AUTOSTAKE_ADMIN))
    )
    (defcap AUTOSTAKE_ADMIN ()
        (enforce-guard (keyset-ref-guard SC_KEY))
        (compose-capability (OUROBOROS.DPTS_INCREASE-NONCE))
    )
    (defcap AUTOSTAKE_MASTER ()
        (enforce-one
            "Either Demiourgos Trinity or Vesting Key can perform Vesting"
            [
                (compose-capability (AUTOSTAKE_ADMIN))
                (compose-capability (OUROBOROS.OUROBOROS_ADMIN))
            ]
        )
    )
    (defcap AUTOSTAKE_INIT ()
        (compose-capability (AUTOSTAKE_MASTER))
        (compose-capability (AUTOSTAKE_GENESIS))
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

    ;;1]CONSTANTS Definitions
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
    (defconst AURYN_FEE 50.0)
    (defconst ELITE-AURYN_FEE 100.0)

    (defconst BAR OUROBOROS.BAR)
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

    ;;2]SCHEMA Definitions
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
    ;;3]TABLES Definitions
    (deftable TrinityTable:{TrinitySchema})
    (deftable AutostakeLedger:{AutostakeSchema})
    (deftable EliteTracker:{EliteAccountSchema})
    (deftable UncoilLedger:{UncoilSchema})


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
    ;;      AUTOSTAKE_ADMIN                         Module Admin Capability                                                                             ;;
    ;;      AUTOSTAKE_MASTER                        Module Mastery Capability                                                                           ;;
    ;;      AUTOSTAKE_INIT                          Module Initialisation Capability                                                                    ;;
    ;;      AUTOSTAKE_GENESIS                       Module Genesis Capability                                                                           ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      BASIC                                                                                                                                       ;;
    ;;      UPDATE_AURYNZ                           Capability required to update Auryns Data (UncoilLedger and Elitetracker)                           ;;
    ;;      SNAKE_TOKEN_ACCOUNT_EXISTANCE           Capability enforcing Snake Token Account Exists                                                     ;;
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
    ;;      UPDATE_AURYNZ
    ;;      SNAKE_TOKEN_ACCOUNT_EXISTANCE|UPDATE_UNCOIL_LEDGER|UPDATE_ELITE_TRACKER|UPDATE_AUTOSTAKE_LEDGER
    ;;      UNCOIL-LEDGER_BALANCE|UNCOIL-LEDGER_MANAGING-POSITION|UNCOIL-LEDGER_MANAGING-TIER
    ;;      CULL_EXECUTOR|CULLABLE
    ;;
    (defcap UPDATE_AURYNZ (patron:string account:string)
        (compose-capability (OUROBOROS.DPTS_CLIENT patron))
        (compose-capability (SNAKE_TOKEN_ACCOUNT_EXISTANCE account))
        (compose-capability (UPDATE_UNCOIL_LEDGER))
        (compose-capability (UPDATE_ELITE_TRACKER))
    )
    (defcap SNAKE_TOKEN_ACCOUNT_EXISTANCE (account:string)
        (let
            (
                (iz-sc:bool (OUROBOROS.UR_DPTS-AccountType account))
            )
            (if (= iz-sc true)
                true
                (enforce-one
                    (format "No Snake Token Accounts found defined on {} Account" [account])
                    [
                        (compose-capability (OUROBOROS.DPTF_ACCOUNT_EXISTANCE (UR_OuroborosID) account true))
                        (compose-capability (OUROBOROS.DPTF_ACCOUNT_EXISTANCE (UR_AurynID) account true))
                        (compose-capability (OUROBOROS.DPTF_ACCOUNT_EXISTANCE (UR_EliteAurynID) account true))
                        (compose-capability (DPMF.DPMF_ACCOUNT_EXISTANCE (UR_VEliteAurynID) account true))
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
    (defcap UPDATE_AUTOSTAKE_LEDGER ()
        @doc "Capability required for updating the Autostake Ledger"
        true
    )
    (defcap AUTOSTAKE_EXECUTOR ()
        @doc "Capability required to execute Autostake Client Functions"
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
        (enforce (contains position (enumerate 1 7)) "Invalid Position for managing")
    )
    (defcap UNCOIL-LEDGER_MANAGING-TIER (tier:integer)
        @doc "Enforces Integer as Uncoil Ledger Elite-Auryn Uncoil optional position"
        (enforce (contains tier (enumerate 0 7)) "Invalid Tier for Elite Uncoil Position Management and Hexa Boolean List Making")
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
                (cull-boolean-slice:[bool] (UR_CanCullUncoil account elite))
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
    ;;      BURN_OUROBOROS|BURN_AURYN|BURN_ELITE-AURYN
    ;;      MINT_AURYN|MINT_ELITE-AURYN
    ;;
    (defcap BURN_OUROBOROS (patron:string ouro-burn-amount:decimal)
        (compose-capability (OUROBOROS.DPTF_BURN patron (UR_OuroborosID) SC_NAME ouro-burn-amount true))
        (compose-capability (OUROBOROS.DPTF_MINT patron (UR_IgnisID ) SC_NAME (UC_IgnisMintAmount ouro-burn-amount) false true))
    )
    (defcap BURN_AURYN (patron:string auryn-amount:decimal)
        (compose-capability (OUROBOROS.DPTF_BURN patron (UR_AurynID) SC_NAME auryn-amount true))
    )
    (defcap BURN_ELITE-AURYN (patron:string elite-auryn-amount:decimal)
        (compose-capability (OUROBOROS.DPTF_BURN patron (UR_EliteAurynID) SC_NAME elite-auryn-amount true))
    )
    (defcap MINT_AURYN (patron:string auryn-amount:decimal)
        (compose-capability (OUROBOROS.DPTF_MINT patron (UR_AurynID) SC_NAME auryn-amount false true))
    )
    (defcap MINT_ELITE-AURYN (patron:string elite-auryn-amount:decimal)
        (compose-capability (OUROBOROS.DPTF_MINT patron (UR_EliteAurynID) SC_NAME elite-auryn-amount false true))
    )
    ;;
    ;;      COIL_OUROBOROS|FUEL_OUROBOROS|COIL-AURYN
    ;;      CURL-OUROBOROS|UNCOIL-AURYN|CULL_OUROBOROS
    ;;
    (defcap COIL_OUROBOROS(patron:string coiler:string ouro-input-amount:decimal)
        (let 
            (
                (ouro-id:string (UR_OuroborosID))
                (auryn-id:string (UR_AurynID))
                (auryn-computed-amount:decimal (UC_OuroCoil ouro-input-amount))
            )
        ;;0]Core-Permissions of the Capability
            (compose-capability (AUTOSTAKE_EXECUTOR))
        ;;1]<client> Account transfers as method <OURO|Ouroboros> to the <Snake_Autostake> Account for coiling(autostaking)
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF ouro-id client SC_NAME ouro-input-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron ouro-id coiler SC_NAME ouro-input-amount true))
        ;;2]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (+)
            (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
        ;;3]<Snake_Autostake> Account mints <AURYN|Auryn>
            (compose-capability (MINT_AURYN patron auryn-computed-amount))
        ;;4]<Snake_Autostake> Account transfers as method <AURYN|Auryn> to <client> Account
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF (UR_AurynID) SC_NAME client auryn-computed-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron auryn-id SC_NAME coiler auryn-computed-amount true))
        ;;5]<UncoilLedger> and <EliteTracker> are updated with the operation
            (compose-capability (UPDATE_AURYNZ patron coiler))
        )
    )
    (defcap FUEL_OUROBOROS(patron:string fueler:string ouro-input-amount:decimal)
        (let
            (
                (ouro-id:string (UR_OuroborosID))
            )
        ;;0]Core-Permissions of the Capability
            (compose-capability (AUTOSTAKE_EXECUTOR))
        ;;1]<client> Account transfers as method <OURO|Ouroboros> to the <Snake_Autostake> Account, for fueling (fueling does not generate <AURYN|Auryn>)
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF (UR_OuroborosID) client SC_NAME ouro-input-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron ouro-id fueler SC_NAME ouro-input-amount true))
        ;;2]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (+)
            (compose-capability (UPDATE_AUTOSTAKE_LEDGER))  
        )
    )
    (defcap COIL_AURYN(patron:string coiler:string auryn-input-amount:decimal)
        (let
            (
                (auryn-id:string (UR_AurynID))
                (eauryn-id:string (UR_EliteAurynID))
            )
        ;;0]Core-Permissions of the Capability
            (compose-capability (AUTOSTAKE_EXECUTOR))
        ;;1]<client> Account transfers as method <AURYN|Auryn> to the <Snake_Autostake> Account for coiling(autostkaing)
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF auryn-id client SC_NAME auryn-input-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron auryn-id coiler SC_NAME auryn-input-amount true))
        ;;2]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-auryn> (+)
            (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
        ;;3]<Snake_Autostake> Account mints <EAURYN|Elite-Auryn>
            (compose-capability (MINT_ELITE-AURYN patron auryn-input-amount))
        ;;4]<Snake_Autostake> Account transfers as method <EAURYN|Elite-Auryn> to <coiler> Account
            ;;odl: (compose-capability (OUROBOROS.TRANSFER_DPTF eauryn-id SC_NAME client auryn-input-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron eauryn-id SC_NAME coiler auryn-input-amount true))
        ;;5]<UncoilLedger> and <EliteTracker> are updated with the operation
            (compose-capability (UPDATE_AURYNZ patron coiler))
        )
    )
    (defcap CURL_OUROBOROS(patron:string coiler:string ouro-input-amount:decimal)
        (let 
            (
                (ouro-id:string (UR_OuroborosID))
                (eauryn-id:string (UR_EliteAurynID))
                (auryn-computed-amount:decimal (UC_OuroCoil ouro-input-amount))
            )
        ;;0]Core-Permissions of the Capability
            (compose-capability (AUTOSTAKE_EXECUTOR))
        ;;1]<coiler> Account transfers as method <OURO|Ouroboros> to the <Snake_Autostake> Account for curling (double-coiling) 
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF ouro-id coiler SC_NAME ouro-input-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron ouro-id coiler SC_NAME ouro-input-amount true))
        ;;2]<Snake_Autostake> Account mints <AURYN|Auryn>
            (compose-capability (MINT_AURYN patron auryn-computed-amount))
        ;;3]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (+)|<resident-auryn> (+)
            (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
        ;;4]<Snake_Autostake> Account mints <EAURYN|Elite-Auryn>
            (compose-capability (MINT_ELITE-AURYN patron auryn-computed-amount))
        ;;5]<Snake_Autostake> Account transfers as method <EAURYN|Elite-Auryn> to <coiler> Account
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF eauryn-id SC_NAME client auryn-computed-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron eauryn-id SC_NAME coiler auryn-computed-amount true))
        ;;6]<UncoilLedger> and <EliteTracker> are updated with the operation
            (compose-capability (UPDATE_AURYNZ patron coiler))
        )
    )
    (defcap UNCOIL_AURYN(patron:string uncoiler:string auryn-input-amount:decimal)
        (let*
            (
                (auryn-id:string (UR_AurynID))
                (uncoil-position:integer (UR_UncoilPosition uncoiler))
                (uncoil-data:[decimal] (UC_AurynUncoil auryn-input-amount uncoil-position))
                (ouro-burn-fee-amount:decimal (at 2 uncoil-data))
            )
        ;;1]<UncoilLedger> and <EliteTracker> are updated with the operation; <UncoilLedger> must exist for operation
            (compose-capability (UPDATE_AURYNZ patron uncoiler))
        ;;2]<client> Account transfers as method <AURYN|Auryn> to <Snake_Autostake> Account for burning
            ;;old (compose-capability (OUROBOROS.TRANSFER_DPTF auryn-id client SC_NAME auryn-input-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron auryn-id uncoiler SC_NAME auryn-input-amount true))
        ;;3]<Snake_Autostake> Account burns the whole <AURYN|Auryn> transferred
            (compose-capability (BURN_AURYN patron auryn-input-amount))
        ;;4)<Snake_Autostake> Account burns <OURO|Ouroboros> as uncoil fee (burning <OURO|Ouroboros automatically mints <IGNIS|Ignis>)
            (compose-capability (BURN_OUROBOROS patron ouro-burn-fee-amount))
        ;;5]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (-)|<unbonding-ouro> (+)
            (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
        ;;6*]<Snake_Autostake> Account updates <UncoilLedger>
            (compose-capability (UPDATE_UNCOIL_LEDGER)) ;;Capability already granted by (UPDATE_AURYNZ)
        )        
    )
    (defcap CULL_OUROBOROS(patron:string culler:string culled-amount:decimal)
        (let
            (
                (ouro-id:string (UR_OuroborosID))
            )
        ;;1]Enforces that the culled amount is greater than 0.0, that is, that there are cullable positions.
            (enforce (> culled-amount 0.0) "No Auryn Uncoil Positions are cullable yet")
        ;;2]Snake_Autostake> Account transfers as method culled <OURO|Ouroboros> to <culler> Account
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF ouro-id SC_NAME client culled-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron ouro-id SC_NAME culler culled-amount true))
        ;;3]<Snake_Autostake> Account updates <AutostakeLedger>|<unbonding-ouro> (-)
            (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
        )
    )
    (defcap UNCOIL_ELITE-AURYN(patron:string uncoiler:string elite-auryn-input-amount:decimal)
        (let
            (
                (eauryn-id:string (UR_EliteAurynID))
            )
        ;;1]<UncoilLedger> and <EliteTracker> are updated with the operation; <UncoilLedger> must exist for operation
            (compose-capability (UPDATE_AURYNZ patron uncoiler))
        ;;2]<client> Account transfers as method <ELITEAURYN|EliteAuryn> to <Snake_Autostake> Account for burning
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF eauryn-id client SC_NAME elite-auryn-input-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron eauryn-id uncoiler SC_NAME elite-auryn-input-amount true))
        ;;3]<Snake_Autostake> Account burns the whole <ELITEAURYN|EliteAuryn> transferred
            (compose-capability (BURN_ELITE-AURYN patron elite-auryn-input-amount))
        ;;4]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-auryn> (-)|<unbonding-auryn> (+)
            (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
        ;;5*]<Snake_Autostake> Account updates <UncoilLedger>
            (compose-capability (UPDATE_UNCOIL_LEDGER)) ;;Capability already granted by (UPDATE_AURYNZ)
        )
    )
    (defcap CULL_AURYN(patron:string culler:string culled-amount:decimal)
        (let
            (
                (auryn-id:string (UR_AurynID))
            )
        ;;1]Enforces that the culled amount is greater than 0.0, that is, that there are cullable positions.
            (enforce (> culled-amount 0.0) "No Elite-Auryn Uncoil Positions are cullable yet")
        ;;2]Snake_Autostake> Account transfers as method culled <AURYN|Auryn> to <client> Account
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF eauryn-id SC_NAME client culled-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron auryn-id SC_NAME culler culled-amount true))
        ;;3]<Snake_Autostake> Account updates <AutostakeLedger>|<unbonding-auryn> (-)
            (compose-capability (UPDATE_AUTOSTAKE_LEDGER))
        )
    )
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      PRIMARY Functions                       Stand-Alone Functions                                                                               ;;
    ;;                                                                                                                                                  ;;
    ;;      0)UTILITY                               Free Functions: can can be called by anyone. (Compute|Print|Read|Validate Functions)                ;;
    ;;                                                  No Key|Guard required.                                                                          ;;
    ;;      1)ADMINISTRATOR                         Administrator Functions: can only be called by module administrator.                                ;;
    ;;                                                  DPTF_ADMIN Capability Required.                                                                 ;;
    ;;      2)CLIENT                                Client Functions: can be called by any DPTS Account.                                                ;;
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
    ;;==================ELITE_ACCOUNT===============                                                                                                    ;;                                  ;;
    ;;      UC_Elite                                Computes Elite Account Data                                                                         ;;
    ;;      UP_Elite                                Prints Elite Account Data                                                                           ;;
    ;;      UC_EliteTierClass                       Returns Demiourgos Elite Account Tier Class                                                         ;;
    ;;      UC_EliteTierName                        Returns Demiourgos Elite Account Tier Name                                                          ;;
    ;;      UC_MajorEliteTier                       Returns Demiourgos Elite Account Major Tier                                                         ;;
    ;;      UC_MinorEliteTier                       Returns Demiourgos Elite Account Minor Tier                                                         ;;
    ;;      UC_DEB                                  Returns Demiourgos Elite Account Bonus (DEB)                                                        ;;
    ;;      UC_EliteTier                            Core Function that returns Major or Minor Elite Tier                                                ;;
    ;;      UC_EliteAurynzBalance                   Returns Total Elite Auryn Balance (True and Meta Fungible)                                          ;;
    ;;==================IDENTIFIERS=================                                                                                                    ;;
    ;;      UR_OuroborosID                          Returns as string the Ouroboros id                                                                  ;;
    ;;      UR_AurynID                              Returns as string the Auryn id                                                                      ;;
    ;;      UR_EliteAurynID                         Returns as string the Elite-Auryn id                                                                ;;
    ;;      UR_IgnisID                              Returns as string the Ignis id                                                                      ;;
    ;;      UR_VEliteAurynID                        Returns as string the Vested Elite-Auryn id                                                         ;;
    ;;==================AUTOSTAKE-LEDGER============                                                                                                    ;;
    ;;      UR_ResidentOuro                         Returns as decimal the amount of Resident Ouroboros                                                 ;;
    ;;      UR_UnbondingOuro                        Returns as decimal the amount of Unbonding Ouroboros                                                ;;
    ;;      UR_ResidentAuryn                        Returns as decimal the amount of Resident Auryn                                                     ;;
    ;;      UR_UnbondingAuryn                       Returns as decimal the amount of Unbonding Auryn                                                    ;;
    ;;      UR_Auryndex                             Returns the value of Auryndex with 24 decimals                                                      ;;
    ;;==================COMPUTATIONS================                                                                                                    ;;
    ;;      UC_IgnisMintAmount                      Computes Ignis Mint amount from Ouro-burn-amount                                                    ;;
    ;;      UC_OuroCoil                             Computes Ouro Coil Data: Outputs Auryn Output Amount                                                ;;
    ;;      UC_AurynUncoil                          Computes Auryn Uncoil Data: Outputs Decimal List                                                    ;;
    ;;      UC_AurynUncoilFeePromile                Computes Auryn Uncoil Fee Promile                                                                   ;;
    ;;      UC_UncoilDuration                       Computes Auryn Uncoil Duration in Hours for client                                                  ;;
    ;;      UC_UncoilDurationElite                  Computes Elite-Auryn Uncoil Duration in Hours for client                                            ;;
    ;;      UC_CullTime                             Computes Cull Time for Auryn using Tx present time                                                  ;;
    ;;      UC_CullTimeElite                        Computes Cull Time for Elite-Auryn using Tx present time                                            ;;
    ;;      UC_TotalCull                            Computes the sum of all balances that are cullable for Account                                      ;;
    ;;==================UNCOIL_COMPUTATIONS=========                                                                                                    ;;
    ;;      UR_MaximUncoilAmount                    Returns the max Auryn Uncoil amount                                                                 ;;
    ;;      UC_MinorEliteUncoilAmount               Returns the max Elite-Auryn Uncoil amount that preserves Minor Elite Account Tier                   ;;
    ;;      UC_MajorEliteUncoilAmount               Returns the max Elite-Auryn Uncoil amount that preserves Major Elite Account Tier                   ;;
    ;;      UC_MaximEliteUncoilAmount               Computes the max Elite-Auryn Uncoil amount                                                          ;;
    ;;      UC_MinorMajorEliteUncoilAmount          Computes Minor and Major Elite-Auryn Uncoil Amount                                                  ;;
    ;;==================UNCOIL-LEDGER_READINGS======                                                                                                    ;;
    ;;      UR_UncoilAmount                         Reads UncoilLedger and outputs Uncoil Balance for Account and Position                              ;;
    ;;      UR_CullAmount                           Reads UncoilLedger and outputs the Cull Balance for Account and Position                            ;;
    ;;      UR_UncoilPosition                       Reads best Auryn or Elite-Auryn uncoil Position                                                     ;;
    ;;      UR_CanCullUncoil                        Reads UncoilLedger and outputs a boolean list with cullable positions                               ;;
    ;;      UC_GetZeroPosition                      Computes best uncoil position from a list of balances                                               ;;
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
    ;;      C_UpdateAurynzData                      DPTS Account <client> updates Elite Account Status for Snake Account <account>                      ;;
    ;;==================Coil|Curl|Fuel==============                                                                                                    ;;
    ;;      C_CoilOuroboros                         Coils Ouroboros, staking it into the Autostake Pool, generating Auryn                               ;;
    ;;      C_FuelOuroboros                         Fuels the Autostake Pool with Ouroboros, increasing the Auryndex                                    ;;
    ;;      C_CoilAuryn                             Coils Auryn, securing it into the Autostake Pool, generating Elite-Auryn                            ;;
    ;;      C_CurlOuroboros                         Curls Ouroboros, then Curls Auryn in a single Function                                              ;;
    ;;==================AURYN-UNCOIL================                                                                                                    ;;
    ;;      C_UncoilAuryn                           Initiates Auryn Uncoil - does not work if all Auryn Uncoil positions are occupied                   ;;
    ;;      C_CullOuroboros                         Culls all cullable Auryn Uncoil Positions, collecting Ouroboros                                     ;;
    ;;==================ELITE-AURYN-UNCOIL==========                                                                                                    ;;
    ;;      C_UncoilEliteAuryn                      Initiates Elite-Auryn Uncoil - does not work if all Elite-Auryn Uncoil positions are occupied       ;;
    ;;      C_CullAuryn                             Culls all cullable Elite-Auryn Uncoil Positions, collecting Auryn                                   ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      AUXILIARY FUNCTIONS                                                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;==================MINT|BURN-SNAKE-TOKENS======                                                                                                    ;;
    ;;      X_BurnOuroboros                         Burns Ouroboros and generates Ignis at 100x capacity                                                ;;
    ;;      X_BurnAuryn                             Burns Auryn                                                                                         ;;
    ;;      X_BurnEliteAuryn                        Burns EliteAuryn                                                                                    ;;
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
    ;;==============================================
    ;;                                            ;;
    ;;      UTILITY FUNCTIONS                     ;;
    ;;                                            ;;
    ;;==================ELITE_ACCOUNT===============
    ;;
    ;;      UC_Elite|UP_Elite
    ;;      UC_EliteTierClas|UC_EliteTierName|UC_MajorEliteTier|UC_MinorEliteTier
    ;;      UC_DEB|UC_EliteTier|UC_EliteAurynzBalance
    ;;
    (defun UC_Elite:object{EliteAccountSchema} (x:decimal)
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
    (defun UP_Elite (account:string)
        @doc "Prints Elite Account Data"
        (with-default-read EliteTracker account
            { "class" : C1, "name" : N00, "tier" : "0.0" , "deb" : (at 0 DEB)}
            { "class" := c, "name" := n, "tier" := t, "deb" := d }
            (format "Account {}: Class = {}; Name = {}; Tier = {}; DEB = {};" [account c n t d])
        )
    )
    (defun UC_EliteTierClas:decimal (account:string)

        (OUROBOROS.UV_DPTS-Account account)
        (let*
            (
                (teab:decimal (UC_EliteAurynzBalance account))
                (elite:object{EliteAccountSchema} (UC_Elite teab))
                (deb (at "class" elite))
            )
            deb
        ) 
    )
    (defun UC_EliteTierName:decimal (account:string)
        (OUROBOROS.UV_DPTS-Account account)
        (let*
            (
                (teab:decimal (UC_EliteAurynzBalance account))
                (elite:object{EliteAccountSchema} (UC_Elite teab))
                (deb (at "name" elite))
            )
            deb
        ) 
    )
    (defun UC_MajorEliteTier:integer (account:string)
        @doc "Gets Major Elite Tier for Account"

        (OUROBOROS.UV_DPTS-Account account)
        (UC_EliteTier account true)
    )
    (defun UC_MinorEliteTier:integer (account:string)
        @doc "Gets Minor Elite Tier for Account"

        (OUROBOROS.UV_DPTS-Account account)
        (UC_EliteTier account false)
    )
    (defun UC_DEB:decimal (account:string)

        (OUROBOROS.UV_DPTS-Account account)
        (let*
            (
                (teab:decimal (UC_EliteAurynzBalance account))
                (elite:object{EliteAccountSchema} (UC_Elite teab))
                (deb (at "deb" elite))
            )
            deb
        ) 
    )
    (defun UC_EliteTier:integer (account:string major:bool)
        @doc "Core Function that returns Major or Minor Elite Tier"

        (OUROBOROS.UV_DPTS-Account account)
        (let*
            (
                (teab:decimal (UC_EliteAurynzBalance account))
                (elite:object{EliteAccountSchema} (UC_Elite teab))
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
    (defun UC_EliteAurynzBalance:decimal (account:string)

        (OUROBOROS.UV_DPTS-Account account)
        (let
            (
                (eab:decimal (OUROBOROS.UR_AccountTrueFungibleSupply (UR_EliteAurynID) account))
                (veab:decimal (DPMF.UR_AccountMetaFungibleSupply (UR_VEliteAurynID) account))
            )
            (+ eab veab)
        )
    )
    ;;==================IDENTIFIERS=================
    ;;      UR_OuroborosID|UR_AurynID|UR_EliteAurynID|UR_IgnisID|UR_VEliteAurynID
    ;;
    (defun UR_OuroborosID:string ()
        @doc "Returns as string the Ouroboros id"
        (at "ouro-id" (read TrinityTable TRINITY ["ouro-id"]))
    )
    (defun UR_AurynID:string ()
        @doc "Returns as string the Auryn id"
        (at "auryn-id" (read TrinityTable TRINITY ["auryn-id"]))
    )
    (defun UR_EliteAurynID:string ()
        @doc "Returns as string the Elite-Auryn id"
        (at "elite-auryn-id" (read TrinityTable TRINITY ["elite-auryn-id"]))
    )
    (defun UR_IgnisID:string ()
        @doc "Returns as string the Ignis id"
        (at "ignis-id" (read TrinityTable TRINITY ["ignis-id"]))
    )
    (defun UR_VEliteAurynID:string ()
        @doc "Returns as string the Ignis id"
        (at "vested-elite-auryn-id" (read TrinityTable TRINITY ["vested-elite-auryn-id"]))
    )
    ;;==================AUTOSTAKE-LEDGER============
    ;;      UR_ResidentOuro|UR_UnbondingOuro|UR_ResidentAuryn|UR_UnbondingAuryn
    ;;      UR_Auryndex
    ;;
    (defun UR_ResidentOuro:decimal ()
        @doc "Returns as decimal the amount of Resident Ouroboros"
        (at "resident-ouro" (read AutostakeLedger AUTOSTAKEHOLDINGS ["resident-ouro"]))
    )
    (defun UR_UnbondingOuro:decimal ()
        @doc "Returns as decimal the amount of Unbonding Ouroboros"
        (at "unbonding-ouro" (read AutostakeLedger AUTOSTAKEHOLDINGS ["unbonding-ouro"]))
    )
    (defun UR_ResidentAuryn:decimal ()
        @doc "Returns as decimal the amount of Resident Auryn"
        (at "resident-auryn" (read AutostakeLedger AUTOSTAKEHOLDINGS ["resident-auryn"]))
    )
    (defun UR_UnbondingAuryn:decimal ()
        @doc "Returns as decimal the amount of Unbonding Auryn"
        (at "unbonding-auryn" (read AutostakeLedger AUTOSTAKEHOLDINGS ["unbonding-auryn"]))
    )
    (defun UR_Auryndex:decimal ()
        @doc "Returns the value of Auryndex with 24 decimals"
        (let
            (
                (auryn-supply:decimal (OUROBOROS.UR_TrueFungibleSupply (UR_AurynID)))
                (r-ouro-supply:decimal (UR_ResidentOuro))
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
    ;;      UC_IgnisMintAmount|UC_OuroCoil|UC_AurynUncoil|UC_AurynUncoilFeePromile
    ;;      UC_UncoilDuration|UC_UncoilDurationElite|UC_CullTime|UC_CullTimeElite|UC_TotalCull
    ;;
    (defun UC_IgnisMintAmount:decimal (ouro-burn-amount:decimal)
        @doc "Computes Ignis Mint amount from Ouro-burn-amount"
        (let*
            (
                (ignis-decimals:integer (OUROBOROS.UR_TrueFungibleDecimals (UR_IgnisID)))
                (ignis-mint-amount:decimal (floor (* ouro-burn-amount 100.0) ignis-decimals))
            )
            ignis-mint-amount
        )   
    )
    (defun UC_OuroCoil:decimal (ouro-input-amount:decimal)
        @doc "Compute Ouroboros Coil Data. This amount includes: \
        \ Auryn Output Amount as decimal via Auryndex"

        (let
            (
                (auryndex:decimal (UR_Auryndex))
                (r-ouro-supply:decimal (UR_ResidentOuro))
                (auryndecimals:integer (OUROBOROS.UR_TrueFungibleDecimals (UR_AurynID)))
            )
            (if (= auryndex 0.0)
                ouro-input-amount
                (floor (/ ouro-input-amount auryndex) auryndecimals)
            )
        )
    )
    (defun UC_AurynUncoil:[decimal] (auryn-input-amount:decimal position:integer)
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
                (ouro-decimals:integer (OUROBOROS.UR_TrueFungibleDecimals (UR_OuroborosID)))
                (auryndex:decimal (UR_Auryndex))
                (ouro-redeem:decimal (floor (* auryn-input-amount auryndex) ouro-decimals))
                (uncoil-fee-promile:decimal (UC_AurynUncoilFeePromile auryn-input-amount position))
                (ouro-burn-fee:decimal (floor (* (/ uncoil-fee-promile 1000.0) ouro-redeem) ouro-decimals))
                (ouro-output:decimal (- ouro-redeem ouro-burn-fee))
            )
            [ouro-redeem ouro-output ouro-burn-fee uncoil-fee-promile]
        )
    )
    (defun UC_AurynUncoilFeePromile:decimal (x:decimal p:integer)
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
    (defun UC_UncoilDuration:integer (client:string)
        @doc "Computes Auryn Uncoil Duration in Hours for client "

        (let*
            (
                (teab:decimal (UC_EliteAurynzBalance client))
                (elite-object:object{EliteAccountSchema} (UC_Elite teab))
                (elite-tier:string (at "tier" elite-object))
                (major-elite-tier:integer (str-to-int (take 1 elite-tier)))
                (minor-elite-tier:integer (str-to-int (take -1 elite-tier)))
                (order:integer (+ (* (- major-elite-tier 1) 7 ) minor-elite-tier))
            )
            (if (= major-elite-tier 0)
                (at 0 AUHD)
                (at order AUHD)
            )
        )
    )
    (defun UC_UncoilDurationElite:integer (client:string elite-auryn-uncoil-amount:decimal)
        @doc "Computes Elite-Auryn Uncoil Duration in Hours for client considering the amount to be uncoiled \
            \ Exceptionally for an Utility Computation function, \
            \ it also enforces that the amount to be uncoiled is smaller than amount of Elite-Auryn existing on the <client> DPTF Account"
        (let*
            (
                (eab:decimal (OUROBOROS.UR_AccountTrueFungibleSupply (UR_EliteAurynID) client))
                (teab:decimal (UC_EliteAurynzBalance client))
                (teab-after-uncoil:decimal (- teab elite-auryn-uncoil-amount))
                (projected-elite-object:object{EliteAccountSchema} (UC_Elite teab-after-uncoil))
                (projected-elite-tier:string (at "tier" projected-elite-object))
                (projected-major-elite-tier:integer (str-to-int (take 1 projected-elite-tier)))
                (projected-minor-elite-tier:integer (str-to-int (take -1 projected-elite-tier)))
                (projected-order:integer (+ (* (- projected-major-elite-tier 1) 7 ) projected-minor-elite-tier))
            )
            (enforce 
                (<= elite-auryn-uncoil-amount eab) 
                (format "When computing Elite-Auryn Uncoil Duration, the Elite-Auryn-Uncoil-Amount of {} cannot be greater than the total Elite-Auryn Amount of {} held by the Account {}" [elite-auryn-uncoil-amount eab client])
            )
            (if (= projected-major-elite-tier 0)
                (at 0 EAUHD)
                (at projected-order EAUHD)
            )
        )
    )
    (defun UC_CullTime:time (client:string)
        @doc "Computes Cull Time for Auryn using Tx present time"

        (let
            (
                (present-time:time (at "block-time" (chain-data)))
                (auryn-uncoil-duration:integer (UC_UncoilDuration client))
            )
            (add-time present-time (hours auryn-uncoil-duration))
        )
    )
    (defun UC_CullTimeElite:time (client:string elite-auryn-uncoil-amount:decimal)
        @doc "Computes Cull Time for Elite-Auryn using Tx present time"

        (let
            (
                (present-time:time (at "block-time" (chain-data)))
                (elite-auryn-uncoil-duration:integer (UC_UncoilDurationElite client elite-auryn-uncoil-amount))
            )
            (add-time present-time (hours elite-auryn-uncoil-duration))
        )
    )
    (defun UC_TotalCull:decimal (account:string elite:bool)
        @doc "Computes the sum of all balances that are cullable for Account \
        \ Can be used for either Auryn or Elite-Auryn (via boolean elite) \
        \ Similar to X_CullUncoilAll, but does not cull positions, \
        \ Only reads cullable balances and adds them up"

        (let*
            (
                (cull-boolean-slice:[bool] (UR_CanCullUncoil account elite))
                (d1:decimal (UR_CullAmount (at 0 cull-boolean-slice) account 1 elite))
                (d2:decimal (UR_CullAmount (at 1 cull-boolean-slice) account 2 elite))
                (d3:decimal (UR_CullAmount (at 2 cull-boolean-slice) account 3 elite))
                (d4:decimal (UR_CullAmount (at 3 cull-boolean-slice) account 4 elite))
                (d5:decimal (UR_CullAmount (at 4 cull-boolean-slice) account 5 elite))
                (d6:decimal (UR_CullAmount (at 5 cull-boolean-slice) account 6 elite))
                (d7:decimal (UR_CullAmount (at 6 cull-boolean-slice) account 7 elite))
                (valid-culled-balances:[decimal] [d1 d2 d3 d4 d5 d6 d7])
            )
            (fold (+) 0.0 valid-culled-balances)
        )
    )
    ;;==================UNCOIL_COMPUTATIONS=========
    ;;
    ;;      UR_MaximUncoilAmount|UC_MinorEliteUncoilAmount|UC_MajorEliteUncoilAmount
    ;;      UC_MaximEliteUncoilAmount|UC_MinorMajorEliteUncoilAmount
    ;;
    (defun UR_MaximUncoilAmount:decimal (client:string)
        @doc "Returns the max Auryn Uncoil amount"
        (OUROBOROS.UR_AccountTrueFungibleSupply (UR_AurynID) client)
    )
    (defun UC_MinorEliteUncoilAmount:decimal (client:string)
        @doc "Returns the max Elite-Auryn Uncoil amount that preserves Minor Elite Account Tier"
        (at 0 (UC_MinorMajorEliteUncoilAmount client))
    )
    (defun UC_MajorEliteUncoilAmount:decimal (client:string)
        @doc "Returns the max Elite-Auryn Uncoil amount that preserves Minor Elite Account Tier"
        (at 1 (UC_MinorMajorEliteUncoilAmount client))
    )
    (defun UC_MaximEliteUncoilAmount:decimal (client:string)
        @doc "Computes the max Elite-Auryn Uncoil amount"

        (with-read UncoilLedger client
            { "P1" := o1, "P2" := o2, "P3" := o3, "P4" := o4, "P5" := o5, "P6" := o6, "P7" := o7 }
            (let*
                (
                    (eab:decimal (OUROBOROS.UR_AccountTrueFungibleSupply (UR_EliteAurynID) client))
                    (teab:decimal (UC_EliteAurynzBalance client))
                    (elite-object:object{EliteAccountSchema} (UC_Elite teab))
                    (elite-tier:string (at "tier" elite-object))
                    (major-elite-tier:integer (str-to-int (take 1 elite-tier)))
    
                    (ab1:decimal (at "eau-ab" o1))
                    (ab2:decimal (at "eau-ab" o2))
                    (ab3:decimal (at "eau-ab" o3))
                    (ab4:decimal (at "eau-ab" o4))
                    (ab5:decimal (at "eau-ab" o5))
                    (ab6:decimal (at "eau-ab" o6))
                    (ab7:decimal (at "eau-ab" o7))
                    (aurynbalancelist:[decimal] [ab1 ab2 ab3 ab4 ab5 ab6 ab7])
                    (current-zero-position:integer (UC_GetZeroPosition aurynbalancelist))
    
                    (vab1:decimal (if (> ab1 0.0 ) ab1 0.0))
                    (vab2:decimal (if (> ab2 0.0 ) ab2 0.0))
                    (vab3:decimal (if (> ab3 0.0 ) ab3 0.0))
                    (vab4:decimal (if (> ab4 0.0 ) ab4 0.0))
                    (vab5:decimal (if (> ab5 0.0 ) ab5 0.0))
                    (vab6:decimal (if (> ab6 0.0 ) ab6 0.0))
                    (vab7:decimal (if (> ab7 0.0 ) ab7 0.0))
                    (valid-balances:[decimal] [vab1 vab2 vab3 vab4 vab5 vab6 vab7])
                    (sum-valid-balances:decimal (fold (+) 0.0 valid-balances))
                )
                (if (= elite-tier "0.0")
                    0.0
                    (if (= elite-tier "0.1")
                        (if (= vab1 0.0) eab 0.0)
                        (let*
                            (
                                (first-order:integer (+ (* (- current-zero-position 1) 7) 1))
                                (balance-at-first-order:decimal (at first-order ET))
                                (theoretical-amount:decimal (- teab balance-at-first-order))
                            )
                            (if (> theoretical-amount eab)
                                eab
                                theoretical-amount
                            )
                        )
                    )
                )
            )
        )
    )
    (defun UC_MinorMajorEliteUncoilAmount:[decimal] (client:string)
        @doc "Computes Minor and Major Elite-Auryn Uncoil Amount"

        (let*
            (
                (eab:decimal (OUROBOROS.UR_AccountTrueFungibleSupply (UR_EliteAurynID) client))
                (teab:decimal (UC_EliteAurynzBalance client))
                (elite-object:object{EliteAccountSchema} (UC_Elite teab))
                (elite-tier:string (at "tier" elite-object))
                (major-elite-tier:integer (str-to-int (take 1 elite-tier)))
                (minor-elite-tier:integer (str-to-int (take -1 elite-tier)))
                (ea-dec:integer (OUROBOROS.UR_TrueFungibleDecimals (UR_EliteAurynID)))
                (atomic-unit:decimal (/ 1.0 (dec (^ 10 ea-dec))))
            )
            (if (= elite-tier "0.0")
                0.0
                (if (= elite-tier "0.1")
                    (- eab atomic-unit)
                    (let*
                        (
                            (order:integer (+ (* (- major-elite-tier 1) 7 ) minor-elite-tier))
                            (first-order:integer (+ (* (- major-elite-tier 1) 7) 1))
                            (balance-at-order:decimal (at order ET))
                            (balance-at-first-order:decimal (at first-order ET))
                            (difference:decimal (- teab balance-at-order))
                            (difference-at-first-order:decimal (- teab balance-at-first-order))
                            (minor-amount:decimal (if (< eab difference) eab difference))
                            (major-amount:decimal (if (< eab difference-at-first-order) eab difference-at-first-order))
                        )
                        [minor-amount major-amount]
                    ) 
                )
            )
        )
    )
    ;;==================UNCOIL-LEDGER_READINGS======
    ;;
    ;;      UR_UncoilAmount|UR_CullAmount|UR_UncoilPosition|UR_UncoilPositionElite
    ;;      UR_CanCullUncoil|UC_GetZeroPosition
    ;;
    (defun UP_UncoilLedger (account:string position:integer)
        (with-read UncoilLedger account
            { "P1" := o1, "P2" := o2, "P3" := o3, "P4" := o4, "P5" := o5, "P6" := o6, "P7" := o7 }
            (cond
                ((= position 1) (format "Account {} P1 position is {}" [account o1]))
                ((= position 2) (format "Account {} P2 position is {}" [account o2]))
                ((= position 3) (format "Account {} P3 position is {}" [account o3]))
                ((= position 4) (format "Account {} P4 position is {}" [account o4]))
                ((= position 5) (format "Account {} P5 position is {}" [account o5]))
                ((= position 6) (format "Account {} P6 position is {}" [account o6]))
                [account o7]
            )
        )
    )
    (defun UR_UncoilAmount:decimal (account:string position:integer elite:bool)
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
    (defun UR_CullAmount:decimal (cullable:bool account:string position:integer elite:bool)
        @doc "Reads UncoilLedger and outputs the Cull Balance for Account \
            \ Can be used for either Auryn or Elite-Auryn (via boolean elite) \
            \ The Cull Amount represents a cullable UncoilLedger Uncoil Balance Amount"

        (if (= cullable true)
            (with-capability (CULLABLE account position elite)
                (UR_UncoilAmount account position elite)
            )
            0.0
        )
    )
    (defun UR_UncoilPosition:integer (client:string)
        @doc "Gets best Auryn uncoil Position \
            \ Assumes Uncoil Ledger already exits. If it doesnt, it will fail"

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
                    (ouroborosbalancelist:[decimal] [ob1 ob2 ob3 ob4 ob5 ob6 ob7])
                )
                (UC_GetZeroPosition ouroborosbalancelist)
            )
        )
    )
    (defun UR_UncoilPositionElite:integer (client:string elite-auryn-uncoil-amount:decimal)
    @doc "Gets best Elite-Auryn uncoil Position considering the input <elite-auryn-uncoil-amount>\
        \ Assumes Uncoil Ledger already exits. If it doesnt, it will fail"

        (with-read UncoilLedger client
            { "P1" := o1, "P2" := o2, "P3" := o3, "P4" := o4, "P5" := o5, "P6" := o6, "P7" := o7 }
            (let*
                (
                    (eab:decimal (OUROBOROS.UR_AccountTrueFungibleSupply (UR_EliteAurynID) client))
                    (teab:decimal (UC_EliteAurynzBalance client))
                    (teab-after-uncoil:decimal (- teab elite-auryn-uncoil-amount))
                    (projected-elite-object:object{EliteAccountSchema} (UC_Elite teab-after-uncoil))
                    (projected-elite-tier:string (at "tier" projected-elite-object))
                    (projected-major-elite-tier:integer (str-to-int (take 1 projected-elite-tier)))

                    (ab1:decimal (at "eau-ab" o1))
                    (ab2:decimal (at "eau-ab" o2))
                    (ab3:decimal (at "eau-ab" o3))
                    (ab4:decimal (at "eau-ab" o4))
                    (ab5:decimal (at "eau-ab" o5))
                    (ab6:decimal (at "eau-ab" o6))
                    (ab7:decimal (at "eau-ab" o7))
                    (aurynbalancelist:[decimal] [ab1 ab2 ab3 ab4 ab5 ab6 ab7])
                    (current-zero-position:integer (UC_GetZeroPosition aurynbalancelist))
                )
                (enforce 
                    (<= elite-auryn-uncoil-amount eab) 
                    (format "When computing Elite-Auryn Uncoil Position, the Elite-Auryn-Uncoil-Amount of {} cannot be greater than the total Elite-Auryn Amount of {} held by the Account {}" [elite-auryn-uncoil-amount eab client])
                )
                (if (>= projected-major-elite-tier current-zero-position)
                    current-zero-position
                    ;; when PMET < CZP
                    -2
                )
            )
        )
    )
    (defun UR_CanCullUncoil:[bool] (account:string elite:bool)
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
    (defun UC_GetZeroPosition:integer (inputlist:[decimal])
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
    (defun A_InitialiseAutostake:[string] (patron:string ouro-id:string)
        @doc "Initialises the Autostake Smart-Contract \
        \ Returns the ids of Auryn, Elite-Auryn, Ignis in a list of strings"
        (OUROBOROS.UV_TrueFungibleIdentifier ouro-id)

        ;;Initialise the Autostake DPTS Account as a Smart Account
        ;;Necesary because it needs to operate as a MultiverX Smart Contract
        (OUROBOROS.C_DeploySmartDPTSAccount SC_NAME (keyset-ref-guard SC_KEY))

        (with-capability (AUTOSTAKE_INIT)
            ;;Issue Auryns Token
            (let
                (
                    (AurynID:string 
                        (OUROBOROS.C_IssueTrueFungible
                            patron
                            SC_NAME
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
                        (OUROBOROS.C_IssueTrueFungible
                            patron
                            SC_NAME
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
                        (OUROBOROS.C_IssueTrueFungible
                            patron
                            SC_NAME
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
                ;;Snake-Autostake MANAGEMENT
                ;;Issue OURO DPTF Account for the <Snake_Autostake> aka AutostakePool
                (OUROBOROS.C_DeployTrueFungibleAccount ouro-id SC_NAME)
                ;;SetTokenRoles
                ;;BURN Roles
                (OUROBOROS.C_ToggleBurnRole patron ouro-id SC_NAME true)
                (OUROBOROS.C_ToggleBurnRole patron AurynID SC_NAME true)
                (OUROBOROS.C_ToggleBurnRole patron EliteAurynID SC_NAME true)
                ;;MINT Roles
                (OUROBOROS.C_ToggleMintRole patron AurynID SC_NAME true)
                (OUROBOROS.C_ToggleMintRole patron EliteAurynID SC_NAME true)
                (OUROBOROS.C_ToggleMintRole patron IgnisID SC_NAME true)
                
                ;;Fee Settings
                (OUROBOROS.C_SetFee patron AurynID AURYN_FEE)
                (OUROBOROS.C_SetFee patron EliteAurynID ELITE-AURYN_FEE)
                (OUROBOROS.C_ToggleFee patron AurynID true)
                (OUROBOROS.C_ToggleFee patron EliteAurynID true)

                (OUROBOROS.C_ToggleFeeLock patron AurynID true)
                (OUROBOROS.C_ToggleFeeLock patron EliteAurynID true)

                ;;Finalise initialisation, returning the IDs of the created tokens.
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
            (OUROBOROS.X_IncrementNonce SC_NAME)
        )
    )
    ;;
    ;;-------------------------------------------------------------------------------------------------------
    ;;
    ;;      CLIENT FUNCTIONS
    ;;
    ;;      C_CarryAuryn|C_CarryElite-Auryn|C_UpdateAurynzData
    ;;
    (defun C_CarryAuryn (patron:string sender:string receiver:string carry-amount:decimal)
        @doc "Uses the Snake_Carrier Smart DPTS Account to move Auryn from <sender> to <receiver> \
        \ Keeps 5% as Carry Fee, which is the price for transfering Auryn \
        \ Assumes a DPTS account exists for the receiver"

        ;;0]Any Client can perform <C_CarryAuryn>; Smart DPTS Accounts arent required to provide their guards.
        ;;1]<Sender> Account transfers as method Auryn to the <Snake_Carrier>
        ;;2]<Snake-Carrier> transfers as method 95% of the amount to the <Receiver> Account, witholding 5% itself
        patron
    )
    (defun C_UpdateAurynzData (patron:string account:string)
        @doc "DPTS Account <client> updates Elite Account Status for Snake Account <account>"

        ;;0]Any Snake Token Account Owner can update his Demiourgos Elite Account
        (with-capability (UPDATE_AURYNZ patron account)
            (let
                (
                    (major:integer (UC_MajorEliteTier account))
                )
                (X_InitialiseUncoilLedger account)              ;works when not exist
                (X_UpdateUncoilLedgerWithElite account major)   ;always updates elite
                (X_UpdateEliteTracker account)                  ;works because Balance get is made with default read
            )
        )
    )
    ;;
    ;;==================Coil|Curl|Fuel==============
    ;;      C_CoilOuroboros|C_FuelOuroboros
    ;;      C_CoilAuryn|C_CurlOuroboros
    ;;
    (defun C_CoilOuroboros:decimal (patron:string coiler:string ouro-input-amount:decimal)
        @doc "Standard Coil Ouroboros function, for when <coiler> is a Normal DPTS Account \
        \ Does not work if the <coiler> is a Smart DPTS account"
        (with-capability (COIL_OUROBOROS patron coiler ouro-input-amount)
            (X_CoilOuroboros patron coiler ouro-input-amount)
        )
    )
    (defun CX_CoilOuroboros:decimal (patron:string coiler:string ouro-input-amount:decimal)
        @doc "Methodic Coil Ouroboros function, for when <coiler> is a Smart DPTS Account \
        \ Required Capability must be composed for the function using it."
        (require-capability (COIL_OUROBOROS patron coiler ouro-input-amount))
        (X_CoilOuroboros patron coiler ouro-input-amount)
    )
    (defun X_CoilOuroboros:decimal (patron:string coiler:string ouro-input-amount:decimal)
        @doc "Coils Ouroboros, staking it into the Autostake Pool, generating Auryn \
            \ Returns as decimal amount of generated Auryn \
            \ This is the Core Function"

        (require-capability (AUTOSTAKE_EXECUTOR))
        (let
            (
                (ouro-id:string (UR_OuroborosID))
                (auryn-id:string (UR_AurynID))
                (auryn-output-amount:decimal (UC_OuroCoil ouro-input-amount))
            )
        ;;1]<client> Account transfers as method <OURO|Ouroboros> to the <Snake_Autostake> Account for coiling(autostaking)
            (OUROBOROS.CX_TransferTrueFungible patron ouro-id coiler SC_NAME ouro-input-amount)
        ;;2]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (+)
            (X_UpdateResidentOuro ouro-input-amount true)
        ;;3]<Snake_Autostake> Account mints <AURYN|Auryn>
            (X_MintAuryn patron auryn-output-amount)
        ;;4]<Snake_Autostake> Account transfers as method <AURYN|Auryn> to <client> Account  
            (OUROBOROS.CX_TransferTrueFungible patron auryn-id SC_NAME coiler auryn-output-amount)
        ;;5]<UncoilLedger> and <EliteTracker> are updated with the operation
            (C_UpdateAurynzData patron coiler)
        ;;6]<auryn-output-amount> is returned
            auryn-output-amount
        )
    )
    (defun C_FuelOuroboros (patron:string fueler:string ouro-input-amount:decimal)
        @doc "Standard FuelOuroboros function, for when <fueler> is a Normal DPTS Account \
        \ Does not work if the <fueler> is a Smart DPTS account"
        (with-capability (FUEL_OUROBOROS patron fueler ouro-input-amount)
            (X_FuelOuroboros patron fueler ouro-input-amount)
        )
    )
    (defun CX_FuelOuroboros (patron:string fueler:string ouro-input-amount:decimal)
        @doc "Methodic FuelOuroboros function, for when <fueler> is a Smart DPTS Account \
        \ Required Capability must be composed for the function using it."
        (require-capability (FUEL_OUROBOROS patron fueler ouro-input-amount))
        (X_FuelOuroboros patron fueler ouro-input-amount)
    )
    (defun X_FuelOuroboros (patron:string fueler:string ouro-input-amount:decimal)
        @doc "Fuels Ouroboros to the Autostake Pool, increasing Auryndex"

        (require-capability (AUTOSTAKE_EXECUTOR))
        (let
            (
                (ouro-id:string (UR_OuroborosID))
            )
        ;;1]<client> Account transfers as method <OURO|Ouroboros> to the <Snake_Autostake> Account, for fueling (fueling does not generate <AURYN|Auryn>)
            (OUROBOROS.CX_TransferTrueFungible patron ouro-id fueler SC_NAME ouro-input-amount)
        ;;2]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (+)
            (X_UpdateResidentOuro ouro-input-amount true)
        )
    )

    (defun C_CoilAuryn (patron:string coiler:string auryn-input-amount:decimal)
        @doc "Standard CoilAuryn function, for when <coiler> is a Normal DPTS Account \
        \ Does not work if the <fueler> is a Smart DPTS account"
        (with-capability (COIL_AURYN patron coiler auryn-input-amount)
            (X_CoilAuryn patron coiler auryn-input-amount)
        )
    )
    (defun CX_CoilAuryn (patron:string coiler:string auryn-input-amount:decimal)
        @doc "Methodic CoilAuryn function, for when <coiler> is a Smart DPTS Account \
        \ Required Capability must be composed for the function using it."
        (require-capability (COIL_AURYN patron coiler auryn-input-amount))
        (X_CoilAuryn patron coiler auryn-input-amount)
    )
    (defun X_CoilAuryn (patron:string coiler:string auryn-input-amount:decimal)
        @doc "Coils Auryn, securing it into the Autostake Pool, generating Elite-Auryn"

        (require-capability (AUTOSTAKE_EXECUTOR))
        (let
            (
                (auryn-id:string (UR_AurynID))
                (eauryn-id:string (UR_EliteAurynID))
            )
        ;;1]<client> Account transfers as method <AURYN|Auryn> to the <Snake_Autostake> Account for coiling(autostkaing)
            (OUROBOROS.CX_TransferTrueFungible patron auryn-id coiler SC_NAME auryn-input-amount)
        ;;2]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-auryn> (+)
            (X_UpdateResidentAuryn auryn-input-amount true)
        ;;3]<Snake_Autostake> Account mints <EAURYN|Elite-Auryn>
            (X_MintEliteAuryn patron auryn-input-amount)
        ;;4]<Snake_Autostake> Account transfers as method <EAURYN|Elite-Auryn> to <client> Account
            (OUROBOROS.CX_TransferTrueFungible patron eauryn-id SC_NAME coiler auryn-input-amount)
        ;;5]<UncoilLedger> and <EliteTracker> are updated with the operation
            (C_UpdateAurynzData patron coiler) 
        )
    )

    (defun C_CurlOuroboros:decimal (patron:string coiler:string ouro-input-amount:decimal)
        @doc "Standard CurlOuroboros function, for when <coiler> is a Normal DPTS Account \
            \ Does not work if the <fueler> is a Smart DPTS account"
        (with-capability (CURL_OUROBOROS patron coiler ouro-input-amount)
            (X_CurlOuroboros patron coiler ouro-input-amount)
        )
    )
    (defun CX_CurlOuroboros:decimal (patron:string coiler:string ouro-input-amount:decimal)
        @doc "Methodic CurlOuroboros function, for when <coiler> is a Smart DPTS Account \
            \ Required Capability must be composed for the function using it."
        (require-capability (CURL_OUROBOROS patron coiler ouro-input-amount))
        (X_CurlOuroboros patron coiler ouro-input-amount)
    )
    (defun X_CurlOuroboros:decimal (patron:string coiler:string ouro-input-amount:decimal)
        @doc "Curls Ouroboros, then Curls Auryn in a single Function \
            \ Outputs the Amount of Elite-Auryn resulted"

        (require-capability (AUTOSTAKE_EXECUTOR))
        (let
            (
                (ouro-id:string (UR_OuroborosID))
                (eauryn-id:string (UR_EliteAurynID))
                (auryn-output-amount:decimal (UC_OuroCoil ouro-input-amount))
            )  
        ;;1]<client> Account transfers as method <OURO|Ouroboros> to the <Snake_Autostake> Account for curling (double-coiling) 
            (OUROBOROS.CX_TransferTrueFungible patron ouro-id coiler SC_NAME ouro-input-amount)
        ;;2]<Snake_Autostake> Account mints <AURYN|Auryn>
            (X_MintAuryn patron auryn-output-amount)
        ;;3]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (+)|<resident-auryn> (+)
            (X_UpdateResidentOuro ouro-input-amount true)
            (X_UpdateResidentAuryn auryn-output-amount true)
        ;;4]<Snake_Autostake> Account mints <EAURYN|Elite-Auryn>
            (X_MintEliteAuryn patron auryn-output-amount)
        ;;5]<Snake_Autostake> Account transfers as method <EAURYN|Elite-Auryn> to <client> Account
            (OUROBOROS.CX_TransferTrueFungible patron eauryn-id SC_NAME coiler auryn-output-amount)
        ;;6]<UncoilLedger> and <EliteTracker> are updated with the operation
            (C_UpdateAurynzData patron coiler)  
            auryn-output-amount 
        )
    )
    ;;
    ;;==================AURYN-UNCOIL================
    ;;      C_UncoilAuryn|C_CullOuroboros
    ;;
    (defun C_UncoilAuryn (patron:string uncoiler:string auryn-input-amount:decimal)
        @doc "Uncoils Auryn, generating Ouroboros for client and IGNIS for Autostake \
            \ Uses the best(cheapest) uncoil Position. This is determined automatically \
            \ and must not be entered as a parameter. When no position is available, function fails."
        
        ;;0]Any Client can perform <C_UncoilAuryn>; Smart DPTS Accounts arent required to provide their guards
        (with-capability (UNCOIL_AURYN patron uncoiler auryn-input-amount)
        ;;1]<UncoilLedger> and <EliteTracker> are updated with the operation; <UncoilLedger> must exist for operation
        (C_UpdateAurynzData patron uncoiler)
            (let*
                (
                    (auryn-id:string (UR_AurynID))
                    (uncoil-position:integer (UR_UncoilPosition uncoiler))
                    (uncoil-data:[decimal] (UC_AurynUncoil auryn-input-amount uncoil-position))
                    (ouro-redeem-amount:decimal (at 0 uncoil-data))
                    (ouro-output-amount:decimal (at 1 uncoil-data))
                    (ouro-burn-fee-amount:decimal (at 2 uncoil-data))
                    (cull-time:time (UC_CullTime uncoiler))
                )
        ;;Enforces a position is free for update, otherwise uncoil cannot execute. If no positions is free, position is returned as -1
                (enforce (!= uncoil-position -1) "No more Auryn Uncoil Positions")
        ;;2]<client> Account transfers as method <AURYN|Auryn> to <Snake_Autostake> Account for burning
                (OUROBOROS.CX_TransferTrueFungible patron auryn-id uncoiler SC_NAME auryn-input-amount)
        ;;3]<Snake_Autostake> Account burns the whole <AURYN|Auryn> transferred
                (X_BurnAuryn patron auryn-input-amount)
        ;;4)<Snake_Autostake> Account burns <OURO|Ouroboros> as uncoil fee (burning <OURO|Ouroboros automatically mints <IGNIS|Ignis>)
                (X_BurnOuroboros patron ouro-burn-fee-amount)
        ;;5]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-ouro> (-)|<unbonding-ouro> (+)
                (X_UpdateResidentOuro ouro-redeem-amount false)
                (X_UpdateUnbondingOuro ouro-output-amount true)
        ;;6]<Snake_Autostake> Account updates <UncoilLedger>
                (X_UpdateUncoilLedger uncoiler uncoil-position ouro-output-amount cull-time false)
            )
        )
    )
    (defun C_CullOuroboros (patron:string culler:string)
        @doc "Culls all cullable Auryn Uncoil Positions, collecting Ouroboros \
            \ Fails if no cullable positions exist, or if no entry for account in UncoilLedger exist"

        (with-capability (CULL_EXECUTOR)
            (let
                (
                    (ouro-id:string (UR_OuroborosID))
                    (culled-amount:decimal (X_CullUncoilAll culler false))
                )
        ;;0]Any Client can perform <C_CullOuroboros>; Smart DPTS Accounts arent required to provide their guards
        ;;1]Enforces that the culled amount is greater than 0.0, that is, that there are cullable positions.
                (with-capability (CULL_OUROBOROS patron culler culled-amount)
        ;;2]Snake_Autostake> Account transfers as method culled  <OURO|Ouroboros> to <client> Account
                    (OUROBOROS.CX_TransferTrueFungible patron ouro-id SC_NAME culler culled-amount)
        ;;3]<Snake_Autostake> Account updates <AutostakeLedger>|<unbonding-ouro> (-)
                    (X_UpdateUnbondingOuro culled-amount false)
                )
            )
        )
    )
    ;;
    ;;==================ELITE-AURYN-UNCOIL==========
    ;;      C_UncoilEliteAuryn|C_CullAuryn
    ;;
    (defun C_UncoilEliteAuryn (patron:string uncoiler:string elite-auryn-input-amount:decimal)
        @doc "Uncoils EliteAuryn, generating Auryn for client \
            \ Uses the best(cheapest) uncoil Position. This is determined automatically \
            \ and must not be entered as a parameter. When no position is available, function fails."
        
        ;;0]Any Client can perform <C_UncoilEliteAuryn>; Smart DPTS Accounts arent required to provide their guards
        (with-capability (UNCOIL_ELITE-AURYN patron uncoiler elite-auryn-input-amount)
        ;;1]<UncoilLedger> and <EliteTracker> are updated with the operation; <UncoilLedger> must exist for operation
            (C_UpdateAurynzData patron uncoiler)
            (let
                (
                    (eauryn-id:string (UR_EliteAurynID))
                    (uncoil-position:integer (UR_UncoilPositionElite uncoiler elite-auryn-input-amount))
                    (cull-time:time (UC_CullTimeElite uncoiler elite-auryn-input-amount))
                )
        ;;Enforces a position is free for update, otherwise uncoil cannot execute. If no positions is free, position is returned as -1
                (if (= uncoil-position -2)
                    (enforce (>= uncoil-position 0) (format "Uncoiling {} Elite-Auryn surpasses the Uncoiling Position Capabilities offered by the resulted Major Elite Tier" [elite-auryn-input-amount]))
                    (enforce (>= uncoil-position 0) "No more Elite-Auryn Uncoil Positions")
                )
        ;;2]<client> Account transfers as method <ELITEAURYN|EliteAuryn> to <Snake_Autostake> Account for burning
                (OUROBOROS.CX_TransferTrueFungible patron eauryn-id uncoiler SC_NAME elite-auryn-input-amount)
        ;;3]<Snake_Autostake> Account burns the whole <ELITEAURYN|EliteAuryn> transferred
                (X_BurnEliteAuryn patron elite-auryn-input-amount)
        ;;4]<Snake_Autostake> Account updates <AutostakeLedger>|<resident-auryn> (-)|<unbonding-auryn> (+)
                (X_UpdateResidentAuryn elite-auryn-input-amount false)
                (X_UpdateUnbondingAuryn elite-auryn-input-amount true)
        ;;5*]<Snake_Autostake> Account updates <UncoilLedger>
                (X_UpdateUncoilLedger uncoiler uncoil-position elite-auryn-input-amount cull-time true)
        ;;6]<UncoilLedger> and <EliteTracker> are updated once again with the operation since Elite-Auryn amounts will change with operation
                (C_UpdateAurynzData patron uncoiler)
            )
        )
    )
    (defun C_CullAuryn (patron:string culler:string)
        @doc "Culls all cullable Elite-Auryn Uncoil Positions, collecting Auryn \
            \ Fails if no cullable positions exist, or if no entry for account in UncoilLedger exist"
        
        (with-capability (CULL_EXECUTOR)
            (let*
                (
                    (auryn-id:string (UR_AurynID))
                    (culled-amount:decimal (X_CullUncoilAll culler true))
                )
        ;;0]Any Client can perform <C_CullAuryn>; Smart DPTS Accounts arent required to provide their guards
        ;;1]Enforces that the culled amount is greater than 0.0, that is, that there are cullable positions.
                (with-capability (CULL_AURYN patron culler culled-amount)
        ;;2]Snake_Autostake> Account transfers as method culled <AURYN|Auryn> to <client> Account
                    (OUROBOROS.CX_TransferTrueFungible patron auryn-id SC_NAME culler culled-amount)
        ;;3]<Snake_Autostake> Account updates <AutostakeLedger>|<unbonding-auryn> (-)
                    (X_UpdateUnbondingAuryn culled-amount false)
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
    ;;      X_MintAuryn|X_MintEliteAuryn
    ;;
    (defun X_BurnOuroboros (patron:string amount:decimal)
        @doc "Burns Ouroboros and generates Ignis at 100x capacity"
        (OUROBOROS.CX_Burn patron (UR_OuroborosID) SC_NAME amount)
        (OUROBOROS.CX_Mint patron (UR_IgnisID) SC_NAME (UC_IgnisMintAmount amount) false)
    )
    (defun X_BurnAuryn (patron:string amount:decimal)
        @doc "Burns Auryn"
        (OUROBOROS.CX_Burn patron (UR_AurynID) SC_NAME amount)
    )
    (defun X_BurnEliteAuryn (patron:string amount:decimal)
        @doc "Burns Elite-Auryn"
        (OUROBOROS.CX_Burn patron (UR_EliteAurynID) SC_NAME amount)
    )
    (defun X_MintAuryn (patron:string amount:decimal)
        @doc "Mints Auryn"
        (OUROBOROS.CX_Mint patron (UR_AurynID) SC_NAME amount false)
    )
    (defun X_MintEliteAuryn (patron:string amount:decimal)
        @doc "Mints Elite-Auryn"
        (OUROBOROS.CX_Mint patron (UR_EliteAurynID) SC_NAME amount false)
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
                (cull-boolean-slice:[bool] (UR_CanCullUncoil account elite))
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
            \ Can be used for either Auryn or Elite-Auryn (via boolean <elite>) \
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
                    
                    (major:integer (UC_MajorEliteTier account))

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

        (require-capability (SNAKE_TOKEN_ACCOUNT_EXISTANCE account))
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
                (iz-sc:bool (OUROBOROS.UR_DPTS-AccountType account))
                (teab:decimal (UC_EliteAurynzBalance account))
                (elite:object{EliteAccountSchema} (UC_Elite teab))
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
        (enforce (contains tier (enumerate 0 7)) "Invalid Tier for Elite Uncoil Position Management")
        (require-capability (UNCOIL-LEDGER_MANAGING-TIER tier))
        (let
            (
                (hexa:[bool] (XU_MakeHexaBooleanList tier))
            )
            (with-capability (UNCOIL-LEDGER_MANAGING-POSITION 1)
                (XU_ToggleEliteUncoilPosition account 1 (at 0 hexa))   ;;manages position 1
            )
            (with-capability (UNCOIL-LEDGER_MANAGING-POSITION 2)
                (XU_ToggleEliteUncoilPosition account 2 (at 1 hexa))   ;;manages position 2
            )
            (with-capability (UNCOIL-LEDGER_MANAGING-POSITION 3)
                (XU_ToggleEliteUncoilPosition account 3 (at 2 hexa))   ;;manages position 3
            )
            (with-capability (UNCOIL-LEDGER_MANAGING-POSITION 4)
                (XU_ToggleEliteUncoilPosition account 4 (at 3 hexa))   ;;manages position 4
            )
            (with-capability (UNCOIL-LEDGER_MANAGING-POSITION 5)
                (XU_ToggleEliteUncoilPosition account 5 (at 4 hexa))   ;;manages position 5
            )
            (with-capability (UNCOIL-LEDGER_MANAGING-POSITION 6)
                (XU_ToggleEliteUncoilPosition account 6 (at 5 hexa))   ;;manages position 6
            )
            (with-capability (UNCOIL-LEDGER_MANAGING-POSITION 7)
                (XU_ToggleEliteUncoilPosition account 7 (at 6 hexa))   ;;manages position 7
            )
        )
    )
    (defun XU_MakeHexaBooleanList:[bool] (tier:integer)
        @doc "Creates a list of 6 bolean values depending based on Major Elite Tier Value"
        (require-capability (UNCOIL-LEDGER_MANAGING-TIER tier))
        (cond
            ((or (= tier 0)(= tier 1))[true false false false false false false])
            ((= tier 2) [true true false false false false false])
            ((= tier 3) [true true true false false false false])
            ((= tier 4) [true true true true false false false])
            ((= tier 5) [true true true true true false false])
            ((= tier 6) [true true true true true true false])
            [true true true true true true true]
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