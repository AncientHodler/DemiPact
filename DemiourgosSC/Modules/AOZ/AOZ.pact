
;(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")
(module AGEOFZALMOXIS GOVERNANCE
    ;(use n_e096dec549c18b706547e425df9ac0571ebd00b0.BASIS)
    ;(use n_e096dec549c18b706547e425df9ac0571ebd00b0.TALOS|DPTF)
    ;(use n_e096dec549c18b706547e425df9ac0571ebd00b0.TALOS|DPTF2)
    ;(use n_e096dec549c18b706547e425df9ac0571ebd00b0.TALOS|ATS1)
    ;(use n_e096dec549c18b706547e425df9ac0571ebd00b0.TALOS|ATS2)
    (use BASIS)
    (use ATS)
    (use TALOS|DPTF)
    (use TALOS|DPTF2)
    (use TALOS|ATS1)
    (use TALOS|ATS2)

    ;;Module Governance
    (defcap GOVERNANCE ()
        @doc "AoZ Module Governance Capability"
        (compose-capability (AOZ|MASTER))
    )
    (defcap AOZ|MASTER ()
        @doc "AOZ Master Capability"
        (compose-capability (AOZ-ADMIN))
    )
    (defcap AOZ-ADMIN ()
        (enforce-guard
            (UTILS.GUARD|UEV_Any
                [
                    G-MD_AOZ
                    G-SC_AOZ
                ]
            )
        )
    )
    ;;Module Guard
    (defconst G-MD_AOZ   (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_AOZ   (keyset-ref-guard AOZ|SC_KEY))

    (defconst AOZ|SC_KEY "free.User000i-Keyset")
    (defconst AOZ|SC_NAME "Ѻ.ÅτhGźνΣhςвiàÁĘĚДÏWÉΨTěCÃŒnæi9цéŘQí¢лΞÛIчмfÓeżÜýЯàDÖ5αȚÞVđσγ₱0ęЬÔĄsĄLлKùvåH£ΞMFУûÊyđÜqdŽŚЖsĘъsПÂÔØŹÞŮγŚΣЧ6Ïж¢чPyòлБ14ÚęŃĄåîêтηΛbΦđkûÇĂζsБúĎdŸUЛзÙÂÚJηXťćж¥zщòÁŸRĘ")
    (defconst AOZ|SC_KDA-NAME "k:95a59029029524ebb250b2fafe6826ff88bb59c527d661cba3279d09a51d3bdf")
    (defconst AOZ|PBL "9G.29k17uqiwBF7mbc3rzr5gz228lxepz7a0fwrja2Bgzk1czjCLja3wg9q1ey10ftFhxIAiFBHCtvotkmKIIxFisMni8EA6esncL3lg2uLLH2u89Er9sgbeGmK0k7b63xujf1nAIf5GB583fcE6pzFak2CwhEi1dHzI0F14tvtxv4H8r1ABk5weoJ7HfCoadMm1h8MjIwjzbDKo80H25AJL8I1JiFF66Iwjcj3sFrD9xaqz1ziEEBJICF2k81pG9ABpDk2rK4ooglCK3kmC0h7yvvakjIvMpGp00jnw2Cpg1HoxjK0HoqzuKciIIczGsEzCjoB43x7lKsxkzAm7op2urv0I85Kon7uIBmg328cuKMc8driw8boAFnrdqHEFhx4sFjm8DM44FutCykKGx7GGLnoeJLaC707lot9tM51krmp6KDG8Ii318fIc1L5iuzqEwDnkro35JthzlDD1GkJaGgze3kDApAckn3uMcBypdz4LxbDGrg5K2GdiFBdFHqdpHyssrH8t694BkBtM9EB3yI3ojbnrbKrEM8fMaHAH2zl4x5gdkHnpjAeo8nz")

;;  1]CONSTANTS Definitions
    (defconst AOZ|INFO "AOZ-Table-Key")
;;  2]SCHEMAS Definitions
    (defschema AOZ|PropertiesSchema
        primal-tf-ids:[string]
        primal-mf-ids:[string]
        atspair-ids:[string]
        tf-game-assets:[string]
        mf-game-assets:[string]
        sf-game-assets:[string]
        nf-game-assets:[string]
    )
;;  3]TABLES Definitions
    (deftable AOZ|Assets:{AOZ|PropertiesSchema})
    ;;
    ;;
    ;;            AOZ               Submodule
    ;;
    ;;            CAPABILITIES      <>
    ;;            FUNCTIONS         [10]
    ;;========[D] RESTRICTIONS=================================================;;
    ;;            Capabilities FUNCTIONS                [CAP]
    ;;            Function Based & CAPABILITIES         [CF](have this tag)
    ;;            Enforcements & Validations FUNCTIONS  [UEV]
    ;;            Composed CAPABILITIES                 [CC](dont have this tag)
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;            Data Read FUNCTIONS                   [UR]
    ;;            Data Read and Computation FUNCTIONS   [URC] and [UC]
    ;;            Data Creation|Composition Functions   [UCC]
    ;;       [10] Administrative Usage Functions        [A]
    ;;            Client Usage FUNCTIONS                [C]
    ;;            Auxiliary Usage Functions             [X]
    ;;=========================================================================;;
    ;;
    ;;            START
    ;;
    ;;========[D] RESTRICTIONS=================================================;;
    ;;     (NONE) Capabilities FUNCTIONS                [CAP]
    ;;     (NONE) Function Based & CAPABILITIES         [CF](have this tag)
    ;;     (NONE) Enforcements & Validations FUNCTIONS  [UEV]
    ;;     (NONE) Composed CAPABILITIES                 [CC](dont have this tag)
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;        [1] Data Read FUNCTIONS                   [UR]
    (defun AOZ|UR_Assets:string (asset-row:integer position:integer)
        (UTILS.UTILS|UEV_PositionalVariable asset-row 7 "Asset-Row Input out of Bounds")
        (with-read AOZ|Assets AOZ|INFO
            { "primal-tf-ids"       := pti 
            , "primal-mf-ids"       := pmi
            , "atspair-ids"         := ats
            ,"tf-game-assets"       := tf
            ,"mf-game-assets"       := mf
            ,"sf-game-assets"       := sf
            ,"nf-game-assets"       := nf
            }
            (let
                (
                    (l1:integer (length pti))
                    (l2:integer (length pmi))
                    (l3:integer (length ats))
                    (l4:integer (length tf))
                    (l5:integer (length mf))
                    (l6:integer (length sf))
                    (l7:integer (length nf))
                )
                (cond
                    ((= asset-row 1) (enforce (= (contains position (enumerate 0 (- l1 1))) true) (format "Position {} out of bounds for Asset-Row {}" [position asset-row])))
                    ((= asset-row 2) (enforce (= (contains position (enumerate 0 (- l2 1))) true) (format "Position {} out of bounds for Asset-Row {}" [position asset-row])))
                    ((= asset-row 3) (enforce (= (contains position (enumerate 0 (- l3 1))) true) (format "Position {} out of bounds for Asset-Row {}" [position asset-row])))
                    ((= asset-row 4) (enforce (= (contains position (enumerate 0 (- l4 1))) true) (format "Position {} out of bounds for Asset-Row {}" [position asset-row])))
                    ((= asset-row 5) (enforce (= (contains position (enumerate 0 (- l5 1))) true) (format "Position {} out of bounds for Asset-Row {}" [position asset-row])))
                    ((= asset-row 6) (enforce (= (contains position (enumerate 0 (- l6 1))) true) (format "Position {} out of bounds for Asset-Row {}" [position asset-row])))
                    ((= asset-row 7) (enforce (= (contains position (enumerate 0 (- l7 1))) true) (format "Position {} out of bounds for Asset-Row {}" [position asset-row])))
                    true
                )
                (cond
                    ((= asset-row 1) (at position pti))
                    ((= asset-row 2) (at position pmi))
                    ((= asset-row 3) (at position ats))
                    ((= asset-row 4) (at position tf))
                    ((= asset-row 5) (at position mf))
                    ((= asset-row 6) (at position sf))
                    ((= asset-row 7) (at position nf))
                    true
                )
                
            )
        )
    )
    ;;     (NONE) Data Read and Computation FUNCTIONS   [URC] and [UC]
    ;;     (NONE) Data Creation|Composition Functions   [UCC]
    ;;            Administrative Usage Functions        [A]
    (defun AOZ|A_InitialiseAssets ()
        @doc "Initialises the AOZ Assets Table"
        (with-capability (AOZ-ADMIN)
            (insert AOZ|Assets AOZ|INFO
                {"primal-tf-ids"            : [""]
                ,"primal-mf-ids"            : [""]
                ,"atspair-ids"              : [""]
                ,"tf-game-assets"           : [""]
                ,"mf-game-assets"           : [""]
                ,"sf-game-assets"           : [""]
                ,"nf-game-assets"           : [""]}
            )
        )
    )
    (defun AOZ|A_AddPrimalTrueFungible (tf:string)
        (BASIS.DPTF-DPMF|UEV_id tf true)
        (require-capability (AOZ-ADMIN))
        (with-read AOZ|Assets AOZ|INFO
            { "primal-tf-ids" := pti }
            (update AOZ|Assets AOZ|INFO
                { "primal-tf-ids" : 
                    (if (= pti [""])
                        [tf]
                        (UTILS.LIST|UC_AppendLast pti tf)
                    )
                }
            )
        )
    )
    (defun AOZ|A_AddPrimalMetaFungible (mf:string)
        (BASIS.DPTF-DPMF|UEV_id mf false)
        (require-capability (AOZ-ADMIN))
        (with-read AOZ|Assets AOZ|INFO
            { "primal-mf-ids" := pmi }
            (update AOZ|Assets AOZ|INFO
                { "primal-mf-ids" : 
                    (if (= pmi [""])
                        [mf]
                        (UTILS.LIST|UC_AppendLast pmi mf)
                    )
                }
            )
        )
    )
    (defun AOZ|A_AddATSPair (atspair:string)
        (ATS.ATS|UEV_id atspair)
        (require-capability (AOZ-ADMIN))
        (with-read AOZ|Assets AOZ|INFO
            { "atspair-ids" := ats }
            (update AOZ|Assets AOZ|INFO
                { "atspair-ids" : 
                    (if (= ats [""])
                        [atspair]
                        (UTILS.LIST|UC_AppendLast ats atspair)
                    )
                }
            )
        )
    )
    (defun AOZ|A_AddTrueFungibleGameAsset (tf:string)
        (BASIS.DPTF-DPMF|UEV_id tf true)
        (require-capability (AOZ-ADMIN))
        (with-read AOZ|Assets AOZ|INFO
            { "tf-game-assets" := tga }
            (update AOZ|Assets AOZ|INFO
                { "tf-game-assets" : 
                    (if (= tga [""])
                        [tf]
                        (UTILS.LIST|UC_AppendLast tga tf)
                    )
                }
            )
        )
    )
    (defun AOZ|A_AddMetaFungibleGameAsset (mf:string)
        (BASIS.DPTF-DPMF|UEV_id mf false)
        (require-capability (AOZ-ADMIN))
        (with-read AOZ|Assets AOZ|INFO
            { "mf-game-assets" := mga }
            (update AOZ|Assets AOZ|INFO
                { "mf-game-assets" : 
                    (if (= mga [""])
                        [mf]
                        (UTILS.LIST|UC_AppendLast mga mf)
                    )
                }
            )
        )
    )
    (defun AOZ|A_IssueTrueFungibles:[string] (patron:string)
        @doc "Mints all DPTF Tokens needed for AOZ and adds their ids to the AOZ|Assets"
        (with-capability (AOZ-ADMIN)
            (let*
                (
                    (tf-ids:[string]
                        (TALOS|DPTF.C_Issue
                            patron
                            AOZ|SC_NAME
                            ["PrimordialKoson" "EsothericKoson" "AncientKoson" "PlebiumDenarius" "ComatusAureus" "PileatusSolidus" "TarabostesStater" "StrategonDrachma" "BasileonAs"]
                            ["PKOSON" "EKOSON" "AKOSON" "PDKOSON" "CAKOSON" "PSKOSON" "TSKOSON" "SDKOSON" "BAKOSON"]
                            [24 24 24 24 24 24 24 24 24]
                            [true true true true true true true true true]          ;;can change owner
                            [true true true true true true true true true]          ;;can upgrade
                            [true true true true true true true true true]          ;;can can-add-special-role
                            [false false false false false false false false false] ;;can-freeze
                            [false false false false false false false false false] ;;can-wipe
                            [true true true true true true true true true]          ;;can pause
                        )
                    )
                )
                (map
                    (lambda
                        (idx:integer)
                        (AOZ|A_AddPrimalTrueFungible (at idx tf-ids))
                    )
                    (enumerate 0 8)
                )
                tf-ids
            )
        )
    )
    (defun AOZ|A_SetupTrueFungibles (patron:string)
        @doc "Sets up the AOZ Primal True Fungible Tokens"
        (let
            (
                (PlebiumDenariusID:string (AOZ|UR_Assets 1 3))
                (ComatusAureusID:string (AOZ|UR_Assets 1 4))
                (PileatusSolidusID:string (AOZ|UR_Assets 1 5))
                (TarabostesStaterID:string (AOZ|UR_Assets 1 6))
                (StrategonDrachmaID:string (AOZ|UR_Assets 1 7))
                (BasileonAsID:string (AOZ|UR_Assets 1 8))
            )
            ;;Set Transaction Fees for Minor Solid Kosonic Currencies
            (TALOS|DPTF.C_SetFee patron PlebiumDenariusID 10.0)
            (TALOS|DPTF.C_ToggleFee patron PlebiumDenariusID true)
            (TALOS|DPTF.C_ToggleFeeLock patron PlebiumDenariusID true)

            (TALOS|DPTF.C_SetFee patron ComatusAureusID 20.0)
            (TALOS|DPTF.C_ToggleFee patron ComatusAureusID true)
            (TALOS|DPTF.C_ToggleFeeLock patron ComatusAureusID true)

            (TALOS|DPTF.C_SetFee patron PileatusSolidusID 30.0)
            (TALOS|DPTF.C_ToggleFee patron PileatusSolidusID true)
            (TALOS|DPTF.C_ToggleFeeLock patron PileatusSolidusID true)

            (TALOS|DPTF.C_SetFee patron TarabostesStaterID 40.0)
            (TALOS|DPTF.C_ToggleFee patron TarabostesStaterID true)
            (TALOS|DPTF.C_ToggleFeeLock patron TarabostesStaterID true)

            (TALOS|DPTF.C_SetFee patron StrategonDrachmaID 50.0)
            (TALOS|DPTF.C_ToggleFee patron StrategonDrachmaID true)
            (TALOS|DPTF.C_ToggleFeeLock patron StrategonDrachmaID true)

            (TALOS|DPTF.C_SetFee patron BasileonAsID 60.0)
            (TALOS|DPTF.C_ToggleFee patron BasileonAsID true)
            (TALOS|DPTF.C_ToggleFeeLock patron BasileonAsID true)
        )
    )
    (defun AOZ|A_IssueMetaFungibles:[string] (patron:string)
        @doc "Mints all DPMF Tokens needed for AOZ and adds their ids to the AOZ|Assets"
        (with-capability (AOZ-ADMIN)
            (let
                (
                    (mf-ids:[string]
                        (TALOS|DPMF.C_Issue
                            patron
                            AOZ|SC_NAME
                            ["DenariusDebilis" "AureusFragilis" "SolidusFractus" "StaterTenuulus" "DrachmaMinima" "AsInfinimus"]
                            ["DDKOSON" "AFKOSON" "SFKOSON" "STKOSON" "DMKOSON" "AIKOSON"]
                            [24 24 24 24 24 24]
                            [true true true true true true]                         ;;can change owner
                            [true true true true true true]                         ;;can upgrade
                            [true true true true true true]                         ;;can can-add-special-role
                            [false false false false false false]                   ;;can-freeze
                            [false false false false false false]                   ;;can-wipe
                            [true true true true true true]                         ;;can pause
                            [true true true true true true]                         ;;can-transfer-nft-create-role
                        )
                    )
                )
                (map
                    (lambda
                        (idx:integer)
                        (AOZ|A_AddPrimalMetaFungible (at idx mf-ids))
                    )
                    (enumerate 0 5)
                )
                mf-ids
            )
        )
    )
    (defun AOZ|A_MakeATSPairs:[string] (patron:string)
        @doc "Creates all required ATS-Pairs and adds their ids to the AOZ|Assets"
        (with-capability (AOZ-ADMIN)
            (let*
                (
                    (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
                    (EsothericKosonID:string (AOZ|UR_Assets 1 1))
                    (AncientKosonID:string (AOZ|UR_Assets 1 2))

                    (PlebiumDenariusID:string (AOZ|UR_Assets 1 3))
                    (ComatusAureusID:string (AOZ|UR_Assets 1 4))
                    (PileatusSolidusID:string (AOZ|UR_Assets 1 5))
                    (TarabostesStaterID:string (AOZ|UR_Assets 1 6))
                    (StrategonDrachmaID:string (AOZ|UR_Assets 1 7))
                    (BasileonAsID:string (AOZ|UR_Assets 1 8))

                    (DenariusDebilisID:string (AOZ|UR_Assets 2 0))
                    (AureusFragilisID:string (AOZ|UR_Assets 2 1))
                    (SolidusFractusID:string (AOZ|UR_Assets 2 2))
                    (StaterTenuulusID:string (AOZ|UR_Assets 2 3))
                    (DrachmaMinimaID:string (AOZ|UR_Assets 2 4))
                    (AsInfinimusID:string (AOZ|UR_Assets 2 5))

                    (PlebeicStrengthID:string
                        (TALOS|ATS1.C_Issue
                            patron
                            AOZ|SC_NAME
                            "PlebeicStrength"
                            24
                            PrimordialKosonID
                            false
                            PlebiumDenariusID
                            true
                        )
                    )
                    (ComatiCommandID:string
                        (TALOS|ATS1.C_Issue
                            patron
                            AOZ|SC_NAME
                            "ComatiCommand"
                            24
                            PrimordialKosonID
                            false
                            ComatusAureusID
                            true
                        )
                    )
                    (PileatiPowerID:string
                        (TALOS|ATS1.C_Issue
                            patron
                            AOZ|SC_NAME
                            "PileatiPower"
                            24
                            PrimordialKosonID
                            false
                            PileatusSolidusID
                            true
                        )
                    )
                    (TarabostesTenacityID:string
                        (TALOS|ATS1.C_Issue
                            patron
                            AOZ|SC_NAME
                            "TarabostesTenacity"
                            24
                            PrimordialKosonID
                            false
                            TarabostesStaterID
                            true
                        )
                    )
                    (StrategonVigorID:string
                        (TALOS|ATS1.C_Issue
                            patron
                            AOZ|SC_NAME
                            "StrategonVigor"
                            24
                            PrimordialKosonID
                            false
                            StrategonDrachmaID
                            true
                        )
                    )
                    (AsAuthorityID:string
                        (TALOS|ATS1.C_Issue
                            patron
                            AOZ|SC_NAME
                            "AsAuthority"
                            24
                            PrimordialKosonID
                            false
                            BasileonAsID
                            true
                        )
                    )
                    (atspairs:[string] [PlebeicStrengthID ComatiCommandID PileatiPowerID TarabostesTenacityID StrategonVigorID AsAuthorityID])
                )
                (map
                    (lambda
                        (idx:integer)
                        (AOZ|A_AddATSPair (at idx atspairs))
                    )
                    (enumerate 0 (- (length atspairs) 1))
                )
                ;;Setup each Autostake Pool
                ;;Plebeic Strength
                (TALOS|ATS3.C_AddSecondary patron PlebeicStrengthID EsothericKosonID false)
                (TALOS|ATS3.C_AddSecondary patron PlebeicStrengthID AncientKosonID false)
                (TALOS|ATS3.C_AddHotRBT patron PlebeicStrengthID DenariusDebilisID)
                (TALOS|ATS3.C_TurnRecoveryOn patron PlebeicStrengthID false)
                (TALOS|ATS3.C_TurnRecoveryOn patron PlebeicStrengthID true) ;;must be removed as was used for testing
                ;;Comati Command
                (TALOS|ATS3.C_AddSecondary patron ComatiCommandID EsothericKosonID false)
                (TALOS|ATS3.C_AddSecondary patron ComatiCommandID AncientKosonID false)
                (TALOS|ATS3.C_AddHotRBT patron ComatiCommandID AureusFragilisID)
                (TALOS|ATS3.C_SetHotFee patron ComatiCommandID 900.0 90)
                (TALOS|ATS3.C_TurnRecoveryOn patron ComatiCommandID false)
                ;;Pileati Power
                (TALOS|ATS3.C_AddSecondary patron PileatiPowerID EsothericKosonID false)
                (TALOS|ATS3.C_AddSecondary patron PileatiPowerID AncientKosonID false)
                (TALOS|ATS3.C_AddHotRBT patron PileatiPowerID SolidusFractusID)
                (TALOS|ATS3.C_SetHotFee patron PileatiPowerID 900.0 180)
                (TALOS|ATS3.C_TurnRecoveryOn patron PileatiPowerID false)
                ;;Tarabostes Tenacity
                (TALOS|ATS3.C_AddSecondary patron TarabostesTenacityID EsothericKosonID false)
                (TALOS|ATS3.C_AddSecondary patron TarabostesTenacityID AncientKosonID false)
                (TALOS|ATS3.C_AddHotRBT patron TarabostesTenacityID StaterTenuulusID)
                (TALOS|ATS3.C_SetHotFee patron TarabostesTenacityID 900.0 360)
                (TALOS|ATS3.C_TurnRecoveryOn patron TarabostesTenacityID false)
                ;;Strategon Vigor
                (TALOS|ATS3.C_AddSecondary patron StrategonVigorID EsothericKosonID false)
                (TALOS|ATS3.C_AddSecondary patron StrategonVigorID AncientKosonID false)
                (TALOS|ATS3.C_AddHotRBT patron StrategonVigorID DrachmaMinimaID)
                (TALOS|ATS3.C_SetHotFee patron StrategonVigorID 900.0 720)
                (TALOS|ATS3.C_TurnRecoveryOn patron StrategonVigorID false)
                ;;As Authority
                (TALOS|ATS3.C_AddSecondary patron AsAuthorityID EsothericKosonID false)
                (TALOS|ATS3.C_AddSecondary patron AsAuthorityID AncientKosonID false)
                (TALOS|ATS3.C_AddHotRBT patron AsAuthorityID AsInfinimusID)
                (TALOS|ATS3.C_SetHotFee patron AsAuthorityID 900.0 1440)
                (TALOS|ATS3.C_TurnRecoveryOn patron AsAuthorityID false)

                ;;Genesis Mint and Stake to kickstart staking Pools
                (TALOS|DPTF.C_Mint
                    patron
                    PrimordialKosonID
                    patron
                    10000.0
                    true
                )
                (TALOS|DPTF.C_Mint
                    patron
                    EsothericKosonID
                    patron
                    5000.0
                    true
                )
                (TALOS|DPTF.C_Mint
                    patron
                    AncientKosonID
                    patron
                    5000.0
                    true
                )
                ;;Stake 150 75 75 PKOSON, EKOSON, AKOSON in each ATS Pool to kickstart the pools.
                (TALOS|ATS3.C_Coil patron patron PlebeicStrengthID PrimordialKosonID 150.0)
                (TALOS|ATS3.C_Coil patron patron PlebeicStrengthID EsothericKosonID 75.0)
                (TALOS|ATS3.C_Coil patron patron PlebeicStrengthID AncientKosonID 75.0)

                (TALOS|ATS3.C_Coil patron patron ComatiCommandID PrimordialKosonID 150.0)
                (TALOS|ATS3.C_Coil patron patron ComatiCommandID EsothericKosonID 75.0)
                (TALOS|ATS3.C_Coil patron patron ComatiCommandID AncientKosonID 75.0)

                (TALOS|ATS3.C_Coil patron patron PileatiPowerID PrimordialKosonID 150.0)
                (TALOS|ATS3.C_Coil patron patron PileatiPowerID EsothericKosonID 75.0)
                (TALOS|ATS3.C_Coil patron patron PileatiPowerID AncientKosonID 75.0)

                (TALOS|ATS3.C_Coil patron patron TarabostesTenacityID PrimordialKosonID 150.0)
                (TALOS|ATS3.C_Coil patron patron TarabostesTenacityID EsothericKosonID 75.0)
                (TALOS|ATS3.C_Coil patron patron TarabostesTenacityID AncientKosonID 75.0)

                (TALOS|ATS3.C_Coil patron patron StrategonVigorID PrimordialKosonID 150.0)
                (TALOS|ATS3.C_Coil patron patron StrategonVigorID EsothericKosonID 75.0)
                (TALOS|ATS3.C_Coil patron patron StrategonVigorID AncientKosonID 75.0)

                (TALOS|ATS3.C_Coil patron patron AsAuthorityID PrimordialKosonID 150.0)
                (TALOS|ATS3.C_Coil patron patron AsAuthorityID EsothericKosonID 75.0)
                (TALOS|ATS3.C_Coil patron patron AsAuthorityID AncientKosonID 75.0)
                atspairs
            )
        )
    )
    ;;     (NONE) Client Usage FUNCTIONS                [C]
    ;;     (NONE) Auxiliary Usage Functions             [X]
    ;;=========================================================================;;
)

(create-table AOZ|Assets)