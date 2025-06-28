(interface UtilitySwp
    @doc "Exported Utility Functions for the SWP Module"
    ;;
    (defun UC_BalancedLiquidity:[decimal] (ia:decimal ip:integer i-prec X:[decimal] Xp:[integer]))
    (defun UC_ComputeD:decimal (A:decimal X:[decimal]))
    (defun UC_ComputeWP (X:[decimal] input-amounts:[decimal] ip:[integer] op:integer o-prec w:[decimal]))
    (defun UC_ComputeY (A:decimal X:[decimal] input-amount:decimal ip:integer op:integer o-prec:integer))
    (defun UC_DNext (D:decimal A:decimal X:[decimal]))
    (defun UC_LP:decimal (input-amounts:[decimal] pts:[decimal] lps:decimal lpp:integer))
    (defun UC_LpID:[string] (token-names:[string] token-tickers:[string] weights:[decimal] amp:decimal))
    (defun UC_NewSupply:[decimal] (X:[decimal] input-amounts:[decimal] ip:[integer]))
    (defun UC_PoolID:string (token-ids:[string] weights:[decimal] amp:decimal))
    (defun UC_Prefix:string (weights:[decimal] amp:decimal))
    (defun UC_YNext (Y:decimal D:decimal A:decimal X:[decimal] op:integer))
    ;;
    (defun UC_AreOnPools:[bool] (id1:string id2:string swpairs:[string]))
    (defun UC_FilterOne:[string] (swpairs:[string] id:string))
    (defun UC_FilterTwo:[string] (swpairs:[string] id1:string id2:string))
    (defun UC_IzOnPool:bool (id:string swpair:string))
    (defun UC_IzOnPools:[bool] (id:string swpairs:[string]))
    (defun UC_MakeGraphNodes:[string] (input-id:string output-id:string swpairs:[string]))
    (defun UC_PoolTokensFromPairs:[[string]] (swpairs:[string]))
    (defun UC_SpecialFeeOutputs:[decimal] (sftp:[decimal] input-amount:decimal output-precision:integer))
    (defun UC_TokensFromSwpairString:[string] (swpair:string))
    (defun UC_UniqueTokens:[string] (swpairs:[string]))
    (defun UC_MakeLiquidityList (swpair:string ptp:integer amount:decimal))
)
(interface UtilitySwpV2
    @doc "Exported Utility Functions for the SWP Module \
    \ V2 adds Reverse Swap Computation Functions, and fixes Stable Swap math"
    ;;
    ;;Raw Swap INPUT Data - <drsi> and <irsi>
    ;;Data needed to perform the actual swap computation with no fees.
    (defschema DirectRawSwapInput
        A:decimal
        X:[decimal]
        input-amounts:[decimal]
        input-positions:[integer]
        output-position:integer
        output-precision:integer
        weights:[decimal]
    )
    (defschema InverseRawSwapInput
        A:decimal
        X:[decimal]
        output-amount:decimal
        output-position:integer
        input-position:integer
        input-precision:integer
        weights:[decimal]
    )
    ;;Swap INPUT Data - <dsid> and <rsid>
    (defschema DirectSwapInputData
        ;;Stores Input Data for a Direct Swap
        input-ids:[string]
        input-amounts:[decimal]
        output-id:string
    )
    (defschema ReverseSwapInputData
        ;;Stores Input Data fora Reverse Swap
        output-id:string
        output-amount:decimal
        input-id:string
    )
    ;;Swap OUTPUT Data - Always Taxed (with swap fees)
    (defschema DirectTaxedSwapOutput
        ;;Direct Taxed Swap starts from <Brutto Input-IDs Amounts>:[decimal] and yields in this order:
        lp-fuel:[decimal]           ;;<Input-IDs-Amounts> going fueling the Pool, in a full List, that is:
                                    ;;Contains 0.0 for Pool Token IDs not involved in the Input.
        o-id:string                 ;;Output-ID of the Direct-Swap
        o-id-special:decimal        ;;Output-ID-amount that goes to Special-Targets
        o-id-liquid:decimal         ;;Output-ID-amount that is used for Kadena Liquid Staking Boost
        o-id-netto:decimal          ;;Output-ID-amount resulted after the Direct Taxed Swap (END-RESULT)
    )
    (defschema InverseTaxedSwapOutput
        ;;Reverse Taxed Swap starts from <Netto Output-ID Amount>:decimal and yields
        o-id-liquid:decimal         ;;Output-ID-amount that would be used by Kadena Liquid Staking
        o-id-special:decimal        ;;Output-ID-amount that would go to Special-Targets
        lp-fuel:[decimal]           ;;Since the Inverse Swap can be computed for a single Input,
                                    ;;Contains the <Input-ID-Amount> of the Pool Token the Reverse Swap computes for
                                    ;;Therefore the List contains a single non zero element, 
                                    ;;filled with 0.0 for the rest of the Pool Tokens
        i-id:string                 ;;Input-ID of the Reverse Swap; It is also the id of the Single non Zero Value in <lp-fuel>
        i-id-brutto:decimal         ;;Input-ID-amount of the Token the Reverse Taxed Swap computed for (END-RESULT).
    )
    ;;
    (defschema SwapFeez
        lp:decimal
        special:decimal
        boost:decimal
    )
    ;;Virtual Swap Engine (VSE) Schema
    ;:The Virtual Swap Engine is used to perform Swap Computations on Data 
    ;;(that can be either true Swap Pool Data or Virtual Data), Performing always Direct Swaps, 
    ;;The Swaps being carried out are stored in the <swaps> field in an Object{VirtualSwap}
    ;;with their Input-Ids, Input-Amounts, and Output-ID;
    ;;As Supply, it always stores the "current" state of the virtual swap in the <account-supply> and <pool-supply>
    (defschema VirtualSwapEngine
        ;;Virtual Token IDs
        v-tokens:[string]           ;;Stores the Token IDs the VSE is operating with.
                                    ;;These are also the Pool Tokens, in this exact order
        v-prec:[integer]            ;;Decimal Precision of the Pool Tokens
        ;;
        ;;Virtual Account
        account:string              ;;The Account Performing the Virtual Swap (needed to fetch its Tier for Fee Reduction Purposes)
        account-supply:[decimal]    ;;The Virtual Token Supply of the Virtual Account. Gets updated with every Virtual Swap being executed
        ;;
        ;;Virtual Pool
        swpair:string               ;;While the VirtualSwapEngine doesnt operate on Swpair Data, storing the swpair ID is necesary
                                    ;;Because through it, the Pool Tokens can be known, and through them
                                    ;;the positions of the <input-ids>
        X:[decimal]                 ;;Token Supply of the Virtual Pool
        A:decimal                   ;;Amplifier supply of the Virtual Pool
        W:[decimal]                 ;;Weights of the Virtual Pool
        F:object{SwapFeez}          ;;Fee Values of the Virtual Pool
        ;;
        ;;Swap-Results - use <v-tokens> ID Order
        fuel:[decimal]              ;;Stores the Amounts that would go as Fuel for the Pool, boosting LP Token Value
        special:[decimal]           ;;Stores the Amounts that would go to the Pool Special Targets
        boost:[decimal]             ;;Stores the Amounts that would go to Kadena Liquid Staking Boost
        ;;
        ;;Virtual Swap Chains
        swaps:[object{DirectSwapInputData}] ;;Stores the Data of the Swaps in a Chain
    )
    ;;
    (defun UC_ComputeY (drsi:object{DirectRawSwapInput}))
    (defun UC_ComputeInverseY (irsi:object{InverseRawSwapInput}))
    (defun UC_YNext (Y:decimal A:decimal D:decimal n:decimal S-Prime:decimal P-Prime:decimal))
    (defun UC_ZNext (Y:decimal A:decimal D:decimal n:decimal S-Prime:decimal P-Prime:decimal))
    (defun UC_ComputeD:decimal (A:decimal X:[decimal]))
    (defun UC_DNext (D:decimal A:decimal X:[decimal]))
        ;;
    (defun UC_ComputeWP (drsi:object{DirectRawSwapInput}))
    (defun UC_ComputeInverseWP (irsi:object{InverseRawSwapInput}))
        ;;
    (defun UC_ComputeEP:decimal (drsi:object{DirectRawSwapInput}))
    (defun UC_ComputeInverseEP:decimal (irsi:object{InverseRawSwapInput}))
    ;;
    ;;
    (defun UC_BalancedLiquidity:[decimal] (ia:decimal ip:integer i-prec X:[decimal] Xp:[integer]))
    (defun UC_LP:decimal (input-amounts:[decimal] pts:[decimal] lps:decimal lpp:integer))
    (defun UC_LpID:[string] (token-names:[string] token-tickers:[string] weights:[decimal] amp:decimal))
    (defun UC_AddSupply:[decimal] (X:[decimal] input-amounts:[decimal] ip:[integer]))
    (defun UC_RemoveSupply:[decimal] (X:[decimal] output-amount:decimal op:integer))
    (defun UC_PoolID:string (token-ids:[string] weights:[decimal] amp:decimal))
    (defun UC_Prefix:string (weights:[decimal] amp:decimal))
    ;;
    (defun UC_AreOnPools:[bool] (id1:string id2:string swpairs:[string]))
    (defun UC_FilterOne:[string] (swpairs:[string] id:string))
    (defun UC_FilterTwo:[string] (swpairs:[string] id1:string id2:string))
    (defun UC_IzOnPool:bool (id:string swpair:string))
    (defun UC_IzOnPools:[bool] (id:string swpairs:[string]))
    (defun UC_MakeGraphNodes:[string] (input-id:string output-id:string swpairs:[string]))
    (defun UC_PoolTokensFromPairs:[[string]] (swpairs:[string]))
    (defun UC_SpecialFeeOutputs:[decimal] (sftp:[decimal] input-amount:decimal output-precision:integer))
    (defun UC_TokensFromSwpairString:[string] (swpair:string))
    (defun UC_UniqueTokens:[string] (swpairs:[string]))
    (defun UC_MakeLiquidityList (swpair:string ptp:integer amount:decimal))
    ;;
    ;;
    (defun UDC_DirectRawSwapInput:object{DirectRawSwapInput} (a:decimal b:[decimal] c:[decimal] d:[integer] e:integer f:integer g:[decimal]))
    (defun UDC_InverseRawSwapInput:object{InverseRawSwapInput} (a:decimal b:[decimal] c:decimal d:integer e:integer f:integer g:[decimal]))
    (defun UDC_DirectSwapInputData:object{DirectSwapInputData} (a:[string] b:[decimal] c:string))
    (defun UDC_ReverseSwapInputData:object{ReverseSwapInputData} (a:string b:decimal c:string))
    (defun UDC_DirectTaxedSwapOutput:object{DirectTaxedSwapOutput} (a:[decimal] b:string c:decimal d:decimal e:decimal))
    (defun UDC_InverseTaxedSwapOutput:object{InverseTaxedSwapOutput} (a:decimal b:decimal c:[decimal] d:string e:decimal))
    (defun UDC_SwapFeez:object{SwapFeez} (a:decimal b:decimal c:decimal))
    (defun UDC_VirtualSwapEngine:object{VirtualSwapEngine} (a:[string] b:[integer] c:string d:[decimal] e:string f:[decimal] g:decimal h:[decimal] i:object{SwapFeez} j:[decimal] k:[decimal] l:[decimal] m:[object{DirectSwapInputData}]))
)

