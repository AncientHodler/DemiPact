;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface SwapTracer
    @doc "Exposes Tracer Functions, needed to compute Paths between Tokens existing on Liquidity Pools"
    ;;
    (defschema Edges
        principal:string
        swpairs:[string]
    )
    ;;
    (defun UC_PSwpairsFTO:[string] (traces:[object{Edges}] id:string principal:string principals-lst:[string]))
    (defun UC_PrincipalsFromTraces:[string] (traces:[object{Edges}]))
    ;;
    (defun UR_PathTrace:[object{Edges}] (id:string))
    ;;
    (defun URC_PathTracer:[object{Edges}] (old-path-tracer:[object{Edges}] id:string swpair:string principals-lst:[string]))
    (defun URC_ContainsPrincipals:bool (swpair:string principals-lst:[string]))
    (defun URC_ComputeGraphPath:[string] (input:string output:string swpairs:[string] principal-lst:[string]))
    (defun URC_AllGraphPaths:[[string]] (input:string output:string swpairs:[string] principal-lst:[string]))
    (defun URC_MakeGraph:[object{BreadthFirstSearch.GraphNode}] (input:string output:string swpairs:[string] principal-lst:[string]))
    (defun URC_TokenNeighbours:[string] (token-id:string principal-lst:[string]))
    (defun URC_TokenSwpairs:[string] (token-id:string principal-lst:[string]))
    (defun URC_PrincipalSwpairs:[string] (id:string principal:string principal-lst:[string]))
    (defun URC_Edges:[string] (t1:string t2:string principal-lst:[string])) ;;1
    ;;
    (defun UEV_IMC ())
    (defun UEV_IdAsPrincipal (id:string for-trace:bool principals-lst:[string]))
    ;;
    (defun X_MultiPathTracer (swpair:string principals-lst:[string]))
)

