(module C GOVERNANCE
    @doc "Module C"

    (defcap GOVERNANCE ()
        (enforce-guard (keyset-ref-guard C|COCA))
    )

    (defconst C|COCA "free.User000e-Keyset") 

    (defun FunctionC:decimal (input-one:decimal input-two:decimal)
        (require-capability (C|PRIMAL input-one input-two))
        (- input-one input-two)
    )

    (defun C|FunctionC:decimal (input-one:decimal input-two:decimal)
        (with-capability (C|PRIMAL input-one input-two)
            (FunctionC input-one input-two)
        )
    )

    (defcap C|PRIMAL (input-one:decimal input-two:decimal)
        @event
        (enforce (>= input-one input-two) "Invalid Condition")
    )
)