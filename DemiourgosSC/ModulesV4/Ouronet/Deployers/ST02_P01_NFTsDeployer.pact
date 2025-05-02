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
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV2} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
                (ref-P|DPDC-CD:module{OuronetPolicy} DPDC-CD)
                (ref-P|TS02-C1:module{OuronetPolicy} TS02-C1)
            )
            (ref-P|DPDC::P|A_Define)
            (ref-P|DPDC-CD::P|A_Define)
            (ref-P|TS02-C1::P|A_Define)
        )
    )
    ;;{F6}  [C]
    (defun C_CodingDivision (patron:string collection-owner:string collection-creator:string)
        @doc "Issues the Coding Division Collection by Demiourgos Holdings"
        (let
            (
                (ref-TS02-C1:module{TalosStageTwo_ClientOne} TS02-C1)
                (ref-DPDC-CD:module{DemiourgosPactDigitalCollectibles-CreateDestroy} DPDC-CD)
                (dhcd-id:string
                    (ref-TS02-C1::DPSF|C_Issue
                        patron
                        collection-owner collection-creator "DemiourgosHoldingsCodingDivision" "DHCD"
                        true true true true
                        true true true true
                    )
                )
            )
            
        )
    )
    ;;{F7}  [X]
    ;;
)