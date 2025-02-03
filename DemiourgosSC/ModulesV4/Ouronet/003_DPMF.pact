;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module DPMF GOV
    ;;
    (implements OuronetPolicy)
    (implements DalosSchemas)
    (implements DemiourgosPactMetaFungible)
    ;;{G1}
    (defconst GOV|MD_DPMF           (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|DPMF_ADMIN))
    )
    (defcap GOV|DPMF_ADMIN ()
        (enforce-guard GOV|MD_DPMF)
    )
    ;;{G3}
    (defun GOV|Demiurgoi ()
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::GOV|Demiurgoi)
        )
    )
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S}) 
    ;;{P3}
    (defcap P|DALOS|UP_BLC ()
        true
    )
    (defcap P|DALOS|UP_ELT ()
        true
    )
    (defcap P|DPTF|UP_VST ()
        true
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|DPMF_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        (let
            (
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
            )
            (ref-P|DALOS::P|A_Add 
                "DPMF|UpPrBl"
                (create-capability-guard (P|DALOS|UP_BLC))
            )
            (ref-P|DALOS::P|A_Add 
                "DPMF|UpdateElite"
                (create-capability-guard (P|DALOS|UP_ELT))
            )
            (ref-P|DPTF::P|A_Add 
                "DPMF|UpVes"
                (create-capability-guard (P|DPTF|UP_VST))
            )
        )
    )
    ;;
    ;;{1}
    (defschema DPMF|PropertiesSchema
        branding:object{DalosSchemas.BrandingSchema}
        branding-pending:object{DalosSchemas.BrandingSchema}
        owner-konto:string
        name:string
        ticker:string
        decimals:integer
        can-change-owner:bool                  
        can-upgrade:bool
        can-add-special-role:bool
        can-freeze:bool
        can-wipe:bool
        can-pause:bool
        is-paused:bool
        can-transfer-nft-create-role:bool
        supply:decimal
        create-role-account:string
        role-transfer-amount:integer
        nonces-used:integer
        reward-bearing-token:string
        vesting:string
    )
    (defschema DPMF|BalanceSchema
        @doc "Key = <DPMF id> + BAR + <account>"
        unit:[object{DemiourgosPactMetaFungible.DPMF|Schema}]
        role-nft-add-quantity:bool
        role-nft-burn:bool
        role-nft-create:bool
        role-transfer:bool
        frozen:bool
    )
    (defschema DPMF|RoleSchema
        r-nft-burn:[string]
        r-nft-create:[string]
        r-nft-add-quantity:[string]
        r-transfer:[string]
        a-frozen:[string]
    )
    ;;{2}
    (deftable DPMF|PropertiesTable:{DPMF|PropertiesSchema})
    (deftable DPMF|BalanceTable:{DPMF|BalanceSchema})
    (deftable DPMF|RoleTable:{DPMF|RoleSchema})
    ;;{3}
    (defun CT_Bar ()
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
            )
            (ref-U|CT::CT_BAR)
        )
    )
    (defun CT_DefaultBranding ()
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DPTF::CT_DefaultBranding)
        )
    )
    (defun CT_SocialEmpty ()
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DPTF::CT_SocialEmpty)
        )
    )
    (defconst BAR (CT_Bar))
    (defconst BRANDING|DEFAULT (CT_DefaultBranding))
    (defconst SOCIAL|EMPTY (CT_SocialEmpty))
    (defconst DPMF|NEUTRAL
        { "nonce": 0
        , "balance": 0.0
        , "meta-data": [{}] }
    )
    (defconst DPMF|NEGATIVE
        { "nonce": -1
        , "balance": -1.0
        , "meta-data": [{}] }
    )
    ;;
    ;;{C1}
    (defcap SECURE ()
        true
    )
    (defcap DALOS|EXECUTOR ()
        true
    )
    (defcap DPMF|CREDIT ()
        true
    )
    (defcap DPMF|DEBIT ()
        true
    )
    (defcap DPMF|DEBIT_PUR ()
        true
    )
    (defcap DPMF|INCR_NONCE ()
        true
    )
    (defcap DPMF|UPRL-TA ()
        true
    )
    (defcap DPMF|UP_SPLY () 
        true
    )
    ;;{C2}
    (defcap DPMF|S>CTRL (id:string)
        @event
        (CAP_Owner id )
        (UEV_CanUpgradeON id)
    )
    (defcap DPMF|S>X_FRZ-ACC (id:string account:string frozen:bool)
        (CAP_Owner id)
        (UEV_CanFreezeON id)
        (UEV_AccountFreezeState id account (not frozen))
    )
    (defcap DPMF|S>RT_OWN (id:string new-owner:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::UEV_SenderWithReceiver (UR_Konto id) new-owner)
            (ref-DALOS::UEV_EnforceAccountExists new-owner)
            (CAP_Owner id)
            (UEV_CanChangeOwnerON id)
        )
    )
    (defcap DPMF|S>TG_BURN-R (id:string account:string toggle:bool)
        @event
        (if toggle
            (UEV_CanAddSpecialRoleON id)
            true
        )
        (CAP_Owner id)
        (UEV_AccountBurnState id account (not toggle))
    )
    (defcap DPMF|S>TG_PAUSE (id:string pause:bool)
        @event
        (if pause
            (UEV_CanPauseON id)
            true
        )
        (CAP_Owner id)
        (UEV_PauseState id (not pause))
    )
    (defcap DPMF|S>X_TG_TRANSFER-R (id:string account:string toggle:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
            )
            (enforce (!= account ouroboros) (format "{} Account is immune to transfer roles" [ouroboros]))
            (enforce (!= account dalos) (format "{} Account is immune to transfer roles" [dalos]))
            (if toggle
                (UEV_CanAddSpecialRoleON id)
                true
            )
            (CAP_Owner id)
            (UEV_AccountTransferState id account (not toggle))
        )
    )
    (defcap DPMF|S>MOVE_CREATE-R (id:string receiver:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::UEV_SenderWithReceiver (UR_CreateRoleAccount id) receiver)
            (CAP_Owner id)
            (UEV_CanTransferNFTCreateRoleON id)
            (UEV_AccountCreateState id (UR_CreateRoleAccount id) true)
            (UEV_AccountCreateState id receiver false)
        )
        
    )
    (defcap DPMF|S>TG_ADD-QTY-R (id:string account:string toggle:bool)
        @event
        (CAP_Owner id)
        (UEV_AccountAddQuantityState id account (not toggle))
        (if toggle
            (UEV_CanAddSpecialRoleON id)
            true
        )
    )
    ;;{C3}
    (defcap DPMF|F>OWNER (id:string)
        (CAP_Owner id)
    )
    ;;{C4}
    (defcap BASIS|C>X_WRITE-ROLES (id:string account:string rp:integer)
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-U|INT::UEV_PositionalVariable rp 5 "Invalid Role Position")
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id)
            (compose-capability (SECURE))
        )
    )
    (defcap DPMF|C>BURN (id:string client:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership client)
            (UEV_Amount id amount)
            (UEV_AccountBurnState id client true)
            (compose-capability (DPMF|DEBIT))
            (compose-capability (DPMF|UP_SPLY))
        )
    )
    (defcap DPMF|FC>FRZ-ACC (id:string account:string frozen:bool)
        @event
        (compose-capability (DPMF|S>X_FRZ-ACC id account frozen))
        (compose-capability (BASIS|C>X_WRITE-ROLES id account 5))
    )
    (defcap DPMF|C>ISSUE (account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        @event
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-DALOS:module{OuronetDalos} DALOS)
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
            )
            (ref-U|INT::UEV_UniformList lengths)
            (ref-U|LST::UC_IzUnique name)
            (ref-U|LST::UC_IzUnique ticker)
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (compose-capability (SECURE))
        )
    )
    (defcap DPMF|C>TG_TRANSFER-R (id:string account:string toggle:bool)
        @event
        (compose-capability (DPMF|S>X_TG_TRANSFER-R id account toggle))
        (compose-capability (DPMF|UPRL-TA))
        (compose-capability (BASIS|C>X_WRITE-ROLES id account 4))
    )
    (defcap DPMF|C>WIPE (id:string account-to-be-wiped:string)
        @event
        (UEV_CanWipeON id)
        (UEV_AccountFreezeState id account-to-be-wiped true)
        (compose-capability (DPMF|DEBIT))
        (compose-capability (DPMF|UP_SPLY))
    )
    (defcap DPMF|C>ADD-QTY (id:string client:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership client)
            (UEV_Amount id amount)
            (UEV_AccountAddQuantityState id client true)
            (compose-capability (DPMF|CREDIT))
            (compose-capability (DPMF|UP_SPLY))
        )
    )
    (defcap DPMF|C>CREATE (id:string client:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership client)
            (UEV_AccountCreateState id client true)
            (compose-capability (DPMF|INCR_NONCE))
        )
    )
    (defcap DPMF|C>MINT (id:string client:string amount:decimal)
        @event
        (compose-capability (DPMF|C>CREATE id client))
        (compose-capability (DPMF|C>ADD-QTY id client amount))
    )
    (defcap DPMF|C>TRANSFER (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
            )
            (ref-DALOS::CAP_EnforceAccountOwnership sender)
            (if (and method (ref-DALOS::UR_AccountType receiver))
                (ref-DALOS::CAP_EnforceAccountOwnership receiver)
                true
            )
            (UEV_Amount id transfer-amount)
            (ref-DALOS::UEV_EnforceTransferability sender receiver method)
            (UEV_PauseState id false)
            (UEV_AccountFreezeState id sender false)
            (UEV_AccountFreezeState id receiver false)
            (if
                (and 
                    (> (UR_TransferRoleAmount id) 0) 
                    (not (or (= sender ouroboros)(= sender dalos)))
                )
                (let
                    (
                        (s:bool (UR_AccountRoleTransfer id sender))
                        (r:bool (UR_AccountRoleTransfer id receiver))
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
            (compose-capability (DPMF|DEBIT))
            (compose-capability (DPMF|CREDIT))
            (compose-capability (P|DALOS|UP_ELT))
        ) 
    )
    ;;
    ;;{F0}
    (defun UR_P-KEYS:[string] ()
        (keys DPMF|PropertiesTable)
    )
    (defun UR_KEYS:[string] ()
        (keys DPMF|BalanceTable)
    )
    (defun UR_Branding:object{DalosSchemas.BrandingSchema} (id:string pending:bool)
        (UEV_id id)
        (if pending
            (with-read DPMF|PropertiesTable id
                { "branding-pending" := b }
                b
            )
            (with-read DPMF|PropertiesTable id
                { "branding" := b }
                b
            )
        )
    )
    (defun URB_Logo:string (id:string pending:bool)
        (at "logo" (UR_Branding id pending))
    )
    (defun URB_Description:string (id:string pending:bool)
        (at "description" (UR_Branding id pending))
    )
    (defun URB_Website:string (id:string pending:bool)
        (at "website" (UR_Branding id pending))
    )
    (defun URB_Social:[object{DalosSchemas.SocialSchema}] (id:string pending:bool)
        (at "social" (UR_Branding id pending))
    )
    (defun URB_Flag:integer (id:string pending:bool)
        (at "flag" (UR_Branding id pending))
    )
    (defun URB_Genesis:time (id:string pending:bool)
        (at "genesis" (UR_Branding id pending))
    )
    (defun URB_PremiumUntil:time (id:string pending:bool)
        (at "premium-until" (UR_Branding id pending))
    )
    (defun UR_Konto:string (id:string)
        (at "owner-konto" (read DPMF|PropertiesTable id ["owner-konto"]))
    )
    (defun UR_Name:string (id:string)
        (at "name" (read DPMF|PropertiesTable id ["name"]))
    )
    (defun UR_Ticker:string (id:string)
        (at "ticker" (read DPMF|PropertiesTable id ["ticker"])) 
    )
    (defun UR_Decimals:integer (id:string)
        (at "decimals" (read DPMF|PropertiesTable id ["decimals"]))
    )
    (defun UR_CanChangeOwner:bool (id:string)
        (at "can-change-owner" (read DPMF|PropertiesTable id ["can-change-owner"]))
    )
    (defun UR_CanUpgrade:bool (id:string)
        (at "can-upgrade" (read DPMF|PropertiesTable id ["can-upgrade"]))  
    )
    (defun UR_CanAddSpecialRole:bool (id:string)
        (at "can-add-special-role" (read DPMF|PropertiesTable id ["can-add-special-role"]))
    )
    (defun UR_CanFreeze:bool (id:string)
        (at "can-freeze" (read DPMF|PropertiesTable id ["can-freeze"]))
    )
    (defun UR_CanWipe:bool (id:string)
        (at "can-wipe" (read DPMF|PropertiesTable id ["can-wipe"]))
    )
    (defun UR_CanPause:bool (id:string)
        (at "can-pause" (read DPMF|PropertiesTable id ["can-pause"]))
    )
    (defun UR_Paused:bool (id:string)
        (at "is-paused" (read DPMF|PropertiesTable id ["is-paused"]))
    )
    (defun UR_Supply:decimal (id:string)
        (at "supply" (read DPMF|PropertiesTable id ["supply"]))
    )
    (defun UR_TransferRoleAmount:integer (id:string)
        (at "role-transfer-amount" (read DPMF|PropertiesTable id ["role-transfer-amount"]))
    )
    (defun UR_Vesting:string (id:string)
        (at "vesting" (read DPMF|PropertiesTable id ["vesting"]))
    )
    (defun UR_Roles:[string] (id:string rp:integer)
        (if (= rp 1)
            (with-default-read DPMF|RoleTable id
                { "r-burn" : [BAR]}
                { "r-burn" := rb }
                rb
            )
            (if (= rp 2)
                (with-default-read DPMF|RoleTable id
                    { "r-nft-create" : [BAR]}
                    { "r-nft-create" := rnc }
                    rnc
                )
                (if (= rp 3)
                    (with-default-read DPMF|RoleTable id
                        { "r-nft-add-quantity" : [BAR]}
                        { "r-nft-add-quantity" := rnaq }
                        rnaq
                    )
                    (if (= rp 4)
                        (with-default-read DPMF|RoleTable id
                            { "r-transfer" : [BAR]}
                            { "r-transfer" := rt }
                            rt
                        )
                        (with-default-read DPMF|RoleTable id
                            { "a-frozen" : [BAR]}
                            { "a-frozen" := af }
                            af
                        )
                    )
                )
            )
        )
    )
    (defun UR_CanTransferNFTCreateRole:bool (id:string)
        (at "can-transfer-nft-create-role" (read DPMF|PropertiesTable id ["can-transfer-nft-create-role"]))
    )
    (defun UR_CreateRoleAccount:string (id:string)
        (at "create-role-account" (read DPMF|PropertiesTable id ["create-role-account"]))
    )
    (defun UR_NoncesUsed:integer (id:string)
        (at "nonces-used" (read DPMF|PropertiesTable id ["nonces-used"]))
    )
    (defun UR_RewardBearingToken:string (id:string)
        (at "reward-bearing-token" (read DPMF|PropertiesTable id ["reward-bearing-token"]))
    )
    (defun UR_AccountSupply:decimal (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id BAR  account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let 
                (
                    (result 
                        (fold
                            (lambda 
                                (acc:decimal item:object{DemiourgosPactMetaFungible.DPMF|Schema})
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
    (defun UR_AccountRoleBurn:bool (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "role-nft-burn" : false}
            { "role-nft-burn" := rb }
            rb
        )
    )
    (defun UR_AccountRoleTransfer:bool (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "role-transfer" : false }
            { "role-transfer" := rt }
            rt
        )
    )
    (defun UR_AccountFrozenState:bool (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "frozen" : false}
            { "frozen" := fr }
            fr
        )
    )
    (defun UR_AccountUnit:[object] (id:string account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "unit" : DPMF|NEGATIVE}
            { "unit" := u }
            u
        )
    )
    (defun UR_AccountBalances:[decimal] (id:string account:string)
        (UEV_id id)
            (with-default-read DPMF|BalanceTable (concat [id BAR account])
                { "unit" : [DPMF|NEUTRAL] }
                { "unit" := read-unit}
                (let 
                    (
                        (ref-U|LST:module{StringProcessor} U|LST)
                    )
                    (fold
                        (lambda 
                            (acc:[decimal] item:object{DemiourgosPactMetaFungible.DPMF|Schema})
                            (if (!= (at "balance" item) 0.0)
                                    (ref-U|LST::UC_AppL acc (at "balance" item))
                                    acc
                            )
                        )
                        []
                        read-unit
                    )
                )
            )
        
    )
    (defun UR_AccountBatchMetaData (id:string nonce:integer account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (fold
                (lambda 
                    (acc item:object{DemiourgosPactMetaFungible.DPMF|Schema})
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
    (defun UR_AccountBatchSupply:decimal (id:string nonce:integer account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (fold
                (lambda 
                    (acc:decimal item:object{DemiourgosPactMetaFungible.DPMF|Schema})
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
    (defun UR_AccountNonces:[integer] (id:string account:string)
        (UEV_id id false)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "unit" : [DPMF|NEUTRAL] }
            { "unit" := read-unit}
            (let 
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                )
                (fold
                    (lambda 
                        (acc:[integer] item:object{DemiourgosPactMetaFungible.DPMF|Schema})
                        (if (!= (at "nonce" item) 0)
                                (ref-U|LST::UC_AppL acc (at "nonce" item))
                                acc
                        )
                    )
                    []
                    read-unit
                )
            )
        )
    )
    (defun UR_AccountRoleNFTAQ:bool (id:string account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "role-nft-add-quantity" : false}
            { "role-nft-add-quantity" := rnaq }
            rnaq
        )
    )
    (defun UR_AccountRoleCreate:bool (id:string account:string)
        (UEV_id id)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "role-nft-create" : false}
            { "role-nft-create" := rnc }
            rnc
        )
    )
    ;;{F1}
    (defun URC_IzRBT:bool (reward-bearing-token:string)
        @doc "Returns a boolean, if token id is RBT in any atspair"
        (UEV_id reward-bearing-token)
        (if (= (UR_RewardBearingToken reward-bearing-token) BAR)
            false
            true
        )
    )
    (defun URC_IzRBTg:bool (atspair:string reward-bearing-token:string)
        @doc "Returns a boolean, if token id is RBT in a specific atspair"
        (UEV_id reward-bearing-token)
        (if (= (UR_RewardBearingToken reward-bearing-token) BAR)
            false
            (if (= (UR_RewardBearingToken reward-bearing-token) atspair)
                true
                false
            )
        )
    )
    (defun URC_EliteAurynzSupply (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
            )
            (if (!= ea-id BAR)
                (let
                    (
                        (ea-supply:decimal (ref-DPTF::UR_AccountSupply ea-id account))
                        (vea:string (ref-DPTF::UR_Vesting ea-id))
                    )
                    (if (!= vea BAR)
                        (+ ea-supply (UR_AccountSupply vea account))
                        ea-supply
                    )
                )
                true
            )
        )
    )
    (defun URC_AccountExist:bool (id:string account:string)
        (with-default-read DPMF|BalanceTable (concat [id BAR account])
            { "unit" : [DPMF|NEGATIVE] }
            { "unit" := u}
            (if (= u [DPMF|NEGATIVE])
                false
                true
            )
        )
    )
    (defun URC_HasVesting:bool (id:string)
        @doc "Returns a boolean if DPMF has a vesting counterpart"
        (if (= (UR_Vesting id) BAR)
            false
            true
        )
    )
    ;;{F2}
    (defun UEV_UpdateRewardBearingToken (id:string)
        (let
            (
                (rbt:string (UR_RewardBearingToken id))
            )
            (enforce (= rbt BAR) "RBT for a DPMF is immutable")
        )
    )
    (defun UEV_CanChangeOwnerON (id:string)
        (let
            (
                (x:bool (UR_CanChangeOwner id))
            )
            (enforce (= x true) (format "{} ownership cannot be changed" [id]))
        )
    )
    (defun UEV_CanUpgradeON (id:string)
        (let
            (
                (x:bool (UR_CanUpgrade id))
            )
            (enforce (= x true) (format "{} properties cannot be upgraded" [id])
            )
        )
    )
    (defun UEV_CanAddSpecialRoleON (id:string)
        (let
            (
                (x:bool (UR_CanAddSpecialRole id))
            )
            (enforce (= x true) (format "For {} no special roles can be added" [id])
            )
        )
    )
    (defun UEV_CanFreezeON (id:string)
        (let
            (
                (x:bool (UR_CanFreeze id))
            )
            (enforce (= x true) (format "{} cannot be freezed" [id])
            )
        )
    )
    (defun UEV_CanWipeON (id:string)
        (let
            (
                (x:bool (UR_CanWipe id))
            )
            (enforce (= x true) (format "{} cannot be wiped" [id])
            )
        )
    )
    (defun UEV_CanPauseON (id:string)
        (let
            (
                (x:bool (UR_CanPause id))
            )
            (enforce (= x true) (format "{} cannot be paused" [id])
            )
        )
    )
    (defun UEV_PauseState (id:string state:bool)
        (let
            (
                (x:bool (UR_Paused id))
            )
            (if state
                (enforce x (format "{} is already unpaused" [id]))
                (enforce (= x false) (format "{} is already paused" [id]))
            )
        )
    )
    (defun UEV_AccountBurnState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_AccountRoleBurn id account))
            )
            (enforce (= x state) (format "Burn Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountTransferState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_AccountRoleTransfer id account))
            )
            (enforce (= x state) (format "Transfer Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountFreezeState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_AccountFrozenState id account))
            )
            (enforce (= x state) (format "Frozen for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_Amount (id:string amount:decimal)
        (let
            (
                (decimals:integer (UR_Decimals id))
            )
            (enforce
                (= (floor amount decimals) amount)
                (format "{} is not conform with the {} prec" [amount id])
            )
            (enforce
                (> amount 0.0)
                (format "{} is not a Valid Transaction amount" [amount])
            )
        )
    )
    (defun UEV_CheckID:bool (id:string)
        (with-default-read DPMF|PropertiesTable id
            { "supply" : -1.0 }
            { "supply" := s }
            (if (>= s 0.0)
                true
                false
            )
        )
    )
    (defun UEV_id (id:string)
        (with-default-read DPMF|PropertiesTable id
            { "supply" : -1.0 }
            { "supply" := s }
            (enforce
                (>= s 0.0)
                (format "DPMF ID {} does not exist" [id])
            )
        )
    )
    (defun UEV_CanTransferNFTCreateRoleON (id:string)
        (let
            (
                (x:bool (UR_CanTransferNFTCreateRole id))
            )
            (enforce (= x true) (format "DPMF Token {} cannot have its create role transfered" [id])
            )
        )
    )
    (defun UEV_AccountAddQuantityState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_AccountRoleNFTAQ id account))
            )
            (enforce (= x state) (format "Add Quantity Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_AccountCreateState (id:string account:string state:bool)
        (let
            (
                (x:bool (UR_AccountRoleCreate id account))
            )
            (enforce (= x state) (format "Create Role for {} on Account {} must be set to {} for exec" [id account state]))
        )
    )
    (defun UEV_Vesting (id:string existance:bool)
        (let
            (
                (has-vesting:bool (URC_HasVesting id))
            )
            (enforce (= has-vesting existance) (format "Vesting for the Token {} is not satisfied with existance {}" [id existance]))
        )
    )
    ;;{F3}
    (defun UDC_Compose:object{DemiourgosPactMetaFungible.DPMF|Schema} (nonce:integer balance:decimal meta-data:[object])
        @doc "Composes a DPMF Object"
        {"nonce" : nonce, "balance": balance, "meta-data" : meta-data}
    )
    (defun UDC_Nonce-Balance:[object{DemiourgosPactMetaFungible.DPMF|Nonce-Balance}] (nonce-lst:[integer] balance-lst:[decimal])
        @doc "Composes a Nonce-Balance Object, needed for Wiping functionality"
        (let
            (
                (nonce-length:integer (length nonce-lst))
                (balance-length:integer (length balance-lst))
            )
            (enforce (= nonce-length balance-length) "Nonce and Balance Lists are not of equal length")
            (zip (lambda (x:integer y:decimal) { "nonce": x, "balance": y }) nonce-lst balance-lst)
        )
    )
    ;;{F4}
    (defun CAP_Owner (id:string)
        @doc "Enforces DPMF Token ID Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (UR_Konto id))
        )
    )
    ;;
    ;;{F5}
    ;;{F6}
    (defun C_RotateOwnership (patron:string id:string new-owner:string)
        @doc "Rotates DPMF ID Ownership"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|S>RT_OWN id new-owner)
                (X_ChangeOwnership id new-owner)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|biggest"))
            )
        )
    )
    (defun C_DeployAccount (id:string account:string)
        @doc "Deploys a DPMF Account"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (create-role-account:string (UR_CreateRoleAccount id))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (UEV_id id)
            (with-default-read DPMF|BalanceTable (concat [id BAR account])
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
                (write DPMF|BalanceTable (concat [id BAR account])
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
    (defun C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Toggles Freezing of a DPMF Account"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|FC>FRZ-ACC id account toggle)
                (X_ToggleFreezeAccount id account toggle)
                (X_WriteRoles id account 5 toggle)
                (ref-DALOS::IGNIS|C_Collect patron account (ref-DALOS::UR_UsagePrice "ignis|big"))
            )
        )
    )
    (defun C_TogglePause (patron:string id:string toggle:bool)
        @doc "Toggles Pause for a DPMF Token"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|S>TG_PAUSE id toggle)
                (X_TogglePause id toggle)
                (ref-DALOS::IGNIS|C_Collect patron patron (ref-DALOS::UR_UsagePrice "ignis|medium"))
            )
        )
    )
    (defun C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles Transfer-Role for a DPMF Token on a specific account"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|C>TG_TRANSFER-R id account toggle)
                (X_ToggleTransferRole id account toggle)
                (X_UpdateRoleTransferAmount id toggle)
                (X_WriteRoles id account 4 toggle)
                (ref-DALOS::IGNIS|C_Collect patron account (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_Wipe (patron:string id:string atbw:string)
        @doc "Wipes a DPMF Token from a given account"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|C>WIPE id atbw)
                (X_Wipe id atbw)
                (ref-DALOS::IGNIS|C_CollectWT patron atbw (ref-DALOS::UR_UsagePrice "ignis|biggest") (ref-DALOS::IGNIS|URC_ZeroGAS id atbw))
            )
        )
    )
    (defun C_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Adds quantity for a DPMF Token"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|C>ADD-QTY id account amount)
                (X_AddQuantity id nonce account amount)
                (ref-DALOS::IGNIS|C_CollectWT patron account (ref-DALOS::UR_UsagePrice "ignis|small") (ref-DALOS::IGNIS|URC_ZeroGAS id account))
            )
        )
    )
    (defun C_Burn (patron:string id:string nonce:integer account:string amount:decimal)
        @doc "Burns a DPMF Token from an account"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|C>BURN id account amount)
                (X_Burn id nonce account amount)
                (ref-DALOS::IGNIS|C_CollectWT patron account (ref-DALOS::UR_UsagePrice "ignis|small") (ref-DALOS::IGNIS|URC_ZeroGAS id account))
            )
        )
    )
    (defun C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool)
        @doc "Controls the properties of a DPTF Token \
            \ <can-change-owner> <can-upgrade> <can-add-special-role> <can-freeze> <can-wipe> <can-pause> <can-transfer-nft-create-role>"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|S>CTRL id)
                (X_Control patron id cco cu casr cf cw cp ctncr)
                (ref-DALOS::IGNIS|C_Collect patron (UR_Konto id) (ref-DALOS::UR_UsagePrice "ignis|small"))
            )
        )
    )
    (defun C_Create:integer (patron:string id:string account:string meta-data:[object])
        @doc "Creates a DPMF Token (id must already be issued), only creating a new nonce, without adding quantity"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|C>CREATE id account)
                (ref-DALOS::IGNIS|C_CollectWT patron account (ref-DALOS::UR_UsagePrice "ignis|small") (ref-DALOS::IGNIS|URC_ZeroGAS id account))
                (X_Create id account meta-data)
            )
        )
    )
    (defun C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        @doc "Issues a new DPMF Token. Summoned only"
        (enforce-guard (P|UR "TALOS|Summoner"))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (l1:integer (length name))
                (mf-cost:decimal (ref-DALOS::UR_UsagePrice "dpmf"))
                (kda-costs:decimal (* (dec l1) mf-cost))
                (issued-ids:[string]
                    (with-capability (SECURE)
                        (X_IssueFree patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role)
                    )
                )                
            )
            (ref-DALOS::KDA|C_Collect patron kda-costs)
            issued-ids
        )
    )
    (defun C_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object])
        @doc "Mints a DPMF Token; minting creates it and adds quantity"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|C>MINT id account amount)
                (ref-DALOS::IGNIS|C_CollectWT patron account (ref-DALOS::UR_UsagePrice "ignis|small") (ref-DALOS::IGNIS|URC_ZeroGAS id account))
                (X_Mint id account amount meta-data)
            )
        )
    )
    (defun C_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Transfers a DPMF Token, trasnfering an amount smaller than or equal to nonce amount"
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|C>TRANSFER id sender receiver transfer-amount method)
                (ref-DALOS::IGNIS|C_CollectWT patron sender (ref-DALOS::UR_UsagePrice "ignis|smallest") (ref-DALOS::GNIS|URC_ZeroGAZ id sender receiver))
                (X_Transfer id nonce sender receiver transfer-amount method)
            )
        )
    )
    (defun C_MultiBatchTransfer (patron:string id:string nonces:[integer] sender:string receiver:string method:bool)
        @doc "Executes a MultiBatch transfer, transfering multiple nonces in single function"
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (account-nonces:[integer] (UR_AccountNonces id sender))
                (contains-all:bool (ref-U|INT::UC_ContainsAll account-nonces nonces))
            )
            (enforce contains-all "Invalid Nonce List for DPTF Multi Batch Transfer")
            (map
                (lambda
                    (single-nonce:integer)
                    (C_SingleBatchTransfer patron id single-nonce sender receiver method)
                )
                nonces
            )
        )
    )
    (defun C_SingleBatchTransfer (patron:string id:string nonce:integer sender:string receiver:string method:bool)
        @doc "Executes a single Batch Transfer, transfering the whole nonce amount"
        (let
            (
                (balance:decimal (UR_AccountBatchSupply id nonce))
            )
            (C_Transfer patron id nonce sender receiver balance method)
        )
    )
    ;;{F7}
    (defun X_UpdateElite (id:string sender:string receiver:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
            )
            (if (!= ea-id BAR)
                (if (= id ea-id)
                    (with-capability (P|DALOS|UP_ELT)
                        (ref-DALOS::X_UpdateElite sender (URC_EliteAurynzSupply sender))
                        (ref-DALOS::X_UpdateElite receiver (URC_EliteAurynzSupply receiver))
                    )
                    (let
                        (
                            (v-ea-id:string (ref-DPTF::UR_Vesting ea-id))
                        )
                        (if (and (!= v-ea-id BAR)(= id v-ea-id))
                            (with-capability (P|DALOS|UP_ELT)
                                (ref-DALOS::X_UpdateElite sender (URC_EliteAurynzSupply sender))
                                (ref-DALOS::X_UpdateElite receiver (URC_EliteAurynzSupply receiver))
                            )
                            true
                        )
                    )
                )
                true
            )
        )
    )
    (defun X_UpdateVesting (dptf:string dpmf:string)
        (enforce-guard (P|UR "VST|UpVes"))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (with-capability (P|DPTF|UP_VST)
                (ref-DPTF::X_UpdateVesting dptf dpmf)
            )
            (update DPMF|PropertiesTable dpmf
                {"vesting" : dptf}
            )
        )
        
    )
    (defun X_IssueFree:[string] 
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
        (enforce-one
            "DPMF Issue not permitted"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "VST|Caller"))
            ]
        )
        (with-capability (DPMF|C>ISSUE account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (l1:integer (length name))
                    (gas-costs:decimal (* (dec l1) (ref-DALOS::UR_UsagePrice "ignis|token-issue")))
                    (folded-lst:[string]
                        (fold
                            (lambda
                                (acc:[string] index:integer)
                                (let
                                    (
                                        (id:string
                                            (X_Issue
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
                                    (ref-U|LST::UC_AppL acc id)
                                )
                            )
                            []
                            (enumerate 0 (- l1 1))
                        )
                    )
                )
                (ref-DALOS::IGNIS|C_Collect patron account gas-costs)
                folded-lst
            )
        ) 
    )
    (defun X_UpdateBranding (id:string pending:bool branding:object{DalosSchemas.BrandingSchema})
        (enforce-guard (P|UR "BRD|Update"))
        (if pending
            (update DPMF|PropertiesTable id
                {"branding-pending" : branding}
            )
            (update DPMF|PropertiesTable id
                {"branding" : branding}
            )
        )
    )
    (defun X_ChangeOwnership (id:string new-owner:string)
        (require-capability (DPMF|S>RT_OWN id new-owner))
        (update DPMF|PropertiesTable id
            {"owner-konto"                      : new-owner}
        )
    )
    (defun X_ToggleFreezeAccount (id:string account:string toggle:bool)
        (require-capability (DPMF|S>X_FRZ-ACC id account toggle))
        (update DPMF|BalanceTable (concat [id BAR account])
            { "frozen" : toggle}
        )
    )
    (defun X_TogglePause (id:string toggle:bool)
        (require-capability (DPMF|S>TG_PAUSE id toggle))
        (update DPMF|PropertiesTable id
            { "is-paused" : toggle}
        )
    )
    (defun X_ToggleTransferRole (id:string account:string toggle:bool)
        (require-capability (DPMF|S>X_TG_TRANSFER-R id account toggle))
        (update DPMF|BalanceTable (concat [id BAR account])
            {"role-transfer" : toggle}
        )
    )
    (defun X_UpdateRoleTransferAmount (id:string direction:bool)
        (require-capability (DPMF|UPRL-TA))
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
    (defun X_UpdateSupply (id:string amount:decimal direction:bool)
        (require-capability (DPMF|UP_SPLY))
        (UEV_Amount id amount)
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
    (defun X_Wipe (id:string account-to-be-wiped:string)
        (require-capability (DPMF|C>WIPE id account-to-be-wiped))
        (let
            (
                (nonce-lst:[integer] (UR_AccountNonces id account-to-be-wiped))
                (balance-lst:[decimal] (UR_AccountBalances id account-to-be-wiped))
                (balance-sum:decimal (fold (+) 0.0 balance-lst))
            )
            (X_DebitMultiple id nonce-lst account-to-be-wiped balance-lst)
            (X_UpdateSupply id balance-sum false)
        )
    )
    (defun X_ToggleBurnRole (id:string account:string toggle:bool)
        (enforce-guard (P|UR "ATS|Caller"))
        (with-capability (DPMF|S>TG_BURN-R id account toggle)
            (update DPMF|BalanceTable (concat [id BAR account])
                {"role-nft-burn" : toggle}
            )
        )
    )
    (defun X_UpdateRewardBearingToken (atspair:string id:string)
        (enforce-guard (P|UR "ATSM|Caller"))
        (UEV_UpdateRewardBearingToken id)
        (update DPMF|PropertiesTable id
            {"reward-bearing-token" : atspair}
        )
    )
    (defun X_WriteRoles (id:string account:string rp:integer d:bool)
        (enforce-one
            "Invalid Permissions to update Reward Token"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "ATS|Caller"))
            ]
        )
        (let
            (
                (ref-U|DALOS:module{Ouronet4Dalos} U|DALOS)
            )
            (with-capability (BASIS|C>X_WRITE-ROLES id account rp)
                (with-default-read DPMF|RoleTable id
                    { "r-nft-burn"          : [BAR]
                    , "r-nft-create"        : [BAR]
                    , "r-nft-add-quantity"  : [BAR]
                    , "r-transfer"          : [BAR]
                    , "a-frozen"            : [BAR]}
                    { "r-nft-burn"          := rb
                    , "r-nft-create"        := rnc
                    , "r-nft-add-quantity"  := rnaq
                    , "r-transfer"          := rt
                    , "a-frozen"            := af}
                    (if (= rp 1)
                        (write DPMF|RoleTable id
                            { "r-nft-burn"          : (ref-U|DALOS::UC_NewRoleList rb account d)
                            , "r-nft-create"        : rnc
                            , "r-nft-add-quantity"  : rnaq
                            , "r-transfer"          : rt
                            , "a-frozen"            : af}
                        )
                        (if (= rp 2)
                            (write DPMF|RoleTable id
                                { "r-nft-burn"          : rb
                                , "r-nft-create"        : (ref-U|DALOS::UC_NewRoleList rnc account d)
                                , "r-nft-add-quantity"  : rnaq
                                , "r-transfer"          : rt
                                , "a-frozen"            : af}
                            )
                            (if (= rp 3)
                                (write DPMF|RoleTable id
                                    { "r-nft-burn"          : rb
                                    , "r-nft-create"        : rnc
                                    , "r-nft-add-quantity"  : (ref-U|DALOS::UC_NewRoleList rnaq account d)
                                    , "r-transfer"          : rt
                                    , "a-frozen"            : af}
                                )
                                (if (= rp 4)
                                    (write DPMF|RoleTable id
                                        { "r-nft-burn"          : rb
                                        , "r-nft-create"        : rnc
                                        , "r-nft-add-quantity"  : rnaq
                                        , "r-transfer"          : (ref-U|DALOS::UC_NewRoleList rt account d)
                                        , "a-frozen"            : af}
                                    )
                                    (write DPMF|RoleTable id
                                        { "r-nft-burn"          : rb
                                        , "r-nft-create"        : rnc
                                        , "r-nft-add-quantity"  : rnaq
                                        , "r-transfer"          : rt
                                        , "a-frozen"            : (ref-U|DALOS::UC_NewRoleList af account d)}
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    (defun X_AddQuantity (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|C>ADD-QTY id account amount))
        (with-read DPMF|BalanceTable (concat [id BAR account])
            { "unit" := unit }
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (current-nonce-balance:decimal (UR_AccountBatchSupply id nonce account))
                    (current-nonce-meta-data (UR_AccountBatchMetaData id nonce account))
                    (updated-balance:decimal (+ current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object{DemiourgosPactMetaFungible.DPMF|Schema} (UDC_Compose nonce current-nonce-balance current-nonce-meta-data))
                    (updated-meta-fungible:object{DemiourgosPactMetaFungible.DPMF|Schema} (UDC_Compose nonce updated-balance current-nonce-meta-data))
                    (processed-unit:[object{DemiourgosPactMetaFungible.DPMF|Schema}] (ref-U|LST::UC_ReplaceItem unit meta-fungible-to-be-replaced updated-meta-fungible))
                )
                (update DPMF|BalanceTable (concat [id BAR account])
                    {"unit" : processed-unit}    
                )
            )
        )
        (X_UpdateSupply id amount true)
    )
    (defun X_Burn (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|C>BURN id account amount))
        (X_DebitStandard id nonce account amount)
        (X_UpdateSupply id amount false)
    )
    (defun X_Control
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
        (require-capability (DPMF|S>CTRL id))
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
    (defun X_Credit (id:string nonce:integer meta-data:[object] account:string amount:decimal)
        (require-capability (DPMF|CREDIT))
        (let
            (
                (create-role-account:string (UR_CreateRoleAccount id))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF|BalanceTable (concat [id BAR account])
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
                (let
                    (
                        (ref-U|LST:module{StringProcessor} U|LST)
                        (next-unit:[object] (if (= unit [DPMF|NEGATIVE]) [DPMF|NEUTRAL] unit))
                        (is-new:bool (if (= unit [DPMF|NEGATIVE]) true false))
                        (current-nonce-balance:decimal (UR_AccountBatchSupply id nonce account))
                        (credited-balance:decimal (+ current-nonce-balance amount))
                        (present-meta-fungible:object{DemiourgosPactMetaFungible.DPMF|Schema} (UDC_Compose nonce current-nonce-balance meta-data))
                        (credited-meta-fungible:object{DemiourgosPactMetaFungible.DPMF|Schema} (UDC_Compose nonce credited-balance meta-data))
                        (processed-unit-with-replace:[object{DemiourgosPactMetaFungible.DPMF|Schema}] (ref-U|LST::UC_ReplaceItem next-unit present-meta-fungible credited-meta-fungible))
                        (processed-unit-with-append:[object{DemiourgosPactMetaFungible.DPMF|Schema}] (ref-U|LST::UC_AppL next-unit credited-meta-fungible))
                    )
                    (if (= current-nonce-balance 0.0)
                        (write DPMF|BalanceTable (concat [id BAR account])
                            { "unit"                        : processed-unit-with-append
                            , "role-nft-add-quantity"       : (if is-new false rnaq)
                            , "role-nft-burn"               : (if is-new false rb)
                            , "role-nft-create"             : (if is-new role-nft-create-boolean rnc)
                            , "role-transfer"               : (if is-new false rt)
                            , "frozen"                      : (if is-new false f)}
                        )
                        (write DPMF|BalanceTable (concat [id BAR account])
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
    (defun X_Create:integer (id:string account:string meta-data:[object])
        (require-capability (DPMF|C>CREATE id account))
        (let
            (
                (new-nonce:integer (+ (UR_NoncesUsed id) 1))
                (create-role-account:string (UR_CreateRoleAccount id))
                (role-nft-create-boolean:bool (if (= create-role-account account) true false))
            )
            (with-default-read DPMF|BalanceTable (concat [id BAR account])
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
                (let
                    (
                        (ref-U|LST:module{StringProcessor} U|LST)
                        (new-nonce:integer (+ (UR_NoncesUsed id) 1))
                        (meta-fungible:object{DemiourgosPactMetaFungible.DPMF|Schema} (UDC_Compose new-nonce 0.0 meta-data))
                        (appended-meta-fungible:[object{DemiourgosPactMetaFungible.DPMF|Schema}] (ref-U|LST::UC_AppL u meta-fungible))
                    )
                    (write DPMF|BalanceTable (concat [id BAR account])
                        { "unit"                        : appended-meta-fungible
                        , "role-nft-add-quantity"       : rnaq
                        , "role-nft-burn"               : rb
                        , "role-nft-create"             : rnc
                        , "role-transfer"               : rt
                        , "frozen"                      : f}
                    )
                    (X_IncrementNonce id)
                    new-nonce
                )
            )
        )
    )
    (defun X_DebitAdmin (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|DEBIT))
        (with-capability (DPMF|DEBIT_PUR)
            (CAP_Owner id false)
            (X_DebitPure id nonce account amount)
        )
    )
    (defun X_DebitStandard (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|DEBIT))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (DPMF|DEBIT_PUR)
                (ref-DALOS::CAP_EnforceAccountOwnership account)
                (X_DebitPure id nonce account amount)
            )
        )
    )
    (defun X_DebitPure (id:string nonce:integer account:string amount:decimal)
        (require-capability (DPMF|DEBIT_PUR))
        (with-read DPMF|BalanceTable (concat [id BAR account])
            {"unit"                                 := unit  
            ,"role-nft-add-quantity"                := rnaq
            ,"role-nft-burn"                        := rnb
            ,"role-nft-create"                      := rnc
            ,"role-transfer"                        := rt
            ,"frozen"                               := f}
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (current-nonce-balance:decimal (UR_AccountBatchSupply id nonce account))
                    (current-nonce-meta-data (UR_AccountBatchMetaData id nonce account))
                    (debited-balance:decimal (- current-nonce-balance amount))
                    (meta-fungible-to-be-replaced:object{DemiourgosPactMetaFungible.DPMF|Schema} (UDC_Compose nonce current-nonce-balance current-nonce-meta-data))
                    (debited-meta-fungible:object{DemiourgosPactMetaFungible.DPMF|Schema} (UDC_Compose nonce debited-balance current-nonce-meta-data))
                    (processed-unit-with-remove:[object{DemiourgosPactMetaFungible.DPMF|Schema}] (ref-U|LST::UC_RemoveItem unit meta-fungible-to-be-replaced))
                    (processed-unit-with-replace:[object{DemiourgosPactMetaFungible.DPMF|Schema}] (ref-U|LST::UC_ReplaceItem unit meta-fungible-to-be-replaced debited-meta-fungible))
                )
                (enforce (>= debited-balance 0.0) "Insufficient Funds for debiting")
                (if (= debited-balance 0.0)
                    (update DPMF|BalanceTable (concat [id BAR account])
                        {"unit"                     : processed-unit-with-remove
                        ,"role-nft-add-quantity"    : rnaq
                        ,"role-nft-burn"            : rnb
                        ,"role-nft-create"          : rnc
                        ,"role-transfer"            : rt
                        ,"frozen"                   : f}
                    )
                    (update DPMF|BalanceTable (concat [id BAR account])
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
    (defun X_DebitMultiple (id:string nonce-lst:[integer] account:string balance-lst:[decimal])
        (let
            (
                (nonce-balance-obj-lst:[object{DemiourgosPactMetaFungible.DPMF|Nonce-Balance}] (UDC_Nonce-Balance nonce-lst balance-lst))
            )
            (map (lambda (x:object{DemiourgosPactMetaFungible.DPMF|Nonce-Balance}) (X_DebitPaired id account x)) nonce-balance-obj-lst)
        )
    )
    (defun X_DebitPaired (id:string account:string nonce-balance-obj:object{DemiourgosPactMetaFungible.DPMF|Nonce-Balance})
        (let
            (
                (nonce:integer (at "nonce" nonce-balance-obj))
                (balance:decimal (at "balance" nonce-balance-obj))
            )
            (X_DebitAdmin id nonce account balance)
        )
    )
    (defun X_Issue:string
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
        (let
            (
                (ref-U|DALOS:module{Ouronet4Dalos} U|DALOS)
                (id:string (ref-U|DALOS::UDC_Makeid ticker))
            )
            (ref-U|DALOS::UEV_Decimals decimals)
            (ref-U|DALOS::UEV_NameOrTicker name true false)
            (ref-U|DALOS::UEV_NameOrTicker ticker false false)
            (require-capability (SECURE))
            (insert DPMF|PropertiesTable id
                {"branding"             : BRANDING|DEFAULT
                ,"branding-pending"     : BRANDING|DEFAULT
                ,"owner-konto"          : account
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
                ,"reward-bearing-token" : BAR
                ,"vesting"              : BAR}
            )
            (C_DeployAccount id account)    
            id
        )
    )
    (defun X_IncrementNonce (id:string)
        (require-capability (DPMF|INCR_NONCE))
        (with-read DPMF|PropertiesTable id
            { "nonces-used" := nu }
            (update DPMF|PropertiesTable id { "nonces-used" : (+ nu 1)})
        )
    )
    (defun X_Mint:integer (id:string account:string amount:decimal meta-data:[object])
        (require-capability (DPMF|C>MINT id account amount))
        (let
            (
                (new-nonce:integer (+ (UR_NoncesUsed id) 1))
            )
            (X_Create id account meta-data)
            (X_AddQuantity id new-nonce account amount)
            new-nonce
        )
    )
    (defun X_Transfer (id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)
        (require-capability (DPMF|C>TRANSFER id sender receiver transfer-amount method))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (current-nonce-meta-data (UR_AccountBatchMetaData id nonce sender))
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
            )
            (X_DebitStandard id nonce sender transfer-amount)
            (X_Credit id nonce current-nonce-meta-data receiver transfer-amount)
            (X_UpdateElite id sender receiver)
        )
    )
    (defun X_MoveCreateRole (id:string receiver:string)
        (enforce-guard (P|UR "ATS|Caller"))
        (with-capability (DPMF|S>MOVE_CREATE-R id receiver)
            (update DPMF|BalanceTable (concat [id BAR (UR_CreateRoleAccount id)])
                {"role-nft-create" : false}
            )
            (update DPMF|BalanceTable (concat [id BAR receiver])
                {"role-nft-create" : true}
            )
            (update DPMF|PropertiesTable id
                {"create-role-account" : receiver}
            )
        )
    )
    (defun X_ToggleAddQuantityRole (id:string account:string toggle:bool)
        (enforce-guard (P|UR "ATS|Caller"))
        (with-capability (DPMF|S>TG_ADD-QTY-R id account toggle)
            (update DPMF|BalanceTable (concat [id BAR account])
                {"role-nft-add-quantity" : toggle}
            )
        )
    )
)

(create-table P|T)
(create-table DPMF|PropertiesTable)
(create-table DPMF|BalanceTable)
(create-table DPMF|RoleTable)