(module U|SWP GOV
    ;;
    (implements UtilitySwpV2)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|U|SWP_ADMIN)))
    (defcap GOV|U|SWP_ADMIN ()
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (g:guard (ref-U|CT::CT_GOV|UTILS))
            )
            (enforce-guard g)
        )
    )
    ;;{G3}
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    ;;{P3}
    ;;{P4}
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
    ;;{C2}
    ;;{C3}
    ;;{C4}
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;S - Stable Pools Computation using Curve Finance original math.
    (defun UC_ComputeY 
        (drsi:object{UtilitySwpV2.DirectRawSwapInput})
        @doc "Computes <output-amount> of the Swap given the <input-amount>"
        (let
            (
                ;;Unwrap Object Data
                (A:decimal (at "A" drsi))
                (X:[decimal] (at "X" drsi))
                (input-amount:decimal (at 0 (at "input-amounts" drsi)))
                (ip:integer (at 0 (at "input-positions" drsi)))
                (op:integer (at "output-position" drsi))
                (o-prec:integer (at "output-precision" drsi))
                ;;
                (ref-U|LST:module{StringProcessor} U|LST)
                (prec:integer 24)
                (D:decimal (UC_ComputeD A X))
                (n:decimal (dec (length X)))
                (xo:decimal (at op X))
                (xi:decimal (at ip X))
                (xi-plus:decimal (+ xi input-amount))
                (X1:[decimal] (ref-U|LST::UC_ReplaceAt X ip xi-plus))
                (X2:[decimal] (ref-U|LST::UC_ReplaceAt X1 op -1.0))
                (X3:[decimal] (ref-U|LST::UC_RemoveItem X2 -1.0))
                (S-Prime:decimal (floor (fold (+) 0.0 X3) prec))
                (P-Prime:decimal (floor (fold (*) 1.0 X3) prec))
                ;;Y0 Initial Assumption
                ;;For best results <input-amount> < 0.9975 * xo
                (y0:decimal (- xo input-amount))
                (output-lst:[decimal]
                    (fold
                        (lambda
                            (y-values:[decimal] idx:integer)
                            (let
                                (
                                    (prev-y:decimal (at idx y-values))
                                    (y-value:decimal (UC_YNext prev-y A D n S-Prime P-Prime))
                                )
                                (ref-U|LST::UC_AppL y-values y-value)               
                            )
                        )
                        [y0]
                        (enumerate 0 10)
                    )
                )        
            )
            (- xo (floor (ref-U|LST::UC_LE output-lst) o-prec))
        )
    )
    (defun UC_ComputeInverseY
        (irsi:object{UtilitySwpV2.InverseRawSwapInput})
        @doc "Computes the <input-amount> for the Swap given the <output-amount>"
        (let        
            (
                ;;Unwrap Object Data
                (A:decimal (at "A" irsi))
                (X:[decimal] (at "X" irsi))
                (output-amount:decimal (at "output-amount" irsi))
                (op:integer (at "output-position" irsi))
                (ip:integer (at "input-position" irsi))
                (i-prec:integer (at "input-precision" irsi))
                ;;
                (ref-U|LST:module{StringProcessor} U|LST)
                (prec:integer 24)
                (D:decimal (UC_ComputeD A X))
                (n:decimal (dec (length X)))
                (xo:decimal (at op X))
                (xi:decimal (at ip X))
                (xo-minus:decimal (- xo output-amount))
                (X1:[decimal] (ref-U|LST::UC_ReplaceAt X op xo-minus))
                (X2:[decimal] (ref-U|LST::UC_ReplaceAt X1 ip -1.0))
                (X3:[decimal] (ref-U|LST::UC_RemoveItem X2 -1.0))
                (S-Prime:decimal (floor (fold (+) 0.0 X3) prec))
                (P-Prime:decimal (floor (fold (*) 1.0 X3) prec))
                ;;Y0 Initial Assumption
                ;;For best results <output-amount> < 0.9975 * xi
                (y0:decimal (+ xi output-amount))
                (output-lst:[decimal]
                    (fold
                        (lambda
                            (y-values:[decimal] idx:integer)
                            (let
                                (
                                    (prev-y:decimal (at idx y-values))
                                    (y-value:decimal (UC_ZNext prev-y A D n S-Prime P-Prime))
                                )
                                (ref-U|LST::UC_AppL y-values y-value)               
                            )
                        )
                        [y0]
                        (enumerate 0 10)
                    )
                )   
            )
            (- (floor (ref-U|LST::UC_LE output-lst) i-prec) xi)
        )
    )
    (defun UC_YNext (Y:decimal A:decimal D:decimal n:decimal S-Prime:decimal P-Prime:decimal)
        @doc "Swapping 100B for y amount of C >> Equation in a stable swap pool: \
            \ How much C do you get from swapping 100B ? \
            \ D-of-[A B C] = D-of-[A (B + 100) (C - y)] \
            \ Function solves for Y iteratively, where Y = (C - y) [y  = swap value] \
            \ \
            \ <input> = 100 ; <output> = ?? \
            \ \
            \ S-Prime = A + (B + 100) without (C - ??) \
            \ P-Prime = A * (B + 100) without (C - ??) \
            \ \
            \ c = (D^(n+1))/(n^n * Pp * A * n^n) \
            \ b = Sp + (D/(A * n^n)) \
            \ Numerator = Y^2 + c \
            \ Denominator = 2*Y + b - D \
            \ YNext = Numerator / Denominator"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (prec:integer 24)
                (n1:decimal (+ 1.0 n))
                (nn:decimal (^ n n))
                (c:decimal (floor (/ (^ D n1) (fold (*) 1.0 [nn P-Prime A nn])) prec))
                (b:decimal (floor (+ S-Prime (/ D (* A nn))) prec))
                (Ysq:decimal (^ Y 2.0))
                (numerator:decimal (floor (+ Ysq c) prec))
                (denominator:decimal (floor (- (+ (* Y 2.0) b) D) prec))
            )
            (floor (/ numerator denominator) prec)
        )
    )
    (defun UC_ZNext (Y:decimal A:decimal D:decimal n:decimal S-Prime:decimal P-Prime:decimal)
        @doc "Swapping ??B for 100C  >> Equation in a stable swap pool: \
            \ How much B do you need to swap to get 100C ? \
            \ D-of-[A B C] = D-of-[A (B + y) (C - 100)] \
            \ Function solves for Y iteratively, where Y = (B + y) [y  = swap value] \
            \ \
            \ <input> = ?? ; <output> = 100 \
            \ \
            \ S-Prime = A + (C - 100) without (B + ??) \
            \ P-Prime = A * (C - 100) without (B + ??) \
            \ \
            \ c = (D^(n+1))/(n^n * Pp * A * n^n) \
            \ b = Sp + (D/(A * n^n)) \
            \ Numerator = Y^2 + c \
            \ Denominator = 2*Y + b - D \
            \ YNext = Numerator / Denominator"
        (UC_YNext Y A D n S-Prime P-Prime)
    )
    (defun UC_ComputeD:decimal (A:decimal X:[decimal])
        @doc "Computes D Parameter given an amplifier <A> and a value of Pool Tokens \
        \ Uses <UC_DNext> for aproximation over 5 fixed iterations"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (output-lst:[decimal]
                    (fold
                        (lambda
                            (d-values:[decimal] idx:integer)
                            (let
                                (
                                    (prev-d:decimal (at idx d-values))
                                    (d-value:decimal (UC_DNext prev-d A X))
                                )
                                (ref-U|LST::UC_AppL d-values d-value)
                            )
                        )
                        [(fold (+) 0.0 X)]
                        (enumerate 0 5)
                    )
                )
            )
            (ref-U|LST::UC_LE output-lst)
        )
    )
    (defun UC_DNext (D:decimal A:decimal X:[decimal])
        @doc "Computes Dnext: \
        \ n = (length X) \
        \ S=x1+x2+x3+... \
        \ P=x1*x2*x3*... \
        \ Dp = (D^(n+1))/(P*n^n) \
        \ Numerator = (A*n^n*S + Dp*n)*D \
        \ Denominator = (A*n^n-1)*D + (n+1)*Dp \
        \ DNext = Numerator / Denominator"
        (let
            (
                (prec:integer 24)
                (n:decimal (dec (length X)))
                (S:decimal (fold (+) 0.0 X))
                (P:decimal (floor (fold (*) 1.0 X) prec))
                (n1:decimal (+ 1.0 n))
                (nn:decimal (^ n n))
                (Dp:decimal (floor (/ (^ D n1) (* nn P)) prec))
                ;;
                (v1:decimal (floor (fold (*) 1.0 [A nn S]) prec))
                (v2:decimal (* Dp n))
                (v3:decimal (+ v1 v2))
                (numerator:decimal (floor (* v3 D) prec))
                ;;
                (v4:decimal (- (* A nn) 1.0))
                (v5:decimal (* v4 D))
                (v6:decimal (floor (* n1 Dp) prec))
                (denominator:decimal (+ v5 v6))
            )
            (floor (/ numerator denominator) prec)
        )
    )
    ;;W - Weigthed Constant Product Pools Computations
    (defun UC_ComputeWP
        (drsi:object{UtilitySwpV2.DirectRawSwapInput})
        @doc "Swapping 100A for y amount of C >> Equation in a weighted constant product pool: \
            \ How much C do you get for swapping 100A ? \
            \ xA^wA * xB^wB * xC^wC * xD^wD = (xA + 100)^wA * xB^wB * (xC - y)^wC * xD^wD \
            \ This functions solves for y"
        (let
            (
                ;;Unwrap Object Data
                (X:[decimal] (at "X" drsi))
                (input-amounts:[decimal] (at "input-amounts" drsi))
                (ip:[integer] (at "input-positions" drsi))
                (op:integer (at "output-position" drsi))
                (o-prec:integer (at "output-precision" drsi))
                (w:[decimal] (at "weights" drsi))
                ;;
                (ref-U|LST:module{StringProcessor} U|LST)
                (raised:[decimal] (zip (lambda (x:decimal y:decimal) (floor (^ x y) 24)) X w))
                (pool-product:decimal (floor (fold (*) 1.0 raised) 24))
                (added-supplies:[decimal] (UC_AddSupply X input-amounts ip))
                (rm-output:[decimal] (ref-U|LST::UC_RemoveItemAt added-supplies op))
                (rw:[decimal] (ref-U|LST::UC_RemoveItemAt w op))
                (rm-output-raised:[decimal] (zip (lambda (x:decimal y:decimal) (^ x y)) rm-output rw))
                (rm-output-raised-multiplied:decimal (floor (fold (*) 1.0 rm-output-raised) 24))
                (ow:decimal (at op w))
                (inverse-ow:decimal (floor (/ 1.0 ow) 24))
                (output-missing-term-raised:decimal (floor (/ pool-product rm-output-raised-multiplied) 24))
                (output-missing-term:decimal (floor (^ output-missing-term-raised inverse-ow) o-prec))
            )
            (- (at op X) output-missing-term)
        )
    )
    (defun UC_ComputeInverseWP
        (irsi:object{UtilitySwpV2.InverseRawSwapInput})
        @doc "Swapping ??A for 100C >> Equation in a weighted constant product pool: \
            \ How much A do you need to swap to get 100C ?  \
            \ xA^wA * xB^wB * xC^wC * xD^wD = (xA + y)^wA * xB^wB * (xC - 100)^wC * xD^wD \
            \ This functions solves for y"
        (let
            (
                ;;Unwrap Object Data
                (X:[decimal] (at "X" irsi))
                (output-amount:decimal (at "output-amount" irsi))
                (op:integer (at "output-position" irsi))
                (ip:integer (at "input-position" irsi))
                (i-prec:integer (at "input-precision" irsi))
                (w:[decimal] (at "weights" irsi))
                ;;
                (ref-U|LST:module{StringProcessor} U|LST)
                (raised:[decimal] (zip (lambda (x:decimal y:decimal) (floor (^ x y) 24)) X w))
                (pool-product:decimal (floor (fold (*) 1.0 raised) 24))
                (removed-supplies:[decimal] (UC_RemoveSupply X output-amount op))
                (rm-input:[decimal] (ref-U|LST::UC_RemoveItemAt removed-supplies ip))
                (rw:[decimal] (ref-U|LST::UC_RemoveItemAt w ip))
                (rm-input-raised:[decimal] (zip (lambda (x:decimal y:decimal) (^ x y)) rm-input rw))
                (rm-input-raised-multiplied:decimal (floor (fold (*) 1.0 rm-input-raised) 24))
                (iw:decimal (at ip w))
                (inverse-iw:decimal (floor (/ 1.0 iw) 24))
                (input-missing-term-raised:decimal (floor (/ pool-product rm-input-raised-multiplied) 24))
                (input-missing-term:decimal (floor (^ input-missing-term-raised inverse-iw) i-prec))
            )
            (- input-missing-term (at ip X))
        )
    )
    ;;W - Equal Weight Constant Product Pools Computations
    (defun UC_ComputeEP:decimal 
        (drsi:object{UtilitySwpV2.DirectRawSwapInput})
        @doc "Swapping 100A for y amount of C >> Equation in an equal weight constant product pool: \
            \ xA * xB * xC * xD = (xA + 100) * xB * (xC - y) * xD \
            \ This Functions solves for y"
        (let
            (
                ;;Unwrap Object Data
                (X:[decimal] (at "X" drsi))
                (input-amounts:[decimal] (at "input-amounts" drsi))
                (ip:[integer] (at "input-positions" drsi))
                (op:integer (at "output-position" drsi))
                (o-prec:integer (at "output-precision" drsi))
                ;;
                (ref-U|LST:module{StringProcessor} U|LST)
                (pool-product:decimal (floor (fold (*) 1.0 X) 24))
                (added-supplies:[decimal] (UC_AddSupply X input-amounts ip))
                (rm-output:[decimal] (ref-U|LST::UC_RemoveItemAt added-supplies op))
                (rm-output-multiplied:decimal (floor (fold (*) 1.0 rm-output) 24))
                (output-missing-term:decimal (floor (/ pool-product rm-output-multiplied) o-prec))
            )
            (- (at op X) output-missing-term)
        )
    )
    (defun UC_ComputeInverseEP:decimal 
        (irsi:object{UtilitySwpV2.InverseRawSwapInput})
        @doc "How Much A is needed to get 100C >> Equation in an equal weight constant product pool: \
            \ xA * xB * xC * xD = (xA + y) * xB * (xC - 100) * xD \
            \ This function solves for Y"
        (let
            (
                ;;Unwrap Object Data
                (X:[decimal] (at "X" irsi))
                (output-amount:decimal (at "output-amount" irsi))
                (op:integer (at "output-position" irsi))
                (ip:integer (at "input-position" irsi))
                (i-prec:integer (at "input-precision" irsi))
                ;;
                (ref-U|LST:module{StringProcessor} U|LST)
                (pool-product:decimal (floor (fold (*) 1.0 X) 24))
                (removed-supplies:[decimal] (UC_RemoveSupply X output-amount op))
                (rm-input:[decimal] (ref-U|LST::UC_RemoveItemAt removed-supplies ip))
                (rm-input-multiplied:decimal (floor (fold (*) 1.0 rm-input) 24))
                (input-missing-term:decimal (floor (/ pool-product rm-input-multiplied) i-prec))
            )
            (- input-missing-term (at ip X))
        )
    )
    ;;LP Computations
    (defun UC_BalancedLiquidity:[decimal] (ia:decimal ip:integer i-prec X:[decimal] Xp:[integer])
        @doc "Computes Balanced Liquidity Amounts from input sources"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ratio:decimal (floor (/ ia (at ip X)) i-prec))
                (output:[decimal]
                    (fold
                        (lambda
                            (acc:[decimal] idx:integer)
                            (ref-U|LST::UC_AppL
                                acc
                                (if (= idx ip)
                                    ia
                                    (floor (* ratio (at idx X)) (at idx Xp))
                                )
                            )
                        )
                        []
                        (enumerate 0 (- (length X) 1))
                    )
                )
            )
            output
        )
    )
    (defun UC_LP:decimal (input-amounts:[decimal] pts:[decimal] lps:decimal lpp:integer)
        @doc "Computes the amount of LP that would result from <input-amounts> of tokens added to the pool, when \
            \ the pools has <pts> token supply, and the lp amounts is <lps> and the lp token has <lpp> precision \
            \ Must only be used when <input-amounts> are balanced, otherwise LP computation results in an inccorect value"
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (nz:[decimal] (ref-U|LST::UC_RemoveItem input-amounts 0.0))
                (fnz:decimal (at 0 nz))
                (fnzp:integer (at 0 (ref-U|LST::UC_Search input-amounts fnz)))
            )
            (floor (* (/ (at fnzp input-amounts) (at fnzp pts)) lps) lpp)
        )
    )
    (defun UC_LpID:[string] (token-names:[string] token-tickers:[string] weights:[decimal] amp:decimal)
        @doc "Creates a LP Id from input sources"
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|INT:module{OuronetIntegersV2} U|INT)
                (ref-U|LST:module{StringProcessor} U|LST)
                (prefix:string (UC_Prefix weights amp))
                (l1:integer (length token-names))
                (l2:integer (length token-tickers))
                (lengths:[integer] [l1 l2])
                (minus:string "-")
                (caron:string "^")
            )
            (ref-U|INT::UEV_UniformList lengths)
            (let
                (
                    (lp-name-elements:[string]
                        (fold
                            (lambda
                                (acc:[string] idx:integer)
                                (if (!= idx (- l1 1))
                                    (ref-U|LST::UC_AppL acc (+ (at idx token-names) caron))
                                    (ref-U|LST::UC_AppL acc (at idx token-names))
                                )
                            )
                            []
                            (enumerate 0 (- l1 1))
                        )
                    )
                    (lp-ticker-elements:[string]
                        (fold
                            (lambda
                                (acc:[string] idx:integer)
                                (if (!= idx (- l1 1))
                                    (ref-U|LST::UC_AppL acc (+ (at idx token-tickers) minus))
                                    (ref-U|LST::UC_AppL acc (at idx token-tickers))
                                )
                            )
                            []
                            (enumerate 0 (- l1 1))
                        )
                    )
                    (lp-name:string (concat [prefix BAR (concat lp-name-elements)]))
                    (lp-ticker:string (concat [prefix BAR (concat lp-ticker-elements) BAR "LP"]))
                )
                [lp-name lp-ticker]
            )
        )
    )
    (defun UC_AddSupply:[decimal] (X:[decimal] input-amounts:[decimal] ip:[integer])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[decimal] idx:integer)
                    (ref-U|LST::UC_AppL
                        acc
                        (+
                            (if (contains idx ip)
                                (at (at 0 (ref-U|LST::UC_Search ip idx)) input-amounts)
                                0.0
                            )
                            (at idx X)
                        )
                    )
                )
                []
                (enumerate 0 (- (length X) 1))
            )
        )
    )
    (defun UC_RemoveSupply:[decimal] (X:[decimal] output-amount:decimal op:integer)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[decimal] idx:integer)
                    (ref-U|LST::UC_AppL
                        acc
                        (-
                            (at idx X)
                            (if (= idx op)
                                output-amount
                                0.0
                            )
                        )
                    )
                )
                []
                (enumerate 0 (- (length X) 1))
            )
        )
    )
    (defun UC_PoolID:string (token-ids:[string] weights:[decimal] amp:decimal)
        @doc "Creates a Swap Pool Id from input sources"
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|LST:module{StringProcessor} U|LST)
                (prefix:string (UC_Prefix weights amp))
                (swpair-elements:[string]
                    (fold
                        (lambda
                            (acc:[string] idx:integer)
                            (if (!= idx (- (length token-ids) 1))
                                (ref-U|LST::UC_AppL acc (+ (at idx token-ids) BAR))
                                (ref-U|LST::UC_AppL acc (at idx token-ids))
                            )
                        )
                        []
                        (enumerate 0 (- (length token-ids) 1))
                    )
                )
            )
            (concat [prefix BAR (concat swpair-elements)])
        )
    )
    (defun UC_Prefix:string (weights:[decimal] amp:decimal)
        (let
            (
                (ws:decimal (fold (+) 0.0 weights))
            )
            (if (= amp -1.0)
                (if (= ws 1.0)
                    "W"
                    "P"
                )
                "S"
            )
        )
    )
    ;;
    (defun UC_AreOnPools:[bool] (id1:string id2:string swpairs:[string])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[bool] idx:integer)
                    (ref-U|LST::UC_AppL
                        acc
                        (let*
                            (
                                (pool-tokens:[string] (UC_TokensFromSwpairString (at idx swpairs)))
                                (iz-id1:bool (contains id1 pool-tokens))
                                (iz-id2:bool (contains id2 pool-tokens))
                            )
                            (and iz-id1 iz-id2)
                        )
                    )
                )
                []
                (enumerate 0 (- (length swpairs) 1))
            )
        )
    )
    (defun UC_FilterOne:[string] (swpairs:[string] id:string)
        (let*
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (l1:[bool] (UC_IzOnPools id swpairs))
                (l2:[string] (zip (lambda (s:string b:bool) (if b s BAR)) swpairs l1))
                (l3:[string] (ref-U|LST::UC_RemoveItem l2 BAR))
            )
            l3
        )
    )
    (defun UC_FilterTwo:[string] (swpairs:[string] id1:string id2:string)
        (let*
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (l1:[bool] (UC_AreOnPools id1 id2 swpairs))
                (l2:[string] (zip (lambda (s:string b:bool) (if b s BAR)) swpairs l1))
                (l3:[string] (ref-U|LST::UC_RemoveItem l2 BAR))
            )
            l3
        )
    )
    (defun UC_IzOnPool:bool (id:string swpair:string)
        (contains id (UC_TokensFromSwpairString swpair))
    )
    (defun UC_IzOnPools:[bool] (id:string swpairs:[string])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[bool] idx:integer)
                    (ref-U|LST::UC_AppL
                        acc
                        (UC_IzOnPool id (at idx swpairs))
                    )
                )
                []
                (enumerate 0 (- (length swpairs) 1))
            )
        )
    )
    (defun UC_MakeGraphNodes:[string] (input-id:string output-id:string swpairs:[string])
        @doc "Given an <input-id> and <output-id>, creates a list of ids: \
            \ Representing the nodes of the graph. \
            \ Uses 2 Steps: \
            \ \
            \ Step1 = Filter All Existing <swpairs>, to those containing <input-id> and <output-id> = select-swpairs\
            \ Step2 = Extract all Tokens from relevant pairs => these are the nodes = nodes \
            \ \
            \ Uses p2-p7 s2-s7 Swpair Information Data via passed down <swpairs>"
        (let*
            (
                (in:[string] (UC_FilterOne swpairs input-id))
                (out:[string] (UC_FilterOne swpairs output-id))
                (l0:[string] (+ in out))
                (select-swpairs:[string] (distinct l0))

                (non-distinct-nodes-array:[[string]] (UC_PoolTokensFromPairs select-swpairs))
                (non-distinct-nodes:[string] (fold (+) [] non-distinct-nodes-array))
            )
            (distinct non-distinct-nodes)
        )
    )
    (defun UC_PoolTokensFromPairs:[[string]] (swpairs:[string])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[[string]] idx:integer)
                    (ref-U|LST::UC_AppL
                        acc
                        (UC_TokensFromSwpairString (at idx swpairs))
                    )
                )
                []
                (enumerate 0 (- (length swpairs) 1))
            )
        )
    )
    (defun UC_SpecialFeeOutputs:[decimal] (sftp:[decimal] input-amount:decimal output-precision:integer)
        (if (= (length sftp) 1)
            [input-amount]
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (sftp-sum:decimal (fold (+) 0.0 sftp))
                    (sftp-wl:[decimal] (drop -1 sftp))
                    (ipl:[decimal]
                        (fold
                            (lambda
                                (acc:[decimal] idx:integer)
                                (ref-U|LST::UC_AppL
                                    acc
                                    (floor (* (/ (at idx sftp-wl) sftp-sum) input-amount) output-precision)
                                )
                            )
                            []
                            (enumerate 0 (- (length sftp-wl) 1))
                        )
                    )
                    (ipl-sum:decimal (fold (+) 0.0 ipl))
                    (last:decimal (- input-amount ipl-sum))
                )
                (ref-U|LST::UC_AppL ipl last)
            )
        )
    )
    (defun UC_TokensFromSwpairString:[string] (swpair:string)
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|LST:module{StringProcessor} U|LST)
                (bar:string (ref-U|CT::CT_BAR))
            )
            (drop 1 (ref-U|LST::UC_SplitString bar swpair))
        )
    )
    (defun UC_UniqueTokens:[string] (swpairs:[string])
        (distinct (fold (+) [] (UC_PoolTokensFromPairs swpairs)))
    )
    (defun UC_MakeLiquidityList (swpair:string ptp:integer amount:decimal)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (how-many-pts:integer (length (UC_TokensFromSwpairString swpair)))
                (zeroes:[decimal] (make-list how-many-pts 0.0))
            )
            (ref-U|LST::UC_ReplaceAt zeroes ptp amount)
        )
    )
    (defun UC_PoolType:string (swpair:string)
        (take 1 swpair)
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    (defun UDC_DirectRawSwapInput:object{UtilitySwpV2.DirectRawSwapInput}
        (a:decimal b:[decimal] c:[decimal] d:[integer] e:integer f:integer g:[decimal])
        {"A"                : a
        ,"X"                : b
        ,"input-amounts"    : c
        ,"input-positions"  : d
        ,"output-position"  : e
        ,"output-precision" : f
        ,"weights"          : g}
    )
    (defun UDC_InverseRawSwapInput:object{UtilitySwpV2.InverseRawSwapInput}
        (a:decimal b:[decimal] c:decimal d:integer e:integer f:integer g:[decimal])
        {"A"                : a
        ,"X"                : b
        ,"output-amount"    : c
        ,"output-position"  : d
        ,"input-position"   : e
        ,"input-precision"  : f
        ,"weights"          : g}
    )
    ;;
    (defun UDC_DirectSwapInputData:object{UtilitySwpV2.DirectSwapInputData}
        (a:[string] b:[decimal] c:string)
        {"input-ids"        : a
        ,"input-amounts"    : b
        ,"output-id"        : c}
    )
    (defun UDC_ReverseSwapInputData:object{UtilitySwpV2.ReverseSwapInputData}
        (a:string b:decimal c:string)
        {"output-id"        : a
        ,"output-amount"    : b
        ,"input-id"         : c}
    )
    ;;
    (defun UDC_DirectTaxedSwapOutput:object{UtilitySwpV2.DirectTaxedSwapOutput}
        (a:[decimal] b:string c:decimal d:decimal e:decimal)
        {"lp-fuel"          : a
        ,"o-id"             : b
        ,"o-id-special"     : c
        ,"o-id-liquid"      : d
        ,"o-id-netto"       : e}
    )
    (defun UDC_InverseTaxedSwapOutput:object{UtilitySwpV2.InverseTaxedSwapOutput}
        (a:decimal b:decimal c:[decimal] d:string e:decimal)
        {"o-id-liquid"      : a
        ,"o-id-special"     : b
        ,"lp-fuel"          : c
        ,"i-id"             : d
        ,"i-id-brutto"      : e}
    )
    (defun UDC_SwapFeez:object{UtilitySwpV2.SwapFeez}
        (a:decimal b:decimal c:decimal)
        {"lp"               : a
        ,"special"          : b
        ,"boost"            : c}
    )
    (defun UDC_VirtualSwapEngine:object{UtilitySwpV2.VirtualSwapEngine}
        (a:[string] b:[integer] c:string d:[decimal] e:string f:[decimal] g:decimal h:[decimal] i:object{UtilitySwpV2.SwapFeez} j:[decimal] k:[decimal] l:[decimal] m:[object{UtilitySwpV2.DirectSwapInputData}])
        {"v-tokens"         : a
        ,"v-prec"           : b
        ,"account"          : c
        ,"account-supply"   : d
        ,"swpair"           : e
        ,"X"                : f
        ,"A"                : g
        ,"W"                : h
        ,"F"                : i
        ,"fuel"             : j
        ,"special"          : k
        ,"boost"            : l
        ,"swaps"            : m}
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)