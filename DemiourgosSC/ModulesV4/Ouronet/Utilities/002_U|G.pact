(module U|G GOV
    ;;
    (implements OuronetGuards)
    ;;{G1}
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|U|G_ADMIN))
    )
    (defcap GOV|U|G_ADMIN ()
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (g:guard (ref-U|CT::CT_GOV|UTILS))
            )
            (enforce-guard g)
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
    (defun UEV_GuardOfAll:guard (guards:[guard])
        @doc "Create a guard that only succeeds if every guard in GUARDS is successfully enforced."
        (enforce (< 0 (length guards)) "Guard list cannot be empty")
        (create-user-guard (UEV_All guards))
    )
    (defun UEV_All:bool (guards:[guard])
        @doc "Enforces all guards in GUARDS"
        (map (enforce-guard) guards)
        true
    )
    (defun UEV_GuardOfAny:guard (guards:[guard])
        @doc "Create a guard that succeeds if at least one guard in GUARDS is successfully enforced."
        (enforce (< 0 (length guards)) "Guard list cannot be empty")
        (create-user-guard (UEV_Any guards))
    )
    (defun UEV_Any:bool (guards:[guard])
        @doc "Will succeed if at least one guard in GUARDS is successfully enforced."
        (enforce 
            (< 0 (length (filter (= true) (map (UC_Try) guards))))
            "None of the guards passed"
        )
    )
    (defun UC_Try (g:guard)
        @doc "Helper function used in <UEV_Any>"
        (try false (enforce-guard g))
    )
)