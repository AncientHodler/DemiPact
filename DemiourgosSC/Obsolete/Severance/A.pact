(module A GOVERNANCE
    @doc "Module A"

    (defcap GOVERNANCE ()
        (enforce-guard (keyset-ref-guard A|AOZ))
    )

    (defschema A|TableSchema
        balance:decimal
        guard:guard
    )

    (defschema A|GuardStorageSchema
        guard:guard
    )

    (deftable A|Table:{A|TableSchema})
    (deftable A|AllowedModules:{A|GuardStorageSchema})

    (defun A|UR_Balance:decimal (account:string)
        (at "balance" (read A|Table account ["balance"]))
    )
    (defun A|UR_Guard:guard (account:string)
        (at "guard" (read A|Table account ["guard"]))
    )
    (defun A|UR_AllowedGuard:guard (allowed-mdl:string)
        (at "guard" (read A|AllowedModules allowed-mdl ["guard"]))
    )
    (defun A|AllowModules (mdl:string guard-to-save:guard)
        (with-capability (GOVERNANCE)
            (write A|AllowedModules mdl
                {"guard" : guard-to-save}
            )
        )
    )

    (defun A|UpdateBalanceAllowedGuards (account:string)
        (let
            (
                (account-guard:guard (A|UR_Guard account))
                (bobo-guard:guard (A|UR_AllowedGuard "Module_BOBO"))
            )
            [account-guard bobo-guard]
        )
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
        (enforce-one
            "Update Balance Capability not granted"
            [
                (enforce-guard (UTILITY.GUARD|Any (A|UpdateBalanceAllowedGuards account)))
                (enforce-guard (A|UR_Guard account))
            ]
        )
        (update A|Table account
            {"balance"  : new-balance}
        )
    )


    

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
(create-table A|AllowedModules)