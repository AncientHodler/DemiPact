(module U|DPTF GOV
    ;;
    (implements UtilityDptf)
    ;;{G1}
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|U|DPTF_ADMIN))
    )
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
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{F-UC}
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
    ;;{F_UR}
    ;;{F-UEV}
    ;;{F-UDC}
    
)