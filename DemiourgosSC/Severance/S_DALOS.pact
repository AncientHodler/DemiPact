(module DALOS GOVERNANCE
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
            \ Remove Comment below so that only ADMIN (<free.DH_Master-Keyset>) can enact an upgrade"
        ;;true
        (compose-capability (DEMIURGOI))
    )
    ;;[D] DALOS Governance
    (defcap DEMIURGOI ()
        @doc "Capability enforcing the DALOS Demiurgoi admins"
        (enforce-guard (keyset-ref-guard DALOS|DEMIURGOI))
    )
    ;;[D] Demiurgoi IDs
    (defconst DALOS|DEMIURGOI "free.DH_Master-Keyset")                                
    (defconst DALOS|CTO "k:50d6c59b21e5e6e55baecaa75a1007de37576bde12d8230dc82459cc01b9484b")
    (defconst DALOS|HOV "k:0cb30c0121ff919266121a99ff9359871818932211df94dae4137c29bc0e8f7e")
    ;;[T] Ouroboros Account ids for DPTF Submodule
    (defconst OUROBOROS|SC_KEY "free.DH_SC_Ouroboros-Keyset")
    (defconst OUROBOROS|SC_NAME "Ouroboros")
    (defconst OUROBOROS|SC_KDA-NAME "k:7c9cd45184af5f61b55178898e00404ec04f795e10fff14b1ea86f4c35ff3a1e")
    ;;[G] GasTanker Account ids for GAS Submodule
    (defconst GAS|SC_KEY "free.DH_SC_GAS-Keyset")
    (defconst GAS|SC_NAME "GasTanker")
    (defconst GAS|SC_KDA-NAME "k:e0eab7eda0754b0927cb496616a7ab153bfd5928aa18d19018712db9c5c5c0b9")
    ;;[L] Liquidizer Account ids for LIQUID Submodule
    (defconst LIQUID|SC_KEY "free.DH_SC_KadenaLiquidStaking-Keyset")
    (defconst LIQUID|SC_NAME "Liquidizer")
    (defconst LIQUID|SC_KDA-NAME "k:a3506391811789fe88c4b8507069016eeb9946f3cb6d0b6214e700c343187c98")
    ;;[A] Autostake Account ids for ATS Submodule
    (defconst ATS|SC_KEY "free.DH_SC_Autostake-Keyset")
    (defconst ATS|SC_NAME "DalosAutostake")
    (defconst ATS|SC_KDA-NAME "k:89faf537ec7282d55488de28c454448a20659607adc52f875da30a4fd4ed2d12")
    ;;[V] Vesting Account ids for Vesting Submodule
    (defconst VST|SC_KEY "free.DH_SC_Vesting-Keyset")
    (defconst VST|SC_NAME "DalosVesting")
    (defconst VST|SC_KDA-NAME "k:4728327e1b4790cb5eb4c3b3c531ba1aed00e86cd9f6252bfb78f71c44822d6d")

    ;;1.2]Table Keys
    ;;[D] DALOS Table Keys
    (defconst DALOS|INFO "DalosInformation")
    (defconst DALOS|VGD "VirtualGasData")
    (defconst DALOS|PRICES "DalosPrices")

    ;;[G] GAS Constant Values
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
    (defschema DALOS|PropertiesSchema
        unity-id:string
        gas-source-id:string
        gas-source-id-price:decimal
        gas-id:string
        ats-gas-source-id:string
        elite-ats-gas-source-id:string
        wrapped-kda-id:string
        liquid-kda-id:string
    )
    (defschema DALOS|GasManagementSchema
        @doc "Schema that stores GAS Management Properties of the Virtual Blockchain \
        \ The boolean <virtual-gas-toggle> toggles wheter the virtual gas is enabled or not \
        \ The boolean <native-gas-toggle> toggles wheter the native gas is enabled or not"
        virtual-gas-tank:string
        virtual-gas-toggle:bool
        virtual-gas-spent:decimal
        native-gas-toggle:bool
        native-gas-spent:decimal
    )
    ;;DALOS Virtual Blockchain Prices
    (defschema DALOS|PricesSchema
        @doc "Schema that stores DALOS KDA prices for specific operations"
        standard:decimal
        smart:decimal
        dptf:decimal
        dpmf:decimal
        dpsf:decimal
        dpnf:decimal
        blue:decimal
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
        governor:string                     ;;Stores the Governing Module String.
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
            \ Key for the Table is a string composed of: <DPTF id> + UTILITY.BAR + <account> \
            \ This ensure a single entry per DPTF id per account."
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
    (deftable DALOS|PropertiesTable:{DALOS|PropertiesSchema})
    (deftable DALOS|PricesTable:{DALOS|PricesSchema})
    (deftable DALOS|AccountTable:{DALOS|AccountSchema})    
    (deftable DALOS|Glyphs:{DALOS|GlyphsSchema})

;;  4)Glyph and Charset Management
    (defun DALOS|A_WriteGlyphs ()
        @doc "Populates the DALOS|Glyphs Table"
        ;;Dalos Auxilliary 32 Glyphs
        (insert DALOS|Glyphs " " { "u" : [32], "c" : "U+0020", "n" : "Space"})
        (insert DALOS|Glyphs "!" { "u" : [33], "c" : "U+0021", "n" : "Exclamation Mark"})
        (insert DALOS|Glyphs "\"" { "u" : [34], "c" : "U+0022", "n" : "Quotation Mark"})
        (insert DALOS|Glyphs "#" { "u" : [35], "c" : "U+0023", "n" : "Number Sign (Hash)"})
        (insert DALOS|Glyphs "%" { "u" : [37], "c" : "U+0025", "n" : "Percent Sign"})
        (insert DALOS|Glyphs "&" { "u" : [38], "c" : "U+0026", "n" : "Ampersand"})
        (insert DALOS|Glyphs "'" { "u" : [39], "c" : "U+0027", "n" : "Apostrophe"})
        (insert DALOS|Glyphs "(" { "u" : [40], "c" : "U+0028", "n" : "Left Parenthesis"})
        (insert DALOS|Glyphs ")" { "u" : [41], "c" : "U+0029", "n" : "Right Parenthesis"})
        (insert DALOS|Glyphs "*" { "u" : [42], "c" : "U+002A", "n" : "Asterisk"})
        (insert DALOS|Glyphs "+" { "u" : [43], "c" : "U+002B", "n" : "Plus Sign"})
        (insert DALOS|Glyphs "," { "u" : [44], "c" : "U+002C", "n" : "Comma"})
        (insert DALOS|Glyphs "-" { "u" : [45], "c" : "U+002D", "n" : "Hyphen-Minus"})
        (insert DALOS|Glyphs "." { "u" : [46], "c" : "U+002E", "n" : "Full Stop"})
        (insert DALOS|Glyphs "/" { "u" : [47], "c" : "U+002F", "n" : "Solidus (Slash)"})
        (insert DALOS|Glyphs ":" { "u" : [58], "c" : "U+003A", "n" : "Colon"})
        (insert DALOS|Glyphs ";" { "u" : [59], "c" : "U+003B", "n" : "Semicolon"})
        (insert DALOS|Glyphs "<" { "u" : [60], "c" : "U+003C", "n" : "Less-Than Sign"})
        (insert DALOS|Glyphs "=" { "u" : [61], "c" : "U+003D", "n" : "Equals Sign"})
        (insert DALOS|Glyphs ">" { "u" : [62], "c" : "U+003E", "n" : "Greater-Than Sign"})
        (insert DALOS|Glyphs "?" { "u" : [63], "c" : "U+003F", "n" : "Question Mark"})
        (insert DALOS|Glyphs "@" { "u" : [64], "c" : "U+0040", "n" : "Commercial At"})
        (insert DALOS|Glyphs "[" { "u" : [91], "c" : "U+005B", "n" : "Left Square Bracket"})
        (insert DALOS|Glyphs "]" { "u" : [93], "c" : "U+005D", "n" : "Right Square Bracket"})
        (insert DALOS|Glyphs "^" { "u" : [94], "c" : "U+005E", "n" : "Circumflex Accent"})
        (insert DALOS|Glyphs "_" { "u" : [95], "c" : "U+005F", "n" : "Low Line (Underscore)"})
        (insert DALOS|Glyphs "`" { "u" : [96], "c" : "U+0060", "n" : "Grave Accent"})
        (insert DALOS|Glyphs "{" { "u" : [123], "c" : "U+007B", "n" : "Left Curly Bracket"})
        (insert DALOS|Glyphs "|" { "u" : [124], "c" : "U+007C", "n" : "Vertical Line"})
        (insert DALOS|Glyphs "}" { "u" : [125], "c" : "U+007D", "n" : "Right Curly Bracket"})
        (insert DALOS|Glyphs "~" { "u" : [126], "c" : "U+007E", "n" : "Tilde"})
        (insert DALOS|Glyphs "‰" { "u" : [137], "c" : "U+2030", "n" : "Per Mille Sign"})
        ;;Digits - 10 glyphs
        (insert DALOS|Glyphs "0" { "u" : [48], "c" : "U+0030", "n" : "Digit Zero"})
        (insert DALOS|Glyphs "1" { "u" : [49], "c" : "U+0031", "n" : "Digit One"})
        (insert DALOS|Glyphs "2" { "u" : [50], "c" : "U+0032", "n" : "Digit Two"})
        (insert DALOS|Glyphs "3" { "u" : [51], "c" : "U+0033", "n" : "Digit Three"})
        (insert DALOS|Glyphs "4" { "u" : [52], "c" : "U+0034", "n" : "Digit Four"})
        (insert DALOS|Glyphs "5" { "u" : [53], "c" : "U+0035", "n" : "Digit Five"})
        (insert DALOS|Glyphs "6" { "u" : [54], "c" : "U+0036", "n" : "Digit Six"})
        (insert DALOS|Glyphs "7" { "u" : [55], "c" : "U+0037", "n" : "Digit Seven"})
        (insert DALOS|Glyphs "8" { "u" : [56], "c" : "U+0038", "n" : "Digit Eight"})
        (insert DALOS|Glyphs "9" { "u" : [57], "c" : "U+0039", "n" : "Digit Nine"})
        ;;Currencies - 10 Glyphs
        (insert DALOS|Glyphs "Ѻ" { "u" : [209, 186], "c" : "U+047A", "n" : "Cyrillic Capital Letter Round Omega (OUROBOROS Currency)"})
        (insert DALOS|Glyphs "₿" { "u" : [226, 130, 191], "c" : "U+20BF", "n" : "Bitcoin Sign"})
        (insert DALOS|Glyphs "$" { "u" : [36], "c" : "U+0024", "n" : "Dollar Sign"})
        (insert DALOS|Glyphs "¢" { "u" : [194, 162], "c" : "U+00A2", "n" : "Cent Sign"})
        (insert DALOS|Glyphs "€" { "u" : [226, 130, 172], "c" : "U+20AC", "n" : "Euro Sign"})
        (insert DALOS|Glyphs "£" { "u" : [194, 163], "c" : "U+00A3", "n" : "Pound Sign"})
        (insert DALOS|Glyphs "¥" { "u" : [194, 165], "c" : "U+00A5", "n" : "Yen Sign"})
        (insert DALOS|Glyphs "₱" { "u" : [226, 130, 177], "c" : "U+20B1", "n" : "Peso Sign"})
        (insert DALOS|Glyphs "₳" { "u" : [226, 130, 179], "c" : "U+20B3", "n" : "Austral Sign (AURYN Currency)"})
        (insert DALOS|Glyphs "∇" { "u" : [226, 136, 135], "c" : "U+2207", "n" : "Nabla (TALOS Currency)"})
        ;;Latin Majuscules - 26 Glyphs
        (insert DALOS|Glyphs "A" { "u" : [65], "c" : "U+0041", "n" : "Latin Capital Letter A"})
        (insert DALOS|Glyphs "B" { "u" : [66], "c" : "U+0042", "n" : "Latin Capital Letter B"})
        (insert DALOS|Glyphs "C" { "u" : [67], "c" : "U+0043", "n" : "Latin Capital Letter C"})
        (insert DALOS|Glyphs "D" { "u" : [68], "c" : "U+0044", "n" : "Latin Capital Letter D"})
        (insert DALOS|Glyphs "E" { "u" : [69], "c" : "U+0045", "n" : "Latin Capital Letter E"})
        (insert DALOS|Glyphs "F" { "u" : [70], "c" : "U+0046", "n" : "Latin Capital Letter F"})
        (insert DALOS|Glyphs "G" { "u" : [71], "c" : "U+0047", "n" : "Latin Capital Letter G"})
        (insert DALOS|Glyphs "H" { "u" : [72], "c" : "U+0048", "n" : "Latin Capital Letter H"})
        (insert DALOS|Glyphs "I" { "u" : [73], "c" : "U+0049", "n" : "Latin Capital Letter I"})
        (insert DALOS|Glyphs "J" { "u" : [74], "c" : "U+004A", "n" : "Latin Capital Letter J"})
        (insert DALOS|Glyphs "K" { "u" : [75], "c" : "U+004B", "n" : "Latin Capital Letter K"})
        (insert DALOS|Glyphs "L" { "u" : [76], "c" : "U+004C", "n" : "Latin Capital Letter L"})
        (insert DALOS|Glyphs "M" { "u" : [77], "c" : "U+004D", "n" : "Latin Capital Letter M"})
        (insert DALOS|Glyphs "N" { "u" : [78], "c" : "U+004E", "n" : "Latin Capital Letter N"})
        (insert DALOS|Glyphs "O" { "u" : [79], "c" : "U+004F", "n" : "Latin Capital Letter O"})
        (insert DALOS|Glyphs "P" { "u" : [80], "c" : "U+0050", "n" : "Latin Capital Letter P"})
        (insert DALOS|Glyphs "Q" { "u" : [81], "c" : "U+0051", "n" : "Latin Capital Letter Q"})
        (insert DALOS|Glyphs "R" { "u" : [82], "c" : "U+0052", "n" : "Latin Capital Letter R"})
        (insert DALOS|Glyphs "S" { "u" : [83], "c" : "U+0053", "n" : "Latin Capital Letter S"})
        (insert DALOS|Glyphs "T" { "u" : [84], "c" : "U+0054", "n" : "Latin Capital Letter T"})
        (insert DALOS|Glyphs "U" { "u" : [85], "c" : "U+0055", "n" : "Latin Capital Letter U"})
        (insert DALOS|Glyphs "V" { "u" : [86], "c" : "U+0056", "n" : "Latin Capital Letter V"})
        (insert DALOS|Glyphs "W" { "u" : [87], "c" : "U+0057", "n" : "Latin Capital Letter W"})
        (insert DALOS|Glyphs "X" { "u" : [88], "c" : "U+0058", "n" : "Latin Capital Letter X"})
        (insert DALOS|Glyphs "Y" { "u" : [89], "c" : "U+0059", "n" : "Latin Capital Letter Y"})
        (insert DALOS|Glyphs "Z" { "u" : [90], "c" : "U+005A", "n" : "Latin Capital Letter Z"})
        ;;Latin Minuscules - 26 Glyphs
        (insert DALOS|Glyphs "a" { "u" : [97], "c" : "U+0061", "n" : "Latin Small Letter A"})
        (insert DALOS|Glyphs "b" { "u" : [98], "c" : "U+0062", "n" : "Latin Small Letter B"})
        (insert DALOS|Glyphs "c" { "u" : [99], "c" : "U+0063", "n" : "Latin Small Letter C"})
        (insert DALOS|Glyphs "d" { "u" : [100], "c" : "U+0064", "n" : "Latin Small Letter D"})
        (insert DALOS|Glyphs "e" { "u" : [101], "c" : "U+0065", "n" : "Latin Small Letter E"})
        (insert DALOS|Glyphs "f" { "u" : [102], "c" : "U+0066", "n" : "Latin Small Letter F"})
        (insert DALOS|Glyphs "g" { "u" : [103], "c" : "U+0067", "n" : "Latin Small Letter G"})
        (insert DALOS|Glyphs "h" { "u" : [104], "c" : "U+0068", "n" : "Latin Small Letter H"})
        (insert DALOS|Glyphs "i" { "u" : [105], "c" : "U+0069", "n" : "Latin Small Letter I"})
        (insert DALOS|Glyphs "j" { "u" : [106], "c" : "U+006A", "n" : "Latin Small Letter J"})
        (insert DALOS|Glyphs "k" { "u" : [107], "c" : "U+006B", "n" : "Latin Small Letter K"})
        (insert DALOS|Glyphs "l" { "u" : [108], "c" : "U+006C", "n" : "Latin Small Letter L"})
        (insert DALOS|Glyphs "m" { "u" : [109], "c" : "U+006D", "n" : "Latin Small Letter M"})
        (insert DALOS|Glyphs "n" { "u" : [110], "c" : "U+006E", "n" : "Latin Small Letter N"})
        (insert DALOS|Glyphs "o" { "u" : [111], "c" : "U+006F", "n" : "Latin Small Letter O"})
        (insert DALOS|Glyphs "p" { "u" : [112], "c" : "U+0070", "n" : "Latin Small Letter P"})
        (insert DALOS|Glyphs "q" { "u" : [113], "c" : "U+0071", "n" : "Latin Small Letter Q"})
        (insert DALOS|Glyphs "r" { "u" : [114], "c" : "U+0072", "n" : "Latin Small Letter R"})
        (insert DALOS|Glyphs "s" { "u" : [115], "c" : "U+0073", "n" : "Latin Small Letter S"})
        (insert DALOS|Glyphs "t" { "u" : [116], "c" : "U+0074", "n" : "Latin Small Letter T"})
        (insert DALOS|Glyphs "u" { "u" : [117], "c" : "U+0075", "n" : "Latin Small Letter U"})
        (insert DALOS|Glyphs "v" { "u" : [118], "c" : "U+0076", "n" : "Latin Small Letter V"})
        (insert DALOS|Glyphs "w" { "u" : [119], "c" : "U+0077", "n" : "Latin Small Letter W"})
        (insert DALOS|Glyphs "x" { "u" : [120], "c" : "U+0078", "n" : "Latin Small Letter X"})
        (insert DALOS|Glyphs "y" { "u" : [121], "c" : "U+0079", "n" : "Latin Small Letter Y"})
        (insert DALOS|Glyphs "z" { "u" : [122], "c" : "U+007A", "n" : "Latin Small Letter Z"})
        ;;Latin Extended Majuscules - 53 Glyphs
        (insert DALOS|Glyphs "Æ" { "u" : [195, 134], "c" : "U+00C6", "n" : "Latin Capital Letter Ae"})
        (insert DALOS|Glyphs "Œ" { "u" : [197, 146], "c" : "U+0152", "n" : "Latin Capital Letter Oe"})
        (insert DALOS|Glyphs "Á" { "u" : [195, 129], "c" : "U+00C1", "n" : "Latin Capital Letter A with Acute"})
        (insert DALOS|Glyphs "Ă" { "u" : [196, 130], "c" : "U+0102", "n" : "Latin Capital Letter A with Breve"})
        (insert DALOS|Glyphs "Â" { "u" : [195, 130], "c" : "U+00C2", "n" : "Latin Capital Letter A with Circumflex"})
        (insert DALOS|Glyphs "Ä" { "u" : [195, 132], "c" : "U+00C4", "n" : "Latin Capital Letter A with Diaeresis"})
        (insert DALOS|Glyphs "À" { "u" : [195, 128], "c" : "U+00C0", "n" : "Latin Capital Letter A with Grave"})
        (insert DALOS|Glyphs "Ą" { "u" : [196, 132], "c" : "U+0104", "n" : "Latin Capital Letter A with Ogonek"})
        (insert DALOS|Glyphs "Å" { "u" : [195, 133], "c" : "U+00C5", "n" : "Latin Capital Letter A with Ring Above"})
        (insert DALOS|Glyphs "Ã" { "u" : [195, 131], "c" : "U+00C3", "n" : "Latin Capital Letter A with Tilde"})
        (insert DALOS|Glyphs "Ć" { "u" : [196, 134], "c" : "U+0106", "n" : "Latin Capital Letter C with Acute"})
        (insert DALOS|Glyphs "Č" { "u" : [196, 140], "c" : "U+010C", "n" : "Latin Capital Letter C with Caron"})
        (insert DALOS|Glyphs "Ç" { "u" : [195, 135], "c" : "U+00C7", "n" : "Latin Capital Letter C with Cedilla"})
        (insert DALOS|Glyphs "Ď" { "u" : [196, 142], "c" : "U+010E", "n" : "Latin Capital Letter D with Caron"})
        (insert DALOS|Glyphs "Đ" { "u" : [196, 144], "c" : "U+0110", "n" : "Latin Capital Letter D with Stroke"})
        (insert DALOS|Glyphs "É" { "u" : [195, 137], "c" : "U+00C9", "n" : "Latin Capital Letter E with Acute"})
        (insert DALOS|Glyphs "Ě" { "u" : [196, 154], "c" : "U+011A", "n" : "Latin Capital Letter E with Caron"})
        (insert DALOS|Glyphs "Ê" { "u" : [195, 138], "c" : "U+00CA", "n" : "Latin Capital Letter E with Circumflex"})
        (insert DALOS|Glyphs "Ë" { "u" : [195, 139], "c" : "U+00CB", "n" : "Latin Capital Letter E with Diaeresis"})
        (insert DALOS|Glyphs "È" { "u" : [195, 136], "c" : "U+00C8", "n" : "Latin Capital Letter E with Grave"})
        (insert DALOS|Glyphs "Ę" { "u" : [196, 152], "c" : "U+0118", "n" : "Latin Capital Letter E with Ogonek"})
        (insert DALOS|Glyphs "Ğ" { "u" : [196, 158], "c" : "U+011E", "n" : "Latin Capital Letter G with Breve"})
        (insert DALOS|Glyphs "Í" { "u" : [195, 141], "c" : "U+00CD", "n" : "Latin Capital Letter I with Acute"})
        (insert DALOS|Glyphs "Î" { "u" : [195, 142], "c" : "U+00CE", "n" : "Latin Capital Letter I with Circumflex"})
        (insert DALOS|Glyphs "Ï" { "u" : [195, 143], "c" : "U+00CF", "n" : "Latin Capital Letter I with Diaeresis"})
        (insert DALOS|Glyphs "Ì" { "u" : [195, 140], "c" : "U+00CC", "n" : "Latin Capital Letter I with Grave"})
        (insert DALOS|Glyphs "Ł" { "u" : [197, 129], "c" : "U+0141", "n" : "Latin Capital Letter L with Stroke"})
        (insert DALOS|Glyphs "Ń" { "u" : [197, 131], "c" : "U+0143", "n" : "Latin Capital Letter N with Acute"})
        (insert DALOS|Glyphs "Ñ" { "u" : [195, 145], "c" : "U+00D1", "n" : "Latin Capital Letter N with Tilde"})
        (insert DALOS|Glyphs "Ó" { "u" : [195, 147], "c" : "U+00D3", "n" : "Latin Capital Letter O with Acute"})
        (insert DALOS|Glyphs "Ô" { "u" : [195, 148], "c" : "U+00D4", "n" : "Latin Capital Letter O with Circumflex"})
        (insert DALOS|Glyphs "Ö" { "u" : [195, 150], "c" : "U+00D6", "n" : "Latin Capital Letter O with Diaeresis"})
        (insert DALOS|Glyphs "Ò" { "u" : [195, 146], "c" : "U+00D2", "n" : "Latin Capital Letter O with Grave"})
        (insert DALOS|Glyphs "Ø" { "u" : [195, 152], "c" : "U+00D8", "n" : "Latin Capital Letter O with Stroke"})
        (insert DALOS|Glyphs "Õ" { "u" : [195, 149], "c" : "U+00D5", "n" : "Latin Capital Letter O with Tilde"})
        (insert DALOS|Glyphs "Ř" { "u" : [197, 152], "c" : "U+0158", "n" : "Latin Capital Letter R with Caron"})
        (insert DALOS|Glyphs "Ś" { "u" : [197, 154], "c" : "U+015A", "n" : "Latin Capital Letter S with Acute"})
        (insert DALOS|Glyphs "Š" { "u" : [197, 160], "c" : "U+0160", "n" : "Latin Capital Letter S with Caron"})
        (insert DALOS|Glyphs "Ş" { "u" : [197, 158], "c" : "U+015E", "n" : "Latin Capital Letter S with Cedilla"})
        (insert DALOS|Glyphs "Ș" { "u" : [200, 152], "c" : "U+0218", "n" : "Latin Capital Letter S with Comma Below"})
        (insert DALOS|Glyphs "Þ" { "u" : [195, 158], "c" : "U+00DE", "n" : "Latin Capital Letter Thorn"})
        (insert DALOS|Glyphs "Ť" { "u" : [197, 164], "c" : "U+0164", "n" : "Latin Capital Letter T with Caron"})
        (insert DALOS|Glyphs "Ț" { "u" : [200, 154], "c" : "U+021A", "n" : "Latin Capital Letter T with Comma Below"})
        (insert DALOS|Glyphs "Ú" { "u" : [195, 154], "c" : "U+00DA", "n" : "Latin Capital Letter U with Acute"})
        (insert DALOS|Glyphs "Û" { "u" : [195, 155], "c" : "U+00DB", "n" : "Latin Capital Letter U with Circumflex"})
        (insert DALOS|Glyphs "Ü" { "u" : [195, 156], "c" : "U+00DC", "n" : "Latin Capital Letter U with Diaeresis"})
        (insert DALOS|Glyphs "Ù" { "u" : [195, 153], "c" : "U+00D9", "n" : "Latin Capital Letter U with Grave"})
        (insert DALOS|Glyphs "Ů" { "u" : [197, 174], "c" : "U+016E", "n" : "Latin Capital Letter U with Ring Above"})
        (insert DALOS|Glyphs "Ý" { "u" : [195, 157], "c" : "U+00DD", "n" : "Latin Capital Letter Y with Acute"})
        (insert DALOS|Glyphs "Ÿ" { "u" : [195, 184], "c" : "U+00DC", "n" : "Latin Capital Letter U with Diaeresis"})
        (insert DALOS|Glyphs "Ź" { "u" : [197, 185], "c" : "U+0179", "n" : "Latin Capital Letter Z with Acute"})
        (insert DALOS|Glyphs "Ž" { "u" : [197, 189], "c" : "U+017D", "n" : "Latin Capital Letter Z with Caron"})
        (insert DALOS|Glyphs "Ż" { "u" : [197, 187], "c" : "U+017B", "n" : "Latin Capital Letter Z with Dot Above"})
        ;;Latin Extended Minuscules - 54 Glyphs
        (insert DALOS|Glyphs "æ" { "u" : [195, 166], "c" : "U+00E6", "n" : "Latin Small Letter Ae"})
        (insert DALOS|Glyphs "œ" { "u" : [197, 147], "c" : "U+0153", "n" : "Latin Small Letter Oe"})
        (insert DALOS|Glyphs "á" { "u" : [195, 161], "c" : "U+00E1", "n" : "Latin Small Letter A with Acute"})
        (insert DALOS|Glyphs "ă" { "u" : [196, 131], "c" : "U+0103", "n" : "Latin Small Letter A with Breve"})
        (insert DALOS|Glyphs "â" { "u" : [195, 162], "c" : "U+00E2", "n" : "Latin Small Letter A with Circumflex"})
        (insert DALOS|Glyphs "ä" { "u" : [195, 164], "c" : "U+00E4", "n" : "Latin Small Letter A with Diaeresis"})
        (insert DALOS|Glyphs "à" { "u" : [195, 160], "c" : "U+00E0", "n" : "Latin Small Letter A with Grave"})
        (insert DALOS|Glyphs "ą" { "u" : [196, 133], "c" : "U+0105", "n" : "Latin Small Letter A with Ogonek"})
        (insert DALOS|Glyphs "å" { "u" : [195, 165], "c" : "U+00E5", "n" : "Latin Small Letter A with Ring Above"})
        (insert DALOS|Glyphs "ã" { "u" : [195, 163], "c" : "U+00E3", "n" : "Latin Small Letter A with Tilde"})
        (insert DALOS|Glyphs "ć" { "u" : [196, 135], "c" : "U+0107", "n" : "Latin Small Letter C with Acute"})
        (insert DALOS|Glyphs "č" { "u" : [196, 141], "c" : "U+010D", "n" : "Latin Small Letter C with Caron"})
        (insert DALOS|Glyphs "ç" { "u" : [195, 167], "c" : "U+00E7", "n" : "Latin Small Letter C with Cedilla"})
        (insert DALOS|Glyphs "ď" { "u" : [196, 143], "c" : "U+010F", "n" : "Latin Small Letter D with Caron"})
        (insert DALOS|Glyphs "đ" { "u" : [196, 145], "c" : "U+0111", "n" : "Latin Small Letter D with Stroke"})
        (insert DALOS|Glyphs "é" { "u" : [195, 169], "c" : "U+00E9", "n" : "Latin Small Letter E with Acute"})
        (insert DALOS|Glyphs "ě" { "u" : [196, 155], "c" : "U+011B", "n" : "Latin Small Letter E with Caron"})
        (insert DALOS|Glyphs "ê" { "u" : [195, 170], "c" : "U+00EA", "n" : "Latin Small Letter E with Circumflex"})
        (insert DALOS|Glyphs "ë" { "u" : [195, 171], "c" : "U+00EB", "n" : "Latin Small Letter E with Diaeresis"})
        (insert DALOS|Glyphs "è" { "u" : [195, 168], "c" : "U+00E8", "n" : "Latin Small Letter E with Grave"})
        (insert DALOS|Glyphs "ę" { "u" : [196, 153], "c" : "U+0119", "n" : "Latin Small Letter E with Ogonek"})
        (insert DALOS|Glyphs "ğ" { "u" : [196, 159], "c" : "U+011F", "n" : "Latin Small Letter G with Breve"})
        (insert DALOS|Glyphs "í" { "u" : [195, 173], "c" : "U+00ED", "n" : "Latin Small Letter I with Acute"})
        (insert DALOS|Glyphs "î" { "u" : [195, 174], "c" : "U+00EE", "n" : "Latin Small Letter I with Circumflex"})
        (insert DALOS|Glyphs "ï" { "u" : [195, 175], "c" : "U+00EF", "n" : "Latin Small Letter I with Diaeresis"})
        (insert DALOS|Glyphs "ì" { "u" : [195, 172], "c" : "U+00EC", "n" : "Latin Small Letter I with Grave"})
        (insert DALOS|Glyphs "ł" { "u" : [197, 130], "c" : "U+0142", "n" : "Latin Small Letter L with Stroke"})
        (insert DALOS|Glyphs "ń" { "u" : [197, 132], "c" : "U+0144", "n" : "Latin Small Letter N with Acute"})
        (insert DALOS|Glyphs "ñ" { "u" : [195, 177], "c" : "U+00F1", "n" : "Latin Small Letter N with Tilde"})
        (insert DALOS|Glyphs "ó" { "u" : [195, 179], "c" : "U+00F3", "n" : "Latin Small Letter O with Acute"})
        (insert DALOS|Glyphs "ô" { "u" : [195, 180], "c" : "U+00F4", "n" : "Latin Small Letter O with Circumflex"})
        (insert DALOS|Glyphs "ö" { "u" : [195, 182], "c" : "U+00F6", "n" : "Latin Small Letter O with Diaeresis"})
        (insert DALOS|Glyphs "ò" { "u" : [195, 178], "c" : "U+00F2", "n" : "Latin Small Letter O with Grave"})
        (insert DALOS|Glyphs "ø" { "u" : [195, 184], "c" : "U+00F8", "n" : "Latin Small Letter O with Stroke"})
        (insert DALOS|Glyphs "õ" { "u" : [195, 181], "c" : "U+00F5", "n" : "Latin Small Letter O with Tilde"})
        (insert DALOS|Glyphs "ř" { "u" : [197, 153], "c" : "U+0159", "n" : "Latin Small Letter R with Caron"})
        (insert DALOS|Glyphs "ś" { "u" : [197, 155], "c" : "U+015B", "n" : "Latin Small Letter S with Acute"})
        (insert DALOS|Glyphs "š" { "u" : [197, 161], "c" : "U+0161", "n" : "Latin Small Letter S with Caron"})
        (insert DALOS|Glyphs "ş" { "u" : [197, 159], "c" : "U+015F", "n" : "Latin Small Letter S with Cedilla"})
        (insert DALOS|Glyphs "ș" { "u" : [200, 153], "c" : "U+0219", "n" : "Latin Small Letter S with Comma Below"})
        (insert DALOS|Glyphs "þ" { "u" : [195, 190], "c" : "U+00FE", "n" : "Latin Small Letter Thorn"})
        (insert DALOS|Glyphs "ť" { "u" : [197, 165], "c" : "U+0165", "n" : "Latin Small Letter T with Caron"})
        (insert DALOS|Glyphs "ț" { "u" : [200, 155], "c" : "U+021B", "n" : "Latin Small Letter T with Comma Below"})
        (insert DALOS|Glyphs "ú" { "u" : [195, 186], "c" : "U+00FA", "n" : "Latin Small Letter U with Acute"})
        (insert DALOS|Glyphs "û" { "u" : [195, 187], "c" : "U+00FB", "n" : "Latin Small Letter U with Circumflex"})
        (insert DALOS|Glyphs "ü" { "u" : [195, 188], "c" : "U+00FC", "n" : "Latin Small Letter U with Diaeresis"})
        (insert DALOS|Glyphs "ù" { "u" : [195, 185], "c" : "U+00F9", "n" : "Latin Small Letter U with Grave"})
        (insert DALOS|Glyphs "ů" { "u" : [197, 175], "c" : "U+016F", "n" : "Latin Small Letter U with Ring Above"})
        (insert DALOS|Glyphs "ý" { "u" : [195, 189], "c" : "U+00FD", "n" : "Latin Small Letter Y with Acute"})
        (insert DALOS|Glyphs "ÿ" { "u" : [195, 191], "c" : "U+00FF", "n" : "Latin Small Letter Y with Diaeresis"})
        (insert DALOS|Glyphs "ź" { "u" : [197, 186], "c" : "U+017A", "n" : "Latin Small Letter Z with Acute"})
        (insert DALOS|Glyphs "ž" { "u" : [197, 190], "c" : "U+017E", "n" : "Latin Small Letter Z with Caron"})
        (insert DALOS|Glyphs "ż" { "u" : [197, 188], "c" : "U+017C", "n" : "Latin Small Letter Z with Dot Above"})
        (insert DALOS|Glyphs "ß" { "u" : [195, 159], "c" : "U+00DF", "n" : "Latin Small Letter Sharp S"})
        ;;Greek Majuscules - 10 Glyphs
        (insert DALOS|Glyphs "Γ" { "u" : [206, 147], "c" : "U+0393", "n" : "Greek Capital Letter Gamma"})
        (insert DALOS|Glyphs "Δ" { "u" : [206, 148], "c" : "U+0394", "n" : "Greek Capital Letter Delta"})
        (insert DALOS|Glyphs "Θ" { "u" : [206, 152], "c" : "U+0398", "n" : "Greek Capital Letter Theta"})
        (insert DALOS|Glyphs "Λ" { "u" : [206, 155], "c" : "U+039B", "n" : "Greek Capital Letter Lambda"})
        (insert DALOS|Glyphs "Ξ" { "u" : [206, 158], "c" : "U+039E", "n" : "Greek Capital Letter Xi"})
        (insert DALOS|Glyphs "Π" { "u" : [206, 160], "c" : "U+03A0", "n" : "Greek Capital Letter Pi"})
        (insert DALOS|Glyphs "Σ" { "u" : [206, 163], "c" : "U+03A3", "n" : "Greek Capital Letter Sigma"})
        (insert DALOS|Glyphs "Φ" { "u" : [206, 166], "c" : "U+03A6", "n" : "Greek Capital Letter Phi"})
        (insert DALOS|Glyphs "Ψ" { "u" : [206, 168], "c" : "U+03A8", "n" : "Greek Capital Letter Psi"})
        (insert DALOS|Glyphs "Ω" { "u" : [206, 169], "c" : "U+03A9", "n" : "Greek Capital Letter Omega"})
        ;;Greek Minuscules - 19 Glyphs
        (insert DALOS|Glyphs "α" { "u" : [206, 177], "c" : "U+03B1", "n" : "Greek Small Letter Alpha"})
        (insert DALOS|Glyphs "β" { "u" : [206, 178], "c" : "U+03B2", "n" : "Greek Small Letter Beta"})
        (insert DALOS|Glyphs "γ" { "u" : [206, 179], "c" : "U+03B3", "n" : "Greek Small Letter Gamma"})
        (insert DALOS|Glyphs "δ" { "u" : [206, 180], "c" : "U+03B4", "n" : "Greek Small Letter Delta"})
        (insert DALOS|Glyphs "ε" { "u" : [206, 181], "c" : "U+03B5", "n" : "Greek Small Letter Epsilon"})
        (insert DALOS|Glyphs "ζ" { "u" : [206, 182], "c" : "U+03B6", "n" : "Greek Small Letter Zeta"})
        (insert DALOS|Glyphs "η" { "u" : [206, 183], "c" : "U+03B7", "n" : "Greek Small Letter Eta"})
        (insert DALOS|Glyphs "θ" { "u" : [206, 184], "c" : "U+03B8", "n" : "Greek Small Letter Theta"})
        (insert DALOS|Glyphs "ι" { "u" : [206, 185], "c" : "U+03B9", "n" : "Greek Small Letter Iota"})
        (insert DALOS|Glyphs "κ" { "u" : [206, 186], "c" : "U+03BA", "n" : "Greek Small Letter Kappa"})
        (insert DALOS|Glyphs "λ" { "u" : [206, 187], "c" : "U+03BB", "n" : "Greek Small Letter Lambda"})
        (insert DALOS|Glyphs "μ" { "u" : [206, 188], "c" : "U+03BC", "n" : "Greek Small Letter Mu"})
        (insert DALOS|Glyphs "ν" { "u" : [206, 189], "c" : "U+03BD", "n" : "Greek Small Letter Nu"})
        (insert DALOS|Glyphs "ξ" { "u" : [206, 190], "c" : "U+03BE", "n" : "Greek Small Letter Xi"})
        (insert DALOS|Glyphs "π" { "u" : [206, 192], "c" : "U+03C0", "n" : "Greek Small Letter Pi"})
        (insert DALOS|Glyphs "ρ" { "u" : [206, 193], "c" : "U+03C1", "n" : "Greek Small Letter Rho"})
        (insert DALOS|Glyphs "σ" { "u" : [206, 195], "c" : "U+03C3", "n" : "Greek Small Letter Sigma"})
        (insert DALOS|Glyphs "ς" { "u" : [206, 194], "c" : "U+03C2", "n" : "Greek Small Letter Final Sigma"})
        (insert DALOS|Glyphs "τ" { "u" : [206, 196], "c" : "U+03C4", "n" : "Greek Small Letter Tau"})
        (insert DALOS|Glyphs "φ" { "u" : [206, 198], "c" : "U+03C6", "n" : "Greek Small Letter Phi"})
        (insert DALOS|Glyphs "χ" { "u" : [206, 199], "c" : "U+03C7", "n" : "Greek Small Letter Chi"})
        (insert DALOS|Glyphs "ψ" { "u" : [206, 200], "c" : "U+03C8", "n" : "Greek Small Letter Psi"})
        (insert DALOS|Glyphs "ω" { "u" : [206, 201], "c" : "U+03C9", "n" : "Greek Small Letter Omega"})
        ;;Cyrillic Majuscules - 19 Glyphs
        (insert DALOS|Glyphs "Б" { "u" : [208, 145], "c" : "U+0411", "n" : "Cyrillic Capital Letter Be"})
        (insert DALOS|Glyphs "Д" { "u" : [208, 148], "c" : "U+0414", "n" : "Cyrillic Capital Letter De"})
        (insert DALOS|Glyphs "Ж" { "u" : [208, 150], "c" : "U+0416", "n" : "Cyrillic Capital Letter Zhe"})
        (insert DALOS|Glyphs "З" { "u" : [208, 151], "c" : "U+0417", "n" : "Cyrillic Capital Letter Ze"})
        (insert DALOS|Glyphs "И" { "u" : [208, 152], "c" : "U+0418", "n" : "Cyrillic Capital Letter I"})
        (insert DALOS|Glyphs "Й" { "u" : [208, 153], "c" : "U+0419", "n" : "Cyrillic Capital Letter Short I"})
        (insert DALOS|Glyphs "Л" { "u" : [208, 155], "c" : "U+041B", "n" : "Cyrillic Capital Letter El"})
        (insert DALOS|Glyphs "П" { "u" : [208, 159], "c" : "U+041F", "n" : "Cyrillic Capital Letter Pe"})
        (insert DALOS|Glyphs "У" { "u" : [208, 163], "c" : "U+0423", "n" : "Cyrillic Capital Letter U"})
        (insert DALOS|Glyphs "Ц" { "u" : [208, 166], "c" : "U+0426", "n" : "Cyrillic Capital Letter Tse"})
        (insert DALOS|Glyphs "Ч" { "u" : [208, 167], "c" : "U+0427", "n" : "Cyrillic Capital Letter Che"})
        (insert DALOS|Glyphs "Ш" { "u" : [208, 168], "c" : "U+0428", "n" : "Cyrillic Capital Letter Sha"})
        (insert DALOS|Glyphs "Щ" { "u" : [208, 169], "c" : "U+0429", "n" : "Cyrillic Capital Letter Shcha"})
        (insert DALOS|Glyphs "Ъ" { "u" : [208, 170], "c" : "U+042A", "n" : "Cyrillic Capital Letter Hard Sign"})
        (insert DALOS|Glyphs "Ы" { "u" : [208, 171], "c" : "U+042B", "n" : "Cyrillic Capital Letter Yeru"})
        (insert DALOS|Glyphs "Ь" { "u" : [208, 172], "c" : "U+042C", "n" : "Cyrillic Capital Letter Soft Sign"})
        (insert DALOS|Glyphs "Э" { "u" : [208, 173], "c" : "U+042D", "n" : "Cyrillic Capital Letter E"})
        (insert DALOS|Glyphs "Ю" { "u" : [208, 174], "c" : "U+042E", "n" : "Cyrillic Capital Letter Yu"})
        (insert DALOS|Glyphs "Я" { "u" : [208, 175], "c" : "U+042F", "n" : "Cyrillic Capital Letter Ya"})
        ;;Cyrillic Minuscules - 25 Glyphs
        (insert DALOS|Glyphs "б" { "u" : [208, 177], "c" : "U+0431", "n" : "Cyrillic Small Letter Be"})
        (insert DALOS|Glyphs "в" { "u" : [208, 178], "c" : "U+0432", "n" : "Cyrillic Small Letter Ve"})
        (insert DALOS|Glyphs "д" { "u" : [208, 180], "c" : "U+0434", "n" : "Cyrillic Small Letter De"})
        (insert DALOS|Glyphs "ж" { "u" : [208, 182], "c" : "U+0436", "n" : "Cyrillic Small Letter Zhe"})
        (insert DALOS|Glyphs "з" { "u" : [208, 183], "c" : "U+0437", "n" : "Cyrillic Small Letter Ze"})
        (insert DALOS|Glyphs "и" { "u" : [208, 184], "c" : "U+0438", "n" : "Cyrillic Small Letter I"})
        (insert DALOS|Glyphs "й" { "u" : [208, 185], "c" : "U+0439", "n" : "Cyrillic Small Letter Short I"})
        (insert DALOS|Glyphs "к" { "u" : [208, 186], "c" : "U+043A", "n" : "Cyrillic Small Letter Ka"})
        (insert DALOS|Glyphs "л" { "u" : [208, 187], "c" : "U+043B", "n" : "Cyrillic Small Letter El"})
        (insert DALOS|Glyphs "м" { "u" : [208, 188], "c" : "U+043C", "n" : "Cyrillic Small Letter Em"})
        (insert DALOS|Glyphs "н" { "u" : [208, 189], "c" : "U+043D", "n" : "Cyrillic Small Letter En"})
        (insert DALOS|Glyphs "п" { "u" : [208, 191], "c" : "U+043F", "n" : "Cyrillic Small Letter Pe"})
        (insert DALOS|Glyphs "т" { "u" : [209, 130], "c" : "U+0442", "n" : "Cyrillic Small Letter Te"})
        (insert DALOS|Glyphs "у" { "u" : [209, 131], "c" : "U+0443", "n" : "Cyrillic Small Letter U"})
        (insert DALOS|Glyphs "ф" { "u" : [209, 132], "c" : "U+0444", "n" : "Cyrillic Small Letter Ef"})
        (insert DALOS|Glyphs "ц" { "u" : [209, 134], "c" : "U+0446", "n" : "Cyrillic Small Letter Tse"})
        (insert DALOS|Glyphs "ч" { "u" : [209, 135], "c" : "U+0447", "n" : "Cyrillic Small Letter Che"})
        (insert DALOS|Glyphs "ш" { "u" : [209, 136], "c" : "U+0448", "n" : "Cyrillic Small Letter Sha"})
        (insert DALOS|Glyphs "щ" { "u" : [209, 137], "c" : "U+0449", "n" : "Cyrillic Small Letter Shcha"})
        (insert DALOS|Glyphs "ъ" { "u" : [209, 138], "c" : "U+044A", "n" : "Cyrillic Small Letter Hard Sign"})
        (insert DALOS|Glyphs "ы" { "u" : [209, 139], "c" : "U+044B", "n" : "Cyrillic Small Letter Yeru"})
        (insert DALOS|Glyphs "ь" { "u" : [209, 140], "c" : "U+044C", "n" : "Cyrillic Small Letter Soft Sign"})
        (insert DALOS|Glyphs "э" { "u" : [209, 141], "c" : "U+044D", "n" : "Cyrillic Small Letter E"})
        (insert DALOS|Glyphs "ю" { "u" : [209, 142], "c" : "U+044E", "n" : "Cyrillic Small Letter Yu"})
        (insert DALOS|Glyphs "я" { "u" : [209, 143], "c" : "U+044F", "n" : "Cyrillic Small Letter Ya"})
    )
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
    
    (defun EnforceMultiStringDalosCharset:bool (multi-s:string)
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
    (defun StringLookup:[integer] (s:string)
        @doc "Returns the string Unicode as Bytes"
        (enforce (= (length s) 1) "A single string element must be used")
        (at "u" (read DALOS|Glyphs s ["u"]))
    )

    ;;DALOS Module Body

    ;;========[D] CAPABILITIES=================================================;;
    ;;1.1]    [D] DALOS Capabilities
    ;;1.1.1]  [D]   DALOS Basic Capabilities
    (defcap DALOS|EXIST (account:string)
        @doc "Enforces that a DALOS Account exists"
        (DALOS|UVE_id account)
    )
    (defcap DALOS|ACCOUNT_OWNER (account:string)
        @doc "Enforces DALOS Account Ownership"
        (enforce-guard (DALOS|UR_AccountGuard account))
    )
        (defun DALOS|EnforceSmartAccount (account:string)
            (with-capability (DALOS|ABS_ACCOUNT_OWNER account)
                true
            )
        )
    (defcap DALOS|ABS_ACCOUNT_OWNER (account:string)
        @doc "Enforces DALOS Account Ownership"
        (let*
            (
                (type:bool (DALOS|UR_AccountType account))
            )
            (if type
                (DALOS|EnforceSmartAccount_Core account)
                (DALOS|EnforceStandardAccount_Core account)
            )
        )
    )
    (defun DALOS|EnforceStandardAccount_Core (account:string)
        @doc "Enforces ownership parameters for a Standard DALOS Account"
        (let
            (
                (sovereign:string (DALOS|UR_AccountSovereign account))
                (governor:string (DALOS|UR_AccountGovernor account))
            )
            (enforce (= sovereign account) "Incompatible Sovereign for Standard DALOS Account")
            (enforce (= governor UTILITY.BAR) "Incompatible Governer for Standard DALOS Account")
            (enforce-guard (DALOS|UR_AccountGuard account))
        )
    )
    (defun DALOS|EnforceSmartAccount_Core (account:string)
        (let*
            (
                (sovereign:string (DALOS|UR_AccountSovereign account))
                (governor:string (DALOS|UR_AccountGovernor account))
                (gov:string (+ "(" governor))
                (lengov:integer (length gov))
            )
            (enforce (!= sovereign account) "Incompatible Sovereign for Smart DALOS Account")
            (enforce (!= governor UTILITY.BAR) "Incompatible Governor for Smart DALOS Account")
            (enforce-one
                "Insuficient Permissions to handle a Smart DALOS Account"
                [
                    (enforce-guard (DALOS|UR_AccountGuard account))
                    (enforce (= gov (take lengov (at 0 (at "exec-code" (read-msg))))) "Enforce Smart Contract Governance Module Usage")
                ]
            )
        )
    )
    (defcap DALOS|IZ_ACCOUNT_SMART (account:string smart:bool)
        @doc "Enforces that a DALOS Account is either Normal (<smart-contract> boolean false) or Smart (<smart-contract> boolean true) \
            \ If the input DALOS Account doesnt exist, it is considered Normal"
        (UTILITY.DALOS|UV_Account account)
        (let
            (
                (x:bool (DALOS|UR_AccountType account))
            )
            (if (= smart true)
                (enforce (= x true) (format "Account {} is not a SC Account, when it should have been, for the operation to execute" [account]))
                (enforce (= x false) (format "Account {} is a SC Account, when it shouldnt have been, for the operation to execute" [account]))
            )
        )
    )

    (defcap DALOS|TRANSFERABILITY (sender:string receiver:string)
        @doc "Enforces transferability between <sender> and <receiver>"
        (compose-capability (DALOS|METHODIC_TRANSFERABILITY sender receiver false))
    )
    (defcap DALOS|METHODIC_TRANSFERABILITY (sender:string receiver:string method:bool)
        @doc "Enforces transferability between <sender>, <receiver> and <method>"
        (let
            (
                (x:bool (DALOS|UC_MethodicTransferability sender receiver method))
            )
            (enforce (= x true) (format "Transferability between {} and {} with {} Method is not ensured" [sender receiver method]))
        )
    )
    (defcap DALOS|INCREASE-NONCE ()
        @doc "Capability required to increment the DALOS nonce"
        true
    )
    (defcap DALOS|UPDATE_ELITE ()
        @doc "Capability required to update Elite-Account Information"
        true
    )
    (defcap DALOS|EXECUTOR ()
        @doc "Capability Required to Execute DPTF, DPMF, ATS, VST Functions"
        true
    )

    ;;1.1.2]  [D]   DALOS Composed Capabilities
    (defcap DALOS|CLIENT (account:string)
        @doc "Enforces DALOS Account ownership if its a Standard DALOS Account \
            \ Fails if account doesnt exist via the last capability"
        @managed
        (let
            (
                (iz-sc:bool (DALOS|UR_AccountType account))
            )
            (if (= iz-sc true)
                true
                (compose-capability (DALOS|ACCOUNT_OWNER account))
            )
        )
    )
    (defcap DALOS|METHODIC (client:string method:bool)
        (if (= method true)
            (compose-capability (DALOS|IZ_ACCOUNT_SMART client true))
            (compose-capability (DALOS|ACCOUNT_OWNER client))
        )
    )

    ;;First Part
    (defcap DALOS|ROTATE_ACCOUNT (patron:string account:string)
        @doc "Capability required to rotate(update|change) DALOS Account information (Kadena-Konto and Guard)"
        (compose-capability (DALOS|ACCOUNT_OWNER account))   
        (compose-capability (GAS|COLLECTION patron account DALOS.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DALOS|ROTATE_SOVEREIGN (patron:string account:string new-sovereign:string)
        (compose-capability (DALOS|SOVEREIGN account new-sovereign))
        (compose-capability (GAS|COLLECTION patron account DALOS.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DALOS|SOVEREIGN (account:string new-sovereign:string)
        (compose-capability (DALOS|ACCOUNT_OWNER account)) 
        (compose-capability (DALOS|IZ_ACCOUNT_SMART account true))
        (compose-capability (DALOS|IZ_ACCOUNT_SMART new-sovereign false))
        (DALOS|UV_SenderWithReceiver (DALOS|UR_AccountSovereign account) new-sovereign)
    )
    (defcap DALOS|ROTATE_GOVERNOR (patron:string account:string governor:string)
        (compose-capability (DALOS|GOVERNOR account governor))
        (compose-capability (GAS|COLLECTION patron account DALOS.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DALOS|GOVERNOR (account:string governor:string)
        (compose-capability (DALOS|ACCOUNT_OWNER account)) 
        (compose-capability (DALOS|IZ_ACCOUNT_SMART account true))
    )
    ;;Second Part
    (defcap DALOS|CONTROL_SMART-ACCOUNT (patron:string account:string pasc:bool pbsc:bool pbm:bool)
        @doc "Capability required to Control a Smart DALOS Account"
        (compose-capability (DALOS|CONTROL_SMART-ACCOUNT_CORE account pasc pbsc pbm))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DALOS|CONTROL_SMART-ACCOUNT_CORE (account:string pasc:bool pbsc:bool pbm:bool)
        @doc "Core Capability required to Control a Smart DALOS Account"
        (compose-capability (DALOS|ACCOUNT_OWNER account))     
        (compose-capability (DALOS|IZ_ACCOUNT_SMART account true))
        (enforce (= (or (or pasc pbsc) pbm) true) "At least one Smart DALOS Account parameter must be true")
    )
    

    
    

    ;;========[D] FUNCTIONS====================================================;;
    ;;1.2]    [D] DALOS Functions
    ;;1.2.1]  [D]   DALOS Utility Functions
    ;;1.2.1.1][D]           Properties Info - Reading of the DALOS Virtual Blockchain Properties
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
            { "gas-id" :  UTILITY.BAR }
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
    ;;1.2.1.2][D]           Dalos Gas Management Info - Reading of the DALOS Virtual Blockchain gas Management Information
    (defun DALOS|UR_Tanker:string ()
        @doc "Returns as string the Gas Pot Account"
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
        @doc "Returns as decimal the amount of Gas Spent"
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
        (at "native-gas-spent" (read GAS|PropertiesTable DALOS|VGD ["native-gas-spent"]))
    )
    ;;1.2.1.3][D]           Dalos Price Info - Reading of the DALOS Virtual Blockchain Prices
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
    ;;1.2.1.4][D]           Account Info - Reading of the DALOS Account Information
    (defun DALOS|UR_AccountGuard:guard (account:string)
        @doc "Returns DALOS Account <account> Guard"
        (at "guard" (read DALOS|AccountTable account ["guard"]))
    )
    (defun DALOS|UR_AccountProperties:[bool] (account:string)
        @doc "Returns a boolean list with DALOS Account Type properties"
        (UTILITY.DALOS|UV_Account account)
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
    (defun DALOS|UR_AccountNonce:integer (account:string)
        @doc "Returns DALOS Account <account> nonce value"
        (UTILITY.DALOS|UV_Account account)
        (with-default-read DALOS|AccountTable account
            { "nonce" : 0 }
            { "nonce" := n }
            n
        )
    )
    (defun DALOS|UR_AccountSovereign:string (account:string)
        @doc "Returns DALOS Account <sovereign> Account"
        (at "sovereign" (read DALOS|AccountTable account ["sovereign"]))
    )
    (defun DALOS|UR_AccountGovernor:string (account:string)
        @doc "Returns DALOS Account <governor> Account"
        (at "governor" (read DALOS|AccountTable account ["governor"]))
    )
    (defun DALOS|UR_AccountKadena:string (account:string)
        @doc "Returns DALOS Account <kadena-konto> Account"
        (at "kadena-konto" (read DALOS|AccountTable account ["kadena-konto"]))
    )
    (defun DALOS|UR_Elite (account:string)
        (UTILITY.DALOS|UV_Account account)
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
    (defun DALOS|UP_AccountProperties (account:string)
        @doc "Prints DALOS Account <account> Properties"
        (DALOS|UVE_id account)
        (let* 
            (
                (p:[bool] (DALOS|UR_AccountProperties account))
                (a:bool (at 0 p))
                (b:bool (at 1 p))
                (c:bool (at 2 p))
            )
            (if (= a true)
                (format "Account {} is a Smart Account: Payable: {}; Payable by Smart Account: {}." [account b c])
                (format "Account {} is a Normal Account" [account])
            )
        )
    )

    ;;Read Primal DPTF Data
    (defun DALOS|UR_TrueFungible:object{DPTF|BalanceSchema} (account:string snake-or-gas:bool)
        @doc "Reads either Ouroboros-DPTF Data <snake-or-gas> is true, or \
        \ Ignis-DPTF Data <snake-or-gas> is false, Ignis being the GAS Token"
        (UTILITY.DALOS|UV_Account account)
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
    (defun DALOS|UR_TrueFungible_AccountRoleBurn:decimal (account:string snake-or-gas:bool)
        (at "role-burn" (DALOS|UR_TrueFungible account snake-or-gas))
    )
    (defun DALOS|UR_TrueFungible_AccountRoleMint:decimal (account:string snake-or-gas:bool)
        (at "role-mint" (DALOS|UR_TrueFungible account snake-or-gas))
    )
    (defun DALOS|UR_TrueFungible_AccountRoleTransfer:decimal (account:string snake-or-gas:bool)
        (at "role-transfer" (DALOS|UR_TrueFungible account snake-or-gas))
    )
    (defun DALOS|UR_TrueFungible_AccountRoleFeeExemption:decimal (account:string snake-or-gas:bool)
        (at "role-fee-exemption" (DALOS|UR_TrueFungible account snake-or-gas))
    )
    (defun DALOS|UR_TrueFungible_AccountFreezeState:decimal (account:string snake-or-gas:bool)
        (at "frozen" (DALOS|UR_TrueFungible account snake-or-gas))
    )
    ;;Gas Management Computaiton Functions
    (defun DALOS|GAS|UC_KadenaSplit:[decimal] (kadena-input-amount:decimal)
        @doc "Computes the KDA Split required for Native Gas Collection \
        \ This is 5% 5% 15% and 75% outputed as 5% 15% 75% in a list"
        (let*
            (
                (five:decimal (UTILITY.UC_Percent kadena-input-amount 5.0 UTILITY.KDA_PRECISION))
                (fifteen:decimal (UTILITY.UC_Percent kadena-input-amount 15.0 UTILITY.KDA_PRECISION))
                (total:decimal (UTILITY.UC_Percent kadena-input-amount 25.0 UTILITY.KDA_PRECISION))
                (rest:decimal (- kadena-input-amount total))
            )
            [five fifteen rest]
        )
    )
    ;;Native
    (defun DALOS|GAS|UC_IsNativeGasZero:bool ()
        @doc "Returns true if Native GAS cost is Zero (not yet toggled), otherwise returns false"
        (let*
            (
                (gas-toggle:bool (DALOS|UR_NativeToggle))
                (NZG:bool (if (= gas-toggle false) true false))
            )
            NZG
        )
    )
    ;;Virtual
    (defun DALOS|GAS|UC_IsVirtualGasZero:bool ()
        @doc "Function needed for <DALOS|GAS|UC_IsVirtualGasZeroWithException>"
        (let*
            (
                (gas-toggle:bool (DALOS|UR_VirtualToggle))
                (ZG:bool (if (= gas-toggle false) true false))
            )
            ZG
        )
    )
    (defun DALOS|GAS|UC_IsVirtualGasZeroWithException:bool (sender:string)
        @doc "Function needed for <GAS|UC_ZeroGAS>"
        (let*
            (
                (t0:bool (DALOS|GAS|UC_IsVirtualGasZero))
                (t1:bool (if (or (= sender GAS|SC_NAME)(= sender LIQUID|SC_NAME)) true false))
            )
            (or t0 t1)
        )
    )
    (defun DALOS|GAS|UC_ZeroGAS:bool (id:string sender:string)
        @doc "Returns true if Virtual GAS cost is Zero (not yet toggled), otherwise returns false (sender only)"

        (let*
            (
                (t1:bool (DALOS|GAS|UC_IsVirtualGasZeroWithException sender))
                (gas-id:string (DALOS|UR_IgnisID))
                (t2:bool (if (or (= gas-id UTILITY.BAR)(= id gas-id)) true false))
            )
            (or t1 t2)
        )
    )
    (defun GAS|UC_ZeroGAZ:bool (id:string sender:string receiver:string)
        @doc "Returns true if Virtual GAS cost is Zero (not yet toggled), otherwise returns false (sender + receiver)"

        (let*
            (
                (t1:bool (DALOS|GAS|UC_ZeroGAS id sender))
                (t2:bool (if (or (= receiver GAS|SC_NAME)(= receiver LIQUID|SC_NAME)) true false))
            )
            (or t1 t2)
        )
    )

    ;;1.2.1.3][D]           Computing|Composing

    (defun DALOS|UC_MethodicTransferability:bool (sender:string receiver:string method:bool)
        @doc "Computes transferability between 2 DALOS Accounts, <sender> and <receiver> given the input <method>"
        (DALOS|UV_SenderWithReceiver sender receiver)
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
    (defun DALOS|UC_Transferability:bool (sender:string receiver:string)
        @doc "Computes transferability between 2 DALOS Accounts, <sender> and <receiver> "
        (DALOS|UC_MethodicTransferability sender receiver false)
    )
    (defun DALOS|UC_Makeid:string (ticker:string)
        @doc "Creates a DPTF|DPMF id \ 
            \ using the first 12 Characters of the prev-block-hash of (chain-data) as randomness source"
        (UTILITY.DALOS|UV_Ticker ticker)
        (UTILITY.DALOS|UC_Makeid ticker)
    )

    (defun DALOS|UC_UpdateTrueFungibleSupply:object{DPTF|BalanceSchema} (input:object{DPTF|BalanceSchema} new-supply:decimal)
        (let
            (
                (rb:bool (at "role-burn" input))
                (rm:bool (at "role-mint" input))
                (rt:bool (at "role-transfer" input))
                (rfe:bool (at "role-fee-exemption" input))
                (f:bool (at "frozen" input))
            )
            (enforce (>= new-supply 0.0) "Cannot update with negative supply")
            {"balance"              : new-supply
            ,"role-burn"            : rb
            ,"role-mint"            : rm
            ,"role-transfer"        : rt
            ,"role-fee-exemption"   : rfe
            ,"frozen"               : f}
        )
    )

    ;;1.2.1.4][D]           Validations
    (defun DALOS|UVE_id (dalos-account:string)
        @doc "Validates the existance of the DALOS Account <dalos-account>"
        ;;First, the name must conform to the naming requirement
        (UTILITY.DALOS|UV_Account dalos-account)
        ;;If it passes the naming requirement, its existance is checked, by reading its DEB
        ;;If the DEB is smaller than 1, which it cant happen, then account doesnt exist
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
    (defun DALOS|UV_SenderWithReceiver (sender:string receiver:string)
        @doc "Validates Account <sender> with Account <receiver> for Transfer"
        (DALOS|UVE_id sender)
        (DALOS|UVE_id receiver)
        (enforce (!= sender receiver) "Sender and Receiver must be different")
    )
    (defun DALOS|UV_Fee (fee:decimal)
        @doc "Validate input decimal as a fee value"
        (enforce
            (= (floor fee UTILITY.FEE_PRECISION) fee)
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


    ;;1.2.2]  [D]   DALOS Administration Functions
    (defun DALOS|A_UpdateStandard (price:decimal)
        @doc "Updates DALOS Kadena Cost for deploying a Standard DALOS Account"
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"standard" : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateSmart(price:decimal)
        @doc "Updates DALOS Kadena Cost for deploying a Smart DALOS Account"
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"smart"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateTrue(price:decimal)
        @doc "Updates DALOS Kadena Cost for issuing a DPTF Token"
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"dptf"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateMeta(price:decimal)
        @doc "Updates DALOS Kadena Cost for issuing a DPMF Token"
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"dpmf"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateSemi(price:decimal)
        @doc "Updates DALOS Kadena Cost for issuing a DPSF Token"
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"dpsf"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateNon(price:decimal)
        @doc "Updates DALOS Kadena Cost for issuing a DPNF Token"
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"dpnf"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateBlue(price:decimal)
        @doc "Updates DALOS Kadena Cost for the Blue Checker"
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"blue"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )

    ;;1.2.3]  [D]   DALOS Client Functions
    ;;1.2.3.1][D]           Control
    (defun DALOS|C_TransferDalosFuel (sender:string receiver:string amount:decimal)
        @doc "Transfer KDA from sender to receiver"
        (install-capability (coin.TRANSFER sender receiver amount))
        (coin.transfer sender receiver amount)
    )
    (defun DALOS|C_TransferRawDalosFuel (sender:string amount:decimal)
        @doc "Colects Raw Dalos Fuel to Ouroboros Account"
        (let
            (
                (kadena-split:[decimal] (DALOS|GAS|UC_KadenaSplit amount))
                (am0:decimal (at 0 kadena-split))
                (am1:decimal (at 1 kadena-split))
                (am2:decimal (at 2 kadena-split))
                (sender-kda:string (DALOS|UR_AccountKadena sender))
            )
        )
        (DALOS|C_TransferDalosFuel sender-kda DALOS|CTO am0)                ;;5% to CTO
        (DALOS|C_TransferDalosFuel sender-kda DALOS|HOV am0)                ;;5% to HOV
        (DALOS|C_TransferDalosFuel sender-kda OUROBOROS|SC_KDA-NAME am1)    ;;15% to OUROBOROS|SC_KDA-NAME (to be used for Liquid Kadena Protocol)
        (DALOS|C_TransferDalosFuel sender-kda GAS|SC_KDA-NAME am2)          ;;75% to OUROBOROS|SC_KDA-NAME (to be used for DALOS Gas Station)
    )
    (defun DALOS|C_DeployStandardAccount (account:string guard:guard kadena:string)
        @doc "Deploys a Standard DALOS Account. \
            \ Before any DPTF|DPMF|DPFS|DPNF Token can be created and used, \
            \ a Standard or Smart DALOS Account must be deployed \
            \ Equivalent to creting a new ERD Address \
            \ \
            \ If a DALOS Account already exists, function will fail, due to usage of insert"
        (UTILITY.DALOS|UV_Account account)
        (UTILITY.DALOS|UV_EnforceReserved account guard)
        (enforce-guard guard)

        (insert DALOS|AccountTable account
            { "guard"                       : guard
            , "kadena-konto"                : kadena
            , "sovereign"                   : account
            , "governor"                    : UTILITY.BAR

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
        (if (not DALOS|GAS|UC_IsNativeGasZero)
            (DALOS|C_TransferRawDalosFuel account (DALOS|UR_Standard))
            true
        )
    )
    (defun DALOS|C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string)
        @doc "Deploys a Smart DALOS Account. \
            \ Before any DPTF, DPMF, DPSF, DPNF Token can be created, \
            \ a Standard or Smart DALOS Account must be deployed \
            \ Equivalent to creating a new ERD Smart-Contract Address"
        (UTILITY.DALOS|UV_Account account)
        (UTILITY.DALOS|UV_Account sovereign)
        (UTILITY.DALOS|UV_EnforceReserved account guard)
        (enforce-guard guard)

        ;;Since it uses insert, the function only works if the DALOS account doesnt exist yet.
        (with-capability (DALOS|IZ_ACCOUNT_SMART sovereign false)
            (insert DALOS|AccountTable account
                { "guard"                       : guard
                , "kadena-konto"                : kadena
                , "sovereign"                   : sovereign
                , "governor"                    : UTILITY.BAR

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
        )
        ;;Collect the Deployment fee as Raw KDA, if native Gas is set to ON
        (if (not DALOS|GAS|UC_IsNativeGasZero)
            (DALOS|C_TransferRawDalosFuel account (DALOS|UR_Smart))
            true
        )
    )
    ;;Account Management Part 1 - Rotate Functions
    (defun DALOS|C_RotateGuard (patron:string account:string new-guard:guard safe:bool)
        @doc "Updates the Guard stored in the DALOS|AccountTable"
        (let
            (
                (ZG:bool (DALOS|GAS|UC_IsVirtualGasZero))
            )
            (with-capability (DALOS|ROTATE_ACCOUNT patron account)
                (if (= ZG false)
                    (GAS|X_Collect patron account DALOS.GAS_SMALL)
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
                (ZG:bool (DALOS|GAS|UC_IsVirtualGasZero))
            )
            (with-capability (DALOS|ROTATE_ACCOUNT patron account)
                (if (= ZG false)
                    (GAS|X_Collect patron account DALOS.GAS_SMALL)
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
                (ZG:bool (DALOS|GAS|UC_IsVirtualGasZero))
            )
            (with-capability (DALOS|ROTATE_SOVEREIGN patron account new-sovereign)
                (if (= ZG false)
                    (GAS|X_Collect patron account DALOS.GAS_SMALL)
                    true
                )
                (DALOS|X_RotateSovereign account new-sovereign)
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    (defun DALOS|C_RotateGovernor (patron:string account:string governor:string)
        @doc "Updates the Smart Account Governor, which is the Governing Module \
        \ Only works for Smart DALOS Accounts"
        (let
            (
                (ZG:bool (DALOS|GAS|UC_IsVirtualGasZero))
            )
            (with-capability (DALOS|ROTATE_GOVERNOR patron account governor)
                (if (= ZG false)
                    (GAS|X_Collect patron account DALOS.GAS_SMALL)
                    true
                )
                (DALOS|X_RotateGovernor account governor)
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    ;;Account Management Part 2 - Smart Account Properties
    (defun DALOS|C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool)
        @doc "Manages Smart DALOS Account Type via boolean triggers"
        (let
            (
                (ZG:bool (DALOS|GAS|UC_IsVirtualGasZero))
            )
            (with-capability (DALOS|CONTROL_SMART-ACCOUNT patron account payable-as-smart-contract payable-by-smart-contract)
                (if (= ZG false)
                    (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                    true
                )
                (DALOS|X_UpdateSmartAccountParameters account payable-as-smart-contract payable-by-smart-contract payable-by-method)
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    ;;Account Management Part 3 - Last Part
    ;;Update Elite - must be done from DPTF|DPMF Module.





















    
    ;;Account Management - Part 1 - DALOS|X_Rotate Functions
    (defun DALOS|X_RotateGuard (account:string new-guard:guard safe:bool)
        @doc "Updates DALOS Account Parameters"
        (require-capability (DALOS|ACCOUNT_OWNER account))
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
        (require-capability (DALOS|ACCOUNT_OWNER account))
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
    (defun DALOS|X_RotateGovernor (account:string governor:string)
        @doc "Updates DALOS Account Governor"
        (require-capability (DALOS|GOVERNOR account governor))
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
    ;;DALOS|X_IncrementNonce
    (defun DALOS|X_IncrementNonce (client:string)
        @doc "Increments DALOS Account nonce, which store how many txs the DALOS Account executed"
        (require-capability (DALOS|INCREASE-NONCE))
        (with-read DALOS|AccountTable client
            { "nonce"                       := n }
            (update DALOS|AccountTable client { "nonce" : (+ n 1)})
        )
    )

    ;;GAS|X_Collect with all SubFunctions and related Capabilities
    (defun GAS|X_Collect (patron:string active-account:string amount:decimal)
        @doc "Collects GAS"
        (require-capability (GAS|COLLECTION patron active-account amount))
        (let
            (
                (sender-type:bool (DALOS|UR_AccountType active-account))
            )
            (if (= sender-type false)
                (GAS|X_CollectStandard patron amount)
                (GAS|X_CollectSmart patron active-account amount)
            )
        )
    )
    (defun GAS|X_CollectStandard (patron:string amount:decimal)
        @doc "Collects GAS when the <active-account> is a Standard DALOS Account"
        (require-capability (GAS|COLLECTER_STANDARD patron amount))
        (GAS|X_Transfer patron (DALOS|UR_Tanker) amount)
        (GAS|X_Increment false amount)
    )
    (defun GAS|X_CollectSmart (patron:string active-account:string amount:decimal)
        @doc "Collects GAS when the <active-account> is a Smart DALOS Account"
        (require-capability (GAS|COLLECTER_SMART patron sender amount))
        (let*
            (
                (gas-pot:string (DALOS|UR_Tanker))
                (quarter:decimal (* amount DALOS.GAS_QUARTER))
                (rest:decimal (- amount quarter))                
            )
            (GAS|X_Transfer patron gas-pot rest)    ;;Three Quarters goes to defined Gas-Tanker Account
            (GAS|X_Transfer patron sender quarter)  ;;One Quarter goes to <Active-Account> because its a Smart DALOS Account
            (GAS|X_Increment false amount)          ;;Increment the amount of Virtual Gas Spent
        )
    )

    (defun GAS|X_Increment (native:bool increment:decimal)
        @doc "Increments either <native-gas-spent> or <virtual-gas-spent> existing in the DALOS|GasManagementTable to <increment>"
        (require-capability (GAS|INCREMENT))
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
    (defun GAS|X_Transfer (sender:string receiver:string ta:decimal)
        @doc "Core function used only for transfering GAS aka IGNIS Token \
        \ Transfer ALWAYS takes place, without taking the IGNIS Token DPTF Properties in Account \
        \ Therefore is always works, regardless of the IGNIS Properties \
        \ Transferring IGNIS this way is only used for GAS movement WITHIN the DALOS Module \
        \ Transferring IGNIS as GAS has its own similar functions in the DPTF|DPMF module and in the DPSF|DPNF Module \
        \ Transferring IGNIS can also be done as Standard DPTF Transfer, using the DPTF IGNIS Properties"
        (require-capability (GAS|IGNIS sender receiver ta))
        (GAS|X_Debit sender ta)
        (GAS|X_Credit receiver ta)

    )
    (defun GAS|X_Debit (sender:string ta:decimal)
        @doc "Core function for debiting IGNIS from an account \
        \ Protected by DebitGas Capability \
        \ <Sender> must exist as DALOS Standard Account"
        (require-capability (GAS|DEBIT_IGNIS sender))
        (let
            (
                (read-gas:decimal (DALOS|UR_TrueFungible_AccountSupply sender false))
                (gas-obj:object{DPTF|BalanceSchema} (DALOS|UR_TrueFungible sender false))
            )
            
            (enforce (<= ta read-gas) "Insufficient GAS for GAS-Debiting")
            (update DALOS|AccountTable sender
                {"ignis" : (DALOS|UC_UpdateTrueFungibleSupply gas-obj (- read-gas ta))}
            )
        )
    )
    (defun GAS|X_Credit (receiver:string ta:decimal)
        @doc "Core function for crediting IGNIS to an account \
        \ Protected by CreditGas Capability.  \
        \ <Receiver> must exist as DALOS Standard or Smart Account"
        (require-capability (GAS|CREDIT_IGNIS receiver))
        (let
            (
                (read-gas:decimal (DALOS|UR_TrueFungible_AccountSupply receiver false))
                (gas-obj:object{DPTF|BalanceSchema} (DALOS|UR_TrueFungible receiver false))
            )
            
            (enforce (>= read-gas 0.0) "Impossible operation, negative GAS amounts detected")
            (update DALOS|AccountTable sender
                {"ignis" : (DALOS|UC_UpdateTrueFungibleSupply gas-obj (+ read-gas ta))}
            )
        )
    )

    ;;GAS Capabilities
    (defcap GAS|COLLECTION (patron:string active-account:string amount:decimal)
        @doc "Capability required to collect GAS"
        (compose-capability (GAS|PATRON patron))
        (let
            (
                (sender-type:bool (DALOS|UR_AccountType active-account))
            )
            (if sender-type
                (compose-capability (GAS|COLLECTER_SMART patron active-account amount))
                (compose-capability (GAS|COLLECTER_STANDARD patron amount))
            )
        )
    )
    (defcap GAS|PATRON (patron:string)
        @doc "Capability that ensures a DALOS account can act as gas payer, also enforcing its Guard"
            (compose-capability (DALOS|IZ_ACCOUNT_SMART patron false))
            (compose-capability (DALOS|ACCOUNT_OWNER patron))
    )
    (defcap GAS|COLLECTER_STANDARD (patron:string amount:decimal)
        @doc "Capability required for collecting GAS when the <active-account> is a Standard DALOS Account"
        (let
            (
                (gas-id:string (DALOS|UR_IgnisID))
            )
            (if (!= gas-id UTILITY.BAR)
                (compose-capability (GAS|COLLECTER_STANDARD_CORE patron amount))
                true
            )
        )
    )
    (defcap GAS|COLLECTER_STANDARD_CORE (patron:string amount:decimal)
        @doc "Core Capability used in <GAS|COLLECTER_STANDARD> Capability"
        (compose-capability (GAS|IGNIS patron (GAS|UR_Tanker) amount))
        (compose-capability (GAS|INCREMENT))
    )
    (defcap GAS|COLLECTER_SMART (patron:string active-account:string amount:decimal)
        @doc "Capability required for collecting GAS when the <active-account> is a Smart DALOS Account"
        ;;03]Validate <amount> as a GAS amount
        (let
            (
                (gas-id:string (DALOS|UR_IgnisID))
            )
            (if (!= gas-id UTILITY.BAR)
                (let*
                    (
                        (gas-pot:string (DALOS|UR_Tanker))
                        (quarter:decimal (* amount DALOS.GAS_QUARTER))
                        (rest:decimal (- amount quarter))
                    )

            
                    (compose-capability (GAS|IGNIS patron gas-pot rest))
                    (compose-capability (GAS|IGNIS patron active-account quarter))
                    (compose-capability (GAS|INCREMENT))
                )
                true
            )
        )
    )
    (defcap GAS|IGNIS (sender:string receiver:string ta:decimal)
        @doc "Capability required for trasnfering GAS"
        (enforce (!= sender receiver) "Sender and Receiver must be different")
        (DALOS|UV_TwentyFourPrecision ta)
        (enforce (> ta 0.0) "Cannot debit|credit 0.0 or negative GAS amounts")
        (compose-capability (GAS|DEBIT_IGNIS sender ta))
        (compose-capability (GAS|CREDIT_IGNIS receiver ta))
    )
    (defcap GAS|DEBIT_IGNIS (sender:string)
        (compose-capability (DALOS|EXIST sender))
        (compose-capability (DALOS|IZ_ACCOUNT_SMART sender false))
    )
    (defcap GAS|CREDIT_IGNIS (receiver:string)
        (compose-capability (DALOS|EXIST receiver))
    )
    (defcap GAS|INCREMENT ()
        @doc "Capability required to increment spent GAS amounts"
        true
    )
    (defun DALOS|UV_TwentyFourPrecision (amount:decimal)
        @doc "Enforces Decimal has 24 precision"
        (enforce
            (= (floor amount 24) amount)
            (format "The GAS Amount of {} is not a valid GAS Amount decimal wise" [amount])
        )
    )
)

(create-table DALOS|Glyphs)

(create-table DALOS|PropertiesTable)
(create-table DALOS|GasManagementTable)
(create-table DALOS|PricesTable)

(create-table DALOS|AccountTable)


;;Must be moved in Handling

;;defun DALOS|UC_Filterid:[string]
;;defun DPTF-DPMF-ATS|UR_FilterKeysForInfo:[string]