(interface DeployerAoz
    @doc "Exposes AOZ Deployer Functions"
    ;;
    (defun UR_Assets:string (ar:integer p:integer))

    (defun A_AddPrimalTrueFungible (tf:string))
    (defun A_AddPrimalMetaFungible (mf:string))
    (defun A_AddATSPair (atspair:string))
    (defun A_AddTrueFungibleGameAsset (tf:string))
    (defun A_AddMetaFungibleGameAsset (mf:string))
    (defun A_AddSemiFungibleGameAsset (sf:string))
    (defun A_AddNonFungibleGameAsset (nf:string))

    (defun A_Step001 ())
    (defun A_Step002:[string] ())
    (defun A_Step003 ())
    (defun A_Step004:[string] ())
    (defun A_Step005:[string] ())
    (defun A_Step006:[string] ())
    (defun A_Step007:[string] ())
    (defun A_Step008 ())
    (defun A_Step009 ())
    (defun A_Step010 ())
    (defun A_Step011 ())
    (defun A_Step012 ())
    (defun A_Step013 ())
    (defun A_Step014 ())
    (defun A_Step015 (amount:decimal))
    (defun A_Step016 (amount:decimal))
    (defun A_Step017 (amount:decimal))
    (defun A_Step018 (amount:decimal))
    (defun A_Step019 (amount:decimal))
    (defun A_Step020 (amount:decimal))

)
(module DPL-AOZ GOV
    ;;
    (implements DeployerAoz)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPL-AOZ                (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_DPL-AOZ                (keyset-ref-guard AOZ|SC_KEY))
    ;;
    (defconst AOZ|SC_KEY                    (+ (GOV|NS_Use) ".us-0000_aozt-keyset"))
    (defconst AOZ|SC_NAME                   "Ѻ.ÅτhGźνΣhςвiàÁĘĚДÏWÉΨTěCÃŒnæi9цéŘQí¢лΞÛIчмfÓeżÜýЯàDÖ5αȚÞVđσγ₱0ęЬÔĄsĄLлKùvåH£ΞMFУûÊyđÜqdŽŚЖsĘъsПÂÔØŹÞŮγŚΣЧ6Ïж¢чPyòлБ14ÚęŃĄåîêтηΛbΦđkûÇĂζsБúĎdŸUЛзÙÂÚJηXťćж¥zщòÁŸRĘ")
    (defconst AOZ|SC_KDA-NAME               "k:95a59029029524ebb250b2fafe6826ff88bb59c527d661cba3279d09a51d3bdf")
    (defconst AOZ|PBL                       "9G.29k17uqiwBF7mbc3rzr5gz228lxepz7a0fwrja2Bgzk1czjCLja3wg9q1ey10ftFhxIAiFBHCtvotkmKIIxFisMni8EA6esncL3lg2uLLH2u89Er9sgbeGmK0k7b63xujf1nAIf5GB583fcE6pzFak2CwhEi1dHzI0F14tvtxv4H8r1ABk5weoJ7HfCoadMm1h8MjIwjzbDKo80H25AJL8I1JiFF66Iwjcj3sFrD9xaqz1ziEEBJICF2k81pG9ABpDk2rK4ooglCK3kmC0h7yvvakjIvMpGp00jnw2Cpg1HoxjK0HoqzuKciIIczGsEzCjoB43x7lKsxkzAm7op2urv0I85Kon7uIBmg328cuKMc8driw8boAFnrdqHEFhx4sFjm8DM44FutCykKGx7GGLnoeJLaC707lot9tM51krmp6KDG8Ii318fIc1L5iuzqEwDnkro35JthzlDD1GkJaGgze3kDApAckn3uMcBypdz4LxbDGrg5K2GdiFBdFHqdpHyssrH8t694BkBtM9EB3yI3ojbnrbKrEM8fMaHAH2zl4x5gdkHnpjAeo8nz")
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPL_AOZ_ADMIN)))
    (defcap GOV|DPL_AOZ_ADMIN ()
        (enforce-one
            "AOZ Admin not satisfed"
            [
                (enforce-guard GOV|MD_DPL-AOZ)
                (enforce-guard GOV|SC_DPL-AOZ)
            ]
        )
    )
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    ;;{P3}
    ;;{P4}
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    (defschema AOZ|PropertiesSchema
        primal-tf-ids:[string]
        primal-mf-ids:[string]
        atspair-ids:[string]
        tf-game-assets:[string]
        mf-game-assets:[string]
        sf-game-assets:[string]
        nf-game-assets:[string]
    )
    ;;{2}
    (deftable AOZ|Assets:{AOZ|PropertiesSchema})
    ;;{3}
    (defconst AOZ|INFO "AOZ-Table-Key")
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_Fm (p:integer ar:integer)
        (format "Position {} out of bounds for Asset-Row {}" [p ar])
    )
    ;;{F0}  [UR]
    (defun UR_Assets:string (ar:integer p:integer)
        (let
            (
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
            )
            (ref-U|INT::UEV_PositionalVariable ar 7 "Asset-Row Input out of Bounds")
            (with-read AOZ|Assets AOZ|INFO
                { "primal-tf-ids"       := pti
                , "primal-mf-ids"       := pmi
                , "atspair-ids"         := ats
                ,"tf-game-assets"       := tf
                ,"mf-game-assets"       := mf
                ,"sf-game-assets"       := sf
                ,"nf-game-assets"       := nf
                }
                (cond
                    ((= ar 1) (UEV_AssetPossition ar p (length pti)))
                    ((= ar 2) (UEV_AssetPossition ar p (length pmi)))
                    ((= ar 3) (UEV_AssetPossition ar p (length ats)))
                    ((= ar 4) (UEV_AssetPossition ar p (length tf)))
                    ((= ar 5) (UEV_AssetPossition ar p (length mf)))
                    ((= ar 6) (UEV_AssetPossition ar p (length sf)))
                    ((= ar 7) (UEV_AssetPossition ar p (length nf)))
                    true
                )
                (cond
                    ((= ar 1) (at p pti))
                    ((= ar 2) (at p pmi))
                    ((= ar 3) (at p ats))
                    ((= ar 4) (at p tf))
                    ((= ar 5) (at p mf))
                    ((= ar 6) (at p sf))
                    ((= ar 7) (at p nf))
                    true
                )
            )
        )
    )
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_AssetPossition (a-row:integer a-pos:integer how-many-assets:integer)
        (enforce (= (contains a-pos (enumerate 0 (- how-many-assets 1))) true) (UC_Fm a-pos a-row))
    )
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun A_AddPrimalTrueFungible (tf:string)
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
            )
            (ref-DPTF::UEV_id tf)
            (with-read AOZ|Assets AOZ|INFO
                { "primal-tf-ids" := pti }
                (update AOZ|Assets AOZ|INFO
                    { "primal-tf-ids" :
                        (if (= pti [""])
                            [tf]
                            (ref-U|LST::UC_AppL pti tf)
                        )
                    }
                )
            )
        )
    )
    (defun A_AddPrimalMetaFungible (mf:string)
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
            )
            (ref-DPMF::UEV_id mf)
            (with-read AOZ|Assets AOZ|INFO
                { "primal-mf-ids" := pmi }
                (update AOZ|Assets AOZ|INFO
                    { "primal-mf-ids" :
                        (if (= pmi [""])
                            [mf]
                            (ref-U|LST::UC_AppL pmi mf)
                        )
                    }
                )
            )
        )
    )
    (defun A_AddATSPair (atspair:string)
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-ATS:module{AutostakeV4} ATS)
            )
            (ref-ATS::UEV_id atspair)
            (with-read AOZ|Assets AOZ|INFO
                { "atspair-ids" := ats }
                (update AOZ|Assets AOZ|INFO
                    { "atspair-ids" :
                        (if (= ats [""])
                            [atspair]
                            (ref-U|LST::UC_AppL ats atspair)
                        )
                    }
                )
            )
        )
    )
    (defun A_AddTrueFungibleGameAsset (tf:string)
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
            )
            (ref-DPTF::UEV_id tf)
            (with-read AOZ|Assets AOZ|INFO
                { "tf-game-assets" := tga }
                (update AOZ|Assets AOZ|INFO
                    { "tf-game-assets" :
                        (if (= tga [""])
                            [tf]
                            (ref-U|LST::UC_AppL tga tf)
                        )
                    }
                )
            )
        )
    )
    (defun A_AddMetaFungibleGameAsset (mf:string)
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
            )
            (ref-DPMF::UEV_id mf)
            (with-read AOZ|Assets AOZ|INFO
                { "mf-game-assets" := mga }
                (update AOZ|Assets AOZ|INFO
                    { "mf-game-assets" :
                        (if (= mga [""])
                            [mf]
                            (ref-U|LST::UC_AppL mga mf)
                        )
                    }
                )
            )
        )
    )
    (defun A_AddSemiFungibleGameAsset (sf:string)
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (with-read AOZ|Assets AOZ|INFO
                { "sf-game-assets" := sga }
                (update AOZ|Assets AOZ|INFO
                    { "sf-game-assets" :
                        (if (= sga [""])
                            [sf]
                            (ref-U|LST::UC_AppL sga sf)
                        )
                    }
                )
            )
        )
    )
    (defun A_AddNonFungibleGameAsset (nf:string)
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (with-read AOZ|Assets AOZ|INFO
                { "nf-game-assets" := nga }
                (update AOZ|Assets AOZ|INFO
                    { "nf-game-assets" :
                        (if (= nga [""])
                            [nf]
                            (ref-U|LST::UC_AppL nga nf)
                        )
                    }
                )
            )
        )
    )
    ;;  [DEPLOY]
    (defun A_Step001 ()
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
    (defun A_Step002:[string] ()
        (let
            (
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                (patron:string AOZ|SC_NAME)
                (tf-ids:[string]
                    (ref-TS01-C1::DPTF|C_Issue
                        patron
                        patron
                        ["PrimordialKoson" "EsothericKoson" "AncientKoson" "PlebiumDenarius" "ComatusAureus" "PileatusSolidus" "TarabostesStater" "StrategonDrachma" "BasileonAs"]
                        ["PKOSON" "EKOSON" "AKOSON" "PDKOSON" "CAKOSON" "PSKOSON" "TSKOSON" "SDKOSON" "BAKOSON"]
                        (make-list 9 24)                            ;;precision
                        (make-list 9 true)                          ;;can change owner
                        (make-list 9 true)                          ;;can upgrade
                        (make-list 9 true)                          ;;can can-add-special-role
                        (make-list 9 false)                         ;;can-freeze
                        (make-list 9 false)                         ;;can-wipe
                        (make-list 9 true)                          ;;can-pause
                    )
                )
            )
            (with-capability (SECURE)
                (map
                    (lambda
                        (idx:integer)
                        (A_AddPrimalTrueFungible (at idx tf-ids))
                    )
                    (enumerate 0 (- (length tf-ids) 1))
                )
            )
            tf-ids
        )
    )
    (defun A_Step003 ()
        (let
            (
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                (patron:string AOZ|SC_NAME)
                (PlebiumDenariusID:string (UR_Assets 1 3))
                (ComatusAureusID:string (UR_Assets 1 4))
                (PileatusSolidusID:string (UR_Assets 1 5))
                (TarabostesStaterID:string (UR_Assets 1 6))
                (StrategonDrachmaID:string (UR_Assets 1 7))
                (BasileonAsID:string (UR_Assets 1 8))
            )
            ;;Set Transaction Fees for Minor Solid Kosonic Currencies
            (ref-TS01-C1::DPTF|C_SetFee patron PlebiumDenariusID 10.0)
            (ref-TS01-C1::DPTF|C_ToggleFee patron PlebiumDenariusID true)
            (ref-TS01-C1::DPTF|C_ToggleFeeLock patron PlebiumDenariusID true)

            (ref-TS01-C1::DPTF|C_SetFee patron ComatusAureusID 20.0)
            (ref-TS01-C1::DPTF|C_ToggleFee patron ComatusAureusID true)
            (ref-TS01-C1::DPTF|C_ToggleFeeLock patron ComatusAureusID true)

            (ref-TS01-C1::DPTF|C_SetFee patron PileatusSolidusID 30.0)
            (ref-TS01-C1::DPTF|C_ToggleFee patron PileatusSolidusID true)
            (ref-TS01-C1::DPTF|C_ToggleFeeLock patron PileatusSolidusID true)

            (ref-TS01-C1::DPTF|C_SetFee patron TarabostesStaterID 40.0)
            (ref-TS01-C1::DPTF|C_ToggleFee patron TarabostesStaterID true)
            (ref-TS01-C1::DPTF|C_ToggleFeeLock patron TarabostesStaterID true)

            (ref-TS01-C1::DPTF|C_SetFee patron StrategonDrachmaID 50.0)
            (ref-TS01-C1::DPTF|C_ToggleFee patron StrategonDrachmaID true)
            (ref-TS01-C1::DPTF|C_ToggleFeeLock patron StrategonDrachmaID true)

            (ref-TS01-C1::DPTF|C_SetFee patron BasileonAsID 60.0)
            (ref-TS01-C1::DPTF|C_ToggleFee patron BasileonAsID true)
            (ref-TS01-C1::DPTF|C_ToggleFeeLock patron BasileonAsID true)
        )
    )
    (defun A_Step004:[string] ()
        (let*
            (
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                (patron:string AOZ|SC_NAME)
                (mf-ids:[string]
                    (ref-TS01-C1::DPMF|C_Issue
                        patron
                        patron
                        ["DenariusDebilis" "AureusFragilis" "SolidusFractus" "StaterTenuulus" "DrachmaMinima" "AsInfinimus"]
                        ["DDKOSON" "AFKOSON" "SFKOSON" "STKOSON" "DMKOSON" "AIKOSON"]
                        (make-list 6 24)                            ;;precision
                        (make-list 6 true)                          ;;can change owner
                        (make-list 6 true)                          ;;can upgrade
                        (make-list 6 true)                          ;;can can-add-special-role
                        (make-list 6 false)                         ;;can-freeze
                        (make-list 6 false)                         ;;can-wipe
                        (make-list 6 true)                          ;;can-pause
                        (make-list 6 true)                          ;;can-transfer-nft-create-role
                    )
                )
            )
            (with-capability (SECURE)
                (map
                    (lambda
                        (idx:integer)
                        (A_AddPrimalMetaFungible (at idx mf-ids))
                    )
                    (enumerate 0 5)
                )
            )
            mf-ids
        )
    )
    (defun A_Step005:[string] ()
        (let*
            (
                (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                (patron:string AOZ|SC_NAME)
                (PrimordialKosonID:string (UR_Assets 1 0))
                (EsothericKosonID:string (UR_Assets 1 1))
                (AncientKosonID:string (UR_Assets 1 2))

                (PlebiumDenariusID:string (UR_Assets 1 3))
                (ComatusAureusID:string (UR_Assets 1 4))

                (DenariusDebilisID:string (UR_Assets 2 0))
                (AureusFragilisID:string (UR_Assets 2 1))

                (ats-ids:[string]
                    (ref-TS01-C2::ATS|C_Issue
                        patron
                        patron
                        ["PlebeicStrength" "ComatiCommand"]
                        [24 24]
                        [PrimordialKosonID PrimordialKosonID]
                        [false false]
                        [PlebiumDenariusID ComatusAureusID]
                        [true true]
                    )
                )
            )
            (with-capability (SECURE)
                (map
                    (lambda
                        (idx:integer)
                        (A_AddATSPair (at idx ats-ids))
                    )
                    (enumerate 0 (- (length ats-ids) 1))
                )
            )
            ats-ids
        )
    )
    (defun A_Step006:[string] ()
        (let*
            (
                (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                (patron:string AOZ|SC_NAME)
                (PrimordialKosonID:string (UR_Assets 1 0))
                (EsothericKosonID:string (UR_Assets 1 1))
                (AncientKosonID:string (UR_Assets 1 2))

                (PileatusSolidusID:string (UR_Assets 1 5))
                (TarabostesStaterID:string (UR_Assets 1 6))


                (SolidusFractusID:string (UR_Assets 2 2))
                (StaterTenuulusID:string (UR_Assets 2 3))


                (ats-ids:[string]
                    (ref-TS01-C2::ATS|C_Issue
                        patron
                        patron
                        ["PileatiPower" "TarabostesTenacity"]
                        [24 24]
                        [PrimordialKosonID PrimordialKosonID]
                        [false false]
                        [PileatusSolidusID TarabostesStaterID]
                        [true true]
                    )
                )
            )
            (with-capability (SECURE)
                (map
                    (lambda
                        (idx:integer)
                        (A_AddATSPair (at idx ats-ids))
                    )
                    (enumerate 0 (- (length ats-ids) 1))
                )
            )
            ats-ids
        )
    )
    (defun A_Step007:[string] ()
        (let*
            (
                (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                (patron:string AOZ|SC_NAME)
                (PrimordialKosonID:string (UR_Assets 1 0))
                (EsothericKosonID:string (UR_Assets 1 1))
                (AncientKosonID:string (UR_Assets 1 2))

                (StrategonDrachmaID:string (UR_Assets 1 7))
                (BasileonAsID:string (UR_Assets 1 8))

                (DrachmaMinimaID:string (UR_Assets 2 4))
                (AsInfinimusID:string (UR_Assets 2 5))

                (ats-ids:[string]
                    (ref-TS01-C2::ATS|C_Issue
                        patron
                        patron
                        ["StrategonVigor" "AsAuthority"]
                        [24 24]
                        [PrimordialKosonID PrimordialKosonID]
                        [false false]
                        [StrategonDrachmaID BasileonAsID]
                        [true true]
                    )
                )
            )
            (with-capability (SECURE)
                (map
                    (lambda
                        (idx:integer)
                        (A_AddATSPair (at idx ats-ids))
                    )
                    (enumerate 0 (- (length ats-ids) 1))
                )
            )
            ats-ids
        )
    )
    (defun A_Step008 ()
        (with-capability (GOV|DPL_AOZ_ADMIN)
            (let
                (
                    (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                    (PlebeicStrengthID:string (UR_Assets 3 0))
                    (DenariusDebilisID:string (UR_Assets 2 0))
                    (decay:integer 0)
                )
                (XI_SetupKosonicATS PlebeicStrengthID DenariusDebilisID decay)
                (ref-TS01-C2::ATS|C_TurnRecoveryOn AOZ|SC_NAME PlebeicStrengthID true) ;;When deploying on mainnet must be removed
            )
        )
    )
    (defun A_Step009 ()
        (with-capability (GOV|DPL_AOZ_ADMIN)
            (let
                (
                    (AureusFragilisID:string (UR_Assets 2 1))
                    (ComatiCommandID:string (UR_Assets 3 1))
                    (decay:integer 90)
                )
                (XI_SetupKosonicATS ComatiCommandID AureusFragilisID decay)
            )
        )
    )
    (defun A_Step010 ()
        (with-capability (GOV|DPL_AOZ_ADMIN)
            (let
                (
                    (SolidusFractusID:string (UR_Assets 2 2))
                    (PileatiPowerID:string (UR_Assets 3 2))
                    (decay:integer 180)
                )
                (XI_SetupKosonicATS PileatiPowerID SolidusFractusID decay)
            )
        )
    )
    (defun A_Step011 ()
        (with-capability (GOV|DPL_AOZ_ADMIN)
            (let
                (
                    (StaterTenuulusID:string (UR_Assets 2 3))
                    (TarabostesTenacityID:string (UR_Assets 3 3))
                    (decay:integer 360)
                )
                (XI_SetupKosonicATS TarabostesTenacityID StaterTenuulusID decay)
            )
        )
    )
    (defun A_Step012 ()
        (with-capability (GOV|DPL_AOZ_ADMIN)
            (let
                (
                    (DrachmaMinimaID:string (UR_Assets 2 4))
                    (StrategonVigorID:string (UR_Assets 3 4))
                    (decay:integer 720)
                )
                (XI_SetupKosonicATS StrategonVigorID DrachmaMinimaID decay)
            )
        )
    )
    (defun A_Step013 ()
        (with-capability (GOV|DPL_AOZ_ADMIN)
            (let
                (
                    (AsInfinimusID:string (UR_Assets 2 5))
                    (AsAuthorityID:string (UR_Assets 3 5))
                    (decay:integer 1440)
                )
                (XI_SetupKosonicATS AsAuthorityID AsInfinimusID decay)
            )
        )
    )
    (defun A_Step014 ()
        (let
            (
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                (patron:string AOZ|SC_NAME)
                (PrimordialKosonID:string (UR_Assets 1 0))
                (EsothericKosonID:string (UR_Assets 1 1))
                (AncientKosonID:string (UR_Assets 1 2))
                (pk-amount:decimal 50000.0)
                (ek-amount:decimal 50000.0)
                (ak-amount:decimal 50000.0)
            )
            (ref-TS01-C1::DPTF|C_Mint
                patron
                PrimordialKosonID
                patron
                pk-amount
                true
            )
            (ref-TS01-C1::DPTF|C_Mint
                patron
                EsothericKosonID
                patron
                ek-amount
                true
            )
            (ref-TS01-C1::DPTF|C_Mint
                patron
                AncientKosonID
                patron
                ak-amount
                true
            )
        )
    )
    (defun A_Step015 (amount:decimal)
        (with-capability (GOV|DPL_AOZ_ADMIN)
            (XI_SetupCoilPairs (UR_Assets 3 0) amount)
        )
    )
    (defun A_Step016 (amount:decimal)
        (with-capability (GOV|DPL_AOZ_ADMIN)
            (XI_SetupCoilPairs (UR_Assets 3 1) amount)
        )
    )
    (defun A_Step017 (amount:decimal)
        (with-capability (GOV|DPL_AOZ_ADMIN)
            (XI_SetupCoilPairs (UR_Assets 3 2) amount)
        )
    )
    (defun A_Step018 (amount:decimal)
        (with-capability (GOV|DPL_AOZ_ADMIN)
            (XI_SetupCoilPairs (UR_Assets 3 3) amount)
        )
    )
    (defun A_Step019 (amount:decimal)
        (with-capability (GOV|DPL_AOZ_ADMIN)
            (XI_SetupCoilPairs (UR_Assets 3 4) amount)
        )
    )
    (defun A_Step020 (amount:decimal)
        (with-capability (GOV|DPL_AOZ_ADMIN)
            (XI_SetupCoilPairs (UR_Assets 3 5) amount)
        )
    )
    ;;{F6}  [C]
    ;;{F7}  [X]
    (defun XI_SetupKosonicATS (index-name:string hot-rbt:string decay:integer)
        (require-capability (GOV|DPL_AOZ_ADMIN))
        (let
            (
                (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                (patron:string AOZ|SC_NAME)
                (EsothericKosonID:string (UR_Assets 1 1))
                (AncientKosonID:string (UR_Assets 1 2))
            )
            (ref-TS01-C2::ATS|C_AddSecondary patron index-name EsothericKosonID false)
            (ref-TS01-C2::ATS|C_AddSecondary patron index-name AncientKosonID false)
            (ref-TS01-C2::ATS|C_AddHotRBT patron index-name hot-rbt)
            (if (!= decay 0)
                (ref-TS01-C2::ATS|C_SetHotFee patron index-name 900.0 decay)
                true
            )
            (ref-TS01-C2::ATS|C_TurnRecoveryOn patron index-name false)
        )
    )
    (defun XI_SetupCoilPairs (index-name:string amount:decimal)
        (require-capability (GOV|DPL_AOZ_ADMIN))
        (let
            (
                (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                (patron:string AOZ|SC_NAME)
                (PrimordialKosonID:string (UR_Assets 1 0))
                (EsothericKosonID:string (UR_Assets 1 1))
                (AncientKosonID:string (UR_Assets 1 2))
            )
            (ref-TS01-C2::ATS|C_Coil patron patron index-name PrimordialKosonID amount)
            (ref-TS01-C2::ATS|C_Coil patron patron index-name EsothericKosonID amount)
            (ref-TS01-C2::ATS|C_Coil patron patron index-name AncientKosonID amount)
        )
    )
    ;;{F7}
    ;;
)

(create-table AOZ|Assets)