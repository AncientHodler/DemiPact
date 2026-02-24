;;
;;  [1]      [U|CT]
;;
(interface OuronetConstantsV1
    @doc "Exported Constants as Functions from this Module via interface"
    ;;
    (defun CT_NS_USE ())
    (defun CT_GOV|UTILS ())
    ;;
    (defun CT_DPTF-FeeLock ())
    (defun CT_ATS-FeeLock ())
    ;;
    (defun CT_KDA_PRECISION ())
    (defun CT_MIN_PRECISION ())
    (defun CT_MAX_PRECISION ())
    (defun CT_FEE_PRECISION ())
    (defun CT_MIN_DESIGNATION_LENGTH ())
    (defun CT_MAX_TOKEN_NAME_LENGTH ())
    (defun CT_MAX_TOKEN_TICKER_LENGTH ())
    (defun CT_ACCOUNT_ID_PROH-CHAR ())
    (defun CT_ACCOUNT_ID_MAX_LENGTH ())
    (defun CT_BAR ())
    (defun CT_NUMBERS ())
    (defun CT_CAPITAL_LETTERS ())
    (defun CT_NON_CAPITAL_LETTERS ())
    (defun CT_SPECIAL ())
    ;;
    (defun CT_ET ())
    (defun CT_DEB ())
    ;;
    (defun CT_C1 ())
    (defun CT_C2 ())
    (defun CT_C3 ())
    (defun CT_C4 ())
    (defun CT_C5 ())
    (defun CT_C6 ())
    (defun CT_C7 ())
    ;;
    (defun CT_N00 ())
    (defun CT_N01 ())
    (defun CT_N11 ())
    (defun CT_N12 ())
    (defun CT_N13 ())
    (defun CT_N14 ())
    (defun CT_N15 ())
    (defun CT_N16 ())
    (defun CT_N17 ())
    ;;
    (defun CT_N21 ())
    (defun CT_N22 ())
    (defun CT_N23 ())
    (defun CT_N24 ())
    (defun CT_N25 ())
    (defun CT_N26 ())
    (defun CT_N27 ())
    ;;
    (defun CT_N31 ())
    (defun CT_N32 ())
    (defun CT_N33 ())
    (defun CT_N34 ())
    (defun CT_N35 ())
    (defun CT_N36 ())
    (defun CT_N37 ())
    ;;
    (defun CT_N41 ())
    (defun CT_N42 ())
    (defun CT_N43 ())
    (defun CT_N44 ())
    (defun CT_N45 ())
    (defun CT_N46 ())
    (defun CT_N47 ())
    ;;
    (defun CT_N51 ())
    (defun CT_N52 ())
    (defun CT_N53 ())
    (defun CT_N54 ())
    (defun CT_N55 ())
    (defun CT_N56 ())
    (defun CT_N57 ())
    ;;
    (defun CT_N61 ())
    (defun CT_N62 ())
    (defun CT_N63 ())
    (defun CT_N64 ())
    (defun CT_N65 ())
    (defun CT_N66 ())
    (defun CT_N67 ())
    ;;
    (defun CT_N71 ())
    (defun CT_N72 ())
    (defun CT_N73 ())
    (defun CT_N74 ())
    (defun CT_N75 ())
    (defun CT_N76 ())
    (defun CT_N77 ())
)
(interface DiaKdaPidV1
    @doc "Exposes the UR Function that Reads KDA Price in Dollars (KDA-PID) via Dia Oracle on Chain 2"
    ;;
    (defun UR|KDA-PID:decimal ())
)
;;
;;  [2]      [U|G]
;;
(interface OuronetGuardsV1
    @doc "Exported Functions from this Module via interface"
    ;;
    (defun UC_Try (g:guard))
    ;;
    (defun UEV_All:bool (guards:[guard]))
    (defun UEV_Any:bool (guards:[guard]))
    (defun UEV_GuardOfAll:guard (guards:[guard]))
    (defun UEV_GuardOfAny:guard (guards:[guard]))
)
;;
;;  [3]      [U|ST]
;;
(interface OuronetGasStationV1
    @doc "Exported Ouronet Gas Station Functions"
    ;;
    (defun UR_chain-gas-price ())
    (defun UR_chain-gas-limit ())
    ;;
    (defun URC_chain-gas-notional ())
    ;;
    (defun UEV_max-gas-notional:guard (gasNotional:decimal))
    (defun UEV_enforce-below-gas-notional (gasNotional:decimal))
    (defun UEV_enforce-below-or-at-gas-notional (gasNotional:decimal))
    (defun UEV_max-gas-price:guard (gasPrice:decimal))
    (defun UEV_enforce-below-gas-price:bool (gasPrice:decimal))
    (defun UEV_enforce-below-or-at-gas-price:bool (gasPrice:decimal))
    (defun UEV_max-gas-limit:guard (gasLimit:integer))
    (defun UEV_enforce-below-gas-limit:bool (gasLimit:integer))
    (defun UEV_enforce-below-or-at-gas-limit:bool (gasLimit:integer))
)
;;
;;  [4]      [U|RS]
;;
(interface ReservedAccountsV1
    @doc "Exported Reserved Account Functions"
    ;;
    (defun UEV_CheckReserved:string (account:string))
    (defun UEV_EnforceReserved:bool (account:string guard:guard))
)
;;
;;  [5]      [U|LST]
;;
(interface StringProcessorV1
    @doc "Exported List and String Processor Functions"
    ;;
    (defun UC_AppL:list (in:list item))
    (defun UC_Chain:list (in:list))
    (defun UC_FE (in:list))
    (defun UC_InsertFirst:list (in:list item))
    (defun UC_IsNotEmpty:bool (x:list))
    (defun UC_IzUnique (lst:[string]))
    (defun UC_LE (in:list))
    (defun UC_RemoveItem:list (in:list item))
    (defun UC_RemoveItemAt:list (in:list position:integer))
    (defun UC_ReplaceAt:list (in:list idx:integer item))
    (defun UC_ReplaceItem:list (in:list old-item new-item))
    (defun UC_Search:[integer] (searchee:list item))
    (defun UC_SecondListElement (in:list))
    (defun UC_SplitString:[string] (splitter:string splitee:string))
    ;;
    (defun UEV_NotEmpty:bool (x:list))
    (defun UEV_StringPresence (item:string item-lst:[string]))
)
;;
;;  [6]      [U|INT]
;;
(interface OuronetIntegersV1
    @doc "Exported Integer Functions"
    (defschema NonceSplitter
        negative-nonces:[integer]
        positive-nonces:[integer]
        negative-counterparts:[integer]
        positive-counterparts:[integer]
    )
    (defschema SplitIntegers
        negative:[integer]
        positive:[integer]
    )
    ;;
    (defun UC_MaxInteger:integer (lst:[integer]))
    (defun UC_SplitAuxiliaryIntegerList:object{SplitIntegers} (primary:[integer] auxiliary:[integer]))
    (defun UC_SplitIntegerList:object{SplitIntegers} (input:[integer]))
    (defun UC_NonceSplitter:object{NonceSplitter} (nonces:[integer] amounts:[integer]))
    ;;
    (defun UEV_ContainsAll:bool (l1:[integer] l2:[integer]))
    (defun UEV_PositionalVariable (integer-to-validate:integer positions:integer message:string))
    (defun UEV_UniformList (input:[integer]))
    ;;
    (defun UDC_SplitIntegers:object{SplitIntegers} (neg:[integer] pos:[integer]))
    (defun UDC_NonceSplitter:object{NonceSplitter} (a:[integer] b:[integer] c:[integer] d:[integer]))
)
;;
;;  [7]      [U|DEC]
;;
(interface OuronetDecimalsV1
    @doc "Exported Decimal Functions"
    ;;
    (defun UC_AddArray:[decimal] (array:[[decimal]]))
    (defun UC_AddHybridArray (lists)) ;;2
    (defun UC_Max (x y))
    (defun UC_Percent:decimal (x:decimal percent:decimal precision:integer)) ;;3
    (defun UC_Promille:decimal (x:decimal promille:decimal precision:integer)) ;;1
    (defun UC_UnlockPrice:[decimal] (unlocks:integer dptf-or-ats:bool)) ;;2
    ;;
    (defun UEV_DecimalArray (array:[[decimal]])) ;;1
)
;;
;;  [8]      [U|DALOS]
;;
(interface UtilityDalosV1
    @doc "Exported Utility Functions for the DALOS Module \
    \ \
    \ Added <UC_TenTwentyThirtyFourtySplit>"
    ;;
    (defun UC_TenTwentyThirtyFourtySplit:[decimal] (input:decimal ip:integer))
    (defun UC_DirectFilterId:[string] (listoflists:[[string]] account:string))
    (defun UC_InverseFilterId:[string] (listoflists:[[string]] account:string))
    (defun UC_ConcatWithBar:string (input:[string]))
    ;;
    (defun UC_GasCost (base-cost:decimal major:integer minor:integer native:bool))
    (defun UC_GasDiscount (major:integer minor:integer native:bool))
    (defun UC_IzCharacterANC:bool (c:string capital:bool iz-special:bool))
    (defun UC_IzStringANC:bool (s:string capital:bool iz-special:bool))
    (defun UC_NewRoleList (current-lst:[string] account:string direction:bool))
    ;;
    (defun UEV_Decimals:bool (decimals:integer))
    (defun UEV_Fee (fee:decimal))
    (defun UEV_NameOrTicker:bool (name-ticker:string name-or-ticker:bool iz-special:bool))
    ;;
    (defun UDC_Makeid:string (ticker:string))
    (defun UDC_MakeMVXNonce:string (nonce:integer))
)
(interface UtilityDalosGlyphs
    (defun GLYPH|UEV_DalosAccountCheck (account:string))
    (defun GLYPH|UEV_DalosAccount (account:string))
    (defun GLYPH|UEV_MsDc:bool (multi-s:string))
)
;;
;;  [9]      [U|ATS]
;;
(interface UtilityAtsV1
    @doc "Exported Utility Functions for the ATS and ATSU Modules"
    ;;
    (defschema Awo
        reward-tokens:[decimal]
        cull-time:time
    )
    ;;
    (defun UC_IzCullable:bool (input:object{Awo}))
    (defun UC_IzUnstakeObjectValid:bool (input:object{Awo}))
    (defun UC_MakeHardIntervals:[integer] (start:integer growth:integer))
    (defun UC_MakeSoftIntervals:[integer] (start:integer growth:integer))
    (defun UC_MultiReshapeUnstakeObject:[object{Awo}] (input:[object{Awo}] remove-position:integer))
    (defun UC_PromilleSplit:[decimal] (promille:decimal input:decimal input-precision:integer))
    (defun UC_ReshapeUnstakeObject:object{Awo} (input:object{Awo} remove-position:integer))
    (defun UC_SolidifyUnstakeObject:object{Awo} (input:object{Awo} remove-position:integer))
    (defun UC_SplitBalanceWithBooleans:[decimal] (precision:integer amount:decimal milestones:integer boolean:[bool]))
    (defun UC_SplitByIndexedRBT:[decimal] (rbt-amount:decimal pair-rbt-supply:decimal index:decimal resident-amounts:[decimal] rt-precisions:[integer]))
    (defun UC_UnlockPrice:[decimal] (unlocks:integer))
    ;;
    (defun UEV_AutostakeIndex (ats:string))
    (defun UEV_UniqueAtspair (ats:string))
        ;;
    (defun UEV_CRF|Positions (fee-positions:integer))
    (defun UEV_CRF|FeeThresholds (fee-thresholds:[decimal] c-rbt-prec:integer))
    (defun UEV_CRF|FeeArray (fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]]))
    (defun UEV_Fee (fee:decimal))
    (defun UEV_Decay (decay:integer))
    (defun UEV_HibernationFees (peak:decimal decay:decimal))
        ;;
    (defun UEV_ColdDurationParameters (soft-or-hard:bool base:integer growth:integer))
    ;;
    (defun UDC_Elite (x:decimal))
)
;;
;;  [10]     [U|DPTF]
;;
(interface UtilityDptfV1
    @doc "Exported Utility Functions for the DPTF Module \
        \ Commented Functions are internal use only and have no use outside the module"
    ;;
    (defschema DispoData
        @doc "Stores the information needed to compute the maximum Negative Ouro an Account is allowed to overconsume"
        elite-auryn-amount:decimal
        auryndex-value:decimal
        elite-auryndex-value:decimal
        major-tier:integer
        minor-tier:integer
        ouroboros-precision:integer
    )
    ;;
    (defun EmptyDispo:object{DispoData} ())
    ;;
    (defun UC_TwoSplitter:[integer] (input:integer))
    (defun UC_FourSplitter:[integer] (input:integer))
    (defun UC_EightSplitter:[integer] (input:integer))
    ;;
    (defun UC_OuroDispo:decimal (input:object{DispoData}))
    (defun UC_UnlockPrice:[decimal] (unlocks:integer))
    (defun UC_VolumetricTax (precision:integer amount:decimal))
)
;;
;;  [11]     [U|VST]
;;

