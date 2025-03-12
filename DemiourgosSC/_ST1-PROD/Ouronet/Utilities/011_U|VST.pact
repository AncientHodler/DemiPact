(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(interface UtilityVst
    @doc "Exported Utility Functions for the VST Module"
    ;;
    (defun UC_MakeVestingDateList:[time] (offset:integer duration:integer milestones:integer))
    (defun UC_SplitBalanceForVesting:[decimal] (precision:integer amount:decimal milestones:integer))
    (defun UC_VestingID:[string] (dptf-name:string dptf-ticker:string))
    (defun UC_SleepingID:[string] (dptf-name:string dptf-ticker:string))
    (defun UC_FrozenID:[string] (dptf-name:string dptf-ticker:string))
    (defun UC_ReservedID:[string] (dptf-name:string dptf-ticker:string))
    ;;
    (defun UEV_Milestone (milestones:integer))
    (defun UEV_MilestoneWithTime (offset:integer duration:integer milestones:integer))
)
(module U|VST GOV
    ;;
    (implements UtilityVst)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|U|VST_ADMIN)))
    (defcap GOV|U|VST_ADMIN ()
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (g:guard (ref-U|CT::CT_GOV|UTILS))
            )
            (enforce-guard g)
        )
    )
    ;;{G3}
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    ;;{P3}
    ;;{P4}
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    ;;{C2}
    ;;{C3}
    ;;{C4}
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F-UC}
    (defun UC_MakeVestingDateList:[time] (offset:integer duration:integer milestones:integer)
        @doc "Makes a Times list with unvesting milestones according to vesting parameters"
        (let*
            (
                (present-time:time (at "block-time" (chain-data)))
                (first-time:time (add-time present-time offset))
                (times:[time] [first-time])
            )
            (if (= milestones 1)
                [(add-time present-time duration)]
                (fold
                    (lambda
                        (acc:[time] idx:integer)
                        (let*
                            (
                                (to-add:integer (* idx duration))
                                (new-time:time (add-time first-time to-add))
                            )
                            (+ acc [new-time])
                        )
                    )
                    times
                    (enumerate 1 (- milestones 1))
                )
            )

        )
    )
    (defun UC_SplitBalanceForVesting:[decimal] (precision:integer amount:decimal milestones:integer)
        @doc "Splits an Amount according to vesting parameters"
        (UEV_Milestone milestones)
        (enforce (!= milestones 0) "Cannot split with zero milestones")
        (let
            (
                (split:decimal (floor (/ amount (dec milestones)) precision))
                (multiply:integer (- milestones 1))
            )
            (enforce (> split 0.0) (format "Amount {} to small to split into {} milestones" [amount milestones]))
            (let*
                (
                    (big-chunk:decimal (floor (* split (dec multiply)) precision))
                    (last-split:decimal (floor (- amount big-chunk) precision))
                )
                (enforce (= (+ big-chunk last-split) amount) (format "Amount of {} could not be split into {} milestones succesfully" [amount milestones]))
                (+ (make-list multiply split) [last-split])
            )
        )
    )
    (defun UC_VestingID:[string] (dptf-name:string dptf-ticker:string)
        (UCX_SpecialID dptf-name dptf-ticker "Vested" "V")
    )
    (defun UC_SleepingID:[string] (dptf-name:string dptf-ticker:string)
        (UCX_SpecialID dptf-name dptf-ticker "Sleeping" "Z")
    )
    (defun UC_FrozenID:[string] (dptf-name:string dptf-ticker:string)
        (UCX_SpecialID dptf-name dptf-ticker "Frozen" "F")
    )
    (defun UC_ReservedID:[string] (dptf-name:string dptf-ticker:string)
        (UCX_SpecialID dptf-name dptf-ticker "Reserved" "R")
    )
    (defun UCX_SpecialID:[string] (dptf-name:string dptf-ticker:string special-name:string special-prefix:string)
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (max-name:integer (ref-U|CT::CT_MAX_TOKEN_NAME_LENGTH))
                (max-ticker:integer (ref-U|CT::CT_MAX_TOKEN_TICKER_LENGTH))
                (caron:string "^")
                (s1:string (+ special-name caron))
                (s2:string (+ special-prefix BAR))
                (l1:integer (- max-name (length s1)))
                (l2:integer (- max-ticker (length s2)))
                (vested-name:string (concat [s1 (take l1 dptf-name)]))
                (vested-ticker:string (concat [s2 (take l2 dptf-ticker)]))
            )
            [vested-name vested-ticker]
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_Milestone (milestones:integer)
        @doc "Restrict Milestone integer between 1 and 250 Milestones"
        (enforce
            (and (>= milestones 1) (<= milestones 250))
            (format "Milestone splitting number {} is out of bounds"[milestones])
        )
    )
    (defun UEV_MilestoneWithTime (offset:integer duration:integer milestones:integer)
        @doc "Validates Milestone duration to be lower than 25 years"
        (UEV_Milestone milestones)
        (enforce
            (<= (+ (* milestones duration ) offset) 788400000)
            "Total Vesting Time cannot be greater than 25 years"
        )
    )
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)