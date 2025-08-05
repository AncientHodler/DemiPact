(module DPDC-R GOV
    ;;
    (implements OuronetPolicy)
    (implements DpdcRoles)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-R                 (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPDC-R_ADMIN)))
    (defcap GOV|DPDC-R_ADMIN ()             (enforce-guard GOV|MD_DPDC-R))
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
    (defcap P|DPDC-R|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC-R|CALLER))
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
        (with-capability (GOV|DPDC-R_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC-R_ADMIN)
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
                (ref-P|DPDC:module{OuronetPolicy} DPDC)
                (mg:guard (create-capability-guard (P|DPDC-R|CALLER)))
            )
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
    ;;{C3}
    ;;{C4}
    (defcap DPDC|C>TG_ADD-QTY-R (id:string account:string toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_ToggleSpecialRole id true toggle)
            (ref-DPDC::UEV_AccountAddQuantityState id account (not toggle))
            (ref-DPDC::CAP_Owner id true)
            (compose-capability (P|DPDC-R|CALLER))
        )
    )
    (defcap DPDC|C>FRZ-ACC (id:string son:bool account:string frozen:bool)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_CanFreezeON id son)
            (ref-DPDC::UEV_AccountFreezeState id son account (not frozen))
            (ref-DPDC::CAP_Owner id son)
            (compose-capability (P|DPDC-R|CALLER))
        )
    )
    (defcap DPDC|C>TG_EXEMPTION-R (id:string son:bool account:string toggle:bool)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (type:bool (ref-DALOS::UR_AccountType account))
            )
            (enforce type "Only Smart Ouronet Accounts can get this role")
            (ref-DPDC::UEV_AccountExemptionState id son account (not toggle))
            (ref-DPDC::CAP_Owner id son)
            (compose-capability (P|DPDC-R|CALLER))
        )
    )
    (defcap DPDC|C>TG_BURN-R (id:string son:bool account:string toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_ToggleSpecialRole id son toggle)
            (ref-DPDC::UEV_AccountBurnState id son account (not toggle))
            (ref-DPDC::CAP_Owner id son)
            (compose-capability (P|DPDC-R|CALLER))
        )
    )
    (defcap DPDC|C>TG_UPDATE-R (id:string son:bool account:string toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_ToggleSpecialRole id son toggle)
            (ref-DPDC::UEV_AccountUpdateState id son account (not toggle))
            (ref-DPDC::CAP_Owner id son)
            (compose-capability (P|DPDC-R|CALLER))
        )
    )
    (defcap DPDC|C>TG_MODIFY-CREATOR-R (id:string son:bool account:string toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_ToggleSpecialRole id son toggle)
            (ref-DPDC::UEV_AccountModifyCreatorState id son account (not toggle))
            (ref-DPDC::CAP_Owner id son)
            (compose-capability (P|DPDC-R|CALLER))
        )
    )
    (defcap DPDC|C>TG_MODIFY-ROYALTIES-R (id:string son:bool account:string toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_ToggleSpecialRole id son toggle)
            (ref-DPDC::UEV_AccountModifyRoyaltiesState id son account (not toggle))
            (ref-DPDC::CAP_Owner id son)
            (compose-capability (P|DPDC-R|CALLER))
        )
    )
    (defcap DPDC|C>TG_TRANSFER-R (id:string son:bool account:string toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_ToggleSpecialRole id son toggle)
            (ref-DPDC::UEV_AccountTransferState id son account (not toggle))
            (ref-DPDC::CAP_Owner id son)
            (compose-capability (P|DPDC-R|CALLER))
        )
    )
    ;;
    (defcap DPDC|C>MV_CREATE-R (id:string son:bool old-account:string new-account:string)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_CanAddSpecialRoleON id son)
            (ref-DPDC::UEV_AccountCreateState id son old-account true)
            (ref-DPDC::UEV_AccountCreateState id son new-account false)
            (ref-DPDC::CAP_Owner id son)
            (compose-capability (P|DPDC-R|CALLER))
        )
    )
    (defcap DPDC|C>MV_RECREATE-R (id:string son:bool old-account:string new-account:string)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_CanAddSpecialRoleON id son)
            (ref-DPDC::UEV_AccountRecreateState id son old-account true)
            (ref-DPDC::UEV_AccountRecreateState id son new-account false)
            (ref-DPDC::CAP_Owner id son)
            (compose-capability (P|DPDC-R|CALLER))
        ) 
    )
    (defcap DPDC|C>MV_SET-URI-R (id:string son:bool old-account:string new-account:string)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_CanAddSpecialRoleON id son)
            (ref-DPDC::UEV_AccountSetUriState id son old-account true)
            (ref-DPDC::UEV_AccountSetUriState id son new-account false)
            (ref-DPDC::CAP_Owner id son)
            (compose-capability (P|DPDC-R|CALLER))
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
    ;;Role Toggling
    (defun C_ToggleAddQuantityRole:object{IgnisCollector.OutputCumulator}
        (id:string account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC|C>TG_ADD-QTY-R id account toggle)
                (ref-DPDC::XE_DeployAccountWNE account id true)
                (XI_ToggleAddQuantityRole id account toggle)
                (ref-IGNIS::IC|UDC_BigCumulator (ref-DPDC::UR_OwnerKonto id true))
            )
        )
    )
    (defun C_ToggleFreezeAccount:object{IgnisCollector.OutputCumulator}
        (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC|C>FRZ-ACC id son account toggle)
                (ref-DPDC::XE_DeployAccountWNE account id son)
                (XI_ToggleFreezeAccount id son account toggle)
                (ref-IGNIS::IC|UDC_BiggestCumulator (ref-DPDC::UR_OwnerKonto id son))
            )
        )
    )
    (defun C_ToggleExemptionRole:object{IgnisCollector.OutputCumulator}
        (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC|C>TG_EXEMPTION-R id son account toggle)
                (ref-DPDC::XE_DeployAccountWNE account id son)
                (XI_ToggleExemptionRole id son account toggle)
                (ref-IGNIS::IC|UDC_BiggestCumulator (ref-DPDC::UR_OwnerKonto id son))
            )
        )
    )
    (defun C_ToggleBurnRole:object{IgnisCollector.OutputCumulator}
        (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC|C>TG_BURN-R id son account toggle)
                (ref-DPDC::XE_DeployAccountWNE account id son)
                (XI_ToggleBurnRole id son account toggle)
                (ref-IGNIS::IC|UDC_BigCumulator (ref-DPDC::UR_OwnerKonto id son))
            )
        )
    )
    (defun C_ToggleUpdateRole:object{IgnisCollector.OutputCumulator}
        (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC|C>TG_UPDATE-R id son account toggle)
                (ref-DPDC::XE_DeployAccountWNE account id son)
                (XI_ToggleUpdateRole id son account toggle)
                (ref-IGNIS::IC|UDC_BigCumulator (ref-DPDC::UR_OwnerKonto id son))
            )
        )
    )
    (defun C_ToggleModifyCreatorRole:object{IgnisCollector.OutputCumulator}
        (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC|C>TG_MODIFY-CREATOR-R id son account toggle)
                (ref-DPDC::XE_DeployAccountWNE account id son)
                (XI_ToggleModifyCreatorRole id son account toggle)
                (ref-IGNIS::IC|UDC_BigCumulator (ref-DPDC::UR_OwnerKonto id son))
            )
        )
    )
    (defun C_ToggleModifyRoyaltiesRole:object{IgnisCollector.OutputCumulator}
        (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC|C>TG_MODIFY-ROYALTIES-R id son account toggle)
                (ref-DPDC::XE_DeployAccountWNE account id son)
                (XI_ToggleModifyRoyaltiesRole id son account toggle)
                (ref-IGNIS::IC|UDC_BigCumulator (ref-DPDC::UR_OwnerKonto id son))
            )
        )
    )
    (defun C_ToggleTransferRole:object{IgnisCollector.OutputCumulator}
        (id:string son:bool account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC|C>TG_TRANSFER-R id son account toggle)
                (ref-DPDC::XE_DeployAccountWNE account id son)
                (XI_ToggleTransferRole id son account toggle)
                (ref-IGNIS::IC|UDC_BigCumulator (ref-DPDC::UR_OwnerKonto id son))
            )
        )
    )
    ;;
    (defun C_MoveCreateRole:object{IgnisCollector.OutputCumulator}
        (id:string son:bool new-account:string)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (old-account:string (ref-DPDC::UR_Verum5 id son))
            )
            (with-capability (DPDC|C>MV_CREATE-R id son old-account new-account)
                (ref-DPDC::XE_DeployAccountWNE new-account id son)
                (XI_MoveCreateRole id son old-account new-account)
                (ref-IGNIS::IC|UDC_BiggestCumulator (ref-DPDC::UR_OwnerKonto id son))
            )
        )
    )
    (defun C_MoveRecreateRole:object{IgnisCollector.OutputCumulator}
        (id:string son:bool new-account:string)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (old-account:string (ref-DPDC::UR_Verum6 id son))
            )
            (with-capability (DPDC|C>MV_RECREATE-R id son old-account new-account)
                (ref-DPDC::XE_DeployAccountWNE new-account id son)
                (XI_MoveRecreateRole id son old-account new-account)
                (ref-IGNIS::IC|UDC_BiggestCumulator (ref-DPDC::UR_OwnerKonto id son))
            )
        )
    )
    (defun C_MoveSetUriRole:object{IgnisCollector.OutputCumulator}
        (id:string son:bool new-account:string)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (old-account:string (ref-DPDC::UR_Verum10 id son))
            )
            (with-capability (DPDC|C>MV_SET-URI-R id son old-account new-account)
                (ref-DPDC::XE_DeployAccountWNE new-account id son)
                (XI_MoveSetUriRole id son old-account new-account)
                (ref-IGNIS::IC|UDC_BiggestCumulator (ref-DPDC::UR_OwnerKonto id son))
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_ToggleAddQuantityRole (id:string account:string toggle:bool)
        (require-capability (DPDC|C>TG_ADD-QTY-R id account toggle))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::XE_U|Rnaq id account toggle)
            (ref-DPDC::XE_U|VerumRoles id true 3 toggle account)
        )
    )
    (defun XI_ToggleFreezeAccount (id:string son:bool account:string toggle:bool)
        (require-capability (DPDC|C>FRZ-ACC id son account toggle))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
            )
            (ref-DPDC::XE_U|Frozen id son account toggle)
            (ref-DPDC::XE_U|VerumRoles id son 1 toggle account)
        )
    )
    (defun XI_ToggleExemptionRole (id:string son:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_EXEMPTION-R id son account toggle))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
            )
            (ref-DPDC::XE_U|Exemption id son account toggle)
            (ref-DPDC::XE_U|VerumRoles id son 2 toggle account)
        )
    )
    (defun XI_ToggleBurnRole (id:string son:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_BURN-R id son account toggle))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::XE_U|Burn id son account toggle)
            (ref-DPDC::XE_U|VerumRoles id son 4 toggle account)
        )
    )
    (defun XI_ToggleUpdateRole (id:string son:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_UPDATE-R id son account toggle))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::XE_U|Update id son account toggle)
            (ref-DPDC::XE_U|VerumRoles id son 7 toggle account)
        )
    )
    (defun XI_ToggleModifyCreatorRole (id:string son:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_MODIFY-CREATOR-R id son account toggle))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::XE_U|ModifyCreator id son account toggle)
            (ref-DPDC::XE_U|VerumRoles id son 8 toggle account)
        )
    )
    (defun XI_ToggleModifyRoyaltiesRole (id:string son:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_MODIFY-ROYALTIES-R id son account toggle))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::XE_U|ModifyRoyalties id son account toggle)
            (ref-DPDC::XE_U|VerumRoles id son 9 toggle account)
        )
    )
    (defun XI_ToggleTransferRole (id:string son:bool account:string toggle:bool)
        (require-capability (DPDC|C>TG_TRANSFER-R id son account toggle))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::XE_U|Transfer id son account toggle)
            (ref-DPDC::XE_U|VerumRoles id son 11 toggle account)
        )
    )
    ;;
    (defun XI_MoveCreateRole (id:string son:bool old-account:string new-account:string)
        (require-capability (DPDC|C>MV_CREATE-R id son old-account new-account))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::XE_U|Create id son old-account false)
            (ref-DPDC::XE_U|VerumRoles id son 5 false old-account)
            (ref-DPDC::XE_U|Create id son new-account true)
            (ref-DPDC::XE_U|VerumRoles id son 5 true new-account)
        )
    )
    (defun XI_MoveRecreateRole (id:string son:bool old-account:string new-account:string)
        (require-capability (DPDC|C>MV_RECREATE-R id son old-account new-account))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::XE_U|Recreate id son old-account false)
            (ref-DPDC::XE_U|VerumRoles id son 6 false old-account)
            (ref-DPDC::XE_U|Recreate id son new-account true)
            (ref-DPDC::XE_U|VerumRoles id son 6 true new-account)
        )
    )
    (defun XI_MoveSetUriRole (id:string son:bool old-account:string new-account:string)
        (require-capability (DPDC|C>MV_SET-URI-R id son old-account new-account))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::XE_U|SetNewUri id son old-account false)
            (ref-DPDC::XE_U|VerumRoles id son 10 false old-account)
            (ref-DPDC::XE_U|SetNewUri id son new-account true)
            (ref-DPDC::XE_U|VerumRoles id son 10 true new-account)
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)