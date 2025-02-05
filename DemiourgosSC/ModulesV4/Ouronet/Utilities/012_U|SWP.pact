(module U|SWP GOV
    ;;
    (implements UtilitySwp)
    ;;{G1}
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|U|SWP_ADMIN))
    )
    (defcap GOV|U|SWP_ADMIN ()
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
    (defun UC_ComputeWP (X:[decimal] input-amounts:[decimal] ip:[integer] op:integer o-prec w:[decimal])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (raised:[decimal] (zip (lambda (x:decimal y:decimal) (floor (^ x y) 24)) X w))
                (pool-product:decimal (floor (fold (*) 1.0 raised) 24))
                (new-supplies:[decimal] (UC_NewSupply X input-amounts ip))
                (new-supplies-rem:[decimal] (ref-U|LST::UC_RemoveItemAt new-supplies op))
                (rw:[decimal] (ref-U|LST::UC_RemoveItemAt w op))
                (nsr:[decimal] (zip (lambda (x:decimal y:decimal) (^ x y)) new-supplies-rem rw))
                (nsrm:decimal (floor (fold (*) 1.0 nsr) 24))
                (ow:decimal (at op w))
                (iow:decimal (floor (/ 1.0 ow) 24))
                (rest:decimal (floor (/ pool-product nsrm) 24))
                (output:decimal (floor (^ rest iow) o-prec))
            )
            (- (at op X) output)
        )
    )
    (defun UC_NewSupply:[decimal] (X:[decimal] input-amounts:[decimal] ip:[integer])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[decimal] idx:integer)
                    (ref-U|LST::UC_AppL 
                        acc 
                        (+ 
                            (if (contains idx ip)
                                (at (at 0 (ref-U|LST::UC_Search ip idx)) input-amounts)
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
    )
    (defun UC_ComputeY (A:decimal X:[decimal] input-amount:decimal ip:integer op:integer o-prec:integer)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (xi:decimal (at ip X))
                (xn:decimal (+ xi input-amount))
                (XX:[decimal] (ref-U|LST::UC_ReplaceAt X ip xn))
                (NewD:decimal (UC_ComputeD A XX))
                (y0:decimal (+ (at op X) input-amount))
                (output-lst:[decimal]
                    (fold
                        (lambda
                            (y-values:[decimal] idx:integer)
                            (let
                                (
                                    (prev-y:decimal (at idx y-values))
                                    (y-value:decimal (UC_YNext prev-y NewD A X op))
                                )
                                (ref-U|LST::UC_AppL y-values y-value)
                            )
                        )
                        [y0]
                        (enumerate 0 10)
                    )
                )
            )
            (- (floor (ref-U|LST::UC_LE output-lst) o-prec) (at op X))
        )
    )
    (defun UC_ComputeD:decimal (A:decimal X:[decimal])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (output-lst:[decimal]
                    (fold
                        (lambda
                            (d-values:[decimal] idx:integer)
                            (let
                                (
                                    (prev-d:decimal (at idx d-values))
                                    (d-value:decimal (UC_DNext prev-d A X))
                                )
                                (ref-U|LST::UC_AppL d-values d-value)
                            )
                        )
                        [(fold (+) 0.0 X)]
                        (enumerate 0 5)
                    )
                )
            )
            (ref-U|LST::UC_LE output-lst)
        )
    )
    (defun UC_DNext (D:decimal A:decimal X:[decimal])
        @doc "Computes Dnext: \
        \ n = (length X) \
        \ S=x1+x2+x3+... \
        \ P=x1*x2*x3*... \
        \ Dp = (D^(n+1))/(P*n^n) \
        \ Numerator = (A*n^n*S + Dp*n)*D \
        \ Denominator = (A*n^n-1)*D + (n+1)*Dp \
        \ DNext = Numerator / Denominator"
        (let
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
    (defun UC_YNext (Y:decimal D:decimal A:decimal X:[decimal] op:integer)
        @doc "Computes Y such that the invariant remains satisfied \
        \ Sp = x1+x2+x3+ ... without the term to be computed, containing the modified input token amount \
        \ Pp = x1*x2*x3* ... without the term to be computed, containing the modified input token amount \
        \ c = (D^(n+1))/(n^n*Pp*A*n^n) \
        \ b = Sp + (D/A*n^n) \
        \ Numerator = y^2 + c \
        \ Denominator = 2*y + b - D \
        \ YNext = Numerator / Denominator "
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (prec:integer 24)
                (n:decimal (dec (length X)))
                (XX:[decimal] (ref-U|LST::UC_ReplaceAt X op -1.0))
                (XXX:[decimal] (ref-U|LST::UC_RemoveItem XX -1.0))
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
    (defun UC_Prefix:string (weights:[decimal] amp:decimal)
        (let
            (
                (ws:decimal (fold (+) 0.0 weights))
            )
            (if (= amp -1.0)
                (if (= ws 1.0)
                    "W"
                    "P"
                )
                "S"
            )
        )
    )
    (defun UC_LpID:[string] (token-names:[string] token-tickers:[string] weights:[decimal] amp:decimal)
        @doc "Creates a LP Id from input sources"
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-U|LST:module{StringProcessor} U|LST)
                (bar:string (ref-U|CT::CT_BAR))
                (prefix:string (UC_Prefix weights amp))
                (l1:integer (length token-names))
                (l2:integer (length token-tickers))
                (lengths:[integer] [l1 l2])
                (minus:string "-")
                (caron:string "^")
            )
            (ref-U|INT::UEV_UniformList lengths)
            (let
                (
                    (lp-name-elements:[string]
                        (fold
                            (lambda
                                (acc:[string] idx:integer)
                                (if (!= idx (- l1 1))
                                    (ref-U|LST::UC_AppL acc (+ (at idx token-names) caron))
                                    (ref-U|LST::UC_AppL acc (at idx token-names))
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
                                    (ref-U|LST::UC_AppL acc (+ (at idx token-tickers) minus))
                                    (ref-U|LST::UC_AppL acc (at idx token-tickers))
                                )
                            )
                            []
                            (enumerate 0 (- l1 1))
                        )
                    )
                    (lp-name:string (concat [prefix bar (concat lp-name-elements)]))
                    (lp-ticker:string (concat [prefix bar (concat lp-ticker-elements) bar "LP"]))
                )
                [lp-name lp-ticker]
            )
        )
    )
    (defun UC_PoolID:string (token-ids:[string] weights:[decimal] amp:decimal)
        @doc "Creates a Swap Pool Id from input sources"
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|LST:module{StringProcessor} U|LST)
                (bar:string (ref-U|CT::CT_BAR))
                (prefix:string (UC_Prefix weights amp))
                (swpair-elements:[string]
                    (fold
                        (lambda
                            (acc:[string] idx:integer)
                            (if (!= idx (- (length token-ids) 1))
                                (ref-U|LST::UC_AppL acc (+ (at idx token-ids) bar))
                                (ref-U|LST::UC_AppL acc (at idx token-ids))
                            )
                        )
                        []
                        (enumerate 0 (- (length token-ids) 1))
                    )
                )
            )
            (concat [prefix bar (concat swpair-elements)])
        )
    )
    (defun UC_BalancedLiquidity:[decimal] (ia:decimal ip:integer i-prec X:[decimal] Xp:[integer])
        @doc "Computes Balanced Liquidity Amounts from input sources"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ratio:decimal (floor (/ ia (at ip X)) i-prec))
                (output:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (ref-U|LST::UC_AppL 
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
    (defun UC_LP:decimal (input-amounts:[decimal] pts:[decimal] lps:decimal lpp:integer)
        @doc "Computes the amount of LP that would result from <input-amounts> of tokens added to the pool, when \
            \ the pools has <pts> token supply, adn the lp amounts is <lps> and the lp token has <lpp> precision"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (nz:[decimal] (ref-U|LST::UC_RemoveItem input-amounts 0.0))
                (fnz:decimal (at 0 nz))
                (fnzp:integer (at 0 (ref-U|LST::UC_Search input-amounts fnz)))
            )
            (floor (* (/ (at fnzp input-amounts) (at fnzp pts)) lps) lpp)
        )
    )
    (defun UC_TokensFromSwpairString:[string] (swpair:string)
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|LST:module{StringProcessor} U|LST)
                (bar:string (ref-U|CT::CT_BAR))
            )
            (drop 1 (ref-U|LST::UC_SplitString bar swpair))
        )
    )
    ;;{F_UR}
    ;;{F-UEV}
    ;;{F-UDC}
)