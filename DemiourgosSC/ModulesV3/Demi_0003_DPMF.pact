;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module DPMF GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_DPMF           (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|DPMF_ADMIN))
    )
    (defcap GOV|DPMF_ADMIN ()
        (enforce-guard GOV|MD_DPMF)
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S}) 
    ;;{P3}
    (defcap P|DALOS|UP_BLC ()
        true
    )
    (defcap P|DALOS|UP_ELT ()
        true
    )
    (defcap P|DPTF|UP_VST ()
        true
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
        (DALOS.P|A_Add 
            "DPMF|UpPrBl"
            (create-capability-guard (P|DALOS|UP_BLC))
        )
        (DALOS.P|A_Add 
            "DPMF|UpdateElite"
            (create-capability-guard (P|DALOS|UP_ELT))
        )
        (DPTF.P|A_Add 
            "DPMF|UpVes"
            (create-capability-guard (P|DPTF|UP_VST))
        )
    )
    ;;
    ;;{1}
    (defschema DPMF|PropertiesSchema
        branding:object{DALOS.BrandingSchema}
        branding-pending:object{DALOS.BrandingSchema}
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
        @doc "Key = <DPMF id> + UTILS.BAR + <account>"
        unit:[object{DPMF|Schema}]
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
    (defschema DPMF|Schema
        nonce:integer
        balance:decimal
        meta-data:[object]
    )
    (defschema DPMF|Nonce-Balance
        nonce:integer
        balance:decimal
    )
    ;;{2}
    (deftable DPMF|PropertiesTable:{DPMF|PropertiesSchema})
    (deftable DPMF|BalanceTable:{DPMF|BalanceSchema})
    (deftable DPMF|RoleTable:{DPMF|RoleSchema})
    ;;{3}
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
    ;;{4}
    (defcap SECURE ()
        true
    )
    (defcap DALOS|EXECUTOR ()
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
    ;;{5}
    (defcap DPMF|S>CTRL (id:string)
        @event
        (DPMF|CAP_Owner id )
        (DPMF|UEV_CanUpgradeON id)
    )
    (defcap DPMF|S>X_FRZ-ACC (id:string account:string frozen:bool)
        (DPMF|CAP_Owner id)
        (DPMF|UEV_CanFreezeON id)
        (DPMF|UEV_AccountFreezeState id account (not frozen))
    )
    (defcap DPMF|S>RT_OWN (id:string new-owner:string)
        @event
        (DALOS.DALOS|UEV_SenderWithReceiver (DPMF|UR_Konto id) new-owner)
        (DALOS.DALOS|UEV_EnforceAccountExists new-owner)
        (DPMF|CAP_Owner id)
        (DPMF|UEV_CanChangeOwnerON id)
    )
    (defcap DPMF|S>TG_BURN-R (id:string account:string toggle:bool)
        @event
        (if toggle
            (DPMF|UEV_CanAddSpecialRoleON id)
            true
        )
        (DPMF|CAP_Owner id)
        (DPMF|UEV_AccountBurnState id account (not toggle))
    )
    (defcap DPMF|S>TG_PAUSE (id:string pause:bool)
        @event
        (if pause
            (DPMF|UEV_CanPauseON id)
            true
        )
        (DPMF|CAP_Owner id)
        (DPMF|UEV_PauseState id (not pause))
    )
    (defcap DPMF|S>X_TG_TRANSFER-R (id:string account:string toggle:bool)
        (enforce (!= account DALOS.OUROBOROS|SC_NAME) (format "{} Account is immune to transfer roles" [DALOS.OUROBOROS|SC_NAME]))
        (enforce (!= account DALOS.DALOS|SC_NAME) (format "{} Account is immune to transfer roles" [DALOS.DALOS|SC_NAME]))
        (if toggle
            (DPMF|UEV_CanAddSpecialRoleON id)
            true
        )
        (DPMF|CAP_Owner id)
        (DPMF|UEV_AccountTransferState id account (not toggle))
    )
    (defcap DPMF|S>MOVE_CREATE-R (id:string receiver:string)
        @event
        (DALOS.DALOS|UEV_SenderWithReceiver (DPMF|UR_CreateRoleAccount id) receiver)
        (DPMF|CAP_Owner id)
        (DPMF|UEV_CanTransferNFTCreateRoleON id)
        (DPMF|UEV_AccountCreateState id (DPMF|UR_CreateRoleAccount id) true)
        (DPMF|UEV_AccountCreateState id receiver false)
    )
    (defcap DPMF|S>TG_ADD-QTY-R (id:string account:string toggle:bool)
        @event
        (DPMF|CAP_Owner id)
        (DPMF|UEV_AccountAddQuantityState id account (not toggle))
        (if toggle
            (DPMF|UEV_CanAddSpecialRoleON id)
            true
        )
    )
    ;;{6}
    (defcap DPMF|F>OWNER (id:string)
        (DPMF|CAP_Owner id)
    )
    ;;{7}
    (defcap BASIS|C>X_WRITE-ROLES (id:string account:string rp:integer)
        (UTILS.UTILS|UEV_PositionalVariable rp 5 "Invalid Role Position")
        (DALOS.DALOS|UEV_EnforceAccountExists account)
        (DPMF|UEV_id id)
        (compose-capability (SECURE))
    )
    (defcap DPMF|C>BURN (id:string client:string amount:decimal)
        @event
        (DALOS.DALOS|CAP_EnforceAccountOwnership client)
        (DPMF|UEV_Amount id amount)
        (DPMF|UEV_AccountBurnState id client true)
        (compose-capability (DPMF|DEBIT))
        (compose-capability (DPMF|UP_SPLY))
    )
    (defcap DPMF|FC>FRZ-ACC (id:string account:string frozen:bool)
        @event
        (compose-capability (DPMF|S>X_FRZ-ACC id account frozen))
        (compose-capability (BASIS|C>X_WRITE-ROLES id account 5))
    )
    (defcap DPMF|C>ISSUE (account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        @event
        (let*
            (
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
            (UTILS.UTILS|UEV_EnforceUniformIntegerList lengths)
            (UTILS.LIST|UC_IzUnique name)
            (UTILS.LIST|UC_IzUnique ticker)
            (DALOS.DALOS|CAP_EnforceAccountOwnership account)
            (compose-capability (SECURE))
        )
    )
    (defcap DPMF|C>TG_TRANSFER-R (id:string account:string toggle:bool)
        @event
        (compose-capability (DPMF|S>X_TG_TRANSFER-R id account toggle))
        (compose-capability (DPMF|UPRL-TA))
        (compose-capability (BASIS|C>X_WRITE-ROLES id account 4))
    )
    (defcap DPMF|C>WIPE (id:string account-to-be-wiped:string)
        @event
        (DPMF|UEV_CanWipeON id)
        (DPMF|UEV_AccountFreezeState id account-to-be-wiped true)
        (compose-capability (DPMF|DEBIT))
        (compose-capability (DPMF|UP_SPLY))
    )
    (defcap DPMF|C>ADD-QTY (id:string client:string amount:decimal)
        @event
        (DALOS.DALOS|CAP_EnforceAccountOwnership client)
        (DPMF|UEV_Amount id amount)
        (DPMF|UEV_AccountAddQuantityState id client true)
        (compose-capability (DPMF|CREDIT))
        (compose-capability (DPMF|UP_SPLY))
    )
    (defcap DPMF|C>CREATE (id:string client:string)
        @event
        (DALOS.DALOS|CAP_EnforceAccountOwnership client)
        (DPMF|UEV_AccountCreateState id client true)
        (compose-capability (DPMF|INCR_NONCE))
    )
    (defcap DPMF|C>MINT (id:string client:string amount:decimal)
        @event
        (compose-capability (DPMF|C>CREATE id client))
        (compose-capability (DPMF|C>ADD-QTY id client amount))
    )
    (defcap DPMF|C>TRANSFER (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @event
        (compose-capability (DPMF|C>X_TRANSFER id sender receiver transfer-amount method))
        (compose-capability (DALOS|EXECUTOR))
    )
    (defcap DPMF|C>X_TRANSFER (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (DALOS.DALOS|CAP_EnforceAccountOwnership sender)
        (if (and method (DALOS.DALOS|UR_AccountType receiver))
            (DALOS.DALOS|CAP_EnforceAccountOwnership receiver)
            true
        )
        (DPMF|UEV_Amount id transfer-amount)
        (DALOS.DALOS|UEV_EnforceTransferability sender receiver method)
        (DPMF|UEV_PauseState id false)
        (DPMF|UEV_AccountFreezeState id sender false)
        (DPMF|UEV_AccountFreezeState id receiver false)
        (if
            (and 
                (> (DPMF|UR_TransferRoleAmount id) 0) 
                (not (or (= sender DALOS.OUROBOROS|SC_NAME)(= sender DALOS.DALOS|SC_NAME)))
            )
            (let
                (
                    (s:bool (DPMF|UR_AccountRoleTransfer id sender))
                    (r:bool (DPMF|UR_AccountRoleTransfer id receiver))
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
        (compose-capability (DPMF|DEBIT))
        (compose-capability (DPMF|CREDIT))
        (compose-capability (P|DALOS|UP_ELT))
    )
    ;;
    ;;{8}
    (defun DPMF|CAP_Owner (id:string)
        (DALOS.DALOS|CAP_EnforceAccountOwnership (DPMF|UR_Konto id))
    )
    ;;{9}
    (defun DPMF|UDC_Compose:object{DPMF|Schema} (nonce:integer balance:decimal meta-data:[object])
        {"nonce" : nonce, "balance": balance, "meta-data" : meta-data}
    )
    (defun DPMF|UDC_Nonce-Balance:[object{DPMF|Nonce-Balance}] (nonce-lst:[integer] balance-lst:[decimal])
        (let
            (
                (nonce-length:integer (length nonce-lst))
                (balance-length:integer (length balance-lst))
            )
            (enforce (= nonce-length balance-length) "Nonce and Balance Lists are not of equal length")
            (zip (lambda (x:integer y:decimal) { "nonce": x, "balance": y }) nonce-lst balance-lst)
        )
    )
    ;;{10}
    (defun DPMF|UEV_UpdateRewardBearingToken (id:string)
        (let
            (
                (rbt:string (DPMF|UR_RewardBearingToken id))
            )
            (enforce (= rbt UTILS.BAR) "RBT for a DPMF is immutable")
        )
    )
    (defun DPMF|UEV_CanChangeOwnerON (id:string)
        (let
            (
                (x:bool (DPMF|UR_CanChangeOwner id))
            )
            (enforce (= x true) (format "{} ownership cannot be changed" [id]))
        )
    )
    (defun DPMF|UEV_CanUpgradeON (id:string)
        (let
            (
                (x:bool (DPMF|UR_CanUpgrade id))
            )
            (enforce (= x true) (format "{} properties cannot be upgraded" [id])
            )
        )
    )
    (defun DPMF|UEV_CanAddSpecialRoleON (id:string)
        (let
            (
                (x:bool (DPMF|UR_CanAddSpecialRole id))
            )
            (enforce (= x true) (format "For {} no special roles can be added" [id])
            )
        )
    )
    (defun DPMF|UEV_CanFreezeON (id:string)
        (let
            (
                (x:bool (DPMF|UR_CanFreeze id))
            )
            (enforce (= x true) (format "{} cannot be freezed" [id])
            )
        )
    )
    (defun DPMF|UEV_CanWipeON (id:string)
        (let
            (
                (x:bool (DPMF|UR_CanWipe id))
            )
            (enforce (= x true) (format "{} cannot be wiped" [id])
            )
        )
    )
    (defun DPMF|UEV_CanPauseON (id:string)
        (let
            (
                (x:bool (DPMF|UR_CanPause id))
            )
            (enforce (= x true) (format "{} cannot be paused" [id])
            )
        )
    )
    (defun DPMF|UEV_PauseState (id:string state:bool)
        (let
            (
                (x:bool (DPMF|UR_Paused id))
            )
            (if state
                (enforce x (format "{} is already unpaused" [id]))
                (enforce (= x false) (format "{} is already paused" [id]))
            )
        )
    )
    (defun DPMF|UEV_AccountBurnState (id:string account:string state:bool)
        (let
            (
                (x:bool (DPMF|UR_AccountRoleBurn id account))
            )
            (enforce (= x state) (format "Burn Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun DPMF|UEV_AccountTransferState (id:string account:string state:bool)
        (let
            (
                (x:bool (DPMF|UR_AccountRoleTransfer id account))
            )
            (enforce (= x state) (format "Transfer Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun DPMF|UEV_AccountFreezeState (id:string account:string state:bool)
        (let
            (
                (x:bool (DPMF|UR_AccountFrozenState id account))
            )
            (enforce (= x state) (format "Frozen for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun DPMF|UEV_Amount (id:string amount:decimal)
        (let
            (
                (decimals:integer (DPMF|UR_Decimals id))
            )
            (enforce
                (= (floor amount decimals) amount)
                (format "{} is not conform with the {} prec." [amount id])
            )
            (enforce
                (> amount 0.0)
                (format "{} is not a Valid Transaction amount" [amount])
            )
        )
    )
    (defun DPMF|UEV_CheckID:bool (id:string)
        (with-default-read DPMF|PropertiesTable id
            { "supply" : -1.0 }
            { "supply" := s }
            (if (>= s 0.0)
                true
                false
            )
        )
    )
    (defun DPMF|UEV_id (id:string)
        (with-default-read DPMF|PropertiesTable id
            { "supply" : -1.0 }
            { "supply" := s }
            (enforce
                (>= s 0.0)
                (format "DPMF ID {} does not exist" [id])
            )
        )
    )
    (defun DPMF|UEV_CanTransferNFTCreateRoleON (id:string)
        (let
            (
                (x:bool (DPMF|UR_CanTransferNFTCreateRole id))
            )
            (enforce (= x true) (format "DPMF Token {} cannot have its create role transfered" [id])
            )
        )
    )
    (defun DPMF|UEV_AccountAddQuantityState (id:string account:string state:bool)
        (let
            (
                (x:bool (DPMF|UR_AccountRoleNFTAQ id account))
            )
            (enforce (= x state) (format "Add Quantity Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun DPMF|UEV_AccountCreateState (id:string account:string state:bool)
        (let
            (
                (x:bool (DPMF|UR_AccountRoleCreate id account))
            )
            (enforce (= x state) (format "Create Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun DPMF|UEV_Vesting (id:string existance:bool)
        (let
            (
                (has-vesting:bool (DPMF|URC_HasVesting id))
            )
            (enforce (= has-vesting existance) (format "Vesting for the Token {} is not satisfied with existance {}" [id existance]))
        )
    )
    ;;{11}
    ;;{12}
    (defun DPMF|UR_P-KEYS:[string] ()
        (keys DPMF|PropertiesTable)
    )
    (defun DPMF|UR_KEYS:[string] ()
        (keys DPMF|BalanceTable)
    )
    (defun DPMF|UR_Branding:object{DALOS.BrandingSchema} (id:string pending:bool)
        (DPMF|UEV_id id)
        (if pending
            (with-read DPMF|PropertiesTable id
                { "branding-pending" := b }
                b
            )
            (with-read DPMF|PropertiesTable id
                { "branding" := b }
                b
            )
        )
    )
    (defun DPMF|URB_Logo:string (id:string pending:bool)
        (at "logo" (DPMF|UR_Branding id pending))
    )
    (defun DPMF|URB_Description:string (id:string pending:bool)
        (at "description" (DPMF|UR_Branding id pending))
    )
    (defun DPMF|URB_Website:string (id:string pending:bool)
        (at "website" (DPMF|UR_Branding id pending))
    )
    (defun DPMF|URB_Social:[object{DALOS.SocialSchema}] (id:string pending:bool)
        (at "social" (DPMF|UR_Branding id pending))
    )
    (defun DPMF|URB_Flag:integer (id:string pending:bool)
        (at "flag" (DPMF|UR_Branding id pending))
    )
    (defun DPMF|URB_Genesis:time (id:string pending:bool)
        (at "genesis" (DPMF|UR_Branding id pending))
    )
    (defun DPMF|URB_PremiumUntil:time (id:string pending:bool)
        (at "premium-until" (DPMF|UR_Branding id pending))
    )
    (defun DPMF|UR_Konto:string (id:string)
        (at "owner-konto" (read DPMF|PropertiesTable id ["owner-konto"]))
    )
    (defun DPMF|UR_Name:string (id:string)
        (at "name" (read DPMF|PropertiesTable id ["name"]))
    )
    (defun DPMF|UR_Ticker:string (id:string)
        (at "ticker" (read DPMF|PropertiesTable id ["ticker"])) 
    )
    (defun DPMF|UR_Decimals:integer (id:string)
        (at "decimals" (read DPMF|PropertiesTable id ["decimals"]))
    )
    (defun DPMF|UR_CanChangeOwner:bool (id:string)
        (at "can-change-owner" (read DPMF|PropertiesTable id ["can-change-owner"]))
    )
    (defun DPMF|UR_CanUpgrade:bool (id:string)
        (at "can-upgrade" (read DPMF|PropertiesTable id ["can-upgrade"]))  
    )
    (defun DPMF|UR_CanAddSpecialRole:bool (id:string)
        (at "can-add-special-role" (read DPMF|PropertiesTable id ["can-add-special-role"]))
    )
    (defun DPMF|UR_CanFreeze:bool (id:string)
        (at "can-freeze" (read DPMF|PropertiesTable id ["can-freeze"]))
    )
    (defun DPMF|UR_CanWipe:bool (id:string)
        (at "can-wipe" (read DPMF|PropertiesTable id ["can-wipe"]))
    )
    (defun DPMF|UR_CanPause:bool (id:string)
        (at "can-pause" (read DPMF|PropertiesTable id ["can-pause"]))
    )
    (defun DPMF|UR_Paused:bool (id:string)
        (at "is-paused" (read DPMF|PropertiesTable id ["is-paused"]))
    )
    (defun DPMF|UR_Supply:decimal (id:string)
        (at "supply" (read DPMF|PropertiesTable id ["supply"]))
    )
    (defun DPMF|UR_TransferRoleAmount:integer (id:string)
        (at "role-transfer-amount" (read DPMF|PropertiesTable id ["role-transfer-amount"]))
    )
    (defun DPMF|UR_Vesting:string (id:string)
        (at "vesting" (read DPMF|PropertiesTable id ["vesting"]))
    )
    (defun DPMF|UR_Roles:[string] (id:string rp:integer)
        (if (= rp 1)
            (with-default-read DPMF|RoleTable id
                { "r-burn" : [UTILS.BAR]}
                { "r-burn" := rb }
                rb
            )
            (if (= rp 2)
                (with-default-read DPMF|RoleTable id
                    { "r-nft-create" : [UTILS.BAR]}
                    { "r-nft-create" := rnc }
                    rnc
                )
                (if (= rp 3)
                    (with-default-read DPMF|RoleTable id
                        { "r-nft-add-quantity" : [UTILS.BAR]}
                        { "r-nft-add-quantity" := rnaq }
                        rnaq
                    )
                    (if (= rp 4)
                        (with-default-read DPMF|RoleTable id
                            { "r-transfer" : [UTILS.BAR]}
                            { "r-transfer" := rt }
                            rt
                        )
                        (with-default-read DPMF|RoleTable id
                            { "a-frozen" : [UTILS.BAR]}
                            { "a-frozen" := af }
                            af
                        )
                    )
                )
            )
        )
    )
    (defun DPMF|UR_CanTransferNFTCreateRole:bool (id:string)
        (at "can-transfer-nft-create-role" (read DPMF|PropertiesTable id ["can-transfer-nft-create-role"]))
    )
    (defun DPMF|UR_CreateRoleAccount:string (id:string)
        (at "create-role-account" (read DPMF|PropertiesTable id ["create-role-account"]))
    )
    (defun DPMF|UR_NoncesUsed:integer (id:string)
        (at "nonces-used" (read DPMF|PropertiesTable id ["nonces-used"]))
    )
    (defun DPMF|UR_RewardBearingToken:string (id:string)
        (at "reward-bearing-token" (read DPMF|PropertiesTable id ["reward-bearing-token"]))
    )
    (defun DPMF|UR_AccountSupply:decimal (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR  account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let 
                (
                    (result 
                        (fold
                            (lambda 
                                (acc:decimal item:object{DPMF|Schema})
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
    (defun DPMF|UR_AccountRoleBurn:bool (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "role-nft-burn" : false}
            { "role-nft-burn" := rb }
            rb
        )
    )
    (defun DPMF|UR_AccountRoleTransfer:bool (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "role-transfer" : false }
            { "role-transfer" := rt }
            rt
        )
    )
    (defun DPMF|UR_AccountFrozenState:bool (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "frozen" : false}
            { "frozen" := fr }
            fr
        )
    )
    (defun DPMF|UR_AccountUnit:[object] (id:string account:string)
        (DPMF|UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "unit" : DPMF|NEGATIVE}
            { "unit" := u }
            u
        )
    )
    (defun DPMF|UR_AccountBalances:[decimal] (id:string account:string)
        (DPMF|UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let 
                (
                    (result 
                        (fold
                            (lambda 
                                (acc:[decimal] item:object{DPMF|Schema})
                                (if (!= (at "balance" item) 0.0)
                                        (UTILS.LIST|UC_AppendLast acc (at "balance" item))
                                        acc
                                )
                            )
                            []
                            read-unit
                        )
                    )
                )
                result
            )
        )
    )
    (defun DPMF|UR_AccountBatchMetaData (id:string nonce:integer account:string)
        (DPMF|UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let 
                (
                    (result-meta-data
                        (fold
                            (lambda 
                                (acc item:object{DPMF|Schema})
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
                result-meta-data
            )
        )
    )
    (defun DPMF|UR_AccountBatchSupply:decimal (id:string nonce:integer account:string)
        (DPMF|UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let 
                (
                    (result-balance:decimal
                        (fold
                            (lambda 
                                (acc:decimal item:object{DPMF|Schema})
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
                result-balance
            )
        )
    )
    (defun DPMF|UR_AccountNonces:[integer] (id:string account:string)
        (DPMF|UEV_id id false)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let 
                (
                    (result 
                        (fold
                            (lambda 
                                (acc:[integer] item:object{DPMF|Schema})
                                (if (!= (at "nonce" item) 0)
                                        (UTILS.LIST|UC_AppendLast acc (at "nonce" item))
                                        acc
                                )
                            )
                            []
                            read-unit
                        )
                    )
                )
                result
            )
        )
    )
    (defun DPMF|UR_AccountRoleNFTAQ:bool (id:string account:string)
        (DPMF|UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "role-nft-add-quantity" : false}
            { "role-nft-add-quantity" := rnaq }
            rnaq
        )
    )
    (defun DPMF|UR_AccountRoleCreate:bool (id:string account:string)
        (DPMF|UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "role-nft-create" : false}
            { "role-nft-create" := rnc }
            rnc
        )
    )
    ;;{13}
    (defun DPMF|URC_IzRBT:bool (reward-bearing-token:string)
        (DPMF|UEV_id reward-bearing-token)
        (if (= (DPMF|UR_RewardBearingToken reward-bearing-token) UTILS.BAR)
            false
            true
        )
    )
    (defun DPMF|URC_IzRBTg:bool (atspair:string reward-bearing-token:string)
        (DPMF|UEV_id reward-bearing-token)
        (if (= (DPMF|UR_RewardBearingToken reward-bearing-token) UTILS.BAR)
            false
            (if (= (DPMF|UR_RewardBearingToken reward-bearing-token) atspair)
                true
                false
            )
        )
    )
    (defun DALOS|URC_EliteAurynzSupply (account:string)
        (let
            (
                (ea-id:string (DALOS.DALOS|UR_EliteAurynID))
            )
            (if (!= ea-id UTILS.BAR)
                (let
                    (
                        (ea-supply:decimal (DPTF.DPTF|UR_AccountSupply ea-id account))
                        (vea:string (DPTF.DPTF|UR_Vesting ea-id))
                    )
                    (if (!= vea UTILS.BAR)
                        (+ ea-supply (DPMF|UR_AccountSupply vea account))
                        ea-supply
                    )
                )
                true
            )
        )
    )
    (defun DPMF|URC_AccountExist:bool (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "unit" : [DPMF|NEGATIVE] }
            { "unit" := u}
            (if (= u [DPMF|NEGATIVE])
                false
                true
            )
        )
    )
    (defun DPMF|URC_HasVesting:bool (id:string)
        (if (= (DPMF|UR_Vesting id) UTILS.BAR)
            false
            true
        )
    )
    ;;
    ;;{14}
    ;;{15}
    (defun DPMF|C_RtOwn (patron:string id:string new-owner:string)
        (with-capability (DPMF|S>RT_OWN id new-owner)
            (DPMF|X_ChangeOwnership id new-owner)
            (DALOS.IGNIS|C_Collect patron (DPMF|UR_Konto id) (DALOS.DALOS|UR_UsagePrice "ignis|biggest"))
        )
    )
    (defun DPMF|C_DeployAccount (id:string account:string)
        (DALOS.DALOS|UEV_EnforceAccountExists account)
        (DPMF|UEV_id id)
        (let*
            (
                (create-role-account:string (DPMF|UR_CreateRoleAccount id))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
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
                (write DPMF|BalanceTable (concat [id UTILS.BAR account])
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
    (defun DPMF|C_TgFreezeAccount (patron:string id:string account:string toggle:bool)
        (with-capability (DPMF|FC>FRZ-ACC id account toggle)
            (DPMF|X_ToggleFreezeAccount id account toggle)
            (DPMF|X_WriteRoles id account 5 toggle)
            (DALOS.IGNIS|C_Collect patron account (DALOS.DALOS|UR_UsagePrice "ignis|big"))
        )
    )
    (defun DPMF|C_TgPause (patron:string id:string toggle:bool)
        (with-capability (DPMF|S>TG_PAUSE id toggle)
            (DPMF|X_TogglePause id toggle)
            (DALOS.IGNIS|C_Collect patron patron (DALOS.DALOS|UR_UsagePrice "ignis|medium"))
        )
    )
    (defun DPMF|C_TgTransferR (patron:string id:string account:string toggle:bool)
        (with-capability (DPMF|C>TG_TRANSFER-R id account toggle)
            (DPMF|X_ToggleTransferRole id account toggle)
            (DPMF|X_UpdateRoleTransferAmount id toggle)
            (DPMF|X_WriteRoles id account 4 toggle)
            (DALOS.IGNIS|C_Collect patron account (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun DPMF|C_Wipe (patron:string id:string atbw:string)
        (with-capability (DPMF|C>WIPE id atbw)
            (DPMF|X_Wipe id atbw)
            (DALOS.IGNIS|C_CollectWT patron atbw (DALOS.DALOS|UR_UsagePrice "ignis|biggest") (DALOS.IGNIS|URC_ZeroGAS id atbw))
        )
    )
    (defun DPMF|C_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal)
        (with-capability (DPMF|C>ADD-QTY id account amount)
            (DPMF|X_AddQuantity id nonce account amount)
            (DALOS.IGNIS|C_CollectWT patron account (DALOS.DALOS|UR_UsagePrice "ignis|small") (DALOS.IGNIS|URC_ZeroGAS id account))
        )
    )
    (defun DPMF|C_Burn (patron:string id:string nonce:integer account:string amount:decimal)
        (with-capability (DPMF|C>BURN id account amount)
            (DPMF|X_Burn id nonce account amount)
            (DALOS.IGNIS|C_CollectWT patron account (DALOS.DALOS|UR_UsagePrice "ignis|small") (DALOS.IGNIS|URC_ZeroGAS id account))
        )
    )
    (defun DPMF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool)
        (with-capability (DPMF|S>CTRL id)
            (DPMF|X_Control id cco cu casr cf cw cp ctncr)
            (DALOS.IGNIS|C_Collect patron (DPMF|UR_Konto id) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun DPMF|C_Create:integer (patron:string id:string account:string meta-data:[object])
        (with-capability (DPMF|C>CREATE id account)
            (DALOS.IGNIS|C_CollectWT patron account (DALOS.DALOS|UR_UsagePrice "ignis|small") (DALOS.IGNIS|URC_ZeroGAS id account))
            (DPMF|X_Create id account meta-data)
        )
    )
    (defun DPMF|C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        (enforce-guard (P|UR "TALOS|Summoner"))
        (let*
            (
                (l1:integer (length name))
                (mf-cost:decimal (DALOS.DALOS|UR_UsagePrice "dpmf"))
                (kda-costs:decimal (* (dec l1) mf-cost))
                (issued-ids:[string]
                    (with-capability (SECURE)
                        (DPMF|X_IssueFree patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role)
                    )
                )                
            )
            (DALOS.KDA|C_Collect patron kda-costs)
            issued-ids
        )
    )
    (defun DPMF|C_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object])
        (with-capability (DPMF|C>MINT id account amount)
            (DALOS.IGNIS|C_CollectWT patron account (DALOS.DALOS|UR_UsagePrice "ignis|small") (DALOS.IGNIS|URC_ZeroGAS id account))
            (DPMF|X_Mint id account amount meta-data)
        )
    )
    (defun DPMF|C_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)
        (with-capability (DPMF|C>TRANSFER id sender receiver transfer-amount method)
            (DPMF|XK_Transfer patron id nonce sender receiver transfer-amount method)
        )
    )
    (defun DPMF|C_MultiBatchTransfer (patron:string id:string nonces:[integer] sender:string receiver:string method:bool)
        (let*
            (
                (account-nonces:[integer] (DPMF|UR_AccountNonces id sender))
                (contains-all:bool (UTILS.UTILS|UC_ContainsAll account-nonces nonces))
            )
            (enforce contains-all "Invalid Nonce List for DPTf Multi Batch Transfer")
            (map
                (lambda
                    (single-nonce:integer)
                    (DPMF|C_SingleBatchTransfer patron id single-nonce sender receiver method)
                )
                nonces
            )
        )
    )
    (defun DPMF|C_SingleBatchTransfer (patron:string id:string nonce:integer sender:string receiver:string method:bool)
        (let
            (
                (balance:decimal (DPMF|UR_AccountBatchSupply id nonce))
            )
            (DPMF|C_Transfer patron id nonce sender receiver balance method)
        )
    )
    ;;{16}
    (defun BASIS|X_UpdateElite (id:string sender:string receiver:string)
        (let
            (
                (ea-id:string (DALOS.DALOS|UR_EliteAurynID))
            )
            (if (!= ea-id UTILS.BAR)
                (if (= id ea-id)
                    (with-capability (P|DALOS|UP_ELT)
                        (DALOS.DALOS|X_UpdateElite sender (DALOS|URC_EliteAurynzSupply sender))
                        (DALOS.DALOS|X_UpdateElite receiver (DALOS|URC_EliteAurynzSupply receiver))
                    )
                    (let
                        (
                            (v-ea-id:string (DPTF.DPTF|UR_Vesting ea-id))
                        )
                        (if (and (!= v-ea-id UTILS.BAR)(= id v-ea-id))
                            (with-capability (P|DALOS|UP_ELT)
                                (DALOS.DALOS|X_UpdateElite sender (DALOS|URC_EliteAurynzSupply sender))
                                (DALOS.DALOS|X_UpdateElite receiver (DALOS|URC_EliteAurynzSupply receiver))
                            )
                            true
                        )
                    )
                )
                true
            )
        )
    )
    (defun BASIS|X_UpdateVesting (dptf:string dpmf:string)
        (enforce-guard (P|UR "VST|UpVes"))
        (with-capability (P|DPTF|UP_VST)
            (DPTF.DPTF|X_UpdateVesting dptf dpmf)
        )
        (update DPMF|PropertiesTable dpmf
            {"vesting" : dptf}
        )
    )
    (defun DPMF|X_IssueFree:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        (enforce-one
            "DPMF Issue not permitted"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "VST|Caller"))
            ]
        )
        (with-capability (DPMF|C>ISSUE account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role)
            (let*
                (
                    (l1:integer (length name))
                    (gas-costs:decimal (* (dec l1) (DALOS.DALOS|UR_UsagePrice "ignis|token-issue")))
                    (folded-lst:[string]
                        (fold
                            (lambda
                                (acc:[string] index:integer)
                                (let
                                    (
                                        (id:string
                                            (DPMF|X_Issue
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
                                    (UTILS.LIST|UC_AppendLast acc id)
                                )
                            )
                            []
                            (enumerate 0 (- l1 1))
                        )
                    )
                )
                (DALOS.IGNIS|C_Collect patron account gas-costs)
                folded-lst
            )
        ) 
    )
    (defun DPMF|X_UpdateBranding (id:string pending:bool branding:object{DALOS.BrandingSchema})
        (enforce-guard (P|UR "BRD|Update"))
        (if pending
            (update DPMF|PropertiesTable id
                {"branding-pending" : branding}
            )
            (update DPMF|PropertiesTable id
                {"branding" : branding}
            )
        )
    )
    (defun DPMF|X_ChangeOwnership (id:string new-owner:string)
        (require-capability (DPMF|S>RT_OWN id new-owner))
        (update DPMF|PropertiesTable id
            {"owner-konto"                      : new-owner}
        )
    )
    (defun DPMF|X_ToggleFreezeAccount (id:string account:string toggle:bool)
        (require-capability (DPMF|S>X_FRZ-ACC id account toggle))
        (update DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "frozen" : toggle}
        )
    )
    (defun DPMF|X_TogglePause (id:string toggle:bool)
        (require-capability (DPMF|S>TG_PAUSE id toggle))
        (update DPMF|PropertiesTable id
            { "is-paused" : toggle}
        )
    )
    (defun DPMF|X_ToggleTransferRole (id:string account:string toggle:bool)
        (require-capability (DPMF|S>X_TG_TRANSFER-R id account toggle))
        (update DPMF|BalanceTable (concat [id UTILS.BAR account])
            {"role-transfer" : toggle}
        )
    )
    (defun DPMF|X_UpdateRoleTransferAmount (id:string direction:bool)
        (require-capability (DPMF|UPRL-TA))
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
    (defun DPMF|X_UpdateSupply (id:string amount:decimal direction:bool)
        (require-capability (DPMF|UP_SPLY))
        (DPMF|UEV_Amount id amount)
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
    (defun DPMF|X_Wipe (id:string account-to-be-wiped:string)
        (require-capability (DPMF|C>WIPE id account-to-be-wiped))
        (let*
            (
                (nonce-lst:[integer] (DPMF|UR_AccountNonces id account-to-be-wiped))
                (balance-lst:[decimal] (DPMF|UR_AccountBalances id account-to-be-wiped))
                (balance-sum:decimal (fold (+) 0.0 balance-lst))
            )
            (DPMF|X_DebitMultiple id nonce-lst account-to-be-wiped balance-lst)
            (DPMF|X_UpdateSupply id balance-sum false)
        )
    )
    (defun DPMF|X_ToggleBurnRole (id:string account:string toggle:bool)
        (enforce-guard (P|UR "ATSI|TgBrRl"))
        (with-capability (DPMF|S>TG_BURN-R id account toggle)
            (update DPMF|BalanceTable (concat [id UTILS.BAR account])
                {"role-nft-burn" : toggle}
            )
        )
    )
    (defun DPMF|X_UpdateRewardBearingToken (atspair:string id:string)
        (enforce-guard (P|UR "ATSM|Caller"))
        (DPMF|UEV_UpdateRewardBearingToken id)
        (update DPMF|PropertiesTable id
            {"reward-bearing-token" : atspair}
        )
    )
    (defun DPMF|X_WriteRoles (id:string account:string rp:integer d:bool)
        (enforce-one
            "Invalid Permissions to update Reward Token"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "ATSI|WR"))
            ]
        )
        (with-capability (BASIS|C>X_WRITE-ROLES id account rp)
            (with-default-read DPMF|RoleTable id
                { "r-nft-burn"          : [UTILS.BAR]
                , "r-nft-create"        : [UTILS.BAR]
                , "r-nft-add-quantity"  : [UTILS.BAR]
                , "r-transfer"          : [UTILS.BAR]
                , "a-frozen"            : [UTILS.BAR]}
                { "r-nft-burn"          := rb
                , "r-nft-create"        := rnc
                , "r-nft-add-quantity"  := rnaq
                , "r-transfer"          := rt
                , "a-frozen"            := af}
                (if (= rp 1)
                    (write DPMF|RoleTable id
                        { "r-nft-burn"          : (UTILS.BASIS|UC_NewRoleList rb account d)
                        , "r-nft-create"        : rnc
                        , "r-nft-add-quantity"  : rnaq
                        , "r-transfer"          : rt
                        , "a-frozen"            : af}
                    )
                    (if (= rp 2)
                        (write DPMF|RoleTable id
                            { "r-nft-burn"          : rb
                            , "r-nft-create"        : (UTILS.BASIS|UC_NewRoleList rnc account d)
                            , "r-nft-add-quantity"  : rnaq
                            , "r-transfer"          : rt
                            , "a-frozen"            : af}
                        )
                        (if (= rp 3)
                            (write DPMF|RoleTable id
                                { "r-nft-burn"          : rb
                                , "r-nft-create"        : rnc
                                , "r-nft-add-quantity"  : (UTILS.BASIS|UC_NewRoleList rnaq account d)
                                , "r-transfer"          : rt
                                , "a-frozen"            : af}
                            )
                            (if (= rp 4)
                                (write DPMF|RoleTable id
                                    { "r-nft-burn"          : rb
                                    , "r-nft-create"        : rnc
                                    , "r-nft-add-quantity"  : rnaq
                                    , "r-transfer"          : (UTILS.BASIS|UC_NewRoleList rt account d)
                                    , "a-frozen"            : af}
                                )
                                (write DPMF|RoleTable id
                                    { "r-nft-burn"          : rb
                                    , "r-nft-create"        : rnc
                                    , "r-nft-add-quantity"  : rnaq
                                    , "r-transfer"          : rt
                                    , "a-frozen"            : (UTILS.BASIS|UC_NewRoleList af account d)}
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    (defun DPMF|X_AddQuantity (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|C>ADD-QTY id account amount))
        (with-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "unit" := unit }
            (let*
                (
                    (current-nonce-balance:decimal (DPMF|UR_AccountBatchSupply id nonce account))
                    (current-nonce-meta-data (DPMF|UR_AccountBatchMetaData id nonce account))
                    (updated-balance:decimal (+ current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object{DPMF|Schema} (DPMF|UDC_Compose nonce current-nonce-balance current-nonce-meta-data))
                    (updated-meta-fungible:object{DPMF|Schema} (DPMF|UDC_Compose nonce updated-balance current-nonce-meta-data))
                    (processed-unit:[object{DPMF|Schema}] (UTILS.LIST|UC_ReplaceItem unit meta-fungible-to-be-replaced updated-meta-fungible))
                )
                (update DPMF|BalanceTable (concat [id UTILS.BAR account])
                    {"unit" : processed-unit}    
                )
            )
        )
        (DPMF|X_UpdateSupply id amount true)
    )
    (defun DPMF|X_Burn (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|C>BURN id account amount))
        (DPMF|X_DebitStandard id nonce account amount)
        (DPMF|X_UpdateSupply id amount false)
    )
    (defun DPMF|X_Control
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
        (require-capability (DPMF|S>CTRL id false))
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
    (defun DPMF|X_Credit (id:string nonce:integer meta-data:[object] account:string amount:decimal)
        (require-capability (DPMF|CREDIT))
        (let*
            (
                (create-role-account:string (DPMF|UR_CreateRoleAccount id))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
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
                (let*
                    (
                        (next-unit:[object] (if (= unit [DPMF|NEGATIVE]) [DPMF|NEUTRAL] unit))
                        (is-new:bool (if (= unit [DPMF|NEGATIVE]) true false))
                        (current-nonce-balance:decimal (DPMF|UR_AccountBatchSupply id nonce account))
                        (credited-balance:decimal (+ current-nonce-balance amount))
                        (present-meta-fungible:object{DPMF|Schema} (DPMF|UDC_Compose nonce current-nonce-balance meta-data))
                        (credited-meta-fungible:object{DPMF|Schema} (DPMF|UDC_Compose nonce credited-balance meta-data))
                        (processed-unit-with-replace:[object{DPMF|Schema}] (UTILS.LIST|UC_ReplaceItem next-unit present-meta-fungible credited-meta-fungible))
                        (processed-unit-with-append:[object{DPMF|Schema}] (UTILS.LIST|UC_AppendLast next-unit credited-meta-fungible))
                    )
                    (if (= current-nonce-balance 0.0)
                        (write DPMF|BalanceTable (concat [id UTILS.BAR account])
                            { "unit"                        : processed-unit-with-append
                            , "role-nft-add-quantity"       : (if is-new false rnaq)
                            , "role-nft-burn"               : (if is-new false rb)
                            , "role-nft-create"             : (if is-new role-nft-create-boolean rnc)
                            , "role-transfer"               : (if is-new false rt)
                            , "frozen"                      : (if is-new false f)}
                        )
                        (write DPMF|BalanceTable (concat [id UTILS.BAR account])
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
    (defun DPMF|X_Create:integer (id:string account:string meta-data:[object])
        (require-capability (DPMF|C>CREATE id account))
        (let*
            (
                (new-nonce:integer (+ (DPMF|UR_NoncesUsed id) 1))
                (create-role-account:string (DPMF|UR_CreateRoleAccount id))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
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
                (let*
                    (
                        (new-nonce:integer (+ (DPMF|UR_NoncesUsed id) 1))
                        (meta-fungible:object{DPMF|Schema} (DPMF|UDC_Compose new-nonce 0.0 meta-data))
                        (appended-meta-fungible:[object{DPMF|Schema}] (UTILS.LIST|UC_AppendLast u meta-fungible))
                    )
                    (write DPMF|BalanceTable (concat [id UTILS.BAR account])
                        { "unit"                        : appended-meta-fungible
                        , "role-nft-add-quantity"       : rnaq
                        , "role-nft-burn"               : rb
                        , "role-nft-create"             : rnc
                        , "role-transfer"               : rt
                        , "frozen"                      : f}
                    )
                    (DPMF|X_IncrementNonce id)
                    new-nonce
                )
            )
        )
    )
    (defun DPMF|X_DebitAdmin (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|DEBIT))
        (with-capability (DPMF|DEBIT_PUR)
            (DPMF|CAP_Owner id false)
            (DPMF|X_DebitPure id nonce account amount)
        )
    )
    (defun DPMF|X_DebitStandard (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|DEBIT))
        (with-capability (DPMF|DEBIT_PUR)
            (DALOS.DALOS|CAP_EnforceAccountOwnership account)
            (DPMF|X_DebitPure id nonce account amount)
        )
    )
    (defun DPMF|X_DebitPure (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|DEBIT_PUR))
        (with-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            {"unit"                                 := unit  
            ,"role-nft-add-quantity"                := rnaq
            ,"role-nft-burn"                        := rnb
            ,"role-nft-create"                      := rnc
            ,"role-transfer"                        := rt
            ,"frozen"                               := f}
            (let*
                (
                    (current-nonce-balance:decimal (DPMF|UR_AccountBatchSupply id nonce account))
                    (current-nonce-meta-data (DPMF|UR_AccountBatchMetaData id nonce account))
                    (debited-balance:decimal (- current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object{DPMF|Schema} (DPMF|UDC_Compose nonce current-nonce-balance current-nonce-meta-data))
                    (debited-meta-fungible:object{DPMF|Schema} (DPMF|UDC_Compose nonce debited-balance current-nonce-meta-data))
                    (processed-unit-with-remove:[object{DPMF|Schema}] (UTILS.LIST|UC_RemoveItem unit meta-fungible-to-be-replaced))
                    (processed-unit-with-replace:[object{DPMF|Schema}] (UTILS.LIST|UC_ReplaceItem unit meta-fungible-to-be-replaced debited-meta-fungible))
                )
                (enforce (>= debited-balance 0.0) "Insufficient Funds for debiting")
                (if (= debited-balance 0.0)
                    (update DPMF|BalanceTable (concat [id UTILS.BAR account])
                        {"unit"                     : processed-unit-with-remove
                        ,"role-nft-add-quantity"    : rnaq
                        ,"role-nft-burn"            : rnb
                        ,"role-nft-create"          : rnc
                        ,"role-transfer"            : rt
                        ,"frozen"                   : f}
                    )
                    (update DPMF|BalanceTable (concat [id UTILS.BAR account])
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
    (defun DPMF|X_DebitMultiple (id:string nonce-lst:[integer] account:string balance-lst:[decimal])
        (let
            (
                (nonce-balance-obj-lst:[object{DPMF|Nonce-Balance}] (DPMF|UDC_Nonce-Balance nonce-lst balance-lst))
            )
            (map (lambda (x:object{DPMF|Nonce-Balance}) (DPMF|X_DebitPaired id account x)) nonce-balance-obj-lst)
        )
    )
    (defun DPMF|X_DebitPaired (id:string account:string nonce-balance-obj:object{DPMF|Nonce-Balance})
        (let
            (
                (nonce:integer (at "nonce" nonce-balance-obj))
                (balance:decimal (at "balance" nonce-balance-obj))
            )
            (DPMF|X_DebitAdmin id nonce account balance)
        )
    )
    (defun DPMF|X_Issue:string
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
        (UTILS.DALOS|UEV_Decimals decimals)
        (UTILS.DALOS|UEV_NameOrTicker name true false)
        (UTILS.DALOS|UEV_NameOrTicker ticker false false)
        (require-capability (SECURE))
        (insert DPMF|PropertiesTable (DALOS.DALOS|UC_Makeid ticker)
            {"branding"             : DALOS.BRANDING|DEFAULT
            ,"branding-pending"     : DALOS.BRANDING|DEFAULT
            ,"owner-konto"          : account
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
            ,"reward-bearing-token" : UTILS.BAR
            ,"vesting"              : UTILS.BAR}
        )
        (DPMF|C_DeployAccount (DALOS.DALOS|UC_Makeid ticker) account)    
        (DALOS.DALOS|UC_Makeid ticker)
    )
    (defun DPMF|X_IncrementNonce (id:string)
        (require-capability (DPMF|INCR_NONCE))
        (with-read DPMF|PropertiesTable id
            { "nonces-used" := nu }
            (update DPMF|PropertiesTable id { "nonces-used" : (+ nu 1)})
        )
    )
    (defun DPMF|X_Mint:integer (id:string account:string amount:decimal meta-data:[object])
        (require-capability (DPMF|C>MINT id account amount))
        (let
            (
                (new-nonce:integer (+ (DPMF|UR_NoncesUsed id) 1))
            )
            (DPMF|X_Create id account meta-data)
            (DPMF|X_AddQuantity id new-nonce account amount)
            new-nonce
        )
    )
    (defun DPMF|XK_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)
        (require-capability (DALOS|EXECUTOR))
        (DPMF|X_Transfer id nonce sender receiver transfer-amount method)
        (DALOS.IGNIS|C_CollectWT patron sender (DALOS.DALOS|UR_UsagePrice "ignis|smallest") (DALOS.IGNIS|URC_ZeroGAZ id sender receiver))
    )
    (defun DPMF|X_Transfer (id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)
        (require-capability (DPMF|C>X_TRANSFER id sender receiver transfer-amount method))
        (let
            (
                (current-nonce-meta-data (DPMF|UR_AccountBatchMetaData id nonce sender))
                (ea-id:string (DALOS.DALOS|UR_EliteAurynID))
            )
            (DPMF|X_DebitStandard id nonce sender transfer-amount)
            (DPMF|X_Credit id nonce current-nonce-meta-data receiver transfer-amount)
            (BASIS|X_UpdateElite id sender receiver)
        )
    )

    (defun DPMF|X_MoveCreateRole (id:string receiver:string)
        (enforce-guard (P|UR "ATSI|MCRl"))
        (with-capability (DPMF|S>MOVE_CREATE-R id receiver)
            (update DPMF|BalanceTable (concat [id UTILS.BAR (DPMF|UR_CreateRoleAccount id)])
                {"role-nft-create" : false}
            )
            (update DPMF|BalanceTable (concat [id UTILS.BAR receiver])
                {"role-nft-create" : true}
            )
            (update DPMF|PropertiesTable id
                {"create-role-account" : receiver}
            )
        )
    )
    (defun DPMF|X_ToggleAddQuantityRole (id:string account:string toggle:bool)
        (enforce-guard (P|UR "ATSI|TgAqRl"))
        (with-capability (DPMF|S>TG_ADD-QTY-R id account toggle)
            (update DPMF|BalanceTable (concat [id UTILS.BAR account])
                {"role-nft-add-quantity" : toggle}
            )
        )
    )
)

(create-table P|T)
(create-table DPMF|PropertiesTable)
(create-table DPMF|BalanceTable)
(create-table DPMF|RoleTable)