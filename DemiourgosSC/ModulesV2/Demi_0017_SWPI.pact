(module SWPI GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (SWPI-ADMIN))
    )
    (defcap SWPI-ADMIN ()
        (enforce-one
            "SWPI Swapper Admin not satisfed"
            [
                (enforce-guard G-MD_SWPI)
                (enforce-guard G-SC_SWPI)
            ]
        )
    )

    (defconst G-MD_SWPI   (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_SWPI   (keyset-ref-guard SWP.SWP|SC_KEY))

    (defcap COMPOSE ()
        true
    )
    (defcap SECURE ()
        true
    )
    (defcap P|SWPI|CALLER ()
        true
    )
    (defcap P|SWPI|REMOTE-GOV ()
        true
    )
    ;;
    (defun A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (SWPI-ADMIN)
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
            "SWPI|Caller"
            (create-capability-guard (P|SWPI|CALLER))
        )
        (SWP.A_AddPolicy
            "SWPI|Caller"
            (create-capability-guard (P|SWPI|CALLER))
        )
        (SWPT.P|A_Add
            "SWPI|Caller"
            (create-capability-guard (P|SWPI|CALLER))
        )
        (SWP.A_AddPolicy
            "SWPI|RemoteSwapGovernor"
            (create-capability-guard (P|SWPI|REMOTE-GOV))
        )
    )
    (deftable PoliciesTable:{DALOS.PolicySchema})
    ;;
    (defcap SWPI|ISSUE (account:string pool-tokens:[object{SWP.SWP|PoolTokens}] fee-lp:decimal amp:decimal)
        (let*
            (
                (l:integer (length pool-tokens))
                (principals:[string] (SWP.SWP|UR_Principals))
                (pt-ids:[string] (SWP.SWP|UC_ExtractTokens pool-tokens))
                (ptte:[string]
                    (if (= amp -1)
                        (drop 1 pt-ids)
                        pt-ids
                    )
                )
                (iz-principal:bool (contains (at 0 pt-ids) principals))
            )
            (compose-capability (P|SWPI|REMOTE-GOV))
            (compose-capability (P|SWPI|CALLER))
            ;;
            (SWP.SWP|UEV_PoolFee fee-lp)
            (SWP.SWP|UEV_New pt-ids amp)
            (map
                (lambda
                    (id:string)
                    (BASIS.DPTF-DPMF|CAP_Owner id true)
                )
                ptte
            )
            ;;
            (if (= amp -1.0)
                (enforce iz-principal "First Token is not a principal Token")
                true
            )
            (enforce (or (= amp -1.0) (>= amp 1.0)) "Invalid Amplifier value")
            (enforce (and (>= l 2) (<= l 7)) "A min of 2 and a max of 7 Tokens can be used to create a Swap Pair")
        )
    )
    (defun SWPI|C_IssueStandard:string (patron:string account:string pool-tokens:[object{SWP.SWP|PoolTokens}] fee-lp:decimal)
        (SWPI|C_IssueStable patron account pool-tokens fee-lp -1.0)
    )
    (defun SWPI|UC_LpComposer:[string] (pool-tokens:[object{SWP.SWP|PoolTokens}] amp:decimal)
        (let*
            (
                (pool-token-ids:[string] (SWP.SWP|UC_ExtractTokens pool-tokens))
                (l:integer (length pool-token-ids))
                (pool-token-names:[string]
                    (fold
                        (lambda
                            (acc:[string] idx:integer)
                            (UTILS.LIST|UC_AppendLast 
                                acc 
                                (BASIS.DPTF-DPMF|UR_Name (at idx pool-token-ids) true)
                            )
                        )
                        []
                        (enumerate 0 (- l 1))
                    )
                )
                (pool-token-tickers:[string]
                    (fold
                        (lambda
                            (acc:[string] idx:integer)
                            (UTILS.LIST|UC_AppendLast 
                                acc 
                                (BASIS.DPTF-DPMF|UR_Ticker (at idx pool-token-ids) true)
                            )
                        )
                        []
                        (enumerate 0 (- l 1))
                    )
                )
            )
            (SUT.SWP|UC_LP pool-token-names pool-token-tickers amp)
        )
    )
    (defun SWPI|C_IssueStable:[string] (patron:string account:string pool-tokens:[object{SWP.SWP|PoolTokens}] fee-lp:decimal amp:decimal)
        (with-capability (SWPI|ISSUE account pool-tokens fee-lp amp)
            (let*
                (
                    (kda-dptf-cost:decimal (DALOS.DALOS|UR_UsagePrice "dptf"))
                    (kda-swp-cost:decimal (DALOS.DALOS|UR_UsagePrice "swp"))
                    (kda-costs:decimal (+ kda-dptf-cost kda-swp-cost))
                    (gas-swp-cost:decimal (DALOS.DALOS|UR_UsagePrice "ignis|swp-issue"))
                    (pool-token-ids:[string] (SWP.SWP|UC_ExtractTokens pool-tokens))
                    (pool-token-amounts:[decimal] (SWP.SWP|UC_ExtractTokenSupplies pool-tokens))
                    (lp-name-ticker:[string] (SWPI|UC_LpComposer pool-tokens amp))
                    (token-lp:string (BASIS.DPTF|C_IssueLP patron account (at 0 lp-name-ticker) (at 1 lp-name-ticker)))
                    (swpair:string (SWPI|X_Issue account pool-tokens token-lp fee-lp amp))
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
                (SWPT.SWPT|X_MultiPathTracer swpair)
                [swpair token-lp]
            )
        )
    )
    ;;
    (defun SWPI|X_Issue:string (account:string pool-tokens:[object{SWP.SWP|PoolTokens}] token-lp:string fee-lp:decimal amp:decimal)
        (let
            (
                (token-ids:[string] (SWP.SWP|UC_ExtractTokens pool-tokens))
            )
            (SWP.SWP|X_InsertNew account pool-tokens token-lp fee-lp amp)
            (BASIS.DPTF-DPMF|C_DeployAccount token-lp account true)
            (BASIS.DPTF-DPMF|C_DeployAccount token-lp SWP.SWP|SC_NAME true)
            (map
                (lambda
                    (id:string)
                    (BASIS.DPTF-DPMF|C_DeployAccount id SWP.SWP|SC_NAME true)
                )
                (drop 1 token-ids)
            )
            (SUT.SWP|UC_Swpair token-ids amp)
        )
    )
)

(create-table PoliciesTable)