(interface UtilityVstV1
    @doc "Exported Utility Functions for the VST Module"
    ;;
    (defun UC_MakeVestingDateList:[time] (offset:integer duration:integer milestones:integer))
    (defun UC_SplitBalanceForVesting:[decimal] (precision:integer amount:decimal milestones:integer))
    (defun UC_VestingID:[string] (dptf-name:string dptf-ticker:string))
    (defun UC_SleepingID:[string] (dptf-name:string dptf-ticker:string))
    (defun UC_HibernationID:[string] (dptf-name:string dptf-ticker:string))
        ;;
    (defun UC_FrozenID:[string] (dptf-name:string dptf-ticker:string))
    (defun UC_ReservedID:[string] (dptf-name:string dptf-ticker:string))
        ;;
    (defun UC_EquityID:[string] (sft-name:string sft-ticker:string))
    ;;
    (defun UEV_Milestone (milestones:integer))
    (defun UEV_MilestoneWithTime (offset:integer duration:integer milestones:integer upper-limit-in-seconds:integer))
)
;;
;;  [12]     [U|SWP]
;;
(interface UtilitySwpV1
    @doc "Exported Utility Functions for the SWP Module"
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
;;
;;  [13]     [U|BFS]
;;
(interface BreadthFirstSearchV1
    @doc "Interface exposing a Breadth-First-Search Implementation on Pact \
    \ Used in the SWP Modules to compute Paths between SWPair Tokens."
    ;;
    (defschema GraphNode
        node:string
        links:[string]
    )
    (defschema BFS
        visited:[string]
        que:[object{QE}]
        chains:[[string]]
    )
    (defschema QE
        node:string
        chain:[string]
    )
    ;;
    (defun UC_BFS:object{BFS} (graph:[object{GraphNode}] in:string))
)