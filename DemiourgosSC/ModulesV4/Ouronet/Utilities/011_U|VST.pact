(module U|VST GOV
    ;;
    (implements Ouronet4Vst)
    ;;{G1}
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|U|VST_ADMIN))
    )
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
    ;;{P1}
    ;;{P2}
    ;;{P3}
    ;;{P4}
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    (defun UEV_Milestone (milestones:integer)
        @doc "Restrict Milestone integer between 1 and 365 Milestones"
        (enforce 
            (and (>= milestones 1) (<= milestones 365)) 
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
    (defun UC_MakeVestingDateList:[time] (offset:integer duration:integer milestones:integer)
        @doc "Makes a Times list with unvesting milestones according to vesting parameters"
        (let*
            (
                (present-time:time (at "block-time" (chain-data)))
                (first-time:time (add-time present-time offset))
                (times:[time] [first-time])
            )
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