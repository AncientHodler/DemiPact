(module DPDC-MNG GOV
    ;;
    (implements OuronetPolicyV1)
    (implements DpdcManagementV1)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-MNG               (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPDC-MNG_ADMIN)))
    (defcap GOV|DPDC-MNG_ADMIN ()           (enforce-guard GOV|MD_DPDC-MNG))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV1} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicyV1.P|S})
    (deftable P|MT:{OuronetPolicyV1.P|MS})
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
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV1} DALOS)) (ref-DALOS::P|Info)))
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
                    (ref-U|LST:module{StringProcessorV1} U|LST)
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
                (ref-P|DPDC:module{OuronetPolicyV1} DPDC)
                (ref-P|DPDC-C:module{OuronetPolicyV1} DPDC-C)
                (mg:guard (create-capability-guard (P|DPDC-MNG|CALLER)))
            )
            (ref-P|DPDC::P|A_AddIMP mg)
            (ref-P|DPDC-C::P|A_AddIMP mg)
        )
    )
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuardsV1} U|G)
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
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstantsV1} U|CT)) (ref-U|CT::CT_BAR)))
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
                (ref-DPDC:module{DpdcV1} DPDC)
            )
            (ref-DPDC::CAP_Owner id son)
            (ref-DPDC::UEV_CanUpgradeON id son)
        )
    )
    (defcap DPDC-MNG|S>TG_PAUSE (id:string son:bool toggle:bool)
        @event
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
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
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (ref-DPDC:module{DpdcV1} DPDC)
                (nonce-class:integer (ref-DPDC::UR_NonceClass id true nonce))
            )
            (enforce
                (fold (and) true
                    [
                        (> nonce 0)
                        (> amount 0)
                        (= nonce-class 0)
                    ]
                )
                "Invalid Data for Adding Quantity for an SFT Nonce"
            )
            ;;Account Ownership
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            ;;Correct add quantity role
            (ref-DPDC::UEV_AccountAddQuantityState id account true)
            ;;Req cap
            (compose-capability (P|DPDC-MNG|CALLER))
        )
    )
    (defcap DPDC-MNG|C>BURN-SFT (account:string id:string nonce:integer amount:integer)
        @event
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
            )
            ;;Account Ownership - via Debit Function
            ;;Correct burn role
            (ref-DPDC::UEV_AccountBurnState id true account true)
            ;;Remove Nonces Capability (also enforces nonces are held by account)
            (compose-capability (DPDC-MNG|C>REMOVE-CLASS-ZERO-NONCES account id true [nonce] [amount]))
        )
    )
    (defcap DPDC-MNG|C>WIPE-SFT-NONCE-PARTIALLY (account:string id:string nonce:integer amount:integer)
        @event
        (compose-capability (DPDC-MNG|C>WIPE-SFT account id [nonce] [amount]))
    )
    (defcap DPDC-MNG|C>WIPE-SFT-NONCE-TOTALLY (account:string id:string nonce:integer amount:integer)
        @event
        (compose-capability (DPDC-MNG|C>WIPE-SFT account id [nonce] [amount]))
    )
    (defcap DPDC-MNG|C>WIPE-SFT-NONCES (account:string id:string nonces:[integer])
        @event
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (amounts:[integer] (ref-DPDC::UR_AccountNoncesSupplies account id true nonces))
            )
            (compose-capability (DPDC-MNG|C>WIPE-SFT account id nonces amounts))
        )
    )
    (defcap DPDC-MNG|C>WIPE-SFT (account:string id:string nonces:[integer] amounts:[integer])
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
            )
            ;;Semi-Fungible <id> is frozen on <account>
            (ref-DPDC::UEV_AccountFreezeState id true account true)
            ;;Semi-Fungible has <can-wipe> set to ON
            (ref-DPDC::UEV_CanWipeON id true)
            ;;Wiping requires <id> ownership via debit function
            ;;Remove Nonces Capability (also enforces nonces are held by account)
            (compose-capability (DPDC-MNG|C>REMOVE-CLASS-ZERO-NONCES account id true nonces amounts))
        )
    )
    ;;
    ;;
    (defcap DPDC-MNG|C>RESPAWN-NFT (account:string id:string nonce:integer)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (ref-DPDC:module{DpdcV1} DPDC)
            )
            ;;Account Ownership
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            ;;Correct Role
            (ref-DPDC::UEV_AccountCreateState id false account true)
            ;;NFT Nonce must not exist, to respawn it
            (ref-DPDC::UEV_NftNonceExistance id nonce false)
            ;;Req Cap
            (compose-capability (P|DPDC-MNG|CALLER))
        )
    )
    (defcap DPDC-MNG|C>BURN-NFT (account:string id:string nonce:integer)
        @event
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
            )
            ;;Account Ownership - via Debit Function
            ;;Correct Role
            (ref-DPDC::UEV_AccountBurnState id false account true)
            ;;Nonce Must Exist to Burn it
            (ref-DPDC::UEV_NftNonceExistance id nonce true)
            ;;Remove Nonces Capability (also enforces nonces are held by account)
            (compose-capability (DPDC-MNG|C>REMOVE-CLASS-ZERO-NONCES account id false [nonce] [1]))
        )
    )
    (defcap DPDC-MNG|C>WIPE-NFT-NONCE (account:string id:string nonce:integer)
        @event
        (compose-capability (DPDC-MNG|C>WIPE-NFT account id [nonce] [1]))
    )
    (defcap DPDC-MNG|C>WIPE-NFT-NONCES (account:string id:string nonces:[integer])
        @event
        (compose-capability (DPDC-MNG|C>WIPE-NFT account id nonces (make-list (length nonces) 1)))
    )

    (defcap DPDC-MNG|C>WIPE-NFT (account:string id:string nonces:[integer] amounts:[integer])
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
            )
            ;;Semi-Fungible <id> is frozen on <account>
            (ref-DPDC::UEV_AccountFreezeState id false account true)
            ;;Semi-Fungible has <can-wipe> set to ON
            (ref-DPDC::UEV_CanWipeON id false)
            ;;Wiping requires <id> ownership - via Debit Function
            ;;Remove Nonces Capability (also enforces nonces are held by account)
            (compose-capability (DPDC-MNG|C>REMOVE-CLASS-ZERO-NONCES account id false nonces amounts))
        )
    )
    ;;
    ;;
    (defcap DPDC-MNG|C>REMOVE-CLASS-ZERO-NONCES
        (account:string id:string son:bool nonces:[integer] amounts:[integer])
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (l1:integer (length nonces))
                (l2:integer (length amounts))
            )
            (enforce (= l1 l2) "Invalid Nonces and Amount for Class Zero Nonce Removal")
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (nonce:integer (at idx nonces))
                            (amount:integer (at idx amounts))
                            (account-nonce-supply:integer (ref-DPDC::UR_AccountNonceSupply account id son nonce))
                        )
                        (enforce
                            (and
                                (> amount 0)
                                (<= amount account-nonce-supply)
                            )
                            (format "Amount {} is invalid for Debiting Nonce {} of {} on Account" [amount nonce id account])
                        )
                    )
                )
                (enumerate 0 (- l1 1))
            )
            (compose-capability (DPDC-MNG|C>IZ-CLASS-ZERO id son nonces))
            (compose-capability (P|SECURE-CALLER))
        )
    )
    (defcap DPDC-MNG|C>IZ-CLASS-ZERO (id:string son:bool nonces:[integer])
        (let
            (
                (class-zero-nonces:[integer] (URC_FilterClassZeroNonces id son nonces))
            )
            (enforce (= nonces class-zero-nonces) "Invalid Class Zero Nonces")
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_TakePureWipe:object{DpdcManagementV1.RemovableNonces} (input:object{DpdcManagementV1.RemovableNonces} size:integer)
        @doc "Takes <size> and returns a smaller |object{DpdcManagementV1.RemovableNonces}|"
        (let
            (
                (nonces:[integer] (at "r-nonces" input))
                (amounts:[integer] (at "r-amounts" input))
                (l:integer (length nonces))
            )
            (enforce (< size l) (format "Size of {} is larger than the Data set of the Removable Nonces Object" [size]))
            (UDC_RemovableNonces
                (take size nonces)
                (take size amounts)
            )
        )
    )
    (defun UC_WipeCumulator:object{IgnisCollectorV1.OutputCumulator}
        (id:string son:bool removable-nonces-obj:object{DpdcManagementV1.RemovableNonces})
        (let
            (
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DPDC:module{DpdcV1} DPDC)
                (no-of-nonces:integer (length (at "r-nonces" removable-nonces-obj)))
            )
            (ref-IGNIS::UDC_ConstructOutputCumulator
                (*  ;;Cost 2 IGNIS per Nonce wiped
                    (ref-DALOS::UR_UsagePrice "ignis|small")
                    (dec no-of-nonces)
                )
                (ref-DPDC::UR_OwnerKonto id son)
                (ref-IGNIS::URC_IsVirtualGasZero)
                [removable-nonces-obj]
            )
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun URDC_WipePure:object{DpdcManagementV1.RemovableNonces} (account:string id:string son:bool)
        @doc "Uses Expensive Read Functions to obtain a |object{DpdcManagementV1.RemovableNonces}| that can be used \
        \ to execute a <C_WipePure>, bypassing the expensive gas costs of using (keys...) or (select...) functions"
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
            )
            (URC_FilterAccountViableNonces account id son (ref-DPDC::URD_AccountNonces account id son))
        )
    )
    (defun URC_FilterClassZeroNonces:[integer] (id:string son:bool nonces:[integer])
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
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
    (defun URC_FilterAccountViableNonces:object{DpdcManagementV1.RemovableNonces}
        (account:string id:string son:bool nonces:[integer])
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (ref-U|LST:module{StringProcessorV1} U|LST)
                (matrix:[[integer]]
                    (fold
                        (lambda
                            (acc:[[integer]] idx:integer)
                            (let
                                (
                                    (acc-nonces:[integer] (at 0 acc))
                                    (acc-amounts:[integer] (at 1 acc))
                                    (nonce:integer (at idx nonces))
                                    (nonce-class:integer (ref-DPDC::UR_NonceClass id son nonce))
                                    (account-nonce-supply:integer (ref-DPDC::UR_AccountNonceSupply account id son nonce))
                                )
                                (if
                                    (and
                                        (= nonce-class 0)
                                        (> account-nonce-supply 0)
                                    )
                                    [
                                        (ref-U|LST::UC_AppL acc-nonces nonce)
                                        (ref-U|LST::UC_AppL acc-amounts account-nonce-supply)
                                    ]
                                    [
                                        acc-nonces
                                        acc-amounts
                                    ]
                                )
                            )
                        )
                        [[][]]
                        (enumerate 0 (- (length nonces) 1))
                    )
                )
            )
            (UDC_RemovableNonces
                (at 0 matrix)
                (at 1 matrix)
            )
        )
    )
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    (defun UDC_RemovableNonces:object{DpdcManagementV1.RemovableNonces}
        (a:[integer] b:[integer])
        {"r-nonces"     : a
        ,"r-amounts"    : b}
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_Control:object{IgnisCollectorV1.OutputCumulator}
        (id:string son:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DPDC:module{DpdcV1} DPDC)
                (owner:string (ref-DPDC::UR_OwnerKonto id son))
            )
            (with-capability (DPDC-MNG|S>CTRL id son)
                (XI_Control id son cu cco ccc casr ctncr cf cw cp)
                (if son
                    (ref-IGNIS::UDC_BigCumulator owner)
                    (ref-IGNIS::UDC_BiggestCumulator owner)
                )
            )
        )
    )
    (defun C_TogglePause:object{IgnisCollectorV1.OutputCumulator}
        (id:string son:bool toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DPDC:module{DpdcV1} DPDC)
            )
            (with-capability (DPDC-MNG|S>TG_PAUSE id son toggle)
                (XI_TogglePause id son toggle)
                (ref-IGNIS::UDC_MediumCumulator (ref-DPDC::UR_OwnerKonto id son))
            )
        )
    )
    ;;
    ;;  [CREDIT-SINGLE]
    ;;  [SFT]
    (defun C_AddQuantity:object{IgnisCollectorV1.OutputCumulator}
        (account:string id:string nonce:integer amount:integer)
        @doc "Add Quantity for an SFT"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DPDC:module{DpdcV1} DPDC)
            )
            (with-capability (DPDC-MNG|C>ADD-QUANTITY account id nonce amount)
                (XI_IncreaseClassZeroSemiFungible account id nonce amount)
                (ref-IGNIS::UDC_SmallCumulator (ref-DPDC::UR_OwnerKonto id true))
            )
        )
    )
    ;;  [NFT]
    (defun C_RespawnNFT:object{IgnisCollectorV1.OutputCumulator} (account:string id:string nonce:integer)
        @doc "Respawns a previously burned NFT"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DPDC:module{DpdcV1} DPDC)
                (ref-DPDC-C:module{DpdcCreateV1} DPDC-C)
            )
            (with-capability (DPDC-MNG|C>RESPAWN-NFT account id nonce)
                (ref-DPDC-C::XB_CreditNFT-Nonce account id nonce 1)
                (ref-IGNIS::UDC_MediumCumulator (ref-DPDC::UR_OwnerKonto id false))
            )
        )
    )
    ;;
    ;;  [DEBIT-SINGLE]
    ;;  [SFT]
    (defun C_BurnSFT:object{IgnisCollectorV1.OutputCumulator}
        (account:string id:string nonce:integer amount:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DPDC:module{DpdcV1} DPDC)
            )
            (with-capability (DPDC-MNG|C>BURN-SFT account id nonce amount)
                ;;Burn Semifungible and Update Supplies
                (XI_DecreaseClassZeroSemiFungibles account id [nonce] [amount] false)
                ;;Costs 2 IGNIS per Burn Event
                (ref-IGNIS::UDC_SmallCumulator (ref-DPDC::UR_OwnerKonto id true))
            )
        )
    )
    (defun C_WipeSlim:object{IgnisCollectorV1.OutputCumulator}
        (account:string id:string nonce:integer amount:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DPDC:module{DpdcV1} DPDC)
            )
            (with-capability (DPDC-MNG|C>WIPE-SFT-NONCE-PARTIALLY account id nonce amount)
                ;;Burn Semifungible and Update Supplies
                (XI_DecreaseClassZeroSemiFungibles account id [nonce] [amount] true)
                ;;Costs 1 IGNIS for Partial Nonce Wipe Event
                (ref-IGNIS::UDC_SmallestCumulator (ref-DPDC::UR_OwnerKonto id true))
            )
        )
    )
    ;;  [NFT]
    (defun C_BurnNFT:object{IgnisCollectorV1.OutputCumulator} (account:string id:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DPDC:module{DpdcV1} DPDC)
                (ref-DPDC-C:module{DpdcCreateV1} DPDC-C)
            )
            (with-capability (DPDC-MNG|C>BURN-NFT account id nonce)
                (ref-DPDC-C::XI_DecreaseClassZeroNonFungibles id account [nonce] false)
                (ref-IGNIS::UDC_MediumCumulator (ref-DPDC::UR_OwnerKonto id false))
            )
        )
    )
    ;;  [SFT+NFT]
    (defun C_WipeNonce:object{IgnisCollectorV1.OutputCumulator}
        (account:string id:string son:bool nonce:integer)
        @doc "Wipes a viable SFT or NFT Nonce in its entirety"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-DPDC:module{DpdcV1} DPDC)
                (owner:string (ref-DPDC::UR_OwnerKonto id son))
            )
            (if son
                (let
                    (
                        (amount:integer (ref-DPDC::UR_AccountNonceSupply account id true nonce))
                    )
                    (with-capability (DPDC-MNG|C>WIPE-SFT-NONCE-TOTALLY account id nonce amount)
                        (XI_DecreaseClassZeroSemiFungibles account id [nonce] [amount] true)
                        (ref-IGNIS::UDC_SmallCumulator owner)
                    )
                )
                (with-capability (DPDC-MNG|C>WIPE-NFT-NONCE account id nonce)
                    (XI_DecreaseClassZeroNonFungibles account id [nonce] true)
                    (ref-IGNIS::UDC_BigCumulator owner)
                )
            )
        )
    )
    ;;
    ;;  [DEBIT-MULTIPLE]
    ;;  [SFT+NFT]
    (defun C_WipeHeavy:object{IgnisCollectorV1.OutputCumulator}
        (account:string id:string son:bool)
        @doc "Wipes all viable <id> Nonces of an SFT or NFT <account> \
            \ \
            \ |Heavy| reffers to the usage of expensive functions like <select> or <keys> \
            \ (that arent meant to be used in transactional context) to get the Account Nonces; \
            \ May fit in a single Transaction for Small Data Sets"
        (UEV_IMC)
        (C_WipePure account id son (URDC_WipePure account id son))
    )
    (defun C_WipePure:object{IgnisCollectorV1.OutputCumulator}
        (account:string id:string son:bool removable-nonces-obj:object{DpdcManagementV1.RemovableNonces})
        @doc "Wipes all <id> Nonces of an SFT or NFT <account>, presented via an <removable-nonces-obj> object \
            \ \
            \ The object must be pre-read (dirty read) \
            \ \
            \ Example to retrieve the <removable-nonces-obj> \
            \ <(URDC_WipePure account id son)> ; to get the whole object \
            \ <(UC_TakePureWipe (URDC_WipePure account id son) 165)> ; to get only the first 165 units \
            \ Aproximately 167 Individual Wipes fit inside one TX (for NFTs)."
        (UEV_IMC)
        (let
            (
                (viable-nonces:[integer] (at "r-nonces" removable-nonces-obj))
                (viable-amounts:[integer] (at "r-amounts" removable-nonces-obj))
            )
            (if son
                (with-capability (DPDC-MNG|C>WIPE-SFT-NONCES account id viable-nonces)
                    ;;Burn SemiFungible and Update Nonce Supplies
                    (XI_DecreaseClassZeroSemiFungibles account id viable-nonces viable-amounts true)
                )
                (with-capability (DPDC-MNG|C>WIPE-NFT-NONCES account id viable-nonces)
                    ;;Burn NonFungible
                    (XI_DecreaseClassZeroNonFungibles account id viable-nonces true)
                )
            )
            ;;Costs 2 IGNIS per Nonce Wiped
            (UC_WipeCumulator id son removable-nonces-obj)
        )
    )
    (defun C_WipeClean:object{IgnisCollectorV1.OutputCumulator}
        (account:string id:string son:bool nonces:[integer])
        @doc "Wipes <id> select viable <nonces> of an SFT or NFT <account> \
            \ Fails if a single nonce is not viable"
        (UEV_IMC)
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
            )
            (C_WipePure account id son
                (UDC_RemovableNonces
                    nonces
                    (ref-DPDC::UR_AccountNoncesSupplies account id son nonces)
                )
            )
        )
    )
    (defun C_WipeDirty:object{IgnisCollectorV1.OutputCumulator}
        (account:string id:string son:bool nonces:[integer])
        @doc "Wipes <id> select <nonces> of an SFT or NFT <account> (at least 1 nonce must be viable)"
        (UEV_IMC)
        (C_WipePure account id son (URC_FilterAccountViableNonces account id son nonces))
    )
    ;;{F7}  [X]
    (defun XI_Control (id:string son:bool cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        (require-capability (DPDC-MNG|S>CTRL id son))
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
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
                (ref-DPDC:module{DpdcV1} DPDC)
            )
            (ref-DPDC::XE_U|IsPaused id son toggle)
        )
    )
    ;;
    (defun XI_IncreaseClassZeroSemiFungible (account:string id:string nonce:integer amount:integer)
        (require-capability (DPDC-MNG|C>ADD-QUANTITY account id nonce amount))
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (ref-DPDC-C:module{DpdcCreateV1} DPDC-C)
                (nonce-supply:integer (ref-DPDC::UR_NonceSupply id true nonce))
            )
            ;;Credit SFT Nonce
            (ref-DPDC-C::XB_CreditSFT-Nonce account id nonce amount)
            ;;Update Nonce Supplies
            (ref-DPDC::XE_U|NonceSupply id nonce (+ amount nonce-supply))
        )
    )
    (defun XI_DecreaseClassZeroSemiFungibles
        (account:string id:string nonces:[integer] amounts:[integer] wipe-mode:bool)
        @doc "Only Positive, Class 0 Nonces can be burned directly with this function \
            \ Negative (Fragment Nonces) and Class Non-0 Nonces (Set Nonces) are protected by direct burning."
        (require-capability (DPDC-MNG|C>IZ-CLASS-ZERO id true nonces))
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (ref-DPDC-C:module{DpdcCreateV1} DPDC-C)
                ;;
                (l1:integer (length nonces))
            )
            ;;Debit SFT Nonce(s)
            (if (= l1 1)
                (ref-DPDC-C::XE_DebitSFT-Nonce account id (at 0 nonces) (at 0 amounts) wipe-mode)
                (ref-DPDC-C::XE_DebitSFT-Nonces account id nonces amounts wipe-mode)
            )
            ;;Update Nonce Supplies
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (nonce:integer (at idx nonces))
                            (amount:integer (at idx amounts))
                            (nonce-supply:integer (ref-DPDC::UR_NonceSupply id true nonce))
                        )
                        ;;Update Nonce Supply
                        (ref-DPDC::XE_U|NonceSupply id nonce (- nonce-supply amount))
                    )
                )
                (enumerate 0 (- l1 1))
            )
        )
    )
    ;;
    (defun XI_DecreaseClassZeroNonFungibles
        (account:string id:string nonces:[integer] wipe-mode:bool)
        (require-capability (DPDC-MNG|C>IZ-CLASS-ZERO id false nonces))
        (let
            (
                (ref-DPDC:module{DpdcV1} DPDC)
                (ref-DPDC-C:module{DpdcCreateV1} DPDC-C)
                ;;
                (l1:integer (length nonces))
            )
            ;;Debit NFT Nonce(s)
            (if (= l1 1)
                (ref-DPDC-C::XE_DebitNFT-Nonce account id (at 0 nonces) 1 wipe-mode)
                (ref-DPDC-C::XE_DebitNFT-Nonces account id nonces (make-list l1 1) wipe-mode)
            )
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)