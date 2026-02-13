
(interface fungible-v3
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
(interface fungible-xchain-v2
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
(interface StoaFungibleV2
    @doc "Standard Interface for Stoa based True Fungibles \
        \ Stoa based true fungibles must adhere to a special syntax and architecture, \
        \ that incorporate <fungible-v3> and <fungible-xchain-v2> interfaces functionalitz, \
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
        @doc "Must point to <StoaFungibleV2.CSK>"
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
    (defun UR_Details:object{fungible-v3.account-details} (account:string))
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
        \ Must required [UPDATE-LOCAL-SUPPLY] for the supply to be updated safely"
    )
)
  
(module coinn GOVERNANCE
    @doc "Stoa represents the StoaChain Coin Contract \
        \ Forked from the latest original coin contract on Kadena Chain"

    (implements fungible-v3)                        ;;former <fungible-v2>
    (implements fungible-xchain-v2)                 ;;former <fungible-xchain-v1>
    (implements StoaFungibleV2)                     ;;Incorporates <fungible-v2> and <fungible-xchain-v1> with extra functionality

    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst STOA|MasterOne                        "free.stoa_master_one")
    (defconst STOA|MasterTwo                        "free.stoa_master_two")
    (defconst STOA|MasterThree                      "free.stoa_master_three")
    (defconst STOA|MasterFour                       "free.stoa_master_four")
    (defconst STOA|MasterFive                       "free.stoa_master_five")
    (defconst STOA|MasterSix                        "free.stoa_master_six")
    (defconst STOA|MasterSeven                      "free.stoa_master_seven")
    ;;{G2}
    (defcap GOVERNANCE ()
        @doc "<ORIGINAL>"                           (compose-capability (GOV|STOA_MASTERS))
    )
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
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    (defschema coin-schema
        @doc "<ORIGINAL> \
            \ The STOA contract token schema"
        ;;@model [(invariant (>= balance 0.0))]
    
        balance:decimal
        guard:guard
    )
    (defschema crosschain-schema
        @doc "<ORIGINAL> \
            \ Schema for yielded value in cross-chain transfers"
        receiver:string
        receiver-guard:guard
        amount:decimal
        source-chain:string
    )
    ;;{2}
    (deftable coin-table:{coin-schema})             ;;<ORIGINAL>
    (deftable LocalSupply:{StoaFungibleV2.LocalSupplySchema})
    ;;{3}
    (defconst COIN_CHARSET                          CHARSET_LATIN1
        "<ORIGINAL> - The default coin contract character set"
    )
    (defconst MINIMUM_PRECISION                     12
        "<ORIGINAL> - Minimum allowed precision for coin transactions"
    )
    (defconst MINIMUM_ACCOUNT_LENGTH                3
        "<ORIGINAL> - Minimum account length admissible for coin accounts"
    )
    (defconst MAXIMUM_ACCOUNT_LENGTH                256
        "<ORIGINAL> - Maximum account name length admissible for coin accounts"    
    )
    (defconst VALID_CHAIN_IDS                       (map (int-to-str 10) (enumerate 0 9))
        "<ORIGINAL> - List of all valid Chainweb chain ids (10 Chains for STOA)"
    )
    (defconst CSK                                   (CoinSupplyKey))
    (defconst STOA_PREC                             MINIMUM_PRECISION)
    ;;
    (defconst GENESIS-SUPPLY                        16000000.0)
    (defconst GENESIS-TIME                          (time "2026-02-11T20:00:00Z"))
    (defconst BPD                                   2880)
    ;;
    (defconst GENESIS-MIN-GAS-PRICE                 10000)          ; 10,000 ANU
    (defconst MAX-GAS-PRICE                         400000)         ; 400,000 ANU
    (defconst GAS-PRICE-INTERVAL                    10800.0)        ; 3 hours in seconds
    ;;
    (defun precision:integer ()
        @doc "<ORIGINAL> - Returns the Minimum Precision"
        MINIMUM_PRECISION
    )
    (defun CoinSupplyKey ()
        StoaFungibleV2.CSK
    )
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap SECURE ()
        true
    )
    (defcap GAS ()
        @doc "<ORIGINAL> - [Magic] Protects GAS buy and redeem"
        true
    )
    (defcap COINBASE ()
        @doc "<ORIGINAL> - [Magic] Protects miner reward"
        true
    )
    (defcap GENESIS ()
        @doc "<ORIGINAL> - [Magic] Protects genesis transactions"
        true
    )
    (defcap REMEDIATE ()
        @doc "<ORIGINAL> - [Magic] Used for remediation transactions"
        true
    )
    (defcap UPDATE-LOCAL-SUPPLY:bool ()
        @doc "Required for Local Supply Update"
        true
    )
    (defcap ROTATE (account:string)
        @doc "<ORIGINAL> - Autonomously managed capability for guard rotation"
        @event
        true
    )
    (defcap TRANSFER_XCHAIN_RECD:bool
        (sender:string receiver:string amount:decimal source-chain:string)
        @event
        true
    )
    (defcap RELEASE_ALLOCATION  (account:string amount:decimal)
        @doc "<ORIGINAL><NOT-NEEDED> - Event for allocation release, can be used for sig scoping."
        @event true
    )
    ;;{C2}
    (defcap DEBIT (sender:string)
        @doc "<ORIGINAL> - Capability for managing debiting operations"
        (enforce-guard (UR_Guard sender))
        (enforce (!= sender "") "valid sender")
    )
    (defcap CREDIT (receiver:string)
        @doc "<ORIGINAL> - Capability for managing crediting operations"
        (enforce (!= receiver "") "valid receiver")
    )
    ;;{C3}
    ;;{C4}
    (defcap TRANSMIT:bool (sender:string receiver:string amount:decimal)
        @doc "Similar to TRANSFER, but unmanaged"
        @event
        (compose-capability (X_TRANSFER sender receiver amount))
    )
    (defcap TRANSFER:bool (sender:string receiver:string amount:decimal)
        @doc "<ORIGINAL> - TRANSFER Capability"
        @managed amount TRANSFER-mgr
        (compose-capability (X_TRANSFER sender receiver amount))
    )
    (defun TRANSFER-mgr:decimal (managed:decimal requested:decimal)
        (let
            (
                (newbal:decimal (- managed requested))
            )
            (enforce 
                (>= newbal 0.0)
                (format "STOA TRANSFER exceeded for balance {}" [managed])
            )
            newbal
        )
    )
    (defcap X_TRANSFER:bool (sender:string receiver:string amount:decimal)
        (UEV_Account sender)
        (UEV_Account receiver)
        (UEV_SenderWithReceiver sender receiver)
        (UEV_Amount amount "Transfer requires a positive amount")
        (UEV_CoinPrecision amount)
        (compose-capability (DEBIT sender))
        (compose-capability (CREDIT receiver))
    )
    (defcap TRANSFER_XCHAIN:bool (sender:string receiver:string amount:decimal target-chain:string)
        @doc "<ORIGINAL> - TRANSFER_XCHAIN Capability"
        @managed amount TRANSFER_XCHAIN-mgr
        (UEV_Account sender)
        (UEV_Account receiver)
        (UEV_Amount amount "Transfer-Across requires a positive amount")
        (UEV_CoinPrecision amount)
        (UEV_AcrossChainID target-chain)
        (compose-capability (DEBIT sender))
        (compose-capability (UPDATE-LOCAL-SUPPLY))
    )
    (defun TRANSFER_XCHAIN-mgr:decimal (managed:decimal requested:decimal)
        (enforce 
            (>= managed requested)
            (format "STOA TRANSFER_XCHAIN exceeded for balance {}" [managed])
        )
        0.0
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_CheckReserved:string (account:string)
        (check-reserved account)
    )
    ;;
    (defun check-reserved:string (account:string)
        @doc "<ORIGINAL> - Checks <account> for reserved name and returns type if found or empty string. \
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
    ;;
    (defun UC_YearZeroBlocks ()
        @doc "Computes how many blocks Year 0 has on all chains"
        (let
            (
                (genesis-time:time GENESIS-TIME)
                (year (format-time "%Y" genesis-time))
                (year-end (parse-time "%Y-%m-%d %H:%M:%S" (format "{}-12-31 23:59:59" [year])))
                (seconds-remaining 
                    ;;Seconds remaining untill year end
                    (diff-time year-end genesis-time)
                )
                (blocks:integer (floor (/ seconds-remaining 30.0)))
                (chains:integer (length VALID_CHAIN_IDS))
            )
            (*
                chains
                (if (>= seconds-remaining 0.0)
                    blocks
                    0
                )
            )
        )
    )
    (defun UC_YearDays:integer (year:integer)
        @doc "Computes the number of days in a given year, using the Gregorian Formula"
        (let
            (
                (div4 (= (mod year 4) 0))
                (div100 (= (mod year 100) 0))
                (div400 (= (mod year 400) 0))
                (iz-leap-year:bool
                    (and 
                        div4
                        (or (not div100) div400)
                    )
                )
            )
            (if iz-leap-year 366 365)
        )
    )
    (defun UC_YearEmission:decimal (stoa-year:integer)
        ;;Yearly Emission follows the formula 
        ;;(Ceiling-Supply[at year start])/(Speed);;
        ;;
        ;;Starting Parameters:
        ;;GENESIS-SUPPLY    =  16 000 000,0 STOA
        ;;GENESIS-CEILING   = 500 000 000,0 STOA (+ mil each year)
        ;;SPEED             = 100 (+ 1 each year)
        ;;
        ;;Year 0 Supply = (500 000 000,0 - 16 000 000,000000000000)/100 = 4 840 000,0
        ;;Year 1 Supply = (501 000 000,0 - 20 840 000,000000000000)/101 = 4 754 059,405940594059
        ;;Year 2 Supply = (502 000 000,0 - 25 594 059,405940594059)/102 = 4 670 646.476412347117
        ;;...
        ;;...
        ;;The Linear Formula for this Recurrent formula is
        ;;
        ;;Year (t) Supply = (500.000 * t * t + 99.500.000 * t + 47.916.000.000) / ((t + 99) * (t + 100))
        @doc "Computes the yearly emission using a linear formula based on <stoa-year> \
        \ <stoa-year> is the year number of the Stoa Blockchain. \
        \ The starting year, which is an incomplete year, is considered Year 0"
        (let
            (
                (t:decimal (dec stoa-year))
            )
            (floor
                (/
                    (fold (+) 0.0
                        [
                            (fold (*) 1.0 [500000.0 t t])
                            (* 99500000.0 t)
                            47916000000.0
                        ]
                    )
                    (*
                        (+ t 99.0)
                        (+ t 100.0)
                    )
                )
                STOA_PREC
            )
        )
    )
    (defun UC_GetYear:integer (input:time)
        (str-to-int (format-time "%Y" input))
    )
    (defun UC_MinimumGasPriceANU:integer ()
        @doc "Returns the current minimum gas price in ANU (smallest STOA unit). \
            \ Starts at 10,000 ANU at genesis, increases by 1 ANU every 3 hours, \
            \ caps at 400,000 ANU."
        (let* 
            (
                (current-time:time (at "block-time" (chain-data)))
                (seconds-elapsed:decimal (diff-time current-time GENESIS-TIME))
                (intervals:integer (floor (/ seconds-elapsed GAS-PRICE-INTERVAL)))
                (raw-price:integer (+ GENESIS-MIN-GAS-PRICE (round intervals)))
            )
            (if (> raw-price MAX-GAS-PRICE) 
                MAX-GAS-PRICE 
                raw-price
            )
        )
    )
    (defun UC_MinimumGasPriceSTOA:decimal ()
        @doc "Returns the current minimum gas price in STOA"
        (/ (dec (UC_MinimumGasPriceANU)) 1000000000000.0)
    )
    ;;{F0}  [UR]
    (defun UR_Precision:integer ()
        @doc "Returns the precision of the Stoa Coin"
        (precision)
    )
    (defun UR_Details:object{fungible-v3.account-details} (account:string)
        (details account)
    )
    (defun UR_Balance:decimal (account:string)
        (get-balance account)
    )
    (defun UR_Guard:guard (account:string)
        (at "guard" (read coin-table account ["guard"]))
    )
    ;;
    (defun UR_LocalCoinSupply:decimal ()
        (with-default-read LocalSupply CSK
            {"local-circulating": 0.0}
            {"local-circulating" := supply}
            supply
        )
    )
    ;;
    (defun get-balance:decimal (account:string)
        @doc "<ORIGINAL> - Gets the balance of a Stoa Account"
        (with-read coin-table account
            { "balance" := balance }
            balance
        )
    )
    (defun details:object{fungible-v3.account-details} (account:string)
        @doc "<ORIGINAL> - Gets full details of a Stoa Account"
        (with-read coin-table account
            {"balance"  := bal
            ,"guard"    := g}
            (UDC_AccountDetails account bal g)
        )
    )
    ;;{F1}  [URC]
    (defun URC_Emissions:[decimal] ()
        @doc "Computes the current Block Emission \
        \ Ouputs two values: \
        \ [<block-emission> <urv-emission>] \
        \ <block-emission> = how much each block on each chain gets = 90% split to all chains \
        \ <urv-emission> = how much the UrstoaVault gets = 10% from all chains"   
        (let
            (
                (chains:integer (length VALID_CHAIN_IDS))
                (stoa-year:integer (URC_GetStoaYear))
                (current-year:integer (UC_GetYear (at "block-time" (chain-data))))
                (yearly-stoa-supply:decimal (URC_YearEmission))
                (yearly-days:integer (UC_YearDays current-year))
                (yearly-blocks:integer (* yearly-days BPD))
                (yearly-blocks-total:integer 
                    (if (!= stoa-year 0)
                        (* chains yearly-blocks)    
                        (UC_YearZeroBlocks)
                    )
                )
                (total-block-emission:decimal
                    (floor (/ yearly-stoa-supply (dec yearly-blocks-total)) STOA_PREC)
                )
                (block-emission:decimal (floor (* 0.9 total-block-emission) STOA_PREC))
                (remaining-block-emission:decimal (- total-block-emission block-emission))
                (urv-emission:decimal (* (dec chains) remaining-block-emission))
            )
            [block-emission urv-emission]
        )
    )
    (defun URC_YearEmission:decimal ()
        (UC_YearEmission (URC_GetStoaYear))
    )
    (defun URC_GetStoaYear:integer ()
        (let
            (
                (genesis-year:integer (UC_GetYear GENESIS-TIME))
                (current-year:integer (UC_GetYear (at "block-time" (chain-data))))
                (stoa-year:integer (- current-year genesis-year))
            )
            stoa-year
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_Account (account:string)
        (validate-account account)
    )
    (defun UEV_SenderWithReceiver (sender:string receiver:string)
        @doc "Enforces <sender> is different from <receiver>"
        (enforce (!= sender receiver) "Sender and Receiver must be different for execution!")
    )
    (defun UEV_Amount (amount:decimal message:string)
        @doc "Enforces the <amount> is greater than 0.0 \
            \ Displaying <message> if it isn't"
        (enforce (> amount 0.0) message)
    )
    (defun UEV_MngAmount (amount:decimal message:string)
        @doc "Enforces the <amount> is greater than or equal to 0.0 \
            \ Displaying <message> if it isn't"
        (enforce (>= amount 0.0) message)
    )
    (defun UEV_CoinPrecision:bool (amount:decimal)
        @doc "Enforces Stoa Coin Precision"
        (enforce-unit amount)
    )
    (defun UEV_SufficientBalance (account:string amount:decimal)
        @doc "Enforces that <amount> is sufficient for <account> for debiting operations"
        (let
            (
                (account-balance:decimal (UR_Balance account))
            )
            (enforce 
                (<= amount account-balance)
                (format "The amount of {} is to great to debit from Account {}" [amount account])
            )
        )
    )
    (defun UEV_AcrossChainID (across-chain-id:string)
        (enforce (!= "" across-chain-id) "Empty target-chain!")
        (enforce (!= (at "chain-id" (chain-data)) across-chain-id) "Cannot run cross-chain transfers to the same chain")
        (enforce (contains across-chain-id VALID_CHAIN_IDS) "Target Chain is not a valid chainweb chain id")
    )
    (defun UEV_Reserved:bool (account:string guard:guard)
        (enforce-reserved account guard)
    )
    (defun UEV_Rotate:bool (account:string new-guard:guard)
        @doc "Validation for Rotation"
        ;;1]Enforces existing account guard
        (CAP_Account account)
        (UEV_PureRotate account new-guard)
        
    )
    (defun UEV_PureRotate:bool (account:string new-guard:guard)
        ;;1]Allow rotation only for vanity accounts, or
        ;;  re-rotating a principal account back to its proper guard
        (enforce 
            (or 
                (not (is-principal account))
                (validate-principal new-guard account)
            )
            "It is unsafe for principal accounts to rotate their guard"
        )
    )
    ;;
    (defun validate-account (account:string)
        @doc "<ORIGINAL> \
            \ Enforce that an account name conforms to the coin contract \
            \ minimum and maximum length requirements, as well as the    \
            \ latin-1 character set."
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
            (enforce
                (is-charset COIN_CHARSET account)
                (format
                    "Account does not conform to the coin contract charset: {}"
                    [account]
                )
            )
        )
    )
    (defun enforce-unit:bool (amount:decimal)
        @doc "<ORIGINAL> - Enforce minimum precision allowed for coin transactions"
        (enforce
            (= 
                (floor amount STOA_PREC)
                amount
            )
            (format 
                "Amount {} violates Stoa Precision of {}" 
                [amount STOA_PREC]
            )
        )
    )
    (defun enforce-reserved:bool (account:string guard:guard)
        @doc "<ORIGINAL> - Enforce reserved account name protocols"
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
    ;;{F3}  [UDC]
    (defun UDC_AccountDetails:object{fungible-v2.account-details}
        (a:string b:decimal c:guard)
        {"account"          : a
        ,"balance"          : b
        ,"guard"            : c}
    )
    (defun UDC_AccountData:object{coin-schema} 
        (a:decimal b:guard)
        {"balance"          : a
        ,"guard"            : b}
    )
    (defun UDC_AcrossData:object{crosschain-schema}
        (a:string b:guard c:decimal d:string)
        {"receiver"         : a
        ,"receiver-guard"   : b
        ,"amount"           : c
        ,"source-chain"     : d}
    )
    ;;{F4}  [CAP]
    (defun gas-only ()
        @doc "<ORIGINAL> - Predicate for gas-only user guards."
        (require-capability (GAS))
    )
    (defun gas-guard (guard:guard)
        @doc "<ORIGINAL> - Predicate for gas + single key user guards"
        (enforce-one
            "Enforces either the presence of a GAS-Capability or Guard Keyset"
            [
                (gas-only)
                (enforce-guard guard)
            ]
        )
    )
    (defun CAP_Account (account:string)
        (enforce-guard (UR_Guard account))
    )
    ;;
    ;;{F5}  [A]
    (defun A_InitialiseStoaChain (foundation:string foundation-guard:guard)
        @doc "Initialises StoaChain on Chain0"
        ;;1]Only on ChainId 0
        (UEV_ChainZero)
        (with-capability (GOVERNANCE)
            ;;2]Create Foundation Account for STOA and URSTOA
            (C_CreateAccount foundation foundation-guard)
            (C_UR|CreateAccount foundation foundation-guard)
            ;;3]Mint Genesis STOA and URSTOA
            (XM_InitialMint foundation foundation-guard)
            (XM_UR|InitialMint foundation foundation-guard)
            ;;4]Initialise URSTOA-Vault
            (XM_InitialiseUrStoaVault foundation)
        )
    )
    ;;{F6}  [C]
    (defun C_CreateAccount:string (account:string guard:guard)
        (create-account account guard)
    )
    (defun C_RotateAccount:string (account:string new-guard:guard)
        (rotate account new-guard)
    )
    (defun C_Transfer:string (sender:string receiver:string amount:decimal)
        (transfer sender receiver amount)
    )
    (defun C_TransferAnew:string (sender:string receiver:string receiver-guard:guard amount:decimal)
        (transfer-create sender receiver receiver-guard amount)
    )
    (defun C_TransferAcross:string 
        (sender:string receiver:string receiver-guard:guard target-chain:string amount:decimal)
        (transfer-crosschain sender receiver receiver-guard target-chain amount)
    )
    (defun C_Transmit:string (sender:string receiver:string amount:decimal)
        (with-capability (TRANSMIT sender receiver amount)
            (debit sender amount)
            (credit receiver (UR_Guard receiver) amount)
        )
    )
    (defun C_TransmitAnew:string (sender:string receiver:string receiver-guard:guard amount:decimal)
        (with-capability (TRANSMIT sender receiver amount)
            (debit sender amount)
            (credit receiver receiver-guard amount)
        )
    )
    ;;
    (defun create-account:string (account:string guard:guard)
        @doc "<ORIGINAL> - <C_CreateAccount>: Creates a new Stoa Account"
        (UEV_Account account)
        (UEV_Reserved account guard)
        (insert coin-table account
            (UDC_AccountData 0.0 guard)
        )
    )
    (defun rotate:string (account:string new-guard:guard)
        @doc "<ORIGINAL> - <C_RotateAccount>: Rotates the guard of an existing Stoa Account"
        (with-capability (ROTATE account)
            (UEV_Rotate account new-guard)
            (update coin-table account
                { "guard" : new-guard }
            )
        )
    )
    (defun transfer:string (sender:string receiver:string amount:decimal)
        @doc "<ORIGINAL> - <C_Transfer>: Transfers <amount> from <sender> to <receiver>"
        (with-capability (TRANSFER sender receiver amount)
            (debit sender amount)
            (credit receiver (UR_Guard receiver) amount)
        )
    )
    (defun transfer-create:string (sender:string receiver:string receiver-guard:guard amount:decimal)
        @doc "<ORIGINAL> - <C_TransferAnew>: Transfers <amount> from <sender> to <receiver> \
            \ when <receiver> doesnt exist; It is being created with the <receiver-guard>"
        (with-capability (TRANSFER sender receiver amount)
            (debit sender amount)
            (credit receiver receiver-guard amount)
        )
    )
    (defpact transfer-crosschain:string 
        (sender:string receiver:string receiver-guard:guard target-chain:string amount:decimal)
        (step
            (with-capability (TRANSFER_XCHAIN sender receiver amount target-chain)
                (emit-event (TRANSFER sender "" amount))
                (debit sender amount)
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
                (emit-event (TRANSFER_XCHAIN_RECD "" receiver amount source-chain))
                (with-capability (CREDIT receiver)
                    (credit receiver receiver-guard amount)
                )
                (with-capability (UPDATE-LOCAL-SUPPLY)
                    (X_UpdateLocalSupply amount true)
                )
            )
        )
    )
    ;;{F7}  [X]
    ;;
    (defun XM_InitialMint:string (account:string guard:guard)
        @doc "Genesis-only mint for GENESIS STOA supply - unlocked immediately to foundation account"
        (require-capability (GENESIS))
        (UEV_Account account)
        (let
            (
                (amount:decimal GENESIS-SUPPLY)
            )
            (UEV_CoinPrecision amount)
            (emit-event (TRANSFER "" account amount))
            (with-capability (CREDIT account)
                (credit account guard amount)
            )
            (with-capability (UPDATE-LOCAL-SUPPLY)
                (X_UpdateLocalSupply amount true)
            )
            (format "{} STOA succesfully minted to {} as Genesis Supply" [amount account])
        )
    )
    (defun X_UpdateLocalSupply (amount:decimal direction:bool)
        (require-capability (UPDATE-LOCAL-SUPPLY))
        (UEV_CoinPrecision amount)
        (let
            (
                (current-supply:decimal (UR_LocalCoinSupply))
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
    (defun debit:string (account:string amount:decimal)
        @doc "<ORIGINAL> - Debits <amount> from <account> balance"
        (UEV_Account account)
        (UEV_Amount amount "Debit Amount must be positive")
        (UEV_CoinPrecision amount)
        (UEV_SufficientBalance account amount)
        (require-capability (DEBIT account))
        (with-read coin-table account
            {"balance" := balance}
            (update coin-table account
                {"balance" : (- balance amount)}
            )
        )
    )
    (defun credit:string (account:string guard:guard amount:decimal)
        @doc "<ORIGINAL> - Credits <amount> to <account> balance"
        (UEV_Account account)
        (UEV_Amount amount "Credit Amount must be positive")
        (UEV_CoinPrecision amount)
        (require-capability (CREDIT account))
        (with-default-read coin-table account
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
                (write coin-table account
                    (UDC_AccountData (if is-new amount (+ balance amount)) retg)
                )
            )
        )
    )
    ;;
    (defpact fund-tx (sender:string miner:string miner-guard:guard total:decimal)
        @doc "<ORIGINAL> - [MAGIC] Funds a transaction in two steps, \
            \ with the actual transaction transpiring in the middle \
            \ \ 
            \ 1] A buying phase, debiting the sender for total gas and fee, yielding TX_MAX_CHARGE \
            \ 2] A settlement phase, resuming TX_MAX_CHARGE, \
            \    and allocating to the coinbase account for used gas and fee \
            \    and sender account for balance (unused gas, if any)"
        (step (buy-gas sender total))
        (step (redeem-gas miner miner-guard sender total))
    )
    (defun buy-gas:string (sender:string total:decimal)
        @doc "<ORIGINAL> - [MAGIC] Describes the main [gas-buy] operation \
            \ At this point Miner has been chosen from the pool, and will be validated \
            \ <sender> of the transaction has specified a Gas limit (max gas) for the tx, \
            \ with the price being the spot price of gas at that time \
            \ The [gas-buy] will be executed prior to executing <sender> code"
        (require-capability (GAS))
        (UEV_Amount total "Gas Supply must be positive")
        (UEV_Account sender)
        (UEV_CoinPrecision total)
        (with-capability (DEBIT sender)
            (debit sender total)
        )
    )
    (defun redeem-gas:string (miner:string miner-guard:guard sender:string total:decimal)
        @doc "<ORIGINAL> - [MAGIC] Describes the main [gas-redeem] operation \
            \ At this point, the <sender> tx has been executed, \
            \ and the gas that was charged has been calculated. \
            \ <miner> will be credited the gas cost, \
            \ and <sender> will receive the remainder up to the limit"
        (require-capability (GAS))
        (UEV_Account sender)
        (UEV_Account miner)
        (UEV_CoinPrecision total)
        (let
            (
                (fee (read-decimal "fee"))
                (refund (- total fee))
            )
            (UEV_CoinPrecision fee)
            (UEV_MngAmount fee "Fee must be a non-negative quantity")
            (UEV_MngAmount refund "Refund must be a non-negative quantity")
            (emit-event (TRANSFER sender miner fee))
            (with-capability (CREDIT sender)
                ;; Update Directly instead of credit
                (if (> refund 0.0)
                    (update coin-table sender
                        {"balance" : (+ (UR_Balance sender) refund)}
                    )
                    "noop"
                )
            )
            (with-capability (CREDIT miner)
                (if (> fee 0.0)
                    (credit miner miner-guard fee)
                    "noop"
                )
            )
        )
    )
    (defun coinbase:string (account:string account-guard:guard amount:decimal)
        @doc "<ORIGINAL> - [MAGIC] Internal Function for the creation of coins \
            \ Cannot be used outside of <coin> contract \
            \ <amount> is discarded, and proper amount are computed within. \
            \ <amount is kept for csv read compatibility> \
            \ \
            \ Mints 90% of emissions split on everz chain \
            \ Mints and injects 10% of emissions on Chain 0 in the UrStoa Vault \
            \ \ 
            \ The proper amounts are computed via <URC_Emissions>"
        (require-capability (COINBASE))
        (UEV_Account account)
        (let
            (
                (chain-id:string (at "chain-id" (chain-data)))
                (emissions:[decimal] (URC_Emissions))
                (block-emission:decimal (at 0 emissions))
                (urv-emission:decimal (at 1 emissions))
            )
            (if (= chain-id "0")
                ;;Chain 0, mint <block-emission> (90% of emission) and <urv-emission> to miner <account>
                ;;Inject <urv-emission> from Miner to UrstoaVault
                (let
                    (
                        (whole:decimal (+ block-emission urv-emission))
                    )
                    ;;1]Update Local Supply with the generated amount
                    (with-capability (UPDATE-LOCAL-SUPPLY)
                        (X_UpdateLocalSupply whole true)
                    )
                    ;;2]Mint the <whole> amount to miner <account>
                    (with-capability (CREDIT account)
                        (credit account account-guard whole)
                    )
                    ;;3]Miner <account> injects <urv-emission> to UrStoaVault
                    (C_URV|Inject account urv-emission)
                    ;;4]Return the proper output string
                    (format
                        "Miner {} succesfully mined {} STOA, and injected an additional {} STOA to the UrStoa Vault"
                        [account block-emission urv-emission]
                    )
                )
                ;;Chain non-0, mint <block-emission> (90% of emission) to miner <account>
                (do
                    ;;1]Update Local Supply with the generated amount
                    (with-capability (UPDATE-LOCAL-SUPPLY)
                        (X_UpdateLocalSupply block-emission true)
                    )
                    ;;2]Miner <account> gets its <block-emission>
                    (with-capability (CREDIT account)
                        (credit account account-guard block-emission)
                    )
                    ;;4]Return the proper output string
                    (format
                        "Miner {} succesfully mined {} STOA on Chain {}"
                        [account block-emission chain-id]
                    )
                )
            )
        )
    )
    (defun remediate:string (account:string amount:decimal)
        @doc "<ORIGINAL> - [MAGIC] Allows for remediation transactions \
            \ Protected by the [REMEDIATE] capability \
            \ <remediate> decreases balance of <account> by <amount>"
        (require-capability (REMEDIATE))
        (let
            (
                (account-balance:decimal (UR_Balance account))
                (remediated-balance:decimal (- account-balance amount))
            )
            (UEV_Account account)
            (UEV_Amount amount "Remediation amount must be positive")
            (UEV_CoinPrecision amount)
            (UEV_SufficientBalance account amount)
            (emit-event (TRANSFER "" account amount))
            (update coin-table account
                {"balance" : remediated-balance}
            )
            (with-capability (UPDATE-LOCAL-SUPPLY)
                (X_UpdateLocalSupply amount false)
            )
            (format "Remediated {} STOA on Account {}" [amount account])
        )
    )
    ;;
    ;;Appendiges - Coin Allocations. Functions kept for backward Compatibility
    ;;STOA does not use allocation
    (defun create-allocation-account (account:string date:time keyset-ref:string amount:decimal)
        (format "{} does not use coin allocations" ["STOA"])
    )
    (defun release-allocation (account:string)
        (format "{} does not use coin allocations" ["STOA"])
    )
    ;;<======================>
    ;;
    ;;
    ;;  [UR-STOA SubModule]
    ;;<======================>
    (defun UR_UR|StoaDocumentation ()
        @doc "The UR-STOA Token is the means by which 10% of Yang Supply is distributed, \
        \ acting as a perpetual Virtual Miner for STOA Currency. \
        \ Total and Final Supply minted at Genesis, 1.000.000 UR-STOA \
        \ UR-STOA resides only on ChainID 0, can only be used here to earn STOA; \
        \ Since there is no point in using it on other ChainIDs, its usage is restricted on Chain 0 \
        \ \
        \ Distribution is executed by Staking URSTOA in the URSTOA-Vault, using a RPS Mechanic \
        \ Only on ChainID 0"
        true
    )
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    ;;{2}
    (deftable UR|StoaTable:{coin-schema})
    (deftable UR|LocalSupply:{StoaFungibleV2.LocalSupplySchema})
    ;;{3}
    (defconst URSTOA_PREC               3)
    (defconst URGENESIS-SUPPLY          1000000.0)
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap UR|ROTATE:bool (account:string new-guard:guard)
        @doc "Manages Guard Rotation for UrStoa Accounts"
        @event
        (CAP_UR|Account account)
        (UEV_PureRotate account new-guard)
    )
    ;;{C2}
    (defcap UR|DEBIT (sender:string amount:decimal)
        @doc "Manages debit operations"
        (enforce-guard (UR_UR|Guard sender))
        (enforce (!= sender "") "Invalid Sender")
        (UEV_UR|SufficientBalance sender amount)
    )
    (defcap UR|CREDIT (receiver:string)
        @doc "Manages credit operations"
        (enforce (!= receiver "") "Invalid Receiver")
    )
    ;;{C3}
    ;;{C4}
    (defcap UR|TRANSFER:bool (sender:string receiver:string amount:decimal)
        @event
        (let
            (
                (urv-konto:string URV|KONTO)
            )
            (enforce 
                (!= receiver urv-konto) 
                "UrStoa cannot be transferred to the UrStoaVault, it cannot only be staked into it!"
            )
            (UEV_Account sender)
            (UEV_Account receiver)
            (UEV_SenderWithReceiver sender receiver)
            (UEV_Amount amount "Transfer requires a positive amount")
            (UEV_UR|StoaPrecision amount)
            (compose-capability (UR|DEBIT sender amount))
            (compose-capability (UR|CREDIT receiver))
            (compose-capability (SECURE))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_UR|Details:object{fungible-v2.account-details} (account:string)
        (UEV_ChainZero)
        (with-read UR|StoaTable account
            {"balance"  := bal
            ,"guard"    := g}
            (UDC_AccountDetails account bal g)
        )
    )
    (defun UR_UR|Balance:decimal (account:string)
        (UEV_ChainZero)
        (at "balance" (read UR|StoaTable account ["balance"]))
    )
    (defun UR_UR|Guard:guard (account:string)
        (UEV_ChainZero)
        (at "guard" (read UR|StoaTable account ["guard"]))
    )
    (defun UR_UR|LocalStoaSupply:decimal ()
        (UEV_ChainZero)
        (with-default-read UR|LocalSupply CSK
            {"local-circulating": 0.0}
            {"local-circulating" := supply}
            supply
        )
    )
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_UR|SufficientBalance (account:string amount:decimal)
        @doc "Enforces that UrStoa <amount> is sufficient for <account> for debiting operations"
        (let
            (
                (account-balance:decimal (UR_UR|Balance account))
            )
            (enforce 
                (<= amount account-balance)
                (format "The UrStoa amount of {} is to great to debit from Account {}" [amount account])
            )
        )
    )
    (defun UEV_ChainZero ()
        (let
            (
                (chain-id:string (at "chain-id" (chain-data)))
            )
            (enforce (= chain-id "0") "UR-STOA Operations are restricted to ChainId 0")
        )
    )
    (defun UEV_UR|StoaPrecision:bool (amount:decimal)
        @doc "Enforces UrStoa Coin Precision"
        (enforce
            (=
                (floor amount URSTOA_PREC)
                amount
            )
            (format "Amount {} violates UrStoa Precision of {}" [amount STOA_PREC])
        )
    )
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    (defun CAP_UR|Account (account:string)
        (enforce-guard (UR_UR|Guard account))
    )
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_UR|CreateAccount:string (account:string guard:guard)
        (UEV_ChainZero)
        (UEV_Account account)
        (UEV_Reserved account guard)
        (insert UR|StoaTable account
            (UDC_AccountData 0.0 guard)
        )
    )
    (defun C_UR|RotateAccount:string (account:string new-guard:guard)
        (with-capability (UR|ROTATE account new-guard)
            (update UR|StoaTable account
                {"guard" : new-guard}
            )
        )
    )
    (defun C_UR|Transfer:string (sender:string receiver:string amount:decimal)
        (with-capability (UR|TRANSFER sender receiver amount)
            (X_UR|Transfer sender receiver (UR_UR|Guard receiver) amount)
        )
    )
    (defun C_UR|TransferAnew:string (sender:string receiver:string receiver-guard:guard amount:decimal)
        (with-capability (UR|TRANSFER sender receiver amount)
            (X_UR|Transfer sender receiver receiver-guard amount)
        )
    )
    ;;{F7}  [X]  - Auxiliary Functions with protection
    ;;      [XM] - Protected by Magic Capabilities (Node Runtime)
    (defun X_UR|Transfer:string (sender:string receiver:string receiver-guard:guard amount:decimal)
        (require-capability (SECURE))
        (X_UR|Debit sender amount)
        (X_UR|Credit receiver receiver-guard amount)
    )
    (defun X_UR|Credit:string (account:string guard:guard amount:decimal)
        @doc "Credits UrStoa <amount> to <account> balance"
        (UEV_Account account)
        (UEV_Amount amount "Credit Amount must be positive")
        (UEV_UR|StoaPrecision amount)
        (require-capability (UR|CREDIT account))
        (with-default-read UR|StoaTable account
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
                (write UR|StoaTable account
                    (UDC_AccountData (if is-new amount (+ balance amount)) retg)
                )
            )
        )
    )
    (defun X_UR|Debit:string (account:string amount:decimal)
        @doc "Debits <amount> from <account> balance"
        (UEV_Account account)
        (UEV_Amount amount "Debit Amount must be positive")
        (UEV_UR|StoaPrecision amount)
        (require-capability (UR|DEBIT account amount))
        (with-read UR|StoaTable account
            {"balance" := balance}
            (update UR|StoaTable account
                {"balance" : (- balance amount)}
            )
        )
    )
    (defun X_UR|UpdateLocalSupply (amount:decimal direction:bool)
        (require-capability (UPDATE-LOCAL-SUPPLY))
        (UEV_UR|StoaPrecision amount)
        (let
            (
                (current-supply:decimal (UR_UR|LocalStoaSupply))
                (updated-supply:decimal
                    (if direction
                        (+ current-supply amount)
                        (- current-supply amount)
                    )
                )
            )
            (write UR|LocalSupply CSK
                {"local-circulating" : updated-supply}
            )
        )
    )
    ;;
    (defun XM_UR|InitialMint:string (account:string guard:guard)
        @doc "Genesis-only mint for initial 1M URSTOA supply - Chain 0 only. \
            \ On other chains, this is a no-op (required because genesis runs on all chains)."
        (require-capability (GENESIS))
        (let
            (
                (chain-id:string (at "chain-id" (chain-data)))
            )
            ;; Only mint on Chain 0, no-op on other chains
            ;; 1 URSTOA is generated directly inside the vault for the <foundation-account>
            (if (= chain-id "0")
                (let
                    (
                        (amount:decimal (- URGENESIS-SUPPLY 1.0))
                    )
                    (UEV_Account account)
                    (UEV_UR|StoaPrecision amount)
                    (emit-event (UR|TRANSFER "" account amount))
                    (with-capability (UR|CREDIT account)
                        (X_UR|Credit account guard amount)
                    )
                    (with-capability (UPDATE-LOCAL-SUPPLY)
                        (X_UR|UpdateLocalSupply amount true)
                    )
                    "Initial 1M URSTOA minted to foundation at Genesis"
                )
                "UrStoa mint skipped - not Chain 0"
            )
        )
    )
    ;;
    ;;  [UR-STOA-VAULT Submodule]
    ;;<======================>
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst URV|KONTO                                         (GOV|URV|KONTO))
    ;;{G2}
    (defcap URV|NATIVE-AUTOMATIC ()
        @doc "Autonomic management of <stoa-account> of the URSTOA-Vault"
        true
    )
    ;;{G3}
    (defun GOV|URV|KONTO ()                                     (create-principal (GOV|URV|GUARD)))
    (defun GOV|URV|GUARD ()                                     (create-capability-guard (URV|NATIVE-AUTOMATIC)))
    ;;
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    (defschema UrStoaVaultSchema
        urstoa-supply:decimal                                   ;;Stores the total URSTOA held in Vault
                                                                ;;Functions as Global Score
        stoa-supply:decimal                                     ;;Stores the total STOA held in Vault as claimable Rewards
        nzs-count:integer                                       ;;Stores the number of users with <Non-Zero-Score>
        current-rps:decimal                                     ;;Stores current RPS decimal
        unclaimed-count:integer                                 ;;Stores the total number of Users with unclaimed Rewards        
    )
    (defschema UrStoaUserSchema
        user-supply:decimal                                     ;;Stores the URSTOA amount held in Vault by <account>
                                                                ;;Functions as the Users Score
        last-rps:decimal                                        ;;Value of the Users Last RPS
        pending-rewards:decimal                                 ;;Amount of Stoa <User> is eligible to Collect
    )
    ;;{2}
    (deftable URV|UrStoaVault:{UrStoaVaultSchema})              ;;Key = <USV> (single entry)
    (deftable URV|UrStoaVaultUser:{UrStoaUserSchema})           ;;Key = <account>
    ;;{3}
    (defconst USV   "UR-Stoa-Vault-Key")
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
    (defun UR_URV|VaultUrSupply:decimal ()
        (UEV_ChainZero)
        (at "urstoa-supply" (read URV|UrStoaVault USV ["urstoa-supply"]))
    )
    (defun UR_URV|VaultSupply:decimal ()
        (UEV_ChainZero)
        (at "stoa-supply" (read URV|UrStoaVault USV ["stoa-supply"]))
    )
    (defun UR_URV|VaultNZS:integer ()
        (UEV_ChainZero)
        (at "nzs-count" (read URV|UrStoaVault USV ["nzs-count"]))
    )
    (defun UR_URV|VaultRPS:decimal ()
        (UEV_ChainZero)
        (at "current-rps" (read URV|UrStoaVault USV ["current-rps"]))
    )
    (defun UR_URV|VaultUnclaimedCount:integer ()
        (UEV_ChainZero)
        (at "unclaimed-count" (read URV|UrStoaVault USV ["unclaimed-count"]))
    )
    ;;
    (defun UR_URV|UserSupply:decimal (account:string)
        (UEV_ChainZero)
        (with-default-read URV|UrStoaVaultUser account
            {"user-supply" : 0.0}
            {"user-supply" := us}
            us
        )
    )
    (defun UR_URV|UserLastRps:decimal (account:string)
        (UEV_ChainZero)
        (let
            (
                (current-rps:decimal (UR_URV|VaultRPS))
            )
            (with-default-read URV|UrStoaVaultUser account
                {"last-rps" : current-rps}
                {"last-rps" := l-rps}
                l-rps
            )
        )
    )
    (defun UR_URV|UserPendingRewards:decimal (account:string)
        (UEV_ChainZero)
        (with-default-read URV|UrStoaVaultUser account
            {"pending-rewards" : 0.0}
            {"pending-rewards" := pr}
            pr
        )
    )
    (defun UR_URV|IzAccount:bool (account:string)
        (let
            (
                (trial (try false (read URV|UrStoaVaultUser account)))
            )
            (if (= (typeof trial) "bool") false true)
        )
    )
    ;;{F1}  [URC]
    (defun URC_AvailableRewards (account:string)
        (let
            (
                (current-pending-rewards:decimal (UR_URV|UserPendingRewards account))
                (current-score:decimal (UR_URV|UserSupply account))
                (last-rps:decimal (UR_URV|UserLastRps account))
                (current-rps:decimal (UR_URV|VaultRPS))
                ;;
                (diff-rps:decimal (- current-rps last-rps))
                (gained-pending-rewards:decimal (floor (* current-score diff-rps) STOA_PREC))
            )
            (+ current-pending-rewards gained-pending-rewards)
        )
    )
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    (defun UDC_URV|UserData:object{UrStoaUserSchema}
        (a:decimal b:decimal c:decimal)
        {"user-supply"      : a
        ,"last-rps"         : b
        ,"pending-rewards"  : c}
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defcap URV|INJECT ()
        @event
        (let
            (
                (vault-score:decimal (UR_URV|VaultUrSupply))
            )
            (enforce (> vault-score 0.0) "URSTOA-Vault Score must be greater than 0.0 for injection")
            (compose-capability (SECURE))
        )
    )
    (defcap URV|STAKE (account:string amount:decimal)
        @event
        (compose-capability (UR|DEBIT account amount))
        (compose-capability (UR|CREDIT URV|KONTO))
        (compose-capability (SECURE))
    )
    (defcap URV|UNSTAKE (account:string amount:decimal)
        @event
        (let
            (
                (vault-score:decimal (UR_URV|VaultUrSupply))
                (user-score:decimal (UR_URV|UserSupply account))
                (remaining:decimal (- user-score amount))
                (vault-remaining:decimal (- vault-score amount))
            )
            (enforce (>= remaining 0.0) (format "Account {} Vault Balance exceded by {}" [account (abs remaining)]))
            (enforce (>= vault-remaining 1.0) "At least 1.0 URSTOA must remain in the URSTOA-Vault")
            (CAP_UR|Account account)
            (compose-capability (URV|NATIVE-AUTOMATIC))
            (compose-capability (UR|DEBIT URV|KONTO amount))
            (compose-capability (UR|CREDIT account))
            (compose-capability (SECURE))
        )
    )
    (defcap URV|COLLECT (account:string)
        @event
        (CAP_Account account)
        (compose-capability (URV|NATIVE-AUTOMATIC))
        (compose-capability (SECURE))
    )
    ;;
    ;;
    (defun C_URV|Inject:string (account:string stoa-amount:decimal)
        @doc "Injects STOA <amount> into the URSTOA-Vault"
        (with-capability (URV|INJECT)
            (let
                (
                    (vault-score:decimal (UR_URV|VaultUrSupply))
                    (gained-rps:decimal (floor (/ stoa-amount vault-score) STOA_PREC))
                    (current-rps:decimal (UR_URV|VaultRPS))
                    (new-rps:decimal (+ current-rps gained-rps))
                )
                ;;0]Move Stoa from Account to the URSTOA-Vault using Unmanaged Transfer via Transmit
                (C_Transmit account URV|KONTO stoa-amount)
                ;;1]Update Vault <current-rps> with new value gained from injecting <stoa-amount>
                (XI_URV|UpdateVaultRPS new-rps)
                ;;2]Update Vault <stoa-supply> with <stoa-amount>
                (XI_URV|UpdateVaultSupply stoa-amount true)
                ;;3]Reset <unclaimed-count> (set it to <nzs-count>)
                (XI_URV|ResetUnclaimedCount)
                ;;4]Returns Output Text
                (format "Succesfully injected {} STOA to UrStoaVault" [stoa-amount])
            )
        )
    )
    (defun C_URV|Stake:string (account:string urstoa-amount:decimal)
        @doc "Stakes URSTOA in the URSTOA-Vault in order to earn 10% of Yang Emissions"
        (with-capability (URV|STAKE account urstoa-amount)
            (let
                (
                    (user-score:decimal (UR_URV|UserSupply account))
                )
                ;;1]Move URSTOA from user to the Vault
                (X_UR|Transfer account URV|KONTO (GOV|URV|GUARD) urstoa-amount)
                ;;2.1]Update Pending Rewards
                (if (not (UR_URV|IzAccount account))
                    (insert URV|UrStoaVaultUser account
                        (UDC_URV|UserData 0.0 (UR_URV|VaultRPS) 0.0)
                    )
                    true
                )
                (XI_URV|UpdatePendingRewards account)
                ;;2.2]Update Vault and User Scores
                (XI_URV|UpdateVaultScore urstoa-amount true)
                (XI_URV|UpdateUserScore account urstoa-amount true)
                ;;2.3]If initial <user-score> was 0, increment <nzs-count>
                (if (= user-score 0.0)
                    (XI_URV|UpdateNZS true)
                    true
                )
                ;;2.4]Update <last-rps> with the Vaults <current-rps>
                (XI_URV|UpdateUserRPS account (UR_URV|VaultRPS))
                ;;3]Returns Output Text
                (format "Succesfully staked {} UrStoa to UrStoaVault" [urstoa-amount])
            )
        )
    )
    (defun C_URV|Unstake:string (account:string urstoa-amount:decimal)
        @doc "Unstakes URSTOA from the URSTOA-Vault; \
            \ Unstaking revokes STOA earnings from the 10% of the YANG Emissions"
        (with-capability (URV|UNSTAKE account urstoa-amount)
            (let
                (
                    (user-score:decimal (UR_URV|UserSupply account))
                    (remaining:decimal (- user-score urstoa-amount))
                )
                ;;1]Move URSTOA from Vault to the user
                (X_UR|Transfer URV|KONTO account (UR_UR|Guard account) urstoa-amount)
                ;;2.1]Update Pending Rewards
                (XI_URV|UpdatePendingRewards account)
                ;;2.2]Update Vault and User Scores
                (XI_URV|UpdateVaultScore urstoa-amount false)
                (XI_URV|UpdateUserScore account urstoa-amount false)
                ;;2.3]If remaining <user-score> becomes 0, decrement <nzs-count>
                (if (= remaining 0.0)
                    (XI_URV|UpdateNZS false)
                    true
                )
                ;;2.4]Update <last-rps> with the Vaults <current-rps>
                (XI_URV|UpdateUserRPS account (UR_URV|VaultRPS))
                ;;3]Returns Output Text
                (format "Succesfully unstaked {} UrStoa from UrStoaVault" [urstoa-amount])
            )
        )
    )
    (defun C_URV|Collect:string (account:string)
        @doc "Collects ALL earnings generated by URSTOA Staking in the URSTOA-Vault"
        (with-capability (URV|COLLECT account)
            (let
                (
                    (available-rewards:decimal (URC_URV|ClaimableRewards account))
                )
                ;;1]Collect STOA Rewards
                (C_Transmit URV|KONTO account available-rewards)
                ;;2]Resets <pending-rewards> to 0
                (XI_URV|ResetPendingRewards account)
                ;;3]Decrement <unclaimed-count>
                (XI_URV|UpdateUnclaimedCount false)
                ;;4]Update <last-rps> with the Vaults <current-rps>
                (XI_URV|UpdateUserRPS account (UR_URV|VaultRPS))
                ;;5]Update Vault Supply
                (XI_URV|UpdateVaultSupply available-rewards false)
                ;;6]Returns Output Text
                (format "Account {} succesfully collected {} STOA from the UrStoaVault" [account available-rewards])
            )
        )
    )
    (defun URC_URV|ClaimableRewards:decimal (account:string)
        @doc "Computes Claimable Reward of Account"
        (if (= (UR_URV|VaultUnclaimedCount) 1)
            (UR_URV|VaultSupply)
            (URC_AvailableRewards account)
        )
    )
    ;;{F7}  [X]
    ;;
    (defun XM_InitialiseUrStoaVault (foundation-account:string)
        (require-capability (GENESIS))
        (let
            (
                (vault-account:string (GOV|URV|KONTO))
                (vault-guard:guard (GOV|URV|GUARD))
            )
            (C_CreateAccount vault-account vault-guard)
            (C_UR|CreateAccount vault-account vault-guard)
            (insert URV|UrStoaVault USV
                {"urstoa-supply"    : 1.0
                ,"stoa-supply"      : 0.0
                ,"nzs-count"        : 1
                ,"current-rps"      : 0.0
                ,"unclaimed-count"  : 0}
            )
            (insert URV|UrStoaVaultUser foundation-account
                {"user-supply"      : 1.0
                ,"last-rps"         : 0.0
                ,"pending-rewards"  : 0.0}
            )
            (with-capability (UR|CREDIT vault-account)
                (X_UR|Credit vault-account vault-guard 1.0)
            )
            (with-capability (UPDATE-LOCAL-SUPPLY)
                (X_UR|UpdateLocalSupply 1.0 true)
            )
        )
    )
    ;;
    (defun XI_URV|UpdateVaultScore (amount:decimal direction:bool)
        (require-capability (SECURE))
        (let
            (
                (vault-score:decimal (UR_URV|VaultUrSupply))
                (new-vault-score:decimal
                    (if direction
                        (+ vault-score amount)
                        (- vault-score amount)
                    )
                )
            )
            (update URV|UrStoaVault USV
                {"urstoa-supply" : new-vault-score}
            )
        )
    )
    (defun XI_URV|UpdateVaultSupply (amount:decimal direction:bool)
        (require-capability (SECURE))
        (let
            (
                (vault-supply:decimal (UR_URV|VaultSupply))
                (new-vault-supply:decimal
                    (if direction
                        (+ vault-supply amount)
                        (- vault-supply amount)
                    )
                )
            )
            (update URV|UrStoaVault USV
                {"stoa-supply" : new-vault-supply}
            )
        )
    )
    (defun XI_URV|UpdateNZS (direction:bool)
        (require-capability (SECURE))
        (let
            (
                (nzs:integer (UR_URV|VaultNZS))
                (new-nzs:integer
                    (if direction
                        (+ nzs 1)
                        (- nzs 1)
                    )
                )
            )
            (update URV|UrStoaVault USV
                {"nzs-count" : new-nzs}
            )
        )
    )
    (defun XI_URV|UpdateVaultRPS (new-rps:decimal)
        (require-capability (SECURE))
        (update URV|UrStoaVault USV
            {"current-rps" : new-rps}
        )
    )
    (defun XI_URV|UpdateUnclaimedCount (direction:bool)
        (require-capability (SECURE))
        (let
            (
                (uc:integer (UR_URV|VaultUnclaimedCount))
                (new-uc:integer
                    (if direction
                        (+ uc 1)
                        (- uc 1)
                    )
                )
            )
            (update URV|UrStoaVault USV
                {"unclaimed-count" : new-uc}
            )
        )
    )
    (defun XI_URV|ResetUnclaimedCount ()
        (require-capability (SECURE))
        (update URV|UrStoaVault USV
            {"unclaimed-count" : (UR_URV|VaultNZS)}
        )
    )
    ;;
    (defun XI_URV|UpdateUserScore (account:string amount:decimal direction:bool)
        (require-capability (SECURE))
        (let
            (
                (user-score:decimal (UR_URV|UserSupply account))
                (new-user-score:decimal
                    (if direction
                        (+ user-score amount)
                        (- user-score amount)
                    )
                )
            )
            (update URV|UrStoaVaultUser account
                {"user-supply" : new-user-score}
            )
        )
    )
    (defun XI_URV|UpdateUserRPS (account:string new-rps:decimal)
        (require-capability (SECURE))
        (update URV|UrStoaVaultUser account
            {"last-rps" : new-rps}
        )
    )
    (defun XI_URV|UpdatePendingRewards (account:string)
        (require-capability (SECURE))
        (update URV|UrStoaVaultUser account
            {"pending-rewards" : (URC_AvailableRewards account)}
        )
    )
    (defun XI_URV|ResetPendingRewards (account:string)
        (require-capability (SECURE))
        (update URV|UrStoaVaultUser account
            {"pending-rewards" : 0.0}
        )
    )
    ;;
)

(create-table coin-table)           ;;Stores Stoa <balance> and <guard>
(create-table LocalSupply)          ;;Stores Stoa <local-circulating>

(create-table UR|StoaTable)         ;;Stores UrStoa <balance> and <guard>
(create-table UR|LocalSupply)       ;;Stores UrStoa <local-circulating>

(create-table URV|UrStoaVault)      ;;Stores UrStoaVault Data
(create-table URV|UrStoaVaultUser)  ;;Stores UrStoaVault User Data