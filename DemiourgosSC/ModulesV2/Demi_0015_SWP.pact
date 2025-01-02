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
    (defconst SWP|SC_NAME "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ")
    (defconst SWP|SC_KDA-NAME (create-principal SWP|GUARD))
    (defconst SWP|PBL "9G.4Bl3bJ5o1eIoBkhynF39lFdvkA3E0n8m5fBr9iG4D6Ahj3xfop72b98rr33vFFLjqaiozE1btl7lgzKcjHwjzu5GuFqvMb43v9CHHe8je3buLbHMkcAyKdEMD85yIHsb9ty58Kzyado3ho1n1mf9GzpeegMrpK9wDFteeKexdL7HHq8GF7ptD2w45IkMf2A8j4pm7E6vJ1ytCckhclD9nd3JzL2j5cyLxawnE76leKmEmFaxqnF76yyJe5Mu6yLkg2yonJa6vx6jd1kr0hdEf81o42Asr8EcCDeeqD4nAehC3w3pFDMwbln4Mbl6t55GHGephx99LJKH1ojhlMlnyC4bbJFAiyD1h6vs0o7mKAaazFG9y0vfbvM9imcs1vCMmpk2cGDAAAqH6iJe32ugHA3AECEgCvxCskw4Mfx6Cc4rx2BkmKMlxeHqyDceI6wa2qjzuyI80vKg6H6tMwEg48H0ywIMDyxteDfHav08eEJE2lljEIAc1jxLlLcosbiknAyxJvu8g7kA4oAlcio2jI8lMxp76vosd5FxpatowuFktILfyCFyHvKfcozy")
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
    (defun SWP|UEV_StringIsOnList (item:string item-lst:[string])
        (let
            (
                (iz-present:bool (contains item item-lst))
            )
            (enforce (!= item-lst [UTILS.BAR]) (format "Removal of {} from {} cannot be executed" [item item-lst]))
            (enforce iz-present (format "String {} is not present in list {}." [item item-lst]))
        )
    )
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
            { "unlocks" : -1 }
            { "unlocks" := u }
            (if (< u 0)
                false
                true
            )
        )
    )
    (defun SWP|UEV_id (swpair:string)
        (with-default-read SWP|Pairs swpair
            { "unlocks" : -1 }
            { "unlocks" := u }
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
    ;;[UC]
    (defun SWP|UC_PoolTotalFee (swpair:string)
        (let*
            (
                (lb:bool (SWP|UR_LiquidBoost))
                (current-fee-lp:decimal (SWP|UR_FeeLP swpair))
                (current-fee-special:decimal (SWP|UR_FeeSP swpair))
                (tf1:decimal (+ current-fee-lp current-fee-special))
                (tf2:decimal (+ (* current-fee-lp 2.0) current-fee-special))
            )
            (if lb
                tf2
                tf1
            )
        )
    )
    (defun SWP|UC_Swap:decimal (swpair:string input-amount:decimal a-to-b-or-b-to-a:bool)
        (let*
            (
                (a-id:string (SWP|UR_TokenA swpair))
                (b-id:string (SWP|UR_TokenB swpair))
                (a-dec:integer (BASIS.DPTF-DPMF|UR_Decimals a-id true))
                (b-dec:integer (BASIS.DPTF-DPMF|UR_Decimals b-id true))
                (r-a:decimal (SWP|UR_TokenAS swpair))
                (r-b:decimal (SWP|UR_TokenBS swpair))
                (axb:decimal (* r-a r-b))

                (f1-a:decimal (+ r-a input-amount))
                (f1-b:decimal (floor (/ axb f1-a) b-dec))
                (f2-b:decimal (+ r-b input-amount))
                (f2-a:decimal (floor (/ axb f2-b) a-dec))
            )
            (if a-to-b-or-b-to-a
                (with-capability (COMPOSE)
                    (BASIS.DPTF-DPMF|UEV_Amount a-id input-amount true)
                    (- r-b f1-b)
                )
                (with-capability (COMPOSE)
                    (BASIS.DPTF-DPMF|UEV_Amount b-id input-amount true)
                    (- r-a f2-a)
                )
            )
        )
    )
    ;;[C-Composed]
    (defcap SWP|PRINCIPAL (principal:string add-or-remove:bool)
        (compose-capability (SWP-ADMIN))
        (BASIS.DPTF-DPMF|UEV_id principal true)
        (if (not add-or-remove)
            (SWP|UEV_StringIsOnList principal (SWP|UR_Principals))
            true
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
    (defcap SWP|X_UPDATE-LP (swpair:string lp-token:string add-or-remove:bool)
        (SWP|CAP_Owner swpair)
        (BASIS.DPTF-DPMF|UEV_id lp-token true)
        (if (not add-or-remove)
            (SWP|UEV_StringIsOnList lp-token (SWP|UR_TokenLPS swpair))
            true
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
                (lb:bool (SWP|UR_LiquidBoost))
                (current-fee-lp:decimal (SWP|UR_FeeLP swpair))
                (current-fee-special:decimal (SWP|UR_FeeSP swpair))

                (tf1:decimal (+ new-fee current-fee-lp))
                (tf2:decimal (+ new-fee current-fee-special))

                (tf3:decimal (+ tf1 current-fee-lp))
                (tf4:decimal (+ tf2 new-fee))
            )
            (SWP|CAP_Owner swpair)
            (SWP|UEV_FeeLockState swpair false)
            (if lb
                (if lp-or-special
                    (SWP|UEV_PoolFee tf4)
                    (SWP|UEV_PoolFee tf3)
                )
                (if lp-or-special
                    (SWP|UEV_PoolFee tf2)
                    (SWP|UEV_PoolFee tf1)
                )
            )
        )
    )
    ;;[A]
    ;;Initialise Functions
    (defun SWP|A_Step01 ()
        (insert SWP|Properties SWP|INFO
            {"principals"           : [UTILS.BAR]
            ,"liquid-boost"         : true}
        )
    )
    (defun SWP|A_Step02 ()
        (SWP|A_UpdatePrincipal (DALOS.DALOS|UR_LiquidKadenaID) true)
        (SWP|A_UpdatePrincipal (DALOS.DALOS|UR_OuroborosID) true)
    )
    (defun SWP|A_Step03 (patron:string)
        (SWP|A_EnsurePrincipalRoles patron (DALOS.DALOS|UR_LiquidKadenaID))
        (SWP|A_EnsurePrincipalRoles patron (DALOS.DALOS|UR_OuroborosID))
    )
    ;;
    (defun SWP|A_UpdatePrincipal (principal:string add-or-remove:bool)
        (with-capability (SWP|PRINCIPAL principal add-or-remove)
            (with-read SWP|Properties SWP|INFO
                { "principals" := pp }
                (if add-or-remove
                    (if (= pp [UTILS.BAR])
                        (update SWP|Properties SWP|INFO
                            {"principals" : [principal]}
                        )
                        (update SWP|Properties SWP|INFO
                            {"principals" : (UTILS.LIST|UC_AppendLast pp principal)}
                        )
                    )
                    (if (= 1 (length pp))
                        (update SWP|Properties SWP|INFO
                            {"principals" : [UTILS.BAR]}
                        )
                        (let
                            (
                                (pp-position:integer (at 0 (UTILS.LIST|UC_Search (SWP|UR_Principals) principal)))
                            )
                            (update SWP|Properties SWP|INFO
                                {"principals" : (UTILS.LIST|UC_RemoveItem pp (at pp-position pp))}
                            )
                        )
                    )
                )
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
    (defun SWP|A_EnsurePrincipalRoles (patron:string principal:string)
        (BASIS.DPTF-DPMF|C_DeployAccount principal SWP|SC_NAME true)
        (ATSI.DPTF|C_ToggleFeeExemptionRole patron principal SWP|SC_NAME true)
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
    (defun SWP|X_UpdateLP (swpair:string lp-token:string add-or-remove:bool)
        ;;(enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (with-capability (SWP|X_UPDATE-LP swpair lp-token add-or-remove)
            (with-read SWP|Pairs swpair
                { "token-lps" := tlps}
                (if add-or-remove
                    (if (= tlps [UTILS.BAR])
                        (update SWP|Pairs swpair
                            {"token-lps" : [lp-token]}
                        )
                        (update SWP|Pairs swpair
                            {"token-lps" : (UTILS.LIST|UC_AppendLast tlps lp-token)}
                        )
                    )
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