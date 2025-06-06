
(module SWP-MTX GOV
    ;;
    (implements OuronetPolicy)
    (implements SwapperMtx)
    ;(implements DemiourgosPactDigitalCollectibles-UtilityPrototype)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_SWP-MTX        (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst SWP|SC_NAME           (GOV|SWP|SC_NAME))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|SWP-MTX_ADMIN)))
    (defcap GOV|SWP-MTX_ADMIN ()    (enforce-guard GOV|MD_SWP-MTX))
    ;;
    (defun GOV|SWP|SC_NAME ()       (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|SWP|SC_NAME)))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|SWP-MTX|CALLER ()
        true
    )
    (defcap P|SWP-MTX|REMOTE-GOV ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|SWP-MTX|CALLER))
        (compose-capability (SECURE))
    )
    (defcap P|DT ()
        (compose-capability (P|SWP-MTX|REMOTE-GOV))
        (compose-capability (P|SWP-MTX|CALLER))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|SWP-MTX_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|SWP-MTX_ADMIN)
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
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|ORBR:module{OuronetPolicy} OUROBOROS)
                (ref-P|SWPT:module{OuronetPolicy} SWPT)
                (ref-P|SWP:module{OuronetPolicy} SWP)
                (ref-P|SWPL:module{OuronetPolicy} SWPL)
                (mg:guard (create-capability-guard (P|SWP-MTX|CALLER)))
            )
            (ref-P|SWP::P|A_Add
                "SWP-MTX|RemoteSwpGov"
                (create-capability-guard (P|SWP-MTX|REMOTE-GOV))
            )
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|ORBR::P|A_AddIMP mg)
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
    (defconst BAR                   (CT_Bar))
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
    (defcap SWP-MTX|C>ISSUE-S-POOL (pool-tokens:[object{SwapperV4.PoolTokens}])
        @event
        (compose-capability (SECURE))
    )
    (defcap SWP-MTX|C>ISSUE-W-POOL (pool-tokens:[object{SwapperV4.PoolTokens}])
        @event
        (compose-capability (SECURE))
    )
    (defcap SWP-MTX|C>ISSUE-P-POOL (pool-tokens:[object{SwapperV4.PoolTokens}])
        @event
        (compose-capability (SECURE))
    )
    (defcap SWP-MTX|C>ISSUE (p:bool)
        (compose-capability (P|DT))
        (if p
            (compose-capability (GOV|SWP-MTX_ADMIN))
            true
        )
    )
    ;;
    (defcap SWP-MTX|C>ADD-STANDARD-LQ (swpair:string ld:object{SwapperLiquidity.LiquidityData})
        @event
        (compose-capability (SWP-MTX|C>X-ADD-LQ swpair ld))
    )
    (defcap SWP-MTX|C>X-ADD-LQ (swpair:string ld:object{SwapperLiquidity.LiquidityData})
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                (can-add:bool (ref-SWP::UR_CanAdd swpair))
                (read-lp-supply:decimal (ref-SWP::URC_LpCapacity swpair))
                (iz-asymmetric:bool (at "iz-asymmetric" (at "sorted-lq-type" ld)))
                (iz-balanced:bool (at "iz-balanced" (at "sorted-lq-type" ld)))
                (iz-asymmetric-allowed:bool (ref-SWP::UR_Asymetric))
            )
            (if iz-asymmetric
                (enforce iz-asymmetric-allowed "Asymetric Liquidity Addition isn't enabled by an Ouronet Administrator")
                true
            )
            (if (= read-lp-supply 0.0)
                (enforce iz-balanced
                    "Liquidity Addition on an empty Pool must have a Balanced Part present!"
                )
                true
            )
            (enforce can-add (format "Liquidity Adding and Removal isn't enabled on pool {}" [swpair]))
            (compose-capability (P|DT))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_PoolState:object{SwapperLiquidity.PoolState} (swpair:string)
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPL:module{SwapperLiquidity} SWPL)
            )
            (ref-SWPL::UDC_PoolState
                (ref-SWP::UR_PoolTokenSupplies swpair)
                (ref-SWP::URC_LpCapacity swpair)
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
        (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal amp:decimal p:bool)
        (UEV_IMC)
        (with-capability (SWP-MTX|C>ISSUE-S-POOL pool-tokens)
            (C|MTX_Issue
                patron account pool-tokens fee-lp
                (make-list (length pool-tokens) 1.0)
                amp p
            )
        )
    )
    (defun C_IssueWeightedPool
        (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool)
        (UEV_IMC)
        (with-capability (SWP-MTX|C>ISSUE-W-POOL pool-tokens)
            (C|MTX_Issue
                patron account pool-tokens fee-lp
                weights
                -1.0 p
            )
        )
    )
    (defun C_IssueStandardPool
        (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal p:bool)
        (UEV_IMC)
        (with-capability (SWP-MTX|C>ISSUE-P-POOL pool-tokens)
            (C|MTX_Issue
                patron account pool-tokens fee-lp
                (make-list (length pool-tokens) 1.0)
                -1.0 p
            )
        )
    )
    (defun C|KDA-PID_AddStandardLiquidity
        (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UEV_IMC)
        (let
            (
                (ref-SWPL:module{SwapperLiquidity} SWPL)
                (ld:object{SwapperLiquidity.LiquidityData}
                    (ref-SWPL::URC_Liquidity swpair input-amounts)
                )
            )
            (with-capability (SECURE)
                (C|MTX_AddStandardLiquidity patron account swpair ld kda-pid)
            )
        )
    )
    ;;
    (defpact C|MTX_AddStandardLiquidity 
        (patron:string account:string swpair:string ld:object{SwapperLiquidity.LiquidityData} kda-pid:decimal)
        ;;Add Standard Liquidity, as a MultiStep Transaction in two steps
        ;;
        ;;Step 1 Validation
        (step
            (let
                (
                    (ref-SWPL:module{SwapperLiquidity} SWPL)
                    (pool-state:object{SwapperLiquidity.PoolState}
                        (UR_PoolState swpair)
                    )
                    (clad:object{SwapperLiquidity.CompleteLiquidityAdditionData}
                        (ref-SWPL::URC|KDA-PID_CompleteLiquidityAdditionData account swpair ld true true kda-pid)
                    )
                )
                (require-capability (SECURE))
                (yield
                    {"pool-state"   : pool-state
                    ,"clad"         : clad}
                )
                (format "Step 0|1 for Adding Standard Liquidity on Pool {} with {} completed succesfully" [swpair ld])
            )        
        )
        ;;Step 2 Adding Liquidity
        ;;Will Execute only if Pool-State remains the same
        (step
            (resume
                {"pool-state"   := prev-pool-state
                ,"clad"         := clad
                }
                (with-capability (SWP-MTX|C>ADD-STANDARD-LQ swpair ld)
                    (let
                        (
                            (current-pool-state:object{SwapperLiquidity.PoolState} (UR_PoolState swpair))
                        )
                        (enforce (= prev-pool-state current-pool-state) "Execution Step of Adding Liquidity cannot execute on altered pool state")
                        (let
                            (
                                (ref-SWPL:module{SwapperLiquidity} SWPL)
                                (lp:decimal (at "primary-lp" clad))
                            )
                            (yield
                                {"ico"  : (ref-SWPL::XB|KDA-PID_AddLiqudity account swpair true true kda-pid ld clad)
                                ,"lp"   : (at "primary-lp" clad)}
                            )
                            (format "Succesfully added {} LP on SWPair {}" [lp swpair])
                        )
                    )
                )
            )
        )
        (step
            (resume
                {"ico"  := ico1
                ,"lp"   := native-lp-transfer-amount}
                (with-capability (P|SWP-MTX|CALLER)
                    (let
                        (
                            (ref-IGNIS:module{IgnisCollector} DALOS)
                            (ref-TFT:module{TrueFungibleTransferV6} TFT)
                            (ref-SWP:module{SwapperV4} SWP)
                            (ref-SWPL:module{SwapperLiquidity} SWPL)
                            ;;
                            (lp-id:string (ref-SWP::UR_TokenLP swpair))
                            ;;
                            (ico2:object{IgnisCollector.OutputCumulator}
                                (ref-TFT::C_Transfer lp-id SWP|SC_NAME account native-lp-transfer-amount true)
                            )
                        )
                        ;;Autonomous Swap Mangement
                        (ref-SWPL::XI_AutonomousSwapManagement swpair)
                        ;;Collect IGNIS
                        (ref-IGNIS::IC|C_Collect patron
                            (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators 
                                [ico1 ico2] 
                                []
                            )
                        )
                    )
                )
            )
        )
    )
    (defpact C|MTX_Issue
        (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        ;;Issues an SWPair, as MultiStep Transaction, to be used in case <C_Issue> cant fit inside one TX.
        ;;
        ;;Step 1 Validation
        (step
            (let
                (
                    (ref-SWPI:module{SwapperIssue} SWPI)
                )
                (require-capability (SECURE))
                (ref-SWPI::UEV_Issue account pool-tokens fee-lp weights amp p)
            )
        )
        ;;Step 2 Ignis Collection and KDA Fuel Processing
        (step
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (ref-SWP:module{SwapperV4} SWP)
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
                    (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                    ;;
                    (ico0:object{IgnisCollector.OutputCumulator}
                        (ref-IGNIS::IC|UDC_ConstructOutputCumulator sum-ignis SWP|SC_NAME trigger [])
                    )
                    (ico1:object{IgnisCollector.OutputCumulator}
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
                (ref-IGNIS::IC|C_Collect patron
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico0 ico1] [])
                )
                ;;Collect KDA for Issuance
                (ref-DALOS::KDA|C_Collect patron kda-costs)
                (let
                    (
                        (ref-ORBR:module{OuroborosV3} OUROBOROS)
                        (auto-fuel:bool (ref-DALOS::UR_AutoFuel))
                    )
                    (if auto-fuel
                        (do
                            (with-capability (P|DT)
                                (ref-ORBR::C_Fuel)
                            )
                            (format "{} IGNIS and {} KDA collected (raising DLK Index) succesfully." [sum-ignis kda-costs])
                        )
                        (format "{} IGNIS collected, with {} KDA collected (in reserves) succesfully" [sum-ignis kda-costs])
                    )
                )
            )
        )
        ;;Step 3 Issuance
        (step
            (with-capability (SWP-MTX|C>ISSUE p)
                (let
                    (
                        (ref-DALOS:module{OuronetDalosV4} DALOS)
                        (ref-BRD:module{Branding} BRD)
                        (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                        (ref-TFT:module{TrueFungibleTransferV6} TFT)
                        (ref-SWPT:module{SwapTracer} SWPT)
                        (ref-SWP:module{SwapperV4} SWP)
                        ;;
                        (principals:[string] (ref-SWP::UR_Principals))
                        (pool-token-ids:[string] (ref-SWP::UC_ExtractTokens pool-tokens))
                        (pool-token-amounts:[decimal] (ref-SWP::UC_ExtractTokenSupplies pool-tokens))
                        (lp-name-ticker:[string] (ref-SWP::URC_LpComposer pool-tokens weights amp))
                        (lp-name:string (at 0 lp-name-ticker))
                        (lp-ticker:string (at 1 lp-name-ticker))
                        (ico:object{IgnisCollector.OutputCumulator}
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

(create-table P|T)
(create-table P|MT)