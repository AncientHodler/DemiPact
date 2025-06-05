(interface TalosStageOne_ClientPactsV3
    @doc "Removes DPTF Bulk and Multi Transfer in Multistep, to be added later on \
    \ Due to the optimization of DPTF Transfers there are no longer needed in the near future \
    \ V3 Adds Liquidity Addition and moves all Defpacts in MTX Modules"

    ;;
    ;;
    ;;SWP (Swap-Pair) Pact Initiating Functions
    ;;Issue
    (defun SWP|C_IssueStablePool (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal amp:decimal p:bool))
    (defun SWP|C_IssueWeightedPool (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool))
    (defun SWP|C_IssueStandardPool (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal p:bool))
    ;;
    (defun SWP|C_AddLiquidity (patron:string account:string swpair:string input-amounts:[decimal]))
    ;;
)
(module TS01-CP GOV
    @doc "TALOS Administrator and Client Module for Stage 1"
    ;;
    (implements OuronetPolicy)
    (implements TalosStageOne_ClientPactsV3)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_TS01-CP        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TS01-CP_ADMIN)))
    (defcap GOV|TS01-CP_ADMIN ()    (enforce-guard GOV|MD_TS01-CP))
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
    (defcap P|TS ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (gap:bool (ref-DALOS::UR_GAP))
            )
            (enforce (not gap) "While Global Administrative Pause is online, no client Functions can be executed")
            (compose-capability (P|TALOS-SUMMONER))
        )
    )
    (defcap P|TALOS-SUMMONER ()
        @doc "Talos Summoner Capability"
        true
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
        (with-capability (GOV|TS01-CP_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|TS01-CP_ADMIN)
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
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|SWP-MTX:module{OuronetPolicy} SWP-MTX)
                (mg:guard (create-capability-guard (P|TALOS-SUMMONER)))
            )
            (ref-P|SWP-MTX::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
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
    (defun CT_KdaPid ()             (let ((ref-U|CT|DIA:module{DiaKdaPid} U|CT)) (ref-U|CT|DIA::UR|KDA-PID)))
    (defconst KDAPID                (CT_KdaPid))
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
    ;;  [SWP PactStarters]
    (defun SWP|C_IssueStablePool (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal amp:decimal p:bool)
        @doc "Similar outcome to <ref-TS01-C2::SWP|C_IssueStable>, but over 3 <steps> (0|1|2) via <defpact> \
            \ Calling this function runs the Step 0 of 2. To finalize SWPair creation, Steps 1 and 2 must also be executed \
            \ \
            \ Step 0: Data Validation, makes sure the input data is correct for SWPair Creation \
            \ Step 1: Collects IGNIS, KDA, and fuels LiquidStaking Index with collected KDA \
            \ Step 2: Executes the actual Pool Creation, Issuing the LP Token, Creating the SWPair, minting the LP Token Supply \
            \   transfering it to its creator, and saves all other relevant data when a Pool Creation takes place"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWP-MTX:module{SwapperMtx} SWP-MTX)
                )
                (ref-SWP-MTX::C_IssueStablePool patron account pool-tokens fee-lp amp p)
            )
        )
    )
    (defun SWP|C_IssueWeightedPool (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool)
        @doc "Similar to <SWP|C_IssueStableMultiStep>, but issues a W (Weighted) Pool"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWP-MTX:module{SwapperMtx} SWP-MTX)
                )
                (ref-SWP-MTX::C_IssueWeightedPool patron account pool-tokens fee-lp weights p)
            )
        )
    )
    (defun SWP|C_IssueStandardPool (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal p:bool)
        @doc "Similar to <SWP|C_IssueStableMultiStep>, but issues a P (Standard) Pool"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWP-MTX:module{SwapperMtx} SWP-MTX)
                )
                (ref-SWP-MTX::C_IssueStandardPool patron account pool-tokens fee-lp p)
            )
        )
    )
    ;;
    (defun SWP|C_AddLiquidity
        (patron:string account:string swpair:string input-amounts:[decimal])
        (with-capability (P|TS)
            (let
                (
                    (ref-SWP-MTX:module{SwapperMtx} SWP-MTX)
                )
                (ref-SWP-MTX::C|KDA-PID_AddStandardLiquidity patron account swpair input-amounts KDAPID)
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)