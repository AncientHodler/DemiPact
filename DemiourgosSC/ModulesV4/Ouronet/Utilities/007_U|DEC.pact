(interface OuronetDecimals
    @doc "Exported Decimal Functions"
    ;;
    (defun UC_AddArray:[decimal] (array:[[decimal]]))
    (defun UC_AddHybridArray (lists)) ;;2
    (defun UC_Max (x y))
    (defun UC_Percent:decimal (x:decimal percent:decimal precision:integer)) ;;3
    (defun UC_Promille:decimal (x:decimal promille:decimal precision:integer)) ;;1
    (defun UC_UnlockPrice:[decimal] (unlocks:integer dptf-or-ats:bool)) ;;2
    ;;
    (defun UEV_DecimalArray (array:[[decimal]])) ;;1
)
(module U|DEC GOV
    ;;
    (implements OuronetDecimals)
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|U|DEC_ADMIN))
    )
    (defcap GOV|U|DEC_ADMIN ()
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (g:guard (ref-U|CT::CT_GOV|UTILS))
            )
            (enforce-guard g)
        )
    )
    ;;
    (defun UC_AddArray:[decimal] (array:[[decimal]])
        @doc "Adds all column elements in an array of decimal elements, while ensuring all rows are of equal length"
        (UEV_DecimalArray array)
        (fold
            (lambda
                (acc:[decimal] item:[decimal])
                (zip (+) acc item)
            )
            (make-list (length (at 0 array)) 0.0)
            array
        )
    )
    (defun UC_AddHybridArray (lists)
        @doc "Adds all column elements in an array of numbers, even if the inner lists are of unequal lengths"
        (let 
            (
                (maxl 
                    (fold 
                        (lambda 
                            (acc lst) 
                            (UC_Max acc (length lst))
                        )
                        0
                        lists
                    )
                )
            )
            (map 
                (lambda 
                    (i)
                    (fold 
                        (+) 
                        0.0
                        (map 
                            (lambda 
                                (inner-lst)
                                (if (< i (length inner-lst))
                                    (at i inner-lst)
                                    0.0
                                )
                            )
                            lists
                        )
                    )
                )
                (enumerate 0 (- maxl 1))
            )
        )
    )
    (defun UC_Max (x y)
        (if (> x y) x y)
    )
    (defun UC_Percent:decimal (x:decimal percent:decimal precision:integer)
        (enforce (and (> percent 0.0)(<= percent 100.0)) "Invalid percent amount")
        (floor (* (/ percent 100.0) x) precision)
    )
    (defun UC_Promille:decimal (x:decimal promille:decimal precision:integer)
        (enforce (and (> promille 0.0)(<= promille 1000.0)) "Invalid permille amount")
        (floor (* (/ promille 1000.0) x) precision)
    )
    (defun UC_UnlockPrice:[decimal] (unlocks:integer dptf-or-ats:bool)
        @doc "Computes  ATS or DPTF unlock price \
        \ Outputs [virtual-gas-costs native-gas-cost] \
        \ Virtual Gas Token = IGNIS; Native Gas Token = KADENA"
        (let*
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (dptf:decimal (ref-U|CT::CT_DPTF-FeeLock))
                (ats:decimal (ref-U|CT::CT_ATS-FeeLock))
                (multiplier:decimal (dec (+ unlocks 1)))
                (base:decimal (if dptf-or-ats dptf ats))
                (gas-cost:decimal (* base multiplier))
                (gaz-cost:decimal (/ gas-cost 100.0))
            )
            [gas-cost gaz-cost]
        )
    )
    ;;{F-UEV}
    (defun UEV_DecimalArray (array:[[decimal]])
        @doc "Enforces all inner list inside an array of decimal elements are of equal size"
        (enforce
            (=
                true
                (fold
                    (lambda
                        (acc:bool inner-lst:[decimal])
                        (and
                            acc
                            (if (= 
                                    (length inner-lst) 
                                    (length (at 0 array))
                                )
                                true
                                false
                            )
                        )
                    )
                    true
                    array
                )
            )
            "All Fee-Array Lists must be of equal length !"
        )
    )
)