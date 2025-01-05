(module SWPM GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (SWPM-ADMIN))
    )
    (defcap SWPM-ADMIN ()
        (enforce-one
            "SWPM Autostake Admin not satisfed"
            [
                (enforce-guard G-MD_SWPM)
                (enforce-guard G-SC_SWPM)
            ]
        )
    )

    (defconst G-MD_SWPM   (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_SWPM   (keyset-ref-guard SWP.SWP|SC_KEY))

    (defcap COMPOSE ()
        true
    )
    (defcap SECURE ()
        true
    )
    (defcap P|SWPM|CALLER ()
        true
    )
    ;;
    (defun A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (SWPM-ADMIN)
            (write PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun C_ReadPolicy:guard (policy-name:string)
        (at "policy" (read PoliciesTable policy-name ["policy"]))
    )
    (defun DefinePolicies ()
        (BASIS.A_AddPolicy
            "SWPM|Caller"
            (create-capability-guard (P|SWPM|CALLER))
        )
        (SWP.A_AddPolicy
            "SWPM|Caller"
            (create-capability-guard (P|SWPM|CALLER))
        )
    )
    (deftable PoliciesTable:{DALOS.PolicySchema})
    ;;

    
    (defun SWPM|X_Issue:string (account:string pool-tokens:[object{SWP.SWP|PoolTokens}] token-lp:string fee-lp:decimal amp:decimal)
        (SWP.SWP|X_InsertNew account pool-tokens token-lp fee-lp amp)
        (BASIS.DPTF-DPMF|C_DeployAccount token-lp account true)
        (BASIS.DPTF-DPMF|C_DeployAccount token-lp SWP.SWP|SC_NAME true)
        (map
            (lambda
                (id:string)
                (BASIS.DPTF-DPMF|C_DeployAccount id SWP.SWP|SC_NAME true)
            )
            (drop 1 (SWP.SWP|UC_ExtractTokens pool-tokens))
        )
        (SWP.SWP|UC_Swpair pool-tokens amp)
    )
    (defcap SWPM|ISSUE (account:string pool-tokens:[object{SWP.SWP|PoolTokens}] fee-lp:decimal amp:decimal)
        (let*
            (
                (l:integer (length pool-tokens))
                (principals:[string] (SWP.SWP|UR_Principals))
                (token-ids:[string] (SWP.SWP|UC_ExtractTokens pool-tokens))
                (iz-principal:bool (contains (at 0 token-ids) principals))
            )
            (enforce iz-principal "Token-A is not a principal Token")
            (enforce (and (>= l 2) (<= l 7)) "A min of 2 and a max of 7 Tokens can be used to create a Swap Pair")
            (SWP.SWP|UEV_PoolFee fee-lp)
            (map
                (lambda
                    (id:string)
                    (BASIS.DPTF-DPMF|CAP_Owner id true)
                )
                (drop 1 token-ids)
            )
            (SWP.SWP|UEV_New pool-tokens amp)
            (compose-capability (P|SWPM|CALLER))
        )
    )
    (defun SWPM|C_IssueStandard:string (patron:string account:string pool-tokens:[object{SWP.SWP|PoolTokens}] fee-lp:decimal)
        (SWPM|C_IssueStable patron account pool-tokens fee-lp -1.0)
    )
    (defun SWPM|C_IssueStable:string (patron:string account:string pool-tokens:[object{SWP.SWP|PoolTokens}] fee-lp:decimal amp:decimal)
        (with-capability (SWPM|ISSUE account pool-tokens fee-lp amp)
            (let*
                (
                    (kda-dptf-cost:decimal (DALOS.DALOS|UR_UsagePrice "dptf"))
                    (kda-swp-cost:decimal (DALOS.DALOS|UR_UsagePrice "swp"))
                    (kda-costs:decimal (+ kda-dptf-cost kda-swp-cost))
                    (gas-swp-cost:decimal (DALOS.DALOS|UR_UsagePrice "ignis|swp-issue"))
                    (lp-name-ticker:[string] (SWP.SWP|UC_LP pool-tokens amp))
                    (token-lp:string (BASIS.DPTF|C_IssueLP patron account (at 0 lp-name-ticker) (at 1 lp-name-ticker)))
                    (swpair:string (SWPM|X_Issue account pool-tokens token-lp fee-lp amp))
                    (pool-token-ids:[string] (SWP.SWP|UC_ExtractTokens pool-tokens))
                    (pool-token-amounts:[decimal] (SWP.SWP|UC_ExtractTokenSupplies pool-tokens))
                    (last-ids:[string] (drop 1 pool-token-ids))
                )
                ;;Burn and Mint Role for <token-lp> and FeeEx Role for every token except for first to SWP.SWP|SC_NAME
                (ATSI.DPTF-DPMF|C_ToggleBurnRole patron token-lp SWP.SWP|SC_NAME true true)
                (ATSI.DPTF|C_ToggleMintRole patron token-lp SWP.SWP|SC_NAME true)
                (map
                    (lambda
                        (idx:integer)
                        (if (not (BASIS.DPTF|UR_AccountRoleFeeExemption (at idx last-ids) SWP.SWP|SC_NAME))
                            (ATSI.DPTF|C_ToggleFeeExemptionRole patron (at idx last-ids) SWP.SWP|SC_NAME true)
                            true
                        )
                    )
                    (enumerate 0 (- (length pool-tokens) 2))
                )
                ;;Transfer All Tokens to SWP.SWP|SC_NAME and get 10 million Token-LP in return, minted in origin mode.
                (TFT.DPTF|C_MultiTransfer patron pool-token-ids account SWP.SWP|SC_NAME pool-token-amounts true)
                (BASIS.DPTF|C_Mint patron token-lp SWP.SWP|SC_NAME 10000000.0 true)
                (TFT.DPTF|C_Transfer patron token-lp SWP.SWP|SC_NAME account 10000000.0 true)
                ;;Collect IGNIS for Operation
                (DALOS.IGNIS|C_Collect patron account gas-swp-cost)
                ;;Collect all due KDA for Operation
                (DALOS.KDA|C_Collect patron kda-costs)
                ;;Return Pair ID
                swpair
            )
        )
    )
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
    (defun SWPM|C_ToggleFeeLock (patron:string swpair:string toggle:bool)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
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
)

(create-table PoliciesTable)