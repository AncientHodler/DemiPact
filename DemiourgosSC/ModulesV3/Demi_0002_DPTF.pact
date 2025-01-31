;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module DPTF GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_DPTF           (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|DPTF_ADMIN))
    )
    (defcap GOV|DPTF_ADMIN ()
        (enforce-guard GOV|MD_DPTF)
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
    (defcap P|DALOS|UP_DATA ()
        true
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|DPTF_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        (DALOS.P|A_Add 
            "DPTF|UpPrBl"
            (create-capability-guard (P|DALOS|UP_BLC))
        )
        (DALOS.P|A_Add 
            "DPTF|UpPrDt"
            (create-capability-guard (P|DALOS|UP_DATA))
        )
    )
    ;;
    ;;{1}
    (defschema DPTF|PropertiesSchema
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
        supply:decimal
        origin-mint:bool
        origin-mint-amount:decimal
        role-transfer-amount:integer
        fee-toggle:bool
        min-move:decimal
        fee-promile:decimal
        fee-target:string
        fee-lock:bool
        fee-unlocks:integer
        primary-fee-volume:decimal
        secondary-fee-volume:decimal
        reward-token:[string]
        reward-bearing-token:[string]
        vesting:string
    )
    (defschema DPTF|RoleSchema
        r-burn:[string]
        r-mint:[string]
        r-fee-exemption:[string]
        r-transfer:[string]
        a-frozen:[string]
    )
    ;;{2}
    (deftable DPTF|PropertiesTable:{DPTF|PropertiesSchema})
    (deftable DPTF|BalanceTable:{DALOS.DPTF|BalanceSchema})
    (deftable DPTF|RoleTable:{DPTF|RoleSchema})
    ;;{3}
    ;;
    ;;{4}
    (defcap SECURE ()
        true
    )
    (defcap DALOS|EXECUTOR ()
        true
    )
    (defcap DPTF|CREDIT ()
        true
    )
    (defcap DPTF|DEBIT ()
        true
    )
    (defcap DPTF|DEBIT_PUR ()
        true
    )
    (defcap DPTF|INCR-LOCKS ()
        true
    )
    (defcap DPTF|UPRL-TA ()
        true
    )
    (defcap DPTF|UP_SPLY () 
        true
    )
    ;;{5}
    (defcap DPTF|S>CTRL (id:string)
        @event
        (DPTF|CAP_Owner id)
        (DPTF|UEV_CanUpgradeON id)
    )
    (defcap DPTF|S>X_FRZ-ACC (id:string account:string frozen:bool)
        (DPTF|CAP_Owner id)
        (DPTF|UEV_CanFreezeON id)
        (DPTF|UEV_AccountFreezeState id account (not frozen))
    )
    (defcap DPTF|S>RT_OWN (id:string new-owner:string)
        @event
        (DALOS.DALOS|UEV_SenderWithReceiver (DPTF|UR_Konto id) new-owner)
        (DALOS.DALOS|UEV_EnforceAccountExists new-owner)
        (DPTF|CAP_Owner id)
        (DPTF|UEV_CanChangeOwnerON id)
    )
    (defcap DPTF|S>TG_BURN-R (id:string account:string toggle:bool)
        @event
        (if toggle
            (DPTF|UEV_CanAddSpecialRoleON id)
            true
        )
        (DPTF|CAP_Owner id)
        (DPTF|UEV_AccountBurnState id account (not toggle))
    )
    (defcap DPTF|S>TG_PAUSE (id:string pause:bool)
        @event
        (if pause
            (DPTF|UEV_CanPauseON id)
            true
        )
        (DPTF|CAP_Owner id)
        (DPTF|UEV_PauseState id (not pause))
    )
    (defcap DPTF|S>X_TG_TRANSFER-R (id:string account:string toggle:bool)
        (enforce (!= account DALOS.OUROBOROS|SC_NAME) (format "{} Account is immune to transfer roles" [DALOS.OUROBOROS|SC_NAME]))
        (enforce (!= account DALOS.DALOS|SC_NAME) (format "{} Account is immune to transfer roles" [DALOS.DALOS|SC_NAME]))
        (if toggle
            (DPTF|UEV_CanAddSpecialRoleON id)
            true
        )
        (DPTF|CAP_Owner id)
        (DPTF|UEV_AccountTransferState id account (not toggle))
    )
    (defcap DPTF|S>SET_FEE (id:string fee:decimal)
        @event
        (UTILS.DALOS|UEV_Fee fee)
        (DPTF|CAP_Owner id)
        (DPTF|UEV_FeeLockState id false)
    )
    (defcap DPTF|S>SET_FEE-TARGET (id:string target:string)
        @event
        (DALOS.DALOS|UEV_EnforceAccountExists target)
        (DPTF|CAP_Owner id)
        (DPTF|UEV_FeeLockState id false) 
    )
    (defcap DPTF|S>SET_MIN-MOVE (id:string min-move-value:decimal)
        @event
        (let
            (
                (decimals:integer (DPTF|UR_Decimals id))
            )
            (enforce
                (= (floor min-move-value decimals) min-move-value)
                (format "Min tr amount {} does not conform with the {} DPTF dec. no." [min-move-value id])
            )
            (enforce (or (= min-move-value -1.0) (> min-move-value 0.0)) "Min-Move Value does not compute")
            (DPTF|CAP_Owner id)
            (DPTF|UEV_FeeLockState id false)
        )
    )
    (defcap DPTF|S>TG_FEE (id:string toggle:bool)
        @event
        (let
            (
                (fee-promile:decimal (DPTF|UR_FeePromile id))
            )
            (enforce (or (= fee-promile -1.0) (and (>= fee-promile 0.0) (<= fee-promile 1000.0))) "Please Set up Fee Promile before Turning Fee Collection on !")
            (DALOS.DALOS|UEV_EnforceAccountExists (DPTF|UR_FeeTarget id))
            (DPTF|CAP_Owner id)
            (DPTF|UEV_FeeLockState id false)
            (DPTF|UEV_FeeToggleState id (not toggle))
        )
    )
    (defcap DPTF|S>TG_FEE-EXEMP-R (id:string account:string toggle:bool)
        @event
        (DPTF|CAP_Owner id)
        (DALOS.DALOS|UEV_EnforceAccountType account true)
        (if toggle
            (DPTF|UEV_CanAddSpecialRoleON id)
            true
        )
        (DPTF|UEV_AccountFeeExemptionState id account (not toggle))
    )
    (defcap DPTF|S>X_TG_FEE-LOCK (id:string toggle:bool)
        (DPTF|CAP_Owner id)
        (DPTF|UEV_FeeLockState id (not toggle))
    )
    (defcap DPTF|S>TG_MINT-R (id:string account:string toggle:bool)
        @event
        (DPTF|CAP_Owner id)
        (if toggle
            (DPTF|UEV_CanAddSpecialRoleON id)
            true
        )
        (DPTF|UEV_AccountMintState id account (not toggle))
    )
    ;;{6}
    (defcap DPTF|F>OWNER (id:string)
        (DPTF|CAP_Owner id)
    )
    ;;{7}
    (defcap BASIS|C>X_WRITE-ROLES (id:string account:string rp:integer)
        (UTILS.UTILS|UEV_PositionalVariable rp 5 "Invalid Role Position")
        (DALOS.DALOS|UEV_EnforceAccountExists account)
        (DPTF|UEV_id id)
        (compose-capability (SECURE))
    )
    (defcap DPTF|C>BURN (id:string client:string amount:decimal)
        @event
        (DALOS.DALOS|CAP_EnforceAccountOwnership client)
        (DPTF|UEV_Amount id amount)
        (DPTF|UEV_AccountBurnState id client true)
        (compose-capability (DPTF|DEBIT))
        (compose-capability (DPTF|UP_SPLY))
    )
    (defcap DPTF|FC>FRZ-ACC (id:string account:string frozen:bool)
        @event
        (compose-capability (DPTF|S>X_FRZ-ACC id account frozen))
        (compose-capability (BASIS|C>X_WRITE-ROLES id account 5))
    )
    (defcap DPTF|C>ISSUE (account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
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
                (lengths:[integer] [l1 l2 l3 l4 l5 l6 l7 l8 l9])
            )
            (UTILS.UTILS|UEV_EnforceUniformIntegerList lengths)
            (UTILS.LIST|UC_IzUnique name)
            (UTILS.LIST|UC_IzUnique ticker)
            (DALOS.DALOS|CAP_EnforceAccountOwnership account)
            (compose-capability (SECURE))
        )
    )
    (defcap DPTF|C>TG_TRANSFER-R (id:string account:string toggle:bool)
        @event
        (compose-capability (DPTF|S>X_TG_TRANSFER-R id account toggle))
        (compose-capability (DPTF|UPRL-TA))
        (compose-capability (BASIS|C>X_WRITE-ROLES id account 4))
    )
    (defcap DPTF|C>WIPE (id:string account-to-be-wiped:string)
        @event
        (DPTF|UEV_CanWipeON id)
        (DPTF|UEV_AccountFreezeState id account-to-be-wiped true)
        (compose-capability (DPTF|DEBIT))
        (compose-capability (DPTF|UP_SPLY))
    )
    (defcap DPTF|C>MINT (id:string client:string amount:decimal origin:bool)
        (DALOS.DALOS|CAP_EnforceAccountOwnership client)
        (if origin
            (compose-capability (DPTF|C>MINT-ORG id amount))
            (compose-capability (DPTF|C>MINT-STD id client amount))
        )
    )
    (defcap DPTF|C>MINT-ORG (id:string amount:decimal)
        @event
        (DPTF|CAP_Owner id)
        (DPTF|UEV_Virgin id)
        (compose-capability (DPTF|C>MINT_GNRL id amount))
    )
    (defcap DPTF|C>MINT-STD (id:string client:string amount:decimal)
        @event
        (DPTF|UEV_AccountMintState id client true)
        (compose-capability (DPTF|C>MINT_GNRL id amount))
    )
    (defcap DPTF|C>MINT_GNRL (id:string amount:decimal)
        (DPTF|UEV_Amount id amount)
        (compose-capability (DPTF|CREDIT))
        (compose-capability (DPTF|UP_SPLY))
    )
    (defcap DPTF|C>TG_FEE-LOCK (id:string toggle:bool)
        @event
        (compose-capability (DPTF|S>X_TG_FEE-LOCK id toggle))
        (compose-capability (DPTF|INCR-LOCKS))
    )
    ;;
    ;;{8}
    (defun DPTF|CAP_Owner (id:string)
        (DALOS.DALOS|CAP_EnforceAccountOwnership (DPTF|UR_Konto id))
    )
    ;;{9}
    ;;{10}
    (defun DPTF|UEV_CanChangeOwnerON (id:string)
        (let
            (
                (x:bool (DPTF|UR_CanChangeOwner id))
            )
            (enforce x (format "{} ownership cannot be changed" [id]))
        )
    )
    (defun DPTF|UEV_CanUpgradeON (id:string)
        (let
            (
                (x:bool (DPTF|UR_CanUpgrade id))
            )
            (enforce x (format "{} properties cannot be upgraded" [id]))
        )
    )
    (defun DPTF|UEV_CanAddSpecialRoleON (id:string)
        (let
            (
                (x:bool (DPTF|UR_CanAddSpecialRole id))
            )
            (enforce x (format "For {} no special roles can be added" [id])
            )
        )
    )
    (defun DPTF|UEV_CanFreezeON (id:string)
        (let
            (
                (x:bool (DPTF|UR_CanFreeze id))
            )
            (enforce x (format "{} cannot be freezed" [id])
            )
        )
    )
    (defun DPTF|UEV_CanWipeON (id:string)
        (let
            (
                (x:bool (DPTF|UR_CanWipe id))
            )
            (enforce x (format "{} cannot be wiped" [id])
            )
        )
    )
    (defun DPTF|UEV_CanPauseON (id:string)
        (let
            (
                (x:bool (DPTF|UR_CanPause id))
            )
            (enforce x (format "{} cannot be paused" [id])
            )
        )
    )
    (defun DPTF|UEV_PauseState (id:string state:bool)
        (let
            (
                (x:bool (DPTF|UR_Paused id))
            )
            (if state
                (enforce x (format "{} is already unpaused" [id]))
                (enforce (= x false) (format "{} is already paused" [id]))
            )
        )
    )
    (defun DPTF|UEV_AccountBurnState (id:string account:string state:bool)
        (let
            (
                (x:bool (DPTF|UR_AccountRoleBurn id account))
            )
            (enforce (= x state) (format "Burn Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun DPTF|UEV_AccountTransferState (id:string account:string state:bool)
        (let
            (
                (x:bool (DPTF|UR_AccountRoleTransfer id account))
            )
            (enforce (= x state) (format "Transfer Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun DPTF|UEV_AccountFreezeState (id:string account:string state:bool)
        (let
            (
                (x:bool (DPTF|UR_AccountFrozenState id account))
            )
            (enforce (= x state) (format "Frozen for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun DPTF|UEV_Amount (id:string amount:decimal)
        (let
            (
                (decimals:integer (DPTF|UR_Decimals id))
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
    (defun DPTF|UEV_CheckID:bool (id:string)
        (with-default-read DPTF|PropertiesTable id
            { "supply" : -1.0 }
            { "supply" := s }
            (if (>= s 0.0)
                true
                false
            )
        )
    )
    (defun DPTF|UEV_id (id:string)
        (with-default-read DPTF|PropertiesTable id
            { "supply" : -1.0 }
            { "supply" := s }
            (enforce
                (>= s 0.0)
                (format "DPTF ID {} does not exist" [id])
            )
        )
    )
    (defun DPTF|UEV_Virgin (id:string)
        (let
            (
                (om:bool (DPTF|UR_OriginMint id))
                (oma:decimal (DPTF|UR_OriginAmount id))
            )
            (enforce
                (and (= om false) (= oma 0.0))
                (format "Origin Mint for {} is offline" [id])
            )
        )
    )
    (defun DPTF|UEV_FeeLockState (id:string state:bool)
        (let
            (
                (x:bool (DPTF|UR_FeeLock id))
            )
            (enforce (= x state) (format "Fee-lock for {} must be set to {} for exec" [id state]))
        )
    )
    (defun DPTF|UEV_FeeToggleState (id:string state:bool)
        (let
            (
                (x:bool (DPTF|UR_FeeToggle id))
            )
            (enforce (= x state) (format "Fee-Toggle for {} must be set to {} for exec" [id state]))
        )
    )
    (defun DPTF|UEV_AccountMintState (id:string account:string state:bool)
        (let
            (
                (x:bool (DPTF|UR_AccountRoleMint id account))
            )
            (enforce (= x state) (format "Mint Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun DPTF|UEV_AccountFeeExemptionState (id:string account:string state:bool)
        (let
            (
                (x:bool (DPTF|UR_AccountRoleFeeExemption id account))
            )
            (enforce (= x state) (format "Fee-Exemption Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun DPTF|UEV_EnforceMinimumAmount (id:string transfer-amount:decimal)
        (let*
            (
                (min-move-read:decimal (DPTF|UR_MinMove id))
                (precision:integer (DPTF|UR_Decimals id))
                (min-move:decimal 
                    (if (= min-move-read -1.0)
                        (floor (/ 1.0 (^ 10.0 (dec precision))) precision)
                        min-move-read
                    )
                )
            )
            (enforce (>= transfer-amount min-move) (format "{} is not a valid {} min move amount" [transfer-amount id]))
        )
    )
    (defun DPTF|UEV_Vesting (id:string existance:bool)
        (let
            (
                (has-vesting:bool (DPTF|URC_HasVesting id))
            )
            (enforce (= has-vesting existance) (format "Vesting for the Token {} is not satisfied with existance {}" [id existance]))
        )
    )
    ;;{11}
    (defun DPTF|UC_UnlockPrice:[decimal] (id:string)
        (UTILS.DPTF|UC_UnlockPrice (DPTF|UR_FeeUnlocks id))
    )
    (defun DPTF|UC_VolumetricTax (id:string amount:decimal)
        (DPTF|UEV_Amount id amount)
        (UTILS.DPTF|UC_VolumetricTax (DPTF|UR_Decimals id) amount)
    )
    ;;{12}
    (defun DPTF|UR_P-KEYS:[string] ()
        (keys DPTF|PropertiesTable)
    )
    
    (defun DPTF|UR_KEYS:[string] ()
        (keys DPTF|BalanceTable)
    )
    (defun DPTF|UR_Branding:object{DALOS.BrandingSchema} (id:string pending:bool)
        (DPTF|UEV_id id)
        (if pending
            (with-read DPTF|PropertiesTable id
                { "branding-pending" := b }
                b
            )
            (with-read DPTF|PropertiesTable id
                { "branding" := b }
                b
            )
        )
    )
    (defun DPTF|URB_Logo:string (id:string pending:bool)
        (at "logo" (DPTF|UR_Branding id pending))
    )
    (defun DPTF|URB_Description:string (id:string pending:bool)
        (at "description" (DPTF|UR_Branding id pending))
    )
    (defun DPTF|URB_Website:string (id:string pending:bool)
        (at "website" (DPTF|UR_Branding id pending))
    )
    (defun DPTF|URB_Social:[object{DALOS.SocialSchema}] (id:string pending:bool)
        (at "social" (DPTF|UR_Branding id pending))
    )
    (defun DPTF|URB_Flag:integer (id:string pending:bool)
        (at "flag" (DPTF|UR_Branding id pending))
    )
    (defun DPTF|URB_Genesis:time (id:string pending:bool)
        (at "genesis" (DPTF|UR_Branding id pending))
    )
    (defun DPTF|URB_PremiumUntil:time (id:string pending:bool)
        (at "premium-until" (DPTF|UR_Branding id pending))
    )
    (defun DPTF|UR_Konto:string (id:string)
        (at "owner-konto" (read DPTF|PropertiesTable id ["owner-konto"]))
    )
    (defun DPTF|UR_Name:string (id:string)
        (at "name" (read DPTF|PropertiesTable id ["name"]))
    )
    (defun DPTF|UR_Ticker:string (id:string)
        (at "ticker" (read DPTF|PropertiesTable id ["ticker"])) 
    )
    (defun DPTF|UR_Decimals:integer (id:string)
        (at "decimals" (read DPTF|PropertiesTable id ["decimals"]))
    )
    (defun DPTF|UR_CanChangeOwner:bool (id:string)
        (at "can-change-owner" (read DPTF|PropertiesTable id ["can-change-owner"]))
    )
    (defun DPTF|UR_CanUpgrade:bool (id:string)
        (at "can-upgrade" (read DPTF|PropertiesTable id ["can-upgrade"]))  
    )
    (defun DPTF|UR_CanAddSpecialRole:bool (id:string)
        (at "can-add-special-role" (read DPTF|PropertiesTable id ["can-add-special-role"]))
    )
    (defun DPTF|UR_CanFreeze:bool (id:string)
        (at "can-freeze" (read DPTF|PropertiesTable id ["can-freeze"]))
    )
    (defun DPTF|UR_CanWipe:bool (id:string)
        (at "can-wipe" (read DPTF|PropertiesTable id ["can-wipe"]))
    )
    (defun DPTF|UR_CanPause:bool (id:string)
        (at "can-pause" (read DPTF|PropertiesTable id ["can-pause"]))
    )
    (defun DPTF|UR_Paused:bool (id:string)
        (at "is-paused" (read DPTF|PropertiesTable id ["is-paused"]))
    )
    (defun DPTF|UR_Supply:decimal (id:string)
        (at "supply" (read DPTF|PropertiesTable id ["supply"]))
    )
    (defun DPTF|UR_OriginMint:bool (id:string)
        (at "origin-mint" (read DPTF|PropertiesTable id ["origin-mint"]))
    )
    (defun DPTF|UR_OriginAmount:decimal (id:string)
        (at "origin-mint-amount" (read DPTF|PropertiesTable id ["origin-mint-amount"]))
    )
    (defun DPTF|UR_TransferRoleAmount:integer (id:string)
        (at "role-transfer-amount" (read DPTF|PropertiesTable id ["role-transfer-amount"]))
    )
    (defun DPTF|UR_FeeToggle:bool (id:string)
        (at "fee-toggle" (read DPTF|PropertiesTable id ["fee-toggle"]))
    )
    (defun DPTF|UR_MinMove:decimal (id:string)
        (at "min-move" (read DPTF|PropertiesTable id ["min-move"]))
    )
    (defun DPTF|UR_FeePromile:decimal (id:string)
        (at "fee-promile" (read DPTF|PropertiesTable id ["fee-promile"]))
    )
    (defun DPTF|UR_FeeTarget:string (id:string)
        (at "fee-target" (read DPTF|PropertiesTable id ["fee-target"]))
    )
    (defun DPTF|UR_FeeLock:bool (id:string)
        (at "fee-lock" (read DPTF|PropertiesTable id ["fee-lock"]))
    )
    (defun DPTF|UR_FeeUnlocks:integer (id:string)
        (at "fee-unlocks" (read DPTF|PropertiesTable id ["fee-unlocks"]))
    )
    (defun DPTF|UR_PrimaryFeeVolume:decimal (id:string)
        (at "primary-fee-volume" (read DPTF|PropertiesTable id ["primary-fee-volume"]))
    )
    (defun DPTF|UR_SecondaryFeeVolume:decimal (id:string)
        (at "secondary-fee-volume" (read DPTF|PropertiesTable id ["secondary-fee-volume"]))
    )
    (defun DPTF|UR_RewardToken:[string] (id:string)
        (at "reward-token" (read DPTF|PropertiesTable id ["reward-token"]))
    )
    (defun DPTF|UR_RewardBearingToken:[string] (id:string)
        (at "reward-bearing-token" (read DPTF|PropertiesTable id ["reward-bearing-token"]))
    )
    (defun DPTF|UR_Vesting:string (id:string)
        (at "vesting" (read DPTF|PropertiesTable id ["vesting"]))
    )
    (defun DPTF|UR_Roles:[string] (id:string rp:integer)
        (if (= rp 1)
            (with-default-read DPTF|RoleTable id
                { "r-burn" : [UTILS.BAR]}
                { "r-burn" := rb }
                rb
            )
            (if (= rp 2)
                (with-default-read DPTF|RoleTable id
                    { "r-mint" : [UTILS.BAR]}
                    { "r-mint" := rm }
                    rm
                )
                (if (= rp 3)
                    (with-default-read DPTF|RoleTable id
                        { "r-fee-exemption" : [UTILS.BAR]}
                        { "r-fee-exemption" := rfe }
                        rfe
                    )
                    (if (= rp 4)
                        (with-default-read DPTF|RoleTable id
                            { "r-transfer" : [UTILS.BAR]}
                            { "r-transfer" := rt }
                            rt
                        )
                        (with-default-read DPTF|RoleTable id
                            { "a-frozen" : [UTILS.BAR]}
                            { "a-frozen" := af }
                            af
                        )
                    )
                )
            )
        )
    )
    (defun DPTF|UR_AccountSupply:decimal (id:string account:string)
        (if (DALOS|URC_IzCoreDPTF id)
            (if (= id (DALOS.DALOS|UR_OuroborosID))
                (DALOS.DALOS|UR_TF_AccountSupply account true)
                (DALOS.DALOS|UR_TF_AccountSupply account false)
            )
            (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "balance" : 0.0 }
                { "balance" := b}
                b
            )
        )
    )
    (defun DPTF|UR_AccountRoleBurn:bool (id:string account:string)
        (if (DALOS|URC_IzCoreDPTF id)
            (if (= id (DALOS.DALOS|UR_OuroborosID))
                (DALOS.DALOS|UR_TF_AccountRoleBurn account true)
                (DALOS.DALOS|UR_TF_AccountRoleBurn account false)
            )
            (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "role-burn" : false}
                { "role-burn" := rb }
                rb
            )
        )
    )
    (defun DPTF|UR_AccountRoleMint:bool (id:string account:string)
        (if (DALOS|URC_IzCoreDPTF id)
            (if (= id (DALOS.DALOS|UR_OuroborosID))
                (DALOS.DALOS|UR_TF_AccountRoleMint account true)
                (DALOS.DALOS|UR_TF_AccountRoleMint account false)
            )
            (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "role-mint" : false}
                { "role-mint" := rm }
                rm
            )
        )
    )
    (defun DPTF|UR_AccountRoleTransfer:bool (id:string account:string)
        (if (DALOS|URC_IzCoreDPTF id)
            (if (= id (DALOS.DALOS|UR_OuroborosID))
                (DALOS.DALOS|UR_TF_AccountRoleTransfer account true)
                (DALOS.DALOS|UR_TF_AccountRoleTransfer account false)
            )
            (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "role-transfer" : false}
                { "role-transfer" := rt }
                rt
            )
        )
    )
    (defun DPTF|UR_AccountRoleFeeExemption:bool (id:string account:string)
        (if (DALOS|URC_IzCoreDPTF id)
            (if (= id (DALOS.DALOS|UR_OuroborosID))
                (DALOS.DALOS|UR_TF_AccountRoleFeeExemption account true)
                (DALOS.DALOS|UR_TF_AccountRoleFeeExemption account false)
            )
            (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "role-fee-exemption" : false}
                { "role-fee-exemption" := rfe }
                rfe
            )
        )
    )
    (defun DPTF|UR_AccountFrozenState:bool (id:string account:string)
        (if (DALOS|URC_IzCoreDPTF id)
            (if (= id (DALOS.DALOS|UR_OuroborosID))
                (DALOS.DALOS|UR_TF_AccountFreezeState account true)
                (DALOS.DALOS|UR_TF_AccountFreezeState account false)
            )
            (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "frozen" : false}
                { "frozen" := fr }
                fr
            )
        )
    )
    ;;{13}
    (defun DPTF|URC_IzRT:bool (reward-token:string)
        (DPTF|UEV_id reward-token)
        (if (= (DPTF|UR_RewardToken reward-token) [UTILS.BAR])
            false
            true
        )
    )
    (defun DPTF|URC_IzRTg:bool (atspair:string reward-token:string)
        (DPTF|UEV_id reward-token)
        (if (= (DPTF|UR_RewardToken reward-token) [UTILS.BAR])
            false
            (if (= (contains atspair (DPTF|UR_RewardToken reward-token)) true)
                true
                false
            )
        )
    )
    (defun DPTF|URC_IzRBT:bool (reward-bearing-token:string)
        (DPTF|UEV_id reward-bearing-token)
        (if (= (DPTF|UR_RewardBearingToken reward-bearing-token) [UTILS.BAR])
            false
            true
        )
    )
    (defun DPTF|URC_IzRBTg:bool (atspair:string reward-bearing-token:string)
        (DPTF|UEV_id reward-bearing-token)
        (if (= (DPTF|UR_RewardBearingToken reward-bearing-token) [UTILS.BAR])
            false
            (if (contains atspair (DPTF|UR_RewardBearingToken reward-bearing-token))
                true
                false
            )
        )
    )
    (defun DALOS|URC_IzCoreDPTF:bool (id:string)
        (DPTF|UEV_id id)
        (let*
            (
                (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                (ignis-id:string (DALOS.DALOS|UR_IgnisID))
                (iz-ouro-defined:bool (not (= ouro-id UTILS.BAR)))
                (iz-ignis-defined:bool (not (= ignis-id UTILS.BAR)))
            )
            (if (not iz-ouro-defined)
                (if (not iz-ignis-defined)
                        false
                        (= id ignis-id)
                    )
                (if (= id ouro-id)
                    true
                    (if (not iz-ignis-defined)
                        false
                        (= id ignis-id)
                    )
                )
            )
        )
    )
    (defun DPTF|URC_AccountExist:bool (id:string account:string)
        (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
            { "balance" : -1.0 }
            { "balance" := b}
            (if (= b -1.0)
                false
                true
            )
        )
    )
    (defun DPTF|URC_Fee:[decimal] (id:string amount:decimal)
        (let
            (
                (fee-toggle:bool (DPTF|UR_FeeToggle id))
            )
            (if (= fee-toggle false)
                [0.0 0.0 amount]
                (let*
                    (
                        (precision:integer (DPTF|UR_Decimals id))
                        (fee-promile:decimal (DPTF|UR_FeePromile id))
                        (fee-unlocks:integer (DPTF|UR_FeeUnlocks id))
                        (volumetric-fee:decimal (DPTF|UC_VolumetricTax id amount))
                        (primary-fee-value:decimal 
                            (if (= fee-promile -1.0)
                                volumetric-fee
                                (floor (* (/ fee-promile 1000.0) amount) precision)
                            ) 
                        )
                        (secondary-fee-value:decimal 
                            (if (= fee-unlocks 0)
                                0.0
                                (* (dec fee-unlocks) volumetric-fee)
                            )
                        )
                        (remainder:decimal (- amount (+ primary-fee-value secondary-fee-value)))
                    )
                    [primary-fee-value secondary-fee-value remainder]
                )
            )
        )
    )
    (defun DPTF|URC_TrFeeMinExc:bool (id:string sender:string receiver:string)
        (let*
            (
                (gas-id:string (DALOS.DALOS|UR_IgnisID))
                (sender-fee-exemption:bool (DPTF|UR_AccountRoleFeeExemption id sender))
                (receiver-fee-exemption:bool (DPTF|UR_AccountRoleFeeExemption id receiver))
                (token-owner:string (DPTF|UR_Konto id))
                (sender-t1:bool (or (= sender DALOS.OUROBOROS|SC_NAME) (= sender DALOS.DALOS|SC_NAME)))
                (sender-t2:bool (or (= sender token-owner)(= sender-fee-exemption true)))
                (iz-sender-exception:bool (or sender-t1 sender-t2))
                (receiver-t1:bool (or (= receiver DALOS.OUROBOROS|SC_NAME) (= receiver DALOS.DALOS|SC_NAME)))
                (receiver-t2:bool (or (= receiver token-owner)(= receiver-fee-exemption true)))
                (iz-receiver-exception:bool (or receiver-t1 receiver-t2))
                (are-members-exception (or iz-sender-exception iz-receiver-exception))
                (is-id-gas:bool (= id gas-id))
                (iz-exception:bool (or is-id-gas are-members-exception ))
            )
            iz-exception
        )
    )
    (defun DPTF|URC_HasVesting:bool (id:string)
        (if (= (DPTF|UR_Vesting id) UTILS.BAR)
            false
            true
        )
    )
    ;;
    ;;{14}
    ;;{15}
    (defun DPTF|C_RtOwn (patron:string id:string new-owner:string)
        (with-capability (DPTF|S>RT_OWN id new-owner)
            (DPTF|X_ChangeOwnership id new-owner)
            (DALOS.IGNIS|C_Collect patron (DPTF|UR_Konto id) (DALOS.DALOS|UR_UsagePrice "ignis|biggest"))
        )
    )
    (defun DPTF|C_DeployAccount (id:string account:string)
        (DALOS.DALOS|UEV_EnforceAccountExists account)
        (DPTF|UEV_id id)
        (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
            { "balance"                             : 0.0
            , "role-burn"                           : false
            , "role-mint"                           : false
            , "role-transfer"                       : false
            , "role-fee-exemption"                  : false
            , "frozen"                              : false}
            { "balance"                             := b
            , "role-burn"                           := rb
            , "role-mint"                           := rm
            , "role-transfer"                       := rt
            , "role-fee-exemption"                  := rfe
            , "frozen"                              := f}
            (write DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "balance"                         : b
                , "role-burn"                       : rb
                , "role-mint"                       : rm
                , "role-transfer"                   : rt
                , "role-fee-exemption"              : rfe
                , "frozen"                          : f}
            )
        )
    )
    (defun DPTF|C_TgFreezeAccount (patron:string id:string account:string toggle:bool)
        (with-capability (DPTF|FC>FRZ-ACC id account toggle)
            (DPTF|X_ToggleFreezeAccount id account toggle)
            (DPTF|X_WriteRoles id account 5 toggle)
            (DALOS.IGNIS|C_Collect patron account (DALOS.DALOS|UR_UsagePrice "ignis|big"))
        )
    )
    (defun DPTF|C_TgPause (patron:string id:string toggle:bool)
        (with-capability (DPTF|S>TG_PAUSE id toggle)
            (DPTF|X_TogglePause id toggle)
            (DALOS.IGNIS|C_Collect patron patron (DALOS.DALOS|UR_UsagePrice "ignis|medium"))
        )
    )
    (defun DPTF|C_TgTransferR (patron:string id:string account:string toggle:bool)
        (with-capability (DPTF|C>TG_TRANSFER-R id account toggle)
            (DPTF|X_ToggleTransferRole id account toggle)
            (DPTF|X_UpdateRoleTransferAmount id toggle)
            (DPTF|X_WriteRoles id account 4 toggle)
            (DALOS.IGNIS|C_Collect patron account (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun DPTF|C_Wipe (patron:string id:string atbw:string)
        (with-capability (DPTF|C>WIPE id atbw)
            (DPTF|X_Wipe id atbw)
            (DALOS.IGNIS|C_CollectWT patron atbw (DALOS.DALOS|UR_UsagePrice "ignis|biggest") (DALOS.IGNIS|URC_ZeroGAS id atbw))
        )
    )
    (defun DPTF|C_Burn (patron:string id:string account:string amount:decimal)
        (with-capability (DPTF|C>BURN id account amount)
            (DPTF|X_BurnCore id account amount)
            (DALOS.IGNIS|C_CollectWT patron account (DALOS.DALOS|UR_UsagePrice "ignis|small") (DALOS.IGNIS|URC_ZeroGAS id account))
        )
    )
    (defun DPTF|C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool)
        (with-capability (DPTF|S>CTRL id true)
            (DPTF|X_Control patron id cco cu casr cf cw cp)
            (DALOS.IGNIS|C_Collect patron (DPTF|UR_Konto id) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun DPTF|C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
        (enforce-guard (P|UR "TALOS|Summoner"))
        (let*
            (
                (l1:integer (length name))
                (tl:[bool] (make-list l1 false))
                (tf-cost:decimal (DALOS.DALOS|UR_UsagePrice "dptf"))
                (kda-costs:decimal (* (dec l1) tf-cost))
                (issued-ids:[string]
                    (with-capability (SECURE)
                        (DPTF|X_IssueFree patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause tl)
                    )
                )
            )
            (DALOS.KDA|C_Collect patron kda-costs)
            issued-ids
        )
    )
    (defun DPTF|C_IssueLP:string (patron:string account:string name:string ticker:string)
        (enforce-guard (P|UR "SWPI|Caller"))
        (with-capability (SECURE)
            (at 0 (DPTF|X_IssueFree patron account [name] [ticker] [24] [false] [false] [true] [false] [false] [false] [true]))
        )
    )
    (defun DPTF|C_Mint (patron:string id:string account:string amount:decimal origin:bool)
        (with-capability (DPTF|C>MINT id account amount origin)
            (let
                (
                    (price:decimal
                        (if origin
                            (DALOS.DALOS|UR_UsagePrice "ignis|biggest")
                            (DALOS.DALOS|UR_UsagePrice "ignis|small")
                        )
                    )
                )
                (DALOS.IGNIS|C_CollectWT patron account price (DALOS.IGNIS|URC_ZeroGAS id account))
                (DPTF|X_Mint id account amount origin)
            )
        )
    )
    (defun DPTF|C_SetFee (patron:string id:string fee:decimal)
        (with-capability (DPTF|S>SET_FEE id fee)
            (DPTF|X_SetFee id fee)
            (DALOS.IGNIS|C_Collect patron (DPTF|UR_Konto id) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun DPTF|C_SetFeeTarget (patron:string id:string target:string)
        (with-capability (DPTF|S>SET_FEE-TARGET id target)
            (DPTF|X_SetFeeTarget id target)
            (DALOS.IGNIS|C_Collect patron (DPTF|UR_Konto id) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun DPTF|C_SetMinMove (patron:string id:string min-move-value:decimal)
        (with-capability (DPTF|S>SET_MIN-MOVE id min-move-value)
            (DPTF|X_SetMinMove id min-move-value)
            (DALOS.IGNIS|C_Collect patron (DPTF|UR_Konto id) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun DPTF|C_ToggleFee (patron:string id:string toggle:bool)
        (with-capability (DPTF|S>TG_FEE id toggle)
            (DPTF|X_ToggleFee id toggle)
            (DALOS.IGNIS|C_Collect patron (DPTF|UR_Konto id) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun DPTF|C_ToggleFeeLock (patron:string id:string toggle:bool)
        (enforce-guard (P|UR "TALOS|Summoner"))
        (with-capability (DPTF|C>TG_FEE-LOCK id toggle)
            (let*
                (
                    (token-owner:string (DPTF|UR_Konto id))
                    (g1:decimal (DALOS.DALOS|UR_UsagePrice "ignis|small"))
                    (toggle-costs:[decimal] (DPTF|X_ToggleFeeLock id toggle))
                    (g2:decimal (at 0 toggle-costs))
                    (gas-costs:decimal (+ g1 g2))
                    (kda-costs:decimal (at 1 toggle-costs))
                )
                (DALOS.IGNIS|C_Collect patron token-owner gas-costs)
                (if (> kda-costs 0.0)
                    (do
                        (DPTF|X_IncrementFeeUnlocks id)
                        (DALOS.KDA|C_Collect patron kda-costs)
                    )
                    true
                )
            )
        )
    )
    ;;{16}
    (defun DPTF|X_IssueFree:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] iz-lp:[bool])
        (require-capability (SECURE))
        (with-capability (DPTF|C>ISSUE account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause)
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
                                            (DPTF|X_Issue 
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
                                                (at index iz-lp)
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
    (defun DPTF|X_UpdateBranding (id:string pending:bool branding:object{DALOS.BrandingSchema})
        (enforce-guard (P|UR "BRD|Update"))
        (if pending
            (update DPTF|PropertiesTable id
                {"branding-pending" : branding}
            )
            (update DPTF|PropertiesTable id
                {"branding" : branding}
            )
        )
    )
    (defun DPTF|X_ChangeOwnership (id:string new-owner:string)
        (require-capability (DPTF|S>RT_OWN id new-owner))
        (update DPTF|PropertiesTable id
            {"owner-konto"                      : new-owner}
        )
    )
    (defun DPTF|X_ToggleFreezeAccount (id:string account:string toggle:bool)
        (require-capability (DPTF|S>X_FRZ-ACC id account toggle))
        (if (DALOS|URC_IzCoreDPTF id)
            (with-capability (P|DALOS|UP_DATA)
                (DALOS.DALOS|X_UpdateFreeze account (= id (DALOS.DALOS|UR_OuroborosID)) toggle)
            )
            (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "frozen" : toggle}
            )
        )
    )
    (defun DPTF|X_TogglePause (id:string toggle:bool)
        (require-capability (DPTF|S>TG_PAUSE id toggle))
        (update DPTF|PropertiesTable id
            { "is-paused" : toggle}
        )
    )
    (defun DPTF|X_ToggleTransferRole (id:string account:string toggle:bool)
        (require-capability (DPTF|S>X_TG_TRANSFER-R id account toggle))
        (if (DALOS|URC_IzCoreDPTF id)
            (with-capability (P|DALOS|UP_DATA)
                (DALOS.DALOS|X_UpdateTransferRole account (= id (DALOS.DALOS|UR_OuroborosID)) toggle)
            )
            (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                {"role-transfer" : toggle}
            )
        )
    )
    
    (defun DPTF|X_UpdateRoleTransferAmount (id:string direction:bool)
        (require-capability (DPTF|UPRL-TA))
        (if (= direction true)
            (with-read DPTF|PropertiesTable id
                { "role-transfer-amount" := rta }
                (update DPTF|PropertiesTable id
                    {"role-transfer-amount" : (+ rta 1)}
                )
            )
            (with-read DPTF|PropertiesTable id
                { "role-transfer-amount" := rta }
                (update DPTF|PropertiesTable id
                    {"role-transfer-amount" : (- rta 1)}
                )
            )
        )
    )
    (defun DPTF|X_UpdateSupply (id:string amount:decimal direction:bool)
        (require-capability (DPTF|UP_SPLY))
        (DPTF|UEV_Amount id amount)
        (if (= direction true)
            (with-read DPTF|PropertiesTable id
                { "supply" := s }
                (enforce (>= (+ s amount) 0.0) "DPTF Token Supply cannot be updated to negative values!")
                (update DPTF|PropertiesTable id { "supply" : (+ s amount)})
            )
            (with-read DPTF|PropertiesTable id
                { "supply" := s }
                (enforce (>= (- s amount) 0.0) "DPTF Token Supply cannot be updated to negative values!")
                (update DPTF|PropertiesTable id { "supply" : (- s amount)})
            )
        )
    )
    (defun DPTF|X_Wipe (id:string account-to-be-wiped:string)
        (require-capability (DPTF|C>WIPE id account-to-be-wiped))
        (let
            (
                (amount-to-be-wiped:decimal (DPTF|UR_AccountSupply id account-to-be-wiped))
            )
            (DPTF|X_DebitAdmin id account-to-be-wiped amount-to-be-wiped)
            (DPTF|X_UpdateSupply id amount-to-be-wiped false)
        )
    )
    (defun DPTF|X_ToggleBurnRole (id:string account:string toggle:bool)
        (enforce-guard (P|UR "ATSI|TgBrRl"))
        (with-capability (DPTF|S>TG_BURN-R id account toggle)
            (if (DALOS|URC_IzCoreDPTF id)
                (with-capability (P|DALOS|UP_DATA)
                    (DALOS.DALOS|X_UpdateBurnRole account (= id (DALOS.DALOS|UR_OuroborosID)) toggle)
                )
                (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                    {"role-burn" : toggle}
                )
            )
        )
    )
    (defun DPTF|X_UpdateRewardBearingToken (atspair:string id:string)
        (enforce-guard (P|UR "ATSI|Caller"))
        (with-read DPTF|PropertiesTable id
            {"reward-bearing-token" := rbt}
            (if (= (at 0 rbt) UTILS.BAR)
                (update DPTF|PropertiesTable id
                    {"reward-bearing-token" : [atspair]}
                )
                (update DPTF|PropertiesTable id
                    {"reward-bearing-token" : (UTILS.LIST|UC_AppendLast rbt atspair)}
                )
            )
        )
    )
    (defun DPTF|X_UpdateVesting (dptf:string dpmf:string)
        (enforce-guard (P|UR "DPMF|UpVes"))
        (update DPTF|PropertiesTable dptf
            {"vesting" : dpmf}
        )
    )
    (defun DPTF|X_Control (id:string can-change-owner:bool can-upgrade:bool can-add-special-role:bool can-freeze:bool can-wipe:bool can-pause:bool)
        (require-capability (DPTF|S>CTRL id true))
        (update DPTF|PropertiesTable id
            {"can-change-owner"                 : can-change-owner
            ,"can-upgrade"                      : can-upgrade
            ,"can-add-special-role"             : can-add-special-role
            ,"can-freeze"                       : can-freeze
            ,"can-wipe"                         : can-wipe
            ,"can-pause"                        : can-pause}
        )
    )
    (defun DPTF|X_Issue:string 
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
            iz-lp:bool
        )
        (UTILS.DALOS|UEV_Decimals decimals)
        (UTILS.DALOS|UEV_NameOrTicker name true iz-lp)
        (UTILS.DALOS|UEV_NameOrTicker ticker false iz-lp)
        (require-capability (SECURE))
        (insert DPTF|PropertiesTable (DALOS.DALOS|UC_Makeid ticker)
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
                ,"supply"               : 0.0
                ,"origin-mint"          : false
                ,"origin-mint-amount"   : 0.0
                ,"role-transfer-amount" : 0
                ,"fee-toggle"           : false
                ,"min-move"             : -1.0
                ,"fee-promile"          : 0.0
                ,"fee-target"           : DALOS.OUROBOROS|SC_NAME
                ,"fee-lock"             : false
                ,"fee-unlocks"          : 0
                ,"primary-fee-volume"   : 0.0
                ,"secondary-fee-volume" : 0.0
                ,"reward-token"         : [UTILS.BAR]
                ,"reward-bearing-token" : [UTILS.BAR]
                ,"vesting"              : UTILS.BAR
            }
        )
        (DPTF|C_DeployAccount (DALOS.DALOS|UC_Makeid ticker) account)    
        (DALOS.DALOS|UC_Makeid ticker)
    )
    (defun DPTF|X_Mint (id:string account:string amount:decimal origin:bool)
        (if origin
            (require-capability (DPTF|C>MINT-ORG id amount ))
            (require-capability (DPTF|C>MINT-STD id account amount))
        )
        (DPTF|X_Credit id account amount)
        (DPTF|X_UpdateSupply id amount true)
        (if origin
            (update DPTF|PropertiesTable id
                { "origin-mint" : false
                , "origin-mint-amount" : amount}
            )
            true
        )
    )
    (defun DPTF|X_SetFee (id:string fee:decimal)
        (require-capability (DPTF|S>SET_FEE id fee))
        (update DPTF|PropertiesTable id
            { "fee-promile" : fee}
        )
    )
    (defun DPTF|X_SetFeeTarget (id:string target:string)
        (require-capability (DPTF|S>SET_FEE-TARGET id target))
        (update DPTF|PropertiesTable id
            { "fee-target" : target}
        )
    )
    (defun DPTF|X_SetMinMove (id:string min-move-value:decimal)
        (require-capability (DPTF|S>SET_MIN-MOVE id min-move-value))
        (update DPTF|PropertiesTable id
            { "min-move" : min-move-value}
        )
    )
    (defun DPTF|X_ToggleFee (id:string toggle:bool)
        (require-capability (DPTF|S>TG_FEE id toggle))
        (update DPTF|PropertiesTable id
            { "fee-toggle" : toggle}
        )
    )
    (defun DPTF|X_ToggleFeeLock:[decimal] (id:string toggle:bool)
        (require-capability (DPTF|S>X_TG_FEE-LOCK id toggle))
        (update DPTF|PropertiesTable id
            { "fee-lock" : toggle}
        )
        (if (= toggle true)
            [0.0 0.0]
            (UTILS.DPTF|UC_UnlockPrice (DPTF|UR_FeeUnlocks id))
        )
    )
    (defun DPTF|X_IncrementFeeUnlocks (id:string)
        (require-capability (DPTF|INCR-LOCKS))
        (with-read DPTF|PropertiesTable id
            { "fee-unlocks" := fu }
            (enforce (< fu 7) (format "Cannot increment Fee Unlocks for Token {}" [id]))
            (update DPTF|PropertiesTable id
                {"fee-unlocks" : (+ fu 1)}
            )
        )
    )
    (defun DPTF|X_Burn (id:string account:string amount:decimal)
        (enforce-guard (P|UR "TFT|BrTF"))
        (with-capability (DPTF|C>BURN id account amount)
            (DPTF|X_BurnCore id account amount)
        )
    )
    (defun DPTF|X_BurnCore (id:string account:string amount:decimal)
        (require-capability (DPTF|C>BURN id account amount))
        (DPTF|X_DebitStandard id account amount)
        (DPTF|X_UpdateSupply id amount false)
    )
    (defun DPTF|X_Credit (id:string account:string amount:decimal)
        (enforce-one
            "Credit Not permitted"
            [
                (enforce-guard (create-capability-guard (DPTF|CREDIT)))
                (enforce-guard (P|UR "TFT|CrTF"))
            ]
        )
        (if (DALOS|URC_IzCoreDPTF id)
            (let*
                (
                    (snake-or-gas:bool (if (= id (DALOS.DALOS|UR_OuroborosID)) true false))
                    (read-balance:decimal (DALOS.DALOS|UR_TF_AccountSupply account snake-or-gas))
                )
                (enforce (>= read-balance 0.0) "Impossible operation, negative Primordial TrueFungible amounts detected")
                (enforce (> amount 0.0) "Crediting amount must be greater than zero, even for Primordial TrueFungibles")
                (with-capability (P|DALOS|UP_BLC)
                    (DALOS.DALOS|X_UpdateBalance account snake-or-gas (+ read-balance amount))
                )
            )
            (let
                (
                    (dptf-account-exist:bool (DPTF|URC_AccountExist id account))
                )
                (enforce (> amount 0.0) "Crediting amount must be greater than zero")
                (if (= dptf-account-exist false)
                    (insert DPTF|BalanceTable (concat [id UTILS.BAR account])
                        { "balance"                         : amount
                        , "role-burn"                       : false
                        , "role-mint"                       : false
                        , "role-transfer"                   : false
                        , "role-fee-exemption"              : false
                        , "frozen"                          : false
                        }
                    )
                    (with-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                        { "balance"                         := b
                        , "role-burn"                       := rb
                        , "role-mint"                       := rm
                        , "role-transfer"                   := rt
                        , "role-fee-exemption"              := rfe
                        , "frozen"                          := f
                        }
                        (write DPTF|BalanceTable (concat [id UTILS.BAR account])
                            { "balance"                     : (+ b amount)
                            , "role-burn"                   : rb
                            , "role-mint"                   : rm
                            , "role-transfer"               : rt
                            , "role-fee-exemption"          : rfe
                            , "frozen"                      : f
                            }   
                        )
                    )
                )
            )
        )
    )
    (defun DPTF|X_DebitAdmin (id:string account:string amount:decimal)
        (require-capability (DPTF|DEBIT))
        (with-capability (DPTF|DEBIT_PUR)
            (DPTF|CAP_Owner id)
            (DPTF|X_Debit id account amount)
        )
    )
    (defun DPTF|X_DebitStandard (id:string account:string amount:decimal)
        (enforce-one
            "Standard Debit Not permitted"
            [
                (enforce-guard (create-capability-guard (DPTF|DEBIT)))
                (enforce-guard (P|UR "TFT|DbTF"))
            ]
        )
        (with-capability (DPTF|DEBIT_PUR)
            (DALOS.DALOS|CAP_EnforceAccountOwnership account)
            (DPTF|X_Debit id account amount)
        )
    )
    (defun DPTF|X_Debit (id:string account:string amount:decimal)
        (require-capability (DPTF|DEBIT_PUR))
        (if (DALOS|URC_IzCoreDPTF id)
            (let*
                (
                    (snake-or-gas:bool (if (= id (DALOS.DALOS|UR_OuroborosID)) true false))
                    (read-balance:decimal (DALOS.DALOS|UR_TF_AccountSupply account snake-or-gas))
                )
                (enforce (>= read-balance 0.0) "Impossible operation, negative Primordial TrueFungible amounts detected")
                (enforce (<= amount read-balance) "Insufficient Funds for debiting")
                (with-capability (P|DALOS|UP_BLC)
                    (DALOS.DALOS|X_UpdateBalance account snake-or-gas (- read-balance amount))
                )
            )
            (with-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "balance" := balance }
                (enforce (<= amount balance) "Insufficient Funds for debiting")
                (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                    {"balance" : (- balance amount)}    
                )
            )
        )
    )
    (defun DPTF|X_ToggleFeeExemptionRole (id:string account:string toggle:bool)
        (enforce-guard (P|UR "ATSI|TgFeRl"))
        (with-capability (DPTF|S>TG_FEE-EXEMP-R id account toggle)
            (if (DALOS|URC_IzCoreDPTF id)
                (with-capability (P|DALOS|UP_DATA)
                    (DALOS.DALOS|X_UpdateFeeExemptionRole account (= id (DALOS.DALOS|UR_OuroborosID)) toggle)
                )
                (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                    {"role-fee-exemption" : toggle}
                )
            )
        )
    )
    (defun DPTF|X_ToggleMintRole (id:string account:string toggle:bool)
        (enforce-guard (P|UR "ATSI|TgMnRl"))
        (with-capability (DPTF|S>TG_MINT-R id account toggle)
            (if (DALOS|URC_IzCoreDPTF id)
                (with-capability (P|DALOS|UP_DATA)
                    (DALOS.DALOS|X_UpdateMintRole account (= id (DALOS.DALOS|UR_OuroborosID)) toggle)
                )
                (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                    {"role-mint" : toggle}
                )
            )
        )
    )
    (defun DPTF|X_UpdateFeeVolume (id:string amount:decimal primary:bool)
        (enforce-guard (P|UR "TFT|UpFees"))
        (DPTF|UEV_Amount id amount)
        (if primary
            (with-read DPTF|PropertiesTable id
                { "primary-fee-volume" := pfv }
                (update DPTF|PropertiesTable id
                    {"primary-fee-volume" : (+ pfv amount)}
                )
            )
            (with-read DPTF|PropertiesTable id
                { "secondary-fee-volume" := sfv }
                (update DPTF|PropertiesTable id
                    {"secondary-fee-volume" : (+ sfv amount)}
                )
            )
        )
    )
    (defun DPTF|X_UpdateRewardToken (atspair:string id:string direction:bool)
        (enforce-one
            "Invalid Permissions to update Reward Token"
            [
                (enforce-guard (P|UR "ATSI|Caller"))
                (enforce-guard (P|UR "ATSM|Caller"))
            ]
        )
        (with-read DPTF|PropertiesTable id
            {"reward-token" := rt}
            (if (= direction true)
                (if (= (at 0 rt) UTILS.BAR)
                    (update DPTF|PropertiesTable id
                        {"reward-token" : [atspair]}
                    )
                    (update DPTF|PropertiesTable id
                        {"reward-token" : (UTILS.LIST|UC_AppendLast rt atspair)}
                    )
                )
                (update DPTF|PropertiesTable id
                    {"reward-token" : (UTILS.LIST|UC_RemoveItem rt atspair)}
                )
            )
        )
    )
    (defun DPTF|X_WriteRoles (id:string account:string rp:integer d:bool)
        (enforce-one
            "Invalid Permissions to update Reward Token"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "ATSI|WR"))
            ]
        )
        (with-capability (BASIS|C>X_WRITE-ROLES id account rp)
            (with-default-read DPTF|RoleTable id
                { "r-burn"          : [UTILS.BAR]
                , "r-mint"          : [UTILS.BAR]
                , "r-fee-exemption" : [UTILS.BAR]
                , "r-transfer"      : [UTILS.BAR]
                , "a-frozen"        : [UTILS.BAR]}
                { "r-burn"          := rb
                , "r-mint"          := rm
                , "r-fee-exemption" := rfe
                , "r-transfer"      := rt
                , "a-frozen"        := af}
                (if (= rp 1)
                    (write DPTF|RoleTable id
                        {"r-burn"           : (UTILS.BASIS|UC_NewRoleList rb account d)
                        , "r-mint"          : rm
                        , "r-fee-exemption" : rfe
                        , "r-transfer"      : rt
                        , "a-frozen"        : af}
                    )
                    (if (= rp 2)
                        (write DPTF|RoleTable id
                            {"r-burn"           : rb
                            , "r-mint"          : (UTILS.BASIS|UC_NewRoleList rm account d)
                            , "r-fee-exemption" : rfe
                            , "r-transfer"      : rt
                            , "a-frozen"        : af}
                        )
                        (if (= rp 3)
                            (write DPTF|RoleTable id
                                {"r-burn"           : rb
                                , "r-mint"          : rm
                                , "r-fee-exemption" : (UTILS.BASIS|UC_NewRoleList rfe account d)
                                , "r-transfer"      : rt
                                , "a-frozen"        : af}
                            )
                            (if (= rp 4)
                                (write DPTF|RoleTable id
                                    {"r-burn"           : rb
                                    , "r-mint"          : rm
                                    , "r-fee-exemption" : rfe
                                    , "r-transfer"      : (UTILS.BASIS|UC_NewRoleList rt account d)
                                    , "a-frozen"        : af}
                                )
                                (write DPTF|RoleTable id
                                    {"r-burn"           : rb
                                    , "r-mint"          : rm
                                    , "r-fee-exemption" : rfe
                                    , "r-transfer"      : rt
                                    , "a-frozen"        : (UTILS.BASIS|UC_NewRoleList af account d)}
                                )
                            )
                        )
                    )
                )
            )
        )
    )
)

(create-table P|T)
(create-table DPTF|PropertiesTable)
(create-table DPTF|BalanceTable)
(create-table DPTF|RoleTable)