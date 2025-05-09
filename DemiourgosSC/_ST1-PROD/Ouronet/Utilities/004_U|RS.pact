(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(interface ReservedAccounts
    @doc "Exported Reserved Account Functions"
    ;;
    (defun UEV_CheckReserved:string (account:string))
    (defun UEV_EnforceReserved:bool (account:string guard:guard))
)
(module U|RS GOV
    ;;
    (implements ReservedAccounts)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|U|RS_ADMIN)))
    (defcap GOV|U|RS_ADMIN ()
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
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    ;;{P3}
    ;;{P4}
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    ;;{C2}
    ;;{C3}
    ;;{C4}
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_CheckReserved:string (account:string)
        @doc "Checks account for reserved name and returns type if \
            \ found or empty string. Reserved names start with a \
            \ single char and colon, e.g. 'c:foo', which would return 'c' as type."
        (let
            (
                (pfx (take 2 account))
            )
            (if (= ":" (take -1 pfx))
                (take 1 pfx)
                ""
            )
        )
    )
    (defun UEV_EnforceReserved:bool (account:string guard:guard)
        @doc "Enforce reserved account name protocols"
        (if
            (validate-principal guard account)
            true
            (let
                (
                    (r (UEV_CheckReserved account))
                )
                (if
                    (= r "")
                    true
                    (if
                        (= r "k")
                        (enforce false "Single-key account protocol violation")
                        (enforce false (format "Reserved protocol guard violation: {}" [r]))
                    )
                )
            )
        )
    )
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)