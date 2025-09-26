;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module VST GOV
    ;;
    (implements OuronetPolicy)
    (implements VestingV5)
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
    (defcap P|VST|REMOTE-GOV ()
        true
    )
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|VestingKey ()        (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|VestingKey)))
    (defun GOV|VST|SC_NAME ()       (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|VST|SC_NAME)))
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
    (defcap P|TT ()
        (compose-capability (VST|GOV))
        (compose-capability (P|VST|CALLER))
        (compose-capability (SECURE))
        (compose-capability (P|VST|REMOTE-GOV))
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
                (ref-P|DPOF:module{OuronetPolicy} DPOF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|ATSU:module{OuronetPolicy} ATSU)
                (mg:guard (create-capability-guard (P|VST|CALLER)))
            )
            (ref-P|ATS::P|A_Add
                "VST|RemoteAtsGov"
                (create-capability-guard (P|VST|REMOTE-GOV))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|DPOF::P|A_AddIMP mg)
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
    (defun CT_EmptyCumulator ()     (let ((ref-IGNIS:module{IgnisCollectorV2} IGNIS)) (ref-IGNIS::DALOS|EmptyOutputCumulatorV2)))
    (defconst BAR                   (CT_Bar))
    (defconst EOC                   (CT_EmptyCumulator))
    (defconst ATS|SC_NAME           (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|ATS|SC_NAME)))
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
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
            )
            (ref-DALOS::UEV_EnforceAccountType freeze-output false)
            (ref-DPTF::UEV_Frozen dptf true)
            (compose-capability (P|TT))
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
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (iz-reservation:bool (ref-DPTF::UR_IzReservationOpen dptf))
            )
            (ref-DALOS::UEV_EnforceAccountType reserver false)
            (ref-DPTF::UEV_Reserved dptf true)
            (enforce iz-reservation (format "Reservation is not opened for Token {}" [dptf]))
            (compose-capability (P|TT))
        )
    )
    (defcap VST|C>UNRESERVE (unreserver:string r-dptf:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (dptf:string (ref-DPTF::UR_Reservation r-dptf))
            )
            (ref-DALOS::UEV_EnforceAccountType unreserver true)
            (ref-DPTF::CAP_Owner dptf)
            (ref-DPTF::UEV_Reserved r-dptf true)
            (compose-capability (P|TT))
        )
    )
    ;;
    (defcap VST|C>VESTING-LINK (dptf:string)
        @event
        (compose-capability (VST|C>LINK dptf))
    )
    (defcap VST|C>VEST (vester:string target-account:string dptf:string amount:decimal offset:integer duration:integer milestones:integer)
        @event
        (let
            (
                (ref-U|VST:module{UtilityVstV2} U|VST)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
            )
            (ref-U|VST::UEV_MilestoneWithTime offset duration milestones 788400000)
            (ref-DALOS::UEV_EnforceAccountType vester false)
            (ref-DALOS::UEV_EnforceAccountType target-account false)
            (ref-DPTF::CAP_Owner dptf)
            (ref-DPTF::UEV_Vesting dptf true)
            (compose-capability (P|TT))
        )
    )
    (defcap VST|C>CULL (unvester:string dpof:string nonce:integer culled-amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
            )
            (enforce (> culled-amount 0.0) (format "Nonce {} cant be culled" [nonce]))
            (ref-DALOS::UEV_EnforceAccountType unvester false)
            (ref-DPOF::UEV_Vesting dpof true)
            (compose-capability (P|TT))
        )
    )
    ;;
    (defcap VST|C>SLEEPING-LINK (dptf:string)
        @event
        (compose-capability (VST|C>LINK dptf))
    )
    (defcap VST|C>SLEEP (sleeper:string target-account:string dptf:string amount:decimal duration:integer)
        @event
        (let
            (
                (ref-U|VST:module{UtilityVstV2} U|VST)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
            )
            ;;Limit <Sleep> to 25 Years
            (ref-U|VST::UEV_MilestoneWithTime 0 duration 1 788400000)
            (ref-DALOS::UEV_EnforceAccountType target-account false)
            (ref-DPTF::UEV_Sleeping dptf true)
            (compose-capability (P|TT))
        )
    )
    (defcap VST|C>UNSLEEP (unsleeper:string dpof:string nonce:integer nonce-supply:decimal culled-amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                ;;
                (dptf:string (ref-DPOF::UR_Sleeping dpof))
            )
            (ref-DALOS::UEV_EnforceAccountType unsleeper false)
            (ref-DPTF::UEV_Sleeping dptf true)
            (enforce 
                (= nonce-supply culled-amount) 
                (format "{} Nonce {} cannot be unsleeped yet" [dpof nonce])
            )
            (compose-capability (P|TT))
        )
    )
    (defcap VST|C>MERGE (merger:string dpof:string nonces:[integer])
        @event
        (UEV_NoncesForMerging nonces)
        (compose-capability (VST|X>MERGE merger dpof))
    )
    (defcap VST|C>SLUMBER (merger:string dpof:string nonces:[integer])
        @event
        (UEV_NoncesForMerging nonces)
        (compose-capability (VST|X>MERGE merger dpof))
    )
    (defcap VST|X>MERGE (merger:string dpof:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership merger)
            (ref-DALOS::UEV_EnforceAccountType merger false)
            (compose-capability (P|TT))
        )
    )
    (defcap VST|C>HIBERNATE (hibernator:string target-account:string dptf:string amount:decimal dayz:integer)
        @event
        (let
            (
                (ref-U|VST:module{UtilityVstV2} U|VST)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
            )
            (ref-DALOS::UEV_EnforceAccountType target-account false)
            (ref-DPTF::UEV_Hibernation dptf true)
            (enforce
                (and (>= dayz 1) (<= dayz 36500))
                "Between 1 Day and 100 years is allowed for Hibernation"
            )
            (compose-capability (P|TT))
        )
    )
    (defcap VST|C>AWAKE (awaker:string dpof:string nonce:integer)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
            )
            (ref-DALOS::UEV_EnforceAccountType awaker false)
            (ref-DPOF::UEV_Hibernation dpof true)
            (compose-capability (P|TT))
        )
    )
    ;;
    (defcap VST|C>REPURPOSE-FROZEN-TF (dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        @event
        (compose-capability (VST|C>REPURPOSE-TRUE-FUNGIBLE dptf-to-repurpose repurpose-from repurpose-to 1))
    )
    (defcap VST|C>REPURPOSE-RESERVED-TF (dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        @event
        (compose-capability (VST|C>REPURPOSE-TRUE-FUNGIBLE dptf-to-repurpose repurpose-from repurpose-to 2))
    )
    (defcap VST|C>REPURPOSE-VESTING-MF (dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        @event
        (compose-capability (VST|C>REPURPOSE-ORTO-FUNGIBLE dpof-to-repurpose [nonce] repurpose-from repurpose-to 1))
    )
    (defcap VST|C>REPURPOSE-SLEEPING-MF (dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        @event
        (compose-capability (VST|C>REPURPOSE-ORTO-FUNGIBLE dpof-to-repurpose [nonce] repurpose-from repurpose-to 2))
    )
    (defcap VST|C>REPURPOSE-HIBERNATING-MF (dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        @event
        (compose-capability (VST|C>REPURPOSE-ORTO-FUNGIBLE dpof-to-repurpose [nonce] repurpose-from repurpose-to 3))
    )
    ;;
    (defcap VST|C>REPURPOSE-MERGE (dpof-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string)
        @event
        (UEV_NoncesForMerging nonces)
        (compose-capability (VST|C>REPURPOSE-ORTO-FUNGIBLE dpof-to-repurpose nonces repurpose-from repurpose-to 2))
    )
    (defcap VST|C>REPURPOSE-SLUMBER (dpof-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string)
        @event
        (UEV_NoncesForMerging nonces)
        (compose-capability (VST|C>REPURPOSE-ORTO-FUNGIBLE dpof-to-repurpose nonces repurpose-from repurpose-to 3))
    )
    ;;
    (defcap VST|C>REPURPOSE-TRUE-FUNGIBLE (dptf-to-repurpose:string repurpose-from:string repurpose-to:string fr-tag:integer)
        (enforce (contains fr-tag [1 2]) "Invalid Frozen|Reserve Tag")
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (dptf:string
                    (cond
                        ((= fr-tag 1) (ref-DPTF::UR_Frozen dptf-to-repurpose))
                        ((= fr-tag 2) (ref-DPTF::UR_Reservation dptf-to-repurpose))
                        BAR
                    )
                )
            )
            (ref-DALOS::UEV_SenderWithReceiver repurpose-from repurpose-to)
            (ref-DALOS::UEV_EnforceAccountType repurpose-to false)
            (ref-DPTF::CAP_Owner dptf)
            (compose-capability (P|TT))
        )
    )
    (defcap VST|C>REPURPOSE-ORTO-FUNGIBLE (dpof-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string vzh-tag:integer)
        (let
            (
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
            )
            (ref-DPOF::UEV_NoncesToAccount dpof-to-repurpose repurpose-from nonces)
            (compose-capability (VST|X>REPURPOSE-ORTO-FUNGIBLE dpof-to-repurpose repurpose-from repurpose-to vzh-tag))
        )
    )
    (defcap VST|X>REPURPOSE-ORTO-FUNGIBLE (dpof-to-repurpose:string repurpose-from:string repurpose-to:string vzh-tag:integer)
        (enforce (contains vzh-tag [1 2 3]) "Invalid Vesting|Sleeping|Hibernation Tag")
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                (dptf:string
                    (cond
                        ((= vzh-tag 1) (ref-DPOF::UR_Vesting dpof-to-repurpose))
                        ((= vzh-tag 2) (ref-DPOF::UR_Sleeping dpof-to-repurpose))
                        ((= vzh-tag 3) (ref-DPOF::UR_Hibernation dpof-to-repurpose))
                        BAR
                    )
                )
            )
            (ref-DALOS::UEV_SenderWithReceiver repurpose-from repurpose-to)
            (ref-DALOS::UEV_EnforceAccountType repurpose-to false)
            (ref-DPTF::CAP_Owner dptf)
            (compose-capability (P|TT))
        )
    )
    ;;
    ;;
    (defcap VST|C>TOGGLE-FROZEN-TF-TR (s-dptf:string target:string)
        @event
        (compose-capability (VST|X>TOGGLE-SPECIAL-TF-TR s-dptf target))
    )
    (defcap VST|C>TOGGLE-RESERVED-TF-TR (s-dptf:string target:string)
        @event
        (compose-capability (VST|X>TOGGLE-SPECIAL-TF-TR s-dptf target))
    )
    (defcap VST|X>TOGGLE-SPECIAL-TF-TR (s-dptf:string target:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
            )
            (ref-DPTF::UEV_ParentOwnership s-dptf)
            (compose-capability (P|TT))
        )
    )
    ;;
    (defcap VST|C>TOGGLE-SLEEPING-OF-TR (s-dpof:string target:string)
        @event
        (compose-capability (VST|X>TOGGLE-SPECIAL-OF-TR s-dpof target))
    )
    (defcap VST|C>TOGGLE-HIBERNATING-OF-TR (s-dpof:string target:string)
        @event
        (compose-capability (VST|X>TOGGLE-SPECIAL-OF-TR s-dpof target))
    )

    (defcap VST|X>TOGGLE-SPECIAL-OF-TR (s-dpof:string target:string)
        (let
            (
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
            )
            (ref-DPOF::UEV_ParentOwnership s-dpof)
            (compose-capability (P|TT))
        )
    )
    ;;
    (defcap VST|C>LINK (dptf:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
            )
            (ref-DPTF::CAP_Owner dptf)
        )
        (compose-capability (P|TT))
    )
    ;;
    (defcap ATSU|C>CONSTRICT (ats:string coil-token:string)
        @event
        (let
            (
                (ref-ATS:module{AutostakeV5} ATS)
                (h:bool (ref-ATS::UR_Hibernate ats))
            )
            (ref-ATS::UEV_RewardTokenExistance ats coil-token true)
            (enforce h (format "Cannot Constrict when {} has Hibernation turned of" [ats]))
            (compose-capability (P|TT))
        )
    )
    (defcap ATSU|C>BRUMATE (ats1:string ats2:string curl-token:string)
        @event
        (let
            (
                (ref-ATS:module{AutostakeV5} ATS)
                (h1:bool (ref-ATS::UR_Hibernate ats1))
                (h2:bool (ref-ATS::UR_Hibernate ats2))
            )
            (ref-ATS::UEV_RewardTokenExistance ats1 curl-token true)
            (enforce (and (not h1) h2) "Brumate requires hibernation for {} set to off andfor {} set to ON")
            (compose-capability (P|TT))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_MergeAll:[decimal] (balances:[decimal] seconds-to-unsleep:[decimal])
        @doc "Combines an equal length <balances> list representing Sleeping DPOF Account Balances \
        \ with a <seconds-to-unsleep> list to create an output decimal list with 3 decimals: \
        \ 1] 1st decimal, representing the amount of DPTF token that can be awakend \
        \ 2] 2nd decimal, representing the amount of Sleeping DPOF that must still exist in a sleeping state \
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
    (defun URC_CullMetaDataAmountWithObject:list (id:string nonce:integer)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                (meta-data-chain:[object{VestingV5.VST|MetaDataSchema}] 
                    (ref-DPOF::UR_NonceMetaData id nonce)
                )
            )
            (fold
                (lambda
                    (acc:list item:object{VestingV5.VST|MetaDataSchema})
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
                meta-data-chain
            )
        )
    )
    (defun URC_SecondsToUnlock:[decimal] (id:string nonces:[integer])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                (meta-data-array (ref-DPOF::UR_NoncesMetaDatas id nonces))
                (present-time:time (at "block-time" (chain-data)))
            )
            (fold
                (lambda
                    (acc:[decimal] idx:integer)
                    (ref-U|LST::UC_AppL
                        acc
                        (diff-time 
                            (at "release-date" (at 0 (take -1 (at idx meta-data-array)))) 
                            present-time
                        )
                    )
                )
                []
                (enumerate 0 (- (length meta-data-array) 1))
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
    (defun UEV_StillHasSleeping (sleeping-dpof:string nonce:integer)
        (let
            (
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                (meta-data-chain:[object] (ref-DPOF::UR_NonceMetaData sleeping-dpof nonce))
                (release-date:time (at "release-date" (at 0 meta-data-chain)))
                (present-time:time (at "block-time" (chain-data)))
                (dt:decimal (diff-time release-date present-time))
            )
            (enforce (> dt 0.0) (format "Nonce {} of Sleeping DPOF {} must be dormant for operation" [nonce sleeping-dpof]))
        )
    )
    ;;{F3}  [UDC]
    (defun UDC_ComposeVestingMetaData:[object{VestingV5.VST|MetaDataSchema}]
        (dptf:string amount:decimal offset:integer duration:integer milestones:integer)
        (let
            (
                (ref-U|VST:module{UtilityVstV2} U|VST)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (amount-lst:[decimal] (ref-U|VST::UC_SplitBalanceForVesting (ref-DPTF::UR_Decimals dptf) amount milestones))
                (date-lst:[time] (ref-U|VST::UC_MakeVestingDateList offset duration milestones))
                (meta-data-chain:[object{VestingV5.VST|MetaDataSchema}] (zip (lambda (x:decimal y:time) { "release-amount": x, "release-date": y }) amount-lst date-lst))
            )
            (ref-DPTF::UEV_Amount dptf amount)
            meta-data-chain
        )
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_CreateFrozenLink:object{IgnisCollectorV2.OutputCumulator}
        (patron:string dptf:string)
        (UEV_IMC)
        (with-capability (VST|C>FROZEN-LINK dptf)
            (XI_CreateSpecialTrueFungibleLink patron dptf 1)
        )
    )
    (defun C_CreateReservationLink:object{IgnisCollectorV2.OutputCumulator}
        (patron:string dptf:string)
        (UEV_IMC)
        (with-capability (VST|C>RESERVATION-LINK dptf)
            (XI_CreateSpecialTrueFungibleLink patron dptf 2)
        )
    )
    (defun C_CreateVestingLink:object{IgnisCollectorV2.OutputCumulator}
        (patron:string dptf:string)
        (UEV_IMC)
        (with-capability (VST|C>VESTING-LINK dptf)
            (XI_CreateSpecialOrtoFungibleLink patron dptf 1)
        )
    )
    (defun C_CreateSleepingLink:object{IgnisCollectorV2.OutputCumulator}
        (patron:string dptf:string)
        (UEV_IMC)
        (with-capability (VST|C>SLEEPING-LINK dptf)
            (XI_CreateSpecialOrtoFungibleLink patron dptf 2)
        )
    )
    (defun C_CreateHibernatingLink:object{IgnisCollectorV2.OutputCumulator}
        (patron:string dptf:string)
        (UEV_IMC)
        (with-capability (VST|C>SLEEPING-LINK dptf)
            (XI_CreateSpecialOrtoFungibleLink patron dptf 3)
        )
    )
    ;;  [Frozen Token Actions]
    (defun C_Freeze:object{IgnisCollectorV2.OutputCumulator}
        (freezer:string freeze-output:string dptf:string amount:decimal)
        (UEV_IMC)
        (with-capability (VST|C>FREEZE freezer freeze-output dptf amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    (f-dptf:string (ref-DPTF::UR_Frozen dptf))
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators
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
    (defun C_RepurposeFrozen:object{IgnisCollectorV2.OutputCumulator}
        (dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-FROZEN-TF dptf-to-repurpose repurpose-from repurpose-to)
            (XI_RepurposeTrueFungible dptf-to-repurpose repurpose-from repurpose-to)
        )
    )
    (defun C_ToggleTransferRoleFrozenDPTF:object{IgnisCollectorV2.OutputCumulator}
        (s-dptf:string target:string toggle:bool)
        (UEV_IMC)
        (with-capability (VST|C>TOGGLE-FROZEN-TF-TR s-dptf target)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                )
                (ref-DPTF::C_ToggleTransferRole s-dptf target toggle)
            )
        )
    )
    ;;  [Reserve Token Actions]
    (defun C_Reserve:object{IgnisCollectorV2.OutputCumulator}
        (reserver:string dptf:string amount:decimal)
        (UEV_IMC)
        (with-capability (VST|C>RESERVE reserver dptf amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    (r-dptf:string (ref-DPTF::UR_Reservation dptf))
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators
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
    (defun C_Unreserve:object{IgnisCollectorV2.OutputCumulator}
        (unreserver:string r-dptf:string amount:decimal)
        (UEV_IMC)
        (with-capability (VST|C>UNRESERVE unreserver r-dptf amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    (dptf:string (ref-DPTF::UR_Reservation r-dptf))
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators
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
    (defun C_RepurposeReserved:object{IgnisCollectorV2.OutputCumulator}
        (dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-RESERVED-TF dptf-to-repurpose repurpose-from repurpose-to)
            (XI_RepurposeTrueFungible dptf-to-repurpose repurpose-from repurpose-to)
        )
    )
    (defun C_ToggleTransferRoleReservedDPTF:object{IgnisCollectorV2.OutputCumulator}
        (s-dptf:string target:string toggle:bool)
        (UEV_IMC)
        (with-capability (VST|C>TOGGLE-RESERVED-TF-TR s-dptf target)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                )
                (ref-DPTF::C_ToggleTransferRole s-dptf target toggle)
            )
        )
    )
    ;;  [Vesting Token Actions]
    (defun C_Vest:object{IgnisCollectorV2.OutputCumulator}
        (vester:string target-account:string dptf:string amount:decimal offset:integer duration:integer milestones:integer)
        (UEV_IMC)
        (with-capability (VST|C>VEST vester target-account dptf amount offset duration milestones)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    ;;
                    (dpof-id:string (ref-DPTF::UR_Vesting dptf))
                    (meta-data-chain:[object{VestingV5.VST|MetaDataSchema}] 
                        (UDC_ComposeVestingMetaData dptf amount offset duration milestones)
                    )
                    (nonce:integer (+ (ref-DPOF::UR_NoncesUsed dpof-id) 1))
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators
                    [
                        ;;1]VST|SC_NAME mints the DPOF Vested Token
                        (ref-DPOF::C_Mint dpof-id VST|SC_NAME amount meta-data-chain)
                        ;;2]Vester transfers the DPTF Token to the VST|SC_NAME if its not already there
                        (if (!= vester VST|SC_NAME)
                            (ref-TFT::C_Transfer dptf vester VST|SC_NAME amount true)
                            EOC
                        )
                        ;;3]VST|SC_NAME transfers the DPOF Vested Token to target-account
                        (ref-DPOF::C_Transfer dpof-id [nonce] VST|SC_NAME target-account amount true)
                    ]
                    [nonce]
                )
            )
        )
    )
    (defun C_Unvest:object{IgnisCollectorV2.OutputCumulator}
        (unvester:string dpof:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (culled-data:list (URC_CullMetaDataAmountWithObject dpof nonce))
                (culled-amount:decimal (at 0 culled-data))
            )
            (with-capability (VST|C>CULL unvester dpof nonce culled-amount)
                (let
                    (
                        (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                        (ref-DALOS:module{OuronetDalosV5} DALOS)
                        (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                        (ref-TFT:module{TrueFungibleTransferV8} TFT)
                        ;;
                        (dptf-id:string (ref-DPOF::UR_Vesting dpof))
                        (nonces-used:integer (ref-DPOF::UR_NoncesUsed dpof))
                        (nonce-supply:decimal (ref-DPOF::UR_NonceSupply dpof nonce))
                        (remint-meta-data-chain:[object{VestingV5.VST|MetaDataSchema}] (at 1 culled-data))
                        ;;
                        (obj-l:decimal (dec (length remint-meta-data-chain)))
                        (smallest:decimal (ref-DALOS::UR_UsagePrice "ignis|smallest"))
                        ;;
                        (price:decimal (/ (* obj-l smallest) 5.0))
                        (trigger:bool (ref-IGNIS::URC_IsVirtualGasZero))
                        (return-amount:decimal (- nonce-supply culled-amount))
                        ;;
                        (ico1:object{IgnisCollectorV2.OutputCumulator}
                            (ref-IGNIS::UDC_ConstructOutputCumulator price VST|SC_NAME trigger [])
                        )
                        (ico2:object{IgnisCollectorV2.OutputCumulator}
                            (if (= return-amount 0.0)
                                ;;1]VST|SC_NAME transfers the whole dptf back to the unvester, when there is no return amount
                                (ref-TFT::C_Transfer dptf-id VST|SC_NAME unvester nonce-supply true)
                                (ref-IGNIS::UDC_ConcatenateOutputCumulators
                                    [
                                        ;;1]Only the ready to unvest dptf is trasnfered back to unvester
                                        (ref-TFT::C_Transfer dptf-id VST|SC_NAME unvester culled-amount true)
                                        ;;2]If return amount is non zero, it is minted as a new DPOF
                                        (ref-DPOF::C_Mint dpof VST|SC_NAME return-amount remint-meta-data-chain)
                                        ;;3]Together with the newly minted remainder, still vested, dppf
                                        (ref-DPOF::C_Transfer dpof [(+ 1 nonces-used)] VST|SC_NAME unvester true)
                                    ]
                                    []
                                )
                            )
                        )
                        (ico3:object{IgnisCollectorV2.OutputCumulator}
                            (ref-IGNIS::UDC_ConcatenateOutputCumulators
                                [
                                    ;;1]Transfer <nonce> to VST|SC_NAME for Burning
                                    (ref-DPOF::C_Transfer dpof [nonce] unvester VST|SC_NAME true)
                                    ;;2]Burn it
                                    (ref-DPOF::C_Burn dpof VST|SC_NAME nonce nonce-supply)
                                ]
                                []
                            )
                        )
                    )
                    (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2 ico3] [])
                )
            )
        )
    )
    (defun C_RepurposeVested:object{IgnisCollectorV2.OutputCumulator}
        (dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-VESTING-MF dpof-to-repurpose nonce repurpose-from repurpose-to)
            (XI_RepurposeOrtoFungible dpof-to-repurpose nonce repurpose-from repurpose-to)
        )
    )
    ;;  [Sleeping Token Actions]
    (defun C_Sleep:object{IgnisCollectorV2.OutputCumulator}
        (sleeper:string target-account:string dptf:string amount:decimal duration:integer)
        (UEV_IMC)
        (with-capability (VST|C>SLEEP sleeper target-account dptf amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    ;;
                    (dpof-id:string (ref-DPTF::UR_Sleeping dptf))
                    (meta-data-chain:[object{VestingV5.VST|MetaDataSchema}] 
                        (UDC_ComposeVestingMetaData dptf amount 0 duration 1)
                    )
                    (nonce:integer (+ (ref-DPOF::UR_NoncesUsed dpof-id) 1))
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators
                    [
                        ;;1]VST|SC_NAME mints the DPOF Sleeping Token
                        (ref-DPOF::C_Mint dpof-id VST|SC_NAME amount meta-data-chain)
                        ;;2]Sleeper transfers the DPTF Token to the VST|SC_NAME if its not already there
                        (if (!= sleeper VST|SC_NAME)
                            (ref-TFT::C_Transfer dptf sleeper VST|SC_NAME amount true)
                            EOC
                        )
                        ;;3]VST|SC_NAME transfers the DPOF Sleeping Token to target-account
                        (ref-DPOF::C_Transfer dpof-id [nonce] VST|SC_NAME target-account true)
                    ]
                    []
                )
            )
        )
    )
    (defun C_Unsleep:object{IgnisCollectorV2.OutputCumulator}
        (unsleeper:string dpof:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                (nonce-supply:decimal (ref-DPOF::UR_NonceSupply dpof nonce))
                (culled-amount:decimal (at 0 (URC_CullMetaDataAmountWithObject dpof nonce)))
            )
            (with-capability (VST|C>UNSLEEP unsleeper dpof nonce nonce-supply culled-amount)
                (let
                    (
                        (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                        (ref-TFT:module{TrueFungibleTransferV8} TFT)
                        ;;
                        (dptf-id:string (ref-DPOF::UR_Sleeping dpof))
                    )
                    (ref-IGNIS::UDC_ConcatenateOutputCumulators
                        [
                            ;;1]Unsleeper transfers the initial dpof to the VST|SC_NAME
                            (ref-DPOF::C_Transfer dpof [nonce] unsleeper VST|SC_NAME true)
                            ;;2]Which is then burned in its entirety
                            (ref-DPOF::C_Burn dpof VST|SC_NAME nonce nonce-supply)
                            ;;3]VST|SC_NAME transfers in return the initial amount of the dpof, as the dptf counterpart
                            (ref-TFT::C_Transfer dptf-id VST|SC_NAME unsleeper nonce-supply true)
                        ]
                        []
                    )
                )
            )
        ) 
    )
    (defun C_Merge:object{IgnisCollectorV2.OutputCumulator}
        (merger:string dpof:string nonces:[integer])
        (UEV_IMC)
        (with-capability (VST|C>MERGE merger dpof nonces)
            (XI_MergeNonces dpof merger merger nonces 2)
        )
    )
    (defun C_RepurposeMerge:object{IgnisCollectorV2.OutputCumulator}
        (dpof-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-MERGE dpof-to-repurpose nonces repurpose-from repurpose-to)
            (XI_MergeNonces dpof-to-repurpose repurpose-from repurpose-to nonces 2)
        )
    )
    (defun C_RepurposeSleeping:object{IgnisCollectorV2.OutputCumulator}
        (dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-SLEEPING-MF dpof-to-repurpose nonce repurpose-from repurpose-to)
            (XI_RepurposeOrtoFungible dpof-to-repurpose nonce repurpose-from repurpose-to)
        )
    )
    (defun C_ToggleTransferRoleSleepingDPOF:object{IgnisCollectorV2.OutputCumulator}
        (s-dpof:string target:string toggle:bool)
        (UEV_IMC)
        (with-capability (VST|C>TOGGLE-SLEEPING-OF-TR s-dpof target)
            (let
                (
                    (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                )
                (ref-DPOF::C_ToggleTransferRole s-dpof target toggle)
            )
        )
    )
    ;;
    (defun C_Hibernate:object{IgnisCollectorV2.OutputCumulator}
        (hibernator:string target-account:string dptf:string amount:decimal dayz:integer)
        (UEV_IMC)
        (with-capability (VST|C>HIBERNATE hibernator target-account dptf amount dayz)
            (let
                (
                    (ref-U|VST:module{UtilityVstV2} U|VST)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    ;;
                    (dpof-id:string (ref-DPTF::UR_Hibernation dptf))
                    (duration:integer (* dayz 86400))
                    (meta-data-chain:[object{VestingV5.VST|HibernatingSchema}]
                        [
                            {"mint-time"    : (at "block-time" (chain-data))
                            ,"release-date" : (at 0 (ref-U|VST::UC_MakeVestingDateList 0 duration 1))}
                        ]
                    )
                    (nonce:integer (+ (ref-DPOF::UR_NoncesUsed dpof-id) 1))
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators
                    [
                        ;;1]VST|SC_NAME mints the DPOF Hibernating Token
                        (ref-DPOF::C_Mint dpof-id VST|SC_NAME amount meta-data-chain)
                        ;;2]Sleeper transfers the DPTF Token to the VST|SC_NAME if its not already there
                        (if (!= hibernator VST|SC_NAME)
                            (ref-TFT::C_Transfer dptf hibernator VST|SC_NAME amount true)
                            EOC
                        )
                        ;;3]VST|SC_NAME transfers the DPOF Sleeping Token to target-account
                        (ref-DPOF::C_Transfer dpof-id [nonce] VST|SC_NAME target-account true)
                    ]
                    []
                )
            )
        )
    )
    (defun C_Awake:object{IgnisCollectorV2.OutputCumulator}
        (awaker:string dpof:string nonce:integer)
        @doc "Hibernated Tokens have a 80% peak awakening fee, \
            \ that goes down to zero as time elapses towards its release date.\
            \ This fee is discared (burning it), with no way of collecting it."
        (UEV_IMC)
        (with-capability (VST|C>AWAKE awaker dpof nonce)
            (let
                (
                    (ref-U|ATS:module{UtilityAtsV2} U|ATS)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    ;;
                    (dptf-id:string (ref-DPOF::UR_Hibernation dpof))
                    (precision:integer (ref-DPOF::UR_Decimals dpof))
                    (nonce-supply:decimal (ref-DPOF::UR_NonceSupply dpof nonce))
                    (meta-data-chain:[object] (ref-DPOF::UR_NonceMetaData dpof nonce))
                    ;;
                    (mint-time:time (at "mint-time" (at 0 meta-data-chain)))
                    (release-time:time (at "release-date" (at 0 meta-data-chain)))
                    (hibernating-period:decimal (diff-time release-time mint-time))
                    ;;
                    (present-time:time (at "block-time" (chain-data)))
                    (elapsed-time:decimal (diff-time present-time mint-time))
                    ;;
                    (hibernating-fee-promile:decimal
                        (if (>= elapsed-time hibernating-period)
                            0.0
                            (floor (- 800.0 (* 800.0 (/ elapsed-time hibernating-period))) 4)
                        )
                    )
                    (remainder:decimal 
                        (if (= hibernating-fee-promile 0.0)
                            nonce-supply
                            (at 0 (ref-U|ATS::UC_PromilleSplit hibernating-fee-promile nonce-supply precision))
                        )
                    )
                    (hibernating-fee:decimal (- nonce-supply remainder))
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators
                    [
                        ;;1]Transfer Nonce to VST|SC_NAME
                        (ref-DPOF::C_Transfer dpof [nonce] awaker VST|SC_NAME true)
                        ;;2]Burn it whole
                        (ref-DPOF::C_Burn dpof VST|SC_NAME nonce nonce-supply)
                        ;;3]Transfer Remainder from VST|SC_NAME to <awaker>
                        (ref-TFT::C_Transfer dptf-id VST|SC_NAME awaker remainder true)
                        ;;4]Burn <hibernating-fee> if its greater than 0.0 on VST|SC_NAME
                        (if (!= hibernating-fee 0.0)
                            (ref-DPTF::C_Burn dptf-id VST|SC_NAME hibernating-fee)
                            EOC
                        )
                    ]
                    [hibernating-fee-promile remainder hibernating-fee]
                )
            )
        )
    )
    (defun C_Slumber:object{IgnisCollectorV2.OutputCumulator}
        (merger:string dpof:string nonces:[integer])
        (UEV_IMC)
        (with-capability (VST|C>SLUMBER merger dpof nonces)
            (XI_MergeNonces dpof merger merger nonces 3)
        )
    )
    (defun C_RepurposeSlumber:object{IgnisCollectorV2.OutputCumulator}
        (dpof-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-SLUMBER dpof-to-repurpose nonces repurpose-from repurpose-to)
            (XI_MergeNonces dpof-to-repurpose repurpose-from repurpose-to nonces 3)
        )
    )
    (defun C_RepurposeHibernating:object{IgnisCollectorV2.OutputCumulator}
        (dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        (UEV_IMC)
        (with-capability (VST|C>REPURPOSE-HIBERNATING-MF dpof-to-repurpose nonce repurpose-from repurpose-to)
            (XI_RepurposeOrtoFungible dpof-to-repurpose nonce repurpose-from repurpose-to)
        )
    )
    (defun C_ToggleTransferRoleHibernatingDPOF:object{IgnisCollectorV2.OutputCumulator}
        (s-dpof:string target:string toggle:bool)
        (UEV_IMC)
        (with-capability (VST|C>TOGGLE-HIBERNATING-OF-TR s-dpof target)
            (let
                (
                    (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                )
                (ref-DPOF::C_ToggleTransferRole s-dpof target toggle)
            )
        )
    )
    ;;
    (defun C_Constrict:object{IgnisCollectorV2.OutputCumulator}
        (constricter:string ats:string rt:string amount:decimal dayz:integer)
            @doc "Constricts the <rt> Token, autostaking it in the ATS-Pair <ats>, generating Hibernated Token \
            \ Only works when <ats> has <hibernate> on"
        (UEV_IMC)
        (with-capability (ATSU|C>CONSTRICT ats rt)
            (let
                (
                    (ref-U|ATS:module{UtilityAtsV2} U|ATS)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    ;;
                    ;;<ats>
                    (coil-data:object{AutostakeV5.CoilData} 
                        (ref-ATS::URC_RewardBearingTokenAmountsWithHibernation ats rt amount dayz)
                    )
                    (input-amount:decimal (at "first-input-amount" coil-data))
                    (royalty-fee:decimal (at "royalty-fee" coil-data))
                    (c-rbt:string (at "rbt-id" coil-data))
                    (c-rbt-amount (at "rbt-amount" coil-data))
                    ;;
                    (ico1:object{IgnisCollectorV2.OutputCumulator}
                        (ref-TFT::C_Transfer rt constricter ATS|SC_NAME amount true)
                    )
                    (ico2:object{IgnisCollectorV2.OutputCumulator}
                        (ref-DPTF::C_Mint c-rbt ATS|SC_NAME c-rbt-amount false)
                    )
                    (ico3:object{IgnisCollectorV2.OutputCumulator}
                        (C_Hibernate ATS|SC_NAME constricter c-rbt c-rbt-amount dayz)
                    )
                )
                (ref-ATS::XE_UpdateRUR ats rt 1 true input-amount)
                (if (!= royalty-fee 0.0)
                    (ref-ATS::XE_UpdateRUR ats rt 3 true royalty-fee)
                    true
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2 ico3] [c-rbt-amount])
            )
        )
    )
    (defun C_Brumate:object{IgnisCollectorV2.OutputCumulator}
        (brumator:string ats1:string ats2:string rt:string amount:decimal dayz:integer)
        @doc "Brumates the <rt> through 2 ATS-Pairs, \
            \ outputting the <c-rbt2> as Hibernated Token to the <brumator> \
            \ <ats1> must have <hibernation> off, and <ats2> may on for brumation to work"
        (UEV_IMC)
        (with-capability (ATSU|C>BRUMATE ats1 ats2 rt)
            (let
                (
                    (ref-U|ATS:module{UtilityAtsV2} U|ATS)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    ;;
                    ;;<ats1>
                    (coil1-data:object{AutostakeV5.CoilData} 
                        (ref-ATS::URC_RewardBearingTokenAmounts ats1 rt amount)
                    )
                    (input1-amount:decimal (at "first-input-amount" coil1-data))
                    (royalty1-fee:decimal (at "royalty-fee" coil1-data))
                    (c-rbt1:string (at "rbt-id" coil1-data))
                    (c-rbt1-amount (at "rbt-amount" coil1-data))
                    ;;
                    ;;<ats2>
                    (coil2-data:object{AutostakeV5.CoilData} 
                        (ref-ATS::URC_RewardBearingTokenAmountsWithHibernation ats2 c-rbt1 c-rbt1-amount dayz)
                    )
                    (input2-amount:decimal (at "first-input-amount" coil2-data))
                    (royalty2-fee:decimal (at "royalty-fee" coil2-data))
                    (c-rbt2:string (at "rbt-id" coil2-data))
                    (c-rbt2-amount (at "rbt-amount" coil2-data))
                    ;;
                    (ico1:object{IgnisCollectorV2.OutputCumulator}
                        (ref-TFT::C_Transfer rt brumator ATS|SC_NAME amount true)
                    )
                    (ico2:object{IgnisCollectorV2.OutputCumulator}
                        (ref-DPTF::C_Mint c-rbt1 ATS|SC_NAME c-rbt1-amount false)
                    )
                    (ico3:object{IgnisCollectorV2.OutputCumulator}
                        (ref-DPTF::C_Mint c-rbt2 ATS|SC_NAME c-rbt2-amount false)
                    )
                    (ico4:object{IgnisCollectorV2.OutputCumulator}
                        (C_Hibernate ATS|SC_NAME brumator c-rbt2 c-rbt2-amount dayz)
                    )
                )
                (ref-ATS::XE_UpdateRUR ats1 rt 1 true input1-amount)
                (ref-ATS::XE_UpdateRUR ats2 c-rbt1 1 true input2-amount)
                (if (!= royalty1-fee 0.0)
                    (ref-ATS::XE_UpdateRUR ats1 rt 3 true royalty1-fee)
                    true
                )
                (if (!= royalty2-fee 0.0)
                    (ref-ATS::XE_UpdateRUR ats2 c-rbt1 3 true royalty2-fee)
                    true
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2 ico3 ico4] [c-rbt2-amount])
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_CreateSpecialTrueFungibleLink:object{IgnisCollectorV2.OutputCumulator}
        (patron:string dptf:string fr-tag:integer)
        (require-capability (SECURE))
        (let
            (
                (ref-U|VST:module{UtilityVstV2} U|VST)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                ;;
                (dptf-name:string (ref-DPTF::UR_Name dptf))
                (dptf-ticker:string (ref-DPTF::UR_Ticker dptf))
                (dptf-decimals:integer (ref-DPTF::UR_Decimals dptf))
                (special-tf-id:[string]
                    (cond
                        ((= fr-tag 1) (ref-U|VST::UC_FrozenID dptf-name dptf-ticker))
                        ((= fr-tag 2) (ref-U|VST::UC_ReservedID dptf-name dptf-ticker))
                        [BAR]
                    )
                )
                (special-tf-name:string (at 0 special-tf-id))
                (special-tf-ticker:string (at 1 special-tf-id))
                (ico0:object{IgnisCollectorV2.OutputCumulator}
                    (ref-DPTF::XB_IssueFree
                        VST|SC_NAME
                        [special-tf-name]
                        [special-tf-ticker]
                        [dptf-decimals]
                        ;;
                        [false] ;;<can-upgrade>
                        [false] ;;<can-change-owner>
                        [true]  ;;<can-add-special-role>
                        ;;
                        [true]  ;;<can-freeze>
                        [true]  ;;<can-wipe>
                        [false] ;;<can-pause>
                        [true]  ;;<iz-special>
                    )
                )
                (special-dptf:string (at 0 (at "output" ico0)))
                (kda-costs:decimal (ref-DALOS::UR_UsagePrice "dptf"))
            )
            ;;Create DPTF Account 
            ;;Required Roles are on by default for VST|SC_NAME and dont need to be set.
            (ref-DPTF::C_DeployAccount dptf VST|SC_NAME)
            (ref-IGNIS::KDA|C_Collect patron kda-costs)
            (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                [
                    ico0 
                    (ref-DPTF::XE_UpdateSpecialTrueFungible dptf special-dptf fr-tag)
                ] 
                [special-dptf]
            )
        )
    )
    (defun XI_CreateSpecialOrtoFungibleLink:object{IgnisCollectorV2.OutputCumulator}
        (patron:string dptf:string vzh-tag:integer)
        (require-capability (SECURE))
        (let
            (
                (ref-U|VST:module{UtilityVstV2} U|VST)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                ;;
                (dptf-name:string (ref-DPTF::UR_Name dptf))
                (dptf-ticker:string (ref-DPTF::UR_Ticker dptf))
                (dptf-decimals:integer (ref-DPTF::UR_Decimals dptf))
                (special-of-id:[string]
                    (cond
                        ((= vzh-tag 1) (ref-U|VST::UC_VestingID dptf-name dptf-ticker))
                        ((= vzh-tag 2) (ref-U|VST::UC_SleepingID dptf-name dptf-ticker))
                        ((= vzh-tag 3) (ref-U|VST::UC_HibernationID dptf-name dptf-ticker))
                        [BAR]
                    )
                )
                (special-of-name:string (at 0 special-of-id))
                (special-of-ticker:string (at 1 special-of-id))
                (ico0:object{IgnisCollectorV2.OutputCumulator}
                    (ref-DPOF::XB_IssueFree
                        VST|SC_NAME
                        ;;
                        [special-of-name]
                        [special-of-ticker]
                        [dptf-decimals]
                        ;;
                        [false] ;;<can-upgrade>
                        [false] ;;<can-change-owner>
                        [true]  ;;<can-add-special-role>
                        [false] ;;<can-transfer-nft-create-role>
                        ;;
                        [true]  ;;<can-freeze>
                        [true]  ;;<can-wipe>
                        [false] ;;<can-pause>
                        ;;
                        [true]  ;;<iz-special>
                    )
                )
                (special-dpof:string (at 0 (at "output" ico0)))
                (kda-costs:decimal (ref-DALOS::UR_UsagePrice "dpmf"))
            )
            ;;Create DPTF Account 
            ;;Required Roles are on by default for VST|SC_NAME and dont need to be set.
            (ref-DPTF::C_DeployAccount dptf VST|SC_NAME)
            (ref-IGNIS::KDA|C_Collect patron kda-costs)
            (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                [
                    ico0 
                    (ref-DPOF::XE_UpdateSpecialOrtoFungible dptf special-dpof vzh-tag)
                ]
                [special-dpof]
            )
        )
    )
    (defun XI_RepurposeTrueFungible:object{IgnisCollectorV2.OutputCumulator}
        (dptf-to-repurpose:string repurpose-from:string repurpose-to:string)
        (require-capability (SECURE))
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (ref-TFT:module{TrueFungibleTransferV8} TFT)
                ;;
                (amount:decimal (ref-DPTF::UR_AccountSupply dptf-to-repurpose repurpose-from))
            )
            (ref-IGNIS::UDC_ConcatenateOutputCumulators
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
    (defun XI_RepurposeOrtoFungible:object{IgnisCollectorV2.OutputCumulator}
        (dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string)
        (require-capability (SECURE))
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                ;;
                (nonces-used:integer (ref-DPOF::UR_NoncesUsed dpof-to-repurpose))
                (amount:decimal (ref-DPOF::UR_NonceSupply dpof-to-repurpose nonce))
                (meta-data-chain:[object] (ref-DPOF::UR_NonceMetaData dpof-to-repurpose nonce))
            )
            (ref-IGNIS::UDC_ConcatenateOutputCumulators
                [
                    ;;1]Freeze <repurpose-from> for <dpof-to-repurpose>
                    (ref-DPOF::C_ToggleFreezeAccount dpof-to-repurpose repurpose-from true)
                    ;;2]WipePartial <dpof-to-repurpose> on <repurpose-from>
                    (ref-DPOF::C_WipeClean dpof-to-repurpose repurpose-from [nonce])
                    ;;3]Unfreeze <repurpose-from>
                    (ref-DPOF::C_ToggleFreezeAccount dpof-to-repurpose repurpose-from false)
                    ;;4]Mint <dptf-to-repurpose> anew
                    (ref-DPOF::C_Mint dpof-to-repurpose VST|SC_NAME amount meta-data-chain)
                    ;;5]Transfer it to <repurpose-to>
                    (ref-DPOF::C_Transfer dpof-to-repurpose [(+ 1 nonces-used)] VST|SC_NAME repurpose-to true)
                ]
                []
            )
        )
    )
    (defun XI_MergeNonces:object{IgnisCollectorV2.OutputCumulator}
        (dpof:string merger:string target:string nonces:[integer] vzh-tag:integer)
        @doc "<vzh-tag> = 2; Sleeping Tokens \
            \ <vzh-tag> = 3: Hibernating Tokens "
        (enforce (contains vzh-tag [2 3]) "Only Sleeping and Hibernating Tokens can be merged")
        (require-capability (SECURE))
        (let
            (
                (ref-U|VST:module{UtilityVstV2} U|VST)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                (ref-TFT:module{TrueFungibleTransferV8} TFT)
                ;;
                (dptf:string 
                    (if (= vzh-tag 2)
                        (ref-DPOF::UR_Sleeping dpof)
                        (ref-DPOF::UR_Hibernation dpof)
                    )
                )
                (nonces-used:integer (ref-DPOF::UR_NoncesUsed dpof))
                (nonces-supplies:[decimal] (ref-DPOF::UR_NoncesSupplies dpof nonces))
                (sum:decimal (fold (+) 0.0 nonces-supplies))
                (how-many:decimal (dec (length nonces)))
                (biggest:decimal (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                (price:decimal (* how-many biggest))
                (trigger:bool (ref-IGNIS::URC_IsVirtualGasZero))
                ;;
                (stu:[decimal] (URC_SecondsToUnlock dpof nonces))
                (compute-merge-all:[decimal] (UC_MergeAll nonces-supplies stu))
                ;;
                (free-amount:decimal (at 0 compute-merge-all))
                (locked-amount:decimal (at 1 compute-merge-all))
                (weigthed-locked-amount-in-seconds:integer (floor (at 2 compute-merge-all)))
            )
            (ref-IGNIS::UDC_ConcatenateOutputCumulators
                [
                    ;;A]5xNumber of Nonces in IGNIS for Merging
                    (ref-IGNIS::UDC_ConstructOutputCumulator price VST|SC_NAME trigger [])
                    ;;
                    ;;B]Destroy input Nonces through Wiping
                    ;;1]Freeze <merger> for <dpof>
                    (ref-DPOF::C_ToggleFreezeAccount dpof merger true)
                    ;;2]WipePartial <dpof> on <merger>
                    (ref-DPOF::C_WipeClean dpof merger nonces)
                    ;;3]Unfreeze <merger>
                    (ref-DPOF::C_ToggleFreezeAccount dpof merger false)
                    ;;
                    ;;C]Release DPTF if <free-amount> is non zero
                    (if (!= free-amount 0.0)
                        (ref-TFT::C_Transfer dptf VST|SC_NAME target free-amount true)
                        EOC
                    )
                    ;;
                    ;;D]Release a new Orto-Fungible if <locked-amount> is non zero
                    (if (!= locked-amount 0.0)
                        (let
                            (
                                (release-date:time (at 0 (ref-U|VST::UC_MakeVestingDateList 0 weigthed-locked-amount-in-seconds 1)))
                            )
                            (ref-IGNIS::UDC_ConcatenateOutputCumulators
                                [
                                    (ref-DPOF::C_Mint dpof VST|SC_NAME locked-amount
                                        (if (= vzh-tag 2)
                                            [
                                                ;;Sleeping Meta-Data
                                                {"release-amount"   : locked-amount
                                                ,"release-date"     : release-date}
                                            ]
                                            [
                                                ;;Hibernating Meta-Data
                                                {"mint-time"        : (at "block-time" (chain-data))
                                                ,"release-date"     : release-date}
                                            ]
                                        )
                                    )
                                    (ref-DPOF::C_Transfer dpof [(+ 1 nonces-used)] VST|SC_NAME target true)
                                ]
                                []
                            )
                        )
                        EOC
                    )
                ]
                compute-merge-all
            )
        )
    )
    ;;
)

;(create-table P|T)
;(create-table P|MT)