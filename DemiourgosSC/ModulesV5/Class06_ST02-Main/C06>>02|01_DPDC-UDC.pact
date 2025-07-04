(module DPDC-UDC GOV
    ;;
    (implements OuronetPolicy)
    (implements DpdcUdc)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-UDC               (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPDC-UDC_ADMIN)))
    (defcap GOV|DPDC-UDC_ADMIN ()           (enforce-guard GOV|MD_DPDC-UDC))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|DPDC-UDC|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC-UDC|CALLER))
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
        (with-capability (GOV|DPDC-UDC_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC-UDC_ADMIN)
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
                (mg:guard (create-capability-guard (P|DPDC-UDC|CALLER)))
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
    ;;Properties UDCs
    ;;
    ;;  [0]
    ;;
    (defun UDC_DPSF|Account:object{DpdcUdc.DPSF|Account}
        (a:bool b:[object{DpdcUdc.DPSF|NonceBalance}] c:[object{DpdcUdc.DPSF|NonceBalance}] d:object{DpdcUdc.AccountRoles} e:bool)
        {"iz"                       : a
        ,"holdings"                 : b
        ,"fragments"                : c
        ,"roles"                    : d
        ,"role-nft-add-quantity"    : e}
    )
    (defun UDC_DPSF|NonceBalance:object{DpdcUdc.DPSF|NonceBalance}
        (a:integer b:integer)
        {"nonce"                    : a
        ,"supply"                   : b}
    )
    (defun UDC_DPNF|Account:object{DpdcUdc.DPNF|Account}
        (a:bool b:[integer] c:[object{DpdcUdc.DPSF|NonceBalance}] d:object{DpdcUdc.AccountRoles})
        {"iz"                       : a
        ,"holdings"                 : b
        ,"fragments"                : c
        ,"roles"                    : d}
    )
    (defun UDC_AccountRoles:object{DpdcUdc.AccountRoles}
        (a:bool b:bool c:bool d:bool e:bool f:bool g:bool h:bool i:bool j:bool)
        {"frozen"               : a
        ,"role-exemption"       : b
        ,"role-nft-burn"        : c
        ,"role-nft-create"      : d
        ,"role-nft-recreate"    : e
        ,"role-nft-update"      : f
        ,"role-modify-creator"  : g
        ,"role-modify-royalties": h
        ,"role-set-new-uri"     : i
        ,"role-transfer"        : j}
    )
    ;;
    ;;  [1]
    ;;
    (defun UDC_DPDC|Properties:object{DpdcUdc.DPDC|Properties}
        (
            a:string b:string c:string d:string
            e:bool f:bool g:bool h:bool
            i:bool j:bool k:bool l:bool
            m:bool n:integer o:integer
        )
        {"owner-konto"                  : a
        ,"creator-konto"                : b
        ,"name"                         : c
        ,"ticker"                       : d
        ,"can-upgrade"                  : e
        ,"can-change-owner"             : f
        ,"can-change-creator"           : g
        ,"can-add-special-role"         : h
        ,"can-transfer-nft-create-role" : i
        ,"can-freeze"                   : j
        ,"can-wipe"                     : k
        ,"can-pause"                    : l
        ,"is-paused"                    : m
        ,"nonces-used"                  : n
        ,"set-classes-used"             : o}
    )
    ;;
    ;;  [2]
    ;;
    (defun UDC_NonceElement:object{DpdcUdc.DPDC|NonceElement} 
        (   
            a:integer b:integer c:integer d:bool
            e:object{DpdcUdc.DPDC|NonceData}
            f:object{DpdcUdc.DPDC|NonceData}
        )
        {"nonce-class"      : a
        ,"nonce-value"      : b
        ,"nonce-supply"     : c
        ,"iz-active"        : d
        ,"nonce-data"       : e
        ,"split-data"       : f}
    )
    (defun UDC_NonceData:object{DpdcUdc.DPDC|NonceData} 
        (
            a:decimal b:decimal c:string d:string e:[object]
            f:object{DpdcUdc.URI|Type}
            g:object{DpdcUdc.URI|Data}
            h:object{DpdcUdc.URI|Data}
            i:object{DpdcUdc.URI|Data}
        )
        {"royalty"          : a
        ,"ignis"            : b
        ,"name"             : c
        ,"description"      : d
        ,"meta-data"        : e
        ,"asset-type"       : f
        ,"uri-primary"      : g
        ,"uri-secondary"    : h
        ,"uri-tertiary"     : i}
    )
    (defun UDC_URI|Type:object{DpdcUdc.URI|Type}
        (a:bool b:bool c:bool d:bool e:bool f:bool g:bool)
        {"image"            : a
        ,"audio"            : b
        ,"video"            : c
        ,"document"         : d
        ,"archive"          : e
        ,"model"            : f
        ,"exotic"           : g}
    )
    (defun UDC_URI|Data:object{DpdcUdc.URI|Data}
        (a:string b:string c:string d:string e:string f:string g:string)
        {"image"            : a
        ,"audio"            : b
        ,"video"            : c
        ,"document"         : d
        ,"archive"          : e
        ,"model"            : f
        ,"exotic"           : g}
    )
    (defun UDC_Score:object{DpdcUdc.DPDC|NonceScore}
        (a:decimal)
        {"score"            : a}
    )
    ;;
    ;;  [3]
    ;;
    (defun UDC_DPDC|Set:object{DpdcUdc.DPDC|Set}
        (
            a:integer b:string c:bool d:bool e:bool
            f:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            g:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]
            i:object{DpdcUdc.DPDC|NonceData}
            j:object{DpdcUdc.DPDC|NonceData}
        )
        {"set-class"                    : a
        ,"set-name"                     : b
        ,"iz-active"                    : c
        ,"primordial"                   : d
        ,"composite"                    : e
        ,"primordial-set-definition"    : f
        ,"composite-set-definition"     : g
        ,"nonce-data"                   : i
        ,"split-data"                   : j}
    )
    (defun UDC_DPDC|AllowedNonceForSetPosition:object{DpdcUdc.DPDC|AllowedNonceForSetPosition} 
        (a:[integer])
        {"allowed-nonces"   : a}
    )
    (defun UDC_DPDC|AllowedClassForSetPosition:object{DpdcUdc.DPDC|AllowedClassForSetPosition} 
        (a:integer)
        {"allowed-sclass"   : a}
    )
    ;;
    ;;  [4]
    ;;
    (defun UDC_DPDC|VerumRoles:object{DpdcUdc.DPDC|VerumRoles}
        (a:[string] b:[string] c:[string] d:[string] e:string f:string g:[string] h:[string] i:[string] j:string k:[string])
        {"a-frozen"                 : a
        ,"r-exemption"              : b
        ,"r-nft-add-quantity"       : c
        ,"r-nft-burn"               : d
        ,"r-nft-create"             : e
        ,"r-nft-recreate"           : f
        ,"r-nft-update"             : g
        ,"r-modify-creator"         : h
        ,"r-modify-royalties"       : i
        ,"r-set-new-uri"            : j
        ,"r-transfer"               : k}
    )
    ;;
    ;;  [CUSTOM]
    ;;
    ;;  [0]
    ;;
    (defun UDC_ZeroNBO:object{DpdcUdc.DPSF|NonceBalance} ()
        (UDC_DPSF|NonceBalance 0 0)
    )
    ;;
    ;;  [2]
    ;;
    (defun UDC_ZeroNonceElement:object{DpdcUdc.DPDC|NonceElement} ()
        (UDC_NonceElement
            0 0 0 false
            (UDC_ZeroNonceData)
            (UDC_ZeroNonceData)
        )
    )
    (defun UDC_ZeroNonceData:object{DpdcUdc.DPDC|NonceData} ()
        (UDC_NonceData
            0.0 0.0 BAR BAR [{}]
            (UDC_ZeroURI|Type) (UDC_ZeroURI|Data)
            (UDC_ZeroURI|Data) (UDC_ZeroURI|Data)
        )
    )
    (defun UDC_ZeroURI|Type:object{DpdcUdc.URI|Type} ()
        (UDC_URI|Type false false false false false false false)
    )
    (defun UDC_ZeroURI|Data:object{DpdcUdc.URI|Data} ()
        (UDC_URI|Data BAR BAR BAR BAR BAR BAR BAR)
    )
    (defun UDC_NoScore:object{DpdcUdc.DPDC|NonceScore} ()
        (UDC_Score -1.0)
    )
    (defun UDC_NoPrimordialSet:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}] ()
        [(UDC_DPDC|AllowedNonceForSetPosition [0])]
    )
    (defun UDC_NoCompositeSet:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}] ()
        [(UDC_DPDC|AllowedClassForSetPosition -1)]
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)