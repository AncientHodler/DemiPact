(interface UtilityAtsV2
    @doc "Exported Utility Functions for the ATS and ATSU Modules"
    ;;
    (defschema Awo
        reward-tokens:[decimal]
        cull-time:time
    )
    ;;
    (defun UC_IzCullable:bool (input:object{Awo}))
    (defun UC_IzUnstakeObjectValid:bool (input:object{Awo}))
    (defun UC_MakeHardIntervals:[integer] (start:integer growth:integer))
    (defun UC_MakeSoftIntervals:[integer] (start:integer growth:integer))
    (defun UC_MultiReshapeUnstakeObject:[object{Awo}] (input:[object{Awo}] remove-position:integer))
    (defun UC_PromilleSplit:[decimal] (promille:decimal input:decimal input-precision:integer))
    (defun UC_ReshapeUnstakeObject:object{Awo} (input:object{Awo} remove-position:integer))
    (defun UC_SolidifyUnstakeObject:object{Awo} (input:object{Awo} remove-position:integer))
    (defun UC_SplitBalanceWithBooleans:[decimal] (precision:integer amount:decimal milestones:integer boolean:[bool]))
    (defun UC_SplitByIndexedRBT:[decimal] (rbt-amount:decimal pair-rbt-supply:decimal index:decimal resident-amounts:[decimal] rt-precisions:[integer]))
    (defun UC_UnlockPrice:[decimal] (unlocks:integer))
    ;;
    (defun UEV_AutostakeIndex (ats:string))
    (defun UEV_UniqueAtspair (ats:string))
        ;;
    (defun UEV_CRF|Positions (fee-positions:integer))
    (defun UEV_CRF|FeeThresholds (fee-thresholds:[decimal] c-rbt-prec:integer))
    (defun UEV_CRF|FeeArray (fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]]))
    (defun UEV_Fee (fee:decimal))
    (defun UEV_Decay (decay:integer))
    (defun UEV_HibernationFees (peak:decimal decay:decimal))
        ;;
    (defun UEV_ColdDurationParameters (soft-or-hard:bool base:integer growth:integer))
    ;;
    (defun UDC_Elite (x:decimal))
)
(interface UtilityVstV2
    @doc "Exported Utility Functions for the VST Module"
    ;;
    (defun UC_MakeVestingDateList:[time] (offset:integer duration:integer milestones:integer))
    (defun UC_SplitBalanceForVesting:[decimal] (precision:integer amount:decimal milestones:integer))
    (defun UC_VestingID:[string] (dptf-name:string dptf-ticker:string))
    (defun UC_SleepingID:[string] (dptf-name:string dptf-ticker:string))
    (defun UC_HibernationID:[string] (dptf-name:string dptf-ticker:string))
        ;;
    (defun UC_FrozenID:[string] (dptf-name:string dptf-ticker:string))
    (defun UC_ReservedID:[string] (dptf-name:string dptf-ticker:string))
        ;;
    (defun UC_EquityID:[string] (sft-name:string sft-ticker:string))
    ;;
    (defun UEV_Milestone (milestones:integer))
    (defun UEV_MilestoneWithTime (offset:integer duration:integer milestones:integer upper-limit-in-seconds:integer))
)