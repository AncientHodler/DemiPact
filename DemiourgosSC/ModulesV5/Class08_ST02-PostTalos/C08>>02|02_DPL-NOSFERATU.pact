(interface DeployerNosferatu
    ;;
    (defun A_Step00 (patron:string collection-owner:string collection-creator:string))
    (defun A_Step01 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step02 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step03 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step04 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step05 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step06 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step07 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step08 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step09 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step10 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step11 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step12 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step13 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step14 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step15 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step16 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step17 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step18 (patron:string dhn-id:string mdm:[[string]]))
    (defun A_Step19 (patron:string dhn-id:string mdm:[[string]]))
)
(module NOSFERATU GOV
    ;;
    (implements DeployerNosferatu)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_NOSFERATU              (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPL_NFT_ADMIN)))
    (defcap GOV|DPL_NFT_ADMIN ()            (enforce-guard GOV|MD_NOSFERATU))
    ;;{G3}
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
    (defschema NosferatuMetaData
        Backgrounds:string
        Body:string
        BodyAccesories:string
        Clothes:string
        Ear:string
        Eyes:string
        Glasses:string
        HandAccessories:string
        Hats:string
        MouthAccessories:string
        PhotoEffect:string
        Rarity:string
        Tooth:string
    )
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                        (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst B                             (CT_Bar))
    ;;
    (defconst IPFS "Ouronet-IPFS Link")
    (defconst R     100.0)  ;;Native Nosferatu Royalty
    (defconst IR-L  160.0)  ;;Legendary Ignis Royalty
    (defconst IR-E  80.0)   ;;Epic Ignis Royalty
    (defconst IR-R  40.0)   ;;Rare Ignis Royalty
    (defconst IR-C  20.0)   ;;Common Ignis Royalty
    ;;
    (defconst T true)
    (defconst F false)
    ;;
    (defconst D-L "Legendary Nosferat Earning 0.4 Percent of Nosferatu Movie Profits, and 0.25 Promile of all Future Movie Profits")
    (defconst D-E "Epic Nosferat Earning 0.2 Percent of Nosferatu Movie Profits, and 0.125 Promile of all Future Movie Profits")
    (defconst D-R "Rare Nosferat Earning 0.1 Percent of Nosferatu Movie Profits, and 0.0625 Promile of all Future Movie Profits")
    (defconst D-C "Common Nosferat Earning 0.5 Promile of Nosferatu Movie Profits, and 0.03125 Promile of all Future Movie Profits")
    ;;
    (defconst TYPE                          (let ((ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)) (ref-DPDC-UDC::UDC_URI|Type T F F F F F F)))
    (defconst ZD                            (let ((ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)) (ref-DPDC-UDC::UDC_ZeroURI|Data)))
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
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    (defun N:object{NosferatuMetaData} (a:[string])
        {"Backgrounds"      : (at 0 a)
        ,"Body"             : (at 1 a)
        ,"BodyAccesories"   : (at 2 a)
        ,"Clothes"          : (at 3 a)
        ,"Ear"              : (at 4 a)
        ,"Eyes"             : (at 5 a)
        ,"Glasses"          : (at 6 a)
        ,"HandAccessories"  : (at 7 a)
        ,"Hats"             : (at 8 a)
        ,"MouthAccessories" : (at 9 a)
        ,"PhotoEffect"      : (at 10 a)
        ,"Rarity"           : (at 11 a)
        ,"Tooth"            : (at 12 a)}
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun A_Step00 (patron:string collection-owner:string collection-creator:string)
        (let
            (
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
            )
            (ref-TS02-C2::DPNF|C_Issue
                patron
                collection-owner collection-creator "DemiourgosHoldingsNosferatu" "DHN"
                true true true true true true true true
            )
        )
    )
    (defun NosferatuSpawner (patron:string dhn-id:string mdm:[[string]] rarity:string starting-position:integer number-of-positions:integer)
        (let
            (
                (rarities:[string] ["Legendary" "Epic" "Rare" "Common"])
                (iz-rarity-ok:bool (contains rarity rarities))
            )
            (enforce iz-rarity-ok "Rarity string is invalid")
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                    (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
                    ;;
                    (IR:decimal
                        (cond
                            ((= rarity "Legendary") IR-L)
                            ((= rarity "Epic") IR-E)
                            ((= rarity "Rare") IR-R)
                            ((= rarity "Common") IR-C)
                            0.0
                        )
                    )
                    (D:string
                        (cond
                            ((= rarity "Legendary") D-L)
                            ((= rarity "Epic") D-E)
                            ((= rarity "Rare") D-R)
                            ((= rarity "Common") D-C)
                            ""
                        )
                    )
                    (l:integer (length mdm))
                )
                (enforce (= l number-of-positions) "Invalid Number of Positions")
                (ref-TS02-C2::DPNF|C_Create
                    patron dhn-id
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.DPDC|NonceData}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                (ref-DPDC-UDC::UDC_NonceData
                                    R
                                    IR
                                    (format "Nosferatu {} #{}" [rarity (+ starting-position idx)])
                                    D-L
                                    (ref-DPDC-UDC::UDC_MetaData (N (at idx mdm)))
                                    TYPE
                                    (ref-DPDC-UDC::UDC_URI|Data (fold (+) IPFS ["/" rarity "_" (format "{}" [(+ idx starting-position)]) ".png"]) B B B B B B)
                                    ZD
                                    ZD
                                )
                            )
                        )
                        []
                        (enumerate 0 (- (length mdm) 1))
                    )
                )
            )
            
        )
    )
    (defun A_Step01 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Legendary (1-80)"
        (NosferatuSpawner patron dhn-id mdm "Legendary" 1 80)
    )
    (defun A_Step02 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Legendary (81-100) and Epic (1-60)"
        [
            (NosferatuSpawner patron dhn-id (take 20 mdm) "Legendary" 81 20)
            (NosferatuSpawner patron dhn-id (take -60 mdm) "Epic" 1 60)
        ]
    )
    (defun A_Step03 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Epic (61-140)"
        (NosferatuSpawner patron dhn-id mdm "Epic" 61 80)
    )
    (defun A_Step04 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Epic (141-200) and Rare (1-20)"
        [
            (NosferatuSpawner patron dhn-id (take 60 mdm) "Epic" 141 60)
            (NosferatuSpawner patron dhn-id (take -20 mdm) "Rare" 1 20)
        ]
    )
    (defun A_Step05 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Rare (21-100)"
        (NosferatuSpawner patron dhn-id mdm "Rare" 21 80)
    )
    (defun A_Step06 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Rare (101-180)"
        (NosferatuSpawner patron dhn-id mdm "Rare" 101 80)
    )
    (defun A_Step07 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Rare (181-260)"
        (NosferatuSpawner patron dhn-id mdm "Rare" 181 80)
    )
    (defun A_Step08 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Rare (261-340)"
        (NosferatuSpawner patron dhn-id mdm "Rare" 261 80)
    )
    (defun A_Step09 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Rare (341-400) and Common (1-20)"
        [
            (NosferatuSpawner patron dhn-id (take 60 mdm) "Rare" 341 60)
            (NosferatuSpawner patron dhn-id (take -20 mdm) "Common" 1 20)
        ]
    )
    (defun A_Step10 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (21-100)"
        (NosferatuSpawner patron dhn-id mdm "Common" 21 80)
    )
    (defun A_Step11 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (101-180)"
        (NosferatuSpawner patron dhn-id mdm "Common" 101 80)
    )
    (defun A_Step12 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (181-260)"
        (NosferatuSpawner patron dhn-id mdm "Common" 181 80)
    )
    (defun A_Step13 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (261-340)"
        (NosferatuSpawner patron dhn-id mdm "Common" 261 80)
    )
    (defun A_Step14 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (341-420)"
        (NosferatuSpawner patron dhn-id mdm "Common" 341 80)
    )
    (defun A_Step15 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (421-500)"
        (NosferatuSpawner patron dhn-id mdm "Common" 421 80)
    )
    (defun A_Step16 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (501-580)"
        (NosferatuSpawner patron dhn-id mdm "Common" 501 80)
    )
    (defun A_Step17 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (581-660)"
        (NosferatuSpawner patron dhn-id mdm "Common" 581 80)
    )
    (defun A_Step18 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (661-740)"
        (NosferatuSpawner patron dhn-id mdm "Common" 661 80)
    )
    (defun A_Step19 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (741-800)"
        (NosferatuSpawner patron dhn-id mdm "Common" 741 60)
    )
    ;;{F7}  [X]
    ;;
)
