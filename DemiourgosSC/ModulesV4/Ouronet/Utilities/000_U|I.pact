
;;001_U|CT
(interface OuronetConstants
    (defun CT_NS_USE ()) ;;1
    (defun CT_GOV|UTILS ()) ;;12

    (defun CT_DPTF-FeeLock ()) ;;1
    (defun CT_ATS-FeeLock ()) ;;1

    (defun CT_KDA_PRECISION ()) ;;2
    (defun CT_MIN_PRECISION ()) ;;1
    (defun CT_MAX_PRECISION ()) ;;1
    (defun CT_FEE_PRECISION ()) ;;5
    (defun CT_MIN_DESIGNATION_LENGTH ()) ;;4
    (defun CT_MAX_TOKEN_NAME_LENGTH ()) ;;2
    (defun CT_MAX_TOKEN_TICKER_LENGTH ()) ;;2
    (defun CT_ACCOUNT_ID_PROH-CHAR ()) ;;1
    (defun CT_ACCOUNT_ID_MAX_LENGTH ()) ;;1
    (defun CT_BAR ()) ;;8
    (defun CT_NUMBERS ()) ;;1
    (defun CT_CAPITAL_LETTERS ()) ;;1
    (defun CT_NON_CAPITAL_LETTERS ()) ;;1
    (defun CT_SPECIAL ())

    (defun CT_ET ()) ;;1
    (defun CT_DEB ()) ;;1

    (defun CT_C1 ()) ;;1
    (defun CT_C2 ()) ;;1
    (defun CT_C3 ()) ;;1
    (defun CT_C4 ()) ;;1
    (defun CT_C5 ()) ;;1
    (defun CT_C6 ()) ;;1
    (defun CT_C7 ()) ;;1
    ;;
    (defun CT_N00 ()) ;;1
    (defun CT_N01 ()) ;;1
    (defun CT_N11 ()) ;;1
    (defun CT_N12 ()) ;;1
    (defun CT_N13 ()) ;;1
    (defun CT_N14 ()) ;;1
    (defun CT_N15 ()) ;;1
    (defun CT_N16 ()) ;;1
    (defun CT_N17 ()) ;;1
    ;;
    (defun CT_N21 ()) ;;1
    (defun CT_N22 ()) ;;1
    (defun CT_N23 ()) ;;1
    (defun CT_N24 ()) ;;1
    (defun CT_N25 ()) ;;1
    (defun CT_N26 ()) ;;1
    (defun CT_N27 ()) ;;1
    ;;
    (defun CT_N31 ()) ;;1
    (defun CT_N32 ()) ;;1
    (defun CT_N33 ()) ;;1
    (defun CT_N34 ()) ;;1
    (defun CT_N35 ()) ;;1
    (defun CT_N36 ()) ;;1
    (defun CT_N37 ()) ;;1
    ;;
    (defun CT_N41 ()) ;;1
    (defun CT_N42 ()) ;;1
    (defun CT_N43 ()) ;;1
    (defun CT_N44 ()) ;;1
    (defun CT_N45 ()) ;;1
    (defun CT_N46 ()) ;;1
    (defun CT_N47 ()) ;;1
    ;;
    (defun CT_N51 ()) ;;1
    (defun CT_N52 ()) ;;1
    (defun CT_N53 ()) ;;1
    (defun CT_N54 ()) ;;1
    (defun CT_N55 ()) ;;1
    (defun CT_N56 ()) ;;1
    (defun CT_N57 ()) ;;1
    ;;
    (defun CT_N61 ()) ;;1
    (defun CT_N62 ()) ;;1
    (defun CT_N63 ()) ;;1
    (defun CT_N64 ()) ;;1
    (defun CT_N65 ()) ;;1
    (defun CT_N66 ()) ;;1
    (defun CT_N67 ()) ;;1
    ;;
    (defun CT_N71 ()) ;;1
    (defun CT_N72 ()) ;;1
    (defun CT_N73 ()) ;;1
    (defun CT_N74 ()) ;;1
    (defun CT_N75 ()) ;;1
    (defun CT_N76 ()) ;;1
    (defun CT_N77 ()) ;;1
)

;;002_U|G
(interface OuronetGuards
    (defun UC_Try (g:guard))

    (defun UEV_GuardOfAll:guard (guards:[guard]))
    (defun UEV_All:bool (guards:[guard]))
    (defun UEV_GuardOfAny:guard (guards:[guard]))
    (defun UEV_Any:bool (guards:[guard])) ;;5
)

