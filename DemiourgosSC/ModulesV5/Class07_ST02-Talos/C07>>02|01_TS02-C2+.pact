(interface TalosStageTwo_ClientTwo
    @doc "Exposes Client NFT Functions"
    ;;
    (defun DPNF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun DPNF|C_UpgradeBranding (patron:string entity-id:string months:integer))
    ;;
    (defun DPNF|C_Control (patron:string id:string cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool))
    (defun DPNF|C_DeployAccount (patron:string id:string account:string))
    (defun DPNF|C_Issue:string
        (
            patron:string 
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
    )
    (defun DPNF|C_TogglePause (patron:string id:string toggle:bool))
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
    (defun DPNF|C_Create:string
        (
            patron:string id:string
            input-nonce-data:[object{Dpdc.DC|DataSchema}]
        )
    )
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
                (ref-P|DPDC-M:module{OuronetPolicy} DPDC-M)
                (ref-P|DPDC-NM:module{OuronetPolicy} DPDC-NM)
                (ref-P|DPDC-NP:module{OuronetPolicy} DPDC-NP)
                (mg:guard (create-capability-guard (P|TALOS-SUMMONER)))
            )
            (ref-P|TS01-A::P|A_AddIMP mg)
            (ref-P|DPDC::P|A_AddIMP mg)
            (ref-P|DPDC-M::P|A_AddIMP mg)
            (ref-P|DPDC-NM::P|A_AddIMP mg)
            (ref-P|DPDC-NP::P|A_AddIMP mg)
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
    ;;  [DPNF_Client]
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
        @doc "Similar to its DPSF counterpart"
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
    (defun DPNF|C_Control (patron:string id:string cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        @doc "Controls DPNF Properties"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-M:module{DpdcManagement} DPDC-M)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-M::C_Control id false cu cco ccc casr ctncr cf cw cp)
                )
            )
        )
    )
    (defun DPNF|C_DeployAccount (patron:string id:string account:string)
        @doc "Deploys a DPNF Account. Stand Alone Deployment costs 3 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC:module{Dpdc} DPDC)
                )
                (ref-DPDC::C_DeployAccountNFT id account)
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
                    (ref-DPDC-M:module{DpdcManagement} DPDC-M)
                    (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-DPDC-M::C_IssueDigitalCollection
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
    (defun DPNF|C_TogglePause (patron:string id:string toggle:bool)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-M:module{DpdcManagement} DPDC-M)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-M::C_TogglePause id false toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-M:module{DpdcManagement} DPDC-M)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-M::C_ToggleFreezeAccount id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleExemptionRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-M:module{DpdcManagement} DPDC-M)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-M::C_ToggleExemptionRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-M:module{DpdcManagement} DPDC-M)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-M::C_ToggleBurnRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleUpdateRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-M:module{DpdcManagement} DPDC-M)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-M::C_ToggleUpdateRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleModifyCreatorRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-M:module{DpdcManagement} DPDC-M)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-M::C_ToggleModifyCreatorRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleModifyRoyaltiesRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-M:module{DpdcManagement} DPDC-M)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-M::C_ToggleModifyRoyaltiesRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-M:module{DpdcManagement} DPDC-M)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-M::C_ToggleTransferRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_MoveCreateRole (patron:string id:string new-account:string)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-M:module{DpdcManagement} DPDC-M)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-M::C_MoveCreateRole id false new-account)
                )
            )
        )
    )
    (defun DPNF|C_MoveRecreateRole (patron:string id:string new-account:string)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-M:module{DpdcManagement} DPDC-M)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-M::C_MoveRecreateRole id false new-account)
                )
            )
        )
    )
    (defun DPNF|C_MoveSetUriRole (patron:string id:string new-account:string)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-M:module{DpdcManagement} DPDC-M)
                )
                (ref-IGNIS::IC|C_Collect patron
                    (ref-DPDC-M::C_MoveSetUriRole id false new-account)
                )
            )
        )
    )
    ;;
    (defun DPNF|C_Create:string
        (
            patron:string id:string
            input-nonce-data:[object{Dpdc.DC|DataSchema}]
        )
        @doc "Creates a new NFT Collection Element(s), having a new nonce, \
            \ of amount 1, on the <creator> account."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC-NM:module{DpdcNonceManagement} DPDC-NM)
                    (l:integer (length input-nonce-data))
                    (ico:object{IgnisCollector.OutputCumulator}
                        (if (= l 1)
                            (ref-DPDC-NM::C_CreateNewNonce
                                id false 0 1 (at 0 input-nonce-data)
                            )
                            (ref-DPDC-NM::C_CreateNewNonces
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
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)