
(module MTX-SWP GOV
    ;;
    (implements OuronetPolicy)
    (implements SwapperMtxV2)
    ;(implements DemiourgosPactDigitalCollectibles-UtilityPrototype)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_MTX-SWP        (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst SWP|SC_NAME           (GOV|SWP|SC_NAME))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|MTX-SWP_ADMIN)))
    (defcap GOV|MTX-SWP_ADMIN ()    (enforce-guard GOV|MD_MTX-SWP))
    ;;
    (defun GOV|SWP|SC_NAME ()       (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|SWP|SC_NAME)))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|MTX-SWP|CALLER ()
        true
    )
    (defcap P|MTX-SWP|REMOTE-GOV ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|MTX-SWP|CALLER))
        (compose-capability (SECURE))
    )
    (defcap P|DT ()
        (compose-capability (P|MTX-SWP|REMOTE-GOV))
        (compose-capability (P|MTX-SWP|CALLER))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|MTX-SWP_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|MTX-SWP_ADMIN)
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
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|DPOF:module{OuronetPolicy} DPOF)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|VST:module{OuronetPolicy} VST)
                (ref-P|ORBR:module{OuronetPolicy} OUROBOROS)
                (ref-P|SWPT:module{OuronetPolicy} SWPT)
                (ref-P|SWP:module{OuronetPolicy} SWP)
                (ref-P|SWPL:module{OuronetPolicy} SWPL)
                (mg:guard (create-capability-guard (P|MTX-SWP|CALLER)))
            )
            (ref-P|VST::P|A_Add
                "MTX-SWP|RemoteSwpGov"
                (create-capability-guard (P|MTX-SWP|REMOTE-GOV))
            )
            (ref-P|SWP::P|A_Add
                "MTX-SWP|RemoteSwpGov"
                (create-capability-guard (P|MTX-SWP|REMOTE-GOV))
            )
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|DPOF::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|ORBR::P|A_AddIMP mg)
            (ref-P|VST::P|A_AddIMP mg)
            (ref-P|SWPT::P|A_AddIMP mg)
            (ref-P|SWP::P|A_AddIMP mg)
            (ref-P|SWPL::P|A_AddIMP mg)
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
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defun CT_EmptyCumulator ()     (let ((ref-IGNIS:module{IgnisCollectorV2} IGNIS)) (ref-IGNIS::DALOS|EmptyOutputCumulatorV2)))
    (defconst BAR                   (CT_Bar))
    (defconst EOC                   (CT_EmptyCumulator))
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
    (defcap MTX-SWP|C>ISSUE-S-POOL (pool-tokens:[object{SwapperV5.PoolTokens}])
        @event
        (compose-capability (SECURE))
    )
    (defcap MTX-SWP|C>ISSUE-W-POOL (pool-tokens:[object{SwapperV5.PoolTokens}])
        @event
        (compose-capability (SECURE))
    )
    (defcap MTX-SWP|C>ISSUE-P-POOL (pool-tokens:[object{SwapperV5.PoolTokens}])
        @event
        (compose-capability (SECURE))
    )
    (defcap MTX-SWP|C>ISSUE (p:bool)
        (compose-capability (P|DT))
        (if p
            (compose-capability (GOV|MTX-SWP_ADMIN))
            true
        )
    )
    ;;
    (defcap MTX-SWP|C>ADD-STANDARD-LQ (swpair:string ld:object{SwapperLiquidityV2.LiquidityData})
        @event
        (compose-capability (MTX-SWP|C>X-ADD-LQ swpair ld))
    )
    (defcap MTX-SWP|C>ADD-ICED-LQ (swpair:string ld:object{SwapperLiquidityV2.LiquidityData})
        @event
        (compose-capability (MTX-SWP|C-ADD-CHILLED-LQ swpair ld))
    )
    (defcap MTX-SWP|C>ADD-GLACIAL-LQ (swpair:string ld:object{SwapperLiquidityV2.LiquidityData})
        @event
        (compose-capability (MTX-SWP|C-ADD-CHILLED-LQ swpair ld))
    )
    (defcap MTX-SWP|C>ADD-FROZEN-LQ 
        (swpair:string frozen-dptf:string ld:object{SwapperLiquidityV2.LiquidityData})
        @event
        (let
            (
                (ref-SWPLC:module{SwapperLiquidityClientV2} SWPLC) 
            )
            (ref-SWPLC::UEV_AddFrozenLiquidity swpair frozen-dptf)
            (compose-capability (MTX-SWP|C-ADD-CHILLED-LQ swpair ld))
        )
    )
    (defcap MTX-SWP|C>ADD-SLEEPING-LQ 
        (account:string swpair:string sleeping-dpof:string nonce:integer ld:object{SwapperLiquidityV2.LiquidityData})
        @event
        (let
            (
                (ref-SWPLC:module{SwapperLiquidityClientV2} SWPLC)
            )
            (ref-SWPLC::UEV_AddSleepingLiquidity account swpair sleeping-dpof nonce)
            (compose-capability (MTX-SWP|C-ADD-DORMANT-LQ swpair ld))
        )
    )
    (defcap MTX-SWP|C-ADD-DORMANT-LQ (swpair:string ld:object{SwapperLiquidityV2.LiquidityData})
        (let
            (
                (ref-SWPLC:module{SwapperLiquidityClientV2} SWPLC)
            )
            (ref-SWPLC::UEV_AddDormantLiquidity swpair)
            (compose-capability (MTX-SWP|C>X-ADD-LQ swpair ld))
        )
    )
    (defcap MTX-SWP|C-ADD-CHILLED-LQ (swpair:string ld:object{SwapperLiquidityV2.LiquidityData})
        (let
            (
                (ref-SWPLC:module{SwapperLiquidityClientV2} SWPLC) 
            )
            (ref-SWPLC::UEV_AddChilledLiquidity swpair ld)
            (compose-capability (MTX-SWP|C>X-ADD-LQ swpair ld))
        )
    )
    (defcap MTX-SWP|C>X-ADD-LQ (swpair:string ld:object{SwapperLiquidityV2.LiquidityData})
        (let
            (
                (ref-SWPLC:module{SwapperLiquidityClientV2} SWPLC) 
            )
            (ref-SWPLC::UEV_AddLiquidity swpair ld)
            (compose-capability (P|DT))
        )
    )
    (defcap MTX-SWP|S>ADD-LQ (kda-pid:decimal)
        @doc "Records the KDA-PID the MTX was initiated with"
        @event
        true
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_PoolState:object{SwapperLiquidityV2.PoolState} (swpair:string)
        (let
            (
                (ref-SWP:module{SwapperV5} SWP)
                (ref-SWPL:module{SwapperLiquidityV2} SWPL)
            )
            (ref-SWPL::UDC_PoolState
                (ref-SWP::UR_Amplifier swpair)
                (ref-SWPL::UDC_PoolFees swpair)
                (ref-SWP::UR_PoolTokenSupplies swpair)
                (ref-SWP::UR_Weigths swpair)
                ;;
                (ref-SWP::URC_LpCapacity swpair)
                (ref-SWP::UR_SpecialFeeTargets swpair)
                (ref-SWP::UR_SpecialFeeTargetsProportions swpair)
            )
        )
    )
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_IssueStablePool
        (patron:string account:string pool-tokens:[object{SwapperV5.PoolTokens}] fee-lp:decimal amp:decimal p:bool)
        (UEV_IMC)
        (with-capability (MTX-SWP|C>ISSUE-S-POOL pool-tokens)
            (MTX|C_Issue
                patron account pool-tokens fee-lp
                (make-list (length pool-tokens) 1.0)
                amp p
            )
        )
    )
    (defun C_IssueWeightedPool
        (patron:string account:string pool-tokens:[object{SwapperV5.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool)
        (UEV_IMC)
        (with-capability (MTX-SWP|C>ISSUE-W-POOL pool-tokens)
            (MTX|C_Issue
                patron account pool-tokens fee-lp
                weights
                -1.0 p
            )
        )
    )
    (defun C_IssueStandardPool
        (patron:string account:string pool-tokens:[object{SwapperV5.PoolTokens}] fee-lp:decimal p:bool)
        (UEV_IMC)
        (with-capability (MTX-SWP|C>ISSUE-P-POOL pool-tokens)
            (MTX|C_Issue
                patron account pool-tokens fee-lp
                (make-list (length pool-tokens) 1.0)
                -1.0 p
            )
        )
    )
    ;;
    (defun C_AddStandardLiquidity
        (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UEV_IMC)
        (with-capability (MTX-SWP|S>ADD-LQ kda-pid)
            (MTX|C_AddLiquidity patron account swpair input-amounts true true kda-pid)
        )
    )
    (defun C_AddIcedLiquidity
        (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UEV_IMC)
        (with-capability (MTX-SWP|S>ADD-LQ kda-pid)
            (MTX|C_AddLiquidity patron account swpair input-amounts false true kda-pid)
        )
    )
    (defun C_AddGlacialLiquidity
        (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UEV_IMC)
        (with-capability (MTX-SWP|S>ADD-LQ kda-pid)
            (MTX|C_AddLiquidity patron account swpair input-amounts false false kda-pid)
        )
    )
    (defun C_AddFrozenLiquidity
        (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal kda-pid:decimal)
        (UEV_IMC)
        (with-capability (MTX-SWP|S>ADD-LQ kda-pid)
            (MTX|C_AddFrozenLiquidity patron account swpair frozen-dptf input-amount kda-pid)
        )
    )
    (defun C_AddSleepingLiquidity
        (patron:string account:string swpair:string sleeping-dpof:string nonce:integer kda-pid:decimal)
        (UEV_IMC)
        (with-capability (MTX-SWP|S>ADD-LQ kda-pid)
            (MTX|C_AddSleepingLiquidity patron account swpair sleeping-dpof nonce kda-pid)
        )
    )
    ;;{F6.P}  [MTX|C]
    (defpact MTX|C_AddLiquidity 
        (
            patron:string account:string swpair:string input-amounts:[decimal] 
            asymmetric-collection:bool gaseous-collection:bool kda-pid:decimal
        )
        ;;Adds Standard,Iced or Glacial Liquidity, as an MTX in 3 steps
        ;;
        ;;Step 0 Computation and Validation
        (step
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPL:module{SwapperLiquidityV2} SWPL)
                    ;;
                    (pool-state:object{SwapperLiquidityV2.PoolState}
                        (UR_PoolState swpair)
                    )
                    (ld:object{SwapperLiquidityV2.LiquidityData}
                        (ref-SWPL::URC_LD swpair input-amounts)
                    )
                    (clad:object{SwapperLiquidityV2.CompleteLiquidityAdditionData}
                        (ref-SWPL::URC|KDA-PID_CLAD 
                            account swpair ld asymmetric-collection gaseous-collection kda-pid
                        )
                    )
                )
                (require-capability (MTX-SWP|S>ADD-LQ kda-pid))
                (yield
                    {"pool-state"   : pool-state
                    ,"ld"           : ld
                    ,"clad"         : clad}
                )
                (ref-IGNIS::C_Collect patron 
                    (ref-IGNIS::UDC_ConstructOutputCumulator 100.0 SWP|SC_NAME false [])
                )
                (format "MTX LqAdd. computed succesfully and collected {} IGNIS before discounts; 1|3" [100.0])
            )
        )
        ;;Step 1, Adding Liquidity and Minting LP
        (step-with-rollback
            (resume
                {"pool-state"   := prev-pool-state
                ,"ld"           := ld
                ,"clad"         := clad
                }
                (let
                    (
                        (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                        (ref-SWPL:module{SwapperLiquidityV2} SWPL)
                        ;;
                        (current-pool-state:object{SwapperLiquidityV2.PoolState} (UR_PoolState swpair))
                        (primary:decimal (at "primary-lp" clad))
                        (secondary:decimal (at "secondary-lp" clad))
                        (sum-lp:decimal (+ primary secondary))
                    )
                    (enforce 
                        (= prev-pool-state current-pool-state) 
                        "Execution Step of Adding Liquidity cannot execute on altered pool state!"
                    )
                    (ref-IGNIS::C_Collect patron 
                        (at "perfect-ignis-fee" (at "clad-op" clad))
                    )
                    (if (and asymmetric-collection gaseous-collection)
                        (with-capability (MTX-SWP|C>ADD-STANDARD-LQ swpair ld)
                            ;;<asymmetric-collection=true> <gaseous-collection=true>
                            (ref-SWPL::XE|KDA-PID_AddLiqudity 
                                account swpair asymmetric-collection gaseous-collection kda-pid ld clad
                            )
                        )
                        (if gaseous-collection
                            (with-capability (MTX-SWP|C>ADD-ICED-LQ swpair ld)
                                ;;<asymmetric-collection=false> <gaseous-collection=true>
                                (ref-SWPL::XE|KDA-PID_AddLiqudity 
                                    account swpair asymmetric-collection gaseous-collection kda-pid ld clad
                                )
                            )
                            (with-capability (MTX-SWP|C>ADD-GLACIAL-LQ swpair ld)
                                ;;<asymmetric-collection=false> <gaseous-collection=false>
                                (ref-SWPL::XE|KDA-PID_AddLiqudity 
                                    account swpair asymmetric-collection gaseous-collection kda-pid ld clad
                                )
                            )
                        )
                    )
                    (yield
                        {"primary-lp-amount"    : primary
                        ,"secondary-lp-amount"  : secondary}
                    )
                    (format "Succesfully Added Liquidity on {} and minted {} LP; 2|3" [swpair sum-lp])
                )
            )
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                )
                (ref-IGNIS::C_Collect patron 
                    (ref-IGNIS::UDC_ConstructOutputCumulator 100.0 SWP|SC_NAME false [])
                )
                (format "Inconsistent Pool State detected: Adding Liquidity not allowed; Stepped rolled back; 2|3" [swpair])
            )
        )
        ;;Step 2, transfering LP To Client
        (step
            (resume
                {"primary-lp-amount"    := primary
                ,"secondary-lp-amount"  := secondary
                }
                (with-capability (P|MTX-SWP|CALLER)
                    (let
                        (
                            (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                            (ref-TFT:module{TrueFungibleTransferV8} TFT)
                            (ref-VST:module{VestingV5} VST)
                            (ref-SWP:module{SwapperV5} SWP)
                            (ref-SWPL:module{SwapperLiquidityV2} SWPL)
                            ;;
                            (lp-id:string (ref-SWP::UR_TokenLP swpair))
                            (ico1:object{IgnisCollectorV2.OutputCumulator}
                                (if (!= primary 0.0)
                                    (ref-TFT::C_Transfer lp-id SWP|SC_NAME account primary true)
                                    EOC
                                )
                            )
                            (ico2:object{IgnisCollectorV2.OutputCumulator}
                                (if (not asymmetric-collection)
                                    (ref-VST::C_Freeze SWP|SC_NAME account lp-id secondary)
                                    EOC
                                )
                            )
                        )
                        ;;Autonomous Swap Mangement
                        (ref-SWPL::XE_AutonomousSwapManagement swpair)
                        ;;Collect Last Gas
                        (ref-IGNIS::C_Collect patron 
                            (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                                [ico1 ico2] 
                                []
                            ) 
                        )
                        (if (not asymmetric-collection)
                            (format "Succesfully moved {} Native LP and {} Frozen LP to client; 3|3" [primary secondary])
                            (format "Succesfully moved {} Native LP to client; 2|2" [primary])
                        )
                    )
                )
            )
        )
    )
    (defpact MTX|C_AddFrozenLiquidity
        (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal kda-pid:decimal)
        ;;Adds Frozen Liquidity, as an MTX in 3 Steps
        ;;
        ;:Step 0, Computation and Validation
        (step
            (let
                (
                    (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    (ref-SWP:module{SwapperV5} SWP)
                    (ref-SWPL:module{SwapperLiquidityV2} SWPL)
                    ;;
                    (pool-state:object{SwapperLiquidityV2.PoolState}
                        (UR_PoolState swpair)
                    )
                    ;;
                    (dptf:string (ref-DPTF::UR_Frozen frozen-dptf))
                    (ptp:integer (ref-SWP::UR_PoolTokenPosition swpair dptf))
                    (lq-lst:[decimal] (ref-U|SWP::UC_MakeLiquidityList swpair ptp input-amount))
                    (ld:object{SwapperLiquidityV2.LiquidityData}
                        (ref-SWPL::URC_LD swpair lq-lst)
                    )
                    (clad:object{SwapperLiquidityV2.CompleteLiquidityAdditionData}
                        (ref-SWPL::URC|KDA-PID_CLAD account swpair ld false false kda-pid)
                    )
                )
                (require-capability (MTX-SWP|S>ADD-LQ kda-pid))
                (yield
                    {"pool-state"   : pool-state
                    ,"ld"           : ld
                    ,"clad"         : clad}
                )
                (ref-IGNIS::C_Collect patron 
                    (ref-IGNIS::UDC_ConstructOutputCumulator 100.0 SWP|SC_NAME false [])
                )
                (format "MTX Frozen LqAdd. computed succesfully and collected {} IGNIS before discounts; 1|3" [100.0])
            )
        )
        ;;Step 1, Adding Liquidity and Minting LP
        (step-with-rollback
            (resume
                {"pool-state"   := prev-pool-state
                ,"ld"           := ld
                ,"clad"         := clad
                }
                (let
                    (
                        (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                        ;;
                        (current-pool-state:object{SwapperLiquidityV2.PoolState} (UR_PoolState swpair))
                        (secondary:decimal (at "secondary-lp" clad))
                    )
                    (enforce 
                        (= prev-pool-state current-pool-state) 
                        "Execution Step of Adding Liquidity cannot execute on altered pool state!"
                    )
                    (with-capability (MTX-SWP|C>ADD-FROZEN-LQ swpair frozen-dptf ld)
                        (let
                            (
                                (ref-DALOS:module{OuronetDalosV5} DALOS)
                                (ref-TFT:module{TrueFungibleTransferV8} TFT)
                                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                                (ref-SWPL:module{SwapperLiquidityV2} SWPL)
                                (vst-sc:string (ref-DALOS::GOV|VST|SC_NAME))
                                ;;
                                ;;Move F|DPTF to vst-sc and burn it
                                (ico1:object{IgnisCollectorV2.OutputCumulator}
                                    (ref-TFT::C_Transfer frozen-dptf account vst-sc input-amount true)
                                )
                                (ico2:object{IgnisCollectorV2.OutputCumulator}
                                    (ref-DPTF::C_Burn frozen-dptf vst-sc input-amount)
                                )
                                (ico3:object{IgnisCollectorV2.OutputCumulator}
                                    (at "perfect-ignis-fee" (at "clad-op" clad))
                                )
                            )
                            (ref-IGNIS::C_Collect patron 
                                (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                                    [ico1 ico2 ico3] []
                                )
                            )
                            (ref-SWPL::XE|KDA-PID_AddLiqudity vst-sc swpair false false kda-pid ld clad)
                            (yield
                                {"secondary-lp-amount"  : secondary}
                            )
                            (format "Succesfully Added Frozen Liquidity on {} and minted {} LP; Stepped rolled back; 2|3" [swpair secondary])
                        )
                    )
                )
            )
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                )
                (ref-IGNIS::C_Collect patron 
                    (ref-IGNIS::UDC_ConstructOutputCumulator 100.0 SWP|SC_NAME false [])
                )
                (format "Inconsistent Pool State detected: Adding Liquidity not allowed; 2|3" [swpair])
            )
        )
        ;;Step 2, transfering LP To Client
        (step
            (resume
                {"secondary-lp-amount"  := secondary}
                (with-capability (P|MTX-SWP|CALLER)
                    (let
                        (
                            (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                            (ref-VST:module{VestingV5} VST)
                            (ref-SWP:module{SwapperV5} SWP)
                            (ref-SWPL:module{SwapperLiquidityV2} SWPL)
                            ;;
                            (lp-id:string (ref-SWP::UR_TokenLP swpair))
                            (ico:object{IgnisCollectorV2.OutputCumulator}
                                (ref-VST::C_Freeze SWP|SC_NAME account lp-id secondary)
                            )
                        )
                        ;;Autonomous Swap Mangement
                        (ref-SWPL::XE_AutonomousSwapManagement swpair)
                        ;;Collect Last Gas
                        (ref-IGNIS::C_Collect patron ico)
                        (format "Succesfuly frozen {} LP to Client; 3|3" [secondary])
                    )
                )
            )
        )
    )
    (defpact MTX|C_AddSleepingLiquidity
        (patron:string account:string swpair:string sleeping-dpof:string nonce:integer kda-pid:decimal)
        ;;Adds Frozen Liquidity, as an MTX in 3 Steps
        ;;
        ;:Step 0, Computation and Validation
        (step
            (let
                (
                    (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                    (ref-SWP:module{SwapperV5} SWP)
                    (ref-SWPL:module{SwapperLiquidityV2} SWPL)
                    ;;
                    (pool-state:object{SwapperLiquidityV2.PoolState}
                        (UR_PoolState swpair)
                    )
                    ;;
                    (dptf:string (ref-DPOF::UR_Sleeping sleeping-dpof))
                    (ptp:integer (ref-SWP::UR_PoolTokenPosition swpair dptf))
                    (batch-amount:decimal (ref-DPOF::UR_NonceSupply sleeping-dpof nonce))
                    (lq-lst:[decimal] (ref-U|SWP::UC_MakeLiquidityList swpair ptp batch-amount))
                    (ld:object{SwapperLiquidityV2.LiquidityData}
                        (ref-SWPL::URC_LD swpair lq-lst)
                    )
                    (clad:object{SwapperLiquidityV2.CompleteLiquidityAdditionData}
                        (ref-SWPL::URC|KDA-PID_CLAD account swpair ld true true kda-pid)
                    )
                )
                (require-capability (MTX-SWP|S>ADD-LQ kda-pid))
                (yield
                    {"pool-state"   : pool-state
                    ,"ld"           : ld
                    ,"clad"         : clad
                    ,"ba"           : batch-amount}
                )
                (ref-IGNIS::C_Collect patron 
                    (ref-IGNIS::UDC_ConstructOutputCumulator 100.0 SWP|SC_NAME false [])
                )
                (format "MTX Sleeping LqAdd. computed succesfully and collected {} IGNIS before discounts; 1|3" [100.0])
            )
        )
        ;;Step 1, Adding Liquidity and Minting LP
        (step-with-rollback
            (resume
                {"pool-state"   := prev-pool-state
                ,"ld"           := ld
                ,"clad"         := clad
                ,"ba"           := batch-amount
                }
                (let
                    (
                        (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                        ;;
                        (current-pool-state:object{SwapperLiquidityV2.PoolState} (UR_PoolState swpair))
                        (primary:decimal (at "primary-lp" clad))
                    )
                    (enforce 
                        (= prev-pool-state current-pool-state) 
                        "Execution Step of Adding Liquidity cannot execute on altered pool state!"
                    )
                    (with-capability (MTX-SWP|C>ADD-SLEEPING-LQ account swpair sleeping-dpof nonce ld)
                        (let
                            (
                                (ref-DALOS:module{OuronetDalosV5} DALOS)
                                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                                (ref-TFT:module{TrueFungibleTransferV8} TFT)
                                (ref-SWPL:module{SwapperLiquidityV2} SWPL)
                                ;;
                                (vst-sc:string (ref-DALOS::GOV|VST|SC_NAME))
                                (ignis-id:string (ref-DALOS::UR_IgnisID))
                                ;;
                                (nonce-md:[object] (ref-DPOF::UR_NonceMetaData sleeping-dpof nonce))
                                (release-date:time (at "release-date" (at 0 nonce-md)))
                                (present-time:time (at "block-time" (chain-data)))
                                (dt:integer (floor (diff-time release-date present-time)))
                                ;;
                                ;;Move Z|DPOF to vst-sc and burn it
                                (ico1:object{IgnisCollectorV2.OutputCumulator}
                                    (ref-DPOF::C_Transfer sleeping-dpof [nonce] account vst-sc true)
                                )
                                (ico2:object{IgnisCollectorV2.OutputCumulator}
                                    (ref-DPOF::C_Burn sleeping-dpof vst-sc nonce batch-amount)
                                )
                                (ico3:object{IgnisCollectorV2.OutputCumulator}
                                    (at "perfect-ignis-fee" (at "clad-op" clad))
                                )
                                ;;
                                ;;MOVE IGNIS to vst-sc, paying for the ignis-tax
                                (ico4:object{IgnisCollectorV2.OutputCumulator}
                                    (ref-TFT::C_Transfer ignis-id account vst-sc (at "total-ignis-tax-needed" clad) true)
                                )
                            )
                            (ref-IGNIS::C_Collect patron 
                                (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                                    [ico1 ico2 ico3 ico4] []
                                )
                            )
                            (ref-SWPL::XE|KDA-PID_AddLiqudity vst-sc swpair true true kda-pid ld clad)
                            (yield
                                {"primary-lp-amount"    : primary
                                ,"time-diff"            : dt}
                            )
                            (format "Succesfully Added Sleeping Liquidity on {} and minted {} LP; 2|3" [swpair primary])
                        )
                    )
                )
            )
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                )
                (ref-IGNIS::C_Collect patron 
                    (ref-IGNIS::UDC_ConstructOutputCumulator 100.0 SWP|SC_NAME false [])
                )
                (format "Inconsistent Pool State detected: Adding Liquidity not allowed; Stepped rolled back; 2|3" [swpair])
            )
        )
        ;;Step 2, transfering LP To Client
        (step
            (resume
                {"primary-lp-amount"    := primary
                ,"time-diff"            := dt}
                (with-capability (P|MTX-SWP|CALLER)
                    (let
                        (
                            (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                            (ref-VST:module{VestingV5} VST)
                            (ref-SWP:module{SwapperV5} SWP)
                            (ref-SWPL:module{SwapperLiquidityV2} SWPL)
                            ;;
                            (lp-id:string (ref-SWP::UR_TokenLP swpair))
                            (ico:object{IgnisCollectorV2.OutputCumulator}
                                (ref-VST::C_Sleep SWP|SC_NAME account lp-id primary dt)
                            )
                        )
                        ;;Autonomous Swap Mangement
                        (ref-SWPL::XE_AutonomousSwapManagement swpair)
                        ;;Collect Last Gas
                        (ref-IGNIS::C_Collect patron ico)
                        (format "Succesfuly put to sleep {} LP to Client; 3|3" [primary])
                    )
                )
            )
        )
    )
    (defpact MTX|C_Issue
        (patron:string account:string pool-tokens:[object{SwapperV5.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        ;;Issues an SWPair, as MultiStep Transaction, to be used in case <C_Issue> cant fit inside one TX.
        ;;
        ;;Step 1 Validation
        (step
            (let
                (
                    (ref-SWPI:module{SwapperIssueV3} SWPI)
                )
                (require-capability (SECURE))
                (ref-SWPI::UEV_Issue account pool-tokens fee-lp weights amp p)
            )
        )
        ;;Step 2 Ignis Collection and KDA Fuel Processing
        (step-with-rollback
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DALOS:module{OuronetDalosV5} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    (ref-SWP:module{SwapperV5} SWP)
                    (pool-token-ids:[string] (ref-SWP::UC_ExtractTokens pool-tokens))
                    (pool-token-amounts:[decimal] (ref-SWP::UC_ExtractTokenSupplies pool-tokens))
                    ;;
                    (sum-ignis:decimal 
                        (fold (+) 0.0 
                            [
                                (ref-DALOS::UR_UsagePrice "ignis|swp-issue")
                                (ref-DALOS::UR_UsagePrice "ignis|token-issue")
                                (ref-DALOS::UR_UsagePrice "ignis|biggest")
                                (ref-DALOS::UR_UsagePrice "ignis|smallest")
                            ]
                        )
                    )
                    (trigger:bool (ref-IGNIS::URC_IsVirtualGasZero))
                    ;;
                    (ico0:object{IgnisCollectorV2.OutputCumulator}
                        (ref-IGNIS::UDC_ConstructOutputCumulator sum-ignis SWP|SC_NAME trigger [])
                    )
                    (ico1:object{IgnisCollectorV2.OutputCumulator}
                        (ref-TFT::UDC_MultiTransferCumulator pool-token-ids account SWP|SC_NAME pool-token-amounts)
                    )
                    ;;
                    (kda-costs:decimal 
                        (+ 
                            (ref-DALOS::UR_UsagePrice "dptf")
                            (ref-DALOS::UR_UsagePrice "swp")
                        )
                    )
                )
                ;;Collect IGNIS for Issuance
                (ref-IGNIS::C_Collect patron
                    (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico0 ico1] [])
                )
                ;;Collect KDA for Issuance
                (ref-IGNIS::KDA|C_Collect patron kda-costs)
                (let
                    (
                        (ref-ORBR:module{OuroborosV5} OUROBOROS)
                        (auto-fuel:bool (ref-DALOS::UR_AutoFuel))
                    )
                    (if auto-fuel
                        (do
                            (with-capability (P|DT)
                                (ref-ORBR::C_Fuel)
                            )
                            (format "{} IGNIS and {} KDA collected (raising DLK Index) succesfully; 2|3" [sum-ignis kda-costs])
                        )
                        (format "{} IGNIS collected, with {} KDA collected (in reserves) succesfully; 2|3" [sum-ignis kda-costs])
                    )
                )
            )
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                )
                (ref-IGNIS::C_Collect patron 
                    (ref-IGNIS::UDC_ConstructOutputCumulator 100.0 SWP|SC_NAME false [])
                )
                (format "Insufficient IGNIS and KDA for Collection; Stepped rolled back{} 2|3" [";"])
            )
        )
        ;;Step 3 Issuance
        (step
            (with-capability (MTX-SWP|C>ISSUE p)
                (let
                    (
                        (ref-DALOS:module{OuronetDalosV5} DALOS)
                        (ref-BRD:module{Branding} BRD)
                        (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                        (ref-TFT:module{TrueFungibleTransferV8} TFT)
                        (ref-SWPT:module{SwapTracer} SWPT)
                        (ref-SWP:module{SwapperV5} SWP)
                        ;;
                        (principals:[string] (ref-SWP::UR_Principals))
                        (pool-token-ids:[string] (ref-SWP::UC_ExtractTokens pool-tokens))
                        (pool-token-amounts:[decimal] (ref-SWP::UC_ExtractTokenSupplies pool-tokens))
                        (lp-name-ticker:[string] (ref-SWP::URC_LpComposer pool-tokens weights amp))
                        (lp-name:string (at 0 lp-name-ticker))
                        (lp-ticker:string (at 1 lp-name-ticker))
                        (ico:object{IgnisCollectorV2.OutputCumulator}
                            (ref-DPTF::XE_IssueLP lp-name lp-ticker)
                        )
                        (token-lp:string (at 0 (at "output" ico)))
                        (swpair:string (ref-SWP::XE_Issue account pool-tokens token-lp fee-lp weights amp p))
                    )
                    (ref-BRD::XE_Issue swpair)
                    (ref-TFT::C_MultiTransfer pool-token-ids account SWP|SC_NAME pool-token-amounts true)
                    (ref-DPTF::C_Mint token-lp SWP|SC_NAME 10000000.0 true)
                    (ref-TFT::C_Transfer token-lp SWP|SC_NAME account 10000000.0 true)
                    (ref-SWPT::XE_MultiPathTracer swpair principals)
                    (format "Swpair with ID {} and LP Token {} ID created succesfully" [swpair token-lp])
                )
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

;(create-table P|T)
;(create-table P|MT)