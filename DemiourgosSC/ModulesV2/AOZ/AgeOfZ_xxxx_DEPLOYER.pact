
;(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")
(module AOZ GOVERNANCE

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
    (defcap ADD_ASSET ()
        true
    )
    ;;Module Guard
    (defconst G-MD_AOZ   (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_AOZ   (keyset-ref-guard AOZ|SC_KEY))

    (defconst AOZ|SC_KEY
        (+ UTILS.NS_USE ".us-0000_aozt-keyset")
    )

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
    ;;            FUNCTIONS
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
    (defun AOZ|A_AddPrimalTrueFungible (tf:string)
        (BASIS.DPTF-DPMF|UEV_id tf true)
        (require-capability (ADD_ASSET))
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
        (require-capability (ADD_ASSET))
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
        (require-capability (ADD_ASSET))
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
        (require-capability (ADD_ASSET))
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
        (require-capability (ADD_ASSET))
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
    (defun AOZ|A_AddSemiFungibleGameAsset (sf:string)
        (require-capability (ADD_ASSET))
        (with-read AOZ|Assets AOZ|INFO
            { "sf-game-assets" := sga }
            (update AOZ|Assets AOZ|INFO
                { "sf-game-assets" : 
                    (if (= sga [""])
                        [sf]
                        (UTILS.LIST|UC_AppendLast sga sf)
                    )
                }
            )
        )
    )
    (defun AOZ|A_AddNonFungibleGameAsset (nf:string)
        (require-capability (ADD_ASSET))
        (with-read AOZ|Assets AOZ|INFO
            { "nf-game-assets" := nga }
            (update AOZ|Assets AOZ|INFO
                { "nf-game-assets" : 
                    (if (= nga [""])
                        [nf]
                        (UTILS.LIST|UC_AppendLast nga nf)
                    )
                }
            )
        )
    )
    ;;========[D] Deploy FUNCTIONS===============================================;;
    ;;            Administrative Usage Functions        [A]
    (defun A_Step027 ()
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
    (defun A_Step028:[string] ()
        (let*
            (
                (patron:string AOZ|SC_NAME)
                (tf-ids:[string]
                    (TALOS-01.DPTF|C_Issue
                        patron
                        patron
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
            (with-capability (ADD_ASSET)
                (map
                    (lambda
                        (idx:integer)
                        (AOZ|A_AddPrimalTrueFungible (at idx tf-ids))
                    )
                    (enumerate 0 8)
                )
            )
            tf-ids
        )
    )
    (defun A_Step029 ()
        (let
            (
                (patron:string AOZ|SC_NAME)
                (PlebiumDenariusID:string (AOZ|UR_Assets 1 3))
                (ComatusAureusID:string (AOZ|UR_Assets 1 4))
                (PileatusSolidusID:string (AOZ|UR_Assets 1 5))
                (TarabostesStaterID:string (AOZ|UR_Assets 1 6))
                (StrategonDrachmaID:string (AOZ|UR_Assets 1 7))
                (BasileonAsID:string (AOZ|UR_Assets 1 8))
            )
            ;;Set Transaction Fees for Minor Solid Kosonic Currencies
            (BASIS.DPTF|C_SetFee patron PlebiumDenariusID 10.0)
            (BASIS.DPTF|C_ToggleFee patron PlebiumDenariusID true)
            (TALOS-01.DPTF|C_ToggleFeeLock patron PlebiumDenariusID true)

            (BASIS.DPTF|C_SetFee patron ComatusAureusID 20.0)
            (BASIS.DPTF|C_ToggleFee patron ComatusAureusID true)
            (TALOS-01.DPTF|C_ToggleFeeLock patron ComatusAureusID true)

            (BASIS.DPTF|C_SetFee patron PileatusSolidusID 30.0)
            (BASIS.DPTF|C_ToggleFee patron PileatusSolidusID true)
            (TALOS-01.DPTF|C_ToggleFeeLock patron PileatusSolidusID true)

            (BASIS.DPTF|C_SetFee patron TarabostesStaterID 40.0)
            (BASIS.DPTF|C_ToggleFee patron TarabostesStaterID true)
            (TALOS-01.DPTF|C_ToggleFeeLock patron TarabostesStaterID true)

            (BASIS.DPTF|C_SetFee patron StrategonDrachmaID 50.0)
            (BASIS.DPTF|C_ToggleFee patron StrategonDrachmaID true)
            (TALOS-01.DPTF|C_ToggleFeeLock patron StrategonDrachmaID true)

            (BASIS.DPTF|C_SetFee patron BasileonAsID 60.0)
            (BASIS.DPTF|C_ToggleFee patron BasileonAsID true)
            (TALOS-01.DPTF|C_ToggleFeeLock patron BasileonAsID true)
        )
    )
    (defun A_Step030:[string] ()
        (let*
            (
                (patron:string AOZ|SC_NAME)
                (mf-ids:[string]
                    (TALOS-01.DPMF|C_Issue
                        patron
                        patron
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
            (with-capability (ADD_ASSET)
                (map
                    (lambda
                        (idx:integer)
                        (AOZ|A_AddPrimalMetaFungible (at idx mf-ids))
                    )
                    (enumerate 0 5)
                )
            )
            mf-ids
        )
    )
    (defun A_Step031:[string] ()
        (let*
            (
                (patron:string AOZ|SC_NAME)
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

                (ats-ids:[string]
                    (TALOS-01.ATS|C_Issue
                        patron
                        patron
                        ["PlebeicStrength" "ComatiCommand" "PileatiPower" "TarabostesTenacity" "StrategonVigor" "AsAuthority"]
                        [24 24 24 24 24 24]
                        [PrimordialKosonID PrimordialKosonID PrimordialKosonID PrimordialKosonID PrimordialKosonID PrimordialKosonID]
                        [false false false false false false]
                        [PlebiumDenariusID ComatusAureusID PileatusSolidusID TarabostesStaterID StrategonDrachmaID BasileonAsID]
                        [true true true true true true]
                    )    
                )
            )
            (with-capability (ADD_ASSET)
                (map
                    (lambda
                        (idx:integer)
                        (AOZ|A_AddATSPair (at idx ats-ids))
                    )
                    (enumerate 0 (- (length ats-ids) 1))
                )
            )
            ats-ids
        )
    )
    (defun A_Step032 ()
        (let
            (
                (patron:string AOZ|SC_NAME)
                (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
                (EsothericKosonID:string (AOZ|UR_Assets 1 1))
                (AncientKosonID:string (AOZ|UR_Assets 1 2))

                (PlebiumDenariusID:string (AOZ|UR_Assets 1 3))
                (ComatusAureusID:string (AOZ|UR_Assets 1 4))
                (PileatusSolidusID:string (AOZ|UR_Assets 1 5))

                (DenariusDebilisID:string (AOZ|UR_Assets 2 0))
                (AureusFragilisID:string (AOZ|UR_Assets 2 1))
                (SolidusFractusID:string (AOZ|UR_Assets 2 2))

                (PlebeicStrengthID:string (AOZ|UR_Assets 3 0))
                (ComatiCommandID:string (AOZ|UR_Assets 3 1))
                (PileatiPowerID:string (AOZ|UR_Assets 3 2))
            )
            ;;Plebeic Strength
            (ATSM.ATSM|C_AddSecondary patron PlebeicStrengthID EsothericKosonID false)
            (ATSM.ATSM|C_AddSecondary patron PlebeicStrengthID AncientKosonID false)
            (ATSM.ATSM|C_AddHotRBT patron PlebeicStrengthID DenariusDebilisID)
            (ATSM.ATSM|C_TurnRecoveryOn patron PlebeicStrengthID false)
            (ATSM.ATSM|C_TurnRecoveryOn patron PlebeicStrengthID true) ;;When deploying on mainnet must be removed
            ;;Comati Command
            (ATSM.ATSM|C_AddSecondary patron ComatiCommandID EsothericKosonID false)
            (ATSM.ATSM|C_AddSecondary patron ComatiCommandID AncientKosonID false)
            (ATSM.ATSM|C_AddHotRBT patron ComatiCommandID AureusFragilisID)
            (ATSM.ATSM|C_SetHotFee patron ComatiCommandID 900.0 90)
            (ATSM.ATSM|C_TurnRecoveryOn patron ComatiCommandID false)
            ;;Pileati Power
            (ATSM.ATSM|C_AddSecondary patron PileatiPowerID EsothericKosonID false)
            (ATSM.ATSM|C_AddSecondary patron PileatiPowerID AncientKosonID false)
            (ATSM.ATSM|C_AddHotRBT patron PileatiPowerID SolidusFractusID)
            (ATSM.ATSM|C_SetHotFee patron PileatiPowerID 900.0 180)
            (ATSM.ATSM|C_TurnRecoveryOn patron PileatiPowerID false)
        )
    )
    (defun A_Step033 ()
        (let
            (
                (patron:string AOZ|SC_NAME)
                (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
                (EsothericKosonID:string (AOZ|UR_Assets 1 1))
                (AncientKosonID:string (AOZ|UR_Assets 1 2))

                (TarabostesStaterID:string (AOZ|UR_Assets 1 6))
                (StrategonDrachmaID:string (AOZ|UR_Assets 1 7))
                (BasileonAsID:string (AOZ|UR_Assets 1 8))

                (StaterTenuulusID:string (AOZ|UR_Assets 2 3))
                (DrachmaMinimaID:string (AOZ|UR_Assets 2 4))
                (AsInfinimusID:string (AOZ|UR_Assets 2 5))

                (TarabostesTenacityID:string (AOZ|UR_Assets 3 3))
                (StrategonVigorID:string (AOZ|UR_Assets 3 4))
                (AsAuthorityID:string (AOZ|UR_Assets 3 5))
            )
            ;;Tarabostes Tenacity
            (ATSM.ATSM|C_AddSecondary patron TarabostesTenacityID EsothericKosonID false)
            (ATSM.ATSM|C_AddSecondary patron TarabostesTenacityID AncientKosonID false)
            (ATSM.ATSM|C_AddHotRBT patron TarabostesTenacityID StaterTenuulusID)
            (ATSM.ATSM|C_SetHotFee patron TarabostesTenacityID 900.0 360)
            (ATSM.ATSM|C_TurnRecoveryOn patron TarabostesTenacityID false)
            ;;Strategon Vigor
            (ATSM.ATSM|C_AddSecondary patron StrategonVigorID EsothericKosonID false)
            (ATSM.ATSM|C_AddSecondary patron StrategonVigorID AncientKosonID false)
            (ATSM.ATSM|C_AddHotRBT patron StrategonVigorID DrachmaMinimaID)
            (ATSM.ATSM|C_SetHotFee patron StrategonVigorID 900.0 720)
            (ATSM.ATSM|C_TurnRecoveryOn patron StrategonVigorID false)
            ;;As Authority
            (ATSM.ATSM|C_AddSecondary patron AsAuthorityID EsothericKosonID false)
            (ATSM.ATSM|C_AddSecondary patron AsAuthorityID AncientKosonID false)
            (ATSM.ATSM|C_AddHotRBT patron AsAuthorityID AsInfinimusID)
            (ATSM.ATSM|C_SetHotFee patron AsAuthorityID 900.0 1440)
            (ATSM.ATSM|C_TurnRecoveryOn patron AsAuthorityID false)
        )
    )
    (defun A_Step034 ()
        (let
            (
                (patron:string AOZ|SC_NAME)
                (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
                (EsothericKosonID:string (AOZ|UR_Assets 1 1))
                (AncientKosonID:string (AOZ|UR_Assets 1 2))
            )
            (BASIS.DPTF|C_Mint
                patron
                PrimordialKosonID
                patron
                10000.0
                true
            )
            (BASIS.DPTF|C_Mint
                patron
                EsothericKosonID
                patron
                10000.0
                true
            )
            (BASIS.DPTF|C_Mint
                patron
                AncientKosonID
                patron
                10000.0
                true
            )
        )
    )
    (defun A_Step035 ()
        (let
            (
                (patron:string AOZ|SC_NAME)
                (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
                (EsothericKosonID:string (AOZ|UR_Assets 1 1))
                (AncientKosonID:string (AOZ|UR_Assets 1 2))

                (PlebeicStrengthID:string (AOZ|UR_Assets 3 0))
                (am:decimal 250.0)
            )
            ;;Stake 250 250 250 PKOSON, EKOSON, AKOSON in PlebeicStrength to kickstart it.
            (ATSM.ATSM|C_Coil patron patron PlebeicStrengthID PrimordialKosonID am)
            (ATSM.ATSM|C_Coil patron patron PlebeicStrengthID EsothericKosonID am)
            (ATSM.ATSM|C_Coil patron patron PlebeicStrengthID AncientKosonID am)
        ) 
    )
    (defun A_Step036 ()
        (let
            (
                (patron:string AOZ|SC_NAME)
                (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
                (EsothericKosonID:string (AOZ|UR_Assets 1 1))
                (AncientKosonID:string (AOZ|UR_Assets 1 2))

                (ComatiCommandID:string (AOZ|UR_Assets 3 1))
                (am:decimal 250.0)
            )
            ;;Stake 250 250 250 PKOSON, EKOSON, AKOSON in ComatiCommand to kickstart it.
            (ATSM.ATSM|C_Coil patron patron ComatiCommandID PrimordialKosonID am)
            (ATSM.ATSM|C_Coil patron patron ComatiCommandID EsothericKosonID am)
            (ATSM.ATSM|C_Coil patron patron ComatiCommandID AncientKosonID am)
        ) 
    )
    (defun A_Step037 ()
        (let
            (
                (patron:string AOZ|SC_NAME)
                (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
                (EsothericKosonID:string (AOZ|UR_Assets 1 1))
                (AncientKosonID:string (AOZ|UR_Assets 1 2))

                (PileatiPowerID:string (AOZ|UR_Assets 3 2))
                (am:decimal 250.0)
            )
            ;;Stake 250 250 250 PKOSON, EKOSON, AKOSON in PileatiPower to kickstart it.
            (ATSM.ATSM|C_Coil patron patron PileatiPowerID PrimordialKosonID am)
            (ATSM.ATSM|C_Coil patron patron PileatiPowerID EsothericKosonID am)
            (ATSM.ATSM|C_Coil patron patron PileatiPowerID AncientKosonID am)
        ) 
    )
    (defun A_Step038 ()
        (let
            (
                (patron:string AOZ|SC_NAME)
                (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
                (EsothericKosonID:string (AOZ|UR_Assets 1 1))
                (AncientKosonID:string (AOZ|UR_Assets 1 2))

                (TarabostesTenacityID:string (AOZ|UR_Assets 3 3))
                (am:decimal 250.0)
            )
            ;;Stake 250 250 250 PKOSON, EKOSON, AKOSON in TarabostesTenacity to kickstart it.
            (ATSM.ATSM|C_Coil patron patron TarabostesTenacityID PrimordialKosonID am)
            (ATSM.ATSM|C_Coil patron patron TarabostesTenacityID EsothericKosonID am)
            (ATSM.ATSM|C_Coil patron patron TarabostesTenacityID AncientKosonID am)
        ) 
    )
    (defun A_Step039 ()
        (let
            (
                (patron:string AOZ|SC_NAME)
                (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
                (EsothericKosonID:string (AOZ|UR_Assets 1 1))
                (AncientKosonID:string (AOZ|UR_Assets 1 2))

                (StrategonVigorID:string (AOZ|UR_Assets 3 4))
                (am:decimal 250.0)
            )
            ;;Stake 250 250 250 PKOSON, EKOSON, AKOSON in StrategonVigor to kickstart it.
            (ATSM.ATSM|C_Coil patron patron StrategonVigorID PrimordialKosonID am)
            (ATSM.ATSM|C_Coil patron patron StrategonVigorID EsothericKosonID am)
            (ATSM.ATSM|C_Coil patron patron StrategonVigorID AncientKosonID am)
        ) 
    )
    (defun A_Step040 ()
        (let
            (
                (patron:string AOZ|SC_NAME)
                (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
                (EsothericKosonID:string (AOZ|UR_Assets 1 1))
                (AncientKosonID:string (AOZ|UR_Assets 1 2))

                (AsAuthorityID:string (AOZ|UR_Assets 3 5))
                (am:decimal 250.0)
            )
            ;;Stake 250 250 250 PKOSON, EKOSON, AKOSON in AsAuthority to kickstart it.
            (ATSM.ATSM|C_Coil patron patron AsAuthorityID PrimordialKosonID am)
            (ATSM.ATSM|C_Coil patron patron AsAuthorityID EsothericKosonID am)
            (ATSM.ATSM|C_Coil patron patron AsAuthorityID AncientKosonID am)
        ) 
    )

    (defun A_Step041 ()
        (let
            (
                (patron:string AOZ|SC_NAME)
                (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
            )
            (TALOS-01.VST|C_CreateVestingLink patron PrimordialKosonID)
        )
    )
)

(create-table AOZ|Assets)