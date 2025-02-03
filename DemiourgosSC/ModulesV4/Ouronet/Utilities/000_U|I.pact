
;;001_U|CT
(interface OuronetConstants
    (defun CT_NS_USE ()) ;;1
    (defun CT_GOV|UTILS ()) ;;12

    (defun CT_DPTF-FeeLock ()) ;;1
    (defun CT_ATS-FeeLock ()) ;;1

    (defun CT_KDA_PRECISION ()) ;;2
    (defun CT_MIN_PRECISION ()) ;;1
    (defun CT_MAX_PRECISION ()) ;;1
    (defun CT_FEE_PRECISION ()) ;;1
    (defun CT_MIN_DESIGNATION_LENGTH ()) ;;4
    (defun CT_MAX_TOKEN_NAME_LENGTH ()) ;;2
    (defun CT_MAX_TOKEN_TICKER_LENGTH ()) ;;2
    (defun CT_ACCOUNT_ID_CHARSET ()) ;;1
    (defun CT_ACCOUNT_ID_PROH-CHAR ()) ;;1
    (defun CT_ACCOUNT_ID_MAX_LENGTH ()) ;;1
    (defun CT_BAR ()) ;;6
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
    (defun UEV_GuardOfAll:guard (guards:[guard]))
    (defun UEV_All:bool (guards:[guard]))
    (defun UEV_GuardOfAny:guard (guards:[guard]))
    (defun UEV_Any:bool (guards:[guard])) ;;1
    (defun UC_Try (g:guard))
)

;;003_U|ST
(interface OuronetGasStation
    (defun max-gas-notional:guard (gasNotional:decimal))
    (defun enforce-below-gas-notional (gasNotional:decimal))
    (defun enforce-below-or-at-gas-notional (gasNotional:decimal))
    (defun max-gas-price:guard (gasPrice:decimal))
    (defun enforce-below-gas-price:bool (gasPrice:decimal))
    (defun enforce-below-or-at-gas-price:bool (gasPrice:decimal))
    (defun max-gas-limit:guard (gasLimit:integer))
    (defun enforce-below-gas-limit:bool (gasLimit:integer))
    (defun enforce-below-or-at-gas-limit:bool (gasLimit:integer))
    (defun chain-gas-price ())
    (defun chain-gas-limit ())
    (defun chain-gas-notional ())
)

;;004_U|RS
(interface ReservedAccounts
    (defun UEV_EnforceReserved:bool (account:string guard:guard))
    (defun UEV_CheckReserved:string (account:string))
)

;;005_U|LST
(interface StringProcessor
    (defun UEV_NotEmpty:bool (x:list))
    (defun UC_SplitString:[string] (splitter:string splitee:string)) ;;1
    (defun UC_Search:[integer] (searchee:list item)) ;;16
    (defun UC_ReplaceItem:list (in:list old-item new-item)) ;;4
    (defun UC_ReplaceAt:list (in:list idx:integer item)) ;;6
    (defun UC_RemoveItem:list (in:list item)) ;;7
    (defun UC_RemoveItemAt:list (in:list position:integer)) ;;3
    (defun UC_IzUnique (lst:[string])) ;;5
    (defun UC_FE (in:list)) ;;1
    (defun UC_SecondListElement (in:list))
    (defun UC_LE (in:list)) ;;13
    (defun UC_InsertFirst:list (in:list item))
    (defun UC_AppL:list (in:list item)) ;;52
    (defun UC_IsNotEmpty:bool (x:list))
    (defun UC_Chain:list (in:list))
)

;;006_U|INT
(interface OuronetIntegers
    (defun UC_MaxInteger:integer (lst:[integer])) ;;2
    (defun UEV_PositionalVariable (integer-to-validate:integer positions:integer message:string)) ;;7
    (defun UEV_UniformList (input:[integer])) ;;4
    (defun UEV_ContainsAll (l1:[integer] l2:[integer])) ;;1
)

;;007_U|DEC
(interface OuronetDecimals
    (defun UEV_DecimalArray (array:[[decimal]])) ;;1
    (defun UC_Percent:decimal (x:decimal percent:decimal precision:integer)) ;;3
    (defun UC_Promille:decimal (x:decimal promille:decimal precision:integer)) ;;1
    (defun UC_Max (x y))
    (defun UC_AddArray:[decimal] (array:[[decimal]]))
    (defun UC_AddHybridArray (lists))
    (defun UC_UnlockPrice:[decimal] (unlocks:integer dptf-or-ats:bool)) ;;2

)