;;003_U|ST
(interface OuronetGasStation
    (defun UC_chain-gas-notional ())

    (defun UR_chain-gas-price ())
    (defun UR_chain-gas-limit ())

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

;;004_U|RS
(interface ReservedAccounts
    (defun UEV_EnforceReserved:bool (account:string guard:guard))
    (defun UEV_CheckReserved:string (account:string))
)

;;005_U|LST
(interface StringProcessor
    (defun UC_SplitString:[string] (splitter:string splitee:string)) ;;1
    (defun UC_Search:[integer] (searchee:list item)) ;;30
    (defun UC_KeepEndMatch:[string] (in:[string] match:string)) ;;1
    (defun UC_ReplaceItem:list (in:list old-item new-item)) ;;4
    (defun UC_ReplaceAt:list (in:list idx:integer item)) ;;7
    (defun UC_RemoveItem:list (in:list item)) ;;11
    (defun UC_RemoveItemAt:list (in:list position:integer)) ;;3
    (defun UC_IzUnique (lst:[string])) ;;5
    (defun UC_FE (in:list)) ;;1
    (defun UC_SecondListElement (in:list))
    (defun UC_LE (in:list)) ;;13
    (defun UC_InsertFirst:list (in:list item))
    (defun UC_AppL:list (in:list item)) ;;81
    (defun UC_IsNotEmpty:bool (x:list))
    (defun UC_Chain:list (in:list))

    (defun UEV_NotEmpty:bool (x:list))
    (defun UEV_StringPresence (item:string item-lst:[string])) ;;2
)

;;006_U|INT
(interface OuronetIntegers
    (defun UC_MaxInteger:integer (lst:[integer])) ;;2

    (defun UEV_PositionalVariable (integer-to-validate:integer positions:integer message:string)) ;;8
    (defun UEV_UniformList (input:[integer])) ;;5
    (defun UEV_ContainsAll (l1:[integer] l2:[integer])) ;;1
)

;;007_U|DEC
(interface OuronetDecimals
    (defun UC_Percent:decimal (x:decimal percent:decimal precision:integer)) ;;3
    (defun UC_Promille:decimal (x:decimal promille:decimal precision:integer)) ;;1
    (defun UC_Max (x y))
    (defun UC_AddArray:[decimal] (array:[[decimal]]))
    (defun UC_AddHybridArray (lists)) ;;2
    (defun UC_UnlockPrice:[decimal] (unlocks:integer dptf-or-ats:bool)) ;;2

    (defun UEV_DecimalArray (array:[[decimal]])) ;;1

)

;;008_U|DALOS
(interface UtilityDalos
    (defun UC_IzStringANC:bool (s:string capital:bool))
    (defun UC_IzCharacterANC:bool (c:string capital:bool))
    (defun UC_NewRoleList (current-lst:[string] account:string direction:bool)) ;;10
    (defun UC_FilterId:[string] (listoflists:[[string]] account:string)) ;;1
    (defun UC_GasCost (base-cost:decimal major:integer minor:integer native:bool)) ;;2
    (defun UC_GasDiscount (major:integer minor:integer native:bool))
    (defun UC_KadenaSplit:[decimal] (kadena-input-amount:decimal)) ;;1

    (defun UEV_NameOrTicker:bool (name-ticker:string name-or-ticker:bool iz-lp:bool)) ;;4
    (defun UEV_Decimals:bool (decimals:integer)) ;;3
    (defun UEV_Fee (fee:decimal)) ;;3
    (defun UEV_TokenName:bool (name:string))
    (defun UEV_TickerName:bool (ticker:string))

    (defun UDC_Makeid:string (ticker:string)) ;;4
    (defun UDC_MakeMVXNonce:string (nonce:integer))
)

;;009_U|ATS
(interface UtilityAts
    (defschema Awo
        reward-tokens:[decimal]
        cull-time:time
    )
    
    (defun UC_TripleAnd:bool (b1:bool b2:bool b3:bool))
    (defun UC_QuadAnd:bool (b1:bool b2:bool b3:bool b4:bool))
    (defun UC_UnlockPrice:[decimal] (unlocks:integer)) ;;2
    (defun UC_PromilleSplit:[decimal] (promille:decimal input:decimal input-precision:integer)) ;;3
    (defun UC_MakeSoftIntervals:[integer] (start:integer growth:integer)) ;;2
    (defun UC_MakeHardIntervals:[integer] (start:integer growth:integer)) ;;1
    (defun UC_SplitBalanceWithBooleans:[decimal] (precision:integer amount:decimal milestones:integer boolean:[bool])) ;;1
    (defun UC_SplitByIndexedRBT:[decimal] (rbt-amount:decimal pair-rbt-supply:decimal index:decimal resident-amounts:[decimal] rt-precisions:[integer])) ;;1
    (defun UC_IzCullable:bool (input:object{Awo})) ;;2
    (defun UC_ZeroColdFeeExceptionBoolean:bool (fee-thresholds:[decimal] fee-array:[[decimal]])) ;;2
    (defun UC_MultiReshapeUnstakeObject:[object{Awo}] (input:[object{Awo}] remove-position:integer)) ;;1
    (defun UC_ReshapeUnstakeObject:object{Awo} (input:object{Awo} remove-position:integer)) ;;7
    (defun UC_IzUnstakeObjectValid:bool (input:object{Awo}))
    (defun UC_SolidifyUnstakeObject:object{Awo} (input:object{Awo} remove-position:integer))

    (defun UEV_UniqueAtspair (ats:string)) ;;1
    (defun UEV_AutostakeIndex (ats:string))

    (defun UDC_Elite (x:decimal)) ;;2
)

;;010_U|DPTF
(interface UtilityDptf
    (defun UC_OuroLoanLimit (elite-auryn-amount:decimal dispo-data:[decimal] ouro-precision:integer))
    (defun UC_UnlockPrice:[decimal] (unlocks:integer)) ;;1
    (defun UC_VolumetricTax (precision:integer amount:decimal)) ;;1
    ;(defun UCX_VolumetricPermile:decimal (precision:integer unit:integer))
)

;;011_U|VST
(interface UtilityVst
    (defun UC_SplitBalanceForVesting:[decimal] (precision:integer amount:decimal milestones:integer)) ;;2
    (defun UC_MakeVestingDateList:[time] (offset:integer duration:integer milestones:integer)) ;;1
    (defun UC_VestingID:[string] (dptf-name:string dptf-ticker:string)) ;;1

    (defun UEV_Milestone (milestones:integer))
    (defun UEV_MilestoneWithTime (offset:integer duration:integer milestones:integer)) ;;1
)

;;012_U|SWP
(interface UtilitySwp
    (defun UC_ComputeWP (X:[decimal] input-amounts:[decimal] ip:[integer] op:integer o-prec w:[decimal]))
    (defun UC_NewSupply:[decimal] (X:[decimal] input-amounts:[decimal] ip:[integer]))
    (defun UC_ComputeY (A:decimal X:[decimal] input-amount:decimal ip:integer op:integer o-prec:integer))
    (defun UC_ComputeD:decimal (A:decimal X:[decimal])) ;;3
    (defun UC_DNext (D:decimal A:decimal X:[decimal]))
    (defun UC_YNext (Y:decimal D:decimal A:decimal X:[decimal] op:integer))
    (defun UC_Prefix:string (weights:[decimal] amp:decimal))
    (defun UC_LpID:[string] (token-names:[string] token-tickers:[string] weights:[decimal] amp:decimal)) ;;1
    (defun UC_PoolID:string (token-ids:[string] weights:[decimal] amp:decimal)) ;;3
    (defun UC_BalancedLiquidity:[decimal] (ia:decimal ip:integer i-prec X:[decimal] Xp:[integer])) ;;1
    (defun UC_LP:decimal (input-amounts:[decimal] pts:[decimal] lps:decimal lpp:integer)) ;;2
    (defun UC_TokensFromSwpairString:[string] (swpair:string)) ;;1
)

;;013_U|BFS
(interface BreadthFirstSearch
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

    (defun UC_BFS:object{BFS} (graph:[object{GraphNode}] in:string))
    ;(defun UC_GraphNodeLinks:[string] (graph:[object{U|SCH.GraphNode}] node:string))
    ;(defun UC_GraphNodes:[string] (graph:[object{U|SCH.GraphNode}]))
    ;(defun UC_PrimalQE:[object{U|SCH.QE}] (links:[string] node:string))
    ;(defun UC_GetChains:[[string]] (input:[object{U|SCH.QE}]))
    ;(defun UC_FilterVisited:[string] (visited:[string] new-nodes:[string]))
    ;(defun UC_ExStrLst:[string] (to-extend:[string] elements:[string]))
    ;(defun UC_ExQeLst:[object{U|SCH.QE}] (input:[object{U|SCH.QE}] que-element:[object{U|SCH.QE}]))
    ;(defun UC_RmFirstQeList:[object{U|SCH.QE}] (input:[object{U|SCH.QE}]))
    ;(defun UC_ExStrArrLst:[[string]] (to-extend:[[string]] elements:[[string]]))

    ;(defun UDC_ExtendChain:object{U|SCH.QE} (input:object{U|SCH.QE} element:string))
    ;(defun UDC_AddVisited:object{U|SCH.BFS} (input:object{U|SCH.BFS} visited:[string]))
    ;(defun UDC_AddToQue:object{U|SCH.BFS} (input:object{U|SCH.BFS} que:[object{U|SCH.QE}]))
    ;(defun UDC_RmFromQue:object{U|SCH.BFS} (input:object{U|SCH.BFS}))
    ;(defun UDC_AddChains:object{U|SCH.BFS} (input:object{U|SCH.BFS} chains-to-add:[[string]]))
)

;;000_Policy
(interface OuronetPolicy
    (defschema P|S
        policy:guard
    )
    (defun P|UR:guard (policy-name:string))
    (defun P|A_Add (policy-name:string policy-guard:guard)) ;;14
)

;;001_DALOS
(interface OuronetDalos
    (defschema DPTF|BalanceSchema
        @doc "Schema that Stores Account Balances for DPTF Tokens (True Fungibles)\
            \ Key for the Table is a string composed of: <DPTF id> + BAR + <account> \
            \ This ensure a single entry per DPTF id per account. \
            \ As an Exception OUROBOROS and IGNIS Account Data is Stored at the DALOS Account Level"
        balance:decimal
        role-burn:bool
        role-mint:bool
        role-transfer:bool
        role-fee-exemption:bool
        frozen:bool
    )
    ;;
    (defun GOV|Demiurgoi ()) ;;4
    (defun GOV|DalosKey ())
    (defun GOV|AutostakeKey ()) ;;2
    (defun GOV|VestingKey ()) ;;1
    (defun GOV|LiquidKey ()) ;;1
    (defun GOV|OuroborosKey ()) ;;1
    (defun GOV|SwapKey ()) ;;1
    ;;
    (defun GOV|DALOS|SC_KDA-NAME ())
    (defun GOV|DALOS|SC_NAME ()) ;;4
    (defun GOV|ATS|SC_NAME ()) ;;12
    (defun GOV|VST|SC_NAME ())
    (defun GOV|LIQUID|SC_NAME ())
    (defun GOV|OUROBOROS|SC_NAME ()) ;;4
    ;;
    (defun GOV|DALOS|PBL ())
    (defun GOV|ATS|PBL ())
    (defun GOV|VST|PBL ())
    (defun GOV|LIQUID|PBL ())
    (defun GOV|OUROBOROS|PBL ())
    (defun GOV|SWP|PBL ())
    ;;
    ;;
    (defun UR_KadenaLedger:[string] (kadena:string))
    (defun UR_DemiurgoiID:[string] ())
    (defun UR_UnityID:string ()) ;;2
    (defun UR_OuroborosID:string ()) ;;19
    (defun UR_OuroborosPrice:decimal ()) ;;2
    (defun UR_IgnisID:string ()) ;6
    (defun UR_AurynID:string ())
    (defun UR_EliteAurynID:string ()) ;;5
    (defun UR_WrappedKadenaID:string ()) ;;4
    (defun UR_LiquidKadenaID:string ()) ;;1
    (defun UR_Tanker:string ())
    (defun UR_VirtualToggle:bool ())
    (defun UR_VirtualSpent:decimal ())
    (defun UR_NativeToggle:bool ())
    (defun UR_NativeSpent:decimal ())
    (defun UR_UsagePrice:decimal (action:string)) ;;73
    (defun UR_AccountPublicKey:string (account:string))
    (defun UR_AccountGuard:guard (account:string)) ;;3
    (defun UR_AccountKadena:string (account:string)) ;;3
    (defun UR_AccountSovereign:string (account:string)) ;;1
    (defun UR_AccountGovernor:guard (account:string)) ;;1
    (defun UR_AccountProperties:[bool] (account:string))
    (defun UR_AccountType:bool (account:string)) ;;2
    (defun UR_AccountPayableAs:bool (account:string))
    (defun UR_AccountPayableBy:bool (account:string))
    (defun UR_AccountPayableByMethod:bool (account:string))
    (defun UR_AccountNonce:integer (account:string))
    (defun UR_Elite (account:string))
    (defun UR_Elite-Class (account:string))
    (defun UR_Elite-Name (account:string))
    (defun UR_Elite-Tier (account:string))
    (defun UR_Elite-Tier-Major:integer (account:string)) ;;4
    (defun UR_Elite-Tier-Minor:integer (account:string)) ;;1
    (defun UR_Elite-DEB (account:string))
    ;(defun UR_TrueFungible:object{DPTF|BalanceSchema} (account:string snake-or-gas:bool))
    (defun UR_TF_AccountSupply:decimal (account:string snake-or-gas:bool)) ;;4
    (defun UR_TF_AccountRoleBurn:bool (account:string snake-or-gas:bool)) ;;2
    (defun UR_TF_AccountRoleMint:bool (account:string snake-or-gas:bool)) ;;2
    (defun UR_TF_AccountRoleTransfer:bool (account:string snake-or-gas:bool)) ;;2
    (defun UR_TF_AccountRoleFeeExemption:bool (account:string snake-or-gas:bool)) ;;2
    (defun UR_TF_AccountFreezeState:bool (account:string snake-or-gas:bool)) ;;2

    (defun URC_Transferability:bool (sender:string receiver:string method:bool))
    (defun IGNIS|URC_Exception (account:string))
    (defun IGNIS|URC_ZeroGAZ:bool (id:string sender:string receiver:string)) ;;2
    (defun IGNIS|URC_ZeroGAS:bool (id:string sender:string)) ;;8
    (defun IGNIS|URC_IsVirtualGasZeroAbsolutely:bool (id:string))
    (defun IGNIS|URC_IsVirtualGasZero:bool ())
    (defun IGNIS|URC_IsNativeGasZero:bool ())

    (defun UEV_StandardAccOwn (account:string))
    (defun UEV_SmartAccOwn (account:string))
    (defun UEV_Methodic (account:string method:bool))
    (defun UEV_EnforceAccountExists (dalos-account:string)) ;;11
    (defun UEV_EnforceAccountType (account:string smart:bool)) ;;8
    (defun UEV_EnforceTransferability (sender:string receiver:string method:bool)) ;;2
    (defun UEV_SenderWithReceiver (sender:string receiver:string)) ;;5
    (defun UEV_TwentyFourPrecision (amount:decimal))
    (defun GLYPH|UEV_DalosAccountCheck (account:string)) ;;1
    (defun GLYPH|UEV_DalosAccount (account:string)) ;;1
    (defun GLYPH|UEV_MsDc:bool (multi-s:string))
    (defun IGNIS|UEV_VirtualState (state:bool))
    (defun IGNIS|UEV_VirtualOnCondition ())
    (defun IGNIS|UEV_NativeState (state:bool))
    (defun IGNIS|UEV_Patron (patron:string))

    (defun CAP_EnforceAccountOwnership (account:string)) ;;20

    (defun A_UpdateUsagePrice (action:string new-price:decimal))
    (defun A_UpdatePublicKey (account:string new-public:string))
    (defun A_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun A_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun IGNIS|A_Toggle (native:bool toggle:bool))
    (defun IGNIS|A_SetSourcePrice (price:decimal))

    (defun C_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun C_RotateGuard (patron:string account:string new-guard:guard safe:bool))
    (defun C_RotateKadena (patron:string account:string kadena:string))
    (defun C_RotateSovereign (patron:string account:string new-sovereign:string))
    (defun C_RotateGovernor (patron:string account:string governor:guard)) ;;4
    (defun C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool))
    (defun C_TransferDalosFuel (sender:string receiver:string amount:decimal)) ;;2
    (defun IGNIS|C_Collect (patron:string active-account:string amount:decimal)) ;;61
    (defun IGNIS|C_CollectWT (patron:string active-account:string amount:decimal trigger:bool)) ;;11
    (defun KDA|C_Collect (sender:string amount:decimal)) ;;7
    (defun KDA|C_CollectWT (sender:string amount:decimal trigger:bool)) ;;1

    ;(defun X_UpdateKadenaLedger (kadena:string dalos:string direction:bool))
    ;(defun X_RotateGuard (account:string new-guard:guard safe:bool))
    ;(defun X_RotateKadena (account:string kadena:string))
    ;(defun X_RotateSovereign (account:string new-sovereign:string))
    ;(defun X_RotateGovernor (account:string governor:guard))
    ;(defun X_UpdateSmartAccountParameters (account:string pasc:bool pbsc:bool pbm:bool))
    (defun X_UpdateElite (account:string amount:decimal)) ;;4
    ;(defun X_UpdateTF (account:string snake-or-gas:bool new-obj:object{DPTF|BalanceSchema}))
    (defun X_UpdateBalance (account:string snake-or-gas:bool new-balance:decimal)) ;;2
    (defun X_UpdateBurnRole (account:string snake-or-gas:bool new-burn:bool)) ;;1
    (defun X_UpdateMintRole (account:string snake-or-gas:bool new-mint:bool)) ;;1
    (defun X_UpdateTransferRole (account:string snake-or-gas:bool new-transfer:bool)) ;;1
    (defun X_UpdateFeeExemptionRole (account:string snake-or-gas:bool new-fee-exemption:bool)) ;;1
    (defun X_UpdateFreeze (account:string snake-or-gas:bool new-freeze:bool)) ;;1
    ;(defun IGNIS|X_Collect (patron:string active-account:string amount:decimal))
    ;(defun IGNIS|X_CollectST (patron:string amount:decimal))
    ;(defun IGNIS|X_CollectSM (patron:string active-account:string amount:decimal))
    ;(defun IGNIS|X_Transfer (sender:string receiver:string ta:decimal))
    ;(defun IGNIS|X_Debit (sender:string ta:decimal))
    ;(defun IGNIS|X_Credit (receiver:string ta:decimal))
    ;(defun IGNIS|X_Increment (native:bool increment:decimal))
    ;(defun IGNIS|X_Toggle (native:bool toggle:bool))
    ;(defun IGNIS|X_UpOuroPr (price:decimal))
)

