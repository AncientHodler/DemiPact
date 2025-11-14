(module SAMPLE GOV
    ;;
    (implements OuronetPolicy)
    ;(implements DemiourgosPactDigitalCollectibles-UtilityPrototype)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_SAMPLE                 (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|SAMPLE_ADMIN)))
    (defcap GOV|SAMPLE_ADMIN ()             (enforce-guard GOV|MD_SAMPLE))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;; [Keys]
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|CollectiblesKey ()           (+ (GOV|NS_Use) ".dh_sc_dpdc-keyset"))
    ;;
    ;; [SC-Names]
    (defun GOV|DPDC|SC_NAME ()              (at 0 ["Σ.μЖâAáпδÃàźфнMAŸôIÌjȘЛδεЬÍБЮoзξ4κΩøΠÒçѺłœщÌĘчoãueUøVlßHšδLτε£σž£ЙLÛòCÎcďьčfğÅηвČïnÊвÞIwÇÝмÉŠвRмWć5íЮzGWYвьżΨπûEÃdйdGЫŁŤČçПχĘŚślьЙŤğLУ0SýЭψȘÔÜнìÆkČѺȘÍÍΛ4шεнÄtИςȘ4"]))
    ;;
    ;; [PBLs]
    (defun GOV|DPDC|PBL ()                  (at 0 ["9G.2j95rkomKqd207CDg5yycyKcAy1AqFhjy6D0rCr0Kbwe9E6libtveIHsAIw9F2c43v6IHILIBf62r2LD58xHE09kypyoevL62E81wHL4zj9tIyspf5df82upuBGGKmIsHGuvH86fHMMi99n0htsypL9h3dMHFCIx8ogeynkmCIghxK871rlkas8iDfce7AwAbiajr7H1LHi17mLD7aJu6m7xmcAABkhxtwb4Kqbk8xLpehakyu3AvajgJvtfeysoH67irvplA0as86Jls1r3d3oHms9Maaja9856wzybpthMGs6qDAzacE24skcA30wvm77BLhrdh0ymkl3vbJ9lG641J7ofg5K9gEbHD4ioFHLEajL28qsD4cFEhdDthDzwF8EnBBc74Dikqn9xixFap5Jxhl7D0owz5d9MDJzfjgx3jbdpD3zglsq83iC4fhcpbz3KeAi11Ig2pgIqnmwwqA0Exr5073w7lgzlrw3Ff7Co9uuxbnLuJvlFzgfGeIwM2Dmev1JskqEGK0Ck0B87iagsHFI76HC6sKnwrHnkl0sl8pAf0pbBaw9MbqLs"]))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|SAMPLE|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|SAMPLE|CALLER))
        (compose-capability (SECURE))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|SAMPLE_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|SAMPLE_ADMIN)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (dg:guard (create-capability-guard (SECURE)))
                )
                (with-default-read P|MT P|I
                    {"m-policies" : [dg]}
                    {"m-policies" := mp}
                    (write P|MT P|I
                        {"m-policies" : (ref-U|LST::UC_AppL mp policy-guard)}
                    )
                )
            )
        )
    )
    (defun P|A_Define ()
        (let
            (
                (ref-P|DPDC:module{OuronetPolicy} DPDC)
                (mg:guard (create-capability-guard (P|SAMPLE|CALLER)))
            )
            (ref-P|DPDC::P|A_AddIMP mg)
        )
    )
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
            )
            (ref-U|G::UEV_Any (P|UR_IMP))
        )
    )
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
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
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(IGNIS.C_Collect "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî" (IGNIS.UDC_CustomCodeCumulator))
(let
    
    (
        (ref-P|DPAD:module{OuronetPolicy} DEMIPAD)
        (ref-P|KPAY:module{OuronetPolicy} DEMIPAD-KPAY)
        ;;
        (ref-U|G:module{OuronetGuards} U|G)
        (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
        (ref-TS01-C1:module{TalosStageOne_ClientOneV6} TS01-C1)
        (ref-DPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
        (ref-TS02-DPAD:module{TalosStageTwo_DemiPadV2} TS02-DPAD)
        ;;
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (lpad-sc:string (ref-DPAD::GOV|DEMIPAD|SC_NAME))
        (mg:guard (create-capability-guard (TS02-DPAD.P|TALOS-SUMMONER)))
        ;;
        (s-key:string DEMIPAD-KPAY.KPAY|INFO)
    )
    [
        ;;1]Turn Off KDA Collection to Mint DPTF without KDA Cost
        (ref-TS01-A::DALOS|A_IgnisToggle true false)    ;;turn off KDA Collection
        (let
            (
                (ids:list
                    (ref-TS01-C1::DPTF|C_Issue
                        patron
                        patron
                        ["KadenaPay"]
                        ["KPAY"]
                        [24]
                        [true]
                        [true]
                        [true]
                        [true]
                        [true]
                        [true]
                    )
                )
                (KpayID:string (at 0 ids))
            )
            [   
                ;;2]Turn back On KDA Collection
                (ref-TS01-A::DALOS|A_IgnisToggle true true)     ;;Turn on KDA Collection
                ;;3]Backward IMC
                (ref-P|KPAY::P|A_Define)
                ;;4]Forward IMC
                (ref-P|KPAY::P|A_AddIMP mg)
                ;;5]Demipad Governer Update
                (ref-TS01-C1::DALOS|C_RotateGovernor
                    patron
                    lpad-sc
                    (ref-U|G::UEV_GuardOfAny
                        [
                            (create-capability-guard (DEMIPAD.DEMIPAD|GOV))
                            (ref-P|DPAD::P|UR "SPARK|RemoteGov")
                            (ref-P|DPAD::P|UR "SNAKES|RemoteGov")
                            (ref-P|DPAD::P|UR "CUSTODIANS|RemoteGov")
                            (ref-P|DPAD::P|UR "KPAY|RemoteGov")
                        ]
                    )
                )
                ;;6]Permissions
                (ref-TS01-C1::DPTF|C_Mint patron KpayID lpad-sc 250000000.0 true)
                (ref-TS01-C1::DPTF|C_ToggleBurnRole patron KpayID lpad-sc true)
                ;;7]Store Kpay ID
                (acquire-module-admin DEMIPAD-KPAY)
                (insert DEMIPAD-KPAY.KPAY|T|Properties s-key
                    {"asset-id"            : KpayID}
                )
                ;;8]Register KPAY To Launchpad
                (ref-TS02-DPAD::A_RegisterAssetToLaunchpad patron KpayID [true true])
            ]
        )
    ]
)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(IGNIS.C_Collect "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî" (IGNIS.UDC_CustomCodeCumulator))
(let
    (
        (ref-DEMIPAD-KPAY:module{KadenaPay} DEMIPAD-KPAY)
        (ref-TS02-DPAD:module{TalosStageTwo_DemiPadV2} TS02-DPAD)
        ;;
        (KpayID:string (ref-DEMIPAD-KPAY::UR_KpayID))
    )
    [
        ;;9]Defines the starting point, which is the base for the price and ending period.
        (ref-TS02-DPAD::A_DefinePrice KpayID
            {"starting-time" : (at "block-time" (chain-data))}
        )
        (ref-TS02-DPAD::A_ToggleOpenForBusiness KpayID true)
    ]
)