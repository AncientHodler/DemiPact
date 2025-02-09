(interface OuronetGasStation
    @doc "Exported Ouronet Gas Station Functions"
    ;;
    (defun UC_chain-gas-notional ())
    ;;
    (defun UR_chain-gas-price ())
    (defun UR_chain-gas-limit ())
    ;;
    (defun UEV_max-gas-notional:guard (gasNotional:decimal))
    (defun UEV_enforce-below-gas-notional (gasNotional:decimal))
    (defun UEV_enforce-below-or-at-gas-notional (gasNotional:decimal))
    (defun UEV_max-gas-price:guard (gasPrice:decimal))
    (defun UEV_enforce-below-gas-price:bool (gasPrice:decimal))
    (defun UEV_enforce-below-or-at-gas-price:bool (gasPrice:decimal))
    (defun UEV_max-gas-limit:guard (gasLimit:integer))
    (defun UEV_enforce-below-gas-limit:bool (gasLimit:integer))
    (defun UEV_enforce-below-or-at-gas-limit:bool (gasLimit:integer))
)
(module U|ST GOV
    ;;
    (implements OuronetGasStation)
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|U|ST_ADMIN)))
    (defcap GOV|U|ST_ADMIN ()
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (g:guard (ref-U|CT::CT_GOV|UTILS))
            )
            (enforce-guard g)
        )
    )
    ;;
    ;;{F-UC}
    (defun UC_chain-gas-notional ()
        @doc "Return gas limit * gas price from chain-data"
        (* (UR_chain-gas-price) (UR_chain-gas-limit))
    )
    ;;{F_UR}
    (defun UR_chain-gas-price ()
        @doc "Return gas price from chain-data"
        (at 'gas-price (chain-data))
    )
    (defun UR_chain-gas-limit ()
        @doc "Return gas limit from chain-data"
        (at 'gas-limit (chain-data))
    )
    ;;{F-UEV}
    (defun UEV_max-gas-notional:guard (gasNotional:decimal)
        @doc "Guard to enforce gas price * gas limit is smaller than or equal to GAS"
        (create-user-guard
            (UEV_enforce-below-or-at-gas-notional gasNotional)
        )
    )
    (defun UEV_enforce-below-gas-notional (gasNotional:decimal)
        (enforce (< (UC_chain-gas-notional) gasNotional)
            (format "Gas Limit * Gas Price must be smaller than {}" [gasNotional])
        )
    )
    (defun UEV_enforce-below-or-at-gas-notional (gasNotional:decimal)
        (enforce (<= (UC_chain-gas-notional) gasNotional)
            (format "Gas Limit * Gas Price must be smaller than or equal to {}" [gasNotional])
        )
    )
    (defun UEV_max-gas-price:guard (gasPrice:decimal)
        @doc "Guard to enforce gas price is smaller than or equal to GAS PRICE"
        (create-user-guard
            (UEV_enforce-below-or-at-gas-price gasPrice)
        )
    )
    (defun UEV_enforce-below-gas-price:bool (gasPrice:decimal)
        (enforce (< (UR_chain-gas-price) gasPrice)
            (format "Gas Price must be smaller than {}" [gasPrice])
        )
    )
    (defun UEV_enforce-below-or-at-gas-price:bool (gasPrice:decimal)
        (enforce (<= (UR_chain-gas-price) gasPrice)
            (format "Gas Price must be smaller than or equal to {}" [gasPrice])
        )
    )
    (defun UEV_max-gas-limit:guard (gasLimit:integer)
        @doc "Guard to enforce gas limit is smaller than or equal to GAS LIMIT"
        (create-user-guard
            (UEV_enforce-below-or-at-gas-limit gasLimit)
        )
    )
    (defun UEV_enforce-below-gas-limit:bool (gasLimit:integer)
        (enforce (< (UR_chain-gas-limit) gasLimit)
            (format "Gas Limit must be smaller than {}" [gasLimit])
        )
    )
    (defun UEV_enforce-below-or-at-gas-limit:bool (gasLimit:integer)
        (enforce (<= (UR_chain-gas-limit) gasLimit)
            (format "Gas Limit must be smaller than or equal to {}" [gasLimit])
        )
    )
)