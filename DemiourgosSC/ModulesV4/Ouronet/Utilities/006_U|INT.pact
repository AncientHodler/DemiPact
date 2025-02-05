(module U|INT GOV
    ;;
    (implements OuronetIntegers)
    ;;{G1}
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|U|INT_ADMIN))
    )
    (defcap GOV|U|INT_ADMIN ()
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
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{F-UC}
    (defun UC_MaxInteger:integer (lst:[integer])
        (fold
            (lambda
                (acc:integer element:integer)
                (if (> element acc) element acc)
            )
            (at 0 lst)
            (drop 1 lst)
        )
    )
    ;;{F_UR}
    ;;{F-UEV}
    (defun UEV_PositionalVariable (integer-to-validate:integer positions:integer message:string)
        @doc "Validates a number (positions-number) as positional variable"
        (enforce (= (contains integer-to-validate (enumerate 1 positions)) true) message)
    )
    (defun UEV_UniformList (input:[integer])
        @doc "Enforces that all elements in the integer list are the same."
        (let 
            (
                (fe:integer (at 0 input))
            )  ;; Get the first element in the list
            (map
                (lambda 
                    (index:integer)
                    (enforce (= fe (at index input)) "List elements are not the same")
                    true
                )
                (enumerate 0 (- (length input) 1))
            )
        )
    )
    (defun UEV_ContainsAll (l1:[integer] l2:[integer])
        (let*
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (tl:[bool]
                    (fold
                        (lambda
                            (acc:[bool] item:integer)
                            (ref-U|LST::UC_AppL acc (contains item l2))
                        )
                        []
                        l1
                    )
                )
                (sl:[integer] (ref-U|LST::UC_Search tl true))
                (tl2:integer (length sl))
            )
            (if (= tl2 (length l1))
                true
                false
            )
        )
    )
    ;;{F-UDC}
    
)