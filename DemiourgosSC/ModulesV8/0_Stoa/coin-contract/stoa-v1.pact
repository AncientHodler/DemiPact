(interface StoaFungibleV1
    @doc "Standard for Stoa and StoaFungibleV1 Coins"
    ;; [0] Schemas
    (defschema StoaAccountDetails
        @doc "Schema for results of Account Operation"
        account:string
        balance:decimal
        guard:guard
    )
    ;; [1] CAPS
    ;; [On Chain Transfers]
    (defcap TRANSFER:bool (sender:string receiver:string amount:decimal)
        @doc "Managed Capability sealing <amount> for transfer from <sender> to <receiver> \
            \ Permits any number of transfers up to <amount>"
        @managed amount TRANSFER-mgr
    )
        (defun TRANSFER-mgr:decimal (managed:decimal requested:decimal)
            @doc "Manages TRANSFER <amount> linearly, such that a request from 1.0 <amount> \
            \ on a 3.0 <amounts> managed quantity emits updated amount 2.0"
        )
    ;;  [Cross Chain Transfers]
    (defcap TRANSFER-ACROSS:bool (sender:string receiver:string amount:decimal target-chain:string)
        @doc "Managed Capability sealing <amount> for a Transfer-Across \
            \ from <sender> to <receiver> on <target-chain> \
            \ Allows any number of Transfer-Across up to <amount>"
        @managed amount TRANSFER-ACROSS-mgr
    )
        (defun TRANSFER-ACROSS-mgr:decimal (managed:decimal requested:decimal)
            @doc "Allows a Transfer-Across to be less than or equal to managed quantity \
             \ as a once shot, returning 0.0"
        )
    (defcap TRANSFER-ACROSS-RCV:bool (sender:string receiver:string amount:decimal source-chain:string)
        @doc "Event emitted on receipt of a Transfer-Across"
        @event
    )
    ;; [2] Functions
    (defun UR_Details:object{StoaAccountDetails} (account:string))      ;;Get an object with the details of an <account>
    (defun UR_Precision:integer ())                                     ;;Returns Stoa Precision
    ;;
    (defun UEV_StoaPrecision:bool (amount:decimal))                     ;;Enforces Stoa Precision
    ;;
    (defun C_CreateAccount:string (account:string guard:guard))         ;;Creates a new Account for the given Fungible
    (defun C_RotateAccount:string (account:string new-guard:guard))     ;;Rotates the Guard of an Account
    (defun C_Transfer:string (sender:string receiver:string amount:decimal)
        @doc "Transfers <amount> from <sender> to <receiver> \
            \ Fails if either <sender> or <receiver> does not exist"
    )
    (defun C_TransferAnew:string (sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "Transfers <amount> from <sender> to <receiver> \
            \ Fails if <sender> does not exist \
            \ If <receiver> exist, guard must match existing value \
            \ If <receiver> does not exist, it is created using <receiver-guard> \
            \ Subject to management by [TRANSFER] capability"
    )
    (defpact C_TransferAcross:string (sender:string receiver:string receiver-guard:guard target-chain:string amount:decimal)
        @doc "2 Sterp Pact to transfer <amount> from <sender> to <receiver> on <target-chain> via SPV Proof \
            \ <target-chain> must be different from current chain-id \
            \ 1.Step debits <amount> from <sender> and yields <receiver>, <receiver-guard> and <amount> to <target-chain> \
            \ 2.Step continuation is sent into <target-chain> with proof obtained from the spv output endpoint of Chainweb \
            \ Proof is validated and <receiver> is credited the <amount>, creating account with <receiver-guard> as needed"
    )
)
(module STOA GOV
    @doc "Stoa represents the StoaChain Coin Contract \
    \ Forked from the latest original coin contract on Kadena Chain"
    (implements StoaFungibleV1)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst STOA|MasterOne                "stoa-ns.stoa_master_one")
    (defconst STOA|MasterTwo                "stoa-ns.stoa_master_two")
    (defconst STOA|MasterThree              "stoa-ns.stoa_master_three")
    (defconst STOA|MasterFour               "stoa-ns.stoa_master_four")
    (defconst STOA|MasterFive               "stoa-ns.stoa_master_five")
    (defconst STOA|MasterSix                "stoa-ns.stoa_master_six")
    (defconst STOA|MasterSeven              "stoa-ns.stoa_master_seven")
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|STOA_MASTERS)))
    (defcap GOV|STOA_MASTERS ()
        @event
        (enforce-one
            "Stoa Masters Permission not satisfied"
            [
                (enforce-guard (keyset-ref-guard STOA|MasterOne))
                (enforce-guard (keyset-ref-guard STOA|MasterTwo))
                (enforce-guard (keyset-ref-guard STOA|MasterThree))
                (enforce-guard (keyset-ref-guard STOA|MasterFour))
                (enforce-guard (keyset-ref-guard STOA|MasterFive))
                (enforce-guard (keyset-ref-guard STOA|MasterSix))
                (enforce-guard (keyset-ref-guard STOA|MasterSeven))
            ]
        )
    )
    ;;{G3}
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    
    ;;{1}
    (defschema StoaSchema
        @doc "The basic Stoa Fungible Token Schema"
        balance:decimal
        guard:guard
    )
    (defschema StoaAcrossSchema
        @doc "Schema for yielded values in CrossChain Transfers"
        receiver:string
        receiver-guard:guard
        amount:decimal
        source-chain:string
    )
    (defschema LocalSupplySchema
        local-circulating:decimal
    )
    ;;{2}
    (deftable StoaTable:{StoaSchema})
    (deftable LocalSupply:{LocalSupplySchema})
    ;;{3}
    (defconst COIN_CHARSET              CHARSET_LATIN1)
    (defconst STOA_PREC                 12)
    (defconst MINIMUM_ACCOUNT_LENGTH    3)
    (defconst MAXIMUM_ACCOUNT_LENGTH    256)
    (defconst VALID_CHAIN_IDS           (map (int-to-str 10) (enumerate 0 19)))
    (defconst CSK                       "chain-supply-key")
    ;;
    (defconst GENESIS-SUPPLY            12000000.0)
    (defconst GENESIS-CEILING           480000000.0)
    (defconst GENESIS-TIME              (time "2026-01-01T00:00:00Z"))
    (defconst BPD                       2880.0)
    (defconst EMISSION-SPEED            25000.0)
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap GAS ()
        @doc "Protects GAS buy and redeem"
        true
    )
    (defcap COINBASE ()
        @doc "Protects miner reward"
        true
    )
    (defcap GENESIS ()
        @doc "Protects genesis transactions"
        true
    )
    (defcap REMEDIATE ()
        @doc "Used for remediation transactions"
        true
    )
    (defcap UPDATE-LOCAL-SUPPLY ()
        @doc "Required for Local Supply Update"
        true
    )
    (defcap ROTATE (account:string new-guard:guard)
        @doc "Manages Guard Rotation"
        @managed
        ;;Allow Rotation only for vanity accounts, or
        ;;Re-Rotating a principa account back to its proper guard
        (enforce
            (or
                (not (is-principal account))
                (validate-principal new-guard account)
            )
            "It is unsafe for principal accounts to rotate their guard"
        )
        (CAP_Account account)
    )
    (defcap TRANSFER-ACROSS-RCV:bool
        (sender:string receiver:string amount:decimal source-chain:string)
        @event
        true
    )
    ;;{C2}
    (defcap DEBIT (sender:string amount:decimal)
        @doc "Manages debit operations"
        (enforce-guard (UR_Guard sender))
        (enforce (!= sender "") "Invalid Sender")
        (let
            (
                (account-balance:decimal (UR_Balance sender))
            )
            (enforce (<= amount account-balance) "Insufficient debiting balance")
        )
    )
    (defcap CREDIT (receiver:string)
        @doc "Manages credit operations"
        (enforce (!= receiver "") "Invalid Receiver")
    )
    ;;{C3}
    ;;{C4}
    (defcap TRANSFER:bool (sender:string receiver:string amount:decimal)
        @managed amount TRANSFER-mgr
        (UEV_SenderWithReceiver sender receiver)
        (UEV_Amount amount "Transfer requires a positive amount")
        (UEV_StoaPrecision amount)
        (compose-capability (DEBIT sender))
        (compose-capability (CREDIT receiver))
    )
        (defun TRANSFER-mgr:decimal (managed:decimal requested:decimal)
            (let
                (
                    (new-balance:decimal (- managed requested))
                )
                (UEV_MngAmount new-balance (format "Transfer exceeded for balance {}" [managed]))
                new-balance
            )
        )
    (defcap TRANSFER-ACROSS:bool (sender:string receiver:string amount:decimal target-chain:string)
        @managed amount TRANSFER-ACROSS-mgr
        (UEV_Amount amount "Transfer-Across requires a positive amount")
        (enforce (> amount 0.0) )
        (UEV_StoaPrecision amount)
        (compose-capability (DEBIT sender))
        (compose-capability (UPDATE-LOCAL-SUPPLY))
    )
        (defun TRANSFER-ACROSS-mgr:decimal (managed:decimal requested:decimal)
            (enforce (>= managed requested) (format "Transfer-Across exceeded for balance {}" [managed]))
            0.0
        )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_CheckReserved:string (account:string)
        @doc "Checks <account> for reserved name and returns type if found or empty string. \
        \ Reserved names start with a single char and colon, e.g. 'c:foo', which would return 'c' as type."
        (let
            (
                (pfx:string (take 2 account))
            )
            (if (= ":" (take -1 pfx))
                (take 1 pfx)
                ""
            )
        )
    )
    (defun UC_CurrentCeiling ()
        (let
            (
                (genesis-year:decimal (UC_GetYear GENESIS-TIME))
                (year-now:decimal (UC_GetYear (at "time" (chain-data))))
                (new-millions:decimal (* 1000000.0 (- year-now genesis-year)))
            )
            (+ new-millions GENESIS-CEILING)
        )
    )
    (defun UC_GetYear:decimal (input:time)
        (dec (str-to-int (format-time "%Y" input)))
    )
    ;;{F0}  [UR]
    (defun UR_Details:object{StoaFungibleV1.StoaAccountDetails} (account:string)
        (with-read StoaTable account
            {"balance"  := bal
            ,"guard"    := g}
            (UDC_AccountDetails account bal g)
        )
    )
    (defun UR_Balance:decimal (account:string)
        (at "balance" (read StoaTable account ["balance"]))
    )
    (defun UR_Guard:guard (account:string)
        (at "guard" (read StoaTable account ["guard"]))
    )
    (defun UR_Precision:integer ()
        STOA_PREC
    )
    (defun UR_LocalStoaSupply:decimal ()
        (with-default-read LocalSupply CSK
            {"local-circulating": 0.0}
            {"local-circulating" := supply}
            supply
        )
    )
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_Account (account:string)
        @doc "Validates the <account> string"
        (enforce (is-charset COIN_CHARSET account) (format "Account {} is not CharSet conform" [account]))
        (let
            (
                (account-length:integer (length account))
                (check:bool
                    (and
                        (>= account-length MINIMUM_ACCOUNT_LENGTH)
                        (<= account-length MAXIMUM_ACCOUNT_LENGTH)
                    )
                )
            )
            (enforce check (format "Account {} has invalid length" [account]))
        )
    )
    (defun UEV_SenderWithReceiver (sender:string receiver:string)
        (enforce (!= sender receiver) "Sender and Receiver must be different for execution!")
    )
    (defun UEV_Reserved:bool (account:string guard:guard)
        @doc "Enforce reserved account name protocolas"
        (if (validate-principal guard account)
            true
            (let
                (
                    (r:string (UC_CheckReserved account))
                )
                (if (= r "")
                    true
                    (if (= r "k")
                        (enforce false "Single-key account protocol violation")
                        (enforce false (format "Reserved protocol guard violation: {}" [r]))
                    )
                )
            )
        )
    )
    (defun UEV_StoaPrecision:bool (amount:decimal)
        @doc "Enforces Stoa Coin Precision"
        (enforce
            (=
                (floor amount STOA_PREC)
                amount
            )
            (format "Amount {} violates Stoa Precision of {}" [amount STOA_PREC])
        )
    )
    (defun UEV_Amount (amount:decimal message:string)
        (enforce (> amount 0.0) message)
    )
    (defun UEV_MngAmount (amount:decimal message:string)
        (enforce (>= amount 0.0) message)
    )
    ;;{F3}  [UDC]
    (defun UDC_AccountDetails:object{StoaFungibleV1.StoaAccountDetails}
        (a:string b:decimal c:guard)
        {"account"          : a
        ,"balance"          : b
        ,"guard"            : c}
    )
    (defun UDC_AccountData:object{StoaSchema} 
        (a:decimal b:guard)
        {"balance"          : a
        ,"guard"            : b}
    )
    (defun UDC_AcrossData:object{StoaAcrossSchema}
        (a:string b:guard c:decimal d:string)
        {"receiver"         : a
        ,"receiver-guard"   : b
        ,"amount"           : c
        ,"source-chain"     : d}
    )
    ;;{F4}  [CAP]
    (defun CAP_GasOnly ()
        @doc "Predicate for gas-onlz user guards"
        (require-capability (GAS))
    )
    (defun CAP_GasGuard (guard:guard)
        @doc "Predicate for gas + single key user guards"
        (enforce-one
            "Enforces either the presence of a GAS-Capability or Keyset"
            [
                (CAP_GasOnly)
                (enforce-guard guard)
            ]
        )
    )
    (defun CAP_Account (account:string)
        (enforce-guard (UR_Guard account))
    )
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_CreateAccount:string (account:string guard:guard)
        (UEV_Account account)
        (UEV_Reserved account guard)
        (insert StoaTable account
            (UDC_AccountData 0.0 guard)
        )
    )
    (defun C_RotateAccount:string (account:string new-guard:guard)
        (with-capability (ROTATE account new-guard)
            (update StoaTable account
                {"guard" : new-guard}
            )
        )
    )
    (defun C_Transfer:string (sender:string receiver:string amount:decimal)
        (UEV_Account sender)
        (UEV_Account receiver)
        (UEV_Amount amount "Transfer amount must be positive!")
        (with-capability (TRANSFER sender receiver amount)
            (X_Debit sender amount)
            (X_Credit receiver (UR_Guard receiver) amount)
        )
    )
    (defun C_TransferAnew:string (sender:string receiver:string receiver-guard:guard amount:decimal)
        (UEV_Account sender)
        (UEV_Account receiver)
        (UEV_Amount amount "Transfer amount must be positive!")
        (with-capability (TRANSFER sender receiver amount)
            (X_Debit sender amount)
            (X_Credit receiver receiver-guard amount)
        )
    )
    (defpact C_TransferAcross:string
        (sender:string receiver:string receiver-guard:guard target-chain:string amount:decimal)
        (step
            (with-capability (TRANSFER-ACROSS sender receiver amount target-chain)
                (enforce (!= "" target-chain) "Empty target-chain!")
                (enforce (!= (at "chain-id" (chain-data)) target-chain) "Cannot run cross-chain transfers to the same chain")
                (enforce (contains target-chain VALID_CHAIN_IDS) "Target Chain is not a valid chainweb chain id")
                (UEV_Account sender)
                (UEV_Account receiver)
                (UEV_StoaPrecision amount)
                (UEV_Amount amount "TransferAcross amount must be positive!")
                (X_Debit sender amount)
                (emit-event (TRANSFER sender "" amount))
                (X_UpdateLocalSupply amount false)
                (yield
                    (UDC_AcrossData receiver receiver-guard amount (at "chain-id" (chain-data)))
                    target-chain
                )
            )
        )
        (step
            (resume
                {"receiver"         := receiver
                ,"receiver-guard"   := receiver-guard
                ,"amount"           := amount
                ,"source-chain"     := source-chain}
                (emit-event (TRANSFER "" receiver amount))
                (emit-event (TRANSFER-ACROSS-RCV "" receiver amount source-chain))
                (with-capability (CREDIT receiver)
                    (X_Credit receiver receiver-guard amount)
                )
                (with-capability (UPDATE-LOCAL-SUPPLY)
                    (X_UpdateLocalSupply amount true)
                )
            )
        )
    )
    ;;{F7}  [X]  - Auxiliary Functions with protection
    ;;      [XM] - Protected by Magic Capabilities (Node Runtime)  
    (defun X_Credit:string (account:string guard:guard amount:decimal)
        @doc "Credits <amount> to <account> balance"
        (UEV_Account account)
        (UEV_Amount amount "Credit Amount must be positive")
        (UEV_StoaPrecision amount)
        (require-capability (CREDIT account)
            (with-default-read StoaTable account
                (UDC_AccountData -1.0 guard)
                {"balance"  := balance
                ,"guard"    := retg}
                ;We don't want to overwrite an existing guard with the user-supplied one
                (enforce (= retg guard) "Account guards do not match !")
                (let
                    (
                        (is-new:bool 
                            (if (= balance -1.0)
                                (UEV_Reserved account guard)
                                false
                            )
                        )
                    )
                    (write StoaTable account
                        (UDC_AccountData (if is-new amount (+ balance amount)) retg)
                    )
                )
            )
        )
    )
    (defun X_Debit:string (account:string amount:decimal)
        @doc "Debits <amount> from <account> balance"
        (UEV_Account account)
        (UEV_Amount amount "Debit Amount must be positive")
        (UEV_StoaPrecision amount)
        (require-capability (DEBIT account amount))
        (with-read StoaTable account
            {"balance" := balance}
            (update StoaTable account
                {"balance" : (- balance amount)}
            )
        )
    )
    (defun X_UpdateLocalSupply (amount:decimal direction:bool)
        (require-capability (UPDATE-LOCAL-SUPPLY))
        (UEV_StoaPrecision amount)
        (let
            (
                (current-supply:decimal (UR_LocalStoaSupply))
                (updated-supply:decimal
                    (if direction
                        (+ current-supply amount)
                        (- current-supply amount)
                    )
                )
            )
            (write LocalSupply CSK
                {"local-circulating" : updated-supply}
            )
        )
    )
    ;;
    (defun XM_StoaCoinbase:string (account:string account-guard:guard)
        @doc "Internal Function for the initial creation of coins. \
            \ Cannot be used outside of the coin contract"
        (require-capability (COINBASE))
        (UEV_Account account)
        (let
            (
                (current-total-supply:decimal (at "global-supply-register" (chain-data)))
                (current-ceiling:decimal (UC_CurrentCeiling))
                (remaining:decimal (- current-ceiling current-total-supply))
                (divisor:decimal (* BPD EMISSION-SPEED))
                (yang-amount:decimal (floor (/ remaining divisor) STOA_PREC))
            )
            (with-capability (UPDATE-LOCAL-SUPPLY)
                (X_UpdateLocalSupply yang-amount true)
            )
            (with-capability (CREDIT account)
                (X_Credit account account-guard yang-amount)
            )
        )
    )
    (defpact XM_FundTX (sender:string miner:string miner-guard:guard total:decimal)  
        @doc "For funding a transaction in two steps, \
            \ with the actual transaction transpiring in the middle \
            \ \ 
            \ 1] A buying phase, debiting the sender for total gas and fee, yielding TX_MAX_CHARGE \
            \ 2] A settlement phase, resuming TX_MAX_CHARGE, \
            \    and allocating to the coinbase account for used gas and fee \
            \    and sender account for balance (unused gas, if any)"
        (step (XM_BuyGas sender total))
        (step (XM_RedeemGas miner miner-guard sender total))
    )
    (defun XM_BuyGas:string (sender:string total:decimal)
        @doc "Describes the main [gas-buy] operation \
            \ At this point Miner has been chosen from the pool, and will be validated \
            \ <sender> of the transaction has specified a Gas limit (max gas) for the tx, \
            \ with the price being the spot price of gas at that time \
            \ The [gas-buy] will be executed prior to executing <sender> code"
        (require-capability (GAS))
        (UEV_Amount total "Gas Supply must be positive")
        (UEV_Account sender)
        (UEV_StoaPrecision total)
        (with-capability (DEBIT sender)
            (X_Debit sender total)
        )
    )
    (defun XM_RedeemGas:string (miner:string miner-guard:guard sender:string total:decimal)
        @doc "Describes the main [gas-redeem] operation \
            \ At this point, the <sender> tx has been executed, \
            \ and the gas that was charged has been calculated. \
            \ <miner> will be credited the gas cost, \
            \ and <sender> will receive the remainder up to the limit"
        (require-capability (GAS))
        (UEV_Account sender)
        (UEV_Account miner)
        (UEV_StoaPrecision total)
        (let
            (
                (fee (read-decimal "fee"))
                (refund (- total fee))
            )
            (UEV_StoaPrecision fee)
            (UEV_MngAmount fee "Fee must be a non-negative quantity")
            (UEV_MngAmount refund "Refund must be a non-negative quantity")
            (emit-event (TRANSFER sender miner fee))
            (with-capability (CREDIT sender)
                ;; Update Directly instead of credit
                (if (> refund 0.0)
                    (update StoaTable sender
                        {"balance" : (+ (UR_Balance sender) refund)}
                    )
                    "noop"
                )
            )
            (with-capability (CREDIT miner)
                (if (> fee 0.0)
                    (X_Credit miner miner-guard fee)
                    "noop"
                )
            )
        )
    )
    (defun XM_Remediate (account:string amount:string)
        @doc "Allows for remediation transactions \
            \ Protected by the [REMEDIATE] capability"
        @model
        [
            (property (valid-account account))
            (property (> amount 0.0))
        ]
        (UEV_Account account)
        (UEV_Amount amount "Remediation amount must be positive")
        (UEV_StoaPrecision amount)
        (require-capability (REMEDIATE))
        (emit-event (TRANSFER "" account amount))
        (let
            (
                (account-balance:decimal (UR_Balance account))
            )
            (enforce (<= amount account-balance) "Insufficient funds")
            (update StoaTable account
                {"balance" : (- account-balance amount)}
            )
        )
    )
    ;;
)

(create-table StoaTable)
(create-table LocalSupply)