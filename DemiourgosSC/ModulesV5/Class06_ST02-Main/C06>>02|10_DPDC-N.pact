
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
        (id:string son:bool account:string nosc:integer nos:bool nost:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData})
        @doc "[0] Controls Full Nonce Updating"
        @event
        (let
            (
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
            )
            (UEV_RoleNftRecreateON id son account)
            (ref-DPDC-C::UEV_NonceDataForCreation new-nonce-data)
            (compose-capability (DPDC-N|C>DATA id son account nosc nos nost))
        )
    )
    (defcap DPDC-N|C>SET-ROYALTY
        (id:string son:bool account:string nosc:integer nos:bool nost:bool royalty-value:decimal)
        @doc "[1] Controls Nonce Native Royalty Updating"
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (UEV_RoleModifyRoyaltiesON id son account)
            (ref-DPDC::UEV_Royalty royalty-value)
            (compose-capability (DPDC-N|C>DATA id son account nosc nos nost))
        )
    )
    (defcap DPDC-N|C>SET-IGNIS-ROYALTY
        (id:string son:bool account:string nosc:integer nos:bool nost:bool royalty-value:decimal)
        @doc "[2] Controls Nonce Native Ignis Royalty Updating"
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (UEV_RoleModifyRoyaltiesON id son account)
            (ref-DPDC::UEV_IgnisRoyalty royalty-value)
            (compose-capability (DPDC-N|C>DATA id son account nosc nos nost))
        )
    )
    (defcap DPDC-N|C>SET-NAME
        (id:string son:bool account:string nosc:integer nos:bool nost:bool)
        @doc "[3] Controls Nonce Name Updating"
        @event
        (compose-capability (DPDC-N|C>UPDATE id son account nosc nos nost))
    )
    (defcap DPDC-N|C>SET-DESCRIPTION
        (id:string son:bool account:string nosc:integer nos:bool nost:bool)
        @doc "[4] Controls Nonce Description Updating"
        @event
        (compose-capability (DPDC-N|C>UPDATE id son account nosc nos nost))
    )
    (defcap DPDC-N|C>SET-SCORE
        (id:string son:bool account:string nosc:integer nos:bool nost:bool score:decimal)
        @doc "[5] Controls Nonce Score Updating"
        @event
        (UEV_Score score)
        (compose-capability (DPDC-N|C>UPDATE id son account nosc nos nost))
    )
    (defcap DPDC-N|C>SET-META-DATA
        (id:string son:bool account:string nosc:integer nos:bool nost:bool)
        @doc "[6] Controls Nonce Meta-Data Updating"
        @event
        (compose-capability (DPDC-N|C>UPDATE id son account nosc nos nost))
    )
    
    (defcap DPDC-N|C>SET-URI
        (id:string son:bool account:string nosc:integer nos:bool nost:bool)
        @doc "[7] Controls Nonce Uri Updating"
        @event
        (UEV_RoleSetNewUriON id son account)
        (compose-capability (DPDC-N|C>DATA id son account nosc nos nost))
    )
    ;;
    (defcap DPDC-N|C>UPDATE 
        (id:string son:bool account:string nosc:integer nos:bool nost:bool)
        (UEV_RoleNftUpdateON id son account)
        (compose-capability (DPDC-N|C>DATA id son account nosc nos nost))
    )
    (defcap DPDC-N|C>DATA
        (id:string son:bool account:string nosc:integer nos:bool nost:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
            )
            (UEV_NonceDataUpdater id son account nosc nos nost)
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (compose-capability (P|SECURE-CALLER))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_Nonce:object{DpdcUdc.DPDC|NonceData}
        (id:string son:bool nosc:integer nos:bool nost:bool)
        @doc "nosc = <Nonce-Or-Set-Class> ; value of either a Nonce or Set-Class \
            \ nos  = <Native-Or-Split>    ; designates either native or split for Nonce-Data \
            \ nost = <NoNCe-Or-SET>       ; designates if <nosc> is either a <nonce> or <set-class> value"
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-S:module{DpdcSets} DPDC-S)
            )
            (if nost
                (if nos
                    (ref-DPDC::UR_NonceData id son nosc)
                    (ref-DPDC::UR_SplitData id son nosc)
                )
                (if nos
                    (ref-DPDC-S::UR_SetNonceData id son nosc)
                    (ref-DPDC-S::UR_SetSplitData id son nosc)
                )
            )
        )
    )
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_NonceDataUpdater
        (id:string son:bool account:string nosc:integer nos:bool nost:bool)
        (enforce (> nosc 0) "Operation requires greater than zero <nonce-or-set-class>")
        (if nost
            ;;Nonce
            (let
                (
                    (ref-DPDC:module{Dpdc} DPDC)
                    (ref-DPDC-F:module{DpdcFragments} DPDC-F)
                )
                (ref-DPDC::UEV_Nonce id son nosc)
                (if (not nos)
                    (ref-DPDC-F::UEV_Fragmentation id son nosc)
                    true
                )
            )
            ;;Sets
            (let
                (
                    (ref-DPDC-S:module{DpdcSets} DPDC-S)
                )
                (ref-DPDC-S::UEV_SetClass id son nosc)
                (if (not nos)
                    (ref-DPDC-S::UEV_Fragmentation id son nosc)
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
        (id:string son:bool account:string nosc:integer nos:bool nost:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData})
        @doc "[0] Updates Full Nonce Data"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-DATA id son account nosc nos nost new-nonce-data)
                (XI_U|NonceData id son account nosc nos nost new-nonce-data)
                (ref-IGNIS::IC|UDC_BiggestCumulator account)
            )
        )
    )
    (defun C_UpdateNonceRoyalty
        (id:string son:bool account:string nosc:integer nos:bool nost:bool royalty-value:decimal)
        @doc "[1] Updates Nonce Native Royalty Value"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-ROYALTY id son account nosc nos nost royalty-value)
                (XI_U|NonceRoyalty id son account nosc nos nost true royalty-value)
                (ref-IGNIS::IC|UDC_SmallCumulator account)
            )
        )
    )
    (defun C_UpdateNonceIgnisRoyalty
        (id:string son:bool account:string nosc:integer nos:bool nost:bool royalty-value:decimal)
        @doc "[2] Updates Nonce Ignis Royalty Value"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-IGNIS-ROYALTY id son account nosc nos nost royalty-value)
                (XI_U|NonceRoyalty id son account nosc nos nost false royalty-value)
                (ref-IGNIS::IC|UDC_SmallCumulator account)
            )
        )
    )
    (defun C_UpdateNonceName
        (id:string son:bool account:string nosc:integer nos:bool nost:bool name:string)
        @doc "[3] Updates Nonce Name"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-NAME id son account nosc nos nost)
                (XI_U|NonceNoD id son account nosc nos nost true name)
                (ref-IGNIS::IC|UDC_SmallCumulator account)
            )
        )
    )
    (defun C_UpdateNonceDescription
        (id:string son:bool account:string nosc:integer nos:bool nost:bool description:string)
        @doc "[4] Updates Nonce Description"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-DESCRIPTION id son account nosc nos nost)
                (XI_U|NonceNoD id son account nosc nos nost false description)
                (ref-IGNIS::IC|UDC_SmallCumulator account)
            )
        )
    )
    (defun C_UpdateNonceScore
        (id:string son:bool account:string nosc:integer nos:bool nost:bool score:decimal)
        @doc "[5] Updates Nonce Score"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-SCORE id son account nosc nos nost score)
                (XI_U|NonceScore id son account nosc nos nost score)
                (ref-IGNIS::IC|UDC_SmallCumulator account)
            )
        )
    )
    (defun C_UpdateNonceMetaData
        (id:string son:bool account:string nosc:integer nos:bool nost:bool meta-data:object)
        @doc "[6] Updates Nonce Meta-Data"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-META-DATA id son account nosc nos nost)
                (XI|U_NonceMetaData id son account nosc nos nost meta-data)
                (ref-IGNIS::IC|UDC_SmallCumulator account)
            )
        )
    )
    (defun C_UpdateNonceURI
        (
            id:string son:bool account:string nosc:integer nos:bool nost:bool
            ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}
        )
        @doc "[7] Updates Nonce URIs"
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
            )
            (with-capability (DPDC-N|C>SET-URI id son account nosc nos nost)
                (XI_U|NonceUri id son account nosc nos nost ay u1 u2 u3)
                (ref-IGNIS::IC|UDC_SmallCumulator account)
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_U|NonceData
        (id:string son:bool account:string nosc:integer nos:bool nost:bool new-nonce-data:object{DpdcUdc.DPDC|NonceData})
        (require-capability (SECURE))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-S:module{DpdcSets} DPDC-S)
            )
            (if nost
                ;;Nonce
                (ref-DPDC::XE_U|NonceOrSplitData id son nosc nos new-nonce-data)
                ;;Sets
                (ref-DPDC-S::XB_U|NonceOrSplitData id son nosc nos new-nonce-data)
            )
        )
    )
    (defun XI_U|NonceRoyalty
        (id:string son:bool account:string nosc:integer nos:bool nost:bool r-or-ir:bool royalty-value:decimal)
        (require-capability (SECURE))
        (let
            (
                (read-nonce-data:object{DpdcUdc.DPDC|NonceData} (UR_Nonce id son nosc nos nost))
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
            (XI_U|NonceData id son account nosc nos nost new-nonce-data)
        )
    )
    (defun XI_U|NonceNoD 
        (id:string son:bool account:string nosc:integer nos:bool nost:bool name-or-description:bool name-description:string)
        (require-capability (SECURE))
        (let
            (
                (read-nonce-data:object{DpdcUdc.DPDC|NonceData} (UR_Nonce id son nosc nos nost))
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
            (XI_U|NonceData id son account nosc nos nost new-nonce-data)
        )
    )
    (defun XI_U|NonceScore
        (id:string son:bool account:string nosc:integer nos:bool nost:bool score:decimal)
        (require-capability (SECURE))
        (let
            (
                (read-nonce-data:object{DpdcUdc.DPDC|NonceData} (UR_Nonce id son nosc nos nost))
                (read-md:object{DpdcUdc.NonceMetaData} (at "meta-data" read-nonce-data))
                ;;
                (updated-md:object{DpdcUdc.NonceMetaData}
                    (+
                        {"score" : score}
                        (remove "score" read-md)
                    )
                )
                (new-nonce-data:object{DpdcUdc.DPDC|NonceData}
                    (+
                        {"meta-data" : updated-md}
                        (remove "meta-data" read-nonce-data)
                    )
                )
            )
            (XI_U|NonceData id son account nosc nos nost new-nonce-data)
        )
    )
    (defun XI|U_NonceMetaData 
        (id:string son:bool account:string nosc:integer nos:bool nost:bool meta-data:object)
        (require-capability (SECURE))
        (let
            (
                (read-nonce-data:object{DpdcUdc.DPDC|NonceData} (UR_Nonce id son nosc nos nost))
                (read-md:object{DpdcUdc.NonceMetaData} (at "meta-data" read-nonce-data))
                ;;
                (updated-md:object{DpdcUdc.NonceMetaData}
                    (+
                        {"meta-data" : meta-data}
                        (remove "meta-data" read-md)
                    )
                )
                (new-nonce-data:object{DpdcUdc.DPDC|NonceData}
                    (+
                        {"meta-data" : updated-md}
                        (remove "meta-data" read-nonce-data)
                    )
                )
            )
            (XI_U|NonceData id son account nosc nos nost new-nonce-data)
        )
    )
    (defun XI_U|NonceUri
        (
            id:string son:bool account:string nosc:integer nos:bool nost:bool
            ay:object{DpdcUdc.URI|Type} u1:object{DpdcUdc.URI|Data} u2:object{DpdcUdc.URI|Data} u3:object{DpdcUdc.URI|Data}
        )
        (require-capability (SECURE))
        (let
            (
                (read-nonce-data:object{DpdcUdc.DPDC|NonceData} (UR_Nonce id son nosc nos nost))
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
            (XI_U|NonceData id son account nosc nos nost new-nonce-data)
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)