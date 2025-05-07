(interface DeployerNft
    (defun A_Step001 ())
    (defun C_CodingDivision (patron:string collection-owner:string collection-creator:string))
    (defun C_IssueCodingDivision:string (patron:string collection-owner:string collection-creator:string))
    (defun C_IssueCodingDivisionElements:string (patron:string dhcd-id:string))
    ;;
    (defun C_VestaxFinance (patron:string collection-owner:string collection-creator:string))
    (defun C_IssueVestaxFinance:string (patron:string collection-owner:string collection-creator:string))
    (defun C_IssueVestaxFinanceElements:string (patron:string dhvx-id:string))
)
(module DPL-NFT GOV
    ;;
    (implements DeployerNft)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPL-NFT                (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPL_NFT_ADMIN)))
    (defcap GOV|DPL_NFT_ADMIN ()            (enforce-guard GOV|MD_DPL-NFT))
    ;;{G3}
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
    (defun CT_Bar ()                        (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                           (CT_Bar))
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
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
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;  [NFT DEPLOY]
    (defun A_Step001 ()
        (let
            (
                (ref-P|DPDC:module{OuronetPolicy} DPDC)
                (ref-P|DPDC-U1:module{OuronetPolicy} DPDC-U1)
                (ref-P|DPDC-U2:module{OuronetPolicy} DPDC-U2)
                (ref-P|TS02-C1:module{OuronetPolicy} TS02-C1)
            )
            (ref-P|DPDC::P|A_Define)
            (ref-P|DPDC-U1::P|A_Define)
            (ref-P|DPDC-U2::P|A_Define)
            (ref-P|TS02-C1::P|A_Define)
        )
    )
    ;;{F6}  [C]
    
    ;;
    (defun C_CodingDivision (patron:string collection-owner:string collection-creator:string)
        @doc "Issues the Coding Division Collection with its 10 Elements"
        (C_IssueCodingDivisionElements 
            patron 
            (C_IssueCodingDivision patron collection-owner collection-creator)
        )
    )
    (defun C_IssueCodingDivision:string (patron:string collection-owner:string collection-creator:string)
        @doc "Issues the Coding Division DPSF Collection"
        (let
            (
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
            )
            (ref-TS02-C1::DPSF|C_Issue
                patron
                collection-owner collection-creator "DemiourgosHoldingsCodingDivision" "DHCD"
                true true true true
                true true true true
            )
        )
    )
    (defun C_IssueCodingDivisionElements:string (patron:string dhcd-id:string)
        @doc "Issues 10 SFTs within the CD Collection, each with 500 Units"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
                ;;
                (r:decimal 150.0)
                (i:decimal 50.0)
                (names:[string]
                    ["Snake Eye" "Rudis" "Gwen" "Clutter" "Bangai" "Binos" "Rubia" "Ocultus" "Oreta" "Binar"]
                )
                (descriptions:[string]
                    [
                        "Long dormant sentient AI, Snake Eye. Coded by a mad developer back in the 80s. Awakened by DemiourgosHoldings. With the help of our Coding Division it searches for his creator."
                        "Of Japanese origin, Rudis was forced by the Yakuza to leave his homeland. His ancestors were traced back to the 47 Ronin riot on the 14th of December 1702. Abounty is placed on his head for \"bad genetics\". He found shelter at our Coding Division. Works remote."
                        "After the great nuclear war between East and West, Gwen was forced to leave her homeland. She comes from the East and met her love in the West. Together they trz to prove that East and West can love each other. She joined our Coding Division shortly after her runaway in Europe."
                        "Born in the USA, Clutter migrated to Europe where he met Gwen - an Asian runaway. They fell in love and the rest is history, at least that is what they believe. Together they are the heart and soul of our team at Demiourgos Holdings."
                        "She is the most respected and feared hacker of her time. Born in Romania, she hacked her billionaire husband's accounts and build a submarine secret refuge for all the hackers in the world. Some say her refuge is at the Arctic or the North Pole, others in the nuclear seas of the East. Most of us believe she remains close to her home. Bangai offers council to Coding Division from time to time."
                        "Binos grew up as a poor kid in West Africa. From childhood, he studied coding, and finally it paid off in his mid-20s after the Great War between East and West. Africa became the strongest continent on Earth and Binos became a leader in his community. He joined Demiourgos Coding Division as a high esteemed and skilled visionary in coding."
                        "Born and raised in Paris, she loved poetry and arts since childhood. Her father, a team lead programmer at CERN European Organization of Nuclear Research, forced her to follow her steps as a programmer. Rubia turned into a punk rebel queen and spent most of her time in the suburbs of Paris doing riots against the system. Rubia Hacked the CERN whole system and joined Bangai as sister-in-love. Her father was imprisoned for treason."
                        "He is the mastermind behind the Coding Division. As nobody knows his true identity, most of us believe Ocultus managed to clone himself by awakening and using Snake Eye. Archive footage of strange occult rituals between androids and humans leaked to the press. He is one of the most wanted coders between friends and foes."
                        "At age 17 she saved London from the great ocean flood that came during the War between East and West by using a code to align electronical devices and hardware memory. After the government stole her work, she was recruited by Ocultus for a greater cause."
                        "In his youth, Binar developed the Elrond Blockchain. Nobody knows exactly his whereabouts and most forgot his name. During The Great War, people priorities their lives over the development of new technologies. Binar helped fund the war efforts of the West against the East. Today he is rarely seen in public. About once a year he visits our Coding Division. He brings lots of champagne."
                    ]
                )
                (md:[object] [{}])
                (asset-type:object{DemiourgosPactDigitalCollectibles.DC|URI|Type}
                    {"image"    : false
                    ,"audio"    : false
                    ,"video"    : true
                    ,"document" : false
                    ,"archive"  : false
                    ,"model"    : false
                    ,"exotic"   : false}
                )
                (ext:string ".mp4")
                (l1:string "https://crimson-giant-bobcat-181.mypinata.cloud/ipfs/QmXSBRXv3Uj2nZ8fUcnHEioDTiwCkxAQz96BZvcLhFTVyk/")
                (l2:string "https://ipfs.io/ipfs/QmXSBRXv3Uj2nZ8fUcnHEioDTiwCkxAQz96BZvcLhFTVyk/")
                (ltf:[string] ["1" "2" "3" "4" "5" "6" "7" "8" "9" "10"])
                (b:string "|")
                (primary-uri-lst:[object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}]
                    (fold
                        (lambda
                            (acc:[object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                {"image"    : b
                                ,"audio"    : b
                                ,"video"    : (fold (+) "" [l1 (at idx ltf) ext])
                                ,"document" : b
                                ,"archive"  : b
                                ,"model"    : b
                                ,"exotic"   : b}
                            )
                        )
                        []
                        (enumerate 0 (- (length ltf) 1))
                    )
                )
                (secondary-uri-lst:[object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}]
                    (fold
                        (lambda
                            (acc:[object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                {"image"    : b
                                ,"audio"    : b
                                ,"video"    : (fold (+) "" [l2 (at idx ltf) ext])
                                ,"document" : b
                                ,"archive"  : b
                                ,"model"    : b
                                ,"exotic"   : b}
                            )
                        )
                        []
                        (enumerate 0 (- (length ltf) 1))
                    )
                )
                (tertiary-uri:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
                    {"image"    : b
                    ,"audio"    : b
                    ,"video"    : b
                    ,"document" : b
                    ,"archive"  : b
                    ,"model"    : b
                    ,"exotic"   : b}
                )
            )
            (ref-TS02-C1::DPSF|C_Create
                patron dhcd-id (make-list 10 500)
                (fold
                    (lambda
                        (acc:[object{DemiourgosPactDigitalCollectibles.DC|DataSchema}] idx:integer)
                        (ref-U|LST::UC_AppL acc
                            {"royalty"          : r
                            ,"ignis"            : i
                            ,"name"             : (at idx names)
                            ,"description"      : (at idx descriptions)
                            ,"meta-data"        : md
                            ,"asset-type"       : asset-type
                            ,"uri-primary"      : (at idx primary-uri-lst)
                            ,"uri-secondary"    : (at idx secondary-uri-lst)
                            ,"uri-tertiary"     : tertiary-uri}
                        )
                    )
                    []
                    (enumerate 0 (- (length ltf) 1))
                )
            )
        )
    )
    ;;
    (defun C_VestaxFinance (patron:string collection-owner:string collection-creator:string)
        @doc "Issues the Coding Division Collection with its 10 Elements"
        (C_IssueVestaxFinanceElements 
            patron 
            (C_IssueVestaxFinance patron collection-owner collection-creator)
        )
    )
    (defun C_IssueVestaxFinance:string (patron:string collection-owner:string collection-creator:string)
        @doc "Issues the VestaX-Finance DPSF Collection"
        (let
            (
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
            )
            (ref-TS02-C1::DPSF|C_Issue
                patron
                collection-owner collection-creator "DemiourgosHoldingsVestaX" "DHVX"
                true true true true
                true true true true
            )
        )
    )
    (defun C_IssueVestaxFinanceElements:string (patron:string dhvx-id:string)
        @doc "Issues 3 SFTs within the VX Collection, each with 1000 2000 3000 Units"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
                ;;
                (r:decimal 150.0)
                (i:[decimal] [32.0 18.0 10.0])
                (names:[string]
                    ["GoldenVestaX" "SilverVestaX" "BronzeVestaX"]
                )
                (descriptions:[string]
                    [
                        "Financial Ownership over 15% of VestaX.Finance Revenues. Multiple Benefits in Demiourgos.Holdings Ecosystem. For Demiourgos OGs."
                        "Financial Ownership over 15% of VestaX.Finance Revenues. Multiple Benefits in Demiourgos.Holdings Ecosystem. For Demiourgos Partners."
                        "Financial Ownership over 15% of VestaX.Finance Revenues. Multiple Benefits in Demiourgos.Holdings Ecosystem. For Demiourgos Investors."
                    ]
                )
                (md:[object] [{}])
                (asset-type:object{DemiourgosPactDigitalCollectibles.DC|URI|Type}
                    {"image"    : false
                    ,"audio"    : false
                    ,"video"    : true
                    ,"document" : false
                    ,"archive"  : false
                    ,"model"    : false
                    ,"exotic"   : false}
                )
                (l1:[string]
                    [
                        "https://crimson-giant-bobcat-181.mypinata.cloud/ipfs/QmZ6TcrEEWcuJmZMcue3jFcX3BUXXn7CznAK2J5VhgFqEo"
                        "https://crimson-giant-bobcat-181.mypinata.cloud/ipfs/QmVCQ13cN2o91bnB45ByDEXqwMZmFd1CtDeEyqcVZD79Vc"
                        "https://crimson-giant-bobcat-181.mypinata.cloud/ipfs/QmQVVEFALsQKigZQHVRNBHgEQQ4pUJMtSMjE7K1Ge18eYH"
                    ]
                )
                (l2:[string]
                    [
                        "https://gateway.pinata.cloud/ipfs/QmZ6TcrEEWcuJmZMcue3jFcX3BUXXn7CznAK2J5VhgFqEo"
                        "https://gateway.pinata.cloud/ipfs/QmVCQ13cN2o91bnB45ByDEXqwMZmFd1CtDeEyqcVZD79Vc"
                        "https://gateway.pinata.cloud/ipfs/QmQVVEFALsQKigZQHVRNBHgEQQ4pUJMtSMjE7K1Ge18eYH"
                    ]
                )
                (b:string "|")
                (primary-uri-lst:[object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}]
                    (fold
                        (lambda
                            (acc:[object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                {"image"    : b
                                ,"audio"    : b
                                ,"video"    : (at idx l1)
                                ,"document" : b
                                ,"archive"  : b
                                ,"model"    : b
                                ,"exotic"   : b}
                            )
                        )
                        []
                        (enumerate 0 (- (length i) 1))
                    )
                )
                (secondary-uri-lst:[object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}]
                    (fold
                        (lambda
                            (acc:[object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                {"image"    : b
                                ,"audio"    : b
                                ,"video"    : (at idx l2)
                                ,"document" : b
                                ,"archive"  : b
                                ,"model"    : b
                                ,"exotic"   : b}
                            )
                        )
                        []
                        (enumerate 0 (- (length i) 1))
                    )
                )
                (tertiary-uri:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
                    {"image"    : b
                    ,"audio"    : b
                    ,"video"    : b
                    ,"document" : b
                    ,"archive"  : b
                    ,"model"    : b
                    ,"exotic"   : b}
                )
            )
            (ref-TS02-C1::DPSF|C_Create
                patron dhvx-id [1000 2000 4000]
                (fold
                    (lambda
                        (acc:[object{DemiourgosPactDigitalCollectibles.DC|DataSchema}] idx:integer)
                        (ref-U|LST::UC_AppL acc
                            {"royalty"          : r
                            ,"ignis"            : (at idx i)
                            ,"name"             : (at idx names)
                            ,"description"      : (at idx descriptions)
                            ,"meta-data"        : md
                            ,"asset-type"       : asset-type
                            ,"uri-primary"      : (at idx primary-uri-lst)
                            ,"uri-secondary"    : (at idx secondary-uri-lst)
                            ,"uri-tertiary"     : tertiary-uri}
                        )
                    )
                    []
                    (enumerate 0 (- (length i) 1))
                )
            )
        )
    )
    ;;{F7}  [X]
    ;;
)