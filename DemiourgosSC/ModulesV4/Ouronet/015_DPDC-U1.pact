(module DPDC-U1 GOV
    ;;
    (implements OuronetPolicy)
    (implements DemiourgosPactDigitalCollectibles-UtilityOne)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-U1        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|DPDC-U1_ADMIN)))
    (defcap GOV|DPDC-U1_ADMIN ()    (enforce-guard GOV|MD_DPDC-U1))
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
    (defcap P|DPDC-U1|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC-U1|CALLER))
        (compose-capability (SECURE))
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
        (with-capability (GOV|DPDC-U1_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC-U1_ADMIN)
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
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPDC:module{OuronetPolicy} DPDC)
                (mg:guard (create-capability-guard (P|DPDC-U1|CALLER)))
            )
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPDC::P|A_AddIMP mg)
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
    (defcap DPDC|S>CTRL (id:string sft-or-nft:bool)
        @event
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (ref-DPDC::CAP_Owner id sft-or-nft)
            (ref-DPDC::UEV_CanUpgradeON id sft-or-nft)
        )
    )
    (defcap DPDC|C>ISSUE (account:string creator-account:string collection-name:string collection-ticker:string)
        @event
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV2} U|DALOS)
                (ref-DALOS:module{OuronetDalosV3} DALOS)
            )
            (ref-U|DALOS::UEV_NameOrTicker collection-name true false)
            (ref-U|DALOS::UEV_NameOrTicker collection-ticker false false)
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (ref-DALOS::UEV_EnforceAccountType creator-account false)
            (compose-capability (P|SECURE-CALLER))
        )
    )
    (defcap DPDC|S>TG_PAUSE (id:string sft-or-nft:bool toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (if toggle
                (ref-DPDC::UEV_CanPauseON id sft-or-nft)
                true
            )
            (ref-DPDC::UEV_PauseState id sft-or-nft (not toggle))
            (ref-DPDC::CAP_Owner id sft-or-nft)
        )
    )
    ;;{C3}
    ;;{C4}
    (defcap DPDC|C>TG_ADD-QTY-R (id:string account:string toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (ref-DPDC::UEV_ToggleSpecialRole id true toggle)
            (ref-DPDC::UEV_AccountAddQuantityState id account (not toggle))
            (ref-DPDC::CAP_Owner id true)
            (compose-capability (P|DPDC-U1|CALLER))
        )
    )
    (defcap DPDC|C>FRZ-ACC (id:string sft-or-nft:bool account:string frozen:bool)
        @event
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (ref-DPDC::UEV_CanFreezeON id sft-or-nft)
            (ref-DPDC::UEV_AccountFreezeState id sft-or-nft account (not frozen))
            (ref-DPDC::CAP_Owner id sft-or-nft)
            (compose-capability (P|DPDC-U1|CALLER))
        )
    )
    (defcap DPDC|C>TG_EXEMPTION-R (id:string sft-or-nft:bool account:string toggle:bool)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (type:bool (ref-DALOS::UR_AccountType account))
            )
            (enforce type "Only Smart Ouronet Accounts can get this role")
            (ref-DPDC::UEV_AccountExemptionState id sft-or-nft account (not toggle))
            (ref-DPDC::CAP_Owner id sft-or-nft)
            (compose-capability (P|DPDC-U1|CALLER))
        )
    )
    (defcap DPDC|C>TG_BURN-R (id:string sft-or-nft:bool account:string toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (ref-DPDC::UEV_ToggleSpecialRole id sft-or-nft toggle)
            (ref-DPDC::UEV_AccountBurnState id sft-or-nft account (not toggle))
            (ref-DPDC::CAP_Owner id sft-or-nft)
            (compose-capability (P|DPDC-U1|CALLER))
        )
    )
    (defcap DPDC|C>TG_UPDATE-R (id:string sft-or-nft:bool account:string toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (ref-DPDC::UEV_ToggleSpecialRole id sft-or-nft toggle)
            (ref-DPDC::UEV_AccountUpdateState id sft-or-nft account (not toggle))
            (ref-DPDC::CAP_Owner id sft-or-nft)
            (compose-capability (P|DPDC-U1|CALLER))
        )
    )
    (defcap DPDC|C>TG_MODIFY-CREATOR-R (id:string sft-or-nft:bool account:string toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (ref-DPDC::UEV_ToggleSpecialRole id sft-or-nft toggle)
            (ref-DPDC::UEV_AccountModifyCreatorState id sft-or-nft account (not toggle))
            (ref-DPDC::CAP_Owner id sft-or-nft)
            (compose-capability (P|DPDC-U1|CALLER))
        )
    )
    (defcap DPDC|C>TG_MODIFY-ROYALTIES-R (id:string sft-or-nft:bool account:string toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (ref-DPDC::UEV_ToggleSpecialRole id sft-or-nft toggle)
            (ref-DPDC::UEV_AccountModifyRoyaltiesState id sft-or-nft account (not toggle))
            (ref-DPDC::CAP_Owner id sft-or-nft)
            (compose-capability (P|DPDC-U1|CALLER))
        )
    )
    (defcap DPDC|C>TG_TRANSFER-R (id:string sft-or-nft:bool account:string toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (ref-DPDC::UEV_ToggleSpecialRole id sft-or-nft toggle)
            (ref-DPDC::UEV_AccountTransferState id sft-or-nft account (not toggle))
            (ref-DPDC::CAP_Owner id sft-or-nft)
            (compose-capability (P|DPDC-U1|CALLER))
        )
    )
    ;;
    (defcap DPDC|C>MV_CREATE-R (id:string sft-or-nft:bool old-account:string new-account:string)
        @event
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (ref-DPDC::UEV_CanAddSpecialRoleON id sft-or-nft)
            (ref-DPDC::UEV_AccountCreateState id sft-or-nft old-account true)
            (ref-DPDC::UEV_AccountCreateState id sft-or-nft new-account false)
            (ref-DPDC::CAP_Owner id sft-or-nft)
            (compose-capability (P|DPDC-U1|CALLER))
        )
    )
    (defcap DPDC|C>MV_RECREATE-R (id:string sft-or-nft:bool old-account:string new-account:string)
        @event
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (ref-DPDC::UEV_CanAddSpecialRoleON id sft-or-nft)
            (ref-DPDC::UEV_AccountRecreateState id sft-or-nft old-account true)
            (ref-DPDC::UEV_AccountRecreateState id sft-or-nft new-account false)
            (ref-DPDC::CAP_Owner id sft-or-nft)
            (compose-capability (P|DPDC-U1|CALLER))
        ) 
    )
    (defcap DPDC|C>MV_SET-URI-R (id:string sft-or-nft:bool old-account:string new-account:string)
        @event
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (ref-DPDC::UEV_CanAddSpecialRoleON id sft-or-nft)
            (ref-DPDC::UEV_AccountSetUriState id sft-or-nft old-account true)
            (ref-DPDC::UEV_AccountSetUriState id sft-or-nft new-account false)
            (ref-DPDC::CAP_Owner id sft-or-nft)
            (compose-capability (P|DPDC-U1|CALLER))
        )
    )
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
    (defun C_Control:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sft-or-nft:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (owner:string (ref-DPDC::UR_OwnerKonto id sft-or-nft))
            )
            (with-capability (DPDC|S>CTRL id sft-or-nft)
                (XI_Control id sft-or-nft cu cco ccc casr ctncr cf cw cp)
                (if sft-or-nft
                    (ref-DALOS::UDC_BigCumulatorV2 owner)
                    (ref-DALOS::UDC_BiggestCumulatorV2 owner)
                )
            )
        )
    )
    (defun C_IssueDigitalCollection:object{OuronetDalosV3.OutputCumulatorV2}
        (
            patron:string sft-or-nft:bool
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
        (UEV_IMC)
        (with-capability (DPDC|C>ISSUE owner-account creator-account collection-name collection-ticker)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-BRD:module{Branding} BRD)
                    (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                    ;;
                    (multiplier:decimal (if sft-or-nft 5.0 10.0))
                    (ti:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                    (ignis-price:decimal (* ti multiplier))
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                    ;;
                    (kda-cost:decimal
                        (if sft-or-nft
                            (ref-DALOS::UR_UsagePrice "dpsf")
                            (ref-DALOS::UR_UsagePrice "dpsf")
                        )
                    )
                    (id:string
                        (XI_IssueDigitalCollection
                            sft-or-nft
                            owner-account creator-account collection-name collection-ticker
                            can-upgrade can-change-owner can-change-creator can-add-special-role 
                            can-transfer-nft-create-role can-freeze can-wipe can-pause
                        )
                    )
                )
                (ref-BRD::XE_Issue id)
                ;;Deploy Collection Accounts for Owner and Creator
                (if sft-or-nft
                    (do
                        (ref-DPDC::XB_DeployAccountSFT id owner-account true false false false true true false false false true false)
                        (ref-DPDC::XB_DeployAccountSFT id creator-account false false false false false false false false false false false)
                    )
                    (do
                        (ref-DPDC::XB_DeployAccountNFT id owner-account false false false true true false false false true false)
                        (ref-DPDC::XB_DeployAccountNFT id creator-account false false false false false false false false false false false)
                    )
                )
                (ref-DALOS::KDA|C_Collect patron kda-cost)
                (ref-DALOS::UDC_ConstructOutputCumulatorV2 ignis-price owner-account trigger [id])
            )
        )
    )
    ;;
    (defun C_TogglePause:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sft-or-nft:bool toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (with-capability (DPDC|S>TG_PAUSE id sft-or-nft toggle)
                (XI_TogglePause id sft-or-nft toggle)
                (ref-DALOS::UDC_MediumCumulatorV2 (ref-DPDC::UR_OwnerKonto id sft-or-nft))
            )
        )
    )
    ;;Role Toggling
    (defun C_ToggleAddQuantityRole:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (with-capability (DPDC|C>TG_ADD-QTY-R id account toggle)
                (ref-DPDC::XE_DeployAccountWNE id true account)
                (XI_ToggleAddQuantityRole id account toggle)
                (ref-DALOS::UDC_BigCumulatorV2 (ref-DPDC::UR_OwnerKonto id true))
            )
        )
    )
    (defun C_ToggleFreezeAccount:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sft-or-nft:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (with-capability (DPDC|C>FRZ-ACC id sft-or-nft account toggle)
                (ref-DPDC::XE_DeployAccountWNE id sft-or-nft account)
                (XI_ToggleFreezeAccount id sft-or-nft account toggle)
                (ref-DALOS::UDC_BiggestCumulatorV2 (ref-DPDC::UR_OwnerKonto id sft-or-nft))
            )
        )
    )
    (defun C_ToggleExemptionRole:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sft-or-nft:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (with-capability (DPDC|C>TG_EXEMPTION-R id sft-or-nft account toggle)
                (ref-DPDC::XE_DeployAccountWNE id sft-or-nft account)
                (XI_ToggleExemptionRole id sft-or-nft account toggle)
                (ref-DALOS::UDC_BiggestCumulatorV2 (ref-DPDC::UR_OwnerKonto id sft-or-nft))
            )
        )
    )
    (defun C_ToggleBurnRole:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sft-or-nft:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (with-capability (DPDC|C>TG_BURN-R id sft-or-nft account toggle)
                (ref-DPDC::XE_DeployAccountWNE id sft-or-nft account)
                (XI_ToggleBurnRole id sft-or-nft account toggle)
                (ref-DALOS::UDC_BigCumulatorV2 (ref-DPDC::UR_OwnerKonto id sft-or-nft))
            )
        )
    )
    (defun C_ToggleUpdateRole:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sft-or-nft:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (with-capability (DPDC|C>TG_UPDATE-R id sft-or-nft account toggle)
                (ref-DPDC::XE_DeployAccountWNE id sft-or-nft account)
                (XI_ToggleUpdateRole id sft-or-nft account toggle)
                (ref-DALOS::UDC_BigCumulatorV2 (ref-DPDC::UR_OwnerKonto id sft-or-nft))
            )
        )
    )
    (defun C_ToggleModifyCreatorRole:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sft-or-nft:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (with-capability (DPDC|C>TG_MODIFY-CREATOR-R id sft-or-nft account toggle)
                (ref-DPDC::XE_DeployAccountWNE id sft-or-nft account)
                (XI_ToggleModifyCreatorRole id sft-or-nft account toggle)
                (ref-DALOS::UDC_BigCumulatorV2 (ref-DPDC::UR_OwnerKonto id sft-or-nft))
            )
        )
    )
    (defun C_ToggleModifyRoyaltiesRole:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sft-or-nft:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (with-capability (DPDC|C>TG_MODIFY-ROYALTIES-R id sft-or-nft account toggle)
                (ref-DPDC::XE_DeployAccountWNE id sft-or-nft account)
                (XI_ToggleModifyRoyaltiesRole id sft-or-nft account toggle)
                (ref-DALOS::UDC_BigCumulatorV2 (ref-DPDC::UR_OwnerKonto id sft-or-nft))
            )
        )
    )
    (defun C_ToggleTransferRole:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sft-or-nft:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (with-capability (DPDC|C>TG_TRANSFER-R id sft-or-nft account toggle)
                (ref-DPDC::XE_DeployAccountWNE id sft-or-nft account)
                (XI_ToggleTransferRole id sft-or-nft account toggle)
                (ref-DALOS::UDC_BigCumulatorV2 (ref-DPDC::UR_OwnerKonto id sft-or-nft))
            )
        )
    )
    ;;
    (defun C_MoveCreateRole:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sft-or-nft:bool new-account:string)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (old-account:string (at 0 (ref-DPDC::UR_ER-Create id sft-or-nft)))
            )
            (with-capability (DPDC|C>MV_CREATE-R id sft-or-nft old-account new-account)
                (ref-DPDC::XE_DeployAccountWNE id sft-or-nft new-account)
                (XI_MoveCreateRole id sft-or-nft old-account new-account)
                (ref-DALOS::UDC_BiggestCumulatorV2 (ref-DPDC::UR_OwnerKonto id sft-or-nft))
            )
        )
    )
    (defun C_MoveRecreateRole:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sft-or-nft:bool new-account:string)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (old-account:string (at 0 (ref-DPDC::UR_ER-Recreate id sft-or-nft)))
            )
            (with-capability (DPDC|C>MV_RECREATE-R id sft-or-nft old-account new-account)
                (ref-DPDC::XE_DeployAccountWNE id sft-or-nft new-account)
                (XI_MoveRecreateRole id sft-or-nft old-account new-account)
                (ref-DALOS::UDC_BiggestCumulatorV2 (ref-DPDC::UR_OwnerKonto id sft-or-nft))
            )
        )
    )
    (defun C_MoveSetUriRole:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sft-or-nft:bool new-account:string)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (old-account:string (at 0 (ref-DPDC::UR_ER-SetUri id sft-or-nft)))
            )
            (with-capability (DPDC|C>MV_SET-URI-R id sft-or-nft old-account new-account)
                (ref-DPDC::XE_DeployAccountWNE id sft-or-nft new-account)
                (XI_MoveSetUriRole id sft-or-nft old-account new-account)
                (ref-DALOS::UDC_BiggestCumulatorV2 (ref-DPDC::UR_OwnerKonto id sft-or-nft))
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_Control (id:string sft-or-nft:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        (require-capability (DPDC|S>CTRL id sft-or-nft))
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (ref-DPDC::XB_UP|Specs id sft-or-nft 
                (ref-DPDC::UDC_Control id sft-or-nft cu cco ccc casr ctncr cf cw cp)
            )
        )
    )
    (defun XI_IssueDigitalCollection:string
        (
            sft-or-nft:bool
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
        (require-capability (DPDC|C>ISSUE owner-account creator-account collection-name collection-ticker))
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV2} U|DALOS)
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (id:string (ref-U|DALOS::UDC_Makeid collection-ticker))
                (specifications:object{DemiourgosPactDigitalCollectibles.DPDC|PropertiesSchema}
                    (ref-DPDC::UDC_Properties
                        owner-account creator-account collection-name collection-ticker
                        can-upgrade can-change-owner can-change-creator can-add-special-role
                        can-transfer-nft-create-role can-freeze can-wipe can-pause
                        false 0
                    )
                )
                (existing-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (if sft-or-nft
                        (ref-DPDC::UDC_ExistingRoles [BAR] [BAR] [owner-account] [BAR] [owner-account] [owner-account] [BAR] [BAR] [BAR] [owner-account] [BAR])    
                        (ref-DPDC::UDC_ExistingRoles [BAR] [BAR] [BAR] [BAR] [owner-account] [owner-account] [BAR] [BAR] [BAR] [owner-account] [BAR])
                    )
                )
                (zse:[object{DemiourgosPactDigitalCollectibles.DPDC|Set}]
                    [(ref-DPDC::UDC_ZeroSet)]
                )
                (zne:[object{DemiourgosPactDigitalCollectibles.DPDC|NonceElementSchema}]
                    [(ref-DPDC::UDC_NonceZeroElement)]
                )
            )
            (ref-DPDC::XE_InsertNewCollection id sft-or-nft zne specifications zse existing-roles)
            id
        )
    )
    (defun XI_TogglePause (id:string sft-or-nft:bool toggle:bool)
        (require-capability (DPDC|S>TG_PAUSE id sft-or-nft toggle))
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (new-specs:object{DemiourgosPactDigitalCollectibles.DPDC|PropertiesSchema}
                    (+
                        {"is-paused" : toggle}
                        (remove "is-paused" (ref-DPDC::UR_CollectionSpecs id sft-or-nft))
                    )
                )
            )
            (ref-DPDC::XB_UP|Specs id sft-or-nft new-specs)
        )
    )
    ;;
    (defun XI_ToggleAddQuantityRole (id:string account:string toggle:bool)
        (require-capability (DPDC|C>TG_ADD-QTY-R id account toggle))
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV2} U|DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                (add-q-accounts:[string] (ref-DPDC::UR_ER-AddQuantity id))
                (updated-add-q-accounts:[string] (ref-U|DALOS::UC_NewRoleList add-q-accounts account toggle))
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-nft-add-quantity" : updated-add-q-accounts}
                        (remove "r-nft-add-quantity" (ref-DPDC::UR_CollectionRoles id true))
                    )
                )
            )
            (ref-DPDC::XB_UAD|Rnaq id account toggle)
            (ref-DPDC::XB_UP|ExistingRoles id true prp-roles)
        )
    )
    (defun XI_ToggleFreezeAccount (id:string sft-or-nft:bool account:string toggle:bool)
        (require-capability (DPDC|C>FRZ-ACC id sft-or-nft account toggle))
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV2} U|DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                ;;
                (frozen-accounts:[string] (ref-DPDC::UR_ER-Frozen id sft-or-nft))
                (updated-frozen-accounts:[string] (ref-U|DALOS::UC_NewRoleList frozen-accounts account toggle))
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"a-frozen" : updated-frozen-accounts}
                        (remove "a-frozen" (ref-DPDC::UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"frozen"   : toggle}
                        (remove "frozen" (ref-DPDC::UR_CA|R id sft-or-nft account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRoles id sft-or-nft account prp-roles acc-roles)
        )
    )
    (defun XI_ToggleExemptionRole (id:string sft-or-nft:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_EXEMPTION-R id sft-or-nft account toggle))
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV2} U|DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                ;;
                (exemption-r-accounts:[string] (ref-DPDC::UR_ER-Exemption id sft-or-nft))
                (updated-exemption-r-accounts:[string] (ref-U|DALOS::UC_NewRoleList exemption-r-accounts account toggle))
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-exemption" : updated-exemption-r-accounts}
                        (remove "r-exemption" (ref-DPDC::UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-exemption"   : toggle}
                        (remove "role-exemption" (ref-DPDC::UR_CA|R id sft-or-nft account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRoles id sft-or-nft account prp-roles acc-roles)
        )
    )
    (defun XI_ToggleBurnRole (id:string sft-or-nft:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_BURN-R id sft-or-nft account toggle))
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV2} U|DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                ;;
                (burn-r-accounts:[string] (ref-DPDC::UR_ER-Burn id sft-or-nft))
                (updated-burn-r-accounts:[string] (ref-U|DALOS::UC_NewRoleList burn-r-accounts account toggle))
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-nft-burn" : updated-burn-r-accounts}
                        (remove "r-nft-burn" (ref-DPDC::UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-nft-burn"   : toggle}
                        (remove "role-nft-burn" (ref-DPDC::UR_CA|R id sft-or-nft account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRoles id sft-or-nft account prp-roles acc-roles)
        )
    )
    (defun XI_ToggleUpdateRole (id:string sft-or-nft:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_UPDATE-R id sft-or-nft account toggle))
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV2} U|DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                ;;
                (update-r-accounts:[string] (ref-DPDC::UR_ER-Update id sft-or-nft))
                (updated-update-r-accounts:[string] (ref-U|DALOS::UC_NewRoleList update-r-accounts account toggle))
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-nft-update" : updated-update-r-accounts}
                        (remove "r-nft-update" (ref-DPDC::UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-nft-update"   : toggle}
                        (remove "role-nft-update" (ref-DPDC::UR_CA|R id sft-or-nft account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRoles id sft-or-nft account prp-roles acc-roles)
        )
    )
    (defun XI_ToggleModifyCreatorRole (id:string sft-or-nft:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_MODIFY-CREATOR-R id sft-or-nft account toggle))
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV2} U|DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                ;;
                (modc-r-accounts:[string] (ref-DPDC::UR_ER-Update id sft-or-nft))
                (updated-modc-r-accounts:[string] (ref-U|DALOS::UC_NewRoleList modc-r-accounts account toggle))
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-modify-creator" : updated-modc-r-accounts}
                        (remove "r-modify-creator" (ref-DPDC::UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-modify-creator"   : toggle}
                        (remove "role-modify-creator" (ref-DPDC::UR_CA|R id sft-or-nft account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRoles id sft-or-nft account prp-roles acc-roles)
        )
    )
    (defun XI_ToggleModifyRoyaltiesRole (id:string sft-or-nft:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_MODIFY-ROYALTIES-R id sft-or-nft account toggle))
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV2} U|DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                ;;
                (modr-r-accounts:[string] (ref-DPDC::UR_ER-ModifyRoyalties id sft-or-nft))
                (updated-modr-r-accounts:[string] (ref-U|DALOS::UC_NewRoleList modr-r-accounts account toggle))
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-modify-royalties" : updated-modr-r-accounts}
                        (remove "r-modify-royalties" (ref-DPDC::UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-modify-royalties"   : toggle}
                        (remove "role-modify-royalties" (ref-DPDC::UR_CA|R id sft-or-nft account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRoles id sft-or-nft account prp-roles acc-roles)
        )
    )
    (defun XI_ToggleTransferRole (id:string sft-or-nft:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_TRANSFER-R id sft-or-nft account toggle))
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV2} U|DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                ;;
                (transfer-r-accounts:[string] (ref-DPDC::UR_ER-Transfer id sft-or-nft))
                (updated-transfer-r-accounts:[string] (ref-U|DALOS::UC_NewRoleList transfer-r-accounts account toggle))
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-transfer" : updated-transfer-r-accounts}
                        (remove "r-transfer" (ref-DPDC::UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-transfer"   : toggle}
                        (remove "role-transfer" (ref-DPDC::UR_CA|R id sft-or-nft account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRoles id sft-or-nft account prp-roles acc-roles)
        )
    )
    ;;
    (defun XI_MoveCreateRole (id:string sft-or-nft:bool old-account:string new-account:string)
        (require-capability (DPDC|C>MV_CREATE-R id sft-or-nft old-account new-account))
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV2} U|DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                ;;
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-nft-create" : [new-account]}
                        (remove "r-nft-create" (ref-DPDC::UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (old-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-nft-create"   : false}
                        (remove "role-nft-create" (ref-DPDC::UR_CA|R id sft-or-nft old-account))
                    )
                )
                (new-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-nft-create"   : true}
                        (remove "role-nft-create" (ref-DPDC::UR_CA|R id sft-or-nft new-account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRolesSingle id sft-or-nft old-account new-account prp-roles old-acc-roles new-acc-roles)
        )
    )
    (defun XI_MoveRecreateRole (id:string sft-or-nft:bool old-account:string new-account:string)
        (require-capability (DPDC|C>MV_RECREATE-R id sft-or-nft old-account new-account))
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV2} U|DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                ;;
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-nft-recreate" : [new-account]}
                        (remove "r-nft-recreate" (ref-DPDC::UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (old-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-nft-recreate"   : false}
                        (remove "role-nft-recreate" (ref-DPDC::UR_CA|R id sft-or-nft old-account))
                    )
                )
                (new-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-nft-recreate"   : true}
                        (remove "role-nft-recreate" (ref-DPDC::UR_CA|R id sft-or-nft new-account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRolesSingle id sft-or-nft old-account new-account prp-roles old-acc-roles new-acc-roles)
        )
    )
    (defun XI_MoveSetUriRole (id:string sft-or-nft:bool old-account:string new-account:string)
        (require-capability (DPDC|C>MV_SET-URI-R id sft-or-nft old-account new-account))
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV2} U|DALOS)
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
                ;;
                (prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
                    (+
                        {"r-set-new-uri" : [new-account]}
                        (remove "r-set-new-uri" (ref-DPDC::UR_CollectionRoles id sft-or-nft))
                    )
                )
                ;;
                (old-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-set-new-uri"   : false}
                        (remove "role-set-new-uri" (ref-DPDC::UR_CA|R id sft-or-nft old-account))
                    )
                )
                (new-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema}
                    (+
                        {"role-set-new-uri"   : true}
                        (remove "role-set-new-uri" (ref-DPDC::UR_CA|R id sft-or-nft new-account))
                    )
                )
            )
            (XI_UpdateRolesAndExistingRolesSingle id sft-or-nft old-account new-account prp-roles old-acc-roles new-acc-roles)
        )
    )
    ;;
    (defun XI_UpdateRolesAndExistingRolesSingle
        (
            id:string sft-or-nft:bool old-account:string new-account:string
            prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
            old-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema} 
            new-acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema} 
        )
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (XI_UpdateRolesAndExistingRoles id sft-or-nft new-account prp-roles new-acc-roles)
            (ref-DPDC::XB_UAD|Roles id sft-or-nft old-account old-acc-roles)
        )
    )
    (defun XI_UpdateRolesAndExistingRoles
        (
            id:string sft-or-nft:bool account:string 
            prp-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesStorageSchema}
            acc-roles:object{DemiourgosPactDigitalCollectibles.DPDC|RolesSchema} 
        )
        (let
            (
                (ref-DPDC:module{DemiourgosPactDigitalCollectibles} DPDC)
            )
            (ref-DPDC::XB_UAD|Roles id sft-or-nft account acc-roles)
            (ref-DPDC::XB_UP|ExistingRoles id sft-or-nft prp-roles)
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)