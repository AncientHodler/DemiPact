(interface BsSets
    (defun A01_TierOneCommonComati (patron:string dhb:string))
)
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
            (ref-DPDC-UDC::UDC_DPDC|AllowedNonceForSetPosition lst)
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
                (s:string "IPFS T1 Commati Photo Link")
            )
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
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)