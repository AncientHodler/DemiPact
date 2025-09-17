(module NOSFERATU GOV
    ;;
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
    (defun NosferatuSpawner (patron:string dhn-id:string rarity:string starting-position:integer number-of-positions:integer mdm:[[string]])
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
    ;;
    (defun A_Step01 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Legendary (1-70)"
        (NosferatuSpawner patron dhn-id "Legendary" 1 70 mdm)
    )
    (defun A_Step02 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Legendary (71-100) and Epic (1-40)"
        [
            (NosferatuSpawner patron dhn-id "Legendary" 71 30 (take 30 mdm))
            (NosferatuSpawner patron dhn-id "Epic" 1 40 (take -40 mdm))
        ]
    )
    (defun A_Step03 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Epic (41-110)"
        (NosferatuSpawner patron dhn-id "Epic" 41 70 mdm)
    )
    (defun A_Step04 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Epic (111-180)"
        (NosferatuSpawner patron dhn-id "Epic" 111 70 mdm)
    )
    (defun A_Step05 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Epic (181-200) and Rare (1-50)"
        [
            (NosferatuSpawner patron dhn-id "Epic" 181 20 (take 20 mdm))
            (NosferatuSpawner patron dhn-id "Rare" 1 50 (take -50 mdm))
        ]
    )
    (defun A_Step06 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Rare (51-120)"
        (NosferatuSpawner patron dhn-id "Rare" 51 70 mdm)
    )
    (defun A_Step07 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Rare (121-190)"
        (NosferatuSpawner patron dhn-id "Rare" 121 70 mdm)
    )
    (defun A_Step08 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Rare (191-260)"
        (NosferatuSpawner patron dhn-id "Rare" 191 70 mdm)
    )
    (defun A_Step09 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Rare (261-330)"
        (NosferatuSpawner patron dhn-id "Rare" 261 70 mdm)
    )
    (defun A_Step10 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Rare (331-400)"
        (NosferatuSpawner patron dhn-id "Rare" 331 70 mdm)
    )
    (defun A_Step11 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (1-70)"
        (NosferatuSpawner patron dhn-id "Common" 1 70 mdm)
    )
    (defun A_Step12 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (71-140)"
        (NosferatuSpawner patron dhn-id "Common" 71 70 mdm)
    )
    (defun A_Step13 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (141-210)"
        (NosferatuSpawner patron dhn-id "Common" 141 70 mdm)
    )
    (defun A_Step14 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (211-280)"
        (NosferatuSpawner patron dhn-id "Common" 211 70 mdm)
    )
    (defun A_Step15 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (281-350)"
        (NosferatuSpawner patron dhn-id "Common" 281 70 mdm)
    )
    (defun A_Step16 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (351-420)"
        (NosferatuSpawner patron dhn-id "Common" 351 70 mdm)
    )
    (defun A_Step17 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (421-490)"
        (NosferatuSpawner patron dhn-id "Common" 421 70 mdm)
    )
    (defun A_Step18 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (491-560)"
        (NosferatuSpawner patron dhn-id "Common" 491 70 mdm)
    )
    (defun A_Step19 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (561-630)"
        (NosferatuSpawner patron dhn-id "Common" 561 70 mdm)
    )
    (defun A_Step20 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (631-700)"
        (NosferatuSpawner patron dhn-id "Common" 631 70 mdm)
    )
    (defun A_Step21 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (701-770)"
        (NosferatuSpawner patron dhn-id "Common" 701 70 mdm)
    )
    (defun A_Step22 (patron:string dhn-id:string mdm:[[string]])
        @doc "Mint Nosferatu Common (771-800)"
        (NosferatuSpawner patron dhn-id "Common" 771 30 mdm)
    )
    ;;{F7}  [X]
    ;;
)
