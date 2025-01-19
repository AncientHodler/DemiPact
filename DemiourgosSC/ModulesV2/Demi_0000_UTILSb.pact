(module SUT GOV
    ;;
    ;;{G1}
    (defconst GOV|MD_SUT   (keyset-ref-guard UTILS.GOV|DEMIURGOI))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|SUT_ADMIN))
    )
    (defcap GOV|SUT_ADMIN ()
        (enforce-guard GOV|MD_SUT)
    )
    ;;{G3}
    ;;
    ;;
    ;;{P1}
    ;;{P2}
    ;;{P3}
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
    ;;{5}
    ;;{6}
    ;;{7}
    ;;
    ;;{8}
    ;;{9}
    ;;{10}
    ;;{11}
    (defun SWP|UC_ComputeP (X:[decimal] input-amounts:[decimal] ip:[integer] op:integer o-prec)
        (let*
            (
                (pool-product:decimal (floor (fold (*) 1.0 X) 24))
                (l1:integer (length X))
                (new-supplies:[decimal] (SUT|UC_NewSupply X input-amounts ip))
                (new-supplies-rem:[decimal] (UTILS.LIST|UC_RemoveItemAt new-supplies op))
                (new-supplies-product:decimal (floor (fold (*) 1.0 new-supplies-rem) 24))
                (output:decimal (floor (/ pool-product new-supplies-product) o-prec))
            )
            (- (at op X) output)
        )
    )
    (defun SUT|UC_NewSupply (X:[decimal] input-amounts:[decimal] ip:[integer])
        (fold
            (lambda
                (acc:[decimal] idx:integer)
                (UTILS.LIST|UC_AppendLast 
                    acc 
                    (+ 
                        (if (contains idx ip)
                            (at (at 0 (UTILS.LIST|UC_Search ip idx)) input-amounts)
                            0.0
                        )
                        (at idx X)
                    )
                )
            )
            []
            (enumerate 0 (- (length X) 1))
        )
    )
    (defun SWP|UC_ComputeY (A:decimal X:[decimal] input-amount:decimal ip:integer op:integer)
        (let*
            (
                (xi:decimal (at ip X))
                (xn:decimal (+ xi input-amount))
                (XX:[decimal] (UTILS.LIST|UC_ReplaceAt X ip xn))
                (NewD:decimal (SUT|UC_ComputeD A XX))
                (y0:decimal (+ (at op X) input-amount))
                (output-lst:[decimal]
                    (fold
                        (lambda
                            (y-values:[decimal] idx:integer)
                            (let*
                                (
                                    (prev-y:decimal (at idx y-values))
                                    (y-value:decimal (SWP|UC_YNext prev-y NewD A X op))
                                )
                                (UTILS.LIST|UC_AppendLast y-values y-value)
                            )
                        )
                        [y0]
                        (enumerate 0 10)
                    )
                )
            )
            (- (UTILS.LIST|UC_LastListElement output-lst) (at op X))
        )
    )
    (defun SUT|UC_ComputeD:decimal (A:decimal X:[decimal])
        (let*
            (
                (output-lst:[decimal]
                    (fold
                        (lambda
                            (d-values:[decimal] idx:integer)
                            (let*
                                (
                                    (prev-d:decimal (at idx d-values))
                                    (d-value:decimal (SUT|UC_DNext prev-d A X))
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
    (defun SUT|UC_DNext (D:decimal A:decimal X:[decimal])
        @doc "Computes Dnext: \
        \ n = (length X) \
        \ S=x1+x2+x3+... \
        \ P=x1*x2*x3*... \
        \ Dp = (D^(n+1))/(P*n^n) \
        \ Numerator = (A*n^n*S + Dp*n)*D \
        \ Denominator = (A*n^n-1)*D + (n+1)*Dp \
        \ DNext = Numerator / Denominator"
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
    (defun SWP|UC_YNext (Y:decimal D:decimal A:decimal X:[decimal] op:integer)
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
                (XX:[decimal] (UTILS.LIST|UC_ReplaceAt X op -1.0))
                (XXX:[decimal] (UTILS.LIST|UC_RemoveItem XX -1.0))
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
    ;;
    (defun SWP|UC_LP:[string] (token-names:[string] token-tickers:[string] amp:decimal)
        (if (= amp -1.0)
            (SWP|UC_LpIDs token-names token-tickers true)
            (SWP|UC_LpIDs token-names token-tickers false)
        )
    )
    (defun SWP|UC_LpIDs:[string] (token-names:[string] token-tickers:[string] p-or-s:bool)
        (let*
            (
                (l1:integer (length token-names))
                (l2:integer (length token-tickers))
                (lengths:[integer] [l1 l2])
                (prefix:string (if p-or-s "P" "S"))
                (minus:string "-")
                (caron:string "^")
            )
            (UTILS.UTILS|UEV_EnforceUniformIntegerList lengths)
            (let*
                (
                    (lp-name-elements:[string]
                        (fold
                            (lambda
                                (acc:[string] idx:integer)
                                (if (!= idx (- l1 1))
                                    (UTILS.LIST|UC_AppendLast acc (+ (at idx token-names) caron))
                                    (UTILS.LIST|UC_AppendLast acc (at idx token-names))
                                )
                            )
                            []
                            (enumerate 0 (- l1 1))
                        )
                    )
                    (lp-ticker-elements:[string]
                        (fold
                            (lambda
                                (acc:[string] idx:integer)
                                (if (!= idx (- l1 1))
                                    (UTILS.LIST|UC_AppendLast acc (+ (at idx token-tickers) minus))
                                    (UTILS.LIST|UC_AppendLast acc (at idx token-tickers))
                                )
                            )
                            []
                            (enumerate 0 (- l1 1))
                        )
                    )
                    (lp-name:string (concat [prefix UTILS.BAR (concat lp-name-elements)]))
                    (lp-ticker:string (concat [prefix UTILS.BAR (concat lp-ticker-elements) UTILS.BAR "LP"]))
                )
                [lp-name lp-ticker]
            )
        )
    )
    (defun SWP|UC_Swpair:string (token-ids:[string] amp:decimal)
        (if (= amp -1.0)
            (SWP|UC_PoolID token-ids true)
            (SWP|UC_PoolID token-ids false)
        )
    )
    (defun SWP|UC_PoolID:string (token-ids:[string] p-or-s:bool)
        (let*
            (
                (prefix:string (if p-or-s "P" "S"))
                (swpair-elements:[string]
                    (fold
                        (lambda
                            (acc:[string] idx:integer)
                            (if (!= idx (- (length token-ids) 1))
                                (UTILS.LIST|UC_AppendLast acc (+ (at idx token-ids) UTILS.BAR))
                                (UTILS.LIST|UC_AppendLast acc (at idx token-ids))
                            )
                        )
                        []
                        (enumerate 0 (- (length token-ids) 1))
                    )
                )
            )
            (concat [prefix UTILS.BAR (concat swpair-elements)])
        )
    )
    (defun SWP|UC_BalancedLiquidity:[decimal] (ia:decimal ip:integer i-prec X:[decimal] Xp:[integer])
        (let*
            (
                (ratio:decimal (floor (/ ia (at ip X)) i-prec))
                (output:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (UTILS.LIST|UC_AppendLast 
                                acc 
                                (if (= idx ip)
                                    ia
                                    (floor (* ratio (at idx X)) (at idx Xp))
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
    ;;{12}
    ;;{13}
    ;;
    ;;{14}
    ;;{15}
    ;;{16}
)