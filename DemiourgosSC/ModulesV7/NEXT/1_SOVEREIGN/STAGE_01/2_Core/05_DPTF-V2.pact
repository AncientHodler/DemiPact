;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module DPTF GOV
    ;;
    (implements OuronetPolicy)
    (implements BrandingUsageV9)
    (implements DemiourgosPactTrueFungibleV6)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPTF           (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|DPTF_ADMIN)))
    (defcap GOV|DPTF_ADMIN ()       (enforce-guard GOV|MD_DPTF))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|DPTF|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPTF|CALLER))
        (compose-capability (SECURE))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|DPTF_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPTF_ADMIN)
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
                (mg:guard (create-capability-guard (P|DPTF|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
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
    (defschema DPTF|PropertiesSchemaV2
        owner-konto:string
        name:string
        ticker:string
        decimals:integer
        ;;
        can-upgrade:bool
        can-change-owner:bool
        can-add-special-role:bool
        can-freeze:bool
        can-wipe:bool
        can-pause:bool
        ;;
        is-paused:bool
        ;;
        supply:decimal
        origin-mint:bool
        origin-mint-amount:decimal
        ;;
        ;;role-transfer-amount:integer      [x]Removed in V2
        ;;
        fee-toggle:bool
        min-move:decimal
        fee-promile:decimal
        fee-target:string
        fee-lock:bool
        fee-unlocks:integer
        primary-fee-volume:decimal
        secondary-fee-volume:decimal
        ;;
        reward-token:[string]
        reward-bearing-token:[string]
        ;;
        vesting-link:string
        sleeping-link:string
        hibernation-link:string             ;[x]Added in V2
        frozen-link:string
        reservation-link:string
        reservation:bool
    )
    (defschema DPTF|RoleSchema
        a-frozen:[string]
        r-burn:[string]
        r-mint:[string]
        r-fee-exemption:[string]
        r-transfer:[string]
    )
    ;;{2}
    (deftable DPTF|PropertiesTable:{DPTF|PropertiesSchemaV2})           ;;Key = <DPTF-id>
    (deftable DPTF|RoleTable:{DPTF|RoleSchema})                         ;;Key = <DPTF-id>
    (deftable DPTF|BalanceTable:{OuronetDalosV5.DPTF|BalanceSchemaV2})  ;;Key = <DPTF-id> + BAR + <account> 
    ;;{3}
    (defun CT_Bar ()            (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR               (CT_Bar))
    (defconst DALOS|SC_NAME     (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|DALOS|SC_NAME)))
    (defconst OUROBOROS|SC_NAME (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|OUROBOROS|SC_NAME)))
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    (defcap DPTF|S>ROTATE-OWNERSHIP (id:string new-owner:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::UEV_SenderWithReceiver (UR_Konto id) new-owner)
            (ref-DALOS::UEV_EnforceAccountExists new-owner)
            (CAP_Owner id)
            (UEV_CanChangeOwnerON id)
        )
    )
    (defcap DPTF|S>CONTROL (id:string)
        @event
        (CAP_Owner id)
        (UEV_CanUpgradeON id)
    )
    (defcap DPTF|S>TOGGLE_PAUSE (id:string pause:bool)
        @event
        (if pause
            (UEV_CanPauseON id)
            true
        )
        (CAP_Owner id)
        (UEV_PauseState id (not pause))
    )
    (defcap DPTF|S>TOGGLE_RESERVATION (id:string toggle:bool)
        @event
        (CAP_Owner id)
        (UEV_ReservationState id (not toggle))
    )
    ;;
    (defcap DPTF|S>SET_FEE (id:string fee:decimal)
        @event
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
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
                (ref-DALOS:module{OuronetDalosV5} DALOS)
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
    (defcap DPTF|S>TOGGLE_FEE (id:string toggle:bool)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
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
    (defcap GOV|SET_TREASURY-DISPO (type:integer tdp:decimal tds:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ouro:string (ref-DALOS::UR_OuroborosID))
                (ouro-supply:decimal (UR_Supply ouro))
                (op:integer (UR_Decimals ouro))
                (treasury:string (at 0 (ref-DALOS::UR_DemiurgoiID)))
                (treasury-supply:decimal (UR_AccountSupply ouro treasury))
            )
            ;;Type can only pe 0, 1, 2 or 3
            ;;Type 0 = No Treasury Dispo
            ;;Type 1 = Maximum Dispo equal to Total Supply
            ;;Type 2 = Percent Based Dispo
            ;:Type 3 = Absolute Value Dispo in Thousands
            (enforce (= (contains type (enumerate 0 3)) true) "Treasury Dispo Type can only be 0, 1, 2 or 3!")
            (let
                (
                    (lowest-dispo:decimal (UC_TreasuryLowestDispo ouro-supply op type tdp tds))
                )
                (enforce
                    (<= lowest-dispo treasury-supply)
                    (format "A Type {} Treasury Dispo cannot be set at {} because it surpases the Current Treasury Value of {}" [type tdp treasury-supply])
                )
                (compose-capability (GOV|DPTF_ADMIN))
            )
        )
    )
    (defcap GOV|WIPE_ALL-TREASURY-DEBT ()
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ouro:string (ref-DALOS::UR_OuroborosID))
                (ouro-supply:decimal (UR_Supply ouro))
                (op:integer (UR_Decimals ouro))
                (treasury:string (at 0 (ref-DALOS::UR_DemiurgoiID)))
                (treasury-supply:decimal (UR_AccountSupply ouro treasury))
            )
            (enforce (< treasury-supply 0.0) "Cannot Wipe Positive Treasury Balance")
            (compose-capability (GOV|DPTF_ADMIN))
            (compose-capability (SECURE))
        )
    )
    (defcap GOV|WIPE_PARTIAL-TREASURY-DEBT (debt-to-be-wiped:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ouro:string (ref-DALOS::UR_OuroborosID))
                (ouro-supply:decimal (UR_Supply ouro))
                (op:integer (UR_Decimals ouro))
                (treasury:string (at 0 (ref-DALOS::UR_DemiurgoiID)))
                (treasury-supply:decimal (UR_AccountSupply ouro treasury))
            )
            (enforce (< treasury-supply 0.0) "Cannot Wipe Positive Treasury Balance")
            (enforce (<= debt-to-be-wiped (abs treasury-supply))
                "Debt to be wiped must be smaller than or equal to the absolute value of the current Treasury Debt"
            )
            (compose-capability (GOV|DPTF_ADMIN))
            (compose-capability (SECURE))
        )
    )
    ;;
    (defcap DPTF|C>UPDATE-BRD (dptf:string)
        @event
        (UEV_ParentOwnership dptf)
        (compose-capability (P|DPTF|CALLER))
    )
    (defcap DPTF|C>UPGRADE-BRD (dptf:string)
        @event
        (UEV_ParentOwnership dptf)
        (compose-capability (P|DPTF|CALLER))
    )
    ;;
    (defcap DPTF|C>ISSUE (account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
        @event
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
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
    ;;
    (defcap DPTF|C>TOGGLE_FEE-LOCK (id:string toggle:bool)
        @event
        (compose-capability (DPTF|S>X_TG_FEE-LOCK id toggle))
        (compose-capability (SECURE))
    )
    ;;
    (defcap DPTF|C>FREEZE (id:string account:string frozen:bool)
        @doc "Toggle Verum 1"
        @event
        (compose-capability (DPTF|C>X_FREEZE id account frozen))
        (compose-capability (SECURE))
    )
    (defcap DPTF|C>X_FREEZE (id:string account:string frozen:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::UEV_NotSmartOuronetAccount account)
            (CAP_Owner id)
            (UEV_AccountFreezeState id account (not frozen))
            (if frozen
                (UEV_CanFreezeON id)
                true
            )
            (compose-capability (P|DPTF|CALLER))
        )
    )
    (defcap DPTF|C>TOGGLE-BURN-ROLE (id:string account:string toggle:bool)
        @doc "Toggle Verum 2"
        @event
        (compose-capability (DPTF|C>X_TOGGLE-BURN-ROLE id account toggle))
        (compose-capability (SECURE))
    )
    (defcap DPTF|C>X_TOGGLE-BURN-ROLE (id:string account:string toggle:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::UEV_NotSmartOuronetAccount account)
            (CAP_Owner id)
            (UEV_AccountBurnState id account (not toggle))
            (if toggle
                (UEV_CanAddSpecialRoleON id)
                true
            )
            (compose-capability (P|DPTF|CALLER))
        )
    )
    (defcap DPTF|C>TOGGLE-MINT-ROLE (id:string account:string toggle:bool)
        @doc "Toggle Verum 3"
        @event
        (compose-capability (DPTF|C>X_TOGGLE-MINT-ROLE id account toggle))
        (compose-capability (SECURE))
    )
    (defcap DPTF|C>X_TOGGLE-MINT-ROLE (id:string account:string toggle:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::UEV_NotSmartOuronetAccount account)
            (CAP_Owner id)
            (UEV_AccountMintState id account (not toggle))
            (if toggle
                (UEV_CanAddSpecialRoleON id)
                true
            )
        )
        (compose-capability (P|DPTF|CALLER))
    )
    (defcap DPTF|C>TOGGLE-FEE-EXEMPTION-ROLE (id:string account:string toggle:bool)
        @doc "Toggle Verum 4"
        @event
        (compose-capability (DPTF|C>X_TOGGLE-FEE-EXEMPTION-ROLE id account toggle))
        (compose-capability (SECURE))
    )
    (defcap DPTF|C>X_TOGGLE-FEE-EXEMPTION-ROLE (id:string account:string toggle:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::UEV_NotSmartOuronetAccount account)
            (ref-DALOS::UEV_EnforceAccountType account true)
            (CAP_Owner id)
            (UEV_AccountFeeExemptionState id account (not toggle))
            (if toggle
                (UEV_CanAddSpecialRoleON id)
                true
            )
            (compose-capability (P|DPTF|CALLER))
        )
    )
    (defcap DPTF|C>TOGGLE_TRANSFER-ROLE (id:string account:string toggle:bool)
        @doc "Toggle Verum 5"
        @event
        (compose-capability (DPTF|C>X_TOGGLE-TRANSFER-ROLE id account toggle))
        (compose-capability (SECURE))
    )
    (defcap DPTF|C>X_TOGGLE-TRANSFER-ROLE (id:string account:string toggle:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (special:[string] ["F|" "R|"])
                (ft:string (take 2 id))
                (iz-special:bool (contains ft special))
            )
            ;;Frozen and Reserved Special Tokens can use Core Smart Ouronet Accounts for Transfer Roles Setup.
            (if (not iz-special)
                (do
                    (ref-DALOS::UEV_NotSmartOuronetAccount account)
                    (UEV_AccountTransferState id account (not toggle))
                )
                true
            )
            (CAP_Owner id)
            (if toggle
                (UEV_CanAddSpecialRoleON id)
                true
            )
            (compose-capability (P|DPTF|CALLER))
        )
    )
    (defcap DPTF|C>BURN (id:string client:string amount:decimal)
        @event
        (let
            (
                (ref-U|DPTF:module{UtilityDptf} U|DPTF)
            )
            (UEV_AccountBurnState id client true)
            (compose-capability (DPTF|C>DEBIT client id amount (ref-U|DPTF::EmptyDispo) false))
        )
    )
    (defcap DPTF|C>MINT (id:string client:string amount:decimal origin:bool)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership client)
            (if origin
                (do
                    (CAP_Owner id)
                    (UEV_Virgin id)
                    (ref-DALOS::UEV_NotSmartOuronetAccount client)
                )
                (UEV_AccountMintState id client true)  
            )
            (compose-capability (DPTF|C>CREDIT client id amount))
        )
    )
    (defcap DPTF|C>WIPE-SLIM (id:string account-to-be-wiped:string amount:decimal)
        @event
        (compose-capability (DPTF|C>X_WIPE id account-to-be-wiped amount))
    )
    (defcap DPTF|C>WIPE (id:string account-to-be-wiped:string)
        @event
        (compose-capability (DPTF|C>X_WIPE id account-to-be-wiped (UR_AccountSupply id account-to-be-wiped)))
    )
    (defcap DPTF|C>X_WIPE (id:string account-to-be-wiped:string amount:decimal)
        (let
            (
                (ref-U|DPTF:module{UtilityDptf} U|DPTF)
            )
            (UEV_CanWipeON id)
            (UEV_AccountFreezeState id account-to-be-wiped true)
            (compose-capability (DPTF|C>DEBIT account-to-be-wiped id (ref-U|DPTF::EmptyDispo) true))
        )
    )
    ;;
    (defcap DPTF|C>DEBIT (account:string id:string amount:decimal dispo-data:object{UtilityDptf.DispoData} wipe-mode:bool)
        (UEV_Amount id amount)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (current-supply:decimal (UR_AccountSupply id account))
                (debit-result:decimal (- current-supply amount))
                (ouro-id:string (ref-DALOS::UR_OuroborosID))
            )
            (if (= id ouro-id)
                (let
                    (
                        (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                        (ea-id:string (ref-DALOS::UR_EliteAurynID))
                        (treasury:string (at 0 (ref-DALOS::UR_DemiurgoiID)))
                        (account-type:bool (ref-DALOS::UR_AccountType account))
                        (lowest-dispo:decimal
                            (if account-type
                                (if (= account treasury)
                                    (URC_TreasuryLowestDispo)
                                    0.0
                                )
                                (if (= ea-id BAR)
                                    0.0
                                    (- (ref-U|DPTF::UC_OuroDispo dispo-data))
                                )
                            )
                        )
                    )
                    (enforce (>= debit-result lowest-dispo) "Cannot Debit OURO, dispo capabilities exceeded!")
                )
                (enforce (>= debit-result 0.0) (format "Cannot Debit DPTF {] into the negatives" [id]))
            )
            (if wipe-mode
                (CAP_Owner id)
                (ref-DALOS::CAP_EnforceAccountOwnership account)
            )
            (if (and (= id ouro-id) wipe-mode)
                (enforce (> current-supply 0.0) "Can only Debit positive OURO Amounts")
                true
            )
            (compose-capability (SECURE))
        )
    )
    (defcap DPTF|C>CREDIT (account:string id:string amount:decimal)
        (UEV_Amount id amount)
        (compose-capability (SECURE))
    )
    (defcap DPTF|C>UPDATE-SPECIAL (main-dptf:string secondary-dptf:string fr-tag:integer)
        (enforce (contains fr-tag [1 2]) "Invalid Frozen|Reserve Tag")
        (let
            (
                (main-special-id:string
                    (cond
                        ((= fr-tag 1) (UR_Frozen main-dptf))
                        ((= fr-tag 2) (UR_Reservation main-dptf))
                        BAR
                    )
                )
                (secondary-special-id:string
                    (cond
                        ((= fr-tag 1) (UR_Frozen secondary-dptf))
                        ((= fr-tag 2) (UR_Reservation secondary-dptf))
                        BAR
                    )
                )
                (iz-secondary-rt:bool (URC_IzRT secondary-dptf))
                (iz-secondary-rbt:bool (URC_IzRBT secondary-dptf))
                (main-dptf-ftc:string (take 2 main-dptf))
            )
            (CAP_Owner main-dptf)
            (CAP_Owner secondary-dptf)
            (enforce
                (and (= main-special-id BAR) (= secondary-special-id BAR) )
                "Special True Fungible Links (Frozen or Reserved) are immutable !"
            )
            (enforce
                (and (not iz-secondary-rt) (not iz-secondary-rbt))
                "Special True Fungible cannot be RTs or Cold-RBTs"
            )
            (cond
                ((= fr-tag 1)
                    (enforce
                        (not (contains main-dptf-ftc ["R|" "F|"]))
                        (format "When setting a Frozen Link, the main DPTF {} cannot be a Special Token" [main-dptf])
                        ;;But can be an LP Token
                    )
                )
                ((= fr-tag 2)
                    (enforce
                        (not (contains main-dptf-ftc ["R|" "F|" "S|" "W|" "P|"]))
                        (format "When setting a Reserve Link, the main DPTF {} cannot be a Special or LP Token" [main-dptf])
                    )
                )
                true
            )
            (compose-capability (SECURE))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun URU_UpgradeTruefungibleToV2 (ids:[string])
        (map
            (lambda
                (id:string)
                (UR_Hibernation id)
            )
            ids
        )
    )
    (defun UC_IdAccount:string (id:string account:string)
        (format "{}{}{}" [id BAR account])
    )
    (defun UC_VolumetricTax (id:string amount:decimal)
        (let
            (
                (ref-U|DPTF:module{UtilityDptf} U|DPTF)
            )
            (UEV_Amount id amount)
            (ref-U|DPTF::UC_VolumetricTax (UR_Decimals id) amount)
        )
    )
    (defun UC_TreasuryLowestDispo
        (ouro-supply:decimal ouro-precision:integer dispo-type:integer tdp:decimal tds:decimal)
        (let
            (
                (max-dispo:decimal
                    (cond
                        ((= dispo-type 1) ouro-supply)
                        ((= dispo-type 2) (floor (/ (* tdp ouro-supply) 1000.0) ouro-precision))
                        ((= dispo-type 3) (floor (* tds 1000.0) ouro-precision))
                        0.0
                    )
                )
            )
            (- 0.0 max-dispo)
        )
    )
    ;;{F0}  [UR]
    (defun UR_P-KEYS:[string] ()
        (keys DPTF|PropertiesTable)
    )
    (defun UR_KEYS:[string] ()
        (keys DPTF|BalanceTable)
    )
    ;;
    ;;
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
    ;;
    (defun UR_CanUpgrade:bool (id:string)
        (at "can-upgrade" (read DPTF|PropertiesTable id ["can-upgrade"]))
    )
    (defun UR_CanChangeOwner:bool (id:string)
        (at "can-change-owner" (read DPTF|PropertiesTable id ["can-change-owner"]))
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
    ;;
    (defun UR_Paused:bool (id:string)
        (at "is-paused" (read DPTF|PropertiesTable id ["is-paused"]))
    )
    ;;
    (defun UR_Supply:decimal (id:string)
        (at "supply" (read DPTF|PropertiesTable id ["supply"]))
    )
    (defun UR_OriginMint:bool (id:string)
        (at "origin-mint" (read DPTF|PropertiesTable id ["origin-mint"]))
    )
    (defun UR_OriginAmount:decimal (id:string)
        (at "origin-mint-amount" (read DPTF|PropertiesTable id ["origin-mint-amount"]))
    )
    ;;
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
    ;;
    (defun UR_RewardToken:[string] (id:string)
        (at "reward-token" (read DPTF|PropertiesTable id ["reward-token"]))
    )
    (defun UR_RewardBearingToken:[string] (id:string)
        (at "reward-bearing-token" (read DPTF|PropertiesTable id ["reward-bearing-token"]))
    )
    ;;
    (defun UR_Vesting:string (id:string)
        (at "vesting-link" (read DPTF|PropertiesTable id ["vesting-link"]))
    )
    (defun UR_Sleeping:string (id:string)
        (at "sleeping-link" (read DPTF|PropertiesTable id ["sleeping-link"]))
    )
    (defun UR_Hibernation:string (id:string)
        (let
            (
                (default-value:string BAR)
                (temp (read DPTF|PropertiesTable id ["hibernation-link"]))
                (needs-populate:bool (= temp {}))
                (link:string (if needs-populate default-value (at "hibernation-link" temp)))
            )
            (if needs-populate
                (update DPTF|PropertiesTable id 
                    {"hibernation-link": default-value}
                )
                true  ; No-op if already populated
            )
            link
        )
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
    ;;
    (defun UR_IzId:bool (id:string)
        (let
            (
                (trial (try false (read DPTF|PropertiesTable id))) 
            )
            (if (= (typeof trial) "bool") false true)
        )
    )
    ;;
    ;;
    (defun UR_Verum1:[string] (id:string)
        (at "a-frozen" (read DPTF|RoleTable id ["a-frozen"]))
    )
    (defun UR_Verum2:[string] (id:string)
        (at "r-burn" (read DPTF|RoleTable id ["r-burn"]))
    )
    (defun UR_Verum3:[string] (id:string)
        (at "r-mint" (read DPTF|RoleTable id ["r-mint"]))
    )
    (defun UR_Verum4:[string] (id:string)
        (at "r-fee-exemption" (read DPTF|RoleTable id ["r-fee-exemption"]))
    )
    (defun UR_Verum5:[string] (id:string)
        (at "r-transfer" (read DPTF|RoleTable id ["r-transfer"]))
    )
    ;;
    ;;
    (defun UR_IzAccount:bool (id:string account:string)
        (let
            (
                (trial (try false (read DPTF|BalanceTable (UC_IdAccount id account))))
            )
            (if (= (typeof trial) "bool") false true)
        )
    )
    (defun UR_AccountSupply:decimal (id:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (ref-DALOS::UR_TF_AccountSupply account (= id (ref-DALOS::UR_OuroborosID)))
                (with-default-read DPTF|BalanceTable (UC_IdAccount id account)
                    { "balance" : 0.0 }
                    { "balance" := b}
                    b
                )
            )
        )
    )
    (defun UR_AccountFrozenState:bool (id:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (and
                (if (URC_IzCoreDPTF id)
                    (ref-DALOS::UR_TF_AccountFreezeState account (= id (ref-DALOS::UR_OuroborosID)))
                    (with-default-read DPTF|BalanceTable (UC_IdAccount id account)
                        { "frozen" : false}
                        { "frozen" := fr }
                        fr
                    )
                )
                (not (ref-DALOS::UR_AutonomicRoles account))
            )
        )
    )
    (defun UR_AccountRoleBurn:bool (id:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (or
                (if (URC_IzCoreDPTF id)
                    (ref-DALOS::UR_TF_AccountRoleBurn account (= id (ref-DALOS::UR_OuroborosID)))
                    (with-default-read DPTF|BalanceTable (UC_IdAccount id account)
                        { "role-burn" : false}
                        { "role-burn" := rb }
                        rb
                    )
                )
                (ref-DALOS::UR_AutonomicRoles account)
            )
            
        )
    )
    (defun UR_AccountRoleMint:bool (id:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (or
                (if (URC_IzCoreDPTF id)
                    (ref-DALOS::UR_TF_AccountRoleMint account (= id (ref-DALOS::UR_OuroborosID)))
                    (with-default-read DPTF|BalanceTable (UC_IdAccount id account)
                        { "role-mint" : false}
                        { "role-mint" := rm }
                        rm
                    )
                )
                (ref-DALOS::UR_AutonomicRoles account)
            )
        )
    )
    (defun UR_AccountRoleTransfer:bool (id:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (or
                (if (URC_IzCoreDPTF id)
                    (ref-DALOS::UR_TF_AccountRoleTransfer account (= id (ref-DALOS::UR_OuroborosID)))
                    (with-default-read DPTF|BalanceTable (UC_IdAccount id account)
                        { "role-transfer" : false}
                        { "role-transfer" := rt }
                        rt
                    )
                )
                (ref-DALOS::UR_AutonomicRoles account)
            )
            
        )
    )
    (defun UR_AccountRoleFeeExemption:bool (id:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (owner:string (UR_Konto id))
            )
            (fold (or) false
                [
                    (if (URC_IzCoreDPTF id)
                        (ref-DALOS::UR_TF_AccountRoleFeeExemption account (= id (ref-DALOS::UR_OuroborosID)))
                        (with-default-read DPTF|BalanceTable (UC_IdAccount id account)
                            { "role-fee-exemption" : false}
                            { "role-fee-exemption" := rfe }
                            rfe
                        )
                    )
                    (= account owner)
                    (ref-DALOS::UR_AutonomicRoles account)
                ]
            )
        )
    )
    ;;{F1}  [URC]
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
                (ref-DALOS:module{OuronetDalosV5} DALOS)
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
    ;;
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
    (defun URC_HasHibernation:bool (id:string)
        @doc "Returns a boolean if DPTF has a hibernation counterpart"
        (if (= (UR_Hibernation id) BAR)
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
    (defun URC_Parent:string (dptf:string)
        @doc "Computes <dptf> parent"
        (let
            (
                (fourth:string (drop 3 (take 4 dptf)))
            )
            (enforce (!= fourth BAR) "Frozen LP Tokens not allowed for this operation")
            (let
                (
                    (first-two:string (take 2 dptf))
                )
                (cond
                    ((= first-two "F|") (UR_Frozen dptf))
                    ((= first-two "R|") (UR_Reservation dptf))
                    dptf
                )
            )
        )
    )
    (defun URC_TreasuryLowestDispo:decimal ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ouro:string (ref-DALOS::UR_OuroborosID))
            )
            (UC_TreasuryLowestDispo
                (UR_Supply ouro)
                (UR_Decimals ouro)
                (ref-DALOS::UR_DispoType)
                (ref-DALOS::UR_DispoTDP)
                (ref-DALOS::UR_DispoTDS)
            )
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_ParentOwnership (dptf:string)
        @doc "Enforces: \
            \ <dptf> Ownership, if <dptf> is pure \
            \ <(UR_Frozen dptf)>, if its a f|dptf \
            \ (UR_Reservation dptf), if its a r|dptf \
            \ While ensuring a Frozen LP cant be used for this operation."
        (CAP_Owner (URC_Parent dptf))
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
                (enforce x (format "{} must not be paused for action" [id]))
                (enforce (not x) (format "{} is paused; transfers are paused" [id]))
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
    (defun UEV_Hibernation (id:string existance:bool)
        (let
            (
                (has-hibernation:bool (URC_HasHibernation id))
            )
            (enforce (= has-hibernation existance) (format "Hibernation for the Token {} is not satisfied with existance {}" [id existance]))
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
    ;;{F3}  [UDC]
    (defun UDC_VerumRoles:object{DPTF|RoleSchema}
        (a:[string] b:[string] c:[string] d:[string] e:[string])
        {"a-frozen"             : a
        ,"r-burn"               : b
        ,"r-mint"               : c
        ,"r-fee-exemption"      : d
        ,"r-transfer"           : e}
    )
    (defun UDC_TrueFungibleAccount:object{OuronetDalosV5.DPTF|BalanceSchemaV2}
        (a:decimal b:bool c:bool d:bool e:bool f:bool)
        {"balance"              : a
        ,"frozen"               : b
        ,"role-burn"            : c
        ,"role-mint"            : d
        ,"role-transfer"        : e
        ,"role-fee-exemption"   : f}
    )
    ;;{F4}  [CAP]
    (defun CAP_Owner (id:string)
        @doc "Enforces DPTF Token ID Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (UR_Konto id))
        )
    )
    ;;
    ;;{F5}  [A]
    (defun A_UpdateTreasury (type:integer tdp:decimal tds:decimal)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (with-capability (GOV|SET_TREASURY-DISPO type tdp tds)
                (ref-DALOS::XE_UpdateTreasury type tdp tds)
            )
        )
    )
    (defun A_WipeTreasuryDebt ()
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ouro:string (ref-DALOS::UR_OuroborosID))
                (treasury:string (at 0 (ref-DALOS::UR_DemiurgoiID)))
                (treasury-supply:decimal (UR_AccountSupply ouro treasury))
            )
            (with-capability (GOV|WIPE_ALL-TREASURY-DEBT)
                (C_Mint ouro treasury (abs treasury-supply) false)
                (ref-DALOS::XE_UpdateTreasury 0 0.0 0.0)
            )
        )
    )
    (defun A_WipeTreasuryDebtPartial (debt-to-be-wiped:decimal)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ouro:string (ref-DALOS::UR_OuroborosID))
                (treasury:string (at 0 (ref-DALOS::UR_DemiurgoiID)))
                (treasury-supply:decimal (UR_AccountSupply ouro treasury))
            )
            (with-capability (GOV|WIPE_PARTIAL-TREASURY-DEBT debt-to-be-wiped)
                (C_Mint ouro treasury debt-to-be-wiped false)
            )
        )
    )
    ;;{F6}  [C]
    (defun C_UpdatePendingBranding:object{IgnisCollectorV2.OutputCumulator}
        (entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-BRD:module{Branding} BRD)
            )
            (with-capability (DPTF|C>UPDATE-BRD entity-id)
                (ref-BRD::XE_UpdatePendingBranding entity-id logo description website social)
                (ref-IGNIS::UDC_BrandingCumulator (UR_Konto entity-id) 1.0)
            )
        )
    )
    (defun C_UpgradeBranding (patron:string entity-id:string months:integer)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-BRD:module{Branding} BRD)
                (parent:string (URC_Parent entity-id))
                (parent-owner:string (UR_Konto parent))
                (kda-payment:decimal
                    (with-capability (DPTF|C>UPGRADE-BRD entity-id)
                        (ref-BRD::XE_UpgradeBranding entity-id parent-owner months)
                    )
                )
            )
            (ref-IGNIS::KDA|C_CollectWT patron kda-payment false)
        )
    )
    ;;
    (defun C_Issue:object{IgnisCollectorV2.OutputCumulator}
        (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-upgrade:[bool] can-change-owner:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (l1:integer (length name))
                (tl:[bool] (make-list l1 false))
                (tf-cost:decimal (ref-DALOS::UR_UsagePrice "dptf"))
                (kda-costs:decimal (* (dec l1) tf-cost))
                (ico:object{IgnisCollectorV2.OutputCumulator}
                    (with-capability (SECURE)
                        (XB_IssueFree account name ticker decimals can-upgrade can-change-owner can-add-special-role can-freeze can-wipe can-pause tl)
                    )
                )
            )
            (ref-IGNIS::KDA|C_Collect patron kda-costs)
            ico
        )
    )
    (defun C_RotateOwnership:object{IgnisCollectorV2.OutputCumulator}
        (id:string new-owner:string)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
            )
            (with-capability (DPTF|S>ROTATE-OWNERSHIP id new-owner)
                (XI_ChangeOwnership id new-owner)
                (ref-IGNIS::UDC_BigCumulator (UR_Konto id))
            )
        )
    )
    (defun C_Control:object{IgnisCollectorV2.OutputCumulator}
        (id:string cu:bool cco:bool casr:bool cf:bool cw:bool cp:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
            )
            (with-capability (DPTF|S>CONTROL id)
                (XI_Control id cu cco casr cf cw cp)
                (ref-IGNIS::UDC_SmallCumulator (UR_Konto id))
            )
        )
    )
    (defun C_TogglePause:object{IgnisCollectorV2.OutputCumulator}
        (id:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
            )
            (with-capability (DPTF|S>TOGGLE_PAUSE id toggle)
                (XI_TogglePause id toggle)
                (ref-IGNIS::UDC_MediumCumulator (UR_Konto id))
            )
        )
    )
    (defun C_ToggleReservation:object{IgnisCollectorV2.OutputCumulator}
        (id:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
            )
            (with-capability (DPTF|S>TOGGLE_RESERVATION id toggle)
                (XI_ToggleReservation id toggle)
                (ref-IGNIS::UDC_MediumCumulator (UR_Konto id))
            )
        )
    )
    ;;
    (defun C_ToggleFee:object{IgnisCollectorV2.OutputCumulator}
        (id:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
            )
            (with-capability (DPTF|S>TOGGLE_FEE id toggle)
                (XI_ToggleFee id toggle)
                (ref-IGNIS::UDC_SmallCumulator (UR_Konto id))
            )
        )
    )
    (defun C_SetMinMove:object{IgnisCollectorV2.OutputCumulator}
        (id:string min-move-value:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
            )
            (with-capability (DPTF|S>SET_MIN-MOVE id min-move-value)
                (XI_SetMinMove id min-move-value)
                (ref-IGNIS::UDC_SmallCumulator (UR_Konto id))
            )
        )
    )
    (defun C_SetFee:object{IgnisCollectorV2.OutputCumulator}
        (id:string fee:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
            )
            (with-capability (DPTF|S>SET_FEE id fee)
                (XI_SetFee id fee)
                (ref-IGNIS::UDC_SmallCumulator (UR_Konto id))
            )
        )
    )
    (defun C_SetFeeTarget:object{IgnisCollectorV2.OutputCumulator}
        (id:string target:string)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
            )
            (with-capability (DPTF|S>SET_FEE-TARGET id target)
                (XI_SetFeeTarget id target)
                (ref-IGNIS::UDC_SmallCumulator (UR_Konto id))
            )
        )
    )
    (defun C_ToggleFeeLock:object{IgnisCollectorV2.OutputCumulator}
        (patron:string id:string toggle:bool)
        (UEV_IMC)
        (with-capability (DPTF|C>TOGGLE_FEE-LOCK id toggle)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DALOS:module{OuronetDalosV5} DALOS)
                    (toggle-costs:[decimal] (XI_ToggleFeeLock id toggle))
                    (g:decimal (at 0 toggle-costs))
                    (gas-costs:decimal (+ (ref-DALOS::UR_UsagePrice "ignis|small") g))
                    (kda-costs:decimal (at 1 toggle-costs))
                    (trigger:bool (ref-IGNIS::URC_IsVirtualGasZero))
                    (output:bool (if (> kda-costs 0.0) true false))
                )
                (if (> kda-costs 0.0)
                    (do
                        (XI_IncrementFeeUnlocks id)
                        (ref-IGNIS::KDA|C_Collect patron kda-costs)
                    )
                    true
                )
                (ref-IGNIS::UDC_ConstructOutputCumulator gas-costs (UR_Konto id) trigger [output])
            )
        )
    )
    ;;
    (defun C_DeployAccount (id:string account:string)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (f:bool false)
                (tk:string (UC_IdAccount id account))
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id)
            (with-default-read DPTF|BalanceTable tk
                (UDC_TrueFungibleAccount 0.0 f f f f f)
                {"balance"                  := b
                ,"frozen"                   := f
                ,"role-burn"                := rb
                ,"role-mint"                := rm
                ,"role-transfer"            := rt
                ,"role-fee-exemption"       := rfe
                }
                (write DPTF|BalanceTable tk
                    (UDC_TrueFungibleAccount b f rb rm rt rfe)
                )
            )
        )
    )
    (defun C_ToggleFreezeAccount:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string toggle:bool)
        @doc "Toggle Verum 1"
        (UEV_IMC)
        (with-capability (DPTF|C>FREEZE id account toggle)
            (let
                (
                    (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (verum-one:[string] (UR_Verum1 id))
                    (updated-verum-one:[string] (ref-U|DALOS::UC_NewRoleList verum-one account toggle))
                )
                ;;Update Verum Roles
                (XI_UpdateVerum1 id updated-verum-one)
                ;;Update Account Roles
                (XI_ToggleFreezeAccount id account toggle)
                ;;Output
                (ref-IGNIS::UDC_BigCumulator (UR_Konto id))
            )
        )
    )
    (defun C_ToggleBurnRole:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string toggle:bool)
        @doc "Toggle Verum 2"
        (with-capability (DPTF|C>TOGGLE-BURN-ROLE id account toggle)
            (let
                (
                    (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (verum-two:[string] (UR_Verum2 id))
                    (updated-verum-two:[string] (ref-U|DALOS::UC_NewRoleList verum-two account toggle))
                )
                ;;Update Verum Roles
                (XI_UpdateVerum2 id updated-verum-two)
                ;;Update Account Roles
                (XI_ToggleBurnRole id account toggle)
                ;;Output
                (ref-IGNIS::UDC_BigCumulator (UR_Konto id))
            )
        )
    )
    (defun C_ToggleMintRole:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string toggle:bool)
        @doc "Toggle Verum 3"
        (with-capability (DPTF|C>TOGGLE-MINT-ROLE id account toggle)
            (let
                (
                    (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (verum-three:[string] (UR_Verum3 id))
                    (updated-verum-three:[string] (ref-U|DALOS::UC_NewRoleList verum-three account toggle))
                )
                ;;Update Verum Roles
                (XI_UpdateVerum3 id updated-verum-three)
                ;;Update Account Roles
                (XI_ToggleMintRole id account toggle)
                ;;Output
                (ref-IGNIS::UDC_BigCumulator (UR_Konto id))
            )
        )
    )
    ;;Toggle Verum 4
    (defun C_ToggleFeeExemptionRole:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string toggle:bool)
        @doc "Toggle Verum 4"
        (with-capability (DPTF|C>TOGGLE-FEE-EXEMPTION-ROLE id account toggle)
            (let
                (
                    (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (verum-four:[string] (UR_Verum4 id))
                    (updated-verum-four:[string] (ref-U|DALOS::UC_NewRoleList verum-four account toggle))
                )
                ;;Update Verum Roles
                (XI_UpdateVerum4 id updated-verum-four)
                ;;Update Account Roles
                (XI_ToggleFeeExemptionRole id account toggle)
                ;;Output
                (ref-IGNIS::UDC_BigCumulator (UR_Konto id))
            )
        )
    )
    ;;Toggle Verum 5
    (defun C_ToggleTransferRole:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string toggle:bool)
        @doc "Toggle Verum 5"
        (UEV_IMC)
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (verum-five:[string] (UR_Verum5 id))
                (updated-verum-five:[string] (ref-U|DALOS::UC_NewRoleList verum-five account toggle))
            )
            (with-capability (DPTF|C>TOGGLE_TRANSFER-ROLE id account toggle)
                ;;Update Verum Roles
                (XI_UpdateVerum5 id updated-verum-five)
                ;;Update Account Roles
                (XI_ToggleTransferRole id account toggle)
                ;;Output
                (ref-IGNIS::UDC_BigCumulator (UR_Konto id))
            )
        )
    )
    ;;
    (defun C_Burn:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
            )
            (with-capability (DPTF|C>BURN id account amount)
                (XB_DebitTrueFungible id account amount (ref-U|DPTF::EmptyDispo) false)
                (XB_UpdateSupply id amount false)
                (ref-IGNIS::UDC_ConstructOutputCumulator 
                    (ref-DALOS::UR_UsagePrice "ignis|small")
                    account 
                    (ref-IGNIS::URC_ZeroGAS id account)
                    []
                )
            )
        )
    )
    (defun C_Mint:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string amount:decimal origin:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (with-capability (DPTF|C>MINT id account amount origin)
                (XB_CreditTrueFungible id account amount)
                (XB_UpdateSupply id amount true)
                (if origin
                    (update DPTF|PropertiesTable id
                        {"origin-mint"          : false
                        ,"origin-mint-amount"   : amount}
                    )
                    true
                )
                (ref-IGNIS::UDC_ConstructOutputCumulator
                    (if origin 
                        (ref-DALOS::UR_UsagePrice "ignis|biggest") 
                        (ref-DALOS::UR_UsagePrice "ignis|small")
                    )
                    account 
                    (ref-IGNIS::URC_ZeroGAS id account) 
                    []
                )
            )
        )
    )
    ;;
    (defun C_WipeSlim:object{IgnisCollectorV2.OutputCumulator}
        (id:string account-to-be-wiped:string amount-to-be-wiped:decimal)
        (UEV_IMC)
        (let
            (
                (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
            )
            (with-capability (DPTF|C>WIPE-SLIM id account-to-be-wiped amount-to-be-wiped)
                (XB_DebitTrueFungible id account-to-be-wiped amount-to-be-wiped (ref-U|DPTF::EmptyDispo) true)
                (XB_UpdateSupply id amount-to-be-wiped false)
                (ref-IGNIS::UDC_BiggestCumulator (UR_Konto id))
            )
        )
    )
    (defun C_Wipe:object{IgnisCollectorV2.OutputCumulator}
        (id:string account-to-be-wiped:string)
        (UEV_IMC)
        (let
            (
                (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (amount-to-be-wiped:decimal (UR_AccountSupply id account-to-be-wiped))
            )
            (with-capability (DPTF|C>WIPE id account-to-be-wiped)
                (XB_DebitTrueFungible id account-to-be-wiped amount-to-be-wiped (ref-U|DPTF::EmptyDispo) true)
                (XB_UpdateSupply id amount-to-be-wiped false)
                (ref-IGNIS::UDC_BiggestCumulator (UR_Konto id))
            )
        )
    )
    ;;{F7}  [X]
    (defun XE_IssueLP:object{IgnisCollectorV2.OutputCumulator}
        (name:string ticker:string)
        @doc "Issues a DPTF Token as a Liquidity Pool Token. A LP DPTF follows specific rules in naming."
        (UEV_IMC)
        (with-capability (SECURE)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV5} DALOS)
                    (swp-sc:string (ref-DALOS::GOV|SWP|SC_NAME))
                )
                (XB_IssueFree swp-sc [name] [ticker] [24] [false] [false] [true] [false] [false] [false] [true])
            )
        )
    )
    (defun XB_IssueFree:object{IgnisCollectorV2.OutputCumulator}
        (
            account:string
            name:[string]
            ticker:[string]
            decimals:[integer]
            ;;
            can-upgrade:[bool]
            can-change-owner:[bool]
            can-add-special-role:[bool]
            ;;
            can-freeze:[bool]
            can-wipe:[bool]
            can-pause:[bool]
            ;;
            iz-special:[bool]
        )
        (UEV_IMC)
        (with-capability (DPTF|C>ISSUE account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-DALOS:module{OuronetDalosV5} DALOS)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-BRD:module{Branding} BRD)
                    (l1:integer (length name))
                    (ignis-issue-cost:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                    (gas-costs:decimal (* (dec l1) ignis-issue-cost))
                    (trigger:bool (ref-IGNIS::URC_IsVirtualGasZero))
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
                (ref-IGNIS::UDC_ConstructOutputCumulator gas-costs account trigger folded-lst)
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
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (id:string (ref-U|DALOS::UDC_Makeid ticker))
            )
            (ref-U|DALOS::UEV_Decimals decimals)
            (ref-U|DALOS::UEV_NameOrTicker name true iz-special)
            (ref-U|DALOS::UEV_NameOrTicker ticker false iz-special)
            (insert DPTF|PropertiesTable id
                {"owner-konto"          : account
                ,"name"                 : name
                ,"ticker"               : ticker
                ,"decimals"             : decimals
                ;;
                ,"can-upgrade"          : can-upgrade
                ,"can-change-owner"     : can-change-owner
                ,"can-add-special-role" : can-add-special-role
                ,"can-freeze"           : can-freeze
                ,"can-wipe"             : can-wipe
                ,"can-pause"            : can-pause
                ;;
                ,"is-paused"            : false
                ;;
                ,"supply"               : 0.0
                ,"origin-mint"          : false
                ,"origin-mint-amount"   : 0.0
                ;;
                ,"fee-toggle"           : false
                ,"min-move"             : -1.0
                ,"fee-promile"          : 0.0
                ,"fee-target"           : OUROBOROS|SC_NAME
                ,"fee-lock"             : false
                ,"fee-unlocks"          : 0
                ,"primary-fee-volume"   : 0.0
                ,"secondary-fee-volume" : 0.0
                ;;
                ,"reward-token"         : [BAR]
                ,"reward-bearing-token" : [BAR]
                ;;
                ,"vesting-link"         : BAR
                ,"sleeping-link"        : BAR
                ,"frozen-link"          : BAR
                ,"reservation-link"     : BAR
                ,"hibernation-link"     : BAR
                ,"reservation"          : false}
            )
            (XI_WriteRoles id
                (UDC_VerumRoles
                    [BAR]
                    [BAR]
                    [BAR]
                    [BAR]
                    [BAR]
                )
            )
            (C_DeployAccount id account)
            id
        )
    )
    (defun XB_DeployAccountWNE (account:string id:string)
        (UEV_IMC)
        (let
            (
                (exist-account:bool (UR_IzAccount id account))
            )
            (if (not exist-account)
                (C_DeployAccount id account)
                true
            )
        )
    )
    ;;PURE Update/Write Functions
    ;;1]DPTF|PropertiesTable
    (defun XI_ChangeOwnership (id:string new-owner:string)
        (require-capability (DPTF|S>ROTATE-OWNERSHIP id new-owner))
        (update DPTF|PropertiesTable id
            {"owner-konto"                      : new-owner}
        )
    )
    (defun XI_Control (id:string can-upgrade:bool can-change-owner:bool can-add-special-role:bool can-freeze:bool can-wipe:bool can-pause:bool)
        (require-capability (DPTF|S>CONTROL id))
        (update DPTF|PropertiesTable id
            {"can-upgrade"                      : can-upgrade
            ,"can-change-owner"                 : can-change-owner
            ,"can-add-special-role"             : can-add-special-role
            ,"can-freeze"                       : can-freeze
            ,"can-wipe"                         : can-wipe
            ,"can-pause"                        : can-pause}
        )
    )
    (defun XI_TogglePause (id:string toggle:bool)
        (require-capability (DPTF|S>TOGGLE_PAUSE id toggle))
        (update DPTF|PropertiesTable id
            { "is-paused" : toggle}
        )
    )
    (defun XB_UpdateSupply (id:string amount:decimal direction:bool)
        (UEV_IMC)
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
    ;;
    (defun XI_ToggleFee(id:string toggle:bool)
        (require-capability (DPTF|S>TOGGLE_FEE id toggle))
        (update DPTF|PropertiesTable id
            { "fee-toggle" : toggle}
        )
    )
    (defun XI_SetMinMove (id:string min-move-value:decimal)
        (require-capability (DPTF|S>SET_MIN-MOVE id min-move-value))
        (update DPTF|PropertiesTable id
            { "min-move" : min-move-value}
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
    (defun XE_UpdateFeeVolume (id:string amount:decimal primary:bool)
        (UEV_IMC)
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
    ;;
    (defun XE_UpdateRewardToken (atspair:string id:string direction:bool)
        (UEV_IMC)
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
    (defun XE_UpdateRewardBearingToken (atspair:string id:string)
        (UEV_IMC)
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
    ;;
    (defun XE_UpdateVesting (dptf:string dpof:string)
        (UEV_IMC)
        (update DPTF|PropertiesTable dptf
            {"vesting-link" : dpof}
        )
    )
    (defun XE_UpdateSleeping (dptf:string dpof:string)
        (UEV_IMC)
        (update DPTF|PropertiesTable dptf
            {"sleeping-link" : dpof}
        )
    )
    (defun XE_UpdateHibernation (dptf:string dpof:string)
        (UEV_IMC)
        (update DPTF|PropertiesTable dptf
            {"hibernation-link" : dpof}
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
    (defun XI_ToggleReservation (id:string toggle:bool)
        (require-capability (DPTF|S>TOGGLE_RESERVATION id toggle))
        (update DPTF|PropertiesTable id
            { "reservation" : toggle}
        )
    )
    (defun XE_UpdateSpecialTrueFungible:object{IgnisCollectorV2.OutputCumulator}
        (main-dptf:string secondary-dptf:string fr-tag:integer)
        (UEV_IMC)
        (with-capability (DPTF|C>UPDATE-SPECIAL main-dptf secondary-dptf fr-tag)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                )
                (cond
                    ((= fr-tag 1)
                        (do
                            (XI_UpdateFrozen main-dptf secondary-dptf)
                            (XI_UpdateFrozen secondary-dptf main-dptf)
                        )
                    )
                    ((= fr-tag 2)
                        (do
                            (XI_UpdateReserved main-dptf secondary-dptf)
                            (XI_UpdateReserved secondary-dptf main-dptf)
                        )
                    )
                    true
                )
                (ref-IGNIS::UDC_BiggestCumulator (UR_Konto main-dptf))
            )
        )
    )
    ;;2]DPTF|RoleTable
    (defun XI_WriteRoles (id:string verum-roles:object{DPTF|RoleSchema})
        (require-capability (SECURE))
        (write DPTF|RoleTable id verum-roles)
    )
    (defun XI_UpdateVerum1 (id:string new-verum1:[string])
        (require-capability (SECURE))  
        (update DPTF|RoleTable id
            {"a-frozen" : new-verum1}
        )
    )
    (defun XI_UpdateVerum2 (id:string new-verum2:[string])
        (require-capability (SECURE))  
        (update DPTF|RoleTable id
            {"r-burn" : new-verum2}
        )
    )
    (defun XI_UpdateVerum3 (id:string new-verum3:[string])
        (require-capability (SECURE))  
        (update DPTF|RoleTable id
            {"r-mint" : new-verum3}
        )
    )
    (defun XI_UpdateVerum4 (id:string new-verum4:[string])
        (require-capability (SECURE))  
        (update DPTF|RoleTable id
            {"r-fee-exemption" : new-verum4}
        )
    )
    (defun XI_UpdateVerum5 (id:string new-verum5:[string])
        (require-capability (SECURE))  
        (update DPTF|RoleTable id
            {"r-transfer" : new-verum5}
        )
    )
    ;;3]DPTF|BalanceTable
    (defun XI_ToggleFreezeAccount (id:string account:string toggle:bool)
        @doc "Toggle Verum 1"
        (require-capability (DPTF|C>X_FREEZE id account toggle))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (ref-DALOS::XE_UpdateFreeze account (= id (ref-DALOS::UR_OuroborosID)) toggle)
                (update DPTF|BalanceTable (UC_IdAccount id account)
                    { "frozen" : toggle}
                )
            )
        )
    )
    (defun XI_ToggleBurnRole (id:string account:string toggle:bool)
        @doc "Toggle Verum 2"
        (require-capability (DPTF|C>X_TOGGLE-BURN-ROLE id account toggle))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (ref-DALOS::XE_UpdateBurnRole account (= id (ref-DALOS::UR_OuroborosID)) toggle)
                (update DPTF|BalanceTable (UC_IdAccount id account)
                    {"role-burn" : toggle}
                )
            )
        )
    )
    (defun XI_ToggleMintRole (id:string account:string toggle:bool)
        @doc "Toggle Verum 3"
        (require-capability (DPTF|C>X_TOGGLE-MINT-ROLE id account toggle))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (ref-DALOS::XE_UpdateMintRole account (= id (ref-DALOS::UR_OuroborosID)) toggle)
                (update DPTF|BalanceTable (UC_IdAccount id account)
                    {"role-mint" : toggle}
                )
            )
        )
    )
    (defun XI_ToggleFeeExemptionRole (id:string account:string toggle:bool)
        @doc "Toggle Verum 4"
        (require-capability (DPTF|C>X_TOGGLE-FEE-EXEMPTION-ROLE id account toggle))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (ref-DALOS::XE_UpdateFeeExemptionRole account (= id (ref-DALOS::UR_OuroborosID)) toggle)
                (update DPTF|BalanceTable (UC_IdAccount id account)
                    {"role-fee-exemption" : toggle}
                )
            )
        )
    )
    (defun XI_ToggleTransferRole (id:string account:string toggle:bool)
        @doc "Toggle Verum 5"                
        (require-capability (DPTF|C>X_TOGGLE-TRANSFER-ROLE id account toggle))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                (ref-DALOS::XE_UpdateTransferRole account (= id (ref-DALOS::UR_OuroborosID)) toggle)
                (update DPTF|BalanceTable (UC_IdAccount id account)
                    {"role-transfer" : toggle}
                )
            )
        )
    )
    ;;
    ;;
    (defun XB_DebitTrueFungible (id:string account:string amount:decimal dispo-data:object{UtilityDptf.DispoData} wipe-mode:bool)
        @doc "Debit DPTF <id> on <account> with <amount> \
            \ Ouronet Account <account> must exist \
            \ Assumes DPTF Account with key <(UC_IdAccount id account)> exists\
            \ Only Performs Debitation, does not update supply"
        (UEV_IMC)
        (with-capability (DPTF|C>DEBIT account id amount dispo-data wipe-mode)
            (let
                (
                    (current-supply:decimal (UR_AccountSupply id account))
                )
                (XI_UpdateBalance id account (- current-supply amount))
            )
        )
    )
    (defun XB_CreditTrueFungible (id:string account:string amount:decimal)
        @doc "Debit DPTF <id> on <account> with <amount> \
            \ Ouronet Account <account> must exist \
            \ DPTF Account with key <(UC_IdAccount id account)> may exist or not\
            \ Only Performs Creditation, does not update supply"
        (UEV_IMC)
        (with-capability (DPTF|C>CREDIT account id amount)
            (XB_DeployAccountWNE account id)
            (let
                (
                    (current-supply:decimal (UR_AccountSupply id account))
                )
                (XI_UpdateBalance id account (+ current-supply amount))
            )
        )
    )
    (defun XI_UpdateBalance (id:string account:string new-balance:decimal)
        (require-capability (SECURE))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (if (URC_IzCoreDPTF id)
                ;;Updates for Core Tokens
                (ref-DALOS::XB_UpdateBalance account (= id (ref-DALOS::UR_OuroborosID)) new-balance)
                ;;Updates for Non Core Tokens
                (XII_UpdateBalance id account new-balance)
            )
        )
    )
    (defun XII_UpdateBalance (id:string account:string new-balance:decimal)
        (require-capability (SECURE))
        (let
            (
                (tk:string (UC_IdAccount id account))
                (data-obj:object (read DPTF|BalanceTable tk))
                (has-removable:bool (contains "exist" data-obj))
                (new-balance-obj:object
                    (+
                        {"balance" : new-balance}
                        (remove "balance" data-obj)
                    )
                )
            )
            (write DPTF|BalanceTable tk
                (if has-removable
                    (remove "exist" new-balance-obj)
                    new-balance-obj
                )
            )
        )
    )
    ;;
    
)

;(create-table P|T)
;(create-table P|MT)
;(create-table DPTF|PropertiesTable)
;(create-table DPTF|BalanceTable)
;(create-table DPTF|RoleTable)