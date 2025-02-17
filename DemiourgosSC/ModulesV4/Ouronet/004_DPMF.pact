;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface DemiourgosPactMetaFungible
    @doc "Exposes most of the Functions of the DPMF Module. \
    \ The ATS Module contains 3 more DPTF Functions that couldnt be brought here logisticaly \
    \ UR(Utility-Read), URC(Utility-Read-Compute), UEV(Utility-Enforce-Validate) and \
    \ UDC(Utility-Data-Composition) are NOT sorted alphabetically"
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
    (defun UR_Roles:[string] (id:string rp:integer))
    (defun UR_CanTransferNFTCreateRole:bool (id:string))
    (defun UR_CreateRoleAccount:string (id:string))
    (defun UR_NoncesUsed:integer (id:string))
    (defun UR_RewardBearingToken:string (id:string))
    (defun UR_AccountSupply:decimal (id:string account:string))
    (defun UR_AccountRoleBurn:bool (id:string account:string))
    (defun UR_AccountRoleTransfer:bool (id:string account:string))
    (defun UR_AccountFrozenState:bool (id:string account:string))
    (defun UR_AccountUnit:[object] (id:string account:string))
    (defun UR_AccountBalances:[decimal] (id:string account:string))
    (defun UR_AccountBatchMetaData (id:string nonce:integer account:string))
    (defun UR_AccountBatchSupply:decimal (id:string nonce:integer account:string))
    (defun UR_AccountNonces:[integer] (id:string account:string))
    (defun UR_AccountRoleNFTAQ:bool (id:string account:string))
    (defun UR_AccountRoleCreate:bool (id:string account:string))
    ;;
    (defun URC_IzRBT:bool (reward-bearing-token:string))
    (defun URC_IzRBTg:bool (atspair:string reward-bearing-token:string))
    (defun URC_EliteAurynzSupply (account:string))
    (defun URC_AccountExist:bool (id:string account:string))
    (defun URC_HasVesting:bool (id:string))
    ;;
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
    (defun UEV_Amount (id:string amount:decimal))
    (defun UEV_CheckID:bool (id:string))
    (defun UEV_id (id:string))
    (defun UEV_CanTransferNFTCreateRoleON (id:string))
    (defun UEV_AccountAddQuantityState (id:string account:string state:bool))
    (defun UEV_AccountCreateState (id:string account:string state:bool))
    (defun UEV_Vesting (id:string existance:bool))
    ;;
    (defun UDC_Compose:object{DPMF|Schema} (nonce:integer balance:decimal meta-data:[object]))
    (defun UDC_Nonce-Balance:[object{DPMF|Nonce-Balance}] (nonce-lst:[integer] balance-lst:[decimal]))
    ;;
    (defun CAP_Owner (id:string))
    ;;
    (defun C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun C_UpgradeBranding (patron:string entity-id:string months:integer))
    ;;
    (defun C_AddQuantity:object{OuronetDalos.IgnisCumulator} (patron:string id:string nonce:integer account:string amount:decimal))
    (defun C_Burn:object{OuronetDalos.IgnisCumulator} (patron:string id:string nonce:integer account:string amount:decimal))
    (defun C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool))
    (defun C_Create:object{OuronetDalos.IgnisCumulator} (patron:string id:string account:string meta-data:[object]))
    (defun C_DeployAccount (id:string account:string))
    (defun C_Issue:object{OuronetDalos.IgnisCumulator} (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool]))
    (defun C_Mint:object{OuronetDalos.IgnisCumulator} (patron:string id:string account:string amount:decimal meta-data:[object]))
    (defun C_MultiBatchTransfer:[object{OuronetDalos.IgnisCumulator}] (patron:string id:string nonces:[integer] sender:string receiver:string method:bool))
    (defun C_RotateOwnership (patron:string id:string new-owner:string))
    (defun C_SingleBatchTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string nonce:integer sender:string receiver:string method:bool))
    (defun C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool))
    (defun C_TogglePause (patron:string id:string toggle:bool))
    (defun C_ToggleTransferRole:object{OuronetDalos.IgnisCumulator} (patron:string id:string account:string toggle:bool))
    (defun C_Transfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)) ;;6
    (defun C_Wipe (patron:string id:string atbw:string))
    ;;
    (defun XB_IssueFree:object{OuronetDalos.IgnisCumulator} (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])) ;;1
    (defun XB_UpdateElite (id:string sender:string receiver:string))
    (defun XB_WriteRoles (id:string account:string rp:integer d:bool))
    ;;
    (defun XE_MoveCreateRole (id:string receiver:string))
    (defun XE_ToggleAddQuantityRole (id:string account:string toggle:bool))
    (defun XE_ToggleBurnRole (id:string account:string toggle:bool))
    (defun XE_UpdateRewardBearingToken (atspair:string id:string))
    (defun XE_UpdateVesting (dptf:string dpmf:string))
)
(module DPMF GOV
    ;;
    (implements OuronetPolicy)
    (implements BrandingUsage)
    (implements DemiourgosPactMetaFungible)
    ;;{G1}
    (defconst GOV|MD_DPMF           (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|DPMF_ADMIN)))
    (defcap GOV|DPMF_ADMIN ()       (enforce-guard GOV|MD_DPMF))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S}) 
    ;;{P3}
    (defcap P|DPMF|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPMF|CALLER))
        (compose-capability (SECURE))
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|DPMF_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        (let
            (
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
            )
            (ref-P|DALOS::P|A_Add 
                "DPMF|<"
                (create-capability-guard (P|DPMF|CALLER))
            )
            (ref-P|BRD::P|A_Add 
                "DPMF|<"
                (create-capability-guard (P|DPMF|CALLER))
            )
            (ref-P|DPTF::P|A_Add
                "DPMF|<"
                (create-capability-guard (P|DPMF|CALLER))
            )
        )
    )
    ;;
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
        vesting:string
    )
    (defschema DPMF|BalanceSchema
        @doc "Key = <DPMF id> + BAR + <account>"
        unit:[object{DemiourgosPactMetaFungible.DPMF|Schema}]
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
        { "nonce": 0
        , "balance": 0.0
        , "meta-data": [{}] }
    )
    (defconst DPMF|NEGATIVE
        { "nonce": -1
        , "balance": -1.0
        , "meta-data": [{}] }
    )
    ;;
    ;;{C1}
    (defcap SECURE ()
        true
    )
    (defcap DPMF|CREDIT ()
        true
    )
    (defcap DPMF|DEBIT ()
        true
    )
    (defcap DPMF|DEBIT_PUR ()
        true
    )
    (defcap DPMF|INCR_NONCE ()
        true
    )
    (defcap DPMF|UPRL-TA ()
        true
    )
    (defcap DPMF|UP_SPLY () 
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
                (ref-DALOS:module{OuronetDalos} DALOS)
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
    (defcap DPMF|S>X_TG_TRANSFER-R (id:string account:string toggle:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
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
                (ref-DALOS:module{OuronetDalos} DALOS)
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
    (defcap DPMF|C>UPDATE-BRD (id:string)
        @event
        (CAP_Owner id)
        (compose-capability (P|DPMF|CALLER))
    )
    (defcap DPMF|C>UPGRADE-BRD (id:string)
        @event
        (compose-capability (P|DPMF|CALLER))
    )
    (defcap BASIS|C>X_WRITE-ROLES (id:string account:string rp:integer)
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-DALOS:module{OuronetDalos} DALOS)
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
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership client)
            (UEV_Amount id amount)
            (UEV_AccountBurnState id client true)
            (compose-capability (SECURE))
        )
    )
    (defcap DPMF|FC>FRZ-ACC (id:string account:string frozen:bool)
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
                (ref-DALOS:module{OuronetDalos} DALOS)
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
    (defcap DPMF|C>WIPE (id:string account-to-be-wiped:string)
        @event
        (UEV_CanWipeON id)
        (UEV_AccountFreezeState id account-to-be-wiped true)
        (compose-capability (SECURE))
    )
    (defcap DPMF|C>ADD-QTY (id:string client:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
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
                (ref-DALOS:module{OuronetDalos} DALOS)
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
                (ref-DALOS:module{OuronetDalos} DALOS)
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
    ;;
    ;;{F0}
    (defun UR_P-KEYS:[string] ()
        (keys DPMF|PropertiesTable)
    )
    (defun UR_KEYS:[string] ()
        (keys DPMF|BalanceTable)
    )
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
        (at "vesting" (read DPMF|PropertiesTable id ["vesting"]))
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
        (with-default-read DPMF|BalanceTable (concat [id BAR  account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let 
                (
                    (result 
                        (fold
                            (lambda 
                                (acc:decimal item:object{DemiourgosPactMetaFungible.DPMF|Schema})
                                (+ acc (at "balance" item))
                            )
                            0.0
                            read-unit
                        )
                    )
                )
                result
            )
        )
    )
    (defun UR_AccountRoleBurn:bool (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "role-nft-burn" : false}
            { "role-nft-burn" := rb }
            rb
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
    (defun UR_AccountUnit:[object] (id:string account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "unit" : DPMF|NEGATIVE}
            { "unit" := u }
            u
        )
    )
    (defun UR_AccountBalances:[decimal] (id:string account:string)
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
                            (acc:[decimal] item:object{DemiourgosPactMetaFungible.DPMF|Schema})
                            (if (!= (at "balance" item) 0.0)
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
    (defun UR_AccountBatchMetaData (id:string nonce:integer account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (fold
                (lambda 
                    (acc item:object{DemiourgosPactMetaFungible.DPMF|Schema})
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
    (defun UR_AccountBatchSupply:decimal (id:string nonce:integer account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (fold
                (lambda 
                    (acc:decimal item:object{DemiourgosPactMetaFungible.DPMF|Schema})
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
    (defun UR_AccountNonces:[integer] (id:string account:string)
        (UEV_id id false)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let 
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                )
                (fold
                    (lambda 
                        (acc:[integer] item:object{DemiourgosPactMetaFungible.DPMF|Schema})
                        (if (!= (at "nonce" item) 0)
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
    (defun UR_AccountRoleNFTAQ:bool (id:string account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "role-nft-add-quantity" : false}
            { "role-nft-add-quantity" := rnaq }
            rnaq
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
    ;;{F1}
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
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
            )
            (if (!= ea-id BAR)
                (let
                    (
                        (ea-supply:decimal (ref-DPTF::UR_AccountSupply ea-id account))
                        (vea:string (ref-DPTF::UR_Vesting ea-id))
                    )
                    (if (!= vea BAR)
                        (+ ea-supply (UR_AccountSupply vea account))
                        ea-supply
                    )
                )
                true
            )
        )
    )
    (defun URC_AccountExist:bool (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "unit" : [DPMF|NEGATIVE] }
            { "unit" := u}
            (if (= u [DPMF|NEGATIVE])
                false
                true
            )
        )
    )
    (defun URC_HasVesting:bool (id:string)
        @doc "Returns a boolean if DPMF has a vesting counterpart"
        (if (= (UR_Vesting id) BAR)
            false
            true
        )
    )
    ;;{F2}
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
    ;;{F3}
    (defun UDC_Compose:object{DemiourgosPactMetaFungible.DPMF|Schema} (nonce:integer balance:decimal meta-data:[object])
        @doc "Composes a DPMF Object"
        {"nonce" : nonce, "balance": balance, "meta-data" : meta-data}
    )
    (defun UDC_Nonce-Balance:[object{DemiourgosPactMetaFungible.DPMF|Nonce-Balance}] (nonce-lst:[integer] balance-lst:[decimal])
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
    ;;{F4}
    (defun CAP_Owner (id:string)
        @doc "Enforces DPMF Token ID Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (UR_Konto id))
        )
    )
    ;;
    ;;{F5}
    ;;{F6}
    (defun C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-BRD:module{Branding} BRD)
                (owner:string (UR_Konto entity-id))
                (branding-cost:decimal (ref-DALOS::UR_UsagePrice "ignis|branding"))
                (final-cost:decimal (* 1.5 branding-cost))
            )
            (with-capability (DPMF|C>UPDATE-BRD)
                (ref-BRD::XE_UpdatePendingBranding entity-id logo description website social)
                (ref-DALOS::IGNIS|C_Collect patron owner final-cost)
            )
        )
    )
    (defun C_UpgradeBranding (patron:string entity-id:string months:integer)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-BRD:module{Branding} BRD)
                (owner:string (UR_Konto entity-id))
                (kda-payment:decimal
                    (with-capability (DPMF|C>UPGRADE-BRD)
                        (ref-BRD::XE_UpgradeBranding entity-id owner months)
                    )
                )
            )
            (ref-DALOS::KDA|C_CollectWT patron kda-payment false)
        )
    )
    ;;
    (defun C_AddQuantity:object{OuronetDalos.IgnisCumulator} (patron:string id:string nonce:integer account:string amount:decimal)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (trigger:bool (ref-DALOS::IGNIS|URC_ZeroGAS id account))
            )
            (with-capability (DPMF|C>ADD-QTY id account amount)
                (XI_AddQuantity id nonce account amount)
                (ref-DALOS::UDC_Cumulator price trigger [])
            )
        )
    )
    (defun C_Burn:object{OuronetDalos.IgnisCumulator} (patron:string id:string nonce:integer account:string amount:decimal)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (P|UR "ATSU|<"))
                (enforce-guard (P|UR "VST|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (trigger:bool (ref-DALOS::IGNIS|URC_ZeroGAS id account))
            )
            (with-capability (DPMF|C>BURN id account amount)
                (XI_Burn id nonce account amount)
                (ref-DALOS::UDC_Cumulator price trigger [])
            )
        )
    )
    (defun C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|S>CTRL id)
                (XI_Control patron id cco cu casr cf cw cp ctncr)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_Create:object{OuronetDalos.IgnisCumulator} (patron:string id:string account:string meta-data:[object])
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|medium"))
                (trigger:bool (ref-DALOS::IGNIS|URC_ZeroGAS id account))
                (new-nonce:integer
                    (with-capability (DPMF|C>CREATE id account)
                        (XI_Create id account meta-data)
                    )
                )
            )
            (ref-DALOS::UDC_Cumulator price trigger [new-nonce])
        )
    )
    (defun C_DeployAccount (id:string account:string)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (P|UR "ATSU|<"))
                (enforce-guard (P|UR "VST|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (create-role-account:string (UR_CreateRoleAccount id))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id)
            (with-default-read DPMF|BalanceTable (concat [id BAR account])
                { "unit" : [DPMF|NEUTRAL]
                , "role-nft-add-quantity"           : false
                , "role-nft-burn"                   : false
                , "role-nft-create"                 : role-nft-create-boolean
                , "role-transfer"                   : false
                , "frozen"                          : false}
                { "unit"                            := u
                , "role-nft-add-quantity"           := rnaq
                , "role-nft-burn"                   := rb
                , "role-nft-create"                 := rnc
                , "role-transfer"                   := rt
                , "frozen"                          := f }
                (write DPMF|BalanceTable (concat [id BAR account])
                    { "unit"                        : u
                    , "role-nft-add-quantity"       : rnaq
                    , "role-nft-burn"               : rb
                    , "role-nft-create"             : rnc
                    , "role-transfer"               : rt
                    , "frozen"                      : f}
                )
            )
        )
    )
    (defun C_Issue:object{OuronetDalos.IgnisCumulator} (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (l1:integer (length name))
                (mf-cost:decimal (ref-DALOS::UR_UsagePrice "dpmf"))
                (kda-costs:decimal (* (dec l1) mf-cost))
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (SECURE)
                        (XB_IssueFree patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role)
                    )
                )
            )
            (ref-DALOS::KDA|C_Collect patron kda-costs)
            ico
        )
    )
    (defun C_Mint:object{OuronetDalos.IgnisCumulator} (patron:string id:string account:string amount:decimal meta-data:[object])
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (P|UR "ATSU|<"))
                (enforce-guard (P|UR "VST|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (new-nonce:integer
                    (with-capability (DPMF|C>MINT id account amount)
                        (XI_Mint id account amount meta-data)
                    )
                )
                (medium:decimal (ref-DALOS::UR_UsagePrice "ignis|medium"))
                (small:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (price:decimal (+ medium small))
                (trigger:bool (ref-DALOS::IGNIS|URC_ZeroGAS id account))
            )
            (ref-DALOS::UDC_Cumulator price trigger [new-nonce])
        )
    )
    (defcap DPMF|S>MULTI-BATCH-TRANSFER (id:string nonces:[integer] sender:string)
        @event
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (account-nonces:[integer] (UR_AccountNonces id sender))
                (contains-all:bool (ref-U|INT::UEV_ContainsAll account-nonces nonces))
            )
            (enforce contains-all "Invalid Nonce List for DPTF Multi Batch Transfer")
        )
    )
    (defun C_MultiBatchTransfer:[object{OuronetDalos.IgnisCumulator}] (patron:string id:string nonces:[integer] sender:string receiver:string method:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (DPMF|S>MULTI-BATCH-TRANSFER id nonces sender)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                )
                (fold
                    (lambda
                        (acc:[object{OuronetDalos.IgnisCumulator}] idx:integer)
                        (ref-U|LST::UC_AppL 
                            acc 
                            (C_SingleBatchTransfer patron id (at idx nonces) sender receiver method)
                        )
                    )
                    []
                    (enumerate 0 (- (length nonces) 1))
                )
            )
        )
    )
    (defun C_RotateOwnership (patron:string id:string new-owner:string)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|S>RT_OWN id new-owner)
                (XI_ChangeOwnership id new-owner)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|biggest"))
            )
        )
    )
    (defun C_SingleBatchTransfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string nonce:integer sender:string receiver:string method:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (C_Transfer patron id nonce sender receiver (UR_AccountBatchSupply id nonce) method)
    )
    (defun C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|FC>FRZ-ACC id account toggle)
                (XI_ToggleFreezeAccount id account toggle)
                (XB_WriteRoles id account 5 toggle)
                (ref-DALOS::IGNIS|C_Collect patron account (ref-DALOS::UR_UsagePrice "ignis|big"))
            )
        )
    )
    (defun C_TogglePause (patron:string id:string toggle:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|S>TG_PAUSE id toggle)
                (XI_TogglePause id toggle)
                (ref-DALOS::IGNIS|C_Collect patron patron (ref-DALOS::UR_UsagePrice "ignis|medium"))
            )
        )
    )
    (defun C_ToggleTransferRole:object{OuronetDalos.IgnisCumulator} (patron:string id:string account:string toggle:bool)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (P|UR "VST|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (small:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (price:decimal (* 3.0 small))
                (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
            )
            (with-capability (DPMF|C>TG_TRANSFER-R id account toggle)
                (XI_ToggleTransferRole id account toggle)
                (XI_UpdateRoleTransferAmount id toggle)
                (XB_WriteRoles id account 4 toggle)
                (ref-DALOS::UDC_Cumulator price trigger [])
            )
        )
    )
    (defun C_Transfer:object{OuronetDalos.IgnisCumulator} (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (P|UR "ATSU|<"))
                (enforce-guard (P|UR "VST|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (trigger:bool (ref-DALOS::GNIS|URC_ZeroGAZ id sender receiver))
            )
            (with-capability (DPMF|C>TRANSFER id sender receiver transfer-amount method)
                (XI_Transfer id nonce sender receiver transfer-amount method)
                (ref-DALOS::UDC_Cumulator price trigger [])
            )
        )
    )
    (defun C_Wipe (patron:string id:string atbw:string)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|C>WIPE id atbw)
                (XI_Wipe id atbw)
                (ref-DALOS::IGNIS|C_CollectWT patron atbw (ref-DALOS::UR_UsagePrice "ignis|biggest") (ref-DALOS::IGNIS|URC_ZeroGAS id atbw))
            )
        )
    )
    ;;{F7}
    (defun XB_IssueFree:object{OuronetDalos.IgnisCumulator}
        (
            patron:string
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
        )
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "VST|<"))
            ]
        )
        (with-capability (DPMF|C>ISSUE account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-BRD:module{Branding} BRD)
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (l1:integer (length name))
                    (gas-costs:decimal (* (dec l1) (ref-DALOS::UR_UsagePrice "ignis|token-issue")))
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
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
                (ref-DALOS::UDC_Cumulator gas-costs trigger folded-lst)
            )
        ) 
    )
    (defun XB_UpdateElite (id:string sender:string receiver:string)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "TFT|<"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
            )
            (if (!= ea-id BAR)
                (with-capability (P|DPMF|CALLER)
                    (if (= id ea-id)
                        (do
                            (ref-DALOS::XE_UpdateElite sender (URC_EliteAurynzSupply sender))
                            (ref-DALOS::XE_UpdateElite receiver (URC_EliteAurynzSupply receiver))
                        )
                        (let
                            (
                                (v-ea-id:string (ref-DPTF::UR_Vesting ea-id))
                            )
                            (if (and (!= v-ea-id BAR)(= id v-ea-id))
                                (do
                                    (ref-DALOS::XE_UpdateElite sender (URC_EliteAurynzSupply sender))
                                    (ref-DALOS::XE_UpdateElite receiver (URC_EliteAurynzSupply receiver))
                                )
                                true
                            )
                        )
                    )
                )
                true
            )
        )
    )
    (defun XB_WriteRoles (id:string account:string rp:integer d:bool)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "ATS|<"))
            ]
        )
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
            )
            (with-capability (BASIS|C>X_WRITE-ROLES id account rp)
                (with-default-read DPMF|RoleTable id
                    { "r-nft-burn"          : [BAR]
                    , "r-nft-create"        : [BAR]
                    , "r-nft-add-quantity"  : [BAR]
                    , "r-transfer"          : [BAR]
                    , "a-frozen"            : [BAR]}
                    { "r-nft-burn"          := rb
                    , "r-nft-create"        := rnc
                    , "r-nft-add-quantity"  := rnaq
                    , "r-transfer"          := rt
                    , "a-frozen"            := af}
                    (if (= rp 1)
                        (write DPMF|RoleTable id
                            { "r-nft-burn"          : (ref-U|DALOS::UC_NewRoleList rb account d)
                            , "r-nft-create"        : rnc
                            , "r-nft-add-quantity"  : rnaq
                            , "r-transfer"          : rt
                            , "a-frozen"            : af}
                        )
                        (if (= rp 2)
                            (write DPMF|RoleTable id
                                { "r-nft-burn"          : rb
                                , "r-nft-create"        : (ref-U|DALOS::UC_NewRoleList rnc account d)
                                , "r-nft-add-quantity"  : rnaq
                                , "r-transfer"          : rt
                                , "a-frozen"            : af}
                            )
                            (if (= rp 3)
                                (write DPMF|RoleTable id
                                    { "r-nft-burn"          : rb
                                    , "r-nft-create"        : rnc
                                    , "r-nft-add-quantity"  : (ref-U|DALOS::UC_NewRoleList rnaq account d)
                                    , "r-transfer"          : rt
                                    , "a-frozen"            : af}
                                )
                                (if (= rp 4)
                                    (write DPMF|RoleTable id
                                        { "r-nft-burn"          : rb
                                        , "r-nft-create"        : rnc
                                        , "r-nft-add-quantity"  : rnaq
                                        , "r-transfer"          : (ref-U|DALOS::UC_NewRoleList rt account d)
                                        , "a-frozen"            : af}
                                    )
                                    (write DPMF|RoleTable id
                                        { "r-nft-burn"          : rb
                                        , "r-nft-create"        : rnc
                                        , "r-nft-add-quantity"  : rnaq
                                        , "r-transfer"          : rt
                                        , "a-frozen"            : (ref-U|DALOS::UC_NewRoleList af account d)}
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
        (enforce-guard (P|UR "ATS|<"))
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
        (enforce-guard (P|UR "ATS|<"))
        (with-capability (DPMF|S>TG_ADD-QTY-R id account toggle)
            (update DPMF|BalanceTable (concat [id BAR account])
                {"role-nft-add-quantity" : toggle}
            )
        )
    )
    (defun XE_ToggleBurnRole (id:string account:string toggle:bool)
        (enforce-guard (P|UR "ATS|<"))
        (with-capability (DPMF|S>TG_BURN-R id account toggle)
            (update DPMF|BalanceTable (concat [id BAR account])
                {"role-nft-burn" : toggle}
            )
        )
    )
    (defun XE_UpdateRewardBearingToken (atspair:string id:string)
        (enforce-guard (P|UR "ATSU|<"))
        (UEV_UpdateRewardBearingToken id)
        (update DPMF|PropertiesTable id
            {"reward-bearing-token" : atspair}
        )
    )
    (defun XE_UpdateVesting (dptf:string dpmf:string)
        (enforce-guard (P|UR "VST|<"))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|DPMF|CALLER)
                (ref-DPTF::XE_UpdateVesting dptf dpmf)
            )
            (update DPMF|PropertiesTable dpmf
                {"vesting" : dptf}
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
                    (current-nonce-balance:decimal (UR_AccountBatchSupply id nonce account))
                    (current-nonce-meta-data (UR_AccountBatchMetaData id nonce account))
                    (updated-balance:decimal (+ current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object{DemiourgosPactMetaFungible.DPMF|Schema} (UDC_Compose nonce current-nonce-balance current-nonce-meta-data))
                    (updated-meta-fungible:object{DemiourgosPactMetaFungible.DPMF|Schema} (UDC_Compose nonce updated-balance current-nonce-meta-data))
                    (processed-unit:[object{DemiourgosPactMetaFungible.DPMF|Schema}] (ref-U|LST::UC_ReplaceItem unit meta-fungible-to-be-replaced updated-meta-fungible))
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
            patron:string
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
            {"can-change-owner"                 : can-change-owner
            ,"can-upgrade"                      : can-upgrade
            ,"can-add-special-role"             : can-add-special-role
            ,"can-freeze"                       : can-freeze
            ,"can-wipe"                         : can-wipe
            ,"can-pause"                        : can-pause
            ,"can-transfer-nft-create-role"     : can-transfer-nft-create-role}
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
                { "unit" : [DPMF|NEUTRAL]
                , "role-nft-add-quantity" : false
                , "role-nft-burn" : false
                , "role-nft-create" : role-nft-create-boolean
                , "role-transfer" : false
                , "frozen" : false}
                { "unit" := u
                , "role-nft-add-quantity" := rnaq
                , "role-nft-burn" := rb
                , "role-nft-create" := rnc
                , "role-transfer" := rt
                , "frozen" := f}
                (let
                    (
                        (ref-U|LST:module{StringProcessor} U|LST)
                        (new-nonce:integer (+ (UR_NoncesUsed id) 1))
                        (meta-fungible:object{DemiourgosPactMetaFungible.DPMF|Schema} (UDC_Compose new-nonce 0.0 meta-data))
                        (appended-meta-fungible:[object{DemiourgosPactMetaFungible.DPMF|Schema}] (ref-U|LST::UC_AppL u meta-fungible))
                    )
                    (write DPMF|BalanceTable (concat [id BAR account])
                        { "unit"                        : appended-meta-fungible
                        , "role-nft-add-quantity"       : rnaq
                        , "role-nft-burn"               : rb
                        , "role-nft-create"             : rnc
                        , "role-transfer"               : rt
                        , "frozen"                      : f}
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
                { "unit" : [DPMF|NEGATIVE]
                , "role-nft-add-quantity" : false
                , "role-nft-burn" : false
                , "role-nft-create" : role-nft-create-boolean
                , "role-transfer" : false
                , "frozen" : false}
                { "unit" := unit
                , "role-nft-add-quantity" := rnaq
                , "role-nft-burn" := rb
                , "role-nft-create" := rnc
                , "role-transfer" := rt
                , "frozen" := f}
                (let
                    (
                        (ref-U|LST:module{StringProcessor} U|LST)
                        (next-unit:[object] (if (= unit [DPMF|NEGATIVE]) [DPMF|NEUTRAL] unit))
                        (is-new:bool (if (= unit [DPMF|NEGATIVE]) true false))
                        (current-nonce-balance:decimal (UR_AccountBatchSupply id nonce account))
                        (credited-balance:decimal (+ current-nonce-balance amount))
                        (present-meta-fungible:object{DemiourgosPactMetaFungible.DPMF|Schema} (UDC_Compose nonce current-nonce-balance meta-data))
                        (credited-meta-fungible:object{DemiourgosPactMetaFungible.DPMF|Schema} (UDC_Compose nonce credited-balance meta-data))
                        (processed-unit-with-replace:[object{DemiourgosPactMetaFungible.DPMF|Schema}] (ref-U|LST::UC_ReplaceItem next-unit present-meta-fungible credited-meta-fungible))
                        (processed-unit-with-append:[object{DemiourgosPactMetaFungible.DPMF|Schema}] (ref-U|LST::UC_AppL next-unit credited-meta-fungible))
                    )
                    (if (= current-nonce-balance 0.0)
                        (write DPMF|BalanceTable (concat [id BAR account])
                            { "unit"                        : processed-unit-with-append
                            , "role-nft-add-quantity"       : (if is-new false rnaq)
                            , "role-nft-burn"               : (if is-new false rb)
                            , "role-nft-create"             : (if is-new role-nft-create-boolean rnc)
                            , "role-transfer"               : (if is-new false rt)
                            , "frozen"                      : (if is-new false f)}
                        )
                        (write DPMF|BalanceTable (concat [id BAR account])
                            { "unit"                        : processed-unit-with-replace
                            , "role-nft-add-quantity"       : (if is-new false rnaq)
                            , "role-nft-burn"               : (if is-new false rb)
                            , "role-nft-create"             : (if is-new role-nft-create-boolean rnc)
                            , "role-transfer"               : (if is-new false rt)
                            , "frozen"                      : (if is-new false f)}
                        )
                    )
                )
            )
        )
    )
    (defun XI_DebitAdmin (id:string nonce:integer account:string amount:decimal)
        (require-capability (SECURE))
        (CAP_Owner id false)
        (XI_DebitPure id nonce account amount)
    )
    (defun XI_DebitMultiple (id:string nonce-lst:[integer] account:string balance-lst:[decimal])
        (let
            (
                (nonce-balance-obj-lst:[object{DemiourgosPactMetaFungible.DPMF|Nonce-Balance}] (UDC_Nonce-Balance nonce-lst balance-lst))
            )
            (map (lambda (x:object{DemiourgosPactMetaFungible.DPMF|Nonce-Balance}) (XI_DebitPaired id account x)) nonce-balance-obj-lst)
        )
    )
    (defun XI_DebitPaired (id:string account:string nonce-balance-obj:object{DemiourgosPactMetaFungible.DPMF|Nonce-Balance})
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
            {"unit"                                 := unit  
            ,"role-nft-add-quantity"                := rnaq
            ,"role-nft-burn"                        := rnb
            ,"role-nft-create"                      := rnc
            ,"role-transfer"                        := rt
            ,"frozen"                               := f}
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (current-nonce-balance:decimal (UR_AccountBatchSupply id nonce account))
                    (current-nonce-meta-data (UR_AccountBatchMetaData id nonce account))
                    (debited-balance:decimal (- current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object{DemiourgosPactMetaFungible.DPMF|Schema} (UDC_Compose nonce current-nonce-balance current-nonce-meta-data))
                    (debited-meta-fungible:object{DemiourgosPactMetaFungible.DPMF|Schema} (UDC_Compose nonce debited-balance current-nonce-meta-data))
                    (processed-unit-with-remove:[object{DemiourgosPactMetaFungible.DPMF|Schema}] (ref-U|LST::UC_RemoveItem unit meta-fungible-to-be-replaced))
                    (processed-unit-with-replace:[object{DemiourgosPactMetaFungible.DPMF|Schema}] (ref-U|LST::UC_ReplaceItem unit meta-fungible-to-be-replaced debited-meta-fungible))
                )
                (enforce (>= debited-balance 0.0) "Insufficient Funds for debiting")
                (if (= debited-balance 0.0)
                    (update DPMF|BalanceTable (concat [id BAR account])
                        {"unit"                     : processed-unit-with-remove
                        ,"role-nft-add-quantity"    : rnaq
                        ,"role-nft-burn"            : rnb
                        ,"role-nft-create"          : rnc
                        ,"role-transfer"            : rt
                        ,"frozen"                   : f}
                    )
                    (update DPMF|BalanceTable (concat [id BAR account])
                        {"unit"                     : processed-unit-with-replace
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
                (ref-DALOS:module{OuronetDalos} DALOS)
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
        )
        (require-capability (SECURE))
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                (id:string (ref-U|DALOS::UDC_Makeid ticker))
            )
            (ref-U|DALOS::UEV_Decimals decimals)
            (ref-U|DALOS::UEV_NameOrTicker name true false)
            (ref-U|DALOS::UEV_NameOrTicker ticker false false)
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
                ,"vesting"              : BAR}
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
                (ref-DALOS:module{OuronetDalos} DALOS)
                (current-nonce-meta-data (UR_AccountBatchMetaData id nonce sender))
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
        (require-capability (DPMF|C>WIPE id account-to-be-wiped))
        (let
            (
                (nonce-lst:[integer] (UR_AccountNonces id account-to-be-wiped))
                (balance-lst:[decimal] (UR_AccountBalances id account-to-be-wiped))
                (balance-sum:decimal (fold (+) 0.0 balance-lst))
            )
            (XI_DebitMultiple id nonce-lst account-to-be-wiped balance-lst)
            (XI_UpdateSupply id balance-sum false)
        )
    )  
)

(create-table P|T)
(create-table DPMF|PropertiesTable)
(create-table DPMF|BalanceTable)
(create-table DPMF|RoleTable)