;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module ATSM GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_ATSM           (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_ATSM           (keyset-ref-guard ATS.ATS|SC_KEY))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|ATSM_ADMIN))
    )
    (defcap GOV|ATSM_ADMIN ()
        (enforce-one
            "ATSM Autostake Admin not satisfed"
            [
                (enforce-guard GOV|MD_ATSM)
                (enforce-guard GOV|SC_ATSM)
            ]
        )
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    (defcap P|ATSM|REMOTE-GOV ()
        true
    )
    (defcap P|ATSM|UPDATE_ROU ()
        true
    )
    (defcap P|ATSM|CALLER ()
        true
    )
    (defcap P|ATSM|RESHAPE ()
        true
    )
    (defcap P|ATSM|RM_SECONDARY_RT ()
        true
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|ATSM_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        (DPTF.P|A_Add
            "ATSM|Caller"
            (create-capability-guard (P|ATSM|CALLER))
        )
        (DPMF.P|A_Add
            "ATSM|Caller"
            (create-capability-guard (P|ATSM|CALLER))
        )
        (ATS.P|A_Add
            "ATSM|Caller"
            (create-capability-guard (P|ATSM|CALLER))
        )
        (ATS.P|A_Add
            "ATSM|RemoteAtsGov"
            (create-capability-guard (P|ATSM|REMOTE-GOV))
        )
        (ATS.P|A_Add
            "ATSM|UpdateROU"
            (create-capability-guard (P|ATSM|UPDATE_ROU))
        )
        (ATS.P|A_Add
            "ATSM|ReshapeUnstakeAccount"
            (create-capability-guard (P|ATSM|RESHAPE))
        )
        (ATS.P|A_Add
            "ATSM|RemoveSecondaryRT"
            (create-capability-guard (P|ATSM|RM_SECONDARY_RT))
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
    ;;{5}
    ;;{6}
    ;;{7}
    (defcap ATSM|C>RM_SCND (atspair:string reward-token:string)
        @event
        (ATS.ATS|CAP_Owner atspair)
        (ATS.ATS|UEV_UpdateColdAndHot atspair)
        (ATS.ATS|UEV_ParameterLockState atspair false)
        (compose-capability (P|ATSM|REMOTE-GOV))
        (compose-capability (P|ATSM|UPDATE_ROU))
        (compose-capability (P|ATSM|RESHAPE))
        (compose-capability (P|ATSM|RM_SECONDARY_RT))
        (compose-capability (P|ATSM|CALLER))
        (let
            (
                (rt-position:integer (ATS.ATS|URC_RewardTokenPosition atspair reward-token))
            )
            (enforce (> rt-position 0) "Primal RT cannot be removed")
        )
    )
    (defcap ATSM|C>COIL_OR_CURL (atspair:string coil-token:string)
        @event
        (ATS.ATS|UEV_RewardTokenExistance atspair coil-token true)
        (compose-capability (P|ATSM|REMOTE-GOV))
        (compose-capability (P|ATSM|UPDATE_ROU))
    )
    (defcap ATSM|C>SYPHON (atspair:string syphon-amounts:[decimal])
        @event
        (ATS.ATS|CAP_Owner atspair)
        (ATS.ATS|UEV_SyphoningState atspair true)
        (compose-capability (P|ATSM|REMOTE-GOV))
        (compose-capability (P|ATSM|UPDATE_ROU))
        (compose-capability (P|ATSM|CALLER))
        (let*
            (
                (rt-lst:[string] (ATS.ATS|UR_RewardTokenList atspair))
                (l0:integer (length syphon-amounts))
                (l1:integer (length rt-lst))
                (max-syphon:[decimal] (ATS.ATS|URC_MaxSyphon atspair))
                (max-syphon-sum:decimal (fold (+) 0.0 max-syphon))
                (input-syphon-sum:decimal (fold (+) 0.0 syphon-amounts))

                (resident-amounts:[decimal] (ATS.ATS|UR_RoUAmountList atspair true))
                (supply-check:[bool] (zip (lambda (x:decimal y:decimal) (<= x y)) syphon-amounts resident-amounts))
                (tr-nr:integer (length (UTILS.LIST|UC_Search supply-check true)))
            )
            (enforce (= l0 l1) "Invalid Amounts of Syphon Values")
            (enforce (> input-syphon-sum 0.0) "Invalid Syphon Amounts")
            (map
                (lambda
                    (sv:decimal)
                    (enforce (>= sv 0.0) "Unallowed Negative Syphon Values Detected !")
                )
                syphon-amounts
            )
            (enforce (<= input-syphon-sum max-syphon-sum) "Syphon Amounts surpassing pairs Syphon-Index")
            (enforce (= l0 tr-nr) "Invalid syphon amounts surpassing present resident Amounts")
        )
    )
    (defcap ATSM|C>KICKSTART (kickstarter:string atspair:string rt-amounts:[decimal] rbt-request-amount:decimal)
        @event
        (DALOS.DALOS|CAP_EnforceAccountOwnership (ATS.ATS|UR_OwnerKonto atspair))
        (DALOS.DALOS|UEV_EnforceAccountType kickstarter false)
        (compose-capability (P|ATSM|REMOTE-GOV))
        (compose-capability (P|ATSM|UPDATE_ROU))
        (compose-capability (P|ATSM|CALLER))
        (let*
            (
                (index:decimal (ATS.ATS|URC_Index atspair))
                (rt-lst:[string] (ATS.ATS|UR_RewardTokenList atspair))
                (l1:integer (length rt-amounts))
                (l2:integer (length rt-lst))
            )
            (enforce (= index -1.0) "Kickstarting can only be done on ATS-Pairs with -1 Index")
            (enforce (= l1 l2) "RT-Amounts list does not correspond with the Number of the ATS-Pair Reward Tokens")
            (enforce (> rbt-request-amount 0.0) "RBT Request Amount must be greater than zero!")
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
    (defun ATSM|C_ChangeOwnership (patron:string atspair:string new-owner:string)
        (with-capability (P|ATSM|CALLER)
            (ATS.ATS|X_ChangeOwnership atspair new-owner)
            (DALOS.IGNIS|C_Collect patron (ATS.ATS|UR_OwnerKonto atspair) (DALOS.DALOS|UR_UsagePrice "ignis|biggest"))
        )
    )
    (defun ATSM|C_ModifyCanChangeOwner (patron:string atspair:string new-boolean:bool)
        (with-capability (P|ATSM|CALLER)
            (ATS.ATS|X_ModifyCanChangeOwner atspair new-boolean)
            (DALOS.IGNIS|C_Collect patron (ATS.ATS|UR_OwnerKonto atspair) (DALOS.DALOS|UR_UsagePrice "ignis|biggest"))
        )
    )
    (defun ATSM|C_ToggleParameterLock (patron:string atspair:string toggle:bool)
        (enforce-guard (P|UR "TALOS|Summoner"))
        (with-capability (P|ATSM|CALLER)
            (let*
                (
                    (atspair-owner:string (ATS.ATS|UR_OwnerKonto atspair))
                    (g1:decimal (DALOS.DALOS|UR_UsagePrice "ignis|small"))
                    (toggle-costs:[decimal] (ATS.ATS|X_ToggleParameterLock atspair toggle))
                    (g2:decimal (at 0 toggle-costs))
                    (gas-costs:decimal (+ g1 g2))
                    (kda-costs:decimal (at 1 toggle-costs))
                )
                (DALOS.IGNIS|C_Collect patron atspair-owner gas-costs)
                (if (> kda-costs 0.0)
                    (do
                        (ATS.ATS|X_IncrementParameterUnlocks atspair)
                        (DALOS.KDA|C_Collect patron kda-costs)
                    )
                    true
                )
            )
        )
    )
    (defun ATSM|C_UpdateSyphon (patron:string atspair:string syphon:decimal)
        (with-capability (P|ATSM|CALLER)
            (ATS.ATS|X_UpdateSyphon atspair syphon)
            (DALOS.IGNIS|C_Collect patron (ATS.ATS|UR_OwnerKonto atspair) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun ATSM|C_ToggleSyphoning (patron:string atspair:string toggle:bool)
        (with-capability (P|ATSM|CALLER)
            (ATS.ATS|X_ToggleSyphoning atspair toggle)
            (DALOS.IGNIS|C_Collect patron (ATS.ATS|UR_OwnerKonto atspair) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun ATSM|C_SetCRD (patron:string atspair:string soft-or-hard:bool base:integer growth:integer)
        (with-capability (P|ATSM|CALLER)
            (ATS.ATS|X_SetCRD atspair soft-or-hard base growth)
            (DALOS.IGNIS|C_Collect patron (ATS.ATS|UR_OwnerKonto atspair) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun ATSM|C_SetColdFee (patron:string atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        (with-capability (P|ATSM|CALLER)
            (ATS.ATS|X_SetColdFee atspair fee-positions fee-thresholds fee-array)
            (DALOS.IGNIS|C_Collect patron (ATS.ATS|UR_OwnerKonto atspair) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun ATSM|C_SetHotFee (patron:string atspair:string promile:decimal decay:integer)
        (with-capability (P|ATSM|CALLER)
            (ATS.ATS|X_SetHotFee atspair promile decay)
            (DALOS.IGNIS|C_Collect patron (ATS.ATS|UR_OwnerKonto atspair) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun ATSM|C_ToggleElite (patron:string atspair:string toggle:bool)
        (with-capability (P|ATSM|CALLER)
            (ATS.ATS|X_ToggleElite atspair toggle)
            (DALOS.IGNIS|C_Collect patron (ATS.ATS|UR_OwnerKonto atspair) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun ATSM|C_TurnRecoveryOn (patron:string atspair:string cold-or-hot:bool)
        (with-capability (P|ATSM|CALLER)
            (ATS.ATS|X_TurnRecoveryOn atspair cold-or-hot)
            (ATSI.ATSI|XC_EnsureActivationRoles patron atspair cold-or-hot)
            (DALOS.IGNIS|C_Collect patron (ATS.ATS|UR_OwnerKonto atspair) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun ATSM|C_AddSecondary (patron:string atspair:string reward-token:string rt-nfr:bool)
        (with-capability (P|ATSM|CALLER)
            (DPTF.DPTF|C_DeployAccount reward-token ATS.ATS|SC_NAME)
            (ATS.ATS|X_AddSecondary atspair reward-token rt-nfr)
            (DPTF.DPTF|X_UpdateRewardToken atspair reward-token true)
            (ATSI.ATSI|XC_EnsureActivationRoles patron atspair true)
            (if (ATS.ATS|URC_IzPresentHotRBT atspair)
                (ATSI.ATSI|XC_EnsureActivationRoles patron atspair false)
                true
            )
            (DALOS.IGNIS|C_Collect patron (ATS.ATS|UR_OwnerKonto atspair) (DALOS.DALOS|UR_UsagePrice "ignis|token-issue"))
        )
    )
    (defun ATSM|C_RemoveSecondary (patron:string remover:string atspair:string reward-token:string)
        (with-capability (ATSM|C>RM_SCND atspair reward-token)
            (let*
                (
                    (rt-lst:[string] (ATS.ATS|UR_RewardTokenList atspair))
                    (remove-position:integer (at 0 (UTILS.LIST|UC_Search rt-lst reward-token)))
                    (primal-rt:string (at 0 rt-lst))
                    (resident-sum:decimal (at remove-position (ATS.ATS|UR_RoUAmountList atspair true)))
                    (unbound-sum:decimal (at remove-position (ATS.ATS|UR_RoUAmountList atspair false)))
                    (remove-sum:decimal (+ resident-sum unbound-sum))
                    (accounts-with-atspair-data:[string] (TFT.DPTF-DPMF-ATS|UR_FilterKeysForInfo atspair 3 false))
                )
            ;;1]The RT to be removed, is transfered to the remover, from the ATS|SC_NAME
                (TFT.DPTF|C_Transfer patron reward-token ATS.ATS|SC_NAME remover remove-sum true)
            ;;2]The amount removed is added back as Primal-RT
                (TFT.DPTF|C_Transfer patron primal-rt remover ATS.ATS|SC_NAME remove-sum true)
            ;;3]ROU Table is updated with the new DATA, now as primal RT
                (ATS.ATS|X_UpdateRoU atspair primal-rt true true resident-sum)
                (ATS.ATS|X_UpdateRoU atspair primal-rt false true unbound-sum)
            ;;4]Client Accounts are modified to remove the RT Token and update balances with Primal RT
                (map
                    (lambda
                        (kontos:string)
                        (ATS.ATS|X_ReshapeUnstakeAccount atspair kontos remove-position)
                    )
                    accounts-with-atspair-data
                )
            ;;5]Actually Remove the RT from the ATS-Pair
                (ATS.ATS|X_RemoveSecondary atspair reward-token)
            ;;6]Update Data in the DPTF Token Properties
                (DPTF.DPTF|X_UpdateRewardToken atspair reward-token false)
            )
        )
    )
    (defun ATSM|C_AddHotRBT (patron:string atspair:string hot-rbt:string)
        (with-capability (P|ATSM|CALLER)
            (DPMF.DPMF|C_DeployAccount hot-rbt ATS.ATS|SC_NAME)
            (DPMF.DPMF|X_UpdateRewardBearingToken atspair hot-rbt)
            (ATS.ATS|X_AddHotRBT atspair hot-rbt)
            (ATSI.ATSI|XC_EnsureActivationRoles patron atspair false)
            (DALOS.IGNIS|C_Collect patron (ATS.ATS|UR_OwnerKonto atspair) (DALOS.DALOS|UR_UsagePrice "ignis|token-issue"))
        )
    )
    (defun ATSM|C_Syphon (patron:string syphon-target:string atspair:string syphon-amounts:[decimal])
        (with-capability (ATSM|C>SYPHON atspair syphon-amounts)
            (let
                (
                    (rt-lst:[string] (ATS.ATS|UR_RewardTokenList atspair))
                )
                (map
                    (lambda
                        (index:integer)
                        (if (> (at index syphon-amounts) 0.0)
                            (do
                                (TFT.DPTF|C_Transfer patron (at index rt-lst) ATS.ATS|SC_NAME syphon-target (at index syphon-amounts) true)
                                (ATS.ATS|X_UpdateRoU atspair (at index rt-lst) true false (at index syphon-amounts))
                            )
                            true
                        )
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
            )
        )
    )
    (defun ATSM|C_KickStart:decimal (patron:string kickstarter:string atspair:string rt-amounts:[decimal] rbt-request-amount:decimal)
        (with-capability (ATSM|C>KICKSTART kickstarter atspair rt-amounts rbt-request-amount)
            (let
                (
                    (rbt-id:string (ATS.ATS|UR_ColdRewardBearingToken atspair))
                    (rt-lst:[string] (ATS.ATS|UR_RewardTokenList atspair))
                )
                (map
                    (lambda
                        (index:integer)
                        (do
                            (TFT.DPTF|C_Transfer patron (at index rt-lst) kickstarter ATS.ATS|SC_NAME (at index rt-amounts) true)
                            (ATS.ATS|X_UpdateRoU atspair (at index rt-lst) true true (at index rt-amounts))
                        )
                        
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
                (DPTF.DPTF|C_Mint patron rbt-id ATS.ATS|SC_NAME rbt-request-amount false)
                (TFT.DPTF|C_Transfer patron rbt-id ATS.ATS|SC_NAME kickstarter rbt-request-amount true)
                (ATS.ATS|URC_Index atspair)
            )
        )
    )
    (defun ATSM|C_Coil:decimal (patron:string coiler:string atspair:string rt:string amount:decimal)
        (with-capability (ATSM|C>COIL_OR_CURL atspair rt)
            (let
                (
                    (c-rbt:string (ATS.ATS|UR_ColdRewardBearingToken atspair))
                    (c-rbt-amount:decimal (ATS.ATS|URC_RBT atspair rt amount))
                )
                (TFT.DPTF|C_Transfer patron rt coiler ATS.ATS|SC_NAME amount true)
                (ATS.ATS|X_UpdateRoU atspair rt true true amount)
                (DPTF.DPTF|C_Mint patron c-rbt ATS.ATS|SC_NAME c-rbt-amount false)
                (TFT.DPTF|C_Transfer patron c-rbt ATS.ATS|SC_NAME coiler c-rbt-amount true)
                c-rbt-amount
            )
        )
    )
    (defun ATSM|C_Curl:decimal (patron:string curler:string atspair1:string atspair2:string rt:string amount:decimal)
        (with-capability (ATSM|C>COIL_OR_CURL atspair1 rt)
            (let*
                (
                    (c-rbt1:string (ATS.ATS|UR_ColdRewardBearingToken atspair1))
                    (c-rbt1-amount:decimal (ATS.ATS|URC_RBT atspair1 rt amount))
                    (c-rbt2:string (ATS.ATS|UR_ColdRewardBearingToken atspair2))
                    (c-rbt2-amount:decimal (ATS.ATS|URC_RBT atspair2 c-rbt1 c-rbt1-amount))
                )
                (TFT.DPTF|C_Transfer patron rt curler ATS.ATS|SC_NAME amount true)
                (ATS.ATS|X_UpdateRoU atspair1 rt true true amount)
                (DPTF.DPTF|C_Mint patron c-rbt1 ATS.ATS|SC_NAME c-rbt1-amount false)
                (ATS.ATS|X_UpdateRoU atspair2 c-rbt1 true true c-rbt1-amount)
                (DPTF.DPTF|C_Mint patron c-rbt2 ATS.ATS|SC_NAME c-rbt2-amount false)
                (TFT.DPTF|C_Transfer patron c-rbt2 ATS.ATS|SC_NAME curler c-rbt2-amount true)
                c-rbt2-amount
            )
        )
    )
    ;;{16}
)

(create-table P|T)