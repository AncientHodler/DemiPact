(module TS01-C3 GOV
    @doc "TALOS Administrator and Client Module for Stage 1"
    ;;
    (implements OuronetPolicy)
    (implements TalosStageOne_ClientThreeV2)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_TS01-C3        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TS01-C1_ADMIN)))
    (defcap GOV|TS01-C1_ADMIN ()    (enforce-guard GOV|MD_TS01-C3))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
                (ref-DALOS:module{OuronetDalosV6} DALOS)
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
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|TS01-C1_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|TS01-C1_ADMIN)
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
                (ref-P|IGNIS:module{OuronetPolicy} IGNIS)
                (ref-P|LIQUID:module{OuronetPolicy} LIQUID)
                (ref-P|ORBR:module{OuronetPolicy} OUROBOROS)
                (ref-P|SWPT:module{OuronetPolicy} SWPT)
                (ref-P|SWP:module{OuronetPolicy} SWP)
                (ref-P|SWPI:module{OuronetPolicy} SWPI)
                (ref-P|SWPL:module{OuronetPolicy} SWPL)
                (ref-P|SWPLC:module{OuronetPolicy} SWPLC)
                (ref-P|SWPU:module{OuronetPolicy} SWPU)
                (ref-P|TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                (mg:guard (create-capability-guard (P|TALOS-SUMMONER)))
            )
            (ref-P|IGNIS::P|A_AddIMP mg)
            (ref-P|LIQUID::P|A_AddIMP mg)
            (ref-P|ORBR::P|A_AddIMP mg)
            ;;
            (ref-P|SWPT::P|A_AddIMP mg)
            (ref-P|SWP::P|A_AddIMP mg)
            (ref-P|SWPI::P|A_AddIMP mg)
            (ref-P|SWPL::P|A_AddIMP mg)
            (ref-P|SWPLC::P|A_AddIMP mg)
            (ref-P|SWPU::P|A_AddIMP mg)
            (ref-P|TS01-A::P|A_AddIMP mg)
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
    ;;  [Swapper_Client]
    (defun SWP|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for SWPair Token <entity-id> costing 400 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-B|SWP:module{BrandingUsageV9} SWP)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-B|SWP::C_UpdatePendingBranding entity-id logo description website social)
                )
            )
        )
    )
    (defun SWP|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Similar to its DPTF, DPOF, ATS Variants"
        (with-capability (P|TS)
            (let
                (
                    (ref-B|SWP:module{BrandingUsageV9} SWP)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                )
                (ref-B|SWP::C_UpgradeBranding patron entity-id months)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    (defun SWP|C_UpdatePendingBrandingLPs (patron:string swpair:string entity-pos:integer logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for SWPair LPs (Native LP, Frozen LP or Sleeping LP) Token <entity-id> costing 200 IGNIS \
            \ <entity-pos> 1 = LP Token will be used \
            \ <entity-pos> 2 = Frozen-LP Token will be used \
            \ <entity-pos> 3 = Sleeping-LP Token will be used"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-B|SWPLC:module{BrandingUsageV10} SWPLC)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-B|SWPLC::C_UpdatePendingBrandingLPs swpair entity-pos logo description website social)
                )
            )
        )
    )
    (defun SWP|C_UpgradeBrandingLPs (patron:string swpair:string entity-pos:integer months:integer)
        @doc "Similar to its DPTF, DPOF, ATS SWP Variants, but for SWPair LPs"
        (with-capability (P|TS)
            (let
                (
                    (ref-B|SWPLC:module{BrandingUsageV10} SWPLC)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                )
                (ref-B|SWPLC::C_UpgradeBrandingLPs patron swpair entity-pos months)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    (defun SWP|C_ChangeOwnership (patron:string swpair:string new-owner:string)
        @doc "Changes Ownership of an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWP:module{SwapperV6} SWP)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWP::C_ChangeOwnership swpair new-owner)
                )
                (format "Succesfully changed ownership for SWP-Pair {}" [swpair])
            )
        )
    )
    (defun SWP|C_EnableFrozenLP:string (patron:string swpair:string)
        @doc "Enables the posibility of using Frozen Tokens to add Liquidity for an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                    (ref-SWP:module{SwapperV6} SWP)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    ;;
                    (lp-id:string (ref-SWP::UR_TokenLP swpair))
                    (current-frozen-link:string (ref-DPTF::UR_Frozen lp-id))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWP::C_EnableFrozenLP patron swpair)
                    )
                    (issued-frozen-lp-id:string (at 0 (at "output" ico)))
                )
                (ref-IGNIS::C_Collect patron ico)
                (if (= current-frozen-link BAR)
                    (do
                        (ref-TS01-A::XB_DynamicFuelKDA)
                        (format "Succesfully Issued Frozen LP {} and enabled Frozen LP Functionality on SWP-Pair {}" [issued-frozen-lp-id swpair])
                    )
                    (format 
                        "Succesfully enabled Frozen LP Functionality on SWP-Pair {}, without issuing a Frozen LP, as it allready exists with id {}" 
                        [swpair current-frozen-link]
                    )
                )
            )
        )
    )
    (defun SWP|C_EnableSleepingLP:string (patron:string swpair:string)
        @doc "Enables the posibility of using Sleeping Tokens to add Liquidity for an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                    (ref-SWP:module{SwapperV6} SWP)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    ;;
                    (lp-id:string (ref-SWP::UR_TokenLP swpair))
                    (current-sleeping-link:string (ref-DPTF::UR_Sleeping lp-id))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWP::C_EnableSleepingLP patron swpair)
                    )
                    (issued-sleeping-lp-id:string (at 0 (at "output" ico)))
                )
                (ref-IGNIS::C_Collect patron ico)
                (if (= current-sleeping-link BAR)
                    (do
                        (ref-TS01-A::XB_DynamicFuelKDA)
                        (format "Succesfully Issued Sleeping LP {} and enabled Frozen LP Functionality on SWP-Pair {}" [issued-sleeping-lp-id swpair])
                    )
                    (format 
                        "Succesfully enabled Sleeping LP Functionality on SWP-Pair {}, without issuing a Frozen LP, as it allready exists with id {}" 
                        [swpair current-sleeping-link]
                    )
                )
            )
        )
    )
    (defun SWP|C_IssueStable:list (patron:string account:string pool-tokens:[object{SwapperV6.PoolTokens}] fee-lp:decimal amp:decimal p:bool)
        @doc "Issues a Stable Liquidity Pool. First Token in the liquidity Pool must have a connection to a principal Token \
            \ Stable Pools have the S designation. \
            \ Stable Pools can be created with up to 7 Tokens, and have by design equal weighting. \
            \ The <p> boolean defines if The Pool is a Principal Pools. \
            \ Principal Pools are always on, and cant be disabled by low-liquidity."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPI:module{SwapperIssueV4} SWPI)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    (weights:[decimal] (make-list (length pool-tokens) 1.0))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPI::C_Issue patron account pool-tokens fee-lp weights amp p)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at "output" ico)
            )
        )
    )
    (defun SWP|C_IssueStandard:list (patron:string account:string pool-tokens:[object{SwapperV6.PoolTokens}] fee-lp:decimal p:bool)
        @doc "Issues a Standard, Constant Product Pool. \
            \ Constant Product Pools have the P Designation, and they are by design equal weigthed \
            \ Can also be created with up to 7 Tokens, also the <p> boolean determines if its a Principal Pool or not \
            \ The First Token must be a Principal Token"
        (SWP|C_IssueStable patron account pool-tokens fee-lp -1.0 p)
    )
    (defun SWP|C_IssueWeighted:list (patron:string account:string pool-tokens:[object{SwapperV6.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool)
        @doc "Issues a Weigthed Constant Liquidity Pool \
            \ Weigthed Pools have the W Designation, and the weights can be changed at will. \
            \ Can also be created with up to 7 Tokens, <p> boolean determines if its a Principal Pool or not \
            \ The First Token must also be a Principal Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPI:module{SwapperIssueV4} SWPI)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPI::C_Issue patron account pool-tokens fee-lp weights -1.0 p)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at "output" ico)
            )
        )
    )
    (defun SWP|C_ModifyCanChangeOwner (patron:string swpair:string new-boolean:bool)
        @doc "Modifies the <can-change-owner> parameter of an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWP:module{SwapperV6} SWP)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWP::C_ModifyCanChangeOwner swpair new-boolean)
                )
                (format "Succesfully updated SWP-Pair {} <can-change-owner> Parameter" [swpair])
            )
        )
    )
    (defun SWP|C_ModifyWeights (patron:string swpair:string new-weights:[decimal])
        @doc "Modify weights for an SWPair. Works only for W Pools"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWP:module{SwapperV6} SWP)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWP::C_ModifyWeights swpair new-weights)
                )
                (format "Succesfully updated SWP-Pair {} Weigths Parameter" [swpair])
            )
        )
    )
    (defun SWP|C_ToggleAddLiquidity (patron:string swpair:string toggle:bool)
        @doc "Toggle on or off the Functionality of adding liquidity for an <swpair> \
            \ When <toggle> is <true>, ensures required Mint, Burn, Transfer Roles are set, if not, set them. \
            \ The Roles are: \
            \ Mint and Burn Roles for LP Token (requires LP Token Ownership) \
            \ Fee Exemption Roles for all Tokens of an S-Pool, or \
            \ for all Tokens of a W- or P-Pool, except its first Token (which is principal) \
            \ Roles are needed to SWP|SC_NAME \
            \ \
            \ Requires <swpair> ownership"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClientV2} SWPLC)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWPLC::C_ToggleAddLiquidity swpair toggle)
                )
                (format "Succesfully toggled Liquidity Provisioning for SWP-Pair" [swpair])
            )
        )
    )
    (defun SWP|C_ToggleSwapCapability (patron:string swpair:string toggle:bool)
        @doc "Toggle on or off the Functionality of swapping for an <swpair> \
            \ When <toggle> is <true>, same setup for roles is executed as for <SWP|C_ToggleAddLiquidity> \
            \ \
            \ <On> Toggle can only be executed is <swpair> surpasses <(ref-SWP::UR_InactiveLimit)> \
            \ \
            \ Requires <swpair> ownership"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPU:module{SwapperUsageV5} SWPU)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWPU::C_ToggleSwapCapability swpair toggle)
                )
                (format "Succesfully toggled Swap Capability for SWP-Pair" [swpair])
            )
        )
    )
    (defun SWP|C_ToggleFeeLock (patron:string swpair:string toggle:bool)
        @doc "Locks the SPWPair fees in place. Modifying the SWPair fees requires them to be unlocked \
            \ Unlocking costs KDA and is financially discouraged"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWP:module{SwapperV6} SWP)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWP::C_ToggleFeeLock patron swpair toggle)
                    )
                    (collect:bool (at 0 (at "output" ico)))
                )
                (ref-IGNIS::C_Collect patron ico)
                (ref-TS01-A::XE_ConditionalFuelKDA collect)
                (format "Succesfully toggled the Fee Lock for the SWP-Pair" [swpair])
            )
        )
    )
    (defun SWP|C_UpdateAmplifier (patron:string swpair:string amp:decimal)
        @doc "Updates Amplifier Value; Only works on S-Pools (Stable Pools)"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWP:module{SwapperV6} SWP)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWP::C_UpdateAmplifier swpair amp)
                )
                (format "Succesfully updated SWP-Pair {} Amplifier Parameter" [swpair])
            )
        )
    )
    (defun SWP|C_UpdateFee (patron:string swpair:string new-fee:decimal lp-or-special:bool)
        @doc "Updates Fees Values for an SWPair \
            \ The <lp-or-special> boolean defines whether its the LP-Fee or Special-Fee that is changed \
            \ THe LP Fee is the amount of Swap Output kept by the Liquidity Pool, increasing the Value of its LP Token(s) \
            \ The Special-Fee is the Fee that is collected to the Special-Fee-Targets \
            \ The Fee must be between 0.0001 - 320.0 (promile, that would be 32%) \
            \ When <liquid-boost>, an universal SWP Parameter (that can be set only by the admin) is set to true \
            \   an amount equal to the LP-Fee is also used to boost the Liquid Kadena Index \
            \   which is why the fee must be capped at close a third of 100% (320 promile in this case)"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWP:module{SwapperV6} SWP)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWP::C_UpdateFee swpair new-fee lp-or-special)
                )
                (format "Succesfully updated SWP-Pair {} Fees" [swpair])
            )
        )
    )
    (defun SWP|C_UpdateSpecialFeeTargets (patron:string swpair:string targets:[object{SwapperV6.FeeSplit}])
        @doc "Updates the Special Fee Targets, along with their Split, for an SWPair"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWP:module{SwapperV6} SWP)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWP::C_UpdateSpecialFeeTargets swpair targets)
                )
                (format "Succesfully updated SWP-Pair {} Special Fee Targets" [swpair])
            )
        )
    )
    ;;
    (defun SWP|C_Fuel
        (patron:string account:string swpair:string input-amounts:[decimal])
        @doc "Fuels the <swpair> with <input-amounts> of Tokens. \
            \ Must contain values for all pool tokens, with zero for Tokens that arent used \
            \ Fueling increases Liquidity without issuing LP, therefore increasing LP Value"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClientV2} SWPLC) 
                )
                (ref-IGNIS::C_Collect patron
                    (ref-SWPLC::C_Fuel account swpair input-amounts true true)
                )
                (format "Succesfully fueled SWP-Pair {} with Token Amounts {}" [swpair input-amounts])
            )
        )
    )
    (defun SWP|C_AddLiquidity:string (patron:string account:string swpair:string input-amounts:[decimal])
        @doc "Adds Liquidity using <input-amounts> on <swpair>, in its default Standard Mode. \
            \ Must Contain 0.0 for Tokens not used; Pool Token Order must be followed for desired <input-amounts> \
            \ 1000 IGNIS Flat Fee Cost for adding liquidity to deincentivize addition of small values \
            \ \
            \ Liquidity can also be added on a completely empty pool, \
            \ if no asymetric liquidity exists in the <input-amounts> \
            \ In this case, the original Token Ratios are used, the SWPair was created with. \
            \ \
            \ DEFAULT MODE \
            \ \
            \ If Asymmetric LP is detected, further IGNIS costs are enforced \
            \ <ignis-gaseous-tax>, <deficit-ignis-tax>, <boost-ignis-tax> \
            \ Also a specific quantity of LP is relinquished as <fuel-lp-tax>"
        (with-capability (P|TS)
            (let
                (
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClientV2} SWPLC)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPLC::C|KDA-PID_AddStandardLiquidity account swpair input-amounts kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Generated {} Native LP Tokens for Swpair {}"
                    [(at 0 (at "output" ico)) swpair]
                )
            )
        )
    )
    (defun SWP|C_AddIcedLiquidity:string (patron:string account:string swpair:string input-amounts:[decimal])
        @doc "Same as <SWP|C_AddLiquidity>, but using ICED Mode \
            \ \
            \ ICED MODE \
            \ Returns a part of the <asymmetric-lp-amount> as Frozen LP \
            \ <Swpair> must be enabled for Frozen LP for this feature \
            \ Only works when asymetric-liquidity exists in <input-amounts> \
            \ if <input-amounts> have balanced-liquidity, Native LP is returned for it \
            \ \
            \ In ICED MODE, only the IGNIS <ignis-gaseous-tax> is paid \
            \ Therefore the <asymmetric-lp-fee-amount> is returned as native LP \
            \ While the rest of the <asymmetric-lp-amount> is returned as Frozen LP"
        (with-capability (P|TS)
            (let
                (
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClientV2} SWPLC)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPLC::C|KDA-PID_AddIcedLiquidity account swpair input-amounts kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Generated {} Native and {} Frozen LP Tokens for Swpair {}"
                    [(at 0 (at "output" ico)) (at 1 (at "output" ico)) swpair]
                )
            )
        )
    )
    (defun SWP|C_AddGlacialLiquidity:string (patron:string account:string swpair:string input-amounts:[decimal])
        @doc "Same as <SWP|C_AddLiquidity>, but using GLACIAL Mode \
            \ \
            \ GLACIAL MODE \
            \ Returns all of the <asymmetric-lp-amount> as Frozen LP \
            \ <Swpair> must be enabled for Frozen LP for this feature \
            \ Only works when asymetric-liquidity exists in <input-amounts> \
            \ if <input-amounts> have balanced-liquidity, Native LP is returned for it \
            \ \
            \ In GLACIAL MODE, no further IGNIS taxes are paid"
        (with-capability (P|TS)
            (let
                (
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClientV2} SWPLC)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPLC::C|KDA-PID_AddGlacialLiquidity account swpair input-amounts kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Generated {} Native and {} Frozen LP Tokens for Swpair {}"
                    [(at 0 (at "output" ico)) (at 1 (at "output" ico)) swpair]
                )
            )
        )
    )
    (defun SWP|C_AddFrozenLiquidity:string (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal)
        @doc "Adds Liquidity using a single <input-amount> of a single <frozen-dptf> \
            \ Since this is an asymetric-liquidity-amount, it is bound by max. deviation rules \
            \ 1000 IGNIS Flat Fee Cost for adding liquidity. \
            \ \
            \ FROZEN MODE \
            \ Returns all LP Tokens as Frozen LP Tokens \
            \ <Swpair> must be enabled for Frozen LP for this feature \
            \ Also, a frozen link for one of the <swpair> Pool Tokens must have been previously created."
        (with-capability (P|TS)
            (let
                (
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClientV2} SWPLC)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPLC::C|KDA-PID_AddFrozenLiquidity account swpair frozen-dptf input-amount kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Generated {} Frozen LP Tokens for Swpair {}"
                    [(at 0 (at "output" ico)) swpair]
                )
            )
        )
    )
    (defun SWP|C_AddSleepingLiquidity:string (patron:string account:string swpair:string sleeping-dpof:string nonce:integer)
        @doc "Adds Liquidity using a single <input-amount> of a single <sleeping-dpof> \
        \ Since this is an asymetric-liquidity-amount, it is bound by max. deviation rules \
        \ 1000 IGNIS Flat Fee Cost for adding liquidity. \
        \ \
        \ SLEEPING MODE \
        \ Returns all LP Tokens as Sleeping LP tokens \
        \ <Swpair> must be enabled for Sleeping LP for this feature \
        \ Also, a sleeping link for one of the <swpair> Pool Tokens must have been previously created."
        (with-capability (P|TS)
            (let
                (
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClientV2} SWPLC)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPLC::C|KDA-PID_AddSleepingLiquidity account swpair sleeping-dpof nonce kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Generated {} Leeping LP Tokens for Swpair {}"
                    [(at 0 (at "output" ico)) swpair]
                )  
            )
        )
    )
    (defun SWP|C_RemoveLiquidity (patron:string account:string swpair:string lp-amount:decimal)
        @doc "Removes <swpair> Liquidity using <lp-amount> of LP Tokens \
            \ Always returns all Pool Tokens at current Pool Token Ratio \
            \ Removing Liquidty complety leaving the pool exactly empty (0.0 tokens) is fully supported"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPLC:module{SwapperLiquidityClientV2} SWPLC) 
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPLC::C_RemoveLiquidity account swpair lp-amount)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Removed {} LP Tokens from SWP-Pair {}, yielding {} of all Pool Tokens" [lp-amount swpair (at "output" ico)])
            )
        )
    )
    ;;Swaps
    (defun SWP|C_Firestarter (fire-starter:string)
        @doc "Makes IGNIS for <fire-starter> using 10 native Kadenas"
        (with-capability (P|TS)
            (let
                (
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-DALOS:module{OuronetDalosV6} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                    (ref-LIQUID:module{KadenaLiquidStakingV5} LIQUID)
                    (ref-ORBR:module{OuroborosV5} OUROBOROS)
                    (ref-SWP:module{SwapperV6} SWP)
                    (ref-SWPU:module{SwapperUsageV5} SWPU)
                    ;;
                    (ouro:string (ref-DALOS::UR_OuroborosID))
                    (ignis:string (ref-DALOS::UR_IgnisID))
                    (primordial:string (ref-SWP::UR_PrimordialPool))
                    (fire-starter-ignis:decimal (ref-DPTF::UR_AccountSupply ignis fire-starter))
                    (fire-starter-ouro:decimal (ref-DPTF::UR_AccountSupply ouro fire-starter))
                )
                (enforce
                    (fold (and) true
                        [
                            (< fire-starter-ouro 1.0)
                            (>= fire-starter-ouro 0.0)
                            (< fire-starter-ignis 100.0)
                        ]
                    )
                    "Only empty or allmost empty Ouronet Accounts can firestart"
                )
                (let
                    (
                        (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                        (wkda:string (ref-DALOS::UR_WrappedKadenaID))
                        (ico1:object{IgnisCollectorV2.OutputCumulator}
                            (ref-LIQUID::C_WrapKadena fire-starter 10.0)
                        )
                        (ico2:object{IgnisCollectorV2.OutputCumulator}
                            (ref-SWPU::C_Swap fire-starter primordial [wkda] [10.0] ouro -1.0 kda-pid)
                        )
                        (gained-ouro:decimal (at 0 (at "output" ico2)))
                        (ico3:object{IgnisCollectorV2.OutputCumulator}
                            (ref-ORBR::C_SublimateV2 fire-starter fire-starter gained-ouro)
                        )
                    )
                    (format "Used 10 KDA to generate {} IGNIS with no IGNIS Costs!" [(at 0 (at "output" ico3))])              
                )
            )
        )
    )
    (defun SWP|C_SingleSwapWithSlippage
        (
            patron:string
            account:string
            swpair:string
            input-id:string
            input-amount:decimal
            output-id:string
            slippage:decimal
        )
        @doc "Executes A Swap from <input-id> with <input-amount> to <output-id> with <slippage>"
        (with-capability (P|TS)
            (let
                (
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPU:module{SwapperUsageV5} SWPU)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPU::C_Swap account swpair [input-id] [input-amount] output-id slippage kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Succesfully swapped input(s) to {} {}" [(at 0 (at "output" ico)) output-id])
            )
        )
    )
    (defun SWP|C_SingleSwapNoSlippage
        (
            patron:string
            account:string
            swpair:string
            input-id:string
            input-amount:decimal
            output-id:string
        )
        @doc "Executes A Swap from <input-id> with <input-amount> to <output-id> without slippage"
        (with-capability (P|TS)
            (let
                (
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPU:module{SwapperUsageV5} SWPU)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPU::C_Swap account swpair [input-id] [input-amount] output-id -1.0 kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Succesfully swapped input(s) to {} {}" [(at 0 (at "output" ico)) output-id])
            )
        )
    )
    (defun SWP|C_MultiSwapWithSlippage
        (
            patron:string
            account:string
            swpair:string
            input-ids:[string]
            input-amounts:[decimal]
            output-id:string
            slippage:decimal
        )
        @doc "Executes A Swap from <input-ids> with <input-amounts> to <output-id> with <slippage>"
        (with-capability (P|TS)
            (let
                (
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPU:module{SwapperUsageV5} SWPU)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPU::C_Swap account swpair input-ids input-amounts output-id slippage kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Succesfully swapped input(s) to {} {}" [(at 0 (at "output" ico)) output-id])
            )
        )
    )
    (defun SWP|C_MultiSwapNoSlippage
        (
            patron:string
            account:string
            swpair:string
            input-ids:[string]
            input-amounts:[decimal]
            output-id:string
        )
        @doc "Executes A Swap from <input-id> with <input-amount> to <output-id> without slippage"
        (with-capability (P|TS)
            (let
                (
                    (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-SWPU:module{SwapperUsageV5} SWPU)
                    (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-SWPU::C_Swap account swpair input-ids input-amounts output-id -1.0 kda-pid)
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Succesfully swapped input(s) to {} {}" [(at 0 (at "output" ico)) output-id])
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)