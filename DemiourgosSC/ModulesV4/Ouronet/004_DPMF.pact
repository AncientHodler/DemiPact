;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface DemiourgosPactMetaFungibleV4
    @doc "Exposes most of the Functions of the DPMF Module. \
    \ The ATS Module contains 3 more DPTF Functions that couldnt be brought here logisticaly \
    \ UR(Utility-Read), URC(Utility-Read-Compute), UEV(Utility-Enforce-Validate) and \
    \ UDC(Utility-Data-Composition) are NOT sorted alphabetically \
    \ \
    \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
    \ Removes the 2 Branding Functions from this Interface, since they are in their own interface. \
    \ \
    \ V3 adds 2 Functions related to single Elite Account Update. \
    \ \
    \ V4 Removes <patron> input variable where it is not needed"
    ;;
    ;;
    (defschema DPMF|Schema
        nonce:integer
        balance:decimal
        meta-data:[object]
    )
    (defschema DPMF|Nonce-Balance
        nonce:integer
        balance:decimal
    )
    ;;
    ;;
    (defun UR_P-KEYS:[string] ())
    (defun UR_KEYS:[string] ())
    ;;
    (defun UR_Konto:string (id:string))
    (defun UR_Name:string (id:string))
    (defun UR_Ticker:string (id:string))
    (defun UR_Decimals:integer (id:string))
    (defun UR_CanChangeOwner:bool (id:string))
    (defun UR_CanUpgrade:bool (id:string))
    (defun UR_CanAddSpecialRole:bool (id:string))
    (defun UR_CanFreeze:bool (id:string))
    (defun UR_CanWipe:bool (id:string))
    (defun UR_CanPause:bool (id:string))
    (defun UR_Paused:bool (id:string))
    (defun UR_Supply:decimal (id:string))
    (defun UR_TransferRoleAmount:integer (id:string))
    (defun UR_Vesting:string (id:string))
    (defun UR_Sleeping:string (id:string))
    (defun UR_Roles:[string] (id:string rp:integer))
    (defun UR_CanTransferNFTCreateRole:bool (id:string))
    (defun UR_CreateRoleAccount:string (id:string))
    (defun UR_NoncesUsed:integer (id:string))
    (defun UR_RewardBearingToken:string (id:string))
    (defun UR_AccountSupply:decimal (id:string account:string))
    (defun UR_AccountRoleBurn:bool (id:string account:string))
    (defun UR_AccountRoleCreate:bool (id:string account:string))
    (defun UR_AccountRoleNFTAQ:bool (id:string account:string))
    (defun UR_AccountRoleTransfer:bool (id:string account:string))
    (defun UR_AccountFrozenState:bool (id:string account:string))
    ;;
    (defun UR_AccountUnit:[object{DPMF|Schema}] (id:string account:string))
    (defun UR_AccountNonces:[integer] (id:string account:string))
    (defun UR_AccountBalances:[decimal] (id:string account:string))
    (defun UR_AccountMetaDatas:[[object]] (id:string account:string))
        ;;
    (defun UR_AccountNonceBalance:decimal (id:string nonce:integer account:string))
    (defun UR_AccountNonceMetaData:[object] (id:string nonce:integer account:string))
        ;;
    (defun UR_AccountNoncesBalances:[decimal] (id:string nonces:[integer] account:string))
    (defun UR_AccountNoncesMetaDatas:[[object]] (id:string nonces:[integer] account:string))
    ;;
    (defun URC_IzRBT:bool (reward-bearing-token:string))
    (defun URC_IzRBTg:bool (atspair:string reward-bearing-token:string))
    (defun URC_EliteAurynzSupply (account:string))
    (defun URC_AccountExist:bool (id:string account:string))
    (defun URC_HasVesting:bool (id:string))
    (defun URC_HasSleeping:bool (id:string))
    (defun URC_Parent:string (dpmf:string))
    (defun URC_IzIdEA:bool (id:string))
    ;;
    (defun UEV_ParentOwnership (dpmf:string))
    (defun UEV_NoncesToAccount (id:string account:string nonces:[integer]))
    (defun UEV_id (id:string))
    (defun UEV_CheckID:bool (id:string))
    (defun UEV_Amount (id:string amount:decimal))
    (defun UEV_CheckAmount:bool (id:string amount:decimal))
    (defun UEV_UpdateRewardBearingToken (id:string))
    (defun UEV_CanChangeOwnerON (id:string))
    (defun UEV_CanUpgradeON (id:string))
    (defun UEV_CanAddSpecialRoleON (id:string))
    (defun UEV_CanFreezeON (id:string))
    (defun UEV_CanWipeON (id:string))
    (defun UEV_CanPauseON (id:string))
    (defun UEV_PauseState (id:string state:bool))
    (defun UEV_AccountBurnState (id:string account:string state:bool))
    (defun UEV_AccountTransferState (id:string account:string state:bool))
    (defun UEV_AccountFreezeState (id:string account:string state:bool))
    (defun UEV_CanTransferNFTCreateRoleON (id:string))
    (defun UEV_AccountAddQuantityState (id:string account:string state:bool))
    (defun UEV_AccountCreateState (id:string account:string state:bool))
    (defun UEV_Vesting (id:string existance:bool))
    (defun UEV_Sleeping (id:string existance:bool))
    ;;
    (defun UDC_Compose:object{DPMF|Schema} (nonce:integer balance:decimal meta-data:[object]))
    (defun UDC_Nonce-Balance:[object{DPMF|Nonce-Balance}] (nonce-lst:[integer] balance-lst:[decimal]))
    ;;
    ;;
    (defun CAP_Owner (id:string))
    ;;
    (defun C_AddQuantity:object{IgnisCollector.OutputCumulator} (id:string nonce:integer account:string amount:decimal))
    (defun C_Burn:object{IgnisCollector.OutputCumulator} (id:string nonce:integer account:string amount:decimal))
    (defun C_Control:object{IgnisCollector.OutputCumulator} (id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool))
    (defun C_Create:object{IgnisCollector.OutputCumulator} (id:string account:string meta-data:[object]))
    (defun C_DeployAccount (id:string account:string))
    (defun C_Issue:object{IgnisCollector.OutputCumulator} (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool]))
    (defun C_Mint:object{IgnisCollector.OutputCumulator} (id:string account:string amount:decimal meta-data:[object]))
    (defun C_MultiBatchTransfer:object{IgnisCollector.OutputCumulator} (id:string nonces:[integer] sender:string receiver:string method:bool))
    (defun C_RotateOwnership:object{IgnisCollector.OutputCumulator} (id:string new-owner:string))
    (defun C_SingleBatchTransfer:object{IgnisCollector.OutputCumulator} (id:string nonce:integer sender:string receiver:string method:bool))
    (defun C_ToggleFreezeAccount:object{IgnisCollector.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_TogglePause:object{IgnisCollector.OutputCumulator}  (id:string toggle:bool))
    (defun C_ToggleTransferRole:object{IgnisCollector.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_Transfer:object{IgnisCollector.OutputCumulator} (id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool))
    (defun C_Wipe:object{IgnisCollector.OutputCumulator} (id:string atbw:string))
    (defun C_WipePartial:object{IgnisCollector.OutputCumulator} (id:string atbw:string nonces:[integer]))
    ;;
    (defun XB_DeployAccountWNE (id:string account:string))
    (defun XB_IssueFree:object{IgnisCollector.OutputCumulator} (account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool] iz-special:[bool]))
    (defun XB_UpdateEliteSingle (id:string account:string))
    (defun XB_UpdateElite (id:string sender:string receiver:string))
    (defun XB_WriteRoles (id:string account:string rp:integer d:bool))
    ;;
    (defun XE_MoveCreateRole (id:string receiver:string))
    (defun XE_ToggleAddQuantityRole (id:string account:string toggle:bool))
    (defun XE_ToggleBurnRole (id:string account:string toggle:bool))
    (defun XE_UpdateRewardBearingToken (atspair:string id:string))
    (defun XE_UpdateSpecialMetaFungible:object{IgnisCollector.OutputCumulator} (main-dptf:string secondary-dpmf:string vesting-or-sleeping:bool))
)
(module DPMF GOV
    ;;
    (implements OuronetPolicy)
    (implements BrandingUsageV6)
    (implements DemiourgosPactMetaFungibleV4)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPMF           (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|DPMF_ADMIN)))
    (defcap GOV|DPMF_ADMIN ()       (enforce-guard GOV|MD_DPMF))
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
    (defcap P|DPMF|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPMF|CALLER))
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
        (with-capability (GOV|DPMF_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPMF_ADMIN)
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
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (mg:guard (create-capability-guard (P|DPMF|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
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
    (defschema DPMF|PropertiesSchema
        owner-konto:string
        name:string
        ticker:string
        decimals:integer
        can-change-owner:bool
        can-upgrade:bool
        can-add-special-role:bool
        can-freeze:bool
        can-wipe:bool
        can-pause:bool
        is-paused:bool
        can-transfer-nft-create-role:bool
        supply:decimal
        create-role-account:string
        role-transfer-amount:integer
        nonces-used:integer
        reward-bearing-token:string
        vesting-link:string
        sleeping-link:string
    )
    (defschema DPMF|BalanceSchema
        @doc "Key = <DPMF id> + BAR + <account>"
        exist:bool
        unit:[object{DemiourgosPactMetaFungibleV4.DPMF|Schema}]
        role-nft-add-quantity:bool
        role-nft-burn:bool
        role-nft-create:bool
        role-transfer:bool
        frozen:bool
    )
    (defschema DPMF|RoleSchema
        r-nft-burn:[string]
        r-nft-create:[string]
        r-nft-add-quantity:[string]
        r-transfer:[string]
        a-frozen:[string]
    )
    ;;{2}
    (deftable DPMF|PropertiesTable:{DPMF|PropertiesSchema})
    (deftable DPMF|BalanceTable:{DPMF|BalanceSchema})
    (deftable DPMF|RoleTable:{DPMF|RoleSchema})
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    (defconst DPMF|NEUTRAL
        {"nonce": 0
        ,"balance": 0.0
        ,"meta-data": [{}] }
    )
    (defconst DPMF|NEGATIVE
        {"nonce": -1
        ,"balance": -1.0
        ,"meta-data": [{}] }
    )
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    (defcap DPMF|S>CTRL (id:string)
        @event
        (CAP_Owner id )
        (UEV_CanUpgradeON id)
    )
    (defcap DPMF|S>X_FRZ-ACC (id:string account:string frozen:bool)
        (CAP_Owner id)
        (UEV_CanFreezeON id)
        (UEV_AccountFreezeState id account (not frozen))
    )
    (defcap DPMF|S>RT_OWN (id:string new-owner:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-DALOS::UEV_SenderWithReceiver (UR_Konto id) new-owner)
            (ref-DALOS::UEV_EnforceAccountExists new-owner)
            (CAP_Owner id)
            (UEV_CanChangeOwnerON id)
        )
    )
    (defcap DPMF|S>TG_BURN-R (id:string account:string toggle:bool)
        @event
        (if toggle
            (UEV_CanAddSpecialRoleON id)
            true
        )
        (CAP_Owner id)
        (UEV_AccountBurnState id account (not toggle))
    )
    (defcap DPMF|S>TG_PAUSE (id:string pause:bool)
        @event
        (if pause
            (UEV_CanPauseON id)
            true
        )
        (CAP_Owner id)
        (UEV_PauseState id (not pause))
    )
    (defcap DPMF|S>MULTI-BATCH-TRANSFER (id:string nonces:[integer] sender:string)
        @event
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (account-nonces:[integer] (UR_AccountNonces id sender))
                (contains-all:bool (ref-U|INT::UEV_ContainsAll nonces account-nonces))
            )
            (enforce contains-all "Invalid Nonce List for DPMF Multi Batch Transfer")
        )
    )
    (defcap DPMF|S>X_TG_TRANSFER-R (id:string account:string toggle:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
            )
            (enforce (!= account ouroboros) (format "{} Account is immune to transfer roles" [ouroboros]))
            (enforce (!= account dalos) (format "{} Account is immune to transfer roles" [dalos]))
            (if toggle
                (UEV_CanAddSpecialRoleON id)
                true
            )
            (CAP_Owner id)
            (UEV_AccountTransferState id account (not toggle))
        )
    )
    (defcap DPMF|S>MOVE_CREATE-R (id:string receiver:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-DALOS::UEV_SenderWithReceiver (UR_CreateRoleAccount id) receiver)
            (CAP_Owner id)
            (UEV_CanTransferNFTCreateRoleON id)
            (UEV_AccountCreateState id (UR_CreateRoleAccount id) true)
            (UEV_AccountCreateState id receiver false)
        )

    )
    (defcap DPMF|S>TG_ADD-QTY-R (id:string account:string toggle:bool)
        @event
        (CAP_Owner id)
        (UEV_AccountAddQuantityState id account (not toggle))
        (if toggle
            (UEV_CanAddSpecialRoleON id)
            true
        )
    )
    ;;{C3}
    ;;{C4}
    (defcap DPMF|C>UPDATE-BRD (dpmf:string)
        @event
        (UEV_ParentOwnership dpmf)
        (compose-capability (P|DPMF|CALLER))
    )
    (defcap DPMF|C>UPGRADE-BRD (dpmf:string)
        @event
        (UEV_ParentOwnership dpmf)
        (compose-capability (P|DPMF|CALLER))
    )
    (defcap BASIS|C>X_WRITE-ROLES (id:string account:string rp:integer)
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-U|INT::UEV_PositionalVariable rp 5 "Invalid Role Position")
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id)
            (compose-capability (SECURE))
        )
    )
    (defcap DPMF|C>BURN (id:string client:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership client)
            (UEV_Amount id amount)
            (UEV_AccountBurnState id client true)
            (compose-capability (SECURE))
        )
    )
    (defcap DPMF|C>FRZ-ACC (id:string account:string frozen:bool)
        @event
        (compose-capability (DPMF|S>X_FRZ-ACC id account frozen))
        (compose-capability (BASIS|C>X_WRITE-ROLES id account 5))
    )
    (defcap DPMF|C>ISSUE (account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        @event
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (l1:integer (length name))
                (l2:integer (length ticker))
                (l3:integer (length decimals))
                (l4:integer (length can-change-owner))
                (l5:integer (length can-upgrade))
                (l6:integer (length can-add-special-role))
                (l7:integer (length can-freeze))
                (l8:integer (length can-wipe))
                (l9:integer (length can-pause))
                (l0:integer (length can-transfer-nft-create-role))
                (lengths:[integer] [l1 l2 l3 l4 l5 l6 l7 l8 l9 l0])
            )
            (ref-U|INT::UEV_UniformList lengths)
            (ref-U|LST::UC_IzUnique name)
            (ref-U|LST::UC_IzUnique ticker)
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (compose-capability (P|SECURE-CALLER))
        )
    )
    (defcap DPMF|C>TG_TRANSFER-R (id:string account:string toggle:bool)
        @event
        (compose-capability (DPMF|S>X_TG_TRANSFER-R id account toggle))
        (compose-capability (BASIS|C>X_WRITE-ROLES id account 4))
        (compose-capability (SECURE))
    )
    (defcap DPMF|C>TOTAL-WIPE (id:string account-to-be-wiped:string)
        @event
        (compose-capability (DPMF|X>WIPE id account-to-be-wiped))
    )
    (defcap DPMF|C>PARTIAL-WIPE (id:string account-to-be-wiped:string nonces:[integer])
        @event
        (UEV_NoncesToAccount id account-to-be-wiped nonces)
        (compose-capability (DPMF|X>WIPE id account-to-be-wiped))

    )
    (defcap DPMF|X>WIPE (id:string account-to-be-wiped:string)
        (UEV_CanWipeON id)
        (UEV_AccountFreezeState id account-to-be-wiped true)
        (compose-capability (SECURE))
    )
    (defcap DPMF|C>ADD-QTY (id:string client:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership client)
            (UEV_Amount id amount)
            (UEV_AccountAddQuantityState id client true)
            (compose-capability (SECURE))
        )
    )
    (defcap DPMF|C>CREATE (id:string client:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership client)
            (UEV_AccountCreateState id client true)
            (compose-capability (SECURE))
        )
    )
    (defcap DPMF|C>MINT (id:string client:string amount:decimal)
        @event
        (compose-capability (DPMF|C>CREATE id client))
        (compose-capability (DPMF|C>ADD-QTY id client amount))
    )
    (defcap DPMF|C>TRANSFER (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
            )
            (ref-DALOS::CAP_EnforceAccountOwnership sender)
            (if (and method (ref-DALOS::UR_AccountType receiver))
                (ref-DALOS::CAP_EnforceAccountOwnership receiver)
                true
            )
            (UEV_Amount id transfer-amount)
            (ref-DALOS::UEV_EnforceTransferability sender receiver method)
            (UEV_PauseState id false)
            (UEV_AccountFreezeState id sender false)
            (UEV_AccountFreezeState id receiver false)
            (if
                (and
                    (> (UR_TransferRoleAmount id) 0)
                    (not (or (= sender ouroboros)(= sender dalos)))
                )
                (let
                    (
                        (s:bool (UR_AccountRoleTransfer id sender))
                        (r:bool (UR_AccountRoleTransfer id receiver))
                    )
                    (enforce-one
                        (format "Neither the sender {} nor the receiver {} have an active transfer role" [sender receiver])
                        [
                            (enforce (= s true) (format "Transfer-Role doesnt check for sender {}" [sender]))
                            (enforce (= r true) (format "Transfer-Role doesnt check for sender {}" [sender]))
                        ]
                    )
                )
                (format "No transfer restrictions exist when transfering {} from {} to {}" [id sender receiver])
            )
            (compose-capability (SECURE))
        )
    )
    (defcap DPMF|C>UPDATE-SPECIAL (main-dptf:string secondary-dpmf:string vesting-or-sleeping:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (main-special-id:string
                    (if vesting-or-sleeping
                        (ref-DPTF::UR_Vesting main-dptf)
                        (ref-DPTF::UR_Sleeping main-dptf)
                    )
                )
                (secondary-special-id:string
                    (if vesting-or-sleeping
                        (UR_Vesting secondary-dpmf)
                        (UR_Sleeping secondary-dpmf)
                    )
                )
                (iz-secondary-rbt:bool (URC_IzRBT secondary-dpmf))
                (main-dptf-first-character:string (take 1 main-dptf))
                (main-dptf-second-character:string (drop 1 (take 2 main-dptf)))
            )
            (ref-DPTF::CAP_Owner main-dptf)
            (CAP_Owner secondary-dpmf)
            (enforce
                (and (= main-special-id BAR) (= secondary-special-id BAR) )
                "Special Meta Fungible Links (vesting or sleeping) are immutable !"
            )
            (enforce
                (not iz-secondary-rbt)
                "Special Meta Fungible cannot be a Hot-RBT"
            )
            (if (= main-dptf-second-character BAR)
                (if vesting-or-sleeping
                    (enforce
                        (not (contains main-dptf-first-character ["R" "F" "S" "W" "P"]))
                        (format "When setting a Vesting Link, the main DPTF {} cannot be a Special DPTF" )
                    )
                    (enforce
                        (not (contains main-dptf-first-character ["R" "F"]))
                        (format "When setting a Sleeping Link, the main DPTF {} cannot be a Reserved or Frozen Token" )
                    )

                )
                true
            )
            (compose-capability (P|SECURE-CALLER))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_P-KEYS:[string] ()
        (keys DPMF|PropertiesTable)
    )
    (defun UR_KEYS:[string] ()
        (keys DPMF|BalanceTable)
    )
    ;;
    (defun UR_Konto:string (id:string)
        (at "owner-konto" (read DPMF|PropertiesTable id ["owner-konto"]))
    )
    (defun UR_Name:string (id:string)
        (at "name" (read DPMF|PropertiesTable id ["name"]))
    )
    (defun UR_Ticker:string (id:string)
        (at "ticker" (read DPMF|PropertiesTable id ["ticker"]))
    )
    (defun UR_Decimals:integer (id:string)
        (at "decimals" (read DPMF|PropertiesTable id ["decimals"]))
    )
    (defun UR_CanChangeOwner:bool (id:string)
        (at "can-change-owner" (read DPMF|PropertiesTable id ["can-change-owner"]))
    )
    (defun UR_CanUpgrade:bool (id:string)
        (at "can-upgrade" (read DPMF|PropertiesTable id ["can-upgrade"]))
    )
    (defun UR_CanAddSpecialRole:bool (id:string)
        (at "can-add-special-role" (read DPMF|PropertiesTable id ["can-add-special-role"]))
    )
    (defun UR_CanFreeze:bool (id:string)
        (at "can-freeze" (read DPMF|PropertiesTable id ["can-freeze"]))
    )
    (defun UR_CanWipe:bool (id:string)
        (at "can-wipe" (read DPMF|PropertiesTable id ["can-wipe"]))
    )
    (defun UR_CanPause:bool (id:string)
        (at "can-pause" (read DPMF|PropertiesTable id ["can-pause"]))
    )
    (defun UR_Paused:bool (id:string)
        (at "is-paused" (read DPMF|PropertiesTable id ["is-paused"]))
    )
    (defun UR_Supply:decimal (id:string)
        (at "supply" (read DPMF|PropertiesTable id ["supply"]))
    )
    (defun UR_TransferRoleAmount:integer (id:string)
        (at "role-transfer-amount" (read DPMF|PropertiesTable id ["role-transfer-amount"]))
    )
    (defun UR_Vesting:string (id:string)
        (at "vesting-link" (read DPMF|PropertiesTable id ["vesting-link"]))
    )
    (defun UR_Sleeping:string (id:string)
        (at "sleeping-link" (read DPMF|PropertiesTable id ["sleeping-link"]))
    )
    (defun UR_Roles:[string] (id:string rp:integer)
        (if (= rp 1)
            (with-default-read DPMF|RoleTable id
                { "r-burn" : [BAR]}
                { "r-burn" := rb }
                rb
            )
            (if (= rp 2)
                (with-default-read DPMF|RoleTable id
                    { "r-nft-create" : [BAR]}
                    { "r-nft-create" := rnc }
                    rnc
                )
                (if (= rp 3)
                    (with-default-read DPMF|RoleTable id
                        { "r-nft-add-quantity" : [BAR]}
                        { "r-nft-add-quantity" := rnaq }
                        rnaq
                    )
                    (if (= rp 4)
                        (with-default-read DPMF|RoleTable id
                            { "r-transfer" : [BAR]}
                            { "r-transfer" := rt }
                            rt
                        )
                        (with-default-read DPMF|RoleTable id
                            { "a-frozen" : [BAR]}
                            { "a-frozen" := af }
                            af
                        )
                    )
                )
            )
        )
    )
    (defun UR_CanTransferNFTCreateRole:bool (id:string)
        (at "can-transfer-nft-create-role" (read DPMF|PropertiesTable id ["can-transfer-nft-create-role"]))
    )
    (defun UR_CreateRoleAccount:string (id:string)
        (at "create-role-account" (read DPMF|PropertiesTable id ["create-role-account"]))
    )
    (defun UR_NoncesUsed:integer (id:string)
        (at "nonces-used" (read DPMF|PropertiesTable id ["nonces-used"]))
    )
    (defun UR_RewardBearingToken:string (id:string)
        (at "reward-bearing-token" (read DPMF|PropertiesTable id ["reward-bearing-token"]))
    )
    (defun UR_AccountSupply:decimal (id:string account:string)
        (fold (+) 0.0 (UR_AccountBalances id account))
    )

    (defun UR_AccountRoleBurn:bool (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "role-nft-burn" : false}
            { "role-nft-burn" := rb }
            rb
        )
    )
    (defun UR_AccountRoleCreate:bool (id:string account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "role-nft-create" : false}
            { "role-nft-create" := rnc }
            rnc
        )
    )
    (defun UR_AccountRoleNFTAQ:bool (id:string account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "role-nft-add-quantity" : false}
            { "role-nft-add-quantity" := rnaq }
            rnaq
        )
    )
    (defun UR_AccountRoleTransfer:bool (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "role-transfer" : false }
            { "role-transfer" := rt }
            rt
        )
    )
    (defun UR_AccountFrozenState:bool (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "frozen" : false}
            { "frozen" := fr }
            fr
        )
    )
    ;;
    (defun UR_AccountUnit:[object{DemiourgosPactMetaFungibleV4.DPMF|Schema}] (id:string account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "unit" : [DPMF|NEGATIVE]}
            { "unit" := u }
            u
        )
    )
    (defun UR_AccountNonces:[integer] (id:string account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            {"unit" : [DPMF|NEUTRAL]}
            {"unit" := read-unit}
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                )
                (fold
                    (lambda
                        (acc:[integer] item:object{DemiourgosPactMetaFungibleV4.DPMF|Schema})
                        (if (> (at "nonce" item) 0)
                                (ref-U|LST::UC_AppL acc (at "nonce" item))
                                acc
                        )
                    )
                    []
                    read-unit
                )
            )
        )
    )
    (defun UR_AccountBalances:[decimal] (id:string account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            {"unit" : [DPMF|NEUTRAL]}
            {"unit" := read-unit}
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                )
                (fold
                    (lambda
                        (acc:[decimal] item:object{DemiourgosPactMetaFungibleV4.DPMF|Schema})
                        (if (> (at "nonce" item) 0)
                                (ref-U|LST::UC_AppL acc (at "balance" item))
                                acc
                        )
                    )
                    []
                    read-unit
                )
            )
        )
    )
    (defun UR_AccountMetaDatas:[[object]] (id:string account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                )
                (fold
                    (lambda
                        (acc:[[object]] item:object{DemiourgosPactMetaFungibleV4.DPMF|Schema})
                        (if (> (at "nonce" item) 0)
                                (ref-U|LST::UC_AppL acc (at "meta-data" item))
                                acc
                        )
                    )
                    []
                    read-unit
                )
            )
        )
    )
    (defun UR_AccountNonceBalance:decimal (id:string nonce:integer account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            {"unit" : [DPMF|NEUTRAL]}
            {"unit" := read-unit}
            (fold
                (lambda
                    (acc:decimal item:object{DemiourgosPactMetaFungibleV4.DPMF|Schema})
                    (let
                        (
                            (nonce-val:integer (at "nonce" item))
                            (balance-val:decimal (at "balance" item))
                        )
                        (if (= nonce-val nonce)
                            balance-val
                            acc
                        )
                    )
                )
                0.0
                read-unit
            )
        )
    )
    (defun UR_AccountNonceMetaData:[object]
        (id:string nonce:integer account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (fold
                (lambda
                    (acc item:object{DemiourgosPactMetaFungibleV4.DPMF|Schema})
                    (let
                        (
                            (nonce-val:integer (at "nonce" item))
                            (meta-data-val (at "meta-data" item))
                        )
                        (if (= nonce-val nonce)
                            meta-data-val
                            acc
                        )
                    )
                )
                []
                read-unit
            )
        )
    )
    (defun UR_AccountNoncesBalances:[decimal] (id:string nonces:[integer] account:string)
        (UEV_id id)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (all-nonce-lst:[integer] (UR_AccountNonces id account))
                (all-balance-lst:[decimal] (UR_AccountBalances id account))
            )
            (UEV_NoncesToAccount id account nonces)
            (fold
                (lambda
                    (acc:[decimal] nonce:integer)
                    (ref-U|LST::UC_AppL acc (at (at 0 (ref-U|LST::UC_Search all-nonce-lst nonce)) all-balance-lst))
                )
                []
                nonces
            )
        )
    )
    (defun UR_AccountNoncesMetaDatas:[[object]] (id:string nonces:[integer] account:string)
        (UEV_id id)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (all-nonce-lst:[integer] (UR_AccountNonces id account))
                (all-metadata-lst:[[object]] (UR_AccountMetaDatas id account))
            )
            (UEV_NoncesToAccount id account nonces)
            (fold
                (lambda
                    (acc:[[object]] nonce:integer)
                    (ref-U|LST::UC_AppL acc (at (at 0 (ref-U|LST::UC_Search all-nonce-lst nonce)) all-metadata-lst))
                )
                []
                nonces
            )
        )
    )
    ;;{F1}  [URC]
    (defun URC_IzRBT:bool (reward-bearing-token:string)
        @doc "Returns a boolean, if token id is RBT in any atspair"
        (UEV_id reward-bearing-token)
        (if (= (UR_RewardBearingToken reward-bearing-token) BAR)
            false
            true
        )
    )
    (defun URC_IzRBTg:bool (atspair:string reward-bearing-token:string)
        @doc "Returns a boolean, if token id is RBT in a specific atspair"
        (UEV_id reward-bearing-token)
        (if (= (UR_RewardBearingToken reward-bearing-token) BAR)
            false
            (if (= (UR_RewardBearingToken reward-bearing-token) atspair)
                true
                false
            )
        )
    )
    (defun URC_EliteAurynzSupply (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
            )
            (if (!= ea-id BAR)
                (let
                    (
                        (ea-supply:decimal (ref-DPTF::UR_AccountSupply ea-id account))
                        (fea:string (ref-DPTF::UR_Frozen ea-id))
                        (rea:string (ref-DPTF::UR_Reservation ea-id))
                        (vea:string (ref-DPTF::UR_Vesting ea-id))
                        (sea:string (ref-DPTF::UR_Sleeping ea-id))
                        (fea-supply:decimal
                            (if (!= fea BAR)
                                (ref-DPTF::UR_AccountSupply fea account)
                                0.0
                            )
                        )
                        (rea-supply:decimal
                            (if (!= rea BAR)
                                (ref-DPTF::UR_AccountSupply rea account)
                                0.0
                            )
                        )
                        (vea-supply:decimal
                            (if (!= vea BAR)
                                (UR_AccountSupply vea account)
                                0.0
                            )
                        )
                        (sea-supply:decimal
                            (if (!= sea BAR)
                                (UR_AccountSupply sea account)
                                0.0
                            )
                        )
                    )
                    (fold (+) 0.0 [ea-supply fea-supply rea-supply vea-supply sea-supply])
                )
                0.0
            )
        )
    )
    (defun URC_AccountExist:bool (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "exist"   : false }
            { "exist"   := e}
            e
        )
    )
    (defun URC_HasVesting:bool (id:string)
        @doc "Returns a boolean if DPMF has a vesting counterpart"
        (if (= (UR_Vesting id) BAR)
            false
            true
        )
    )
    (defun URC_HasSleeping:bool (id:string)
        @doc "Returns a boolean if DPMF has a sleeping counterpart"
        (if (= (UR_Sleeping id) BAR)
            false
            true
        )
    )
    (defun URC_Parent:string (dpmf:string)
        @doc "Computes <dpmf> parent"
        (let
            (
                (fourth:string (drop 3 (take 4 dpmf)))
            )
            (enforce (!= fourth BAR) "Sleeping LP Tokens not allowed for this operation")
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (first-two:string (take 2 dpmf))
                )
                (if (= first-two "V|")
                    (UR_Vesting dpmf)
                    (if (= first-two "Z|")
                        (UR_Sleeping dpmf)
                        dpmf
                    )
                )
            )
        )
    )
    (defun URC_IzIdEA:bool (id:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
                (fea:string (ref-DPTF::UR_Frozen ea-id))
                (rea:string (ref-DPTF::UR_Reservation ea-id))
                (vea:string (ref-DPTF::UR_Vesting ea-id))
                (sea:string (ref-DPTF::UR_Sleeping ea-id))
            )
            (contains id [ea-id fea rea vea sea])
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_ParentOwnership (dpmf:string)
        @doc "Enforces: \
            \ <dpmf> Ownership, if <dpmf> is pure \
            \ <(UR_Vesting dpmf)>, if its a v|dpmf \
            \ <(UR_Sleeping dpmf)>, if its a s|dpmf \
            \ While ensuring a Sleeping LP cant be used for this operation."
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (parent:string (URC_Parent dpmf))
            )
            (if (= parent dpmf)
                (CAP_Owner dpmf)
                (ref-DPTF::CAP_Owner parent)
            )
        )
    )
    (defun UEV_NoncesToAccount (id:string account:string nonces:[integer])
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (all-nonce-lst:[integer] (UR_AccountNonces id account))
                (validate-nonces:bool (ref-U|INT::UEV_ContainsAll nonces all-nonce-lst))
            )
            (enforce validate-nonces (format "Input nonces {} for {} dont all exist on {}" [nonces id account]))
        )
    )
    (defun UEV_id (id:string)
        (with-default-read DPMF|PropertiesTable id
            { "supply" : -1.0 }
            { "supply" := s }
            (enforce
                (>= s 0.0)
                (format "DPMF ID {} does not exist" [id])
            )
        )
    )
    (defun UEV_CheckID:bool (id:string)
        (with-default-read DPMF|PropertiesTable id
            { "supply" : -1.0 }
            { "supply" := s }
            (if (>= s 0.0)
                true
                false
            )
        )
    )
    (defun UEV_Amount (id:string amount:decimal)
        (let
            (
                (decimals:integer (UR_Decimals id))
            )
            (enforce
                (= (floor amount decimals) amount)
                (format "{} is not conform with the {} prec" [amount id])
            )
            (enforce
                (> amount 0.0)
                (format "{} is not a Valid Transaction amount" [amount])
            )
        )
    )
    (defun UEV_CheckAmount:bool (id:string amount:decimal)
        (let
            (
                (decimals:integer (UR_Decimals id))
                (decimal-check:bool (if (= (floor amount decimals) amount) true false))
                (positivity-check:bool (if (> amount 0.0) true false))
                (result:bool (and decimal-check positivity-check))
            )
            result
        )
    )
    (defun UEV_UpdateRewardBearingToken (id:string)
        (let
            (
                (rbt:string (UR_RewardBearingToken id))
            )
            (enforce (= rbt BAR) "RBT for a DPMF is immutable")
        )
    )
    (defun UEV_CanChangeOwnerON (id:string)
        (let
            (
                (x:bool (UR_CanChangeOwner id))
            )
            (enforce (= x true) (format "{} ownership cannot be changed" [id]))
        )
    )
    (defun UEV_CanUpgradeON (id:string)
        (let
            (
                (x:bool (UR_CanUpgrade id))
            )
            (enforce (= x true) (format "{} properties cannot be upgraded" [id])
            )
        )
    )
    (defun UEV_CanAddSpecialRoleON (id:string)
        (let
            (
                (x:bool (UR_CanAddSpecialRole id))
            )
            (enforce (= x true) (format "For {} no special roles can be added" [id])
            )
        )
    )
    (defun UEV_CanFreezeON (id:string)
        (let
            (
                (x:bool (UR_CanFreeze id))
            )
            (enforce (= x true) (format "{} cannot be freezed" [id])
            )
        )
    )
    (defun UEV_CanWipeON (id:string)
        (let
            (
                (x:bool (UR_CanWipe id))
            )
            (enforce (= x true) (format "{} cannot be wiped" [id])
            )
        )
    )
    (defun UEV_CanPauseON (id:string)
        (let
            (
                (x:bool (UR_CanPause id))
            )
            (enforce (= x true) (format "{} cannot be paused" [id])
            )
        )
    )
    (defun UEV_PauseState (id:string state:bool)
        (let
            (
                (x:bool (UR_Paused id))
            )
            (if state
                (enforce x (format "{} is already unpaused" [id]))
                (enforce (= x false) (format "{} is already paused" [id]))
            )
        )
    )
    (defun UEV_AccountBurnState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_AccountRoleBurn id account))
            )
            (enforce (= x state) (format "Burn Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountTransferState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_AccountRoleTransfer id account))
            )
            (enforce (= x state) (format "Transfer Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountFreezeState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_AccountFrozenState id account))
            )
            (enforce (= x state) (format "Frozen for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_CanTransferNFTCreateRoleON (id:string)
        (let
            (
                (x:bool (UR_CanTransferNFTCreateRole id))
            )
            (enforce (= x true) (format "DPMF Token {} cannot have its create role transfered" [id])
            )
        )
    )
    (defun UEV_AccountAddQuantityState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_AccountRoleNFTAQ id account))
            )
            (enforce (= x state) (format "Add Quantity Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountCreateState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_AccountRoleCreate id account))
            )
            (enforce (= x state) (format "Create Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_Vesting (id:string existance:bool)
        (let
            (
                (has-vesting:bool (URC_HasVesting id))
            )
            (enforce (= has-vesting existance) (format "Vesting for the Token {} is not satisfied with existance {}" [id existance]))
        )
    )
    (defun UEV_Sleeping (id:string existance:bool)
        (let
            (
                (has-sleeping:bool (URC_HasSleeping id))
            )
            (enforce (= has-sleeping existance) (format "Sleeping for the Token {} is not satisfied with existance {}" [id existance]))
        )
    )
    ;;{F3}  [UDC]
    (defun UDC_Compose:object{DemiourgosPactMetaFungibleV4.DPMF|Schema} (nonce:integer balance:decimal meta-data:[object])
        @doc "Composes a DPMF Object"
        {"nonce" : nonce, "balance": balance, "meta-data" : meta-data}
    )
    (defun UDC_Nonce-Balance:[object{DemiourgosPactMetaFungibleV4.DPMF|Nonce-Balance}] (nonce-lst:[integer] balance-lst:[decimal])
        @doc "Composes a Nonce-Balance Object, needed for Wiping functionality"
        (let
            (
                (nonce-length:integer (length nonce-lst))
                (balance-length:integer (length balance-lst))
            )
            (enforce (= nonce-length balance-length) "Nonce and Balance Lists are not of equal length")
            (zip (lambda (x:integer y:decimal) { "nonce": x, "balance": y }) nonce-lst balance-lst)
        )
    )
    ;;{F4}  [CAP]
    (defun CAP_Owner (id:string)
        @doc "Enforces DPMF Token ID Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (UR_Konto id))
        )
    )
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_UpdatePendingBranding:object{IgnisCollector.OutputCumulator}
        (entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-BRD:module{Branding} BRD)
            )
            (with-capability (DPMF|C>UPDATE-BRD entity-id)
                (ref-BRD::XE_UpdatePendingBranding entity-id logo description website social)
                (ref-IGNIS::IC|UDC_BrandingCumulator (UR_Konto entity-id) 1.5)
            )
        )
    )
    (defun C_UpgradeBranding (patron:string entity-id:string months:integer)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-BRD:module{Branding} BRD)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (parent:string (URC_Parent entity-id))
                (parent-owner:string
                    (if (= parent entity-id)
                        (UR_Konto entity-id)
                        (ref-DPTF::UR_Konto parent)
                    )
                )
                (kda-payment:decimal
                    (with-capability (DPMF|C>UPGRADE-BRD entity-id)
                        (ref-BRD::XE_UpgradeBranding entity-id parent-owner months)
                    )
                )
            )
            (ref-DALOS::KDA|C_CollectWT patron kda-payment false)
        )
    )
    ;;
    (defun C_AddQuantity:object{IgnisCollector.OutputCumulator}
        (id:string nonce:integer account:string amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPMF|C>ADD-QTY id account amount)
                (XI_AddQuantity id nonce account amount)
                (ref-IGNIS::IC|UDC_SmallCumulator (UR_Konto id))
            )
        )
    )
    (defun C_Burn:object{IgnisCollector.OutputCumulator}
        (id:string nonce:integer account:string amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPMF|C>BURN id account amount)
                (XI_Burn id nonce account amount)
                (ref-IGNIS::IC|UDC_SmallCumulator (UR_Konto id))
            )
        )
    )
    (defun C_Control:object{IgnisCollector.OutputCumulator}
        (id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPMF|S>CTRL id)
                (XI_Control id cco cu casr cf cw cp ctncr)
                (ref-IGNIS::IC|UDC_MediumCumulator (UR_Konto id))
            )
        )
    )
    (defun C_Create:object{IgnisCollector.OutputCumulator}
        (id:string account:string meta-data:[object])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|medium"))
                (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                (new-nonce:integer
                    (with-capability (DPMF|C>CREATE id account)
                        (XI_Create id account meta-data)
                    )
                )
            )
            (ref-IGNIS::IC|UDC_ConstructOutputCumulator price (UR_Konto id) trigger [new-nonce])
        )
    )
    (defun C_DeployAccount (id:string account:string)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (create-role-account:string (UR_CreateRoleAccount id))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id)
            (with-default-read DPMF|BalanceTable (concat [id BAR account])
                {"exist"                               : true
                ,"unit"                                : [DPMF|NEUTRAL]
                ,"role-nft-add-quantity"               : false
                ,"role-nft-burn"                       : false
                ,"role-nft-create"                     : role-nft-create-boolean
                ,"role-transfer"                       : false
                ,"frozen"                              : false}
                {"exist"                               := e
                ,"unit"                                := u
                ,"role-nft-add-quantity"               := rnaq
                ,"role-nft-burn"                       := rb
                ,"role-nft-create"                     := rnc
                ,"role-transfer"                       := rt
                ,"frozen"                              := f }
                (write DPMF|BalanceTable (concat [id BAR account])
                    {"exist"                           : e
                    ,"unit"                            : u
                    ,"role-nft-add-quantity"           : rnaq
                    ,"role-nft-burn"                   : rb
                    ,"role-nft-create"                 : rnc
                    ,"role-transfer"                   : rt
                    ,"frozen"                          : f}
                )
            )
        )
    )
    (defun C_Issue:object{IgnisCollector.OutputCumulator}
        (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (l1:integer (length name))
                (mf-cost:decimal (ref-DALOS::UR_UsagePrice "dpmf"))
                (kda-costs:decimal (* (dec l1) mf-cost))
                (iz-special:[bool] (make-list l1 false))
                (ico:object{IgnisCollector.OutputCumulator}
                    (with-capability (SECURE)
                        (XB_IssueFree account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role iz-special)
                    )
                )
            )
            (ref-DALOS::KDA|C_Collect patron kda-costs)
            ico
        )
    )
    (defun C_Mint:object{IgnisCollector.OutputCumulator}
        (id:string account:string amount:decimal meta-data:[object])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (new-nonce:integer
                    (with-capability (DPMF|C>MINT id account amount)
                        (XI_Mint id account amount meta-data)
                    )
                )
                (medium:decimal (ref-DALOS::UR_UsagePrice "ignis|medium"))
                (small:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (price:decimal (+ medium small))
                (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
            )
            (ref-IGNIS::IC|UDC_ConstructOutputCumulator price (UR_Konto id) trigger [new-nonce])
        )
    )
    (defun C_MultiBatchTransfer:object{IgnisCollector.OutputCumulator}
        (id:string nonces:[integer] sender:string receiver:string method:bool)
        (UEV_IMC)
        (with-capability (DPMF|S>MULTI-BATCH-TRANSFER id nonces sender)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (folded-obj:[object{IgnisCollector.OutputCumulator}]
                        (fold
                            (lambda
                                (acc:[object{IgnisCollector.OutputCumulator}] idx:integer)
                                (ref-U|LST::UC_AppL
                                    acc
                                    (C_SingleBatchTransfer id (at idx nonces) sender receiver method)
                                )
                            )
                            []
                            (enumerate 0 (- (length nonces) 1))
                        )
                    )
                )
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators folded-obj [])
            )
        )
    )
    (defun C_RotateOwnership:object{IgnisCollector.OutputCumulator}
        (id:string new-owner:string)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPMF|S>RT_OWN id new-owner)
                (XI_ChangeOwnership id new-owner)
                (ref-IGNIS::IC|UDC_BiggestCumulator (UR_Konto id))
            )
        )
    )
    (defun C_SingleBatchTransfer:object{IgnisCollector.OutputCumulator}
        (id:string nonce:integer sender:string receiver:string method:bool)
        (UEV_IMC)
        (C_Transfer id nonce sender receiver (UR_AccountNonceBalance id nonce sender) method)
    )
    (defun C_ToggleFreezeAccount:object{IgnisCollector.OutputCumulator}
        (id:string account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPMF|C>FRZ-ACC id account toggle)
                (XI_ToggleFreezeAccount id account toggle)
                (XB_WriteRoles id account 5 toggle)
                (ref-IGNIS::IC|UDC_BiggestCumulator (UR_Konto id))
            )
        )
    )
    (defun C_TogglePause:object{IgnisCollector.OutputCumulator}
        (id:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPMF|S>TG_PAUSE id toggle)
                (XI_TogglePause id toggle)
                (ref-IGNIS::IC|UDC_MediumCumulator (UR_Konto id))
            )
        )
    )
    (defun C_ToggleTransferRole:object{IgnisCollector.OutputCumulator}
        (id:string account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPMF|C>TG_TRANSFER-R id account toggle)
                (XB_DeployAccountWNE id account)
                (XI_ToggleTransferRole id account toggle)
                (XI_UpdateRoleTransferAmount id toggle)
                (XB_WriteRoles id account 4 toggle)
                (ref-IGNIS::IC|UDC_BiggestCumulator (UR_Konto id))
            )
        )
    )
    (defun C_Transfer:object{IgnisCollector.OutputCumulator}
        (id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPMF|C>TRANSFER id sender receiver transfer-amount method)
                (XI_Transfer id nonce sender receiver transfer-amount method)
                (ref-IGNIS::IC|UDC_SmallCumulator (UR_Konto id))
            )
        )
    )
    (defun C_Wipe:object{IgnisCollector.OutputCumulator}
        (id:string atbw:string)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPMF|C>TOTAL-WIPE id atbw)
                (XI_Wipe id atbw)
                (ref-IGNIS::IC|UDC_BiggestCumulator (UR_Konto id))
            )
        )
    )
    (defun C_WipePartial:object{IgnisCollector.OutputCumulator}
        (id:string atbw:string nonces:[integer])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPMF|C>PARTIAL-WIPE id atbw nonces)
                (XI_WipePartial id atbw nonces)
                (ref-IGNIS::IC|UDC_BiggestCumulator (UR_Konto id))
            )
        )
    )
    ;;{F7}  [X]
    (defun XB_DeployAccountWNE (id:string account:string)
        (UEV_IMC)
        (let
            (
                (exist-account:bool (URC_AccountExist id account))
            )
            (if (not exist-account)
                (C_DeployAccount id account)
                true
            )
        )
    )
    (defun XB_IssueFree:object{IgnisCollector.OutputCumulator}
        (
            account:string
            name:[string]
            ticker:[string]
            decimals:[integer]
            can-change-owner:[bool]
            can-upgrade:[bool]
            can-add-special-role:[bool]
            can-freeze:[bool]
            can-wipe:[bool]
            can-pause:[bool]
            can-transfer-nft-create-role:[bool]
            iz-special:[bool]
        )
        (UEV_IMC)
        (with-capability (DPMF|C>ISSUE account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-BRD:module{Branding} BRD)
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (l1:integer (length name))
                    (gas-costs:decimal (* (dec l1) (ref-DALOS::UR_UsagePrice "ignis|token-issue")))
                    (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                    (folded-lst:[string]
                        (fold
                            (lambda
                                (acc:[string] index:integer)
                                (let
                                    (
                                        (id:string
                                            (XI_Issue
                                                account
                                                (at index name)
                                                (at index ticker)
                                                (at index decimals)
                                                (at index can-change-owner)
                                                (at index can-upgrade)
                                                (at index can-add-special-role)
                                                (at index can-freeze)
                                                (at index can-wipe)
                                                (at index can-pause)
                                                (at index can-transfer-nft-create-role)
                                                (at index iz-special)
                                            )
                                        )
                                    )
                                    (ref-BRD::XE_Issue id)
                                    (ref-U|LST::UC_AppL acc id)
                                )
                            )
                            []
                            (enumerate 0 (- l1 1))
                        )
                    )
                )
                (ref-IGNIS::IC|UDC_ConstructOutputCumulator gas-costs account trigger folded-lst)
            )
        )
    )
    (defun XB_UpdateEliteSingle (id:string account:string)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (iz-elite-auryn:bool (URC_IzIdEA id))
                (a-type:bool (ref-DALOS::UR_AccountType account))
            )
            (if iz-elite-auryn
                (with-capability (P|DPMF|CALLER)
                    (if (not a-type)
                        (ref-DALOS::XE_UpdateElite account (URC_EliteAurynzSupply account))
                        true
                    )
                )
                true
            )
        )
    )
    (defun XB_UpdateElite (id:string sender:string receiver:string)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (iz-elite-auryn:bool (URC_IzIdEA id))
                (s-type:bool (ref-DALOS::UR_AccountType sender))
                (r-type:bool (ref-DALOS::UR_AccountType receiver))
            )
            (if iz-elite-auryn
                (with-capability (P|DPMF|CALLER)
                    (if (not s-type)
                        (ref-DALOS::XE_UpdateElite sender (URC_EliteAurynzSupply sender))
                        true
                    )
                    (if (not r-type)
                        (ref-DALOS::XE_UpdateElite receiver (URC_EliteAurynzSupply receiver))
                        true
                    )
                )
                true
            )
        )
    )
    (defun XB_WriteRoles (id:string account:string rp:integer d:bool)
        (UEV_IMC)
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
            )
            (with-capability (BASIS|C>X_WRITE-ROLES id account rp)
                (with-default-read DPMF|RoleTable id
                    {"r-nft-burn"           : [BAR]
                    ,"r-nft-create"         : [BAR]
                    ,"r-nft-add-quantity"   : [BAR]
                    ,"r-transfer"           : [BAR]
                    ,"a-frozen"             : [BAR]}
                    {"r-nft-burn"           := rb
                    ,"r-nft-create"         := rnc
                    ,"r-nft-add-quantity"   := rnaq
                    ,"r-transfer"           := rt
                    ,"a-frozen"             := af}
                    (if (= rp 1)
                        (write DPMF|RoleTable id
                            {"r-nft-burn"           : (ref-U|DALOS::UC_NewRoleList rb account d)
                            ,"r-nft-create"         : rnc
                            ,"r-nft-add-quantity"   : rnaq
                            ,"r-transfer"           : rt
                            ,"a-frozen"             : af}
                        )
                        (if (= rp 2)
                            (write DPMF|RoleTable id
                                {"r-nft-burn"           : rb
                                ,"r-nft-create"         : (ref-U|DALOS::UC_NewRoleList rnc account d)
                                ,"r-nft-add-quantity"   : rnaq
                                ,"r-transfer"           : rt
                                ,"a-frozen"             : af}
                            )
                            (if (= rp 3)
                                (write DPMF|RoleTable id
                                    {"r-nft-burn"           : rb
                                    ,"r-nft-create"         : rnc
                                    ,"r-nft-add-quantity"   : (ref-U|DALOS::UC_NewRoleList rnaq account d)
                                    ,"r-transfer"           : rt
                                    ,"a-frozen"             : af}
                                )
                                (if (= rp 4)
                                    (write DPMF|RoleTable id
                                        {"r-nft-burn"           : rb
                                        ,"r-nft-create"         : rnc
                                        ,"r-nft-add-quantity"   : rnaq
                                        ,"r-transfer"           : (ref-U|DALOS::UC_NewRoleList rt account d)
                                        ,"a-frozen"             : af}
                                    )
                                    (write DPMF|RoleTable id
                                        {"r-nft-burn"          : rb
                                        ,"r-nft-create"        : rnc
                                        ,"r-nft-add-quantity"  : rnaq
                                        ,"r-transfer"          : rt
                                        ,"a-frozen"            : (ref-U|DALOS::UC_NewRoleList af account d)}
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    ;;
    (defun XE_MoveCreateRole (id:string receiver:string)
        (UEV_IMC)
        (with-capability (DPMF|S>MOVE_CREATE-R id receiver)
            (update DPMF|BalanceTable (concat [id BAR (UR_CreateRoleAccount id)])
                {"role-nft-create" : false}
            )
            (update DPMF|BalanceTable (concat [id BAR receiver])
                {"role-nft-create" : true}
            )
            (update DPMF|PropertiesTable id
                {"create-role-account" : receiver}
            )
        )
    )
    (defun XE_ToggleAddQuantityRole (id:string account:string toggle:bool)
        (UEV_IMC)
        (with-capability (DPMF|S>TG_ADD-QTY-R id account toggle)
            (update DPMF|BalanceTable (concat [id BAR account])
                {"role-nft-add-quantity" : toggle}
            )
        )
    )
    (defun XE_ToggleBurnRole (id:string account:string toggle:bool)
        (UEV_IMC)
        (with-capability (DPMF|S>TG_BURN-R id account toggle)
            (update DPMF|BalanceTable (concat [id BAR account])
                {"role-nft-burn" : toggle}
            )
        )
    )
    (defun XE_UpdateRewardBearingToken (atspair:string id:string)
        (UEV_IMC)
        (UEV_UpdateRewardBearingToken id)
        (update DPMF|PropertiesTable id
            {"reward-bearing-token" : atspair}
        )
    )
    (defun XE_UpdateSpecialMetaFungible:object{IgnisCollector.OutputCumulator}
        (main-dptf:string secondary-dpmf:string vesting-or-sleeping:bool)
        (UEV_IMC)
        (with-capability (DPMF|C>UPDATE-SPECIAL main-dptf secondary-dpmf vesting-or-sleeping)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                )
                (if vesting-or-sleeping
                    (do
                        (ref-DPTF::XE_UpdateVesting main-dptf secondary-dpmf)
                        (XI_UpdateVesting main-dptf secondary-dpmf)
                    )
                    (do
                        (ref-DPTF::XE_UpdateSleeping main-dptf secondary-dpmf)
                        (XI_UpdateSleeping main-dptf secondary-dpmf)
                    )
                )
                (ref-IGNIS::IC|UDC_BiggestCumulator (ref-DPTF::UR_Konto main-dptf))
            )
        )
    )
    ;;
    (defun XI_AddQuantity (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|C>ADD-QTY id account amount))
        (with-read DPMF|BalanceTable (concat [id BAR account])
            { "unit" := unit }
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (current-nonce-balance:decimal (UR_AccountNonceBalance id nonce account))
                    (current-nonce-meta-data:[object] (UR_AccountNonceMetaData id nonce account))
                    (updated-balance:decimal (+ current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object{DemiourgosPactMetaFungibleV4.DPMF|Schema} (UDC_Compose nonce current-nonce-balance current-nonce-meta-data))
                    (updated-meta-fungible:object{DemiourgosPactMetaFungibleV4.DPMF|Schema} (UDC_Compose nonce updated-balance current-nonce-meta-data))
                    (processed-unit:[object{DemiourgosPactMetaFungibleV4.DPMF|Schema}] (ref-U|LST::UC_ReplaceItem unit meta-fungible-to-be-replaced updated-meta-fungible))
                )
                (update DPMF|BalanceTable (concat [id BAR account])
                    {"unit" : processed-unit}
                )
            )
        )
        (XI_UpdateSupply id amount true)
    )
    (defun XI_Burn (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|C>BURN id account amount))
        (XI_DebitStandard id nonce account amount)
        (XI_UpdateSupply id amount false)
    )
    (defun XI_ChangeOwnership (id:string new-owner:string)
        (require-capability (DPMF|S>RT_OWN id new-owner))
        (update DPMF|PropertiesTable id
            {"owner-konto"                      : new-owner}
        )
    )
    (defun XI_Control
        (
            id:string
            can-change-owner:bool
            can-upgrade:bool
            can-add-special-role:bool
            can-freeze:bool
            can-wipe:bool
            can-pause:bool
            can-transfer-nft-create-role:bool
        )
        (require-capability (DPMF|S>CTRL id))
        (update DPMF|PropertiesTable id
            {"can-change-owner"             : can-change-owner
            ,"can-upgrade"                  : can-upgrade
            ,"can-add-special-role"         : can-add-special-role
            ,"can-freeze"                   : can-freeze
            ,"can-wipe"                     : can-wipe
            ,"can-pause"                    : can-pause
            ,"can-transfer-nft-create-role" : can-transfer-nft-create-role}
        )
    )
    (defun XI_Create:integer (id:string account:string meta-data:[object])
        (require-capability (DPMF|C>CREATE id account))
        (let
            (
                (new-nonce:integer (+ (UR_NoncesUsed id) 1))
                (create-role-account:string (UR_CreateRoleAccount id))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF|BalanceTable (concat [id BAR account])
                {"exist"                    : true
                ,"unit"                     : [DPMF|NEUTRAL]
                ,"role-nft-add-quantity"    : false
                ,"role-nft-burn"            : false
                ,"role-nft-create"          : role-nft-create-boolean
                ,"role-transfer"            : false
                ,"frozen"                   : false}
                {"exist"                    := e
                ,"unit"                     := u
                ,"role-nft-add-quantity"    := rnaq
                ,"role-nft-burn"            := rb
                ,"role-nft-create"          := rnc
                ,"role-transfer"            := rt
                ,"frozen"                   := f}
                (let
                    (
                        (ref-U|LST:module{StringProcessor} U|LST)
                        (new-nonce:integer (+ (UR_NoncesUsed id) 1))
                        (meta-fungible:object{DemiourgosPactMetaFungibleV4.DPMF|Schema} (UDC_Compose new-nonce 0.0 meta-data))
                        (appended-meta-fungible:[object{DemiourgosPactMetaFungibleV4.DPMF|Schema}] (ref-U|LST::UC_AppL u meta-fungible))
                    )
                    (write DPMF|BalanceTable (concat [id BAR account])
                        {"exist"                    : e
                        ,"unit"                     : appended-meta-fungible
                        ,"role-nft-add-quantity"    : rnaq
                        ,"role-nft-burn"            : rb
                        ,"role-nft-create"          : rnc
                        ,"role-transfer"            : rt
                        ,"frozen"                   : f}
                    )
                    (XI_IncrementNonce id)
                    new-nonce
                )
            )
        )
    )
    (defun XI_Credit (id:string nonce:integer meta-data:[object] account:string amount:decimal)
        (require-capability (SECURE))
        (let
            (
                (create-role-account:string (UR_CreateRoleAccount id))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF|BalanceTable (concat [id BAR account])
                {"exist"                    : true
                ,"unit"                     : [DPMF|NEGATIVE]
                ,"role-nft-add-quantity"    : false
                ,"role-nft-burn"            : false
                ,"role-nft-create"          : role-nft-create-boolean
                ,"role-transfer"            : false
                ,"frozen"                   : false}
                { "unit"                    := unit
                ,"role-nft-add-quantity"    := rnaq
                ,"role-nft-burn"            := rb
                ,"role-nft-create"          := rnc
                ,"role-transfer"            := rt
                ,"frozen"                   := f}
                (let
                    (
                        (ref-U|LST:module{StringProcessor} U|LST)
                        (next-unit:[object] (if (= unit [DPMF|NEGATIVE]) [DPMF|NEUTRAL] unit))
                        (is-new:bool (if (= unit [DPMF|NEGATIVE]) true false))
                        (current-nonce-balance:decimal (UR_AccountNonceBalance id nonce account))
                        (credited-balance:decimal (+ current-nonce-balance amount))
                        (present-meta-fungible:object{DemiourgosPactMetaFungibleV4.DPMF|Schema} (UDC_Compose nonce current-nonce-balance meta-data))
                        (credited-meta-fungible:object{DemiourgosPactMetaFungibleV4.DPMF|Schema} (UDC_Compose nonce credited-balance meta-data))
                        (processed-unit-with-replace:[object{DemiourgosPactMetaFungibleV4.DPMF|Schema}] (ref-U|LST::UC_ReplaceItem next-unit present-meta-fungible credited-meta-fungible))
                        (processed-unit-with-append:[object{DemiourgosPactMetaFungibleV4.DPMF|Schema}] (ref-U|LST::UC_AppL next-unit credited-meta-fungible))
                    )
                    (if (= current-nonce-balance 0.0)
                        (write DPMF|BalanceTable (concat [id BAR account])
                            {"exist"                    : true
                            ,"unit"                     : processed-unit-with-append
                            ,"role-nft-add-quantity"    : (if is-new false rnaq)
                            ,"role-nft-burn"            : (if is-new false rb)
                            ,"role-nft-create"          : (if is-new role-nft-create-boolean rnc)
                            ,"role-transfer"            : (if is-new false rt)
                            ,"frozen"                   : (if is-new false f)}
                        )
                        (write DPMF|BalanceTable (concat [id BAR account])
                            {"exist"                    : true
                            ,"unit"                     : processed-unit-with-replace
                            ,"role-nft-add-quantity"    : (if is-new false rnaq)
                            ,"role-nft-burn"            : (if is-new false rb)
                            ,"role-nft-create"          : (if is-new role-nft-create-boolean rnc)
                            ,"role-transfer"            : (if is-new false rt)
                            ,"frozen"                   : (if is-new false f)}
                        )
                    )
                )
            )
        )
    )
    (defun XI_DebitAdmin (id:string nonce:integer account:string amount:decimal)
        (require-capability (SECURE))
        (CAP_Owner id)
        (XI_DebitPure id nonce account amount)
    )
    (defun XI_DebitMultiple (id:string nonce-lst:[integer] account:string balance-lst:[decimal])
        (let
            (
                (nonce-balance-obj-lst:[object{DemiourgosPactMetaFungibleV4.DPMF|Nonce-Balance}] (UDC_Nonce-Balance nonce-lst balance-lst))
            )
            (map (lambda (x:object{DemiourgosPactMetaFungibleV4.DPMF|Nonce-Balance}) (XI_DebitPaired id account x)) nonce-balance-obj-lst)
        )
    )
    (defun XI_DebitPaired (id:string account:string nonce-balance-obj:object{DemiourgosPactMetaFungibleV4.DPMF|Nonce-Balance})
        (let
            (
                (nonce:integer (at "nonce" nonce-balance-obj))
                (balance:decimal (at "balance" nonce-balance-obj))
            )
            (XI_DebitAdmin id nonce account balance)
        )
    )
    (defun XI_DebitPure (id:string nonce:integer account:string amount:decimal)
        (require-capability (SECURE))
        (with-read DPMF|BalanceTable (concat [id BAR account])
            {"exist"                    := e
            ,"unit"                     := unit
            ,"role-nft-add-quantity"    := rnaq
            ,"role-nft-burn"            := rnb
            ,"role-nft-create"          := rnc
            ,"role-transfer"            := rt
            ,"frozen"                   := f}
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (current-nonce-balance:decimal (UR_AccountNonceBalance id nonce account))
                    (current-nonce-meta-data (UR_AccountNonceMetaData id nonce account))
                    (debited-balance:decimal (- current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object{DemiourgosPactMetaFungibleV4.DPMF|Schema} (UDC_Compose nonce current-nonce-balance current-nonce-meta-data))
                    (debited-meta-fungible:object{DemiourgosPactMetaFungibleV4.DPMF|Schema} (UDC_Compose nonce debited-balance current-nonce-meta-data))
                    (processed-unit-with-remove:[object{DemiourgosPactMetaFungibleV4.DPMF|Schema}] (ref-U|LST::UC_RemoveItem unit meta-fungible-to-be-replaced))
                    (processed-unit-with-replace:[object{DemiourgosPactMetaFungibleV4.DPMF|Schema}] (ref-U|LST::UC_ReplaceItem unit meta-fungible-to-be-replaced debited-meta-fungible))
                )
                (enforce (>= debited-balance 0.0) "Insufficient Funds for debiting")
                (if (= debited-balance 0.0)
                    (update DPMF|BalanceTable (concat [id BAR account])
                        {"exist"                    : e
                        ,"unit"                     : processed-unit-with-remove
                        ,"role-nft-add-quantity"    : rnaq
                        ,"role-nft-burn"            : rnb
                        ,"role-nft-create"          : rnc
                        ,"role-transfer"            : rt
                        ,"frozen"                   : f}
                    )
                    (update DPMF|BalanceTable (concat [id BAR account])
                        {"exist"                    : e
                        ,"unit"                     : processed-unit-with-replace
                        ,"role-nft-add-quantity"    : rnaq
                        ,"role-nft-burn"            : rnb
                        ,"role-nft-create"          : rnc
                        ,"role-transfer"            : rt
                        ,"frozen"                   : f}
                    )
                )
            )
        )
    )
    (defun XI_DebitStandard (id:string nonce:integer account:string amount:decimal)
        (require-capability (SECURE))
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (XI_DebitPure id nonce account amount)
        )
    )
    (defun XI_IncrementNonce (id:string)
        (require-capability (SECURE))
        (with-read DPMF|PropertiesTable id
            { "nonces-used" := nu }
            (update DPMF|PropertiesTable id { "nonces-used" : (+ nu 1)})
        )
    )
    (defun XI_Issue:string
        (
            account:string
            name:string
            ticker:string
            decimals:integer
            can-change-owner:bool
            can-upgrade:bool
            can-add-special-role:bool
            can-freeze:bool
            can-wipe:bool
            can-pause:bool
            can-transfer-nft-create-role:bool
            iz-special:bool
        )
        (require-capability (SECURE))
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (id:string (ref-U|DALOS::UDC_Makeid ticker))
            )
            (ref-U|DALOS::UEV_Decimals decimals)
            (ref-U|DALOS::UEV_NameOrTicker name true iz-special)
            (ref-U|DALOS::UEV_NameOrTicker ticker false iz-special)
            (insert DPMF|PropertiesTable id
                {"owner-konto"          : account
                ,"name"                 : name
                ,"ticker"               : ticker
                ,"decimals"             : decimals
                ,"can-change-owner"     : can-change-owner
                ,"can-upgrade"          : can-upgrade
                ,"can-add-special-role" : can-add-special-role
                ,"can-freeze"           : can-freeze
                ,"can-wipe"             : can-wipe
                ,"can-pause"            : can-pause
                ,"is-paused"            : false
                ,"can-transfer-nft-create-role" : can-transfer-nft-create-role
                ,"supply"               : 0.0
                ,"create-role-account"  : account
                ,"role-transfer-amount" : 0
                ,"nonces-used"          : 0
                ,"reward-bearing-token" : BAR
                ,"vesting-link"         : BAR
                ,"sleeping-link"        : BAR}
            )
            (C_DeployAccount id account)
            id
        )
    )
    (defun XI_Mint:integer (id:string account:string amount:decimal meta-data:[object])
        (require-capability (DPMF|C>MINT id account amount))
        (let
            (
                (new-nonce:integer (+ (UR_NoncesUsed id) 1))

            )
            (XI_Create id account meta-data)
            (XI_AddQuantity id new-nonce account amount)
            new-nonce
        )
    )
    (defun XI_ToggleFreezeAccount (id:string account:string toggle:bool)
        (require-capability (DPMF|S>X_FRZ-ACC id account toggle))
        (update DPMF|BalanceTable (concat [id BAR account])
            { "frozen" : toggle}
        )
    )
    (defun XI_TogglePause (id:string toggle:bool)
        (require-capability (DPMF|S>TG_PAUSE id toggle))
        (update DPMF|PropertiesTable id
            { "is-paused" : toggle}
        )
    )
    (defun XI_ToggleTransferRole (id:string account:string toggle:bool)
        (require-capability (DPMF|S>X_TG_TRANSFER-R id account toggle))
        (update DPMF|BalanceTable (concat [id BAR account])
            {"role-transfer" : toggle}
        )
    )
    (defun XI_Transfer (id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)
        (require-capability (DPMF|C>TRANSFER id sender receiver transfer-amount method))
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (current-nonce-meta-data (UR_AccountNonceMetaData id nonce sender))
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
            )
            (XI_DebitStandard id nonce sender transfer-amount)
            (XI_Credit id nonce current-nonce-meta-data receiver transfer-amount)
            (XB_UpdateElite id sender receiver)
        )
    )
    (defun XI_UpdateRoleTransferAmount (id:string direction:bool)
        (require-capability (SECURE))
        (if (= direction true)
            (with-read DPMF|PropertiesTable id
                { "role-transfer-amount" := rta }
                (update DPMF|PropertiesTable id
                    {"role-transfer-amount" : (+ rta 1)}
                )
            )
            (with-read DPMF|PropertiesTable id
                { "role-transfer-amount" := rta }
                (update DPMF|PropertiesTable id
                    {"role-transfer-amount" : (- rta 1)}
                )
            )
        )
    )
    (defun XI_UpdateVesting (dptf:string dpmf:string)
        (require-capability (SECURE))
        (update DPMF|PropertiesTable dpmf
            {"vesting-link" : dptf}
        )
    )
    (defun XI_UpdateSleeping (dptf:string dpmf:string)
        (require-capability (SECURE))
        (update DPMF|PropertiesTable dpmf
            {"sleeping-link" : dptf}
        )
    )
    (defun XI_UpdateSupply (id:string amount:decimal direction:bool)
        (require-capability (SECURE))
        (UEV_Amount id amount)
        (if (= direction true)
            (with-read DPMF|PropertiesTable id
                { "supply" := s }
                (enforce (>= (+ s amount) 0.0) "DPMF Token Supply cannot be updated to negative values!")
                (update DPMF|PropertiesTable id { "supply" : (+ s amount)})
            )
            (with-read DPMF|PropertiesTable id
                { "supply" := s }
                (enforce (>= (- s amount) 0.0) "DPMF Token Supply cannot be updated to negative values!")
                (update DPMF|PropertiesTable id { "supply" : (- s amount)})
            )
        )
    )
    (defun XI_Wipe (id:string account-to-be-wiped:string)
        (require-capability (DPMF|C>TOTAL-WIPE id account-to-be-wiped))
        (let
            (
                (nonce-lst:[integer] (UR_AccountNonces id account-to-be-wiped))
                (balance-lst:[decimal] (UR_AccountBalances id account-to-be-wiped))
                (sum:decimal (fold (+) 0.0 balance-lst))
            )
            (XI_DebitMultiple id nonce-lst account-to-be-wiped balance-lst)
            (XI_UpdateSupply id sum false)
        )
    )
    (defun XI_WipePartial (id:string account-to-be-wiped:string nonces:[integer])
        (require-capability (DPMF|C>PARTIAL-WIPE id account-to-be-wiped nonces))
        (let
            (
                (balances:[decimal] (UR_AccountNoncesBalances id nonces account-to-be-wiped))
                (sum:decimal (fold (+) 0.0 balances))
            )
            (XI_DebitMultiple id nonces account-to-be-wiped balances)
            (XI_UpdateSupply id sum false)
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)
(create-table DPMF|PropertiesTable)
(create-table DPMF|BalanceTable)
(create-table DPMF|RoleTable)