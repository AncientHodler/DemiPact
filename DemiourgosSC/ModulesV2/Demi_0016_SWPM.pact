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
        (SWP.A_AddPolicy
            "SWPM|Caller"
            (create-capability-guard (P|SWPM|CALLER))
        )
    )
    (deftable PoliciesTable:{DALOS.PolicySchema})
    ;;
    (defun SWP|X_Issue:string (account:string token-a:string token-b:string token-lp:string a-init:decimal b-init:decimal fee-lp:decimal)
        (SWP.SWP|X_InsertNewSwapPair account token-a token-b token-lp a-init b-init fee-lp)
        (BASIS.DPTF-DPMF|C_DeployAccount token-lp account true)
        (BASIS.DPTF-DPMF|C_DeployAccount token-b SWP.SWP|SC_NAME true)
        (BASIS.DPTF-DPMF|C_DeployAccount token-lp SWP.SWP|SC_NAME true)
        (concat [token-a UTILS.BAR token-b])
    )
    
    (defcap SWPM|ISSUE (account:string token-a:string token-b:string fee-lp:decimal)
        (compose-capability (P|SWPM|CALLER))
        (BASIS.DPTF-DPMF|CAP_Owner token-b true)
        (SWP.SWP|UEV_PoolFee fee-lp)
        (SWP.SWP|UEV_New token-a token-b)
    )
    (defun SWPM|C_Issue:string 
        (
            patron:string 
            account:string 
            token-a:string 
            token-b:string 
            token-a-amount:decimal
            token-b-amount:decimal
            fee-lp:decimal
        )
        (with-capability (SWPM|ISSUE account token-a token-b fee-lp)
            (let*
                (
                    (kda-dptf-cost:decimal (DALOS.DALOS|UR_UsagePrice "dptf"))
                    (kda-swp-cost:decimal (DALOS.DALOS|UR_UsagePrice "swp"))
                    (kda-costs:decimal (+ kda-dptf-cost kda-swp-cost))
                    (gas-swp-cost:decimal (DALOS.DALOS|UR_UsagePrice "ignis|swp-issue"))
                    
                    (tad:integer (BASIS.DPTF-DPMF|UR_Decimals token-a true))
                    (tbd:integer (BASIS.DPTF-DPMF|UR_Decimals token-b true))
                    (token-lp-decimal:integer (if (> tad tbd) tad tbd))

                    (token-a-name:string (BASIS.DPTF-DPMF|UR_Name token-a true))
                    (token-b-name:string (BASIS.DPTF-DPMF|UR_Name token-b true))
                    (token-a-ticker:string (BASIS.DPTF-DPMF|UR_Ticker token-a true))
                    (token-b-ticker:string (BASIS.DPTF-DPMF|UR_Ticker token-b true))

                    (s1:string "Swap")
                    (s2:string "SW")
                    (l1:integer (floor (/ (dec (- UTILS.MAX_TOKEN_NAME_LENGTH (length s1))) 2.0)))
                    (l2:integer (floor (/ (dec (- UTILS.MAX_TOKEN_TICKER_LENGTH (length s2))) 2.0)))

                    (lp-name:string (concat [s1 (take l1 token-a-name) (take l1 token-b-name)]))
                    (lp-ticker:string (concat [s2 (take l2 token-a-ticker) (take l2 token-b-ticker)]))

                    (dptf-l:[string]
                        (BASIS.DPTF|C_IssueFree
                            patron
                            account
                            [lp-name]
                            [lp-ticker]
                            [token-lp-decimal]
                            [false]
                            [false]
                            [true]
                            [false]
                            [false]
                            [false]
                        )
                    )
                    (token-lp:string (at 0 dptf-l))
                    (swpair:string (SWP|X_Issue account token-a token-b token-lp token-a-amount token-b-amount fee-lp))
                )
                ;;Burn and Mint Role for <token-lp> and FeeEx for token-b to SWP.SWP|SC_NAME
                (ATSI.DPTF-DPMF|C_ToggleBurnRole patron token-lp SWP.SWP|SC_NAME true true)
                (ATSI.DPTF|C_ToggleMintRole patron token-lp SWP.SWP|SC_NAME true)
                (ATSI.DPTF|C_ToggleFeeExemptionRole patron token-b SWP.SWP|SC_NAME true)
                ;;Transfer Token-A and Token-B to SWP.SWP|SC_NAME and get 10 million Token-LP in return, minted in origin mode.
                (TFT.DPTF|C_Transfer patron token-a account SWP.SWP|SC_NAME token-a-amount true)
                (TFT.DPTF|C_Transfer patron token-b account SWP.SWP|SC_NAME token-b-amount true)
                (SWP.SWP|X_UpdateSupply swpair token-a-amount true)
                (SWP.SWP|X_UpdateSupply swpair token-b-amount false)
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