;;008_U|DALOS
(interface Ouronet4Dalos
    (defun UEV_NameOrTicker:bool (name-ticker:string name-or-ticker:bool iz-lp:bool)) ;;4
    (defun UEV_Decimals:bool (decimals:integer)) ;;3
    (defun UEV_Fee (fee:decimal)) ;;3
    (defun UEV_TokenName:bool (name:string))
    (defun UEV_TickerName:bool (ticker:string))
    (defun UC_IzStringANC:bool (s:string capital:bool))
    (defun UC_IzCharacterANC:bool (c:string capital:bool))
    (defun UC_NewRoleList (current-lst:[string] account:string direction:bool)) ;;10
    (defun UC_FilterId:[string] (listoflists:[[string]] account:string)) ;;1
    (defun UC_GasCost (base-cost:decimal major:integer minor:integer native:bool)) ;;2
    (defun UC_GasDiscount (major:integer minor:integer native:bool))
    (defun UC_KadenaSplit:[decimal] (kadena-input-amount:decimal)) ;;1
    (defun UDC_Makeid:string (ticker:string)) ;;4
    (defun UDC_MakeMVXNonce:string (nonce:integer))
)

;;009_U|ATS
(interface Ouronet4Ats
    (defschema Awo
        reward-tokens:[decimal]
        cull-time:time
    )
    
    (defun UEV_UniqueAtspair (ats:string)) ;;1
    (defun UEV_AutostakeIndex (ats:string))

    (defun UC_TripleAnd:bool (b1:bool b2:bool b3:bool))
    (defun UC_QuadAnd:bool (b1:bool b2:bool b3:bool b4:bool))
    (defun UC_UnlockPrice:[decimal] (unlocks:integer)) ;;1
    (defun UC_MakeSoftIntervals:[integer] (start:integer growth:integer)) ;;2
    (defun UC_MakeHardIntervals:[integer] (start:integer growth:integer)) ;;1
    (defun UC_SplitBalanceWithBooleans:[decimal] (precision:integer amount:decimal milestones:integer boolean:[bool])) ;;1
    (defun UC_SplitByIndexedRBT:[decimal] (rbt-amount:decimal pair-rbt-supply:decimal index:decimal resident-amounts:[decimal] rt-precisions:[integer])) ;;1
    (defun UC_PromilleSplit:[decimal] (promille:decimal input:decimal input-precision:integer))
    (defun UDC_Elite (x:decimal)) ;;2

    (defun UC_IzCullable:bool (input:object{Awo})) ;;1
    (defun UC_ZeroColdFeeExceptionBoolean:bool (fee-thresholds:[decimal] fee-array:[[decimal]])) ;;2
    (defun UC_MultiReshapeUnstakeObject:[object{Awo}] (input:[object{Awo}] remove-position:integer)) ;;1
    (defun UC_ReshapeUnstakeObject:object{Awo} (input:object{Awo} remove-position:integer)) ;;7
    (defun UC_IzUnstakeObjectValid:bool (input:object{Awo}))
    (defun UC_SolidifyUnstakeObject:object{Awo} (input:object{Awo} remove-position:integer))
)

;;010_U|DPTF
(interface Ouronet4Dptf
    (defun UC_UnlockPrice:[decimal] (unlocks:integer)) ;;1
    (defun UC_VolumetricTax (precision:integer amount:decimal)) ;;1
    ;(defun UCX_VolumetricPermile:decimal (precision:integer unit:integer))
)

;;011_U|VST
(interface Ouronet4Vst
    (defun UEV_Milestone (milestones:integer))
    (defun UEV_MilestoneWithTime (offset:integer duration:integer milestones:integer))
    (defun UC_SplitBalanceForVesting:[decimal] (precision:integer amount:decimal milestones:integer))
    (defun UC_MakeVestingDateList:[time] (offset:integer duration:integer milestones:integer))
)

