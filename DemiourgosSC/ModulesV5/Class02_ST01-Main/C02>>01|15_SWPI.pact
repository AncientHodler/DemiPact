(module SWPI GOV
    ;;
    (implements OuronetPolicy)
    (implements SwapperIssue)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_SWPI           (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst SWP|SC_NAME           (GOV|SWP|SC_NAME))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|SWPI_ADMIN)))
    (defcap GOV|SWPI_ADMIN ()       (enforce-guard GOV|MD_SWPI))
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
    (defcap P|SWPI|CALLER ()
        true
    )
    (defcap P|SWPI|REMOTE-GOV ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|SWPI|CALLER))
        (compose-capability (SECURE))
    )
    (defcap P|DT ()
        (compose-capability (P|SWPI|REMOTE-GOV))
        (compose-capability (P|SWPI|CALLER))
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
        (with-capability (GOV|SWPI_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|SWPI_ADMIN)
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
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|ORBR:module{OuronetPolicy} OUROBOROS)
                (ref-P|SWP:module{OuronetPolicy} SWP)
                (ref-P|SWPT:module{OuronetPolicy} SWPT)
                (mg:guard (create-capability-guard (P|SWPI|CALLER)))
            )
            (ref-P|SWP::P|A_Add
                "SWPI|RemoteSwpGov"
                (create-capability-guard (P|SWPI|REMOTE-GOV))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|ORBR::P|A_AddIMP mg)
            (ref-P|SWP::P|A_AddIMP mg)
            (ref-P|SWPT::P|A_AddIMP mg)
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
    (defconst EMPTY_HOPPER
        [
            {
                "nodes" : [],
                "edges" : [],
                "output-values" : []
            }
        ]
    )
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
    (defcap SWPI|C>ISSUE (account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        @event
        (UEV_Issue account pool-tokens fee-lp weights amp p)
        (compose-capability (P|DT))
        (if p
            (compose-capability (GOV|SWPI_ADMIN))
            true
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_DeviationInValueShares:decimal (pool-reserves:[decimal] asymmetric-liq:[decimal] w:[decimal])
        @doc "Maximum Pool Deviation is (n-1)/n, and max allowed deviation for asymmetric liq is 40% of this value"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (l1:integer (length pool-reserves))
                (l2:integer (length asymmetric-liq))
                (l3:integer (length w))
                (iz-asymmetric:bool (contains 0.0 asymmetric-liq))
            )
            (ref-U|INT::UEV_UniformList [l1 l2 l3])
            (enforce iz-asymmetric "Invalid Values to Compute Deviation In Value Shares")
            (let
                (
                    (ref-U|VST:module{UtilityVst} U|VST)
                    (sw:decimal (fold (+) 0.0 w))
                    (iz-weigthed:bool (if (= sw 1.0) true false))
                    ;;
                    (initial-shares:[decimal] (UC_PoolShares pool-reserves w))
                    (asymmetric-shares:[decimal] (zip (*) initial-shares asymmetric-liq))
                    (new-total-shares:decimal (+ 5040000.0 (fold (+) 0.0 asymmetric-shares)))
                    (new-supply:[decimal] (zip (+) pool-reserves asymmetric-liq))
                    ;;
                    (aw:[decimal] (if iz-weigthed w (ref-U|VST::UC_SplitBalanceForVesting 24 1.0 l1)))
                    (deviated-shares:[decimal] (UC_DeviatedShares new-supply initial-shares new-total-shares))
                    (diff-with-deviated-shares:[decimal] (zip (-) aw deviated-shares))
                    (abs-dwds:[decimal]
                        (fold
                            (lambda
                                (acc:[decimal] idx:integer)
                                (ref-U|LST::UC_AppL acc (abs (at idx diff-with-deviated-shares )))
                            )
                            []
                            (enumerate 0 (- l1 1))
                        )
                    )
                    ;;Total Deviation must be divided by 2, to account for gain and losses in share variation
                    (total-deviation:decimal (floor (/ (fold (+) 0.0 abs-dwds) 2.0) 24))
                )
                total-deviation
            )
        )
    )
    (defun UC_DeviatedShares:[decimal] (pool-reserves:[decimal] pool-shares:[decimal] new-total-shares:decimal)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[decimal] idx:integer)
                    (ref-U|LST::UC_AppL acc
                        (floor (/ (* (at idx pool-reserves)(at idx pool-shares)) new-total-shares) 24)
                    )
                )
                []
                (enumerate 0 (- (length pool-reserves) 1))
            )
        )
    )
    (defun UC_PoolShares:[decimal] (pool-reserves:[decimal] w:[decimal])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (size:decimal (dec (length pool-reserves)))
                (sw:decimal (fold (+) 0.0 w))
                (iz-weigthed:bool (if (= sw 1.0) true false))
            )
            (fold
                (lambda
                    (acc:[decimal] idx:integer)
                    (let
                        (
                            (amount:decimal (at idx pool-reserves))
                            (position-share:decimal
                                (if iz-weigthed
                                    (* 5040000.0 (at idx w))
                                    (/ 5040000.0 size)
                                )
                            )
                            (amount-share:decimal
                                (floor (/ position-share amount) 24)
                            )
                        )
                        (ref-U|LST::UC_AppL acc amount-share)
                    )
                )
                []
                (enumerate 0 (- (length w) 1))
            )
        )
    )
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
                (input-positions:[integer] (UC_PoolTokenPositions swpair input-ids))
                (output-position:integer (at 0 (UC_PoolTokenPositions swpair [output-id])))
                ;;
                (swap-result:object{UtilitySwpV2.DirectTaxedSwapOutput}
                    (UC_BareboneSwapWithFeez account pool-type dsid F A X v-prec input-positions output-position W)
                )
                (tsoa:decimal (fold (+) 0.0 [(at "o-id-special" swap-result) (at "o-id-liquid" swap-result) (at "o-id-netto" swap-result)]))
                (tsoa-filled:[decimal] (URC_IndirectRefillAmounts X [output-position] [tsoa]))
                (remainder-filled:[decimal] (URC_IndirectRefillAmounts X [output-position] [(at "o-id-netto" swap-result)]))
                (input-amounts-filled:[decimal] (URC_IndirectRefillAmounts X input-positions input-amounts))
            )
            (ref-U|SWP::UDC_VirtualSwapEngine
                v-tokens v-prec account
                (zip (+) remainder-filled (zip (-) account-supply input-amounts-filled)) 
                swpair 
                (zip (-) (zip (+) X input-amounts-filled) remainder-filled)
                A W F
                (zip (+) fuel (at "lp-fuel" swap-result))
                (ref-U|LST::UC_ReplaceAt special output-position (+ (at output-position special) (at "o-id-special" swap-result)))
                (ref-U|LST::UC_ReplaceAt boost output-position (+ (at output-position boost) (at "o-id-liquid" swap-result)))
                (ref-U|LST::UC_AppL swaps dsid)
            )
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
                ;;
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
                (dsid-for-swap:object{UtilitySwpV2.DirectSwapInputData}
                    (ref-U|SWP::UDC_DirectSwapInputData input-ids input-amounts-for-swap output-id)
                )
                (drsi:object{UtilitySwpV2.DirectRawSwapInput}
                    (UDC_DirectRawSwapInput dsid-for-swap A X input-positions output-position weights)
                )
                (input-amounts-for-lp:[decimal] (zip (-) input-amounts input-amounts-for-swap))
                (input-amounts-for-lp-filled:[decimal] (URC_IndirectRefillAmounts X input-positions input-amounts-for-lp))
                ;;
                ;;Total-Swap-Output-Amount <tsoa> is computed without them, then splited into 3 parts: 
                ;;special, boost, remainder
                (tsoa:decimal (UC_BareboneSwap pool-type drsi))
                (special:decimal (floor (* (/ f2 fselp) tsoa) o-prec))
                (boost:decimal (floor (* (/ f3 fselp) tsoa) o-prec))
                (remainder:decimal (- tsoa (+ special boost)))
                (output:object{UtilitySwpV2.DirectTaxedSwapOutput}
                    (ref-U|SWP::UDC_DirectTaxedSwapOutput
                        input-amounts-for-lp-filled
                        output-id
                        special
                        boost
                        remainder
                    )
                )
            )
            output
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
                    (UDC_InverseRawSwapInput new-rsid A X output-position input-position weights)
                )
                ;;Now Compute the Input Amount needed to get the <tsoa>, the Partial-Input-Amount <pia>
                ;;<pia> is part of the TotalInputAmount, that would be used for a direct swap, after LP fees have been retained
                (pia:decimal (UC_BareboneInverseSwap pool-type irsi))
                ;;Now Compute the Total-Input-Amouant <tia>
                (tia:decimal (floor (/ (* 1000.0 pia) (- 1000.0 f1)) i-prec))
                (output:object{UtilitySwpV2.InverseTaxedSwapOutput}
                    (ref-U|SWP::UDC_InverseTaxedSwapOutput
                        boost
                        special
                        (URC_IndirectRefillAmounts X [input-position] [(- tia pia)])
                        input-id
                        tia
                    )
                )
            )
            output
        )
    )
    ;;
    (defun UC_BareboneSwap:decimal
        (pool-type:string drsi:object{UtilitySwpV2.DirectRawSwapInput})
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (l1:integer (length (at "input-amounts" drsi)))
            )
            (if (= pool-type "S")
                (enforce (= l1 1) "Only a single Input can be used in Stable Swap")
                true
            )
            (cond
                ((= pool-type "S") (ref-U|SWP::UC_ComputeY drsi))
                ((= pool-type "W") (ref-U|SWP::UC_ComputeWP drsi))
                ((= pool-type "P") (ref-U|SWP::UC_ComputeEP drsi))
                -1.0
            )
        )
    )
    (defun UC_BareboneInverseSwap:decimal 
        (pool-type:string irsi:object{UtilitySwpV2.InverseRawSwapInput})
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
            )
            (cond
                ((= pool-type "S") (ref-U|SWP::UC_ComputeInverseY irsi))
                ((= pool-type "W") (ref-U|SWP::UC_ComputeInverseWP irsi))
                ((= pool-type "P") (ref-U|SWP::UC_ComputeInverseEP irsi))
                -1.0
            )
        )
    )
    (defun UC_PoolTokenPositions:[integer] (swpair:string input-ids:[string])
        @doc "Same result as <URC_PoolTokenPositions> but being done without reading <swpair> data \
        \ Result is simply computed, through the <swpair> string"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWP:module{SwapperV4} SWP)
                (pool-tokens:[string] (ref-U|SWP::UC_TokensFromSwpairString swpair))
                (are-on-pool:bool (ref-SWP::UEV_CheckAgainst input-ids pool-tokens))
            )
            (enforce are-on-pool (format "Input Token IDs {} arent on pool {}" [input-ids swpair]))
            (fold
                (lambda
                    (acc:[integer] idx:integer)
                    (ref-U|LST::UC_AppL
                        acc
                        (ref-SWP::UC_PoolTokenPosition swpair (at idx input-ids))
                    )
                )
                []
                (enumerate 0 (- (length input-ids) 1))
            )
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun URC_EliteFeeReduction:object{UtilitySwpV2.SwapFeez} (account:string fees:object{UtilitySwpV2.SwapFeez})
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
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
    (defun URC_PoolTokenPositions:[integer] (swpair:string input-ids:[string])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-SWP:module{SwapperV4} SWP)
                (pool-tokens (ref-SWP::UR_PoolTokens swpair))
                (are-on-pool:bool (ref-SWP::UEV_CheckAgainst input-ids pool-tokens))
            )
            (enforce are-on-pool (format "Input Token IDs {} arent on pool {}" [input-ids swpair]))
            (fold
                (lambda
                    (acc:[integer] idx:integer)
                    (ref-U|LST::UC_AppL
                        acc
                        (ref-SWP::UR_PoolTokenPosition swpair (at idx input-ids))
                    )
                )
                []
                (enumerate 0 (- (length input-ids) 1))
            )
        )
    )
    ;;
    (defun URC_DirectRawSwapInput:object{UtilitySwpV2.DirectRawSwapInput}
        (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData})
        (let
            (
                ;;Unwrap Object Data
                (input-ids:[string] (at "input-ids" dsid))
                (input-amounts:[decimal] (at "input-amounts" dsid))
                (output-id:string (at "output-id" dsid))
                ;;
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
            )
            (ref-U|SWP::UDC_DirectRawSwapInput
                (ref-SWP::UR_Amplifier swpair)
                (ref-SWP::UR_PoolTokenSupplies swpair)
                input-amounts 
                (URC_PoolTokenPositions swpair input-ids)
                (ref-SWP::UR_PoolTokenPosition swpair output-id)
                (ref-DPTF::UR_Decimals output-id)
                (ref-SWP::UR_Weigths swpair)
            )
        )
    )
    (defun URC_InverseRawSwapInput:object{UtilitySwpV2.InverseRawSwapInput}
        (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData})
        (let
            (
                ;;Unwrap Object Data
                (output-id:string (at "output-id" rsid))
                (output-amount:decimal (at "output-amount" rsid))
                (input-id:string (at "input-id" rsid))
                ;;
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
            )
            (ref-U|SWP::UDC_InverseRawSwapInput
                (ref-SWP::UR_Amplifier swpair)
                (ref-SWP::UR_PoolTokenSupplies swpair)
                output-amount
                (ref-SWP::UR_PoolTokenPosition swpair output-id)
                (ref-SWP::UR_PoolTokenPosition swpair input-id)
                (ref-DPTF::UR_Decimals input-id)
                (ref-SWP::UR_Weigths swpair)
            )
        )
    )
    ;;
    (defun URC_Swap:decimal 
        (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} validation:bool)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (pool-type:string (ref-U|SWP::UC_PoolType swpair))
                (l1:integer (length (at "input-amounts" dsid)))
            )
            (if (= pool-type "S")
                (enforce (= l1 1) "Only a single Input can be used in Stable Swap")
                true
            )
            (if validation
                (UEV_SwapData swpair dsid)
                true
            )
            (cond
                ((= pool-type "S") (URC_S-Swap swpair dsid))
                ((= pool-type "W") (URC_W-Swap swpair dsid))
                ((= pool-type "P") (URC_P-Swap swpair dsid))
                -1.0
            )
        )
    )
    (defun URC_S-Swap:decimal (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData})
        @doc "Performs a Swap Computation in a Swable Pool. Data needed: \
            \ <A> = Pool Amplifier\
            \ <X> = Pool Token Supplies (must be read) \
            \ <input-amounts> = Amounts of the Input Tokens that make the swap. They must be in the same order as the <input-ids> \
            \ ip = Position of the input token (must be read) \
            \ op = position in the pool of the output token (must be read) \
            \ o-prec = precision of the output token (must be read) \
            \ w = weigths of the swpair"
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
            )
            (ref-U|SWP::UC_ComputeY
                (URC_DirectRawSwapInput swpair dsid)
            )
        )
    )
    (defun URC_W-Swap:decimal (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData})
        @doc "Performs a Swap Computation in a Weigthed Constant Product Pool. Data needed: \
            \ <X> = Pool Token Supplies (must be read) \
            \ <input-amounts> = Amounts of the Input Tokens that make the swap. They must be in the same order as the <input-ids> \
            \ ip = list with the pool position of the input tokens (must be read) \
            \ op = position in the pool of the output token (must be read) \
            \ o-prec = precision of the output token (must be read) \
            \ w = weigths of the swpair"
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
            )
            (ref-U|SWP::UC_ComputeWP
                (URC_DirectRawSwapInput swpair dsid)
            )
        )
    )
    (defun URC_P-Swap:decimal (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData})
        @doc "Performs a Swap Computation in a Constant Product Pool. Data needed: \
            \ <X> = Pool Token Supplies (must be read) \
            \ <input-amounts> = Amounts of the Input Tokens that make the swap. They must be in the same order as the <input-ids> \
            \ ip = list with the pool position of the input tokens (must be read) \
            \ op = position in the pool of the output token (must be read) \
            \ o-prec = precision of the output token (must be read)"
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
            )
            (ref-U|SWP::UC_ComputeEP
                (URC_DirectRawSwapInput swpair dsid)
            )
        )
    )
    (defun URC_InverseSwap:decimal
        (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData} validation:bool)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (pool-type:string (ref-U|SWP::UC_PoolType swpair))
            )
            (if validation
                (UEV_InverseSwapData swpair rsid)
                true
            )
            (cond
                ((= pool-type "S") (URC_S-InverseSwap swpair rsid))
                ((= pool-type "W") (URC_W-InverseSwap swpair rsid))
                ((= pool-type "P") (URC_P-InverseSwap swpair rsid))
                -1.0
            )
        )
    )
    (defun URC_S-InverseSwap:decimal (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData})
        @doc "Performs a Swap Computation in a Swable Pool. Data needed: \
            \ <A> = Pool Amplifier\
            \ <X> = Pool Token Supplies (must be read) \
            \ <output-amount> = How much output must be achieved by swaping the input amount that must be solved for \
            \ <op> = output position in the pool (must be read) \
            \ <ip> = input position in the pool (must be read) \
            \ <i-prec> = precision of the input token (must be read)"
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
            )
            (ref-U|SWP::UC_ComputeInverseY
                (URC_InverseRawSwapInput swpair rsid)
            )
        )
    )
    (defun URC_W-InverseSwap:decimal (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData})
        @doc "Inverse Swap solves how much of a given SINGLE input is needed to get a specific SINGLE output. Data needed: \
            \ <X> = Pool Token Supplies (must be read) \
            \ <output-amount> = How much output must be achieved by swaping the input amount that must be solved for \
            \ <op> = output position in the pool (must be read) \
            \ <ip> = input position in the pool (must be read) \
            \ <i-prec> = precision of the input token (must be read) \
            \ w = weigths of the swpair"
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
            )
            (ref-U|SWP::UC_ComputedInverseWP 
                (URC_InverseRawSwapInput swpair rsid)
            )
        )
    )
    (defun URC_P-InverseSwap (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData})
        @doc "Inverse Swap solves how much of a given SINGLE input is needed to get a specific SINGLE output. Data needed: \
            \ <X> = Pool Token Supplies (must be read) \
            \ <output-amount> = How much output must be achieved by swaping the input amount that must be solved for \
            \ <op> = output position in the pool (must be read) \
            \ <ip> = input position in the pool (must be read) \
            \ <i-prec> = precision of the input token (must be read)"
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
            )
            (ref-U|SWP::UC_ComputeInverseEP 
                (URC_InverseRawSwapInput swpair rsid)
            )
        )
    )
    ;;
    (defun URC_Hopper:object{SwapperIssue.Hopper}
        (hopper-input-id:string hopper-output-id:string hopper-input-amount:decimal)
        @doc "Creates a Hopper Object, by computing \
        \ 1] The trace between <hopper-input-id> and <hopper-output-id>, the <nodes> \
        \ 2] The hops between them, the <edges> as the cheapest available edge from all available \
        \ 3] The best <output> values using said best <edges>, given the <hopper-input-amount>"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWPT:module{SwapTracer} SWPT)
                (ref-SWP:module{SwapperV4} SWP)
                (swpairs:[string] (ref-SWP::URC_Swpairs))
                (principal-lst:[string] (ref-SWP::UR_Principals))
                (nodes:[string] (ref-SWPT::URC_ComputeGraphPath hopper-input-id hopper-output-id swpairs principal-lst))
            )
            (if (!= nodes [BAR])
                (let
                    (
                        (fl:[object{SwapperIssue.Hopper}]
                            (fold
                                (lambda
                                    (acc:[object{SwapperIssue.Hopper}] idx:integer)
                                    (ref-U|LST::UC_ReplaceAt
                                        acc
                                        0
                                        (let
                                            (
                                                (input:decimal
                                                    (if (= idx 0)
                                                        hopper-input-amount
                                                        (at 0 (take -1 (at "output-values" (at 0 acc))))
                                                    )
                                                )
                                                (i-id:string (at idx nodes))
                                                (o-id:string (at (+ idx 1) nodes))
                                                (best-edge:string (URC_BestEdge input i-id o-id))
                                                (dsid:object{UtilitySwpV2.DirectSwapInputData}
                                                    (ref-U|SWP::UDC_DirectSwapInputData [i-id] [input] o-id)
                                                )
                                                (output:decimal (URC_Swap best-edge dsid false))
                                            )
                                            (UDC_Hopper
                                                nodes
                                                (ref-U|LST::UC_AppL (at "edges" (at 0 acc)) best-edge)
                                                (ref-U|LST::UC_AppL (at "output-values" (at 0 acc)) output)
                                            )
                                        )
                                    )
                                )
                                EMPTY_HOPPER
                                (enumerate 0 (- (length nodes) 2))
                            )
                        )
                    )
                    (at 0 fl)
                )
                (at 0 EMPTY_HOPPER)
            )
        )
    )
    (defun URC_BestEdge:string (ia:decimal i:string o:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWPT:module{SwapTracer} SWPT)
                (ref-SWP:module{SwapperV4} SWP)
                (principals:[string] (ref-SWP::UR_Principals))
                (edges:[string] (ref-SWPT::URC_Edges i o principals))
                (svl:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (ref-U|LST::UC_AppL
                                acc
                                (URC_Swap (at idx edges) (ref-U|SWP::UDC_DirectSwapInputData [i] [ia] o) false)
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
    ;;Value Computations
    (defun URC_TokenDollarPrice (id:string kda-pid:decimal)
        @doc "Retrieves Token Price in Dollars, via DIA Oracle that outputs KDA Price"
        ;;<kda-pid> or <kda-price-in-dollars> can be retrieved prior to the function call with:
        ;;(at "value" (n_bfb76eab37bf8c84359d6552a1d96a309e030b71.dia-oracle.get-value "KDA/USD"))
        ;;This function is structured like this, to allow price retrieval from any source.
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (id-in-kda:decimal (URC_SingleWorthDWK id))
                (id-precision:integer (ref-DPTF::UR_Decimals id))
            )
            (floor (* id-in-kda kda-pid) id-precision)
        )
    )
    (defun URC_SingleWorthDWK (id:string)
        (URC_WorthDWK id 1.0)
    )
    (defun URC_WorthDWK (id:string amount:decimal)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (dwk:string (ref-DALOS::UR_WrappedKadenaID))
                (dlk:string (ref-DALOS::UR_LiquidKadenaID))
            )
            (if (= id dwk)
                amount
                (if (= id dlk)
                    (let
                        (
                            (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                            (ref-ATS:module{AutostakeV3} ATS)
                            (ats-pairs-with-dlk-id:[string] (ref-DPTF::UR_RewardBearingToken dlk))
                            (kdaliquindex:string (at 0 ats-pairs-with-dlk-id))
                            (index-value:decimal (ref-ATS::URC_Index kdaliquindex))
                            (dlk-prec:integer (ref-DPTF::UR_Decimals dlk))
                        )
                        (floor (* amount index-value) dlk-prec)
                    )
                    (let
                        (
                            (h-obj:object{SwapperIssue.Hopper} (URC_Hopper id dwk amount))
                            (ovs:[decimal] (at "output-values" h-obj))
                        )
                        (at 0 (take -1 ovs))
                    )
                )
            )
        )
    )
    (defun URC_PoolValue:[decimal] (swpair:string)
        @doc "Outputs the Pool Value in DWK. \
        \ If the Pool is empty, even though its value is technically zero, \
        \ The Value of the Genesis Initiation is outputed \
        \ PoolValue includes two decimal values: \
        \ 1st Value: Total Value of the Pool in DWK \
        \ 2nd Value: Value of 1 LP Token in DWK"
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
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
                (w:[decimal]
                    (if (= current-lp-supply 0.0)
                        (ref-SWP::UR_GenesisWeigths swpair)
                        (ref-SWP::UR_Weigths swpair)
                    )
                )
                ;;
                (pool-type:string (ref-U|SWP::UC_PoolType swpair))
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (how-many:integer (length pool-tokens))
                (lp-prec:integer (ref-DPTF::UR_Decimals (ref-SWP::UR_TokenLP swpair)))
                ;;
                (first-token:string (at 0 pool-tokens))
                (first-token-supply:decimal (at 0 pool-token-supplies))
                (first-token-precision:integer (ref-DPTF::UR_Decimals first-token))
                (first-weigth:decimal (at 0 w))
                (first-worth:decimal (URC_WorthDWK first-token first-token-supply))
                ;;
                (pool-worth:decimal
                    (if (or (= pool-type "S") (= pool-type "P"))
                        (floor (* (dec how-many) first-worth) first-token-precision)
                        (floor (/ first-worth first-weigth) first-token-precision)
                    )
                )
                (lp-worth:decimal
                    (floor (/ pool-worth lp-supply) lp-prec)
                )
            )
            [pool-worth lp-worth]
        )
    )
    (defun URC_DirectRefillAmounts:[decimal] (swpair:string ids:[string] amounts:[decimal])
        @doc "Refill incomplete amount values with zeros, to create an amount list equal to the <swpair> token number"
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
    (defun URC_TrimIdsWithZeroAmounts:[string] (swpair:string input-amounts:[decimal])
        @doc "From a complete list of input amounts, also containing zeroes, \
            \ creates a list of Pool Token IDs for the amounts greater than zero."
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
    ;;{F2}  [UEV]
    (defun UEV_SwapData 
        (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData})
        (let
            (
                ;;Unwrap Object Data
                (input-ids:[string] (at "input-ids" dsid))
                (input-amounts:[decimal] (at "input-amounts" dsid))
                (output-id:string (at "output-id" dsid))
                ;;
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-SWP:module{SwapperV4} SWP)
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (l1:integer (length input-ids))
                (l2:integer (length input-amounts))
                (l3:integer (length pool-tokens))
                (lengths:[integer] [l1 l2])
                (iz-on-pool:bool (ref-SWP::UEV_CheckAgainst input-ids pool-tokens))
                (t1:bool (contains output-id input-ids))
                (t2:bool (contains output-id pool-tokens))
            )
            (ref-U|INT::UEV_UniformList lengths)
            (enforce iz-on-pool "Input Tokens are not part of the pool")
            (enforce (not t1) "Output-ID cannot be within the Input-IDs")
            (enforce t2 "OutputID is not part of Swpair Tokens")
            (enforce (and (>= l2 1) (< l2 l3)) "Incorrect amount of swap Tokens")
        )
    )
    (defun UEV_InverseSwapData 
        (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData})
        (let
            (
                ;;Unwrap Object Data
                (output-id:string (at "output-id" rsid))
                (output-amount:decimal (at "output-amount" rsid))
                (input-id:string (at "input-id" rsid))
                ;;
                (ref-U|INT:module{OuronetIntegers} U|INT)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (t1:bool (contains input-id pool-tokens))
                (t2:bool (contains output-id pool-tokens))
            )
            (enforce (and t1 t2) "Invalid Pool Tokens")
            (ref-DPTF::UEV_Amount output-id output-amount)
        )
    )
    (defun UEV_Issue
        (account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-SWP:module{SwapperV4} SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (fee-precision:integer (ref-U|CT::CT_FEE_PRECISION))
                (principals:[string] (ref-SWP::UR_Principals))
                (l1:integer (length pool-tokens))
                (l2:integer (length weights))
                (ws:decimal (fold (+) 0.0 weights))
                (pt-ids:[string] (ref-SWP::UC_ExtractTokens pool-tokens))
                (ptte:[string]
                    (if (= amp -1.0)
                        (drop 1 pt-ids)
                        pt-ids
                    )
                )
                (first-pool-token:string (at 0 pt-ids))
                (iz-principal:bool (contains first-pool-token principals))
                (contains-principals:bool
                    (fold
                        (lambda
                            (acc:bool idx:integer)
                            (or
                                acc
                                (contains (at idx pt-ids) principals)
                            )
                        )
                        false
                        (enumerate 0 (- (length pt-ids) 1))
                    )
                )
            )
            ;;Functions
            (ref-SWP::UEV_PoolFee fee-lp)
            (ref-SWP::UEV_New pt-ids weights amp)
            ;;Mappings
            (map
                (lambda
                    (id:string)
                    (ref-DPTF::CAP_Owner id)
                )
                ptte
            )
            (map
                (lambda
                    (w:decimal)
                    (= (floor w fee-precision) w)
                )
                weights
            )

            ;;Enforcements
            (enforce (!= principals [BAR]) "Principals must be defined before a Swap Pair can be issued")
            (enforce (or (= amp -1.0) (>= amp 1.0)) "Invalid amp value")
            (enforce (and (>= l1 2) (<= l1 7)) "2 - 7 Tokens can be used to create a Swap Pair")
            (enforce (= l1 l2) "Number of weigths does not concide with the pool-tokens Number")
            (enforce-one
                "Invalid Weight Values"
                [
                    (enforce (= ws 1.0) "Weights must add to exactly 1.0")
                    (enforce (= ws (dec l1)) "Weights must all be 1.0")
                ]
            )
            ;;Ifs
            ;;On a W or P pool, first Pool Token must be a Principal Token
            (if (= amp -1.0)
                (enforce iz-principal "1st Token is not a Principal")
                true
            )
            ;;If a Stable Pool is to be created and none of its Tokens are Principal Tokens,
            ;;  its first Token must have a connection to DLK present via existing pools.
            (if (and (> amp 0.0) (not contains-principals))
                (let
                    (
                        (ref-DALOS:module{OuronetDalosV4} DALOS)
                        (dlk:string (ref-DALOS::UR_LiquidKadenaID))
                        (h-obj:object{SwapperIssue.Hopper} (URC_Hopper first-pool-token dlk 1.0))
                    )
                    (enforce
                        (!= h-obj (at 0 EMPTY_HOPPER))
                        (format "No connection to DLK detected for {}. Create a W or P Pool first with it!" [first-pool-token])
                    )
                )
                true
            )
            ;;If pool is not a principal pool, its initial liquidity must be worth at least <spawn-limit>
            (if (not p)
                (let
                    (
                        (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                        (pt-amounts:[decimal] (ref-SWP::UC_ExtractTokenSupplies pool-tokens))
                        (first-pool-token-amount:decimal (at 0 pt-amounts))
                        (prefix:string (ref-U|SWP::UC_Prefix weights amp))
                        (how-many:integer (length pool-tokens))
                        ;;
                        (first-worth:decimal (URC_WorthDWK first-pool-token first-pool-token-amount))
                        (pool-worth-with-input-tokens-in-dwk:decimal
                            (if (or (= prefix "S") (= prefix "P"))
                                (* (dec how-many) first-worth)
                                (/ first-worth (at 0 weights))
                            )
                        )
                        (spawn-limit:decimal (ref-SWP::UR_SpawnLimit))
                    )
                    (enforce (>= pool-worth-with-input-tokens-in-dwk spawn-limit) "More liquidity is needed to open a new pool!")
                )
                true
            )
            (format "Validation prior to pool creation executed succesfully {}" ["!"])
        )
    )
    ;;{F3}  [UDC]
    (defun UDC_DirectRawSwapInput:object{UtilitySwpV2.DirectRawSwapInput}
        (
            dsid:object{UtilitySwpV2.DirectSwapInputData}
            A:decimal X:[decimal] input-positions:[integer] output-position:integer weights:[decimal]
        )
        (let
            (
                ;;Unwrap Object Data
                (input-amounts:[decimal] (at "input-amounts" dsid))
                (output-id:string (at "output-id" dsid))
                ;;
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
            )
            (ref-U|SWP::UDC_DirectRawSwapInput
                A
                X
                input-amounts 
                input-positions
                output-position
                (ref-DPTF::UR_Decimals output-id)
                weights
            )
        )
    )
    (defun UDC_InverseRawSwapInput:object{UtilitySwpV2.InverseRawSwapInput}
        (
            rsid:object{UtilitySwpV2.ReverseSwapInputData}
            A:decimal X:[decimal] output-position:integer input-position:integer weights:[decimal]
        )
        (let
            (
                ;;Unwrap Object Data
                (output-amount:decimal (at "output-amount" rsid))
                (input-id:string (at "input-id" rsid))
                ;;
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
            )
            (ref-U|SWP::UDC_InverseRawSwapInput
                A
                X
                output-amount
                output-position
                input-position
                (ref-DPTF::UR_Decimals input-id)
                weights
            )
        )
    )
    (defun UDC_Hopper:object{SwapperIssue.Hopper} (a:[string] b:[string] c:[decimal])
        {"nodes"            : a
        ,"edges"            : b
        ,"output-values"    : c}
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_Issue:object{IgnisCollector.OutputCumulator}
        (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool)
        @doc "Issues a new SWPair (Liquidty Pool)"
        (UEV_IMC)
        (with-capability (SWPI|C>ISSUE account pool-tokens fee-lp weights amp p)
            (let
                (
                    (ref-IGNIS:module{IgnisCollector} DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-BRD:module{Branding} BRD)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                    (ref-TFT:module{TrueFungibleTransferV6} TFT)
                    (ref-SWPT:module{SwapTracer} SWPT)
                    (ref-SWP:module{SwapperV4} SWP)
                    ;;
                    (kda-dptf-cost:decimal (ref-DALOS::UR_UsagePrice "dptf"))
                    (kda-swp-cost:decimal (ref-DALOS::UR_UsagePrice "swp"))
                    (kda-costs:decimal (+ kda-dptf-cost kda-swp-cost))
                    (gas-swp-cost:decimal (ref-DALOS::UR_UsagePrice "ignis|swp-issue"))
                    (pool-token-ids:[string] (ref-SWP::UC_ExtractTokens pool-tokens))
                    (pool-token-amounts:[decimal] (ref-SWP::UC_ExtractTokenSupplies pool-tokens))
                    (lp-name-ticker:[string] (ref-SWP::URC_LpComposer pool-tokens weights amp))
                    (ico1:object{IgnisCollector.OutputCumulator}
                        (ref-DPTF::XE_IssueLP (at 0 lp-name-ticker) (at 1 lp-name-ticker))
                    )
                    (token-lp:string (at 0 (at "output" ico1)))
                    (swpair:string (ref-SWP::XE_Issue account pool-tokens token-lp fee-lp weights amp p))
                )
                (ref-BRD::XE_Issue swpair)
                (let
                    (
                        (trigger:bool (ref-IGNIS::IC|URC_IsVirtualGasZero))
                        (ico2:object{IgnisCollector.OutputCumulator}
                            (ref-TFT::C_MultiTransfer pool-token-ids account SWP|SC_NAME pool-token-amounts true)
                        )
                        (ico3:object{IgnisCollector.OutputCumulator}
                            (ref-DPTF::C_Mint token-lp SWP|SC_NAME 10000000.0 true)
                        )
                        (ico4:object{IgnisCollector.OutputCumulator}
                            (ref-TFT::C_Transfer token-lp SWP|SC_NAME account 10000000.0 true)
                        )
                        (ico5:object{IgnisCollector.OutputCumulator}
                            (ref-IGNIS::IC|UDC_ConstructOutputCumulator gas-swp-cost SWP|SC_NAME trigger [])
                        )
                    )
                    (ref-SWPT::XE_MultiPathTracer swpair (ref-SWP::UR_Principals))
                    (ref-DALOS::KDA|C_Collect patron kda-costs)
                    (ref-IGNIS::IC|UDC_ConcatenateOutputCumulators [ico1 ico2 ico3 ico4 ico5] [swpair token-lp])
                )
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)