


(module OUROBOROS GOVERNANCE
    @doc "The OUROBOROS Module contains 4 submodules as logic subgrouping of constants, schemas, tables, capabilities and functions \
        \ Since pact doesnt support nested modules, the | separator will be used to differentiate between submodules \
        \ \
        \ [D] [1]DALOS Submodule\
        \ is the Demiourgos.Holdings Core Module that defines the Core Functions of the DALOS Virtual Blockchain \
        \ The Core Functionality reffers to the construct of DALOS or Demiourgos-Pact-Token Standard \
        \ The DALOS Module manages the functionality of the so called DALOS Account \
        \ which holds all the information needed to operate on the DALOS Virtual Blockchain \
        \ \
        \ The DALOS Elite, is also part of the DALOS Account: \
        \ DALOS Elite depends on the amount of Elite-Auryn and Vested-Elite-Auryn owned by Users \
        \ 7 Elite-Tier brings huge benefits accross the whole of DALOS Ecosystem.\ 
        \ Elite-AURYN and Vested-Elite-AURYN are autostaked AURYN, which itself is autostaked OUROBOROS \
        \ \
        \ \
        \ [TM] [2]DPTF-DPMF Submodule \
        \ encompases capabilities and functions common to both DPTF and DPMF Submodules \
        \ \
        \ \
        \ [T] [3]DPTF Submodule\
        \ or Demiourgos-Pact-True-Fungible is a Token Standard implemented by Demiurgos.Holdings on Pact \
        \ DPTF Tokens, also known as DALOS True-Fungibles, are the 1st of 4 Token Types existing on DALOS Virtual Blockchain \
        \ \
        \ \
        \ [M] [4]DPMF Submodule \
        \ or Demiourgos-Pact-Meta-Fungible is a Token Standard implemented by Demiourgos.Holdings on Pact \
        \ DPMF Tokens, also known as DALOS Meta-Fungibles, are the 2nd of the 4 Token Types existing on DALOS Virtual Blockchain \
        \ \
        \ \
        \ [G] [5]GAS Submodule \
        \ contains functions that define the GAS mechanics on the DALOS Virtual Blockchain \
        \ The GAS Token of the DALOS Virtual Blockchain is represented by the IGNIS DPTF Token: \
        \ The IGNIS DPTF Token is generated from the OURO DPTF Token, with OURO (Ouroboros) acting as an indirect <gas> Token \
        \ As OURO can natively be converted to IGNIS to pay the gas fees, so can IGNIS be natively compressed to OURO \
        \ \
        \ \
        \ [A] [6]ATS Submodule \
        \ The ATS or Autostkae Module encompasses all the functions and capabilities needed to create \ 
        \ the native Autostake Capability for DPTF Tokens existing on the DALOS Virtual Blockchain \
        \ \
        \ \
        \ [L] [7]LIQUID Submodule \
        \ contains functions that pertain to the Kadena-Liquid-Staking protocol operating on the DALOS Virtual Blockchain \
        \ The Liquid Staking Protocol operates natively on the DALOS Virtual Blockchain, with operations collecting native Kadena as fees, \
        \ directly fueling the Liquid-Index (see below)  \
        \ Native Kadena Tokens can be wrapped into DWK (DalosWrappedKadena) DPTF Tokens, with the DWK Token representing the DPTF equivalent of native Kadena; \
        \ DWK Tokens together with DLK (Dalos Liquid Kadena) create an ATS-Pair (Autostake Pair) using the native DALOS Autostake functionality \
        \ 15% of all collected KDA fees fuel the Pair's Liquid-Index, increasing the value of DLK in DWK. \
        \ \
        \ \
        \ [V] [8]VST Submodule \
        \ The VST or Vesting Submodule contains functions and capabilities required for creating the native DPTF Vesting Functionality \
        \ existing on the DALOS Virtual Blockchain. The vesting functionality allows creatin of what are called vesting Pairs \
        \ wherewith a DPTF Token is immutable linked to its counterpart DPMF Token acting as the Vesting Counterpart. \
        \ DPTF Token owners can then <vest> their DPTF Tokens to a target account of their choosing, using 3 parametrs \
        \ <offset>, <duration>, and <milestones> to define how the vesting behaves. Clients can then unvest their vested DPMF tokens, \
        \ when the vesting expires, receiving DPTF Tokens. The DPMF Tokens are non stransferable by default, and cannot be used for anything other \
        \ than for keeping a record of the vesting, as long as the vesting mechanic is kept in place by the DPTF Token Owner. \
        \ This way, any DPTF Token Owner has vesting capabilities for their Tokens.\ 
        \ \
        \ The Vesting functionality can be even combined with the Autostake Functionality, \
        \ with Token owners being able to coil their tokens and vest the output directly to a target account for more granular control of their tokens \
        \ with everthing being supported natively, at the <protocol-level> " 

    (use UTILITY)
;;  0]GOVERNANCE Capabilitis:
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
            \ Remove Comment below so that only ADMIN (<free.DH_Master-Keyset>) can enact an upgrade"
        ;true
        (compose-capability (DEMIURGOI))
    )
    ;;[D] DALOS Governance
    (defcap DEMIURGOI ()
        @doc "Capability enforcing the DALOS Demiurgoi admins"
        (enforce-guard (keyset-ref-guard DALOS|DEMIURGOI))
    )
    ;;[T] DPTF Governance
    (defcap OUROBOROS ()
        @doc "Capability enforcing the OUROBOROS Administrator"
        (enforce-one
            "Keyset not valid for Ouroboros Smart DALOS Account Operations"
            [
                (enforce-guard (keyset-ref-guard DALOS|DEMIURGOI))
                (enforce-guard (keyset-ref-guard DPTF|SC_KEY))
            ]
        )
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    ;;[G] GAS Governance
    (defcap GAS-TANKER ()
        @doc "Capability enforcing the GasTanker Administrator"
        (enforce-one
            "Keyset not valid for GasTanker Smart DALOS Account Operations"
            [
                (enforce-guard (keyset-ref-guard DALOS|DEMIURGOI))
                (enforce-guard (keyset-ref-guard GAS|SC_KEY))
            ]
        )
    )
    ;;[L] LIQUID Governance
    (defcap LIQUID-STAKING ()
        @doc "Capability enforcing the KadenaLiquidStaking Administrator"
        (enforce-one
            "Keyset not valid for KadenaLiquidStaking Smart DALOS Account Operations"
            [
                (enforce-guard (keyset-ref-guard DALOS|DEMIURGOI))
                (enforce-guard (keyset-ref-guard LIQUID|SC_KEY))
            ]
        )
    )
    ;;[A] AUTOSTAKE Governance
    (defcap AUTOSTAKE ()
        @doc "Capability enforcing the DalosAutostake Administrator"
        (enforce-one
            "Keyset not valid for DalosAutostake Smart DALOS Account Operations"
            [
                (enforce-guard (keyset-ref-guard DALOS|DEMIURGOI))
                (enforce-guard (keyset-ref-guard ATS|SC_KEY))
            ]
        )
    )
    ;;[V] VESTING Governance
    (defcap VESTING ()
        @doc "Capability enforcing the DalosVesting Administrator"
        (enforce-one
            "Keyset not valid for DalosVesting Smart DALOS Account Operations"
            [
                (enforce-guard (keyset-ref-guard DALOS|DEMIURGOI))
                (enforce-guard (keyset-ref-guard VST|SC_KEY))
            ]
        )
    )
    (defcap COMPOSE ()
        @doc "Capability used to compose multiple functions in an IF statement"
        true
    )
;;  1]CONSTANTS Definitions
    ;;1.1]Account and KEYs IDs
    ;;[D] Demiurgoi IDs
    (defconst DALOS|DEMIURGOI "free.DH_Master-Keyset")                                
    (defconst DALOS|CTO "k:50d6c59b21e5e6e55baecaa75a1007de37576bde12d8230dc82459cc01b9484b")
    (defconst DALOS|HOV "k:0cb30c0121ff919266121a99ff9359871818932211df94dae4137c29bc0e8f7e")
    ;;[T] Ouroboros Account ids for DPTF Submodule
    (defconst DPTF|SC_KEY "free.DH_SC_Ouroboros-Keyset")
    (defconst DPTF|SC_NAME "Ouroboros")
    (defconst DPTF|SC_KDA-NAME "k:7c9cd45184af5f61b55178898e00404ec04f795e10fff14b1ea86f4c35ff3a1e")
    ;;[G] GasTanker Account ids for GAS Submodule
    (defconst GAS|SC_KEY "free.DH_SC_GAS-Keyset")
    (defconst GAS|SC_NAME "GasTanker")
    (defconst GAS|SC_KDA-NAME "k:e0eab7eda0754b0927cb496616a7ab153bfd5928aa18d19018712db9c5c5c0b9")
    ;;[L] Liquidizer Account ids for LIQUID Submodule
    (defconst LIQUID|SC_KEY "free.DH_SC_KadenaLiquidStaking-Keyset")
    (defconst LIQUID|SC_NAME "Liquidizer")
    (defconst LIQUID|SC_KDA-NAME "k:a3506391811789fe88c4b8507069016eeb9946f3cb6d0b6214e700c343187c98")
    ;;[A] Autostake Account ids for ATS Submodule
    (defconst ATS|SC_KEY "free.DH_SC_Autostake-Keyset")
    (defconst ATS|SC_NAME "DalosAutostake")
    (defconst ATS|SC_KDA-NAME "k:89faf537ec7282d55488de28c454448a20659607adc52f875da30a4fd4ed2d12")
    ;;[V] Vesting Account ids for Vesting Submodule
    (defconst VST|SC_KEY "free.DH_SC_Vesting-Keyset")
    (defconst VST|SC_NAME "DalosVesting")
    (defconst VST|SC_KDA-NAME "k:4728327e1b4790cb5eb4c3b3c531ba1aed00e86cd9f6252bfb78f71c44822d6d")

    ;;
    ;;1.2]Table Keys
    ;;[D] DALOS Table Keys
    (defconst DALOS|INFO "DalosInformation")
    (defconst DALOS|PRICES "DalosPrices")
    ;;[G] GAS Table Keys
    (defconst GAS|VGD "VirtualGasData")
    ;;1.3]Other Constants
    ;;[A] Autostake Constants
    (defconst NULLTIME (time "1984-10-11T11:10:00Z"))
    (defconst ANTITIME (time "1983-08-07T11:10:00Z"))

