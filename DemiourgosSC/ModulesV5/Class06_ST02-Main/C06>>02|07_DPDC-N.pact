
(module DPDC-N GOV
    ;;
    (implements OuronetPolicy)
    (implements DpdcNonce)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-N                 (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPDC-N_ADMIN)))
    (defcap GOV|DPDC-N_ADMIN ()             (enforce-guard GOV|MD_DPDC-N))
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
    (defcap P|DPDC-N|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC-N|CALLER))
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
        (with-capability (GOV|DPDC-N_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC-N_ADMIN)
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
                (mg:guard (create-capability-guard (P|DPDC-N|CALLER)))
            )
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
    ;;{C3}
    ;;{C4}
    (defcap DPDC-N|C>SET-NONCE-SCORE (id:string son:bool account:string nonce:integer score:decimal)
        @event
        (UEV_Score score)
        (compose-capability (DPDC-N|C>NONCE-UPDATE id son account nonce))
    )
    (defcap DPDC-N|C>SET-NONCE-META-DATA (id:string son:bool account:string nonce:integer)
        @event
        (compose-capability (DPDC-N|C>NONCE-UPDATE id son account nonce))
    )
    (defcap DPDC-N|C>SET-NAME-OR-DESCRIPTION (id:string son:bool account:string nonce:integer)
        @event
        (compose-capability (DPDC-N|C>NONCE-UPDATE id son account nonce))
    )
    (defcap DPDC-N|C>SET-ROYALTY (id:string son:bool account:string nonce:integer royalty:decimal)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_Royalty royalty)
            (compose-capability (DPDC-N|C>NONCE-ROYALTY-UPDATE id son account nonce))
        )
    )
    (defcap DPDC-N|C>SET-IGNIS-ROYALTY (id:string son:bool account:string nonce:integer ignis-royalty:decimal)
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::UEV_IgnisRoyalty ignis-royalty)
            (compose-capability (DPDC-N|C>NONCE-ROYALTY-UPDATE id son account nonce))
        )
    )
    (defcap DPDC-N|C>SET-NONCE-URI (id:string son:bool account:string nonce:integer)
        @event
        (UEV_CanUpdateUriON id son account)
        (UEV_NonceManagement id son account nonce)
        (compose-capability (P|DPDC-N|CALLER))
    )
    (defcap DPDC-N|C>NONCE-UPDATE (id:string son:bool account:string nonce:integer)
        (UEV_CanUpdateON id son account)
        (UEV_NonceManagement id son account nonce)
        (compose-capability (P|DPDC-N|CALLER))
    )
    (defcap DPDC-N|C>NONCE-ROYALTY-UPDATE (id:string son:bool account:string nonce:integer)
        (UEV_CanUpdateRoyaltiesON id son account)
        (UEV_NonceManagement id son account nonce)
        (compose-capability (P|DPDC-N|CALLER))
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_NonceManagement (id:string son:bool account:string nonce:integer)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (ref-DPDC::UEV_Nonce id son nonce)
            (ref-DPDC::CAP_Owner id son)
        )
    )
    (defun UEV_CanUpdateON (id:string son:bool account:string)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (x:bool (ref-DPDC::UR_CA|R-Update id son account))
            )
            (enforce x (format "{} Collection {} Nonces cannot be Updated while using the {} Ouronet Account" [(if son "SFT" "NFT") id account]))
        )
    )
    (defun UEV_CanUpdateRoyaltiesON (id:string son:bool account:string)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (x:bool (ref-DPDC::UR_CA|R-ModifyRoyalties id son account))
            )
            (enforce x (format "{} Collection {} Nonces Royalties cannot be Updated while using the {} Ouronet Account" [(if son "SFT" "NFT") id account]))
        )
    )
    (defun UEV_CanUpdateUriON (id:string son:bool account:string)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (x:bool (ref-DPDC::UR_CA|R-SetUri id son account))
            )
            (enforce x (format "{} Collection {} Nonces Uris cannot be Updated while using the {} Ouronet Account" [(if son "SFT" "NFT") id account]))
        )
    )
    (defun UEV_Score (score:decimal)
        (enforce
            (= (floor score 24) score)
            (format "The score {} can have up to 24 decimals precision" [score])
        )
        (enforce 
            (and (>= score -1.0) (<= score 100000000000.0))
            "Score must be lower than 100 billion"
        )
    )
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_UpdateNonceRoyalty:object{IgnisCollector.OutputCumulator}
        (id:string son:bool account:string nonce:integer royalty:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-ROYALTY id son account nonce royalty)
                (XI_UpdateNonceRoyalty id son account nonce true royalty)
                (ref-IGNIS::IC|UDC_SmallestCumulator account)
            )
        )
    )
    (defun C_UpdateNonceIgnisRoyalty:object{IgnisCollector.OutputCumulator}
        (id:string son:bool account:string nonce:integer ignis-royalty:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-IGNIS-ROYALTY id son account nonce ignis-royalty)
                (XI_UpdateNonceRoyalty id son account nonce false ignis-royalty)
                (ref-IGNIS::IC|UDC_SmallestCumulator account)
            )
        )
    )
    (defun C_UpdateNonceNameOrDescription:object{IgnisCollector.OutputCumulator}
        (id:string son:bool account:string nonce:integer name-or-description:bool name-description:string)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-NAME-OR-DESCRIPTION id son account nonce)
                (XI_UpdateNonceNoD id son account nonce name-or-description name-description)
                (ref-IGNIS::IC|UDC_SmallestCumulator account)
            )
        )
    )
    (defun C_UpdateNonceScore:object{IgnisCollector.OutputCumulator}
        (id:string son:bool account:string nonce:integer score:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-NONCE-SCORE id son account nonce score)
                (XI_UpdateNonceScore id son account nonce score)
                (ref-IGNIS::IC|UDC_SmallestCumulator account)
            )
        )
    )
    (defun C_UpdateNonceMetadata:object{IgnisCollector.OutputCumulator}
        (id:string son:bool account:string nonce:integer meta-data:[object])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-NONCE-META-DATA id son account nonce)
                (XI_UpdateNonceMetaData id son account nonce meta-data)
                (ref-IGNIS::IC|UDC_SmallestCumulator account)
            )
        )
    )
    (defun C_UpdateNonceUri:object{IgnisCollector.OutputCumulator}
        (
            id:string son:bool account:string nonce:integer
            ay:object{DpdcUdc.URI|Type}
            u1:object{DpdcUdc.URI|Data}
            u2:object{DpdcUdc.URI|Data}
            u3:object{DpdcUdc.URI|Data}
        )
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-NONCE-URI id son account nonce)
                (XI_UpdateNonceUri id son account nonce ay u1 u2 u3)
                (ref-IGNIS::IC|UDC_SmallestCumulator account)
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_UpdateNonceUri
        (
            id:string son:bool account:string nonce:integer
            ay:object{DpdcUdc.URI|Type}
            u1:object{DpdcUdc.URI|Data}
            u2:object{DpdcUdc.URI|Data}
            u3:object{DpdcUdc.URI|Data}
        )
        (require-capability (DPDC-N|C>SET-NONCE-URI id son account nonce))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
                (nonce-data-new:object{DpdcUdc.DPDC|NonceData}
                    (+
                        {"uri-tertiary" : u3}
                        (+
                            {"uri-secondary" : u2}
                            (+
                                {"uri-primary" : u1}
                                (+
                                    {"asset-type" : ay}
                                    (remove "asset-type" (ref-DPDC::UR_NonceData id son nonce))
                                )
                            )
                        )
                    ) 
                )
            )
            (ref-DPDC::XE_U|NonceOrSplitData id son nonce nonce-data-new true)
        )
    )
    (defun XI_UpdateNonceRoyalty 
        (id:string son:bool account:string nonce:integer r-or-ir:bool royalty-value:decimal)
        (if r-or-ir
            (require-capability (DPDC-N|C>SET-ROYALTY id son account nonce royalty-value))
            (require-capability (DPDC-N|C>SET-IGNIS-ROYALTY id son account nonce royalty-value))
        )
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
                (nonce-data-new:object{DpdcUdc.DPDC|NonceData}
                    (if r-or-ir
                        (+
                            {"royalty" : royalty-value}
                            (remove "royalty" (ref-DPDC::UR_NonceData id son nonce))
                        )
                        (+
                            {"ignis" : royalty-value}
                            (remove "ignis" (ref-DPDC::UR_NonceData id son nonce))
                        )
                    ) 
                )
            )
            (ref-DPDC::XE_U|NonceOrSplitData id son nonce nonce-data-new true)
        )
    )
    (defun XI_UpdateNonceNoD (id:string son:bool account:string nonce:integer name-or-description:bool name-description:string)
        (require-capability (DPDC-N|C>SET-NAME-OR-DESCRIPTION id son account nonce))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
                (nonce-data-new:object{DpdcUdc.DPDC|NonceData}
                    (if name-or-description
                        (+
                            {"name" : name-description}
                            (remove "name" (ref-DPDC::UR_NonceData id son nonce))
                        )
                        (+
                            {"description" : name-description}
                            (remove "description" (ref-DPDC::UR_NonceData id son nonce))
                        )
                    ) 
                )
            )
            (ref-DPDC::XE_U|NonceOrSplitData id son nonce nonce-data-new true)
        )
    )
    (defun XI_UpdateNonceScore (id:string son:bool account:string nonce:integer score:decimal)
        (require-capability (DPDC-N|C>SET-NONCE-SCORE id son account nonce score))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
                (current-nonce-score:decimal (ref-DPDC::UR_N|Score id son nonce))
                (current-nonce-md:[object] (ref-DPDC::UR_N|MetaData (ref-DPDC::UR_NonceData id son nonce)))
                (score-md-obj:object (ref-DPDC-UDC::UDC_Score score))
                (e-md:[object] [{}])
                ;;
                (updated-md:[object]
                    (if (= current-nonce-score -1.0)
                        (if (= current-nonce-md e-md)
                            [score-md-obj]
                            (ref-U|LST::UC_InsertFirst current-nonce-md score-md-obj)
                        )
                        (ref-U|LST::UC_ReplaceAt current-nonce-md 0 score-md-obj)
                    )
                )
                (updated-nd:object{DpdcUdc.DPDC|NonceData}
                    (+
                        {"meta-data" : updated-md}
                        (remove "meta-data" (ref-DPDC::UR_NonceData id son nonce))
                    )
                )
                (nos:bool (if (< nonce 0) false true))
            )
            (ref-DPDC::XE_U|NonceOrSplitData id son nonce updated-nd nos)
        )
    )
    (defun XI_UpdateNonceMetaData (id:string son:bool account:string nonce:integer meta-data:[object])
        (require-capability (DPDC-N|C>SET-NONCE-META-DATA id son account nonce))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
                (current-nonce-score:decimal (ref-DPDC::UR_N|Score id son nonce))
                (e-md:[object] [{}])
                ;;
                (updated-md:[object]
                    (if (= current-nonce-score -1.0)
                        meta-data
                        (+ [(ref-DPDC-UDC::UDC_Score current-nonce-score)] meta-data)
                    )
                )
                (updated-nd:object{DpdcUdc.DPDC|NonceData}
                    (+
                        {"meta-data" : updated-md}
                        (remove "meta-data" (ref-DPDC::UR_NonceData id son nonce))
                    )
                )
                (nos:bool (if (< nonce 0) false true))
            )
            (ref-DPDC::XE_U|NonceOrSplitData id son nonce updated-nd nos)
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)