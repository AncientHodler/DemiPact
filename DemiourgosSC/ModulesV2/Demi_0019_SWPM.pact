;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module SWPM GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_SWPM           (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_SWPM           (keyset-ref-guard SWP.SWP|SC_KEY))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|SWPM_ADMIN))
    )
    (defcap GOV|SWPM_ADMIN ()
        (enforce-one
            "SWPM Swapper Admin not satisfed"
            [
                (enforce-guard GOV|MD_SWPM)
                (enforce-guard GOV|SC_SWPM)
            ]
        )
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    (defcap P|SWPM|CALLER ()
        true
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|SWPM_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        (SWP.P|A_Add
            "SWPM|Caller"
            (create-capability-guard (P|SWPM|CALLER))
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
    (defcap COMPOSE ()
        true
    )
    ;;{5}
    ;;{6}
    ;;{7}
    ;;
    ;;{8}
    ;;{9}
    ;;{10}
    ;;{11}
    ;;{12}
    ;;{13}
    ;;
    ;;{14}
    ;;{15}
    (defun SWPM|C_ChangeOwnership (patron:string swpair:string new-owner:string)
        (with-capability (P|SWPM|CALLER)
            (SWP.SWP|X_ChangeOwnership swpair new-owner)
            (DALOS.IGNIS|C_Collect patron (SWP.SWP|UR_OwnerKonto swpair) (DALOS.DALOS|UR_UsagePrice "ignis|biggest"))
        )
    )
    (defun SWPM|C_ModifyCanChangeOwner (patron:string swpair:string new-boolean:bool)
        (with-capability (P|SWPM|CALLER)
            (SWP.SWP|X_ModifyCanChangeOwner swpair new-boolean)
            (DALOS.IGNIS|C_Collect patron (SWP.SWP|UR_OwnerKonto swpair) (DALOS.DALOS|UR_UsagePrice "ignis|biggest"))
        )
    )
    (defun SWPM|C_ToggleAddOrSwap (patron:string swpair:string toggle:bool add-or-swap:bool)
        @doc "When Toggle is true, ensure required Mint, Burn, Transfer Roles are set, if not, set them \
        \ Mint and Burn Roles for LP Token (requires LP Token Ownership) \
        \ Fee Exemption Roles for all Tokens of a Stable Pool, or \
        \ for all Tokens of a Product Pool, except its first Token (which is principal) \
        \ Roles are needed to SWP.SWP|SC_NAME"
        (with-capability (P|SWPM|CALLER)
            (if toggle
                (let*
                    (
                        (pt-ids:[string] (SWP.SWP|UR_PoolTokens swpair))
                        (amp:decimal (SWP.SWP|UR_Amplifier swpair))
                        (ptts:[string]
                            (if (= amp -1.0)
                                (drop 1 pt-ids)
                                pt-ids
                            )
                        )
                        (swp:string SWP.SWP|SC_NAME)
                        (lp-id:string (SWP.SWP|UR_TokenLP swpair))
                        (lp-burn-role:bool (DPTF.DPTF|UR_AccountRoleBurn lp-id swp))
                        (lp-mint-role:bool (DPTF.DPTF|UR_AccountRoleMint lp-id swp))
                    )
                    (if (not lp-burn-role)
                        (ATSI.DPTF|C_TgBurnR patron lp-id swp true)
                        true
                    )
                    (if (not lp-mint-role)
                        (ATSI.DPTF|C_TgMintR patron lp-id swp true)
                        true
                    )
                    (map
                        (lambda
                            (idx:integer)
                            (if (not (DPTF.DPTF|UR_AccountRoleFeeExemption (at idx ptts) swp))
                                (ATSI.DPTF|C_TgFeeExemptionR patron (at idx ptts) swp true)
                                true
                            )
                        )
                        (enumerate 0 (- (length ptts) 1))
                    )
                )
                true
            )
            (SWP.SWP|X_CanAddOrSwapToggle swpair toggle add-or-swap)
            (DALOS.IGNIS|C_Collect patron (SWP.SWP|UR_OwnerKonto swpair) (DALOS.DALOS|UR_UsagePrice "ignis|medium"))
        )
    )
    (defun SWPM|C_ModifyWeights (patron:string swpair:string new-weights:[decimal])
        (with-capability (P|SWPM|CALLER)
            (SWP.SWP|X_ModifyWeights swpair new-weights)
            (DALOS.IGNIS|C_Collect patron (SWP.SWP|UR_OwnerKonto swpair) (DALOS.DALOS|UR_UsagePrice "ignis|biggest"))
        )
    )
    (defun SWPM|C_ToggleFeeLock (patron:string swpair:string toggle:bool)
        (enforce-guard (P|UR "TALOS|Summoner"))
        (with-capability (P|SWPM|CALLER)
            (let*
                (
                    (swpair-owner:string (SWP.SWP|UR_OwnerKonto swpair))
                    (g1:decimal (DALOS.DALOS|UR_UsagePrice "ignis|small"))
                    (toggle-costs:[decimal] (SWP.SWP|X_ToggleFeeLock swpair toggle))
                    (g2:decimal (at 0 toggle-costs))
                    (gas-costs:decimal (+ g1 g2))
                    (kda-costs:decimal (at 1 toggle-costs))
                )
                (DALOS.IGNIS|C_Collect patron swpair-owner gas-costs)
                (if (> kda-costs 0.0)
                    (with-capability (COMPOSE)
                        (SWP.SWP|X_IncrementFeeUnlocks swpair)
                        (DALOS.KDA|C_Collect patron kda-costs)
                    )
                    true
                )
            )
        )
    )
    (defun SWPM|C_UpdateLP (patron:string swpair:string lp-token:string add-or-remove:bool)
        (with-capability (P|SWPM|CALLER)
            (SWP.SWP|X_UpdateLP swpair lp-token add-or-remove)
            (DALOS.IGNIS|C_Collect patron (SWP.SWP|UR_OwnerKonto swpair) (DALOS.DALOS|UR_UsagePrice "ignis|biggest"))
        )
    )
    (defun SWPM|C_UpdateFee (patron:string swpair:string new-fee:decimal lp-or-special:bool)
        (with-capability (P|SWPM|CALLER)
            (SWP.SWP|X_UpdateFee swpair new-fee lp-or-special)
            (DALOS.IGNIS|C_Collect patron (SWP.SWP|UR_OwnerKonto swpair) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun SWPM|C_UpdateSpecialFeeTargets (patron:string swpair:string targets:[object{SWP.SWP|FeeSplit}])
        (with-capability (P|SWPM|CALLER)
            (SWP.SWP|X_UpdateSpecialFeeTargets swpair targets)
            (DALOS.IGNIS|C_Collect patron (SWP.SWP|UR_OwnerKonto swpair) (DALOS.DALOS|UR_UsagePrice "ignis|medium"))
        )
    )
    (defun SWPM|C_ToggleSpecialMode (patron:string swpair:string)
        (with-capability (P|SWPM|CALLER)
            (SWP.SWP|X_ToggleSpecialMode swpair)
            (DALOS.IGNIS|C_Collect patron (SWP.SWP|UR_OwnerKonto swpair) (DALOS.DALOS|UR_UsagePrice "ignis|medium"))
        )
    )
    (defun SWPM|C_RotateGovernor (patron:string swpair:string new-gov:guard)
        (with-capability (P|SWPM|CALLER)
            (SWP.SWP|X_UpdateGovernor swpair new-gov)
            (DALOS.IGNIS|C_Collect patron (SWP.SWP|UR_OwnerKonto swpair) (DALOS.DALOS|UR_UsagePrice "ignis|medium"))
        )
    )
    (defun SWPM|C_UpdateAmplifier (patron:string swpair:string amp:decimal)
        (with-capability (P|SWPM|CALLER)
            (SWP.SWP|X_UpdateAmplifier swpair amp)
            (DALOS.IGNIS|C_Collect patron (SWP.SWP|UR_OwnerKonto swpair) (DALOS.DALOS|UR_UsagePrice "ignis|medium"))
        )
    )
    ;;{16}
)

(create-table P|T)