(interface Branding
    (defschema Schema
        logo:string
        description:string
        website:string
        social:[object{SocialSchema}]
        flag:integer
        genesis:time
        premium-until:time
    )
    (defschema SocialSchema
        social-media-name:string
        social-media-link:string
    )

    (defun UR_Branding:object{Schema} (id:string pending:bool))
    (defun UR_Logo:string (id:string pending:bool))
    (defun UR_Description:string (id:string pending:bool))
    (defun UR_Website:string (id:string pending:bool))
    (defun UR_Social:[object{SocialSchema}] (id:string pending:bool))
    (defun UR_Flag:integer (id:string pending:bool))
    (defun UR_Genesis:time (id:string pending:bool))
    (defun UR_PremiumUntil:time (id:string pending:bool))

    (defun URC_MaxBluePayment (account:string))

    (defun UEV_SpecificPolicy (match:string))

    (defun UDC_BrandingLogo:object{Schema} (input:object{Schema} logo:string))
    (defun UDC_BrandingDescription:object{Schema} (input:object{Schema} description:string))
    (defun UDC_BrandingWebsite:object{Schema} (input:object{Schema} website:string))
    (defun UDC_BrandingSocial:object{Schema} (input:object{Schema} social:[object{SocialSchema}]))
    (defun UDC_BrandingFlag:object{Schema} (input:object{Schema} flag:integer))
    (defun UDC_BrandingPremium:object{Schema} (input:object{Schema} premium:time))

    (defun A_SetFlag (entity-id:string flag:integer))

    (defun X_Issue (entity-id:string))
    ;(defun X_UpdateBrandingData (entity-id:string pending:bool branding:object{Schema}))
    (defun X_UpdatePendingBranding (entity-id:string logo:string description:string website:string social:[object{SocialSchema}]))
    (defun X_UpgradeBranding:decimal (entity-id:string entity-owner-account:string months:integer))

)

