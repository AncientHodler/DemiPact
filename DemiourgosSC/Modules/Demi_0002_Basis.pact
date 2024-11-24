(module BASIS GOVERNANCE
    @doc "Demiourgos 0002 Module - BASIS (DPTF and DPMF Module) \
    \ Module 2 containing Most of True Fungible and Meta Fungible Functionality \
    \ \
    \ \
    \ Smart DALOS Accounts governed by the Module (0) \
    \ \
    \ 0)NONE \
    \ BASIS Submodules: \
    \ \
    \ DALOS DPTF-DPMF DPTF DPMF IGNIS"

    ;;Module Governance
    (defcap GOVERNANCE ()
        (compose-capability (BASIS-ADMIN))
    )
    (defcap BASIS-ADMIN ()
        (enforce-guard G_BASIS)
    )
    ;;Module Guards
    (defconst G_BASIS   (keyset-ref-guard BASIS|DEMIURGOI))
    ;;Module Keys
    (defconst BASIS|DEMIURGOI "free.DH_Master-Keyset")
    ;;Module Accounts Information - NONE
    ;;External Module Usage
    (use free.UTILS)
    (use free.DALOS)

    ;;
    ;;
    ;;


    ;;Simple True Capabilities (10+1)
    (defcap COMPOSE ()
        @doc "Usage: composing multiple functions in an IF statement"
        true
    )
    ;;
    (defcap ATS|UPDATE_RBT ()
        @doc "Usage: updating <reward-bearing-token> data"
        true
    )
    (defcap DALOS|EXECUTOR ()
        @doc "Usage: executing functions that have methodic counterparts"
        true
    )
    (defcap DPMF|CREDIT ()
        @doc "Usage: DPMF crediting"
        true
    )
    (defcap DPMF|DEBIT ()
        @doc "Usage: DPMF debiting"
        true
    )
    (defcap DPMF|DEBIT_PUR ()
        @doc "Usage: Pure DPMF debiting"
        true
    )
    (defcap DPMF|INCREMENT_NONCE ()
        @doc "Usage: incremending DPMF nonce"
        true
    )
    (defcap DPTF|BURN ()
        @doc "Usage: DPTF burning"
        true
    )
    (defcap DPTF|CREDIT ()
        @doc "Usage: DPTF crediting"
        true
    )
    (defcap DPTF|CREDIT_PUR ()
        @doc "Usage: Pure DPTF crediting"
        true
    )
    (defcap DPTF|DEBIT ()
        @doc "Usage: DPTF debiting"
        true
    )
    (defcap DPTF|DEBIT_PUR ()
        @doc "Usage: Pure DPTF debiting"
        true
    )
    (defcap DPTF|INCREMENT-LOCKS ()
        @doc "Usage: incrementing <fee-unlocks> DPTF Data"
        true
    )
    (defcap DPTF|UPDATE_FEES_PUR ()
        @doc "Usage: Pure updating <primary-fee-volume> or <secondary-fee-volume>"
        true
    )
    (defcap DPTF|UPDATE_RT ()
        @doc "Usage: updating <reward-token> DPTF Data"
        true
    )
    (defcap DPTF-DPMF|UPDATE_ROLE-TRANSFER-AMOUNT ()
        @doc "Usage: updating <role-transfer-amount> for DPTF and DPMF Tokens"
        true
    )
    (defcap DPTF-DPMF|UPDATE_SUPPLY () 
        @doc "Usage: updating <supply> for DPTF and DPMF Tokens"
        true
    )
    (defcap VST|UPDATE ()
        @doc "Usage: updating <vesting> for DPTF and DPMF Tokens"
        true
    )
    ;; POLICY Capabilities
    (defcap P|DALOS|INCREMENT_NONCE ()
        @doc "Policy allowing usage of <DALOS.DALOS|X_IncrementNonce>"
        true
    )
    (defcap P|DALOS|UP_BALANCE ()
        @doc "Policy allowing usage of <DALOS.DALOS|XO_UpdateBalance>"
        true
    )
    (defcap P|DALOS|UP_DATA ()
        @doc "Policy allowing usage of: \
        \ <DALOS.DALOS|XO_UpdateBurnRole> \
        \ <DALOS.DALOS|XO_UpdateMintRole> \
        \ <DALOS.DALOS|XO_UpdateTransferRole> \
        \ <DALOS.DALOS|XO_UpdateFeeExemptionRole> \
        \ <DALOS.DALOS|XO_UpdateFreeze>"
        true
    )
    (defcap P|DALOS|UPDATE_ELITE ()
        @doc "Policy allowing usage of <DALOS.DALOS|X_UpdateElite>"
        true
    )
    (defcap P|IGNIS|COLLECTER ()
        @doc "Policy allowing usage of <DALOS.IGNIS|X_Collect>"
        true
    )
    ;;Combined Policy Capabilities
    (defcap P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER ()
        @doc "Dual Capability for simple usage"
        (compose-capability (P|DALOS|INCREMENT_NONCE))
        (compose-capability (P|IGNIS|COLLECTER))
    )
    (defcap DPTF|CLIENT_BURN ()
        @doc "Capability neeed to use the Client Burn Function for DPTF Tokens"
        (compose-capability (DPTF|BURN))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )

    ;;Policies

    (defun BASIS|A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (BASIS-ADMIN)
            (write BASIS|PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun BASIS|C_ReadPolicy:guard (policy-name:string)
        @doc "Reads the guard of a stored policy"
        (at "policy" (read BASIS|PoliciesTable policy-name ["policy"]))
    )

    (defun BASIS|DefinePolicies ()
        @doc "Add the Policy that allows running external Functions from this Module"
        (DALOS.DALOS|A_AddPolicy 
            "BASIS|IncrementDalosNonce"
            (create-capability-guard (P|DALOS|INCREMENT_NONCE))           ;;  DALOS.DALOS|X_IncrementNonce
        )
        (DALOS.DALOS|A_AddPolicy 
            "BASIS|UpdatePrimordialBalance"
            (create-capability-guard (P|DALOS|UP_BALANCE))                ;;  DALOS.DALOS|XO_UpdateBalance
        )
        (DALOS.DALOS|A_AddPolicy 
            "BASIS|UpdatePrimordialData"
            (create-capability-guard (P|DALOS|UP_DATA))                   ;;  DALOS.DALOS|XO_UpdateBurnRole
        )                                                                 ;;  DALOS.DALOS|XO_UpdateMintRole
                                                                          ;;  DALOS.DALOS|XO_UpdateTransferRole
                                                                          ;;  DALOS.DALOS|XO_UpdateFeeExemptionRole
                                                                          ;;  DALOS.DALOS|XO_UpdateFreeze
        (DALOS.DALOS|A_AddPolicy 
            "BASIS|UpdateElite"
            (create-capability-guard (P|DALOS|UPDATE_ELITE))              ;;  DALOS.DALOS|X_UpdateElite
        )
        (DALOS.DALOS|A_AddPolicy 
            "BASIS|GasCollection"
            (create-capability-guard (P|IGNIS|COLLECTER))                 ;;  DALOS.IGNIS|X_Collect
        )
        
        
    )

;;  1]CONSTANTS Definitions - NONE
;;  2]SCHEMAS Definitions
    (defschema BASIS|PolicySchema
        @doc "Schema that stores external policies, that are able to operate within this module"
        policy:guard
    )
    ;;[T] DPTF Schemas
    (defschema DPTF|PropertiesSchema
        @doc "Schema for DPTF Token (True Fungibles) Properties \
            \ Key for Table is DPTF Token id. This ensure a unique entry per Token id"
        owner-konto:string
        name:string
        ticker:string
        decimals:integer
        ;;TM=Token Manager
        can-change-owner:bool                 
        can-upgrade:bool
        can-add-special-role:bool
        can-freeze:bool
        can-wipe:bool
        can-pause:bool
        is-paused:bool
        ;;Supply
        supply:decimal
        origin-mint:bool
        origin-mint-amount:decimal
        ;;Roles
        role-transfer-amount:integer
        ;;DPTF Fee Management
        fee-toggle:bool
        min-move:decimal
        fee-promile:decimal
        fee-target:string
        fee-lock:bool
        fee-unlocks:integer
        primary-fee-volume:decimal
        secondary-fee-volume:decimal
        ;;Autostake
        reward-token:[string]           ;;The list of strings are the ATS-Pairs the DPTF Token is part of as RT (Reward Token)
                                        ;;A DPTF Token can exist as RT in multiple ATS Pairs
        reward-bearing-token:[string]   ;;The list of strings are the ATS-Pairs the DPTF Token is part of as a cold RBT
                                        ;;A DPTF Token can exists as cold-RBT in multiple ATS Pairs
        ;;Vesting
        vesting:string
    )
    ;;DPTF|BalanceSchema defined in DALOS Module

    ;;[M] DPMF Schemas
    (defschema DPMF|PropertiesSchema
        @doc "Schema for DPMF Token (Meta Fungibles) Properties \
        \ Key for Table is DPMF Token id. This ensure a unique entry per Token id"
        owner-konto:string
        name:string
        ticker:string
        decimals:integer
        ;;TM=Token Manager
        can-change-owner:bool                  
        can-upgrade:bool
        can-add-special-role:bool
        can-freeze:bool
        can-wipe:bool
        can-pause:bool
        is-paused:bool
        can-transfer-nft-create-role:bool
        ;;Supply
        supply:decimal
        ;;Roles
        create-role-account:string
        role-transfer-amount:integer
        ;;Units
        nonces-used:integer
        ;;Autostake
        reward-bearing-token:string     ;;String is an ATS Pair the DPMF Token is part of as a Hot-RBT.
                                        ;;A DPMF can exist as hot-RBT in a single ATS Pair
        ;;Vesting
        vesting:string
    )
    (defschema DPMF|BalanceSchema
        @doc "Schema that Stores Account Balances for DPMF Tokens (Meta Fungibles)\
            \ Key for the Table is a string composed of: <DPMF id> + UTILS.BAR + <account> \
            \ This ensure a single entry per DPMF id per account."

        unit:[object{DPMF|Schema}]
        ;;Special Roles
        role-nft-add-quantity:bool
        role-nft-burn:bool
        role-nft-create:bool
        role-transfer:bool
        ;;States
        frozen:bool
    )
    (defschema DPMF|Schema
        nonce:integer
        balance:decimal
        meta-data:[object]
    )
    ;;Neutral MetaFungible Definition, used for existing MetaFungible Accounts that hold no tokens
    (defconst DPMF|NEUTRAL
        { "nonce": 0
        , "balance": 0.0
        , "meta-data": [{}] }
    )
    ;;Used for non existing MetaFungible Account
    (defconst DPMF|NEGATIVE
        { "nonce": -1
        , "balance": -1.0
        , "meta-data": [{}] }
    )
    (defschema DPMF|Nonce-Balance
        @doc "Schema for Nonce-Balance, used in Multi Debiting, necesarry for wiping"
        nonce:integer
        balance:decimal
    )

