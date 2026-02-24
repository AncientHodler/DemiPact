(module AQP GOV
    ;;
    (implements OuronetPolicyV1)
    ;(implements DemiourgosPactDigitalCollectibles-UtilityPrototype)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_AQP                    (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|AQP_ADMIN)))
    (defcap GOV|AQP_ADMIN ()                (enforce-guard GOV|MD_AQP))
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
    (defcap P|AQP|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|AQP|CALLER))
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
        (with-capability (GOV|AQP_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|AQP_ADMIN)
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
                (ref-P|DALOS:module{OuronetPolicyV1} DALOS)
                (mg:guard (create-capability-guard (P|AQP|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
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
    (defschema AQP|Schema
        ;;
        aqp-class:integer                                       ;;Defines the Pool Class, there are 5
        ;;                                                        Class 0 = LPs allowed - native|sleeping|freezing
        ;;                                                        Class 1 = DPTF Allowed (non LP) - native|freezing|sleeping|hibernating
        ;;                                                        Class 2 = DPOF Allowed (non LP) - native only
        ;;                                                        Class 3 = DPSF Score (SFTs)
        ;;                                                        Class 4 = DPNF Score (NFTs)
        asset-id:string                                         ;;ID of the Asset that is allowed to be staked in the Pool.
        ;;                                                        This must be in accordance with the <aqp-class> and together with it
        ;;                                                        Defines which assets can be staked in the Pool
        ;;
        ;;Score - Links
        score-primary:string
        score-secondary:string
        score-tertiary:string
        score-quaternary:string
        score-quinary:string
        score-senary:string
        score-septenary:string
        ;;
        ;;Select Keys
        aqp-id:string
    )
    ;;Staking Trackers
    (defschema AQP|TrueFungibleTracker
        balance:decimal                                         ;;Store DPTF Balance Amount
        ;;
        ;;Select Keys
        pool-id:string                                          ;;Pool-ID
        dptf-id:string                                          ;;DPTF-ID
        owner-id:string                                         ;;Owner-ID
        beneficiary-id:string                                   ;;Beneficiary-ID
    )
    (defschema AQP|OrtoFungibleTracker
        owner-id:string                                         ;;Owner-ID
        beneficiary-id:string                                   ;;Beneficiary-ID
        ;;
        ;;Select Keys
        pool-id:string                                          ;;Pool-ID
        dpof-id:string                                          ;;DPOF-ID
        owner-id:string                                         ;;Owner-ID
        beneficiary-id:string                                   ;;Beneficiary-ID
        nonce:integer                                           ;;Nonce-Value
    )
    (defschema AQP|SemiFungibleTracker
        balance:decimal                                         ;;Stores DPSF Balance
        ;;
        ;;Select Keys
        pool-id:string                                          ;;Pool-ID
        dpsf-id:string                                          ;;DPSF-ID
        owner-id:string                                         ;;Owner-ID
        beneficiary-id:string                                   ;;Beneficiary-ID
        nonce:integer                                           ;;Nonce-Value
    )
    (defschema AQP|NonFungibleTracker
        balance:decimal                                         ;;Stores DPNF Balance
        ;;
        ;;Select Keys
        pool-id:string                                          ;;Pool-ID
        dpnf-id:string                                          ;;DPNF-ID
        owner-id:string                                         ;;Owner-ID
        beneficiary-id:string                                   ;;Beneficiary-ID
        nonce:integer                                           ;;Nonce-Value
    )
    ;;
    ;;{2}
    (deftable AQP|T|Pool:{AQP|Schema})                          ;;Key = <Pool-ID>
    ;;Trackers
    (deftable AQP|T|DPTFTracker:{AQP|TrueFungibleTracker})      ;;Key = <Pool-ID> | <DPTF-ID> | <Owner-ID> | <Beneficiary-ID>
    (deftable AQP|T|DPOFTracker:{AQP|OrtoFungibleTracker})      ;;Key = <Pool-ID> | <DPOF-ID> | <Owner-ID> | <Beneficiary-ID> | <Nonce>
    (deftable AQP|T|DPSFTracker:{AQP|SemiFungibleTracker})      ;;Key = <Pool-ID> | <DPSF-ID> | <Owner-ID> | <Beneficiary-ID> | <Nonce>
    (deftable AQP|T|DPNFTracker:{AQP|NonFungibleTracker})       ;;Key = <Pool-ID> | <DPNF-ID> | <Owner-ID> | <Beneficiary-ID> | <Nonce>
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
    (defun C_Issue:object{IgnisCollectorV1.OutputCumulator}
        ()
        @doc ""
        true
    )
    (defun C_AddScore:object{IgnisCollectorV1.OutputCumulator}
        ()
        @doc ""
        true
    )
    (defun C_RevokeScore:object{IgnisCollectorV1.OutputCumulator}
        ()
        @doc ""
        true
    )
    ;;
    (defun C_Stake:object{IgnisCollectorV1.OutputCumulator}
        ()
        @doc ""
        true
    )
    (defun C_Unstake:object{IgnisCollectorV1.OutputCumulator}
        ()
        @doc ""
        true
    )
    ;;
    ;;ACTIONS
    ;;
    ;;1]INJECT Rewards (can inject only when <total-score> != 0.0)
    ;;  1a] Update <current-rps> = (+ <current-rps> (/ <reward-amount> <total-score>))
    ;;  1b] Update <available-rewards> = (+ <available-rewards> <reward-amount>)
    ;;  1c] Update <unclaimed-count> = <nzs-count>
    ;;
    ;;2]STAKE
    ;;  2a] Check if <deb-score> is different from the stored <deb-score>; if it is different use the newly computed <deb-score> for 2b]
    ;;  2b] Update <pending-rewards> = <pending-rewards> + (* <deb-score> (- <current-rps> <last-rps>))     
    ;;      Use the stored <deb-score> is if the same as the newly computed <deb-score>; No score updates yet
    ;;  2c] Update <total-base-score>/<total-deb-score> and <base-score>/<deb-score> considering the newly staked assets.
    ;;  2d] If prev <deb-score> was 0, increment <nzs-count>; 
    ;;      Increment <unclaimed-count> for first-stakers (prev <deb-score> was 0)
    ;;  2e] Update <last-rps> to the Pools <current-rps>
    ;;
    ;;3]UNSTAKE
    ;;  3a] Check if <deb-score> is different from the stored <deb-score>; if it is different use the newly computed <deb-score> for 3b]
    ;;  3b] Update <pending-rewards> = <pending-rewards> + (* <deb-score> (- <current-rps> <last-rps>))
    ;;      Use the stored <deb-score> is if the same as the newly computed <deb-score>; No score updates yet.
    ;;  3c] Update <total-base-score>/<total-deb-score> and <base-score>/<deb-score> considering the newly staked assets.
    ;;  3d] If <deb-score> becomes 0, decrement <nzs-count>
    ;;  3e] Update <last-rps> to the Pools <current-rps>
    ;;
    ;;4]COLLECT
    ;;  4a] Check if <deb-score> is different from the stored <deb-score>; if it is different use the newly computed <deb-score> for 4c]
    ;;  4b] Update <available-rewards> = <available-rewards> - <collected-rewards>
    ;;  4c] Computes Current Reward = <pending-reward> + (* <deb-score> (- <current-rps> <last-rps>))
    ;;      If <unclaimed-count> = 1 (is last user with non zero rewards) , then Current-Reward is the min between computed and exiting (for dust sweaping)
    ;;  4d] Updates the <pending-reward> to either 0.0 (in case all is collected) or to the remaining amount. (difference between computed and collected)
    ;;  4e] If all Computed Reward is collected, and the <pending-reward> becomes 0, decrement <unclaimed-count>
    ;;  4f] Update <last-rps> to the Pools <current-rps>
    ;;
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)
;;
(create-table AQP|T|Pool)
(create-table AQP|T|DPTFTracker)
(create-table AQP|T|DPOFTracker)
(create-table AQP|T|DPSFTracker)
(create-table AQP|T|DPNFTracker)