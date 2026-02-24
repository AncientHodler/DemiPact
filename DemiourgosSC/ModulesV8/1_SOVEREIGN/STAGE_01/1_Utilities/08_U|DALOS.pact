(module U|DALOS GOV
    ;;
    (implements UtilityDalosV1)
    (implements UtilityDalosGlyphs)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|U|DALOS_ADMIN)))
    (defcap GOV|U|DALOS_ADMIN ()
        (let
            (
                (ref-U|CT:module{OuronetConstantsV1} U|CT)
                (g:guard (ref-U|CT::CT_GOV|UTILS))
            )
            (enforce-guard g)
        )
    )
    ;;{G3}
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
    (defun UC_TenTwentyThirtyFourtySplit:[decimal] (input:decimal ip:integer)
        (let
            (
                (v1:decimal (floor (* 0.1 input) ip))
                (v2:decimal (* 2.0 v1))
                (v3:decimal (* 3.0 v1))
                (v4:decimal (- input(fold (+) 0.0 [v1 v2 v3])))
            )
            [v1 v2 v3 v4]
        )
    )
    (defun UC_DirectFilterId:[string] (listoflists:[[string]] account:string)
        @doc "Helper Function needed for returning DALOS ids for Account <account>"
        (let
            (
                (ref-U|LST:module{StringProcessorV1} U|LST)
                (result
                    (fold
                        (lambda
                            (acc:[string] item:[string])
                            (if (= (ref-U|LST::UC_LE item) account)
                                (ref-U|LST::UC_AppL acc
                                    (if (= (length item) 2)
                                        (ref-U|LST::UC_FE item)
                                        (UC_ConcatWithBar (drop -1 item))
                                    )
                                )
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
    (defun UC_InverseFilterId:[string] (listoflists:[[string]] account:string)
        @doc "Helper Function needed for returning DALOS ids for Account <account>"
        (let
            (
                (ref-U|LST:module{StringProcessorV1} U|LST)
                (result
                    (fold
                        (lambda
                            (acc:[string] item:[string])
                            (if (= (UC_ConcatWithBar (drop -1 item)) account)
                                (ref-U|LST::UC_AppL acc
                                    (ref-U|LST::UC_LE item)
                                )
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
    (defun UC_ConcatWithBar:string (input:[string])
        (let
            (
                (ref-U|CT:module{OuronetConstantsV1} U|CT)
                (ref-U|LST:module{StringProcessorV1} U|LST)
                (b:string (ref-U|CT::CT_BAR))
                (folded-lst:[string]
                    (fold
                        (lambda
                            (acc:[string] idx:integer)
                            (if (!= idx (- (length input) 1))
                                (ref-U|LST::UC_AppL acc (+ (at idx input) b))
                                (ref-U|LST::UC_AppL acc (at idx input))
                            )
                        )
                        []
                        (enumerate 0 (- (length input) 1))
                    )
                )
            )
            (fold (+) "" folded-lst)
            
        )
    )
    (defun UC_GasCost (base-cost:decimal major:integer minor:integer native:bool)
        @doc "Computes gas costs (ignis or kda) based on input <base-cost> and <minor> and <major> Elite Tier"
        (* (/ (- 100.0 (UC_GasDiscount major minor native)) 100.0) base-cost)
    )
    (defun UC_GasDiscount (major:integer minor:integer native:bool)
        @doc "Computes the discount applied to base gas cost \
        \ Native <true> = 24.5% Reduction maximum at Tier 7.7 for KDA Costs \
        \ Not Native <false> = 49.5% Reduction maximum at Tier 7.7 for IGNIS Costs"
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
    (defun UC_IzCharacterANC:bool (c:string capital:bool iz-special:bool)
        @doc "Checks if a character is alphanumeric with or without Uppercase Only"
        (let*
            (
                (ref-U|CT:module{OuronetConstantsV1} U|CT)

                (cl:[string] (ref-U|CT::CT_CAPITAL_LETTERS))
                (n:[string] (ref-U|CT::CT_NUMBERS))
                (ncl:[string] (ref-U|CT::CT_NON_CAPITAL_LETTERS))
                (s:[string] (ref-U|CT::CT_SPECIAL))

                (c1:bool (or (contains c cl)(contains c n)))
                (c2:bool (or c1 (contains c ncl) ))
                (c3:bool (or c1 (contains c s)))
                (c4:bool (or c3 (contains c ncl)))
            )
            (if iz-special
                (if capital c3 c4)
                (if capital c1 c2)
            )
        )
    )
    (defun UC_IzStringANC:bool (s:string capital:bool iz-special:bool)
        @doc "Checks if a string is alphanumeric with or without Uppercase Only \
        \ Uppercase Only toggle is used by setting the capital boolean to true"
        (fold
            (lambda
                (acc:bool c:string)
                (and acc (UC_IzCharacterANC c capital iz-special))
            )
            true
            (str-to-list s)
        )
    )
    (defun UC_NewRoleList (current-lst:[string] account:string direction:bool)
        (let
            (
                (ref-U|CT:module{OuronetConstantsV1} U|CT)
                (ref-U|LST:module{StringProcessorV1} U|LST)
                (b:string (ref-U|CT::CT_BAR))
                (l:integer (length current-lst))
                (iz-within:bool (contains account current-lst))
            )
            (if direction
                (if
                    (and (= l 1) (= current-lst [b]))
                    [account]
                    (ref-U|LST::UC_AppL current-lst account)
                )
                (do
                    (enforce iz-within "When removing an Account, it must exist within!")
                    (if
                        (and (= l 1) (!= current-lst [b]))
                        [b]
                        (ref-U|LST::UC_RemoveItem current-lst account)
                    )
                )
            )
        )
    )
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
    (defun UEV_Decimals:bool (decimals:integer)
        @doc "Enforces the decimal size is DALOS precision conform"
        (let
            (
                (ref-U|CT:module{OuronetConstantsV1} U|CT)
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
                (ref-U|CT:module{OuronetConstantsV1} U|CT)
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
    (defun UEV_NameOrTicker:bool (name-ticker:string name-or-ticker:bool iz-special:bool)
        @doc "Enforces correct DALOS Token Name and/or Ticker specifications"
        (let*
            (
                (ref-U|CT:module{OuronetConstantsV1} U|CT)
                (nl (length name-ticker))
                (min:integer (ref-U|CT::CT_MIN_DESIGNATION_LENGTH))
                (max-n-standard:integer (ref-U|CT::CT_MAX_TOKEN_NAME_LENGTH))
                (max-t-standard:integer (ref-U|CT::CT_MAX_TOKEN_TICKER_LENGTH))
                (max-n-lp:integer (+ (* max-n-standard 7) 8))
                (max-t-lp:integer (+ (* max-t-standard 7) 11))
                (max-n:integer (if iz-special max-n-lp max-n-standard))
                (max-t:integer (if iz-special max-t-lp max-t-standard))
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
                (UC_IzStringANC name-ticker (not name-or-ticker) iz-special)
                "Designation does not conform character-wise"
            )
        )
    )
    ;;{F3}  [UDC]
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
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)