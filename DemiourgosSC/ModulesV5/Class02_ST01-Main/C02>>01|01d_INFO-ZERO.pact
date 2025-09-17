(module INFO-ZERO GOV
    ;;
    (implements OuronetPolicy)
    (implements OuronetInfoV2)
    (implements DalosInfoV2)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_INFO-ZERO              (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|INFO-ZERO_ADMIN)))
    (defcap GOV|INFO-ZERO_ADMIN ()          (enforce-guard GOV|MD_INFO-ZERO))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::P|Info)))
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
                (ref-P|DPDC:module{OuronetPolicy} DPDC)
                (mg:guard (create-capability-guard (P|INFO-ZERO|CALLER)))
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
    ;;{C4}
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun OI|UC_IfpFromOutputCumulator:decimal (input:object{IgnisCollector.OutputCumulator})
        (let
            (
                (cc:[object{IgnisCollector.ModularCumulator}] (at "cumulator-chain" input))
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
        [
            (at 2 (UR_DemiurgoiID))
            DALOS|SC_NAME
            (at 1 (UR_DemiurgoiID))
            (GOV|OUROBOROS|SC_NAME)
        ]
    )
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    (defun OI|UDC_ClientInfo:object{OuronetInfoV2.ClientInfo}
        (a:[string] b:[string] c:object{OuronetInfoV2.ClientIgnisCosts} d:object{OuronetInfoV2.ClientKadenaCosts})
        {"pre-text"         : a
        ,"post-text"        : b
        ,"ignis"            : c
        ,"kadena"           : d}
    )
    (defun OI|UDC_ClientIgnisCosts:object{OuronetInfoV2.ClientIgnisCosts}
        (a:decimal b:decimal c:decimal d:string)
        {"ignis-discount"   : a
        ,"ignis-full"       : b
        ,"ignis-need"       : c
        ,"ignis-text"       : d}
    )
    (defun OI|UDC_ClientKadenaCosts:object{OuronetInfoV2.ClientKadenaCosts}
        (a:decimal b:decimal c:decimal d:[decimal] e:[string] f:string)
        {"kadena-discount"  : a
        ,"kadena-full"      : b
        ,"kadena-need"      : c
        ,"kadena-split"     : d
        ,"kadena-targets"   : e
        ,"kadena-text"      : f}
    )
    (defun OI|UDC_FullKadenaCosts:object{OuronetInfoV2.ClientKadenaCosts} (kfp:decimal)
        (let
            (
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
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
    (defun OI|UDC_KadenaCosts:object{OuronetInfoV2.ClientKadenaCosts} (patron:string kfp:decimal)
        (let
            (
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                (kadena-discount:decimal (URC_KadenaGasDiscount patron))
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
    (defun OI|UDC_NoKadenaCosts:object{OuronetInfoV2.ClientKadenaCosts} ()
        (OI|UDC_ClientKadenaCosts
            1.0
            0.0
            0.0
            [0.0]
            [BAR]
            "Operation is free of native Kadena (KDA)"
        )
    )
    (defun OI|UDC_DynamicKadenaCost:object{OuronetInfoV2.ClientKadenaCosts} (patron:string kfp:decimal)
        (if (= kfp 0.0)
            (OI|UDC_NoKadenaCosts)
            (OI|UDC_KadenaCosts patron kfp)
        )
    )
    ;;
    (defun OI|UDC_IgnisCosts:object{OuronetInfoV2.ClientIgnisCosts} (patron:string ifp:decimal)
        (let
            (
                (ignis-discount:decimal (URC_IgnisGasDiscount patron))
                (discount-percent:string (format "{}%" [(* 100.0 (- 1.0 ignis-discount))]))
                (ignis-need:decimal (* ignis-discount ifp))
                (ignis-need-price (OI|UC_ConvertPrice (/ ignis-need 100.0)))
                (ignis-text:string
                    (if (= ignis-discount 1.0)
                        (format "Operation costs {} IGNIS valued at {} with no further discounts applied." [ignis-need ignis-need-price])
                        (format "Operation costs {} IGNIS discounted by {} to {} IGNIS valued at {}"
                            [ifp discount-percent ignis-need ignis-need-price]
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
    (defun OI|UDC_NoIgnisCosts:object{OuronetInfoV2.ClientIgnisCosts} ()
        (OI|UDC_ClientIgnisCosts
            1.0
            0.0
            0.0
            "Operation is free of Ouronet GAS (IGNIS)"
        )
    )
    (defun OI|UDC_DynamicIgnisCost:object{OuronetInfoV2.ClientIgnisCosts} (patron:string ifp:decimal)
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
    (defun DALOS-INFO|URC_ControlSmartAccount:object{OuronetInfoV2.ClientInfo} (patron:string account:string)
        (let
            (
                (is-ignis:bool (IC|URC_IsVirtualGasZero))
                (ifp:decimal (UR_UsagePrice "ignis|small"))
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
    (defun DALOS-INFO|URC_DeploySmartAccount:object{OuronetInfoV2.ClientInfo} (account:string)
        (let
            (
                (is-kadena:bool (IC|URC_IsNativeGasZero))
                (kfp:decimal (UR_UsagePrice "smart"))
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
    (defun DALOS-INFO|URC_DeployStandardAccount:object{OuronetInfoV2.ClientInfo} (account:string)
        (let
            (
                (is-kadena:bool (IC|URC_IsNativeGasZero))
                (kfp:decimal (UR_UsagePrice "standard"))
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
    (defun DALOS-INFO|URC_RotateGovernor:object{OuronetInfoV2.ClientInfo} (patron:string account:string)
        (let
            (
                (is-ignis:bool (IC|URC_IsVirtualGasZero))
                (ifp:decimal (UR_UsagePrice "ignis|small"))
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
    (defun DALOS-INFO|URC_RotateGuard:object{OuronetInfoV2.ClientInfo} (patron:string account:string)
        (let
            (
                (is-ignis:bool (IC|URC_IsVirtualGasZero))
                (ifp:decimal (UR_UsagePrice "ignis|small"))
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
    (defun DALOS-INFO|URC_RotateKadena:object{OuronetInfoV2.ClientInfo} (patron:string account:string)
        (let
            (
                (is-ignis:bool (IC|URC_IsVirtualGasZero))
                (ifp:decimal (UR_UsagePrice "ignis|small"))
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
    (defun DALOS-INFO|URC_RotateSovereign:object{OuronetInfoV2.ClientInfo} (patron:string account:string)
        (let
            (
                (is-ignis:bool (IC|URC_IsVirtualGasZero))
                (ifp:decimal (UR_UsagePrice "ignis|small"))
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
    (defun DALOS-INFO|URC_UpdateEliteAccount:object{OuronetInfoV2.ClientInfo} (patron:string account:string)
        (let
            (
                (is-ignis:bool (IC|URC_IsVirtualGasZero))
                (ifp:decimal (UR_UsagePrice "ignis|small"))
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
    (defun DALOS-INFO|URC_UpdateEliteAccountSquared:object{OuronetInfoV2.ClientInfo} (patron:string sender:string receiver:string)
        (let
            (
                (is-ignis:bool (IC|URC_IsVirtualGasZero))
                (ifp:decimal (UR_UsagePrice "ignis|medium"))
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
    ;;
    ;;
    ;;
    ;;<======================>
    ;;[GLYPH] Functions
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    ;;{2}
    ;;{3}
    (defconst DALOS|CHR_AUX
        [ " " "!" "#" "%" "&" "'" "(" ")" "*" "+" "," "-" "." "/" ":" ";" "<" "=" ">" "?" "@" "[" "]" "^" "_" "`" "{" "|" "}" "~" "‰" ]
    )
    (defconst DALOS|CHR_DIGITS
        ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9"]
    )
    (defconst DALOS|CHR_CURRENCIES
        [ "Ѻ" "₿" "$" "¢" "€" "£" "¥" "₱" "₳" "∇" ]
    )
    (defconst DALOS|CHR_LATIN-B
        [ "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" ]
    )
    (defconst DALOS|CHR_LATIN-S
        [ "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" ]
    )
    (defconst DALOS|CHR_LATIN-EXT-B
        [ "Æ" "Œ" "Á" "Ă" "Â" "Ä" "À" "Ą" "Å" "Ã" "Ć" "Č" "Ç" "Ď" "Đ" "É" "Ě" "Ê" "Ë" "È" "Ę" "Ğ" "Í" "Î" "Ï" "Ì" "Ł" "Ń" "Ñ" "Ó" "Ô" "Ö" "Ò" "Ø" "Õ" "Ř" "Ś" "Š" "Ş" "Ș" "Þ" "Ť" "Ț" "Ú" "Û" "Ü" "Ù" "Ů" "Ý" "Ÿ" "Ź" "Ž" "Ż" ]
    )
    (defconst DALOS|CHR_LATIN-EXT-S
        [ "æ" "œ" "á" "ă" "â" "ä" "à" "ą" "å" "ã" "ć" "č" "ç" "ď" "đ" "é" "ě" "ê" "ë" "è" "ę" "ğ" "í" "î" "ï" "ì" "ł" "ń" "ñ" "ó" "ô" "ö" "ò" "ø" "õ" "ř" "ś" "š" "ş" "ș" "þ" "ť" "ț" "ú" "û" "ü" "ù" "ů" "ý" "ÿ" "ź" "ž" "ż" "ß" ]
    )
    (defconst DALOS|CHR_GREEK-B
        [ "Γ" "Δ" "Θ" "Λ" "Ξ" "Π" "Σ" "Φ" "Ψ" "Ω" ]
    )
    (defconst DALOS|CHR_GREEK-S
        [ "α" "β" "γ" "δ" "ε" "ζ" "η" "θ" "ι" "κ" "λ" "μ" "ν" "ξ" "π" "ρ" "σ" "ς" "τ" "φ" "χ" "ψ" "ω" ]
    )
    (defconst DALOS|CHR_CYRILLIC-B
        [ "Б" "Д" "Ж" "З" "И" "Й" "Л" "П" "У" "Ц" "Ч" "Ш" "Щ" "Ъ" "Ы" "Ь" "Э" "Ю" "Я" ]
    )
    (defconst DALOS|CHR_CYRILLIC-S
        [ "б" "в" "д" "ж" "з" "и" "й" "к" "л" "м" "н" "п" "т" "у" "ф" "ц" "ч" "ш" "щ" "ъ" "ы" "ь" "э" "ю" "я" ]
    )
    (defconst DALOS|CHARSET
        (fold (+) []
            [
                DALOS|CHR_DIGITS
                DALOS|CHR_CURRENCIES
                DALOS|CHR_LATIN-B
                DALOS|CHR_LATIN-S
                DALOS|CHR_LATIN-EXT-B
                DALOS|CHR_LATIN-EXT-S
                DALOS|CHR_GREEK-B
                DALOS|CHR_GREEK-S
                DALOS|CHR_CYRILLIC-B
                DALOS|CHR_CYRILLIC-S
            ]
        )
    )
    (defconst DALOS|EXTENDED        (+ DALOS|CHR_AUX DALOS|CHARSET))
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
    (defun GLYPH|UEV_DalosAccountCheck (account:string)
        @doc "Checks if a string is a valid DALOS Account, using no enforcements "
        (let
            (
                (account-len:integer (length account))
                (t1:bool (= account-len 162))
                (ouroboros:string "Ѻ")
                (sigma:string "Σ")
                (first:string (take 1 account))
                (t2:bool (or (= first ouroboros)(= first sigma)))
                (t3:bool (and t1 t2))
                (second:string (drop 1 (take 2 account)))
                (point:string ".")
                (t4:bool (= second point))
                (t5:bool (GLYPH|UEV_MsDc (drop 2 account)))
                (t6:bool (and t4 t5))
            )
            (and t3 t6)
        )
    )
    (defun GLYPH|UEV_DalosAccount (account:string)
        @doc "Enforces that a Dalos Account (Address) has the proper format"
        (let
            (
                (account-len:integer (length account))
                (ouroboros:string "Ѻ")
                (sigma:string "Σ")
                (first:string (take 1 account))
                (second:string (drop 1 (take 2 account)))
                (point:string ".")
            )
            (enforce (= account-len 162) "Address|Account does not conform to the DALOS Standard for Addresses|Accounts")
            (enforce-one
                "Address|Account format is invalid"
                [
                    (enforce (= first ouroboros) "Account|Address Identifier is invalid, while checking for a Standard Account|Address")
                    (enforce (= first sigma) "Account|Address Identifier is invalid, while checking for a Smart Account|Address")
                ]
            )
            (enforce (= second point) "Account|Address Format is invalid, second Character must be a <.>")
            (let
                (
                    (checkup:bool (GLYPH|UEV_MsDc (drop 2 account)))
                )
                (enforce checkup "Characters do not conform to the DALOS|CHARSET")
            )
        )
    )
    (defun GLYPH|UEV_MsDc:bool (multi-s:string)
        @doc "Enforce a multistring is part of the DALOS|CHARSET"
        (let
            (
                (str-lst:[string] (str-to-list multi-s))
            )
            (fold
                (lambda
                    (acc:bool idx:integer)
                    (let
                        (
                            (checkup:bool (contains (at idx str-lst) DALOS|CHARSET))
                        )
                        (or acc checkup)
                    )
                )
                false
                (enumerate 0 (- (length str-lst) 1))
            )
        )
    )
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