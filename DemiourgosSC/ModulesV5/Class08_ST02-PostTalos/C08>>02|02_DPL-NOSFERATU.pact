(interface DeployerNosferatu
    (defun A_Step01 (patron:string collection-owner:string collection-creator:string))
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
    (defconst BAR                           (CT_Bar))
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
    (defun UDC_NosMD:object{NosferatuMetaData}
        (i:[string])
        {"Backgrounds"      : (at 0 i)
        ,"Body"             : (at 1 i)
        ,"BodyAccesories"   : (at 2 i)
        ,"Clothes"          : (at 3 i)
        ,"Ear"              : (at 4 i)
        ,"Eyes"             : (at 5 i)
        ,"Glasses"          : (at 6 i)
        ,"HandAccessories"  : (at 7 i)
        ,"Hats"             : (at 8 i)
        ,"MouthAccessories" : (at 9 i)
        ,"PhotoEffect"      : (at 10 i)
        ,"Rarity"           : (at 11 i)
        ,"Tooth"            : (at 12 i)}
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun A_Step01 (patron:string collection-owner:string collection-creator:string)
        @doc "Issue Nosferatu NFT Collection"
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
                (b:string BAR)
                (dhn-id:string
                    (ref-TS02-C2::DPNF|C_Issue
                        patron
                        collection-owner collection-creator "DemiourgosHoldingsNosferatu" "DHN"
                        true true true true true true true true
                    )
                )
                (t:bool true)
                (f:bool false)
                ;;
                (r:decimal 100.0)
                (ri-l:decimal 160.0)
                (ri-e:decimal 80.0)
                (ri-r:decimal 40.0)
                (ri-c:decimal 20.0)
                ;;
                (d-l:string "Legendary Nosferat Earning 0.4 Percent of Nosferatu Movie Profits, and 0.25 Promile of all Future Movie Profits")
                (d-e:string "Epic Nosferat Earning 0.2 Percent of Nosferatu Movie Profits, and 0.125 Promile of all Future Movie Profits")
                (d-r:string "Rare Nosferat Earning 0.1 Percent of Nosferatu Movie Profits, and 0.0625 Promile of all Future Movie Profits")
                (d-c:string "Common Nosferat Earning 0.5 Promile of Nosferatu Movie Profits, and 0.03125 Promile of all Future Movie Profits")
                ;;
                (type:object{DpdcUdc.URI|Type} (ref-DPDC-UDC::UDC_URI|Type t f f f f f f))
                (zd:object{DpdcUdc.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
                ;;
                (l-l001:string "https://ipfs.io/ipfs/QmXtn1RpdCYjWSVwBVWwkaT8k5QtGZg2Rm5MTveHRd6exZ/Nosferatu%20Legendary_1.jpg")
                (l-l002:string "https://ipfs.io/ipfs/QmXtn1RpdCYjWSVwBVWwkaT8k5QtGZg2Rm5MTveHRd6exZ/Nosferatu%20Legendary_2.jpg")
                (l-l003:string "https://ipfs.io/ipfs/QmXtn1RpdCYjWSVwBVWwkaT8k5QtGZg2Rm5MTveHRd6exZ/Nosferatu%20Legendary_3.jpg")
                (l-l004:string "https://ipfs.io/ipfs/QmXtn1RpdCYjWSVwBVWwkaT8k5QtGZg2Rm5MTveHRd6exZ/Nosferatu%20Legendary_4.jpg")
                ;;
            )
            (ref-TS02-C2::DPNF|C_Create
                patron dhn-id
                [
                    (ref-DPDC-UDC::UDC_NonceData r ri-l "Nosferatu Legendary #1" d-l 
                        [(UDC_NosMD ["The Serpent's Cryptovault of Bloodcoin Hoard" "Nosferatu's Bloodgrip of Legends" "$Elite Auryn" "Viespar Coat with Legendary Bloodgrip" "Gold Earring Right" "Sanguine Tide Glow" "Golden Aristocrat Glasses" "Golden Ring" "Golden Wreath" "Queen of Clubs" "Crimson Veil Effect" "Legendary" "Silver Tooth"])]
                        type (ref-DPDC-UDC::UDC_URI|Data l-l001 b b b b b b) zd zd
                    )
                    (ref-DPDC-UDC::UDC_NonceData r ri-l "Nosferatu Legendary #2" d-l 
                        [(UDC_NosMD ["Shadowed Seat of Eternal Rule" "Nosferatu's Bloodgrip of Legends" "$Auryn" "Viespar with Legendary Bloodgrip" "Gold Earring Left" "Divine Glow" "Round Golden Glasses" "Engraved Ring" "King's Crown" "Gold Coin" "Crimson Veil Effect" "Legendary" "Gold Tooth"])]
                        type (ref-DPDC-UDC::UDC_URI|Data l-l002 b b b b b b) zd zd
                    )
                    (ref-DPDC-UDC::UDC_NonceData r ri-l "Nosferatu Legendary #3" d-l 
                        [(UDC_NosMD ["The Serpent's Cryptovault of Bloodcoin Hoard" "Legendary Vampiric Mesmeric Hypnotic Figure" "$Elite Auryn" "Viespar" "Double Gold Earrings Right" "Sanguine Tide Glow" "No Glasses" "No Accessories" "Wreath Leafs" "Opium Pipe #2" "Nightfall Mist Distortion" "Legendary" "Silver Tooth"])]
                        type (ref-DPDC-UDC::UDC_URI|Data l-l003 b b b b b b) zd zd
                    )
                    (ref-DPDC-UDC::UDC_NonceData r ri-l "Nosferatu Legendary #4" d-l 
                        [(UDC_NosMD ["Vampire's Haunting Steps" "Nosferatu's Bloodgrip of Legends" "$Auryn" "Viespar with Legendary Bloodgrip" "Silver Earring Left" "Moonlight Glow" "Golden Aristocrat Glasses" "Golden Skull Ring" "Tillted Peacky Hat" "Jack of Spades" "Moonlit Shadows Overlay" "Legendary" "Gold Tooth"])]
                        type (ref-DPDC-UDC::UDC_URI|Data l-l004 b b b b b b) zd zd
                    )
                ]
            )
        )
    )
    ;;{F7}  [X]
    ;;
)