(interface DemiourgosPactTrueFungible
    (defun UR_P-KEYS:[string] ()) ;;1
    (defun UR_KEYS:[string] ()) ;;1

    (defun UR_Konto:string (id:string)) ;;3
    (defun UR_Name:string (id:string)) ;;2
    (defun UR_Ticker:string (id:string)) ;;2
    (defun UR_Decimals:integer (id:string)) ;;15
    (defun UR_CanChangeOwner:bool (id:string))
    (defun UR_CanUpgrade:bool (id:string))
    (defun UR_CanAddSpecialRole:bool (id:string))
    (defun UR_CanFreeze:bool (id:string))
    (defun UR_CanWipe:bool (id:string))
    (defun UR_CanPause:bool (id:string))
    (defun UR_Paused:bool (id:string))
    (defun UR_Supply:decimal (id:string)) ;;2
    (defun UR_OriginMint:bool (id:string))
    (defun UR_OriginAmount:decimal (id:string))
    (defun UR_TransferRoleAmount:integer (id:string))
    (defun UR_FeeToggle:bool (id:string)) ;;1
    (defun UR_MinMove:decimal (id:string))
    (defun UR_FeePromile:decimal (id:string))
    (defun UR_FeeTarget:string (id:string)) ;;1
    (defun UR_FeeLock:bool (id:string))
    (defun UR_FeeUnlocks:integer (id:string))
    (defun UR_PrimaryFeeVolume:decimal (id:string))
    (defun UR_SecondaryFeeVolume:decimal (id:string))
    (defun UR_RewardToken:[string] (id:string)) ;;5
    (defun UR_RewardBearingToken:[string] (id:string)) ;;4
    (defun UR_Vesting:string (id:string)) ;;6
    (defun UR_Roles:[string] (id:string rp:integer))
    (defun UR_AccountSupply:decimal (id:string account:string)) ;;3
    (defun UR_AccountRoleBurn:bool (id:string account:string)) ;;5
    (defun UR_AccountRoleMint:bool (id:string account:string)) ;;4
    (defun UR_AccountRoleTransfer:bool (id:string account:string))
    (defun UR_AccountRoleFeeExemption:bool (id:string account:string)) ;;4
    (defun UR_AccountFrozenState:bool (id:string account:string))

    (defun URC_IzRT:bool (reward-token:string)) ;;3
    (defun URC_IzRTg:bool (atspair:string reward-token:string)) ;;2
    (defun URC_IzRBT:bool (reward-bearing-token:string)) ;;3
    (defun URC_IzRBTg:bool (atspair:string reward-bearing-token:string));1
    (defun URC_IzCoreDPTF:bool (id:string))
    (defun URC_AccountExist:bool (id:string account:string))
    (defun URC_Fee:[decimal] (id:string amount:decimal)) ;;1
    (defun URC_TrFeeMinExc:bool (id:string sender:string receiver:string)) ;;2
    (defun URC_HasVesting:bool (id:string))

    (defun UEV_CanChangeOwnerON (id:string))
    (defun UEV_CanUpgradeON (id:string))
    (defun UEV_CanAddSpecialRoleON (id:string))
    (defun UEV_CanFreezeON (id:string))
    (defun UEV_CanWipeON (id:string))
    (defun UEV_CanPauseON (id:string))
    (defun UEV_PauseState (id:string state:bool)) ;;1
    (defun UEV_AccountBurnState (id:string account:string state:bool))
    (defun UEV_AccountTransferState (id:string account:string state:bool))
    (defun UEV_AccountFreezeState (id:string account:string state:bool)) ;;2
    (defun UEV_Amount (id:string amount:decimal)) ;;7
    (defun UEV_CheckID:bool (id:string))
    (defun UEV_id (id:string)) ;;7
    (defun UEV_Virgin (id:string))
    (defun UEV_FeeLockState (id:string state:bool))
    (defun UEV_FeeToggleState (id:string state:bool))
    (defun UEV_AccountMintState (id:string account:string state:bool))
    (defun UEV_AccountFeeExemptionState (id:string account:string state:bool))
    (defun UEV_EnforceMinimumAmount (id:string transfer-amount:decimal)) ;;1
    (defun UEV_Vesting (id:string existance:bool)) ;;1

    (defun CAP_Owner (id:string)) ;;7

    (defun C_RotateOwnership (patron:string id:string new-owner:string))
    (defun C_DeployAccount (id:string account:string)) ;;9
    (defun C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool))
    (defun C_TogglePause (patron:string id:string toggle:bool))
    (defun C_ToggleTransferRole (patron:string id:string account:string toggle:bool))
    (defun C_Wipe (patron:string id:string atbw:string))
    (defun C_Burn (patron:string id:string account:string amount:decimal)) ;;7
    (defun C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool))
    (defun C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool]))
    (defun C_IssueLP:string (patron:string account:string name:string ticker:string)) ;;1
    (defun C_Mint (patron:string id:string account:string amount:decimal origin:bool)) ;;9
    (defun C_SetFee (patron:string id:string fee:decimal))
    (defun C_SetFeeTarget (patron:string id:string target:string))
    (defun C_SetMinMove (patron:string id:string min-move-value:decimal))
    (defun C_ToggleFee (patron:string id:string toggle:bool))
    (defun C_ToggleFeeLock (patron:string id:string toggle:bool))

    ;(defun X_IssueFree:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] iz-lp:[bool]))
    ;(defun X_ChangeOwnership (id:string new-owner:string))
    ;(defun X_ToggleFreezeAccount (id:string account:string toggle:bool))
    ;(defun X_TogglePause (id:string toggle:bool))
    ;(defun X_ToggleTransferRole (id:string account:string toggle:bool))
    ;(defun X_UpdateRoleTransferAmount (id:string direction:bool))
    ;(defun X_UpdateSupply (id:string amount:decimal direction:bool))
    ;(defun X_Wipe (id:string account-to-be-wiped:string))
    (defun X_ToggleBurnRole (id:string account:string toggle:bool)) ;;1
    (defun X_UpdateRewardBearingToken (atspair:string id:string)) ;;1
    (defun X_UpdateVesting (dptf:string dpmf:string)) ;;1
    ;(defun X_Control (id:string can-change-owner:bool can-upgrade:bool can-add-special-role:bool can-freeze:bool can-wipe:bool can-pause:bool))
    ;(defun X_Issue:string (account:string name:string ticker:string decimals:integer can-change-owner:bool can-upgrade:bool can-add-special-role:bool can-freeze:bool can-wipe:bool can-pause:bool iz-lp:bool))
    ;(defun X_Mint (id:string account:string amount:decimal origin:bool))
    ;(defun X_SetFee (id:string fee:decimal))
    ;(defun X_SetFeeTarget (id:string target:string))
    ;(defun X_SetMinMove (id:string min-move-value:decimal))
    ;(defun X_ToggleFee (id:string toggle:bool))
    ;(defun X_ToggleFeeLock:[decimal] (id:string toggle:bool))
    ;(defun X_IncrementFeeUnlocks (id:string))
    (defun X_Burn (id:string account:string amount:decimal)) ;;1
    ;(defun X_BurnCore (id:string account:string amount:decimal))
    (defun X_Credit (id:string account:string amount:decimal)) ;;8
    ;(defun X_DebitAdmin (id:string account:string amount:decimal))
    (defun X_DebitStandard (id:string account:string amount:decimal dispo-data:[decimal])) ;;2
    ;(defun X_Debit (id:string account:string amount:decimal dispo-data:[decimal]))
    (defun X_ToggleFeeExemptionRole (id:string account:string toggle:bool)) ;;1
    (defun X_ToggleMintRole (id:string account:string toggle:bool)) ;;1
    (defun X_UpdateFeeVolume (id:string amount:decimal primary:bool)) ;;2
    (defun X_UpdateRewardToken (atspair:string id:string direction:bool)) ;;3
    (defun X_WriteRoles (id:string account:string rp:integer d:bool)) ;;3
)

