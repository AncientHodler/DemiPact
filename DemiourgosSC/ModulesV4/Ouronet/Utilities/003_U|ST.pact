(module U|ST GOV
    ;;
    (implements OuronetGasStation)
    ;;{G1}
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|U|ST_ADMIN))
    )
    (defcap GOV|U|ST_ADMIN ()
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
    (defun max-gas-notional:guard (gasNotional:decimal)
        @doc "Guard to enforce gas price * gas limit is smaller than or equal to GAS"
        (create-user-guard
            (enforce-below-or-at-gas-notional gasNotional)
        )
    )
    (defun enforce-below-gas-notional (gasNotional:decimal)
        (enforce (< (chain-gas-notional) gasNotional)
            (format "Gas Limit * Gas Price must be smaller than {}" [gasNotional])
        )
    )
    (defun enforce-below-or-at-gas-notional (gasNotional:decimal)
        (enforce (<= (chain-gas-notional) gasNotional)
            (format "Gas Limit * Gas Price must be smaller than or equal to {}" [gasNotional])
        )
    )
    (defun max-gas-price:guard (gasPrice:decimal)
        @doc "Guard to enforce gas price is smaller than or equal to GAS PRICE"
        (create-user-guard
            (enforce-below-or-at-gas-price gasPrice)
        )
    )
    (defun enforce-below-gas-price:bool (gasPrice:decimal)
        (enforce (< (chain-gas-price) gasPrice)
            (format "Gas Price must be smaller than {}" [gasPrice])
        )
    )
    (defun enforce-below-or-at-gas-price:bool (gasPrice:decimal)
        (enforce (<= (chain-gas-price) gasPrice)
            (format "Gas Price must be smaller than or equal to {}" [gasPrice])
        )
    )
    (defun max-gas-limit:guard (gasLimit:integer)
        @doc "Guard to enforce gas limit is smaller than or equal to GAS LIMIT"
        (create-user-guard
            (enforce-below-or-at-gas-limit gasLimit)
        )
    )
    (defun enforce-below-gas-limit:bool (gasLimit:integer)
        (enforce (< (chain-gas-limit) gasLimit)
            (format "Gas Limit must be smaller than {}" [gasLimit])
        )
    )
    (defun enforce-below-or-at-gas-limit:bool (gasLimit:integer)
        (enforce (<= (chain-gas-limit) gasLimit)
            (format "Gas Limit must be smaller than or equal to {}" [gasLimit])
        )
    )
    (defun chain-gas-price ()
        @doc "Return gas price from chain-data"
        (at 'gas-price (chain-data))
    )
    (defun chain-gas-limit ()
        @doc "Return gas limit from chain-data"
        (at 'gas-limit (chain-data))
    )
    (defun chain-gas-notional ()
        @doc "Return gas limit * gas price from chain-data"
        (* (chain-gas-price) (chain-gas-limit))
    )
)