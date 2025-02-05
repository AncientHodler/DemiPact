;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module SWPST GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_SWPST          (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_SWPST          (keyset-ref-guard SWP.SWP|SC_KEY))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|SWPSC_ADMIN))
    )
    (defcap GOV|SWPSC_ADMIN ()
        (enforce-one
            "SWPSC Swapper Admin not satisfed"
            [
                (enforce-guard GOV|MD_SWPST)
                (enforce-guard GOV|SC_SWPST)
            ]
        )
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    ;;{P3}
    ;;{P4}
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
    ;;{12}
    ;;{13}
    ;;
    ;;{14}
    ;;{15}
    ;;{16}
    ;;
    (defconst EMPTY_NEOV
        [
            {
                "nodes" : [],
                "edges" : [],
                "output-values" : []
            }
        ]
    )
    (defschema NEOV
        nodes:[string]
        edges:[string]
        output-values:[decimal]
    )
    (defun SWPST|URC_Neov:object{NEOV} (id:string ia:decimal vid:string)
        (let*
            (
                (nodes:[string] (SWPT.GRPH|URC_ComputePath id vid))
                (fl:[object{NEOV}]
                    (fold
                        (lambda
                            (acc:[object{NEOV}] idx:integer)
                            (UTILS.LIST|UC_ReplaceAt
                                acc
                                0
                                (let*
                                    (
                                        (input:decimal
                                            (if (= idx 0)
                                                ia
                                                (at 0 (take -1 (at "output-values" (at 0 acc))))
                                            )
                                        )
                                        (i-id:string (at idx nodes))
                                        (o-id:string (at (+ idx 1) nodes))
                                        (best-edge:string (SWPST|URC_BestEdge input i-id o-id))
                                        (output:decimal (SWPSC.SWPSC|URC_Swap best-edge [i-id] [input] o-id))
                                    )
                                    {
                                        "nodes"         : nodes,
                                        "edges"         : (UTILS.LIST|UC_AppendLast (at "edges" (at 0 acc)) best-edge),
                                        "output-values" : (UTILS.LIST|UC_AppendLast (at "output-values" (at 0 acc)) output)
                                    }
                                )
                            )
                        )
                        EMPTY_NEOV
                        (enumerate 0 (- (length nodes) 2))
                    )
                )
            )
            (at 0 fl)
        )
    )
    (defun SWPST|URC_BestEdge:string (ia:decimal i:string o:string)
        (let*
            (
                (edges:[string] (SWPT.SWPT|URC_Edges i o))
                (svl:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (UTILS.LIST|UC_AppendLast 
                                acc
                                (SWPSC.SWPSC|URC_Swap (at idx edges) [i] [ia] o)
                            )
                        )
                        []
                        (enumerate 0 (- (length edges) 1))
                    )
                )
                (sp:integer
                    (fold
                        (lambda
                            (acc:integer idx:integer)
                            (if (= idx 0)
                                acc
                                (if (< (at idx svl) (at acc svl))
                                    idx
                                    acc
                                )
                            )
                        )
                        0
                        (enumerate 0 (- (length svl) 1))
                    )
                )
            )
            (at sp edges)
        )
    )
)