(module AQP GOV
    ;;
    (implements OuronetPolicy)
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
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;; [Keys]
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|CollectiblesKey ()           (+ (GOV|NS_Use) ".dh_sc_aqp-keyset"))
    ;;
    ;; [SC-Names]
    (defun GOV|AQP|SC_NAME ()              (at 0 [""]))
    ;;
    ;; [PBLs]
    (defun GOV|AQP|PBL ()                  (at 0 [""]))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
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
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::P|Info)))
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
                (mg:guard (create-capability-guard (P|AQP|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
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
    (defschema AQP|Schema
        ;;
        aqp-class:integer                                       ;;Defines the Pool Class, there are 5
                                                                ;;Class 0 = LPs allowed - native|sleeping|freezing
                                                                ;;Class 1 = DPTF Allowed (non LP) - native|freezing|sleeping|hibernating
                                                                ;;Class 2 = DPOF Allowed (non LP) - native only
                                                                ;;Class 3 = DPSF Score (SFTs)
                                                                ;;Class 4 = DPNF Score (NFTs)
        asset-id:string                                         ;;ID of the Asset that is allowed to be staked in the Pool.
                                                                ;;This must be in accordance with the <aqp-class> and together with it
                                                                ;;defines which assets can be staked in the Pool
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





















    (defschema AcqPoolSchema
        ;;Properties
        aqp-class:integer           ;;Stores AQP-Class, Class 0 = First Tier, Class 1 = Next Tier (Meta Pools)
        aqp-asset:string            ;;Stores the ID of the Asset that is allowed in the Pool, [BAR] if no Assets are Allowed (for Meta Pools)
        aqp-fungibility:[bool]      ;;Stores the fungibility of the Asset allowed for staking;
                                    ;;DPTF = True Fungible = [true true]
                                    ;;DPOF = Orto Fungible = [true false]
                                    ;;DPSF = Semi Fungible = [false true]
                                    ;;DPNF =  Non Fungible = [false false]
        ;;
        aqp-reward-asset:[string]   ;;Stores the list of DPTFs that are allowed as Rewards.
        ;;When Pool is setup with a DPTF Asset
        allow-frozen:bool           ;;Defines if Frozen Counterpart is allowed (Farms and Vaults)
        allow-sleeping:bool         ;;Defines if Sleeping Counterpart is allowed (Farms and Vaults)
        allow-hibernated:bool       ;;Defines if Hibernated Counterparts is allowed (Vaults)
                                    ;;Reserved and Vested Special Tokens arent allowed in AQP Pools
        ;;

        master:string               ;;Stores the ID of the Master Acquisition Pool, the Pool it is slave to. BAR if none.
        slave:string                ;;Stores the ID of the Slave Acquisition Pool, the Pool it is master of. BAR if none.
        ;;
        global-nzs-count:integer    ;;Stores the Number or Entities with Non-Zero-Score accross all scores, each Entity being counted once
        score1:string
        score2:string
        score3:string
        score4:string
        score5:string
        score6:string
        score7:string
        ;;
        ;;Select Keys
        pool-id:string              ;;Stores the ID of the Pool. ["F|" = Farms; "V|" = Vaults; "T|" = Treasuries; "M|" = Meta]
    )
    (defschema AcqAnchorSchema
        ank-asset:string            ;;ID of the anchored Asset
        ank-fungibility:[bool]      ;;Stores the Fungiblity of the Asset the Anchor is based on.
        precision:decimal           ;;Precision of the Anchor Variable
        ;;
        ;;Select Keys
        anchor-id:string
    )
    (defschema AcqScoreSchema
        pool-id:string              ;;Stores the ID of the Pool the Score is tied to. "|" if Score isnt tied to a Pool Yet.
                                    ;;Tying a Score to a Pool should be immutable.
        ;;Scores Information
        which-base:string           ;;Stores which base should be used for the Boosted-Score. Defaults to "|" when the same base is used.
                                    ;;Otherwise stores the Score-ID for which the base score should be used.
        total-base-score:decimal    ;;Sum of all Individual Entities Scores, Precision up 24 decimals.
        total-boosted-score:decimal ;;Sum of all Individual Entities Boosted Scores, (Base-Score x Anchor-Boost)
        total-deb-score:decimal     ;;Sum of all Individual Entities DEB Scores, (Boosted-Score x DEB)
        nzs-count:integer           ;;Stores the number of Entities with Non-Zero-Score.
        ;;
        ;;Score Composition
        deb-boost:bool              ;;Defines if the score is boosted by DEB or not.
        ;;DPTF & DPOF
        mlt-frozen:decimal          ;;Stores how much the Frozen Counterpart of the DPTF is worth when staked; (0.0 for Treasuries) [default 2.0]
        mlt-sleeping:decimal        ;;Stores how much the Sleeping Counterpart of the DPTF is worth when staked; (0.0 for Treasuries) [default 1.0]
        mlt-hibernated:decimal      ;;Stores how much the Hibernated Counterpart of the DPTF is worth when staked; (0.0 for Treasuries) [default 1.0]
        ;;DPSF & DPNF
        sft-equality:bool           ;;Stores if all SFTs should be treated as equal (Default True). When <false> Nonce Value is checked.
        nft-equality:bool           ;;Stores if all NFTs should be treated as equal. When set to <false>, deffers to <nft-native> for scoring
        nft-native:bool             ;;When <true>, uses NFT Native Score, when <false> uses trait based Score
        nft-score-traits:[string]   ;;Specify which traits can be used for scoring for NFTs.
        nft-boost-traits:[string]   ;;Specify which traits can be used for score boosting.
        ;;
        ;:Select Keys
        score-id:string             ;;Stores the ID of the Score
    )
    
    (defschema AcqRewardSchema
        ;;Reward Information
        current-rps:decimal         ;;Rewards per Score Unit, Precision 48 decimal, Initial 0.0
        available-rewards:decimal   ;;Unclaimed Rewards, Precision up to 24 decimals (DPTF Precision)
        unclaimed-count:integer     ;;Number of Entities with Total Unclaimed Rewards > 0
        segmentation:bool           ;:Default to False; Determines if rewards can be collected in their entirety or not.
        ;;
        ;;Select Keys
        pool-id:string              ;;Stores the ID of the Pool
        score-id:string             ;;Stores the ID of the Score
        dptf-id:string              ;;Stores the ID of the DPTF Reward Token
    )
    ;;
    ;;
    ;;ENTITY Schemas
    (defschema EntityScoreSchema
        base-score:decimal          ;;Stores the current ENTITY Score, Precision up to 24 decimals
        boosted-score:decimal       ;;Stores the current ENTITY Boosted Scores, (Base-Score x NFT-Boost)
        deb-score:decimal           ;;Stores the current ENTITY DEB Score (Boosted-Score x DEB)
        ;;
        entity-id:string            ;;Stores the Entity-ID (Pool-ID or Ouronet-Account)
        pool-id:string              ;;Stores the ID of the Pool
        score-id:string             ;;Stores the ID of the Score
    )
    (defschema EntityRewardSchema
        last-rps:decimal            ;;Stores Global RPS at last interaction
        pending-rewards:decimal     ;;Checkpointed Rewards, precision up to 24 decimals (DPTF Precision)
        ;;
        ;;Select Keys
        entity-id:string            ;;Stores the Entity-ID (Pool-ID or Ouronet-Account)
        pool-id:string              ;;Stores the ID of the Pool
        dptf-id:string              ;;Stores the ID of the DPTF Reward Token
    )
    ;;






    ;;
    ;;Score Storage
    (defschema SemiFungibleNonceScoresSchema
        score:decimal               ;;Stores SFT Nonce Score
        promille:decimal            ;;Stores SFT Nonce Boost Promille
        ;;
        ;:Select Keys
        score-id:string             ;;Score-ID
        dpsf-id:string              ;;DPSF-ID
        nonce:integer               ;;Nonce-Value
    )
    (defschema NonFungibleTraitScoresSchema
        score:decimal               ;;Stores NFT Rarity Score
        promille:decimal            ;;Stores NFT Rarity Boost Promille
        ;;
        ;:Select Keys
        score-id:string             ;;Score-ID
        dpnf-id:string              ;;DPNF-ID
        trait:string                ;;Trait
    )
    ;;Stake Tracker
    (defschema TrueFungibleTracker
        balance:decimal             ;;Store DPTF Balance Amount
        ;;
        ;;Select Keys
        pool-id:string              ;;Pool-ID
        dptf-id:string              ;;DPTF-ID
        owner-id:string             ;;Owner-ID
        beneficiary-id:string       ;;Beneficiary-ID
    )
    (defschema OrtoFungibleTracker
        owner-id:string             ;;Owner-ID
        beneficiary-id:string       ;;Beneficiary-ID
        ;;
        ;;Select Keys
        pool-id:string              ;;Pool-ID
        dpof-id:string              ;;DPOF-ID
        nonce:integer               ;;Nonce-Value
    )
    (defschema SemiFungibleTracker
        balance:decimal             ;;Stores DPSF Balance
        ;;
        ;;Select Keys
        pool-id:string              ;;Pool-ID
        dpsf-id:string              ;;DPSF-ID
        owner-id:string             ;;Owner-ID
        beneficiary-id:string       ;;Beneficiary-ID
        nonce:integer               ;;Nonce-Value
    )
    (defschema NonFungibleTracker
        balance:decimal             ;;Stores DPNF Balance
        ;;
        ;;Select Keys
        pool-id:string              ;;Pool-ID
        dpnf-id:string              ;;DPNF-ID
        owner-id:string             ;;Owner-ID
        beneficiary-id:string       ;;Beneficiary-ID
        nonce:integer               ;;Nonce-Value
    )
    ;;{2}
    ;;Acquisition Pool Tables
    (deftable AQP|T|Pool:{AcqPoolSchema})                       ;;Key = <Pool-ID>
    (deftable AQP|T|Anchor:{AcqAnchorSchema})                   ;;Key = <Anchor-ID>
    (deftable AQP|T|Score:{AcqScoreSchema})                     ;;Key = <Score-ID>
    (deftable AQP|T|RewardRPS:{AcqRewardSchema})                ;;Key = <Pool-ID> | <Score-ID> | <DPTF-ID>
    ;;
    ;;Entity Tables
    (deftable AQP|T|EntityScore:{EntityScoreSchema})            ;;Key = <Entity-ID> | <Pool-ID> | <Score-ID>
    (deftable AQP|T|EntityRewards:{EntityRewardSchema})         ;;Key = <Entity-ID> | <Pool-ID> | <Score-ID> | <DPTF-ID>
                                                                ;;<Entity-ID> = <Ouronet-Account>   for Native AQP Pools
                                                                ;;<Entity-ID> = <Pool-ID>           for Meta   AQP Pools
    ;;
    ;;Anchor Tables
    (deftable AQP|T|Anchors:{AcqAnchorsSchema})                 ;;Key = <Ouronet-Account> | <Anchor-ID>


    ;;Score Tables
    (deftable AQP|T|DPSFScores:{SemiFungibleNonceScoresSchema}) ;;Key = <Score-ID> | <DPSF-ID> | <Nonce>
    (deftable AQP|T|DPNFScores:{NonFungibleTraitScoresSchema})  ;;Key = <Score-ID> | <DPSF-ID> | <Trait>
    ;;
    ;;Staking Tracking Tables
    (deftable AQP|T|DPTFTracker:{TrueFungibleTracker})          ;;Key = <Pool-ID> | <DPTF-ID> | <Owner-ID> | <Beneficiary-ID>
    (deftable AQP|T|DPOFTracker:{OrtoFungibleTracker})          ;;Key = <Pool-ID> | <DPOF-ID> | <Nonce>
    (deftable AQP|T|DPSFTracker:{SemiFungibleTracker})          ;;Key = <Pool-ID> | <DPSF-ID> | <Owner-ID> | <Beneficiary-ID> | <Nonce>
    (deftable AQP|T|DPNFTracker:{NonFungibleTracker})           ;;Key = <Pool-ID> | <DPNF-ID> | <Owner-ID> | <Beneficiary-ID> | <Nonce>
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    ;;
    ;;







    ;;1]TrueFungibleAnchor
    (defschema ANK|
        ank-asset                   ;;
    )
    


    (deftable ANK|T|TF|Definition:{TF|AnchorDefinition})        ;;Key = 
    (defschema TF|AnchorDefinition
        unit-amount:decimal
        promile-per-unit:decimal
    )
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