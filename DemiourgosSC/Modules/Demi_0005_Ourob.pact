(module OUROBOROS GOVERNANCE
    @doc "Demiourgos 0005 Module - OUROB (Ouroboros Module) \
    \ Module 5 contains initialisation functions, and usage functions that can be executed, \
    \ after all other functions are defined in the previous module \
    \ \
    \ \
    \ Smart DALOS Accounts governed by the Module (1) \
    \ \
    \ 1)Ouroboros Smart Account"

    ;;Module Governance
    (defcap GOVERNANCE ()
        (compose-capability (OUROBOROS-ADMIN))
    )
    (defcap OUROBOROS-ADMIN ()
        (enforce-guard G_OUROBOROS)
    )
    ;;Module Guard
    (defconst G_OUROBOROS (keyset-ref-guard OUROBOROS|DEMIURGOI))
    ;;Module Keys
    (defconst OUROBOROS|DEMIURGOI "free.DH_Master-Keyset")
    ;;Module Accounts Information
        ;;[O] Ouroboros Account ids for Ouroboros Submodule
    (defconst OUROBOROS|SC_KEY "free.DH_SC_Ouroboros-Keyset")
    (defconst OUROBOROS|SC_NAME DALOS.OUROBOROS|SC_NAME)                                ;;Former Ouroboros
    (defconst OUROBOROS|SC_KDA-NAME (create-principal OUROBOROS|GUARD))
    ;(defconst OUROBOROS|SC_KDA-NAME "k:7c9cd45184af5f61b55178898e00404ec04f795e10fff14b1ea86f4c35ff3a1e")
    ;;External Module Usage
    (use free.UTILS)
    (use free.DALOS)
    (use free.BASIS)
    (use free.AUTOSTAKE)
    (use free.LIQUID)

    ;;
    ;;
    ;;


    ;;Simple True Capabilities (1)
    (defcap COMPOSE ()
        @doc "Capability used to compose multiple functions in an IF statement"
        true
    )
    (defcap DPTF|MULTI ()
        @doc "Capability needed for Multi and Bulk DPTF Transfers"
        true
    )
    (defcap DPTF|MULTI-PAIRED ()
        @doc "Capability needed for Multi-Paired Aux Function"
        true
    )
    (defcap DPTF|BULK-PAIRED ()
        @doc "Capability needed for Bulk-Paired Aux Function"
        true
    )
    ;; POLICY Capabilities
    (defcap P|ATS|REMOTE-GOV ()
        @doc "Policy allowing interaction with the Autostake Smart DALOS Account"
        true
    )
    (defcap P|ATS|UPDATE_ROU ()
        @doc "Policy allowing usage of <AUTOSTAKE.ATS|X_UpdateRoU>"
        true
    )

    ;;Policies - NONE
    (defun OUROBOROS|DefinePolicies ()
        @doc "Add the Policy that allows running external Functions from this Module"
        (AUTOSTAKE.ATS|A_AddPolicy     ;DALOS|DALOS
            "OUROBOROS|RemoteAutostakeGovernor"
            (create-capability-guard (P|ATS|REMOTE-GOV))                  ;;  Remote Interactions with AUTOSTAKE.ATS|SC-NAME
        )
        (AUTOSTAKE.ATS|A_AddPolicy     ;DALOS|DALOS
            "OUROBOROS|UpdateROU"
            (create-capability-guard (P|ATS|UPDATE_ROU))                  ;;  Remote Interactions with AUTOSTAKE.ATS|SC-NAME
        )
    )
    ;;Modules's Governor
    (defcap OUROBOROS|GOV ()
        @doc "Autostake Module Governor Capability for its Smart DALOS Account"
        true
    )
    (defun OUROBOROS|SetGovernor (patron:string)
        (DALOS.DALOS|C_RotateGovernor
            patron
            OUROBOROS|SC_NAME
            (create-capability-guard (OUROBOROS|GOV))
        )
    )
    (defcap OUROBOROS|NATIVE-AUTOMATIC ()
        @doc "Capability needed for auto management of the <kadena-konto> associated with the Ouroboros Smart DALOS Account"
        true
    )
    (defconst OUROBOROS|GUARD (create-capability-guard (OUROBOROS|NATIVE-AUTOMATIC)))
    ;;
    ;;
    ;; START
    ;;
    ;;
;;  1]CONSTANTS Definitions
    (defconst NULLTIME (time "1984-10-11T11:10:00Z"))
    (defconst ANTITIME (time "1983-08-07T11:10:00Z"))
