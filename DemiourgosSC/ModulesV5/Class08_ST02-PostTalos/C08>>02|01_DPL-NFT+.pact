(interface DeployerNft
    (defun A_Step00 ())
    (defun A_Step01 ())
    (defun A_Step02 (patron:string collection-owner:string collection-creator:string))
    (defun A_Step03 (patron:string collection-owner:string collection-creator:string))
    (defun A_Step04 (patron:string collection-owner:string collection-creator:string))
    (defun A_Step05 (patron:string collection-owner:string collection-creator:string))
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
            (ref-DPDC::DPDC|SetGovernor patron)
        )
    )
    (defun A_Step02 (patron:string collection-owner:string collection-creator:string)
        @doc "Issue Ouronet Custodians Collection"
        (C_OuronetCustodians patron collection-owner collection-creator)
    )
    (defun A_Step03 (patron:string collection-owner:string collection-creator:string)
        @doc "Issue VestaX.Finance Collection"
        (C_IssueVestaxFinanceElements 
            patron 
            (C_IssueVestaxFinance patron collection-owner collection-creator)
        )
    )
    (defun A_Step04 (patron:string collection-owner:string collection-creator:string)
        @doc "Issue Coding Division Collection"
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
                (dhcd-id:string
                    (ref-TS02-C1::DPSF|C_Issue
                        patron
                        collection-owner collection-creator "DemiourgosHoldingsCodingDivision" "DHCD"
                        true true true true true true true true
                    )
                )
                (r:decimal 150.0)
                (ir:decimal 50.0)
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (d1:string "Long dormant sentient AI, Snake Eye. Coded by a mad developer back in the 80s. Awakened by DemiourgosHoldings. With the help of our Coding Division it searches for his creator.")
                (d2:string "Of Japanese origin, Rudis was forced by the Yakuza to leave his homeland. His ancestors were traced back to the 47 Ronin riot on the 14th of December 1702. Abounty is placed on his head for \"bad genetics\". He found shelter at our Coding Division. Works remote.")
                (d3:string "After the great nuclear war between East and West, Gwen was forced to leave her homeland. She comes from the East and met her love in the West. Together they trz to prove that East and West can love each other. She joined our Coding Division shortly after her runaway in Europe.")
                (d4:string "Born in the USA, Clutter migrated to Europe where he met Gwen - an Asian runaway. They fell in love and the rest is history, at least that is what they believe. Together they are the heart and soul of our team at Demiourgos Holdings.")
                (d5:string "She is the most respected and feared hacker of her time. Born in Romania, she hacked her billionaire husband's accounts and build a submarine secret refuge for all the hackers in the world. Some say her refuge is at the Arctic or the North Pole, others in the nuclear seas of the East. Most of us believe she remains close to her home. Bangai offers council to Coding Division from time to time.")
                (d6:string "Binos grew up as a poor kid in West Africa. From childhood, he studied coding, and finally it paid off in his mid-20s after the Great War between East and West. Africa became the strongest continent on Earth and Binos became a leader in his community. He joined Demiourgos Coding Division as a high esteemed and skilled visionary in coding.")
                (d7:string "Born and raised in Paris, she loved poetry and arts since childhood. Her father, a team lead programmer at CERN European Organization of Nuclear Research, forced her to follow her steps as a programmer. Rubia turned into a punk rebel queen and spent most of her time in the suburbs of Paris doing riots against the system. Rubia Hacked the CERN whole system and joined Bangai as sister-in-love. Her father was imprisoned for treason.")
                (d8:string "He is the mastermind behind the Coding Division. As nobody knows his true identity, most of us believe Ocultus managed to clone himself by awakening and using Snake Eye. Archive footage of strange occult rituals between androids and humans leaked to the press. He is one of the most wanted coders between friends and foes.")                
                (d9:string "At age 17 she saved London from the great ocean flood that came during the War between East and West by using a code to align electronical devices and hardware memory. After the government stole her work, she was recruited by Ocultus for a greater cause.")
                (d10:string "In his youth, Binar developed the Elrond Blockchain. Nobody knows exactly his whereabouts and most forgot his name. During The Great War, people priorities their lives over the development of new technologies. Binar helped fund the war efforts of the West against the East. Today he is rarely seen in public. About once a year he visits our Coding Division. He brings lots of champagne.")
                (type:object{DpdcUdc.URI|Type} (ref-DPDC-UDC::UDC_URI|Type false false true false false false false))
                ;;
                (ext:string ".mp4")
                (l1:string "https://crimson-giant-bobcat-181.mypinata.cloud/ipfs/QmXSBRXv3Uj2nZ8fUcnHEioDTiwCkxAQz96BZvcLhFTVyk/")
                (l2:string "https://ipfs.io/ipfs/QmXSBRXv3Uj2nZ8fUcnHEioDTiwCkxAQz96BZvcLhFTVyk/")
                (ltf:[string] ["1" "2" "3" "4" "5" "6" "7" "8" "9" "10"])
                (b:string BAR)
                (zd:object{DpdcUdc.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
                ;;
                (set-name:string "CodingDivisionSet")
                (set-link:string "Coding Division Set Image Link here.")
                (sd:string "Full Coding Division Complement, working Day and Night for Demiourgos Holdings")
            )
            (ref-TS02-C1::DPSF|C_Create
                patron dhcd-id (make-list 10 500)
                [
                    (ref-DPDC-UDC::UDC_NonceData r ir "Snake Eye" d1 md type
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l1 (at 0 ltf) ext]) b b b b)
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l2 (at 0 ltf) ext]) b b b b) zd
                    )
                    (ref-DPDC-UDC::UDC_NonceData r ir "Rudis" d2 md type
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l1 (at 1 ltf) ext]) b b b b)
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l2 (at 1 ltf) ext]) b b b b) zd
                    )
                    (ref-DPDC-UDC::UDC_NonceData r ir "Gwen" d3 md type
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l1 (at 2 ltf) ext]) b b b b)
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l2 (at 2 ltf) ext]) b b b b) zd
                    )
                    (ref-DPDC-UDC::UDC_NonceData r ir "Clutter" d4 md type
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l1 (at 3 ltf) ext]) b b b b)
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l2 (at 3 ltf) ext]) b b b b) zd
                    )
                    (ref-DPDC-UDC::UDC_NonceData r ir "Bangai" d5 md type
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l1 (at 4 ltf) ext]) b b b b)
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l2 (at 4 ltf) ext]) b b b b) zd
                    )
                    (ref-DPDC-UDC::UDC_NonceData r ir "Binos" d6 md type
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l1 (at 5 ltf) ext]) b b b b)
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l2 (at 5 ltf) ext]) b b b b) zd
                    )
                    (ref-DPDC-UDC::UDC_NonceData r ir "Rubia" d7 md type
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l1 (at 6 ltf) ext]) b b b b)
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l2 (at 6 ltf) ext]) b b b b) zd
                    )
                    (ref-DPDC-UDC::UDC_NonceData r ir "Ocultus" d8 md type
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l1 (at 7 ltf) ext]) b b b b)
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l2 (at 7 ltf) ext]) b b b b) zd
                    )
                    (ref-DPDC-UDC::UDC_NonceData r ir "Oretta" d9 md type
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l1 (at 8 ltf) ext]) b b b b)
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l2 (at 8 ltf) ext]) b b b b) zd
                    )
                    (ref-DPDC-UDC::UDC_NonceData r ir "Binar" d10 md type
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l1 (at 9 ltf) ext]) b b b b)
                        (ref-DPDC-UDC::UDC_URI|Data b b (fold (+) "" [l2 (at 9 ltf) ext]) b b b b) zd
                    )
                ]
            )
            (ref-TS02-C1::DPSF|C_DefinePrimordialSet
                patron dhcd-id set-name 1.0
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
                (ref-DPDC-UDC::UDC_NonceData
                    100.0
                    400.0
                    set-name
                    sd
                    md
                    (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                    (ref-DPDC-UDC::UDC_URI|Data set-link b b b b b b)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                )
            )
        )
    )
    (defun A_Step05 (patron:string collection-owner:string collection-creator:string)
        @doc "Issue Wonder Coach Collection"
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
                (b:string BAR)
                (dhwc-id:string
                    (ref-TS02-C1::DPSF|C_Issue
                        patron
                        collection-owner collection-creator "DemiourgosHoldingsWonderCoach" "DHWC"
                        true true true true true true true true
                    )
                )
                ;;
                (r-b:decimal 100.0)
                (ir-b:decimal 10.0)
                (r-s:decimal 90.0)
                (ir-s:decimal 20.0)
                (r-g:decimal 80.0)
                (ir-g:decimal 50.0)
                ;;
                (r-bf:decimal 70.0)
                (ir-bf:decimal 95.0)
                (r-sf:decimal 60.0)
                (ir-sf:decimal 180.0)
                (r-gf:decimal 50.0)
                (ir-gf:decimal 425.0)
                ;;
                (r-full:decimal 40.0)
                (ir-full:decimal 560.0)
                ;;
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (d1:string "Sleeping Beauty")
                (d2:string "Sleeping Beauty")
                (d3:string "Sleeping Beauty")
                (d4:string "Sleeping Beauty")
                (d5:string "Sleeping Beauty")
                (d6:string "Sleeping Beauty")
                (d7:string "Sleeping Beauty")
                (d8:string "Sleeping Beauty")
                (d9:string "Sleeping Beauty")
                (d10:string "Sleeping Beauty")
                (d11:string "Sleeping Beauty")
                (d12:string "Sleeping Beauty")
                (d13:string "Sleeping Beauty")
                (d14:string "Sleeping Beauty")
                (d15:string "Sleeping Beauty")
                (d16:string "Sleeping Beauty")
                (d17:string "Sleeping Beauty")
                (d18:string "Sleeping Beauty")
                (d19:string "Sleeping Beauty")
                (d20:string "Sleeping Beauty")
                (d21:string "Sleeping Beauty")
                (d22:string "Sleeping Beauty")
                (d23:string "Sleeping Beauty")
                (d24:string "Sleeping Beauty")
                (d25:string "Sleeping Beauty")
                (d26:string "Sleeping Beauty")
                (d27:string "Sleeping Beauty")
                (d28:string "Sleeping Beauty")
                (d29:string "Sleeping Beauty")
                (d30:string "Sleeping Beauty")
                ;;
                (type:object{DpdcUdc.URI|Type} (ref-DPDC-UDC::UDC_URI|Type true false false false false false false))
                (b1:string "https://ipfs.io/ipfs/QmdNyUynFZEs3Qtw4UZR6UFabg9AvsTdTzb1D66XHAwsGy")
                (b2:string "https://ipfs.io/ipfs/QmaBitPm9zDtZigmjUwNv29CuX3breQCxAUtx5CpmdA2Re")
                (b3:string "https://ipfs.io/ipfs/QmeEf95o2CxTuxdbAWYZkDSqhLHLNaKDr15gfdMrEQ8iPt")
                (b4:string "https://ipfs.io/ipfs/QmavUDhJ9pi9UzE783ft24Ti2smEBZWkig2GjhxZhExeXz")
                (b5:string "https://ipfs.io/ipfs/QmbP4DTsAkcUnrYp9PU7Gie7idtbxvvkXqiwnVNmZKyudT")
                (b6:string "https://ipfs.io/ipfs/QmezgN8EJfP4DAxuUMFXkjYVsLusyWZkJmfWyMFCr5eoj6")
                (b7:string "https://ipfs.io/ipfs/QmZNLenWkaRJRobobb6mPFRCWww3YF26Qi9FD3tULehWMk")
                (b8:string "https://ipfs.io/ipfs/QmRNrj76DUhsXyzYoWtEL3upY7FBpTLiqBpKfjpuJ9wux6")
                (b9:string "https://ipfs.io/ipfs/QmdJp8RTzgQ3ikjJu6XP1UDHtXfUB9HRw4DyoPWH2uoFQu")
                (b10:string "https://ipfs.io/ipfs/QmcH3NvyhtKuGjja7wTBF3Jy4yEU684ibD3QMZDk6QQh1r")
                (s1:string "https://ipfs.io/ipfs/QmTihLCsqxqakVmqYnkMoeVhknFQCQ2nmRA6UjwdLrCHWJ")
                (s2:string "https://ipfs.io/ipfs/QmWJ73VJ8FthkXF8xdvbhfFY26T8BEZyKqUV7A4JNzwFhy")
                (s3:string "https://ipfs.io/ipfs/QmcbPCpCL7mJZ7WXKqaYBBzZW53QEGZTSPUY8cXdquyXug")
                (s4:string "https://ipfs.io/ipfs/QmZeEFsG96SsVZm9Ka3vXu4zx99T2ryxtYo9HLH6EEiqiy")
                (s5:string "https://ipfs.io/ipfs/QmeoLjGL1FifK2QmjA72jkdTXGaLzJieWNYaWQC4uaVSP2")
                (s6:string "https://ipfs.io/ipfs/QmYDZJkMCeCo2PU5ByLGmVhNAdX2N4oEpjveJdQpzBdsrb")
                (s7:string "https://ipfs.io/ipfs/QmZ4ppMuYoNMEbroytgMhozxJSPJT94JfK4pmogzH1oi4t")
                (s8:string "https://ipfs.io/ipfs/QmS6hzw2sr3cr9rZQC86f9yU7jy3uVqCbZQXzA2utbcyYK")
                (s9:string "https://ipfs.io/ipfs/QmV64EEbEiP9YNGXpdExX8hxUjHXcS7wTdGaZjiMUWinQH")
                (s10:string "https://ipfs.io/ipfs/QmcKq3aRpvgksHFVT2gPvpgVqJRK1xskoumsjUco7K2187")
                (g1:string "https://ipfs.io/ipfs/QmS7SP1BK53pxRxwff8yYc2AaXC9NCpPa2QFk5tWomXwqt")
                (g2:string "https://ipfs.io/ipfs/QmQU14hEPnooFQcWfVfhBKy69jCpW3wZ3F6Dgeocxsd81G")
                (g3:string "https://ipfs.io/ipfs/QmSVnL8CTd4a7zYHeptj5dH6MXtfxz1o5gPqL2k8qk9Uzf")
                (g4:string "https://ipfs.io/ipfs/QmbVcTCgswd9v8HixeUru6tbXkq8GLKQ6FXF5N21etbG6C")
                (g5:string "https://ipfs.io/ipfs/QmTZT1LCw6yb8qxNr6twHLLFuReYspseb99DftaiEkzaJR")
                (g6:string "https://ipfs.io/ipfs/QmZCoG2TY7Hi3c3CzL4Dvz7bvVPCAnSCuehZx1e9Jh1zCJ")
                (g7:string "https://ipfs.io/ipfs/QmcPnMURPCdk8qpEXc3q6V7UUqAPmDHVbFMRYTZheeuNDs")
                (g8:string "https://ipfs.io/ipfs/QmPMNgtXCd9Pe9Qsnen9Tg2koLKXKriMAgMd9rAeHk6V77")
                (g9:string "https://ipfs.io/ipfs/QmQWWhJ4T8sfwTYFAz5evz3ZX6mxof9KgDxBb7EHyirG1f")
                (g10:string "https://ipfs.io/ipfs/QmQBByq28rgrce5UNxmJpP9TRE4Sj5SZeyEWhyyCqTFw63")
                ;;
                (bf:string "https://ipfs.io/ipfs/QmT9HM77wfod92eXeSbKkVXJiVKaWmSdaSUpkJmE6GozuB")
                (sf:string "https://ipfs.io/ipfs/QmQhCbuWKALbakWFtf2cNJCzwbXiB8PxuSNf9sv8CC5BMa")
                (gf:string "https://ipfs.io/ipfs/QmeKFGGsgsnMpYFifdc61pvgNyEQnrVX7QDgZHtgpDBA85")
                (ff:string "Link for Movie Collectable Here")
                ;;
                (zd:object{DpdcUdc.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
            )
            [
                (ref-TS02-C1::DPSF|C_Create
                    patron dhwc-id
                    (fold (+) [] [(make-list 10 1000) (make-list 10 500) (make-list 10 200)])
                    [
                        (ref-DPDC-UDC::UDC_NonceData r-b ir-b "Wonder Coach Bronze Frame #1" d1 md type
                            (ref-DPDC-UDC::UDC_URI|Data b1 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-b ir-b "Wonder Coach Bronze Frame #2" d2 md type
                            (ref-DPDC-UDC::UDC_URI|Data b2 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-b ir-b "Wonder Coach Bronze Frame #3" d3 md type
                            (ref-DPDC-UDC::UDC_URI|Data b3 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-b ir-b "Wonder Coach Bronze Frame #4" d4 md type
                            (ref-DPDC-UDC::UDC_URI|Data b4 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-b ir-b "Wonder Coach Bronze Frame #5" d5 md type
                            (ref-DPDC-UDC::UDC_URI|Data b6 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-b ir-b "Wonder Coach Bronze Frame #6" d6 md type
                            (ref-DPDC-UDC::UDC_URI|Data b6 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-b ir-b "Wonder Coach Bronze Frame #7" d7 md type
                            (ref-DPDC-UDC::UDC_URI|Data b7 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-b ir-b "Wonder Coach Bronze Frame #8" d8 md type
                            (ref-DPDC-UDC::UDC_URI|Data b8 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-b ir-b "Wonder Coach Bronze Frame #9" d9 md type
                            (ref-DPDC-UDC::UDC_URI|Data b9 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-b ir-b "Wonder Coach Bronze Frame #10" d10 md type
                            (ref-DPDC-UDC::UDC_URI|Data b10 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-s ir-s "Wonder Coach Silver Frame #1" d11 md type
                            (ref-DPDC-UDC::UDC_URI|Data s1 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-s ir-s "Wonder Coach Silver Frame #2" d12 md type
                            (ref-DPDC-UDC::UDC_URI|Data s2 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-s ir-s "Wonder Coach Silver Frame #3" d13 md type
                            (ref-DPDC-UDC::UDC_URI|Data s3 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-s ir-s "Wonder Coach Silver Frame #4" d14 md type
                            (ref-DPDC-UDC::UDC_URI|Data s4 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-s ir-s "Wonder Coach Silver Frame #5" d15 md type
                            (ref-DPDC-UDC::UDC_URI|Data s5 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-s ir-s "Wonder Coach Silver Frame #6" d16 md type
                            (ref-DPDC-UDC::UDC_URI|Data s6 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-s ir-s "Wonder Coach Silver Frame #7" d17 md type
                            (ref-DPDC-UDC::UDC_URI|Data s7 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-s ir-s "Wonder Coach Silver Frame #8" d18 md type
                            (ref-DPDC-UDC::UDC_URI|Data s8 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-s ir-s "Wonder Coach Silver Frame #9" d19 md type
                            (ref-DPDC-UDC::UDC_URI|Data s9 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-s ir-s "Wonder Coach Silver Frame #10" d20 md type
                            (ref-DPDC-UDC::UDC_URI|Data s10 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-g ir-g "Wonder Coach Golden Frame #1" d21 md type
                            (ref-DPDC-UDC::UDC_URI|Data g1 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-g ir-g "Wonder Coach Golden Frame #2" d22 md type
                            (ref-DPDC-UDC::UDC_URI|Data g2 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-g ir-g "Wonder Coach Golden Frame #3" d23 md type
                            (ref-DPDC-UDC::UDC_URI|Data g3 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-g ir-g "Wonder Coach Golden Frame #4" d24 md type
                            (ref-DPDC-UDC::UDC_URI|Data g4 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-g ir-g "Wonder Coach Golden Frame #5" d25 md type
                            (ref-DPDC-UDC::UDC_URI|Data g5 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-g ir-g "Wonder Coach Golden Frame #6" d26 md type
                            (ref-DPDC-UDC::UDC_URI|Data g6 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-g ir-g "Wonder Coach Golden Frame #7" d27 md type
                            (ref-DPDC-UDC::UDC_URI|Data g7 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-g ir-g "Wonder Coach Golden Frame #8" d28 md type
                            (ref-DPDC-UDC::UDC_URI|Data g8 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-g ir-g "Wonder Coach Golden Frame #9" d29 md type
                            (ref-DPDC-UDC::UDC_URI|Data g9 b b b b b b) zd zd
                        )
                        (ref-DPDC-UDC::UDC_NonceData r-g ir-g "Wonder Coach Golden Frame #10" d30 md type
                            (ref-DPDC-UDC::UDC_URI|Data g10 b b b b b b) zd zd
                        )
                    ]
                )
                (ref-TS02-C1::DPSF|C_DefinePrimordialSet
                    patron dhwc-id "Wonder Coach Bronze Chapter" 1.0
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
                    (ref-DPDC-UDC::UDC_NonceData
                        r-bf
                        ir-bf
                        "Wonder Coach Bronze Chapter"
                        "The Woander Coach Bronze Chapter represents a complete Set of all Bronze Wonder Coach Frames. 7% Royalty and 95% Ignis-Royalty relative to individual Elements"
                        md
                        (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                        (ref-DPDC-UDC::UDC_URI|Data bf b b b b b b)
                        (ref-DPDC-UDC::UDC_ZeroURI|Data)
                        (ref-DPDC-UDC::UDC_ZeroURI|Data)
                    )
                )
                (ref-TS02-C1::DPSF|C_DefinePrimordialSet
                    patron dhwc-id "Wonder Coach Silver Chapter" 1.0
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
                    (ref-DPDC-UDC::UDC_NonceData
                        r-sf
                        ir-sf
                        "Wonder Coach Silver Chapter"
                        "The Wonder Coach Silver Chapter represents a complete Set of all Silver Wonder Coach Frames. 6% Royalty and 90% Ignis-Royalty relative to individual Elements"
                        md
                        (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                        (ref-DPDC-UDC::UDC_URI|Data sf b b b b b b)
                        (ref-DPDC-UDC::UDC_ZeroURI|Data)
                        (ref-DPDC-UDC::UDC_ZeroURI|Data)
                    )
                )
                (ref-TS02-C1::DPSF|C_DefinePrimordialSet
                    patron dhwc-id "Wonder Coach Golden Chapter" 1.0
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
                    (ref-DPDC-UDC::UDC_NonceData
                        r-gf
                        ir-gf
                        "Wonder Coach Golden Chapter"
                        "The Wonder Coach Golden Chapter represents a complete Set of all Golden Wonder Coach Frames. 5% Royalty and 85% Ignis-Royalty relative to individual Elements"
                        md
                        (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                        (ref-DPDC-UDC::UDC_URI|Data sf b b b b b b)
                        (ref-DPDC-UDC::UDC_ZeroURI|Data)
                        (ref-DPDC-UDC::UDC_ZeroURI|Data)
                    )
                )
                (ref-TS02-C1::DPSF|C_DefineCompositeSet
                    patron dhwc-id "Wonder Coach Movie Collectable" 1.0
                    [
                        (C 1)
                        (C 2)
                        (C 3)
                    ]
                    (ref-DPDC-UDC::UDC_NonceData
                        r-full
                        ir-full
                        "Wonder Coach Movie Collectable"
                        "The Woander Coach Movie Collectable represents the Complete Movie Collectable Set, containing all 30 existing Frames. 4% Royalty and 80% Ignis-Royalty relative to individual Elements"
                        md
                        (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                        (ref-DPDC-UDC::UDC_URI|Data ff b b b b b b)
                        (ref-DPDC-UDC::UDC_ZeroURI|Data)
                        (ref-DPDC-UDC::UDC_ZeroURI|Data)
                    )
                )
            ]
        )
    )
    ;;{F6}  [C]
    ;;
    (defun C_OuronetCustodians (patron:string collection-owner:string collection-creator:string)
        @doc "Issues the Ouronet Custodians Collection with 3 Elements, each with Fragmentation Capabilities \
            \ Also Enables Fragmentation for Each Nonce"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
                (dhoc:string (C_IssueOuronetCustodians patron collection-owner collection-creator))
                ;;
                (r:[decimal] [40.0 30.0 20.0])
                (i:[decimal] [10.0 2.0 0.4])
                (names:[string]
                    [
                        "Ouronet Golden Star Fragments"
                        "Ouronet Silver Star Fragments"
                        "Ouronet Bronze Star Fragments"
                    ]
                )
                (descriptions:[string]
                    [
                        "Golden Ouronet Fragment: 1/1000th of a Golden Custodian SFT, representing 1/100,000th of one-third of Ouronet’s Financial Ownership. Perfect for affordable investment in the Ouronet Virtual Blockchain."
                        "Silver Ouronet Fragment: 1/1000th of a Silver Custodian SFT, representing 1/1,000,000th of one-third of Ouronet’s Financial Ownership. Ideal for accessible investment in the Ouronet Virtual Blockchain."
                        "Bronze Ouronet Fragment: 1/1000th of a Bronze Custodian SFT, representing 1/10,000,000th of one-third of Ouronet’s Financial Ownership. Good cost-effective investment in the Ouronet Virtual Blockchain."
                    ]
                )
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (asset-type:object{DpdcUdc.URI|Type}
                    (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                )
                (image-links:[string]
                    [
                        "https://gateway.pinata.cloud/ipfs/QmUemLvfaJqKGMeXkxbinCQhNBKnRFMMn9fFnSF6FJ3FoP/1s.png"
                        "https://gateway.pinata.cloud/ipfs/QmUemLvfaJqKGMeXkxbinCQhNBKnRFMMn9fFnSF6FJ3FoP/2s.png"
                        "https://gateway.pinata.cloud/ipfs/QmUemLvfaJqKGMeXkxbinCQhNBKnRFMMn9fFnSF6FJ3FoP/3s.png"
                    ]
                )
                (b:string BAR)
                (primary-uri-lst:[object{DpdcUdc.URI|Data}]
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.URI|Data}] idx:integer)
                            (ref-U|LST::UC_AppL acc 
                                (ref-DPDC-UDC::UDC_URI|Data (at idx image-links) b b b b b b)
                            )
                        )
                        []
                        (enumerate 0 (- (length r) 1))
                    )
                )
                (st-uri:object{DpdcUdc.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
                (fragmentation-data:[object{DpdcUdc.DPDC|NonceData}]
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.DPDC|NonceData}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                (ref-DPDC-UDC::UDC_NonceData
                                    (at idx r)
                                    (at idx i)
                                    (at idx names)
                                    (at idx descriptions)
                                    md
                                    asset-type
                                    (at idx primary-uri-lst)
                                    st-uri
                                    st-uri
                                )
                            )
                        )
                        []
                        (enumerate 0 (- (length r) 1))
                    )
                )
            )
            [
                (C_IssueOuronetCustodiansElements patron dhoc)
                (ref-TS02-C1::DPSF|C_EnableNonceFragmentation patron dhoc 1 (at 0 fragmentation-data))
                (ref-TS02-C1::DPSF|C_EnableNonceFragmentation patron dhoc 2 (at 1 fragmentation-data))
                (ref-TS02-C1::DPSF|C_EnableNonceFragmentation patron dhoc 3 (at 2 fragmentation-data))
            ]
        )
    )
    (defun C_IssueOuronetCustodians:string (patron:string collection-owner:string collection-creator:string)
        @doc "Issues the Ouronet Custodians DPSF Collection"
        (let
            (
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
            )
            (ref-TS02-C1::DPSF|C_Issue
                patron
                collection-owner collection-creator "DemiourgosHoldingsOuronetCustodians" "DHOC"
                true true true true
                true true true true
            )
        )
    )
    (defun C_IssueOuronetCustodiansElements:string (patron:string dhoc-id:string)
        @doc "Issues 3 SFTs in the Collection, with 100 1000 and 10000 Units"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
                ;;
                (r:[decimal] [70.0 60.0 50.0])
                (i:[decimal] [5000.0 500.0 50.0])
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
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (asset-type:object{DpdcUdc.URI|Type}
                    (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                )
                (image-links:[string]
                    [
                        "https://gateway.pinata.cloud/ipfs/QmUemLvfaJqKGMeXkxbinCQhNBKnRFMMn9fFnSF6FJ3FoP/1f.png"
                        "https://gateway.pinata.cloud/ipfs/QmUemLvfaJqKGMeXkxbinCQhNBKnRFMMn9fFnSF6FJ3FoP/2f.png"
                        "https://gateway.pinata.cloud/ipfs/QmUemLvfaJqKGMeXkxbinCQhNBKnRFMMn9fFnSF6FJ3FoP/3f.png"
                    ]
                )
                (b:string BAR)
                (primary-uri-lst:[object{DpdcUdc.URI|Data}]
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.URI|Data}] idx:integer)
                            (ref-U|LST::UC_AppL acc 
                                (ref-DPDC-UDC::UDC_URI|Data (at idx image-links) b b b b b b)
                            )
                        )
                        []
                        (enumerate 0 (- (length r) 1))
                    )
                )
                (st-uri:object{DpdcUdc.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
            )
            (ref-TS02-C1::DPSF|C_Create
                patron dhoc-id [100 1000 10000]
                (fold
                    (lambda
                        (acc:[object{DpdcUdc.DPDC|NonceData}] idx:integer)
                        (ref-U|LST::UC_AppL acc
                            (ref-DPDC-UDC::UDC_NonceData
                                (at idx r)
                                (at idx i)
                                (at idx names)
                                (at idx descriptions)
                                md
                                asset-type
                                (at idx primary-uri-lst)
                                st-uri
                                st-uri
                            )
                        )
                    )
                    []
                    (enumerate 0 (- (length r) 1))
                )
            )
        )
    )
    ;;
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
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
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
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (asset-type:object{DpdcUdc.URI|Type}
                    (ref-DPDC-UDC::UDC_URI|Type false false true false false false false)
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
                (b:string BAR)
                (primary-uri-lst:[object{DpdcUdc.URI|Data}]
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.URI|Data}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                (ref-DPDC-UDC::UDC_URI|Data b b (at idx l1) b b b b)
                            )
                        )
                        []
                        (enumerate 0 (- (length i) 1))
                    )
                )
                (secondary-uri-lst:[object{DpdcUdc.URI|Data}]
                    (fold
                        (lambda
                            (acc:[object{DpdcUdc.URI|Data}] idx:integer)
                            (ref-U|LST::UC_AppL acc
                                (ref-DPDC-UDC::UDC_URI|Data b b (at idx l2) b b b b)
                            )
                        )
                        []
                        (enumerate 0 (- (length i) 1))
                    )
                )
                (tertiary-uri:object{DpdcUdc.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
            )
            (ref-TS02-C1::DPSF|C_Create
                patron dhvx-id [1000 2000 4000]
                (fold
                    (lambda
                        (acc:[object{DpdcUdc.DPDC|NonceData}] idx:integer)
                        (ref-U|LST::UC_AppL acc
                            (ref-DPDC-UDC::UDC_NonceData
                                r
                                (at idx i)
                                (at idx names)
                                (at idx descriptions)
                                md asset-type
                                (at idx primary-uri-lst)
                                (at idx secondary-uri-lst)
                                tertiary-uri
                            )
                        )
                    )
                    []
                    (enumerate 0 (- (length i) 1))
                )
            )
        )
    )
    ;;
    ;;{F7}  [X]
    ;;
)