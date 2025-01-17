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
            (SUT.SWP|UC_ComputeP X input-amounts ip op o-prec)
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
                (SUT.SWP|UC_ComputeY A X input-amount ip op)
            )
        ) 
    )
    ;;
    ;;
    ;;
)