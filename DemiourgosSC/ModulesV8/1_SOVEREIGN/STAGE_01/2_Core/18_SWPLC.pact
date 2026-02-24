(module SWPLC GOV
    ;;
    (implements OuronetPolicyV1)
    (implements BrandingUsageSecondaryV1)
    (implements SwapperLiquidityClientV1)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_SWPLC          (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst SWP|SC_NAME           (GOV|SWP|SC_NAME))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|SWPLC_ADMIN)))
    (defcap GOV|SWPLC_ADMIN ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV1} DALOS)
                (master:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
                (g1:guard GOV|MD_SWPLC)
                (g2:guard (ref-DALOS::UR_AccountGuard master))
            )
            (enforce-one
                "SWPLC Ownership not verified"
                [
                    (enforce-guard g1)
                    (enforce-guard g2)
                ]
            )
        )
    )
    ;;
    (defun GOV|SWP|SC_NAME ()       (let ((ref-DALOS:module{OuronetDalosV1} DALOS)) (ref-DALOS::GOV|SWP|SC_NAME)))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV1} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicyV1.P|S})
    (deftable P|MT:{OuronetPolicyV1.P|MS})
    ;;{P3}
    (defcap P|SWPLC|CALLER ()
        true
    )
    (defcap P|SWPLC|REMOTE-GOV ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|SWPLC|CALLER))
        (compose-capability (SECURE))
    )
    (defcap P|DT ()
        (compose-capability (P|SWPLC|REMOTE-GOV))
        (compose-capability (P|SWPLC|CALLER))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV1} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|SWPLC_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|SWPLC_ADMIN)
            (let
                (
                    (ref-U|LST:module{StringProcessorV1} U|LST)
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
                (ref-P|BRD:module{OuronetPolicyV1} BRD)
                (ref-P|DALOS:module{OuronetPolicyV1} DALOS)
                (ref-P|DPTF:module{OuronetPolicyV1} DPTF)
                (ref-P|DPOF:module{OuronetPolicyV1} DPOF)
                (ref-P|TFT:module{OuronetPolicyV1} TFT)
                (ref-P|VST:module{OuronetPolicyV1} VST)
                (ref-P|SWP:module{OuronetPolicyV1} SWP)
                (ref-P|SWPL:module{OuronetPolicyV1} SWPL)
                (mg:guard (create-capability-guard (P|SWPLC|CALLER)))
            )
            (ref-P|VST::P|A_Add
                "SWPLC|RemoteSwpGov"
                (create-capability-guard (P|SWPLC|REMOTE-GOV))
            )
            (ref-P|SWP::P|A_Add
                "SWPLC|RemoteSwpGov"
                (create-capability-guard (P|SWPLC|REMOTE-GOV))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|DPOF::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|VST::P|A_AddIMP mg)
            (ref-P|SWP::P|A_AddIMP mg)
            (ref-P|SWPL::P|A_AddIMP mg)
        )
    )
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuardsV1} U|G)
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
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstantsV1} U|CT)) (ref-U|CT::CT_BAR)))
    (defun CT_EmptyCumulator ()     (let ((ref-IGNIS:module{IgnisCollectorV1} IGNIS)) (ref-IGNIS::DALOS|EmptyOutputCumulatorV2)))
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
    (defcap SWPLC|C>UPDATE-BRD (swpair:string)
        @event
        (let
            (
                (ref-SWP:module{SwapperV1} SWP)
            )
            (ref-SWP::CAP_Owner swpair)
            (compose-capability (P|SWPLC|CALLER))
        )
    )
    (defcap SWPLC|C>UPGRADE-BRD (swpair:string)
        @event
        (let
            (
                (ref-SWP:module{SwapperV1} SWP)
            )
            (ref-SWP::CAP_Owner swpair)
            (compose-capability (P|SWPLC|CALLER))
        )
    )
    ;;
    (defcap SWPLC|C>INDIRECT-FUEL
        (account:string swpair:string id-lst:[string] transfer-amount-lst:[decimal])
        @event
        (compose-capability (P|SWPLC|CALLER))
    )
    (defcap SWPLC|C>DIRECT-FUEL
        (account:string swpair:string id-lst:[string] transfer-amount-lst:[decimal])
        @event
        (compose-capability (P|DT))
    )
    ;;
    (defcap SWPLC|C>ADD-STANDARD-LQ (swpair:string ld:object{SwapperLiquidityV1.LiquidityData})
        @event
        (compose-capability (SWPLC|C>X-ADD-LQ swpair ld))
    )
    (defcap SWPLC|C>ADD-ICED-LQ (swpair:string ld:object{SwapperLiquidityV1.LiquidityData})
        @event
        (compose-capability (SWPLC|C-ADD-CHILLED-LQ swpair ld))
    )
    (defcap SWPLC|C>ADD-GLACIAL-LQ (swpair:string ld:object{SwapperLiquidityV1.LiquidityData})
        @event
        (compose-capability (SWPLC|C-ADD-CHILLED-LQ swpair ld))
    )
    (defcap SWPLC|C>ADD-FROZEN-LQ 
        (swpair:string frozen-dptf:string ld:object{SwapperLiquidityV1.LiquidityData})
        @event
        (UEV_AddFrozenLiquidity swpair frozen-dptf)
        (compose-capability (SWPLC|C-ADD-CHILLED-LQ swpair ld))
        (compose-capability (P|SWPLC|REMOTE-GOV))
    )
    (defcap SWPLC|C>ADD-SLEEPING-LQ 
        (account:string swpair:string sleeping-dpof:string nonce:integer ld:object{SwapperLiquidityV1.LiquidityData})
        @event
        (UEV_AddSleepingLiquidity account swpair sleeping-dpof nonce)
        (compose-capability (SWPLC|C-ADD-DORMANT-LQ swpair ld))
        (compose-capability (P|SWPLC|REMOTE-GOV))
    )
    (defcap SWPLC|C-ADD-DORMANT-LQ (swpair:string ld:object{SwapperLiquidityV1.LiquidityData})
        (UEV_AddDormantLiquidity swpair)
        (compose-capability (SWPLC|C>X-ADD-LQ swpair ld))
    )
    (defcap SWPLC|C-ADD-CHILLED-LQ (swpair:string ld:object{SwapperLiquidityV1.LiquidityData})
        (UEV_AddChilledLiquidity swpair ld)
        (compose-capability (SWPLC|C>X-ADD-LQ swpair ld))
    )
    (defcap SWPLC|C>X-ADD-LQ (swpair:string ld:object{SwapperLiquidityV1.LiquidityData})
        (UEV_AddLiquidity swpair ld)
        (compose-capability (P|SECURE-CALLER))
        (compose-capability (P|SWPLC|REMOTE-GOV))
    )
    ;;
    (defcap SWPLC|C>REMOVE_LQ (swpair:string lp-amount:decimal)
        @event
        (UEV_RemoveLiquidity swpair lp-amount)
        (compose-capability (P|SECURE-CALLER))
        (compose-capability (P|SWPLC|REMOTE-GOV))
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun URC_EntityPosToID:string (swpair:string entity-pos:integer)
        @doc "For the LP Branding Functions"
        (let
            (
                (ref-U|INT:module{OuronetIntegersV1} U|INT)
                (ref-SWP:module{SwapperV1} SWP)
            )
            (ref-U|INT::UEV_PositionalVariable entity-pos 3 "Invalid entity position")
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                    (lp-id:string (ref-SWP::UR_TokenLP swpair))
                )
                (if (= entity-pos 1)
                    lp-id
                    (if (= entity-pos 2)
                        (ref-DPTF::UR_Frozen lp-id)
                        (ref-DPTF::UR_Sleeping lp-id)
                    )
                )
            )
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_InputsForLP (swpair:string input-amounts:[decimal])
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (ref-SWP:module{SwapperV1} SWP)
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (l1:integer (length input-amounts))
                (l2:integer (length pool-tokens))
                (sum:decimal (fold (+) 0.0 input-amounts))
            )
            (enforce (= l1 l2) "Invalid input amounts")
            (enforce (>= sum 0.0) "Input amounts Sum must be greater than zero")
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (amount:decimal (at idx input-amounts))
                            (pool-token:string (at idx pool-tokens))
                        )
                        (enforce (>= amount 0.0) "Amounts must be greater or equal to zero")
                        (if (> amount 0.0)
                            (ref-DPTF::UEV_Amount pool-token amount)
                            true
                        )
                    )
                )
                (enumerate 0 (- l1 1))
            )
        )
    )
    (defun UEV_AddFrozenLiquidity
        (swpair:string frozen-dptf:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (ref-SWP:module{SwapperV1} SWP)
                ;;
                (dptf:string (ref-DPTF::UR_Frozen frozen-dptf))
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (iz-frozen-dptf-compatible:bool (contains dptf pool-tokens))
            )
            (enforce iz-frozen-dptf-compatible (format "Frozen-DPTF {} isnt't compatible with Swpair {}" [frozen-dptf swpair]))
        )
    )
    (defun UEV_AddSleepingLiquidity 
        (account:string swpair:string sleeping-dpof:string nonce:integer)
        (let
            (
                (ref-DPOF:module{DemiourgosPactOrtoFungibleV1} DPOF)
                (ref-VST:module{VestingV1} VST)
                (ref-SWP:module{SwapperV1} SWP)
                ;;
                (dptf:string (ref-DPOF::UR_Sleeping sleeping-dpof))
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (iz-sleeping-dpof-compatible:bool (contains dptf pool-tokens))
            )
            (enforce iz-sleeping-dpof-compatible (format "sleeping-dpof {} isnt't compatible with Swpair {}" [sleeping-dpof swpair]))
            (ref-DPOF::UEV_NoncesToAccount sleeping-dpof account [nonce])
            (ref-VST::UEV_StillHasSleeping sleeping-dpof nonce)
        )
    )
    (defun UEV_AddDormantLiquidity (swpair:string)
        (let
            (
                (ref-SWP:module{SwapperV1} SWP)
                (iz-sleeping:bool (ref-SWP::UR_IzSleepingLP swpair))
            )
            (enforce iz-sleeping (format "Sleeping LP Functionality is not enabled on Swpair {}" [swpair]))
        )
    )
    (defun UEV_AddChilledLiquidity (swpair:string ld:object{SwapperLiquidityV1.LiquidityData})
        (let
            (
                (ref-SWP:module{SwapperV1} SWP)
                (iz-frozen:bool (ref-SWP::UR_IzFrozenLP swpair))
                (iz-asymmetric:bool (at "iz-asymmetric" (at "sorted-lq-type" ld)))
            )
            (enforce iz-asymmetric "Chilled Liquidity can only be added when asymtric liquidity exists")
            (enforce iz-frozen (format "Frozen LP Functionality is not enabled on Swpair {}" [swpair]))
        )
    )
    (defun UEV_AddLiquidity (swpair:string ld:object{SwapperLiquidityV1.LiquidityData})
        (let
            (
                (ref-SWP:module{SwapperV1} SWP)
                ;;
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
            (enforce can-add (format "Adding|Removing Liquidity isn't enabled on pool {}" [swpair]))
        )
    )
    (defun UEV_RemoveLiquidity (swpair:string lp-amount:decimal)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (ref-SWP:module{SwapperV1} SWP)
                ;;
                (can-add:bool (ref-SWP::UR_CanAdd swpair))
                (lp-id:string (ref-SWP::UR_TokenLP swpair))
                (pool-lp-amount:decimal (ref-DPTF::UR_Supply lp-id))
            )
            (ref-DPTF::UEV_Amount lp-id lp-amount)
            (enforce (<= lp-amount pool-lp-amount) (format "{} is an invalid LP Amount for removing Liquidity" [lp-amount]))
            (enforce can-add (format "Liquidity Adding and Removal isn't enabled on pool {}" [swpair]))
        )
    )
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;LP DPTF Branding
    (defun C_UpdatePendingBrandingLPs:object{IgnisCollectorV1.OutputCumulator}
        (swpair:string entity-pos:integer logo:string description:string website:string social:[object{BrandingV1.SocialSchema}])
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-BRD:module{BrandingV1} BRD)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (ref-DPOF:module{DemiourgosPactOrtoFungibleV1} DPOF)
                (entity-id:string (URC_EntityPosToID swpair entity-pos))
                (entity-owner:string
                    (if (= entity-pos 3)
                        (ref-DPOF::UR_Konto entity-id)
                        (ref-DPTF::UR_Konto entity-id)
                    )
                )
            )
            (with-capability (SWPLC|C>UPDATE-BRD swpair)
                (ref-BRD::XE_UpdatePendingBranding entity-id logo description website social)
                (ref-IGNIS::UDC_BrandingCumulator entity-owner 2.0)
            )
        )
    )
    (defun C_UpgradeBrandingLPs (patron:string swpair:string entity-pos:integer months:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-BRD:module{BrandingV1} BRD)
                (ref-SWP:module{SwapperV1} SWP)
                (owner:string (ref-SWP::UR_OwnerKonto swpair))
                (entity-id:string (URC_EntityPosToID swpair entity-pos))
                (kda-payment:decimal
                    (with-capability (SWPLC|C>UPGRADE-BRD swpair)
                        (ref-BRD::XE_UpgradeBranding entity-id owner months)
                    )
                )
            )
            (ref-IGNIS::KDA|C_CollectWT patron kda-payment false)
        )
    )
    ;;LQ Functions
    (defun C_ToggleAddLiquidity:object{IgnisCollectorV1.OutputCumulator}
        (swpair:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-SWP:module{SwapperV1} SWP)
            )
            (with-capability (P|SWPLC|CALLER)
                (ref-SWP::C_ToggleAddOrSwap swpair toggle true)
            )
        )
    )
    (defun C_Fuel:object{IgnisCollectorV1.OutputCumulator}
        (account:string swpair:string input-amounts:[decimal] direct-or-indirect:bool validation:bool)
        (UEV_IMC)
        (let
            (
                (ref-U|LST:module{StringProcessorV1} U|LST)
                (ref-TFT:module{TrueFungibleTransferV1} TFT)
                (ref-SWP:module{SwapperV1} SWP)
                (ref-SWPI:module{SwapperIssueV1} SWPI)
                ;;
                (pt-current-amounts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (has-zeros:bool (contains 0.0 input-amounts))
                (input-ids-for-transfer:[string]
                    (if has-zeros
                        (ref-SWPI::URC_TrimIdsWithZeroAmounts swpair input-amounts)
                        pool-tokens
                    )
                )
                (input-amounts-for-transfer:[decimal]
                    (if has-zeros
                        (ref-U|LST::UC_RemoveItem input-amounts 0.0)
                        input-amounts
                    )
                )
                (new-balances:[decimal] 
                    (zip (+) pt-current-amounts input-amounts)
                )
            )
            (if validation
                (UEV_InputsForLP swpair input-amounts)
                true
            )
            (if direct-or-indirect
                (with-capability (SWPLC|C>DIRECT-FUEL account swpair input-ids-for-transfer input-amounts-for-transfer)
                    (ref-SWP::XE_UpdateSupplies swpair new-balances)
                    (ref-TFT::C_MultiTransfer input-ids-for-transfer account SWP|SC_NAME input-amounts-for-transfer true)
                )
                (with-capability (SWPLC|C>INDIRECT-FUEL account swpair input-ids-for-transfer input-amounts-for-transfer)
                    (ref-SWP::XE_UpdateSupplies swpair new-balances)
                    EOC
                )
            )
        )
    )
    (defun C|KDA-PID_AddStandardLiquidity:object{IgnisCollectorV1.OutputCumulator}
        (account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UEV_IMC)
        (let
            (
                (ref-SWPL:module{SwapperLiquidityV1} SWPL)
                (ld:object{SwapperLiquidityV1.LiquidityData}
                    (ref-SWPL::URC_LD swpair input-amounts)
                )
            )
            (with-capability (SWPLC|C>ADD-STANDARD-LQ swpair ld)
                (let
                    (
                        (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                        (ref-TFT:module{TrueFungibleTransferV1} TFT)
                        (ref-SWP:module{SwapperV1} SWP)
                        
                        ;;
                        (lp-id:string (ref-SWP::UR_TokenLP swpair))
                        ;;
                        ;;Compute Liquidity Addition Data
                        (clad:object{SwapperLiquidityV1.CompleteLiquidityAdditionData}
                            (ref-SWPL::URC|KDA-PID_CLAD account swpair ld true true kda-pid)
                        )
                        ;;
                        (ico1:object{IgnisCollectorV1.OutputCumulator}
                            (at "perfect-ignis-fee" (at "clad-op" clad))
                        )
                        (native-lp-transfer-amount:decimal (at "primary-lp" clad))
                    )
                    (ref-SWPL::XE|KDA-PID_AddLiqudity account swpair true true kda-pid ld clad)
                    (let
                        (
                            (ico2:object{IgnisCollectorV1.OutputCumulator}
                                (ref-TFT::C_Transfer lp-id SWP|SC_NAME account native-lp-transfer-amount true)
                            )
                        )
                        ;;Autonomous Swap Mangement
                        (ref-SWPL::XE_AutonomousSwapManagement swpair)
                        ;;Output Cumulator
                        (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                            [ico1 ico2] [native-lp-transfer-amount]
                        )
                    )
                )
            )
        )
    )
    (defun C|KDA-PID_AddIcedLiquidity:object{IgnisCollectorV1.OutputCumulator}
        (account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UEV_IMC)
        (let
            (
                (ref-SWPL:module{SwapperLiquidityV1} SWPL)
                (ld:object{SwapperLiquidityV1.LiquidityData}
                    (ref-SWPL::URC_LD swpair input-amounts)
                )
            )
            (with-capability (SWPLC|C>ADD-ICED-LQ swpair ld)
                (let
                    (
                        (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                        (ref-TFT:module{TrueFungibleTransferV1} TFT)
                        (ref-VST:module{VestingV1} VST)
                        (ref-SWP:module{SwapperV1} SWP)
                        ;;
                        (lp-id:string (ref-SWP::UR_TokenLP swpair))
                        ;;
                        ;;Compute Liquidity Addition Data
                        (clad:object{SwapperLiquidityV1.CompleteLiquidityAdditionData}
                            (ref-SWPL::URC|KDA-PID_CLAD account swpair ld false true kda-pid)
                        )
                        ;;
                        (ico1:object{IgnisCollectorV1.OutputCumulator}
                            (at "perfect-ignis-fee" (at "clad-op" clad))
                            
                        )
                        (native-lp-transfer-amount:decimal (at "primary-lp" clad))
                        (frozen-lp-transfer-amount:decimal (at "secondary-lp" clad))
                    )
                    (ref-SWPL::XE|KDA-PID_AddLiqudity account swpair false true kda-pid ld clad)
                    (let
                        (
                            (ico2:object{IgnisCollectorV1.OutputCumulator}
                                (ref-TFT::C_Transfer lp-id SWP|SC_NAME account native-lp-transfer-amount true)
                            )
                            (ico3:object{IgnisCollectorV1.OutputCumulator}
                                (ref-VST::C_Freeze SWP|SC_NAME account lp-id frozen-lp-transfer-amount)
                            )
                        )
                        ;;Autonomous Swap Mangement
                        (ref-SWPL::XE_AutonomousSwapManagement swpair)
                        ;;Output Cumulator
                        (ref-IGNIS::UDC_ConcatenateOutputCumulators [
                            ico1 ico2 ico3] [native-lp-transfer-amount frozen-lp-transfer-amount]
                        )
                    )
                )
            )
        )
    )
    (defun C|KDA-PID_AddGlacialLiquidity:object{IgnisCollectorV1.OutputCumulator}
        (account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UEV_IMC)
        (let
            (
                (ref-SWPL:module{SwapperLiquidityV1} SWPL)
                (ld:object{SwapperLiquidityV1.LiquidityData}
                    (ref-SWPL::URC_LD swpair input-amounts)
                )
            )
            (with-capability (SWPLC|C>ADD-GLACIAL-LQ swpair ld)
                (let
                    (
                        (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                        (ref-TFT:module{TrueFungibleTransferV1} TFT)
                        (ref-VST:module{VestingV1} VST)
                        (ref-SWP:module{SwapperV1} SWP)
                        ;;
                        (lp-id:string (ref-SWP::UR_TokenLP swpair))
                        ;;
                        ;;Compute Liquidity Addition Data
                        (clad:object{SwapperLiquidityV1.CompleteLiquidityAdditionData}
                            (ref-SWPL::URC|KDA-PID_CLAD account swpair ld false false kda-pid)
                        )
                        ;;
                        (ico1:object{IgnisCollectorV1.OutputCumulator}
                            (at "perfect-ignis-fee" (at "clad-op" clad))
                            
                        )
                        (native-lp-transfer-amount:decimal (at "primary-lp" clad))
                        (frozen-lp-transfer-amount:decimal (at "secondary-lp" clad))
                    )
                    (ref-SWPL::XE|KDA-PID_AddLiqudity account swpair false false kda-pid ld clad)
                    (let
                        (
                            (ico2:object{IgnisCollectorV1.OutputCumulator}
                                (if (!= native-lp-transfer-amount 0.0)
                                    (ref-TFT::C_Transfer lp-id SWP|SC_NAME account native-lp-transfer-amount true)
                                    EOC
                                )
                            )
                            (ico3:object{IgnisCollectorV1.OutputCumulator}
                                (ref-VST::C_Freeze SWP|SC_NAME account lp-id frozen-lp-transfer-amount)
                            )
                        )
                        ;;Autonomous Swap Mangement
                        (ref-SWPL::XE_AutonomousSwapManagement swpair)
                        ;;Output Cumulator
                        (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                            [ico1 ico2 ico3] [native-lp-transfer-amount frozen-lp-transfer-amount]
                        )
                    )
                )
            )
        )
    )
    (defun C|KDA-PID_AddFrozenLiquidity:object{IgnisCollectorV1.OutputCumulator}
        (account:string swpair:string frozen-dptf:string input-amount:decimal kda-pid:decimal)
        (UEV_IMC)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV1} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                (ref-SWP:module{SwapperV1} SWP)
                (ref-SWPL:module{SwapperLiquidityV1} SWPL)
                ;;
                (dptf:string (ref-DPTF::UR_Frozen frozen-dptf))
                (ptp:integer (ref-SWP::UR_PoolTokenPosition swpair dptf))
                (lq-lst:[decimal] (ref-U|SWP::UC_MakeLiquidityList swpair ptp input-amount))
                (ld:object{SwapperLiquidityV1.LiquidityData}
                    (ref-SWPL::URC_LD swpair lq-lst)
                )
            )
            (with-capability (SWPLC|C>ADD-FROZEN-LQ swpair frozen-dptf ld)
                (let
                    (
                        (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                        (ref-DALOS:module{OuronetDalosV1} DALOS)
                        (ref-TFT:module{TrueFungibleTransferV1} TFT)
                        (ref-VST:module{VestingV1} VST)
                        ;;
                        (vst-sc:string (ref-DALOS::GOV|VST|SC_NAME))
                        (ignis-id:string (ref-DALOS::UR_IgnisID))
                        (lp-id:string (ref-SWP::UR_TokenLP swpair))
                        ;;
                        ;;Move F|DPTF to vst-sc and burn it
                        (ico1:object{IgnisCollectorV1.OutputCumulator}
                            (ref-TFT::C_Transfer frozen-dptf account vst-sc input-amount true)
                        )
                        (ico2:object{IgnisCollectorV1.OutputCumulator}
                            (ref-DPTF::C_Burn frozen-dptf vst-sc input-amount)
                        )
                        ;;
                        ;;Compute CLAD
                        (clad:object{SwapperLiquidityV1.CompleteLiquidityAdditionData}
                            (ref-SWPL::URC|KDA-PID_CLAD vst-sc swpair ld false false kda-pid)
                        )
                        ;;
                        (ico3:object{IgnisCollectorV1.OutputCumulator}
                            (at "perfect-ignis-fee" (at "clad-op" clad))
                        )
                        (frozen-lp-transfer-amount:decimal (at "secondary-lp" clad))
                    )
                    (ref-SWPL::XE|KDA-PID_AddLiqudity vst-sc swpair false false kda-pid ld clad)
                    (let
                        (
                            (ico4:object{IgnisCollectorV1.OutputCumulator}
                                (ref-VST::C_Freeze SWP|SC_NAME account lp-id frozen-lp-transfer-amount)
                            )
                        )
                        ;;Autonomous Swap Mangement
                        (ref-SWPL::XE_AutonomousSwapManagement swpair)
                        ;;Output Cumulator
                        (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                            [ico1 ico2 ico3 ico4] [frozen-lp-transfer-amount]
                        )
                    )
                )
            )
        )
    )
    (defun C|KDA-PID_AddSleepingLiquidity:object{IgnisCollectorV1.OutputCumulator}
        (account:string swpair:string sleeping-dpof:string nonce:integer kda-pid:decimal)
        (UEV_IMC)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV1} U|SWP)
                (ref-DPOF:module{DemiourgosPactOrtoFungibleV1} DPOF)
                (ref-TFT:module{TrueFungibleTransferV1} TFT)
                (ref-SWP:module{SwapperV1} SWP)
                (ref-SWPL:module{SwapperLiquidityV1} SWPL)
                ;;
                (dptf:string (ref-DPOF::UR_Sleeping sleeping-dpof))
                (ptp:integer (ref-SWP::UR_PoolTokenPosition swpair dptf))
                (batch-amount:decimal (ref-DPOF::UR_NonceSupply sleeping-dpof nonce))
                (lq-lst:[decimal] (ref-U|SWP::UC_MakeLiquidityList swpair ptp batch-amount))
                (ld:object{SwapperLiquidityV1.LiquidityData}
                    (ref-SWPL::URC_LD swpair lq-lst)
                )
            )
            (with-capability (SWPLC|C>ADD-SLEEPING-LQ account swpair sleeping-dpof nonce ld)
                (let
                    (
                        (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                        (ref-DALOS:module{OuronetDalosV1} DALOS)
                        (ref-VST:module{VestingV1} VST)
                        ;;
                        (vst-sc:string (ref-DALOS::GOV|VST|SC_NAME))
                        (ignis-id:string (ref-DALOS::UR_IgnisID))
                        (lp-id:string (ref-SWP::UR_TokenLP swpair))
                        ;;
                        (nonce-md:[object] (ref-DPOF::UR_NonceMetaData sleeping-dpof nonce))
                        (release-date:time (at "release-date" (at 0 nonce-md)))
                        (present-time:time (at "block-time" (chain-data)))
                        (dt:integer (floor (diff-time release-date present-time)))
                        ;;
                        ;;
                        ;;Move Z|DPMF to vst-sc and burn it
                        (ico1:object{IgnisCollectorV1.OutputCumulator}
                            (ref-DPOF::C_Transfer sleeping-dpof [nonce] account vst-sc true)
                        )
                        (ico2:object{IgnisCollectorV1.OutputCumulator}
                            (ref-DPOF::C_Burn sleeping-dpof vst-sc nonce batch-amount)
                        )
                        ;;
                        ;;Compute CLAD
                        (clad:object{SwapperLiquidityV1.CompleteLiquidityAdditionData}
                            (ref-SWPL::URC|KDA-PID_CLAD vst-sc swpair ld true true kda-pid)
                        )
                        ;;
                        ;;MOVE IGNIS to vst-sc, paying for the ignis-tax
                        (ico3:object{IgnisCollectorV1.OutputCumulator}
                            (ref-TFT::C_Transfer ignis-id account vst-sc (at "total-ignis-tax-needed" clad) true)
                        )
                        ;;
                        (ico4:object{IgnisCollectorV1.OutputCumulator}
                            (at "perfect-ignis-fee" (at "clad-op" clad))
                        )
                        (sleeping-lp-transfer-amount:decimal (at "primary-lp" clad))
                    )
                    (ref-SWPL::XE|KDA-PID_AddLiqudity vst-sc swpair true true kda-pid ld clad)
                    (let
                        (
                            (ico5:object{IgnisCollectorV1.OutputCumulator}
                                (ref-VST::C_Sleep SWP|SC_NAME account lp-id sleeping-lp-transfer-amount dt)
                            )
                        )
                        ;;Autonomous Swap Mangement
                        (ref-SWPL::XE_AutonomousSwapManagement swpair)
                        ;;Output Cumulator
                        (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                            [ico1 ico2 ico3 ico4 ico5] [sleeping-lp-transfer-amount]
                        )
                    )
                )
            )
        )
    )
    ;;
    (defun C_RemoveLiquidity:object{IgnisCollectorV1.OutputCumulator}
        (account:string swpair:string lp-amount:decimal)
        @doc "Removes <swpair> Liquidity using <lp-amount> of LP Tokens \
            \ Always returns all Pool Tokens at current Pool Token Ratio"
        ;;
        (UEV_IMC)
        (with-capability (SWPLC|C>REMOVE_LQ swpair lp-amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV1} TFT)
                    (ref-SWP:module{SwapperV1} SWP)
                    (ref-SWPL:module{SwapperLiquidityV1} SWPL)
                    ;;
                    (pool-token-ids:[string] (ref-SWP::UR_PoolTokens swpair))
                    (lp-id:string (ref-SWP::UR_TokenLP swpair))
                    (pt-output-amounts:[decimal] (ref-SWPL::URC_LpBreakAmounts swpair lp-amount))
                    (pt-current-amounts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                    (pt-new-amounts:[decimal] (zip (-) pt-current-amounts pt-output-amounts))
                    ;;
                    ;;Removing Liquidity requires a flat fee of 10$ in Ignis
                    ;;This deincentivizes frequent Liquidity removals
                    ;;
                    (flat-ignis-lq-rm-fee:decimal 1000.0)
                    (trigger:bool (ref-IGNIS::URC_IsVirtualGasZero))
                    (ico-flat:object{IgnisCollectorV1.OutputCumulator}
                        (ref-IGNIS::UDC_ConstructOutputCumulator flat-ignis-lq-rm-fee SWP|SC_NAME trigger [])
                    )
                    ;;
                    (ico1:object{IgnisCollectorV1.OutputCumulator}
                        (ref-TFT::C_Transfer lp-id account SWP|SC_NAME lp-amount true)
                    )
                    (ico2:object{IgnisCollectorV1.OutputCumulator}
                        (ref-DPTF::C_Burn lp-id SWP|SC_NAME lp-amount)
                    )
                    (ico3:object{IgnisCollectorV1.OutputCumulator}
                        (ref-TFT::C_MultiTransfer pool-token-ids SWP|SC_NAME account pt-output-amounts true)
                    )
                )
                ;;Updates Pool Supplies
                (ref-SWP::XE_UpdateSupplies swpair pt-new-amounts)
                ;;Autonomous Swap Mangement
                (ref-SWPL::XE_AutonomousSwapManagement swpair)
                ;;Output Cumulator
                (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico-flat ico1 ico2 ico3] pt-output-amounts)
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)