(interface DemiourgosPactMetaFungible
    (defschema DPMF|Schema
        nonce:integer
        balance:decimal
        meta-data:[object]
    )
    (defschema DPMF|Nonce-Balance
        nonce:integer
        balance:decimal
    )

    (defun UR_P-KEYS:[string] ()) ;;1
    (defun UR_KEYS:[string] ()) ;;1

    (defun UR_Konto:string (id:string)) ;;1
    (defun UR_Name:string (id:string))
    (defun UR_Ticker:string (id:string))
    (defun UR_Decimals:integer (id:string)) ;;1
    (defun UR_CanChangeOwner:bool (id:string))
    (defun UR_CanUpgrade:bool (id:string))
    (defun UR_CanAddSpecialRole:bool (id:string))
    (defun UR_CanFreeze:bool (id:string))
    (defun UR_CanWipe:bool (id:string))
    (defun UR_CanPause:bool (id:string))
    (defun UR_Paused:bool (id:string))
    (defun UR_Supply:decimal (id:string)) ;;1
    (defun UR_TransferRoleAmount:integer (id:string)) ;;1
    (defun UR_Vesting:string (id:string)) ;;2
    (defun UR_Roles:[string] (id:string rp:integer))
    (defun UR_CanTransferNFTCreateRole:bool (id:string))
    (defun UR_CreateRoleAccount:string (id:string)) ;;2
    (defun UR_NoncesUsed:integer (id:string)) ;;3
    (defun UR_RewardBearingToken:string (id:string)) ;;5
    (defun UR_AccountSupply:decimal (id:string account:string))
    (defun UR_AccountRoleBurn:bool (id:string account:string)) ;;3
    (defun UR_AccountRoleTransfer:bool (id:string account:string)) ;;3
    (defun UR_AccountFrozenState:bool (id:string account:string))
    (defun UR_AccountUnit:[object] (id:string account:string))
    (defun UR_AccountBalances:[decimal] (id:string account:string))
    (defun UR_AccountBatchMetaData (id:string nonce:integer account:string)) ;;2
    (defun UR_AccountBatchSupply:decimal (id:string nonce:integer account:string)) ;;4
    (defun UR_AccountNonces:[integer] (id:string account:string))
    (defun UR_AccountRoleNFTAQ:bool (id:string account:string)) ;;2
    (defun UR_AccountRoleCreate:bool (id:string account:string)) ;;2

    (defun URC_IzRBT:bool (reward-bearing-token:string)) ;;5
    (defun URC_IzRBTg:bool (atspair:string reward-bearing-token:string)) ;;1
    (defun URC_EliteAurynzSupply (account:string)) ;;1
    (defun URC_AccountExist:bool (id:string account:string))
    (defun URC_HasVesting:bool (id:string))

    (defun UEV_UpdateRewardBearingToken (id:string))
    (defun UEV_CanChangeOwnerON (id:string))
    (defun UEV_CanUpgradeON (id:string))
    (defun UEV_CanAddSpecialRoleON (id:string))
    (defun UEV_CanFreezeON (id:string))
    (defun UEV_CanWipeON (id:string))
    (defun UEV_CanPauseON (id:string))
    (defun UEV_PauseState (id:string state:bool))
    (defun UEV_AccountBurnState (id:string account:string state:bool))
    (defun UEV_AccountTransferState (id:string account:string state:bool))
    (defun UEV_AccountFreezeState (id:string account:string state:bool))
    (defun UEV_Amount (id:string amount:decimal))
    (defun UEV_CheckID:bool (id:string))
    (defun UEV_id (id:string)) ;;5
    (defun UEV_CanTransferNFTCreateRoleON (id:string))
    (defun UEV_AccountAddQuantityState (id:string account:string state:bool))
    (defun UEV_AccountCreateState (id:string account:string state:bool))
    (defun UEV_Vesting (id:string existance:bool)) ;;2

    (defun UDC_Compose:object{DPMF|Schema} (nonce:integer balance:decimal meta-data:[object]))
    (defun UDC_Nonce-Balance:[object{DPMF|Nonce-Balance}] (nonce-lst:[integer] balance-lst:[decimal]))

    (defun CAP_Owner (id:string)) ;;2

    (defun C_RotateOwnership (patron:string id:string new-owner:string))
    (defun C_DeployAccount (id:string account:string)) ;;2
    (defun C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool))
    (defun C_TogglePause (patron:string id:string toggle:bool))
    (defun C_ToggleTransferRole (patron:string id:string account:string toggle:bool)) ;;1
    (defun C_Wipe (patron:string id:string atbw:string))
    (defun C_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal))
    (defun C_Burn (patron:string id:string nonce:integer account:string amount:decimal)) ;;3
    (defun C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool))
    (defun C_Create:integer (patron:string id:string account:string meta-data:[object]))
    (defun C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool]))
    (defun C_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object])) ;;3
    (defun C_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool)) ;;6
    (defun C_MultiBatchTransfer (patron:string id:string nonces:[integer] sender:string receiver:string method:bool))
    (defun C_SingleBatchTransfer (patron:string id:string nonce:integer sender:string receiver:string method:bool))

    (defun X_UpdateElite (id:string sender:string receiver:string)) ;;1
    (defun X_UpdateVesting (dptf:string dpmf:string)) ;;1
    (defun X_IssueFree:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])) ;;1

    ;(defun X_ChangeOwnership (id:string new-owner:string))
    ;(defun X_ToggleFreezeAccount (id:string account:string toggle:bool))
    ;(defun X_TogglePause (id:string toggle:bool))
    ;(defun X_ToggleTransferRole (id:string account:string toggle:bool))
    ;(defun X_UpdateRoleTransferAmount (id:string direction:bool))
    ;(defun X_UpdateSupply (id:string amount:decimal direction:bool))
    ;(defun X_Wipe (id:string account-to-be-wiped:string))
    (defun X_ToggleBurnRole (id:string account:string toggle:bool)) ;;1
    (defun X_UpdateRewardBearingToken (atspair:string id:string)) ;;1
    (defun X_WriteRoles (id:string account:string rp:integer d:bool)) ;;4
    ;(defun X_AddQuantity (id:string nonce:integer account:string amount:decimal))
    ;(defun X_Burn (id:string nonce:integer account:string amount:decimal))
    ;(defun X_Control (patron:string id:string can-change-owner:bool can-upgrade:bool can-add-special-role:bool can-freeze:bool can-wipe:bool can-pause:boolcan-transfer-nft-create-role:bool))
    ;(defun X_Credit (id:string nonce:integer meta-data:[object] account:string amount:decimal))
    ;(defun X_Create:integer (id:string account:string meta-data:[object]))
    ;(defun X_DebitAdmin (id:string nonce:integer account:string amount:decimal))
    ;(defun X_DebitStandard (id:string nonce:integer account:string amount:decimal))
    ;(defun X_DebitPure (id:string nonce:integer account:string amount:decimal))
    ;(defun X_DebitMultiple (id:string nonce-lst:[integer] account:string balance-lst:[decimal]))
    ;(defun X_DebitPaired (id:string account:string nonce-balance-obj:object{DPMF|Nonce-Balance}))
    ;(defun X_Issue:string (account:string name:string ticker:string decimals:integer can-change-owner:bool can-upgrade:bool can-add-special-role:bool can-freeze:bool can-wipe:bool can-pause:boolcan-transfer-nft-create-role:bool))
    ;(defun X_IncrementNonce (id:string))
    ;(defun X_Mint:integer (id:string account:string amount:decimal meta-data:[object]))
    ;(defun XK_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool))
    ;(defun X_Transfer (id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool))
    (defun X_MoveCreateRole (id:string receiver:string)) ;;1
    (defun X_ToggleAddQuantityRole (id:string account:string toggle:bool)) ;;1
)