;;012_U|SWP
(interface Ouronet4Swp
    (defun UC_ComputeWP (X:[decimal] input-amounts:[decimal] ip:[integer] op:integer o-prec w:[decimal]))
    (defun UC_NewSupply:[decimal] (X:[decimal] input-amounts:[decimal] ip:[integer]))
    (defun UC_ComputeY (A:decimal X:[decimal] input-amount:decimal ip:integer op:integer o-prec:integer))
    (defun UC_ComputeD:decimal (A:decimal X:[decimal]))
    (defun UC_DNext (D:decimal A:decimal X:[decimal]))
    (defun UC_YNext (Y:decimal D:decimal A:decimal X:[decimal] op:integer))

    (defun UC_Prefix:string (weights:[decimal] amp:decimal))
    (defun UC_LpID:[string] (token-names:[string] token-tickers:[string] weights:[decimal] amp:decimal))
    (defun UC_PoolID:string (token-ids:[string] weights:[decimal] amp:decimal))
    (defun UC_BalancedLiquidity:[decimal] (ia:decimal ip:integer i-prec X:[decimal] Xp:[integer]))
    (defun UC_LP:decimal (input-amounts:[decimal] pts:[decimal] lps:decimal lpp:integer))
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
    (defun P|A_Add (policy-name:string policy-guard:guard)) ;;11
)

