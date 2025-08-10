(interface DeployerNft
    (defun A_Step00 ())
    (defun A_Step01 ())
    (defun A_Step02 (patron:string collection-owner:string collection-creator:string))  ;;Ouronet Custodians
    (defun A_Step03 (patron:string collection-creator:string))                          ;;Demiourgos Shareholders
    (defun A_Step04 (patron:string collection-owner:string collection-creator:string))  ;;Coding Division
    (defun A_Step05 (patron:string collection-owner:string collection-creator:string))  ;;VestaX.Finance
    (defun A_Step06 (patron:string collection-owner:string collection-creator:string))  ;;Wonder Coach
    ;;
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
    (defun CT_Bar ()                        (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                           (CT_Bar))
    ;;
    (defconst DEMIURGOI|AH_NAME             "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
    ;;  [DPDC]
    (defconst DPDC|SC_KDA-NAME              "k:35d7f82a7754d10fc1128d199aadb51cb1461f0eb52f4fa89790a44434f12ed8")
    (defconst DPDC|SC_KEY                   (let ((ref-DPDC:module{Dpdc} DPDC)) (ref-DPDC::GOV|CollectiblesKey)))
    (defconst DPDC|SC_NAME                  (let ((ref-DPDC:module{Dpdc} DPDC)) (ref-DPDC::GOV|DPDC|SC_NAME)))
    (defconst DPDC|PBL                      (let ((ref-DPDC:module{Dpdc} DPDC)) (ref-DPDC::GOV|DPDC|PBL)))
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
    (defun N:object{DpdcUdc.DPDC|AllowedNonceForSetPosition} (lst:[integer])
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
            )
            (ref-DPDC-UDC::UDC_DPDC|AllowedNonceForSetPosition lst)
        )
    )
    (defun C:object{DpdcUdc.DPDC|AllowedClassForSetPosition} (input:integer)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
            )
            (ref-DPDC-UDC::UDC_DPDC|AllowedClassForSetPosition input)
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;  [NFT DEPLOY]
    (defun A_Step00 ()
        (let
            (
                (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                (ref-DPDC:module{Dpdc} DPDC)
                (patron:string DEMIURGOI|AH_NAME)
            )
            (ref-TS01-A::DALOS|A_DeploySmartAccount DPDC|SC_NAME (keyset-ref-guard DPDC|SC_KEY) DPDC|SC_KDA-NAME patron DPDC|PBL)
        )
    )
    (defun A_Step01 ()
        (let
            (
                (ref-P|DPDC-UDC:module{OuronetPolicy} DPDC-UDC)
                (ref-P|DPDC:module{OuronetPolicy} DPDC)
                (ref-P|DPDC-C:module{OuronetPolicy} DPDC-C)
                (ref-P|DPDC-I:module{OuronetPolicy} DPDC-I)
                (ref-P|DPDC-R:module{OuronetPolicy} DPDC-R)
                (ref-P|DPDC-MNG:module{OuronetPolicy} DPDC-MNG)
                (ref-P|DPDC-N:module{OuronetPolicy} DPDC-N)
                (ref-P|DPDC-T:module{OuronetPolicy} DPDC-T)
                (ref-P|DPDC-F:module{OuronetPolicy} DPDC-F)
                (ref-P|DPDC-S:module{OuronetPolicy} DPDC-S)
                ;;
                (ref-P|TS02-C1:module{OuronetPolicy} TS02-C1)
                (ref-P|TS02-C2:module{OuronetPolicy} TS02-C2)
                ;;
                (ref-P|EQUITY:module{OuronetPolicy} EQUITY)
                ;;
                (ref-DPDC:module{Dpdc} DPDC)
                (patron:string DEMIURGOI|AH_NAME)
            )
            (ref-P|DPDC-UDC::P|A_Define)
            (ref-P|DPDC::P|A_Define)
            (ref-P|DPDC-C::P|A_Define)
            (ref-P|DPDC-I::P|A_Define)
            (ref-P|DPDC-R::P|A_Define)
            (ref-P|DPDC-MNG::P|A_Define)
            (ref-P|DPDC-N::P|A_Define)
            (ref-P|DPDC-T::P|A_Define)
            (ref-P|DPDC-F::P|A_Define)
            (ref-P|DPDC-S::P|A_Define)
            ;;
            (ref-P|TS02-C1::P|A_Define)
            (ref-P|TS02-C2::P|A_Define)
            ;;
            (ref-P|EQUITY::P|A_Define)
            ;;
            (ref-DPDC::DPDC|SetGovernor patron)
        )
    )
    (defun A_Step02 (patron:string collection-owner:string collection-creator:string)
        @doc "Issues the Ouronet Custodians Collection with 3 Elements, each with Fragmentation Capabilities \
            \ Also Enables Fragmentation for Each Nonce"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
                ;;
                (dhoc-id:string
                    ;;1]Issue Custodians Collection
                    (ref-TS02-C1::DPSF|C_Issue
                        patron
                        collection-owner collection-creator "OuronetCustodians" "DHOC"
                        true true true true
                        true true true true
                    )
                )
                ;;
                (b:string BAR)
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (i-asset-type:object{DpdcUdc.URI|Type}
                    (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                )
                (zd:object{DpdcUdc.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
                ;;
                (royalty:[decimal]                  [70.0 60.0 50.0])
                (ignis-royalty:[decimal]            [5000.0 500.0 50.0])
                (names:[string]
                    [
                        "Ouronet Golden Star"
                        "Ouronet Silver Star"
                        "Ouronet Bronze Star"
                    ]
                )
                (descriptions:[string]
                    [
                        "Golden Ouronet Custodian SFTs, represents a third of Ouronet Financial Ownership, spread over 100 Units"
                        "Silver Ouronet Custodian SFTs, represents a third of Ouronet Financial Ownership, spread over 1000 Units"
                        "Bronze Ouronet Custodian SFTs, represents a third of Ouronet Financial Ownership, spread over 10000 Units"
                    ]
                )
                (image-links:[string]
                    [
                        "https://gateway.pinata.cloud/ipfs/QmUemLvfaJqKGMeXkxbinCQhNBKnRFMMn9fFnSF6FJ3FoP/1f.png"
                        "https://gateway.pinata.cloud/ipfs/QmUemLvfaJqKGMeXkxbinCQhNBKnRFMMn9fFnSF6FJ3FoP/2f.png"
                        "https://gateway.pinata.cloud/ipfs/QmUemLvfaJqKGMeXkxbinCQhNBKnRFMMn9fFnSF6FJ3FoP/3f.png"
                    ]
                )
                (primary-uri-lst:[object{DpdcUdc.URI|Data}]
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.URI|Data}] idx:integer)
                            (ref-U|LST::UC_AppL acc 
                                (ref-DPDC-UDC::UDC_URI|Data (at idx image-links) b b b b b b)
                            )
                        )
                        []
                        [0 1 2]
                    )
                )
                (native-nonce-data:[object{DpdcUdc.DPDC|NonceData}]
                    ;;Construct the Native Nonce Data in a 3 element list
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.DPDC|NonceData}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                (ref-DPDC-UDC::UDC_NonceData
                                    (at idx royalty)
                                    (at idx ignis-royalty)
                                    (at idx names)
                                    (at idx descriptions)
                                    md
                                    i-asset-type
                                    (at idx primary-uri-lst)
                                    zd
                                    zd
                                )
                            )
                        )
                        []
                        [0 1 2]
                    )
                )
                ;;
                (fragments-royalty:[decimal]        [40.0 30.0 20.0])
                (fragments-ignis-royalty:[decimal]  [10.0 2.0 0.4])
                (fragments-names:[string]
                    [
                        "Ouronet Golden Star Fragments"
                        "Ouronet Silver Star Fragments"
                        "Ouronet Bronze Star Fragments"
                    ]
                )
                (fragments-descriptions:[string]
                    [
                        "Golden Ouronet Fragment: 1/1000th of a Golden Custodian SFT, representing 1/100,000th of one-third of Ouronet’s Financial Ownership. Perfect for affordable investment in the Ouronet Virtual Blockchain."
                        "Silver Ouronet Fragment: 1/1000th of a Silver Custodian SFT, representing 1/1,000,000th of one-third of Ouronet’s Financial Ownership. Ideal for accessible investment in the Ouronet Virtual Blockchain."
                        "Bronze Ouronet Fragment: 1/1000th of a Bronze Custodian SFT, representing 1/10,000,000th of one-third of Ouronet’s Financial Ownership. Good cost-effective investment in the Ouronet Virtual Blockchain."
                    ]
                )
                (fragments-image-links:[string]
                    [
                        "https://gateway.pinata.cloud/ipfs/QmUemLvfaJqKGMeXkxbinCQhNBKnRFMMn9fFnSF6FJ3FoP/1s.png"
                        "https://gateway.pinata.cloud/ipfs/QmUemLvfaJqKGMeXkxbinCQhNBKnRFMMn9fFnSF6FJ3FoP/2s.png"
                        "https://gateway.pinata.cloud/ipfs/QmUemLvfaJqKGMeXkxbinCQhNBKnRFMMn9fFnSF6FJ3FoP/3s.png"
                    ]
                )
                (fragments-primary-uri-lst:[object{DpdcUdc.URI|Data}]
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.URI|Data}] idx:integer)
                            (ref-U|LST::UC_AppL acc 
                                (ref-DPDC-UDC::UDC_URI|Data (at idx fragments-image-links) b b b b b b)
                            )
                        )
                        []
                        [0 1 2]
                    )
                )
                (fragments-nonce-data:[object{DpdcUdc.DPDC|NonceData}]
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.DPDC|NonceData}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                (ref-DPDC-UDC::UDC_NonceData
                                    (at idx fragments-royalty)
                                    (at idx fragments-ignis-royalty)
                                    (at idx fragments-names)
                                    (at idx fragments-descriptions)
                                    md
                                    i-asset-type
                                    (at idx fragments-primary-uri-lst)
                                    zd
                                    zd
                                )
                            )
                        )
                        []
                        [0 1 2]
                    )
                )
            )
            [
                ;;2]Create Nonces [1 2 3]
                (ref-TS02-C1::DPSF|C_Create patron dhoc-id [100 1000 10000] native-nonce-data)
                ;;3]Enable Fragmentations for Nonces [1 2 3]
                (ref-TS02-C1::DPSF|C_EnableNonceFragmentation patron dhoc-id 1 (at 0 fragments-nonce-data))
                (ref-TS02-C1::DPSF|C_EnableNonceFragmentation patron dhoc-id 2 (at 1 fragments-nonce-data))
                (ref-TS02-C1::DPSF|C_EnableNonceFragmentation patron dhoc-id 3 (at 2 fragments-nonce-data))
            ]
            
        )
    )
    ;;
    (defun A_Step03 (patron:string collection-creator:string)
        @doc "Issues the Demiourgos Shareholder SemiFungible Equity Collection"
        (let
            (
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
            )
            (ref-TS02-C1::DPSF|C_IssueCompany
                patron collection-creator
                "DemiourgosHoldings" "DH"
                150.0 1000.0
                [
                    "Native Share IPFS Link"
                    "Tier 1 IPFS Link"
                    "Tier 2 IPFS Link"
                    "Tier 3 IPFS Link"
                    "Tier 4 IPFS Link"
                    "Tier 5 IPFS Link"
                    "Tier 6 IPFS Link"
                    "Tier 7 IPFS Link"
                ]
            )
        )
    )
    (defun A_Step04 (patron:string collection-owner:string collection-creator:string)
        @doc "Issues the Coding Division SemiFungible Collection"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
                ;;
                (dhcd-id:string
                    (ref-TS02-C1::DPSF|C_Issue
                        patron
                        collection-owner collection-creator "CodingDivision" "DHCD"
                        true true true true 
                        true true true true
                    )
                )
                ;;
                (b:string BAR)
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (i-asset-type:object{DpdcUdc.URI|Type}
                    (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                )
                (v-asset-type:object{DpdcUdc.URI|Type}
                    (ref-DPDC-UDC::UDC_URI|Type false false true false false false false)
                )
                (zd:object{DpdcUdc.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
                ;;
                (royalty:decimal            150.0)
                (set-royalty:decimal        120.0)
                (ignis-royalty:decimal      50.0)
                (set-ignis-royalty:decimal  400.0)
                (names:[string]
                    [
                        "Snake Eye" "Rudis" "Gwen" "Clutter" "Bangai" "Binos" "Rubia" "Ocultus" "Oretta" "Binar" "TheCodingDivision"
                    ]
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
                        "Full Coding Division Complement, working Day and Night for Demiourgos Holdings, to conquer the World"
                    ]
                )
                (image-links:[string]
                    [
                        "https://ipfs.io/ipfs/QmXSBRXv3Uj2nZ8fUcnHEioDTiwCkxAQz96BZvcLhFTVyk/1.mp4"
                        "https://ipfs.io/ipfs/QmXSBRXv3Uj2nZ8fUcnHEioDTiwCkxAQz96BZvcLhFTVyk/2.mp4"
                        "https://ipfs.io/ipfs/QmXSBRXv3Uj2nZ8fUcnHEioDTiwCkxAQz96BZvcLhFTVyk/3.mp4"
                        "https://ipfs.io/ipfs/QmXSBRXv3Uj2nZ8fUcnHEioDTiwCkxAQz96BZvcLhFTVyk/4.mp4"
                        "https://ipfs.io/ipfs/QmXSBRXv3Uj2nZ8fUcnHEioDTiwCkxAQz96BZvcLhFTVyk/5.mp4"
                        "https://ipfs.io/ipfs/QmXSBRXv3Uj2nZ8fUcnHEioDTiwCkxAQz96BZvcLhFTVyk/6.mp4"
                        "https://ipfs.io/ipfs/QmXSBRXv3Uj2nZ8fUcnHEioDTiwCkxAQz96BZvcLhFTVyk/7.mp4"
                        "https://ipfs.io/ipfs/QmXSBRXv3Uj2nZ8fUcnHEioDTiwCkxAQz96BZvcLhFTVyk/8.mp4"
                        "https://ipfs.io/ipfs/QmXSBRXv3Uj2nZ8fUcnHEioDTiwCkxAQz96BZvcLhFTVyk/9.mp4"
                        "https://ipfs.io/ipfs/QmXSBRXv3Uj2nZ8fUcnHEioDTiwCkxAQz96BZvcLhFTVyk/10.mp4"
                        "https://ipfs.io/ipfs/SetLink.png"
                    ]
                )
                (primary-uri-lst:[object{DpdcUdc.URI|Data}]
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.URI|Data}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                (if (!= idx 10)
                                    (ref-DPDC-UDC::UDC_URI|Data b b (at idx image-links) b b b b)
                                    (ref-DPDC-UDC::UDC_URI|Data (at idx image-links) b b b b b b)
                                )
                                
                            )
                        )
                        []
                        (enumerate 0 10)
                    )
                )
                (native-nonce-data:[object{DpdcUdc.DPDC|NonceData}]
                    ;;Construct the Native Nonce Data in a 11 element list
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.DPDC|NonceData}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                (ref-DPDC-UDC::UDC_NonceData
                                    (if (!= idx 10) royalty set-royalty)
                                    (if (!= idx 10) ignis-royalty set-ignis-royalty)
                                    (at idx names)
                                    (at idx descriptions)
                                    md
                                    (if (!= idx 10) v-asset-type i-asset-type)
                                    (at idx primary-uri-lst)
                                    zd
                                    zd
                                )
                            )
                        )
                        []
                        (enumerate 0 10)
                    )
                )
            )
            [
                ;;2]Create Nonces [1 2 3 4 5 6 7 8 9 10]
                (ref-TS02-C1::DPSF|C_Create patron dhcd-id (make-list 10 500) (drop -1 native-nonce-data))
                ;;3]Define the CodingDivision Primordial Set
                (ref-TS02-C1::DPSF|C_DefinePrimordialSet
                    patron dhcd-id (at 10 names) 1.0
                    [
                        (N [1])
                        (N [2])
                        (N [3])
                        (N [4])
                        (N [5])
                        (N [6])
                        (N [7])
                        (N [8])
                        (N [9])
                        (N [10])
                    ]
                    (at 10 native-nonce-data)
                )
            ]
        )
    )
    (defun A_Step05 (patron:string collection-owner:string collection-creator:string)
        @doc "Issues the VestaX.Finance SemiFungible Collection"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
                ;;
                (dhvx-id:string
                    ;;1]Issue VestaX.Finance Collection
                    (ref-TS02-C1::DPSF|C_Issue
                        patron
                        collection-owner collection-creator "VestaX" "DHVX"
                        true true true true
                        true true true true
                    )
                )
                ;;
                (b:string BAR)
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (v-asset-type:object{DpdcUdc.URI|Type}
                    (ref-DPDC-UDC::UDC_URI|Type false false true false false false false)
                )
                (zd:object{DpdcUdc.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
                ;;
                (royalty:decimal            150.0)
                (ignis-royalty:[decimal]    [32.0 18.0 10.0])
                (names:[string]
                    ["GoldenVestaX" "SilverVestaX" "BronzeVestaX"]
                )
                (descriptions:[string]
                    [
                        "Financial Ownership over 15% of VestaX.Finance Revenues. Multiple Ouronet Benefits. For Demiourgos OGs."
                        "Financial Ownership over 15% of VestaX.Finance Revenues. Multiple Ouronet Benefits. For Demiourgos Partners."
                        "Financial Ownership over 15% of VestaX.Finance Revenues. Multiple Ouronet Benefits. For Demiourgos Investors."
                    ]
                )
                (image-links:[string]
                    [
                        "https://gateway.pinata.cloud/ipfs/QmZ6TcrEEWcuJmZMcue3jFcX3BUXXn7CznAK2J5VhgFqEo"
                        "https://gateway.pinata.cloud/ipfs/QmVCQ13cN2o91bnB45ByDEXqwMZmFd1CtDeEyqcVZD79Vc"
                        "https://gateway.pinata.cloud/ipfs/QmQVVEFALsQKigZQHVRNBHgEQQ4pUJMtSMjE7K1Ge18eYH"
                    ]
                )
                (primary-uri-lst:[object{DpdcUdc.URI|Data}]
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.URI|Data}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                (ref-DPDC-UDC::UDC_URI|Data b b (at idx image-links) b b b b)
                            )
                        )
                        []
                        [0 1 2]
                    )
                )
                (native-nonce-data:[object{DpdcUdc.DPDC|NonceData}]
                    ;;Construct the Native Nonce Data in a 3 element list
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.DPDC|NonceData}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                (ref-DPDC-UDC::UDC_NonceData
                                    royalty
                                    (at idx ignis-royalty)
                                    (at idx names)
                                    (at idx descriptions)
                                    md
                                    v-asset-type
                                    (at idx primary-uri-lst)
                                    zd
                                    zd
                                )
                            )
                        )
                        []
                        [0 1 2]
                    )
                )
            )
            ;;2]Create Nonces [1 2 3]
            (ref-TS02-C1::DPSF|C_Create patron dhvx-id [1000 2000 4000] native-nonce-data)
        )
    )
    ;;
    (defun A_Step06 (patron:string collection-owner:string collection-creator:string)
        @doc "Issue Wonder Coach Collection with 30 Native Elements and 4 Set Elements"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
                ;;
                (dhwc-id:string
                    (ref-TS02-C1::DPSF|C_Issue
                        patron
                        collection-owner collection-creator "WonderCoach" "DHWC"
                        true true true true 
                        true true true true
                    )
                )
                ;;
                (b:string BAR)
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (i-asset-type:object{DpdcUdc.URI|Type}
                    (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                )
                (zd:object{DpdcUdc.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
                ;;
                (royalty:[decimal]              [100.0 90.0 80.0])
                (set-royalty:[decimal]          [70.0 60.0 50.0 40.0])
                (ignis-royalty:[decimal]        [10.0 20.0 50.0])
                (set-ignis-royalty:[decimal]    [95.0 180.0 425.0 560.0])
                ;;
                (r:[decimal]                    (fold (+) [] [(make-list 10 (at 0 royalty)) (make-list 10 (at 1 royalty)) (make-list 10 (at 2 royalty)) set-royalty]))
                (i-r:[decimal]                  (fold (+) [] [(make-list 10 (at 0 ignis-royalty)) (make-list 10 (at 1 ignis-royalty)) (make-list 10 (at 2 ignis-royalty)) set-ignis-royalty]))
                ;;
                (names:[string]
                    [
                        "Wonder Coach Bronze Frame #1"
                        "Wonder Coach Bronze Frame #2"
                        "Wonder Coach Bronze Frame #3"
                        "Wonder Coach Bronze Frame #4"
                        "Wonder Coach Bronze Frame #5"
                        "Wonder Coach Bronze Frame #6"
                        "Wonder Coach Bronze Frame #7"
                        "Wonder Coach Bronze Frame #8"
                        "Wonder Coach Bronze Frame #9"
                        "Wonder Coach Bronze Frame #10"

                        "Wonder Coach Silver Frame #1"
                        "Wonder Coach Silver Frame #2"
                        "Wonder Coach Silver Frame #3"
                        "Wonder Coach Silver Frame #4"
                        "Wonder Coach Silver Frame #5"
                        "Wonder Coach Silver Frame #6"
                        "Wonder Coach Silver Frame #7"
                        "Wonder Coach Silver Frame #8"
                        "Wonder Coach Silver Frame #9"
                        "Wonder Coach Silver Frame #10"

                        "Wonder Coach Golden Frame #1"
                        "Wonder Coach Golden Frame #2"
                        "Wonder Coach Golden Frame #3"
                        "Wonder Coach Golden Frame #4"
                        "Wonder Coach Golden Frame #5"
                        "Wonder Coach Golden Frame #6"
                        "Wonder Coach Golden Frame #7"
                        "Wonder Coach Golden Frame #8"
                        "Wonder Coach Golden Frame #9"
                        "Wonder Coach Golden Frame #10"

                        "Wonder Coach Bronze Chapter"
                        "Wonder Coach Silver Chapter"
                        "Wonder Coach Golden Chapter"
                        "Wonder Coach Movie Collectable"
                    ]
                )
                (descriptions:[string]
                    [
                        "Soul’s pause, forgotten calm sleep."
                        "Broken gaze, mirrored disappointment stares."
                        "Shadowed soul, hope in silent pain."
                        "Swinging power, coaching rhythm sways."
                        "Lonely duo, quiet tension lingers."
                        "Restless reflection, unease in mirror."
                        "Beyond words, smoke of resolve."
                        "Rising corner, fear behind glass."
                        "Alone in crowd, isolated gaze."
                        "Silent conviction, truth’s heavy stare."

                        "Success clashes, coaching tensions rise."
                        "Waiting gaze, eyes on tomorrow."
                        "Hope’s gift, love in lights."
                        "Silent fall, abyss edge moment."
                        "Change begins, fear faces forward."
                        "Despair’s echo, unbroken despite cry."
                        "Life’s rhythm, dance path unfolds."
                        "First steps, story begins, destiny touches."
                        "Taxi tears, mistaken return, letting go."
                        "Gentle truths, cat’s wisdom lesson."

                        "Inner superhero, power in thoughts."
                        "Quiet victory, smile after storm."
                        "Time spares none, patience slaps fury."
                        "Soaring idea, red eureka phone win."
                        "Red tenderness, cat’s secret, full thoughts."
                        "Pre-role dance, coaching steps glide."
                        "Past echoes back, connection lost."
                        "News post-ruin, breaker lifts again."
                        "Trembling silence, fear’s skin, guilty alone."
                        "Forced yes, scorn in receiver."

                        "The Woander Coach Bronze Chapter represents a complete Set of all Bronze Wonder Coach Frames. 7% Royalty and 95% Ignis-Royalty relative to individual Elements"
                        "The Wonder Coach Silver Chapter represents a complete Set of all Silver Wonder Coach Frames. 6% Royalty and 90% Ignis-Royalty relative to individual Elements"
                        "The Wonder Coach Golden Chapter represents a complete Set of all Golden Wonder Coach Frames. 5% Royalty and 85% Ignis-Royalty relative to individual Elements"
                        "The Woander Coach Movie Collectable represents the Complete Movie Collectable Set, containing all 30 existing Frames. 4% Royalty and 80% Ignis-Royalty relative to individual Elements"
                    ]
                )
                (image-links:[string]
                    [
                        "https://ipfs.io/ipfs/QmdNyUynFZEs3Qtw4UZR6UFabg9AvsTdTzb1D66XHAwsGy"
                        "https://ipfs.io/ipfs/QmaBitPm9zDtZigmjUwNv29CuX3breQCxAUtx5CpmdA2Re"
                        "https://ipfs.io/ipfs/QmeEf95o2CxTuxdbAWYZkDSqhLHLNaKDr15gfdMrEQ8iPt"
                        "https://ipfs.io/ipfs/QmavUDhJ9pi9UzE783ft24Ti2smEBZWkig2GjhxZhExeXz"
                        "https://ipfs.io/ipfs/QmbP4DTsAkcUnrYp9PU7Gie7idtbxvvkXqiwnVNmZKyudT"
                        "https://ipfs.io/ipfs/QmezgN8EJfP4DAxuUMFXkjYVsLusyWZkJmfWyMFCr5eoj6"
                        "https://ipfs.io/ipfs/QmZNLenWkaRJRobobb6mPFRCWww3YF26Qi9FD3tULehWMk"
                        "https://ipfs.io/ipfs/QmRNrj76DUhsXyzYoWtEL3upY7FBpTLiqBpKfjpuJ9wux6"
                        "https://ipfs.io/ipfs/QmdJp8RTzgQ3ikjJu6XP1UDHtXfUB9HRw4DyoPWH2uoFQu"
                        "https://ipfs.io/ipfs/QmcH3NvyhtKuGjja7wTBF3Jy4yEU684ibD3QMZDk6QQh1r"

                        "https://ipfs.io/ipfs/QmTihLCsqxqakVmqYnkMoeVhknFQCQ2nmRA6UjwdLrCHWJ"
                        "https://ipfs.io/ipfs/QmWJ73VJ8FthkXF8xdvbhfFY26T8BEZyKqUV7A4JNzwFhy"
                        "https://ipfs.io/ipfs/QmcbPCpCL7mJZ7WXKqaYBBzZW53QEGZTSPUY8cXdquyXug"
                        "https://ipfs.io/ipfs/QmZeEFsG96SsVZm9Ka3vXu4zx99T2ryxtYo9HLH6EEiqiy"
                        "https://ipfs.io/ipfs/QmeoLjGL1FifK2QmjA72jkdTXGaLzJieWNYaWQC4uaVSP2"
                        "https://ipfs.io/ipfs/QmYDZJkMCeCo2PU5ByLGmVhNAdX2N4oEpjveJdQpzBdsrb"
                        "https://ipfs.io/ipfs/QmZ4ppMuYoNMEbroytgMhozxJSPJT94JfK4pmogzH1oi4t"
                        "https://ipfs.io/ipfs/QmS6hzw2sr3cr9rZQC86f9yU7jy3uVqCbZQXzA2utbcyYK"
                        "https://ipfs.io/ipfs/QmV64EEbEiP9YNGXpdExX8hxUjHXcS7wTdGaZjiMUWinQH"
                        "https://ipfs.io/ipfs/QmcKq3aRpvgksHFVT2gPvpgVqJRK1xskoumsjUco7K2187"

                        "https://ipfs.io/ipfs/QmS7SP1BK53pxRxwff8yYc2AaXC9NCpPa2QFk5tWomXwqt"
                        "https://ipfs.io/ipfs/QmQU14hEPnooFQcWfVfhBKy69jCpW3wZ3F6Dgeocxsd81G"
                        "https://ipfs.io/ipfs/QmSVnL8CTd4a7zYHeptj5dH6MXtfxz1o5gPqL2k8qk9Uzf"
                        "https://ipfs.io/ipfs/QmbVcTCgswd9v8HixeUru6tbXkq8GLKQ6FXF5N21etbG6C"
                        "https://ipfs.io/ipfs/QmTZT1LCw6yb8qxNr6twHLLFuReYspseb99DftaiEkzaJR"
                        "https://ipfs.io/ipfs/QmZCoG2TY7Hi3c3CzL4Dvz7bvVPCAnSCuehZx1e9Jh1zCJ"
                        "https://ipfs.io/ipfs/QmcPnMURPCdk8qpEXc3q6V7UUqAPmDHVbFMRYTZheeuNDs"
                        "https://ipfs.io/ipfs/QmPMNgtXCd9Pe9Qsnen9Tg2koLKXKriMAgMd9rAeHk6V77"
                        "https://ipfs.io/ipfs/QmQWWhJ4T8sfwTYFAz5evz3ZX6mxof9KgDxBb7EHyirG1f"
                        "https://ipfs.io/ipfs/QmQBByq28rgrce5UNxmJpP9TRE4Sj5SZeyEWhyyCqTFw63"

                        "https://ipfs.io/ipfs/QmT9HM77wfod92eXeSbKkVXJiVKaWmSdaSUpkJmE6GozuB"
                        "https://ipfs.io/ipfs/QmQhCbuWKALbakWFtf2cNJCzwbXiB8PxuSNf9sv8CC5BMa"
                        "https://ipfs.io/ipfs/QmeKFGGsgsnMpYFifdc61pvgNyEQnrVX7QDgZHtgpDBA85"
                        "Link for Movie Collectable Here"
                    ]
                )
                (primary-uri-lst:[object{DpdcUdc.URI|Data}]
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.URI|Data}] idx:integer)
                            (ref-U|LST::UC_AppL acc 
                                (ref-DPDC-UDC::UDC_URI|Data (at idx image-links) b b b b b b)
                            )
                        )
                        []
                        (enumerate 0 33)
                    )
                )
                (native-nonce-data:[object{DpdcUdc.DPDC|NonceData}]
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.DPDC|NonceData}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                (ref-DPDC-UDC::UDC_NonceData
                                    (at idx r)
                                    (at idx i-r)
                                    (at idx names)
                                    (at idx descriptions)
                                    md
                                    i-asset-type
                                    (at idx primary-uri-lst)
                                    zd
                                    zd
                                )
                            )
                        )
                        []
                        (enumerate 0 33)
                    )
                )
            )
            [
                ;;1]Create Nonce [1 2 3 4 5 6 7 8 9 10 11 12 12 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30]
                (ref-TS02-C1::DPSF|C_Create
                    patron dhwc-id
                    (fold (+) [] [(make-list 10 1000) (make-list 10 500) (make-list 10 200)])
                    (drop -4 native-nonce-data)
                )
                ;;2]Define the Bronze, Silver, Golden and Movie Sets
                (ref-TS02-C1::DPSF|C_DefinePrimordialSet
                    patron dhwc-id (at 30 names) 1.0
                    [
                        (N [1])
                        (N [2])
                        (N [3])
                        (N [4])
                        (N [5])
                        (N [6])
                        (N [7])
                        (N [8])
                        (N [9])
                        (N [10])
                    ]
                    (at 30 native-nonce-data)
                )
                (ref-TS02-C1::DPSF|C_DefinePrimordialSet
                    patron dhwc-id (at 31 names) 1.0
                    [
                        (N [11])
                        (N [12])
                        (N [13])
                        (N [14])
                        (N [15])
                        (N [16])
                        (N [17])
                        (N [18])
                        (N [19])
                        (N [20])
                    ]
                    (at 31 native-nonce-data)
                )
                (ref-TS02-C1::DPSF|C_DefinePrimordialSet
                    patron dhwc-id (at 32 names) 1.0
                    [
                        (N [21])
                        (N [22])
                        (N [23])
                        (N [24])
                        (N [25])
                        (N [26])
                        (N [27])
                        (N [28])
                        (N [29])
                        (N [30])
                    ]
                    (at 32 native-nonce-data)
                )
                (ref-TS02-C1::DPSF|C_DefineCompositeSet
                    patron dhwc-id (at 33 names) 1.0
                    [
                        (C 1)
                        (C 2)
                        (C 3)
                    ]
                    (at 33 native-nonce-data)
                )
            ]
        )
    )
    ;;{F6}  [C]
    ;;
    ;;
    ;;
    ;;{F7}  [X]
    ;;
)