(interface Autostake
    (defschema ATS|RewardTokenSchema
        token:string
        nfr:bool
        resident:decimal
        unbonding:decimal
    )
    (defschema ATS|Hot
        mint-time:time
    )

    (defun GOV|ATS|SC_KDA-NAME ())

    (defun UR_P-KEYS:[string] ()) ;;1
    (defun UR_KEYS:[string] ()) ;;1
    (defun UR_OwnerKonto:string (atspair:string)) ;;15
    (defun UR_CanChangeOwner:bool (atspair:string))
    (defun UR_Lock:bool (atspair:string))
    (defun UR_Unlocks:integer (atspair:string))
    (defun UR_IndexName:string (atspair:string))
    (defun UR_IndexDecimals:integer (atspair:string))
    (defun UR_Syphon:decimal (atspair:string))
    (defun UR_Syphoning:bool (atspair:string))
    (defun UR_RewardTokens:[object{ATS|RewardTokenSchema}] (atspair:string)) ;;1
    (defun UR_ColdRewardBearingToken:string (atspair:string)) ;;7
    (defun UR_ColdNativeFeeRedirection:bool (atspair:string)) ;;1
    (defun UR_ColdRecoveryPositions:integer (atspair:string)) ;;1
    (defun UR_ColdRecoveryFeeThresholds:[decimal] (atspair:string))
    (defun UR_ColdRecoveryFeeTable:[[decimal]] (atspair:string))
    (defun UR_ColdRecoveryFeeRedirection:bool (atspair:string)) ;;1
    (defun UR_ColdRecoveryDuration:[integer] (atspair:string))
    (defun UR_EliteMode:bool (atspair:string)) ;;1
    (defun UR_HotRewardBearingToken:string (atspair:string)) ;;1
    (defun UR_HotRecoveryStartingFeePromile:decimal (atspair:string)) ;;1
    (defun UR_HotRecoveryDecayPeriod:integer (atspair:string)) ;;1
    (defun UR_HotRecoveryFeeRedirection:bool (atspair:string)) ;;1
    (defun UR_ToggleColdRecovery:bool (atspair:string))
    (defun UR_ToggleHotRecovery:bool (atspair:string))
    (defun UR_RewardTokenList:[string] (atspair:string)) ;;9
    (defun UR_RoUAmountList:[decimal] (atspair:string rou:bool)) ;;3
    (defun UR_RT-Data (atspair:string reward-token:string data:integer)) ;;1
    (defun UR_RtPrecisions:[integer] (atspair:string))
    (defun UR_P0:[object{UtilityAts.Awo}] (atspair:string account:string)) ;;3
    (defun UR_P1-7:object{UtilityAts.Awo} (atspair:string account:string position:integer)) ;;8

    (defun URC_PosObjSt:integer (atspair:string input-obj:object{UtilityAts.Awo}))
    (defun URC_MaxSyphon:[decimal] (atspair:string)) ;;1
    (defun URC_CullValue:[decimal] (atspair:string input:object{UtilityAts.Awo})) ;;2
    (defun URC_AccountUnbondingBalance (atspair:string account:string reward-token:string)) ;;1
    (defun URC_UnstakeObjectUnbondingValue (atspair:string reward-token:string io:object{UtilityAts.Awo}))
    (defun URC_RewardTokenPosition:integer (atspair:string reward-token:string)) ;;1
    (defun URC_WhichPosition:integer (atspair:string c-rbt-amount:decimal account:string)) ;;1
    (defun URC_ElitePosition:integer (atspair:string c-rbt-amount:decimal account:string))
    (defun URC_NonElitePosition:integer (atspair:string account:string))
    (defun URC_PSL:[integer] (atspair:string account:string))
    (defun URC_PosSt:integer (atspair:string account:string position:integer))
    (defun URC_ColdRecoveryFee (atspair:string c-rbt-amount:decimal input-position:integer)) ;;1
    (defun URC_CullColdRecoveryTime:time (atspair:string account:string)) ;;1
    (defun URC_RTSplitAmounts:[decimal] (atspair:string rbt-amount:decimal)) ;;4
    (defun URC_Index (atspair:string)) ;;3
    (defun URC_PairRBTSupply:decimal (atspair:string))
    (defun URC_RBT:decimal (atspair:string rt:string rt-amount:decimal)) ;;3
    (defun URC_ResidentSum:decimal (atspair:string))
    (defun URC_IzPresentHotRBT:bool (atspair:string)) ;;1

    (defun UEV_CanChangeOwnerON (atspair:string))
    (defun UEV_RewardTokenExistance (atspair:string reward-token:string existance:bool)) ;;3
    (defun UEV_RewardBearingTokenExistance (atspair:string reward-bearing-token:string existance:bool cold-or-hot:bool))
    (defun UEV_HotRewardBearingTokenPresence (atspair:string enforced-presence:bool))
    (defun UEV_ParameterLockState (atspair:string state:bool)) ;;1
    (defun UEV_SyphoningState (atspair:string state:bool)) ;;1
    (defun UEV_FeeState (atspair:string state:bool fee-switch:integer))
    (defun UEV_EliteState (atspair:string state:bool))
    (defun UEV_RecoveryState (atspair:string state:bool cold-or-hot:bool)) ;;2
    (defun UEV_UpdateColdOrHot (atspair:string cold-or-hot:bool))
    (defun UEV_UpdateColdAndHot (atspair:string)) ;;1
    (defun UEV_id (atspair:string)) ;;5
    (defun UEV_IzTokenUnique (atspair:string reward-token:string))
    (defun UEV_IssueData (atspair:string index-decimals:integer reward-token:string reward-bearing-token:string))

    (defun UDC_MakeUnstakeObject:object{UtilityAts.Awo} (atspair:string time:time))
    (defun UDC_MakeZeroUnstakeObject:object{UtilityAts.Awo} (atspair:string)) ;;4
    (defun UDC_MakeNegativeUnstakeObject:object{UtilityAts.Awo} (atspair:string)) ;;2
    (defun UDC_ComposePrimaryRewardToken:object{ATS|RewardTokenSchema} (token:string nfr:bool))
    (defun UDC_RT:object{ATS|RewardTokenSchema} (token:string nfr:bool r:decimal u:decimal))

    (defun CAP_Owner (id:string)) ;;2

    (defun C_Issue:[string] (patron:string account:string atspair:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string] rbt-nfr:[bool]))
    (defun C_ToggleFeeSettings (patron:string atspair:string toggle:bool fee-switch:integer))
    (defun C_TurnRecoveryOff (patron:string atspair:string cold-or-hot:bool))
    (defun DPTF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)) ;;1
    (defun DPTF|C_ToggleFeeExemptionRole (patron:string id:string account:string toggle:bool)) ;;2
    (defun DPTF|C_ToggleMintRole (patron:string id:string account:string toggle:bool)) ;;1
    (defun DPMF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)) ;;1
    (defun DPMF|C_MoveCreateRole (patron:string id:string receiver:string)) ;;1
    (defun DPMF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool)) ;;1

    (defun X_ChangeOwnership (atspair:string new-owner:string)) ;;1
    (defun X_ModifyCanChangeOwner (atspair:string new-boolean:bool)) ;;1
    (defun X_ToggleParameterLock:[decimal] (atspair:string toggle:bool)) ;;1
    (defun X_IncrementParameterUnlocks (atspair:string)) ;;1
    (defun X_UpdateSyphon (atspair:string syphon:decimal)) ;;1
    (defun X_ToggleSyphoning (atspair:string toggle:bool)) ;;1
    ;(defun X_ToggleFeeSettings (atspair:string toggle:bool fee-switch:integer))
    (defun X_SetCRD (atspair:string soft-or-hard:bool base:integer growth:integer)) ;;1
    (defun X_SetColdFee (atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])) ;;1
    (defun X_SetHotFee (atspair:string promile:decimal decay:integer)) ;;1
    (defun X_ToggleElite (atspair:string toggle:bool)) ;;1
    (defun X_TurnRecoveryOn (atspair:string cold-or-hot:bool)) ;;1
    (defun X_TurnRecoveryOff (atspair:string cold-or-hot:bool))
    (defun X_Issue:string (account:string atspair:string index-decimals:integer reward-token:string rt-nfr:bool reward-bearing-token:string rbt-nfr:bool))
    (defun X_AddSecondary (atspair:string reward-token:string rt-nfr:bool)) ;;1
    (defun X_AddHotRBT (atspair:string hot-rbt:string)) ;;1
    (defun X_ReshapeUnstakeAccount (atspair:string account:string rp:integer)) ;;1
    (defun X_RemoveSecondary (atspair:string reward-token:string)) ;;1
    (defun X_UpdateRoU (atspair:string reward-token:string rou:bool direction:bool amount:decimal)) ;;14
    (defun X_UpP0 (atspair:string account:string obj:[object{UtilityAts.Awo}])) ;;4
    (defun X_UpP1 (atspair:string account:string obj:object{UtilityAts.Awo})) ;;2
    (defun X_UpP2 (atspair:string account:string obj:object{UtilityAts.Awo})) ;;2
    (defun X_UpP3 (atspair:string account:string obj:object{UtilityAts.Awo})) ;;2
    (defun X_UpP4 (atspair:string account:string obj:object{UtilityAts.Awo})) ;;2
    (defun X_UpP5 (atspair:string account:string obj:object{UtilityAts.Awo})) ;;2
    (defun X_UpP6 (atspair:string account:string obj:object{UtilityAts.Awo})) ;;2
    (defun X_UpP7 (atspair:string account:string obj:object{UtilityAts.Awo})) ;;2
    (defun X_SpawnAutostakeAccount (atspair:string account:string)) ;;1
    (defun XC_EnsureActivationRoles (patron:string atspair:string cold-or-hot:bool)) ;;3
    (defun XC_SetMassRole (patron:string atspair:string burn-or-exemption:bool))
    (defun XC_RevokeBurn (patron:string id:string cold-or-hot:bool))
    (defun X_MassTurnColdRecoveryOff (patron:string id:string))
    (defun XC_RevokeFeeExemption (patron:string id:string))
    (defun XC_RevokeMint (patron:string id:string))
    (defun XC_RevokeCreateOrAddQ (patron:string id:string))
)

