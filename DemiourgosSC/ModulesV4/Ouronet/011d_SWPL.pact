(interface SwapperLiquidity
    @doc "Exposes Liquidity Functions;"
    ;;
    (defschema LiquiditySplit
        balanced:[decimal]
        asymetric:[decimal]
        
    )
    (defschema LiquiditySplitType
        iz-balanced:bool
        iz-asymetric:bool
    )
    (defschema LiquidityData
        sorted-lq:object{LiquiditySplit}
        sorted-lq-type:object{LiquiditySplitType}
        balanced:decimal
        asymetric:decimal
        asymetric-fee:decimal
    )
    (defschema LiquidityComputationData
        li:integer
        pool-type:string
        lp-prec:integer
        current-lp-supply:decimal
        lp-supply:decimal
        pool-token-supplies:[decimal]
    )
    ;;
    (defun UC_DetermineLiquidity:object{LiquiditySplitType} (input-lqs:object{LiquiditySplit}))
    (defun UC_BareboneSwapWithFeez:object{UtilitySwpV2.DirectTaxedSwapOutput}
        (
            account:string pool-type:string 
            dsid:object{UtilitySwpV2.DirectSwapInputData} fees:object{UtilitySwpV2.SwapFeez}
            A:decimal X:[decimal] X-prec:[integer] input-positions:[integer] output-position:integer weights:[decimal]
        )
    )
    (defun UC_InverseBareboneSwapWithFeez:object{UtilitySwpV2.InverseTaxedSwapOutput}
        (
            account:string pool-type:string 
            rsid:object{UtilitySwpV2.ReverseSwapInputData} fees:object{UtilitySwpV2.SwapFeez}
            A:decimal X:[decimal] X-prec:[integer] output-position:integer input-position:integer weights:[decimal]
        )
    )
    (defun UC_VirtualSwap:object{UtilitySwpV2.VirtualSwapEngine} 
        (vse:object{UtilitySwpV2.VirtualSwapEngine} dsid:object{UtilitySwpV2.DirectSwapInputData})
    )
    (defun UC_TrimZeroInputAmounts:[decimal] (input-amounts:[decimal]))
    ;;
    (defun URC_TrimIdsWithZeroAmounts:[string] (swpair:string input-amounts:[decimal]))
    (defun URC_DirectRefillAmounts:[decimal] (swpair:string ids:[string] amounts:[decimal]))
    (defun URC_IndirectRefillAmounts:[decimal] (X:[decimal] positions:[integer] amounts:[decimal]))
    (defun URC_EliteFeeReduction:object{UtilitySwpV2.SwapFeez} (account:string fees:object{UtilitySwpV2.SwapFeez}))
    (defun URC_AsymetricTax (account:string swpair:string ld:object{LiquidityData}))
        ;;
    (defun URC_KDA-PID:decimal ())
    (defun URC_LpToIgnis:decimal (swpair:string lp-amount:decimal kda-pid:decimal))
        ;;
    (defun URC_EntityPosToID:string (swpair:string entity-pos:integer))
    (defun URC_SortLiquidty:object{LiquiditySplit} (swpair:string input-amounts:[decimal]))
    (defun URC_AddLiquidityIgnisCost:decimal (swpair:string input-amounts:[decimal]))
    (defun URC_AreAmountsBalanced:bool (swpair:string input-amounts:[decimal]))
    (defun URC_BalancedLiquidityV2:[decimal] (swpair:string input-id:string input-amount:decimal with-validation:bool))
    (defun URC_Liquidity:object{LiquidityData} (swpair:string input-amounts:[decimal]))
    (defun URC_LpBreakAmounts:[decimal] (swpair:string input-lp-amount:decimal))
    (defun URC_CustomLpBreakAmounts:[decimal] (swpair:string swpair-pool-token-supplies:[decimal] swpair-lp-supply:decimal input-lp-amount:decimal))
    ;;
    (defun UEV_BalancedLiquidity (swpair:string input-id:string input-amount:decimal))
    (defun UEV_InputsForLP (swpair:string input-amounts:[decimal]))
    ;;
    (defun UDC_VirtualSwapEngineSwpair:object{UtilitySwpV2.VirtualSwapEngine} (account:string account-liq:[decimal] swpair:string pool-liq:[decimal]))
    (defun UDC_VirtualSwapEngine:object{UtilitySwpV2.VirtualSwapEngine}
        (
            account:string account-liq:[decimal] swpair:string starting-liq:[decimal]
            A:decimal W:[decimal] F:object{UtilitySwpV2.SwapFeez}
        )
    )
    (defun UDC_PoolFees:object{UtilitySwpV2.SwapFeez} (swpair:string))
        ;;
    (defun UDC_LiquiditySplit:object{LiquiditySplit} (a:[decimal] b:[decimal]))
    (defun UDC_LiquiditySplitType:object{LiquiditySplitType} (a:bool b:bool))
    (defun UDC_LiquidityData:object{LiquidityData} (a:object{LiquiditySplit} b:object{LiquiditySplitType} c:decimal d:decimal e:decimal))
    (defun UDC_LiquidityComputationData:object{LiquidityComputationData} (a:integer b:string c:integer d:decimal e:decimal f:[decimal]))
    ;;
    ;;
    (defun C_ToggleAddLiquidity:object{OuronetDalosV3.OutputCumulatorV2} (swpair:string toggle:bool))
    (defun C_AddLiquidity:object{OuronetDalosV3.OutputCumulatorV2} (account:string swpair:string input-amounts:[decimal]))
    (defun C_AddSleepingLiquidity:object{OuronetDalosV3.OutputCumulatorV2} (account:string swpair:string sleeping-dpmf:string nonce:integer))
    (defun C_AddFrozenLiquidity:object{OuronetDalosV3.OutputCumulatorV2} (account:string swpair:string frozen-dptf:string input-amount:decimal))
    (defun C_RemoveLiquidity:object{OuronetDalosV3.OutputCumulatorV2} (account:string swpair:string lp-amount:decimal))
)
(module SWPL GOV
    ;;
    (implements OuronetPolicy)
    (implements BrandingUsageV5)
    (implements SwapperLiquidity)
    ;(implements DemiourgosPactDigitalCollectibles-UtilityPrototype)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_SWPL           (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|SWPL_ADMIN)))
    (defcap GOV|SWPL_ADMIN ()       (enforce-guard GOV|MD_SWPL))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
    (defcap P|SWPL|REMOTE-GOV ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|SWPL|CALLER))
        (compose-capability (SECURE))
    )
    (defcap P|DT ()
        (compose-capability (P|SWPL|REMOTE-GOV))
        (compose-capability (P|SWPL|CALLER))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::P|Info)))
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
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|VST:module{OuronetPolicy} VST)
                (ref-P|SWP:module{OuronetPolicy} SWP)
                (mg:guard (create-capability-guard (P|SWPL|CALLER)))
            )
            (ref-P|VST::P|A_Add
                "SWPL|RemoteSwpGov"
                (create-capability-guard (P|SWPL|REMOTE-GOV))
            )
            (ref-P|SWP::P|A_Add
                "SWPL|RemoteSwpGov"
                (create-capability-guard (P|SWPL|REMOTE-GOV))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|DPMF::P|A_AddIMP mg)
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
    (defun CT_EmptyCumulator        ()(let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::DALOS|EmptyOutputCumulatorV2)))
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
    (defcap SWPL|C>UPDATE-BRD (swpair:string)
        @event
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
            )
            (ref-SWP::CAP_Owner swpair)
            (compose-capability (P|SWPL|CALLER))
        )
    )
    (defcap SWPU|C>UPGRADE-BRD (swpair:string)
        @event
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
            )
            (ref-SWP::CAP_Owner swpair)
            (compose-capability (P|SWPL|CALLER))
        )
    )
    ;;
    (defcap SWPL|C>ADD_LQ (swpair:string)
        @doc "Input Validation occurs in <URC_DoubleValueLP> part of the <AddLiqudity>"
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                (can-add:bool (ref-SWP::UR_CanAdd swpair))
            )
            (enforce can-add (format "Liquidity Adding and Removal isnt enabled on pool {}" [swpair]))
            (compose-capability (P|DT))
            (compose-capability (SECURE))
        )
    )
    (defcap SWPL|C>ADD_ASYMETRIC-LQ (account:string swpair:string input-amounts:[decimal])
        @doc "No further validation needed, as Capability is already called: \
            \ with an <account> for which ownership has been verified \
            \ an <swpair> that exists \
            \ <input-amounts> that are asymetric to the input <swpair>"
        @event
        true
    )
    (defcap SWPL|C>ADD_BALANCED-LQ (account:string swpair:string input-amounts:[decimal])
        @doc "No further validation needed, as Capability is already called: \
            \ with an <account> for which ownership has been verified \
            \ an <swpair> that exists \
            \ <input-amounts> that are balanced to the input <swpair>"
        @event
        true
    )
    ;;
    (defcap SWPL|C>ADD_SLEEPING-LQ (account:string swpair:string sleeping-dpmf:string nonce:integer)
        @event
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (ref-SWP:module{SwapperV4} SWP)
                (iz-sleeping:bool (ref-SWP::UR_IzSleepingLP swpair))
                (dptf:string (ref-DPMF::UR_Sleeping sleeping-dpmf))
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
            )
            (ref-DPMF::UEV_NoncesToAccount sleeping-dpmf account [nonce])
            (let
                (
                    (nonce-md:[object] (ref-DPMF::UR_AccountNonceMetaData sleeping-dpmf nonce account))
                    (release-date:time (at "release-date" (at 0 nonce-md)))
                    (present-time:time (at "block-time" (chain-data)))
                    (dt:decimal (diff-time release-date present-time))
                )
                (enforce (> dt 0.0) (format "Sleeping must exist for Nonce {} for operation" [nonce]))
                (enforce iz-sleeping (format "Sleeping LP Functionality is not enabled on Swpair {}" [swpair]))
                (enforce (contains dptf pool-tokens) (format "Sleeping DPMF {} incompatible with Swpair {}" [sleeping-dpmf swpair]))
                (compose-capability (P|DT))
            )
        )
    )
    (defcap SWPL|C>ADD_FROZEN-LQ (swpair:string frozen-dptf:string)
        @event
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                (iz-frozen:bool (ref-SWP::UR_IzFrozenLP swpair))
                (dptf:string (ref-DPTF::UR_Frozen frozen-dptf))
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
            )
            (enforce iz-frozen (format "Frozen LP Functionality is not enabled on Swpair {}" [swpair]))
            (enforce (contains dptf pool-tokens) (format "Frozen DPTF {} incompatible with Swpair {}" [frozen-dptf swpair]))
            (compose-capability (P|DT))
        )
    )
    (defcap SWPL|C>RM_LQ (swpair:string lp-amount:decimal)
        @event
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                (can-add:bool (ref-SWP::UR_CanAdd swpair))
                (lp-id:string (ref-SWP::UR_TokenLP swpair))
                (pool-lp-amount:decimal (ref-DPTF::UR_Supply lp-id))
            )
            (ref-DPTF::UEV_Amount lp-id lp-amount)
            (ref-SWP::UEV_id swpair)
            (enforce (<= lp-amount pool-lp-amount) (format "{} is an invalid LP Amount for removing Liquidity" [lp-amount]))
            (enforce can-add "Pool is inactive: cannot add or remove liqudity!")
        )
        (compose-capability (P|DT))
        (compose-capability (SECURE))
    )
    (defcap SWPL|C>INDIRECT-FUEL
        (account:string swpair:string id-lst:[string] transfer-amount-lst:[decimal])
        @event
        (compose-capability (P|SWPL|CALLER))
    )
    (defcap SWPL|C>DIRECT-FUEL
        (account:string swpair:string id-lst:[string] transfer-amount-lst:[decimal])
        @event
        (compose-capability (P|DT))
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_DetermineLiquidity:object{SwapperLiquidity.LiquiditySplitType}
        (input-lqs:object{SwapperLiquidity.LiquiditySplit})
        (let
            (
                (balanced-liquidity:[decimal] (at "balanced" input-lqs))
                (asymetric-liquidity:[decimal] (at "asymetric" input-lqs))
                (l:integer (length balanced-liquidity))
                (iz-balanced:bool (!= balanced-liquidity (make-list l 0.0)))
                (iz-asymetric:bool (!= asymetric-liquidity (make-list l 0.0)))
            )
            {"iz-balanced"  : iz-balanced
            ,"iz-asymetric" : iz-asymetric}
        )
    )
    (defun UC_BareboneSwapWithFeez:object{UtilitySwpV2.DirectTaxedSwapOutput}
        (
            account:string pool-type:string 
            dsid:object{UtilitySwpV2.DirectSwapInputData} fees:object{UtilitySwpV2.SwapFeez}
            A:decimal X:[decimal] X-prec:[integer] input-positions:[integer] output-position:integer weights:[decimal]
        )
        @doc "Performs a Direct Swap with Fees Computation, outputing results in an object{UtilitySwpV2.DirectTaxedSwapOutput} \
            \ Given proper inputs, can be used for an actual Swap Functions, to save redundant code."
        (let
            (
                ;;Unwrap Object Data
                (input-ids:[string] (at "input-ids" dsid))
                (input-amounts:[decimal] (at "input-amounts" dsid))
                (output-id:string (at "output-id" dsid))
                ;;
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWPI:module{SwapperIssue} SWPI)
                ;;
                (drsi:object{UtilitySwpV2.DirectRawSwapInput}
                    (ref-SWPI::UDC_DirectRawSwapInput dsid A X input-positions output-position weights)
                )
                ;;Get Working fees
                (reduced-fees:object{UtilitySwpV2.SwapFeez} (URC_EliteFeeReduction account fees))
                (f1:decimal (at "lp" reduced-fees))
                (f2:decimal (at "special" reduced-fees))
                (f3:decimal (at "boost" reduced-fees))
                (o-prec:integer (at output-position X-prec))
                ;;
                ;;From the input amounts, compute FeeSharesExcludingLpFee <fselp>
                (fselp:decimal (- 1000.0 f1))
                (input-amounts-for-swap:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (ref-U|LST::UC_AppL
                                acc
                                (floor
                                    (* (at idx input-amounts) (/ fselp 1000.0))
                                    (at (at idx input-positions) X-prec)
                                )
                            )
                        )
                        []
                        (enumerate 0 (- (length input-amounts) 1))
                    )
                )
                (input-amounts-for-lp:[decimal] (zip (-) input-amounts input-amounts-for-swap))
                (input-amounts-for-lp-filled:[decimal] (URC_IndirectRefillAmounts X input-positions input-amounts-for-lp))
                ;;
                ;;Total-Swap-Output-Amount <tsoa> is computed without them, then splited into 3 parts: 
                ;;special, boost, remainder
                (tsoa:decimal (ref-SWPI::UC_BareboneSwap pool-type drsi))
                (special:decimal (floor (* (/ f2 fselp) tsoa) o-prec))
                (boost:decimal (floor (* (/ f3 fselp) tsoa) o-prec))
                (remainder:decimal (- tsoa (+ special boost)))
            )
            (ref-U|SWP::UDC_DirectTaxedSwapOutput
                input-amounts-for-lp-filled
                output-id
                special
                boost
                remainder
            )
        )
    )
    (defun UC_InverseBareboneSwapWithFeez:object{UtilitySwpV2.InverseTaxedSwapOutput}
        (
            account:string pool-type:string 
            rsid:object{UtilitySwpV2.ReverseSwapInputData} fees:object{UtilitySwpV2.SwapFeez}
            A:decimal X:[decimal] X-prec:[integer] output-position:integer input-position:integer weights:[decimal]
        )
        @doc "Performs a Reverse Swap with Fees Computation, outputing results in an object{UtilitySwpV2.InverseTaxedSwapOutput} \
            \ Use Case is displaying Input Amounts for a Swap when the desired Output Amount of a Token is entered first. \
            \ However not only the input required can be displayed, but also the susequent fees that would be incurred"
        (let
            (
                ;;Unwrap Object Data
                (output-id:string (at "output-id" rsid))
                (output-amount:decimal (at "output-amount" rsid))
                (input-id:string (at "input-id" rsid))
                ;;
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWPI:module{SwapperIssue} SWPI)
                ;;
                ;;Get Working fees
                (reduced-fees:object{UtilitySwpV2.SwapFeez} (URC_EliteFeeReduction account fees))
                (f1:decimal (at "lp" reduced-fees))
                (f2:decimal (at "special" reduced-fees))
                (f3:decimal (at "boost" reduced-fees))
                (o-prec:integer (at output-position X-prec))
                (i-prec:integer (at input-position X-prec))
                ;;
                ;;Star by computing the Output fee shares <ofs>
                (ofs:decimal (- 1000.0 (fold (+) 0.0 [f1 f2 f3])))
                ;;Compute Output-Amount per fee Share <oapfs>
                (oapfs:decimal (floor (/ output-amount ofs) o-prec))
                (boost:decimal (floor (* f3 oapfs) o-prec))
                (special:decimal (floor (* f2 oapfs) o-prec))
                ;;Then Compute Total-Swap-Output-Amount <tsoa>
                (tsoa:decimal (fold (+) 0.0 [output-amount boost special]))
                ;:Remake a new rsid
                (new-rsid:object{UtilitySwpV2.ReverseSwapInputData} 
                    (ref-U|SWP::UDC_ReverseSwapInputData output-id tsoa input-id)
                )
                (irsi:object{UtilitySwpV2.InverseRawSwapInput}
                    (ref-SWPI::UDC_InverseRawSwapInput new-rsid A X output-position input-position weights)
                )
                ;;Now Compute the Input Amount needed to get the <tsoa>, the Partial-Input-Amount <pia>
                ;;<pia> is part of the TotalInputAmount, that would be used for a direct swap, after LP fees have been retained
                (pia:decimal (ref-SWPI::UC_BareboneInverseSwap pool-type irsi))
                ;;Now Compute the Total-Input-Amouant <tia>
                (tia:decimal (floor (/ (* f1 pia) (- 1000.0 f1)) i-prec))
            )
            (ref-U|SWP::UDC_InverseTaxedSwapOutput
                boost
                special
                (URC_IndirectRefillAmounts X [input-position] (- tia pia))
                input-id
                tia
            )
        )
    )
    ;;
    (defun UC_VirtualSwap:object{UtilitySwpV2.VirtualSwapEngine} 
        (vse:object{UtilitySwpV2.VirtualSwapEngine} dsid:object{UtilitySwpV2.DirectSwapInputData})
        @doc "Executes a Virtual Swap, saving data in the Output Object"
        (let
            (
                ;;Unwrap Input Objects
                (v-tokens:[string] (at "v-tokens" vse))
                (v-prec:[integer] (at "v-prec" vse))
                (account:string (at "account" vse))
                (account-supply:[decimal] (at "account-supply" vse))
                (swpair:string (at "swpair" vse))
                (X:[decimal] (at "X" vse))
                (A:decimal (at "A" vse))
                (W:[decimal] (at "W" vse))
                (F:object{UtilitySwpV2.SwapFeez} (at "F" vse))
                (fuel:[decimal] (at "fuel" vse))
                (special:[decimal] (at "special" vse))
                (boost:[decimal] (at "boost" vse))
                (swaps:[object{UtilitySwpV2.DirectSwapInputData}] (at "swaps" vse))
                ;;
                (input-ids:[string] (at "input-ids" dsid))
                (input-amounts:[decimal] (at "input-amounts" dsid))
                (output-id:string (at "output-id" dsid))
                ;;
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPI:module{SwapperIssue} SWPI)
                ;;
                (pool-type:string (ref-U|SWP::UC_PoolType swpair))
                (input-positions:[integer] (ref-SWPI::UC_PoolTokenPositions swpair input-ids))
                (output-position:integer (at 0 (ref-SWPI::UC_PoolTokenPositions swpair [output-id])))
                ;;
                (swap-result:object{UtilitySwpV2.DirectTaxedSwapOutput}
                    (UC_BareboneSwapWithFeez account pool-type dsid F A X v-prec input-positions output-position W)
                )
                (tsoa:decimal (fold (+) 0.0 [(at "o-id-special" swap-result) (at "o-id-liquid" swap-result) (at "o-id-netto" swap-result)]))
                (tsoa-filled:[decimal] (URC_IndirectRefillAmounts X [output-position] [tsoa]))
                (remainder-filled:[decimal] (URC_IndirectRefillAmounts X [output-position] [(at "o-id-netto" swap-result)]))
                (input-amounts-filled:[decimal] (URC_IndirectRefillAmounts X input-positions input-amounts))
                (input-amounts-for-lp-filled:[decimal] (URC_IndirectRefillAmounts X input-positions (at "lp-fuel" swap-result)))
            )
            (ref-U|SWP::UDC_VirtualSwapEngine
                v-tokens v-prec account
                (zip (+) remainder-filled (zip (-) account-supply input-amounts-filled)) 
                swpair X A W F
                (zip (+) fuel input-amounts-for-lp-filled)
                (ref-U|LST::UC_ReplaceAt special output-position (+ (at output-position special) (at "o-id-special" swap-result)))
                (ref-U|LST::UC_ReplaceAt boost output-position (+ (at output-position boost) (at "o-id-liquid" swap-result)))
                (ref-U|LST::UC_AppL swaps dsid)
            )
        )
    )
    ;;
    (defun UC_TrimZeroInputAmounts:[decimal] (input-amounts:[decimal])
        @doc "Trims the <input-amounts> list for zeroes, \
            \ so that it may be used for transfering purposes."
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (zero-positions:[integer] (ref-U|LST::UC_Search input-amounts 0.0))
            )
            (fold
                (lambda
                    (acc:[decimal] idx:integer)
                    (let
                        (
                            (iz-index-zero:bool (contains idx zero-positions))
                        )
                        (if (not iz-index-zero)
                            (ref-U|LST::UC_AppL
                                acc
                                (at idx input-amounts)
                            )
                            acc
                        )
                    )
                )
                []
                (enumerate 0 (- (length input-amounts) 1))
            )
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun URC_TrimIdsWithZeroAmounts:[string] (swpair:string input-amounts:[decimal])
        @doc "From a complete list of input amounts, also containing zeroes, \
            \ creates a list of Pool Token IDs for the amounts greater than zero. \
            \ Its brother Function <UC_TrimZeroInputAmounts> creates the equivalent \
            \ <input-amounts> list with values greater than zero."
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-SWP:module{SwapperV4} SWP)
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (zero-positions:[integer] (ref-U|LST::UC_Search input-amounts 0.0))
            )
            (fold
                (lambda
                    (acc:[string] idx:integer)
                    (let
                        (
                            (iz-index-zero:bool (contains idx zero-positions))
                        )
                        (if (not iz-index-zero)
                            (ref-U|LST::UC_AppL
                                acc
                                (at idx pool-tokens)
                            )
                            acc
                        )
                    )
                )
                []
                (enumerate 0 (- (length input-amounts) 1))
            )
        )
    )
    (defun URC_DirectRefillAmounts:[decimal] (swpair:string ids:[string] amounts:[decimal])
        @doc "Refill incomplete amount values with zeros, to create an amount equal to the <swpair> token number"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-SWP:module{SwapperV4} SWP)
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
            )
            (fold
                (lambda
                    (acc:[decimal] idx:integer)
                    (let
                        (
                            (pt:string (at idx pool-tokens))
                            (spt:[integer] (ref-U|LST::UC_Search ids pt))
                            (pos:integer
                                (if (> (length spt) 0)
                                    (at 0 spt)
                                    -1
                                )
                            )
                            (value:decimal
                                (if (= pos -1)
                                    0.0
                                    (at pos amounts)
                                )
                            )
                        )
                        (ref-U|LST::UC_AppL acc value)
                    )
                )
                []
                (enumerate 0 (- (length pool-tokens) 1))
            )
        )
    )
    (defun URC_IndirectRefillAmounts:[decimal] (X:[decimal] positions:[integer] amounts:[decimal])
        @doc "Refill incomplete amount values with zeros, to create an amount equal to the <X> positions number"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[decimal] idx:integer)
                    (let
                        (
                            (spt:[integer] (ref-U|LST::UC_Search positions idx))
                            (pos:integer
                                (if (> (length spt) 0)
                                    (at 0 spt)
                                    -1
                                )
                            )
                            (value:decimal
                                (if (= pos -1)
                                    0.0
                                    (at pos amounts)
                                )
                            )
                        )
                        (ref-U|LST::UC_AppL acc value)
                    )
                )
                []
                (enumerate 0 (- (length X) 1))
            )
        )
    )
    (defun URC_EliteFeeReduction:object{UtilitySwpV2.SwapFeez} (account:string fees:object{UtilitySwpV2.SwapFeez})
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (major:integer (ref-DALOS::UR_Elite-Tier-Major account))
                (minor:integer (ref-DALOS::UR_Elite-Tier-Minor account))
            )
            (ref-U|SWP::UDC_SwapFeez
                (ref-U|DALOS::UC_GasCost (at "lp" fees) major minor false)
                (ref-U|DALOS::UC_GasCost (at "special" fees) major minor false)
                (ref-U|DALOS::UC_GasCost (at "boost" fees) major minor false)
            )
        )
    )
    (defun URC_AsymetricTax
        (account:string swpair:string ld:object{SwapperLiquidity.LiquidityData})
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (balanced-liquidity:[decimal] (at "balanced" (at "sorted-lq" ld)))
                (asymetric-liquidity:[decimal] (at "asymetric" (at "sorted-lq" ld)))
                (iz-balanced:bool (at "iz-balanced" (at "sorted-lq-type" ld)))
                (iz-asymetric:bool (at "iz-asymetric" (at "sorted-lq-type" ld)))
                ;;
                (balanced-lp-amount:decimal (at "balanced" ld))
                (asymetric-lp-amount:decimal (at "asymetric" ld))
                (asymetric-lp-fee-amount:decimal (at "asymetric-fee" ld))
                (lp-amount:decimal (+ balanced-lp-amount asymetric-lp-amount))
                ;;
                (pool-token-supplies:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (lp-supply:decimal (ref-SWP::URC_LpCapacity swpair))
                (virtual-pool-token-supplies:[decimal] 
                    (if iz-balanced
                        (zip (+) pool-token-supplies balanced-liquidity)
                        pool-token-supplies
                    )
                )
                (virtual-lp-supply:decimal
                    (if iz-balanced
                        (+ lp-supply balanced-lp-amount)
                        lp-supply
                    )
                )
                (asymetric-break-amounts:[decimal]
                    (URC_CustomLpBreakAmounts swpair virtual-pool-token-supplies virtual-lp-supply asymetric-lp-amount)
                )
                ;;
                ;;Construct the Virtual Swapper
                ;;
                (vse:object{UtilitySwpV2.VirtualSwapEngine}
                    (UDC_VirtualSwapEngineSwpair account asymetric-liquidity swpair virtual-pool-token-supplies)
                )
                ;;Preparing first Virtual Swap
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (df-pool-tokens:[string] (drop 1 pool-tokens))
                (df-asymetric-liquidity:[decimal] (drop 1 asymetric-liquidity))
                ;(search-for-zeroes:[integer] (ref-U|LST::UC_Search df-asymetric-liquidity 0.0))
                (df-asymetric-liquidity-no-zeroes:[decimal] (ref-U|LST::UC_RemoveItem df-asymetric-liquidity 0.0))
                (df-pool-tokens-no-zeroes:[string]
                    (fold
                        (lambda
                            (acc:[string] idx:integer)
                            (if (!= (at idx df-asymetric-liquidity) 0.0)
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
                (l1:integer (length df-asymetric-liquidity-no-zeroes))
                (swap-no1-data:object{UtilitySwpV2.DirectSwapInputData}
                    (ref-U|SWP::DirectSwapInputData
                        df-pool-tokens-no-zeroes
                        df-asymetric-liquidity-no-zeroes
                        (at 0 pool-tokens)
                    )
                )
                ;;
                ;;First Virtual Swap
                (vse1:object{UtilitySwpV2.VirtualSwapEngine}
                    (if (!= l1 0)
                        (UC_VirtualSwap vse swap-no1-data)
                        vse
                    )
                )
            )
            [
                (format "ASYMETRIC BREAK AMOUNTS ARE {}" [asymetric-break-amounts])
                (format "FIRST SWAP IZ {}" [vse1])
            ]
        )
    )
    ;;
    (defun URC_KDA-PID:decimal ()
        ;;(at "value" (n_bfb76eab37bf8c84359d6552a1d96a309e030b71.dia-oracle.get-value "KDA/USD"))
        1.0
    )
    (defun URC_LpToIgnis:decimal (swpair:string lp-amount:decimal kda-pid:decimal)
        ;;<kda-pid> or <kda-price-in-dollars> can be retrieved prior to the function call with:
        ;;(at "value" (n_bfb76eab37bf8c84359d6552a1d96a309e030b71.dia-oracle.get-value "KDA/USD"))
        ;;This function is structured like this, to allow price retrieval from any source.
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPI:module{SwapperIssue} SWPI)
                ;;
                (pool-value:[decimal] (ref-SWPI::URC_PoolValue swpair))
                (lp-value-in-dwk:decimal (at 1 pool-value))
            )
            (floor (fold (*) 1.0 [lp-amount lp-value-in-dwk kda-pid]) 2)
        )
    )
    ;;
    (defun URC_EntityPosToID:string (swpair:string entity-pos:integer)
        (let
            (
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-SWP:module{SwapperV4} SWP)
            )
            (ref-U|INT::UEV_PositionalVariable entity-pos 3 "Invalid entity position")
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
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
    (defun URC_SortLiquidty:object{SwapperLiquidity.LiquiditySplit} (swpair:string input-amounts:[decimal])
        @doc "Sorts Liquidity into a balanced part and an asymetric part"
        (let
            (
                (has-zeroes:bool (contains 0.0 input-amounts))
            )
            (if has-zeroes
                {"balanced"     : (make-list (length input-amounts) 0.0)
                ,"asymetric"    : input-amounts}
                (let
                    (
                        ;;(ref-U|LST:module{StringProcessor} U|LST)
                        (ref-SWP:module{SwapperV4} SWP)
                        (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                        (balanced-chain:[decimal]
                            (fold
                                (lambda
                                    (acc:[decimal] idx:integer)
                                    (let
                                        (

                                            (input-id:string (at idx pool-tokens))
                                            (input-amount:decimal (at idx input-amounts))
                                            (balanced-lq:[decimal] (URC_BalancedLiquidityV2 swpair input-id input-amount false))
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
                    {"balanced"     : balanced-chain
                    ,"asymetric"    : (zip (-) input-amounts balanced-chain)}
                )
            )
        )
    )
    (defun URC_AddLiquidityIgnisCost:decimal (swpair:string input-amounts:[decimal])
        @doc "To be revised"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-SWP:module{SwapperV4} SWP)
                (med:decimal (ref-DALOS::UR_UsagePrice "ignis|medium"))
                (liq:decimal (ref-DALOS::UR_UsagePrice "ignis|swp-liquidity"))
                (iz-balanced:bool (URC_AreAmountsBalanced swpair input-amounts))
                (n:decimal (dec (length (ref-SWP::UR_PoolTokens swpair))))
                (m:decimal (dec (length (ref-U|LST::UC_RemoveItem input-amounts 0.0))))
            )
            (if iz-balanced
                med
                (if (= m n)
                    (* liq n)
                    (* liq (- n m))
                )
            )
        )
    )
    (defun URC_AreAmountsBalanced:bool (swpair:string input-amounts:[decimal])
        @doc "Determines if <input-amounts> are balanced according to <swpair>"
        (let
            (
                (sum:decimal (fold (+) 0.0 input-amounts))
            )
            (enforce (> sum 0.0) "At least a single input value must be greater than zero!")
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-SWP:module{SwapperV4} SWP)
                    (positive-amounts:[decimal] (ref-U|LST::UC_RemoveItem input-amounts 0.0))
                    (first-positive-amount:decimal (at 0 positive-amounts))
                    (positive-amounts-positions:[integer] (ref-U|LST::UC_Search input-amounts first-positive-amount))
                    (first-positive-position:integer (at 0 positive-amounts-positions))
                    (first-positive-id:string (at first-positive-position (ref-SWP::UR_PoolTokens swpair)))
                    (balanced-amounts:[decimal] (URC_BalancedLiquidityV2 swpair first-positive-id first-positive-amount false))
                )
                (if (= balanced-amounts input-amounts)
                    true
                    false
                )
            )
        )
    )
    (defun URC_BalancedLiquidityV2:[decimal] (swpair:string input-id:string input-amount:decimal with-validation:bool)
        @doc "Computes the amounts of Balanced Liquidity from one <input-id> with an <input-amount> on a given <swpair> \
        \ <with-validation> specifies if additional validation should also be executed to validate the inputs."
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
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
    (defun URC_Liquidity:object{SwapperLiquidity.LiquidityData} (swpair:string input-amounts:[decimal])
        @doc "Computes the LP amounts, valid for all 3 pool types, outputing a TripleLP object containing: \
        \ 1st Value: A Liquidity Split Object, containing the Liquidity Split \
        \ 2nd Value: The Type of Liquidity existing in the input \
        \ 3rd Value: LP for the Balanced Part \
        \ 4th Value: Full LP for the Asymetric Part \
        \ 5th Value: LP Amount as Liquidity Fee for the Asymetric Part"
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (sorted-lq:object{SwapperLiquidity.LiquiditySplit} (URC_SortLiquidty swpair input-amounts))
                (sorted-lq-type:object{SwapperLiquidity.LiquiditySplitType} (UC_DetermineLiquidity sorted-lq))
                (balanced-lq:[decimal] (at "balanced" sorted-lq))
                (asymetric-lq:[decimal] (at "asymetric" sorted-lq))
                (iz-balanced:bool (at "iz-balanced" sorted-lq-type))
                (iz-asymetric:bool (at "iz-asymetric" sorted-lq-type))
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
                (lcd:object{SwapperLiquidity.LiquidityComputationData}
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
                ;;Asymetric Liq Computation
                (y-with-z:[decimal]
                    (if iz-asymetric
                        (let
                            (
                                (asymetric-lp:[decimal] (URCX_AsymetricLP swpair asymetric-lq lcd))
                                (full-lp:decimal (at 0 asymetric-lp))
                                (taxd-lp:decimal (at 1 asymetric-lp))
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
    (defun URCX_BalancedLP:decimal (lcd:object{SwapperLiquidity.LiquidityComputationData} balanced-lq:[decimal])
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
    (defun URCX_AsymetricLP:[decimal] (swpair:string asymetric-lq:[decimal] lcd:object{SwapperLiquidity.LiquidityComputationData})
        @doc "Computes the Full LP (at 0) and Reduced LP (at 1) from Liquidity Fee for asymetric-liquidity"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|VST:module{UtilityVst} U|VST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (li:integer (at "li" lcd))
                (pool-type:string (at "pool-type" lcd))
                (lp-prec:integer (at "lp-prec" lcd))
                (current-lp-supply:decimal (at "current-lp-supply" lcd))
                (lp-supply:decimal (at "lp-supply" lcd))
                (pool-token-supplies:[decimal] (at "pool-token-supplies" lcd))
                ;;
                ;;Compute Full LP for Asymetric Liq
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
                                    (fold (*) 1.0 [(/ (at idx asymetric-lq) (at idx pool-token-supplies)) (at idx percent-lst) lp-supply]) 
                                    lp-prec
                                )
                            )
                        )
                        []
                        (enumerate 0 (- li 1))
                    )
                )
                (full-asymetric-lp:decimal (fold (+) 0.0 lp-amounts))
                ;;Compute Taxed LP for Asymetric Liq
                (liquidity-fee:decimal (/ (ref-SWP::URC_LiquidityFee swpair) 1000.0))
                (amp:decimal (ref-SWP::UR_Amplifier swpair))
                (new-balances:[decimal] (zip (+) pool-token-supplies asymetric-lq))
                (d0:decimal
                    (if (= pool-type "S")
                        (ref-U|SWP::UC_ComputeD amp pool-token-supplies)
                        5040000.0
                    )
                )
                (d1:decimal
                    (if (= pool-type "S")
                        (ref-U|SWP::UC_ComputeD amp new-balances)
                        (+ 5040000.0 (URCXX_D1forWP swpair pool-token-supplies asymetric-lq))
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
                (taxed-asymetric-lp:decimal
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
            [full-asymetric-lp taxed-asymetric-lp]
        )
    )
    (defun URCXX_D1forWP:decimal (swpair:string current:[decimal] input:[decimal])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWP:module{SwapperV4} SWP)
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
    (defun URC_LpBreakAmounts:[decimal] (swpair:string input-lp-amount:decimal)
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
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
                (ref-SWP:module{SwapperV4} SWP)
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
    (defun UEV_BalancedLiquidity (swpair:string input-id:string input-amount:decimal)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (iz-on-pool:bool (contains input-id pool-tokens))
            )
            (enforce iz-on-pool (format "Token {} is not part of SWPair {}" [input-id swpair]))
            (ref-DPTF::UEV_Amount input-id input-amount)
        )
    )
    (defun UEV_InputsForLP (swpair:string input-amounts:[decimal])
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
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
    ;;{F3}  [UDC]
    (defun UDC_VirtualSwapEngineSwpair:object{UtilitySwpV2.VirtualSwapEngine}
        (account:string account-liq:[decimal] swpair:string pool-liq:[decimal])
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
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
                (ref-SWP:module{SwapperV4} SWP)
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
                (ref-SWP:module{SwapperV4} SWP)
                (lb:bool (ref-SWP::UR_LiquidBoost))
                (lp-fee:decimal (ref-SWP::UR_FeeLP swpair))
                (special-fee:decimal (ref-SWP::UR_FeeSP swpair))
                (boost-fee:decimal (if lb lp-fee 0.0))
            )
            (ref-U|SWP::UDC_SwapFeez lp-fee special-fee boost-fee)
        )
    )
    (defun UDC_LiquiditySplit:object{SwapperLiquidity.LiquiditySplit} (a:[decimal] b:[decimal])
        {"balanced"             : a
        ,"asymetric"            : b}
    )
    (defun UDC_LiquiditySplitType:object{SwapperLiquidity.LiquiditySplitType} (a:bool b:bool)
        {"iz-balanced"          : a
        ,"iz-asymetric"         : b}
    )
    (defun UDC_LiquidityData:object{SwapperLiquidity.LiquidityData}
        (a:object{SwapperLiquidity.LiquiditySplit} b:object{SwapperLiquidity.LiquiditySplitType} c:decimal d:decimal e:decimal)
        {"sorted-lq"            : a
        ,"sorted-lq-type"       : b
        ,"balanced"             : c
        ,"asymetric"            : d
        ,"asymetric-fee"        : e}
    )
    (defun UDC_LiquidityComputationData:object{SwapperLiquidity.LiquidityComputationData}
        (a:integer b:string c:integer d:decimal e:decimal f:[decimal])
        {"li"                   : a
        ,"pool-type"            : b
        ,"lp-prec"              : c
        ,"current-lp-supply"    : d
        ,"lp-supply"            : e
        ,"pool-token-supplies"  : f}
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;LP DPTF Branding
    (defun C_UpdatePendingBrandingLPs:object{OuronetDalosV3.OutputCumulatorV2}
        (swpair:string entity-pos:integer logo:string description:string website:string social:[object{Branding.SocialSchema}])
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-BRD:module{Branding} BRD)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (entity-id:string (URC_EntityPosToID swpair entity-pos))
                (entity-owner:string
                    (if (= entity-pos 3)
                        (ref-DPMF::UR_Konto entity-id)
                        (ref-DPTF::UR_Konto entity-id)
                    )
                )
            )
            (with-capability (SWPL|C>UPDATE-BRD swpair)
                (ref-BRD::XE_UpdatePendingBranding entity-id logo description website social)
                (ref-DALOS::UDC_BrandingCumulatorV2 entity-owner 2.0)
            )
        )
    )
    (defun C_UpgradeBrandingLPs (patron:string swpair:string entity-pos:integer months:integer)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-BRD:module{Branding} BRD)
                (ref-SWP:module{SwapperV4} SWP)
                (owner:string (ref-SWP::UR_OwnerKonto swpair))
                (entity-id:string (URC_EntityPosToID swpair entity-pos))
                (kda-payment:decimal
                    (with-capability (SWPU|C>UPGRADE-BRD swpair)
                        (ref-BRD::XE_UpgradeBranding entity-id owner months)
                    )
                )
            )
            (ref-DALOS::KDA|C_CollectWT patron kda-payment false)
        )
    )
    ;;
    (defun C_ToggleAddLiquidity:object{OuronetDalosV3.OutputCumulatorV2}
        (swpair:string toggle:bool)
        (UEV_IMC)
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
            )
            (with-capability (P|SWPL|CALLER)
                (ref-SWP::C_ToggleAddOrSwap swpair toggle true)
            )
        )
    )
    ;;V2
    ;;Must Add Ignis Cost and Asymetric Cost
    (defun C_Fuel:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string input-amounts:[decimal] direct-or-indirect:bool validation:bool)
        (UEV_IMC)
        (let
            (
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (swp-sc:string (ref-SWP::GOV|SWP|SC_NAME))
                (pt-current-amounts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (has-zeros:bool (contains 0.0 input-amounts))
                (input-ids-for-transfer:[string]
                    (if has-zeros
                        (URC_TrimIdsWithZeroAmounts swpair input-amounts)
                        pool-tokens
                    )
                )
                (input-amounts-for-transfer:[decimal]
                    (if has-zeros
                        (UC_TrimZeroInputAmounts input-amounts)
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
                (with-capability (SWPL|C>DIRECT-FUEL account swpair input-ids-for-transfer input-amounts-for-transfer)
                    (ref-SWP::XE_UpdateSupplies swpair new-balances)
                    (ref-TFT::C_MultiTransfer input-ids-for-transfer account swp-sc input-amounts-for-transfer true)
                )
                (with-capability (SWPL|C>INDIRECT-FUEL account swpair input-ids-for-transfer input-amounts-for-transfer)
                    (ref-SWP::XE_UpdateSupplies swpair new-balances)
                    EOC
                )
            )
        )
    )
    (defun C_AddLiquidity:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string input-amounts:[decimal])
        @doc "Asymetric Liquidity cant be added on an empty pool"
        (UEV_IMC)
        (with-capability (SWPL|C>ADD_LQ swpair)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (ref-SWP:module{SwapperV4} SWP)
                    ;;
                    (swp-sc:string (ref-SWP::GOV|SWP|SC_NAME))
                    (lp-id:string (ref-SWP::UR_TokenLP swpair))
                    (gw:[decimal] (ref-SWP::UR_GenesisWeigths swpair))
                    (read-lp-supply:decimal (ref-SWP::URC_LpCapacity swpair))
                    (pt-current-amounts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                    ;;
                    ;;Compute LP Amounts
                    (ld:object{SwapperLiquidity.LiquidityData} (URC_Liquidity swpair input-amounts))
                    (balanced-liquidity:[decimal] (at "balanced" (at "sorted-lq" ld)))
                    (asymetric-liquidity:[decimal] (at "asymetric" (at "sorted-lq" ld)))
                    (iz-balanced:bool (at "iz-balanced" (at "sorted-lq-type" ld)))
                    (iz-asymetric:bool (at "iz-asymetric" (at "sorted-lq-type" ld)))
                    ;;
                    (balanced-lp-amount:decimal (at "balanced" ld))
                    (asymetric-lp-amount:decimal (at "asymetric" ld))
                    (asymetric-lp-fee-amount:decimal (at "asymetric-fee" ld))
                    (lp-amount:decimal (+ balanced-lp-amount asymetric-lp-amount))
                    ;;
                    ;;Compute New Pool Amounts
                    (pt-amounts-with-balanced:[decimal] 
                        (zip (+) pt-current-amounts balanced-liquidity)
                    )
                    (pt-amounts-with-asymetric:[decimal] 
                        (zip (+) pt-amounts-with-balanced asymetric-liquidity)
                    )
                    ;;
                    ;;Compute Transfer IDs and Amounts
                    (input-ids-for-transfer:[string]
                        (if (and (not iz-balanced) iz-asymetric)
                            (URC_TrimIdsWithZeroAmounts swpair input-amounts)
                            (ref-SWP::UR_PoolTokens swpair)
                        )
                    )
                    (input-amounts-for-transfer:[decimal]
                        (if (and (not iz-balanced) iz-asymetric)
                            (UC_TrimZeroInputAmounts input-amounts)
                            input-amounts
                        )
                    )
                    ;;Compute Asymetric Liquidity Prices
                    (asymetric-ignis:decimal (URC_LpToIgnis swpair asymetric-lp-fee-amount (URC_KDA-PID)))
                    (liquidity-ignis:decimal (URC_AddLiquidityIgnisCost swpair input-amounts))
                    (price:decimal (+ asymetric-ignis liquidity-ignis))
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                    ;;
                    (ico0:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-DALOS::UDC_ConstructOutputCumulatorV2 price swp-sc trigger [])
                    )
                    (ico1:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-TFT::C_MultiTransfer input-ids-for-transfer account swp-sc input-amounts-for-transfer true)
                    )
                    (ico2:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-DPTF::C_Mint lp-id swp-sc lp-amount false)
                    )
                    (ico3:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-TFT::C_Transfer lp-id swp-sc account lp-amount true)
                    )
                )
                ;;Modify Weigths to Genesis Weigths if LP Supply was Zero prior to Adding this Liquidity
                (if (= read-lp-supply 0.0)
                    (ref-SWP::XB_ModifyWeights swpair gw)
                    true
                )
                ;;Update Pool Token Amounts
                (if (and iz-balanced (not iz-asymetric))
                    (with-capability (SWPL|C>ADD_BALANCED-LQ account swpair balanced-liquidity)
                        (ref-SWP::XE_UpdateSupplies swpair pt-amounts-with-balanced)
                    )
                    (if (and iz-asymetric (not iz-balanced))
                        (with-capability (SWPL|C>ADD_ASYMETRIC-LQ account swpair asymetric-liquidity)
                            (ref-SWP::XE_UpdateSupplies swpair pt-amounts-with-asymetric)
                        )
                        (with-capability (SWPL|C>ADD_BALANCED-LQ account swpair balanced-liquidity)
                            (with-capability (SWPL|C>ADD_ASYMETRIC-LQ account swpair asymetric-liquidity)
                                (ref-SWP::XE_UpdateSupplies swpair pt-amounts-with-asymetric)
                            )
                        )
                    )
                )
                ;;Autonomous Swap Mangement
                (XI_AutonomousSwapManagement swpair)
                ;;Output Cumulator
                (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 [ico1 ico2 ico3] [lp-amount])
            )
        )
    )
    ;;V1
    (defun C_AddSleepingLiquidity:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string sleeping-dpmf:string nonce:integer)
        (UEV_IMC)
        (with-capability (SWPL|C>ADD_SLEEPING-LQ account swpair sleeping-dpmf nonce)
            (let
                (
                    (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                    (ref-VST:module{VestingV3} VST)
                    (ref-SWP:module{SwapperV4} SWP)
                    (lp:string (ref-SWP::UR_TokenLP swpair))
                    (dptf:string (ref-DPMF::UR_Sleeping sleeping-dpmf))
                    (ptp:integer (ref-SWP::UR_PoolTokenPosition swpair dptf))
                    (vst-sc:string (ref-DALOS::GOV|VST|SC_NAME))
                    (batch-amount:decimal (ref-DPMF::UR_AccountNonceBalance sleeping-dpmf nonce account))
                    (lq-lst:[decimal] (ref-U|SWP::UC_MakeLiquidityList swpair ptp batch-amount))
                    (nonce-md:[object] (ref-DPMF::UR_AccountNonceMetaData sleeping-dpmf nonce account))
                    (release-date:time (at "release-date" (at 0 nonce-md)))
                    (present-time:time (at "block-time" (chain-data)))
                    (dt:integer (floor (diff-time release-date present-time)))
                    (ico1:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-DPMF::C_SingleBatchTransfer sleeping-dpmf nonce account vst-sc true)
                    )
                    (ico2:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-DPMF::C_Burn sleeping-dpmf nonce vst-sc batch-amount)
                    )
                    (ico3:object{OuronetDalosV3.OutputCumulatorV2}
                        (C_AddLiquidity vst-sc swpair lq-lst)
                    )
                    (lp-amount:decimal (at 0 (at "output" ico3)))
                    (ico4:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-VST::C_Sleep vst-sc account lp lp-amount dt)
                    )
                )
                (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 [ico1 ico2 ico3 ico4] [lp-amount])
                ;;1]<account> sends <sleeping-dpmf> to <VST|SC_NAME>
                ;;via ico1
                ;;2]<VST|SC_NAME> burns it and releasing the base dptf, which can then be directly used to add liqudity
                ;;via ico2
                ;;3]<VST|SC_NAME> adds liquidity with the <dptf>, generating native LP
                ;;via ico3
                ;;4]<VST|SC_NAME> sleeps resulted LP to target <account>
                ;;via ico4
            )
        )
    )
    (defun C_AddFrozenLiquidity:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string frozen-dptf:string input-amount:decimal)
        (UEV_IMC)
        (with-capability (SWPL|C>ADD_FROZEN-LQ swpair frozen-dptf)
            (let
                (
                    (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (ref-VST:module{VestingV3} VST)
                    (ref-SWP:module{SwapperV4} SWP)
                    (lp:string (ref-SWP::UR_TokenLP swpair))
                    (dptf:string (ref-DPTF::UR_Frozen frozen-dptf))
                    (ptp:integer (ref-SWP::UR_PoolTokenPosition swpair dptf))
                    (vst-sc:string (ref-DALOS::GOV|VST|SC_NAME))
                    (lq-lst:[decimal] (ref-U|SWP::UC_MakeLiquidityList swpair ptp input-amount))
                    (ico1:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-TFT::C_Transfer frozen-dptf account vst-sc input-amount true)
                    )
                    (ico2:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-DPTF::C_Burn frozen-dptf vst-sc input-amount)
                    )
                    (ico3:object{OuronetDalosV3.OutputCumulatorV2}
                        (C_AddLiquidity vst-sc swpair lq-lst)
                    )
                    (lp-amount:decimal (at 0 (at "output" ico3)))
                    (ico4:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-VST::C_Freeze vst-sc account lp lp-amount)
                    )
                )
                (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 [ico1 ico2 ico3 ico4] [lp-amount])
                ;;1]<account> sends <frozen-dptf> to <VST|SC_NAME>
                ;;via ico1
                ;;2]<VST|SC_NAME> burns it and releasing the base dptf, which can then be directly used to add liqudity
                ;;via ico2
                ;;3]<VST|SC_NAME> adds liquidity with the <dptf>, generating native LP
                ;;via ico3
                ;;4]<VST|SC_NAME> freezes resulted LP to target <account>
                ;;via ico4
            )
        )
    )
    (defun C_RemoveLiquidity:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string swpair:string lp-amount:decimal)
        (UEV_IMC)
        (with-capability (SWPL|C>RM_LQ swpair lp-amount)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (ref-SWP:module{SwapperV4} SWP)
                    (swp-sc:string (ref-DALOS::GOV|SWP|SC_NAME))
                    (pool-token-ids:[string] (ref-SWP::UR_PoolTokens swpair))
                    (lp-id:string (ref-SWP::UR_TokenLP swpair))
                    (pt-output-amounts:[decimal] (URC_LpBreakAmounts swpair lp-amount))
                    (pt-current-amounts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                    (pt-new-amounts:[decimal] (zip (-) pt-current-amounts pt-output-amounts))
                    (token-issue:decimal (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                    (price:decimal (* 2.0 token-issue))
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                    (ico0:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-DALOS::UDC_ConstructOutputCumulatorV2 price swp-sc trigger [])
                    )
                    (ico1:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-TFT::C_Transfer lp-id account swp-sc lp-amount true)
                    )
                    (ico2:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-DPTF::C_Burn lp-id swp-sc lp-amount)
                    )
                    (ico3:object{OuronetDalosV3.OutputCumulatorV2}
                        (ref-TFT::C_MultiTransfer pool-token-ids swp-sc account pt-output-amounts true)
                    )
                )
                (ref-SWP::XE_UpdateSupplies swpair pt-new-amounts)
                (XI_AutonomousSwapManagement swpair)
                (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 [ico0 ico1 ico2 ico3] pt-output-amounts)
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_AutonomousSwapManagement (swpair:string)
        (require-capability (SECURE))
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPI:module{SwapperIssue} SWPI)
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