(module BLOODSHED-SETS GOV
    ;;
    (implements BsSets)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_BLOODSHED-SETS         (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|BLOODSHED-SETS_ADMIN)))
    (defcap GOV|BLOODSHED-SETS_ADMIN ()     (enforce-guard GOV|MD_BLOODSHED-SETS))
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
    ;;
    ;;
    (defconst R                     Bloodshed.R)            ;;Native Bloodshed Royalty
    (defconst IR-L                  Bloodshed.IR-L)         ;;Legendary Ignis Royalty
    (defconst IR-E                  Bloodshed.IR-E)         ;;Epic Ignis Royalty
    (defconst IR-R                  Bloodshed.IR-R)         ;;Rare Ignis Royalty
    (defconst IR-C                  Bloodshed.IR-C)         ;;Common Ignis Royalty
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
    (defun N:object{DpdcUdc.DPDC|AllowedNonceForSetPosition} (lst:[integer])
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
            )
            (ref-DPDC-UDC::N lst)
        )
    )
    (defun C:object{DpdcUdc.DPDC|AllowedClassForSetPosition} (input:integer)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
            )
            (ref-DPDC-UDC::C input)
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun A01_TierOneCommonComati (patron:string dhb:string)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
                (r:decimal (* 0.9 R))
                (ir:decimal (fold (*) 1.0 [18.0 0.9 IR-C]))
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (b:string BAR)
                (s:string "IPFS T1 Comati Photo Link")
            )
            ;;Set Class 1
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Common Comati" 1.1
                [
                    (N (enumerate 4865 12928 144))
                    (N (enumerate 4866 12928 144))
                    (N (enumerate 4867 12928 144))
                    (N (enumerate 4868 12928 144))
                    (N (enumerate 4869 12928 144))
                    (N (enumerate 4870 12928 144))
                    (N (enumerate 4871 12928 144))
                    (N (enumerate 4872 12928 144))
                    (N (enumerate 4873 12928 144))
                    (N (enumerate 4874 12928 144))
                    (N (enumerate 4875 12928 144))
                    (N (enumerate 4876 12928 144))
                    (N (enumerate 4877 12928 144))
                    (N (enumerate 4878 12928 144))
                    (N (enumerate 4879 12928 144))
                    (N (enumerate 4880 12928 144))
                    (N (enumerate 4881 12928 144))
                    (N (enumerate 4882 12928 144))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Common Comati"
                    "All Common Comati Dacians in a Set. 13.5% (90% of Native Bloodshed Royalty) Royalty and 90% Ignis-Royalty relative to individual Elements"
                    md
                    (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                    (ref-DPDC-UDC::UDC_URI|Data s b b b b b b)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                )
            )
        )
    )
    (defun A02_TierOneCommonUrsoi (patron:string dhb:string)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
                (r:decimal (* 0.9 R))
                (ir:decimal (fold (*) 1.0 [18.0 0.9 IR-C]))
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (b:string BAR)
                (s:string "IPFS T1 Ursoi Photo Link")
            )
            ;;Set Class 2
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Common Ursoi" 1.1
                [
                    (N (enumerate 4883 12928 144))
                    (N (enumerate 4884 12928 144))
                    (N (enumerate 4885 12928 144))
                    (N (enumerate 4886 12928 144))
                    (N (enumerate 4887 12928 144))
                    (N (enumerate 4888 12928 144))
                    (N (enumerate 4889 12928 144))
                    (N (enumerate 4890 12928 144))
                    (N (enumerate 4891 12928 144))
                    (N (enumerate 4892 12928 144))
                    (N (enumerate 4893 12928 144))
                    (N (enumerate 4894 12928 144))
                    (N (enumerate 4895 12928 144))
                    (N (enumerate 4896 12928 144))
                    (N (enumerate 4897 12928 144))
                    (N (enumerate 4898 12928 144))
                    (N (enumerate 4899 12928 144))
                    (N (enumerate 4900 12928 144))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Common Ursoi"
                    "All Common Ursoi Dacians in a Set. 13.5% (90% of Native Bloodshed Royalty) Royalty and 90% Ignis-Royalty relative to individual Elements"
                    md
                    (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                    (ref-DPDC-UDC::UDC_URI|Data s b b b b b b)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                )
            )
        )
    )
    (defun A03_TierOneCommonPileati (patron:string dhb:string)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
                (r:decimal (* 0.9 R))
                (ir:decimal (fold (*) 1.0 [18.0 0.9 IR-C]))
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (b:string BAR)
                (s:string "IPFS T1 Pileati Photo Link")
            )
            ;;Set Class 3
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Common Pileati" 1.1
                [
                    (N (enumerate 4901 12928 144))
                    (N (enumerate 4902 12928 144))
                    (N (enumerate 4903 12928 144))
                    (N (enumerate 4904 12928 144))
                    (N (enumerate 4905 12928 144))
                    (N (enumerate 4906 12928 144))
                    (N (enumerate 4907 12928 144))
                    (N (enumerate 4908 12928 144))
                    (N (enumerate 4909 12928 144))
                    (N (enumerate 4910 12928 144))
                    (N (enumerate 4911 12928 144))
                    (N (enumerate 4912 12928 144))
                    (N (enumerate 4913 12928 144))
                    (N (enumerate 4914 12928 144))
                    (N (enumerate 4915 12928 144))
                    (N (enumerate 4916 12928 144))
                    (N (enumerate 4917 12928 144))
                    (N (enumerate 4918 12928 144))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Common Pileati"
                    "All Common Pileati Dacians in a Set. 13.5% (90% of Native Bloodshed Royalty) Royalty and 90% Ignis-Royalty relative to individual Elements"
                    md
                    (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                    (ref-DPDC-UDC::UDC_URI|Data s b b b b b b)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                )
            )
        )
    )
    (defun A04_TierOneCommonSmardoi (patron:string dhb:string)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
                (r:decimal (* 0.9 R))
                (ir:decimal (fold (*) 1.0 [18.0 0.9 IR-C]))
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (b:string BAR)
                (s:string "IPFS T1 Smardoi Photo Link")
            )
            ;;Set Class 4
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Common Smardoi" 1.1
                [
                    (N (enumerate 4919 12928 144))
                    (N (enumerate 4920 12928 144))
                    (N (enumerate 4921 12928 144))
                    (N (enumerate 4922 12928 144))
                    (N (enumerate 4923 12928 144))
                    (N (enumerate 4924 12928 144))
                    (N (enumerate 4925 12928 144))
                    (N (enumerate 4926 12928 144))
                    (N (enumerate 4927 12928 144))
                    (N (enumerate 4928 12928 144))
                    (N (enumerate 4929 12928 144))
                    (N (enumerate 4930 12928 144))
                    (N (enumerate 4931 12928 144))
                    (N (enumerate 4932 12928 144))
                    (N (enumerate 4933 12928 144))
                    (N (enumerate 4934 12928 144))
                    (N (enumerate 4935 12928 144))
                    (N (enumerate 4936 12928 144))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Common Smardoi"
                    "All Common Smardoi Dacians in a Set. 13.5% (90% of Native Bloodshed Royalty) Royalty and 90% Ignis-Royalty relative to individual Elements"
                    md
                    (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                    (ref-DPDC-UDC::UDC_URI|Data s b b b b b b)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                )
            )
        )
    )
    (defun A05_TierOneCommonCarpian (patron:string dhb:string)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
                (r:decimal (* 0.9 R))
                (ir:decimal (fold (*) 1.0 [18.0 0.9 IR-C]))
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (b:string BAR)
                (s:string "IPFS T1 Carpian Photo Link")
            )
            ;;Set Class 5
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Common Carpian" 1.1
                [
                    (N (enumerate 4937 12928 144))
                    (N (enumerate 4938 12928 144))
                    (N (enumerate 4939 12928 144))
                    (N (enumerate 4940 12928 144))
                    (N (enumerate 4941 12928 144))
                    (N (enumerate 4942 12928 144))
                    (N (enumerate 4943 12928 144))
                    (N (enumerate 4944 12928 144))
                    (N (enumerate 4945 12928 144))
                    (N (enumerate 4946 12928 144))
                    (N (enumerate 4947 12928 144))
                    (N (enumerate 4948 12928 144))
                    (N (enumerate 4949 12928 144))
                    (N (enumerate 4950 12928 144))
                    (N (enumerate 4951 12928 144))
                    (N (enumerate 4952 12928 144))
                    (N (enumerate 4953 12928 144))
                    (N (enumerate 4954 12928 144))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Common Carpian"
                    "All Common Carpian Dacians in a Set. 13.5% (90% of Native Bloodshed Royalty) Royalty and 90% Ignis-Royalty relative to individual Elements"
                    md
                    (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                    (ref-DPDC-UDC::UDC_URI|Data s b b b b b b)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                )
            )
        )
    )
    (defun A06_TierOneCommonTarabostes (patron:string dhb:string)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
                (r:decimal (* 0.9 R))
                (ir:decimal (fold (*) 1.0 [18.0 0.9 IR-C]))
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (b:string BAR)
                (s:string "IPFS T1 Tarabostes Photo Link")
            )
            ;;Set Class 6
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Common Tarabostes" 1.1
                [
                    (N (enumerate 4955 12928 144))
                    (N (enumerate 4956 12928 144))
                    (N (enumerate 4957 12928 144))
                    (N (enumerate 4958 12928 144))
                    (N (enumerate 4959 12928 144))
                    (N (enumerate 4960 12928 144))
                    (N (enumerate 4961 12928 144))
                    (N (enumerate 4962 12928 144))
                    (N (enumerate 4963 12928 144))
                    (N (enumerate 4964 12928 144))
                    (N (enumerate 4965 12928 144))
                    (N (enumerate 4966 12928 144))
                    (N (enumerate 4967 12928 144))
                    (N (enumerate 4968 12928 144))
                    (N (enumerate 4969 12928 144))
                    (N (enumerate 4970 12928 144))
                    (N (enumerate 4971 12928 144))
                    (N (enumerate 4972 12928 144))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Common Tarabostes"
                    "All Common Tarabostes Dacians in a Set. 13.5% (90% of Native Bloodshed Royalty) Royalty and 90% Ignis-Royalty relative to individual Elements"
                    md
                    (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                    (ref-DPDC-UDC::UDC_URI|Data s b b b b b b)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                )
            )
        )
    )
    (defun A07_TierOneCommonCostoboc (patron:string dhb:string)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
                (r:decimal (* 0.9 R))
                (ir:decimal (fold (*) 1.0 [18.0 0.9 IR-C]))
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (b:string BAR)
                (s:string "IPFS T1 Costoboc Photo Link")
            )
            ;;Set Class 7
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Common Costoboc" 1.1
                [
                    (N (enumerate 4973 12928 144))
                    (N (enumerate 4974 12928 144))
                    (N (enumerate 4975 12928 144))
                    (N (enumerate 4976 12928 144))
                    (N (enumerate 4977 12928 144))
                    (N (enumerate 4978 12928 144))
                    (N (enumerate 4979 12928 144))
                    (N (enumerate 4980 12928 144))
                    (N (enumerate 4981 12928 144))
                    (N (enumerate 4982 12928 144))
                    (N (enumerate 4983 12928 144))
                    (N (enumerate 4984 12928 144))
                    (N (enumerate 4985 12928 144))
                    (N (enumerate 4986 12928 144))
                    (N (enumerate 4987 12928 144))
                    (N (enumerate 4988 12928 144))
                    (N (enumerate 4989 12928 144))
                    (N (enumerate 4990 12928 144))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Common Costoboc"
                    "All Common Costoboc Dacians in a Set. 13.5% (90% of Native Bloodshed Royalty) Royalty and 90% Ignis-Royalty relative to individual Elements"
                    md
                    (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                    (ref-DPDC-UDC::UDC_URI|Data s b b b b b b)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                    (ref-DPDC-UDC::UDC_ZeroURI|Data)
                )
            )
        )
    )
    (defun A08_TierOneCommonBuridavensRareComati (patron:string dhb:string)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
                (r:decimal (* 0.9 R))
                (ir:decimal (fold (*) 1.0 [18.0 0.9 IR-C]))
                ;;
                (r2:decimal (* 0.85 R))
                (ir-r:decimal (fold (*) 1.0 [9.0 0.85 IR-R]))
                ;;
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (b:string BAR)
                (s:string "IPFS T1 Buridavens Photo Link")
                (s1:string "IPFS T1 Comati Photo Link")
                ;;
                (type:object{DpdcUdc.URI|Type} (ref-DPDC-UDC::UDC_URI|Type true false false false false false false))
                (zd:object{DpdcUdc.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
            )
            ;;Set Class 8
            [(ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Common Buridavens" 1.1
                [
                    (N (enumerate 4991 12928 144))
                    (N (enumerate 4992 12928 144))
                    (N (enumerate 4993 12928 144))
                    (N (enumerate 4994 12928 144))
                    (N (enumerate 4995 12928 144))
                    (N (enumerate 4996 12928 144))
                    (N (enumerate 4997 12928 144))
                    (N (enumerate 4998 12928 144))
                    (N (enumerate 4999 12928 144))
                    (N (enumerate 5000 12928 144))
                    (N (enumerate 5001 12928 144))
                    (N (enumerate 5002 12928 144))
                    (N (enumerate 5003 12928 144))
                    (N (enumerate 5004 12928 144))
                    (N (enumerate 5005 12928 144))
                    (N (enumerate 5006 12928 144))
                    (N (enumerate 5007 12928 144))
                    (N (enumerate 5008 12928 144))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r ir
                    "Tier 1 Common Buridavens"
                    "All Common Buridavens Dacians in a Set. 13.5% (90% of Native Bloodshed Royalty) Royalty and 90% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 9
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Rare Comati" 1.1
                [
                    (N (enumerate 1697 4864 72))
                    (N (enumerate 1698 4864 72))
                    (N (enumerate 1699 4864 72))
                    (N (enumerate 1700 4864 72))
                    (N (enumerate 1701 4864 72))
                    (N (enumerate 1702 4864 72))
                    (N (enumerate 1703 4864 72))
                    (N (enumerate 1704 4864 72))
                    (N (enumerate 1705 4864 72))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r2 ir-r
                    "Tier 1 Rare Comati"
                    "All Rare Comati Dacians in a Set. 12.75% (85% of Native Bloodshed Royalty) Royalty and 85% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s1 b b b b b b)
                    zd zd
                )
            )]
        )
    )
    ;;
    (defun A09_TierOneRare (patron:string dhb:string)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
                (r:decimal (* 0.85 R))
                (ir:decimal (fold (*) 1.0 [9.0 0.85 IR-R]))
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (b:string BAR)
                (s2:string "IPFS T1 Ursoi Photo Link")
                (s3:string "IPFS T1 Pileati Photo Link")
                (s4:string "IPFS T1 Smardoi Photo Link")
                (s5:string "IPFS T1 Carpian Photo Link")
                (s6:string "IPFS T1 Tarabostes Photo Link")
                (s7:string "IPFS T1 Costoboc Photo Link")
                (s8:string "IPFS T1 Buridavens Photo Link")
                ;;
                (type:object{DpdcUdc.URI|Type} (ref-DPDC-UDC::UDC_URI|Type true false false false false false false))
                (zd:object{DpdcUdc.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
            )
            ;;Set Class 10
            [(ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Rare Ursoi" 1.1
                [
                    (N (enumerate 1706 4864 72))
                    (N (enumerate 1707 4864 72))
                    (N (enumerate 1708 4864 72))
                    (N (enumerate 1709 4864 72))
                    (N (enumerate 1710 4864 72))
                    (N (enumerate 1711 4864 72))
                    (N (enumerate 1712 4864 72))
                    (N (enumerate 1713 4864 72))
                    (N (enumerate 1714 4864 72))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Rare Ursoi"
                    "All Rare Ursoi Dacians in a Set. 12.75% (85% of Native Bloodshed Royalty) Royalty and 85% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s2 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 11
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Rare Pileati" 1.1
                [
                    (N (enumerate 1715 4864 72))
                    (N (enumerate 1716 4864 72))
                    (N (enumerate 1717 4864 72))
                    (N (enumerate 1718 4864 72))
                    (N (enumerate 1719 4864 72))
                    (N (enumerate 1720 4864 72))
                    (N (enumerate 1721 4864 72))
                    (N (enumerate 1722 4864 72))
                    (N (enumerate 1723 4864 72))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Rare Pileati"
                    "All Rare Pileati Dacians in a Set. 12.75% (85% of Native Bloodshed Royalty) Royalty and 85% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s3 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 12
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Rare Smardoi" 1.1
                [
                    (N (enumerate 1724 4864 72))
                    (N (enumerate 1725 4864 72))
                    (N (enumerate 1726 4864 72))
                    (N (enumerate 1727 4864 72))
                    (N (enumerate 1728 4864 72))
                    (N (enumerate 1729 4864 72))
                    (N (enumerate 1730 4864 72))
                    (N (enumerate 1731 4864 72))
                    (N (enumerate 1732 4864 72))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Rare Smardoi"
                    "All Rare Smardoi Dacians in a Set. 12.75% (85% of Native Bloodshed Royalty) Royalty and 85% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s4 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 13
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Rare Carpian" 1.1
                [
                    (N (enumerate 1733 4864 72))
                    (N (enumerate 1734 4864 72))
                    (N (enumerate 1735 4864 72))
                    (N (enumerate 1736 4864 72))
                    (N (enumerate 1737 4864 72))
                    (N (enumerate 1738 4864 72))
                    (N (enumerate 1739 4864 72))
                    (N (enumerate 1740 4864 72))
                    (N (enumerate 1741 4864 72))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Rare Carpian"
                    "All Rare Carpian Dacians in a Set. 12.75% (85% of Native Bloodshed Royalty) Royalty and 85% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s5 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 14
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Rare Tarabostes" 1.1
                [
                    (N (enumerate 1742 4864 72))
                    (N (enumerate 1743 4864 72))
                    (N (enumerate 1744 4864 72))
                    (N (enumerate 1745 4864 72))
                    (N (enumerate 1746 4864 72))
                    (N (enumerate 1747 4864 72))
                    (N (enumerate 1748 4864 72))
                    (N (enumerate 1749 4864 72))
                    (N (enumerate 1750 4864 72))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Rare Tarabostes"
                    "All Rare Tarabostes Dacians in a Set. 12.75% (85% of Native Bloodshed Royalty) Royalty and 85% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s6 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 15
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Rare Costoboc" 1.1
                [
                    (N (enumerate 1751 4864 72))
                    (N (enumerate 1752 4864 72))
                    (N (enumerate 1753 4864 72))
                    (N (enumerate 1754 4864 72))
                    (N (enumerate 1755 4864 72))
                    (N (enumerate 1756 4864 72))
                    (N (enumerate 1757 4864 72))
                    (N (enumerate 1758 4864 72))
                    (N (enumerate 1759 4864 72))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Rare Costoboc"
                    "All Rare Costoboc Dacians in a Set. 12.75% (85% of Native Bloodshed Royalty) Royalty and 85% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s7 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 16
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Rare Buridavens" 1.1
                [
                    (N (enumerate 1760 4864 72))
                    (N (enumerate 1761 4864 72))
                    (N (enumerate 1762 4864 72))
                    (N (enumerate 1763 4864 72))
                    (N (enumerate 1764 4864 72))
                    (N (enumerate 1765 4864 72))
                    (N (enumerate 1766 4864 72))
                    (N (enumerate 1767 4864 72))
                    (N (enumerate 1768 4864 72))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Rare Buridavens"
                    "All Rare Buridavens Dacians in a Set. 12.75% (85% of Native Bloodshed Royalty) Royalty and 85% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s8 b b b b b b)
                    zd zd
                )
            )]
        )
    )
    (defun A10_TierOneEpic (patron:string dhb:string)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
                (r:decimal (* 0.80 R))
                (ir:decimal (fold (*) 1.0 [6.0 0.80 IR-E]))
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (b:string BAR)
                (s1:string "IPFS T1 Comati Photo Link")
                (s2:string "IPFS T1 Ursoi Photo Link")
                (s3:string "IPFS T1 Pileati Photo Link")
                (s4:string "IPFS T1 Smardoi Photo Link")
                (s5:string "IPFS T1 Carpian Photo Link")
                (s6:string "IPFS T1 Tarabostes Photo Link")
                (s7:string "IPFS T1 Costoboc Photo Link")
                (s8:string "IPFS T1 Buridavens Photo Link")
                ;;
                (type:object{DpdcUdc.URI|Type} (ref-DPDC-UDC::UDC_URI|Type true false false false false false false))
                (zd:object{DpdcUdc.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
            )
            ;;Set Class 17
            [(ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Epic Comati" 1.1
                [
                    (N (enumerate 161 1696 48))
                    (N (enumerate 162 1696 48))
                    (N (enumerate 163 1696 48))
                    (N (enumerate 164 1696 48))
                    (N (enumerate 165 1696 48))
                    (N (enumerate 166 1696 48))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Epic Comati"
                    "All Epic Comati Dacians in a Set. 12% (80% of Native Bloodshed Royalty) Royalty and 80% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s1 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 18
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Epic Ursoi" 1.1
                [
                    (N (enumerate 167 1696 48))
                    (N (enumerate 168 1696 48))
                    (N (enumerate 169 1696 48))
                    (N (enumerate 170 1696 48))
                    (N (enumerate 171 1696 48))
                    (N (enumerate 172 1696 48))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Epic Ursoi"
                    "All Epic Ursoi Dacians in a Set. 12% (80% of Native Bloodshed Royalty) Royalty and 80% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s2 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 19
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Epic Pileati" 1.1
                [
                    (N (enumerate 173 1696 48))
                    (N (enumerate 174 1696 48))
                    (N (enumerate 175 1696 48))
                    (N (enumerate 176 1696 48))
                    (N (enumerate 177 1696 48))
                    (N (enumerate 178 1696 48))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Epic Pileati"
                    "All Epic Pileati Dacians in a Set. 12% (80% of Native Bloodshed Royalty) Royalty and 80% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s3 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 20
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Epic Smardoi" 1.1
                [
                    (N (enumerate 179 1696 48))
                    (N (enumerate 180 1696 48))
                    (N (enumerate 181 1696 48))
                    (N (enumerate 182 1696 48))
                    (N (enumerate 183 1696 48))
                    (N (enumerate 184 1696 48))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Epic Smardoi"
                    "All Epic Smardoi Dacians in a Set. 12% (80% of Native Bloodshed Royalty) Royalty and 80% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s4 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 21
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Epic Carpian" 1.1
                [
                    (N (enumerate 185 1696 48))
                    (N (enumerate 186 1696 48))
                    (N (enumerate 187 1696 48))
                    (N (enumerate 188 1696 48))
                    (N (enumerate 189 1696 48))
                    (N (enumerate 190 1696 48))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Epic Carpian"
                    "All Epic Carpian Dacians in a Set. 12% (80% of Native Bloodshed Royalty) Royalty and 80% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s5 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 22
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Epic Tarabostes" 1.1
                [
                    (N (enumerate 191 1696 48))
                    (N (enumerate 192 1696 48))
                    (N (enumerate 193 1696 48))
                    (N (enumerate 194 1696 48))
                    (N (enumerate 195 1696 48))
                    (N (enumerate 196 1696 48))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Epic Tarabostes"
                    "All Epic Tarabostes Dacians in a Set. 12% (80% of Native Bloodshed Royalty) Royalty and 80% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s6 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 23
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Epic Costoboc" 1.1
                [
                    (N (enumerate 197 1696 48))
                    (N (enumerate 198 1696 48))
                    (N (enumerate 199 1696 48))
                    (N (enumerate 200 1696 48))
                    (N (enumerate 201 1696 48))
                    (N (enumerate 202 1696 48))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Epic Costoboc"
                    "All Epic Costoboc Dacians in a Set. 12% (80% of Native Bloodshed Royalty) Royalty and 80% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s7 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 24
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 1 Epic Buridavens" 1.1
                [
                    (N (enumerate 203 1696 48))
                    (N (enumerate 204 1696 48))
                    (N (enumerate 205 1696 48))
                    (N (enumerate 206 1696 48))
                    (N (enumerate 207 1696 48))
                    (N (enumerate 208 1696 48))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r
                    ir
                    "Tier 1 Epic Buridavens"
                    "All Epic Buridavens Dacians in a Set. 12% (80% of Native Bloodshed Royalty) Royalty and 80% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s8 b b b b b b)
                    zd zd
                )
            )]
        )
    )
    (defun A11_TierTwoThreeFour (patron:string dhb:string)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-TS02-C2:module{TalosStageTwo_ClientTwo} TS02-C2)
                (r:decimal (* 0.75 R))
                (ir-c:decimal (* 18 IR-C))
                (ir-r:decimal (* 9 IR-R))
                (ir-e:decimal (* 6 IR-E))
                (ir-l:decimal IR-L)
                (ir-s:decimal (fold (+) 0.0 [ir-c ir-r ir-e ir-l]))
                (ir:decimal (* 0.75 ir-s))
                ;;
                (r2:decimal (* 0.7 R))
                (ir3-c:decimal (fold (*) 1.0 [0.7 144.0 IR-C]))
                (ir3-r:decimal (fold (*) 1.0 [0.7 72.0 IR-R]))
                (ir3-e:decimal (fold (*) 1.0 [0.7 48.0 IR-E]))
                (ir3-l:decimal (fold (*) 1.0 [0.7 8.0 IR-L]))
                ;;
                (r3:decimal (* 0.65 R))
                (ir4:decimal (fold (*) 1.0 [0.65 8.0 ir-s]))
                ;;
                (md:object{DpdcUdc.NonceMetaData} (ref-DPDC-UDC::UDC_NoMetaData))
                (b:string BAR)
                (s1:string "IPFS T2 Comati Photo Link")
                (s2:string "IPFS T2 Ursoi Photo Link")
                (s3:string "IPFS T2 Pileati Photo Link")
                (s4:string "IPFS T2 Smardoi Photo Link")
                (s5:string "IPFS T2 Carpian Photo Link")
                (s6:string "IPFS T2 Tarabostes Photo Link")
                (s7:string "IPFS T2 Costoboc Photo Link")
                (s8:string "IPFS T2 Buridavens Photo Link")
                ;;
                (s9:string "IPFS T3 Common Link")
                (s10:string "IPFS T3 Rare Link")
                (s11:string "IPFS T3 Epic Link")
                (s12:string "IPFS T3 Legendary Link")
                ;;
                (s13:string "IPFS T4 Link")
                ;;
                (type:object{DpdcUdc.URI|Type} (ref-DPDC-UDC::UDC_URI|Type true false false false false false false))
                (zd:object{DpdcUdc.URI|Data} (ref-DPDC-UDC::UDC_ZeroURI|Data))
                ;;
            )
            ;;Set Class 25
            [(ref-TS02-C2::DPNF|C_DefineHybridSet
                patron dhb "Tier 2 Comati" 1.3
                [(N (enumerate 1 160 8))]
                [(C 1) (C 9) (C 17)]
                (ref-DPDC-UDC::UDC_NonceData
                    r ir
                    "Tier 2 Comati"
                    "All Comati Dacians in a Set. 11.25% (75% of Native Bloodshed Royalty) Royalty and 75% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s1 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 26
            (ref-TS02-C2::DPNF|C_DefineHybridSet
                patron dhb "Tier 2 Ursoi" 1.3
                [(N (enumerate 2 160 8))]
                [(C 2) (C 10) (C 18)]
                (ref-DPDC-UDC::UDC_NonceData
                    r ir
                    "Tier 2 Ursoi"
                    "All Ursoi Dacians in a Set. 11.25% (75% of Native Bloodshed Royalty) Royalty and 75% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s2 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 27
            (ref-TS02-C2::DPNF|C_DefineHybridSet
                patron dhb "Tier 2 Pileati" 1.3
                [(N (enumerate 3 160 8))]
                [(C 3) (C 11) (C 19)]
                (ref-DPDC-UDC::UDC_NonceData
                    r ir
                    "Tier 2 Pileati"
                    "All Pileati Dacians in a Set. 11.25% (75% of Native Bloodshed Royalty) Royalty and 75% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s3 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 28
            (ref-TS02-C2::DPNF|C_DefineHybridSet
                patron dhb "Tier 2 Smardoi" 1.3
                [(N (enumerate 4 160 8))]
                [(C 4) (C 12) (C 20)]
                (ref-DPDC-UDC::UDC_NonceData
                    r ir
                    "Tier 2 Smardoi"
                    "All Smardoi Dacians in a Set. 11.25% (75% of Native Bloodshed Royalty) Royalty and 75% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s4 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 29
            (ref-TS02-C2::DPNF|C_DefineHybridSet
                patron dhb "Tier 2 Carpian" 1.3
                [(N (enumerate 5 160 8))]
                [(C 5) (C 13) (C 21)]
                (ref-DPDC-UDC::UDC_NonceData
                    r ir
                    "Tier 2 Carpian"
                    "All Carpian Dacians in a Set. 11.25% (75% of Native Bloodshed Royalty) Royalty and 75% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s5 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 30
            (ref-TS02-C2::DPNF|C_DefineHybridSet
                patron dhb "Tier 2 Tarabostes" 1.3
                [(N (enumerate 6 160 8))]
                [(C 6) (C 14) (C 22)]
                (ref-DPDC-UDC::UDC_NonceData
                    r ir
                    "Tier 2 Tarabostes"
                    "All Tarabostes Dacians in a Set. 11.25% (75% of Native Bloodshed Royalty) Royalty and 75% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s6 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 31
            (ref-TS02-C2::DPNF|C_DefineHybridSet
                patron dhb "Tier 2 Costoboc" 1.3
                [(N (enumerate 7 160 8))]
                [(C 7) (C 15) (C 23)]
                (ref-DPDC-UDC::UDC_NonceData
                    r ir
                    "Tier 2 Costoboc"
                    "All Costoboc Dacians in a Set. 11.25% (75% of Native Bloodshed Royalty) Royalty and 75% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s7 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 32
            (ref-TS02-C2::DPNF|C_DefineHybridSet
                patron dhb "Tier 2 Buridavens" 1.3
                [(N (enumerate 8 160 8))]
                [(C 8) (C 16) (C 24)]
                (ref-DPDC-UDC::UDC_NonceData
                    r ir
                    "Tier 2 Buridavens"
                    "All Buridavens Dacians in a Set. 11.25% (75% of Native Bloodshed Royalty) Royalty and 75% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s8 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 33
            (ref-TS02-C2::DPNF|C_DefineCompositeSet
                patron dhb "Tier 3 Common" 1.6
                [(C 1) (C 2) (C 3) (C 4) (C 5) (C 6) (C 7) (C 8)]
                (ref-DPDC-UDC::UDC_NonceData
                    r2 ir3-c
                    "Tier 3 Common"
                    "All Common Dacians in a Set. 10.5% (70% of Native Bloodshed Royalty) Royalty and 70% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s9 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 34
            (ref-TS02-C2::DPNF|C_DefineCompositeSet
                patron dhb "Tier 3 Rare" 1.6
                [(C 9) (C 10) (C 11) (C 12) (C 13) (C 14) (C 15) (C 16)]
                (ref-DPDC-UDC::UDC_NonceData
                    r2 ir3-r
                    "Tier 3 Rare"
                    "All Rare Dacians in a Set. 10.5% (70% of Native Bloodshed Royalty) Royalty and 70% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s10 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 35
            (ref-TS02-C2::DPNF|C_DefineCompositeSet
                patron dhb "Tier 3 Epic" 1.6
                [(C 17) (C 18) (C 19) (C 20) (C 21) (C 22) (C 23) (C 24)]
                (ref-DPDC-UDC::UDC_NonceData
                    r2 ir3-e
                    "Tier 3 Epic"
                    "All Epic Dacians in a Set. 10.5% (70% of Native Bloodshed Royalty) Royalty and 70% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s11 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 36
            (ref-TS02-C2::DPNF|C_DefinePrimordialSet
                patron dhb "Tier 3 Legendary" 1.6
                [
                    (N (enumerate 1 160 8))
                    (N (enumerate 2 160 8))
                    (N (enumerate 3 160 8))
                    (N (enumerate 4 160 8))
                    (N (enumerate 5 160 8))
                    (N (enumerate 6 160 8))
                    (N (enumerate 7 160 8))
                    (N (enumerate 8 160 8))
                ]
                (ref-DPDC-UDC::UDC_NonceData
                    r2 ir3-l
                    "Tier 3 Legendary"
                    "All Legendary Dacians in a Set. 10.5% (70% of Native Bloodshed Royalty) Royalty and 70% Ignis-Royalty relative to individual Elements"
                    md
                    (ref-DPDC-UDC::UDC_URI|Type true false false false false false false)
                    (ref-DPDC-UDC::UDC_URI|Data s12 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 37
            (ref-TS02-C2::DPNF|C_DefineCompositeSet
                patron dhb "Tier 4" 2.0
                [(C 25) (C 26) (C 27) (C 28) (C 29) (C 30) (C 31) (C 32)]
                (ref-DPDC-UDC::UDC_NonceData
                    r3 ir4
                    "Tier 4"
                    "All Unique 272 Dacians in a Set. 9.75% (65% of Native Bloodshed Royalty) Royalty and 65% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s13 b b b b b b)
                    zd zd
                )
            )
            ;;Set Class 38
            (ref-TS02-C2::DPNF|C_DefineCompositeSet
                patron dhb "Tier 4" 2.0
                [(C 33) (C 34) (C 35) (C 36)]
                (ref-DPDC-UDC::UDC_NonceData
                    r3 ir4
                    "Tier 4"
                    "All Unique 272 Dacians in a Set. 9.75% (65% of Native Bloodshed Royalty) Royalty and 65% Ignis-Royalty relative to individual Elements"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s13 b b b b b b)
                    zd zd
                )
            )
            ;;Set Fragmentation for Class 37 and 38
            (ref-TS02-C2::DPNF|C_EnableSetClassFragmentation
                patron dhb 37
                (ref-DPDC-UDC::UDC_NonceData
                    r3 (/ ir4 1000.0)
                    "Tier 4 Fragments"
                    "Bloodshed Tier 4 Fragments. 9.75% (65% of Native Bloodshed Royalty) Royalty and 1000th Ignis-Royalty relative to the Full Set"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s13 b b b b b b)
                    zd zd
                )
            )
            (ref-TS02-C2::DPNF|C_EnableSetClassFragmentation
                patron dhb 38
                (ref-DPDC-UDC::UDC_NonceData
                    r3 (/ ir4 1000.0)
                    "Tier 4 Fragments"
                    "Bloodshed Tier 4 Fragments. 9.75% (65% of Native Bloodshed Royalty) Royalty and 1000th Ignis-Royalty relative to the Full Set"
                    md type
                    (ref-DPDC-UDC::UDC_URI|Data s13 b b b b b b)
                    zd zd
                )
            )
            ]
        )
    )
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)