;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module SWP GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_SWP            (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_SWP            (keyset-ref-guard SWP|SC_KEY))

    (defconst SWP|SC_KEY            (+ UTILS.NS_USE ".dh_sc_swapper-keyset"))
    (defconst SWP|SC_NAME           "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ")
    (defconst SWP|SC_KDA-NAME       (create-principal SWP|GUARD))
    (defconst SWP|GUARD             (create-capability-guard (SWP|NATIVE-AUTOMATIC)))
    (defconst SWP|PBL               "9G.4Bl3bJ5o1eIoBkhynF39lFdvkA3E0n8m5fBr9iG4D6Ahj3xfop72b98rr33vFFLjqaiozE1btl7lgzKcjHwjzu5GuFqvMb43v9CHHe8je3buLbHMkcAyKdEMD85yIHsb9ty58Kzyado3ho1n1mf9GzpeegMrpK9wDFteeKexdL7HHq8GF7ptD2w45IkMf2A8j4pm7E6vJ1ytCckhclD9nd3JzL2j5cyLxawnE76leKmEmFaxqnF76yyJe5Mu6yLkg2yonJa6vx6jd1kr0hdEf81o42Asr8EcCDeeqD4nAehC3w3pFDMwbln4Mbl6t55GHGephx99LJKH1ojhlMlnyC4bbJFAiyD1h6vs0o7mKAaazFG9y0vfbvM9imcs1vCMmpk2cGDAAAqH6iJe32ugHA3AECEgCvxCskw4Mfx6Cc4rx2BkmKMlxeHqyDceI6wa2qjzuyI80vKg6H6tMwEg48H0ywIMDyxteDfHav08eEJE2lljEIAc1jxLlLcosbiknAyxJvu8g7kA4oAlcio2jI8lMxp76vosd5FxpatowuFktILfyCFyHvKfcozy")
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|SWP_ADMIN))
    )
    (defcap GOV|SWP_ADMIN ()
        (enforce-one
            "SWP Swapper Admin not satisfed"
            [
                (enforce-guard GOV|MD_SWP)
                (enforce-guard GOV|SC_SWP)
            ]
        )
    )
    (defcap SWP|GOV ()
        @doc "Governor Capability for the Autostake Smart DALOS Account"
        true
    )
    (defcap SWP|NATIVE-AUTOMATIC ()
        @doc "Autonomic management of <kadena-konto> of SWAPPER Smart Account"
        true
    )
    ;;{G3}
    (defun SWP|SetGovernor (patron:string)
        (DALOS.DALOS|C_RotateGovernor
            patron
            SWP|SC_NAME
            (UTILS.GUARD|UEV_Any
                [
                    (create-capability-guard (SWP|GOV))
                    (P|UR "SWPI|RemoteSwapGovernor")
                    (P|UR "SWPL|RemoteSwapGovernor")
                    (P|UR "SWPS|RemoteSwapGovernor")
                ]
            )
        )
    )
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|SWP_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()              
        true
    )
    ;;
    ;;{1}
    (defschema SWP|PropertiesSchema
        principals:[string]
        liquid-boost:bool
    )
    (defschema SWP|PairsSchema
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
    (defschema SWP|PoolsSchema
        pools:[string]
    )
    ;;{2}
    (deftable SWP|Properties:{SWP|PropertiesSchema})
    (deftable SWP|Pairs:{SWP|PairsSchema})
    (deftable SWP|Pools:{SWP|PoolsSchema})
    ;;{3}
    (defconst SWP|INFO "SwapperInformation")
    (defconst P2 "P2")
    (defconst P3 "P3")
    (defconst P4 "P4")
    (defconst P5 "P5")
    (defconst P6 "P6")
    (defconst P7 "P7")
    (defconst S2 "S2")
    (defconst S3 "S3")
    (defconst S4 "S4")
    (defconst S5 "S5")
    (defconst S6 "S6")
    (defconst S7 "S7")
    (defconst SWP|EMPTY-TARGET
        { "target": UTILS.BAR
        , "value": 1.0 }
    )
    ;;
    ;;{4}
    (defcap SECURE ()
        true
    )
    ;;{5}
    (defcap SWP|S>RT_OWN (swpair:string new-owner:string)
        @event
        (DALOS.DALOS|UEV_SenderWithReceiver (SWP|UR_OwnerKonto swpair) new-owner)
        (DALOS.DALOS|UEV_EnforceAccountExists new-owner)
        (SWP|CAP_Owner swpair)
        (SWP|UEV_CanChangeOwnerON swpair)
    )
    (defcap SWP|S>RT_CAN-CHANGE (swpair:string new-boolean:bool)
        @event
        (let
            (
                (current:bool (SWP|UR_CanChangeOwner swpair))
            )
            (enforce (!= current new-boolean) "Similar boolean cannot be used <can-change-owner>")
            (SWP|CAP_Owner swpair)
        )
    )
    (defcap SWP|S>ADD-OR-SWAP (swpair:string toggle:bool add-or-swap:bool)
        @event
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
    (defcap SWP|S>TG_FEE-LOCK (swpair:string toggle:bool)
        @event
        (SWP|CAP_Owner swpair)
        (SWP|UEV_FeeLockState swpair (not toggle))
    )
    (defcap SWP|S>UPDATE-LP (swpair:string lp-token:string add-or-remove:bool)
        @event
        (DPTF.DPTF|UEV_id lp-token)
        (SWP|CAP_Owner swpair)
        (if (not add-or-remove)
            (SWP|UEV_StringIsOnList lp-token (SWP|UR_TokenLPS swpair))
            true
        )
    )
    (defcap SWP|S>UPDATE-SUPPLIES (swpair:string new-supplies:[decimal])
        (SWP|UEV_id swpair)
        (let*
            (
                (pool-tokens:[string] (SWP|UR_PoolTokens swpair))
                (l0:integer (length pool-tokens))
                (l1:integer (length new-supplies))
                (lengths:[integer] [l0 l1])
            )
            (UTILS.UTILS|UEV_EnforceUniformIntegerList lengths)
            (map
                (lambda 
                    (idx:integer)
                    (if (> (at idx new-supplies) 0.0)
                        (DPTF.DPTF|UEV_Amount (at idx pool-tokens) (at idx new-supplies))
                        true
                    )
                )
                (enumerate 0 (- l0 1))
            )
        )
    )
    (defcap SWP|S>UPDATE-SUPPLY (swpair:string id:string new-supply:decimal)
        (DPTF.DPTF|UEV_Amount id new-supply)
        (SWP|UEV_id swpair)
    )
    (defcap SWP|S>UPDATE-FEE (swpair:string new-fee:decimal lp-or-special:bool)
        @event
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
    (defcap SWP|S>UPDATE-AMPLIFIER (swpair:string new-amplifier:decimal)
        @event
        (SWP|CAP_Owner swpair)
        (let
            (
                (current-amp:decimal (SWP|UR_Amplifier swpair))
            )
            (enforce (> current-amp 0.0) "Amplifier can only be updated for Stable Pools")
        )
    )
    ;;{6}
    (defcap SWP|F>OWNER (swpair:string)
        (SWP|CAP_Owner swpair)
    )
    ;;{7}
    (defcap SWP|C>PRINCIPAL (principal:string add-or-remove:bool)
        @event
        (DPTF.DPTF|UEV_id principal)
        (if (not add-or-remove)
            (SWP|UEV_StringIsOnList principal (SWP|UR_Principals))
            true
        )
        (compose-capability (GOV|SWP_ADMIN))
    )
    (defcap SWP|C>LQBOOST (new-boost-variable:bool)
        @event
        (let
            (
                (lqb:bool (SWP|UR_LiquidBoost))
            )
            (enforce (!= new-boost-variable lqb))
        )
        (compose-capability (GOV|SWP_ADMIN))
    )
    (defcap SPW|C>UPDATE_SPECIAL-FEE-TARGETS ()
        @event
        (compose-capability (SWP|F>OWNER))
    )
    (defcap SPW|C>TG_SPECIAL-MODE ()
        @event
        (compose-capability (SWP|F>OWNER))
    )
    (defcap SPW|C>RT_GOV ()
        @event
        (compose-capability (SWP|F>OWNER))
    )
    ;;
    ;;{8}
    (defun SWP|CAP_Owner (swpair:string)
        (DALOS.DALOS|CAP_EnforceAccountOwnership (SWP|UR_OwnerKonto swpair))
    )
    ;;{9}
    ;;{10}
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
    (defun SWP|UEV_StringIsOnList (item:string item-lst:[string])
        (let
            (
                (iz-present:bool (contains item item-lst))
            )
            (enforce (!= item-lst [UTILS.BAR]) (format "Removal of {} from {} cannot be executed" [item item-lst]))
            (enforce iz-present (format "String {} is not present in list {}." [item item-lst]))
        )
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
    (defun SWP|UEV_New (t-ids:[string] amp:decimal)
        (let
            (
                (n:integer (length t-ids))
                (SP3:[string] (if (= amp -1.0) (SWP|UR_Pools P3) (SWP|UR_Pools S3)))
                (SP4:[string] (if (= amp -1.0) (SWP|UR_Pools P4) (SWP|UR_Pools S4)))
                (SP5:[string] (if (= amp -1.0) (SWP|UR_Pools P5) (SWP|UR_Pools S5)))
                (SP6:[string] (if (= amp -1.0) (SWP|UR_Pools P6) (SWP|UR_Pools S6)))
                (SP7:[string] (if (= amp -1.0) (SWP|UR_Pools P7) (SWP|UR_Pools S7)))
                (msg:string "Pool already exists for given Tokens!")
            )
            (cond
                ((= n 2) (SWP|UEV_CheckTwo t-ids amp))
                ((= n 3) (enforce (not (SWP|UEV_CheckAgainstMass t-ids SP3)) msg))
                ((= n 4) (enforce (not (SWP|UEV_CheckAgainstMass t-ids SP4)) msg))
                ((= n 5) (enforce (not (SWP|UEV_CheckAgainstMass t-ids SP5)) msg))
                ((= n 6) (enforce (not (SWP|UEV_CheckAgainstMass t-ids SP6)) msg))
                ((= n 7) (enforce (not (SWP|UEV_CheckAgainstMass t-ids SP7)) msg))
                true
            )
        )
    )
    (defun SWP|UEV_CheckTwo (token-ids:[string] amp:decimal)
        (let*
            (
                (e0:string (at 0 token-ids))
                (e1:string (at 1 token-ids))
                (swp1:string (SUT.SWP|UC_Swpair token-ids amp))
                (swp2:string (SUT.SWP|UC_Swpair [e1 e0] amp))
                (t1:bool (SWP|URC_CheckID swp1))
                (t2:bool (SWP|URC_CheckID swp2))
            )
            (enforce (not t1) (format "Pair {} must not exist" [swp1]))
            (enforce (not t2) (format "Pair {} must not exist" [swp2]))
        )
    )
    (defun SWP|UEV_CheckAgainstMass:bool (token-ids:[string] present-pools:[string])
        (fold
            (lambda
                (acc:bool idx:integer)
                (or
                    acc
                    (SWP|UEV_CheckAgainst token-ids (SWP|UC_SplitTokenIDs (at idx present-pools)))
                )
            )
            false
            (enumerate 0 (- (length present-pools) 1))
        )
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
    ;;{11}
    (defun SWP|UC_SplitTokenIDs:[string] (swpair:string)
        (drop 1 (UTILS.LIST|UC_SplitString UTILS.BAR swpair))
    )
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
    ;;{12}
    (defun SWP|UR_Principals:[string] ()
        (at "principals" (read SWP|Properties SWP|INFO ["principals"]))
    )
    (defun SWP|UR_LiquidBoost:bool ()
        (at "liquid-boost" (read SWP|Properties SWP|INFO ["liquid-boost"]))
    )
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
    (defun SWP|UR_GenesisRatio:[object{SWP|PoolTokens}] (swpair:string)
        (at "genesis-ratio" (read SWP|Pairs swpair ["genesis-ratio"]))
    )
    (defun SWP|UR_PoolTokenObject:[object{SWP|PoolTokens}] (swpair:string)
        (at "pool-tokens" (read SWP|Pairs swpair ["pool-tokens"]))
    )
    (defun SWP|UR_TokenLP:string (swpair:string)
        (at "token-lp" (read SWP|Pairs swpair ["token-lp"]))
    )
    (defun SWP|UR_TokenLPS:[string] (swpair:string)
        (at "token-lps" (read SWP|Pairs swpair ["token-lps"]))
    )
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

    (defun SWP|UR_Special:bool (swpair:string)
        (at "special" (read SWP|Pairs swpair ["special"]))
    )
    (defun SWP|UR_Governor:guard (swpair:string)
        (at "governor" (read SWP|Pairs swpair ["governor"]))
    )
    (defun SWP|UR_Amplifier:decimal (swpair:string)
        (at "amplifier" (read SWP|Pairs swpair ["amplifier"]))
    )
    (defun SWP|UR_Pools:[string] (pool-category:string)
        (at "pools" (read SWP|Pools pool-category ["pools"]))
    )
    (defun SWP|UR_PoolTokens:[string] (swpair:string)
        (SWP|UC_ExtractTokens (SWP|UR_PoolTokenObject swpair))
    )
    (defun SWP|UR_PoolTokenSupplies:[decimal] (swpair:string)
        (SWP|UC_ExtractTokenSupplies (SWP|UR_PoolTokenObject swpair))
    )
    (defun SWP|UR_PoolGenesisSupplies:[decimal] (swpair:string)
        (SWP|UC_ExtractTokenSupplies (SWP|UR_GenesisRatio swpair))
    )
    (defun SWP|UR_PoolTokenPosition:integer (swpair:string id:string)
        (let*
            (
                (pool-tokens:[string] (SWP|UR_PoolTokens swpair))
                (iz-on-pool:bool (contains id pool-tokens))
            )
            (enforce iz-on-pool (format "Token {} is not part of Pool {}" [id swpair]))
            (at 0 (UTILS.LIST|UC_Search pool-tokens id))
        )
    )
    (defun SWP|UR_PoolTokenSupply:decimal (swpair:string id:string)
        (at (SWP|UR_PoolTokenPosition swpair id) (SWP|UR_PoolTokenSupplies swpair))
    )
    (defun SWP|UR_PoolTokenPrecisions:[integer] (swpair:string)
        (let*
            (
                (pool-token-ids:[string] (SWP|UR_PoolTokens swpair))
                (l:integer (length pool-token-ids))
                (Xp:[integer]
                    (fold
                        (lambda
                            (acc:[integer] idx:integer)
                            (UTILS.LIST|UC_AppendLast 
                                acc 
                                (DPTF.DPTF|UR_Decimals (at idx pool-token-ids))
                            )
                        )
                        []
                        (enumerate 0 (- (length pool-token-ids) 1))
                    )
                )
            )
            Xp
        )
    )
    ;;{13}
    (defun SWP|URC_CheckID:bool (swpair:string)
        (with-default-read SWP|Pairs swpair
            { "unlocks" : -1 }
            { "unlocks" := u }
            (if (< u 0)
                false
                true
            )
        )
    )
    (defun SWP|URC_PoolTotalFee:decimal (swpair:string)
        @doc "Computes Total Pool Fee in Promille"
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
    (defun SWP|URC_LiquidityFee:decimal (swpair:string)
        (let
            (
                (pool-type:string (take 1 swpair))
            )
            (if (= "P" pool-type)
                0.0
                (let
                    (
                        (n:decimal (dec (length (SWP|UR_PoolTokens swpair))))
                        (swap-fee:decimal (SWP|URC_PoolTotalFee swpair))
                    )
                    (floor (/ (* n swap-fee) (* 4.0 (- n 1.0))) UTILS.FEE_PRECISION)
                )
            )
        )
    )
    (defun SWP|URC_Swpairs:[string] ()
        @doc "Outputs all current Existing Swpairs. Cheaper than <keys SWP|Pairs>"
        (let
            (
                (p2:[string] (SWP|UR_Pools SWP.P2))
                (p3:[string] (SWP|UR_Pools SWP.P3))
                (p4:[string] (SWP|UR_Pools SWP.P4))
                (p5:[string] (SWP|UR_Pools SWP.P5))
                (p6:[string] (SWP|UR_Pools SWP.P6))
                (p7:[string] (SWP|UR_Pools SWP.P7))
                (s2:[string] (SWP|UR_Pools SWP.S2))
                (s3:[string] (SWP|UR_Pools SWP.S3))
                (s4:[string] (SWP|UR_Pools SWP.S4))
                (s5:[string] (SWP|UR_Pools SWP.S5))
                (s6:[string] (SWP|UR_Pools SWP.S6))
                (s7:[string] (SWP|UR_Pools SWP.S7))
            )
            (fold (+) [] (UTILS.LIST|UC_RemoveItem [p2 p3 p4 p5 p6 p7 s2 s3 s4 s5 s6 s7] [UTILS.BAR]))
        )
    )
    ;;
    ;;{14}
    (defun SWP|A_UpdatePrincipal (principal:string add-or-remove:bool)
        (with-capability (SWP|C>PRINCIPAL principal add-or-remove)
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
        (with-capability (SWP|C>LQBOOST new-boost-variable)
            (update SWP|Properties SWP|INFO
                {"liquid-boost" : new-boost-variable}
            )
        )
    )
    ;;{15}
    ;;{16}
    (defun SWP|X_ChangeOwnership (swpair:string new-owner:string)
        (enforce-guard (P|UR "SWPM|Caller"))
        (with-capability (SWP|S>RT_OWN swpair new-owner)
            (update SWP|Pairs swpair
                {"owner-konto"                      : new-owner}
            )
        )
    )
    (defun SWP|X_ModifyCanChangeOwner (swpair:string new-boolean:bool)
        (enforce-guard (P|UR "SWPM|Caller"))
        (with-capability (SWP|S>RT_CAN-CHANGE swpair new-boolean)
            (update SWP|Pairs swpair
                {"can-change-owner"                 : new-boolean}
            )
        )    
    )
    (defun SWP|X_CanAddOrSwapToggle (swpair:string toggle:bool add-or-swap:bool)
        (enforce-guard (P|UR "SWPM|Caller"))
        (with-capability (SWP|S>ADD-OR-SWAP swpair toggle add-or-swap)
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
        (enforce-guard (P|UR "SWPM|Caller"))
        (with-capability (SWP|S>TG_FEE-LOCK swpair toggle)
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
        (enforce-guard (P|UR "SWPM|Caller"))
        (with-read SWP|Pairs swpair
            { "unlocks" := u }
            (update SWP|Pairs swpair
                {"unlocks" : (+ u 1)}
            )
        )
    )
    (defun SWP|X_UpdateLP (swpair:string lp-token:string add-or-remove:bool)
        (enforce-guard (P|UR "SWPM|Caller"))
        (with-capability (SWP|S>UPDATE-LP swpair lp-token add-or-remove)
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
    (defun SWP|X_UpdateSupplies (swpair:string new-supplies:[decimal])
        (enforce-guard (P|UR "SWPL|Caller"))
        (with-capability (SWP|S>UPDATE-SUPPLIES swpair new-supplies)
            (let*
                (
                    (pool-tokens:[string] (SWP|UR_PoolTokens swpair))
                    (new-pool-tokens:[object{SWP|PoolTokens}] 
                        (zip (lambda (x:string y:decimal) { "token-id": x, "token-supply": y }) pool-tokens new-supplies)
                    )
                )
                (update SWP|Pairs swpair
                    {"pool-tokens" : new-pool-tokens}
                )
            )
        )
    )
    (defun SWP|X_UpdateSupply (swpair:string id:string new-supply:decimal)
        ;(enforce-guard (P|UR "SWPM|Caller"))
        (with-capability (SWP|S>UPDATE-SUPPLY swpair id new-supply)
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
        (enforce-guard (P|UR "SWPM|Caller"))
        (with-capability (SWP|S>UPDATE-FEE swpair new-fee lp-or-special)
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
        (enforce-guard (P|UR "SWPM|Caller"))
        (with-capability (SPW|C>UPDATE_SPECIAL-FEE-TARGETS swpair)
            (update SWP|Pairs swpair
                {"fee-special-targets"                : targets}
            )
        )
    )
    (defun SWP|X_ToggleSpecialMode (swpair:string)
        (enforce-guard (P|UR "SWPM|Caller"))
        (with-capability (SPW|C>TG_SPECIAL-MODE swpair)
            (with-read SWP|Pairs swpair
                { "special" := s}
                (update SWP|Pairs swpair
                    {"special" : (not s)}
                )
            )
        )
    )
    (defun SWP|X_UpdateGovernor (swpair:string new-governor:guard)
        (enforce-guard (P|UR "SWPM|Caller"))
        (with-capability (SPW|C>RT_GOV swpair)
            (update SWP|Pairs swpair
                {"governor" : new-governor}
            )
        )
    )
    (defun SWP|X_UpdateAmplifier (swpair:string new-amplifier:decimal)
        (enforce-guard (P|UR "SWPM|Caller"))
        (with-capability (SWP|S>UPDATE-AMPLIFIER swpair new-amplifier)
            (update SWP|Pairs swpair
                {"amplifier" : new-amplifier}
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
        (enforce-guard (P|UR "SWPI|Caller"))
        (let*
            (
                (n:integer (length pool-tokens))
                (what:bool (if (= amp -1.0) true false))
                (pool-token-ids:[string] (SWP|UC_ExtractTokens pool-tokens))
                (swpair:string (SUT.SWP|UC_Swpair pool-token-ids amp))
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
)

(create-table P|T)
(create-table SWP|Properties)
(create-table SWP|Pairs)
(create-table SWP|Pools)
