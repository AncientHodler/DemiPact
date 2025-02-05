;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module DPTF GOV
    ;;
    (implements OuronetPolicy)
    (implements DemiourgosPactTrueFungible)
    ;;{G1}
    (defconst GOV|MD_DPTF           (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|DPTF_ADMIN)))
    (defcap GOV|DPTF_ADMIN ()       (enforce-guard GOV|MD_DPTF))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;{P1}
    ;(defschema P|S
    ;    policy:guard
    ;)
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S}) 
    ;;{P3}
    (defcap P|DALOS|UP_BLC ()
        true
    )
    (defcap P|DALOS|UP_DATA ()
        true
    )
    (defcap P|DPTF|BRD ()
        true
    )
    (defcap P|DPTF|CALLER ()
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
        (let
            (
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|BRD:module{OuronetPolicy} BRD)
            )
            (ref-P|DALOS::P|A_Add 
                "DPTF|UpdatePrimordialBalance"
                (create-capability-guard (P|DALOS|UP_BLC))
            )
            (ref-P|DALOS::P|A_Add 
                "DPTF|UpdatePrimordialData"
                (create-capability-guard (P|DALOS|UP_DATA))
            )
            (ref-P|BRD::P|A_Add 
                "DPTF|Branding"
                (create-capability-guard (P|DPTF|BRD))
            )
            (ref-P|BRD::P|A_Add 
                "DPTF|Caller"
                (create-capability-guard (P|DPTF|CALLER))
            )
        )
    )
    ;;
    ;;{1}
    (defschema DPTF|PropertiesSchema
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
    (deftable DPTF|BalanceTable:{OuronetDalos.DPTF|BalanceSchema})
    (deftable DPTF|RoleTable:{DPTF|RoleSchema})
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    ;;
    ;;{C1}
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
    ;;{C2}
    (defcap DPTF|S>CTRL (id:string)
        @event
        (CAP_Owner id)
        (UEV_CanUpgradeON id)
    )
    (defcap DPTF|S>X_FRZ-ACC (id:string account:string frozen:bool)
        (CAP_Owner id)
        (UEV_CanFreezeON id)
        (UEV_AccountFreezeState id account (not frozen))
    )
    (defcap DPTF|S>RT_OWN (id:string new-owner:string)
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
    (defcap DPTF|S>TG_BURN-R (id:string account:string toggle:bool)
        @event
        (if toggle
            (UEV_CanAddSpecialRoleON id)
            true
        )
        (CAP_Owner id)
        (UEV_AccountBurnState id account (not toggle))
    )
    (defcap DPTF|S>TG_PAUSE (id:string pause:bool)
        @event
        (if pause
            (UEV_CanPauseON id)
            true
        )
        (CAP_Owner id)
        (UEV_PauseState id (not pause))
    )
    (defcap DPTF|S>X_TG_TRANSFER-R (id:string account:string toggle:bool)
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
    (defcap DPTF|S>SET_FEE (id:string fee:decimal)
        @event
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
            )
            (ref-U|DALOS::UEV_Fee fee)
            (CAP_Owner id)
            (UEV_FeeLockState id false)
        )
    )
    (defcap DPTF|S>SET_FEE-TARGET (id:string target:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::UEV_EnforceAccountExists target)
            (CAP_Owner id)
            (UEV_FeeLockState id false) 
        )
    )
    (defcap DPTF|S>SET_MIN-MOVE (id:string min-move-value:decimal)
        @event
        (let
            (
                (decimals:integer (UR_Decimals id))
            )
            (enforce
                (= (floor min-move-value decimals) min-move-value)
                (format "Min tr amount {} does not conform with the {} DPTF dec. no." [min-move-value id])
            )
            (enforce (or (= min-move-value -1.0) (> min-move-value 0.0)) "Min-Move Value does not compute")
            (CAP_Owner id)
            (UEV_FeeLockState id false)
        )
    )
    (defcap DPTF|S>TG_FEE (id:string toggle:bool)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (fee-promile:decimal (UR_FeePromile id))
            )
            (enforce (or (= fee-promile -1.0) (and (>= fee-promile 0.0) (<= fee-promile 1000.0))) "Please Set up Fee Promile before Turning Fee Collection on !")
            (ref-DALOS::UEV_EnforceAccountExists (UR_FeeTarget id))
            (CAP_Owner id)
            (UEV_FeeLockState id false)
            (UEV_FeeToggleState id (not toggle))
        )
    )
    (defcap DPTF|S>TG_FEE-EXEMP-R (id:string account:string toggle:bool)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::UEV_EnforceAccountType account true)
            (UEV_AccountFeeExemptionState id account (not toggle))
            (CAP_Owner id)
            (if toggle
                (UEV_CanAddSpecialRoleON id)
                true
            )
        )
    )
    (defcap DPTF|S>X_TG_FEE-LOCK (id:string toggle:bool)
        (CAP_Owner id)
        (UEV_FeeLockState id (not toggle))
    )
    (defcap DPTF|S>TG_MINT-R (id:string account:string toggle:bool)
        @event
        (UEV_AccountMintState id account (not toggle))
        (CAP_Owner id)
        (if toggle
            (UEV_CanAddSpecialRoleON id)
            true
        )
    )
    ;;{C3}
    ;;{C4}
    (defcap DPTF|C>UPDATE-BRD (id:string)
        @event
        (CAP_Owner id)
        (compose-capability (P|DPTF|CALLER))
    )
    (defcap DPTF|C>UPGRADE-BRD (id:string)
        @event
        (compose-capability (P|DPTF|CALLER))
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
    (defcap DPTF|C>BURN (id:string client:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership client)
            (UEV_Amount id amount)
            (UEV_AccountBurnState id client true)
            (compose-capability (DPTF|DEBIT))
            (compose-capability (DPTF|UP_SPLY))
        )
    )
    (defcap DPTF|FC>FRZ-ACC (id:string account:string frozen:bool)
        @event
        (compose-capability (DPTF|S>X_FRZ-ACC id account frozen))
        (compose-capability (BASIS|C>X_WRITE-ROLES id account 5))
    )
    (defcap DPTF|C>ISSUE (account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
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
                (lengths:[integer] [l1 l2 l3 l4 l5 l6 l7 l8 l9])
            )
            (ref-U|INT::UEV_UniformList lengths)
            (ref-U|LST::UC_IzUnique name)
            (ref-U|LST::UC_IzUnique ticker)
            (ref-DALOS::CAP_EnforceAccountOwnership account)
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
        (UEV_CanWipeON id)
        (UEV_AccountFreezeState id account-to-be-wiped true)
        (compose-capability (DPTF|DEBIT))
        (compose-capability (DPTF|UP_SPLY))
    )
    (defcap DPTF|C>MINT (id:string client:string amount:decimal origin:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership client)
            (if origin
                (compose-capability (DPTF|C>MINT-ORG id amount))
                (compose-capability (DPTF|C>MINT-STD id client amount))
            )
        )
    )
    (defcap DPTF|C>MINT-ORG (id:string amount:decimal)
        @event
        (CAP_Owner id)
        (UEV_Virgin id)
        (compose-capability (DPTF|C>MINT_GNRL id amount))
    )
    (defcap DPTF|C>MINT-STD (id:string client:string amount:decimal)
        @event
        (UEV_AccountMintState id client true)
        (compose-capability (DPTF|C>MINT_GNRL id amount))
    )
    (defcap DPTF|C>MINT_GNRL (id:string amount:decimal)
        (UEV_Amount id amount)
        (compose-capability (DPTF|CREDIT))
        (compose-capability (DPTF|UP_SPLY))
    )
    (defcap DPTF|C>TG_FEE-LOCK (id:string toggle:bool)
        @event
        (compose-capability (DPTF|S>X_TG_FEE-LOCK id toggle))
        (compose-capability (DPTF|INCR-LOCKS))
    )
    ;;
    ;;{F-}
    (defun UC_VolumetricTax (id:string amount:decimal)
        (let
            (
                (ref-U|DPTF:module{UtilityDptf} U|DPTF)
            )
            (UEV_Amount id amount)
            (ref-U|DPTF::UC_VolumetricTax (UR_Decimals id) amount)
        )
    )
    ;;{F0}
    (defun UR_P-KEYS:[string] ()
        (keys DPTF|PropertiesTable)
    )
    (defun UR_KEYS:[string] ()
        (keys DPTF|BalanceTable)
    )
    (defun UR_Konto:string (id:string)
        (at "owner-konto" (read DPTF|PropertiesTable id ["owner-konto"]))
    )
    (defun UR_Name:string (id:string)
        (at "name" (read DPTF|PropertiesTable id ["name"]))
    )
    (defun UR_Ticker:string (id:string)
        (at "ticker" (read DPTF|PropertiesTable id ["ticker"])) 
    )
    (defun UR_Decimals:integer (id:string)
        (at "decimals" (read DPTF|PropertiesTable id ["decimals"]))
    )
    (defun UR_CanChangeOwner:bool (id:string)
        (at "can-change-owner" (read DPTF|PropertiesTable id ["can-change-owner"]))
    )
    (defun UR_CanUpgrade:bool (id:string)
        (at "can-upgrade" (read DPTF|PropertiesTable id ["can-upgrade"]))  
    )
    (defun UR_CanAddSpecialRole:bool (id:string)
        (at "can-add-special-role" (read DPTF|PropertiesTable id ["can-add-special-role"]))
    )
    (defun UR_CanFreeze:bool (id:string)
        (at "can-freeze" (read DPTF|PropertiesTable id ["can-freeze"]))
    )
    (defun UR_CanWipe:bool (id:string)
        (at "can-wipe" (read DPTF|PropertiesTable id ["can-wipe"]))
    )
    (defun UR_CanPause:bool (id:string)
        (at "can-pause" (read DPTF|PropertiesTable id ["can-pause"]))
    )
    (defun UR_Paused:bool (id:string)
        (at "is-paused" (read DPTF|PropertiesTable id ["is-paused"]))
    )
    (defun UR_Supply:decimal (id:string)
        (at "supply" (read DPTF|PropertiesTable id ["supply"]))
    )
    (defun UR_OriginMint:bool (id:string)
        (at "origin-mint" (read DPTF|PropertiesTable id ["origin-mint"]))
    )
    (defun UR_OriginAmount:decimal (id:string)
        (at "origin-mint-amount" (read DPTF|PropertiesTable id ["origin-mint-amount"]))
    )
    (defun UR_TransferRoleAmount:integer (id:string)
        (at "role-transfer-amount" (read DPTF|PropertiesTable id ["role-transfer-amount"]))
    )
    (defun UR_FeeToggle:bool (id:string)
        (at "fee-toggle" (read DPTF|PropertiesTable id ["fee-toggle"]))
    )
    (defun UR_MinMove:decimal (id:string)
        (at "min-move" (read DPTF|PropertiesTable id ["min-move"]))
    )
    (defun UR_FeePromile:decimal (id:string)
        (at "fee-promile" (read DPTF|PropertiesTable id ["fee-promile"]))
    )
    (defun UR_FeeTarget:string (id:string)
        (at "fee-target" (read DPTF|PropertiesTable id ["fee-target"]))
    )
    (defun UR_FeeLock:bool (id:string)
        (at "fee-lock" (read DPTF|PropertiesTable id ["fee-lock"]))
    )
    (defun UR_FeeUnlocks:integer (id:string)
        (at "fee-unlocks" (read DPTF|PropertiesTable id ["fee-unlocks"]))
    )
    (defun UR_PrimaryFeeVolume:decimal (id:string)
        (at "primary-fee-volume" (read DPTF|PropertiesTable id ["primary-fee-volume"]))
    )
    (defun UR_SecondaryFeeVolume:decimal (id:string)
        (at "secondary-fee-volume" (read DPTF|PropertiesTable id ["secondary-fee-volume"]))
    )
    (defun UR_RewardToken:[string] (id:string)
        (at "reward-token" (read DPTF|PropertiesTable id ["reward-token"]))
    )
    (defun UR_RewardBearingToken:[string] (id:string)
        (at "reward-bearing-token" (read DPTF|PropertiesTable id ["reward-bearing-token"]))
    )
    (defun UR_Vesting:string (id:string)
        (at "vesting" (read DPTF|PropertiesTable id ["vesting"]))
    )
    (defun UR_Roles:[string] (id:string rp:integer)
        (if (= rp 1)
            (with-default-read DPTF|RoleTable id
                { "r-burn" : [BAR]}
                { "r-burn" := rb }
                rb
            )
            (if (= rp 2)
                (with-default-read DPTF|RoleTable id
                    { "r-mint" : [BAR]}
                    { "r-mint" := rm }
                    rm
                )
                (if (= rp 3)
                    (with-default-read DPTF|RoleTable id
                        { "r-fee-exemption" : [BAR]}
                        { "r-fee-exemption" := rfe }
                        rfe
                    )
                    (if (= rp 4)
                        (with-default-read DPTF|RoleTable id
                            { "r-transfer" : [BAR]}
                            { "r-transfer" := rt }
                            rt
                        )
                        (with-default-read DPTF|RoleTable id
                            { "a-frozen" : [BAR]}
                            { "a-frozen" := af }
                            af
                        )
                    )
                )
            )
        )
    )
    (defun UR_AccountSupply:decimal (id:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (if (= id (ref-DALOS::UR_OuroborosID))
                    (ref-DALOS::UR_TF_AccountSupply account true)
                    (ref-DALOS::UR_TF_AccountSupply account false)
                )
                (with-default-read DPTF|BalanceTable (concat [id BAR account])
                    { "balance" : 0.0 }
                    { "balance" := b}
                    b
                )
            )
        )
        
    )
    (defun UR_AccountRoleBurn:bool (id:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (if (= id (ref-DALOS::UR_OuroborosID))
                    (ref-DALOS::UR_TF_AccountRoleBurn account true)
                    (ref-DALOS::UR_TF_AccountRoleBurn account false)
                )
                (with-default-read DPTF|BalanceTable (concat [id BAR account])
                    { "role-burn" : false}
                    { "role-burn" := rb }
                    rb
                )
            )
        )
    )
    (defun UR_AccountRoleMint:bool (id:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (if (= id (ref-DALOS::UR_OuroborosID))
                    (ref-DALOS::UR_TF_AccountRoleMint account true)
                    (ref-DALOS::UR_TF_AccountRoleMint account false)
                )
                (with-default-read DPTF|BalanceTable (concat [id BAR account])
                    { "role-mint" : false}
                    { "role-mint" := rm }
                    rm
                )
            )
        )
    )
    (defun UR_AccountRoleTransfer:bool (id:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (if (= id (ref-DALOS::UR_OuroborosID))
                    (ref-DALOS::UR_TF_AccountRoleTransfer account true)
                    (ref-DALOS::UR_TF_AccountRoleTransfer account false)
                )
                (with-default-read DPTF|BalanceTable (concat [id BAR account])
                    { "role-transfer" : false}
                    { "role-transfer" := rt }
                    rt
                )
            )
        )
    )
    (defun UR_AccountRoleFeeExemption:bool (id:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (if (= id (ref-DALOS::UR_OuroborosID))
                    (ref-DALOS::UR_TF_AccountRoleFeeExemption account true)
                    (ref-DALOS::UR_TF_AccountRoleFeeExemption account false)
                )
                (with-default-read DPTF|BalanceTable (concat [id BAR account])
                    { "role-fee-exemption" : false}
                    { "role-fee-exemption" := rfe }
                    rfe
                )
            )
        )
    )
    (defun UR_AccountFrozenState:bool (id:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (if (= id (ref-DALOS::UR_OuroborosID))
                    (ref-DALOS::UR_TF_AccountFreezeState account true)
                    (ref-DALOS::UR_TF_AccountFreezeState account false)
                )
                (with-default-read DPTF|BalanceTable (concat [id BAR account])
                    { "frozen" : false}
                    { "frozen" := fr }
                    fr
                )
            )
        )
    )
    ;;{F1}
    (defun URC_IzRT:bool (reward-token:string)
        @doc "Returns a boolean, if token id is RT in any atspair"
        (UEV_id reward-token)
        (if (= (UR_RewardToken reward-token) [BAR])
            false
            true
        )
    )
    (defun URC_IzRTg:bool (atspair:string reward-token:string)
        @doc "Returns a boolean, if token id is RT in a specific atspair"
        (UEV_id reward-token)
        (if (= (UR_RewardToken reward-token) [BAR])
            false
            (if (= (contains atspair (UR_RewardToken reward-token)) true)
                true
                false
            )
        )
    )
    (defun URC_IzRBT:bool (reward-bearing-token:string)
        @doc "Returns a boolean, if token id is RBT in any atspair"
        (UEV_id reward-bearing-token)
        (if (= (UR_RewardBearingToken reward-bearing-token) [BAR])
            false
            true
        )
    )
    (defun URC_IzRBTg:bool (atspair:string reward-bearing-token:string)
        @doc "Returns a boolean, if token id is RBT in a specific atspair"
        (UEV_id reward-bearing-token)
        (if (= (UR_RewardBearingToken reward-bearing-token) [BAR])
            false
            (if (contains atspair (UR_RewardBearingToken reward-bearing-token))
                true
                false
            )
        )
    )
    (defun URC_IzCoreDPTF:bool (id:string)
        @doc "Returns a boolean, if id is a Core DPTF \
            \ Core DPTFs are OUROBOROS and IGNIS"
        (UEV_id id)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                (ignis-id:string (ref-DALOS::UR_IgnisID))
                (iz-ouro-defined:bool (not (= ouro-id BAR)))
                (iz-ignis-defined:bool (not (= ignis-id BAR)))
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
    (defun URC_AccountExist:bool (id:string account:string)
        @doc "Returns a boolean if a given DPTF Account exists"
        (with-default-read DPTF|BalanceTable (concat [id BAR account])
            { "balance" : -1.0 }
            { "balance" := b}
            (if (= b -1.0)
                false
                true
            )
        )
    )
    (defun URC_Fee:[decimal] (id:string amount:decimal)
        @doc "Computes the DPTF transfer fee split given a DPTF Id and amount \
            \ Returns a list of decimals: \
            \ <primary-fee-value> - the actual transfer fee \
            \ <secondary-fee-value> - results when to many Fee-Unlocks have been executed \
            \ <remainder> - the Token amount that reaches the target"
        (let
            (
                (fee-toggle:bool (UR_FeeToggle id))
            )
            (if (= fee-toggle false)
                [0.0 0.0 amount]
                (let
                    (
                        (precision:integer (UR_Decimals id))
                        (fee-promile:decimal (UR_FeePromile id))
                        (fee-unlocks:integer (UR_FeeUnlocks id))
                        (volumetric-fee:decimal (UC_VolumetricTax id amount))
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
    (defun URC_TrFeeMinExc:bool (id:string sender:string receiver:string)
        @doc "Computes if there is an exception for DPTF Id regarding <fee-exemption>\
        \ <OUROBOROS|SC_NAME> and <DALOS|SC_NAME> are fee-exempted by default (as both senders or receivers) \
        \ Fee-exemption also does not apply when Token-Owner sends or receives the token"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))

                (sender-fee-exemption:bool (UR_AccountRoleFeeExemption id sender))
                (receiver-fee-exemption:bool (UR_AccountRoleFeeExemption id receiver))
                (token-owner:string (UR_Konto id))
                (sender-t1:bool (or (= sender ouroboros) (= sender dalos)))
                (sender-t2:bool (or (= sender token-owner)(= sender-fee-exemption true)))
                (iz-sender-exception:bool (or sender-t1 sender-t2))
                (receiver-t1:bool (or (= receiver ouroboros) (= receiver dalos)))
                (receiver-t2:bool (or (= receiver token-owner)(= receiver-fee-exemption true)))
                (iz-receiver-exception:bool (or receiver-t1 receiver-t2))
                (are-members-exception (or iz-sender-exception iz-receiver-exception))
            )
            are-members-exception
        )
    )
    (defun URC_HasVesting:bool (id:string)
        @doc "Returns a boolean if DPTF has a vesting counterpart"
        (if (= (UR_Vesting id) BAR)
            false
            true
        )
    )
    ;;{F2}
    (defun UEV_CanChangeOwnerON (id:string)
        (let
            (
                (x:bool (UR_CanChangeOwner id))
            )
            (enforce x (format "{} ownership cannot be changed" [id]))
        )
    )
    (defun UEV_CanUpgradeON (id:string)
        (let
            (
                (x:bool (UR_CanUpgrade id))
            )
            (enforce x (format "{} properties cannot be upgraded" [id]))
        )
    )
    (defun UEV_CanAddSpecialRoleON (id:string)
        (let
            (
                (x:bool (UR_CanAddSpecialRole id))
            )
            (enforce x (format "For {} no special roles can be added" [id])
            )
        )
    )
    (defun UEV_CanFreezeON (id:string)
        (let
            (
                (x:bool (UR_CanFreeze id))
            )
            (enforce x (format "{} cannot be freezed" [id])
            )
        )
    )
    (defun UEV_CanWipeON (id:string)
        (let
            (
                (x:bool (UR_CanWipe id))
            )
            (enforce x (format "{} cannot be wiped" [id])
            )
        )
    )
    (defun UEV_CanPauseON (id:string)
        (let
            (
                (x:bool (UR_CanPause id))
            )
            (enforce x (format "{} cannot be paused" [id])
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
                (format "{} is not conform with the {} prec." [amount id])
            )
            (enforce
                (> amount 0.0)
                (format "{} is not a Valid Transaction amount" [amount])
            )
        )
    )
    (defun UEV_CheckID:bool (id:string)
        (with-default-read DPTF|PropertiesTable id
            { "supply" : -1.0 }
            { "supply" := s }
            (if (>= s 0.0)
                true
                false
            )
        )
    )
    (defun UEV_id (id:string)
        (with-default-read DPTF|PropertiesTable id
            { "supply" : -1.0 }
            { "supply" := s }
            (enforce
                (>= s 0.0)
                (format "DPTF ID {} does not exist" [id])
            )
        )
    )
    (defun UEV_Virgin (id:string)
        (let
            (
                (om:bool (UR_OriginMint id))
                (oma:decimal (UR_OriginAmount id))
            )
            (enforce
                (and (= om false) (= oma 0.0))
                (format "Origin Mint for {} is offline" [id])
            )
        )
    )
    (defun UEV_FeeLockState (id:string state:bool)
        (let
            (
                (x:bool (UR_FeeLock id))
            )
            (enforce (= x state) (format "Fee-lock for {} must be set to {} for exec" [id state]))
        )
    )
    (defun UEV_FeeToggleState (id:string state:bool)
        (let
            (
                (x:bool (UR_FeeToggle id))
            )
            (enforce (= x state) (format "Fee-Toggle for {} must be set to {} for exec" [id state]))
        )
    )
    (defun UEV_AccountMintState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_AccountRoleMint id account))
            )
            (enforce (= x state) (format "Mint Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountFeeExemptionState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_AccountRoleFeeExemption id account))
            )
            (enforce (= x state) (format "Fee-Exemption Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_EnforceMinimumAmount (id:string transfer-amount:decimal)
        (let
            (
                (min-move-read:decimal (UR_MinMove id))
                (precision:integer (UR_Decimals id))
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
    (defun UEV_Vesting (id:string existance:bool)
        (let
            (
                (has-vesting:bool (URC_HasVesting id))
            )
            (enforce (= has-vesting existance) (format "Vesting for the Token {} is not satisfied with existance {}" [id existance]))
        )
    )
    ;;{F3}
    ;;{F4}
    (defun CAP_Owner (id:string)
        @doc "Enforces DPTF Token ID Ownership"
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
    (defun C_UpdatePendingBranding (patron:string id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for DPTF Token <id> costing 100 IGNIS"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-BRD:module{Branding} BRD)
                (owner:string (UR_Konto id))
                (branding-cost:decimal (ref-DALOS::UR_UsagePrice "ignis|branding"))
            )
            (with-capability (DPTF|C>UPDATE-BRD)
                (ref-BRD::X_UpdatePendingBranding id logo description website social)
                (ref-DALOS::IGNIS|C_Collect patron owner branding-cost)
            )
        )
    )
    (defun C_UpgradeBranding (patron:string id:string months:integer)
        @doc "Upgrades Branding for DPTF Token, making it a premium Branding. \
        \ Also sets pending-branding to live branding if its branding is not live yet"
        (enforce-guard (P|UR "TALOS|Summoner"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-BRD:module{Branding} BRD)
                (owner:string (UR_Konto id))
                (kda-payment:decimal
                    (with-capability (DPTF|C>UPGRADE-BRD)
                        (ref-BRD::X_UpgradeBranding id owner months)
                    )
                )
            )
            (ref-DALOS::KDA|C_CollectWT patron kda-payment false)
        )
    )
    (defun C_RotateOwnership (patron:string id:string new-owner:string)
        @doc "Rotates DPTF ID Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>RT_OWN id new-owner)
                (X_ChangeOwnership id new-owner)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|biggest"))
            )
        )
    )
    (defun C_DeployAccount (id:string account:string)
        @doc "Deploys a DPTF Account"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id)
            (with-default-read DPTF|BalanceTable (concat [id BAR account])
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
                (write DPTF|BalanceTable (concat [id BAR account])
                    { "balance"                         : b
                    , "role-burn"                       : rb
                    , "role-mint"                       : rm
                    , "role-transfer"                   : rt
                    , "role-fee-exemption"              : rfe
                    , "frozen"                          : f}
                )
            )
        )
    )
    (defun C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Toggles Freezing of a DPTF Account"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|FC>FRZ-ACC id account toggle)
                (X_ToggleFreezeAccount id account toggle)
                (X_WriteRoles id account 5 toggle)
                (ref-DALOS::IGNIS|C_Collect patron account (ref-DALOS::UR_UsagePrice "ignis|big"))
            )
        )
    )
    (defun C_TogglePause (patron:string id:string toggle:bool)
        @doc "Toggles Pause for a DPTF Token"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>TG_PAUSE id toggle)
                (X_TogglePause id toggle)
                (ref-DALOS::IGNIS|C_Collect patron patron (ref-DALOS::UR_UsagePrice "ignis|medium"))
            )
        )
    )
    (defun C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles Transfer-Role for a DPTF Token on a specific account"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|C>TG_TRANSFER-R id account toggle)
                (X_ToggleTransferRole id account toggle)
                (X_UpdateRoleTransferAmount id toggle)
                (X_WriteRoles id account 4 toggle)
                (ref-DALOS::IGNIS|C_Collect patron account (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_Wipe (patron:string id:string atbw:string)
        @doc "Wipes a DPTF Token from a given account"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|C>WIPE id atbw)
                (X_Wipe id atbw)
                (ref-DALOS::IGNIS|C_CollectWT patron atbw (ref-DALOS::UR_UsagePrice "ignis|biggest") (ref-DALOS::IGNIS|URC_ZeroGAS id atbw))
            )
        )
    )
    (defun C_Burn (patron:string id:string account:string amount:decimal)
        @doc "Burns a DPTF Token from an account"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|C>BURN id account amount)
                (X_BurnCore id account amount)
                (ref-DALOS::IGNIS|C_CollectWT patron account (ref-DALOS::UR_UsagePrice "ignis|small") (ref-DALOS::IGNIS|URC_ZeroGAS id account))
            )
        )
    )
    (defun C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool)
        @doc "Controls the properties of a DPTF Token \
            \ <can-change-owner> <can-upgrade> <can-add-special-role> <can-freeze> <can-wipe> <can-pause>"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>CTRL id)
                (X_Control patron id cco cu casr cf cw cp)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
        @doc "Issues a new DPTF Token. Summoned only"
        (enforce-guard (P|UR "TALOS|Summoner"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (l1:integer (length name))
                (tl:[bool] (make-list l1 false))
                (tf-cost:decimal (ref-DALOS::UR_UsagePrice "dptf"))
                (kda-costs:decimal (* (dec l1) tf-cost))
                (issued-ids:[string]
                    (with-capability (SECURE)
                        (X_IssueFree patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause tl)
                    )
                )
            )
            (ref-DALOS::KDA|C_Collect patron kda-costs)
            issued-ids
        )
    )
    (defun C_IssueLP:string (patron:string account:string name:string ticker:string)
        @doc "Issues a DPTF Token as a Liquidity Pool Token. A LP DPTF follows specific rules in naming."
        (enforce-guard (P|UR "SWPI|Caller"))
        (with-capability (SECURE)
            (at 0 (X_IssueFree patron account [name] [ticker] [24] [false] [false] [true] [false] [false] [false] [true]))
        )
    )
    (defun C_Mint (patron:string id:string account:string amount:decimal origin:bool)
        @doc "Mints a DPTF Token"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (big:decimal (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                (small:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (price:decimal (if origin big small))
            )
            (with-capability (DPTF|C>MINT id account amount origin)
                (ref-DALOS::IGNIS|C_CollectWT patron account price (ref-DALOS::IGNIS|URC_ZeroGAS id account))
                (X_Mint id account amount origin) 
            )
        )
    )
    (defun C_SetFee (patron:string id:string fee:decimal)
        @doc "Sets a transfer fee for the DPTF Token"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>SET_FEE id fee)
                (X_SetFee id fee)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_SetFeeTarget (patron:string id:string target:string)
        @doc "Sets the Fee Collection Target for a DPTF"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>SET_FEE-TARGET id target)
                (X_SetFeeTarget id target)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_SetMinMove (patron:string id:string min-move-value:decimal)
        @doc "Sets the minimum amount needed to transfer a DPTF Token"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>SET_MIN-MOVE id min-move-value)
                (X_SetMinMove id min-move-value)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_ToggleFee (patron:string id:string toggle:bool)
        @doc "Toggles Fee collection for a DPTF Token. When a DPTF Token is setup with a transfer fee, \
        \ it will come in effect only when the toggle is on(true)"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>TG_FEE id toggle)
                (X_ToggleFee id toggle)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_ToggleFeeLock (patron:string id:string toggle:bool)
        @doc "Toggles Fee Settings Lock; Summoned only"
        (enforce-guard (P|UR "TALOS|Summoner"))
        (with-capability (DPTF|C>TG_FEE-LOCK id toggle)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (token-owner:string (UR_Konto id))
                    (g1:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                    (toggle-costs:[decimal] (X_ToggleFeeLock id toggle))
                    (g2:decimal (at 0 toggle-costs))
                    (gas-costs:decimal (+ g1 g2))
                    (kda-costs:decimal (at 1 toggle-costs))
                )
                (ref-DALOS::IGNIS|C_Collect patron token-owner gas-costs)
                (if (> kda-costs 0.0)
                    (do
                        (X_IncrementFeeUnlocks id)
                        (ref-DALOS::KDA|C_Collect patron kda-costs)
                    )
                    true
                )
            )
        )
    )
    ;;{F7}
    (defun X_IssueFree:[string] 
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
            iz-lp:[bool]
        )
        (require-capability (SECURE))
        (with-capability (DPTF|C>ISSUE account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (l1:integer (length name))
                    (ignis-issue-cost:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                    (gas-costs:decimal (* (dec l1) ignis-issue-cost))
                    (folded-lst:[string]
                        (fold
                            (lambda
                                (acc:[string] index:integer)
                                (let
                                    (
                                        (id:string
                                            (X_Issue 
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
                                    (ref-U|LST::UC_AppL acc id)
                                )
                            )
                            []
                            (enumerate 0 (- l1 1))
                        )
                    )
                )
                (ref-DALOS::IGNIS|C_Collect patron account gas-costs)
                folded-lst
            )
        )
    )
    (defun X_ChangeOwnership (id:string new-owner:string)
        (require-capability (DPTF|S>RT_OWN id new-owner))
        (update DPTF|PropertiesTable id
            {"owner-konto"                      : new-owner}
        )
    )
    (defun X_ToggleFreezeAccount (id:string account:string toggle:bool)
        (require-capability (DPTF|S>X_FRZ-ACC id account toggle))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (with-capability (P|DALOS|UP_DATA)
                    (ref-DALOS::X_UpdateFreeze account (= id (ref-DALOS::UR_OuroborosID)) toggle)
                )
                (update DPTF|BalanceTable (concat [id BAR account])
                    { "frozen" : toggle}
                )
            )
        )
    )
    (defun X_TogglePause (id:string toggle:bool)
        (require-capability (DPTF|S>TG_PAUSE id toggle))
        (update DPTF|PropertiesTable id
            { "is-paused" : toggle}
        )
    )
    (defun X_ToggleTransferRole (id:string account:string toggle:bool)
        (require-capability (DPTF|S>X_TG_TRANSFER-R id account toggle))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (with-capability (P|DALOS|UP_DATA)
                    (ref-DALOS::X_UpdateTransferRole account (= id (ref-DALOS::UR_OuroborosID)) toggle)
                )
                (update DPTF|BalanceTable (concat [id BAR account])
                    {"role-transfer" : toggle}
                )
            )
        )
    )
    (defun X_UpdateRoleTransferAmount (id:string direction:bool)
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
    (defun X_UpdateSupply (id:string amount:decimal direction:bool)
        (require-capability (DPTF|UP_SPLY))
        (UEV_Amount id amount)
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
    (defun X_Wipe (id:string account-to-be-wiped:string)
        (require-capability (DPTF|C>WIPE id account-to-be-wiped))
        (let
            (
                (amount-to-be-wiped:decimal (UR_AccountSupply id account-to-be-wiped))
            )
            (X_DebitAdmin id account-to-be-wiped amount-to-be-wiped)
            (X_UpdateSupply id amount-to-be-wiped false)
        )
    )
    (defun X_ToggleBurnRole (id:string account:string toggle:bool)
        (enforce-guard (P|UR "ATS|Caller"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>TG_BURN-R id account toggle)
                (if (URC_IzCoreDPTF id)
                    (with-capability (P|DALOS|UP_DATA)
                        (ref-DALOS::X_UpdateBurnRole account (= id (ref-DALOS::UR_OuroborosID)) toggle)
                    )
                    (update DPTF|BalanceTable (concat [id BAR account])
                        {"role-burn" : toggle}
                    )
                )
            )
        )
    )
    (defun X_UpdateRewardBearingToken (atspair:string id:string)
        (enforce-guard (P|UR "ATS|Caller"))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (with-read DPTF|PropertiesTable id
                {"reward-bearing-token" := rbt}
                (if (= (at 0 rbt) BAR)
                    (update DPTF|PropertiesTable id
                        {"reward-bearing-token" : [atspair]}
                    )
                    (update DPTF|PropertiesTable id
                        {"reward-bearing-token" : (ref-U|LST::UC_AppL rbt atspair)}
                    )
                )
            )
        )
    )
    (defun X_UpdateVesting (dptf:string dpmf:string)
        (enforce-guard (P|UR "DPMF|UpdateVesting"))
        (update DPTF|PropertiesTable dptf
            {"vesting" : dpmf}
        )
    )
    (defun X_Control (id:string can-change-owner:bool can-upgrade:bool can-add-special-role:bool can-freeze:bool can-wipe:bool can-pause:bool)
        (require-capability (DPTF|S>CTRL id))
        (update DPTF|PropertiesTable id
            {"can-change-owner"                 : can-change-owner
            ,"can-upgrade"                      : can-upgrade
            ,"can-add-special-role"             : can-add-special-role
            ,"can-freeze"                       : can-freeze
            ,"can-wipe"                         : can-wipe
            ,"can-pause"                        : can-pause}
        )
    )
    (defun X_Issue:string 
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
        (require-capability (SECURE))
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-BRD:module{Branding} BRD)
                (id:string (ref-U|DALOS::UDC_Makeid ticker))
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
            )
            (ref-U|DALOS::UEV_Decimals decimals)
            (ref-U|DALOS::UEV_NameOrTicker name true iz-lp)
            (ref-U|DALOS::UEV_NameOrTicker ticker false iz-lp)
            (ref-BRD::X_Issue id)
            (insert DPTF|PropertiesTable id
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
                ,"supply"               : 0.0
                ,"origin-mint"          : false
                ,"origin-mint-amount"   : 0.0
                ,"role-transfer-amount" : 0
                ,"fee-toggle"           : false
                ,"min-move"             : -1.0
                ,"fee-promile"          : 0.0
                ,"fee-target"           : ouroboros
                ,"fee-lock"             : false
                ,"fee-unlocks"          : 0
                ,"primary-fee-volume"   : 0.0
                ,"secondary-fee-volume" : 0.0
                ,"reward-token"         : [BAR]
                ,"reward-bearing-token" : [BAR]
                ,"vesting"              : BAR}
            )
            (C_DeployAccount id account)    
            id
        ) 
    )
    (defun X_Mint (id:string account:string amount:decimal origin:bool)
        (if origin
            (require-capability (DPTF|C>MINT-ORG id amount ))
            (require-capability (DPTF|C>MINT-STD id account amount))
        )
        (X_Credit id account amount)
        (X_UpdateSupply id amount true)
        (if origin
            (update DPTF|PropertiesTable id
                { "origin-mint" : false
                , "origin-mint-amount" : amount}
            )
            true
        )
    )
    (defun X_SetFee (id:string fee:decimal)
        (require-capability (DPTF|S>SET_FEE id fee))
        (update DPTF|PropertiesTable id
            { "fee-promile" : fee}
        )
    )
    (defun X_SetFeeTarget (id:string target:string)
        (require-capability (DPTF|S>SET_FEE-TARGET id target))
        (update DPTF|PropertiesTable id
            { "fee-target" : target}
        )
    )
    (defun X_SetMinMove (id:string min-move-value:decimal)
        (require-capability (DPTF|S>SET_MIN-MOVE id min-move-value))
        (update DPTF|PropertiesTable id
            { "min-move" : min-move-value}
        )
    )
    (defun X_ToggleFee (id:string toggle:bool)
        (require-capability (DPTF|S>TG_FEE id toggle))
        (update DPTF|PropertiesTable id
            { "fee-toggle" : toggle}
        )
    )
    (defun X_ToggleFeeLock:[decimal] (id:string toggle:bool)
        (require-capability (DPTF|S>X_TG_FEE-LOCK id toggle))
        (let
            (
                (ref-U|DPTF:module{UtilityDptf} U|DPTF)
            )
            (update DPTF|PropertiesTable id
                { "fee-lock" : toggle}
            )
            (if (= toggle true)
                [0.0 0.0]
                (ref-U|DPTF::UC_UnlockPrice (UR_FeeUnlocks id))
            )
        )
    )
    (defun X_IncrementFeeUnlocks (id:string)
        (require-capability (DPTF|INCR-LOCKS))
        (with-read DPTF|PropertiesTable id
            { "fee-unlocks" := fu }
            (enforce (< fu 7) (format "Cannot increment Fee Unlocks for Token {}" [id]))
            (update DPTF|PropertiesTable id
                {"fee-unlocks" : (+ fu 1)}
            )
        )
    )
    (defun X_Burn (id:string account:string amount:decimal)
        (enforce-guard (P|UR "TFT|Burn"))
        (with-capability (DPTF|C>BURN id account amount)
            (X_BurnCore id account amount)
        )
    )
    (defun X_BurnCore (id:string account:string amount:decimal)
        (require-capability (DPTF|C>BURN id account amount))
        (X_DebitStandard id account amount)
        (X_UpdateSupply id amount false)
    )
    (defun X_Credit (id:string account:string amount:decimal)
        (enforce-one
            "Credit Not permitted"
            [
                (enforce-guard (create-capability-guard (DPTF|CREDIT)))
                (enforce-guard (P|UR "TFT|Credit"))
            ]
        )
        (if (URC_IzCoreDPTF id)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (snake-or-gas:bool (if (= id (ref-DALOS::UR_OuroborosID)) true false))
                    (read-balance:decimal (ref-DALOS::UR_TF_AccountSupply account snake-or-gas))
                )
                (enforce (>= read-balance 0.0) "Impossible operation, negative Primordial TrueFungible amounts detected")
                (enforce (> amount 0.0) "Crediting amount must be greater than zero, even for Primordial TrueFungibles")
                (with-capability (P|DALOS|UP_BLC)
                    (ref-DALOS::X_UpdateBalance account snake-or-gas (+ read-balance amount))
                )
            )
            (let
                (
                    (dptf-account-exist:bool (URC_AccountExist id account))
                )
                (enforce (> amount 0.0) "Crediting amount must be greater than zero")
                (if (= dptf-account-exist false)
                    (insert DPTF|BalanceTable (concat [id BAR account])
                        { "balance"                         : amount
                        , "role-burn"                       : false
                        , "role-mint"                       : false
                        , "role-transfer"                   : false
                        , "role-fee-exemption"              : false
                        , "frozen"                          : false
                        }
                    )
                    (with-read DPTF|BalanceTable (concat [id BAR account])
                        { "balance"                         := b
                        , "role-burn"                       := rb
                        , "role-mint"                       := rm
                        , "role-transfer"                   := rt
                        , "role-fee-exemption"              := rfe
                        , "frozen"                          := f
                        }
                        (write DPTF|BalanceTable (concat [id BAR account])
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
    (defun X_DebitAdmin (id:string account:string amount:decimal)
        (require-capability (DPTF|DEBIT))
        (with-capability (DPTF|DEBIT_PUR)
            (CAP_Owner id)
            (X_Debit id account amount)
        )
    )
    (defun X_DebitStandard (id:string account:string amount:decimal)
        (enforce-one
            "Standard Debit Not permitted"
            [
                (enforce-guard (create-capability-guard (DPTF|DEBIT)))
                (enforce-guard (P|UR "TFT|Debit"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|DEBIT_PUR)
                (ref-DALOS::CAP_EnforceAccountOwnership account)
                (X_Debit id account amount)
            )
        )
    )
    (defun X_Debit (id:string account:string amount:decimal)
        (require-capability (DPTF|DEBIT_PUR))
        (if (URC_IzCoreDPTF id)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (snake-or-gas:bool (if (= id (ref-DALOS::UR_OuroborosID)) true false))
                    (read-balance:decimal (ref-DALOS::UR_TF_AccountSupply account snake-or-gas))
                )
                (enforce (>= read-balance 0.0) "Impossible operation, negative Primordial TrueFungible amounts detected")
                (enforce (<= amount read-balance) "Insufficient Funds for debiting")
                (with-capability (P|DALOS|UP_BLC)
                    (ref-DALOS::X_UpdateBalance account snake-or-gas (- read-balance amount))
                )
            )
            (with-read DPTF|BalanceTable (concat [id BAR account])
                { "balance" := balance }
                (enforce (<= amount balance) "Insufficient Funds for debiting")
                (update DPTF|BalanceTable (concat [id BAR account])
                    {"balance" : (- balance amount)}    
                )
            )
        )
    )
    (defun X_ToggleFeeExemptionRole (id:string account:string toggle:bool)
        (enforce-guard (P|UR "ATS|Caller"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>TG_FEE-EXEMP-R id account toggle)
                (if (URC_IzCoreDPTF id)
                    (with-capability (P|DALOS|UP_DATA)
                        (ref-DALOS::X_UpdateFeeExemptionRole account (= id (ref-DALOS::UR_OuroborosID)) toggle)
                    )
                    (update DPTF|BalanceTable (concat [id BAR account])
                        {"role-fee-exemption" : toggle}
                    )
                )
            )
        )
    )
    (defun X_ToggleMintRole (id:string account:string toggle:bool)
        (enforce-guard (P|UR "ATS|Caller"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>TG_MINT-R id account toggle)
                (if (URC_IzCoreDPTF id)
                    (with-capability (P|DALOS|UP_DATA)
                        (ref-DALOS::X_UpdateMintRole account (= id (ref-DALOS::UR_OuroborosID)) toggle)
                    )
                    (update DPTF|BalanceTable (concat [id BAR account])
                        {"role-mint" : toggle}
                    )
                )
            )
        )
    )
    (defun X_UpdateFeeVolume (id:string amount:decimal primary:bool)
        (enforce-guard (P|UR "TFT|UpdateFees"))
        (UEV_Amount id amount)
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
    (defun X_UpdateRewardToken (atspair:string id:string direction:bool)
        (enforce-one
            "Invalid Permissions to update Reward Token"
            [
                (enforce-guard (P|UR "ATS|Caller"))
                (enforce-guard (P|UR "ATSU|Caller"))
            ]
        )
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (with-read DPTF|PropertiesTable id
                {"reward-token" := rt}
                (if (= direction true)
                    (if (= (at 0 rt) BAR)
                        (update DPTF|PropertiesTable id
                            {"reward-token" : [atspair]}
                        )
                        (update DPTF|PropertiesTable id
                            {"reward-token" : (ref-U|LST::UC_AppL rt atspair)}
                        )
                    )
                    (update DPTF|PropertiesTable id
                        {"reward-token" : (ref-U|LST::UC_RemoveItem rt atspair)}
                    )
                )
            )
        )
    )
    (defun X_WriteRoles (id:string account:string rp:integer d:bool)
        (enforce-one
            "Invalid Permissions to update Reward Token"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "ATS|Caller"))
            ]
        )
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
            )
            (with-capability (BASIS|C>X_WRITE-ROLES id account rp)
                (with-default-read DPTF|RoleTable id
                    { "r-burn"          : [BAR]
                    , "r-mint"          : [BAR]
                    , "r-fee-exemption" : [BAR]
                    , "r-transfer"      : [BAR]
                    , "a-frozen"        : [BAR]}
                    { "r-burn"          := rb
                    , "r-mint"          := rm
                    , "r-fee-exemption" := rfe
                    , "r-transfer"      := rt
                    , "a-frozen"        := af}
                    (if (= rp 1)
                        (write DPTF|RoleTable id
                            {"r-burn"           : (ref-U|DALOS::UC_NewRoleList rb account d)
                            , "r-mint"          : rm
                            , "r-fee-exemption" : rfe
                            , "r-transfer"      : rt
                            , "a-frozen"        : af}
                        )
                        (if (= rp 2)
                            (write DPTF|RoleTable id
                                {"r-burn"           : rb
                                , "r-mint"          : (ref-U|DALOS::UC_NewRoleList rm account d)
                                , "r-fee-exemption" : rfe
                                , "r-transfer"      : rt
                                , "a-frozen"        : af}
                            )
                            (if (= rp 3)
                                (write DPTF|RoleTable id
                                    {"r-burn"           : rb
                                    , "r-mint"          : rm
                                    , "r-fee-exemption" : (ref-U|DALOS::UC_NewRoleList rfe account d)
                                    , "r-transfer"      : rt
                                    , "a-frozen"        : af}
                                )
                                (if (= rp 4)
                                    (write DPTF|RoleTable id
                                        {"r-burn"           : rb
                                        , "r-mint"          : rm
                                        , "r-fee-exemption" : rfe
                                        , "r-transfer"      : (ref-U|DALOS::UC_NewRoleList rt account d)
                                        , "a-frozen"        : af}
                                    )
                                    (write DPTF|RoleTable id
                                        {"r-burn"           : rb
                                        , "r-mint"          : rm
                                        , "r-fee-exemption" : rfe
                                        , "r-transfer"      : rt
                                        , "a-frozen"        : (ref-U|DALOS::UC_NewRoleList af account d)}
                                    )
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