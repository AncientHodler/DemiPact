(module SWPSC GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (SWPSC-ADMIN))
    )
    (defcap SWPSC-ADMIN ()
        (enforce-one
            "SWPSC Swapper Admin not satisfed"
            [
                (enforce-guard G-MD_SWPSC)
                (enforce-guard G-SC_SWPSC)
            ]
        )
    )

    (defconst G-MD_SWPSC    (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_SWPSC    (keyset-ref-guard SWP.SWP|SC_KEY))
    ;;
    (defschema Node
        link:string
        swpairs:[string]
    )
    (defschema Graph
        nodes:[object{Node}]
    )
    ;;
    (defun SWPSC|UC_IzPrincipal:bool (id:string)
        (if (contains id (SWP.SWP|UR_Principals))
            true
            false
        )
    )
    (defun SWPSC|UC_IzOnPools:[bool] (id:string swpairs:[string])
        (fold
            (lambda
                (acc:[bool] idx:integer)
                (UTILS.LIST|UC_AppendLast 
                    acc
                    (SWPSC|UC_IzOnPool id (at idx swpairs))
                )
            )
            []
            (enumerate 0 (- (length swpairs) 1))
        )
    )
    (defun SWPSC|UC_IzOnPool:bool (id:string swpair:string)
        (if (contains id (UTILS.LIST|UC_SplitString UTILS.BAR swpair))
            true
            false
        )
    )
    ;;object{Graph}
    (defun SWPSC|UC_SmartSwapGraph (input-id:string output-id:string)
        (SWPSC|UC_SmartSwapGraphCustom (SWPSC|UR_Swpairs) input-id output-id)
    )
    (defun SWPSC|UC_SmartSwapGraphCustom (swpairs:[string] input-id:string output-id:string)
        
        ;;Step2 = Extract all Tokens from relevant pairs => these are the nodes
        ;;Step3 = Define the nodes (tokens) and edges
        (let*
            (
                (in1:[bool] (SWPSC|UC_IzOnPools input-id swpairs))
                (in2:[string] (zip (lambda (s:string b:bool) (if b s UTILS.BAR)) swpairs in1))
                (in3:[string] (UTILS.LIST|UC_RemoveItem in2 UTILS.BAR))
                (out1:[bool] (SWPSC|UC_IzOnPools output-id swpairs))
                (out2:[string] (zip (lambda (s:string b:bool) (if b s UTILS.BAR)) swpairs out1))
                (out3:[string] (UTILS.LIST|UC_RemoveItem out2 UTILS.BAR))
                (l0:[string] (+ in3 out3))
                (l1:[string] (distinct l0))

                (non-distinct-nodes-array:[[string]]
                    (fold
                        (lambda
                            (acc:[[string]] idx:integer)
                            (UTILS.LIST|UC_AppendLast 
                                acc
                                (drop 1 (UTILS.LIST|UC_SplitString UTILS.BAR (at idx l1)))
                            )
                        )
                        []
                        (enumerate 0 (- (length l1) 1))
                    )
                )
                (non-distinct-nodes:[string] (fold (+) [] non-distinct-nodes-array))
                (nodes:[string] (distinct non-distinct-nodes))
            )
        ;;Step1 = Filter <swpairs> containing <input-id> or <output-id> = l1
        ;;Step2 = Extract all Tokens from relevant pairs => these are the nodes = nodes
            nodes
        )
    )
    
    (defun SWPSC|UR_Swpairs:[string] ()
        (let
            (
                (p2:[string] (SWP.SWP|UR_Pools SWP.P2))
                (p3:[string] (SWP.SWP|UR_Pools SWP.P3))
                (p4:[string] (SWP.SWP|UR_Pools SWP.P4))
                (p5:[string] (SWP.SWP|UR_Pools SWP.P5))
                (p6:[string] (SWP.SWP|UR_Pools SWP.P6))
                (p7:[string] (SWP.SWP|UR_Pools SWP.P7))

                (s2:[string] (SWP.SWP|UR_Pools SWP.S2))
                (s3:[string] (SWP.SWP|UR_Pools SWP.S3))
                (s4:[string] (SWP.SWP|UR_Pools SWP.S4))
                (s5:[string] (SWP.SWP|UR_Pools SWP.S5))
                (s6:[string] (SWP.SWP|UR_Pools SWP.S6))
                (s7:[string] (SWP.SWP|UR_Pools SWP.S7))
            )
            (fold (+) [] (UTILS.LIST|UC_RemoveItem [p2 p3 p4 p5 p6 p7 s2 s3 s4 s5 s6 s7] [UTILS.BAR]))
        )
    )
    ;;
    (defun SWPSC|UC_Swap:decimal (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (let
            (
                (A:decimal (SWP.SWP|UR_Amplifier swpair))
            )
            (if (= A -1.0)
                (SWPSC|UC_ProductSwap swpair input-ids input-amounts output-id)
                (SWPSC|UC_StableSwap swpair input-ids input-amounts output-id)
            )
        )
    )
    (defun SWPSC|UC_ProductSwap:decimal (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (let*
            (
                
                (X:[decimal] (SWP.SWP|UR_PoolTokenSupplies swpair))
                (op:integer (SWP.SWP|UR_PoolTokenPosition swpair output-id))
                (o-prec:integer (BASIS.DPTF-DPMF|UR_Decimals output-id true))
                (pool-tokens:[string] (SWP.SWP|UR_PoolTokens swpair))
                (l1:integer (length input-ids))
                (l2:integer (length input-amounts))
                (l3:integer (length pool-tokens))
                (lengths:[integer] [l1 l2])
                (iz-on-pool:bool (SWP.SWP|UEV_CheckAgainst input-ids pool-tokens))
                (t1:bool (contains output-id input-ids))
                (t2:bool (contains output-id pool-tokens))
                (ip:[integer]
                    (fold
                        (lambda
                            (acc:[integer] idx:integer)
                            (UTILS.LIST|UC_AppendLast 
                                acc 
                                (SWP.SWP|UR_PoolTokenPosition swpair (at idx input-ids))
                            )
                        )
                        []
                        (enumerate 0 (- l1 1))
                    )
                )
            )
            (UTILS.UTILS|UEV_EnforceUniformIntegerList lengths)
            (enforce iz-on-pool "Input Tokens are not part of the pool")
            (enforce t2 "OutputID is not part of Swpair Tokens")
            (enforce (not t1) "Output-ID cannot be within the Input-IDs")
            (enforce (and (>= l2 1) (< l2 l3)) "Incorrect amount of swap Tokens")
            (map
                (lambda
                    (idx:integer)
                    (BASIS.DPTF-DPMF|UEV_Amount (at idx input-ids) (at idx input-amounts) true)
                )
                (enumerate 0 (- l1 1))
            )
            (UTILS.SWP|UCC_ComputeP X input-amounts ip op o-prec)
        )
    )
    (defun SWPSC|UC_StableSwap:decimal (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (let*
            (
                (A:decimal (SWP.SWP|UR_Amplifier swpair))
                (X:[decimal] (SWP.SWP|UR_PoolTokenSupplies swpair))
                (pool-tokens:[string] (SWP.SWP|UR_PoolTokens swpair))
                (l1:integer (length input-ids))
                (l2:integer (length input-amounts))
                (lengths:[integer] [l1 l2])
                (iz-on-pool:bool (SWP.SWP|UEV_CheckAgainst input-ids pool-tokens))
                (t1:bool (contains output-id input-ids))
                (t2:bool (contains output-id pool-tokens))
            )
            (UTILS.UTILS|UEV_EnforceUniformIntegerList lengths)
            (enforce iz-on-pool "Input Tokens are not part of the pool")
            (enforce t2 "OutputID is not part of Swpair Tokens")
            (enforce (not t1) "Output-ID cannot be within the Input-IDs")
            (enforce (= l1 1) "Only a single Input can be used in Stable Swap")
            (let*
                (
                    (input-amount:decimal (at 0 input-amounts))
                    (input-id:string (at 0 input-ids))
                    (ip:integer (SWP.SWP|UR_PoolTokenPosition swpair input-id))
                    (op:integer (SWP.SWP|UR_PoolTokenPosition swpair output-id))
                )
                (UTILS.SWP|UCC_ComputeY A X input-amount ip op)
            )
        ) 
    )
)