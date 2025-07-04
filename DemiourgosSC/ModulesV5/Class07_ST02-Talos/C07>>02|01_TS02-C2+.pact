(interface TalosStageTwo_ClientTwo
    @doc "Exposes Client NFT Functions"
    ;;
    ;;  [2] DPDC
    ;;
    (defun DPNF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun DPNF|C_UpgradeBranding (patron:string entity-id:string months:integer))
    ;;
    ;;  [3] DPDC-C
    ;;
    (defun DPNF|C_Create:string
        (
            patron:string id:string
            input-nonce-data:[object{DpdcUdc.DPDC|NonceData}]
        )
    )
    ;;
    ;;  [4] DPDC-I
    ;;
    (defun DPNF|C_DeployAccount (patron:string id:string account:string))
    (defun DPNF|C_Issue:string
        (
            patron:string 
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
    )
    ;;
    ;;  [5] DPDC-R
    ;;
    (defun DPNF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool))
    (defun DPNF|C_ToggleExemptionRole (patron:string id:string account:string toggle:bool))
    (defun DPNF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool))
    (defun DPNF|C_ToggleUpdateRole (patron:string id:string account:string toggle:bool))
    (defun DPNF|C_ToggleModifyCreatorRole (patron:string id:string account:string toggle:bool))
    (defun DPNF|C_ToggleModifyRoyaltiesRole (patron:string id:string account:string toggle:bool))
    (defun DPNF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool))
    (defun DPNF|C_MoveCreateRole (patron:string id:string new-account:string))
    (defun DPNF|C_MoveRecreateRole (patron:string id:string new-account:string))
    (defun DPNF|C_MoveSetUriRole (patron:string id:string new-account:string))
    ;;
    ;;  [6] DPDC-MNG
    ;;
    (defun DPNF|C_Control (patron:string id:string cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool))
    (defun DPNF|C_TogglePause (patron:string id:string toggle:bool))
    ;;
    ;;  [7] DPDC-T
    ;;
    ;;
    ;;  [8] DPDC-S
    ;;
    (defun DPNF|C_DefinePrimordialSet 
        (
            patron:string id:string set-name:string 
            set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun DPNF|C_DefineCompositeSet
        (
            patron:string id:string set-name:string 
            set-definition:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun DPNF|C_EnableSetClassFragmentation
        (
            patron:string id:string set-class:integer
            fragmentation-ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun DPNF|C_ToggleSet (patron:string id:string set-class:integer toggle:bool))
    (defun DPNF|C_RenameSet (patron:string id:string set-class:integer new-name:string))
    ;;
    (defun DPNF|C_UpdateSetNonce (patron:string id:string account:string nonce:integer native-or-split:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData}))
    (defun DPNF|C_UpdateSetNonceRoyalty (patron:string id:string account:string nonce:integer native-or-split:bool royalty-value:decimal))
    (defun DPNF|C_UpdateSetNonceIgnisRoyalty (patron:string id:string account:string nonce:integer native-or-split:bool royalty-value:decimal))
    (defun DPNF|C_UpdateSetNonceName (patron:string id:string account:string nonce:integer native-or-split:bool name:string))
    (defun DPNF|C_UpdateSetNonceDescription (patron:string id:string account:string nonce:integer native-or-split:bool description:string))
    (defun DPNF|C_UpdateSetNonceScore (patron:string id:string account:string nonce:integer native-or-split:bool score:decimal))
    (defun DPNF|C_RemoveSetNonceScore (patron:string id:string account:string nonce:integer native-or-split:bool))
    (defun DPNF|C_UpdateSetNonceMetaData (patron:string id:string account:string nonce:integer native-or-split:bool meta-data:[object]))
    (defun DPNF|C_UpdateSetNonceURI
        (
            patron:string id:string account:string nonce:integer native-or-split:bool
            ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}
        )
    )
    ;;
    ;;  [9] DPDC-F
    ;;
    (defun DPNF|C_EnableNonceFragmentation (patron:string id:string nonce:integer fragmentation-ind:object{DpdcUdc.DPDC|NonceData}))
    ;;
    ;;  [10] DPDC-N
    ;;
    (defun DPNF|C_UpdateNonce (patron:string id:string account:string nonce:integer native-or-split:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData}))
    (defun DPNF|C_UpdateNonceRoyalty (patron:string id:string account:string nonce:integer native-or-split:bool royalty-value:decimal))
    (defun DPNF|C_UpdateNonceIgnisRoyalty (patron:string id:string account:string nonce:integer native-or-split:bool royalty-value:decimal))
    (defun DPNF|C_UpdateNonceName (patron:string id:string account:string nonce:integer native-or-split:bool name:string))
    (defun DPNF|C_UpdateNonceDescription (patron:string id:string account:string nonce:integer native-or-split:bool description:string))
    (defun DPNF|C_UpdateNonceScore (patron:string id:string account:string nonce:integer native-or-split:bool score:decimal))
    (defun DPNF|C_RemoveNonceScore (patron:string id:string account:string nonce:integer native-or-split:bool))
    (defun DPNF|C_UpdateNonceMetaData (patron:string id:string account:string nonce:integer native-or-split:bool meta-data:[object]))
    (defun DPNF|C_UpdateNonceURI
        (
            patron:string id:string account:string nonce:integer native-or-split:bool
            ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}
        )
    )
    ;;
)
(module TS02-C2 GOV
    @doc "TALOS Stage 2 Client Functiones Part 2 - NFT Functions"
    ;;
    (implements OuronetPolicy)
    (implements TalosStageTwo_ClientTwo)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_TS02-C2        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TS02-C2_ADMIN)))
    (defcap GOV|TS02-C2_ADMIN ()    (enforce-guard GOV|MD_TS02-C2))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|TS ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (gap:bool (ref-DALOS::UR_GAP))
            )
            (enforce (not gap) "While Global Administrative Pause is online, no client Functions can be executed")
            (compose-capability (P|TALOS-SUMMONER))
        )
    )
    (defcap P|TALOS-SUMMONER ()
        @doc "Talos Summoner Capability"
        true
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
        (with-capability (GOV|TS02-C2_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|TS02-C2_ADMIN)
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
                (ref-P|TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                (ref-P|DPDC:module{OuronetPolicy} DPDC)
                (ref-P|DPDC-C:module{OuronetPolicy} DPDC-C)
                (ref-P|DPDC-I:module{OuronetPolicy} DPDC-I)
                (ref-P|DPDC-R:module{OuronetPolicy} DPDC-R)
                (ref-P|DPDC-MNG:module{OuronetPolicy} DPDC-MNG)
                (ref-P|DPDC-N:module{OuronetPolicy} DPDC-N)
                (ref-P|DPDC-T:module{OuronetPolicy} DPDC-T)
                (ref-P|DPDC-F:module{OuronetPolicy} DPDC-F)
                (ref-P|DPDC-S:module{OuronetPolicy} DPDC-S)
                (mg:guard (create-capability-guard (P|TALOS-SUMMONER)))
            )
            (ref-P|TS01-A::P|A_AddIMP mg)
            (ref-P|DPDC::P|A_AddIMP mg)
            (ref-P|DPDC-C::P|A_AddIMP mg)
            (ref-P|DPDC-I::P|A_AddIMP mg)
            (ref-P|DPDC-R::P|A_AddIMP mg)
            (ref-P|DPDC-MNG::P|A_AddIMP mg)
            (ref-P|DPDC-N::P|A_AddIMP mg)
            (ref-P|DPDC-T::P|A_AddIMP mg)
            (ref-P|DPDC-F::P|A_AddIMP mg)
            (ref-P|DPDC-S::P|A_AddIMP mg)
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
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;
    ;;  [2] DPDC
    ;;
    (defun DPNF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for DPNF Token <entity-id> costing 500 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC:module{Dpdc} DPDC)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC::C_UpdatePendingBranding entity-id false logo description website social)
                )
            )
        )
    )
    (defun DPNF|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Upgrades Branding for DPNF Token, making it a premium Branding. \
            \ Also sets pending-branding to live branding if its branding is not live yet"
        (with-capability (P|TS)
            (let
                (
                    (ref-DPDC:module{Dpdc} DPDC)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                )
                (ref-DPDC::C_UpgradeBranding patron entity-id false months)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    ;;
    ;;  [3] DPDC-C
    ;;
    (defun DPNF|C_Create:string
        (
            patron:string id:string
            input-nonce-data:[object{DpdcUdc.DPDC|NonceData}]
        )
        @doc "Creates a new NFT Collection Element(s), having a new nonce, \
            \ of amount 1, on the <creator> account."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                    (l:integer (length input-nonce-data))
                    (ico:object{IgnisCollector.OutputCumulator}
                        (if (= l 1)
                            (ref-DPDC-C::C_CreateNewNonce
                                id false 0 1 (at 0 input-nonce-data) false
                            )
                            (ref-DPDC-C::C_CreateNewNonces
                                id false (make-list l 1) input-nonce-data
                            )
                        )
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (format "Created {} Clas 0 NonFungible(s) within the {} DPNF Collection"
                    [(at "output" ico) id]
                )
            )
        )
    )
    ;;
    ;;  [4] DPDC-I
    ;;
    (defun DPNF|C_DeployAccount (patron:string id:string account:string)
        @doc "Deploys a DPNF Account. Stand Alone Deployment costs 3 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-I:module{DpdcIssue} DPDC-I)
                )
                (ref-DPDC-I::C_DeployAccountNFT id account)
                (ref-IGNIS::IC|C_Collect patron
                    (ref-IGNIS::IC|UDC_MediumCumulator account)
                )
            )
        )
    )
    (defun DPNF|C_Issue:string
        (
            patron:string 
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
        @doc "Issues a new DPNF (Demiourgos Pact Non-Fungible) Digital Collection: <NFT> \
            \ Costs 10x<ignis|token-issue> = 5000 IGNIS and 500 KDA"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-I:module{DpdcIssue} DPDC-I)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-DPDC-I::C_IssueDigitalCollection
                            patron false 
                            owner-account creator-account collection-name collection-ticker
                            can-upgrade can-change-owner can-change-creator can-add-special-role
                            can-transfer-nft-create-role can-freeze can-wipe can-pause
                        )
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    ;;
    ;;  [5] DPDC-R
    ;;
    (defun DPNF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Freezes a given account for a given DPNF Token. Frozen Accounts can no longer send or receive that DPNF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_ToggleFreezeAccount id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleExemptionRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles exemption Role for a given DPNF on a given Smart Ouronet Account (Only Smart Ouronet Accounts can accept this role) \
            \ When sending to or receiving from such Accounts, the flat IGNIS Royalty fee must not be paid."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_ToggleExemptionRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles burn Role for a given DPNF on any Ouronet Account. \
            \ Such Accounts can then burn the DPNF"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_ToggleBurnRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleUpdateRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles update Role for a given DPNF on any Ouronet Account. \
            \ Such Accounts can then update (modify) the Metadata on any DPNF nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_ToggleUpdateRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleModifyCreatorRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles Modify Creator Role for a given DPNF on any Ouronet Account. \
            \ Such Accounts can proceed to modify the Creator of the DPNF Collection"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_ToggleModifyCreatorRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleModifyRoyaltiesRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles Modify Royalties Role for a given DPNF on any Ouronet Account. \
            \ Such Accounts can proceed to modify the Permille Royalty of any nonce in the  DPNF Collection"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_ToggleModifyRoyaltiesRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles Transfer Role for a given DPNF on any Ouronet Account. \
            \ Transfers for any Nonce in the DPNF Collection are then restricted only to and from these accounts"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_ToggleTransferRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_MoveCreateRole (patron:string id:string new-account:string)
        @doc "Moves the Create Role to another Ouronet Account. A single Account may have this Role \
            \ This is the only account that can issue new NFTs in the Collection"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_MoveCreateRole id false new-account)
                )
            )
        )
    )
    (defun DPNF|C_MoveRecreateRole (patron:string id:string new-account:string)
        @doc "Moves the Recreate Role to another Ouronet Account. A single Account may have this Role \
            \ This is the only account that can recreate any existing NFT in the Collection \
            \ Recreation reffers to a complete update (modification) of all NFT properties of a given nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_MoveRecreateRole id false new-account)
                )
            )
        )
    )
    (defun DPNF|C_MoveSetUriRole (patron:string id:string new-account:string)
        @doc "Moves the Set URI Role to another Ouronet Account. A single Account may have this Role \
            \ This is the only account that can modify the URIs of any nonce in the NFT Collection"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_MoveSetUriRole id false new-account)
                )
            )
        )
    )
    ;;
    ;;  [6] DPDC-MNG
    ;;
    (defun DPNF|C_Control (patron:string id:string cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        @doc "Controls DPNF Properties"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG) 
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-MNG::C_Control id false cu cco ccc casr ctncr cf cw cp)
                )
            )
        )
    )
    
    (defun DPNF|C_TogglePause (patron:string id:string toggle:bool)
        @doc "Pauses a DPNF Collection. Paused Collections can no longer be transfered"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG) 
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-MNG::C_TogglePause id false toggle)
                )
            )
        )
    )
    ;;
    ;;  [7] DPDC-T
    ;;
    ;;
    ;;  [8] DPDC-S
    ;;
    (defun DPNF|C_DefinePrimordialSet
        (
            patron:string id:string set-name:string 
            set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
        @doc "Defines a New Primordial NFT Set. Primordial Sets are composed of Class 0 Nonces"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-S::C_DefinePrimordialSet id true set-name set-definition ind)
                )
                (format "Primordial Set for NFT Collection {} defined succesfully" [id])
            )
        )
    )
    (defun DPNF|C_DefineCompositeSet
        (
            patron:string id:string set-name:string 
            set-definition:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
        @doc "Defines a New Composite NFT Set. Composite Sets are composed of Class (!=0) Nonces"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-S::C_DefineCompositeSet id false set-name set-definition ind)
                )
                (format "Composite Set <{}> for NFT Collection {} defined succesfully" [set-name id])
            )
        )
    )
    (defun DPNF|C_EnableSetClassFragmentation
        (
            patron:string id:string set-class:integer
            fragmentation-ind:object{DpdcUdc.DPDC|NonceData}
        )
        @doc "Enables Fragmentation for a given Set Class. This allows all NFTs of the given Set Class to be Fragmented"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-S::C_EnableSetClassFragmentation id false set-class fragmentation-ind)
                )
                (format "Set Class {} for NFT {} succesfully fragmented" [set-class id])
            )
        )
    )
    (defun DPNF|C_ToggleSet (patron:string id:string set-class:integer toggle:bool)
        @doc "Enables or Disables a Set. A disabled Set allows only for decomposition of Set Elements, but not for composition"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-S::C_ToggleSet id false set-class toggle)
                )
                (format "NFT {} Set Class {} succesfully turned {}" [id set-class (if toggle "ON" "OFF")])
            )
        )
    )
    (defun DPNF|C_RenameSet (patron:string id:string set-class:integer new-name:string)
        @doc "Renames an NFT Set"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-S::C_RenameSet id false set-class new-name)
                )
                (format "NFT {} Set Class {} succesfuly renamed from to <{}>" [id set-class new-name])
            )
        )
    )
    ;;
    (defun DPNF|C_UpdateSetNonce 
        (patron:string id:string account:string nonce:integer native-or-split:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData})
        @doc "[0] Updates Full Set Nonce Data, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonce id false account nonce native-or-split false new-nonce-data)
                )
            )
        )
    )
    (defun DPNF|C_UpdateSetNonceRoyalty
        (patron:string id:string account:string nonce:integer native-or-split:bool royalty-value:decimal)
        @doc "[1] Updates Set Nonce Native Royalty Value, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceRoyalty id false account nonce native-or-split false royalty-value)
                )
            )
        )
    )
    (defun DPNF|C_UpdateSetNonceIgnisRoyalty
        (patron:string id:string account:string nonce:integer native-or-split:bool royalty-value:decimal)
        @doc "[2] Updates Set Nonce IGNIS Royalty Value, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceIgnisRoyalty id false account nonce native-or-split false royalty-value)
                )
            )
        )
    )
    (defun DPNF|C_UpdateSetNonceName
        (patron:string id:string account:string nonce:integer native-or-split:bool name:string)
        @doc "[3] Updates Set Nonce Name, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceName id false account nonce native-or-split false name)
                )
            )
        )
    )
    (defun DPNF|C_UpdateSetNonceDescription
        (patron:string id:string account:string nonce:integer native-or-split:bool description:string)
        @doc "[4] Updates Set Nonce Description, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceDescription id false account nonce native-or-split false description)
                )
            )
        )
    )
    (defun DPNF|C_UpdateSetNonceScore
        (patron:string id:string account:string nonce:integer native-or-split:bool score:decimal)
        @doc "[5] Updates Set Nonce Score, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceScore id false account nonce native-or-split false score)
                )
            )
        )
    )
    (defun DPNF|C_RemoveSetNonceScore (patron:string id:string account:string nonce:integer native-or-split:bool)
        @doc "[5b] Removes Set Nonce Score, setting it to -1.0, either Native or Split, for an NFT"
        (DPNF|C_UpdateNonceScore patron id account nonce native-or-split -1.0)
    )
    (defun DPNF|C_UpdateSetNonceMetaData
        (patron:string id:string account:string nonce:integer native-or-split:bool meta-data:[object])
        @doc "[6] Updates Set Nonce Meta-Data, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceMetaData id false account nonce native-or-split false meta-data)
                )
            )
        )
    )
    (defun DPNF|C_UpdateSetNonceURI
        (
            patron:string id:string account:string nonce:integer native-or-split:bool
            ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}
        )
        @doc "[7] Updates Set Nonce URI, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceURI id false account nonce native-or-split false ay u1 u2 u3)
                )
            )
        )
    )
    ;;
    ;;  [9] DPDC-F
    ;;
    (defun DPNF|C_EnableNonceFragmentation (patron:string id:string nonce:integer fragmentation-ind:object{DpdcUdc.DPDC|NonceData})
        @doc "Enables Fragmentation for a given NFT Nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-F:module{DpdcFragments} DPDC-F)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-F::C_EnableNonceFragmentation id false nonce fragmentation-ind)
                )
                (format "Fragmentation for NFT {} Nonce {} enabled succesfully" [id nonce])
            )
        )
    )
    ;;
    ;;  [10] DPDC-N
    ;;
    (defun DPNF|C_UpdateNonce 
        (patron:string id:string account:string nonce:integer native-or-split:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData})
        @doc "[0] Updates Full Nonce Data, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonce id false account nonce native-or-split true new-nonce-data)
                )
            )
        )
    )
    (defun DPNF|C_UpdateNonceRoyalty
        (patron:string id:string account:string nonce:integer native-or-split:bool royalty-value:decimal)
        @doc "[1] Updates Nonce Native Royalty Value, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceRoyalty id false account nonce native-or-split true royalty-value)
                )
            )
        )
    )
    (defun DPNF|C_UpdateNonceIgnisRoyalty
        (patron:string id:string account:string nonce:integer native-or-split:bool royalty-value:decimal)
        @doc "[2] Updates Nonce IGNIS Royalty Value, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceIgnisRoyalty id false account nonce native-or-split true royalty-value)
                )
            )
        )
    )
    (defun DPNF|C_UpdateNonceName
        (patron:string id:string account:string nonce:integer native-or-split:bool name:string)
        @doc "[3] Updates Nonce Name, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceName id false account nonce native-or-split true name)
                )
            )
        )
    )
    (defun DPNF|C_UpdateNonceDescription
        (patron:string id:string account:string nonce:integer native-or-split:bool description:string)
        @doc "[4] Updates Nonce Description, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceDescription id false account nonce native-or-split true description)
                )
            )
        )
    )
    (defun DPNF|C_UpdateNonceScore
        (patron:string id:string account:string nonce:integer native-or-split:bool score:decimal)
        @doc "[5] Updates Nonce Score, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceScore id false account nonce native-or-split true score)
                )
            )
        )
    )
    (defun DPNF|C_RemoveNonceScore (patron:string id:string account:string nonce:integer native-or-split:bool)
        @doc "[5b] Removes Nonce Score, setting it to -1.0, either Native or Split, for an NFT"
        (DPNF|C_UpdateNonceScore patron id account nonce native-or-split -1.0)
    )
    (defun DPNF|C_UpdateNonceMetaData
        (patron:string id:string account:string nonce:integer native-or-split:bool meta-data:[object])
        @doc "[6] Updates Nonce Meta-Data, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceMetaData id false account nonce native-or-split true meta-data)
                )
            )
        )
    )
    (defun DPNF|C_UpdateNonceURI
        (
            patron:string id:string account:string nonce:integer native-or-split:bool
            ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}
        )
        @doc "[7] Updates Nonce URI, either Native or Split, for an NFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceURI id false account nonce native-or-split true ay u1 u2 u3)
                )
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)