;;001_DALOS
(interface DalosSchemas
    (defschema DPTF|BalanceSchema
        @doc "Schema that Stores Account Balances for DPTF Tokens (True Fungibles)\
            \ Key for the Table is a string composed of: <DPTF id> + BAR + <account> \
            \ This ensure a single entry per DPTF id per account. \
            \ As an Exception OUROBOROS and IGNIS Account Data is Stored at the DALOS Account Level"
        balance:decimal
        ;;Special Roles
        role-burn:bool
        role-mint:bool
        role-transfer:bool
        role-fee-exemption:bool                         
        ;;States
        frozen:bool
    )
    (defschema BrandingSchema
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
)
(interface OuronetDalos
    (defun GOV|Demiurgoi ()) ;;4
    (defun GOV|DALOS|SC_NAME ()) ;;4
    (defun GOV|LIQUID|SC_NAME ())
    (defun GOV|OUROBOROS|SC_NAME ()) ;;4

    (defun UR_KadenaLedger:[string] (kadena:string))
    (defun UR_DemiurgoiID:[string] ())
    (defun UR_UnityID:string ()) ;;2
    (defun UR_OuroborosID:string ()) ;;14
    (defun UR_OuroborosPrice:decimal ())
    (defun UR_IgnisID:string ()) ;1
    (defun UR_AurynID:string ())
    (defun UR_EliteAurynID:string ()) ;;5
    (defun UR_WrappedKadenaID:string ())
    (defun UR_LiquidKadenaID:string ())
    (defun UR_Tanker:string ())
    (defun UR_VirtualToggle:bool ())
    (defun UR_VirtualSpent:decimal ())
    (defun UR_NativeToggle:bool ())
    (defun UR_NativeSpent:decimal ())
    (defun UR_UsagePrice:decimal (action:string)) ;;40
    (defun UR_AccountPublicKey:string (account:string))
    (defun UR_AccountGuard:guard (account:string))
    (defun UR_AccountKadena:string (account:string))
    (defun UR_AccountSovereign:string (account:string))
    (defun UR_AccountGovernor:guard (account:string))
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
    (defun UR_Elite-Tier-Major:integer (account:string)) ;;2
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
    (defun UEV_EnforceAccountExists (dalos-account:string)) ;;8
    (defun UEV_EnforceAccountType (account:string smart:bool)) ;;1
    (defun UEV_EnforceTransferability (sender:string receiver:string method:bool)) ;;2
    (defun UEV_SenderWithReceiver (sender:string receiver:string)) ;;4
    (defun UEV_TwentyFourPrecision (amount:decimal))
    (defun GLYPH|UEV_DalosAccountCheck (account:string)) ;;1
    (defun GLYPH|UEV_DalosAccount (account:string)) ;;1
    (defun GLYPH|UEV_MsDc:bool (multi-s:string))
    (defun IGNIS|UEV_VirtualState (state:bool))
    (defun IGNIS|UEV_VirtualOnCondition ())
    (defun IGNIS|UEV_NativeState (state:bool))
    (defun IGNIS|UEV_Patron (patron:string))

    (defun CAP_EnforceAccountOwnership (account:string)) ;;16

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
    (defun C_RotateGovernor (patron:string account:string governor:guard)) ;;1
    (defun C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool))
    (defun C_TransferDalosFuel (sender:string receiver:string amount:decimal))
    (defun IGNIS|C_Collect (patron:string active-account:string amount:decimal)) ;;32
    (defun IGNIS|C_CollectWT (patron:string active-account:string amount:decimal trigger:bool)) ;;11
    (defun KDA|C_Collect (sender:string amount:decimal)) ;;4
    (defun KDA|C_CollectWT (sender:string amount:decimal trigger:bool))

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

(interface DemiourgosPactTrueFungible
    (defun CT_DefaultBranding ()) ;;1
    (defun CT_SocialEmpty ()) ;;1

    (defun UR_P-KEYS:[string] ()) ;;1
    (defun UR_KEYS:[string] ()) ;;1
    ;(defun UR_Branding:object{DalosSchemas.BrandingSchema} (id:string pending:bool))
    (defun URB_Logo:string (id:string pending:bool))
    (defun URB_Description:string (id:string pending:bool))
    (defun URB_Website:string (id:string pending:bool))
    ;(defun URB_Social:[object{DalosSchemas.SocialSchema}] (id:string pending:bool))
    (defun URB_Flag:integer (id:string pending:bool))
    (defun URB_Genesis:time (id:string pending:bool))
    (defun URB_PremiumUntil:time (id:string pending:bool))
    (defun UR_Konto:string (id:string))
    (defun UR_Name:string (id:string))
    (defun UR_Ticker:string (id:string))
    (defun UR_Decimals:integer (id:string)) ;;6
    (defun UR_CanChangeOwner:bool (id:string))
    (defun UR_CanUpgrade:bool (id:string))
    (defun UR_CanAddSpecialRole:bool (id:string))
    (defun UR_CanFreeze:bool (id:string))
    (defun UR_CanWipe:bool (id:string))
    (defun UR_CanPause:bool (id:string))
    (defun UR_Paused:bool (id:string))
    (defun UR_Supply:decimal (id:string)) ;;1
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
    (defun UR_RewardToken:[string] (id:string)) ;;3
    (defun UR_RewardBearingToken:[string] (id:string)) ;;3
    (defun UR_Vesting:string (id:string)) ;;2
    (defun UR_Roles:[string] (id:string rp:integer))
    (defun UR_AccountSupply:decimal (id:string account:string)) ;;2
    (defun UR_AccountRoleBurn:bool (id:string account:string)) ;;2
    (defun UR_AccountRoleMint:bool (id:string account:string)) ;;1
    (defun UR_AccountRoleTransfer:bool (id:string account:string))
    (defun UR_AccountRoleFeeExemption:bool (id:string account:string)) ;;2
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
    (defun UEV_Amount (id:string amount:decimal)) ;;1
    (defun UEV_CheckID:bool (id:string))
    (defun UEV_id (id:string)) ;;5
    (defun UEV_Virgin (id:string))
    (defun UEV_FeeLockState (id:string state:bool))
    (defun UEV_FeeToggleState (id:string state:bool))
    (defun UEV_AccountMintState (id:string account:string state:bool))
    (defun UEV_AccountFeeExemptionState (id:string account:string state:bool))
    (defun UEV_EnforceMinimumAmount (id:string transfer-amount:decimal)) ;;1
    (defun UEV_Vesting (id:string existance:bool))

    (defun CAP_Owner (id:string)) ;;3

    (defun C_RotateOwnership (patron:string id:string new-owner:string))
    (defun C_DeployAccount (id:string account:string)) ;;4
    (defun C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool))
    (defun C_TogglePause (patron:string id:string toggle:bool))
    (defun C_ToggleTransferRole (patron:string id:string account:string toggle:bool))
    (defun C_Wipe (patron:string id:string atbw:string))
    (defun C_Burn (patron:string id:string account:string amount:decimal))
    (defun C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool))
    (defun C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool]))
    (defun C_IssueLP:string (patron:string account:string name:string ticker:string))
    (defun C_Mint (patron:string id:string account:string amount:decimal origin:bool))
    (defun C_SetFee (patron:string id:string fee:decimal))
    (defun C_SetFeeTarget (patron:string id:string target:string))
    (defun C_SetMinMove (patron:string id:string min-move-value:decimal))
    (defun C_ToggleFee (patron:string id:string toggle:bool))
    (defun C_ToggleFeeLock (patron:string id:string toggle:bool))

    ;(defun X_IssueFree:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] iz-lp:[bool]))
    (defun X_UpdateBranding (id:string pending:bool branding:object{DalosSchemas.BrandingSchema}))
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
    (defun X_DebitStandard (id:string account:string amount:decimal)) ;;2
    ;(defun X_Debit (id:string account:string amount:decimal))
    (defun X_ToggleFeeExemptionRole (id:string account:string toggle:bool)) ;;1
    (defun X_ToggleMintRole (id:string account:string toggle:bool)) ;;1
    (defun X_UpdateFeeVolume (id:string amount:decimal primary:bool)) ;;2
    (defun X_UpdateRewardToken (atspair:string id:string direction:bool)) ;;1
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
    ;(defun UR_Branding:object{DalosSchemas.BrandingSchema} (id:string pending:bool))
    (defun URB_Logo:string (id:string pending:bool))
    (defun URB_Description:string (id:string pending:bool))
    (defun URB_Website:string (id:string pending:bool))
    ;(defun URB_Social:[object{DalosSchemas.SocialSchema}] (id:string pending:bool))
    (defun URB_Flag:integer (id:string pending:bool))
    (defun URB_Genesis:time (id:string pending:bool))
    (defun URB_PremiumUntil:time (id:string pending:bool))
    (defun UR_Konto:string (id:string))
    (defun UR_Name:string (id:string))
    (defun UR_Ticker:string (id:string))
    (defun UR_Decimals:integer (id:string))
    (defun UR_CanChangeOwner:bool (id:string))
    (defun UR_CanUpgrade:bool (id:string))
    (defun UR_CanAddSpecialRole:bool (id:string))
    (defun UR_CanFreeze:bool (id:string))
    (defun UR_CanWipe:bool (id:string))
    (defun UR_CanPause:bool (id:string))
    (defun UR_Paused:bool (id:string))
    (defun UR_Supply:decimal (id:string)) ;;1
    (defun UR_TransferRoleAmount:integer (id:string)) ;;1
    (defun UR_Vesting:string (id:string))
    (defun UR_Roles:[string] (id:string rp:integer))
    (defun UR_CanTransferNFTCreateRole:bool (id:string))
    (defun UR_CreateRoleAccount:string (id:string)) ;;2
    (defun UR_NoncesUsed:integer (id:string))
    (defun UR_RewardBearingToken:string (id:string)) ;;3
    (defun UR_AccountSupply:decimal (id:string account:string))
    (defun UR_AccountRoleBurn:bool (id:string account:string)) ;;1
    (defun UR_AccountRoleTransfer:bool (id:string account:string)) ;;2
    (defun UR_AccountFrozenState:bool (id:string account:string))
    (defun UR_AccountUnit:[object] (id:string account:string))
    (defun UR_AccountBalances:[decimal] (id:string account:string))
    (defun UR_AccountBatchMetaData (id:string nonce:integer account:string))
    (defun UR_AccountBatchSupply:decimal (id:string nonce:integer account:string))
    (defun UR_AccountNonces:[integer] (id:string account:string))
    (defun UR_AccountRoleNFTAQ:bool (id:string account:string)) ;;1
    (defun UR_AccountRoleCreate:bool (id:string account:string)) ;;1

    (defun URC_IzRBT:bool (reward-bearing-token:string)) ;;2
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
    (defun UEV_id (id:string)) ;;1
    (defun UEV_CanTransferNFTCreateRoleON (id:string))
    (defun UEV_AccountAddQuantityState (id:string account:string state:bool))
    (defun UEV_AccountCreateState (id:string account:string state:bool))
    (defun UEV_Vesting (id:string existance:bool)) ;;1

    (defun UDC_Compose:object{DPMF|Schema} (nonce:integer balance:decimal meta-data:[object]))
    (defun UDC_Nonce-Balance:[object{DPMF|Nonce-Balance}] (nonce-lst:[integer] balance-lst:[decimal]))

    (defun CAP_Owner (id:string)) ;;1

    (defun C_RotateOwnership (patron:string id:string new-owner:string))
    (defun C_DeployAccount (id:string account:string))
    (defun C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool))
    (defun C_TogglePause (patron:string id:string toggle:bool))
    (defun C_ToggleTransferRole (patron:string id:string account:string toggle:bool))
    (defun C_Wipe (patron:string id:string atbw:string))
    (defun C_AddQuantity (patron:string id:string nonce:integer account:string amount:decimal))
    (defun C_Burn (patron:string id:string nonce:integer account:string amount:decimal))
    (defun C_Control (patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool))
    (defun C_Create:integer (patron:string id:string account:string meta-data:[object]))
    (defun C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool]))
    (defun C_Mint:integer (patron:string id:string account:string amount:decimal meta-data:[object]))
    (defun C_Transfer (patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool))
    (defun C_MultiBatchTransfer (patron:string id:string nonces:[integer] sender:string receiver:string method:bool))
    (defun C_SingleBatchTransfer (patron:string id:string nonce:integer sender:string receiver:string method:bool))

    (defun X_UpdateElite (id:string sender:string receiver:string)) ;;1
    (defun X_UpdateVesting (dptf:string dpmf:string))
    (defun X_IssueFree:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool]))
    (defun X_UpdateBranding (id:string pending:bool branding:object{DalosSchemas.BrandingSchema}))
    ;(defun X_ChangeOwnership (id:string new-owner:string))
    ;(defun X_ToggleFreezeAccount (id:string account:string toggle:bool))
    ;(defun X_TogglePause (id:string toggle:bool))
    ;(defun X_ToggleTransferRole (id:string account:string toggle:bool))
    ;(defun X_UpdateRoleTransferAmount (id:string direction:bool))
    ;(defun X_UpdateSupply (id:string amount:decimal direction:bool))
    ;(defun X_Wipe (id:string account-to-be-wiped:string))
    (defun X_ToggleBurnRole (id:string account:string toggle:bool)) ;;1
    (defun X_UpdateRewardBearingToken (atspair:string id:string))
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

    (defun GOV|ATS|SC_NAME ()) ;;2
    (defun GOV|ATS|SC_KDA-NAME ())

    (defun UR_P-KEYS:[string] ()) ;;1
    (defun UR_KEYS:[string] ()) ;;1
    (defun UR_OwnerKonto:string (atspair:string))
    (defun UR_CanChangeOwner:bool (atspair:string))
    (defun UR_Lock:bool (atspair:string))
    (defun UR_Unlocks:integer (atspair:string))
    (defun UR_IndexName:string (atspair:string))
    (defun UR_IndexDecimals:integer (atspair:string))
    (defun UR_Syphon:decimal (atspair:string))
    (defun UR_Syphoning:bool (atspair:string))
    (defun UR_RewardTokens:[object{ATS|RewardTokenSchema}] (atspair:string))
    (defun UR_ColdRewardBearingToken:string (atspair:string))
    (defun UR_ColdNativeFeeRedirection:bool (atspair:string)) ;;1
    (defun UR_ColdRecoveryPositions:integer (atspair:string))
    (defun UR_ColdRecoveryFeeThresholds:[decimal] (atspair:string))
    (defun UR_ColdRecoveryFeeTable:[[decimal]] (atspair:string))
    (defun UR_ColdRecoveryFeeRedirection:bool (atspair:string))
    (defun UR_ColdRecoveryDuration:[integer] (atspair:string))
    (defun UR_EliteMode:bool (atspair:string))
    (defun UR_HotRewardBearingToken:string (atspair:string))
    (defun UR_HotRecoveryStartingFeePromile:decimal (atspair:string))
    (defun UR_HotRecoveryDecayPeriod:integer (atspair:string))
    (defun UR_HotRecoveryFeeRedirection:bool (atspair:string))
    (defun UR_ToggleColdRecovery:bool (atspair:string))
    (defun UR_ToggleHotRecovery:bool (atspair:string))
    (defun UR_RewardTokenList:[string] (atspair:string))
    (defun UR_RoUAmountList:[decimal] (atspair:string rou:bool))
    (defun UR_RT-Data (atspair:string reward-token:string data:integer)) ;;1
    (defun UR_RtPrecisions:[integer] (atspair:string))
    (defun UR_P0:[object{Ouronet4Ats.Awo}] (atspair:string account:string))
    (defun UR_P1-7:object{Ouronet4Ats.Awo} (atspair:string account:string position:integer))

    (defun URC_PosObjSt:integer (atspair:string input-obj:object{Ouronet4Ats.Awo}))
    (defun URC_MaxSyphon:[decimal] (atspair:string))
    (defun URC_CullValue:[decimal] (atspair:string input:object{Ouronet4Ats.Awo}))
    (defun URC_AccountUnbondingBalance (atspair:string account:string reward-token:string))
    (defun URC_UnstakeObjectUnbondingValue (atspair:string reward-token:string io:object{Ouronet4Ats.Awo}))
    (defun URC_RewardTokenPosition:integer (atspair:string reward-token:string))
    (defun URC_WhichPosition:integer (atspair:string c-rbt-amount:decimal account:string))
    (defun URC_ElitePosition:integer (atspair:string c-rbt-amount:decimal account:string))
    (defun URC_NonElitePosition:integer (atspair:string account:string))
    (defun URC_PSL:[integer] (atspair:string account:string))
    (defun URC_PosSt:integer (atspair:string account:string position:integer))
    (defun URC_ColdRecoveryFee (atspair:string c-rbt-amount:decimal input-position:integer))
    (defun URC_CullColdRecoveryTime:time (atspair:string account:string))
    (defun URC_RTSplitAmounts:[decimal] (atspair:string rbt-amount:decimal))
    (defun URC_Index (atspair:string))
    (defun URC_PairRBTSupply:decimal (atspair:string))
    (defun URC_RBT:decimal (atspair:string rt:string rt-amount:decimal))
    (defun URC_ResidentSum:decimal (atspair:string))
    (defun URC_IzPresentHotRBT:bool (atspair:string))

    (defun UEV_CanChangeOwnerON (atspair:string))
    (defun UEV_RewardTokenExistance (atspair:string reward-token:string existance:bool))
    (defun UEV_RewardBearingTokenExistance (atspair:string reward-bearing-token:string existance:bool cold-or-hot:bool))
    (defun UEV_HotRewardBearingTokenPresence (atspair:string enforced-presence:bool))
    (defun UEV_ParameterLockState (atspair:string state:bool))
    (defun UEV_SyphoningState (atspair:string state:bool))
    (defun UEV_FeeState (atspair:string state:bool fee-switch:integer))
    (defun UEV_EliteState (atspair:string state:bool))
    (defun UEV_RecoveryState (atspair:string state:bool cold-or-hot:bool))
    (defun UEV_UpdateColdOrHot (atspair:string cold-or-hot:bool))
    (defun UEV_UpdateColdAndHot (atspair:string))
    (defun UEV_id (atspair:string)) ;;1
    (defun UEV_IzTokenUnique (atspair:string reward-token:string))
    (defun UEV_IssueData (atspair:string index-decimals:integer reward-token:string reward-bearing-token:string))

    (defun UDC_MakeUnstakeObject:object{Ouronet4Ats.Awo} (atspair:string time:time))
    (defun UDC_MakeZeroUnstakeObject:object{Ouronet4Ats.Awo} (atspair:string))
    (defun UDC_MakeNegativeUnstakeObject:object{Ouronet4Ats.Awo} (atspair:string))
    (defun UDC_ComposePrimaryRewardToken:object{ATS|RewardTokenSchema} (token:string nfr:bool))
    (defun UDC_RT:object{ATS|RewardTokenSchema} (token:string nfr:bool r:decimal u:decimal))

    (defun CAP_Owner (id:string))

    (defun C_Issue:[string] (patron:string account:string atspair:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string] rbt-nfr:[bool]))
    (defun C_ToggleFeeSettings (patron:string atspair:string toggle:bool fee-switch:integer))
    (defun C_TurnRecoveryOff (patron:string atspair:string cold-or-hot:bool))
    (defun DPTF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool))
    (defun DPTF|C_ToggleFeeExemptionRole (patron:string id:string account:string toggle:bool))
    (defun DPTF|C_ToggleMintRole (patron:string id:string account:string toggle:bool))
    (defun DPMF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool))
    (defun DPMF|C_MoveCreateRole (patron:string id:string receiver:string))
    (defun DPMF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool))

    (defun X_ChangeOwnership (atspair:string new-owner:string))
    (defun X_ModifyCanChangeOwner (atspair:string new-boolean:bool))
    (defun X_ToggleParameterLock:[decimal] (atspair:string toggle:bool))
    (defun X_IncrementParameterUnlocks (atspair:string))
    (defun X_UpdateSyphon (atspair:string syphon:decimal))
    (defun X_ToggleSyphoning (atspair:string toggle:bool))
    (defun X_ToggleFeeSettings (atspair:string toggle:bool fee-switch:integer))
    (defun X_SetCRD (atspair:string soft-or-hard:bool base:integer growth:integer))
    (defun X_SetColdFee (atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]]))
    (defun X_SetHotFee (atspair:string promile:decimal decay:integer))
    (defun X_ToggleElite (atspair:string toggle:bool))
    (defun X_TurnRecoveryOn (atspair:string cold-or-hot:bool))
    (defun X_TurnRecoveryOff (atspair:string cold-or-hot:bool))
    (defun X_Issue:string (account:string atspair:string index-decimals:integer reward-token:string rt-nfr:bool reward-bearing-token:string rbt-nfr:bool))
    (defun X_InsertNewATSPair (account:string atspair:string index-decimals:integer reward-token:string rt-nfr:bool reward-bearing-token:string rbt-nfr:bool))
    (defun X_AddSecondary (atspair:string reward-token:string rt-nfr:bool))
    (defun X_AddHotRBT (atspair:string hot-rbt:string))
    (defun X_ReshapeUnstakeAccount (atspair:string account:string rp:integer))
    (defun X_RemoveSecondary (atspair:string reward-token:string))
    (defun X_UpdateRoU (atspair:string reward-token:string rou:bool direction:bool amount:decimal)) ;;2
    (defun X_UpP0 (atspair:string account:string obj:[object{Ouronet4Ats.Awo}]))
    (defun X_UpP1 (atspair:string account:string obj:object{Ouronet4Ats.Awo}))
    (defun X_UpP2 (atspair:string account:string obj:object{Ouronet4Ats.Awo}))
    (defun X_UpP3 (atspair:string account:string obj:object{Ouronet4Ats.Awo}))
    (defun X_UpP4 (atspair:string account:string obj:object{Ouronet4Ats.Awo}))
    (defun X_UpP5 (atspair:string account:string obj:object{Ouronet4Ats.Awo}))
    (defun X_UpP6 (atspair:string account:string obj:object{Ouronet4Ats.Awo}))
    (defun X_UpP7 (atspair:string account:string obj:object{Ouronet4Ats.Awo}))
    (defun X_SpawnAutostakeAccount (atspair:string account:string))
    (defun XC_EnsureActivationRoles (patron:string atspair:string cold-or-hot:bool))
    (defun XC_SetMassRole (patron:string atspair:string burn-or-exemption:bool))
    (defun XC_RevokeBurn (patron:string id:string cold-or-hot:bool))
    (defun X_MassTurnColdRecoveryOff (patron:string id:string))
    (defun XC_RevokeFeeExemption (patron:string id:string))
    (defun XC_RevokeMint (patron:string id:string))
    (defun XC_RevokeCreateOrAddQ (patron:string id:string))
)