(interface TrueFungibleTransfer
    (defun DPTF-DPMF-ATS|UR_TableKeys:[string] (position:integer poi:bool))
    (defun DPTF-DPMF-ATS|UR_FilterKeysForInfo:[string] (account-or-token-id:string table-to-query:integer mode:bool)) ;;1

    ;(defun URC_CPF_RT-RBT:[decimal] (id:string native-fee-amount:decimal))
    ;(defun URC_CPF_RBT:decimal (id:string native-fee-amount:decimal))
    ;(defun URC_CPF_RT:decimal (id:string native-fee-amount:decimal))
    ;(defun URC_NFR-Boolean_RT-RBT:[bool] (id:string ats-pairs:[string] rt-or-rbt:bool))
    ;(defun URC_BooleanDecimalCombiner:[decimal] (id:string amount:decimal milestones:integer boolean:[bool]))

    ;(defun UEV_AmountCheck:bool (id:string amount:decimal))
    ;(defun UEV_Pair_ID-Amount:bool (id-lst:[string] transfer-amount-lst:[decimal]))
    ;(defun UEV_Pair_Receiver-Amount:bool (id:string receiver-lst:[string] transfer-amount-lst:[decimal]))

    (defun UDC_GetDispoData:[decimal] (account:string))
    ;(defun UDC_Pair_ID-Amount:[object{DPTF|ID-Amount}] (id-lst:[string] transfer-amount-lst:[decimal]))
    ;(defun UDC_Pair_Receiver-Amount:[object{DPTF|Receiver-Amount}] (receiver-lst:[string] transfer-amount-lst:[decimal]))

    (defun C_ClearDispo (patron:string account:string))
    (defun C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal)) ;;2
    (defun C_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool)) ;;25
    (defun C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)) ;;2
    (defun C_BulkTransfer (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool))

    ;(defun X_Transmute (id:string transmuter:string transmute-amount:decimal))
    ;(defun X_Transfer (id:string sender:string receiver:string transfer-amount:decimal method:bool))
    ;(defun X_CreditPrimaryFee (id:string pf:decimal native:bool))
    ;(defun X_CPF_StillFee (id:string target:string still-fee:decimal))
    ;(defun X_CPF_BurnFee (id:string target:string burn-fee:decimal))
    ;(defun X_CPF_CreditFee (id:string target:string credit-fee:decimal))
    ;(defun X_MultiTransferPaired (patron:string sender:string receiver:string id-amount-pair:object{DPTF|ID-Amount} method:bool))
    ;(defun X_BulkTransferPaired (patron:string id:string sender:string receiver-amount-pair:object{DPTF|Receiver-Amount} method:bool))
)

(interface AutostakeUsage
    (defun C_ColdRecovery (patron:string recoverer:string ats:string ra:decimal))
    (defun C_Cull:[decimal] (patron:string culler:string ats:string))
    (defun C_HotRecovery (patron:string recoverer:string ats:string ra:decimal))
    (defun C_Redeem (patron:string redeemer:string id:string nonce:integer))
    (defun C_RecoverWholeRBTBatch (patron:string recoverer:string id:string nonce:integer))
    (defun C_RecoverHotRBT (patron:string recoverer:string id:string nonce:integer amount:decimal))
    (defun C_RotateOwnership (patron:string ats:string new-owner:string))
    (defun C_ModifyCanChangeOwner (patron:string ats:string new-boolean:bool))
    (defun C_ToggleParameterLock (patron:string ats:string toggle:bool))
    (defun C_UpdateSyphon (patron:string ats:string syphon:decimal))
    (defun C_ToggleSyphoning (patron:string ats:string toggle:bool))
    (defun C_SetCRD (patron:string ats:string soft-or-hard:bool base:integer growth:integer))
    (defun C_SetColdFee (patron:string ats:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]]))
    (defun C_SetHotFee (patron:string ats:string promile:decimal decay:integer))
    (defun C_ToggleElite (patron:string ats:string toggle:bool))
    (defun C_TurnRecoveryOn (patron:string ats:string cold-or-hot:bool))
    (defun C_AddSecondary (patron:string ats:string reward-token:string rt-nfr:bool))
    (defun C_RemoveSecondary (patron:string remover:string ats:string reward-token:string))
    (defun C_AddHotRBT (patron:string ats:string hot-rbt:string))
    (defun C_Fuel (patron:string fueler:string atspair:string reward-token:string amount:decimal)) ;;1
    (defun C_Syphon (patron:string syphon-target:string ats:string syphon-amounts:[decimal]))
    (defun C_KickStart:decimal (patron:string kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal))
    (defun C_Coil:decimal (patron:string coiler:string ats:string rt:string amount:decimal))
    (defun C_Curl:decimal (patron:string curler:string ats1:string ats2:string rt:string amount:decimal))

    ;(defun X_MultiCull:[decimal] (ats:string acc:string))
    ;(defun X_SingleCull:[decimal] (ats:string acc:string position:integer))
    ;(defun X_StoreUnstakeObject (ats:string acc:string position:integer obj:object{UtilityAts.Awo}))
    ;(defun X_DeployAccount (ats:string acc:string))
    ;(defun X_Normalize (ats:string acc:string))
    ;(defun X_UUP (ats:string acc:string data:[object{UtilityAts.Awo}]))
)

(interface Vesting
    (defschema VST|MetaDataSchema
        release-amount:decimal
        release-date:time
    )
    (defun GOV|VST|SC_KDA-NAME ())
    ;;
    (defun URC_CullMetaDataAmount:decimal (client:string id:string nonce:integer))
    (defun URC_CullMetaDataObject:[object{VST|MetaDataSchema}] (client:string id:string nonce:integer))

    (defun UEV_Active (dptf:string dpmf:string))

    (defun UDC_ComposeVestingMetaData:[object{VST|MetaDataSchema}] (id:string amount:decimal offset:integer duration:integer milestones:integer))

    (defun C_CreateVestingLink:string (patron:string dptf:string))
    (defun C_Vest (patron:string vester:string target-account:string id:string amount:decimal offset:integer duration:integer milestones:integer))
    (defun C_Cull (patron:string culler:string id:string nonce:integer))

    (defun X_DefineVestingPair (patron:string dptf:string dpmf:string))
)

