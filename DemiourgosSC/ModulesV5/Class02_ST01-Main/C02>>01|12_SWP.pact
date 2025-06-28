;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module SWP GOV
    ;;
    (implements OuronetPolicy)
    (implements BrandingUsageV7)
    (implements SwapperV4)
    ;;{G1}
    (defconst GOV|MD_SWP            (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_SWP            (keyset-ref-guard SWP|SC_KEY))
    ;;
    (defconst SWP|SC_KEY            (GOV|SwapKey))
    (defconst SWP|SC_NAME           (GOV|SWP|SC_NAME))
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
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|SwapKey ()           (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|SwapKey)))
    (defun GOV|SWP|SC_NAME ()       (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|SWP|SC_NAME)))
    (defun SWP|SetGovernor (patron:string)
        (with-capability (P|SWP|CALLER)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-U|G:module{OuronetGuards} U|G)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-DALOS::C_RotateGovernor
                            SWP|SC_NAME
                            (ref-U|G::UEV_GuardOfAny
                                [
                                    (create-capability-guard (SWP|GOV))
                                    (P|UR "SWPU|RemoteSwpGov")
                                    (P|UR "SWPI|RemoteSwpGov")
                                    (P|UR "SWPLC|RemoteSwpGov")
                                    (P|UR "MTX-SWP|RemoteSwpGov")
                                ]
                            )
                        )
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
            )
        )
    )
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|SWP|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|SWP|CALLER))
        (compose-capability (SECURE))
    )
    (defcap P|GOVERNING-CALLER ()
        (compose-capability (P|SWP|CALLER))
        (compose-capability (SWP|GOV))
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
        (with-capability (GOV|SWP_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|SWP_ADMIN)
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
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|ATSU:module{OuronetPolicy} ATSU)
                (ref-P|VST:module{OuronetPolicy} VST)
                (ref-P|LIQUID:module{OuronetPolicy} LIQUID)
                (ref-P|ORBR:module{OuronetPolicy} OUROBOROS)
                (ref-P|SWPT:module{OuronetPolicy} SWPT)
                (mg:guard (create-capability-guard (P|SWP|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|DPMF::P|A_AddIMP mg)
            (ref-P|ATS::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|ATSU::P|A_AddIMP mg)
            (ref-P|VST::P|A_AddIMP mg)
            (ref-P|LIQUID::P|A_AddIMP mg)
            (ref-P|ORBR::P|A_AddIMP mg)
            (ref-P|SWPT::P|A_AddIMP mg)
        )
    )
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
                (mp:[guard] (P|UR_IMP))
                (g:guard (ref-U|G::UEV_GuardOfAny mp))
            )
            (enforce-guard g)
        )
    )
    ;;
    ;;{1}
    (defschema SWP|PropertiesSchema
        principals:[string]
        primordial-pool:string
        liquid-boost:bool
        spawn-limit:decimal
        inactive-limit:decimal
    )
    (defschema SWP|AsymmetrySchema
        asymmetric:bool
    )
    (defschema SWP|PairsSchema
        @doc "Key = <token-a-id> + UTILS.BAR + <token-b-id>"
        owner-konto:string
        can-change-owner:bool
        can-add:bool
        can-swap:bool
        genesis-weights:[decimal]
        weights:[decimal]
        genesis-ratio:[object{SwapperV4.PoolTokens}]
        pool-tokens:[object{SwapperV4.PoolTokens}]
        token-lp:string
        fee-lp:decimal
        fee-special:decimal
        fee-special-targets:[object{SwapperV4.FeeSplit}]
        fee-lock:bool
        unlocks:integer
        amplifier:decimal
        primality:bool
        frozen-lp:bool
        sleeping-lp:bool
    )
    (defschema SWP|PoolsSchema
        pools:[string]
    )
    ;;{2}
    (deftable SWP|Properties:{SWP|PropertiesSchema})
    (deftable SWP|Pairs:{SWP|PairsSchema})
    (deftable SWP|Pools:{SWP|PoolsSchema})
    (deftable SWP|Asymmetry:{SWP|AsymmetrySchema})
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defun CT_EmptyCumulator        ()(let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::DALOS|EmptyOutputCumulatorV2)))
    (defun SWP|Info ()              (at 0 ["SwapperInformation"]))
    (defconst BAR                   (CT_Bar))
    (defconst EOC                   (CT_EmptyCumulator))
    (defconst SWP|INFO              (SWP|Info))
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
                (ref-DALOS:module{OuronetDalosV4} DALOS)
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
                    (= (floor w (ref-U|CT::CT_FEE_PRECISION)) w)
                )
                new-weights
            )
            (enforce (= pp "W") "Changing weights available only for weighted Pools")
            (enforce (= ws 1.0) "All weights must add to exactly 1.0")
            (CAP_Owner swpair)
        )
    )
    (defcap SWP|S>UPDATE-SUPPLIES (swpair:string new-supplies:[decimal])
        (let
            (
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
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
    (defcap SPW|S>UPDATE_SPECIAL-FEE-TARGETS (swpair:string targets:[object{SwapperV4.FeeSplit}])
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (target-no:integer (length targets))
                (owner:string (UR_OwnerKonto swpair))
                (major:integer (ref-DALOS::UR_Elite-Tier-Major owner))
                (max:integer
                    (cond
                        ((or (= major 0) (= major 1)) 1)
                        ((or (= major 2) (= major 3)) 2)
                        ((or (= major 4) (= major 5)) 3)
                        4
                    )
                )
            )
            (enforce (and (>= target-no 1) (<= target-no max)) "Between 1 and 4 special fee Targets allowed")
            (CAP_Owner swpair)
            (map
                (lambda
                    (obj:object{SwapperV4.FeeSplit})
                    (UEV_FeeSplit obj)
                )
                targets
            )
        )
    )
    ;{C3}
    ;{C4}
    (defcap SWP|C>UPDATE-BRD (swpair:string)
        @event
        (CAP_Owner swpair)
        (compose-capability (P|SWP|CALLER))
    )
    (defcap SWP|C>UPGRADE-BRD (swpair:string)
        @event
        (CAP_Owner swpair)
        (compose-capability (P|SWP|CALLER))
    )
    (defcap SWP|C>ADD-OR-SWAP (swpair:string toggle:bool add-or-swap:bool)
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
    (defcap SWP|C>PRINCIPAL (principal:string add-or-remove:bool)
        @event
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
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
            (enforce (!= new-boost-variable lqb) (format "Liquid Boost already set to {}" [new-boost-variable]))
        )
        (compose-capability (GOV|SWP_ADMIN))
    )
    (defcap SWP|C>LIMIT ()
        @event
        (compose-capability (GOV|SWP_ADMIN))
    )

    (defcap SWP|C>TG_FEE-LOCK (swpair:string toggle:bool)
        @event
        (UEV_FeeLockState swpair (not toggle))
        (CAP_Owner swpair)
        (compose-capability (SECURE))
    )
    (defcap SWP|C>ENABLE-FROZEN (swpair:string)
        @event
        (UEV_FrozenLP swpair false)
        (compose-capability (P|GOVERNING-CALLER))
    )
    (defcap SWP|C>ENABLE-SLEEPING (swpair:string)
        @event
        (UEV_SleepingLP swpair false)
        (compose-capability (P|GOVERNING-CALLER))
    )
    (defcap SWP|C>DEFINE-PRIMORDIAL-POOL (primordial-pool:string)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                ;;
                (primality:bool (UR_Primality primordial-pool))
                (pt:[string] (UR_PoolTokens primordial-pool))
                (ouro:string (ref-DALOS::UR_OuroborosID))
                (wkda:string (ref-DALOS::UR_WrappedKadenaID))
                (lkda:string (ref-DALOS::UR_LiquidKadenaID))
                (pool-type:string (ref-U|SWP::UC_PoolType primordial-pool))
                (iz-weigthed:bool (= pool-type "W"))
                (has-ouro:bool (contains ouro pt))
                (has-wkda:bool (contains wkda pt))
                (has-lkda:bool (contains lkda pt))
                (iz-three:bool (= (length pt) 3))
            )
            (enforce (fold (and) true [iz-weigthed has-ouro has-wkda has-lkda iz-three]) "Pool is not the primordial pool")
            (compose-capability (GOV|SWP_ADMIN))
        )
    )
    (defcap SWP|C>TG-ASYMETRIC-LQ (toggle:bool)
        (let
            (
                (pp:string (UR_PrimordialPool))
            )
            (enforce (!= pp BAR) "PrimordialPool must be set for this operation")
            (UEV_AsymetricState (not toggle))
            (compose-capability (GOV|SWP_ADMIN))
            (compose-capability (P|SWP|CALLER))
        )
    )
    ;;{FC}
    (defun UC_ExtractTokens:[string] (input:[object{SwapperV4.PoolTokens}])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[string] item:object{SwapperV4.PoolTokens})
                    (ref-U|LST::UC_AppL acc (at "token-id" item))
                )
                []
                input
            )
        )
    )
    (defun UC_ExtractTokenSupplies:[decimal] (input:[object{SwapperV4.PoolTokens}])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[decimal] item:object{SwapperV4.PoolTokens})
                    (ref-U|LST::UC_AppL acc (at "token-supply" item))
                )
                []
                input
            )
        )
    )
    (defun UC_CustomSpecialFeeTargets:[string] (io:[object{SwapperV4.FeeSplit}])
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
    (defun UC_CustomSpecialFeeTargetsProportions:[decimal] (io:[object{SwapperV4.FeeSplit}])
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
    ;;{F0}
    (defun UR_Asymetric:bool ()
        (at "asymmetric" (read SWP|Asymmetry SWP|INFO ["asymmetric"]))
    )
    (defun UR_Principals:[string] ()
        (at "principals" (read SWP|Properties SWP|INFO ["principals"]))
    )
    (defun UR_PrimordialPool:string ()
        (at "primordial-pool" (read SWP|Properties SWP|INFO ["primordial-pool"]))
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
    ;;
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
    (defun UR_GenesisRatio:[object{SwapperV4.PoolTokens}] (swpair:string)
        (at "genesis-ratio" (read SWP|Pairs swpair ["genesis-ratio"]))
    )
    (defun UR_PoolTokenObject:[object{SwapperV4.PoolTokens}] (swpair:string)
        (at "pool-tokens" (read SWP|Pairs swpair ["pool-tokens"]))
    )
    (defun UR_TokenLP:string (swpair:string)
        (at "token-lp" (read SWP|Pairs swpair ["token-lp"]))
    )
    (defun UR_FeeLP:decimal (swpair:string)
        (at "fee-lp" (read SWP|Pairs swpair ["fee-lp"]))
    )
    (defun UR_FeeSP:decimal (swpair:string)
        (at "fee-special" (read SWP|Pairs swpair ["fee-special"]))
    )
    (defun UR_FeeSPT:[object{SwapperV4.FeeSplit}] (swpair:string)
        (at "fee-special-targets" (read SWP|Pairs swpair ["fee-special-targets"]))
    )
    (defun UR_FeeLock:bool (swpair:string)
        (at "fee-lock" (read SWP|Pairs swpair ["fee-lock"]))
    )
    (defun UR_FeeUnlocks:integer (swpair:string)
        (at "fee-unlocks" (read SWP|Pairs swpair ["fee-unlocks"]))
    )
    (defun UR_Amplifier:decimal (swpair:string)
        (at "amplifier" (read SWP|Pairs swpair ["amplifier"]))
    )
    (defun UR_Primality:bool (swpair:string)
        (at "primality" (read SWP|Pairs swpair ["primality"]))
    )
    (defun UR_IzFrozenLP:bool (swpair:string)
        (at "frozen-lp" (read SWP|Pairs swpair ["frozen-lp"]))
    )
    (defun UR_IzSleepingLP:bool (swpair:string)
        (at "sleeping-lp" (read SWP|Pairs swpair ["sleeping-lp"]))
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
                ;;
                (pool-tokens:[string] (UR_PoolTokens swpair))
                (iz-on-pool:bool (contains id pool-tokens))
            )
            (enforce iz-on-pool (format "Token {} is not part of Pool {}" [id swpair]))
            (at 0 (ref-U|LST::UC_Search pool-tokens id))
        )
    )
    (defun UC_PoolTokenPosition:integer (swpair:string id:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                ;;
                (pool-tokens:[string] (ref-U|SWP::UC_TokensFromSwpairString swpair))
                (iz-on-pool:bool (contains id pool-tokens))
            )
            (enforce iz-on-pool (format "Token {} is not part of the Pool String {}" [id swpair]))
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                ;;
                (pool-tokens:[string] (UR_PoolTokens swpair))
                (l:integer (length pool-tokens))
                (Xp:[integer]
                    (fold
                        (lambda
                            (acc:[integer] idx:integer)
                            (ref-U|LST::UC_AppL
                                acc
                                (ref-DPTF::UR_Decimals (at idx pool-tokens))
                            )
                        )
                        []
                        (enumerate 0 (- l 1))
                    )
                )
            )
            Xp
        )
    )
    (defun UC_PoolTokenPrecisions:[integer] (swpair:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                ;;
                (pool-tokens:[string] (ref-U|SWP::UC_TokensFromSwpairString swpair))
                (l:integer (length pool-tokens))
                (Xp:[integer]
                    (fold
                        (lambda
                            (acc:[integer] idx:integer)
                            (ref-U|LST::UC_AppL
                                acc
                                (ref-DPTF::UR_Decimals (at idx pool-tokens))
                            )
                        )
                        []
                        (enumerate 0 (- l 1))
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
    (defun URC_LpCapacity:decimal (swpair:string)
        @doc "Computes the LP Capacity of a Given Swap Pair"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
            )
            (ref-DPTF::UR_Supply (UR_TokenLP swpair))
        )
    )
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
                (ref-U|CT:module{OuronetConstants} U|CT)
                (n:decimal (dec (length (UR_PoolTokens swpair))))
                (swap-fee:decimal (URC_PoolTotalFee swpair))
            )
            (floor (/ (* n swap-fee) (* 4.0 (- n 1.0))) (ref-U|CT::CT_FEE_PRECISION))
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
    (defun URC_LpComposer:[string] (pool-tokens:[object{SwapperV4.PoolTokens}] weights:[decimal] amp:decimal)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
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
    (defun UEV_FeeSplit (input:object{SwapperV4.FeeSplit})
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
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
    (defun UEV_AsymetricState (state:bool)
        (let
            (
                (x:bool (UR_Asymetric))
            )
            (enforce (= x state) (format "Asymetric Liquidity must be set to {} for this operation" [state]))
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
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
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
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
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
    (defun UEV_FrozenLP (swpair:string state:bool)
        (let
            (
                (frozen-lp:bool (UR_IzFrozenLP swpair))
            )
            (enforce (= state frozen-lp) (format "Swpair {} must have its Frozen-LP set to <> for this operation" [swpair state]))
        )
    )
    (defun UEV_SleepingLP (swpair:string state:bool)
        (let
            (
                (sleeping-lp:bool (UR_IzSleepingLP swpair))
            )
            (enforce (= state sleeping-lp) (format "Swpair {} must have its Sleeping-LP set to <> for this operation" [swpair state]))
        )
    )
    ;;{F3}
    ;;{F4}
    (defun CAP_Owner (swpair:string)
        @doc "Enforces SWPair Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (UR_OwnerKonto swpair))
        )
    )
    ;;
    ;;{F5}
    (defun A_UpdatePrincipal (principal:string add-or-remove:bool)
        (UEV_IMC)
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
    (defun A_UpdateLimit (limit:decimal spawn:bool)
        (UEV_IMC)
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
    (defun A_UpdateLiquidBoost (new-boost-variable:bool)
        (UEV_IMC)
        (with-capability (SWP|C>LQBOOST new-boost-variable)
            (update SWP|Properties SWP|INFO
                {"liquid-boost" : new-boost-variable}
            )
        )
    )
    (defun A_DefinePrimordialPool (primordial-pool:string)
        (UEV_IMC)
        (with-capability (SWP|C>DEFINE-PRIMORDIAL-POOL primordial-pool)
            (update SWP|Properties SWP|INFO
                {"primordial-pool" : primordial-pool}
            )
        )
    )
    (defun A_ToggleAsymetricLiquidityAddition (toggle:bool)
        (UEV_IMC)
        (with-capability (SWP|C>TG-ASYMETRIC-LQ toggle)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (ref-ATS:module{AutostakeV4} ATS)
                    ;;
                    (ignis-id:string (ref-DALOS::UR_IgnisID))
                    (ouro-id:string (ref-DALOS::UR_OuroborosID))
                    (vst-sc:string (ref-DALOS::GOV|VST|SC_NAME))
                    ;;
                    (ignis-burn-role:bool (ref-DPTF::UR_AccountRoleBurn ignis-id SWP|SC_NAME))
                    (ouro-mint-role:bool (ref-DPTF::UR_AccountRoleMint ouro-id SWP|SC_NAME))
                    (ignis-fee-exemption-role:bool (ref-DPTF::UR_AccountRoleFeeExemption ignis-id SWP|SC_NAME))
                    (ignis-fee-exemption-roleV2:bool (ref-DPTF::UR_AccountRoleFeeExemption ignis-id vst-sc))
                )
                (if (not ignis-burn-role)
                    (ref-ATS::DPTF|C_ToggleBurnRole ignis-id SWP|SC_NAME true)
                    true
                )
                (if (not ouro-mint-role)
                    (ref-ATS::DPTF|C_ToggleMintRole ouro-id SWP|SC_NAME true)
                    true
                )
                (if (not ignis-fee-exemption-role)
                    (ref-ATS::DPTF|C_ToggleFeeExemptionRole ignis-id SWP|SC_NAME true)
                    true
                )
                (if (not ignis-fee-exemption-role)
                    (ref-ATS::DPTF|C_ToggleFeeExemptionRole ignis-id vst-sc true)
                    true
                )
                (update SWP|Asymmetry SWP|INFO
                    {"asymmetric" : toggle}
                )
            )
        )
    )
    ;;{F6}
    (defun C_UpdatePendingBranding:object{IgnisCollector.OutputCumulator}
        (entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-BRD:module{Branding} BRD)
            )
            (with-capability (SWP|C>UPDATE-BRD entity-id)
                (ref-BRD::XE_UpdatePendingBranding entity-id logo description website social)
                (ref-IGNIS::IC|UDC_BrandingCumulator (UR_OwnerKonto entity-id) 4.0)
            )
        )
    )
    (defun C_UpgradeBranding (patron:string entity-id:string months:integer)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-BRD:module{Branding} BRD)
                (owner:string (UR_OwnerKonto entity-id))
                (kda-payment:decimal
                    (with-capability (SWP|C>UPGRADE-BRD entity-id)
                        (ref-BRD::XE_UpgradeBranding entity-id owner months)
                    )
                )
            )
            (ref-DALOS::KDA|C_CollectWT patron kda-payment false)
        )
    )
    ;;
    (defun C_ChangeOwnership:object{IgnisCollector.OutputCumulator}
        (swpair:string new-owner:string)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (SWP|S>RT_OWN swpair new-owner)
                (XI_ChangeOwnership swpair new-owner)
                (ref-IGNIS::IC|UDC_BiggestCumulator (UR_OwnerKonto swpair))
            )
        )
    )
    (defun C_EnableFrozenLP:object{IgnisCollector.OutputCumulator}
        (patron:string swpair:string)
        (UEV_IMC)
        (with-capability (SWP|C>ENABLE-FROZEN swpair)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (ref-VST:module{VestingV4} VST)
                    (lp-id:string (UR_TokenLP swpair))
                )
                (XI_EnableFrozenLP swpair)
                (ref-VST::C_CreateFrozenLink patron lp-id)
            )
        )
    )
    (defun C_EnableSleepingLP:object{IgnisCollector.OutputCumulator}
        (patron:string swpair:string)
        (UEV_IMC)
        (with-capability (SWP|C>ENABLE-SLEEPING swpair)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (ref-VST:module{VestingV4} VST)
                    (lp-id:string (UR_TokenLP swpair))
                )
                (XI_EnableSleepingLP swpair)
                (ref-VST::C_CreateSleepingLink patron lp-id)
            )
        )
    )
    (defun C_ModifyCanChangeOwner:object{IgnisCollector.OutputCumulator}
        (swpair:string new-boolean:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (SWP|S>RT_CAN-CHANGE swpair new-boolean)
                (XI_ModifyCanChangeOwner swpair new-boolean)
                (ref-IGNIS::IC|UDC_BiggestCumulator (UR_OwnerKonto swpair))
            )
        )
    )
    (defun C_ModifyWeights:object{IgnisCollector.OutputCumulator}
        (swpair:string new-weights:[decimal])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (SECURE)
                (XB_ModifyWeights swpair new-weights)
                (ref-IGNIS::IC|UDC_BiggestCumulator (UR_OwnerKonto swpair))
            )
        )
    )
    (defun C_ToggleAddOrSwap:object{IgnisCollector.OutputCumulator}
        (swpair:string toggle:bool add-or-swap:bool)
        (UEV_IMC)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-ATS:module{AutostakeV4} ATS)
                (biggest:decimal (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                (price:decimal (* 5.0 biggest))
                (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                (ico0:object{IgnisCollector.OutputCumulator}
                    (ref-IGNIS::IC|UDC_ConstructOutputCumulator price (UR_OwnerKonto swpair) trigger [])
                )
                (ico1:object{IgnisCollector.OutputCumulator}
                    (with-capability (P|GOVERNING-CALLER)
                        (if toggle
                            (let
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
                                    (ico2:object{IgnisCollector.OutputCumulator}
                                        (if (not lp-burn-role)
                                            (ref-ATS::DPTF|C_ToggleBurnRole lp-id SWP|SC_NAME true)
                                            EOC
                                        )
                                    )
                                    (ico3:object{IgnisCollector.OutputCumulator}
                                        (if (not lp-mint-role)
                                            (ref-ATS::DPTF|C_ToggleMintRole lp-id SWP|SC_NAME true)
                                            EOC
                                        )
                                    )
                                    (folded-obj:[object{IgnisCollector.OutputCumulator}]
                                        (fold
                                            (lambda
                                                (acc:[object{IgnisCollector.OutputCumulator}] idx:integer)
                                                (ref-U|LST::UC_AppL
                                                    acc
                                                    (if (not (ref-DPTF::UR_AccountRoleFeeExemption (at idx ptts) SWP|SC_NAME))
                                                        (ref-ATS::DPTF|C_ToggleFeeExemptionRole (at idx ptts) SWP|SC_NAME true)
                                                        EOC
                                                    )
                                                )
                                            )
                                            []
                                            (enumerate 0 (- (length ptts) 1))
                                        )
                                    )
                                    (ico4:object{IgnisCollector.OutputCumulator}
                                        (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators folded-obj [])
                                    )
                                )
                                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico2 ico3 ico4] [])
                            )
                            EOC
                        )
                    )
                )
            )
            (with-capability (SWP|C>ADD-OR-SWAP swpair toggle add-or-swap)
                (XE_CanAddOrSwapToggle swpair toggle add-or-swap)
            )
            (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico0 ico1] [])
        )
    )
    (defun C_ToggleFeeLock:object{IgnisCollector.OutputCumulator}
        (patron:string swpair:string toggle:bool)
        (UEV_IMC)
        (with-capability (SWP|C>TG_FEE-LOCK swpair toggle)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (toggle-costs:[decimal] (XI_ToggleFeeLock swpair toggle))
                    (g:decimal (at 0 toggle-costs))
                    (gas-costs:decimal (+ (ref-DALOS::UR_UsagePrice "ignis|small") g))
                    (kda-costs:decimal (at 1 toggle-costs))
                    (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                    (output:bool (if (> kda-costs 0.0) true false))
                )
                (if (> kda-costs 0.0)
                    (do
                        (XI_IncrementFeeUnlocks swpair)
                        (ref-DALOS::KDA|C_Collect patron kda-costs)
                    )
                    true
                )
                (ref-IGNIS::IC|UDC_ConstructOutputCumulator gas-costs (UR_OwnerKonto swpair) trigger [output])
            )
        )
    )
    (defun C_UpdateAmplifier:object{IgnisCollector.OutputCumulator}
        (swpair:string amp:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (SWP|S>UPDATE-AMPLIFIER swpair amp)
                (XI_UpdateAmplifier swpair amp)
                (ref-IGNIS::IC|UDC_MediumCumulator (UR_OwnerKonto swpair))
            )
        )
    )
    (defun C_UpdateFee:object{IgnisCollector.OutputCumulator}
        (swpair:string new-fee:decimal lp-or-special:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (SWP|S>UPDATE-FEE swpair new-fee)
                (XI_UpdateFee swpair new-fee lp-or-special)
                (ref-IGNIS::IC|UDC_SmallCumulator (UR_OwnerKonto swpair))
            )
        )
    )
    (defun C_UpdateSpecialFeeTargets:object{IgnisCollector.OutputCumulator}
        (swpair:string targets:[object{SwapperV4.FeeSplit}])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (SPW|S>UPDATE_SPECIAL-FEE-TARGETS swpair targets)
                (XI_UpdateSpecialFeeTargets swpair targets)
                (ref-IGNIS::IC|UDC_MediumCumulator (UR_OwnerKonto swpair))
            )
        )
    )
    ;;{F7}
    (defun XB_ModifyWeights (swpair:string new-weights:[decimal])
        (UEV_IMC)
        (with-capability (SWP|S>WEIGHTS swpair new-weights)
            (update SWP|Pairs swpair
                {"weights"  : new-weights}
            )
        )
    )
    ;;
    (defun XE_UpdateSupplies (swpair:string new-supplies:[decimal])
        (UEV_IMC)
        (with-capability (SWP|S>UPDATE-SUPPLIES swpair new-supplies)
            (let
                (
                    (pool-tokens:[string] (UR_PoolTokens swpair))
                    (new-pool-tokens:[object{SwapperV4.PoolTokens}]
                        (zip (lambda (x:string y:decimal) { "token-id": x, "token-supply": y }) pool-tokens new-supplies)
                    )
                )
                (update SWP|Pairs swpair
                    {"pool-tokens" : new-pool-tokens}
                )
            )
        )
    )
    (defun XE_UpdateSupply (swpair:string id:string new-supply:decimal)
        (UEV_IMC)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (current-pool-tokens:[object{SwapperV4.PoolTokens}] (UR_PoolTokenObject swpair))
                (id-pos:integer (UR_PoolTokenPosition swpair id))
                (new:object{SwapperV4.PoolTokens} { "token-id" : id, "token-supply" : new-supply})
                (new-pool-tokens:[object{SwapperV4.PoolTokens}] (ref-U|LST::UC_ReplaceAt current-pool-tokens id-pos new))
            )
            (with-capability (SWP|S>UPDATE-SUPPLY swpair id new-supply)
                (update SWP|Pairs swpair
                    {"pool-tokens" : new-pool-tokens}
                )
            )
        )
    )
    (defun XE_Issue:string (account:string pool-tokens:[object{SwapperV4.PoolTokens}] token-lp:string fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        (UEV_IMC)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
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
                {"owner-konto"          : account
                ,"can-change-owner"     : true
                ,"can-add"              : false
                ,"can-swap"             : false

                ,"genesis-weights"      : weights
                ,"weights"              : weights
                ,"genesis-ratio"        : pool-tokens
                ,"pool-tokens"          : pool-tokens
                ,"token-lp"             : token-lp

                ,"fee-lp"               : fee-lp
                ,"fee-special"          : 0.0
                ,"fee-special-targets"  : [SWP|EMPTY-TARGET]
                ,"fee-lock"             : false
                ,"unlocks"              : 0

                ,"amplifier"            : amp
                ,"primality"            : p
                ,"frozen-lp"            : false
                ,"sleeping-lp"          : false
                }
            )
            (with-capability (P|SECURE-CALLER)
                (XI_SavePool n what swpair)
                (ref-DPTF::C_DeployAccount token-lp account)
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
    )
    (defun XE_CanAddOrSwapToggle (swpair:string toggle:bool add-or-swap:bool)
        (UEV_IMC)
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
                (local-guard:guard (create-capability-guard (SWP|C>ADD-OR-SWAP swpair toggle add-or-swap)))
                (mg:[guard] (P|UR_IMP))
                (ag:[guard] (+ [local-guard] mg))
            )
            (ref-U|G::UEV_Any ag)
        )
        (if add-or-swap
            (update SWP|Pairs swpair
                {"can-add"                      : toggle}
            )
            (update SWP|Pairs swpair
                {"can-swap"                     : toggle}
            )
        )
    )
    ;;
    (defun XI_ChangeOwnership (swpair:string new-owner:string)
        (require-capability (SWP|S>RT_OWN swpair new-owner))
        (update SWP|Pairs swpair
            {"owner-konto"                      : new-owner}
        )
    )
    (defun XI_IncrementFeeUnlocks (swpair:string)
        (require-capability (SECURE))
        (with-read SWP|Pairs swpair
            { "unlocks" := u }
            (update SWP|Pairs swpair
                {"unlocks" : (+ u 1)}
            )
        )
    )
    (defun XI_ModifyCanChangeOwner (swpair:string new-boolean:bool)
        (require-capability (SWP|S>RT_CAN-CHANGE swpair new-boolean))
        (update SWP|Pairs swpair
            {"can-change-owner"                 : new-boolean}
        )
    )
    (defun XI_SavePool (n:integer what:bool swpair:string)
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
    (defun XI_ToggleFeeLock:[decimal] (swpair:string toggle:bool)
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
    (defun XI_UpdateAmplifier (swpair:string new-amplifier:decimal)
        (with-capability (SWP|S>UPDATE-AMPLIFIER swpair new-amplifier)
            (update SWP|Pairs swpair
                {"amplifier" : new-amplifier}
            )
        )
    )
    (defun XI_UpdateFee (swpair:string new-fee:decimal lp-or-special:bool)
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
    (defun XI_UpdateSpecialFeeTargets (swpair:string targets:[object{SwapperV4.FeeSplit}])
        (require-capability (SPW|S>UPDATE_SPECIAL-FEE-TARGETS swpair targets))
        (update SWP|Pairs swpair
            {"fee-special-targets"                : targets}
        )
    )
    (defun XI_EnableFrozenLP (swpair:string)
        (require-capability (SWP|C>ENABLE-FROZEN swpair))
        (update SWP|Pairs swpair
            {"frozen-lp"    : true}
        )
    )
    (defun XI_EnableSleepingLP (swpair:string)
        (require-capability (SWP|C>ENABLE-SLEEPING swpair))
        (update SWP|Pairs swpair
            {"sleeping-lp"    : true}
        )
    )
)

(create-table P|T)
(create-table P|MT)
(create-table SWP|Properties)
(create-table SWP|Asymmetry)
(create-table SWP|Pairs)
(create-table SWP|Pools)