(interface TrueFungibleTransfer
    (defun DPTF-DPMF-ATS|UR_TableKeys:[string] (position:integer poi:bool))
    (defun DPTF-DPMF-ATS|UR_FilterKeysForInfo:[string] (account-or-token-id:string table-to-query:integer mode:bool))

    ;(defun URC_CPF_RT-RBT:[decimal] (id:string native-fee-amount:decimal))
    ;(defun URC_CPF_RBT:decimal (id:string native-fee-amount:decimal))
    ;(defun URC_CPF_RT:decimal (id:string native-fee-amount:decimal))
    ;(defun URC_NFR-Boolean_RT-RBT:[bool] (id:string ats-pairs:[string] rt-or-rbt:bool))
    ;(defun URC_BooleanDecimalCombiner:[decimal] (id:string amount:decimal milestones:integer boolean:[bool]))

    ;(defun UEV_AmountCheck:bool (id:string amount:decimal))
    ;(defun UEV_Pair_ID-Amount:bool (id-lst:[string] transfer-amount-lst:[decimal]))
    ;(defun UEV_Pair_Receiver-Amount:bool (id:string receiver-lst:[string] transfer-amount-lst:[decimal]))

    ;(defun UDC_Pair_ID-Amount:[object{DPTF|ID-Amount}] (id-lst:[string] transfer-amount-lst:[decimal]))
    ;(defun UDC_Pair_Receiver-Amount:[object{DPTF|Receiver-Amount}] (receiver-lst:[string] transfer-amount-lst:[decimal]))

    (defun C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal))
    (defun C_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool))
    (defun C_MultiTransfer (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
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
