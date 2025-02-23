;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface DemiourgosPactTrueFungible
    @doc "Exposes most of the Functions of the DPTF Module. \
    \ Later deployed modules, contain the rest of the DPTF Functions \
    \ These are ATS and TFT Modules \
    \ UR(Utility-Read), URC(Utility-Read-Compute), UEV(Utility-Enforce-Validate) \
    \ are NOT sorted alphabetically"
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
    (defun UR_OriginMint:bool (id:string))
    (defun UR_OriginAmount:decimal (id:string))
    (defun UR_TransferRoleAmount:integer (id:string))
    (defun UR_FeeToggle:bool (id:string))
    (defun UR_MinMove:decimal (id:string))
    (defun UR_FeePromile:decimal (id:string))
    (defun UR_FeeTarget:string (id:string))
    (defun UR_FeeLock:bool (id:string))
    (defun UR_FeeUnlocks:integer (id:string))
    (defun UR_PrimaryFeeVolume:decimal (id:string))
    (defun UR_SecondaryFeeVolume:decimal (id:string))
    (defun UR_RewardToken:[string] (id:string))
    (defun UR_RewardBearingToken:[string] (id:string))
    (defun UR_Vesting:string (id:string))
    (defun UR_Sleeping:string (id:string))
    (defun UR_Frozen:string (id:string))
    (defun UR_Reservation:string (id:string))
    (defun UR_IzReservationOpen:bool (id:string))
    (defun UR_Roles:[string] (id:string rp:integer))
    (defun UR_AccountSupply:decimal (id:string account:string))
    (defun UR_AccountRoleBurn:bool (id:string account:string))
    (defun UR_AccountRoleMint:bool (id:string account:string))
    (defun UR_AccountRoleTransfer:bool (id:string account:string))
    (defun UR_AccountRoleFeeExemption:bool (id:string account:string))
    (defun UR_AccountFrozenState:bool (id:string account:string))
    ;;
    (defun URC_IzRT:bool (reward-token:string))
    (defun URC_IzRTg:bool (atspair:string reward-token:string))
    (defun URC_IzRBT:bool (reward-bearing-token:string))
    (defun URC_IzRBTg:bool (atspair:string reward-bearing-token:string))
    (defun URC_IzCoreDPTF:bool (id:string))
    (defun URC_AccountExist:bool (id:string account:string))
    (defun URC_Fee:[decimal] (id:string amount:decimal))
    (defun URC_TrFeeMinExc:bool (id:string sender:string receiver:string))
    (defun URC_HasVesting:bool (id:string))
    (defun URC_HasSleeping:bool (id:string))
    (defun URC_HasFrozen:bool (id:string))
    (defun URC_HasReserved:bool (id:string))
    ;;
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
    (defun UEV_Virgin (id:string))
    (defun UEV_FeeLockState (id:string state:bool))
    (defun UEV_FeeToggleState (id:string state:bool))
    (defun UEV_AccountMintState (id:string account:string state:bool))
    (defun UEV_AccountFeeExemptionState (id:string account:string state:bool))
    (defun UEV_EnforceMinimumAmount (id:string transfer-amount:decimal))
    (defun UEV_Vesting (id:string existance:bool))
    (defun UEV_Sleeping (id:string existance:bool))
    (defun UEV_Frozen (id:string existance:bool))
    (defun UEV_Reserved (id:string existance:bool))
    ;;
    (defun CAP_Owner (id:string))
    ;;
    (defun C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun C_UpgradeBranding (patron:string entity-id:string months:integer))
    ;;
    (defun C_Burn:object{OuronetDalos.IgnisCumulator} (patron:string id:string account:string amount:decimal))
    (defun C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool))
    (defun C_DeployAccount (id:string account:string))
    (defun C_Issue:object{OuronetDalos.IgnisCumulator} (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool]))
    (defun C_Mint:object{OuronetDalos.IgnisCumulator} (patron:string id:string account:string amount:decimal origin:bool))
    (defun C_RotateOwnership (patron:string id:string new-owner:string))
    (defun C_SetFee (patron:string id:string fee:decimal))
    (defun C_SetFeeTarget (patron:string id:string target:string))
    (defun C_SetMinMove (patron:string id:string min-move-value:decimal))
    (defun C_ToggleFee (patron:string id:string toggle:bool))
    (defun C_ToggleFeeLock:bool (patron:string id:string toggle:bool))
    (defun C_ToggleFreezeAccount:object{OuronetDalos.IgnisCumulator} (patron:string id:string account:string toggle:bool))
    (defun C_TogglePause (patron:string id:string toggle:bool))
    (defun C_ToggleReservation (patron:string id:string toggle:bool))
    (defun C_ToggleTransferRole:object{OuronetDalos.IgnisCumulator} (patron:string id:string account:string toggle:bool))
    (defun C_Wipe:object{OuronetDalos.IgnisCumulator} (patron:string id:string atbw:string))
    ;;
    (defun XB_Credit (id:string account:string amount:decimal))
    (defun XI_Debit (id:string account:string amount:decimal dispo-data:object{UtilityDptf.DispoData}))
    (defun XB_WriteRoles (id:string account:string rp:integer d:bool))
    ;;
    (defun XE_Burn (id:string account:string amount:decimal))
    (defun XE_IssueLP:object{OuronetDalos.IgnisCumulator} (patron:string account:string name:string ticker:string))
    (defun XE_ToggleBurnRole (id:string account:string toggle:bool))
    (defun XE_ToggleFeeExemptionRole (id:string account:string toggle:bool))
    (defun XE_ToggleMintRole (id:string account:string toggle:bool))
    (defun XE_UpdateRewardBearingToken (atspair:string id:string))
    (defun XE_UpdateSpecialTrueFungible:object{OuronetDalos.IgnisCumulator} (main-dptf:string secondary-dptf:string frozen-or-reserved:bool))
    (defun XE_UpdateVesting (dptf:string dpmf:string))
    (defun XE_UpdateSleeping (dptf:string dpmf:string))
    (defun XE_UpdateFeeVolume (id:string amount:decimal primary:bool))
    (defun XE_UpdateRewardToken (atspair:string id:string direction:bool))
)
(module DPTF GOV
    ;;
    (implements OuronetPolicy)
    (implements BrandingUsage)
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
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S}) 
    ;;{P3}
    (defcap P|DPTF|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPTF|CALLER))
        (compose-capability (SECURE))
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
                "DPTF|<"
                (create-capability-guard (P|DPTF|CALLER))
            )
            (ref-P|BRD::P|A_Add 
                "DPTF|<"
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
        vesting-link:string
        sleeping-link:string
        frozen-link:string
        reservation-link:string
        reservation:bool
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
    ;;{C2}
    (defcap DPTF|S>CTRL (id:string)
        @event
        (CAP_Owner id)
        (UEV_CanUpgradeON id)
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
    (defcap DPTF|S>TG_PAUSE (id:string pause:bool)
        @event
        (if pause
            (UEV_CanPauseON id)
            true
        )
        (CAP_Owner id)
        (UEV_PauseState id (not pause))
    )
    (defcap DPTF|S>TG_RESERVATION (id:string toggle:bool)
        @event
        (CAP_Owner id)
        (UEV_ReservationState id (not toggle))
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
    (defcap DPTF|S>SET_FEE-TARGET (id:string target:string) ;;add blacklisted accounts. eventual D Accounts.
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (current-fee-target:string (UR_FeeTarget id))
                (target-type:bool (ref-DALOS::UR_AccountType target))
                (dalos-sc:string (ref-DALOS::GOV|DALOS|SC_NAME))
                (orbr-sc:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
            )
            (enforce (!= target current-fee-target) "New Fee Target must be different than the current <fee-target>")
            (if target-type
                (enforce (or (= target dalos-sc)(= target orbr-sc)) "As Smart OURONET Accounts, only DALOS and OUROBOROS can be set as as fee Target")
                (ref-DALOS::UEV_EnforceAccountExists target)
            )
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
    (defcap DPTF|S>X_TG_FEE-LOCK (id:string toggle:bool)
        (CAP_Owner id)
        (UEV_FeeLockState id (not toggle))
    )
    ;;{C3}
    ;;{C4}
    (defcap DPTF|S>TG_MINT-R (id:string account:string toggle:bool)
        @event
        (UEV_AccountMintState id account (not toggle))
        (CAP_Owner id)
        (if toggle
            (UEV_CanAddSpecialRoleON id)
            true
        )
        (compose-capability (P|DPTF|CALLER))
    )
    (defcap DPTF|C>TG_FEE-EXEMP-R (id:string account:string toggle:bool)
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
            (compose-capability (P|DPTF|CALLER))
        )
    )
    (defcap DPTF|C>X_TG_TRANSFER-R (id:string account:string toggle:bool)
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
            (compose-capability (P|DPTF|CALLER))
        )
    )
    (defcap DPTF|C>TG_BURN-R (id:string account:string toggle:bool)
        @event
        (if toggle
            (UEV_CanAddSpecialRoleON id)
            true
        )
        (CAP_Owner id)
        (UEV_AccountBurnState id account (not toggle))
        (compose-capability (P|DPTF|CALLER))
    )
    (defcap DPTF|C>X_FRZ-ACC (id:string account:string frozen:bool)
        (CAP_Owner id)
        (UEV_CanFreezeON id)
        (UEV_AccountFreezeState id account (not frozen))
        (compose-capability (P|DPTF|CALLER))
    )
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
            (compose-capability (SECURE))
        )
    )
    (defcap DPTF|FC>FRZ-ACC (id:string account:string frozen:bool)
        @event
        (compose-capability (DPTF|C>X_FRZ-ACC id account frozen))
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
            (compose-capability (P|SECURE-CALLER))
        )
    )
    (defcap DPTF|C>TG_TRANSFER-R (id:string account:string toggle:bool)
        @event
        (compose-capability (DPTF|C>X_TG_TRANSFER-R id account toggle))
        (compose-capability (BASIS|C>X_WRITE-ROLES id account 4))
        (compose-capability (SECURE))
    )
    (defcap DPTF|C>WIPE (id:string account-to-be-wiped:string)
        @event
        (UEV_CanWipeON id)
        (UEV_AccountFreezeState id account-to-be-wiped true)
        (compose-capability (SECURE))
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
        (compose-capability (SECURE))
    )
    (defcap DPTF|C>TG_FEE-LOCK (id:string toggle:bool)
        @event
        (compose-capability (DPTF|S>X_TG_FEE-LOCK id toggle))
        (compose-capability (SECURE))
    )
    (defcap DPTF|C>UPDATE-SPECIAL (main-dptf:string secondary-dptf:string frozen-or-reserved:bool)
        (let
            (
                (main-special-id:string
                    (if frozen-or-reserved
                        (UR_Frozen main-dptf)
                        (UR_Reservation main-dptf)
                    )
                )
                (secondary-special-id:string
                    (if frozen-or-reserved
                        (UR_Frozen secondary-dptf)
                        (UR_Reservation secondary-dptf)
                    )
                )
                (iz-secondary-rt:bool (URC_IzRT secondary-dptf))
                (iz-secondary-rbt:bool (URC_IzRBT secondary-dptf))
                (main-dptf-first-character:string (take 1 main-dptf))
                (main-dptf-second-character:string (drop 1 (take 2 main-dptf)))
            )
            (CAP_Owner main-dptf)
            (CAP_Owner secondary-dptf)
            (enforce 
                (and (= main-special-id BAR) (= secondary-special-id BAR) )
                "Special True Fungible Links (frozen or reserved) are immutable !"
            )
            (enforce
                (and (not iz-secondary-rt) (not iz-secondary-rbt))
                "Special True Fungible cannot be RTs or Cold-RBTs"
            )
            (if (= main-dptf-second-character BAR)
                (if frozen-or-reserved
                    (enforce
                        (not (contains main-dptf-first-character ["R" "F"]))
                        (format "When setting a Frozen Link, the main DPTF {} cannot be a Reserved or Frozen Token" )
                    )
                    (enforce
                        (not (contains main-dptf-first-character ["R" "F" "S" "W" "P"]))
                        (format "When setting a Reserve Link, the main DPTF {} cannot be a Special DPTF" )
                    )
                    
                )
                true
            )
            (compose-capability (SECURE))
        )
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
        (at "vesting-link" (read DPTF|PropertiesTable id ["vesting-link"]))
    )
    (defun UR_Sleeping:string (id:string)
        (at "sleeping-link" (read DPTF|PropertiesTable id ["sleeping-link"]))
    )
    (defun UR_Frozen:string (id:string)
        (at "frozen-link" (read DPTF|PropertiesTable id ["frozen-link"]))
    )
    (defun UR_Reservation:string (id:string)
        (at "reservation-link" (read DPTF|PropertiesTable id ["reservation-link"]))
    )
    (defun UR_IzReservationOpen:bool (id:string)
        (at "reservation" (read DPTF|PropertiesTable id ["reservation"]))
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
            { "exist"   : false }
            { "exist"   := e}
            e
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
    (defun URC_HasSleeping:bool (id:string)
        @doc "Returns a boolean if DPTF has a sleeping counterpart"
        (if (= (UR_Sleeping id) BAR)
            false
            true
        )
    )
    (defun URC_HasFrozen:bool (id:string)
        @doc "Returns a boolean if DPTF has a frozen counterpart"
        (if (= (UR_Frozen id) BAR)
            false
            true
        )
    )
    (defun URC_HasReserved:bool (id:string)
        @doc "Returns a boolean if DPTF has a reserved counterpart"
        (if (= (UR_Reservation id) BAR)
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
                (enforce (not x) (format "{} is already paused" [id]))
            )
        )
    )
    (defun UEV_ReservationState (id:string state:bool)
        (let
            (
                (x:bool (UR_IzReservationOpen id))
            )
            (if state
                (enforce x (format "{} is already open for reservations" [id]))
                (enforce (not x) (format "{} is already closed for reservations" [id]))
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
    (defun UEV_Sleeping (id:string existance:bool)
        (let
            (
                (has-sleeping:bool (URC_HasSleeping id))
            )
            (enforce (= has-sleeping existance) (format "Sleeping for the Token {} is not satisfied with existance {}" [id existance]))
        )
    )
    (defun UEV_Frozen (id:string existance:bool)
        (let
            (
                (has-frozen:bool (URC_HasFrozen id))
            )
            (enforce (= has-frozen existance) (format "Frozen for the Token {} is not satisfied with existance {}" [id existance]))
        )
    )
    (defun UEV_Reserved (id:string existance:bool)
        (let
            (
                (has-reserved:bool (URC_HasReserved id))
            )
            (enforce (= has-reserved existance) (format "Reserved for the Token {} is not satisfied with existance {}" [id existance]))
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
    (defun C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-BRD:module{Branding} BRD)
                (owner:string (UR_Konto entity-id))
                (branding-cost:decimal (ref-DALOS::UR_UsagePrice "ignis|branding"))
            )
            (with-capability (DPTF|C>UPDATE-BRD)
                (ref-BRD::XE_UpdatePendingBranding entity-id logo description website social)
                (ref-DALOS::IGNIS|C_Collect patron owner branding-cost)
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
                    (with-capability (DPTF|C>UPGRADE-BRD)
                        (ref-BRD::XE_UpgradeBranding entity-id owner months)
                    )
                )
            )
            (ref-DALOS::KDA|C_CollectWT patron kda-payment false)
        )
    )
    ;;
    (defun C_Burn:object{OuronetDalos.IgnisCumulator}
        (patron:string id:string account:string amount:decimal)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (P|UR "TFT|<"))
                (enforce-guard (P|UR "ATSU|<"))
                (enforce-guard (P|UR "VST|<"))
                (enforce-guard (P|UR "LIQUID|<"))
                (enforce-guard (P|UR "OUROBOROS|<"))
                (enforce-guard (P|UR "SWPU|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (trigger:bool (ref-DALOS::IGNIS|URC_ZeroGAS id account))
            )
            (with-capability (DPTF|C>BURN id account amount)
                (XI_BurnCore id account amount)
                (ref-DALOS::UDC_Cumulator price trigger [])
            )
        )
    )
    (defun C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>CTRL id)
                (XI_Control patron id cco cu casr cf cw cp)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_DeployAccount (id:string account:string)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "ATS|<"))
                (enforce-guard (P|UR "ATSU|<"))
                (enforce-guard (P|UR "VST|<"))
                (enforce-guard (P|UR "SWP|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id)
            (with-default-read DPTF|BalanceTable (concat [id BAR account])
                {"exist"                    : true
                ,"balance"                  : 0.0
                ,"role-burn"                : false
                ,"role-mint"                : false
                ,"role-transfer"            : false
                ,"role-fee-exemption"       : false
                ,"frozen"                   : false}
                {"exist"                    := e
                ,"balance"                  := b
                ,"role-burn"                := rb
                ,"role-mint"                := rm
                ,"role-transfer"            := rt
                ,"role-fee-exemption"       := rfe
                ,"frozen"                   := f}
                (write DPTF|BalanceTable (concat [id BAR account])
                    {"exist"                : e
                    ,"balance"              : b
                    ,"role-burn"            : rb
                    ,"role-mint"            : rm
                    ,"role-transfer"        : rt
                    ,"role-fee-exemption"   : rfe
                    ,"frozen"               : f}
                )
            )
        )
    )
    (defun C_Issue:object{OuronetDalos.IgnisCumulator}
        (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (l1:integer (length name))
                (tl:[bool] (make-list l1 false))
                (tf-cost:decimal (ref-DALOS::UR_UsagePrice "dptf"))
                (kda-costs:decimal (* (dec l1) tf-cost))
                (ico:object{OuronetDalos.IgnisCumulator}
                    (with-capability (SECURE)
                        (XB_IssueFree patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause tl)
                    )
                )
            )
            (ref-DALOS::KDA|C_Collect patron kda-costs)
            ico
        )
    )
    (defun C_Mint:object{OuronetDalos.IgnisCumulator}
        (patron:string id:string account:string amount:decimal origin:bool)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (P|UR "ATSU|<"))
                (enforce-guard (P|UR "VST|<"))
                (enforce-guard (P|UR "LIQUID|<"))
                (enforce-guard (P|UR "OUROBOROS|<"))
                (enforce-guard (P|UR "SWP|<"))
                (enforce-guard (P|UR "SWPU|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (big:decimal (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                (small:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (price:decimal (if origin big small))
                (trigger:bool (ref-DALOS::IGNIS|URC_ZeroGAS id account))
            )
            (with-capability (DPTF|C>MINT id account amount origin)
                (XI_Mint id account amount origin)
                (ref-DALOS::UDC_Cumulator price trigger [])
            )
        )
    )
    (defun C_RotateOwnership (patron:string id:string new-owner:string)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>RT_OWN id new-owner)
                (XI_ChangeOwnership id new-owner)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|biggest"))
            )
        )
    )
    (defun C_SetFee (patron:string id:string fee:decimal)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>SET_FEE id fee)
                (XI_SetFee id fee)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_SetFeeTarget (patron:string id:string target:string)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>SET_FEE-TARGET id target)
                (XI_SetFeeTarget id target)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_SetMinMove (patron:string id:string min-move-value:decimal)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>SET_MIN-MOVE id min-move-value)
                (XI_SetMinMove id min-move-value)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_ToggleFee (patron:string id:string toggle:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>TG_FEE id toggle)
                (XI_ToggleFee id toggle)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_ToggleFeeLock:bool (patron:string id:string toggle:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (DPTF|C>TG_FEE-LOCK id toggle)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (token-owner:string (UR_Konto id))
                    (g1:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                    (toggle-costs:[decimal] (XI_ToggleFeeLock id toggle))
                    (g2:decimal (at 0 toggle-costs))
                    (gas-costs:decimal (+ g1 g2))
                    (kda-costs:decimal (at 1 toggle-costs))
                    (output:bool (if (> kda-costs 0.0) true false))
                )
                (ref-DALOS::IGNIS|C_Collect patron token-owner gas-costs)
                (if (> kda-costs 0.0)
                    (do
                        (XI_IncrementFeeUnlocks id)
                        (ref-DALOS::KDA|C_Collect patron kda-costs)
                    )
                    true
                )
                output
            )
        )
    )
    (defun C_ToggleFreezeAccount:object{OuronetDalos.IgnisCumulator}
        (patron:string id:string account:string toggle:bool)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (P|UR "TFT|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (with-capability (DPTF|FC>FRZ-ACC id account toggle)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (price:decimal (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-DALOS::UDC_Cumulator price trigger [])
                    )
                )
                (XI_ToggleFreezeAccount id account toggle)
                (XB_WriteRoles id account 5 toggle)
                ico
            )
        )
    )
    (defun C_TogglePause (patron:string id:string toggle:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>TG_PAUSE id toggle)
                (XI_TogglePause id toggle)
                (ref-DALOS::IGNIS|C_Collect patron patron (ref-DALOS::UR_UsagePrice "ignis|medium"))
            )
        )
    )
    (defun C_ToggleReservation (patron:string id:string toggle:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>TG_RESERVATION id toggle)
                (XI_ToggleReservation id toggle)
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
            (with-capability (DPTF|C>TG_TRANSFER-R id account toggle)
                (XI_ToggleTransferRole id account toggle)
                (XI_UpdateRoleTransferAmount id toggle)
                (XB_WriteRoles id account 4 toggle)
                (ref-DALOS::UDC_Cumulator price trigger [])
            )
        )
    )
    (defun C_Wipe:object{OuronetDalos.IgnisCumulator} 
        (patron:string id:string atbw:string)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (P|UR "TFT|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                (trigger:bool (ref-DALOS::IGNIS|URC_ZeroGAS id atbw))
                (ico:object{OuronetDalos.IgnisCumulator}
                     (ref-DALOS::UDC_Cumulator price trigger [])
                )
            )
            (with-capability (DPTF|C>WIPE id atbw)
                (XI_Wipe id atbw)
                ico
            )
        )
    )
    ;;{F7}
    (defun XB_Credit (id:string account:string amount:decimal)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "TFT|<"))
            ]
        )
        (if (URC_IzCoreDPTF id)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (snake-or-gas:bool (if (= id (ref-DALOS::UR_OuroborosID)) true false))
                    (read-balance:decimal (ref-DALOS::UR_TF_AccountSupply account snake-or-gas))
                )
                (enforce (> amount 0.0) "Crediting amount must be greater than zero, even for Primordial TrueFungibles")
                (with-capability (P|DPTF|CALLER)
                    (ref-DALOS::XB_UpdateBalance account snake-or-gas (+ read-balance amount))
                )
            )
            (let
                (
                    (dptf-account-exist:bool (URC_AccountExist id account))
                )
                (enforce (> amount 0.0) "Crediting amount must be greater than zero")
                (if (= dptf-account-exist false)
                    (insert DPTF|BalanceTable (concat [id BAR account])
                        {"exist"                    : true
                        ,"balance"                  : amount
                        ,"role-burn"                : false
                        ,"role-mint"                : false
                        ,"role-transfer"            : false
                        ,"role-fee-exemption"       : false
                        ,"frozen"                   : false}
                    )
                    (with-read DPTF|BalanceTable (concat [id BAR account])
                        {"exist"                    := e
                        ,"balance"                  := b
                        ,"role-burn"                := rb
                        ,"role-mint"                := rm
                        ,"role-transfer"            := rt
                        ,"role-fee-exemption"       := rfe
                        ,"frozen"                   := f}
                        (write DPTF|BalanceTable (concat [id BAR account])
                            {"exist"                : e
                            ,"balance"              : (+ b amount)
                            ,"role-burn"            : rb
                            ,"role-mint"            : rm
                            ,"role-transfer"        : rt
                            ,"role-fee-exemption"   : rfe
                            ,"frozen"               : f}
                        )
                    )
                )
            )
        )
    )
    ;;
    (defun XB_DebitStandard (id:string account:string amount:decimal dispo-data:object{UtilityDptf.DispoData})
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
            )
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (with-capability (SECURE)
                (XI_Debit id account amount dispo-data)
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
                (with-default-read DPTF|RoleTable id
                    {"r-burn"           : [BAR]
                    ,"r-mint"           : [BAR]
                    ,"r-fee-exemption"  : [BAR]
                    ,"r-transfer"       : [BAR]
                    ,"a-frozen"         : [BAR]}
                    {"r-burn"           := rb
                    ,"r-mint"           := rm
                    ,"r-fee-exemption"  := rfe
                    ,"r-transfer"       := rt
                    ,"a-frozen"         := af}
                    (if (= rp 1)
                        (write DPTF|RoleTable id
                            {"r-burn"           : (ref-U|DALOS::UC_NewRoleList rb account d)
                            ,"r-mint"           : rm
                            ,"r-fee-exemption"  : rfe
                            ,"r-transfer"       : rt
                            ,"a-frozen"         : af}
                        )
                        (if (= rp 2)
                            (write DPTF|RoleTable id
                                {"r-burn"           : rb
                                ,"r-mint"           : (ref-U|DALOS::UC_NewRoleList rm account d)
                                ,"r-fee-exemption"  : rfe
                                ,"r-transfer"       : rt
                                ,"a-frozen"         : af}
                            )
                            (if (= rp 3)
                                (write DPTF|RoleTable id
                                    {"r-burn"           : rb
                                    ,"r-mint"           : rm
                                    ,"r-fee-exemption"  : (ref-U|DALOS::UC_NewRoleList rfe account d)
                                    ,"r-transfer"       : rt
                                    ,"a-frozen"         : af}
                                )
                                (if (= rp 4)
                                    (write DPTF|RoleTable id
                                        {"r-burn"           : rb
                                        ,"r-mint"           : rm
                                        ,"r-fee-exemption"  : rfe
                                        ,"r-transfer"       : (ref-U|DALOS::UC_NewRoleList rt account d)
                                        ,"a-frozen"         : af}
                                    )
                                    (write DPTF|RoleTable id
                                        {"r-burn"           : rb
                                        ,"r-mint"           : rm
                                        ,"r-fee-exemption"  : rfe
                                        ,"r-transfer"       : rt
                                        ,"a-frozen"         : (ref-U|DALOS::UC_NewRoleList af account d)}
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
    (defun XE_Burn (id:string account:string amount:decimal)
        (enforce-guard (P|UR "TFT|<"))
        (with-capability (DPTF|C>BURN id account amount)
            (XI_BurnCore id account amount)
        )
    )
    (defun XE_IssueLP:object{OuronetDalos.IgnisCumulator}
        (patron:string account:string name:string ticker:string)
        @doc "Issues a DPTF Token as a Liquidity Pool Token. A LP DPTF follows specific rules in naming."
        (enforce-guard (P|UR "SWPU|<"))
        (with-capability (SECURE)
            (XB_IssueFree patron account [name] [ticker] [24] [false] [false] [true] [false] [false] [false] [true])
        )
    )
    (defun XE_ToggleBurnRole (id:string account:string toggle:bool)
        (enforce-guard (P|UR "ATS|<"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|C>TG_BURN-R id account toggle)
                (if (URC_IzCoreDPTF id)
                    (ref-DALOS::XE_UpdateBurnRole account (= id (ref-DALOS::UR_OuroborosID)) toggle)
                    (update DPTF|BalanceTable (concat [id BAR account])
                        {"role-burn" : toggle}
                    )
                )
            )
        )
    )
    (defun XE_ToggleFeeExemptionRole (id:string account:string toggle:bool)
        (enforce-guard (P|UR "ATS|<"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|C>TG_FEE-EXEMP-R id account toggle)
                (if (URC_IzCoreDPTF id)
                    (ref-DALOS::XE_UpdateFeeExemptionRole account (= id (ref-DALOS::UR_OuroborosID)) toggle)
                    (update DPTF|BalanceTable (concat [id BAR account])
                        {"role-fee-exemption" : toggle}
                    )
                )
            )
        )
    )
    (defun XE_ToggleMintRole (id:string account:string toggle:bool)
        (enforce-guard (P|UR "ATS|<"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPTF|S>TG_MINT-R id account toggle)
                (if (URC_IzCoreDPTF id)
                    (ref-DALOS::XE_UpdateMintRole account (= id (ref-DALOS::UR_OuroborosID)) toggle)
                    (update DPTF|BalanceTable (concat [id BAR account])
                        {"role-mint" : toggle}
                    )
                )
            )
        )
    )
    (defun XE_UpdateRewardBearingToken (atspair:string id:string)
        (enforce-guard (P|UR "ATS|<"))
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
    (defun XE_UpdateSpecialTrueFungible:object{OuronetDalos.IgnisCumulator} 
        (main-dptf:string secondary-dptf:string frozen-or-reserved:bool)
        (enforce-guard (P|UR "VST|<"))
        (with-capability (DPTF|C>UPDATE-SPECIAL main-dptf secondary-dptf frozen-or-reserved)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (price:decimal (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-DALOS::UDC_Cumulator price trigger [])
                    )
                )
                (if frozen-or-reserved
                    (do
                        (XI_UpdateFrozen main-dptf secondary-dptf)
                        (XI_UpdateFrozen secondary-dptf main-dptf)
                    )
                    (do
                        (XI_UpdateReserved main-dptf secondary-dptf)
                        (XI_UpdateReserved secondary-dptf main-dptf)
                    )
                )
                ico
            )
        )
    )
    (defun XE_UpdateVesting (dptf:string dpmf:string)
        (enforce-guard (P|UR "DPMF|<"))
        (update DPTF|PropertiesTable dptf
            {"vesting-link" : dpmf}
        )
    )
    (defun XE_UpdateSleeping (dptf:string dpmf:string)
        (enforce-guard (P|UR "DPMF|<"))
        (update DPTF|PropertiesTable dptf
            {"sleeping-link" : dpmf}
        )
    )
    (defun XE_UpdateFeeVolume (id:string amount:decimal primary:bool)
        (enforce-guard (P|UR "TFT|<"))
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
    (defun XE_UpdateRewardToken (atspair:string id:string direction:bool)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (P|UR "ATS|<"))
                (enforce-guard (P|UR "ATSU|<"))
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
    ;;
    (defun XI_BurnCore (id:string account:string amount:decimal)
        (require-capability (DPTF|C>BURN id account amount))
        (let
            (
                (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                (empty-dispo:object{UtilityDptf.DispoData} (ref-U|DPTF::EmptyDispo))
            )
            (XB_DebitStandard id account amount empty-dispo)
            (XI_UpdateSupply id amount false)
        )
    )
    (defun XI_ChangeOwnership (id:string new-owner:string)
        (require-capability (DPTF|S>RT_OWN id new-owner))
        (update DPTF|PropertiesTable id
            {"owner-konto"                      : new-owner}
        )
    )
    (defun XI_Control (id:string can-change-owner:bool can-upgrade:bool can-add-special-role:bool can-freeze:bool can-wipe:bool can-pause:bool)
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
    ;;
    (defun XI_Debit (id:string account:string amount:decimal dispo-data:object{UtilityDptf.DispoData})
        (require-capability (SECURE))
        (if (URC_IzCoreDPTF id)
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ouro-id:string (ref-DALOS::UR_OuroborosID))
                    (ea-id:string (ref-DALOS::UR_EliteAurynID))
                    (snake-or-gas:bool (if (= id ouro-id) true false))
                    (read-balance:decimal (ref-DALOS::UR_TF_AccountSupply account snake-or-gas))
                )
                (with-capability (P|DPTF|CALLER)
                    (if snake-or-gas
                        (if (= ea-id BAR)
                            (do
                                (enforce (<= amount read-balance) "Insufficient OURO Funds for debiting")
                                (ref-DALOS::XB_UpdateBalance account snake-or-gas (- read-balance amount))
                            )
                            (let
                                (
                                    (max-dispo-ouro (ref-U|DPTF::UC_OuroDispo dispo-data))
                                )
                                (enforce (>= (- read-balance amount) (- 0.0 max-dispo-ouro)) "Ouro Transfer Amount outr of Dispo Bounds")
                                (ref-DALOS::XB_UpdateBalance account snake-or-gas (- read-balance amount))
                            )
                        )
                        (do
                            (enforce (<= amount read-balance) "Insufficient IGNIS Funds for debiting")
                            (ref-DALOS::XB_UpdateBalance account snake-or-gas (- read-balance amount))
                        )
                    )
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
    (defun XI_DebitAdmin (id:string account:string amount:decimal)
        (require-capability (SECURE))
        (let
            (
                (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                (empty-dispo:object{UtilityDptf.DispoData} (ref-U|DPTF::EmptyDispo))
            )
            (CAP_Owner id)
            (XI_Debit id account amount empty-dispo)
        )
    )
    (defun XI_IncrementFeeUnlocks (id:string)
        (require-capability (SECURE))
        (with-read DPTF|PropertiesTable id
            { "fee-unlocks" := fu }
            (enforce (< fu 7) (format "Cannot increment Fee Unlocks for Token {}" [id]))
            (update DPTF|PropertiesTable id
                {"fee-unlocks" : (+ fu 1)}
            )
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
            iz-special:bool
        )
        (require-capability (SECURE))
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (id:string (ref-U|DALOS::UDC_Makeid ticker))
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
            )
            (ref-U|DALOS::UEV_Decimals decimals)
            (ref-U|DALOS::UEV_NameOrTicker name true iz-special)
            (ref-U|DALOS::UEV_NameOrTicker ticker false iz-special)
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
                ,"vesting-link"         : BAR
                ,"sleeping-link"        : BAR
                ,"frozen-link"          : BAR
                ,"reservation-link"     : BAR
                ,"reservation"          : false}
            )
            (C_DeployAccount id account)    
            id
        ) 
    )
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
            iz-special:[bool]
        )
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "VST|<"))
            ]
        )
        (with-capability (DPTF|C>ISSUE account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-BRD:module{Branding} BRD)
                    (l1:integer (length name))
                    (ignis-issue-cost:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                    (gas-costs:decimal (* (dec l1) ignis-issue-cost))
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
                (ref-DALOS::UDC_Cumulator gas-costs trigger folded-lst)
            )
        )
    )
    (defun XI_Mint (id:string account:string amount:decimal origin:bool)
        (if origin
            (require-capability (DPTF|C>MINT-ORG id amount ))
            (require-capability (DPTF|C>MINT-STD id account amount))
        )
        (XB_Credit id account amount)
        (XI_UpdateSupply id amount true)
        (if origin
            (update DPTF|PropertiesTable id
                {"origin-mint"          : false
                ,"origin-mint-amount"   : amount}
            )
            true
        )
    )
    (defun XI_SetFee (id:string fee:decimal)
        (require-capability (DPTF|S>SET_FEE id fee))
        (update DPTF|PropertiesTable id
            { "fee-promile" : fee}
        )
    )
    (defun XI_SetFeeTarget (id:string target:string)
        (require-capability (DPTF|S>SET_FEE-TARGET id target))
        (update DPTF|PropertiesTable id
            { "fee-target" : target}
        )
    )
    (defun XI_SetMinMove (id:string min-move-value:decimal)
        (require-capability (DPTF|S>SET_MIN-MOVE id min-move-value))
        (update DPTF|PropertiesTable id
            { "min-move" : min-move-value}
        )
    )
    (defun XI_ToggleFee(id:string toggle:bool)
        (require-capability (DPTF|S>TG_FEE id toggle))
        (update DPTF|PropertiesTable id
            { "fee-toggle" : toggle}
        )
    )
    (defun XI_ToggleFeeLock:[decimal] (id:string toggle:bool)
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
    (defun XI_ToggleFreezeAccount (id:string account:string toggle:bool)
        (require-capability (DPTF|C>X_FRZ-ACC id account toggle))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (ref-DALOS::XE_UpdateFreeze account (= id (ref-DALOS::UR_OuroborosID)) toggle)
                (update DPTF|BalanceTable (concat [id BAR account])
                    { "frozen" : toggle}
                )
            )
        )
    )
    (defun XI_TogglePause (id:string toggle:bool)
        (require-capability (DPTF|S>TG_PAUSE id toggle))
        (update DPTF|PropertiesTable id
            { "is-paused" : toggle}
        )
    )
    (defun XI_ToggleReservation (id:string toggle:bool)
        (require-capability (DPTF|S>TG_RESERVATION id toggle))
        (update DPTF|PropertiesTable id
            { "reservation" : toggle}
        )
    )
    (defun XI_ToggleTransferRole (id:string account:string toggle:bool)
        (require-capability (DPTF|C>X_TG_TRANSFER-R id account toggle))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (ref-DALOS::XE_UpdateTransferRole account (= id (ref-DALOS::UR_OuroborosID)) toggle)
                (update DPTF|BalanceTable (concat [id BAR account])
                    {"role-transfer" : toggle}
                )
            )
        )
    )
    (defun XI_UpdateFrozen (core-dptf:string frozen-dptf:string)
        (require-capability (SECURE))
        (update DPTF|PropertiesTable core-dptf
            {"frozen-link" : frozen-dptf}
        )
    )
    (defun XI_UpdateReserved (core-dptf:string reserved-dptf:string)
        (require-capability (SECURE))
        (update DPTF|PropertiesTable core-dptf
            {"reservation-link" : reserved-dptf}
        )
    )
    (defun XI_UpdateRoleTransferAmount (id:string direction:bool)
        (require-capability (SECURE))
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
    (defun XI_UpdateSupply (id:string amount:decimal direction:bool)
        (require-capability (SECURE))
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
    (defun XI_Wipe (id:string account-to-be-wiped:string)
        (require-capability (DPTF|C>WIPE id account-to-be-wiped))
        (let
            (
                (amount-to-be-wiped:decimal (UR_AccountSupply id account-to-be-wiped))
            )
            (if (> amount-to-be-wiped 0.0)
                (do
                    (XI_DebitAdmin id account-to-be-wiped amount-to-be-wiped)
                    (XI_UpdateSupply id amount-to-be-wiped false)
                )
                "Negative Amounts cant be wiped"
            )
        )
    )
    
)

(create-table P|T)
(create-table DPTF|PropertiesTable)
(create-table DPTF|BalanceTable)
(create-table DPTF|RoleTable)