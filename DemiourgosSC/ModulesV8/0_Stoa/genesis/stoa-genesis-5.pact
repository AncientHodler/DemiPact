;;1]Deploy <stoa-ns> assets
(namespace "stoa-ns")

(module stoic-xchain GOVERNANCE
    ;;
    @doc "Module for initializing the kadena-xchain-gas Account \
        \ needed to autonomously pay crosschain-transactions"

    (use coin)
    (use util.guards)
    (use util.guards1)

    ; ── Define the private/admin-only capability ───────────────────
    (defcap GOVERNANCE ()
        @doc "This is the Key Governing this module"
        (enforce-guard (keyset-ref-guard "ns-admin-keyset"))
    )

    ; ── Create the xchain gas account (admin-only) ─────────────────
    (defun create-xchain-gas-account:string ()
        @doc "Creates kadena-xchain-gas — only callable by module Governance"
        (with-capability (GOVERNANCE)
            (let
                (
                    (gas-restriction-guard:guard
                        (create-user-guard
                            (util.guards1.enforce-guard-all
                                [ 
                                    (create-user-guard (coin.gas-only))
                                    (create-user-guard (util.guards1.enforce-below-or-at-gas-price 0.00000001))
                                    (create-user-guard (util.guards1.enforce-below-or-at-gas-limit 850))
                                ]
                            )
                        )
                    )
                    (final-guard:guard
                        (create-user-guard
                            (util.guards.enforce-or
                                (keyset-ref-guard "ns-admin-keyset")
                                gas-restriction-guard
                            )
                        )
                    )
                )
                (coin.C_CreateAccount "kadena-xchain-gas" final-guard)
                "kadena-xchain-gas account successfully created"
            )
        )
    )
    ;;
)

(create-xchain-gas-account)