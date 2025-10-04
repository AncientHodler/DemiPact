
(module DPOF GOV
    ;;
    (implements OuronetPolicy)
    (implements BrandingUsageV9)
    (implements DemiourgosPactOrtoFungibleV2)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPOF                   (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPOF_ADMIN)))
    (defcap GOV|DPOF_ADMIN ()               (enforce-guard GOV|MD_DPOF))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;; [Keys]
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|CollectiblesKey ()           (+ (GOV|NS_Use) ".dh_sc_dpdc-keyset"))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|DPOF|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPOF|CALLER))
        (compose-capability (SECURE))
    )
    (defcap SECURE-ADMIN ()
        (compose-capability (SECURE))
        (compose-capability (GOV|DPOF_ADMIN))
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
        (with-capability (GOV|DPOF_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPOF_ADMIN)
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
                (mg:guard (create-capability-guard (P|DPOF|CALLER)))
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
    (defschema TransmitData
        input-nonces:[integer]
        input-amounts:[decimal]
        output-nonces:[integer]
        meta-data-array:[[object]]
    )
    ;;{2}
    (deftable DPOF|T|Properties:{DpofUdc.DPOF|Properties})      ;;Key = <DPOF-id>      
    (deftable DPOF|T|Nonces:{DpofUdc.DPOF|NonceElement})        ;;Key = <DSOF-id> + BAR + <nonce>
    (deftable DPOF|T|VerumRoles:{DpofUdc.DPOF|VerumRoles})      ;;Key = <DPOF-id>
    (deftable DPOF|T|AccountRoles:{DpofUdc.DPOF|AccountRoles})  ;;Key = <DPOF-id> + BAR + <account> 
    ;;{3}
    (defun CT_Bar ()        (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR           (CT_Bar))
    (defconst OF            (at 0 ["Orto-Fungible"]))
    (defconst ATS|SC_NAME   (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|ATS|SC_NAME)))
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    (defcap DPOF|S>ROTATE-OWNERSHIP (id:string new-owner:string)
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
    (defcap DPOF|S>CONTROL (id:string)
        @event
        (CAP_Owner id )
        (UEV_CanUpgradeON id)
    )
    (defcap DPOF|S>CREDIT-SINGULAR (account:string id:string nonce:integer amount:decimal)
        ;;Nonce must be held by Account (also indirectly validates that account exists)
        (UEV_NoncesToAccount id account [nonce])
        ;;Amount must be validated
        (UEV_Amount id amount)
        ;;Nonce must be in circulation
        (UEV_NoncesCirculating id [nonce])
    )
    (defcap DPOF|S>CREDIT-CONSECUTIVE (account:string id:string nonces:[integer] amounts:[decimal])
        (map
            (lambda
                (idx:integer)
                (let
                    (
                        (amount:decimal (at idx amounts))
                    )
                    (UEV_Amount id amount)
                )
            )
            (enumerate 0 (- (length nonces) 1))
        )
    )
    ;;
    (defcap DPOF|S>PAUSE (id:string pause:bool)
        @doc "Pause and Unpause a DPOF <id>"
        @event
        (CAP_Owner id)
        (UEV_PauseState id (not pause))
        (if pause
            (UEV_CanPauseON id)
            true
        )
    )
    (defcap DPOF|S>X_FREEZE (id:string account:string frozen:bool)
        @doc "Toggle Verum 1"
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
        )
    )
    (defcap DPOF|S>X_TOGGLE-ADD-QUANTITY-ROLE (id:string account:string toggle:bool)
        @doc "Toggle Verum 2"
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::UEV_NotSmartOuronetAccount account)
            (CAP_Owner id)
            (UEV_AccountAddQuantityState id account (not toggle))
            (if toggle
                (UEV_CanAddSpecialRoleON id)
                true
            )
        )
    )
    (defcap DPOF|S>X_TOGGLE-BURN-ROLE (id:string account:string toggle:bool)
        @doc "Toggle Verum 4"
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
        )
    )
    (defcap DPOF|S>X_SWITCH-CREATE-ROLE (id:string receiver:string)
        @doc "Switch Verum 4"
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (current:string (UR_Verum4 id))
            )
            (ref-DALOS::UEV_NotSmartOuronetAccount receiver)
            (ref-DALOS::UEV_SenderWithReceiver current receiver)
            (CAP_Owner id)
            (UEV_CanTransferOftCreateRoleON id)
        )
    )
    (defcap DPOF|S>X_TOGGLE-TRANSFER-ROLE (id:string account:string toggle:bool)
        @doc "Toggle Verum 5"
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (special:[string] ["V|" "Z|"])
                (ft:string (take 2 id))
                (iz-special:bool (contains ft special))
            )
            ;;Vested and Sleeping Special Tokens can use Core Smart Ouronet Accounts for Transfer Roles Setup.
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
        )
    )
    (defcap DPOF|S>MOVE (id:string sender:string receiver:string method:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            ;;1]Ownership
            (if (and method (ref-DALOS::UR_AccountType receiver))
                (ref-DALOS::CAP_EnforceAccountOwnership receiver)
                true
            )
            ;;2]Transferability
            (ref-DALOS::UEV_EnforceTransferability sender receiver method)
            ;;3]<id> Pause State and <sender> <receiver> Frozen State
            (UEV_PauseState id false)
            (UEV_AccountFreezeState id sender false)
            (UEV_AccountFreezeState id receiver false)
            ;;4]Transfer Roles Check
            (UEV_MoveRoleCheck id sender receiver)
        )
    )
    ;;{C3}
    ;;{C4}
    (defcap DPOF|C>UPDATE-BRD (dpof:string)
        @event
        (UEV_ParentOwnership dpof)
        (compose-capability (P|DPOF|CALLER))
    )
    (defcap DPOF|C>UPGRADE-BRD (dpof:string)
        @event
        (UEV_ParentOwnership dpof)
        (compose-capability (P|DPOF|CALLER))
    )
    ;;
    (defcap DPOF|C>ISSUE 
        (
            account:string name:[string] ticker:[string] decimals:[integer]
            can-upgrade:[bool] can-change-owner:[bool] can-add-special-role:[bool] can-transfer-oft-create-role:[bool]
            can-freeze:[bool] can-wipe:[bool] can-pause:[bool]
        )
        @event
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-U|INT::UEV_UniformList 
                [
                    (length name)
                    (length ticker)
                    (length decimals)
                    (length can-upgrade)
                    (length can-change-owner)
                    (length can-add-special-role)
                    (length can-transfer-oft-create-role)
                    (length can-freeze)
                    (length can-wipe)
                    (length can-pause)
                ]
            )
            (ref-U|LST::UC_IzUnique name)
            (ref-U|LST::UC_IzUnique ticker)
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (compose-capability (P|SECURE-CALLER))
        )
    )
    ;;
    (defcap DPOF|C>ADD-QTY (client:string id:string nonce:integer amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership client)
            (UEV_AccountAddQuantityState id client true)
            (compose-capability (DPOF|C>CREDIT client id [nonce] [amount] [[{}]]))
        )
    )
    (defcap DPOF|C>BURN (client:string id:string nonce:integer amount:decimal)
        @event
        (let
            (
                (nonce-supply:decimal (UR_NonceSupply id nonce))
            )
            (UEV_AccountBurnState id client true)
            (if (< amount nonce-supply)
                (UEV_SegmentationState id true)
                true
            )
            (compose-capability (DPOF|C>DEBIT client id [nonce] [amount] false))
        )
    )
    (defcap DPOF|C>MINT (client:string id:string amount:decimal meta-data-chain:[object])
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (nonces-used:integer (UR_NoncesUsed id))
                (owner:string (UR_Konto id))
            )
            (ref-DALOS::CAP_EnforceAccountOwnership client)
            (UEV_AccountAddQuantityState id client true)
            (if (and (= owner ATS|SC_NAME) (!= client owner))
                (enforce false "Only the ATS owner can mint when the owner is ATS")
                (UEV_AccountCreateState id client true)
            )
            (compose-capability (DPOF|C>CREDIT client id [(+ nonces-used 1)] [amount] [meta-data-chain]))
        )
    )
    (defcap DPOF|C>WIPE-SLIM (account:string id:string nonce:integer amount:decimal)
        @event
        (UEV_SegmentationState id true)
        (compose-capability (DPOF|C>X_WIPE account id [nonce] [amount]))
    )
    (defcap DPOF|C>WIPE (account:string id:string nonces:[integer])
        @event
        (compose-capability (DPOF|C>X_WIPE account id nonces (UR_NoncesSupplies id nonces)))
    )
    (defcap DPOF|C>X_WIPE (account:string id:string nonces:[integer] amounts:[decimal])
        ;;Nonces must be held by <account>
        (UEV_NoncesToAccount id account nonces)
        ;;Orto-Fungible is frozen on target account
        (UEV_AccountFreezeState id account true)
        ;;Orto-Fungible has <can-wipe> on
        (UEV_CanWipeON id)
        ;;Neeeded Capabilities
        (compose-capability (DPOF|C>DEBIT account id nonces amounts true))
    )
    ;;
    (defcap DPOF|C>DEBIT (account:string id:string nonces:[integer] amounts:[decimal] wipe-mode:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (l1:integer (length nonces))
                (l2:integer (length amounts))    
            )
            (enforce (= l1 l2) "Invalid Inputs for Debitation")
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (nonce:integer (at idx nonces))
                            (amount:decimal (at idx amounts))
                            (nonce-supply:decimal (UR_NonceSupply id nonce))
                        )
                        (enforce
                            ;;Cannot Debit into the negatives
                            (<= amount nonce-supply)
                            (format "Cannot Debit into the Negatives for {} {} Nonce {} on Account {}" [OF id nonce account])
                        )
                        (UEV_Amount id amount)
                        ;;<UEV_CirculatingNonce> is indirectly verified via the <enforce> above and <UEV_Amount> 
                        ;;(since non circulating nonce have supply -1.0 and amount must be greater than 0 and smaller than <nonce-supply>)
                    )
                    
                )
                (enumerate 0 (- l1 1))
            )
            ;;Enforces <account> ownership needed for Debitation
            (if wipe-mode
                (CAP_Owner id)
                (ref-DALOS::CAP_EnforceAccountOwnership account)
            )
            ;;Checks all <nonces> are owned by Account
            (UEV_NoncesToAccount id account nonces)
            ;:For XI Functions
            (compose-capability (SECURE))
        )
    )
    (defcap DPOF|C>CREDIT (account:string id:string nonces:[integer] amounts:[decimal] meta-data-array:[[object]])
        (let
            (
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (iz-singular:bool (UC_IzSingular id nonces))
                (iz-consecutive:bool (UC_IzConsecutive id nonces))
                (l1:integer (length nonces))
                (l2:integer (length amounts))
                (l3:integer (length meta-data-array))
            )
            (ref-U|INT::UEV_UniformList [l1 l2 l3])
            (enforce-one
                "Invalid Nonce Chain for Creditation"
                [
                    (enforce iz-singular "Nonce Chain is not Singular")
                    (enforce iz-consecutive "Nonce Chain is not Consecutive")
                ]
            )
            (if iz-singular
                (do
                    (enforce (not iz-consecutive) "Nonce Chain must compute false for Consecutive")
                    (compose-capability (DPOF|S>CREDIT-SINGULAR account id (at 0 nonces) (at 0 amounts)))
                )
                true
            )
            (if iz-consecutive
                (do
                    (enforce (not iz-singular) "Nonce Chain must compute false for Singular")
                    (compose-capability (DPOF|S>CREDIT-CONSECUTIVE account id nonces amounts))
                )
                true
            )
            (compose-capability (SECURE))
        )
    )
    ;;
    (defcap DPOF|C>FREEZE (id:string account:string frozen:bool)
        @doc "Toggle Verum 1"
        @event
        (compose-capability (DPOF|S>X_FREEZE id account frozen))
        (compose-capability (SECURE))
    )
    (defcap DPOF|C>TOGGLE-ADD-QUANTITY-ROLE (id:string account:string toggle:bool)
        @doc "Toggle Verum 2"
        @event
        (compose-capability (DPOF|S>X_TOGGLE-ADD-QUANTITY-ROLE id account toggle))
        (compose-capability (SECURE))
    )
    (defcap DPOF|C>TOGGLE-BURN-ROLE (id:string account:string toggle:bool)
        @doc "Toggle Verum 3"
        @event
        (compose-capability (DPOF|S>X_TOGGLE-BURN-ROLE id account toggle))
        (compose-capability (SECURE))
    )
    (defcap DPOF|C>SWITCH-CREATE-ROLE (id:string receiver:string)
        @doc "Switch Verum 4"
        @event
        (compose-capability (DPOF|S>X_SWITCH-CREATE-ROLE id receiver))
        (compose-capability (SECURE))
    )

    (defcap DPOF|C>TOGGLE-TRANSFER-ROLE (id:string account:string toggle:bool)
        @doc "Toggle Verum 5"
        @event
        (compose-capability (DPOF|S>X_TOGGLE-TRANSFER-ROLE id account toggle))
        (compose-capability (SECURE))
    )
    ;;
    (defcap DPOF|C>TRANSMIT (id:string td:object{TransmitData} sender:string receiver:string method:bool)
        @event
        (let
            (   
                (input-nonces:[integer] (at "input-nonces" td))
                (input-amounts:[decimal] (at "input-amounts" td))
                (output-nonces:[integer] (at "output-nonces" td))
                (meta-data-array:[[object]] (at "meta-data" td))
            )
            (UEV_SegmentationState id true)
            (compose-capability (DPOF|C>DEBIT sender id input-nonces input-amounts false))
            (compose-capability (DPOF|C>CREDIT receiver id output-nonces input-amounts meta-data-array))
            (compose-capability (DPOF|S>MOVE id sender receiver method))
        )
    )
    (defcap DPOF|C>TRANSFER (id:string nonces:[integer] sender:string receiver:string method:bool)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership sender)
            (UEV_NoncesToAccount id sender nonces)
            (UEV_NoncesCirculating id nonces)
            (compose-capability (DPOF|S>MOVE id sender receiver method))
            (compose-capability (SECURE))
        )
    )
    (defcap DPOF|C>UPDATE-SPECIAL (main-dptf:string secondary-dpof:string vzh-tag:integer)
        (enforce (contains vzh-tag [1 2 3]) "Invalid Vesting|Sleeping|Hibernation Tag")
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (main-special-id:string
                    (cond
                        ((= vzh-tag 1) (ref-DPTF::UR_Vesting main-dptf))
                        ((= vzh-tag 2) (ref-DPTF::UR_Sleeping main-dptf))
                        ((= vzh-tag 2) (ref-DPTF::UR_Hibernation main-dptf))
                        BAR
                    )
                )
                (secondary-special-id:string
                    (cond
                        ((= vzh-tag 1) (UR_Vesting secondary-dpof))
                        ((= vzh-tag 2) (UR_Sleeping secondary-dpof))
                        ((= vzh-tag 3) (UR_Hibernation secondary-dpof))
                        BAR
                    )
                )
                (iz-secondary-rbt:bool (URC_IzRBT secondary-dpof))
                (main-dptf-ftc:string (take 2 main-dptf))
            )
            (ref-DPTF::CAP_Owner main-dptf)
            (CAP_Owner secondary-dpof)
            (enforce
                (and (= main-special-id BAR) (= secondary-special-id BAR) )
                "Special Orto Fungible Links (Vesting, Sleeping or Hibernation) are immutable !"
            )
            (enforce
                (not iz-secondary-rbt)
                "Special Orto Fungible cannot be a Hot-RBT"
            )
            (cond
                ((= vzh-tag 1)
                    (enforce
                        (not (contains main-dptf-ftc ["R|" "F|" "S|" "W|" "P|"]))
                        (format "When setting a Vesting Link, the main DPTF {} cannot be a Special or LP Token" [main-dptf])
                    )
                )
                ((= vzh-tag 2)
                    (enforce
                        (not (contains main-dptf-ftc ["R|" "F|"]))
                        (format "When setting a Sleeping Link, the main DPTF {} cannot be a Special Token" [main-dptf])
                        ;;But can be an LP Token
                    )
                )
                ((= vzh-tag 3)
                    (enforce
                        (not (contains main-dptf-ftc ["R|" "F|" "S|" "W|" "P|"]))
                        (format "When setting a Hibernation Link, the main DPTF {} cannot be a Special or LP Token" [main-dptf])
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
    (defun UC_IdNonce:string (id:string nonce:integer)
        (format "{}{}{}" [id BAR nonce])
    )
    (defun UC_IdAccount:string (id:string account:string)
        (format "{}{}{}" [id BAR account])
    )
    (defun UC_IzSingular:bool (id:string nonces:[integer])
        @doc "Checks if the <[nonces]> is singular; \
        \ Singular <[nonces]> means length is 1, and the nonce exists"
        (let
            (
                (l:integer (length nonces))
                (first-nonce:integer (at 0 nonces))
                (iz-nonce:bool (UR_IzNonce id first-nonce))
            )
            (if (and (= l 1) iz-nonce)
                true
                false
            )
        )
    )
    (defun UC_IzConsecutive:bool (id:string nonces:[integer])
        @doc "Checks if <[nonces]> are consecutive; \
        \ Consecutive means they need to be consecutive, dont exist yet, \
        \ and start imediatly after tha last used nonce"
        (let
            (
                (l:integer (length nonces))
                (nonces-used:integer (UR_NoncesUsed id))
                (last-nonce:integer (at 0 (take -1 nonces)))
                (enumerated:[integer] (enumerate (+ nonces-used 1) last-nonce))
            )
            (if 
                (fold (and) true
                    [
                        (= (+ nonces-used l) last-nonce)
                        (= enumerated nonces)
                        (>= l 1)
                    ]
                )
                true
                false
            )
        )
    )
    (defun UC_TakePureWipe:object{DpofUdc.RemovableNonces} 
        (input:object{DpofUdc.RemovableNonces} size:integer)
        @doc "Takes <size> and returns a smaller |object{DpofUdc.RemovableNonces}|"
        (let
            (
                (nonces:[integer] (at "r-nonces" input))
                (amounts:[decimal] (at "r-amounts" input))
                (l:integer (length nonces))
            )
            (enforce (< size l) (format "Size of {} is larger than the Data set of the Removable Nonces Object" [size]))
            (UDC_RemovableNonces
                (take size nonces)
                (take size amounts)
            )
        )
    )
    (defun UC_MoveCumulator:object{IgnisCollectorV2.OutputCumulator}
        (id:string nonces:[integer] transmit-or-transfer:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (UCX_NoncesCumulator 
                id 
                (length nonces)
                (if transmit-or-transfer
                    (ref-DALOS::UR_UsagePrice "ignis|small")
                    (ref-DALOS::UR_UsagePrice "ignis|smallest")
                )
                {}
            )
        )
    )
    (defun UC_WipeCumulator:object{IgnisCollectorV2.OutputCumulator}
        (id:string removable-nonces-obj:object{DpofUdc.RemovableNonces})
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (UCX_NoncesCumulator 
                id 
                (length (at "r-nonces" removable-nonces-obj))
                (ref-DALOS::UR_UsagePrice "ignis|small")
                removable-nonces-obj
            )
        )
    )
    (defun UCX_NoncesCumulator:object{IgnisCollectorV2.OutputCumulator}
        (id:string number-of-nonces:integer price-per-nonce:decimal output-obj:object)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
            )
            (ref-IGNIS::UDC_ConstructOutputCumulator
                (*  
                    (dec number-of-nonces)
                    price-per-nonce
                )
                (UR_Konto id)
                (ref-IGNIS::URC_IsVirtualGasZero)
                [output-obj]
            )
        )
    )
    ;;{F0}  [UR]
    (defun UR_P-KEYS:[string] ()
        (keys DPOF|T|Properties)
    )
    (defun UR_N-KEYS:[string] ()
        (keys DPOF|T|Nonces)
    )
    (defun UR_V-KEYS:[string] ()
        (keys DPOF|T|VerumRoles)
    )
    (defun UR_KEYS:[string] ()
        (keys DPOF|T|AccountRoles)
    )
    ;;
    ;;
    (defun UR_Konto:string (id:string)
        (at "owner-konto" (read DPOF|T|Properties id ["owner-konto"]))
    )
    (defun UR_Name:string (id:string)
        (at "name" (read DPOF|T|Properties id ["name"]))
    )
    (defun UR_Ticker:string (id:string)
        (at "ticker" (read DPOF|T|Properties id ["ticker"]))
    )
    (defun UR_Decimals:integer (id:string)
        (at "decimals" (read DPOF|T|Properties id ["decimals"]))
    )
    ;;
    (defun UR_CanUpgrade:bool (id:string)
        (at "can-upgrade" (read DPOF|T|Properties id ["can-upgrade"]))
    )
    (defun UR_CanChangeOwner:bool (id:string)
        (at "can-change-owner" (read DPOF|T|Properties id ["can-change-owner"]))
    )
    (defun UR_CanAddSpecialRole:bool (id:string)
        (at "can-add-special-role" (read DPOF|T|Properties id ["can-add-special-role"]))
    )
    (defun UR_CanTransferOftCreateRole:bool (id:string)
        (at "can-transfer-oft-create-role" (read DPOF|T|Properties id ["can-transfer-oft-create-role"]))
    )
    (defun UR_CanFreeze:bool (id:string)
        (at "can-freeze" (read DPOF|T|Properties id ["can-freeze"]))
    )
    (defun UR_CanWipe:bool (id:string)
        (at "can-wipe" (read DPOF|T|Properties id ["can-wipe"]))
    )
    (defun UR_CanPause:bool (id:string)
        (at "can-pause" (read DPOF|T|Properties id ["can-pause"]))
    )
    (defun UR_Segmentation:bool (id:string)
        (at "segmentation" (read DPOF|T|Properties id ["segmentation"]))
    )
    ;;
    (defun UR_IsPaused:bool (id:string)
        (at "is-paused" (read DPOF|T|Properties id ["is-paused"]))
    )
    (defun UR_NoncesUsed:integer (id:string)
        (at "nonces-used" (read DPOF|T|Properties id ["nonces-used"]))
    )
    (defun UR_NoncesExcluded:integer (id:string)
        (at "nonces-excluded" (read DPOF|T|Properties id ["nonces-excluded"]))
    )
    ;;
    (defun UR_Supply:decimal (id:string)
        (at "supply" (read DPOF|T|Properties id ["supply"]))
    )
    ;;
    (defun UR_RewardBearingToken:string (id:string)
        (at "reward-bearing-token" (read DPOF|T|Properties id ["reward-bearing-token"]))
    )
    (defun UR_Vesting:string (id:string)
        (at "vesting-link" (read DPOF|T|Properties id ["vesting-link"]))
    )
    (defun UR_Sleeping:string (id:string)
        (at "sleeping-link" (read DPOF|T|Properties id ["sleeping-link"]))
    )
    (defun UR_Hibernation:string (id:string)
        (at "hibernation-link" (read DPOF|T|Properties id ["hibernation-link"]))
    )
    ;;
    (defun UR_IzId:bool (id:string)
        (let
            (
                (trial (try false (read DPOF|T|Properties id))) 
            )
            (if (= (typeof trial) "bool") false true)
        )
    )
    ;;
    ;;
    (defun UR_NonceHolder:string (id:string nonce:integer)
        (at "holder" (read DPOF|T|Nonces (UC_IdNonce id nonce) ["holder"]))
    )
    (defun UR_NonceID:string (id:string nonce:integer)
        (at "id" (read DPOF|T|Nonces (UC_IdNonce id nonce) ["id"]))
    )
    (defun UR_NonceValue:integer (id:string nonce:integer)
        (at "value" (read DPOF|T|Nonces (UC_IdNonce id nonce) ["value"]))
    )
    (defun UR_NonceSupply:decimal (id:string nonce:integer)
        (at "supply" (read DPOF|T|Nonces (UC_IdNonce id nonce) ["supply"]))
    )
    (defun UR_NonceMetaData:[object] (id:string nonce:integer)
        (at "meta-data-chain" (read DPOF|T|Nonces (UC_IdNonce id nonce) ["meta-data-chain"]))
    )
    (defun UR_NoncesSupplies:[decimal] (id:string nonces:[integer])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[decimal] element:integer)
                    (ref-U|LST::UC_AppL acc (UR_NonceSupply id element))
                )
                []
                nonces
            )
        )
    )
    (defun UR_NoncesMetaDatas:[[object]] (id:string nonces:[integer])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[[object]] element:integer)
                    (ref-U|LST::UC_AppL acc (UR_NonceMetaData id element))
                )
                []
                nonces
            )
        )
    )
    (defun UR_IzNonce:bool (id:string nonce:integer)
        (let
            (
                (trial (try false (read DPOF|T|Nonces (UC_IdNonce id nonce))))
            )
            (if (= (typeof trial) "bool") false true)
        )
    )
    ;;
    ;;
    (defun UR_Verum1:[string] (id:string)
        (at "a-frozen" (read DPOF|T|VerumRoles id ["a-frozen"]))
    )
    (defun UR_Verum2:[string] (id:string)
        (at "r-oft-add-quantity" (read DPOF|T|VerumRoles id ["r-oft-add-quantity"]))
    )
    (defun UR_Verum3:[string] (id:string)
        (at "r-oft-burn" (read DPOF|T|VerumRoles id ["r-oft-burn"]))
    )
    (defun UR_Verum4:string (id:string)
        (at "r-oft-create" (read DPOF|T|VerumRoles id ["r-oft-create"]))
    )
    (defun UR_Verum5:[string] (id:string)
        (at "r-transfer" (read DPOF|T|VerumRoles id ["r-transfer"]))
    )
    ;;
    ;;
    (defun UR_R-Frozen:bool (id:string account:string)
        ;;(at "frozen" (read DPOF|T|AccountRoles (UC_IdAccount id account) ["frozen"]))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (and
                (with-default-read DPOF|T|AccountRoles (UC_IdAccount id account)
                    { "frozen" : false}
                    { "frozen" := fr }
                    fr
                )
                (not (ref-DALOS::UR_AutonomicRoles account))
            )
        )
    )
    (defun UR_R-AddQuantity:bool (id:string account:string)
        ;;(at "role-oft-add-quantity" (read DPOF|T|AccountRoles (UC_IdAccount id account) ["role-oft-add-quantity"]))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (or
                (with-default-read DPOF|T|AccountRoles (UC_IdAccount id account)
                    { "role-oft-add-quantity" : false}
                    { "role-oft-add-quantity" := roaq }
                    roaq
                )
                (ref-DALOS::UR_AutonomicRoles account)
            )
        )
    )
    (defun UR_R-Burn:bool (id:string account:string)
        ;;(at "role-oft-burn" (read DPOF|T|AccountRoles (UC_IdAccount id account) ["role-oft-burn"]))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (or
                (with-default-read DPOF|T|AccountRoles (UC_IdAccount id account)
                    { "role-oft-burn" : false}
                    { "role-oft-burn" := rob }
                    rob
                )
                (ref-DALOS::UR_AutonomicRoles account)
            )
        )
    )
    (defun UR_R-Create:bool (id:string account:string)
        ;;(at "role-oft-create" (read DPOF|T|AccountRoles (UC_IdAccount id account) ["role-oft-create"]))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (owner:string (UR_Konto id))
            )
            (fold (or) false
                [
                    (with-default-read DPOF|T|AccountRoles (UC_IdAccount id account)
                        { "role-oft-create" : false}
                        { "role-oft-create" := roc }
                        roc
                    )
                    (= account owner)
                    (ref-DALOS::UR_AutonomicRoles account)
                ]
            )
        )
    )
    (defun UR_R-Transfer:bool (id:string account:string)
        ;;(at "role-transfer" (read DPOF|T|AccountRoles (UC_IdAccount id account) ["role-transfer"]))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (or
                (with-default-read DPOF|T|AccountRoles (UC_IdAccount id account)
                    { "role-transfer" : false}
                    { "role-transfer" := rt }
                    rt
                )
                (ref-DALOS::UR_AutonomicRoles account)
            )
        )
    )
    ;;
    (defun UR_AccountSupply:decimal (id:string account:string)
        (with-default-read DPOF|T|AccountRoles (UC_IdAccount id account)
            { "total-account-supply" : 0.0 }
            { "total-account-supply" := tas}
            tas
        )
    )
    (defun UR_IzAccount:bool (id:string account:string)
        (let
            (
                (trial (try false (read DPOF|T|AccountRoles (UC_IdAccount id account))))
            )
            (if (= (typeof trial) "bool") false true)
        )
    )
    ;;
    ;;
    (defun URD_AccountNonces:[integer] (account:string dpof-id:string)
        (map (at "value")
            (select DPOF|T|Nonces ["value"]
                (and?
                    (where "id" (= dpof-id))
                    (where "holder" (= account))
                )
            )
        )
    )
    ;;{F1}  [URC]
    (defun URDC_WipePure:object{DpofUdc.RemovableNonces} (account:string id:string)
        @doc "Uses Expensive Read Functions to obtain a |object{DpofUdc.RemovableNonces}| that can be used \
            \ to execute a <C_WipePure>, bypassing the expensive gas costs of using (keys...) or (select...) functions"
        (let
            (
                (nonces:[integer] (URD_AccountNonces account id))
                (amounts:[decimal] (UR_NoncesSupplies id nonces))
            )
            (UDC_RemovableNonces nonces amounts)
        )
    )
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
    ;;
    (defun URC_HasVesting:bool (id:string)
        @doc "Returns a boolean if DPOF has a vesting counterpart"
        (if (= (UR_Vesting id) BAR)
            false
            true
        )
    )
    (defun URC_HasSleeping:bool (id:string)
        @doc "Returns a boolean if DPOF has a sleeping counterpart"
        (if (= (UR_Sleeping id) BAR)
            false
            true
        )
    )
    (defun URC_HasHibernation:bool (id:string)
        @doc "Returns a boolean if DPOF has a hibernation counterpart"
        (if (= (UR_Hibernation id) BAR)
            false
            true
        )
    )
    (defun URC_Parent:string (dpof:string)
        @doc "Computes <dpof> parent"
        (let
            (
                (fourth:string (drop 3 (take 4 dpof)))
            )
            (enforce (!= fourth BAR) "Sleeping LP Tokens not allowed for this operation")
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    (first-two:string (take 2 dpof))
                )
                (cond
                    ((= first-two "V|") (UR_Vesting dpof))
                    ((= first-two "Z|") (UR_Sleeping dpof))
                    ((= first-two "H|") (UR_Hibernation dpof))
                    dpof
                )
            )
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_id (id:string)
        (with-default-read DPOF|T|Properties id
            { "supply" : -1.0 }
            { "supply" := s }
            (enforce
                (>= s 0.0)
                (format "DPOF ID {} does not exist" [id])
            )
        )
    )
    (defun UEV_NoncesCirculating (id:string nonces:[integer])
        @doc "Validates that <nonces> are in circulation"
        (map
            (lambda
                (element:integer)
                (let
                    (
                        (nonce-supply:decimal (UR_NonceSupply id element))
                    )
                    (enforce 
                        (!= nonce-supply -1.0) 
                        (format "{} {} Nonce {} must be in Circulation for exec"[OF id element])
                    )
                )
            )
            nonces
        )
    )
    (defun UEV_ParentOwnership (id:string)
        @doc "Enforces: \
            \ <id> Ownership, if <id> is pure \
            \ <(UR_Vesting id)>, if its a Vested ID \
            \ <(UR_Sleeping id)>, if its a Sleeping ID \
            \ <(UR_Hibernation id)>, if its a Hibernation ID \
            \ While ensuring a Sleeping LP cant be used for this operation."
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (parent:string (URC_Parent id))
            )
            (if (= parent id)
                (CAP_Owner id)
                (ref-DPTF::CAP_Owner parent)
            )
        )
    )
    (defun UEV_NoncesToAccount (id:string account:string nonces:[integer])
        @doc "Enforces <nonces> of <id> are held by <account>"
        (map
            (lambda
                (idx:integer)
                (let
                    (
                        (nonce:integer (at idx nonces))
                        (nonce-holder:string (UR_NonceHolder id nonce))
                    )
                    (enforce (= account nonce-holder) (format "Nonce {} of DPOF {} is not owned by account" [nonce id account]))
                )
            )
            (enumerate 0 (- (length nonces)1))
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
    ;;
    (defun UEV_UpdateRewardBearingToken (id:string)
        (let
            (
                (rbt:string (UR_RewardBearingToken id))
            )
            (enforce (= rbt BAR) (format "{} as an RBT is immutable tied to an ATS-Pair" [OF]))
        )
    )
    ;;
    (defun UEV_CanUpgradeON (id:string)
        (let
            (
                (x:bool (UR_CanUpgrade id))
            )
            (enforce (= x true) (format "{} {} properties cannot be upgraded" [OF id]))
        )
    )
    (defun UEV_CanChangeOwnerON (id:string)
        (let
            (
                (x:bool (UR_CanChangeOwner id))
            )
            (enforce (= x true) (format "{} {} ownership cannot be changed" [OF id]))
        )
    )
    (defun UEV_CanAddSpecialRoleON (id:string)
        (let
            (
                (x:bool (UR_CanAddSpecialRole id))
            )
            (enforce (= x true) (format "For {} {} no special roles can be added" [OF id]))
        )
    )
    (defun UEV_CanTransferOftCreateRoleON (id:string)
        (let
            (
                (x:bool (UR_CanTransferOftCreateRole id))
            )
            (enforce (= x true) (format "{}} Token {} cannot have its create role transfered" [OF id]))
        )
    )
    (defun UEV_CanFreezeON (id:string)
        (let
            (
                (x:bool (UR_CanFreeze id))
            )
            (enforce (= x true) (format "{} {} cannot be freezed" [OF id]))
        )
    )
    (defun UEV_CanWipeON (id:string)
        (let
            (
                (x:bool (UR_CanWipe id))
            )
            (enforce (= x true) (format "{} {} cannot be wiped" [OF id]))
        )
    )
    (defun UEV_CanPauseON (id:string)
        (let
            (
                (x:bool (UR_CanPause id))
            )
            (enforce (= x true) (format "{} {} cannot be paused" [OF id])
            )
        )
    )
    (defun UEV_PauseState (id:string state:bool)
        (let
            (
                (x:bool (UR_IsPaused id))
            )
            (if state
                (enforce x (format "{} {} is already unpaused" [OF id]))
                (enforce (= x false) (format "{} {} is already paused" [OF id]))
            )
        )
    )
    ;;
    (defun UEV_SegmentationState (id:string state:bool)
        (let
            (
                (x:bool (UR_Segmentation id))
            )
            (enforce (= x state) (format "Segmentation state for {} {} must be set to {} for exec" [OF id state]))
        )
    )
    (defun UEV_AccountFreezeState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_R-Frozen id account))
            )
            (enforce (= x state) (format "Frozen for {} {} on Account {} must be set to {} for exec" [OF id account state]))
        )
    )
    (defun UEV_AccountAddQuantityState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_R-AddQuantity id account))
            )
            (enforce (= x state) (format "Add Quantity Role for {} {} on Account {} must be set to {} for exec" [OF id account state]))
        )
    )
    (defun UEV_AccountBurnState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_R-Burn id account))
            )
            (enforce (= x state) (format "Burn Role for {} {} on Account {} must be set to {} for exec" [OF id account state]))
        )
    )
    (defun UEV_AccountCreateState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_R-Create id account))
            )
            (enforce (= x state) (format "Create Role for {} {} on Account {} must be set to {} for exec" [OF id account state]))
        )
    )
    (defun UEV_AccountTransferState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_R-Transfer id account))
            )
            (enforce (= x state) (format "Transfer Role for {} {} on Account {} must be set to {} for exec" [OF id account state]))
        )
    )
    ;;
    (defun UEV_Vesting (id:string existance:bool)
        (let
            (
                (has-vesting:bool (URC_HasVesting id))
            )
            (enforce (= has-vesting existance) (format "Vesting for the Token {} {} is not satisfied with existance {}" [OF id existance]))
        )
    )
    (defun UEV_Sleeping (id:string existance:bool)
        (let
            (
                (has-sleeping:bool (URC_HasSleeping id))
            )
            (enforce (= has-sleeping existance) (format "Sleeping for the Token {} {} is not satisfied with existance {}" [OF id existance]))
        )
    )
    (defun UEV_Hibernation (id:string existance:bool)
        (let
            (
                (has-hibernation:bool (URC_HasHibernation id))
            )
            (enforce (= has-hibernation existance) (format "Hibernation for the Token {} {} is not satisfied with existance {}" [OF id existance]))
        )
    )
    (defun UEV_MoveRoleCheck (id:string sender:string receiver:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (verum-five:[string] (UR_Verum5 id))
                (lvf:integer (length verum-five))
                (transfer-roles:integer
                    (if (and (= lvf 1) (= verum-five [BAR]))
                        0 lvf
                    )
                )
                (are-transfer-roles-active:bool (if (> transfer-roles 0) true false))
                (ss:string (ref-I|OURONET::OI|UC_ShortAccount sender))
                (sr:string (ref-I|OURONET::OI|UC_ShortAccount receiver))
                (allow:string (format "{} Transfer from {} to {} is allowed" [OF ss sr]))
            )
            (if are-transfer-roles-active
                (let
                    (
                        (ref-DALOS:module{OuronetDalosV5} DALOS)
                        (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                        (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
                        ;;
                        (sender-transfer-role:bool (UR_R-Transfer id sender))
                        (receiver-transfer-role:bool (UR_R-Transfer id receiver))
                    )
                    (enforce-one
                        (format "Incompatible Transfer Roles from {} to {}" [ss sr])
                        [
                            (enforce sender-transfer-role (format "Incompatible Transfer Role for Sender {}" [ss]))
                            (enforce receiver-transfer-role (format "Incompatible Transfer Role for Receiver {}" [sr]))
                        ]
                    )
                )
                allow
            )
        )
    )
    ;;{F3}  [UDC]
    (defun UDC_NonceElement:object{DpofUdc.DPOF|NonceElement}
        (a:string b:string c:integer d:decimal e:[object])
        {"holder"           : a
        ,"id"               : b
        ,"value"            : c
        ,"supply"           : d
        ,"meta-data-chain"  : e}
    )
    (defun UDC_VerumRoles:object{DpofUdc.DPOF|VerumRoles}
        (a:[string] b:[string] c:[string] d:string e:[string])
        {"a-frozen"             : a
        ,"r-oft-add-quantity"   : b
        ,"r-oft-burn"           : c
        ,"r-oft-create"         : d
        ,"r-transfer"           : e}
    )
    (defun UDC_AccountRoles:object{DpofUdc.DPOF|AccountRoles}
        (a:decimal b:bool c:bool d:bool e:bool f:bool)
        {"total-account-supply"     : a
        ,"frozen"                   : b
        ,"role-oft-add-quantity"    : c
        ,"role-oft-burn"            : d
        ,"role-oft-create"          : e
        ,"role-transfer"            : f}
    )
    (defun UDC_RemovableNonces:object{DpofUdc.RemovableNonces}
        (a:[integer] b:[decimal])
        {"r-nonces"     : a
        ,"r-amounts"    : b}
    )
    (defun UDCX_TransmitData:object{TransmitData}
        (a:[integer] b:[decimal] c:[integer] d:[[object]])
        {"input-nonces"     : a
        ,"input-amounts"    : b
        ,"output-nonces"    : c
        ,"meta-data-array"  : d}
    )
    ;;{F4}  [CAP]
    (defun CAP_Owner (id:string)
        @doc "Enforces DPOF Token ID Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (UR_Konto id))
        )
    )
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_UpdatePendingBranding:object{IgnisCollectorV2.OutputCumulator}
        (entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-BRD:module{Branding} BRD)
            )
            (with-capability (DPOF|C>UPDATE-BRD entity-id)
                (ref-BRD::XE_UpdatePendingBranding entity-id logo description website social)
                (ref-IGNIS::UDC_BrandingCumulator (UR_Konto entity-id) 1.5)
            )
        )
    )
    (defun C_UpgradeBranding (patron:string entity-id:string months:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-BRD:module{Branding} BRD)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (parent:string (URC_Parent entity-id))
                (parent-owner:string
                    (if (= parent entity-id)
                        (UR_Konto entity-id)
                        (ref-DPTF::UR_Konto parent)
                    )
                )
                (kda-payment:decimal
                    (with-capability (DPOF|C>UPGRADE-BRD entity-id)
                        (ref-BRD::XE_UpgradeBranding entity-id parent-owner months)
                    )
                )
            )
            (ref-IGNIS::KDA|C_CollectWT patron kda-payment false)
        )
    )
    ;;
    (defun C_Issue:object{IgnisCollectorV2.OutputCumulator}
        (
            patron:string account:string 
            name:[string] ticker:[string] decimals:[integer]
            can-upgrade:[bool] can-change-owner:[bool] can-add-special-role:[bool] can-transfer-oft-create-role:[bool]
            can-freeze:[bool] can-wipe:[bool] can-pause:[bool]
        )
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (l1:integer (length name))
                (mf-cost:decimal (ref-DALOS::UR_UsagePrice "dpmf"))
                (kda-costs:decimal (* (dec l1) mf-cost))
                (iz-special:[bool] (make-list l1 false))
                (ico:object{IgnisCollectorV2.OutputCumulator}
                    (with-capability (SECURE)
                        (XB_IssueFree 
                            account name ticker decimals 
                            can-upgrade can-change-owner can-add-special-role can-transfer-oft-create-role
                            can-freeze can-wipe can-pause iz-special
                        )
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
            (with-capability (DPOF|S>ROTATE-OWNERSHIP id new-owner)
                (XI_ChangeOwnership id new-owner)
                (ref-IGNIS::UDC_BiggestCumulator (UR_Konto id))
            )
        )
    )
    (defun C_Control:object{IgnisCollectorV2.OutputCumulator}
        (id:string cu:bool cco:bool casr:bool ctocr:bool cf:bool cw:bool cp:bool sg:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
            )
            (with-capability (DPOF|S>CONTROL id)
                (XI_Control id cu cco casr ctocr cf cw cp sg)
                (ref-IGNIS::UDC_MediumCumulator (UR_Konto id))
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
            (with-capability (DPOF|S>PAUSE id toggle)
                ;;Pause|Unpause <id>
                (XI_TogglePause id toggle)
                ;;Output
                (ref-IGNIS::UDC_MediumCumulator (UR_Konto id))
            )
        )
    )
    ;;
    (defun C_DeployAccount (id:string account:string)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (create-role-account:string (UR_Verum4 id))
                (f:bool false)
                (role-oft-create-boolean:bool (if (= create-role-account account) true f))
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id)
            (with-default-read DPOF|T|AccountRoles (UC_IdAccount id account)
                (UDC_AccountRoles 0.0 f f f role-oft-create-boolean f)
                {"total-account-supply"     := tas
                ,"frozen"                   := fz
                ,"role-oft-add-quantity"    := roaq
                ,"role-oft-burn"            := rob
                ,"role-oft-create"          := roc
                ,"role-transfer"            := rt}
                (with-capability (SECURE)
                    (XB_W|AccountRoles id account
                        (UDC_AccountRoles tas fz roaq rob roc rt)
                    )
                )
            )
        )
    )
    (defun C_ToggleFreezeAccount:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string toggle:bool)
        @doc "Toggle Verum 1"
        (UEV_IMC)
        (with-capability (DPOF|C>FREEZE id account toggle)
            (let
                (
                    (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (verum-one:[string] (UR_Verum1 id))
                    (updated-verum-one:[string] (ref-U|DALOS::UC_NewRoleList verum-one account toggle))
                )
                ;;Deploy WNE
                (XB_DeployAccountWNE account id)
                ;;Update Verum Roles
                (XI_UpdateVerum1 id updated-verum-one)
                ;;Update Account Roles
                (XI_ToggleFreezeAccount id account toggle)
                ;;Output
                (ref-IGNIS::UDC_BiggestCumulator (UR_Konto id))
            )
        )
    )
    (defun C_ToggleAddQuantityRole:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string toggle:bool)
        @doc "Toggle Verum 2"
        (UEV_IMC)
        (with-capability (DPOF|C>TOGGLE-ADD-QUANTITY-ROLE id account toggle)
            (let
                (
                    (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (verum-two:[string] (UR_Verum2 id))
                    (updated-verum-two:[string] (ref-U|DALOS::UC_NewRoleList verum-two account toggle))
                )
                ;;Deploy WNE
                (XB_DeployAccountWNE account id)
                ;;Update Verum Roles
                (XI_UpdateVerum2 id updated-verum-two)
                ;;Update Account Roles
                (XI_ToggleAddQuantityRole id account toggle)
                ;;Output
                (ref-IGNIS::UDC_BiggestCumulator (UR_Konto id))
            )
        )
    )
    (defun C_ToggleBurnRole:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string toggle:bool)
        @doc "Toggle Verum 3"
        (UEV_IMC)
        (with-capability (DPOF|C>TOGGLE-BURN-ROLE id account toggle)
            (let
                (
                    (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (verum-three:[string] (UR_Verum3 id))
                    (updated-verum-three:[string] (ref-U|DALOS::UC_NewRoleList verum-three account toggle))
                )
                ;;Deploy WNE
                (XB_DeployAccountWNE account id)
                ;;Update Verum Roles
                (XI_UpdateVerum3 id updated-verum-three)
                ;;Update Account Roles
                (XI_ToggleBurnRole id account toggle)
                ;;Output
                (ref-IGNIS::UDC_BiggestCumulator (UR_Konto id))
            )
        )
    )
    (defun C_MoveCreateRole:object{IgnisCollectorV2.OutputCumulator}
        (id:string receiver:string)
        @doc "Switch Verum 4"
        (UEV_IMC)
        (with-capability (DPOF|C>SWITCH-CREATE-ROLE id receiver)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                )
                ;;Deploy WNE
                (XB_DeployAccountWNE receiver id)
                ;;Update Verum Roles
                (XI_UpdateVerum4 id receiver)
                ;;Update Account Roles
                (XI_SwitchCreateRole id receiver)
                ;;Output
                (ref-IGNIS::UDC_BiggestCumulator (UR_Konto id))
            )
        )
    )
    (defun C_ToggleTransferRole:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string toggle:bool)
        @doc "Toggle Verum 5"
        (UEV_IMC)
        (with-capability (DPOF|C>TOGGLE-TRANSFER-ROLE id account toggle)
            (let
                (
                    (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (verum-five:[string] (UR_Verum5 id))
                    (updated-verum-five:[string] (ref-U|DALOS::UC_NewRoleList verum-five account toggle))
                )
                ;;Deploy WNE
                (XB_DeployAccountWNE account id)
                ;;Update Verum Roles
                (XI_UpdateVerum5 id updated-verum-five)
                ;;Update Account Roles
                (XI_ToggleTransferRole id account toggle)
                ;;Output
                (ref-IGNIS::UDC_BiggestCumulator (UR_Konto id))
            )
        )
        
    )
    ;;
    (defun C_AddQuantity:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string nonce:integer amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (supply:decimal (UR_Supply id))
            )
            (with-capability (DPOF|C>ADD-QTY account id nonce amount)
                ;;Credit <nonce> held on <account> by <amount> 
                (XI_CreditNonces account id [nonce] [amount] [[{}]])
                ;;Update <id> Supply
                (XI_UpdateSupply id (+ supply amount))
                ;;Output
                (ref-IGNIS::UDC_SmallCumulator (UR_Konto id))
            )
        )
    )
    (defun C_Burn:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string nonce:integer amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (supply:decimal (UR_Supply id))
            )
            (with-capability (DPOF|C>BURN account id nonce amount)
                ;;Debit <nonce> held on <account> by <amount>
                (XI_DebitNonces account id [nonce] [amount] false)
                ;;Update <id> Supply
                (XI_UpdateSupply id (- supply amount))
                ;;Output
                (ref-IGNIS::UDC_SmallCumulator (UR_Konto id))
            )
        )
    )
    (defun C_Mint:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string amount:decimal meta-data-chain:[object])
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (supply:decimal (UR_Supply id))
                (nonces-used:integer (UR_NoncesUsed id))
            )
            (with-capability (DPOF|C>MINT account id amount meta-data-chain)
                ;;Credit <nonce> held on <account> by <amount>
                (XI_CreditNonces account id [(+ nonces-used 1)] [amount] [meta-data-chain])
                ;;Update <id> Supply
                (XI_UpdateSupply id (+ supply amount))
                ;;Output
                (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                    [(ref-IGNIS::UDC_MediumCumulator (UR_Konto id))]
                    [(UR_NoncesUsed id)]
                )
            )
        )
    )
    ;;Wipes
    (defun C_WipeSlim:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string nonce:integer amount:decimal)
        @doc "Wipes a specific DPOF <id> <nonce> on <account> by <amount> \
        \ Amount may be lower or equal to the nonce amount. \
        \ Requires <id> has <segmentation> set to true"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (supply:decimal (UR_Supply id))
            )
            (with-capability (DPOF|C>WIPE-SLIM account id nonce amount)
                ;;Debit <nonce> held on <account> by <amount>
                (XI_DebitNonces account id [nonce] [amount] true)
                ;;Update <id> Supply
                (XI_UpdateSupply id (- supply amount))
                ;;Output 2 IGNIS
                (ref-IGNIS::UDC_SmallCumulator (UR_Konto id))
            )
        )
    )
    (defun C_WipeHeavy:object{IgnisCollectorV2.OutputCumulator} (id:string account:string)
        @doc "Wipes all viable <id> Nonces of an DPOF <account> \
            \ \
            \ |Heavy| reffers to the usage of expensive functions like <select> or <keys> \
            \ (that arent meant to be used in transactional context) to get the Account Nonces; \
            \ May fit in a single Transaction for Small Data Sets"
        (UEV_IMC)
        (C_WipePure id account (URDC_WipePure account id))
    )
    (defun C_WipePure:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string removable-nonces-obj:object{DpofUdc.RemovableNonces})
        @doc "Wipes all <id> Nonces of an DPOF <account>, presented via an <removable-nonces-obj> object \
            \ \
            \ The object must be pre-read (dirty read) \
            \ \
            \ Example to retrieve the <removable-nonces-obj> \
            \ <(URDC_WipePure account id)> ; to get the whole object \
            \ <(UC_TakePureWipe (URDC_WipePure account id) 165)> ; to get only the first 165 units \
            \ Aproximately xx Individual Wipes fit inside one TX (for NFTs)."
        (UEV_IMC)
        (let
            (
                (supply:decimal (UR_Supply id))
                (nonces:[integer] (at "r-nonces" removable-nonces-obj))
                (amounts:[decimal] (at "r-amounts" removable-nonces-obj))
                (sum:decimal (fold (+) 0.0 amounts))
            )
            (with-capability (DPOF|C>WIPE account id nonces)
                ;;Debit <nonces> by <amounts> on <account> for <id>
                (XI_DebitNonces account id nonces amounts true)
                ;;Update <id> Supply
                (XI_UpdateSupply id (- supply sum))
                ;;Output (2 IGNIS per Nonce Wiped)
                (UC_WipeCumulator id removable-nonces-obj)
            )
        )
    )
    (defun C_WipeClean:object{IgnisCollectorV2.OutputCumulator}
        (id:string account:string nonces:[integer])
        @doc "Wipes <id> select <nonces> of a DPOF <account>"
        (UEV_IMC)
        (C_WipePure id account
            (UDC_RemovableNonces
                nonces
                (UR_NoncesSupplies id nonces)
            )
        )
    )
    ;;Transfers
    (defun C_Transmit:object{IgnisCollectorV2.OutputCumulator}
        (id:string nonces:[integer] amounts:[decimal] sender:string receiver:string method:bool)
        @doc "Transfer DPOF <id> <nonces> from <sender> to <receiver> by a specific <amount> \
            \ This debits the <sender> nonces by <amount> and creates new nonces on receiver of <amount> \
            \ Requires <segmentation> set to <true> \
            \ Using an <amount> equal to the nonce supply, will take nonce out of the circulation"
        (UEV_IMC)
        (let
            (
                (nonces-used:integer (UR_NoncesUsed id))
                (how-many:integer (length nonces))
                (output-nonces:[integer] (enumerate (+ nonces-used 1) (+ nonces-used how-many)))
                (meta-data-array:[[object]] (UR_NoncesMetaDatas id nonces))
                (td:object{TransmitData}
                    (UDCX_TransmitData nonces amounts output-nonces meta-data-array)
                )
            )
            (with-capability (DPOF|C>TRANSMIT id td sender receiver method)
                ;;1]Debit sender
                (XI_DebitNonces sender id nonces amounts false)
                ;;2]Credit receiver
                (XI_CreditNonces receiver id output-nonces amounts meta-data-array)
                ;;3]Output Costs 2 IGNIS per Nonce Transmitted
                (UC_MoveCumulator id nonces true)
            )
        )
    )
    (defun C_Transfer:object{IgnisCollectorV2.OutputCumulator}
        (id:string nonces:[integer] sender:string receiver:string method:bool)
        @doc "Transfer DPOF <id> <nonces> from <sender> to <receiver> by changing their Ownership"
        (UEV_IMC)
        (with-capability (DPOF|C>TRANSFER id nonces sender receiver method)
            (let
                (
                    (sender-supply:decimal (UR_AccountSupply id sender))
                    (receiver-supply:decimal (UR_AccountSupply id receiver))
                    (nonces-supplies:[decimal] (UR_NoncesSupplies id nonces))
                    (sum:decimal (fold (+) 0.0 nonces-supplies))
                )
                ;;1]Deploy Receiver account if it doesnt exist
                (XB_DeployAccountWNE receiver id)
                ;;2]Decrease Supply for Sender and increase for Receiver
                (XI_UpdateAccountSupply id sender (- sender-supply sum))
                (XI_UpdateAccountSupply id receiver (+ receiver-supply sum))
                ;;2]Transfer <nonces> to <receiver>
                (map
                    (lambda
                        (element:integer)
                        (XI_UpdateNonceHolder id element receiver)
                    )
                    nonces
                )
                ;;3]Output Costs 1 IGNIS per Nonce Transfered
                (UC_MoveCumulator id nonces false)
            )
        )
    )
    ;;{F7}  [X]
    (defun XB_IssueFree:object{IgnisCollectorV2.OutputCumulator}
        (
            account:string
            ;;
            name:[string]
            ticker:[string]
            decimals:[integer]
            ;;
            can-upgrade:[bool]
            can-change-owner:[bool]
            can-add-special-role:[bool]
            can-transfer-oft-create-role:[bool]
            ;;
            can-freeze:[bool]
            can-wipe:[bool]
            can-pause:[bool]
            ;;
            iz-special:[bool]
        )
        (UEV_IMC)
        (with-capability 
            (DPOF|C>ISSUE 
                account name ticker decimals    
                can-upgrade can-change-owner can-add-special-role can-transfer-oft-create-role
                can-freeze can-wipe can-pause
            )
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DALOS:module{OuronetDalosV5} DALOS)
                    (ref-BRD:module{Branding} BRD)
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (l1:integer (length name))
                    (gas-costs:decimal (* (dec l1) (ref-DALOS::UR_UsagePrice "ignis|token-issue")))
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
                                                ;;
                                                (at index can-upgrade)
                                                (at index can-change-owner)
                                                (at index can-add-special-role)
                                                (at index can-transfer-oft-create-role)
                                                ;;
                                                (at index can-freeze)
                                                (at index can-wipe)
                                                (at index can-pause)
                                                ;;
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
    (defun XB_DeployAccountWNE (account:string id:string)
        (UEV_IMC)
        (let
            (
                (iz-account:bool (UR_IzAccount account id))
            )
            (if (not iz-account)
                (C_DeployAccount id account)
                true
            )
        )
    )
    ;;
    (defun XI_Issue:string
        (
            account:string
            name:string
            ticker:string
            decimals:integer
            ;;
            can-upgrade:bool
            can-change-owner:bool
            can-add-special-role:bool
            can-transfer-oft-create-role:bool
            ;;
            can-freeze:bool
            can-wipe:bool
            can-pause:bool
            ;;
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
            ;;
            (XI_InsertNewId id
                {"owner-konto"                  : account
                ,"name"                         : name
                ,"ticker"                       : ticker
                ,"decimals"                     : decimals
                ;;
                ,"can-upgrade"                  : can-upgrade                           ;;false
                ,"can-change-owner"             : can-change-owner                      ;;false
                ,"can-add-special-role"         : can-add-special-role                  ;;true
                ,"can-transfer-oft-create-role" : can-transfer-oft-create-role          ;;false
                ;;
                ,"can-freeze"                   : can-freeze                            ;;true
                ,"can-wipe"                     : can-wipe                              ;;true
                ,"can-pause"                    : can-pause                             ;;false
                ,"segmentation"                 : false
                ;;
                ,"is-paused"                    : false
                ,"nonces-used"                  : 0
                ,"nonces-excluded"              : 0
                ;;
                ,"supply"                       : 0.0
                ;;
                ,"reward-bearing-token"         : BAR
                ,"vesting-link"                 : BAR
                ,"sleeping-link"                : BAR
                ,"hibernation-link"             : BAR}
            )
            (XI_WriteRoles id
                (UDC_VerumRoles
                    [BAR]
                    [BAR]
                    [BAR]
                    account
                    [BAR]
                )
            )
            (C_DeployAccount id account)
            id
        )
    )
    (defun XI_Control
        (
            id:string
            can-upgrade:bool
            can-change-owner:bool
            can-add-special-role:bool
            can-transfer-oft-create-role:bool
            can-freeze:bool
            can-wipe:bool
            can-pause:bool
            segmentation:bool
        )
        (require-capability (DPOF|S>CONTROL id))
        (update DPOF|T|Properties id
            {"can-upgrade"                  : can-upgrade
            ,"can-change-owner"             : can-change-owner
            ,"can-add-special-role"         : can-add-special-role
            ,"can-transfer-oft-create-role" : can-transfer-oft-create-role
            ,"can-freeze"                   : can-freeze
            ,"can-wipe"                     : can-wipe
            ,"can-pause"                    : can-pause
            ,"segmentation"                 : segmentation}
        )
    )
    ;;
    (defun XI_DebitNonces (account:string id:string nonces:[integer] amounts:[decimal] wipe-mode:bool)
        @doc "Debit DPOF <id> <nonces> on <account> with <amounts> \
            \ Will Take Nonce out of circulation if all <nonce> supply is debited. \
            \ Only Performs debitation, does not update supply. \
            \ All <nonces> must be held by <account>"
        (require-capability (DPOF|C>DEBIT account id nonces amounts wipe-mode))
        (let
            (
                (tas:decimal (UR_AccountSupply id account))
                (sum:decimal (fold (+) 0.0 amounts))
            )
            (XI_UpdateAccountSupply id account (- tas sum))
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (nonce:integer (at idx nonces))
                            (amount:decimal (at idx amounts))
                            (nonce-supply:decimal (UR_NonceSupply id nonce))
                            (nonce-holder:string (UR_NonceHolder id nonce))
                        )
                        (if (= amount nonce-supply)
                            ;;Take Nonce out of Circulation;
                            (do
                                (XI_UpdateNonceSupply id nonce -1.0)
                                (XI_UpdateNonceHolder id nonce BAR)
                                (XI_IncrementNoncesExcluded id)
                            )
                            ;;Only Debit Nonce without taking it out of circulation
                            (XI_UpdateNonceSupply id nonce (- nonce-supply amount))
                        )
                    )
                )
                (enumerate 0 (- (length nonces) 1))
            )
        )  
    )
    (defun XI_CreditNonces (account:string id:string nonces:[integer] amounts:[decimal] meta-data-array:[[object]])
        @doc "Credit a DPOF <id> <nonces> on <account> with <amounts> and <meta-datas> \
            \ Only Performs creditation, does not update supply\
            \ Designed to Process <nonces> in two variants \
            \ Either the nonce exists already, in which case length must be 1; <iz-singular> true\
            \ Or ALL the nonce dont exist, in which case the length must be greater than 1; <iz-singular> false"
        (require-capability (DPOF|C>CREDIT account id nonces amounts meta-data-array))
        ;;Deploy Account WNE
        (XB_DeployAccountWNE account id)
        (let
            (
                (iz-singular:bool (UC_IzSingular id nonces))
                (iz-consecutive:bool (UC_IzConsecutive id nonces))
                (tas:decimal (UR_AccountSupply id account))
                (sum:decimal (fold (+) 0.0 amounts))
            )
            ;;Update Total Individual Account Supply
            (XI_UpdateAccountSupply id account (+ tas sum))
            (if iz-singular
                (XI_UpdateNonceSupply id (at 0 nonces) (+ (UR_NonceSupply id (at 0 nonces)) (at 0 amounts)))
                true
            )
            (if iz-consecutive
                (do
                    ;;Update <nonces-used> in properties of <id>
                    (XI_UpdateNoncesUsed id (at 0 (take -1 nonces)))
                    ;;Insert New Nonces
                    (XI_InsertNewNonces account id nonces amounts meta-data-array)
                )
                true
            )
        )
    )
    ;;
    ;;Pure Write/Update Functions
    ;;1]DPOF|T|Properties
    (defun XI_InsertNewId (id:string id-data:object{DpofUdc.DPOF|Properties})
        (UEV_IMC)
        (insert DPOF|T|Properties id id-data)
    )
    (defun XI_ChangeOwnership (id:string new-owner:string)
        (require-capability (DPOF|S>ROTATE-OWNERSHIP id new-owner))
        (update DPOF|T|Properties id
            {"owner-konto" : new-owner}
        )
    )
    (defun XI_TogglePause (id:string toggle:bool)
        (require-capability (DPOF|S>PAUSE id toggle))
        (update DPOF|T|Properties id
            { "is-paused" : toggle}
        )
    )
    (defun XI_UpdateSupply (id:string new-supply:decimal)
        (require-capability (SECURE))
        (update DPOF|T|Properties id
            {"supply" : new-supply}
        )
    )
    (defun XI_UpdateNoncesUsed (id:string new-value:integer)
        (require-capability (SECURE))
        (update DPOF|T|Properties id
            {"nonces-used" : new-value}
        )
    )
    (defun XI_IncrementNoncesExcluded (id:string)
        (require-capability (SECURE))
        (let
            (
                (excluded:integer (UR_NoncesExcluded id))
            )
            (update DPOF|T|Properties id
                {"nonces-excluded" : (+ excluded 1)}
            )
        )
    )
    (defun XE_UpdateRewardBearingToken (atspair:string hot-rbt:string)
        (UEV_IMC)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (with-read DPOF|T|Properties hot-rbt
                {"reward-bearing-token" := rbt}
                (enforce (= rbt BAR) (format "RBT-Data for DPOF {} is already set as ATS-Pair {}" [hot-rbt rbt]))
                (update DPOF|T|Properties hot-rbt
                    {"reward-bearing-token" : atspair}
                )
            )
        )
    )
    (defun XI_UpdateVesting (dptf:string dpof:string)
        (require-capability (SECURE))
        (update DPOF|T|Properties dpof
            {"vesting-link" : dptf}
        )
    )
    (defun XI_UpdateSleeping (dptf:string dpof:string)
        (require-capability (SECURE))
        (update DPOF|T|Properties dpof
            {"sleeping-link" : dptf}
        )
    )
    (defun XI_UpdateHibernation (dptf:string dpof:string)
        (require-capability (SECURE))
        (update DPOF|T|Properties dpof
            {"hibernation-link" : dptf}
        )
    )
    (defun XE_UpdateSpecialOrtoFungible:object{IgnisCollectorV2.OutputCumulator}
        (main-dptf:string secondary-dpof:string vzh-tag:integer)
        (UEV_IMC)
        (with-capability (DPOF|C>UPDATE-SPECIAL main-dptf secondary-dpof vzh-tag)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                )
                (cond
                    ((= vzh-tag 1)
                        (do
                            (ref-DPTF::XE_UpdateVesting main-dptf secondary-dpof)
                            (XI_UpdateVesting main-dptf secondary-dpof)
                        )
                    )
                    ((= vzh-tag 2)
                        (do
                            (ref-DPTF::XE_UpdateSleeping main-dptf secondary-dpof)
                            (XI_UpdateSleeping main-dptf secondary-dpof)
                        )
                    )
                    ((= vzh-tag 3)
                        (do
                            (ref-DPTF::XE_UpdateHibernation main-dptf secondary-dpof)
                            (XI_UpdateHibernation main-dptf secondary-dpof)
                        )
                    )
                    true
                )
                (ref-IGNIS::UDC_BiggestCumulator (ref-DPTF::UR_Konto main-dptf))
            )
        )
    )
    ;;2]DPOF|T|Nonces
    (defun XI_InsertNewNonces (nonce-owner:string id:string nonces:[integer] amounts:[decimal] meta-data-array:[[object]])
        (require-capability (SECURE))
        (with-capability (SECURE)
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (nonce:integer (at idx nonces))
                            (amount:decimal (at idx amounts))
                            (meta-data-chain:[object] (at idx meta-data-array))
                        )
                        (XB_InsertNewNonce nonce-owner id nonce amount meta-data-chain)
                    )
                )
                (enumerate 0 (- (length nonces) 1))
            )
        )
    )
    (defun XB_InsertNewNonce (nonce-owner:string id:string nonce:integer amount:decimal meta-data-chain:[object])
        (UEV_IMC)
        (insert DPOF|T|Nonces (UC_IdNonce id nonce)
            (UDC_NonceElement nonce-owner id nonce amount meta-data-chain)
        )
    )
    (defun XI_UpdateNonceSupply (id:string nonce:integer new-nonce-supply:decimal)
        (require-capability (SECURE))
        (update DPOF|T|Nonces (UC_IdNonce id nonce)
            {"supply" : new-nonce-supply}
        )
    )
    (defun XI_UpdateNonceHolder (id:string nonce:integer new-nonce-holder:string)
        (require-capability (SECURE))
        (update DPOF|T|Nonces (UC_IdNonce id nonce)
            {"holder" : new-nonce-holder}
        )
    )
    ;;3]DPOF|T|VerumRoles
    (defun XI_WriteRoles (id:string verum-roles:object{DpofUdc.DPOF|VerumRoles})
        (UEV_IMC)
        (write DPOF|T|VerumRoles id verum-roles)
    )
    (defun XI_UpdateVerum1 (id:string new-verum1:[string])
        (require-capability (SECURE))  
        (update DPOF|T|VerumRoles id
            {"a-frozen" : new-verum1}
        )
    )
    (defun XI_UpdateVerum2 (id:string new-verum2:[string])
        (require-capability (SECURE))  
        (update DPOF|T|VerumRoles id
            {"r-oft-add-quantity" : new-verum2}
        )
    )
    (defun XI_UpdateVerum3 (id:string new-verum3:[string])
        (require-capability (SECURE))  
        (update DPOF|T|VerumRoles id
            {"r-oft-burn" : new-verum3}
        )
    )
    (defun XI_UpdateVerum4 (id:string new-r-oft-create-account:string)
        (require-capability (SECURE))  
        (update DPOF|T|VerumRoles id
            {"r-oft-create" : new-r-oft-create-account}
        )
    )
    (defun XI_UpdateVerum5 (id:string new-verum5:[string])
        (require-capability (SECURE))  
        (update DPOF|T|VerumRoles id
            {"r-transfer" : new-verum5}
        )
    )
    ;;4]DPOF|T|AccountRoles
    (defun XB_W|AccountRoles (id:string account:string account-data:object{DpofUdc.DPOF|AccountRoles})
        (UEV_IMC)
        (write DPOF|T|AccountRoles (UC_IdAccount id account)
            account-data
        )
    )
    (defun XI_ToggleFreezeAccount (id:string account:string toggle:bool)
        (require-capability (DPOF|S>X_FREEZE id account toggle))
        (update DPOF|T|AccountRoles (UC_IdAccount id account)
            { "frozen" : toggle}
        )
    )
    (defun XI_ToggleAddQuantityRole (id:string account:string toggle:bool)
        (require-capability (DPOF|S>X_TOGGLE-ADD-QUANTITY-ROLE id account toggle))
        (update DPOF|T|AccountRoles (UC_IdAccount id account)
            { "role-oft-add-quantity" : toggle}
        )
    )
    (defun XI_ToggleBurnRole (id:string account:string toggle:bool)
        (require-capability (DPOF|S>X_TOGGLE-BURN-ROLE id account toggle))
        (update DPOF|T|AccountRoles (UC_IdAccount id account)
            { "role-oft-burn" : toggle}
        )
    )
    (defun XI_SwitchCreateRole (id:string receiver:string)
        (require-capability (DPOF|S>X_SWITCH-CREATE-ROLE id receiver))
        (update DPOF|T|AccountRoles (UC_IdAccount id (UR_Verum4 id))
            { "role-oft-create" : false}
        )
        (update DPOF|T|AccountRoles (UC_IdAccount id receiver)
            { "role-oft-create" : true}
        )
    )
    (defun XI_ToggleTransferRole (id:string account:string toggle:bool)
        (require-capability (DPOF|S>X_TOGGLE-TRANSFER-ROLE id account toggle))
        (update DPOF|T|AccountRoles (UC_IdAccount id account)
            { "role-transfer" : toggle}
        )
    )
    (defun XI_UpdateAccountSupply (id:string account:string new-tas:decimal)
        (require-capability (SECURE))
        (update  DPOF|T|AccountRoles (UC_IdAccount id account)
            {"total-account-supply" : new-tas}
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)
;;
(create-table DPOF|T|Properties)
(create-table DPOF|T|Nonces)
(create-table DPOF|T|VerumRoles)
(create-table DPOF|T|AccountRoles)