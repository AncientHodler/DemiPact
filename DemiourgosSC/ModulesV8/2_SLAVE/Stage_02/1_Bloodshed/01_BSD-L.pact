(interface Bloodshed
    (defschema MD
        Rarity:string
        Dacian:string
        Potency:string
        Bloodshed:string
        Background:string
        FirstProtection:string
        SecondProtection:string
        MainHand:string
        OffHand:string
    )
    (defconst IPFS                  "https://ipfs.io/ipfs/QmYjHPWPxCeHGu9vgYUbzjmWo34A2z3CNuYmU6MEzgUSzP/")
    (defconst LEGENDARY             277.0)      ;;Legendary BS Score
    (defconst EPIC                  43.0)       ;;Epic BS Score
    (defconst RARE                  25.0)       ;;Rare BS Score
    (defconst COMMON                11.0)       ;;Common BS Score
    ;;
    (defconst LEGENDARY-S           160)        ;;Legendary Supply
    (defconst EPIC-S                1536)       ;;Epic Supply
    (defconst RARE-S                3168)       ;:Rare Supply
    (defconst COMMON-S              8064)       ;;Common Supply
    ;;
    (defconst R                     150.0)      ;;Native Bloodshed Royalty
    (defconst IR-L                  110.0)      ;;Legendary Ignis Royalty
    (defconst IR-E                  50.0)       ;;Epic Ignis Royalty
    (defconst IR-R                  30.0)       ;;Rare Ignis Royalty
    (defconst IR-C                  10.0)       ;;Common Ignis Royalty
    ;;
    (defconst BS-PREC               6)          ;;
    ;;Rarity
    (defconst R1                    "Common")
    (defconst R2                    "Rare")
    (defconst R3                    "Epic")
    (defconst R4                    "Legendary")
    ;;Dacian
    (defconst D1                    "Comati")
    (defconst D2                    "Ursoi")
    (defconst D3                    "Pileati")
    (defconst D4                    "Smardoi")
    (defconst D5                    "Carpian")
    (defconst D6                    "Tarabostes")
    (defconst D7                    "Costoboc")
    (defconst D8                    "Buridavens")
    ;;Potency
    (defconst P1                    "Standard" )
    (defconst P2                    "Premium")
    (defconst P3                    "Elite")
    ;;Bloodshed
    (defconst B0                    "Tier-0")
    (defconst B1                    "Tier-1")
    (defconst B2                    "Tier-2")
    (defconst B3                    "Tier-3")
    (defconst B4                    "Tier-4")
    (defconst B5                    "Tier-5")
    ;;Backgrounds
    (defconst CC1                   "Storm")
    (defconst CC2                   "Grainfield")
    (defconst CC3                   "Alpine")
    (defconst CC4                   "Swamp")
    (defconst CC5                   "Panonic")
    (defconst CC6                   "Continental")
    (defconst RR1                   "Rain")
    (defconst RR2                   "Steppe")
    (defconst RR3                   "Pontic")
    (defconst EP1                   "Fire")
    (defconst EP2                   "Lightning")
    (defconst LG1                   "WolvenTrinity")
    (defconst LG2                   "DacianGryphon")
    (defconst LG3                   "GryphonPhalera")
    (defconst LG4                   "UnicornBird")
    (defconst LG5                   "EightLeggedStag")
    (defconst LG6                   "RamSacrifice")
    (defconst LG7                   "SwirlingHorses")
    (defconst LG8                   "TwinRams")
    ;;MainProtection
    (defconst MP1                   "Bear-Skin")
    (defconst MP2                   "Armor")
    ;;SecondaryProtection
    (defconst SP1                   "DacianSkin")
    (defconst SP2                   "Shield")
    ;;MainHand
    (defconst MH1                   "Cosor")
    (defconst MH2                   "Falx")
    (defconst MH3                   "DacianDraco")
    ;;OffHand
    (defconst OH1                   "Cosor")
    (defconst OH2                   "Falx")
    (defconst OH3                   "Sicae")
    (defconst OH4                   "Pavaza")
    (defconst OH5                   "Howler")
    ;;
    (defconst NAME                  "Bloodshed")
    (defconst DS                    "A Collection of 12928 NFTs depicting 272 unique Dacian Warriors, representing Bloodshed.gg, a gaming Guild within Age of Zalmoxis - a Web3 MMORPG, spawned on Ouronet, powered by Kadena")
)
;;
(module BLOODSHED-L GOV
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_BLOODSHED-L            (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|BLOODSHED-L_ADMIN)))
    (defcap GOV|BLOODSHED-L_ADMIN ()        (enforce-guard GOV|MD_BLOODSHED-L))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    (defconst IPFS                  Bloodshed.IPFS)
    ;;
    (defconst LEGENDARY             Bloodshed.LEGENDARY)    ;;Legendary BS Score
    (defconst EPIC                  Bloodshed.EPIC)         ;;Epic BS Score
    (defconst RARE                  Bloodshed.RARE)         ;;Rare BS Score
    (defconst COMMON                Bloodshed.COMMON)       ;;Common BS Score
    ;;
    (defconst LEGENDARY-S           Bloodshed.LEGENDARY-S)  ;;Legendary Supply
    (defconst EPIC-S                Bloodshed.EPIC-S)       ;;Epic Supply
    (defconst RARE-S                Bloodshed.RARE-S)       ;:Rare Supply
    (defconst COMMON-S              Bloodshed.COMMON-S)     ;;Common Supply
    ;;
    (defconst R                     Bloodshed.R)            ;;Native Bloodshed Royalty
    (defconst IR-L                  Bloodshed.IR-L)         ;;Legendary Ignis Royalty
    (defconst IR-E                  Bloodshed.IR-E)         ;;Epic Ignis Royalty
    (defconst IR-R                  Bloodshed.IR-R)         ;;Rare Ignis Royalty
    (defconst IR-C                  Bloodshed.IR-C)         ;;Common Ignis Royalty
    ;;
    (defconst BS-PREC               Bloodshed.BS-PREC)      ;;Score Precision
    ;;
    (defconst NAME                  Bloodshed.NAME)         ;;Collection Name
    (defconst DS                    Bloodshed.DS)           ;;Colelction Description
    ;;
    ;;Rarity
    (defconst R1                    Bloodshed.R1)
    (defconst R2                    Bloodshed.R2)
    (defconst R3                    Bloodshed.R3)
    (defconst R4                    Bloodshed.R4)
    ;;Dacian
    (defconst D1                    Bloodshed.D1)
    (defconst D2                    Bloodshed.D2)
    (defconst D3                    Bloodshed.D3)
    (defconst D4                    Bloodshed.D4)
    (defconst D5                    Bloodshed.D5)
    (defconst D6                    Bloodshed.D6)
    (defconst D7                    Bloodshed.D7)
    (defconst D8                    Bloodshed.D8)
    ;;Potency
    (defconst P1                    Bloodshed.P1)
    (defconst P2                    Bloodshed.P2)
    (defconst P3                    Bloodshed.P3)
    ;;Bloodshed
    (defconst B0                    Bloodshed.B0)
    (defconst B1                    Bloodshed.B1)
    (defconst B2                    Bloodshed.B2)
    (defconst B3                    Bloodshed.B3)
    (defconst B4                    Bloodshed.B4)
    (defconst B5                    Bloodshed.B5)
    ;;Backgrounds
    (defconst CC1                   Bloodshed.CC1)
    (defconst CC2                   Bloodshed.CC2)
    (defconst CC3                   Bloodshed.CC3)
    (defconst CC4                   Bloodshed.CC4)
    (defconst CC5                   Bloodshed.CC5)
    (defconst CC6                   Bloodshed.CC6)
    (defconst RR1                   Bloodshed.RR1)
    (defconst RR2                   Bloodshed.RR2)
    (defconst RR3                   Bloodshed.RR3)
    (defconst EP1                   Bloodshed.EP1)
    (defconst EP2                   Bloodshed.EP2)
    (defconst LG1                   Bloodshed.LG1)
    (defconst LG2                   Bloodshed.LG2)
    (defconst LG3                   Bloodshed.LG3)
    (defconst LG4                   Bloodshed.LG4)
    (defconst LG5                   Bloodshed.LG5)
    (defconst LG6                   Bloodshed.LG6)
    (defconst LG7                   Bloodshed.LG7)
    (defconst LG8                   Bloodshed.LG8)
    ;;MainProtection
    (defconst MP1                   Bloodshed.MP1)
    (defconst MP2                   Bloodshed.MP2)
    ;;SecondaryProtection
    (defconst SP1                   Bloodshed.SP1)
    (defconst SP2                   Bloodshed.SP2)
    ;;MainHand
    (defconst MH1                   Bloodshed.MH1)
    (defconst MH2                   Bloodshed.MH2)
    (defconst MH3                   Bloodshed.MH2)
    ;;OffHand
    (defconst OH1                   Bloodshed.OH1)
    (defconst OH2                   Bloodshed.OH2)
    (defconst OH3                   Bloodshed.OH3)
    (defconst OH4                   Bloodshed.OH4)
    (defconst OH5                   Bloodshed.OH5)
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
    (defun OrderMultiplier:decimal (rarity-range:integer position:integer rarity-elements:integer)
        (enforce (<= position rarity-elements) "Invalid Position To Rarity Elements Value")
        (let
            (
                (rr:decimal (dec rarity-range))
                (p:decimal (dec position))
                (re:decimal (dec rarity-elements))
            )
            (floor (- rr (/ (* rr (- p 1)) (- re 1))) BS-PREC)
        )
    )
    (defun LegendaryOM (position:integer)
        (OrderMultiplier 100 position LEGENDARY-S)
    )
    (defun LS (position:integer)
        (floor (* LEGENDARY (LegendaryOM position)) BS-PREC)
    )
    ;;
    (defun LegendaryLink:string (position:integer small-or-big:bool)
        (let
            (
                (type:string (if small-or-big "512x512" "FULL"))
                (folder:string "/07_Bloodshed/1_Legendary/")
                (p:integer (mod position 8))
                (l:string "L_")
                (image-str:string 
                    (concat ["L_" (if (= p 0) "8" (format "{}" [p])) ".jpg"])
                )
            )
            (concat [IPFS type folder image-str])
        )
    )
    ;;
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    (defun MD:object{Bloodshed.MD}
        (a:string b:string c:string d:string e:string f:string g:string h:string i:string)
        {"Rarity"           : a
        ,"Dacian"           : b
        ,"Potency"          : c
        ,"Bloodshed"        : d
        ,"Background"       : e
        ,"FirstProtection"  : f
        ,"SecondProtection" : g
        ,"MainHand"         : h
        ,"OffHand"          : i
        }
    )
    ;;
    (defun L-x (pos:integer)
        (let
            (
                (p:integer (mod pos 8))
            )
            (cond
                ((= p 1) (MD R4 D1 P3 B5 LG1 MP1 SP1 MH3 OH2))
                ((= p 2) (MD R4 D2 P3 B5 LG2 MP1 SP1 MH1 OH1))
                ((= p 3) (MD R4 D3 P3 B5 LG3 MP1 SP2 MH2 OH4))
                ((= p 4) (MD R4 D4 P3 B5 LG4 MP1 SP1 MH2 OH3))
                ((= p 5) (MD R4 D5 P3 B5 LG5 MP2 SP1 MH3 OH5))
                ((= p 6) (MD R4 D6 P3 B5 LG6 MP2 SP2 MH2 OH4))
                ((= p 7) (MD R4 D7 P3 B5 LG7 MP2 SP1 MH2 OH5))
                ((= p 0) (MD R4 D8 P3 B5 LG8 MP2 SP1 MH1 OH1))
                true
            )
        )
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun A_Issue (patron:string collection-owner:string collection-creator:string)
        @doc "Issue Bloodshed NFT Collection"
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdcV2} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwoV6} TS02-C2)
            )
            (ref-TS02-C2::DPNF|C_Issue
                patron
                collection-owner collection-creator "DemiourgosHoldingsBloodshed" "DHB"
                true true true true true true true true
            )
        )
    )
    (defun A_Legendary (patron:string dhb:string pos:[integer])
        @doc "Issue Bloodshed Legendary NFT"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC-UDC:module{DpdcUdcV2} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwoV6} TS02-C2)
                (b:string BAR)
                (t:bool true)
                (f:bool false)
                ;;
                (d-l:string "Legendary Bloodshed NFT")
                ;;
                (type:object{DpdcUdcV2.URI|Type} (ref-DPDC-UDC::UDC_URI|Type t f f f f f f))
                (zd:object{DpdcUdcV2.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
                ;;
            )
            (ref-TS02-C2::DPNF|C_Create
                patron dhb
                (fold
                    (lambda
                        (acc:[object{DpdcUdcV2.DPDC|NonceData}] idx:integer)
                        (let
                            (
                                (p:integer (at idx pos))
                            )
                            (ref-U|LST::UC_AppL acc
                                (ref-DPDC-UDC::UDC_NonceData
                                    R
                                    IR-L
                                    (format "Bloodshed Legendary #{}" [p])
                                    d-l
                                    (ref-DPDC-UDC::UDC_ScoreMetaData (LS p) (L-x p))
                                    type
                                    (ref-DPDC-UDC::UDC_URI|Data (LegendaryLink p true) b b b b b b)
                                    (ref-DPDC-UDC::UDC_URI|Data (LegendaryLink p false) b b b b b b)
                                    zd
                                )
                            )
                        )
                    )
                    []
                    (enumerate 0 (- (length pos) 1))
                )
            )
        )
    )
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)