(interface KadenaLiquidStaking
    (defun GOV|LIQUID|SC_KDA-NAME ()) ;;1

    (defun UEV_IzLiquidStakingLive ())

    (defun LIQUID|C_WrapKadena (patron:string wrapper:string amount:decimal)) ;;1
    (defun LIQUID|C_UnwrapKadena (patron:string unwrapper:string amount:string))
)

(interface Ouroboros
    (defun GOV|ORBR|SC_KDA-NAME ())

    (defun URC_Sublimate:decimal (ouro-amount:decimal))
    (defun URC_Compress:[decimal] (ignis-amount:decimal))

    (defun UEV_AccountsAsStandard (accounts:[string]))
    (defun UEV_Exchange ())

    (defun C_Fuel (patron:string))
    (defun C_WithdrawFees (patron:string id:string target:string))
    (defun C_Sublimate:decimal (patron:string client:string target:string ouro-amount:decimal))
    (defun C_Compress:decimal (patron:string client:string ignis-amount:decimal))
)

(interface Swapper
    (defschema PoolTokens
        token-id:string
        token-supply:decimal
    )
    (defschema FeeSplit
        target:string
        value:integer
    )
    (defschema Edges
        principal:string
        swpairs:[string]
    )
    (defun GOV|SWP|SC_KDA-NAME ())

    (defun UC_ExtractTokens:[string] (input:[object{PoolTokens}]))
    (defun UC_ExtractTokenSupplies:[decimal] (input:[object{PoolTokens}]))
    (defun UC_CustomSpecialFeeTargets:[string] (io:[object{FeeSplit}]))
    (defun UC_CustomSpecialFeeTargetsProportions:[decimal] (io:[object{FeeSplit}]))
    (defun SWPT|UC_PSwpairsFTO:[string] (traces:[object{Edges}] id:string principal:string))
    (defun SWPT|UC_PrincipalsFromTraces:[string] (traces:[object{Edges}]))

    (defun UR_Principals:[string] ())
    (defun UR_LiquidBoost:bool ())
    (defun UR_SpawnLimit:decimal ())
    (defun UR_InactiveLimit:decimal ())
    (defun UR_OwnerKonto:string (swpair:string))
    (defun UR_CanChangeOwner:bool (swpair:string))
    (defun UR_CanAdd:bool (swpair:string))
    (defun UR_CanSwap:bool (swpair:string))
    (defun UR_GenesisWeigths:[decimal] (swpair:string))
    (defun UR_Weigths:[decimal] (swpair:string))
    (defun UR_GenesisRatio:[object{PoolTokens}] (swpair:string))
    (defun UR_PoolTokenObject:[object{PoolTokens}] (swpair:string))
    (defun UR_TokenLP:string (swpair:string)) ;;1
    (defun UR_TokenLPS:[string] (swpair:string)) ;;1
    (defun UR_FeeLP:decimal (swpair:string))
    (defun UR_FeeSP:decimal (swpair:string))
    (defun UR_FeeSPT:[object{FeeSplit}] (swpair:string))
    (defun UR_FeeLock:bool (swpair:string))
    (defun UR_FeeUnlocks:integer (swpair:string))
    (defun UR_Special:bool (swpair:string))
    (defun UR_Governor:guard (swpair:string))
    (defun UR_Amplifier:decimal (swpair:string)) ;;1
    (defun UR_Primality:bool (swpair:string))
    (defun UR_Pools:[string] (pool-category:string))
    (defun UR_PoolTokens:[string] (swpair:string)) ;;2
    (defun UR_PoolTokenSupplies:[decimal] (swpair:string)) ;;3
    (defun UR_PoolGenesisSupplies:[decimal] (swpair:string)) ;;2
    (defun UR_PoolTokenPosition:integer (swpair:string id:string)) ;;1
    (defun UR_PoolTokenSupply:decimal (swpair:string id:string))
    (defun UR_PoolTokenPrecisions:[integer] (swpair:string)) ;;2
    (defun UR_SpecialFeeTargets:[string] (swpair:string))
    (defun UR_SpecialFeeTargetsProportions:[decimal] (swpair:string))

    (defun URC_CheckID:bool (swpair:string))
    (defun URC_PoolTotalFee:decimal (swpair:string))
    (defun URC_LiquidityFee:decimal (swpair:string))
    (defun URC_Swpairs:[string] ())
    (defun SWPT|URC_PathTracer:[object{Edges}] (old-path-tracer:[object{Edges}] id:string swpair:string))
    (defun SWPT|URC_ContainsPrincipals:bool (swpair:string))
    (defun SWPI|URC_LpComposer:[string] (pool-tokens:[object{PoolTokens}] weights:[decimal] amp:decimal))

    ;(defun UEV_FeeSplit (input:object{FeeSplit}))
    (defun UEV_id (swpair:string)) ;;2
    (defun UEV_CanChangeOwnerON (swpair:string))
    (defun UEV_FeeLockState (swpair:string state:bool))
    (defun UEV_PoolFee (fee:decimal))
    (defun UEV_New (t-ids:[string] w:[decimal] amp:decimal))
    (defun UEV_CheckTwo (token-ids:[string] w:[decimal] amp:decimal))
    (defun UEV_CheckAgainstMass:bool (token-ids:[string] present-pools:[string]))
    (defun UEV_CheckAgainst:bool (token-ids:[string] pool-tokens:[string])) ;;1
    (defun SWPT|UEV_IdAsPrincipal (id:string for-trace:bool))

    (defun A_UpdatePrincipal (principal:string add-or-remove:bool))
    (defun A_UpdateLiquidBoost (new-boost-variable:bool))
    (defun A_UpdateLimit (limit:decimal spawn:bool))

    (defun X_ChangeOwnership (swpair:string new-owner:string))
    (defun X_ModifyCanChangeOwner (swpair:string new-boolean:bool))
    (defun X_CanAddOrSwapToggle (swpair:string toggle:bool add-or-swap:bool))
    (defun X_ModifyWeights (swpair:string new-weights:[decimal]))
    (defun X_ToggleFeeLock:[decimal] (swpair:string toggle:bool))
    (defun X_IncrementFeeUnlocks (swpair:string))
    (defun X_UpdateLP (swpair:string lp-token:string add-or-remove:bool))
    (defun X_UpdateSupplies (swpair:string new-supplies:[decimal]))
    (defun X_UpdateSupply (swpair:string id:string new-supply:decimal))
    (defun X_UpdateFee (swpair:string new-fee:decimal lp-or-special:bool))
    (defun X_UpdateSpecialFeeTargets (swpair:string targets:[object{FeeSplit}]))
    (defun X_ToggleSpecialMode (swpair:string))
    (defun X_UpdateGovernor (swpair:string new-governor:guard))
    (defun X_UpdateAmplifier (swpair:string new-amplifier:decimal))
    (defun X_SavePool (n:integer what:bool swpair:string))
    (defun X_Issue:string (account:string pool-tokens:[object{PoolTokens}] token-lp:string fee-lp:decimal weights:[decimal] amp:decimal p:bool))
    (defun SWPT|X_MultiPathTracer (swpair:string))
    (defun SWPT|X_SinglePathTracer (id:string swpair:string))

)

(interface SwapperUsage
    (defun SWPLC|URC_AreAmountsBalanced:bool (swpair:string input-amounts:[decimal]))
    (defun SWPLC|URC_LpCapacity:decimal (swpair:string))
    (defun SWPLC|URC_BalancedLiquidity:[decimal] (swpair:string input-id:string input-amount:decimal))
    (defun SWPLC|URC_SymetricLpAmount:decimal (swpair:string input-id:string input-amount:decimal))
    (defun SWPLC|URC_LpBreakAmounts:[decimal] (swpair:string input-lp-amount:decimal))
    (defun SWPLC|URC_LpAmount:decimal (swpair:string input-amounts:[decimal]))
    (defun SWPLC|URC_WP_LpAmount:decimal (swpair:string input-amounts:[decimal]))
    (defun SWPLC|URC_S_LpAmount:decimal (swpair:string input-amounts:[decimal]))
    

)
