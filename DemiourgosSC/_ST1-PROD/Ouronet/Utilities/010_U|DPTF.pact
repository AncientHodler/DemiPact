(namespace "...")
(interface UtilityDptf
    @doc "Exported Utility Functions for the DPTF Module \
        \ Commented Functions are internal use only and have no use outside the module"
    ;;
    (defschema DispoData
        @doc "Stores the information needed to compute the maximum Negative Ouro an Account is allowed to overconsume"
        elite-auryn-amount:decimal
        auryndex-value:decimal
        elite-auryndex-value:decimal
        major-tier:integer
        minor-tier:integer
        ouroboros-precision:integer
    )
    ;;
    (defun EmptyDispo:object{DispoData} ())
    ;;
    (defun UC_TwoSplitter:[integer] (input:integer))
    (defun UC_FourSplitter:[integer] (input:integer))
    (defun UC_EightSplitter:[integer] (input:integer))
    ;;
    (defun UC_OuroDispo:decimal (input:object{DispoData}))
    (defun UC_UnlockPrice:[decimal] (unlocks:integer))
    (defun UC_VolumetricTax (precision:integer amount:decimal))
)
(module U|DPTF GOV
    ;;
    (implements UtilityDptf)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|U|DPTF_ADMIN)))
    (defcap GOV|U|DPTF_ADMIN ()
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
    (defun EmptyDispo:object{DispoData} ()
        {"elite-auryn-amount"           :0.0
        ,"auryndex-value"               :-1.0
        ,"elite-auryndex-value"         :-1.0
        ,"major-tier"                   :0
        ,"minor-tier"                   :0
        ,"ouroboros-precision"          :24}
    )
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
    (defun UC_TwoSplitter:[integer] (input:integer)
        (let
            (
                (dec-in:decimal (dec input))
                (div:decimal (/ dec-in 2.0))
                (rest:decimal (- div (dec (floor div))))
            )
            (cond
                ((= rest 0.0) (make-list 2 (floor div)))
                ((= rest 0.5) (+ (make-list 1 (+ 1 (floor div))) (make-list 1 (floor div))))
                [0 0 0 0]
            )
        )
    )
    (defun UC_FourSplitter:[integer] (input:integer)
        (let
            (
                (dec-in:decimal (dec input))
                (div:decimal (/ dec-in 4.0))
                (rest:decimal (- div (dec (floor div))))
            )
            (cond
                ((= rest 0.0) (make-list 4 (floor div)))
                ((= rest 0.25) (+ (make-list 1 (+ 1 (floor div))) (make-list 3 (floor div))))
                ((= rest 0.5) (+ (make-list 2 (+ 1 (floor div))) (make-list 2 (floor div))))
                ((= rest 0.75) (+ (make-list 3 (+ 1 (floor div))) (make-list 1 (floor div))))
                [0 0 0 0]
            )
        )
    )
    (defun UC_EightSplitter:[integer] (input:integer)
        (let
            (
                (dec-in:decimal (dec input))
                (div:decimal (/ dec-in 8.0))
                (rest:decimal (- div (dec (floor div))))
            )
            (cond
                ((= rest 0.0) (make-list 8 (floor div)))
                ((= rest 0.125) (+ (make-list 1 (+ 1 (floor div))) (make-list 7 (floor div))))
                ((= rest 0.25) (+ (make-list 2 (+ 1 (floor div))) (make-list 6 (floor div))))
                ((= rest 0.375) (+ (make-list 3 (+ 1 (floor div))) (make-list 5 (floor div))))
                ((= rest 0.5) (+ (make-list 4 (+ 1 (floor div))) (make-list 4 (floor div))))
                ((= rest 0.625) (+ (make-list 5 (+ 1 (floor div))) (make-list 3 (floor div))))
                ((= rest 0.75) (+ (make-list 6 (+ 1 (floor div))) (make-list 2 (floor div))))
                ((= rest 0.875) (+ (make-list 7 (+ 1 (floor div))) (make-list 1 (floor div))))
                [0 0 0 0]
            )
        )
    )
    (defun UC_OuroDispo:decimal (input:object{DispoData})
        (let
            (
                (ea-amount:decimal (at "elite-auryn-amount" input))
                (a-idx:decimal (at "auryndex-value" input))
                (ea-idx:decimal (at "elite-auryndex-value" input))
                (major:decimal (dec (at "major-tier" input)))
                (minor:decimal (dec (at "minor-tier" input)))
                (o-prec:integer (at "ouroboros-precision" input))

                (olp:decimal
                    (if (< major 3.0)
                        0.0
                        (floor (+ (/ (- (+ (* (- major 1) 7.0) minor) 15.0) 10.0) 11.5) 1)
                    )
                )
                (olpd:decimal (floor (/ olp 100.0) 3))
            )
            (if (or (= -1.0 a-idx) (= -1.0 ea-idx))
                0.0
                (floor (fold (*) 1.0 [a-idx ea-idx ea-amount olpd]) o-prec)
            )
        )
    )
    (defun UC_UnlockPrice:[decimal] (unlocks:integer)
        @doc "Computes  ATS unlock price \
            \ Outputs [virtual-gas-costs (IGNIS) native-gas-cost(KDA)]"
        (let
            (
                (ref-U|DEC:module{OuronetDecimals} U|DEC)
            )
            (ref-U|DEC::UC_UnlockPrice unlocks true)
        )
    )
    (defun UC_VolumetricTax (precision:integer amount:decimal)
        @doc "Computes Volumetric-Transaction-Tax (VTT) value, given an Input Decimal <amount>"
        (let*
            (
                (amount-int:integer (floor amount))
                (amount-str:string (int-to-str 10 amount-int))
                (amount-str-rev-lst:[string] (reverse (str-to-list amount-str)))
                (amount-dec-rev-lst:[decimal] (map (lambda (x:string) (dec (str-to-int 10 x))) amount-str-rev-lst))
                (integer-lst:[integer] (enumerate 0 (- (length amount-dec-rev-lst) 1)))
                (logarithm-lst:[decimal] (map (lambda (u:integer) (UCX_VolumetricPermile precision u)) integer-lst))
                (multiply-lst:[decimal] (zip (lambda (x:decimal y:decimal) (* x y)) amount-dec-rev-lst logarithm-lst))
                (volumetric-fee:decimal (floor (fold (+) 0.0 multiply-lst) precision))
            )
            volumetric-fee
        )
    )
    (defun UCX_VolumetricPermile:decimal (precision:integer unit:integer)
        @doc "Auxiliary computation function needed to compute the volumetric the VTT"
        (let*
            (
                (logarithm-base:decimal (if (= unit 0) 0.0 (dec (str-to-int 10 (concat (make-list unit "7"))))))
                (logarithm-number:decimal (dec (^ 10 unit)))
                (logarithm:decimal (floor (log logarithm-base logarithm-number) precision))
                (volumetric-permile:decimal (floor (* logarithm-number (/ logarithm 1000.0)) precision))
            )
            volumetric-permile
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)