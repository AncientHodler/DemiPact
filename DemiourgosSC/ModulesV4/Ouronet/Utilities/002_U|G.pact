(interface OuronetGuards
    @doc "Exported Functions from this Module via interface"
    ;;
    (defun UC_Try (g:guard))
    ;;
    (defun G01 ())
    (defun G02 ())
    (defun G03 ())
    (defun G04 ())
    (defun G05 ())
    (defun G06 ())
    (defun G07 ())
    (defun G08 ())
    (defun G09 ())
    (defun G10 ())
    (defun G11 ())
    (defun G12 ())
    (defun G13 ())
    ;;
    (defun UEV_All:bool (guards:[guard]))
    (defun UEV_Any:bool (guards:[guard]))
    (defun UEV_IMT (type:string I:[guard] M:[guard] T:[guard]))
    (defun UEV_GuardOfAll:guard (guards:[guard]))
    (defun UEV_GuardOfAny:guard (guards:[guard]))
    (defun UEV_TypeIMT (type:string))
)
(module U|G GOV
    ;;
    (implements OuronetGuards)
    ;;{G1}
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|U|G_ADMIN)))
    (defcap GOV|U|G_ADMIN ()
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (g:guard (ref-U|CT::CT_GOV|UTILS))
            )
            (enforce-guard g)
        )
    )
    ;;
    ;;{3}
    (defun G01 () (at 0 ["TALOS-01"]))
    (defun G02 () (at 0 ["BRD|<"]))
    (defun G03 () (at 0 ["DPTF|<"]))
    (defun G04 () (at 0 ["DPMF|<"]))
    (defun G05 () (at 0 ["ATS|<"]))
    (defun G06 () (at 0 ["TFT|<"]))
    (defun G07 () (at 0 ["ATSU|<"]))
    (defun G08 () (at 0 ["VST|<"]))
    (defun G09 () (at 0 ["LIQUID|<"]))
    (defun G10 () (at 0 ["OUROBOROS|<"]))
    (defun G11 () (at 0 ["SWPT|<"]))
    (defun G12 () (at 0 ["SWP|<"]))
    (defun G13 () (at 0 ["SWPU|<"]))
    ;;
    ;;{F-UEV}
    (defun UEV_All:bool (guards:[guard])
        @doc "Enforces all guards in GUARDS"
        (map (enforce-guard) guards)
        true
    )
    (defun UEV_Any:bool (guards:[guard])
        @doc "Will succeed if at least one guard in GUARDS is successfully enforced."
        (enforce 
            (< 0 (length (filter (= true) (map (UC_Try) guards))))
            "None of the guards passed"
        )
    )
    (defun UEV_IMT (type:string I:[guard] M:[guard] T:[guard])
        @doc "Enforces Secure Intermodule Communications for Stage 1, using <I M T> guard lists"
        (enforce (and (= 1 (length I)) (= 1 (length T))) "Internal and Talos guard must be a single guard")
        (UEV_TypeIMT)
        (cond
            ((= type "I") (enforce-guard (at 0 I)))
            ((= type "M") (enforce-guard ((UEV_GuardOfAny M))))
            ((= type "T") (enforce-guard (at 0 T)))
            ((= type "IM") (enforce-guard (UEV_GuardOfAny (+ I M))))
            ((= type "IT") (enforce-guard (UEV_GuardOfAny (+ I T))))
            ((= type "MT") (enforce-guard (UEV_GuardOfAny (+ M T))))
            ((= type "IMT") (enforce-guard (UEV_GuardOfAny (fold (+) [] [I M T]))))
            true
        )
    )
    (defun UEV_GuardOfAll:guard (guards:[guard])
        @doc "Create a guard that only succeeds if every guard in GUARDS is successfully enforced."
        (enforce (< 0 (length guards)) "Guard list cannot be empty")
        (create-user-guard (UEV_All guards))
    )
    (defun UEV_GuardOfAny:guard (guards:[guard])
        @doc "Create a guard that succeeds if at least one guard in GUARDS is successfully enforced."
        (enforce (< 0 (length guards)) "Guard list cannot be empty")
        (create-user-guard (UEV_Any guards))
    )
    (defun UEV_TypeIMT (type:string)
        @doc "Enforces a string as one of 7 possible variants, needed for <UEV_SIP>"
        (enforce-one
            "Invalid IMT Type"
            [
                (enforce (= type "I") "Not I")
                (enforce (= type "M") "Not M")
                (enforce (= type "T") "Not T")
                (enforce (= type "IM") "Not IM")
                (enforce (= type "IT") "Not IT")
                (enforce (= type "MT") "Not MT")
                (enforce (= type "IMT") "Not IMT")
            ]
        )
    )
    ;;{F-UDC}
    (defun UC_Try (g:guard)
        @doc "Helper function used in <UEV_Any>"
        (try false (enforce-guard g))
    )
)