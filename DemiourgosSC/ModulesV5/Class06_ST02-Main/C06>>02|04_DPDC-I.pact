(module DPDC-I GOV
    ;;
    (implements OuronetPolicy)
    (implements DpdcIssue)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-I                 (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPDC-I_ADMIN)))
    (defcap GOV|DPDC-I_ADMIN ()             (enforce-guard GOV|MD_DPDC-I))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|DPDC-I|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC-I|CALLER))
        (compose-capability (SECURE))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|DPDC-I_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC-I_ADMIN)
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
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPDC:module{OuronetPolicy} DPDC)
                (mg:guard (create-capability-guard (P|DPDC-I|CALLER)))
            )
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPDC::P|A_AddIMP mg)
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
    (defcap DPDC-I|C>ISSUE (owner-account:string creator-account:string collection-name:string collection-ticker:string)
        @event
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-U|DALOS::UEV_NameOrTicker collection-name true false)
            (ref-U|DALOS::UEV_NameOrTicker collection-ticker false false)
            (ref-DALOS::CAP_EnforceAccountOwnership owner-account)
            (ref-DALOS::UEV_EnforceAccountType creator-account false)
            (compose-capability (P|SECURE-CALLER))
        )
    )
    ;;
    ;;{C3}
    ;;{C4}
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_DeployAccountSFT (id:string account:string)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (f:bool false)
            )
            (ref-DPDC::XB_DeployAccountSFT id account f f f f f f f f f f f)
        )
    )
    (defun C_DeployAccountNFT (id:string account:string)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (f:bool false)
            )
            (ref-DPDC::XB_DeployAccountNFT id account f f f f f f f f f f)
        )
    )
    (defun C_IssueDigitalCollection:object{IgnisCollector.OutputCumulator}
        (
            patron:string son:bool
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
        (UEV_IMC)
        (with-capability (DPDC-I|C>ISSUE owner-account creator-account collection-name collection-ticker)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-BRD:module{Branding} BRD)
                    (ref-DPDC:module{Dpdc} DPDC)
                    ;;
                    (multiplier:decimal (if son 5.0 10.0))
                    (ti:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                    (ignis-price:decimal (* ti multiplier))
                    (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                    ;;
                    (kda-cost:decimal
                        (if son
                            (ref-DALOS::UR_UsagePrice "dpsf")
                            (ref-DALOS::UR_UsagePrice "dpsf")
                        )
                    )
                    (id:string
                        (XI_IssueDigitalCollection
                            son
                            owner-account creator-account collection-name collection-ticker
                            can-upgrade can-change-owner can-change-creator can-add-special-role 
                            can-transfer-nft-create-role can-freeze can-wipe can-pause
                        )
                    )
                    (t:bool true)
                    (f:bool false)
                )
                (ref-BRD::XE_Issue id)
                ;;Deploy Collection Accounts for Owner and Creator
                (if son
                    (do
                        (ref-DPDC::XB_DeployAccountSFT id owner-account t f f f t t f f f t f)
                        (ref-DPDC::XB_DeployAccountSFT id creator-account f f f f f f f f f f f)
                    )
                    (do
                        (ref-DPDC::XB_DeployAccountNFT id owner-account f f f t t f f f t f)
                        (ref-DPDC::XB_DeployAccountNFT id creator-account f f f f f f f f f f)
                    )
                )
                (ref-DALOS::KDA|C_Collect patron kda-cost)
                (ref-IGNIS::IC|UDC_ConstructOutputCumulator ignis-price owner-account trigger [id])
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_IssueDigitalCollection:string
        (
            son:bool
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
        (require-capability (DPDC-I|C>ISSUE owner-account creator-account collection-name collection-ticker))
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-DPDC:module{Dpdc} DPDC)
                (id:string (ref-U|DALOS::UDC_Makeid collection-ticker))
                (specifications:object{DpdcUdc.DPDC|Properties}
                    (ref-DPDC-UDC::UDC_DPDC|Properties
                        owner-account creator-account collection-name collection-ticker
                        can-upgrade can-change-owner can-change-creator can-add-special-role
                        can-transfer-nft-create-role can-freeze can-wipe can-pause
                        false 0 0
                    )
                )
                (zne:[object{DpdcUdc.DPDC|NonceElement}]
                    [(ref-DPDC-UDC::UDC_ZeroNonceElement)]
                )
                (b:[string] [BAR])
                (oa:[string] [owner-account])
                (verum-chain:object{DpdcUdc.DPDC|VerumRoles}
                    (if son
                        (ref-DPDC-UDC::UDC_DPDC|VerumRoles b b oa b oa oa b b b oa b)    
                        (ref-DPDC-UDC::UDC_DPDC|VerumRoles b b b b oa oa b b b oa b)
                    )
                )
            )
            (ref-DPDC::XE_InsertCollection id son specifications)
            (ref-DPDC::XE_InsertVerumRoles id son verum-chain)
            id
        )
    )
    ;;
    
)

(create-table P|T)
(create-table P|MT)