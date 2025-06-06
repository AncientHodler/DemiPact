;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module ATSU GOV
    ;;
    (implements OuronetPolicy)
    (implements AutostakeUsageV3)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_ATSU           (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_ATSU           (keyset-ref-guard (GOV|AutostakeKey)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|ATSC_ADMIN)))
    (defcap GOV|ATSC_ADMIN ()
        (enforce-one
            "ATSU Autostake Admin not satisfed"
            [
                (enforce-guard GOV|MD_ATSU)
                (enforce-guard GOV|SC_ATSU)
            ]
        )
    )
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|AutostakeKey ()      (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|AutostakeKey)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|ATSU|CALLER ()
        true
    )
    (defcap P|ATSU|REMOTE-GOV ()
        true
    )
    (defcap P|TT ()
        (compose-capability (P|ATSU|REMOTE-GOV))
        (compose-capability (P|ATSU|CALLER))
        (compose-capability (SECURE))
    )
    (defcap P|DT1 ()
        (compose-capability (P|ATSU|REMOTE-GOV))
        (compose-capability (SECURE))
    )
    (defcap P|DT2 ()
        (compose-capability (P|ATSU|REMOTE-GOV))
        (compose-capability (P|ATSU|CALLER))
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
        (with-capability (GOV|ATSC_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|ATSC_ADMIN)
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
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (mg:guard (create-capability-guard (P|ATSU|CALLER)))
            )
            (ref-P|ATS::P|A_Add
                "ATSU|RemoteAtsGov"
                (create-capability-guard (P|ATSU|REMOTE-GOV))
            )

            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|DPMF::P|A_AddIMP mg)
            (ref-P|ATS::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
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
    (defun CT_EmptyCumulator        ()(let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::DALOS|EmptyOutputCumulatorV2)))
    (defconst EOC                   (CT_EmptyCumulator))
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
    (defcap ATSC|C>COLD_REC (recoverer:string ats:string ra:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership recoverer)
            (ref-ATS::UEV_RecoveryState ats true true)
            (compose-capability (ATSC|C>DEPLOY ats recoverer))
            (compose-capability (P|TT))
        )
    )
    (defcap ATSC|C>CULL (culler:string ats:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership culler)
            (ref-ATS::UEV_id ats)
            (compose-capability (ATSC|C>NORM_LEDGER ats culler))
            (compose-capability (P|TT))
        )
    )
    (defcap ATSC|C>DEPLOY (ats:string acc:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (ref-DALOS::UEV_EnforceAccountExists acc)
            (ref-ATS::UEV_id ats)
            (compose-capability (ATSC|C>NORM_LEDGER ats acc))
        )
    )
    (defcap ATSC|C>NORM_LEDGER (ats:string acc:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
                (dalos-admin:guard GOV|MD_ATSU)
                (autos-admin:guard GOV|SC_ATSU)
                (acc-g:guard (ref-DALOS::UR_AccountGuard acc))
                (sov:string (ref-DALOS::UR_AccountSovereign acc))
                (sov-g:guard (ref-DALOS::UR_AccountGuard sov))
                (gov-g:guard (ref-DALOS::UR_AccountGovernor acc))
            )
            (ref-ATS::UEV_id ats)
            (enforce-one
                "Invalid permission for normalizing ATS|Ledger Account Operations"
                [
                    (enforce-guard dalos-admin)
                    (enforce-guard autos-admin)
                    (enforce-guard acc-g)
                    (enforce-guard sov-g)
                    (enforce-guard gov-g)
                ]
            )
            (compose-capability (P|ATSU|CALLER))
        )
    )
    (defcap ATSH|C>HOT_REC (recoverer:string ats:string ra:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership recoverer)
            (ref-ATS::UEV_id ats)
            (ref-ATS::UEV_RecoveryState ats true false)
            (compose-capability (P|TT))
        )
    )
    (defcap ATSH|C>REDEEM (redeemer:string id:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (iz-rbt:bool (ref-DPMF::URC_IzRBT id))
            )
            (ref-DALOS::UEV_EnforceAccountType redeemer false)
            (ref-DPMF::UEV_id id)
            (enforce iz-rbt "Invalid Hot-RBT")
            (compose-capability (P|TT))
        )
    )
    (defcap ATSH|C>RECOVER (recoverer:string id:string nonce:integer amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (iz-rbt:bool (ref-DPMF::URC_IzRBT id))
                (nonce-max-amount:decimal (ref-DPMF::UR_AccountNonceBalance id nonce recoverer))
            )
            (ref-DALOS::UEV_EnforceAccountType recoverer false)
            (ref-DPMF::UEV_id id)
            (enforce iz-rbt "Invalid Hot-RBT")
            (enforce (>= nonce-max-amount amount) "Recovery Amount surpasses Batch Balance")
            (compose-capability (P|TT))
        )
    )
    (defcap ATSU|C>RM_SCND (ats:string reward-token:string)
        @event
        (let
            (
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (ref-ATS::CAP_Owner ats)
            (ref-ATS::UEV_UpdateColdAndHot ats)
            (ref-ATS::UEV_ParameterLockState ats false)
            (let
                (
                    (rt-position:integer (ref-ATS::URC_RewardTokenPosition ats reward-token))
                )
                (enforce (> rt-position 0) "Primal RT cannot be removed")
            )
            (compose-capability (P|TT))
        )
    )
    (defcap ATSU|C>COIL_OR_CURL (ats:string coil-token:string)
        @event
        (let
            (
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (ref-ATS::UEV_RewardTokenExistance ats coil-token true)
            (compose-capability (P|TT))
        )
    )
    (defcap ATSF|C>FUEL (ats:string reward-token:string)
        @event
        (let
            (
                (ref-ATS:module{AutostakeV3} ATS)
                (index:decimal (ref-ATS::URC_Index ats))
            )
            (ref-ATS::UEV_RewardTokenExistance ats reward-token true)
            (enforce (>= index 0.1) "Fueling cannot take place on a negative Index")
            (compose-capability (P|TT))
        )
    )
    (defcap ATSU|C>SYPHON (ats:string syphon-amounts:[decimal])
        @event
        (let
            (
                (ref-ATS:module{AutostakeV3} ATS)
                (ref-U|LST:module{StringProcessor} U|LST)
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                (l0:integer (length syphon-amounts))
                (l1:integer (length rt-lst))
                (max-syphon:[decimal] (ref-ATS::URC_MaxSyphon ats))
                (max-syphon-sum:decimal (fold (+) 0.0 max-syphon))
                (input-syphon-sum:decimal (fold (+) 0.0 syphon-amounts))

                (resident-amounts:[decimal] (ref-ATS::UR_RoUAmountList ats true))
                (supply-check:[bool] (zip (lambda (x:decimal y:decimal) (<= x y)) syphon-amounts resident-amounts))
                (tr-nr:integer (length (ref-U|LST::UC_Search supply-check true)))
            )
            (ref-ATS::CAP_Owner ats)
            (ref-ATS::UEV_SyphoningState ats true)
            (enforce (= l0 l1) "Invalid Amounts of Syphon Values")
            (enforce (> input-syphon-sum 0.0) "Invalid Syphon Amounts")
            (map
                (lambda
                    (sv:decimal)
                    (enforce (>= sv 0.0) "Unallowed Negative Syphon Values Detected !")
                )
                syphon-amounts
            )
            (enforce (<= input-syphon-sum max-syphon-sum) "Syphon Amounts surpassing pairs Syphon-Index")
            (enforce (= l0 tr-nr) "Invalid syphon amounts surpassing present resident Amounts")
            (compose-capability (P|TT))
        )
    )
    (defcap ATSU|C>KICKSTART (kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
                (index:decimal (ref-ATS::URC_Index ats))
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                (l1:integer (length rt-amounts))
                (l2:integer (length rt-lst))
            )
            (ref-DALOS::CAP_EnforceAccountOwnership (ref-ATS::UR_OwnerKonto ats))
            (ref-DALOS::UEV_EnforceAccountType kickstarter false)
            (enforce (= index -1.0) "Kickstarting can only be done on ATS-Pairs with -1 Index")
            (enforce (= l1 l2) "RT-Amounts list does not correspond with the Number of the ATS-Pair Reward Tokens")
            (enforce (> rbt-request-amount 0.0) "RBT Request Amount must be greater than zero!")
            (compose-capability (P|TT))
        )
    )
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
    (defun C_AddHotRBT:object{IgnisCollector.OutputCumulator}
        (ats:string hot-rbt:string)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (ref-ATS:module{AutostakeV3} ATS)
                ;;
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
            )
            (with-capability (P|ATSU|CALLER)
                (ref-DPMF::C_DeployAccount hot-rbt ats-sc)
                (ref-DPMF::XE_UpdateRewardBearingToken ats hot-rbt)
                (ref-ATS::XE_AddHotRBT ats hot-rbt)
                (let
                    (
                        (ico1:object{IgnisCollector.OutputCumulator}
                            (ref-ATS::XB_EnsureActivationRoles ats false)
                        )
                        (ico2:object{IgnisCollector.OutputCumulator}
                            (ref-IGNIS::IC|UDC_ConstructOutputCumulator price ats-sc trigger [])
                        )
                    )
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2] [])
                )
            )
        )
    )
    (defun C_AddSecondary:object{IgnisCollector.OutputCumulator}
        (ats:string reward-token:string rt-nfr:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-ATS:module{AutostakeV3} ATS)
                ;;
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                (price:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
            )
            (with-capability (P|ATSU|CALLER)
                (ref-DPTF::C_DeployAccount reward-token ats-sc)
                (ref-ATS::XE_AddSecondary ats reward-token rt-nfr)
                (ref-DPTF::XE_UpdateRewardToken ats reward-token true)
                (let
                    (
                        (iz-hot-rbt-present:bool (ref-ATS::URC_IzPresentHotRBT ats))
                        (ico1:object{IgnisCollector.OutputCumulator}
                            (ref-ATS::XB_EnsureActivationRoles ats true)
                        )
                        (ico2:object{IgnisCollector.OutputCumulator}
                            (if iz-hot-rbt-present
                                (ref-ATS::XB_EnsureActivationRoles ats false)
                                EOC
                            )
                        )
                        (ico3:object{IgnisCollector.OutputCumulator}
                            (ref-IGNIS::IC|UDC_ConstructOutputCumulator price ats-sc trigger [])
                        )
                    )
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3] [])
                )
            )
        )
    )
    (defun C_Coil:object{IgnisCollector.OutputCumulator}
        (coiler:string ats:string rt:string amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                ;;
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                (c-rbt-amount:decimal (ref-ATS::URC_RBT ats rt amount))
            )
            (with-capability (ATSU|C>COIL_OR_CURL ats rt)
                (let
                    (
                        (ico1:object{IgnisCollector.OutputCumulator}
                            (ref-TFT::C_Transfer rt coiler ats-sc amount true)
                        )
                        (ico2:object{IgnisCollector.OutputCumulator}
                            (ref-DPTF::C_Mint c-rbt ats-sc c-rbt-amount false)
                        )
                        (ico3:object{IgnisCollector.OutputCumulator}
                            (ref-TFT::C_Transfer c-rbt ats-sc coiler c-rbt-amount true)
                        )
                    )
                    (ref-ATS::XE_UpdateRoU ats rt true true amount)
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3] [c-rbt-amount])
                )
            )
        )
    )
    (defun C_ColdRecovery:object{IgnisCollector.OutputCumulator}
        (recoverer:string ats:string ra:decimal)
        (UEV_IMC)
        (with-capability (ATSC|C>COLD_REC recoverer ats ra)
            (XI_DeployAccount ats recoverer)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-U|ATS:module{UtilityAts} U|ATS)
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (ref-ATS:module{AutostakeV3} ATS)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    ;;
                    (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                    (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                    (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                    (c-rbt-precision:integer (ref-DPTF::UR_Decimals c-rbt))
                    (usable-position:integer (ref-ATS::URC_WhichPosition ats ra recoverer))
                    (fee-promile:decimal (ref-ATS::URC_ColdRecoveryFee ats ra usable-position))
                    (c-rbt-fee-split:[decimal] (ref-U|ATS::UC_PromilleSplit fee-promile ra c-rbt-precision))
                    (c-fr:bool (ref-ATS::UR_ColdRecoveryFeeRedirection ats))
                    (cull-time:time (ref-ATS::URC_CullColdRecoveryTime ats recoverer))
                    ;;for false
                    (ng-c-fr:[decimal] (ref-ATS::URC_RTSplitAmounts ats (at 1 c-rbt-fee-split)))            ;;fee
                    ;;for true
                    (positive-c-fr:[decimal] (ref-ATS::URC_RTSplitAmounts ats (at 0 c-rbt-fee-split)))      ;;remainder
                    ;;
                    (biggest:decimal (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                    (price:decimal (* 2.0 biggest))
                    (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                    (ico1:object{IgnisCollector.OutputCumulator}
                        (ref-TFT::C_Transfer c-rbt recoverer ats-sc ra true)
                    )
                    (ico2:object{IgnisCollector.OutputCumulator}
                        (ref-DPTF::C_Burn c-rbt ats-sc ra)
                    )
                    (ico3:object{IgnisCollector.OutputCumulator}
                        (ref-IGNIS::IC|UDC_ConstructOutputCumulator price ats-sc trigger [])
                    )
                )
                (map
                    (lambda
                        (index:integer)
                        (ref-ATS::XE_UpdateRoU ats (at index rt-lst) false true (at index positive-c-fr))
                        (ref-ATS::XE_UpdateRoU ats (at index rt-lst) true false (at index positive-c-fr))
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
                (let
                    (
                        (ico4:object{IgnisCollector.OutputCumulator}
                            (if (not c-fr)
                                (let
                                    (
                                        (folded-lst:[object{IgnisCollector.OutputCumulator}]
                                            (fold
                                                (lambda
                                                    (acc:[object{IgnisCollector.OutputCumulator}] idx:integer)
                                                    (ref-U|LST::UC_AppL acc 
                                                        (ref-DPTF::C_Burn (at idx rt-lst) ats-sc (at idx ng-c-fr))
                                                    )
                                                )
                                                []
                                                (enumerate 0 (- (length rt-lst) 1))
                                            )
                                        )
                                    )
                                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators folded-lst [])
                                )
                                EOC
                            )
                        )
                    )
                    (XI_StoreUnstakeObject ats recoverer usable-position
                        { "reward-tokens"   : positive-c-fr
                        , "cull-time"       : cull-time}
                    )
                    (XI_Normalize ats recoverer)
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3 ico4] [])
                )
            )
        )
    )
    (defun C_Cull:object{IgnisCollector.OutputCumulator}
        (culler:string ats:string)
        (UEV_IMC)
        (with-capability (ATSC|C>CULL culler ats)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-U|DEC:module{OuronetDecimals} U|DEC)
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-ATS:module{AutostakeV3} ATS)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    ;;
                    (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                    (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                    (c0:[decimal] (XI_MultiCull ats culler))
                    (c1:[decimal] (XI_SingleCull ats culler 1))
                    (c2:[decimal] (XI_SingleCull ats culler 2))
                    (c3:[decimal] (XI_SingleCull ats culler 3))
                    (c4:[decimal] (XI_SingleCull ats culler 4))
                    (c5:[decimal] (XI_SingleCull ats culler 5))
                    (c6:[decimal] (XI_SingleCull ats culler 6))
                    (c7:[decimal] (XI_SingleCull ats culler 7))
                    (ca:[[decimal]] [c0 c1 c2 c3 c4 c5 c6 c7])
                    (cw:[decimal] (ref-U|DEC::UC_AddHybridArray ca))
                    ;;
                    (biggest:decimal (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                    (price:decimal (* 2.0 biggest))
                    (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                    ;;
                    (ico1:object{IgnisCollector.OutputCumulator}
                        (ref-IGNIS::IC|UDC_ConstructOutputCumulator price ats-sc trigger [])
                    )
                    (folded-obj:[object{IgnisCollector.OutputCumulator}]
                        (fold
                            (lambda
                                (acc:[object{IgnisCollector.OutputCumulator}] idx:integer)
                                (ref-U|LST::UC_AppL acc
                                    (if (!= (at idx cw) 0.0)
                                        (do
                                            (ref-ATS::XE_UpdateRoU ats (at idx rt-lst) false false (at idx cw))
                                            (ref-TFT::C_Transfer (at idx rt-lst) ats-sc culler (at idx cw) true)
                                        )
                                        EOC
                                    )
                                )
                            )
                            []
                            (enumerate 0 (- (length rt-lst) 1))
                        )
                    )
                    (ico2:object{IgnisCollector.OutputCumulator}
                        (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators folded-obj [])
                    )
                )
                (XI_Normalize ats culler)
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2] cw)
            )
        )
    )
    (defun C_Curl:object{IgnisCollector.OutputCumulator}
        (curler:string ats1:string ats2:string rt:string amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                ;;
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                (c-rbt1:string (ref-ATS::UR_ColdRewardBearingToken ats1))
                (c-rbt1-amount:decimal (ref-ATS::URC_RBT ats1 rt amount))
                (c-rbt2:string (ref-ATS::UR_ColdRewardBearingToken ats2))
                (c-rbt2-amount:decimal (ref-ATS::URC_RBT ats2 c-rbt1 c-rbt1-amount))
            )
            (with-capability (ATSU|C>COIL_OR_CURL ats1 rt)
                (let
                    (
                        (ico1:object{IgnisCollector.OutputCumulator}
                            (ref-TFT::C_Transfer rt curler ats-sc amount true)
                        )
                        (ico2:object{IgnisCollector.OutputCumulator}
                            (ref-DPTF::C_Mint c-rbt1 ats-sc c-rbt1-amount false)
                        )
                        (ico3:object{IgnisCollector.OutputCumulator}
                            (ref-DPTF::C_Mint c-rbt2 ats-sc c-rbt2-amount false)
                        )
                        (ico4:object{IgnisCollector.OutputCumulator}
                            (ref-TFT::C_Transfer c-rbt2 ats-sc curler c-rbt2-amount true)
                        )
                    )
                    (ref-ATS::XE_UpdateRoU ats1 rt true true amount)
                    (ref-ATS::XE_UpdateRoU ats2 c-rbt1 true true c-rbt1-amount)
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3 ico4] [c-rbt2-amount])
                )
            )
        )
    )
    (defun C_Fuel:object{IgnisCollector.OutputCumulator}
        (fueler:string ats:string reward-token:string amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-ATS:module{AutostakeV3} ATS)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
            )
            (with-capability (ATSF|C>FUEL ats reward-token)
                (ref-ATS::XE_UpdateRoU ats reward-token true true amount)
                (ref-TFT::C_Transfer reward-token fueler ats-sc amount true)
            )
        )
    )
    (defun C_HotRecovery:object{IgnisCollector.OutputCumulator}
        (recoverer:string ats:string ra:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (ref-ATS:module{AutostakeV3} ATS)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                ;;
                (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                (h-rbt:string (ref-ATS::UR_HotRewardBearingToken ats))
                (present-time:time (at "block-time" (chain-data)))
                (meta-data-obj:object{AutostakeV3.ATS|Hot} { "mint-time" : present-time})
                (meta-data:[object] [meta-data-obj])
                (new-nonce:integer (+ (ref-DPMF::UR_NoncesUsed h-rbt) 1))
                ;;
            )
            (with-capability (ATSH|C>HOT_REC recoverer ats ra)
                (let
                    (
                        (ico1:object{IgnisCollector.OutputCumulator}
                            (ref-IGNIS::IC|UDC_ConstructOutputCumulator 
                                (* 3.0 (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                                ats-sc
                                (ref-IGNIS::IC|URC_IsVirtualGasZero)
                                []
                            )
                        )
                        (ico2:object{IgnisCollector.OutputCumulator}
                            (ref-TFT::C_Transfer c-rbt recoverer ats-sc ra true)
                        )
                        (ico3:object{IgnisCollector.OutputCumulator}
                            (ref-DPTF::C_Burn c-rbt ats-sc ra)
                        )
                        (ico4:object{IgnisCollector.OutputCumulator}
                            (ref-DPMF::C_Mint h-rbt ats-sc ra meta-data)
                        )
                        (ico5:object{IgnisCollector.OutputCumulator}
                            (ref-DPMF::C_Transfer h-rbt new-nonce ats-sc recoverer ra true)
                        )
                    )
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3 ico4 ico5] [])
                )
            )
        )
    )
    (defun C_KickStart:object{IgnisCollector.OutputCumulator}
        (kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal)
        (UEV_IMC)
        (with-capability (ATSU|C>KICKSTART kickstarter ats rt-amounts rbt-request-amount)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATS:module{AutostakeV3} ATS)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                    (rbt-id:string (ref-ATS::UR_ColdRewardBearingToken ats))
                    (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                    ;;
                    (folded-obj:[object{IgnisCollector.OutputCumulator}]
                        (fold
                            (lambda
                                (acc:[object{IgnisCollector.OutputCumulator}] idx:integer)
                                (do
                                    (ref-ATS::XE_UpdateRoU ats (at idx rt-lst) true true (at idx rt-amounts))
                                    (ref-U|LST::UC_AppL acc 
                                        (ref-TFT::C_Transfer (at idx rt-lst) kickstarter ats-sc (at idx rt-amounts) true)
                                    )
                                )
                            )
                            []
                            (enumerate 0 (- (length rt-lst) 1))
                        )
                    )
                    (ico1:object{IgnisCollector.OutputCumulator}
                        (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators folded-obj [])      
                    )
                    (ico2:object{IgnisCollector.OutputCumulator}
                        (ref-DPTF::C_Mint rbt-id ats-sc rbt-request-amount false)
                    )
                    (ico3:object{IgnisCollector.OutputCumulator}
                        (ref-TFT::C_Transfer rbt-id ats-sc kickstarter rbt-request-amount true)
                    )
                    (index:decimal (ref-ATS::URC_Index ats))
                )
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3] [index])  
            )
        )
    )
    (defun C_ModifyCanChangeOwner:object{IgnisCollector.OutputCumulator}
        (ats:string new-boolean:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::XE_ModifyCanChangeOwner ats new-boolean)
                (ref-IGNIS::IC|UDC_BigCumulator (ref-ATS::UR_OwnerKonto ats))
            )
        )
    )
    (defun C_RecoverHotRBT:object{IgnisCollector.OutputCumulator}
        (recoverer:string id:string nonce:integer amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (ref-ATS:module{AutostakeV3} ATS)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                (ats:string (ref-DPMF::UR_RewardBearingToken id))
                (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
            )
            (with-capability (ATSH|C>RECOVER recoverer id nonce amount)
                (let
                    (
                        (ico1:object{IgnisCollector.OutputCumulator}
                            (ref-DPMF::C_Transfer id nonce recoverer ats-sc amount true)
                        )
                        (ico2:object{IgnisCollector.OutputCumulator}
                            (ref-DPMF::C_Burn id nonce ats-sc amount)
                        )
                        (ico3:object{IgnisCollector.OutputCumulator}
                            (ref-DPTF::C_Mint c-rbt ats-sc amount false)
                        )
                        (ico4:object{IgnisCollector.OutputCumulator}
                            (ref-TFT::C_Transfer c-rbt ats-sc recoverer amount true)
                        )
                    )
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3 ico4] [])
                )
            )
        )
    )
    (defun C_RecoverWholeRBTBatch:object{IgnisCollector.OutputCumulator}
        (recoverer:string id:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
            )
            (C_RecoverHotRBT recoverer id nonce (ref-DPMF::UR_AccountNonceBalance id nonce recoverer))
        )
    )
    (defun C_Redeem:object{IgnisCollector.OutputCumulator}
        (redeemer:string id:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (ref-ATS:module{AutostakeV3} ATS)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                ;;
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                (precision:integer (ref-DPMF::UR_Decimals id))
                (current-nonce-balance:decimal (ref-DPMF::UR_AccountNonceBalance id nonce redeemer))
                (meta-data (ref-DPMF::UR_AccountNonceMetaData id nonce redeemer))
                ;;
                (birth-date:time (at "mint-time" (at 0 meta-data)))
                (present-time:time (at "block-time" (chain-data)))
                (elapsed-time:decimal (diff-time present-time birth-date))
                ;;
                (ats:string (ref-DPMF::UR_RewardBearingToken id))
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                (h-promile:decimal (ref-ATS::UR_HotRecoveryStartingFeePromile ats))
                (h-decay:integer (ref-ATS::UR_HotRecoveryDecayPeriod ats))
                (h-fr:bool (ref-ATS::UR_HotRecoveryFeeRedirection ats))
                ;;
                (total-time:decimal (* 86400.0 (dec h-decay)))
                (end-time:time (add-time birth-date (hours (* 24 h-decay))))
                (earned-rbt:decimal
                    (if (>= elapsed-time total-time)
                        current-nonce-balance
                        (floor (* current-nonce-balance (/ (- 1000.0 (* h-promile (- 1.0 (/ elapsed-time total-time)))) 1000.0)) precision)
                    )
                )
                (total-rts:[decimal] (ref-ATS::URC_RTSplitAmounts ats current-nonce-balance))
                (earned-rts:[decimal] (ref-ATS::URC_RTSplitAmounts ats earned-rbt))
                (fee-rts:[decimal] (zip (lambda (x:decimal y:decimal) (- x y)) total-rts earned-rts))
            )
            (with-capability (ATSH|C>REDEEM redeemer id)
                (let
                    (
                        (ico1:object{IgnisCollector.OutputCumulator}
                            (ref-DPMF::C_Transfer id nonce redeemer ats-sc current-nonce-balance true)
                        )
                        (ico2:object{IgnisCollector.OutputCumulator}
                            (ref-DPMF::C_Burn id nonce ats-sc current-nonce-balance)
                        )
                        (ico3:object{IgnisCollector.OutputCumulator}
                            (ref-TFT::XE_FeelesMultiTransfer rt-lst ats-sc redeemer earned-rts true)
                        )
                        (folded-obj:[object{IgnisCollector.OutputCumulator}]
                            (fold
                                (lambda
                                    (acc:[object{IgnisCollector.OutputCumulator}] idx:integer)
                                    (do
                                        (ref-ATS::XE_UpdateRoU ats (at idx rt-lst) true false (at idx fee-rts))
                                        (ref-U|LST::UC_AppL acc
                                            (ref-DPTF::C_Burn (at idx rt-lst) ats-sc (at idx fee-rts))
                                        )
                                    )
                                )
                                []
                                (enumerate 0 (- (length rt-lst) 1))
                            )
                        )
                        (ico4:object{IgnisCollector.OutputCumulator}
                            (if (and (not h-fr) (!= earned-rbt current-nonce-balance))
                                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators folded-obj [])
                                EOC
                            )
                        )
                    )
                    (map
                        (lambda
                            (idx:integer)
                            (ref-ATS::XE_UpdateRoU ats (at idx rt-lst) true false (at idx earned-rts))
                        )
                        (enumerate 0 (- (length rt-lst) 1))
                    )
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3 ico4] [])
                )
            )
        )
    )
    (defun C_RemoveSecondary:object{IgnisCollector.OutputCumulator}
        (remover:string ats:string reward-token:string)
        (UEV_IMC)
        (with-capability (ATSU|C>RM_SCND ats reward-token)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (ref-ATS:module{AutostakeV3} ATS)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                    ;;
                    (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                    (remove-position:integer (at 0 (ref-U|LST::UC_Search rt-lst reward-token)))
                    (primal-rt:string (at 0 rt-lst))
                    (resident-sum:decimal (at remove-position (ref-ATS::UR_RoUAmountList ats true)))
                    (unbound-sum:decimal (at remove-position (ref-ATS::UR_RoUAmountList ats false)))
                    (remove-sum:decimal (+ resident-sum unbound-sum))
                    (accounts-with-ats-data:[string] (ref-TFT::DPTF-DPMF-ATS|UR_FilterKeysForInfo ats 3 false))
                    ;;
                    (ico1:object{IgnisCollector.OutputCumulator}
                        (ref-IGNIS::IC|UDC_ConstructOutputCumulator 
                            (ref-DALOS::UR_UsagePrice "ignis|token-issue") 
                            ats-sc
                            (ref-IGNIS::IC|URC_IsVirtualGasZero) 
                            []
                        )
                    )
                    (ico2:object{IgnisCollector.OutputCumulator}
                        (ref-TFT::C_Transfer reward-token ats-sc remover remove-sum true)
                    )
                    (ico3:object{IgnisCollector.OutputCumulator}
                        (ref-TFT::C_Transfer primal-rt remover ats-sc remove-sum true)
                    )
                )
                ;;1]The RT to be removed, is transfered to the remover, from the ATS|SC_NAME
                        ;via ico2
                    ;;2]The amount removed is added back as Primal-RT
                        ;via ico3
                    ;;3]ROU Table is updated with the new DATA, now as primal RT
                    (ref-ATS::XE_UpdateRoU ats primal-rt true true resident-sum)
                    (ref-ATS::XE_UpdateRoU ats primal-rt false true unbound-sum)
                ;;4]Client Accounts are modified to remove the RT Token and update balances with Primal RT
                    (map
                        (lambda
                            (kontos:string)
                            (ref-ATS::XE_ReshapeUnstakeAccount ats kontos remove-position)
                        )
                        accounts-with-ats-data
                    )
                ;;5]Actually Remove the RT from the ATS-Pair
                    (ref-ATS::XE_RemoveSecondary ats reward-token)
                ;;6]Update Data in the DPTF Token Properties
                    (ref-DPTF::XE_UpdateRewardToken ats reward-token false)
                ;;7]Output ICO
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3] [])
            )
        )
    )
    (defun C_RotateOwnership:object{IgnisCollector.OutputCumulator}
        (ats:string new-owner:string)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::XE_ChangeOwnership ats new-owner)
                (ref-IGNIS::IC|UDC_BiggestCumulator (ref-ATS::UR_OwnerKonto ats))
            )
        )
    )
    (defun C_SetColdFee:object{IgnisCollector.OutputCumulator}
        (ats:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::XE_SetColdFee ats fee-positions fee-thresholds fee-array)
                (ref-IGNIS::IC|UDC_SmallCumulator (ref-ATS::UR_OwnerKonto ats))
            )
        )
    )
    (defun C_SetCRD:object{IgnisCollector.OutputCumulator}
        (ats:string soft-or-hard:bool base:integer growth:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::XE_SetCRD ats soft-or-hard base growth)
                (ref-IGNIS::IC|UDC_SmallCumulator (ref-ATS::UR_OwnerKonto ats))
            )
        )
    )
    (defun C_SetHotFee:object{IgnisCollector.OutputCumulator}
        (ats:string promile:decimal decay:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::XE_SetHotFee ats promile decay)
                (ref-IGNIS::IC|UDC_SmallCumulator (ref-ATS::UR_OwnerKonto ats))
            )
        )
    )
    (defun C_Syphon:object{IgnisCollector.OutputCumulator}
        (syphon-target:string ats:string syphon-amounts:[decimal])
        (UEV_IMC)
        (with-capability (ATSU|C>SYPHON ats syphon-amounts)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATS:module{AutostakeV3} ATS)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                    (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                    ;;
                    (folded-obj:[object{IgnisCollector.OutputCumulator}]
                        (fold
                            (lambda
                                (acc:[object{IgnisCollector.OutputCumulator}] idx:integer)
                                (ref-U|LST::UC_AppL acc
                                    (if (> (at idx syphon-amounts) 0.0)
                                        (do
                                            (ref-ATS::XE_UpdateRoU ats (at idx rt-lst) true false (at idx syphon-amounts))
                                            (ref-TFT::C_Transfer (at idx rt-lst) ats-sc syphon-target (at idx syphon-amounts) true)
                                        )
                                        EOC
                                    )

                                )
                            )
                            []
                            (enumerate 0 (- (length rt-lst) 1))
                        )
                    )
                )
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators folded-obj [])
            )
        )
    )
    (defun C_ToggleElite:object{IgnisCollector.OutputCumulator}
        (ats:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::XE_ToggleElite ats toggle)
                (ref-IGNIS::IC|UDC_SmallCumulator (ref-ATS::UR_OwnerKonto ats))
            )
        )
    )
    (defun C_ToggleParameterLock:object{IgnisCollector.OutputCumulator}
        (patron:string ats:string toggle:bool)
        (UEV_IMC)
        (with-capability (P|ATSU|CALLER)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-ATS:module{AutostakeV3} ATS)
                    (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                    (toggle-costs:[decimal] (ref-ATS::XE_ToggleParameterLock ats toggle))
                    (g:decimal (at 0 toggle-costs))
                    (gas-costs:decimal (+ (ref-DALOS::UR_UsagePrice "ignis|small") g))
                    (kda-costs:decimal (at 1 toggle-costs))
                    (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                    (output:bool (if (> kda-costs 0.0) true false))
                )
                (if (> kda-costs 0.0)
                    (do
                        (ref-ATS::XE_IncrementParameterUnlocks ats)
                        (ref-DALOS::KDA|C_Collect patron kda-costs)
                    )
                    true
                )
                (ref-IGNIS::IC|UDC_ConstructOutputCumulator gas-costs ats-sc trigger [output])
            )
        )
    )
    (defun C_ToggleSyphoning:object{IgnisCollector.OutputCumulator}
        (ats:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::XE_ToggleSyphoning ats toggle)
                (ref-IGNIS::IC|UDC_SmallCumulator (ref-ATS::UR_OwnerKonto ats))
            )
        )
    )
    (defun C_TurnRecoveryOn:object{IgnisCollector.OutputCumulator}
        (ats:string cold-or-hot:bool)
        (UEV_IMC)
        (with-capability (P|ATSU|CALLER)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-ATS:module{AutostakeV3} ATS)
                    (ico1:object{IgnisCollector.OutputCumulator}
                        (ref-ATS::XB_EnsureActivationRoles ats cold-or-hot)
                    )
                    (ico2:object{IgnisCollector.OutputCumulator}
                        (ref-IGNIS::IC|UDC_BiggestCumulator (ref-ATS::UR_OwnerKonto ats))
                    )
                )
                (ref-ATS::XE_TurnRecoveryOn ats cold-or-hot)
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2] [])
            )
        )
    )
    (defun C_UpdateSyphon:object{IgnisCollector.OutputCumulator}
        (ats:string syphon:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (with-capability (P|ATSU|CALLER)
                (ref-ATS::XE_UpdateSyphon ats syphon)
                (ref-IGNIS::IC|UDC_SmallCumulator (ref-ATS::UR_OwnerKonto ats))
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_DeployAccount (ats:string acc:string)
        (require-capability (ATSC|C>DEPLOY ats acc))
        (let
            (
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (ref-ATS::XE_SpawnAutostakeAccount ats acc)
            (XI_Normalize ats acc)
        )
    )
    (defun XI_MultiCull:[decimal] (ats:string acc:string)
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|DEC:module{OuronetDecimals} U|DEC)
                (ref-U|ATS:module{UtilityAts} U|ATS)
                (ref-ATS:module{AutostakeV3} ATS)
                (zr:object{UtilityAts.Awo} (ref-ATS::UDC_MakeZeroUnstakeObject ats))
                (ng:object{UtilityAts.Awo} (ref-ATS::UDC_MakeNegativeUnstakeObject ats))
                (p0:[object{UtilityAts.Awo}] (ref-ATS::UR_P0 ats acc))
                (p0l:integer (length p0))
                (boolean-lst:[bool]
                    (fold
                        (lambda
                            (acc:[bool] item:object{UtilityAts.Awo})
                            (ref-U|LST::UC_AppL acc (ref-U|ATS::UC_IzCullable item))
                        )
                        []
                        p0
                    )
                )
                (zr-output:[decimal] (make-list (length (ref-ATS::UR_RewardTokens ats)) 0.0))
                (cullables:[integer] (ref-U|LST::UC_Search boolean-lst true))
                (immutables:[integer] (ref-U|LST::UC_Search boolean-lst false))
                (how-many-cullables:integer (length cullables))
            )
            (if (= how-many-cullables 0)
                zr-output
                (let
                    (
                        (after-cull:[object{UtilityAts.Awo}]
                            (if (< how-many-cullables p0l)
                                (fold
                                    (lambda
                                        (acc:[object{UtilityAts.Awo}] idx:integer)
                                        (ref-U|LST::UC_AppL acc (at (at idx immutables) p0))
                                    )
                                    []
                                    (enumerate 0 (- (length immutables) 1))
                                )
                                [zr]
                            )
                        )
                        (to-be-culled:[object{UtilityAts.Awo}]
                            (fold
                                (lambda
                                    (acc:[object{UtilityAts.Awo}] idx:integer)
                                    (ref-U|LST::UC_AppL acc (at (at idx cullables) p0))
                                )
                                []
                                (enumerate 0 (- (length cullables) 1))
                            )
                        )
                        (culled-values:[[decimal]]
                            (fold
                                (lambda
                                    (acc:[[decimal]] idx:integer)
                                    (ref-U|LST::UC_AppL acc (ref-ATS::URC_CullValue ats (at idx to-be-culled)))
                                )
                                []
                                (enumerate 0 (- (length to-be-culled) 1))
                            )
                        )
                        (summed-culled-values:[decimal] (ref-U|DEC::UC_AddHybridArray culled-values))
                    )
                    (ref-ATS::XE_UpP0 ats acc after-cull)
                    summed-culled-values
                )
            )
        )
    )
    (defun XI_Normalize (ats:string acc:string)
        (require-capability (ATSC|C>NORM_LEDGER ats acc))
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-ATS:module{AutostakeV3} ATS)
                (p0:[object{UtilityAts.Awo}] (ref-ATS::UR_P0 ats acc))
                (p1:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc 1))
                (p2:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc 2))
                (p3:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc 3))
                (p4:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc 4))
                (p5:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc 5))
                (p6:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc 6))
                (p7:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc 7))
                (zr:object{UtilityAts.Awo} (ref-ATS::UDC_MakeZeroUnstakeObject ats))
                (ng:object{UtilityAts.Awo} (ref-ATS::UDC_MakeNegativeUnstakeObject ats))
                (positions:integer (ref-ATS::UR_ColdRecoveryPositions ats))
                (elite:bool (ref-ATS::UR_EliteMode ats))
                (major-tier:integer (ref-DALOS::UR_Elite-Tier-Major acc))
                ;;
                (p0-znn:[object{UtilityAts.Awo}] (if (and (!= p0 [zr]) (!= p0 [ng])) p0 [ng]))
                (p0-znz:[object{UtilityAts.Awo}] (if (and (!= p0 [zr]) (!= p0 [ng])) p0 [zr]))
                (p1-znn:object{UtilityAts.Awo} (if (and (!= p1 zr) (!= p1 ng)) p1 ng))
                (p1-znz:object{UtilityAts.Awo} (if (and (!= p1 zr) (!= p1 ng)) p1 zr))
                (p2-znn:object{UtilityAts.Awo} (if (and (!= p2 zr) (!= p2 ng)) p2 ng))
                (p2-znz:object{UtilityAts.Awo} (if (and (!= p2 zr) (!= p2 ng)) p2 zr))
                (p3-znn:object{UtilityAts.Awo} (if (and (!= p3 zr) (!= p3 ng)) p3 ng))
                (p3-znz:object{UtilityAts.Awo} (if (and (!= p3 zr) (!= p3 ng)) p3 zr))
                (p4-znn:object{UtilityAts.Awo} (if (and (!= p4 zr) (!= p4 ng)) p4 ng))
                (p4-znz:object{UtilityAts.Awo} (if (and (!= p4 zr) (!= p4 ng)) p4 zr))
                (p5-znn:object{UtilityAts.Awo} (if (and (!= p5 zr) (!= p5 ng)) p5 ng))
                (p5-znz:object{UtilityAts.Awo} (if (and (!= p5 zr) (!= p5 ng)) p5 zr))
                (p6-znn:object{UtilityAts.Awo} (if (and (!= p6 zr) (!= p6 ng)) p6 ng))
                (p6-znz:object{UtilityAts.Awo} (if (and (!= p6 zr) (!= p6 ng)) p6 zr))
                (p7-znn:object{UtilityAts.Awo} (if (and (!= p7 zr) (!= p7 ng)) p7 ng))
                (p7-znz:object{UtilityAts.Awo} (if (and (!= p7 zr) (!= p7 ng)) p7 zr))
                (p2-zne:object{UtilityAts.Awo} (if (and (!= p2 zr) (!= p2 ng)) p2 (if (>= major-tier 2) zr ng)))
                (p3-zne:object{UtilityAts.Awo} (if (and (!= p3 zr) (!= p3 ng)) p3 (if (>= major-tier 3) zr ng)))
                (p4-zne:object{UtilityAts.Awo} (if (and (!= p4 zr) (!= p4 ng)) p4 (if (>= major-tier 4) zr ng)))
                (p5-zne:object{UtilityAts.Awo} (if (and (!= p5 zr) (!= p5 ng)) p5 (if (>= major-tier 5) zr ng)))
                (p6-zne:object{UtilityAts.Awo} (if (and (!= p6 zr) (!= p6 ng)) p6 (if (>= major-tier 6) zr ng)))
                (p7-zne:object{UtilityAts.Awo} (if (and (!= p7 zr) (!= p7 ng)) p7 (if (>= major-tier 7) zr ng)))
                ;;
                (c-pm1:[object{UtilityAts.Awo}] (fold (+) [] [p0-znz [p1-znn] [p2-znn] [p3-znn] [p4-znn] [p5-znn] [p6-znn] [p7-znn]]))
                (c-p1:[object{UtilityAts.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-znn] [p3-znn] [p4-znn] [p5-znn] [p6-znn] [p7-znn]]))
                (c-p2:[object{UtilityAts.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-znz] [p3-znn] [p4-znn] [p5-znn] [p6-znn] [p7-znn]]))
                (c-p3:[object{UtilityAts.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-znz] [p3-znz] [p4-znn] [p5-znn] [p6-znn] [p7-znn]]))
                (c-p4:[object{UtilityAts.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-znz] [p3-znz] [p4-znz] [p5-znn] [p6-znn] [p7-znn]]))
                (c-p5:[object{UtilityAts.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-znz] [p3-znz] [p4-znz] [p5-znz] [p6-znn] [p7-znn]]))
                (c-p6:[object{UtilityAts.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-znz] [p3-znz] [p4-znz] [p5-znz] [p6-znz] [p7-znn]]))
                (c-ne:[object{UtilityAts.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-znz] [p3-znz] [p4-znz] [p5-znz] [p6-znz] [p7-znz]]))
                (c-el:[object{UtilityAts.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-zne] [p3-zne] [p4-zne] [p5-zne] [p6-zne] [p7-zne]]))

            )
            (cond
                ((= positions -1) (XI_UUP ats acc c-pm1))
                ((= positions 1) (XI_UUP ats acc c-p1))
                ((= positions 2) (XI_UUP ats acc c-p2))
                ((= positions 3) (XI_UUP ats acc c-p3))
                ((= positions 4) (XI_UUP ats acc c-p4))
                ((= positions 5) (XI_UUP ats acc c-p5))
                ((= positions 6) (XI_UUP ats acc c-p6))
                ((not elite) (XI_UUP ats acc c-ne))
                (elite (XI_UUP ats acc c-el))
                true
            )
        )
    )
    (defun XI_SingleCull:[decimal] (ats:string acc:string position:integer)
        (let
            (
                (ref-ATS:module{AutostakeV3} ATS)
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                (l:integer (length rt-lst))
                (empty:[decimal] (make-list l 0.0))
                (zr:object{UtilityAts.Awo} (ref-ATS::UDC_MakeZeroUnstakeObject ats))
                (unstake-obj:object{UtilityAts.Awo} (ref-ATS::UR_P1-7 ats acc position))
                (rt-amounts:[decimal] (at "reward-tokens" unstake-obj))
                (cull-output:[decimal] (ref-ATS::URC_CullValue ats unstake-obj))
            )
            (if (!= cull-output empty)
                (XI_StoreUnstakeObject ats acc position zr)
                true
            )
            cull-output
        )
    )
    (defun XI_StoreUnstakeObject (ats:string acc:string position:integer obj:object{UtilityAts.Awo})
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-ATS:module{AutostakeV3} ATS)
                (p0:[object{UtilityAts.Awo}] (ref-ATS::UR_P0 ats acc))
            )
            (if (= position -1)
                (if (and
                        (= (length p0) 1)
                        (=
                            (at 0 p0)
                            (ref-ATS::UDC_MakeZeroUnstakeObject ats)
                        )
                    )
                    (ref-ATS::XE_UpP0 ats acc [obj])
                    (ref-ATS::XE_UpP0 ats acc (ref-U|LST::UC_AppL p0 obj))
                )
                (cond
                    ((= position 1) (ref-ATS::XE_UpP1 ats acc obj))
                    ((= position 2) (ref-ATS::XE_UpP2 ats acc obj))
                    ((= position 3) (ref-ATS::XE_UpP3 ats acc obj))
                    ((= position 4) (ref-ATS::XE_UpP4 ats acc obj))
                    ((= position 5) (ref-ATS::XE_UpP5 ats acc obj))
                    ((= position 6) (ref-ATS::XE_UpP6 ats acc obj))
                    ((= position 7) (ref-ATS::XE_UpP7 ats acc obj))
                    true
                )
            )
        )
    )
    (defun XI_UUP (ats:string acc:string data:[object{UtilityAts.Awo}])
        (let
            (
                (ref-ATS:module{AutostakeV3} ATS)
            )
            (ref-ATS::XE_UpP0 ats acc (drop -7 data))
            (ref-ATS::XE_UpP1 ats acc (at 0 (take 1 (take -7 data))))
            (ref-ATS::XE_UpP2 ats acc (at 0 (take 1 (take -6 data))))
            (ref-ATS::XE_UpP3 ats acc (at 0 (take 1 (take -5 data))))
            (ref-ATS::XE_UpP4 ats acc (at 0 (take 1 (take -4 data))))
            (ref-ATS::XE_UpP5 ats acc (at 0 (take 1 (take -3 data))))
            (ref-ATS::XE_UpP6 ats acc (at 0 (take 1 (take -2 data))))
            (ref-ATS::XE_UpP7 ats acc (at 0 (take -1 data)))
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)