;;  3]TABLES Definitions
    (deftable BASIS|PoliciesTable:{BASIS|PolicySchema}) 
    ;;[T] DPTF Tables
    (deftable DPTF|PropertiesTable:{DPTF|PropertiesSchema})
    (deftable DPTF|BalanceTable:{DALOS.DPTF|BalanceSchema})
    ;;[M] DPMF Tables
    (deftable DPMF|PropertiesTable:{DPMF|PropertiesSchema})
    (deftable DPMF|BalanceTable:{DPMF|BalanceSchema})
    ;;
    ;;
    ;;            BASIS             Submodule
    ;;
    ;;            CAPABILITIES      <48>
    ;;            FUNCTIONS         [158]
    ;;========[D] RESTRICTIONS=================================================;;
    ;;        [1] Capabilities FUNCTIONS                [CAP]
    ;;        <1> Function Based & CAPABILITIES         [CF](have this tag)
    ;;       [22] Enforcements & Validations FUNCTIONS  [UEV]
    ;;       <47> Composed CAPABILITIES                 [CC](dont have this tag)
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;       [43] Data Read FUNCTIONS                   [UR]
    ;;       [10] Data Read and Computation FUNCTIONS   [URC] and [UC]
    ;;        [2] Data Creation|Composition Functions   [UCC]
    ;;            Administrative Usage Functions        [A]
    ;;       [23] Client Usage FUNCTIONS                [C]
    ;;       [57] Auxiliary Usage Functions             [X]
    ;;=========================================================================;;
    ;;
    ;;            START
    ;;
    ;;========[D] RESTRICTIONS=================================================;;
    ;;        [1] Capabilities FUNCTIONS                [CAP]
    (defun DPTF-DPMF|CAP_Owner (id:string token-type:bool)
        @doc "Enforces DPTF|DPMF Token Ownership"
        (DALOS.DALOS|CAP_EnforceAccountOwnership (DPTF-DPMF|UR_Konto id token-type))
    )
    ;;        <1> Function Based & CAPABILITIES         [CF](have this tag)
    (defcap DPTF-DPMF|CF|OWNER (id:string token-type:bool)
        @doc "Capability that Enforces DPTF|DPMF Token Ownership"
        (DPTF-DPMF|CAP_Owner id token-type)
    )
    ;;            Enforcements & Validations FUNCTIONS  [UEV]
    (defun ATS|UEV_UpdateRewardBearingToken (id:string token-type:bool)
        @doc "Capability to update the <reward-bearing-token> in the DPTF-DPMF|PropertiesTable"
        (if (= token-type false)
            (let
                (
                    (rbt:string (DPMF|UR_RewardBearingToken id))
                )
                (enforce (= rbt UTILS.BAR) "RBT for a DPMF is immutable")
            )
            true
        )
    )
    (defun DPTF-DPMF|UEV_CanChangeOwnerON (id:string token-type:bool)
        @doc "Enforces DPTF Token ownership is changeble"
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanChangeOwner id token-type))
            )
            (enforce (= x true) (format "DPTF|DPMF Token {} ownership cannot be changed" [id]))
        )
    )
    (defun DPTF-DPMF|UEV_CanUpgradeON (id:string token-type:bool)
        @doc "Enforces DPTF|DPMF Token is upgradeable"
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanUpgrade id token-type))
            )
            (enforce (= x true) (format "DPTF|DPMF Token {} properties cannot be upgraded" [id])
            )
        )
    )
    (defun DPTF-DPMF|UEV_CanAddSpecialRoleON (id:string token-type:bool)
        @doc "Enforces adding special roles for DPTF|DPMF Token is true"
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanAddSpecialRole id token-type))
            )
            (enforce (= x true) (format "For DPTF|DPMF Token {} no special roles can be added" [id])
            )
        )
    )
    (defun DPTF-DPMF|UEV_CanFreezeON (id:string token-type:bool)
        @doc "Enforces DPTF|DPMF Token can be frozen"
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanFreeze id token-type))
            )
            (enforce (= x true) (format "DPTF|DPMF Token {} cannot be freezed" [id])
            )
        )
    )
    (defun DPTF-DPMF|UEV_CanWipeON (id:string token-type:bool)
        @doc "Enforces DPTF|DPMF Token can be wiped"
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanWipe id token-type))
            )
            (enforce (= x true) (format "DPTF|DPMF Token {} cannot be wiped" [id])
            )
        )
    )
    (defun DPTF-DPMF|UEV_CanPauseON (id:string token-type:bool)
        @doc "Enforces DPTF|DPMF Token can be paused"
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanPause id token-type))
            )
            (enforce (= x true) (format "DPTF|DPMF Token {} cannot be paused" [id])
            )
        )
    )
    (defun DPTF-DPMF|UEV_PauseState (id:string state:bool token-type:bool)
        @doc "Enforces DPTF|DPMF Token <is-paused> to <state>"
        (let
            (
                (x:bool (DPTF-DPMF|UR_Paused id token-type))
            )
            (if (= state true)
                (enforce (= x true) (format "DPTF|DPMF Token {} is already unpaused" [id]))
                (enforce (= x false) (format "DPTF|DPMF Token {} is already paused" [id]))
            )
        )
    )
    (defun DPTF-DPMF|UEV_AccountBurnState (id:string account:string state:bool token-type:bool)
        @doc "Enforces DPTF|DPMF Account <role-burn> to <state>"
        (let
            (
                (x:bool (DPTF-DPMF|UR_AccountRoleBurn id account token-type))
            )
            (enforce (= x state) (format "Burn Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    (defun DPTF-DPMF|UEV_AccountTransferState (id:string account:string state:bool token-type:bool)
        @doc "Enforces DPTF Account <role-transfer> to <state>"
        (let
            (
                (x:bool (DPTF-DPMF|UR_AccountRoleTransfer id account token-type))
            )
            (enforce (= x state) (format "Transfer Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    (defun DPTF-DPMF|UEV_AccountFreezeState (id:string account:string state:bool token-type:bool)
        @doc "Enforces DPTF|DPMF Account <frozen> to <state>"
        (let
            (
                (x:bool (DPTF-DPMF|UR_AccountFrozenState id account token-type))
            )
            (enforce (= x state) (format "Frozen for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    (defun DPTF-DPMF|UEV_Amount (id:string amount:decimal token-type:bool)
        @doc "Enforce the minimum denomination for a specific DPTF|DPMF id \
            \ and ensure the amount is greater than zero"
        (let
            (
                (decimals:integer (DPTF-DPMF|UR_Decimals id token-type))
            )
            (enforce
                (= (floor amount decimals) amount)
                (format "The amount of {} does not conform with the {} decimals number" [amount id])
            )
            (enforce
                (> amount 0.0)
                (format "The amount of {} is not a Valid Transaction amount" [amount])
            )
        )
    )
    (defun DPTF-DPMF|UEV_CheckID:bool (id:string token-type:bool)
        @doc "Checks if a DPTF|DPMF Token exists, without enforcements \
        \ Returns true if it does, and false if it doesnt"
        (if token-type
            (with-default-read DPTF|PropertiesTable id
                { "supply" : -1.0 }
                { "supply" := s }
                (if (>= s 0.0)
                    true
                    false
                )
            )
            (with-default-read DPMF|PropertiesTable id
                { "supply" : -1.0 }
                { "supply" := s }
                (if (>= s 0.0)
                    true
                    false
                )
            )
        )
    )
    (defun DPTF-DPMF|UEV_id (id:string token-type:bool)
        @doc "Enforces the True or MetaFungible <id> exists"
        (if token-type
            (with-default-read DPTF|PropertiesTable id
                { "supply" : -1.0 }
                { "supply" := s }
                (enforce
                    (>= s 0.0)
                    (format "DPTF Token with id {} does not exist." [id])
                )
            )
            (with-default-read DPMF|PropertiesTable id
                { "supply" : -1.0 }
                { "supply" := s }
                (enforce
                    (>= s 0.0)
                    (format "DPMF Token with id {} does not exist." [id])
                )
            )
        )
    )
    (defun DPTF|UEV_Virgin (id:string)
        @doc "Enforces Origin Mint hasn't been executed"
        (let
            (
                (om:bool (DPTF|UR_OriginMint id))
                (oma:decimal (DPTF|UR_OriginAmount id))
            )
            (enforce
                (and (= om false) (= oma 0.0))
                (format "Origin Mint for DPTF {} cannot be executed any more !" [id])
            )
        )
    )
    (defun DPTF|UEV_FeeLockState (id:string state:bool)
        @doc "Enforces DPTF Token <fee-lock> to <state>"
        (let
            (
                (x:bool (DPTF|UR_FeeLock id))
            )
            (enforce (= x state) (format "Fee-lock for {} must be set to {} for this operation" [id state]))
        )
    )
    (defun DPTF|UEV_FeeToggleState (id:string state:bool)
        @doc "Enforces DPTF Token <fee-toggle> to <state>"
        (let
            (
                (x:bool (DPTF|UR_FeeToggle id))
            )
            (enforce (= x state) (format "Fee-Toggle for {} must be set to {} for this operation" [id state]))
        )
    )
    (defun DPTF|UEV_AccountMintState (id:string account:string state:bool)
        @doc "Enforces DPTF Account <role-mint> to <state>"
        (let
            (
                (x:bool (DPTF|UR_AccountRoleMint id account))
            )
            (enforce (= x state) (format "Mint Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    (defun DPTF|UEV_AccountFeeExemptionState (id:string account:string state:bool)
        @doc "Enforces DPTF Account <role-fee-exemption> to <state>"
        (let
            (
                (x:bool (DPTF|UR_AccountRoleFeeExemption id account))
            )
            (enforce (= x state) (format "Fee-Exemption Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    (defun DPTF|UEV_EnforceMinimumAmount (id:string transfer-amount:decimal)
        @doc "Enforces the minimum transfer amount for the DPTF Token"
        (let*
            (
                (min-move-read:decimal (DPTF|UR_MinMove id))
                (precision:integer (DPTF-DPMF|UR_Decimals id true))
                (min-move:decimal 
                    (if (= min-move-read -1.0)
                        (floor (/ 1.0 (^ 10.0 (dec precision))) precision)
                        min-move-read
                    )
                )
            )
            (enforce (>= transfer-amount min-move) (format "The transfer-amount of {} is not a valid {} transfer amount" [transfer-amount id]))
        )
    )
    (defun DPMF|UEV_CanTransferNFTCreateRoleON (id:string)
        @doc "Enforces DPMF Property as On"
        (let
            (
                (x:bool (DPMF|UR_CanTransferNFTCreateRole id))
            )
            (enforce (= x true) (format "DPMF Token {} cannot have its create role transfered" [id])
            )
        )
    )
    (defun DPMF|UEV_AccountAddQuantityState (id:string account:string state:bool)
        @doc "Enforces DPMF Property to <state>"
        (let
            (
                (x:bool (DPMF|UR_AccountRoleNFTAQ id account))
            )
            (enforce (= x state) (format "Add Quantity Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    (defun DPMF|UEV_AccountCreateState (id:string account:string state:bool)
        @doc "Enforces DPMF Property to <state>"
        (let
            (
                (x:bool (DPMF|UR_AccountRoleCreate id account))
            )
            (enforce (= x state) (format "Create Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    ;;       <47> Composed CAPABILITIES                 [CC](dont have this tag)
    (defcap DPTF-DPMF|BURN (id:string client:string amount:decimal token-type:bool)
        @doc "Capability required to EXECUTE <DPTF-DPMF|CX_Burn> Function"
        (DALOS.DALOS|CAP_EnforceAccountOwnership client)
        (compose-capability (DPTF-DPMF|X_BURN id client amount token-type))
        (compose-capability (IGNIS|MATRON_SOFT id client))
        (compose-capability (P|DALOS|INCREMENT_NONCE))
    )
    (defcap DPTF-DPMF|X_BURN (id:string client:string amount:decimal token-type:bool)
        @doc "Core Capability required to burn a DPTF|DPMF Token"
        (DPTF-DPMF|UEV_Amount id amount token-type)
        (DPTF-DPMF|UEV_AccountBurnState id client true token-type)
        (if token-type
            (compose-capability (DPTF|DEBIT))
            (compose-capability (DPMF|DEBIT))
        )
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
    )
    (defcap DPTF-DPMF|CONTROL (id:string token-type:bool)
        @doc "Capability required to EXECUTE <DPTF|C_Control>|<DPMF|C_Control> Function"
        (compose-capability (DPTF-DPMF|X_CONTROL id token-type))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap DPTF-DPMF|X_CONTROL (id:string token-type:bool)
        @doc "Core Capability required for managing DPTF|DPMF Properties"
        (DPTF-DPMF|CAP_Owner id token-type)
        (DPTF-DPMF|UEV_CanUpgradeON id token-type)
    )
    (defcap DPTF-DPMF|FROZEN-ACCOUNT (id:string account:string frozen:bool token-type:bool)
        @doc "Capability required to EXECUTE <DPTF-DPMF|C_ToggleFreezeAccount> Function"
        (compose-capability (DPTF-DPMF|X_FROZEN-ACCOUNT id account frozen token-type))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap DPTF-DPMF|X_FROZEN-ACCOUNT (id:string account:string frozen:bool token-type:bool)
        @doc "Core Capability required to toggle freeze for a DPTF|DPMF Account"
        (DPTF-DPMF|CAP_Owner id token-type)
        (DPTF-DPMF|UEV_CanFreezeON id token-type)
        (DPTF-DPMF|UEV_AccountFreezeState id account (not frozen) token-type)
    )
    (defcap DPTF-DPMF|ISSUE ()
        @doc "Capability required to EXECUTE a <DPTF-DPMF|C_Issue> Function"
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap DPTF-DPMF|OWNERSHIP-CHANGE (id:string new-owner:string token-type:bool)
        @doc "Capability required to EXECUTE <DPTF-DPMF|C_ChangeOwnership> Function"
        (compose-capability (DPTF-DPMF|X_OWNERSHIP-CHANGE id new-owner token-type))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap DPTF-DPMF|X_OWNERSHIP-CHANGE (id:string new-owner:string token-type:bool)
        @doc "Core Capability required for changing DPTF|DPMF Ownership"
        (DALOS.DALOS|UEV_SenderWithReceiver (DPTF-DPMF|UR_Konto id token-type) new-owner)
        (DPTF-DPMF|CAP_Owner id token-type)
        (DPTF-DPMF|UEV_CanChangeOwnerON id token-type)
        (DALOS.DALOS|UEV_EnforceAccountExists new-owner)
    )
    (defcap DPTF-DPMF|TOGGLE_BURN-ROLE (id:string account:string toggle:bool token-type:bool)
        @doc "Capability required to EXECUTE <DPTF-DPMF|C_ToggleBurnRole> Function"
        (compose-capability (DPTF-DPMF|X_TOGGLE_BURN-ROLE id account toggle token-type))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap DPTF-DPMF|X_TOGGLE_BURN-ROLE (id:string account:string toggle:bool token-type:bool)
        @doc "Core Capability required to toggle <role-burn> to a DPTF|DPMF Account for a DPTF|DPMF Token"
        (if toggle
            (DPTF-DPMF|UEV_CanAddSpecialRoleON id token-type)
            true
        )
        (DPTF-DPMF|CAP_Owner id token-type)
        (DPTF-DPMF|UEV_AccountBurnState id account (not toggle) token-type)
    )
    (defcap DPTF-DPMF|TOGGLE_PAUSE (id:string pause:bool token-type:bool)
        @doc "Capability required to EXECUTE <DPTF-DPMF|C_TogglePause> Function"
        (compose-capability (DPTF-DPMF|X_TOGGLE_PAUSE id pause token-type))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap DPTF-DPMF|X_TOGGLE_PAUSE (id:string pause:bool token-type:bool)
        @doc "Capability required to toggle pause for a DPTF|DPMF Token"
        (if pause
            (DPTF-DPMF|UEV_CanPauseON id token-type)
            true
        )
        (DPTF-DPMF|CAP_Owner id token-type)
        (DPTF-DPMF|UEV_PauseState id (not pause) token-type)
    )
    (defcap DPTF-DPMF|TOGGLE_TRANSFER-ROLE (patron:string id:string account:string toggle:bool token-type:bool)
        @doc "Capability required to EXECUTE <DPTF-DPMF|C_ToggleTransferRole> Function"
        (compose-capability (DPTF-DPMF|X_TOGGLE_TRANSFER-ROLE id account toggle token-type))
        (compose-capability (DPTF-DPMF|UPDATE_ROLE-TRANSFER-AMOUNT))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap DPTF-DPMF|X_TOGGLE_TRANSFER-ROLE (id:string account:string toggle:bool token-type:bool)
        @doc "Core Capability required to toggle <role-transfer> to a DPTF|DPMF Account for a DPTF|DPMF Token"
        (enforce (!= account DALOS.OUROBOROS|SC_NAME) (format "{} Account is immune to transfer roles" [DALOS.OUROBOROS|SC_NAME]))
        (enforce (!= account DALOS.DALOS|SC_NAME) (format "{} Account is immune to transfer roles" [DALOS.DALOS|SC_NAME]))
        (if toggle
            (DPTF-DPMF|UEV_CanAddSpecialRoleON id token-type)
            true
        )
        (DPTF-DPMF|CAP_Owner id token-type)
        (DPTF-DPMF|UEV_AccountTransferState id account (not toggle) token-type)
    )
    (defcap DPTF-DPMF|WIPE (patron:string id:string account-to-be-wiped:string token-type:bool)
        @doc "Capability required to EXECUTE <DPTF-DPMF|C_Wipe> Function"
        (compose-capability (DPTF-DPMF|X_WIPE id account-to-be-wiped token-type))
        (compose-capability (IGNIS|MATRON_SOFT id account-to-be-wiped))
        (compose-capability (P|DALOS|INCREMENT_NONCE))
    )
    (defcap DPTF-DPMF|X_WIPE (id:string account-to-be-wiped:string token-type:bool)
        @doc "Core Capability required to Wipe a DPTF|DPMF Token Balance from a DPTF|DPMF Account"
        (DPTF-DPMF|UEV_CanWipeON id token-type)
        (DPTF-DPMF|UEV_AccountFreezeState id account-to-be-wiped true token-type)
        (if token-type
            (compose-capability (DPTF|DEBIT))
            (compose-capability (DPMF|DEBIT))
        )
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
    )
    ;;
    (defcap DPTF|MINT (id:string client:string amount:decimal origin:bool)
        @doc "Capability required to EXECUTE <DPTF|C_Mint>|<DPTF|C_Mint> Function \
            \ Master Mint capability, required to mint DPTF Tokens, both as Origin and as Standard Mint"
        (DALOS.DALOS|CAP_EnforceAccountOwnership client)
        (if origin
            (compose-capability (DPTF|MINT-ORIGIN id client amount))
            (compose-capability (DPTF|MINT-STANDARD id client amount))
        )
    )
    (defcap DPTF|MINT-ORIGIN (id:string client:string amount:decimal)
        @doc "Capability required to mint the Origin DPTF Mint Supply"

        (compose-capability (DPTF|X_MINT-ORIGIN id amount))
        (compose-capability (IGNIS|MATRON_SOFT id client))
        (compose-capability (P|DALOS|INCREMENT_NONCE))
    )
    (defcap DPTF|X_MINT-ORIGIN (id:string amount:decimal)
        @doc "Core Capability required to mint the Origin DPTF Mint Supply"  
        (DPTF-DPMF|CAP_Owner id true)
        (DPTF|UEV_Virgin id)
        (compose-capability (DPTF|MINT_GENERAL id amount))
    )
    (defcap DPTF|MINT-STANDARD (id:string client:string amount:decimal)
        @doc "Capability required to mint a DPTF  Token"
        (compose-capability (DPTF|X_MINT-STANDARD id client amount))
        (compose-capability (IGNIS|MATRON_SOFT id client))
        (compose-capability (P|DALOS|INCREMENT_NONCE))
    )
    (defcap DPTF|X_MINT-STANDARD (id:string client:string amount:decimal )
        @doc "Core Capability required to mint a DPTF Token"
        (DPTF|UEV_AccountMintState id client true)
        (compose-capability (DPTF|MINT_GENERAL id amount))
    )
    (defcap DPTF|MINT_GENERAL (id:string amount:decimal)
        @doc "General Mint Capability"
        (DPTF-DPMF|UEV_Amount id amount true)
        (compose-capability (DPTF|CREDIT))
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
    )
    (defcap DPTF|SET_FEE (patron:string id:string fee:decimal)
        @doc "Capability required to EXECUTE <DPTF|C_SetFee> Function"
        (compose-capability (DPTF|X_SET_FEE id fee))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap DPTF|X_SET_FEE (id:string fee:decimal)
        @doc "Core Capability required to set the <fee-promile> for a DPTF Token"
        (UTILS.DALOS|UEV_Fee fee)
        (DPTF-DPMF|CAP_Owner id true)
        (DPTF|UEV_FeeLockState id false)
    )
    (defcap DPTF|SET_FEE-TARGET (patron:string id:string target:string)
        @doc "Capability required to EXECUTE <DPTF|C_SetFeeTarget> Function"
        (compose-capability (DPTF|X_SET_FEE-TARGET id target))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap DPTF|X_SET_FEE-TARGET (id:string target:string)
        @doc "Core Capability required to set <fee-target> for a DPTF Token"
        (DALOS.DALOS|UEV_EnforceAccountExists target)
        (DPTF-DPMF|CAP_Owner id true)
        (DPTF|UEV_FeeLockState id false) 
    )
    (defcap DPTF|SET_MIN-MOVE (patron:string id:string min-move-value:decimal)
        @doc "Capability required to EXECUTE <DPTF|C_SetMinMove> Function"
        (compose-capability (DPTF|X_SET_MIN-MOVE id min-move-value))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap DPTF|X_SET_MIN-MOVE (id:string min-move-value:decimal)
        @doc "Core Capability required to set the <min-move> value for a DPTF Token"
        (let
            (
                (decimals:integer (DPTF-DPMF|UR_Decimals id true))
            )
            (enforce
                (= (floor min-move-value decimals) min-move-value)
                (format "The Minimum Transfer amount of {} does not conform with the {} DPTF Token decimals number" [min-move-value id])
            )
            (enforce (or (= min-move-value -1.0) (> min-move-value 0.0)) "Min-Move Value does not compute")
            (DPTF-DPMF|CAP_Owner id true)
            (DPTF|UEV_FeeLockState id false)
        )
    )
    (defcap DPTF|TOGGLE_FEE (patron:string id:string toggle:bool)
        @doc "Capability required to EXECUTE <DPTF|C_ToggleFee> Function"
        (compose-capability (DPTF|X_TOGGLE_FEE id toggle))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap DPTF|X_TOGGLE_FEE (id:string toggle:bool)
        @doc "Core Capability required to set to <toggle> the <fee-toggle> for a DPTF Token"
        (let
            (
                (fee-promile:decimal (DPTF|UR_FeePromile id))
            )
            (enforce (or (= fee-promile -1.0) (and (>= fee-promile 0.0) (<= fee-promile 1000.0))) "Please Set up Fee Promile before Turning Fee Collection on !")
            (DALOS.DALOS|UEV_EnforceAccountExists (DPTF|UR_FeeTarget id))
            (DPTF-DPMF|CAP_Owner id true)
            (DPTF|UEV_FeeLockState id false)
            (DPTF|UEV_FeeToggleState id (not toggle))
        )
    )
    (defcap DPTF|X_TOGGLE_FEE-EXEMPTION-ROLE (id:string account:string toggle:bool)
        @doc "Core Capability required to toggle the <role-fee-exemption> Role \
        \ Can only be toggled for Smart DALOS Accounts"
        (DPTF-DPMF|CAP_Owner id true)
        (DALOS.DALOS|UEV_EnforceAccountType account true)
        (if toggle
            (DPTF-DPMF|UEV_CanAddSpecialRoleON id true)
            true
        )
        (DPTF|UEV_AccountFeeExemptionState id account (not toggle))
    )
    (defcap DPTF|TOGGLE_FEE-LOCK (patron:string id:string toggle:bool)
        @doc "Capability required to EXECUTE <DPTF|C_ToggleFeeLock> Function"
        (compose-capability (DPTF|X_TOGGLE_FEE-LOCK id toggle))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
        (compose-capability (DPTF|INCREMENT-LOCKS))
    )
    (defcap DPTF|X_TOGGLE_FEE-LOCK (id:string toggle:bool)
        @doc "Core Capability required to set to <toggle> the <fee-lock> for a DPTF Token"
        (DPTF-DPMF|CAP_Owner id true)
        (DPTF|UEV_FeeLockState id (not toggle))
    )
    (defcap DPTF|X_TOGGLE_MINT-ROLE (id:string account:string toggle:bool)
        @doc "Core Capability required to toggle <role-mint> to a DPTF Account for a DPTF Token"
        (DPTF-DPMF|CAP_Owner id true)
        (if toggle
            (DPTF-DPMF|UEV_CanAddSpecialRoleON id true)
            true
        )
        (DPTF|UEV_AccountMintState id account (not toggle))
    )
    ;;
    (defcap DPMF|ADD-QUANTITY (id:string client:string amount:decimal)
        @doc "Capability required to add-quantity for a DPMF Token"
        (DALOS.DALOS|CAP_EnforceAccountOwnership client)
        (compose-capability (DPMF|X_ADD-QUANTITY id client amount))
        (compose-capability (IGNIS|MATRON_SOFT id client))
        (compose-capability (P|DALOS|INCREMENT_NONCE))
    )
    (defcap DPMF|X_ADD-QUANTITY (id:string client:string amount:decimal)
        @doc "Core Capability required to add-quantity for a DPMF Token"
        (DPTF-DPMF|UEV_Amount id amount false)
        (DPMF|UEV_AccountAddQuantityState id client true)
        (compose-capability (DPMF|CREDIT))
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
    )
    (defcap DPMF|CREATE (id:string client:string)
        @doc "Capability that allows creation of a new MetaFungilbe nonce"
        (DALOS.DALOS|CAP_EnforceAccountOwnership client)
        (compose-capability (DPMF|X_CREATE id client))
        (compose-capability (IGNIS|MATRON_SOFT id client))
        (compose-capability (P|DALOS|INCREMENT_NONCE))
    )
    (defcap DPMF|X_CREATE (id:string client:string)
        @doc "Core Capability that allows creation of a new MetaFungilbe nonce"
        (DPMF|UEV_AccountCreateState id client true)
        (compose-capability (DPMF|INCREMENT_NONCE))
    )
    (defcap DPMF|MINT (id:string client:string amount:decimal)
        @doc "Capability required to execute <DPMF|C_Mint>"
        (DALOS.DALOS|CAP_EnforceAccountOwnership client)
        (compose-capability (DPMF|X_MINT id client amount))
        (compose-capability (IGNIS|MATRON_SOFT id client))
        (compose-capability (P|DALOS|INCREMENT_NONCE))
    )
    (defcap DPMF|X_MINT (id:string client:string amount:decimal)
        @doc "Core Capability required to execute <DPMF|C_Mint>"
        (compose-capability (DPMF|X_CREATE id client))
        (compose-capability (DPMF|X_ADD-QUANTITY id client amount))
    )
    (defcap DPMF|X_MOVE_CREATE-ROLE (id:string receiver:string)
        @doc "Core Capability required to execute <DPMF|C_MoveCreateRole> (AUTOSTAKE Module resident)"
        (DALOS.DALOS|UEV_SenderWithReceiver (DPMF|UR_CreateRoleAccount id) receiver)
        (DPTF-DPMF|CAP_Owner id false)
        (DPMF|UEV_CanTransferNFTCreateRoleON id)
        (DPMF|UEV_AccountCreateState id (DPMF|UR_CreateRoleAccount id) true)
        (DPMF|UEV_AccountCreateState id receiver false)
    )
    (defcap DPMF|X_TOGGLE_ADD-QUANTITY-ROLE (id:string account:string toggle:bool)
        @doc "Core Capability required to execute <DPMF|C_ToggleAddQuantityRole> (AUTOSTAKE Module resident)"
        (DPTF-DPMF|CAP_Owner id false)
        (DPMF|UEV_AccountAddQuantityState id account (not toggle))
        (if toggle
            (DPTF-DPMF|UEV_CanAddSpecialRoleON id false)
            true
        )
    )
    (defcap DPMF|TRANSFER (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Capability required to execute DPTF Transfers"
        (compose-capability (DPMF|X_TRANSFER id sender receiver transfer-amount method))
        (compose-capability (IGNIS|MATRON_STRONG id sender receiver))
        (compose-capability (P|DALOS|INCREMENT_NONCE))
        (compose-capability (DALOS|EXECUTOR))
    )
    (defcap DPMF|X_TRANSFER (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Core Capability required to execute DPTF Transfers"
        ;;Sender and Method Check
        (DALOS.DALOS|CAP_EnforceAccountOwnership sender)
        (if (and method (DALOS.DALOS|UR_AccountType receiver))
            (DALOS.DALOS|CAP_EnforceAccountOwnership receiver)
            true
        )
        ;;Token and Amount check
        (DPTF-DPMF|UEV_Amount id transfer-amount false)
        ;;Transferability check
        (DALOS.DALOS|UEV_EnforceTransferability sender receiver method)
        ;;Pause State Check
        (DPTF-DPMF|UEV_PauseState id false false)
        ;;Freeze State Check
        (DPTF-DPMF|UEV_AccountFreezeState id sender false false)
        (DPTF-DPMF|UEV_AccountFreezeState id receiver false false)
        ;;Transfer Role Check
        (if
            (and 
                (> (DPTF-DPMF|UR_TransferRoleAmount id false) 0) 
                (not (or (= sender DALOS.OUROBOROS|SC_NAME)(= sender DALOS.DALOS|SC_NAME)))
            )
            (let
                (
                    (s:bool (DPTF-DPMF|UR_AccountRoleTransfer id sender false))
                    (r:bool (DPTF-DPMF|UR_AccountRoleTransfer id receiver false))
                )
                (enforce-one
                    (format "Neither the sender {} nor the receiver {} have an active transfer role" [sender receiver])
                    [
                        (enforce (= s true) (format "Transfer-Role doesnt check for sender {}" [sender]))
                        (enforce (= r true) (format "Transfer-Role doesnt check for sender {}" [sender]))
                    ]

                )
            )
            (format "No transfer restrictions exist when transfering {} from {} to {}" [id sender receiver])
        )
        ;;Debit and Credit Capabilities
        (compose-capability (DPMF|DEBIT))
        (compose-capability (DPMF|CREDIT))
        ;;Capability needed in case an Elite Account Update is required
        (compose-capability (P|DALOS|UPDATE_ELITE))
    )
    ;;
    (defcap IGNIS|MATRON_SOFT (id:string client:string)
        @doc "Capability needed to be a gas payer for a patron with a sender"
        (if (DALOS.IGNIS|URC_ZeroGAS id client)
            true
            (compose-capability (P|IGNIS|COLLECTER))
        )
    )
    (defcap IGNIS|MATRON_STRONG (id:string client:string target:string)
        @doc "Capability needed to be a gas payer for a patron with a sender and receiver"
        (if (DALOS.IGNIS|URC_ZeroGAZ id client target)
            true
            (compose-capability (P|IGNIS|COLLECTER))
        )
    )
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;            Data Read Functions                   [UR]
    (defun DPTF|KEYS:[string] ()
        (keys DPTF|BalanceTable)
    )
    (defun DPMF|KEYS:[string] ()
        (keys DPMF|BalanceTable)
    )
    (defun DPTF-DPMF|UR_AccountFrozenState:bool (id:string account:string token-type:bool)
        @doc "Returns Account <account> True or Meta Fungible <id> Frozen State \
            \ Assumed as false if DPTF|DPMF Account doesnt exit"
        (if token-type
            (if (DALOS|UC_IzCoreDPTF id)
                (if (= id (DALOS.DALOS|UR_OuroborosID))
                    (DALOS.DALOS|UR_TrueFungible_AccountFreezeState account true)
                    (DALOS.DALOS|UR_TrueFungible_AccountFreezeState account false)
                )
                (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                    { "frozen" : false}
                    { "frozen" := fr }
                    fr
                )
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
                { "frozen" : false}
                { "frozen" := fr }
                fr
            )
        )
    )
    (defun DPTF-DPMF|UR_AccountRoleBurn:bool (id:string account:string token-type:bool)
        @doc "Returns Account <account> True or Meta Fungible <id> Burn Role \
            \ Assumed as false if DPTF|DPMF Account doesnt exit"
        (if token-type
            (if (DALOS|UC_IzCoreDPTF id)
                (if (= id (DALOS.DALOS|UR_OuroborosID))
                    (DALOS.DALOS|UR_TrueFungible_AccountRoleBurn account true)
                    (DALOS.DALOS|UR_TrueFungible_AccountRoleBurn account false)
                )
                (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                    { "role-burn" : false}
                    { "role-burn" := rb }
                    rb
                )
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
                { "role-nft-burn" : false}
                { "role-nft-burn" := rb }
                rb
            )
        )
    )
    (defun DPTF-DPMF|UR_AccountRoleTransfer:bool (id:string account:string token-type:bool)
        @doc "Returns Account <account> True or Meta Fungible <id> Transfer Role \
            \ Assumed as false if DPTF|DPMF Account doesnt exit"
        (if token-type
            (if (DALOS|UC_IzCoreDPTF id)
                (if (= id (DALOS.DALOS|UR_OuroborosID))
                    (DALOS.DALOS|UR_TrueFungible_AccountRoleTransfer account true)
                    (DALOS.DALOS|UR_TrueFungible_AccountRoleTransfer account false)
                )
                (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                    { "role-transfer" : false}
                    { "role-transfer" := rt }
                    rt
                )
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
                { "role-transfer" : false }
                { "role-transfer" := rt }
                rt
            )
        )
    )
    (defun DPTF-DPMF|UR_AccountSupply:decimal (id:string account:string token-type:bool)
        @doc "Returns Account <account> True or Meta Fungible <id> Supply \
            \ If DPTF|DPMF Account doesnt exist, 0.0 balance is returned"
        (if token-type
            (if (DALOS|UC_IzCoreDPTF id)
                (if (= id (DALOS.DALOS|UR_OuroborosID))
                    (DALOS.DALOS|UR_TrueFungible_AccountSupply account true)
                    (DALOS.DALOS|UR_TrueFungible_AccountSupply account false)
                )
                (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                    { "balance" : 0.0 }
                    { "balance" := b}
                    b
                )
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR  account])
                { "unit" : [DPMF|NEUTRAL] }
                { "unit" := read-unit}
                (let 
                    (
                        (result 
                            (fold
                                (lambda 
                                    (acc:decimal item:object{DPMF|Schema})
                                    (+ acc (at "balance" item))
                                )
                                0.0
                                read-unit
                            )
                        )
                    )
                    result
                )
            )
        )
    )
    (defun DPTF-DPMF|UR_CanAddSpecialRole:bool (id:string token-type:bool)
        (if token-type
            (at "can-add-special-role" (read DPTF|PropertiesTable id ["can-add-special-role"]))
            (at "can-add-special-role" (read DPMF|PropertiesTable id ["can-add-special-role"]))
        )
    )
    (defun DPTF-DPMF|UR_CanChangeOwner:bool (id:string token-type:bool)
        (if token-type
            (at "can-change-owner" (read DPTF|PropertiesTable id ["can-change-owner"]))
            (at "can-change-owner" (read DPMF|PropertiesTable id ["can-change-owner"]))
        )
    )
    (defun DPTF-DPMF|UR_CanFreeze:bool (id:string token-type:bool)
        (if token-type
            (at "can-freeze" (read DPTF|PropertiesTable id ["can-freeze"]))
            (at "can-freeze" (read DPMF|PropertiesTable id ["can-freeze"]))
        )
    )
    (defun DPTF-DPMF|UR_CanPause:bool (id:string token-type:bool)
        (if token-type
            (at "can-pause" (read DPTF|PropertiesTable id ["can-pause"]))
            (at "can-pause" (read DPMF|PropertiesTable id ["can-pause"]))
        )
    )
    (defun DPTF-DPMF|UR_CanUpgrade:bool (id:string token-type:bool)
        (if token-type
            (at "can-upgrade" (read DPTF|PropertiesTable id ["can-upgrade"]))
            (at "can-upgrade" (read DPMF|PropertiesTable id ["can-upgrade"]))
        )   
    )
    (defun DPTF-DPMF|UR_CanWipe:bool (id:string token-type:bool)
        (if token-type
            (at "can-wipe" (read DPTF|PropertiesTable id ["can-wipe"]))
            (at "can-wipe" (read DPMF|PropertiesTable id ["can-wipe"]))
        )
    )
    (defun DPTF-DPMF|UR_Decimals:integer (id:string token-type:bool)
        (if token-type
            (at "decimals" (read DPTF|PropertiesTable id ["decimals"]))
            (at "decimals" (read DPMF|PropertiesTable id ["decimals"]))
        )
    )
    (defun DPTF-DPMF|UR_Konto:string (id:string token-type:bool)
        (if token-type
            (at "owner-konto" (read DPTF|PropertiesTable id ["owner-konto"]))
            (at "owner-konto" (read DPMF|PropertiesTable id ["owner-konto"]))
        )
    )
    (defun DPTF-DPMF|UR_Name:string (id:string token-type:bool)
        (if token-type
            (at "name" (read DPTF|PropertiesTable id ["name"]))
            (at "name" (read DPMF|PropertiesTable id ["name"]))
        )
    )
    (defun DPTF-DPMF|UR_Paused:bool (id:string token-type:bool)
        (if token-type
            (at "is-paused" (read DPTF|PropertiesTable id ["is-paused"]))
            (at "is-paused" (read DPMF|PropertiesTable id ["is-paused"]))
        )
    )
    (defun DPTF-DPMF|UR_Supply:decimal (id:string token-type:bool)
        (if token-type
            (at "supply" (read DPTF|PropertiesTable id ["supply"]))
            (at "supply" (read DPMF|PropertiesTable id ["supply"]))
        )
    )
    (defun DPTF-DPMF|UR_Ticker:string (id:string token-type:bool)
        (if token-type
            (at "ticker" (read DPTF|PropertiesTable id ["ticker"]))
            (at "ticker" (read DPMF|PropertiesTable id ["ticker"]))   
        )
    )
    (defun DPTF-DPMF|UR_TransferRoleAmount:integer (id:string token-type:bool)
        (if token-type
            (at "role-transfer-amount" (read DPTF|PropertiesTable id ["role-transfer-amount"]))
            (at "role-transfer-amount" (read DPMF|PropertiesTable id ["role-transfer-amount"]))
        )
    )
    (defun DPTF-DPMF|UR_Vesting:string (id:string token-type:bool)
        (if token-type
            (at "vesting" (read DPTF|PropertiesTable id ["vesting"]))
            (at "vesting" (read DPMF|PropertiesTable id ["vesting"]))
        )
    )
    ;;
    (defun DPTF|UR_AccountRoleFeeExemption:bool (id:string account:string)
        @doc "Returns Account <account> True Fungible <id> Fee Exemption Role \
            \ Assumed as false if DPTF Account doesnt exit"
        (if (DALOS|UC_IzCoreDPTF id)
            (if (= id (DALOS.DALOS|UR_OuroborosID))
                (DALOS.DALOS|UR_TrueFungible_AccountRoleFeeExemption account true)
                (DALOS.DALOS|UR_TrueFungible_AccountRoleFeeExemption account false)
            )
            (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "role-fee-exemption" : false}
                { "role-fee-exemption" := rfe }
                rfe
            )
        )
        
    )
    (defun DPTF|UR_AccountRoleMint:bool (id:string account:string)
        @doc "Returns Account <account> True Fungible <id> Mint Role \
            \ Assumed as false if DPTF Account doesnt exit"
        (if (DALOS|UC_IzCoreDPTF id)
            (if (= id (DALOS.DALOS|UR_OuroborosID))
                (DALOS.DALOS|UR_TrueFungible_AccountRoleMint account true)
                (DALOS.DALOS|UR_TrueFungible_AccountRoleMint account false)
            )
            (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "role-mint" : false}
                { "role-mint" := rm }
                rm
            )
        )
    )
    (defun DPTF|UR_FeeLock:bool (id:string)
        (at "fee-lock" (read DPTF|PropertiesTable id ["fee-lock"]))
    )
    (defun DPTF|UR_FeePromile:decimal (id:string)
        (at "fee-promile" (read DPTF|PropertiesTable id ["fee-promile"]))
    )
    (defun DPTF|UR_FeeTarget:string (id:string)
        (at "fee-target" (read DPTF|PropertiesTable id ["fee-target"]))
    )
    (defun DPTF|UR_FeeToggle:bool (id:string)
        (at "fee-toggle" (read DPTF|PropertiesTable id ["fee-toggle"]))
    )
    (defun DPTF|UR_FeeUnlocks:integer (id:string)
        (at "fee-unlocks" (read DPTF|PropertiesTable id ["fee-unlocks"]))
    )
    (defun DPTF|UR_MinMove:decimal (id:string)
        (at "min-move" (read DPTF|PropertiesTable id ["min-move"]))
    )
    (defun DPTF|UR_OriginAmount:decimal (id:string)
        (at "origin-mint-amount" (read DPTF|PropertiesTable id ["origin-mint-amount"]))
    )
    (defun DPTF|UR_OriginMint:bool (id:string)
        (at "origin-mint" (read DPTF|PropertiesTable id ["origin-mint"]))
    )
    (defun DPTF|UR_PrimaryFeeVolume:decimal (id:string)
        (at "primary-fee-volume" (read DPTF|PropertiesTable id ["primary-fee-volume"]))
    )
    (defun DPTF|UR_RewardBearingToken:[string] (id:string)
        (at "reward-bearing-token" (read DPTF|PropertiesTable id ["reward-bearing-token"]))
    )
    (defun DPTF|UR_RewardToken:[string] (id:string)
        (at "reward-token" (read DPTF|PropertiesTable id ["reward-token"]))
    )
    (defun DPTF|UR_SecondaryFeeVolume:decimal (id:string)
        (at "secondary-fee-volume" (read DPTF|PropertiesTable id ["secondary-fee-volume"]))
    )
    ;;
    (defun DPMF|UR_AccountBalances:[decimal] (id:string account:string)
        @doc "Returns a list of Balances that exist for MetaFungible <id> on DPMF Account <account>\
            \ Needed for Mass Debiting"
        (DPTF-DPMF|UEV_id id false)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR  account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let 
                (
                    (result 
                        (fold
                            (lambda 
                                (acc:[decimal] item:object{DPMF|Schema})
                                (if (!= (at "balance" item) 0.0)
                                        (UTILS.LIST|UC_AppendLast acc (at "balance" item))
                                        acc
                                )
                            )
                            []
                            read-unit
                        )
                    )
                )
                result
            )
        )
    )
    (defun DPMF|UR_AccountBatchMetaData (id:string nonce:integer account:string)
        @doc "Returns the Meta-Data of a MetaFungible Batch (<id> & <nonce>) held by DPMF Account <account>"
        (DPTF-DPMF|UEV_id id false)
        (with-default-read DPMF|BalanceTable (concat [id BAR  account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let 
                (
                    (result-meta-data
                        (fold
                            (lambda 
                                (acc item:object{DPMF|Schema})
                                (let
                                    (
                                        (nonce-val:integer (at "nonce" item))
                                        (meta-data-val (at "meta-data" item))
                                    )
                                    (if (= nonce-val nonce)
                                        meta-data-val
                                        acc
                                    )
                                )
                            )
                            []
                            read-unit
                        )
                    )
                )
                result-meta-data
            )
        )
    )
    (defun DPMF|UR_AccountBatchSupply:decimal (id:string nonce:integer account:string)
        @doc "Returns the supply of a MetaFungible Batch (<id> & <nonce>) held by DPMF Account <account>"
        (DPTF-DPMF|UEV_id id false)
        (with-default-read DPMF|BalanceTable (concat [id BAR  account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let 
                (
                    (result-balance:decimal
                        (fold
                            (lambda 
                                (acc:decimal item:object{DPMF|Schema})
                                (let
                                    (
                                        (nonce-val:integer (at "nonce" item))
                                        (balance-val:decimal (at "balance" item))
                                    )
                                    (if (= nonce-val nonce)
                                        balance-val
                                        acc
                                    )
                                )
                            )
                            0.0
                            read-unit
                        )
                    )
                )
                result-balance
            )
        )
    )
    (defun DPMF|UR_AccountNonces:[integer] (id:string account:string)
        @doc "Returns a list of Nonces that exist for MetaFungible <id> held by DPMF Account <account>"
        (DPTF-DPMF|UEV_id id false)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR  account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let 
                (
                    (result 
                        (fold
                            (lambda 
                                (acc:[integer] item:object{DPMF|Schema})
                                (if (!= (at "nonce" item) 0)
                                        (UTILS.LIST|UC_AppendLast acc (at "nonce" item))
                                        acc
                                )
                            )
                            []
                            read-unit
                        )
                    )
                )
                result
            )
        )
    )
    (defun DPMF|UR_AccountRoleCreate:bool (id:string account:string)
        @doc "Returns Account <account> Meta Fungible <id> Create Role"
        (DPTF-DPMF|UEV_id id false)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "role-nft-create" : false}
            { "role-nft-create" := rnc }
            rnc
        )
    )
    (defun DPMF|UR_AccountRoleNFTAQ:bool (id:string account:string)
        @doc "Returns Account <account> Meta Fungible <id> NFT Add Quantity Role"
        (DPTF-DPMF|UEV_id id false)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "role-nft-add-quantity" : false}
            { "role-nft-add-quantity" := rnaq }
            rnaq
        )
    )
    (defun DPMF|UR_AccountUnit:[object] (id:string account:string)
        @doc "Returns Account <account> Meta Fungible <id> Unit"
        (DPTF-DPMF|UEV_id id false)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "unit" : DPMF|NEGATIVE}
            { "unit" := u }
            u
        )
    )
    (defun DPMF|UR_CanTransferNFTCreateRole:bool (id:string)
        @doc "Returns <can-transfer-nft-create-role> for the DPMF <id>"
        (at "can-transfer-nft-create-role" (read DPMF|PropertiesTable id ["can-transfer-nft-create-role"]))
    )
    (defun DPMF|UR_CreateRoleAccount:string (id:string)
        @doc "Returns <create-role-account> for the DPMF <id>"
        (at "create-role-account" (read DPMF|PropertiesTable id ["create-role-account"]))
    )
    (defun DPMF|UR_NoncesUsed:integer (id:string)
        @doc "Returns <nonces-used> for the DPMF <id>"
        (at "nonces-used" (read DPMF|PropertiesTable id ["nonces-used"]))
    )
    (defun DPMF|UR_RewardBearingToken:string (id:string)
        @doc "Returns <reward-bearing-token> for the DPMF <id>"
        (at "reward-bearing-token" (read DPMF|PropertiesTable id ["reward-bearing-token"]))
    )
    ;;       [10] Data Read and Computation Functions   [URC] and [UC]
    (defun ATS|UC_IzRT:bool (reward-token:string)                           ;ATS|UC_IzRT-Absolute
        @doc "Checks if a DPTF Token is specified as Reward Token in any ATS Pair"
        (DPTF-DPMF|UEV_id reward-token true)
        (if (= (DPTF|UR_RewardToken reward-token) [UTILS.BAR])
            false
            true
        )
    )
    (defun ATS|UC_IzRTg:bool (atspair:string reward-token:string)           ;ATS|UC_IzRT
        @doc "Checks if a DPTF Token is specified as Reward-Token in a given ATS Pair"
        (DPTF-DPMF|UEV_id reward-token true)
        (if (= (DPTF|UR_RewardToken reward-token) [UTILS.BAR])
            false
            (if (= (contains atspair (DPTF|UR_RewardToken reward-token)) true)
                true
                false
            )
        )
    )
    (defun ATS|UC_IzRBT:bool (reward-bearing-token:string cold-or-hot:bool) ;;ATS|UC_IzRBT-Absolute
        @doc "Checks if a DPTF|DPMF Tokens is registered as Reward-Bearing-Token in any ATS Pair"
        (DPTF-DPMF|UEV_id reward-bearing-token cold-or-hot)
        (if (= cold-or-hot true)
            (if (= (DPTF|UR_RewardBearingToken reward-bearing-token) [UTILS.BAR])
                false
                true
            )
            (if (= (DPMF|UR_RewardBearingToken reward-bearing-token) UTILS.BAR)
                false
                true
            )
        )
    )
    
    (defun ATS|UC_IzRBTg:bool (atspair:string reward-bearing-token:string cold-or-hot:bool) ;;ATS|UC_IzRBT
        @doc "Checks if a DPTF|DPMF Token is registered as Reward-Bearing-Token in a given ATS Pair"
        (DPTF-DPMF|UEV_id reward-bearing-token cold-or-hot)
        (if (= cold-or-hot true)
            (if (= (DPTF|UR_RewardBearingToken reward-bearing-token) [UTILS.BAR])
                false
                (if (= (contains atspair (DPTF|UR_RewardBearingToken reward-bearing-token)) true)
                    true
                    false
                )
            )
            (if (= (DPMF|UR_RewardBearingToken reward-bearing-token) UTILS.BAR)
                false
                (if (= (DPMF|UR_RewardBearingToken reward-bearing-token) atspair)
                    true
                    false
                )
            )
        )
    )
    (defun DALOS|UC_IzCoreDPTF:bool (id:string)
        @doc "Checks if Token-Id is a Core DPTF Token \
        \ The Core DPTF Tokens are OUROBOROS and IGNIS"
        (DPTF-DPMF|UEV_id id true)
        (let*
            (
                (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                (ignis-id:string (DALOS.DALOS|UR_IgnisID))
                (iz-ouro-defined:bool (not (= ouro-id UTILS.BAR)))
                (iz-ignis-defined:bool (not (= ignis-id UTILS.BAR)))
            )
            (if (not iz-ouro-defined)
                (if (not iz-ignis-defined)
                        false
                        (= id ignis-id)
                    )
                (if (= id ouro-id)
                    true
                    (if (not iz-ignis-defined)
                        false
                        (= id ignis-id)
                    )
                )
            )
        )
    )
    (defun DALOS|URC_EliteAurynzSupply (account:string)
        @doc "Returns Total Elite Auryn (normal and vested) Supply of Account"
        (if (!= (DALOS.DALOS|UR_EliteAurynID) UTILS.BAR)
            (let
                (
                    (ea-supply:decimal (DPTF-DPMF|UR_AccountSupply (DALOS.DALOS|UR_EliteAurynID) account true))
                    (vea:string (DPTF-DPMF|UR_Vesting (DALOS.DALOS|UR_EliteAurynID) true))
                )
                (if (!= vea UTILS.BAR)
                    (+ ea-supply (DPTF-DPMF|UR_AccountSupply vea account false))
                    ea-supply
                )
            )
            true
        )
    )
    (defun DPTF-DPMF|URC_AccountExist:bool (id:string account:string token-type:bool)
        @doc "Checks if DPTF|DPMF Account <account> exists for DPTF|DPMF Token id <id>"
        (if token-type
            (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "balance" : -1.0 }
                { "balance" := b}
                (if (= b -1.0)
                    false
                    true
                )
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
                { "unit" : [DPMF|NEGATIVE] }
                { "unit" := u}
                (if (= u [DPMF|NEGATIVE])
                    false
                    true
                )
            )
        )
    )
    (defun DPTF|UC_Fee:[decimal] (id:string amount:decimal)
        @doc "Computes Fee values for a DPTF Token <id> and <amount> \
            \ and outputs them into a list of strings; The list is as follows: \
            \ \
            \ 1st element, is the Primary Fee, which is the standard Fee set up for the Token \
            \ 2nd element, is the Secondary Fee, which exists if the number of <fee-unlocks> becomes greater than zero \
            \ 3rd element, is the Remainder, which is the actual amount that reaches the receiver \
            \ \
            \ If the <fee-toggle> is set to false, no fee is deducted \
            \ All 3 amounts, when summed, must equal exactly the input amount to the last decimal"
        (let
            (
                (fee-toggle:bool (DPTF|UR_FeeToggle id))
            )
            (if (= fee-toggle false)
                [0.0 0.0 amount]
                (let*
                    (
                        (precision:integer (DPTF-DPMF|UR_Decimals id true))
                        (fee-promile:decimal (DPTF|UR_FeePromile id))
                        (fee-unlocks:integer (DPTF|UR_FeeUnlocks id))
                        (volumetric-fee:decimal (DPTF|UC_VolumetricTax id amount))
                        (primary-fee-value:decimal 
                            (if (= fee-promile -1.0)
                                volumetric-fee
                                (floor (* (/ fee-promile 1000.0) amount) precision)
                            ) 
                        )
                        (secondary-fee-value:decimal 
                            (if (= fee-unlocks 0)
                                0.0
                                (* (dec fee-unlocks) volumetric-fee)
                            )
                        )
                        (remainder:decimal (- amount (+ primary-fee-value secondary-fee-value)))
                    )
                    [primary-fee-value secondary-fee-value remainder]
                )
            )
        )
    )
    (defun DPTF|UC_TransferFeeAndMinException:bool (id:string sender:string receiver:string)
        @doc "Computes if there is a DPTF Fee or Min Transfer Amount Exception"
        (let*
            (
                (gas-id:string (DALOS.DALOS|UR_IgnisID))
                (sender-fee-exemption:bool (DPTF|UR_AccountRoleFeeExemption id sender))
                (receiver-fee-exemption:bool (DPTF|UR_AccountRoleFeeExemption id receiver))
                (token-owner:string (DPTF-DPMF|UR_Konto id true))
                (sender-t1:bool (or (= sender OUROBOROS|SC_NAME) (= sender DALOS|SC_NAME)))
                (sender-t2:bool (or (= sender token-owner)(= sender-fee-exemption true)))
                (iz-sender-exception:bool (or sender-t1 sender-t2))
                (receiver-t1:bool (or (= receiver OUROBOROS|SC_NAME) (= receiver DALOS|SC_NAME)))
                (receiver-t2:bool (or (= receiver token-owner)(= receiver-fee-exemption true)))
                (iz-receiver-exception:bool (or receiver-t1 receiver-t2))
                (are-members-exception (or iz-sender-exception iz-receiver-exception))
                (is-id-gas:bool (= id gas-id))
                (iz-exception:bool (or is-id-gas are-members-exception ))
            )
            iz-exception
        )
    )
    (defun DPTF|UC_UnlockPrice:[decimal] (id:string)
        @doc "Computes the <fee-lock> unlock price for a DPTF <id> \
            \ Outputs [virtual-gas-costs native-gas-cost] \
            \ Virtual Gas Token = Ignis; Native Gas Token = Kadena"
        (UTILS.DPTF|UC_UnlockPrice (DPTF|UR_FeeUnlocks id))
    )
    (defun DPTF|UC_VolumetricTax (id:string amount:decimal)
        @doc "Computes the Volumetric-Transaction-Tax (VTT), given an DTPF <id> and <amount>"
        (DPTF-DPMF|UEV_Amount id amount true)
        (UTILS.DPTF|UC_VolumetricTax (DPTF-DPMF|UR_Decimals id true) amount)
    )
    ;;        [2] Data Creation|Composition Functions   [UCC]
    (defun DPMF|UCC_Compose:object{DPMF|Schema} (nonce:integer balance:decimal meta-data:[object])
        @doc "Composes a Meta-Fungible object from <nonce>, <balance> and <meta-data>"
        {"nonce" : nonce, "balance": balance, "meta-data" : meta-data}
    )
    (defun DPMF|UCC_Pair_Nonce-Balance:[object{DPMF|Nonce-Balance}] (nonce-lst:[integer] balance-lst:[decimal])
        @doc "Composes a Nonce-Balance object from a <nonce-lst> list and <balance-lst> list \
        \ Used in <DPMF|X_DebitMultiple>, which itself is part of <DPTF-DPMF|X_Wipe> when used on a DPMF Token"
        (let
            (
                (nonce-length:integer (length nonce-lst))
                (balance-length:integer (length balance-lst))
            )
            (enforce (= nonce-length balance-length) "Nonce and Balance Lists are not of equal length")
            (zip (lambda (x:integer y:decimal) { "nonce": x, "balance": y }) nonce-lst balance-lst)
        )
    )
    ;;     (NONE) Administrative Usage Functions        [A]
    ;;       [23] Client Usage Functions                [C]
    (defun DPTF-DPMF|C_ChangeOwnership (patron:string id:string new-owner:string token-type:bool)
        @doc "Moves DPTF|DPMF <id> Token Ownership to <new-owner> DPTF|DPMF Account"
        (with-capability (DPTF-DPMF|OWNERSHIP-CHANGE id new-owner token-type)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (DPTF-DPMF|UR_Konto id token-type) DALOS.GAS_BIGGEST)
                true
            )
            (DPTF-DPMF|X_ChangeOwnership id new-owner token-type)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF-DPMF|C_DeployAccount (id:string account:string token-type:bool)
        @doc "Creates a new DPTF|DPMF Account for True|Meta-Fungible <id> and Account <account> \
            \ If a DPTF|DPMF Account already exists for <id> and <account>, it remains as is \
            \ \
            \ A DPTF Account can only be created if a coresponding DALOS Account exists."
        (DALOS.DALOS|UEV_EnforceAccountExists account)        ;;Validates Dalos Account Existance
        (DPTF-DPMF|UEV_id id token-type)    ;;Validates Token Existance
        (if token-type
            (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "balance"                             : 0.0
                , "role-burn"                           : false
                , "role-mint"                           : false
                , "role-transfer"                       : false
                , "role-fee-exemption"                  : false
                , "frozen"                              : false}
                { "balance"                             := b
                , "role-burn"                           := rb
                , "role-mint"                           := rm
                , "role-transfer"                       := rt
                , "role-fee-exemption"                  := rfe
                , "frozen"                              := f}
                (write DPTF|BalanceTable (concat [id UTILS.BAR account])
                    { "balance"                         : b
                    , "role-burn"                       : rb
                    , "role-mint"                       : rm
                    , "role-transfer"                   : rt
                    , "role-fee-exemption"              : rfe
                    , "frozen"                          : f}
                )
            )
            (let*
                (
                    (create-role-account:string (DPMF|UR_CreateRoleAccount id))
                    (role-nft-create-boolean:bool (if (= create-role-account account) true false))
                )
                (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
                    { "unit" : [DPMF|NEUTRAL]
                    , "role-nft-add-quantity"           : false
                    , "role-nft-burn"                   : false
                    , "role-nft-create"                 : role-nft-create-boolean
                    , "role-transfer"                   : false
                    , "frozen"                          : false}
                    { "unit"                            := u
                    , "role-nft-add-quantity"           := rnaq
                    , "role-nft-burn"                   := rb
                    , "role-nft-create"                 := rnc
                    , "role-transfer"                   := rt
                    , "frozen"                          := f }
                    (write DPMF|BalanceTable (concat [id UTILS.BAR account])
                        { "unit"                        : u
                        , "role-nft-add-quantity"       : rnaq
                        , "role-nft-burn"               : rb
                        , "role-nft-create"             : rnc
                        , "role-transfer"               : rt
                        , "frozen"                      : f}
                    )
                )
            )
        )
    )
    (defun DPTF-DPMF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool token-type:bool)
        @doc "Freeze/Unfreeze via boolean <toggle> True|Meta-Fungile <id> on DPTF Account <account>"
        (with-capability (DPTF-DPMF|FROZEN-ACCOUNT patron id account toggle token-type)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_BIG)
                true
            )
            (DPTF-DPMF|X_ToggleFreezeAccount id account toggle token-type)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF-DPMF|C_TogglePause (patron:string id:string toggle:bool token-type:bool)
        @doc "Pause/Unpause True|Meta-Fungible <id> via the boolean <toggle>"
        (with-capability (DPTF-DPMF|TOGGLE_PAUSE patron id toggle token-type)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron patron DALOS.GAS_MEDIUM)
                true
            )
            (DPTF-DPMF|X_TogglePause id toggle token-type)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF-DPMF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool token-type:bool)
        @doc "Sets |role-transfer| to <toggle> for True|Meta-Fungible <id> and DPTF|DPMF Account <account>. \
            \ If any DPTF|DPMF Account has |role-transfer| true, normal transfers are restricted. \
            \ Transfers will only be allowed to DPTF|DPMF Accounts with |role-transfer| true, \
            \ while these Accounts can transfer the True|Meta-Fungible freely to others."
        (with-capability (DPTF-DPMF|TOGGLE_TRANSFER-ROLE patron id account toggle token-type)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_SMALL)
                true
            )
            (DPTF-DPMF|X_ToggleTransferRole id account toggle token-type)
            (DPTF-DPMF|X_UpdateRoleTransferAmount id toggle token-type)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF-DPMF|C_Wipe (patron:string id:string atbw:string token-type:bool)
        @doc "Wipes the whole supply of <id> True|Meta-Fungible of a frozen DPTF|DPMF Account <account>"
        (with-capability (DPTF-DPMF|WIPE patron id atbw token-type)
            (if (not (DALOS.IGNIS|URC_ZeroGAS id atbw))
                (DALOS.IGNIS|X_Collect patron atbw DALOS.GAS_BIGGEST)
                true
            )
            (DPTF-DPMF|X_Wipe id atbw token-type)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    ;;
    (defun DPTF|C_Burn (patron:string id:string account:string amount:decimal)
        @doc "Client DPTF Burn Function"
        (with-capability (DPTF|CLIENT_BURN)
            (if (not (DALOS.IGNIS|URC_ZeroGAS id account))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_SMALL)
                true
            )
            (DPTF|XO_Burn id account amount)
            (DALOS.DALOS|X_IncrementNonce account)
        )
    )
    (defun DPTF|C_Control 
        (
            patron:string
            id:string
            cco:bool 
            cu:bool 
            casr:bool 
            cf:bool 
            cw:bool 
            cp:bool
        )
        @doc "Controls TrueFungible <id> Properties using 6 boolean control triggers \
            \ Setting the <can-upgrade> property to false disables all future Control of Properties"
        (with-capability (DPTF-DPMF|CONTROL patron id true)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (DPTF-DPMF|UR_Konto id true) DALOS.GAS_SMALL)
                true
            )
            (DPTF|X_Control patron id cco cu casr cf cw cp)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF|C_Issue:[string]
        (
            patron:string
            account:string
            name:[string]
            ticker:[string]
            decimals:[integer]
            can-change-owner:[bool]
            can-upgrade:[bool]
            can-add-special-role:[bool]
            can-freeze:[bool]
            can-wipe:[bool]
            can-pause:[bool]
        )
        @doc "Issues Multiple DPTF Tokens at once \
        \ Can also be used for issuing a single DPTF Token \
        \ Outputs a list with the IDs of the Issued Tokens \
        \ Creates DPTF Account(s) for the DALOS Account <account> for each issued Token "
        (UTILS.LIST|UC_IzUnique name)
        (UTILS.LIST|UC_IzUnique ticker)
        (let*
            (
                (l1:integer (length name))
                (l2:integer (length ticker))
                (l3:integer (length decimals))
                (l4:integer (length can-change-owner))
                (l5:integer (length can-upgrade))
                (l6:integer (length can-add-special-role))
                (l7:integer (length can-freeze)) 
                (l8:integer (length can-wipe))
                (l9:integer (length can-pause))
                (lengths:[integer] [l1 l2 l3 l4 l5 l6 l7 l8 l9])
                (tf-cost:decimal (DALOS.DALOS|UR_True))
                (gas-costs:decimal (* (dec l1) DALOS.GAS_ISSUE))
                (kda-costs:decimal (* (dec l1) tf-cost))
            )
            (UTILS.UTILS|UEV_EnforceUniformIntegerList lengths)
            (with-capability (DPTF-DPMF|ISSUE)
                (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                    (DALOS.IGNIS|X_Collect patron account gas-costs)
                    true
                )
                (if (not (DALOS.IGNIS|URC_IsNativeGasZero))
                    (DALOS.DALOS|C_TransferRawDalosFuel patron kda-costs)
                    true
                )
                (fold
                    (lambda
                        (acc:[string] index:integer)
                        (let
                            (
                                (id:string
                                    (DPTF|X_Issue 
                                        account 
                                        (at index name)
                                        (at index ticker)
                                        (at index decimals)
                                        (at index can-change-owner)
                                        (at index can-upgrade)
                                        (at index can-add-special-role)
                                        (at index can-freeze)
                                        (at index can-wipe) 
                                        (at index can-pause)
                                    )
                                )
                            )
                            (DALOS.DALOS|X_IncrementNonce patron)
                            (UTILS.LIST|UC_AppendLast acc id)
                        )
                    )
                    []
                    (enumerate 0 (- (length name) 1))
                )
            )
        )
    )
    (defun DPTF|C_Mint (patron:string id:string account:string amount:decimal origin:bool)
        @doc "Client DPTF Mint Function"
        (with-capability (DPTF|MINT id account amount origin)
            (if (not (DALOS.IGNIS|URC_ZeroGAS id account))
                (if origin
                    (DALOS.IGNIS|X_Collect patron account DALOS.GAS_BIGGEST)
                    (DALOS.IGNIS|X_Collect patron account DALOS.GAS_SMALL)
                )
                true
            )
            (DPTF|X_Mint id account amount origin )
            (DALOS.DALOS|X_IncrementNonce account)
        )
    )
    (defun DPTF|C_SetFee (patron:string id:string fee:decimal)
        @doc "Sets the <fee-promile> for DPTF Token <id> to <fee> \
        \ -1.0 activates the Volumetric Transaction Tax (VTT) mechanic."
        (with-capability (DPTF|SET_FEE patron id fee)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (DPTF-DPMF|UR_Konto id true) DALOS.GAS_SMALL)
                true
            )
            (DPTF|X_SetFee id fee)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF|C_SetFeeTarget (patron:string id:string target:string)
        @doc "Sets the <fee-target> for DPTF Token <id> to <target> \
        \ Default is <Ouroboros> (Fee-Carrier Account) \
        \ Setting it to <Gas-Tanker> makes fees act like collected gas \
        \ Fees from <Ouroboros> can be retrieved by the Token owner; \
        \ Fees from <Gas-Tanker> are distributed to DALOS Custodians."
        (with-capability (DPTF|SET_FEE-TARGET patron id target)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (DPTF-DPMF|UR_Konto id true) DALOS.GAS_SMALL)
                true
            )
            (DPTF|X_SetFeeTarget id target)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF|C_SetMinMove (patron:string id:string min-move-value:decimal)
        @doc "Sets the <min-move> for the DPTF Token <id> to <min-move-value>"
        (with-capability (DPTF|SET_MIN-MOVE patron id min-move-value)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (DPTF-DPMF|UR_Konto id true) DALOS.GAS_SMALL)
                true
            )
            (DPTF|X_SetMinMove id min-move-value)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF|C_ToggleFee (patron:string id:string toggle:bool)
        @doc "Toggles <fee-toggle> for the DPTF Token <id> to <toggle> \
        \ <fee-toggle> must be set to true for fee collection to execute"
        (with-capability (DPTF|TOGGLE_FEE patron id toggle)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (DPTF-DPMF|UR_Konto id true) DALOS.GAS_SMALL)
                true
            )
            (DPTF|X_ToggleFee id toggle)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF|C_ToggleFeeLock (patron:string id:string toggle:bool)
        @doc "Sets the <fee-lock> for DPTF Token <id> to <toggle> \
        \ Unlocking (<toggle> = false) has restrictions: \
        \ - Max 7 unlocks per token \
        \ - Unlock cost: (10000 IGNIS + 100 KDA) * (fee-unlocks + 1) \
        \ - Each unlock adds a Secondary Fee collected by the <GasTanker> Smart DALOS Account \
        \ equal to the VTT * fee-unlocks, calculated by <UTILS.DPTF|UC_VolumetricTax>"
        (let
            (
                (ZG:bool (DALOS.IGNIS|URC_IsVirtualGasZero))
                (NZG:bool (IGNIS|URC_IsNativeGasZero))
                (token-owner:string (DPTF-DPMF|UR_Konto id true))
            )
            (with-capability (DPTF|TOGGLE_FEE-LOCK patron id toggle)
                (if (not ZG)
                    (DALOS.IGNIS|X_Collect patron token-owner DALOS.GAS_SMALL)
                    true
                )
                (let*
                    (
                        (toggle-costs:[decimal] (DPTF|X_ToggleFeeLock id toggle))
                        (gas-costs:decimal (at 0 toggle-costs))
                        (kda-costs:decimal (at 1 toggle-costs))
                    )
                    (if (> gas-costs 0.0)
                        (with-capability (COMPOSE)
                            (if (not ZG)
                                (DALOS.IGNIS|X_Collect patron token-owner gas-costs)
                                true
                            )
                            (if (not NZG)
                                (DALOS.DALOS|C_TransferRawDalosFuel patron kda-costs)
                                true
                            )
                            (DPTF|X_IncrementFeeUnlocks id)
                        )
                        true
                    )
                )
                (DALOS.DALOS|X_IncrementNonce patron)
            )
        )
    )
    ;;
    (defun DPMF|C_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Client Function that adds quantity for a DPMF Token"
        (with-capability (DPMF|ADD-QUANTITY id account amount)
            (if (not (DALOS.IGNIS|URC_ZeroGAS id account))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_SMALL)
                true
            )
            (DPMF|X_AddQuantity id nonce account amount)
            (DALOS.DALOS|X_IncrementNonce account)
        )
    )
    (defun DPMF|C_Burn (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Client Function that burns a DPMF Token"
        (with-capability (DPTF-DPMF|BURN id account amount false)
            (if (not (DALOS.IGNIS|URC_ZeroGAS id account))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_SMALL)
                true
            )
            (DPMF|X_Burn id nonce account amount)
            (DALOS.DALOS|X_IncrementNonce account)
        )
    )
    (defun DPMF|C_Control
        (
            patron:string
            id:string
            cco:bool 
            cu:bool 
            casr:bool 
            cf:bool 
            cw:bool 
            cp:bool
            ctncr:bool
        )
        @doc "Controls MetaFungible <id> Properties using 7 boolean control triggers \
            \ Setting the <can-upgrade> property to false disables all future Control of Properties"
        (with-capability (DPTF-DPMF|CONTROL id false)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (DPTF-DPMF|UR_Konto id false) DALOS.GAS_SMALL)
                true
            )
            (DPMF|X_Control id cco cu casr cf cw cp ctncr)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPMF|C_Create:integer (patron:string id:string account:string meta-data:[object])
        @doc "Client Function that creates a DPMF"
        (with-capability (DPMF|CREATE id account)
            (if (not (DALOS.IGNIS|URC_ZeroGAS id account))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_SMALL)
                true
            )
            (DALOS.DALOS|X_IncrementNonce account)
            (DPMF|X_Create id account meta-data)
        )
    )
    (defun DPMF|C_Issue:[string]
        (
            patron:string
            account:string
            name:[string]
            ticker:[string]
            decimals:[integer]
            can-change-owner:[bool]
            can-upgrade:[bool]
            can-add-special-role:[bool]
            can-freeze:[bool]
            can-wipe:[bool]
            can-pause:[bool]
            can-transfer-nft-create-role:[bool]
        )
        @doc "Issues Multiple DPMF Tokens at once \
        \ Can also be used for issuing a single DPMF Token \
        \ Outputs a list with the IDs of the Issued Tokens \
        \ Creates DPMF Account(s) for the DALOS Account <account> for each issued Token "
        (UTILS.LIST|UC_IzUnique name)
        (UTILS.LIST|UC_IzUnique ticker)
        (let*
            (
                (l1:integer (length name))
                (l2:integer (length ticker))
                (l3:integer (length decimals))
                (l4:integer (length can-change-owner))
                (l5:integer (length can-upgrade))
                (l6:integer (length can-add-special-role))
                (l7:integer (length can-freeze))
                (l8:integer (length can-wipe))
                (l9:integer (length can-pause))
                (l0:integer (length can-transfer-nft-create-role))
                (lengths:[integer] [l1 l2 l3 l4 l5 l6 l7 l8 l9 l0])
                (tf-cost:decimal (DALOS.DALOS|UR_Meta))
                (gas-costs:decimal (* (dec l1) DALOS.GAS_ISSUE))
                (kda-costs:decimal (* (dec l1) tf-cost))
            )
            (UTILS.UTILS|UEV_EnforceUniformIntegerList lengths)
            (with-capability (DPTF-DPMF|ISSUE)
                (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                    (DALOS.IGNIS|X_Collect patron account gas-costs)
                    true
                )
                (if (not (DALOS.IGNIS|URC_IsNativeGasZero))
                    (DALOS.DALOS|C_TransferRawDalosFuel patron kda-costs)
                    true
                )
                (fold
                    (lambda
                        (acc:[string] index:integer)
                        (let
                            (
                                (id:string
                                    (DPMF|X_Issue
                                        account 
                                        (at index name)
                                        (at index ticker)
                                        (at index decimals)
                                        (at index can-change-owner)
                                        (at index can-upgrade)
                                        (at index can-add-special-role)
                                        (at index can-freeze)
                                        (at index can-wipe) 
                                        (at index can-pause)
                                        (at index can-transfer-nft-create-role)
                                    )
                                )
                            )
                            (DALOS.DALOS|X_IncrementNonce patron)
                            (UTILS.LIST|UC_AppendLast acc id)
                        )
                    )
                    []
                    (enumerate 0 (- (length name) 1))
                )
            )
        )
    )
    (defun DPMF|C_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object])
        @doc "Client Function that mints a DPMF"
        (with-capability (DPMF|MINT id account amount)
            (if (not (DALOS.IGNIS|URC_ZeroGAS id account))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_SMALL)
                true
            )
            (DALOS.DALOS|X_IncrementNonce account)
            (DPMF|X_Mint id account amount meta-data)
        )
    )
    (defun DPMF|C_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal)
        @doc "Client DPMF Transfer Function"
        (with-capability (DPMF|TRANSFER id sender receiver transfer-amount false)
            (DPMF|XK_Transfer patron id nonce sender receiver transfer-amount false)
        )
    )
    (defun DPMF|CM_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal)
        @doc "Methodic DPMF Transfer Function; To be used in Modules associated with Smart DALOS Accounts"                                        
        (with-capability (DPMF|TRANSFER id sender receiver transfer-amount true)
            (DPMF|XK_Transfer patron id nonce sender receiver transfer-amount true)
        )
    )
    ;;       [57] Auxiliary Usage Functions             [X]
    (defun DPTF-DPMF|X_ChangeOwnership (id:string new-owner:string token-type:bool)
        (require-capability (DPTF-DPMF|X_OWNERSHIP-CHANGE id new-owner token-type))
        (if token-type
            (update DPTF|PropertiesTable id
                {"owner-konto"                      : new-owner}
            )
            (update DPMF|PropertiesTable id
                {"owner-konto"                      : new-owner}
            )
        )
    )
    (defun DPTF-DPMF|X_ToggleFreezeAccount (id:string account:string toggle:bool token-type:bool)
        (require-capability (DPTF-DPMF|X_FROZEN-ACCOUNT id account toggle token-type))
        (if token-type
            (if (DALOS|UC_IzCoreDPTF id)
                (with-capability (P|DALOS|UP_DATA)
                    (DALOS.DALOS|XO_UpdateFreeze account (= id (DALOS.DALOS|UR_OuroborosID)) toggle)
                )
                (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                    { "frozen" : toggle}
                )
            )
            (update DPMF|BalanceTable (concat [id UTILS.BAR account])
                { "frozen" : toggle}
            )
        )
    )
    (defun DPTF-DPMF|X_TogglePause (id:string toggle:bool token-type:bool)
        (require-capability (DPTF-DPMF|X_TOGGLE_PAUSE id toggle token-type))
        (if token-type
            (update DPTF|PropertiesTable id
                { "is-paused" : toggle}
            )
            (update DPMF|PropertiesTable id
                { "is-paused" : toggle}
            )
        )
    )
    (defun DPTF-DPMF|X_ToggleTransferRole (id:string account:string toggle:bool token-type:bool)
        (require-capability (DPTF-DPMF|X_TOGGLE_TRANSFER-ROLE id account toggle token-type))
        (if token-type
            (if (DALOS|UC_IzCoreDPTF id)
                (with-capability (P|DALOS|UP_DATA)
                    (DALOS.DALOS|XO_UpdateTransferRole account (= id (DALOS.DALOS|UR_OuroborosID)) toggle)
                )
                (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                    {"role-transfer" : toggle}
                )
            )
            (update DPMF|BalanceTable (concat [id UTILS.BAR account])
                {"role-transfer" : toggle}
            )
        )
    )
    (defun DPTF-DPMF|X_UpdateElite (id:string sender:string receiver:string)
        @doc "Updates Elite Account in a transfer context"
        (let
            (
                (ea-id:string (DALOS.DALOS|UR_EliteAurynID))
            )
            (if (!= ea-id UTILS.BAR)
                (if (= id ea-id)
                    (with-capability (P|DALOS|UPDATE_ELITE)
                        (DALOS.DALOS|X_UpdateElite sender (DALOS|URC_EliteAurynzSupply sender))
                        (DALOS.DALOS|X_UpdateElite receiver (DALOS|URC_EliteAurynzSupply receiver))
                    )
                    (let
                        (
                            (v-ea-id:string (DPTF-DPMF|UR_Vesting ea-id true))
                        )
                        (if (and (!= v-ea-id UTILS.BAR)(= id v-ea-id))
                            (with-capability (P|DALOS|UPDATE_ELITE)
                                (DALOS.DALOS|X_UpdateElite sender (DALOS|URC_EliteAurynzSupply sender))
                                (DALOS.DALOS|X_UpdateElite receiver (DALOS|URC_EliteAurynzSupply receiver))
                            )
                            true
                        )
                    )
                )
                true
            )
        )
    )
    (defun DPTF-DPMF|X_UpdateRoleTransferAmount (id:string direction:bool token-type:bool)
        @doc "Updates <role-transfer-amount> for Token <id>"
        (require-capability (DPTF-DPMF|UPDATE_ROLE-TRANSFER-AMOUNT))
        (if token-type
            (if (= direction true)
                (with-read DPTF|PropertiesTable id
                    { "role-transfer-amount" := rta }
                    (update DPTF|PropertiesTable id
                        {"role-transfer-amount" : (+ rta 1)}
                    )
                )
                (with-read DPTF|PropertiesTable id
                    { "role-transfer-amount" := rta }
                    (update DPTF|PropertiesTable id
                        {"role-transfer-amount" : (- rta 1)}
                    )
                )
            )
            (if (= direction true)
                (with-read DPMF|PropertiesTable id
                    { "role-transfer-amount" := rta }
                    (update DPMF|PropertiesTable id
                        {"role-transfer-amount" : (+ rta 1)}
                    )
                )
                (with-read DPMF|PropertiesTable id
                    { "role-transfer-amount" := rta }
                    (update DPMF|PropertiesTable id
                        {"role-transfer-amount" : (- rta 1)}
                    )
                )
            )
        )
    )
    (defun DPTF-DPMF|X_UpdateSupply (id:string amount:decimal direction:bool token-type:bool)
        @doc "Updates <id> True|Meta-Fungible supply. Boolean <direction> used for increase|decrease"
        (require-capability (DPTF-DPMF|UPDATE_SUPPLY))
        (DPTF-DPMF|UEV_Amount id amount token-type)
        (if token-type
            (if (= direction true)
                (with-read DPTF|PropertiesTable id
                    { "supply" := s }
                    (enforce (>= (+ s amount) 0.0) "DPTF Token Supply cannot be updated to negative values!")
                    (update DPTF|PropertiesTable id { "supply" : (+ s amount)})
                )
                (with-read DPTF|PropertiesTable id
                    { "supply" := s }
                    (enforce (>= (- s amount) 0.0) "DPTF Token Supply cannot be updated to negative values!")
                    (update DPTF|PropertiesTable id { "supply" : (- s amount)})
                )
            )
            (if (= direction true)
                (with-read DPMF|PropertiesTable id
                    { "supply" := s }
                    (enforce (>= (+ s amount) 0.0) "DPMF Token Supply cannot be updated to negative values!")
                    (update DPMF|PropertiesTable id { "supply" : (+ s amount)})
                )
                (with-read DPMF|PropertiesTable id
                    { "supply" := s }
                    (enforce (>= (- s amount) 0.0) "DPMF Token Supply cannot be updated to negative values!")
                    (update DPMF|PropertiesTable id { "supply" : (- s amount)})
                )
            )
        )
    )
    (defun DPTF-DPMF|X_Wipe (id:string account-to-be-wiped:string token-type:bool)
        (require-capability (DPTF-DPMF|X_WIPE id account-to-be-wiped token-type))
        (if token-type
            (let
                (
                    (amount-to-be-wiped:decimal (DPTF-DPMF|UR_AccountSupply id account-to-be-wiped token-type))
                )
                (DPTF|X_DebitAdmin id account-to-be-wiped amount-to-be-wiped)
                (DPTF-DPMF|X_UpdateSupply id amount-to-be-wiped false token-type)
            )
            (let*
                (
                    (nonce-lst:[integer] (DPMF|UR_AccountNonces id account-to-be-wiped))
                    (balance-lst:[decimal] (DPMF|UR_AccountBalances id account-to-be-wiped))
                    (balance-sum:decimal (fold (+) 0.0 balance-lst))
                )
                (DPMF|X_DebitMultiple id nonce-lst account-to-be-wiped balance-lst)
                (DPTF-DPMF|X_UpdateSupply id balance-sum false token-type)
            )
        )
    )
    (defun DPTF-DPMF|XO_ToggleBurnRole (id:string account:string toggle:bool token-type:bool)
        (enforce-guard (BASIS|C_ReadPolicy "AUTOSTAKE|ToggleBurnRole"))
        (with-capability (DPTF-DPMF|X_TOGGLE_BURN-ROLE id account toggle token-type)
            (DPTF-DPMF|XP_ToggleBurnRole id account toggle token-type)
        )
    )
    (defun DPTF-DPMF|XP_ToggleBurnRole (id:string account:string toggle:bool token-type:bool)
        (require-capability (DPTF-DPMF|X_TOGGLE_BURN-ROLE id account toggle token-type))
        (if token-type
            (if (DALOS|UC_IzCoreDPTF id)
                (with-capability (P|DALOS|UP_DATA)
                    (DALOS.DALOS|XO_UpdateBurnRole account (= id (DALOS.DALOS|UR_OuroborosID)) toggle)
                )
                (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                    {"role-burn" : toggle}
                )
            )
            (update DPMF|BalanceTable (concat [id UTILS.BAR account])
                {"role-nft-burn" : toggle}
            )
        )
    )
    (defun DPTF-DPMF|XO_UpdateRewardBearingToken (id:string atspair:string token-type:bool)
        @doc "Updates Reward-Bearing-Token Data (atspair name) for DPTF|DPMF Token <id> \
        \ For DPTF Tokens (<token-type> = true), the atspair is added; \
        \ For DPMF Tokens, (<token-type> = false), the DPTF Token must not have a designated ATS-Pair \
        \   in the <reward-bearing-token> list. If it has, this new <ats-pair> cant be added, since a DPMF Token \
        \   is linked immutably to an ATS-Pair, and cannot be unlinked"
        (enforce-guard (BASIS|C_ReadPolicy "AUTOSTAKE|UpdateRewardBearingToken"))
        (with-capability (ATS|UPDATE_RBT)
            (ATS|UEV_UpdateRewardBearingToken id token-type)
            (DPTF-DPMF|XP_UpdateRewardBearingToken id atspair token-type)
        )
    )
    (defun DPTF-DPMF|XP_UpdateRewardBearingToken (id:string atspair:string token-type:bool)
        @doc "XP Pure UpdateRewardBearingToken Function"
        (require-capability (ATS|UPDATE_RBT))
        (if token-type
            (with-read DPTF|PropertiesTable id
                {"reward-bearing-token" := rbt}
                (if (= (at 0 rbt) UTILS.BAR)
                    (update DPTF|PropertiesTable id
                        {"reward-bearing-token" : [atspair]}
                    )
                    (update DPTF|PropertiesTable id
                        {"reward-bearing-token" : (UTILS.LIST|UC_AppendLast rbt atspair)}
                    )
                )
            )
            (update DPMF|PropertiesTable id
                {"reward-bearing-token" : atspair}
            )
        )
    )

    (defun DPTF-DPMF|XO_UpdateVesting (dptf:string dpmf:string)
        @doc "Updates Vesting Data for DPTF|DPMF Token Pair" 
        (enforce-guard (BASIS|C_ReadPolicy "AUTOSTAKE|UpdateVesting"))
        (with-capability (VST|UPDATE)
            (DPTF-DPMF|XP_UpdateVesting dptf dpmf)
        )
    )
    (defun DPTF-DPMF|XP_UpdateVesting (dptf:string dpmf:string)
        @doc "XP Pure Update Function"            
        (require-capability (VST|UPDATE))
        (update DPTF|PropertiesTable dptf
            {"vesting" : dpmf}
        )
        (update DPMF|PropertiesTable dpmf
            {"vesting" : dptf}
        )
    )
    ;;
    (defun DPTF|X_Control
        (
            id:string
            can-change-owner:bool 
            can-upgrade:bool 
            can-add-special-role:bool 
            can-freeze:bool 
            can-wipe:bool 
            can-pause:bool
        )
        (require-capability (DPTF-DPMF|X_CONTROL id true))
        (update DPTF|PropertiesTable id
            {"can-change-owner"                 : can-change-owner
            ,"can-upgrade"                      : can-upgrade
            ,"can-add-special-role"             : can-add-special-role
            ,"can-freeze"                       : can-freeze
            ,"can-wipe"                         : can-wipe
            ,"can-pause"                        : can-pause}
        )
    )
    (defun DPTF|X_Issue:string
        (
            account:string
            name:string 
            ticker:string 
            decimals:integer 
            can-change-owner:bool 
            can-upgrade:bool 
            can-add-special-role:bool 
            can-freeze:bool 
            can-wipe:bool 
            can-pause:bool
        )
        (UTILS.DALOS|UEV_Decimals decimals)
        (UTILS.DALOS|UEV_TokenName name)
        (UTILS.DALOS|UEV_TickerName ticker)
        (require-capability (DPTF-DPMF|ISSUE))
        (insert DPTF|PropertiesTable (DALOS|UC_Makeid ticker)
                {"owner-konto"          : account
                ,"name"                 : name
                ,"ticker"               : ticker
                ,"decimals"             : decimals
                ,"can-change-owner"     : can-change-owner
                ,"can-upgrade"          : can-upgrade
                ,"can-add-special-role" : can-add-special-role
                ,"can-freeze"           : can-freeze
                ,"can-wipe"             : can-wipe
                ,"can-pause"            : can-pause
                ,"is-paused"            : false
                ,"supply"               : 0.0
                ,"origin-mint"          : false
                ,"origin-mint-amount"   : 0.0
                ,"role-transfer-amount" : 0
                ,"fee-toggle"           : false
                ,"min-move"             : -1.0
                ,"fee-promile"          : 0.0
                ,"fee-target"           : DALOS.OUROBOROS|SC_NAME
                ,"fee-lock"             : false
                ,"fee-unlocks"          : 0
                ,"primary-fee-volume"   : 0.0
                ,"secondary-fee-volume" : 0.0
                ,"reward-token"         : [UTILS.BAR]
                ,"reward-bearing-token" : [UTILS.BAR]
                ,"vesting"              : UTILS.BAR
            }
        )
        ;;Creates a new DPTF Account for the Token Issuer and returns id
        (DPTF-DPMF|C_DeployAccount (DALOS|UC_Makeid ticker) account true)
        (DALOS.DALOS|UC_Makeid ticker)
    )
    (defun DPTF|X_Mint (id:string account:string amount:decimal origin:bool)
        (if origin
            (require-capability (DPTF|X_MINT-ORIGIN id amount ))
            (require-capability (DPTF|X_MINT-STANDARD id account amount))
        )
        (DPTF|XO_Credit id account amount)
        (DPTF-DPMF|X_UpdateSupply id amount true true)
        (if origin
            (update DPTF|PropertiesTable id
                { "origin-mint" : false
                , "origin-mint-amount" : amount}
            )
            true
        )
    )
    (defun DPTF|X_SetFee (id:string fee:decimal)
        (require-capability (DPTF|X_SET_FEE id fee))
        (update DPTF|PropertiesTable id
            { "fee-promile" : fee}
        )
    )
    (defun DPTF|X_SetFeeTarget (id:string target:string)
        (require-capability (DPTF|X_SET_FEE-TARGET id target))
        (update DPTF|PropertiesTable id
            { "fee-target" : target}
        )
    )
    (defun DPTF|X_SetMinMove (id:string min-move-value:decimal)
        (require-capability (DPTF|X_SET_MIN-MOVE id min-move-value))
        (update DPTF|PropertiesTable id
            { "min-move" : min-move-value}
        )
    )
    (defun DPTF|X_ToggleFee (id:string toggle:bool)
        (require-capability (DPTF|X_TOGGLE_FEE id toggle))
        (update DPTF|PropertiesTable id
            { "fee-toggle" : toggle}
        )
    )
    (defun DPTF|X_ToggleFeeLock:[decimal] (id:string toggle:bool)
        (require-capability (DPTF|X_TOGGLE_FEE-LOCK id toggle))
        (update DPTF|PropertiesTable id
            { "fee-lock" : toggle}
        )
        (if (= toggle true)
            [0.0 0.0]
            (UTILS.DPTF|UC_UnlockPrice (DPTF|UR_FeeUnlocks id))
        )
    )
    (defun DPTF|X_IncrementFeeUnlocks (id:string)
        (require-capability (DPTF|INCREMENT-LOCKS))
        (with-read DPTF|PropertiesTable id
            { "fee-unlocks" := fu }
            (enforce (< fu 7) (format "Cannot increment Fee Unlocks for Token {}" [id]))
            (update DPTF|PropertiesTable id
                {"fee-unlocks" : (+ fu 1)}
            )
        )
    )
    (defun DPTF|XO_Burn (id:string account:string amount:decimal)
        @doc "Auxiliary that burns a DPTF"
        (enforce-one
            "Burn Not permitted"
            [
                (enforce-guard (create-capability-guard (DPTF|BURN)))
                (enforce-guard (BASIS|C_ReadPolicy "AUTOSTAKE|BurnTrueFungible"))
            ]
        )
        (with-capability (DPTF-DPMF|X_BURN id account amount true)
            (DPTF|XP_Burn id account amount)
        )
    )
    (defun DPTF|XP_Burn (id:string account:string amount:decimal)
        @doc "XP Pure Burn Function"
        (require-capability (DPTF-DPMF|X_BURN id account amount true))
        (DPTF|XO_DebitStandard id account amount)
        (DPTF-DPMF|X_UpdateSupply id amount false true)
    )
    (defun DPTF|XO_Credit (id:string account:string amount:decimal)
        @doc "Auxiliary Function that credits a TrueFungible to a DPTF Account \
            \ If a DPTF Account for the Token ID <id> doesnt exist, it will be created \
            \ However if a DALOS Account (Standard or Smart) doesnt exit for <account>, function will fail, \
            \ since a DALOS Account is mandatory for a DPTF Account creation"
        (enforce-one
            "Credit Not permitted"
            [
                (enforce-guard (create-capability-guard (DPTF|CREDIT)))
                (enforce-guard (BASIS|C_ReadPolicy "AUTOSTAKE|CreditTrueFungible"))
            ]
        )
        (with-capability (DPTF|CREDIT_PUR)
            (DPTF|XP_Credit id account amount)
        )
    )
    (defun DPTF|XP_Credit (id:string account:string amount:decimal )
        @doc "XP Pure Update Function"
        (require-capability (DPTF|CREDIT_PUR))
        (if (DALOS|UC_IzCoreDPTF id)
            (let*
                (
                    (snake-or-gas:bool (if (= id (DALOS.DALOS|UR_OuroborosID)) true false))
                    (read-balance:decimal (DALOS.DALOS|UR_TrueFungible_AccountSupply account snake-or-gas))
                )
                (enforce (>= read-balance 0.0) "Impossible operation, negative Primordial TrueFungible amounts detected")
                (enforce (> amount 0.0) "Crediting amount must be greater than zero, even for Primordial TrueFungibles")
                (with-capability (P|DALOS|UP_BALANCE)
                    (DALOS.DALOS|XO_UpdateBalance account snake-or-gas (+ read-balance amount))
                )
            )
            (let
                (
                    (dptf-account-exist:bool (DPTF-DPMF|URC_AccountExist id account true))
                )
                (enforce (> amount 0.0) "Crediting amount must be greater than zero")
                (if (= dptf-account-exist false)
                    (insert DPTF|BalanceTable (concat [id UTILS.BAR account])
                        { "balance"                         : amount
                        , "role-burn"                       : false
                        , "role-mint"                       : false
                        , "role-transfer"                   : false
                        , "role-fee-exemption"              : false
                        , "frozen"                          : false
                        }
                    )
                    (with-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                        { "balance"                         := b
                        , "role-burn"                       := rb
                        , "role-mint"                       := rm
                        , "role-transfer"                   := rt
                        , "role-fee-exemption"              := rfe
                        , "frozen"                          := f
                        }
                        (write DPTF|BalanceTable (concat [id UTILS.BAR account])
                            { "balance"                     : (+ b amount)
                            , "role-burn"                   : rb
                            , "role-mint"                   : rm
                            , "role-transfer"               : rt
                            , "role-fee-exemption"          : rfe
                            , "frozen"                      : f
                            }   
                        )
                    )
                )
            )
        )
    )
    (defun DPTF|X_DebitAdmin (id:string account:string amount:decimal)
        @doc "Auxiliary Function that debits a TrueFungible from a DPTF Account \
            \ Administrative Variant, used when debiting is executed as a part of wiping by the DPTF Owner"
        (require-capability (DPTF|DEBIT))
        (with-capability (DPTF|DEBIT_PUR)
            (DPTF-DPMF|CAP_Owner id true)
            (DPTF|XP_Debit id account amount)
        )
    )
    (defun DPTF|XO_DebitStandard (id:string account:string amount:decimal)
        @doc "Auxiliary Function that debits a TrueFungible from a DPTF Account \
            \ Standard Variant"
        (enforce-one
            "Standard Debit Not permitted"
            [
                (enforce-guard (create-capability-guard (DPTF|DEBIT)))
                (enforce-guard (BASIS|C_ReadPolicy "AUTOSTAKE|DebitTrueFungible"))
            ]
        )
        (with-capability (DPTF|DEBIT_PUR)
            (DALOS.DALOS|CAP_EnforceAccountOwnership account)
            (DPTF|XP_Debit id account amount)
        )
    )
    (defun DPTF|XP_Debit (id:string account:string amount:decimal)
        @doc "XP Pure Debit Function"
        (require-capability (DPTF|DEBIT_PUR))
        (if (DALOS|UC_IzCoreDPTF id)
            (let*
                (
                    (snake-or-gas:bool (if (= id (DALOS.DALOS|UR_OuroborosID)) true false))
                    (read-balance:decimal (DALOS.DALOS|UR_TrueFungible_AccountSupply account snake-or-gas))
                )
                (enforce (>= read-balance 0.0) "Impossible operation, negative Primordial TrueFungible amounts detected")
                (enforce (<= amount read-balance) "Insufficient Funds for debiting")
                (with-capability (P|DALOS|UP_BALANCE)
                    (DALOS.DALOS|XO_UpdateBalance account snake-or-gas (- read-balance amount))
                )

            )
            (with-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "balance" := balance }
                (enforce (<= amount balance) "Insufficient Funds for debiting")
                (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                    {"balance" : (- balance amount)}    
                )
            )
        )
    )
    (defun DPTF|XO_ToggleFeeExemptionRole (id:string account:string toggle:bool)
        @doc "Auxiliary that toggles Fee Exemption Role for a DPTF Token"
        (enforce-guard (BASIS|C_ReadPolicy "AUTOSTAKE|ToggleFeeExemptionRole"))
        (with-capability (DPTF|X_TOGGLE_FEE-EXEMPTION-ROLE id account toggle)
            (DPTF|XP_ToggleFeeExemptionRole id account toggle)
        )
    )
    (defun DPTF|XP_ToggleFeeExemptionRole (id:string account:string toggle:bool)
        @doc "XP Pure ToggleFeeExemptionRole Function"
        (require-capability (DPTF|X_TOGGLE_FEE-EXEMPTION-ROLE id account toggle))
        (if (DALOS|UC_IzCoreDPTF id)
            (with-capability (P|DALOS|UP_DATA)
                (DALOS.DALOS|XO_UpdateFeeExemptionRole account (= id (DALOS.DALOS|UR_OuroborosID)) toggle)
            )
            (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                {"role-fee-exemption" : toggle}
            )
        )
    )
    (defun DPTF|XO_ToggleMintRole (id:string account:string toggle:bool)
        @doc "Auxiliary that toggles Mint Role for a DPTF Token"
        (enforce-guard (BASIS|C_ReadPolicy "AUTOSTAKE|ToggleMintRole"))
        (with-capability (DPTF|X_TOGGLE_MINT-ROLE id account toggle)
            (DPTF|XP_ToggleMintRole id account toggle)
        )
    )
    (defun DPTF|XP_ToggleMintRole (id:string account:string toggle:bool)
        @doc "XP Pure ToggleMintRole Function"
        (require-capability (DPTF|X_TOGGLE_MINT-ROLE id account toggle))
        (if (DALOS|UC_IzCoreDPTF id)
            (with-capability (P|DALOS|UP_DATA)
                (DALOS.DALOS|XO_UpdateMintRole account (= id (DALOS.DALOS|UR_OuroborosID)) toggle)
            )
            (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                {"role-mint" : toggle}
            )
        )
    )
    (defun DPTF|XO_UpdateFeeVolume (id:string amount:decimal primary:bool)
        @doc "Updates Primary Fee Volume for DPTF <id> with <amount>"
        (enforce-guard (BASIS|C_ReadPolicy "AUTOSTAKE|UpdateFees"))
        (with-capability (DPTF|UPDATE_FEES_PUR)
            (DPTF-DPMF|UEV_Amount id amount true)
            (DPTF|XP_UpdateFeeVolume id amount primary)
        )
    )
    (defun DPTF|XP_UpdateFeeVolume (id:string amount:decimal primary:bool)
        @doc "XP Pure UpdateFeeVolume Function"
        (require-capability (DPTF|UPDATE_FEES_PUR))
        (if primary
            (with-read DPTF|PropertiesTable id
                { "primary-fee-volume" := pfv }
                (update DPTF|PropertiesTable id
                    {"primary-fee-volume" : (+ pfv amount)}
                )
            )
            (with-read DPTF|PropertiesTable id
                { "secondary-fee-volume" := sfv }
                (update DPTF|PropertiesTable id
                    {"secondary-fee-volume" : (+ sfv amount)}
                )
            )
        )
    )
    (defun DPTF|XO_UpdateRewardToken (atspair:string id:string direction:bool)
        @doc "Updates (adds or removes) Reward Token for DPTF <id>"
        (enforce-one
            "Invalid Permissions to update RewardToken"
            [
                (enforce-guard (BASIS|C_ReadPolicy "AUTOSTAKE|UpdateRewardToken"))
                (enforce-guard (BASIS|C_ReadPolicy "OUROBOROS|UpdateRewardToken"))
            ]
        )
        (with-capability (DPTF|UPDATE_RT)
            (DPTF|XP_UpdateRewardToken atspair id direction)
        )
    )
    (defun DPTF|XP_UpdateRewardToken (atspair:string id:string direction:bool)
        @doc "Updates (adds or removes) Reward Token for DPTF <id>"
        (require-capability (DPTF|UPDATE_RT))
        (with-read DPTF|PropertiesTable id
            {"reward-token" := rt}
            (if (= direction true)
                (if (= (at 0 rt) UTILS.BAR)
                    (update DPTF|PropertiesTable id
                        {"reward-token" : [atspair]}
                    )
                    (update DPTF|PropertiesTable id
                        {"reward-token" : (UTILS.LIST|UC_AppendLast rt atspair)}
                    )
                )
                (update DPTF|PropertiesTable id
                    {"reward-token" : (UTILS.LIST|UC_RemoveItem rt atspair)}
                )
            )
        )
    )
    ;;
    (defun DPMF|X_AddQuantity (id:string nonce:integer account:string amount:decimal)
        @doc "Auxiliary Base Function that adds quantity for an existing Metafungible \
            \ Assumes <id> and <nonce> exist on DPMF Account"
        (require-capability (DPMF|X_ADD-QUANTITY id account amount))
        (with-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "unit" := unit }
            (let*
                (
                    (current-nonce-balance:decimal (DPMF|UR_AccountBatchSupply id nonce account))
                    (current-nonce-meta-data (DPMF|UR_AccountBatchMetaData id nonce account))
                    (updated-balance:decimal (+ current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object{DPMF|Schema} (DPMF|UCC_Compose nonce current-nonce-balance current-nonce-meta-data))
                    (updated-meta-fungible:object{DPMF|Schema} (DPMF|UCC_Compose nonce updated-balance current-nonce-meta-data))
                    (processed-unit:[object{DPMF|Schema}] (UTILS.LIST|UC_ReplaceItem unit meta-fungible-to-be-replaced updated-meta-fungible))
                )
                (update DPMF|BalanceTable (concat [id UTILS.BAR account])
                    {"unit" : processed-unit}    
                )
            )
        )
        (DPTF-DPMF|X_UpdateSupply id amount true false)
    )
    (defun DPMF|X_Burn (id:string nonce:integer account:string amount:decimal)
        @doc "Auxiliary Base Function that burns a DPMF"
        (require-capability (DPTF-DPMF|X_BURN id account amount false))
        (DPMF|X_DebitStandard id nonce account amount)
        (DPTF-DPMF|X_UpdateSupply id amount false false)
    )
    (defun DPMF|X_Control
        (
            patron:string
            id:string
            can-change-owner:bool 
            can-upgrade:bool 
            can-add-special-role:bool 
            can-freeze:bool 
            can-wipe:bool 
            can-pause:bool
            can-transfer-nft-create-role:bool
        )
        (require-capability (DPTF-DPMF|X_CONTROL id false))
        (update DPMF|PropertiesTable id
            {"can-change-owner"                 : can-change-owner
            ,"can-upgrade"                      : can-upgrade
            ,"can-add-special-role"             : can-add-special-role
            ,"can-freeze"                       : can-freeze
            ,"can-wipe"                         : can-wipe
            ,"can-pause"                        : can-pause
            ,"can-transfer-nft-create-role"     : can-transfer-nft-create-role}
        )
    )
    (defun DPMF|X_Credit (id:string nonce:integer meta-data:[object] account:string amount:decimal)
        @doc "Auxiliary Function that credits a MetaFungible to a DPMF Account \
            \ Also creates a new DPMF Account if it doesnt exist. \
            \ If account already has DPMF nonce, it is simply increased \
            \ If account doesnt have DPMF nonce, it is added"
        (require-capability (DPMF|CREDIT))
        ;(enforce (> amount 0.0) "Crediting amount must be greater than zero") ;;Allready checked as part of the DPMF|X_TRANSFER
        (let*
            (
                (create-role-account:string (DPMF|UR_CreateRoleAccount id))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
                { "unit" : [DPMF|NEGATIVE]
                , "role-nft-add-quantity" : false
                , "role-nft-burn" : false
                , "role-nft-create" : role-nft-create-boolean
                , "role-transfer" : false
                , "frozen" : false}
                { "unit" := unit
                , "role-nft-add-quantity" := rnaq
                , "role-nft-burn" := rb
                , "role-nft-create" := rnc
                , "role-transfer" := rt
                , "frozen" := f}
                (let*
                    (
                        (next-unit:[object] (if (= unit [DPMF|NEGATIVE]) [DPMF|NEUTRAL] unit))
                        (is-new:bool (if (= unit [DPMF|NEGATIVE]) true false))
                        (current-nonce-balance:decimal (DPMF|UR_AccountBatchSupply id nonce account))
                        (credited-balance:decimal (+ current-nonce-balance amount))
                        (present-meta-fungible:object{DPMF|Schema} (DPMF|UCC_Compose nonce current-nonce-balance meta-data))
                        (credited-meta-fungible:object{DPMF|Schema} (DPMF|UCC_Compose nonce credited-balance meta-data))
                        (processed-unit-with-replace:[object{DPMF|Schema}] (UTILS.LIST|UC_ReplaceItem next-unit present-meta-fungible credited-meta-fungible))
                        (processed-unit-with-append:[object{DPMF|Schema}] (UTILS.LIST|UC_AppendLast next-unit credited-meta-fungible))
                    )
                    (if (= current-nonce-balance 0.0)
                        (write DPMF|BalanceTable (concat [id UTILS.BAR account])
                            { "unit"                        : processed-unit-with-append
                            , "role-nft-add-quantity"       : (if is-new false rnaq)
                            , "role-nft-burn"               : (if is-new false rb)
                            , "role-nft-create"             : (if is-new role-nft-create-boolean rnc)
                            , "role-transfer"               : (if is-new false rt)
                            , "frozen"                      : (if is-new false f)}
                        )
                        (write DPMF|BalanceTable (concat [id UTILS.BAR account])
                            { "unit"                        : processed-unit-with-replace
                            , "role-nft-add-quantity"       : (if is-new false rnaq)
                            , "role-nft-burn"               : (if is-new false rb)
                            , "role-nft-create"             : (if is-new role-nft-create-boolean rnc)
                            , "role-transfer"               : (if is-new false rt)
                            , "frozen"                      : (if is-new false f)}
                        )
                    )
                )
            )
        )
    )
    (defun DPMF|X_Create:integer (id:string account:string meta-data:[object])
        @doc "Auxiliary Base Function that creates a MetaFungible. \
        \ Creating a DPTF means spawning a new DPMF Token as part of al already issued DPMF Token \
        \ Creating is done with zero amount quantity"
        (require-capability (DPMF|X_CREATE id account))
        (let*
            (
                (new-nonce:integer (+ (DPMF|UR_NoncesUsed id) 1))
                (create-role-account:string (DPMF|UR_CreateRoleAccount id))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
                { "unit" : [DPMF|NEUTRAL]
                , "role-nft-add-quantity" : false
                , "role-nft-burn" : false
                , "role-nft-create" : role-nft-create-boolean
                , "role-transfer" : false
                , "frozen" : false}
                { "unit" := u
                , "role-nft-add-quantity" := rnaq
                , "role-nft-burn" := rb
                , "role-nft-create" := rnc
                , "role-transfer" := rt
                , "frozen" := f}
                (let*
                    (
                        (new-nonce:integer (+ (DPMF|UR_NoncesUsed id) 1))
                        (meta-fungible:object{DPMF|Schema} (DPMF|UCC_Compose new-nonce 0.0 meta-data))
                        (appended-meta-fungible:[object{DPMF|Schema}] (UTILS.LIST|UC_AppendLast u meta-fungible))
                    )
                    (write DPMF|BalanceTable (concat [id UTILS.BAR account])
                        { "unit"                        : appended-meta-fungible
                        , "role-nft-add-quantity"       : rnaq
                        , "role-nft-burn"               : rb
                        , "role-nft-create"             : rnc
                        , "role-transfer"               : rt
                        , "frozen"                      : f}
                    )
                    (DPMF|X_IncrementNonce id)
                    new-nonce
                )
            )
        )
    )
    (defun DPMF|X_DebitAdmin (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|DEBIT))
        (with-capability (DPMF|DEBIT_PUR)
            (DPTF-DPMF|CAP_Owner id false)
            (DPMF|X_DebitPure id nonce account amount)
        )
    )
    (defun DPMF|X_DebitStandard (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|DEBIT))
        (with-capability (DPMF|DEBIT_PUR)
            (DALOS.DALOS|CAP_EnforceAccountOwnership account)
            (DPMF|X_DebitPure id nonce account amount)
        )
    )
    (defun DPMF|X_DebitPure (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|DEBIT_PUR))
        (with-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            {"unit"                                 := unit  
            ,"role-nft-add-quantity"                := rnaq
            ,"role-nft-burn"                        := rnb
            ,"role-nft-create"                      := rnc
            ,"role-transfer"                        := rt
            ,"frozen"                               := f}
            (let*
                (
                    (current-nonce-balance:decimal (DPMF|UR_AccountBatchSupply id nonce account))
                    (current-nonce-meta-data (DPMF|UR_AccountBatchMetaData id nonce account))
                    (debited-balance:decimal (- current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object{DPMF|Schema} (DPMF|UCC_Compose nonce current-nonce-balance current-nonce-meta-data))
                    (debited-meta-fungible:object{DPMF|Schema} (DPMF|UCC_Compose nonce debited-balance current-nonce-meta-data))
                    (processed-unit-with-remove:[object{DPMF|Schema}] (UTILS.LIST|UC_RemoveItem unit meta-fungible-to-be-replaced))
                    (processed-unit-with-replace:[object{DPMF|Schema}] (UTILS.LIST|UC_ReplaceItem unit meta-fungible-to-be-replaced debited-meta-fungible))
                )
                (enforce (>= debited-balance 0.0) "Insufficient Funds for debiting")
                (if (= debited-balance 0.0)
                    (update DPMF|BalanceTable (concat [id UTILS.BAR account])
                        {"unit"                     : processed-unit-with-remove
                        ,"role-nft-add-quantity"    : rnaq
                        ,"role-nft-burn"            : rnb
                        ,"role-nft-create"          : rnc
                        ,"role-transfer"            : rt
                        ,"frozen"                   : f}
                    )
                    (update DPMF|BalanceTable (concat [id UTILS.BAR account])
                        {"unit"                     : processed-unit-with-replace
                        ,"role-nft-add-quantity"    : rnaq
                        ,"role-nft-burn"            : rnb
                        ,"role-nft-create"          : rnc
                        ,"role-transfer"            : rt
                        ,"frozen"                   : f}
                    )
                )
            )
        )
    )
    (defun DPMF|X_DebitMultiple (id:string nonce-lst:[integer] account:string balance-lst:[decimal])
        @doc "Auxiliary Function needed for Wiping \
            \ Executes |X_Debit| on a list of nonces and balances via its helper Function |X_DebitPaired|"
        (let
            (
                (nonce-balance-obj-lst:[object{DPMF|Nonce-Balance}] (DPMF|UCC_Pair_Nonce-Balance nonce-lst balance-lst))
            )
            (map (lambda (x:object{DPMF|Nonce-Balance}) (DPMF|X_DebitPaired id account x)) nonce-balance-obj-lst)
        )
    )
    (defun DPMF|X_DebitPaired (id:string account:string nonce-balance-obj:object{DPMF|Nonce-Balance})
        @doc "Helper Function designed for making |X_DebitMultiple| possible, which is needed for Wiping \
            \ Same a |X_Debit| but the nonce and balance are composed into a singular <nonce-balance-obj> object \
            \ Within |X_DebitPaired|, |X_Debit| is called using true <admin> boolean \
            \ which is needed when MetaFungible debitation is executed by DPMF Owner (admin) on another DPMF Account \
            \ as part of the Wiping Process"
        (let
            (
                (nonce:integer (at "nonce" nonce-balance-obj))
                (balance:decimal (at "balance" nonce-balance-obj))
            )
            (DPMF|X_DebitAdmin id nonce account balance)
        )
    )
    (defun DPMF|X_Issue:string
        (
            account:string 
            name:string 
            ticker:string 
            decimals:integer 
            can-change-owner:bool 
            can-upgrade:bool 
            can-add-special-role:bool 
            can-freeze:bool 
            can-wipe:bool 
            can-pause:bool
            can-transfer-nft-create-role:bool
        )
        (UTILS.DALOS|UEV_Decimals decimals)
        (UTILS.DALOS|UEV_TokenName name)
        (UTILS.DALOS|UEV_TickerName ticker)
        (require-capability (DPTF-DPMF|ISSUE))
        (insert DPMF|PropertiesTable (DALOS|UC_Makeid ticker)
            {"owner-konto"          : account
            ,"name"                 : name
            ,"ticker"               : ticker
            ,"decimals"             : decimals
            ,"can-change-owner"     : can-change-owner
            ,"can-upgrade"          : can-upgrade
            ,"can-add-special-role" : can-add-special-role
            ,"can-freeze"           : can-freeze
            ,"can-wipe"             : can-wipe
            ,"can-pause"            : can-pause
            ,"is-paused"            : false
            ,"can-transfer-nft-create-role" : can-transfer-nft-create-role
            ,"supply"               : 0.0
            ,"create-role-account"  : account
            ,"role-transfer-amount" : 0
            ,"nonces-used"          : 0
            ,"reward-bearing-token" : UTILS.BAR
            ,"vesting"              : UTILS.BAR}
        )
        (DPTF-DPMF|C_DeployAccount (DALOS|UC_Makeid ticker) account false)
        (DALOS|UC_Makeid ticker)
    )
    (defun DPMF|X_IncrementNonce (id:string)
        @doc "Increments <id> MetaFungible nonce"
        (require-capability (DPMF|INCREMENT_NONCE))
        (with-read DPMF|PropertiesTable id
            { "nonces-used" := nu }
            (update DPMF|PropertiesTable id { "nonces-used" : (+ nu 1)})
        )
    )
    (defun DPMF|X_Mint:integer (id:string account:string amount:decimal meta-data:[object])
        @doc "Auxiliary Base Function that mints a DPMF \
        \ Minting a DPTF means creating it, and then designating directly an amount for it. \
        \ Returns the nonce of the minted DPMF"
        (require-capability (DPMF|X_MINT id account amount))
        (let
            (
                (new-nonce:integer (+ (DPMF|UR_NoncesUsed id) 1))
            )
            (DPMF|X_Create id account meta-data)
            (DPMF|X_AddQuantity id new-nonce account amount)
            new-nonce
        )
    )
    (defun DPMF|X_Transfer (id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Transfers <id> MetaFungible from <sender> to <receiver> DPMF Account without GAS"
        (require-capability (DPMF|X_TRANSFER id sender receiver transfer-amount method))
        (let
            (
                (current-nonce-meta-data (DPMF|UR_AccountBatchMetaData id nonce sender))
                (ea-id:string (DALOS.DALOS|UR_EliteAurynID))
            )
            (DPMF|X_DebitStandard id nonce sender transfer-amount)
            (DPMF|X_Credit id nonce current-nonce-meta-data receiver transfer-amount)
            (DPTF-DPMF|X_UpdateElite id sender receiver)
        )
    )
    (defun DPMF|XK_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Kore DPMF Transfer Function"
        (require-capability (DALOS|EXECUTOR))
        (if (not (DALOS.IGNIS|URC_ZeroGAZ id sender receiver))
            (DALOS.IGNIS|X_Collect patron sender DALOS.GAS_SMALLEST)
            true
        )
        (DPMF|X_Transfer id nonce sender receiver transfer-amount method)
        (DALOS.DALOS|X_IncrementNonce sender)
    )
    (defun DPMF|XO_MoveCreateRole (id:string receiver:string)
        @doc "Auxiliary that Moves the Create Role for a DPMF Token"
        (enforce-guard (BASIS|C_ReadPolicy "AUTOSTAKE|MoveCreateRole"))
        (with-capability (DPMF|X_MOVE_CREATE-ROLE id receiver)
            (DPMF|XP_MoveCreateRole id receiver)
        )
    )
    (defun DPMF|XP_MoveCreateRole (id:string receiver:string)
        @doc "XP Pure MoveCreateRole Function"
        (require-capability (DPMF|X_MOVE_CREATE-ROLE id receiver))
        (update DPMF|BalanceTable (concat [id UTILS.BAR (DPMF|UR_CreateRoleAccount id)])
            {"role-nft-create" : false}
        )
        (update DPMF|BalanceTable (concat [id UTILS.BAR receiver])
            {"role-nft-create" : true}
        )
        (update DPMF|PropertiesTable id
            {"create-role-account" : receiver}
        )
    )
    (defun DPMF|XO_ToggleAddQuantityRole (id:string account:string toggle:bool)
        @doc "Auxiliary that Toggles the Add Quantity Role for a DPMF Token"
        (enforce-guard (BASIS|C_ReadPolicy "AUTOSTAKE|ToggleAddQuantityRole"))
        (with-capability (DPMF|X_TOGGLE_ADD-QUANTITY-ROLE id account toggle)
            (DPMF|XP_ToggleAddQuantityRole id account toggle)
        )
    )
    (defun DPMF|XP_ToggleAddQuantityRole (id:string account:string toggle:bool)
        @doc "XP Pure oggleAddQuantityRole Function"
        (require-capability (DPMF|X_TOGGLE_ADD-QUANTITY-ROLE id account toggle))
        (update DPMF|BalanceTable (concat [id UTILS.BAR account])
            {"role-nft-add-quantity" : toggle}
        )
    )
)
;;Policies Table
(create-table BASIS|PoliciesTable)
;;[T] DPTF Tables
(create-table DPTF|PropertiesTable)
(create-table DPTF|BalanceTable)
;;[M] DPMF Tables
(create-table DPMF|PropertiesTable)
(create-table DPMF|BalanceTable)