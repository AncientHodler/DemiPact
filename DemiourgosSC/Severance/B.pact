(module BOBO GOVERNANCE
    @doc "Module B"

    (defcap GOVERNANCE ()
        (enforce-guard (keyset-ref-guard B|BYTA))
    )

    (defconst B|BYTA "free.User000c-Keyset")
    (deftable B|Table:{A.A|Schema})

    (defun FunctionB:decimal (input-one:decimal input-two:decimal)
        (require-capability (B|PRIMAL input-one input-two))
        (* input-one input-two)
    )

    (defun B|FunctionB:decimal (input-one:decimal input-two:decimal)
        (with-capability (B|PRIMAL input-one input-two)
            (FunctionB input-one input-two)
        )
    )

    (defun B|UpdateTableA (account:string balance:decimal)
        (A.A|UpdateBalance account balance)
    )

    (defun B|SpecialUpdateTableA (account:string balance:decimal)
        (A.A|UpdateBalance account balance)
    )

    (defcap B|PRIMAL (input-one:decimal input-two:decimal)
        @event
        (enforce (>= input-one 0.0) "Invalid Condition")
        (enforce (>= input-two 1.0) "Invalid Condition")
    )
)

(create-table B|Table)