;;  2]SCHEMAS Definitions
    ;;[D] DALOS Schemas
    (defschema DALOS|PropertiesSchema
        unity-id:string
        gas-source-id:string
        gas-source-id-price:decimal
        gas-id:string
        ats-gas-source-id:string
        elite-ats-gas-source-id:string
        wrapped-kda-id:string
        liquid-kda-id:string
    )
    (defschema DALOS|PricesSchema
        @doc "Schema that stores DALOS KDA prices for specific operations"
        standard:decimal
        smart:decimal
        dptf:decimal
        dpmf:decimal
        dpsf:decimal
        dpnf:decimal
        blue:decimal
    )
    (defschema DALOS|AccountSchema
        @doc "Schema that stores DALOS Account Information"
        guard:guard                         ;;Guard of the DALOS Account
        sovereign:string                    ;;Stores the Sovereign Account (Can only be a Standard DALOS Account)
                                            ;;The Sovereign Account, is the Account that has ownership of this Account;
                                            ;;For Normal DALOS Account, the Sovereign is itself (The Key of the Table Data)
                                            ;;For Smart DALOS Account, the Sovereign is another Normal DALOS Account

        smart-contract:bool                 ;;When true DALOS Account is a Smart DALOS Account, if <false> it is a Standard DALOS Account
        payable-as-smart-contract:bool      ;;when true, a Smart DALOS Account is payable by other Normal DALOS Accounts
        payable-by-smart-contract:bool      ;;when true, a Smart DALOS Account is payable by other Smart DALOS Accounts
        payable-by-method:bool              ;;when true, a Smart DALOS Account is payable only through special Functions
        governor:string                     ;;Stores the Governing Module String.

        nonce:integer                       ;;stores how many transactions the DALOS Account executed
        kadena-konto:string                 ;;stores the underlying Kadena principal Account that was used to create the DALOS Account
                                            ;;this account is used for KDA payments. The guard for this account is not stored in this module
                                            ;;Rather the guard of the kadena account saved here, is stored in the table inside the coin module
        elite:object{DALOS|EliteSchema}
    )
    (defschema DALOS|EliteSchema
        @doc "Schema that tracks DALOS Elite Account Information"
        class:string
        name:string
        tier:string
        deb:decimal
    )
    (defconst DALOS|PLEB
        { "class" : "NOVICE"
        , "name"  : "Infidel"
        , "tier"  : "0.0"
        , "deb"   : 1.0 }
    )
    (defconst DALOS|VOID
        { "class" : "VOID"
        , "name"  : "Undead"
        , "tier"  : "0.0"
        , "deb"   : 0.0 }
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
        reward-token:[string]
        reward-bearing-token:[string]
        ;;Vesting
        vesting:string
    )
    (defschema DPTF|BalanceSchema
        @doc "Schema that Stores Account Balances for DPTF Tokens (True Fungibles)\
            \ Key for the Table is a string composed of: <DPTF id> + UTILITY.BAR + <account> \
            \ This ensure a single entry per DPTF id per account."
        balance:decimal
        ;;Special Roles
        role-burn:bool
        role-mint:bool
        role-transfer:bool
        role-fee-exemption:bool                         
        ;;States
        frozen:bool
    )

    ;;[M] DPMF Schemas
    (defschema DPMF|PropertiesSchema
        @doc "Schema for DPMF Token (MEta Fungibles) Properties \
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
        reward-bearing-token:string
        ;;Vesting
        vesting:string
    )
    (defschema DPMF|BalanceSchema
        @doc "Schema that Stores Account Balances for DPMF Tokens (Meta Fungibles)\
            \ Key for the Table is a string composed of: <DPMF id> + UTILITY.BAR + <account> \
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
    ;;[G] GAS Schemas
    (defschema GAS|PropertiesSchema
        @doc "Schema that stores DPTF id for the Gas Token of the Virtual Blockchain \
        \ The boolean <virtual-gas-toggle> toggles wheter or not the virtual gas is enabled or not"
        virtual-gas-tank:string
        virtual-gas-toggle:bool
        virtual-gas-spent:decimal
        native-gas-toggle:bool
        native-gas-spent:decimal
    )
    ;;[A] ATS Schemas
    (defschema ATS|PropertiesSchema
        owner-konto:string
        can-change-owner:bool
        parameter-lock:bool
        unlocks:integer
        ;;Index
        pair-index-name:string
        index-decimals:integer
        ;;Reward Tokens
        reward-tokens:[object{ATS|RewardTokenSchema}]
        ;;Cold Reward Bearing Token Info
        c-rbt:string
        c-nfr:bool
        c-positions:integer
        c-limits:[decimal]
        c-array:[[decimal]]
        c-fr:bool
        c-duration:[integer]
        c-elite-mode:bool
        ;;Hot Reward Bearing Token Info
        h-rbt:string
        h-promile:decimal
        h-decay:integer
        h-fr:bool
        ;; Activation Toggles
        cold-recovery:bool
        hot-recovery:bool
    )
    (defschema ATS|RewardTokenSchema
        token:string
        nfr:bool
        resident:decimal
        unbonding:decimal
    )
    ;;==
    (defschema ATS|BalanceSchema
        @doc "Schema that Stores ATS Unstake Information for ATS Pairs (True Fungibles)\
            \ Key for the Table is a string composed of: <ATS-Pair> + UTILITY.BAR + <account> \
            \ This ensure a single entry per ATS Pair per account."
        P0:[object{ATS|Unstake}]
        P1:object{ATS|Unstake}
        P2:object{ATS|Unstake}
        P3:object{ATS|Unstake}
        P4:object{ATS|Unstake}
        P5:object{ATS|Unstake}
        P6:object{ATS|Unstake}
        P7:object{ATS|Unstake}
    )
    (defschema ATS|Unstake
        reward-tokens:[decimal]
        cull-time:time
    )
    (defschema ATS|Hot
        mint-time:time
    )
    
    ;;[L] LIQUID Schemas - NONE
    ;;[V] VST Schemas - NONE
    ;;
    ;;
;;  3]TABLES Definitions
    ;;[D] DALOS Tables
    (deftable DALOS|PropertiesTable:{DALOS|PropertiesSchema})
    (deftable DALOS|PricesTable:{DALOS|PricesSchema})
    (deftable DALOS|AccountTable:{DALOS|AccountSchema})
    ;;[T] DPTF Tables
    (deftable DPTF|PropertiesTable:{DPTF|PropertiesSchema})
    (deftable DPTF|BalanceTable:{DPTF|BalanceSchema})
    ;;[M] DPMF Tables
    (deftable DPMF|PropertiesTable:{DPMF|PropertiesSchema})
    (deftable DPMF|BalanceTable:{DPMF|BalanceSchema})
    ;;[G] GAS Tables
    (deftable GAS|PropertiesTable:{GAS|PropertiesSchema})
    ;;[A] ATS Tables
    (deftable ATS|Pairs:{ATS|PropertiesSchema})
    (deftable ATS|Ledger:{ATS|BalanceSchema})
    ;;[L] LIQUID Tables - NONE
    ;;[V] VST Tables - NONE
    ;;
    ;;
    ;;
    ;;Decentralized Asset Ledger Omnipotent Sovereign; [1] DALOS Submodule
    ;;
    ;;
    ;;
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
        (UTILITY.DALOS|UV_PositionalVariable table-to-query 3 "Table To Query can only be 1 2 or 3")
        (if (= mode true)
            (UTILITY.DALOS|UV_Account account-or-token-id)
            (with-capability (COMPOSE)
                (if (= table-to-query 1)
                    (DPTF-DPMF|UVE_id account-or-token-id true)
                    (if (= table-to-query 2)
                        (DPTF-DPMF|UVE_id account-or-token-id false)
                        (ATS|UVE_id account-or-token-id) 
                    )
                )
            )
        )
        (let*
            (
                (keyz:[string]
                    (if (= table-to-query 1)
                        (keys DPTF|BalanceTable)
                        (if (= table-to-query 2)
                            (keys DPMF|BalanceTable)
                            (keys ATS|Ledger)
                        )
                    )
                )
                (listoflists:[[string]] (map (lambda (x:string) (UTILITY.UC_SplitString UTILITY.BAR x)) keyz))
                (output:[string] (DALOS|UC_Filterid listoflists account-or-token-id))
            )
            output
        )
    )
    ;;========    CAPABILITIES-EXPORTED-AS-FUNCTIONS===========================;;
    ;;Enforce Capability Verification instead of granting it
    (defun DALOS|CAP|StandardAccount (account:string)
        (with-capability (DALOS|IZ_ACCOUNT_SMART account false)
            true
        )
    )
    (defun DALOS|CAP|SmartAccount (account:string)
        (with-capability (DALOS|IZ_ACCOUNT_SMART account true)
            true
        )
    )
    (defun VST|CAP|Existance (id:string token-type:bool existance:bool)
        (with-capability (VST|EXISTANCE id token-type existance)
            true
        )
    )
    (defun VST|CAP|Active (dptf:string dpmf:string)
        (with-capability (VST|ACTIVE dptf dpmf)
            true
        )
    )
    ;;========    SMART ACCOUNT AUTOMATIC OWNERSHIP============================;;
    ;;Step 1, create the capability
    (defcap DALOS|SMART_OWNERSHIP ()
        true
    )
    ;;Step 2, create a guard from the capability
    (defun DALOS|MakeSmartGuard:guard ()
        (create-capability-guard (DALOS|SMART_OWNERSHIP))
    )
    ;;Step 3, create the principal, which is the KDA address
    (defconst DALOS|SMART|SC_KDA-NAME (create-principal (DALOS|MakeSmartGuard)))
    ;;Step 4, create a coin.account
    (defun DALOS|SpawnPrimordialSmartAccount ()
        (coin.create-account DALOS|SMART|SC_KDA-NAME DALOS|MakeSmartGuard)
    )
    ;;========[D] CAPABILITIES=================================================;;
    ;;1.1]    [D] DALOS Capabilities
    ;;1.1.1]  [D]   DALOS Basic Capabilities
    (defcap DALOS|EXIST (account:string)
        @doc "Enforces that a DALOS Account exists"
        (DALOS|UVE_id account)
    )
    (defcap DALOS|ACCOUNT_OWNER (account:string)
        @doc "Enforces DALOS Account Ownership"
        (enforce-guard (DALOS|UR_AccountGuard account))
    )
    (defun DALOS|EnforceSmartAccount (account:string)
        (with-capability (DALOS|ABS_ACCOUNT_OWNER account)
            true
        )
    )
    (defcap DALOS|ABS_ACCOUNT_OWNER (account:string)
        @doc "Enforces DALOS Account Ownership"
        (let*
            (
                (type:bool (DALOS|UR_AccountType account))
            )
            (if type
                (DALOS|EnforceSmartAccount_Core account)
                (DALOS|EnforceStandardAccount_Core account)
            )
        )
    )
    (defun DALOS|EnforceStandardAccount_Core (account:string)
        @doc "Enforces ownership parameters for a Standard DALOS Account"
        (let
            (
                (sovereign:string (DALOS|UR_AccountSovereign account))
                (governor:string (DALOS|UR_AccountGovernor account))
            )
            (enforce (= sovereign account) "Incompatible Sovereign for Standard DALOS Account")
            (enforce (= governor UTILITY.BAR) "Incompatible Governer for Standard DALOS Account")
            (enforce-guard (DALOS|UR_AccountGuard account))
        )
    )
    (defun DALOS|EnforceSmartAccount_Core (account:string)
        (let*
            (
                (sovereign:string (DALOS|UR_AccountSovereign account))
                (governor:string (DALOS|UR_AccountGovernor account))
                (gov:string (+ "(" governor))
                (lengov:integer (length gov))
            )
            (enforce (!= sovereign account) "Incompatible Sovereign for Smart DALOS Account")
            (enforce (!= governor UTILITY.BAR) "Incompatible Governor for Smart DALOS Account")
            (enforce-one
                "Insuficient Permissions to handle a Smart DALOS Account"
                [
                    (enforce-guard (DALOS|UR_AccountGuard account))
                    (enforce (= gov (take lengov (at 0 (at "exec-code" (read-msg))))) "Enforce Smart Contract Governance Module Usage")
                ]
            )
        )
    )
    (defcap DALOS|IZ_ACCOUNT_SMART (account:string smart:bool)
        @doc "Enforces that a DALOS Account is either Normal (<smart-contract> boolean false) or Smart (<smart-contract> boolean true) \
            \ If the input DALOS Account doesnt exist, it is considered Normal"
        (UTILITY.DALOS|UV_Account account)
        (let
            (
                (x:bool (DALOS|UR_AccountType account))
            )
            (if (= smart true)
                (enforce (= x true) (format "Account {} is not a SC Account, when it should have been, for the operation to execute" [account]))
                (enforce (= x false) (format "Account {} is a SC Account, when it shouldnt have been, for the operation to execute" [account]))
            )
        )
    )
    
    (defcap DALOS|TRANSFERABILITY (sender:string receiver:string)
        @doc "Enforces transferability between <sender> and <receiver>"
        (compose-capability (DALOS|METHODIC_TRANSFERABILITY sender receiver false))
    )
    (defcap DALOS|METHODIC_TRANSFERABILITY (sender:string receiver:string method:bool)
        @doc "Enforces transferability between <sender>, <receiver> and <method>"
        (let
            (
                (x:bool (DALOS|UC_MethodicTransferability sender receiver method))
            )
            (enforce (= x true) (format "Transferability between {} and {} with {} Method is not ensured" [sender receiver method]))
        )
    )
    (defcap DALOS|INCREASE-NONCE ()
        @doc "Capability required to increment the DALOS nonce"
        true
    )
    (defcap DALOS|UPDATE_ELITE ()
        @doc "Capability required to update Elite-Account Information"
        true
    )
    (defcap DALOS|EXECUTOR ()
        @doc "Capability Required to Execute DPTF, DPMF, ATS, VST Functions"
        true
    )
    ;;1.1.2]  [D]   DALOS Composed Capabilities
    (defcap DALOS|CLIENT (account:string)
        @doc "Enforces DALOS Account ownership if its a Standard DALOS Account \
            \ Fails if account doesnt exist via the last capability"
        @managed
        (let
            (
                (iz-sc:bool (DALOS|UR_AccountType account))
            )
            (if (= iz-sc true)
                true
                (compose-capability (DALOS|ACCOUNT_OWNER account))
            )
        )
    )
    (defcap DALOS|METHODIC (client:string method:bool)
        (if (= method true)
            (compose-capability (DALOS|IZ_ACCOUNT_SMART client true))
            (compose-capability (DALOS|ACCOUNT_OWNER client))
        )
    )
    (defcap DALOS|CONTROL_SMART-ACCOUNT (patron:string account:string pasc:bool pbsc:bool pbm:bool)
        @doc "Capability required to Control a Smart DALOS Account"
        (compose-capability (DALOS|CONTROL_SMART-ACCOUNT_CORE account pasc pbsc pbm))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DALOS|CONTROL_SMART-ACCOUNT_CORE (account:string pasc:bool pbsc:bool pbm:bool)
        @doc "Core Capability required to Control a Smart DALOS Account"
        (compose-capability (DALOS|ACCOUNT_OWNER account))     
        (compose-capability (DALOS|IZ_ACCOUNT_SMART account true))
        (enforce (= (or (or pasc pbsc) pbm) true) "At least one Smart DALOS Account parameter must be true")
    )
    (defcap DALOS|ROTATE_ACCOUNT (patron:string account:string)
        @doc "Capability required to rotate(update|change) DALOS Account information (Kadena-Konto and Guard)"
        (compose-capability (DALOS|ACCOUNT_OWNER account))   
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DALOS|ROTATE_SOVEREIGN (patron:string account:string new-sovereign:string)
        (compose-capability (DALOS|SOVEREIGN account new-sovereign))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DALOS|SOVEREIGN (account:string new-sovereign:string)
        (compose-capability (DALOS|ACCOUNT_OWNER account)) 
        (compose-capability (DALOS|IZ_ACCOUNT_SMART account true))
        (compose-capability (DALOS|IZ_ACCOUNT_SMART new-sovereign false))
        (DALOS|UV_SenderWithReceiver (DALOS|UR_AccountSovereign account) new-sovereign)
    )
    (defcap DALOS|ROTATE_GOVERNOR (patron:string account:string governor:string)
        (compose-capability (DALOS|GOVERNOR account governor))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DALOS|GOVERNOR (account:string governor:string)
        (compose-capability (DALOS|ACCOUNT_OWNER account)) 
        (compose-capability (DALOS|IZ_ACCOUNT_SMART account true))
    )

    ;;========[D] FUNCTIONS====================================================;;
    ;;1.2]    [D] DALOS Functions
    ;;1.2.1]  [D]   DALOS Utility Functions
    ;;1.2.1.0][D]           Properties Info
    (defun DALOS|UR_UnityID:string ()
        @doc "Returns the Unity ID"
        (at "unity-id" (read DALOS|PropertiesTable DALOS|INFO ["unity-id"]))
    )
    (defun DALOS|UR_OuroborosID:string ()
        @doc "Returns the Ouroboros ID"
        (at "gas-source-id" (read DALOS|PropertiesTable DALOS|INFO ["gas-source-id"]))
    )
    (defun DALOS|UR_OuroborosPrice:decimal ()
        @doc "Returns the Ouroboros ID"
        (at "gas-source-id-price" (read DALOS|PropertiesTable DALOS|INFO ["gas-source-id-price"]))
    )
    (defun DALOS|UR_IgnisID:string ()
        @doc "Returns the Ignis ID"
        (with-default-read DALOS|PropertiesTable DALOS|INFO 
            { "gas-id" :  UTILITY.BAR }
            { "gas-id" := gas-id}
            gas-id
        )
    )
    (defun DALOS|UR_AurynID:string ()
        @doc "Returns the Auryn ID"
        (at "ats-gas-source-id" (read DALOS|PropertiesTable DALOS|INFO ["ats-gas-source-id"]))
    )
    (defun DALOS|UR_EliteAurynID:string ()
        @doc "Returns the Elite-Auryn ID"
        (at "elite-ats-gas-source-id" (read DALOS|PropertiesTable DALOS|INFO ["elite-ats-gas-source-id"]))
    )
    (defun DALOS|UR_WrappedKadenaID:string ()
        @doc "Returns the Wrapped KDA ID"
        (at "wrapped-kda-id" (read DALOS|PropertiesTable DALOS|INFO ["wrapped-kda-id"]))
    )
    (defun DALOS|UR_LiquidKadenaID:string ()
        @doc "Returns the Liquid KDA ID"
        (at "liquid-kda-id" (read DALOS|PropertiesTable DALOS|INFO ["liquid-kda-id"]))
    )
    ;;1.2.1.1][D]           Account Info
    (defun DALOS|UR_AccountGuard:guard (account:string)
        @doc "Returns DALOS Account <account> Guard"
        (at "guard" (read DALOS|AccountTable account ["guard"]))
    )
    (defun DALOS|UR_AccountProperties:[bool] (account:string)
        @doc "Returns a boolean list with DALOS Account Type properties"
        (UTILITY.DALOS|UV_Account account)
        (with-default-read DALOS|AccountTable account
            { "smart-contract" : false, "payable-as-smart-contract" : false, "payable-by-smart-contract" : false, "payable-by-method" : false}
            { "smart-contract" := sc, "payable-as-smart-contract" := pasc, "payable-by-smart-contract" := pbsc, "payable-by-method" := pbm }
            [sc pasc pbsc pbm]
        )
    )
    (defun DALOS|UR_AccountType:bool (account:string)
        @doc "Returns DALOS Account <account> Boolean type"
        (at 0 (DALOS|UR_AccountProperties account))
    )
    (defun DALOS|UR_AccountPayableAs:bool (account:string)
        @doc "Returns DALOS Account <account> Boolean payables-as-smart-contract"
        (at 1 (DALOS|UR_AccountProperties account))
    )
    (defun DALOS|UR_AccountPayableBy:bool (account:string)
        @doc "Returns DALOS Account <account> Boolean payables-by-smart-contract"
        (at 2 (DALOS|UR_AccountProperties account))
    )
    (defun DALOS|UR_AccountPayableByMethod:bool (account:string)
    @doc "Returns DALOS Account <account> Boolean payables-by-smart-contract"
        (at 3 (DALOS|UR_AccountProperties account))
    )
    (defun DALOS|UR_AccountNonce:integer (account:string)
        @doc "Returns DALOS Account <account> nonce value"
        (UTILITY.DALOS|UV_Account account)
        (with-default-read DALOS|AccountTable account
            { "nonce" : 0 }
            { "nonce" := n }
            n
        )
    )
    (defun DALOS|UR_AccountSovereign:string (account:string)
        @doc "Returns DALOS Account <sovereign> Account"
        (at "sovereign" (read DALOS|AccountTable account ["sovereign"]))
    )
    (defun DALOS|UR_AccountGovernor:string (account:string)
        @doc "Returns DALOS Account <governor> Account"
        (at "governor" (read DALOS|AccountTable account ["governor"]))
    )
    (defun DALOS|UR_AccountKadena:string (account:string)
        @doc "Returns DALOS Account <kadena-konto> Account"
        (at "kadena-konto" (read DALOS|AccountTable account ["kadena-konto"]))
    )
    (defun DALOS|UR_Elite (account:string)
        (UTILITY.DALOS|UV_Account account)
        (with-default-read DALOS|AccountTable account
            { "elite" : DALOS|PLEB }
            { "elite" := e}
            e
        )
    )
    (defun DALOS|UR_Elite-Class (account:string)
        (at "class" (DALOS|UR_Elite account))
    )
    (defun DALOS|UR_Elite-Name (account:string)
        (at "name" (DALOS|UR_Elite account))
    )
    (defun DALOS|UR_Elite-Tier (account:string)
        (at "tier" (DALOS|UR_Elite account))
    )
    (defun DALOS|UR_Elite-Tier-Major:integer (account:string)
        (str-to-int (take 1 (DALOS|UR_Elite-Tier account)))
    )
    (defun DALOS|UR_Elite-Tier-Minor:integer (account:string)
        (str-to-int (take -1 (DALOS|UR_Elite-Tier account)))
    )
    (defun DALOS|UR_Elite-DEB (account:string)
        (at "deb" (DALOS|UR_Elite account))
    )
    (defun DALOS|UP_AccountProperties (account:string)
        @doc "Prints DALOS Account <account> Properties"
        (DALOS|UVE_id account)
        (let* 
            (
                (p:[bool] (DALOS|UR_AccountProperties account))
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
    ;;1.2.1.2][D]           Dalos Price Info
    (defun DALOS|UR_Standard:decimal ()
        @doc "Returns the KDA price to deploy a Standard DALOS Account"
        (at "standard" (read DALOS|PricesTable DALOS|PRICES ["standard"]))
    )
    (defun DALOS|UR_Smart:decimal ()
        @doc "Returns the KDA price to deploy a Smart DALOS Account"
        (at "smart" (read DALOS|PricesTable DALOS|PRICES ["smart"]))
    )
    (defun DALOS|UR_True:decimal ()
        @doc "Returns the KDA price to issue a True Fungible Token"
        (at "dptf" (read DALOS|PricesTable DALOS|PRICES ["dptf"]))
    )
    (defun DALOS|UR_Meta:decimal ()
        @doc "Returns the KDA price to issue a Meta Fungible Token"
        (at "dpmf" (read DALOS|PricesTable DALOS|PRICES ["dpmf"]))
    )
    (defun DALOS|UR_Semi:decimal ()
        @doc "Returns the KDA price to issue a Semi Fungible Token"
        (at "dpsf" (read DALOS|PricesTable DALOS|PRICES ["dpsf"]))
    )
    (defun DALOS|UR_Non:decimal ()
        @doc "Returns the KDA price to issue a Non Fungible Token"
        (at "dpnf" (read DALOS|PricesTable DALOS|PRICES ["dpnf"]))
    )
    (defun DALOS|UR_Blue:decimal ()
        @doc "Returns the KDA price for a Blue Check"
        (at "blue" (read DALOS|PricesTable DALOS|PRICES ["blue"]))
    )
    ;;1.2.1.3][D]           Computing
    (defun DALOS|UC_Filterid:[string] (listoflists:[[string]] account:string)
        @doc "Helper Function needed for returning DALOS ids for Account <account>"
        (UTILITY.DALOS|UV_Account account)
        (UTILITY.DALOS|UC_Filterid listoflists account)
    )
    (defun DALOS|UC_MethodicTransferability:bool (sender:string receiver:string method:bool)
        @doc "Computes transferability between 2 DALOS Accounts, <sender> and <receiver> given the input <method>"
        (DALOS|UV_SenderWithReceiver sender receiver)
        (let
            (
                (s-sc:bool (DALOS|UR_AccountType sender))
                (r-sc:bool (DALOS|UR_AccountType receiver))
                (r-pasc:bool (DALOS|UR_AccountPayableAs receiver))
                (r-pbsc:bool (DALOS|UR_AccountPayableBy receiver))
                (r-mt:bool (DALOS|UR_AccountPayableByMethod receiver))
            )
            (if (= s-sc false)
                (if (= r-sc false)              ;;sender is normal
                    true                        ;;receiver is normal (Normal => Normal | Case 1)
                    (if (= method true)         ;;receiver is smart  (Normal => Smart | Case 3)
                        r-mt
                        r-pasc
                    )
                )
                (if (= r-sc false)              ;;sender is smart
                    true                        ;;receiver is normal (Smart => Normal | Case 4)
                    (if (= method true)         ;;receiver is false (Smart => Smart | Case 2)
                        r-mt
                        r-pbsc
                    )
                )
            )
        )
    )
    (defun DALOS|UC_Transferability:bool (sender:string receiver:string)
        @doc "Computes transferability between 2 DALOS Accounts, <sender> and <receiver> "
        (DALOS|UC_MethodicTransferability sender receiver false)
    )
    (defun DALOS|UC_Makeid:string (ticker:string)
        @doc "Creates a DPTF|DPMF id \ 
            \ using the first 12 Characters of the prev-block-hash of (chain-data) as randomness source"
        (UTILITY.DALOS|UV_Ticker ticker)
        (UTILITY.DALOS|UC_Makeid ticker)
    )
    ;;1.2.1.4][D]           Validations
    (defun DALOS|UVE_id (dalos-account:string)
        @doc "Validates the existance of the DALOS Account <dalos-account>"
        ;;First, the name must conform to the naming requirement
        (UTILITY.DALOS|UV_Account dalos-account)
        ;;If it passes the naming requirement, its existance is checked, by reading its DEB
        ;;If the DEB is smaller than 1, which it cant happen, then account doesnt exist
        (with-default-read DALOS|AccountTable dalos-account
            { "elite" : DALOS|VOID }
            { "elite" := e }
            (let
                (
                    (deb:decimal (at "deb" e))
                )
                (enforce 
                    (>= deb 1.0)
                    (format "The {} DALOS Account doesnt exist" [dalos-account])
                )
            )
        )
    )
    (defun DALOS|UV_SenderWithReceiver (sender:string receiver:string)
        @doc "Validates Account <sender> with Account <receiver> for Transfer"
        (DALOS|UVE_id sender)
        (DALOS|UVE_id receiver)
        (enforce (!= sender receiver) "Sender and Receiver must be different")
    )
    (defun DALOS|UV_Fee (fee:decimal)
        @doc "Validate input decimal as a fee value"
        (enforce
            (= (floor fee UTILITY.FEE_PRECISION) fee)
            (format "The fee amount of {} is not a valid fee amount decimal wise" [fee])
        )
        (enforce 
            (or 
                (or (= fee -1.0) (= fee 0.0))
                (and (>= fee 1.0) (<= fee 999.0))
            ) 
            (format "The fee amount of {} is not a valid fee amount value wise" [fee])
        )
    )
    ;;1.2.2]  [D]   DALOS Administration Functions
    (defun DALOS|A_UpdateStandard (price:decimal)
        @doc "Updates DALOS Kadena Cost for deploying a Standard DALOS Account"
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"standard" : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateSmart(price:decimal)
        @doc "Updates DALOS Kadena Cost for deploying a Smart DALOS Account"
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"smart"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateTrue(price:decimal)
        @doc "Updates DALOS Kadena Cost for issuing a DPTF Token"
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"dptf"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateMeta(price:decimal)
        @doc "Updates DALOS Kadena Cost for issuing a DPMF Token"
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"dpmf"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateSemi(price:decimal)
        @doc "Updates DALOS Kadena Cost for issuing a DPSF Token"
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"dpsf"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateNon(price:decimal)
        @doc "Updates DALOS Kadena Cost for issuing a DPNF Token"
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"dpnf"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateBlue(price:decimal)
        @doc "Updates DALOS Kadena Cost for the Blue Checker"
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"blue"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    ;;1.2.3]  [D]   DALOS Client Functions
    ;;1.2.3.1][D]           Control
    (defun DALOS|C_DeployStandardAccount (account:string guard:guard kadena:string)
        @doc "Deploys a Standard DALOS Account. \
            \ Before any DPTF|DPMF|DPFS|DPNF Token can be created and used, \
            \ a Standard or Smart DALOS Account must be deployed \
            \ Equivalent to creting a new ERD Address \
            \ \
            \ If a DALOS Account already exists, function will fail, due to usage of insert"
        (UTILITY.DALOS|UV_Account account)
        ;(UTILITY.DALOS|UV_EnforceReserved account guard)
        (insert DALOS|AccountTable account
            { "guard"                       : guard
            , "sovereign"                   : account
            , "smart-contract"              : false
            , "payable-as-smart-contract"   : false
            , "payable-by-smart-contract"   : false
            , "payable-by-method"           : false
            , "governor"                    : UTILITY.BAR
            , "nonce"                       : 0
            , "kadena-konto"                : kadena
            , "elite"                       : DALOS|PLEB
            }  
        )
        (if (not (GAS|UC_NativeSubZero))
            (with-capability (GAS|COLLECT_KDA account (DALOS|UR_Standard))
                (GAS|X_CollectDalosFuel account (DALOS|UR_Standard))
            )
            true
        )
    )
    (defun DALOS|C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string)
        @doc "Deploys a Smart DALOS Account. \
            \ Before any DPTF, DPMF, DPSF, DPNF Token can be created, \
            \ a Standard or Smart DALOS Account must be deployed \
            \ Equivalent to creating a new ERD Smart-Contract Address"
        (UTILITY.DALOS|UV_Account account)
        (UTILITY.DALOS|UV_Account sovereign)
        ;(UTILITY.DALOS|UV_EnforceReserved account guard)
        ;;Since it uses insert, the function only works if the DALOS account doesnt exist yet.
        (with-capability (DALOS|IZ_ACCOUNT_SMART sovereign false)
            (insert DALOS|AccountTable account
                { "guard"                       : guard
                , "sovereign"                   : sovereign
                , "smart-contract"              : true
                , "payable-as-smart-contract"   : false
                , "payable-by-smart-contract"   : false
                , "payable-by-method"           : true
                , "governor"                    : UTILITY.BAR
                , "nonce"                       : 0
                , "kadena-konto"                : kadena
                , "elite"                       : DALOS|PLEB
                }  
            )
        )
        (if (not (GAS|UC_NativeSubZero))
            (with-capability (GAS|COLLECT_KDA account (DALOS|UR_Smart))
                (GAS|X_CollectDalosFuel account (DALOS|UR_Smart))
            )
            true
        )
    )
    (defun DALOS|C_UpdateSmartAccountGovernor (patron:string account:string governor:string)
        @doc "Updates the Smart Account Governor, which is the Governing Module \
        \ Only works for Smart DALOS Accounts"
        (let
            (
                (ZG:bool (GAS|UC_SubZero))
            )
            (with-capability (DALOS|ROTATE_GOVERNOR patron account governor)
                (if (= ZG false)
                    (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                    true
                )
                (DALOS|X_RotateGovernor account governor)
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    (defun DALOS|C_UpdateSmartAccountSovereign (patron:string account:string new-sovereign:string)
        @doc "Updates the Smart Account Sovereign Account \
        \ Only works for Smart DALOS Accounts"
        (let
            (
                (ZG:bool (GAS|UC_SubZero))
            )
            (with-capability (DALOS|ROTATE_SOVEREIGN patron account new-sovereign)
                (if (= ZG false)
                    (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                    true
                )
                (DALOS|X_RotateSovereign account new-sovereign)
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    (defun DALOS|C_RotateGuard (patron:string account:string new-guard:guard safe:bool)
        @doc "Updates the Guard stored in the DALOS|AccountTable"
        (let
            (
                (ZG:bool (GAS|UC_SubZero))
            )
            (with-capability (DALOS|ROTATE_ACCOUNT patron account)
                (if (= ZG false)
                    (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                    true
                )
                (DALOS|X_RotateGuard account new-guard safe)
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    (defun DALOS|C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool)
        @doc "Manages Smart DALOS Account Type via boolean triggers"
        (let
            (
                (ZG:bool (GAS|UC_SubZero))
            )
            (with-capability (DALOS|CONTROL_SMART-ACCOUNT patron account payable-as-smart-contract payable-by-smart-contract)
                (if (= ZG false)
                    (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                    true
                )
                (DALOS|X_UpdateSmartAccountParameters account payable-as-smart-contract payable-by-smart-contract payable-by-method)
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    (defun DALOS|C_RotateKadena (patron:string account:string kadena:string)
        @doc "Updates the Kadena Account stored in the DALOS|AccountTable"
        (let
            (
                (ZG:bool (GAS|UC_SubZero))
            )
            (with-capability (DALOS|ROTATE_ACCOUNT patron account)
                (if (= ZG false)
                    (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                    true
                )
                (DALOS|X_RotateKadena account kadena)
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    ;;1.2.4]  [D]   DALOS Auxiliary Functions
    (defun DALOS|X_IncrementNonce (client:string)
        @doc "Increments DALOS Account nonce, which store how many txs the DALOS Account executed"
        (require-capability (DALOS|INCREASE-NONCE))
        (with-read DALOS|AccountTable client
            { "nonce"                       := n }
            (update DALOS|AccountTable client { "nonce" : (+ n 1)})
        )
    )
    (defun DALOS|X_RotateGovernor (account:string governor:string)
        @doc "Updates DALOS Account Governor"
        (require-capability (DALOS|GOVERNOR account governor))
        (update DALOS|AccountTable account
            {"governor"                        : governor}
        )
    )
    (defun DALOS|X_RotateSovereign (account:string new-sovereign:string)
        @doc "Updates DALOS Account Sovereign"
        (require-capability (DALOS|SOVEREIGN account new-sovereign))
        (update DALOS|AccountTable account
            {"sovereign"                        : new-sovereign}
        )
    )
    (defun DALOS|X_RotateGuard (account:string new-guard:guard safe:bool)
        @doc "Updates DALOS Account Parameters"
        (require-capability (DALOS|ACCOUNT_OWNER account))
        (if safe
            (enforce-guard new-guard)
            true
        )
        (update DALOS|AccountTable account
            {"guard"                        : new-guard}
        )
    )
    (defun DALOS|X_UpdateSmartAccountParameters (account:string pasc:bool pbsc:bool pbm:bool)
        @doc "Updates DALOS Account Parameters"
        (require-capability (DALOS|CONTROL_SMART-ACCOUNT_CORE account pasc pbsc pbm))
        (update DALOS|AccountTable account
            {"payable-as-smart-contract"    : pasc
            ,"payable-by-smart-contract"    : pbsc
            ,"payable-by-method"            : pbm}
        )
    )
    (defun DALOS|X_RotateKadena (account:string kadena:string)
        @doc "Updates DALOS Account Parameters"
        (require-capability (DALOS|ACCOUNT_OWNER account))
        (update DALOS|AccountTable account
            {"kadena-konto"                  : kadena}
        )
    )
    (defun DALOS|X_UpdateElite (account:string)
        @doc "Updates Elite Account Information"
        (require-capability (DALOS|UPDATE_ELITE))
        (if (= (DALOS|UR_AccountType account) false)
            (update DALOS|AccountTable account
                { "elite" : (UTILITY.ATS|UC_Elite (DALOS|UR_EliteAurynzSupply account))}
            )
            true
        )
    )
    (defun DALOS|UR_EliteAurynzSupply (account:string)
        @doc "Returns Total Elite Auryn (normal and vested) Supply of Account"
        (if (!= (DALOS|UR_EliteAurynID) UTILITY.BAR)
            (let
                (
                    (ea-supply:decimal (DPTF-DPMF|UR_AccountSupply (DALOS|UR_EliteAurynID) account true))
                    (vea:string (DPTF-DPMF|UR_Vesting (DALOS|UR_EliteAurynID) true))
                )
                (if (!= vea UTILITY.BAR)
                    (+ ea-supply (DPTF-DPMF|UR_AccountSupply vea account false))
                    ea-supply
                )
            )
            true
        )
    )
    ;;
    ;;
    ;;
    ;;True-Meta; [2] DPTF-DPMF Submodule
    ;;
    ;;
    ;;
    ;;========[TM]CAPABILITIES=================================================;;
    ;;2.1]    [TM]DPTF-DPMF Capabilities
    ;;2.1.1]  [TM]  DPTF-DPMF Basic Capabilities
    ;;2.1.1.1][TM]          DPTF-DPMF <DPTF|PropertiesTable>|<DPMF|PropertiesTable> Table Management
    (defcap DPTF-DPMF|EXIST (id:string token-type:bool)
        @doc "Enforces that a DPTF or DPMF Token exists"
        (DPTF-DPMF|UVE_id id token-type)
    )
    (defcap DPTF-DPMF|OWNER (id:string token-type:bool)
        @doc "Enforces DPTF|DPMF Token Ownership"
        (let*
            (
                (owner-konto:string (DPTF-DPMF|UR_Konto id token-type))
                (owner-dalos-guard:guard (DALOS|UR_AccountGuard owner-konto))
            )
            (enforce-guard owner-dalos-guard)
        )
    )
    (defcap DPTF-DPMF|CAN-CHANGE-OWNER_ON (id:string token-type:bool)
        @doc "Enforces DPTF Token ownership is changeble"
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanChangeOwner id token-type))
            )
            (enforce (= x true) (format "DPTF|DPMF Token {} ownership cannot be changed" [id]))
        )
    )
    (defcap DPTF-DPMF|CAN-UPGRADE_ON (id:string token-type:bool)
        @doc "Enforces DPTF|DPMF Token is upgradeable"
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanUpgrade id token-type))
            )
            (enforce (= x true) (format "DPTF|DPMF Token {} properties cannot be upgraded" [id])
            )
        )
    )
    (defcap DPTF-DPMF|CAN-ADD-SPECIAL-ROLE_ON (id:string token-type:bool)
        @doc "Enforces adding special roles for DPTF|DPMF Token is true"
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanAddSpecialRole id token-type))
            )
            (enforce (= x true) (format "For DPTF|DPMF Token {} no special roles can be added" [id])
            )
        )
    )
    (defcap DPTF-DPMF|CAN-FREEZE_ON (id:string token-type:bool)
        @doc "Enforces DPTF|DPMF Token can be frozen"
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanFreeze id token-type))
            )
            (enforce (= x true) (format "DPTF|DPMF Token {} cannot be freezed" [id])
            )
        )
    )
    (defcap DPTF-DPMF|CAN-WIPE_ON (id:string token-type:bool)
        @doc "Enforces DPTF|DPMF Token Property can be wiped"
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanWipe id token-type))
            )
            (enforce (= x true) (format "DPTF|DPMF Token {} cannot be wiped" [id])
            )
        )
    )
    (defcap DPTF-DPMF|CAN-PAUSE_ON (id:string token-type:bool)
        @doc "Enforces DPTF|DPMF Token can be paused"
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanPause id token-type))
            )
            (enforce (= x true) (format "DPTF|DPMF Token {} cannot be paused" [id])
            )
        )
    )
    (defcap DPTF-DPMF|PAUSE_STATE (id:string state:bool token-type:bool)
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
    (defcap DPTF-DPMF|UPDATE_SUPPLY () 
        @doc "Capability required to update DPTF Supply"
        true
    )
    (defcap DPTF-DPMF|UPDATE_ROLE-TRANSFER-AMOUNT ()
        @doc "Capability required to update DPTF Transfer-Role-Amount"
        true
    )
    (defcap DPTF|INCREMENT-LOCKS ()
        @doc "Capability required to increment DPTF lock amounts: <fee-unlocks>"
        true
    )
    ;;2.1.1.2][TM]          DPTF-DPMF <DPTF|BalanceTable>|<DPTF|BalanceTable> Table Management
    (defcap DPTF-DPMF|ACCOUNT_EXISTANCE (id:string account:string existance:bool token-type:bool)
        @doc"Enforces <existance> Existance for the DPTF|DPMF Token Account <id>|<account>"
        (let
            (
                (existance-check:bool (DPTF-DPMF|UR_AccountExist id account token-type))
            )
            (enforce (= existance-check existance) (format "{} Existance isnt verified for the DPTF|DPMF Token Account <{}>|<{}}>" [existance id account]))
        )
    )
    (defcap DPTF-DPMF|ACCOUNT_BURN_STATE (id:string account:string state:bool token-type:bool)
        @doc "Enforces DPTF|DPMF Account <role-burn> to <state>"
        (let
            (
                (x:bool (DPTF-DPMF|UR_AccountRoleBurn id account token-type))
            )
            (enforce (= x state) (format "Burn Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    (defcap DPTF-DPMF|ACCOUNT_TRANSFER_STATE (id:string account:string state:bool token-type:bool)
        @doc "Enforces DPTF Account <role-transfer> to <state>"
        (let
            (
                (x:bool (DPTF-DPMF|UR_AccountRoleTransfer id account token-type))
            )
            (enforce (= x state) (format "Transfer Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    (defcap DPTF-DPMF|ACCOUNT_FREEZE_STATE (id:string account:string state:bool token-type:bool)
        @doc "Enforces DPTF|DPMF Account <frozen> to <state>"
        (let
            (
                (x:bool (DPTF-DPMF|UR_AccountFrozenState id account token-type))
            )
            (enforce (= x state) (format "Frozen for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    ;;2.1.2]  [TM]  DPTF-DPMF Composed Capabilities
    ;;2.2.2.1][TM]          Control
    (defcap DPTF-DPMF|OWNERSHIP-CHANGE (patron:string id:string new-owner:string token-type:bool)
        @doc "Capability required to EXECUTE <DPTF-DPMF|C_ChangeOwnership> Function"
        (compose-capability (DPTF-DPMF|OWNERSHIP-CHANGE_CORE id new-owner token-type))
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto id token-type) UTILITY.GAS_BIGGEST))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF-DPMF|OWNERSHIP-CHANGE_CORE (id:string new-owner:string token-type:bool)
        @doc "Core Capability required for changing DPTF|DPMF Ownership"
        (DALOS|UV_SenderWithReceiver (DPTF-DPMF|UR_Konto id token-type) new-owner)
        (compose-capability (DPTF-DPMF|OWNER id token-type))
        (compose-capability (DPTF-DPMF|CAN-CHANGE-OWNER_ON id token-type))
        (compose-capability (DALOS|EXIST new-owner))
    )
    (defcap DPTF-DPMF|CONTROL (patron:string id:string token-type:bool)
        @doc "Capability required to EXECUTE <DPTF|C_Control>|<DPMF|C_Control> Function"
        (compose-capability (DPTF-DPMF|CONTROL_CORE id token-type))
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto id token-type) UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE)) 
    )
    (defcap DPTF-DPMF|CONTROL_CORE (id:string token-type:bool)
        @doc "Core Capability required for managing DPTF|DPMF Properties"
        (compose-capability (DPTF-DPMF|OWNER id token-type))
        (compose-capability (DPTF-DPMF|CAN-UPGRADE_ON id))
    )
    (defcap DPTF-DPMF|TOGGLE_PAUSE (patron:string id:string pause:bool token-type:bool)
        @doc "Capability required to EXECUTE <DPTF-DPMF|C_TogglePause> Function"
        (compose-capability (DPTF-DPMF|TOGGLE_PAUSE_CORE id pause token-type))
        (compose-capability (GAS|COLLECTION patron patron UTILITY.GAS_MEDIUM))
        (compose-capability (DALOS|INCREASE-NONCE)) 
    )
    (defcap DPTF-DPMF|TOGGLE_PAUSE_CORE (id:string pause:bool token-type:bool)
        @doc "Capability required to toggle pause for a DPTF|DPMF Token"
        (if (= pause true)
            (compose-capability (DPTF-DPMF|CAN-PAUSE_ON id token-type))
            true
        )
        (compose-capability (DPTF-DPMF|OWNER id token-type))
        (compose-capability (DPTF-DPMF|PAUSE_STATE id (not pause) token-type))
    )
    (defcap DPTF-DPMF|FROZEN-ACCOUNT (patron:string id:string account:string frozen:bool token-type:bool)
        @doc "Capability required to EXECUTE <DPTF-DPMF|C_ToggleFreezeAccount> Function"
        (compose-capability (DPTF-DPMF|FROZEN-ACCOUNT_CORE id account frozen token-type))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_BIG))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF-DPMF|FROZEN-ACCOUNT_CORE (id:string account:string frozen:bool token-type:bool)
        @doc "Core Capability required to toggle freeze for a DPTF|DPMF Account"
        (compose-capability (DPTF-DPMF|OWNER id token-type))
        (compose-capability (DPTF-DPMF|CAN-FREEZE_ON id token-type))
        (compose-capability (DPTF-DPMF|ACCOUNT_FREEZE_STATE id account (not frozen) token-type))
    )
    ;;2.1.2.2][TM]          Token Roles
    (defcap DPTF-DPMF|TOGGLE_BURN-ROLE (patron:string id:string account:string toggle:bool token-type:bool)
        @doc "Capability required to EXECUTE <DPTF-DPMF|C_ToggleBurnRole> Function"
        (compose-capability (DPTF-DPMF|TOGGLE_BURN-ROLE_CORE id account toggle token-type))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF-DPMF|TOGGLE_BURN-ROLE_CORE (id:string account:string toggle:bool token-type:bool)
        @doc "Core Capability required to toggle <role-burn> to a DPTF|DPMF Account for a DPTF|DPMF Token"
        (if (= toggle true)
            (compose-capability (DPTF-DPMF|CAN-ADD-SPECIAL-ROLE_ON id token-type))
            true
        )
        (compose-capability (DPTF-DPMF|OWNER id token-type))
        (compose-capability (DPTF-DPMF|ACCOUNT_BURN_STATE id account (not toggle) token-type))
    )
    (defcap DPTF-DPMF|TOGGLE_TRANSFER-ROLE (patron:string id:string account:string toggle:bool token-type:bool)
        @doc "Capability required to EXECUTE <DPTF-DPMF|C_ToggleTransferRole> Function"
        (compose-capability (DPTF-DPMF|TOGGLE_TRANSFER-ROLE_CORE id account toggle token-type))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DPTF-DPMF|UPDATE_ROLE-TRANSFER-AMOUNT))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF-DPMF|TOGGLE_TRANSFER-ROLE_CORE (id:string account:string toggle:bool token-type:bool)
        @doc "Core Capability required to toggle <role-transfer> to a DPTF|DPMF Account for a DPTF|DPMF Token"
        (enforce (!= account DPTF|SC_NAME) (format "{} Account is immune to transfer roles" [DPTF|SC_NAME]))
        (enforce (!= account GAS|SC_NAME) (format "{} Account is immune to transfer roles" [GAS|SC_NAME]))
        (if (= toggle true)
            (compose-capability (DPTF-DPMF|CAN-ADD-SPECIAL-ROLE_ON id token-type))
            true
        )
        (compose-capability (DPTF-DPMF|OWNER id token-type))
        (compose-capability (DPTF-DPMF|ACCOUNT_TRANSFER_STATE id account (not toggle) token-type))
    )
    (defcap DPTF-DPMF|UPDATE_VESTING (patron:string dptf:string dpmf:string)
        (compose-capability (DPTF-DPMF|UPDATE_VESTING_CORE dptf dpmf))
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto dptf true) UTILITY.GAS_BIGGEST))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF-DPMF|UPDATE_VESTING_CORE (dptf:string dpmf:string)
        (DPTF-DPMF|UVE_id dptf true)
        (DPTF-DPMF|UVE_id dpmf false)
        (compose-capability (DPTF-DPMF|OWNER dptf true))
        (compose-capability (DPTF-DPMF|OWNER dpmf false))
        (compose-capability (VST|ACTIVE dptf dpmf))
        (let
            (
                (tf-vesting-id:string (DPTF-DPMF|UR_Vesting dptf true))
                (mf-vesting-id:string (DPTF-DPMF|UR_Vesting dpmf false))
                (iz-hot-rbt:bool (ATS|UC_IzRBT-Absolute dpmf false))
            )
            (enforce 
                (and (= tf-vesting-id UTILITY.BAR) (= mf-vesting-id UTILITY.BAR) )
                "Vesting Pairs are immutable !"
            )
            (enforce (= iz-hot-rbt false) "A DPMF defined as a hot-rbt cannot be used as Vesting Token in Vesting pair")
        )
    )
    ;;2.1.2.3][TM]          Create
    (defcap DPTF-DPMF|ISSUE (patron:string client:string token-type:bool issue-size:integer)
        @doc "Capability required to EXECUTE a <DPTF-DPMF|C_Issue> Function"
        ;@managed
        (let*
            (
                (issue:decimal UTILITY.GAS_ISSUE)
                (tf:decimal (DALOS|UR_True))
                (mf:decimal (DALOS|UR_Meta))
                (t0:decimal (* (dec issue-size) issue))
                (t1:decimal (* (dec issue-size) tf))
                (t2:decimal (* (dec issue-size) mf))
            )
            (compose-capability (DALOS|INCREASE-NONCE))
            (if (!= (DALOS|UR_IgnisID) UTILITY.BAR)
                (compose-capability (GAS|COLLECTION patron client t0))
                true
            )
            (if (not (GAS|UC_NativeSubZero))
                (if token-type
                    (compose-capability (GAS|COLLECT_KDA patron t1))
                    (compose-capability (GAS|COLLECT_KDA patron t2))
                )
                true
            )
        )
    )
    ;;2.1.2.4][TM]          Destroy
    (defcap DPTF-DPMF|BURN (patron:string id:string client:string amount:decimal method:bool token-type:bool)
        @doc "Capability required to EXECUTE <DPTF-DPMF|CX_Burn> Function"
        (compose-capability (DALOS|METHODIC client method))
        (compose-capability (GAS|MATRON_SOFT patron id client UTILITY.GAS_SMALL))
        (compose-capability (DPTF-DPMF|BURN_CORE id client amount token-type))
        (compose-capability (DALOS|INCREASE-NONCE))
        (compose-capability (DALOS|EXECUTOR))
    )
    (defcap DPTF-DPMF|BURN_CORE (id:string client:string amount:decimal token-type:bool)
        @doc "Core Capability required to burn a DPTF|DPMF Token"
        (DPTF-DPMF|UV_Amount id amount token-type)
        (compose-capability (DPTF-DPMF|ACCOUNT_BURN_STATE id client true token-type))
        (compose-capability (DPTF-DPMF|DEBIT id client token-type))
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
    )
    (defcap DPTF-DPMF|WIPE (patron:string id:string account-to-be-wiped:string token-type:bool)
        @doc "Capability required to EXECUTE <DPTF-DPMF|C_Wipe> Function"
        (compose-capability (GAS|MATRON_SOFT patron id account-to-be-wiped UTILITY.GAS_BIGGEST))
        (compose-capability (DPTF-DPMF|WIPE_CORE id account-to-be-wiped token-type))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF-DPMF|WIPE_CORE (id:string account-to-be-wiped:string token-type:bool)
        @doc "Core Capability required to Wipe a DPTF|DPMF Token Balance from a DPTF|DPMF Account"
        (compose-capability (DPTF-DPMF|OWNER id token-type))
        (compose-capability (DPTF-DPMF|CAN-WIPE_ON id token-type))
        (compose-capability (DPTF-DPMF|ACCOUNT_FREEZE_STATE id account-to-be-wiped true token-type))
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
    )
    ;;2.1.2.4][TM]          Transfer
    (defcap DPTF-DPMF|TRANSFER (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool token-type:bool)
        @doc "Main DPTF-DPMF Transfer Capability \
            \ False <method> enforces <sender> ownership \
            \ True <method> enforcer (or <sender> <receiver>) is Smart DALOS Account"
        (compose-capability (DALOS|EXECUTOR))
        (if (= method false)
            (compose-capability (DALOS|ACCOUNT_OWNER sender))
            (enforce-one
                (format "No permission available to transfer from Account {}" [sender])
                [
                    (compose-capability (DALOS|METHODIC sender method))
                    (compose-capability (DALOS|METHODIC receiver method))
                ]
            )
        )
        (if (= token-type true)
            (if (not (DPTF|UC_TransferFeeAndMinException id sender receiver))
                (compose-capability (DPTF|TRANSFER_MIN id transfer-amount))
                true
            )
            true
        )
        (compose-capability (GAS|MATRON_STRONG patron id sender receiver UTILITY.GAS_SMALLEST))
        (compose-capability (DPTF-DPMF|TRANSFER_CORE id sender receiver transfer-amount token-type))
        (compose-capability (DALOS|METHODIC_TRANSFERABILITY sender receiver method))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF-DPMF|TRANSFER_CORE (id:string sender:string receiver:string transfer-amount:decimal token-type:bool)
        @doc "Core DPTF-DPMF Transfer Capability"
        (DPTF-DPMF|UV_Amount id transfer-amount token-type)
        (DALOS|UV_SenderWithReceiver sender receiver)
        (compose-capability (DPTF-DPMF|PAUSE_STATE id false token-type))
        (compose-capability (DPTF-DPMF|ACCOUNT_FREEZE_STATE id sender false token-type))
        (compose-capability (DPTF-DPMF|ACCOUNT_FREEZE_STATE id receiver false token-type))
        (if (and (> (DPTF-DPMF|UR_TransferRoleAmount id token-type) 0) (not (or (= sender DPTF|SC_NAME)(= sender GAS|SC_NAME))))
            (enforce-one
                (format "Neither the sender {} nor the receiver {} have an active transfer role" [sender receiver])
                [
                    (compose-capability (DPTF-DPMF|ACCOUNT_TRANSFER_STATE id sender true token-type))
                    (compose-capability (DPTF-DPMF|ACCOUNT_TRANSFER_STATE id receiver true token-type))
                ]
            )
            (format "No transfer restrictions exist when transfering {} from {} to {}" [id sender receiver])
        )
        (compose-capability (DPTF-DPMF|DEBIT id sender token-type))
        (compose-capability (DPTF-DPMF|CREDIT id receiver token-type))
        (compose-capability (DALOS|UPDATE_ELITE))
        (if token-type
            (compose-capability (DPTF|TRANSFER_CORE-TF id))
            true
        )
    )
    (defcap DPTF|TRANSFER_CORE-TF (id:string)
        @doc "Transfer Capabilities needed when id is true-fungible"
        (compose-capability (DPTF-DPMF|CREDIT id GAS|SC_NAME true))
        (compose-capability (DPTF|UPDATE_FEES))
        (compose-capability (DPTF|CREDIT_PRIMARY-FEE))
        (compose-capability (DPTF|TRANSMUTE_CORE id))
    )
    (defcap DPTF|TRANSMUTE_CORE (id:string)
        @doc "Core Capabity needed for transmuting a DPTF Token"
        (compose-capability (DPTF-DPMF|CREDIT id (DPTF|UR_FeeTarget id) true))
        (if (or
                (ATS|UC_IzRBT-Absolute id true)
                (ATS|UC_IzRT-Absolute id)
            )
            (compose-capability (DPTF-DPMF|CREDIT id ATS|SC_NAME true))
            true
        )
    )
    (defcap DPTF-DPMF|CREDIT (id:string account:string token-type:bool)
        @doc "Capability to perform crediting operations with DPTF|DPMF Tokens"
        (compose-capability (DPTF-DPMF|CREDIT-DEBIT id account token-type))
    )
    (defcap DPTF-DPMF|DEBIT (id:string account:string token-type:bool)
        @doc "Capability to perform debiting operations on a Normal DALOS Account type for a DPTF|DPMF Token"
        (compose-capability (DPTF-DPMF|CREDIT-DEBIT id account token-type))
    )
    (defcap DPTF-DPMF|CREDIT-DEBIT (id:string account:string token-type:bool)
        @doc "Credit|Debit Core Capability"
        (compose-capability (DPTF-DPMF|EXIST id token-type))
        (compose-capability (DALOS|EXIST account))
    )
    (defcap DPTF|TRANSMUTE (patron:string id:string transmuter:string)
        @doc "Capability required to transmute a DPTF Token"
        (compose-capability (GAS|COLLECTION patron transmuter UTILITY.GAS_SMALLEST))
        (compose-capability (DALOS|INCREASE-NONCE))
        (compose-capability (DALOS|EXECUTOR))
        (compose-capability (DPTF|TRANSMUTE_MANTLE id transmuter))
    )
    (defcap DPTF|TRANSMUTE_MANTLE (id:string transmuter:string)
        (compose-capability (DPTF-DPMF|DEBIT id transmuter true))
        (compose-capability (DPTF|TRANSMUTE_CORE id))
        (compose-capability (DPTF|CREDIT_PRIMARY-FEE))
    )
    (defcap DPTF|CREDIT_PRIMARY-FEE ()
        @doc "Capability needed to Credit Primary Fees"
        (compose-capability (DPTF|CPF_CREDIT-FEE))
        (compose-capability (DPTF|CPF_STILL-FEE))
        (compose-capability (DPTF|CPF_BURN-FEE))
        (compose-capability (ATS|UPDATE_ROU))
    )
    (defcap DPTF|CPF_CREDIT-FEE ()
        @doc "Cap req to Credit Fee within CPF"
        true
    )
    (defcap DPTF|CPF_STILL-FEE ()
        @doc "Cap req to Still Fee within CPF"
        true
    )
    (defcap DPTF|CPF_BURN-FEE ()
        @doc "Cap req to Burn Fee within CPF"
        true
    )
    ;;========[TM]FUNCTIONS====================================================;;
    ;;2.2]    [TM]DPTF-DPMF Functions
    ;;2.2.1]  [TM]  DPTF-DPMF Utility Functions
    ;;2.2.1.1][TM]          Account Info          Account Info
    (defun DPTF-DPMF|UR_AccountExist:bool (id:string account:string token-type:bool)
        @doc "Checks if DPTF|DPMF Account <account> exists for DPTF|DPMF Token id <id>"
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id token-type)
        (if (= token-type true)
            (with-default-read DPTF|BalanceTable (concat [id UTILITY.BAR account])
                { "balance" : -1.0 }
                { "balance" := b}
                (if (= b -1.0)
                    false
                    true
                )
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILITY.BAR account])
                { "unit" : [DPMF|NEGATIVE] }
                { "unit" := u}
                (if (= u [DPMF|NEGATIVE])
                    false
                    true
                )
            )
        )
    )
    (defun DPTF-DPMF|UR_AccountSupply:decimal (id:string account:string token-type:bool)
        @doc "Returns Account <account> True or Meta Fungible <id> Supply \
            \ If DPTF|DPMF Account doesnt exist, 0.0 balance is returned"
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id token-type)
        (if (= token-type true)
            (with-default-read DPTF|BalanceTable (concat [id UTILITY.BAR account])
                { "balance" : 0.0 }
                { "balance" := b}
                b
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILITY.BAR  account])
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
    (defun DPTF-DPMF|UR_AccountRoleBurn:bool (id:string account:string token-type:bool)
        @doc "Returns Account <account> True or Meta Fungible <id> Burn Role \
            \ Assumed as false if DPTF|DPMF Account doesnt exit"
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id token-type)
        (if (= token-type true)
            (with-default-read DPTF|BalanceTable (concat [id UTILITY.BAR account])
                { "role-burn" : false}
                { "role-burn" := rb }
                rb
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILITY.BAR account])
                { "role-nft-burn" : false}
                { "role-nft-burn" := rb }
                rb
            )
        )
    )
    (defun DPTF-DPMF|UR_AccountRoleTransfer:bool (id:string account:string token-type:bool)
        @doc "Returns Account <account> True or Meta Fungible <id> Transfer Role \
            \ Assumed as false if DPTF|DPMF Account doesnt exit"
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id token-type)
        (if (= token-type true)
            (with-default-read DPTF|BalanceTable (concat [id UTILITY.BAR account])
                { "role-transfer" : false}
                { "role-transfer" := rt }
                rt
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILITY.BAR account])
                { "role-transfer" : false }
                { "role-transfer" := rt }
                rt
            )
        )DPTF|UR_AccountRoleMint
    )
    ;;2.2.1.2][TM]          True|Meta-Fungible Info
    (defun DPTF-DPMF|UR_Konto:string (id:string token-type:bool)
        @doc "Returns <owner-konto> for the DPTF|DPMF <id>"
        (if (= token-type true)
            (at "owner-konto" (read DPTF|PropertiesTable id ["owner-konto"]))
            (at "owner-konto" (read DPMF|PropertiesTable id ["owner-konto"]))
        )
    )
    (defun DPTF-DPMF|UR_Name:string (id:string token-type:bool)
        @doc "Returns <name> for the DPTF|DPMF <id>"
        (if (= token-type true)
            (at "name" (read DPTF|PropertiesTable id ["name"]))
            (at "name" (read DPMF|PropertiesTable id ["name"]))
        )
    )
    (defun DPTF-DPMF|UR_Ticker:string (id:string token-type:bool)
        @doc "Returns <ticker> for the DPTF|DPMF <id>"
        (if (= token-type true)
            (at "ticker" (read DPTF|PropertiesTable id ["ticker"]))
            (at "ticker" (read DPMF|PropertiesTable id ["ticker"]))   
        )
    )
    (defun DPTF-DPMF|UR_Decimals:integer (id:string token-type:bool)
        @doc "Returns <decimals> for the DPTF|DPMF <id>"
        (if (= token-type true)
            (at "decimals" (read DPTF|PropertiesTable id ["decimals"]))
            (at "decimals" (read DPMF|PropertiesTable id ["decimals"]))
        )
    )
    (defun DPTF-DPMF|UR_CanChangeOwner:bool (id:string token-type:bool)
        @doc "Returns <can-change-owner> for the DPTF|DPMF <id>"
        (if (= token-type true)
            (at "can-change-owner" (read DPTF|PropertiesTable id ["can-change-owner"]))
            (at "can-change-owner" (read DPMF|PropertiesTable id ["can-change-owner"]))
        )
    )
    (defun DPTF-DPMF|UR_CanUpgrade:bool (id:string token-type:bool)
        @doc "Returns <can-upgrade> for the DPTF|DPMF <id>"
        (if (= token-type true)
            (at "can-upgrade" (read DPTF|PropertiesTable id ["can-upgrade"]))
            (at "can-upgrade" (read DPMF|PropertiesTable id ["can-upgrade"]))
        )   
    )
    (defun DPTF-DPMF|UR_CanAddSpecialRole:bool (id:string token-type:bool)
        @doc "Returns <can-add-special-role> for the DPTF|DPMF <id>"
        (if (= token-type true)
            (at "can-add-special-role" (read DPTF|PropertiesTable id ["can-add-special-role"]))
            (at "can-add-special-role" (read DPMF|PropertiesTable id ["can-add-special-role"]))
        )
    )
    (defun DPTF-DPMF|UR_CanFreeze:bool (id:string token-type:bool)
        @doc "Returns <can-freeze> for the DPTF|DPMF <id>"
        (if (= token-type true)
            (at "can-freeze" (read DPTF|PropertiesTable id ["can-freeze"]))
            (at "can-freeze" (read DPMF|PropertiesTable id ["can-freeze"]))
        )
    )
    (defun DPTF-DPMF|UR_CanWipe:bool (id:string token-type:bool)
        @doc "Returns <can-wipe> for the DPTF|DPMF <id>"
        (if (= token-type true)
            (at "can-wipe" (read DPTF|PropertiesTable id ["can-wipe"]))
            (at "can-wipe" (read DPMF|PropertiesTable id ["can-wipe"]))
        )
    )
    (defun DPTF-DPMF|UR_CanPause:bool (id:string token-type:bool)
        @doc "Returns <can-pause> for the DPTF|DPMF <id>"
        (if (= token-type true)
            (at "can-pause" (read DPTF|PropertiesTable id ["can-pause"]))
            (at "can-pause" (read DPMF|PropertiesTable id ["can-pause"]))
        )
    )
    (defun DPTF-DPMF|UR_Paused:bool (id:string token-type:bool)
        @doc "Returns <is-paused> for the DPTF|DPMF <id>"
        (if (= token-type true)
            (at "is-paused" (read DPTF|PropertiesTable id ["is-paused"]))
            (at "is-paused" (read DPMF|PropertiesTable id ["is-paused"]))
        )
    )
    (defun DPTF-DPMF|UR_Supply:decimal (id:string token-type:bool)
        @doc "Returns <supply> for the DPTF|DPMF <id>"
        (if (= token-type true)
            (at "supply" (read DPTF|PropertiesTable id ["supply"]))
            (at "supply" (read DPMF|PropertiesTable id ["supply"]))
        )
    )
    (defun DPTF-DPMF|UR_TransferRoleAmount:integer (id:string token-type:bool)
        @doc "Returns <role-transfer-amount> for the DPTF|DPMF <id>"
        (if (= token-type true)
            (at "role-transfer-amount" (read DPTF|PropertiesTable id ["role-transfer-amount"]))
            (at "role-transfer-amount" (read DPMF|PropertiesTable id ["role-transfer-amount"]))
        )
    )
    (defun DPTF-DPMF|UR_Vesting:string (id:string token-type:bool)
        @doc "Returns <vesting> for the DPTF|DPMF <id>"
        (if (= token-type true)
            (at "vesting" (read DPTF|PropertiesTable id ["vesting"]))
            (at "vesting" (read DPMF|PropertiesTable id ["vesting"]))
        )
    )
    ;;2.2.1.3][TM]          Validations
    (defun DPTF-DPMF|UV_Amount (id:string amount:decimal token-type:bool)
        @doc "Enforce the minimum denomination for a specific DPTF|DPMF id \
        \ and ensure the amount is greater than zero"
        (DPTF-DPMF|UVE_id id token-type)
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
    (defun DPTF-DPMF|UVE_id (id:string token-type:bool)
        @doc "Enforces the True or MetaFungible <id> exists"
        (if (= token-type true)
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
    ;;2.2.2]  [TM]  DPTF-DPMF Client Functions
    ;;2.2.2.1][TM]          Control
    (defun DPTF-DPMF|C_ChangeOwnership (patron:string id:string new-owner:string token-type:bool)
        @doc "Moves DPTF|DPMF <id> Token Ownership to <new-owner> DPTF|DPMF Account"
        (with-capability (DPTF-DPMF|OWNERSHIP-CHANGE patron id new-owner token-type)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (DPTF-DPMF|UR_Konto id token-type) UTILITY.GAS_BIGGEST)
                true
            )
            (DPTF-DPMF|X_ChangeOwnership id new-owner token-type)
            (DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF-DPMF|C_TogglePause (patron:string id:string toggle:bool token-type:bool)
        @doc "Pause/Unpause True|Meta-Fungible <id> via the boolean <toggle>"
        (with-capability (DPTF-DPMF|TOGGLE_PAUSE patron id toggle token-type)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron patron UTILITY.GAS_MEDIUM)
                true
            )
            (DPTF-DPMF|X_TogglePause id toggle token-type)
            (DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF-DPMF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool token-type:bool)
        @doc "Freeze/Unfreeze via boolean <toggle> True|Meta-Fungile <id> on DPTF Account <account>"
        (with-capability (DPTF-DPMF|FROZEN-ACCOUNT patron id account toggle token-type)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron account UTILITY.GAS_BIG)
                true
            )
            (DPTF-DPMF|X_ToggleFreezeAccount id account toggle token-type)
            (DALOS|X_IncrementNonce patron)
        )
    )
    ;;2.2.2.2][TM]          Token Roles
    (defun DPTF-DPMF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool token-type:bool)
        @doc "Sets |role-burn| to <toggle> for True|Meta-Fungible <id> and DPTF|DPMF Account <account>. \
            \ This determines if Account <account> can burn existing True|Meta-Fungibles."
        (with-capability (DPTF-DPMF|TOGGLE_BURN-ROLE patron id account toggle token-type)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                true
            )
            (DPTF-DPMF|X_ToggleBurnRole id account toggle token-type)
            (DALOS|X_IncrementNonce patron)
            (if (and (= account ATS|SC_NAME) (= toggle false))
                (ATS|C_RevokeBurn patron id token-type)
                true
            )
        )
    )
    (defun DPTF-DPMF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool token-type:bool)
        @doc "Sets |role-transfer| to <toggle> for True|Meta-Fungible <id> and DPTF|DPMF Account <account>. \
            \ If any DPTF|DPMF Account has |role-transfer| true, normal transfers are restricted. \
            \ Transfers will only be allowed to DPTF|DPMF Accounts with |role-transfer| true, \
            \ while these Accounts can transfer the True|Meta-Fungible freely to others."
        (with-capability (DPTF-DPMF|TOGGLE_TRANSFER-ROLE patron id account toggle token-type)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                true
            )
            (DPTF-DPMF|X_ToggleTransferRole id account toggle token-type)
            (DPTF-DPMF|X_UpdateRoleTransferAmount id toggle token-type)
            (DALOS|X_IncrementNonce patron)
        )
    )
    ;;2.2.2.3][TM]          Create
    (defun DPTF-DPMF|C_DeployAccount (id:string account:string token-type:bool)
        @doc "Creates a new DPTF|DPMF Account for True|Meta-Fungible <id> and Account <account> \
            \ If a DPTF|DPMF Account already exists for <id> and <account>, it remains as is \
            \ \
            \ A DPTF Account can only be created if a coresponding DALOS Account exists, and its guard is presented."
        (DPTF-DPMF|UVE_id id token-type)
        (with-capability (DALOS|EXIST account)
            (if (= token-type true)
                (with-default-read DPTF|BalanceTable (concat [id UTILITY.BAR account])
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
                    (write DPTF|BalanceTable (concat [id UTILITY.BAR account])
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
                    (with-default-read DPMF|BalanceTable (concat [id UTILITY.BAR account])
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
                        (write DPMF|BalanceTable (concat [id UTILITY.BAR account])
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
    )
    ;;2.2.2.4][TM]          Destroy
    (defun DPTF-DPMF|C_Wipe (patron:string id:string atbw:string token-type:bool)
        @doc "Wipes the whole supply of <id> True|Meta-Fungible of a frozen DPTF|DPMF Account <account>"
        (with-capability (DPTF-DPMF|WIPE patron id atbw token-type)
            (if (not (GAS|UC_ZeroGAS id atbw))
                (GAS|X_Collect patron atbw UTILITY.GAS_BIGGEST)
                true
            )
            (DPTF-DPMF|X_Wipe id atbw token-type)
            (DALOS|X_IncrementNonce patron)
        )
    )
    ;;2.2.3]  [TM]  DPTF Auxiliary Functions
    ;;2.2.3.1][TM]          Update
    (defun DPTF-DPMF|X_UpdateSupply (id:string amount:decimal direction:bool token-type:bool)
        @doc "Updates <id> True|Meta-Fungible supply. Boolean <direction> used for increase|decrease"
        (DPTF-DPMF|UV_Amount id amount token-type)
        (require-capability (DPTF-DPMF|UPDATE_SUPPLY))
        (if (= token-type true)
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
    (defun DPTF-DPMF|X_UpdateRoleTransferAmount (id:string direction:bool token-type:bool)
        @doc "Updates <role-transfer-amount> for Token <id>"
        (require-capability (DPTF-DPMF|UPDATE_ROLE-TRANSFER-AMOUNT))
        (if (= token-type true)
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
    (defun DPTF-DPMF|X_UpdateRewardBearingToken (id:string atspair:string token-type:bool)
        @doc "Updates Reward-Bearing-Token Data (atspair name) for DPTF|DPMF Token <id>"
        (require-capability (ATS|UPDATE_RBT id token-type))
        (if (= token-type true)
            (with-read DPTF|PropertiesTable id
                {"reward-bearing-token" := rbt}
                (if (= (at 0 rbt) UTILITY.BAR)
                    (update DPTF|PropertiesTable id
                        {"reward-bearing-token" : [atspair]}
                    )
                    (update DPTF|PropertiesTable id
                        {"reward-bearing-token" : (UTILITY.UC_AppendLast rbt atspair)}
                    )
                )
            )
            (update DPMF|PropertiesTable id
                {"reward-bearing-token" : atspair}
            )
        )
    )
    (defun DPTF-DPMF|X_UpdateVesting (dptf:string dpmf:string)
        (require-capability (DPTF-DPMF|UPDATE_VESTING_CORE dptf dpmf))
        (update DPTF|PropertiesTable dptf
            {"vesting" : dpmf}
        )
        (update DPMF|PropertiesTable dpmf
            {"vesting" : dptf}
        )
    )
    (defun DPTF-DPMF|X_UpdateElite (id:string sender:string receiver:string)
        @doc "Updates Elite Account in a transfer context"
        (let
            (
                (ea-id:string (DALOS|UR_EliteAurynID))
            )
            (if (!= ea-id UTILITY.BAR)
                (if (= id ea-id)
                    (with-capability (COMPOSE)
                        (DALOS|X_UpdateElite sender)
                        (DALOS|X_UpdateElite receiver)
                    )
                    (let
                        (
                            (v-ea-id:string (DPTF-DPMF|UR_Vesting ea-id true))
                        )
                        (if (and (!= v-ea-id UTILITY.BAR)(= id v-ea-id))
                            (with-capability (COMPOSE)
                                (DALOS|X_UpdateElite sender)
                                (DALOS|X_UpdateElite receiver)
                            )
                            true
                        )
                    )
                )
                true
            )
        )
    )
    ;;2.2.3.2][TM]          Remainder-Aux
    (defun DPTF-DPMF|X_ChangeOwnership (id:string new-owner:string token-type:bool)
        (require-capability (DPTF-DPMF|OWNERSHIP-CHANGE_CORE id new-owner token-type))
        (if (= token-type true)
            (update DPTF|PropertiesTable id
                {"owner-konto"                      : new-owner}
            )
            (update DPMF|PropertiesTable id
                {"owner-konto"                      : new-owner}
            )
        )
    )
    (defun DPTF-DPMF|X_TogglePause (id:string toggle:bool token-type:bool)
        (require-capability (DPTF-DPMF|TOGGLE_PAUSE_CORE id toggle token-type))
        (if (= token-type true)
            (update DPTF|PropertiesTable id
                { "is-paused" : toggle}
            )
            (update DPMF|PropertiesTable id
                { "is-paused" : toggle}
            )
        )
    )
    (defun DPTF-DPMF|X_ToggleFreezeAccount (id:string account:string toggle:bool token-type:bool)
        (require-capability (DPTF-DPMF|FROZEN-ACCOUNT_CORE id account toggle token-type))
        (if (= token-type true)
            (update DPTF|BalanceTable (concat [id UTILITY.BAR account])
                { "frozen" : toggle}
            )
            (update DPMF|BalanceTable (concat [id UTILITY.BAR account])
                { "frozen" : toggle}
            )
        )
    )
    (defun DPTF-DPMF|X_ToggleBurnRole (id:string account:string toggle:bool token-type:bool)
        (require-capability (DPTF-DPMF|TOGGLE_BURN-ROLE_CORE id account toggle token-type))
        (if (= token-type true)
            (update DPTF|BalanceTable (concat [id UTILITY.BAR account])
                {"role-burn" : toggle}
            )
            (update DPMF|BalanceTable (concat [id UTILITY.BAR account])
                {"role-nft-burn" : toggle}
            )
        )
    )
    (defun DPTF-DPMF|X_ToggleTransferRole (id:string account:string toggle:bool token-type:bool)
        (require-capability (DPTF-DPMF|TOGGLE_TRANSFER-ROLE_CORE id account toggle token-type))
        (if (= token-type true)
            (update DPTF|BalanceTable (concat [id UTILITY.BAR account])
                {"role-transfer" : toggle}
            )
            (update DPMF|BalanceTable (concat [id UTILITY.BAR account])
                {"role-transfer" : toggle}
            )
        )
    )
    (defun DPTF-DPMF|X_Wipe (id:string account-to-be-wiped:string token-type:bool)
        (require-capability (DPTF-DPMF|WIPE_CORE id account-to-be-wiped token-type))
        (if (= token-type true)
            (let
                (
                    (amount-to-be-wiped:decimal (DPTF-DPMF|UR_AccountSupply id account-to-be-wiped token-type))
                )
                (DPTF|X_Debit id account-to-be-wiped amount-to-be-wiped true)
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
    ;;
    ;;
    ;;
    ;;Demiourgos-Pact-True-Fungible; [3] DPTF Submodule
    ;;
    ;;
    ;;
    ;;========[T] CAPABILITIES=================================================;;
    ;;3.1]    [T] DPTF Capabilities
    ;;3.1.1]  [T]   DPTF Basic Capabilities
    ;;3.1.1.1][T]           DPTF <DPTF|PropertiesTable> Table Management
    (defcap DPTF|VIRGIN (id:string)
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
    (defcap DPTF|FEE-LOCK_STATE (id:string state:bool)
        @doc "Enforces DPTF Token <fee-lock> to <state>"
        (let
            (
                (x:bool (DPTF|UR_FeeLock id))
            )
            (enforce (= x state) (format "Fee-lock for {} must be set to {} for this operation" [id state]))
        )
    )
    (defcap DPTF|FEE-TOGGLE_STATE (id:string state:bool)
        @doc "Enforces DPTF Token <fee-toggle> to <state>"
        (let
            (
                (x:bool (DPTF|UR_FeeToggle id))
            )
            (enforce (= x state) (format "Fee-Toggle for {} must be set to {} for this operation" [id state]))
        )
    )
    (defcap DPTF|UPDATE_FEES ()
        @doc "Capability required to update Fee Volumes in the DPTF Properties Schema"
        true
    )
    ;;3.1.1.2][T]           DPTF <DPTF|BalanceTable> Table Management
    (defcap DPTF|ACCOUNT_MINT_STATE (id:string account:string state:bool)
        @doc "Enforces DPTF Account <role-mint> to <state>"
        (let
            (
                (x:bool (DPTF|UR_AccountRoleMint id account))
            )
            (enforce (= x state) (format "Mint Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    (defcap DPTF|ACCOUNT_FEE-EXEMPTION_STATE (id:string account:string state:bool)
        @doc "Enforces DPTF Account <role-fee-exemption> to <state>"
        (let
            (
                (x:bool (DPTF|UR_AccountRoleFeeExemption id account))
            )
            (enforce (= x state) (format "Fee-Exemption Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    ;;3.1.2]  [T]   DPTF Composed Capabilities
    ;;3.1.2.1][T]           Control
    (defcap DPTF|TOGGLE_FEE (patron:string id:string toggle:bool)
        @doc "Capability required to EXECUTE <DPTF|C_ToggleFee> Function"
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL))
        (compose-capability (DPTF|TOGGLE_FEE_CORE id toggle))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|TOGGLE_FEE_CORE (id:string toggle:bool)
        @doc "Core Capability required to set to <toggle> the <fee-toggle> for a DPTF Token"
        (let
            (
                (fee-promile:decimal (DPTF|UR_FeePromile id))
            )
            (enforce (or (= fee-promile -1.0) (and (>= fee-promile 0.0) (<= fee-promile 1000.0))) "Please Set up Fee Promile before Turning Fee Collection on !")
            (UTILITY.DALOS|UV_Account (DPTF|UR_FeeTarget id))
            (compose-capability (DPTF-DPMF|OWNER id true))
            (compose-capability (DALOS|EXIST (DPTF|UR_FeeTarget id)))
            (compose-capability (DPTF|FEE-LOCK_STATE id false))
            (compose-capability (DPTF|FEE-TOGGLE_STATE id (not toggle)))
        )
    )
    (defcap DPTF|SET_MIN-MOVE (patron:string id:string min-move-value:decimal)
        @doc "Capability required to EXECUTE <DPTF|C_SetMinMove> Function"
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL))
        (compose-capability (DPTF|SET_MIN-MOVE_CORE id min-move-value))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|SET_MIN-MOVE_CORE (id:string min-move-value:decimal)
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
            (compose-capability (DPTF-DPMF|OWNER id true))
            (compose-capability (DPTF|FEE-LOCK_STATE id false))  
        )
    )
    (defcap DPTF|SET_FEE (patron:string id:string fee:decimal)
        @doc "Capability required to EXECUTE <DPTF|C_SetFee> Function"
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL))
        (compose-capability (DPTF|SET_FEE_CORE id fee))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|SET_FEE_CORE (id:string fee:decimal)
        @doc "Core Capability required to set the <fee-promile> for a DPTF Token"
        (DALOS|UV_Fee fee)
        (compose-capability (DPTF-DPMF|OWNER id true))
        (compose-capability (DPTF|FEE-LOCK_STATE id false))
    )
    (defcap DPTF|SET_FEE-TARGET (patron:string id:string target:string)
        @doc "Capability required to EXECUTE <DPTF|C_SetFeeTarget> Function"
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL))
        (compose-capability (DPTF|SET_FEE-TARGET_CORE id target))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|SET_FEE-TARGET_CORE (id:string target:string)
        @doc "Core Capability required to set <fee-target> for a DPTF Token"
        (UTILITY.DALOS|UV_Account target)
        (compose-capability (DALOS|EXIST target))
        (compose-capability (DPTF-DPMF|OWNER id true))
        (compose-capability (DPTF|FEE-LOCK_STATE id false))    
    )
    (defcap DPTF|TOGGLE_FEE-LOCK (patron:string id:string toggle:bool)
        @doc "Capability required to EXECUTE <DPTF|C_ToggleFeeLock> Function"
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL))
        (compose-capability (DPTF|TOGGLE_FEE-LOCK_CORE id toggle))
        (compose-capability (DALOS|INCREASE-NONCE))
        (if (not toggle)
            (let*
                (
                    (token-owner:string (DPTF-DPMF|UR_Konto id true))
                    (toggle-costs:[decimal] (UTILITY.DPTF|UC_UnlockPrice (DPTF|UR_FeeUnlocks id)))
                    (gas-costs:decimal (at 0 toggle-costs))
                    (kda-costs:decimal (at 1 toggle-costs))
                )
                (compose-capability (GAS|DUAL-COLLECTER patron token-owner gas-costs kda-costs))
            )
            true
        )
    )
    (defcap GAS|DUAL-COLLECTER (patron:string client:string gas-costs:decimal kda-costs:decimal)
        (compose-capability (GAS|COLLECTION patron client gas-costs))
        (compose-capability (GAS|COLLECT_KDA patron kda-costs))
        (compose-capability (DPTF|INCREMENT-LOCKS))
    )
    (defcap DPTF|TOGGLE_FEE-LOCK_CORE (id:string toggle:bool)
        @doc "Core Capability required to set to <toggle> the <fee-lock> for a DPTF Token"
        (compose-capability (DPTF-DPMF|OWNER id true))
        (compose-capability (DPTF|FEE-LOCK_STATE id (not toggle)))
    )
    (defcap DPTF|WITHDRAW-FEES (patron:string id:string output-target-account:string)
        @doc "Capability required to EXECUTE <DPTF|C_WithdrawFees> Function"
        (UTILITY.DALOS|UV_Account output-target-account)
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL))
        (compose-capability (DPTF|WITHDRAW-FEES_CORE id output-target-account))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|WITHDRAW-FEES_CORE (id:string output-target-account:string)
        @doc "Core Capability required to withdraw cumulated DPTF Fees from their Standard cumulation Location \
            \ Their Standard Cumulation Location is the Ouroboros Smart DALOS Account"
        (compose-capability (DPTF-DPMF|OWNER id true))
        (compose-capability (DALOS|IZ_ACCOUNT_SMART output-target-account false))
        (let
            (
                (withdraw-amount:decimal (DPTF-DPMF|UR_AccountSupply id DPTF|SC_NAME true))
            )
            (enforce (> withdraw-amount 0.0) (format "There are no {} fees to be withdrawed from {}" [id DPTF|SC_NAME]))
            (compose-capability (DPTF-DPMF|TRANSFER_CORE id DPTF|SC_NAME output-target-account withdraw-amount true))
        )
    )
    ;;3.1.2.2][T]           Token Roles
    (defcap DPTF|TOGGLE_MINT-ROLE (patron:string id:string account:string toggle:bool)
        @doc "Capability required to EXECUTE <DPTF|C_ToggleMintRole> Function"
        (compose-capability (DPTF|TOGGLE_MINT-ROLE_CORE id account toggle))    
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|TOGGLE_MINT-ROLE_CORE (id:string account:string toggle:bool)
        @doc "Core Capability required to toggle <role-mint> to a DPTF Account for a DPTF Token"
        (compose-capability (DPTF-DPMF|OWNER id true))
        (if (= toggle true)
            (compose-capability (DPTF-DPMF|CAN-ADD-SPECIAL-ROLE_ON id true))
            true
        )
        (compose-capability (DPTF|ACCOUNT_MINT_STATE id account (not toggle)))
    )
    (defcap DPTF|TOGGLE_FEE-EXEMPTION-ROLE (patron:string id:string account:string toggle:bool)
        @doc "Capability required to toggle the <role-fee-exemption> Role"
        (compose-capability (DPTF|TOGGLE_FEE-EXEMPTION-ROLE_CORE id account toggle))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|TOGGLE_FEE-EXEMPTION-ROLE_CORE (id:string account:string toggle:bool)
        @doc "Core Capability required to toggle the <role-fee-exemption> Role"
        (compose-capability (DPTF-DPMF|OWNER id true))
        (compose-capability (DALOS|IZ_ACCOUNT_SMART account true))
        (if (= toggle true)
            (compose-capability (DPTF-DPMF|CAN-ADD-SPECIAL-ROLE_ON id true))
            true
        )
        (compose-capability (DPTF|ACCOUNT_FEE-EXEMPTION_STATE id account (not toggle)))
    )
    ;;3.1.2.3][T]           Create
    (defcap DPTF|MINT (patron:string id:string client:string amount:decimal origin:bool method:bool)
        @doc "Capability required to EXECUTE <DPTF|C_Mint>|<DPTF|CX_Mint> Function \
            \ Master Mint capability, required to mint DPTF Tokens, both as Origin and as Standard Mint"
        (if (= origin true)
            (compose-capability (DPTF|MINT-ORIGIN patron id client amount method))
            (compose-capability (DPTF|MINT-STANDARD patron id client amount method))
        )
        (compose-capability (DALOS|EXECUTOR))
    )
    (defcap DPTF|MINT-ORIGIN (patron:string id:string client:string amount:decimal method:bool)
        @doc "Capability required to mint the Origin DPTF Mint Supply"
        (compose-capability (DALOS|METHODIC client method))
        (compose-capability (GAS|MATRON_SOFT patron id client UTILITY.GAS_BIGGEST))
        (compose-capability (DPTF|MINT-ORIGIN_CORE id client amount))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|MINT-ORIGIN_CORE (id:string account:string amount:decimal)
        @doc "Core Capability required to mint the Origin DPTF Mint Supply"
        (DPTF-DPMF|UV_Amount id amount true)
        (compose-capability (DPTF|VIRGIN id))
        (compose-capability (DPTF-DPMF|OWNER id true))
        (compose-capability (DPTF-DPMF|CREDIT id account true))
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
    )
    (defcap DPTF|MINT-STANDARD (patron:string id:string client:string amount:decimal method:bool)
        @doc "Capability required to mint a DPTF Token"                
        (compose-capability (DALOS|METHODIC client method))
        (compose-capability (GAS|MATRON_SOFT patron id client UTILITY.GAS_SMALL))
        (compose-capability (DPTF|MINT-STANDARD_CORE id client amount))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|MINT-STANDARD_CORE (id:string client:string amount:decimal)
        @doc "Core Capability required to mint a DPTF Token"
        (DPTF-DPMF|UV_Amount id amount true)
        (compose-capability (DPTF|ACCOUNT_MINT_STATE id client true))
        (compose-capability (DPTF-DPMF|CREDIT id client true))
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
    )
    ;;3.1.2.4][T]           Transfer
    (defcap DPTF|TRANSFER_GAS (sender:string receiver:string amount:decimal)
        @doc "Capability required for moving GAS"
        (let
            (
                (gas-id:string (DALOS|UR_IgnisID))
            )
            (compose-capability (DPTF-DPMF|TRANSFER_CORE gas-id sender receiver amount true))
            (compose-capability (DALOS|METHODIC_TRANSFERABILITY sender receiver true))
        )
    )
    (defcap DPTF|TRANSFER_MIN (id:string transfer-amount:decimal)
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
    ;;========[T] FUNCTIONS====================================================;;
    ;;3.2]    [T] DPTF Functions
    ;;3.2.1]  [T]   DPTF Utility Functions
    ;;3.2.1.1][T]           Account Info
    (defun DPTF|UR_AccountRoleMint:bool (id:string account:string)
        @doc "Returns Account <account> True Fungible <id> Mint Role \
            \ Assumed as false if DPTF Account doesnt exit"
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id true)
        (with-default-read DPTF|BalanceTable (concat [id UTILITY.BAR account])
            { "role-mint" : false}
            { "role-mint" := rm }
            rm
        )
    )
    (defun DPTF|UR_AccountRoleFeeExemption:bool (id:string account:string)
        @doc "Returns Account <account> True Fungible <id> Fee Exemption Role \
            \ Assumed as false if DPTF Account doesnt exit"
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id true)
        (with-default-read DPTF|BalanceTable (concat [id UTILITY.BAR account])
            { "role-fee-exemption" : false}
            { "role-fee-exemption" := rfe }
            rfe
        )
    )
    (defun DPTF-DPMF|UR_AccountFrozenState:bool (id:string account:string token-type:bool)
        @doc "Returns Account <account> True or Meta Fungible <id> Frozen State \
            \ Assumed as false if DPTF|DPMF Account doesnt exit"
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id token-type)
        (if (= token-type true)
            (with-default-read DPTF|BalanceTable (concat [id UTILITY.BAR account])
                { "frozen" : false}
                { "frozen" := fr }
                fr
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILITY.BAR account])
                { "frozen" : false}
                { "frozen" := fr }
                fr
            )
        )
    )
    ;;3.2.1.2][T]           True-Fungible Info
    (defun DPTF|UR_OriginMint:bool (id:string)
        @doc "Returns <origin-mint> for the DPTF <id>"
        (at "origin-mint" (read DPTF|PropertiesTable id ["origin-mint"]))
    )
    (defun DPTF|UR_OriginAmount:decimal (id:string)
        @doc "Returns <origin-mint-amount> for the DPTF <id>"
        (at "origin-mint-amount" (read DPTF|PropertiesTable id ["origin-mint-amount"]))
    )
    (defun DPTF|UR_FeeToggle:bool (id:string)
        @doc "Returns <fee-toggle> for the DPTF <id>"
        (at "fee-toggle" (read DPTF|PropertiesTable id ["fee-toggle"]))
    )
    (defun DPTF|UR_MinMove:decimal (id:string)
        @doc "Returns <min-move> for the DPTF <id>"
        (at "min-move" (read DPTF|PropertiesTable id ["min-move"]))
    )
    (defun DPTF|UR_FeePromile:decimal (id:string)
        @doc "Returns <fee-promile> for the DPTF <id>"
        (at "fee-promile" (read DPTF|PropertiesTable id ["fee-promile"]))
    )
    (defun DPTF|UR_FeeTarget:string (id:string)
        @doc "Returns <fee-target> for the DPTF <id>"
        (at "fee-target" (read DPTF|PropertiesTable id ["fee-target"]))
    )
    (defun DPTF|UR_FeeLock:bool (id:string)
        @doc "Returns <fee-lock> for the DPTF <id>"
        (at "fee-lock" (read DPTF|PropertiesTable id ["fee-lock"]))
    )
    (defun DPTF|UR_FeeUnlocks:integer (id:string)
        @doc "Returns <fee-unlocks> for the DPTF <id>"
        (at "fee-unlocks" (read DPTF|PropertiesTable id ["fee-unlocks"]))
    )
    (defun DPTF|UR_PrimaryFeeVolume:decimal (id:string)
        @doc "Returns <primary-fee-volume> for the DPTF <id>"
        (at "primary-fee-volume" (read DPTF|PropertiesTable id ["primary-fee-volume"]))
    )
    (defun DPTF|UR_SecondaryFeeVolume:decimal (id:string)
        @doc "Returns <secondary-fee-volume> for the DPTF <id>"
        (at "secondary-fee-volume" (read DPTF|PropertiesTable id ["secondary-fee-volume"]))
    )
    (defun DPTF|UR_RewardToken:[string] (id:string)
        @doc "Returns a list of ATS Pairs the id is part of as a Reward Token"
        (at "reward-token" (read DPTF|PropertiesTable id ["reward-token"]))
    )
    (defun DPTF|UR_RewardBearingToken:[string] (id:string)
        @doc "Returns a list of ATS Pairs the id is part of as a cold Reward Bearing Token"
        (at "reward-bearing-token" (read DPTF|PropertiesTable id ["reward-bearing-token"]))
    )
    ;;3.2.1.3][T]           Computing
    (defun DPTF|UC_VolumetricTax (id:string amount:decimal)
        @doc "Computes the Volumetric-Transaction-Tax (VTT), given an DTPF <id> and <amount>"
        (DPTF-DPMF|UV_Amount id amount true)
        (UTILITY.DPTF|UC_VolumetricTax (DPTF-DPMF|UR_Decimals id true) amount)
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
        \ All 3 amounts, when summed, must equal exactlz the input amount to the last decimal"
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
                        (fee-target:string (DPTF|UR_FeeTarget id))
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
    (defun DPTF|UC_UnlockPrice:[decimal] (id:string)
        @doc "Computes the <fee-lock> unlock price for a DPTF <id> \
            \ Outputs [virtual-gas-costs native-gas-cost] \
            \ Virtual Gas Token = Ignis; Native Gas Token = Kadena"
        (UTILITY.DPTF|UC_UnlockPrice (DPTF|UR_FeeUnlocks id))
    )
    (defun DPTF|UC_TransferFeeAndMinException:bool (id:string sender:string receiver:string)
        @doc "Computes if there is a DPTF Fee or Min Transfer Amount Exception"
        (let*
            (
                (gas-id:string (DALOS|UR_IgnisID))
                (sender-fee-exemption:bool (DPTF|UR_AccountRoleFeeExemption id sender))
                (receiver-fee-exemption:bool (DPTF|UR_AccountRoleFeeExemption id receiver))
                (token-owner:string (DPTF-DPMF|UR_Konto id true))
                (sender-t1:bool (or (= sender DPTF|SC_NAME) (= sender GAS|SC_NAME)))
                (sender-t2:bool (or (= sender token-owner)(= sender-fee-exemption true)))
                (iz-sender-exception:bool (or sender-t1 sender-t2))
                (receiver-t1:bool (or (= receiver DPTF|SC_NAME) (= receiver GAS|SC_NAME)))
                (receiver-t2:bool (or (= receiver token-owner)(= receiver-fee-exemption true)))
                (iz-receiver-exception:bool (or receiver-t1 receiver-t2))
                (are-members-exception (or iz-sender-exception iz-receiver-exception))
                (is-id-gas:bool (= id gas-id))
                (iz-exception:bool (or is-id-gas are-members-exception ))
            )
            iz-exception
        )
    )
    ;;5.3.2]  [T]   DPTF Administration Functions
        ;;NONE
    ;;3.2.3]  [T]   DPTF Client Functions
    ;;3.2.3.1][T]           Control
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
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL)
                true
            )
            (DPTF|X_Control patron id cco cu casr cf cw cp)
            (DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF|C_ToggleFee (patron:string id:string toggle:bool)
        @doc "Toggles <fee-toggle> for the DPTF Token <id> to <toggle> \
        \ <fee-toggle> must be set to true for fee collection to execute"
        (with-capability (DPTF|TOGGLE_FEE patron id toggle)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL)
                true
            )
            (DPTF|X_ToggleFee id toggle)
            (DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF|C_SetMinMove (patron:string id:string min-move-value:decimal)
        @doc "Sets the <min-move> for the DPTF Token <id> to <min-move-value>"
        (with-capability (DPTF|SET_MIN-MOVE patron id min-move-value)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL)
                true
            )
            (DPTF|X_SetMinMove id min-move-value)
            (DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF|C_SetFee (patron:string id:string fee:decimal)
        @doc "Sets the <fee-promile> for DPTF Token <id> to <fee> \
        \ -1.0 activates the Volumetric Transaction Tax (VTT) mechanic."
        (with-capability (DPTF|SET_FEE patron id fee)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL)
                true
            )
            (DPTF|X_SetFee id fee)
            (DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF|C_SetFeeTarget (patron:string id:string target:string)
        @doc "Sets the <fee-target> for DPTF Token <id> to <target> \
            \ Default is <Ouroboros> (Fee-Carrier Account) \
            \ Setting it to <Gas-Tanker> makes fees act like collected gas \
            \ Fees from <Ouroboros> can be retrieved by the Token owner; fees from <Gas-Tanker> are distributed to DALOS Custodians."
        (with-capability (DPTF|SET_FEE-TARGET patron id target)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL)
                true
            )
            (DPTF|X_SetFeeTarget id target)
            (DALOS|X_IncrementNonce patron)
        )
    )
    (defun DPTF|C_ToggleFeeLock (patron:string id:string toggle:bool)
        @doc "Sets the <fee-lock> for DPTF Token <id> to <toggle> \
            \ Unlocking (<toggle> = false) has restrictions: \
            \ - Max 7 unlocks per token \
            \ - Unlock cost: (10000 IGNIS + 100 KDA) * (fee-unlocks + 1) \
            \ - Each unlock adds a Secondary Fee collected by the <GasTanker> Smart DALOS Account \
            \ equal to the VTT * fee-unlocks, calculated by <UTILITY.DPTF|UC_VolumetricTax>"
        (let
            (
                (ZG:bool (GAS|UC_SubZero))
                (NZG:bool (GAS|UC_NativeSubZero))
                (token-owner:string (DPTF-DPMF|UR_Konto id true))
            )
            (with-capability (DPTF|TOGGLE_FEE-LOCK patron id toggle)
                (if (not ZG)
                    (GAS|X_Collect patron token-owner UTILITY.GAS_SMALL)
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
                                (GAS|X_Collect patron token-owner gas-costs)
                                true
                            )
                            (if (not NZG)
                                (GAS|X_CollectDalosFuel patron kda-costs)
                                true
                            )
                            (DPTF|X_IncrementFeeUnlocks id)
                        )
                        true
                    )
                )
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    (defun DPTF|C_WithdrawFees (patron:string id:string output-target-account:string)
        @doc "Withdraws Primary Fees from the Ouroboros Smart DALOS Account \
            \ Limitations: \
            \ Works only if DPTF <id> <fee-target> is left default (Ouroboros Smart DALOS Account) \
            \ Only the Token Owner can collect these fees to a Normal DALOS Account"
        (with-capability (DPTF|WITHDRAW-FEES patron id output-target-account)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL)
                true
            )
            (DPTF|X_WithdrawFees id output-target-account)
            (DALOS|X_IncrementNonce patron)
        )
    )
    ;;3.2.3.2][T]           Token Roles
    (defun DPTF|C_ToggleMintRole (patron:string id:string account:string toggle:bool)
        @doc "Sets |role-mint| to <toggle> for TrueFungible <id> and DPTF Account <account>, allowing or revoking minting rights"
        (with-capability (DPTF|TOGGLE_MINT-ROLE patron id account toggle)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                true
            )
            (DPTF|X_ToggleMintRole id account toggle)
            (DALOS|X_IncrementNonce patron)
            (if (and (= account ATS|SC_NAME) (= toggle false))
                (ATS|C_RevokeMint patron id)
                true
            )
        )
    )
    (defun DPTF|C_ToggleFeeExemptionRole (patron:string id:string account:string toggle:bool)
        @doc "Sets |role-fee-exemption| to <toggle> for TrueFungible <id> and DPTF Account <account> \
            \ Accounts with this role true are exempt from fees when sending or receiving the token, if fee settings are active"
        (with-capability (DPTF|TOGGLE_FEE-EXEMPTION-ROLE patron id account toggle)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                true
            )
            (DPTF|X_ToggleFeeExemptionRole id account toggle)
            (DALOS|X_IncrementNonce patron)
            (if (and (= account ATS|SC_NAME) (= toggle false))
                (ATS|C_RevokeFeeExemption patron id)
                true
            )
        )
    )
    ;;3.2.3.3][T]           Create
    (defun DPTF|CM_Issue:[string]
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
        @doc "Issues Multiple DPTF Tokens at once"
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
                (tf-cost:decimal (DALOS|UR_True))
                (gas-costs:decimal (* (dec l1) UTILITY.GAS_ISSUE))
                (kda-costs:decimal (* (dec l1) tf-cost))
            )
            (UTILITY.UV_EnforceUniformIntegerList lengths)
            (with-capability (DPTF-DPMF|ISSUE patron account true l1)
                (if (not (GAS|UC_SubZero))
                    (GAS|X_Collect patron account gas-costs)
                    true
                )
                (if (not (GAS|UC_NativeSubZero))
                    (GAS|X_CollectDalosFuel patron kda-costs)
                    true
                )
                (fold
                    (lambda
                        (acc:[string] index:integer)
                        (let
                            (
                                (id:string
                                    (DPTF|X_Issue 
                                        l1 
                                        patron 
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
                            (DALOS|X_IncrementNonce patron)
                            (UTILITY.UC_AppendLast acc id)
                        )
                    )
                    []
                    (enumerate 0 (- (length name) 1))
                )
            )
        )
    )
    (defun DPTF|C_Issue:string 
        (
            patron:string 
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
        @doc "Issues a new DALOS TrueFungible Token, creating an entry in DPTF|PropertiesTable \
            \ Outputs the unique Token-id (ticker + first 12 characters of previous block hash) \
            \ Also creates the issuer's DPTF Account as the first account for this token."
        
        (with-capability (DPTF-DPMF|ISSUE patron account true 1)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron account UTILITY.GAS_ISSUE)
                true
            )
            (if (not (GAS|UC_NativeSubZero))
                (GAS|X_CollectDalosFuel patron (DALOS|UR_True))
                true
            )
            (DALOS|X_IncrementNonce patron)
            (DPTF|X_Issue 1 patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause)
        )
    )
    (defun DPTF|CX_Mint (patron:string id:string account:string amount:decimal origin:bool)
        @doc "Client DPTF Mint Methodic Function"
        (with-capability (DPTF|MINT patron id account amount origin true)
            (DPTF|K_Mint patron id account amount origin)
        )
    )
    (defun DPTF|C_Mint (patron:string id:string account:string amount:decimal origin:bool)
        @doc "Client DPTF Mint Function"
        (with-capability (DPTF|MINT patron id account amount origin false)
            (DPTF|K_Mint patron id account amount origin)
        )
    )
        (defun DPTF|K_Mint (patron:string id:string account:string amount:decimal origin:bool)
            @doc "Kore Mint Function: Mints <amount> <id> TrueFungible for DPTF Account <account> \
            \ \
            \ Boolean <origin> toggles Normal Mint (false, 2 GAS) and Origin Mint (true, 5 GAS). \
            \ Origin Mint can only be executed once right after issuance, with zero emission, and requires no Mint Role."
            (require-capability (DALOS|EXECUTOR))
            (if (not (GAS|UC_ZeroGAS id account))
                (if origin
                    (GAS|X_Collect patron account UTILITY.GAS_BIGGEST)
                    (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                )
                true
            )
            (DPTF|X_Mint id account amount origin)
            (DALOS|X_IncrementNonce account)
        )
    ;;3.2.3.4][T]           Destroy
    (defun DPTF|CX_Burn (patron:string id:string account:string amount:decimal)
        @doc "Client DPTF Burn Methodic Function"
        (with-capability (DPTF-DPMF|BURN patron id account amount true true)
            (DPTF|K_Burn patron id account amount)
        )
    )
    (defun DPTF|C_Burn (patron:string id:string account:string amount:decimal)
        @doc "Client DPTF Burn Function"
        (with-capability (DPTF-DPMF|BURN patron id account amount false true)
            (DPTF|K_Burn patron id account amount)
        )
    )
        (defun DPTF|K_Burn (patron:string id:string account:string amount:decimal)
            @doc "Kore Function for Burning DPTF Tokens"
            (require-capability (DALOS|EXECUTOR))
            (if (not (GAS|UC_ZeroGAS id account))
                (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                true
            )
            (DPTF|X_Burn id account amount)
            (DALOS|X_IncrementNonce account)
        )
    ;;3.2.3.5][T]           Transfer and Transmute
    (defun DPTF|CX_Transfer (patron:string id:string sender:string receiver:string a:decimal)
        @doc "Client DPTF Transfer Methodic Function"
        (with-capability (DPTF-DPMF|TRANSFER patron id sender receiver a true true)
            (DPTF|K_Transfer patron id sender receiver a)
        )
    )
    (defun DPTF|C_Transfer (patron:string id:string sender:string receiver:string a:decimal)
        @doc "Client DPTF Transfer Function"
        (with-capability (DPTF-DPMF|TRANSFER patron id sender receiver a false true)
            (DPTF|K_Transfer patron id sender receiver a)
        )
    )
        (defun DPTF|K_Transfer (patron:string id:string sender:string receiver:string a:decimal)
            @doc "Kore DPTF Transfer Function"
            (require-capability (DALOS|EXECUTOR))
            (if (not (and (= id (DALOS|UR_UnityID))(>= a 10)))
                (if (not (GAS|UC_ZeroGAZ id sender receiver))
                    (GAS|X_Collect patron sender UTILITY.GAS_SMALLEST)
                    true
                )
                true
            )
            (DPTF|X_Transfer id sender receiver a)
            (DALOS|X_IncrementNonce sender)
        )
    (defun DPTF|C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal)
        @doc "Client DPTF Transmute Function"
        (with-capability (DPTF|TRANSMUTE patron id transmuter)
            (DPTF|K_Transmute patron id transmuter transmute-amount)
        )
    )
        (defun DPTF|K_Transmute (patron:string id:string transmuter:string transmute-amount:decimal)
            @doc "Kore DPTF Transmute Function"
            (require-capability (DALOS|EXECUTOR))
            (if (not (and (= id (DALOS|UR_UnityID))(>= transmute-amount 10)))
                (if (not (GAS|UC_ZeroGAS id transmuter))
                    (GAS|X_Collect patron transmuter UTILITY.GAS_SMALLEST)
                    true
                )
                true
            )    
            (DPTF|X_Transmute id transmuter transmute-amount)
            (DALOS|X_IncrementNonce transmuter)
        )
    ;;3.2.4]  [T]   DPTF Auxiliary Functions
    ;;3.2.4.1][T]           Transfer
    (defun DPTF|X_Transfer (id:string sender:string receiver:string transfer-amount:decimal)
        @doc "Transfers <id> TrueFungible from <sender> to <receiver> DPTF Account without GAS"
        (require-capability (DPTF-DPMF|TRANSFER_CORE id sender receiver transfer-amount true))
        (DPTF|X_Debit id sender transfer-amount false)
        (let*
            (
                (ea-id:string (DALOS|UR_EliteAurynID))
                (fee-toggle:bool (DPTF|UR_FeeToggle id))
                (iz-exception:bool (DPTF|UC_TransferFeeAndMinException id sender receiver))
                (fees:[decimal] (DPTF|UC_Fee id transfer-amount))
                (primary-fee:decimal (at 0 fees))
                (secondary-fee:decimal (at 1 fees))
                (remainder:decimal (at 2 fees))
                (iz-full-credit:bool 
                    (or 
                        (or 
                            (= fee-toggle false) 
                            (= iz-exception true)
                        ) 
                        (= primary-fee 0.0)
                    )
                )
            )
            (if (= iz-full-credit true)
                (DPTF|X_Credit id receiver transfer-amount)
                (if (= secondary-fee 0.0)
                    (with-capability (COMPOSE)
                        (DPTF|X_CreditPrimaryFee id primary-fee true)
                        (DPTF|X_Credit id receiver remainder)
                    )
                    (with-capability (COMPOSE)
                        (DPTF|X_CreditPrimaryFee id primary-fee true)
                        (DPTF|X_Credit id GAS|SC_NAME secondary-fee)
                        (DPTF|X_UpdateFeeVolume id secondary-fee false)
                        (DPTF|X_Credit id receiver remainder)
                    )
                )
            )
            (DPTF-DPMF|X_UpdateElite id sender receiver)
        )
    )
    (defun DPTF|X_CreditPrimaryFee (id:string pf:decimal native:bool)
        @doc "Function used within <DPTF|X_Transfer> to credit Primary Fee; \
        \ Depends on specific ATS Parameters if id is part of an ATS-Pair"
        (let
            (
                (rt:bool (ATS|UC_IzRT-Absolute id))
                (rbt:bool (ATS|UC_IzRBT-Absolute id true))
                (target:string (DPTF|UR_FeeTarget id))
            )
            (if (and rt rbt)
                (let*
                    (
                        (v:[decimal] (ATS|CPF_RT-RBT id pf))
                        (v1:decimal (at 0 v))
                        (v2:decimal (at 1 v))
                        (v3:decimal (at 2 v))
                    )
                    (DPTF|X_CPF_StillFee id target v1)
                    (DPTF|X_CPF_CreditFee id target v2)
                    (DPTF|X_CPF_BurnFee id target v3)
                )
                (if rt
                    (let*
                        (
                            (v1:decimal (ATS|CPF_RT id pf))
                            (v2:decimal (- pf v1))
                        )
                        (DPTF|X_CPF_StillFee id target v1)
                        (DPTF|X_CPF_CreditFee id target v2)
                    )
                    (if rbt
                        (let*
                            (
                                (v1:decimal (ATS|CPF_RBT id pf))
                                (v2:decimal (- pf v1))
                            )
                            (DPTF|X_CPF_StillFee id target v1)
                            (DPTF|X_CPF_BurnFee id target v2)
                        )
                        (DPTF|X_Credit id target pf)
                    )
                )
            )
        )
        (if native
            (DPTF|X_UpdateFeeVolume id pf true)
            true
        )
    )
    (defun DPTF|X_CPF_StillFee (id:string target:string still-fee:decimal)
        @doc "Helper Function needed for <DPTF|X_CreditPrimaryFee>"
        (require-capability (DPTF|CPF_STILL-FEE))
        (if (!= still-fee 0.0)
            (DPTF|X_Credit id target still-fee)
            true
        )
    )
    (defun DPTF|X_CPF_BurnFee (id:string target:string burn-fee:decimal)
        @doc "Helper Function needed for <DPTF|X_CreditPrimaryFee>"
        (require-capability (DPTF|CPF_BURN-FEE))
        (if (!= burn-fee 0.0)
            (with-capability (DPTF-DPMF|BURN_CORE id ATS|SC_NAME burn-fee true)
                (DPTF|X_Credit id ATS|SC_NAME burn-fee)
                (DPTF|X_Burn id ATS|SC_NAME burn-fee)
            )
        true
        )
    )
    (defun DPTF|X_CPF_CreditFee (id:string target:string credit-fee:decimal)
        @doc "Helper Function needed for <DPTF|X_CreditPrimaryFee>"
        (require-capability (DPTF|CPF_CREDIT-FEE))
        (if (!= credit-fee 0.0)
            (DPTF|X_Credit id ATS|SC_NAME credit-fee)
            true
        )
    )
    (defun DPTF|X_Transmute (id:string transmuter:string transmute-amount:decimal)
        @doc "Transmutes a DPTF Token; only specific functions can use transmutation\
        \ Transmutation behaves as a DPTF Fee (without actually counting towards Native DPTF Fee Volume), \
        \ when the DPTF Token is not part of any ATS-Pair; \
        \ If the Token is part one or multiple ATS Pairs, \
        \ the input amount will be used to strengthen those ATS-Pairs Indices"
        (require-capability (DPTF|TRANSMUTE_MANTLE id transmuter))
        (DPTF|X_Debit id transmuter transmute-amount false)
        (DPTF|X_CreditPrimaryFee id transmute-amount false)
    )
    (defun DPTF|X_Credit (id:string account:string amount:decimal)
        @doc "Auxiliary Function that credits a TrueFungible to a DPTF Account \
        \ If a DPTF Account for the Token ID <id> doesnt exist, it will be created \
        \ However if a DALOS Account (Standard or Smart) doesnt exit for <account>, function will fail, \
        \ since a DALOS Account is mandatory for a DPTF Account creation"
        ;;Capability Required for Credit
        (require-capability (DPTF-DPMF|CREDIT id account true))
        ;;Checks if a DPTF Account Exists, if it doesnt a new one is created with the credited amount
        ;;If it exists, a write operation is executed, writing an updated amount.
        (let
            (
                (dptf-account-exist:bool (DPTF-DPMF|UR_AccountExist id account true))
            )
            (enforce (> amount 0.0) "Crediting amount must be greater than zero")
            (if (= dptf-account-exist false)
                (insert DPTF|BalanceTable (concat [id UTILITY.BAR account])
                    { "balance"                         : amount
                    , "role-burn"                       : false
                    , "role-mint"                       : false
                    , "role-transfer"                   : false
                    , "role-fee-exemption"              : false
                    , "frozen"                          : false
                    }
                )
                (with-read DPTF|BalanceTable (concat [id UTILITY.BAR account])
                    { "balance"                         := b
                    , "role-burn"                       := rb
                    , "role-mint"                       := rm
                    , "role-transfer"                   := rt
                    , "role-fee-exemption"              := rfe
                    , "frozen"                          := f
                    }
                    (write DPTF|BalanceTable (concat [id UTILITY.BAR account])
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
    (defun DPTF|X_Debit (id:string account:string amount:decimal admin:bool)
        @doc "Auxiliary Function that debits a TrueFungible from a DPTF Account \
            \ \
            \ true <admin> boolean is used when debiting is executed as a part of wiping by the DPTF Owner \
            \ otherwise, for normal debiting operations, false <admin> boolean must be used"
        ;;Capability Required for Debit is called within the <if> body
        (if (= admin true)
            (require-capability (DPTF-DPMF|OWNER id true))
            (require-capability (DPTF-DPMF|DEBIT id account true))
        )
        (with-read DPTF|BalanceTable (concat [id UTILITY.BAR account])
            { "balance" := balance }
            (enforce (<= amount balance) "Insufficient Funds for debiting")
            (update DPTF|BalanceTable (concat [id UTILITY.BAR account])
                {"balance" : (- balance amount)}    
            )
        )
    )
    ;;3.2.4.2][T]           Update
    (defun DPTF|X_UpdateFeeVolume (id:string amount:decimal primary:bool)
        @doc "Updates Primrary Fee Volume for DPTF <id> with <amount>"
        (DPTF-DPMF|UV_Amount id amount true)
        (require-capability (DPTF|UPDATE_FEES))
        (if (= primary true)
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
    (defun DPTF|X_UpdateRewardToken (atspair:string id:string direction:bool)
        (require-capability (ATS|UPDATE_RT))
        (with-read DPTF|PropertiesTable id
            {"reward-token" := rt}
            (if (= direction true)
                (if (= (at 0 rt) UTILITY.BAR)
                    (update DPTF|PropertiesTable id
                        {"reward-token" : [atspair]}
                    )
                    (update DPTF|PropertiesTable id
                        {"reward-token" : (UTILITY.UC_AppendLast rt atspair)}
                    )
                )
                (update DPTF|PropertiesTable id
                    {"reward-token" : (UC_RemoveItem rt atspair)}
                )
            )
        )
    )
    ;;3.2.4.3][T]           Remainder-Aux
    (defun DPTF|X_Control
        (
            patron:string
            id:string
            can-change-owner:bool 
            can-upgrade:bool 
            can-add-special-role:bool 
            can-freeze:bool 
            can-wipe:bool 
            can-pause:bool
        )
        (require-capability (DPTF-DPMF|CONTROL_CORE id true))
        (update DPTF|PropertiesTable id
            {"can-change-owner"                 : can-change-owner
            ,"can-upgrade"                      : can-upgrade
            ,"can-add-special-role"             : can-add-special-role
            ,"can-freeze"                       : can-freeze
            ,"can-wipe"                         : can-wipe
            ,"can-pause"                        : can-pause}
        )
    )
    (defun DPTF|X_ToggleFee (id:string toggle:bool)
        (require-capability (DPTF|TOGGLE_FEE_CORE id toggle))
        (update DPTF|PropertiesTable id
            { "fee-toggle" : toggle}
        )
    )
    (defun DPTF|X_SetMinMove (id:string min-move-value:decimal)
        (require-capability (DPTF|SET_MIN-MOVE_CORE id min-move-value))
        (update DPTF|PropertiesTable id
            { "min-move" : min-move-value}
        )
    )
    (defun DPTF|X_SetFee (id:string fee:decimal)
        (require-capability (DPTF|SET_FEE_CORE id fee))
        (update DPTF|PropertiesTable id
            { "fee-promile" : fee}
        )
    )
    (defun DPTF|X_SetFeeTarget (id:string target:string)
        (require-capability (DPTF|SET_FEE-TARGET_CORE id target))
        (update DPTF|PropertiesTable id
            { "fee-target" : target}
        )
    )
    (defun DPTF|X_ToggleFeeLock:[decimal] (id:string toggle:bool)
        (require-capability (DPTF|TOGGLE_FEE-LOCK_CORE id toggle))
        (update DPTF|PropertiesTable id
            { "fee-lock" : toggle}
        )
        (if (= toggle true)
            [0.0 0.0]
            (UTILITY.DPTF|UC_UnlockPrice (DPTF|UR_FeeUnlocks id))
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
    (defun DPTF|X_WithdrawFees (id:string output-target-account:string)
        (require-capability (DPTF|WITHDRAW-FEES_CORE id output-target-account))
        (let
            (
                (withdraw-amount:decimal (DPTF-DPMF|UR_AccountSupply id DPTF|SC_NAME true))
            )
            (DPTF|X_Transfer id DPTF|SC_NAME output-target-account withdraw-amount)
        )
    )
    (defun DPTF|X_ToggleMintRole (id:string account:string toggle:bool)
        (require-capability (DPTF|TOGGLE_MINT-ROLE_CORE id account toggle))
        (update DPTF|BalanceTable (concat [id UTILITY.BAR account])
            {"role-mint" : toggle}
        )
    )
    (defun DPTF|X_ToggleFeeExemptionRole (id:string account:string toggle:bool)
        (require-capability (DPTF|TOGGLE_FEE-EXEMPTION-ROLE_CORE id account toggle))
        (update DPTF|BalanceTable (concat [id UTILITY.BAR account])
            {"role-fee-exemption" : toggle}
        )
    )
    (defun DPTF|X_Issue:string
        (
            issue-size:integer
            patron:string 
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
        (UTILITY.DALOS|UV_Decimals decimals)
        (UTILITY.DALOS|UV_Name name)
        (UTILITY.DALOS|UV_Ticker ticker)
        (require-capability (DPTF-DPMF|ISSUE patron account true issue-size))
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
                ,"fee-target"           : DPTF|SC_NAME
                ,"fee-lock"             : false
                ,"fee-unlocks"          : 0
                ,"primary-fee-volume"   : 0.0
                ,"secondary-fee-volume" : 0.0
                ,"reward-token"         : [UTILITY.BAR]
                ,"reward-bearing-token" : [UTILITY.BAR]
                ,"vesting"              : UTILITY.BAR
            }
        )
        ;;Creates a new DPTF Account for the Token Issuer and returns id
        (DPTF-DPMF|C_DeployAccount (DALOS|UC_Makeid ticker) account true)
        (DALOS|UC_Makeid ticker)
    )
    (defun DPTF|X_Mint (id:string account:string amount:decimal origin:bool)
        (if (= origin true)
            (require-capability (DPTF|MINT-ORIGIN_CORE id account amount))
            (require-capability (DPTF|MINT-STANDARD_CORE id account amount))
        )
        (DPTF|X_Credit id account amount)
        (DPTF-DPMF|X_UpdateSupply id amount true true)
        (if (= origin true)
            (update DPTF|PropertiesTable id
                { "origin-mint" : false
                , "origin-mint-amount" : amount}
            )
            true
        )
    )
    (defun DPTF|X_Burn (id:string account:string amount:decimal)
        (require-capability (DPTF-DPMF|BURN_CORE id account amount true))
        (DPTF|X_Debit id account amount false)
        (DPTF-DPMF|X_UpdateSupply id amount false true)
    )
    ;;
    ;;
    ;;
    ;;Demiourgos-Pact-Meta-Fungible; [4] DPMF Submodule
    ;;
    ;;
    ;;
    ;;========[M] CAPABILITIES=================================================;;
    ;;4.1]    [M] DPMF Capabilities
    ;;4.1.1]  [M]   DPMF Basic Capabilities
    ;;4.1.1.1][M]           DPMF <DPMF|PropertiesTable> Table Management
    (defcap DPMF|CAN-TRANSFER-NFT-CREATE-ROLE_ON (id:string)
        @doc "Enforces DPMF Token Property as true"
        (let
            (
                (x:bool (DPMF|UR_CanTransferNFTCreateRole id))
            )
            (enforce (= x true) (format "DPMF Token {} cannot have its create role transfered" [id])
            )
        )
    )
    (defcap DPMF|INCREASE_NONCE ()
        @doc "Capability required to update |nonce| in the DPMF|PropertiesTable"
        true
    )
    ;;4.1.1.2][M]           DPMF <DPMF|BalanceTable> Table Management
    (defcap DPMF|ACCOUNT_ADD-QUANTITY_STATE (id:string account:string state:bool)
        @doc "Enforces DPMF Account <role-nft-add-quantity> to <state>"
        (let
            (
                (x:bool (DPMF|UR_AccountRoleNFTAQ id account))
            )
            (enforce (= x state) (format "Add Quantity Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    (defcap DPMF|ACCOUNT_CREATE_STATE (id:string account:string state:bool)
        @doc "Enforces DPMF Account <role-nft-create> to <state>"
        (let
            (
                (x:bool (DPMF|UR_AccountRoleCreate id account))
            )
            (enforce (= x state) (format "Create Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    ;;4.1.2]  [M]  DPMF Composed Capabilities
    ;;4.1.2.1][M]           Token Roles
    (defcap DPMF|MOVE_CREATE-ROLE (patron:string id:string receiver:string)
        @doc "Capability required to EXECUTE <DPMF|C_MoveCreateRole> Function"
        (let
            (
                (current-owner-account:string (DPTF-DPMF|UR_Konto id false))
            )
            (compose-capability (DPMF|MOVE_CREATE-ROLE_CORE id receiver))
            (compose-capability (GAS|COLLECTION patron current-owner-account UTILITY.GAS_BIGGEST))
            (compose-capability (DALOS|INCREASE-NONCE))
        ) 
    )
    (defcap DPMF|MOVE_CREATE-ROLE_CORE (id:string receiver:string)
        @doc "Core Capability required to set <role-nft-create> for a DPMF Account of a DPMF Token"
        (DALOS|UV_SenderWithReceiver (DPMF|UR_CreateRoleAccount id) receiver)
        (compose-capability (DPTF-DPMF|OWNER id false))
        (compose-capability (DPMF|CAN-TRANSFER-NFT-CREATE-ROLE_ON id))
        (compose-capability (DPMF|ACCOUNT_CREATE_STATE id (DPMF|UR_CreateRoleAccount id) true))
        (compose-capability (DPMF|ACCOUNT_CREATE_STATE id receiver false))
    )
    (defcap DPMF|TOGGLE_ADD-QUANTITY-ROLE (patron:string id:string account:string toggle:bool)
        @doc "Capability required to EXECUTE <DPMF|C_ToggleAddQuantityRole> Function"
        (compose-capability (DPMF|TOGGLE_ADD-QUANTITY-ROLE_CORE id account toggle))    
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPMF|TOGGLE_ADD-QUANTITY-ROLE_CORE (id:string account:string toggle:bool)
        @doc "Core Capability required to toggle <role-nft-add-quantity> for a DPMF Account"
        (compose-capability (DPTF-DPMF|OWNER id false))
        (if (= toggle true)
            (compose-capability (DPTF-DPMF|CAN-ADD-SPECIAL-ROLE_ON id false))
            true
        )
        (compose-capability (DPMF|ACCOUNT_ADD-QUANTITY_STATE id account (not toggle)))
    )
    ;;4.1.2.2][M]           Create
    (defcap DPMF|MINT (patron:string id:string client:string amount:decimal method:bool)
        @doc "Capability required to EXECUTE <DPMF|C_Mint>|<DPMF|CX_Mint> Function"
        (compose-capability (DALOS|METHODIC client method))
        (compose-capability (GAS|MATRON_SOFT patron id client UTILITY.GAS_SMALL))
        (compose-capability (DPMF|MINT_CORE id client amount))
        (compose-capability (DALOS|INCREASE-NONCE))
        (compose-capability (DALOS|EXECUTOR))
    )
    (defcap DPMF|MINT_CORE (id:string client:string amount:decimal)
        @doc "Core Capability required to mint a DPMF Token"
        (compose-capability (DPMF|CREATE_CORE id client))
        (compose-capability (DPMF|ADD-QUANTITY_CORE id client amount))
    )
    (defcap DPMF|CREATE (patron:string id:string client:string method:bool)
        @doc "Capability that allows creation of a new MetaFungilbe nonce"
        (compose-capability (DALOS|METHODIC client method))
        (compose-capability (GAS|MATRON_SOFT patron id client UTILITY.GAS_SMALL))
        (compose-capability (DPMF|CREATE_CORE id client))
        (compose-capability (DALOS|INCREASE-NONCE))
        (compose-capability (DALOS|EXECUTOR))
    )
    (defcap DPMF|CREATE_CORE (id:string client:string)
        @doc "Core Capability that allows creation of a new MetaFungilbe nonce"
        (compose-capability (DPMF|ACCOUNT_CREATE_STATE id client true))
        (compose-capability (DPMF|INCREASE_NONCE))
    )
    (defcap DPMF|ADD-QUANTITY (patron:string id:string client:string amount:decimal method:bool)
        @doc "Capability required to add-quantity for a DPMF Token"
        (compose-capability (DALOS|METHODIC client method))
        (compose-capability (GAS|MATRON_SOFT patron id client UTILITY.GAS_SMALL))
        (compose-capability (DPMF|ADD-QUANTITY_CORE id client))
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
        (compose-capability (DALOS|INCREASE-NONCE))
        (compose-capability (DALOS|EXECUTOR))
    )
    (defcap DPMF|ADD-QUANTITY_CORE (id:string client:string amount:decimal)
        @doc "Core Capability required to add-quantity for a DPMF Token"
        (DPTF-DPMF|UV_Amount id amount false)
        (compose-capability (DPMF|ACCOUNT_ADD-QUANTITY_STATE id client true))
        (compose-capability (DPTF-DPMF|CREDIT id client false))
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
    )
    ;;========[M] FUNCTIONS====================================================;;
    ;;4.2]    [M] DPMF Functions
    ;;4.2.1]  [M]   DPMF Utility Functions
    ;;4.2.1.1][M]           Account Info
    (defun DPMF|UR_AccountUnit:[object] (id:string account:string)
        @doc "Returns Account <account> Meta Fungible <id> Unit"
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id false)
        (with-default-read DPMF|BalanceTable (concat [id UTILITY.BAR account])
            { "unit" : DPMF|NEGATIVE}
            { "unit" := u }
            u
        )
    )
    (defun DPMF|UR_AccountRoleNFTAQ:bool (id:string account:string)
        @doc "Returns Account <account> Meta Fungible <id> NFT Add Quantity Role"
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id false)
        (with-default-read DPMF|BalanceTable (concat [id UTILITY.BAR account])
            { "role-nft-add-quantity" : false}
            { "role-nft-add-quantity" := rnaq }
            rnaq
        )
    )
    (defun DPMF|UR_AccountRoleCreate:bool (id:string account:string)
        @doc "Returns Account <account> Meta Fungible <id> Create Role"
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id false)
        (with-default-read DPMF|BalanceTable (concat [id UTILITY.BAR account])
            { "role-nft-create" : false}
            { "role-nft-create" := rnc }
            rnc
        )
    )
    ;;4.2.1.2][M]           Account Nonce
    (defun DPMF|UR_AccountBalances:[decimal] (id:string account:string)
        @doc "Returns a list of Balances that exist for MetaFungible <id> on DPMF Account <account>\
        \ Needed for Mass Debiting"
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id false)
        (with-default-read DPMF|BalanceTable (concat [id UTILITY.BAR  account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let 
                (
                    (result 
                        (fold
                            (lambda 
                                (acc:[decimal] item:object{DPMF|Schema})
                                (if (!= (at "balance" item) 0.0)
                                        (UTILITY.UC_AppendLast acc (at "balance" item))
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
    (defun DPMF|UR_AccountNonces:[integer] (id:string account:string)
        @doc "Returns a list of Nonces that exist for MetaFungible <id> held by DPMF Account <account>"
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id false)
        (with-default-read DPMF|BalanceTable (concat [id UTILITY.BAR  account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let 
                (
                    (result 
                        (fold
                            (lambda 
                                (acc:[integer] item:object{DPMF|Schema})
                                (if (!= (at "nonce" item) 0)
                                        (UTILITY.UC_AppendLast acc (at "nonce" item))
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
    (defun DPMF|UR_AccountBatchSupply:decimal (id:string nonce:integer account:string)
        @doc "Returns the supply of a MetaFungible Batch (<id> & <nonce>) held by DPMF Account <account>"
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id false)
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
    (defun DPMF|UR_AccountBatchMetaData (id:string nonce:integer account:string)
        @doc "Returns the Meta-Data of a MetaFungible Batch (<id> & <nonce>) held by DPMF Account <account>"
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id false)
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
    ;;4.2.1.3][M]           Meta-Fungible Info
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
        (at "reward-bearing-token" (read DPMF|PropertiesTable id ["reward-bearing-token"]))
    )
    ;;4.2.1.4][M]           Composition
    (defun DPMF|UC_Compose:object{DPMF|Schema} (nonce:integer balance:decimal meta-data:[object])
        @doc "Composes a Meta-Fungible object from <nonce>, <balance> and <meta-data>"
        {"nonce" : nonce, "balance": balance, "meta-data" : meta-data}
    )
    (defun DPMF|UC_Pair_Nonce-Balance:[object{DPMF|Nonce-Balance}] (nonce-lst:[integer] balance-lst:[decimal])
        @doc "Composes a Nonce-Balance object from a <nonce-lst> list and <balance-lst> list"
        (let
            (
                (nonce-length:integer (length nonce-lst))
                (balance-length:integer (length balance-lst))
            )
            (enforce (= nonce-length balance-length) "Nonce and Balance Lists are not of equal length")
            (zip (lambda (x:integer y:decimal) { "nonce": x, "balance": y }) nonce-lst balance-lst)
        )
    )
    ;;4.2.2]  [M]   DPTM Client Functions
    ;;4.2.2.1][M]           Control
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
        (with-capability (DPTF-DPMF|CONTROL patron id false)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (DPTF-DPMF|UR_Konto id false) UTILITY.GAS_SMALL)
                true
            )
            (DPMF|X_Control patron id cco cu casr cf cw cp ctncr)
            (DALOS|X_IncrementNonce patron)
        )
    )
    ;;4.2.2.2][M]           Token Roles
    (defun DPMF|C_MoveCreateRole (patron:string id:string receiver:string)
        @doc "Moves |role-nft-create| from <sender> to <receiver> DPMF Account for MetaFungible <id> \
            \ Only a single DPMF Account can have the |role-nft-create| \
            \ Afterwards the receiver DPMF Account can crete new Meta Fungibles \ 
            \ Fails if the target DPMF Account doesnt exist"
        (with-capability (DPMF|MOVE_CREATE-ROLE patron id receiver)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (DPTF-DPMF|UR_Konto id false) UTILITY.GAS_BIGGEST)
                true
            )
            (DPMF|X_MoveCreateRole id receiver)
            (DALOS|X_IncrementNonce patron)
            (if (!= (DPMF|UR_CreateRoleAccount id) ATS|SC_NAME)
                (ATS|C_RevokeCreateOrAddQ patron id)
                true
            )
        )
    )
    (defun DPMF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool)
        @doc "Sets |role-nft-add-quantity| to <toggle> boolean for MetaFungible <id> and DPMF Account <account> \
            \ Afterwards Account <account> can either add quantity or no longer add quantity to existing MetaFungible"
        (with-capability (DPMF|TOGGLE_ADD-QUANTITY-ROLE patron id account toggle)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                true
            )
            (DPMF|X_ToggleAddQuantityRole id account toggle)
            (DALOS|X_IncrementNonce patron)
            (if (and (= account ATS|SC_NAME) (= toggle false))
                (ATS|C_RevokeCreateOrAddQ patron id)
                true
            )
        )
    )
    ;;4.2.2.3][M]           Create
    (defun DPMF|CM_Issue:[string]
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
        @doc "Issues Multiple DPTF Tokens at once"
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
                (tf-cost:decimal (DALOS|UR_Meta))
                (gas-costs:decimal (* (dec l1) UTILITY.GAS_ISSUE))
                (kda-costs:decimal (* (dec l1) tf-cost))
            )
            (UTILITY.UV_EnforceUniformIntegerList lengths)
            (with-capability (DPTF-DPMF|ISSUE patron account false l1)
                (if (not (GAS|UC_SubZero))
                    (GAS|X_Collect patron account gas-costs)
                    true
                )
                (if (not (GAS|UC_NativeSubZero))
                    (GAS|X_CollectDalosFuel patron kda-costs)
                    true
                )
                (fold
                    (lambda
                        (acc:[string] index:integer)
                        (let
                            (
                                (id:string
                                    (DPMF|X_Issue 
                                        l1 
                                        patron 
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
                            (DALOS|X_IncrementNonce patron)
                            (UTILITY.UC_AppendLast acc id)
                        )
                    )
                    []
                    (enumerate 0 (- (length name) 1))
                )
            )
        )
    )
    (defun DPMF|C_Issue:string 
        (
            patron:string
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
        @doc "Issues a new DALOS MEtaFungible Token, creating an entry in DPMF|PropertiesTable \
            \ Outputs the unique Token-id (ticker + first 12 characters of previous block hash) \
            \ Also creates the issuer's DPMF Account as the first account for this token."
        (with-capability (DPTF-DPMF|ISSUE patron account false 1)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron account UTILITY.GAS_ISSUE)
                true
            )
            (if (not (GAS|UC_NativeSubZero))
                (GAS|X_CollectDalosFuel patron (DALOS|UR_Meta))
                true
            )
            (DALOS|X_IncrementNonce patron)
            (DPMF|X_Issue 1 patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role)
        )
    )
    (defun DPMF|CX_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object])
        @doc "Client Metodic Function that mints a DPMF"
        (with-capability (DPMF|MINT patron id account amount true)
            (DPMF|K_Mint patron id account amount meta-data)
        )
    )
    (defun DPMF|C_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object])
        @doc "Client Function that mints a DPMF"
        (with-capability (DPMF|MINT patron id account amount false)
            (DPMF|K_Mint patron id account amount meta-data)
        )
    )
        (defun DPMF|K_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object])
            @doc "Kore Function that mints a DPMF"
            (require-capability (DALOS|EXECUTOR))
            (if (not (GAS|UC_ZeroGAS id account))
                (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                true
            )
            (DALOS|X_IncrementNonce account)
            (DPMF|X_Mint id account amount meta-data)
        )
    (defun DPMF|CX_Create:integer (patron:string id:string account:string meta-data:[object])
        @doc "Client Methodic Function that creates a DPMF"
        (with-capability (DPMF|CREATE patron id account true)
            (DPMF|K_Create patron id account meta-data)
        )
    )
    (defun DPMF|C_Create:integer (patron:string id:string account:string meta-data:[object])
        @doc "Client Function that creates a DPMF"
        (with-capability (DPMF|CREATE patron id account false)
            (DPMF|K_Create patron id account meta-data)
        )
    )
        (defun DPMF|K_Create:integer (patron:string id:string account:string meta-data:[object])
            @doc "Kore Function that creates a DPMF"
            (require-capability (DALOS|EXECUTOR))
            (if (not (GAS|UC_ZeroGAS id account))
                (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                true
            )
            (DALOS|X_IncrementNonce account)
            (DPMF|X_Create id account meta-data)
        )
    (defun DPMF|CX_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Client Methodic Function that adds quantity for a DPMF Token"
        (require-capability (DPMF|ADD-QUANTITY patron id account amount true))
        (DPMF|K_AddQuantity patron id nonce account amount)
    )
    (defun DPMF|C_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Client Function that adds quantity for a DPMF Token"
        (with-capability (DPMF|ADD-QUANTITY patron id account amount false)
            (DPMF|K_AddQuantity patron id nonce account amount)
        )
    )
        (defun DPMF|K_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal)
            @doc "Kore Function that adds quantity for a DPMF Token"
            (require-capability (DALOS|EXECUTOR))
            (if (not (GAS|UC_ZeroGAS id account))
                (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                true
            )
            (DPMF|X_AddQuantity id nonce account amount)
            (DALOS|X_IncrementNonce account)
        )
    ;;4.2.2.4][M]           Destroy
    (defun DPMF|CX_Burn (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Client Methodic Function that burns a DPMF Token"
        (with-capability (DPTF-DPMF|BURN patron id account amount true false)
            (DPMF|K_Burn patron id nonce account amount)
        )
    )
    (defun DPMF|C_Burn (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Client Function that burns a DPMF Token"
        (with-capability (DPTF-DPMF|BURN patron id account amount false false)
            (DPMF|K_Burn patron id nonce account amount)
        )
    )
        (defun DPMF|K_Burn (patron:string id:string nonce:integer account:string amount:decimal)
            @doc "Kore Function that burns a DPMF Token"
            (require-capability (DALOS|EXECUTOR))
            (if (not (GAS|UC_ZeroGAS id account))
                (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                true
            )
            (DPMF|X_Burn id nonce account amount)
            (DALOS|X_IncrementNonce account)
        )
    ;;4.2.2.5][M]           Transfer
    (defun DPMF|CX_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal)
        @doc "Client DPMF Transfer Methodic Function"
        (with-capability (DPTF-DPMF|TRANSFER patron id sender receiver transfer-amount true false)
            (DPMF|K_Transfer patron id nonce sender receiver transfer-amount)
        )
    )
    (defun DPMF|C_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal)
        @doc "Client DPMF Transfer Function"
        (with-capability (DPTF-DPMF|TRANSFER patron id sender receiver transfer-amount false false)
            (DPMF|K_Transfer patron id nonce sender receiver transfer-amount)
        )
    )
        (defun DPMF|K_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal)
            @doc "Kore DPMF Transfer Function"
            (require-capability (DALOS|EXECUTOR))
            (if (not (GAS|UC_ZeroGAZ id sender receiver))
                (GAS|X_Collect patron sender UTILITY.GAS_SMALLEST)
                true
            )
            (DPMF|X_Transfer id nonce sender receiver transfer-amount)
            (DALOS|X_IncrementNonce sender)
        )
    ;;4.2.3]  [M]   DPTM Auxiliary Functions
    ;;4.2.3.1][M]           Transfer
    (defun DPMF|X_Transfer (id:string nonce:integer sender:string receiver:string transfer-amount:decimal)
        @doc "Transfers <id> MetaFungible from <sender> to <receiver> DPMF Account without GAS"
        (require-capability (DPTF-DPMF|TRANSFER_CORE id sender receiver transfer-amount false))
        (let
            (
                (current-nonce-meta-data (DPMF|UR_AccountBatchMetaData id nonce sender))
                (ea-id:string (DALOS|UR_EliteAurynID))
            )
            (DPMF|X_Debit id nonce sender transfer-amount false)
            (DPMF|X_Credit id nonce current-nonce-meta-data receiver transfer-amount)
            (DPTF-DPMF|X_UpdateElite id sender receiver)
        )
    )
    (defun DPMF|X_Credit (id:string nonce:integer meta-data:[object] account:string amount:decimal)
        @doc "Auxiliary Function that credit a MetaFungible to a DPMF Account \
            \ Also creates a new DPMF Account if it doesnt exist. \
            \ If account already has DPMF nonce, it is simply increased \
            \ If account doesnt have DPMF nonce, it is added"
        (require-capability (DPTF-DPMF|CREDIT id account false))
        (let*
            (
                (create-role-account:string (DPMF|UR_CreateRoleAccount id))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILITY.BAR account])
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
                        (present-meta-fungible:object{DPMF|Schema} (DPMF|UC_Compose nonce current-nonce-balance meta-data))
                        (credited-meta-fungible:object{DPMF|Schema} (DPMF|UC_Compose nonce credited-balance meta-data))
                        (processed-unit-with-replace:[object{DPMF|Schema}] (UTILITY.UC_ReplaceItem next-unit present-meta-fungible credited-meta-fungible))
                        (processed-unit-with-append:[object{DPMF|Schema}] (UTILITY.UC_AppendLast next-unit credited-meta-fungible))
                    )
                    (enforce (> amount 0.0) "Crediting amount must be greater than zero")
                    ;; First, a new DPTS Account is created for Account <account>. 
                    ;; If DPTS Account exists for <account>, nothing is modified
                    ;; Make the Write in the account
                    (if (= current-nonce-balance 0.0)
                        ;;Remove Metafungible
                        (write DPMF|BalanceTable (concat [id UTILITY.BAR account])
                            { "unit"                        : processed-unit-with-append
                            , "role-nft-add-quantity"       : (if is-new false rnaq)
                            , "role-nft-burn"               : (if is-new false rb)
                            , "role-nft-create"             : (if is-new role-nft-create-boolean rnc)
                            , "role-transfer"               : (if is-new false rt)
                            , "frozen"                      : (if is-new false f)}
                        )
                        ;;Replace Metafungible
                        (write DPMF|BalanceTable (concat [id UTILITY.BAR account])
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
    (defun DPMF|X_Debit (id:string nonce:integer account:string amount:decimal admin:bool)
        @doc "Auxiliary Function that debits a MetaFungible from a DPMF Account \
            \ If the amount is equal to the whole nonce amount, the whole MetaFungible is removed \
            \ \
            \ true <admin> boolean is used when debiting is executed as a part of wiping by the DPMF Owner \
            \ otherwise, for normal debiting operations, false <admin> boolean must be used"
        (if (= admin true)
            (require-capability (DPTF-DPMF|OWNER id false))
            (require-capability (DPTF-DPMF|DEBIT id account false))
        )
        (with-read DPMF|BalanceTable (concat [id UTILITY.BAR account])
            { "unit"                                := unit  
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
                    (meta-fungible-to-be-replaced:object{DPMF|Schema} (DPMF|UC_Compose nonce current-nonce-balance current-nonce-meta-data))
                    (debited-meta-fungible:object{DPMF|Schema} (DPMF|UC_Compose nonce debited-balance current-nonce-meta-data))
                    (processed-unit-with-remove:[object{DPMF|Schema}] (UTILITY.UC_RemoveItem unit meta-fungible-to-be-replaced))
                    (processed-unit-with-replace:[object{DPMF|Schema}] (UTILITY.UC_ReplaceItem unit meta-fungible-to-be-replaced debited-meta-fungible))
                )
                (enforce (>= debited-balance 0.0) "Insufficient Funds for debiting")
                (if (= debited-balance 0.0)
                    ;;Remove Metafungible
                    (update DPMF|BalanceTable (concat [id UTILITY.BAR account])
                        {"unit"                     : processed-unit-with-remove
                        ,"role-nft-add-quantity"    : rnaq
                        ,"role-nft-burn"            : rnb
                        ,"role-nft-create"          : rnc
                        ,"role-transfer"            : rt
                        ,"frozen"                   : f}
                    )
                    ;;Replace Metafungible
                    (update DPMF|BalanceTable (concat [id UTILITY.BAR account])
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
                (nonce-balance-obj-lst:[object{DPMF|Nonce-Balance}] (DPMF|UC_Pair_Nonce-Balance nonce-lst balance-lst))
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
            (DPMF|X_Debit id nonce account balance true)
        )
    )
    ;;4.2.3.2][M]           Update
    (defun DPMF|X_IncrementNonce (id:string)
        @doc "Increments <id> MetaFungible nonce"
        (require-capability (DPMF|INCREASE_NONCE))
        (with-read DPMF|PropertiesTable id
            { "nonces-used" := nu }
            (update DPMF|PropertiesTable id { "nonces-used" : (+ nu 1)})
        )
    )
    ;;4.2.3.3][M]           Remainder-Aux
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
        (require-capability (DPTF-DPMF|CONTROL_CORE id false))
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
    (defun DPMF|X_MoveCreateRole (id:string receiver:string)
        @doc "Assumes a DPMF Account exists for the <receiver>"
        (require-capability (DPMF|MOVE_CREATE-ROLE_CORE id receiver))
        (update DPMF|BalanceTable (concat [id UTILITY.BAR (DPMF|UR_CreateRoleAccount id)])
            {"role-nft-create" : false}
        )
        (update DPMF|BalanceTable (concat [id UTILITY.BAR receiver])
            {"role-nft-create" : true}
        )
        (update DPMF|PropertiesTable id
            {"create-role-account" : receiver}
        )
    )
    (defun DPMF|X_ToggleAddQuantityRole (id:string account:string toggle:bool)
        (require-capability (DPMF|TOGGLE_ADD-QUANTITY-ROLE_CORE id account toggle))
        (update DPMF|BalanceTable (concat [id UTILITY.BAR account])
            {"role-nft-add-quantity" : toggle}
        )
    )
    (defun DPMF|X_Issue:string
        (
            issue-size:integer
            patron:string
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
        (UTILITY.DALOS|UV_Decimals decimals)
        (UTILITY.DALOS|UV_Name name)
        (UTILITY.DALOS|UV_Ticker ticker)
        (require-capability (DPTF-DPMF|ISSUE patron account false issue-size))
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
            ,"reward-bearing-token" : UTILITY.BAR
            ,"vesting"              : UTILITY.BAR}
        )
        ;;Creates a new DPMF Account for the Token Issuer and returns id
        (DPTF-DPMF|C_DeployAccount (DALOS|UC_Makeid ticker) account false)
        (DALOS|UC_Makeid ticker)
    )
    (defun DPMF|X_Mint:integer (id:string account:string amount:decimal meta-data:[object])
        @doc "Auxiliary Base Function that mints a DPMF"
        (require-capability (DPMF|MINT_CORE id account amount))
        (let
            (
                (new-nonce:integer (+ (DPMF|UR_NoncesUsed id) 1))
            )
            (DPMF|X_Create id account meta-data)
            (DPMF|X_AddQuantity id new-nonce account amount)
            new-nonce
        )
    )
    (defun DPMF|X_Create:integer (id:string account:string meta-data:[object])
        @doc "Auxiliary Base Function that creates a MetaFungible"
        (require-capability (DPMF|CREATE_CORE id account))
        (let*
            (
                (new-nonce:integer (+ (DPMF|UR_NoncesUsed id) 1))
                (create-role-account:string (DPMF|UR_CreateRoleAccount id))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILITY.BAR account])
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
                        (meta-fungible:object{DPMF|Schema} (DPMF|UC_Compose new-nonce 0.0 meta-data))
                        (appended-meta-fungible:[object{DPMF|Schema}] (UTILITY.UC_AppendLast u meta-fungible))
                    )
                    (write DPMF|BalanceTable (concat [id UTILITY.BAR account])
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
    (defun DPMF|X_AddQuantity (id:string nonce:integer account:string amount:decimal)
        @doc "Auxiliary Base Function that adds quantity for an existing Metafungible \
            \ Assumes <id> and <nonce> exist on DPMF Account"
        (require-capability (DPMF|ADD-QUANTITY_CORE id account amount))
        (with-read DPMF|BalanceTable (concat [id UTILITY.BAR account])
            { "unit" := unit }
            (let*
                (
                    (current-nonce-balance:decimal (DPMF|UR_AccountBatchSupply id nonce account))
                    (current-nonce-meta-data (DPMF|UR_AccountBatchMetaData id nonce account))
                    (updated-balance:decimal (+ current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object{DPMF|Schema} (DPMF|UC_Compose nonce current-nonce-balance current-nonce-meta-data))
                    (updated-meta-fungible:object{DPMF|Schema} (DPMF|UC_Compose nonce updated-balance current-nonce-meta-data))
                    (processed-unit:[object{DPMF|Schema}] (UTILITY.UC_ReplaceItem unit meta-fungible-to-be-replaced updated-meta-fungible))
                )
                (update DPMF|BalanceTable (concat [id UTILITY.BAR account])
                    {"unit" : processed-unit}    
                )
            )
        )
        (DPTF-DPMF|X_UpdateSupply id amount true false)
    )
    (defun DPMF|X_Burn (id:string nonce:integer account:string amount:decimal)
        @doc "Auxiliary Base Function that burns a DPMF"
        (require-capability (DPTF-DPMF|BURN_CORE id account amount false))
        (DPMF|X_Debit id nonce account amount false)
        (DPTF-DPMF|X_UpdateSupply id amount false false)
    )
    ;;
    ;;
    ;;
    ;;GAS; [5] GAS Submodule
    ;;
    ;;
    ;;
    ;;========[G] CAPABILITIES=================================================;;
    ;;5.1]    [G] GAS Capabilities
    ;;5.1.1]  [G]   GAS Basic Capabilities
    (defcap GAS|VIRTUAL_STATE (state:bool)
        @doc "Enforces <virtual-gas-toggle> to <state>"
        (let
            (
                (t:bool (GAS|UR_VirtualToggle))
            )
            (if (= state true)
                (enforce (= t true) "Virtual GAS Collection is not turned on !")
                (let
                    (
                        (current-gas-source-id:string (DALOS|UR_OuroborosID))
                        (current-gas-id:string (DALOS|UR_IgnisID))
                    )
                    (enforce (= t false) "Virtual GAS Collection is turned on !")
                    (enforce (!= current-gas-source-id "") "Gas-Source-ID hasnt been set for the Virtual GAS collection to be turned ON")
                    (enforce (!= current-gas-id "") "Gas-ID hasnt been set for the Virtual GAS collection to be turned ON")
                    (enforce (!= current-gas-source-id current-gas-id) "Gas-Source-ID must be different from the Gas-ID for the Virtual GAS collection to be turned ON")
                )
            )
        )
    )
    (defcap GAS|NATIVE_STATE (state:bool)
        @doc "Enforces <native-gas-toggle> to <state>"
        (let
            (
                (t:bool (GAS|UR_NativeToggle))
            )
            (if (= state true)
                (enforce (= t true) "Native GAS Collection is not turned on !")
                (enforce (= t false) "Native GAS Collection is turned on !")
            )
        )
    )
    (defcap GAS|COLLECT_KDA (patron:string kda-amount:decimal)
        @doc "Capability needed to Collect KDA Fees"
        (UTILITY.DALOS|UV_Account patron)
        (compose-capability (GAS|INCREMENT))
        (let*
            (
                (kadena-split:[decimal] (GAS|UC_KadenaSplit kda-amount))
                (am1:decimal (at 1 kadena-split))
                (wrapped-kda-id:string (DALOS|UR_WrappedKadenaID))
            )
            (compose-capability (DPTF-DPMF|TRANSFER patron wrapped-kda-id patron LIQUID|SC_NAME am1 true true))
        )
    )
    (defcap GAS|INCREMENT ()
        @doc "Capability Required to increment the GAS spent"
        true
    )
    ;;5.1.2]  [G]   GAS Composed Capabilities
    ;;5.1.2.1][G]           GAS Control
    (defcap GAS|UPDATE_IDS (id:string)
        (DPTF-DPMF|UVE_id id true)
        (compose-capability (GAS-TANKER))
    )
    (defcap GAS|TOGGLE (native:bool toggle:bool)
        @doc "Capability required to toggle virtual or native GAS to either on or off"
        (compose-capability (GAS-TANKER))
        (if (= native true)
            (compose-capability (GAS|NATIVE_STATE (not toggle)))
            (compose-capability (GAS|VIRTUAL_STATE (not toggle)))
        )
    )
    ;;5.1.2.2][G]           GAS Handling
    (defcap GAS|MATRON_SOFT (patron:string id:string client:string gas-amount:decimal)
        @doc "Capability needed to be a gas payer for a patron with a sender"
        (let
            (
                (ZG:bool (GAS|UC_ZeroGAS id client))
            )
            (if (= ZG false)
                (compose-capability (GAS|COLLECTION patron client gas-amount))
                true
            ) 
        )
    )
    (defcap GAS|MATRON_STRONG (patron:string id:string client:string target:string gas-amount:decimal)
        @doc "Capability needed to be a gas payer for a patron with a sender and receiver"
        (let
            (
                (ZG:bool (GAS|UC_ZeroGAZ id client target))
            )
            (if (= ZG false)
                (compose-capability (GAS|COLLECTION patron client gas-amount))
                true
            )
        )
    )
    (defcap GAS|PATRON (patron:string)
        @doc "Capability that ensures a DALOS account can act as gas payer, also enforcing its Guard"
            (compose-capability (DALOS|IZ_ACCOUNT_SMART patron false))
            (compose-capability (DALOS|ACCOUNT_OWNER patron))
    )
    (defcap GAS|COLLECTION (patron:string sender:string amount:decimal)
        @doc "Capability required to collect GAS"
        (compose-capability (GAS|PATRON patron))
        (let
            (
                (sender-type:bool (DALOS|UR_AccountType sender))
            )
            (if (= sender-type false)
                (compose-capability (GAS|COLLECTER_STANDARD patron amount))
                (compose-capability (GAS|COLLECTER_SMART patron sender amount))
            )
        )
    )
    (defcap GAS|COLLECTER_STANDARD (patron:string amount:decimal)
        @doc "Capability required to collect GAS when Normal DALOS accounts are involved as clients"
        (let
            (
                (gas-id:string (DALOS|UR_IgnisID))
            )
            (if (!= gas-id UTILITY.BAR)
                (compose-capability (GAS|COLLECTER_STANDARD_CORE patron amount gas-id))
                true
            )
        )
    )
    (defcap GAS|COLLECTER_STANDARD_CORE (patron:string amount:decimal gas-id:string)
        (DPTF-DPMF|UV_Amount gas-id amount true)
        (compose-capability (DPTF|TRANSFER_GAS patron (GAS|UR_Tanker) amount))
        (compose-capability (GAS|INCREMENT))
    )
    (defcap GAS|COLLECTER_SMART (patron:string sender:string amount:decimal)
        @doc "Capability required to collect GAS when Smart DALOS accounts are involved as clients"
        ;;03]Validate <amount> as a GAS amount
        (let
            (
                (gas-id:string (DALOS|UR_IgnisID))
            )
            (if (!= gas-id UTILITY.BAR)
                (let*
                    (
                        (gas-pot:string (GAS|UR_Tanker))
                        (quarter:decimal (* amount UTILITY.GAS_QUARTER))
                        (rest:decimal (- amount quarter))
                    )
                    (DPTF-DPMF|UV_Amount gas-id amount true)
                    (compose-capability (DPTF|TRANSFER_GAS patron gas-pot rest))
                    (compose-capability (DPTF|TRANSFER_GAS patron sender quarter))
                    (compose-capability (GAS|INCREMENT))
                )
                true
            )
        )
    )
    ;;========[G] FUNCTIONS====================================================;;
    ;;5.2]    [G] GAS Functions
    ;;5.2.1]  [G]   GAS Utility Functions
    ;;5.2.1.1][G]           Gas Info
    (defun GAS|UR_Tanker:string ()
        @doc "Returns as string the Gas Pot Account"
        (at "virtual-gas-tank" (read GAS|PropertiesTable GAS|VGD ["virtual-gas-tank"]))
    )
    (defun GAS|UR_VirtualToggle:bool ()
        @doc "Returns as boolean the Gas Toggle State"
        (with-default-read GAS|PropertiesTable GAS|VGD
            {"virtual-gas-toggle" : false}
            {"virtual-gas-toggle" := tg}
            tg
        )
    )
    (defun GAS|UR_VirtualSpent:decimal ()
        @doc "Returns as decimal the amount of Gas Spent"
        (at "virtual-gas-spent" (read GAS|PropertiesTable GAS|VGD ["virtual-gas-spent"]))
    )
    (defun GAS|UR_NativeToggle:bool ()
        @doc "Returns as boolean the Native Gas Toggle State"
        (with-default-read GAS|PropertiesTable GAS|VGD
            {"native-gas-toggle" : false}
            {"native-gas-toggle" := tg}
            tg
        )
    )
    (defun GAS|UR_NativeSpent:decimal ()
        @doc "Returns as decimal the amount of Native Gas Spent"
        (at "native-gas-spent" (read GAS|PropertiesTable GAS|VGD ["native-gas-spent"]))
    )
    ;;5.2.1.2][G]           Computing
    (defun GAS|UC_ZeroGAZ:bool (id:string sender:string receiver:string)
        @doc "Returns true if Virtual GAS cost is Zero (not yet toggled), otherwise returns false (s + r)"

        (let*
            (
                (t1:bool (GAS|UC_ZeroGAS id sender))
                (t2:bool (if (or (= receiver GAS|SC_NAME)(= receiver LIQUID|SC_NAME)) true false))
            )
            (or t1 t2)
        )
    )
    (defun GAS|UC_ZeroGAS:bool (id:string sender:string)
        @doc "Returns true if Virtual GAS cost is Zero (not yet toggled), otherwise returns false (s only)"

        (let*
            (
                (t1:bool (GAS|UC_Zero sender))
                (gas-id:string (DALOS|UR_IgnisID))
                (t2:bool (if (or (= gas-id UTILITY.BAR)(= id gas-id)) true false))
            )
            (or t1 t2)
        )
    )
    (defun GAS|UC_Zero:bool (sender:string)
        @doc "Function needed for <GAS|UC_ZeroGAS>"
        (let*
            (
                (t0:bool (GAS|UC_SubZero))
                (t1:bool (if (or (= sender GAS|SC_NAME)(= sender LIQUID|SC_NAME)) true false))
            )
            (or t0 t1)
        )
    )
    (defun GAS|UC_SubZero:bool ()
        @doc "Function needed for <GAS|UC_Zero>"
        (let*
            (
                (gas-toggle:bool (GAS|UR_VirtualToggle))
                (ZG:bool (if (= gas-toggle false) true false))
            )
            ZG
        )
    )
    (defun GAS|UC_NativeSubZero:bool ()
        @doc "Returns true if Native GAS cost is Zero (not yet toggled), otherwise returns false"
        (let*
            (
                (gas-toggle:bool (GAS|UR_NativeToggle))
                (NZG:bool (if (= gas-toggle false) true false))
            )
            NZG
        )
    )
    (defun GAS|UC_KadenaSplit:[decimal] (kadena-input-amount:decimal)
        @doc "Computes the KDA Split required for Native Gas Collection \
        \ This is 5% 5% 15% and 75% outputed as 5% 15% 75% in a list"
        (let*
            (
                (five:decimal (UTILITY.UC_Percent kadena-input-amount 5.0 UTILITY.KDA_PRECISION))
                (fifteen:decimal (UTILITY.UC_Percent kadena-input-amount 15.0 UTILITY.KDA_PRECISION))
                (total:decimal (UTILITY.UC_Percent kadena-input-amount 25.0 UTILITY.KDA_PRECISION))
                (rest:decimal (- kadena-input-amount total))
            )
            [five fifteen rest]
        )
    )
    ;;5.2.2]  [G]   GAS Administration Functions
    (defun GAS|A_SetIDs (id:string source:bool)
        @doc "Sets the Gas-Source|Gas id for the Virtual Blockchain \
            \ Boolean <source> determines wheter Gas-Source ID or GAS Id is set"
        (DPTF-DPMF|UVE_id id true)
        (with-capability (GAS|UPDATE_IDS id)
            (if (= source true)
                (GAS|X_UpdateSourceID id)
                (GAS|X_UpdateID id)
            )
        )
    )
    (defun GAS|A_SetSourcePrice (price:decimal)
        @doc "Sets the Gas Source Price in (dollars)$, which determines how much GAS can be created from Gas Source Token"
        (with-capability (GAS-TANKER)
            (GAS|X_UpdateSourcePrice price)
        )
    )
    (defun GAS|A_Toggle (native:bool toggle:bool)
        @doc "Turns Native or Virtual Gas collection to <toggle>"
        (with-capability (GAS|TOGGLE native toggle)
            (GAS|X_Toggle native toggle)
        )
    )
    ;;5.2.4]  [G]   GAS Auxiliary Functions
    ;;5.2.4.1][G]           GAS|PropertiesTable Update
    (defun GAS|X_UpdateSourceID (id:string)
        @doc "Updates <gas-source-id> existing in the GAS|PropertiesTable"
        (require-capability (GAS|UPDATE_IDS id))
        (update GAS|PropertiesTable GAS|VGD
            {"gas-source-id" : id}
        )
    )
    (defun GAS|X_UpdateSourcePrice (price:decimal)
        @doc "Updates <gas-source-price> existing in the GAS|PropertiesTable"
        (require-capability (GAS-TANKER))
        (update GAS|PropertiesTable GAS|VGD
            {"gas-source-price" : price}
        )
    )
    (defun GAS|X_UpdateID (id:string)
        @doc "Updates <virtual-gas-id> existing in the GAS|PropertiesTable"
        (require-capability (GAS|UPDATE_IDS id))
        (update GAS|PropertiesTable GAS|VGD
            {"virtual-gas-id" : id}
        )
    )
    (defun GAS|X_Toggle (native:bool toggle:bool)
        @doc "Updates <native-gas-toggle> or <virtual-gas-toggle> existing in the GAS|PropertiesTable to <toggle>"
        (require-capability (GAS-TANKER))
        (if (= native true)
            (update GAS|PropertiesTable GAS|VGD
                {"native-gas-toggle" : toggle}
            )
            (update GAS|PropertiesTable GAS|VGD
                {"virtual-gas-toggle" : toggle}
            )
        )
    )
    (defun GAS|X_UpdatePot (account:string)
        @doc "Updates <virtual-gas-tank> existing in the GAS|PropertiesTable"
        (require-capability (GAS-TANKER))
        (update GAS|PropertiesTable GAS|VGD
            {"virtual-gas-tank" : account}
        )
    )
    (defun GAS|X_Increment (native:bool increment:decimal)
        @doc "Increments either <native-gas-spent> or <virtual-gas-spent> existing in the GAS|PropertiesTable to <increment>"
        (require-capability (GAS|INCREMENT))
        (let
            (
                (current-gas-spent:decimal (GAS|UR_VirtualSpent))
                (current-ngas-spent:decimal (GAS|UR_NativeSpent))
            )
            (if (= native true)
                (update GAS|PropertiesTable GAS|VGD
                    {"native-gas-spent" : (+ current-ngas-spent increment)}
                )
                (update GAS|PropertiesTable GAS|VGD
                    {"virtual-gas-spent" : (+ current-gas-spent increment)}
                )
            )
        )
    )
    ;;5.2.4.2][G]           Virtual Gas Collection
    (defun GAS|X_Collect (patron:string sender:string amount:decimal)
        @doc "Collects GAS"
        (require-capability (GAS|COLLECTION patron sender amount))
        (let
            (
                (sender-type:bool (DALOS|UR_AccountType sender))
            )
            (if (= sender-type false)
                (GAS|X_CollectStandard patron amount)
                (GAS|X_CollectSmart patron sender amount)
            )
        )
    )
    (defun GAS|X_CollectStandard (patron:string amount:decimal)
        @doc "Collects GAS when a Standard DALOS Account is involved"
        (require-capability (GAS|COLLECTER_STANDARD patron amount))
        (GAS|X_Transfer patron (GAS|UR_Tanker) amount)
        (GAS|X_Increment false amount)
    )
    (defun GAS|X_CollectSmart (patron:string sender:string amount:decimal)
        @doc "Collects GAS when a Smart DALOS Account is involved"
        (require-capability (GAS|COLLECTER_SMART patron sender amount))
        (let*
            (
                (gas-pot:string (GAS|UR_Tanker))
                (quarter:decimal (* amount UTILITY.GAS_QUARTER))
                (rest:decimal (- amount quarter))                
            )
            (GAS|X_Transfer patron gas-pot rest)
            (GAS|X_Transfer patron sender quarter)
            (GAS|X_Increment false amount)
        )
    )
    (defun GAS|X_Transfer (gas-sender:string gas-receiver:string gas-amount:decimal)
        @doc "Transfers <gas-amount> GAS from <gas-sender> to <gas-receiver>"
        (require-capability (DPTF|TRANSFER_GAS gas-sender gas-receiver gas-amount))
        (let
            (
                (gas-id:string (DALOS|UR_IgnisID))
            )
            (DPTF-DPMF|C_DeployAccount gas-id gas-receiver true)
            (DPTF|X_Debit gas-id gas-sender gas-amount false)
            (DPTF|X_Credit gas-id gas-receiver gas-amount)
        )            
    )
    ;;5.2.4.2][G]           Native Gas Collection
    (defun GAS|X_CollectDalosFuel (patron:string amount:decimal)
        @doc "Collects and distributes Blockchain Fuel in KDA \
        \ Team 10% | 15% Liquid KDA Protocol | 75% GasTanker (DALOS GasStation)"
        (require-capability (GAS|COLLECT_KDA patron amount))
        (let*
            (
                (kadena-split:[decimal] (GAS|UC_KadenaSplit amount))
                (am0:decimal (at 0 kadena-split))
                (am1:decimal (at 1 kadena-split))
                (am2:decimal (at 2 kadena-split))
                (kadena-patron:string (DALOS|UR_AccountKadena patron))
                (wrapped-kda-id:string (DALOS|UR_WrappedKadenaID))
                (liquidpair:string (at 0 (DPTF|UR_RewardToken wrapped-kda-id)))
            )
            (GAS|XC_TransferDalosFuel kadena-patron DALOS|CTO am0)
            (GAS|XC_TransferDalosFuel kadena-patron DALOS|HOV am0)
            ;;Autostake Part
            (LIQUID|C_WrapKadena patron patron am1)
            (DPTF|CX_Transfer patron wrapped-kda-id patron LIQUID|SC_NAME am1)
            (ATS|C_Fuel patron LIQUID|SC_NAME liquidpair wrapped-kda-id am1)

            (GAS|XC_TransferDalosFuel kadena-patron GAS|SC_KDA-NAME am2)
            (GAS|X_Increment true amount)
        )
    )
    (defun GAS|XC_TransferDalosFuel (sender:string receiver:string amount:decimal)
        @doc "Transfers <amount> Kadena from <sender> to <receiver> \
            \ <sender>|<receiver> are Kadena Accounts (that are saved in the Kadena Coin Table)"
        (install-capability (coin.TRANSFER sender receiver amount))
        (coin.transfer sender receiver amount)
    )
