(module U|BFS GOV
    ;;
    (implements BreadthFirstSearchV1)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|U|BFS_ADMIN)))
    (defcap GOV|U|BFS_ADMIN ()
        (let
            (
                (ref-U|CT:module{OuronetConstantsV1} U|CT)
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
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstantsV1} U|CT)) (ref-U|CT::CT_BAR)))
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
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    ;;{C2}
    ;;{C3}
    ;;{C4}
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_BFS:object{BreadthFirstSearchV1.BFS} (graph:[object{BreadthFirstSearchV1.GraphNode}] in:string)
        @doc "Implementation of the Breadth First Search Method, outputing a BFS Object, \
        \ which ultimately contains all chains, starting from a specific <in> node"
        (fold
            (lambda
                (acc:object{BreadthFirstSearchV1.BFS} idx:integer)
                (if (= idx 0)
                    (let
                        (
                            (links:[string] (UCX_GraphNodeLinks graph in))
                        )
                        (if (!= links [BAR])
                            (let
                                (
                                    (primal-que:[object{BreadthFirstSearchV1.QE}] (UCX_PrimalQE links in))
                                    (chains-to-add:[[string]] (UCX_GetChains primal-que))
                                    (acc1-visited:object{BreadthFirstSearchV1.BFS} (UDCX_AddVisited acc (+ [in] links)))
                                    (acc2-que:object{BreadthFirstSearchV1.BFS} (UDCX_AddToQue acc1-visited primal-que))
                                    (acc3-chains:object{BreadthFirstSearchV1.BFS} (UDCX_AddChains acc2-que chains-to-add))
                                )
                                acc3-chains
                            )
                            EBFS
                        )
                    )
                    (if (!= acc EBFS)
                        (let
                            (
                                (first-qe:object{BreadthFirstSearchV1.QE} (at 0 (at "que" acc)))
                                (first-qe-node:string (at "node" first-qe))
                            )
                            (if (!= first-qe-node BAR)
                                (let
                                    (
                                        (ref-U|LST:module{StringProcessorV1} U|LST)
                                        (first-qe-node-links:[string] (UCX_GraphNodeLinks graph first-qe-node))
                                        (visited:[string] (at "visited" acc))
                                        (not-visited:[string] (UCX_FilterVisited visited first-qe-node-links))
                                        (lnv:integer (length not-visited))
                                        (acc0-rm:object{BreadthFirstSearchV1.BFS} (UDCX_RmFromQue acc))
                                        (new-que:[object{BreadthFirstSearchV1.QE}]
                                            (if (= lnv 0)
                                                EQE
                                                (fold
                                                    (lambda
                                                        (acc:[object{BreadthFirstSearchV1.QE}] idx2:integer)
                                                        (ref-U|LST::UC_AppL
                                                            acc
                                                            (UDCX_ExtendChain first-qe (at idx2 not-visited))
                                                        )
                                                    )
                                                    []
                                                    (enumerate 0 (- (length not-visited) 1))
                                                )
                                            )
                                        )
                                        (chains-to-add:[[string]] (UCX_GetChains new-que))
                                        (acc1-visited:object{BreadthFirstSearchV1.BFS} (UDCX_AddVisited acc0-rm not-visited))
                                        (acc2-que:object{BreadthFirstSearchV1.BFS}
                                            (if (!= chains-to-add [[BAR]])
                                                (UDCX_AddToQue acc1-visited new-que)
                                                acc1-visited
                                            )
                                        )
                                        (acc3-chains:object{BreadthFirstSearchV1.BFS}
                                            (if (!= chains-to-add [[BAR]])
                                                (UDCX_AddChains acc2-que chains-to-add)
                                                acc2-que
                                            )
                                        )
                                    )
                                    acc3-chains
                                )
                                acc
                            )
                        )
                        EBFS
                    )
                )
            )
            EBFS
            (enumerate 0 (- (length graph) 1))
        )
    )
    (defun UCX_GraphNodeLinks:[string] (graph:[object{BreadthFirstSearchV1.GraphNode}] node:string)
        @doc "Scans a Graph for a Node, outputing its links"
        (let
            (
                (ref-U|LST:module{StringProcessorV1} U|LST)
                (nodes:[string] (UCX_GraphNodes graph))
                (sl:[integer] (ref-U|LST::UC_Search nodes node))
                (search-result-size:integer (length sl))
            )
            (if (= search-result-size 0)
                [BAR]
                (let
                    (
                        (pos:integer (at 0 sl))
                        (graph-node:object{BreadthFirstSearchV1.GraphNode} (at pos graph))
                    )
                    (at "links" graph-node)
                )
            )
        )
    )
    (defun UCX_GraphNodes:[string] (graph:[object{BreadthFirstSearchV1.GraphNode}])
        @doc "Outputs a string list representing the nodes of a graph"
        (let
            (
                (ref-U|LST:module{StringProcessorV1} U|LST)
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
    (defun UCX_PrimalQE:[object{BreadthFirstSearchV1.QE}] (links:[string] node:string)
        @doc "Computes the Primal Que Elements in a BFS Object, which is the first Que Element that is created"
        (let
            (
                (ref-U|LST:module{StringProcessorV1} U|LST)
            )
            (fold
                (lambda
                    (acc:[object{BreadthFirstSearchV1.QE}] idx:integer)
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
    (defun UCX_GetChains:[[string]] (input:[object{BreadthFirstSearchV1.QE}])
        @doc "Extracts a list of chains from a list of Que Objects"
        (let
            (
                (ref-U|LST:module{StringProcessorV1} U|LST)
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
    (defun UCX_FilterVisited:[string] (visited:[string] new-nodes:[string])
        @doc "Filters a list of new-nodes by a list of visited nodes"
        (let
            (
                (ref-U|LST:module{StringProcessorV1} U|LST)
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
    (defun UCX_ExStrLst:[string] (to-extend:[string] elements:[string])
        (if (= [BAR] to-extend)
            elements
            (+ to-extend elements)
        )
    )
    (defun UCX_ExQeLst:[object{BreadthFirstSearchV1.QE}] (input:[object{BreadthFirstSearchV1.QE}] que-element:[object{BreadthFirstSearchV1.QE}])
        (if (and (= (at 0 EQE) (at 0 input)) (= (length input) 1))
            que-element
            (+ input que-element)
        )
    )
    (defun UCX_RmFirstQeList:[object{BreadthFirstSearchV1.QE}] (input:[object{BreadthFirstSearchV1.QE}])
        (if (> (length input) 1)
            (drop 1 input)
            EQE
        )
    )
    (defun UCX_ExStrArrLst:[[string]] (to-extend:[[string]] elements:[[string]])
        (if (= [[BAR]] to-extend)
            elements
            (+ to-extend elements)
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    (defun UDCX_ExtendChain:object{BreadthFirstSearchV1.QE} (input:object{BreadthFirstSearchV1.QE} element:string)
        @doc "Extends a Que Element with a new element"
        (let
            (
                (ref-U|LST:module{StringProcessorV1} U|LST)
            )
            {
                "node": element,
                "chain": (ref-U|LST::UC_AppL (at "chain" input) element)
            }
        )
    )
    (defun UDCX_AddVisited:object{BreadthFirstSearchV1.BFS} (input:object{BreadthFirstSearchV1.BFS} visited:[string])
        {
            "visited":  (UCX_ExStrLst (at "visited" input) visited),
            "que":      (at "que" input),
            "chains":   (at "chains" input)
        }
    )
    (defun UDCX_AddToQue:object{BreadthFirstSearchV1.BFS} (input:object{BreadthFirstSearchV1.BFS} que:[object{BreadthFirstSearchV1.QE}])
        {
            "visited":  (at "visited" input),
            "que":      (UCX_ExQeLst (at "que" input) que),
            "chains":   (at "chains" input)
        }
    )
    (defun UDCX_RmFromQue:object{BreadthFirstSearchV1.BFS} (input:object{BreadthFirstSearchV1.BFS})
        {
            "visited":  (at "visited" input),
            "que":      (UCX_RmFirstQeList (at "que" input)),
            "chains":   (at "chains" input)
        }
    )
    (defun UDCX_AddChains:object{BreadthFirstSearchV1.BFS} (input:object{BreadthFirstSearchV1.BFS} chains-to-add:[[string]])
        {
            "visited":  (at "visited" input),
            "que":      (at "que" input),
            "chains":   (UCX_ExStrArrLst (at "chains" input) chains-to-add)
        }
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)