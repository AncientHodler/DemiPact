;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface Vesting
    @doc "Exposes Vesting Functions"
    ;;
    (defschema VST|MetaDataSchema
        release-amount:decimal
        release-date:time
    )
    ;;
    (defun GOV|VST|SC_KDA-NAME ())
    ;;
    (defun URC_CullMetaDataAmount:decimal (client:string id:string nonce:integer))
    (defun URC_CullMetaDataObject:[object{VST|MetaDataSchema}] (client:string id:string nonce:integer))
    (defun URC_SecondsToUnlock:[decimal] (dpmf:string account:string nonces:[integer]))
    ;;
    (defun UEV_IMC ())
    (defun UEV_SpecialTrueFungibleRoles (dptf:string frozen-or-reserved:bool))
    (defun UEV_SpecialMetaFungibleRoles (dptf:string vesting-or-sleeping:bool))
    ;;
    (defun UDC_ComposeVestingMetaData:[object{VST|MetaDataSchema}] (dptf:string amount:decimal offset:integer duration:integer milestones:integer))
    ;;
    (defun C_CreateFrozenLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string))
    (defun C_CreateReservationLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string))
    (defun C_CreateVestingLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string))
    (defun C_CreateSleepingLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string))
    ;;
    ;;
    (defun C_Freeze:[object{OuronetDalos.IgnisCumulator}] (patron:string freezer:string freeze-output:string dptf:string amount:decimal))
    (defun C_RepurposeFrozen:[object{OuronetDalos.IgnisCumulator}] (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string))
    ;;
    (defun C_Reserve:[object{OuronetDalos.IgnisCumulator}] (patron:string reserver:string dptf:string amount:decimal))
    (defun C_Unreserve:[object{OuronetDalos.IgnisCumulator}] (patron:string unreserver:string r-dptf:string amount:decimal))
    (defun C_RepurposeReserved:[object{OuronetDalos.IgnisCumulator}] (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string))
    ;;
    (defun C_Unvest:[object{OuronetDalos.IgnisCumulator}] (patron:string unvester:string dpmf:string nonce:integer))
    (defun C_Vest:[object{OuronetDalos.IgnisCumulator}] (patron:string vester:string target-account:string dptf:string amount:decimal offset:integer duration:integer milestones:integer))
    (defun C_RepurposeVested:[object{OuronetDalos.IgnisCumulator}] (patron:string dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string))
    ;;
    (defun C_Merge:[object{OuronetDalos.IgnisCumulator}] (patron:string merger:string dpmf:string nonces:[integer]))
    (defun C_MergeAll:[object{OuronetDalos.IgnisCumulator}] (patron:string merger:string dpmf:string))
    (defun C_Sleep:[object{OuronetDalos.IgnisCumulator}] (patron:string sleeper:string target-account:string dptf:string amount:decimal duration:integer))
    (defun C_Unsleep:[object{OuronetDalos.IgnisCumulator}] (patron:string unsleeper:string dpmf:string nonce:integer))
    (defun C_RepurposeSleeping:[object{OuronetDalos.IgnisCumulator}] (patron:string dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string))
    (defun C_RepurposeMerge:[object{OuronetDalos.IgnisCumulator}] (patron:string dpmf-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string))
    (defun C_RepurposeMergeAll:[object{OuronetDalos.IgnisCumulator}] (patron:string dpmf-to-repurpose:string repurpose-from:string repurpose-to:string))

)
(module VST GOV
    ;;
    (implements OuronetPolicy)
    (implements Vesting)
    ;;{G1}
    (defconst GOV|MD_VST            (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_VST            (keyset-ref-guard VST|SC_KEY))
    ;;
    (defconst VST|SC_KEY            (GOV|VestingKey))
    (defconst VST|SC_NAME           (GOV|VST|SC_NAME))
    (defconst VST|SC_KDA-NAME       (GOV|VST|SC_KDA-NAME))
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
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|VestingKey ()        (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|VestingKey)))
    (defun GOV|VST|SC_NAME ()       (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|VST|SC_NAME)))
    (defun GOV|VST|SC_KDA-NAME ()   (at 0 ["k:4728327e1b4790cb5eb4c3b3c531ba1aed00e86cd9f6252bfb78f71c44822d6d"]))
    (defun VST|SetGovernor (patron:string)
        (with-capability (P|VST|CALLER)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ico:object{OuronetDalos.IgnisCumulator}
                        (ref-DALOS::C_RotateGovernor
                            patron
                            VST|SC_NAME
                            (create-capability-guard (VST|GOV))
                        )
                    )
                )
                (ref-DALOS::IGNIS|C_Collect patron patron (at "price" ico))
            )
        )
    )
    ;;
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
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::P|Info)))
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
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defun CT_EmptyIgnisCumulator ()(let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::DALOS|EmptyIgCum)))
    (defconst BAR                   (CT_Bar))
    (defconst EIC                   (CT_EmptyIgnisCumulator))
    ;;
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap VST|C>FROZEN-LINK ()
        @event
        (compose-capability (P|SECURE-CALLER))
    )
    ;;
    (defcap VST|C>RESERVATION-LINK ()
        @event
        (compose-capability (P|SECURE-CALLER))
    )
    (defcap VST|C>FREEZE (freezer:string freeze-output:string dptf:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DALOS::UEV_EnforceAccountType freezer false)
            (ref-DALOS::UEV_EnforceAccountType freeze-output false)
            (ref-DPTF::UEV_Amount dptf amount)
            (ref-DPTF::UEV_Frozen dptf true)
            (UEV_SpecialTrueFungibleRoles dptf true)
            (compose-capability (P|DT))
        )
    )
    (defcap VST|C>RESERVE (reserver:string dptf:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (iz-reservation:bool (ref-DPTF::UR_IzReservationOpen dptf))
            )
            (ref-DALOS::UEV_EnforceAccountType reserver false)
            (ref-DPTF::UEV_Amount dptf amount)
            (ref-DPTF::UEV_Reserved dptf true)
            (UEV_SpecialTrueFungibleRoles dptf false)
            (enforce iz-reservation (format "Reservation is not opened for Token {}" [dptf]))
            (compose-capability (P|DT))
        )
    )
    (defcap VST|C>UNRESERVE (unreserver:string r-dptf:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DALOS::UEV_EnforceAccountType unreserver true)
            (ref-DPTF::UEV_Amount r-dptf amount)
            (ref-DPTF::CAP_Owner r-dptf)
            (ref-DPTF::UEV_Reserved r-dptf true)
            (UEV_SpecialTrueFungibleRoles (ref-DPTF::UR_Reservation r-dptf) false)
            (compose-capability (P|DT))
        )
    )
    ;;
    (defcap VST|C>VESTING-LINK ()
        @event
        (compose-capability (P|SECURE-CALLER))
    )
    (defcap VST|C>VEST (vester:string target-account:string dptf:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DALOS::UEV_EnforceAccountType vester false)
            (ref-DALOS::UEV_EnforceAccountType target-account false)
            (ref-DPTF::CAP_Owner dptf)
            (ref-DPTF::UEV_Vesting dptf true)
            (UEV_SpecialMetaFungibleRoles dptf true)
            (compose-capability (P|DT))
        )
    )
    (defcap VST|C>CULL (unvester:string dpmf:string nonce:integer)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (culled-amount:decimal (URC_CullMetaDataAmount unvester dpmf nonce))
            )
            (enforce (> culled-amount 0.0) (format "Nonce {} cant be culled" [nonce]))
            (ref-DALOS::UEV_EnforceAccountType unvester false)
            (ref-DPMF::UEV_Vesting dpmf true)
            (UEV_SpecialMetaFungibleRoles (ref-DPMF::UR_Vesting dpmf) true)
            (compose-capability (P|DT))
        )
    )
    ;;
    (defcap VST|C>SLEEPING-LINK ()
        @event
        (compose-capability (P|SECURE-CALLER))
    )
    (defcap VST|C>SLEEP (target-account:string dptf:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DALOS::UEV_EnforceAccountType target-account false)
            (ref-DPTF::UEV_Sleeping dptf true)
            (UEV_SpecialMetaFungibleRoles dptf false)
            (compose-capability (P|DT))
        )
    )
    (defcap VST|C>UNSLEEP (unsleeper:string dpmf:string nonce:integer)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (initial-amount:decimal (ref-DPMF::UR_AccountNonceBalance dpmf nonce unsleeper))
                (dptf:string (ref-DPMF::UR_Sleeping dpmf))
                (culled-amount:decimal (URC_CullMetaDataAmount unsleeper dpmf nonce))
            )
            (ref-DALOS::UEV_EnforceAccountType unsleeper false)
            (ref-DPTF::UEV_Sleeping dptf true)
            (UEV_SpecialMetaFungibleRoles dptf false)
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
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
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
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
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
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (ref-DPMF::UEV_NoncesToAccount dpmf-to-repurpose repurpose-from nonces)
            (compose-capability (VST|X>REPURPOSE-MF dpmf-to-repurpose repurpose-from repurpose-to vesting-or-sleeping))
        )
    )
    (defcap VST|X>REPURPOSE-MF (dpmf-to-repurpose:string repurpose-from:string repurpose-to:string vesting-or-sleeping:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
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
    ;;
    ;;
    ;;{F0}
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
    ;;{F1}
    (defun URC_CullMetaDataAmountWithObject:list (client:string id:string nonce:integer)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (meta-data:[object{Vesting.VST|MetaDataSchema}] (ref-DPMF::UR_AccountNonceMetaData id nonce client))
            )
            (fold
                (lambda
                    (acc:list item:object{Vesting.VST|MetaDataSchema})
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
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (meta-data:[object{Vesting.VST|MetaDataSchema}] (ref-DPMF::UR_AccountNonceMetaData id nonce client))
                (culled-amount:decimal
                    (fold
                        (lambda
                            (acc:decimal item:object{Vesting.VST|MetaDataSchema})
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
    (defun URC_CullMetaDataObject:[object{Vesting.VST|MetaDataSchema}] (client:string id:string nonce:integer)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (meta-data:[object{Vesting.VST|MetaDataSchema}] (ref-DPMF::UR_AccountNonceMetaData id nonce client))
            )
            (fold
                (lambda
                    (acc:[object{Vesting.VST|MetaDataSchema}] item:object{Vesting.VST|MetaDataSchema})
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
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (meta-datas:[[object{VST|MetaDataSchema}]] (ref-DPMF::UR_AccountNoncesMetaDatas dpmf nonces account))
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
    ;;{F2}
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
            )
            (ref-U|G::UEV_Any (P|UR_IMP))
        )
    )
    (defun UEV_NoncesForMerging (nonces:[integer])
        (let
            (
                (l:integer (length nonces))
            )
            (enforce (>= l 2) "Merging requires at least 2 nonces")
        )
    )
    (defun UEV_SpecialTrueFungibleRoles (dptf:string frozen-or-reserved:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (special:string (if frozen-or-reserved "Frozen" "Reserved"))
                (s-dptf:string 
                    (if frozen-or-reserved
                        (ref-DPTF::UR_Frozen dptf)
                        (ref-DPTF::UR_Reservation dptf)
                    )
                )
                (vst-sc:string VST|SC_NAME)
                (t1:bool (ref-DPTF::UR_AccountRoleFeeExemption dptf vst-sc))
                (r-burn:bool (ref-DPTF::UR_AccountRoleBurn s-dptf vst-sc))
                (r-mint:bool (ref-DPTF::UR_AccountRoleMint s-dptf vst-sc))
                (r-trns:bool (ref-DPTF::UR_AccountRoleTransfer s-dptf vst-sc))
                (r-fexm:bool (ref-DPTF::UR_AccountRoleFeeExemption s-dptf vst-sc))
                (t2:bool (and (and r-burn r-mint) (and r-trns r-fexm)))
                (truth:bool (and t1 t2))
            )
            (enforce truth (format "Needed Roles for {} Functionality for the {} Id arent properly set; Special Functionality offline" [special dptf]))
        )
    )
    (defun UEV_SpecialMetaFungibleRoles (dptf:string vesting-or-sleeping:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (special:string (if vesting-or-sleeping "Vesting" "Sleeping"))
                (s-dpmf:string 
                    (if vesting-or-sleeping
                        (ref-DPTF::UR_Vesting dptf)
                        (ref-DPTF::UR_Sleeping dptf)
                    )
                )
                (vst-sc:string VST|SC_NAME)
                (t1:bool (ref-DPTF::UR_AccountRoleFeeExemption dptf vst-sc))
                (r-burn:bool (ref-DPMF::UR_AccountRoleBurn s-dpmf vst-sc))
                (r-crea:bool (ref-DPMF::UR_AccountRoleCreate s-dpmf vst-sc))
                (r-nadq:bool (ref-DPMF::UR_AccountRoleNFTAQ s-dpmf vst-sc))
                (r-trns:bool (ref-DPMF::UR_AccountRoleTransfer s-dpmf vst-sc))
                (t2:bool (and (and r-burn r-crea) (and r-nadq r-trns)))
                (truth:bool (and t1 t2))
            )
            (enforce truth (format "Needed Roles for {} Functionality for the {} Id arent properly set; Special Functionality offline" [special dptf]))
        )
    )
    ;;{F3}
    (defun UDC_ComposeVestingMetaData:[object{Vesting.VST|MetaDataSchema}] 
        (dptf:string amount:decimal offset:integer duration:integer milestones:integer)
        (let
            (
                (ref-U|VST:module{UtilityVst} U|VST)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (amount-lst:[decimal] (ref-U|VST::UC_SplitBalanceForVesting (ref-DPTF::UR_Decimals dptf) amount milestones))
                (date-lst:[time] (ref-U|VST::UC_MakeVestingDateList offset duration milestones))
                (meta-data:[object{Vesting.VST|MetaDataSchema}] (zip (lambda (x:decimal y:time) { "release-amount": x, "release-date": y }) amount-lst date-lst))
            )
            (ref-DPTF::UEV_Amount dptf amount)
            (ref-U|VST::UEV_MilestoneWithTime offset duration milestones)
            meta-data
        )
    )
    ;;{F4}
    ;;
    ;;{F5}
    ;;{F6}
    (defun C_CreateFrozenLink:object{OuronetDalos.IgnisCumulator}
        (patron:string dptf:string)
        @doc "Creates a Frozen Link, issuing a Special-DPTF as a frozen counterpart for another DPTF \
            \ A Frozen Link is immutable, and noted in the Token Properties of both DPTFs \
            \ A Special DPTF of the Frozen variety, is used for implementing the FROZEN Functionality for a DPTF Token \
            \ So called FROZEN Tokens are meant to be frozen on the account holding them, and only be used by that account, \
            \ for specific purposes only, defined by the <dptf> owner, which is also the owner of the Frozen Token. \
            \ Frozen Tokens can never be converted back to the original <dptf> Token they were created from \
            \ \
            \ Only the <dptf> owner can create Frozen Tokens to Target Accounts, \
            \ or designate other Smart Ouronet Accounts to create them \
            \ \
            \ Frozen Tokens can be used to add Swpair Liquidity, as if they were the initial <dptf> token \
            \ This can be done, when this functionality is turned on for the Swpair, and using a Frozen Token for adding Liquidity \
            \ generates a Frozen LP Token, which behaves similarly to the Frozen Token \
            \ that is, it can never be converted back to the SWPairs native LP, locking liquidity in place \
            \ Existing LPs can also be frozen, permanently locking liquidity \
            \ \
            \ VESTA will be the first Token that will be making use of this functionality"
        (UEV_IMC)
        (with-capability (VST|C>FROZEN-LINK)
            (XI_CreateSpecialTrueFungibleLink patron dptf true)
        )
    )
    (defun C_CreateReservationLink:object{OuronetDalos.IgnisCumulator}
        (patron:string dptf:string)
        @doc "Creates a Reservation Link, issuing a Special-DPTF as a reserved counterpart for another DPTF \
            \ A Reservation Link is immutable, and noted in the Token Properties of both DPTFs \
            \ A Special DPTF of the Reserved variety, is used for implementing the RESERVED Functionality for a DPTF Token \
            \ So called RESERVED Tokens are meant to be frozen on the account holding them, and only be used by that account, \
            \ for specific purposes only, defined by the <dptf> owner, which is also the owner of the Reserved Token. \
            \ Reserved Tokens can never be converted back to the original <dptf> Token they were created from \
            \ \
            \ As opposed to frozen tokens, where only the <dptf> owner can generate them or designated Ouronet Accounts, \
            \ Reserved Tokens can be generated by clients, using as input the <dptf> Token, only when reservations are open by the <dptf> owner \
            \ That is, the <dptf> owner dictates when clients can generate reserved tokens from the input <dptf>, \
            \ and as such, reserved tokens can be used for special discounts when sales are planned with the main <dptf> Token, \
            \ as if they were the main <dptf> token. \
            \ \
            \ Reserved Tokens cannot be used to add liquidty on any Swpair. \
            \ \
            \ OURO will be the first Token that will be making use of this functionality"
        (UEV_IMC)
        (with-capability (VST|C>RESERVATION-LINK)
            (XI_CreateSpecialTrueFungibleLink patron dptf false)
        )
    )
    (defun C_CreateVestingLink:object{OuronetDalos.IgnisCumulator}
        (patron:string dptf:string)
        @doc "Creates a Vesting Link, issuing a Special-DPMF as a vested counterpart for another DPTF \
            \ A Vesting Link is immutable, and noted in the Token Properties of both the DPTF and the Special DPMF \
            \ A Special DPMF of the Vested variety, is used for implementing the Vesting Functionality for a DPTF Token \
            \ The <dptf> owner has the ability to vest its <dptf> token into a vested counterpart \
            \ specifying a target account, an offset, a duration and a number of milestones as vesting parameters \
            \ \
            \ The Target account receives the vested token, and according to its input vested parameters, \
            \ can revert it back to the <dptf> counterpart, as vesting intervals expire \
            \ \
            \ Vested Tokens cannot be used to add liquidity on any Swpair \
            \ \
            \ If a Vested Counterpart is created for a Token that is a Cold-RBT in an ATS Pair, \
            \ the RT owner of that ATS Pair can <coil>|<curl> the RT Token, and subsequently <vest> the output Hot-RBT token, \
            \ thus creating an additional layer of locking, for the input <RT> token, by converting it in a Vested Hot-RBT \
            \ OURO, AURYN and ELITE-AURYN will be the first Tokens that will make use of this functionality"
        (UEV_IMC)
        (with-capability (VST|C>VESTING-LINK)
            (XI_CreateSpecialMetaFungibleLink patron dptf true)
        )
    )
    (defun C_CreateSleepingLink:object{OuronetDalos.IgnisCumulator}
        (patron:string dptf:string)
        @doc "Creates a Sleeping Link, issuing a Special-DPMF as a sleeping counterpart for another DPTF \
            \ A Sleeping Link is immutable, and noted in the Token Properties of both the DPTF and the Special DPMF \
            \ A Special DPMF of the Sleeping variety, is used for implementing the Sleeping Functionality for a DPTF Token \
            \ A Sleeping DPMF is similar to a vested Token, however it has a single period after which it can be converted \
            \ in its entirety, at once, into the initial <dptf> \
            \ As opposed to Vested DPMF Tokens, multiple Sleeping DPMF Tokens, can be unified into a single Sleeping Token \
            \ using a weigthed mean to determine the final time when it can be converted back to the initial <dptf> \
            \ \
            \ As oposed to Vested Tokens, Sleeping Tokens can be used to add Swpair Liquidity, as if they were the initial <dptf> token \
            \ This can be done, when this functionality is turned on for the Swpair, and using a Sleeping Token for adding Liquidity \
            \ generates a Sleeping LP Token, which behaves similarly to the Sleeping Token, inheriting its sleeping date, \
            \ that is, it can be converted back to the SWPairs native LP, when its sleeping interval expires \
            \ Existing LPs can also be put to sleep, locking liquidity for a given period \
            \ \
            \ VESTA will be the first Token that will be making use of this functionality"
        (UEV_IMC)
        (with-capability (VST|C>SLEEPING-LINK)
            (XI_CreateSpecialMetaFungibleLink patron dptf false)
        )
    )
    ;;Frozen Token Actions
    (defun C_Freeze:[object{OuronetDalos.IgnisCumulator}]
        (patron:string freezer:string freeze-output:string dptf:string amount:decimal)
        (UEV_IMC)
        (with-capability (VST|C>FREEZE freezer freeze-output dptf amount)
            ;;1]Freezer sends dptf to VST|SC_NAME
            ;;2]VST|SC_NAME mints F|dptf
            ;;3|VST|SC_Name sends F|dptf to freeze-output
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (vst-sc:string VST|SC_NAME)
                    (f-dptf:string (ref-DPTF::UR_Frozen dptf))
                )
                [
                    (ref-TFT::XB_FeelesTransfer patron dptf freezer vst-sc amount true)
                    (ref-DPTF::C_Mint patron f-dptf vst-sc amount false)
                    (ref-TFT::XB_FeelesTransfer patron f-dptf vst-sc freeze-output amount true)
                ]
            )
        )
    )
    (defun C_RepurposeFrozen:[object{OuronetDalos.IgnisCumulator}]
        (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-FROZEN-TF dptf-to-repurpose repurpose-from repurpose-to)
            (XI_RepurposeTrueFungible patron dptf-to-repurpose repurpose-from repurpose-to)
        )
    )
    ;;Reserve Token Actions
    (defun C_Reserve:[object{OuronetDalos.IgnisCumulator}]
        (patron:string reserver:string dptf:string amount:decimal)
        (UEV_IMC)
        (with-capability (VST|C>RESERVE reserver dptf amount)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (vst-sc:string VST|SC_NAME)
                    (r-dptf:string (ref-DPTF::UR_Reservation dptf))
                    
                )
                [
                    ;;1]Reserver sends dptf to VST|SC_NAME
                    (ref-TFT::XB_FeelesTransfer patron dptf reserver vst-sc amount true) 
                    ;;2]VST|SC_NAME mint R|dptf
                    (ref-DPTF::C_Mint patron r-dptf vst-sc amount false)
                    ;;3]VST|SC_NAME sends R|dptf to reserver
                    (ref-TFT::XB_FeelesTransfer patron r-dptf vst-sc reserver amount true)
                ]
            )
        )
    )
    (defun C_Unreserve:[object{OuronetDalos.IgnisCumulator}]
        (patron:string unreserver:string r-dptf:string amount:decimal)
        (UEV_IMC)
        (with-capability (VST|C>UNRESERVE unreserver r-dptf amount)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (vst-sc:string VST|SC_NAME)
                    (dptf:string (ref-DPTF::UR_Reservation r-dptf))
                )
                [
                    ;;1]Unreserver sends R|dptf to VST|SC_NAME
                    (ref-TFT::XB_FeelesTransfer patron r-dptf unreserver vst-sc amount true)
                    ;;2]VST|SC_NAME burns R|dptf
                    (ref-DPTF::C_Burn patron r-dptf vst-sc amount)
                    ;;3]VST|SC_NAME sends dptf back to unreserver
                    (ref-TFT::XB_FeelesTransfer patron dptf vst-sc unreserver amount true)
                ]
            )
        )
    )
    (defun C_RepurposeReserved:[object{OuronetDalos.IgnisCumulator}]
        (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-RESERVED-TF dptf-to-repurpose repurpose-from repurpose-to)
            (XI_RepurposeTrueFungible patron dptf-to-repurpose repurpose-from repurpose-to)
        )
    )
    ;;Vesting Token Actions
    (defun C_Unvest:[object{OuronetDalos.IgnisCumulator}]
        (patron:string unvester:string dpmf:string nonce:integer)
        (UEV_IMC)
        (with-capability (VST|C>CULL unvester dpmf nonce)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (vst-sc:string VST|SC_NAME)
                    (dptf-id:string (ref-DPMF::UR_Vesting dpmf))
                    (initial-amount:decimal (ref-DPMF::UR_AccountNonceBalance dpmf nonce unvester))
                    (culled-data:list (URC_CullMetaDataAmountWithObject unvester dpmf nonce))
                    (culled-amount:decimal (at 0 culled-data))
                    (md-remint:[object{Vesting.VST|MetaDataSchema}] (at 1 culled-data))
                    (obj-l:decimal (dec (length md-remint)))
                    (smallest:decimal (ref-DALOS::UR_UsagePrice "ignis|smallest"))
                    (price:decimal (/ (* obj-l smallest) 5.0))
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                    (return-amount:decimal (- initial-amount culled-amount))
                    (ico0:object{OuronetDalos.IgnisCumulator}
                        (ref-DALOS::UDC_Cumulator price trigger [])
                    )
                    (ico1:[object{OuronetDalos.IgnisCumulator}]
                        (if (= return-amount 0.0)
                            [
                                ;;1]VST|SC_NAME transfers the whole dptf back to the unvester, when there is no return amount
                                (ref-TFT::XB_FeelesTransfer patron dptf-id vst-sc unvester initial-amount true)
                            ]
                            [
                                ;;1]Only the ready to unvest dptf is trasnfered back to unvester
                                (ref-TFT::XB_FeelesTransfer patron dptf-id vst-sc unvester culled-amount true)
                                ;;2]If return amount is non zero, it is minted as a new DPMF
                                (ref-DPMF::C_Mint patron dpmf vst-sc return-amount md-remint)
                                ;;3]Together with the newly minted remainder, still vested, dpmf
                                (ref-DPMF::C_Transfer patron dpmf (+ 1 nonce) vst-sc unvester return-amount true)
                            ]
                        )
                    )
                    (ico2:[object{OuronetDalos.IgnisCumulator}]
                        [
                            ;;1]Freeze unvester account
                            (ref-DPMF::C_ToggleFreezeAccount patron dpmf unvester true)
                            ;;2]Wipe unvest nonce
                            (ref-DPMF::C_WipePartial patron dpmf unvester [nonce])
                            ;;3]Unfreeze unvester account
                            (ref-DPMF::C_ToggleFreezeAccount patron dpmf unvester false)
                        ]
                    )
                    

                )
                (+ [ico0] (+ ico1 ico2))
            )
        )
    )
    (defun C_Vest:[object{OuronetDalos.IgnisCumulator}]
        (patron:string vester:string target-account:string dptf:string amount:decimal offset:integer duration:integer milestones:integer)
        (UEV_IMC)
        (with-capability (VST|C>VEST vester target-account dptf)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (vst-sc:string VST|SC_NAME)
                    (dpmf-id:string (ref-DPTF::UR_Vesting dptf))
                    (meta-data:[object{Vesting.VST|MetaDataSchema}] (UDC_ComposeVestingMetaData dptf amount offset duration milestones))
                    (nonce:integer (+ (ref-DPMF::UR_NoncesUsed dpmf-id) 1))
                )
                [
                    ;;1]VST|SC_NAME mints the DPMF Vested Token
                    (ref-DPMF::C_Mint patron dpmf-id vst-sc amount meta-data)
                    ;;2]Vester transfers the DPTF Token to the VST|SC_NAME
                    (ref-TFT::XB_FeelesTransfer patron dptf vester vst-sc amount true)
                    ;;3]VST|SC_NAME transfers the DPMF Vested Token to target-account
                    (ref-DPMF::C_Transfer patron dpmf-id nonce vst-sc target-account amount true)
                ]
            )
        )
    )
    (defun C_RepurposeVested:[object{OuronetDalos.IgnisCumulator}]
        (patron:string dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-VESTING-MF dpmf-to-repurpose nonce repurpose-from repurpose-to)
            (XI_RepurposeMetaFungible patron dpmf-to-repurpose nonce repurpose-from repurpose-to)
        )
    )
    ;;Sleeping Token Actions
    (defun C_Merge:[object{OuronetDalos.IgnisCumulator}]
        (patron:string merger:string dpmf:string nonces:[integer])
        (UEV_IMC)
        (with-capability (VST|C>MERGE merger dpmf nonces)
            (XI_MergeNoncesToTarget patron dpmf merger merger nonces)
        )
    )
    (defun C_MergeAll:[object{OuronetDalos.IgnisCumulator}]
        (patron:string merger:string dpmf:string)
        (UEV_IMC)
        (with-capability (VST|C>MERGE-ALL merger dpmf)
            (let
                (
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (nonces:[integer] (ref-DPMF::UR_AccountNonces dpmf merger))
                )
                (XI_MergeNoncesToTarget patron dpmf merger merger nonces)
            )
        )
    )
    (defun C_Sleep:[object{OuronetDalos.IgnisCumulator}]
        (patron:string sleeper:string target-account:string dptf:string amount:decimal duration:integer)
        (UEV_IMC)
        (with-capability (VST|C>SLEEP target-account dptf)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (vst-sc:string VST|SC_NAME)
                    (dpmf-id:string (ref-DPTF::UR_Sleeping dptf))
                    (meta-data:[object{Vesting.VST|MetaDataSchema}] (UDC_ComposeVestingMetaData dptf amount 0 duration 1))
                    (nonce:integer (+ (ref-DPMF::UR_NoncesUsed dpmf-id) 1))
                )
                [
                    ;;1]VST|SC_NAME mints the DPMF Sleeping Token
                    (ref-DPMF::C_Mint patron dpmf-id vst-sc amount meta-data)
                    ;;2]Sleeper transfers the DPTF Token to the VST|SC_NAME
                    (ref-TFT::XB_FeelesTransfer patron dptf sleeper vst-sc amount true)
                    ;;3]VST|SC_NAME transfers the DPMF Sleeping Token to target-account
                    (ref-DPMF::C_Transfer patron dpmf-id nonce vst-sc target-account amount true)
                ]
            )
        )
    )
    (defun C_Unsleep:[object{OuronetDalos.IgnisCumulator}]
        (patron:string unsleeper:string dpmf:string nonce:integer)
        (UEV_IMC)
        (with-capability (VST|C>UNSLEEP unsleeper dpmf nonce)
            (let
                (
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (vst-sc:string VST|SC_NAME)
                    (dptf-id:string (ref-DPMF::UR_Sleeping dpmf))
                    (initial-amount:decimal (ref-DPMF::UR_AccountNonceBalance dpmf nonce unsleeper))
                )
                [
                    ;;1]Unsleeper transfers the initial dpmf to the VST|SC_NAME
                    (ref-DPMF::C_Transfer patron dpmf nonce unsleeper vst-sc initial-amount true)
                    ;;2]Which is then burned in its entirety
                    (ref-DPMF::C_Burn patron dpmf nonce vst-sc initial-amount)
                    ;;3]VST|SC_NAME transfers in return the initial amount of the dpmf, as the dptf counterpart
                    (ref-TFT::XB_FeelesTransfer patron dptf-id vst-sc unsleeper initial-amount true)
                ]
            )
        )
    )
    (defun C_RepurposeSleeping:[object{OuronetDalos.IgnisCumulator}]
        (patron:string dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-SLEEPING-MF dpmf-to-repurpose nonce repurpose-from repurpose-to)
            (XI_RepurposeMetaFungible patron dpmf-to-repurpose nonce repurpose-from repurpose-to)
        )
    )
    (defun C_RepurposeMerge:[object{OuronetDalos.IgnisCumulator}]
        (patron:string dpmf-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-MERGE dpmf-to-repurpose nonces repurpose-from repurpose-to)
            (XI_MergeNoncesToTarget patron dpmf-to-repurpose repurpose-from repurpose-to nonces)
        )
    )
    (defun C_RepurposeMergeAll:[object{OuronetDalos.IgnisCumulator}]
        (patron:string dpmf-to-repurpose:string repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-MERGE-ALL dpmf-to-repurpose repurpose-from repurpose-to)
            (let
                (
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (nonces:[integer] (ref-DPMF::UR_AccountNonces dpmf-to-repurpose repurpose-from))
                )
                (XI_MergeNoncesToTarget patron dpmf-to-repurpose repurpose-from repurpose-to nonces)
            )
        )
    )
    ;;{F7}
    (defun XI_CreateSpecialTrueFungibleLink:object{OuronetDalos.IgnisCumulator} 
        (patron:string dptf:string frozen-or-reserved:bool)
        (require-capability (SECURE))
        (let
            (
                (ref-U|VST:module{UtilityVst} U|VST)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (vst-sc:string VST|SC_NAME)
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
                (ico0:object{OuronetDalos.IgnisCumulator}
                    (ref-DPTF::XB_IssueFree
                        patron
                        vst-sc
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
            (ref-DPTF::C_DeployAccount dptf vst-sc)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                    (dptf-fer:bool (ref-DPTF::UR_AccountRoleFeeExemption dptf vst-sc))
                    ;;DPTF Roles
                    (ico1:[object{OuronetDalos.IgnisCumulator}]
                        (if (not dptf-fer)
                            (ref-ATS::DPTF|C_ToggleFeeExemptionRole patron dptf vst-sc true)
                            [EIC]
                        )
                    )
                    ;;Special-DPTF Roles
                    (ico2:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPTF|C_ToggleBurnRole patron special-dptf vst-sc true)
                        ;;Even if the Burn Role can be given to external Smart Ouronet Accounts, 
                        ;;it is highly recomended to keep the Burn Role only on the VST|SC_NAME, such that only this Account is allowed to burn the Special-DPTF
                        ;;as was intended by its design, that is, only the the VST|SC_NAME to be allowed to mint burn the Special Token.
                        ;;Giving other Smart Dalos Accounts the Burn Role for a Special Token, will raise a Red Flag for the Parent DPTF Token
                    )
                    (ico3:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPTF|C_ToggleMintRole patron special-dptf vst-sc true)
                        ;;Same as Burn Role, see above.
                    )
                    (ico4:object{OuronetDalos.IgnisCumulator}
                        (ref-DPTF::C_ToggleTransferRole patron special-dptf vst-sc true)
                        ;;Further Transfer Roles can be set to external Smart Ouronet Accounts as needed to implement Special DPTF Functionality
                        ;;Lifting the Transfer Role for the special DPTF from VST|SC_NAME, disables its functionality as Frozen or Reserved Special DPTF
                    )
                    (ico5:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPTF|C_ToggleFeeExemptionRole patron special-dptf vst-sc true)
                        ;;Further Fee Exemption Roles can be set to external Smart Ouronet Accounts as needed to implement Special DPTF Functionality
                    )
                    (ico6:object{OuronetDalos.IgnisCumulator}
                        (ref-DPTF::XE_UpdateSpecialTrueFungible dptf special-dptf frozen-or-reserved)
                    )
                )
                (ref-DALOS::KDA|C_Collect patron kda-costs)
                (ref-DALOS::UDC_CompressICO (fold (+) [] [[ico0] ico1 ico2 ico3 [ico4] ico5 [ico6]]) [special-dptf])
            )
        )
    )
    (defun XI_CreateSpecialMetaFungibleLink:object{OuronetDalos.IgnisCumulator} 
        (patron:string dptf:string vesting-or-sleeping:bool)
        (require-capability (SECURE))
        (let
            (
                (ref-U|VST:module{UtilityVst} U|VST)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (vst-sc:string VST|SC_NAME)
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
                (ico0:object{OuronetDalos.IgnisCumulator}
                    (ref-DPMF::XB_IssueFree
                        patron
                        vst-sc
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
            (ref-DPTF::C_DeployAccount dptf vst-sc)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                    (dptf-fer:bool (ref-DPTF::UR_AccountRoleFeeExemption dptf vst-sc))
                    ;;DPTF Roles
                    (ico1:[object{OuronetDalos.IgnisCumulator}]
                        (if (not dptf-fer)
                            (ref-ATS::DPTF|C_ToggleFeeExemptionRole patron dptf vst-sc true)
                            [EIC]
                        )
                    )
                    ;;Special-DPMF Roles
                    (ico2:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPMF|C_ToggleBurnRole patron special-dpmf vst-sc true)
                        ;;Same as Burn Role for Special DPTFs, see above
                    )
                    (ico3:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPMF|C_ToggleAddQuantityRole patron special-dpmf vst-sc true)
                        ;;Same as Mint Role for Special DPTFs, see above
                    )
                    (ico4:object{OuronetDalos.IgnisCumulator}
                        (ref-DPMF::C_ToggleTransferRole patron special-dpmf vst-sc true)
                        ;;Further Transfer Roles can be set to external Smart Ouronet Accounts as needed to implement Special DPTF Functionality
                        ;;Lifting the Transfer Role for the special DPMF from VST|SC_NAME, disables its functionality as Vested or Sleeping Special DPMF
                    )
                    (ico5:object{OuronetDalos.IgnisCumulator}
                        (ref-DPMF::XE_UpdateSpecialMetaFungible dptf special-dpmf vesting-or-sleeping)
                    )
                )
                (ref-DALOS::KDA|C_Collect patron kda-costs)
                (ref-DALOS::UDC_CompressICO (fold (+) [] [[ico0] ico1 ico2 ico3 [ico4] [ico5]]) [special-dpmf])
            )
        )
    )
    (defun XI_RepurposeTrueFungible:[object{OuronetDalos.IgnisCumulator}]
        (patron:string dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        (require-capability (SECURE))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-TFT:module{TrueFungibleTransfer} TFT)
                (amount:decimal (ref-DPTF::UR_AccountSupply dptf-to-repurpose repurpose-from))
                (vst-sc:string VST|SC_NAME)
            )
            [
                ;;1]Freeze <repurpose-from> for <dptf-to-repurpose>
                (ref-DPTF::C_ToggleFreezeAccount patron dptf-to-repurpose repurpose-from true)
                ;;2]Wipe <dptf-to-repurpose> on <repurpose-from>
                (ref-DPTF::C_Wipe patron dptf-to-repurpose repurpose-from)
                ;;3]Unfreeze <repurpose-from>
                (ref-DPTF::C_ToggleFreezeAccount patron dptf-to-repurpose repurpose-from false)
                ;;4]Mint <dptf-to-repurpose> anew
                (ref-DPTF::C_Mint patron dptf-to-repurpose vst-sc amount false)
                ;;5]Transfer it to <repurpose-to>
                (ref-TFT::XB_FeelesTransfer patron dptf-to-repurpose vst-sc repurpose-to amount true)
            ]
        )
    )
    (defun XI_RepurposeMetaFungible:[object{OuronetDalos.IgnisCumulator}]
        (patron:string dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        (require-capability (SECURE))
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (amount:decimal (ref-DPMF::UR_AccountNonceBalance dpmf-to-repurpose nonce repurpose-from))
                (meta-data:[object] (ref-DPMF::UR_AccountNonceMetaData dpmf-to-repurpose nonce repurpose-from))
                (vst-sc:string VST|SC_NAME)
            )
            [
                ;;1]Freeze <repurpose-from> for <dpmf-to-repurpose>
                (ref-DPMF::C_ToggleFreezeAccount patron dpmf-to-repurpose repurpose-from true)
                ;;2]WipePartial <dpmf-to-repurpose> on <repurpose-from>
                (ref-DPMF::C_WipePartial patron dpmf-to-repurpose repurpose-from [nonce])
                ;;3]Unfreeze <repurpose-from>
                (ref-DPMF::C_ToggleFreezeAccount patron dpmf-to-repurpose repurpose-from false)
                ;;4]Mint <dptf-to-repurpose> anew
                (ref-DPMF::C_Mint patron dpmf-to-repurpose vst-sc amount meta-data)
                ;;5]Transfer it to <repurpose-to>
                (ref-DPMF::C_SingleBatchTransfer patron dpmf-to-repurpose (ref-DPMF::UR_NoncesUsed dpmf-to-repurpose) vst-sc repurpose-to true)
            ]
        )
    )
    (defun XI_MergeNoncesToTarget:[object{OuronetDalos.IgnisCumulator}]
        (patron:string dpmf:string merger:string target:string nonces:[integer])
        (require-capability (SECURE))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (ref-TFT:module{TrueFungibleTransfer} TFT)
                (dptf:string (ref-DPMF::UR_Sleeping dpmf))
                (nonces-balances:[decimal] (ref-DPMF::UR_AccountNoncesBalances dpmf nonces merger))
                (how-many:decimal (dec (length nonces)))
                (biggest:decimal (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                (price:decimal (* how-many biggest))
                (stu:[decimal] (URC_SecondsToUnlock dpmf merger nonces))
                (compute-merge-all:[decimal] (UC_MergeAll nonces-balances stu))
                (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                ;;
                (wake-amount:decimal (at 0 compute-merge-all))
                (asleep-amount:decimal (at 1 compute-merge-all))
                (sleep-time-in-seconds:integer (floor (at 2 compute-merge-all)))
            )
            (if (= asleep-amount 0.0)
                [
                    ;;1]Freeze <merger> for <dpmf>
                    (ref-DPMF::C_ToggleFreezeAccount patron dpmf merger true)
                    ;;2]WipePartial <dpmf> on <merger>
                    (ref-DPMF::C_WipePartial patron dpmf merger nonces)
                    ;;3]Unfreeze <merger>
                    (ref-DPMF::C_ToggleFreezeAccount patron dpmf merger false)
                    ;;4]Retrieve the <wake-amount> to <target>
                    (ref-TFT::XB_FeelesTransfer patron dptf VST|SC_NAME target wake-amount true)
                    ;;5]Add Merging IGNIS Costs
                    (ref-DALOS::UDC_Cumulator price trigger [])
                ]
                (let
                    (
                        (meta-data:[object{Vesting.VST|MetaDataSchema}] 
                            (UDC_ComposeVestingMetaData dptf asleep-amount 0 sleep-time-in-seconds 1)
                        )
                        (mint-ico:object{OuronetDalos.IgnisCumulator}
                            (ref-DPMF::C_Mint patron dpmf VST|SC_NAME asleep-amount meta-data)
                        )
                        (minted-nonce:integer (at 0 (at "output" mint-ico)))
                    )
                    [
                        ;;Add minted ico
                        mint-ico
                        ;;1]Freeze <merger> for <dpmf>
                        (ref-DPMF::C_ToggleFreezeAccount patron dpmf merger true)
                        ;;2]WipePartial <dpmf> on <merger>
                        (ref-DPMF::C_WipePartial patron dpmf merger nonces)
                        ;;3]Unfreeze <merger>
                        (ref-DPMF::C_ToggleFreezeAccount patron dpmf merger false)
                        ;;4]Retrieve the <wake-amount> to <target> if its greater than zero
                        (if (> wake-amount 0.0)
                            (ref-TFT::XB_FeelesTransfer patron dptf VST|SC_NAME target wake-amount true)
                            EIC
                        )
                        ;;5]Retrieve the minted <dpmf> to <target>
                        (ref-DPMF::C_SingleBatchTransfer patron dpmf minted-nonce VST|SC_NAME target true)
                        ;;6]Add Merging IGNIS Costs
                        (ref-DALOS::UDC_Cumulator price trigger [])
                    ]
                )
            )
        )
    )
)

(create-table P|T)
(create-table P|MT)