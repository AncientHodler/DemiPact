;;1]Deploy <stoa-ns> assets
(namespace "stoa-ns")

(module stoic-xchain GOVERNANCE
    ;;
    @doc "Module for initializing the kadena-xchain-gas Account \
        \ needed to autonomously pay crosschain-transactions"

    (use coin)
    (use util.guards)
    (use util.gas-guards)

    ; ── Define the private/admin-only capability ───────────────────
    (defcap GOVERNANCE ()
        @doc "This is the Key Governing this module"
        (enforce-guard (keyset-ref-guard "ns-admin-keyset"))
    )

    ; ── Create the xchain gas account (admin-only) ─────────────────
    (defun create-xchain-gas-account:string ()
        @doc "Creates stoa-xchain-gas (former kadena-xchain-gas) — only callable by module Governance"
        (with-capability (GOVERNANCE)
            (let
                (
                    (minimum-gas-price-anu:integer (coin.UC_MinimumGasPriceANU))
                    (minimum-stoa-gas-price:decimal (/ (dec minimum-gas-price-anu) 1000000000000.0))
                    (gas-restriction-guard:guard
                        (create-user-guard
                            (util.gas-guards.enforce-guard-all
                                [ 
                                    (create-user-guard (coin.gas-only))
                                    ;(create-user-guard (util.gas-guards.enforce-below-or-at-gas-price 0.00000001))
                                    (create-user-guard (util.gas-guards.enforce-below-or-at-gas-price minimum-stoa-gas-price))
                                    (create-user-guard (util.gas-guards.enforce-below-or-at-gas-limit 850))
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
                (coin.C_CreateAccount "stoa-xchain-gas" final-guard)
                "stoa-xchain-gas account successfully created"
            )
        )
    )
    ;;
)

(create-xchain-gas-account)