(module DPDC-T GOV
    ;;
    (implements OuronetPolicy)
    (implements DpdcTransferV4)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-T                 (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPDC-T_ADMIN)))
    (defcap GOV|DPDC-T_ADMIN ()             (enforce-guard GOV|MD_DPDC-T))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|DPDC-T|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC-T|CALLER))
        (compose-capability (SECURE))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|DPDC-T_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC-T_ADMIN)
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
                (ref-P|DPDC-C:module{OuronetPolicy} DPDC-C)
                (mg:guard (create-capability-guard (P|DPDC-T|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
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
    (defcap IGNIS|C>NO-ROYALTY ()
        true
    )
    (defcap DPDC-T|C>REPURPOSE (id:string son:bool repurpose-from:string repurpose-to:string nonces:[integer] amounts:[integer])
        @event
        (let
            (
                (l1:integer (length nonces))
                (l2:integer (length amounts))
            )
            (enforce (= l1 l2) "Invalid Repurpose data")
        )
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap DPDC-T|C>TRANSFER (ids:[string] sons:[bool] sender:string receiver:string nonces-array:[[integer]] amounts-array:[[integer]] method:bool)
        @event
        (let
            (
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPDC:module{DpdcV2} DPDC)
                (l1:integer (length ids))
                (l2:integer (length sons))
                (l3:integer (length nonces-array))
                (l4:integer (length amounts-array))
            )
            ;;Single
            (ref-U|INT::UEV_UniformList [l1 l2 l3 l4])
            (if (and method (ref-DALOS::UR_AccountType receiver))
                (ref-DALOS::CAP_EnforceAccountOwnership receiver)
                true
            )
            (ref-DALOS::CAP_EnforceAccountOwnership sender)
            (ref-DALOS::UEV_EnforceTransferability sender receiver method)
            ;;Multi
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (id:string (at idx ids))
                            (son:bool (at idx sons))
                            (nonces:[integer] (at idx nonces-array))
                            (amounts:[integer] (at idx amounts-array))
                        )
                        (ref-DPDC::UEV_PauseState id son false)
                        (ref-DPDC::UEV_AccountFreezeState id son sender false)
                        (ref-DPDC::UEV_AccountFreezeState id son receiver false)
                        (UEV_TransferRoles id son sender receiver)
                        (UEV_AmountsForTransfer id son nonces amounts)
                    )
                )
                (enumerate 0 (- l1 1))
            )
            ;;Capabilities
            (compose-capability (P|SECURE-CALLER))
        )
    )
    (defcap IGNIS|C>ROYALTY (sender:string receiver:string ta:decimal)
        @event
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
            )
            (enforce (!= sender receiver) "Sender and Receiver must be different")
            (enforce (> ta 0.0) "Cannot debit|credit 0.0 or negative IGNIS amounts")
            (ref-IGNIS::UEV_TwentyFourPrecision ta)
            (compose-capability (IGNIS|C>DEBIT sender ta))
            (compose-capability (IGNIS|C>CREDIT receiver))
        )
    )
    (defcap IGNIS|C>CREDIT (receiver:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::UEV_EnforceAccountExists receiver)
            (compose-capability (P|DPDC-T|CALLER))
        )
    )
    (defcap IGNIS|C>DEBIT (sender:string ta:decimal)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (read-gas:decimal (ref-DALOS::UR_TF_AccountSupply sender false))
            )
            (enforce (<= ta read-gas) "Insufficient IGNIS for Debiting")
            (ref-DALOS::UEV_EnforceAccountExists sender)
            (ref-DALOS::UEV_EnforceAccountType sender false)
            (compose-capability (P|DPDC-T|CALLER))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_AndTruths:bool (truths:[bool])
        (fold (and) true truths)
    )
    (defun UC_CleanseAggregatedRoyalties:object{DpdcTransferV4.AggregatedRoyalties} (agg:object{DpdcTransferV4.AggregatedRoyalties})
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (agg-creators:[string] (at "creators" agg))
                (agg-royalties:[decimal] (at "ignis-royalties" agg))
                (non-zero-indices:[integer]
                    (filter
                        (lambda 
                            (idx:integer) 
                            (!= (at idx agg-royalties) 0.0)
                        )
                        (enumerate 0 (- (length agg-royalties) 1))
                    )
                )
                (how-many-non-zeroes:integer (length non-zero-indices))
                (how-many-zeroes:integer (- (length agg-royalties) how-many-non-zeroes))
            )
            (if (= how-many-zeroes 0)
                agg
                (UDCX_AggregatedRoyalties
                    ;;Creators
                    (map
                        (lambda (idx:integer) (at idx agg-creators))
                        non-zero-indices
                    )
                    ;;Royalties
                    (map
                        (lambda (idx:integer) (at idx agg-royalties))
                        non-zero-indices
                    )
                )
            )
        )
    )
    (defun UC_AggregateRoyalties:object{DpdcTransferV4.AggregatedRoyalties}
        (creators:[string] id-ignis-royalties:[decimal])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (d-creators:[string] (distinct creators))
            )
            (UDCX_AggregatedRoyalties
                d-creators
                (fold
                    (lambda
                        (acc:[decimal] idx:integer)
                        (let
                            (
                                (creator:string (at idx d-creators))
                                (c-idxes:[integer] (ref-U|LST::UC_Search creators creator))
                            )
                            (ref-U|LST::UC_AppL acc
                                (fold
                                    (lambda
                                        (accc:decimal idx:integer)
                                        (+ accc (at (at idx c-idxes) id-ignis-royalties))
                                    )
                                    0.0
                                    (enumerate 0 (- (length c-idxes) 1))
                                )
                            )
                        )
                    )
                    []
                    (enumerate 0 (- (length d-creators) 1))
                )
            )
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun URC_TransferRoleChecker:bool (id:string son:bool sender:string)
        (let
            (
                (ref-DPDC:module{DpdcV2} DPDC)
                (dpdc:string (ref-DPDC::GOV|DPDC|SC_NAME))
                (verum:[string] (ref-DPDC::UR_Verum11 id son))
                (lv:integer (length verum))
                (tra:integer
                    (if (and (= lv 1) (= verum [BAR]))
                        0
                        lv
                    )
                )
            )
            (and
                (> tra 0)
                (not (= sender dpdc))
            )
        )
    )
    (defun URC_SummedIgnisRoyalty:decimal (sender:string id:string son:bool nonces:[integer] amounts:[integer])
        (let
            (
                (ref-DPDC:module{DpdcV2} DPDC)
                (creator:string (ref-DPDC::UR_CreatorKonto id son))
            )
            (if (= sender creator)
                0.0
                (fold
                    (lambda
                        (acc:decimal idx:integer)
                        (+ 
                            acc 
                            (* 
                                (dec (at idx amounts)) 
                                (ref-DPDC::UR_N|IgnisRoyalty (ref-DPDC::UR_NonceData id son (at idx nonces)))
                            )
                        )
                    )
                    0.0
                    (enumerate 0 (- (length nonces) 1))
                )
            )
        )
    )
    (defun URC_TotalTransferPrice:decimal
        (id:string son:bool nonces:[integer] amounts:[integer])
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ft:string (take 2 id))
                (sh:string "E|")
                (sl:decimal (ref-DALOS::UR_UsagePrice "ignis|smallest"))
                (s:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                (m:decimal (ref-DALOS::UR_UsagePrice "ignis|medium"))
                (th:decimal (/ sl 1000.0))
            )
            (fold
                (lambda
                    (acc:decimal idx:integer)
                    (let
                        (
                            (nonce:integer (at idx nonces))
                            (amount:integer (at idx amounts))
                            (price-per-nonce:decimal
                                (if (or (< nonce 0) (fold (and) true [(= ft sh) son (= nonce 1)]))
                                    th
                                    (if son s m)
                                )
                            )
                            (total-price-per-nonce:decimal (* price-per-nonce (dec amount)))
                            (flat-price-per-nonce:decimal
                                (if (> nonce 0)
                                    0.0
                                    (if (= (mod amount 1000) 0)
                                        (dec (/ amount 1000))
                                        (dec (+ (/ amount 1000) 1))
                                    )
                                )
                            )
                        )
                        (fold (+) 0.0 [acc total-price-per-nonce flat-price-per-nonce])
                    )
                )
                0.0
                (enumerate 0 (- (length nonces) 1))
            )
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_TransferRoles (id:string son:bool sender:string receiver:string)
        (let
            (
                (ref-DPDC:module{DpdcV2} DPDC)
                (trc:bool (URC_TransferRoleChecker id son sender))
                (s:bool (ref-DPDC::UR_CA|R-Transfer id son sender))
                (r:bool (ref-DPDC::UR_CA|R-Transfer id son sender))
            )
            (UEV_TransferRoleChecker trc s r)
        )
    )
    (defun UEV_TransferRoleChecker (trc:bool s:bool r:bool)
        (if
            trc
            (enforce-one
                "Invalid TR"
                [
                    (enforce s "Invalid TR Sender")
                    (enforce r "Invalid TR Receiver")
                ]
            )
            true
        )
    )
    (defun UEV_AmountsForTransfer (id:string son:bool nonces:[integer] amounts:[integer])
        (let
            (
                (ref-DPDC:module{DpdcV2} DPDC)
                (l1:integer (length nonces))
                (l2:integer (length amounts))
            )
            (enforce (= l1 l2) "Invalid Nonces|Amounts Pair for Collectable Transfer")
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (nonce:integer (at idx nonces))
                            (amount:integer (at idx amounts))
                            (nonce-supply:integer (ref-DPDC::UR_NonceSupply id son nonce))
                        )
                        (if (and (not son) (> nonce 0))
                            (enforce (= amount 1) "When transfering Native NFT Nonces, their amount must be 1")
                            true
                        )
                    )
                )
                (enumerate 0 (- (length nonces) 1))
            )
        )
    )
    ;;{F3}  [UDC]
    (defun UDC_MultiTransferCumulator:object{IgnisCollectorV2.OutputCumulator}
        (ids:[string] sons:[bool] sender:string receiver:string nonces-array:[[integer]] amounts-array:[[integer]])
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
            )
            (ref-IGNIS::UDC_ConstructOutputCumulator
                (fold
                    (lambda
                        (acc:decimal idx:integer)
                        (+ acc (URC_TotalTransferPrice (at idx ids) (at idx sons) (at idx nonces-array) (at idx amounts-array)))
                    )
                    0.0
                    (enumerate 0 (- (length ids) 1))
                )
                sender
                (ref-IGNIS::URC_ZeroEliteGAZ sender receiver) []
            )
        )
    )
    (defun UDCX_AggregatedRoyalties:object{DpdcTransferV4.AggregatedRoyalties}
        (a:[string] b:[decimal])
        {"creators"         : a
        ,"ignis-royalties"  : b}
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_RepurposeCollectable:object{IgnisCollectorV2.OutputCumulator}
        (id:string son:bool repurpose-from:string repurpose-to:string nonces:[integer] amounts:[integer])
        (UEV_IMC)
        (with-capability (DPDC-T|C>REPURPOSE id son repurpose-from repurpose-to nonces amounts)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DALOS:module{OuronetDalosV5} DALOS)
                    (ref-DPDC:module{DpdcV2} DPDC)
                    (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                    ;;
                    (l:integer (length nonces))
                    (owner:string (ref-DPDC::UR_OwnerKonto id son))
                    (s:decimal (ref-DALOS::UR_UsagePrice "ignis|small"))
                    (m:decimal (ref-DALOS::UR_UsagePrice "ignis|medium"))
                    (p:decimal (if son s m))
                    (sum-amounts:decimal (dec (fold (+) 1 amounts)))
                    (price:decimal (* p sum-amounts))
                    (trigger:bool (ref-IGNIS::URC_IsVirtualGasZero))
                )
                (if (= l 1)
                    ;;Single Mode
                    (let
                        (
                            (nonce:integer (at 0 nonces))
                            (amount:integer (at 0 amounts))
                        )
                        ;;1]Debit from <repurpose-from>
                        (if son
                            (ref-DPDC-C::XE_DebitSFT-Nonce repurpose-from id nonce amount true)
                            (ref-DPDC-C::XE_DebitNFT-Nonce repurpose-from id nonce amount true)
                        )
                        ;;2]Credit to <repurpose-to>
                        (if son
                            (ref-DPDC-C::XB_CreditSFT-Nonce repurpose-to id nonce amount)
                            (ref-DPDC-C::XB_CreditNFT-Nonce repurpose-to id nonce amount)
                        )
                    )
                    ;;Multi Mode
                    (do
                        (if son
                            ;;1]Debit from <repurpose-from>
                            (ref-DPDC-C::XE_DebitSFT-Nonces repurpose-from id nonces amounts true)
                            (ref-DPDC-C::XE_DebitNFT-Nonces repurpose-from id nonces amounts true)
                        )
                        (if son
                            ;;2]Credit to <repurpose-to>
                            (ref-DPDC-C::XB_CreditSFT-Nonces repurpose-to id nonces amounts)
                            (ref-DPDC-C::XB_CreditNFT-Nonces repurpose-to id nonces amounts)
                        )
                    )
                )
                ;;3]Output Cumulator
                (ref-IGNIS::UDC_ConstructOutputCumulator price owner trigger [])
            )
        )
    )
    (defun C_Transfer:object{IgnisCollectorV2.OutputCumulator}
        (ids:[string] sons:[bool] sender:string receiver:string nonces-array:[[integer]] amounts-array:[[integer]] method:bool)
        (UEV_IMC)
        (with-capability (DPDC-T|C>TRANSFER ids sons sender receiver nonces-array amounts-array method)
            (map
                (lambda
                    (idx:integer)
                    (XI_TransferNonces (at idx ids) (at idx sons) sender receiver (at idx nonces-array) (at idx amounts-array))
                )
                (enumerate 0 (- (length ids) 1))
            )
            (UDC_MultiTransferCumulator ids sons sender receiver nonces-array amounts-array)
        )
    )
    (defun C_IgnisRoyaltyCollector:object{DpdcTransferV4.AggregatedRoyalties}
        (patron:string sender:string ids:[string] sons:[bool] nonces-array:[[integer]] amounts-array:[[integer]])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DPDC:module{DpdcV2} DPDC)
                ;;
                (ivgz:bool (ref-IGNIS::URC_IsVirtualGasZero))
                ;;
                (creators:[string]
                    (map
                        (lambda
                            (idx:integer)
                            (ref-DPDC::UR_CreatorKonto (at idx ids) (at idx sons))
                        )
                        (enumerate 0 (- (length ids) 1))
                    )
                )
                (ids-ignis-royalties:[decimal]
                    (map
                        (lambda
                            (idx:integer)
                            (URC_SummedIgnisRoyalty sender (at idx ids) (at idx sons) (at idx nonces-array) (at idx amounts-array))
                        )
                        (enumerate 0 (- (length ids) 1))
                    )
                )
                (sum:decimal (fold (+) 0.0 ids-ignis-royalties))
            )
            (if (or ivgz (= sum 0.0))
                (with-capability (IGNIS|C>NO-ROYALTY )
                    (UDCX_AggregatedRoyalties [""] [0.0])
                )
                (let
                    (
                        (agg:object{DpdcTransferV4.AggregatedRoyalties} (UC_AggregateRoyalties creators ids-ignis-royalties))
                        (cleansed-agg:object{DpdcTransferV4.AggregatedRoyalties} (UC_CleanseAggregatedRoyalties agg))
                        (agg-creators:[string] (at "creators" cleansed-agg))
                        (agg-royalties:[decimal] (at "ignis-royalties" cleansed-agg))
                    )
                    (map
                        (lambda
                            (idx:integer)
                            (with-capability (IGNIS|C>ROYALTY patron (at idx agg-creators) (at idx agg-royalties))
                                (XI_IgnisTransfer patron (at idx agg-creators) (at idx agg-royalties))
                            )
                        )
                        (enumerate 0 (- (length agg-creators) 1))
                    )
                    (UDCX_AggregatedRoyalties agg-creators agg-royalties)
                )
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_TransferNonces (id:string son:bool sender:string receiver:string nonces:[integer] amounts:[integer])
        (let
            (
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                ;;
                (split:object{OuronetIntegersV2.NonceSplitter} (ref-U|INT::UC_NonceSplitter nonces amounts))
                (negative-nonces:[integer] (at "negative-nonces" split))
                (positive-nonces:[integer] (at "positive-nonces" split))
                (negative-counterparts:[integer] (at "negative-counterparts" split))
                (positive-counterparts:[integer] (at "positive-counterparts" split))
                ;;
                (n0:integer (at 0 nonces))
                (a0:integer (at 0 amounts))
                (l1:integer (length nonces))
                (l2:integer (length amounts))
                (negatives:integer (length negative-nonces))
                (positives:integer (length positive-nonces))
                ;;
                (isg:bool (and (= l1 1) (= l2 1)))                  ;;iz-single
                (inn:bool (< n0 0))                                 ;;iz-nonce-negative
                (ong:bool (and (> negatives 0) (= positives 0)))    ;;only-negatives
                (onp:bool (and (> positives 0) (= negatives 0)))    ;;only-positives
            )
            (cond
                ;;SINGLE
                ;;Transfer Native Nonce
                ((UC_AndTruths [isg (not inn) son])
                    (do
                        (ref-DPDC-C::XE_DebitSFT-Nonce sender id n0 a0 false)
                        (ref-DPDC-C::XB_CreditSFT-Nonce receiver id n0 a0)
                    )
                )
                ((UC_AndTruths [isg (not inn) (not son)])
                    (do
                        (ref-DPDC-C::XE_DebitNFT-Nonce sender id n0 a0 false)
                        (ref-DPDC-C::XB_CreditNFT-Nonce receiver id n0 a0)
                    )
                )
                ;;Trasnfer Fragment Nonce
                ((UC_AndTruths [isg inn son])
                    (do
                        (ref-DPDC-C::XE_DebitSFT-FragmentNonce sender id n0 a0)
                        (ref-DPDC-C::XE_CreditSFT-FragmentNonce receiver id n0 a0)
                    )
                )
                ((UC_AndTruths [isg inn (not son)])
                    (do
                        (ref-DPDC-C::XE_DebitNFT-FragmentNonce sender id n0 a0)
                        (ref-DPDC-C::XE_CreditNFT-FragmentNonce receiver id n0 a0)
                    )
                )
                ;;
                ;;MULTI
                ;;Transfer Native Nonces
                ((UC_AndTruths [(not isg) (not ong) onp son])
                    (do
                        (ref-DPDC-C::XE_DebitSFT-Nonces sender id nonces amounts false)
                        (ref-DPDC-C::XB_CreditSFT-Nonces receiver id nonces amounts)
                    )
                )
                ((UC_AndTruths [(not isg) (not ong) onp (not son)])
                    (do
                        (ref-DPDC-C::XE_DebitNFT-Nonces sender id nonces amounts false)
                        (ref-DPDC-C::XB_CreditNFT-Nonces receiver id nonces amounts)
                    )
                )
                ;;Transfer Fragment Nonces
                ((UC_AndTruths [(not isg) ong son])
                    (do
                        (ref-DPDC-C::XE_DebitSFT-FragmentNonces sender id nonces amounts)
                        (ref-DPDC-C::XE_CreditSFT-FragmentNonces receiver id nonces amounts)
                    )
                )
                ((UC_AndTruths [(not isg) ong (not son)])
                    (do
                        (ref-DPDC-C::XE_DebitNFT-FragmentNonces sender id nonces amounts)
                        (ref-DPDC-C::XE_CreditNFT-FragmentNonces receiver id nonces amounts)
                    )
                )
                ;;Transfer Hybrid (Native and Fragment) Nonces
                ((UC_AndTruths [(not isg) (not ong) (not onp) son])
                    (do
                        (ref-DPDC-C::XE_DebitSFT-HybridNonces sender id nonces amounts)
                        (ref-DPDC-C::XE_CreditSFT-HybridNonces receiver id nonces amounts)
                    )
                )
                ((UC_AndTruths [(not isg) (not ong) (not onp) (not son)])
                    (do
                        (ref-DPDC-C::XE_DebitNFT-HybridNonces sender id nonces amounts)
                        (ref-DPDC-C::XE_CreditNFT-HybridNonces receiver id nonces amounts)
                    )
                )
            )
        )
    )
    ;;
    (defun XI_IgnisTransfer (sender:string receiver:string ta:decimal)
        (require-capability (IGNIS|C>ROYALTY sender receiver ta))
        (XI_IgnisDebit sender ta)
        (XI_IgnisCredit receiver ta)
    )
    (defun XI_IgnisCredit (receiver:string ta:decimal)
        (require-capability (IGNIS|C>CREDIT receiver))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::XB_UpdateBalance receiver false (+ (ref-DALOS::UR_TF_AccountSupply receiver false) ta))
        )
    )
    (defun XI_IgnisDebit (sender:string ta:decimal)
        (require-capability (IGNIS|C>DEBIT sender ta))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::XB_UpdateBalance sender false (- (ref-DALOS::UR_TF_AccountSupply sender false) ta))
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)