
;(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")
(module AGEOFZALMOXIS GOVERNANCE

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
    ;;
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
)

(create-table AOZ|Assets)