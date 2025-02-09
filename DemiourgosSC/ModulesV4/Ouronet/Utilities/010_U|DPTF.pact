(interface UtilityDptf
    @doc "Exported Utility Functions for the DPTF Module \
        \ Commented Functions are internal use only and have no use outside the module"
    ;;  
    (defun UC_OuroLoanLimit (elite-auryn-amount:decimal dispo-data:[decimal] ouro-precision:integer))
    (defun UC_UnlockPrice:[decimal] (unlocks:integer)) ;;1
    (defun UC_VolumetricTax (precision:integer amount:decimal)) ;;1
    ;(defun UCI_VolumetricPermile:decimal (precision:integer unit:integer))
)
(module U|DPTF GOV
    ;;
    (implements UtilityDptf)
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
    ;;
    ;;{F-UC}
    (defun UC_OuroLoanLimit (elite-auryn-amount:decimal dispo-data:[decimal] ouro-precision:integer)
        (let
            (
                (a-idx:decimal (at 0 dispo-data))
                (ea-idx:decimal (at 1 dispo-data))
                (major:decimal (at 2 dispo-data))
                (minor:decimal (at 3 dispo-data))
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
                (floor (fold (*) 1.0 [a-idx ea-idx elite-auryn-amount olpd]) ouro-precision)
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
                (logarithm-lst:[decimal] (map (lambda (u:integer) (UCI_VolumetricPermile precision u)) integer-lst))
                (multiply-lst:[decimal] (zip (lambda (x:decimal y:decimal) (* x y)) amount-dec-rev-lst logarithm-lst))
                (volumetric-fee:decimal (floor (fold (+) 0.0 multiply-lst) precision))
            )
            volumetric-fee
        )
    )
    (defun UCI_VolumetricPermile:decimal (precision:integer unit:integer)
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
)