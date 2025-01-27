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
    ;;{P4}
    ;;
    ;;{1}
    (defschema GraphNode
        node:string
        links:[string]
    )
    (defschema BFS
        visited:[string]
        que:[object{QE}]
        chains:[[string]]
    )
    (defschema QE
        node:string
        chain:[string]
    )
    ;;{2}
    ;;{3}
    (defconst EQE
        [
            {
                "node":     UTILS.BAR,
                "chain":    [UTILS.BAR]
            }
        ]
    )
    (defconst EBFS
        {
            "visited":  [UTILS.BAR],
            "que":      EQE,
            "chains":   [[UTILS.BAR]]
        }
    )
    ;;
    ;;{4}
    ;;{5}
    ;;{6}
    ;;{7}
    ;;
    ;;{8}
    ;;{9}
    (defun GRPH|UDC_AddVisited:object{BFS} (input:object{BFS} visited:[string])
        {
            "visited":  (SUT|UC_ExStrLst (at "visited" input) visited),
            "que":      (at "que" input),
            "chains":   (at "chains" input)
        }
    )
    (defun GRPH|UDC_AddToQue:object{BFS} (input:object{BFS} que:[object{QE}])
        {
            "visited":  (at "visited" input),
            "que":      (SUT|UC_ExQeLst (at "que" input) que),
            "chains":   (at "chains" input)
        }
    )
    (defun GRPH|UDC_RmFromQue:object{BFS} (input:object{BFS})
        {
            "visited":  (at "visited" input),
            "que":      (SUT|UC_RmFirstQeList (at "que" input)),
            "chains":   (at "chains" input)
        }
    )
    (defun GRPH|UDC_AddChains:object{BFS} (input:object{BFS} chains-to-add:[[string]])
        {
            "visited":  (at "visited" input),
            "que":      (at "que" input),
            "chains":   (SUT|UC_ExStrArrLst (at "chains" input) chains-to-add)  
        }
    )
    ;;{10}
    ;;{11}
    (defun SWP|UC_ComputeWP (X:[decimal] input-amounts:[decimal] ip:[integer] op:integer o-prec w:[decimal])
        (let*
            (
                (raised:[decimal] (zip (lambda (x:decimal y:decimal) (^ x y)) X w))
                (pool-product:decimal (floor (fold (*) 1.0 raised) 24))
                (new-supplies:[decimal] (SWP|UC_NewSupply X input-amounts ip))
                (new-supplies-rem:[decimal] (UTILS.LIST|UC_RemoveItemAt new-supplies op))
                (rw:[decimal] (UTILS.LIST|UC_RemoveItemAt w op))
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
    (defun SWP|UC_NewSupply (X:[decimal] input-amounts:[decimal] ip:[integer])
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
    (defun SWP|UC_ComputeY (A:decimal X:[decimal] input-amount:decimal ip:integer op:integer o-prec:integer)
        (let*
            (
                (xi:decimal (at ip X))
                (xn:decimal (+ xi input-amount))
                (XX:[decimal] (UTILS.LIST|UC_ReplaceAt X ip xn))
                (NewD:decimal (SWP|UC_ComputeD A XX))
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
            (- (floor (UTILS.LIST|UC_LastListElement output-lst) o-prec) (at op X))
        )
    )
    (defun SWP|UC_ComputeD:decimal (A:decimal X:[decimal])
        (let*
            (
                (output-lst:[decimal]
                    (fold
                        (lambda
                            (d-values:[decimal] idx:integer)
                            (let*
                                (
                                    (prev-d:decimal (at idx d-values))
                                    (d-value:decimal (SWP|UC_DNext prev-d A X))
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
    (defun SWP|UC_DNext (D:decimal A:decimal X:[decimal])
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
    (defun SWP|UC_Prefix:string (weights:[decimal] amp:decimal)
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
    (defun SWP|UC_LpID:[string] (token-names:[string] token-tickers:[string] weights:[decimal] amp:decimal)
        (let*
            (
                (prefix:string (SWP|UC_Prefix weights amp))
                (l1:integer (length token-names))
                (l2:integer (length token-tickers))
                (lengths:[integer] [l1 l2])
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
    (defun SWP|UC_PoolID:string (token-ids:[string] weights:[decimal] amp:decimal)
        (let*
            (
                (prefix:string (SWP|UC_Prefix weights amp))
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
    (defun GRPH|UC_BFS:object{BFS} (graph:[object{GraphNode}] in:string)
        (fold
            (lambda
                (acc:object{BFS} idx:integer)
                (if (= idx 0)
                    (let*
                        (
                            (links:[string] (GRPH|UC_GraphNodeLinks graph in))
                            (primal-que:[object{QE}] (GRPH|UC_PrimalQE graph in))
                            (chains-to-add:[[string]] (GRPH|UC_GetChains primal-que))
                            (acc1-visited:object{BFS} (GRPH|UDC_AddVisited acc (+ [in] links)))
                            (acc2-que:object{BFS} (GRPH|UDC_AddToQue acc1-visited primal-que))
                            (acc3-chains:object{BFS} (GRPH|UDC_AddChains acc2-que chains-to-add))
                        )
                        acc3-chains
                    )
                    (let*
                        (
                            (first-qe:object{QE} (at 0 (at "que" acc)))
                            (first-qe-node:string (at "node" first-qe))  
                        )
                        (if (!= first-qe-node UTILS.BAR)
                            (let*
                                (
                                    (first-qe-node-links:[string] (GRPH|UC_GraphNodeLinks graph first-qe-node))
                                    (visited:[string] (at "visited" acc))
                                    (not-visited:[string] (GRPH|UC_FilterVisited visited first-qe-node-links))
                                    (lnv:integer (length not-visited))
                                    (acc0-rm:object{BFS} (GRPH|UDC_RmFromQue acc))
                                    (new-que:[object{QE}]
                                        (if (= lnv 0)
                                            EQE
                                            (fold
                                                (lambda
                                                    (acc:[object{QE}] idx2:integer)
                                                    (UTILS.LIST|UC_AppendLast 
                                                        acc
                                                        (GRPH|UC_ExtendChain first-qe (at idx2 not-visited))
                                                    )
                                                )
                                                []
                                                (enumerate 0 (- (length not-visited) 1))
                                            )
                                        )
                                    )
                                    (chains-to-add:[[string]] (GRPH|UC_GetChains new-que))
                                    (acc1-visited:object{BFS} (GRPH|UDC_AddVisited acc0-rm not-visited))
                                    (acc2-que:object{BFS} 
                                        (if (!= chains-to-add [[UTILS.BAR]])
                                            (GRPH|UDC_AddToQue acc1-visited new-que)
                                            acc1-visited
                                        )
                                    )
                                    (acc3-chains:object{BFS} 
                                        (if (!= chains-to-add [[UTILS.BAR]])
                                            (GRPH|UDC_AddChains acc2-que chains-to-add)
                                            acc2-que
                                        )
                                    )
                                )
                                acc3-chains
                            )
                            acc
                        )
                    )
                )
            )
            EBFS
            (enumerate 0 (- (length graph) 1))
        )
    )
    (defun GRPH|UC_GraphNodeLinks:[string] (graph:[object{GraphNode}] node:string)
        (at "links" (at (at 0 (UTILS.LIST|UC_Search (GRPH|UC_GraphNodes graph) node)) graph))
    )
    (defun GRPH|UC_GraphNodes:[string] (graph:[object{GraphNode}])
        (fold
            (lambda
                (acc:[string] idx:integer)
                (UTILS.LIST|UC_AppendLast 
                    acc
                    (at "node" (at idx graph))
                )
            )
            []
            (enumerate 0 (- (length graph) 1))
        )
    )
    (defun GRPH|UC_PrimalQE:[object{QE}] (graph:[object{GraphNode}] node:string)
        (let*
            (
                (links:[string] (GRPH|UC_GraphNodeLinks graph node))
            )
            (fold
                (lambda
                    (acc:[object{QE}] idx:integer)
                    (UTILS.LIST|UC_AppendLast 
                        acc
                        {
                            "node":     (at idx links),
                            "chain":    [node, (at idx links)]
                        }
                    )
                )
                []
                (enumerate 0 (- (length links) 1))
            )
        )
    )
    (defun GRPH|UC_GetChains:[[string]] (input:[object{QE}])
        (fold
            (lambda
                (acc:[[string]] idx:integer)
                (UTILS.LIST|UC_AppendLast 
                    acc
                    (at "chain" (at idx input))
                )
            )
            []
            (enumerate 0 (- (length input) 1))
        )
    )
    (defun GRPH|UC_FilterVisited (visited:[string] new-nodes:[string])
        (fold
            (lambda
                (acc:[string] idx:integer)
                (let*
                    (
                        (elem:string (at idx new-nodes))
                        (iz-visited:bool (contains elem visited))
                    )
                    (if iz-visited
                        (UTILS.LIST|UC_RemoveItem acc elem)
                        acc
                    )
                )
            )
            new-nodes
            (enumerate 0 (- (length new-nodes) 1))
        )
    )
    (defun GRPH|UC_ExtendChain:object{QE} (input:object{QE} element:string)
        {
            "node": element,
            "chain": (UTILS.LIST|UC_AppendLast (at "chain" input) element)
        }
    )
    (defun SUT|UC_ExStrLst:[string] (to-extend:[string] elements:[string])
        (if (= [UTILS.BAR] to-extend)
            elements
            (+ to-extend elements)
        )
    )
    (defun SUT|UC_ExQeLst:[object{QE}] (input:[object{QE}] que-element:[object{QE}])
        (if (and (= (at 0 EQE) (at 0 input)) (= (length input) 1))
            que-element
            (+ input que-element)
        )
    )
    (defun SUT|UC_RmFirstQeList:[object{QE}] (input:[object{QE}])
        (if (> (length input) 1)
            (drop 1 input)
            EQE
        )
        
    )
    (defun SUT|UC_ExStrArrLst:[[string]] (to-extend:[[string]] elements:[[string]])
        (if (= [[UTILS.BAR]] to-extend)
            elements
            (+ to-extend elements)
        )
    )
    (defun SUT|UC_LP:decimal (input-amounts:[decimal] pts:[decimal] lps:decimal lpp:integer)
        (let*
            (
                (nz:[decimal] (UTILS.LIST|UC_RemoveItem input-amounts 0.0))
                (fnz:decimal (at 0 nz))
                (fnzp:integer (at 0 (UTILS.LIST|UC_Search input-amounts fnz)))
            )
            (floor (* (/ (at fnzp input-amounts) (at fnzp pts)) lps) lpp)
        )
    )
    ;;{12}
    ;;{13}
    ;;
    ;;{14}
    ;;{15}
    ;;{16}
    ;;
)