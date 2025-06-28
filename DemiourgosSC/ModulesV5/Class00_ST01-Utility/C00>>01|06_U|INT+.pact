(interface OuronetIntegersV2
    @doc "Exported Integer Functions"
    (defschema SplitIntegers
        negative:[integer]
        positive:[integer]
    )
    ;;
    (defun UC_MaxInteger:integer (lst:[integer])) ;;2
    ;;
    (defun UEV_ContainsAll:bool (l1:[integer] l2:[integer]))
    (defun UEV_PositionalVariable (integer-to-validate:integer positions:integer message:string))
    (defun UEV_UniformList (input:[integer]))
)
(module U|INT GOV
    ;;
    (implements OuronetIntegersV2)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|U|INT_ADMIN)))
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
    (defun UC_SplitAuxiliaryIntegerList:object{OuronetIntegersV2.SplitIntegers} (primary:[integer] auxiliary:[integer])
        @doc "Splits an auxiliary integer list into 2 integers list, according to the negatives and positives of the primary"
        (let 
            (
                (indices (enumerate 0 (- (length primary) 1)))
                (neg-indices (filter (lambda (i:integer) (< (at i primary) 0)) indices))
                (pos-indices (filter (lambda (i:integer) (> (at i primary) 0)) indices))
                (neg-counterparts (map (lambda (i:integer) (at i auxiliary)) neg-indices))
                (pos-counterparts (map (lambda (i:integer) (at i auxiliary)) pos-indices))
            )
            (UDC_SplitIntegers neg-counterparts pos-counterparts)
        )
    )
    (defun UC_SplitIntegerList:object{OuronetIntegersV2.SplitIntegers} (input:[integer])
        @doc "Splits an integer list into a negative and postive integer list"
        (let 
            (
                (negatives (filter (lambda (x:integer) (< x 0)) input))
                (positives (filter (lambda (x:integer) (> x 0)) input))
            )
            (UDC_SplitIntegers negatives positives)
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_ContainsAll:bool (l1:[integer] l2:[integer])
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
    ;;{F3}  [UDC]
    (defun UDC_SplitIntegers:object{OuronetIntegersV2.SplitIntegers} (neg:[integer] pos:[integer])
        {"negative" : neg
        ,"positive" : pos}
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)