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
        ;;
        ;;Management
        owner-konto:string                                      ;;Stores the Score Owner.
        can-upgrade:string                                      ;;Defines if Score Settings can be upgraded
        can-change-owner:string                                 ;;Defines if the Owner can be changed
        ;;
        ;; Links
        anchor-link:string                                      ;;Specifies the Anchor ID that is to boost the score.
        boost-link:string                                       ;;Specifies the Score ID that is used as Base for the Boosted Score.
        aqpool-link:string                                      ;;Specifies the Pool that employs the Score.
        fvt-link:string                                         ;;Specifies the FVT the Score is part of.
        ;;Score Information
        deb-boost:bool                                          ;;Specifies if DEB boosting occurs.
        base-score-id:string                                    ;;Stores the Score ID for the Base. BAR if it uses its own Base.
        total-base-score:string                                 ;;Sum of all Entities Scores, 24 prec
        total-boosted-score:string                              ;;Sum of all Entities Boosted Scores, 24 prec
        total-deb-score:string                                  ;;Sum of all Entities Final Score, 24 prec
        nzs-count:integer
        ;;
        ;;Score Class
        score-class:integer                                     ;;Defines the Score Class, there are 5
                                                                ;;Class 0 = LP Score (LP - native|sleeping|freezing)
                                                                ;;Class 1 = DPTF Score (non LP) 
                                                                ;;Class 2 = DPOF Score (non LP)
                                                                ;;Class 3 = DPSF Score (SFTs)
                                                                ;;Class 4 = DPNF Score (NFTs)
        ;;
        ;;DPTF & DPOF
        mx-frozen:decimal                                       ;;Multiplier for Frozen Tokens (Default 2.0)
        mx-sleeping:decimal                                     ;;Multiplier for Sleeping Tokens (Default 1.0)
        mx-hibernated:decimal                                   ;;Multiplier for Hibernated Tokens (Default 1.0)
        ;;
        ;;DPSF
        sft-equality:bool                                       ;;When true all SFTs are equal. When <false>, <nonce-score-value> is checked.
        ;;
        ;;DPNF
        nft-score-model:integer                                 ;;Sets NFT Score Model; Omly 3 Models Allowed [-1 0 1]
                                                                ;;Model -1 = All NFTs are equal, and will have a score of 1
                                                                ;;Model  0 = NFTs will be scored by their native Score Systems
                                                                ;;Model  1 = NFTs will be scored based on Scores defined per Trait <trait-score-value>
                                                                ;;(Multiple Traits can be used, must be specified in the key below)
        nft-trait-keys:[string]                                 ;;Specifies which NFT Traits will be used for scoring.
        ;;
        ;;Select Keys
        score-id:string                                         ;;Stores the ID of the Score
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
        nonce-score-value:decimal                               ;;Score Value of DPSF Nonce
        ;;
        ;;Select Keys
        score-id:string
        dpsf-id:string
        nonce:integer
    )
    (defschema SCR|NF|Schema
        trait-score-value:decimal                               ;;Promile of Trait
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
    ;;
    
    ;;
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)
;;
(create-table SCR|T|Score)
(create-table SCR|T|UserScore)
(create-table SCR|T|SF|Score)
(create-table SCR|T|NF|Score)