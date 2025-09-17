(module DPDC-F GOV
    ;;
    (implements OuronetPolicy)
    (implements DpdcFragments)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPDC-F                 (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPDC-F_ADMIN)))
    (defcap GOV|DPDC-F_ADMIN ()             (enforce-guard GOV|MD_DPDC-F))
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
    (defcap P|DPDC-F|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPDC-F|CALLER))
        (compose-capability (SECURE))
    )
    (defcap P|DPDC-F|REMOTE-GOV ()
        @doc "DPDC Remote Governor Capability"
        true
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
        (with-capability (GOV|DPDC-F_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPDC-F_ADMIN)
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
                (ref-P|DPDC-T:module{OuronetPolicy} DPDC-T)
                (mg:guard (create-capability-guard (P|DPDC-F|CALLER)))
            )
            (ref-P|DPDC::P|A_Add
                "DPDC-F|RemoteDpdcGov"
                (create-capability-guard (P|DPDC-F|REMOTE-GOV))
            )
            (ref-P|DPDC::P|A_AddIMP mg)
            (ref-P|DPDC-C::P|A_AddIMP mg)
            (ref-P|DPDC-T::P|A_AddIMP mg)
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
    (defcap DPDC-F|C>ENABLE-FRAGMENTATION
        (
            id:string son:bool nonce:integer
            fragmentation-ind:object{DpdcUdc.DPDC|NonceData}
        )
        @event
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
                (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                (nonce-class:integer (ref-DPDC::UR_NonceClass id son nonce))
                (iz-fragmented:bool (UEV_IzNonceFragmented id son nonce))
            )
            (enforce (= nonce-class 0) "Only Class 0 Nonces can be fragmented")
            (enforce (not iz-fragmented) "Nonce must not be fragmented in order to enable fragmentation for it !")
            (ref-DPDC::UEV_Nonce id son nonce)
            (ref-DPDC::CAP_Owner id son)
            (ref-DPDC-C::UEV_NonceDataForCreation fragmentation-ind)
            (compose-capability (P|DPDC-F|CALLER))
        )
    )
    (defcap DPDC-F|C>NONCE
        (id:string son:bool nonce:integer)
        (UEV_Fragmentation id son nonce)
        (compose-capability (P|DPDC-F|CALLER))
        (compose-capability (P|DPDC-F|REMOTE-GOV))
    )
    (defcap DPDC-F|C>MERGE 
        (nonce:integer amount:integer)
        (let
            (
                (divided:integer (mod amount 1000))
            )
            (enforce (< nonce 0) "Only negative nonces can be used for merging")
            (enforce (= divided 0) "Only multiple of 1000 can be used for Merging")
            (compose-capability (P|DPDC-F|CALLER))
            (compose-capability (P|DPDC-F|REMOTE-GOV))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_IzNonceFragmented:bool (id:string son:bool nonce:integer)
        @doc "Checks if a nonce is fragmented. For non 0 nonce-classes, the set class is checked instead for fragmentation"
        (enforce (> nonce 0) "Only greater than 0 nonces can be checked for fragmentation")
        (let
            (
                (ref-DPDC-UDC:module{DpdcUdc} DPDC-UDC)
                (ref-DPDC:module{Dpdc} DPDC)
                (sd:object{DpdcUdc.DPDC|NonceData} (ref-DPDC::UR_SplitNonceData id son nonce))
                (zd:object{DpdcUdc.DPDC|NonceData} (ref-DPDC-UDC::UDC_ZeroNonceData))
                (nonce-class:integer (ref-DPDC::UR_NonceClass id son nonce))
            )
            (if (!= sd zd) 
                true
                (if (!= nonce-class 0)
                    (let
                        (
                            (ref-DPDC-S:module{DpdcSets} DPDC-S)
                        )
                        (ref-DPDC-S::UEV_IzSetClassFragmented id son nonce-class)
                    )
                    false
                )
            )
        )
    )
    (defun UEV_Fragmentation (id:string son:bool nonce:integer)
        (let
            (
                (iz-fragmented:bool (UEV_IzNonceFragmented id son nonce))
            )
            (enforce iz-fragmented "Nonce must be fragmented for operation")
        )
    )
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_MakeFragments:object{IgnisCollector.OutputCumulator}
        (account:string id:string son:bool nonce:integer amount:integer)
        (UEV_IMC)
        (with-capability (DPDC-F|C>NONCE id son nonce)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC:module{Dpdc} DPDC)
                    (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                    (ref-DPDC-T:module{DpdcTransfer} DPDC-T)
                    (dpdc:string (ref-DPDC::GOV|DPDC|SC_NAME))
                    (neg-nonce:integer (- 0 nonce))
                    (f-amount:integer (* 1000 amount))
                )
                ;;1]Transfer <nonce> <amount> from <account> to <DPDC|SC_NAME>
                (ref-DPDC-T::C_Transfer id son account dpdc [nonce] [amount] true)
                ;;2]Fragment Nonces are credited to the <DPDC|SC_NAME>
                (if son
                    (ref-DPDC-C::XE_CreditSFT-FragmentNonce dpdc id neg-nonce f-amount)
                    (ref-DPDC-C::XE_CreditNFT-FragmentNonce dpdc id neg-nonce f-amount)
                )
                ;;3]They are then transfered to the <account>
                (ref-DPDC-T::C_Transfer id son dpdc account [neg-nonce] [f-amount] true)
                ;;4]Output Cumulator
                (ref-IGNIS::IC|UDC_BiggestCumulator (ref-DPDC::UR_CreatorKonto id son))
            )
        )
    )
    (defun C_MergeFragments:object{IgnisCollector.OutputCumulator}
        (account:string id:string son:bool nonce:integer amount:integer)
        (UEV_IMC)
        (with-capability (DPDC-F|C>MERGE nonce amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC:module{Dpdc} DPDC)
                    (ref-DPDC-C:module{DpdcCreate} DPDC-C)
                    (ref-DPDC-T:module{DpdcTransfer} DPDC-T)
                    (dpdc:string (ref-DPDC::GOV|DPDC|SC_NAME))
                    (pos-nonce:integer (abs nonce))
                    (merged-amount:integer (/ amount 1000))
                )
                ;;1]Transfer <nonce> <amount> from <account> to <DPDC|SC_NAME>
                (ref-DPDC-T::C_Transfer id son account dpdc [nonce] [amount] true)
                ;;2]Fragment Nonces are debited from the <DPDC|SC_NAME>
                (if son
                    (ref-DPDC-C::XE_DebitSFT-FragmentNonce dpdc id nonce amount)
                    (ref-DPDC-C::XE_DebitNFT-FragmentNonce dpdc id nonce amount)
                )
                ;;3]Native <nonces> are transfered from <DPDC|SC_NAME> to <account>
                (ref-DPDC-T::C_Transfer id son dpdc account [pos-nonce] [merged-amount] true)
                ;;4]Output Cumulator
                (ref-IGNIS::IC|UDC_BiggestCumulator (ref-DPDC::UR_CreatorKonto id son))
            )
        )
    )
    (defun C_EnableNonceFragmentation:object{IgnisCollector.OutputCumulator}
        (
            id:string son:bool nonce:integer
            fragmentation-ind:object{DpdcUdc.DPDC|NonceData}
        )
        (UEV_IMC)
        (with-capability (DPDC-F|C>ENABLE-FRAGMENTATION id son nonce fragmentation-ind)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPDC:module{Dpdc} DPDC)
                    (dpdc:string (ref-DPDC::GOV|DPDC|SC_NAME))
                )
                (XI_EnableNonceFragmentation id son nonce fragmentation-ind)
                (ref-DPDC::XE_DeployAccountWNE dpdc id son)
                (ref-IGNIS::IC|UDC_SmallestCumulator (ref-DPDC::UR_CreatorKonto id son))
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_EnableNonceFragmentation 
        (
            id:string son:bool nonce:integer
            fragmentation-ind:object{DpdcUdc.DPDC|NonceData}
        )
        (require-capability (DPDC-F|C>ENABLE-FRAGMENTATION id son nonce fragmentation-ind))
        (let
            (
                (ref-DPDC:module{Dpdc} DPDC)
            )
            (ref-DPDC::XE_U|NonceOrSplitData id son nonce false fragmentation-ind)
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)