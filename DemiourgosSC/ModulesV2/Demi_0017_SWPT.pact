(module SWPT GOV
    ;;
    ;;{G1}
    (defconst GOV|MD_SWPT   (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_SWPT   (keyset-ref-guard SWP.SWP|SC_KEY))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|SWPT_ADMIN))
    )
    (defcap GOV|SWPT_ADMIN ()
        (enforce-one
            "SWPT Swapper Admin not satisfed"
            [
                (enforce-guard GOV|MD_SWPT)
                (enforce-guard GOV|SC_SWPT)
            ]
        )
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|SWPT_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()              
        true
    )
    ;;
    ;;{1}
    (defschema SWPT|Edges
        principal:string
        swpairs:[string]
    )
    (defschema SWPT|S|Tracer
        links:[object{SWPT|Edges}]
    )
    ;;{2}
    (deftable SWPT|T|Tracer:{SWPT|S|Tracer})
    ;;{3}
    (defconst NLEO
        { "principal" : UTILS.BAR
        , "swpairs"   : [UTILS.BAR]}
    )
    (defconst NLE [NLEO])
    ;;
    ;;{4}
    (defcap SECURE ()
        true
    )
    ;;{5}
    ;;{6}
    ;;{7}
    ;;
    ;;{8}
    ;;{9}
    ;;{10}
    (defun SWPT|UEV_IdAsPrincipal (id:string for-trace:bool)
        (let
            (
                (iz-principal:bool (SWPT|URC_IzPrincipal id))
            )
            (if for-trace
                (enforce (or iz-principal (= id UTILS.BAR)) (format "ID {} is not a valid principal for trace operations" [id]))
                (enforce iz-principal (format "ID {} is not a principal" [id]))
            )
        )
    )
    ;;{11}
    (defun SWPT|UC_PoolTokens:[string] (swpair:string)
        (drop 1 (UTILS.LIST|UC_SplitString UTILS.BAR swpair))
    )
    (defun SWPT|UC_UniqueTokens:[string] (swpairs:[string])
        (distinct (fold (+) [] (SWPT|UC_PoolTokensFromPairs swpairs)))
    )
    (defun SWPT|UC_PoolTokensFromPairs:[[string]] (swpairs:[string])
        (fold
            (lambda
                (acc:[[string]] idx:integer)
                (UTILS.LIST|UC_AppendLast 
                    acc
                    (SWPT|UC_PoolTokens (at idx swpairs))
                )
            )
            []
            (enumerate 0 (- (length swpairs) 1))
        )
    )
    (defun SWPT|UC_IzOnPool:bool (id:string swpair:string)
        (contains id (SWPT|UC_PoolTokens swpair))
    )
    (defun SWPT|UC_IzOnPools:[bool] (id:string swpairs:[string])
        (fold
            (lambda
                (acc:[bool] idx:integer)
                (UTILS.LIST|UC_AppendLast 
                    acc
                    (SWPT|UC_IzOnPool id (at idx swpairs))
                )
            )
            []
            (enumerate 0 (- (length swpairs) 1))
        )
    )
    (defun SWPT|UC_AreOnPools:[bool] (id1:string id2:string swpairs:[string])
        (fold
            (lambda
                (acc:[bool] idx:integer)
                (UTILS.LIST|UC_AppendLast 
                    acc
                    (let*
                        (
                            (pool-tokens:[string] (SWPT|UC_PoolTokens (at idx swpairs)))
                            (iz-id1:bool (contains id1 pool-tokens))
                            (iz-id2:bool (contains id2 pool-tokens))
                        )
                        (and iz-id1 iz-id2)
                    )
                )
            )
            []
            (enumerate 0 (- (length swpairs) 1))
        )
    )
    (defun SWPT|UC_FilterOne:[string] (swpairs:[string] id:string)
        (let*
            (
                (l1:[bool] (SWPT|UC_IzOnPools id swpairs))
                (l2:[string] (zip (lambda (s:string b:bool) (if b s UTILS.BAR)) swpairs l1))
                (l3:[string] (UTILS.LIST|UC_RemoveItem l2 UTILS.BAR))
            )
            l3
        )
    )
    (defun SWPT|UC_FilterTwo:[string] (swpairs:[string] id1:string id2:string)
        (let*
            (
                (l1:[bool] (SWPT|UC_AreOnPools id1 id2 swpairs))
                (l2:[string] (zip (lambda (s:string b:bool) (if b s UTILS.BAR)) swpairs l1))
                (l3:[string] (UTILS.LIST|UC_RemoveItem l2 UTILS.BAR))
            )
            l3
        )
    )
    (defun SWPT|UC_PSwpairsFTO:[string] (traces:[object{SWPT|Edges}] id:string principal:string)
        @doc "Principal Swpairs From Trace Object: given a trace object, id and principal, output the stored swpairs\
        \ UTILS.BAR can be used as principal, returning swpairs that contain no principals. \
        \ Swpairs that contain no principals, can only be stable swap pairs."
        (SWPT|UEV_IdAsPrincipal principal true)
        (let*
            (
                (u2:[string] [UTILS.BAR])
                (principals-from-traces:[string] (SWPT|UC_PrincipalsFromTraces traces))
                (search:[integer] (UTILS.LIST|UC_Search principals-from-traces principal))
            )
            (if (!= (length search) 0)
                (at "swpairs" (at (at 0 search) traces))
                u2
            )
        )
    )
    (defun SWPT|UC_PrincipalsFromTraces:[string] (traces:[object{SWPT|Edges}])
        (fold
            (lambda
                (acc:[string] idx:integer)
                (UTILS.LIST|UC_AppendLast 
                    acc
                    (at "principal" (at idx traces))
                )
            )
            []
            (enumerate 0 (- (length traces) 1))
        )
    )
    ;;{12}
    (defun SWPT|UR_PathTrace:[object{SWPT|Edges}] (id:string)
        (at "links" (read SWPT|T|Tracer id ["links"]))
    )
    (defun SWPT|UR_PrincipalSwpairs:[string] (id:string principal:string)
        (SWPT|UC_PSwpairsFTO (SWPT|UR_PathTrace id) id principal)
    )
    ;;{13}
    (defun SWPT|URC_TokenNeighbours:[string] (token-id:string)
        (UTILS.LIST|UC_RemoveItem (SWPT|UC_UniqueTokens (SWPT|URC_TokenSwpairs token-id)) token-id)
    )
    (defun SWPT|URC_TokenSwpairs:[string] (token-id:string)
        @doc "Reads all swpairs attached to the <token-id> and outputs them into a string list"
        (let*
            (
                (cp:[string] (UTILS.LIST|UC_InsertFirst (SWP.SWP|UR_Principals) UTILS.BAR))
                (swpairs-array:[[string]]
                    (fold
                        (lambda
                            (acc:[[string]] idx:integer)
                            (let
                                (
                                    (swpairs:[string] (SWPT|UR_PrincipalSwpairs token-id (at idx cp)))
                                    (u2:[string] [UTILS.BAR])
                                )
                                (if (!= swpairs u2)
                                    (UTILS.LIST|UC_AppendLast 
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
    (defun SWPT|URC_Edges:[string] (t1:string t2:string)
        (let*
            (
                (swp1:[string] (SWPT|URC_TokenSwpairs t1))
                (swp2:[string] (SWPT|URC_TokenSwpairs t2))
                (swps:[string] (+ swp1 swp2))
                (d:[string] (distinct swps))
            )
            (SWPT|UC_FilterTwo d t1 t2)
        )
    )
    (defun GRPH|URC_ComputePath:[string] (input:string output:string)
        (let*
            (
                (all-paths:[[string]] (GRPH|URC_AllPaths input output))
                (fp:[[string]]
                    (fold
                        (lambda
                            (acc:[[string]] idx:integer)
                            (let*
                                (
                                    (e:[string] (at idx all-paths))
                                    (l:string (at 0 (take -1 e)))
                                    (check:bool (= l output))
                                )
                                (if (not check)
                                    (UTILS.LIST|UC_RemoveItem acc e)
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
    )
    (defun GRPH|URC_AllPaths:[[string]] (input:string output:string)
        (at "chains" (SUT.GRPH|UC_BFS (GRPH|URC_Make input output) input))
    )
    (defun GRPH|URC_Make:[object{SUT.GraphNode}] (input:string output:string)
        (let
            (
                (nodes:[string] (GRPH|URC_Nodes input output))
            )
            (fold
                (lambda
                    (acc:[object{SUT.GraphNode}] idx:integer)
                    (UTILS.LIST|UC_AppendLast 
                        acc
                        {
                            "node": (at idx nodes),
                            "links": (SWPT|URC_TokenNeighbours (at idx nodes))
                        }
                    )
                )
                []
                (enumerate 0 (- (length nodes) 1))
            )
        )
    )
    (defun GRPH|URC_Nodes:[string] (input-id:string output-id:string)
        @doc "Given an <input-id> and <output-id>, creates a list of ids: \
            \ Representing the nodes of the graph. \
            \ Uses 2 Steps: \
            \ \
            \ Step1 = Filter All Existing <swpairs>, to those containing <input-id> and <output-id> = select-swpairs\
            \ Step2 = Extract all Tokens from relevant pairs => these are the nodes = nodes \
            \ \
            \ Uses p2-p7 s2-s7 Swpair Information Data"
        (let*
            (
                (swpairs:[string] (SWP.SWP|URC_Swpairs))
                (in:[string] (SWPT|UC_FilterOne swpairs input-id))
                (out:[string] (SWPT|UC_FilterOne swpairs output-id))
                (l0:[string] (+ in out))
                (select-swpairs:[string] (distinct l0))

                (non-distinct-nodes-array:[[string]] (SWPT|UC_PoolTokensFromPairs select-swpairs))
                (non-distinct-nodes:[string] (fold (+) [] non-distinct-nodes-array))
            )
            (distinct non-distinct-nodes)
        )
    )
    (defun SWPT|URC_PathTracer:[object{SWPT|Edges}] (old-path-tracer:[object{SWPT|Edges}] id:string swpair:string)
        "Computes a new Path-tracer object list, given <old-path-tracer> object, token-id <id> and Swap-Pair <swpair>"
        (let*
            (
                (u1:string UTILS.BAR)
                (u2:[string] [UTILS.BAR])
                (swpair-tokens:[string] (SWPT|UC_PoolTokens swpair))
                (has-principals:bool (SWPT|URC_ContainsPrincipals swpair))
                (current-element-zero-swpairs:[string] (SWPT|UC_PSwpairsFTO old-path-tracer id u1))
                (new-element-zero-swpairs:[string]
                    (if (= current-element-zero-swpairs u2)
                        (if has-principals
                            u2
                            [swpair]
                        )
                        (if has-principals
                            current-element-zero-swpairs
                            (UTILS.LIST|UC_AppendLast current-element-zero-swpairs swpair)
                        )
                    )
                )
                (element-zero:object{SWPT|Edges}
                    { "principal" : u1 , "swpairs" : new-element-zero-swpairs}
                )
                (principals:[string] (SWP.SWP|UR_Principals))
            )
            (fold
                (lambda
                    (acc:[object{SWPT|Edges}] idx:integer)
                    (UTILS.LIST|UC_AppendLast 
                        acc
                        (let*
                            (
                                (current-element-swpairs:[string] (SWPT|UC_PSwpairsFTO old-path-tracer id (at idx principals)))
                                (lopt:integer (length old-path-tracer))
                                (iz-principal-on-swpair:bool (contains (at idx principals) swpair-tokens))
                                (check:bool (and (!= id (at idx principals)) iz-principal-on-swpair))
                                (swpairs-to-add:[string]
                                    (if (= lopt 1)
                                        (if check
                                            [swpair]
                                            u2
                                        )
                                        (if check
                                            (UTILS.LIST|UC_AppendLast current-element-swpairs swpair)
                                            current-element-swpairs
                                        )
                                    )
                                )
                                (filtered-swpairs-to-add:[string]
                                    (if (= swpairs-to-add u2)
                                        swpairs-to-add
                                        (if (= (at 0 swpairs-to-add) u1)
                                            (drop 1 swpairs-to-add)
                                            swpairs-to-add
                                        )
                                    )
                                )
                            )
                            {
                                "principal" : (at idx principals),
                                "swpairs"   : filtered-swpairs-to-add
                            }
                        )
                    )
                )
                [element-zero]
                (enumerate 0 (- (length principals) 1))
            )
        )
    )
    (defun SWPT|URC_ContainsPrincipals:bool (swpair:string)
        (let
            (
                (swpair-tokens:[string] (SWPT|UC_PoolTokens swpair))
                (principals:[string] (SWP.SWP|UR_Principals))
            )
            (fold
                (lambda
                    (acc:bool idx:integer)
                    (or
                        acc
                        (contains (at idx swpair-tokens) principals)
                    )
                )
                false
                (enumerate 0 (- (length swpair-tokens) 1))
            )
        )
    )
    (defun SWPT|URC_IzPrincipal:bool (id:string)
        (if (contains id (SWP.SWP|UR_Principals))
            true
            false
        )
    )
    ;;
    ;;{14}
    ;;{15}
    ;;{16}
    (defun SWPT|X_MultiPathTracer (swpair:string)
        (enforce-guard (P|UR "SWPI|Caller"))
        (with-capability (SECURE)
            (map
                (lambda
                    (token:string)
                    (SWPT|X_SinglePathTracer token swpair)
                )
                (SWPT|UC_PoolTokens swpair)
            )
        )
    )
    (defun SWPT|X_SinglePathTracer (id:string swpair:string)
        (require-capability (SECURE))
        (with-default-read SWPT|T|Tracer id
            { "links" : NLE }
            { "links" := lks }
            (write SWPT|T|Tracer id
                { "links" : (SWPT|URC_PathTracer lks id swpair)}
            )
        )
    )
)

(create-table P|T)
(create-table SWPT|T|Tracer)