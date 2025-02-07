(module U|BFS GOV
    ;;
    (implements BreadthFirstSearch)
    ;;{G1}
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|U|BFS_ADMIN))
    )
    (defcap GOV|U|BFS_ADMIN ()
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
    (defun CT_Bar ()
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
            )
            (ref-U|CT::CT_BAR)
        )
    )
    (defconst BAR (CT_Bar))
    (defconst EQE
        [
            {
                "node":     BAR,
                "chain":    [BAR]
            }
        ]
    )
    (defconst EBFS
        {
            "visited":  [BAR],
            "que":      EQE,
            "chains":   [[BAR]]
        }
    )
    ;;
    ;;{F-UC}
    (defun UC_BFS:object{BreadthFirstSearch.BFS} (graph:[object{BreadthFirstSearch.GraphNode}] in:string)
        @doc "Implementation of the Breadth First Search Method, outputing a BFS Object, \
        \ which ultimately contains all chains, starting from a specific <in> node"
        (fold
            (lambda
                (acc:object{BreadthFirstSearch.BFS} idx:integer)
                (if (= idx 0)
                    (let
                        (
                            (links:[string] (UC_GraphNodeLinks graph in))
                            (primal-que:[object{BreadthFirstSearch.QE}] (UC_PrimalQE links in))
                            (chains-to-add:[[string]] (UC_GetChains primal-que))
                            (acc1-visited:object{BreadthFirstSearch.BFS} (UDC_AddVisited acc (+ [in] links)))
                            (acc2-que:object{BreadthFirstSearch.BFS} (UDC_AddToQue acc1-visited primal-que))
                            (acc3-chains:object{BreadthFirstSearch.BFS} (UDC_AddChains acc2-que chains-to-add))
                        )
                        acc3-chains
                    )
                    (let
                        (
                            (first-qe:object{BreadthFirstSearch.QE} (at 0 (at "que" acc)))
                            (first-qe-node:string (at "node" first-qe))  
                        )
                        (if (!= first-qe-node BAR)
                            (let
                                (
                                    (ref-U|LST:module{StringProcessor} U|LST)
                                    (first-qe-node-links:[string] (UC_GraphNodeLinks graph first-qe-node))
                                    (visited:[string] (at "visited" acc))
                                    (not-visited:[string] (UC_FilterVisited visited first-qe-node-links))
                                    (lnv:integer (length not-visited))
                                    (acc0-rm:object{BreadthFirstSearch.BFS} (UDC_RmFromQue acc))
                                    (new-que:[object{BreadthFirstSearch.QE}]
                                        (if (= lnv 0)
                                            EQE
                                            (fold
                                                (lambda
                                                    (acc:[object{BreadthFirstSearch.QE}] idx2:integer)
                                                    (ref-U|LST::UC_AppL 
                                                        acc
                                                        (UDC_ExtendChain first-qe (at idx2 not-visited))
                                                    )
                                                )
                                                []
                                                (enumerate 0 (- (length not-visited) 1))
                                            )
                                        )
                                    )
                                    (chains-to-add:[[string]] (UC_GetChains new-que))
                                    (acc1-visited:object{BreadthFirstSearch.BFS} (UDC_AddVisited acc0-rm not-visited))
                                    (acc2-que:object{BreadthFirstSearch.BFS} 
                                        (if (!= chains-to-add [[BAR]])
                                            (UDC_AddToQue acc1-visited new-que)
                                            acc1-visited
                                        )
                                    )
                                    (acc3-chains:object{BreadthFirstSearch.BFS} 
                                        (if (!= chains-to-add [[BAR]])
                                            (UDC_AddChains acc2-que chains-to-add)
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
    (defun UC_GraphNodeLinks:[string] (graph:[object{BreadthFirstSearch.GraphNode}] node:string)
        @doc "Scans a Graph for a Node, outputing its links"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (nodes:[string] (UC_GraphNodes graph))
                (sl:[integer] (ref-U|LST::UC_Search nodes node))
                (pos:integer (at 0 sl))
                (graph-node:object{BreadthFirstSearch.GraphNode} (at pos graph))
            )
            (at "links" graph-node)
        )
    )
    (defun UC_GraphNodes:[string] (graph:[object{BreadthFirstSearch.GraphNode}])
        @doc "Outputs a string list representing the nodes of a graph"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[string] idx:integer)
                    (ref-U|LST::UC_AppL 
                        acc
                        (at "node" (at idx graph))
                    )
                )
                []
                (enumerate 0 (- (length graph) 1))
            )
        )
    )
    (defun UC_PrimalQE:[object{BreadthFirstSearch.QE}] (links:[string] node:string)
        @doc "Computes the Primal Que Elements in a BFS Object, which is the first Que Element that is created"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[object{BreadthFirstSearch.QE}] idx:integer)
                    (ref-U|LST::UC_AppL 
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
    (defun UC_GetChains:[[string]] (input:[object{BreadthFirstSearch.QE}])
        @doc "Extracts a list of chains from a list of Que Objects"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[[string]] idx:integer)
                    (ref-U|LST::UC_AppL 
                        acc
                        (at "chain" (at idx input))
                    )
                )
                []
                (enumerate 0 (- (length input) 1))
            )
        )
    )
    (defun UC_FilterVisited:[string] (visited:[string] new-nodes:[string])
        @doc "Filters a list of new-nodes by a list of visited nodes"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[string] idx:integer)
                    (let
                        (
                            (elem:string (at idx new-nodes))
                            (iz-visited:bool (contains elem visited))
                        )
                        (if iz-visited
                            (ref-U|LST::UC_RemoveItem acc elem)
                            acc
                        )
                    )
                )
                new-nodes
                (enumerate 0 (- (length new-nodes) 1))
            )
        )
    )
    (defun UC_ExStrLst:[string] (to-extend:[string] elements:[string])
        (if (= [BAR] to-extend)
            elements
            (+ to-extend elements)
        )
    )
    (defun UC_ExQeLst:[object{BreadthFirstSearch.QE}] (input:[object{BreadthFirstSearch.QE}] que-element:[object{BreadthFirstSearch.QE}])
        (if (and (= (at 0 EQE) (at 0 input)) (= (length input) 1))
            que-element
            (+ input que-element)
        )
    )
    (defun UC_RmFirstQeList:[object{BreadthFirstSearch.QE}] (input:[object{BreadthFirstSearch.QE}])
        (if (> (length input) 1)
            (drop 1 input)
            EQE
        )
    )
    (defun UC_ExStrArrLst:[[string]] (to-extend:[[string]] elements:[[string]])
        (if (= [[BAR]] to-extend)
            elements
            (+ to-extend elements)
        )
    )
    ;;{F_UR}
    ;;{F-UEV}
    ;;{F-UDC}
    (defun UDC_ExtendChain:object{BreadthFirstSearch.QE} (input:object{BreadthFirstSearch.QE} element:string)
        @doc "Extends a Que Element with a new element"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            {
                "node": element,
                "chain": (ref-U|LST::UC_AppL (at "chain" input) element)
            }
        )
    )
    (defun UDC_AddVisited:object{BreadthFirstSearch.BFS} (input:object{BreadthFirstSearch.BFS} visited:[string])
        {
            "visited":  (UC_ExStrLst (at "visited" input) visited),
            "que":      (at "que" input),
            "chains":   (at "chains" input)
        }
    )
    (defun UDC_AddToQue:object{BreadthFirstSearch.BFS} (input:object{BreadthFirstSearch.BFS} que:[object{BreadthFirstSearch.QE}])
        {
            "visited":  (at "visited" input),
            "que":      (UC_ExQeLst (at "que" input) que),
            "chains":   (at "chains" input)
        }
    )
    (defun UDC_RmFromQue:object{BreadthFirstSearch.BFS} (input:object{BreadthFirstSearch.BFS})
        {
            "visited":  (at "visited" input),
            "que":      (UC_RmFirstQeList (at "que" input)),
            "chains":   (at "chains" input)
        }
    )
    (defun UDC_AddChains:object{BreadthFirstSearch.BFS} (input:object{BreadthFirstSearch.BFS} chains-to-add:[[string]])
        {
            "visited":  (at "visited" input),
            "que":      (at "que" input),
            "chains":   (UC_ExStrArrLst (at "chains" input) chains-to-add)  
        }
    )
)