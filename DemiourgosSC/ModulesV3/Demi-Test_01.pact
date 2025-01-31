(module TEST GOV
    (defcap GOV ()
        true
    )

    (defun SSWP|UCC_DNext (D:decimal A:decimal X:[decimal])
        @doc "Computes Dnext: \
        \ n = (length X) \
        \ S=x1+x2+x3+... \
        \ P=x1*x2*x3*... \
        \ Dp = (D^(n+1))/(P*n^n) \
        \ Numerator = (A*n^n*S + Dp*n)*D \
        \ Denominator = (A*n^n-1)*D + (n+1)*Dp \
        \ DNext = Numerator / Denominator"
        ;;
        (let*
            (
                (prec:integer 24)
                (n:decimal (dec (length X)))
                (S:decimal (fold (+) 0.0 X))
                (P:decimal (floor (fold (*) 1.0 X) prec))
                (n1:decimal (+ 1.0 n))
                (nn:decimal (^ n n))
                (Dp:decimal (floor (/ (^ D n1) (* nn P)) prec))

                (v1:decimal (floor (fold (*) 1.0 [A nn S]) prec))
                (v2:decimal (* Dp n))
                (v3:decimal (+ v1 v2))
                (numerator:decimal (floor (* v3 D) prec))

                (v4:decimal (- (* A nn) 1.0))
                (v5:decimal (* v4 D))
                (v6:decimal (floor (* n1 Dp) prec))
                (denominator:decimal (+ v5 v6))
            )
            (floor (/ numerator denominator) prec)
        )
    )
    (defun SSWP|UCC_ComputeD:decimal (A:decimal X:[decimal])
        (let*
            (
                (output-lst:[decimal]
                    (fold
                        (lambda
                            (d-values:[decimal] idx:integer)
                            (let*
                                (
                                    (prev-d:decimal (at idx d-values))
                                    (d-value:decimal (SSWP|UCC_DNext prev-d A X))
                                )
                                (UTILS.LIST|UC_AppendLast d-values d-value)
                            )
                        )
                        [(fold (+) 0.0 X)]
                        (enumerate 0 5)
                    )
                )
            )
            (UTILS.LIST|UC_LastListElement output-lst)
        )
    )
    (defun SSWP|UCC_ComputeD2:[decimal] (A:decimal X:[decimal])
        (let*
            (
                (output-lst:[decimal]
                    (fold
                        (lambda
                            (d-values:[decimal] idx:integer)
                            (let*
                                (
                                    (prev-d:decimal (at idx d-values))
                                    (d-value:decimal (SSWP|UCC_DNext prev-d A X))
                                )
                                (UTILS.LIST|UC_AppendLast d-values d-value)
                            )
                        )
                        [(fold (+) 0.0 X)]
                        (enumerate 0 5)
                    )
                )
            )
            output-lst
        )
    )
    (defun SSWP|UCC_YNext (Y:decimal D:decimal A:decimal X:[decimal] op:integer)
        @doc "Computes Y such that the invariant remains satisfied \
        \ Sp = x1+x2+x3+ ... without the term to be computed, containing the modified input token amount \
        \ Pp = x1*x2*x3* ... without the term to be computed, containing the modified input token amount \
        \ c = (D^(n+1))/(n^n*Pp*A*n^n) \
        \ b = Sp + (D/A*n^n) \
        \ Numerator = y^2 + c \
        \ Denominator = 2*y + b - D \
        \ YNext = Numerator / Denominator "
        (let*
            (
                (prec:integer 24)
                (n:decimal (dec (length X)))
                (XXX:[decimal] (UTILS.LIST|UC_RemoveItem X (at op X)))
                (Sp:decimal (fold (+) 0.0 XXX))
                (Pp:decimal (floor (fold (*) 1.0 XXX) prec))
                (n1:decimal (+ 1.0 n))
                (nn:decimal (^ n n))
                (c:decimal (floor (/ (^ D n1) (fold (*) 1.0 [nn Pp A nn])) prec))
                (b:decimal (floor (+ Sp (/ D (* A nn))) prec))
                (Ysq:decimal (^ Y 2.0))
                (numerator:decimal (floor (+ Ysq c) prec))
                (denominator:decimal (floor (- (+ (* Y 2.0) b) D) prec))
            )
            (floor (/ numerator denominator) prec)
        )
    )

    (defun SSWP|UCC_ComputeY:decimal (A:decimal X:[decimal] input-amount:decimal ip:integer op:integer)
        (let*
            (
                (xi:decimal (at ip X))
                (xn:decimal (+ xi input-amount))
                (XX:[decimal] (UTILS.LIST|UC_ReplaceAt X ip xn))
                (NewD:decimal (SSWP|UCC_ComputeD A XX))
                (y0:decimal (+ (at op X) input-amount))
                (output-lst:[decimal]
                    (fold
                        (lambda
                            (y-values:[decimal] idx:integer)
                            (let*
                                (
                                    (prev-y:decimal (at idx y-values))
                                    (y-value:decimal (SSWP|UCC_YNext prev-y NewD A X op))
                                )
                                (UTILS.LIST|UC_AppendLast y-values y-value)
                            )
                        )
                        [y0]
                        (enumerate 0 3)
                    )
                )
            )
            (UTILS.LIST|UC_LastListElement output-lst)
            ;(- (UTILS.LIST|UC_LastListElement output-lst) (at op X))
        )
    )




    (defun SSWP|UC_YRefineCore (Ytrf:decimal A:decimal X:[decimal] yp:integer)
        ;;outputs D with Ytrf
        (SSWP|UCC_ComputeD A (UTILS.LIST|UC_ReplaceAt X yp Ytrf))
    )

    ;;A:decimal X:[decimal] input-amount:decimal ip:integer op:integer
    ;;first D
    ;;first Y floored with 1 decimal

    ;;subsequent D and their resulting difference ==> function that computes the difference.


    (defun SSWP|UCC_DifferenceD:decimal (MainD:decimal YTRF:decimal A:decimal X:[decimal] op:integer)
        (let*
            (
                (XY:[decimal] (UTILS.LIST|UC_ReplaceAt X op YTRF))
                (RFD:decimal (SSWP|UCC_ComputeD A XY))
            )
            (- MainD RFD)
        )
    )
    (defun SSWP|UCC_RefineY (A:decimal X:[decimal] input-amount:decimal ip:integer op:integer)
        (let*
            (
                (xi:decimal (at ip X))
                (xn:decimal (+ xi input-amount))
                (XX:[decimal] (UTILS.LIST|UC_ReplaceAt X ip xn))
                (InitD:decimal (SSWP|UCC_ComputeD A XX))

                (Y:decimal (SSWP|UCC_ComputeY A X input-amount ip op))
                (FirstY (floor Y 12))

                (refinery:[object{Refinery}] (SSWP|UCC_RefineDecimal InitD FirstY A X op))
            )
            refinery
        )
    )
    (defschema Refinery
        y:decimal
        diff:decimal
    )
    ;{ "y": x, "v": y }
    (defun SSWP|UC_LastPos:integer (input:[object{Refinery}])
        (let*
            (
                (fi:[object{Refinery}] 
                    (filter
                        (lambda (item) (<= 0.0 (at "diff" item)))
                        input
                    )
                )
                (lastfi:object{Refinery} (UTILS.LIST|UC_LastListElement fi))
                (opl:[integer] (UTILS.LIST|UC_Search input lastfi))
            )
            (at 0 opl)
        )
    )

    (defun SSWP|UCC_RefineDecimal:[object{Refinery}] (InitD:decimal Y:decimal A:decimal X:[decimal] op:integer)
        (let*
            (
                (first-diff:decimal (SSWP|UCC_DifferenceD InitD Y A X op))
                (Y0:object{Refinery} { "y": Y, "diff": first-diff})

                (refinery:[object{Refinery}]
                    (fold
                        (lambda
                            (acc:[object{Refinery}] idx:integer)
                            (let*
                                (
                                    (prev-idx:integer (- idx 1))
                                    (prev-ipsilon:decimal (at "y" (at prev-idx acc)))
                                    (prev-diff:decimal (at "diff" (at prev-idx acc)))

                                    (last-pos-idx:integer (SSWP|UC_LastPos acc))
                                    (last-pos-ipsilon (at "y" (at last-pos-idx acc)))
                                    (offset (- prev-idx last-pos-idx))

                                    (next-ipsilon:decimal
                                        (if (= prev-diff 0.0)
                                            0.0
                                            (if (> prev-diff 0.0)
                                                (SSWP|UCC_MDwPO prev-ipsilon)
                                                (SSWP|UCC_MDwNO last-pos-ipsilon offset)
                                            )
                                        )
                                        
                                    )
                                    (next-diff:decimal 
                                        (if (= prev-diff 0.0)
                                            0.0
                                            (SSWP|UCC_DifferenceD InitD next-ipsilon A X op))
                                        )
                                    (next-item:object{Refinery} { "y": next-ipsilon, "diff": next-diff })
                                )
                                (UTILS.LIST|UC_AppendLast acc next-item)
                            )
                        )
                        [Y0]
                        (enumerate 1 90)
                    )
                )
            )
            refinery
        )
    )

    (defun SSWP|UCC_MDwNO (i:decimal p:integer)
        (SSWP|UCC_MD i p)
    )
    (defun SSWP|UCC_MDwPO (i:decimal)
        (SSWP|UCC_MD i 0)
    )
    (defun SSWP|UCC_MD (i:decimal p:integer)
        (floor
            (cond
                ((SSWP|UC_PB i 1) (SSWP|UC_ND i (+ 1 p)))
                ((SSWP|UC_PB i 2) (SSWP|UC_ND i (+ 2 p)))
                ((SSWP|UC_PB i 3) (SSWP|UC_ND i (+ 3 p)))
                ((SSWP|UC_PB i 4) (SSWP|UC_ND i (+ 4 p)))
                ((SSWP|UC_PB i 5) (SSWP|UC_ND i (+ 5 p)))
                ((SSWP|UC_PB i 6) (SSWP|UC_ND i (+ 6 p)))
                ((SSWP|UC_PB i 7) (SSWP|UC_ND i (+ 7 p)))
                ((SSWP|UC_PB i 8) (SSWP|UC_ND i (+ 8 p)))
                ((SSWP|UC_PB i 9) (SSWP|UC_ND i (+ 9 p)))
                ((SSWP|UC_PB i 10) (SSWP|UC_ND i (+ 10 p)))
                ((SSWP|UC_PB i 11) (SSWP|UC_ND i (+ 11 p)))
                ((SSWP|UC_PB i 12) (SSWP|UC_ND i (+ 12 p)))
                ((SSWP|UC_PB i 13) (SSWP|UC_ND i (+ 13 p)))
                ((SSWP|UC_PB i 14) (SSWP|UC_ND i (+ 14 p)))
                ((SSWP|UC_PB i 15) (SSWP|UC_ND i (+ 15 p)))
                ((SSWP|UC_PB i 16) (SSWP|UC_ND i (+ 16 p)))
                ((SSWP|UC_PB i 17) (SSWP|UC_ND i (+ 17 p)))
                ((SSWP|UC_PB i 18) (SSWP|UC_ND i (+ 18 p)))
                ((SSWP|UC_PB i 19) (SSWP|UC_ND i (+ 19 p)))
                ((SSWP|UC_PB i 20) (SSWP|UC_ND i (+ 20 p)))
                ((SSWP|UC_PB i 21) (SSWP|UC_ND i (+ 21 p)))
                ((SSWP|UC_PB i 22) (SSWP|UC_ND i (+ 22 p)))
                ((SSWP|UC_PB i 23) (SSWP|UC_ND i (+ 23 p)))
                ((SSWP|UC_PB i 24) (SSWP|UC_ND i (+ 24 p)))
                true
            )
            24
        )
    )
    (defun SSWP|UC_PB (i:decimal p:integer)
        (= i (floor i p))
    )
    (defun SSWP|UC_ND (i:decimal p:integer)
        (+ i (/ 1.0 (dec(^ 10 p))))
    )
    ;;=============================================================================
    (defun SWP|UC_Liquidity:[decimal] (ia:decimal ip:integer i-prec X:[decimal] Xp:[integer])
        (let*
            (
                (raport:decimal (floor (/ ia (at ip X)) i-prec))
                (output:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (UTILS.LIST|UC_AppendLast 
                                acc 
                                (if (= idx ip)
                                    ia
                                    (floor (* raport (at idx X)) (at idx Xp))
                                )
                            )
                        )
                        []
                        (enumerate 0 (- (length X) 1))
                    )
                )
            )
            output
        )
    )

    
)