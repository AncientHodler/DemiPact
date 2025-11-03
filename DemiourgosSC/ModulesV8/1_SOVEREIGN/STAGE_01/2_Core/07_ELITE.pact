(module ELITE GOV
    ;;
    (implements OuronetPolicy)
    (implements Elite)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_ELITE                  (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|ELITE_ADMIN)))
    (defcap GOV|ELITE_ADMIN ()              (enforce-guard GOV|MD_ELITE))
    (defcap GOV|ELITE_ADMIN-CALLER ()
        (compose-capability (GOV|ELITE_ADMIN))
        (compose-capability (P|ELITE|CALLER))
    )
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;; [Keys]
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|CollectiblesKey ()           (+ (GOV|NS_Use) ".dh_sc_dpdc-keyset"))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|ELITE|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|ELITE|CALLER))
        (compose-capability (SECURE))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|ELITE_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|ELITE_ADMIN)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (dg:guard (create-capability-guard (SECURE)))
                )
                (with-default-read P|MT P|I
                    {"m-policies" : [dg]}
                    {"m-policies" := mp}
                    (write P|MT P|I
                        {"m-policies" : (ref-U|LST::UC_AppL mp policy-guard)}
                    )
                )
            )
        )
    )
    (defun P|A_Define ()
        (let
            (
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|DPOF:module{OuronetPolicy} DPOF)
                (mg:guard (create-capability-guard (P|ELITE|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|DPOF::P|A_AddIMP mg)
        )
    )
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
            )
            (ref-U|G::UEV_Any (P|UR_IMP))
        )
    )
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun URC_EliteAurynzSupply (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-DPOF:module{DemiourgosPactOrtoFungibleV3} DPOF)
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
            )
            (if (!= ea-id BAR)
                (let
                    (
                        (ea-supply:decimal (ref-DPTF::UR_AccountSupply ea-id account))
                        (fea:string (ref-DPTF::UR_Frozen ea-id))
                        (rea:string (ref-DPTF::UR_Reservation ea-id))
                        (vea:string (ref-DPTF::UR_Vesting ea-id))
                        (sea:string (ref-DPTF::UR_Sleeping ea-id))
                        (hea:string (ref-DPTF::UR_Hibernation ea-id))
                        (fea-supply:decimal
                            (if (!= fea BAR)
                                (ref-DPTF::UR_AccountSupply fea account)
                                0.0
                            )
                        )
                        (rea-supply:decimal
                            (if (!= rea BAR)
                                (ref-DPTF::UR_AccountSupply rea account)
                                0.0
                            )
                        )
                        (vea-supply:decimal
                            (if (!= vea BAR)
                                (ref-DPOF::UR_AccountSupply vea account)
                                0.0
                            )
                        )
                        (sea-supply:decimal
                            (if (!= sea BAR)
                                (ref-DPOF::UR_AccountSupply sea account)
                                0.0
                            )
                        )
                        (hea-supply:decimal
                            (if (!= hea BAR)
                                (ref-DPOF::UR_AccountSupply hea account)
                                0.0
                            )
                        )
                    )
                    (fold (+) 0.0 [ea-supply fea-supply rea-supply vea-supply sea-supply hea-supply])
                )
                0.0
            )
        )
    )
    (defun URC_IzIdEA:bool (id:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
                (fea:string (ref-DPTF::UR_Frozen ea-id))
                (rea:string (ref-DPTF::UR_Reservation ea-id))
                (vea:string (ref-DPTF::UR_Vesting ea-id))
                (sea:string (ref-DPTF::UR_Sleeping ea-id))
                (hea:string (ref-DPTF::UR_Hibernation ea-id))
            )
            (contains id [ea-id fea rea vea sea hea])
        )
    )
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun A_MigrateMetaToOrtoFungibleId (id:string)
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungibleV6} DPMF)
                (ref-DPOF:module{DemiourgosPactOrtoFungibleV3} DPOF)
            )
            (with-capability (GOV|ELITE_ADMIN-CALLER)
                (ref-DPOF::XI_InsertNewId id
                    {"owner-konto"                  : (ref-DPMF::UR_Konto id)
                    ,"name"                         : (ref-DPMF::UR_Name id)
                    ,"ticker"                       : (ref-DPMF::UR_Ticker id)
                    ,"decimals"                     : (ref-DPMF::UR_Decimals id)
                    ;;
                    ,"can-upgrade"                  : (ref-DPMF::UR_CanUpgrade id)
                    ,"can-change-owner"             : (ref-DPMF::UR_CanChangeOwner id)
                    ,"can-add-special-role"         : (ref-DPMF::UR_CanAddSpecialRole id)
                    ,"can-transfer-oft-create-role" : (ref-DPMF::UR_CanTransferNFTCreateRole id)
                    ;;
                    ,"can-freeze"                   : (ref-DPMF::UR_CanFreeze id)
                    ,"can-wipe"                     : (ref-DPMF::UR_CanWipe id)
                    ,"can-pause"                    : (ref-DPMF::UR_CanPause id)
                    ;;
                    ,"is-paused"                    : (ref-DPMF::UR_Paused id)
                    ,"nonces-used"                  : (ref-DPMF::UR_NoncesUsed id)
                    ,"nonces-excluded"              : 0
                    ;;
                    ,"supply"                       : (ref-DPMF::UR_Supply id)
                    ;;
                    ,"segmentation"                 : false
                    ,"reward-bearing-token"         : (ref-DPMF::UR_RewardBearingToken id)
                    ,"vesting-link"                 : (ref-DPMF::UR_Vesting id)
                    ,"sleeping-link"                : (ref-DPMF::UR_Sleeping id)
                    ,"hibernation-link"             : BAR}
                )
                (ref-DPOF::XI_WriteRoles id
                    (ref-DPOF::UDC_VerumRoles
                        (ref-DPMF::UR_Roles id 5)
                        (ref-DPMF::UR_Roles id 3)
                        (ref-DPMF::UR_Roles id 1)
                        (ref-DPMF::UR_CreateRoleAccount id)
                        (ref-DPMF::UR_Roles id 4)
                    )
                )
                (format "Succesfully migrated DPMF {} to DPOF" [id])
            )
        )
    )
    (defun A_MigrateMetaToOrtoFungibleAccount (id:string account:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV4} INFO-ZERO)
                (ref-DPOF:module{DemiourgosPactOrtoFungibleV3} DPOF)
                (iz-id:bool (ref-DPOF::UR_IzId id))
            )
            (enforce iz-id (format "Meta Fungible ID {} must be migrated to Ortofungible for Operation" [id]))
            (let
                (
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV6} DPMF)
                    
                    (unit:[object{DemiourgosPactMetaFungibleV6.DPMF|Schema}] (ref-DPMF::UR_AccountUnit id account))
                    (dpmf-negative:object{DemiourgosPactMetaFungibleV6.DPMF|Schema}
                        {"nonce": -1
                        ,"balance": -1.0
                        ,"meta-data": [{}]}
                    )
                )
                (if (= unit dpmf-negative)
                    ;;If <unit> is <dpmf-negative> no writing occurs for the migration
                    (format "Account {} doesnt exist for DPMF {} and cant be migrated" [account id])
                    (let
                        (
                            (total-account-supply:decimal
                                (fold
                                    (lambda
                                        (acc:decimal item:object{DemiourgosPactMetaFungibleV6.DPMF|Schema})
                                        (+ acc (at "balance" item))
                                    )
                                    0.0
                                    unit
                                )
                            )
                        )
                        (with-capability (GOV|ELITE_ADMIN-CALLER)
                            ;;Write Account Data
                            (ref-DPOF::XB_W|AccountRoles id account
                                (ref-DPOF::UDC_AccountRoles
                                    total-account-supply
                                    (ref-DPMF::UR_AccountFrozenState id account)
                                    (ref-DPMF::UR_AccountRoleNFTAQ id account)
                                    (ref-DPMF::UR_AccountRoleBurn id account)
                                    (ref-DPMF::UR_AccountRoleCreate id account)
                                    (ref-DPMF::UR_AccountRoleTransfer id account)
                                    id
                                    account
                                )
                            )
                            ;;Insert Nonces
                            (if (> total-account-supply 0.0)
                                (format "No Orto-Fungible Insertion needed for the MetaFungible ID {} and Account {}" [id account])
                                (map
                                    (lambda
                                        (item:object{DemiourgosPactMetaFungibleV6.DPMF|Schema})
                                        (let
                                            (
                                                (nonce:integer (at "nonce" item))
                                                (balance:decimal (at "balance" item))
                                                (meta-data-chain:[object] (at "meta-data" item))
                                            )
                                            (if (!= nonce 0)
                                                (ref-DPOF::XB_InsertNewNonce
                                                    account id 
                                                    nonce
                                                    balance
                                                    meta-data-chain
                                                )
                                                true
                                            )
                                        )
                                    )
                                    unit
                                )
                            )
                        )
                    )
                )
                (format "Succesfuly migrated DPMF {} Account of {} into DPOF" 
                    [id (ref-I|OURONET::OI|UC_ShortAccount account)]
                )
            )
        )
    )
    ;;{F6}  [C]
    ;;{F7}  [X]
    (defun XE_UpdateEliteSingle (id:string account:string)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (iz-elite-auryn:bool (URC_IzIdEA id))
                (a-type:bool (ref-DALOS::UR_AccountType account))
            )
            (if iz-elite-auryn
                (with-capability (P|ELITE|CALLER)
                    (if (not a-type)
                        (ref-DALOS::XE_UpdateElite account (URC_EliteAurynzSupply account))
                        true
                    )
                )
                true
            )
        )
    )
    (defun XE_UpdateElite (id:string sender:string receiver:string)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (iz-elite-auryn:bool (URC_IzIdEA id))
                (s-type:bool (ref-DALOS::UR_AccountType sender))
                (r-type:bool (ref-DALOS::UR_AccountType receiver))
            )
            (if iz-elite-auryn
                (with-capability (P|ELITE|CALLER)
                    (if (not s-type)
                        (ref-DALOS::XE_UpdateElite sender (URC_EliteAurynzSupply sender))
                        true
                    )
                    (if (not r-type)
                        (ref-DALOS::XE_UpdateElite receiver (URC_EliteAurynzSupply receiver))
                        true
                    )
                )
                true
            )
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)