(interface TalosStageTwo_ClientOne
    @doc "Exposes Client SFT Functions"
    ;;
    (defun DPSF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun DPSF|C_UpgradeBranding (patron:string entity-id:string months:integer))
    ;;
    (defun DPSF|C_Control (patron:string id:string cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)) ;x
    (defun DPSF|C_DeployAccount (patron:string id:string account:string))
    (defun DPSF|C_Issue:string 
        (
            patron:string 
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
    )
    ;;
    (defun DPSF|C_TogglePause (patron:string id:string toggle:bool))
    (defun DPSF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_ToggleExemptionRole (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_ToggleUpdateRole (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_ToggleModifyCreatorRole (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_ToggleModifyRoyaltiesRole (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool))
    (defun DPSF|C_MoveCreateRole (patron:string id:string new-account:string))
    (defun DPSF|C_MoveRecreateRole (patron:string id:string new-account:string))
    (defun DPSF|C_MoveSetUriRole (patron:string id:string new-account:string))
    ;;
    (defun DPSF|C_Create:string
        (
            patron:string id:string amount:[integer]
            input-nonce-data:[object{DpdcUdc.DPDC|NonceData}]
        )
    )
    (defun DPSF|C_EnableNonceFragmentation (patron:string id:string nonce:integer fragmentation-ind:object{DpdcUdc.DPDC|NonceData}))
    (defun DPSF|C_DefinePrimordialSet 
        (
            patron:string id:string set-name:string 
            set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    ;;
    (defun DPSF|C_SetNonceRoyalty (patron:string id:string account:string nonce:integer royalty:decimal))
    (defun DPSF|C_SetNonceIgnisRoyalty (patron:string id:string account:string nonce:integer ignis-royalty:decimal))
    (defun DPSF|C_SetNonceName (patron:string id:string account:string nonce:integer name:string))
    (defun DPSF|C_SetNonceDescription (patron:string id:string account:string nonce:integer description:string))
    (defun DPSF|C_SetNonceScore (patron:string id:string account:string nonce:integer score:decimal))
    (defun DPSF|C_RemoveNonceScore (patron:string id:string account:string nonce:integer))
    (defun DPSF|C_SetNonceMetaData (patron:string id:string account:string nonce:integer meta-data:[object]))
    (defun DPSF|C_SetNonceUri 
        (
            patron:string id:string account:string nonce:integer
            ay:object{DpdcUdc.URI|Type}
            u1:object{DpdcUdc.URI|Data}
            u2:object{DpdcUdc.URI|Data}
            u3:object{DpdcUdc.URI|Data}
        )
    )
)
(module TS02-C1 GOV
    @doc "TALOS Stage 2 Client Functiones Part 1 - SFT Functions"
    ;;
    (implements OuronetPolicy)
    (implements TalosStageTwo_ClientOne)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_TS02-C1        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TS02-C1_ADMIN)))
    (defcap GOV|TS02-C1_ADMIN ()    (enforce-guard GOV|MD_TS02-C1))
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
        (with-capability (GOV|TS02-C1_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|TS02-C1_ADMIN)
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
    ;;  [DPSF_Client]
    (defun DPSF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for DPSF Token <entity-id> costing 400 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC:module{Dpdc} DPDC)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC::C_UpdatePendingBranding patron entity-id true logo description website social)
                )
            )
        )
    )
    (defun DPSF|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Upgrades Branding for DPSF Token, making it a premium Branding. \
            \ Also sets pending-branding to live branding if its branding is not live yet"
        (with-capability (P|TS)
            (let
                (
                    (ref-DPDC:module{Dpdc} DPDC)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                )
                (ref-DPDC::C_UpgradeBranding patron entity-id true months)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    ;;
    (defun DPSF|C_Control (patron:string id:string cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        @doc "Controls DPSF Properties"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG) 
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-MNG::C_Control id true cu cco ccc casr ctncr cf cw cp)
                )
            )
        )
    )
    (defun DPSF|C_DeployAccount (patron:string id:string account:string)
        @doc "Deploys a DPSF Account. Stand Alone Deployment costs 2 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-I:module{DpdcIssue} DPDC-I)
                )
                (ref-DPDC-I::C_DeployAccountSFT id account)
                (ref-IGNIS::IC|C_Collect patron
                    (ref-IGNIS::IC|UDC_SmallCumulator account)
                )
            )
        )
    )
    (defun DPSF|C_Issue:string
        (
            patron:string 
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
        @doc "Issues a new DPSF (Demiourgos Pact Semi-Fungible) Digital Collection: <SFT> \
            \ Costs 5x<ignis|token-issue> = 2500 IGNIS and 400 KDA"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-I:module{DpdcIssue} DPDC-I)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-DPDC-I::C_IssueDigitalCollection
                            patron true 
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
    (defun DPSF|C_TogglePause (patron:string id:string toggle:bool)
        @doc "Pauses a DPSF Collection. Paused Collections can no longer be transfered"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG) 
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-MNG::C_TogglePause id true toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles the add quantity role for a DPTF Token on a given Ouronet Account"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_ToggleAddQuantityRole id account toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Freezes a given account for a given DPSF Token. Frozen Accounts can no longer send or receive that DPSF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_ToggleFreezeAccount id true account toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleExemptionRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles exemption Role for a given DPSF on a given Smart Ouronet Account (Only Smart Ouronet Accounts can accept this role) \
            \ When sending to or receiving from such Accounts, the flat IGNIS Royalty fee must not be paid."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_ToggleExemptionRole id true account toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles burn Role for a given DPSF on any Ouronet Account. \
            \ Such Accounts can then burn the DPSF"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_ToggleBurnRole id true account toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleUpdateRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles update Role for a given DPSF on any Ouronet Account. \
            \ Such Accounts can then update (modify) the Metadata on any DPSF nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_ToggleUpdateRole id true account toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleModifyCreatorRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles Modify Creator Role for a given DPSF on any Ouronet Account. \
            \ Such Accounts can proceed to modify the Creator of the DPSF Collection"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_ToggleModifyCreatorRole id true account toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleModifyRoyaltiesRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles Modify Royalties Role for a given DPSF on any Ouronet Account. \
            \ Such Accounts can proceed to modify the Permille Royalty of any nonce in the  DPSF Collection"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_ToggleModifyRoyaltiesRole id true account toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles Transfer Role for a given DPSF on any Ouronet Account. \
            \ Transfers for any Nonce in the DPSF Collection are then restricted only to and from these accounts"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_ToggleTransferRole id true account toggle)
                )
            )
        )
    )
    (defun DPSF|C_MoveCreateRole (patron:string id:string new-account:string)
        @doc "Moves the Create Role to another Ouronet Account. A single Account may have this Role \
            \ This is the only account that can issue new SFTs in the Collection"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_MoveCreateRole id true new-account)
                )
            )
        )
    )
    (defun DPSF|C_MoveRecreateRole (patron:string id:string new-account:string)
        @doc "Moves the Recreate Role to another Ouronet Account. A single Account may have this Role \
            \ This is the only account that can recreate any existing SFT in the Collection \
            \ Recreation reffers to a complete update (modification) of all SFT properties of a given nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_MoveRecreateRole id true new-account)
                )
            )
        )
    )
    (defun DPSF|C_MoveSetUriRole (patron:string id:string new-account:string)
        @doc "Moves the Set URI Role to another Ouronet Account. A single Account may have this Role \
            \ This is the only account that can modify the URIs of any nonce in the SFT Collection"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-R::C_MoveSetUriRole id true new-account)
                )
            )
        )
    )
    ;;
    (defun DPSF|C_Create:string
        (
            patron:string id:string amount:[integer]
            input-nonce-data:[object{DpdcUdc.DPDC|NonceData}]
        )
        @doc "Creates a new SFT Collection Element(s), having a new nonce, \
            \ of amount <amount>, on the <creator> account."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                    (l:integer (length input-nonce-data))
                    (ico:object{IgnisCollector.OutputCumulator}
                        (if (= l 1)
                            (ref-DPDC-C::C_CreateNewNonce
                                id true 0 (at 0 amount) (at 0 input-nonce-data) false
                            )
                            (ref-DPDC-C::C_CreateNewNonces
                                id true amount input-nonce-data
                            )
                        )
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (format "Created {} Clas 0 SemiFungible(s) within the {} DPSF Collection"
                    [(at "output" ico) id]
                )
            )
        )
    )
    (defun DPSF|C_EnableNonceFragmentation (patron:string id:string nonce:integer fragmentation-ind:object{DpdcUdc.DPDC|NonceData})
        @doc "Enables Fragmentation for a given SFT Nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-F:module{DpdcFragments} DPDC-F)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-F::C_EnableNonceFragmentation id true nonce fragmentation-ind)
                )
                (format "Fragmentation for SFT {} Nonce {} enabled succesfully" [id nonce])
            )
        )
    )
    (defun DPSF|C_DefinePrimordialSet
        (
            patron:string id:string set-name:string 
            set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
        @doc "Defines a New Primordial SFT Set. Primordial Sets are composed oc Class 0 Nonces"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-S::C_DefinePrimordialSet id true set-name set-definition ind)
                )
                (format "Primordial Set <{}> for SFT Collection {} defined succesfully" [set-name id])
            )
        )
    )

    ;;
    (defun DPSF|C_SetNonceRoyalty (patron:string id:string account:string nonce:integer royalty:decimal)
        @doc "Updates the Royalty of an SFT Nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceRoyalty id true account nonce royalty)
                )
            )
        )
    )
    (defun DPSF|C_SetNonceIgnisRoyalty (patron:string id:string account:string nonce:integer ignis-royalty:decimal)
        @doc "Updates the Ignis Royalty of an SFT Nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceIgnisRoyalty id true account nonce ignis-royalty)
                )
            )
        )
    )
    (defun DPSF|C_SetNonceName (patron:string id:string account:string nonce:integer name:string)
        @doc "Updates the Name of an SFT nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceNameOrDescription id true account nonce true name)
                )
            )
        )
    )
    (defun DPSF|C_SetNonceDescription (patron:string id:string account:string nonce:integer description:string)
        @doc "Updates the Description of an SFT nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceNameOrDescription id true account nonce false description)
                )
            )
        )
    )
    (defun DPSF|C_SetNonceScore (patron:string id:string account:string nonce:integer score:decimal)
        @doc "Updates the Score of an SFT nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-DPDC-N::C_UpdateNonceScore id true account nonce score)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (format "Update Nonce {} of SFT Collection {} with a score of {}"
                    [nonce id score]
                )
            )
        )
    )
    (defun DPSF|C_RemoveNonceScore (patron:string id:string account:string nonce:integer)
        @doc "Removes the Score of an SFT nonce, setting it to -1.0"
        (DPSF|C_SetNonceScore patron id account nonce -1.0)
    )
    (defun DPSF|C_SetNonceMetaData (patron:string id:string account:string nonce:integer meta-data:[object])
        @doc "Updates the Metadata of an SFT nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-DPDC-N::C_UpdateNonceMetadata id true account nonce meta-data)
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (format "Update Meta-Data of Nonce {} of SFT Collection {}"
                    [nonce id]
                )
            )
        )
    )
    (defun DPSF|C_SetNonceUri
        (
            patron:string id:string account:string nonce:integer
            ay:object{DpdcUdc.URI|Type}
            u1:object{DpdcUdc.URI|Data}
            u2:object{DpdcUdc.URI|Data}
            u3:object{DpdcUdc.URI|Data}
        )
        @doc "Updates the URI List for an SFT nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceUri id true account nonce ay u1 u2 u3)
                )
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)