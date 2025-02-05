;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module SWPS GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_SWPS           (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_SWPS           (keyset-ref-guard SWP.SWP|SC_KEY))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|SWPS_ADMIN))
    )
    (defcap GOV|SWPS_ADMIN ()
        (enforce-one
            "SWPS Swapper Admin not satisfed"
            [
                (enforce-guard GOV|MD_SWPS)
                (enforce-guard GOV|SC_SWPS)
            ]
        )
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    (defcap P|SWPS|CALLER ()
        true
    )
    (defcap P|SWPS|REMOTE-GOV ()
        true
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|SWPS_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        true
        (SWP.P|A_Add
            "SWPS|Caller"
            (create-capability-guard (P|SWPS|CALLER))
        )
        (SWP.P|A_Add
            "SWPS|RemoteSwapGovernor"
            (create-capability-guard (P|SWPS|REMOTE-GOV))
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
    ;;{16}
    (defcap SWPS|C>SWAP (swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (let
            (
                (l1:integer (length input-ids))
                (l2:integer (length input-amounts))
                (can-swap:bool (SWP.SWP|UR_CanSwap swpair))
                (izo:bool (SWPT.SWPT|UC_IzOnPool output-id swpair))
            )
            (enforce izo (format "{} is not part of SwapPool {}" [output-id swpair]))
            (enforce can-swap (format "Pool {} swap functionality is inactive: cannot Swap Tokens" [swpair]))
            (enforce (= l1 l2) "Invalid input Values")
            (SWP.SWP|UEV_id swpair)
            (map
                (lambda 
                    (idx:integer)
                    (let*
                        (
                            (id:string (at idx input-ids))
                            (amount:decimal (at idx input-amounts))
                            (iop:bool (SWPT.SWPT|UC_IzOnPool id swpair))
                        )
                        (enforce iop (format "Input Token id {} is not part of Liquidity Pool {}" [id swpair]))
                        (DPTF.DPTF|UEV_Amount id amount)
                    )
                )
                (enumerate 0 (- l1 1))
            )
            (compose-capability (P|SWPS|REMOTE-GOV))
            (compose-capability (P|SWPS|CALLER))
        )
    )
    (defun SWPS|UC_PrimalPool:string ()
        (let
            (
                (dlk:string (DALOS.DALOS|UR_LiquidKadenaID))
                (ouro:string (DALOS.DALOS|UR_OuroborosID))
                (dwk:string (DALOS.DALOS|UR_WrappedKadenaID))
                (u:string UTILS.BAR)
            )
            (concat ["W" u dlk u ouro u dwk])
        )
    )
    (defun SWPS|UC_InputAmounts:[decimal] (input-ids:[string] input-amounts:[decimal] supra:decimal sub:decimal)
        (fold
            (lambda
                (acc:[decimal] idx:integer)
                (UTILS.LIST|UC_AppendLast 
                    acc
                    (floor (* (at idx input-amounts) (/ supra sub)) (DPTF.DPTF|UR_Decimals (at idx input-ids)))
                )
            )
            []
            (enumerate 0 (- (length input-amounts) 1))
        )
    )
    (defun SWPS|C_SimpleSwap (patron:string account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (with-capability (SWPS|C>SWAP swpair input-ids input-amounts output-id)
            ;;
            (let*
                (
                    (dlk:string (DALOS.DALOS|UR_LiquidKadenaID))
                    (op:integer (DPTF.DPTF|UR_Decimals output-id))
                    (major:integer (DALOS.DALOS|UR_Elite-Tier-Major patron))
                    (minor:integer (DALOS.DALOS|UR_Elite-Tier-Minor patron))
    
                    (lb:bool (SWP.SWP|UR_LiquidBoost))
                    (lp-fee:decimal (SWP.SWP|UR_FeeLP swpair))
                    (boost-fee:decimal (if lb lp-fee 0.0))
                    (special-fee:decimal (SWP.SWP|UR_FeeSP swpair))
    
                    (f1:decimal (UTILS.DALOS|UC_GasCost lp-fee major minor false))
                    (f2:decimal (UTILS.DALOS|UC_GasCost boost-fee major minor false))
                    (f3:decimal (UTILS.DALOS|UC_GasCost special-fee major minor false))
                    (tf:decimal (fold (+) 0.0 [f1 f2 f3]))
                    (rest:decimal (- 1000.0 tf))
                    (input-split:[decimal] [f1 f2 f3 rest])
                    (x:[decimal] (drop 1 input-split))
                    (s:decimal (fold (+) 0.0 x))
    
                    (input-amounts-for-swap:[decimal] (SWPS|UC_InputAmounts input-ids input-amounts s 1000.0))
                    (total-swap-output-amount:decimal (SWPSC.SWPSC|URC_Swap swpair input-ids input-amounts-for-swap output-id))
                    
                    (boost-output:decimal (floor (* (/ f2 s) total-swap-output-amount) op))
                    (special-output:decimal (floor (* (/ f3 s) total-swap-output-amount) op))
                    (rest-output:decimal (- total-swap-output-amount (+ boost-output special-output)))

                    (pool-token-ids:[string] (SWP.SWP|UR_PoolTokens swpair))
                    (pool-token-supplies:[decimal] (SWP.SWP|UR_PoolTokenSupplies swpair))
                    (pool-token-precisions:[integer] (SWP.SWP|UR_PoolTokenPrecisions swpair))
                    (updated-supplies:[decimal]
                        (fold
                            (lambda
                                (acc:[decimal] idx:integer)
                                (UTILS.LIST|UC_AppendLast 
                                    acc
                                    (let*
                                        (
                                            (id:string (at idx pool-token-ids))
                                            (amount:decimal (at idx pool-token-supplies))
                                            (iz-on-input:bool (contains id input-ids))
                                            (iz-output:bool (= id output-id))
                                        )
                                        (if iz-output
                                            (- amount total-swap-output-amount)
                                            (if iz-on-input
                                                (+ 
                                                    amount
                                                    (at (at 0 (UTILS.LIST|UC_Search input-ids id)) input-amounts)
                                                )
                                                amount
                                            )
                                        )
                                    )
                                )
                            )
                            []
                            (enumerate 0 (- (length pool-token-supplies) 1))
                        )
                    )
                )
                ;;Account Transfers all <input-ids> with <input-amounts> to SWP|SC_NAME
                (TFT.DPTF|C_MultiTransfer patron input-ids account SWP.SWP|SC_NAME input-amounts true)
                ;;SWP.SWP|SC_NAME transfer the resulted <output-id> to <special-fee targets> (if special-fee is non zero) and <account>
                (if (= special-fee 0.0)
                    (TFT.DPTF|C_Transfer patron output-id SWP.SWP|SC_NAME account rest-output true)
                    (let*
                        (
                            (sft:[string] (SWP.SWP|UR_SpecialFeeTargets swpair))
                            (sftp:[decimal] (SWP.SWP|UR_SpecialFeeTargetsProportions swpair))
                            (l:integer (length sft))
                        )
                        (if (= l 1)
                            (TFT.DPTF|C_BulkTransfer patron output-id SWP.SWP|SC_NAME [+ sft [account]] [special-output rest-output] true)
                            (let*
                                (
                                    (s:decimal (fold (+) 0.0 sftp))
                                    (sftpwl:[decimal] (drop -1 sftp))
                                    (pl:[decimal]
                                        (fold
                                            (lambda
                                                (acc:[decimal] idx:integer)
                                                (UTILS.LIST|UC_AppendLast 
                                                    acc
                                                    (floor (* (/ (at idx sftpwl) s) special-output) op)
                                                )
                                            )
                                            []
                                            (enumerate 0 (- (length sftpwl) 1))
                                        )
                                    )
                                    (pls:decimal (fold (+) 0.0 pl))
                                    (last:decimal (- special-output pls))
                                    (sta:[decimal] (UTILS.LIST|UC_AppendLast pl last))
                                )
                                (TFT.DPTF|C_BulkTransfer patron output-id SWP.SWP|SC_NAME (+ sft [account]) (+ sta [rest-output]) true)
                            )
                        )
                    )
                )
                ;;Update Pools Supplies on current pool.
                (SWP.SWP|X_UpdateSupplies swpair updated-supplies)
                ;;Burn the DLK Amount to pump Liquid Index, and update Required Pools.
                (if (!= boost-output 0.0)
                    (SPWS|X_PumpLiquidIndex patron output-id boost-output)
                    true
                )
                [boost-output special-output rest-output]
            )
        )
    )
    (defun SPWS|X_PumpLiquidIndex (patron:string id:string amount:decimal)
        (let
            (
                (dlk:string (DALOS.DALOS|UR_LiquidKadenaID))
            )
            (if (= id dlk)
                (DPTF.DPTF|C_Burn patron id SWP.SWP|SC_NAME amount)
                (let
                    (
                        (ewo:object{NEOV} (SWPS|URC_Neov id amount dlk))
                        (path-to-dlk:[string] (at "nodes" ewo))
                        (edges:[string] (at "edges" ewo))
                        (ovs:[decimal] (at "output-values" ewo))
                        (final-boost-output:decimal (at 0 (take -1 ovs)))
                    )
                    (DPTF.DPTF|C_Burn patron dlk SWP.SWP|SC_NAME final-boost-output)
                    (map
                        (lambda 
                            (idx:integer)
                            (let*
                                (
                                    (first-id:string (at idx path-to-dlk))
                                    (second-id:string (at (+ idx 1) path-to-dlk))
                                    (hop:string (at idx edges))
                                    (first-amount:decimal 
                                        (if (= idx 0)
                                            amount
                                            (at (- idx 1) ovs)
                                        )
                                    )
                                    (second-amount:decimal (at idx ovs))
                                    (f-id-hop-a:decimal (SWP.SWP|UR_PoolTokenSupply hop first-id))
                                    (s-id-hop-a:decimal (SWP.SWP|UR_PoolTokenSupply hop second-id))
                                )
                                (SWP.SWP|X_UpdateSupply hop first-id (+ f-id-hop-a first-amount))
                                (SWP.SWP|X_UpdateSupply hop second-id (- s-id-hop-a second-amount))
                            )
                        )
                        (enumerate 0 (- (length edges) 1))
                    )
                )
            )
        )
    )
    ;;
    (defconst EMPTY_NEOV
        [
            {
                "nodes" : [],
                "edges" : [],
                "output-values" : []
            }
        ]
    )
    (defschema NEOV
        nodes:[string]
        edges:[string]
        output-values:[decimal]
    )
    (defun SWPS|URC_Neov:object{NEOV} (id:string ia:decimal vid:string)
        (let*
            (
                (nodes:[string] (SWPT.GRPH|URC_ComputePath id vid))
                (fl:[object{NEOV}]
                    (fold
                        (lambda
                            (acc:[object{NEOV}] idx:integer)
                            (UTILS.LIST|UC_ReplaceAt
                                acc
                                0
                                (let*
                                    (
                                        (input:decimal
                                            (if (= idx 0)
                                                ia
                                                (at 0 (take -1 (at "output-values" (at 0 acc))))
                                            )
                                        )
                                        (i-id:string (at idx nodes))
                                        (o-id:string (at (+ idx 1) nodes))
                                        (best-edge:string (SWPS|URC_BestEdge input i-id o-id))
                                        (output:decimal (SWPSC.SWPSC|URC_Swap best-edge [i-id] [input] o-id))
                                    )
                                    {
                                        "nodes"         : nodes,
                                        "edges"         : (UTILS.LIST|UC_AppendLast (at "edges" (at 0 acc)) best-edge),
                                        "output-values" : (UTILS.LIST|UC_AppendLast (at "output-values" (at 0 acc)) output)
                                    }
                                )
                            )
                        )
                        EMPTY_NEOV
                        (enumerate 0 (- (length nodes) 2))
                    )
                )
            )
            (at 0 fl)
        )
    )
    (defun SWPS|URC_BestEdge:string (ia:decimal i:string o:string)
        (let*
            (
                (edges:[string] (SWPT.SWPT|URC_Edges i o))
                (svl:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (UTILS.LIST|UC_AppendLast 
                                acc
                                (SWPSC.SWPSC|URC_Swap (at idx edges) [i] [ia] o)
                            )
                        )
                        []
                        (enumerate 0 (- (length edges) 1))
                    )
                )
                (sp:integer
                    (fold
                        (lambda
                            (acc:integer idx:integer)
                            (if (= idx 0)
                                acc
                                (if (< (at idx svl) (at acc svl))
                                    idx
                                    acc
                                )
                            )
                        )
                        0
                        (enumerate 0 (- (length svl) 1))
                    )
                )
            )
            (at sp edges)
        )
    )
)

(create-table P|T)