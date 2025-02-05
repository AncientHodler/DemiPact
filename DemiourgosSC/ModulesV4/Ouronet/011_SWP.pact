(module SWP GOV
    ;;
    (implements OuronetPolicy)
    (implements Swapper)
    ;;{G1}
    (defconst GOV|MD_SWP            (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_SWP            (keyset-ref-guard SWP|SC_KEY))
    ;;
    (defconst SWP|SC_KEY            (GOV|SwapKey))
    (defconst SWP|SC_NAME           (GOV|SWP|SC_NAME))
    (defconst SWP|SC_KDA-NAME       (GOV|SWP|SC_KDA-NAME))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|SWP_ADMIN)))
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
        @doc "Governor Capability for the Swapper Smart DALOS Account"
        true
    )
    (defcap SWP|NATIVE-AUTOMATIC ()
        @doc "Autonomic management of <kadena-konto> of SWAPPER Smart Account"
        true
    )
    ;;
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|SwapKey ()           (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|SwapKey)))
    (defun GOV|SWP|SC_NAME ()       (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|SWP|SC_NAME)))
    (defun GOV|SWP|SC_KDA-NAME ()   (create-principal (create-capability-guard (SWP|NATIVE-AUTOMATIC))))
    (defun SWP|SetGovernor (patron:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-U|G:module{OuronetGuards} U|G)
            )
            (ref-DALOS::C_RotateGovernor
                patron
                SWP|SC_NAME
                (ref-U|G::UEV_Any
                    [
                        (create-capability-guard (SWP|GOV))
                        (P|UR "SWPU|RemoteAtsGov")
                    ]
                )
            )
        )
    )
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
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
        spawn-limit:decimal
        inactive-limit:decimal
    )
    (defschema SWP|PairsSchema
        @doc "Key = <token-a-id> + UTILS.BAR + <token-b-id>"
        owner-konto:string
        can-change-owner:bool
        can-add:bool
        can-swap:bool
        genesis-weights:[decimal]
        weights:[decimal]
        genesis-ratio:[object{Swapper.PoolTokens}]
        pool-tokens:[object{Swapper.PoolTokens}]
        token-lp:string
        token-lps:[string]
        fee-lp:decimal
        fee-special:decimal
        fee-special-targets:[object{Swapper.FeeSplit}]
        fee-lock:bool
        unlocks:integer
        special:bool
        governor:guard
        amplifier:decimal
        primality:bool
    )
    (defschema SWP|PoolsSchema
        pools:[string]
    )
    (defschema SWPT|TracerSchema
        links:[object{Swapper.Edges}]
    )
    ;;{2}
    (deftable SWP|Properties:{SWP|PropertiesSchema})
    (deftable SWP|Pairs:{SWP|PairsSchema})
    (deftable SWP|Pools:{SWP|PoolsSchema})
    (deftable SWPT|Tracer:{SWPT|TracerSchema})
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    (defconst SWP|INFO              "SwapperInformation")
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
    (defconst NLE [NLEO])
    (defconst NLEO
        { "principal" : BAR
        , "swpairs"   : [BAR]}
    )
    (defconst SWP|EMPTY-TARGET
        { "target": BAR
        , "value": 1 }
    )
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    (defcap SWP|S>RT_OWN (swpair:string new-owner:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::UEV_SenderWithReceiver (UR_OwnerKonto swpair) new-owner)
            (ref-DALOS::UEV_EnforceAccountExists new-owner)
            (UEV_CanChangeOwnerON swpair)
            (CAP_Owner swpair)
        )
    )
    (defcap SWP|S>RT_CAN-CHANGE (swpair:string new-boolean:bool)
        @event
        (let
            (
                (current:bool (UR_CanChangeOwner swpair))
            )
            (enforce (!= current new-boolean) "Similar boolean unallowed for <can-change-owner>")
            (CAP_Owner swpair)
        )
    )
    (defcap SWP|S>ADD-OR-SWAP (swpair:string toggle:bool add-or-swap:bool)
        @event
        (let
            (
                (add:bool (UR_CanAdd swpair))
                (swap:bool (UR_CanSwap swpair))
            )
            (if add-or-swap
                (enforce (!= add toggle) "Similar boolean unallowed for <can-add> or <can-swap>")
                (enforce (!= swap toggle) "Similar boolean unallowed for <can-add> or <can-swap>")
            )
            (CAP_Owner swpair)
        )
    )
    (defcap SWP|S>WEIGHTS (swpair:string new-weights:[decimal])
        @event
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (pp:string (take 1 swpair))
                (ws:decimal (fold (+) 0.0 new-weights))
            )
            (map
                (lambda
                    (w:decimal)
                    (= (floor w ref-U|CT::CT_FEE_PRECISION) w)
                )
                new-weights
            )
            (enforce (= pp "W") "Changing weights available only for weighted Pools")
            (enforce (= ws 1.0) "All weights must add to exactl 1.0")
            (CAP_Owner swpair)
        )
    )
    (defcap SWP|S>UPDATE-LP (swpair:string lp-token:string add-or-remove:bool)
        @event
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DPTF::UEV_id lp-token)
            (CAP_Owner swpair)
            (if (not add-or-remove)
                (ref-U|LST::UEV_StringPresence lp-token (UR_TokenLPS swpair))
                true
            )
        )
    )
    (defcap SWP|S>UPDATE-SUPPLIES (swpair:string new-supplies:[decimal])
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (pool-tokens:[string] (UR_PoolTokens swpair))
                (l0:integer (length pool-tokens))
                (l1:integer (length new-supplies))
                (lengths:[integer] [l0 l1])
            )
            (UEV_id swpair)
            (ref-U|INT::UEV_UniformList lengths)
            (map
                (lambda 
                    (idx:integer)
                    (if (> (at idx new-supplies) 0.0)
                        (ref-DPTF::UEV_Amount (at idx pool-tokens) (at idx new-supplies))
                        true
                    )
                )
                (enumerate 0 (- l0 1))
            )
        )
    )
    (defcap SWP|S>UPDATE-SUPPLY (swpair:string id:string new-supply:decimal)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DPTF::UEV_Amount id new-supply)
            (UEV_id swpair)
        )
    )
    (defcap SWP|S>UPDATE-FEE (swpair:string new-fee:decimal )
        @event
        (UEV_FeeLockState swpair false)
        (UEV_PoolFee new-fee)
        (CAP_Owner swpair)
    )
    (defcap SWP|S>UPDATE-AMPLIFIER (swpair:string new-amplifier:decimal)
        @event
        (CAP_Owner swpair)
        (let
            (
                (current-amp:decimal (UR_Amplifier swpair))
            )
            (enforce (> current-amp 0.0) "Amplifier can only be updated for Stable Pools")
        )
    )
    (defcap SPW|S>UPDATE_SPECIAL-FEE-TARGETS (swpair:string targets:[object{Swapper.FeeSplit}])
        @event
        (CAP_Owner swpair)
        (map
            (lambda
                (obj:object{Swapper.FeeSplit})
                (UEV_FeeSplit obj)
            )
            targets
        )
    )
    (defcap SWP|S>TG_SPECIAL-MODE (swpair:string)
        @event
        (CAP_Owner swpair)
    )
    (defcap SPW|S>RT_GOV (swpair:string)
        @event
        (CAP_Owner swpair)
    )
    ;{C3}
    ;{C4}
    (defcap SWP|C>PRINCIPAL (principal:string add-or-remove:bool)
        @event
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DPTF::UEV_id principal)
            (if (not add-or-remove)
                (ref-U|LST::UEV_StringPresence principal (UR_Principals))
                true
            )
            (compose-capability (GOV|SWP_ADMIN))
        )
    )
    (defcap SWP|C>LQBOOST (new-boost-variable:bool)
        @event
        (let
            (
                (lqb:bool (UR_LiquidBoost))
            )
            (enforce (!= new-boost-variable lqb))
        )
        (compose-capability (GOV|SWP_ADMIN))
    )
    (defcap SWP|C>LIMIT ()
        @event
        (compose-capability (GOV|SWP_ADMIN))
    )
    (defcap SWPI|C>ISSUE (account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        @event
        (let*
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (l1:integer (length pool-tokens))
                (l2:integer (length weights))
                (ws:decimal (fold (+) 0.0 weights))
                (principals:[string] (UR_Principals))
                (pt-ids:[string] (UC_ExtractTokens pool-tokens))
                (ptte:[string]
                    (if (= amp -1.0)
                        (drop 1 pt-ids)
                        pt-ids
                    )
                )
                (iz-principal:bool (contains (at 0 pt-ids) principals))
            )
            (UEV_PoolFee fee-lp)
            (UEV_New pt-ids weights amp)
            (map
                (lambda
                    (id:string)
                    (ref-DPTF::CAP_Owner id)
                )
                ptte
            )
            (map
                (lambda
                    (w:decimal)
                    (= (floor w (ref-U|CT::CT_FEE_PRECISION)) w)
                )
                weights
            )
            (enforce-one
                "Invalid Weight Values"
                [
                    (enforce (= ws 1.0) "Weights must add to exactly 1.0")
                    (enforce (= ws (dec l1)) "Weights must all be 1.0")
                ]
            )
            (if (= amp -1.0)
                (enforce iz-principal "1st Token is not a Principal")
                true
            )
            (enforce (or (= amp -1.0) (>= amp 1.0)) "Invalid amp value")
            (enforce (and (>= l1 2) (<= l1 7)) "2 - 7 Tokens can be used to create a Swap Pair")
            (enforce (= l1 l2) "Number of weigths does not concide with the pool-tokens Number")
        )
        (compose-capability (SECURE))
        (compose-capability (SWP|GOV))
        (if p
            (compose-capability (GOV|SWP_ADMIN))
            true
        )
    )
    (defcap SWP|C>TG_FEE-LOCK (swpair:string toggle:bool)
        @event
        (UEV_FeeLockState swpair (not toggle))
        (CAP_Owner swpair)
        (compose-capability (SECURE))
    )
    ;;{FC}
    (defun UC_ExtractTokens:[string] (input:[object{Swapper.PoolTokens}])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[string] item:object{Swapper.PoolTokens})
                    (ref-U|LST::UC_AppL acc (at "token-id" item))
                )            
                []
                input
            )
        )
    )
    (defun UC_ExtractTokenSupplies:[decimal] (input:[object{Swapper.PoolTokens}])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[decimal] item:object{Swapper.PoolTokens})
                    (ref-U|LST::UC_AppL acc (at "token-supply" item))
                )            
                []
                input
            )
        )
    )
    (defun UC_CustomSpecialFeeTargets:[string] (io:[object{Swapper.FeeSplit}])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[string] idx:integer)
                    (ref-U|LST::UC_AppL
                        acc
                        (at "target" (at idx io))
                    )
                )
                []
                (enumerate 0 (- (length io) 1))
            )
        )
    )
    (defun UC_CustomSpecialFeeTargetsProportions:[decimal] (io:[object{Swapper.FeeSplit}])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[decimal] idx:integer)
                    (ref-U|LST::UC_AppL
                        acc
                        (dec (at "value" (at idx io)))
                    )
                )
                []
                (enumerate 0 (- (length io) 1))
            )
        )
    )
    (defun SWPT|UC_PSwpairsFTO:[string] (traces:[object{Swapper.Edges}] id:string principal:string)
        @doc "Principal Swpairs From Trace Object: given a trace object, id and principal, output the stored swpairs\
        \ UTILS.BAR can be used as principal, returning swpairs that contain no principals. \
        \ Swpairs that contain no principals, can only be stable swap pairs."
        (SWPT|UEV_IdAsPrincipal principal true)
        (let*
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (principals-from-traces:[string] (SWPT|UC_PrincipalsFromTraces traces))
                (search:[integer] (ref-U|LST::UC_Search principals-from-traces principal))
            )
            (if (!= (length search) 0)
                (at "swpairs" (at (at 0 search) traces))
                [BAR]
            )
        )
    )
    (defun SWPT|UC_PrincipalsFromTraces:[string] (traces:[object{Swapper.Edges}])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[string] idx:integer)
                    (ref-U|LST::UC_AppendLast 
                        acc
                        (at "principal" (at idx traces))
                    )
                )
                []
                (enumerate 0 (- (length traces) 1))
            )
        )
    )
    ;;{F0}
    (defun UR_Principals:[string] ()
        (at "principals" (read SWP|Properties SWP|INFO ["principals"]))
    )
    (defun UR_LiquidBoost:bool ()
        (at "liquid-boost" (read SWP|Properties SWP|INFO ["liquid-boost"]))
    )
    (defun UR_SpawnLimit:decimal ()
        (at "spawn-limit" (read SWP|Properties SWP|INFO ["spawn-limit"]))
    )
    (defun UR_InactiveLimit:decimal ()
        (at "inactive-limit" (read SWP|Properties SWP|INFO ["inactive-limit"]))
    )
    (defun UR_OwnerKonto:string (swpair:string)
        (at "owner-konto" (read SWP|Pairs swpair ["owner-konto"]))
    )
    (defun UR_CanChangeOwner:bool (swpair:string)
        (at "can-change-owner" (read SWP|Pairs swpair ["can-change-owner"]))
    )
    (defun UR_CanAdd:bool (swpair:string)
        (at "can-add" (read SWP|Pairs swpair ["can-add"]))
    )
    (defun UR_CanSwap:bool (swpair:string)
        (at "can-swap" (read SWP|Pairs swpair ["can-swap"]))
    )
    (defun UR_GenesisWeigths:[decimal] (swpair:string)
        (at "genesis-weights" (read SWP|Pairs swpair ["genesis-weights"]))
    )
    (defun UR_Weigths:[decimal] (swpair:string)
        (at "weights" (read SWP|Pairs swpair ["weights"]))
    )
    (defun UR_GenesisRatio:[object{Swapper.PoolTokens}] (swpair:string)
        (at "genesis-ratio" (read SWP|Pairs swpair ["genesis-ratio"]))
    )
    (defun UR_PoolTokenObject:[object{Swapper.PoolTokens}] (swpair:string)
        (at "pool-tokens" (read SWP|Pairs swpair ["pool-tokens"]))
    )
    (defun UR_TokenLP:string (swpair:string)
        (at "token-lp" (read SWP|Pairs swpair ["token-lp"]))
    )
    (defun UR_TokenLPS:[string] (swpair:string)
        (at "token-lps" (read SWP|Pairs swpair ["token-lps"]))
    )
    (defun UR_FeeLP:decimal (swpair:string)
        (at "fee-lp" (read SWP|Pairs swpair ["fee-lp"]))
    )
    (defun UR_FeeSP:decimal (swpair:string)
        (at "fee-special" (read SWP|Pairs swpair ["fee-special"]))
    )
    (defun UR_FeeSPT:[object{Swapper.FeeSplit}] (swpair:string)
        (at "fee-special-targets" (read SWP|Pairs swpair ["fee-special-targets"]))
    )
    (defun UR_FeeLock:bool (swpair:string)
        (at "fee-lock" (read SWP|Pairs swpair ["fee-lock"]))
    )
    (defun UR_FeeUnlocks:integer (swpair:string)
        (at "fee-unlocks" (read SWP|Pairs swpair ["fee-unlocks"]))
    )
    (defun UR_Special:bool (swpair:string)
        (at "special" (read SWP|Pairs swpair ["special"]))
    )
    (defun UR_Governor:guard (swpair:string)
        (at "governor" (read SWP|Pairs swpair ["governor"]))
    )
    (defun UR_Amplifier:decimal (swpair:string)
        (at "amplifier" (read SWP|Pairs swpair ["amplifier"]))
    )
    (defun UR_Primality:bool (swpair:string)
        (at "primality" (read SWP|Pairs swpair ["primality"]))
    )
    (defun UR_Pools:[string] (pool-category:string)
        (at "pools" (read SWP|Pools pool-category ["pools"]))
    )
    (defun UR_PoolTokens:[string] (swpair:string)
        (UC_ExtractTokens (UR_PoolTokenObject swpair))
    )
    (defun UR_PoolTokenSupplies:[decimal] (swpair:string)
        (UC_ExtractTokenSupplies (UR_PoolTokenObject swpair))
    )
    (defun UR_PoolGenesisSupplies:[decimal] (swpair:string)
        (UC_ExtractTokenSupplies (UR_GenesisRatio swpair))
    )
    (defun UR_PoolTokenPosition:integer (swpair:string id:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (pool-tokens:[string] (UR_PoolTokens swpair))
                (iz-on-pool:bool (contains id pool-tokens))
            )
            (enforce iz-on-pool (format "Token {} is not part of Pool {}" [id swpair]))
            (at 0 (ref-U|LST::UC_Search pool-tokens id))
        )
    )
    (defun UR_PoolTokenSupply:decimal (swpair:string id:string)
        (at (UR_PoolTokenPosition swpair id) (UR_PoolTokenSupplies swpair))
    )
    (defun UR_PoolTokenPrecisions:[integer] (swpair:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (pool-token-ids:[string] (UR_PoolTokens swpair))
                (l:integer (length pool-token-ids))
                (Xp:[integer]
                    (fold
                        (lambda
                            (acc:[integer] idx:integer)
                            (ref-U|LST::UC_AppL
                                acc 
                                (ref-DPTF::UR_Decimals (at idx pool-token-ids))
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
    (defun UR_SpecialFeeTargets:[string] (swpair:string)
        (UC_CustomSpecialFeeTargets (UR_FeeSPT swpair))
    )
    (defun UR_SpecialFeeTargetsProportions:[decimal] (swpair:string)
        (UC_CustomSpecialFeeTargetsProportions (UR_FeeSPT swpair))
    )
    ;;{F1}
    (defun URC_CheckID:bool (swpair:string)
        (with-default-read SWP|Pairs swpair
            { "unlocks" : -1 }
            { "unlocks" := u }
            (if (< u 0)
                false
                true
            )
        )
    )
    (defun URC_PoolTotalFee:decimal (swpair:string)
        @doc "Computes Total Pool Fee in Promille"
        (let
            (
                (lb:bool (UR_LiquidBoost))
                (current-fee-lp:decimal (UR_FeeLP swpair))
                (current-fee-special:decimal (UR_FeeSP swpair))
                (tf1:decimal (+ current-fee-lp current-fee-special))
                (tf2:decimal (+ (* current-fee-lp 2.0) current-fee-special))
            )
            (if lb
                tf2
                tf1
            )
        )
    )
    (defun URC_LiquidityFee:decimal (swpair:string)
        (let
            (
                (pool-type:string (take 1 swpair))
            )
            (if (= "P" pool-type)
                0.0
                (let
                    (
                        (ref-U|CT:module{OuronetConstants} U|CT)
                        (n:decimal (dec (length (UR_PoolTokens swpair))))
                        (swap-fee:decimal (URC_PoolTotalFee swpair))
                    )
                    (floor (/ (* n swap-fee) (* 4.0 (- n 1.0))) ref-U|CT::CT_FEE_PRECISION)
                )
            )
        )
    )
    (defun URC_Swpairs:[string] ()
        @doc "Outputs all current Existing Swpairs. Cheaper than <keys SWP|Pairs>"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (pl:[string] [P2 P3 P4 P5 P6 P7 S2 S3 S4 S5 S6 S7])
                (fl:[[string]]
                    (fold
                        (lambda
                            (acc:[[string]] idx:integer)
                            (ref-U|LST::UC_AppL
                                acc
                                (UR_Pools (at idx pl))
                            )
                        )
                        []
                        (enumerate 0 (- (length pl) 1))
                    )
                )
            )
            (fold (+) [] (ref-U|LST::UC_RemoveItem fl [BAR]))
        )
    )
    (defun SWPT|URC_PathTracer:[object{Swapper.Edges}] (old-path-tracer:[object{Swapper.Edges}] id:string swpair:string)
        "Computes a new Path-tracer object list, given <old-path-tracer> object, token-id <id> and Swap-Pair <swpair>"
        (let*
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (swpair-tokens:[string] (UR_PoolTokens swpair))
                (has-principals:bool (SWPT|URC_ContainsPrincipals swpair))
                (current-element-zero-swpairs:[string] (SWPT|UC_PSwpairsFTO old-path-tracer id BAR))
                (new-element-zero-swpairs:[string]
                    (if (= current-element-zero-swpairs [BAR])
                        (if has-principals
                            [BAR]
                            [swpair]
                        )
                        (if has-principals
                            current-element-zero-swpairs
                            (ref-U|LST::UC_AppL current-element-zero-swpairs swpair)
                        )
                    )
                )
                (element-zero:object{Swapper.Edges}
                    { "principal" : BAR , "swpairs" : new-element-zero-swpairs}
                )
                (principals:[string] (UR_Principals))
            )
            (fold
                (lambda
                    (acc:[object{Swapper.Edges}] idx:integer)
                    (ref-U|LST::UC_AppL 
                        acc
                        (let*
                            (
                                (current-element-swpairs:[string] (SWPT|UC_PSwpairsFTO old-path-tracer id (at idx principals)))
                                (lopt:integer (length old-path-tracer))
                                (iz-principal-on-swpair:bool (contains (at idx principals) swpair-tokens))
                                (check:bool (and (!= id (at idx principals)) iz-principal-on-swpair))
                                (swpairs-to-add:[string]
                                    (if (= lopt 1)
                                        (if check
                                            [swpair]
                                            [BAR]
                                        )
                                        (if check
                                            (ref-U|LST::UC_AppL current-element-swpairs swpair)
                                            current-element-swpairs
                                        )
                                    )
                                )
                                (filtered-swpairs-to-add:[string]
                                    (if (= swpairs-to-add [BAR])
                                        swpairs-to-add
                                        (if (= (at 0 swpairs-to-add) BAR)
                                            (drop 1 swpairs-to-add)
                                            swpairs-to-add
                                        )
                                    )
                                )
                            )
                            {
                                "principal" : (at idx principals),
                                "swpairs"   : filtered-swpairs-to-add
                            }
                        )
                    )
                )
                [element-zero]
                (enumerate 0 (- (length principals) 1))
            )
        )
    )
    (defun SWPT|URC_ContainsPrincipals:bool (swpair:string)
        (let
            (
                (swpair-tokens:[string] (UR_PoolTokens swpair))
                (principals:[string] (UR_Principals))
            )
            (fold
                (lambda
                    (acc:bool idx:integer)
                    (or
                        acc
                        (contains (at idx swpair-tokens) principals)
                    )
                )
                false
                (enumerate 0 (- (length swpair-tokens) 1))
            )
        )
    )
    (defun SWPI|URC_LpComposer:[string] (pool-tokens:[object{Swapper.PoolTokens}] weights:[decimal] amp:decimal)
        (let*
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (pool-token-ids:[string] (UC_ExtractTokens pool-tokens))
                (l:integer (length pool-token-ids))
                (pool-token-names:[string]
                    (fold
                        (lambda
                            (acc:[string] idx:integer)
                            (ref-U|LST::UC_AppL
                                acc 
                                (ref-DPTF::UR_Name (at idx pool-token-ids))
                            )
                        )
                        []
                        (enumerate 0 (- l 1))
                    )
                )
                (pool-token-tickers:[string]
                    (fold
                        (lambda
                            (acc:[string] idx:integer)
                            (ref-U|LST::UC_AppL
                                acc 
                                (ref-DPTF::UR_Ticker (at idx pool-token-ids))
                            )
                        )
                        []
                        (enumerate 0 (- l 1))
                    )
                )
            )
            (ref-U|SWP::UC_LpID pool-token-names pool-token-tickers weights amp)
        )
    )
    ;;{F2}
    (defun UEV_FeeSplit (input:object{Swapper.FeeSplit})
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (tg:string (at "target" input))
                (v:integer (at "value" input))
            )
            (ref-DALOS::UEV_EnforceAccountExists tg)
            (enforce (and (>= v 1)(<= v 100000)) "Invalid Splitting Value in Split Object")
        )
    )
    (defun UEV_id (swpair:string)
        (with-default-read SWP|Pairs swpair
            { "unlocks" : -1 }
            { "unlocks" := u }
            (enforce
                (>= u 0)
                (format "SWP-Pair {} does not exist." [swpair])
            )
        )
    )
    (defun UEV_CanChangeOwnerON (swpair:string)
        (UEV_id swpair)
        (let
            (
                (x:bool (UR_CanChangeOwner swpair))
            )
            (enforce (= x true) (format "SWP Pair {} ownership cannot be changed" [swpair]))
        )
    )
    (defun UEV_FeeLockState (swpair:string state:bool)
        (let
            (
                (x:bool (UR_FeeLock swpair))
            )
            (enforce (= x state) (format "Fee-lock for SWP Pair {} must be set to {} for this operation" [swpair state]))
        )
    )
    (defun UEV_PoolFee (fee:decimal)
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (fee-prec:integer (ref-U|CT::CT_FEE_PRECISION))
            )
            (enforce
                (= (floor fee fee-prec) fee)
                (format "SWP Pool Fee amount of {} is invalid decimal wise" [fee])
            )
            (enforce (and (>= fee 0.0001) (<= fee 320.0)) (format "SWP Pool Fee amount of {} is invalid size wise" [fee]))
        )
    )
    (defun UEV_New (t-ids:[string] w:[decimal] amp:decimal)
        (let
            (
                (n:integer (length t-ids))
                (SP3:[string] (if (= amp -1.0) (UR_Pools P3) (UR_Pools S3)))
                (SP4:[string] (if (= amp -1.0) (UR_Pools P4) (UR_Pools S4)))
                (SP5:[string] (if (= amp -1.0) (UR_Pools P5) (UR_Pools S5)))
                (SP6:[string] (if (= amp -1.0) (UR_Pools P6) (UR_Pools S6)))
                (SP7:[string] (if (= amp -1.0) (UR_Pools P7) (UR_Pools S7)))
                (msg:string "Pool already exists for given Tokens!")
            )
            (cond
                ((= n 2) (UEV_CheckTwo t-ids w amp))
                ((= n 3) (enforce (not (UEV_CheckAgainstMass t-ids SP3)) msg))
                ((= n 4) (enforce (not (UEV_CheckAgainstMass t-ids SP4)) msg))
                ((= n 5) (enforce (not (UEV_CheckAgainstMass t-ids SP5)) msg))
                ((= n 6) (enforce (not (UEV_CheckAgainstMass t-ids SP6)) msg))
                ((= n 7) (enforce (not (UEV_CheckAgainstMass t-ids SP7)) msg))
                true
            )
        )
    )
    (defun UEV_CheckTwo (token-ids:[string] w:[decimal] amp:decimal)
        (let
            (
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (e0:string (at 0 token-ids))
                (e1:string (at 1 token-ids))
                (swp1:string (ref-U|SWP::UC_PoolID token-ids w amp))
                (swp2:string (ref-U|SWP::UC_PoolID [e1 e0] w amp))
                (t1:bool (URC_CheckID swp1))
                (t2:bool (URC_CheckID swp2))
            )
            (enforce (not t1) (format "Pair {} must not exist" [swp1]))
            (enforce (not t2) (format "Pair {} must not exist" [swp2]))
        )
    )
    (defun UEV_CheckAgainstMass:bool (token-ids:[string] present-pools:[string])
        (let
            (
                (ref-U|SWP:module{UtilitySwp} U|SWP)
            )
            (fold
                (lambda
                    (acc:bool idx:integer)
                    (or
                        acc
                        (UEV_CheckAgainst token-ids (ref-U|SWP::UC_TokensFromSwpairString (at idx present-pools)))
                    )
                )
                false
                (enumerate 0 (- (length present-pools) 1))
            )
        )
    )
    (defun UEV_CheckAgainst:bool (token-ids:[string] pool-tokens:[string])
        (fold
            (lambda
                (acc:bool idx:integer)
                (and acc (contains (at idx token-ids) pool-tokens))
            )
            true
            (enumerate 0 (- (length token-ids) 1))
        )
    )
    (defun SWPT|UEV_IdAsPrincipal (id:string for-trace:bool)
        (let
            (
                (iz-principal:bool (contains id (UR_Principals)))
            )
            (if for-trace
                (enforce (or iz-principal (= id BAR)) (format "ID {} is not a valid principal for trace operations" [id]))
                (enforce iz-principal (format "ID {} is not a principal" [id]))
            )
        )
    )
    ;;{F3}
    ;;{F4}
    (defun CAP_Owner (swpair:string)
        @doc "Enforces SWPair Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (UR_OwnerKonto swpair))
        )
    )
    ;;
    ;;{F5}
    (defun A_UpdatePrincipal (principal:string add-or-remove:bool)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (with-read SWP|Properties SWP|INFO
                { "principals" := pp }
                (with-capability (SWP|C>PRINCIPAL principal add-or-remove)
                    (if add-or-remove
                        (if (= pp [BAR])
                            (update SWP|Properties SWP|INFO
                                {"principals" : [principal]}
                            )
                            (update SWP|Properties SWP|INFO
                                {"principals" : (ref-U|LST::UC_AppL pp principal)}
                            )
                        )
                        (if (= 1 (length pp))
                            (update SWP|Properties SWP|INFO
                                {"principals" : [BAR]}
                            )
                            (let
                                (
                                    (pp-position:integer (at 0 (ref-U|LST::UC_Search (UR_Principals) principal)))
                                )
                                (update SWP|Properties SWP|INFO
                                    {"principals" : (ref-U|LST::UC_RemoveItem pp (at pp-position pp))}
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    (defun A_UpdateLiquidBoost (new-boost-variable:bool)
        (with-capability (SWP|C>LQBOOST new-boost-variable)
            (update SWP|Properties SWP|INFO
                {"liquid-boost" : new-boost-variable}
            )
        )
    )
    (defun A_UpdateLimit (limit:decimal spawn:bool)
        (with-capability (SWP|C>LIMIT)
            (if spawn
                (update SWP|Properties SWP|INFO
                    {"spawn-limit" : limit}
                )
                (update SWP|Properties SWP|INFO
                    {"inactive-limit" : limit}
                )
            )
        )
    )
    ;;{F6}
    (defun C_Issue:[string] (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        @doc "Issues a new SWPair (Liquidty Pool)"
        (enforce-guard (P|UR "TALOS|Summoner"))
        (with-capability (SWPI|C>ISSUE account pool-tokens fee-lp weights amp p)
            (let*
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (kda-dptf-cost:decimal (ref-DALOS::UR_UsagePrice "dptf"))
                    (kda-swp-cost:decimal (ref-DALOS::UR_UsagePrice "swp"))
                    (kda-costs:decimal (+ kda-dptf-cost kda-swp-cost))
                    (gas-swp-cost:decimal (ref-DALOS::UR_UsagePrice "ignis|swp-issue"))
                    (pool-token-ids:[string] (UC_ExtractTokens pool-tokens))
                    (pool-token-amounts:[decimal] (UC_ExtractTokenSupplies pool-tokens))
                    (lp-name-ticker:[string] (SWPI|URC_LpComposer pool-tokens weights amp))
                    (token-lp:string (ref-DPTF::C_IssueLP patron account (at 0 lp-name-ticker) (at 1 lp-name-ticker)))
                    (swpair:string (X_Issue account pool-tokens token-lp fee-lp weights amp p))
                )
                (ref-TFT::C_MultiTransfer patron pool-token-ids account SWP|SC_NAME pool-token-amounts true)
                (ref-DPTF::C_Mint patron token-lp SWP|SC_NAME 10000000.0 true)
                (ref-TFT::C_Transfer patron token-lp SWP|SC_NAME account 10000000.0 true)
                (SWPT|X_MultiPathTracer swpair)
                (ref-DALOS::IGNIS|C_Collect patron account gas-swp-cost)
                (ref-DALOS::KDA|C_Collect patron kda-costs)
                [swpair token-lp]
            )
        )
    )
    (defun C_ChangeOwnership (patron:string swpair:string new-owner:string)
        @doc "Changes Ownership of an SWPair"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (SWP|S>RT_OWN swpair new-owner)
                (X_ChangeOwnership swpair new-owner)
                (ref-DALOS::IGNIS|C_Collect patron (UR_OwnerKonto swpair) (ref-DALOS::UR_UsagePrice "ignis|biggest"))
            )
        )
    )
    (defun C_ModifyCanChangeOwner (patron:string swpair:string new-boolean:bool)
        @doc "Modifies the <can-change-owner> parameter of an SWPair"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (SWP|S>RT_CAN-CHANGE swpair new-boolean)
                (X_ModifyCanChangeOwner swpair new-boolean)
                (ref-DALOS::IGNIS|C_Collect patron (UR_OwnerKonto swpair) (ref-DALOS::UR_UsagePrice "ignis|biggest"))
            )
        )
    )
    (defun C_ToggleAddOrSwap (patron:string swpair:string toggle:bool add-or-swap:bool)
        @doc "When Toggle is true, ensure required Mint, Burn, Transfer Roles are set, if not, set them \
        \ Mint and Burn Roles for LP Token (requires LP Token Ownership) \
        \ Fee Exemption Roles for all Tokens of a Stable Pool, or \
        \ for all Tokens of a Product Pool, except its first Token (which is principal) \
        \ Roles are needed to SWP|SC_NAME"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-ATS:module{Autostake} ATS)
            )
            (with-capability (SWP|S>ADD-OR-SWAP swpair toggle add-or-swap)
                (X_CanAddOrSwapToggle swpair toggle add-or-swap)
                (ref-DALOS::IGNIS|C_Collect patron (UR_OwnerKonto swpair) (ref-DALOS::UR_UsagePrice "ignis|medium"))
                (if toggle
                    (let*
                        (
                            (pt-ids:[string] (UR_PoolTokens swpair))
                            (amp:decimal (UR_Amplifier swpair))
                            (ptts:[string]
                                (if (= amp -1.0)
                                    (drop 1 pt-ids)
                                    pt-ids
                                )
                            )
                            (lp-id:string (UR_TokenLP swpair))
                            (lp-burn-role:bool (ref-DPTF::UR_AccountRoleBurn lp-id SWP|SC_NAME))
                            (lp-mint-role:bool (ref-DPTF::UR_AccountRoleMint lp-id SWP|SC_NAME))
                        )
                        (if (not lp-burn-role)
                            (ref-ATS::DPTF|C_ToggleBurnRole patron lp-id SWP|SC_NAME true)
                            true
                        )
                        (if (not lp-mint-role)
                            (ref-ATS::DPTF|C_ToggleMintRole patron lp-id SWP|SC_NAME true)
                            true
                        )
                        (map
                            (lambda
                                (idx:integer)
                                (if (not (ref-DPTF::UR_AccountRoleFeeExemption (at idx ptts) SWP|SC_NAME))
                                    (ref-ATS::C_ToggleFeeExemptionRole patron (at idx ptts) SWP|SC_NAME true)
                                    true
                                )
                            )
                            (enumerate 0 (- (length ptts) 1))
                        )
                    )
                    true
                )
            )
        )
    )
    (defun C_ModifyWeights (patron:string swpair:string new-weights:[decimal])
        @doc "Modify weights for an SWPair"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (SECURE)
                (X_ModifyWeights swpair new-weights)
                (ref-DALOS::IGNIS|C_Collect patron (UR_OwnerKonto swpair) (ref-DALOS::UR_UsagePrice "ignis|biggest"))
            )
        )
    )
    (defun C_ToggleFeeLock (patron:string swpair:string toggle:bool)
        @doc "Locks the fee in place for for an SWPair"
        (enforce-guard (P|UR "TALOS|Summoner"))
        (with-capability (SWP|C>TG_FEE-LOCK swpair toggle)
            (let*
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (swpair-owner:string (UR_OwnerKonto swpair))
                    (g1:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                    (toggle-costs:[decimal] (X_ToggleFeeLock swpair toggle))
                    (g2:decimal (at 0 toggle-costs))
                    (gas-costs:decimal (+ g1 g2))
                    (kda-costs:decimal (at 1 toggle-costs))
                )
                (ref-DALOS::IGNIS|C_Collect patron swpair-owner gas-costs)
                (if (> kda-costs 0.0)
                    (do
                        (X_IncrementFeeUnlocks swpair)
                        (ref-DALOS::KDA|C_Collect patron kda-costs)
                    )
                    true
                )
            )
        )
    )
    (defun C_UpdateLP (patron:string swpair:string lp-token:string add-or-remove:bool)
        @doc "Updates LP Tokens for an SWPair"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (SWP|S>UPDATE-LP swpair lp-token add-or-remove)
                (X_UpdateLP swpair lp-token add-or-remove)
                (ref-DALOS::IGNIS|C_Collect patron (UR_OwnerKonto swpair) (ref-DALOS::UR_UsagePrice "ignis|biggest"))
            )
        )
    )
    (defun C_UpdateFee (patron:string swpair:string new-fee:decimal lp-or-special:bool)
        @doc "Updates the Fees for an SWPair"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (SWP|S>UPDATE-FEE swpair new-fee)
                (X_UpdateFee swpair new-fee lp-or-special)
                (ref-DALOS::IGNIS|C_Collect patron (UR_OwnerKonto swpair) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_UpdateSpecialFeeTargets (patron:string swpair:string targets:[object{Swapper.FeeSplit}])
        @doc "Updates the Fee Targets for an SWPair"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (SPW|S>UPDATE_SPECIAL-FEE-TARGETS swpair targets)
                (X_UpdateSpecialFeeTargets swpair targets)
                (ref-DALOS::IGNIS|C_Collect patron (UR_OwnerKonto swpair) (ref-DALOS::UR_UsagePrice "ignis|medium"))
            )
        )
    )
    (defun C_ToggleSpecialMode (patron:string swpair:string)
        @doc "Toggles Special Mode for an SWPair."
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (SWP|S>TG_SPECIAL-MODE swpair)
                (X_ToggleSpecialMode swpair)
                (ref-DALOS::IGNIS|C_Collect patron (UR_OwnerKonto swpair) (ref-DALOS::UR_UsagePrice "ignis|medium"))
            )
        )
    )
    (defun C_RotateGovernor (patron:string swpair:string new-gov:guard)
        @doc "Rotates Governor for an Swpair"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (SPW|S>RT_GOV swpair)
                (X_UpdateGovernor swpair new-gov)
                (ref-DALOS::IGNIS|C_Collect patron (UR_OwnerKonto swpair) (ref-DALOS::UR_UsagePrice "ignis|medium"))
            )
        )
    )
    (defun C_UpdateAmplifier (patron:string swpair:string amp:decimal)
        @doc "Updates Amplifier Value for a Stable SWPair"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (SWP|S>UPDATE-AMPLIFIER swpair amp)
                (X_UpdateAmplifier swpair amp)
                (ref-DALOS::IGNIS|C_Collect patron (UR_OwnerKonto swpair) (ref-DALOS::UR_UsagePrice "ignis|medium"))
            )
        )
    )
    ;;{F7}
    (defun X_ChangeOwnership (swpair:string new-owner:string)
        (require-capability (SWP|S>RT_OWN swpair new-owner))
        (update SWP|Pairs swpair
            {"owner-konto"                      : new-owner}
        )
    )
    (defun X_ModifyCanChangeOwner (swpair:string new-boolean:bool)
        (require-capability (SWP|S>RT_CAN-CHANGE swpair new-boolean))
        (update SWP|Pairs swpair
            {"can-change-owner"                 : new-boolean}
        )  
    )
    (defun X_CanAddOrSwapToggle (swpair:string toggle:bool add-or-swap:bool)
        (require-capability (SWP|S>ADD-OR-SWAP swpair toggle add-or-swap))
        (if add-or-swap
            (update SWP|Pairs swpair
                {"can-add"                      : toggle}
            )
            (update SWP|Pairs swpair
                {"can-swap"                     : toggle}
            )
        )
    )
    (defun X_ModifyWeights (swpair:string new-weights:[decimal])
        (enforce-one
            "Modifying weights not allowed"
            [
                (create-capability-guard (SECURE))
                (enforce-guard (P|UR "SWPL|Caller"))
            ]
        )
        (with-capability (SWP|S>WEIGHTS swpair new-weights)
            (update SWP|Pairs swpair
                {"weights"                          : new-weights}
            )
        )
        
    )
    (defun X_ToggleFeeLock:[decimal] (swpair:string toggle:bool)
        (require-capability (SWP|C>TG_FEE-LOCK swpair toggle))
        (let
            (
                (ref-U|ATS:module{UtilityAts} U|ATS)
            )
            (update SWP|Pairs swpair
                { "fee-lock" : toggle}
            )
            (if (= toggle true)
                [0.0 0.0]
                (ref-U|ATS::UC_UnlockPrice (UR_FeeUnlocks swpair))
            )
        )
    )
    (defun X_IncrementFeeUnlocks (swpair:string)
        (require-capability (SECURE))
        (with-read SWP|Pairs swpair
            { "unlocks" := u }
            (update SWP|Pairs swpair
                {"unlocks" : (+ u 1)}
            )
        )
    )
    (defun X_UpdateLP (swpair:string lp-token:string add-or-remove:bool)
        (require-capability (SWP|S>UPDATE-LP swpair lp-token add-or-remove))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (with-read SWP|Pairs swpair
                { "token-lps" := tlps}
                (if add-or-remove
                    (if (= tlps [BAR])
                        (update SWP|Pairs swpair
                            {"token-lps" : [lp-token]}
                        )
                        (update SWP|Pairs swpair
                            {"token-lps" : (ref-U|LST::UC_AppL tlps lp-token)}
                        )
                    )
                    (if (= 1 (length tlps))
                        (update SWP|Pairs swpair
                            {"token-lps" : [BAR]}
                        )
                        (let
                            (
                                (lp-token-position:integer (at 0 (ref-U|LST::UC_Search (UR_TokenLPS swpair) lp-token)))
                            )
                            (update SWP|Pairs swpair
                                {"token-lps" : (ref-U|LST::UC_RemoveItem tlps (at lp-token-position tlps))}
                            )
                        )
                    )
                )
            )
        )
    )
    (defun X_UpdateSupplies (swpair:string new-supplies:[decimal])
        (enforce-one
            "Updating Pool Supplies not allowed"
            [
                
                (enforce-guard (P|UR "SWPL|Caller"))
                (enforce-guard (P|UR "SWPS|Caller"))
            ]
        )
        (with-capability (SWP|S>UPDATE-SUPPLIES swpair new-supplies)
            (let
                (
                    (pool-tokens:[string] (UR_PoolTokens swpair))
                    (new-pool-tokens:[object{Swapper.PoolTokens}] 
                        (zip (lambda (x:string y:decimal) { "token-id": x, "token-supply": y }) pool-tokens new-supplies)
                    )
                )
                (update SWP|Pairs swpair
                    {"pool-tokens" : new-pool-tokens}
                )
            )
        )
    )
    (defun X_UpdateSupply (swpair:string id:string new-supply:decimal)
        (enforce-guard (P|UR "SWPS|Caller"))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (current-pool-tokens:[object{Swapper.PoolTokens}] (UR_PoolTokenObject swpair))
                (id-pos:integer (UR_PoolTokenPosition swpair id))
                (new:object{Swapper.PoolTokens} { "token-id" : id, "token-supply" : new-supply})
                (new-pool-tokens:[object{Swapper.PoolTokens}] (ref-U|LST::UC_ReplaceAt current-pool-tokens id-pos new))
            )
            (with-capability (SWP|S>UPDATE-SUPPLY swpair id new-supply)
                (update SWP|Pairs swpair
                    {"pool-tokens" : new-pool-tokens}
                )
            )
        )
    )
    (defun X_UpdateFee (swpair:string new-fee:decimal lp-or-special:bool)
        (require-capability (SWP|S>UPDATE-FEE swpair new-fee))
        (if lp-or-special
            (update SWP|Pairs swpair
                {"fee-lp"                         : new-fee}
            )
            (update SWP|Pairs swpair
                {"fee-special"                    : new-fee}
            )
        )
    )
    (defun X_UpdateSpecialFeeTargets (swpair:string targets:[object{Swapper.FeeSplit}])
        (require-capability (SPW|S>UPDATE_SPECIAL-FEE-TARGETS swpair targets))
        (update SWP|Pairs swpair
            {"fee-special-targets"                : targets}
        )
    )
    (defun X_ToggleSpecialMode (swpair:string)
        (require-capability (SWP|S>TG_SPECIAL-MODE swpair))
        (with-read SWP|Pairs swpair
            { "special" := s}
            (update SWP|Pairs swpair
                {"special" : (not s)}
            )
        )
    )
    (defun X_UpdateGovernor (swpair:string new-governor:guard)
        (require-capability (SPW|S>RT_GOV swpair))
        (update SWP|Pairs swpair
            {"governor" : new-governor}
        )
    )
    (defun X_UpdateAmplifier (swpair:string new-amplifier:decimal)
        (with-capability (SWP|S>UPDATE-AMPLIFIER swpair new-amplifier)
            (update SWP|Pairs swpair
                {"amplifier" : new-amplifier}
            )
        )
    )
    (defun X_SavePool (n:integer what:bool swpair:string)
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (vars
                    (cond
                        ((= n 2) (if what [(UR_Pools P2) P2] [(UR_Pools S2) S2]))
                        ((= n 3) (if what [(UR_Pools P3) P3] [(UR_Pools S3) S3]))
                        ((= n 4) (if what [(UR_Pools P4) P4] [(UR_Pools S4) S4]))
                        ((= n 5) (if what [(UR_Pools P5) P5] [(UR_Pools S5) S5]))
                        ((= n 6) (if what [(UR_Pools P6) P6] [(UR_Pools S6) S6]))
                        ((= n 7) (if what [(UR_Pools P7) P7] [(UR_Pools S7) S7]))
                        true
                    )
                )
                (sp-n:[string] (at 0 vars))
                (SPN:string (at 1 vars))
            )
            (if (= sp-n [BAR])
                (update SWP|Pools SPN
                    {"pools" : [swpair]}
                )
                (update SWP|Pools SPN
                    {"pools" : (ref-U|LST::UC_AppL sp-n swpair)}
                )
            )
        )
    )
    (defun X_Issue:string (account:string pool-tokens:[object{Swapper.PoolTokens}] token-lp:string fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        (require-capability (SWPI|C>ISSUE account pool-tokens fee-lp weights amp p))
        (let
            (
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (n:integer (length pool-tokens))
                (what:bool (if (= amp -1.0) true false))
                (pool-token-ids:[string] (UC_ExtractTokens pool-tokens))
                (swpair:string (ref-U|SWP::UC_PoolID pool-token-ids weights amp))
                (ptte:[string]
                    (if (= amp -1.0)
                        (drop 1 pool-token-ids)
                        pool-token-ids
                    )
                )
            )
            (insert SWP|Pairs swpair
                {"owner-konto"                          : account
                ,"can-change-owner"                     : true
                ,"can-add"                              : false
                ,"can-swap"                             : false

                ,"genesis-weights"                      : weights
                ,"weights"                              : weights
                ,"genesis-ratio"                        : pool-tokens
                ,"pool-tokens"                          : pool-tokens
                ,"token-lp"                             : token-lp
                ,"token-lps"                            : [BAR]

                ,"fee-lp"                               : fee-lp
                ,"fee-special"                          : 0.0
                ,"fee-special-targets"                  : [SWP|EMPTY-TARGET]
                ,"fee-lock"                             : false
                ,"unlocks"                              : 0

                ,"special"                              : false
                ,"governor"                             : (ref-DALOS::UR_AccountGuard account)
                ,"amplifier"                            : amp
                ,"primality"                            : p
                }
            )
            (X_SavePool n what swpair)
            (ref-DPTF::C_DeployAccount token-lp account)
            (ref-DPTF::C_DeployAccount token-lp SWP|SC_NAME)
            (map
                (lambda
                    (id:string)
                    (ref-DPTF::C_DeployAccount id SWP|SC_NAME)
                )
                ptte
            )
            swpair
        )
    )
    ;;
    (defun SWPT|X_MultiPathTracer (swpair:string)
        (enforce-guard (P|UR "SWPI|Caller"))
        (with-capability (SECURE)
            (map
                (lambda
                    (token:string)
                    (SWPT|X_SinglePathTracer token swpair)
                )
                (UR_PoolTokens swpair)
            )
        )
    )
    (defun SWPT|X_SinglePathTracer (id:string swpair:string)
        (require-capability (SECURE))
        (with-default-read SWPT|Tracer id
            { "links" : NLE }
            { "links" := lks }
            (write SWPT|Tracer id
                { "links" : (SWPT|URC_PathTracer lks id swpair)}
            )
        )
    )
    
)

(create-table P|T)
(create-table SWP|Properties)
(create-table SWP|Pairs)
(create-table SWP|Pools)
(create-table SWPT|Tracer)