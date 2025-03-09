(interface TalosStageOne_ClientPacts
    ;;
    ;;
    ;;DPTF (Demiourgos Pact True Fungible) Pact Initiating Functions
    (defun DPTF|C_BulkTransfer81-160 (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)) ;d
    (defun DPTF|C_BulkTransfer41-80 (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)) ;d
    (defun DPTF|C_BulkTransfer13-40 (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)) ;d
    (defun DPTF|C_MultiTransfer41-80 (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)) ;d
    (defun DPTF|C_MultiTransfer13-40 (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)) ;d
    ;;SWP (Swap-Pair) Pact Initiating Functions
    ;;Issue
    (defun SWP|C_IssueStableMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal amp:decimal p:bool)) ;d
    (defun SWP|C_IssueStandardMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal p:bool)) ;d
    (defun SWP|C_IssueWeightedMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool)) ;d

)
(module TS01-CP GOV
    @doc "TALOS Administrator and Client Module for Stage 1"
    ;;
    (implements OuronetPolicy)
    (implements TalosStageOne_ClientPacts)
    ;;{G1}
    (defconst GOV|MD_TS01-CP        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TS01-CP_ADMIN)))
    (defcap GOV|TS01-CP_ADMIN ()    (enforce-guard GOV|MD_TS01-CP))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|TS ()
        @doc "Talos Summoner Capability"
        true
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::P|Info)))
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
                (ref-P|SWPU:module{OuronetPolicy} SWPU)
                (mg:guard (create-capability-guard (P|TS)))
            )
            (ref-P|SWPU::P|A_AddIMP mg)
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
    ;;{3}
    (defun TALOS|Gassless ()        (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|DALOS|SC_NAME)))
    (defconst GASSLES-PATRON        (TALOS|Gassless))
    (defcap SECURE ()
        true
    )
    ;;
    ;;
    ;;
    ;;{DPTF_PactStarters}
    (defun DPTF|C_BulkTransfer81-160 (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Transfer 81-160 DPTFs in Bulk or 41-80 Elite Auryns in Bulk over 13 Steps\
            \ Steps 0|1|2|3 Validation in 4 Steps \
            \ Step 4 Collects the required IGNIS in 1 Step\
            \ Step 5|6|7|8|9|10|11|12 BulkTransfer in 8 Steps"
        (with-capability (P|TS)
            (let
                (
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                )
                (ref-TFT::PS|C_BulkTransfer81-160 patron id sender receiver-lst transfer-amount-lst method)
            )
        )
    )
    (defun DPTF|C_BulkTransfer41-80 (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Transfer 41-80 DPTFs in Bulk or 21-40 Elite Auryns in Bulk over 7 Steps\
            \ Steps 0|1| Validation in 2 Steps \
            \ Step 2 Collects the required IGNIS in 1 Step\
            \ Step 3|4|5|6 BulkTransfer in 4 Steps"
        (with-capability (P|TS)
            (let
                (
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                )
                (ref-TFT::PS|C_BulkTransfer41-80 patron id sender receiver-lst transfer-amount-lst method)
            )
        )
    )
    (defun DPTF|C_BulkTransfer13-40 (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Transfer 13-40 DPTFs in Bulk or 9-20 Elite Auryns in Bulk over 4 Steps\
            \ Steps 0 Validation in 1 Step \
            \ Step 1 Collects the required IGNIS in 1 Step\
            \ Step 2|3 BulkTransfer in 2 Steps"
        (with-capability (P|TS)
            (let
                (
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                )
                (ref-TFT::PS|C_BulkTransfer13-40 patron id sender receiver-lst transfer-amount-lst method)
            )
        )
    )
    (defun DPTF|C_MultiTransfer41-80 (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @doc "Multi Transfers 15-40 DPTFs over 7 Steps \
            \ Steps 0|1 Validation in 2 Steps \
            \ Step 2 Collects the required IGNIS in 1 Step\
            \ Step 3|4|5|6 BulkTransfer in 4 Steps"
        (with-capability (P|TS)
            (let
                (
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                )
                (ref-TFT::PS|C_MultiTransfer41-80 patron id-lst sender receiver transfer-amount-lst method)
            )
        )
    )
    (defun DPTF|C_MultiTransfer13-40 (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @doc "Multi Transfers 13-40 DPTFs over 4 Steps\
            \ Steps 0 Validation in 1 Step \
            \ Step 1 Collects the required IGNIS in 1 Step\
            \ Step 2|3 BulkTransfer in 2 Steps"
        (with-capability (P|TS)
            (let
                (
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                )
                (ref-TFT::PS|C_MultiTransfer13-40 patron id-lst sender receiver transfer-amount-lst method)
            )
        )
    )
    ;;{SWP_PactStarters}
    (defun SWP|C_IssueStableMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal amp:decimal p:bool)
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
                    (ref-SWPU:module{SwapperUsage} SWPU)
                )
                (ref-SWPU::PS|C_IssueStableMultiStep patron account pool-tokens fee-lp amp p)
            )
        )
    )
    (defun SWP|C_IssueStandardMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal p:bool)
        @doc "Similar to <SWP|C_IssueStableMultiStep>, but issues a P (Standard) Pool"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWPU:module{SwapperUsage} SWPU)
                )
                (ref-SWPU::PS|C_IssueStandardMultiStep patron account pool-tokens fee-lp p)
            )
        )
    )
    (defun SWP|C_IssueWeightedMultiStep (patron:string account:string pool-tokens:[object{Swapper.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool)
        @doc "Similar to <SWP|C_IssueStableMultiStep>, but issues a W (Weighted) Pool"
        (with-capability (P|TS)
            (let
                (
                    (ref-SWPU:module{SwapperUsage} SWPU)
                )
                (ref-SWPU::PS|C_IssueWeightedMultiStep patron account pool-tokens fee-lp weights p)
            )
        )
    )
    ;;>>>>>>>>>>>>>>>>>>>>>>>>>>
)

(create-table P|T)
(create-table P|MT)