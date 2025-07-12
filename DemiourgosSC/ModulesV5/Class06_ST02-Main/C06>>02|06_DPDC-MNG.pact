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
    (defcap DPDC-MNG|C>ADD-QUANTITY (id:string account:string nonce:integer amount:integer)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (nonce-class:integer (ref-DPDC::UR_NonceClass id true nonce))
            )
            (enforce (> nonce 0) "Only positive nonces can be used for operation")
            (enforce (> amount 0) "Only positive amounts can be used for operation")
            (enforce (= nonce-class 0) "Adding Quantity is allowed only for class 0 nonces!")
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (ref-DPDC::UEV_AccountAddQuantityState id account true)
            (compose-capability (P|DPDC-MNG|CALLER))
        )
    )
    (defcap DPDC-MNG|C>BURN-SFT (id:string account:string nonce:integer amount:integer)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (ref-DPDC::UEV_AccountBurnState id true account true)
            (compose-capability (DPDC-MNG|C>RM-SFT-QT id account nonce amount))
        )
    )
    (defcap DPDC-MNG|C>WIPE-SFT-NONCE-PARTIALLY (id:string account:string nonce:integer amount:integer)
        @event
        (compose-capability (DPDC-MNG|C>WIPE-SFT id account nonce amount))
    )
    (defcap DPDC-MNG|C>WIPE-SFT-NONCE-TOTALLY (id:string account:string nonce:integer)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (nonce-supply:integer (ref-DPDC::UR_NonceSupply id true nonce))
            )
            (compose-capability (DPDC-MNG|C>WIPE-SFT id account nonce nonce-supply))
        )
    )
    (defcap DPDC-MNG|C>WIPE-SFT (id:string account:string nonce:integer amount:integer)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::CAP_Owner id true)
            (ref-DPDC::UEV_AccountFreezeState id true account true)
            (compose-capability (DPDC-MNG|C>RM-SFT-QT id account nonce amount))
        )
    )
    (defcap DPDC-MNG|C>RM-SFT-QT (id:string account:string nonce:integer amount:integer)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (nonce-supply:integer (ref-DPDC::UR_NonceSupply id true nonce))
            )
            (enforce (> nonce 0) "Only positive nonces can be used for operation")
            (enforce (<= amount nonce-supply) "Invalid Amount for SFT Wiping")
            (compose-capability (P|SECURE-CALLER))
        )
    )
    (defcap DPDC-MNG|C>WIPE-SFTS (id:string account:string)
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
    (defcap DPDC-MNG|C>BURN-NFT (id:string account:string nonce:integer)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (ref-DPDC::UEV_AccountBurnState id false account true)
            (ref-DPDC::UEV_NftNonceExistance id nonce true)
            (compose-capability (P|SECURE-CALLER))
        )
    )
    (defcap DPDC-MNG|C>RESPAWN-NFT (id:string account:string nonce:integer)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (ref-DPDC::UEV_AccountCreateState id false account true)
            (ref-DPDC::UEV_NftNonceExistance id nonce false)
            (compose-capability (P|SECURE-CALLER))
        )
    )
    (defcap DPDC-MNG|C>WIPE-NFT-NONCE (id:string account:string nonce:integer)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_NftNonceExistance id nonce true)
            (compose-capability (DPDC-MNG|C>WIPE-NFT id account))
        )
    )
    (defcap DPDC-MNG|C>WIPE-NFTS (id:string account:string)
        @event
        (compose-capability (DPDC-MNG|C>WIPE-NFT id account))
    )
    (defcap DPDC-MNG|C>WIPE-NFT (id:string account:string)
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
    (defun URC_FilterClassZeroNonces:[object{DpdcUdc.DPSF|NonceBalance}] (id:string input:[object{DpdcUdc.DPSF|NonceBalance}])
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (filter 
                (lambda 
                    (element:object{DpdcUdc.DPSF|NonceBalance})
                    (let
                        (
                            (nonce:integer (at "nonce" element))
                            (nonce-class:integer (ref-DPDC::UR_NonceClass id true nonce))
                        )
                        (= nonce-class 0)
                    )
                ) 
                input
            )
        )
    )
    (defun URC_FilterClassZeroNoncesV2:[integer] (id:string nonces:[integer])
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (filter 
                (lambda 
                    (element:integer)
                    (= (ref-DPDC::UR_NonceClass id false element) 0)
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
    ;;
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
    ;;
    (defun C_AddQuantity:object{IgnisCollector.OutputCumulator}
        (id:string account:string nonce:integer amount:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC-MNG|C>ADD-QUANTITY id account nonce amount)
                (XI_AddQuantity id account nonce amount)
                (ref-IGNIS::IC|UDC_SmallCumulator (ref-DPDC::UR_OwnerKonto id true))
            )
        )
    )
    (defun C_BurnSFT:object{IgnisCollector.OutputCumulator}
        (id:string account:string nonce:integer amount:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC-MNG|C>BURN-SFT id account nonce amount)
                (XI_BurnSemiFungible id account nonce amount)
                (ref-IGNIS::IC|UDC_SmallCumulator (ref-DPDC::UR_OwnerKonto id true))
            )
        )
    )
    (defun C_WipeSftNoncePartialy:object{IgnisCollector.OutputCumulator}
        (id:string account:string nonce:integer amount:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC-MNG|C>WIPE-SFT-NONCE-PARTIALLY id account nonce amount)
                (XI_BurnSemiFungible id account nonce amount)
                (ref-IGNIS::IC|UDC_BigCumulator (ref-DPDC::UR_OwnerKonto id true))
            )
        )
    )
    (defun C_WipeSftNonce:object{IgnisCollector.OutputCumulator}
        (id:string account:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
                (nonce-supply:integer (ref-DPDC::UR_NonceSupply id true nonce))
            )
            (with-capability (DPDC-MNG|C>WIPE-SFT-NONCE-TOTALLY id account nonce)
                (XI_BurnSemiFungible id account nonce nonce-supply)
                (ref-IGNIS::IC|UDC_BigCumulator (ref-DPDC::UR_OwnerKonto id true))
            )
        )
    )
    (defun C_WipeSftNonces:object{IgnisCollector.OutputCumulator}
        (id:string account:string)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC-MNG|C>WIPE-SFTS id account)
                (XI_WipeSFT id account)
                (ref-IGNIS::IC|UDC_BiggestCumulator (ref-DPDC::UR_OwnerKonto id true))
            )
        )
    )
    ;;
    (defun C_BurnNFT (id:string account:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC-MNG|C>BURN-NFT id account nonce)
                (XI_BurnNonFungible id account nonce)
                (ref-IGNIS::IC|UDC_MediumCumulator (ref-DPDC::UR_OwnerKonto id false))
            )
        )
    )
    (defun C_RespawnNFT (id:string account:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC-MNG|C>RESPAWN-NFT id account nonce)
                (XI_RespawnNonFungible id account nonce)
                (ref-IGNIS::IC|UDC_MediumCumulator (ref-DPDC::UR_OwnerKonto id false))
            )
        )
    )
    (defun C_WipeNftNonce (id:string account:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC-MNG|C>WIPE-NFT-NONCE id account nonce)
                (XI_BurnNonFungible id account nonce)
                (ref-IGNIS::IC|UDC_BigCumulator (ref-DPDC::UR_OwnerKonto id false))
            )
        )
    )
    (defun C_WipeNft (id:string account:string)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (with-capability (DPDC-MNG|C>WIPE-NFTS id account)
                (XI_WipeNFT id account )
                (ref-IGNIS::IC|UDC_BiggestCumulator (ref-DPDC::UR_OwnerKonto id false))
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
    (defun XI_AddQuantity (id:string account:string nonce:integer amount:integer)
        (require-capability (DPDC-MNG|C>ADD-QUANTITY id account nonce amount))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                (nonce-supply:integer (ref-DPDC::UR_NonceSupply id true nonce))
            )
            (ref-DPDC::XE_U|NonceSupply id nonce (+ amount nonce-supply))
            (ref-DPDC-C::XB_CreditSFT-Nonce id account nonce amount)
        )
    )
    (defun XI_BurnSemiFungible (id:string account:string nonce:integer amount:integer)
        @doc "Only Class 0 Nonces can be burned."
        (require-capability (SECURE))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                (nonce-supply:integer (ref-DPDC::UR_NonceSupply id true nonce))
            )
            (ref-DPDC::XE_U|NonceSupply id nonce (- nonce-supply amount))
            (ref-DPDC-C::XE_DebitSFT-Nonce id account nonce amount)
        )
    )
    (defun XI_WipeSFT (id:string account:string)
        @doc "Only Class 0 positive nonces can be Wiped. Set Nonces cannot be wiped"
        (require-capability (SECURE))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                (sfh:[object{DpdcUdc.DPSF|NonceBalance}] (ref-DPDC::UR_SemiFungibleAccountHoldings id account))
                (class-zero-sfh:[object{DpdcUdc.DPSF|NonceBalance}] (URC_FilterClassZeroNonces id sfh))
                (czsfh-snbo:object{DpdcUdc.DPSF|NonceBalanceChain} (ref-DPDC-UDC::UR_SplitNonceBalanceObject class-zero-sfh))
                (nonces:[integer] (at "nonce" czsfh-snbo))
                (amounts:[integer] (at "supply" czsfh-snbo))
            )
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (nonce:integer (at idx nonces))
                            (amount:integer (at idx amounts))
                            (nonce-supply:integer (ref-DPDC::UR_NonceSupply id true nonce))
                        )
                        (ref-DPDC::XE_U|NonceSupply id nonce (- nonce-supply amount))
                    )
                )
                (enumerate 0 (- (length nonces) 1))
            )
            (ref-DPDC-C::XE_DebitSFT-Nonces id account nonces amounts)
        )
    )
    ;;
    (defun XI_BurnNonFungible (id:string account:string nonce:integer)
        ;(require-capability (SECURE))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
            )
            (ref-DPDC::XE_U|NonceIzActive id nonce false)
            (ref-DPDC-C::XE_DebitNFT-Nonce id account nonce 1)
        )
    )
    (defun XI_RespawnNonFungible (id:string account:string nonce:integer)
        (require-capability (SECURE))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
            )
            (ref-DPDC::XE_U|NonceIzActive id nonce true)
            (ref-DPDC-C::XB_CreditNFT-Nonce id account nonce 1)
        )
    )
    (defun XI_WipeNFT (id:string account:string)
        @doc "Only Class 0 positive nonces can be Wiped. Set Nonces cannot be wiped"
        (require-capability (SECURE))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                (nfh:[integer] (ref-DPDC::UR_NonFungibleAccountHoldings id account))
                (class-zero-nfh:[integer] (URC_FilterClassZeroNoncesV2 id nfh))
            )
            (ref-DPDC-C::XE_DebitNFT-Nonces id account class-zero-nfh (make-list (length class-zero-nfh) 1))
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)