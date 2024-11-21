(module DALOS GOVERNANCE
    @doc "Demiourgos 0001 Module - DALOS (Dalos Blockchain and Gas Module) \
    \ Module 1 containing Primal Blocckchain Functions including Gas and Elite Account Functionality \
    \ \
    \ \
    \ Smart DALOS Accounts governed by the Module (1) \
    \ \
    \ 1)DALOS Smart Account (responsible for GAS Collection operations) \
    \ \
    \ \
    \ Submodules (3) \
    \ \
    \ 1]GLYPH - Character related operations \
    \ 2]DALOS - Dalos Module and Account related operations \
    \ 3]IGNIS - Gas related operations"

    ;;Module Governance
    (defcap GOVERNANCE ()
        (compose-capability (DALOS-ADMIN))
    )
    (defcap DALOS-ADMIN ()
        (enforce-guard G_DALOS)
    )
    ;;Module Guards
    (defconst G_DALOS   (keyset-ref-guard DALOS|DEMIURGOI))
    ;;Module Keys
    (defconst DALOS|DEMIURGOI "free.DH_Master-Keyset")
    ;;Module Accounts Information
    (defconst DALOS|SC_KEY "free.DH_SC_GAS-Keyset")
    (defconst DALOS|SC_NAME "Σ.W∇ЦwÏξБØnζΦψÕłěîбηжÛśTã∇țâĆã4ЬĚIŽȘØíÕlÛřбΩцμCšιÄиMkλ€УщшàфGřÞыÎäY8È₳BDÏÚmßOozBτòÊŸŹjПкцğ¥щóиś4h4ÑþююqςA9ÆúÛȚβжéÑψéУoЭπÄЩψďşõшżíZtZuψ4ѺËxЖψУÌбЧλüșěđΔjÈt0ΛŽZSÿΞЩŠ")    ;;Former GasTanker
    (defconst DALOS|SC_KDA-NAME (create-principal DALOS|GUARD))
    (defconst LIQUID|SC_NAME "Σ.śκν9₿ŻşYЙΣJΘÊO9jпF₿wŻ¥уPэõΣÑïoγΠθßÙzěŃ∇éÖиțșφΦτşэßιBιśiĘîéòюÚY$êFЬŤØ$868дyβT0ςъëÁwRγПŠτËMĚRПMaäЗэiЪiςΨoÞDŮěŠβLé4čØHπĂŃŻЫΣÀmăĐЗżłÄăiĞ₿йÎEσțłGΛЖΔŞx¥ÁiÙNğÅÌlγ¢ĎwдŃ")      ;;Former Liquidizer
    (defconst OUROBOROS|SC_NAME "Σ.4M0èÞbøXśαiΠ€NùÇèφqλËãØÓNCнÌπпЬ4γTмыżěуàđЫъмéLUœa₿ĞЬŒѺrËQęíùÅЬ¥τ9£φď6pÙ8ìжôYиșîŻøbğůÞχEшäΞúзêŻöŃЮüŞöućЗßřьяÉżăŹCŸNÅìŸпĐżwüăŞãiÜą1ÃγänğhWg9ĚωG₳R0EùçGΨфχЗLπшhsMτξ")        ;;Former Ouroboros
    ;;External Module Usage
    (use coin)
    (use free.UTILS)

    ;;Module's Goverors
    (defcap DALOS|NATIVE-AUTOMATIC ()
        @doc "Capability needed for auto management of the <kadena-konto> associated with the Ouroboros Smart DALOS Account"
        true
    )
    (defconst DALOS|GUARD (create-capability-guard (DALOS|NATIVE-AUTOMATIC)))

    ;(defconst DALOS|CTO "k:50d6c59b21e5e6e55baecaa75a1007de37576bde12d8230dc82459cc01b9484b")
    ;(defconst DALOS|HOV "k:0cb30c0121ff919266121a99ff9359871818932211df94dae4137c29bc0e8f7e")
    ;(defconst DALOS|SC_KDA-NAME "k:e0eab7eda0754b0927cb496616a7ab153bfd5928aa18d19018712db9c5c5c0b9")
    ;(defconst OUROBOROS|SC_KDA-NAME "k:7c9cd45184af5f61b55178898e00404ec04f795e10fff14b1ea86f4c35ff3a1e")

    
    ;;========[D] DALOS-GAS-STATION============================================;;
    (implements gas-payer-v1)

    ;;GAS Payment Parameters
    (defconst MIN_GAS_PRICE:decimal 0.0000001)
    (defconst MAX_GAS_LIMIT:integer 100000)
    (defconst MAX_TX_CALLS:integer 5)

    (defcap GAS_PAYER:bool (user:string limit:integer price:decimal)
        (compose-capability (ALLOW_GAS))

        (enforce (= "exec" (at "tx-type" (read-msg))) "Inside an exec")
        (enforce (> (length (at "exec-code" (read-msg))) 0) "Tx at least one pact function")
        (enforce (<= (length (at "exec-code" (read-msg))) MAX_TX_CALLS) "Tx has too many pact functions")
        
        (let
            ( 
                (enforce-ns 
                    (lambda 
                        (i)
                        (let 
                            (
                                (code (at i (at "exec-code" (read-msg))))
                            )
                            (enforce 
                                (and
                                    (= "(BASIS." (take 7 code)) ;; Check for BASIS module
                                    (= "DPTF|C_" (take 7 (drop 7 code))) ;; Check for DPTF|C_ prefix
                                ) 
                                "only BASIS module and DPTF|C_ prefix allowed on top level"
                            )
                        )
                    )
                )
                (len (length (at "exec-code" (read-msg))))
            )
            (map (enforce-ns) (enumerate 0 (- len 1)))
        )

        (enforce-below-or-at-gas-price MIN_GAS_PRICE)
        (enforce-below-or-at-gas-limit MAX_GAS_LIMIT)
    )
    
    (defun InitGasStation ()
        (coin.create-account DALOS|SC_KDA-NAME (create-gas-payer-guard))
    )
    (defun create-gas-payer-guard:guard ()
        (UTILS.GUARD|UEV_Any [G_DALOS (Overunity)])
    )
    (defun Overunity:guard ()
        (create-user-guard (gas-payer-guard))
    )
    (defun gas-payer-guard ()
        (require-capability (coin.GAS))
        (require-capability (ALLOW_GAS))
    )
    (defcap ALLOW_GAS () true)
    ;;========[D] DALOS-GAS-STATION============================================;;

    ;;
    ;;
    ;;


    ;;Simple True Capabilities (3+1)
    (defcap DALOS|INCREMENT_NONCE ()
        @doc "Capability required to increment the DALOS nonce"
        true
    )
    (defcap IGNIS|COLLECTER ()
        @doc "Capability that allows for local Gas Collection"
        true
    )
    (defcap IGNIS|INCREMENT ()
        @doc "Capability required to increment spent GAS amounts, \
        \ both virtual (IGNIS), and native (KDA)"
        true
    )
    (defcap DALOS|INCREMENT_NONCE||IGNIS|COLLECTER ()
        @doc "Composed Capability for ease of use"
        (compose-capability (DALOS|INCREMENT_NONCE))
        (compose-capability (IGNIS|COLLECTER))
    )
    ;;True Capabilities
    (defcap DALOS|UP_BALANCE ()
        @doc "Capability required to update balance for a Primordial TrueFungible"
        true
    )

    ;;Policies
    (defun DALOS|A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (DALOS-ADMIN)
            (write DALOS|PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun DALOS|C_ReadPolicy:guard (policy-name:string)
        @doc "Reads the guard of a stored policy"
        (at "policy" (read DALOS|PoliciesTable policy-name ["policy"]))
    )

;;  1]CONSTANTS Definitions
    ;;1.1)Glyph and Charset Management
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
        (+
            DALOS|CHR_DIGITS 
            (+
                DALOS|CHR_CURRENCIES
                (+
                    DALOS|CHR_LATIN-B
                    (+
                        DALOS|CHR_LATIN-S
                        (+
                            DALOS|CHR_LATIN-EXT-B
                            (+
                                DALOS|CHR_LATIN-EXT-S
                                (+
                                    DALOS|CHR_GREEK-B
                                    (+
                                        DALOS|CHR_GREEK-S
                                        (+
                                            DALOS|CHR_CYRILLIC-B
                                            DALOS|CHR_CYRILLIC-S
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    (defconst DALOS|EXTENDED (+ DALOS|CHR_AUX DALOS|CHARSET))
    ;;1.2]Table Keys
    ;;[D] DALOS Table Keys
    (defconst DALOS|INFO "DalosInformation")
    (defconst DALOS|VGD "VirtualGasData")
    (defconst DALOS|PRICES "DalosPrices")

    ;;[G] GAS Constant Values
    (defconst GAS_EXCEPTION [DALOS|SC_NAME LIQUID|SC_NAME])
    (defconst GAS_QUARTER 0.25)     ;;Subunitary Amount earned by Smart DALOS Accounts via GAS Collection
    (defconst GAS_SMALLEST 1.00)
    (defconst GAS_SMALL 2.00)
    (defconst GAS_MEDIUM 3.00)
    (defconst GAS_BIG 4.00)
    (defconst GAS_BIGGEST 5.00)
    (defconst GAS_ISSUE 15.00)
    (defconst GAS_HUGE 500.00)

;;  2]SCHEMAS Definitions
    ;;[D] DALOS Schemas
    (defschema DALOS|GlyphsSchema
        u:[integer]     ;;Unicode Numbers
        c:string        ;;Unicode Code
        n:string        ;;Glyph Name
    )
    ;;DALOS Virtual Blockchain Properties
    (defschema DALOS|PolicySchema
        @doc "Schema that stores external policies, that are able to operate within this module"
        policy:guard
    )
    (defschema DALOS|PropertiesSchema
        @doc "Schema that stores DALOS Core Token IDs and Data"
        demiurgoi:[string]                  ;;Stores Demiurgoi DALOS Accounts
        unity-id:string                     ;;DALOS
        gas-source-id:string                ;;OUROBOROS
        gas-source-id-price:decimal         ;;OUROBOROS Price
        gas-id:string                       ;;IGNIS
        ats-gas-source-id:string            ;;AURYN
        elite-ats-gas-source-id:string      ;;ELITE-AURYN
        wrapped-kda-id:string               ;;DWK - Dalos Wrapped Kadena
        liquid-kda-id:string                ;;DLK - Dalos Liquid Kadena
    )
    (defschema DALOS|GasManagementSchema
        @doc "Schema that stores GAS Management Properties of the Virtual Blockchain \
        \ The boolean <virtual-gas-toggle> toggles wheter the virtual gas is enabled or not \
        \ The boolean <native-gas-toggle> toggles wheter the native gas is enabled or not"
        virtual-gas-tank:string             ;;IGNIS|SC_NAME = "GasTanker"
        virtual-gas-toggle:bool             ;;IGNIS collection toggle
        virtual-gas-spent:decimal           ;;IGNIS spent
        native-gas-toggle:bool              ;;KADENA collection toggle
        native-gas-spent:decimal            ;;KADENA spent
    )
    ;;DALOS Virtual Blockchain Prices
    (defschema DALOS|PricesSchema
        @doc "Schema that stores DALOS KDA prices for specific operations"
        standard:decimal                    ;; 10 KDA - Cost to deploy a standard DALOS Account
        smart:decimal                       ;; 25 KDA - Cost to deploy a smart DALOS Account
        dptf:decimal                        ;;200 KDA - Cost to issue a True Fungible Token (DPTF)
        dpmf:decimal                        ;;300 KDA - Cost to issue a Meta Fungible Token (DPMF)
        dpsf:decimal                        ;;400 KDA - Cost to issue a Semi Fungible Token (DPSF)
        dpnf:decimal                        ;;500 KDA - Cost to issue a Non  Fungible Token (DPNF)
        blue:decimal                        ;; 25 KDA - Cost to maintain Blue Check for Token per Month
    )
    ;;DALOS Account Information
    (defschema DALOS|AccountSchema
        @doc "Schema that stores DALOS Account Information"
        ;;==================================;;
        guard:guard                         ;;Guard of the DALOS Account
        kadena-konto:string                 ;;stores the underlying Kadena principal Account that was used to create the DALOS Account
                                            ;;this account is used for KDA payments. The guard for this account is not stored in this module
                                            ;;Rather the guard of the kadena account saved here, is stored in the table inside the coin module
        sovereign:string                    ;;Stores the Sovereign Account (Can only be a Standard DALOS Account)
                                            ;;The Sovereign Account, is the Account that has ownership of this Account;
                                            ;;For Normal DALOS Account, the Sovereign is itself (The Key of the Table Data)
                                            ;;For Smart DALOS Account, the Sovereign is another Normal DALOS Account
        governor:guard                      ;;Stores a guard that allows remote managing of the Smart Account via its own module
                                            ;;A Smart Account can only be managed by a single module this way
        ;;==================================;;
        smart-contract:bool                 ;;When true DALOS Account is a Smart DALOS Account, if <false> it is a Standard DALOS Account
        payable-as-smart-contract:bool      ;;when true, a Smart DALOS Account is payable by other Normal DALOS Accounts
        payable-by-smart-contract:bool      ;;when true, a Smart DALOS Account is payable by other Smart DALOS Accounts
        payable-by-method:bool              ;;when true, a Smart DALOS Account is payable only through special Functions
        ;;==================================;;
        nonce:integer                       ;;stores how many transactions the DALOS Account executed
        elite:object{DALOS|EliteSchema}
                                            ;;Primal DPTF Data
                                            ;;Ouroboros and Gas Info are stored at the DALOS Account Level
        ouroboros:object{DPTF|BalanceSchema}
        ignis:object{DPTF|BalanceSchema}
        ;;==================================;;
    )
    (defschema DPTF|BalanceSchema
        @doc "Schema that Stores Account Balances for DPTF Tokens (True Fungibles)\
            \ Key for the Table is a string composed of: <DPTF id> + UTILS.BAR + <account> \
            \ This ensure a single entry per DPTF id per account. \
            \ As an Exception OUROBOROS and IGNIS Account Data is Stored at the DALOS Account Level"
        balance:decimal
        ;;Special Roles
        role-burn:bool
        role-mint:bool
        role-transfer:bool
        role-fee-exemption:bool                         
        ;;States
        frozen:bool
    )
    (defconst DPTF|BLANK
        { "balance"                 : 0.0
        , "role-burn"               : false
        , "role-mint"               : false
        , "role-transfer"           : false
        , "role-fee-exemption"      : false
        , "frozen"                  : false }
    )
    (defschema DALOS|EliteSchema
        @doc "Schema that tracks DALOS Elite Account Information"
        class:string
        name:string
        tier:string
        deb:decimal
    )
    (defconst DALOS|PLEB
        { "class" : "NOVICE"
        , "name"  : "Infidel"
        , "tier"  : "0.0"
        , "deb"   : 1.0 }
    )
    (defconst DALOS|VOID
        { "class" : "VOID"
        , "name"  : "Undead"
        , "tier"  : "0.0"
        , "deb"   : 0.0 }
    )

;;  3]TABLES Definitions
    ;;[D] DALOS Tables
    (deftable DALOS|Glyphs:{DALOS|GlyphsSchema})
    ;;
    (deftable DALOS|PropertiesTable:{DALOS|PropertiesSchema})
    (deftable DALOS|GasManagementTable:{DALOS|GasManagementSchema})
    (deftable DALOS|PricesTable:{DALOS|PricesSchema})
    ;;
    (deftable DALOS|AccountTable:{DALOS|AccountSchema})
    (deftable DALOS|PoliciesTable:{DALOS|PolicySchema}) 
    

    ;;GLYPH Submodule
    (defun GLYPH|UEV_DalosAccountCheck (account:string)
        @doc "Checks if a string is a valid DALOS Account \
        \ Uses no enforcements, returns true if it checks, false if it doesnt"
        (let*
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
                (t5:bool (GLYPH|UEV_EnforceMultiStringDalosCharset (drop 2 account)))
                (t6:bool (and t4 t5))
            )
            (and t3 t6)
        )
    )
    (defun GLYPH|UEV_DalosAccount (account:string)
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
                    (checkup:bool (GLYPH|UEV_EnforceMultiStringDalosCharset (drop 2 account)))
                )
                (enforce checkup "Characters do not conform to the DALOS|CHARSET")
            )
        )
    )
    (defun GLYPH|UEV_EnforceMultiStringDalosCharset:bool (multi-s:string)
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
    (defun GLYPH|UR_StringLookup:[integer] (s:string)
        @doc "Returns the string Unicode as Bytes"
        (enforce (= (length s) 1) "A single string element must be used")
        (at "u" (read DALOS|Glyphs s ["u"]))
    )
    ;;
    ;;            DALOS             Submodule
    ;;
    ;;            CAPABILITIES      <0>
    ;;            FUNCTIONS         [9]
    ;;========[D] RESTRICTIONS=================================================;;
    ;;            Capabilities Functions                [CAP]
    ;;            Function Based Capabilities           [CF](have this tag)
    ;;            Enforcements and Validations          [UEV]
    ;;            Composed Capabilities                 [CC](dont have this tag)
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;            Data Read Functions                   [UR]
    ;;            Data Read and Computation Functions   [URC] and [UC]
    ;;            Data Creation|Composition Functions   [UCC]
    ;;            Administrative Usage Functions        [A]
    ;;            Client Usage Functions                [C]
    ;;            Auxiliary Usage Functions             [X]
    ;;=========================================================================;;
    ;;
    ;;            START
    ;;
    ;;========[D] RESTRICTIONS=================================================;;
    ;;            Capabilities Functions                [UC]
    (defun DALOS|CAP_EnforceAccountOwnership (account:string)
        @doc "Enforces DALOS Account Ownership"
        (let*
            (
                (type:bool (DALOS|UR_AccountType account))
            )
            (if type
                (DALOS|CAP_X_EnforceSmartAccount account)
                (DALOS|CAP_X_EnforceStandardAccount account)
            )
        )
    )
    (defun DALOS|CAP_X_EnforceStandardAccount (account:string)
        @doc "Enforces ownership parameters for a Standard DALOS Account"
        (let
            (
                (account-guard:guard (DALOS|UR_AccountGuard account))
                (sovereign:string (DALOS|UR_AccountSovereign account))
                (governor:guard (DALOS|UR_AccountGovernor account))
            )
            (enforce (= sovereign account) "Incompatible Sovereign detected for a Standard DALOS Account")
            (enforce (= account-guard governor) "Incompatible Governer Guard detected for Standard DALOS Account")
            (enforce-guard account-guard)
        )
    )
    (defun DALOS|CAP_X_EnforceSmartAccount (account:string)
        (let*
            (
                (account-guard:guard (DALOS|UR_AccountGuard account))
                (sovereign:string (DALOS|UR_AccountSovereign account))
                (sovereign-guard:guard (DALOS|UR_AccountGuard sovereign))
                (governor:guard (DALOS|UR_AccountGovernor account))
            )
            (enforce (!= sovereign account) "Incompatible Sovereign detected for Smart DALOS Account")
            (enforce-guard (UTILS.GUARD|UEV_Any [account-guard sovereign-guard governor]))
        )
    )
    ;;            Function Based Capabilities           [CF]
    (defcap DALOS|CF|OWNER (account:string)
        @doc "Capability that enforces DALOS Account Ownership"
        (DALOS|CAP_EnforceAccountOwnership account)
    )
    ;;            Enforcements and Validations          [UEV]
    (defun DALOS|UEV_Methodic (account:string method:bool)
        @doc "Enforce methodic operation for account"
        (if method
            (DALOS|CAP_EnforceAccountOwnership account)
            true
        )
    )
    (defun DALOS|UEV_EnforceAccountExists (dalos-account:string)
        @doc "Validates the existance of the <dalos-account> \
        \ Existance is checked, by reading its DEB \
        \ If the DEB is smaller than 1, which it cant happen, then the <dalos-account> doesnt exist."
        (with-default-read DALOS|AccountTable dalos-account
            { "elite" : DALOS|VOID }
            { "elite" := e }
            (let
                (
                    (deb:decimal (at "deb" e))
                )
                (enforce 
                    (>= deb 1.0)
                    (format "The {} DALOS Account doesnt exist" [dalos-account])
                )
            )
        )
    )
    (defun DALOS|UEV_EnforceAccountType (account:string smart:bool)
        @doc "Enforces that a DALOS Account is either Normal or Smart. Assumes <account> exists"
        (let
            (
                (x:bool (DALOS|UR_AccountType account))
                (first:string (take 1 account))
                (ouroboros:string "Ѻ")
                (sigma:string "Σ")
            )
            (if smart 
                (enforce (and (= first sigma) (= x true)) (format "Operation requires a Smart DALOS Account; Account {} isnt" [account]))
                (enforce (and (= first ouroboros) (= x false)) (format "Operation requires a Standard DALOS Account; Account {} isnt" [account]))
            )
        )
    )
    (defun DALOS|UEV_EnforceTransferability (sender:string receiver:string method:bool)
        @doc "Enforces transferability between <sender>, <receiver> and <method>"
        (let
            (
                (x:bool (DALOS|URC_Transferability sender receiver method))
            )
            (enforce (= x true) (format "Transferability between {} and {} with {} Method is not ensured" [sender receiver method]))
        )
    )
    (defun DALOS|UEV_SenderWithReceiver (sender:string receiver:string)
        @doc "Validates Account <sender> with Account <receiver> for transfer purposes; \
        \ Thats is, both accounts must exist, and must be different from one another"
        (DALOS|UEV_EnforceAccountExists sender)
        (DALOS|UEV_EnforceAccountExists receiver)
        (enforce (!= sender receiver) "Sender and Receiver must be different")
    )
    (defun DALOS|UEV_TwentyFourPrecision (amount:decimal)
        @doc "Enforces Decimal has 24 precision"
        (enforce
            (= (floor amount 24) amount)
            (format "The GAS Amount of {} is not a valid GAS Amount decimal wise" [amount])
        )
    )
    (defun IGNIS|UEV_VirtualState (state:bool)
        @doc "Enforces <virtual-gas-toggle> to <state>"
        (let
            (
                (t:bool (DALOS|UR_VirtualToggle))
            )
            (enforce (= t state) "Invalid virtual gas collection state!")
            (if (not state)
                (IGNIS|UEV_VirtualOnCondition)
                true
            )
        )
    )
    (defun IGNIS|UEV_VirtualOnCondition ()
        @doc "Enforcers conditions needed to turn the Virtual Gas Collection ON"
        (let
            (
                (ouro-id:string (DALOS|UR_OuroborosID))
                (gas-id:string (DALOS|UR_IgnisID))
            )
            (enforce (!= ouro-id UTILS.BAR) "OURO Id must be set for IGNIS Collection to turn ON!")
            (enforce (!= gas-id UTILS.BAR) "IGNIS Id must be set for IGNIS Collection to turn ON!")
            (enforce (!= gas-id ouro-id) "OURO and IGNIS id must be different for the IGNIS Collection to turn ON!")
        )
    )
    (defun IGNIS|UEV_NativeState (state:bool)
        @doc "Enforces <native-gas-toggle> to <state>"
        (let
            (
                (t:bool (DALOS|UR_NativeToggle))
            )
            (enforce (= t state) "Invalid native gas collection state!")
        )
    )
    ;;            Composed Capabilities                 [CC]
    (defcap DALOS|ROTATE_ACCOUNT (account:string)
        @doc "Capability required to rotate(update|change) DALOS Account information (Kadena-Konto and Guard)"
        (compose-capability (DALOS|CF|OWNER account))
        (compose-capability (DALOS|INCREMENT_NONCE||IGNIS|COLLECTER))
    )
    (defcap DALOS|ROTATE_SOVEREIGN (account:string new-sovereign:string)
        @doc "Capability required to rotate(update|change) the DALOS Account Sovereign"
        (compose-capability (DALOS|SOVEREIGN account new-sovereign))
        (compose-capability (DALOS|INCREMENT_NONCE||IGNIS|COLLECTER))
    )
    (defcap DALOS|SOVEREIGN (account:string new-sovereign:string)
        @doc "Core Capability needed to Rotate the Sovereign"
        (DALOS|CAP_EnforceAccountOwnership account)
        (DALOS|UEV_EnforceAccountType account true)
        (DALOS|UEV_EnforceAccountType new-sovereign false)
        (DALOS|UEV_SenderWithReceiver (DALOS|UR_AccountSovereign account) new-sovereign)
    )
    (defcap DALOS|ROTATE_GOVERNOR (account:string)
        @doc "Capability required to rotate(update|change) the DALOS Account Governor"
        (compose-capability (DALOS|GOVERNOR account))
        (compose-capability (DALOS|INCREMENT_NONCE||IGNIS|COLLECTER))
    )
    (defcap DALOS|GOVERNOR (account:string)
        @doc "Core Capability needed to Rotate the Governor"
        (DALOS|CAP_EnforceAccountOwnership account)
        (DALOS|UEV_EnforceAccountType account true)
    )
    (defcap DALOS|CONTROL_SMART-ACCOUNT (account:string pasc:bool pbsc:bool pbm:bool)
        @doc "Capability required to Control a Smart DALOS Account"
        (compose-capability (DALOS|CONTROL_SMART-ACCOUNT_CORE account pasc pbsc pbm))
        (compose-capability (DALOS|INCREMENT_NONCE||IGNIS|COLLECTER))
    )
    (defcap DALOS|CONTROL_SMART-ACCOUNT_CORE (account:string pasc:bool pbsc:bool pbm:bool)
        @doc "Core Capability required to Control a Smart DALOS Account"
        (compose-capability (DALOS|GOVERNOR account))
        (enforce (= (or (or pasc pbsc) pbm) true) "At least one Smart DALOS Account parameter must be true")
    )
    ;;
    (defcap IGNIS|PATRON (patron:string)
        @doc "Capability that ensures a DALOS account can act as gas payer, also enforcing its Guard"
        (DALOS|CAP_EnforceAccountOwnership patron)
        (DALOS|UEV_EnforceAccountType patron false)
    )
    (defcap IGNIS|COLLECT (patron:string active-account:string amount:decimal)
        @doc "Capability required to collect GAS"
        (compose-capability (IGNIS|PATRON patron))
        (let
            (
                (sender-type:bool (DALOS|UR_AccountType active-account))
            )
            (if sender-type
                (compose-capability (IGNIS|SMART_COLLECT patron active-account amount))
                (compose-capability (IGNIS|NORML_COLLECT patron amount))
            )
        )
    )
    (defcap IGNIS|NORML_COLLECT (patron:string amount:decimal)
        @doc "Capability required for collecting GAS when the <active-account> is a Standard DALOS Account"
        (let
            (
                (gas-id:string (DALOS|UR_IgnisID))
            )
            (if (!= gas-id UTILS.BAR)
                (compose-capability (IGNIS|NORML_COLLECT_CORE patron amount))
                true
            )
        )
    )
    (defcap IGNIS|NORML_COLLECT_CORE (patron:string amount:decimal)
        @doc "Core Capability used in <IGNIS|COLLECTER_STANDARD> Capability"
        (compose-capability (IGNIS|TRANSFER patron (DALOS|UR_Tanker) amount))
        (compose-capability (IGNIS|INCREMENT))
    )
    (defcap IGNIS|SMART_COLLECT (patron:string active-account:string amount:decimal)
        @doc "Capability required for collecting GAS when the <active-account> is a Smart DALOS Account"
        ;;03]Validate <amount> as a GAS amount
        (let
            (
                (gas-id:string (DALOS|UR_IgnisID))
            )
            (if (!= gas-id UTILS.BAR)
                (let*
                    (
                        (gas-pot:string (DALOS|UR_Tanker))
                        (quarter:decimal (* amount GAS_QUARTER))
                        (rest:decimal (- amount quarter))
                    )
                    (compose-capability (IGNIS|TRANSFER patron gas-pot rest))
                    (compose-capability (IGNIS|TRANSFER patron active-account quarter))
                    (compose-capability (IGNIS|INCREMENT))
                )
                true
            )
        )
    )
    (defcap IGNIS|TRANSFER (sender:string receiver:string ta:decimal)
        @doc "Capability required for transfering GAS"
        (enforce (!= sender receiver) "Sender and Receiver must be different")
        (DALOS|UEV_TwentyFourPrecision ta)
        (enforce (> ta 0.0) "Cannot debit|credit 0.0 or negative GAS amounts")
        (compose-capability (IGNIS|DEBIT sender))
        (compose-capability (IGNIS|CREDIT receiver))
    )
    (defcap IGNIS|DEBIT (sender:string)
        (DALOS|UEV_EnforceAccountExists sender)
        (DALOS|UEV_EnforceAccountType sender false)
        (compose-capability (DALOS|UP_BALANCE))
    )
    (defcap IGNIS|CREDIT (receiver:string)
        (DALOS|UEV_EnforceAccountExists receiver)
        (compose-capability (DALOS|UP_BALANCE))
    )
    (defcap IGNIS|TOGGLE (native:bool toggle:bool)
        @doc "Capability required to toggle virtual or native GAS to either on or off"
        (compose-capability (DALOS-ADMIN))
        (if native
            (IGNIS|UEV_NativeState (not toggle))
            (IGNIS|UEV_VirtualState (not toggle))
        )
    )
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;            Data Read Functions                   [UR]
    ;;            DALOS|PropertiesTable
    (defun DALOS|UR_DemiurgoiID:[string] ()
        @doc "Returns a string list with Demiurgoi DALOS Account IDs"
        (at "demiurgoi" (read DALOS|PropertiesTable DALOS|INFO ["demiurgoi"]))
    )
    (defun DALOS|UR_UnityID:string ()
        @doc "Returns the Unity ID"
        (at "unity-id" (read DALOS|PropertiesTable DALOS|INFO ["unity-id"]))
    )
    (defun DALOS|UR_OuroborosID:string ()
        @doc "Returns the Ouroboros ID"
        (at "gas-source-id" (read DALOS|PropertiesTable DALOS|INFO ["gas-source-id"]))
    )
    (defun DALOS|UR_OuroborosPrice:decimal ()
        @doc "Returns the Ouroboros ID"
        (at "gas-source-id-price" (read DALOS|PropertiesTable DALOS|INFO ["gas-source-id-price"]))
    )
    (defun DALOS|UR_IgnisID:string ()
        @doc "Returns the Ignis ID"
        (with-default-read DALOS|PropertiesTable DALOS|INFO 
            { "gas-id" :  UTILS.BAR }
            { "gas-id" := gas-id}
            gas-id
        )
    )
    (defun DALOS|UR_AurynID:string ()
        @doc "Returns the Auryn ID"
        (at "ats-gas-source-id" (read DALOS|PropertiesTable DALOS|INFO ["ats-gas-source-id"]))
    )
    (defun DALOS|UR_EliteAurynID:string ()
        @doc "Returns the Elite-Auryn ID"
        (at "elite-ats-gas-source-id" (read DALOS|PropertiesTable DALOS|INFO ["elite-ats-gas-source-id"]))
    )
    (defun DALOS|UR_WrappedKadenaID:string ()
        @doc "Returns the Wrapped KDA ID"
        (at "wrapped-kda-id" (read DALOS|PropertiesTable DALOS|INFO ["wrapped-kda-id"]))
    )
    (defun DALOS|UR_LiquidKadenaID:string ()
        @doc "Returns the Liquid KDA ID"
        (at "liquid-kda-id" (read DALOS|PropertiesTable DALOS|INFO ["liquid-kda-id"]))
    )
    ;;            DALOS|GasManagementTable
    (defun DALOS|UR_Tanker:string ()
        @doc "Returns as string the Gas Tanker Account"
        (at "virtual-gas-tank" (read DALOS|GasManagementTable DALOS|VGD ["virtual-gas-tank"]))
    )
    (defun DALOS|UR_VirtualToggle:bool ()
        @doc "Returns as boolean the Gas Toggle State"
        (with-default-read DALOS|GasManagementTable DALOS|VGD
            {"virtual-gas-toggle" : false}
            {"virtual-gas-toggle" := tg}
            tg
        )
    )
    (defun DALOS|UR_VirtualSpent:decimal ()
        @doc "Returns as decimal the amount of Virtual Gas Spent"
        (at "virtual-gas-spent" (read DALOS|GasManagementTable DALOS|VGD ["virtual-gas-spent"]))
    )
    (defun DALOS|UR_NativeToggle:bool ()
        @doc "Returns as boolean the Native Gas Toggle State"
        (with-default-read DALOS|GasManagementTable DALOS|VGD
            {"native-gas-toggle" : false}
            {"native-gas-toggle" := tg}
            tg
        )
    )
    (defun DALOS|UR_NativeSpent:decimal ()
        @doc "Returns as decimal the amount of Native Gas Spent"
        (at "native-gas-spent" (read DALOS|GasManagementTable DALOS|VGD ["native-gas-spent"]))
    )
    ;;            DALOS|PricesTable
    (defun DALOS|UR_Standard:decimal ()
        @doc "Returns the KDA price to deploy a Standard DALOS Account"
        (at "standard" (read DALOS|PricesTable DALOS|PRICES ["standard"]))
    )
    (defun DALOS|UR_Smart:decimal ()
        @doc "Returns the KDA price to deploy a Smart DALOS Account"
        (at "smart" (read DALOS|PricesTable DALOS|PRICES ["smart"]))
    )
    (defun DALOS|UR_True:decimal ()
        @doc "Returns the KDA price to issue a True Fungible Token"
        (at "dptf" (read DALOS|PricesTable DALOS|PRICES ["dptf"]))
    )
    (defun DALOS|UR_Meta:decimal ()
        @doc "Returns the KDA price to issue a Meta Fungible Token"
        (at "dpmf" (read DALOS|PricesTable DALOS|PRICES ["dpmf"]))
    )
    (defun DALOS|UR_Semi:decimal ()
        @doc "Returns the KDA price to issue a Semi Fungible Token"
        (at "dpsf" (read DALOS|PricesTable DALOS|PRICES ["dpsf"]))
    )
    (defun DALOS|UR_Non:decimal ()
        @doc "Returns the KDA price to issue a Non Fungible Token"
        (at "dpnf" (read DALOS|PricesTable DALOS|PRICES ["dpnf"]))
    )
    (defun DALOS|UR_Blue:decimal ()
        @doc "Returns the KDA price for a Blue Check"
        (at "blue" (read DALOS|PricesTable DALOS|PRICES ["blue"]))
    )
    ;;            DALOS|AccountTable
    (defun DALOS|UR_AccountGuard:guard (account:string)
        @doc "Returns DALOS Account <account> Guard"
        (at "guard" (read DALOS|AccountTable account ["guard"]))
    )
    (defun DALOS|UR_AccountKadena:string (account:string)
        @doc "Returns DALOS Account <kadena-konto> Account"
        (at "kadena-konto" (read DALOS|AccountTable account ["kadena-konto"]))
    )
    (defun DALOS|UR_AccountSovereign:string (account:string)
        @doc "Returns DALOS Account <sovereign> Account"
        (at "sovereign" (read DALOS|AccountTable account ["sovereign"]))
    )
    (defun DALOS|UR_AccountGovernor:guard (account:string)
        @doc "Returns DALOS Account <governor> Guard"
        (at "governor" (read DALOS|AccountTable account ["governor"]))
    )
    ;;
    (defun DALOS|UR_AccountProperties:[bool] (account:string)
        @doc "Returns a boolean list with DALOS Account Type properties"
        (with-default-read DALOS|AccountTable account
            { "smart-contract" : false, "payable-as-smart-contract" : false, "payable-by-smart-contract" : false, "payable-by-method" : false}
            { "smart-contract" := sc, "payable-as-smart-contract" := pasc, "payable-by-smart-contract" := pbsc, "payable-by-method" := pbm }
            [sc pasc pbsc pbm]
        )
    )
    (defun DALOS|UR_AccountType:bool (account:string)
        @doc "Returns DALOS Account <account> Boolean type"
        (at 0 (DALOS|UR_AccountProperties account))
    )
    (defun DALOS|UR_AccountPayableAs:bool (account:string)
        @doc "Returns DALOS Account <account> Boolean payables-as-smart-contract"
        (at 1 (DALOS|UR_AccountProperties account))
    )
    (defun DALOS|UR_AccountPayableBy:bool (account:string)
        @doc "Returns DALOS Account <account> Boolean payables-by-smart-contract"
        (at 2 (DALOS|UR_AccountProperties account))
    )
    (defun DALOS|UR_AccountPayableByMethod:bool (account:string)
    @doc "Returns DALOS Account <account> Boolean payables-by-smart-contract"
        (at 3 (DALOS|UR_AccountProperties account))
    )
    ;;
    (defun DALOS|UR_AccountNonce:integer (account:string)
        @doc "Returns DALOS Account <account> nonce value"
        (with-default-read DALOS|AccountTable account
            { "nonce" : 0 }
            { "nonce" := n }
            n
        )
    )
    (defun DALOS|UR_Elite (account:string)
        (with-default-read DALOS|AccountTable account
            { "elite" : DALOS|PLEB }
            { "elite" := e}
            e
        )
    )
    (defun DALOS|UR_Elite-Class (account:string)
        (at "class" (DALOS|UR_Elite account))
    )
    (defun DALOS|UR_Elite-Name (account:string)
        (at "name" (DALOS|UR_Elite account))
    )
    (defun DALOS|UR_Elite-Tier (account:string)
        (at "tier" (DALOS|UR_Elite account))
    )
    (defun DALOS|UR_Elite-Tier-Major:integer (account:string)
        (str-to-int (take 1 (DALOS|UR_Elite-Tier account)))
    )
    (defun DALOS|UR_Elite-Tier-Minor:integer (account:string)
        (str-to-int (take -1 (DALOS|UR_Elite-Tier account)))
    )
    (defun DALOS|UR_Elite-DEB (account:string)
        (at "deb" (DALOS|UR_Elite account))
    )
    ;;
    (defun DALOS|UR_TrueFungible:object{DPTF|BalanceSchema} (account:string snake-or-gas:bool)
        @doc "Reads either Ouroboros-DPTF Data <snake-or-gas> is true, or \
        \ Ignis-DPTF Data <snake-or-gas> is false, Ignis being the GAS Token"
        (if snake-or-gas
            (with-default-read DALOS|AccountTable account
                { "ouroboros" : DPTF|BLANK }
                { "ouroboros" := o}
                o
            )
            (with-default-read DALOS|AccountTable account
                { "ignis" : DPTF|BLANK }
                { "ignis" := i}
                i
            )
        )
    )
    (defun DALOS|UR_TrueFungible_AccountSupply:decimal (account:string snake-or-gas:bool)
        (at "balance" (DALOS|UR_TrueFungible account snake-or-gas))
    )
    (defun DALOS|UR_TrueFungible_AccountRoleBurn:bool (account:string snake-or-gas:bool)
        (at "role-burn" (DALOS|UR_TrueFungible account snake-or-gas))
    )
    (defun DALOS|UR_TrueFungible_AccountRoleMint:bool (account:string snake-or-gas:bool)
        (at "role-mint" (DALOS|UR_TrueFungible account snake-or-gas))
    )
    (defun DALOS|UR_TrueFungible_AccountRoleTransfer:bool (account:string snake-or-gas:bool)
        (at "role-transfer" (DALOS|UR_TrueFungible account snake-or-gas))
    )
    (defun DALOS|UR_TrueFungible_AccountRoleFeeExemption:bool (account:string snake-or-gas:bool)
        (at "role-fee-exemption" (DALOS|UR_TrueFungible account snake-or-gas))
    )
    (defun DALOS|UR_TrueFungible_AccountFreezeState:bool (account:string snake-or-gas:bool)
        (at "frozen" (DALOS|UR_TrueFungible account snake-or-gas))
    )
    ;;            Data Read and Computation Functions   [URC]
    (defun DALOS|URC_Transferability:bool (sender:string receiver:string method:bool)
        @doc "Computes transferability between 2 DALOS Accounts, <sender> and <receiver> given the input <method> \
        \ In the Context of Standard transfers, <method> is false \
        \ In the Context of transfers executed within the Module of a Smart DALOS Account, <method> is true"
        (DALOS|UEV_SenderWithReceiver sender receiver)
        (let
            (
                (s-sc:bool (DALOS|UR_AccountType sender))
                (r-sc:bool (DALOS|UR_AccountType receiver))
                (r-pasc:bool (DALOS|UR_AccountPayableAs receiver))
                (r-pbsc:bool (DALOS|UR_AccountPayableBy receiver))
                (r-mt:bool (DALOS|UR_AccountPayableByMethod receiver))
            )
            (if (= s-sc false)
                (if (= r-sc false)              ;;sender is normal
                    true                        ;;receiver is normal (Normal => Normal | Case 1)
                    (if (= method true)         ;;receiver is smart  (Normal => Smart | Case 3)
                        r-mt
                        r-pasc
                    )
                )
                (if (= r-sc false)              ;;sender is smart
                    true                        ;;receiver is normal (Smart => Normal | Case 4)
                    (if (= method true)         ;;receiver is false (Smart => Smart | Case 2)
                        r-mt
                        r-pbsc
                    )
                )
            )
        )
    )
    (defun DALOS|UC_Makeid:string (ticker:string)
        @doc "Creates a DPTF|DPMF id \ 
            \ using the first 12 Characters of the prev-block-hash of (chain-data) as randomness source"
        (UTILS.DALOS|UEV_TickerName ticker)
        (UTILS.DALOS|UCC_Makeid ticker)
    )
    ;;
    (defun IGNIS|URC_Exception (account:string)
        @doc "Checks if the account is on the IGNIS exemption List"
        (contains account GAS_EXCEPTION)
    )
    (defun IGNIS|URC_ZeroGAZ:bool (id:string sender:string receiver:string)
        @doc "Returns true if Virtual GAS cost is Zero (not yet toggled), \
        \ otherwise returns false; Uses (sender + receiver) Context"

        (let*
            (
                (t1:bool (IGNIS|URC_ZeroGAS id sender))
                (t2:bool (IGNIS|URC_Exception receiver))
            )
            (or t1 t2)
        )
    )
    (defun IGNIS|URC_ZeroGAS:bool (id:string sender:string)
        @doc "Returns true if Virtual GAS cost is Zero (not yet toggled), \
        \ otherwise returns false; Uses (sender only) Context"

        (let*
            (
                (t1:bool (IGNIS|URC_IsVirtualGasZeroAbsolutely id))
                (t2:bool (IGNIS|URC_Exception sender))
            )
            (or t1 t2)
        )
    )
    (defun IGNIS|URC_IsVirtualGasZeroAbsolutely:bool (id:string)
        @doc "Virtual Gas Collection is also false, if the Gas Token hasnt been set, \
        \ or if the token is the Gas Token (moving gas doesnt cost gas)"
        (let*
            (
                (t1:bool (IGNIS|URC_IsVirtualGasZero))
                (gas-id:string (DALOS|UR_IgnisID))
                (t2:bool (if (or (= gas-id UTILS.BAR)(= id gas-id)) true false))
            )
            (or t1 t2)
        )
    )
    (defun IGNIS|URC_IsVirtualGasZero:bool ()
        @doc "Checks if Virtual Gas Collection is toggled, returning false if it is"
        (if (DALOS|UR_VirtualToggle)
            false
            true
        )
    )
    (defun IGNIS|URC_IsNativeGasZero:bool ()
        @doc "Checks if VNative Gas Collection is toggled, returning false if it is"
        (if (DALOS|UR_NativeToggle)
            false
            true
        )
    )
    ;;            Data Creation|Composition Functions   [UCC]
    ;;            Administrative Usage Functions        [A]
    (defun IGNIS|A_Toggle (native:bool toggle:bool)
        @doc "Turns Native or Virtual Gas collection to <toggle>"
        (with-capability (IGNIS|TOGGLE native toggle)
            (IGNIS|X_Toggle native toggle)
        )
    )
    (defun IGNIS|A_SetSourcePrice (price:decimal)
        @doc "Sets the Gas Source Price in (dollars)$, \
        \ which determines how much IGNIS can be generated by sublimating OURO"
        (with-capability (DALOS-ADMIN)
            (IGNIS|X_UpdateSourcePrice price)
        )
    )
    (defun DALOS|A_UpdateStandard (price:decimal)
        @doc "Updates DALOS Kadena Cost for deploying a Standard DALOS Account"
        (with-capability (DALOS-ADMIN)
            (update DALOS|PricesTable DALOS|PRICES
                {"standard" : (floor price UTILS.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateSmart(price:decimal)
        @doc "Updates DALOS Kadena Cost for deploying a Smart DALOS Account"
        (with-capability (DALOS-ADMIN)
            (update DALOS|PricesTable DALOS|PRICES
                {"smart"     : (floor price UTILS.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateTrue(price:decimal)
        @doc "Updates DALOS Kadena Cost for issuing a DPTF Token"
        (with-capability (DALOS-ADMIN)
            (update DALOS|PricesTable DALOS|PRICES
                {"dptf"     : (floor price UTILS.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateMeta(price:decimal)
        @doc "Updates DALOS Kadena Cost for issuing a DPMF Token"
        (with-capability (DALOS-ADMIN)
            (update DALOS|PricesTable DALOS|PRICES
                {"dpmf"     : (floor price UTILS.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateSemi(price:decimal)
        @doc "Updates DALOS Kadena Cost for issuing a DPSF Token"
        (with-capability (DALOS-ADMIN)
            (update DALOS|PricesTable DALOS|PRICES
                {"dpsf"     : (floor price UTILS.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateNon(price:decimal)
        @doc "Updates DALOS Kadena Cost for issuing a DPNF Token"
        (with-capability (DALOS-ADMIN)
            (update DALOS|PricesTable DALOS|PRICES
                {"dpnf"     : (floor price UTILS.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateBlue(price:decimal)
        @doc "Updates DALOS Kadena Cost for the Blue Checker"
        (with-capability (DALOS-ADMIN)
            (update DALOS|PricesTable DALOS|PRICES
                {"blue"     : (floor price UTILS.KDA_PRECISION)}
            )
        )
    )
    ;;            Client Usage Functions                [C]
    (defun DALOS|C_TransferDalosFuel (sender:string receiver:string amount:decimal)
        @doc "Transfer KDA from sender to receiver \
        \ Sender and Receiver are KDA Accounts, not DALOS Accounts"
        (install-capability (coin.TRANSFER sender receiver amount))
        (coin.transfer sender receiver amount)
    )
    (defun DALOS|C_TransferRawDalosFuel (sender:string amount:decimal)
        @doc "Colects DALOS Fuel (KDA) and sends it to it destination."
        (let*
            (
                (kadena-split:[decimal] (UTILS.IGNIS|UC_KadenaSplit amount))
                (am0:decimal (at 0 kadena-split))
                (am1:decimal (at 1 kadena-split))
                (am2:decimal (at 2 kadena-split))
                (kda-sender:string (DALOS|UR_AccountKadena sender))

                (demiurgoi:[string] (DALOS|UR_DemiurgoiID))
                (kda-cto:string (DALOS|UR_AccountKadena (at 0 demiurgoi)))
                (kda-hov:string (DALOS|UR_AccountKadena (at 1 demiurgoi)))
                (kda-ouroboros:string (DALOS|UR_AccountKadena OUROBOROS|SC_NAME))
                (kda-dalos:string (DALOS|UR_AccountKadena DALOS|SC_NAME))
            )
            (DALOS|C_TransferDalosFuel kda-sender kda-cto am0)          ;; 5% to KDA-CTO
            (DALOS|C_TransferDalosFuel kda-sender kda-hov am0)          ;; 5% to KDA-HOV
            (DALOS|C_TransferDalosFuel kda-sender kda-ouroboros am1)    ;;15% to KDA-Ouroboros (to be used for Liquid Kadena Protocol Fueling)
            (DALOS|C_TransferDalosFuel kda-sender kda-dalos am2)        ;;75% to KDA-Dalos (to be used for DALOS Gas Station)
        )
    )
    (defun DALOS|C_DeployStandardAccount (account:string guard:guard kadena:string)
        @doc "Deploys a Standard DALOS Account"
        (let
            (
                (account-validation:bool (GLYPH|UEV_DalosAccount account))
                (first:string (take 1 account))
                (ouroboros:string "Ѻ")
            )
            (enforce account-validation (format "Account {} isn't a valid DALOS Account" [account]))
            (enforce (= first ouroboros) (format "Account {} doesn|t have the corrrect Format for a Standard DALOS Account" [account]))
        )
        ;(UTILS.UTILS|UEV_EnforceReserved kadena guard)
        (enforce-guard guard)
        ;;Creates DALOS|AccountTable Entry for the <account>
        (insert DALOS|AccountTable account
            { "guard"                       : guard
            , "kadena-konto"                : kadena
            , "sovereign"                   : account
            , "governor"                    : guard

            , "smart-contract"              : false
            , "payable-as-smart-contract"   : false
            , "payable-by-smart-contract"   : false
            , "payable-by-method"           : false
            
            , "nonce"                       : 0
            , "elite"                       : DALOS|PLEB
            , "ouroboros"                   : DPTF|BLANK
            , "ignis"                       : DPTF|BLANK
            }  
        )
        ;;Collect the Deployment fee as Raw KDA, if native Gas is set to ON
        (if (not (IGNIS|URC_IsNativeGasZero))
            (DALOS|C_TransferRawDalosFuel account (DALOS|UR_Standard))
            true
        )
    )
    (defun DALOS|C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string)
        @doc "Deploys a Smart DALOS Account"
        (let
            (
                (account-validation:bool (GLYPH|UEV_DalosAccount account))
                (first:string (take 1 account))
                (sigma:string "Σ")
            )
            (enforce account-validation (format "Account {} isn't a valid DALOS Account" [account]))
            (enforce (= first sigma) (format "Account {} doesn|t have the corrrect Format for a Smart DALOS Account" [account]))
        )
        (DALOS|UEV_EnforceAccountType sovereign false)
        ;(UTILS.UTILS|UEV_EnforceReserved kadena guard)
        (enforce-guard guard)
        ;;Creates DALOS|AccountTable Entry for the <account>
        (insert DALOS|AccountTable account
            { "guard"                       : guard
            , "kadena-konto"                : kadena
            , "sovereign"                   : sovereign
            , "governor"                    : guard

            , "smart-contract"              : true
            , "payable-as-smart-contract"   : false
            , "payable-by-smart-contract"   : false
            , "payable-by-method"           : true
            
            , "nonce"                       : 0
            , "elite"                       : DALOS|PLEB
            , "ouroboros"                   : DPTF|BLANK
            , "ignis"                       : DPTF|BLANK
            }  
        )
        ;;Collect the Deployment fee as Raw KDA, if native Gas is set to ON
        (if (not (IGNIS|URC_IsNativeGasZero))
            (DALOS|C_TransferRawDalosFuel account (DALOS|UR_Smart))
            true
        )
    )
    (defun DALOS|C_RotateGuard (patron:string account:string new-guard:guard safe:bool)
        @doc "Updates the Guard stored in the DALOS|AccountTable"
        (let
            (
                (ZG:bool (IGNIS|URC_IsVirtualGasZero))
            )
            (with-capability (DALOS|ROTATE_ACCOUNT account)
                (if (= ZG false)
                    (IGNIS|X_Collect patron account GAS_SMALL)
                    true
                )
                (DALOS|X_RotateGuard account new-guard safe)
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    (defun DALOS|C_RotateKadena (patron:string account:string kadena:string)
        @doc "Updates the Kadena Account stored in the DALOS|AccountTable"
        (let
            (
                (ZG:bool (IGNIS|URC_IsVirtualGasZero))
            )
            (with-capability (DALOS|ROTATE_ACCOUNT account)
                (if (= ZG false)
                    (IGNIS|X_Collect patron account GAS_SMALL)
                    true
                )
                (DALOS|X_RotateKadena account kadena)
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    (defun DALOS|C_RotateSovereign (patron:string account:string new-sovereign:string)
        @doc "Updates the Smart Account Sovereign Account \
        \ Only works for Smart DALOS Accounts"
        (let
            (
                (ZG:bool (IGNIS|URC_IsVirtualGasZero))
            )
            (with-capability (DALOS|ROTATE_SOVEREIGN account new-sovereign)
                (if (= ZG false)
                    (IGNIS|X_Collect patron account GAS_SMALL)
                    true
                )
                (DALOS|X_RotateSovereign account new-sovereign)
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    (defun DALOS|C_RotateGovernor (patron:string account:string governor:guard)
        @doc "Updates the Smart Account Governor, which is the Governing Module \
        \ Only works for Smart DALOS Accounts"
        (let
            (
                (ZG:bool (IGNIS|URC_IsVirtualGasZero))
            )
            (with-capability (DALOS|ROTATE_GOVERNOR account)
                (if (= ZG false)
                    (IGNIS|X_Collect patron account GAS_SMALL)
                    true
                )
                (DALOS|X_RotateGovernor account governor)
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    (defun DALOS|C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool)
        @doc "Manages Smart DALOS Account Type via boolean triggers"
        (let
            (
                (ZG:bool (IGNIS|URC_IsVirtualGasZero))
            )
            (with-capability (DALOS|CONTROL_SMART-ACCOUNT patron account payable-as-smart-contract payable-by-smart-contract)
                (if (= ZG false)
                    (IGNIS|X_Collect patron account GAS_SMALL)
                    true
                )
                (DALOS|X_UpdateSmartAccountParameters account payable-as-smart-contract payable-by-smart-contract payable-by-method)
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    ;;            Auxiliary Usage Functions             [X]
    (defun DALOS|X_RotateGuard (account:string new-guard:guard safe:bool)
        @doc "Updates DALOS Account Parameters"
        (require-capability (DALOS|CF|OWNER account))
        (if safe
            (enforce-guard new-guard)
            true
        )
        (update DALOS|AccountTable account
            {"guard"                        : new-guard}
        )
    )
    (defun DALOS|X_RotateKadena (account:string kadena:string)
        @doc "Updates DALOS Account Parameters"
        (require-capability (DALOS|CF|OWNER account))
        (update DALOS|AccountTable account
            {"kadena-konto"                  : kadena}
        )
    )
    (defun DALOS|X_RotateSovereign (account:string new-sovereign:string)
        @doc "Updates DALOS Account Sovereign"
        (require-capability (DALOS|SOVEREIGN account new-sovereign))
        (update DALOS|AccountTable account
            {"sovereign"                        : new-sovereign}
        )
    )
    (defun DALOS|X_RotateGovernor (account:string governor:guard)
        @doc "Updates DALOS Account Governor"
        (require-capability (DALOS|GOVERNOR account))
        (update DALOS|AccountTable account
            {"governor"                        : governor}
        )
    )
    (defun DALOS|X_UpdateSmartAccountParameters (account:string pasc:bool pbsc:bool pbm:bool)
        @doc "Updates DALOS Account Parameters"
        (require-capability (DALOS|CONTROL_SMART-ACCOUNT_CORE account pasc pbsc pbm))
        (update DALOS|AccountTable account
            {"payable-as-smart-contract"    : pasc
            ,"payable-by-smart-contract"    : pbsc
            ,"payable-by-method"            : pbm}
        )
    )

    (defun DALOS|X_UpdateElite (account:string amount:decimal)
        @doc "Updates Elite Account. Can only be called from BASIS Module \
        \ Because Functions that can read Elite-Aurynz Supply (the <amount>) are located there. \
        \ Only Standard DALOS Account can have their Elite Data Updated"
        ;;PROVENANCE
        (enforce-one
            "Update Elite Account not permitted"
            [
                (enforce-guard (DALOS|C_ReadPolicy "BASIS|UpdateElite"))
                (enforce-guard (DALOS|C_ReadPolicy "AUTOSTAKE|UpdateElite"))
            ]
        )
        ;;Function
        (DALOS|UEV_EnforceAccountType account false)
        (update DALOS|AccountTable account
            { "elite" : (UTILS.ATS|UCC_Elite amount)}
        )
    )
    (defun DALOS|X_IncrementNonce (client:string)
        @doc "Increments DALOS Account nonce, which store how many txs the DALOS Account executed \
        \ Can be called from DALOS and BASIS Modules"
        ;;PROVENANCE
        (enforce-one
            "Nonce increase not permitted"
            [
                (enforce-guard (create-capability-guard (DALOS|INCREMENT_NONCE)))
                (enforce-guard (DALOS|C_ReadPolicy "BASIS|IncrementDalosNonce"))
                (enforce-guard (DALOS|C_ReadPolicy "AUTOSTAKE|IncrementDalosNonce"))
            ]
        )
        ;;Function
        (with-read DALOS|AccountTable client
            { "nonce"                       := n }
            (update DALOS|AccountTable client { "nonce" : (+ n 1)})
        )
    )
    (defun IGNIS|X_Collect (patron:string active-account:string amount:decimal)
        @doc "Collects IGNIS as GAS \
        \ Can be called from DALOS and BASIS Modules"
        ;;PROVENANCE
        (enforce-one
            "Gas Collection not permitted"
            [
                (enforce-guard (create-capability-guard (IGNIS|COLLECTER)))
                (enforce-guard (DALOS|C_ReadPolicy "BASIS|GasCollection"))
                (enforce-guard (DALOS|C_ReadPolicy "AUTOSTAKE|GasCollection"))
            ]
        )
        ;;Function
        (with-capability (IGNIS|COLLECT patron active-account amount)
            (IGNIS|X_X_Collect patron active-account amount)
        )
    )
    (defun IGNIS|X_X_Collect (patron:string active-account:string amount:decimal)
        @doc "Core Function that Collects GAS"
        (require-capability (IGNIS|COLLECT patron active-account amount))
        (let
            (
                (sender-type:bool (DALOS|UR_AccountType active-account))
            )
            (if (= sender-type false)
                (IGNIS|X_CollectStandard patron amount)
                (IGNIS|X_CollectSmart patron active-account amount)
            )
        )
    )
    (defun IGNIS|X_CollectStandard (patron:string amount:decimal)
        @doc "Collects GAS when the <active-account> is a Standard DALOS Account"
        (require-capability (IGNIS|NORML_COLLECT patron amount))
        (IGNIS|X_Transfer patron (DALOS|UR_Tanker) amount)
        (IGNIS|X_Increment false amount)
    )
    (defun IGNIS|X_CollectSmart (patron:string active-account:string amount:decimal)
        @doc "Collects GAS when the <active-account> is a Smart DALOS Account"
        (require-capability (IGNIS|SMART_COLLECT patron active-account amount))
        (let*
            (
                (gas-pot:string (DALOS|UR_Tanker))
                (quarter:decimal (* amount GAS_QUARTER))
                (rest:decimal (- amount quarter))                
            )
            (IGNIS|X_Transfer patron gas-pot rest)    ;;Three Quarters goes to defined Gas-Tanker Account
            (IGNIS|X_Transfer patron active-account quarter)  ;;One Quarter goes to <Active-Account> because its a Smart DALOS Account
            (IGNIS|X_Increment false amount)          ;;Increment the amount of Virtual Gas Spent
        )
    )
    (defun IGNIS|X_Increment (native:bool increment:decimal)
        @doc "Increments either <native-gas-spent> or <virtual-gas-spent> \
        \ existing in the DALOS|GasManagementTable to <increment>"
        (require-capability (IGNIS|INCREMENT))
        (let
            (
                (current-gas-spent:decimal (DALOS|UR_VirtualSpent))
                (current-ngas-spent:decimal (DALOS|UR_NativeSpent))
            )
            (if (= native true)
                (update DALOS|GasManagementTable DALOS|VGD
                    {"native-gas-spent" : (+ current-ngas-spent increment)}
                )
                (update DALOS|GasManagementTable DALOS|VGD
                    {"virtual-gas-spent" : (+ current-gas-spent increment)}
                )
            )
        )
    )
    (defun IGNIS|X_Transfer (sender:string receiver:string ta:decimal)
        @doc "Core function used only for transfering GAS aka IGNIS Token \
        \ Transfer of IGNIS as GAS ALWAYS takes place, without taking the IGNIS Token DPTF Properties in Account"
        (require-capability (IGNIS|TRANSFER sender receiver ta))
        (IGNIS|X_Debit sender ta)
        (IGNIS|X_Credit receiver ta)

    )
    (defun IGNIS|X_Debit (sender:string ta:decimal)
        @doc "Core function for debiting IGNIS from an account \
        \ Protected by DebitGas Capability \
        \ <Sender> must exist as DALOS Standard Account"
        (require-capability (IGNIS|DEBIT sender))
        (let
            (
                (read-gas:decimal (DALOS|UR_TrueFungible_AccountSupply sender false))
            )
            (enforce (<= ta read-gas) "Insufficient GAS for GAS-Debiting")
            (DALOS|XO_UpdateBalance sender false (- read-gas ta))
        )
    )
    (defun IGNIS|X_Credit (receiver:string ta:decimal)
        @doc "Core function for crediting IGNIS to an account \
        \ Protected by CreditGas Capability.  \
        \ <Receiver> must exist as DALOS Standard or Smart Account"
        (require-capability (IGNIS|CREDIT receiver))
        (let
            (
                (read-gas:decimal (DALOS|UR_TrueFungible_AccountSupply receiver false))
            )
            (enforce (>= read-gas 0.0) "Impossible operation, negative GAS amounts detected")
            (DALOS|XO_UpdateBalance receiver false (+ read-gas ta))
        )
    )
    (defun IGNIS|X_UpdateSourcePrice (price:decimal)
        @doc "Updates <gas-source-price> existing in the GAS|PropertiesTable \
        \ Can be used from the SWAPER module, (Liqudity Pairs Module)"
        (enforce-one
            "Burn Not permitted"
            [
                (enforce-guard (create-capability-guard (DALOS-ADMIN)))
                (enforce-guard (DALOS|C_ReadPolicy "SWAPER|UpdateOuroborosPrice"))
            ]
        )
        (update DALOS|GasManagementTable DALOS|VGD
            {"gas-source-price" : price}
        )
    )
    (defun IGNIS|X_Toggle (native:bool toggle:bool)
        @doc "Updates <native-gas-toggle> or <virtual-gas-toggle> \
        \ existing in the DALOS|GasManagementTable to <toggle>"
        (require-capability (DALOS-ADMIN))
        (if (= native true)
            (update DALOS|GasManagementTable DALOS|VGD
                {"native-gas-toggle" : toggle}
            )
            (update DALOS|GasManagementTable DALOS|VGD
                {"virtual-gas-toggle" : toggle}
            )
        )
    )
    (defun DALOS|XO_UpdateBalance (account:string snake-or-gas:bool new-balance:decimal)
        @doc "Updates Mint Role with no remorse, while keeping other parameters intact"
        (enforce-one
            "Burn Not permitted"
            [
                (enforce-guard (create-capability-guard (DALOS|UP_BALANCE)))
                (enforce-guard (DALOS|C_ReadPolicy "BASIS|UpdatePrimordialBalance"))
            ]
        )
        (let*
            (
                (read-burn:bool (DALOS|UR_TrueFungible_AccountRoleBurn account snake-or-gas))
                (read-mint:bool (DALOS|UR_TrueFungible_AccountRoleMint account snake-or-gas))
                (read-transfer:bool (DALOS|UR_TrueFungible_AccountRoleTransfer account snake-or-gas))
                (read-fee-exemption:bool (DALOS|UR_TrueFungible_AccountRoleFeeExemption account snake-or-gas))
                (read-frozen:bool (DALOS|UR_TrueFungible_AccountFreezeState account snake-or-gas))
                (new-obj:object{DPTF|BalanceSchema} 
                    {"balance"              : new-balance
                    ,"role-burn"            : read-burn
                    ,"role-mint"            : read-mint
                    ,"role-transfer"        : read-transfer
                    ,"role-fee-exemption"   : read-fee-exemption
                    ,"frozen"               : read-frozen}
                )
            )
            (if snake-or-gas
                (update DALOS|AccountTable account
                    {"ouroboros" : new-obj}
                )
                (update DALOS|AccountTable account
                    {"ignis" : new-obj}
                )
            )
        )
    )
    (defun DALOS|XO_UpdateBurnRole (account:string snake-or-gas:bool new-burn:bool)
        @doc "Updates Mint Role with no remorse, while keeping other parameters intact"
        (enforce-guard (DALOS|C_ReadPolicy "BASIS|UpdatePrimordialData"))
        (let*
            (
                (read-balance:decimal (DALOS|UR_TrueFungible_AccountSupply account snake-or-gas))
                (read-mint:bool (DALOS|UR_TrueFungible_AccountRoleMint account snake-or-gas))
                (read-transfer:bool (DALOS|UR_TrueFungible_AccountRoleTransfer account snake-or-gas))
                (read-fee-exemption:bool (DALOS|UR_TrueFungible_AccountRoleFeeExemption account snake-or-gas))
                (read-frozen:bool (DALOS|UR_TrueFungible_AccountFreezeState account snake-or-gas))
                (new-obj:object{DPTF|BalanceSchema} 
                    {"balance"              : read-balance
                    ,"role-burn"            : new-burn
                    ,"role-mint"            : read-mint
                    ,"role-transfer"        : read-transfer
                    ,"role-fee-exemption"   : read-fee-exemption
                    ,"frozen"               : read-frozen}
                )
            )
            (if snake-or-gas
                (update DALOS|AccountTable account
                    {"ouroboros" : new-obj}
                )
                (update DALOS|AccountTable account
                    {"ignis" : new-obj}
                )
            )
        )
    )
    (defun DALOS|XO_UpdateMintRole (account:string snake-or-gas:bool new-mint:bool)
        @doc "Updates Mint Role with no remorse, while keeping other parameters intact"
        (enforce-guard (DALOS|C_ReadPolicy "BASIS|UpdatePrimordialData"))
        (let*
            (
                (read-balance:decimal (DALOS|UR_TrueFungible_AccountSupply account snake-or-gas))
                (read-burn:bool (DALOS|UR_TrueFungible_AccountRoleBurn account snake-or-gas))
                (read-transfer:bool (DALOS|UR_TrueFungible_AccountRoleTransfer account snake-or-gas))
                (read-fee-exemption:bool (DALOS|UR_TrueFungible_AccountRoleFeeExemption account snake-or-gas))
                (read-frozen:bool (DALOS|UR_TrueFungible_AccountFreezeState account snake-or-gas))
                (new-obj:object{DPTF|BalanceSchema} 
                    {"balance"              : read-balance
                    ,"role-burn"            : read-burn
                    ,"role-mint"            : new-mint
                    ,"role-transfer"        : read-transfer
                    ,"role-fee-exemption"   : read-fee-exemption
                    ,"frozen"               : read-frozen}
                )
            )
            (if snake-or-gas
                (update DALOS|AccountTable account
                    {"ouroboros" : new-obj}
                )
                (update DALOS|AccountTable account
                    {"ignis" : new-obj}
                )
            )
        )
    )
    (defun DALOS|XO_UpdateTransferRole (account:string snake-or-gas:bool new-transfer:bool)
        @doc "Updates Transfer Role with no remorse, while keeping other parameters intact"
        (enforce-guard (DALOS|C_ReadPolicy "BASIS|UpdatePrimordialData"))
        (let*
            (
                (read-balance:decimal (DALOS|UR_TrueFungible_AccountSupply account snake-or-gas))
                (read-burn:bool (DALOS|UR_TrueFungible_AccountRoleBurn account snake-or-gas))
                (read-mint:bool (DALOS|UR_TrueFungible_AccountRoleMint account snake-or-gas))
                (read-fee-exemption:bool (DALOS|UR_TrueFungible_AccountRoleFeeExemption account snake-or-gas))
                (read-frozen:bool (DALOS|UR_TrueFungible_AccountFreezeState account snake-or-gas))
                (new-obj:object{DPTF|BalanceSchema} 
                    {"balance"              : read-balance
                    ,"role-burn"            : read-burn
                    ,"role-mint"            : read-mint
                    ,"role-transfer"        : new-transfer
                    ,"role-fee-exemption"   : read-fee-exemption
                    ,"frozen"               : read-frozen}
                )
            )
            (if snake-or-gas
                (update DALOS|AccountTable account
                    {"ouroboros" : new-obj}
                )
                (update DALOS|AccountTable account
                    {"ignis" : new-obj}
                )
            )
        )
    )
    (defun DALOS|XO_UpdateFeeExemptionRole (account:string snake-or-gas:bool new-fee-exemption:bool)
        @doc "Updates Fee-Exemption Role with no remorse, while keeping other parameters intact"
        (enforce-guard (DALOS|C_ReadPolicy "BASIS|UpdatePrimordialData"))
        (let*
            (
                (read-balance:decimal (DALOS|UR_TrueFungible_AccountSupply account snake-or-gas))
                (read-burn:bool (DALOS|UR_TrueFungible_AccountRoleBurn account snake-or-gas))
                (read-mint:bool (DALOS|UR_TrueFungible_AccountRoleMint account snake-or-gas))
                (read-transfer:bool (DALOS|UR_TrueFungible_AccountRoleTransfer account snake-or-gas))
                (read-frozen:bool (DALOS|UR_TrueFungible_AccountFreezeState account snake-or-gas))
                (new-obj:object{DPTF|BalanceSchema} 
                    {"balance"              : read-balance
                    ,"role-burn"            : read-burn
                    ,"role-mint"            : read-mint
                    ,"role-transfer"        : read-transfer
                    ,"role-fee-exemption"   : new-fee-exemption
                    ,"frozen"               : read-frozen}
                )
            )
            (if snake-or-gas
                (update DALOS|AccountTable account
                    {"ouroboros" : new-obj}
                )
                (update DALOS|AccountTable account
                    {"ignis" : new-obj}
                )
            )
        )
    )
    (defun DALOS|XO_UpdateFreeze (account:string snake-or-gas:bool new-freeze:bool)
        @doc "Updates Freeze Value with no remorse, while keeping other parameters intact"
        (enforce-guard (DALOS|C_ReadPolicy "BASIS|UpdatePrimordialData"))
        (let*
            (
                (read-balance:decimal (DALOS|UR_TrueFungible_AccountSupply account snake-or-gas))
                (read-burn:bool (DALOS|UR_TrueFungible_AccountRoleBurn account snake-or-gas))
                (read-mint:bool (DALOS|UR_TrueFungible_AccountRoleMint account snake-or-gas))
                (read-transfer:bool (DALOS|UR_TrueFungible_AccountRoleTransfer account snake-or-gas))
                (read-fee-exemption:bool (DALOS|UR_TrueFungible_AccountRoleFeeExemption account snake-or-gas))
                (new-obj:object{DPTF|BalanceSchema} 
                    {"balance"              : read-balance
                    ,"role-burn"            : read-burn
                    ,"role-mint"            : read-mint
                    ,"role-transfer"        : read-transfer
                    ,"role-fee-exemption"   : read-fee-exemption
                    ,"frozen"               : new-freeze}
                )
            )
            (if snake-or-gas
                (update DALOS|AccountTable account
                    {"ouroboros" : new-obj}
                )
                (update DALOS|AccountTable account
                    {"ignis" : new-obj}
                )
            )
        )
    )
)

(create-table DALOS|Glyphs)
(create-table DALOS|PoliciesTable)

(create-table DALOS|PropertiesTable)
(create-table DALOS|GasManagementTable)
(create-table DALOS|PricesTable)

(create-table DALOS|AccountTable)