(module SWPT GOV
    ;;
    (implements OuronetPolicy)
    (implements SwapTracer)
    ;;{G1}
    (defconst GOV|MD_SWPT           (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|SWPT_ADMIN)))
    (defcap GOV|SWPT_ADMIN ()       (enforce-guard GOV|MD_SWPT))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|SWPT|CALLER ()
        true
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|SWPT_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|SWPT_ADMIN)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (dg:guard (create-capability-guard (SECURE)))
                )
                (with-default-read P|MT P|I
                    {"m-policies" : [dg]}
                    {"m-policies" := mp}
                    (write P|MT P|I
                        {"m-policies" : (ref-U|LST::UC_AppL mp policy-guard)}
                    )
                )
            )
        )
    )
    (defun P|A_Define ()              
        (let
            (
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|ATSU:module{OuronetPolicy} ATSU)
                (ref-P|VST:module{OuronetPolicy} VST)
                (ref-P|LIQUID:module{OuronetPolicy} LIQUID)
                (ref-P|ORBR:module{OuronetPolicy} OUROBOROS)
                (mg:guard (create-capability-guard (P|SWPT|CALLER)))
            )
            (ref-P|DALOS::P|A_Add "SWPT|<" mg)
            (ref-P|BRD::P|A_Add "SWPT|<" mg)
            (ref-P|DPTF::P|A_Add "SWPT|<" mg)
            (ref-P|DPMF::P|A_Add "SWPT|<" mg)
            (ref-P|ATS::P|A_Add "SWPT|<" mg)
            (ref-P|TFT::P|A_Add "SWPT|<" mg)
            (ref-P|ATSU::P|A_Add "SWPT|<" mg)
            (ref-P|VST::P|A_Add "SWPT|<" mg)
            (ref-P|LIQUID::P|A_Add "SWPT|<" mg)
            (ref-P|ORBR::P|A_Add "SWPT|<" mg)

            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|DPMF::P|A_AddIMP mg)
            (ref-P|ATS::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|ATSU::P|A_AddIMP mg)
            (ref-P|VST::P|A_AddIMP mg)
            (ref-P|LIQUID::P|A_AddIMP mg)
            (ref-P|ORBR::P|A_AddIMP mg)
        )
    )
    ;;
    ;;{1}
    (defschema SWPT|TracerSchema
        links:[object{SwapTracer.Edges}]
    )
    ;;{2}
    (deftable SWPT|Tracer:{SWPT|TracerSchema})
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    (defconst NLE [NLEO])
    (defconst NLEO
        { "principal" : BAR
        , "swpairs"   : [BAR]}
    )
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    ;;
    ;;{FC}
    (defun UC_PSwpairsFTO:[string] (traces:[object{SwapTracer.Edges}] id:string principal:string principals-lst:[string])
        @doc "Principal Swpairs From Trace Object: given a trace object, id and principal, output the stored swpairs\
        \ UTILS.BAR can be used as principal, returning swpairs that contain no principals. \
        \ Swpairs that contain no principals, can only be stable swap pairs."
        (UEV_IdAsPrincipal principal true principals-lst)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (principals-from-traces:[string] (UC_PrincipalsFromTraces traces))
                (search:[integer] (ref-U|LST::UC_Search principals-from-traces principal))
            )
            (if (!= (length search) 0)
                (at "swpairs" (at (at 0 search) traces))
                [BAR]
            )
        )
    )
    (defun UC_PrincipalsFromTraces:[string] (traces:[object{SwapTracer.Edges}])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[string] idx:integer)
                    (ref-U|LST::UC_AppL
                        acc
                        (at "principal" (at idx traces))
                    )
                )
                []
                (enumerate 0 (- (length traces) 1))
            )
        )
    )
    ;;{F0}
    (defun UR_PathTrace:[object{SwapTracer.Edges}] (id:string)
        (at "links" (read SWPT|Tracer id ["links"]))
    )
    ;;{F1}
    (defun URC_PathTracer:[object{SwapTracer.Edges}] (old-path-tracer:[object{SwapTracer.Edges}] id:string swpair:string principals-lst:[string])
        "Computes a new Path-tracer object list, given <old-path-tracer> object, token-id <id> and Swap-Pair <swpair>"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (swpair-tokens:[string] (ref-U|SWP::UC_TokensFromSwpairString swpair))
                (has-principals:bool (URC_ContainsPrincipals swpair principals-lst))
                (current-element-zero-swpairs:[string] (UC_PSwpairsFTO old-path-tracer id BAR principals-lst))
                (new-element-zero-swpairs:[string]
                    (if (= current-element-zero-swpairs [BAR])
                        (if has-principals
                            [BAR]
                            [swpair]
                        )
                        (if has-principals
                            current-element-zero-swpairs
                            (ref-U|LST::UC_AppL current-element-zero-swpairs swpair)
                        )
                    )
                )
                (element-zero:object{SwapTracer.Edges}
                    { "principal" : BAR , "swpairs" : new-element-zero-swpairs}
                )
            )
            (fold
                (lambda
                    (acc:[object{SwapTracer.Edges}] idx:integer)
                    (ref-U|LST::UC_AppL 
                        acc
                        (let
                            (
                                (current-element-swpairs:[string] (UC_PSwpairsFTO old-path-tracer id (at idx principals-lst) principals-lst))
                                (lopt:integer (length old-path-tracer))
                                (iz-principal-on-swpair:bool (contains (at idx principals-lst) swpair-tokens))
                                (check:bool (and (!= id (at idx principals-lst)) iz-principal-on-swpair))
                                (swpairs-to-add:[string]
                                    (if (= lopt 1)
                                        (if check
                                            [swpair]
                                            [BAR]
                                        )
                                        (if check
                                            (ref-U|LST::UC_AppL current-element-swpairs swpair)
                                            current-element-swpairs
                                        )
                                    )
                                )
                                (filtered-swpairs-to-add:[string]
                                    (if (= swpairs-to-add [BAR])
                                        swpairs-to-add
                                        (if (= (at 0 swpairs-to-add) BAR)
                                            (drop 1 swpairs-to-add)
                                            swpairs-to-add
                                        )
                                    )
                                )
                            )
                            {
                                "principal" : (at idx principals-lst),
                                "swpairs"   : filtered-swpairs-to-add
                            }
                        )
                    )
                )
                [element-zero]
                (enumerate 0 (- (length principals-lst) 1))
            )
        )
    )
    (defun URC_ContainsPrincipals:bool (swpair:string principals-lst:[string])
        (let
            (
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (swpair-tokens:[string] (ref-U|SWP::UC_TokensFromSwpairString swpair))
            )
            (fold
                (lambda
                    (acc:bool idx:integer)
                    (or
                        acc
                        (contains (at idx swpair-tokens) principals-lst)
                    )
                )
                false
                (enumerate 0 (- (length swpair-tokens) 1))
            )
        )
    )
    (defun URC_ComputeGraphPath:[string] (input:string output:string swpairs:[string] principal-lst:[string])
        @doc "Computes the path between an <input> and <output> using BFS via <URC_AllGraphPaths> \
        \ from a passed down list of existing <swpairs>"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (all-paths:[[string]] (URC_AllGraphPaths input output swpairs principal-lst))
                
            )
            (if (!= all-paths [[BAR]])
                (let
                    (
                        (fp:[[string]]
                            (fold
                                (lambda
                                    (acc:[[string]] idx:integer)
                                    (let
                                        (
                                            (e:[string] (at idx all-paths))
                                            (l:string (at 0 (take -1 e)))
                                            (check:bool (= l output))
                                        )
                                        (if (not check)
                                            (ref-U|LST::UC_RemoveItem acc e)
                                            acc
                                        )
                                    )
                                )
                                all-paths
                                (enumerate 0 (- (length all-paths) 1))
                            )
                        )
                    )
                    (at 0 fp)
                )
                [BAR]
            )
        )
    )
    (defun URC_AllGraphPaths:[[string]] (input:string output:string swpairs:[string] principal-lst:[string])
        @doc "Computes all paths that exist in a Graph defined from <input> ids, <output> ids \
        \ over a specific passed-down list of existing <swpairs>"
        (let
            (
                (ref-U|BFS:module{BreadthFirstSearch} U|BFS)
                (graph:[object{BreadthFirstSearch.GraphNode}] (URC_MakeGraph input output swpairs principal-lst))
                (bfs-obj:object{BreadthFirstSearch.BFS} (ref-U|BFS::UC_BFS graph input))
            )
            (at "chains" bfs-obj)
        )
    )
    (defun URC_MakeGraph:[object{BreadthFirstSearch.GraphNode}] (input:string output:string swpairs:[string] principal-lst:[string])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (nodes:[string] (ref-U|SWP::UC_MakeGraphNodes input output swpairs))
            )
            (fold
                (lambda
                    (acc:[object{BreadthFirstSearch.GraphNode}] idx:integer)
                    (ref-U|LST::UC_AppL
                        acc
                        {
                            "node": (at idx nodes),
                            "links": (URC_TokenNeighbours (at idx nodes) principal-lst)
                        }
                    )
                )
                []
                (enumerate 0 (- (length nodes) 1))
            )
        )
    )
    (defun URC_TokenNeighbours:[string] (token-id:string principal-lst:[string])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (token-swpairs:[string] (URC_TokenSwpairs token-id principal-lst))
                (unique-tokens:[string] (ref-U|SWP::UC_UniqueTokens token-swpairs))
            )
            (ref-U|LST::UC_RemoveItem unique-tokens token-id)
        )
    )
    (defun URC_TokenSwpairs:[string] (token-id:string principal-lst:[string])
        @doc "Reads all swpairs attached to the <token-id> and outputs them into a string list \
        \ Requires a list of principals through <principal-lst>"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (cp:[string] (ref-U|LST::UC_InsertFirst principal-lst BAR))
                (swpairs-array:[[string]]
                    (fold
                        (lambda
                            (acc:[[string]] idx:integer)
                            (let
                                (
                                    (swpairs:[string] (URC_PrincipalSwpairs token-id (at idx cp) principal-lst))
                                    (u2:[string] [BAR])
                                )
                                (if (!= swpairs u2)
                                    (ref-U|LST::UC_AppL
                                        acc
                                        swpairs
                                    )
                                    acc
                                )
                            )
                        )
                        []
                        (enumerate 0 (- (length cp) 1))
                    )
                )
            )
            (fold (+) [] swpairs-array)
        )
    )
    (defun URC_PrincipalSwpairs:[string] (id:string principal:string principal-lst:[string])
        (UC_PSwpairsFTO (UR_PathTrace id) id principal principal-lst)
    )
    (defun URC_Edges:[string] (t1:string t2:string principal-lst:[string])
        (let
            (
                (ref-U|SWP:module{UtilitySwp} U|SWP)
                (swp1:[string] (URC_TokenSwpairs t1 principal-lst))
                (swp2:[string] (URC_TokenSwpairs t2 principal-lst))
                (swps:[string] (+ swp1 swp2))
                (d:[string] (distinct swps))
            )
            (ref-U|SWP::UC_FilterTwo d t1 t2)
        )
    )
    ;;{F2}
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
            )
            (ref-U|G::UEV_Any (P|UR_IMP))
        )
    )
    (defun UEV_IdAsPrincipal (id:string for-trace:bool principals-lst:[string])
        (let
            (
                (iz-principal:bool (contains id principals-lst))
            )
            (if for-trace
                (enforce (or iz-principal (= id BAR)) (format "ID {} is not a valid principal for trace operations" [id]))
                (enforce iz-principal (format "ID {} is not a principal" [id]))
            )
        )
    )
    ;;{F3}
    ;;{F4}
    ;;
    ;;{F5}
    ;;{F6}
    ;;{F7}
    (defun X_MultiPathTracer (swpair:string principals-lst:[string])
        (UEV_IMC)
        (with-capability (SECURE)
            (let
                (
                    (ref-U|SWP:module{UtilitySwp} U|SWP)
                )
                (map
                    (lambda
                        (token:string)
                        (X_SinglePathTracer token swpair principals-lst)
                    )
                    (ref-U|SWP::UC_TokensFromSwpairString swpair)
                )
            )
        )
    )
    (defun X_SinglePathTracer (id:string swpair:string principals-lst:[string])
        (require-capability (SECURE))
        (with-default-read SWPT|Tracer id
            { "links" : NLE }
            { "links" := lks }
            (write SWPT|Tracer id
                { "links" : (URC_PathTracer lks id swpair principals-lst)}
            )
        )
    )
)

(create-table P|T)
(create-table P|MT)
(create-table SWPT|Tracer)