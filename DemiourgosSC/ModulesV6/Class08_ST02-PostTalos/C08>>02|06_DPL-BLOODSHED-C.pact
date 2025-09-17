(interface BsCommon
    (defun A_Common (patron:string dhb:string pos:[integer]))
)
(module BLOODSHED-C GOV
    ;;
    (implements BsCommon)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_BLOODSHED-C            (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|BLOODSHED-C_ADMIN)))
    (defcap GOV|BLOODSHED-C_ADMIN ()        (enforce-guard GOV|MD_BLOODSHED-C))
    ;;{G3}
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
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    ;;
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
    (defun CommonOM (position:integer)
        (let
            (
                (ref-BSL:module{BsLegendary} BLOODSHED-L)
            )
            (ref-BSL::OrderMultiplier 400 position COMMON-S)
        )
    )
    (defun CS (position:integer)
        (floor (* COMMON (CommonOM position)) BS-PREC)
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
    (defun C-x (pos:integer)
        (let
            (
                (p:integer (mod pos 144))
            )
            (cond
                ((= p 1) (MD R1 D1 P1 B0 CC1 MP1 SP1 MH3 OH2))
                ((= p 2) (MD R1 D1 P1 B0 CC2 MP1 SP1 MH3 OH2))
                ((= p 3) (MD R1 D1 P1 B0 CC3 MP1 SP1 MH3 OH2))
                ((= p 4) (MD R1 D1 P1 B0 CC4 MP1 SP1 MH3 OH2))
                ((= p 5) (MD R1 D1 P1 B0 CC5 MP1 SP1 MH3 OH2))
                ((= p 6) (MD R1 D1 P1 B0 CC6 MP1 SP1 MH3 OH2))
                ((= p 7) (MD R1 D1 P2 B1 CC1 MP1 SP1 MH3 OH2))
                ((= p 8) (MD R1 D1 P2 B1 CC2 MP1 SP1 MH3 OH2))
                ((= p 9) (MD R1 D1 P2 B1 CC3 MP1 SP1 MH3 OH2))
                ((= p 10) (MD R1 D1 P2 B1 CC4 MP1 SP1 MH3 OH2))
                ((= p 11) (MD R1 D1 P2 B1 CC5 MP1 SP1 MH3 OH2))
                ((= p 12) (MD R1 D1 P2 B1 CC6 MP1 SP1 MH3 OH2))
                ((= p 13) (MD R1 D1 P3 B2 CC1 MP1 SP1 MH3 OH2))
                ((= p 14) (MD R1 D1 P3 B2 CC2 MP1 SP1 MH3 OH2))
                ((= p 15) (MD R1 D1 P3 B2 CC3 MP1 SP1 MH3 OH2))
                ((= p 16) (MD R1 D1 P3 B2 CC4 MP1 SP1 MH3 OH2))
                ((= p 17) (MD R1 D1 P3 B2 CC5 MP1 SP1 MH3 OH2))
                ((= p 18) (MD R1 D1 P3 B2 CC6 MP1 SP1 MH3 OH2))
                ((= p 19) (MD R1 D2 P1 B0 CC1 MP1 SP1 MH1 OH1))
                ((= p 20) (MD R1 D2 P1 B0 CC2 MP1 SP1 MH1 OH1))
                ((= p 21) (MD R1 D2 P1 B0 CC3 MP1 SP1 MH1 OH1))
                ((= p 22) (MD R1 D2 P1 B0 CC4 MP1 SP1 MH1 OH1))
                ((= p 23) (MD R1 D2 P1 B0 CC5 MP1 SP1 MH1 OH1))
                ((= p 24) (MD R1 D2 P1 B0 CC6 MP1 SP1 MH1 OH1))
                ((= p 25) (MD R1 D2 P2 B1 CC1 MP1 SP1 MH1 OH1))
                ((= p 26) (MD R1 D2 P2 B1 CC2 MP1 SP1 MH1 OH1))
                ((= p 27) (MD R1 D2 P2 B1 CC3 MP1 SP1 MH1 OH1))
                ((= p 28) (MD R1 D2 P2 B1 CC4 MP1 SP1 MH1 OH1))
                ((= p 29) (MD R1 D2 P2 B1 CC5 MP1 SP1 MH1 OH1))
                ((= p 30) (MD R1 D2 P2 B1 CC6 MP1 SP1 MH1 OH1))
                ((= p 31) (MD R1 D2 P3 B2 CC1 MP1 SP1 MH1 OH1))
                ((= p 32) (MD R1 D2 P3 B2 CC2 MP1 SP1 MH1 OH1))
                ((= p 33) (MD R1 D2 P3 B2 CC3 MP1 SP1 MH1 OH1))
                ((= p 34) (MD R1 D2 P3 B2 CC4 MP1 SP1 MH1 OH1))
                ((= p 35) (MD R1 D2 P3 B2 CC5 MP1 SP1 MH1 OH1))
                ((= p 36) (MD R1 D2 P3 B2 CC6 MP1 SP1 MH1 OH1))
                ((= p 37) (MD R1 D3 P1 B0 CC1 MP1 SP2 MH2 OH4))
                ((= p 38) (MD R1 D3 P1 B0 CC2 MP1 SP2 MH2 OH4))
                ((= p 39) (MD R1 D3 P1 B0 CC3 MP1 SP2 MH2 OH4))
                ((= p 40) (MD R1 D3 P1 B0 CC4 MP1 SP2 MH2 OH4))
                ((= p 41) (MD R1 D3 P1 B0 CC5 MP1 SP2 MH2 OH4))
                ((= p 42) (MD R1 D3 P1 B0 CC6 MP1 SP2 MH2 OH4))
                ((= p 43) (MD R1 D3 P2 B1 CC1 MP1 SP2 MH2 OH4))
                ((= p 44) (MD R1 D3 P2 B1 CC2 MP1 SP2 MH2 OH4))
                ((= p 45) (MD R1 D3 P2 B1 CC3 MP1 SP2 MH2 OH4))
                ((= p 46) (MD R1 D3 P2 B1 CC4 MP1 SP2 MH2 OH4))
                ((= p 47) (MD R1 D3 P2 B1 CC5 MP1 SP2 MH2 OH4))
                ((= p 48) (MD R1 D3 P2 B1 CC6 MP1 SP2 MH2 OH4))
                ((= p 49) (MD R1 D3 P3 B2 CC1 MP1 SP2 MH2 OH4))
                ((= p 50) (MD R1 D3 P3 B2 CC2 MP1 SP2 MH2 OH4))
                ((= p 51) (MD R1 D3 P3 B2 CC3 MP1 SP2 MH2 OH4))
                ((= p 52) (MD R1 D3 P3 B2 CC4 MP1 SP2 MH2 OH4))
                ((= p 53) (MD R1 D3 P3 B2 CC5 MP1 SP2 MH2 OH4))
                ((= p 54) (MD R1 D3 P3 B2 CC6 MP1 SP2 MH2 OH4))
                ((= p 55) (MD R1 D4 P1 B0 CC1 MP1 SP1 MH2 OH3))
                ((= p 56) (MD R1 D4 P1 B0 CC2 MP1 SP1 MH2 OH3))
                ((= p 57) (MD R1 D4 P1 B0 CC3 MP1 SP1 MH2 OH3))
                ((= p 58) (MD R1 D4 P1 B0 CC4 MP1 SP1 MH2 OH3))
                ((= p 59) (MD R1 D4 P1 B0 CC5 MP1 SP1 MH2 OH3))
                ((= p 60) (MD R1 D4 P1 B0 CC6 MP1 SP1 MH2 OH3))
                ((= p 61) (MD R1 D4 P2 B1 CC1 MP1 SP1 MH2 OH3))
                ((= p 62) (MD R1 D4 P2 B1 CC2 MP1 SP1 MH2 OH3))
                ((= p 63) (MD R1 D4 P2 B1 CC3 MP1 SP1 MH2 OH3))
                ((= p 64) (MD R1 D4 P2 B1 CC4 MP1 SP1 MH2 OH3))
                ((= p 65) (MD R1 D4 P2 B1 CC5 MP1 SP1 MH2 OH3))
                ((= p 66) (MD R1 D4 P2 B1 CC6 MP1 SP1 MH2 OH3))
                ((= p 67) (MD R1 D4 P3 B2 CC1 MP1 SP1 MH2 OH3))
                ((= p 68) (MD R1 D4 P3 B2 CC2 MP1 SP1 MH2 OH3))
                ((= p 69) (MD R1 D4 P3 B2 CC3 MP1 SP1 MH2 OH3))
                ((= p 70) (MD R1 D4 P3 B2 CC4 MP1 SP1 MH2 OH3))
                ((= p 71) (MD R1 D4 P3 B2 CC5 MP1 SP1 MH2 OH3))
                ((= p 72) (MD R1 D4 P3 B2 CC6 MP1 SP1 MH2 OH3))
                ((= p 73) (MD R1 D5 P1 B0 CC1 MP2 SP1 MH3 OH5))
                ((= p 74) (MD R1 D5 P1 B0 CC2 MP2 SP1 MH3 OH5))
                ((= p 75) (MD R1 D5 P1 B0 CC3 MP2 SP1 MH3 OH5))
                ((= p 76) (MD R1 D5 P1 B0 CC4 MP2 SP1 MH3 OH5))
                ((= p 77) (MD R1 D5 P1 B0 CC5 MP2 SP1 MH3 OH5))
                ((= p 78) (MD R1 D5 P1 B0 CC6 MP2 SP1 MH3 OH5))
                ((= p 79) (MD R1 D5 P2 B1 CC1 MP2 SP1 MH3 OH5))
                ((= p 80) (MD R1 D5 P2 B1 CC2 MP2 SP1 MH3 OH5))
                ((= p 81) (MD R1 D5 P2 B1 CC3 MP2 SP1 MH3 OH5))
                ((= p 82) (MD R1 D5 P2 B1 CC4 MP2 SP1 MH3 OH5))
                ((= p 83) (MD R1 D5 P2 B1 CC5 MP2 SP1 MH3 OH5))
                ((= p 84) (MD R1 D5 P2 B1 CC6 MP2 SP1 MH3 OH5))
                ((= p 85) (MD R1 D5 P3 B2 CC1 MP2 SP1 MH3 OH5))
                ((= p 86) (MD R1 D5 P3 B2 CC2 MP2 SP1 MH3 OH5))
                ((= p 87) (MD R1 D5 P3 B2 CC3 MP2 SP1 MH3 OH5))
                ((= p 88) (MD R1 D5 P3 B2 CC4 MP2 SP1 MH3 OH5))
                ((= p 89) (MD R1 D5 P3 B2 CC5 MP2 SP1 MH3 OH5))
                ((= p 90) (MD R1 D5 P3 B2 CC6 MP2 SP1 MH3 OH5))
                ((= p 91) (MD R1 D6 P1 B0 CC1 MP2 SP2 MH2 OH4))
                ((= p 92) (MD R1 D6 P1 B0 CC2 MP2 SP2 MH2 OH4))
                ((= p 93) (MD R1 D6 P1 B0 CC3 MP2 SP2 MH2 OH4))
                ((= p 94) (MD R1 D6 P1 B0 CC4 MP2 SP2 MH2 OH4))
                ((= p 95) (MD R1 D6 P1 B0 CC5 MP2 SP2 MH2 OH4))
                ((= p 96) (MD R1 D6 P1 B0 CC6 MP2 SP2 MH2 OH4))
                ((= p 97) (MD R1 D6 P2 B1 CC1 MP2 SP2 MH2 OH4))
                ((= p 98) (MD R1 D6 P2 B1 CC2 MP2 SP2 MH2 OH4))
                ((= p 99) (MD R1 D6 P2 B1 CC3 MP2 SP2 MH2 OH4))
                ((= p 100) (MD R1 D6 P2 B1 CC4 MP2 SP2 MH2 OH4))
                ((= p 101) (MD R1 D6 P2 B1 CC5 MP2 SP2 MH2 OH4))
                ((= p 102) (MD R1 D6 P2 B1 CC6 MP2 SP2 MH2 OH4))
                ((= p 103) (MD R1 D6 P3 B2 CC1 MP2 SP2 MH2 OH4))
                ((= p 104) (MD R1 D6 P3 B2 CC2 MP2 SP2 MH2 OH4))
                ((= p 105) (MD R1 D6 P3 B2 CC3 MP2 SP2 MH2 OH4))
                ((= p 106) (MD R1 D6 P3 B2 CC4 MP2 SP2 MH2 OH4))
                ((= p 107) (MD R1 D6 P3 B2 CC5 MP2 SP2 MH2 OH4))
                ((= p 108) (MD R1 D6 P3 B2 CC6 MP2 SP2 MH2 OH4))
                ((= p 109) (MD R1 D7 P1 B0 CC1 MP2 SP1 MH2 OH5))
                ((= p 110) (MD R1 D7 P1 B0 CC2 MP2 SP1 MH2 OH5))
                ((= p 111) (MD R1 D7 P1 B0 CC3 MP2 SP1 MH2 OH5))
                ((= p 112) (MD R1 D7 P1 B0 CC4 MP2 SP1 MH2 OH5))
                ((= p 113) (MD R1 D7 P1 B0 CC5 MP2 SP1 MH2 OH5))
                ((= p 114) (MD R1 D7 P1 B0 CC6 MP2 SP1 MH2 OH5))
                ((= p 115) (MD R1 D7 P2 B1 CC1 MP2 SP1 MH2 OH5))
                ((= p 116) (MD R1 D7 P2 B1 CC2 MP2 SP1 MH2 OH5))
                ((= p 117) (MD R1 D7 P2 B1 CC3 MP2 SP1 MH2 OH5))
                ((= p 118) (MD R1 D7 P2 B1 CC4 MP2 SP1 MH2 OH5))
                ((= p 119) (MD R1 D7 P2 B1 CC5 MP2 SP1 MH2 OH5))
                ((= p 120) (MD R1 D7 P2 B1 CC6 MP2 SP1 MH2 OH5))
                ((= p 121) (MD R1 D7 P3 B2 CC1 MP2 SP1 MH2 OH5))
                ((= p 122) (MD R1 D7 P3 B2 CC2 MP2 SP1 MH2 OH5))
                ((= p 123) (MD R1 D7 P3 B2 CC3 MP2 SP1 MH2 OH5))
                ((= p 124) (MD R1 D7 P3 B2 CC4 MP2 SP1 MH2 OH5))
                ((= p 125) (MD R1 D7 P3 B2 CC5 MP2 SP1 MH2 OH5))
                ((= p 126) (MD R1 D7 P3 B2 CC6 MP2 SP1 MH2 OH5))
                ((= p 127) (MD R1 D8 P1 B0 CC1 MP2 SP1 MH1 OH1))
                ((= p 128) (MD R1 D8 P1 B0 CC2 MP2 SP1 MH1 OH1))
                ((= p 129) (MD R1 D8 P1 B0 CC3 MP2 SP1 MH1 OH1))
                ((= p 130) (MD R1 D8 P1 B0 CC4 MP2 SP1 MH1 OH1))
                ((= p 131) (MD R1 D8 P1 B0 CC5 MP2 SP1 MH1 OH1))
                ((= p 132) (MD R1 D8 P1 B0 CC6 MP2 SP1 MH1 OH1))
                ((= p 133) (MD R1 D8 P2 B1 CC1 MP2 SP1 MH1 OH1))
                ((= p 134) (MD R1 D8 P2 B1 CC2 MP2 SP1 MH1 OH1))
                ((= p 135) (MD R1 D8 P2 B1 CC3 MP2 SP1 MH1 OH1))
                ((= p 136) (MD R1 D8 P2 B1 CC4 MP2 SP1 MH1 OH1))
                ((= p 137) (MD R1 D8 P2 B1 CC5 MP2 SP1 MH1 OH1))
                ((= p 138) (MD R1 D8 P2 B1 CC6 MP2 SP1 MH1 OH1))
                ((= p 139) (MD R1 D8 P3 B2 CC1 MP2 SP1 MH1 OH1))
                ((= p 140) (MD R1 D8 P3 B2 CC2 MP2 SP1 MH1 OH1))
                ((= p 141) (MD R1 D8 P3 B2 CC3 MP2 SP1 MH1 OH1))
                ((= p 142) (MD R1 D8 P3 B2 CC4 MP2 SP1 MH1 OH1))
                ((= p 143) (MD R1 D8 P3 B2 CC5 MP2 SP1 MH1 OH1))
                ((= p 0) (MD R1 D8 P3 B2 CC6 MP2 SP1 MH1 OH1))
                true
            )
        )
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun A_Common (patron:string dhb:string pos:[integer])
        @doc "Issue Bloodshed Common NFT"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
                (ref-BSL:module{BsLegendary} BLOODSHED-L)
                (b:string BAR)
                (t:bool true)
                (f:bool false)
                ;;
                (d-l:string "Common Bloodshed NFT")
                ;;
                (type:object{DpdcUdc.URI|Type} (ref-DPDC-UDC::UDC_URI|Type t f f f f f f))
                (zd:object{DpdcUdc.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
                ;;
            )
            (ref-TS02-C2::DPNF|C_Create
                patron dhb
                (fold
                    (lambda
                        (acc:[object{DpdcUdc.DPDC|NonceData}] idx:integer)
                        (let
                            (
                                (p:integer (at idx pos))
                            )
                            (ref-U|LST::UC_AppL acc
                                (ref-DPDC-UDC::UDC_NonceData
                                    R
                                    IR-L
                                    (format "Bloodshed Common #{}" [p])
                                    d-l
                                    (ref-DPDC-UDC::UDC_ScoreMetaData (CS p) (C-x p))
                                    type
                                    (ref-DPDC-UDC::UDC_URI|Data (ref-BSL::BloodshedLink "Common" p) b b b b b b)
                                    zd
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