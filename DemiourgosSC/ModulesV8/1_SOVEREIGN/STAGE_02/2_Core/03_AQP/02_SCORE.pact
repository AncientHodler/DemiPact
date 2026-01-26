(module AQP-SCORE GOV
    ;;
    (implements OuronetPolicy)
    ;(implements DemiourgosPactDigitalCollectibles-UtilityPrototype)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_AQP-SCORE              (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|AQP-SCORE_ADMIN)))
    (defcap GOV|AQP-SCORE_ADMIN ()          (enforce-guard GOV|MD_AQP-SCORE))
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|AQP-SCORE|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|AQP-SCORE|CALLER))
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
        (with-capability (GOV|AQP-SCORE_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|AQP-SCORE_ADMIN)
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
                (mg:guard (create-capability-guard (P|AQP-SCORE|CALLER)))
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
    (defschema SCR|Schema
        @doc "General Score Definition \
            \ [.]   = fixed, cannot be changed \
            \ [..]  = Once linked, cannot be changed \
            \ [.t]  = Once set to true, cannot be changed \
            \ [M]   = mutable, can be modified  <owner-konto> \
            \ [Mu]  = mutable via upgrade, can be modified via <owner-konto> and true <can-upgrade>"
        ;;
        ;;Management
        owner-konto:string          ;;[Mu]  Stores the Score Owner.
        can-upgrade:bool            ;;[Mu]  Defines if Score Settings can be upgraded
        can-change-owner:bool       ;;[Mu]  Defines if the Owner can be changed
        ;;
        ;; Links
        anchor-link:string          ;;[..]  Specifies the Anchor ID that is to boost the score. BAR if not in use.
        boost-link:string           ;;[..]  Specifies the Score ID that is used as Base for the Boosted Score. BAR if not in use (uses its own base)
        aqpool-link:string          ;;[..]  Specifies the Pool that employs the Score. BAR if not in use.
        fvt-link:string             ;;[..]  Specifies the FVT the Score is part of. BAR if not in use.
        ;;Score Information
        deb-boost:bool              ;;[.t]  Specifies if DEB boosting occurs.
        total-base-score:decimal    ;;[M]   Sum of all Entities Scores, 24 prec
        total-boosted-score:decimal ;;[M]   Sum of all Entities Boosted Scores, 24 prec
        total-deb-score:decimal     ;;[M]   Sum of all Entities Final Score, 24 prec
        nzs-count:integer           ;;[M]   Store the amount of Non-Zero-Scores
        ;;
        ;;Score Class
        score-class:integer         ;;[.]   Defines the Score Class, there are 5
        ;;                                  Class 0 = LP Score (LP - native|sleeping|freezing)
        ;;                                  Class 1 = DPTF Score (non LP) 
        ;;                                  Class 2 = DPOF Score (non LP)
        ;;                                  Class 3 = DPSF Score (SFTs)
        ;;                                  Class 4 = DPNF Score (NFTs)
        ;;
        ;;DPTF & DPOF
        mx-frozen:decimal           ;;[.]   Multiplier for Frozen Tokens (Default 2.0)
        mx-sleeping:decimal         ;;[.]   Multiplier for Sleeping Tokens (Default 1.0)
        mx-hibernated:decimal       ;;[.]   Multiplier for Hibernated Tokens (Default 1.0)
        ;;
        ;;DPSF
        sft-equality:bool           ;;[.]   When true all SFTs are equal. When <false>, <nonce-score-value> is checked.
        ;;
        ;;DPNF
        nft-score-model:integer     ;;[.]   Sets NFT Score Model; Only 3 Models Allowed [-1 0 1]
        ;;                                  Model -1 = All NFTs are equal, and will have a score of 1
        ;;                                  Model  0 = NFTs will be scored by their native Score Systems
        ;;                                  Model  1 = NFTs will be scored based on Scores defined per Trait <trait-score-value>
        ;;                                  (Multiple Traits can be used, must be specified in the key below)
        nft-trait-keys:[string]     ;;[.]   Specifies which NFT Traits will be used for scoring.
        ;;
        ;;Select Keys
        score-id:string             ;;[.]   Stores the ID of the Score
    )
    (defschema SCR|UserSchema
        base-score:decimal
        boosted-score:decimal
        deb-score:decimal
        ;;
        ;;Select Keys
        ouronet-account:string
        pool-id:string
        score-id:string
    )
    ;;
    (defschema SCR|SF|Schema
        nonce-score-value:decimal   ;;[M]   Score Value of DPSF Nonce
        ;;
        ;;Select Keys
        score-id:string
        dpsf-id:string
        nonce:integer
    )
    (defschema SCR|NF|Schema
        trait-score-value:decimal   ;;[M]   Score Value of DPNF Trait
        ;;
        ;;Select Keys
        score-id:string
        dpnf-id:string
        trait-key:string
        trait-value:string
    )
    ;;
    ;;{2}
    ;;Score ID
    ;;1]Global and 2]Individual
    (deftable SCR|T|Score:{SCR|Schema})                         ;;Key = <Score-ID>
    (deftable SCR|T|UserScore:{SCR|UserSchema})                 ;;Key = <Ouronet-Account> | <Pool-ID> | <Score-ID>
    ;;
    ;;Score Definitions for SFT and NFT
    (deftable SCR|T|SF|Score:{SCR|SF|Schema})                   ;;Key = <Score-ID> | <DPSF-ID> | <Nonce>
    (deftable SCR|T|NF|Score:{SCR|NF|Schema})                   ;;Key = <Score-ID> | <DPNF-ID> | <Trait-Key> | <Trait-Value>
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
    (defun C_IssueLiquidityScore:object{IgnisCollectorV2.OutputCumulator}
        (

        )
        @doc ""
        true
    )
    (defun C_IssueTrueFungibleScore:object{IgnisCollectorV2.OutputCumulator}
        (

        )
        @doc ""
        true
    )
    (defun C_IssueOrtoFungibleScore:object{IgnisCollectorV2.OutputCumulator}
        (

        )
        @doc ""
        true
    )
    (defun C_IssueSemiFungibleScore:object{IgnisCollectorV2.OutputCumulator}
        (

        )
        @doc ""
        true
    )
    (defun C_IssueNonFungibleScore:object{IgnisCollectorV2.OutputCumulator}
        (

        )
        @doc ""
        true
    )
    ;;
    (defun C_RotateOwnership:object{IgnisCollectorV2.OutputCumulator} 
        ()
        @doc ""
        true
    )
    (defun C_Control:object{IgnisCollectorV2.OutputCumulator}
        ()
        @doc ""
        true
    )
    ;;
    (defun C_CreateAnchorLink:object{IgnisCollectorV2.OutputCumulator}
        ()
        @doc ""
        true
    )
    (defun C_CreateBoostLink:object{IgnisCollectorV2.OutputCumulator}
        ()
        @doc ""
        true
    )
    ;;
    (defun C_EnableDebBoost:object{IgnisCollectorV2.OutputCumulator}
        ()
        @doc ""
        true
    )
    (defun C_SetScoreMultipliers:object{IgnisCollectorV2.OutputCumulator}
        ()
        @doc ""
        true
    )
    (defun C_SetScoreSftEquality:object{IgnisCollectorV2.OutputCumulator}
        ()
        @doc ""
        true
    )
    (defun C_SetScoreNftModel:object{IgnisCollectorV2.OutputCumulator}
        ()
        @doc ""
        true
    )
    (defun C_SetScoreNftTraitKeys:object{IgnisCollectorV2.OutputCumulator}
        ()
        @doc ""
        true
    )
    ;;
    (defun C_IssueSemiFungibleScoreDefinition:object{IgnisCollectorV2.OutputCumulator}
        ()
        @doc ""
        true
    )
    (defun C_IssueNonFungibleScoreDefinition:object{IgnisCollectorV2.OutputCumulator}
        ()
        @doc ""
        true
    )
    ;;
    ;;{F7}  [X]
    (defun XE_CreateAqpoolLink:object{IgnisCollectorV2.OutputCumulator}
        ()
        @doc ""
        true
    )
    (defun XE_CreateFvtLink:object{IgnisCollectorV2.OutputCumulator}
        ()
        @doc ""
        true
    )
    ;;
    (defun XE_RevokeAqpoolLink:object{IgnisCollectorV2.OutputCumulator}
        ()
        @doc ""
        true
    )
    (defun XE_RevokeFvtLink:object{IgnisCollectorV2.OutputCumulator}
        ()
        @doc ""
        true
    )
    ;;
    (defun XE_UpdateUserScore
        ()
        @doc ""
        true
    )
    ;;
)

(create-table P|T)
(create-table P|MT)
;;
(create-table SCR|T|Score)
(create-table SCR|T|UserScore)
(create-table SCR|T|SF|Score)
(create-table SCR|T|NF|Score)