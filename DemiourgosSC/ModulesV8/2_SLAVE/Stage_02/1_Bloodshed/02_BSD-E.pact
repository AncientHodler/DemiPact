(module BLOODSHED-E GOV
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_BLOODSHED-E            (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|BLOODSHED-E_ADMIN)))
    (defcap GOV|BLOODSHED-E_ADMIN ()        (enforce-guard GOV|MD_BLOODSHED-E))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
    (defun EpicOM (position:integer)
        (OrderMultiplier 200 position EPIC-S)
    )
    (defun ES (position:integer)
        (floor (* EPIC (EpicOM position)) BS-PREC)
    )
    ;;
    (defun EpicLink:string (position:integer small-or-big:bool)
        (let
            (
                (type:string (if small-or-big "512x512" "FULL"))
                (folder:string "/07_Bloodshed/2_Epic/")
                (p:integer (mod position 48))
                (l:string "E_")
                (v:string (format "{}" [(if (= p 0) 48 p)]))
                (padded-num:string 
                    (if (< p 10)
                        (+ "0" v)
                        v
                    )
                )
                (image-str:string (concat [l padded-num ".jpg"]))
            )
            (concat [IPFS type folder image-str])
        )
    )
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
    (defun E-x (pos:integer)
        (let
            (
                (p:integer (mod pos 48))
            )
            (cond
                ((= p 1) (MD R3 D1 P1 B2 EP1 MP1 SP1 MH3 OH2))
                ((= p 2) (MD R3 D1 P1 B2 EP2 MP1 SP1 MH3 OH2))
                ((= p 3) (MD R3 D1 P2 B3 EP1 MP1 SP1 MH3 OH2))
                ((= p 4) (MD R3 D1 P2 B3 EP2 MP1 SP1 MH3 OH2))
                ((= p 5) (MD R3 D1 P3 B4 EP1 MP1 SP1 MH3 OH2))
                ((= p 6) (MD R3 D1 P3 B4 EP2 MP1 SP1 MH3 OH2))
                ((= p 7) (MD R3 D2 P1 B2 EP1 MP1 SP1 MH1 OH1))
                ((= p 8) (MD R3 D2 P1 B2 EP2 MP1 SP1 MH1 OH1))
                ((= p 9) (MD R3 D2 P2 B3 EP1 MP1 SP1 MH1 OH1))
                ((= p 10) (MD R3 D2 P2 B3 EP2 MP1 SP1 MH1 OH1))
                ((= p 11) (MD R3 D2 P3 B4 EP1 MP1 SP1 MH1 OH1))
                ((= p 12) (MD R3 D2 P3 B4 EP2 MP1 SP1 MH1 OH1))
                ((= p 13) (MD R3 D3 P1 B2 EP1 MP1 SP2 MH2 OH4))
                ((= p 14) (MD R3 D3 P1 B2 EP2 MP1 SP2 MH2 OH4))
                ((= p 15) (MD R3 D3 P2 B3 EP1 MP1 SP2 MH2 OH4))
                ((= p 16) (MD R3 D3 P2 B3 EP2 MP1 SP2 MH2 OH4))
                ((= p 17) (MD R3 D3 P3 B4 EP1 MP1 SP2 MH2 OH4))
                ((= p 18) (MD R3 D3 P3 B4 EP2 MP1 SP2 MH2 OH4))
                ((= p 19) (MD R3 D4 P1 B2 EP1 MP1 SP1 MH2 OH3))
                ((= p 20) (MD R3 D4 P1 B2 EP2 MP1 SP1 MH2 OH3))
                ((= p 21) (MD R3 D4 P2 B3 EP1 MP1 SP1 MH2 OH3))
                ((= p 22) (MD R3 D4 P2 B3 EP2 MP1 SP1 MH2 OH3))
                ((= p 23) (MD R3 D4 P3 B4 EP1 MP1 SP1 MH2 OH3))
                ((= p 24) (MD R3 D4 P3 B4 EP2 MP1 SP1 MH2 OH3))
                ((= p 25) (MD R3 D5 P1 B2 EP1 MP2 SP1 MH3 OH5))
                ((= p 26) (MD R3 D5 P1 B2 EP2 MP2 SP1 MH3 OH5))
                ((= p 27) (MD R3 D5 P2 B3 EP1 MP2 SP1 MH3 OH5))
                ((= p 28) (MD R3 D5 P2 B3 EP2 MP2 SP1 MH3 OH5))
                ((= p 29) (MD R3 D5 P3 B4 EP1 MP2 SP1 MH3 OH5))
                ((= p 30) (MD R3 D5 P3 B4 EP2 MP2 SP1 MH3 OH5))
                ((= p 31) (MD R3 D6 P1 B2 EP1 MP2 SP2 MH2 OH4))
                ((= p 32) (MD R3 D6 P1 B2 EP2 MP2 SP2 MH2 OH4))
                ((= p 33) (MD R3 D6 P2 B3 EP1 MP2 SP2 MH2 OH4))
                ((= p 34) (MD R3 D6 P2 B3 EP2 MP2 SP2 MH2 OH4))
                ((= p 35) (MD R3 D6 P3 B4 EP1 MP2 SP2 MH2 OH4))
                ((= p 36) (MD R3 D6 P3 B4 EP2 MP2 SP2 MH2 OH4))
                ((= p 37) (MD R3 D7 P1 B2 EP1 MP2 SP1 MH2 OH5))
                ((= p 38) (MD R3 D7 P1 B2 EP2 MP2 SP1 MH2 OH5))
                ((= p 39) (MD R3 D7 P2 B3 EP1 MP2 SP1 MH2 OH5))
                ((= p 40) (MD R3 D7 P2 B3 EP2 MP2 SP1 MH2 OH5))
                ((= p 41) (MD R3 D7 P3 B4 EP1 MP2 SP1 MH2 OH5))
                ((= p 42) (MD R3 D7 P3 B4 EP2 MP2 SP1 MH2 OH5))
                ((= p 43) (MD R3 D8 P1 B2 EP1 MP2 SP1 MH1 OH1))
                ((= p 44) (MD R3 D8 P1 B2 EP2 MP2 SP1 MH1 OH1))
                ((= p 45) (MD R3 D8 P2 B3 EP1 MP2 SP1 MH1 OH1))
                ((= p 46) (MD R3 D8 P2 B3 EP2 MP2 SP1 MH1 OH1))
                ((= p 47) (MD R3 D8 P3 B4 EP1 MP2 SP1 MH1 OH1))
                ((= p 0) (MD R3 D8 P3 B4 EP2 MP2 SP1 MH1 OH1))
                true
            )
        )
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun A_Epic (patron:string dhb:string pos:[integer])
        @doc "Issue Bloodshed Epic NFT"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC-UDC:module{DpdcUdcV3} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwoV7} TS02-C2)
                (b:string BAR)
                (t:bool true)
                (f:bool false)
                ;;
                (d-l:string "Epic Bloodshed NFT")
                ;;
                (type:object{DpdcUdcV3.URI|Type} (ref-DPDC-UDC::UDC_URI|Type t f f f f f f))
                (zd:object{DpdcUdcV3.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
                ;;
            )
            (ref-TS02-C2::DPNF|C_Create
                patron dhb
                (fold
                    (lambda
                        (acc:[object{DpdcUdcV3.DPDC|NonceData}] idx:integer)
                        (let
                            (
                                (p:integer (at idx pos))
                            )
                            (ref-U|LST::UC_AppL acc
                                (ref-DPDC-UDC::UDC_NonceData
                                    R
                                    IR-L
                                    (format "Bloodshed Epic #{}" [p])
                                    d-l
                                    (ref-DPDC-UDC::UDC_ScoreMetaData (ES p) (E-x p))
                                    type
                                    (ref-DPDC-UDC::UDC_URI|Data (EpicLink p true) b b b b b b)
                                    (ref-DPDC-UDC::UDC_URI|Data (EpicLink p false) b b b b b b)
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