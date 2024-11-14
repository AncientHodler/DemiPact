(module A GOVERNANCE
    @doc "Module A"

    (defcap GOVERNANCE ()
        (enforce-guard (keyset-ref-guard A|AOZ))
    )


    (defcap UPDATE_FROM_B ()
        true
    )
    (defun GuardFromB:guard ()
        (create-capability-guard (UPDATE_FROM_B))
    )

    (defschema A|TableSchema
        balance:decimal
        guard:guard
    )

    (defun A|UR_Balance:decimal (account:string)
        (at "balance" (read A|Table account ["balance"]))
    )
    (defun A|UR_Guard:guard (account:string)
        (at "guard" (read A|Table account ["guard"]))
    )
    (defun A|Spawn (account:string guard:guard)
        (enforce-guard guard)
        (insert A|Table account
            {"balance"  : 0.0
            ,"guard"    : guard
            }
        )
    )
    (defun A|UpdateBalance (account:string new-balance:decimal)
        (let
            (
                (account-guard:guard (A|UR_Guard account))
            )
            (enforce-guard (UTILITY.guard-any [account-guard B_GUARD]))
            ;(enforce-guard account-guard)
            (update A|Table account
                {"balance"  : new-balance}
            )
        )
    )


    (deftable A|Table:{A|TableSchema})

    (defconst A|AOZ "free.User000i-Keyset") 

    (defun FunctionA:decimal (input-one:decimal input-two:decimal)
        (require-capability (A|PRIMAL input-one input-two))
        (+ input-one input-two)
    )

    (defschema A|Schema
        p1:string
        p2:string
        p2:string
    )

    (defun A|FunctionA:decimal (input-one:decimal input-two:decimal)
        (with-capability (A|PRIMAL input-one input-two)
            (FunctionA input-one input-two)
        )
    )

    (defcap A|PRIMAL (input-one:decimal input-two:decimal)
        @event
        (enforce (>= input-one 10.0) "Invalid Condition")
        (enforce (>= input-two 5.0) "Invalid Condition")
    )
)
(create-table A|Table)