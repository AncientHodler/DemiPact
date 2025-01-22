;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module ATSC GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_ATSC           (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_ATSC           (keyset-ref-guard ATS.ATS|SC_KEY))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|ATSC_ADMIN))
    )
    (defcap GOV|ATSC_ADMIN ()
        (enforce-one
            "ATSC Autostake Admin not satisfed"
            [
                (enforce-guard GOV|MD_ATSC)
                (enforce-guard GOV|SC_ATSC)
            ]
        )
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    (defcap P|ATSC|REMOTE-GOV ()
        true
    )
    (defcap P|ATSC|CALLER ()
        true
    )
    (defcap P|ATSC|UPDATE_ROU ()
        true
    )
    (defcap P|ATSC|UPDATE_UNSTAKE-POS ()
        true
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|ATSC_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        (ATS.P|A_Add
            "ATSC|RemoteAtsGov"
            (create-capability-guard (P|ATSC|REMOTE-GOV))
        )
        (ATS.P|A_Add
            "ATSC|Caller"
            (create-capability-guard (P|ATSC|CALLER))
        )
        (ATS.P|A_Add
            "ATSC|UpdateROU"
            (create-capability-guard (P|ATSC|UPDATE_ROU))
        )
        (ATS.P|A_Add
            "ATSC|UpUnsPos"
            (create-capability-guard (P|ATSC|UPDATE_UNSTAKE-POS))
        )
        (TFT.P|A_Add
            "ATSC|Caller"
            (create-capability-guard (P|ATSC|CALLER))
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
    (defcap COMPOSE ()
        true
    )
    ;;{5}
    ;;{6}
    ;;{7}
    (defcap ATSC|C>COLD_REC (recoverer:string ats:string ra:decimal)
        @event
        (DALOS.DALOS|CAP_EnforceAccountOwnership recoverer)
        (ATS.ATS|UEV_RecoveryState ats true true)
        (compose-capability (P|ATSC|REMOTE-GOV))
        (compose-capability (P|ATSC|CALLER))
        (compose-capability (P|ATSC|UPDATE_ROU))
        (compose-capability (ATSC|C>DEPLOY ats recoverer))
        (compose-capability (P|ATSC|UPDATE_UNSTAKE-POS))
    )
    (defcap ATSC|C>CULL (culler:string ats:string)
        @event
        (DALOS.DALOS|CAP_EnforceAccountOwnership culler)
        (ATS.ATS|UEV_id ats)
        (compose-capability (P|ATSC|REMOTE-GOV))
        (compose-capability (P|ATSC|CALLER))
        (compose-capability (P|ATSC|UPDATE_ROU))
        (compose-capability (P|ATSC|UPDATE_UNSTAKE-POS))
        (compose-capability (ATSC|C>NORM_LEDGER ats culler))
    )
    (defcap ATSC|C>DEPLOY (ats:string acc:string)
        (DALOS.DALOS|UEV_EnforceAccountExists acc)
        (ATS.ATS|UEV_id ats)
        (compose-capability (ATSC|C>NORM_LEDGER ats acc))
    )
    (defcap ATSC|C>NORM_LEDGER (ats:string acc:string)
        (ATS.ATS|UEV_id ats)
        (compose-capability (P|ATSC|UPDATE_UNSTAKE-POS))
        (let*
            (
                (dalos-admin:guard GOV|MD_ATSC)
                (autos-admin:guard GOV|SC_ATSC)
                (acc-g:guard (DALOS.DALOS|UR_AccountGuard acc))
                (sov:string (DALOS.DALOS|UR_AccountSovereign acc))
                (sov-g:guard (DALOS.DALOS|UR_AccountGuard sov))
                (gov-g:guard (DALOS.DALOS|UR_AccountGovernor acc))
            )
            (enforce-one
                "Invalid permission for normalizing ATS|Ledger Account Operations"
                [
                    (enforce-guard dalos-admin)
                    (enforce-guard autos-admin)
                    (enforce-guard acc-g)
                    (enforce-guard sov-g)
                    (enforce-guard gov-g)
                ]
            )
        )
    )
    ;;
    ;;{8}
    ;;{9}
    ;;{10}
    ;;{11}
    ;;{12}
    ;;{13}
    ;;
    ;;{14}
    ;;{15}
    (defun ATSC|C_ColdRecovery (patron:string recoverer:string ats:string ra:decimal)
        (with-capability (ATSC|C>COLD_REC recoverer ats ra)
            (ATSC|X_DeployAccount ats recoverer)
            (let*
                (
                    (rt-lst:[string] (ATS.ATS|UR_RewardTokenList ats))
                    (c-rbt:string (ATS.ATS|UR_ColdRewardBearingToken ats))
                    (c-rbt-precision:integer (DPTF.DPTF|UR_Decimals c-rbt))
                    (usable-position:integer (ATS.ATS|URC_WhichPosition ats ra recoverer))
                    (fee-promile:decimal (ATS.ATS|URC_ColdRecoveryFee ats ra usable-position))
                    (c-rbt-fee-split:[decimal] (UTILS.ATS|UC_PromilleSplit fee-promile ra c-rbt-precision))
                    (c-fr:bool (ATS.ATS|UR_ColdRecoveryFeeRedirection ats))
                    (cull-time:time (ATS.ATS|URC_CullColdRecoveryTime ats recoverer))
                    ;;for false
                    (ng-c-fr:[decimal] (ATS.ATS|URC_RTSplitAmounts ats (at 1 c-rbt-fee-split)))    ;;feeul
                    ;;for true
                    (positive-c-fr:[decimal] (ATS.ATS|URC_RTSplitAmounts ats (at 0 c-rbt-fee-split)))    ;;remainderu
                )
                (TFT.DPTF|C_Transfer patron c-rbt recoverer ATS.ATS|SC_NAME ra true)
                (DPTF.DPTF|C_Burn patron c-rbt ATS.ATS|SC_NAME ra)
                (map
                    (lambda
                        (index:integer)
                        (ATS.ATS|X_UpdateRoU ats (at index rt-lst) false true (at index positive-c-fr))
                        (ATS.ATS|X_UpdateRoU ats (at index rt-lst) true false (at index positive-c-fr))
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
                (if (not c-fr)
                    (map
                        (lambda
                            (index:integer)
                            (DPTF.DPTF|C_Burn patron (at index rt-lst) ATS.ATS|SC_NAME (at index ng-c-fr))
                        )
                        (enumerate 0 (- (length rt-lst) 1))
                    )
                    true
                )
                (ATSC|X_StoreUnstakeObject ats recoverer usable-position 
                    { "reward-tokens"   : positive-c-fr 
                    , "cull-time"       : cull-time}
                )
            )
            (ATSC|X_Normalize ats recoverer)
        )
    )
    (defun ATSC|C_Cull:[decimal] (patron:string culler:string ats:string)
        (with-capability (ATSC|C>CULL culler ats)
            (let*
                (
                    (rt-lst:[string] (ATS.ATS|UR_RewardTokenList ats))
                    (c0:[decimal] (ATSC|X_MultiCull ats culler))
                    (c1:[decimal] (ATSC|X_SingleCull ats culler 1))
                    (c2:[decimal] (ATSC|X_SingleCull ats culler 2))
                    (c3:[decimal] (ATSC|X_SingleCull ats culler 3))
                    (c4:[decimal] (ATSC|X_SingleCull ats culler 4))
                    (c5:[decimal] (ATSC|X_SingleCull ats culler 5))
                    (c6:[decimal] (ATSC|X_SingleCull ats culler 6))
                    (c7:[decimal] (ATSC|X_SingleCull ats culler 7))
                    (ca:[[decimal]] [c0 c1 c2 c3 c4 c5 c6 c7])
                    (cw:[decimal] (UTILS.UTILS|UC_AddHybridArray ca))
                )
                (map
                    (lambda
                        (idx:integer)
                        (if (!= (at idx cw) 0.0)
                            (with-capability (COMPOSE)
                                (ATS.ATS|X_UpdateRoU ats (at idx rt-lst) false false (at idx cw))
                                (TFT.DPTF|C_Transfer patron (at idx rt-lst) ATS.ATS|SC_NAME culler (at idx cw) true)
                            )
                            true
                        )
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
                (ATSC|X_Normalize ats culler)
                cw
            )
        )
    )
    ;;{16}
    (defun ATSC|X_MultiCull:[decimal] (ats:string acc:string)
        (let*
            (
                (zr:object{ATS.Awo} (ATS.ATS|UDC_MakeZeroUnstakeObject ats))
                (ng:object{ATS.Awo} (ATS.ATS|UDC_MakeNegativeUnstakeObject ats))
                (p0:[object{ATS.Awo}] (ATS.ATS|UR_P0 ats acc))
                (p0l:integer (length p0))
                (boolean-lst:[bool]
                    (fold
                        (lambda
                            (acc:[bool] item:object{ATS.Awo})
                            (UTILS.LIST|UC_AppendLast acc (ATS.ATS|UC_IzCullable item))
                        )
                        []
                        p0
                    )
                )
                (zr-output:[decimal] (make-list (length (ATS.ATS|UR_RewardTokens ats)) 0.0))
                (cullables:[integer] (UTILS.LIST|UC_Search boolean-lst true))
                (immutables:[integer] (UTILS.LIST|UC_Search boolean-lst false))
                (how-many-cullables:integer (length cullables))
            )
            (if (= how-many-cullables 0)
                zr-output
                (let*
                    (
                        (after-cull:[object{ATS.Awo}]
                            (if (< how-many-cullables p0l)
                                (fold
                                    (lambda
                                        (acc:[object{ATS.Awo}] idx:integer)
                                        (UTILS.LIST|UC_AppendLast acc (at (at idx immutables) p0))
                                    )
                                    []
                                    (enumerate 0 (- (length immutables) 1))
                                )
                                [zr]
                            )
                        )
                        (to-be-culled:[object{ATS.Awo}]
                            (fold
                                (lambda
                                    (acc:[object{ATS.Awo}] idx:integer)
                                    (UTILS.LIST|UC_AppendLast acc (at (at idx cullables) p0))
                                )
                                []
                                (enumerate 0 (- (length cullables) 1))
                            )
                        )
                        (culled-values:[[decimal]]
                            (fold
                                (lambda
                                    (acc:[[decimal]] idx:integer)
                                    (UTILS.LIST|UC_AppendLast acc (ATS.ATS|URC_CullValue ats (at idx to-be-culled)))
                                )
                                []
                                (enumerate 0 (- (length to-be-culled) 1))
                            )
                        )
                        (summed-culled-values:[decimal] (UTILS.UTILS|UC_AddHybridArray culled-values))
                    )
                    (ATS.X_UpP0 ats acc after-cull)
                    summed-culled-values
                )
            )
        )
    )
    (defun ATSC|X_SingleCull:[decimal] (ats:string acc:string position:integer)
        (let*
            (
                (rt-lst:[string] (ATS.ATS|UR_RewardTokenList ats))
                (l:integer (length rt-lst))
                (empty:[decimal] (make-list l 0.0))
                (zr:object{ATS.Awo} (ATS.ATS|UDC_MakeZeroUnstakeObject ats))
                (unstake-obj:object{ATS.Awo} (ATS.ATS|UR_P1-7 ats acc position))
                (rt-amounts:[decimal] (at "reward-tokens" unstake-obj))
                (cull-output:[decimal] (ATS.ATS|URC_CullValue ats unstake-obj))
            )
            (if (!= cull-output empty)
                (ATSC|X_StoreUnstakeObject ats acc position zr)
                true
            )
            cull-output
        )
    )
    (defun ATSC|X_StoreUnstakeObject (ats:string acc:string position:integer obj:object{ATS.Awo})
        (let
            (
                (p0:[object{ATS.Awo}] (ATS.ATS|UR_P0 ats acc))
            )
            (if (= position -1)
                (if (and 
                        (= (length p0) 1)
                        (= 
                            (at 0 p0) 
                            (ATS.ATS|UDC_MakeZeroUnstakeObject ats)
                        )
                    )
                    (ATS.X_UpP0 ats acc [obj])
                    (ATS.X_UpP0 ats acc (UTILS.LIST|UC_AppendLast p0 obj))
                )
                (cond
                    ((= position 1) (ATS.X_UpP1 ats acc obj))
                    ((= position 2) (ATS.X_UpP2 ats acc obj))
                    ((= position 3) (ATS.X_UpP3 ats acc obj))
                    ((= position 4) (ATS.X_UpP4 ats acc obj))
                    ((= position 5) (ATS.X_UpP5 ats acc obj))
                    ((= position 6) (ATS.X_UpP6 ats acc obj))
                    ((= position 7) (ATS.X_UpP7 ats acc obj))
                    true
                )
            )
        )
    )
    (defun ATSC|X_DeployAccount (ats:string acc:string)
        (require-capability (ATSC|C>DEPLOY ats acc))
        (ATS.ATS|X_SpawnAutostakeAccount ats acc)
        (ATSC|X_Normalize ats acc)
    )
    (defun ATSC|X_Normalize (ats:string acc:string)
        (require-capability (ATSC|C>NORM_LEDGER ats acc))
        (let*
            (
                (p0:[object{ATS.Awo}] (ATS.ATS|UR_P0 ats acc))
                (p1:object{ATS.Awo} (ATS.ATS|UR_P1-7 ats acc 1))
                (p2:object{ATS.Awo} (ATS.ATS|UR_P1-7 ats acc 2))
                (p3:object{ATS.Awo} (ATS.ATS|UR_P1-7 ats acc 3))
                (p4:object{ATS.Awo} (ATS.ATS|UR_P1-7 ats acc 4))
                (p5:object{ATS.Awo} (ATS.ATS|UR_P1-7 ats acc 5))
                (p6:object{ATS.Awo} (ATS.ATS|UR_P1-7 ats acc 6))
                (p7:object{ATS.Awo} (ATS.ATS|UR_P1-7 ats acc 7))

                (zr:object{ATS.Awo} (ATS.ATS|UDC_MakeZeroUnstakeObject ats))
                (ng:object{ATS.Awo} (ATS.ATS|UDC_MakeNegativeUnstakeObject ats))
                (positions:integer (ATS.ATS|UR_ColdRecoveryPositions ats))
                (elite:bool (ATS.ATS|UR_EliteMode ats))
                (major-tier:integer (DALOS.DALOS|UR_Elite-Tier-Major acc))

                (p0-znn:[object{ATS.Awo}] (if (and (!= p0 [zr]) (!= p0 [ng])) p0 [ng]))
                (p0-znz:[object{ATS.Awo}] (if (and (!= p0 [zr]) (!= p0 [ng])) p0 [zr]))
                (p1-znn:object{ATS.Awo} (if (and (!= p1 zr) (!= p1 ng)) p1 ng))
                (p1-znz:object{ATS.Awo} (if (and (!= p1 zr) (!= p1 ng)) p1 zr))
                (p2-znn:object{ATS.Awo} (if (and (!= p2 zr) (!= p2 ng)) p2 ng))
                (p2-znz:object{ATS.Awo} (if (and (!= p2 zr) (!= p2 ng)) p2 zr))
                (p3-znn:object{ATS.Awo} (if (and (!= p3 zr) (!= p3 ng)) p3 ng))
                (p3-znz:object{ATS.Awo} (if (and (!= p3 zr) (!= p3 ng)) p3 zr))
                (p4-znn:object{ATS.Awo} (if (and (!= p4 zr) (!= p4 ng)) p4 ng))
                (p4-znz:object{ATS.Awo} (if (and (!= p4 zr) (!= p4 ng)) p4 zr))
                (p5-znn:object{ATS.Awo} (if (and (!= p5 zr) (!= p5 ng)) p5 ng))
                (p5-znz:object{ATS.Awo} (if (and (!= p5 zr) (!= p5 ng)) p5 zr))
                (p6-znn:object{ATS.Awo} (if (and (!= p6 zr) (!= p6 ng)) p6 ng))
                (p6-znz:object{ATS.Awo} (if (and (!= p6 zr) (!= p6 ng)) p6 zr))
                (p7-znn:object{ATS.Awo} (if (and (!= p7 zr) (!= p7 ng)) p7 ng))
                (p7-znz:object{ATS.Awo} (if (and (!= p7 zr) (!= p7 ng)) p7 zr))

                (p2-zne:object{ATS.Awo} (if (and (!= p2 zr) (!= p2 ng)) p2 (if (>= major-tier 2) zr ng)))
                (p3-zne:object{ATS.Awo} (if (and (!= p3 zr) (!= p3 ng)) p3 (if (>= major-tier 3) zr ng)))
                (p4-zne:object{ATS.Awo} (if (and (!= p4 zr) (!= p4 ng)) p4 (if (>= major-tier 4) zr ng)))
                (p5-zne:object{ATS.Awo} (if (and (!= p5 zr) (!= p5 ng)) p5 (if (>= major-tier 5) zr ng)))
                (p6-zne:object{ATS.Awo} (if (and (!= p6 zr) (!= p6 ng)) p6 (if (>= major-tier 6) zr ng)))
                (p7-zne:object{ATS.Awo} (if (and (!= p7 zr) (!= p7 ng)) p7 (if (>= major-tier 7) zr ng)))
            )
            (cond
                ((= positions -1) (ATSC|X_UUP ats acc [p0-znz p1-znn p2-znn p3-znn p4-znn p5-znn p6-znn p7-znn]))
                ((= positions 1) (ATSC|X_UUP ats acc [p0-znn p1-znz p2-znn p3-znn p4-znn p5-znn p6-znn p7-znn]))
                ((= positions 2) (ATSC|X_UUP ats acc [p0-znn p1-znz p2-znz p3-znn p4-znn p5-znn p6-znn p7-znn]))
                ((= positions 3) (ATSC|X_UUP ats acc [p0-znn p1-znz p2-znz p3-znz p4-znn p5-znn p6-znn p7-znn]))
                ((= positions 4) (ATSC|X_UUP ats acc [p0-znn p1-znz p2-znz p3-znz p4-znz p5-znn p6-znn p7-znn]))
                ((= positions 5) (ATSC|X_UUP ats acc [p0-znn p1-znz p2-znz p3-znz p4-znz p5-znz p6-znn p7-znn]))
                ((= positions 6) (ATSC|X_UUP ats acc [p0-znn p1-znz p2-znz p3-znz p4-znz p5-znz p6-znz p7-znn]))
                ((not elite) (ATSC|X_UUP ats acc [p0-znn p1-znz p2-znz p3-znz p4-znz p5-znz p6-znz p7-znz]))
                (elite (ATSC|X_UUP ats acc [p0-znn p1-znz p2-zne p3-zne p4-zne p5-zne p6-zne p7-zne]))
                true
            )
        )
    )
    (defun ATSC|X_UUP (ats:string acc:string data:[object{ATS.Awo}])
        (enforce (= (length data) 8) "Invalid Data Length")
        (ATS.X_UpP0 ats acc (at 0 data))
        (ATS.X_UpP1 ats acc (at 1 data))
        (ATS.X_UpP2 ats acc (at 2 data))
        (ATS.X_UpP3 ats acc (at 3 data))
        (ATS.X_UpP4 ats acc (at 4 data))
        (ATS.X_UpP5 ats acc (at 5 data))
        (ATS.X_UpP6 ats acc (at 6 data))
        (ATS.X_UpP7 ats acc (at 7 data))
    )
)

(create-table P|T)