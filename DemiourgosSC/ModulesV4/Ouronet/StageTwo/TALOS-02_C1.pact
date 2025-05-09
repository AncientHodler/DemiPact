
(module TS02-C1 GOV
    @doc "TALOS Stage 2 Client Functiones Part 1"
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
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
                (ref-DALOS:module{OuronetDalosV3} DALOS)
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
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::P|Info)))
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
                (ref-P|TS01-A:module{TalosStageOne_AdminV3} TS01-A)
                (ref-P|DPDC:module{OuronetPolicy} DPDC)
                (ref-P|DPDC-U1:module{OuronetPolicy} DPDC-U1)
                (ref-P|DPDC-U2:module{OuronetPolicy} DPDC-U2)
                (ref-P|DPDC-U3:module{OuronetPolicy} DPDC-U3)
                (mg:guard (create-capability-guard (P|TALOS-SUMMONER)))
            )
            (ref-P|TS01-A::P|A_AddIMP mg)
            (ref-P|DPDC::P|A_AddIMP mg)
            (ref-P|DPDC-U1::P|A_AddIMP mg)
            (ref-P|DPDC-U2::P|A_AddIMP mg)
            (ref-P|DPDC-U3::P|A_AddIMP mg)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                )
                (ref-DALOS::IGNIS|C_Collect patron
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
                    (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                    (ref-TS01-A:module{TalosStageOne_AdminV3} TS01-A)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_Control id true cu cco ccc casr ctncr cf cw cp)
                )
            )
        )
    )
    (defun DPSF|C_DeployAccount (patron:string id:string account:string)
        @doc "Deploys a DPSF Account. Stand Alone Deployment costs 2 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                )
                (ref-DPDC::C_DeployAccountSFT id account)
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DALOS::UDC_SmallCumulatorV2 account)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                    (ref-TS01-A:module{TalosStageOne_AdminV3} TS01-A)
                    (ico:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-DPDC-U1::C_IssueDigitalCollection
                            patron true 
                            owner-account creator-account collection-name collection-ticker
                            can-upgrade can-change-owner can-change-creator can-add-special-role
                            can-transfer-nft-create-role can-freeze can-wipe can-pause
                        )
                    )
                )
                (ref-DALOS::IGNIS|C_Collect patron ico)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_TogglePause id true toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles the add quantity role for a DPTF Token on a given Ouronet Account"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_ToggleAddQuantityRole id account toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Freezes a given account for a given DPSF Token. Frozen Accounts can no longer send or receive that DPSF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_ToggleFreezeAccount id true account toggle)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_ToggleExemptionRole id true account toggle)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_ToggleBurnRole id true account toggle)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_ToggleUpdateRole id true account toggle)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_ToggleModifyCreatorRole id true account toggle)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_ToggleModifyRoyaltiesRole id true account toggle)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_ToggleTransferRole id true account toggle)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_MoveCreateRole id true new-account)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_MoveRecreateRole id true new-account)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_MoveSetUriRole id true new-account)
                )
            )
        )
    )
    ;;
    (defun DPSF|C_Create:string
        (
            patron:string id:string amount:[integer]
            input-nonce-data:[object{DemiourgosPactDigitalCollectibles.DC|DataSchema}]
        )
        @doc "Creates a new SFT Collection Element(s), having a new nonce, \
            \ of amount <amount>, on the <creator> account."
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U2:module{DemiourgosPactDigitalCollectibles-UtilityTwo} DPDC-U2)
                    (l:integer (length input-nonce-data))
                    (ico:object{OuronetDalosV3.OutputCumulatorV2}
                        (if (= l 1)
                            (ref-DPDC-U2::C_CreateNewNonce
                                id true 0 (at 0 amount) (at 0 input-nonce-data)
                            )
                            (ref-DPDC-U2::C_CreateNewNonces
                                id true amount input-nonce-data
                            )
                        )
                    )
                )
                (ref-DALOS::IGNIS|C_Collect patron ico)
                (format "Created {} Clas 0 SemiFungible(s) within the {} DPSF Collection"
                    [(at "output" ico) id]
                )
            )
        )
    )
    ;;
    (defun DPSF|C_SetNonceRoyalty (patron:string id:string account:string nonce:integer royalty:decimal)
        @doc "Updates the Royalty of an SFT Nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U3:module{DemiourgosPactDigitalCollectibles-UtilityThree} DPDC-U3)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U3::C_UpdateNonceRoyalty id true account nonce royalty)
                )
            )
        )
    )
    (defun DPSF|C_SetNonceIgnisRoyalty (patron:string id:string account:string nonce:integer ignis-royalty:decimal)
        @doc "Updates the Royalty of an SFT Nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U3:module{DemiourgosPactDigitalCollectibles-UtilityThree} DPDC-U3)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U3::C_UpdateNonceIgnisRoyalty id true account nonce ignis-royalty)
                )
            )
        )
    )
    (defun DPSF|C_SetNonceName (patron:string id:string account:string nonce:integer name:string)
        @doc "Updates the Name of an SFT nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U3:module{DemiourgosPactDigitalCollectibles-UtilityThree} DPDC-U3)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U3::C_UpdateNonceNameOrDescription id true account nonce true name)
                )
            )
        )
    )
    (defun DPSF|C_SetNonceDescription (patron:string id:string account:string nonce:integer description:string)
        @doc "Updates the Description of an SFT nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U3:module{DemiourgosPactDigitalCollectibles-UtilityThree} DPDC-U3)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U3::C_UpdateNonceNameOrDescription id true account nonce false description)
                )
            )
        )
    )
    (defun DPSF|C_SetNonceScore (patron:string id:string account:string nonce:integer score:decimal)
        @doc "Updates the Score of an SFT nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U3:module{DemiourgosPactDigitalCollectibles-UtilityThree} DPDC-U3)
                    (ico:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-DPDC-U3::C_UpdateNonceScore id true account nonce score)
                    )
                )
                (ref-DALOS::IGNIS|C_Collect patron ico)
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
        @doc "Updates the MEtadata of an SFT nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U3:module{DemiourgosPactDigitalCollectibles-UtilityThree} DPDC-U3)
                    (ico:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-DPDC-U3::C_UpdateNonceMetadata id true account nonce meta-data)
                    )
                )
                (ref-DALOS::IGNIS|C_Collect patron ico)
                (format "Update Meta-Data of Nonce {} of SFT Collection {}"
                    [nonce id]
                )
            )
        )
    )
    (defun DPSF|C_SetNonceUri
        (
            patron:string id:string account:string nonce:integer
            ay:object{DemiourgosPactDigitalCollectibles.DC|URI|Type}
            u1:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
            u2:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
            u3:object{DemiourgosPactDigitalCollectibles.DC|URI|Schema}
        )
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U3:module{DemiourgosPactDigitalCollectibles-UtilityThree} DPDC-U3)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U3::C_UpdateNonceUri id true account nonce ay u1 u2 u3)
                )
            )
        )
    )
    ;;  [DPNF_Client]
    (defun DPNF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for DPNF Token <entity-id> costing 500 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                )
                (ref-DALOS::IGNIS|C_Collect patron
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
                    (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                    (ref-TS01-A:module{TalosStageOne_AdminV3} TS01-A)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_Control id false cu cco ccc casr ctncr cf cw cp)
                )
            )
        )
    )
    (defun DPNF|C_DeployAccount (patron:string id:string account:string)
        @doc "Deploys a DPNF Account. Stand Alone Deployment costs 3 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                )
                (ref-DPDC::C_DeployAccountNFT id account)
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DALOS::UDC_MediumCumulatorV2 account)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                    (ref-TS01-A:module{TalosStageOne_AdminV3} TS01-A)
                    (ico:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-DPDC-U1::C_IssueDigitalCollection
                            patron false 
                            owner-account creator-account collection-name collection-ticker
                            can-upgrade can-change-owner can-change-creator can-add-special-role
                            can-transfer-nft-create-role can-freeze can-wipe can-pause
                        )
                    )
                )
                (ref-DALOS::IGNIS|C_Collect patron ico)
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
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_TogglePause id false toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_ToggleFreezeAccount id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleExemptionRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_ToggleExemptionRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_ToggleBurnRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleUpdateRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_ToggleUpdateRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleModifyCreatorRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_ToggleModifyCreatorRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleModifyRoyaltiesRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_ToggleModifyRoyaltiesRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_ToggleTransferRole id false account toggle)
                )
            )
        )
    )
    (defun DPNF|C_MoveCreateRole (patron:string id:string new-account:string)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_MoveCreateRole id false new-account)
                )
            )
        )
    )
    (defun DPNF|C_MoveRecreateRole (patron:string id:string new-account:string)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_MoveRecreateRole id false new-account)
                )
            )
        )
    )
    (defun DPNF|C_MoveSetUriRole (patron:string id:string new-account:string)
        @doc "Similar to its DPSF counterpart"
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U1:module{DemiourgosPactDigitalCollectibles-UtilityOne} DPDC-U1)
                )
                (ref-DALOS::IGNIS|C_Collect patron
                    (ref-DPDC-U1::C_MoveSetUriRole id false new-account)
                )
            )
        )
    )
    ;;
    (defun DPNF|C_Create:string
        (
            patron:string id:string
            input-nonce-data:[object{DemiourgosPactDigitalCollectibles.DC|DataSchema}]
        )
        @doc "Creates a new NFT Collection Element(s), having a new nonce, \
            \ of amount 1, on the <creator> account."
        (with-capability (P|TS)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPDC-U2:module{DemiourgosPactDigitalCollectibles-UtilityTwo} DPDC-U2)
                    (l:integer (length input-nonce-data))
                    (ico:object{OuronetDalosV3.OutputCumulatorV2}
                        (if (= l 1)
                            (ref-DPDC-U2::C_CreateNewNonce
                                id false 0 1 (at 0 input-nonce-data)
                            )
                            (ref-DPDC-U2::C_CreateNewNonces
                                id false (make-list l 1) input-nonce-data
                            )
                        )
                    )
                )
                (ref-DALOS::IGNIS|C_Collect patron ico)
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