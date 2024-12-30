(module SWP GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (SWP-ADMIN))
    )
    (defcap SWP-ADMIN ()
        (enforce-one
            "SWP Admin not satisfed"
            [
                (enforce-guard G-MD_SWP)
                (enforce-guard G-SC_SWP)
            ]
        )
    )
    (defcap COMPOSE ()
        true
    )

    (defconst G-MD_SWP (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_SWP (keyset-ref-guard SWP|SC_KEY))
    (defconst SWP|INFO "SwapperInformation")
    ;;Smart Account Parameters
    (defconst SWP|SC_KEY
        (+ UTILS.NS_USE ".dh_sc_swapper-keyset")
    )
    (defconst SWP|SC_NAME "")
    (defconst SWP|SC_KDA-NAME (create-principal SWP|GUARD))
    (defconst SWP|PBL "")
    ;;P
    (defun A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (SWP-ADMIN)
            (write PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun C_ReadPolicy:guard (policy-name:string)
        (at "policy" (read PoliciesTable policy-name ["policy"]))
    )
    (deftable PoliciesTable:{DALOS.PolicySchema})
    (defun DefinePolicies ()              
        true
    )
    ;;G
    (defcap SWP|GOV ()
        @doc "Swapper Module Governor Capability for its Smart DALOS Account"
        true
    )
    (defun SWP|SetGovernor (patron:string)
        (DALOS.DALOS|C_RotateGovernor
            patron
            SWP|SC_NAME
            (create-capability-guard (SWP|GOV))
        )
    )
    (defcap SWP|NATIVE-AUTOMATIC ()
        @doc "Capability needed for auto management of the <kadena-konto> associated with the Swapper Smart DALOS Account"
        true
    )
    (defconst SWP|GUARD (create-capability-guard (SWP|NATIVE-AUTOMATIC)))
    ;;SWP
    (defschema SWP|PropertiesSchema
        principals:[string]
        liquid-boost:bool
    )
    (defschema SWP|Schema
        @doc "Key = <token-a-id> + UTILS.BAR + <token-b-id>"
        owner-konto:string
        can-change-owner:bool
        can-add:bool
        can-swap:bool

        token-a:string
        token-b:string
        token-lp:string
        token-lps:[string]

        a-init:decimal
        b-init:decimal
        token-a-supply:decimal
        token-b-supply:decimal

        fee-lp:decimal
        fee-special:decimal
        fee-special-targets:[object{SWP|FeeSplit}]
        fee-lock:bool
        unlocks:integer

        special:bool
        governor:guard
    )
    (defschema SWP|FeeSplit
        target:string
        value:decimal
    )
    (defconst SWP|EMPTY-TARGET
        { "target": UTILS.BAR
        , "value": 1.0 }
    )
    (deftable SWP|Properties:{SWP|PropertiesSchema})
    (deftable SWP|Pairs:{SWP|Schema})
    ;;
    (defun SWP|UR_Principals:[string] ()
        (at "principals" (read SWP|Properties SWP|INFO ["principals"]))
    )
    (defun SWP|UR_LiquidBoost:bool ()
        (at "liquid-boost" (read SWP|Properties SWP|INFO ["liquid-boost"]))
    )
    ;;;;
    (defun SWP|UR_OwnerKonto:string (swpair:string)
        (at "owner-konto" (read SWP|Pairs swpair ["owner-konto"]))
    )
    (defun SWP|UR_CanChangeOwner:bool (swpair:string)
        (at "can-change-owner" (read SWP|Pairs swpair ["can-change-owner"]))
    )
    (defun SWP|UR_CanAdd:bool (swpair:string)
        (at "can-add" (read SWP|Pairs swpair ["can-add"]))
    )
    (defun SWP|UR_CanSwap:bool (swpair:string)
        (at "can-swap" (read SWP|Pairs swpair ["can-swap"]))
    )
    ;;
    (defun SWP|UR_TokenA:string (swpair:string)
        (at "token-a" (read SWP|Pairs swpair ["token-a"]))
    )
    (defun SWP|UR_TokenB:string (swpair:string)
        (at "token-b" (read SWP|Pairs swpair ["token-b"]))
    )
    (defun SWP|UR_TokenLP:string (swpair:string)
        (at "token-lp" (read SWP|Pairs swpair ["token-lp"]))
    )
    (defun SWP|UR_TokenLPS:[string] (swpair:string)
        (at "token-lps" (read SWP|Pairs swpair ["token-lps"]))
    )
    ;;
    (defun SWP|UR_TokenAS:decimal (swpair:string)
        (at "token-a-supply" (read SWP|Pairs swpair ["token-a-supply"]))
    )
    (defun SWP|UR_TokenBS:decimal (swpair:string)
        (at "token-b-supply" (read SWP|Pairs swpair ["token-b-supply"]))
    )
    (defun SWP|UR_AInit:decimal (swpair:string)
        (at "a-init" (read SWP|Pairs swpair ["a-init"]))
    )
    (defun SWP|UR_BInit:decimal (swpair:string)
        (at "b-init" (read SWP|Pairs swpair ["b-init"]))
    )
    ;;
    (defun SWP|UR_FeeLP:decimal (swpair:string)
        (at "fee-lp" (read SWP|Pairs swpair ["fee-lp"]))
    )
    (defun SWP|UR_FeeSP:decimal (swpair:string)
        (at "fee-special" (read SWP|Pairs swpair ["fee-special"]))
    )
    (defun SWP|UR_FeeSPT:[object{SWP|FeeSplit}] (swpair:string)
        (at "fee-special-targets" (read SWP|Pairs swpair ["fee-special-targets"]))
    )
    (defun SWP|UR_FeeLock:bool (swpair:string)
        (at "fee-lock" (read SWP|Pairs swpair ["fee-lock"]))
    )
    (defun SWP|UR_FeeUnlocks:integer (swpair:string)
        (at "fee-unlocks" (read SWP|Pairs swpair ["fee-unlocks"]))
    )
    ;;
    (defun SWP|UR_Special:bool (swpair:string)
        (at "special" (read SWP|Pairs swpair ["special"]))
    )
    (defun SWP|UR_Governor:guard (swpair:string)
        (at "governor" (read SWP|Pairs swpair ["governor"]))
    )
    ;;[C-Simple]
    (defun SWP|UEV_New (token-a:string token-b:string)
        (let*
            (
                (a-with-b:string (concat [token-a UTILS.BAR token-b]))
                (b-with-a:string (concat [token-b UTILS.BAR token-a]))
                (t1:bool (SWP|UEV_CheckID a-with-b))
                (t2:bool (SWP|UEV_CheckID b-with-a))
            )
            (enforce (not (or t1 t2)) (format "New Swap Pair with {} and {} cannot be created" [token-a token-b]))
        )
    )
    (defun SWP|UEV_CheckID:bool (swpair:string)
        (with-default-read SWP|Pairs swpair
            { "fee-unlocks" : -1 }
            { "fee-unlocks" := u }
            (if (< u 0)
                false
                true
            )
        )
    )
    (defun SWP|UEV_id (swpair:string)
        (with-default-read SWP|Pairs swpair
            { "fee-unlocks" : -1 }
            { "fee-unlocks" := u }
            (enforce
                (>= u 0)
                (format "SWP-Pair {} does not exist." [swpair])
            )
        )
    )
    (defun SWP|CAP_Owner (swpair:string)
        (DALOS.DALOS|CAP_EnforceAccountOwnership (SWP|UR_OwnerKonto swpair))
    )
    (defcap SWP|CF|OWNER (swpair:string)
        (SWP|CAP_Owner swpair)
    )
    (defun SWP|UEV_CanChangeOwnerON (swpair:string)
        (SWP|UEV_id swpair)
        (let
            (
                (x:bool (SWP|UR_CanChangeOwner swpair))
            )
            (enforce (= x true) (format "SWP Pair {} ownership cannot be changed" [swpair]))
        )
    )
    (defun SWP|UEV_FeeLockState (swpair:string state:bool)
        (let
            (
                (x:bool (SWP|UR_FeeLock swpair))
            )
            (enforce (= x state) (format "Fee-lock for SWP Pair {} must be set to {} for this operation" [swpair state]))
        )
    )
    (defun SWP|UEV_PoolFee (fee:decimal)
        (enforce
            (= (floor fee UTILS.FEE_PRECISION) fee)
            (format "SWP Pool Fee amount of {} is invalid decimal wise" [fee])
        )
        (enforce (and (>= fee 0.0001) (<= fee 999.9999)) (format "SWP Pool Fee amount of {} is invalid size wise" [fee]))
    )
    ;;[C-Composed]
    (defcap SWP|PRINCIPALS (principals:[string])
        (compose-capability (SWP-ADMIN))
        (map
            (lambda
                (principal-id:string)
                (BASIS.DPTF-DPMF|UEV_id principal-id true)
            )
            principals
        )
    )
    (defcap SWP|LQBOOST (new-boost-variable:bool)
        (compose-capability (SWP-ADMIN))
        (let
            (
                (lqb:bool (SWP|UR_LiquidBoost))
            )
            (enforce (!= new-boost-variable lqb))
        )
    )
    (defcap SWP|X_OWNERSHIP_CHANGE (swpair:string new-owner:string)
        (DALOS.DALOS|UEV_SenderWithReceiver (SWP|UR_OwnerKonto swpair) new-owner)
        (DALOS.DALOS|UEV_EnforceAccountExists new-owner)
        (SWP|CAP_Owner swpair)
        (SWP|UEV_CanChangeOwnerON swpair)
    )
    (defcap SWP|X_MODIFY_CAN_CHANGE (swpair:string new-boolean:bool)
        (let
            (
                (current:bool (SWP|UR_CanChangeOwner swpair))
            )
            (enforce (!= current new-boolean) "Similar boolean cannot be used <can-change-owner>")
            (SWP|CAP_Owner swpair)
        )
    )
    (defcap SWP|X_ADD-OR-SWAP (swpair:string toggle:bool add-or-swap:bool)
        (let
            (
                (add:bool (SWP|UR_CanAdd swpair))
                (swap:bool (SWP|UR_CanSwap swpair))
            )
            (if add-or-swap
                (enforce (!= add toggle) "Similar boolean cannot be used for <can-add> or <can-swap>")
                (enforce (!= swap toggle) "Similar boolean cannot be used for <can-add> or <can-swap>")
            )
            (SWP|CAP_Owner swpair)
        )
    )
    (defcap SWP|X_TOGGLE_FEE-LOCK (swpair:string toggle:bool)
        (SWP|CAP_Owner swpair)
        (SWP|UEV_FeeLockState swpair (not toggle))
    )
    (defcap SWP|X_ADD-LP (swpair:string lp-token:string)
        (SWP|CAP_Owner swpair)
        (BASIS.DPTF-DPMF|UEV_id lp-token true)
    )
    (defcap SWP|X_REMOVE-LP (swpair:string lp-token:string)
        (let*
            (
                (tlps:[string] (SWP|UR_TokenLPS swpair))
                (iz-present:bool (contains lp-token tlps))
            )
            (enforce (!= tlps [UTILS.BAR]) "No LPs to remove")
            (enforce iz-present "LP not in the LP List")
            (SWP|CAP_Owner swpair)
            (BASIS.DPTF-DPMF|UEV_id lp-token true)
        ) 
    )
    (defcap SWP|X_UPDATE-SUPPLY (swpair:string new-supply:decimal a-or-b:bool)
        (SWP|UEV_id swpair)
        (let
            (
                (token-a:string (SWP|UR_TokenA swpair))
                (token-b:string (SWP|UR_TokenB swpair))
            )
            (if a-or-b
                (BASIS.DPTF-DPMF|UEV_Amount token-a new-supply true)
                (BASIS.DPTF-DPMF|UEV_Amount token-b new-supply true)
            )
        )
    )
    (defcap SWP|X_UPDATE-FEE (swpair:string new-fee:decimal lp-or-special:bool)
        (let*
            (
                (current-fee-lp:decimal (SWP|UR_FeeLP swpair))
                (current-fee-special:decimal (SWP|UR_FeeSP swpair))
                (tf1:decimal (+ new-fee current-fee-lp))
                (tf2:decimal (+ new-fee current-fee-special))
            )
            (SWP|CAP_Owner swpair)
            (SWP|UEV_FeeLockState swpair false)
            (if lp-or-special
                (SWP|UEV_PoolFee tf2)
                (SWP|UEV_PoolFee tf1)
            )
            
        )
    )
    ;;[A]
    (defun SWP|A_Initialise (patron:string)
        (let*
            (
                (dlk-id:string (DALOS.DALOS|UR_LiquidKadenaID))
                (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                (principals:[string] [dlk-id ouro-id])
            )
            (insert SWP|Properties SWP|INFO
                {"principals"           : principals
                ,"liquid-boost"         : true}
            )
            (map
                (lambda
                    (id:string)
                    (with-capability (COMPOSE)
                        (BASIS.DPTF-DPMF|C_DeployAccount id SWP|SC_NAME true)
                        (ATSI.DPTF|C_ToggleFeeExemptionRole patron id SWP|SC_NAME true)
                    )
                )
                principals
            )
        )
    )
    (defun SWP|A_UpdatePrincipals (principals:[string])
        (with-capability (SWP|PRINCIPALS principals)
            (update SWP|Properties SWP|INFO
                {"principals" : principals}
            )
        )
    )
    (defun SWP|A_UpdateLiquidBoost (new-boost-variable:bool)
        (with-capability (SWP|LQBOOST new-boost-variable)
            (update SWP|Properties SWP|INFO
                {"liquid-boost" : new-boost-variable}
            )
        )
    )
    ;;[X]
    (defun SWP|X_ChangeOwnership (swpair:string new-owner:string)
        (enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (with-capability (SWP|X_OWNERSHIP_CHANGE swpair new-owner)
            (update SWP|Pairs swpair
                {"owner-konto"                      : new-owner}
            )
        )
    )
    (defun SWP|X_ModifyCanChangeOwner (swpair:string new-boolean:bool)
        (enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (with-capability (SWP|X_MODIFY_CAN_CHANGE swpair new-boolean)
            (update SWP|Pairs swpair
                {"can-change-owner"                 : new-boolean}
            )
        )    
    )
    (defun SWP|X_CanAddOrSwapToggle (swpair:string toggle:bool add-or-swap:bool)
        (with-capability (SWP|X_ADD-OR-SWAP swpair toggle add-or-swap)
            (if add-or-swap
                (update SWP|Pairs swpair
                    {"can-add"                      : toggle}
                )
                (update SWP|Pairs swpair
                    {"can-swap"                     : toggle}
                )
            )
        )
    )
    (defun SWP|X_ToggleFeeLock:[decimal] (swpair:string toggle:bool)
        (enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (with-capability (SWP|X_TOGGLE_FEE-LOCK swpair toggle)
            (update SWP|Pairs swpair
                { "fee-lock" : toggle}
            )
            (if (= toggle true)
                [0.0 0.0]
                (UTILS.ATS|UC_UnlockPrice (SWP|UR_FeeUnlocks swpair))
            )
        )
    )
    (defun SWP|X_IncrementFeeUnlocks (swpair:string)
        (enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (with-read SWP|Pairs swpair
            { "unlocks" := u }
            (update SWP|Pairs swpair
                {"unlocks" : (+ u 1)}
            )
        )
    )
    (defun SWP|X_AddLP (swpair:string lp-token:string)
        ;;(enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (with-capability (SWP|X_ADD-LP swpair lp-token)
            (with-read SWP|Pairs swpair
                { "token-lps" := tlps}
                (if (= tlps [UTILS.BAR])
                    (update SWP|Pairs swpair
                        {"token-lps" : [lp-token]}
                    )
                    (update SWP|Pairs swpair
                        {"token-lps" : (UTILS.LIST|UC_AppendLast tlps lp-token)}
                    )
                )
            )
        )
    )
    (defun SWP|X_RemoveLP (swpair:string lp-token:string)
        ;;(enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (with-capability (SWP|X_REMOVE-LP swpair lp-token)
            (with-read SWP|Pairs swpair
                { "token-lps" := tlps}
                (if (= 1 (length tlps))
                    (update SWP|Pairs swpair
                        {"token-lps" : [UTILS.BAR]}
                    )
                    (let
                        (
                            (lp-token-position:integer (at 0 (UTILS.LIST|UC_Search (SWP|UR_TokenLPS swpair) lp-token)))
                        )
                        (update SWP|Pairs swpair
                            {"token-lps" : (UTILS.LIST|UC_RemoveItem tlps (at lp-token-position tlps))}
                        )
                    )
                )
            )
        )
    )
    (defun SWP|X_UpdateSupply (swpair:string new-supply:decimal a-or-b:bool)
        (enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (with-capability (SWP|X_UPDATE-SUPPLY swpair new-supply a-or-b)
            (if a-or-b
                (update SWP|Pairs swpair
                    {"token-a-supply"                 : new-supply}
                )
                (update SWP|Pairs swpair
                    {"token-b-supply"                 : new-supply}
                )
            )
        )
    )
    (defun SWP|X_UpdateFee (swpair:string new-fee:decimal lp-or-special:bool)
        ;;(enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (with-capability (SWP|X_UPDATE-FEE swpair new-fee lp-or-special)
            (if lp-or-special
                (update SWP|Pairs swpair
                    {"fee-lp"                         : new-fee}
                )
                (update SWP|Pairs swpair
                    {"fee-special"                    : new-fee}
                )
            )
            
        )
    )
    (defun SWP|X_UpdateSpecialFeeTargets (swpair:string targets:[object{SWP|FeeSplit}])
        ;;(enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (with-capability (SWP|CF|OWNER swpair)
            (update SWP|Pairs swpair
                {"fee-special-targets"                : targets}
            )
        )
    )
    (defun SWP|X_ToggleSpecialMode (swpair:string)
        ;;(enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (with-capability (SWP|CF|OWNER swpair)
            (with-read SWP|Pairs swpair
                { "special" := s}
                (update SWP|Pairs swpair
                    {"special" : (not s)}
                )
            )
        )
    )
    (defun SWP|X_UpdateGovernor (swpair:string new-governor:guard)
        ;;(enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (with-capability (SWP|CF|OWNER swpair)
            (update SWP|Pairs swpair
                {"governor" : new-governor}
            )
        )
    )
    (defun SWP|X_InsertNewSwapPair (account:string token-a:string token-b:string token-lp:string a-init:decimal b-init:decimal fee-lp:decimal)
        (enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (insert SWP|Pairs (concat [token-a UTILS.BAR token-b])
            {"owner-konto"                          : account
            ,"can-change-owner"                     : true
            ,"can-add"                              : false
            ,"can-swap"                             : false

            ,"token-a"                              : token-a
            ,"token-b"                              : token-b
            ,"token-lp"                             : token-lp
            ,"token-lps"                            : [UTILS.BAR]

            ,"a-init"                               : a-init
            ,"b-init"                               : b-init
            ,"token-a-supply"                       : 0.0
            ,"token-b-supply"                       : 0.0

            ,"fee-lp"                               : fee-lp
            ,"fee-special"                          : 0.0
            ,"fee-special-targets"                  : [SWP|EMPTY-TARGET]
            ,"fee-lock"                             : false
            ,"unlocks"                              : 0

            ,"special"                              : false
            ,"governor"                             : (DALOS.DALOS|UR_AccountGuard account)
            }
        )
    )
)

(create-table PoliciesTable)
(create-table SWP|Properties)
(create-table SWP|Pairs)