;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface Autostake
    @doc "Exposes half of the Autostake Functions, the other Functions existing in the ATSU Module \
    \ Also contains a few DPTF and DPMF Functions \
    \ UR(Utility-Read), URC(Utility-Read-Compute), UEV(Utility-Enforce-Validate) and \
    \ UDC(Utility-Data-Composition) are NOT sorted alphabetically \
    \ CX are Client Function with no direct Ouronet Gas-Station Support \
    \ Commented Functions are internal use only, and have no use outside the module"
    ;;
    (defschema ATS|RewardTokenSchema
        token:string
        nfr:bool
        resident:decimal
        unbonding:decimal
    )
    (defschema ATS|Hot
        mint-time:time
    )
    ;;
    (defun GOV|ATS|SC_KDA-NAME ())
    (defun ATS|SetGovernor (patron:string))
    ;;
    (defun UR_P-KEYS:[string] ())
    (defun UR_KEYS:[string] ())
    (defun UR_OwnerKonto:string (atspair:string))
    (defun UR_CanChangeOwner:bool (atspair:string))
    (defun UR_Lock:bool (atspair:string))
    (defun UR_Unlocks:integer (atspair:string))
    (defun UR_IndexName:string (atspair:string))
    (defun UR_IndexDecimals:integer (atspair:string))
    (defun UR_Syphon:decimal (atspair:string))
    (defun UR_Syphoning:bool (atspair:string))
    (defun UR_RewardTokens:[object{ATS|RewardTokenSchema}] (atspair:string))
    (defun UR_ColdRewardBearingToken:string (atspair:string))
    (defun UR_ColdNativeFeeRedirection:bool (atspair:string))
    (defun UR_ColdRecoveryPositions:integer (atspair:string))
    (defun UR_ColdRecoveryFeeThresholds:[decimal] (atspair:string))
    (defun UR_ColdRecoveryFeeTable:[[decimal]] (atspair:string))
    (defun UR_ColdRecoveryFeeRedirection:bool (atspair:string))
    (defun UR_ColdRecoveryDuration:[integer] (atspair:string))
    (defun UR_EliteMode:bool (atspair:string))
    (defun UR_HotRewardBearingToken:string (atspair:string))
    (defun UR_HotRecoveryStartingFeePromile:decimal (atspair:string))
    (defun UR_HotRecoveryDecayPeriod:integer (atspair:string))
    (defun UR_HotRecoveryFeeRedirection:bool (atspair:string))
    (defun UR_ToggleColdRecovery:bool (atspair:string))
    (defun UR_ToggleHotRecovery:bool (atspair:string))
    (defun UR_RewardTokenList:[string] (atspair:string))
    (defun UR_RoUAmountList:[decimal] (atspair:string rou:bool))
    (defun UR_RT-Data (atspair:string reward-token:string data:integer))
    (defun UR_RtPrecisions:[integer] (atspair:string))
    (defun UR_P0:[object{UtilityAts.Awo}] (atspair:string account:string))
    (defun UR_P1-7:object{UtilityAts.Awo} (atspair:string account:string position:integer))
    ;;
    (defun URC_PosObjSt:integer (atspair:string input-obj:object{UtilityAts.Awo}))
    (defun URC_MaxSyphon:[decimal] (atspair:string))
    (defun URC_CullValue:[decimal] (atspair:string input:object{UtilityAts.Awo}))
    (defun URC_AccountUnbondingBalance (atspair:string account:string reward-token:string))
    (defun URC_UnstakeObjectUnbondingValue (atspair:string reward-token:string io:object{UtilityAts.Awo}))
    (defun URC_RewardTokenPosition:integer (atspair:string reward-token:string))
    (defun URC_WhichPosition:integer (atspair:string c-rbt-amount:decimal account:string))
    (defun URC_ElitePosition:integer (atspair:string c-rbt-amount:decimal account:string))
    (defun URC_NonElitePosition:integer (atspair:string account:string))
    (defun URC_PSL:[integer] (atspair:string account:string))
    (defun URC_PosSt:integer (atspair:string account:string position:integer))
    (defun URC_ColdRecoveryFee (atspair:string c-rbt-amount:decimal input-position:integer))
    (defun URC_CullColdRecoveryTime:time (atspair:string account:string))
    (defun URC_RTSplitAmounts:[decimal] (atspair:string rbt-amount:decimal))
    (defun URC_Index (atspair:string))
    (defun URC_PairRBTSupply:decimal (atspair:string))
    (defun URC_RBT:decimal (atspair:string rt:string rt-amount:decimal))
    (defun URC_ResidentSum:decimal (atspair:string))
    (defun URC_IzPresentHotRBT:bool (atspair:string))
    ;;
    (defun UEV_CanChangeOwnerON (atspair:string))
    (defun UEV_RewardTokenExistance (atspair:string reward-token:string existance:bool))
    (defun UEV_RewardBearingTokenExistance (atspair:string reward-bearing-token:string existance:bool cold-or-hot:bool))
    (defun UEV_HotRewardBearingTokenPresence (atspair:string enforced-presence:bool))
    (defun UEV_ParameterLockState (atspair:string state:bool))
    (defun UEV_SyphoningState (atspair:string state:bool))
    (defun UEV_FeeState (atspair:string state:bool fee-switch:integer))
    (defun UEV_EliteState (atspair:string state:bool))
    (defun UEV_RecoveryState (atspair:string state:bool cold-or-hot:bool))
    (defun UEV_UpdateColdOrHot (atspair:string cold-or-hot:bool))
    (defun UEV_UpdateColdAndHot (atspair:string))
    (defun UEV_id (atspair:string))
    (defun UEV_IzTokenUnique (atspair:string reward-token:string))
    (defun UEV_IssueData (atspair:string index-decimals:integer reward-token:string reward-bearing-token:string))
    ;;
    (defun UDC_MakeUnstakeObject:object{UtilityAts.Awo} (atspair:string time:time))
    (defun UDC_MakeZeroUnstakeObject:object{UtilityAts.Awo} (atspair:string))
    (defun UDC_MakeNegativeUnstakeObject:object{UtilityAts.Awo} (atspair:string))
    (defun UDC_ComposePrimaryRewardToken:object{ATS|RewardTokenSchema} (token:string nfr:bool))
    (defun UDC_RT:object{ATS|RewardTokenSchema} (token:string nfr:bool r:decimal u:decimal))
    ;;
    (defun CAP_Owner (id:string))
    ;;
    (defun C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun C_UpgradeBranding (patron:string entity-id:string months:integer))
    ;;
    (defun C_Issue:[string] (patron:string account:string atspair:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string] rbt-nfr:[bool]))
    (defun C_ToggleFeeSettings (patron:string atspair:string toggle:bool fee-switch:integer))
    (defun C_TurnRecoveryOff (patron:string atspair:string cold-or-hot:bool))
    (defun CX_EnsureActivationRoles (patron:string atspair:string cold-or-hot:bool))
    (defun CX_MassTurnColdRecoveryOff (patron:string id:string))
    (defun CX_RevokeBurn (patron:string id:string cold-or-hot:bool))
    (defun CX_RevokeCreateOrAddQ (patron:string id:string))
    (defun CX_RevokeFeeExemption (patron:string id:string))
    (defun CX_RevokeMint (patron:string id:string))
    (defun CX_SetMassRole (patron:string atspair:string burn-or-exemption:bool))
    (defun DPMF|C_MoveCreateRole (patron:string id:string receiver:string))
    (defun DPMF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool))
    (defun DPMF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool))
    (defun DPTF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool))
    (defun DPTF|C_ToggleFeeExemptionRole (patron:string id:string account:string toggle:bool))
    (defun DPTF|C_ToggleMintRole (patron:string id:string account:string toggle:bool))
    ;;
    (defun XE_AddHotRBT (atspair:string hot-rbt:string))
    (defun XE_AddSecondary (atspair:string reward-token:string rt-nfr:bool))
    (defun XE_ChangeOwnership (atspair:string new-owner:string))
    (defun XE_IncrementParameterUnlocks (atspair:string))
    (defun XE_ModifyCanChangeOwner (atspair:string new-boolean:bool))
    (defun XE_RemoveSecondary (atspair:string reward-token:string))
    (defun XE_ReshapeUnstakeAccount (atspair:string account:string rp:integer))
    (defun XE_SetColdFee (atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]]))
    (defun XE_SetCRD (atspair:string soft-or-hard:bool base:integer growth:integer))
    (defun XE_SetHotFee (atspair:string promile:decimal decay:integer))
    (defun XE_SpawnAutostakeAccount (atspair:string account:string))
    (defun XE_ToggleElite (atspair:string toggle:bool))
    (defun XE_ToggleParameterLock:[decimal] (atspair:string toggle:bool))
    (defun XE_ToggleSyphoning (atspair:string toggle:bool))
    (defun XE_TurnRecoveryOn (atspair:string cold-or-hot:bool))
    (defun XE_UpdateRoU (atspair:string reward-token:string rou:bool direction:bool amount:decimal))
    (defun XE_UpdateSyphon (atspair:string syphon:decimal))
    (defun XE_UpP0 (atspair:string account:string obj:[object{UtilityAts.Awo}]))
    (defun XE_UpP1 (atspair:string account:string obj:object{UtilityAts.Awo}))
    (defun XE_UpP2 (atspair:string account:string obj:object{UtilityAts.Awo}))
    (defun XE_UpP3 (atspair:string account:string obj:object{UtilityAts.Awo}))
    (defun XE_UpP4 (atspair:string account:string obj:object{UtilityAts.Awo}))
    (defun XE_UpP5 (atspair:string account:string obj:object{UtilityAts.Awo}))
    (defun XE_UpP6 (atspair:string account:string obj:object{UtilityAts.Awo}))
    (defun XE_UpP7 (atspair:string account:string obj:object{UtilityAts.Awo}))
    ;;
    ;(defun XI_Issue:string (account:string atspair:string index-decimals:integer reward-token:string rt-nfr:bool reward-bearing-token:string rbt-nfr:bool))
    ;(defun XI_ToggleFeeSettings (atspair:string toggle:bool fee-switch:integer))
    ;(defun XI_TurnRecoveryOff (atspair:string cold-or-hot:bool))
)
(module ATS GOV
    ;;
    (implements OuronetPolicy)
    (implements BrandingUsage)
    (implements Autostake)
    ;;{G1}
    (defconst GOV|MD_ATS            (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_ATS            (keyset-ref-guard ATS|SC_KEY))
    ;;
    (defconst ATS|SC_KEY            (GOV|AutostakeKey))
    (defconst ATS|SC_NAME           (GOV|ATS|SC_NAME))
    (defconst ATS|SC_KDA-NAME       (GOV|ATS|SC_KDA-NAME))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|ATS_ADMIN)))
    (defcap GOV|ATS_ADMIN ()
        (enforce-one
            "ATS Autostake Admin not satisfed"
            [
                (enforce-guard GOV|MD_ATS)
                (enforce-guard GOV|SC_ATS)
            ]
        )
    )
    (defcap ATS|GOV ()
        @doc "Governor Capability for the Autostake Smart DALOS Account"
        true
    )
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|AutostakeKey ()      (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|AutostakeKey)))
    (defun GOV|ATS|SC_NAME ()       (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|ATS|SC_NAME)))
    (defun GOV|ATS|SC_KDA-NAME ()   (at 0 ["k:89faf537ec7282d55488de28c454448a20659607adc52f875da30a4fd4ed2d12"]))
    (defun ATS|SetGovernor (patron:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-U|G:module{OuronetGuards} U|G)
            )
            (with-capability (P|ATS|CALLER)
                (ref-DALOS::C_RotateGovernor
                    patron
                    ATS|SC_NAME
                    (ref-U|G::UEV_GuardOfAny
                        [
                            (create-capability-guard (ATS|GOV))
                            (P|UR "ATSU|RemoteAtsGov")
                            (P|UR "TFT|RemoteAtsGov")
                        ]
                    )
                )
            )
        )
    )
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    ;;{P3}
    (defcap P|ATS|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|ATS|CALLER))
        (compose-capability (SECURE))
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|ATS_ADMIN)
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
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
            )
            (ref-P|DALOS::P|A_Add 
                "ATS|<"
                (create-capability-guard (P|ATS|CALLER))
            )
            (ref-P|BRD::P|A_Add 
                "ATS|<"
                (create-capability-guard (P|ATS|CALLER))
            )
            (ref-P|DPTF::P|A_Add 
                "ATS|<"
                (create-capability-guard (P|ATS|CALLER))
            )
            (ref-P|DPMF::P|A_Add 
                "ATS|<"
                (create-capability-guard (P|ATS|CALLER))
            )
        )
    )
    ;;
    ;;{1}
    (defschema ATS|PropertiesSchema
        owner-konto:string
        can-change-owner:bool
        parameter-lock:bool
        unlocks:integer
        pair-index-name:string
        index-decimals:integer
        syphon:decimal
        syphoning:bool
        reward-tokens:[object{Autostake.ATS|RewardTokenSchema}]
        c-rbt:string
        c-nfr:bool
        c-positions:integer
        c-limits:[decimal]
        c-array:[[decimal]]
        c-fr:bool
        c-duration:[integer]
        c-elite-mode:bool
        h-rbt:string
        h-promile:decimal
        h-decay:integer
        h-fr:bool
        cold-recovery:bool
        hot-recovery:bool
    )
    (defschema ATS|BalanceSchema
        @doc "Key = <ATS-Pair> + BAR + <account>"
        P0:[object{UtilityAts.Awo}]
        P1:object{UtilityAts.Awo}
        P2:object{UtilityAts.Awo}
        P3:object{UtilityAts.Awo}
        P4:object{UtilityAts.Awo}
        P5:object{UtilityAts.Awo}
        P6:object{UtilityAts.Awo}
        P7:object{UtilityAts.Awo}
    )
    ;;{2}
    (deftable ATS|Pairs:{ATS|PropertiesSchema})
    (deftable ATS|Ledger:{ATS|BalanceSchema})
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    (defconst NULLTIME              (time "1984-10-11T11:10:00Z"))
    (defconst ANTITIME              (time "1983-08-07T11:10:00Z"))
    ;;
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    (defcap ATS|S>RT_OWN (atspair:string new-owner:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::UEV_SenderWithReceiver (UR_OwnerKonto atspair) new-owner)
            (ref-DALOS::UEV_EnforceAccountExists new-owner)
            (UEV_CanChangeOwnerON atspair)
            (CAP_Owner atspair)
        )
    )
    (defcap ATS|S>RT_CAN-CHANGE (atspair:string new-boolean:bool)
        @event
        (let
            (
                (current:bool (UR_CanChangeOwner atspair))
            )
            (enforce (!= current new-boolean) "Similar boolean cannot be used for this function")
            (CAP_Owner atspair)
        )
    )
    (defcap ATS|S>TG_PRM-LOCK (atspair:string toggle:bool)
        @event
        (let
            (
                (x:bool (UR_ToggleColdRecovery atspair))
                (y:bool (UR_ToggleHotRecovery atspair))
            )
            (UEV_ParameterLockState atspair (not toggle))
            (CAP_Owner atspair)
            (enforce-one
                (format "ATS <parameter-lock> cannot be toggled when both <cold-recovery> and <hot-recovery> are set to false")
                [
                    (enforce (= x true) (format "Cold-recovery for ATS Pair {} must be set to <true> for this operation" [atspair]))
                    (enforce (= y true) (format "Hot-recovery for ATS Pair {} must be set to <true> for this operation" [atspair]))
                ]
            )
        )
    )
    (defcap ATS|S>SYPHON (atspair:string syphon:decimal)
        @event
        (let
            (
                (precision:integer (UR_IndexDecimals atspair))
            )
            (CAP_Owner atspair)
            (enforce (>= syphon 0.1) "Syphon cannot be set lower than 0.1")
            (enforce
                (= (floor syphon precision) syphon)
                (format "The syphon value of {} is not a valid Index Value for the {} ATS Pair" [syphon atspair])
            )
        )
    )
    (defcap ATS|S>SYPHONING (atspair:string toggle:bool)
        @event
        (UEV_SyphoningState atspair (not toggle))
        (UEV_ParameterLockState atspair false)
        (CAP_Owner atspair)
    )
    (defcap ATS|S>TG_FEE (atspair:string toggle:bool fee-switch:integer)
        @event
        (UEV_FeeState atspair (not toggle) fee-switch)
        (UEV_ParameterLockState atspair false)
        (CAP_Owner atspair)
        (enforce (contains fee-switch (enumerate 0 2)) "Integer not a valid fee-switch integer")
        (if (or (= fee-switch 0)(= fee-switch 1))
            (UEV_UpdateColdOrHot atspair true)
            (UEV_UpdateColdOrHot atspair false)
        )
    )
    (defcap ATS|S>SET_CRD (atspair:string soft-or-hard:bool base:integer growth:integer)
        @event
        (UEV_UpdateColdOrHot atspair true)
        (UEV_ParameterLockState atspair false)
        (CAP_Owner atspair)
        (if (= soft-or-hard true)
            (enforce 
                (and 
                    (= (mod base growth) 0)
                    (= (mod growth 3) 0)
                ) 
                (format "{} as base and {} as growth are incompatible with the Soft Method for generation of CRD" [base growth])
            )
            (enforce 
                (= (mod base growth) 0)
                (format "{} as base and {} as growth are incompatible with the Hard Method for generation of CRD" [base growth])    
            )
        )
    )
    (defcap ATS|S>SET_COLD_FEE (atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        @event
        (let
            (
                (ref-U|DEC:module{OuronetDecimals} U|DEC)
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                (ref-U|ATS:module{UtilityAts} U|ATS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (UEV_UpdateColdOrHot atspair true)
            (UEV_ParameterLockState atspair false)
            (CAP_Owner atspair)
            (enforce 
                (or 
                    (= fee-positions -1)
                    (contains fee-positions (enumerate 1 7))
                )
                "The Number of Fee Positions must be either -1 or between 1 and 7"
            )
            (enforce 
                (and
                    (>= (length fee-thresholds) 1)
                    (<= (length fee-thresholds) 100)
                )
                "No More than 100 Fee Threhsolds can be set"
            )
            (fold
                (lambda
                    (acc:bool idx:integer)
                    (let
                        (
                            (current:decimal (at idx fee-thresholds))
                            (precision:integer (ref-DPTF::UR_Decimals (UR_ColdRewardBearingToken atspair)))
                        )
                        (if (<= idx (- (length fee-thresholds) 2))
                            (let
                                (
                                    (next:decimal (at (+ idx 1) fee-thresholds))
                                )
                                (enforce 
                                    (< current next)
                                    (format "Current Amount {} must be smaller than the next Amount in the Threhsold List" [current next])
                                )
                            )
                            true
                        )
                        (enforce
                            (= (floor current precision) current)
                            (format "The Amount of {} does not conform with the CRBT decimals number" [current])
                        )
                        acc
                    )
                )
                true
                (enumerate 0 (- (length fee-thresholds) 1))
            )
            (if (= (ref-U|ATS::UC_ZeroColdFeeExceptionBoolean fee-thresholds fee-array) true)
                (if (= fee-positions -1)
                    (enforce (= (length fee-array) 1) "The input <fee-array> must be of length 1")
                    (enforce (= (length fee-array) fee-positions) (format "The input <fee-array> must be of length {}" [fee-positions]))
                )
                true
            )
            (ref-U|DEC::UEV_DecimalArray fee-array)
            (if (= (ref-U|ATS::UC_ZeroColdFeeExceptionBoolean fee-thresholds fee-array) true)
                (enforce
                    (= (length (at 0 fee-array)) (+ (length fee-thresholds) 1))
                    "Inner Lists of the <fee-array> are incompatible with the <fee-thresholds> length"
                )
                true
            )
            (map
                (lambda 
                    (inner-lst:[decimal])
                    (map
                        (lambda 
                            (fee:decimal)
                            (do
                                (ref-U|DALOS::UEV_Fee fee)
                                (enforce (>= fee 0.0) "As ATSPair Cold Fee, greater than zero !")
                            )
                            
                        )
                        inner-lst
                    )
                )
                fee-array
            )
        )
        
    )
    (defcap ATS|S>SET_HOT_FEE (atspair:string promile:decimal decay:integer)
        @event
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
            )
            (ref-U|DALOS::UEV_Fee promile)
            (UEV_UpdateColdOrHot atspair false)
            (UEV_ParameterLockState atspair false)
            (CAP_Owner atspair)
            (enforce (> promile 0.0) "As ATSPair Hot Fee, Fee Value must be positive !")
            (enforce 
                (and
                    (>= decay 1)
                    (<= decay 9125)
                )
                "No More than 25 years (9125 days) can be set for Decay Period"
            )
        )
        
    )
    (defcap ATS|S>TOGGLE_ELITE (atspair:string toggle:bool)
        @event
        (UEV_UpdateColdOrHot atspair true)
        (UEV_EliteState atspair (not toggle))
        (UEV_ParameterLockState atspair false)
        (CAP_Owner atspair)
        (if (= toggle true)
            (let
                (
                    (x:integer (UR_ColdRecoveryPositions atspair))
                )
                (enforce (= x 7) (format "Cold Recovery Positions for ATS Pair {} must be set to 7 for this operation" [atspair]))
            )
            true
        )
    )
    (defcap ATS|S>RECOVERY-ON (atspair:string cold-or-hot:bool)
        @event
        (UEV_ParameterLockState atspair false)
        (UEV_RecoveryState atspair false cold-or-hot)
        (CAP_Owner atspair)
    )
    (defcap ATS|S>RECOVERY-OFF (atspair:string cold-or-hot:bool)
        @event
        (UEV_ParameterLockState atspair false)
        (UEV_RecoveryState atspair true cold-or-hot)
        (CAP_Owner atspair)
    )
    (defcap ATS|S>ADD_SEC_RT (atspair:string reward-token:string)
        @event
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DPTF::CAP_Owner reward-token)
            (UEV_IzTokenUnique atspair reward-token)
            (UEV_RewardTokenExistance atspair reward-token false)
        )
    )
    (defcap ATS|S>ADD_SEC_RBT (atspair:string hot-rbt:string)
        @event
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (ref-DPMF::UEV_Vesting hot-rbt false)
            (ref-DPMF::CAP_Owner hot-rbt)
            (UEV_HotRewardBearingTokenPresence atspair false)
        )
    )
    ;;{C3}
    (defcap ATS|F>OWNER (atspair:string)
        (CAP_Owner atspair)
    )
    ;;{C4}
    (defcap ATS|C>UPDATE-BRD (atspair:string)
        @event
        (CAP_Owner atspair)
        (compose-capability (P|ATS|CALLER))
    )
    (defcap ATS|C>UPGRADE-BRD (atspair:string)
        @event
        (compose-capability (P|ATS|CALLER))
    )
    (defcap ATS|C>ADD_SECONDARY (atspair:string reward-token:string token-type:bool)
        @event
        (UEV_UpdateColdAndHot atspair)
        (UEV_ParameterLockState atspair false)
        (CAP_Owner atspair)
        (if (= token-type true)
            (compose-capability (ATS|S>ADD_SEC_RT atspair reward-token))
            (compose-capability (ATS|S>ADD_SEC_RBT atspair reward-token))
        )
    )
    (defcap ATSI|C>ISSUE (account:string atspair:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string]rbt-nfr:[bool])
        @event
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (l1:integer (length atspair))
                (l2:integer (length index-decimals))
                (l3:integer (length reward-token))
                (l4:integer (length rt-nfr))
                (l5:integer (length reward-bearing-token))
                (l6:integer (length rbt-nfr))
                (lengths:[integer] [l1 l2 l3 l4 l5 l6])
            )
            (ref-U|INT::UEV_UniformList lengths)
            (ref-U|LST::UC_IzUnique atspair)
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (map
                (lambda
                    (index:integer)
                    (UEV_IssueData (ref-U|DALOS::UDC_Makeid (at index atspair)) (at index index-decimals) (at index reward-token) (at index reward-bearing-token))

                )
                (enumerate 0 (- l1 1))
            )
            (compose-capability (P|ATS|CALLER))
            (compose-capability (SECURE))
        )
    )
    ;;
    ;;{F0}
    (defun UR_P-KEYS:[string] ()
        (keys ATS|Pairs)
    )
    (defun UR_KEYS:[string] ()
        (keys ATS|Ledger)
    )
    (defun UR_OwnerKonto:string (atspair:string)
        (at "owner-konto" (read ATS|Pairs atspair ["owner-konto"]))
    )
    (defun UR_CanChangeOwner:bool (atspair:string)
        (at "can-change-owner" (read ATS|Pairs atspair ["can-change-owner"]))
    )
    (defun UR_Lock:bool (atspair:string)
        (at "parameter-lock" (read ATS|Pairs atspair ["parameter-lock"]))
    )
    (defun UR_Unlocks:integer (atspair:string)
        (at "unlocks" (read ATS|Pairs atspair ["unlocks"]))
    )
    (defun UR_IndexName:string (atspair:string)
        (at "pair-index-name" (read ATS|Pairs atspair ["pair-index-name"]))
    )
    (defun UR_IndexDecimals:integer (atspair:string)
        (at "index-decimals" (read ATS|Pairs atspair ["index-decimals"]))
    )
    (defun UR_Syphon:decimal (atspair:string)
        (at "syphon" (read ATS|Pairs atspair ["syphon"]))
    )
    (defun UR_Syphoning:bool (atspair:string)
        (at "syphoning" (read ATS|Pairs atspair ["syphoning"]))
    )
    (defun UR_RewardTokens:[object{Autostake.ATS|RewardTokenSchema}] (atspair:string)
        (at "reward-tokens" (read ATS|Pairs atspair ["reward-tokens"]))
    )
    (defun UR_ColdRewardBearingToken:string (atspair:string)
        (at "c-rbt" (read ATS|Pairs atspair ["c-rbt"]))
    )
    (defun UR_ColdNativeFeeRedirection:bool (atspair:string)
        (at "c-nfr" (read ATS|Pairs atspair ["c-nfr"]))
    )
    (defun UR_ColdRecoveryPositions:integer (atspair:string)
        (at "c-positions" (read ATS|Pairs atspair ["c-positions"]))
    )
    (defun UR_ColdRecoveryFeeThresholds:[decimal] (atspair:string)
        (at "c-limits" (read ATS|Pairs atspair ["c-limits"]))
    )
    (defun UR_ColdRecoveryFeeTable:[[decimal]] (atspair:string)
        (at "c-array" (read ATS|Pairs atspair ["c-array"]))
    )
    (defun UR_ColdRecoveryFeeRedirection:bool (atspair:string)
        (at "c-fr" (read ATS|Pairs atspair ["c-fr"]))
    )
    (defun UR_ColdRecoveryDuration:[integer] (atspair:string)
        (at "c-duration" (read ATS|Pairs atspair ["c-duration"]))
    )
    (defun UR_EliteMode:bool (atspair:string)
        (at "c-elite-mode" (read ATS|Pairs atspair ["c-elite-mode"]))
    )
    (defun UR_HotRewardBearingToken:string (atspair:string)
        (at "h-rbt" (read ATS|Pairs atspair ["h-rbt"]))
    )
    (defun UR_HotRecoveryStartingFeePromile:decimal (atspair:string)
        (at "h-promile" (read ATS|Pairs atspair ["h-promile"]))
    )
    (defun UR_HotRecoveryDecayPeriod:integer (atspair:string)
        (at "h-decay" (read ATS|Pairs atspair ["h-decay"]))
    )
    (defun UR_HotRecoveryFeeRedirection:bool (atspair:string)
        (at "h-fr" (read ATS|Pairs atspair ["h-fr"]))
    )
    (defun UR_ToggleColdRecovery:bool (atspair:string)
        (at "cold-recovery" (read ATS|Pairs atspair ["cold-recovery"]))
    )
    (defun UR_ToggleHotRecovery:bool (atspair:string)
        (at "hot-recovery" (read ATS|Pairs atspair ["hot-recovery"]))
    )
    (defun UR_RewardTokenList:[string] (atspair:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[string] item:object{Autostake.ATS|RewardTokenSchema})
                    (ref-U|LST::UC_AppL acc (at "token" item))
                )
                []
                (UR_RewardTokens atspair)
            )
        )
    )
    (defun UR_RoUAmountList:[decimal] (atspair:string rou:bool)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[decimal] item:object{Autostake.ATS|RewardTokenSchema})
                    (if rou
                        (ref-U|LST::UC_AppL acc (at "resident" item))
                        (ref-U|LST::UC_AppL acc (at "unbonding" item))
                    )
                )
                []
                (UR_RewardTokens atspair)
            )
        )
    )
    (defun UR_RT-Data (atspair:string reward-token:string data:integer)
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (rt:[object{Autostake.ATS|RewardTokenSchema}] (UR_RewardTokens atspair))
                (rtp:integer (URC_RewardTokenPosition atspair reward-token))
                (rto:object{Autostake.ATS|RewardTokenSchema} (at rtp rt))
            )
            (ref-U|INT::UEV_PositionalVariable data 3 "Invalid Data Integer")
            (UEV_id atspair)
            (cond
                ((= data 1) (at "nfr" rto))
                ((= data 2) (at "resident" rto))
                ((= data 3) (at "unbonding" rto))
                true
            )
        )
    )
    (defun UR_RtPrecisions:[integer] (atspair:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (fold
                (lambda
                    (acc:[integer] rt:string)
                    (ref-U|LST::UC_AppL acc (ref-DPTF::UR_Decimals rt))
                )
                []
                (UR_RewardTokenList atspair)
            )
        )
    )
    (defun UR_P0:[object{UtilityAts.Awo}] (atspair:string account:string)
        (at "P0" (read ATS|Ledger (concat [atspair BAR account]) ["P0"]))
    )
    (defun UR_P1-7:object{UtilityAts.Awo} (atspair:string account:string position:integer)
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
            )
            (ref-U|INT::UEV_PositionalVariable position 7 "Invalid Position Number")
            (cond
                ((= position 1) (at "P1" (read ATS|Ledger (concat [atspair BAR account]) ["P1"])))
                ((= position 2) (at "P2" (read ATS|Ledger (concat [atspair BAR account]) ["P2"])))
                ((= position 3) (at "P3" (read ATS|Ledger (concat [atspair BAR account]) ["P3"])))
                ((= position 4) (at "P4" (read ATS|Ledger (concat [atspair BAR account]) ["P4"])))
                ((= position 5) (at "P5" (read ATS|Ledger (concat [atspair BAR account]) ["P5"])))
                ((= position 6) (at "P6" (read ATS|Ledger (concat [atspair BAR account]) ["P6"])))
                ((= position 7) (at "P7" (read ATS|Ledger (concat [atspair BAR account]) ["P7"])))
                true
            )
        )
    )
    ;;{F1}
    (defun URC_PosObjSt:integer (atspair:string input-obj:object{UtilityAts.Awo})
        @doc "occupied(0), opened(1), closed (-1)"
        (let
            (
                (zero:object{UtilityAts.Awo} (UDC_MakeZeroUnstakeObject atspair))
                (negative:object{UtilityAts.Awo} (UDC_MakeNegativeUnstakeObject atspair))
            )
            (if (= input-obj zero)
                1
                (if (= input-obj negative)
                    -1
                    0
                )
            )
        )
    )
    (defun URC_MaxSyphon:[decimal] (atspair:string)
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (index:decimal (URC_Index atspair))
                (syphon:decimal (UR_Syphon atspair))
                (resident-rt-amounts:[decimal] (UR_RoUAmountList atspair true))
                (precisions:[integer] (UR_RtPrecisions atspair))
                (max-precision:integer (ref-U|INT::UC_MaxInteger precisions))
                (max-pp:integer (at 0 (ref-U|LST::UC_Search precisions max-precision)))
                (pair-rbt-supply:decimal (URC_PairRBTSupply atspair))
            )
            (if (<= index syphon)
                (make-list (length precisions) 0.0)
                (let
                    (
                        (index-diff:decimal (- index syphon))
                        (rbt:string (UR_ColdRewardBearingToken atspair))
                        (rbt-precision:integer (ref-DPTF::UR_Decimals rbt))
                        (max-sum:decimal (floor (* pair-rbt-supply index-diff) rbt-precision))
                        (prelim:[decimal]
                            (fold
                                (lambda
                                    (acc:[decimal] idx:integer)
                                    (ref-U|LST::UC_AppL acc 
                                        (floor (/ (* (- index syphon) (at idx resident-rt-amounts)) index) (at idx precisions))
                                    )
                                )
                                []
                                (enumerate 0 (- (length precisions) 1))
                            )
                        )
                        (prelim-sum:decimal (fold (+) 0.0 prelim))
                        (diff:decimal (- max-sum prelim-sum))
                    )
                    (if (= diff 0.0)
                        prelim
                        (ref-U|LST::UC_ReplaceAt prelim max-pp (+ diff (at max-pp prelim)))
                    )
                )
            )
        )
    )
    (defun URC_CullValue:[decimal] (atspair:string input:object{UtilityAts.Awo})
        (let
            (
                (ref-U|ATS:module{UtilityAts} U|ATS)
                (rt-lst:[string] (UR_RewardTokenList atspair))
                (rt-amounts:[decimal] (at "reward-tokens" input))
                (l:integer (length rt-lst))
                (iz:bool (ref-U|ATS::UC_IzCullable input))
            )
            (if iz
                rt-amounts
                (make-list l 0.0)
            )
        )
    )
    (defun URC_AccountUnbondingBalance (atspair:string account:string reward-token:string)
        (+
            (fold
                (lambda
                    (acc:decimal item:object{UtilityAts.Awo})
                    (+ acc (URC_UnstakeObjectUnbondingValue atspair reward-token item))
                )
                0.0
                (UR_P0 atspair account)
            )
            (fold
                (lambda
                    (acc:decimal item:integer)
                    (+ acc (URC_UnstakeObjectUnbondingValue atspair reward-token (UR_P1-7 atspair account item)))
                )
                0.0
                (enumerate 1 7)
            )
        )
    )
    (defun URC_UnstakeObjectUnbondingValue (atspair:string reward-token:string io:object{UtilityAts.Awo})
        (let
            (
                (rtp:integer (URC_RewardTokenPosition atspair reward-token))
                (rt:[decimal] (at "reward-tokens" io))
                (rb:decimal (at rtp rt))
            )
            (if (= rb -1.0)
                0.0
                rb
            )
        )
    )
    (defun URC_RewardTokenPosition:integer (atspair:string reward-token:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (existance-check:bool (ref-DPTF::URC_IzRTg atspair reward-token))
            )
            (enforce (= existance-check true) (format "{} Existance isnt verified for Token {} as RT with ATS Pair {}" [true reward-token atspair]))
            (at 0 (ref-U|LST::UC_Search (UR_RewardTokenList atspair) reward-token))
        )
    )
    (defun URC_WhichPosition:integer (atspair:string c-rbt-amount:decimal account:string)
        (let
            (
                (elite:bool (UR_EliteMode atspair))
            )
            (if elite
                (URC_ElitePosition atspair c-rbt-amount account)
                (URC_NonElitePosition atspair account)
            )
        )
    )
    (defun URC_ElitePosition:integer (atspair:string c-rbt-amount:decimal account:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|ATS:module{UtilityAts} U|ATS)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (positions:integer (UR_ColdRecoveryPositions atspair))
                (c-rbt:string (UR_ColdRewardBearingToken atspair))
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
            )
            (if (!= ea-id BAR)
                (let
                    (
                        (iz-ea-id:bool (if (= ea-id c-rbt) true false))
                        (pstate:[integer] (URC_PSL atspair account))
                        (met:integer (ref-DALOS::UR_Elite-Tier-Major account))
                        (ea-supply:decimal (ref-DPTF::UR_AccountSupply ea-id account))
                        (t-ea-supply:decimal (ref-DPMF::URC_EliteAurynzSupply account))
                        (virtual-met:integer (str-to-int (take 1 (at "tier" (ref-U|ATS::UDC_Elite (- t-ea-supply c-rbt-amount))))))
                        (available:[integer] (if iz-ea-id (take virtual-met pstate) (take met pstate)))
                        (search-res:[integer] (ref-U|LST::UC_Search available 1))
                    )
                    (if iz-ea-id
                        (enforce (<= c-rbt-amount ea-supply) "Amount of EA used for Cold Recovery cannot be greater than what exists on Account")
                        true
                    )
                    (if (= (length search-res) 0)
                        0
                        (+ (at 0 search-res) 1)
                    )
                )
                (URC_NonElitePosition atspair account)
            )
        )
    )
    (defun URC_NonElitePosition:integer (atspair:string account:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (positions:integer (UR_ColdRecoveryPositions atspair))
            )
            (if (= positions -1)
                -1
                (let
                    (
                        (pstate:[integer] (URC_PSL atspair account))
                        (available:[integer] (take positions pstate))
                        (search-res:[integer] (ref-U|LST::UC_Search available 1))
                    )
                    (if (= (length search-res) 0)
                        0
                        (+ (at 0 search-res) 1)
                    )
                )
            )
        )
    )
    (defun URC_PSL:[integer] (atspair:string account:string)
        (let
            (
                (p1s:integer (URC_PosSt atspair account 1))
                (p2s:integer (URC_PosSt atspair account 2))
                (p3s:integer (URC_PosSt atspair account 3))
                (p4s:integer (URC_PosSt atspair account 4))
                (p5s:integer (URC_PosSt atspair account 5))
                (p6s:integer (URC_PosSt atspair account 6))
                (p7s:integer (URC_PosSt atspair account 7))
            )
            [p1s p2s p3s p4s p5s p6s p7s]
        )
    )
    (defun URC_PosSt:integer (atspair:string account:string position:integer)
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
            )
            (ref-U|INT::UEV_PositionalVariable position 7 "Input Position out of bounds")
            (with-read ATS|Ledger (concat [atspair BAR account])
                { "P1"  := p1 , "P2"  := p2 , "P3"  := p3, "P4"  := p4, "P5"  := p5, "P6"  := p6, "P7"  := p7 }
                (let
                    (
                        (ps1:integer (URC_PosObjSt atspair p1))
                        (ps2:integer (URC_PosObjSt atspair p2))
                        (ps3:integer (URC_PosObjSt atspair p3))
                        (ps4:integer (URC_PosObjSt atspair p4))
                        (ps5:integer (URC_PosObjSt atspair p5))
                        (ps6:integer (URC_PosObjSt atspair p6))
                        (ps7:integer (URC_PosObjSt atspair p7))
                    )
                    (cond
                        ((= position 1) ps1)
                        ((= position 2) ps2)
                        ((= position 3) ps3)
                        ((= position 4) ps4)
                        ((= position 5) ps5)
                        ((= position 6) ps6)
                        ps7
                    )
                )
            )
        )
    )
    (defun URC_ColdRecoveryFee (atspair:string c-rbt-amount:decimal input-position:integer)
        (let
            (
                (ats-positions:integer (UR_ColdRecoveryPositions atspair))
                (ats-limit-values:[decimal] (UR_ColdRecoveryFeeThresholds atspair))
                (ats-limits:integer (length ats-limit-values))
                (ats-fee-array:[[decimal]] (UR_ColdRecoveryFeeTable atspair))
                (ats-fee-array-length:integer (length ats-fee-array))
                (ats-fee-array-length-length:integer (length (at 0 ats-fee-array)))
                (zc1:bool (if (= ats-limits 1) true false))
                (zc2:bool (if (= (at 0 ats-limit-values) 0.0) true false))
                (zc3:bool (and zc1 zc2))
                (zc4:bool (if (= ats-fee-array-length 1) true false))
                (zc5:bool (if (= ats-fee-array-length-length 1) true false))
                (zc6:bool (and zc4 zc5))
                (zc7:bool (if (= (at 0 (at 0 ats-fee-array)) 0.0) true false))
                (zc8:bool (and zc6 zc7))
                (zc9:bool (and zc3 zc8))
            )
            (enforce (<= input-position ats-positions) "Input position out of bounds")
            (if zc9
                0.0
                (let
                    (
                        (limit:integer
                            (fold
                                (lambda
                                    (acc:integer tv:decimal)
                                    (if (< c-rbt-amount tv)
                                        acc
                                        (+ acc 1)
                                    )
                                )
                                0
                                ats-limit-values
                            )
                        )
                        (qlst:[decimal] 
                            (if (= input-position -1)
                                (at 0 ats-fee-array)
                                (at (- input-position 1) ats-fee-array)
                            )
                        )
                    )
                    (at limit qlst)
                )
            )
        )
    )
    (defun URC_CullColdRecoveryTime:time (atspair:string account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (major:integer (ref-DALOS::UR_Elite-Tier-Major account))
                (minor:integer (ref-DALOS::UR_Elite-Tier-Minor account))
                (position:integer 
                    (if (= major 0)
                        0
                        (+ (* (- major 1) 7) minor)
                    )
                )
                (crd:[integer] (UR_ColdRecoveryDuration atspair))
                (h:integer (at position crd))
                (present-time:time (at "block-time" (chain-data)))
            )
            (add-time present-time (hours h))
        )
    )
    (defun URC_RTSplitAmounts:[decimal] (atspair:string rbt-amount:decimal)
        (let
            (
                (ref-U|ATS:module{UtilityAts} U|ATS)
                (rbt-supply:decimal (URC_PairRBTSupply atspair))
                (index:decimal (URC_Index atspair))
                (resident-amounts:[decimal] (UR_RoUAmountList atspair true))
                (rt-precision-lst:[integer] (UR_RtPrecisions atspair))
            )
            (enforce (<= rbt-amount rbt-supply) "Cannot compute for amounts greater than the pairs rbt supply")
            (ref-U|ATS::UC_SplitByIndexedRBT rbt-amount rbt-supply index resident-amounts rt-precision-lst)
        )
    )
    (defun URC_Index (atspair:string)
        (let
            (
                (p:integer (UR_IndexDecimals atspair))
                (rs:decimal (URC_ResidentSum atspair))
                (rbt-supply:decimal (URC_PairRBTSupply atspair))
            )
            (if
                (= rbt-supply 0.0)
                -1.0
                (floor (/ rs rbt-supply) p)
            )
        )
    )
    (defun URC_PairRBTSupply:decimal (atspair:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (c-rbt:string (UR_ColdRewardBearingToken atspair))
                (c-rbt-supply:decimal (ref-DPTF::UR_Supply c-rbt))
            )
            (if (= (URC_IzPresentHotRBT atspair) false)
                c-rbt-supply
                (let
                    (
                        (h-rbt:string (UR_HotRewardBearingToken atspair))
                        (h-rbt-supply:decimal (ref-DPMF::UR_Supply h-rbt))
                    )
                    (+ c-rbt-supply h-rbt-supply)
                )
            )
        )
    )
    (defun URC_RBT:decimal (atspair:string rt:string rt-amount:decimal)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (index:decimal (abs (URC_Index atspair)))
                (c-rbt:string (UR_ColdRewardBearingToken atspair))
                (p-rbt:integer (ref-DPTF::UR_Decimals c-rbt))
            )
            (enforce
                (= (floor rt-amount p-rbt) rt-amount)
                (format "The entered amount of {} must have at most, the precision c-rbt token {} which is {}" [rt-amount c-rbt p-rbt])
            )
            (floor (/ rt-amount index) p-rbt)
        )
    )
    (defun URC_ResidentSum:decimal (atspair:string)
        (fold (+) 0.0 (UR_RoUAmountList atspair true)) 
    )
    (defun URC_IzPresentHotRBT:bool (atspair:string)
        (if (= (UR_HotRewardBearingToken atspair) BAR)
            false
            true
        )
    )
    ;;{F2}
    (defun UEV_CanChangeOwnerON (atspair:string)
        (UEV_id atspair)
        (let
            (
                (x:bool (UR_CanChangeOwner atspair))
            )
            (enforce (= x true) (format "ATS Pair {} ownership cannot be changed" [atspair]))
        )
    )
    (defun UEV_RewardTokenExistance (atspair:string reward-token:string existance:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (existance-check:bool (ref-DPTF::URC_IzRTg atspair reward-token))
            )
            (enforce (= existance-check existance) (format "{} Existance isnt verified for Token {} as RT with ATS Pair {}" [existance reward-token atspair]))
        )
    )
    (defun UEV_RewardBearingTokenExistance (atspair:string reward-bearing-token:string existance:bool cold-or-hot:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (existance-check:bool 
                    (if cold-or-hot
                        (ref-DPTF::URC_IzRBTg atspair reward-bearing-token)
                        (ref-DPMF::URC_IzRBTg atspair reward-bearing-token)
                    ) 
                )
            )
            (enforce (= existance-check existance) (format "{} Existance isnt verified for Token {} as RBT with ATS Pair {}" [existance reward-bearing-token atspair]))
        )
    )
    (defun UEV_HotRewardBearingTokenPresence (atspair:string enforced-presence:bool)
        (let
            (
                (presence-check:bool (URC_IzPresentHotRBT atspair))
            )
            (enforce (= presence-check enforced-presence) (format "ATS Pair {} cant verfiy {} presence for a Hot RBT Token" [atspair enforced-presence]))
        )
    )
    (defun UEV_ParameterLockState (atspair:string state:bool)
        (let
            (
                (x:bool (UR_Lock atspair))
            )
            (enforce (= x state) (format "Parameter-lock for ATS Pair {} must be set to {} for this operation" [atspair state]))
        )
    )
    (defun UEV_SyphoningState (atspair:string state:bool)
        (let
            (
                (x:bool (UR_Syphoning atspair))
            )
            (enforce (= x state) (format "Syphoning for ATS Pair {} must be set to {} for this operation" [atspair state]))
        )
    )
    (defun UEV_FeeState (atspair:string state:bool fee-switch:integer)
        (let
            (
                (x:bool (UR_ColdNativeFeeRedirection atspair))
                (y:bool (UR_ColdRecoveryFeeRedirection atspair))
                (z:bool (UR_HotRecoveryFeeRedirection atspair))
            )
            (if (= fee-switch 0)
                (enforce (= x state) (format "Cold-NFR for ATS Pair {} must be set to {} for this operation" [atspair state]))
                (if (= fee-switch 1)
                    (enforce (= y state) (format "Cold-RFR for ATS Pair {} must be set to {} for this operation" [atspair state]))
                    (enforce (= z state) (format "Hot-RFR for ATS Pair {} must be set to {} for this operation" [atspair state]))
                )
            )
        )
    )
    (defun UEV_EliteState (atspair:string state:bool)
        (let
            (
                (x:bool (UR_EliteMode atspair))
            )
            (enforce (= x state) (format "Elite-Mode for ATS Pair {} must be set to {} for this operation" [atspair state]))
        )
    )
    (defun UEV_RecoveryState (atspair:string state:bool cold-or-hot:bool)
        (let
            (
                (x:bool (UR_ToggleColdRecovery atspair))
                (y:bool (UR_ToggleHotRecovery atspair))
            )
            (if cold-or-hot
                (enforce (= x state) (format "Cold-recovery for ATS Pair {} must be set to {} for this operation" [atspair state]))
                (enforce (= y state) (format "Hot-recovery for ATS Pair {} must be set to {} for this operation" [atspair state]))
            )
        )
    )
    (defun UEV_UpdateColdOrHot (atspair:string cold-or-hot:bool)
        (UEV_ParameterLockState atspair false)
        (if cold-or-hot
            (UEV_RecoveryState atspair false true)
            (UEV_RecoveryState atspair false false)
        )
    )
    (defun UEV_UpdateColdAndHot (atspair:string)
        (UEV_ParameterLockState atspair false)
        (UEV_RecoveryState atspair false true)
        (UEV_RecoveryState atspair false false)
    )
    (defun UEV_id (atspair:string)
        (let
            (
                (ref-U|ATS:module{UtilityAts} U|ATS)
            )
            (ref-U|ATS::UEV_UniqueAtspair atspair)
            (with-default-read ATS|Pairs atspair
                { "unlocks" : -1 }
                { "unlocks" := u }
                (enforce
                    (>= u 0)
                    (format "ATS-Pair {} does not exist" [atspair])
                )
            )
        )
    )
    (defun UEV_IzTokenUnique (atspair:string reward-token:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (rtl:[string] (UR_RewardTokenList atspair))
            )
            (ref-DPTF::UEV_id reward-token)
            (enforce 
                (= (contains reward-token rtl) false) 
                (format "Token {} already exists as Reward Token for the ATS Pair {}" [reward-token atspair])
            )     
        )
    )
    (defun UEV_IssueData (atspair:string index-decimals:integer reward-token:string reward-bearing-token:string)
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-U|DALOS::UEV_Decimals index-decimals)
            (ref-DPTF::CAP_Owner reward-token)
            (ref-DPTF::CAP_Owner reward-bearing-token)
            (ref-DPTF::UEV_id reward-token)
            (ref-DPTF::UEV_id reward-bearing-token)
            (UEV_RewardTokenExistance atspair reward-token false)
            (UEV_RewardBearingTokenExistance atspair reward-bearing-token false true)
            (enforce (!= reward-token reward-bearing-token) "RT must be different from RBT")
        )
    )
    ;;{F3}
    (defun UDC_MakeUnstakeObject:object{UtilityAts.Awo} (atspair:string time:time)
        { "reward-tokens"   : (make-list (length (UR_RewardTokenList atspair)) 0.0)
        , "cull-time"       : time}
    )
    (defun UDC_MakeZeroUnstakeObject:object{UtilityAts.Awo} (atspair:string)
        (UDC_MakeUnstakeObject atspair NULLTIME)
    )
    (defun UDC_MakeNegativeUnstakeObject:object{UtilityAts.Awo} (atspair:string)
        (UDC_MakeUnstakeObject atspair ANTITIME)
    )
    (defun UDC_ComposePrimaryRewardToken:object{Autostake.ATS|RewardTokenSchema} (token:string nfr:bool)
        (UDC_RT token nfr 0.0 0.0)
    )
    (defun UDC_RT:object{Autostake.ATS|RewardTokenSchema} (token:string nfr:bool r:decimal u:decimal)
        (enforce (>= r 0.0) "Negative Resident not allowed")
        (enforce (>= u 0.0) "Negative Unbonding not allowed")
        {"token"                    : token
        ,"nfr"                      : nfr
        ,"resident"                 : r
        ,"unbonding"                : u}
    )
    ;;{F4}
    (defun CAP_Owner (id:string)
        @doc "Enforces Atspair Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (UR_OwnerKonto id))
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
                (owner:string (UR_OwnerKonto entity-id))
                (branding-cost:decimal (ref-DALOS::UR_UsagePrice "ignis|branding"))
                (final-cost:decimal (* 5.0 branding-cost))
            )
            (with-capability (ATS|C>UPDATE-BRD)
                (ref-BRD::XE_UpdatePendingBranding entity-id logo description website social)
                (ref-DALOS::IGNIS|C_Collect patron owner final-cost)
            )
        )
    )
    (defun C_UpgradeBranding (patron:string entity-id:string months:integer)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-BRD:module{Branding} BRD)
                (owner:string (UR_OwnerKonto entity-id))
                (kda-payment:decimal
                    (with-capability (ATS|C>UPGRADE-BRD)
                        (ref-BRD::XE_UpgradeBranding entity-id owner months)
                    )
                )
            )
            (ref-DALOS::KDA|C_CollectWT patron kda-payment false)
        )
    )
    (defun C_Issue:[string]
        (
            patron:string
            account:string
            atspair:[string]
            index-decimals:[integer]
            reward-token:[string]
            rt-nfr:[bool]
            reward-bearing-token:[string]
            rbt-nfr:[bool]
        )
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (ATSI|C>ISSUE account atspair index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-BRD:module{Branding} BRD)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (l1:integer (length atspair))
                    (ats-cost:decimal (ref-DALOS::UR_UsagePrice "ats"))
                    (gas-costs:decimal (* (dec l1) (ref-DALOS::UR_UsagePrice "ignis|ats-issue")))
                    (kda-costs:decimal (* (dec l1) ats-cost))
                    (folded-lst:[string]
                        (fold
                            (lambda
                                (acc:[string] index:integer)
                                (let
                                    (
                                        (ats-id:string
                                            (XI_Issue
                                                account 
                                                (at index atspair)
                                                (at index index-decimals)
                                                (at index reward-token)
                                                (at index rt-nfr)
                                                (at index reward-bearing-token)
                                                (at index rbt-nfr)
                                            )
                                        )
                                    )
                                    (ref-BRD::XE_Issue ats-id)
                                    (ref-DPTF::XE_UpdateRewardToken ats-id (at index reward-token) true)
                                    (ref-DPTF::XE_UpdateRewardBearingToken ats-id (at index reward-bearing-token))
                                    (CX_EnsureActivationRoles patron ats-id true)
                                    (ref-U|LST::UC_AppL acc ats-id)
                                )
                            )
                            []
                            (enumerate 0 (- l1 1))
                        )
                    )
                )
                (ref-DALOS::IGNIS|C_Collect patron account gas-costs)
                (ref-DALOS::KDA|C_Collect patron kda-costs)
                folded-lst
            )
        )
    )
    (defun C_ToggleFeeSettings (patron:string atspair:string toggle:bool fee-switch:integer)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (ATS|S>TG_FEE atspair toggle fee-switch)
                (XI_ToggleFeeSettings atspair toggle fee-switch)
                (ref-DALOS::IGNIS|C_Collect patron (UR_OwnerKonto atspair) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_TurnRecoveryOff (patron:string atspair:string cold-or-hot:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (ATS|S>RECOVERY-OFF atspair cold-or-hot)
                (XI_TurnRecoveryOff atspair cold-or-hot)
                (ref-DALOS::IGNIS|C_Collect patron (UR_OwnerKonto atspair) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun CX_EnsureActivationRoles (patron:string atspair:string cold-or-hot:bool)
        @doc "Ensures all Activation Roles such that a given ATSPair can function properly"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ats-sc:string ATS|SC_NAME)

                (rt-lst:[string] (UR_RewardTokenList atspair))
                (c-rbt:string (UR_ColdRewardBearingToken atspair))
                (c-rbt-fer:bool (ref-DPTF::UR_AccountRoleFeeExemption c-rbt ats-sc))
                (c-fr:bool (UR_ColdRecoveryFeeRedirection atspair))
                
            )
            (CX_SetMassRole patron atspair false)
            (if cold-or-hot
                (let
                    (
                        (c-rbt-burn-role:bool (ref-DPTF::UR_AccountRoleBurn c-rbt ats-sc))
                        (c-rbt-mint-role:bool (ref-DPTF::UR_AccountRoleMint c-rbt ats-sc))
                    )
                    (if (not c-fr)
                        (CX_SetMassRole patron atspair true)
                        true
                    )
                    (with-capability (SECURE)
                        (if (not c-rbt-burn-role)
                            (DPTF|C_ToggleBurnRole patron c-rbt ats-sc true)
                            true
                        )
                        (if (not c-rbt-fer)
                            (DPTF|C_ToggleFeeExemptionRole patron c-rbt ats-sc true)
                            true
                        )
                        (if (not c-rbt-mint-role)
                            (DPTF|C_ToggleMintRole patron c-rbt ats-sc true)
                            true
                        )
                    )
                )
                (let
                    (
                        (h-rbt:string (UR_HotRewardBearingToken atspair))
                        (h-fr:bool (UR_HotRecoveryFeeRedirection atspair))
                        (h-rbt-burn-role:bool (ref-DPMF::UR_AccountRoleBurn h-rbt ats-sc))
                        (h-rbt-create-role:bool (ref-DPMF::UR_AccountRoleCreate h-rbt ats-sc))
                        (h-rbt-add-q-role:bool (ref-DPMF::UR_AccountRoleNFTAQ h-rbt ats-sc))
                    )
                    (if (not h-fr)
                        (CX_SetMassRole patron atspair true)
                        true
                    )
                    (with-capability (SECURE)
                        (if (not h-rbt-burn-role)
                            (DPMF|C_ToggleBurnRole patron h-rbt ats-sc true)
                            true
                        )
                        (if (not h-rbt-create-role)
                            (DPMF|C_MoveCreateRole patron h-rbt ats-sc)
                            true
                        )
                        (if (not h-rbt-add-q-role)
                            (DPMF|C_ToggleAddQuantityRole patron h-rbt ats-sc true)
                            true
                        )
                    )
                    
                )
            )
        )
    )
    (defun CX_MassTurnColdRecoveryOff (patron:string id:string)
        @doc "Turns Cold Recovery Off for all ATSPairs where id is Cold-RBT (DPTF)"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (SECURE)
                (map
                    (lambda
                        (atspair:string)
                        (if (= (UR_ToggleColdRecovery atspair) true)
                            (C_TurnRecoveryOff patron atspair true)
                            true
                        )
                    )
                    (ref-DPTF::UR_RewardBearingToken id)
                )
            )
            
        )
    )
    (defun CX_RevokeBurn (patron:string id:string cold-or-hot:bool)
        @doc "When <burn-role> is toggled to off on the ATS|SC-NAME  \
            \ for a given <id> [for a RT (DPTF), Cold-RBT (DPTF) or Hot-RBT (DPTF)] when it is part of an ATSPair \
            \ certain actions must be executed to ensure the proper functioning of the ATSPair, which are done here"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (SECURE)
                (if (ref-DPTF::URC_IzRT id)
                    (map
                        (lambda
                            (atspair:string)
                            (do
                                (if (not (UR_ColdRecoveryFeeRedirection atspair))
                                    (C_ToggleFeeSettings patron atspair true 1)
                                    true
                                )
                                (if (not (UR_HotRecoveryFeeRedirection atspair))
                                    (C_ToggleFeeSettings patron atspair true 2)
                                    true
                                )
                            )
                        )
                        (ref-DPTF::UR_RewardToken id)
                    )
                    (let
                        (
                            (iz-rbt:bool (if cold-or-hot (ref-DPTF::URC_IzRBT id) (ref-DPMF::URC_IzRBT id)))
                        )
                        (if iz-rbt
                            (if cold-or-hot
                                (CX_MassTurnColdRecoveryOff patron id)
                                (if (UR_ToggleHotRecovery (ref-DPMF::UR_RewardBearingToken id))
                                    (C_TurnRecoveryOff patron (ref-DPMF::UR_RewardBearingToken id) false)
                                    true
                                )
                            )
                            true
                        )
                    )
                )
            )
        )
    )
    (defun CX_RevokeCreateOrAddQ (patron:string id:string)
        @doc "Same as <CX_RevokeBurn> but for the <role-nft-create> or the <role-nft-add-quantity> of Hot-RBT (DPMF)"
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (SECURE)
                (if (ref-DPMF::URC_IzRBT id)
                    (C_TurnRecoveryOff patron (ref-DPMF::UR_RewardBearingToken id) false)
                    true
                )
            )
        )
    )
    (defun CX_RevokeFeeExemption (patron:string id:string)
        @doc "Same as <CX_RevokeBurn> but for the <fee-exemption-role> of a RT (DPTF) or Cold-RBT (DPTF)"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (if (ref-DPTF::URC_IzRT id)
                (CX_MassTurnColdRecoveryOff patron id)
                true
            )
        )
    )
    (defun CX_RevokeMint (patron:string id:string)
        @doc "Same as <CX_RevokeBurn> but for the <burn-role> of a Cold-RBT (DPTF)"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (if (ref-DPTF::URC_IzRBT id)
                (CX_MassTurnColdRecoveryOff patron id)
                true        
            )
        )
    )
    (defun CX_SetMassRole (patron:string atspair:string burn-or-exemption:bool)
        @doc "Sets either <burn-role> or <fee-exemption-role>  \
            \ via the boolean <burn-or-exemption> for all RTs of an <ats-pair>"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ats-sc:string ATS|SC_NAME)
            )
            (with-capability (SECURE)
                (map
                    (lambda
                        (reward-token:string)
                        (let
                            (
                                (rt-br:bool (ref-DPTF::UR_AccountRoleBurn reward-token ats-sc))
                                (rt-fer:bool (ref-DPTF::UR_AccountRoleFeeExemption reward-token ats-sc))
                            )
                            
                            (if (and (= rt-br false) burn-or-exemption)
                                (DPTF|C_ToggleBurnRole patron reward-token ats-sc true)
                                (if (and (= rt-fer false) (= burn-or-exemption false))
                                    (DPTF|C_ToggleFeeExemptionRole patron reward-token ats-sc true)
                                    true
                                )
                            )
                        )
                    )
                    (UR_RewardTokenList atspair)
                )            
            )
        )
    )
    (defun DPMF|C_MoveCreateRole (patron:string id:string receiver:string)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "VST|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|ATS|CALLER)
                (ref-DPMF::XE_MoveCreateRole id receiver)
                (ref-DPMF::XB_WriteRoles id (ref-DPMF::UR_CreateRoleAccount id) 2 false)
                (ref-DPMF::XB_WriteRoles id receiver 2 true)
                (if (!= (ref-DPMF::UR_CreateRoleAccount id) ATS|SC_NAME)
                    (CX_RevokeCreateOrAddQ patron id)
                    true
                )
                (ref-DALOS::IGNIS|C_Collect patron (ref-DPMF::UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|biggest"))
            )
        )
    )
    (defun DPMF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "VST|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|ATS|CALLER)
                (ref-DPMF::XE_ToggleAddQuantityRole id account toggle)
                (ref-DPMF::XB_WriteRoles id account 3 toggle )
                (if (and (= account ATS|SC_NAME) (= toggle false))
                    (CX_RevokeCreateOrAddQ patron id)
                    true
                )
                (ref-DALOS::IGNIS|C_Collect patron account (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun DPMF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "VST|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (P|ATS|CALLER)
                (ref-DPMF::XE_ToggleBurnRole id account toggle)
                (ref-DPMF::XB_WriteRoles id account 1 toggle)
                (if (and (= account ATS|SC_NAME) (= toggle false))
                    (CX_RevokeBurn patron id false)
                    true
                )
                (ref-DALOS::IGNIS|C_Collect patron account (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun DPTF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "SWP|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|ATS|CALLER)
                (ref-DPTF::XE_ToggleBurnRole id account toggle)
                (ref-DPTF::XB_WriteRoles id account 1 toggle)
                (if (and (= account ATS|SC_NAME) (= toggle false))
                    (CX_RevokeBurn patron id true)
                    true
                )
                (ref-DALOS::IGNIS|C_Collect patron account (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun DPTF|C_ToggleFeeExemptionRole (patron:string id:string account:string toggle:bool)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "VST|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|ATS|CALLER)
                (ref-DPTF::XE_ToggleFeeExemptionRole id account toggle)
                (ref-DPTF::XB_WriteRoles id account 3 toggle)
                (if (and (= account ATS|SC_NAME) (= toggle false))
                    (CX_RevokeFeeExemption patron id)
                    true
                )
                (ref-DALOS::IGNIS|C_Collect patron account (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun DPTF|C_ToggleMintRole (patron:string id:string account:string toggle:bool)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "SWP|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|ATS|CALLER)
                (ref-DPTF::XE_ToggleMintRole id account toggle)
                (ref-DPTF::XB_WriteRoles id account 2 toggle)
                (if (and (= account ATS|SC_NAME) (= toggle false))
                    (CX_RevokeMint patron id)
                    true
                )
                (ref-DALOS::IGNIS|C_Collect patron account (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    ;;{F7}
    (defun XE_AddHotRBT (atspair:string hot-rbt:string)
        (enforce-guard (P|UR "ATSU|<"))
        (with-capability (ATS|C>ADD_SECONDARY atspair hot-rbt false)
            (update ATS|Pairs atspair
                {"h-rbt" : hot-rbt}
            )
        )
    )
    (defun XE_AddSecondary (atspair:string reward-token:string rt-nfr:bool)
        (enforce-guard (P|UR "ATSU|<"))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (with-capability (ATS|C>ADD_SECONDARY atspair reward-token true)
                (with-read ATS|Pairs atspair
                    { "reward-tokens" := rt }
                    (update ATS|Pairs atspair
                        {"reward-tokens" : (ref-U|LST::UC_AppL rt (UDC_ComposePrimaryRewardToken reward-token rt-nfr))}
                    )
                )
            )
        )
    )
    (defun XE_ChangeOwnership (atspair:string new-owner:string)
        (enforce-guard (P|UR "ATSU|<"))
        (with-capability (ATS|S>RT_OWN atspair new-owner)
            (update ATS|Pairs atspair
                {"owner-konto"                      : new-owner}
            )
        )
    )
    (defun XE_IncrementParameterUnlocks (atspair:string)
        (enforce-guard (P|UR "ATSU|<"))
        (with-read ATS|Pairs atspair
            { "unlocks" := u }
            (update ATS|Pairs atspair
                {"unlocks" : (+ u 1)}
            )
        )
    )
    (defun XE_ModifyCanChangeOwner (atspair:string new-boolean:bool)
        (enforce-guard (P|UR "ATSU|<"))
        (with-capability (ATS|S>RT_CAN-CHANGE atspair new-boolean)
            (update ATS|Pairs atspair
                {"can-change-owner"                 : new-boolean}
            )
        )    
    )
    (defun XE_RemoveSecondary (atspair:string reward-token:string)
        (enforce-guard (P|UR "ATSU|<"))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (with-read ATS|Pairs atspair
                { "reward-tokens" := rt }
                (update ATS|Pairs atspair
                    {"reward-tokens" : 
                        (ref-U|LST::UC_RemoveItem  rt (at (URC_RewardTokenPosition atspair reward-token) rt))
                    }
                )
            )
        ) 
    )
    (defun XE_ReshapeUnstakeAccount (atspair:string account:string rp:integer)
        (enforce-guard (P|UR "ATSU|<"))
        (let
            (
                (ref-U|ATS:module{UtilityAts} U|ATS)
            )
            (with-read ATS|Ledger (concat [atspair BAR account])
                { "P0"      := p0 
                , "P1"      := p1
                , "P2"      := p2
                , "P3"      := p3
                , "P4"      := p4
                , "P5"      := p5
                , "P6"      := p6
                , "P7"      := p7}
                (update ATS|Ledger (concat [atspair BAR account])
                    { "P0"  : (ref-U|ATS::UC_MultiReshapeUnstakeObject p0 rp)
                    , "P1"  : (ref-U|ATS::UC_ReshapeUnstakeObject p1 rp)
                    , "P2"  : (ref-U|ATS::UC_ReshapeUnstakeObject p2 rp)
                    , "P3"  : (ref-U|ATS::UC_ReshapeUnstakeObject p3 rp)
                    , "P4"  : (ref-U|ATS::UC_ReshapeUnstakeObject p4 rp)
                    , "P5"  : (ref-U|ATS::UC_ReshapeUnstakeObject p5 rp)
                    , "P6"  : (ref-U|ATS::UC_ReshapeUnstakeObject p6 rp)
                    , "P7"  : (ref-U|ATS::UC_ReshapeUnstakeObject p7 rp)}
                )
            )
        )  
    )
    (defun XE_SetColdFee (atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        (enforce-guard (P|UR "ATSU|<"))
        (with-capability (ATS|S>SET_COLD_FEE atspair fee-positions fee-thresholds fee-array)
            (update ATS|Pairs atspair
                { "c-positions"     : fee-positions
                , "c-limits"        : fee-thresholds 
                , "c-array"         : fee-array}
            )
        )
    )
    (defun XE_SetCRD (atspair:string soft-or-hard:bool base:integer growth:integer)
        (enforce-guard (P|UR "ATSU|<"))
        (let
            (
                (ref-U|ATS:module{UtilityAts} U|ATS)
            )
            (with-capability (ATS|S>SET_CRD atspair soft-or-hard base growth)
                (if (= soft-or-hard true)
                    (update ATS|Pairs atspair
                        { "c-duration" : (ref-U|ATS::UC_MakeSoftIntervals base growth)}
                    )
                    (update ATS|Pairs atspair
                        { "c-duration" : (ref-U|ATS::UC_MakeHardIntervals base growth)}
                    )
                )
            )
        )
    )
    (defun XE_SetHotFee (atspair:string promile:decimal decay:integer)
        (enforce-guard (P|UR "ATSU|<"))
        (with-capability (ATS|S>SET_HOT_FEE atspair promile decay)
            (update ATS|Pairs atspair
                { "h-promile"       : promile
                , "h-decay"         : decay}
            )
        )
    )
    (defun XE_SpawnAutostakeAccount (atspair:string account:string)
        (enforce-guard (P|UR "ATSU|<"))
        (let
            (
                (zero:object{UtilityAts.Awo} (UDC_MakeZeroUnstakeObject atspair))
                (negative:object{UtilityAts.Awo} (UDC_MakeNegativeUnstakeObject atspair))
            )
            (with-default-read ATS|Ledger (concat [atspair BAR account])
                { "P0"  : [zero]
                , "P1"  : negative
                , "P2"  : negative
                , "P3"  : negative
                , "P4"  : negative
                , "P5"  : negative
                , "P6"  : negative
                , "P7"  : negative
                }
                { "P0"  := p0
                , "P1"  := p1
                , "P2"  := p2
                , "P3"  := p3
                , "P4"  := p4
                , "P5"  := p5
                , "P6"  := p6
                , "P7"  := p7
                }
                (write ATS|Ledger (concat [atspair BAR account])
                    { "P0"  : p0
                    , "P1"  : p1
                    , "P2"  : p2
                    , "P3"  : p3
                    , "P4"  : p4
                    , "P5"  : p5
                    , "P6"  : p6
                    , "P7"  : p7
                    }
                )
            )
        )
    )
    (defun XE_ToggleElite (atspair:string toggle:bool)
        (enforce-guard (P|UR "ATSU|<"))
        (with-capability (ATS|S>TOGGLE_ELITE atspair toggle)
            (update ATS|Pairs atspair
                { "c-elite-mode" : toggle}
            )
        )
    )
    (defun XE_ToggleParameterLock:[decimal] (atspair:string toggle:bool)
        (enforce-guard (P|UR "ATSU|<"))
        (let
            (
                (ref-U|ATS:module{UtilityAts} U|ATS)
            )
            (with-capability (ATS|S>TG_PRM-LOCK atspair toggle)
                (update ATS|Pairs atspair
                    { "parameter-lock" : toggle}
                )
                (if (= toggle true)
                    [0.0 0.0]
                    (ref-U|ATS::UC_UnlockPrice (UR_Unlocks atspair))
                )
            )
        )
    )
    (defun XE_ToggleSyphoning (atspair:string toggle:bool)
        (enforce-guard (P|UR "ATSU|<"))
        (with-capability (ATS|S>SYPHONING atspair toggle)
            (update ATS|Pairs atspair
                {"syphoning"                        : toggle}
            )
        )
    )
    (defun XE_TurnRecoveryOn (atspair:string cold-or-hot:bool)
        (enforce-guard (P|UR "ATSU|<"))
        (with-capability (ATS|S>RECOVERY-ON atspair cold-or-hot)
            (if (= cold-or-hot true)
                (update ATS|Pairs atspair
                    { "cold-recovery" : true}
                )
                (update ATS|Pairs atspair
                    { "hot-recovery" : true}
                )
            )
        )
    )
    (defun XE_UpdateRoU (atspair:string reward-token:string rou:bool direction:bool amount:decimal)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (P|UR "ATSU|<"))
                (enforce-guard (P|UR "TFT|<"))
            ]
        )
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (rtp:integer (URC_RewardTokenPosition atspair reward-token))
                (nfr:bool (UR_RT-Data atspair reward-token 1))
                (resident:decimal (UR_RT-Data atspair reward-token 2))
                (unbonding:decimal (UR_RT-Data atspair reward-token 3))
                (new-rt:object{Autostake.ATS|RewardTokenSchema} 
                    (if (= rou true)
                        (if (= direction true)
                            (UDC_RT reward-token nfr (+ resident amount) unbonding)
                            (UDC_RT reward-token nfr (- resident amount) unbonding)
                        )
                        (if (= direction true)
                            (UDC_RT reward-token nfr resident (+ unbonding amount))
                            (UDC_RT reward-token nfr resident (- unbonding amount))
                        )
                    )
                )
            )
            (with-read ATS|Pairs atspair
                { "reward-tokens" := rt }
                (update ATS|Pairs atspair
                    { "reward-tokens" : (ref-U|LST::UC_ReplaceItem rt (at rtp rt) new-rt)}
                )
            )
        )
    )
    (defun XE_UpdateSyphon (atspair:string syphon:decimal)
        (enforce-guard (P|UR "ATSU|<"))
        (with-capability (ATS|S>SYPHON atspair syphon)
            (update ATS|Pairs atspair
                {"syphon"                           : syphon}
            )
        )
    )
    (defun XE_UpP0 (atspair:string account:string obj:[object{UtilityAts.Awo}])
        (enforce-guard (P|UR "ATSU|<"))
        (update ATS|Ledger (concat [atspair BAR account])
            { "P0" : obj}
        )
    )
    (defun XE_UpP1 (atspair:string account:string obj:object{UtilityAts.Awo})
        (enforce-guard (P|UR "ATSU|<"))
        (update ATS|Ledger (concat [atspair BAR account])
            { "P1"  : obj}
        )
    )
    (defun XE_UpP2 (atspair:string account:string obj:object{UtilityAts.Awo})
        (enforce-guard (P|UR "ATSU|<"))
        (update ATS|Ledger (concat [atspair BAR account])
            { "P2"  : obj}
        )
    )
    (defun XE_UpP3 (atspair:string account:string obj:object{UtilityAts.Awo})
        (enforce-guard (P|UR "ATSU|<"))
        (update ATS|Ledger (concat [atspair BAR account])
            { "P3"  : obj}
        )
    )
    (defun XE_UpP4 (atspair:string account:string obj:object{UtilityAts.Awo})
        (enforce-guard (P|UR "ATSU|<"))
        (update ATS|Ledger (concat [atspair BAR account])
            { "P4"  : obj}
        )
    )
    (defun XE_UpP5 (atspair:string account:string obj:object{UtilityAts.Awo})
        (enforce-guard (P|UR "ATSU|<"))
        (update ATS|Ledger (concat [atspair BAR account])
            { "P5"  : obj}
        )
    )
    (defun XE_UpP6 (atspair:string account:string obj:object{UtilityAts.Awo})
        (enforce-guard (P|UR "ATSU|<"))
        (update ATS|Ledger (concat [atspair BAR account])
            { "P6"  : obj}
        )
    )
    (defun XE_UpP7 (atspair:string account:string obj:object{UtilityAts.Awo})
        (enforce-guard (P|UR "ATSU|<"))
        (update ATS|Ledger (concat [atspair BAR account])
            { "P7"  : obj}
        )
    )
    ;;
    (defun XI_Issue:string
        (
            account:string 
            atspair:string 
            index-decimals:integer 
            reward-token:string 
            rt-nfr:bool 
            reward-bearing-token:string 
            rbt-nfr:bool
        )
        (require-capability (SECURE))
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-U|ATS:module{UtilityAts} U|ATS)
                (ats-sc:string ATS|SC_NAME)
                (id:string (ref-U|DALOS::UDC_Makeid atspair))
            )
            (ref-U|DALOS::UEV_Decimals index-decimals)
            (ref-U|ATS::UEV_AutostakeIndex)
            (insert ATS|Pairs id
                {"owner-konto"                          : account
                ,"can-change-owner"                     : true
                ,"parameter-lock"                       : false
                ,"unlocks"                              : 0

                ,"pair-index-name"                      : atspair
                ,"index-decimals"                       : index-decimals
                ,"syphon"                               : 1.0
                ,"syphoning"                            : false

                ,"reward-tokens"                        : [(UDC_ComposePrimaryRewardToken reward-token rt-nfr)]

                ,"c-rbt"                                : reward-bearing-token
                ,"c-nfr"                                : rbt-nfr
                ,"c-positions"                          : -1
                ,"c-limits"                             : [0.0]
                ,"c-array"                              : [[0.0]]
                ,"c-fr"                                 : true
                ,"c-duration"                           : (ref-U|ATS::UC_MakeSoftIntervals 300 6)
                ,"c-elite-mode"                         : false

                ,"h-rbt"                                : BAR
                ,"h-promile"                            : 100.0
                ,"h-decay"                              : 1
                ,"h-fr"                                 : true

                ,"cold-recovery"                        : false
                ,"hot-recovery"                         : false
                }
            )
            (ref-DPTF::C_DeployAccount reward-token account)
            (ref-DPTF::C_DeployAccount reward-bearing-token account)
            (ref-DPTF::C_DeployAccount reward-token ats-sc)
            (ref-DPTF::C_DeployAccount reward-bearing-token ats-sc)
            id
        )
    )
    (defun XI_ToggleFeeSettings (atspair:string toggle:bool fee-switch:integer)
        (require-capability (ATS|S>TG_FEE atspair toggle fee-switch))
        (if (= fee-switch 0)
            (update ATS|Pairs atspair
                { "c-nfr" : toggle}
            )
            (if (= fee-switch 1)
                (update ATS|Pairs atspair
                    { "c-fr" : toggle}
                )
                (update ATS|Pairs atspair
                    { "h-fr" : toggle}
                )
            )
        )
    )
    (defun XI_TurnRecoveryOff (atspair:string cold-or-hot:bool)
        (require-capability (ATS|S>RECOVERY-OFF atspair cold-or-hot))
        (if (= cold-or-hot true)
            (update ATS|Pairs atspair
                { "cold-recovery" : false}
            )
            (update ATS|Pairs atspair
                { "hot-recovery" : false}
            )
        )
    )
)

(create-table P|T)
(create-table ATS|Pairs)
(create-table ATS|Ledger)