(module SWPL GOV
    @doc "Exposes Liquidity Functions"
    ;;
    (implements OuronetPolicy)
    (implements SwapperLiquidityV2)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_SWPL           (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst SWP|SC_NAME           (GOV|SWP|SC_NAME))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|SWPL_ADMIN)))
    (defcap GOV|SWPL_ADMIN ()       (enforce-guard GOV|MD_SWPL))
    ;;
    (defun GOV|SWP|SC_NAME ()       (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|SWP|SC_NAME)))
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
    (defcap P|SWPL|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|SWPL|CALLER))
        (compose-capability (SECURE))
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
        (with-capability (GOV|SWPL_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|SWPL_ADMIN)
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
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                ;(ref-P|DPOF:module{OuronetPolicy} DPOF)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|VST:module{OuronetPolicy} VST)
                (ref-P|SWP:module{OuronetPolicy} SWP)
                (mg:guard (create-capability-guard (P|SWPL|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            ;(ref-P|DPOF::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|SWP::P|A_AddIMP mg)
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
    (defcap SWPL|S>ASYMMETRIC-LQ-GASEOUS-TAX (text:string)
        @doc "ASYMMETRIC-LQ-GASEOUS-TAX \
            \   PURPOSE     Compensates for the LP token deficit arising from asymmetric liquidity additions, \
            \               as determined by the Curve liquidity formula, which calculates excess LP tokens \
            \               compared to a balanced addition. Unlike the Curve approach, which restricts LP minting, \
            \               this tax permits minting but imposes a gas fee in Ignis to offset the deficit. \
            \   CALCULATION The tax is the Ignis equivalent of the LP token deficit (e.g., X LP units), \
            \               computed using the Curve formula based on V-POOL reserves. \
            \               where the V-Pool reserves are: [Pool-Reserves + Balanced Liq Part] from Input Liquidty) \
            \               The LP value is converted to Ignis \
            \   APPLICATION Collected as gas during the liquidity addition transaction, \
            \               subject to Elite Account Gas Discounts (e.g., reduced by Z%). \
            \               This tax maintains pool balance by charging users for excess LP tokens minted"
        @event
        true
    )
    (defcap SWPL|S>ASYMMETRIC-LQ-DEFICIT-TAX (text:string)
        @doc "ASYMMETRIC-LQ-DEFICIT-TAX \
        \   PURPOSE     The Asymmetric Liquidity Deficit Tax mitigates pool imbalance and LP token dilution \
        \               from asymmetric liquidity additions. It targets the difference between \
        \               the deficit (Token A cost to achieve the Asymmetric Break Amounts, ABA) \
        \               and fees (Boost, Fuel, Special), which are computed via virtual swaps. \
        \ \
        \   DEFICIT and ABA Derivationa \
        \               The deficit is the Token A cost to balance an asymmetric input \
        \               (e.g., [0 A, X B, Y C, Z D]) using the Virtual Swap Engine (VSE) \
        \               on the Virtual Pool (V-POOL) (original reserves + balanced liquidity). \
        \               The ABA ([A_aba, B_aba, C_aba, D_aba]) is obtained by calculating \
        \               full LP tokens for the asymmetric addition on V-POOL and removing them, preserving pool ratios. \
        \       VIRTUAL SWAPS \
        \           DIRECT SWAPS \
        \               Convert non-A tokens (e.g., X B → W A) to Token A, with fees (save Fee Values) \
        \              (which are subject to Elite Account Discoutn). No swap if only A is input \
        \           REVERSE|FORWARD SWAPS (For (n-1) non-A ABA tokens (n = pool tokens)) \
        \               Compute A needed for B_aba via reverse swap with fees \
        \               Perform forward swap (Computed A → B_aba, save Fee Values) \
        \               Repeat for C, D, etc \
        \           DEFICIT \
        \               The absolute value of the negative A amount accrued in the virtual swap account \
        \               after all the Forward Virtual Swaps is the TOTAL Deficit \
        \               This value incorporates all the Fees generated by the forward virtual swaps. \
        \               Difference Deficit = Total Deficit minus value of Fees. \
        \       REASONING \
        \               Virtual swaps measure the cost of achieving ABA, using V-POOL for stable ratios \
        \               and incorporating fees to assess damage. \
        \   TAX CALCULATION \
        \       FIXED       50% of the Difference Deficit, flat fee \
        \       VARIABLE    Imbalance cause by asymmetric liquidity (share deviation e.g., W%) \
        \                   capped at 40% Maximum Pool Deviation (which is (n-1)/n given n number of Pool Tokens) \
        \       TOTAL       FIXED + VARIABLE \
        \ \
        \   APPLICATION Collectes as IGNIS to the SWP|SC_NAME Smart Ouronet Account \
        \   SUMMARY     The Deficit Tax, based on Virtual Swaps Computation on V-POOL Data, \
        \               addresses residual damage. ABA is derived by removing LP tokens, \
        \               with deficit accrued from the forward swaps. \
        \               The tax (50% flat + deviation, capped at 40%) ensures fairness and scalability"
        @event
        true
    )
    (defcap SWPL|S>ASYMMETRIC-LQ-FUELING-TAX (text:string)
        @doc "ASYMMETRIC-LQ-FUELING-TAX \
        \   PURPOSE     Enhances LP token value during asymmetric liquidity additions \
        \               by reducing the number of LP tokens minted, counteracting dilution. \
        \               It is based on the Fuel fee computed via virtual swaps, \
        \               as detailed in the Asymmetric Liquidity Deficit Tax documentation \
        \   DERIVATION  Corresponds to the Fuel fee portion from the Virtual Swap Engine (VSE) swaps \
        \               performed on the Virtual Pool (V-POOL) (original reserves + balanced liquidity) \
        \               to achieve the Asymmetric Break Amounts (ABA), \
        \               as detailed in the Asymmetric Liquidity Deficit Tax documentation \
        \   TAC CALCULATION \
        \               The Fee Value computed in pool Tokens, is converted to Token A equivalents using the Pool ratio \
        \               which are then converted to an IGNIS amount value, then to an LP Token Value. \
        \       REASONING \
        \               The Fuel fee, derived from virtual swaps, represents the cost of processing asymmetric inputs. \
        \               Reducing LP minting by this amount preserves LP value, mimicking traditional fueling mechanisms. \
        \ \
        \   APPLICATION Applied by reducing the amount of LP Tokens minted by the calculated amount \
        \   SUMMARY     The Fueling Tax, based on the Fuel fee from VSE swaps on the V-POOL, \
        \               mitigates LP dilution by reducing minted LP tokens (e.g., V LP). \
        \               It leverages the swap process outlined in the Deficit Tax documentation, \
        \               ensuring efficiency and fairness in asymmetric liquidity additions."
        @event
        true
    )
    (defcap SWPL|S>ASYMMETRIC-LQ-SPECIAL-TAX (text:string)
        @doc "ASYMMETRIC-LQ-SPECIAL-TAX \
        \   PURPOSE     Allocates funds to ecosystem targets \
        \               (e.g., governance, incentives) during asymmetric liquidity additions, \
        \               using the Special fee computed via virtual swaps, \
        \               as detailed in the Asymmetric Liquidity Deficit Tax documentation \
        \   DERIVATION  Corresponds to the Special fee portion from the Virtual Swap Engine (VSE) swaps \
        \               performed on the Virtual Pool (V-POOL) (original reserves + balanced liquidity) \
        \               to achieve the Asymmetric Break Amounts (ABA), \
        \               as detailed in the Asymmetric Liquidity Deficit Tax documentation \
        \   TAC CALCULATION \
        \               The Fee Value computed in pool Tokens, is converted to Token A equivalents using the Pool ratio \
        \               which are then converted to an IGNIS amount value \
        \       REASONING \
        \               The Special fee reflects swap processing costs, redirected to support ecosystem functions. \
        \ \
        \   APPLICATION Collected in Ignis and transferred to designated targets via BulkTransfer \
        \   SUMMARY     The Special Tax, based on the Special fee from VSE swaps on the V-POOL, \
        \               supports ecosystem targets (e.g., V Ignis). \
        \               It leverages the Deficit Tax’s swap process, promoting fairness in asymmetric liquidity additions"
        @event
        true
    )
    (defcap SWPL|S>ASYMMETRIC-LQ-LQBOOST-TAX (text:string)
        @doc "ASYMMETRIC-LQ-LQBOOST-TAX \
        \   PURPOSE     Enhances the LiquidIndex of the LKDA Token, during asymmetric liqudity Additions \
        \               using the Boost fee computed via virtual swaps, \
        \               as detailed in the Asymmetric Liquidity Deficit Tax documentation \
        \   DERIVATION  Corresponds to the Boost fee portion from the Virtual Swap Engine (VSE) swaps \
        \               performed on the Virtual Pool (V-POOL) (original reserves + balanced liquidity) \
        \               to achieve the Asymmetric Break Amounts (ABA), \
        \               as detailed in the Asymmetric Liquidity Deficit Tax documentation \
        \   TAC CALCULATION \
        \               The Fee Value computed in pool Tokens, is converted to Token A equivalents using the Pool ratio \
        \               which are then converted to an IGNIS amount value. \
        \       REASONING \
        \               The Boost fee reflects swap processing costs, redirected to increase the value of LKDA \
        \   APPLICATION Resulted IGNIS is compressed to OURO, \
        \               which is then further used to fuel the LKDA-OURO-WKDA Primal Ouronet Pool, \
        \               while burning an equivalent amount of LKDA, thus increasing the LiquidIndex \
        \               which further increases LKDA value in WKDA \
        \   SUMMARY     The Boost Tax, based on the Boost fee from the VSE Swaps on the V-POOL \
        \               supports the Ouronet Ecosystem by increasing the value of LKDA in WKDA \
        \               It leverages the Deficit Tax’s swap process, promoting fairness in asymmetric liquidity additions"
        @event
        true
    )
    (defcap SWPL|S>ADD_ASYMMETRIC-LQ (account:string swpair:string input-amounts:[decimal])
        @doc "Exposes <input-amounts> when they have an asymetric part \
            \ when Liquidity is added from <account> on <swpair>"
        @event
        true
    )
    (defcap SWPL|S>ADD_BALANCED-LQ (account:string swpair:string input-amounts:[decimal])
        @doc "Exposes <input-amounts> when they have a balanced part \
            \ when Liquidity is added from <account> on <swpair>"
        @event
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_DetermineLiquidity:object{SwapperLiquidityV2.LiquiditySplitType}
        (input-lqs:object{SwapperLiquidityV2.LiquiditySplit})
        (UDC_LiquiditySplitType
            (!= (at "balanced" input-lqs) (make-list (length (at "balanced" input-lqs)) 0.0))
            (!= (at "asymmetric" input-lqs) (make-list (length (at "asymmetric" input-lqs)) 0.0))
        )
    )
    ;;
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun URC|KDA-PID_LpToIgnis:decimal (swpair:string amount:decimal kda-pid:decimal)
        (let
            (
                (ref-SWPI:module{SwapperIssueV4} SWPI)
                ;;
                (ignis-prec:integer (URC_IgnisPrecision))
                (pool-value:[decimal] (ref-SWPI::URC_PoolValue swpair))
                (lp-value-in-dwk:decimal (at 1 pool-value))
            )
            (floor (fold (*) 100.0 [amount lp-value-in-dwk kda-pid]) 2)
        )
    )
    (defun URC|KDA-PID_TokenToIgnis (id:string amount:decimal kda-pid:decimal)
        (let
            (
                (ref-SWPI:module{SwapperIssueV4} SWPI)
                ;;
                (ignis-prec:integer (URC_IgnisPrecision))
                (a-price:decimal (ref-SWPI::URC_TokenDollarPrice id kda-pid))
            )
            (floor (fold (*) 1.0 [100.0 a-price amount]) ignis-prec)
        )
    )
    (defun URC|KDA-PID_CLAD:object{SwapperLiquidityV2.CompleteLiquidityAdditionData}
        (
            account:string swpair:string ld:object{SwapperLiquidityV2.LiquidityData} 
            asymmetric-collection:bool gaseous-collection:bool kda-pid:decimal
        )
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                (ref-SWP:module{SwapperV6} SWP)
                (ref-SWPI:module{SwapperIssueV4} SWPI)
                ;;
                (iz-balanced:bool (at "iz-balanced" (at "sorted-lq-type" ld)))
                (iz-asymmetric:bool (at "iz-asymmetric" (at "sorted-lq-type" ld)))
                (balanced-liquidity:[decimal] (at "balanced" (at "sorted-lq" ld)))
                (asymmetric-liquidity:[decimal] (at "asymmetric" (at "sorted-lq" ld)))
                (total-input-liquidity:[decimal] (zip (+) balanced-liquidity asymmetric-liquidity))
                ;;
                (balanced-lp-amount:decimal (at "balanced" ld))
                ;;
                ;;Create <ico-flat>
                (flat-ignis-lq-fee:decimal 1000.0)
                (trigger:bool (ref-IGNIS::URC_IsVirtualGasZero))
                (ico-flat:object{IgnisCollectorV2.OutputCumulator}
                    (ref-IGNIS::UDC_ConstructOutputCumulator flat-ignis-lq-fee SWP|SC_NAME trigger [])
                )
                ;;Initial Transfer IDs and Amounts
                (input-ids-for-transfer:[string]
                    (if (and (not iz-balanced) iz-asymmetric)
                        (ref-SWPI::URC_TrimIdsWithZeroAmounts swpair total-input-liquidity)
                        (ref-SWP::UR_PoolTokens swpair)
                    )
                )
                (input-amounts-for-transfer:[decimal]
                    (if (and (not iz-balanced) iz-asymmetric)
                        (ref-U|LST::UC_RemoveItem total-input-liquidity 0.0)
                        total-input-liquidity
                    )
                )
                ;;General Variables
                (pt-ids:[string] (ref-SWP::UR_PoolTokens swpair))
                (pt-current-amounts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (pt-amounts-with-balanced:[decimal] 
                    (zip (+) pt-current-amounts balanced-liquidity)
                )
                (pt-amounts-with-asymmetric:[decimal] 
                    (zip (+) pt-amounts-with-balanced asymmetric-liquidity)
                )
            )
            (if iz-asymmetric
                (let
                    (
                        (asymmetric-lp-amount:decimal (at "asymmetric" ld))
                        (asymmetric-lp-fee-amount:decimal (at "asymmetric-fee" ld))
                        (full-asymmetric-deviation:[decimal] (UEV_Liquidity swpair ld))
                        (asymmetric-deviation:decimal (at 0 full-asymmetric-deviation))
                        (computed-gaseous-fee:decimal (URC|KDA-PID_LpToIgnis swpair asymmetric-lp-fee-amount kda-pid))
                        (raw-gaseous-fee:decimal
                            (if (< computed-gaseous-fee 50.0)
                                50.0
                                (dec (ceiling computed-gaseous-fee))
                            )
                        )
                        (gaseous-ignis-fee:decimal
                            (if gaseous-collection
                                raw-gaseous-fee
                                0.0
                            )
                        )
                        (ico-gaseous:object{IgnisCollectorV2.OutputCumulator}
                            (if gaseous-collection
                                (ref-IGNIS::UDC_ConstructOutputCumulator gaseous-ignis-fee SWP|SC_NAME trigger [])
                                EOC
                            )
                        )
                        (gaseous-text:string
                            (format "~{} LP out of a total ~{} Asym-LP, covered by {} IGNIS (discounted as GAS), as Asym-Liq.-FEE"
                                [(floor asymmetric-lp-fee-amount 4) (floor asymmetric-lp-amount 4) gaseous-ignis-fee]
                            )
                        )
                    )
                    (if asymmetric-collection
                        ;;Asymmetric Liquidity With Asymetric TAX Collection
                        (let
                            (
                                (ref-U|LST:module{StringProcessor} U|LST)
                                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                                (ignis-id:string (ref-DALOS::UR_IgnisID))
                                (ignis-prec:integer (ref-DPTF::UR_Decimals ignis-id))
                                (lkda-id:string (ref-DALOS::UR_LiquidKadenaID))
                                ;;Compute Asymetric Tax
                                (asymmetric-tax:object{SwapperLiquidityV2.AsymmetricTax} (URC_AsymmetricTax account swpair ld))
                                ;;
                                (a-id:string (at 0 pt-ids))
                                (a-prec:integer (ref-DPTF::UR_Decimals a-id))
                                
                                ;;
                                ;;<ASYMMETRIC-LQ-DEFICIT-TAX>
                                (tad-diff-fillup:decimal (+ asymmetric-deviation 0.5))
                                (tad-diff:decimal (at "tad-diff" asymmetric-tax))
                                (tad-diff-fillup-as-a:decimal (floor (* tad-diff tad-diff-fillup) a-prec))
                                (raw-deficit-ignis-tax:decimal (URC|KDA-PID_TokenToIgnis a-id tad-diff-fillup-as-a kda-pid))
                                (deficit-ignis-tax:decimal
                                    (if (< raw-deficit-ignis-tax 50.0)
                                        50.0 (ceiling raw-deficit-ignis-tax 2)
                                    )
                                )
                                ;;
                                ;;ASYMMETRIC-LQ-FUELING-TAX
                                (relinquish-lp:decimal (at "fuel-to-lp" asymmetric-tax))
                                ;;
                                ;;ASYMMETRIC-LQ-SPECIAL-TAX
                                (special-as-a:decimal (at "special" asymmetric-tax))
                                (raw-special-ignis-tax:decimal (URC|KDA-PID_TokenToIgnis a-id special-as-a kda-pid))
                                (special-ignis-tax:decimal
                                    (if (and (> raw-special-ignis-tax 0.0) (< raw-special-ignis-tax 50.0))
                                        50.0 (ceiling raw-special-ignis-tax 2)
                                    )
                                )
                                ;;
                                ;;ASYMMETRIC-LQ-LQBOOST-TAX
                                (boost-as-a:decimal (at "boost" asymmetric-tax))
                                (raw-lqboost-ignis-tax:decimal 
                                    (if (= boost-as-a 0.0)
                                        0.0
                                        (URC|KDA-PID_TokenToIgnis a-id boost-as-a kda-pid)
                                    )
                                )
                                (lqboost-ignis-tax:decimal
                                    (if (and (> raw-lqboost-ignis-tax 0.0) (< raw-lqboost-ignis-tax 100.0))
                                        100.0 (dec (ceiling raw-lqboost-ignis-tax))
                                    )
                                )
                                ;;Construc ICOz
                                (ignis-swp:decimal (fold (+) 0.0 [deficit-ignis-tax special-ignis-tax lqboost-ignis-tax]))
                                (ignis-id:string (ref-DALOS::UR_IgnisID))
                                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                                (secondary-ids-for-transfer:[string] (ref-U|LST::UC_InsertFirst input-ids-for-transfer ignis-id))
                                (secondary-amounts-for-transfer:[decimal] (ref-U|LST::UC_InsertFirst input-amounts-for-transfer ignis-swp))
                                (ico1:object{IgnisCollectorV2.OutputCumulator}
                                    ;;For initial Transfer towards the SWP|SC_NAME of input tokens and ignis (removed Ignis additions as is always zero)
                                    (ref-TFT::UDC_MultiTransferCumulator input-ids-for-transfer account SWP|SC_NAME input-amounts-for-transfer)
                                )
                                (ico2:object{IgnisCollectorV2.OutputCumulator}
                                    ;;For LP Minting (2)
                                    (ref-IGNIS::UDC_SmallCumulator SWP|SC_NAME)
                                )
                                ;;
                                (read-bk-ids:[string] (ref-SWP::UR_SpecialFeeTargets swpair))
                                (bk-ids:[string] (if (= read-bk-ids [BAR]) [BAR] read-bk-ids))
                                (bk-amt:[decimal]
                                    (if (= read-bk-ids [BAR])
                                        [0.0]
                                        (ref-U|SWP::UC_SpecialFeeOutputs
                                            (ref-SWP::UR_SpecialFeeTargetsProportions swpair)
                                            special-ignis-tax
                                            ignis-prec
                                        )
                                    )
                                )
                                ;;Cumulator needed if Liquid Boost is enabled and executed
                                (ico5:object{IgnisCollectorV2.OutputCumulator}
                                    ;;ico3 for IGNIS to special Targets is always zero: removed
                                    ;;Ico4 for IGNIS burn is always zero;removed
                                    ;;Used for the OURO Mint (2)
                                    (ref-IGNIS::UDC_ConstructOutputCumulator 
                                        (ref-DALOS::UR_UsagePrice "ignis|small") 
                                        SWP|SC_NAME 
                                        (ref-IGNIS::URC_ZeroGAS ouro-id account) []
                                    )
                                )
                                (ico6:object{IgnisCollectorV2.OutputCumulator}
                                    ;;Used for LKDA Burn (2)
                                    (ref-IGNIS::UDC_ConstructOutputCumulator 
                                        (ref-DALOS::UR_UsagePrice "ignis|small") 
                                        SWP|SC_NAME 
                                        (ref-IGNIS::URC_ZeroGAS lkda-id account) []
                                    )
                                )
                                (ico56:object{IgnisCollectorV2.OutputCumulator}
                                    (if (= lqboost-ignis-tax 0.0)
                                        EOC
                                        (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                                            [ico5 ico6] 
                                            []
                                        )
                                    )
                                )
                                (s-ico1:object{IgnisCollectorV2.OutputCumulator}
                                    (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                                        [ico-flat ico-gaseous ico1 ico2 ico56] 
                                        []
                                    )
                                )
                            )
                            (UDC_CompleteLiquidityAdditionData
                                total-input-liquidity
                                balanced-liquidity
                                asymmetric-liquidity
                                full-asymmetric-deviation
                                ;;
                                (- (+ balanced-lp-amount asymmetric-lp-amount) relinquish-lp)
                                0.0
                                ;;
                                (fold (+) 0.0 [deficit-ignis-tax special-ignis-tax lqboost-ignis-tax])
                                ;;
                                gaseous-ignis-fee
                                deficit-ignis-tax
                                special-ignis-tax
                                lqboost-ignis-tax
                                relinquish-lp
                                ;;
                                gaseous-text
                                (format "{} IGNIS costs for a Deviation of ~{}%, as Asym-Liq.-Deficit-TAX"
                                    [deficit-ignis-tax (floor (* 100.0 asymmetric-deviation) 4)]
                                )
                                (if (= special-ignis-tax 0.0)
                                    "Without Asym-Liq.-Special-Tax, as Pool isn't setup up with a special fee"
                                    (format "{} IGNIS credited to Special Targets, as Asym-Liq.-Special-TAX"
                                        [special-ignis-tax]
                                    )
                                )
                                (if (= lqboost-ignis-tax 0.0)
                                    "Without Asym-Liq.LqBoost-TAX, as Global Liquid Boost is disabled"
                                    (format "{} IGNIS fueling LKDA LiquidIndex, as Asym-Liq.LqBoost-TAX"
                                        [lqboost-ignis-tax]
                                    )
                                )
                                (format "Relinquish ~{} LP increasing LP Value, as Asym-Liq.-Fueling-TAX"
                                    [(floor relinquish-lp 4)]
                                )
                                (UDC_CladOperation
                                    s-ico1
                                    ;;
                                    secondary-ids-for-transfer
                                    secondary-amounts-for-transfer
                                    true
                                    bk-ids
                                    bk-amt
                                    ;;
                                    pt-amounts-with-balanced
                                    pt-amounts-with-asymmetric
                                )
                            )
                        )
                        ;;Asymmetric Liquidity Without Asymetric TAX Collection
                        (UDC_CompleteLiquidityAdditionData
                            total-input-liquidity
                            balanced-liquidity
                            asymmetric-liquidity
                            full-asymmetric-deviation
                            ;;
                            (if gaseous-collection
                                (+ balanced-lp-amount asymmetric-lp-fee-amount)
                                balanced-lp-amount
                            )
                            (if gaseous-collection
                                (- asymmetric-lp-amount asymmetric-lp-fee-amount)
                                asymmetric-lp-amount
                            )
                            ;;
                            0.0
                            ;;
                            gaseous-ignis-fee
                            0.0
                            0.0
                            0.0
                            0.0
                            ;;
                            (if gaseous-collection
                                gaseous-text
                                (format "Credited ~{} LP out of a total ~{} Asym-LP, with no IGNIS Asym-Liq.-Fee"
                                    [(floor asymmetric-lp-fee-amount 4) (floor asymmetric-lp-amount 4)]
                                )
                            )
                            (format "Asymmetric Deviation ~{}%: no Asym-Liq.-Deficit-Tax"
                                [(floor (* 100.0 asymmetric-deviation) 4)]
                            )
                            "Without Asym-Liq.-Special-Tax"
                            "Without Asym-Liq.-LqBoost-Tax"
                            "Without Asym-Liq.-Fueling-Tax"
                            (UDC_CladOperation
                                (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                                    [
                                        ico-flat ico-gaseous 
                                        (ref-TFT::UDC_MultiTransferCumulator 
                                            input-ids-for-transfer account SWP|SC_NAME input-amounts-for-transfer
                                        )
                                        (ref-IGNIS::UDC_SmallCumulator SWP|SC_NAME)
                                    ] 
                                    []
                                )
                                ;;
                                input-ids-for-transfer
                                input-amounts-for-transfer
                                false
                                [BAR]
                                [0.0]
                                ;;
                                pt-amounts-with-balanced
                                pt-amounts-with-asymmetric
                            )
                        )
                    )
                )
                (UDC_CompleteLiquidityAdditionData
                    total-input-liquidity
                    balanced-liquidity
                    asymmetric-liquidity
                    [0.0 0.0]
                    ;;
                    balanced-lp-amount
                    0.0
                    ;;
                    0.0
                    ;;
                    0.0
                    0.0
                    0.0
                    0.0
                    0.0
                    ;;
                    (format "Balanced-Liquidity, ({} IGNIS as Asym-Liq.-Fee)" [0.0])
                    (format "Balanced-Liquidity, ({} IGNIS as Asym-Liq.-Deficit-Tax)" [0.0])
                    (format "Balanced-Liquidity, ({} IGNIS as Asym-Liq.-Special-Tax)" [0.0])
                    (format "Balanced-Liquidity, ({} IGNIS as Asym-Liq.-LqBoost-Tax)" [0.0])
                    (format "Balanced-Liquidity, ({} LP relinquished as Asym-Liq.-Fueling-Tax)" [0.0])
                    (UDC_CladOperation
                        (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                            [
                                ico-flat 
                                (ref-TFT::UDC_MultiTransferCumulator 
                                    input-ids-for-transfer account SWP|SC_NAME input-amounts-for-transfer
                                )
                                (ref-IGNIS::UDC_SmallCumulator SWP|SC_NAME)
                            ] 
                            []
                        )
                        ;;
                        input-ids-for-transfer
                        input-amounts-for-transfer
                        true
                        [BAR]
                        [0.0]
                        ;;
                        pt-amounts-with-balanced
                        pt-amounts-with-asymmetric
                    )
                )
            )
        )
    )
    (defun URC_TokenPrecision (id:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
            )
            (ref-DPTF::UR_Decimals id)
        )
    )
    (defun URC_IgnisPrecision ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
            )
            (URC_TokenPrecision (ref-DALOS::UR_IgnisID))
        )
    )
    ;;
    (defun URC_LD:object{SwapperLiquidityV2.LiquidityData} (swpair:string input-amounts:[decimal])
        @doc "Computes the LP amounts, valid for all 3 pool types, outputing a TripleLP object containing: \
        \ 1st Value: A Liquidity Split Object, containing the Liquidity Split \
        \ 2nd Value: The Type of Liquidity existing in the input \
        \ 3rd Value: LP for the Balanced Part \
        \ 4th Value: Full LP for the asymmetric Part \
        \ 5th Value: LP Amount as Liquidity Fee for the asymmetric Part"
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-SWP:module{SwapperV6} SWP)
                ;;
                (sorted-lq:object{SwapperLiquidityV2.LiquiditySplit} (URC_SortLiquidity swpair input-amounts))
                (sorted-lq-type:object{SwapperLiquidityV2.LiquiditySplitType} (UC_DetermineLiquidity sorted-lq))
                (balanced-lq:[decimal] (at "balanced" sorted-lq))
                (asymmetric-lq:[decimal] (at "asymmetric" sorted-lq))
                (iz-balanced:bool (at "iz-balanced" sorted-lq-type))
                (iz-asymmetric:bool (at "iz-asymmetric" sorted-lq-type))
                ;;
                (current-lp-supply:decimal (ref-SWP::URC_LpCapacity swpair))
                (lp-supply:decimal
                    (if (= current-lp-supply 0.0)
                        10000000.0
                        current-lp-supply
                    )
                )
                (pool-token-supplies:[decimal]
                    (if (= current-lp-supply 0.0)
                        (ref-SWP::UR_PoolGenesisSupplies swpair)
                        (ref-SWP::UR_PoolTokenSupplies swpair)
                    )
                )
                (lcd:object{SwapperLiquidityV2.LiquidityComputationData}
                    (UDC_LiquidityComputationData
                        (length input-amounts)
                        (ref-U|SWP::UC_PoolType swpair)
                        (ref-DPTF::UR_Decimals (ref-SWP::UR_TokenLP swpair))
                        current-lp-supply
                        lp-supply
                        pool-token-supplies
                    )
                )
                ;;Balanced Liq Computation
                (x:decimal 
                    (if iz-balanced
                        (URCX_BalancedLP lcd balanced-lq)
                        0.0
                    )
                )
                ;;asymmetric Liq Computation
                (y-with-z:[decimal]
                    (if iz-asymmetric
                        (let
                            (
                                (asymmetric-lp:[decimal] (URCX_AsymmetricLP swpair asymmetric-lq lcd))
                                (full-lp:decimal (at 0 asymmetric-lp))
                                (taxd-lp:decimal (at 1 asymmetric-lp))
                            )
                            [full-lp (- full-lp taxd-lp)]
                        )
                        [0.0 0.0]
                    )
                )
            )
            (UDC_LiquidityData
                sorted-lq
                sorted-lq-type
                x
                (at 0 y-with-z)
                (at 1 y-with-z)
            )
        )
    )
    (defun URCX_BalancedLP:decimal (lcd:object{SwapperLiquidityV2.LiquidityComputationData} balanced-lq:[decimal])
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
            )
            (ref-U|SWP::UC_LP 
                balanced-lq 
                (at "pool-token-supplies" lcd)
                (at "lp-supply" lcd)
                (at "lp-prec" lcd)
            )
        )
    )
    (defun URCX_AsymmetricLP:[decimal] (swpair:string asymmetric-lq:[decimal] lcd:object{SwapperLiquidityV2.LiquidityComputationData})
        @doc "Computes the Full LP (at 0) and Reduced LP (at 1) from Liquidity Fee for asymmetric-liquidity"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|VST:module{UtilityVstV2} U|VST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-SWP:module{SwapperV6} SWP)
                ;;
                (li:integer (at "li" lcd))
                (pool-type:string (at "pool-type" lcd))
                (lp-prec:integer (at "lp-prec" lcd))
                (current-lp-supply:decimal (at "current-lp-supply" lcd))
                (lp-supply:decimal (at "lp-supply" lcd))
                (pool-token-supplies:[decimal] (at "pool-token-supplies" lcd))
                ;;
                ;;Compute Full LP for asymmetric Liq
                (percent-lst:[decimal]
                    (if (= pool-type "W")
                        (if (= current-lp-supply 0.0)
                            (ref-SWP::UR_GenesisWeigths swpair)
                            (ref-SWP::UR_Weigths swpair)
                        )
                        (ref-U|VST::UC_SplitBalanceForVesting 24 1.0 li)
                    )
                )
                (lp-amounts:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (ref-U|LST::UC_AppL 
                                acc 
                                (floor 
                                    (fold (*) 1.0 [(/ (at idx asymmetric-lq) (at idx pool-token-supplies)) (at idx percent-lst) lp-supply]) 
                                    lp-prec
                                )
                            )
                        )
                        []
                        (enumerate 0 (- li 1))
                    )
                )
                (full-asymmetric-lp:decimal (fold (+) 0.0 lp-amounts))
                ;;Compute Taxed LP for asymmetric Liq
                (liquidity-fee:decimal (/ (ref-SWP::URC_LiquidityFee swpair) 1000.0))
                (amp:decimal (ref-SWP::UR_Amplifier swpair))
                (new-balances:[decimal] (zip (+) pool-token-supplies asymmetric-lq))
                (d0:decimal
                    (if (= pool-type "S")
                        (ref-U|SWP::UC_ComputeD amp pool-token-supplies)
                        5040000.0
                    )
                )
                (d1:decimal
                    (if (= pool-type "S")
                        (ref-U|SWP::UC_ComputeD amp new-balances)
                        (+ 5040000.0 (URCXX_D1forWP swpair pool-token-supplies asymmetric-lq))
                    )
                )
                (dr:decimal (floor (/ d0 d1) 24))
                (Xp:[integer] (ref-SWP::UR_PoolTokenPrecisions swpair))
                (adjusted-balances:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (ref-U|LST::UC_AppL
                                acc
                                (- 
                                    (at idx new-balances) 
                                    (floor 
                                        (* 
                                            (abs 
                                                (- 
                                                    (at idx new-balances) 
                                                    (floor 
                                                        (* 
                                                            (at idx pool-token-supplies)
                                                            dr
                                                        ) 
                                                        (at idx Xp)
                                                    )
                                                )
                                            )
                                            liquidity-fee
                                        )
                                        (at idx Xp)
                                    )
                                )
                            )
                        )
                        []
                        (enumerate 0 (- li 1))
                    )
                )
                (taxed-asymmetric-lp:decimal
                    (floor 
                        (/ 
                            (* 
                                (-
                                    (if (= pool-type "S")
                                        (ref-U|SWP::UC_ComputeD amp adjusted-balances) 
                                        (URCXX_D1forWP swpair pool-token-supplies adjusted-balances)
                                    )
                                    d0
                                ) 
                                lp-supply
                            ) 
                            d0
                        ) 
                        lp-prec
                    )
                )
            )
            [full-asymmetric-lp taxed-asymmetric-lp]
        )
    )
    (defun URCXX_D1forWP:decimal (swpair:string current:[decimal] input:[decimal])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWP:module{SwapperV6} SWP)
                (pool-type:string (ref-U|SWP::UC_PoolType swpair))
                (how-many:decimal (dec (length current)))
                (weigths:[decimal] (ref-SWP::UR_Weigths swpair))
                (vpt:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (ref-U|LST::UC_AppL 
                                acc 
                                (floor 
                                    (/ 
                                        (if (= pool-type "P")
                                            (/ 5040000.0 how-many)
                                            (* 5040000.0 (at idx weigths))
                                        )
                                        (at idx current)
                                    ) 
                                    24
                                )
                            )
                        )
                        []
                        (enumerate 0 (- (length current) 1))
                    )
                )
                (input-values:[decimal] (zip (lambda (x:decimal y:decimal) (* x y)) input vpt))
            )
            (fold (+) 0.0 input-values)
        )
    )
    (defun URC_AsymmetricTax:object{SwapperLiquidityV2.AsymmetricTax}
        (account:string swpair:string ld:object{SwapperLiquidityV2.LiquidityData})
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-SWP:module{SwapperV6} SWP)
                (ref-SWPI:module{SwapperIssueV4} SWPI)
                ;;
                ;;Unwrap Object Data
                (iz-balanced:bool (at "iz-balanced" (at "sorted-lq-type" ld)))
                (iz-asymmetric:bool (at "iz-asymmetric" (at "sorted-lq-type" ld)))
            )
            (if (and iz-balanced (not iz-asymmetric))
                (UDC_AsymmetricTax 0.0 0.0 0.0 0.0 0.0 0.0)
                (let
                    (
                        (balanced-liquidity:[decimal] (at "balanced" (at "sorted-lq" ld)))
                        (asymmetric-liquidity:[decimal] (at "asymmetric" (at "sorted-lq" ld)))
                        (total-input-liqudity:[decimal] 
                            (zip (+) balanced-liquidity asymmetric-liquidity)
                        )
                        (balanced-lp-amount:decimal (at "balanced" ld))
                        (asymmetric-lp-amount:decimal (at "asymmetric" ld))
                        (asymmetric-lp-fee-amount:decimal (at "asymmetric-fee" ld))
                        (lp-amount:decimal (+ balanced-lp-amount asymmetric-lp-amount))
                        ;;
                        ;;
                        ;;Get Data to Construct the Virtual Swapper and the Values to compute ABA
                        (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                        (first-pt:string (at 0 pool-tokens))
                        (pool-token-supplies:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                        (lp-supply:decimal (ref-SWP::URC_LpCapacity swpair))
                        ;;
                        (w:[decimal] (ref-SWP::UR_Weigths swpair))
                        (lp-prec:integer (ref-DPTF::UR_Decimals (ref-SWP::UR_TokenLP swpair)))
                        ;;
                        ;;The Asymetric Break Amounts <aba>
                        ;;<aba> is the Output Liquidity one would get by removing LP made with asymmetric Liquidity
                        ;;These are hypothetical values one would get, if all input Liqudity were to be added into the Pool
                        ;;While minting all the LP generated by it via raw mathematical computation.
                        ;;Against these hypothetical Values the Token A Deficit is calculated, which is the base for the Asymetric Taxes.
                        (pool-token-supplies-for-aba:[decimal]
                            ;; on Pool that has a liqudity equal to <pool-liq> + <input-balanced-lq> + <input-asymmetric-lq>
                            (zip (+) pool-token-supplies total-input-liqudity)
                        )
                        (lp-supply-for-aba:decimal
                            ;; and an LP amount equal to <lp-supply> + <balanced-lp-amount> + <asymmetric-lp-amount>
                            (+ lp-supply lp-amount)
                            ;;<aba> is the base for computing the AsymmetricTax
                        )
                        (aba:[decimal]
                            (URC_CustomLpBreakAmounts swpair pool-token-supplies-for-aba lp-supply-for-aba asymmetric-lp-amount)
                        )
                        ;;
                        ;;
                        ;;Constructing the Pool Supplies of the Virtual Swapper, and the Virtual Account Starting Liquidity
                        (virtual-pool-token-supplies:[decimal] 
                            ;;<virtual-pool-token-supplies> = <pool-token-supplies> + <balanced-liquidity> when it exists
                            (if iz-balanced
                                (zip (+) pool-token-supplies balanced-liquidity)
                                pool-token-supplies
                            )
                        )
                        (virtual-lp-supply:decimal
                            ;; Used to compute Fuel Shares as LP
                            (if iz-balanced
                                (+ lp-supply balanced-lp-amount)
                                lp-supply
                            )
                        )
                        (first-bonus-amount:decimal (at 0 aba))
                        (fba-filled:[decimal] (ref-SWPI::URC_IndirectRefillAmounts pool-token-supplies [0] [first-bonus-amount]))
                        (account-starting-liq:[decimal]
                            ;;The Liquidity the Virtual Account starts with on the Virtual Swap Engine
                            ;;Equal to the Asymetric Liqudity minus the A amount from ABA
                            (zip (-) asymmetric-liquidity fba-filled)
                        )
                        (vse:object{UtilitySwpV2.VirtualSwapEngine}
                            (UDC_VirtualSwapEngineSwpair 
                                account account-starting-liq
                                swpair virtual-pool-token-supplies
                            )
                        )
                        (a-prec:integer 
                            (at 0 (at "v-prec" vse))
                            ;;Preparing Step 1 of the Virtual Swaps
                            ;;STEP 1.
                            ;;All no-A Tokens on the Virtual Account are swapped in the Virtual Pool to Token A.
                            ;;      This consumes all non token-A in the Virtual Account of the Swap Engine
                            ;;STEP 2.
                            ;;For each non-A Token the Value of Token A is computed with Reverse Swap (with fees) Math,
                            ;;      that would results in its coresponding value in <aba>
                            ;;      the computed A Amount is then forward swapped in the Virtual Swap Engine
                            ;;      this is done sequentially for each positive value of non-A Tokens present in <aba>
                            ;;After the Virtual Swaps are done, 
                            ;;  1)A deficit of Token A would result.
                            ;;      This deficit represents how much more Token A you would have needed to get the <aba> values of non-A Tokens,
                            ;;          if you were to execute natural Swaps in the pool using Token A as input for these Swaps.
                            ;;      Naturally, the amount of Token A present in the <asymmetric-liquidity> counts against the deficit (since you already have it)
                            ;;      And the amount of Token A in the <aba> counts towards the deficit (since you would have gotten it by breaking the <asymmetric-lp-amount>)
                            ;;          Which is why the Token A in the <aba> needs to be subtracted from the Starting Asymmetric Liquidity 
                            ;;          the Virtual Account starts with in the Virtual Swap Engine
                            ;;  2)Various Fees saved by the VSE (Virtual Swap Engine) related to existing POOL Fees
                            ;;      These are the basis for the computed Taxes.
                        )
                        (df-pool-tokens:[string] (drop 1 pool-tokens))
                        (df-asymmetric-liquidity:[decimal] (drop 1 asymmetric-liquidity))
                        (df-asymmetric-liquidity-no-zeroes:[decimal] (ref-U|LST::UC_RemoveItem df-asymmetric-liquidity 0.0))
                        (df-pool-tokens-no-zeroes:[string]
                            (fold
                                (lambda
                                    (acc:[string] idx:integer)
                                    (if (!= (at idx df-asymmetric-liquidity) 0.0)
                                        (ref-U|LST::UC_AppL
                                            acc
                                            (at idx df-pool-tokens)
                                        )
                                        acc
                                    )
                                )
                                []
                                (enumerate 0 (- (length df-pool-tokens) 1))
                            )
                        )
                        (l1:integer (length df-asymmetric-liquidity-no-zeroes))
                        (swap-no1-data:object{UtilitySwpV2.DirectSwapInputData}
                            (ref-U|SWP::UDC_DirectSwapInputData
                                df-pool-tokens-no-zeroes
                                df-asymmetric-liquidity-no-zeroes
                                (at 0 pool-tokens)
                            )
                        )
                        ;;
                        ;;First Virtual Swap
                        (vse1:object{UtilitySwpV2.VirtualSwapEngine}
                            (if (!= l1 0)
                                (ref-SWPI::UC_VirtualSwap vse swap-no1-data)
                                vse
                            )
                        )
                        (vse2:object{UtilitySwpV2.VirtualSwapEngine}
                            (UCX_Step2AsymmetricTaxVirtualSwapper 
                                vse1 first-pt df-pool-tokens (drop 1 aba)
                            )
                        )
                        ;;Get Needed Virtual Swap Values
                        (token-a-deficit:decimal (abs (at 0 (at "account-supply" vse2))))
                        
                        (fuel:[decimal] (at "fuel" vse2))
                        (special:[decimal] (at "special" vse2))
                        (boost:[decimal] (at "boost" vse2))
                        ;;
                        ;;Get Share Values on <virtual-pool-token-supplies>
                        (shares:[decimal] (ref-SWPI::UC_PoolShares virtual-pool-token-supplies w))
                        (a-share:decimal (at 0 shares))
                        (tad-shares:decimal (floor (* token-a-deficit a-share) 24))

                        (fuel-shares:decimal (floor (fold (+) 0.0 (zip (*) fuel shares)) 24))
                        (special-shares:decimal (floor (fold (+) 0.0 (zip (*) special shares)) 24))
                        (boost-shares:decimal (floor (fold (+) 0.0 (zip (*) boost shares)) 24))
                        (fee-shares:decimal (fold (+) 0.0 [fuel-shares special-shares boost-shares]))
                        (diff-shares:decimal (- tad-shares fee-shares))
                        ;;
                        (fuel-as-a:decimal (floor (/ fuel-shares a-share) a-prec))
                        (special-as-a:decimal (floor (/ special-shares a-share) a-prec))
                        (boost-as-a:decimal (floor (/ boost-shares a-share) a-prec))
                        (tad-diff:decimal (- token-a-deficit (fold (+) 0.0 [fuel-as-a special-as-a boost-as-a])))
                        ;;
                        ;;Get Fuel Shares as LP
                        (fuel-to-lp:decimal (floor (/ (* virtual-lp-supply fuel-shares) 5040000.0) lp-prec))
                    )
                    (UDC_AsymmetricTax
                        token-a-deficit
                        tad-diff
                        fuel-as-a
                        special-as-a
                        boost-as-a
                        fuel-to-lp
                    )
                )
            )
        )
    )
    (defun UCX_Step2AsymmetricTaxVirtualSwapper:object{UtilitySwpV2.VirtualSwapEngine}
        (vse:object{UtilitySwpV2.VirtualSwapEngine} first-token-id:string liq-ids:[string] liq-amounts:[decimal])
        (let
            (
                (l1:integer (length liq-ids))
                (l2:integer (length liq-amounts))
            )
            (if (and (= l1 l2) (= l1 0))
                vse
                (let
                    (
                        (ref-U|LST:module{StringProcessor} U|LST)
                        (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                        (ref-SWPI:module{SwapperIssueV4} SWPI)
                        ;;
                        ;;Unwrap VSE Object Data for fixed Variables
                        (account:string (at "account" vse))
                        (pool-type:string (ref-U|SWP::UC_PoolType (at "swpair" vse)))
                        (fees:object{UtilitySwpV2.SwapFeez} (at "F" vse))
                        (A:decimal (at "A" vse))
                        (X-prec:[integer] (at "v-prec" vse))
                        (v-tokens:[string] (at "v-tokens" vse))
                        (W:[decimal] (at "W" vse))
                        ;;
                        (vse-single-chain:[object{UtilitySwpV2.VirtualSwapEngine}]
                            (fold
                                (lambda
                                    (acc:[object{UtilitySwpV2.VirtualSwapEngine}] idx:integer)
                                    (let
                                        (
                                            (prev-vse:object{UtilitySwpV2.VirtualSwapEngine} (at 0 acc))
                                            (id:string (at idx liq-ids))
                                            (amount:decimal (at idx liq-amounts))
                                            ;;
                                            ;;Unwrap VSE Object Data for mutable Variables
                                            (X:[decimal] (at "X" prev-vse))
                                            (output-position:integer (at 0 (ref-U|LST::UC_Search v-tokens id)))
                                            ;;
                                            (rsid:object{UtilitySwpV2.ReverseSwapInputData}
                                                (ref-U|SWP::UDC_ReverseSwapInputData
                                                    id amount first-token-id
                                                )
                                            )
                                            (itso:object{UtilitySwpV2.InverseTaxedSwapOutput}
                                                (ref-SWPI::UC_InverseBareboneSwapWithFeez
                                                    account pool-type rsid fees A X X-prec output-position 0 W
                                                )
                                            )
                                            (input-amount:decimal (at "i-id-brutto" itso))
                                            ;;
                                            (dsid:object{UtilitySwpV2.DirectSwapInputData}
                                                (ref-U|SWP::UDC_DirectSwapInputData
                                                    [first-token-id]
                                                    [input-amount]
                                                    id
                                                )
                                            )
                                            (new-vse:object{UtilitySwpV2.VirtualSwapEngine}
                                                (ref-SWPI::UC_VirtualSwap prev-vse dsid)
                                            )
                                        )
                                        (ref-U|LST::UC_ReplaceAt acc 0 new-vse)
                                    )
                                )
                                [vse]
                                (enumerate 0 (- l1 1))
                            )
                        )
                    )
                    (at 0 vse-single-chain)
                )
            )
        )
    )
    (defun URC_SortLiquidity:object{SwapperLiquidityV2.LiquiditySplit} (swpair:string input-amounts:[decimal])
        @doc "Sorts Liquidity into a balanced part and an asymmetric part"
        (let
            (
                (iz-balanced:bool (URC_AreAmountsBalanced swpair input-amounts))
            )
            (if iz-balanced
                (UDC_LiquiditySplit
                    input-amounts
                    (make-list (length input-amounts) 0.0)
                )
                (let
                    (
                        (has-zeroes:bool (contains 0.0 input-amounts))
                    )
                    (if has-zeroes
                        (UDC_LiquiditySplit
                            (make-list (length input-amounts) 0.0)
                            input-amounts
                        )
                        (let
                            (
                                (ref-SWP:module{SwapperV6} SWP)
                                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                                (balanced-chain:[decimal]
                                    (fold
                                        (lambda
                                            (acc:[decimal] idx:integer)
                                            (let
                                                (
        
                                                    (input-id:string (at idx pool-tokens))
                                                    (input-amount:decimal (at idx input-amounts))
                                                    (balanced-lq:[decimal] (URC_BalancedLiquidity swpair input-id input-amount false))
                                                    (iz-it-fitting:bool
                                                        (fold
                                                            (lambda
                                                                (acc:bool idxx:integer)
                                                                (let
                                                                    (
                                                                        (element:decimal (at idxx balanced-lq))
                                                                        (iz-smaller:bool (<= element (at idxx input-amounts)))
                                                                    )
                                                                    (and acc iz-smaller)
                                                                )
                                                            )
                                                            true
                                                            (enumerate 0 (- (length balanced-lq) 1))
                                                        )
                                                    )
                                                )
                                                (if iz-it-fitting
                                                    balanced-lq
                                                    acc
                                                )
                                            )
                                        )
                                        []
                                        (enumerate 0 (- (length input-amounts) 1))
                                    )
                                )
                            )
                            (UDC_LiquiditySplit
                                balanced-chain
                                (zip (-) input-amounts balanced-chain)
                            )
                        )
                    )
                )
            )
        )
    )
    ;;
    (defun URC_AreAmountsBalanced:bool (swpair:string input-amounts:[decimal])
        @doc "Determines if <input-amounts> are balanced according to <swpair>"
        (let
            (
                (sum:decimal (fold (+) 0.0 input-amounts))
            )
            (enforce (> sum 0.0) "At least a single input value must be greater than zero!")
            (let
                (
                    (has-zeroes:bool (contains 0.0 input-amounts))
                )
                (if has-zeroes
                    false
                    (let
                        (
                            (ref-U|LST:module{StringProcessor} U|LST)
                            (ref-SWPI:module{SwapperIssueV4} SWPI)
                            (positive-amounts:[decimal] (ref-U|LST::UC_RemoveItem input-amounts 0.0))
                            (positive-ids:[string] (ref-SWPI::URC_TrimIdsWithZeroAmounts swpair input-amounts))
                        )
                        (fold
                            (lambda
                                (acc:bool idx:integer)
                                (let
                                    (
                                        (amount:decimal (at idx positive-amounts))
                                        (id:string (at idx positive-ids))
                                        (computed-balance:[decimal] (URC_BalancedLiquidity swpair id amount false))
                                        (checks:bool (= input-amounts computed-balance))
                                    )
                                    (or acc checks)
                                )
                            )
                            false
                            (enumerate 0 (- (length positive-amounts) 1))

                        )
                    )
                )
            )
        )
    )
    (defun URC_BalancedLiquidity:[decimal] (swpair:string input-id:string input-amount:decimal with-validation:bool)
        @doc "Computes the amounts of Balanced Liquidity from one <input-id> with an <input-amount> on a given <swpair> \
        \ <with-validation> specifies if additional validation should also be executed to validate the inputs."
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-SWP:module{SwapperV6} SWP)
                ;;
                (input-position:integer (ref-SWP::UR_PoolTokenPosition swpair input-id))
                (input-precision:integer (ref-DPTF::UR_Decimals input-id))
                (X:[decimal]
                    (if (= (ref-SWP::URC_LpCapacity swpair) 0.0)
                        (ref-SWP::UR_PoolGenesisSupplies swpair)
                        (ref-SWP::UR_PoolTokenSupplies swpair)
                    )
                )
                (Xp:[integer] (ref-SWP::UR_PoolTokenPrecisions swpair))
            )
            (if with-validation
                (UEV_BalancedLiquidity swpair input-id input-amount)
                true
            )
            (ref-U|SWP::UC_BalancedLiquidity input-amount input-position input-precision X Xp)
        )
    )
    (defun URC_LpBreakAmounts:[decimal] (swpair:string input-lp-amount:decimal)
        (let
            (
                (ref-SWP:module{SwapperV6} SWP)
                (pool-token-supplies:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (lp-supply:decimal (ref-SWP::URC_LpCapacity swpair))
            )
            (URC_CustomLpBreakAmounts swpair pool-token-supplies lp-supply input-lp-amount)
        )
    )
    (defun URC_CustomLpBreakAmounts:[decimal]
        (swpair:string swpair-pool-token-supplies:[decimal] swpair-lp-supply:decimal input-lp-amount:decimal)
        @doc "Computes the Pool Token Amounts that result from removing <input-lp-amount> of LP Token \
        \ Using Custom values for PoolTokenSupplies and PoolLPSupply"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-SWP:module{SwapperV6} SWP)
                (ratio:decimal (floor (/ input-lp-amount swpair-lp-supply) 24))
                (pool-token-precisions:[integer] (ref-SWP::UR_PoolTokenPrecisions swpair))
                (l1:integer (length swpair-pool-token-supplies))
                (l2:integer (length pool-token-precisions))
            )
            ;;Validation of inputs
            (enforce 
                (and
                    (<= input-lp-amount swpair-lp-supply)
                    (= l1 l2)
                )
                "Invalid Input Data for Break LP Computation"
            )
            (if (= input-lp-amount swpair-lp-supply)
                swpair-pool-token-supplies
                (fold
                    (lambda
                        (acc:[decimal] idx:integer)
                        (ref-U|LST::UC_AppL
                            acc
                            (floor (* ratio (at idx swpair-pool-token-supplies)) (at idx pool-token-precisions))
                        )
                    )
                    []
                    (enumerate 0 (- (length swpair-pool-token-supplies) 1))
                )
            )
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_Liquidity:[decimal]
        (swpair:string ld:object{SwapperLiquidityV2.LiquidityData})
            @doc "Validates the asymmetric Liquidity amount, if it exists within the LD Object. \
            \ Validation means that it doesent produce a Share Deviation \
            \ greater than 40% of the Maximum Pool Deviation \
            \ Maximum Pool Deviation is given by its token Size \
            \ and is given by the formula (n-1)/n \
            \ The Deviation is computed on existing <swpair> liquidity, plus \
            \ any balanced-liq, should it exist within the <ld> \
            \ Outputs the Share deviation <ld> would produce on the <swpair> \
            \ If no asymmetric liq exists within the LD, then outputs zero, as no Deviation would occur"
        (let
            (
                (ref-SWP:module{SwapperV6} SWP)
                ;;
                ;;Unwrap Object Data
                (balanced-liquidity:[decimal] (at "balanced" (at "sorted-lq" ld)))
                (asymmetric-liquidity:[decimal] (at "asymmetric" (at "sorted-lq" ld)))
                (iz-balanced:bool (at "iz-balanced" (at "sorted-lq-type" ld)))
                (iz-asymmetric:bool (at "iz-asymmetric" (at "sorted-lq-type" ld)))
                ;;
                ;;Get Data to Construct the Virtual Swapper
                (pool-token-supplies:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (lp-supply:decimal (ref-SWP::URC_LpCapacity swpair))
                (virtual-pool-token-supplies:[decimal] 
                    (if iz-balanced
                        (zip (+) pool-token-supplies balanced-liquidity)
                        pool-token-supplies
                    )
                )
            )
            (if (not iz-asymmetric)
                [0.0 0.0]
                (let
                    (
                        (ref-SWPI:module{SwapperIssueV4} SWPI)
                        ;;
                        (w:[decimal] (ref-SWP::UR_Weigths swpair))
                        (n:decimal (dec (length w)))
                        (max-dev:decimal (floor (* 0.4 (/ (- n 1.0) n)) 24))
                        (dev:decimal (ref-SWPI::UC_DeviationInValueShares virtual-pool-token-supplies asymmetric-liquidity w))
                    )
                    (enforce (<= dev max-dev) (format "asymmetric Liqudity incurrs {} deviation, which is greater than the maximum allowed deviation of {}" [dev max-dev]))
                    [dev max-dev]
                )
            )
        )
    )
    (defun UEV_BalancedLiquidity (swpair:string input-id:string input-amount:decimal)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-SWP:module{SwapperV6} SWP)
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (iz-on-pool:bool (contains input-id pool-tokens))
            )
            (enforce iz-on-pool (format "Token {} is not part of SWPair {}" [input-id swpair]))
            (ref-DPTF::UEV_Amount input-id input-amount)
        )
    )
    
    ;;{F3}  [UDC]
    (defun UDC_VirtualSwapEngineSwpair:object{UtilitySwpV2.VirtualSwapEngine}
        (account:string account-liq:[decimal] swpair:string pool-liq:[decimal])
        (let
            (
                (ref-SWP:module{SwapperV6} SWP)
                (A:decimal (ref-SWP::UR_Amplifier swpair))
                (W:[decimal] (ref-SWP::UR_Weigths swpair))
            )
            (UDC_VirtualSwapEngine
                account account-liq swpair pool-liq
                A W (UDC_PoolFees swpair)
            )
        )
    )
    (defun UDC_VirtualSwapEngine:object{UtilitySwpV2.VirtualSwapEngine}
        (
            account:string account-liq:[decimal] swpair:string starting-liq:[decimal]
            A:decimal W:[decimal] F:object{UtilitySwpV2.SwapFeez}
        )
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWP:module{SwapperV6} SWP)
                (pool-tokens:[string] (ref-U|SWP::UC_TokensFromSwpairString swpair))
                (zero-lst:[decimal] (make-list (length pool-tokens) 0.0))
            )
            (ref-U|SWP::UDC_VirtualSwapEngine
                pool-tokens
                (ref-SWP::UC_PoolTokenPrecisions swpair)
                account account-liq swpair starting-liq
                A W F
                zero-lst zero-lst zero-lst []
            )
        )
    )
    (defun UDC_PoolFees:object{UtilitySwpV2.SwapFeez} (swpair:string)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWP:module{SwapperV6} SWP)
                (lb:bool (ref-SWP::UR_LiquidBoost))
                (lp-fee:decimal (ref-SWP::UR_FeeLP swpair))
                (special-fee:decimal (ref-SWP::UR_FeeSP swpair))
                (boost-fee:decimal (if lb lp-fee 0.0))
            )
            (ref-U|SWP::UDC_SwapFeez lp-fee special-fee boost-fee)
        )
    )
    (defun UDC_OutputLP:object{SwapperLiquidityV2.OutputLP} (a:decimal b:decimal)
        {"primary"                  : a
        ,"secondary"                : b}
    )
    (defun UDC_LiquiditySplit:object{SwapperLiquidityV2.LiquiditySplit} (a:[decimal] b:[decimal])
        {"balanced"                 : a
        ,"asymmetric"               : b}
    )
    (defun UDC_LiquiditySplitType:object{SwapperLiquidityV2.LiquiditySplitType} (a:bool b:bool)
        {"iz-balanced"              : a
        ,"iz-asymmetric"            : b}
    )
    (defun UDC_LiquidityData:object{SwapperLiquidityV2.LiquidityData}
        (a:object{SwapperLiquidityV2.LiquiditySplit} b:object{SwapperLiquidityV2.LiquiditySplitType} c:decimal d:decimal e:decimal)
        {"sorted-lq"                : a
        ,"sorted-lq-type"           : b
        ,"balanced"                 : c
        ,"asymmetric"               : d
        ,"asymmetric-fee"           : e}
    )
    (defun UDC_LiquidityComputationData:object{SwapperLiquidityV2.LiquidityComputationData}
        (a:integer b:string c:integer d:decimal e:decimal f:[decimal])
        {"li"                       : a
        ,"pool-type"                : b
        ,"lp-prec"                  : c
        ,"current-lp-supply"        : d
        ,"lp-supply"                : e
        ,"pool-token-supplies"      : f}
    )
    (defun UDC_AsymmetricTax:object{SwapperLiquidityV2.AsymmetricTax}
        (a:decimal b:decimal c:decimal d:decimal e:decimal f:decimal)
        {"tad"                      : a
        ,"tad-diff"                 : b
        ,"fuel"                     : c
        ,"special"                  : d
        ,"boost"                    : e
        ,"fuel-to-lp"               : f}
    )
    (defun UDC_CompleteLiquidityAdditionData:object{SwapperLiquidityV2.CompleteLiquidityAdditionData}
        (
            a:[decimal] b:[decimal] c:[decimal] d:[decimal]
            e:decimal f:decimal
            g:decimal
            h:decimal i:decimal j:decimal k:decimal l:decimal
            m:string n:string o:string p:string q:string
            r:object{SwapperLiquidityV2.CladOperation}
        )
        {"total-input-liquidity"    : a
        ,"balanced-liquidity"       : b
        ,"asymmetric-liquidity"     : c
        ,"asymmetric-deviation"     : d
        ;;
        ,"primary-lp"               : e
        ,"secondary-lp"             : f
        ;;
        ,"total-ignis-tax-needed"   : g
        ;;
        ,"gaseous-ignis-fee"        : h
        ,"deficit-ignis-tax"        : i
        ,"special-ignis-tax"        : j
        ,"lqboost-ignis-tax"        : k
        ,"relinquish-lp"            : l
        ;;
        ,"gaseous-text"             : m
        ,"deficit-text"             : n
        ,"special-text"             : o
        ,"lqboost-text"             : p
        ,"fueling-text"             : q
        ;;
        ,"clad-op"                  : r}
    )
    (defun UDC_CladOperation:object{SwapperLiquidityV2.CladOperation}
        (a:object{IgnisCollectorV2.OutputCumulator} b:[string] c:[decimal] d:bool e:[string] f:[decimal] g:[decimal] h:[decimal])
        {"perfect-ignis-fee"        : a
        ;;
        ,"mt-ids"                   : b
        ,"mt-amt"                   : c
        ,"lp-mint"                  : d
        ,"bk-ids"                   : e
        ,"bk-amt"                   : f
        ;;
        ,"ppb"                      : g
        ,"ppa"                      : h}
    )
    (defun UDC_PoolState:object{SwapperLiquidityV2.PoolState}
        (a:decimal b:object{UtilitySwpV2.SwapFeez} c:[decimal] d:[decimal] e:decimal f:[string] g:[decimal])
        {"A"    : a
        ,"F"    : b
        ,"X"    : c
        ,"W"    : d
        ;;
        ,"LP"   : e
        ,"FT"   : f
        ,"FTP"  : g}
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
    (defun XE|KDA-PID_AddLiqudity
        (
            account:string swpair:string asymmetric-collection:bool gaseous-collection:bool kda-pid:decimal
            ld:object{SwapperLiquidityV2.LiquidityData} clad:object{SwapperLiquidityV2.CompleteLiquidityAdditionData}
        )
        (UEV_IMC)
        (let
            (
                (ref-SWP:module{SwapperV6} SWP)
                ;;
                (balanced-liquidity:[decimal] (at "balanced" (at "sorted-lq" ld)))
                (asymmetric-liquidity:[decimal] (at "asymmetric" (at "sorted-lq" ld)))
                (iz-balanced:bool (at "iz-balanced" (at "sorted-lq-type" ld)))
                (iz-asymmetric:bool (at "iz-asymmetric" (at "sorted-lq-type" ld)))
                (pt-amounts-with-asymmetric:[decimal] (at "ppa" (at "clad-op" clad)))
                ;;
                (lp-id:string (ref-SWP::UR_TokenLP swpair))
                (gw:[decimal] (ref-SWP::UR_GenesisWeigths swpair))
                (read-lp-supply:decimal (ref-SWP::URC_LpCapacity swpair))
                (primary-lp-amount:decimal (at "primary-lp" clad))
                (secondary-lp-amount:decimal (at "secondary-lp" clad))
                (lp-mint:bool (at "lp-mint" (at "clad-op" clad)))
                (lp-to-mint:decimal (if lp-mint primary-lp-amount (+ primary-lp-amount secondary-lp-amount)))
            )
            (if iz-asymmetric
                (do
                    (if iz-balanced
                        (with-capability (SWPL|S>ADD_BALANCED-LQ account swpair balanced-liquidity)
                            (with-capability (SWPL|S>ADD_ASYMMETRIC-LQ account swpair asymmetric-liquidity)
                                (ref-SWP::XE_UpdateSupplies swpair pt-amounts-with-asymmetric)
                                (if (= read-lp-supply 0.0)
                                    (ref-SWP::XB_ModifyWeights swpair gw)
                                    true
                                )
                            )
                        )
                        (with-capability (SWPL|S>ADD_ASYMMETRIC-LQ account swpair asymmetric-liquidity)
                            (ref-SWP::XE_UpdateSupplies swpair pt-amounts-with-asymmetric)
                        )
                    )
                    (with-capability (SWPL|S>ASYMMETRIC-LQ-GASEOUS-TAX (at "gaseous-text" clad)) true)
                    (if asymmetric-collection
                        (let
                            (
                                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                                (ref-DALOS:module{OuronetDalosV6} DALOS)
                                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                                (ref-ORBR:module{OuroborosV5} OUROBOROS)
                                (ref-SWPI:module{SwapperIssueV4} SWPI)
                                ;;
                                (ignis-id:string (ref-DALOS::UR_IgnisID))
                                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                                (lkda-id:string (ref-DALOS::UR_LiquidKadenaID))
                                (primordial-swpair:string (ref-SWP::UR_PrimordialPool))
                                (lqboost-ignis-tax:decimal (at "lqboost-ignis-tax" clad))
                                (primordial-supplies:[decimal] (ref-SWP::UR_PoolTokenSupplies primordial-swpair))
                                ;;
                                ;;Computing the LQ Boost Tax
                                ;;
                                (ouro-mint-amount:decimal 
                                    (if (= lqboost-ignis-tax 0.0)
                                        0.0
                                        (at 0 (ref-ORBR::URC_Compress lqboost-ignis-tax))
                                    )
                                )    
                                (dsid:object{UtilitySwpV2.DirectSwapInputData}
                                    (ref-U|SWP::UDC_DirectSwapInputData
                                        [ouro-id]
                                        [ouro-mint-amount]
                                        lkda-id
                                    )
                                )
                                (lkda-burn-amount:decimal 
                                    (if (= lqboost-ignis-tax 0.0)
                                        0.0
                                        (ref-SWPI::URC_Swap primordial-swpair dsid false)
                                    )
                                )
                                (bk-ids:[string] (at "bk-ids" (at "clad-op" clad)))
                                (bk-amt:[decimal] (at "bk-amt" (at "clad-op" clad)))
                            )
                            (with-capability (SECURE) (XI_AddLiqSendAndMint account lp-id lp-to-mint clad))
                            ;;Handle Special Targets
                            (if (!= bk-ids [BAR])
                                (ref-TFT::C_MultiBulkTransfer
                                    [ignis-id]
                                    SWP|SC_NAME
                                    [bk-ids]
                                    [bk-amt]
                                )
                                true
                            )
                            ;;Handle Liquid Boost
                            (if (!= lqboost-ignis-tax 0.0)
                                (do
                                    (ref-DPTF::C_Burn ignis-id SWP|SC_NAME lqboost-ignis-tax)
                                    (ref-DPTF::C_Mint ouro-id SWP|SC_NAME ouro-mint-amount false)
                                    (ref-DPTF::C_Burn lkda-id SWP|SC_NAME lkda-burn-amount)
                                    (ref-SWP::XE_UpdateSupplies 
                                        primordial-swpair 
                                        (zip (+) primordial-supplies [(- 0.0 lkda-burn-amount) ouro-mint-amount 0.0])
                                    )
                                )
                                true
                            )
                            (with-capability (SWPL|S>ASYMMETRIC-LQ-DEFICIT-TAX (at "deficit-text" clad)) true)
                            (with-capability (SWPL|S>ASYMMETRIC-LQ-FUELING-TAX (at "fueling-text" clad)) true)
                            (with-capability (SWPL|S>ASYMMETRIC-LQ-SPECIAL-TAX (at "special-text" clad)) true)
                            (with-capability (SWPL|S>ASYMMETRIC-LQ-LQBOOST-TAX (at "lqboost-text" clad)) true)
                        )
                        (with-capability (SECURE) (XI_AddLiqSendAndMint account lp-id lp-to-mint clad))
                    )
                )
                (with-capability (SWPL|S>ADD_BALANCED-LQ account swpair balanced-liquidity)
                    (if (= read-lp-supply 0.0)
                        (ref-SWP::XB_ModifyWeights swpair gw)
                        true
                    )
                    (ref-SWP::XE_UpdateSupplies swpair (at "ppb" (at "clad-op" clad)))
                    (with-capability (SECURE) (XI_AddLiqSendAndMint account lp-id lp-to-mint clad))
                )
            )
        )
    )
    (defun XI_AddLiqSendAndMint 
        (
            account:string lp-id:string lp-amount:decimal 
            clad:object{SwapperLiquidityV2.CompleteLiquidityAdditionData}
        )
        (require-capability (SECURE))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
            )
            (ref-TFT::C_MultiTransfer
                (at "mt-ids" (at "clad-op" clad))
                account SWP|SC_NAME 
                (at "mt-amt" (at "clad-op" clad))
                true
            )
            (ref-DPTF::C_Mint lp-id SWP|SC_NAME lp-amount false)
        )
    )
    (defun XE_AutonomousSwapManagement (swpair:string)
        (UEV_IMC)
        (let
            (
                (ref-SWP:module{SwapperV6} SWP)
                (ref-SWPI:module{SwapperIssueV4} SWPI)
                (pool-worth:decimal (at 0 (ref-SWPI::URC_PoolValue swpair)))
                (inactive-limit:decimal (ref-SWP::UR_InactiveLimit))
            )
            (with-capability (P|SWPL|CALLER)
                (if (< pool-worth inactive-limit)
                    (ref-SWP::XE_CanAddOrSwapToggle swpair false false)
                    (ref-SWP::XE_CanAddOrSwapToggle swpair true false)
                )
            )
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)