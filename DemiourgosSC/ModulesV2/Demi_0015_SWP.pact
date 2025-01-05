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
    (defcap SECURE ()
        true
    )
    (defconst G-MD_SWP (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_SWP (keyset-ref-guard SWP|SC_KEY))
    (defconst SWP|INFO "SwapperInformation")
    (defconst P2 "ProductWithTwo")
    (defconst P3 "ProductWithThree")
    (defconst P4 "ProductWithFour")
    (defconst P5 "ProductWithFive")
    (defconst P6 "ProductWithSix")
    (defconst P7 "ProductWithSeven")
    (defconst S2 "StableWithTwo")
    (defconst S3 "StableWithThree")
    (defconst S4 "StableWithFour")
    (defconst S5 "StableWithFive")
    (defconst S6 "StableWithSix")
    (defconst S7 "StableWithSeven")
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

        genesis-ratio:[object{SWP|PoolTokens}]
        pool-tokens:[object{SWP|PoolTokens}]
        token-lp:string
        token-lps:[string]

        fee-lp:decimal
        fee-special:decimal
        fee-special-targets:[object{SWP|FeeSplit}]
        fee-lock:bool
        unlocks:integer

        special:bool
        governor:guard
        amplifier:decimal
    )
    (defschema SWP|PoolTokens
        token-id:string
        token-supply:decimal
    )
    (defschema SWP|FeeSplit
        target:string
        value:decimal
    )
    (defconst SWP|EMPTY-TARGET
        { "target": UTILS.BAR
        , "value": 1.0 }
    )
    (defschema SWP|PoolsSchema
        pools:[string]
    )
    ;;
    (deftable SWP|Properties:{SWP|PropertiesSchema})
    (deftable SWP|Pairs:{SWP|Schema})
    (deftable SWP|Pools:{SWP|PoolsSchema})
    
    ;;
    (defun SWP|UR_Principals:[string] ()
        (at "principals" (read SWP|Properties SWP|INFO ["principals"]))
    )
    (defun SWP|UR_LiquidBoost:bool ()
        (at "liquid-boost" (read SWP|Properties SWP|INFO ["liquid-boost"]))
    )
    ;;
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
    (defun SWP|UR_PoolTokenObject:[object{SWP|PoolTokens}] (swpair:string)
        (at "pool-tokens" (read SWP|Pairs swpair ["pool-tokens"]))
    )
    (defun SWP|UR_PoolTokens:[string] (swpair:string)
        (SWP|UC_ExtractTokens (SWP|UR_PoolTokenObject swpair))
    )
    (defun SWP|UR_PoolTokenSupplies:[decimal] (swpair:string)
        (SWP|UC_ExtractTokenSupplies (SWP|UR_PoolTokenObject swpair))
    )
    (defun SWP|UR_PoolTokenSupply (swpair:string id:string)
        (let*
            (
                (pool-tokens:[string] (SWP|UR_PoolTokens swpair))
                (pool-token-supplies:[string] (SWP|UR_PoolTokenSupplies swpair))
                (iz-on-pool:bool (contains id pool-tokens))
            )
            (enforce iz-on-pool (format "Token {} is not part of Pool {}" [id swpair]))
            (at (at 0 (UTILS.LIST|UC_Search pool-tokens id)) pool-token-supplies)
        )
    )
    (defun SWP|UR_TokenLP:string (swpair:string)
        (at "token-lp" (read SWP|Pairs swpair ["token-lp"]))
    )
    (defun SWP|UR_TokenLPS:[string] (swpair:string)
        (at "token-lps" (read SWP|Pairs swpair ["token-lps"]))
    )
    ;;
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
    (defun SWP|UR_Amplifier:decimal (swpair:string)
        (at "amplifier" (read SWP|Pairs swpair ["amplifier"]))
    )
    ;;
    (defun SWP|UR_Pools:[string] (pool-category:string)
        (at "pools" (read SWP|Pools pool-category ["pools"]))
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
    ;;need remake
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
    (defun SWP|UC_ExtractTokens:[string] (input:[object{SWP|PoolTokens}])
        (fold
            (lambda
                (acc:[string] item:object{SWP|PoolTokens})
                (UTILS.LIST|UC_AppendLast acc (at "token-id" item))
            )            
            []
            input
        )
    )
    (defun SWP|UC_ExtractTokenSupplies:[decimal] (input:[object{SWP|PoolTokens}])
        (fold
            (lambda
                (acc:[decimal] item:object{SWP|PoolTokens})
                (UTILS.LIST|UC_AppendLast acc (at "token-supply" item))
            )            
            []
            input
        )
    )
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
    ;;needs rework
    (defun SWP|UC_Swap:decimal (swpair:string input-amount:decimal a-to-b-or-b-to-a:bool)
        true
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
    (defcap SWP|X_UPDATE-SUPPLY (swpair:string id:string new-supply:decimal)
        (SWP|UEV_id swpair)
        (BASIS.DPTF-DPMF|UEV_Amount id new-supply true)
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
    (defcap SWP|X_UPDATE-AMPLIFIER (swpair:string new-amplifier:decimal)
        (let
            (
                (current-amp:decimal (SWP|UR_Amplifier swpair))
            )
            (enforce (> current-amp 0.0) "Amplifier can only be updated for Stable Pools")
            (SWP|CAP_Owner swpair)
        )
    )
    ;;[A]
    ;;Initialise Functions
    (defun SWP|A_Step01 ()
        (insert SWP|Properties SWP|INFO
            {"principals"           : [UTILS.BAR]
            ,"liquid-boost"         : true}
        )
        (insert SWP|Pools P2
            {"pools"                : [UTILS.BAR]}
        )
        (insert SWP|Pools P3
            {"pools"                : [UTILS.BAR]}
        )
        (insert SWP|Pools P4
            {"pools"                : [UTILS.BAR]}
        )
        (insert SWP|Pools P5
            {"pools"                : [UTILS.BAR]}
        )
        (insert SWP|Pools P6
            {"pools"                : [UTILS.BAR]}
        )
        (insert SWP|Pools P7
            {"pools"                : [UTILS.BAR]}
        )
        (insert SWP|Pools S2
            {"pools"                : [UTILS.BAR]}
        )
        (insert SWP|Pools S3
            {"pools"                : [UTILS.BAR]}
        )
        (insert SWP|Pools S4
            {"pools"                : [UTILS.BAR]}
        )
        (insert SWP|Pools S5
            {"pools"                : [UTILS.BAR]}
        )
        (insert SWP|Pools S6
            {"pools"                : [UTILS.BAR]}
        )
        (insert SWP|Pools S7
            {"pools"                : [UTILS.BAR]}
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
    (defun SWP|X_UpdateSupply (swpair:string id:string new-supply:decimal)
        (enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (with-capability (SWP|X_UPDATE-SUPPLY swpair id new-supply)
            (let*
                (
                    (current-pool-tokens:[object{SWP|PoolTokens}] (SWP|UR_PoolTokens swpair))
                    (pool-tokens:[string] (SWP|UC_ExtractTokens current-pool-tokens))
                    (pool-token-supplies:[decimal] (SWP|UC_ExtractTokenSupplies current-pool-tokens))
                    (id-pos:integer (at 0 (UTILS.LIST|UC_Search pool-tokens id)))
                    (iz-on-pool:bool (contains id pool-tokens))
                    (new:object{SWP|PoolTokens} { "token-id" : id, "token-supply" : new-supply})
                    (new-pool-tokens:[object{SWP|PoolTokens}] (UTILS.LIST|UC_ReplaceAt current-pool-tokens id-pos new))
                )
                (enforce iz-on-pool (format "Token {} is not part of Pool {}" [id swpair]))
                (update SWP|Pairs swpair
                    {"pool-tokens" : new-pool-tokens}
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
    (defun SWP|X_UpdateAmplifier (swpair:string new-amplifier:decimal)
        ;;(enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (with-capability (SWP|X_UPDATE-AMPLIFIER swpair new-amplifier)
            (update SWP|Pairs swpair
                {"amplifier" : new-amplifier}
            )
        )
    )
    (defun SWP|UC_LP:[string] (pool-tokens:[object{SWP|PoolTokens}] amp:decimal)
        (if (= amp -1.0)
            (SWP|UC_LpIDs pool-tokens true)
            (SWP|UC_LpIDs pool-tokens false)
        )
    )
    (defun SWP|UC_LpIDs:[string] (pool-tokens:[object{SWP|PoolTokens}] p-or-s:bool)
        (let*
            (
                (token-ids:[string] (SWP|UC_ExtractTokens pool-tokens))
                (prefix:string (if p-or-s "P" "S"))
                (u:string UTILS.BAR)
                (minus:string "-")
                (caron:string "^")
                (lp-name-elements:[string]
                    (fold
                        (lambda
                            (acc:[string] idx:integer)
                            (if (!= idx (- (length pool-tokens) 1))
                                (UTILS.LIST|UC_AppendLast acc (+ (BASIS.DPTF-DPMF|UR_Name (at idx token-ids) true) caron))
                                (UTILS.LIST|UC_AppendLast acc (BASIS.DPTF-DPMF|UR_Name (at idx token-ids) true))
                            )
                        )
                        []
                        (enumerate 0 (- (length pool-tokens) 1))
                    )
                )
                (lp-ticker-elements:[string]
                    (fold
                        (lambda
                            (acc:[string] idx:integer)
                            (if (!= idx (- (length pool-tokens) 1))
                                (UTILS.LIST|UC_AppendLast acc (+ (BASIS.DPTF-DPMF|UR_Ticker (at idx token-ids) true) minus))
                                (UTILS.LIST|UC_AppendLast acc (BASIS.DPTF-DPMF|UR_Ticker (at idx token-ids) true))
                            )
                        )
                        []
                        (enumerate 0 (- (length pool-tokens) 1))
                    )
                )
                (lp-name:string (concat [prefix u (concat lp-name-elements)]))
                (lp-ticker:string (concat [prefix u (concat lp-ticker-elements) u "LP"]))
            )
            [lp-name lp-ticker]
        )
    )
    (defun SWP|UC_Swpair:string (pool-tokens:[object{SWP|PoolTokens}] amp:decimal)
        (if (= amp -1.0)
            (SWP|UC_PoolID pool-tokens true)
            (SWP|UC_PoolID pool-tokens false)
        )
    )
    (defun SWP|UC_PoolID:string (pool-tokens:[object{SWP|PoolTokens}] p-or-s:bool)
        (let*
            (
                (token-ids:[string] (SWP|UC_ExtractTokens pool-tokens))
                (prefix:string (if p-or-s "P" "S"))
                (u:string UTILS.BAR)
                (swpair-elements:[string]
                    (fold
                        (lambda
                            (acc:[string] idx:integer)
                            (if (!= idx (- (length pool-tokens) 1))
                                (UTILS.LIST|UC_AppendLast acc (+ (at idx token-ids) u))
                                (UTILS.LIST|UC_AppendLast acc (at idx token-ids))
                            )
                        )
                        []
                        (enumerate 0 (- (length pool-tokens) 1))
                    )
                )
            )
            (concat [prefix u (concat swpair-elements)])
        )
    )
    (defun SWP|UC_Variables (n:integer what:bool)
        (let
            (
                (p2:[string] (SWP|UR_Pools P2))
                (p3:[string] (SWP|UR_Pools P3))
                (p4:[string] (SWP|UR_Pools P4))
                (p5:[string] (SWP|UR_Pools P5))
                (p6:[string] (SWP|UR_Pools P6))
                (p7:[string] (SWP|UR_Pools P7))
                (s2:[string] (SWP|UR_Pools S2))
                (s3:[string] (SWP|UR_Pools S3))
                (s4:[string] (SWP|UR_Pools S4))
                (s5:[string] (SWP|UR_Pools S5))
                (s6:[string] (SWP|UR_Pools S6))
                (s7:[string] (SWP|UR_Pools S7))
            )
            (if (= n 2)
                (if what
                    [p2 P2]
                    [s2 S2]
                )
                (if (= n 3)
                    (if what
                        [p3 P3]
                        [s3 S3]
                    )
                    (if (= n 4)
                        (if what
                            [p4 P4]
                            [s4 S4]
                        )
                        (if (= n 5)
                            (if what
                                [p5 P5]
                                [s5 S5]
                            )
                            (if (= n 6)
                                (if what
                                    [p6 P6]
                                    [s6 S6]
                                )
                                (if what
                                    [p7 P7]
                                    [s7 S7]
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    (defun SWP|X_SavePool (n:integer what:bool swpair:string)
        (require-capability (SECURE))
        (let*
            (
                (u:string UTILS.BAR)
                (vars (SWP|UC_Variables n what))
                (sp-n:[string] (at 0 vars))
                (SPN:string (at 1 vars))
            )
            (if (= sp-n [u])
                (update SWP|Pools SPN
                    {"pools" : [swpair]}
                )
                (update SWP|Pools SPN
                    {"pools" : (UTILS.LIST|UC_AppendLast sp-n swpair)}
                )
            )
        )
    )
    (defun SWP|X_InsertNew (account:string pool-tokens:[object{SWP|PoolTokens}] token-lp:string fee-lp:decimal amp:decimal)
        (enforce-guard (C_ReadPolicy "SWPM|Caller"))
        (let
            (
                (n:integer (length pool-tokens))
                (what:bool (if (= amp -1.0) true false))
                (swpair:string (SWP|UC_Swpair pool-tokens amp))
            )
            (with-capability (SECURE)
                (SWP|X_SavePool n what swpair)
            )
            (insert SWP|Pairs swpair
                {"owner-konto"                          : account
                ,"can-change-owner"                     : true
                ,"can-add"                              : false
                ,"can-swap"                             : false

                ,"genesis-ratio"                        : pool-tokens
                ,"pool-tokens"                          : pool-tokens
                ,"token-lp"                             : token-lp
                ,"token-lps"                            : [UTILS.BAR]

                ,"fee-lp"                               : fee-lp
                ,"fee-special"                          : 0.0
                ,"fee-special-targets"                  : [SWP|EMPTY-TARGET]
                ,"fee-lock"                             : false
                ,"unlocks"                              : 0

                ,"special"                              : false
                ,"governor"                             : (DALOS.DALOS|UR_AccountGuard account)
                ,"amplifier"                            : amp
                }
            )
        )
    )
    ;;
    (defun SWP|UEV_New (pool-tokens:[object{SWP|PoolTokens}] amp:decimal)
        (let
            (
                (n:integer (length pool-tokens))
            )
            (if (= n 2)
                (SWP|UEV_CheckTwo pool-tokens amp)
                (if (= n 3)
                    (SWP|UEV_CheckThree pool-tokens amp)
                    (if (= n 4)
                        (enforce (not (SWP|UEV_CheckFour pool-tokens amp)) "Pool already exists for given Tokens")
                        (if (= n 5)
                            (enforce (not (SWP|UEV_CheckFive pool-tokens amp)) "Pool already exists for given Tokens")
                            (if (= n 6)
                                (enforce (not (SWP|UEV_CheckSix pool-tokens amp)) "Pool already exists for given Tokens")
                                (enforce (not (SWP|UEV_CheckSeven pool-tokens amp)) "Pool already exists for given Tokens")
                            )
                        )
                    )
                )
            )
        )
    )
    (defun SWP|UEV_CheckTwo (pool-tokens:[object{SWP|PoolTokens}] amp:decimal)
        (let*
            (
                (e0:object{SWP|PoolTokens} (at 0 pool-tokens))
                (e1:object{SWP|PoolTokens} (at 1 pool-tokens))
                (swp1:string (SWP|UC_Swpair pool-tokens amp))
                (swp2:string (SWP|UC_Swpair [e1 e0] amp))
                (t1:bool (SWP|UEV_CheckID swp1))
                (t2:bool (SWP|UEV_CheckID swp2))
            )
            (enforce (not t1) (format "Pair {} must not exist" [swp1]))
            (enforce (not t2) (format "Pair {} must not exist" [swp2]))
        )
    )
    (defun SWP|UEV_CheckThree (pool-tokens:[object{SWP|PoolTokens}] amp:decimal)
        (let*
            (
                (e0:object{SWP|PoolTokens} (at 0 pool-tokens))
                (e1:object{SWP|PoolTokens} (at 1 pool-tokens))
                (e2:object{SWP|PoolTokens} (at 2 pool-tokens))

                (swp1:string (SWP|UC_Swpair pool-tokens amp))
                (swp2:string (SWP|UC_Swpair [e0 e2 e1] amp))
                (swp3:string (SWP|UC_Swpair [e1 e0 e2] amp))
                (swp4:string (SWP|UC_Swpair [e1 e2 e0] amp))
                (swp5:string (SWP|UC_Swpair [e2 e0 e1] amp))
                (swp6:string (SWP|UC_Swpair [e2 e1 e0] amp))

                (t1:bool (SWP|UEV_CheckID swp1))
                (t2:bool (SWP|UEV_CheckID swp2))
                (t3:bool (SWP|UEV_CheckID swp3))
                (t4:bool (SWP|UEV_CheckID swp4))
                (t5:bool (SWP|UEV_CheckID swp5))
                (t6:bool (SWP|UEV_CheckID swp6))

                (swpl:[string] [swp1 swp2 swp3 swp4 swp5 swp6])
                (tl:[bool] [t1 t2 t3 t4 t5 t6])
            )
            (map
                (lambda
                    (idx:integer)
                    (enforce (not (at idx tl)) (format "Pair {} must not exist" [(at idx swpl)]))
                )
                (enumerate 0 5)
            )
        )
    )
    (defun SWP|UEV_CheckFour:bool (pool-tokens:[object{SWP|PoolTokens}] amp:decimal)
        (let
            (
                (present-pools:[string] (if (< amp 0.0) (SWP|UR_Pools P4) (SWP|UR_Pools S4)))
                (token-ids:[string] (SWP|UC_ExtractTokens pool-tokens))
            )
            (SWP|UEV_CheckAgainstMass token-ids present-pools)
        )
    )
    (defun SWP|UEV_CheckFive:bool (pool-tokens:[object{SWP|PoolTokens}] amp:decimal)
        (let
            (
                (present-pools:[string] (if (< amp 0.0) (SWP|UR_Pools P5) (SWP|UR_Pools S5)))
                (token-ids:[string] (SWP|UC_ExtractTokens pool-tokens))
            )
            (SWP|UEV_CheckAgainstMass token-ids present-pools)
        )
    )
    (defun SWP|UEV_CheckSix:bool (pool-tokens:[object{SWP|PoolTokens}] amp:decimal)
        (let
            (
                (present-pools:[string] (if (< amp 0.0) (SWP|UR_Pools P7) (SWP|UR_Pools S7)))
                (token-ids:[string] (SWP|UC_ExtractTokens pool-tokens))
            )
            (SWP|UEV_CheckAgainstMass token-ids present-pools)
        )
    )
    (defun SWP|UEV_CheckSeven:bool (pool-tokens:[object{SWP|PoolTokens}] amp:decimal)
        (let
            (
                (present-pools:[string] (if (< amp 0.0) (SWP|UR_Pools P7) (SWP|UR_Pools S7)))
                (token-ids:[string] (SWP|UC_ExtractTokens pool-tokens))
            )
            (SWP|UEV_CheckAgainstMass token-ids present-pools)
        )
    )
    ;;
    (defun SWP|UEV_CheckAgainstMass:bool (token-ids:[string] present-pools:[string])
        (fold
            (lambda
                (acc:bool idx:integer)
                (or
                    acc
                    (SWP|UEV_CheckAgainst token-ids (SWP|UC_TokenIDs (at idx present-pools)))
                )
            )
            true
            (enumerate 0 (- (length present-pools) 1))
        )
    )
    (defun SWP|UC_TokenIDs:[string] (swpair:string)
        (drop 1 (UTILS.LIST|UC_SplitString UTILS.BAR swpair))
    )
    (defun SWP|UEV_CheckAgainst:bool (token-ids:[string] pool-tokens:[string])
        (fold
            (lambda
                (acc:bool idx:integer)
                (and acc (contains (at idx token-ids) pool-tokens))
            )
            true
            (enumerate 0 (- (length token-ids) 1))
        )

    )
    ;;
    (defun SSWP|UCC_DNext (D:decimal A:decimal X:[decimal])
        @doc "Computes Dnext: \
        \ n = (length X) \
        \ S=x1+x2+x3+... \
        \ P=x1*x2*x3*... \
        \ Dp = (D^(n+1))/(P*n^n) \
        \ Numerator = (A*n^n*S + Dp*n)*D \
        \ Denominator = (A*n^n-1)*D + (n+1)*Dp \
        \ DNext = Numerator / Denominator"
        ;;
        (let*
            (
                (prec:integer 24)
                (n:decimal (dec (length X)))
                (S:decimal (fold (+) 0.0 X))
                (P:decimal (floor (fold (*) 1.0 X) prec))
                (n1:decimal (+ 1.0 n))
                (nn:decimal (^ n n))
                (Dp:decimal (floor (/ (^ D n1) (* nn P)) prec))

                (v1:decimal (floor (fold (*) 1.0 [A nn S]) prec))
                (v2:decimal (* Dp n))
                (v3:decimal (+ v1 v2))
                (numerator:decimal (floor (* v3 D) prec))

                (v4:decimal (- (* A nn) 1.0))
                (v5:decimal (* v4 D))
                (v6:decimal (floor (* n1 Dp) prec))
                (denominator:decimal (+ v5 v6))
            )
            (floor (/ numerator denominator) prec)
        )
    )
    (defun SSWP|UCC_ComputeD:decimal (A:decimal X:[decimal])
        (let*
            (
                (output-lst:[decimal]
                    (fold
                        (lambda
                            (d-values:[decimal] idx:integer)
                            (let*
                                (
                                    (prev-d:decimal (at idx d-values))
                                    (d-value:decimal (SSWP|UCC_DNext prev-d A X))
                                )
                                (UTILS.LIST|UC_AppendLast d-values d-value)
                            )
                        )
                        [(fold (+) 0.0 X)]
                        (enumerate 0 5)
                    )
                )
            )
            (UTILS.LIST|UC_LastListElement output-lst)
        )
    )
    (defun SSWP|UCC_YNext (Y:decimal D:decimal A:decimal X:[decimal] op:integer)
        @doc "Computes Y such that the invariant remains satisfied \
        \ Sp = x1+x2+x3+ ... without the term to be computed, containing the modified input token amount \
        \ Pp = x1*x2*x3* ... without the term to be computed, containing the modified input token amount \
        \ c = (D^(n+1))/(n^n*Pp*A*n^n) \
        \ b = Sp + (D/A*n^n) \
        \ Numerator = y^2 + c \
        \ Denominator = 2*y + b - D \
        \ YNext = Numerator / Denominator "
        (let*
            (
                (prec:integer 24)
                (n:decimal (dec (length X)))
                (XXX:[decimal] (UTILS.LIST|UC_RemoveItem X (at op X)))
                (Sp:decimal (fold (+) 0.0 XXX))
                (Pp:decimal (floor (fold (*) 1.0 XXX) prec))
                (n1:decimal (+ 1.0 n))
                (nn:decimal (^ n n))
                (c:decimal (floor (/ (^ D n1) (fold (*) 1.0 [nn Pp A nn])) prec))
                (b:decimal (floor (+ Sp (/ D (* A nn))) prec))
                (Ysq:decimal (^ Y 2.0))
                (numerator:decimal (floor (+ Ysq c) prec))
                (denominator:decimal (floor (- (+ (* Y 2.0) b) D) prec))
            )
            (floor (/ numerator denominator) prec)
        )
    )

    (defun SSWP|UCC_ComputeY (A:decimal X:[decimal] input-amount:decimal ip:integer op:integer)
        (let*
            (
                (xi:decimal (at ip X))
                (xn:decimal (+ xi input-amount))
                (XX:[decimal] (UTILS.LIST|UC_ReplaceAt X ip xn))
                (NewD:decimal (SSWP|UCC_ComputeD A XX))
                (y0:decimal (+ (at op X) input-amount))
                (output-lst:[decimal]
                    (fold
                        (lambda
                            (y-values:[decimal] idx:integer)
                            (let*
                                (
                                    (prev-y:decimal (at idx y-values))
                                    (y-value:decimal (SSWP|UCC_YNext prev-y NewD A X op))
                                )
                                (UTILS.LIST|UC_AppendLast y-values y-value)
                            )
                        )
                        [y0]
                        (enumerate 0 10)
                    )
                )
            )
            (- (UTILS.LIST|UC_LastListElement output-lst) (at op X))
        )
    )
)


(create-table PoliciesTable)
(create-table SWP|Properties)
(create-table SWP|Pairs)
(create-table SWP|Pools)