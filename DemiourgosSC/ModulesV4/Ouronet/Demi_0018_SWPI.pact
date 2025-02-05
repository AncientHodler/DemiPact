;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module SWPI GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_SWPI           (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_SWPI           (keyset-ref-guard SWP.SWP|SC_KEY))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|SWPI_ADMIN))
    )
    (defcap GOV|SWPI_ADMIN ()
        (enforce-one
            "SWPI Swapper Admin not satisfed"
            [
                (enforce-guard GOV|MD_SWPI)
                (enforce-guard GOV|SC_SWPI)
            ]
        )
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    (defcap P|SWPI|CALLER ()
        true
    )
    (defcap P|SWPI|REMOTE-GOV ()
        true
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|SWPI_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        (DPTF.P|A_Add
            "SWPI|Caller"
            (create-capability-guard (P|SWPI|CALLER))
        )
        (SWP.P|A_Add
            "SWPI|RemoteSwapGovernor"
            (create-capability-guard (P|SWPI|REMOTE-GOV))
        )
        (SWP.P|A_Add
            "SWPI|Caller"
            (create-capability-guard (P|SWPI|CALLER))
        )
        (SWPT.P|A_Add
            "SWPI|Caller"
            (create-capability-guard (P|SWPI|CALLER))
        )
        
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
    ;;{5}
    ;;{6}
    ;;{7}
    (defcap SWPI|C>ISSUE (account:string pool-tokens:[object{SWP.SWP|PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        @event
        (let*
            (
                (l1:integer (length pool-tokens))
                (l2:integer (length weights))
                (ws:decimal (fold (+) 0.0 weights))
                (principals:[string] (SWP.SWP|UR_Principals))
                (pt-ids:[string] (SWP.SWP|UC_ExtractTokens pool-tokens))
                (ptte:[string]
                    (if (= amp -1.0)
                        (drop 1 pt-ids)
                        pt-ids
                    )
                )
                (iz-principal:bool (contains (at 0 pt-ids) principals))
            )
            (SWP.SWP|UEV_PoolFee fee-lp)
            (SWP.SWP|UEV_New pt-ids weights amp)
            (map
                (lambda
                    (id:string)
                    (DPTF.DPTF|CAP_Owner id)
                )
                ptte
            )
            (map
                (lambda
                    (w:decimal)
                    (= (floor w UTILS.FEE_PRECISION) w)
                )
                weights
            )
            (enforce-one
                "Invalid Weight Values"
                [
                    (enforce (= ws 1.0) "Weights must add to exactly 1.0")
                    (enforce (= ws (dec l1)) "Weights must all be 1.0")
                ]
            )
            (if (= amp -1.0)
                (enforce iz-principal "1st Token is not a Principal")
                true
            )
            (enforce (or (= amp -1.0) (>= amp 1.0)) "Invalid amp value")
            (enforce (and (>= l1 2) (<= l1 7)) "2 - 7 Tokens can be used to create a Swap Pair")
            (enforce (= l1 l2) "Number of weigths does not concide with the pool-tokens Number")
        )
        (compose-capability (P|SWPI|REMOTE-GOV))
        (compose-capability (P|SWPI|CALLER))
        (if p
            (compose-capability (GOV|SWPI_ADMIN))
            true
        )
    )
    ;;
    ;;{8}
    ;;{9}
    ;;{10}
    ;;{11}
    ;;{12}
    ;;{13}
    (defun SWPI|URC_LpComposer:[string] (pool-tokens:[object{SWP.SWP|PoolTokens}] weights:[decimal] amp:decimal)
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
                                (DPTF.DPTF|UR_Name (at idx pool-token-ids))
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
                                (DPTF.DPTF|UR_Ticker (at idx pool-token-ids))
                            )
                        )
                        []
                        (enumerate 0 (- l 1))
                    )
                )
            )
            (SUT.SWP|UC_LpID pool-token-names pool-token-tickers weights amp)
        )
    )
    ;;
    ;;{14}
    ;;{15}
    (defun SWPI|C_Issue:[string] (patron:string account:string pool-tokens:[object{SWP.SWP|PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        (with-capability (SWPI|C>ISSUE account pool-tokens fee-lp weights amp p)
            (let*
                (
                    (kda-dptf-cost:decimal (DALOS.DALOS|UR_UsagePrice "dptf"))
                    (kda-swp-cost:decimal (DALOS.DALOS|UR_UsagePrice "swp"))
                    (kda-costs:decimal (+ kda-dptf-cost kda-swp-cost))
                    (gas-swp-cost:decimal (DALOS.DALOS|UR_UsagePrice "ignis|swp-issue"))
                    (pool-token-ids:[string] (SWP.SWP|UC_ExtractTokens pool-tokens))
                    (pool-token-amounts:[decimal] (SWP.SWP|UC_ExtractTokenSupplies pool-tokens))
                    (lp-name-ticker:[string] (SWPI|URC_LpComposer pool-tokens weights amp))
                    (token-lp:string (DPTF.DPTF|C_IssueLP patron account (at 0 lp-name-ticker) (at 1 lp-name-ticker)))
                    (swpair:string (SWPI|X_Issue account pool-tokens token-lp fee-lp weights amp p))
                )
                (TFT.DPTF|C_MultiTransfer patron pool-token-ids account SWP.SWP|SC_NAME pool-token-amounts true)
                (DPTF.DPTF|C_Mint patron token-lp SWP.SWP|SC_NAME 10000000.0 true)
                (TFT.DPTF|C_Transfer patron token-lp SWP.SWP|SC_NAME account 10000000.0 true)
                (DALOS.IGNIS|C_Collect patron account gas-swp-cost)
                (DALOS.KDA|C_Collect patron kda-costs)
                (SWPT.SWPT|X_MultiPathTracer swpair)
                [swpair token-lp]
            )
        )
    )
    ;;{16}
    (defun SWPI|X_Issue:string (account:string pool-tokens:[object{SWP.SWP|PoolTokens}] token-lp:string fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        (let
            (
                (token-ids:[string] (SWP.SWP|UC_ExtractTokens pool-tokens))
            )
            (SWP.SWP|X_InsertNew account pool-tokens token-lp fee-lp weights amp p)
            (DPTF.DPTF|C_DeployAccount token-lp account)
            (DPTF.DPTF|C_DeployAccount token-lp SWP.SWP|SC_NAME)
            (map
                (lambda
                    (id:string)
                    (DPTF.DPTF|C_DeployAccount id SWP.SWP|SC_NAME)
                )
                (drop 1 token-ids)
            )
            (SUT.SWP|UC_PoolID token-ids weights amp)
        )
    )
)

(create-table P|T)