;;
    ;;
    ;;
    ;;AUTOSTAKE; [6] ATS Submodule
    ;;
    ;;
    ;;
    ;;========[A] CAPABILITIES=================================================;;
    ;;6.1]    [A] ATS Capabilities
    ;;6.1.1]  [A]   ATS Basic Capabilities
    ;;6.1.1.1][A]           <ATS|Pairs> Table Management
    (defcap ATS|EXIST (atspair:string)
        @doc "Enforces that an ATS Pair exists"
        (ATS|UVE_id atspair)
    )
    (defcap ATS|OWNER (atspair:string)
        @doc "Enforces ATS Pair Ownership"
        (enforce-guard (DALOS|UR_AccountGuard (ATS|UR_OwnerKonto atspair)))
    )
    (defcap ATS|CAN-CHANGE-OWNER_ON (atspair:string)
        @doc "Enforces ATS Pair ownership is changeble"
        (compose-capability (ATS|EXIST atspair))
        (let
            (
                (x:bool (ATS|UR_CanChangeOwner atspair))
            )
            (enforce (= x true) (format "ATS Pair {} ownership cannot be changed" [atspair]))
        )
    )
    (defcap ATS|RT_EXISTANCE (atspair:string reward-token:string existance:bool)
        @doc "Enforces DPTF <reward-token> <existance> for given <atspair>"
        (let
            (
                (existance-check:bool (ATS|UC_IzRT atspair reward-token))
            )
            (enforce (= existance-check existance) (format "{} Existance isnt verified for Token {} as RT with ATS Pair {}" [existance reward-token atspair]))
        )
    )
    (defcap ATS|RBT_EXISTANCE (atspair:string reward-bearing-token:string existance:bool cold-or-hot:bool)
        @doc "Enforces DPTF|DPMF cold or hot Reward-Bearing-Token <existance> for given <atspair> \
        \ <true> existance means the Token is registered to an ATS Pair"
        (let
            (
                (existance-check:bool (ATS|UC_IzRBT atspair reward-bearing-token cold-or-hot))
            )
            (enforce (= existance-check existance) (format "{} Existance isnt verified for Token {} as RBT with ATS Pair {}" [existance reward-bearing-token atspair]))
        )
    )
    (defcap ATS|HOT_RBT_PRESENCE (atspair:string enforced-presence:bool)
        @doc "Enforces that an ATS Pair has or not a registerd DPMF Token as a Hot RBT"
        (let
            (
                (presence-check:bool (ATS|UC_IzPresentHotRBT atspair))
            )
            (enforce (= presence-check enforced-presence) (format "ATS Pair {} cant verfiy {} presence for a Hot RBT Token" [atspair enforced-presence]))
        )
    )
    (defcap ATS|PARAMETER-LOCK_STATE (atspair:string state:bool)
        @doc "Enforces ATS Pair <parameter-lock> to <state>"
        (let
            (
                (x:bool (ATS|UR_Lock atspair))
            )
            (enforce (= x state) (format "Parameter-lock for ATS Pair {} must be set to {} for this operation" [atspair state]))
        )
    )
    (defcap ATS|FEE_STATE (atspair:string state:bool fee-switch:integer)
        @doc "Enforcers one of the 4 ATS fee bool parameters to <state> \
        \ The parameters are: \
        \ <c-nfr> or <h-nfr> \
        \ <c-fr> or <h-fr> "
        (let
            (
                (x:bool (ATS|UR_ColdNativeFeeRedirection atspair))
                (y:bool (ATS|UR_ColdRecoveryFeeRedirection atspair))
                (z:bool (ATS|UR_HotRecoveryFeeRedirection atspair))
            )
            (if (= fee-switch 0)
                (enforce (= x state) (format "Cold-NFR for ATS Pair {} must be set to {} for this operation" [atspair state]))
                (if (= fee-switch 1)
                    (enforce (= y state) (format "Cold-RFR for ATS Pair {} must be set to {} for this operation" [atspair state]))
                    (enforce (= z state) (format "Hot-RFR for ATS Pair {} must be set to {} for this operation" [atspair state]))
                )
            )
        )
    )
    (defcap ATS|ELITE_STATE (atspair:string state:bool)
        @doc "Enforces ATS Pair <c-elite-mode> to <state>"
        (let
            (
                (x:bool (ATS|UR_EliteMode atspair))
            )
            (enforce (= x state) (format "Elite-Mode for ATS Pair {} must be set to {} for this operation" [atspair state]))
        )
    )
    (defcap ATS|RECOVERY_STATE (atspair:string state:bool cold-or-hot:bool)
        @doc "Enforces ATS Pair <cold-recovery> or <hot-recovery> to <state>"
        (let
            (
                (x:bool (ATS|UR_ToggleColdRecovery atspair))
                (y:bool (ATS|UR_ToggleHotRecovery atspair))
            )
            (if (= cold-or-hot true)
                (enforce (= x state) (format "Cold-recovery for ATS Pair {} must be set to {} for this operation" [atspair state]))
                (enforce (= y state) (format "Hot-recovery for ATS Pair {} must be set to {} for this operation" [atspair state]))
            )
        )
    )
    (defcap ATS|INCREMENT-LOCKS ()
        @doc "Capability required to increment ATS lock amounts: <unlocks>"
        true
    )
    ;;6.1.1.2][A]           <ATS|Ledger> Table Management
    (defcap ATS|UPDATE_LEDGER ()
        @doc "Cap required to update entries in the ATS|Ledger"
        true
    )
    (defcap ATS|DEPLOY (atspair:string account:string)
        (compose-capability (DALOS|EXIST account))
        (compose-capability (ATS|EXIST atspair))
        (compose-capability (ATS|NORMALIZE_LEDGER atspair account))
    )
    (defcap ATS|NORMALIZE_LEDGER (atspair:string account:string)
        @doc "Capability needed to normalize an ATS|Ledger Account \
        \ Normalizing an ATS|Ledger Account updates it it according to the <atspair> <c-positions> and <c-elite-mode> parameters \
        \ Existing entries are left as they are"
        (compose-capability (ATS|EXIST atspair))
        (enforce-one
            "Keyset not valid for normalizing ATS|Ledger Account Operations"
            [
                (enforce-guard (keyset-ref-guard OUROBOROS.DALOS|DEMIURGOI))
                (enforce-guard (OUROBOROS.DALOS|UR_AccountGuard account))
            ]
        )
    )
    (defcap ATS|HOT_RECOVERY (patron:string recoverer:string atspair:string ra:decimal)
        @doc "Capability required to execute hot recovery"
        (compose-capability (DALOS|ACCOUNT_OWNER recoverer))
        (compose-capability (ATS|EXIST atspair))
        (compose-capability (ATS|RECOVERY_STATE atspair true false))
    )
    (defcap ATS|COLD_RECOVERY (patron:string recoverer:string atspair:string ra:decimal)
        @doc "Capability required to execute cold recovery"
        (compose-capability (DALOS|ACCOUNT_OWNER recoverer))
        (compose-capability (ATS|EXIST atspair))
        (compose-capability (ATS|RECOVERY_STATE atspair true true))
        (compose-capability (ATS|DEPLOY atspair recoverer))
        (compose-capability (ATS|UPDATE_LEDGER))
        (compose-capability (ATS|UPDATE_ROU))
    )
    (defcap ATS|CULL (culler:string atspair:string)
        (compose-capability (DALOS|ACCOUNT_OWNER culler))    
        ;(compose-capability (DALOS|EXIST culler))
        (compose-capability (ATS|EXIST atspair))
        (compose-capability (ATS|UPDATE_ROU))
        (compose-capability (ATS|NORMALIZE_LEDGER atspair culler))
        (compose-capability (ATS|UPDATE_LEDGER))
    )
    ;;6.1.2]  [A]   ATS Composed Capabilities
    ;;6.1.2.1][A]           Control
    (defcap ATS|UPDATE_COLD (atspair:string)
        @doc "Req for updating Cold ATS Parameters"
        (compose-capability (ATS|PARAMETER-LOCK_STATE atspair false))
        (compose-capability (ATS|RECOVERY_STATE atspair false true))
    )
    (defcap ATS|UPDATE_HOT (atspair:string)
        @doc "Req for updating Hot ATS Parameters"
        (compose-capability (ATS|PARAMETER-LOCK_STATE atspair false))
        (compose-capability (ATS|RECOVERY_STATE atspair false false))
    )
    (defcap ATS|UPDATE (atspair:string)
        @doc "Req for updatin ATS Parameters"
        (compose-capability (ATS|PARAMETER-LOCK_STATE atspair false))
        (compose-capability (ATS|RECOVERY_STATE atspair false true))
        (compose-capability (ATS|RECOVERY_STATE atspair false false))
    )
    (defcap ATS|OWNERSHIP-CHANGE (patron:string atspair:string new-owner:string)
        @doc "Req to change ATS Ownership"
        (compose-capability (ATS|OWNERSHIP-CHANGE_CORE atspair new-owner))
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_BIGGEST))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|OWNERSHIP-CHANGE_CORE (atspair:string new-owner:string)
        @doc "Core Capability required for ATS-Pair Ownership"
        (OUROBOROS.DALOS|UV_SenderWithReceiver (ATS|UR_OwnerKonto atspair) new-owner)
        (compose-capability (ATS|OWNER atspair))
        (compose-capability (ATS|CAN-CHANGE-OWNER_ON atspair))
        (compose-capability (DALOS|EXIST new-owner))
    )
    (defcap ATS|TOGGLE_PARAMETER-LOCK (patron:string atspair:string toggle:bool)
        @doc "Capability required to EXECUTE <ATS|C_ToggleParameterLock> Function"
        (compose-capability (ATS|TOGGLE_PARAMETER-LOCK_CORE atspair toggle))
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
        (if (not toggle)
            (let*
                (
                    (atspair-owner:string (ATS|UR_OwnerKonto atspair))
                    (toggle-costs:[decimal] (UTILITY.ATS|UC_UnlockPrice (ATS|UR_Unlocks atspair)))
                    (gas-costs:decimal (at 0 toggle-costs))
                    (kda-costs:decimal (at 1 toggle-costs))
                )
                (compose-capability (GAS|DUAL-COLLECTER patron atspair-owner gas-costs kda-costs))
            )
            true
        )
    )
    (defcap ATS|TOGGLE_PARAMETER-LOCK_CORE (atspair:string toggle:bool)
        @doc "Core Capability required to set to <toggle> the <parameter-lock> for a ATS Pair"
        (compose-capability (ATS|OWNER atspair))
        (compose-capability (ATS|PARAMETER-LOCK_STATE atspair (not toggle)))
        (enforce-one
            (format "ATS <parameter-lock> cannot be toggled when both <cold-recovery> and <hot-recovery> are set to false")
            [
                (compose-capability (ATS|RECOVERY_STATE atspair true true))
                (compose-capability (ATS|RECOVERY_STATE atspair true false))
            ]
        )
    )
    (defcap ATS|TOGGLE_FEE (patron:string atspair:string toggle:bool fee-switch:integer)
        @doc "Req for updating <c-nfr>, <c-fr>, <h-fer>"
        (compose-capability (ATS|TOGGLE_FEE_CORE atspair toggle fee-switch))
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|TOGGLE_FEE_CORE (atspair:string toggle:bool fee-switch:integer)
        @doc "Core cap req for updating <c-nfr>, <c-fr>, <h-fer>"
        (enforce (contains fee-switch (enumerate 0 2)) "Integer not a valid fee-switch integer")
        (compose-capability (ATS|OWNER atspair))
        (compose-capability (ATS|FEE_STATE atspair (not toggle) fee-switch))
        (if (or (= fee-switch 0)(= fee-switch 1))
            (compose-capability (ATS|UPDATE_COLD atspair))
            (compose-capability (ATS|UPDATE_HOT atspair))
        )
    )
    (defcap ATS|SET_CRD (patron:string atspair:string soft-or-hard:bool base:integer growth:integer)
        @doc "Req for setting Cold Recovery Duration"
        (compose-capability (ATS|SET_CRD_CORE atspair soft-or-hard base growth))
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|SET_CRD_CORE (atspair:string soft-or-hard:bool base:integer growth:integer)
        @doc "Core cap req for setting Cold Recovery Duration"
        (compose-capability (ATS|OWNER atspair))
        (compose-capability (ATS|UPDATE_COLD atspair))
        (if (= soft-or-hard true)
            (enforce 
                (and 
                    (= (mod base growth) 0)
                    (= (mod growth 3) 0)
                ) 
                (format "{} as base and {} as growth are incompatible with the Soft Method for generation of CRD" [base growth])
            )
            (enforce 
                (= (mod base growth) 0)
                (format "{} as base and {} as growth are incompatible with the Hard Method for generation of CRD" [base growth])    
            )
        )
    )
    (defcap ATS|SET_COLD_FEE (patron:string atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        @doc "Req for setting Cold Recovery Fee"
        (compose-capability (ATS|SET_COLD_FEE_CORE atspair fee-positions fee-thresholds fee-array))
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|SET_COLD_FEE_CORE (atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        @doc "Core cap req for setting Cold Recovery Fee"
        (compose-capability (ATS|OWNER atspair))
        (compose-capability (ATS|UPDATE_COLD atspair))
        ;;<fee-positions> validation
        (enforce 
            (or 
                (= fee-positions -1)
                (contains fee-positions (enumerate 1 7))
            )
            "The Number of Fee Positions must be either -1 or between 1 and 7"
        )
        ;;<fee-threhsolds> validation (number)
        (enforce 
            (and
                (>= (length fee-thresholds) 1)
                (<= (length fee-thresholds) 100)
            )
            "No More than 100 Fee Threhsolds can be set"
        )
        ;;<fee-threhsold> validation (value as threshold)
        (fold
            (lambda
                (acc:bool idx:integer)
                (let*
                    (
                        (current:decimal (at idx fee-thresholds))
                        (precision:integer (DPTF-DPMF|UR_Decimals (ATS|UR_ColdRewardBearingToken atspair) true))
                    )
                    (if (<= idx (- (length fee-thresholds) 2))
                        (let
                            (
                                (next:decimal (at (+ idx 1) fee-thresholds))
                            )
                            (enforce 
                                (< current next)
                                (format "Current Amount {} must be smaller than the next Amount in the Threhsold List" [current next])
                            )
                        )
                        true
                    )
                    (enforce
                        (= (floor current precision) current)
                        (format "The Amount of {} does not conform with the CRBT decimals number" [current])
                    )
                    acc
                )
            )
            true
            (enumerate 0 (- (length fee-thresholds) 1))
        )
        ;;<fee-array> validation
        (if (= (ATS|UC_ZeroColdFeeExceptionBoolean fee-thresholds fee-array) true)
            (if (= fee-positions -1)
                (enforce (= (length fee-array) 1) "The input <fee-array> must be of length 1")
                (enforce (= (length fee-array) fee-positions) (format "The input <fee-array> must be of length {}" [fee-positions]))
            )
            true
        )
        ;;<fee-array> validation; inner lists - equal length
        (UTILITY.UV_DecimalArray fee-array)
        ;;<fee-array> validation: inner lists = (length <fee-threshold> +1)
        (if (= (ATS|UC_ZeroColdFeeExceptionBoolean fee-thresholds fee-array) true)
            (enforce
                (= (length (at 0 fee-array)) (+ (length fee-thresholds) 1))
                "Inner Lists of the <fee-array> are incompatible with the <fee-thresholds> length"
            )
            true
        )
        ;;<fee-array>: value validation
        (map
            (lambda 
                (inner-lst:[decimal])
                (map
                    (lambda 
                        (fee:decimal)
                        (DALOS|UV_Fee fee)
                    )
                    inner-lst
                )
            )
            fee-array
        )
    )
    (defcap ATS|SET_HOT_FEE (patron:string atspair:string promile:decimal decay:integer)
        @doc "Req for setting Hot Recovery Fee"
        (compose-capability (ATS|SET_HOT_FEE_CORE atspair promile decay))
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|SET_HOT_FEE_CORE (atspair:string promile:decimal decay:integer)
        @doc "Core cap req for setting Hot Recovery Fee"
        (compose-capability (ATS|OWNER atspair))
        (compose-capability (ATS|UPDATE_HOT atspair))
        (DALOS|UV_Fee promile)
        (enforce 
            (and
                (>= decay 1)
                (<= decay 9125)
            )
            "No More than 25 years (9125 days) can be set for Decay Period"
        )
    )
    (defcap ATS|TOGGLE_ELITE (patron:string atspair:string toggle:bool)
        @doc "Req for toggling Elite Mode for an ATS Pair"
        (compose-capability (ATS|TOGGLE_ELITE_CORE atspair toggle))
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|TOGGLE_ELITE_CORE (atspair:string toggle:bool)
        @doc "Core cap req for toggling Elite Mode for an ATS Pair"
        (compose-capability (ATS|OWNER atspair))
        (compose-capability (ATS|UPDATE_COLD atspair))
        (compose-capability (ATS|ELITE_STATE atspair (not toggle)))
        (if (= toggle true)
            (let
                (
                    (x:integer (ATS|UR_ColdRecoveryPositions atspair))
                )
                (enforce (= x 7) (format "Cold Recovery Positions for ATS Pair {} must be set to 7 for this operation" [atspair]))
            )
            true
        )
    )
    (defcap ATS|TOGGLE_RECOVERY (patron:string atspair:string toggle:bool cold-or-hot:bool)
        @doc "Cap req for toggling Recovery"
        (if (= toggle true)
            (compose-capability (ATS|RECOVERY-ON_CORE atspair cold-or-hot))
            (compose-capability (ATS|RECOVERY-OFF_CORE atspair cold-or-hot))
        )
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|RECOVERY-ON_CORE (atspair:string cold-or-hot:bool)
        @doc "Core cap req for turning on ATS Recovery"
        (compose-capability (ATS|OWNER atspair))
        (compose-capability (ATS|PARAMETER-LOCK_STATE atspair false))
        (compose-capability (ATS|RECOVERY_STATE atspair false cold-or-hot))
    )
        (defcap ATS|RECOVERY-OFF_CORE (atspair:string cold-or-hot:bool)
        @doc "Core cap req for turning off ATS Recovery"
        (compose-capability (ATS|OWNER atspair))
        (compose-capability (ATS|PARAMETER-LOCK_STATE atspair false))
        (compose-capability (ATS|RECOVERY_STATE atspair true cold-or-hot))
    )
    ;;6.1.2.2][A]           Create
    (defcap ATS|ISSUE (patron:string atspair:string issuer:string reward-token:string reward-bearing-token:string)
        @doc "Capability required to EXECUTE <ATS|C_IssueAutostakePair> Function"
        (compose-capability (ATS|ISSUE_CORE atspair issuer reward-token reward-bearing-token))
        (compose-capability (GAS|COLLECTION patron issuer UTILITY.GAS_HUGE))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|ISSUE_CORE (atspair:string issuer:string reward-token:string reward-bearing-token:string)
        @doc "Core Capability required to Issued a ATS Pair"
        (enforce (!= reward-token reward-bearing-token) "Reward Token must be different from Reward-Bearing Token")
        (compose-capability (DPTF-DPMF|OWNER reward-token true))
        (compose-capability (DPTF-DPMF|OWNER reward-bearing-token true))
        (compose-capability (DALOS|IZ_ACCOUNT_SMART issuer false))
        (compose-capability (DALOS|ACCOUNT_OWNER issuer))
        (compose-capability (ATS|UPDATE_RT))
        (compose-capability (ATS|UPDATE_RBT reward-bearing-token true))
        (compose-capability (ATS|RT_EXISTANCE atspair reward-token false))
        (compose-capability (ATS|RBT_EXISTANCE atspair reward-bearing-token false true))
    )
    (defcap ATS|ADD_SECONDARY (patron:string atspair:string reward-token:string token-type:bool)
        @doc "Capability required to EXECUTE <ATS|C_AddSecondary> Function"
        (compose-capability (ATS|ADD_SECONDARY_CORE atspair reward-token token-type))
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_ISSUE))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|ADD_SECONDARY_CORE (atspair:string reward-token:string token-type:bool)
        @doc "Core Capability required to add either a: Secondary Reward Token or a Hot-Reward-Bearing-Token \
        \ Token-type toggles variation: true is for DPTF, meaning Reward Token, False for DPMF meaning hot-rbt"
        (compose-capability (DPTF-DPMF|OWNER reward-token token-type))
        (compose-capability (ATS|OWNER atspair))
        (compose-capability (ATS|UPDATE atspair))
        (if (= token-type true)
            (compose-capability (ATS|ADD_SECONDARY_RT atspair reward-token))
            (compose-capability (ATS|ADD_SECONDARY_RBT atspair reward-token))
        )
    )
    (defcap ATS|ADD_SECONDARY_RT (atspair:string reward-token:string)
        @doc "Cap req for subsequent adding as secondary as RT"
        (ATS|UV_IzTokenUnique atspair reward-token)
        (compose-capability (ATS|RT_EXISTANCE atspair reward-token false))
        (compose-capability (ATS|UPDATE_RT))
    )
    (defcap ATS|ADD_SECONDARY_RBT (atspair:string hot-rbt:string)
        @doc "Cap req for subsequent adding as secondary as Hot-RBT"
        (compose-capability (ATS|HOT_RBT_PRESENCE atspair false))    
        (compose-capability (ATS|UPDATE_RBT hot-rbt false))
        (compose-capability (VST|EXISTANCE hot-rbt false false)) 
    )
    (defcap ATS|UPDATE_RBT (id:string token-type:bool)
        @doc "Capability to update the <reward-bearing-token> in the DPTF-DPMF|PropertiesTable"
        (if (= token-type false)
            (let
                (
                    (rbt:string (DPMF|UR_RewardBearingToken id))
                )
                (enforce (= rbt UTILITY.BAR) "RBT for a DPMF is immutable")
            )
            true
        )
    )
    (defcap ATS|UPDATE_ROU ()
        @doc "Capability to update Resident or Unbonding Amounts for any RT of any ATS-Pair"
        true
    )
    (defcap ATS|UPDATE_RT ()
        @doc "Capability to update <reward-token> in the DPTF|PropertiesTable"
        true
    )
    ;;6.1.2.3][A]           Destroy
    (defcap ATS|REMOVE_SECONDARY (patron:string atspair:string reward-token:string)
        @doc "Capability required to EXECUTE <ATS|C_AddSecondary> Function"
        (compose-capability (ATS|REMOVE_SECONDARY_CORE atspair reward-token))   
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_ISSUE))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|REMOVE_SECONDARY_CORE (atspair:string reward-token:string)
        @doc "Core Capability required to EXECUTE <ATS|C_AddSecondary> Function"
        (compose-capability (ATS|OWNER atspair))
        (compose-capability (ATS|UPDATE atspair))
        (compose-capability (ATS|RT_EXISTANCE atspair reward-token true))
        (compose-capability (ATS|UPDATE_RT))
    )
    ;;6.1.2.4][A]           Client Capabilities
    (defcap ATS|FUEL (patron:string fueler:string atspair:string reward-token:string amount:decimal)
        @doc "Req for <ATS|C_Fuel>"
        (let
            (
                (index:decimal (ATS|UC_Index atspair))
            )
            (enforce (>= index 1.0) "Fueling cannot take place on a negative Index")
            (compose-capability (ATS|RT_EXISTANCE atspair reward-token true))
            ;(compose-capability (DPTF-DPMF|TRANSFER patron reward-token fueler ATS|SC_NAME amount true true))
            (compose-capability (ATS|UPDATE_ROU))
        )
    )
    (defcap ATS|COIL (patron:string coiler:string atspair:string coil-token:string amount:decimal)
        @doc "Full Coil Capability"
        (compose-capability (ATS|COIL_NO-RETURN patron coiler atspair coil-token amount))
        ;(compose-capability (DPTF-DPMF|TRANSFER patron (ATS|UR_ColdRewardBearingToken atspair) ATS|SC_NAME coiler (ATS|UC_RBT atspair coil-token amount) true true))
    )
    (defcap ATS|COIL_NO-RETURN (patron:string coiler:string atspair:string coil-token:string amount:decimal)
        @doc "Partial Coil Capability"
        (compose-capability (ATS|RT_EXISTANCE atspair coil-token true))
        (compose-capability (ATS|UPDATE_ROU))
        ;(compose-capability (DPTF-DPMF|TRANSFER patron coil-token coiler ATS|SC_NAME amount true true))
        ;(compose-capability (DPTF|MINT patron (ATS|UR_ColdRewardBearingToken atspair) ATS|SC_NAME (ATS|UC_RBT atspair coil-token amount) false true))
    )
    (defcap ATS|CURL (patron:string curler:string atspair1:string atspair2:string rt:string amount:decimal)
        @doc "Full Curl Capability"
        (let*
            (
                (c-rbt1:string (ATS|UR_ColdRewardBearingToken atspair1))
                (c-rbt1-amount:decimal (ATS|UC_RBT atspair1 rt amount))
                (c-rbt2:string (ATS|UR_ColdRewardBearingToken atspair2))
                (c-rbt2-amount:decimal (ATS|UC_RBT atspair2 c-rbt1 c-rbt1-amount))
            )
            (compose-capability (ATS|COIL_NO-RETURN patron curler atspair1 rt amount))
            ;(compose-capability (DPTF|MINT patron c-rbt2 ATS|SC_NAME c-rbt2-amount false true))
            ;(compose-capability (DPTF-DPMF|TRANSFER patron c-rbt2 ATS|SC_NAME curler c-rbt2-amount true true))
        )
    )
    ;;========[A] FUNCTIONS====================================================;;
    ;;6.2]    [A] ATS Functions
    ;;6.2.1]  [A]   ATS Utility Functions
    ;;6.2.1.1][A]           ATS|Pairs Info
    (defun ATS|UR_OwnerKonto:string (atspair:string)
        @doc "Gets <owner-konto>"
        (at "owner-konto" (read ATS|Pairs atspair ["owner-konto"]))
    )
    (defun ATS|UR_CanChangeOwner:bool (atspair:string)
        @doc "Gets <can-change-owner-lock>"
        (at "can-change-owner" (read ATS|Pairs atspair ["can-change-owner"]))
    )
    (defun ATS|UR_Lock:bool (atspair:string)
        @doc "Gets <parameter-lock>"
        (at "parameter-lock" (read ATS|Pairs atspair ["parameter-lock"]))
    )
    (defun ATS|UR_Unlocks:integer (atspair:string)
        @doc "Gets <unlocks>"
        (at "unlocks" (read ATS|Pairs atspair ["unlocks"]))
    )
    (defun ATS|UR_IndexName:string (atspair:string)
        @doc "Gets <pair-index-name>"
        (at "pair-index-name" (read ATS|Pairs atspair ["pair-index-name"]))
    )
    (defun ATS|UR_IndexDecimals:integer (atspair:string)
        @doc "Gets <index-decimals>"
        (at "index-decimals" (read ATS|Pairs atspair ["index-decimals"]))
    )
    (defun ATS|UR_RewardTokens:[object{ATS|RewardTokenSchema}] (atspair:string)
        @doc "Gets <reward-tokens>"
        (at "reward-tokens" (read ATS|Pairs atspair ["reward-tokens"]))
    )
    (defun ATS|UR_ColdRewardBearingToken:string (atspair:string)
        @doc "Gets <c-rbt>"
        (at "c-rbt" (read ATS|Pairs atspair ["c-rbt"]))
    )
    (defun ATS|UR_ColdNativeFeeRedirection:bool (atspair:string)
        @doc "Gets <c-nfr>"
        (at "c-nfr" (read ATS|Pairs atspair ["c-nfr"]))
    )
    (defun ATS|UR_ColdRecoveryPositions:integer (atspair:string)
        @doc "Gets <c-positions>"
        (at "c-positions" (read ATS|Pairs atspair ["c-positions"]))
    )
    (defun ATS|UR_ColdRecoveryFeeThresholds:[decimal] (atspair:string)
        @doc "Gets <c-limits>"
        (at "c-limits" (read ATS|Pairs atspair ["c-limits"]))
    )
    (defun ATS|UR_ColdRecoveryFeeTable:[[decimal]] (atspair:string)
        @doc "Gets <c-array>"
        (at "c-array" (read ATS|Pairs atspair ["c-array"]))
    )
    (defun ATS|UR_ColdRecoveryFeeRedirection:bool (atspair:string)
        @doc "Gets <c-fr>"
        (at "c-fr" (read ATS|Pairs atspair ["c-fr"]))
    )
    (defun ATS|UR_ColdRecoveryDuration:[integer] (atspair:string)
        @doc "Gets <c-duration>"
        (at "c-duration" (read ATS|Pairs atspair ["c-duration"]))
    )
    (defun ATS|UR_EliteMode:bool (atspair:string)
        @doc "Gets <c-elite-mode>"
        (at "c-elite-mode" (read ATS|Pairs atspair ["c-elite-mode"]))
    )
    (defun ATS|UR_HotRewardBearingToken:string (atspair:string)
        @doc "Gets <h-rbt>"
        (at "h-rbt" (read ATS|Pairs atspair ["h-rbt"]))
    )
    (defun ATS|UR_HotRecoveryStartingFeePromile:integer (atspair:string)
        @doc "Gets <h-promile>"
        (at "h-promile" (read ATS|Pairs atspair ["h-promile"]))
    )
    (defun ATS|UR_HotRecoveryDecayPeriod:integer (atspair:string)
        @doc "Gets <h-decay>"
        (at "h-decay" (read ATS|Pairs atspair ["h-decay"]))
    )
    (defun ATS|UR_HotRecoveryFeeRedirection:bool (atspair:string)
        @doc "Gets <h-fr>"
        (at "h-fr" (read ATS|Pairs atspair ["h-fr"]))
    )
    (defun ATS|UR_ToggleColdRecovery:bool (atspair:string)
        @doc "Gets <cold-recovery>"
        (at "cold-recovery" (read ATS|Pairs atspair ["cold-recovery"]))
    )
    (defun ATS|UR_ToggleHotRecovery:bool (atspair:string)
        @doc "Gets <hot-recovery>"
        (at "hot-recovery" (read ATS|Pairs atspair ["hot-recovery"]))
    )
    (defun ATS|UR_RewardTokenList:[string] (atspair:string)
        @doc "Returns the list of Reward Tokens for an ATS Pair."
        (fold
            (lambda
                (acc:[string] item:object{ATS|RewardTokenSchema})
                (UTILITY.UC_AppendLast acc (at "token" item))
            )
            []
            (ATS|UR_RewardTokens atspair)
        )
    )
    (defun ATS|UR_RoUAmountList:[decimal] (atspair:string rou:bool)
        @doc "Returns the list of Reward Tokens Resident Amounts for an ATS Pair."
        (fold
            (lambda
                (acc:[decimal] item:object{ATS|RewardTokenSchema})
                (if rou
                    (UTILITY.UC_AppendLast acc (at "resident" item))
                    (UTILITY.UC_AppendLast acc (at "unbonding" item))
                )
            )
            []
            (ATS|UR_RewardTokens atspair)
        )
    )
    (defun ATS|UR_RT-Data (atspair:string reward-token:string data:integer)
        @doc "Returns RT Data for a given <reward-token> of a given <atspair>"
        (ATS|UVE_id atspair)
        (UTILITY.DALOS|UV_PositionalVariable data 3 "Invalid Data Integer")
        (let*
            (
                (rt:[object{ATS|RewardTokenSchema}] (ATS|UR_RewardTokens atspair))
                (rtp:integer (ATS|UC_RewardTokenPosition atspair reward-token))
                (rto:object{ATS|RewardTokenSchema} (at rtp rt))
            )
            (cond
                ((= data 1) (at "nfr" rto))
                ((= data 2) (at "resident" rto))
                ((= data 3) (at "unbonding" rto))
                true
            )
        )
    )
    ;;6.2.1.2][A]           ATS|Ledger Info
    (defun ATS|UP_P0 (atspair:string account:string)
        (format "{}|{} P0: {}" [atspair account (ATS|UR_P0 atspair account)])
    )
    (defun ATS|UP_P1 (atspair:string account:string)
        (format "{}|{} P1: {}" [atspair account (ATS|UR_P1-7 atspair account 1)])
    )
    (defun ATS|UP_P2 (atspair:string account:string)
        (format "{}|{} P2: {}" [atspair account (ATS|UR_P1-7 atspair account 2)])
    )
    (defun ATS|UP_P3 (atspair:string account:string)
        (format "{}|{} P3: {}" [atspair account (ATS|UR_P1-7 atspair account 3)])
    )
    (defun ATS|UP_P4 (atspair:string account:string)
        (format "{}|{} P4: {}" [atspair account (ATS|UR_P1-7 atspair account 4)])
    )
    (defun ATS|UP_P5 (atspair:string account:string)
        (format "{}|{} P5: {}" [atspair account (ATS|UR_P1-7 atspair account 5)])
    )
    (defun ATS|UP_P6 (atspair:string account:string)
        (format "{}|{} P6: {}" [atspair account (ATS|UR_P1-7 atspair account 6)])
    )
    (defun ATS|UP_P7 (atspair:string account:string)
        (format "{}|{} P7: {}" [atspair account (ATS|UR_P1-7 atspair account 7)])
    )
    (defun ATS|UR_P0:[object{ATS|Unstake}] (atspair:string account:string)
        @doc "Returns the <P0> of an ATS-UnstakingAccount"
        (UTILITY.DALOS|UV_UniqueAccount atspair)
        (UTILITY.DALOS|UV_Account account)
        (at "P0" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P0"]))
    )
    (defun ATS|UC_IzCullable:bool (input:object{ATS|Unstake})
        @doc "Computes if Unstake Object is cullable"
        (let*
            (
                (present-time:time (at "block-time" (chain-data)))
                (stored-time:time (at "cull-time" input))
                (diff:decimal (diff-time present-time stored-time))
            )
            (if (>= diff 0.0)
                true
                false
            )
        )
    )
    (defun ATS|UC_CullValue:[decimal] (input:object{ATS|Unstake})
        @doc "Returns the value of a cull object."
        (let*
            (
                (rt-amounts:[decimal] (at "reward-tokens" input))
                (l:integer (length rt-amounts))
                (iz:bool (ATS|UC_IzCullable input))
            )
            (if iz
                rt-amounts
                (make-list l 0.0)
            )
        )
    )
    (defun ATS|UR_P1-7:object{ATS|Unstake} (atspair:string account:string position:integer)
        @doc "Returns the <P1> through <P7> of an ATS-UnstakingAccount"
        (UTILITY.DALOS|UV_UniqueAccount atspair)
        (UTILITY.DALOS|UV_Account account)
        (UTILITY.DALOS|UV_PositionalVariable position 7 "Invalid Position Number")
        (cond
            ((= position 1) (at "P1" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P1"])))
            ((= position 2) (at "P2" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P2"])))
            ((= position 3) (at "P3" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P3"])))
            ((= position 4) (at "P4" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P4"])))
            ((= position 5) (at "P5" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P5"])))
            ((= position 6) (at "P6" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P6"])))
            ((= position 7) (at "P7" (read ATS|Ledger (concat [atspair UTILITY.BAR account]) ["P7"])))
            true
        )
    )
    (defun ATS|URX_UnstakeObjectUnbondingValue (atspair:string reward-token:string io:object{ATS|Unstake})
        @doc "Special Helper Function needed for <ATS|UC_AccountUnbondingBalance>"
        (let*
            (
                (rtp:integer (ATS|UC_RewardTokenPosition atspair reward-token))
                (rt:[decimal] (at "reward-tokens" io))
                (rb:decimal (at rtp rt))
            )
            (if (= rb -1.0)
                0.0
                rb
            )
        )
    )
    (defun ATS|UC_AccountUnbondingBalance (atspair:string account:string reward-token:string)
        @doc "Returns by computation the Total Unbonding value tied to an ATS-UnstakeAccount (defined with <atspair> and <account>) \
            \ for a given Reward-Token (which is a Reward-Token of the given <atspair>)"
        (+
            (fold
                (lambda
                    (acc:decimal item:object{ATS|Unstake})
                    (+ acc (ATS|URX_UnstakeObjectUnbondingValue atspair reward-token item))
                )
                0.0
                (ATS|UR_P0 atspair account)
            )
            (fold
                (lambda
                    (acc:decimal item:integer)
                    (+ acc (ATS|URX_UnstakeObjectUnbondingValue atspair reward-token (ATS|UR_P1-7 atspair account item)))
                )
                0.0
                (enumerate 1 7)
            )
        )
    )
    (defun ATS|UR_RtPrecisions:[integer] (atspair:string)
        @doc "Returns a list of integers representing precisions of RBT Tokens of <atspair>"
        (fold
            (lambda
                (acc:[integer] rt:string)
                (UTILITY.UC_AppendLast acc (DPTF-DPMF|UR_Decimals rt true))
            )
            []
            (ATS|UR_RewardTokenList atspair)
        )
    )
    ;;6.2.1.3][A]           ATS|Ledger Computing
    (defun ATS|UC_RT-Unbonding (atspair:string reward-token:string)
        @doc "Computes the Total Unbonding amount for a given <reward-token> of a given <atspair> \
        \ Result-wise identical to reading it via <OUROBOROS.ATS|UR_RT-Data> option 3, except this is done by computation"
        (with-capability (ATS|RT_EXISTANCE atspair reward-token true)
            (fold
                (lambda
                    (acc:decimal account:string)
                    (+ acc (ATS|UC_AccountUnbondingBalance atspair account reward-token))
                )
                0.0
                (DPTF-DPMF-ATS|UR_FilterKeysForInfo atspair 3 false)
            )
        )
    )
    (defun ATS|UC_WhichPosition:integer (atspair:string c-rbt-amount:decimal account:string)
        @doc "Computes which position can be used for Cold Recovery, given input parameters. \
        \ Returning 0 means no position is available for cold recovery"
        (let
            (
                (elite:bool (ATS|UR_EliteMode atspair))
            )
            (if elite
                (ATS|UC_ElitePosition atspair c-rbt-amount account)
                (ATS|UC_NonElitePosition atspair account)
            )
        )
    )
    (defun ATS|UC_ElitePosition:integer (atspair:string c-rbt-amount:decimal account:string)
        @doc "Computes which position can be used for cold recovery when <c-elite-mode> is true"
        (let
            (
                (positions:integer (ATS|UR_ColdRecoveryPositions atspair))
                (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                (ea-id:string (DALOS|UR_EliteAurynID))
            )
            (if (!= ea-id UTILITY.BAR)
                ;elite auryn is defind
                (let*
                    (
                        (iz-ea-id:bool (if (= ea-id c-rbt) true false))
                        (pstate:[integer] (ATS|UC_PSL atspair account))
                        (met:integer (DALOS|UR_Elite-Tier-Major account))
                        (ea-supply:decimal (DPTF-DPMF|UR_AccountSupply ea-id account true))
                        (t-ea-supply:decimal (DALOS|UR_EliteAurynzSupply account))
                        (virtual-met:integer (str-to-int (take 1 (at "tier" (UTILITY.ATS|UC_Elite (- t-ea-supply c-rbt-amount))))))
                        (available:[integer] (if iz-ea-id (take virtual-met pstate) (take met pstate)))
                        (search-res:[integer] (UTILITY.UC_Search available 1))
                    )
                    (if iz-ea-id
                        (enforce (<= c-rbt-amount ea-supply) "Amount of EA used for Cold Recovery cannot be greater than what exists on Account")
                        true
                    )
                    (if (= (length search-res) 0)
                        0
                        (+ (at 0 search-res) 1)
                    )
                )
                ;elite-auryn is not defined
                (ATS|UC_NonElitePosition atspair account)
            )
        )
    )
    (defun ATS|UC_NonElitePosition:integer (atspair:string account:string)
        @doc "Computes which position can be used for cold recovery when <c-elite-mode> is false"
        (let
            (
                (positions:integer (ATS|UR_ColdRecoveryPositions atspair))
            )
            (if (= positions -1)
                -1
                (let*
                    (
                        (pstate:[integer] (ATS|UC_PSL atspair account))
                        (available:[integer] (take positions pstate))
                        (search-res:[integer] (UTILITY.UC_Search available 1))
                    )
                    (if (= (length search-res) 0)
                        0
                        (+ (at 0 search-res) 1)
                    )
                )
            )
        )
    )
    (defun ATS|UC_PSL:[integer] (atspair:string account:string)
        @doc "Creates a list of position states"
        (let
            (
                (p1s:integer (ATS|UC_PositionState atspair account 1))
                (p2s:integer (ATS|UC_PositionState atspair account 2))
                (p3s:integer (ATS|UC_PositionState atspair account 3))
                (p4s:integer (ATS|UC_PositionState atspair account 4))
                (p5s:integer (ATS|UC_PositionState atspair account 5))
                (p6s:integer (ATS|UC_PositionState atspair account 6))
                (p7s:integer (ATS|UC_PositionState atspair account 7))
            )
            [p1s p2s p3s p4s p5s p6s p7s]
        )
    )
    (defun ATS|UC_PositionState:integer (atspair:string account:string position:integer)
        @doc "Computes position state"
        (UTILITY.DALOS|UV_PositionalVariable position 7 "Input Position out of bounds")
        (with-read ATS|Ledger (concat [atspair UTILITY.BAR account])
            { "P1"  := p1 , "P2"  := p2 , "P3"  := p3, "P4"  := p4, "P5"  := p5, "P6"  := p6, "P7"  := p7 }
            (let
                (
                    (ps1:integer (ATS|UC_PositionalObjectState atspair p1))
                    (ps2:integer (ATS|UC_PositionalObjectState atspair p2))
                    (ps3:integer (ATS|UC_PositionalObjectState atspair p3))
                    (ps4:integer (ATS|UC_PositionalObjectState atspair p4))
                    (ps5:integer (ATS|UC_PositionalObjectState atspair p5))
                    (ps6:integer (ATS|UC_PositionalObjectState atspair p6))
                    (ps7:integer (ATS|UC_PositionalObjectState atspair p7))
                )
                (cond
                    ((= position 1) ps1)
                    ((= position 2) ps2)
                    ((= position 3) ps3)
                    ((= position 4) ps4)
                    ((= position 5) ps5)
                    ((= position 6) ps6)
                    ps7
                )
            )
        )
    )
    (defun ATS|UC_PositionalObjectState:integer (atspair:string input-obj:object{ATS|Unstake})
        @doc "Checks cold recovery position object state: \
        \ occupied(0), opened(1), closed (-1)"
        (let
            (
                (zero:object{ATS|Unstake} (ATS|UC_MakeZeroUnstakeObject atspair))
                (negative:object{ATS|Unstake} (ATS|UC_MakeNegativeUnstakeObject atspair))
            )
            (if (= input-obj zero)
                1
                (if (= input-obj negative)
                    -1
                    0
                )
            )
        )
    )
    (defun ATS|UC_ColdRecoveryFee (atspair:string c-rbt-amount:decimal input-position:integer)
        @doc "Computes the Cold Recovery fee of an <atspair>, given an input <c-rbt-amount> of Cold-Reward-Bearing-Token \
        \ and an input position <input-position> on which the cold recovery takes place."
        (let*
            (
                (ats-positions:integer (ATS|UR_ColdRecoveryPositions atspair))
                (ats-limit-values:[decimal] (ATS|UR_ColdRecoveryFeeThresholds atspair))
                (ats-limits:integer (length ats-limit-values))
                (ats-fee-array:[[decimal]] (ATS|UR_ColdRecoveryFeeTable atspair))
                (ats-fee-array-length:integer (length ats-fee-array))
                (ats-fee-array-length-length:integer (length (at 0 ats-fee-array)))
                (zc1:bool (if (= ats-limits 1) true false))
                (zc2:bool (if (= (at 0 ats-limit-values) 0.0) true false))
                (zc3:bool (and zc1 zc2))
                (zc4:bool (if (= ats-fee-array-length 1) true false))
                (zc5:bool (if (= ats-fee-array-length-length 1) true false))
                (zc6:bool (and zc4 zc5))
                (zc7:bool (if (= (at 0 (at 0 ats-fee-array)) 0.0) true false))
                (zc8:bool (and zc6 zc7))
                (zc9:bool (and zc3 zc8))
            )
            (enforce (<= input-position ats-positions) "Input position out of bounds")
            (if zc9
                0.0
                (let
                    (
                        (limit:integer
                            (fold
                                (lambda
                                    (acc:integer tv:decimal)
                                    (if (< c-rbt-amount tv)
                                        acc
                                        (+ acc 1)
                                    )
                                )
                                0
                                ats-limit-values
                            )
                        )
                        (qlst:[decimal] 
                            (if (= input-position -1)
                                (at 0 ats-fee-array)
                                (at (- input-position 1) ats-fee-array)
                            )
                        )
                    )
                    (at limit qlst)
                )
            )
        )
    )
    (defun ATS|UC_CullColdRecoveryTime:time (atspair:string account:string)
        @doc "Computes the Cull Time for the <atspair> and <account> \
        \ The Cull Time is the unavoidable time that must elapse in order to complete a Cold Recovery in any ATS-Pair \
        \ The Cull Time depends on ATS-Pair parameters, and DALOS Elite Account Tier"
        (let*
            (
                (minor:integer (DALOS|UR_Elite-Tier-Minor account))
                (major:integer (DALOS|UR_Elite-Tier-Major account))
                (mtier:integer (* minor major))
                (crd:[integer] (ATS|UR_ColdRecoveryDuration atspair))
                (h:integer (at mtier crd))
                (present-time:time (at "block-time" (chain-data)))
            )
            (add-time present-time (hours h))
        )
    )
    (defun ATS|UC_RTSplitAmounts:[decimal] (atspair:string rbt-amount:decimal)
        @doc "Splits a RBT value, the <rbt-amount>, using following inputs: \
            \ Reward-Bearing-Token supply <rbt-supply> of an <atspair> (read below) \
            \ The <index> of the <atspair> (read below) \
            \ A list <resident-amounts> respresenting amounts of resident Reward-Tokens of the <atpsair> \
            \ A list <rt-precision-lst> representing the precision of these Reward-Tokens \
            \ \
            \ Resulting a decimal list of Reward-Token Values coresponding to the input <rbt-amount> \
            \ The Actual computation takes place in the UTILITY Module in the <UC_SplitByIndexedRBT> Function"
        (let
            (
                (rbt-supply:decimal (ATS|UC_PairRBTSupply atspair))
                (index:decimal (ATS|UC_Index atspair))
                (resident-amounts:[decimal] (ATS|UR_RoUAmountList atspair true))
                (rt-precision-lst:[integer] (ATS|UR_RtPrecisions atspair))
            )
            (enforce (<= rbt-amount rbt-supply) "Cannot compute for amounts greater than the pairs rbt supply")
            (UTILITY.UC_SplitByIndexedRBT rbt-amount rbt-supply index resident-amounts rt-precision-lst)
        )
    )
    ;;6.2.1.4][A]           ATS|Ledger Composing
    (defun ATS|UC_MakeUnstakeObject:object{ATS|Unstake} (atspair:string time:time)
        @doc "Creates an unstake object"
        { "reward-tokens"   : (make-list (length (ATS|UR_RewardTokenList atspair)) 0.0)
        , "cull-time"       : time}
    )
    (defun ATS|UC_MakeZeroUnstakeObject:object{ATS|Unstake} (atspair:string)
        @doc "Generates an Empty Unstake Object. Empty means position is opened for use"
        (ATS|UC_MakeUnstakeObject atspair NULLTIME)
    )
    (defun ATS|UC_MakeNegativeUnstakeObject:object{ATS|Unstake} (atspair:string)
        @doc "Generates a Nmpty Unstake Object. Negative means position is closed and cannot be used for unstaking"
        (ATS|UC_MakeUnstakeObject atspair ANTITIME)
    )
    ;;6.2.1.5][A]           Computing|Composing
    (defun ATS|UC_Index (atspair:string)
        @doc "Returns the ATS-Pair Index Value"
        (let
            (
                (p:integer (ATS|UR_IndexDecimals atspair))
                (rs:decimal (ATS|UC_ResidentSum atspair))
                (rbt-supply:decimal (ATS|UC_PairRBTSupply atspair))
            )
            (if
                (= rbt-supply 0.0)
                -1.0
                (floor (/ rs rbt-supply) p)
            )
        )
    )
    (defun ATS|UC_PairRBTSupply:decimal (atspair:string)
        (let*
            (
                (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                (c-rbt-supply:decimal (DPTF-DPMF|UR_Supply c-rbt true))
            )
            (if (= (ATS|UC_IzPresentHotRBT atspair) false)
                c-rbt-supply
                (let*
                    (
                        (h-rbt:string (ATS|UR_HotRewardBearingToken atspair))
                        (h-rbt-supply:decimal (DPTF-DPMF|UR_Supply h-rbt false))
                    )
                    (+ c-rbt-supply h-rbt-supply)
                )
            )
        )
    )
    (defun ATS|UC_RBT:decimal (atspair:string rt:string rt-amount:decimal)
        @doc "Computes the RBT amount that can be created from an input rt-amount which is part of an ATS-Pair"
        (let*
            (
                (index:decimal (abs (ATS|UC_Index atspair)))
                (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                (p-rbt:integer (DPTF-DPMF|UR_Decimals c-rbt true))
            )
            ;;Ensures the input rt-amount is a number with at most the maximum decimals the c-rbt token has
            (enforce
                (= (floor rt-amount p-rbt) rt-amount)
                (format "The entered amount of {} must have at most, the precision c-rbt token {} which is {}" [rt-amount c-rbt p-rbt])
            )
            (floor (/ rt-amount index) p-rbt)
        )
    )
    (defun ATS|UC_ResidentSum:decimal (atspair:string)
        @doc "Returns the sum of all Resident Reward-Token Amounts for the ATS-Pair"
        (fold (+) 0.0 (ATS|UR_RoUAmountList atspair true)) 
    )
    
    (defun ATS|UC_ComposePrimaryRewardToken:object{ATS|RewardTokenSchema} (token:string nfr:bool)
        @doc "Composes a brand-new Reward Token object from input parameters"
        (ATS|UC_RT token nfr 0.0 0.0)
    )
    (defun ATS|UC_RT:object{ATS|RewardTokenSchema} (token:string nfr:bool r:decimal u:decimal)
        @doc "Composes a Reward Token object from input parameters"
        (enforce (>= r 0.0) "Negative Resident not allowed")
        (enforce (>= u 0.0) "Negative Unbonding not allowed")
        {"token"                    : token
        ,"nfr"                      : nfr
        ,"resident"                 : r
        ,"unbonding"                : u}
    )
    (defun ATS|UC_IzRT-Absolute:bool (reward-token:string)
        @doc "Checks if a DPTF Token is specified as Reward Token in any ATS Pair"
        (DPTF-DPMF|UVE_id reward-token true)
        (if (= (DPTF|UR_RewardToken reward-token) [UTILITY.BAR])
            false
            true
        )
    )
    (defun ATS|UC_IzRT:bool (atspair:string reward-token:string)
        @doc "Checks if a DPTF Token is specified as Reward-Token in a given ATS Pair"
        (DPTF-DPMF|UVE_id reward-token true)
        (if (= (DPTF|UR_RewardToken reward-token) [UTILITY.BAR])
            false
            (if (= (contains atspair (DPTF|UR_RewardToken reward-token)) true)
                true
                false
            )
        )
    )
    (defun ATS|UC_IzRBT-Absolute:bool (reward-bearing-token:string cold-or-hot:bool)
        @doc "Checks if a DPTF|DPMF Tokens is registered as Reward-Bearing-Token in any ATS Pair"
        (DPTF-DPMF|UVE_id reward-bearing-token cold-or-hot)
        (if (= cold-or-hot true)
            (if (= (DPTF|UR_RewardBearingToken reward-bearing-token) [UTILITY.BAR])
                false
                true
            )
            (if (= (DPMF|UR_RewardBearingToken reward-bearing-token) UTILITY.BAR)
                false
                true
            )
        )
    )
    (defun ATS|UC_IzRBT:bool (atspair:string reward-bearing-token:string cold-or-hot:bool)
        @doc "Checks if a DPTF|DPMF Token is registered as Reward-Bearing-Token in a given ATS Pair"
        (DPTF-DPMF|UVE_id reward-bearing-token cold-or-hot)
        (if (= cold-or-hot true)
            (if (= (DPTF|UR_RewardBearingToken reward-bearing-token) [UTILITY.BAR])
                false
                (if (= (contains atspair (DPTF|UR_RewardBearingToken reward-bearing-token)) true)
                    true
                    false
                )
            )
            (if (= (DPMF|UR_RewardBearingToken reward-bearing-token) UTILITY.BAR)
                false
                (if (= (DPMF|UR_RewardBearingToken reward-bearing-token) atspair)
                    true
                    false
                )
            )
        )
    )
    (defun ATS|UC_IzPresentHotRBT:bool (atspair:string)
        @doc "Checks if an ATS Pair has registered a Hot-RBT"
        (if (= (ATS|UR_HotRewardBearingToken atspair) UTILITY.BAR)
            false
            true
        )
    )
    (defun ATS|UC_RewardTokenPosition:integer (atspair:string reward-token:string)
        @doc "Returns the <reward-token> position when its part of an <atspair>"
        (let
            (
                (existance-check:bool (ATS|UC_IzRT atspair reward-token))
            )
            (enforce (= existance-check true) (format "{} Existance isnt verified for Token {} as RT with ATS Pair {}" [true reward-token atspair]))
            (at 0 (UTILITY.UC_Search (ATS|UR_RewardTokenList atspair) reward-token))
        )
    )
    (defun ATS|UC_ZeroColdFeeExceptionBoolean:bool (fee-thresholds:[decimal] fee-array:[[decimal]])
        @doc "Computes a Boolean representing the Zero Fee Exceptions for Cold ATS Fees."
        (not 
            (UTILITY.TripleAnd
                (= (length fee-thresholds) 1)
                (= (at 0 fee-thresholds) 0.0)
                (UTILITY.TripleAnd
                    (= (length fee-array) 1)
                    (= (length (at 0 fee-array)) 1)
                    (= (at 0 (at 0 fee-array)) 0.0)
                )
            )
        )
    )
    ;;6.2.1.6][A]           CPF Computers
    (defun ATS|CPF_RT-RBT:[decimal] (id:string native-fee-amount:decimal)
        @doc "Used in the CPF - Credit Primary Fee, within <DPTF|X_Transfer> function \
            \ Computes how much of the Primarly Fee is used for strenghtening which ATS Index \
            \ when a token is both RT and RBT for an ATS Pair. \
            \ Returns 3 values: \
            \       [0] <still> amount which must still be used as native transfer fee; \
            \       [1] <credit> amount to be credited to ATS|SC_NAME to strengthen ATS Pair Index\
            \       [2] <burn> amount which has to be burned to strengthen ATS Pair Index"
        (let*
            (
                (rt-ats-pairs:[string] (DPTF|UR_RewardToken id))
                (rbt-ats-pairs:[string] (DPTF|UR_RewardBearingToken id))
                (length-rt:integer (length rt-ats-pairs))
                (length-rbt:integer (length rbt-ats-pairs))
                (rt-boolean:[bool] (ATS|NFR-Boolean_RT-RBT id rt-ats-pairs true))
                (rbt-boolean:[bool] (ATS|NFR-Boolean_RT-RBT id rbt-ats-pairs false))
                (rt-milestones:integer (length (UTILITY.UC_Search rt-boolean true)))
                (rbt-milestones:integer (length (UTILITY.UC_Search rbt-boolean true)))
                (milestones:integer (+ rt-milestones rbt-milestones))
            )
            (if (!= milestones 0)
                (let*
                    (
                        (truths:[bool] (+ rt-boolean rbt-boolean))
                        (split-with-truths:[decimal] (ATS|UC_BooleanDecimalCombiner id native-fee-amount milestones truths))
                    )
                    (if (!= rt-milestones 0)
                        (let
                            (
                                (credit-sum:decimal
                                    (fold
                                        (lambda
                                            (acc:decimal index:integer)
                                            (if (at index rt-boolean)
                                                (with-capability (COMPOSE)
                                                    (ATS|X_UpdateRoU (at index rt-ats-pairs) id true true (at index split-with-truths))
                                                    (+ acc (at index split-with-truths))
                                                )
                                                acc
                                            )
                                        )
                                        0.0
                                        (enumerate 0 (- (length rt-ats-pairs) 1))
                                    )
                                )
                            )
                            (if (= credit-sum 0.0)
                                [0.0 0.0 native-fee-amount]
                                [0.0 credit-sum (- native-fee-amount credit-sum)]
                            )
                        )
                        [0.0 0.0 native-fee-amount]
                    )
                )
                [native-fee-amount 0.0 0.0]
            )
        )
    )
    (defun ATS|CPF_RBT:decimal (id:string native-fee-amount:decimal)
        @doc "Used in the CPF - Credit Primary Fee, within <DPTF|X_Transfer> function \
            \ Computes the <still> amount of Primary Fee when a token is only a RBT token as part of ATS Pairs \
            \ The remaining amount is the <burn> amount."
        (let*
            (
                (ats-pairs:[string] (DPTF|UR_RewardBearingToken id))
                (ats-pairs-bool:[bool] (ATS|NFR-Boolean_RT-RBT id ats-pairs false))
                (milestones:integer (length (UTILITY.UC_Search ats-pairs-bool true)))
            )
            (if (!= milestones 0)
                0.0
                native-fee-amount
            )
        )
    )
    (defun ATS|CPF_RT:decimal (id:string native-fee-amount:decimal)
        @doc "Used in the CPF - Credit Primary Fee, within <DPTF|X_Transfer> function \
            \ Computes the <still> amount of Primary Fee when a token is only a RT token as part of ATS Pairs \
            \ The remaining amount is the <credit> amount."
        (let*
            (
                (ats-pairs:[string] (DPTF|UR_RewardToken id))
                (ats-pairs-bool:[bool] (ATS|NFR-Boolean_RT-RBT id ats-pairs true))
                (milestones:integer (length (UTILITY.UC_Search ats-pairs-bool true)))  
            )
            (if (!= milestones 0)
                (let*
                    (
                        (rt-split-with-boolean:[decimal] (ATS|UC_BooleanDecimalCombiner id native-fee-amount milestones ats-pairs-bool))
                        (number-of-zeroes:integer (length (UTILITY.UC_Search rt-split-with-boolean 0.0)))
                    )
                    (map
                        (lambda
                            (index:integer)
                            (if (at index ats-pairs-bool)
                                (ATS|X_UpdateRoU (at index ats-pairs) id true true (at index rt-split-with-boolean))
                                true
                            )
                        )
                        (enumerate 0 (- (length ats-pairs) 1))
                    )
                    0.0
                )
                native-fee-amount
            )
        )
    )
    (defun ATS|NFR-Boolean_RT-RBT:[bool] (id:string ats-pairs:[string] rt-or-rbt:bool)
        @doc "Helper function used in the ATS|CPF Functions \
        \ Makes a [bool] using RT or RBT <nfr> values from a list of ATS Pair"
        (fold
            (lambda
                (acc:[bool] index:integer)
                (if rt-or-rbt
                    (if (ATS|UR_RT-Data (at index ats-pairs) id 1)
                        (UTILITY.UC_AppendLast acc true)
                        (UTILITY.UC_AppendLast acc false)
                    )
                    (if (ATS|UR_ColdNativeFeeRedirection (at index ats-pairs))
                        (UTILITY.UC_AppendLast acc true)
                        (UTILITY.UC_AppendLast acc false)
                    )
                )
            )
            []
            (enumerate 0 (- (length ats-pairs) 1))
        )
    )
    (defun ATS|UC_BooleanDecimalCombiner:[decimal] (id:string amount:decimal milestones:integer boolean:[bool])
        @doc "Helper function used in the ATS|CPF Functions"
        (UTILITY.UC_SplitBalanceWithBooleans (DPTF-DPMF|UR_Decimals id true) amount milestones boolean)
    )
    ;;6.2.1.7][A]           Validations
    (defun ATS|UVE_id (atspair:string)
        @doc "Enforces ATS Pair <atspair> exists"
        ;;First, the name must conform to the naming requirement
        (UTILITY.DALOS|UV_UniqueAccount atspair)
        ;;If it passes the naming requirement, its existance is checked, by reading it unlock values
        ;;If they are smaller than 0, which it cant happen, then atspair doesnt exist
        (with-default-read ATS|Pairs atspair
            { "unlocks" : -1 }
            { "unlocks" := u }
            (enforce
                (>= u 0)
                (format "ATS-Pair {} does not exist." [atspair])
            )
        )
    )
    (defun ATS|UV_IzTokenUnique (atspair:string reward-token:string)
        @doc "Enforces that the <reward-token> doesnt exist as reward token for the ATS Pair <atspair>"
        (DPTF-DPMF|UVE_id reward-token true)
        (let
            (
                (rtl:[string] (ATS|UR_RewardTokenList atspair))
            )
            (enforce 
                (= (contains reward-token rtl) false) 
                (format "Token {} already exists as Reward Token for the ATS Pair {}" [reward-token atspair]))     
        )
    )
    ;;6.2.2]  [A]   ATS Administration Functions
        ;;NONE
    ;;6.2.3]  [A]   ATS Client Functions
    ;;6.2.3.1][A]           Control
    (defun ATS|C_ChangeOwnership (patron:string atspair:string new-owner:string)
        @doc "Moves ATS <atspair> Ownership to <new-owner> DALOS Account"
        (with-capability (ATS|OWNERSHIP-CHANGE patron atspair new-owner)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_BIGGEST)
                true
            )
            (ATS|X_ChangeOwnership atspair new-owner)
            (DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_ToggleParameterLock (patron:string atspair:string toggle:bool)
        @doc "Sets the <parameter-lock> for the ATS Pair <atspair> to <toggle> \
            \ Unlocking <parameter-toggle> (setting it to false) comes with specific restrictions: \
            \       As many unlocks can be executed for a ATS Pair as needed \
            \       The Cost for unlock is (1000 IGNIS + 10 KDA )*(0 + <unlocks>)"
        (let
            (
                (ZG:bool (GAS|UC_SubZero))
                (NZG:bool (GAS|UC_NativeSubZero))
                (atspair-owner:string (ATS|UR_OwnerKonto atspair))
            )
            (with-capability (ATS|TOGGLE_PARAMETER-LOCK patron atspair toggle)
                (if (not ZG)
                    (GAS|X_Collect patron atspair-owner UTILITY.GAS_SMALL)
                    true
                )
                (let*
                    (
                        (toggle-costs:[decimal] (ATS|X_ToggleParameterLock atspair toggle))
                        (gas-costs:decimal (at 0 toggle-costs))
                        (kda-costs:decimal (at 1 toggle-costs))
                    )
                    (if (> gas-costs 0.0)
                        (with-capability (COMPOSE)
                            (if (not ZG)
                                (GAS|X_Collect patron atspair-owner gas-costs)
                                true
                            )
                            (if (not NZG)
                                (GAS|X_CollectDalosFuel patron kda-costs)
                                true
                            )
                            (ATS|X_IncrementParameterUnlocks atspair)
                        )
                        true
                    )
                )
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    (defun ATS|C_ToggleFeeSettings (patron:string atspair:string toggle:bool fee-switch:integer)
        @doc "Toggles ATS Boolean Fee Parameters to <toggle> : \
        \ fee-switch = 0 : cold-native-fee-redirection (c-nfr) \
        \ fee-switch = 1 : cold-fee-redirection (c-fr) \ 
        \ fee-switch = 2 : hot-fee-redirection (h-fr) "
        (with-capability (ATS|TOGGLE_FEE patron atspair toggle fee-switch)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL)
                true
            )
            (ATS|X_ToggleFeeSettings atspair toggle fee-switch)
            (DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_SetCRD (patron:string atspair:string soft-or-hard:bool base:integer growth:integer)
        @doc "Sets the Cold Recovery Duration based on input parameters"
        (with-capability (ATS|SET_CRD patron atspair soft-or-hard base growth)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL)
                true
            )
            (ATS|X_SetCRD atspair soft-or-hard base growth)
            (DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_SetColdFee (patron:string atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        @doc "Sets Cold Recovery fee parameters"
        (with-capability (ATS|SET_COLD_FEE patron atspair fee-positions fee-thresholds fee-array)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL)
                true
            )
            (ATS|X_SetColdFee atspair fee-positions fee-thresholds fee-array)
            (DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_SetHotFee (patron:string atspair:string promile:decimal decay:integer)
        @doc "Sets Cold Recovery fee parameters"
        (with-capability (ATS|SET_HOT_FEE patron atspair promile decay)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL)
                true
            )
            (ATS|X_SetHotFee atspair promile decay)
            (DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_ToggleElite (patron:string atspair:string toggle:bool)
        @doc "Toggles <c-elite-mode> to <toggle>"
        (with-capability (ATS|TOGGLE_ELITE patron atspair toggle)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL)
                true
            )
            (ATS|X_ToggleElite atspair toggle)
            (DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_TurnRecoveryOn (patron:string atspair:string cold-or-hot:bool)
        @doc "Turns <cold-recovery> or <hot-recovery> on"
        (with-capability (ATS|TOGGLE_RECOVERY patron atspair true cold-or-hot)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL)
                true
            )
            (ATS|X_TurnRecoveryOn atspair cold-or-hot)
            (DALOS|X_IncrementNonce patron)
            (ATS|C_EnsureActivationRoles patron atspair cold-or-hot)
        )
    )
    (defun ATS|C_TurnRecoveryOff (patron:string atspair:string cold-or-hot:bool)
        @doc "Turns <cold-recovery> or <hot-recovery> off"
        (with-capability (ATS|TOGGLE_RECOVERY patron atspair false cold-or-hot)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL)
                true
            )
            (ATS|X_TurnRecoveryOff atspair cold-or-hot)
            (DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_EnsureActivationRoles (patron:string atspair:string cold-or-hot:bool)
        @doc "Ensure proper roles are being set up that can allow Cold or Hot Recovery Activation \
        \ Can be used by anyone which has ownership for the required Tokens"
        (let*
            (
                (rt-lst:[string] (ATS|UR_RewardTokenList atspair))
                (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                (c-rbt-fer:bool (DPTF|UR_AccountRoleFeeExemption c-rbt ATS|SC_NAME))
                (c-fr:bool (ATS|UR_ColdRecoveryFeeRedirection atspair))
                (burn-role:bool (DPTF-DPMF|UR_AccountRoleBurn c-rbt ATS|SC_NAME true))
                (mint-role:bool (DPTF|UR_AccountRoleMint c-rbt ATS|SC_NAME))
            )
            ;;Exemption Roles for all defined Reward Tokens
            (ATS|C_SetMassRole patron atspair false)
            ;;Exemption Role for the c-rbt, if it is <false>
            (if (not c-rbt-fer)
                (DPTF|C_ToggleFeeExemptionRole patron c-rbt ATS|SC_NAME true)
                true
            )
            (if (= cold-or-hot true)
                (if (= c-fr false)
                    ;;Burn Roles for all  defined Reward-Tokens if c-fr is set to false
                    (ATS|C_SetMassRole patron atspair true)
                    (if (= burn-role false)
                        ;;Burn Role for the C-RBT
                        (DPTF-DPMF|C_ToggleBurnRole patron c-rbt ATS|SC_NAME true true)
                        (if (= mint-role false)
                            ;;Mint Role for the C-RBT
                            (DPTF|C_ToggleMintRole patron c-rbt ATS|SC_NAME true)
                            true
                        )
                    )
                )
                (let*
                    (
                        (h-rbt:string (ATS|UR_HotRewardBearingToken atspair))
                        (h-fr:bool (ATS|UR_HotRecoveryFeeRedirection atspair))
                        (burn-role:bool (DPTF-DPMF|UR_AccountRoleBurn h-rbt ATS|SC_NAME false))
                        (create-role:bool (DPMF|UR_AccountRoleCreate h-rbt ATS|SC_NAME))
                        (add-q-role:bool (DPMF|UR_AccountRoleNFTAQ h-rbt ATS|SC_NAME))
                    )
                    (if (= h-fr false)
                        ;;Burn Roles for all defined Reward-Tokens if h-fr is set to false
                        (ATS|C_SetMassRole patron atspair true)
                        (if (= burn-role false)
                            ;;Burn Role for the H-RBT
                            (DPTF-DPMF|C_ToggleBurnRole patron h-rbt ATS|SC_NAME true false)
                            (if (= create-role false)
                                ;;Create Role for the H-RBT
                                (DPMF|C_MoveCreateRole patron h-rbt ATS|SC_NAME)
                                (if (= add-q-role false)
                                    ;;Add-Quantity Role for the H-RBT
                                    (DPMF|C_ToggleAddQuantityRole patron h-rbt ATS|SC_NAME true)
                                    true
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    (defun ATS|C_SetMassRole (patron:string atspair:string burn-or-exemption:bool)
        @doc "Ensures all RTs have either burn or fee-exemption role for ATS|SC_NAME"
        (map
            (lambda
                (reward-token:string)
                (let
                    (
                        (rt-br:bool (DPTF-DPMF|UR_AccountRoleBurn reward-token ATS|SC_NAME true))
                        (rt-fer:bool (DPTF|UR_AccountRoleFeeExemption reward-token ATS|SC_NAME))
                    )
                    (if (and (= rt-br false) (= burn-or-exemption true) )
                        (DPTF-DPMF|C_ToggleBurnRole patron reward-token ATS|SC_NAME true true)        
                        (if (and (= rt-fer false) (= burn-or-exemption false))
                            (DPTF|C_ToggleFeeExemptionRole patron reward-token ATS|SC_NAME true)
                            true
                        )
                    )
                )
            )
            (ATS|UR_RewardTokenList atspair)
        )
    )
    ;;6.2.3.2][A]           Create
    (defun ATS|C_Issue:string
        (
            patron:string
            account:string
            atspair:string
            index-decimals:integer
            reward-token:string
            rt-nfr:bool
            reward-bearing-token:string
            rbt-nfr:bool
        )
        (with-capability (ATS|ISSUE patron (UTILITY.DALOS|UC_Makeid atspair) account reward-token reward-bearing-token)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron account UTILITY.GAS_HUGE)
                true
            )
            (ATS|X_Issue account atspair index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr)
            (DALOS|X_IncrementNonce patron)
            (DPTF|X_UpdateRewardToken (UTILITY.DALOS|UC_Makeid atspair) reward-token true)
            (DPTF-DPMF|X_UpdateRewardBearingToken reward-bearing-token (UTILITY.DALOS|UC_Makeid atspair) true)
            (ATS|C_EnsureActivationRoles patron (UTILITY.DALOS|UC_Makeid atspair) true)
            (UTILITY.DALOS|UC_Makeid atspair)
        )
    )
    (defun ATS|C_AddSecondary (patron:string atspair:string reward-token:string rt-nfr:bool)
        @doc "Add a secondary Reward Token for the ATS Pair <atspair>"
        (with-capability (ATS|ADD_SECONDARY patron atspair reward-token true)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_ISSUE)
                true
            )
            (DPTF-DPMF|C_DeployAccount reward-token ATS|SC_NAME true)
            (ATS|X_AddSecondary atspair reward-token rt-nfr)
            (DALOS|X_IncrementNonce patron)
            (DPTF|X_UpdateRewardToken atspair reward-token true)
            (ATS|C_EnsureActivationRoles patron atspair true)
            (if (= (ATS|UC_IzPresentHotRBT atspair) true)
                (ATS|C_EnsureActivationRoles patron atspair false)
                true
            )
        )
    )
    (defun ATS|C_AddHotRBT (patron:string atspair:string hot-rbt:string)
        @doc "Add a DPMF as <h-rbt> for the ATS Pair <atspair>"
        (with-capability (ATS|ADD_SECONDARY patron atspair hot-rbt false)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_ISSUE)
                true
            )
            (DPTF-DPMF|C_DeployAccount hot-rbt ATS|SC_NAME false)
            (ATS|X_AddHotRBT atspair hot-rbt)
            (DALOS|X_IncrementNonce patron)
            (DPTF-DPMF|X_UpdateRewardBearingToken hot-rbt atspair false)
            (ATS|C_EnsureActivationRoles patron atspair false)
        )
    )
    ;;6.2.3.4][A]           Use
    (defun ATS|C_Fuel (patron:string fueler:string atspair:string reward-token:string amount:decimal)
        @doc "Client Function for fueling an ATS Pair"
        (with-capability (ATS|FUEL patron fueler atspair reward-token amount)
            (DPTF|CX_Transfer patron reward-token fueler ATS|SC_NAME amount)
            (ATS|X_UpdateRoU atspair reward-token true true amount)
        )
    )
    (defun ATS|C_Coil:decimal (patron:string coiler:string atspair:string coil-token:string amount:decimal)
        @doc "Autostakes <coil-token> to the <atspair> ATS-Pair, receiving RBT"
        (with-capability (ATS|COIL patron coiler atspair coil-token amount)
            (let
                (
                    (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                    (c-rbt-amount:decimal (ATS|UC_RBT atspair coil-token amount))
                )
                (DPTF|CX_Transfer patron coil-token coiler ATS|SC_NAME amount)
                (ATS|X_UpdateRoU atspair coil-token true true amount)
                (DPTF|CX_Mint patron c-rbt ATS|SC_NAME c-rbt-amount false)
                (DPTF|CX_Transfer patron c-rbt ATS|SC_NAME coiler c-rbt-amount)
                c-rbt-amount
            )
        )
    )
    (defun ATS|C_Curl:decimal (patron:string curler:string atspair1:string atspair2:string rt:string amount:decimal)
        @doc "Autostakes <rt> token twice using <atspair1> and <atspair2> \
        \ <rt> must be RBT in <atspair1> and RT in <atspair2> for this to work"
        (with-capability (ATS|CURL patron curler atspair1 atspair2 rt amount)
            (let*
                (
                    (c-rbt1:string (ATS|UR_ColdRewardBearingToken atspair1))
                    (c-rbt1-amount:decimal (ATS|UC_RBT atspair1 rt amount))
                    (c-rbt2:string (ATS|UR_ColdRewardBearingToken atspair2))
                    (c-rbt2-amount:decimal (ATS|UC_RBT atspair2 c-rbt1 c-rbt1-amount))
                )
                (DPTF|CX_Transfer patron rt curler ATS|SC_NAME amount)
                (ATS|X_UpdateRoU atspair1 rt true true amount)
                (DPTF|CX_Mint patron c-rbt1 ATS|SC_NAME c-rbt1-amount false)
                (ATS|X_UpdateRoU atspair2 c-rbt1 true true c-rbt1-amount)
                (DPTF|CX_Mint patron c-rbt2 ATS|SC_NAME c-rbt2-amount false)
                (DPTF|CX_Transfer patron c-rbt2 ATS|SC_NAME curler c-rbt2-amount)
                c-rbt2-amount
            )
        )
    )
    (defun ATS|C_HotRecovery (patron:string recoverer:string atspair:string ra:decimal)
        @doc "Executes Hot Recovery for <ats-pair> by <recoverer> with the <ra> amount of Cold-Reward-Bearing-Token"
        (with-capability (ATS|HOT_RECOVERY patron recoverer atspair ra)
            (let*
                (
                    (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                    (h-rbt:string (ATS|UR_HotRewardBearingToken atspair))
                    (present-time:time (at "block-time" (chain-data)))
                    (meta-data-obj:object{ATS|Hot} { "mint-time" : present-time})
                    (meta-data:[object] [meta-data-obj])
                    (new-nonce:integer (+ (DPMF|UR_NoncesUsed h-rbt) 1))
                )
            ;;1]Recoverer transfers c-rbt to the ATS|SC_NAME
                (DPTF|CX_Transfer patron c-rbt recoverer OUROBOROS.ATS|SC_NAME ra)
            ;;2]ATS|SC_NAME burns c-rbt
                (DPTF|CX_Burn patron c-rbt OUROBOROS.ATS|SC_NAME ra)
            ;;3]ATS|SC_NAME mints h-rbt
                (DPMF|CX_Mint patron h-rbt OUROBOROS.ATS|SC_NAME ra meta-data)
            ;;4]ATS|SC_NAME transfers h-rbt to recoverer
                (DPMF|CX_Transfer patron h-rbt new-nonce OUROBOROS.ATS|SC_NAME recoverer ra)
            )
        )
    )
    (defun ATS|C_ColdRecovery (patron:string recoverer:string atspair:string ra:decimal)
        @doc "Executes Cold Recovery for <ats-pair> by <recoverer> with the <ra> amount of Cold-Reward-Bearing-Token"
        (with-capability (ATS|COLD_RECOVERY patron recoverer atspair ra)
            (ATS|X_DeployAccount atspair recoverer)
            (let*
                (
                    (rt-lst:[string] (ATS|UR_RewardTokenList atspair))
                    (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                    (c-rbt-precision:integer (DPTF-DPMF|UR_Decimals c-rbt true))
                    (usable-position:integer (ATS|UC_WhichPosition atspair ra recoverer))
                    (fee-promile:decimal (ATS|UC_ColdRecoveryFee atspair ra usable-position))
                    (c-rbt-fee-split:[decimal] (UTILITY.UC_PromilleSplit fee-promile ra c-rbt-precision))
                    (c-fr:bool (ATS|UR_ColdRecoveryFeeRedirection atspair))
                    (cull-time:time (ATS|UC_CullColdRecoveryTime atspair recoverer))

                    ;;for false
                    (standard-split:[decimal] (ATS|UC_RTSplitAmounts atspair ra))
                    (rt-precision-lst:[integer] (ATS|UR_RtPrecisions atspair))
                    (negative-c-fr:[[decimal]] (UTILITY.UC_ListPromileSplit fee-promile standard-split rt-precision-lst))

                    ;;for true
                    (positive-c-fr:[decimal] (ATS|UC_RTSplitAmounts atspair (at 0 c-rbt-fee-split)))

                )
            ;;1]Recoverer transfers c-rbt to the ATS|SC_NAME
                (DPTF|CX_Transfer patron c-rbt recoverer OUROBOROS.ATS|SC_NAME ra)
            ;;2]ATS|SC_NAME burns c-rbt and handles c-fr
                (DPTF|CX_Burn patron c-rbt OUROBOROS.ATS|SC_NAME ra)
            ;;3]ATS|Pairs is updated with the proper information (unbonding RTs), while burning any fee RTs if needed
                (if c-fr
                    (map
                        (lambda
                            (index:integer)
                            (ATS|X_UpdateRoU atspair (at index rt-lst) false true (at index positive-c-fr))
                            (ATS|X_UpdateRoU atspair (at index rt-lst) true false (at index positive-c-fr))
                        )
                        (enumerate 0 (- (length rt-lst) 1))
                    )
                    (with-capability (COMPOSE)
                        (map
                            (lambda
                                (index:integer)
                                (ATS|X_UpdateRoU atspair (at index rt-lst) false true (at index (at 0 negative-c-fr)))
                                (ATS|X_UpdateRoU atspair (at index rt-lst) true false (at index (at 0 negative-c-fr)))
                            )
                            (enumerate 0 (- (length rt-lst) 1))
                        )
                        (map
                            (lambda
                                (index:integer)
                                (OUROBOROS.DPTF|CX_Burn patron (at index rt-lst) OUROBOROS.ATS|SC_NAME (at index (at 1 negative-c-fr)))
                            )
                            (enumerate 0 (- (length rt-lst) 1))
                        )
                    )
                )
            ;;4]ATS|Ledger is updated with the proper information
                (if c-fr
                    (ATS|X_StoreUnstakeObject atspair recoverer usable-position 
                        { "reward-tokens"   : positive-c-fr 
                        , "cull-time"       : cull-time}
                    )
                    (ATS|X_StoreUnstakeObject atspair recoverer usable-position 
                        { "reward-tokens"   : (at 0 negative-c-fr) 
                        , "cull-time"       : cull-time}
                    )
                )
            )
            (ATS|X_Normalize atspair recoverer)
        )
    )
    (defun ATS|C_Cull:[decimal] (patron:string culler:string atspair:string)
        @doc "Culls <atspair> for <culler>. Culling returns all elapsed past Cold-Recoveries executed by <culler> \
        \ Returns culled values. If no cullable values exists, returns a list of zeros, since nothing has been culled"
        (with-capability (ATS|CULL culler atspair)
            (let*
                (
                    (rt-lst:[string] (ATS|UR_RewardTokenList atspair))
                    (c0:[decimal] (ATS|X_MultiCull atspair culler))
                    (c1:[decimal] (ATS|X_SingleCull atspair culler 1))
                    (c2:[decimal] (ATS|X_SingleCull atspair culler 2))
                    (c3:[decimal] (ATS|X_SingleCull atspair culler 3))
                    (c4:[decimal] (ATS|X_SingleCull atspair culler 4))
                    (c5:[decimal] (ATS|X_SingleCull atspair culler 5))
                    (c6:[decimal] (ATS|X_SingleCull atspair culler 6))
                    (c7:[decimal] (ATS|X_SingleCull atspair culler 7))
                    (ca:[[decimal]] [c0 c1 c2 c3 c4 c5 c6 c7])
                    (cw:[decimal] (UTILITY.UC_AddArray ca))
                )
                (map
                    (lambda
                        (idx:integer)
                        (if (!= (at idx cw) 0.0)
                            (with-capability (COMPOSE)
                                (ATS|X_UpdateRoU atspair (at idx rt-lst) false false (at idx cw))
                                (DPTF|CX_Transfer patron (at idx rt-lst) OUROBOROS.ATS|SC_NAME culler (at idx cw))
                            )
                            true
                        )
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
                (ATS|X_Normalize atspair culler)
                cw
            )
        )
    )
    ;;6.2.3.5][A]           Destroy
    ;;NEEDS FINALISATION
    (defun ATS|C_RemoveSecondary (patron:string atspair:string reward-token:string)
        @doc "Removes a secondary Reward from its ATS Pair"
        (with-capability (OUROBOROS.ATS|REMOVE_SECONDARY patron atspair reward-token)
            (if (not (OUROBOROS.GAS|UC_SubZero))
                (OUROBOROS.GAS|X_Collect patron (OUROBOROS.ATS|UR_OwnerKonto atspair) UTILITY.GAS_ISSUE)
                true
            )
            (OUROBOROS.ATS|X_RemoveSecondary atspair reward-token)
            (OUROBOROS.DALOS|X_IncrementNonce patron)
            (OUROBOROS.DPTF|X_UpdateRewardToken atspair reward-token false)
            ;;Unbonding if it exists for pair, must be returned to users
            ;;Resident, if it exists, must be replaced with primary.
        )
    )
    ;;6.2.3.6][A]           Revoke
    (defun ATS|C_RevokeMint (patron:string id:string)
        @doc "Used when revoking <role-mint> from ATS|SC_NAME \
        \ and <id> is a Cold-RBT for any ATS-Pair"
        (if (ATS|UC_IzRBT-Absolute id true)
            (ATS|C_MassTurnColdRecoveryOff patron id)  
            true        
        )
    )
    (defun ATS|C_RevokeFeeExemption (patron:string id:string)
        @doc "Used when revoking <role-fee-exemption> from ATS|SC_NAME \
        \ and <id> is a RT for any ATS-Pair"
        (if (ATS|UC_IzRT-Absolute id)
            (ATS|C_MassTurnColdRecoveryOff patron id)  
            true
        )
    )
    (defun ATS|C_RevokeCreateOrAddQ (patron:string id:string)
        @doc "Used when revoking either <role-nft-add-quantity> or <role-nft-create> from ATS|SC_NAME \
        \ and <id> is a Hot-RBT for any ATS-Pair"
        (if (ATS|UC_IzRBT-Absolute id false)
            (ATS|C_TurnRecoveryOff patron (DPMF|UR_RewardBearingToken id) false)
            true
        )
    )
    (defun ATS|C_RevokeBurn (patron:string id:string cold-or-hot:bool)
        @doc "Used when revoking either <role-burn> or <role-nft-burn> from ATS|SC_NAME \
        \ and <id> is either RT, Cold-RBT or Hot-RBT in any ATS-Pair \
        \       <id> is RT: if <c-fr> is false, set to true for all ATS-Pairs the RT is part of \
        \       <id> is RT: if <h-fr> is false, set to true for all ATS-Pairs the RT is part of \
        \       <id> is Cold-RBT: stops Cold Recovery \
        \       <id> is Hot-RBT: stops Hot Recovery"
        (if (ATS|UC_IzRT-Absolute id)
            (map
                (lambda
                    (atspair:string)
                    (with-capability (COMPOSE)
                        (if (not (ATS|UR_ColdRecoveryFeeRedirection atspair))
                            (ATS|C_ToggleFeeSettings patron atspair true 1)
                            true
                        )
                        (if (not (ATS|UR_HotRecoveryFeeRedirection atspair))
                            (ATS|C_ToggleFeeSettings patron atspair true 2)
                            true
                        )
                    )
                )
                (DPTF|UR_RewardToken id)
            )
            (if (ATS|UC_IzRBT-Absolute id cold-or-hot)
                (if (= cold-or-hot true)
                    (ATS|C_MassTurnColdRecoveryOff patron id)
                    (if (= (ATS|UR_ToggleHotRecovery (DPMF|UR_RewardBearingToken id)) true)
                        (ATS|C_TurnRecoveryOff patron (DPMF|UR_RewardBearingToken id) false)
                        true
                    )
                )
            )
        )
    )
    (defun ATS|C_MassTurnColdRecoveryOff (patron:string id:string)
        @doc "Turns Cold Recovery off for all ATS-Pairs that have <id> as Cold-RBT"
        (map
            (lambda
                (atspair:string)
                (if (= (ATS|UR_ToggleColdRecovery atspair) true)
                    (ATS|C_TurnRecoveryOff patron atspair true)
                    true
                )
            )
            (DPTF|UR_RewardBearingToken id)
        )
    )
    ;;6.2.4]  [A]   ATS Aux Functions
    ;;6.2.4.1][A]           Aux Functions Part 1
    (defun ATS|X_ChangeOwnership (atspair:string new-owner:string)
        (require-capability (ATS|OWNERSHIP-CHANGE_CORE atspair new-owner))
        (update ATS|Pairs atspair
            {"owner-konto"                      : new-owner}
        )
    )
    (defun ATS|X_ToggleParameterLock:[decimal] (atspair:string toggle:bool)
        (require-capability (ATS|TOGGLE_PARAMETER-LOCK_CORE atspair toggle))
        (update ATS|Pairs atspair
            { "parameter-lock" : toggle}
        )
        (if (= toggle true)
            [0.0 0.0]
            (UTILITY.ATS|UC_UnlockPrice (ATS|UR_Unlocks atspair))
        )
    )
    (defun ATS|X_IncrementParameterUnlocks (atspair:string)
        (require-capability (ATS|INCREMENT-LOCKS))
        (with-read ATS|Pairs atspair
            { "unlocks" := u }
            (update ATS|Pairs atspair
                {"unlocks" : (+ u 1)}
            )
        )
    )
    (defun ATS|X_ToggleFeeSettings (atspair:string toggle:bool fee-switch:integer)
        (require-capability (ATS|TOGGLE_FEE_CORE atspair toggle fee-switch))
        (if (= fee-switch 0)
            (update ATS|Pairs atspair
                { "c-nfr" : toggle}
            )
            (if (= fee-switch 1)
                (update ATS|Pairs atspair
                    { "c-fr" : toggle}
                )
                (update ATS|Pairs atspair
                    { "h-fr" : toggle}
                )
            )
        )
    )
    (defun ATS|X_SetCRD (atspair:string soft-or-hard:bool base:integer growth:integer)
        (require-capability (ATS|SET_CRD_CORE atspair soft-or-hard base growth))
        (if (= soft-or-hard true)
            (update ATS|Pairs atspair
                { "c-duration" : (UTILITY.ATS|UC_MakeSoftIntervals base growth)}
            )
            (update ATS|Pairs atspair
                { "c-duration" : (UTILITY.ATS|UC_MakeHardIntervals base growth)}
            )
        )
    )
    (defun ATS|X_SetColdFee (atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        (require-capability (ATS|SET_COLD_FEE_CORE atspair fee-positions fee-thresholds fee-array))
        (update ATS|Pairs atspair
            { "c-positions"     : fee-positions
            , "c-limits"        : fee-thresholds 
            , "c-array"         : fee-array}
        )
    )
    (defun ATS|X_SetHotFee (atspair:string promile:decimal decay:integer)
        (require-capability (ATS|SET_HOT_FEE_CORE atspair promile decay))
        (update ATS|Pairs atspair
            { "h-promile"       : promile
            , "h-decay"         : decay}
        )
    )
    (defun ATS|X_ToggleElite (atspair:string toggle:bool)
        (require-capability (ATS|TOGGLE_ELITE_CORE atspair toggle))
        (update ATS|Pairs atspair
            { "c-elite-mode" : toggle}
        )
    )
    (defun ATS|X_TurnRecoveryOn (atspair:string cold-or-hot:bool)
        (require-capability (ATS|RECOVERY-ON_CORE atspair cold-or-hot))
        (if (= cold-or-hot true)
            (update ATS|Pairs atspair
                { "cold-recovery" : true}
            )
            (update ATS|Pairs atspair
                { "hot-recovery" : true}
            )
        )
    )
    (defun ATS|X_TurnRecoveryOff (atspair:string cold-or-hot:bool)
        (require-capability (ATS|RECOVERY-OFF_CORE atspair cold-or-hot))
        (if (= cold-or-hot true)
            (update ATS|Pairs atspair
                { "cold-recovery" : false}
            )
            (update ATS|Pairs atspair
                { "hot-recovery" : false}
            )
        )
    )
    (defun ATS|X_Issue
        (
            account:string
            atspair:string
            index-decimals:integer
            reward-token:string
            rt-nfr:bool
            reward-bearing-token:string
            rbt-nfr:bool
        )
        (UTILITY.DALOS|UV_Decimals index-decimals)
        (UTILITY.DALOS|UV_Name atspair)
        (DPTF-DPMF|UVE_id reward-token true)
        (DPTF-DPMF|UVE_id reward-bearing-token true)
        (require-capability (ATS|ISSUE_CORE (UTILITY.DALOS|UC_Makeid atspair) account reward-token reward-bearing-token))
        (insert ATS|Pairs (UTILITY.DALOS|UC_Makeid atspair)
            {"owner-konto"                          : account
            ,"can-change-owner"                     : true
            ,"parameter-lock"                       : false
            ,"unlocks"                              : 0
            ;;Index
            ,"pair-index-name"                      : atspair
            ,"index-decimals"                       : index-decimals
            ;;Reward Tokens
            ,"reward-tokens"                        : [(ATS|UC_ComposePrimaryRewardToken reward-token rt-nfr)]
            ;;Cold Reward Bearing Token Info
            ,"c-rbt"                                : reward-bearing-token
            ,"c-nfr"                                : rbt-nfr
            ,"c-positions"                          : -1
            ,"c-limits"                             : [0.0]
            ,"c-array"                              : [[0.0]]
            ,"c-fr"                                 : true
            ,"c-duration"                           : (UTILITY.ATS|UC_MakeSoftIntervals 300 6)
            ,"c-elite-mode"                         : false
            ;;Hot Reward Bearing Token Info
            ,"h-rbt"                                : UTILITY.BAR
            ,"h-promile"                            : 100.0
            ,"h-decay"                              : 1
            ,"h-fr"                                 : true
            ;; Activation Toggles
            ,"cold-recovery"                 : false
            ,"hot-recovery"                  : false
            }
        )
        (DPTF-DPMF|C_DeployAccount reward-token account true)
        (DPTF-DPMF|C_DeployAccount reward-bearing-token account true)
        (DPTF-DPMF|C_DeployAccount reward-token ATS|SC_NAME true)
        (DPTF-DPMF|C_DeployAccount reward-bearing-token ATS|SC_NAME true)
    )
    (defun ATS|X_AddSecondary (atspair:string reward-token:string rt-nfr:bool)
        (require-capability (ATS|ADD_SECONDARY_CORE atspair reward-token true))
        (with-read ATS|Pairs atspair
            { "reward-tokens" := rt }
            (update ATS|Pairs atspair
                {"reward-tokens" : (UTILITY.UC_AppendLast rt (ATS|UC_ComposePrimaryRewardToken reward-token rt-nfr))}
            )
        )
    )
    (defun ATS|X_AddHotRBT (atspair:string hot-rbt:string)
        (require-capability (ATS|ADD_SECONDARY_CORE atspair hot-rbt false))
        (update ATS|Pairs atspair
            {"h-rbt" : hot-rbt}
        )
    )
    (defun ATS|X_RemoveSecondary (atspair:string reward-token:string)
        (require-capability (ATS|REMOVE_SECONDARY_CORE atspair reward-token))
        (with-read ATS|Pairs atspair
            { "reward-tokens" := rt }
            (update ATS|Pairs atspair
                {"reward-tokens" : 
                    (UTILITY.UC_RemoveItem  rt (at (ATS|UC_RewardTokenPosition atspair reward-token) rt))
                }
            )
        )
    )
    (defun ATS|X_UpdateRoU (atspair:string reward-token:string rou:bool direction:bool amount:decimal)
        (require-capability (ATS|UPDATE_ROU))
        (let*
            (
                (rtp:integer (ATS|UC_RewardTokenPosition atspair reward-token))
                (nfr:bool (ATS|UR_RT-Data atspair reward-token 1))
                (resident:decimal (ATS|UR_RT-Data atspair reward-token 2))
                (unbonding:decimal (ATS|UR_RT-Data atspair reward-token 3))
                (new-rt:object{ATS|RewardTokenSchema} 
                    (if (= rou true)
                        (if (= direction true)
                            (ATS|UC_RT reward-token nfr (+ resident amount) unbonding)
                            (ATS|UC_RT reward-token nfr (- resident amount) unbonding)
                        )
                        (if (= direction true)
                            (ATS|UC_RT reward-token nfr resident (+ unbonding amount))
                            (ATS|UC_RT reward-token nfr resident (- unbonding amount))
                        )
                    )
                )
            )
            (with-read ATS|Pairs atspair
                { "reward-tokens" := rt }
                (update ATS|Pairs atspair
                    { "reward-tokens" : (UTILITY.UC_ReplaceItem rt (at rtp rt) new-rt)}
                )
            )
        )
    )
    ;;6.2.4.2][A]           Aux Functions Part 2 - ATS|Ledger Aux
    (defun ATS|X_StoreUnstakeObjectList (atspair:string account:string obj:[object{ATS|Unstake}])
        @doc "Stores a new Unstake Object on Position -1 for <atspair> and <account> \
        \ Always assumes ATS-Unstake Account defined by <atspair>|<account> exists "
        (require-capability (ATS|UPDATE_LEDGER))
        (update ATS|Ledger (concat [atspair UTILITY.BAR account])
            { "P0" : obj}
        )
    )
    (defun ATS|X_StoreUnstakeObject (atspair:string account:string position:integer obj:object{ATS|Unstake})
        @doc "Updates entry in the ATS|Ledger with <obj> on <position> for <atspair> and <account> \
        \ Always assumes ATS-Unstake Account defined by <atspair>|<account> exists \
        \ For Position -1 it appends the object. \
        \ For Position 1 to 7, it simply replaces the object"
        (require-capability (ATS|UPDATE_LEDGER))
        (with-read ATS|Ledger (concat [atspair UTILITY.BAR account])
            { "P0"  := p0 , "P1"  := p1 , "P2"  := p2 , "P3"  := p3, "P4"  := p4, "P5"  := p5, "P6"  := p6, "P7"  := p7 }
            (if (= position -1)
                (if (and 
                        (= (length p0) 1)
                        (= 
                            (at 0 p0) 
                            (ATS|UC_MakeZeroUnstakeObject atspair)
                        )
                    )
                    (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                        { "P0"  : [obj]}
                    )
                    (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                        { "P0"  : (UTILITY.UC_AppendLast p0 obj)}
                    )
                )
                (if (= position 1)
                    (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                        { "P1"  : obj}
                    )
                    (if (= position 2)
                        (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                            { "P2"  : obj}
                        )
                        (if (= position 3)
                            (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                { "P3"  : obj}
                            )
                            (if (= position 4)
                                (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                    { "P4"  : obj}
                                )
                                (if (= position 5)
                                    (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                        { "P5"  : obj}
                                    )
                                    (if (= position 6)
                                        (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                            { "P6"  : obj}
                                        )
                                        (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                            { "P7"  : obj}
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    (defun ATS|X_DeployAccount (atspair:string account:string)
        @doc "Deploys an ATS|Ledger (Unstaking) Account for <atspair> and <account> and normalizes it"
        (require-capability (ATS|DEPLOY atspair account))
        (let
            (
                (zero:object{ATS|Unstake} (ATS|UC_MakeZeroUnstakeObject atspair))
                (negative:object{ATS|Unstake} (ATS|UC_MakeNegativeUnstakeObject atspair))
            )
            (with-default-read ATS|Ledger (concat [atspair UTILITY.BAR account])
                { "P0"  : [zero]
                , "P1"  : negative
                , "P2"  : negative
                , "P3"  : negative
                , "P4"  : negative
                , "P5"  : negative
                , "P6"  : negative
                , "P7"  : negative
                }
                { "P0"  := p0
                , "P1"  := p1
                , "P2"  := p2
                , "P3"  := p3
                , "P4"  := p4
                , "P5"  := p5
                , "P6"  := p6
                , "P7"  := p7
                }
                (write ATS|Ledger (concat [atspair UTILITY.BAR account])
                    { "P0"  : p0
                    , "P1"  : p1
                    , "P2"  : p2
                    , "P3"  : p3
                    , "P4"  : p4
                    , "P5"  : p5
                    , "P6"  : p6
                    , "P7"  : p7
                    }
                )
            )
        )
        (ATS|X_Normalize atspair account)
    )
    (defun ATS|X_Normalize (atspair:string account:string)
        @doc "Normalize an existing ATS-UnstakeAccount \
        \ Normalizing means updating the unstaking positions according to existing <atspair> parameters"
        (require-capability (ATS|NORMALIZE_LEDGER atspair account))
        (with-read ATS|Ledger (concat [atspair UTILITY.BAR account])
            { "P0"  := p0 , "P1"  := p1 , "P2"  := p2 , "P3"  := p3, "P4"  := p4, "P5"  := p5, "P6"  := p6, "P7"  := p7 }
            (let
                (
                    (zero:object{ATS|Unstake} (ATS|UC_MakeZeroUnstakeObject atspair))
                    (negative:object{ATS|Unstake} (ATS|UC_MakeNegativeUnstakeObject atspair))
                    (positions:integer (ATS|UR_ColdRecoveryPositions atspair))
                    (elite:bool (ATS|UR_EliteMode atspair))
                    (major-tier:integer (DALOS|UR_Elite-Tier-Major account))
                )
                (if (= positions -1)
                    (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                        {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [zero] )
                        ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 negative)
                        ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 negative)
                        ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 negative)
                        ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 negative)
                        ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 negative)
                        ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                        ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                        }
                    )
                    (if (= positions 1)
                        (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                            {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                            ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                            ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 negative)
                            ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 negative)
                            ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 negative)
                            ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 negative)
                            ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                            ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                            }
                        )
                        (if (= positions 2)
                            (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 negative)
                                ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 negative)
                                ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 negative)
                                ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                                ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                                }
                            )
                            (if (= positions 3)
                                (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                    {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                    ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                    ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                    ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 zero)
                                    ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 negative)
                                    ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 negative)
                                    ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                                    ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                                    }
                                )
                                (if (= positions 4)
                                    (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                        {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                        ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                        ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                        ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 zero)
                                        ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 zero)
                                        ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 negative)
                                        ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                                        ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                                        }
                                    )
                                    (if (= positions 5)
                                        (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                            {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                            ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                            ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                            ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 zero)
                                            ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 zero)
                                            ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 zero)
                                            ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                                            ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                                            }
                                        )
                                        (if (= positions 6)
                                            (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                                {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                                ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                                ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                                ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 zero)
                                                ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 zero)
                                                ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 zero)
                                                ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 zero)
                                                ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                                                }
                                            )
                                            (if (not elite)
                                                (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                                    {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                                    ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                                    ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                                    ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 zero)
                                                    ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 zero)
                                                    ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 zero)
                                                    ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 zero)
                                                    ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 zero)
                                                    }
                                                )
                                                (update ATS|Ledger (concat [atspair UTILITY.BAR account])
                                                    {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                                    ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                                    ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 (if (>= major-tier 2) zero negative))
                                                    ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 (if (>= major-tier 3) zero negative))
                                                    ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 (if (>= major-tier 4) zero negative))
                                                    ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 (if (>= major-tier 5) zero negative))
                                                    ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 (if (>= major-tier 6) zero negative))
                                                    ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 (if (>= major-tier 7) zero negative))
                                                    }
                                                )
                                            ) 
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            ) 
        )
    )
    (defun ATS|X_SingleCull:[decimal] (atspair:string account:string position:integer)
        @doc "Culls a single ATS Position, returning the culled amounts"
        (let*
            (
                (zero:object{ATS|Unstake} (ATS|UC_MakeZeroUnstakeObject atspair))
                (unstake-obj:object{ATS|Unstake} (ATS|UR_P1-7 atspair account position))
                (rt-amounts:[decimal] (at "reward-tokens" unstake-obj))
                (l:integer (length rt-amounts))
                (empty:[decimal] (make-list l 0.0))
                (cull-output:[decimal] (ATS|UC_CullValue unstake-obj))
            )
            (if (!= cull-output empty)
                (ATS|X_StoreUnstakeObject atspair account position zero)
                true
            )
            cull-output
        )
    )
    (defun ATS|X_MultiCull:[decimal] (atspair:string account:string)
        @doc "Culls the -1 ATS Position for <atspair> and <account>"
        (let*
            (
                (zero:object{ATS|Unstake} (ATS|UC_MakeZeroUnstakeObject atspair))
                (negative:object{ATS|Unstake} (ATS|UC_MakeNegativeUnstakeObject atspair))
                (p0:[object{ATS|Unstake}] (ATS|UR_P0 atspair account))
                (p0l:integer (length p0))
                (bl:[bool]
                    (fold
                        (lambda
                            (acc:[bool] item:object{ATS|Unstake})
                            (UTILITY.UC_AppendLast acc (ATS|UC_IzCullable item))
                        )
                        []
                        p0
                    )
                )
                (zero-output:[decimal] (make-list (length (ATS|UR_RewardTokenList atspair)) 0.0))
                (cullables:[integer] (UTILITY.UC_Search bl true))
                (immutables:[integer] (UTILITY.UC_Search bl false))
                (how-many-cullables:integer (length cullables))
            )
            (if (= how-many-cullables 0)
                zero-output
                (let*
                    (
                        (after-cull:[object{ATS|Unstake}]
                            (if (< how-many-cullables p0l)
                                (fold
                                    (lambda
                                        (acc:[object{ATS|Unstake}] idx:integer)
                                        (UTILITY.UC_AppendLast acc (at (at idx immutables) p0))
                                    )
                                    []
                                    (enumerate 0 (- (length immutables) 1))
                                )
                                [zero]
                            )
                        )
                        (to-be-culled:[object{ATS|Unstake}]
                            (fold
                                (lambda
                                    (acc:[object{ATS|Unstake}] idx:integer)
                                    (UTILITY.UC_AppendLast acc (at (at idx cullables) p0))
                                )
                                []
                                (enumerate 0 (- (length cullables) 1))
                            )
                        )
                        (culled-values:[[decimal]]
                            (fold
                                (lambda
                                    (acc:[[decimal]] idx:integer)
                                    (UTILITY.UC_AppendLast acc (ATS|UC_CullValue (at idx to-be-culled)))
                                )
                                []
                                (enumerate 0 (- (length to-be-culled) 1))
                            )
                        )
                        (summed-culled-values:[decimal] (UTILITY.UC_AddArray culled-values))
                    )
                    (ATS|X_StoreUnstakeObjectList atspair account after-cull)
                    summed-culled-values
                )
            )
        )
    )
    ;;
    ;;
    ;;
    ;;LIQUID-STAKING; [7] LIQUID Submodule
    ;;
    ;;
    ;;
    ;;========[L] CAPABILITIES=================================================;;
    ;;7.1]    [L] LIQUID Capabilities
    ;;7.1.1]  [L]   LIQUID Composed Capabilities
    (defcap LIQUID|WRAP (patron:string wrapper:string amount:decimal)
        @doc "Capability required to wrap native KDA to DPTF Kadena"
        (let
            (
                (wrapped-kda-id:string (DALOS|UR_WrappedKadenaID))
            )
            (enforce (!= wrapped-kda-id UTILITY.BAR) "Kadena Wrapping is not live yet")
            (compose-capability (DPTF|MINT patron wrapped-kda-id LIQUID|SC_NAME amount false true))
            (compose-capability (DPTF-DPMF|TRANSFER patron wrapped-kda-id LIQUID|SC_NAME wrapper amount true true))
        )
    )
    (defcap LIQUID|UNWRAP (patron:string unwrapper:string amount:decimal)
        @doc "Capability required to wrap native KDA to DPTF Kadena"
        (let
            (
                (wrapped-kda-id:string (DALOS|UR_WrappedKadenaID))
            )
            (enforce (!= wrapped-kda-id UTILITY.BAR) "Kadena Unwrapping is not live yet")
            (compose-capability (DPTF-DPMF|TRANSFER patron wrapped-kda-id unwrapper LIQUID|SC_NAME amount true true))
            (compose-capability (DPTF-DPMF|BURN patron wrapped-kda-id LIQUID|SC_NAME amount true true))
        )
    )
    ;;========[L] FUNCTIONS====================================================;;
    ;;7.2.1]  [L]   LIQUID Administration Functions
        ;;NONE
    ;;7.2.2]  [L]   LIQUID Client Functions
    (defun LIQUID|C_WrapKadena (patron:string wrapper:string amount:decimal)
        @doc "Wraps native Kadena to DPTF Kadena"
        (with-capability (LIQUID|WRAP patron wrapper amount)
            (let
                (
                    (kadena-patron:string (DALOS|UR_AccountKadena wrapper))
                    (wrapped-kda-id:string (DALOS|UR_WrappedKadenaID))
                )
            ;;Wrapper transfer KDA to LIQUID|SC_KDA-NAME
                (GAS|XC_TransferDalosFuel kadena-patron LIQUID|SC_KDA-NAME amount)
            ;;LIQUID|SC_NAME mints DWK
                (DPTF|CX_Mint patron wrapped-kda-id LIQUID|SC_NAME amount false)
            ;;LIQUID|SC_NAME transfer DWK to wrapper
                (DPTF|CX_Transfer patron wrapped-kda-id LIQUID|SC_NAME wrapper amount)
            )
        )
    )
    (defun LIQUID|C_UnwrapKadena (patron:string unwrapper:string amount:decimal)
        @doc "Unwraps DPTF Kadena to native Kadena"
        (with-capability (LIQUID|UNWRAP patron unwrapper amount)
            (let
                (
                    (kadena-patron:string (DALOS|UR_AccountKadena unwrapper))
                    (wrapped-kda-id:string (DALOS|UR_WrappedKadenaID))
                )
            ;;Unwrapper transfer DPTF KDA to LIQUID|SC_NAME
                (DPTF|CX_Transfer patron wrapped-kda-id unwrapper LIQUID|SC_NAME amount)
            ;;LIQUID|SC_NAME burns DWK
                (DPTF|CX_Burn patron wrapped-kda-id LIQUID|SC_NAME amount)
            ;;LIQUID|SC_KDA-NAME transfers native KDA to unwrapper
                (GAS|XC_TransferDalosFuel LIQUID|SC_KDA-NAME kadena-patron amount)
            )
        )
    )
    ;;
    ;;
    ;;
    ;;VESTING; [8] VST Submodule
    ;;
    ;;
    ;;
    ;;========[V] CAPABILITIES=================================================;;
    ;;8.1]    [V] VST Capabilities
    ;;8.1.1]  [V]   VST Basic Capabilities
    (defcap VST|EXISTANCE (id:string token-type:bool existance:bool)
        @doc "Enforce that a DPTF|DPMF has a vesting counterpart or not"
        (let
            (
                (has-vesting:bool (VST|UC_HasVesting id token-type))
            )
            (enforce (= has-vesting existance) (format "Vesting for the Token {} is not satisfied with existance {}" [id existance]))
        )
    )
    (defcap VST|ACTIVE (dptf:string dpmf:string)
        @doc "Enforces Conditions for a Vesting Pair to be active"
        (let
            (
                (dptf-fee-exemption:bool (DPTF|UR_AccountRoleFeeExemption dptf VST|SC_NAME))
                (create-role:bool (DPMF|UR_AccountRoleCreate dpmf VST|SC_NAME))
                (add-q-role:bool (DPMF|UR_AccountRoleNFTAQ dpmf VST|SC_NAME))
                (burn-role:bool (DPTF-DPMF|UR_AccountRoleBurn dpmf VST|SC_NAME false))
                (transfer-role:bool (DPTF-DPMF|UR_AccountRoleTransfer dpmf VST|SC_NAME false))
            )
            (enforce (= dptf-fee-exemption true) "Vesting needs <role-fee-exemption> for the DPTF Token on the DalosVesting Smart DALOS Account")
            (enforce (= create-role true) "Vesting needs <role-nft-create> for the DPMF Token on the DalosVesting Smart DALOS Account")
            (enforce (= add-q-role true) "Vesting needs <role-nft-add-quantity> for the DPMF Token on the DalosVesting Smart DALOS Account")
            (enforce (= burn-role true) "Vesting needs <role-nft-burn> for the DPMF Token on the DalosVesting Smart DALOS Account")
            (enforce (= transfer-role true) "Vesting needs <role-transfer> for the DPMF Token on the DalosVesting Smart DALOS Account")
        )
    )
    (defcap VST|DEFINE ()
        @doc "Capability needed to define a vesting pair"
        true
    )
    ;;========[V] FUNCTIONS====================================================;;
    ;;8.2]    [V] VST Functions
    ;;8.2.1]  [V]   VST Utility Functions
    ;;8.2.1.1][V]           Computing|Composing
    (defun VST|UC_HasVesting:bool (id:string token-type:bool)
        @doc "Checks if a DPTF|DPMF Token has a vesting counterpart"
        (if (= (DPTF-DPMF|UR_Vesting id token-type) UTILITY.BAR)
            false
            true
        )
    )
    ;;8.2.2]  [V]   VST Administration Functions
        ;;NONE
    ;;8.2.3]  [V]   VST Client Functions
    (defun VST|C_CreateVestingLink (patron:string dptf:string)
        @doc "Creates a Vesting Pair using the Input DPTF Token"
        (with-capability (VST|DEFINE)
            (let*
                (
                    (ZG:bool (GAS|UC_SubZero))
                    (dptf-owner:string (DPTF-DPMF|UR_Konto dptf true))
                    (dptf-name:string (DPTF-DPMF|UR_Name dptf true))
                    (dptf-ticker:string (DPTF-DPMF|UR_Ticker dptf true))
                    (dptf-decimals:integer (DPTF-DPMF|UR_Decimals dptf true))
                    (dpmf-name:string (+ "Vested" (take 44 dptf-name)))
                    (dpmf-ticker:string (+ "Z" (take 19 dptf-ticker)))
                    (dpmf:string 
                        (DPMF|C_Issue
                            patron
                            dptf-owner
                            dpmf-name
                            dpmf-ticker
                            dptf-decimals
                            false
                            false
                            true
                            false
                            false
                            false
                            true
                        )
                    )
                )
                (DPTF-DPMF|C_DeployAccount dptf VST|SC_NAME true)
                (DPTF-DPMF|C_DeployAccount dpmf VST|SC_NAME false)
                (DPTF|C_ToggleFeeExemptionRole patron dptf VST|SC_NAME true)
                (DPMF|C_MoveCreateRole patron dpmf VST|SC_NAME)
                (DPMF|C_ToggleAddQuantityRole patron dpmf VST|SC_NAME true)
                (DPTF-DPMF|C_ToggleBurnRole patron dpmf VST|SC_NAME true false)
                (DPTF-DPMF|C_ToggleTransferRole patron dpmf VST|SC_NAME true false)
                (VST|X_DefineVestingPair patron dptf dpmf)
                dpmf
            )
        )
    )
    ;;8.2.4]  [V]   VST Aux Functions
    (defun VST|X_DefineVestingPair (patron:string dptf:string dpmf:string)
        @doc "Defines an immutable vesting connection between a DPTF and a DPMF Token"
        (require-capability (VST|DEFINE))
        (let
            (
                (ZG:bool (GAS|UC_SubZero))
                (dptf-owner:string (DPTF-DPMF|UR_Konto dptf true))
            )
            (with-capability (DPTF-DPMF|UPDATE_VESTING patron dptf dpmf)
                (if (= ZG false)
                    (GAS|X_Collect patron dptf-owner UTILITY.GAS_BIGGEST)
                    true
                )
                (DPTF-DPMF|X_UpdateVesting dptf dpmf)
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
)

(create-table DALOS|PropertiesTable)
(create-table DALOS|PricesTable)
(create-table DALOS|AccountTable)
(create-table DPTF|PropertiesTable)
(create-table DPTF|BalanceTable)
(create-table GAS|PropertiesTable)
(create-table DPMF|PropertiesTable)
(create-table DPMF|BalanceTable)
(create-table ATS|Pairs)
(create-table ATS|Ledger)