(module UTILITY GOVERNANCE
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
            \ Remove Comment below so that only ADMIN (<free.DH_Master-Keyset>) can enact an upgrade"
        true
        ;;(compose-capability (DEMIURGOI))
        ;;(enforce-guard (keyset-ref-guard DALOS-UTILITY))
    )
    (defconst DALOS-UTILITY "free.DH_Master-Keyset")

    ;;[D] DALOS Constant Values
    (defconst KDA_PRECISION 12)
    (defconst MAX_PRECISION 24)
    (defconst MIN_PRECISION 2)
    (defconst FEE_PRECISION 4)
    (defconst MIN_DESIGNATION_LENGTH 3 "Minimum Designation Length for Token-Name, Tocken-Ticker and Dalos Account Name")
    (defconst MAX_TOKEN_NAME_LENGTH 50)
    (defconst MAX_TOKEN_TICKER_LENGTH 20)
    (defconst ACCOUNT_ID_CHARSET CHARSET_LATIN1 "Allowed character set for account IDs.")
    (defconst ACCOUNT_ID_PROHIBITED_CHARACTER ["$" "¢" "£"])
    (defconst ACCOUNT_ID_MAX_LENGTH 256 " Maximum character length for account IDs. ")
    (defconst BAR "|")
    (defconst NUMBERS ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9"])
    (defconst CAPITAL_LETTERS ["A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"])
    (defconst NON_CAPITAL_LETTERS ["a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"])
    
    ;;[G] GAS Constant Values
    (defconst GAS_QUARTER 0.25)     ;;Subunitary Amount earned by Smart DALOS Accounts via GAS Collection
    (defconst GAS_SMALLEST 1.00)
    (defconst GAS_SMALL 2.00)
    (defconst GAS_MEDIUM 3.00)
    (defconst GAS_BIG 4.00)
    (defconst GAS_BIGGEST 5.00)
    (defconst GAS_ISSUE 15.00)
    (defconst GAS_HUGE 500.00)

    ;;[A] Autostake Constant Values
    (defconst ET        ;;Elite Thresholds
        [0.0 1.0 2.0 5.0 10.0 20.0 50.0 100.0 
        105.0 110.0 125.0 150.0 200.0 350.0 600.0
        610.0 620.0 650.0 700.0 800.0 1100.0 1600.0
        1650.0 1700.0 1850.0 2100.0 2600.0 4100.0 6600.0
        6700.0 6800.0 7100.0 7600.0 8600.0 11600.0 16600.0
        17100.0 17600.0 19100.0 21600.0 26600.0 41600.0 66600.0
        67600.0 68600.0 71600.0 76600.0 86600.0 116600.0 166600.0]
    )
    (defconst DEB       ;;Demiourgos Elite Bonus
        [1.0 1.01 1.02 1.03 1.04 1.05 1.06 1.07
        1.09 1.11 1.13 1.15 1.17 1.19 1.21
        1.24 1.27 1.30 1.33 1.36 1.39 1.42
        1.47 1.52 1.57 1.62 1.67 1.72 1.77
        1.85 1.93 2.01 2.09 2.17 2.25 2.33
        2.46 2.59 2.72 2.85 2.98 3.11 3.24
        3.45 3.66 3.87 4.08 4.29 4.50 4.71]
    )
    (defconst AFT       ;;Auryn Fee Thresholds
        [50.0 100.0 200.0 350.0 550.0 800.0]
    )
    (defconst AUHD      ;;Auryn Uncoil Hour Duration - Default when generating ATS-Pair
        [504 480 478 476 472 468 464 460
        456 454 452 448 444 440 436
        432 430 428 424 420 416 412
        408 406 404 400 396 392 388
        384 382 380 376 372 368 364
        360 358 356 352 348 344 340
        336 330 324 318 312 306 300]
    )
    (defconst EAUHD      ;;Elite-Auryn Uncoil Hour Duration - 
        [1680 1512 1488 1464 1440 1416 1392 1368
        1344 1320 1296 1272 1248 1224 1200
        1176 1152 1128 1104 1080 1056 1032
        1008 984 960 936 912 888 864
        840 816 792 768 744 720 696
        672 648 624 600 576 552 528
        504 480 456 432 408 384 360]
    );;generated with <(OUROBOROS.ATS|C_SetCRD patron Elite-Auryndex false 360 24)>
    (defconst AURYN_FEE 50.0)
    (defconst ELITE-AURYN_FEE 100.0)
    ;;Time Constants
    (defconst NULLTIME (time "1984-10-11T11:10:00Z"))
    (defconst ANTITIME (time "1983-08-07T11:10:00Z"))
    ;;Elite Account Classes
    (defconst C1 "NOVICE")
    (defconst C2 "INVESTOR")
    (defconst C3 "ENTREPRENEUR")
    (defconst C4 "MOGUL")
    (defconst C5 "MAGNATE")
    (defconst C6 "TYCOON")
    (defconst C7 "DEMIURG")
    ;;Elite Account Names
    ;;Tier 1 - NOVICE Class
    (defconst N00 "Infidel")
    (defconst N01 "Indigent")
    (defconst N11 "Fledgling")
    (defconst N12 "Amateur")
    (defconst N13 "Beginner")
    (defconst N14 "Dabler")
    (defconst N15 "Aspirant")
    (defconst N16 "Enthusiast")
    (defconst N17 "Partner")
    ;;Tier 2 - INVESTOR Class
    (defconst N21 "Novice Investor")
    (defconst N22 "Associate Investor")
    (defconst N23 "Junior Investor")
    (defconst N24 "Senior Investor")
    (defconst N25 "Adept Investor")
    (defconst N26 "Expert Investor")
    (defconst N27 "Elite Investor")
    ;;Tier 3 - ENTREPRENEUR Class
    (defconst N31 "Novice Entrepreneur")
    (defconst N32 "Associate Entrepreneur")
    (defconst N33 "Junior Entrepreneur")
    (defconst N34 "Senior Entrepreneur")
    (defconst N35 "Adept Entrepreneur")
    (defconst N36 "Expert Entrepreneur")
    (defconst N37 "Elite Entrepreneur")
    ;;Tier 4 - MOGUL Class
    (defconst N41 "Associate Mogul")
    (defconst N42 "Junior Mogul")
    (defconst N43 "Senior Mogul")
    (defconst N44 "Adept Mogul")
    (defconst N45 "Expert Mogul")
    (defconst N46 "Elite Mogul")
    (defconst N47 "Master Mogul")
    ;;Tier 5 - MAGNATE Class
    (defconst N51 "Associate Magnate")
    (defconst N52 "Junior Magnate")
    (defconst N53 "Senior Magnate")
    (defconst N54 "Adept Magnate")
    (defconst N55 "Expert Magnate")
    (defconst N56 "Elite Magnate")
    (defconst N57 "Master Magnate")
    ;;Tier 6 - TYCOON Class
    (defconst N61 "Junior Tycoon")
    (defconst N62 "Senior Tycoon")
    (defconst N63 "Adept Tycoon")
    (defconst N64 "Expert Tycoon")
    (defconst N65 "Elite Tycoon")
    (defconst N66 "Master Tycoon")
    (defconst N67 "Grand-Master Tycoon")
    ;;Tier 6 - DEMIURG Class
    (defconst N71 "Neophyte Demiurg")
    (defconst N72 "Acolyte Demiurg")
    (defconst N73 "Adept Demiurg")
    (defconst N74 "Expert Demiurg")
    (defconst N75 "Elite Demiurg")
    (defconst N76 "Master Demiurg")
    (defconst N77 "Grand-Master Demiurg")

    ;;Guards
    (defun GUARD|All:guard (guards:[guard])
        @doc "Create a guard that only succeeds if every guard in GUARDS is successfully enforced."
        (enforce (< 0 (length guards)) "Guard list cannot be empty")
        (create-user-guard (GUARD|E_All guards))
    )

    (defun GUARD|E_All:bool (guards:[guard])
        @doc "Enforces all guards in GUARDS"
        (map (enforce-guard) guards)
        true
    )

    (defun GUARD|Any:guard (guards:[guard])
        @doc "Create a guard that succeeds if at least one guard in GUARDS is successfully enforced."
        (enforce (< 0 (length guards)) "Guard list cannot be empty")
        (create-user-guard (GUARD|E_Any guards))
    )

    (defun GUARD|E_Any:bool (guards:[guard])
        @doc "Will succeed if at least one guard in GUARDS is successfully enforced."
        (enforce 
            (< 0 (length (filter (= true) (map (GUARD|E_Try) guards))))
            "None of the guards passed"
        )
    )
    (defun GUARD|E_Try (g:guard)
        (try false (enforce-guard g))
    )

    ;; ATS
    ;; DALOS
    ;; DPTF
    ;; VST

    ;; ATS
    (defun ATS|UC_Elite (x:decimal)
        @doc "Returns an Object following DALOS|EliteSchema given a decimal input amount"
        (cond
            ;;Class Novice
            ((<= x (at 0 ET)) { "class": C1, "name": N00, "tier": "0.0", "deb": (at 0 DEB)})
            ((and (> x (at 0 ET))(< x (at 1 ET))) { "class": C1, "name": N01, "tier": "0.1", "deb": (at 0 DEB)})
            ((and (>= x (at 1 ET))(< x (at 2 ET))) { "class": C1, "name": N11, "tier": "1.1", "deb": (at 1 DEB)})
            ((and (>= x (at 2 ET))(< x (at 3 ET))) { "class": C1, "name": N12, "tier": "1.2", "deb": (at 2 DEB)})
            ((and (>= x (at 3 ET))(< x (at 4 ET))) { "class": C1, "name": N13, "tier": "1.3", "deb": (at 3 DEB)})
            ((and (>= x (at 4 ET))(< x (at 5 ET))) { "class": C1, "name": N14, "tier": "1.4", "deb": (at 4 DEB)})
            ((and (>= x (at 5 ET))(< x (at 6 ET))) { "class": C1, "name": N15, "tier": "1.5", "deb": (at 5 DEB)})
            ((and (>= x (at 6 ET))(< x (at 7 ET))) { "class": C1, "name": N16, "tier": "1.6", "deb": (at 6 DEB)})
            ((and (>= x (at 7 ET))(< x (at 8 ET))) { "class": C1, "name": N17, "tier": "1.7", "deb": (at 7 DEB)})
            ;;Class INVESTOR
            ((and (>= x (at 8 ET))(< x (at 9 ET))) { "class": C2, "name": N21, "tier": "2.1", "deb": (at 8 DEB)})
            ((and (>= x (at 9 ET))(< x (at 10 ET))) { "class": C2, "name": N22, "tier": "2.2", "deb": (at 9 DEB)})
            ((and (>= x (at 10 ET))(< x (at 11 ET))) { "class": C2, "name": N23, "tier": "2.3", "deb": (at 10 DEB)})
            ((and (>= x (at 11 ET))(< x (at 12 ET))) { "class": C2, "name": N24, "tier": "2.4", "deb": (at 11 DEB)})
            ((and (>= x (at 12 ET))(< x (at 13 ET))) { "class": C2, "name": N25, "tier": "2.5", "deb": (at 12 DEB)})
            ((and (>= x (at 13 ET))(< x (at 14 ET))) { "class": C2, "name": N26, "tier": "2.6", "deb": (at 13 DEB)})
            ((and (>= x (at 14 ET))(< x (at 15 ET))) { "class": C2, "name": N27, "tier": "2.7", "deb": (at 14 DEB)})
            ;;Class ENTREPRENEUR
            ((and (>= x (at 15 ET))(< x (at 16 ET))) { "class": C3, "name": N31, "tier": "3.1", "deb": (at 15 DEB)})
            ((and (>= x (at 16 ET))(< x (at 17 ET))) { "class": C3, "name": N32, "tier": "3.2", "deb": (at 16 DEB)})
            ((and (>= x (at 17 ET))(< x (at 18 ET))) { "class": C3, "name": N33, "tier": "3.3", "deb": (at 17 DEB)})
            ((and (>= x (at 18 ET))(< x (at 19 ET))) { "class": C3, "name": N34, "tier": "3.4", "deb": (at 18 DEB)})
            ((and (>= x (at 19 ET))(< x (at 20 ET))) { "class": C3, "name": N35, "tier": "3.5", "deb": (at 19 DEB)})
            ((and (>= x (at 20 ET))(< x (at 21 ET))) { "class": C3, "name": N36, "tier": "3.6", "deb": (at 20 DEB)})
            ((and (>= x (at 21 ET))(< x (at 22 ET))) { "class": C3, "name": N37, "tier": "3.7", "deb": (at 21 DEB)})
            ;;Class MOGUL
            ((and (>= x (at 22 ET))(< x (at 23 ET))) { "class": C4, "name": N41, "tier": "4.1", "deb": (at 22 DEB)})
            ((and (>= x (at 23 ET))(< x (at 24 ET))) { "class": C4, "name": N42, "tier": "4.2", "deb": (at 23 DEB)})
            ((and (>= x (at 24 ET))(< x (at 25 ET))) { "class": C4, "name": N43, "tier": "4.3", "deb": (at 24 DEB)})
            ((and (>= x (at 25 ET))(< x (at 26 ET))) { "class": C4, "name": N44, "tier": "4.4", "deb": (at 25 DEB)})
            ((and (>= x (at 26 ET))(< x (at 27 ET))) { "class": C4, "name": N45, "tier": "4.5", "deb": (at 26 DEB)})
            ((and (>= x (at 27 ET))(< x (at 28 ET))) { "class": C4, "name": N46, "tier": "4.6", "deb": (at 27 DEB)})
            ((and (>= x (at 28 ET))(< x (at 29 ET))) { "class": C4, "name": N47, "tier": "4.7", "deb": (at 28 DEB)})
            ;;Class MAGNATE
            ((and (>= x (at 29 ET))(< x (at 30 ET))) { "class": C5, "name": N51, "tier": "5.1", "deb": (at 29 DEB)})
            ((and (>= x (at 30 ET))(< x (at 31 ET))) { "class": C5, "name": N52, "tier": "5.2", "deb": (at 30 DEB)})
            ((and (>= x (at 31 ET))(< x (at 32 ET))) { "class": C5, "name": N53, "tier": "5.3", "deb": (at 31 DEB)})
            ((and (>= x (at 32 ET))(< x (at 33 ET))) { "class": C5, "name": N54, "tier": "5.4", "deb": (at 32 DEB)})
            ((and (>= x (at 33 ET))(< x (at 34 ET))) { "class": C5, "name": N55, "tier": "5.5", "deb": (at 33 DEB)})
            ((and (>= x (at 34 ET))(< x (at 35 ET))) { "class": C5, "name": N56, "tier": "5.6", "deb": (at 34 DEB)})
            ((and (>= x (at 35 ET))(< x (at 36 ET))) { "class": C5, "name": N57, "tier": "5.7", "deb": (at 35 DEB)})
            ;;Class TYCOON
            ((and (>= x (at 36 ET))(< x (at 37 ET))) { "class": C6, "name": N61, "tier": "6.1", "deb": (at 36 DEB)})
            ((and (>= x (at 37 ET))(< x (at 38 ET))) { "class": C6, "name": N62, "tier": "6.2", "deb": (at 37 DEB)})
            ((and (>= x (at 38 ET))(< x (at 39 ET))) { "class": C6, "name": N63, "tier": "6.3", "deb": (at 38 DEB)})
            ((and (>= x (at 39 ET))(< x (at 40 ET))) { "class": C6, "name": N64, "tier": "6.4", "deb": (at 39 DEB)})
            ((and (>= x (at 40 ET))(< x (at 41 ET))) { "class": C6, "name": N65, "tier": "6.5", "deb": (at 40 DEB)})
            ((and (>= x (at 41 ET))(< x (at 42 ET))) { "class": C6, "name": N66, "tier": "6.6", "deb": (at 41 DEB)})
            ((and (>= x (at 42 ET))(< x (at 43 ET))) { "class": C6, "name": N67, "tier": "6.7", "deb": (at 42 DEB)})
            ;;Class DEMIURG
            ((and (>= x (at 43 ET))(< x (at 44 ET))) { "class": C7, "name": N71, "tier": "7.1", "deb": (at 43 DEB)})
            ((and (>= x (at 44 ET))(< x (at 45 ET))) { "class": C7, "name": N72, "tier": "7.2", "deb": (at 44 DEB)})
            ((and (>= x (at 45 ET))(< x (at 46 ET))) { "class": C7, "name": N73, "tier": "7.3", "deb": (at 45 DEB)})
            ((and (>= x (at 46 ET))(< x (at 47 ET))) { "class": C7, "name": N74, "tier": "7.4", "deb": (at 46 DEB)})
            ((and (>= x (at 47 ET))(< x (at 48 ET))) { "class": C7, "name": N75, "tier": "7.5", "deb": (at 47 DEB)})
            ((and (>= x (at 48 ET))(< x (at 49 ET))) { "class": C7, "name": N76, "tier": "7.6", "deb": (at 48 DEB)})
            { "class": C7, "name": N77, "tier": "7.7", "deb": (at 49 DEB)}
        )
    )
    (defun ATS|UC_UnlockPrice:[decimal] (unlocks:integer)
        @doc "Computes the <parameter-lock> unlock price for a ATS <id> \
            \ Outputs [virtual-gas-costs native-gas-cost] \
            \ Virtual Gas Token = Ignis; Native Gas Token = Kadena"
        (let*
            (
                (multiplier:decimal (dec (+ unlocks 1)))
                (gas-cost:decimal (* 1000.0 multiplier))
                (gaz-cost:decimal (/ gas-cost 100.0))
            )
            [gas-cost gaz-cost]
        )
    )
    (defun ATS|UC_MakeSoftIntervals:[integer] (start:integer growth:integer)
        @doc "Creates a Soft Interval List"
        (enforce (= (mod start growth) 0) (format "{} must be divisible by {} and it is not" [start growth]))
        (enforce (= (mod growth 3) 0) (format "{} must be divisible by 3 and it is not" [growth]))
        (let*
            (
                (small:integer (/ growth 3))
                (medium:integer (* small 2))
                (chain1:[integer] (fold (lambda (acc:[integer] item:integer) (UC_AppendLast acc (+ (UC_LastListElement acc) item))) [start] (make-list 6 growth)))
                (chain2:[integer] (fold (lambda (acc:[integer] item:integer) (UC_AppendLast acc (+ (UC_LastListElement acc) item))) chain1 (+ (make-list 5 medium) (make-list 2 small))))
                (chain3:[integer] (fold (lambda (acc:[integer] item:integer) (UC_AppendLast acc (+ (UC_LastListElement acc) item))) chain2 (+ (make-list 5 medium) (make-list 2 small))))
                (chain4:[integer] (fold (lambda (acc:[integer] item:integer) (UC_AppendLast acc (+ (UC_LastListElement acc) item))) chain3 (+ (make-list 5 medium) (make-list 2 small))))
                (chain5:[integer] (fold (lambda (acc:[integer] item:integer) (UC_AppendLast acc (+ (UC_LastListElement acc) item))) chain4 (+ (make-list 5 medium) (make-list 2 small))))
                (chain6:[integer] (fold (lambda (acc:[integer] item:integer) (UC_AppendLast acc (+ (UC_LastListElement acc) item))) chain5 (+ (make-list 5 medium) (make-list 2 small))))
                (chain7:[integer] (fold (lambda (acc:[integer] item:integer) (UC_AppendLast acc (+ (UC_LastListElement acc) item))) chain6 (+ (make-list 5 medium) (make-list 2 small))))
                (last:integer (UC_LastListElement chain7))
                (very-last:integer (+ last 24))
                (final-lst:[integer] (UC_AppendLast chain7 very-last))
            )
            (reverse final-lst)
        )
    )
    (defun ATS|UC_MakeHardIntervals:[integer] (start:integer growth:integer)
        @doc "Creates a Soft Interval List"
        (enforce (= (mod start growth) 0) (format "{} must be divisible by {} and it is not" [start growth]))
        (let*
            (
                (chain:[integer] 
                    (fold 
                        (lambda 
                            (acc:[integer] item:integer) 
                            (UC_AppendLast acc (+ (UC_LastListElement acc) item))
                        ) 
                        [start] 
                        (make-list 48 growth)
                    )
                )
                (big:integer (* 7 growth))
                (last:integer (UC_LastListElement chain))
                (very-last:integer (+ last big))
                (final-lst:[integer] (UC_AppendLast chain very-last))
            )
            (reverse final-lst)
        )
    )
    (defun DALOS|UV_Fee (fee:decimal)
        @doc "Validate input decimal as a fee value"
        (enforce
            (= (floor fee FEE_PRECISION) fee)
            (format "The fee amount of {} is not a valid fee amount decimal wise" [fee])
        )
        (enforce 
            (or 
                (or (= fee -1.0) (= fee 0.0))
                (and (>= fee 1.0) (<= fee 999.0))
            ) 
            (format "The fee amount of {} is not a valid fee amount value wise" [fee])
        )
    )
    (defun DALOS|UC_Filterid:[string] (listoflists:[[string]] account:string)
        @doc "Helper Function needed for returning DALOS ids for Account <account>"
        (let 
            (
                (result
                    (fold
                        (lambda 
                            (acc:[string] item:[string])
                            (if (= (UC_FirstListElement item) account)
                                (UC_AppendLast acc (UC_LastListElement item))
                                acc
                            )
                        )
                        []
                        listoflists
                    )
                )
            )
            result
        )
    )
    (defun DALOS|UC_Makeid:string (ticker:string)
        @doc "Creates a DPTF id \ 
            \ using the first 12 Characters of the prev-block-hash of (chain-data) as randomness source"
        (let
            (
                (dash "-")
                (twelve (take 12 (at "prev-block-hash" (chain-data))))
            )
            (concat [ticker dash twelve])
        )
    )
    (defun DALOS|UC_MakeMVXNonce:string (nonce:integer)
        @doc "Creates a MultiversX specific NFT nonce from an integer"
        (let*
            (
                (hexa:string (int-to-str 16 nonce))
                (hexalength:integer (length hexa))
            )
            (if (= (mod hexalength 2) 1 )
                (concat ["0" hexa])
                hexa
            )
        )
    )
    (defun DALOS|UV_DalosAccount:bool (account:string)
        @doc "Enforces that a Dalos Account (Address) has the proper format \
        \ Superseeds <DALOS|UV_Account>"
        (let*
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
                    (checkup:bool (DALOS.EnforceMultiStringDalosCharset (drop 2 account)))
                )
                (enforce checkup "Characters do not conform to the DALOS|CHARSET")
            )
        )
    )
    (defun DALOS|UV_UniqueAccount (account:string)
        @doc "Enforces that an Unique Account <account> ID meets charset and length requirements"
        (DALOS|UV_Account (take (- (length account) 13) account))
    )
    (defun DALOS|UV_Account (account:string)
        @doc "Enforces that Account <account> ID meets charset and length requirements"
        (enforce
            (is-charset ACCOUNT_ID_CHARSET account)
            (format "Account ID does not conform to the required charset: {}" [account])
        )
        (enforce
            (not (contains account ACCOUNT_ID_PROHIBITED_CHARACTER))
            (format "Account ID contained a prohibited character: {}" [account])
        )
        (let 
            (
                (al:integer (length account))
            )
            (enforce
              (>= al MIN_DESIGNATION_LENGTH)
              (format "Account ID does not conform to the min length requirement: {}" [account])
            )
            (enforce
              (<= al ACCOUNT_ID_MAX_LENGTH)
              (format "Account ID does not conform to the max length requirement: {}" [account])
            )
        )
    )
    (defun DALOS|UC_AccountCheck:bool (account:string)
        @doc "Checks if a DALOS Account ID is valid (meets charset and length requirements), returning true if it is and false if it isnt"
        (let*
            (
                (t1:bool (is-charset ACCOUNT_ID_CHARSET account))
                (t2:bool (not (contains account ACCOUNT_ID_PROHIBITED_CHARACTER)))
                (t3:bool (and t1 t2))
                (account-length:integer (length account))
                (t4:bool (>= account-length MIN_DESIGNATION_LENGTH))
                (t5:bool (<= account-length ACCOUNT_ID_MAX_LENGTH))
                (t6:bool (and t4 t5))
                (t7:bool (and t3 t6))
            )
            t7
        )
    )
    (defun DALOS|UC_IzStringANC:bool (s:string capital:bool)
        @doc "Checks if a string is alphanumeric with or without Uppercase Only \
        \ Uppercase Only toggle is used by setting the capital boolean to true"
        (fold
            (lambda                                                         ;1st part of the Fold Function the Lambda
                (acc:bool c:string)                                         ;input variables of the lambda
                (and acc (DALOS|UC_IzCharacterANC c capital))                     ;operation of the input variables
            )
            true                                                            ;2nd part of the Fold Function, the initial accumulator value
            (str-to-list s)                                                 ;3rd part of the Fold Function, the List upon which the Lambda is executed
        )
    )
    (defun DALOS|UC_IzCharacterANC:bool (c:string capital:bool)
        @doc "Checks if a character is alphanumeric with or without Uppercase Only"
        (let*
            (
                (c1 (or (contains c CAPITAL_LETTERS)(contains c NUMBERS)))
                (c2 (or c1 (contains c NON_CAPITAL_LETTERS) ))
            )
            (if (= capital true) c1 c2)
        )
    )
    
    
    (defun DALOS|UV_Decimals:bool (decimals:integer)
        @doc "Enforces the decimal size is DALOS precision conform"
        (enforce
            (and
                (>= decimals MIN_PRECISION)
                (<= decimals MAX_PRECISION)
            )
            "Decimal Size is not between 2 and 24 as per DALOS Standard!"
        )
    )
    (defun DALOS|UV_Name:bool (name:string)
        @doc "Enforces correct DALOS Token Name specifications"
        (let
            (
                (nl (length name))
            )
            (enforce
                (and
                    (>= nl MIN_DESIGNATION_LENGTH)
                    (<= nl MAX_TOKEN_NAME_LENGTH)
                )
            "Token Name does not conform to the DALOS Name Standard for Size!"
            )
            (enforce
                (DALOS|UC_IzStringANC name false)
                "Token Name is not AlphaNumeric!"
            )
        )    
    )
    (defun DALOS|UV_Ticker:bool (ticker:string)
        @doc "Enforces correct DALOS Ticker Name specifications"
        (let
            (
                (tl (length ticker))
            )
            (enforce
                (and
                    (>= tl MIN_DESIGNATION_LENGTH)
                    (<= tl MAX_TOKEN_TICKER_LENGTH)
                )
            "Token Ticker does not conform to the DALOS Ticker Standard for Size!"
            )
            (enforce
                (DALOS|UC_IzStringANC ticker true)
                "Token Ticker is not Alphanumeric with Capitals Only!"
            )
        )
    )
    (defun DALOS|UV_EnforceReserved:bool (account:string guard:guard)
        @doc "Enforce reserved account name protocols"
        (if 
            (validate-principal guard account)
            true
            (let 
                (
                    (r (DALOS|UV_CheckReserved account))
                )
                (if 
                    (= r "")
                    true
                    (if 
                        (= r "k")
                        (enforce false "Single-key account protocol violation")
                        (enforce false (format "Reserved protocol guard violation: {}" [r]))
                    )
                )
            )
        )
    )
    (defun DALOS|UV_CheckReserved:string (account:string)
        @doc "Checks account for reserved name and returns type if \
            \ found or empty string. Reserved names start with a \
            \ single char and colon, e.g. 'c:foo', which would return 'c' as type."
        (let 
            (
                (pfx (take 2 account))
            )
            (if (= ":" (take -1 pfx)) 
                (take 1 pfx) 
                ""
            )
        )
    )
    (defun DALOS|UV_PositionalVariable (integer-to-validate:integer positions:integer message:string)
        @doc "Validates a number of positions as positional variables"
        (enforce (= (contains integer-to-validate (enumerate 1 positions)) true) message)
    )
    ;;DPTF
    (defun DPTF|UC_VolumetricTax (precision:integer amount:decimal)
        @doc "Computes the Volumetric-Transaction-Tax (VTT), given an DTPF <id> and <amount>"
        (let*
            (
                (amount-int:integer (floor amount))
                (amount-str:string (int-to-str 10 amount-int))
                (amount-str-rev-lst:[string] (reverse (str-to-list amount-str)))
                (amount-dec-rev-lst:[decimal] (map (lambda (x:string) (dec (str-to-int 10 x))) amount-str-rev-lst))
                (integer-lst:[integer] (enumerate 0 (- (length amount-dec-rev-lst) 1)))
                (logarithm-lst:[decimal] (map (lambda (u:integer) (DPTF|UCX_VolumetricPermile precision u)) integer-lst))
                (multiply-lst:[decimal] (zip (lambda (x:decimal y:decimal) (* x y)) amount-dec-rev-lst logarithm-lst))
                (volumetric-fee:decimal (floor (fold (+) 0.0 multiply-lst) precision))
            )
            volumetric-fee
        )
    )
    (defun DPTF|UCX_VolumetricPermile:decimal (precision:integer unit:integer)
        @doc "Auxiliary computation function needed to compute the volumetric the VTT"
        (let*
            (
                (logarithm-base:decimal (if (= unit 0) 0.0 (dec (str-to-int 10 (concat (make-list unit "7"))))))
                (logarithm-number:decimal (dec (^ 10 unit)))
                (logarithm:decimal (floor (log logarithm-base logarithm-number) precision))
                (volumetric-permile:decimal (floor (* logarithm-number (/ logarithm 1000.0)) precision))
            )
            volumetric-permile
        )
    )
    (defun DPTF|UC_UnlockPrice:[decimal] (fee-unlocks:integer)
        @doc "Computes the <fee-lock> unlock price for a DPTF <id> \
            \ Outputs [virtual-gas-costs native-gas-cost] \
            \ Virtual Gas Token = Ignis; Native Gas Token = Kadena"
        (let*
            (
                (multiplier:decimal (dec (+ fee-unlocks 1)))
                (gas-cost:decimal (* 10000.0 multiplier))
                (gaz-cost:decimal (/ gas-cost 100.0))
            )
            [gas-cost gaz-cost]
        )
    )
    ;;VST
    (defun VST|UC_SplitBalanceForVesting:[decimal] (precision:integer amount:decimal milestones:integer)
        @doc "Splits an Amount according to vesting parameters"
        (VST|UV_Milestone milestones)
        (enforce (!= milestones 0) "Cannot split with zero milestones")
        (let
            (
                (split:decimal (floor (/ amount (dec milestones)) precision))
                (multiply:integer (- milestones 1))
            )
            (enforce (> split 0.0) (format "Amount {} to small to split into {} milestones" [amount milestones]))
            (let*
                (
                    (big-chunk:decimal (floor (* split (dec multiply)) precision))
                    (last-split:decimal (floor (- amount big-chunk) precision))
                )
                (enforce (= (+ big-chunk last-split) amount) (format "Amount of {} could not be split into {} milestones succesfully" [amount milestones]))
                (+ (make-list multiply split) [last-split])
            )
        )
    )
    (defun UC_SplitBalanceWithBooleans:[decimal] (precision:integer amount:decimal milestones:integer boolean:[bool])
        @doc "Splits an Amount according to vesting parameters"
        (enforce (> milestones 0) "Cannot split with zero milestones")
        (let
            (
                (split:decimal (floor (/ amount (dec milestones)) precision))
                (tr-nr:integer (length (UC_Search boolean true)))
                (multiply:integer (- milestones 1))
            )
            (enforce (> split 0.0) (format "Amount {} to small to split into {} milestones" [amount milestones]))
            (enforce (= milestones tr-nr) "Input Lists do not sync")
            (let*
                (
                    (big-chunk:decimal (floor (* split (dec multiply)) precision))
                    (last-split:decimal (floor (- amount big-chunk) precision))
                )
                (enforce (= (+ big-chunk last-split) amount) (format "Amount of {} could not be split into {} milestones succesfully" [amount milestones]))
                (let*
                    (
                        (output-without-last:[decimal]
                            (fold
                                (lambda
                                    (acc:[decimal] truth:bool)
                                    (if truth
                                        (UC_AppendLast acc split)
                                        (UC_AppendLast acc 0.0)
                                    )
                                )
                                []
                                boolean
                            )
                        )
                        (positions-lst:[integer] (UC_Search output-without-last split))
                        (last-element-value-position:integer (at (- (length positions-lst) 1) positions-lst) )
                        (output:[decimal] (UC_ReplaceAt output-without-last last-element-value-position last-split))
                    )
                    output
                )
            )
        )
    )
    (defun VST|UC_MakeVestingDateList:[time] (offset:integer duration:integer milestones:integer)
        @doc "Makes a Times list with unvesting milestones according to vesting parameters"
        (let*
            (
                (present-time:time (at "block-time" (chain-data)))
                (first-time:time (add-time present-time offset))
                (times:[time] [first-time])
            )
            (fold
                (lambda
                    (acc:[time] idx:integer)
                    (let*
                        (
                            (to-add:integer (* idx duration))
                            (new-time:time (add-time first-time to-add))
                        )
                        (+ acc [new-time])
                    )
                )
                times
                (enumerate 1 (- milestones 1))
            )
        )
    )
    (defun VST|UV_Milestone (milestones:integer)
        @doc "Restrict Milestone integer between 1 and 365 Milestones"
        (enforce 
            (and (>= milestones 1) (<= milestones 365)) 
            (format "Milestone splitting number {} is out of bounds"[milestones])
        )
    )
    (defun VST|UV_MilestoneWithTime (offset:integer duration:integer milestones:integer)
        @doc "Validates Milestone duration to be lower than 25 years"
        (VST|UV_Milestone milestones)
        (enforce
            (<= (+ (* milestones duration ) offset) 788400000) 
            "Total Vesting Time cannot be greater than 25 years"
        )
    )

    
    ;;UTILITY
    (defun UV_EnforceUniformIntegerList (input:[integer])
        @doc "Enforces that all elements in the integer list are the same."
        (let 
            (
                (fe:integer (at 0 input))
            )  ;; Get the first element in the list
            (map
                (lambda 
                    (index:integer)
                    (enforce (= fe (at index input)) "List elements are not the same")
                    true
                )
                (enumerate 0 (- (length input) 1))
            )
        )
    )
    (defun UV_DecimalArray (array:[[decimal]])
        @doc "Enforces all inner list inside an array are of equal size"
        (enforce
            (=
                true
                (fold
                    (lambda
                        (acc:bool inner-lst:[decimal])
                        (and
                            acc
                            (if (= 
                                    (length inner-lst) 
                                    (length (at 0 array))
                                )
                                true
                                false
                            )
                        )
                    )
                    true
                    array
                )
            )
            "All Fee-Array Lists must be of equal length !"
        )
    )
    (defun UC_AddArray:[decimal] (array:[[decimal]])
        @doc "Adds all column elements in an array, while ensuring all rows are of equal length"
        (UV_DecimalArray array)
        (fold
            (lambda
                (acc:[decimal] item:[decimal])
                (zip (+) acc item)
            )
            (make-list (length (at 0 array)) 0.0)
            array
        )
    )
    (defun UC_SplitString:[string] (splitter:string splitee:string)
        @doc "Splits a string using a single string as splitter"
        (if (= 0 (length splitee))
            [] ;If the string is empty return a zero length list
            (let* 
                (
                    (sep-pos (UC_Search (str-to-list splitee) splitter))
                    (substart (map (+ 1) (UC_InsertFirst sep-pos -1)))
                    (sublen  (zip (-) (UC_AppendLast sep-pos 10000000) substart))
                    (cut (lambda (start len) (take len (drop start splitee))))
                )
                (zip (cut) substart sublen)
            )
        )
    )
    (defun UC_Search:[integer] (searchee:list item)
        @doc "Search an item into the list and returns a list of index"
        (if (contains item searchee)
            (let 
                (
                    (indexes (enumerate 0 (length searchee)))
                    (match (lambda (v i) (if (= item v) i -1)))
                )
                (UC_RemoveItem (zip (match) searchee indexes) -1)
            )
            []
        )
    )
    (defun UC_ReplaceItem:list (in:list old-item new-item)
        @doc "Replace each occurrence of old-item by new-item"
        (map (lambda (x) (if (= x old-item) new-item x)) in)
    )
    (defun UC_RemoveItem:list (in:list item)
        @doc "Remove an item from a list"
        (filter (!= item) in)
    )
    (defun UC_FirstListElement (in:list)
        @doc "Returns the first item of a list"
        (UV_EnforceNotEmpty in)
        (at 0 in)
    )
    (defun UC_SecondListElement (in:list)
        @doc "Returns the second item of a list"
        (UV_EnforceNotEmpty in)
        (at 1 in)
    )
    (defun UC_LastListElement (in:list)
        @doc "Returns the last item of the list"
        (UV_EnforceNotEmpty in)
        (at (- (length in) 1) in)
    )
    (defun UC_InsertFirst:list (in:list item)
        @doc "Insert an item at the left of the list"
        (+ [item] in)
    )
    (defun UC_AppendLast:list (in:list item)
        @doc "Append an item at the end of the list"
        (+ in [item])
    )
    (defun UV_EnforceNotEmpty:bool (x:list)
        @doc "Verify and Enforces that a list is not empty"
        (enforce (UV_IsNotEmpty x) "List cannot be empty")
    )
    (defun UV_IsNotEmpty:bool (x:list)
        @doc "Return true if the list is not empty"
        (< 0 (length x))
    )
    (defun TripleAnd:bool (b1:bool b2:bool b3:bool)
        (and (and b1 b2) b3)
    )
    (defun QuadAnd:bool (b1:bool b2:bool b3:bool b4:bool)
        (and (and b1 b2) (and b3 b4))
    )
    (defun UC_ReplaceAt:list (in:list idx:integer item)
        @doc "Replace the item at position idx"
        (enforce (and? (<= 0) (> (length in)) idx) "Index out of bounds")
        (UC_Chain [(take idx in),
                [item],
                (drop (+ 1 idx) in)])
    )
    (defun UC_Chain:list (in:list)
        @doc "Chain list of lists"
        (fold (+) [] in)
    )
    (defun UV_EnforceListBounds:bool (x:list idx:integer)
        @doc "Verify and ENFORCES that idx is in list bounds"
        (enforce (and? (<= 0) (> (length x)) idx) "Index out of bounds")
    )
    (defun UC_Extend:list (in:list new-length:integer value)
        @doc "Extends a list to new-length by repeating value"
        (let 
            (
                (missing-items (- new-length (length in)))
            )
            (if (<= missing-items 0)
                in
                (+ in (make-list missing-items value))
            )
        )
    )
    (defun UC_MaxInteger:integer (lst:[integer])
        (fold
            (lambda
                (acc:integer element:integer)
                (if (> element acc) element acc)
            )
            (at 0 lst)
            (drop 1 lst)
        )
    )
    (defun UC_SplitByIndexedRBT:[decimal] 
        (
            rbt-amount:decimal
            pair-rbt-supply:decimal 
            index:decimal
            resident-amounts:[decimal] 
            rt-precisions:[integer] 
        )
        @doc "Splits a RBT value using an index and an input resident amount list, in equivalenet resident amounts"
        (if (= rbt-amount pair-rbt-supply)
            resident-amounts
            (let*
                (
                    (max-precision:integer (UC_MaxInteger rt-precisions))
                    (max-pp:integer (at 0 (UC_Search rt-precisions max-precision)))
                    (indexed-rbt:decimal (floor (* rbt-amount index) max-precision))
                    (resident-sum:decimal (fold (+) 0.0 resident-amounts))
                    (preliminary-output:[decimal] 
                        (fold
                            (lambda
                                (acc:[decimal] index:integer)
                                (UC_AppendLast acc (floor (* (/ (at index resident-amounts) resident-sum) indexed-rbt) (at index rt-precisions)))
                            )
                            []
                            (enumerate 0 (- (length resident-amounts) 1))
                        )
                    )
                    (po-sum:decimal (fold (+) 0.0 preliminary-output))
                    (black-sheep:decimal (at max-pp preliminary-output))
                    (white-sheep:decimal (- indexed-rbt (- po-sum black-sheep)))
                    (output:[decimal] (UC_ReplaceAt preliminary-output max-pp white-sheep))
                )
                output
            )
        )
    )

    (defun UC_PromilleSplit:[decimal] (promile:decimal input:decimal input-precision:integer)
        (let*
            (
                (fee:decimal (floor (* (/ promile 1000.0) input) input-precision))
                (remainder:decimal (- input fee))
            )
            [remainder fee]
        )
    )

    (defun UC_ListPromileSplit:[[decimal]] (promile:decimal input-lst:[decimal] input-precision-lst:[integer])
        [
            (fold
                (lambda
                    (acc:[decimal] index:integer)
                    (UC_AppendLast acc (at 0 (UC_PromilleSplit promile (at index input-lst) (at index input-precision-lst))))
                )
                []
                (enumerate 0 (- (length input-lst) 1))
            )
            (fold
                (lambda
                    (acc:[decimal] index:integer)
                    (UC_AppendLast acc (at 1 (UC_PromilleSplit promile (at index input-lst) (at index input-precision-lst))))
                )
                []
                (enumerate 0 (- (length input-lst) 1))
            )
        ]
    )
    (defun UC_Percent:decimal (x:decimal percent:decimal precision:integer)
        (enforce (and (> percent 0.0)(<= percent 100.0)) "P is not a valid percent amount")
        (floor (/ (* x percent) 100.0) precision)
    )

    ;(UTILITY.UC_Percent kadena-input-amount 5.0 UTILITY.KDA_PRECISION)
    ;(UTILITY.UC_Percent kadena-input-amount 15.0 UTILITY.KDA_PRECISION)
    ;(UTILITY.UC_Percent kadena-input-amount 25.0 UTILITY.KDA_PRECISION)
    ;(kadena-split:[decimal] (GAS|UC_KadenaSplit amount))
)
