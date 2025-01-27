;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module SWPSC GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_SWPSC          (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_SWPSC          (keyset-ref-guard SWP.SWP|SC_KEY))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|SWPSC_ADMIN))
    )
    (defcap GOV|SWPSC_ADMIN ()
        (enforce-one
            "SWPSC Swapper Admin not satisfed"
            [
                (enforce-guard GOV|MD_SWPSC)
                (enforce-guard GOV|SC_SWPSC)
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
    (defun SWPSC|URC_Swap:decimal (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (let
            (
                (A:decimal (SWP.SWP|UR_Amplifier swpair))
            )
            (if (= A -1.0)
                (SWPSC|URC_ProductSwap swpair input-ids input-amounts output-id)
                (SWPSC|URC_StableSwap swpair input-ids input-amounts output-id)
            )
        )
    )
    (defun SWPSC|URC_ProductSwap:decimal (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (let*
            (
                
                (X:[decimal] (SWP.SWP|UR_PoolTokenSupplies swpair))
                (op:integer (SWP.SWP|UR_PoolTokenPosition swpair output-id))
                (o-prec:integer (DPTF.DPTF|UR_Decimals output-id))
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
                (w:[decimal] (SWP.SWP|UR_Weigths swpair))
            )
            (UTILS.UTILS|UEV_EnforceUniformIntegerList lengths)
            (enforce iz-on-pool "Input Tokens are not part of the pool")
            (enforce t2 "OutputID is not part of Swpair Tokens")
            (enforce (not t1) "Output-ID cannot be within the Input-IDs")
            (enforce (and (>= l2 1) (< l2 l3)) "Incorrect amount of swap Tokens")
            (map
                (lambda
                    (idx:integer)
                    (DPTF.DPTF|UEV_Amount (at idx input-ids) (at idx input-amounts))
                )
                (enumerate 0 (- l1 1))
            )
            (SUT.SWP|UC_ComputeWP X input-amounts ip op o-prec w)
        )
    )
    (defun SWPSC|URC_StableSwap:decimal (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
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
                    (o-prec:integer (DPTF.DPTF|UR_Decimals output-id))
                )
                (SUT.SWP|UC_ComputeY A X input-amount ip op o-prec)
            )
        ) 
    )
    ;;
    ;;{14}
    ;;{15}
    ;;{16}
)