;;  2]SCHEMAS Definitions
    ;;[T] DPTF Schemas
    (defschema DPTF|ID-Amount
        @doc "Schema for ID-Amount Pair, used in Multi DPTF Transfers"
        id:string
        amount:decimal
    )
    (defschema DPTF|Receiver-Amount
        @doc "Schema for Receiver-Amount Pair, used in Bulk DPTF Transfers"
        receiver:string
        amount:decimal
    )
    ;;[V] VST Schemas
    (defschema VST|MetaDataSchema
        release-amount:decimal
        release-date:time
    )


    ;;DALOS Initialisation Function
    
    ;;How to set Fee for a DPTF
    ;(DALOS.DPTF|C_SetFee patron OuroID 150.0)
    ;(DALOS.DPTF|C_ToggleFee patron OuroID true)
    ;(DALOS.DPTF|C_ToggleFeeLock patron OuroID true)
    ;;
    ;;            BASIS+AUTOSTAKE   Submodule
    ;;
    ;;            CAPABILITIES      <0>
    ;;            FUNCTIONS         [15]
    ;;========[D] RESTRICTIONS=================================================;;
    ;;            Capabilities FUNCTIONS                [CAP]
    ;;            Function Based CAPABILITIES           [CF](have this tag)
    ;;        [3] Enforcements & Validations FUNCTIONS  [UEV]
    ;;            Composed CAPABILITIES                 [CC](dont have this tag)
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;        [1] Data Read FUNCTIONS                   [UR]
    ;;        [1] Data Read and Computation FUNCTIONS   [URC] and [UC]
    ;;        [2] Data Creation|Composition FUNCTIONS   [UCC]
    ;;            Administrative Usage FUNCTIONS        [A]
    ;;        [4] Client Usage FUNCTIONS                [C]
    ;;        [4] Auxiliary Usage FUNCTIONS             [X]
    ;;=========================================================================;;
    ;;
    ;;            START
    ;;
    ;;========[D] RESTRICTIONS=================================================;;
    ;;     (NONE) Capabilities FUNCTIONS                [CAP]
    ;;     (NONE) Function Based CAPABILITIES           [CF](have this tag)
    ;;            Enforcements & Validations FUNCTIONS  [UEV]
    (defun DPTF-DPMF|UEV_AmountCheck:bool (id:string amount:decimal token-type:bool)
        @doc "Checks if the supplied amount is valid with the decimal denomination of the id \
        \ and if the amount is greater than zero. \
        \ Uses no enforcements, returns true if it checks, false if it doesnt"
        (let*
            (
                (decimals:integer (BASIS.DPTF-DPMF|UR_Decimals id token-type))
                (decimal-check:bool (if (= (floor amount decimals) amount) true false))
                (positivity-check:bool (if (> amount 0.0) true false))
                (result:bool (and decimal-check positivity-check))
            )
            result
        )
    )
    (defun DPTF|UEV_Pair_ID-Amount:bool (id-lst:[string] transfer-amount-lst:[decimal])
        @doc "Checks an ID-Amount Pair to be conform so that a Multi DPTF Transfer can properly take place"
        (fold
            (lambda
                (acc:bool item:object{DPTF|ID-Amount})
                (and acc (DPTF-DPMF|UEV_AmountCheck (at "id" item) (at "amount" item) true))
            )
            true
            (DPTF|UCC_Pair_ID-Amount id-lst transfer-amount-lst)
        )
    )
    (defun DPTF|UEV_Pair_Receiver-Amount:bool (id:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @doc "Checks an Receiver-Amount pair to be conform with a token id for Bulk Transfer purposes"
        (BASIS.DPTF-DPMF|UEV_id id true)
        (and
            (fold
                (lambda
                    (acc:bool item:object{DPTF|Receiver-Amount})
                    (let*
                        (
                            (receiver-account:string (at "receiver" item))
                            (receiver-check:bool (DALOS.GLYPH|UEV_DalosAccountCheck receiver-account))
                        )
                        (and acc receiver-check)
                    )
                )
                true
                (DPTF|UCC_Pair_Receiver-Amount receiver-lst transfer-amount-lst)
            )
            (fold
                (lambda
                    (acc:bool item:object{DPTF|Receiver-Amount})
                    (let*
                        (
                            (transfer-amount:decimal (at "amount" item))
                            (check:bool (DPTF-DPMF|UEV_AmountCheck id transfer-amount true))
                        )
                        (and acc check)
                    )
                )
                true
                (DPTF|UCC_Pair_Receiver-Amount receiver-lst transfer-amount-lst)
            )
        )
    )
    ;;        <1> Composed CAPABILITIES                 [CC](dont have this tag)
    (defcap ATS|KICKSTART (kickstarter:string atspair:string rt-amounts:[decimal] rbt-request-amount:decimal)
        @doc "Capability needed to perform a kickstart for an ATS-Pair"
        (let*
            (
                (index:decimal (ATS|UC_Index atspair))
                (rt-lst:[string] (AUTOSTAKE.ATS|UR_RewardTokenList atspair))
                (l1:integer (length rt-amounts))
                (l2:integer (length rt-lst))
                (owner:string (AUTOSTAKE.ATS|UR_OwnerKonto atspair))

            )
            (enforce (= index -1.0) "Kickstarting can only be done on ATS-Pairs with -1 Index")
            (enforce (= l1 l2) "RT-Amounts list does not correspond with the Number of the ATS-Pair Reward Tokens")
            (enforce (> rbt-request-amount 0.0) "RBT Request Amount must be greater than zero!")
            (DALOS.DALOS|CAP_EnforceAccountOwnership owner)
            (DALOS.DALOS|UEV_EnforceAccountType kickstarter false)
            (compose-capability (P|ATS|REMOTE-GOV))
            (compose-capability (P|ATS|UPDATE_ROU))
        )
    )
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;        [1] Data Read FUNCTIONS                   [UR]
    (defun DPTF-DPMF-ATS|UR_FilterKeysForInfo:[string] (account-or-token-id:string table-to-query:integer mode:bool)
        @doc "Returns a List of either: \
            \       Direct-Mode(true):      <account-or-token-id> is <account> Name: \
            \                               Returns True-Fungible, Meta-Fungible IDs or ATS-Pairs held by an Accounts <account> OR \
            \       Inverse-Mode(false):    <account-or-token-id> is DPTF|DPMF|ATS-Pair Designation Name \
            \                               Returns Accounts that exists for a specific True-Fungible, Meta-Fungible or ATS-Pair \
            \       MODE Boolean is only used for proper validation, to accees the needed table, use the proper integer: \
            \ Table-to-query: \
            \ 1 (DPTF|BalanceTable), 2(DPMF|BalanceTable), 3(ATS|Ledger) "

        ;;Enforces that only integer 1 2 3 can be used as input for the <table-to-query> variable.
        (UTILS.UTILS|UEV_PositionalVariable table-to-query 3 "Table To Query can only be 1 2 or 3")
        (if mode
            (with-capability (COMPOSE)
                (if (= table-to-query 1)
                    (BASIS.DPTF-DPMF|UEV_id account-or-token-id true)
                    (if (= table-to-query 2)
                        (BASIS.DPTF-DPMF|UEV_id account-or-token-id false)
                        (AUTOSTAKE.ATS|UEV_id account-or-token-id) 
                    )
                )
            )
        )
        (let*
            (
                (keyz:[string]
                    (if (= table-to-query 1)
                        (BASIS.DPTF|KEYS)
                        (if (= table-to-query 2)
                            (BASIS.DPMF|KEYS)
                            (AUTOSTAKE.ATS|KEYS)
                        )
                    )
                )
                (listoflists:[[string]] (map (lambda (x:string) (UTILS.LIST|UC_SplitString UTILS.BAR x)) keyz))
                (output:[string] (UTILS.DALOS|UC_Filterid listoflists account-or-token-id))
            )
            output
        )
    )
    ;;         [1] Data Read and Computation FUNCTIONS   [URC] and [UC]
    (defun ATS|UC_RT-Unbonding (atspair:string reward-token:string)
        @doc "Computes the Total Unbonding amount for a given <reward-token> of a given <atspair> \
        \ Result-wise identical to reading it via <DEMI_001.ATS|UR_RT-Data> option 3, except this is done by computation"
        (AUTOSTAKE.ATS|UEV_RewardTokenExistance atspair reward-token true)
        (fold
            (lambda
                (acc:decimal account:string)
                (+ acc (AUTOSTAKE.ATS|UC_AccountUnbondingBalance atspair account reward-token))
            )
            0.0
            (DPTF-DPMF-ATS|UR_FilterKeysForInfo atspair 3 false)
        )
    )
    ;;        [2] Data Creation|Composition FUNCTIONS   [UCC]
    (defun DPTF|UCC_Pair_ID-Amount:[object{DPTF|ID-Amount}] (id-lst:[string] transfer-amount-lst:[decimal])
        @doc "Creates an ID-Amount Pair (used in a Multi DPTF Transfer)"
        (let
            (
                (id-length:integer (length id-lst))
                (amount-length:integer (length transfer-amount-lst))
            )
            (enforce (= id-length amount-length) "ID and Transfer-Amount Lists are not of equal length")
            (zip (lambda (x:string y:decimal) { "id": x, "amount": y }) id-lst transfer-amount-lst)
        )
    )
    (defun DPTF|UCC_Pair_Receiver-Amount:[object{DPTF|Receiver-Amount}] (receiver-lst:[string] transfer-amount-lst:[decimal])
        @doc "Create a Receiver-Amount Pair (used in Bulk DPTF Transfer)"
        (let
            (
                (receiver-length:integer (length receiver-lst))
                (amount-length:integer (length transfer-amount-lst))
            )
            (enforce (= receiver-length amount-length) "Receiver and Transfer-Amount Lists are not of equal length")
            (zip (lambda (x:string y:decimal) { "receiver": x, "amount": y }) receiver-lst transfer-amount-lst)
        )
    )
    ;;     (NONE) Administrative Usage FUNCTIONS        [A]
    ;;        [9] Client Usage FUNCTIONS                [C]
    (defun ATS|C_KickStart (patron:string kickstarter:string atspair:string rt-amounts:[decimal] rbt-request-amount:decimal)
        @doc "Kickstarts <atspair> with a specific amount of Reward-Tokens, \
        \ while asking in retunr for a specific amount of Reward-Bearing-Tokens \
        \ thus efectively starting the <atspair> at a specific predefined Index"
        (with-capability (ATS|KICKSTART kickstarter atspair rt-amounts rbt-request-amount)
            (let
                (
                    (rbt-id:string (AUTOSTAKE.ATS|UR_ColdRewardBearingToken atspair))
                    (rt-lst:[string] (AUTOSTAKE.ATS|UR_RewardTokenList atspair))
                )
            ;;1]Kickstarter transfers the rt-amounts to the AUTOSTAKE.ATS|SC_NAME and updates the Resident Amounts
                (DPTF|CM_MultiTransfer patron rt-lst kickstarter AUTOSTAKE.ATS|SC_NAME rt-amounts)
                (map
                    (lambda
                        (rto:object{DPTF|ID-Amount})
                        (AUTOSTAKE.ATS|X_UpdateRoU atspair (at "id" rto) true true (at "amount" rto))
                    )
                    (zip (lambda (x:string y:decimal) { "id":x, "amount":y}) rt-lst rt-amounts)
                )
            ;;2]AUTOSTAKE.ATS|SC-NAME mints the requested RBT Amount
                (BASIS.DPTF|C_Mint patron rbt-id AUTOSTAKE.ATS|SC_NAME rbt-request-amount false)
            ;;3]AUTOSTAKE.ATS|SC-NAME transfers the RBT Amount to the Kickstarter
                (AUTOSTAKE.DPTF|CM_Transfer patron rbt-id ATS|SC_NAME kickstarter rbt-request-amount)
            )
        )
    )
    (defcap ATS|REDEEM (redeemer:string id:string)
        @doc "Required for redeeming a Hot RBT"
        (compose-capability (P|ATS|REMOTE-GOV))

        (BASIS.DPTF-DPMF|UEV_id id false)
        (DALOS.DALOS|UEV_EnforceAccountType redeemer false)
        (let
            (
                (iz-rbt:bool (BASIS.ATS|UC_IzRBT id false))
                
            )
            (enforce iz-rbt "Invalid Hot-RBT")
        )
    )
    (defun ATS|C_Redeem (patron:string redeemer:string id:string nonce:integer)
        @doc "Redeems a Hot RBT"
        (with-capability (ATS|REDEEM redeemer id)
            (let*
                (
                    (precision:integer (BASIS.DPTF-DPMF|UR_Decimals id false))
                    (current-nonce-balance:decimal (BASIS.DPMF|UR_AccountBatchSupply id nonce redeemer))
                    (meta-data (BASIS.DPMF|UR_AccountBatchMetaData id redeemer nonce))
                    (birth-date:time (at "mint-time" meta-data))
                    (present-time:time (at "block-time" (chain-data)))
                    (elapsed-time:decimal (diff-time present-time birth-date))

                    (atspair:string (BASIS.DPMF|UR_RewardBearingToken id))
                    (rt-lst:[string] (AUTOSTAKE.ATS|UR_RewardTokenList atspair))
                    (h-promile:decimal (AUTOSTAKE.ATS|UR_HotRecoveryStartingFeePromile atspair))
                    (h-decay:integer (AUTOSTAKE.ATS|UR_HotRecoveryDecayPeriod atspair))
                    (h-fr:bool (AUTOSTAKE.ATS|UR_HotRecoveryFeeRedirection atspair))

                    (total-time:decimal (* 86400 h-decay))
                    (end-time:time (add-time birth-date (hours (* 24 h-decay))))
                    (earned-rbt:decimal 
                        (if (= elapsed-time end-time)
                            current-nonce-balance
                            (floor (* (* (/ elapsed-time total-time) (/ h-promile 1000.0)) current-nonce-balance) precision)
                        )
                    )

                    (total-rts:[decimal] (AUTOSTAKE.ATS|UC_RTSplitAmounts atspair current-nonce-balance))
                    (earned-rts:[decimal] (AUTOSTAKE.ATS|UC_RTSplitAmounts atspair earned-rbt))
                    (fee-rts:[decimal] (zip (lambda (x:decimal y:decimal) (- x y)) total-rts earned-rts))
                )
            ;;1]Redeemer sends the whole Hot-Rbt to ATS|SC_NAME
                (BASIS.DPMF|CM_Transfer patron id redeemer ATS|SC_NAME current-nonce-balance)
            ;;2]ATS|SC_NAME burns the whole Hot-RBT
                (BASIS.DPMF|C_Burn patron id nonce ATS|SC_NAME current-nonce-balance)
            ;;3]ATS|SC_NAME transfers the proper amount of RT(s) to the Redeemer
                (DPTF|C_MultiTransfer patron rt-lst ATS|SC_NAME redeemer earned-rts)
            ;;4]And the Hot-FeeRediraction is accounted for
                (if (and (not h-fr) (!= earned-rbt current-nonce-balance))
                    (map
                        (lambda
                            (index:integer)
                            (BASIS.DPTF|C_Burn patron (at index rt-lst) ATS|SC_NAME (at index fee-rts))
                        )
                        (enumerate 0 (- (length rt-lst) 1))
                    )
                    true
                )
            )
        )
    )
    (defun DPTF|C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal])
        @doc "Executes a Multi DPTF transfer using 2 lists of multiple IDs and multiple transfer amounts"
        (with-capability (DPTF|MULTI)
            (DPTF|XK_MultiTransfer patron id-lst sender receiver transfer-amount-lst false) 
        )
    )
    (defun DPTF|CM_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal])
        @doc "DPTF Methodic Multi Transfer; Must be used when the Multi Transfer is executed by a Smart DALOS Account"
        (with-capability (DPTF|MULTI)
            (DPTF|XK_MultiTransfer patron id-lst sender receiver transfer-amount-lst true) 
        )
    )
    (defun DPTF|C_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @doc "Executes a Bulk DPTF transfer using 2 lists of multiple Receivers and multiple transfer amounts"
        (with-capability (DPTF|MULTI)
            (DPTF|XK_BulkTransfer patron id sender receiver-lst transfer-amount-lst false)
        )
    )
    (defun DPTF|CM_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        @doc "DPTF Methodic Bulk Transfer; Must be used when the Bulk Transfer is executed by a Smart DALOS Account"
        (with-capability (DPTF|MULTI)
            (DPTF|XK_BulkTransfer patron id sender receiver-lst transfer-amount-lst true)
        )
    )
    ;;        [x] Auxiliary Usage FUNCTIONS             [X]
    (defun DPTF|XK_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @doc "Auxiliary Kore Multi Transfer Function"
        (require-capability (DPTF|MULTI))
        (with-capability (DPTF|MULTI-PAIRED)
            (let
                (
                    (pair-validation:bool (DPTF|UEV_Pair_ID-Amount id-lst transfer-amount-lst))
                )
                (enforce (= pair-validation true) "Input Lists <id-lst>|<transfer-amount-lst> cannot make a valid pair list for Multi Transfer Processing")
                (let
                    (
                        (pair:[object{DPTF|ID-Amount}] (DPTF|UCC_Pair_ID-Amount id-lst transfer-amount-lst))
                    )
                    (map (lambda (x:object{DPTF|ID-Amount}) (DPTF|X_MultiTransferPaired patron sender receiver x method)) pair)
                )
            )
        )
    )
    (defun DPTF|X_MultiTransferPaired (patron:string sender:string receiver:string id-amount-pair:object{DPTF|ID-Amount} method:bool)
        @doc "Helper Function needed for making a Multi DPTF Transfer possible"
        (require-capability (DPTF|MULTI-PAIRED))
        (let
            (
                (id:string (at "id" id-amount-pair))
                (amount:decimal (at "amount" id-amount-pair))
            )
            (if method
                (AUTOSTAKE.DPTF|CM_Transfer patron id sender receiver amount)
                (AUTOSTAKE.DPTF|C_Transfer patron id sender receiver amount)
            )
            
        )
    )
    (defun DPTF|XK_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Auxiliary Kore Bulk Transfer Function"
        (require-capability (DPTF|MULTI))
        (with-capability (DPTF|BULK-PAIRED)
            (let
                (
                    (pair-validation:bool (DPTF|UEV_Pair_Receiver-Amount id receiver-lst transfer-amount-lst))
                )
                (enforce (= pair-validation true) "Input Lists <receiver-lst>|<transfer-amount-lst> cannot make a valid pair list with the <id> for Bulk Transfer Processing")
                (let
                    (
                        (pair:[object{DPTF|Receiver-Amount}] (DPTF|UCC_Pair_Receiver-Amount receiver-lst transfer-amount-lst))
                    )
                    (map (lambda (x:object{DPTF|Receiver-Amount}) (DPTF|X_BulkTransferPaired patron id sender x method)) pair)
                )
            )
        )
    )
    (defun DPTF|X_BulkTransferPaired (patron:string id:string sender:string receiver-amount-pair:object{DPTF|Receiver-Amount} method:bool)
        @doc "Helper Function needed for making a Bulk DPTF Transfer possible"
        (require-capability (DPTF|BULK-PAIRED))
        (let
            (
                (receiver:string (at "receiver" receiver-amount-pair))
                (amount:decimal (at "amount" receiver-amount-pair))
            )
            (if method
                (AUTOSTAKE.DPTF|CM_Transfer patron id sender receiver amount)
                (AUTOSTAKE.DPTF|C_Transfer patron id sender receiver amount)
            )
        )
    )
    ;;
    ;;            OUROBOROS         Submodule
    ;;
    ;;            CAPABILITIES      <0>
    ;;            FUNCTIONS         [9]
    ;;========[D] RESTRICTIONS=================================================;;
    ;;            Capabilities FUNCTIONS                [CAP]
    ;;            Function Based CAPABILITIES           [CF](have this tag)
    ;;        [2] Enforcements & Validations FUNCTIONS  [UEV]
    ;;        <3> Composed CAPABILITIES                 [CC](dont have this tag)
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;            Data Read FUNCTIONS                   [UR]
    ;;        [2] Data Read and Computation FUNCTIONS   [URC] and [UC]
    ;;            Data Creation|Composition FUNCTIONS   [UCC]
    ;;        [1] Administrative Usage FUNCTIONS        [A]
    ;;        [4] Client Usage FUNCTIONS                [C]
    ;;            Auxiliary Usage FUNCTIONS             [X]
    ;;=========================================================================;;
    ;;
    ;;            START
    ;;
    ;;========[D] RESTRICTIONS=================================================;;
    ;;            Capabilities FUNCTIONS                [CAP]
    ;;            Function Based CAPABILITIES           [CF](have this tag)
    ;;        [2] Enforcements & Validations FUNCTIONS  [UEV]
    (defun DALOS|UEV_Live ()
        @doc "Enforce DALOS Virtual Blockchain is properly set up by checking \
        \ OUROBOROS and IGNIS IDs are properly saved in the DALOS|PropertiesTable"
        (let
            (
                (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                (gas-id:string (DALOS.DALOS|UR_IgnisID))
            )
            (enforce (!= ouro-id UTILS.BAR) "Ouroboros is not set")
            (enforce (!= gas-id UTILS.BAR) "Ignis is not set")
        )
    )
    (defun IGNIS|UEV_Exchange ()
        @doc "Enforces the Ouroboros Account has the proper permission \
        \ Such that Ignis Exchange (Sublimation and Compression) is possible"
        (DALOS|UEV_Live)
        (let*
            (
                (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                (gas-id:string (DALOS.DALOS|UR_IgnisID))
                (o-rm:bool (BASIS.DPTF|UR_AccountRoleMint ouro-id OUROBOROS|SC_NAME))
                (o-rb:bool (BASIS.DPTF-DPMF|UR_AccountRoleBurn ouro-id OUROBOROS|SC_NAME true))
                (t1:bool (and o-rm o-rb))
                (g-rm:bool (BASIS.DPTF|UR_AccountRoleMint gas-id OUROBOROS|SC_NAME))
                (g-rb:bool (BASIS.DPTF-DPMF|UR_AccountRoleBurn gas-id OUROBOROS|SC_NAME true))
                (t2:bool (and g-rm g-rb))
                (t3:bool (and t1 t2))
            )
            (enforce t3 "Permission invalid for Ignis Exchange")
        )
    )
    ;;        <4> Composed CAPABILITIES                 [CC](dont have this tag)
    (defcap IGNIS|SUBLIMATE (patron:string client:string target:string)
        @doc "Required for Sublimation"
        (compose-capability (IGNIS|COMPRESS patron client))
        (DALOS.DALOS|UEV_EnforceAccountType target false)
    )
    (defcap IGNIS|COMPRESS (patron:string client:string)
        @doc "Required for Compression"
        (compose-capability (OUROBOROS|GOV))

        (IGNIS|UEV_Exchange)
        (DALOS.DALOS|UEV_EnforceAccountType patron false)
        (DALOS.DALOS|UEV_EnforceAccountType client false)
    )
    (defcap OUROBOROS|WITHDRAW (patron:string id:string target:string)
        @doc "Required to withdraw Fees stored in the Ouroboros Smart DALOS Account"
        (compose-capability (OUROBOROS|GOV))

        (BASIS.DPTF-DPMF|CAP_Owner id true)
        (DALOS.DALOS|UEV_EnforceAccountType target false)
    )
    (defcap OUROBOROS|ADMIN_FUEL ()
        @doc "Needed to Perform an administrator fueling of Liquid Staking using existing KDA Supply"
        (compose-capability (OUROBOROS|GOV))

        (compose-capability (OUROBOROS|NATIVE-AUTOMATIC))
    )
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;     [NONE] Data Read FUNCTIONS                   [UR]
    ;;        [2] Data Read and Computation FUNCTIONS   [URC] and [UC]
    (defun IGNIS|UC_Sublimate:decimal (ouro-amount:decimal)
        @doc "Computes how much GAS(Ignis) can be generated from <ouro-amount> Ouroboros"
        (enforce (>= ouro-amount 1.00) "Only amounts greater than or equal to 1.0 can be used to make gas!")
        (let
            (
                (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                
            )
            (BASIS.DPTF-DPMF|UEV_Amount ouro-id ouro-amount true)
            (let*
                (
                    (ouro-price:decimal (DALOS.DALOS|UR_OuroborosPrice))
                    (ouro-price-used:decimal (if (<= ouro-price 1.00) 1.00 ouro-price))
                    (ignis-id:string (DALOS.DALOS|UR_IgnisID))
                )
                (enforce (!= ignis-id UTILS.BAR) "Gas Token isnt properly set")
                (let*
                    (
                        (ignis-precision:integer (BASIS.DPTF-DPMF|UR_Decimals ignis-id true))
                        (raw-ignis-amount-per-unit:decimal (floor (* ouro-price-used 100.0) ignis-precision))
                        (raw-ignis-amount:decimal (floor (* raw-ignis-amount-per-unit ouro-amount) ignis-precision))
                        (output-ignis-amount:decimal (floor raw-ignis-amount 0))
                    )
                    output-ignis-amount
                )
            )
        )
    )
    (defun IGNIS|UC_Compress (ignis-amount:decimal)
        @doc "Computes how much Ouroboros can be generated from <ignis-amount> GAS(Ignis)"
        (enforce (= (floor ignis-amount 0) ignis-amount) "Only whole Units of GAS(Ignis) can be compressed")
        (enforce (>= ignis-amount 1.00) "Only amounts greater than or equal to 1.0 can be used to compress gas")
        (let*
            (
                (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                (ouro-price:decimal (DALOS.DALOS|UR_OuroborosPrice))
                (ouro-price-used:decimal (if (<= ouro-price 1.00) 1.00 ouro-price))
                (ignis-id:string (DALOS.DALOS|UR_IgnisID))
            )
            (BASIS.DPTF-DPMF|UEV_Amount ignis-id ignis-amount true)
            (let*
                (
                    (ouro-precision:integer (BASIS.DPTF-DPMF|UR_Decimals ouro-id true))
                    (raw-ouro-amount:decimal (floor (/ ignis-amount (* ouro-price-used 100.0)) ouro-precision))
                    (promile-split:[decimal] (UTILS.ATS|UC_PromilleSplit 15.0 raw-ouro-amount ouro-precision))
                    (ouro-remainder-amount:decimal (floor (at 0 promile-split) ouro-precision))
                    (ouro-fee-amount:decimal (at 1 promile-split))
                )
                [ouro-remainder-amount ouro-fee-amount]
            )
        )
    )
    ;;     (NONE) Data Creation|Composition FUNCTIONS   [UCC]
    ;;        [1] Administrative Usage FUNCTIONS        [A]
    (defun OUROBOROS|A_InitialiseVirtualBlockchain (patron:string)
        @doc "Main initialisation function for the DALOS Virtual Blockchain"
        (with-capability (OUROBOROS-ADMIN)
            (DALOS|X_WriteGlyphs)
            (DALOS|X_Initialise patron)
        )
    )
    ;;        [4] Client Usage FUNCTIONS                [C]
    (defun OUROBOROS|C_FuelLiquidStakingFromReserves (patron:string)
        @doc "Uses Native KDA cumulated reserves to fuel the Liquid Staking Protocol"
        (with-capability (OUROBOROS|ADMIN_FUEL)
            (let*
                (
                    (present-kda-balance:decimal (at "balance" (coin.details (DALOS|UR_AccountKadena OUROBOROS|SC_NAME))))
                    (w-kda:string (DALOS.DALOS|UR_WrappedKadenaID))
                    (w-kda-as-rt:[string] (BASIS.DPTF|UR_RewardToken w-kda))
                    (liquid-idx:string (at 0 w-kda-as-rt))
                )
            ;;Use existing Native Kadena Stock for wrapping int DWK
                (LIQUID.LIQUID|C_WrapKadena patron OUROBOROS|SC_NAME present-kda-balance)
            ;;Use the generated DWK to fuel its Autostake Pair
                (AUTOSTAKE.ATS|C_Fuel patron OUROBOROS|SC_NAME liquid-idx w-kda present-kda-balance)
            )
        )
    )
    (defun OUROBOROS|C_WithdrawFees (patron:string id:string target:string)
        @doc "When DPTF <id> <fee-target> is left default (Ouroboros Smart DALOS Account) \
        \ and the DPTF Token is set-up with a fee, fee cumulates to the Ouroboros Smart Account \
        \ The DPTF Token Owner can then withdraw these fees."
        (with-capability (OUROBOROS|WITHDRAW patron id target)
            (let
                (
                    (withdraw-amount:decimal (BASIS.DPTF-DPMF|UR_AccountSupply id OUROBOROS|SC_NAME true))
                )
                (enforce (> withdraw-amount 0.0) (format "There are no {} fees to be withdrawn from {}" [id OUROBOROS|SC_NAME]))
            ;;1]Patron withdraws Fees from Ouroboros Smart DALOS Account to a target Normal DALOS Account
                (AUTOSTAKE.DPTF|CM_Transfer patron id OUROBOROS|SC_NAME target withdraw-amount)
            )
        )
    )
    (defun IGNIS|C_Sublimate:decimal (patron:string client:string target:string ouro-amount:decimal)
        @doc "Generates GAS(Ignis) from Ouroboros via Sublimation by <client> to <target> \
            \ This means ANY Standard DALOS Account can generate GAS(Ignis) for any other Standard DALOS Account \
            \ Smart DALOS Accounts cannot be used as <client> or <target> \
            \ Ouroboros sublimation costs no GAS(Ignis) \
            \ Ouroboros Price is set at a minimum 1$ \
            \ GAS(Ignis) is generated always in whole amounts (ex 1.0 2.0 etc) (even though itself is of decimal type) \
            \ Returns the amount of GAS(Ignis) generated"
        (with-capability (IGNIS|SUBLIMATE patron client target)
            (let*
                (
                    (ignis-id:string (DALOS.DALOS|UR_IgnisID))
                    (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                    (ouro-precision:integer (BASIS.DPTF-DPMF|UR_Decimals ouro-id true))
                    (ouro-split:[decimal] (UTILS.ATS|UC_PromilleSplit 10.0 ouro-amount ouro-precision))
                    (ouro-remainder-amount:decimal (at 0 ouro-split))
                    (ouro-fee-amount:decimal (at 1 ouro-split))
                    (ignis-amount:decimal (IGNIS|UC_Sublimate ouro-remainder-amount))
                )
            ;;01]Client sends OURO <ouro-amount> to the Ouroboros Smart DALOS Account
                (AUTOSTAKE.DPTF|CM_Transfer patron ouro-id client OUROBOROS|SC_NAME ouro-amount)
            ;;02]Ouroboros burns OURO <ouro-remainder-amount>
                (BASIS.DPTF|C_Burn patron ouro-id OUROBOROS|SC_NAME ouro-remainder-amount)
            ;;03]Ouroboros mints GAS(Ignis) <ignis-amount>
                (BASIS.DPTF|C_Mint patron ignis-id OUROBOROS|SC_NAME ignis-amount false)
            ;;04]Ouroboros transfers GAS(Ignis) <ignis-amount> to <target>
                (AUTOSTAKE.DPTF|CM_Transfer patron ignis-id OUROBOROS|SC_NAME target ignis-amount)
            ;;05]Ouroboros transmutes OURO <ouro-fee-amount>
                (AUTOSTAKE.DPTF|C_Transmute patron ouro-id OUROBOROS|SC_NAME ouro-fee-amount)
                ignis-amount
            )
        )
    )
    (defun IGNIS|C_Compress:decimal (patron:string client:string ignis-amount:decimal)
        @doc "Generates Ouroboros from GAS(Ignis) via Compression by <client> for itself \
            \ Any Standard DALOS Accounts can compress GAS(Ignis) \
            \ GAS(Ignis) compression costs no GAS(Ignis) \
            \ Ouroboros Price is set at a minimum 1$ \
            \ Can only compress whole amounts of GAS(Ignis) \
            \ Returns the amount of Ouroboros generated"
        (with-capability (IGNIS|COMPRESS patron client)
            (let*
                (
                    (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                    (ignis-id:string (DALOS.DALOS|UR_IgnisID))
                    (ignis-to-ouro:[decimal] (IGNIS|UC_Compress ignis-amount))
                    (ouro-remainder-amount:decimal (at 0 ignis-to-ouro))
                    (ouro-fee-amount:decimal (at 1 ignis-to-ouro))
                    (total-ouro:decimal (+ ouro-remainder-amount ouro-fee-amount))
                )
            ;;01]Client sends GAS(Ignis) <ignis-amount> to the Ouroboros Smart DALOS Account
                (AUTOSTAKE.DPTF|CM_Transfer patron ignis-id client OUROBOROS|SC_NAME ignis-amount)
            ;;02]Ouroboros burns GAS(Ignis) <ignis-amount>
                (BASIS.DPTF|C_Burn patron ignis-id OUROBOROS|SC_NAME ignis-amount)
            ;;03]Ouroboros mints OURO <total-ouro>
                (BASIS.DPTF|C_Mint patron ouro-id OUROBOROS|SC_NAME total-ouro false)
            ;;04]Ouroboros transfers OURO <ouro-remainder-amount> to <client>
                (AUTOSTAKE.DPTF|CM_Transfer patron ouro-id OUROBOROS|SC_NAME client ouro-remainder-amount)
            ;;05]Ouroboros transmutes OURO <ouro-fee-amount>
                (AUTOSTAKE.DPTF|C_Transmute patron ouro-id OUROBOROS|SC_NAME ouro-fee-amount)
                ouro-remainder-amount
            )
        )
    )
    ;;     (NONE) Auxiliary Usage FUNCTIONS             [X]
    (defun DALOS|X_Initialise (patron:string)
        @doc "Main administrative function that initialises the DALOS Virtual Blockchain"
        (require-capability (OUROBOROS-ADMIN))

        ;;STEP Primordial - Setting Up Policies for Inter-Module Communication
            (BASIS.BASIS|DefinePolicies)
            (AUTOSTAKE.ATS|DefinePolicies)
            (OUROBOROS.OUROBOROS|DefinePolicies)

        ;;STEP 0
        ;;Deploy the <Dalos> Smart DALOS Account
            (DALOS.DALOS|C_DeploySmartAccount DALOS.DALOS|SC_NAME (keyset-ref-guard DALOS.DALOS|SC_KEY) DALOS.DALOS|SC_KDA-NAME patron)
        ;;Deploy the <Autostake> Smart DALOS Account
            (DALOS.DALOS|C_DeploySmartAccount AUTOSTAKE.ATS|SC_NAME (keyset-ref-guard AUTOSTAKE.ATS|SC_KEY) AUTOSTAKE.ATS|SC_KDA-NAME patron)
            (AUTOSTAKE.ATS|SetGovernor patron)
        ;;Deploy the <Vesting> Smart DALOS Account
            (DALOS.DALOS|C_DeploySmartAccount AUTOSTAKE.VST|SC_NAME (keyset-ref-guard AUTOSTAKE.VST|SC_KEY) AUTOSTAKE.VST|SC_KDA-NAME patron)
            (AUTOSTAKE.VST|SetGovernor patron)
        ;;Deploy the <Liquidizer> Smart DALOS Account
            (DALOS.DALOS|C_DeploySmartAccount LIQUID.LIQUID|SC_NAME (keyset-ref-guard LIQUID.LIQUID|SC_KEY) LIQUID.LIQUID|SC_KDA-NAME patron)
            (LIQUID.LIQUID|SetGovernor patron)
        ;;Deploy the <Ouroboros> Smart DALOS Account
            (DALOS.DALOS|C_DeploySmartAccount OUROBOROS.OUROBOROS|SC_NAME (keyset-ref-guard OUROBOROS.OUROBOROS|SC_KEY) OUROBOROS.OUROBOROS|SC_KDA-NAME patron)
            (OUROBOROS.OUROBOROS|SetGovernor patron)

        ;;STEP 1
        ;;Insert Blank Info in the DALOS|PropertiesTable (so that it can be updated afterwards)
            (insert DALOS.DALOS|PropertiesTable DALOS.DALOS|INFO
                {"demiurgoi"                : 
                    [
                        "Ѻ.CЭΞŸNGúůρhãmИΘÛ¢₳šШдìAÚwŚGýηЗПAÊУÔȘřŽÍζЗηmΔφDmcдΛъ₳tĂýăŮsПÞ$öœGθeBŽvąαÃfçл¢ĎĆď$şbsЦэΘNÄëÍĂνуãöž¥àZjÆůšÁœôñχŽâЩåτâн4μфAOçĎΓuЗŮnøЙãĚè6Дżîþż$цÑûρψŻïZÉλûæřΨeèÎígςeL"
                        "Ѻ.ÍăüÙÜЦżΦF₿ÈшÕóñĐĞGюѺλωÇțnθòoйEςк₱0дş3ôPpxŞțqgЖ€šωbэočΞìČ5òżŁdŒИöùЪøŤяжλзÜ2ßżpĄγïčѺöэěτČэεSčDõžЩУЧÀ₳ŚàЪЙĎpЗΣ2ÃлτíČнÙyéÕãďWŹŘĘźσПåbã€éѺι€ΓφŠ₱ŽyWcy5ŘòmČ₿nβÁ¢¥NЙëOι"
                    ]
                ,"unity-id"                 : UTILS.BAR
                ,"gas-source-id"            : UTILS.BAR
                ,"gas-source-id-price"      : 0.0
                ,"gas-id"                   : UTILS.BAR
                ,"ats-gas-source-id"        : UTILS.BAR
                ,"elite-ats-gas-source-id"  : UTILS.BAR
                ,"wrapped-kda-id"           : UTILS.BAR
                ,"liquid-kda-id"            : UTILS.BAR}
            )
        ;;Set Virtual Blockchain KDA Prices
            (insert DALOS.DALOS|PricesTable DALOS.DALOS|PRICES
                {"standard"                 : 10.0
                ,"smart"                    : 20.0
                ,"dptf"                     : 200.0
                ,"dpmf"                     : 300.0
                ,"dpsf"                     : 400.0
                ,"dpnf"                     : 500.0
                ,"blue"                     : 25.0}
            )
        ;;Set Information in the DALOS|GasManagementTable
            (insert DALOS.DALOS|GasManagementTable DALOS.DALOS|VGD
                {"virtual-gas-tank"         : DALOS.DALOS|SC_NAME
                ,"virtual-gas-toggle"       : false
                ,"virtual-gas-spent"        : 0.0
                ,"native-gas-toggle"        : false
                ,"native-gas-spent"         : 0.0}
            )

        ;;STEP 2
        (let*
            (
                (core-tf:[string]
                    (BASIS.DPTF|C_Issue
                        patron
                        DALOS.DALOS|SC_NAME
                        ["Ouroboros" "Auryn" "EliteAuryn" "Ignis" "DalosWrappedKadena" "DalosLiquidKadena"]
                        ["OURO" "AURYN" "ELITEAURYN" "GAS" "DWK" "DLK"]
                        [24 24 24 24 24 24]
                        [true true true true true true]         ;;can change owner
                        [true true true true true true]         ;;can upgrade
                        [true true true true true true]         ;;can can-add-special-role
                        [true false false true false false]     ;;can-freeze
                        [true false false false false false]    ;;can-wipe
                        [true false false true false false]     ;;can pause
                    )
                )
                (OuroID:string (at 0 core-tf))
                (AurynID:string (at 1 core-tf))
                (EliteAurynID:string (at 2 core-tf))
                (GasID:string (at 3 core-tf))
                (WrappedKadenaID:string (at 4 core-tf))
                (StakedKadenaID:string (at 5 core-tf))
            )
        ;;STEP 2.1 - Update DALOS|PropertiesTable with new Data
            (update DALOS.DALOS|PropertiesTable DALOS.DALOS|INFO
                { "gas-source-id"           : OuroID
                , "gas-id"                  : GasID
                , "ats-gas-source-id"       : AurynID
                , "elite-ats-gas-source-id" : EliteAurynID
                , "wrapped-kda-id"          : WrappedKadenaID
                , "liquid-kda-id"           : StakedKadenaID
                }
            )
        ;;STEP 2.2 - Issue needed DPTF Accounts
            (BASIS.DPTF-DPMF|C_DeployAccount AurynID AUTOSTAKE.ATS|SC_NAME true)
            (BASIS.DPTF-DPMF|C_DeployAccount EliteAurynID AUTOSTAKE.ATS|SC_NAME true)
            (BASIS.DPTF-DPMF|C_DeployAccount WrappedKadenaID LIQUID.LIQUID|SC_NAME true)
            (BASIS.DPTF-DPMF|C_DeployAccount StakedKadenaID LIQUID.LIQUID|SC_NAME true)
        ;;STEP 2.3 - Set Up Auryn and Elite-Auryn
            (BASIS.DPTF|C_SetFee patron AurynID UTILS.AURYN_FEE)
            (BASIS.DPTF|C_SetFee patron EliteAurynID UTILS.ELITE-AURYN_FEE)
            (BASIS.DPTF|C_ToggleFee patron AurynID true)
            (BASIS.DPTF|C_ToggleFee patron EliteAurynID true)
            (BASIS.DPTF|C_ToggleFeeLock patron AurynID true)
            (BASIS.DPTF|C_ToggleFeeLock patron EliteAurynID true)
        ;;STEP 2.4 - Set Up Ignis
            ;;Setting Up Ignis Parameters
            (BASIS.DPTF|C_SetMinMove patron GasID 1000.0)
            (BASIS.DPTF|C_SetFee patron GasID -1.0)
            (BASIS.DPTF|C_SetFeeTarget patron GasID DALOS.DALOS|SC_NAME)
            (BASIS.DPTF|C_ToggleFee patron GasID true)
            (BASIS.DPTF|C_ToggleFeeLock patron GasID true)
            ;;Setting Up Compression|Sublimation Permissions
            (AUTOSTAKE.DPTF-DPMF|C_ToggleBurnRole patron GasID OUROBOROS.OUROBOROS|SC_NAME true true)
            (AUTOSTAKE.DPTF-DPMF|C_ToggleBurnRole patron OuroID OUROBOROS.OUROBOROS|SC_NAME true true)
            (AUTOSTAKE.DPTF|C_ToggleMintRole patron GasID OUROBOROS.OUROBOROS|SC_NAME true)
            (AUTOSTAKE.DPTF|C_ToggleMintRole patron OuroID OUROBOROS.OUROBOROS|SC_NAME true)
        ;;STEP 2.5 - Set Up Liquid-Staking System
            ;;Setting Liquid Staking Tokens Parameters
            (BASIS.DPTF|C_SetFee patron StakedKadenaID -1.0)
            (BASIS.DPTF|C_ToggleFee patron StakedKadenaID true)
            (BASIS.DPTF|C_ToggleFeeLock patron StakedKadenaID true)
            ;;Setting Liquid Staking Tokens Roles
            (AUTOSTAKE.DPTF-DPMF|C_ToggleBurnRole patron WrappedKadenaID LIQUID.LIQUID|SC_NAME true true)
            (AUTOSTAKE.DPTF|C_ToggleMintRole patron WrappedKadenaID LIQUID.LIQUID|SC_NAME true)
        ;;STEP 2.6 - Create Vesting Pairs
            (AUTOSTAKE.VST|C_CreateVestingLink patron OuroID)
            (AUTOSTAKE.VST|C_CreateVestingLink patron AurynID)
            (AUTOSTAKE.VST|C_CreateVestingLink patron EliteAurynID)
        
        ;:STEP 3 - Initialises Autostake Pairs
            (let*
                (
                    (Auryndex:string
                        (AUTOSTAKE.ATS|C_Issue
                            patron
                            patron
                            "Auryndex"
                            24
                            OuroID
                            true
                            AurynID
                            false
                        )
                    )
                    (Elite-Auryndex:string
                        (AUTOSTAKE.ATS|C_Issue
                            patron
                            patron
                            "EliteAuryndex"
                            24
                            AurynID
                            true
                            EliteAurynID
                            true
                        )
                    )
                    (Kadena-Liquid-Index:string
                        (AUTOSTAKE.ATS|C_Issue
                            patron
                            patron
                            "Kadindex"
                            24
                            WrappedKadenaID
                            false
                            StakedKadenaID
                            true
                        )
                    )
                    (core-idx:[string] [Auryndex Elite-Auryndex Kadena-Liquid-Index])
                )
        ;;STEP 3.1 - Set Up <Auryndex> Autostake-Pair
                (AUTOSTAKE.ATS|C_SetColdFee patron Auryndex
                    7
                    [50.0 100.0 200.0 350.0 550.0 800.0]
                    [
                        [8.0 7.0 6.0 5.0 4.0 3.0 2.0]
                        [9.0 8.0 7.0 6.0 5.0 4.0 3.0]
                        [10.0 9.0 8.0 7.0 6.0 5.0 4.0]
                        [11.0 10.0 9.0 8.0 7.0 6.0 5.0]
                        [12.0 11.0 10.0 9.0 8.0 7.0 6.0]
                        [13.0 12.0 11.0 10.0 9.0 8.0 7.0]
                        [14.0 13.0 12.0 11.0 10.0 9.0 8.0]
                    ]
                )
                (AUTOSTAKE.ATS|C_TurnRecoveryOn patron Auryndex true)
        ;;STEP 3.2 - Set Up <EliteAuryndex> Autostake-Pair
                (AUTOSTAKE.ATS|C_SetColdFee patron Elite-Auryndex 7 [0.0] [[0.0]])
                (AUTOSTAKE.ATS|C_SetCRD patron Elite-Auryndex false 360 24)
                (AUTOSTAKE.ATS|C_ToggleElite patron Elite-Auryndex true)
                (AUTOSTAKE.ATS|C_TurnRecoveryOn patron Elite-Auryndex true)
        ;;STEP 3.3 - Set Up <Kadindex> Autostake-Pair
                (AUTOSTAKE.ATS|C_SetColdFee patron Kadena-Liquid-Index -1 [0.0] [[0.0]])
                (AUTOSTAKE.ATS|C_SetCRD patron Kadena-Liquid-Index false 12 6)
                (AUTOSTAKE.ATS|C_TurnRecoveryOn patron Kadena-Liquid-Index true)
        ;;STEP 4 - Return Token Ownership to their respective Smart DALOS Accounts
                (BASIS.DPTF-DPMF|C_ChangeOwnership patron AurynID AUTOSTAKE.ATS|SC_NAME true)
                (BASIS.DPTF-DPMF|C_ChangeOwnership patron EliteAurynID AUTOSTAKE.ATS|SC_NAME true)
                (BASIS.DPTF-DPMF|C_ChangeOwnership patron WrappedKadenaID LIQUID.LIQUID|SC_NAME true)
                (BASIS.DPTF-DPMF|C_ChangeOwnership patron StakedKadenaID LIQUID.LIQUID|SC_NAME true)
        ;;STEP 5 - Return as Output a list of all Token-IDs and ATS-Pair IDs that were created
                (+ core-tf core-idx)
            )
        )
    )
    (defun DALOS|X_WriteGlyphs ()
        @doc "Populates the DALOS.DALOS|Glyphs Table"
        ;;Dalos Auxilliary 32 Glyphs
        (insert DALOS.DALOS|Glyphs " " { "u" : [32], "c" : "U+0020", "n" : "Space"})
        (insert DALOS.DALOS|Glyphs "!" { "u" : [33], "c" : "U+0021", "n" : "Exclamation Mark"})
        (insert DALOS.DALOS|Glyphs "\"" { "u" : [34], "c" : "U+0022", "n" : "Quotation Mark"})
        (insert DALOS.DALOS|Glyphs "#" { "u" : [35], "c" : "U+0023", "n" : "Number Sign (Hash)"})
        (insert DALOS.DALOS|Glyphs "%" { "u" : [37], "c" : "U+0025", "n" : "Percent Sign"})
        (insert DALOS.DALOS|Glyphs "&" { "u" : [38], "c" : "U+0026", "n" : "Ampersand"})
        (insert DALOS.DALOS|Glyphs "'" { "u" : [39], "c" : "U+0027", "n" : "Apostrophe"})
        (insert DALOS.DALOS|Glyphs "(" { "u" : [40], "c" : "U+0028", "n" : "Left Parenthesis"})
        (insert DALOS.DALOS|Glyphs ")" { "u" : [41], "c" : "U+0029", "n" : "Right Parenthesis"})
        (insert DALOS.DALOS|Glyphs "*" { "u" : [42], "c" : "U+002A", "n" : "Asterisk"})
        (insert DALOS.DALOS|Glyphs "+" { "u" : [43], "c" : "U+002B", "n" : "Plus Sign"})
        (insert DALOS.DALOS|Glyphs "," { "u" : [44], "c" : "U+002C", "n" : "Comma"})
        (insert DALOS.DALOS|Glyphs "-" { "u" : [45], "c" : "U+002D", "n" : "Hyphen-Minus"})
        (insert DALOS.DALOS|Glyphs "." { "u" : [46], "c" : "U+002E", "n" : "Full Stop"})
        (insert DALOS.DALOS|Glyphs "/" { "u" : [47], "c" : "U+002F", "n" : "Solidus (Slash)"})
        (insert DALOS.DALOS|Glyphs ":" { "u" : [58], "c" : "U+003A", "n" : "Colon"})
        (insert DALOS.DALOS|Glyphs ";" { "u" : [59], "c" : "U+003B", "n" : "Semicolon"})
        (insert DALOS.DALOS|Glyphs "<" { "u" : [60], "c" : "U+003C", "n" : "Less-Than Sign"})
        (insert DALOS.DALOS|Glyphs "=" { "u" : [61], "c" : "U+003D", "n" : "Equals Sign"})
        (insert DALOS.DALOS|Glyphs ">" { "u" : [62], "c" : "U+003E", "n" : "Greater-Than Sign"})
        (insert DALOS.DALOS|Glyphs "?" { "u" : [63], "c" : "U+003F", "n" : "Question Mark"})
        (insert DALOS.DALOS|Glyphs "@" { "u" : [64], "c" : "U+0040", "n" : "Commercial At"})
        (insert DALOS.DALOS|Glyphs "[" { "u" : [91], "c" : "U+005B", "n" : "Left Square Bracket"})
        (insert DALOS.DALOS|Glyphs "]" { "u" : [93], "c" : "U+005D", "n" : "Right Square Bracket"})
        (insert DALOS.DALOS|Glyphs "^" { "u" : [94], "c" : "U+005E", "n" : "Circumflex Accent"})
        (insert DALOS.DALOS|Glyphs "_" { "u" : [95], "c" : "U+005F", "n" : "Low Line (Underscore)"})
        (insert DALOS.DALOS|Glyphs "`" { "u" : [96], "c" : "U+0060", "n" : "Grave Accent"})
        (insert DALOS.DALOS|Glyphs "{" { "u" : [123], "c" : "U+007B", "n" : "Left Curly Bracket"})
        (insert DALOS.DALOS|Glyphs "|" { "u" : [124], "c" : "U+007C", "n" : "Vertical Line"})
        (insert DALOS.DALOS|Glyphs "}" { "u" : [125], "c" : "U+007D", "n" : "Right Curly Bracket"})
        (insert DALOS.DALOS|Glyphs "~" { "u" : [126], "c" : "U+007E", "n" : "Tilde"})
        (insert DALOS.DALOS|Glyphs "‰" { "u" : [137], "c" : "U+2030", "n" : "Per Mille Sign"})
        ;;Digits - 10 glyphs
        (insert DALOS.DALOS|Glyphs "0" { "u" : [48], "c" : "U+0030", "n" : "Digit Zero"})
        (insert DALOS.DALOS|Glyphs "1" { "u" : [49], "c" : "U+0031", "n" : "Digit One"})
        (insert DALOS.DALOS|Glyphs "2" { "u" : [50], "c" : "U+0032", "n" : "Digit Two"})
        (insert DALOS.DALOS|Glyphs "3" { "u" : [51], "c" : "U+0033", "n" : "Digit Three"})
        (insert DALOS.DALOS|Glyphs "4" { "u" : [52], "c" : "U+0034", "n" : "Digit Four"})
        (insert DALOS.DALOS|Glyphs "5" { "u" : [53], "c" : "U+0035", "n" : "Digit Five"})
        (insert DALOS.DALOS|Glyphs "6" { "u" : [54], "c" : "U+0036", "n" : "Digit Six"})
        (insert DALOS.DALOS|Glyphs "7" { "u" : [55], "c" : "U+0037", "n" : "Digit Seven"})
        (insert DALOS.DALOS|Glyphs "8" { "u" : [56], "c" : "U+0038", "n" : "Digit Eight"})
        (insert DALOS.DALOS|Glyphs "9" { "u" : [57], "c" : "U+0039", "n" : "Digit Nine"})
        ;;Currencies - 10 Glyphs
        (insert DALOS.DALOS|Glyphs "Ѻ" { "u" : [209, 186], "c" : "U+047A", "n" : "Cyrillic Capital Letter Round Omega (OUROBOROS Currency)"})
        (insert DALOS.DALOS|Glyphs "₿" { "u" : [226, 130, 191], "c" : "U+20BF", "n" : "Bitcoin Sign"})
        (insert DALOS.DALOS|Glyphs "$" { "u" : [36], "c" : "U+0024", "n" : "Dollar Sign"})
        (insert DALOS.DALOS|Glyphs "¢" { "u" : [194, 162], "c" : "U+00A2", "n" : "Cent Sign"})
        (insert DALOS.DALOS|Glyphs "€" { "u" : [226, 130, 172], "c" : "U+20AC", "n" : "Euro Sign"})
        (insert DALOS.DALOS|Glyphs "£" { "u" : [194, 163], "c" : "U+00A3", "n" : "Pound Sign"})
        (insert DALOS.DALOS|Glyphs "¥" { "u" : [194, 165], "c" : "U+00A5", "n" : "Yen Sign"})
        (insert DALOS.DALOS|Glyphs "₱" { "u" : [226, 130, 177], "c" : "U+20B1", "n" : "Peso Sign"})
        (insert DALOS.DALOS|Glyphs "₳" { "u" : [226, 130, 179], "c" : "U+20B3", "n" : "Austral Sign (AURYN Currency)"})
        (insert DALOS.DALOS|Glyphs "∇" { "u" : [226, 136, 135], "c" : "U+2207", "n" : "Nabla (TALOS Currency)"})
        ;;Latin Majuscules - 26 Glyphs
        (insert DALOS.DALOS|Glyphs "A" { "u" : [65], "c" : "U+0041", "n" : "Latin Capital Letter A"})
        (insert DALOS.DALOS|Glyphs "B" { "u" : [66], "c" : "U+0042", "n" : "Latin Capital Letter B"})
        (insert DALOS.DALOS|Glyphs "C" { "u" : [67], "c" : "U+0043", "n" : "Latin Capital Letter C"})
        (insert DALOS.DALOS|Glyphs "D" { "u" : [68], "c" : "U+0044", "n" : "Latin Capital Letter D"})
        (insert DALOS.DALOS|Glyphs "E" { "u" : [69], "c" : "U+0045", "n" : "Latin Capital Letter E"})
        (insert DALOS.DALOS|Glyphs "F" { "u" : [70], "c" : "U+0046", "n" : "Latin Capital Letter F"})
        (insert DALOS.DALOS|Glyphs "G" { "u" : [71], "c" : "U+0047", "n" : "Latin Capital Letter G"})
        (insert DALOS.DALOS|Glyphs "H" { "u" : [72], "c" : "U+0048", "n" : "Latin Capital Letter H"})
        (insert DALOS.DALOS|Glyphs "I" { "u" : [73], "c" : "U+0049", "n" : "Latin Capital Letter I"})
        (insert DALOS.DALOS|Glyphs "J" { "u" : [74], "c" : "U+004A", "n" : "Latin Capital Letter J"})
        (insert DALOS.DALOS|Glyphs "K" { "u" : [75], "c" : "U+004B", "n" : "Latin Capital Letter K"})
        (insert DALOS.DALOS|Glyphs "L" { "u" : [76], "c" : "U+004C", "n" : "Latin Capital Letter L"})
        (insert DALOS.DALOS|Glyphs "M" { "u" : [77], "c" : "U+004D", "n" : "Latin Capital Letter M"})
        (insert DALOS.DALOS|Glyphs "N" { "u" : [78], "c" : "U+004E", "n" : "Latin Capital Letter N"})
        (insert DALOS.DALOS|Glyphs "O" { "u" : [79], "c" : "U+004F", "n" : "Latin Capital Letter O"})
        (insert DALOS.DALOS|Glyphs "P" { "u" : [80], "c" : "U+0050", "n" : "Latin Capital Letter P"})
        (insert DALOS.DALOS|Glyphs "Q" { "u" : [81], "c" : "U+0051", "n" : "Latin Capital Letter Q"})
        (insert DALOS.DALOS|Glyphs "R" { "u" : [82], "c" : "U+0052", "n" : "Latin Capital Letter R"})
        (insert DALOS.DALOS|Glyphs "S" { "u" : [83], "c" : "U+0053", "n" : "Latin Capital Letter S"})
        (insert DALOS.DALOS|Glyphs "T" { "u" : [84], "c" : "U+0054", "n" : "Latin Capital Letter T"})
        (insert DALOS.DALOS|Glyphs "U" { "u" : [85], "c" : "U+0055", "n" : "Latin Capital Letter U"})
        (insert DALOS.DALOS|Glyphs "V" { "u" : [86], "c" : "U+0056", "n" : "Latin Capital Letter V"})
        (insert DALOS.DALOS|Glyphs "W" { "u" : [87], "c" : "U+0057", "n" : "Latin Capital Letter W"})
        (insert DALOS.DALOS|Glyphs "X" { "u" : [88], "c" : "U+0058", "n" : "Latin Capital Letter X"})
        (insert DALOS.DALOS|Glyphs "Y" { "u" : [89], "c" : "U+0059", "n" : "Latin Capital Letter Y"})
        (insert DALOS.DALOS|Glyphs "Z" { "u" : [90], "c" : "U+005A", "n" : "Latin Capital Letter Z"})
        ;;Latin Minuscules - 26 Glyphs
        (insert DALOS.DALOS|Glyphs "a" { "u" : [97], "c" : "U+0061", "n" : "Latin Small Letter A"})
        (insert DALOS.DALOS|Glyphs "b" { "u" : [98], "c" : "U+0062", "n" : "Latin Small Letter B"})
        (insert DALOS.DALOS|Glyphs "c" { "u" : [99], "c" : "U+0063", "n" : "Latin Small Letter C"})
        (insert DALOS.DALOS|Glyphs "d" { "u" : [100], "c" : "U+0064", "n" : "Latin Small Letter D"})
        (insert DALOS.DALOS|Glyphs "e" { "u" : [101], "c" : "U+0065", "n" : "Latin Small Letter E"})
        (insert DALOS.DALOS|Glyphs "f" { "u" : [102], "c" : "U+0066", "n" : "Latin Small Letter F"})
        (insert DALOS.DALOS|Glyphs "g" { "u" : [103], "c" : "U+0067", "n" : "Latin Small Letter G"})
        (insert DALOS.DALOS|Glyphs "h" { "u" : [104], "c" : "U+0068", "n" : "Latin Small Letter H"})
        (insert DALOS.DALOS|Glyphs "i" { "u" : [105], "c" : "U+0069", "n" : "Latin Small Letter I"})
        (insert DALOS.DALOS|Glyphs "j" { "u" : [106], "c" : "U+006A", "n" : "Latin Small Letter J"})
        (insert DALOS.DALOS|Glyphs "k" { "u" : [107], "c" : "U+006B", "n" : "Latin Small Letter K"})
        (insert DALOS.DALOS|Glyphs "l" { "u" : [108], "c" : "U+006C", "n" : "Latin Small Letter L"})
        (insert DALOS.DALOS|Glyphs "m" { "u" : [109], "c" : "U+006D", "n" : "Latin Small Letter M"})
        (insert DALOS.DALOS|Glyphs "n" { "u" : [110], "c" : "U+006E", "n" : "Latin Small Letter N"})
        (insert DALOS.DALOS|Glyphs "o" { "u" : [111], "c" : "U+006F", "n" : "Latin Small Letter O"})
        (insert DALOS.DALOS|Glyphs "p" { "u" : [112], "c" : "U+0070", "n" : "Latin Small Letter P"})
        (insert DALOS.DALOS|Glyphs "q" { "u" : [113], "c" : "U+0071", "n" : "Latin Small Letter Q"})
        (insert DALOS.DALOS|Glyphs "r" { "u" : [114], "c" : "U+0072", "n" : "Latin Small Letter R"})
        (insert DALOS.DALOS|Glyphs "s" { "u" : [115], "c" : "U+0073", "n" : "Latin Small Letter S"})
        (insert DALOS.DALOS|Glyphs "t" { "u" : [116], "c" : "U+0074", "n" : "Latin Small Letter T"})
        (insert DALOS.DALOS|Glyphs "u" { "u" : [117], "c" : "U+0075", "n" : "Latin Small Letter U"})
        (insert DALOS.DALOS|Glyphs "v" { "u" : [118], "c" : "U+0076", "n" : "Latin Small Letter V"})
        (insert DALOS.DALOS|Glyphs "w" { "u" : [119], "c" : "U+0077", "n" : "Latin Small Letter W"})
        (insert DALOS.DALOS|Glyphs "x" { "u" : [120], "c" : "U+0078", "n" : "Latin Small Letter X"})
        (insert DALOS.DALOS|Glyphs "y" { "u" : [121], "c" : "U+0079", "n" : "Latin Small Letter Y"})
        (insert DALOS.DALOS|Glyphs "z" { "u" : [122], "c" : "U+007A", "n" : "Latin Small Letter Z"})
        ;;Latin Extended Majuscules - 53 Glyphs
        (insert DALOS.DALOS|Glyphs "Æ" { "u" : [195, 134], "c" : "U+00C6", "n" : "Latin Capital Letter Ae"})
        (insert DALOS.DALOS|Glyphs "Œ" { "u" : [197, 146], "c" : "U+0152", "n" : "Latin Capital Letter Oe"})
        (insert DALOS.DALOS|Glyphs "Á" { "u" : [195, 129], "c" : "U+00C1", "n" : "Latin Capital Letter A with Acute"})
        (insert DALOS.DALOS|Glyphs "Ă" { "u" : [196, 130], "c" : "U+0102", "n" : "Latin Capital Letter A with Breve"})
        (insert DALOS.DALOS|Glyphs "Â" { "u" : [195, 130], "c" : "U+00C2", "n" : "Latin Capital Letter A with Circumflex"})
        (insert DALOS.DALOS|Glyphs "Ä" { "u" : [195, 132], "c" : "U+00C4", "n" : "Latin Capital Letter A with Diaeresis"})
        (insert DALOS.DALOS|Glyphs "À" { "u" : [195, 128], "c" : "U+00C0", "n" : "Latin Capital Letter A with Grave"})
        (insert DALOS.DALOS|Glyphs "Ą" { "u" : [196, 132], "c" : "U+0104", "n" : "Latin Capital Letter A with Ogonek"})
        (insert DALOS.DALOS|Glyphs "Å" { "u" : [195, 133], "c" : "U+00C5", "n" : "Latin Capital Letter A with Ring Above"})
        (insert DALOS.DALOS|Glyphs "Ã" { "u" : [195, 131], "c" : "U+00C3", "n" : "Latin Capital Letter A with Tilde"})
        (insert DALOS.DALOS|Glyphs "Ć" { "u" : [196, 134], "c" : "U+0106", "n" : "Latin Capital Letter C with Acute"})
        (insert DALOS.DALOS|Glyphs "Č" { "u" : [196, 140], "c" : "U+010C", "n" : "Latin Capital Letter C with Caron"})
        (insert DALOS.DALOS|Glyphs "Ç" { "u" : [195, 135], "c" : "U+00C7", "n" : "Latin Capital Letter C with Cedilla"})
        (insert DALOS.DALOS|Glyphs "Ď" { "u" : [196, 142], "c" : "U+010E", "n" : "Latin Capital Letter D with Caron"})
        (insert DALOS.DALOS|Glyphs "Đ" { "u" : [196, 144], "c" : "U+0110", "n" : "Latin Capital Letter D with Stroke"})
        (insert DALOS.DALOS|Glyphs "É" { "u" : [195, 137], "c" : "U+00C9", "n" : "Latin Capital Letter E with Acute"})
        (insert DALOS.DALOS|Glyphs "Ě" { "u" : [196, 154], "c" : "U+011A", "n" : "Latin Capital Letter E with Caron"})
        (insert DALOS.DALOS|Glyphs "Ê" { "u" : [195, 138], "c" : "U+00CA", "n" : "Latin Capital Letter E with Circumflex"})
        (insert DALOS.DALOS|Glyphs "Ë" { "u" : [195, 139], "c" : "U+00CB", "n" : "Latin Capital Letter E with Diaeresis"})
        (insert DALOS.DALOS|Glyphs "È" { "u" : [195, 136], "c" : "U+00C8", "n" : "Latin Capital Letter E with Grave"})
        (insert DALOS.DALOS|Glyphs "Ę" { "u" : [196, 152], "c" : "U+0118", "n" : "Latin Capital Letter E with Ogonek"})
        (insert DALOS.DALOS|Glyphs "Ğ" { "u" : [196, 158], "c" : "U+011E", "n" : "Latin Capital Letter G with Breve"})
        (insert DALOS.DALOS|Glyphs "Í" { "u" : [195, 141], "c" : "U+00CD", "n" : "Latin Capital Letter I with Acute"})
        (insert DALOS.DALOS|Glyphs "Î" { "u" : [195, 142], "c" : "U+00CE", "n" : "Latin Capital Letter I with Circumflex"})
        (insert DALOS.DALOS|Glyphs "Ï" { "u" : [195, 143], "c" : "U+00CF", "n" : "Latin Capital Letter I with Diaeresis"})
        (insert DALOS.DALOS|Glyphs "Ì" { "u" : [195, 140], "c" : "U+00CC", "n" : "Latin Capital Letter I with Grave"})
        (insert DALOS.DALOS|Glyphs "Ł" { "u" : [197, 129], "c" : "U+0141", "n" : "Latin Capital Letter L with Stroke"})
        (insert DALOS.DALOS|Glyphs "Ń" { "u" : [197, 131], "c" : "U+0143", "n" : "Latin Capital Letter N with Acute"})
        (insert DALOS.DALOS|Glyphs "Ñ" { "u" : [195, 145], "c" : "U+00D1", "n" : "Latin Capital Letter N with Tilde"})
        (insert DALOS.DALOS|Glyphs "Ó" { "u" : [195, 147], "c" : "U+00D3", "n" : "Latin Capital Letter O with Acute"})
        (insert DALOS.DALOS|Glyphs "Ô" { "u" : [195, 148], "c" : "U+00D4", "n" : "Latin Capital Letter O with Circumflex"})
        (insert DALOS.DALOS|Glyphs "Ö" { "u" : [195, 150], "c" : "U+00D6", "n" : "Latin Capital Letter O with Diaeresis"})
        (insert DALOS.DALOS|Glyphs "Ò" { "u" : [195, 146], "c" : "U+00D2", "n" : "Latin Capital Letter O with Grave"})
        (insert DALOS.DALOS|Glyphs "Ø" { "u" : [195, 152], "c" : "U+00D8", "n" : "Latin Capital Letter O with Stroke"})
        (insert DALOS.DALOS|Glyphs "Õ" { "u" : [195, 149], "c" : "U+00D5", "n" : "Latin Capital Letter O with Tilde"})
        (insert DALOS.DALOS|Glyphs "Ř" { "u" : [197, 152], "c" : "U+0158", "n" : "Latin Capital Letter R with Caron"})
        (insert DALOS.DALOS|Glyphs "Ś" { "u" : [197, 154], "c" : "U+015A", "n" : "Latin Capital Letter S with Acute"})
        (insert DALOS.DALOS|Glyphs "Š" { "u" : [197, 160], "c" : "U+0160", "n" : "Latin Capital Letter S with Caron"})
        (insert DALOS.DALOS|Glyphs "Ş" { "u" : [197, 158], "c" : "U+015E", "n" : "Latin Capital Letter S with Cedilla"})
        (insert DALOS.DALOS|Glyphs "Ș" { "u" : [200, 152], "c" : "U+0218", "n" : "Latin Capital Letter S with Comma Below"})
        (insert DALOS.DALOS|Glyphs "Þ" { "u" : [195, 158], "c" : "U+00DE", "n" : "Latin Capital Letter Thorn"})
        (insert DALOS.DALOS|Glyphs "Ť" { "u" : [197, 164], "c" : "U+0164", "n" : "Latin Capital Letter T with Caron"})
        (insert DALOS.DALOS|Glyphs "Ț" { "u" : [200, 154], "c" : "U+021A", "n" : "Latin Capital Letter T with Comma Below"})
        (insert DALOS.DALOS|Glyphs "Ú" { "u" : [195, 154], "c" : "U+00DA", "n" : "Latin Capital Letter U with Acute"})
        (insert DALOS.DALOS|Glyphs "Û" { "u" : [195, 155], "c" : "U+00DB", "n" : "Latin Capital Letter U with Circumflex"})
        (insert DALOS.DALOS|Glyphs "Ü" { "u" : [195, 156], "c" : "U+00DC", "n" : "Latin Capital Letter U with Diaeresis"})
        (insert DALOS.DALOS|Glyphs "Ù" { "u" : [195, 153], "c" : "U+00D9", "n" : "Latin Capital Letter U with Grave"})
        (insert DALOS.DALOS|Glyphs "Ů" { "u" : [197, 174], "c" : "U+016E", "n" : "Latin Capital Letter U with Ring Above"})
        (insert DALOS.DALOS|Glyphs "Ý" { "u" : [195, 157], "c" : "U+00DD", "n" : "Latin Capital Letter Y with Acute"})
        (insert DALOS.DALOS|Glyphs "Ÿ" { "u" : [195, 184], "c" : "U+00DC", "n" : "Latin Capital Letter U with Diaeresis"})
        (insert DALOS.DALOS|Glyphs "Ź" { "u" : [197, 185], "c" : "U+0179", "n" : "Latin Capital Letter Z with Acute"})
        (insert DALOS.DALOS|Glyphs "Ž" { "u" : [197, 189], "c" : "U+017D", "n" : "Latin Capital Letter Z with Caron"})
        (insert DALOS.DALOS|Glyphs "Ż" { "u" : [197, 187], "c" : "U+017B", "n" : "Latin Capital Letter Z with Dot Above"})
        ;;Latin Extended Minuscules - 54 Glyphs
        (insert DALOS.DALOS|Glyphs "æ" { "u" : [195, 166], "c" : "U+00E6", "n" : "Latin Small Letter Ae"})
        (insert DALOS.DALOS|Glyphs "œ" { "u" : [197, 147], "c" : "U+0153", "n" : "Latin Small Letter Oe"})
        (insert DALOS.DALOS|Glyphs "á" { "u" : [195, 161], "c" : "U+00E1", "n" : "Latin Small Letter A with Acute"})
        (insert DALOS.DALOS|Glyphs "ă" { "u" : [196, 131], "c" : "U+0103", "n" : "Latin Small Letter A with Breve"})
        (insert DALOS.DALOS|Glyphs "â" { "u" : [195, 162], "c" : "U+00E2", "n" : "Latin Small Letter A with Circumflex"})
        (insert DALOS.DALOS|Glyphs "ä" { "u" : [195, 164], "c" : "U+00E4", "n" : "Latin Small Letter A with Diaeresis"})
        (insert DALOS.DALOS|Glyphs "à" { "u" : [195, 160], "c" : "U+00E0", "n" : "Latin Small Letter A with Grave"})
        (insert DALOS.DALOS|Glyphs "ą" { "u" : [196, 133], "c" : "U+0105", "n" : "Latin Small Letter A with Ogonek"})
        (insert DALOS.DALOS|Glyphs "å" { "u" : [195, 165], "c" : "U+00E5", "n" : "Latin Small Letter A with Ring Above"})
        (insert DALOS.DALOS|Glyphs "ã" { "u" : [195, 163], "c" : "U+00E3", "n" : "Latin Small Letter A with Tilde"})
        (insert DALOS.DALOS|Glyphs "ć" { "u" : [196, 135], "c" : "U+0107", "n" : "Latin Small Letter C with Acute"})
        (insert DALOS.DALOS|Glyphs "č" { "u" : [196, 141], "c" : "U+010D", "n" : "Latin Small Letter C with Caron"})
        (insert DALOS.DALOS|Glyphs "ç" { "u" : [195, 167], "c" : "U+00E7", "n" : "Latin Small Letter C with Cedilla"})
        (insert DALOS.DALOS|Glyphs "ď" { "u" : [196, 143], "c" : "U+010F", "n" : "Latin Small Letter D with Caron"})
        (insert DALOS.DALOS|Glyphs "đ" { "u" : [196, 145], "c" : "U+0111", "n" : "Latin Small Letter D with Stroke"})
        (insert DALOS.DALOS|Glyphs "é" { "u" : [195, 169], "c" : "U+00E9", "n" : "Latin Small Letter E with Acute"})
        (insert DALOS.DALOS|Glyphs "ě" { "u" : [196, 155], "c" : "U+011B", "n" : "Latin Small Letter E with Caron"})
        (insert DALOS.DALOS|Glyphs "ê" { "u" : [195, 170], "c" : "U+00EA", "n" : "Latin Small Letter E with Circumflex"})
        (insert DALOS.DALOS|Glyphs "ë" { "u" : [195, 171], "c" : "U+00EB", "n" : "Latin Small Letter E with Diaeresis"})
        (insert DALOS.DALOS|Glyphs "è" { "u" : [195, 168], "c" : "U+00E8", "n" : "Latin Small Letter E with Grave"})
        (insert DALOS.DALOS|Glyphs "ę" { "u" : [196, 153], "c" : "U+0119", "n" : "Latin Small Letter E with Ogonek"})
        (insert DALOS.DALOS|Glyphs "ğ" { "u" : [196, 159], "c" : "U+011F", "n" : "Latin Small Letter G with Breve"})
        (insert DALOS.DALOS|Glyphs "í" { "u" : [195, 173], "c" : "U+00ED", "n" : "Latin Small Letter I with Acute"})
        (insert DALOS.DALOS|Glyphs "î" { "u" : [195, 174], "c" : "U+00EE", "n" : "Latin Small Letter I with Circumflex"})
        (insert DALOS.DALOS|Glyphs "ï" { "u" : [195, 175], "c" : "U+00EF", "n" : "Latin Small Letter I with Diaeresis"})
        (insert DALOS.DALOS|Glyphs "ì" { "u" : [195, 172], "c" : "U+00EC", "n" : "Latin Small Letter I with Grave"})
        (insert DALOS.DALOS|Glyphs "ł" { "u" : [197, 130], "c" : "U+0142", "n" : "Latin Small Letter L with Stroke"})
        (insert DALOS.DALOS|Glyphs "ń" { "u" : [197, 132], "c" : "U+0144", "n" : "Latin Small Letter N with Acute"})
        (insert DALOS.DALOS|Glyphs "ñ" { "u" : [195, 177], "c" : "U+00F1", "n" : "Latin Small Letter N with Tilde"})
        (insert DALOS.DALOS|Glyphs "ó" { "u" : [195, 179], "c" : "U+00F3", "n" : "Latin Small Letter O with Acute"})
        (insert DALOS.DALOS|Glyphs "ô" { "u" : [195, 180], "c" : "U+00F4", "n" : "Latin Small Letter O with Circumflex"})
        (insert DALOS.DALOS|Glyphs "ö" { "u" : [195, 182], "c" : "U+00F6", "n" : "Latin Small Letter O with Diaeresis"})
        (insert DALOS.DALOS|Glyphs "ò" { "u" : [195, 178], "c" : "U+00F2", "n" : "Latin Small Letter O with Grave"})
        (insert DALOS.DALOS|Glyphs "ø" { "u" : [195, 184], "c" : "U+00F8", "n" : "Latin Small Letter O with Stroke"})
        (insert DALOS.DALOS|Glyphs "õ" { "u" : [195, 181], "c" : "U+00F5", "n" : "Latin Small Letter O with Tilde"})
        (insert DALOS.DALOS|Glyphs "ř" { "u" : [197, 153], "c" : "U+0159", "n" : "Latin Small Letter R with Caron"})
        (insert DALOS.DALOS|Glyphs "ś" { "u" : [197, 155], "c" : "U+015B", "n" : "Latin Small Letter S with Acute"})
        (insert DALOS.DALOS|Glyphs "š" { "u" : [197, 161], "c" : "U+0161", "n" : "Latin Small Letter S with Caron"})
        (insert DALOS.DALOS|Glyphs "ş" { "u" : [197, 159], "c" : "U+015F", "n" : "Latin Small Letter S with Cedilla"})
        (insert DALOS.DALOS|Glyphs "ș" { "u" : [200, 153], "c" : "U+0219", "n" : "Latin Small Letter S with Comma Below"})
        (insert DALOS.DALOS|Glyphs "þ" { "u" : [195, 190], "c" : "U+00FE", "n" : "Latin Small Letter Thorn"})
        (insert DALOS.DALOS|Glyphs "ť" { "u" : [197, 165], "c" : "U+0165", "n" : "Latin Small Letter T with Caron"})
        (insert DALOS.DALOS|Glyphs "ț" { "u" : [200, 155], "c" : "U+021B", "n" : "Latin Small Letter T with Comma Below"})
        (insert DALOS.DALOS|Glyphs "ú" { "u" : [195, 186], "c" : "U+00FA", "n" : "Latin Small Letter U with Acute"})
        (insert DALOS.DALOS|Glyphs "û" { "u" : [195, 187], "c" : "U+00FB", "n" : "Latin Small Letter U with Circumflex"})
        (insert DALOS.DALOS|Glyphs "ü" { "u" : [195, 188], "c" : "U+00FC", "n" : "Latin Small Letter U with Diaeresis"})
        (insert DALOS.DALOS|Glyphs "ù" { "u" : [195, 185], "c" : "U+00F9", "n" : "Latin Small Letter U with Grave"})
        (insert DALOS.DALOS|Glyphs "ů" { "u" : [197, 175], "c" : "U+016F", "n" : "Latin Small Letter U with Ring Above"})
        (insert DALOS.DALOS|Glyphs "ý" { "u" : [195, 189], "c" : "U+00FD", "n" : "Latin Small Letter Y with Acute"})
        (insert DALOS.DALOS|Glyphs "ÿ" { "u" : [195, 191], "c" : "U+00FF", "n" : "Latin Small Letter Y with Diaeresis"})
        (insert DALOS.DALOS|Glyphs "ź" { "u" : [197, 186], "c" : "U+017A", "n" : "Latin Small Letter Z with Acute"})
        (insert DALOS.DALOS|Glyphs "ž" { "u" : [197, 190], "c" : "U+017E", "n" : "Latin Small Letter Z with Caron"})
        (insert DALOS.DALOS|Glyphs "ż" { "u" : [197, 188], "c" : "U+017C", "n" : "Latin Small Letter Z with Dot Above"})
        (insert DALOS.DALOS|Glyphs "ß" { "u" : [195, 159], "c" : "U+00DF", "n" : "Latin Small Letter Sharp S"})
        ;;Greek Majuscules - 10 Glyphs
        (insert DALOS.DALOS|Glyphs "Γ" { "u" : [206, 147], "c" : "U+0393", "n" : "Greek Capital Letter Gamma"})
        (insert DALOS.DALOS|Glyphs "Δ" { "u" : [206, 148], "c" : "U+0394", "n" : "Greek Capital Letter Delta"})
        (insert DALOS.DALOS|Glyphs "Θ" { "u" : [206, 152], "c" : "U+0398", "n" : "Greek Capital Letter Theta"})
        (insert DALOS.DALOS|Glyphs "Λ" { "u" : [206, 155], "c" : "U+039B", "n" : "Greek Capital Letter Lambda"})
        (insert DALOS.DALOS|Glyphs "Ξ" { "u" : [206, 158], "c" : "U+039E", "n" : "Greek Capital Letter Xi"})
        (insert DALOS.DALOS|Glyphs "Π" { "u" : [206, 160], "c" : "U+03A0", "n" : "Greek Capital Letter Pi"})
        (insert DALOS.DALOS|Glyphs "Σ" { "u" : [206, 163], "c" : "U+03A3", "n" : "Greek Capital Letter Sigma"})
        (insert DALOS.DALOS|Glyphs "Φ" { "u" : [206, 166], "c" : "U+03A6", "n" : "Greek Capital Letter Phi"})
        (insert DALOS.DALOS|Glyphs "Ψ" { "u" : [206, 168], "c" : "U+03A8", "n" : "Greek Capital Letter Psi"})
        (insert DALOS.DALOS|Glyphs "Ω" { "u" : [206, 169], "c" : "U+03A9", "n" : "Greek Capital Letter Omega"})
        ;;Greek Minuscules - 19 Glyphs
        (insert DALOS.DALOS|Glyphs "α" { "u" : [206, 177], "c" : "U+03B1", "n" : "Greek Small Letter Alpha"})
        (insert DALOS.DALOS|Glyphs "β" { "u" : [206, 178], "c" : "U+03B2", "n" : "Greek Small Letter Beta"})
        (insert DALOS.DALOS|Glyphs "γ" { "u" : [206, 179], "c" : "U+03B3", "n" : "Greek Small Letter Gamma"})
        (insert DALOS.DALOS|Glyphs "δ" { "u" : [206, 180], "c" : "U+03B4", "n" : "Greek Small Letter Delta"})
        (insert DALOS.DALOS|Glyphs "ε" { "u" : [206, 181], "c" : "U+03B5", "n" : "Greek Small Letter Epsilon"})
        (insert DALOS.DALOS|Glyphs "ζ" { "u" : [206, 182], "c" : "U+03B6", "n" : "Greek Small Letter Zeta"})
        (insert DALOS.DALOS|Glyphs "η" { "u" : [206, 183], "c" : "U+03B7", "n" : "Greek Small Letter Eta"})
        (insert DALOS.DALOS|Glyphs "θ" { "u" : [206, 184], "c" : "U+03B8", "n" : "Greek Small Letter Theta"})
        (insert DALOS.DALOS|Glyphs "ι" { "u" : [206, 185], "c" : "U+03B9", "n" : "Greek Small Letter Iota"})
        (insert DALOS.DALOS|Glyphs "κ" { "u" : [206, 186], "c" : "U+03BA", "n" : "Greek Small Letter Kappa"})
        (insert DALOS.DALOS|Glyphs "λ" { "u" : [206, 187], "c" : "U+03BB", "n" : "Greek Small Letter Lambda"})
        (insert DALOS.DALOS|Glyphs "μ" { "u" : [206, 188], "c" : "U+03BC", "n" : "Greek Small Letter Mu"})
        (insert DALOS.DALOS|Glyphs "ν" { "u" : [206, 189], "c" : "U+03BD", "n" : "Greek Small Letter Nu"})
        (insert DALOS.DALOS|Glyphs "ξ" { "u" : [206, 190], "c" : "U+03BE", "n" : "Greek Small Letter Xi"})
        (insert DALOS.DALOS|Glyphs "π" { "u" : [206, 192], "c" : "U+03C0", "n" : "Greek Small Letter Pi"})
        (insert DALOS.DALOS|Glyphs "ρ" { "u" : [206, 193], "c" : "U+03C1", "n" : "Greek Small Letter Rho"})
        (insert DALOS.DALOS|Glyphs "σ" { "u" : [206, 195], "c" : "U+03C3", "n" : "Greek Small Letter Sigma"})
        (insert DALOS.DALOS|Glyphs "ς" { "u" : [206, 194], "c" : "U+03C2", "n" : "Greek Small Letter Final Sigma"})
        (insert DALOS.DALOS|Glyphs "τ" { "u" : [206, 196], "c" : "U+03C4", "n" : "Greek Small Letter Tau"})
        (insert DALOS.DALOS|Glyphs "φ" { "u" : [206, 198], "c" : "U+03C6", "n" : "Greek Small Letter Phi"})
        (insert DALOS.DALOS|Glyphs "χ" { "u" : [206, 199], "c" : "U+03C7", "n" : "Greek Small Letter Chi"})
        (insert DALOS.DALOS|Glyphs "ψ" { "u" : [206, 200], "c" : "U+03C8", "n" : "Greek Small Letter Psi"})
        (insert DALOS.DALOS|Glyphs "ω" { "u" : [206, 201], "c" : "U+03C9", "n" : "Greek Small Letter Omega"})
        ;;Cyrillic Majuscules - 19 Glyphs
        (insert DALOS.DALOS|Glyphs "Б" { "u" : [208, 145], "c" : "U+0411", "n" : "Cyrillic Capital Letter Be"})
        (insert DALOS.DALOS|Glyphs "Д" { "u" : [208, 148], "c" : "U+0414", "n" : "Cyrillic Capital Letter De"})
        (insert DALOS.DALOS|Glyphs "Ж" { "u" : [208, 150], "c" : "U+0416", "n" : "Cyrillic Capital Letter Zhe"})
        (insert DALOS.DALOS|Glyphs "З" { "u" : [208, 151], "c" : "U+0417", "n" : "Cyrillic Capital Letter Ze"})
        (insert DALOS.DALOS|Glyphs "И" { "u" : [208, 152], "c" : "U+0418", "n" : "Cyrillic Capital Letter I"})
        (insert DALOS.DALOS|Glyphs "Й" { "u" : [208, 153], "c" : "U+0419", "n" : "Cyrillic Capital Letter Short I"})
        (insert DALOS.DALOS|Glyphs "Л" { "u" : [208, 155], "c" : "U+041B", "n" : "Cyrillic Capital Letter El"})
        (insert DALOS.DALOS|Glyphs "П" { "u" : [208, 159], "c" : "U+041F", "n" : "Cyrillic Capital Letter Pe"})
        (insert DALOS.DALOS|Glyphs "У" { "u" : [208, 163], "c" : "U+0423", "n" : "Cyrillic Capital Letter U"})
        (insert DALOS.DALOS|Glyphs "Ц" { "u" : [208, 166], "c" : "U+0426", "n" : "Cyrillic Capital Letter Tse"})
        (insert DALOS.DALOS|Glyphs "Ч" { "u" : [208, 167], "c" : "U+0427", "n" : "Cyrillic Capital Letter Che"})
        (insert DALOS.DALOS|Glyphs "Ш" { "u" : [208, 168], "c" : "U+0428", "n" : "Cyrillic Capital Letter Sha"})
        (insert DALOS.DALOS|Glyphs "Щ" { "u" : [208, 169], "c" : "U+0429", "n" : "Cyrillic Capital Letter Shcha"})
        (insert DALOS.DALOS|Glyphs "Ъ" { "u" : [208, 170], "c" : "U+042A", "n" : "Cyrillic Capital Letter Hard Sign"})
        (insert DALOS.DALOS|Glyphs "Ы" { "u" : [208, 171], "c" : "U+042B", "n" : "Cyrillic Capital Letter Yeru"})
        (insert DALOS.DALOS|Glyphs "Ь" { "u" : [208, 172], "c" : "U+042C", "n" : "Cyrillic Capital Letter Soft Sign"})
        (insert DALOS.DALOS|Glyphs "Э" { "u" : [208, 173], "c" : "U+042D", "n" : "Cyrillic Capital Letter E"})
        (insert DALOS.DALOS|Glyphs "Ю" { "u" : [208, 174], "c" : "U+042E", "n" : "Cyrillic Capital Letter Yu"})
        (insert DALOS.DALOS|Glyphs "Я" { "u" : [208, 175], "c" : "U+042F", "n" : "Cyrillic Capital Letter Ya"})
        ;;Cyrillic Minuscules - 25 Glyphs
        (insert DALOS.DALOS|Glyphs "б" { "u" : [208, 177], "c" : "U+0431", "n" : "Cyrillic Small Letter Be"})
        (insert DALOS.DALOS|Glyphs "в" { "u" : [208, 178], "c" : "U+0432", "n" : "Cyrillic Small Letter Ve"})
        (insert DALOS.DALOS|Glyphs "д" { "u" : [208, 180], "c" : "U+0434", "n" : "Cyrillic Small Letter De"})
        (insert DALOS.DALOS|Glyphs "ж" { "u" : [208, 182], "c" : "U+0436", "n" : "Cyrillic Small Letter Zhe"})
        (insert DALOS.DALOS|Glyphs "з" { "u" : [208, 183], "c" : "U+0437", "n" : "Cyrillic Small Letter Ze"})
        (insert DALOS.DALOS|Glyphs "и" { "u" : [208, 184], "c" : "U+0438", "n" : "Cyrillic Small Letter I"})
        (insert DALOS.DALOS|Glyphs "й" { "u" : [208, 185], "c" : "U+0439", "n" : "Cyrillic Small Letter Short I"})
        (insert DALOS.DALOS|Glyphs "к" { "u" : [208, 186], "c" : "U+043A", "n" : "Cyrillic Small Letter Ka"})
        (insert DALOS.DALOS|Glyphs "л" { "u" : [208, 187], "c" : "U+043B", "n" : "Cyrillic Small Letter El"})
        (insert DALOS.DALOS|Glyphs "м" { "u" : [208, 188], "c" : "U+043C", "n" : "Cyrillic Small Letter Em"})
        (insert DALOS.DALOS|Glyphs "н" { "u" : [208, 189], "c" : "U+043D", "n" : "Cyrillic Small Letter En"})
        (insert DALOS.DALOS|Glyphs "п" { "u" : [208, 191], "c" : "U+043F", "n" : "Cyrillic Small Letter Pe"})
        (insert DALOS.DALOS|Glyphs "т" { "u" : [209, 130], "c" : "U+0442", "n" : "Cyrillic Small Letter Te"})
        (insert DALOS.DALOS|Glyphs "у" { "u" : [209, 131], "c" : "U+0443", "n" : "Cyrillic Small Letter U"})
        (insert DALOS.DALOS|Glyphs "ф" { "u" : [209, 132], "c" : "U+0444", "n" : "Cyrillic Small Letter Ef"})
        (insert DALOS.DALOS|Glyphs "ц" { "u" : [209, 134], "c" : "U+0446", "n" : "Cyrillic Small Letter Tse"})
        (insert DALOS.DALOS|Glyphs "ч" { "u" : [209, 135], "c" : "U+0447", "n" : "Cyrillic Small Letter Che"})
        (insert DALOS.DALOS|Glyphs "ш" { "u" : [209, 136], "c" : "U+0448", "n" : "Cyrillic Small Letter Sha"})
        (insert DALOS.DALOS|Glyphs "щ" { "u" : [209, 137], "c" : "U+0449", "n" : "Cyrillic Small Letter Shcha"})
        (insert DALOS.DALOS|Glyphs "ъ" { "u" : [209, 138], "c" : "U+044A", "n" : "Cyrillic Small Letter Hard Sign"})
        (insert DALOS.DALOS|Glyphs "ы" { "u" : [209, 139], "c" : "U+044B", "n" : "Cyrillic Small Letter Yeru"})
        (insert DALOS.DALOS|Glyphs "ь" { "u" : [209, 140], "c" : "U+044C", "n" : "Cyrillic Small Letter Soft Sign"})
        (insert DALOS.DALOS|Glyphs "э" { "u" : [209, 141], "c" : "U+044D", "n" : "Cyrillic Small Letter E"})
        (insert DALOS.DALOS|Glyphs "ю" { "u" : [209, 142], "c" : "U+044E", "n" : "Cyrillic Small Letter Yu"})
        (insert DALOS.DALOS|Glyphs "я" { "u" : [209, 143], "c" : "U+044F", "n" : "Cyrillic Small Letter Ya"})
    )
    ;;=========================================================================;;
    ;;
    ;;
    ;;
    ;;========[P] PRINT-FUNCTIONS==============================================;;
    (defun DALOS|UP_AccountProperties (account:string)
        @doc "Prints DALOS Account <account> Properties"
        (let* 
            (
                (p:[bool] (DALOS.DALOS|UR_AccountProperties account))
                (a:bool (at 0 p))
                (b:bool (at 1 p))
                (c:bool (at 2 p))
            )
            (if (= a true)
                (format "Account {} is a Smart Account: Payable: {}; Payable by Smart Account: {}." [account b c])
                (format "Account {} is a Normal Account" [account])
            )
        )
    )
    (defun ATS|UP_P0 (atspair:string account:string)
        @doc "Prints Data of the P0 Position ofr <atspair> and <account>"
        (format "{}|{} P0: {}" [atspair account (AUTOSTAKE.ATS|UR_P0 atspair account)])
    )
    (defun ATS|UP_P1 (atspair:string account:string)
        @doc "Prints Data of the P1 Position ofr <atspair> and <account>"
        (format "{}|{} P1: {}" [atspair account (AUTOSTAKE.ATS|UR_P1-7 atspair account 1)])
    )
    (defun ATS|UP_P2 (atspair:string account:string)
        @doc "Prints Data of the P2 Position ofr <atspair> and <account>"
        (format "{}|{} P2: {}" [atspair account (AUTOSTAKE.ATS|UR_P1-7 atspair account 2)])
    )
    (defun ATS|UP_P3 (atspair:string account:string)
        @doc "Prints Data of the P3 Position ofr <atspair> and <account>"
        (format "{}|{} P3: {}" [atspair account (AUTOSTAKE.ATS|UR_P1-7 atspair account 3)])
    )
    (defun ATS|UP_P4 (atspair:string account:string)
        @doc "Prints Data of the P4 Position ofr <atspair> and <account>"
        (format "{}|{} P4: {}" [atspair account (AUTOSTAKE.ATS|UR_P1-7 atspair account 4)])
    )
    (defun ATS|UP_P5 (atspair:string account:string)
        @doc "Prints Data of the P5 Position ofr <atspair> and <account>"
        (format "{}|{} P5: {}" [atspair account (AUTOSTAKE.ATS|UR_P1-7 atspair account 5)])
    )
    (defun ATS|UP_P6 (atspair:string account:string)
        @doc "Prints Data of the P6 Position ofr <atspair> and <account>"
        (format "{}|{} P6: {}" [atspair account (AUTOSTAKE.ATS|UR_P1-7 atspair account 6)])
    )
    (defun ATS|UP_P7 (atspair:string account:string)
        @doc "Prints Data of the P7 Position ofr <atspair> and <account>"
        (format "{}|{} P7: {}" [atspair account (AUTOSTAKE.ATS|UR_P1-7 atspair account 7)])
    )
)

