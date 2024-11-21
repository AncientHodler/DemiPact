


(module DEMI_001 GOVERNANCE
    (use UTILITY)
;;  0]GOVERNANCE Capabilitis:
    (defcap GOVERNANCE ()
        ;true
        (compose-capability (DEMIURGOI))
    )
    ;;Contract Guards
    (defconst G_DEMIURGOI   (keyset-ref-guard DALOS|DEMIURGOI))
    (defconst G_DPTF        (keyset-ref-guard DPTF|SC_KEY))
    (defconst G_GAS         (keyset-ref-guard GAS|SC_KEY))
    (defconst G_LIQUID      (keyset-ref-guard LIQUID|SC_KEY))
    (defconst G_ATS         (keyset-ref-guard ATS|SC_KEY))
    (defconst G_VST         (keyset-ref-guard VST|SC_KEY))

    (defcap DEMIURGOI ()
        (enforce-guard G_DEMIURGOI)
    )
    (defcap OUROBOROS ()
        (enforce-guard (UTILITY.GUARD|Any [G_DEMIURGOI G_DPTF]))
    )
    (defcap GAS_TANKER ()
        (enforce-guard (UTILITY.GUARD|Any [G_DEMIURGOI G_GAS]))
    )
    (defcap LIQUID_STAKING ()
        (enforce-guard (UTILITY.GUARD|Any [G_DEMIURGOI G_LIQUID]))
    )
    (defcap AUTOSTAKE ()
        (enforce-guard (UTILITY.GUARD|Any [G_DEMIURGOI G_ATS]))
    )
    (defcap VESTING ()
        (enforce-guard (UTILITY.GUARD|Any [G_DEMIURGOI G_VST]))
    )

    (defcap COMPOSE ()
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
        standard:decimal
        smart:decimal
        dptf:decimal
        dpmf:decimal
        dpsf:decimal
        dpnf:decimal
        blue:decimal
    )
    (defschema DALOS|AccountSchema
        ;;==================================;;
        guard:guard                         ;;Guard of the DALOS Account
        kadena-konto:string                 ;;stores the underlying Kadena principal Account that was used to create the DALOS Account
                                            ;;this account is used for KDA payments. The guard for this account is not stored in this module
                                            ;;Rather the guard of the kadena account saved here, is stored in the table inside the coin module
        sovereign:string                    ;;Stores the Sovereign Account (Can only be a Standard DALOS Account)
                                            ;;The Sovereign Account, is the Account that has ownership of this Account;
                                            ;;For Normal DALOS Account, the Sovereign is itself (The Key of the Table Data)
                                            ;;For Smart DALOS Account, the Sovereign is another Normal DALOS Account
        governor:string                     ;;Stores the Governing Module String.
        ;;==================================;;
        smart-contract:bool                 ;;When true DALOS Account is a Smart DALOS Account, if <false> it is a Standard DALOS Account
        payable-as-smart-contract:bool      ;;when true, a Smart DALOS Account is payable by other Normal DALOS Accounts
        payable-by-smart-contract:bool      ;;when true, a Smart DALOS Account is payable by other Smart DALOS Accounts
        payable-by-method:bool              ;;when true, a Smart DALOS Account is payable only through special Functions
        ;;==================================;;
        nonce:integer                       ;;stores how many transactions the DALOS Account executed
        elite:object{DALOS|EliteSchema}
                                            ;;Primal DPTF Data
                                            ;;Ouroboros and Gas Info are stored at the DALOS Account Level
        ;ouroboros:object{DPTF|BalanceSchema}
        ;ignis:object{DPTF|BalanceSchema}
        ;;==================================;;
    )
    (defschema DALOS|EliteSchema
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
        @doc "Key = DPTF Token id"
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
        @doc "Key = <DPTF id> + UTILS.BAR + <account>"
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
        @doc "Key = DPMF Token id"
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
        @doc "Key = <DPMF id> + UTILS.BAR + <account>"
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
        nonce:integer
        balance:decimal
    )
    ;;[G] GAS Schemas
    (defschema GAS|PropertiesSchema
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
        @doc "Key = ATS-Pair> + UTILS.BAR + <account>"
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
    (defun DPTF|KEYS:[string] ()
        (keys DPTF|BalanceTable)
    )
    (defun DPMF|KEYS:[string] ()
        (keys DPMF|BalanceTable)
    )
    (defun ATS|KEYS:[string] ()
        (keys ATS|Ledger)
    )
    ;;========[D] CAPABILITIES=================================================;;
    ;;1.1]    [D] DALOS Capabilities
    ;;1.1.1]  [D]   DALOS Basic Capabilities
    (defcap DALOS|EXIST (account:string)
        (DALOS.DALOS|UEV_EnforceAccountExists account)
    )
    (defcap DALOS|ACCOUNT_OWNER (account:string)
        (enforce-guard (DALOS|UR_AccountGuard account))
    )
    (defcap DALOS|ABS_ACCOUNT_OWNER (account:string)
        (DALOS|CAP_EnforceAccountOwnership account)
    )
    (defun DALOS|CAP_EnforceAccountOwnership (account:string)
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
        (let
            (
                (sovereign:string (DALOS|UR_AccountSovereign account))
                (governor:string (DALOS|UR_AccountGovernor account))
            )
            (enforce (= sovereign account) "Incompatible Sovereign for Standard DALOS Account")
            (enforce (= governor UTILS.BAR) "Incompatible Governer for Standard DALOS Account")
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
            ;(enforce (!= governor UTILS.BAR) "Incompatible Governor for Smart DALOS Account")
            (enforce-one
                "Insuficient Permissions to handle a Smart DALOS Account"
                [
                    (enforce-guard (DALOS|UR_AccountGuard account))
                    (enforce (= gov (take lengov (at 0 (at "exec-code" (read-msg))))) "Enforce Smart Contract Governance Module Usage")
                ]
            )
        )
    )
    (defun DALOS|Enforce_AccountType (account:string smart:bool)
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
    (defcap DALOS|IZ_ACCOUNT_SMART (account:string smart:bool)
        (DALOS|Enforce_AccountType account smart)
    )
    
    (defcap DALOS|TRANSFERABILITY (sender:string receiver:string)
        (compose-capability (DALOS|METHODIC_TRANSFERABILITY sender receiver false))
    )
    (defcap DALOS|METHODIC_TRANSFERABILITY (sender:string receiver:string method:bool)
        (let
            (
                (x:bool (DALOS|UC_MethodicTransferability sender receiver method))
            )
            (enforce (= x true) (format "Transferability between {} and {} with {} Method is not ensured" [sender receiver method]))
        )
    )
    (defcap DALOS|INCREASE-NONCE ()
        true
    )
    (defcap DALOS|UPDATE_ELITE ()
        true
    )
    (defcap DALOS|EXECUTOR ()
        true
    )
    ;;1.1.2]  [D]   DALOS Composed Capabilities
    (defcap DALOS|METHODIC (client:string method:bool)
        (if (= method true)
            (DALOS|Enforce_AccountType client true)
            (DALOS|CAP_EnforceAccountOwnership client)
        )
    )
    ;;First Part
    (defcap DALOS|ROTATE_ACCOUNT (patron:string account:string)
        (compose-capability (DALOS|ABS_ACCOUNT_OWNER account))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DALOS|ROTATE_SOVEREIGN (patron:string account:string new-sovereign:string)
        (compose-capability (DALOS|SOVEREIGN account new-sovereign))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DALOS|SOVEREIGN (account:string new-sovereign:string)
        (compose-capability (DALOS|ABS_ACCOUNT_OWNER account)) 
        (DALOS|Enforce_AccountType account true)
        (DALOS|Enforce_AccountType new-sovereign false)
        (DALOS|UV_SenderWithReceiver (DALOS|UR_AccountSovereign account) new-sovereign)
    )
    (defcap DALOS|ROTATE_GOVERNOR (patron:string account:string)
        (compose-capability (DALOS|GOVERNOR account))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DALOS|GOVERNOR (account:string)
        (DALOS|CAP_EnforceAccountOwnership account)
        (DALOS|Enforce_AccountType account true)
    )
    ;;Second Part
    (defcap DALOS|CONTROL_SMART-ACCOUNT (patron:string account:string pasc:bool pbsc:bool pbm:bool)
        (compose-capability (DALOS|CONTROL_SMART-ACCOUNT_CORE account pasc pbsc pbm))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DALOS|CONTROL_SMART-ACCOUNT_CORE (account:string pasc:bool pbsc:bool pbm:bool)
        (compose-capability (DALOS|GOVERNOR account))
        (enforce (= (or (or pasc pbsc) pbm) true) "At least one Smart DALOS Account parameter must be true")
    )
    ;;========[D] FUNCTIONS====================================================;;
    ;;1.2]    [D] DALOS Functions
    ;;1.2.1]  [D]   DALOS Utility Functions
    ;;1.2.1.0][D]           Properties Info
    (defun DALOS|UR_UnityID:string ()
        (at "unity-id" (read DALOS|PropertiesTable DALOS|INFO ["unity-id"]))
    )
    (defun DALOS|UR_OuroborosID:string ()
        (at "gas-source-id" (read DALOS|PropertiesTable DALOS|INFO ["gas-source-id"]))
    )
    (defun DALOS|UR_OuroborosPrice:decimal ()
        (at "gas-source-id-price" (read DALOS|PropertiesTable DALOS|INFO ["gas-source-id-price"]))
    )
    (defun DALOS|UR_IgnisID:string ()
        (with-default-read DALOS|PropertiesTable DALOS|INFO 
            { "gas-id" :  UTILS.BAR }
            { "gas-id" := gas-id}
            gas-id
        )
    )
    (defun DALOS|UR_AurynID:string ()
        (at "ats-gas-source-id" (read DALOS|PropertiesTable DALOS|INFO ["ats-gas-source-id"]))
    )
    (defun DALOS|UR_EliteAurynID:string ()
        (at "elite-ats-gas-source-id" (read DALOS|PropertiesTable DALOS|INFO ["elite-ats-gas-source-id"]))
    )
    (defun DALOS|UR_WrappedKadenaID:string ()
        (at "wrapped-kda-id" (read DALOS|PropertiesTable DALOS|INFO ["wrapped-kda-id"]))
    )
    (defun DALOS|UR_LiquidKadenaID:string ()
        (at "liquid-kda-id" (read DALOS|PropertiesTable DALOS|INFO ["liquid-kda-id"]))
    )
    ;;1.2.1.1][D]           Account Info
    (defun DALOS|UR_AccountGuard:guard (account:string)
        (at "guard" (read DALOS|AccountTable account ["guard"]))
    )
    (defun DALOS|UR_AccountProperties:[bool] (account:string)
        (UTILITY.DALOS|UV_Account account)
        (with-default-read DALOS|AccountTable account
            { "smart-contract" : false, "payable-as-smart-contract" : false, "payable-by-smart-contract" : false, "payable-by-method" : false}
            { "smart-contract" := sc, "payable-as-smart-contract" := pasc, "payable-by-smart-contract" := pbsc, "payable-by-method" := pbm }
            [sc pasc pbsc pbm]
        )
    )
    (defun DALOS|UR_AccountType:bool (account:string)
        (at 0 (DALOS|UR_AccountProperties account))
    )
    (defun DALOS|UR_AccountPayableAs:bool (account:string)
        (at 1 (DALOS|UR_AccountProperties account))
    )
    (defun DALOS|UR_AccountPayableBy:bool (account:string)
        (at 2 (DALOS|UR_AccountProperties account))
    )
    (defun DALOS|UR_AccountPayableByMethod:bool (account:string)
        (at 3 (DALOS|UR_AccountProperties account))
    )
    (defun DALOS|UR_AccountNonce:integer (account:string)
        (UTILITY.DALOS|UV_Account account)
        (with-default-read DALOS|AccountTable account
            { "nonce" : 0 }
            { "nonce" := n }
            n
        )
    )
    (defun DALOS|UR_AccountSovereign:string (account:string)
        (at "sovereign" (read DALOS|AccountTable account ["sovereign"]))
    )
    (defun DALOS|UR_AccountGovernor:string (account:string)
        (at "governor" (read DALOS|AccountTable account ["governor"]))
    )
    (defun DALOS|UR_AccountKadena:string (account:string)
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
    ;;1.2.1.2][D]           Dalos Price Info
    (defun DALOS|UR_Standard:decimal ()
        (at "standard" (read DALOS|PricesTable DALOS|PRICES ["standard"]))
    )
    (defun DALOS|UR_Smart:decimal ()
        (at "smart" (read DALOS|PricesTable DALOS|PRICES ["smart"]))
    )
    (defun DALOS|UR_True:decimal ()
        (at "dptf" (read DALOS|PricesTable DALOS|PRICES ["dptf"]))
    )
    (defun DALOS|UR_Meta:decimal ()
        (at "dpmf" (read DALOS|PricesTable DALOS|PRICES ["dpmf"]))
    )
    (defun DALOS|UR_Semi:decimal ()
        (at "dpsf" (read DALOS|PricesTable DALOS|PRICES ["dpsf"]))
    )
    (defun DALOS|UR_Non:decimal ()
        (at "dpnf" (read DALOS|PricesTable DALOS|PRICES ["dpnf"]))
    )
    (defun DALOS|UR_Blue:decimal ()
        (at "blue" (read DALOS|PricesTable DALOS|PRICES ["blue"]))
    )
    ;;1.2.1.3][D]           Computing
    (defun DALOS|UC_MethodicTransferability:bool (sender:string receiver:string method:bool)
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
        (DALOS|UC_MethodicTransferability sender receiver false)
    )
    (defun DALOS|UC_Makeid:string (ticker:string)
        (UTILITY.DALOS|UV_Ticker ticker)
        (UTILITY.DALOS|UC_Makeid ticker)
    )
    ;;1.2.1.4][D]           Validations
    (defun DALOS.DALOS|UEV_EnforceAccountExists (dalos-account:string)
        (UTILITY.DALOS|UV_Account dalos-account)
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
        (DALOS.DALOS|UEV_EnforceAccountExists sender)
        (DALOS.DALOS|UEV_EnforceAccountExists receiver)
        (enforce (!= sender receiver) "Sender and Receiver must be different")
    )
    ;;1.2.2]  [D]   DALOS Administration Functions
    (defun DALOS|A_UpdateStandard (price:decimal)
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"standard" : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateSmart(price:decimal)
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"smart"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateTrue(price:decimal)
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"dptf"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateMeta(price:decimal)
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"dpmf"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateSemi(price:decimal)
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"dpsf"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateNon(price:decimal)
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"dpnf"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    (defun DALOS|A_UpdateBlue(price:decimal)
        (with-capability (DEMIURGOI)
            (update DALOS|PricesTable DALOS|PRICES
                {"blue"     : (floor price UTILITY.KDA_PRECISION)}
            )
        )
    )
    ;;1.2.3]  [D]   DALOS Client Functions
    ;;1.2.3.1][D]           Control
    (defun DALOS|C_DeployStandardAccount (account:string guard:guard kadena:string)
        (UTILITY.DALOS|UV_Account account)
        (UTILITY.DALOS|UV_EnforceReserved account guard)
        (enforce-guard guard)

        (insert DALOS|AccountTable account
            { "guard"                       : guard
            , "kadena-konto"                : kadena
            , "sovereign"                   : account
            , "governor"                    : UTILS.BAR

            , "smart-contract"              : false
            , "payable-as-smart-contract"   : false
            , "payable-by-smart-contract"   : false
            , "payable-by-method"           : false
            
            , "nonce"                       : 0
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
        (UTILITY.DALOS|UV_Account account)
        (UTILITY.DALOS|UV_Account sovereign)
        (UTILITY.DALOS|UV_EnforceReserved account guard)
        (enforce-guard guard)
        
        (with-capability (DALOS|IZ_ACCOUNT_SMART sovereign false)
            (insert DALOS|AccountTable account
                { "guard"                       : guard
                , "kadena-konto"                : kadena
                , "sovereign"                   : sovereign
                , "governor"                    : UTILS.BAR

                , "smart-contract"              : true
                , "payable-as-smart-contract"   : false
                , "payable-by-smart-contract"   : false
                , "payable-by-method"           : true
                
                , "nonce"                       : 0
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
    ;;Part 1
    (defun DALOS|C_RotateGuard (patron:string account:string new-guard:guard safe:bool)
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
    (defun DALOS|C_RotateKadena (patron:string account:string kadena:string)
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
    (defun DALOS|C_RotateSovereign (patron:string account:string new-sovereign:string)
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
    (defun DALOS|C_UpdateSmartAccountGovernor (patron:string account:string governor:string)
        (let
            (
                (ZG:bool (GAS|UC_SubZero))
            )
            (with-capability (DALOS|ROTATE_GOVERNOR patron account)
                (if (= ZG false)
                    (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                    true
                )
                (DALOS|X_RotateGovernor account governor)
                (DALOS|X_IncrementNonce patron)
            )
        )
    )
    ;;Part 2
    (defun DALOS|C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool)
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
    
    ;;1.2.4]  [D]   DALOS Auxiliary Functions
    (defun DALOS|X_RotateGuard (account:string new-guard:guard safe:bool)
        (require-capability (DALOS|ABS_ACCOUNT_OWNER account))
        (if safe
            (enforce-guard new-guard)
            true
        )
        (update DALOS|AccountTable account
            {"guard"                        : new-guard}
        )
    )
    (defun DALOS|X_RotateKadena (account:string kadena:string)
        (require-capability (DALOS|ABS_ACCOUNT_OWNER account))
        (update DALOS|AccountTable account
            {"kadena-konto"                  : kadena}
        )
    )
    (defun DALOS|X_RotateSovereign (account:string new-sovereign:string)
        (require-capability (DALOS|SOVEREIGN account new-sovereign))
        (update DALOS|AccountTable account
            {"sovereign"                        : new-sovereign}
        )
    )
    (defun DALOS|X_RotateGovernor (account:string governor:string)
        (require-capability (DALOS|GOVERNOR account))
        (update DALOS|AccountTable account
            {"governor"                        : governor}
        )
    )
    (defun DALOS|X_UpdateSmartAccountParameters (account:string pasc:bool pbsc:bool pbm:bool)
        (require-capability (DALOS|CONTROL_SMART-ACCOUNT_CORE account pasc pbsc pbm))
        (update DALOS|AccountTable account
            {"payable-as-smart-contract"    : pasc
            ,"payable-by-smart-contract"    : pbsc
            ,"payable-by-method"            : pbm}
        )
    )
    (defun DALOS|X_IncrementNonce (client:string)
        (require-capability (DALOS|INCREASE-NONCE))
        (with-read DALOS|AccountTable client
            { "nonce"                       := n }
            (update DALOS|AccountTable client { "nonce" : (+ n 1)})
        )
    )
    (defun DALOS|X_UpdateElite (account:string)
        (require-capability (DALOS|UPDATE_ELITE))
        (if (= (DALOS|UR_AccountType account) false)
            (update DALOS|AccountTable account
                { "elite" : (UTILITY.ATS|UCC_Elite (DALOS|UR_EliteAurynzSupply account))}
            )
            true
        )
    )
    (defun DALOS|UR_EliteAurynzSupply (account:string)
        (if (!= (DALOS|UR_EliteAurynID) UTILS.BAR)
            (let
                (
                    (ea-supply:decimal (DPTF-DPMF|UR_AccountSupply (DALOS|UR_EliteAurynID) account true))
                    (vea:string (DPTF-DPMF|UR_Vesting (DALOS|UR_EliteAurynID) true))
                )
                (if (!= vea UTILS.BAR)
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
    (defun DPTF-DPMF|Owner (id:string token-type:bool)
        (DALOS|CAP_EnforceAccountOwnership (DPTF-DPMF|UR_Konto id token-type))
    )
    (defcap DPTF-DPMF|OWNER (id:string token-type:bool)
        (DPTF-DPMF|Owner id token-type)
    )
    (defun DPTF-DPMF|CanChangeOwnerON (id:string token-type:bool)
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanChangeOwner id token-type))
            )
            (enforce (= x true) (format "DPTF|DPMF Token {} ownership cannot be changed" [id]))
        )
    )
    (defun DPTF-DPMF|CanUpgradeON (id:string token-type:bool)
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanUpgrade id token-type))
            )
            (enforce (= x true) (format "DPTF|DPMF Token {} properties cannot be upgraded" [id])
            )
        )
    )
    (defun DPTF-DPMF|CanAddSpecialRoleON (id:string token-type:bool)
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanAddSpecialRole id token-type))
            )
            (enforce (= x true) (format "For DPTF|DPMF Token {} no special roles can be added" [id])
            )
        )
    )
    (defun DPTF-DPMF|CanFreezeON (id:string token-type:bool)
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanFreeze id token-type))
            )
            (enforce (= x true) (format "DPTF|DPMF Token {} cannot be freezed" [id])
            )
        )
    )
    (defun DPTF-DPMF|CanWipeON (id:string token-type:bool)
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanWipe id token-type))
            )
            (enforce (= x true) (format "DPTF|DPMF Token {} cannot be wiped" [id])
            )
        )
    )
    (defun DPTF-DPMF|CanPauseON (id:string token-type:bool)
        (let
            (
                (x:bool (DPTF-DPMF|UR_CanPause id token-type))
            )
            (enforce (= x true) (format "DPTF|DPMF Token {} cannot be paused" [id])
            )
        )
    )
    (defun DPTF-DPMF|PauseState (id:string state:bool token-type:bool)
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
        true
    )
    (defcap DPTF-DPMF|UPDATE_ROLE-TRANSFER-AMOUNT ()
        true
    )
    (defcap DPTF|INCREMENT-LOCKS ()
        true
    )
    ;;2.1.1.2][TM]          DPTF-DPMF <DPTF|BalanceTable>|<DPTF|BalanceTable> Table Management
    (defun DPTF-DPMF|AccountBurnState (id:string account:string state:bool token-type:bool)
        (let
            (
                (x:bool (DPTF-DPMF|UR_AccountRoleBurn id account token-type))
            )
            (enforce (= x state) (format "Burn Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    (defcap DPTF-DPMF|ACCOUNT_TRANSFER_STATE (id:string account:string state:bool token-type:bool)
        (let
            (
                (x:bool (DPTF-DPMF|UR_AccountRoleTransfer id account token-type))
            )
            (enforce (= x state) (format "Transfer Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    (defun DPTF-DPMF|AccountFreezeState (id:string account:string state:bool token-type:bool)
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
        (compose-capability (DPTF-DPMF|OWNERSHIP-CHANGE_CORE id new-owner token-type))
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto id token-type) UTILITY.GAS_BIGGEST))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF-DPMF|OWNERSHIP-CHANGE_CORE (id:string new-owner:string token-type:bool)
        (DALOS|UV_SenderWithReceiver (DPTF-DPMF|UR_Konto id token-type) new-owner)
        (DPTF-DPMF|Owner id token-type)
        (DPTF-DPMF|CanChangeOwnerON id token-type)
        (DALOS.DALOS|UEV_EnforceAccountExists new-owner)
    )
    (defcap DPTF-DPMF|CONTROL (patron:string id:string token-type:bool)
        (compose-capability (DPTF-DPMF|CONTROL_CORE id token-type))
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto id token-type) UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE)) 
    )
    (defcap DPTF-DPMF|CONTROL_CORE (id:string token-type:bool)
        (DPTF-DPMF|Owner id token-type)
        (DPTF-DPMF|CanUpgradeON id token-type)
    )
    (defcap DPTF-DPMF|TOGGLE_PAUSE (patron:string id:string pause:bool token-type:bool)
        (compose-capability (DPTF-DPMF|TOGGLE_PAUSE_CORE id pause token-type))
        (compose-capability (GAS|COLLECTION patron patron UTILITY.GAS_MEDIUM))
        (compose-capability (DALOS|INCREASE-NONCE)) 
    )
    (defcap DPTF-DPMF|TOGGLE_PAUSE_CORE (id:string pause:bool token-type:bool)
        (if pause
            (DPTF-DPMF|CanPauseON id token-type)
            true
        )
        (DPTF-DPMF|Owner id token-type)
        (DPTF-DPMF|PauseState id (not pause) token-type)
    )
    (defcap DPTF-DPMF|FROZEN-ACCOUNT (patron:string id:string account:string frozen:bool token-type:bool)
        (compose-capability (DPTF-DPMF|FROZEN-ACCOUNT_CORE id account frozen token-type))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_BIG))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF-DPMF|FROZEN-ACCOUNT_CORE (id:string account:string frozen:bool token-type:bool)
        (DPTF-DPMF|Owner id token-type)
        (DPTF-DPMF|CanFreezeON id token-type)
        (DPTF-DPMF|AccountFreezeState id account (not frozen) token-type)
    )
    ;;2.1.2.2][TM]          Token Roles
    (defcap DPTF-DPMF|TOGGLE_BURN-ROLE (patron:string id:string account:string toggle:bool token-type:bool)
        (compose-capability (DPTF-DPMF|TOGGLE_BURN-ROLE_CORE id account toggle token-type))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF-DPMF|TOGGLE_BURN-ROLE_CORE (id:string account:string toggle:bool token-type:bool)
        (if (= toggle true)
            (DPTF-DPMF|CanAddSpecialRoleON id token-type)
            true
        )
        (DPTF-DPMF|Owner id token-type)
        (DPTF-DPMF|AccountBurnState id account (not toggle) token-type)
    )
    (defcap DPTF-DPMF|TOGGLE_TRANSFER-ROLE (patron:string id:string account:string toggle:bool token-type:bool)
        (compose-capability (DPTF-DPMF|TOGGLE_TRANSFER-ROLE_CORE id account toggle token-type))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DPTF-DPMF|UPDATE_ROLE-TRANSFER-AMOUNT))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF-DPMF|TOGGLE_TRANSFER-ROLE_CORE (id:string account:string toggle:bool token-type:bool)
        (enforce (!= account DPTF|SC_NAME) (format "{} Account is immune to transfer roles" [DPTF|SC_NAME]))
        (enforce (!= account GAS|SC_NAME) (format "{} Account is immune to transfer roles" [GAS|SC_NAME]))
        (if (= toggle true)
            (DPTF-DPMF|CanAddSpecialRoleON id token-type)
            true
        )
        (DPTF-DPMF|Owner id token-type)
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
        (DPTF-DPMF|Owner dptf true)
        (DPTF-DPMF|Owner dpmf false)
        (VST|Active dptf dpmf)
        (let
            (
                (tf-vesting-id:string (DPTF-DPMF|UR_Vesting dptf true))
                (mf-vesting-id:string (DPTF-DPMF|UR_Vesting dpmf false))
                (iz-hot-rbt:bool (ATS|UC_IzRBT-Absolute dpmf false))
            )
            (enforce 
                (and (= tf-vesting-id UTILS.BAR) (= mf-vesting-id UTILS.BAR) )
                "Vesting Pairs are immutable !"
            )
            (enforce (= iz-hot-rbt false) "A DPMF defined as a hot-rbt cannot be used as Vesting Token in Vesting pair")
        )
    )
    ;;2.1.2.3][TM]          Create
    (defcap DPTF-DPMF|ISSUE (patron:string client:string token-type:bool issue-size:integer)
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
            (if (!= (DALOS|UR_IgnisID) UTILS.BAR)
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
        (compose-capability (DALOS|METHODIC client method))
        (compose-capability (GAS|MATRON_SOFT patron id client UTILITY.GAS_SMALL))
        (compose-capability (DPTF-DPMF|BURN_CORE id client amount token-type))
        (compose-capability (DALOS|INCREASE-NONCE))
        (compose-capability (DALOS|EXECUTOR))
    )
    (defcap DPTF-DPMF|BURN_CORE (id:string client:string amount:decimal token-type:bool)
        (DPTF-DPMF|UV_Amount id amount token-type)
        (DPTF-DPMF|AccountBurnState id client true token-type)
        (compose-capability (DPTF-DPMF|DEBIT id client token-type))
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
    )
    (defcap DPTF-DPMF|WIPE (patron:string id:string account-to-be-wiped:string token-type:bool)
        (compose-capability (GAS|MATRON_SOFT patron id account-to-be-wiped UTILITY.GAS_BIGGEST))
        (compose-capability (DPTF-DPMF|WIPE_CORE id account-to-be-wiped token-type))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF-DPMF|WIPE_CORE (id:string account-to-be-wiped:string token-type:bool)
        (DPTF-DPMF|Owner id token-type)
        (DPTF-DPMF|CanWipeON id token-type)
        (DPTF-DPMF|AccountFreezeState id account-to-be-wiped true token-type)
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
    )
    ;;2.1.2.4][TM]          Transfer
    (defcap DPTF-DPMF|TRANSFER (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool token-type:bool)
        (compose-capability (DALOS|EXECUTOR))
        (if (= method false)
            (compose-capability (DALOS|ABS_ACCOUNT_OWNER sender))
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
        (DPTF-DPMF|UV_Amount id transfer-amount token-type)
        (DALOS|UV_SenderWithReceiver sender receiver)
        (DPTF-DPMF|PauseState id false token-type)
        (DPTF-DPMF|AccountFreezeState id sender false token-type)
        (DPTF-DPMF|AccountFreezeState id receiver false token-type)
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
        (compose-capability (DPTF-DPMF|CREDIT id GAS|SC_NAME true))
        (compose-capability (DPTF|UPDATE_FEES))
        (compose-capability (DPTF|CREDIT_PRIMARY-FEE))
        (compose-capability (DPTF|TRANSMUTE_CORE id))
    )
    (defcap DPTF|TRANSMUTE_CORE (id:string)
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
        (compose-capability (DPTF-DPMF|CREDIT-DEBIT id account token-type))
    )
    (defcap DPTF-DPMF|DEBIT (id:string account:string token-type:bool)
        (compose-capability (DPTF-DPMF|CREDIT-DEBIT id account token-type))
    )
    (defcap DPTF-DPMF|CREDIT-DEBIT (id:string account:string token-type:bool)
        (DPTF-DPMF|UVE_id id token-type)
        (DALOS.DALOS|UEV_EnforceAccountExists account)
    )
    (defcap DPTF|TRANSMUTE (patron:string id:string transmuter:string)
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
        (compose-capability (DPTF|CPF_CREDIT-FEE))
        (compose-capability (DPTF|CPF_STILL-FEE))
        (compose-capability (DPTF|CPF_BURN-FEE))
        (compose-capability (ATS|UPDATE_ROU))
    )
    (defcap DPTF|CPF_CREDIT-FEE ()
        true
    )
    (defcap DPTF|CPF_STILL-FEE ()
        true
    )
    (defcap DPTF|CPF_BURN-FEE ()
        true
    )
    ;;========[TM]FUNCTIONS====================================================;;
    ;;2.2]    [TM]DPTF-DPMF Functions
    ;;2.2.1]  [TM]  DPTF-DPMF Utility Functions
    ;;2.2.1.1][TM]          Account Info          Account Info
    (defun DPTF-DPMF|UR_AccountExist:bool (id:string account:string token-type:bool)
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id token-type)
        (if (= token-type true)
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
    (defun DPTF-DPMF|UR_AccountSupply:decimal (id:string account:string token-type:bool)
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id token-type)
        (if (= token-type true)
            (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "balance" : 0.0 }
                { "balance" := b}
                b
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
    (defun DPTF-DPMF|UR_AccountRoleBurn:bool (id:string account:string token-type:bool)
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id token-type)
        (if (= token-type true)
            (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "role-burn" : false}
                { "role-burn" := rb }
                rb
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
                { "role-nft-burn" : false}
                { "role-nft-burn" := rb }
                rb
            )
        )
    )
    (defun DPTF-DPMF|UR_AccountRoleTransfer:bool (id:string account:string token-type:bool)
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id token-type)
        (if (= token-type true)
            (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "role-transfer" : false}
                { "role-transfer" := rt }
                rt
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
                { "role-transfer" : false }
                { "role-transfer" := rt }
                rt
            )
        )
    )
    ;;2.2.1.2][TM]          True|Meta-Fungible Info
    (defun DPTF-DPMF|UR_Konto:string (id:string token-type:bool)
        (if (= token-type true)
            (at "owner-konto" (read DPTF|PropertiesTable id ["owner-konto"]))
            (at "owner-konto" (read DPMF|PropertiesTable id ["owner-konto"]))
        )
    )
    (defun DPTF-DPMF|UR_Name:string (id:string token-type:bool)
        (if (= token-type true)
            (at "name" (read DPTF|PropertiesTable id ["name"]))
            (at "name" (read DPMF|PropertiesTable id ["name"]))
        )
    )
    (defun DPTF-DPMF|UR_Ticker:string (id:string token-type:bool)
        (if (= token-type true)
            (at "ticker" (read DPTF|PropertiesTable id ["ticker"]))
            (at "ticker" (read DPMF|PropertiesTable id ["ticker"]))   
        )
    )
    (defun DPTF-DPMF|UR_Decimals:integer (id:string token-type:bool)
        (if (= token-type true)
            (at "decimals" (read DPTF|PropertiesTable id ["decimals"]))
            (at "decimals" (read DPMF|PropertiesTable id ["decimals"]))
        )
    )
    (defun DPTF-DPMF|UR_CanChangeOwner:bool (id:string token-type:bool)
        (if (= token-type true)
            (at "can-change-owner" (read DPTF|PropertiesTable id ["can-change-owner"]))
            (at "can-change-owner" (read DPMF|PropertiesTable id ["can-change-owner"]))
        )
    )
    (defun DPTF-DPMF|UR_CanUpgrade:bool (id:string token-type:bool)
        (if (= token-type true)
            (at "can-upgrade" (read DPTF|PropertiesTable id ["can-upgrade"]))
            (at "can-upgrade" (read DPMF|PropertiesTable id ["can-upgrade"]))
        )   
    )
    (defun DPTF-DPMF|UR_CanAddSpecialRole:bool (id:string token-type:bool)
        (if (= token-type true)
            (at "can-add-special-role" (read DPTF|PropertiesTable id ["can-add-special-role"]))
            (at "can-add-special-role" (read DPMF|PropertiesTable id ["can-add-special-role"]))
        )
    )
    (defun DPTF-DPMF|UR_CanFreeze:bool (id:string token-type:bool)
        (if (= token-type true)
            (at "can-freeze" (read DPTF|PropertiesTable id ["can-freeze"]))
            (at "can-freeze" (read DPMF|PropertiesTable id ["can-freeze"]))
        )
    )
    (defun DPTF-DPMF|UR_CanWipe:bool (id:string token-type:bool)
        (if (= token-type true)
            (at "can-wipe" (read DPTF|PropertiesTable id ["can-wipe"]))
            (at "can-wipe" (read DPMF|PropertiesTable id ["can-wipe"]))
        )
    )
    (defun DPTF-DPMF|UR_CanPause:bool (id:string token-type:bool)
        (if (= token-type true)
            (at "can-pause" (read DPTF|PropertiesTable id ["can-pause"]))
            (at "can-pause" (read DPMF|PropertiesTable id ["can-pause"]))
        )
    )
    (defun DPTF-DPMF|UR_Paused:bool (id:string token-type:bool)
        (if (= token-type true)
            (at "is-paused" (read DPTF|PropertiesTable id ["is-paused"]))
            (at "is-paused" (read DPMF|PropertiesTable id ["is-paused"]))
        )
    )
    (defun DPTF-DPMF|UR_Supply:decimal (id:string token-type:bool)
        (if (= token-type true)
            (at "supply" (read DPTF|PropertiesTable id ["supply"]))
            (at "supply" (read DPMF|PropertiesTable id ["supply"]))
        )
    )
    (defun DPTF-DPMF|UR_TransferRoleAmount:integer (id:string token-type:bool)
        (if (= token-type true)
            (at "role-transfer-amount" (read DPTF|PropertiesTable id ["role-transfer-amount"]))
            (at "role-transfer-amount" (read DPMF|PropertiesTable id ["role-transfer-amount"]))
        )
    )
    (defun DPTF-DPMF|UR_Vesting:string (id:string token-type:bool)
        (if (= token-type true)
            (at "vesting" (read DPTF|PropertiesTable id ["vesting"]))
            (at "vesting" (read DPMF|PropertiesTable id ["vesting"]))
        )
    )
    ;;2.2.1.3][TM]          Validations
    (defun DPTF-DPMF|UV_Amount (id:string amount:decimal token-type:bool)
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
        (DPTF-DPMF|UVE_id id token-type)
        (with-capability (DALOS|EXIST account)
            (if (= token-type true)
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
    )
    ;;2.2.2.4][TM]          Destroy
    (defun DPTF-DPMF|C_Wipe (patron:string id:string atbw:string token-type:bool)
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
        (require-capability (ATS|UPDATE_RBT id token-type))
        (if (= token-type true)
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
        (let
            (
                (ea-id:string (DALOS|UR_EliteAurynID))
            )
            (if (!= ea-id UTILS.BAR)
                (if (= id ea-id)
                    (with-capability (COMPOSE)
                        (DALOS|X_UpdateElite sender)
                        (DALOS|X_UpdateElite receiver)
                    )
                    (let
                        (
                            (v-ea-id:string (DPTF-DPMF|UR_Vesting ea-id true))
                        )
                        (if (and (!= v-ea-id UTILS.BAR)(= id v-ea-id))
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
            (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "frozen" : toggle}
            )
            (update DPMF|BalanceTable (concat [id UTILS.BAR account])
                { "frozen" : toggle}
            )
        )
    )
    (defun DPTF-DPMF|X_ToggleBurnRole (id:string account:string toggle:bool token-type:bool)
        (require-capability (DPTF-DPMF|TOGGLE_BURN-ROLE_CORE id account toggle token-type))
        (if (= token-type true)
            (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                {"role-burn" : toggle}
            )
            (update DPMF|BalanceTable (concat [id UTILS.BAR account])
                {"role-nft-burn" : toggle}
            )
        )
    )
    (defun DPTF-DPMF|X_ToggleTransferRole (id:string account:string toggle:bool token-type:bool)
        (require-capability (DPTF-DPMF|TOGGLE_TRANSFER-ROLE_CORE id account toggle token-type))
        (if (= token-type true)
            (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                {"role-transfer" : toggle}
            )
            (update DPMF|BalanceTable (concat [id UTILS.BAR account])
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
    (defun DPTF|Virgin (id:string)
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
    (defun DPTF|FeeLockState (id:string state:bool)
        (let
            (
                (x:bool (DPTF|UR_FeeLock id))
            )
            (enforce (= x state) (format "Fee-lock for {} must be set to {} for this operation" [id state]))
        )
    )
    (defun DPTF|FeeToggleState (id:string state:bool)
        (let
            (
                (x:bool (DPTF|UR_FeeToggle id))
            )
            (enforce (= x state) (format "Fee-Toggle for {} must be set to {} for this operation" [id state]))
        )
    )
    (defcap DPTF|UPDATE_FEES ()
        true
    )
    ;;3.1.1.2][T]           DPTF <DPTF|BalanceTable> Table Management
    (defun DPTF|AccountMintState (id:string account:string state:bool)
        (let
            (
                (x:bool (DPTF|UR_AccountRoleMint id account))
            )
            (enforce (= x state) (format "Mint Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    (defun DPTF|AccountFeeExemptionState (id:string account:string state:bool)
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
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL))
        (compose-capability (DPTF|TOGGLE_FEE_CORE id toggle))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|TOGGLE_FEE_CORE (id:string toggle:bool)
        (let
            (
                (fee-promile:decimal (DPTF|UR_FeePromile id))
            )
            (enforce (or (= fee-promile -1.0) (and (>= fee-promile 0.0) (<= fee-promile 1000.0))) "Please Set up Fee Promile before Turning Fee Collection on !")
            (UTILITY.DALOS|UV_Account (DPTF|UR_FeeTarget id))
            (DPTF-DPMF|Owner id true)
            (DALOS.DALOS|UEV_EnforceAccountExists (DPTF|UR_FeeTarget id))
            (DPTF|FeeLockState id false)
            (DPTF|FeeToggleState id (not toggle))
        )
    )
    (defcap DPTF|SET_MIN-MOVE (patron:string id:string min-move-value:decimal)
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL))
        (compose-capability (DPTF|SET_MIN-MOVE_CORE id min-move-value))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|SET_MIN-MOVE_CORE (id:string min-move-value:decimal)
        (let
            (
                (decimals:integer (DPTF-DPMF|UR_Decimals id true))
            )
            (enforce
                (= (floor min-move-value decimals) min-move-value)
                (format "The Minimum Transfer amount of {} does not conform with the {} DPTF Token decimals number" [min-move-value id])
            )
            (enforce (or (= min-move-value -1.0) (> min-move-value 0.0)) "Min-Move Value does not compute")
            (DPTF-DPMF|Owner id true)
            (DPTF|FeeLockState id false)
        )
    )
    (defcap DPTF|SET_FEE (patron:string id:string fee:decimal)
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL))
        (compose-capability (DPTF|SET_FEE_CORE id fee))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|SET_FEE_CORE (id:string fee:decimal)
        (UTILITY.DALOS|UV_Fee fee)
        (DPTF-DPMF|Owner id true)
        (DPTF|FeeLockState id false)
    )
    (defcap DPTF|SET_FEE-TARGET (patron:string id:string target:string)
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL))
        (compose-capability (DPTF|SET_FEE-TARGET_CORE id target))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|SET_FEE-TARGET_CORE (id:string target:string)
        (UTILITY.DALOS|UV_Account target)
        (DALOS.DALOS|UEV_EnforceAccountExists target)
        (DPTF-DPMF|Owner id true)
        (DPTF|FeeLockState id false) 
    )
    (defcap DPTF|TOGGLE_FEE-LOCK (patron:string id:string toggle:bool)
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
        (DPTF-DPMF|Owner id true)
        (DPTF|FeeLockState id (not toggle))
    )
    (defcap DPTF|WITHDRAW-FEES (patron:string id:string output-target-account:string)
        (UTILITY.DALOS|UV_Account output-target-account)
        (compose-capability (GAS|COLLECTION patron (DPTF-DPMF|UR_Konto id true) UTILITY.GAS_SMALL))
        (compose-capability (DPTF|WITHDRAW-FEES_CORE id output-target-account))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|WITHDRAW-FEES_CORE (id:string output-target-account:string)
        (DPTF-DPMF|Owner id true)
        (DALOS|Enforce_AccountType output-target-account false)
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
        (compose-capability (DPTF|TOGGLE_MINT-ROLE_CORE id account toggle))    
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|TOGGLE_MINT-ROLE_CORE (id:string account:string toggle:bool)
        (DPTF-DPMF|Owner id true)
        (if toggle
            (DPTF-DPMF|CanAddSpecialRoleON id true)
            true
        )
        (DPTF|AccountMintState id account (not toggle))
    )
    (defcap DPTF|TOGGLE_FEE-EXEMPTION-ROLE (patron:string id:string account:string toggle:bool)
        (compose-capability (DPTF|TOGGLE_FEE-EXEMPTION-ROLE_CORE id account toggle))
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|TOGGLE_FEE-EXEMPTION-ROLE_CORE (id:string account:string toggle:bool)
        (DPTF-DPMF|Owner id true)
        (DALOS|Enforce_AccountType account true)
        (if toggle
            (DPTF-DPMF|CanAddSpecialRoleON id true)
            true
        )
        (DPTF|AccountFeeExemptionState id account (not toggle))
    )
    ;;3.1.2.3][T]           Create
    (defcap DPTF|MINT (patron:string id:string client:string amount:decimal origin:bool method:bool)
        (if (= origin true)
            (compose-capability (DPTF|MINT-ORIGIN patron id client amount method))
            (compose-capability (DPTF|MINT-STANDARD patron id client amount method))
        )
        (compose-capability (DALOS|EXECUTOR))
    )
    (defcap DPTF|MINT-ORIGIN (patron:string id:string client:string amount:decimal method:bool)
        (compose-capability (DALOS|METHODIC client method))
        (compose-capability (GAS|MATRON_SOFT patron id client UTILITY.GAS_BIGGEST))
        (compose-capability (DPTF|MINT-ORIGIN_CORE id client amount))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|MINT-ORIGIN_CORE (id:string account:string amount:decimal)
        (DPTF-DPMF|UV_Amount id amount true)
        (DPTF|Virgin id)
        (DPTF-DPMF|Owner id true)
        (compose-capability (DPTF-DPMF|CREDIT id account true))
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
    )
    (defcap DPTF|MINT-STANDARD (patron:string id:string client:string amount:decimal method:bool)               
        (compose-capability (DALOS|METHODIC client method))
        (compose-capability (GAS|MATRON_SOFT patron id client UTILITY.GAS_SMALL))
        (compose-capability (DPTF|MINT-STANDARD_CORE id client amount))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPTF|MINT-STANDARD_CORE (id:string client:string amount:decimal)
        (DPTF-DPMF|UV_Amount id amount true)
        (DPTF|AccountMintState id client true)
        (compose-capability (DPTF-DPMF|CREDIT id client true))
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
    )
    ;;3.1.2.4][T]           Transfer
    (defcap DPTF|TRANSFER_GAS (sender:string receiver:string amount:decimal)
        (let
            (
                (gas-id:string (DALOS|UR_IgnisID))
            )
            (compose-capability (DPTF-DPMF|TRANSFER_CORE gas-id sender receiver amount true))
            (compose-capability (DALOS|METHODIC_TRANSFERABILITY sender receiver true))
        )
    )
    (defun DPTF|EnforceMinimumAmount (id:string transfer-amount:decimal)
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
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id true)
        (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
            { "role-mint" : false}
            { "role-mint" := rm }
            rm
        )
    )
    (defun DPTF|UR_AccountRoleFeeExemption:bool (id:string account:string)
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id true)
        (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
            { "role-fee-exemption" : false}
            { "role-fee-exemption" := rfe }
            rfe
        )
    )
    (defun DPTF-DPMF|UR_AccountFrozenState:bool (id:string account:string token-type:bool)
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id token-type)
        (if (= token-type true)
            (with-default-read DPTF|BalanceTable (concat [id UTILS.BAR account])
                { "frozen" : false}
                { "frozen" := fr }
                fr
            )
            (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
                { "frozen" : false}
                { "frozen" := fr }
                fr
            )
        )
    )
    ;;3.2.1.2][T]           True-Fungible Info
    (defun DPTF|UR_OriginMint:bool (id:string)
        (at "origin-mint" (read DPTF|PropertiesTable id ["origin-mint"]))
    )
    (defun DPTF|UR_OriginAmount:decimal (id:string)
        (at "origin-mint-amount" (read DPTF|PropertiesTable id ["origin-mint-amount"]))
    )
    (defun DPTF|UR_FeeToggle:bool (id:string)
        (at "fee-toggle" (read DPTF|PropertiesTable id ["fee-toggle"]))
    )
    (defun DPTF|UR_MinMove:decimal (id:string)
        (at "min-move" (read DPTF|PropertiesTable id ["min-move"]))
    )
    (defun DPTF|UR_FeePromile:decimal (id:string)
        (at "fee-promile" (read DPTF|PropertiesTable id ["fee-promile"]))
    )
    (defun DPTF|UR_FeeTarget:string (id:string)
        (at "fee-target" (read DPTF|PropertiesTable id ["fee-target"]))
    )
    (defun DPTF|UR_FeeLock:bool (id:string)
        (at "fee-lock" (read DPTF|PropertiesTable id ["fee-lock"]))
    )
    (defun DPTF|UR_FeeUnlocks:integer (id:string)
        (at "fee-unlocks" (read DPTF|PropertiesTable id ["fee-unlocks"]))
    )
    (defun DPTF|UR_PrimaryFeeVolume:decimal (id:string)
        (at "primary-fee-volume" (read DPTF|PropertiesTable id ["primary-fee-volume"]))
    )
    (defun DPTF|UR_SecondaryFeeVolume:decimal (id:string)
        (at "secondary-fee-volume" (read DPTF|PropertiesTable id ["secondary-fee-volume"]))
    )
    (defun DPTF|UR_RewardToken:[string] (id:string)
        (at "reward-token" (read DPTF|PropertiesTable id ["reward-token"]))
    )
    (defun DPTF|UR_RewardBearingToken:[string] (id:string)
        (at "reward-bearing-token" (read DPTF|PropertiesTable id ["reward-bearing-token"]))
    )
    ;;3.2.1.3][T]           Computing
    (defun DPTF|UC_VolumetricTax (id:string amount:decimal)
        (DPTF-DPMF|UV_Amount id amount true)
        (UTILITY.DPTF|UC_VolumetricTax (DPTF-DPMF|UR_Decimals id true) amount)
    )
    (defun DPTF|UC_Fee:[decimal] (id:string amount:decimal)
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
        (UTILITY.DPTF|UC_UnlockPrice (DPTF|UR_FeeUnlocks id))
    )
    (defun DPTF|UC_TransferFeeAndMinException:bool (id:string sender:string receiver:string)
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
                            (UTILS.LIST|UC_AppendLast acc id)
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
        (with-capability (DPTF|MINT patron id account amount origin true)
            (DPTF|K_Mint patron id account amount origin)
        )
    )
    (defun DPTF|C_Mint (patron:string id:string account:string amount:decimal origin:bool)
        (with-capability (DPTF|MINT patron id account amount origin false)
            (DPTF|K_Mint patron id account amount origin)
        )
    )
        (defun DPTF|K_Mint (patron:string id:string account:string amount:decimal origin:bool)
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
        (with-capability (DPTF-DPMF|BURN patron id account amount true true)
            (DPTF|K_Burn patron id account amount)
        )
    )
    (defun DPTF|C_Burn (patron:string id:string account:string amount:decimal)
        (with-capability (DPTF-DPMF|BURN patron id account amount false true)
            (DPTF|K_Burn patron id account amount)
        )
    )
        (defun DPTF|K_Burn (patron:string id:string account:string amount:decimal)
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
        (with-capability (DPTF-DPMF|TRANSFER patron id sender receiver a true true)
            (DPTF|K_Transfer patron id sender receiver a)
        )
    )
    (defun DPTF|C_Transfer (patron:string id:string sender:string receiver:string a:decimal)
        (with-capability (DPTF-DPMF|TRANSFER patron id sender receiver a false true)
            (DPTF|K_Transfer patron id sender receiver a)
        )
    )
        (defun DPTF|K_Transfer (patron:string id:string sender:string receiver:string a:decimal)
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
        (with-capability (DPTF|TRANSMUTE patron id transmuter)
            (DPTF|K_Transmute patron id transmuter transmute-amount)
        )
    )
        (defun DPTF|K_Transmute (patron:string id:string transmuter:string transmute-amount:decimal)
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
        (require-capability (DPTF|CPF_STILL-FEE))
        (if (!= still-fee 0.0)
            (DPTF|X_Credit id target still-fee)
            true
        )
    )
    (defun DPTF|X_CPF_BurnFee (id:string target:string burn-fee:decimal)
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
        (require-capability (DPTF|CPF_CREDIT-FEE))
        (if (!= credit-fee 0.0)
            (DPTF|X_Credit id ATS|SC_NAME credit-fee)
            true
        )
    )
    (defun DPTF|X_Transmute (id:string transmuter:string transmute-amount:decimal)
        (require-capability (DPTF|TRANSMUTE_MANTLE id transmuter))
        (DPTF|X_Debit id transmuter transmute-amount false)
        (DPTF|X_CreditPrimaryFee id transmute-amount false)
    )
    (defun DPTF|X_Credit (id:string account:string amount:decimal)
        (require-capability (DPTF-DPMF|CREDIT id account true))
        (let
            (
                (dptf-account-exist:bool (DPTF-DPMF|UR_AccountExist id account true))
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
    (defun DPTF|X_Debit (id:string account:string amount:decimal admin:bool)
        ;;Capability Required for Debit is called within the <if> body
        (if (= admin true)
            (require-capability (DPTF-DPMF|OWNER id true))
            (require-capability (DPTF-DPMF|DEBIT id account true))
        )
        (with-read DPTF|BalanceTable (concat [id UTILS.BAR account])
            { "balance" := balance }
            (enforce (<= amount balance) "Insufficient Funds for debiting")
            (update DPTF|BalanceTable (concat [id UTILS.BAR account])
                {"balance" : (- balance amount)}    
            )
        )
    )
    ;;3.2.4.2][T]           Update
    (defun DPTF|X_UpdateFeeVolume (id:string amount:decimal primary:bool)
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
                (if (= (at 0 rt) UTILS.BAR)
                    (update DPTF|PropertiesTable id
                        {"reward-token" : [atspair]}
                    )
                    (update DPTF|PropertiesTable id
                        {"reward-token" : (UTILS.LIST|UC_AppendLast rt atspair)}
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
        (update DPTF|BalanceTable (concat [id UTILS.BAR account])
            {"role-mint" : toggle}
        )
    )
    (defun DPTF|X_ToggleFeeExemptionRole (id:string account:string toggle:bool)
        (require-capability (DPTF|TOGGLE_FEE-EXEMPTION-ROLE_CORE id account toggle))
        (update DPTF|BalanceTable (concat [id UTILS.BAR account])
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
                ,"reward-token"         : [UTILS.BAR]
                ,"reward-bearing-token" : [UTILS.BAR]
                ,"vesting"              : UTILS.BAR
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
    (defun DPMF|CanTransferNFTCreateRoleON (id:string)
        (let
            (
                (x:bool (DPMF|UR_CanTransferNFTCreateRole id))
            )
            (enforce (= x true) (format "DPMF Token {} cannot have its create role transfered" [id])
            )
        )
    )
    (defcap DPMF|INCREASE_NONCE ()
        true
    )
    ;;4.1.1.2][M]           DPMF <DPMF|BalanceTable> Table Management
    (defun DPMF|AccountAddQuantityState (id:string account:string state:bool)
        (let
            (
                (x:bool (DPMF|UR_AccountRoleNFTAQ id account))
            )
            (enforce (= x state) (format "Add Quantity Role for {} on Account {} must be set to {} for this operation" [id account state]))
        )
    )
    (defun DPMF|AccountCreateState (id:string account:string state:bool)
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
        (DALOS|UV_SenderWithReceiver (DPMF|UR_CreateRoleAccount id) receiver)
        (DPTF-DPMF|Owner id false)
        (DPMF|CanTransferNFTCreateRoleON id)
        (DPMF|AccountCreateState id (DPMF|UR_CreateRoleAccount id) true)
        (DPMF|AccountCreateState id receiver false)
    )
    (defcap DPMF|TOGGLE_ADD-QUANTITY-ROLE (patron:string id:string account:string toggle:bool)
        (compose-capability (DPMF|TOGGLE_ADD-QUANTITY-ROLE_CORE id account toggle))    
        (compose-capability (GAS|COLLECTION patron account UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap DPMF|TOGGLE_ADD-QUANTITY-ROLE_CORE (id:string account:string toggle:bool)
        (DPTF-DPMF|Owner id false)
        (if toggle
            (DPTF-DPMF|CanAddSpecialRoleON id false)
            true
        )
        (DPMF|AccountAddQuantityState id account (not toggle))
    )
    ;;4.1.2.2][M]           Create
    (defcap DPMF|MINT (patron:string id:string client:string amount:decimal method:bool)
        (compose-capability (DALOS|METHODIC client method))
        (compose-capability (GAS|MATRON_SOFT patron id client UTILITY.GAS_SMALL))
        (compose-capability (DPMF|MINT_CORE id client amount))
        (compose-capability (DALOS|INCREASE-NONCE))
        (compose-capability (DALOS|EXECUTOR))
    )
    (defcap DPMF|MINT_CORE (id:string client:string amount:decimal)
        (compose-capability (DPMF|CREATE_CORE id client))
        (compose-capability (DPMF|ADD-QUANTITY_CORE id client amount))
    )
    (defcap DPMF|CREATE (patron:string id:string client:string method:bool)
        (compose-capability (DALOS|METHODIC client method))
        (compose-capability (GAS|MATRON_SOFT patron id client UTILITY.GAS_SMALL))
        (compose-capability (DPMF|CREATE_CORE id client))
        (compose-capability (DALOS|INCREASE-NONCE))
        (compose-capability (DALOS|EXECUTOR))
    )
    (defcap DPMF|CREATE_CORE (id:string client:string)
        (DPMF|AccountCreateState id client true)
        (compose-capability (DPMF|INCREASE_NONCE))
    )
    (defcap DPMF|ADD-QUANTITY (patron:string id:string client:string amount:decimal method:bool)
        (compose-capability (DALOS|METHODIC client method))
        (compose-capability (GAS|MATRON_SOFT patron id client UTILITY.GAS_SMALL))
        (compose-capability (DPMF|ADD-QUANTITY_CORE id client))
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
        (compose-capability (DALOS|INCREASE-NONCE))
        (compose-capability (DALOS|EXECUTOR))
    )
    (defcap DPMF|ADD-QUANTITY_CORE (id:string client:string amount:decimal)
        (DPTF-DPMF|UV_Amount id amount false)
        (DPMF|AccountAddQuantityState id client true)
        (compose-capability (DPTF-DPMF|CREDIT id client false))
        (compose-capability (DPTF-DPMF|UPDATE_SUPPLY))
    )
    ;;========[M] FUNCTIONS====================================================;;
    ;;4.2]    [M] DPMF Functions
    ;;4.2.1]  [M]   DPMF Utility Functions
    ;;4.2.1.1][M]           Account Info
    (defun DPMF|UR_AccountUnit:[object] (id:string account:string)
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id false)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "unit" : DPMF|NEGATIVE}
            { "unit" := u }
            u
        )
    )
    (defun DPMF|UR_AccountRoleNFTAQ:bool (id:string account:string)
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id false)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "role-nft-add-quantity" : false}
            { "role-nft-add-quantity" := rnaq }
            rnaq
        )
    )
    (defun DPMF|UR_AccountRoleCreate:bool (id:string account:string)
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id false)
        (with-default-read DPMF|BalanceTable (concat [id UTILS.BAR account])
            { "role-nft-create" : false}
            { "role-nft-create" := rnc }
            rnc
        )
    )
    ;;4.2.1.2][M]           Account Nonce
    (defun DPMF|UR_AccountBalances:[decimal] (id:string account:string)
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id false)
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
    (defun DPMF|UR_AccountNonces:[integer] (id:string account:string)
        (UTILITY.DALOS|UV_Account account)
        (DPTF-DPMF|UVE_id id false)
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
    (defun DPMF|UR_AccountBatchSupply:decimal (id:string nonce:integer account:string)
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
        (at "can-transfer-nft-create-role" (read DPMF|PropertiesTable id ["can-transfer-nft-create-role"]))
    )
    (defun DPMF|UR_CreateRoleAccount:string (id:string)
        (at "create-role-account" (read DPMF|PropertiesTable id ["create-role-account"]))
    )
    (defun DPMF|UR_NoncesUsed:integer (id:string)
        (at "nonces-used" (read DPMF|PropertiesTable id ["nonces-used"]))
    )
    (defun DPMF|UR_RewardBearingToken:string (id:string)
        (at "reward-bearing-token" (read DPMF|PropertiesTable id ["reward-bearing-token"]))
    )
    ;;4.2.1.4][M]           Composition
    (defun DPMF|UC_Compose:object{DPMF|Schema} (nonce:integer balance:decimal meta-data:[object])
        {"nonce" : nonce, "balance": balance, "meta-data" : meta-data}
    )
    (defun DPMF|UC_Pair_Nonce-Balance:[object{DPMF|Nonce-Balance}] (nonce-lst:[integer] balance-lst:[decimal])
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
                            (UTILS.LIST|UC_AppendLast acc id)
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
        (with-capability (DPMF|MINT patron id account amount true)
            (DPMF|K_Mint patron id account amount meta-data)
        )
    )
    (defun DPMF|C_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object])
        (with-capability (DPMF|MINT patron id account amount false)
            (DPMF|K_Mint patron id account amount meta-data)
        )
    )
        (defun DPMF|K_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object])
            (require-capability (DALOS|EXECUTOR))
            (if (not (GAS|UC_ZeroGAS id account))
                (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                true
            )
            (DALOS|X_IncrementNonce account)
            (DPMF|X_Mint id account amount meta-data)
        )
    (defun DPMF|CX_Create:integer (patron:string id:string account:string meta-data:[object])
        (with-capability (DPMF|CREATE patron id account true)
            (DPMF|K_Create patron id account meta-data)
        )
    )
    (defun DPMF|C_Create:integer (patron:string id:string account:string meta-data:[object])
        (with-capability (DPMF|CREATE patron id account false)
            (DPMF|K_Create patron id account meta-data)
        )
    )
        (defun DPMF|K_Create:integer (patron:string id:string account:string meta-data:[object])
            (require-capability (DALOS|EXECUTOR))
            (if (not (GAS|UC_ZeroGAS id account))
                (GAS|X_Collect patron account UTILITY.GAS_SMALL)
                true
            )
            (DALOS|X_IncrementNonce account)
            (DPMF|X_Create id account meta-data)
        )
    (defun DPMF|CX_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|ADD-QUANTITY patron id account amount true))
        (DPMF|K_AddQuantity patron id nonce account amount)
    )
    (defun DPMF|C_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal)
        (with-capability (DPMF|ADD-QUANTITY patron id account amount false)
            (DPMF|K_AddQuantity patron id nonce account amount)
        )
    )
        (defun DPMF|K_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal)
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
        (with-capability (DPTF-DPMF|BURN patron id account amount true false)
            (DPMF|K_Burn patron id nonce account amount)
        )
    )
    (defun DPMF|C_Burn (patron:string id:string nonce:integer account:string amount:decimal)
        (with-capability (DPTF-DPMF|BURN patron id account amount false false)
            (DPMF|K_Burn patron id nonce account amount)
        )
    )
        (defun DPMF|K_Burn (patron:string id:string nonce:integer account:string amount:decimal)
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
        (with-capability (DPTF-DPMF|TRANSFER patron id sender receiver transfer-amount true false)
            (DPMF|K_Transfer patron id nonce sender receiver transfer-amount)
        )
    )
    (defun DPMF|C_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal)
        (with-capability (DPTF-DPMF|TRANSFER patron id sender receiver transfer-amount false false)
            (DPMF|K_Transfer patron id nonce sender receiver transfer-amount)
        )
    )
        (defun DPMF|K_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal)
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
        (require-capability (DPTF-DPMF|CREDIT id account false))
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
                        (present-meta-fungible:object{DPMF|Schema} (DPMF|UC_Compose nonce current-nonce-balance meta-data))
                        (credited-meta-fungible:object{DPMF|Schema} (DPMF|UC_Compose nonce credited-balance meta-data))
                        (processed-unit-with-replace:[object{DPMF|Schema}] (UTILITY.UC_ReplaceItem next-unit present-meta-fungible credited-meta-fungible))
                        (processed-unit-with-append:[object{DPMF|Schema}] (UTILS.LIST|UC_AppendLast next-unit credited-meta-fungible))
                    )
                    (enforce (> amount 0.0) "Crediting amount must be greater than zero")
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
    (defun DPMF|X_Debit (id:string nonce:integer account:string amount:decimal admin:bool)
        (if (= admin true)
            (require-capability (DPTF-DPMF|OWNER id false))
            (require-capability (DPTF-DPMF|DEBIT id account false))
        )
        (with-read DPMF|BalanceTable (concat [id UTILS.BAR account])
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
        (let
            (
                (nonce-balance-obj-lst:[object{DPMF|Nonce-Balance}] (DPMF|UC_Pair_Nonce-Balance nonce-lst balance-lst))
            )
            (map (lambda (x:object{DPMF|Nonce-Balance}) (DPMF|X_DebitPaired id account x)) nonce-balance-obj-lst)
        )
    )
    (defun DPMF|X_DebitPaired (id:string account:string nonce-balance-obj:object{DPMF|Nonce-Balance})
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
        (require-capability (DPMF|MOVE_CREATE-ROLE_CORE id receiver))
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
    (defun DPMF|X_ToggleAddQuantityRole (id:string account:string toggle:bool)
        (require-capability (DPMF|TOGGLE_ADD-QUANTITY-ROLE_CORE id account toggle))
        (update DPMF|BalanceTable (concat [id UTILS.BAR account])
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
            ,"reward-bearing-token" : UTILS.BAR
            ,"vesting"              : UTILS.BAR}
        )
        (DPTF-DPMF|C_DeployAccount (DALOS|UC_Makeid ticker) account false)
        (DALOS|UC_Makeid ticker)
    )
    (defun DPMF|X_Mint:integer (id:string account:string amount:decimal meta-data:[object])
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
        (require-capability (DPMF|CREATE_CORE id account))
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
                        (meta-fungible:object{DPMF|Schema} (DPMF|UC_Compose new-nonce 0.0 meta-data))
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
    (defun DPMF|X_AddQuantity (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|ADD-QUANTITY_CORE id account amount))
        (with-read DPMF|BalanceTable (concat [id UTILS.BAR account])
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
                (update DPMF|BalanceTable (concat [id UTILS.BAR account])
                    {"unit" : processed-unit}    
                )
            )
        )
        (DPTF-DPMF|X_UpdateSupply id amount true false)
    )
    (defun DPMF|X_Burn (id:string nonce:integer account:string amount:decimal)
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
    (defun GAS|VirtualState (state:bool)
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
    (defun GAS|NativeState (state:bool)
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
        true
    )
    ;;5.1.2]  [G]   GAS Composed Capabilities
    ;;5.1.2.1][G]           GAS Control
    (defcap GAS|UPDATE_IDS (id:string)
        (DPTF-DPMF|UVE_id id true)
        (compose-capability (GAS_TANKER))
    )
    (defcap GAS|TOGGLE (native:bool toggle:bool)
        (compose-capability (GAS_TANKER))
        (if (= native true)
            (GAS|NativeState (not toggle))
            (GAS|VirtualState (not toggle))
        )
    )
    ;;5.1.2.2][G]           GAS Handling
    (defcap GAS|MATRON_SOFT (patron:string id:string client:string gas-amount:decimal)
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
        (DALOS|Enforce_AccountType patron false)
        (DALOS|CAP_EnforceAccountOwnership patron)
    )
    (defcap GAS|COLLECTION (patron:string sender:string amount:decimal)
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
        (let
            (
                (gas-id:string (DALOS|UR_IgnisID))
            )
            (if (!= gas-id UTILS.BAR)
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
        (let
            (
                (gas-id:string (DALOS|UR_IgnisID))
            )
            (if (!= gas-id UTILS.BAR)
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
        (at "virtual-gas-tank" (read GAS|PropertiesTable GAS|VGD ["virtual-gas-tank"]))
    )
    (defun GAS|UR_VirtualToggle:bool ()
        (with-default-read GAS|PropertiesTable GAS|VGD
            {"virtual-gas-toggle" : false}
            {"virtual-gas-toggle" := tg}
            tg
        )
    )
    (defun GAS|UR_VirtualSpent:decimal ()
        (at "virtual-gas-spent" (read GAS|PropertiesTable GAS|VGD ["virtual-gas-spent"]))
    )
    (defun GAS|UR_NativeToggle:bool ()
        (with-default-read GAS|PropertiesTable GAS|VGD
            {"native-gas-toggle" : false}
            {"native-gas-toggle" := tg}
            tg
        )
    )
    (defun GAS|UR_NativeSpent:decimal ()
        (at "native-gas-spent" (read GAS|PropertiesTable GAS|VGD ["native-gas-spent"]))
    )
    ;;5.2.1.2][G]           Computing
    (defun GAS|UC_ZeroGAZ:bool (id:string sender:string receiver:string)
        (let*
            (
                (t1:bool (GAS|UC_ZeroGAS id sender))
                (t2:bool (if (or (= receiver GAS|SC_NAME)(= receiver LIQUID|SC_NAME)) true false))
            )
            (or t1 t2)
        )
    )
    (defun GAS|UC_ZeroGAS:bool (id:string sender:string)
        (let*
            (
                (t1:bool (GAS|UC_Zero sender))
                (gas-id:string (DALOS|UR_IgnisID))
                (t2:bool (if (or (= gas-id UTILS.BAR)(= id gas-id)) true false))
            )
            (or t1 t2)
        )
    )
    (defun GAS|UC_Zero:bool (sender:string)
        (let*
            (
                (t0:bool (GAS|UC_SubZero))
                (t1:bool (if (or (= sender GAS|SC_NAME)(= sender LIQUID|SC_NAME)) true false))
            )
            (or t0 t1)
        )
    )
    (defun GAS|UC_SubZero:bool ()
        (let*
            (
                (gas-toggle:bool (GAS|UR_VirtualToggle))
                (ZG:bool (if (= gas-toggle false) true false))
            )
            ZG
        )
    )
    (defun GAS|UC_NativeSubZero:bool ()
        (let*
            (
                (gas-toggle:bool (GAS|UR_NativeToggle))
                (NZG:bool (if (= gas-toggle false) true false))
            )
            NZG
        )
    )
    (defun GAS|UC_KadenaSplit:[decimal] (kadena-input-amount:decimal)
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
        (DPTF-DPMF|UVE_id id true)
        (with-capability (GAS|UPDATE_IDS id)
            (if (= source true)
                (GAS|X_UpdateSourceID id)
                (GAS|X_UpdateID id)
            )
        )
    )
    (defun GAS|A_SetSourcePrice (price:decimal)
        (with-capability (GAS_TANKER)
            (GAS|X_UpdateSourcePrice price)
        )
    )
    (defun GAS|A_Toggle (native:bool toggle:bool)
        (with-capability (GAS|TOGGLE native toggle)
            (GAS|X_Toggle native toggle)
        )
    )
    ;;5.2.4]  [G]   GAS Auxiliary Functions
    ;;5.2.4.1][G]           GAS|PropertiesTable Update
    (defun GAS|X_UpdateSourceID (id:string)
        (require-capability (GAS|UPDATE_IDS id))
        (update GAS|PropertiesTable GAS|VGD
            {"gas-source-id" : id}
        )
    )
    (defun GAS|X_UpdateSourcePrice (price:decimal)
        (require-capability (GAS_TANKER))
        (update GAS|PropertiesTable GAS|VGD
            {"gas-source-price" : price}
        )
    )
    (defun GAS|X_UpdateID (id:string)
        (require-capability (GAS|UPDATE_IDS id))
        (update GAS|PropertiesTable GAS|VGD
            {"virtual-gas-id" : id}
        )
    )
    (defun GAS|X_Toggle (native:bool toggle:bool)
        (require-capability (GAS_TANKER))
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
        (require-capability (GAS_TANKER))
        (update GAS|PropertiesTable GAS|VGD
            {"virtual-gas-tank" : account}
        )
    )
    (defun GAS|X_Increment (native:bool increment:decimal)
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
        (require-capability (GAS|COLLECTER_STANDARD patron amount))
        (GAS|X_Transfer patron (GAS|UR_Tanker) amount)
        (GAS|X_Increment false amount)
    )
    (defun GAS|X_CollectSmart (patron:string sender:string amount:decimal)
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
            
            (LIQUID|C_WrapKadena patron patron am1)
            (DPTF|CX_Transfer patron wrapped-kda-id patron LIQUID|SC_NAME am1)
            (ATS|C_Fuel patron LIQUID|SC_NAME liquidpair wrapped-kda-id am1)

            (GAS|XC_TransferDalosFuel kadena-patron GAS|SC_KDA-NAME am2)
            (GAS|X_Increment true amount)
        )
    )
    (defun GAS|XC_TransferDalosFuel (sender:string receiver:string amount:decimal)
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
    (defun ATS|CAP_Owner (atspair:string)
        (DALOS|CAP_EnforceAccountOwnership (ATS|UR_OwnerKonto atspair))
    )
    (defun ATS|CanChangeOwnerON (atspair:string)
        (ATS|UEV_id atspair)
        (let
            (
                (x:bool (ATS|UR_CanChangeOwner atspair))
            )
            (enforce (= x true) (format "ATS Pair {} ownership cannot be changed" [atspair]))
        )
    )
    (defcap ATS|RT_EXISTANCE (atspair:string reward-token:string existance:bool)
        (ATS|RewardTokenExistance atspair reward-token existance)
    )
    (defun ATS|RewardTokenExistance (atspair:string reward-token:string existance:bool)
        (let
            (
                (existance-check:bool (ATS|UC_IzRT atspair reward-token))
            )
            (enforce (= existance-check existance) (format "{} Existance isnt verified for Token {} as RT with ATS Pair {}" [existance reward-token atspair]))
        )
    )
    (defun ATS|RewardBearingTokenExistance (atspair:string reward-bearing-token:string existance:bool cold-or-hot:bool)
        (let
            (
                (existance-check:bool (ATS|UC_IzRBT atspair reward-bearing-token cold-or-hot))
            )
            (enforce (= existance-check existance) (format "{} Existance isnt verified for Token {} as RBT with ATS Pair {}" [existance reward-bearing-token atspair]))
        )
    )
    (defun ATS|HotRewardBearingTokenPresence (atspair:string enforced-presence:bool)
        (let
            (
                (presence-check:bool (ATS|UC_IzPresentHotRBT atspair))
            )
            (enforce (= presence-check enforced-presence) (format "ATS Pair {} cant verfiy {} presence for a Hot RBT Token" [atspair enforced-presence]))
        )
    )
    (defun ATS|UEV_ParameterLockState (atspair:string state:bool)
        (let
            (
                (x:bool (ATS|UR_Lock atspair))
            )
            (enforce (= x state) (format "Parameter-lock for ATS Pair {} must be set to {} for this operation" [atspair state]))
        )
    )
    (defun ATS|UEV_FeeState (atspair:string state:bool fee-switch:integer)
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
    (defun ATS|EliteState (atspair:string state:bool)
        (let
            (
                (x:bool (ATS|UR_EliteMode atspair))
            )
            (enforce (= x state) (format "Elite-Mode for ATS Pair {} must be set to {} for this operation" [atspair state]))
        )
    )
    (defcap ATS|RECOVERY_STATE (atspair:string state:bool cold-or-hot:bool)
        (ATS|UEV_RecoveryState atspair state cold-or-hot)
    )
    (defun ATS|UEV_RecoveryState (atspair:string state:bool cold-or-hot:bool)
        (let
            (
                (x:bool (ATS|UR_ToggleColdRecovery atspair))
                (y:bool (ATS|UR_ToggleHotRecovery atspair))
            )
            (if cold-or-hot
                (enforce (= x state) (format "Cold-recovery for ATS Pair {} must be set to {} for this operation" [atspair state]))
                (enforce (= y state) (format "Hot-recovery for ATS Pair {} must be set to {} for this operation" [atspair state]))
            )
        )
    )
    (defcap ATS|INCREMENT-LOCKS ()
        true
    )
    ;;6.1.1.2][A]           <ATS|Ledger> Table Management
    (defcap ATS|UPDATE_LEDGER ()
        true
    )
    (defcap ATS|DEPLOY (atspair:string account:string)
        (DALOS.DALOS|UEV_EnforceAccountExists account)
        (ATS|UEV_id atspair)
        (compose-capability (ATS|NORMALIZE_LEDGER atspair account))
    )
    (defcap ATS|NORMALIZE_LEDGER (atspair:string account:string)
        (ATS|UEV_id atspair)
        (enforce-one
            "Keyset not valid for normalizing ATS|Ledger Account Operations"
            [
                (compose-capability (DEMIURGOI))
                (compose-capability (DALOS|ABS_ACCOUNT_OWNER account))
            ]
        )
    )
    (defcap ATS|HOT_RECOVERY (patron:string recoverer:string atspair:string ra:decimal)
        (DALOS|CAP_EnforceAccountOwnership recoverer)
        (ATS|UEV_id atspair)
        (ATS|UEV_RecoveryState atspair true false)
    )
    (defcap ATS|COLD_RECOVERY (patron:string recoverer:string atspair:string ra:decimal)
        (DALOS|CAP_EnforceAccountOwnership recoverer)
        (ATS|UEV_id atspair)
        (ATS|UEV_RecoveryState atspair true true)
        (compose-capability (ATS|DEPLOY atspair recoverer))
        (compose-capability (ATS|UPDATE_LEDGER))
        (compose-capability (ATS|UPDATE_ROU))
    )
    (defcap ATS|CULL (culler:string atspair:string)
        (DALOS|CAP_EnforceAccountOwnership culler)
        (ATS|UEV_id atspair)
        (compose-capability (ATS|UPDATE_ROU))
        (compose-capability (ATS|NORMALIZE_LEDGER atspair culler))
        (compose-capability (ATS|UPDATE_LEDGER))
    )
    ;;6.1.2]  [A]   ATS Composed Capabilities
    ;;6.1.2.1][A]           Control
    (defun ATS|UEV_UpdateColdOrHot (atspair:string cold-or-hot:bool)
        (ATS|UEV_ParameterLockState atspair false)
        (if cold-or-hot
            (ATS|UEV_RecoveryState atspair false true)
            (ATS|UEV_RecoveryState atspair false false)
        )
    )
    (defun ATS|UEV_UpdateColdAndHot (atspair:string)
        (ATS|UEV_ParameterLockState atspair false)
        (ATS|UEV_RecoveryState atspair false true)
        (ATS|UEV_RecoveryState atspair false false)
    )
    (defcap ATS|OWNERSHIP_CHANGE (patron:string atspair:string new-owner:string)
        (compose-capability (ATS|X_OWNERSHIP_CHANGE atspair new-owner))
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_BIGGEST))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|X_OWNERSHIP_CHANGE (atspair:string new-owner:string)
        (DALOS|UV_SenderWithReceiver (ATS|UR_OwnerKonto atspair) new-owner)
        (ATS|CAP_Owner atspair)
        (ATS|CanChangeOwnerON atspair)
        (DALOS.DALOS|UEV_EnforceAccountExists new-owner)
    )
    (defcap ATS|TOGGLE_PARAMETER-LOCK (patron:string atspair:string toggle:bool)
        (compose-capability (ATS|X_TOGGLE_PARAMETER-LOCK atspair toggle))
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
    (defcap ATS|X_TOGGLE_PARAMETER-LOCK (atspair:string toggle:bool)
        (ATS|CAP_Owner atspair)
        (ATS|UEV_ParameterLockState atspair (not toggle))
        (enforce-one
            (format "ATS <parameter-lock> cannot be toggled when both <cold-recovery> and <hot-recovery> are set to false")
            [
                (compose-capability (ATS|RECOVERY_STATE atspair true true))
                (compose-capability (ATS|RECOVERY_STATE atspair true false))
            ]
        )
    )
    (defcap ATS|TOGGLE_FEE (patron:string atspair:string toggle:bool fee-switch:integer)
        (compose-capability (ATS|X_TOGGLE_FEE atspair toggle fee-switch))
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|X_TOGGLE_FEE (atspair:string toggle:bool fee-switch:integer)
        (enforce (contains fee-switch (enumerate 0 2)) "Integer not a valid fee-switch integer")
        (ATS|CAP_Owner atspair)
        (ATS|UEV_FeeState atspair (not toggle) fee-switch)
        (if (or (= fee-switch 0)(= fee-switch 1))
            (ATS|UEV_UpdateColdOrHot atspair true)
            (ATS|UEV_UpdateColdOrHot atspair false)
        )
    )
    (defcap ATS|SET_CRD (patron:string atspair:string soft-or-hard:bool base:integer growth:integer)
        (compose-capability (ATS|X_SET_CRD atspair soft-or-hard base growth))
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|X_SET_CRD (atspair:string soft-or-hard:bool base:integer growth:integer)
        (ATS|CAP_Owner atspair)
        (ATS|UEV_UpdateColdOrHot atspair true)
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
        (compose-capability (ATS|X_SET_COLD_FEE atspair fee-positions fee-thresholds fee-array))
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|X_SET_COLD_FEE (atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        (ATS|CAP_Owner atspair)
        (ATS|UEV_UpdateColdOrHot atspair true)
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
                        (UTILITY.DALOS|UV_Fee fee)
                    )
                    inner-lst
                )
            )
            fee-array
        )
    )
    (defcap ATS|SET_HOT_FEE (patron:string atspair:string promile:decimal decay:integer)
        (compose-capability (ATS|X_SET_HOT_FEE atspair promile decay))
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|X_SET_HOT_FEE (atspair:string promile:decimal decay:integer)
        (ATS|CAP_Owner atspair)
        (ATS|UEV_UpdateColdOrHot atspair false)
        (UTILITY.DALOS|UV_Fee promile)
        (enforce 
            (and
                (>= decay 1)
                (<= decay 9125)
            )
            "No More than 25 years (9125 days) can be set for Decay Period"
        )
    )
    (defcap ATS|TOGGLE_ELITE (patron:string atspair:string toggle:bool)
        (compose-capability (ATS|X_TOGGLE_ELITE atspair toggle))
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|X_TOGGLE_ELITE (atspair:string toggle:bool)
        (ATS|CAP_Owner atspair)
        (ATS|UEV_UpdateColdOrHot atspair true)
        (ATS|EliteState atspair (not toggle))
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
        (if (= toggle true)
            (compose-capability (ATS|X_RECOVERY-ON atspair cold-or-hot))
            (compose-capability (ATS|X_RECOVERY-OFF atspair cold-or-hot))
        )
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_SMALL))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|X_RECOVERY-ON (atspair:string cold-or-hot:bool)
        (ATS|CAP_Owner atspair)
        (ATS|UEV_ParameterLockState atspair false)
        (ATS|UEV_RecoveryState atspair false cold-or-hot)
    )
        (defcap ATS|X_RECOVERY-OFF (atspair:string cold-or-hot:bool)
        (ATS|CAP_Owner atspair)
        (ATS|UEV_ParameterLockState atspair false)
        (ATS|UEV_RecoveryState atspair true cold-or-hot)
    )
    ;;6.1.2.2][A]           Create
    (defcap ATS|ISSUE (patron:string atspair:string issuer:string reward-token:string reward-bearing-token:string)
        (compose-capability (ATS|X_ISSUE atspair issuer reward-token reward-bearing-token))
        (compose-capability (GAS|COLLECTION patron issuer UTILITY.GAS_HUGE))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|X_ISSUE (atspair:string issuer:string reward-token:string reward-bearing-token:string)
        (enforce (!= reward-token reward-bearing-token) "Reward Token must be different from Reward-Bearing Token")
        (DPTF-DPMF|Owner reward-token true)
        (DPTF-DPMF|Owner reward-bearing-token true)
        (DALOS|CAP_EnforceAccountOwnership issuer)
        (DALOS|Enforce_AccountType issuer false)
        (compose-capability (ATS|UPDATE_RT))
        (compose-capability (ATS|UPDATE_RBT reward-bearing-token true))
        (ATS|RewardTokenExistance atspair reward-token false)
        (ATS|RewardBearingTokenExistance atspair reward-bearing-token false true)
    )
    (defcap ATS|ADD_SECONDARY (patron:string atspair:string reward-token:string token-type:bool)
        (compose-capability (ATS|X_ADD_SECONDARY atspair reward-token token-type))
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_ISSUE))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|X_ADD_SECONDARY (atspair:string reward-token:string token-type:bool)
        (DPTF-DPMF|Owner reward-token token-type)
        (ATS|CAP_Owner atspair)
        (ATS|UEV_UpdateColdAndHot atspair)
        (if (= token-type true)
            (compose-capability (ATS|ADD_SECONDARY_RT atspair reward-token))
            (compose-capability (ATS|ADD_SECONDARY_RBT atspair reward-token))
        )
    )
    (defcap ATS|ADD_SECONDARY_RT (atspair:string reward-token:string)
        (ATS|UEV_IzTokenUnique atspair reward-token)
        (ATS|RewardTokenExistance atspair reward-token false)
        (compose-capability (ATS|UPDATE_RT))
    )
    (defcap ATS|ADD_SECONDARY_RBT (atspair:string hot-rbt:string)
        (ATS|HotRewardBearingTokenPresence atspair false)   
        (compose-capability (ATS|UPDATE_RBT hot-rbt false))
        (VST|Existance hot-rbt false false)
    )
    (defcap ATS|UPDATE_RBT (id:string token-type:bool)
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
    (defcap ATS|UPDATE_ROU ()
        true
    )
    (defcap ATS|UPDATE_RT ()
        true
    )
    ;;6.1.2.3][A]           Destroy
    (defcap ATS|REMOVE_SECONDARY (patron:string atspair:string reward-token:string)
        (compose-capability (ATS|X_REMOVE_SECONDARY atspair reward-token))   
        (compose-capability (GAS|COLLECTION patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_ISSUE))
        (compose-capability (DALOS|INCREASE-NONCE))
    )
    (defcap ATS|X_REMOVE_SECONDARY (atspair:string reward-token:string)
        (ATS|CAP_Owner atspair)
        (ATS|UEV_UpdateColdAndHot atspair)
        (ATS|RewardTokenExistance atspair reward-token true)
        (compose-capability (ATS|UPDATE_RT))
    )
    ;;6.1.2.4][A]           Client Capabilities
    (defcap ATS|FUEL (patron:string fueler:string atspair:string reward-token:string amount:decimal)
        (let
            (
                (index:decimal (ATS|UC_Index atspair))
            )
            (enforce (>= index 1.0) "Fueling cannot take place on a negative Index")
            (ATS|RewardTokenExistance atspair reward-token true)
            (compose-capability (ATS|UPDATE_ROU))
        )
    )
    (defcap ATS|COIL_OR_CURL (patron:string coiler:string atspair:string coil-token:string amount:decimal)
        (ATS|RewardTokenExistance atspair coil-token true)
        (compose-capability (ATS|UPDATE_ROU))
    )
    ;;========[A] FUNCTIONS====================================================;;
    ;;6.2]    [A] ATS Functions
    ;;6.2.1]  [A]   ATS Utility Functions
    ;;6.2.1.1][A]           ATS|Pairs Info
    (defun ATS|UR_OwnerKonto:string (atspair:string)
        (at "owner-konto" (read ATS|Pairs atspair ["owner-konto"]))
    )
    (defun ATS|UR_CanChangeOwner:bool (atspair:string)
        (at "can-change-owner" (read ATS|Pairs atspair ["can-change-owner"]))
    )
    (defun ATS|UR_Lock:bool (atspair:string)
        (at "parameter-lock" (read ATS|Pairs atspair ["parameter-lock"]))
    )
    (defun ATS|UR_Unlocks:integer (atspair:string)
        (at "unlocks" (read ATS|Pairs atspair ["unlocks"]))
    )
    (defun ATS|UR_IndexName:string (atspair:string)
        (at "pair-index-name" (read ATS|Pairs atspair ["pair-index-name"]))
    )
    (defun ATS|UR_IndexDecimals:integer (atspair:string)
        (at "index-decimals" (read ATS|Pairs atspair ["index-decimals"]))
    )
    (defun ATS|UR_RewardTokens:[object{ATS|RewardTokenSchema}] (atspair:string)
        (at "reward-tokens" (read ATS|Pairs atspair ["reward-tokens"]))
    )
    (defun ATS|UR_ColdRewardBearingToken:string (atspair:string)
        (at "c-rbt" (read ATS|Pairs atspair ["c-rbt"]))
    )
    (defun ATS|UR_ColdNativeFeeRedirection:bool (atspair:string)
        (at "c-nfr" (read ATS|Pairs atspair ["c-nfr"]))
    )
    (defun ATS|UR_ColdRecoveryPositions:integer (atspair:string)
        (at "c-positions" (read ATS|Pairs atspair ["c-positions"]))
    )
    (defun ATS|UR_ColdRecoveryFeeThresholds:[decimal] (atspair:string)
        (at "c-limits" (read ATS|Pairs atspair ["c-limits"]))
    )
    (defun ATS|UR_ColdRecoveryFeeTable:[[decimal]] (atspair:string)
        (at "c-array" (read ATS|Pairs atspair ["c-array"]))
    )
    (defun ATS|UR_ColdRecoveryFeeRedirection:bool (atspair:string)
        (at "c-fr" (read ATS|Pairs atspair ["c-fr"]))
    )
    (defun ATS|UR_ColdRecoveryDuration:[integer] (atspair:string)
        (at "c-duration" (read ATS|Pairs atspair ["c-duration"]))
    )
    (defun ATS|UR_EliteMode:bool (atspair:string)
        (at "c-elite-mode" (read ATS|Pairs atspair ["c-elite-mode"]))
    )
    (defun ATS|UR_HotRewardBearingToken:string (atspair:string)
        (at "h-rbt" (read ATS|Pairs atspair ["h-rbt"]))
    )
    (defun ATS|UR_HotRecoveryStartingFeePromile:integer (atspair:string)
        (at "h-promile" (read ATS|Pairs atspair ["h-promile"]))
    )
    (defun ATS|UR_HotRecoveryDecayPeriod:integer (atspair:string)
        (at "h-decay" (read ATS|Pairs atspair ["h-decay"]))
    )
    (defun ATS|UR_HotRecoveryFeeRedirection:bool (atspair:string)
        (at "h-fr" (read ATS|Pairs atspair ["h-fr"]))
    )
    (defun ATS|UR_ToggleColdRecovery:bool (atspair:string)
        (at "cold-recovery" (read ATS|Pairs atspair ["cold-recovery"]))
    )
    (defun ATS|UR_ToggleHotRecovery:bool (atspair:string)
        (at "hot-recovery" (read ATS|Pairs atspair ["hot-recovery"]))
    )
    (defun ATS|UR_RewardTokenList:[string] (atspair:string)
        (fold
            (lambda
                (acc:[string] item:object{ATS|RewardTokenSchema})
                (UTILS.LIST|UC_AppendLast acc (at "token" item))
            )
            []
            (ATS|UR_RewardTokens atspair)
        )
    )
    (defun ATS|UR_RoUAmountList:[decimal] (atspair:string rou:bool)
        (fold
            (lambda
                (acc:[decimal] item:object{ATS|RewardTokenSchema})
                (if rou
                    (UTILS.LIST|UC_AppendLast acc (at "resident" item))
                    (UTILS.LIST|UC_AppendLast acc (at "unbonding" item))
                )
            )
            []
            (ATS|UR_RewardTokens atspair)
        )
    )
    (defun ATS|UR_RT-Data (atspair:string reward-token:string data:integer)
        (ATS|UEV_id atspair)
        (UTILS.UTILS|UEV_PositionalVariable data 3 "Invalid Data Integer")
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
        (UTILS.DALOS|UEV_UniqueAtspair atspair)
        (UTILITY.DALOS|UV_Account account)
        (at "P0" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P0"]))
    )
    (defun ATS|UC_IzCullable:bool (input:object{ATS|Unstake})
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
        (UTILS.DALOS|UEV_UniqueAtspair atspair)
        (UTILITY.DALOS|UV_Account account)
        (UTILS.UTILS|UEV_PositionalVariable position 7 "Invalid Position Number")
        (cond
            ((= position 1) (at "P1" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P1"])))
            ((= position 2) (at "P2" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P2"])))
            ((= position 3) (at "P3" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P3"])))
            ((= position 4) (at "P4" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P4"])))
            ((= position 5) (at "P5" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P5"])))
            ((= position 6) (at "P6" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P6"])))
            ((= position 7) (at "P7" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P7"])))
            true
        )
    )
    (defun ATS|URX_UnstakeObjectUnbondingValue (atspair:string reward-token:string io:object{ATS|Unstake})
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
        (fold
            (lambda
                (acc:[integer] rt:string)
                (UTILS.LIST|UC_AppendLast acc (DPTF-DPMF|UR_Decimals rt true))
            )
            []
            (ATS|UR_RewardTokenList atspair)
        )
    )
    ;;6.2.1.3][A]           ATS|Ledger Computing
    (defun ATS|UC_WhichPosition:integer (atspair:string c-rbt-amount:decimal account:string)
        (let
            (
                (elite:bool (ATS|UR_EliteMode atspair))
            )
            (if elite
                (ATS|UCC_ElitePosition atspair c-rbt-amount account)
                (ATS|UC_NonElitePosition atspair account)
            )
        )
    )
    (defun ATS|UCC_ElitePosition:integer (atspair:string c-rbt-amount:decimal account:string)
        (let
            (
                (positions:integer (ATS|UR_ColdRecoveryPositions atspair))
                (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                (ea-id:string (DALOS|UR_EliteAurynID))
            )
            (if (!= ea-id UTILS.BAR)
                ;elite auryn is defind
                (let*
                    (
                        (iz-ea-id:bool (if (= ea-id c-rbt) true false))
                        (pstate:[integer] (ATS|UC_PSL atspair account))
                        (met:integer (DALOS|UR_Elite-Tier-Major account))
                        (ea-supply:decimal (DPTF-DPMF|UR_AccountSupply ea-id account true))
                        (t-ea-supply:decimal (DALOS|UR_EliteAurynzSupply account))
                        (virtual-met:integer (str-to-int (take 1 (at "tier" (UTILITY.ATS|UCC_Elite (- t-ea-supply c-rbt-amount))))))
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
        (UTILS.UTILS|UEV_PositionalVariable position 7 "Input Position out of bounds")
        (with-read ATS|Ledger (concat [atspair UTILS.BAR account])
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
        @doc "occupied(0), opened(1), closed (-1)"
        (let
            (
                (zero:object{ATS|Unstake} (ATS|UCC_MakeZeroUnstakeObject atspair))
                (negative:object{ATS|Unstake} (ATS|UCC_MakeNegativeUnstakeObject atspair))
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
    (defun ATS|UCC_RTSplitAmounts:[decimal] (atspair:string rbt-amount:decimal)
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
    (defun ATS|UCC_MakeUnstakeObject:object{ATS|Unstake} (atspair:string time:time)
        { "reward-tokens"   : (make-list (length (ATS|UR_RewardTokenList atspair)) 0.0)
        , "cull-time"       : time}
    )
    (defun ATS|UCC_MakeZeroUnstakeObject:object{ATS|Unstake} (atspair:string)
        (ATS|UCC_MakeUnstakeObject atspair NULLTIME)
    )
    (defun ATS|UCC_MakeNegativeUnstakeObject:object{ATS|Unstake} (atspair:string)
        (ATS|UCC_MakeUnstakeObject atspair ANTITIME)
    )
    ;;6.2.1.5][A]           Computing|Composing
    (defun ATS|UC_Index (atspair:string)
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
        (fold (+) 0.0 (ATS|UR_RoUAmountList atspair true)) 
    )
    
    (defun ATS|UCC_ComposePrimaryRewardToken:object{ATS|RewardTokenSchema} (token:string nfr:bool)
        (ATS|UCC_RT token nfr 0.0 0.0)
    )
    (defun ATS|UCC_RT:object{ATS|RewardTokenSchema} (token:string nfr:bool r:decimal u:decimal)
        (enforce (>= r 0.0) "Negative Resident not allowed")
        (enforce (>= u 0.0) "Negative Unbonding not allowed")
        {"token"                    : token
        ,"nfr"                      : nfr
        ,"resident"                 : r
        ,"unbonding"                : u}
    )
    (defun ATS|UC_IzRT-Absolute:bool (reward-token:string)
        (DPTF-DPMF|UVE_id reward-token true)
        (if (= (DPTF|UR_RewardToken reward-token) [UTILS.BAR])
            false
            true
        )
    )
    (defun ATS|UC_IzRT:bool (atspair:string reward-token:string)
        (DPTF-DPMF|UVE_id reward-token true)
        (if (= (DPTF|UR_RewardToken reward-token) [UTILS.BAR])
            false
            (if (= (contains atspair (DPTF|UR_RewardToken reward-token)) true)
                true
                false
            )
        )
    )
    (defun ATS|UC_IzRBT-Absolute:bool (reward-bearing-token:string cold-or-hot:bool)
        (DPTF-DPMF|UVE_id reward-bearing-token cold-or-hot)
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
    (defun ATS|UC_IzRBT:bool (atspair:string reward-bearing-token:string cold-or-hot:bool)
        (DPTF-DPMF|UVE_id reward-bearing-token cold-or-hot)
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
    ;;take me
    (defun ATS|UC_IzPresentHotRBT:bool (atspair:string)
        (if (= (ATS|UR_HotRewardBearingToken atspair) UTILS.BAR)
            false
            true
        )
    )
    (defun ATS|UC_RewardTokenPosition:integer (atspair:string reward-token:string)
        (let
            (
                (existance-check:bool (ATS|UC_IzRT atspair reward-token))
            )
            (enforce (= existance-check true) (format "{} Existance isnt verified for Token {} as RT with ATS Pair {}" [true reward-token atspair]))
            (at 0 (UTILITY.UC_Search (ATS|UR_RewardTokenList atspair) reward-token))
        )
    )
    (defun ATS|UC_ZeroColdFeeExceptionBoolean:bool (fee-thresholds:[decimal] fee-array:[[decimal]])
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
        (fold
            (lambda
                (acc:[bool] index:integer)
                (if rt-or-rbt
                    (if (ATS|UR_RT-Data (at index ats-pairs) id 1)
                        (UTILS.LIST|UC_AppendLast acc true)
                        (UTILS.LIST|UC_AppendLast acc false)
                    )
                    (if (ATS|UR_ColdNativeFeeRedirection (at index ats-pairs))
                        (UTILS.LIST|UC_AppendLast acc true)
                        (UTILS.LIST|UC_AppendLast acc false)
                    )
                )
            )
            []
            (enumerate 0 (- (length ats-pairs) 1))
        )
    )
    (defun ATS|UC_BooleanDecimalCombiner:[decimal] (id:string amount:decimal milestones:integer boolean:[bool])
        (UTILITY.UC_SplitBalanceWithBooleans (DPTF-DPMF|UR_Decimals id true) amount milestones boolean)
    )
    ;;6.2.1.7][A]           Validations
    (defun ATS|UEV_id (atspair:string)
        (UTILS.DALOS|UEV_UniqueAtspair atspair)
        (with-default-read ATS|Pairs atspair
            { "unlocks" : -1 }
            { "unlocks" := u }
            (enforce
                (>= u 0)
                (format "ATS-Pair {} does not exist." [atspair])
            )
        )
    )
    (defun ATS|UEV_IzTokenUnique (atspair:string reward-token:string)
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
        (with-capability (ATS|OWNERSHIP_CHANGE patron atspair new-owner)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_BIGGEST)
                true
            )
            (ATS|X_ChangeOwnership atspair new-owner)
            (DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_ToggleParameterLock (patron:string atspair:string toggle:bool)
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
        (with-capability (ATS|FUEL patron fueler atspair reward-token amount)
            (DPTF|CX_Transfer patron reward-token fueler ATS|SC_NAME amount)
            (ATS|X_UpdateRoU atspair reward-token true true amount)
        )
    )
    (defun ATS|C_Coil:decimal (patron:string coiler:string atspair:string coil-token:string amount:decimal)
        (with-capability (ATS|COIL_OR_CURL patron coiler atspair coil-token amount)
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
        (with-capability (ATS|COIL_OR_CURL patron curler atspair1 rt amount)
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
                (DPTF|CX_Transfer patron c-rbt recoverer ATS|SC_NAME ra)
            ;;2]ATS|SC_NAME burns c-rbt
                (DPTF|CX_Burn patron c-rbt ATS|SC_NAME ra)
            ;;3]ATS|SC_NAME mints h-rbt
                (DPMF|CX_Mint patron h-rbt ATS|SC_NAME ra meta-data)
            ;;4]ATS|SC_NAME transfers h-rbt to recoverer
                (DPMF|CX_Transfer patron h-rbt new-nonce ATS|SC_NAME recoverer ra)
            )
        )
    )
    (defun ATS|C_ColdRecovery (patron:string recoverer:string atspair:string ra:decimal)
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
                    (standard-split:[decimal] (ATS|UCC_RTSplitAmounts atspair ra))
                    (rt-precision-lst:[integer] (ATS|UR_RtPrecisions atspair))
                    (negative-c-fr:[[decimal]] (UTILITY.UC_ListPromileSplit fee-promile standard-split rt-precision-lst))

                    ;;for true
                    (positive-c-fr:[decimal] (ATS|UCC_RTSplitAmounts atspair (at 0 c-rbt-fee-split)))

                )
            ;;1]Recoverer transfers c-rbt to the ATS|SC_NAME
                (DPTF|CX_Transfer patron c-rbt recoverer ATS|SC_NAME ra)
            ;;2]ATS|SC_NAME burns c-rbt and handles c-fr
                (DPTF|CX_Burn patron c-rbt ATS|SC_NAME ra)
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
                                (DPTF|CX_Burn patron (at index rt-lst) ATS|SC_NAME (at index (at 1 negative-c-fr)))
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
                                (DPTF|CX_Transfer patron (at idx rt-lst) ATS|SC_NAME culler (at idx cw))
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
        (with-capability (ATS|REMOVE_SECONDARY patron atspair reward-token)
            (if (not (GAS|UC_SubZero))
                (GAS|X_Collect patron (ATS|UR_OwnerKonto atspair) UTILITY.GAS_ISSUE)
                true
            )
            (ATS|X_RemoveSecondary atspair reward-token)
            (DALOS|X_IncrementNonce patron)
            (DPTF|X_UpdateRewardToken atspair reward-token false)
            ;;Unbonding if it exists for pair, must be returned to users
            ;;Resident, if it exists, must be replaced with primary.
        )
    )
    ;;6.2.3.6][A]           Revoke
    (defun ATS|C_RevokeMint (patron:string id:string)
        (if (ATS|UC_IzRBT-Absolute id true)
            (ATS|C_MassTurnColdRecoveryOff patron id)  
            true        
        )
    )
    (defun ATS|C_RevokeFeeExemption (patron:string id:string)
        (if (ATS|UC_IzRT-Absolute id)
            (ATS|C_MassTurnColdRecoveryOff patron id)  
            true
        )
    )
    (defun ATS|C_RevokeCreateOrAddQ (patron:string id:string)
        (if (ATS|UC_IzRBT-Absolute id false)
            (ATS|C_TurnRecoveryOff patron (DPMF|UR_RewardBearingToken id) false)
            true
        )
    )
    (defun ATS|C_RevokeBurn (patron:string id:string cold-or-hot:bool)
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
        (require-capability (ATS|X_OWNERSHIP_CHANGE atspair new-owner))
        (update ATS|Pairs atspair
            {"owner-konto"                      : new-owner}
        )
    )
    (defun ATS|X_ToggleParameterLock:[decimal] (atspair:string toggle:bool)
        (require-capability (ATS|X_TOGGLE_PARAMETER-LOCK atspair toggle))
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
        (require-capability (ATS|X_TOGGLE_FEE atspair toggle fee-switch))
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
        (require-capability (ATS|X_SET_CRD atspair soft-or-hard base growth))
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
        (require-capability (ATS|X_SET_COLD_FEE atspair fee-positions fee-thresholds fee-array))
        (update ATS|Pairs atspair
            { "c-positions"     : fee-positions
            , "c-limits"        : fee-thresholds 
            , "c-array"         : fee-array}
        )
    )
    (defun ATS|X_SetHotFee (atspair:string promile:decimal decay:integer)
        (require-capability (ATS|X_SET_HOT_FEE atspair promile decay))
        (update ATS|Pairs atspair
            { "h-promile"       : promile
            , "h-decay"         : decay}
        )
    )
    (defun ATS|X_ToggleElite (atspair:string toggle:bool)
        (require-capability (ATS|X_TOGGLE_ELITE atspair toggle))
        (update ATS|Pairs atspair
            { "c-elite-mode" : toggle}
        )
    )
    (defun ATS|X_TurnRecoveryOn (atspair:string cold-or-hot:bool)
        (require-capability (ATS|X_RECOVERY-ON atspair cold-or-hot))
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
        (require-capability (ATS|X_RECOVERY-OFF atspair cold-or-hot))
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
        (require-capability (ATS|X_ISSUE (UTILITY.DALOS|UC_Makeid atspair) account reward-token reward-bearing-token))
        (insert ATS|Pairs (UTILITY.DALOS|UC_Makeid atspair)
            {"owner-konto"                          : account
            ,"can-change-owner"                     : true
            ,"parameter-lock"                       : false
            ,"unlocks"                              : 0
            ;;Index
            ,"pair-index-name"                      : atspair
            ,"index-decimals"                       : index-decimals
            ;;Reward Tokens
            ,"reward-tokens"                        : [(ATS|UCC_ComposePrimaryRewardToken reward-token rt-nfr)]
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
            ,"h-rbt"                                : UTILS.BAR
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
        (require-capability (ATS|X_ADD_SECONDARY atspair reward-token true))
        (with-read ATS|Pairs atspair
            { "reward-tokens" := rt }
            (update ATS|Pairs atspair
                {"reward-tokens" : (UTILS.LIST|UC_AppendLast rt (ATS|UCC_ComposePrimaryRewardToken reward-token rt-nfr))}
            )
        )
    )
    (defun ATS|X_AddHotRBT (atspair:string hot-rbt:string)
        (require-capability (ATS|X_ADD_SECONDARY atspair hot-rbt false))
        (update ATS|Pairs atspair
            {"h-rbt" : hot-rbt}
        )
    )
    (defun ATS|X_RemoveSecondary (atspair:string reward-token:string)
        (require-capability (ATS|X_REMOVE_SECONDARY atspair reward-token))
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
                            (ATS|UCC_RT reward-token nfr (+ resident amount) unbonding)
                            (ATS|UCC_RT reward-token nfr (- resident amount) unbonding)
                        )
                        (if (= direction true)
                            (ATS|UCC_RT reward-token nfr resident (+ unbonding amount))
                            (ATS|UCC_RT reward-token nfr resident (- unbonding amount))
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
        (require-capability (ATS|UPDATE_LEDGER))
        (update ATS|Ledger (concat [atspair UTILS.BAR account])
            { "P0" : obj}
        )
    )
    (defun ATS|X_StoreUnstakeObject (atspair:string account:string position:integer obj:object{ATS|Unstake})
        (require-capability (ATS|UPDATE_LEDGER))
        (with-read ATS|Ledger (concat [atspair UTILS.BAR account])
            { "P0"  := p0 , "P1"  := p1 , "P2"  := p2 , "P3"  := p3, "P4"  := p4, "P5"  := p5, "P6"  := p6, "P7"  := p7 }
            (if (= position -1)
                (if (and 
                        (= (length p0) 1)
                        (= 
                            (at 0 p0) 
                            (ATS|UCC_MakeZeroUnstakeObject atspair)
                        )
                    )
                    (update ATS|Ledger (concat [atspair UTILS.BAR account])
                        { "P0"  : [obj]}
                    )
                    (update ATS|Ledger (concat [atspair UTILS.BAR account])
                        { "P0"  : (UTILS.LIST|UC_AppendLast p0 obj)}
                    )
                )
                (if (= position 1)
                    (update ATS|Ledger (concat [atspair UTILS.BAR account])
                        { "P1"  : obj}
                    )
                    (if (= position 2)
                        (update ATS|Ledger (concat [atspair UTILS.BAR account])
                            { "P2"  : obj}
                        )
                        (if (= position 3)
                            (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                { "P3"  : obj}
                            )
                            (if (= position 4)
                                (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                    { "P4"  : obj}
                                )
                                (if (= position 5)
                                    (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                        { "P5"  : obj}
                                    )
                                    (if (= position 6)
                                        (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                            { "P6"  : obj}
                                        )
                                        (update ATS|Ledger (concat [atspair UTILS.BAR account])
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
        (require-capability (ATS|DEPLOY atspair account))
        (let
            (
                (zero:object{ATS|Unstake} (ATS|UCC_MakeZeroUnstakeObject atspair))
                (negative:object{ATS|Unstake} (ATS|UCC_MakeNegativeUnstakeObject atspair))
            )
            (with-default-read ATS|Ledger (concat [atspair UTILS.BAR account])
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
                (write ATS|Ledger (concat [atspair UTILS.BAR account])
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
        (require-capability (ATS|NORMALIZE_LEDGER atspair account))
        (with-read ATS|Ledger (concat [atspair UTILS.BAR account])
            { "P0"  := p0 , "P1"  := p1 , "P2"  := p2 , "P3"  := p3, "P4"  := p4, "P5"  := p5, "P6"  := p6, "P7"  := p7 }
            (let
                (
                    (zero:object{ATS|Unstake} (ATS|UCC_MakeZeroUnstakeObject atspair))
                    (negative:object{ATS|Unstake} (ATS|UCC_MakeNegativeUnstakeObject atspair))
                    (positions:integer (ATS|UR_ColdRecoveryPositions atspair))
                    (elite:bool (ATS|UR_EliteMode atspair))
                    (major-tier:integer (DALOS|UR_Elite-Tier-Major account))
                )
                (if (= positions -1)
                    (update ATS|Ledger (concat [atspair UTILS.BAR account])
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
                        (update ATS|Ledger (concat [atspair UTILS.BAR account])
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
                            (update ATS|Ledger (concat [atspair UTILS.BAR account])
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
                                (update ATS|Ledger (concat [atspair UTILS.BAR account])
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
                                    (update ATS|Ledger (concat [atspair UTILS.BAR account])
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
                                        (update ATS|Ledger (concat [atspair UTILS.BAR account])
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
                                            (update ATS|Ledger (concat [atspair UTILS.BAR account])
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
                                                (update ATS|Ledger (concat [atspair UTILS.BAR account])
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
                                                (update ATS|Ledger (concat [atspair UTILS.BAR account])
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
        (let*
            (
                (zero:object{ATS|Unstake} (ATS|UCC_MakeZeroUnstakeObject atspair))
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
        (let*
            (
                (zero:object{ATS|Unstake} (ATS|UCC_MakeZeroUnstakeObject atspair))
                (negative:object{ATS|Unstake} (ATS|UCC_MakeNegativeUnstakeObject atspair))
                (p0:[object{ATS|Unstake}] (ATS|UR_P0 atspair account))
                (p0l:integer (length p0))
                (bl:[bool]
                    (fold
                        (lambda
                            (acc:[bool] item:object{ATS|Unstake})
                            (UTILS.LIST|UC_AppendLast acc (ATS|UC_IzCullable item))
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
                                        (UTILS.LIST|UC_AppendLast acc (at (at idx immutables) p0))
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
                                    (UTILS.LIST|UC_AppendLast acc (at (at idx cullables) p0))
                                )
                                []
                                (enumerate 0 (- (length cullables) 1))
                            )
                        )
                        (culled-values:[[decimal]]
                            (fold
                                (lambda
                                    (acc:[[decimal]] idx:integer)
                                    (UTILS.LIST|UC_AppendLast acc (ATS|UC_CullValue (at idx to-be-culled)))
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
        (let
            (
                (wrapped-kda-id:string (DALOS|UR_WrappedKadenaID))
            )
            (enforce (!= wrapped-kda-id UTILS.BAR) "Kadena Wrapping is not live yet")
            (compose-capability (DPTF|MINT patron wrapped-kda-id LIQUID|SC_NAME amount false true))
            (compose-capability (DPTF-DPMF|TRANSFER patron wrapped-kda-id LIQUID|SC_NAME wrapper amount true true))
        )
    )
    (defcap LIQUID|UNWRAP (patron:string unwrapper:string amount:decimal)
        (let
            (
                (wrapped-kda-id:string (DALOS|UR_WrappedKadenaID))
            )
            (enforce (!= wrapped-kda-id UTILS.BAR) "Kadena Unwrapping is not live yet")
            (compose-capability (DPTF-DPMF|TRANSFER patron wrapped-kda-id unwrapper LIQUID|SC_NAME amount true true))
            (compose-capability (DPTF-DPMF|BURN patron wrapped-kda-id LIQUID|SC_NAME amount true true))
        )
    )
    ;;========[L] FUNCTIONS====================================================;;
    ;;7.2.1]  [L]   LIQUID Administration Functions
        ;;NONE
    ;;7.2.2]  [L]   LIQUID Client Functions
    (defun LIQUID|C_WrapKadena (patron:string wrapper:string amount:decimal)
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
    (defun VST|Existance (id:string token-type:bool existance:bool)
        (let
            (
                (has-vesting:bool (VST|UC_HasVesting id token-type))
            )
            (enforce (= has-vesting existance) (format "Vesting for the Token {} is not satisfied with existance {}" [id existance]))
        )
    )
    (defun VST|Active (dptf:string dpmf:string)
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
        true
    )
    ;;========[V] FUNCTIONS====================================================;;
    ;;8.2]    [V] VST Functions
    ;;8.2.1]  [V]   VST Utility Functions
    ;;8.2.1.1][V]           Computing|Composing
    (defun VST|UC_HasVesting:bool (id:string token-type:bool)
        (if (= (DPTF-DPMF|UR_Vesting id token-type) UTILS.BAR)
            false
            true
        )
    )
    ;;8.2.2]  [V]   VST Administration Functions
        ;;NONE
    ;;8.2.3]  [V]   VST Client Functions
    (defun VST|C_CreateVestingLink (patron:string dptf:string)
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