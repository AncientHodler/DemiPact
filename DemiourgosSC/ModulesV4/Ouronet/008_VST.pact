;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface VestingV3
    @doc "Exposes Vesting Functions \
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
        \ \
        \ V3 Removes <patron> input variable where it is not needed"
    ;;
    (defschema VST|MetaDataSchema
        release-amount:decimal
        release-date:time
    )
    ;;
    ;;
    (defun VST|SetGovernor (patron:string))
    ;;
    ;;
    (defun UC_MergeAll:[decimal] (balances:[decimal] seconds-to-unsleep:[decimal]))
    ;;
    (defun URC_CullMetaDataAmountWithObject:list (client:string id:string nonce:integer))
    (defun URC_CullMetaDataAmount:decimal (client:string id:string nonce:integer))
    (defun URC_CullMetaDataObject:[object{VST|MetaDataSchema}] (client:string id:string nonce:integer))
    (defun URC_SecondsToUnlock:[decimal] (dpmf:string account:string nonces:[integer]))
    ;;
    (defun UEV_NoncesForMerging (nonces:[integer]))
    (defun UEV_SpecialTokenRole (dptf:string))
    ;;
    (defun UDC_ComposeVestingMetaData:[object{VST|MetaDataSchema}] (dptf:string amount:decimal offset:integer duration:integer milestones:integer))
    ;;
    ;;
    (defun C_CreateFrozenLink:object{IgnisCollector.OutputCumulator} (patron:string dptf:string))
    (defun C_CreateReservationLink:object{IgnisCollector.OutputCumulator} (patron:string dptf:string))
    (defun C_CreateVestingLink:object{IgnisCollector.OutputCumulator} (patron:string dptf:string))
    (defun C_CreateSleepingLink:object{IgnisCollector.OutputCumulator} (patron:string dptf:string))
    ;;
    ;;
    (defun C_Freeze:object{IgnisCollector.OutputCumulator} (freezer:string freeze-output:string dptf:string amount:decimal))
    (defun C_RepurposeFrozen:object{IgnisCollector.OutputCumulator} (dptf-to-repurpose:string repurpose-from:string repurpose-to:string))
    (defun C_ToggleTransferRoleFrozenDPTF:object{IgnisCollector.OutputCumulator} (s-dptf:string target:string toggle:bool))
    ;;
    (defun C_Reserve:object{IgnisCollector.OutputCumulator} (reserver:string dptf:string amount:decimal))
    (defun C_Unreserve:object{IgnisCollector.OutputCumulator} (unreserver:string r-dptf:string amount:decimal))
    (defun C_RepurposeReserved:object{IgnisCollector.OutputCumulator} (dptf-to-repurpose:string repurpose-from:string repurpose-to:string))
    (defun C_ToggleTransferRoleReservedDPTF:object{IgnisCollector.OutputCumulator} (s-dptf:string target:string toggle:bool))
    ;;
    (defun C_Unvest:object{IgnisCollector.OutputCumulator} (unvester:string dpmf:string nonce:integer))
    (defun C_Vest:object{IgnisCollector.OutputCumulator} (vester:string target-account:string dptf:string amount:decimal offset:integer duration:integer milestones:integer))
    (defun C_RepurposeVested:object{IgnisCollector.OutputCumulator} (dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string))
    ;;
    (defun C_Merge:object{IgnisCollector.OutputCumulator} (merger:string dpmf:string nonces:[integer]))
    (defun C_MergeAll:object{IgnisCollector.OutputCumulator} (merger:string dpmf:string))
    (defun C_Sleep:object{IgnisCollector.OutputCumulator} (sleeper:string target-account:string dptf:string amount:decimal duration:integer))
    (defun C_Unsleep:object{IgnisCollector.OutputCumulator} (unsleeper:string dpmf:string nonce:integer))
    (defun C_RepurposeSleeping:object{IgnisCollector.OutputCumulator} (dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string))
    (defun C_RepurposeMerge:object{IgnisCollector.OutputCumulator} (dpmf-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string))
    (defun C_RepurposeMergeAll:object{IgnisCollector.OutputCumulator} (dpmf-to-repurpose:string repurpose-from:string repurpose-to:string))
    (defun C_ToggleTransferRoleSleepingDPMF:object{IgnisCollector.OutputCumulator} (s-dpmf:string target:string toggle:bool))
)

