(module X GOVERNANCE
    @doc "Module X"

    (defcap GOVERNANCE ()
        (enforce-guard (keyset-ref-guard X|KISS))
    )

    (defconst X|KISS "free.User000f-Keyset") 

    (defun FunctionX:decimal 
        (
            input-one:decimal 
            input-two:decimal
            input-three:decimal 
            input-four:decimal
            input-five:decimal 
            input-six:decimal
        )
        
        (install-capability (A.A|PRIMAL input-one input-two))
        (install-capability (BOBO.B|PRIMAL input-three input-four))
        (install-capability (C.C|PRIMAL input-five input-six))

        (let*
            (
                (a:decimal (A.A|FunctionA input-one input-two))
                (b:decimal (BOBO.B|FunctionB input-three input-four))
                (c:decimal (C.C|FunctionC input-five input-six))
                (a-with-b:decimal (+ a b))
            )
            (+ a-with-b c)
        )
        
    )
)