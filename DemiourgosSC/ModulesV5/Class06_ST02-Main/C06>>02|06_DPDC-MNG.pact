(module DPDC-MNG GOV
    ;;
    (implements OuronetPolicy)
    (implements DpdcManagement)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-MNG               (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPDC-MNG_ADMIN)))
    (defcap GOV|DPDC-MNG_ADMIN ()           (enforce-guard GOV|MD_DPDC-MNG))
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
    (defcap P|DPDC-MNG|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC-MNG|CALLER))
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
        (with-capability (GOV|DPDC-MNG_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC-MNG_ADMIN)
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
                (ref-P|DPDC:module{OuronetPolicy} DPDC)
                (ref-P|DPDC-C:module{OuronetPolicy} DPDC-C)
                (mg:guard (create-capability-guard (P|DPDC-MNG|CALLER)))
            )
            (ref-P|DPDC::P|A_AddIMP mg)
            (ref-P|DPDC-C::P|A_AddIMP mg)
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
    (defcap DPDC-MNG|S>CTRL (id:string son:bool)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::CAP_Owner id son)
            (ref-DPDC::UEV_CanUpgradeON id son)
        )
    )
    (defcap DPDC-MNG|S>TG_PAUSE (id:string son:bool toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (if toggle
                (ref-DPDC::UEV_CanPauseON id son)
                true
            )
            (ref-DPDC::CAP_Owner id son)
            (ref-DPDC::UEV_PauseState id son (not toggle))
        )
    )
    ;;{C3}
    ;;{C4}
    (defcap DPDC-MNG|C>ADD-QUANTITY (account:string id:string nonce:integer amount:integer)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (nonce-class:integer (ref-DPDC::UR_NonceClass id true nonce))
            )
            (enforce (> nonce 0) "Only positive nonces can be used for operation!")
            (enforce (> amount 0) "Only positive amounts can be used for operation!")
            (enforce (= nonce-class 0) "Adding Quantity is allowed only for class 0 nonces!")
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (ref-DPDC::UEV_AccountAddQuantityState id account true)
            (compose-capability (P|DPDC-MNG|CALLER))
        )
    )
    (defcap DPDC-MNG|C>BURN-SFT (account:string id:string nonce:integer amount:integer)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                
            )
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (ref-DPDC::UEV_AccountBurnState id true account true)
            (compose-capability (DPDC-MNG|C>RM-SFT-QT account id nonce amount))
        )
    )
    (defcap DPDC-MNG|C>WIPE-SFT-NONCE-PARTIALLY (account:string id:string nonce:integer amount:integer)
        @event
        (compose-capability (DPDC-MNG|C>WIPE-SFT account id nonce amount))
    )
    (defcap DPDC-MNG|C>WIPE-SFT-NONCE-TOTALLY (account:string id:string nonce:integer)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (account-nonce-supply:integer (ref-DPDC::UR_AccountNonceSupply account id true nonce))
            )
            (compose-capability (DPDC-MNG|C>WIPE-SFT account id nonce account-nonce-supply))
        )
    )
    (defcap DPDC-MNG|C>WIPE-SFT (account:string id:string nonce:integer amount:integer)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::CAP_Owner id true)
            (ref-DPDC::UEV_AccountFreezeState id true account true)
            (compose-capability (DPDC-MNG|C>RM-SFT-QT account id nonce amount))
        )
    )
    (defcap DPDC-MNG|C>RM-SFT-QT (account:string id:string nonce:integer amount:integer)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (nonce-class:integer (ref-DPDC::UR_NonceClass id true nonce))
                (nonce-supply:integer (ref-DPDC::UR_NonceSupply id true nonce))
                (account-nonce-supply:integer (ref-DPDC::UR_AccountNonceSupply account id true nonce))
            )
            ;;Fragments (that have negative nonces) cannot be burned or wiped
            (enforce
                (fold (and) true [(> nonce 0) (> amount 0) (<= amount account-nonce-supply) (= nonce-class 0)])
                (format "Conditions not met for removal of {} SFT {} Nonce {} on Account {}." [amount id nonce account])
            )
            (compose-capability (P|SECURE-CALLER))
        )
    )
    (defcap DPDC-MNG|C>WIPE-SFTS (account:string id:string)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::CAP_Owner id true)
            (ref-DPDC::UEV_AccountFreezeState id true account true)
            (compose-capability (P|SECURE-CALLER))
        )
    )
    ;;
    (defcap DPDC-MNG|C>BURN-NFT (account:string id:string nonce:integer)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (ref-DPDC::UEV_AccountBurnState id false account true)
            (ref-DPDC::UEV_NftNonceExistance id nonce true)
            (compose-capability (P|DPDC-MNG|CALLER))
        )
    )
    (defcap DPDC-MNG|C>RESPAWN-NFT (account:string id:string nonce:integer)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (ref-DPDC::UEV_AccountCreateState id false account true)
            (ref-DPDC::UEV_NftNonceExistance id nonce false)
            (compose-capability (P|DPDC-MNG|CALLER))
        )
    )
    (defcap DPDC-MNG|C>WIPE-NFT-NONCE (account:string id:string nonce:integer)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_NftNonceExistance id nonce true)
            (compose-capability (DPDC-MNG|C>WIPE-NFT account id))
        )
    )
    (defcap DPDC-MNG|C>WIPE-NFTS (account:string id:string)
        @event
        (compose-capability (DPDC-MNG|C>WIPE-NFT account id))
    )
    (defcap DPDC-MNG|C>WIPE-NFT (account:string id:string)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::CAP_Owner id false)
            (ref-DPDC::UEV_AccountFreezeState id false account true)
            (compose-capability (P|SECURE-CALLER))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun URC_FilterClassZeroNonces:[integer] (id:string son:bool nonces:[integer])
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (filter 
                (lambda 
                    (element:integer)
                    (= (ref-DPDC::UR_NonceClass id son element) 0)
                ) 
                nonces
            )
        )
    )
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_Control:object{IgnisCollector.OutputCumulator}
        (id:string son:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (owner:string (ref-DPDC::UR_OwnerKonto id son))
            )
            (with-capability (DPDC-MNG|S>CTRL id son)
                (XI_Control id son cu cco ccc casr ctncr cf cw cp)
                (if son
                    (ref-IGNIS::IC|UDC_BigCumulator owner)
                    (ref-IGNIS::IC|UDC_BiggestCumulator owner)
                )
            )
        )
    )
    (defun C_TogglePause:object{IgnisCollector.OutputCumulator}
        (id:string son:bool toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC-MNG|S>TG_PAUSE id son toggle)
                (XI_TogglePause id son toggle)
                (ref-IGNIS::IC|UDC_MediumCumulator (ref-DPDC::UR_OwnerKonto id son))
            )
        )
    )
    ;; [SFT]
    (defun C_AddQuantity:object{IgnisCollector.OutputCumulator}
        (account:string id:string nonce:integer amount:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC-MNG|C>ADD-QUANTITY account id nonce amount)
                (XI_AddQuantity account id nonce amount)
                (ref-IGNIS::IC|UDC_SmallCumulator (ref-DPDC::UR_OwnerKonto id true))
            )
        )
    )
    (defun C_BurnSFT:object{IgnisCollector.OutputCumulator}
        (account:string id:string nonce:integer amount:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC-MNG|C>BURN-SFT account id nonce amount)
                (XI_BurnSemiFungible account id nonce amount)
                (ref-IGNIS::IC|UDC_SmallCumulator (ref-DPDC::UR_OwnerKonto id true))
            )
        )
    )
    (defun C_WipeSftNoncePartialy:object{IgnisCollector.OutputCumulator}
        (account:string id:string nonce:integer amount:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC-MNG|C>WIPE-SFT-NONCE-PARTIALLY account id nonce amount)
                (XI_BurnSemiFungible account id nonce amount)
                (ref-IGNIS::IC|UDC_BigCumulator (ref-DPDC::UR_OwnerKonto id true))
            )
        )
    )
    (defun C_WipeSftNonce:object{IgnisCollector.OutputCumulator}
        (account:string id:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (nonce-supply:integer (ref-DPDC::UR_NonceSupply id true nonce))
            )
            (with-capability (DPDC-MNG|C>WIPE-SFT-NONCE-TOTALLY account id nonce)
                (XI_BurnSemiFungible account id nonce nonce-supply)
                (ref-IGNIS::IC|UDC_BigCumulator (ref-DPDC::UR_OwnerKonto id true))
            )
        )
    )
    (defun C_WipeSftNonces:object{IgnisCollector.OutputCumulator}
        (account:string id:string)
        @doc "Costs 1 IGNIS per SFT Nonce wiped. \
            \ For demonstration purposes only, due to high computation cost"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC-MNG|C>WIPE-SFTS account id)
                (let
                    (
                        (no-of-nonces:decimal (dec (XI_WipeSFT account id)))
                    )
                    (ref-IGNIS::IC|UDC_ConstructOutputCumulator
                        (* 
                            (ref-DALOS::UR_UsagePrice "ignis|smallest")
                            no-of-nonces
                        )
                        (ref-DPDC::UR_OwnerKonto id true)
                        (ref-IGNIS::IC|URC_IsVirtualGasZero)
                        [no-of-nonces]
                    )
                )
            )
        )
    )
    ;; [NFT]
    (defun C_BurnNFT:object{IgnisCollector.OutputCumulator} (account:string id:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
            )
            (with-capability (DPDC-MNG|C>BURN-NFT account id nonce)
                (ref-DPDC-C::XE_DebitNFT-Nonce id account nonce 1)
                (ref-IGNIS::IC|UDC_MediumCumulator (ref-DPDC::UR_OwnerKonto id false))
            )
        )
    )
    (defun C_RespawnNFT:object{IgnisCollector.OutputCumulator} (account:string id:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
            )
            (with-capability (DPDC-MNG|C>RESPAWN-NFT account id nonce)
                (ref-DPDC-C::XB_CreditNFT-Nonce id account nonce 1)
                (ref-IGNIS::IC|UDC_MediumCumulator (ref-DPDC::UR_OwnerKonto id false))
            )
        )
    )
    (defun C_WipeNftNonce:object{IgnisCollector.OutputCumulator} (account:string id:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
            )
            (with-capability (DPDC-MNG|C>WIPE-NFT-NONCE account id nonce)
                (ref-DPDC-C::XE_DebitNFT-Nonce id account nonce 1)
                (ref-IGNIS::IC|UDC_BigCumulator (ref-DPDC::UR_OwnerKonto id false))
            )
        )
    )
    (defun C_WipeNft:object{IgnisCollector.OutputCumulator} (account:string id:string)
        @doc "Costs 1 IGNIS per SFT Nonce wiped. \
            \ For demonstration purposes only, due to high computation cost"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC-MNG|C>WIPE-NFTS account id)
                (let
                    (
                        (no-of-nonces:decimal (dec  (XI_WipeNFT account id)))
                    )
                    (ref-IGNIS::IC|UDC_ConstructOutputCumulator
                        (* 
                            (ref-DALOS::UR_UsagePrice "ignis|smallest")
                            no-of-nonces
                        )
                        (ref-DPDC::UR_OwnerKonto id false)
                        (ref-IGNIS::IC|URC_IsVirtualGasZero)
                        [no-of-nonces]
                    )
                )
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_Control (id:string son:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        (require-capability (DPDC-MNG|S>CTRL id son))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::XE_U|Specs id son 
                (ref-DPDC::UDC_Control id son cu cco ccc casr ctncr cf cw cp)
            )
        )
    )
    (defun XI_TogglePause (id:string son:bool toggle:bool)
        (require-capability (DPDC-MNG|S>TG_PAUSE id son toggle))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::XE_U|IsPaused id son toggle)
        )
    )
    ;;
    (defun XI_AddQuantity (account:string id:string nonce:integer amount:integer)
        (require-capability (DPDC-MNG|C>ADD-QUANTITY account id nonce amount))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                (nonce-supply:integer (ref-DPDC::UR_NonceSupply id true nonce))
            )
            (ref-DPDC::XE_U|NonceSupply id nonce (+ amount nonce-supply))
            (ref-DPDC-C::XB_CreditSFT-Nonce account id nonce amount)
        )
    )
    (defun XI_BurnSemiFungible (account:string id:string nonce:integer amount:integer)
        @doc "Only Positive, Class 0 Nonces can be burned directly with this function \
            \ Negative (Fragment Nonces) and Class Non-0 Nonces (Set Nonces) are protected by direct burning."   
        (require-capability (SECURE))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                (nonce-supply:integer (ref-DPDC::UR_NonceSupply id true nonce))
            )
            (ref-DPDC::XE_U|NonceSupply id nonce (- nonce-supply amount))
            (ref-DPDC-C::XE_DebitSFT-Nonce account id nonce amount)
        )
    )
    (defun XI_WipeSFT:integer (account:string id:string)
        @doc "Only Positive, Class 0 Nonces can be burned directly with this function \
            \ Negative (Fragment Nonces) and Class Non-0 Nonces (Set Nonces) are protected by direct burning. \
            \ Only Works up to a certain amount of Nonces held by the account due to <UR_AccountNonces> which is expensive \
            \ since it polls all NFT Accounts existing on Ouronet; \
            \ \
            \ Only for demonstration purposes. Nonces should insted be wiped one at a time. \
            \ Outputs the number of elements wiped."
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                (asfn:[integer] (ref-DPDC::UR_AccountNonces account id true))
                (class-zero-asfn:[integer] (URC_FilterClassZeroNonces id true asfn))
                (class-zero-asfn-amounts:[integer] 
                    (fold
                        (lambda
                            (acc:[integer] idx:integer)
                            (ref-U|LST::UC_AppL acc 
                                (ref-DPDC::UR_AccountNonceSupply account id true (at idx class-zero-asfn))
                            )
                        )
                        []
                        (enumerate 0 (- (length class-zero-asfn) 1))
                    )
                )
            )
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (nonce:integer (at idx class-zero-asfn))
                            (amount:integer (at idx class-zero-asfn-amounts))
                            (nonce-supply:integer (ref-DPDC::UR_NonceSupply id true nonce))
                        )
                        (ref-DPDC::XE_U|NonceSupply id nonce (- nonce-supply amount))
                    )
                )
                (enumerate 0 (- (length class-zero-asfn) 1))
            )
            (ref-DPDC-C::XE_DebitSFT-Nonces account id class-zero-asfn class-zero-asfn-amounts)
            (length class-zero-asfn)
        )
    )
    ;;
    (defun XI_WipeNFT:integer (id:string account:string)
        @doc "Similar to SFT Wiping"
        (require-capability (SECURE))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                (anfn:[integer] (ref-DPDC::UR_AccountNonces account id false))
                (class-zero-anfn:[integer] (URC_FilterClassZeroNonces id false anfn))
                (class-zero-anfn-amounts:[integer] (make-list (length class-zero-anfn) 1))
            )
            (ref-DPDC-C::XE_DebitNFT-Nonces account id class-zero-anfn class-zero-anfn-amounts)
            (length class-zero-anfn)
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)