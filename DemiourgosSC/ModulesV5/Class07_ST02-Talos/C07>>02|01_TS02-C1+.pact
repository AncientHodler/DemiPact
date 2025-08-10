(interface TalosStageTwo_ClientOne
    @doc "Exposes Client SFT Functions"
    ;;
    ;;  [2] DPDC
    ;;
    (defun DPSF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun DPSF|C_UpgradeBranding (patron:string entity-id:string months:integer))
    ;;
    ;;  [3] DPDC-C
    ;;
    (defun DPSF|C_Create:string
        (
            patron:string id:string amount:[integer]
            input-nonce-data:[object{DpdcUdc.DPDC|NonceData}]
        )
    )
    ;;
    ;;  [4] DPDC-I
    ;;
    (defun DPSF|C_DeployAccount (patron:string account:string id:string))
    (defun DPSF|C_Issue:string 
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
    ;;  [6] DPDC-MNG
    ;;
    (defun DPSF|C_Control (patron:string id:string cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool))
    (defun DPSF|C_TogglePause (patron:string id:string toggle:bool))
    (defun DPSF|C_AddQuantity (patron:string id:string account:string nonce:integer amount:integer))
    (defun DPSF|C_Burn (patron:string id:string account:string nonce:integer amount:integer))
    (defun DPSF|C_WipeNoncePartialy (patron:string id:string account:string nonce:integer amount:integer))
    (defun DPSF|C_WipeNonce (patron:string id:string account:string nonce:integer))
    ;;
    ;;  [7] DPDC-T
    ;;
    (defun DPSF|C_TransferNonce (patron:string id:string sender:string receiver:string nonce:integer amount:integer method:bool))
    (defun DPSF|C_TransferNonces (patron:string id:string sender:string receiver:string nonces:[integer] amounts:[integer] method:bool))
    ;;
    ;;  [8] DPDC-S
    ;;
    (defun DPSF|C_Make (patron:string account:string id:string nonces:[integer] set-class:integer))
    (defun DPSF|C_Break (patron:string account:string id:string nonce:integer))
    (defun DPSF|C_DefinePrimordialSet 
        (
            patron:string id:string set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun DPSF|C_DefineCompositeSet
        (
            patron:string id:string set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun DPSF|C_DefineHybridSet
        (
            patron:string id:string set-name:string score-multiplier:decimal
            primordial-sd:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            composite-sd:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun DPSF|C_EnableSetClassFragmentation
        (
            patron:string id:string set-class:integer
            fragmentation-ind:object{DpdcUdc.DPDC|NonceData}
        )
    )
    (defun DPSF|C_ToggleSet (patron:string id:string set-class:integer toggle:bool))
    (defun DPSF|C_RenameSet (patron:string id:string set-class:integer new-name:string))
    (defun DPSF|C_UpdateSetMultiplier (patron:string id:string set-class:integer new-multiplier:decimal))
    ;;
    (defun DPSF|C_UpdateSetNonce                (patron:string id:string account:string set-class:integer nos:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData}))
    (defun DPSF|C_UpdateSetNonceRoyalty         (patron:string id:string account:string set-class:integer nos:bool royalty-value:decimal))
    (defun DPSF|C_UpdateSetNonceIgnisRoyalty    (patron:string id:string account:string set-class:integer nos:bool royalty-value:decimal))
    (defun DPSF|C_UpdateSetNonceName            (patron:string id:string account:string set-class:integer nos:bool name:string))
    (defun DPSF|C_UpdateSetNonceDescription     (patron:string id:string account:string set-class:integer nos:bool description:string))
    (defun DPSF|C_UpdateSetNonceScore           (patron:string id:string account:string set-class:integer nos:bool score:decimal))
    (defun DPSF|C_RemoveSetNonceScore           (patron:string id:string account:string set-class:integer nos:bool))
    (defun DPSF|C_UpdateSetNonceMetaData        (patron:string id:string account:string set-class:integer nos:bool meta-data:object))
    (defun DPSF|C_UpdateSetNonceURI             (patron:string id:string account:string set-class:integer nos:bool ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}))
    ;;
    ;;  [9] DPDC-F
    ;;
    (defun DPSF|C_MakeFragments (patron:string account:string id:string nonce:integer amount:integer))
    (defun DPSF|C_MergeFragments (patron:string account:string id:string nonce:integer amount:integer))
    (defun DPSF|C_EnableNonceFragmentation (patron:string id:string nonce:integer fragmentation-ind:object{DpdcUdc.DPDC|NonceData}))
    ;;
    ;;  [10] DPDC-N
    ;;
    (defun DPSF|C_UpdateNonce               (patron:string id:string account:string nonce:integer nos:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData}))
    (defun DPSF|C_UpdateNonceRoyalty        (patron:string id:string account:string nonce:integer nos:bool royalty-value:decimal))
    (defun DPSF|C_UpdateNonceIgnisRoyalty   (patron:string id:string account:string nonce:integer nos:bool royalty-value:decimal))
    (defun DPSF|C_UpdateNonceName           (patron:string id:string account:string nonce:integer nos:bool name:string))
    (defun DPSF|C_UpdateNonceDescription    (patron:string id:string account:string nonce:integer nos:bool description:string))
    (defun DPSF|C_UpdateNonceScore          (patron:string id:string account:string nonce:integer nos:bool score:decimal))
    (defun DPSF|C_RemoveNonceScore          (patron:string id:string account:string nonce:integer nos:bool))
    (defun DPSF|C_UpdateNonceMetaData       (patron:string id:string account:string nonce:integer nos:bool meta-data:object))
    (defun DPSF|C_UpdateNonceURI            (patron:string id:string account:string nonce:integer nos:bool ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}))
    ;;
    ;;
    ;;  [10] EQUITY
    ;;
    (defun DPSF|C_IssueCompany:string
        (
            patron:string creator-account:string collection-name:string collection-ticker:string
            royalty:decimal ignis-royalty:decimal ipfs-links:[string]
        )
    )
    (defun DPSF|C_MorphEquity (patron:string account:string id:string input-nonce:integer input-amount:integer output-nonce:integer))
    ;;
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
                (ref-P|DPDC-T:module{OuronetPolicy} DPDC-T)
                (ref-P|DPDC-F:module{OuronetPolicy} DPDC-F)
                (ref-P|DPDC-S:module{OuronetPolicy} DPDC-S)
                (ref-P|DPDC-N:module{OuronetPolicy} DPDC-N)
                (ref-P|EQUITY:module{OuronetPolicy} EQUITY)
                (mg:guard (create-capability-guard (P|TALOS-SUMMONER)))
            )
            (ref-P|TS01-A::P|A_AddIMP mg)
            (ref-P|DPDC::P|A_AddIMP mg)
            (ref-P|DPDC-C::P|A_AddIMP mg)
            (ref-P|DPDC-I::P|A_AddIMP mg)
            (ref-P|DPDC-R::P|A_AddIMP mg)
            (ref-P|DPDC-MNG::P|A_AddIMP mg)
            (ref-P|DPDC-T::P|A_AddIMP mg)
            (ref-P|DPDC-F::P|A_AddIMP mg)
            (ref-P|DPDC-S::P|A_AddIMP mg)
            (ref-P|DPDC-N::P|A_AddIMP mg)
            (ref-P|EQUITY::P|A_AddIMP mg)
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
    (defun UC_ShortAccount:string (account:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
            )
            (ref-I|OURONET::OI|UC_ShortAccount account)
        )
    )
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
    ;;  [3] DPDC-C
    ;;
    (defun DPSF|C_Create:string
        (
            patron:string id:string amount:[integer]
            input-nonce-data:[object{DpdcUdc.DPDC|NonceData}]
        )
        @doc "Creates a new SFT Collection Element(s), having a new nonce, \
            \ of amount <amount>, on the Account that has <r-nft-create> \
            \ As this account is the only Account that is allowed to create new SFTs in the Collection"
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
    ;;
    ;;  [4] DPDC-I
    ;;
    (defun DPSF|C_DeployAccount (patron:string account:string id:string)
        @doc "Deploys a DPSF Account. Stand Alone Deployment costs 2 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-I:module{DpdcIssue} DPDC-I)
                )
                (ref-DPDC-I::C_DeployAccountSFT account id)
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
                            false
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
    ;;  [6] DPDC-MNG
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
    (defun DPSF|C_AddQuantity (patron:string id:string account:string nonce:integer amount:integer)
        @doc "Increases the Quantity for SFT <id> <nonce> by <amount> on <account> \
        \ Account is created if it doesnt exist for SFT <id>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG) 
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-MNG::C_AddQuantity account id nonce amount)
                )
                (format "Succesfuly added {} Units for SFT {} Nonce {} on Account {}" [amount id nonce (UC_ShortAccount account)])
            )
        )
    )
    (defun DPSF|C_Burn (patron:string id:string account:string nonce:integer amount:integer)
        @doc "Decreases the Quantity for SFT <id> <nonce> by <amount> on <account> \
        \ Account is created if it doesnt exist for SFT <id>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG) 
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-MNG::C_BurnSFT account id nonce amount)
                )
                (format "Succesfuly removed {} Units for SFT {} Nonce {} on Account {}" [amount id nonce (UC_ShortAccount account)])
            )
        )
    )
    (defun DPSF|C_WipeNoncePartialy (patron:string id:string account:string nonce:integer amount:integer)
        @doc "Wipes a partial <amount> of SFT <id> <nonce> from <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG) 
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-MNG::C_WipeSftNoncePartialy account id nonce amount)
                )
                (format "Succesfuly wiped {} Units for SFT {} Nonce {} from Account {}" [amount id nonce (UC_ShortAccount account)])
            )
        )
    )
    (defun DPSF|C_WipeNonce (patron:string id:string account:string nonce:integer)
        @doc "Wipes the SFT <id> <nonce> from <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG) 
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-MNG::C_WipeSftNonce account id nonce)
                )
                (format "Succesfuly wiped SFT {} Nonce {} from Account {}" [id nonce (UC_ShortAccount account)])
            )
        )
    )
    (defun DPSF|C_WipeNonces (patron:string id:string account:string)
        @doc "Wipes all of SFT <id> from <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-MNG::C_WipeSftNonces account id)
                )
                (format "Succesfuly wiped SFT {} from Account {}" [id (UC_ShortAccount account)])
            )
        )
    )
    ;;
    ;;  [7] DPDC-T
    ;;
    (defun DPSF|C_TransferNonce (patron:string id:string sender:string receiver:string nonce:integer amount:integer method:bool)
        @doc "Transfer an SFT <nonce> of <amount> from <sender> to <receiver> using <method>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPDC-T:module{DpdcTransfer} DPDC-T)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount sender))
                    (ra:string (ref-I|OURONET::OI|UC_ShortAccount receiver))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-T::C_Transfer id true sender receiver [nonce] [amount] method)
                )
                (ref-DPDC-T::C_IgnisRoyaltyCollector patron id true [nonce] [amount])
                (format "Succesfuly transfered {} SFT {} Nonce {} from {} to {}" [amount id nonce sa ra])
            )
        )
    )
    (defun DPSF|C_TransferNonces (patron:string id:string sender:string receiver:string nonces:[integer] amounts:[integer] method:bool)
        @doc "Transfer an SFT <nonce> of <amount> from <sender> to <receiver> using <method>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPDC-T:module{DpdcTransfer} DPDC-T)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount sender))
                    (ra:string (ref-I|OURONET::OI|UC_ShortAccount receiver))
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-T::C_Transfer id true sender receiver nonces amounts method)
                )
                (ref-DPDC-T::C_IgnisRoyaltyCollector patron id true nonces amounts)
                (format "Succesfully transfered {} Amounts SFT {} Nonces {} from {} to {}" [amounts id nonces sa ra])
            )
        )
    )
    ;;
    ;;  [8] DPDC-S
    ;;
    (defun DPSF|C_Make
        (patron:string account:string id:string nonces:[integer] set-class:integer)
        @doc "Makes a Set SFT of Class <set-class>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-S::C_Make account id true nonces set-class)
                )
                (format "Set Class {} SFT generated succesfully on Account {}" [set-class (ref-I|OURONET::OI|UC_ShortAccount account)])
            )
        )
    )
    (defun DPSF|C_Break
        (patron:string account:string id:string nonce:integer)
        @doc "Brakes an SFT Nonce representing an SFT Set"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-S::C_Break account id true nonce)
                )
                (format "SFT {} Nonce {} succesfully broken down into its constituents to Account {}" [id nonce (ref-I|OURONET::OI|UC_ShortAccount account)])
            )
        )
    )
    (defun DPSF|C_DefinePrimordialSet
        (
            patron:string id:string set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
        @doc "Defines a New Primordial SFT Set. Primordial Sets are composed of Class 0 Nonces"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-S::C_DefinePrimordialSet id true set-name score-multiplier set-definition ind)
                )
                (format "Primordial Set <{}> for SFT Collection {} defined succesfully" [set-name id])
            )
        )
    )
    (defun DPSF|C_DefineCompositeSet
        (
            patron:string id:string set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
        @doc "Defines a New Composite SFT Set. Composite Sets are composed of Class (!=0) Nonces"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-S::C_DefineCompositeSet id true set-name score-multiplier set-definition ind)
                )
                (format "Composite Set <{}> for SFT Collection {} defined succesfully" [set-name id])
            )
        )
    )
    (defun DPSF|C_DefineHybridSet
        (
            patron:string id:string set-name:string score-multiplier:decimal
            primordial-sd:[object{DpdcUdc.DPDC|AllowedNonceForSetPosition}]
            composite-sd:[object{DpdcUdc.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdc.DPDC|NonceData}
        )
        @doc "Defines a New Hybrid SFT Set. Hybrid Sets are composed of both Class 0 and Non-0 Nonces"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-S::C_DefineHybridSet id true set-name score-multiplier primordial-sd composite-sd ind)
                )
                (format "Hybrid Set <{}> for SFT Collection {} defined succesfully" [set-name id])
            )
        )
    )
    (defun DPSF|C_EnableSetClassFragmentation
        (
            patron:string id:string set-class:integer
            fragmentation-ind:object{DpdcUdc.DPDC|NonceData}
        )
        @doc "Enables Fragmentation for a given Set Class. This allows all SFTs of the given Set Class to be Fragmented"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-S::C_EnableSetClassFragmentation id true set-class fragmentation-ind)
                )
                (format "Set Class {} for SFT {} succesfully fragmented" [set-class id])
            )
        )
    )
    (defun DPSF|C_ToggleSet (patron:string id:string set-class:integer toggle:bool)
        @doc "Enables or Disables a Set. A disabled Set allows only for decomposition of Set Elements, but not for composition"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-S::C_ToggleSet id true set-class toggle)
                )
                (format "SFT {} Set Class {} succesfully turned {}" [id set-class (if toggle "ON" "OFF")])
            )
        )
    )
    (defun DPSF|C_RenameSet (patron:string id:string set-class:integer new-name:string)
        @doc "Renames an SFT Set"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-S::C_RenameSet id true set-class new-name)
                )
                (format "SFT {} Set Class {} succesfuly renamed to <{}>" [id set-class new-name])
            )
        )
    )
    (defun DPSF|C_UpdateSetMultiplier (patron:string id:string set-class:integer new-multiplier:decimal)
        @doc "Updates an SFT Set Multiplier"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-S::C_UpdateSetMultiplier id true set-class new-multiplier)
                )
                (format "SFT {} Set Score Multiplier {} succesfuly updated to <{}>" [id set-class new-multiplier])
            )
        )
    )
    ;;
    (defun DPSF|C_UpdateSetNonce 
        (patron:string id:string account:string set-class:integer nos:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData})
        @doc "[0] Updates Full Set Nonce Data, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonce id true account set-class nos false new-nonce-data)
                )
            )
        )
    )
    (defun DPSF|C_UpdateSetNonceRoyalty
        (patron:string id:string account:string set-class:integer nos:bool royalty-value:decimal)
        @doc "[1] Updates Set Nonce Native Royalty Value, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceRoyalty id true account set-class nos false royalty-value)
                )
            )
        )
    )
    (defun DPSF|C_UpdateSetNonceIgnisRoyalty
        (patron:string id:string account:string set-class:integer nos:bool royalty-value:decimal)
        @doc "[2] Updates Set Nonce IGNIS Royalty Value, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceIgnisRoyalty id true account set-class nos false royalty-value)
                )
            )
        )
    )
    (defun DPSF|C_UpdateSetNonceName
        (patron:string id:string account:string set-class:integer nos:bool name:string)
        @doc "[3] Updates Set Nonce Name, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceName id true account set-class nos false name)
                )
            )
        )
    )
    (defun DPSF|C_UpdateSetNonceDescription
        (patron:string id:string account:string set-class:integer nos:bool description:string)
        @doc "[4] Updates Set Nonce Description, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceDescription id true account set-class nos false description)
                )
            )
        )
    )
    (defun DPSF|C_UpdateSetNonceScore
        (patron:string id:string account:string set-class:integer nos:bool score:decimal)
        @doc "[5] Updates Set Nonce Score, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceScore id true account set-class nos false score)
                )
            )
        )
    )
    (defun DPSF|C_RemoveSetNonceScore (patron:string id:string account:string set-class:integer nos:bool)
        @doc "[5b] Removes Set Nonce Score, setting it to -1.0, either Native or Split, for an SFT"
        (DPSF|C_UpdateNonceScore patron id account set-class nos -1.0)
    )
    (defun DPSF|C_UpdateSetNonceMetaData
        (patron:string id:string account:string set-class:integer nos:bool meta-data:object)
        @doc "[6] Updates Set Nonce Meta-Data, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceMetaData id true account set-class nos false meta-data)
                )
            )
        )
    )
    (defun DPSF|C_UpdateSetNonceURI
        (
            patron:string id:string account:string set-class:integer nos:bool
            ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}
        )
        @doc "[7] Updates Set Nonce URI, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceURI id true account set-class nos false ay u1 u2 u3)
                )
            )
        )
    )
    ;;
    ;;  [9] DPDC-F
    ;;
    (defun DPSF|C_MakeFragments (patron:string account:string id:string nonce:integer amount:integer)
        @doc "Fragments SFT nonce of the given amount into its respective Fragments."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-F:module{DpdcFragments} DPDC-F)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-F::C_MakeFragments account id true nonce amount)
                )
                (format "Succesfuly Fragmented {} SFT(s) {} of Nonce {}" [amount id nonce])
            )
        )
    )
    (defun DPSF|C_MergeFragments (patron:string account:string id:string nonce:integer amount:integer)
        @doc "MErges SFT Fragments nonces of the given amount into the original SFT nonce."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-F:module{DpdcFragments} DPDC-F)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-F::C_MergeFragments account id true nonce amount)
                )
                (format "Succesfuly merged {} {} SFT(s) Fragments of Nonce {}" [amount id nonce])
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
    ;;
    ;;  [10] DPDC-N
    ;;
    (defun DPSF|C_UpdateNonce 
        (patron:string id:string account:string nonce:integer nos:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData})
        @doc "[0] Updates Full Nonce Data, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonce id true account nonce nos true new-nonce-data)
                )
            )
        )
    )
    (defun DPSF|C_UpdateNonceRoyalty
        (patron:string id:string account:string nonce:integer nos:bool royalty-value:decimal)
        @doc "[1] Updates Nonce Native Royalty Value, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceRoyalty id true account nonce nos true royalty-value)
                )
            )
        )
    )
    (defun DPSF|C_UpdateNonceIgnisRoyalty
        (patron:string id:string account:string nonce:integer nos:bool royalty-value:decimal)
        @doc "[2] Updates Nonce IGNIS Royalty Value, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceIgnisRoyalty id true account nonce nos true royalty-value)
                )
            )
        )
    )
    (defun DPSF|C_UpdateNonceName
        (patron:string id:string account:string nonce:integer nos:bool name:string)
        @doc "[3] Updates Nonce Name, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceName id true account nonce nos true name)
                )
            )
        )
    )
    (defun DPSF|C_UpdateNonceDescription
        (patron:string id:string account:string nonce:integer nos:bool description:string)
        @doc "[4] Updates Nonce Description, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceDescription id true account nonce nos true description)
                )
            )
        )
    )
    (defun DPSF|C_UpdateNonceScore
        (patron:string id:string account:string nonce:integer nos:bool score:decimal)
        @doc "[5] Updates Nonce Score, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceScore id true account nonce nos true score)
                )
            )
        )
    )
    (defun DPSF|C_RemoveNonceScore (patron:string id:string account:string nonce:integer nos:bool)
        @doc "[5b] Removes Nonce Score, setting it to -1.0, either Native or Split, for an SFT"
        (DPSF|C_UpdateNonceScore patron id account nonce nos -1.0)
    )
    (defun DPSF|C_UpdateNonceMetaData
        (patron:string id:string account:string nonce:integer nos:bool meta-data:object)
        @doc "[6] Updates Nonce Meta-Data, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceMetaData id true account nonce nos true meta-data)
                )
            )
        )
    )
    (defun DPSF|C_UpdateNonceURI
        (
            patron:string id:string account:string nonce:integer nos:bool
            ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}
        )
        @doc "[7] Updates Nonce URI, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-N:module{DpdcNonce} DPDC-N)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceURI id true account nonce nos true ay u1 u2 u3)
                )
            )
        )
    )
    ;;
    ;;  [11] EQUITY
    ;;
    (defun DPSF|C_IssueCompany:string
        (
            patron:string creator-account:string collection-name:string collection-ticker:string
            royalty:decimal ignis-royalty:decimal ipfs-links:[string]
        )
        @doc "Issues an SFT Equity Collection to tokenize Company Shares on Ouronet. \
            \ Royalty is the standard Royalty for the Whole Collection \
            \ While <ignis-royalty> is the ignis Royalty for 1% of Company Shares \
            \ This makes the value of <ignis-royalty> in $ the Price to transfer All Existing Shares as Package Shares \
            \ \
            \ <ipfs-links> must be 8 elements long.\
            \ The Collection is an Image SFT Collection, automanaged by the <dpdc> Smart Ouronet Account as Collection Owner \
            \ Only 8 Elements can exist in this Collection, and no more can be added. \
            \ \
            \ Equity Collections Costs 0.001 IGNIS per Share for Pure Share Transfers as GAS Fees. \
            \ Package Share cost the normal <ignis|small> price per unit as GAS Fees, as for all SFTs."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ref-EQUITY:module{Equity} EQUITY)
                    ;;
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-EQUITY::C_IssueShareholderCollection 
                            patron creator-account collection-name collection-ticker
                            royalty ignis-royalty ipfs-links
                        )
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun DPSF|C_MorphEquity
        (patron:string account:string id:string input-nonce:integer input-amount:integer output-nonce:integer)
        @doc "Converts any Nonce to [1 2 3 4 5 6 7 8] to any Nonce [1 2 3 4 5 6 7 8] \
            \ Input-Nonce must be different from Output-Nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                    (ref-DPDC-T:module{DpdcTransfer} DPDC-T)
                    (ref-EQUITY:module{Equity} EQUITY)
                    ;;
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-EQUITY::C_MorphPackageShares
                            account id input-nonce input-amount output-nonce
                        )
                    )
                    (output:list (at "output" ico))
                    (ir-nonces:[integer] (at 0 output))
                    (ir-amounts:[integer] (at 1 output))
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
                )
                (ref-IGNIS::IC|C_Collect patron ico)
                (ref-DPDC-T::C_IgnisRoyaltyCollector patron id true ir-nonces ir-amounts)
                (if (= input-nonce 1)
                    ;;Make Package Shares
                    (format "Succesfuly combined {} Shares to Tier {} Package Share on Account {}" [input-amount (- output-nonce 1) sa])
                    (if (= output-nonce 1)
                        ;;Brake Package Shares
                        (format "Succesfuly broke {} Tier {} Package Share to {} Shares on Account {}" [input-amount (- input-nonce 1) (at 1 ir-amounts) sa])
                        ;;Convert Package Shares
                        (format "Succesfuly Converter Tier {} to Tier {} Package Shares on Account {}" [(- input-nonce 1) (- output-nonce 1) sa])
                        
                    )
                )
            )
        )
    )
    ;;
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)