(interface OuronetConstants
    @doc "Exported Constants as Functions from this Module via interface"
    ;;
    (defun CT_NS_USE ())
    (defun CT_GOV|UTILS ())
    ;;
    (defun CT_DPTF-FeeLock ())
    (defun CT_ATS-FeeLock ())
    ;;
    (defun CT_KDA_PRECISION ())
    (defun CT_MIN_PRECISION ())
    (defun CT_MAX_PRECISION ())
    (defun CT_FEE_PRECISION ())
    (defun CT_MIN_DESIGNATION_LENGTH ())
    (defun CT_MAX_TOKEN_NAME_LENGTH ())
    (defun CT_MAX_TOKEN_TICKER_LENGTH ())
    (defun CT_ACCOUNT_ID_PROH-CHAR ())
    (defun CT_ACCOUNT_ID_MAX_LENGTH ())
    (defun CT_BAR ())
    (defun CT_NUMBERS ())
    (defun CT_CAPITAL_LETTERS ())
    (defun CT_NON_CAPITAL_LETTERS ())
    (defun CT_SPECIAL ())
    ;;
    (defun CT_ET ())
    (defun CT_DEB ())
    ;;
    (defun CT_C1 ())
    (defun CT_C2 ())
    (defun CT_C3 ())
    (defun CT_C4 ())
    (defun CT_C5 ())
    (defun CT_C6 ())
    (defun CT_C7 ())
    ;;
    (defun CT_N00 ())
    (defun CT_N01 ())
    (defun CT_N11 ())
    (defun CT_N12 ())
    (defun CT_N13 ())
    (defun CT_N14 ())
    (defun CT_N15 ())
    (defun CT_N16 ())
    (defun CT_N17 ())
    ;;
    (defun CT_N21 ())
    (defun CT_N22 ())
    (defun CT_N23 ())
    (defun CT_N24 ())
    (defun CT_N25 ())
    (defun CT_N26 ())
    (defun CT_N27 ())
    ;;
    (defun CT_N31 ())
    (defun CT_N32 ())
    (defun CT_N33 ())
    (defun CT_N34 ())
    (defun CT_N35 ())
    (defun CT_N36 ())
    (defun CT_N37 ())
    ;;
    (defun CT_N41 ())
    (defun CT_N42 ())
    (defun CT_N43 ())
    (defun CT_N44 ())
    (defun CT_N45 ())
    (defun CT_N46 ())
    (defun CT_N47 ())
    ;;
    (defun CT_N51 ())
    (defun CT_N52 ())
    (defun CT_N53 ())
    (defun CT_N54 ())
    (defun CT_N55 ())
    (defun CT_N56 ())
    (defun CT_N57 ())
    ;;
    (defun CT_N61 ())
    (defun CT_N62 ())
    (defun CT_N63 ())
    (defun CT_N64 ())
    (defun CT_N65 ())
    (defun CT_N66 ())
    (defun CT_N67 ())
    ;;
    (defun CT_N71 ())
    (defun CT_N72 ())
    (defun CT_N73 ())
    (defun CT_N74 ())
    (defun CT_N75 ())
    (defun CT_N76 ())
    (defun CT_N77 ())
)
(interface DiaKdaPid
    @doc "Exposes the UR Function that Reads KDA Price in Dollars (KDA-PID) via Dia Oracle on Chain 2"
    ;;
    (defun UR|KDA-PID:decimal ())
)
(module U|CT GOV
    ;;
    (implements OuronetConstants)
    (implements DiaKdaPid)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    ;;PRODUCTION
    ;;(defun NS_MAIN ()               (at 0 ["n_7d40ccda457e374d8eb07b658fd38c282c545038"]))
    ;;(defun NS_TEST ()               (at 0 ["free"]))
    ;;(defun CT_NS_USE  ()            (NS_MAIN))
    ;;
    (defun NS_MAIN ()               (at 0 [""]))
    (defun NS_TEST ()               (at 0 ["n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea"]))
    (defun CT_NS_USE  ()            (at 0 ["free"]))
    ;;
    (defconst GOV|DEMIURGOI         (+ (CT_NS_USE) ".dh_master-keyset"))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|U|CT_ADMIN)))
    (defcap GOV|U|CT_ADMIN ()       (enforce-guard (CT_GOV|UTILS)))
    ;;{G3}
    (defun CT_GOV|UTILS ()          (keyset-ref-guard GOV|DEMIURGOI))
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
    (defun CT_DPTF-FeeLock ()
        (if
            (or
                (= (CT_NS_USE) (NS_TEST))
                (= (CT_NS_USE) "free")
            )
            1.0
            10000.0
        )
    )
    (defun CT_ATS-FeeLock ()
        (/ (CT_DPTF-FeeLock) 10.0)
    )
    (defun CT_KDA_PRECISION () 12)
    (defun CT_MIN_PRECISION () 2)
    (defun CT_MAX_PRECISION () 24)
    (defun CT_FEE_PRECISION () 4)
    (defun CT_MIN_DESIGNATION_LENGTH () 2)
    (defun CT_MAX_TOKEN_NAME_LENGTH () 50)
    (defun CT_MAX_TOKEN_TICKER_LENGTH () 30)

    (defun CT_ACCOUNT_ID_PROH-CHAR () ["$" "¢" "£"])
    (defun CT_ACCOUNT_ID_MAX_LENGTH () 256)
    (defun CT_BAR () (at 0 ["|"]))
    (defun CT_NUMBERS ()
        ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9"]
    )
    (defun CT_CAPITAL_LETTERS ()
        ["A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"]
    )
    (defun CT_NON_CAPITAL_LETTERS ()
        ["a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"]
    )
    (defun CT_SPECIAL () ["|" "-" "^"])

    (defun CT_ET ()
        @doc "Represents the Total-Elite-Auryn (vested and non-vested) to increase in Elite-Account Rank"
        [0.0 1.0 2.0 5.0 10.0 20.0 50.0 100.0
        105.0 110.0 125.0 150.0 200.0 350.0 600.0
        610.0 620.0 650.0 700.0 800.0 1100.0 1600.0
        1650.0 1700.0 1850.0 2100.0 2600.0 4100.0 6600.0
        6700.0 6800.0 7100.0 7600.0 8600.0 11600.0 16600.0
        17100.0 17600.0 19100.0 21600.0 26600.0 41600.0 66600.0
        67600.0 68600.0 71600.0 76600.0 86600.0 116600.0 166600.0]
    )
    (defun CT_DEB ()
        @doc "Represents the Demiourgos Elite Bonus as non-percentual, direct multipler"
        [1.0 1.01 1.02 1.03 1.04 1.05 1.06 1.07
        1.09 1.11 1.13 1.15 1.17 1.19 1.21
        1.24 1.27 1.30 1.33 1.36 1.39 1.42
        1.47 1.52 1.57 1.62 1.67 1.72 1.77
        1.85 1.93 2.01 2.09 2.17 2.25 2.33
        2.46 2.59 2.72 2.85 2.98 3.11 3.24
        3.45 3.66 3.87 4.08 4.29 4.50 4.71]
    )
    ;;
    (defun CT_C1 () (at 0 ["NOVICE"]))
    (defun CT_C2 () (at 0 ["INVESTOR"]))
    (defun CT_C3 () (at 0 ["ENTREPRENEUR"]))
    (defun CT_C4 () (at 0 ["MOGUL"]))
    (defun CT_C5 () (at 0 ["MAGNATE"]))
    (defun CT_C6 () (at 0 ["TYCOON"]))
    (defun CT_C7 () (at 0 ["DEMIURG"]))
    ;;
    (defun CT_N00 () (at 0 ["Infidel"]))
    (defun CT_N01 () (at 0 ["Indigent"]))
    (defun CT_N11 () (at 0 ["Fledgling"]))
    (defun CT_N12 () (at 0 ["Amateur"]))
    (defun CT_N13 () (at 0 ["Beginner"]))
    (defun CT_N14 () (at 0 ["Dabler"]))
    (defun CT_N15 () (at 0 ["Aspirant"]))
    (defun CT_N16 () (at 0 ["Enthusiast"]))
    (defun CT_N17 () (at 0 ["Partner"]))
    ;;
    (defun CT_N21 () (at 0 ["Novice Investor"]))
    (defun CT_N22 () (at 0 ["Associate Investor"]))
    (defun CT_N23 () (at 0 ["Junior Investor"]))
    (defun CT_N24 () (at 0 ["Senior Investor"]))
    (defun CT_N25 () (at 0 ["Adept Investor"]))
    (defun CT_N26 () (at 0 ["Expert Investor"]))
    (defun CT_N27 () (at 0 ["Elite Investor"]))
    ;;
    (defun CT_N31 () (at 0 ["Novice Entrepreneur"]))
    (defun CT_N32 () (at 0 ["Associate Entrepreneur"]))
    (defun CT_N33 () (at 0 ["Junior Entrepreneur"]))
    (defun CT_N34 () (at 0 ["Senior Entrepreneur"]))
    (defun CT_N35 () (at 0 ["Adept Entrepreneur"]))
    (defun CT_N36 () (at 0 ["Expert Entrepreneur"]))
    (defun CT_N37 () (at 0 ["Elite Entrepreneur"]))
    ;;
    (defun CT_N41 () (at 0 ["Associate Mogul"]))
    (defun CT_N42 () (at 0 ["Junior Mogul"]))
    (defun CT_N43 () (at 0 ["Senior Mogul"]))
    (defun CT_N44 () (at 0 ["Adept Mogul"]))
    (defun CT_N45 () (at 0 ["Expert Mogul"]))
    (defun CT_N46 () (at 0 ["Elite Mogul"]))
    (defun CT_N47 () (at 0 ["Master Mogul"]))
    ;;
    (defun CT_N51 () (at 0 ["Associate Magnate"]))
    (defun CT_N52 () (at 0 ["Junior Magnate"]))
    (defun CT_N53 () (at 0 ["Senior Magnate"]))
    (defun CT_N54 () (at 0 ["Adept Magnate"]))
    (defun CT_N55 () (at 0 ["Expert Magnate"]))
    (defun CT_N56 () (at 0 ["Elite Magnate"]))
    (defun CT_N57 () (at 0 ["Master Magnate"]))
    ;;
    (defun CT_N61 () (at 0 ["Junior Tycoon"]))
    (defun CT_N62 () (at 0 ["Senior Tycoon"]))
    (defun CT_N63 () (at 0 ["Adept Tycoon"]))
    (defun CT_N64 () (at 0 ["Expert Tycoon"]))
    (defun CT_N65 () (at 0 ["Elite Tycoon"]))
    (defun CT_N66 () (at 0 ["Master Tycoon"]))
    (defun CT_N67 () (at 0 ["Grand-Master Tycoon"]))
    ;;
    (defun CT_N71 () (at 0 ["Neophyte Demiurg"]))
    (defun CT_N72 () (at 0 ["Acolyte Demiurg"]))
    (defun CT_N73 () (at 0 ["Adept Demiurg"]))
    (defun CT_N74 () (at 0 ["Expert Demiurg"]))
    (defun CT_N75 () (at 0 ["Elite Demiurg"]))
    (defun CT_N76 () (at 0 ["Master Demiurg"]))
    (defun CT_N77 () (at 0 ["Grand-Master Demiurg"]))
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
    (defun UR|KDA-PID:decimal ()
        ;;(at "value" (n_bfb76eab37bf8c84359d6552a1d96a309e030b71.dia-oracle.get-value "KDA/USD"))
        1.0
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