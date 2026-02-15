;;0]Payload requires
;;  <payload_stoa-master-one>
;;  <payload_stoa-master-two>
;;  <payload_stoa-master-three>
;;  <payload_stoa-master-four>
;;  <payload_stoa-master-five>
;;  <payload_stoa-master-six>
;;  <payload_stoa-master-seven>
;;
;;
;;1]Deploy <stoa-ns> assets
(namespace "stoa-ns")
;;1.1]Keys
(define-keyset "stoa-ns.stoa_master_one" (read-keyset "payload_stoa-master-one"))       ;;Initial Definition
(define-keyset "stoa-ns.stoa_master_two" (read-keyset "payload_stoa-master-two"))       ;;Initial Definition
(define-keyset "stoa-ns.stoa_master_three" (read-keyset "payload_stoa-master-three"))   ;;Initial Definition
(define-keyset "stoa-ns.stoa_master_four" (read-keyset "payload_stoa-master-four"))     ;;Initial Definition
(define-keyset "stoa-ns.stoa_master_five" (read-keyset "payload_stoa-master-five"))     ;;Initial Definition
(define-keyset "stoa-ns.stoa_master_six" (read-keyset "payload_stoa-master-six"))       ;;Initial Definition
;;
;;1.2]Interfaces
(interface fungible-v1
    @doc "Standard for fungible coins as specified in KIP-0002 \
    \ STOA Coin follows this standard"
    
    ;; [0] Schemas
    (defschema account-details
        @doc "Schema for results of Account Operation"
        account:string
        balance:decimal
        guard:guard
    )
    ;; [1] CAPS
    ;; [On Chain Transfers]
    (defcap TRANSFER:bool (sender:string receiver:string amount:decimal)
        @doc "Evented Capability that allows transsfer of <amount> from <sender> to <receiver>"
        @managed amount TRANSFER-mgr
    )
    (defun TRANSFER-mgr:decimal (managed:decimal requested:decimal)
        @doc "Manages TRANSFER AMOUNT linearly, \
            \ such that a request for 1.0 amount on a 3.0 \
            \ managed quantity emits updated amount 2.0."
    )
    ;; [2] Functions
    (defun get-balance:decimal (account:string)
        @doc "Gets balance for <account>, failing if it doesnt exist"
    )
    (defun details:object{account-details} (account:string)
        ;@doc "Gets an objects with details of <account>, failing if it doesnt exist"
        @doc "<ORIGINAL> - Gets full details of a Stoa Account"
    )
    (defun precision:integer ()
        @doc "Returns maximum allowed decimal precision"
    )
    ;;
    (defun enforce-unit:bool (amount:decimal)
        @doc "Enforce minimum precision allowed for transactions."
    )
    ;;
    (defun create-account:string (account:string guard:guard)
        @doc "Creates an <account> with 0.0 balance. with <guard> controlling acces"
    )
    (defun rotate:string (account:string new-guard:guard)
        @doc "Rotates guard for <account>, with <new-guard> \
        \ Existing guard of <account> is enforced"
    )
    (defun transfer:string (sender:string receiver:string amount:decimal)
        @doc "Transfers <amount> from <sender> to <receiver> \
            \ Fails if either <sender> or <receiver> does not exist"
    )
    (defun transfer-create:string 
        (sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "Transfers <amount> from <sender> to <receiver> \
            \ Fails if <sender> does not exist \
            \ If <receiver> exist, guard must match existing value \
            \ If <receiver> does not exist, it is created using <receiver-guard> \
            \ No longer subject to management by [TRANSFER] capability"
    )
    (defpact transfer-crosschain:string
        (sender:string receiver:string receiver-guard:guard target-chain:string amount:decimal)
        @doc "2 Step pact to transfer <amount> from <sender> to <receiver> on <target-chain> via SPV Proof \
            \ <target-chain> must be different from current chain-id \
            \ 1.Step debits <amount> from <sender> and yields <receiver>, <receiver-guard> and <amount> to <target-chain> \
            \ 2.Step continuation is sent into <target-chain> with proof obtained from the spv output endpoint of Chainweb \
            \ Proof is validated and <receiver> is credited the <amount>, creating account with <receiver-guard> as needed"
    )
)

(interface fungible-xchain-v1
    @doc "Offers standard capability for Cross-Chain transfers and associated events"
    ;;
    (defcap TRANSFER_XCHAIN:bool
        (sender:string receiver:string amount:decimal target-chain:string)
        @doc "Transfer Capability used for transfer from sender to receiver on target chain."
        @managed amount TRANSFER_XCHAIN-mgr
    )
    (defun TRANSFER_XCHAIN-mgr:decimal (managed:decimal requested:decimal)
        @doc "Allows TRANSFER-XCHAIN AMOUNT to be less than or \
           \ equal managed quantity as a one-shot, returning 0.0."
    )
    (defcap TRANSFER_XCHAIN_RECD:bool (sender:string receiver:string amount:decimal source-chain:string)
        @doc "Event emitted on receipt of cross-chain transfer."
        @event
    )
)

(interface gas-payer-v1
    @doc "Interface required for Gas Stations"

    (defcap GAS_PAYER:bool (user:string limit:integer price:decimal)
      @doc "Provide a capability indicating that declaring module supports \
        \ gas payment for USER for gas LIMIT and PRICE. Functionality \
        \ should require capability (coin.FUND_TX), and should validate \
        \ the spend of (limit * price), possibly updating some database \
        \ entry. \
        \ Should compose capability required for 'create-gas-payer-guard'."
    )
  
    (defun create-gas-payer-guard:guard ()
      @doc "Provide a guard suitable for controlling a coin account that can \
        \ pay gas via GAS_PAYER mechanics. Generally this is accomplished \
        \ by having GAS_PAYER compose an unparameterized, unmanaged capability \
        \ that is required in this guard. Thus, if coin contract is able to \
        \ successfully acquire GAS_PAYER, the composed 'anonymous' cap required \
        \ here will be in scope, and gas buy will succeed."
    )
)

(interface stoic-fungible-v1
    @doc "Standard Interface for Stoa based True Fungibles \
        \ Stoa based true fungibles must adhere to a special syntax and architecture, \
        \ that incorporate <fungible-v1> and <fungible-xchain-v1> interfaces functionality, \
        \ while adding additional functionality, such as Supply Tracking, \
        \ Transmit functions (unmanaged Transfer function) \
        \ Must allways allow for crosschain-transfers."
    ;; [0] Schemas
    (defschema account-details
        @doc "Schema for results of Account Operation"
        account:string
        balance:decimal
        guard:guard
    )
    (defschema LocalSupplySchema
        local-circulating:decimal
    )
    ;; [0.1] Constants
    (defconst CSK "chain-supply-key")
    (defun CoinSupplyKey ()
        @doc "Must point to <StoaFungibleV1.CSK>"
    )
    ;; [1] CAPS
    ;; [On Chain Transfers]
    (defcap TRANSFER:bool (sender:string receiver:string amount:decimal)
        @doc "Managed Capability that allows transsfer of <amount> from <sender> to <receiver>"
        @managed amount TRANSFER-mgr
    )
    (defun TRANSFER-mgr:decimal (managed:decimal requested:decimal)
        @doc "Manages TRANSFER AMOUNT linearly, \
            \ such that a request for 1.0 amount on a 3.0 \
            \ managed quantity emits updated amount 2.0."
    )
    (defcap TRANSMIT:bool (sender:string receiver:string amount:decimal)
        @doc "Evented Capability that allows transfer of <amount> from <sender> to <receiver>"
        @event
    )
    ;;  [Cross Chain Transfers]
    (defcap TRANSFER_XCHAIN:bool
        (sender:string receiver:string amount:decimal target-chain:string)
        @doc "Transfer Capability used for transfer from sender to receiver on target chain."
        @managed amount TRANSFER_XCHAIN-mgr
    )
    (defun TRANSFER_XCHAIN-mgr:decimal (managed:decimal requested:decimal)
        @doc "Allows TRANSFER-XCHAIN AMOUNT to be less than or \
           \ equal managed quantity as a one-shot, returning 0.0."
    )
    (defcap TRANSFER_XCHAIN_RECD:bool (sender:string receiver:string amount:decimal source-chain:string)
        @doc "Event emitted on receipt of cross-chain transfer."
        @event
    )
    ;;  [Other]
    (defcap UPDATE-LOCAL-SUPPLY:bool ()
        @doc "Simple <true> capability needed to update the local supply"
    )
    ;; [2] Functions
    ;;
    ;;  [UR]
    ;;
    (defun UR_Precision:integer ())
    (defun UR_Details:object{stoa-ns.fungible-v1.account-details} (account:string))
    (defun UR_Balance:decimal (account:string))
    (defun UR_Guard:guard (account:string))
    (defun UR_LocalCoinSupply:decimal ())
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_CoinPrecision:bool (amount:decimal)
        @doc "Should validate Coin Precision"
    )
    ;;
    ;;  [CAP]
    ;;
    (defun CAP_Account (account:string)
        @doc "Should enforce account wonership"
    )
    ;;
    ;;  [C]
    ;;
    (defun C_CreateAccount:string (account:string guard:guard)
        @doc "Should create a new coin account"
    )
    (defun C_RotateAccount:string (account:string new-guard:guard)
        @doc "Should rotate the guard oan existing account"
    )
    (defun C_Transfer:string (sender:string receiver:string amount:decimal)
        @doc "Should transfer <amount> from <sender> to <receiver>"
    )
    (defun C_TransferAnew:string (sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "Should transfer <amount> from <sender> to <receiver> with account creation using <receiver-guard>"
    )
    (defun C_TransferAcross:string (sender:string receiver:string receiver-guard:guard target-chain:string amount:decimal)
        @doc "Should execute a crosschain transfer using the <transfer-crosschain> defpact"
    )
    (defun C_Transmit:string (sender:string receiver:string amount:decimal)
        @doc "Should be similar to <C_Transfer> but unmanaged"
    )
    (defun C_TransmitAnew:string (sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "Should be similar to <C_TransferAnew> but unmanaged"
    )
    (defpact transfer-crosschain:string (sender:string receiver:string receiver-guard:guard target-chain:string amount:decimal)
        @doc "Should execute a crosschain transfer using 2 steps"
    )
    ;;
    ;;  [X]
    ;;
    (defun X_UpdateLocalSupply (amount:decimal direction:bool)
        @doc "Used to update coin local supply. \
        \ Must require [UPDATE-LOCAL-SUPPLY] for the supply to be updated safely"
    )
)
;;
;;1.3]Modules
(module stoic-predicates "stoa-ns.stoa_master_one"

    @doc "Collection of custom keyset predicates for Stoa chain / Ouronet accounts"

    ;─────────────────────────────────────────────────────────────
    ;  Basic threshold predicates (ignore total count)
    ;─────────────────────────────────────────────────────────────

    (defun keys-1:bool (total:integer signed:integer)
        @doc "At least 1 signature (equivalent to keys-any)"
        (> signed 0)
    )
    (defun keys-3:bool (total:integer signed:integer)
        @doc "At least 3 signatures"
        (>= signed 3)
    )
    (defun keys-4:bool (total:integer signed:integer)
        @doc "At least 4 signatures"
        (>= signed 4)
    )

    ;─────────────────────────────────────────────────────────────
    ;  Percentage-based predicates
    ;─────────────────────────────────────────────────────────────

    (defun at-least-51pct:bool (total:integer signed:integer)
        @doc "Simple majority (> 50%)"
        (> signed (/ total 2))
    )
    (defun at-least-60pct:bool (total:integer signed:integer)
        @doc "≥ 60% of keys must sign"
        (>= (* signed 100) (* total 60))
    )
    (defun at-least-66pct:bool (total:integer signed:integer)
        @doc "≥ 2/3 (supermajority)"
        (>= (* signed 3) (* total 2))
    )
    (defun at-least-75pct:bool (total:integer signed:integer)
        @doc "≥ 75% of keys must sign"
        (>= (* signed 100) (* total 75))
    )
    (defun at-least-90pct:bool (total:integer signed:integer)
        @doc "Very high threshold (near unanimity)"
        (>= (* signed 10) (* total 9))
    )

    ;─────────────────────────────────────────────────────────────
    ;  Strict m-of-n predicates (check both count and threshold)
    ;─────────────────────────────────────────────────────────────

    (defun keys-2-of-3:bool (total:integer signed:integer)
        @doc "Exactly 3 keys, at least 2 must sign"
        (and (= total 3) (>= signed 2))
    )
    (defun keys-3-of-5:bool (total:integer signed:integer)
        @doc "Exactly 5 keys, at least 3 must sign"
        (and (= total 5) (>= signed 3))
    )
    (defun keys-4-of-7:bool (total:integer signed:integer)
        @doc "Exactly 7 keys, at least 4 must sign"
        (and (= total 7) (>= signed 4))
    )
    (defun keys-5-of-9:bool (total:integer signed:integer)
        @doc "Exactly 9 keys, at least 5 must sign"
        (and (= total 9) (>= signed 5))
    )

    ;─────────────────────────────────────────────────────────────
    ;  Tolerance / fault-tolerant predicates
    ;─────────────────────────────────────────────────────────────

    (defun all-but-one:bool (total:integer signed:integer)
        @doc "All keys except at most one must sign"
        (>= signed (- total 1))
    )
    (defun all-but-two:bool (total:integer signed:integer)
        @doc "All keys except at most two must sign"
        (>= signed (- total 2))
    )

)
;;  Define the last <stoa_master_seven> using the custom predicate "stoa-ns.stoic.predicates.keys-3-of-5" 
;;  using 5 public keys.
(define-keyset "stoa-ns.stoa_master_seven" (read-keyset "payload_stoa-master-seven"))   ;;Initial Definition