
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
    (defcap DPDC-N|C>SET-DATA
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData})
        @doc "[0] Controls Full Nonce Updating"
        @event
        (let
            (
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
            )
            (UEV_RoleNftRecreateON id son account)
            (ref-DPDC-C::UEV_NonceDataForCreation new-nonce-data)
            (compose-capability (DPDC-N|C>DATA id son account nonce-or-set-class native-or-split classzero-or-nonzero))
        )
    )
    (defcap DPDC-N|C>SET-ROYALTY
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool royalty-value:decimal)
        @doc "[1] Controls Nonce Native Royalty Updating"
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (UEV_RoleModifyRoyaltiesON id son account)
            (ref-DPDC::UEV_Royalty royalty-value)
            (compose-capability (DPDC-N|C>DATA id son account nonce-or-set-class native-or-split classzero-or-nonzero))
        )
    )
    (defcap DPDC-N|C>SET-IGNIS-ROYALTY
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool royalty-value:decimal)
        @doc "[2] Controls Nonce Native Ignis Royalty Updating"
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (UEV_RoleModifyRoyaltiesON id son account)
            (ref-DPDC::UEV_IgnisRoyalty royalty-value)
            (compose-capability (DPDC-N|C>DATA id son account nonce-or-set-class native-or-split classzero-or-nonzero))
        )
    )
    (defcap DPDC-N|C>SET-NAME
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool)
        @doc "[3] Controls Nonce Name Updating"
        @event
        (compose-capability (DPDC-N|C>UPDATE id son account nonce-or-set-class native-or-split classzero-or-nonzero))
    )
    (defcap DPDC-N|C>SET-DESCRIPTION
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool)
        @doc "[4] Controls Nonce Description Updating"
        @event
        (compose-capability (DPDC-N|C>UPDATE id son account nonce-or-set-class native-or-split classzero-or-nonzero))
    )
    (defcap DPDC-N|C>SET-SCORE
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool score:decimal)
        @doc "[5] Controls Nonce Score Updating"
        @event
        (UEV_Score score)
        (compose-capability (DPDC-N|C>UPDATE id son account nonce-or-set-class native-or-split classzero-or-nonzero))
    )
    (defcap DPDC-N|C>SET-META-DATA
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool)
        @doc "[6] Controls Nonce Meta-Data Updating"
        @event
        (compose-capability (DPDC-N|C>UPDATE id son account nonce-or-set-class native-or-split classzero-or-nonzero))
    )
    
    (defcap DPDC-N|C>SET-URI
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool)
        @doc "[7] Controls Nonce Uri Updating"
        @event
        (UEV_RoleSetNewUriON id son account)
        (compose-capability (DPDC-N|C>DATA id son account nonce-or-set-class native-or-split classzero-or-nonzero))
    )
    ;;
    (defcap DPDC-N|C>UPDATE 
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool)
        (UEV_RoleNftUpdateON id son account)
        (compose-capability (DPDC-N|C>DATA id son account nonce-or-set-class native-or-split classzero-or-nonzero))
    )
    (defcap DPDC-N|C>DATA
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
            )
            (UEV_NonceDataUpdater id son account nonce-or-set-class native-or-split classzero-or-nonzero)
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (compose-capability (P|SECURE-CALLER))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_Nonce:object{DpdcUdc.DPDC|NonceData}
        (id:string son:bool nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-S:module{DpdcSets} DPDC-S)
            )
            (if classzero-or-nonzero
                (if native-or-split
                    (ref-DPDC::UR_NonceData id son nonce-or-set-class)
                    (ref-DPDC::UR_SplitData id son nonce-or-set-class)
                )
                (if native-or-split
                    (ref-DPDC-S::UR_SetNonceData id son nonce-or-set-class)
                    (ref-DPDC-S::UR_SetSplitData id son nonce-or-set-class)
                )
            )
        )
    )
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_NonceDataUpdater
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool)
        (enforce (> nonce-or-set-class 0) "Operation requires greater than zero <nonce-or-set-class>")
        (if classzero-or-nonzero
            ;;Nonce
            (let
                (
                    (ref-DPDC:module{Dpdc} DPDC)
                    (ref-DPDC-F:module{DpdcFragments} DPDC-F)
                    (nonce-class:integer (ref-DPDC::UR_NonceClass id son nonce-or-set-class))
                )
                (enforce (= nonce-class 0) "Nonce Class must be 0 for Operation")
                (ref-DPDC::UEV_Nonce id son nonce-or-set-class)
                (if (not native-or-split)
                    (ref-DPDC-F::UEV_Fragmentation id son nonce-or-set-class)
                    true
                )
            )
            ;;Sets
            (let
                (
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                    (set-class:integer (ref-DPDC-S::UR_SetClass id son nonce-or-set-class))
                )
                (enforce (>= set-class 0) "Set Class must be greater than 0 for Operation")
                (ref-DPDC-S::UEV_SetClass id son nonce-or-set-class)
                (if (not native-or-split)
                    (ref-DPDC-S::UEV_Fragmentation id son nonce-or-set-class)
                    true
                )
            )
        )
    )
    (defun UEV_RoleNftRecreateON (id:string son:bool account:string)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (x:bool (ref-DPDC::UR_CA|R-Recreate id son account))
            )
            (enforce x (format "{} Collection {} Element Data cannot be Updated while using the {} Ouronet Account" [(if son "SFT" "NFT") id account]))
        )
    )
    (defun UEV_RoleNftUpdateON (id:string son:bool account:string)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (x:bool (ref-DPDC::UR_CA|R-Update id son account))
            )
            (enforce x (format "{} Collection {} Element Data cannot be Updated while using the {} Ouronet Account" [(if son "SFT" "NFT") id account]))
        )
    )
    (defun UEV_RoleModifyRoyaltiesON (id:string son:bool account:string)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (x:bool (ref-DPDC::UR_CA|R-ModifyRoyalties id son account))
            )
            (enforce x (format "{} Collection {} Element Data Royalties cannot be Updated while using the {} Ouronet Account" [(if son "SFT" "NFT") id account]))
        )
    )
    (defun UEV_RoleSetNewUriON (id:string son:bool account:string)
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (x:bool (ref-DPDC::UR_CA|R-SetUri id son account))
            )
            (enforce x (format "{} Collection {} Element Data URIs cannot be Updated while using the {} Ouronet Account" [(if son "SFT" "NFT") id account]))
        )
    )
    ;;
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
    (defun C_UpdateNonce
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData})
        @doc "[0] Updates Full Nonce Data"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-DATA id son account nonce-or-set-class native-or-split classzero-or-nonzero new-nonce-data)
                (XI_U|NonceData id son account nonce-or-set-class native-or-split classzero-or-nonzero new-nonce-data)
                (ref-IGNIS::IC|UDC_BiggestCumulator account)
            )
        )
    )
    (defun C_UpdateNonceRoyalty
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool royalty-value:decimal)
        @doc "[1] Updates Nonce Native Royalty Value"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-ROYALTY id son account nonce-or-set-class native-or-split classzero-or-nonzero royalty-value)
                (XI_U|NonceRoyalty id son account nonce-or-set-class native-or-split classzero-or-nonzero true royalty-value)
                (ref-IGNIS::IC|UDC_SmallCumulator account)
            )
        )
    )
    (defun C_UpdateNonceIgnisRoyalty
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool royalty-value:decimal)
        @doc "[2] Updates Nonce Ignis Royalty Value"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-IGNIS-ROYALTY id son account nonce-or-set-class native-or-split classzero-or-nonzero royalty-value)
                (XI_U|NonceRoyalty id son account nonce-or-set-class native-or-split classzero-or-nonzero false royalty-value)
                (ref-IGNIS::IC|UDC_SmallCumulator account)
            )
        )
    )
    (defun C_UpdateNonceName
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool name:string)
        @doc "[3] Updates Nonce Name"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-NAME id son account nonce-or-set-class native-or-split classzero-or-nonzero)
                (XI_U|NonceNoD id son account nonce-or-set-class native-or-split classzero-or-nonzero true name)
                (ref-IGNIS::IC|UDC_SmallCumulator account)
            )
        )
    )
    (defun C_UpdateNonceDescription
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool description:string)
        @doc "[4] Updates Nonce Description"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-DESCRIPTION id son account nonce-or-set-class native-or-split classzero-or-nonzero)
                (XI_U|NonceNoD id son account nonce-or-set-class native-or-split classzero-or-nonzero false description)
                (ref-IGNIS::IC|UDC_SmallCumulator account)
            )
        )
    )
    (defun C_UpdateNonceScore
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool score:decimal)
        @doc "[5] Updates Nonce Score"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-SCORE id son account nonce-or-set-class native-or-split classzero-or-nonzero score)
                (XI_U|NonceScore id son account nonce-or-set-class native-or-split classzero-or-nonzero score)
                (ref-IGNIS::IC|UDC_SmallCumulator account)
            )
        )
    )
    (defun C_UpdateNonceMetaData
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool meta-data:[object])
        @doc "[6] Updates Nonce Meta-Data"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-META-DATA id son account nonce-or-set-class native-or-split classzero-or-nonzero)
                (XI|U_NonceMetaData id son account nonce-or-set-class native-or-split classzero-or-nonzero meta-data)
                (ref-IGNIS::IC|UDC_SmallCumulator account)
            )
        )
    )
    (defun C_UpdateNonceURI
        (
            id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool
            ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}
        )
        @doc "[7] Updates Nonce URIs"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-URI id son account nonce-or-set-class native-or-split classzero-or-nonzero)
                (XI_U|NonceUri id son account nonce-or-set-class native-or-split classzero-or-nonzero ay u1 u2 u3)
                (ref-IGNIS::IC|UDC_SmallCumulator account)
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_U|NonceData
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData})
        ;;nonce-or-set-class    >> nonce value or set-class value
        ;;native-or-split       >> determines if its native or split data
        ;;classzero-or-nonzero  >> Nonce data (class-zero) or Set-Data (non-zero)
        (require-capability (SECURE))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-S:module{DpdcSets} DPDC-S)
            )
            (if classzero-or-nonzero
                ;;Nonce
                (ref-DPDC::XE_U|NonceOrSplitData id son nonce-or-set-class new-nonce-data native-or-split)
                ;;Sets
                (ref-DPDC-S::XB_U|NonceOrSplitData id son nonce-or-set-class new-nonce-data native-or-split)
            )
        )
    )
    (defun XI_U|NonceRoyalty
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool r-or-ir:bool royalty-value:decimal)
        (require-capability (SECURE))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (read-nonce-data:object{DpdcUdc.DPDC|NonceData} (UR_Nonce id son nonce-or-set-class native-or-split classzero-or-nonzero))
                (new-nonce-data:object{DpdcUdc.DPDC|NonceData}
                    (if r-or-ir
                        (+
                            {"royalty" : royalty-value}
                            (remove "royalty" read-nonce-data)
                        )
                        (+
                            {"ignis" : royalty-value}
                            (remove "ignis" read-nonce-data)
                        )
                    ) 
                )
            )
            (XI_U|NonceData id son account nonce-or-set-class native-or-split classzero-or-nonzero new-nonce-data)
        )
    )
    (defun XI_U|NonceNoD 
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool name-or-description:bool name-description:string)
        (require-capability (SECURE))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (read-nonce-data:object{DpdcUdc.DPDC|NonceData} (UR_Nonce id son nonce-or-set-class native-or-split classzero-or-nonzero))
                (new-nonce-data:object{DpdcUdc.DPDC|NonceData}
                    (if name-or-description
                        (+
                            {"name" : name-description}
                            (remove "name" read-nonce-data)
                        )
                        (+
                            {"description" : name-description}
                            (remove "description" read-nonce-data)
                        )
                    ) 
                )
            )
            (XI_U|NonceData id son account nonce-or-set-class native-or-split classzero-or-nonzero new-nonce-data)
        )
    )
    (defun XI_U|NonceScore
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool score:decimal)
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
                (read-nonce-data:object{DpdcUdc.DPDC|NonceData} (UR_Nonce id son nonce-or-set-class native-or-split classzero-or-nonzero))
                (current-nonce-score:decimal (ref-DPDC::UR_N|RawScore read-nonce-data))
                (current-nonce-md:[object] (ref-DPDC::UR_N|MetaData read-nonce-data))
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
                (new-nonce-data:object{DpdcUdc.DPDC|NonceData}
                    (+
                        {"meta-data" : updated-md}
                        (remove "meta-data" read-nonce-data)
                    )
                )
            )
            (XI_U|NonceData id son account nonce-or-set-class native-or-split classzero-or-nonzero new-nonce-data)
        )
    )
    (defun XI|U_NonceMetaData 
        (id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool meta-data:[object])
        (require-capability (SECURE))
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-DPDC:module{Dpdc} DPDC)
                ;;
                (read-nonce-data:object{DpdcUdc.DPDC|NonceData} (UR_Nonce id son nonce-or-set-class native-or-split classzero-or-nonzero))
                (current-nonce-score:decimal (ref-DPDC::UR_N|RawScore read-nonce-data))
                (e-md:[object] [{}])
                ;;
                (updated-md:[object]
                    (if (= current-nonce-score -1.0)
                        meta-data
                        (+ [(ref-DPDC-UDC::UDC_Score current-nonce-score)] meta-data)
                    )
                )
                (new-nonce-data:object{DpdcUdc.DPDC|NonceData}
                    (+
                        {"meta-data" : updated-md}
                        (remove "meta-data" read-nonce-data)
                    )
                )
            )
            (XI_U|NonceData id son account nonce-or-set-class native-or-split classzero-or-nonzero new-nonce-data)
        )
    )
    (defun XI_U|NonceUri
        (
            id:string son:bool account:string nonce-or-set-class:integer native-or-split:bool classzero-or-nonzero:bool
            ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}
        )
        (require-capability (SECURE))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (read-nonce-data:object{DpdcUdc.DPDC|NonceData} (UR_Nonce id son nonce-or-set-class native-or-split classzero-or-nonzero))
                (new-nonce-data:object{DpdcUdc.DPDC|NonceData}
                    (+
                        {"uri-tertiary" : u3}
                        (+
                            {"uri-secondary" : u2}
                            (+
                                {"uri-primary" : u1}
                                (+
                                    {"asset-type" : ay}
                                    (remove "asset-type" read-nonce-data)
                                )
                            )
                        )
                    ) 
                )
            )
            (XI_U|NonceData id son account nonce-or-set-class native-or-split classzero-or-nonzero new-nonce-data)
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)