(module INFO-ZERO GOV
    ;;
    (implements OuronetPolicy)
    (implements OuronetInfoV3)
    (implements DalosInfoV3)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_INFO-ZERO              (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|INFO-ZERO_ADMIN)))
    (defcap GOV|INFO-ZERO_ADMIN ()          (enforce-guard GOV|MD_INFO-ZERO))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|INFO-ZERO|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|INFO-ZERO|CALLER))
        (compose-capability (SECURE))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|INFO-ZERO_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|INFO-ZERO_ADMIN)
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
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (mg:guard (create-capability-guard (P|INFO-ZERO|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
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
    ;;
    ;;<======================>
    ;;[OURONET-INFO] Functions
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    ;;{C3}
    (defun CT_KdaPrec ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_KDA_PRECISION)))
    (defun CT_Bar ()                        (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst KDAPREC                       (CT_KdaPrec))
    (defconst BAR                           (CT_Bar))
    ;;
    (defconst DALOS|SC_NAME                 (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|DALOS|SC_NAME)))
    (defconst OUROBOROS|SC_NAME             (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|OUROBOROS|SC_NAME)))
    ;;{C4}
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun OI|UC_IfpFromOutputCumulator:decimal (input:object{IgnisCollectorV2.OutputCumulator})
        (let
            (
                (cc:[object{IgnisCollectorV2.ModularCumulator}] (at "cumulator-chain" input))
            )
            (fold
                (lambda
                    (acc:decimal idx:integer)
                    (+ acc (at "ignis" (at idx cc)))
                )
                0.0
                (enumerate 0 (- (length cc) 1))
            )
        )
    )
    (defun OI|UC_ShortAccount:string (account:string)
        (concat
            [
                (take 5 account)
                "..."
                (take -3 account)
            ]
        )
    )
    (defun OI|UC_ConvertPrice:string (input-price:decimal)
        (let
            (
                (number-of-decimals:integer (if (<= input-price 1.00) 3 2))
                (converted:decimal
                    (if (< input-price 1.00)
                        (floor (* input-price 100.0) 3)
                        (floor input-price 2)
                    )
                )
                (s:string
                    (if (< input-price 1.00)
                        "¢"
                        "$"
                    )
                )
                (ss:string "<0.001¢")
            )
            (if (< input-price 0.00001)
                (format "{}" [ss])
                (format "{}{}" [converted s])    
            )
        )
    )
    (defun OI|UC_FormatIndex:string (index:decimal)
        (let
            (
                (fi:decimal (floor index 12))
                (fis:string (format "{}" [fi]))
                (l1:string (take -3 fis))
                (l2:string (take -3 (drop -3 fis)))
                (l3:string (take -3 (drop -6 fis)))
                (l4:string (take -3 (drop -9 fis)))
                (whole:string (drop -13 fis))
            )
            (concat
                [whole ",[" l4 "." l3 "." l2 "." l1 "]"]
            )
        )
    )
    (defun OI|UC_FormatTokenAmount:string (amount:decimal)
        (format "{}" [(floor amount 4)])
    )
    ;;{F0}  [UR]
    (defun OI|UR_KadenaTargets:[string] ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            [
                (at 2 (ref-DALOS::UR_DemiurgoiID))
                DALOS|SC_NAME
                (at 1 (ref-DALOS::UR_DemiurgoiID))
                OUROBOROS|SC_NAME
            ]
        )
    )
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    (defun OI|UDC_ClientInfo:object{OuronetInfoV3.ClientInfo}
        (a:[string] b:[string] c:object{OuronetInfoV3.ClientIgnisCosts} d:object{OuronetInfoV3.ClientKadenaCosts})
        {"pre-text"         : a
        ,"post-text"        : b
        ,"ignis"            : c
        ,"kadena"           : d}
    )
    (defun OI|UDC_ClientIgnisCosts:object{OuronetInfoV3.ClientIgnisCosts}
        (a:decimal b:decimal c:decimal d:string)
        {"ignis-discount"   : a
        ,"ignis-full"       : b
        ,"ignis-need"       : c
        ,"ignis-text"       : d}
    )
    (defun OI|UDC_ClientKadenaCosts:object{OuronetInfoV3.ClientKadenaCosts}
        (a:decimal b:decimal c:decimal d:[decimal] e:[string] f:string)
        {"kadena-discount"  : a
        ,"kadena-full"      : b
        ,"kadena-need"      : c
        ,"kadena-split"     : d
        ,"kadena-targets"   : e
        ,"kadena-text"      : f}
    )
    (defun OI|UDC_FullKadenaCosts:object{OuronetInfoV3.ClientKadenaCosts} (kfp:decimal)
        (let
            (
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                ;;
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                (kadena-split:[decimal] (ref-U|DALOS::UC_TenTwentyThirtyFourtySplit kfp KDAPREC))
                (kadena-targets:[string] (OI|UR_KadenaTargets))
                (kadena-price:string (OI|UC_ConvertPrice (* kfp kda-pid)))
                (kadena-text:string
                    (format "Operation costs {} KDA valued at {} with no further discounts applied." [kfp kadena-price])
                )
            )
            (OI|UDC_ClientKadenaCosts
                1.0
                kfp
                kfp
                kadena-split
                kadena-targets
                kadena-text
            )
        )
    )
    (defun OI|UDC_KadenaCosts:object{OuronetInfoV3.ClientKadenaCosts} (patron:string kfp:decimal)
        (let
            (
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                ;;
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                (kadena-discount:decimal (ref-DALOS::URC_KadenaGasDiscount patron))
                (discount-percent:string (format "{}%" [(* 100.0 (- 1.0 kadena-discount))]))
                (kadena-need:decimal (floor (* kadena-discount kfp) KDAPREC))
                (kadena-split:[decimal] (ref-U|DALOS::UC_TenTwentyThirtyFourtySplit kadena-need KDAPREC))
                (kadena-targets:[string] (OI|UR_KadenaTargets))
                (kadena-need-price:string (OI|UC_ConvertPrice (* kadena-need kda-pid)))
                (kadena-text:string
                    (if (= kadena-discount 1.0)
                        (format "Operation costs {} KDA valued at {} with no further discounts applied." [kadena-need kadena-need-price])
                        (format "Operation costs {} KDA discounted by {} to {} KDA valued at {}"
                            [kfp discount-percent kadena-need kadena-need-price]
                        )
                    )
                )
            )
            (OI|UDC_ClientKadenaCosts
                kadena-discount
                kfp
                kadena-need
                kadena-split
                kadena-targets
                kadena-text
            )
        )
    )
    (defun OI|UDC_NoKadenaCosts:object{OuronetInfoV3.ClientKadenaCosts} ()
        (OI|UDC_ClientKadenaCosts
            1.0
            0.0
            0.0
            [0.0]
            [BAR]
            "Operation is free of native Kadena (KDA)"
        )
    )
    (defun OI|UDC_DynamicKadenaCost:object{OuronetInfoV3.ClientKadenaCosts} (patron:string kfp:decimal)
        (if (= kfp 0.0)
            (OI|UDC_NoKadenaCosts)
            (OI|UDC_KadenaCosts patron kfp)
        )
    )
    ;;
    (defun OI|UDC_IgnisCosts:object{OuronetInfoV3.ClientIgnisCosts} (patron:string ifp:decimal)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                ;;
                (ignis-discount:decimal (ref-DALOS::URC_IgnisGasDiscount patron))
                (discount-percent:string (format "{}%" [(* 100.0 (- 1.0 ignis-discount))]))
                (ignis-need:decimal (* ignis-discount ifp))
                (ignis-need-price (OI|UC_ConvertPrice (/ ignis-need 100.0)))
                (ignis-text:string
                    (if (= ignis-discount 1.0)
                        (format "Operation costs {} IGNIS valued at {} with no further discounts applied." [ignis-need ignis-need-price])
                        (format "Operation costs {} IGNIS discounted by {} to {} IGNIS valued at {}"
                            [(floor ifp) discount-percent ignis-need ignis-need-price]
                        )
                    )
                )
            )
            (OI|UDC_ClientIgnisCosts
                ignis-discount
                ifp
                ignis-need
                ignis-text
            )
        )
    )
    (defun OI|UDC_NoIgnisCosts:object{OuronetInfoV3.ClientIgnisCosts} ()
        (OI|UDC_ClientIgnisCosts
            1.0
            0.0
            0.0
            "Operation is free of Ouronet GAS (IGNIS)"
        )
    )
    (defun OI|UDC_DynamicIgnisCost:object{OuronetInfoV3.ClientIgnisCosts} (patron:string ifp:decimal)
        (if (= ifp 0.0)
            (OI|UDC_NoIgnisCosts)
            (OI|UDC_IgnisCosts patron ifp)
        )
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
    ;;
    ;;
    ;;
    ;;<======================>
    ;;[DALOS-INFO] Functions
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    ;;{2}
    ;;{3}
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
    (defun DALOS-INFO|URC_ControlSmartAccount:object{OuronetInfoV3.ClientInfo} (patron:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                ;;
                (is-ignis:bool (ref-IGNIS::URC_IsVirtualGasZero))
                (ifp:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (sa:string (OI|UC_ShortAccount account))
            )
            (OI|UDC_ClientInfo
                ["Operation: Execute Smart Account Control."]
                [(format "Smart Ouronet Account {} controlled succesfully" [sa])]
                (if is-ignis (OI|UDC_IgnisCosts patron ifp) (OI|UDC_NoIgnisCosts))
                (OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DALOS-INFO|URC_DeploySmartAccount:object{OuronetInfoV3.ClientInfo} (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                ;;
                (is-kadena:bool (ref-IGNIS::URC_IsNativeGasZero))
                (kfp:decimal (ref-DALOS::UR_UsagePrice "smart"))
                (sa:string (OI|UC_ShortAccount account))
            )
            (OI|UDC_ClientInfo
                ["Operation: Deploy a Smart Ouronet Account."]
                [(format "Smart Ouronet Account {} deployed succesfully" [sa])]
                (OI|UDC_NoIgnisCosts)
                (if is-kadena (OI|UDC_FullKadenaCosts kfp) (OI|UDC_NoKadenaCosts))
            )
        )
    )
    (defun DALOS-INFO|URC_DeployStandardAccount:object{OuronetInfoV3.ClientInfo} (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                ;;
                (is-kadena:bool (ref-IGNIS::URC_IsNativeGasZero))
                (kfp:decimal (ref-DALOS::UR_UsagePrice "standard"))
                (sa:string (OI|UC_ShortAccount account))
            )
            (OI|UDC_ClientInfo
                ["Operation: Deploy a Standard Ouronet Account."]
                [(format "Standard Ouronet Account {} deployed succesfully" [sa])]
                (OI|UDC_NoIgnisCosts)
                (if is-kadena (OI|UDC_FullKadenaCosts kfp) (OI|UDC_NoKadenaCosts))
            )
        )
    )
    (defun DALOS-INFO|URC_RotateGovernor:object{OuronetInfoV3.ClientInfo} (patron:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                ;;
                (is-ignis:bool (ref-IGNIS::URC_IsVirtualGasZero))
                (ifp:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (sa:string (OI|UC_ShortAccount account))
            )
            (OI|UDC_ClientInfo
                ["Operation: Rotate the Governor-Guard of an Ouronet Account."]
                [(format "Ouronet Account {} Governor-Guard rotated succesfully!" [sa])]
                (if is-ignis (OI|UDC_IgnisCosts patron ifp) (OI|UDC_NoIgnisCosts))
                (OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DALOS-INFO|URC_RotateGuard:object{OuronetInfoV3.ClientInfo} (patron:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                ;;
                (is-ignis:bool (ref-IGNIS::URC_IsVirtualGasZero))
                (ifp:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (sa:string (OI|UC_ShortAccount account))
            )
            (OI|UDC_ClientInfo
                ["Operation: Rotate the Primary-Guard of an Ouronet Account."]
                [(format "Ouronet Account {} Primary-Guard rotated succesfully!" [sa])]
                (if is-ignis (OI|UDC_IgnisCosts patron ifp) (OI|UDC_NoIgnisCosts))
                (OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DALOS-INFO|URC_RotateKadena:object{OuronetInfoV3.ClientInfo} (patron:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                ;;
                (is-ignis:bool (ref-IGNIS::URC_IsVirtualGasZero))
                (ifp:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (sa:string (OI|UC_ShortAccount account))
            )
            (OI|UDC_ClientInfo
                ["Operation: Rotate the Attached KDA-Address of an Ouronet Account."]
                [(format "Ouronet Account {} Attached Kadena-Address rotated succesfully!" [sa])]
                (if is-ignis (OI|UDC_IgnisCosts patron ifp) (OI|UDC_NoIgnisCosts))
                (OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DALOS-INFO|URC_RotateSovereign:object{OuronetInfoV3.ClientInfo} (patron:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                ;;
                (is-ignis:bool (ref-IGNIS::URC_IsVirtualGasZero))
                (ifp:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (sa:string (OI|UC_ShortAccount account))
            )
            (OI|UDC_ClientInfo
                ["Operation: Rotate the Sovereign of a Smart Ouronet Account."]
                [(format "Smart Ouronet Account {} Sovereign rotated succesfully!" [sa])]
                (if is-ignis (OI|UDC_IgnisCosts patron ifp) (OI|UDC_NoIgnisCosts))
                (OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DALOS-INFO|URC_UpdateEliteAccount:object{OuronetInfoV3.ClientInfo} (patron:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                ;;
                (is-ignis:bool (ref-IGNIS::URC_IsVirtualGasZero))
                (ifp:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (sa:string (OI|UC_ShortAccount account))
            )
            (OI|UDC_ClientInfo
                ["Operation: Update Elite Account Data for a single Ouronet Account"]
                [(format "Elite Account Data for {} updated succesfully!" [sa])]
                (if is-ignis (OI|UDC_IgnisCosts patron ifp) (OI|UDC_NoIgnisCosts))
                (OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DALOS-INFO|URC_UpdateEliteAccountSquared:object{OuronetInfoV3.ClientInfo} (patron:string sender:string receiver:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                ;;
                (is-ignis:bool (ref-IGNIS::URC_IsVirtualGasZero))
                (ifp:decimal (ref-DALOS::UR_UsagePrice "ignis|medium"))
                (sa1:string (OI|UC_ShortAccount sender))
                (sa2:string (OI|UC_ShortAccount receiver))
            )
            (OI|UDC_ClientInfo
                ["Operation: Update Elite Account Data for a two Ouronet Accounts"]
                [(format "Elite Account Data for {} and {} updated succesfully!" [sa1 sa2])]
                (if is-ignis (OI|UDC_IgnisCosts patron ifp) (OI|UDC_NoIgnisCosts))
                (OI|UDC_NoKadenaCosts)
            )
        )
    )
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