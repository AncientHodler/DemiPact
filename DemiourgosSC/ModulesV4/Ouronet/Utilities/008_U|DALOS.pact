(module U|DALOS GOV
    ;;
    (implements Ouronet4Dalos)
    ;;{G1}
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|U|DALOS_ADMIN))
    )
    (defcap GOV|U|DALOS_ADMIN ()
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (g:guard (ref-U|CT::CT_GOV|UTILS))
            )
            (enforce-guard g)
        )
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    ;;{P3}
    ;;{P4}
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    (defun UEV_NameOrTicker:bool (name-ticker:string name-or-ticker:bool iz-lp:bool)
        @doc "Enforces correct DALOS Token Name and/or Ticker specifications"
        (let*
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (nl (length name-ticker))
                (min:integer (ref-U|CT::CT_MIN_DESIGNATION_LENGTH))
                (max-n-standard:integer (ref-U|CT::CT_MAX_TOKEN_NAME_LENGTH))
                (max-t-standard:integer (ref-U|CT::CT_MAX_TOKEN_TICKER_LENGTH))
                (max-n-lp:integer (+ (* max-n-standard 7) 8))
                (max-t-lp:integer (+ (* max-t-standard 7) 11))
                (max-n:integer (if iz-lp max-n-lp max-n-standard))
                (max-t:integer (if iz-lp max-t-lp max-t-standard))
                (max:integer (if name-or-ticker max-n max-t))
            )
            (enforce
                (and
                    (>= nl min)
                    (<= nl max)
                )
            "Designation does not conform to the DALOS Name Standard for Size!"
            )
            (enforce
                (UC_IzStringANC name-ticker (not name-or-ticker) iz-lp)
                "Designation does not conform character-wise"
            )
        )
    )
    (defun UEV_Decimals:bool (decimals:integer)
        @doc "Enforces the decimal size is DALOS precision conform"
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (min:integer (ref-U|CT::CT_MIN_PRECISION))
                (max:integer (ref-U|CT::CT_MAX_PRECISION))
            )
            (enforce
                (and
                    (>= decimals min)
                    (<= decimals max)
                )
                "Decimal Size is not between 2 and 24 as per DALOS Standard!"
            )
        )
        
    )
    (defun UEV_Fee (fee:decimal)
        @doc "Validate input decimal as a fee value"
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (fp:integer (ref-U|CT::CT_FEE_PRECISION))
            )
            (enforce
                (= (floor fee fp) fee)
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
        
    )
    ;;
    (defun UEV_TokenName:bool (name:string)
        @doc "Enforces correct DALOS Token Name specifications"
        (let
            (
                (nl (length name))
                (ref-U|CT:module{OuronetConstants} U|CT)
                (min:integer (ref-U|CT::CT_MIN_DESIGNATION_LENGTH))
                (max:integer (ref-U|CT::CT_MAX_TOKEN_NAME_LENGTH))
            )
            (enforce
                (and
                    (>= nl min)
                    (<= nl max)
                )
            "Token Name does not conform to the DALOS Name Standard for Size!"
            )
            (enforce
                (UC_IzStringANC name false)
                "Token Name is not AlphaNumeric!"
            )
        )    
    )
    (defun UEV_TickerName:bool (ticker:string)
        @doc "Enforces correct DALOS Ticker Name specifications"
        (let
            (
                (tl (length ticker))
                (ref-U|CT:module{OuronetConstants} U|CT)
                (min:integer (ref-U|CT::CT_MIN_DESIGNATION_LENGTH))
                (max:integer (ref-U|CT::CT_MAX_TOKEN_TICKER_LENGTH))
            )
            (enforce
                (and
                    (>= tl min)
                    (<= tl max)
                )
            "Token Ticker does not conform to the DALOS Ticker Standard for Size!"
            )
            (enforce
                (UC_IzStringANC ticker true)
                "Token Ticker is not Alphanumeric with Capitals Only!"
            )
        )
    )
    (defun UC_IzStringANC:bool (s:string capital:bool)
        @doc "Checks if a string is alphanumeric with or without Uppercase Only \
        \ Uppercase Only toggle is used by setting the capital boolean to true"
        (fold
            (lambda
                (acc:bool c:string)
                (and acc (UC_IzCharacterANC c capital))
            )
            true
            (str-to-list s)
        )
    )
    (defun UC_IzCharacterANC:bool (c:string capital:bool)
        @doc "Checks if a character is alphanumeric with or without Uppercase Only"
        (let*
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (cl:integer (ref-U|CT::CT_CAPITAL_LETTERS))
                (n:integer (ref-U|CT::CT_NUMBERS))
                (ncl:integer (ref-U|CT::CT_NON_CAPITAL_LETTERS))
                (c1 (or (contains c cl)(contains c n)))
                (c2 (or c1 (contains c ncl) ))
            )
            (if (= capital true) c1 c2)
        )
    )
    (defun UC_NewRoleList (current-lst:[string] account:string direction:bool)
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|LST:module{StringProcessor} U|LST)
                (b:integer (ref-U|CT::CT_BAR))
            )
            (if direction
                (if 
                    (= current-lst [b])
                    [account]
                    (ref-U|LST::UC_AppL current-lst account)
                )
                (if
                    (= current-lst [b])
                    [b]
                    (ref-U|LST::UC_RemoveItem current-lst account)
                )
            )
        )
    )
    (defun UC_FilterId:[string] (listoflists:[[string]] account:string)
        @doc "Helper Function needed for returning DALOS ids for Account <account>"
        (let 
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (result
                    (fold
                        (lambda 
                            (acc:[string] item:[string])
                            (if (= (ref-U|LST::UC_FE item) account)
                                (ref-U|LST::UC_AppL acc (ref-U|LST::UC_LE item))
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
    (defun UC_GasCost (base-cost:decimal major:integer minor:integer native:bool)
        @doc "Computes gas costs (ignis or kda) based on input <base-cost> and <minor> and <major> Elite Tier"
        (* (/ (- 100.0 (UC_GasDiscount major minor native)) 100.0) base-cost)
    )
    (defun UC_GasDiscount (major:integer minor:integer native:bool)
        @doc "Computes the discount applied to base gas cost"
        (if (= major 0)
            0.0
            (let
                (
                    (ignis:decimal (+ (* 7.0 (- (dec major) 1.0)) (dec minor)))
                )
                (if native
                    (* 0.5 ignis)
                    ignis
                )
            )
        )
    )
    (defun UC_KadenaSplit:[decimal] (kadena-input-amount:decimal)
        @doc "Computes the KDA Split required for Native Gas Collection \
        \ This is 5% 5% 15% and 75% split, outputed as 5% 15% 75% in a list"
        (let*
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|DEC:module{OuronetDecimals} U|DEC)
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))


                (five:decimal (ref-U|DEC::UC_Percent kadena-input-amount 5.0 kda-prec))
                (fifteen:decimal (ref-U|DEC::UC_Percent kadena-input-amount 15.0 kda-prec))
                (total:decimal (ref-U|DEC::UC_Percent kadena-input-amount 25.0 kda-prec))
                (rest:decimal (- kadena-input-amount total))
            )
            [five fifteen rest]
        )
    )
    (defun UDC_Makeid:string (ticker:string)
        @doc "Creates a Token Id from a string source as the Token Ticker \ 
            \ using the first 12 Characters of the prev-block-hash of (chain-data) as randomness source"
        (let
            (
                (dash "-")
                (twelve (take 12 (at "prev-block-hash" (chain-data))))
            )
            (concat [ticker dash twelve])
        )
    )
    (defun UDC_MakeMVXNonce:string (nonce:integer)
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
)