(interface DpofUdc
    (defschema DPOF|Properties
        owner-konto:string
        name:string
        ticker:string
        decimals:integer
        ;;
        can-upgrade:bool
        can-change-owner:bool
        can-add-special-role:bool
        can-transfer-oft-create-role:bool
        can-freeze:bool
        can-wipe:bool
        can-pause:bool
        ;;
        is-paused:bool
        nonces-used:integer
        nonces-excluded:integer
        ;;
        supply:decimal
        ;;
        segmentation:bool
        reward-bearing-token:string
        vesting-link:string
        sleeping-link:string
        hibernation-link:string
        ;;
    )
    ;;Nonces cant be separated. A Ortofungible Nonce has one unique holder.
    (defschema DPOF|NonceElement
        holder:string                       ;;Stores the <OuronetAccount> holding the nonce - mutable
        id:string                           ;;ID of the Ortofungible - immutable.
        value:integer                       ;;Stores the Nonce value itself - immutable.
        supply:decimal                      ;;Nonce Supply - mutable
        meta-data:object                    ;;Stores Nonce Metadata - immutable
    )
    (defschema DPOF|VerumRoles
        a-frozen:[string]
        r-oft-add-quantity:[string]
        r-oft-burn:[string]
        r-oft-create:string
        r-transfer:[string]
    )
    (defschema DPOF|AccountRoles
        frozen:bool                         ;; multiple
        role-oft-add-quantity:bool          ;; multiple
        role-oft-burn:bool                  ;; multiple
        role-oft-create:bool                ;; single
        role-transfer:bool                  ;; multiple
        total-account-supply:decimal        ;; Holds the Total Account Supply for id
    )
    (defschema RemovableNonces
        @doc "Removable Nonces are Class 0 Nonces held by a given Account with greater than 0 supply \
        \ Given an <account>, a dpdc <id>, and a list of <nonces>, they can be filtered to Removable Nonces"
        r-nonces:[integer]
        r-amounts:[decimal]
    )
)
(interface DemiourgosPactOrtoFungible
    ;;
    ;;  [UR]
    ;;
    (defun UR_Konto:string (id:string))
    ;;
    ;;  [C]
    ;;
    (defun C_Issue:object{IgnisCollector.OutputCumulator}
        (
            patron:string account:string 
            name:[string] ticker:[string] decimals:[integer]
            can-upgrade:[bool] can-change-owner:[bool] can-add-special-role:[bool] can-transfer-oft-create-role:[bool]
            can-freeze:[bool] can-wipe:[bool] can-pause:[bool]
        )
    )
    (defun C_RotateOwnership:object{IgnisCollector.OutputCumulator} (id:string new-owner:string))
    (defun C_Control:object{IgnisCollector.OutputCumulator} (id:string cu:bool cco:bool casr:bool ctocr:bool cf:bool cw:bool cp:bool))
    (defun C_TogglePause:object{IgnisCollector.OutputCumulator} (id:string toggle:bool))
    ;;
    (defun C_DeployAccount (account:string id:string))
    (defun C_ToggleFreezeAccount:object{IgnisCollector.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_ToggleTransferRole:object{IgnisCollector.OutputCumulator} (id:string account:string toggle:bool))
    ;;
    (defun C_AddQuantity:object{IgnisCollector.OutputCumulator} (account:string id:string nonce:integer amount:decimal))
    (defun C_Burn:object{IgnisCollector.OutputCumulator} (account:string id:string nonce:integer amount:decimal))
    (defun C_Mint:object{IgnisCollector.OutputCumulator} (account:string id:string amount:decimal meta-data:object))
    ;;
    (defun C_WipeSlim:object{IgnisCollector.OutputCumulator} (account:string id:string nonce:integer amount:decimal))
    (defun C_WipeHeavy:object{IgnisCollector.OutputCumulator} (account:string id:string))
    (defun C_WipePure:object{IgnisCollector.OutputCumulator} (account:string id:string removable-nonces-obj:object{DpofUdc.RemovableNonces}))
    (defun C_WipeClean:object{IgnisCollector.OutputCumulator} (account:string id:string nonces:[integer]))
    ;;
    (defun C_Transmit:object{IgnisCollector.OutputCumulator} (id:string nonces:[integer] amounts:[decimal] sender:string receiver:string method:bool))
    (defun C_Transfer:object{IgnisCollector.OutputCumulator} (id:string nonces:[integer] sender:string receiver:string method:bool))
)
(module DPOF GOV
    ;;
    (implements OuronetPolicy)
    (implements BrandingUsageV7)
    (implements DemiourgosPactOrtoFungible)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPOF                   (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPOF_ADMIN)))
    (defcap GOV|DPOF_ADMIN ()               (enforce-guard GOV|MD_DPOF))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
        meta-data:[object]
    )
    ;;{2}
    (deftable DPOF|T|Properties:{DpofUdc.DPOF|Properties})          ;;Key = <DPOF-id>      
    (deftable DPOF|T|Nonces:{DpofUdc.DPOF|NonceElement})            ;;Key = <DSOF-id> + BAR + <nonce>
    (deftable DPOF|T|VerumRoles:{DpofUdc.DPOF|VerumRoles})          ;;Key = <DPOF-id>
    (deftable DPOF|T|AccountRoles:{DpofUdc.DPOF|AccountRoles})      ;;Key = <DPOF-id> + BAR + <account> 
    ;;{3}
    (defun CT_Bar ()                                                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                                                   (CT_Bar))
    (defconst OF                                                    (at 0 ["Orto-Fungible"]))
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
                (ref-DALOS:module{OuronetDalosV4} DALOS)
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
        ;;<can-pause> must be on to pause, doesnt matter for unpause
        (if pause
            (UEV_CanPauseON id)
            true
        )
        ;;Enforce Proper existing state
        (UEV_PauseState id (not pause))
    )
    (defcap DPOF|S>X_FREEZE (id:string account:string frozen:bool)
        (CAP_Owner id)
        ;;<can-freeze> must be on to freeze, doesnt matter for unfreeze
        (if frozen
            (UEV_CanFreezeON id)
            true
        )
        ;;Enforce Proper existing state
        (UEV_AccountFreezeState id account (not frozen))
    )
    (defcap DPOF|S>X_TOGGLE-TRANSFER-ROLE (id:string account:string toggle:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
            )
            ;;<DALOS> and <OUROBOROS> Accounts are irelevant for Transfer Roles, and cannot be set for
            (enforce
                (and (!= account ouroboros)(!= account dalos))
                "DALOS and OUROBOROS Smart Ouronet Accounts are immune to Transfer Roles, and cannot be set for!"
            )
            (CAP_Owner id)
            ;;<can-add-special-role> must be on to set Transfer Role, is irrelevant for unsetting
            (if toggle
                (UEV_CanAddSpecialRoleON id)
                true
            )
            ;;Enforce Proper existing state
            (UEV_AccountTransferState id account (not toggle))

        )
    )
    (defcap DPOF|S>MOVE (id:string sender:string receiver:string method:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            ;;Ownership
            (ref-DALOS::CAP_EnforceAccountOwnership sender)
            (if (and method (ref-DALOS::UR_AccountType receiver))
                (ref-DALOS::CAP_EnforceAccountOwnership receiver)
                true
            )
            ;;Transferability
            (ref-DALOS::UEV_EnforceTransferability sender receiver method)
            ;;<id> Pause State and <sender> <receiver> Frozen State
            (UEV_PauseState id false)
            (UEV_AccountFreezeState id sender false)
            (UEV_AccountFreezeState id receiver false)
            ;;Transfer Roles Check
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
                (ref-DALOS:module{OuronetDalosV4} DALOS)
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
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership client)
            (UEV_AccountAddQuantityState id client true)
            (compose-capability (DPOF|C>CREDIT client id [nonce] [amount] [{}]))
        )
    )
    (defcap DPOF|C>BURN (client:string id:string nonce:integer amount:decimal)
        @event
        (UEV_AccountBurnState id client true)
        (compose-capability (DPOF|C>DEBIT client id [nonce] [amount] false))
    )
    (defcap DPOF|C>MINT (client:string id:string amount:decimal meta-data:object)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (nonces-used:integer (UR_NoncesUsed id))
            )
            (ref-DALOS::CAP_EnforceAccountOwnership client)
            (UEV_AccountAddQuantityState id client true)
            (UEV_AccountCreateState id client true)
            (compose-capability (DPOF|C>CREDIT client id [(+ nonces-used 1)] [amount] [meta-data]))
        )
    )
    (defcap DPOF|C>WIPE-SLIM (account:string id:string nonce:integer amount:decimal)
        @event
        (UEV_SegmentationState id true)
        (compose-capability (DPOF|C>WIPE-DPOF account id [nonce] [amount]))
    )
    (defcap DPOF|C>WIPE (account:string id:string nonces:[integer])
        @event
        (compose-capability (DPOF|C>WIPE-DPOF account id nonces (UR_NoncesSupplies id nonces)))
    )
    (defcap DPOF|C>WIPE-DPOF (account:string id:string nonces:[integer] amounts:[decimal])
        ;;Nonces must be held by <account>
        (UEV_NoncesToAccount id account nonces)
        ;;Orto-Fungible is frozen on target account
        (UEV_AccountFreezeState id account true)
        ;;Orto-Fungible has <can-wipe> on
        (UEV_CanWipeON id)
        ;;Neeeded Capabilities
        (compose-capability (DPOF|C>DEBIT account id nonces amounts true))
        (compose-capability (SECURE))   ;;For Updating Supply
    )
    ;;
    (defcap DPOF|C>DEBIT (account:string id:string nonces:[integer] amounts:[decimal] wipe-mode:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
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
                            (amount:integer (at idx amounts))
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
    (defcap DPOF|C>CREDIT (account:string id:string nonces:[integer] amounts:[decimal] meta-datas:[object])
        (let
            (
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (iz-singular:bool (UC_IzSingular id nonces))
                (iz-consecutive:bool (UC_IzConsecutive id nonces))
                (l1:integer (length nonces))
                (l2:integer (length amounts))
                (l3:integer (length meta-datas))
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
        @doc "Freezes and Unfreezes an <account> for a DPOF <id>"
        @event
        (compose-capability (DPOF|S>X_FREEZE id account frozen))
        (compose-capability (SECURE))
    )
    (defcap DPOF|C>TOGGLE-TRANSFER-ROLE (id:string account:string toggle:bool)
        @doc "Toggles <role-transfer> for <id> and <account>"
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
                (meta-data:[object] (at "meta-data" td))
            )
            (UEV_SegmentationState id true)
            (compose-capability (DPOF|C>DEBIT sender id input-nonces input-amounts false))
            (compose-capability (DPOF|C>CREDIT receiver id output-nonces input-amounts meta-data))
            (compose-capability (DPOF|S>MOVE id sender receiver method))
        )
    )
    (defcap DPOF|C>TRANSFER (id:string nonces:[integer] sender:string receiver:string method:bool)
        @event
        (UEV_NoncesToAccount id sender nonces)
        (UEV_NoncesCirculating id nonces)
        (compose-capability (DPOF|S>MOVE id sender receiver method))
        (compose-capability (SECURE))
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
    (defun UC_MoveCumulator:object{IgnisCollector.OutputCumulator}
        (id:string nonces:[integer] transmit-or-transfer:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (UC_NoncesCumulator 
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
    (defun UC_WipeCumulator:object{IgnisCollector.OutputCumulator}
        (id:string removable-nonces-obj:object{DpofUdc.RemovableNonces})
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (UC_NoncesCumulator 
                id 
                (length (at "r-nonces" removable-nonces-obj))
                (ref-DALOS::UR_UsagePrice "ignis|small")
                removable-nonces-obj
            )
        )
    )
    (defun UC_NoncesCumulator:object{IgnisCollector.OutputCumulator}
        (id:string number-of-nonces:integer price-per-nonce:decimal output-obj:object)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (ref-IGNIS::IC|UDC_ConstructOutputCumulator
                (*  
                    (dec number-of-nonces)
                    price-per-nonce
                )
                (UR_Konto id)
                (ref-IGNIS::IC|URC_IsVirtualGasZero)
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
    (defun UR_R-KEYS:[string] ()
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
    (defun UR_Segmentation:bool (id:string)
        (at "segmentation" (read DPOF|T|Properties id ["segmentation"]))
    )
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
    (defun UR_NonceMetaData:object (id:string nonce:integer)
        (at "meta-data" (read DPOF|T|Nonces (UC_IdNonce id nonce) ["meta-data"]))
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
    (defun UR_NoncesMetaDatas:[object] (id:string nonces:[integer])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[object] element:integer)
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
    (defun UR_IzAccount:bool (id:string account:string)
        (let
            (
                (trial (try false (read DPOF|T|AccountRoles (UC_IdAccount id account))))
            )
            (if (= (typeof trial) "bool") false true)
        )
    )
    (defun UR_R-Frozen:bool (id:string account:string)
        (at "frozen" (read DPOF|T|AccountRoles (UC_IdAccount id account) ["frozen"]))
    )
    (defun UR_R-AddQuantity:bool (id:string account:string)
        (at "role-oft-add-quantity" (read DPOF|T|AccountRoles (UC_IdAccount id account) ["role-oft-add-quantity"]))
    )
    (defun UR_R-Burn:bool (id:string account:string)
        (at "role-oft-burn" (read DPOF|T|AccountRoles (UC_IdAccount id account) ["role-oft-burn"]))
    )
    (defun UR_R-Create:bool (id:string account:string)
        (at "role-oft-create" (read DPOF|T|AccountRoles (UC_IdAccount id account) ["role-oft-create"]))
    )
    (defun UR_R-Transfer:bool (id:string account:string)
        (at "role-transfer" (read DPOF|T|AccountRoles (UC_IdAccount id account) ["role-transfer"]))
    )
    (defun UR_AccountSupply:decimal (id:string account:string)
        (at "total-account-supply" (read DPOF|T|AccountRoles (UC_IdAccount id account) ["total-account-supply"]))
    )
    ;;
    ;;
    (defun URD_AccountNonces:[integer] (account:string dpof-id:string )
        (select DPOF|T|Nonces
            (and
                (where "id" (= "dpof-id"))
                (where "nonce-holder" (= "account"))
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
    (defun URC_Parent:string (id:string)
        @doc "Computes <dpmf> parent"
        (let
            (
                (fourth:string (drop 3 (take 4 id)))
            )
            (enforce (!= fourth BAR) "Sleeping LP Tokens not allowed for this operation")
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (first-two:string (take 2 id))
                )
                (cond
                    ((= first-two "V|") (UR_Vesting id))
                    ((= first-two "Z|") (UR_Sleeping id))
                    ((= first-two "H|") (UR_Hibernation id))
                    id
                )
            )
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_id (id:string)
        (let
            (
                (iz-id:bool (UR_IzId id))
            )
            (enforce iz-id (format "DPOF {} does not exist" [id]))
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
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
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
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
                        (ref-DALOS:module{OuronetDalosV4} DALOS)
                        (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                        (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
                        ;;
                        (sender-transfer-role:bool 
                            (fold (or) false 
                                [
                                    (UR_R-Transfer id sender)
                                    (= sender ouroboros) 
                                    (= sender dalos)
                                ]
                            )
                        )
                        (receiver-transfer-role:bool 
                            (fold (or) false 
                                [
                                    (UR_R-Transfer id receiver)
                                    (= receiver ouroboros) 
                                    (= receiver dalos)
                                ]
                            )
                        )
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
    (defun UDC_NonceElement
        (a:string b:string c:integer d:decimal e:object)
        {"holder"       : a
        ,"id"           : b
        ,"value"        : c
        ,"supply"       : d
        ,"meta-data"    : e}
    )
    (defun UDC_VerumRoles
        (a:[string] b:[string] c:[string] d:string e:[string])
        {"a-frozen"             : a
        ,"r-oft-add-quantity"   : b
        ,"r-oft-burn"           : c
        ,"r-oft-create"         : d
        ,"r-transfer"           : e}
    )
    (defun UDC_AccountRoles:object{DpofUdc.DPOF|AccountRoles}
        (a:bool b:bool c:bool d:bool e:bool f:decimal)
        {"frozen"                   : a
        ,"role-oft-add-quantity"    : b
        ,"role-oft-burn"            : c
        ,"role-oft-create"          : d
        ,"role-transfer"            : e
        ,"total-account-supply"     : f}
    )
    (defun UDC_RemovableNonces:object{DpofUdc.RemovableNonces}
        (a:[integer] b:[decimal])
        {"r-nonces"     : a
        ,"r-amounts"    : b}
    )
    (defun UDC_TransmitData
        (a:[integer] b:[decimal] c:[integer] d:[object])
        {"input-nonces"     : a
        ,"input-amounts"    : b
        ,"output-nonces"    : c
        ,"meta-data"        : d}
    )
    ;;{F4}  [CAP]
    (defun CAP_Owner (id:string)
        @doc "Enforces DPOF Token ID Ownership"
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
            (with-capability (DPOF|C>UPDATE-BRD entity-id)
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
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
            (ref-DALOS::KDA|C_CollectWT patron kda-payment false)
        )
    )
    ;;
    (defun C_Issue:object{IgnisCollector.OutputCumulator}
        (
            patron:string account:string 
            name:[string] ticker:[string] decimals:[integer]
            can-upgrade:[bool] can-change-owner:[bool] can-add-special-role:[bool] can-transfer-oft-create-role:[bool]
            can-freeze:[bool] can-wipe:[bool] can-pause:[bool]
        )
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
                        (XB_IssueFree 
                            account name ticker decimals 
                            can-upgrade can-change-owner can-add-special-role can-transfer-oft-create-role
                            can-freeze can-wipe can-pause iz-special
                        )
                    )
                )
            )
            (ref-DALOS::KDA|C_Collect patron kda-costs)
            ico
        )
    )
    (defun C_RotateOwnership:object{IgnisCollector.OutputCumulator}
        (id:string new-owner:string)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPOF|S>ROTATE-OWNERSHIP id new-owner)
                (XI_ChangeOwnership id new-owner)
                (ref-IGNIS::IC|UDC_BiggestCumulator (UR_Konto id))
            )
        )
    )
    (defun C_Control:object{IgnisCollector.OutputCumulator}
        (id:string cu:bool cco:bool casr:bool ctocr:bool cf:bool cw:bool cp:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPOF|S>CONTROL id)
                (XI_Control id cu cco casr ctocr cf cw cp)
                (ref-IGNIS::IC|UDC_MediumCumulator (UR_Konto id))
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
            (with-capability (DPOF|S>PAUSE id toggle)
                ;;Pause|Unpause <id>
                (XI_TogglePause id toggle)
                ;;Output
                (ref-IGNIS::IC|UDC_MediumCumulator (UR_Konto id))
            )
        )
    )
    ;;
    (defun C_DeployAccount (account:string id:string)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (create-role-account:string (UR_Verum4 id))
                (f:bool false)
                (role-oft-create-boolean:bool (if (= create-role-account account) true f))
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id)
            (with-default-read DPOF|T|AccountRoles (UC_IdAccount id account)
                (UDC_AccountRoles f f f role-oft-create-boolean f 0.0)
                {"frozen"                   := fz
                ,"role-oft-add-quantity"    := roaq
                ,"role-oft-burn"            := rob
                ,"role-oft-create"          := roc
                ,"role-transfer"            := rt
                ,"total-account-supply"     := tas
                }
                (write DPOF|T|AccountRoles (UC_IdAccount id account)
                    (UDC_AccountRoles fz roaq rob roc rt tas)
                )
            )
        )
    )
    (defun C_ToggleFreezeAccount:object{IgnisCollector.OutputCumulator}
        (id:string account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (verum-one:[string] (UR_Verum1 id))
                (updated-verum-one:[string] (ref-U|DALOS::UC_NewRoleList verum-one account toggle))
            )
            (with-capability (DPOF|C>FREEZE id account toggle)
                ;;Update Verum Roles
                (XI_UpdateVerum1 id updated-verum-one)
                ;;Update Account Roles
                (XI_ToggleFreezeAccount id account toggle)
                ;;Output
                (ref-IGNIS::IC|UDC_BiggestCumulator (UR_Konto id))
            )
        )
    )
    (defun C_ToggleTransferRole:object{IgnisCollector.OutputCumulator}
        (id:string account:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (verum-five:[string] (UR_Verum5 id))
                (updated-verum-five:[string] (ref-U|DALOS::UC_NewRoleList verum-five account toggle))
            )
            (with-capability (DPOF|C>TOGGLE-TRANSFER-ROLE id account toggle)
                ;;Update Verum Roles
                (XI_UpdateVerum5 id updated-verum-five)
                ;;Update Account Roles
                (XI_ToggleTransferRole id account toggle)
                ;;Output
                (ref-IGNIS::IC|UDC_BiggestCumulator (UR_Konto id))
            )
        )
    )
    ;;
    (defun C_AddQuantity:object{IgnisCollector.OutputCumulator}
        (account:string id:string nonce:integer amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (supply:decimal (UR_Supply id))
            )
            (with-capability (DPOF|C>ADD-QTY account id nonce amount)
                ;;Credit <nonce> held on <account> by <amount> 
                (XI_CreditNonces account id [nonce] [amount] [{}])
                ;;Update <id> Supply
                (XI_UpdateSupply id (+ supply amount))
                ;;Output
                (ref-IGNIS::IC|UDC_SmallCumulator (UR_Konto id))
            )
        )
    )
    (defun C_Burn:object{IgnisCollector.OutputCumulator}
        (account:string id:string nonce:integer amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (supply:decimal (UR_Supply id))
            )
            (with-capability (DPOF|C>BURN account id nonce amount)
                ;;Debit <nonce> held on <account> by <amount>
                (XI_DebitNonces account id [nonce] [amount] false)
                ;;Update <id> Supply
                (XI_UpdateSupply id (- supply amount))
                ;;Output
                (ref-IGNIS::IC|UDC_SmallCumulator (UR_Konto id))
            )
        )
    )
    (defun C_Mint:object{IgnisCollector.OutputCumulator}
        (account:string id:string amount:decimal meta-data:object)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (supply:decimal (UR_Supply id))
                (nonces-used:integer (UR_NoncesUsed id))
            )
            (with-capability (DPOF|C>MINT account id amount meta-data)
                ;;Credit <nonce> held on <account> by <amount>
                (XI_CreditNonces account id [(+ nonces-used 1)] [amount] [meta-data])
                ;;Update <id> Supply
                (XI_UpdateSupply id (+ supply amount))
                ;;Output
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators 
                    (ref-IGNIS::IC|UDC_MediumCumulator (UR_Konto id))
                    [(UR_NoncesUsed id)]
                )
            )
        )
    )
    ;;Wipes
    (defun C_WipeSlim:object{IgnisCollector.OutputCumulator}
        (account:string id:string nonce:integer amount:decimal)
        @doc "Wipes a specific DPOF <id> <nonce> on <account> by <amount> \
        \ Amount may be lower or equal to the nonce amount. \
        \ Requires <id> has <segmentation> set to true"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (supply:decimal (UR_Supply id))
            )
            (with-capability (DPOF|C>WIPE-SLIM account id nonce amount)
                ;;Debit <nonce> held on <account> by <amount>
                (XI_DebitNonces account id [nonce] [amount] true)
                ;;Update <id> Supply
                (XI_UpdateSupply id (- supply amount))
                ;;Output 2 IGNIS
                (ref-IGNIS::IC|UDC_SmallCumulator (UR_Konto id))
            )
        )
    )
    (defun C_WipeHeavy:object{IgnisCollector.OutputCumulator} (account:string id:string)
        @doc "Wipes all viable <id> Nonces of an SFT or NFT <account> \
            \ \
            \ |Heavy| reffers to the usage of expensive functions like <select> or <keys> \
            \ (that arent meant to be used in transactional context) to get the Account Nonces; \
            \ May fit in a single Transaction for Small Data Sets"
        (UEV_IMC)
        (C_WipePure account id (URDC_WipePure account id))
    )
    (defun C_WipePure:object{IgnisCollector.OutputCumulator}
        (account:string id:string removable-nonces-obj:object{DpofUdc.RemovableNonces})
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
                (sum:[decimal] (fold (+) 0.0 amounts))
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
    (defun C_WipeClean:object{IgnisCollector.OutputCumulator}
        (account:string id:string nonces:[integer])
        @doc "Wipes <id> select <nonces> of a DPOF <account>"
        (UEV_IMC)
        (C_WipePure account id
            (UDC_RemovableNonces
                nonces
                (UR_NoncesSupplies id nonces)
            )
        )
    )
    ;;Transfers
    (defun C_Transmit:object{IgnisCollector.OutputCumulator}
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
                (meta-data:[object] (UR_NoncesMetaDatas id nonces))
                (td:object{TransmitData}
                    (UDC_TransmitData nonces amounts output-nonces meta-data)
                )
            )
            (with-capability (DPOF|C>TRANSMIT id td sender receiver method)
                ;;1]Debit sender
                (XI_DebitNonces sender id nonces amounts false)
                ;;2]Credit receiver
                (XI_CreditNonces receiver id output-nonces amounts meta-data)
                ;;3]Output Costs 2 IGNIS per Nonce Transmitted
                (UC_MoveCumulator id nonces true)
            )
        )
    )
    (defun C_Transfer:object{IgnisCollector.OutputCumulator}
        (id:string nonces:[integer] sender:string receiver:string method:bool)
        @doc "Transfer DPOF <id> <nonces> from <sender> to <receiver> by changing their Ownership"
        (UEV_IMC)
        (with-capability (DPOF|C>TRANSFER id nonces sender receiver method)
            ;;1]Deploy Receiver account if it doesnt exist
            (XB_DeployAccountWNE receiver id)
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
    ;;{F7}  [X]
    (defun XB_IssueFree:object{IgnisCollector.OutputCumulator}
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
                (ref-IGNIS::IC|UDC_ConstructOutputCumulator gas-costs account trigger folded-lst)
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
                ,"can-upgrade"                  : can-upgrade
                ,"can-change-owner"             : can-change-owner
                ,"can-add-special-role"         : can-add-special-role
                ,"can-transfer-oft-create-role" : can-transfer-oft-create-role
                ;;
                ,"can-freeze"                   : can-freeze
                ,"can-wipe"                     : can-wipe
                ,"can-pause"                    : can-pause
                ;;
                ,"is-paused"                    : false
                ,"nonces-used"                  : 0
                ,"nonces-excluded"              : 0
                ;;
                ,"supply"                       : 0.0
                ;;
                ,"segmentation"                 : false
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
        )
        (require-capability (DPOF|S>CONTROL id))
        (update DPOF|T|Properties id
            {"can-upgrade"                  : can-upgrade
            ,"can-change-owner"             : can-change-owner
            ,"can-add-special-role"         : can-add-special-role
            ,"can-transfer-oft-create-role" : can-transfer-oft-create-role
            ,"can-freeze"                   : can-freeze
            ,"can-wipe"                     : can-wipe
            ,"can-pause"                    : can-pause}
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
                            (amount:integer (at idx amounts))
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
    (defun XI_CreditNonces (account:string id:string nonces:[integer] amounts:[decimal] meta-datas:[object])
        @doc "Credit a DPOF <id> <nonces> on <account> with <amounts> and <meta-datas> \
            \ Only Performs creditation, does not update supply\
            \ Designed to Process <nonces> in two variants \
            \ Either the nonce exists already, in which case length must be 1; <iz-singular> true\
            \ Or ALL the nonce dont exist, in which case the length must be greater than 1; <iz-singular> false"
        (require-capability (DPOF|C>CREDIT account id nonces amounts meta-datas))
        (let
            (
                (iz-singular:bool (UC_IzSingular id nonces))
                (iz-consecutive:bool (UC_IzConsecutive id nonces))
                (tas:decimal (UR_AccountSupply id account))
                (sum:decimal (fold (+) 0.0 amounts))
            )
            ;;Update Total Account Supply
            (XI_UpdateAccountSupply id account (+ tas sum))
            (if iz-singular
                (XI_UpdateNonceSupply id (at 0 nonces) (+ (UR_NonceSupply id (at 0 nonces)) (at 0 amounts)))
                true
            )
            (if iz-consecutive
                (do
                    ;;Deploy Account WNE
                    (XB_DeployAccountWNE account id)
                    ;;Update <nonces-used> in properties of <id>
                    (XI_UpdateNoncesUsed id (at 0 (take -1 nonces)))
                    ;;Insert New Nonces
                    (XI_InsertNewNonces account id nonces amounts meta-datas)
                )
                true
            )
        )
    )
    ;;
    ;;Pure Write/Update Functions
    ;;1]DPOF|T|Properties
    (defun XI_InsertNewId (id:string id-data:object{DpofUdc.DPOF|Properties})
        (require-capability (SECURE))
        (insert DPOF|T|Properties id id-data)
    )
    (defun XI_ChangeOwnership (id:string new-owner:string)
        (require-capability (DPOF|S>ROTATE-OWNERSHIP id new-owner))
        (write DPOF|T|Properties id
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
        (write DPOF|T|Properties id
            {"supply" : new-supply}
        )
    )
    (defun XI_UpdateNoncesUsed (id:string new-value:decimal)
        (require-capability (SECURE))
        (write DPOF|T|Properties id
            {"nonces-used" : new-value}
        )
    )
    (defun XI_IncrementNoncesExcluded (id:string)
        (require-capability (SECURE))
        (let
            (
                (excluded:integer (UR_NoncesExcluded id))
            )
            (write DPOF|T|Properties id
                {"nonces-excluded" : (+ excluded 1)}
            )
        )
    )
    ;;2]DPOF|T|Nonces
    (defun XI_InsertNewNonces (nonce-owner:string id:string nonces:[integer] amounts:[decimal] meta-datas:[object])
        (require-capability (SECURE))
        (with-capability (SECURE)
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (nonce:integer (at idx nonces))
                            (amount:integer (at idx amounts))
                            (meta-data:object (at idx meta-datas))
                        )
                        (XI_InsertNewNonce nonce-owner id nonce amount meta-data)
                    )
                )
                (enumerate 0 (- (length nonces) 1))
            )
        )
    )
    (defun XI_InsertNewNonce (nonce-owner:string id:string nonce:integer amount:decimal meta-data:object)
        (require-capability (SECURE))
        (insert DPOF|T|Nonces (UC_IdNonce id nonce)
            (UDC_NonceElement nonce-owner id nonce amount meta-data)
        )
    )
    (defun XI_UpdateNonceSupply (id:string nonce:integer new-nonce-supply:decimal)
        (require-capability (SECURE))
        (write DPOF|T|Nonces (UC_IdNonce id nonce)
            {"supply" : new-nonce-supply}
        )
    )
    (defun XI_UpdateNonceHolder (id:string nonce:integer new-nonce-holder:string)
        (require-capability (SECURE))
        (write DPOF|T|Nonces (UC_IdNonce id nonce)
            {"holder" : new-nonce-holder}
        )
    )
    ;;3]DPOF|T|VerumRoles
    (defun XI_WriteRoles (id:string verum-roles:object{DpofUdc.DPOF|VerumRoles})
        (require-capability (SECURE))
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
        (write DPOF|T|VerumRoles id
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
    (defun XI_ToggleFreezeAccount (id:string account:string toggle:bool)
        (require-capability (DPOF|S>X_FREEZE id account toggle))
        (update DPOF|T|AccountRoles (UC_IdAccount id account)
            { "frozen" : toggle}
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
        (write  DPOF|T|AccountRoles (UC_IdAccount id account)
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