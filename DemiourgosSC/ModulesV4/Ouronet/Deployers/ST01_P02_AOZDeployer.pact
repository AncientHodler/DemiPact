(interface DeployerAoz
    (defun UR_Assets:string (ar:integer p:integer))
    (defun A_AddPrimalTrueFungible (tf:string))
    (defun A_AddPrimalMetaFungible (mf:string))
    (defun A_AddATSPair (atspair:string))
    (defun A_AddTrueFungibleGameAsset (tf:string))
    (defun A_AddMetaFungibleGameAsset (mf:string))
    (defun A_AddSemiFungibleGameAsset (sf:string))
    (defun A_AddNonFungibleGameAsset (nf:string))

    (defun A_Step001 ())

)
(module DPL-AOZ GOV
    ;;
    (implements DeployerAoz)
    ;;{G1}
    (defconst GOV|MD_DPL-AOZ                (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_DPL-AOZ                (keyset-ref-guard AOZ|SC_KEY))
    ;;
    (defconst DEMIURGOI|AH_KEY              (+ (GOV|NS_Use) ".dh_ah-keyset"))
    (defconst DEMIURGOI|AH_NAME             "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
    (defconst DEMIURGOI|AH_KDA-NAME         "k:6fa1d9c3e5078a54038159c9a6bd7182301e16d6f280615eddb18b8bd2d6c263")   ;;change to what is needed.
    (defconst DEMIURGOI|AH_PBL              "9G.CgcAjiI89ICnk45mxx63hwkBe5G71sIqfEta0ugkzF7EB6cy55BtzlFa27jDGE7Kn7ChljCmkcIsrDw9JwzJECieGLB5Jlkz9Blo6iJct6uxIA1u64Hr7HKa93EAiCwJJBBKAojJtwupEsvspH1jjGxKyFsb8fbfnJm1rAKxcIzcFILmmdHFaICfFpnbJG6tJu0HM9JCJ7MBCE7C2LiqvE6Fc1hqCeAdGHxDp7sGquI0wl2l08aa6wlKvwu44jgqF8mqDnCyjpxHuttEqjs4h9IJ28kmB53ppwoznt16rjzeMl21n3rwfI2es56rp5xavCabDacyCuonniz72L5d7dq3ptIEiuggEyLIIGe9sadH6eaMyitcmKaH7orgFz6d9kL9FKorBr06owFg328wFhCIlCFpwIzokmo47xKKt5kBzhyodBAjhCqayuHBue4oDhoA21A2H9ut9gApMuxokcmsi7Bd1kitrfJAy1GkrGiBK5dvlhgshcnGaG3vhkCm6dI5idCGjDEodivvDbgyI6zaajHvIMdBtrGvuKnxvsBulkbaDbk2wIdKwrK")
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
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    ;;
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
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{F0}
    (defun UEV_AssetPossition (a-row:integer a-pos:integer how-many-assets:integer)
        (enforce (= (contains a-pos (enumerate 0 (- how-many-assets 1))) true) (UC_Fm a-pos a-row))
    )
    (defun UC_Fm (p:integer ar:integer)
        (format "Position {} out of bounds for Asset-Row {}" [p ar])
    )
    (defun UR_Assets:string (ar:integer p:integer)
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
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
    ;;{F1}
    ;;{F2}
    ;;{F3}
    ;;{F4}
    ;;
    ;;{F5}
    (defun A_AddPrimalTrueFungible (tf:string)
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
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
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
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
                (ref-ATS:module{Autostake} ATS)
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
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
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
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
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
    ;;Deploy
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
                (ref-T01:module{TalosStageOne} TS01)
                (patron:string AOZ|SC_NAME)
                (tf-ids:[string]
                    (ref-T01::DPTF|C_Issue
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
                (ref-T01:module{TalosStageOne} TS01)
                (patron:string AOZ|SC_NAME)
                (PlebiumDenariusID:string (UR_Assets 1 3))
                (ComatusAureusID:string (UR_Assets 1 4))
                (PileatusSolidusID:string (UR_Assets 1 5))
                (TarabostesStaterID:string (UR_Assets 1 6))
                (StrategonDrachmaID:string (UR_Assets 1 7))
                (BasileonAsID:string (UR_Assets 1 8))
            )
            ;;Set Transaction Fees for Minor Solid Kosonic Currencies
            (ref-T01::DPTF|C_SetFee patron PlebiumDenariusID 10.0)
            (ref-T01::DPTF|C_ToggleFee patron PlebiumDenariusID true)
            (ref-T01::DPTF|C_ToggleFeeLock patron PlebiumDenariusID true)

            (ref-T01::DPTF|C_SetFee patron ComatusAureusID 20.0)
            (ref-T01::DPTF|C_ToggleFee patron ComatusAureusID true)
            (ref-T01::DPTF|C_ToggleFeeLock patron ComatusAureusID true)

            (ref-T01::DPTF|C_SetFee patron PileatusSolidusID 30.0)
            (ref-T01::DPTF|C_ToggleFee patron PileatusSolidusID true)
            (ref-T01::DPTF|C_ToggleFeeLock patron PileatusSolidusID true)

            (ref-T01::DPTF|C_SetFee patron TarabostesStaterID 40.0)
            (ref-T01::DPTF|C_ToggleFee patron TarabostesStaterID true)
            (ref-T01::DPTF|C_ToggleFeeLock patron TarabostesStaterID true)

            (ref-T01::DPTF|C_SetFee patron StrategonDrachmaID 50.0)
            (ref-T01::DPTF|C_ToggleFee patron StrategonDrachmaID true)
            (ref-T01::DPTF|C_ToggleFeeLock patron StrategonDrachmaID true)

            (ref-T01::DPTF|C_SetFee patron BasileonAsID 60.0)
            (ref-T01::DPTF|C_ToggleFee patron BasileonAsID true)
            (ref-T01::DPTF|C_ToggleFeeLock patron BasileonAsID true)
        )
    )
    ;;{F6}
    ;;{F7}
)

(create-table AOZ|Assets)