;;For V4
;;<UEV_StillHasSleeping>
(module VST GOV
    ;;
    (implements OuronetPolicy)
    (implements VestingV3)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_VST            (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_VST            (keyset-ref-guard VST|SC_KEY))
    ;;
    (defconst VST|SC_KEY            (GOV|VestingKey))
    (defconst VST|SC_NAME           (GOV|VST|SC_NAME))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|VESTING_ADMIN)))
    (defcap GOV|VESTING_ADMIN ()
        (enforce-one
            "VESTING Admin not satisfed"
            [
                (enforce-guard GOV|MD_VST)
                (enforce-guard GOV|SC_VST)
            ]
        )
    )
    (defcap VST|GOV ()
        @doc "Governor Capability for the Vesting Smart DALOS Account"
        true
    )
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|VestingKey ()        (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|VestingKey)))
    (defun GOV|VST|SC_NAME ()       (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|VST|SC_NAME)))
    (defun VST|SetGovernor (patron:string)
        (with-capability (P|VST|CALLER)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-U|G:module{OuronetGuards} U|G)
                    (ico:object{IgnisCollector.OutputCumulator}
                        (ref-DALOS::C_RotateGovernor
                            VST|SC_NAME
                            (ref-U|G::UEV_GuardOfAny
                                [
                                    (create-capability-guard (VST|GOV))
                                    (P|UR "SWPL|RemoteSwpGov")
                                ]
                            )
                        )
                    )
                )
                (ref-IGNIS::IC|C_Collect patron ico)
            )
        )
    )
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|VST|CALLER ()
        true
    )
    (defcap P|DT ()
        (compose-capability (VST|GOV))
        (compose-capability (P|VST|CALLER))
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|VST|CALLER))
        (compose-capability (SECURE))
    )
    (defcap P|GOVERNING-SECURE-CALLER ()
        (compose-capability (P|SECURE-CALLER))
        (compose-capability (VST|GOV))
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
        (with-capability (GOV|VESTING_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|VESTING_ADMIN)
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
                (ref-P|ATSU:module{OuronetPolicy} ATSU)
                (mg:guard (create-capability-guard (P|VST|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|DPMF::P|A_AddIMP mg)
            (ref-P|ATS::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|ATSU::P|A_AddIMP mg)
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
    (defun CT_EmptyCumulator        ()(let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::DALOS|EmptyOutputCumulatorV2)))
    (defconst BAR                   (CT_Bar))
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
    (defcap VST|C>FROZEN-LINK (dptf:string)
        @event
        (compose-capability (VST|C>LINK dptf))
    )
    (defcap VST|C>FREEZE (freezer:string freeze-output:string dptf:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
            )
            (ref-DALOS::UEV_EnforceAccountType freeze-output false)
            (ref-DALOS::CAP_EnforceAccountOwnership freezer)
            (ref-DPTF::UEV_Amount dptf amount)
            (ref-DPTF::UEV_Frozen dptf true)
            (UEV_SpecialTokenRole dptf)
            (compose-capability (P|DT))
        )
    )
    ;;
    (defcap VST|C>RESERVATION-LINK (dptf:string)
        @event
        (compose-capability (VST|C>LINK dptf))
    )
    (defcap VST|C>RESERVE (reserver:string dptf:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (iz-reservation:bool (ref-DPTF::UR_IzReservationOpen dptf))
            )
            (ref-DALOS::UEV_EnforceAccountType reserver false)
            (ref-DALOS::CAP_EnforceAccountOwnership reserver)
            (ref-DPTF::UEV_Amount dptf amount)
            (ref-DPTF::UEV_Reserved dptf true)
            (UEV_SpecialTokenRole dptf)
            (enforce iz-reservation (format "Reservation is not opened for Token {}" [dptf]))
            (compose-capability (P|DT))
        )
    )
    (defcap VST|C>UNRESERVE (unreserver:string r-dptf:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (dptf:string (ref-DPTF::UR_Reservation r-dptf))
            )
            (ref-DALOS::UEV_EnforceAccountType unreserver true)
            (ref-DPTF::UEV_Amount r-dptf amount)
            (ref-DPTF::CAP_Owner dptf)
            (ref-DPTF::UEV_Reserved r-dptf true)
            (UEV_SpecialTokenRole (ref-DPTF::UR_Reservation r-dptf))
            (compose-capability (P|DT))
        )
    )
    ;;
    (defcap VST|C>VESTING-LINK (dptf:string)
        @event
        (compose-capability (VST|C>LINK dptf))
    )
    (defcap VST|C>VEST (vester:string target-account:string dptf:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
            )
            (ref-DALOS::UEV_EnforceAccountType vester false)
            (ref-DALOS::UEV_EnforceAccountType target-account false)
            (ref-DPTF::UEV_Amount dptf amount)
            (ref-DPTF::CAP_Owner dptf)
            (ref-DPTF::UEV_Vesting dptf true)
            (UEV_SpecialTokenRole dptf)
            (compose-capability (P|DT))
        )
    )
    (defcap VST|C>CULL (unvester:string dpmf:string nonce:integer)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (culled-amount:decimal (URC_CullMetaDataAmount unvester dpmf nonce))
            )
            (enforce (> culled-amount 0.0) (format "Nonce {} cant be culled" [nonce]))
            (ref-DALOS::UEV_EnforceAccountType unvester false)
            (ref-DPMF::UEV_Vesting dpmf true)
            (UEV_SpecialTokenRole (ref-DPMF::UR_Vesting dpmf))
            (compose-capability (P|DT))
        )
    )
    ;;
    (defcap VST|C>SLEEPING-LINK (dptf:string)
        @event
        (compose-capability (VST|C>LINK dptf))
    )
    (defcap VST|C>SLEEP (sleeper:string target-account:string dptf:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
            )
            (ref-DALOS::UEV_EnforceAccountType target-account false)
            (ref-DALOS::CAP_EnforceAccountOwnership sleeper)
            (ref-DPTF::UEV_Amount dptf amount)
            (ref-DPTF::UEV_Sleeping dptf true)
            (UEV_SpecialTokenRole dptf)
            (compose-capability (P|DT))
        )
    )
    (defcap VST|C>UNSLEEP (unsleeper:string dpmf:string nonce:integer)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (initial-amount:decimal (ref-DPMF::UR_AccountNonceBalance dpmf nonce unsleeper))
                (dptf:string (ref-DPMF::UR_Sleeping dpmf))
                (culled-amount:decimal (URC_CullMetaDataAmount unsleeper dpmf nonce))
            )
            (ref-DALOS::UEV_EnforceAccountType unsleeper false)
            (ref-DPTF::UEV_Sleeping dptf true)
            (UEV_SpecialTokenRole dptf)
            (enforce (= initial-amount culled-amount) (format "{} with Nonce {} cannot be unsleeped yet" [dpmf nonce]))
            (compose-capability (P|DT))
        )
    )
    (defcap VST|C>MERGE (merger:string dpmf:string nonces:[integer])
        @event
        (UEV_NoncesForMerging nonces)
        (compose-capability (VST|X>MERGE merger dpmf))
    )
    (defcap VST|C>MERGE-ALL (merger:string dpmf:string)
        @event
        (compose-capability (VST|X>MERGE merger dpmf))
    )
    (defcap VST|X>MERGE (merger:string dpmf:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership merger)
            (ref-DALOS::UEV_EnforceAccountType merger false)
            (compose-capability (P|DT))
            (compose-capability (SECURE))
        )
    )
    ;;
    (defcap VST|C>REPURPOSE-FROZEN-TF (dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        @event
        (compose-capability (VST|C>REPURPOSE-TF dptf-to-repurpose repurpose-from repurpose-to true))
    )
    (defcap VST|C>REPURPOSE-RESERVED-TF (dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        @event
        (compose-capability (VST|C>REPURPOSE-TF dptf-to-repurpose repurpose-from repurpose-to false))
    )
    (defcap VST|C>REPURPOSE-VESTING-MF (dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        @event
        (compose-capability (VST|C>REPURPOSE-MF dpmf-to-repurpose [nonce] repurpose-from repurpose-to true))
    )
    (defcap VST|C>REPURPOSE-SLEEPING-MF (dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        @event
        (compose-capability (VST|C>REPURPOSE-MF dpmf-to-repurpose [nonce] repurpose-from repurpose-to false))
    )

    (defcap VST|C>REPURPOSE-MERGE (dpmf-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string)
        @event
        (UEV_NoncesForMerging nonces)
        (compose-capability (VST|C>REPURPOSE-MF dpmf-to-repurpose nonces repurpose-from repurpose-to false))
    )
    (defcap VST|C>REPURPOSE-MERGE-ALL (dpmf-to-repurpose:string repurpose-from:string repurpose-to:string)
        @event
        (compose-capability (VST|X>REPURPOSE-MF dpmf-to-repurpose repurpose-from repurpose-to false))
    )
    (defcap VST|C>REPURPOSE-TF (dptf-to-repurpose:string repurpose-from:string repurpose-to:string frozen-or-reserved:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (dptf:string
                    (if frozen-or-reserved
                        (ref-DPTF::UR_Frozen dptf-to-repurpose)
                        (ref-DPTF::UR_Reservation dptf-to-repurpose)
                    )
                )
            )
            (ref-DALOS::UEV_SenderWithReceiver repurpose-from repurpose-to)
            (ref-DALOS::UEV_EnforceAccountType repurpose-to false)
            (ref-DPTF::CAP_Owner dptf)
            (compose-capability (P|DT))
            (compose-capability (SECURE))
        )
    )
    (defcap VST|C>REPURPOSE-MF (dpmf-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string vesting-or-sleeping:bool)
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
            )
            (ref-DPMF::UEV_NoncesToAccount dpmf-to-repurpose repurpose-from nonces)
            (compose-capability (VST|X>REPURPOSE-MF dpmf-to-repurpose repurpose-from repurpose-to vesting-or-sleeping))
        )
    )
    (defcap VST|X>REPURPOSE-MF (dpmf-to-repurpose:string repurpose-from:string repurpose-to:string vesting-or-sleeping:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (dptf:string
                    (if vesting-or-sleeping
                        (ref-DPMF::UR_Vesting dpmf-to-repurpose)
                        (ref-DPMF::UR_Sleeping dpmf-to-repurpose)
                    )
                )
            )
            (ref-DALOS::UEV_SenderWithReceiver repurpose-from repurpose-to)
            (ref-DALOS::UEV_EnforceAccountType repurpose-to false)
            (ref-DPTF::CAP_Owner dptf)
            (compose-capability (P|DT))
            (compose-capability (SECURE))
        )
    )
    (defcap VST|C>LINK (dptf:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
            )
            (ref-DPTF::CAP_Owner dptf)
        )
        (compose-capability (P|GOVERNING-SECURE-CALLER))
    )
    (defcap VST|C>TOGGLE-FROZEN_TR (s-dptf:string target:string)
        @event
        (compose-capability (VST|X>TOGGLE-SDPTF-TR s-dptf target true))
    )
    (defcap VST|C>TOGGLE-RESERVED_TR (s-dptf:string target:string)
        @event
        (compose-capability (VST|X>TOGGLE-SDPTF-TR s-dptf target false))
    )
    (defcap VST|X>TOGGLE-SDPTF-TR (s-dptf:string target:string frozen-or-reserved:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (dptf:string
                    (if frozen-or-reserved
                        (ref-DPTF::UR_Frozen s-dptf)
                        (ref-DPTF::UR_Reservation s-dptf)
                    )
                )
            )
            (ref-DPTF::CAP_Owner dptf)
            (enforce (!= target VST|SC_NAME) "Transfer role for Special DPTFs cannot be altered for the Vesting Smart Ouronet Account")
            (compose-capability (P|DT))
        )
    )
    (defcap VST|C>TOGGLE-SLEEPING-TR (s-dpmf:string target:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (dptf:string (ref-DPMF::UR_Sleeping s-dpmf))
            )
            (ref-DPTF::CAP_Owner dptf)
            (enforce (!= target VST|SC_NAME) "Transfer role for Sleeping DPMF cannot be altered for the Vesting Smart Ouronet Account")
            (compose-capability (P|DT))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_MergeAll:[decimal] (balances:[decimal] seconds-to-unsleep:[decimal])
        @doc "Combines an equal length <balances> list representing Sleeping DPMF Account Balances \
        \ with a <seconds-to-unsleep> list to create an output decimal list with 3 decimals: \
        \ 1] 1st decimal, representing the amount of DPTF token that can be awaked \
        \ 2] 2nd decimal, representing the amount of Sleeping DPMF that must still exist in a sleeping state \
        \ 3] 3rd decimal, representing the mean computed weigthed average time in seconds until the the sleeping part must still remain asleep"
        (let
            (
                (sum:decimal (fold (+) 0.0 balances))
                (wake-numerator-denominator:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (let
                                (
                                    (wake:decimal (at 0 acc))
                                    (numerator:decimal (at 1 acc))
                                    (denominator:decimal (at 2 acc))
                                    (balance:decimal (at idx balances))
                                    (stu:decimal (at idx seconds-to-unsleep))
                                    (new-wake:decimal
                                        (if (<= stu 0.0)
                                            (+ wake balance)
                                            wake
                                        )
                                    )
                                    (new-numerator:decimal
                                        (if (> stu 0.0)
                                            (floor (+ numerator (* balance stu)) 24)
                                            numerator
                                        )
                                    )
                                    (new-denominator:decimal
                                        (if (>= stu 0.0)
                                            (+ denominator balance)
                                            denominator
                                        )
                                    )
                                )
                                [new-wake new-numerator new-denominator]
                            )
                        )
                        [0.0 0.0 0.0]
                        (enumerate 0 (- (length balances) 1))
                    )
                )
            )
            [
                (at 0 wake-numerator-denominator)
                (- sum (at 0 wake-numerator-denominator))
                (if (!= (at 2 wake-numerator-denominator) 0.0)
                    (floor (/ (at 1 wake-numerator-denominator) (at 2 wake-numerator-denominator)) 0)
                    0.0
                )

            ]
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun URC_CullMetaDataAmountWithObject:list (client:string id:string nonce:integer)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (meta-data:[object{VestingV3.VST|MetaDataSchema}] (ref-DPMF::UR_AccountNonceMetaData id nonce client))
            )
            (fold
                (lambda
                    (acc:list item:object{VestingV3.VST|MetaDataSchema})
                    (let
                        (
                            (balance:decimal (at "release-amount" item))
                            (date:time (at "release-date" item))
                            (present-time:time (at "block-time" (chain-data)))
                            (t:decimal (diff-time present-time date))
                            (current-acc-amount:decimal (at 0 acc))
                            (current-acc-obj:list (at 1 acc))
                            (amount
                                (if (>= t 0.0)
                                    (+ current-acc-amount balance)
                                    current-acc-amount
                                )
                            )
                            (md-obj
                                (if (< t 0.0)
                                    (ref-U|LST::UC_AppL current-acc-obj item)
                                    current-acc-obj
                                )
                            )
                        )
                        [amount md-obj]
                    )
                )
                [0.0 []]
                meta-data
            )
        )
    )
    (defun URC_CullMetaDataAmount:decimal (client:string id:string nonce:integer)
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (meta-data:[object{VestingV3.VST|MetaDataSchema}] (ref-DPMF::UR_AccountNonceMetaData id nonce client))
                (culled-amount:decimal
                    (fold
                        (lambda
                            (acc:decimal item:object{VestingV3.VST|MetaDataSchema})
                            (let
                                (
                                    (balance:decimal (at "release-amount" item))
                                    (date:time (at "release-date" item))
                                    (present-time:time (at "block-time" (chain-data)))
                                    (t:decimal (diff-time present-time date))
                                )
                                (if (>= t 0.0)
                                    (+ acc balance)
                                    acc
                                )
                            )
                        )
                        0.0
                        meta-data
                    )
                )
            )
            culled-amount
        )
    )
    (defun URC_CullMetaDataObject:[object{VestingV3.VST|MetaDataSchema}] (client:string id:string nonce:integer)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (meta-data:[object{VestingV3.VST|MetaDataSchema}] (ref-DPMF::UR_AccountNonceMetaData id nonce client))
            )
            (fold
                (lambda
                    (acc:[object{VestingV3.VST|MetaDataSchema}] item:object{VestingV3.VST|MetaDataSchema})
                    (let
                        (
                            (date:time (at "release-date" item))
                            (present-time:time (at "block-time" (chain-data)))
                            (t:decimal (diff-time present-time date))
                        )
                        (if (< t 0.0)
                            (ref-U|LST::UC_AppL acc item)
                            acc
                        )
                    )
                )
                []
                meta-data
            )
        )
    )
    (defun URC_SecondsToUnlock:[decimal] (dpmf:string account:string nonces:[integer])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (meta-datas:[[object{VestingV3.VST|MetaDataSchema}]] (ref-DPMF::UR_AccountNoncesMetaDatas dpmf nonces account))
                (present-time:time (at "block-time" (chain-data)))
            )
            (fold
                (lambda
                    (acc:[decimal] idx:integer)
                    (ref-U|LST::UC_AppL
                        acc
                        (diff-time (at "release-date" (at 0 (take -1 (at idx meta-datas)))) present-time)
                    )
                )
                []
                (enumerate 0 (- (length meta-datas) 1))
            )
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_NoncesForMerging (nonces:[integer])
        (let
            (
                (l:integer (length nonces))
            )
            (enforce (>= l 2) "Merging requires at least 2 nonces")
        )
    )
    (defun UEV_SpecialTokenRole (dptf:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (t:bool (ref-DPTF::UR_AccountRoleFeeExemption dptf VST|SC_NAME))
            )
            (enforce t (format "Token {} doesnt have the proper role set needed for special Token Functionality" [dptf]))
        )
    )
    (defun UEV_StillHasSleeping (account:string sleeping-dpmf:string nonce:integer)
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (nonce-md:[object] (ref-DPMF::UR_AccountNonceMetaData sleeping-dpmf nonce account))
                (release-date:time (at "release-date" (at 0 nonce-md)))
                (present-time:time (at "block-time" (chain-data)))
                (dt:decimal (diff-time release-date present-time))
            )
            (enforce (> dt 0.0) (format "Nonce {} of Sleeping DPMF {} must be dormant for operation" [nonce sleeping-dpmf]))
        )
    )
    ;;{F3}  [UDC]
    (defun UDC_ComposeVestingMetaData:[object{VestingV3.VST|MetaDataSchema}]
        (dptf:string amount:decimal offset:integer duration:integer milestones:integer)
        (let
            (
                (ref-U|VST:module{UtilityVst} U|VST)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (amount-lst:[decimal] (ref-U|VST::UC_SplitBalanceForVesting (ref-DPTF::UR_Decimals dptf) amount milestones))
                (date-lst:[time] (ref-U|VST::UC_MakeVestingDateList offset duration milestones))
                (meta-data:[object{VestingV3.VST|MetaDataSchema}] (zip (lambda (x:decimal y:time) { "release-amount": x, "release-date": y }) amount-lst date-lst))
            )
            (ref-DPTF::UEV_Amount dptf amount)
            (ref-U|VST::UEV_MilestoneWithTime offset duration milestones)
            meta-data
        )
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_CreateFrozenLink:object{IgnisCollector.OutputCumulator}
        (patron:string dptf:string)
        (UEV_IMC)
        (with-capability (VST|C>FROZEN-LINK dptf)
            (XI_CreateSpecialTrueFungibleLink patron dptf true)
        )
    )
    (defun C_CreateReservationLink:object{IgnisCollector.OutputCumulator}
        (patron:string dptf:string)

        (UEV_IMC)
        (with-capability (VST|C>RESERVATION-LINK dptf)
            (XI_CreateSpecialTrueFungibleLink patron dptf false)
        )
    )
    (defun C_CreateVestingLink:object{IgnisCollector.OutputCumulator}
        (patron:string dptf:string)
        (UEV_IMC)
        (with-capability (VST|C>VESTING-LINK dptf)
            (XI_CreateSpecialMetaFungibleLink patron dptf true)
        )
    )
    (defun C_CreateSleepingLink:object{IgnisCollector.OutputCumulator}
        (patron:string dptf:string)
        (UEV_IMC)
        (with-capability (VST|C>SLEEPING-LINK dptf)
            (XI_CreateSpecialMetaFungibleLink patron dptf false)
        )
    )
    ;;  [Frozen Token Actions]
    (defun C_Freeze:object{IgnisCollector.OutputCumulator}
        (freezer:string freeze-output:string dptf:string amount:decimal)
        (UEV_IMC)
        (with-capability (VST|C>FREEZE freezer freeze-output dptf amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (f-dptf:string (ref-DPTF::UR_Frozen dptf))
                )
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                    [
                        ;;1]Freezer sends dptf to VST|SC_NAME, if its not already there
                        (if (!= freezer VST|SC_NAME)
                            (ref-TFT::C_Transfer dptf freezer VST|SC_NAME amount true)
                            EOC
                        )
                        ;;2]VST|SC_NAME mints F|dptf
                        (ref-DPTF::C_Mint f-dptf VST|SC_NAME amount false)
                        ;;3|VST|SC_Name sends F|dptf to freeze-output
                        (ref-TFT::C_Transfer f-dptf VST|SC_NAME freeze-output amount true)
                    ]
                    []
                )
            )
        )
    )
    (defun C_RepurposeFrozen:object{IgnisCollector.OutputCumulator}
        (dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-FROZEN-TF dptf-to-repurpose repurpose-from repurpose-to)
            (XI_RepurposeTrueFungible dptf-to-repurpose repurpose-from repurpose-to)
        )
    )
    (defun C_ToggleTransferRoleFrozenDPTF:object{IgnisCollector.OutputCumulator}
        (s-dptf:string target:string toggle:bool)
        (UEV_IMC)
        (with-capability (VST|C>TOGGLE-FROZEN_TR s-dptf target)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                )
                (ref-DPTF::C_ToggleTransferRole s-dptf target toggle)
            )
        )
    )
    ;;  [Reserve Token Actions]
    (defun C_Reserve:object{IgnisCollector.OutputCumulator}
        (reserver:string dptf:string amount:decimal)
        (UEV_IMC)
        (with-capability (VST|C>RESERVE reserver dptf amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (r-dptf:string (ref-DPTF::UR_Reservation dptf))
                )
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                    [
                        ;;1]Reserver sends dptf to VST|SC_NAME if its not already tehre
                        (if (!= reserver VST|SC_NAME)
                            (ref-TFT::C_Transfer dptf reserver VST|SC_NAME amount true)
                            EOC
                        )
                        ;;2]VST|SC_NAME mint R|dptf
                        (ref-DPTF::C_Mint r-dptf VST|SC_NAME amount false)
                        ;;3]VST|SC_NAME sends R|dptf to reserver
                        (ref-TFT::C_Transfer r-dptf VST|SC_NAME reserver amount true)
                    ]
                    []
                )
            )
        )
    )
    (defun C_Unreserve:object{IgnisCollector.OutputCumulator}
        (unreserver:string r-dptf:string amount:decimal)
        (UEV_IMC)
        (with-capability (VST|C>UNRESERVE unreserver r-dptf amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (dptf:string (ref-DPTF::UR_Reservation r-dptf))
                )
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                    [
                        ;;1]Unreserver sends R|dptf to VST|SC_NAME
                        (ref-TFT::C_Transfer r-dptf unreserver VST|SC_NAME amount true)
                        ;;2]VST|SC_NAME burns R|dptf
                        (ref-DPTF::C_Burn r-dptf VST|SC_NAME amount)
                        ;;3]VST|SC_NAME sends dptf back to unreserver
                        (ref-TFT::C_Transfer dptf VST|SC_NAME unreserver amount true)
                    ]
                    []
                )
            )
        )
    )
    (defun C_RepurposeReserved:object{IgnisCollector.OutputCumulator}
        (dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-RESERVED-TF dptf-to-repurpose repurpose-from repurpose-to)
            (XI_RepurposeTrueFungible dptf-to-repurpose repurpose-from repurpose-to)
        )
    )
    (defun C_ToggleTransferRoleReservedDPTF:object{IgnisCollector.OutputCumulator}
        (s-dptf:string target:string toggle:bool)
        (UEV_IMC)
        (with-capability (VST|C>TOGGLE-RESERVED_TR s-dptf target)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                )
                (ref-DPTF::C_ToggleTransferRole s-dptf target toggle)
            )
        )
    )
    ;;  [Vesting Token Actions]
    (defun C_Unvest:object{IgnisCollector.OutputCumulator}
        (unvester:string dpmf:string nonce:integer)
        (UEV_IMC)
        (with-capability (VST|C>CULL unvester dpmf nonce)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (dptf-id:string (ref-DPMF::UR_Vesting dpmf))
                    (initial-amount:decimal (ref-DPMF::UR_AccountNonceBalance dpmf nonce unvester))
                    (culled-data:list (URC_CullMetaDataAmountWithObject unvester dpmf nonce))
                    (culled-amount:decimal (at 0 culled-data))
                    (md-remint:[object{VestingV3.VST|MetaDataSchema}] (at 1 culled-data))
                    (obj-l:decimal (dec (length md-remint)))
                    (smallest:decimal (ref-DALOS::UR_UsagePrice "ignis|smallest"))
                    ;;
                    (price:decimal (/ (* obj-l smallest) 5.0))
                    (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                    (return-amount:decimal (- initial-amount culled-amount))
                    ;;
                    (ico1:object{IgnisCollector.OutputCumulator}
                        (ref-IGNIS::IC|UDC_ConstructOutputCumulator price VST|SC_NAME trigger [])
                    )
                    (ico2:object{IgnisCollector.OutputCumulator}
                        (if (= return-amount 0.0)
                            ;;1]VST|SC_NAME transfers the whole dptf back to the unvester, when there is no return amount
                            (ref-TFT::C_Transfer dptf-id VST|SC_NAME unvester initial-amount true)
                            (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                                [
                                    ;;1]Only the ready to unvest dptf is trasnfered back to unvester
                                    (ref-TFT::C_Transfer dptf-id VST|SC_NAME unvester culled-amount true)
                                    ;;2]If return amount is non zero, it is minted as a new DPMF
                                    (ref-DPMF::C_Mint dpmf VST|SC_NAME return-amount md-remint)
                                    ;;3]Together with the newly minted remainder, still vested, dpmf
                                    (ref-DPMF::C_Transfer dpmf (+ 1 nonce) VST|SC_NAME unvester return-amount true)
                                ]
                                []
                            )
                        )
                    )
                    (ico3:object{IgnisCollector.OutputCumulator}
                        (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                            [
                                ;;1]Freeze unvester account
                                (ref-DPMF::C_ToggleFreezeAccount dpmf unvester true)
                                ;;2]Wipe unvest nonce
                                (ref-DPMF::C_WipePartial dpmf unvester [nonce])
                                ;;3]Unfreeze unvester account
                                (ref-DPMF::C_ToggleFreezeAccount dpmf unvester false)
                            ]
                            []
                        )
                    )
                )
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3] [])
            )
        )
    )
    (defun C_Vest:object{IgnisCollector.OutputCumulator}
        (vester:string target-account:string dptf:string amount:decimal offset:integer duration:integer milestones:integer)
        (UEV_IMC)
        (with-capability (VST|C>VEST vester target-account dptf amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (dpmf-id:string (ref-DPTF::UR_Vesting dptf))
                    (meta-data:[object{VestingV3.VST|MetaDataSchema}] (UDC_ComposeVestingMetaData dptf amount offset duration milestones))
                    (nonce:integer (+ (ref-DPMF::UR_NoncesUsed dpmf-id) 1))
                )
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                    [
                        ;;1]VST|SC_NAME mints the DPMF Vested Token
                        (ref-DPMF::C_Mint dpmf-id VST|SC_NAME amount meta-data)
                        ;;2]Vester transfers the DPTF Token to the VST|SC_NAME if its not already there
                        (if (!= vester VST|SC_NAME)
                            (ref-TFT::C_Transfer dptf vester VST|SC_NAME amount true)
                            EOC
                        )
                        ;;3]VST|SC_NAME transfers the DPMF Vested Token to target-account
                        (ref-DPMF::C_Transfer dpmf-id nonce VST|SC_NAME target-account amount true)
                    ]
                    []
                )
            )
        )
    )
    (defun C_RepurposeVested:object{IgnisCollector.OutputCumulator}
        (dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-VESTING-MF dpmf-to-repurpose nonce repurpose-from repurpose-to)
            (XI_RepurposeMetaFungible dpmf-to-repurpose nonce repurpose-from repurpose-to)
        )
    )
    ;;  [Sleeping Token Actions]
    (defun C_Merge:object{IgnisCollector.OutputCumulator}
        (merger:string dpmf:string nonces:[integer])
        (UEV_IMC)
        (with-capability (VST|C>MERGE merger dpmf nonces)
            (XI_MergeNoncesToTarget dpmf merger merger nonces)
        )
    )
    (defun C_MergeAll:object{IgnisCollector.OutputCumulator}
        (merger:string dpmf:string)
        (UEV_IMC)
        (with-capability (VST|C>MERGE-ALL merger dpmf)
            (let
                (
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                    (nonces:[integer] (ref-DPMF::UR_AccountNonces dpmf merger))
                )
                (XI_MergeNoncesToTarget dpmf merger merger nonces)
            )
        )
    )
    (defun C_Sleep:object{IgnisCollector.OutputCumulator}
        (sleeper:string target-account:string dptf:string amount:decimal duration:integer)
        (UEV_IMC)
        (with-capability (VST|C>SLEEP sleeper target-account dptf amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (dpmf-id:string (ref-DPTF::UR_Sleeping dptf))
                    (meta-data:[object{VestingV3.VST|MetaDataSchema}] (UDC_ComposeVestingMetaData dptf amount 0 duration 1))
                    (nonce:integer (+ (ref-DPMF::UR_NoncesUsed dpmf-id) 1))
                )
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                    [
                        ;;1]VST|SC_NAME mints the DPMF Sleeping Token
                        (ref-DPMF::C_Mint dpmf-id VST|SC_NAME amount meta-data)
                        ;;2]Sleeper transfers the DPTF Token to the VST|SC_NAME if its not already there
                        (if (!= sleeper VST|SC_NAME)
                            (ref-TFT::C_Transfer dptf sleeper VST|SC_NAME amount true)
                            EOC
                        )
                        ;;3]VST|SC_NAME transfers the DPMF Sleeping Token to target-account
                        (ref-DPMF::C_Transfer dpmf-id nonce VST|SC_NAME target-account amount true)
                    ]
                    []
                )
            )
        )
    )
    (defun C_Unsleep:object{IgnisCollector.OutputCumulator}
        (unsleeper:string dpmf:string nonce:integer)
        (UEV_IMC)
        (with-capability (VST|C>UNSLEEP unsleeper dpmf nonce)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (dptf-id:string (ref-DPMF::UR_Sleeping dpmf))
                    (initial-amount:decimal (ref-DPMF::UR_AccountNonceBalance dpmf nonce unsleeper))
                )
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                    [
                        ;;1]Unsleeper transfers the initial dpmf to the VST|SC_NAME
                        (ref-DPMF::C_Transfer dpmf nonce unsleeper VST|SC_NAME initial-amount true)
                        ;;2]Which is then burned in its entirety
                        (ref-DPMF::C_Burn dpmf nonce VST|SC_NAME initial-amount)
                        ;;3]VST|SC_NAME transfers in return the initial amount of the dpmf, as the dptf counterpart
                        (ref-TFT::C_Transfer dptf-id VST|SC_NAME unsleeper initial-amount true)
                    ]
                    []
                )
            )
        )
    )
    (defun C_RepurposeSleeping:object{IgnisCollector.OutputCumulator}
        (dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-SLEEPING-MF dpmf-to-repurpose nonce repurpose-from repurpose-to)
            (XI_RepurposeMetaFungible dpmf-to-repurpose nonce repurpose-from repurpose-to)
        )
    )
    (defun C_RepurposeMerge:object{IgnisCollector.OutputCumulator}
        (dpmf-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-MERGE dpmf-to-repurpose nonces repurpose-from repurpose-to)
            (XI_MergeNoncesToTarget dpmf-to-repurpose repurpose-from repurpose-to nonces)
        )
    )
    (defun C_RepurposeMergeAll:object{IgnisCollector.OutputCumulator}
        (dpmf-to-repurpose:string repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-MERGE-ALL dpmf-to-repurpose repurpose-from repurpose-to)
            (let
                (
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                    (nonces:[integer] (ref-DPMF::UR_AccountNonces dpmf-to-repurpose repurpose-from))
                )
                (XI_MergeNoncesToTarget dpmf-to-repurpose repurpose-from repurpose-to nonces)
            )
        )
    )
    (defun C_ToggleTransferRoleSleepingDPMF:object{IgnisCollector.OutputCumulator}
        (s-dpmf:string target:string toggle:bool)
        (UEV_IMC)
        (with-capability (VST|C>TOGGLE-SLEEPING-TR s-dpmf target)
            (let
                (
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                )
                (ref-DPMF::C_ToggleTransferRole s-dpmf target toggle)
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_CreateSpecialTrueFungibleLink:object{IgnisCollector.OutputCumulator}
        (patron:string dptf:string frozen-or-reserved:bool)
        (require-capability (SECURE))
        (let
            (
                (ref-U|VST:module{UtilityVst} U|VST)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                ;;
                (dptf-name:string (ref-DPTF::UR_Name dptf))
                (dptf-ticker:string (ref-DPTF::UR_Ticker dptf))
                (dptf-decimals:integer (ref-DPTF::UR_Decimals dptf))
                (special-tf-id:[string]
                    (if frozen-or-reserved
                        (ref-U|VST::UC_FrozenID dptf-name dptf-ticker)
                        (ref-U|VST::UC_ReservedID dptf-name dptf-ticker)
                    )
                )
                (special-tf-name:string (at 0 special-tf-id))
                (special-tf-ticker:string (at 1 special-tf-id))
                (ico0:object{IgnisCollector.OutputCumulator}
                    (ref-DPTF::XB_IssueFree
                        VST|SC_NAME
                        [special-tf-name]
                        [special-tf-ticker]
                        [dptf-decimals]
                        [false] ;;<can-change-owner>
                        [false] ;;<can-upgrade>
                        [true]  ;;<can-add-special-role>
                        [true]  ;;<can-freeze>
                        [true]  ;;<can-wipe>
                        [false] ;;<can-pause>
                        [true]  ;;<iz-special>
                    )
                )
                (special-dptf:string (at 0 (at "output" ico0)))
                (kda-costs:decimal (ref-DALOS::UR_UsagePrice "dptf"))
            )
            ;;Create DPTF and Special-DPTF Account and Set Required Roles below.
            ;;For the Special DPTFs to function as intended, these roles must be kept on the VST|SC_NAME
            (ref-DPTF::C_DeployAccount dptf VST|SC_NAME)
            (let
                (
                    (ref-ATS:module{AutostakeV3} ATS)
                    ;;
                    (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                    (dptf-fer:bool (ref-DPTF::UR_AccountRoleFeeExemption dptf VST|SC_NAME))
                    ;;DPTF Roles
                    (ico1:object{IgnisCollector.OutputCumulator}
                        (if (not dptf-fer)
                            (ref-ATS::DPTF|C_ToggleFeeExemptionRole dptf VST|SC_NAME true)
                            EOC
                        )
                    )
                    ;;Special-DPTF Roles
                    (ico2:object{IgnisCollector.OutputCumulator}
                        (ref-ATS::DPTF|C_ToggleBurnRole special-dptf VST|SC_NAME true)
                        ;;Locked to VST|SC_NAME to enable the designed functionality
                    )
                    (ico3:object{IgnisCollector.OutputCumulator}
                        (ref-ATS::DPTF|C_ToggleMintRole special-dptf VST|SC_NAME true)
                        ;;Same as Burn Role, see above.
                    )
                    (ico4:object{IgnisCollector.OutputCumulator}
                        (ref-DPTF::C_ToggleTransferRole special-dptf VST|SC_NAME true)
                        ;;Can be added to or removed from external Smart Ouronet Accounts, as needed to implement Special DPTF Functionality
                        ;;Cannot be removed from VST|SC_NAME to enable designed functionality
                        ;;
                        ;;Fee-Exemption Role isnt needed to be set to VST|SC_NAME as there is no written function to add fees for Special DPTFs
                        ;;As such, transfer fees cannot be set for Special DPTFs
                    )
                    (ico5:object{IgnisCollector.OutputCumulator}
                        (ref-DPTF::XE_UpdateSpecialTrueFungible dptf special-dptf frozen-or-reserved)
                    )
                )
                (ref-DALOS::KDA|C_Collect patron kda-costs)
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico0 ico1 ico2 ico3 ico4 ico5] [special-dptf])
            )
        )
    )
    (defun XI_CreateSpecialMetaFungibleLink:object{IgnisCollector.OutputCumulator}
        (patron:string dptf:string vesting-or-sleeping:bool)
        (require-capability (SECURE))
        (let
            (
                (ref-U|VST:module{UtilityVst} U|VST)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                ;;
                (dptf-name:string (ref-DPTF::UR_Name dptf))
                (dptf-ticker:string (ref-DPTF::UR_Ticker dptf))
                (dptf-decimals:integer (ref-DPTF::UR_Decimals dptf))
                (special-mf-id:[string]
                    (if vesting-or-sleeping
                        (ref-U|VST::UC_VestingID dptf-name dptf-ticker)
                        (ref-U|VST::UC_SleepingID dptf-name dptf-ticker)
                    )
                )
                (special-mf-name:string (at 0 special-mf-id))
                (special-mf-ticker:string (at 1 special-mf-id))
                (ico0:object{IgnisCollector.OutputCumulator}
                    (ref-DPMF::XB_IssueFree
                        VST|SC_NAME
                        [special-mf-name]
                        [special-mf-ticker]
                        [dptf-decimals]
                        [false] ;;<can-change-owner>
                        [false] ;;<can-upgrade>
                        [true]  ;;<can-add-special-role>
                        [true]  ;;<can-freeze>
                        [true]  ;;<can-wipe>
                        [false] ;;<can-pause>
                        [false] ;;<can-transfer-nft-create-role>
                        [true]  ;;<iz-special>
                    )
                )
                (special-dpmf:string (at 0 (at "output" ico0)))
                (kda-costs:decimal (ref-DALOS::UR_UsagePrice "dpmf"))
            )
            ;;Create DPTF and Special-DPMF Account and Set Required Roles below.
            ;;For the Special DPTFs to function as intended, these roles must be kept on the VST|SC_NAME
            (ref-DPTF::C_DeployAccount dptf VST|SC_NAME)
            (let
                (
                    (ref-ATS:module{AutostakeV3} ATS)
                    ;;
                    (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                    (dptf-fer:bool (ref-DPTF::UR_AccountRoleFeeExemption dptf VST|SC_NAME))
                    ;;DPTF Roles
                    (ico1:object{IgnisCollector.OutputCumulator}
                        (if (not dptf-fer)
                            (ref-ATS::DPTF|C_ToggleFeeExemptionRole dptf VST|SC_NAME true)
                            EOC
                        )
                    )
                    ;;Special-DPMF Roles
                    (ico2:object{IgnisCollector.OutputCumulator}
                        (ref-ATS::DPMF|C_ToggleBurnRole special-dpmf VST|SC_NAME true)
                        ;;Same as Burn Role for Special DPTFs, see above
                    )
                    (ico3:object{IgnisCollector.OutputCumulator}
                        (ref-ATS::DPMF|C_ToggleAddQuantityRole special-dpmf VST|SC_NAME true)
                        ;;Same as Mint Role for Special DPTFs, see above
                    )
                    (ico4:object{IgnisCollector.OutputCumulator}
                        (ref-DPMF::C_ToggleTransferRole special-dpmf VST|SC_NAME true)
                        ;;Further Transfer Roles can be set to external Smart Ouronet Accounts as needed to implement Special DPTF Functionality
                        ;;Lifting the Transfer Role for the special DPMF from VST|SC_NAME, disables its functionality as Vested or Sleeping Special DPMF
                    )
                    (ico5:object{IgnisCollector.OutputCumulator}
                        (ref-DPMF::XE_UpdateSpecialMetaFungible dptf special-dpmf vesting-or-sleeping)
                    )
                )
                (ref-DALOS::KDA|C_Collect patron kda-costs)
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico0 ico1 ico2 ico3 ico4 ico5] [special-dpmf])
            )
        )
    )
    (defun XI_RepurposeTrueFungible:object{IgnisCollector.OutputCumulator}
        (dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        (require-capability (SECURE))
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                ;;
                (amount:decimal (ref-DPTF::UR_AccountSupply dptf-to-repurpose repurpose-from))
            )
            (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                [
                    ;;1]Freeze <repurpose-from> for <dptf-to-repurpose>
                    (ref-DPTF::C_ToggleFreezeAccount dptf-to-repurpose repurpose-from true)
                    ;;2]Wipe <dptf-to-repurpose> on <repurpose-from>
                    (ref-DPTF::C_Wipe dptf-to-repurpose repurpose-from)
                    ;;3]Unfreeze <repurpose-from>
                    (ref-DPTF::C_ToggleFreezeAccount dptf-to-repurpose repurpose-from false)
                    ;;4]Mint <dptf-to-repurpose> anew
                    (ref-DPTF::C_Mint dptf-to-repurpose VST|SC_NAME amount false)
                    ;;5]Transfer it to <repurpose-to>
                    (ref-TFT::C_Transfer dptf-to-repurpose VST|SC_NAME repurpose-to amount true)
                ]
                []
            )
        )
    )
    (defun XI_RepurposeMetaFungible:object{IgnisCollector.OutputCumulator}
        (dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        (require-capability (SECURE))
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                ;;
                (amount:decimal (ref-DPMF::UR_AccountNonceBalance dpmf-to-repurpose nonce repurpose-from))
                (meta-data:[object] (ref-DPMF::UR_AccountNonceMetaData dpmf-to-repurpose nonce repurpose-from))
            )
            (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                [
                    ;;1]Freeze <repurpose-from> for <dpmf-to-repurpose>
                    (ref-DPMF::C_ToggleFreezeAccount dpmf-to-repurpose repurpose-from true)
                    ;;2]WipePartial <dpmf-to-repurpose> on <repurpose-from>
                    (ref-DPMF::C_WipePartial dpmf-to-repurpose repurpose-from [nonce])
                    ;;3]Unfreeze <repurpose-from>
                    (ref-DPMF::C_ToggleFreezeAccount dpmf-to-repurpose repurpose-from false)
                    ;;4]Mint <dptf-to-repurpose> anew
                    (ref-DPMF::C_Mint dpmf-to-repurpose VST|SC_NAME amount meta-data)
                    ;;5]Transfer it to <repurpose-to>
                    (ref-DPMF::C_SingleBatchTransfer dpmf-to-repurpose (ref-DPMF::UR_NoncesUsed dpmf-to-repurpose) VST|SC_NAME repurpose-to true)
                ]
                []
            )
        )
    )
    (defun XI_MergeNoncesToTarget:object{IgnisCollector.OutputCumulator}
        (dpmf:string merger:string target:string nonces:[integer])
        (require-capability (SECURE))
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                ;;
                (dptf:string (ref-DPMF::UR_Sleeping dpmf))
                (nonces-balances:[decimal] (ref-DPMF::UR_AccountNoncesBalances dpmf nonces merger))
                (how-many:decimal (dec (length nonces)))
                (biggest:decimal (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                (price:decimal (* how-many biggest))
                (stu:[decimal] (URC_SecondsToUnlock dpmf merger nonces))
                (compute-merge-all:[decimal] (UC_MergeAll nonces-balances stu))
                (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                ;;
                (wake-amount:decimal (at 0 compute-merge-all))
                (asleep-amount:decimal (at 1 compute-merge-all))
                (sleep-time-in-seconds:integer (floor (at 2 compute-merge-all)))
                ;;
                (ico-mic:object{IgnisCollector.OutputCumulator}
                    (ref-IGNIS::IC|UDC_ConstructOutputCumulator price VST|SC_NAME trigger [])
                )
            )
            (if (= asleep-amount 0.0)
                (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                    [
                        ;;1]Freeze <merger> for <dpmf>
                        (ref-DPMF::C_ToggleFreezeAccount dpmf merger true)
                        ;;2]WipePartial <dpmf> on <merger>
                        (ref-DPMF::C_WipePartial dpmf merger nonces)
                        ;;3]Unfreeze <merger>
                        (ref-DPMF::C_ToggleFreezeAccount dpmf merger false)
                        ;;4]Retrieve the <wake-amount> to <target>
                        (ref-TFT::C_Transfer dptf VST|SC_NAME target wake-amount true)
                        ;;5]Add Merging IGNIS Costs
                        ico-mic
                    ]
                    []
                )
                (let
                    (
                        (meta-data:[object{VestingV3.VST|MetaDataSchema}]
                            (UDC_ComposeVestingMetaData dptf asleep-amount 0 sleep-time-in-seconds 1)
                        )
                        (mint-ico:object{IgnisCollector.OutputCumulator}
                            (ref-DPMF::C_Mint dpmf VST|SC_NAME asleep-amount meta-data)
                        )
                        (minted-nonce:integer (at 0 (at "output" mint-ico)))
                    )
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators
                        [
                            ;;Add minted ico
                            mint-ico
                            ;;1]Freeze <merger> for <dpmf>
                            (ref-DPMF::C_ToggleFreezeAccount dpmf merger true)
                            ;;2]WipePartial <dpmf> on <merger>
                            (ref-DPMF::C_WipePartial dpmf merger nonces)
                            ;;3]Unfreeze <merger>
                            (ref-DPMF::C_ToggleFreezeAccount dpmf merger false)
                            ;;4]Retrieve the <wake-amount> to <target> if its greater than zero
                            (if (> wake-amount 0.0)
                                (ref-TFT::C_Transfer dptf VST|SC_NAME target wake-amount true)
                                EOC
                            )
                            ;;5]Retrieve the minted <dpmf> to <target>
                            (ref-DPMF::C_SingleBatchTransfer dpmf minted-nonce VST|SC_NAME target true)
                            ;;6]Add Merging IGNIS Costs
                            ico-mic
                        ]
                        []
                    )
                )
            )
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)