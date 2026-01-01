(module DPDC GOV
    ;;
    (implements OuronetPolicy)
    (implements BrandingUsageV11)
    (implements DpdcV5)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC                   (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    (defconst DPDC|SC_KEY                   (GOV|CollectiblesKey))
    (defconst DPDC|SC_NAME                  (GOV|DPDC|SC_NAME))
    (defconst DPDC|SC_KDA-NAME              "k:35d7f82a7754d10fc1128d199aadb51cb1461f0eb52f4fa89790a44434f12ed8")
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPDC_ADMIN)))
    (defcap GOV|DPDC_ADMIN ()               (enforce-guard GOV|MD_DPDC))
    (defcap DPDC|GOV ()
        @doc "Governor Capability for the DPDC Smart DALOS Account"
        true
    )
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
    (defcap P|DPDC|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC|CALLER))
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
        (with-capability (GOV|DPDC_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC_ADMIN)
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
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (mg:guard (create-capability-guard (P|DPDC|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
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
    (deftable DPSF|T|Properties:{DpdcUdcV3.DPDC|PropertiesV2})        ;;Key = <DPSF-id>      
    (deftable DPSF|T|Nonces:{DpdcUdcV3.DPDC|NonceElement})            ;;Key = <DSPF-id> + BAR + <nonce>
    (deftable DPSF|T|VerumRoles:{DpdcUdcV3.DPDC|VerumRoles})          ;;Key = <DPSF-id>
    (deftable DPSF|T|Account:{DpdcUdcV3.DPSF|AccountRolesV2})         ;;Key = <DPSF-id> + BAR + <account>
    (deftable DPSF|T|AccountSupplies:{DpdcUdcV3.DPDC|AccountSupply})  ;;Key = <account> + BAR + <DPSF-id> + BAR + <nonce>
    ;;
    (deftable DPNF|T|Properties:{DpdcUdcV3.DPDC|PropertiesV2})        ;;Key = <DPNF-id>      
    (deftable DPNF|T|Nonces:{DpdcUdcV3.DPDC|NonceElement})            ;;Key = <DSNF-id> + BAR + <nonce>
    (deftable DPNF|T|VerumRoles:{DpdcUdcV3.DPDC|VerumRoles})          ;;Key = <DPNF-id>
    (deftable DPNF|T|Account:{DpdcUdcV3.DPNF|AccountRolesV2})         ;;Key = <DPNF-id> + BAR + <account> 
    (deftable DPNF|T|AccountSupplies:{DpdcUdcV3.DPDC|AccountSupply})  ;;Key = <account> + BAR + <DPNF-id> + BAR + <nonce>
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    (defconst FRG                   1000)
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
    (defcap DPDC|C>UPDATE-BRD (entity-id:string son:bool)
        @event
        (CAP_Owner entity-id son)
        (compose-capability (P|DPDC|CALLER))
    )
    (defcap DPDC|C>UPGRADE-BRD (entity-id:string son:bool)
        @event
        (CAP_Owner entity-id son)
        (compose-capability (P|DPDC|CALLER))
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_ParseSignedInteger:integer (value:string)
        @doc "Converts an integer written as string, to integer, working for negative values aswell."
        (let
            (
                (is-negative:bool (= (take 1 value) "-"))
                (abs-str:string (if is-negative (drop 1 value) value))
                (parsed-int:integer (str-to-int abs-str))
            )
            (if is-negative
                (- parsed-int)
                parsed-int
            )
        )
    )
    ;;{F0}  [UR]
    (defun UR_AS-KEYS:[string] (son:bool)
        (keys (if son DPSF|T|AccountSupplies DPNF|T|AccountSupplies))
    )
    ;;
    ;; [1] - [Properties]
    (defun UR_Properties:object{DpdcUdcV3.DPDC|PropertiesV2} (id:string son:bool)
        (read (if son DPSF|T|Properties DPNF|T|Properties) id)
    )
    (defun UR_OwnerKonto:string (id:string son:bool)
        (at "owner-konto" (UR_Properties id son))
    )
    (defun UR_CreatorKonto:string (id:string son:bool)
        (at "creator-konto" (UR_Properties id son))
    )
    (defun UR_Name:string (id:string son:bool)
        (at "name" (UR_Properties id son))
    )
    (defun UR_Ticker:string (id:string son:bool)
        (at "ticker" (UR_Properties id son))
    )
    (defun UR_CanUpgrade:bool (id:string son:bool)
        (at "can-upgrade" (UR_Properties id son))
    )
    (defun UR_CanChangeOwner:bool (id:string son:bool)
        (at "can-change-owner" (UR_Properties id son))
    )
    (defun UR_CanChangeCreator:bool (id:string son:bool)
        (at "can-change-creator" (UR_Properties id son))
    )
    (defun UR_CanAddSpecialRole:bool (id:string son:bool)
        (at "can-add-special-role" (UR_Properties id son))
    )
    (defun UR_CanTransferNftCreateRole:bool (id:string son:bool)
        (at "can-transfer-nft-create-role" (UR_Properties id son))
    )
    (defun UR_CanFreeze:bool (id:string son:bool)
        (at "can-freeze" (UR_Properties id son))
    )
    (defun UR_CanWipe:bool (id:string son:bool)
        (at "can-wipe" (UR_Properties id son))
    )
    (defun UR_CanPause:bool (id:string son:bool)
        (at "can-pause" (UR_Properties id son))
    )
    (defun UR_IsPaused:bool (id:string son:bool)
        (at "is-paused" (UR_Properties id son))
    )
    (defun UR_NoncesUsed:integer (id:string son:bool)
        (at "nonces-used" (UR_Properties id son))
    )
    (defun UR_SetClassesUsed:integer (id:string son:bool)
        (at "set-classes-used" (UR_Properties id son))
    )
    ;; [2] - [Nonce Element] - Only positive nonces can be read this way; Negative Nonces will error out except for <UR_NonceSupply>
    (defun UR_NonceElement:object{DpdcUdcV3.DPDC|NonceElement} (id:string son:bool nonce:integer)
        (read (if son DPSF|T|Nonces DPNF|T|Nonces) (concat [id BAR (format "{}" [nonce])]))
    )
    (defun UR_NonceClass:integer (id:string son:bool nonce:integer)
        (at "nonce-class" (UR_NonceElement id son (abs nonce)))
    )
    (defun UR_NonceValue:integer (id:string son:bool nonce:integer)
        (at "nonce-value" (UR_NonceElement id son nonce))
    )
    (defun UR_NonceSupply:integer (id:string son:bool nonce:integer)
        @doc "Can be used with negative Nonce Value"
        (if (< nonce 0)
            FRG
            (at "nonce-supply" (UR_NonceElement id son (abs nonce)))
        )
    )
    (defun UR_NonceHolder:string (id:string son:bool nonce:integer)
        (at "nonce-holder" (UR_NonceElement id son nonce))
    )
    (defun UR_NativeNonceData:object{DpdcUdcV3.DPDC|NonceData} (id:string son:bool nonce:integer)
        (at "nonce-data" (UR_NonceElement id son nonce))
    )
    (defun UR_SplitNonceData:object{DpdcUdcV3.DPDC|NonceData} (id:string son:bool nonce:integer)
        (at "split-data" (UR_NonceElement id son nonce))
    )
    (defun UR_NonceData:object{DpdcUdcV3.DPDC|NonceData} (id:string son:bool nonce:integer)
        (if (< nonce 0)
            (UR_SplitNonceData id son (abs nonce))
            (UR_NativeNonceData id son nonce)
        )
    )
    ;;
    ;; [2.1] - [Generic Nonce-Data Read]
    (defun UR_N|Royalty:decimal (n:object{DpdcUdcV3.DPDC|NonceData})
        (at "royalty" n)
    )
    (defun UR_N|IgnisRoyalty:decimal (n:object{DpdcUdcV3.DPDC|NonceData})
        (at "ignis" n)
    )
    (defun UR_N|Name:string (n:object{DpdcUdcV3.DPDC|NonceData})
        (at "name" n)
    )
    (defun UR_N|Description:string (n:object{DpdcUdcV3.DPDC|NonceData})
        (at "description" n)
    )
    (defun UR_N|MetaData:object{DpdcUdcV3.NonceMetaData} (n:object{DpdcUdcV3.DPDC|NonceData})
        (at "meta-data" n)
    )
    (defun UR_N|AssetType:object{DpdcUdcV3.URI|Type} (n:object{DpdcUdcV3.DPDC|NonceData})
        (at "asset-type" n)
    )
    (defun UR_N|Primary:object{DpdcUdcV3.URI|Data} (n:object{DpdcUdcV3.DPDC|NonceData})
        (at "uri-primary" n)
    )
    (defun UR_N|Secondary:object{DpdcUdcV3.URI|Data} (n:object{DpdcUdcV3.DPDC|NonceData})
        (at "uri-secondary" n)
    )
    (defun UR_N|Tertiary:object{DpdcUdcV3.URI|Data} (n:object{DpdcUdcV3.DPDC|NonceData})
        (at "uri-tertiary" n)
    )
    ;;  [2.1.1] - [Generic Nonce-MetaData Read]
    (defun UR_N|RawScore:decimal (n:object{DpdcUdcV3.DPDC|NonceData})
        (at "score" (UR_N|MetaData n))
    )
    (defun UR_N|Composition:[integer] (n:object{DpdcUdcV3.DPDC|NonceData})
        (at "composition" (UR_N|MetaData n))
    )
    (defun UR_N|RawMetaData:object (n:object{DpdcUdcV3.DPDC|NonceData})
        (at "meta-data" (UR_N|MetaData n))
    )
    ;;  [2.2] - [Existing Nonce-Data Read]
    ;;  [Uses Above Functions, instead of <n> would use <(UR_NativeNonceData id son nonce)> or <(UR_SplitNonceData id son nonce)>]
    ;;
    ;;  [3] - [VerumRoles]
    (defun UR_VerumRoles:object{DpdcUdcV3.DPDC|VerumRoles} (id:string son:bool)
        (if son
            (read DPSF|T|VerumRoles id)
            (read DPNF|T|VerumRoles id)
        )
    )
    (defun UR_Verum1:[string] (id:string son:bool)
        (at "a-frozen" (UR_VerumRoles id son))
    )
    (defun UR_Verum2:[string] (id:string son:bool)
        (at "r-exemption" (UR_VerumRoles id son))
    )
    (defun UR_Verum3:[string] (id:string son:bool)
        (at "r-nft-add-quantity" (UR_VerumRoles id son))
    )
    (defun UR_Verum4:[string] (id:string son:bool)
        (at "r-nft-burn" (UR_VerumRoles id son))
    )
    (defun UR_Verum5:string (id:string son:bool)
        (at "r-nft-create" (UR_VerumRoles id son))
    )
    (defun UR_Verum6:string (id:string son:bool)
        (at "r-nft-recreate" (UR_VerumRoles id son))
    )
    (defun UR_Verum7:[string] (id:string son:bool)
        (at "r-nft-update" (UR_VerumRoles id son))
    )
    (defun UR_Verum8:[string] (id:string son:bool)
        (at "r-modify-creator" (UR_VerumRoles id son))
    )
    (defun UR_Verum9:[string] (id:string son:bool)
        (at "r-modify-royalties" (UR_VerumRoles id son))
    )
    (defun UR_Verum10:string (id:string son:bool)
        (at "r-set-new-uri" (UR_VerumRoles id son))
    )
    (defun UR_Verum11:[string] (id:string son:bool)
        (at "r-transfer" (UR_VerumRoles id son))
    )
    (defun UR_GetSingleVerum:string (id:string son:bool rp:integer)
        (enforce (contains rp [5 6 10]) "Invalid Position for Single Verum")
        (cond
            ((= rp 5) (UR_Verum5 id son))
            ((= rp 6) (UR_Verum6 id son))
            ((= rp 10) (UR_Verum10 id son))
            BAR
        )
    )
    (defun UR_GetVerumChain:[string] (id:string son:bool rp:integer)
        (enforce (contains rp [1 2 3 4 7 8 9 11]) "Invalid Position for Multi Verum")
        (cond
            ((= rp 1) (UR_Verum1 id son))
            ((= rp 2) (UR_Verum2 id son))
            ((= rp 3) (UR_Verum3 id son))
            ((= rp 4) (UR_Verum4 id son))
            ((= rp 7) (UR_Verum7 id son))
            ((= rp 8) (UR_Verum8 id son))
            ((= rp 9) (UR_Verum9 id son))
            ((= rp 11) (UR_Verum11 id son))
            [BAR]
        )
    )
    ;; [4] - [Account]
    (defun UR_IzAccount:bool (account:string id:string son:bool)
        (let
            (
                (trial 
                    (if son
                        (try false (read DPSF|T|Account (concat [id BAR account])))
                        (try false (read DPNF|T|Account (concat [id BAR account])))
                    )
                ) 
            )
            (if (= (typeof trial) "bool") false true)
        )
    )
    (defun UR_CA|R:object{DpdcUdcV3.AccountRoles} (id:string son:bool account:string)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdcV3} DPDC-UDC)
                (f:bool false)
            )
            (if son
                (with-default-read DPSF|T|Account (concat [id BAR account])
                    { "roles" : (ref-DPDC-UDC::UDC_AccountRoles f f f f f f f f f f)}
                    { "roles" := rolez}
                    rolez
                )
                (with-default-read DPNF|T|Account (concat [id BAR account])
                    { "roles" : (ref-DPDC-UDC::UDC_AccountRoles f f f f f f f f f f)}
                    { "roles" := rolez}
                    rolez
                )
            )
        )
    )
    (defun UR_CA|R-AddQuantity:bool (id:string account:string)
        (with-default-read DPSF|T|Account (concat [id BAR account])
            { "role-nft-add-quantity" : false}
            { "role-nft-add-quantity" := rnaq }
            rnaq
        )
    )
    (defun UR_CA|R-Frozen:bool (id:string son:bool account:string)
        (at "frozen" (UR_CA|R id son account))
    )
    (defun UR_CA|R-Exemption:bool (id:string son:bool account:string)
        (at "role-exemption" (UR_CA|R id son account))
    )
    (defun UR_CA|R-Burn:bool (id:string son:bool account:string)
        (at "role-nft-burn" (UR_CA|R id son account))
    )
    (defun UR_CA|R-Create:bool (id:string son:bool account:string)
        (at "role-nft-create" (UR_CA|R id son account))
    )
    (defun UR_CA|R-Recreate:bool (id:string son:bool account:string)
        (at "role-nft-recreate" (UR_CA|R id son account))
    )
    (defun UR_CA|R-Update:bool (id:string son:bool account:string)
        (at "role-nft-update" (UR_CA|R id son account))
    )
    (defun UR_CA|R-ModifyCreator:bool (id:string son:bool account:string)
        (at "role-modify-creator" (UR_CA|R id son account))
    )
    (defun UR_CA|R-ModifyRoyalties:bool (id:string son:bool account:string)
        (at "role-modify-royalties" (UR_CA|R id son account))
    )
    (defun UR_CA|R-SetUri:bool (id:string son:bool account:string)
        (at "role-set-new-uri" (UR_CA|R id son account))
    )
    (defun UR_CA|R-Transfer:bool (id:string son:bool account:string)
        (at "role-transfer" (UR_CA|R id son account))
    )
    ;; [5] - [AccountSupplies]
    (defun UR_AccountSupply:object{DpdcUdcV3.DPDC|AccountSupply} (account:string id:string son:bool nonce:integer)
        (read
            (if son DPSF|T|AccountSupplies DPNF|T|AccountSupplies)
            (concat [account BAR id BAR (format "{}" [nonce])])
        )
    )
    (defun UR_AccountNonceSupply:integer (account:string id:string son:bool nonce:integer)
        @doc "Returns the Supply of a Nonce on an account, returning -1 if no supply is detected \
        \ If the Account exists and has no supply, it would return as 0."
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdcV3} DPDC-UDC)
                (zs:object{DpdcUdcV3.DPDC|AccountSupply} (ref-DPDC-UDC::UDC_DPDC|AccountSupply BAR BAR -1 -1))
            )
            (at "supply" (try zs (UR_AccountSupply account id son nonce)))
        )
    )
    (defun UR_AccountNoncesSupplies:[integer] (account:string id:string son:bool nonces:[integer])
        @doc "Returns the Supplies of the <nonces> used in the input"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[integer] element:integer)
                    (ref-U|LST::UC_AppL acc (UR_AccountNonceSupply account id son element))
                )
                []
                nonces
            )
        ) 
    )
    ;;{F1}  [URC]
    ;;
    ;;  [URD]
    ;;
    ;;1] Returns Collectables held by Account
    (defun URD_HeldCollectables:[string] (account:string son:bool)
        @doc "Returns all Collectables that are registered for a given <account>"
        (map (at "id")
            (select (if son DPSF|T|Account DPNF|T|Account) ["id"]
                (where "account" (= account))
            )
        )
    )
    ;;2]Returns Accounts that are registered for a given Collectable
    (defun URD_ExistingCollectables:[string] (dpdc:string son:bool)
        @doc "Returns all Ouronet Accounts that are registered for a given <dpdc>"
        (map (at "account")
            (select (if son DPSF|T|Account DPNF|T|Account) ["account"]
                (where "id" (= dpdc))
            )
        )
    )
    ;;3]Returns a List of DPTFs that are owned by a given Account for Management Purposes
    (defun URD_OwnedCollectables:[string] (account:string son:bool)
        @doc "Returns all Collectables that can be managed by the given <account>"
        (map (at "id")
            (select (if son DPSF|T|Properties DPNF|T|Properties) ["id"]
                (where "owner-konto" (= account))
            )
        )
    )
    ;;
    (defun URD_AccountNonces:[integer] (account:string id:string son:bool)
        (let 
            (
                (tbl (if son DPSF|T|AccountSupplies DPNF|T|AccountSupplies))
                (results 
                    (map (at "nonce")
                        (filter
                            (lambda (x) (> (at "supply" x) 0))
                            (select tbl ["nonce" "supply"]
                                (and?
                                    (where "id" (= id))
                                    (where "account" (= account))
                                )
                            )
                        )
                        
                    )
                )
            )
            (if (= (length results) 0) 
                [] 
                results
            )
        )
    )
    (defun URD_AccountNoncesWithSupplies:[object] (account:string id:string son:bool)
        @doc "Returns an object with keys <nonce> and <supply> with the required data"
        (let 
            (
                (tbl (if son DPSF|T|AccountSupplies DPNF|T|AccountSupplies))
                (results 
                    (select tbl ["nonce" "supply"]
                        (and?
                            (where "id" (= id))
                            (where "account" (= account))
                        )
                    )
                )
            )
            (if (= (length results) 0) 
                [{}] 
                (filter (lambda (x) (> (at "supply" x) 0)) results)
            )
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_id (id:string son:bool)
        (if son
            (with-default-read DPSF|T|Properties id
                { "nonces-used"   : -1 }
                { "nonces-used"   := ne }
                (enforce (>= ne 0) (format "DPSF ID {} does not exist" [id]))
            )
            (with-default-read DPNF|T|Properties id
                { "nonces-used"   : -1 }
                { "nonces-used"   := ne }
                (enforce (>= ne 0) (format "DPNF ID {} does not exist" [id]))
            )
        )
    )
    (defun UEV_NonceMapper (id:string son:bool nonces:[integer])
        (map
            (lambda
                (idx:integer)
                (UEV_Nonce id son (at idx nonces))
            )
            (enumerate 0 (- (length nonces) 1))
        )
    )
    (defun UEV_Nonce (id:string son:bool nonce:integer)
        (let
            (
                (an:integer (abs nonce))
                (nv:integer (UR_NonceValue id son an))
                (nu:integer (UR_NoncesUsed id son))
            )
            (enforce
                (fold (and) true [(!= an 0) (<= an nu) (= an nv)])
                "Invalid Nonce Value"
            )
        )
    )
    (defun UEV_CanUpgradeON (id:string son:bool)
        (let
            (
                (x:bool (UR_CanUpgrade id son))
            )
            (enforce x (format "{} properties cannot be upgraded" [id]))
        )
    )
    (defun UEV_CanPauseON (id:string son:bool)
        (let
            (
                (x:bool (UR_CanPause id son))
            )
            (enforce x (format "{} cannot be paused" [id]))
        )
    )
    (defun UEV_CanAddSpecialRoleON (id:string son:bool)
        (let
            (
                (x:bool (UR_CanAddSpecialRole id son))
            )
            (enforce x (format "For {} no special roles can be added" [id]))
        )
    )
    (defun UEV_ToggleSpecialRole (id:string son:bool toggle:bool)
        (if toggle
            (UEV_CanAddSpecialRoleON id son)
            true
        )
    )
    (defun UEV_CanFreezeON (id:string son:bool)
        (let
            (
                (x:bool (UR_CanFreeze id son))
            )
            (enforce x (format "{} cannot be freezed" [id]))
        )
    )
    (defun UEV_CanWipeON (id:string son:bool)
        (let
            (
                (x:bool (UR_CanWipe id son))
            )
            (enforce x (format "{} cannot be wiped" [id]))
        )
    )
    (defun UEV_PauseState (id:string son:bool state:bool)
        (let
            (
                (x:bool (UR_IsPaused id son)) ;;false
            )
            (if state
                (enforce x (format "{} is already unpaused" [id]))
                (enforce (not x) (format "{} is already paused" [id]))
            )
        )
    )
    (defun UEV_AccountAddQuantityState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-AddQuantity id account))
            )
            (enforce (= x state) (format "Add Quantity Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountFreezeState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Frozen id son account))
            )
            (enforce (= x state) (format "Frozen for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountExemptionState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Exemption id son account))
            )
            (enforce (= x state) (format "Exemption Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountBurnState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Burn id son account))
            )
            (enforce (= x state) (format "NFT Burn Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountUpdateState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Update id son account))
            )
            (enforce (= x state) (format "NFT Update Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountModifyCreatorState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-ModifyCreator id son account))
            )
            (enforce (= x state) (format "Modify Creator Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountModifyRoyaltiesState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-ModifyRoyalties id son account))
            )
            (enforce (= x state) (format "Modify Royalties Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountTransferState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Transfer id son account))
            )
            (enforce (= x state) (format "Transfer Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountCreateState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Create id son account))
            )
            (enforce (= x state) (format "Create Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountRecreateState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-Recreate id son account))
            )
            (enforce (= x state) (format "Recreate Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountSetUriState (id:string son:bool account:string state:bool)
        (let
            (
                (x:bool (UR_CA|R-SetUri id son account))
            )
            (enforce (= x state) (format "Set Uri Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_Royalty (royalty:decimal)
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
            )
            (ref-U|DALOS::UEV_Fee royalty)
        )
    )
    (defun UEV_IgnisRoyalty (royalty:decimal)
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                ;;
                (ignis-id:string (ref-DALOS::UR_IgnisID))
                (ignis-pr:integer (ref-DPTF::UR_Decimals ignis-id))
            )
            (enforce
                (= (floor royalty ignis-pr) royalty)
                (format "The Ignis input amount of {} is not conform with its precision" [royalty])
            )
        )
    )
    (defun UEV_NftNonceExistance (id:string nonce:integer existance:bool)
        (let
            (
                (x:bool (UR_NonceHolder id false nonce))
                (ft:string (format "NFT {} Nonce {} must have Existance set to {} for Operation" [id nonce existance]))
            )
            (if (> nonce 0)
                (if existance
                    (enforce (!= x BAR) ft)
                    (enforce (= x BAR) ft)
                )
                (let
                    (
                        (ref-DPDC-UDC:module{DpdcUdcV3} DPDC-UDC)
                        (split-data:object{DpdcUdcV3.DPDC|NonceData} (UR_SplitNonceData id false nonce))
                        (znd:object{DpdcUdcV3.DPDC|NonceData} (ref-DPDC-UDC::UDC_ZeroNonceData))
                    )
                    (if existance
                        (enforce (!= split-data znd) ft)
                        (enforce (= split-data znd) ft)
                    )
                )
            )
        )
    )
    (defun UEV_NonceQuantityInclusion (account:string id:string son:bool nonce:integer amount:integer)
        (let
            (
                (nonce-supply:integer (UR_AccountNonceSupply account id son nonce))
            )
            (if (or son (< nonce 0))
                (enforce 
                    (<= amount nonce-supply) 
                    (format 
                        "Account {} doesnt hold {} {} Nonce {} in sufficient quantity for Operation!" 
                        [account (if son "SFT" "NFT") id nonce]
                    )
                )
                (let
                    (
                        (ref-I|OURONET:module{OuronetInfoV4} INFO-ZERO)
                        (nft-holder:string (UR_NonceHolder id false nonce))
                        (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
                    )
                    (enforce (= sa nft-holder) (format "Account {} doesnt hold NFT {} Nonce {}" [account id nonce]))
                )
            )
        )
    )
    (defun UEV_NonceQuantityInclusionMapper (account:string id:string son:bool nonces:[integer] amounts:[integer])
        (map
            (lambda
                (idx:integer)
                (UEV_NonceQuantityInclusion account id son (at idx nonces) (at idx amounts))
            )
            (enumerate 0 (- (length nonces) 1))
        )
    )
    ;;{F3}  [UDC]
    (defun UDC_Control:object{DpdcUdcV3.DPDC|PropertiesV2}
        (id:string son:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdcV3} DPDC-UDC)
            )
            (ref-DPDC-UDC::UDC_DPDC|PropertiesV2
                id
                (UR_OwnerKonto id son)
                (UR_CreatorKonto id son)
                (UR_Name id son)
                (UR_Ticker id son)
                cu cco ccc casr ctncr cf cw cp
                (UR_IsPaused id son)
                (UR_NoncesUsed id son)
                (UR_SetClassesUsed id son)
            )
        )
    )
    ;;
    ;;{F4}  [CAP]
    (defun CAP_Owner (id:string son:bool)
        @doc "Enforces DPSF or DPNF Token ID Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (UR_OwnerKonto id son))
        )
    )
    (defun CAP_Creator (id:string son:bool)
        @doc "Enforces DPSF or DPNF Token ID Creator Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (UR_CreatorKonto id son))
        )
    )
    (defun CAP_OwnerOrCreator (id:string son:bool)
        @doc "Enforces DPSF or DPNF Token ID Owner or Creator Ownership"
        (enforce-one
            (format "Owner or Creator for {} {} not verified" [(if son "DPSF" "DPNF") id])
            [
                (enforce-guard (create-user-guard (CAP_Owner id son)))
                (enforce-guard (create-user-guard (CAP_Creator id son)))
            ]
        )
    )
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_UpdatePendingBranding:object{IgnisCollectorV2.OutputCumulator}
        (entity-id:string son:bool logo:string description:string website:string social:[object{Branding.SocialSchema}])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-BRD:module{Branding} BRD)
                (owner:string (UR_OwnerKonto entity-id son))
                (multiplier:decimal (if son 4.0 5.0))
            )
            (with-capability (DPDC|C>UPDATE-BRD entity-id son)
                (ref-BRD::XE_UpdatePendingBranding entity-id logo description website social)
                (ref-IGNIS::UDC_BrandingCumulator owner multiplier)
            )
        )
    )
    (defun C_UpgradeBranding (patron:string entity-id:string son:bool months:integer)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-BRD:module{Branding} BRD)
                (owner:string (UR_OwnerKonto entity-id son))
                (kda-payment:decimal
                    (with-capability (DPDC|C>UPGRADE-BRD entity-id son)
                        (ref-BRD::XE_UpgradeBranding entity-id owner months)
                    )
                )
            )
            (ref-IGNIS::KDA|C_CollectWT patron kda-payment false)
        )
    )
    ;;
    ;;{F7}  [X]
    ;; [<AccountsTable> Writings] [0]
    (defun XB_DeployAccountSFT
        (
            account:string id:string
            input-rnaq:bool f:bool re:bool rnb:bool rnc:bool rnr:bool
            rnu:bool rmc:bool rmr:bool rsnu:bool rt:bool
        )
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPDC-UDC:module{DpdcUdcV3} DPDC-UDC)
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id true)
            (with-default-read DPSF|T|Account (concat [id BAR account])
                (ref-DPDC-UDC::UDC_DPSF|AccountRolesV2
                    (ref-DPDC-UDC::UDC_AccountRoles f re rnb rnc rnr rnu rmc rmr rsnu rt)
                    input-rnaq
                    id account
                )
                {"roles"                    := r
                ,"role-nft-add-quantity"    := rnaq
                ,"id"                       := i
                ,"account"                  := a}
                (write DPSF|T|Account (concat [id BAR account])
                    (ref-DPDC-UDC::UDC_DPSF|AccountRolesV2 r rnaq i a)
                )
            )
        )
    )
    (defun XB_DeployAccountNFT 
        (
            account:string id:string
            f:bool re:bool rnb:bool rnc:bool rnr:bool
            rnu:bool rmc:bool rmr:bool rsnu:bool rt:bool
        )
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPDC-UDC:module{DpdcUdcV3} DPDC-UDC)
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id false)
            (with-default-read DPNF|T|Account (concat [id BAR account])
                (ref-DPDC-UDC::UDC_DPNF|AccountRolesV2
                    (ref-DPDC-UDC::UDC_AccountRoles f re rnb rnc rnr rnu rmc rmr rsnu rt)
                    id account
                )
                {"roles"                    := r
                ,"id"                       := i
                ,"account"                  := a}
                (write DPNF|T|Account (concat [id BAR account])
                    (ref-DPDC-UDC::UDC_DPNF|AccountRolesV2 r i a)
                )
            )
        )
    )
    (defun XE_DeployAccountWNE (account:string id:string son:bool)
        (let
            (
                (collection-account-exists:bool (UR_IzAccount account id son))
                (f:bool false)
            )
            (if (not collection-account-exists)
                (if son
                    (XB_DeployAccountSFT account id f f f f f f f f f f f)
                    (XB_DeployAccountNFT account id f f f f f f f f f f)
                )
                true
            )
        )
    )
    ;;
    (defun XE_U|Rnaq (id:string account:string toggle)
        (UEV_IMC)
        (update DPSF|T|Account (concat [id BAR account])
            {"role-nft-add-quantity" : toggle}
        )
    )
    (defun XI_U|AccountRoles (id:string son:bool account:string new-roles:object{DpdcUdcV3.AccountRoles})
        (require-capability (SECURE))
        (if son
            (update DPSF|T|Account (concat [id BAR account])
                {"roles" : new-roles}
            )
            (update DPNF|T|Account (concat [id BAR account])
                {"roles" : new-roles}
            )
        )
    )
    ;; [<PropertiesTable> Writings] [1]
    (defun XE_I|Collection
        (id:string son:bool idp:object{DpdcUdcV3.DPDC|PropertiesV2})
        (UEV_IMC)
        (if son
            (insert DPSF|T|Properties id idp)
            (insert DPNF|T|Properties id idp)
        )
    )
    (defun XE_U|Specs (id:string son:bool specs:object{DpdcUdcV3.DPDC|PropertiesV2})
        (UEV_IMC)
        (if son
            (update DPSF|T|Properties id specs)
            (update DPNF|T|Properties id specs)
        )
    )
    (defun XE_U|IsPaused (id:string son:bool toggle:bool)
        (UEV_IMC)
        (if son
            (update DPSF|T|Properties id {"is-paused" : toggle})
            (update DPNF|T|Properties id {"is-paused" : toggle})
        )
    )
    (defun XE_U|NoncesUsed (id:string son:bool new-nv:integer)
        (UEV_IMC)
        (if son
            (update DPSF|T|Properties id {"nonces-used" : new-nv})
            (update DPNF|T|Properties id {"nonces-used" : new-nv})
        )
    )
    (defun XE_U|SetClassesUsed (id:string son:bool new-nsc:integer)
        (UEV_IMC)
        (if son
            (update DPSF|T|Properties id {"set-classes-used" : new-nsc})
            (update DPNF|T|Properties id {"set-classes-used" : new-nsc})
        )
    )
    ;; [<NoncesTable> Writings] [2]
    (defun XE_I|CollectionElement (id:string son:bool nonce-value:integer ned:object{DpdcUdcV3.DPDC|NonceElement})
        (UEV_IMC)
        (if son
            (insert DPSF|T|Nonces (concat [id BAR (format "{}" [nonce-value])]) ned)
            (insert DPNF|T|Nonces (concat [id BAR (format "{}" [nonce-value])]) ned)
        )
    )
    (defun XE_U|NonceSupply (id:string nonce-value:integer new-supply:integer)
        (UEV_IMC)
        (update DPSF|T|Nonces (concat [id BAR (format "{}" [nonce-value])]) {"nonce-supply" : new-supply})
    )
    (defun XE_U|NonceHolder (id:string nonce-value:integer new-holder-account:string)
        (UEV_IMC)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV4} INFO-ZERO)
                (iz-bar:bool (if (= new-holder-account BAR) true false))
                (sh:string
                    (if iz-bar
                        BAR
                        (ref-I|OURONET::OI|UC_ShortAccount new-holder-account)
                    )
                )
            )
            (update DPNF|T|Nonces (concat [id BAR (format "{}" [nonce-value])]) {"nonce-holder" : sh})
        )
    )
    (defun XE_U|NonceOrSplitData (id:string son:bool nonce-value:integer nos:bool nd:object{DpdcUdcV3.DPDC|NonceData} )
        (UEV_IMC)
        (if nos
            (if son
                (update DPSF|T|Nonces (concat [id BAR (format "{}" [nonce-value])]) {"nonce-data" : nd})
                (update DPNF|T|Nonces (concat [id BAR (format "{}" [nonce-value])]) {"nonce-data" : nd})
            )
            (if son
                (update DPSF|T|Nonces (concat [id BAR (format "{}" [nonce-value])]) {"split-data" : nd})
                (update DPNF|T|Nonces (concat [id BAR (format "{}" [nonce-value])]) {"split-data" : nd})
            )
        )
    )
    ;; [<VerumRolesTable> Writings] [3]
    (defun XE_I|VerumRoles (id:string son:bool verum-chain:object{DpdcUdcV3.DPDC|VerumRoles})
        (UEV_IMC)
        (if son
            (insert DPSF|T|VerumRoles id verum-chain)
            (insert DPNF|T|VerumRoles id verum-chain)
        )
    )
    (defun XI_U|VerumRole1 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|T|VerumRoles id {"a-frozen" : ul})
            (update DPNF|T|VerumRoles id {"a-frozen" : ul})
        )
    )
    (defun XI_U|VerumRole2 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|T|VerumRoles id {"r-exemption" : ul})
            (update DPNF|T|VerumRoles id {"r-exemption" : ul})
        )
    )
    (defun XI_U|VerumRole3 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|T|VerumRoles id {"r-nft-add-quantity" : ul})
            (update DPNF|T|VerumRoles id {"r-nft-add-quantity" : ul})
        )
    )
    (defun XI_U|VerumRole4 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|T|VerumRoles id {"r-nft-burn" : ul})
            (update DPNF|T|VerumRoles id {"r-nft-burn" : ul})
        )
    )
    (defun XI_U|VerumRole5 (id:string son:bool ul:string)
        (require-capability (SECURE))
        (if son
            (update DPSF|T|VerumRoles id {"r-nft-create" : ul})
            (update DPNF|T|VerumRoles id {"r-nft-create" : ul})
        )
    )
    (defun XI_U|VerumRole6 (id:string son:bool ul:string)
        (require-capability (SECURE))
        (if son
            (update DPSF|T|VerumRoles id {"r-nft-recreate" : ul})
            (update DPNF|T|VerumRoles id {"r-nft-recreate" : ul})
        )
    )
    (defun XI_U|VerumRole7 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|T|VerumRoles id {"r-nft-update" : ul})
            (update DPNF|T|VerumRoles id {"r-nft-update" : ul})
        )
    )
    (defun XI_U|VerumRole8 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|T|VerumRoles id {"r-modify-creator" : ul})
            (update DPNF|T|VerumRoles id {"r-modify-creator" : ul})
        )
    )
    (defun XI_U|VerumRole9 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|T|VerumRoles id {"r-modify-royalties" : ul})
            (update DPNF|T|VerumRoles id {"r-modify-royalties" : ul})
        )
    )
    (defun XI_U|VerumRole10 (id:string son:bool ul:string)
        (require-capability (SECURE))
        (if son
            (update DPSF|T|VerumRoles id {"r-set-new-uri" : ul})
            (update DPNF|T|VerumRoles id {"r-set-new-uri" : ul})
        )
    )
    (defun XI_U|VerumRole11 (id:string son:bool ul:[string])
        (require-capability (SECURE))
        (if son
            (update DPSF|T|VerumRoles id {"r-transfer" : ul})
            (update DPNF|T|VerumRoles id {"r-transfer" : ul})
        )
    )
    ;;
    ;;  [Indirect Writings]
    ;;
    (defun XE_U|Frozen (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"frozen" : toggle}
                    (remove "frozen" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|Exemption (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-exemption" : toggle}
                    (remove "role-exemption" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|Burn (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-nft-burn" : toggle}
                    (remove "role-nft-burn" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|Create (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-nft-create" : toggle}
                    (remove "role-nft-create" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|Recreate (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-nft-recreate" : toggle}
                    (remove "role-nft-recreate" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|Update (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-nft-update" : toggle}
                    (remove "role-nft-update" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|ModifyCreator (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-modify-creator" : toggle}
                    (remove "role-modify-creator" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|ModifyRoyalties (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-modify-royalties" : toggle}
                    (remove "role-modify-royalties" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|SetNewUri (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-set-new-uri" : toggle}
                    (remove "role-set-new-uri" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|Transfer (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (with-capability (SECURE) 
            (XI_U|AccountRoles id son account
                (+
                    {"role-transfer" : toggle}
                    (remove "role-transfer" (UR_CA|R id son account))
                )
            )
        )
    )
    (defun XE_U|VerumRoles (id:string son:bool rp:integer aor:bool account:string)
        (UEV_IMC)
        (if (contains rp [5 6 10])
            (if aor
                (with-capability (SECURE)
                    (cond
                        ((= rp 5) (XI_U|VerumRole5 id son account))
                        ((= rp 6) (XI_U|VerumRole6 id son account))
                        ((= rp 10) (XI_U|VerumRole10 id son account))
                        true
                    )
                )
                true
            )
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                    (current-verum-chain:[string] (UR_GetVerumChain id son rp))
                    (ul:[string] (ref-U|DALOS::UC_NewRoleList current-verum-chain account aor))
                )
                (with-capability (SECURE)
                    (cond
                        ((= rp 1) (XI_U|VerumRole1 id son ul))
                        ((= rp 2) (XI_U|VerumRole2 id son ul))
                        ((= rp 3) (XI_U|VerumRole3 id son ul))
                        ((= rp 4) (XI_U|VerumRole4 id son ul))
                        ((= rp 7) (XI_U|VerumRole7 id son ul))
                        ((= rp 8) (XI_U|VerumRole8 id son ul))
                        ((= rp 9) (XI_U|VerumRole9 id son ul))
                        ((= rp 11) (XI_U|VerumRole11 id son ul))
                        true
                    )
                )
            )
        )
    )
    ;;
    (defun XE_W|Supply (account:string id:string son:bool nonce-value:integer amount:integer)
        (UEV_IMC)
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdcV3} DPDC-UDC)
                (tbl (if son DPSF|T|AccountSupplies DPNF|T|AccountSupplies))
                (ki:string (concat [account BAR id BAR (format "{}" [nonce-value])]) )
            )
            (with-default-read tbl ki
                (ref-DPDC-UDC::UDC_DPDC|AccountSupply account id nonce-value -1)
                {"account"  := a
                ,"id"       := b
                ,"nonce"    := c
                ,"supply"   := d}
                (write tbl ki
                    (ref-DPDC-UDC::UDC_DPDC|AccountSupply a b c amount)
                )
            )
            
        )
    )
    ;;
    ;;{F8}  [AUP - Admin Update Functions]
    ;;
    (defcap AHU ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ah:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
            )
            (ref-DALOS::CAP_EnforceAccountOwnership ah)
            (compose-capability (SECURE))
        )
    )
    ;;get keys with (UR_AS-KEYS son)
    (defun AUP_SFTs (kis:[string])
        (with-capability (AHU)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                )
                (map
                    (lambda
                        (ki:string)
                        (let
                            (
                                (str-lst:[string] (ref-U|LST::UC_SplitString BAR ki))
                                (l:integer (length str-lst))
                                (account:string 
                                    (at 0 str-lst))
                                
                                (id:string 
                                    (if (= l 3)
                                        (at 1 str-lst)
                                        (concat [(at 1 str-lst) BAR (at 2 str-lst)])
                                    )
                                )
                                (read-nonce:string
                                    (if (= l 3)
                                        (at 2 str-lst)
                                        (at 3 str-lst)
                                    )
                                )   
                                (nonce:integer (UC_ParseSignedInteger read-nonce))
                            )
                            (update DPSF|T|AccountSupplies ki
                                {"account"  : account
                                ,"id"       : id
                                ,"nonce"    : nonce}
                            )
                        )
                    )
                    kis
                )
            )
        )
    )
    (defun AUP_NFTs (kis:[string])
        (with-capability (AHU)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                )
                (map
                    (lambda
                        (ki:string)
                        (let
                            (
                                (str-lst:[string] (ref-U|LST::UC_SplitString BAR ki))
                                (account:string (at 0 str-lst))
                                (id:string  (at 1 str-lst)) 
                                (nonce:integer (UC_ParseSignedInteger (at 2 str-lst)))
                            )
                            (update DPNF|T|AccountSupplies ki
                                {"account"  : account
                                ,"id"       : id
                                ,"nonce"    : nonce}
                            )
                        )
                    )
                    kis
                )
            )
        )
    )
    (defun AUP_Accounts (keyz:[string] son:bool)
        @doc "Get <keyz> with <(keys (if son DPSF|T|Account DPNF|T|Account))>, or update one a time"
        (with-capability (AHU)
            (map
                (lambda
                    (idx:integer)
                    (AUP_Account (at idx keyz) son)
                )
                (enumerate 0 (- (length keyz) 1))
            )
        )
    )
    (defun AUP_Account (ky:string son:bool)
        (require-capability (SECURE))
        (update (if son DPSF|T|Account DPNF|T|Account) ky
            {"id"       : (drop -163 ky)
            ,"account"  : (take -162 ky)}
        )
    )
    (defun AUP_Properties (ids:[string] son:bool)
        @doc "Get <ids> with <(keys (if son DPSF|T|Properties DPNF|T|Properties))>, or update one a time"
        (with-capability (AHU)
            (map
                (lambda
                    (idx:integer)
                    (AUP_Property (at idx ids) son)
                )
                (enumerate 0 (- (length ids) 1))
            )
        )
    )
    (defun AUP_Property (id:string son:bool)
        (require-capability (SECURE))
        (update (if son DPSF|T|Properties DPNF|T|Properties) id
            {"id"       : id}
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)
;;DPSF
(create-table DPSF|T|Properties)
(create-table DPSF|T|Nonces)
(create-table DPSF|T|VerumRoles)
(create-table DPSF|T|Account)
(create-table DPSF|T|AccountSupplies)
;;DPNF
(create-table DPNF|T|Properties)
(create-table DPNF|T|Nonces)
(create-table DPNF|T|VerumRoles)
(create-table DPNF|T|Account)
(create-table DPNF|T|AccountSupplies)