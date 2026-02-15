;;1]Deploy <stoa-ns> assets
(namespace "stoa-ns")

(module stoic-xchain GOVERNANCE
    ;;
    @doc "Module for initializing the <kadena-xchain-gas> and <stoa-xchain-gas> Account \
        \ needed to autonomously pay crosschain-transactions."

    (use coin)
    (use util.guards)
    (use util.gas-guards)

    ; ── Define the private/admin-only capability ───────────────────
    (defcap GOVERNANCE ()
        @doc "This is the Key Governing this module"
        (enforce-guard (keyset-ref-guard "ns-admin-keyset"))
    )

    ; ── Create the xchain gas account (admin-only) ─────────────────
    (defun create-xchain-gas-account:string (kadena-or-stoa:bool)
        @doc "Creates the CrossChain Gas Paying Account, either in the legacy name of <kadena-xchain-gas> \
            \ or in the new StoaChain name, now being <stoa-xchain-gas>"
        (with-capability (GOVERNANCE)
            (let
                (
                    (minimum-gas-price-anu:integer (coin.UC_MinimumGasPriceANU))
                    (minimum-stoa-gas-price:decimal (/ (dec minimum-gas-price-anu) 1000000000000.0))
                    (below-or-at-gas-price:guard
                        (if kadena-or-stoa
                            (create-user-guard (util.gas-guards.enforce-below-or-at-gas-price 0.00000001))
                            (create-user-guard (util.gas-guards.enforce-below-or-at-gas-price minimum-stoa-gas-price))
                        )
                    )
                    (gas-restriction-guard:guard
                        (create-user-guard
                            (util.gas-guards.enforce-guard-all
                                [ 
                                    (create-user-guard (coin.gas-only))
                                    below-or-at-gas-price
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
                    (account-name:string
                        (if kadena-or-stoa
                            "kadena-xchain-gas"
                            "stoa-xchain-gas"
                        )
                    )
                )
                (coin.C_CreateAccount account-name final-guard)
                (format "Account <{}> succesfully created" [account-name])
            )
        )
    )
    ;;
)

;;2]Define the account
;;2.1] Define <kadena-xchain-gas> account
(create-xchain-gas-account true)
;;2.2] Define <stoa-xchain-gas> account
;;     <stoa-xchain-gas> uses a minim Gas Price computed via <coin.UC_MinimumGasPriceANU>
(create-xchain-gas-account false)
;;
;;3]Initialy the <kadena-xchain-gas> will be used for CrossChain Transaction payouts, and thez need to be fueled on every chain
;;4]Later on, with the minimum GasCost Update, payment will be switched to <stoa-xchain-gas>, 
;;  while the <kadena-xchain-gas> accounts will be decommissioned.