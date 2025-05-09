(module AGEOFZALMOXIS GOVERNANCE

    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
            \ Remove Comment below so that only ADMIN (<free.DH_Master-Keyset>) can enact an upgrade"
        true
        ;;(compose-capability (DEMIURGOI))
    )

    (defcap AOZ ()
        @doc "Capability enforcing the OUROBOROS Administrator"
        (enforce-one
            "Keyset not valid for Ouroboros Smart DALOS Account Operations"
            [
                (enforce-guard (keyset-ref-guard OUROBOROS.DALOS|DEMIURGOI))
                (enforce-guard (keyset-ref-guard AOZ|SC_KEY))
            ]
        )
        ;(compose-capability (OUROBOROS.DALOS|INCREASE-NONCE))
    )

;;  1]CONSTANTS Definitions
    ;;1.1]Account and KEYs IDs
    ;;[T] Ouroboros Account ids for DPTF Submodule
    (defconst AOZ|SC_KEY "free.User000i-Keyset")
    (defconst AOZ|SC_NAME "AgeOfZalmoxis")
    (defconst AOZ|SC_KDA-NAME "k:95a59029029524ebb250b2fafe6826ff88bb59c527d661cba3279d09a51d3bdf")
    (defconst AOZ|INFO "AOZ-Table-Key")
    (defschema AOZ|PropertiesSchema
        primal-tf-ids:[string]
        primal-mf-ids:[string]
        atspair-ids:[string]
        tf-game-assets:[string]
        mf-game-assets:[string]
        sf-game-assets:[string]
        nf-game-assets:[string]
    )
    (deftable AOZ|Assets:{AOZ|PropertiesSchema})
    ;;Utility Functions
    (defun AOZ|UR_Assets:string (asset-row:integer position:integer)
        (UTILITY.DALOS|UV_PositionalVariable asset-row 7 "Asset-Row Input out of Bounds")
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
    ;;Administrator Functions
    (defun AOZ|A_InitialiseAssets ()
        @doc "Initialises the AOZ Assets Table"
        (with-capability (AOZ)
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
        (OUROBOROS.DPTF-DPMF|UVE_id tf true)
        (require-capability (AOZ))
        (with-read AOZ|Assets AOZ|INFO
            { "primal-tf-ids" := pti }
            (update AOZ|Assets AOZ|INFO
                { "primal-tf-ids" : 
                    (if (= pti [""])
                        [tf]
                        (UTILITY.UC_AppendLast pti tf)
                    )
                }
            )
        )
    )
    (defun AOZ|A_AddPrimalMetaFungible (mf:string)
        (OUROBOROS.DPTF-DPMF|UVE_id mf false)
        (require-capability (AOZ))
        (with-read AOZ|Assets AOZ|INFO
            { "primal-mf-ids" := pmi }
            (update AOZ|Assets AOZ|INFO
                { "primal-mf-ids" : 
                    (if (= pmi [""])
                        [mf]
                        (UTILITY.UC_AppendLast pmi mf)
                    )
                }
            )
        )
    )
    (defun AOZ|A_AddATSPair (atspair:string)
        (OUROBOROS.ATS|UVE_id atspair)
        (require-capability (AOZ))
        (with-read AOZ|Assets AOZ|INFO
            { "atspair-ids" := ats }
            (update AOZ|Assets AOZ|INFO
                { "atspair-ids" : 
                    (if (= ats [""])
                        [atspair]
                        (UTILITY.UC_AppendLast ats atspair)
                    )
                }
            )
        )
    )
    (defun AOZ|A_AddTrueFungibleGameAsset (tf:string)
        (OUROBOROS.DPTF-DPMF|UVE_id tf true)
        (require-capability (AOZ))
        (with-read AOZ|Assets AOZ|INFO
            { "tf-game-assets" := tga }
            (update AOZ|Assets AOZ|INFO
                { "tf-game-assets" : 
                    (if (= tga [""])
                        [tf]
                        (UTILITY.UC_AppendLast tga tf)
                    )
                }
            )
        )
    )
    (defun AOZ|A_AddMetaFungibleGameAsset (mf:string)
        (OUROBOROS.DPTF-DPMF|UVE_id mf false)
        (require-capability (AOZ))
        (with-read AOZ|Assets AOZ|INFO
            { "mf-game-assets" := mga }
            (update AOZ|Assets AOZ|INFO
                { "mf-game-assets" : 
                    (if (= mga [""])
                        [mf]
                        (UTILITY.UC_AppendLast mga mf)
                    )
                }
            )
        )
    )
    (defun AOZ|A_IssueTrueFungibles:[string] (patron:string)
        @doc "Mints all DPTF Tokens needed for AOZ and adds their ids to the AOZ|Assets"
        (with-capability (AOZ)
            (let*
                (
                    (tf-ids:[string]
                        (OUROBOROS.DPTF|CM_Issue
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
            (OUROBOROS.DPTF|C_SetFee patron PlebiumDenariusID 10.0)
            (OUROBOROS.DPTF|C_ToggleFee patron PlebiumDenariusID true)
            (OUROBOROS.DPTF|C_ToggleFeeLock patron PlebiumDenariusID true)

            (OUROBOROS.DPTF|C_SetFee patron ComatusAureusID 20.0)
            (OUROBOROS.DPTF|C_ToggleFee patron ComatusAureusID true)
            (OUROBOROS.DPTF|C_ToggleFeeLock patron ComatusAureusID true)

            (OUROBOROS.DPTF|C_SetFee patron PileatusSolidusID 30.0)
            (OUROBOROS.DPTF|C_ToggleFee patron PileatusSolidusID true)
            (OUROBOROS.DPTF|C_ToggleFeeLock patron PileatusSolidusID true)

            (OUROBOROS.DPTF|C_SetFee patron TarabostesStaterID 40.0)
            (OUROBOROS.DPTF|C_ToggleFee patron TarabostesStaterID true)
            (OUROBOROS.DPTF|C_ToggleFeeLock patron TarabostesStaterID true)

            (OUROBOROS.DPTF|C_SetFee patron StrategonDrachmaID 50.0)
            (OUROBOROS.DPTF|C_ToggleFee patron StrategonDrachmaID true)
            (OUROBOROS.DPTF|C_ToggleFeeLock patron StrategonDrachmaID true)

            (OUROBOROS.DPTF|C_SetFee patron BasileonAsID 60.0)
            (OUROBOROS.DPTF|C_ToggleFee patron BasileonAsID true)
            (OUROBOROS.DPTF|C_ToggleFeeLock patron BasileonAsID true)
        )
    )
    (defun AOZ|A_IssueMetaFungibles:[string] (patron:string)
        @doc "Mints all DPMF Tokens needed for AOZ and adds their ids to the AOZ|Assets"
        (with-capability (AOZ)
            (let
                (
                    (mf-ids:[string]
                        (OUROBOROS.DPMF|CM_Issue
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
        (with-capability (AOZ)
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
                        (OUROBOROS.ATS|C_Issue
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
                        (OUROBOROS.ATS|C_Issue
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
                        (OUROBOROS.ATS|C_Issue
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
                        (OUROBOROS.ATS|C_Issue
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
                        (OUROBOROS.ATS|C_Issue
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
                        (OUROBOROS.ATS|C_Issue
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
                (OUROBOROS.ATS|C_AddSecondary patron PlebeicStrengthID EsothericKosonID false)
                (OUROBOROS.ATS|C_AddSecondary patron PlebeicStrengthID AncientKosonID false)
                (OUROBOROS.ATS|C_AddHotRBT patron PlebeicStrengthID DenariusDebilisID)
                (OUROBOROS.ATS|C_TurnRecoveryOn patron PlebeicStrengthID false)
                (OUROBOROS.ATS|C_TurnRecoveryOn patron PlebeicStrengthID true) ;;must be removed
                ;;Comati Command
                (OUROBOROS.ATS|C_AddSecondary patron ComatiCommandID EsothericKosonID false)
                (OUROBOROS.ATS|C_AddSecondary patron ComatiCommandID AncientKosonID false)
                (OUROBOROS.ATS|C_AddHotRBT patron ComatiCommandID AureusFragilisID)
                (OUROBOROS.ATS|C_SetHotFee patron ComatiCommandID 900.0 90)
                (OUROBOROS.ATS|C_TurnRecoveryOn patron ComatiCommandID false)
                ;;Pileati Power
                (OUROBOROS.ATS|C_AddSecondary patron PileatiPowerID EsothericKosonID false)
                (OUROBOROS.ATS|C_AddSecondary patron PileatiPowerID AncientKosonID false)
                (OUROBOROS.ATS|C_AddHotRBT patron PileatiPowerID SolidusFractusID)
                (OUROBOROS.ATS|C_SetHotFee patron PileatiPowerID 900.0 180)
                (OUROBOROS.ATS|C_TurnRecoveryOn patron PileatiPowerID false)
                ;;Tarabostes Tenacity
                (OUROBOROS.ATS|C_AddSecondary patron TarabostesTenacityID EsothericKosonID false)
                (OUROBOROS.ATS|C_AddSecondary patron TarabostesTenacityID AncientKosonID false)
                (OUROBOROS.ATS|C_AddHotRBT patron TarabostesTenacityID StaterTenuulusID)
                (OUROBOROS.ATS|C_SetHotFee patron TarabostesTenacityID 900.0 360)
                (OUROBOROS.ATS|C_TurnRecoveryOn patron TarabostesTenacityID false)
                ;;Strategon Vigor
                (OUROBOROS.ATS|C_AddSecondary patron StrategonVigorID EsothericKosonID false)
                (OUROBOROS.ATS|C_AddSecondary patron StrategonVigorID AncientKosonID false)
                (OUROBOROS.ATS|C_AddHotRBT patron StrategonVigorID DrachmaMinimaID)
                (OUROBOROS.ATS|C_SetHotFee patron StrategonVigorID 900.0 720)
                (OUROBOROS.ATS|C_TurnRecoveryOn patron StrategonVigorID false)
                ;;As Authority
                (OUROBOROS.ATS|C_AddSecondary patron AsAuthorityID EsothericKosonID false)
                (OUROBOROS.ATS|C_AddSecondary patron AsAuthorityID AncientKosonID false)
                (OUROBOROS.ATS|C_AddHotRBT patron AsAuthorityID AsInfinimusID)
                (OUROBOROS.ATS|C_SetHotFee patron AsAuthorityID 900.0 1440)
                (OUROBOROS.ATS|C_TurnRecoveryOn patron AsAuthorityID false)

                ;;Genesis Mint and Stake to kickstart staking Pools
                (OUROBOROS.DPTF|C_Mint
                    patron
                    PrimordialKosonID
                    patron
                    10000.0
                    true
                )
                (OUROBOROS.DPTF|C_Mint
                    patron
                    EsothericKosonID
                    patron
                    5000.0
                    true
                )
                (OUROBOROS.DPTF|C_Mint
                    patron
                    AncientKosonID
                    patron
                    5000.0
                    true
                )
                ;;Stake 150 75 75 PKOSON, EKOSON, AKOSON in each ATS Pool to kickstart the pools.
                (OUROBOROS.ATS|C_Coil patron patron PlebeicStrengthID PrimordialKosonID 150.0)
                (OUROBOROS.ATS|C_Coil patron patron PlebeicStrengthID EsothericKosonID 75.0)
                (OUROBOROS.ATS|C_Coil patron patron PlebeicStrengthID AncientKosonID 75.0)

                (OUROBOROS.ATS|C_Coil patron patron ComatiCommandID PrimordialKosonID 150.0)
                (OUROBOROS.ATS|C_Coil patron patron ComatiCommandID EsothericKosonID 75.0)
                (OUROBOROS.ATS|C_Coil patron patron ComatiCommandID AncientKosonID 75.0)

                (OUROBOROS.ATS|C_Coil patron patron PileatiPowerID PrimordialKosonID 150.0)
                (OUROBOROS.ATS|C_Coil patron patron PileatiPowerID EsothericKosonID 75.0)
                (OUROBOROS.ATS|C_Coil patron patron PileatiPowerID AncientKosonID 75.0)

                (OUROBOROS.ATS|C_Coil patron patron TarabostesTenacityID PrimordialKosonID 150.0)
                (OUROBOROS.ATS|C_Coil patron patron TarabostesTenacityID EsothericKosonID 75.0)
                (OUROBOROS.ATS|C_Coil patron patron TarabostesTenacityID AncientKosonID 75.0)

                (OUROBOROS.ATS|C_Coil patron patron StrategonVigorID PrimordialKosonID 150.0)
                (OUROBOROS.ATS|C_Coil patron patron StrategonVigorID EsothericKosonID 75.0)
                (OUROBOROS.ATS|C_Coil patron patron StrategonVigorID AncientKosonID 75.0)

                (OUROBOROS.ATS|C_Coil patron patron AsAuthorityID PrimordialKosonID 150.0)
                (OUROBOROS.ATS|C_Coil patron patron AsAuthorityID EsothericKosonID 75.0)
                (OUROBOROS.ATS|C_Coil patron patron AsAuthorityID AncientKosonID 75.0)
                atspairs
            )
        )
    )

)

(create-table AOZ|Assets)