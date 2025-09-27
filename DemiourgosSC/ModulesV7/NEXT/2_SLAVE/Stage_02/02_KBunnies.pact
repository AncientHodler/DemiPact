(module KBN GOV
    ;;
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_KBN                    (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPL_NFT_ADMIN)))
    (defcap GOV|DPL_NFT_ADMIN ()            (enforce-guard GOV|MD_KBN))
    ;;{G3}
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
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
    (defschema BunnyMetaData
        Rarity:string
        Background:string
        Clothes:string
        Ear:string
        Eyes:string
        Hats:string
        Mouth:string
    )
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                        (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst B                             (CT_Bar))
    ;;
    (defconst R     100.0)  ;;Native Bunny Royalty
    (defconst IR-L  1600.0) ;;Legendary Ignis Royalty
    (defconst IR-C  20.0)   ;;Common Ignis Royalty
    ;;
    (defconst T true)
    (defconst F false)
    ;;
    (defconst D-L "Golden Bunnies, the most precious Bunnies in the whole of Existance, makes the dreams come true for their Owners")
    (defconst D-C "Born on MultiversX, fled to Ouronet, ready for Unity, primed for Cryptoplasm, the Bunny Collection is here to make your dreams come true.")
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
    (defun UC_IpfsLink:string (starting-position:integer idx:integer small-or-big:bool)
        (let
            (
                (ipfs:string "https://ipfs.io/ipfs/QmYjHPWPxCeHGu9vgYUbzjmWo34A2z3CNuYmU6MEzgUSzP/")
                (type:string (if small-or-big "512x512" "FULL"))
                (folder:string "/06_DemiBunnies/")
                (number:integer (+ starting-position idx))
                (num-str:string (format "{}" [number]))
                (padded-num:string
                    (if (< number 1000)
                        (if (< number 100)
                            (if (< number 10)
                                (+ "000" num-str)
                                (+ "00" num-str)
                            )
                            (+ "0" num-str)
                        )
                        num-str
                    )
                )
                (jpg:string ".jpg")
            )
            (concat [ipfs type folder padded-num jpg])
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    (defun N:object{BunnyMetaData} (a:[string])
        {"Rarity"       : (at 0 a)
        ,"Background"   : (at 1 a)
        ,"Clothes"      : (at 2 a)
        ,"Ear"          : (at 3 a)
        ,"Eyes"         : (at 4 a)
        ,"Hats"         : (at 5 a)
        ,"Mouth"        : (at 6 a)
        }
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun BunnySpawner (patron:string kbn-id:string starting-position:integer number-of-positions:integer mdm:[[string]])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwoV4} TS02-C2)
                ;;
                (l:integer (length mdm))
                (legendary:[integer] [25 175 274 388 407 873 880 954 1033 1095])
                (iz-legendary ())
            )
            (enforce (= l number-of-positions) "Invalid Number of Positions")
            (ref-TS02-C2::DPNF|C_Create
                patron kbn-id
                (fold
                    (lambda
                        (acc:[object{DpdcUdc.DPDC|NonceData}] idx:integer)
                        (let
                            (
                                (element-number:integer (+ starting-position idx))
                                (iz-legendary:bool (contains element-number legendary))
                                (rarity:string (if iz-legendary "Legendary" "Common"))
                                (ignis-royalty:decimal (if iz-legendary IR-L IR-C))
                                (element-name:string (format "{} Bunny #{}" [rarity element-number]))
                                (description:string (if iz-legendary D-L D-C))
                            )
                            (ref-U|LST::UC_AppL acc
                                (ref-DPDC-UDC::UDC_NonceData
                                    R
                                    ignis-royalty
                                    element-name
                                    description
                                    (ref-DPDC-UDC::UDC_MetaData (N (at idx mdm)))
                                    TYPE
                                    (ref-DPDC-UDC::UDC_URI|Data (UC_IpfsLink starting-position idx true) B B B B B B)
                                    (ref-DPDC-UDC::UDC_URI|Data (UC_IpfsLink starting-position idx false) B B B B B B)
                                    ZD
                                )
                            )
                        )
                    )
                    []
                    (enumerate 0 (- (length mdm) 1))
                )
            )
        )
    )
    ;;
    (defun A_Step01 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 1 70 mdm)
    )
    (defun A_Step02 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 71 70 mdm)
    )
    (defun A_Step03 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 141 70 mdm)
    )
    (defun A_Step04 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 211 70 mdm)
    )
    (defun A_Step05 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 281 70 mdm)
    )
    (defun A_Step06 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 351 70 mdm)
    )
    (defun A_Step07 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 421 70 mdm)
    )
    (defun A_Step08 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 491 70 mdm)
    )
    (defun A_Step09 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 561 70 mdm)
    )
    (defun A_Step10 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 631 70 mdm)
    )
    (defun A_Step11 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 701 70 mdm)
    )
    (defun A_Step12 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 771 70 mdm)
    )
    (defun A_Step13 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 841 70 mdm)
    )
    (defun A_Step14 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 911 70 mdm)
    )
    (defun A_Step15 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 981 70 mdm)
    )
    (defun A_Step16 (patron:string kbn-id:string mdm:[[string]])
        (BunnySpawner patron kbn-id 1051 70 mdm)
    )
    ;;{F7}  [X]
    ;;
)