;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
;;  DALOS Interfaces
;;
(interface OuronetPolicy
    @doc "Interface exposing OuronetPolicy Functions, which are needed for intermodule communication \
        \ Each Module must have these Functions for these Purposes"
    ;;
    (defschema P|S
        policy:guard
    )
    (defschema P|MS
        m-policies:[guard]
    )
    (defun P|UR:guard (policy-name:string)
        @doc "Reads a Policy from the local module Policy Table"
    )
    (defun P|UR_IMP:[guard] ()
        @doc "Reads the whole Intermodule Policy Guard Chain"
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        @doc "Adds a Policy in the local module Policy Table"
    )
    (defun P|A_AddIMP (policy-guard:guard)
        @doc "Add a Policy in the local Policy Guard Chain"
    )
    (defun P|A_Define ()
        @doc "Defines in each module the policies that are needed for intermodule communication"
    )
    (defun UEV_IMC ()
        @doc "Defines the Intermodule Guards"
    )
)
(interface IgnisCollector
    ;;
    ;;
    ;;  SCHEMAS
    ;;
    (defschema PrimedCumulator
        primed-cumulator:object{CompressedCumulator}
    )
    (defschema CompressedCumulator
        ignis-prices:[decimal]
        interactors:[string]
    )
    (defschema OutputCumulator
        cumulator-chain:[object{ModularCumulator}]
        output:list
    )
    (defschema ModularCumulator
        ignis:decimal
        interactor:string
    )
    ;;
    ;;
    ;;  [URC] Functions
    ;;
    (defun IC|URC_Exception (account:string))
    (defun IC|URC_ZeroEliteGAZ (sender:string receiver:string))
    (defun IC|URC_ZeroGAZ:bool (id:string sender:string receiver:string))
    (defun IC|URC_ZeroGAS:bool (id:string sender:string))
    (defun IC|URC_IsVirtualGasZeroAbsolutely:bool (id:string))
    (defun IC|URC_IsVirtualGasZero:bool ())
    (defun IC|URC_IsNativeGasZero:bool ())
    ;;
    ;;
    ;;  [UEV] Functions
    ;;
    (defun IC|UEV_VirtualState (state:bool))
    (defun IC|UEV_VirtualOnCondition ())
    (defun IC|UEV_NativeState (state:bool))
    (defun IC|UEV_Patron (patron:string))
    ;;
    ;;
    ;;  [UDC] Functions
    ;;
    (defun IC|UDC_BrandingCumulator:object{OutputCumulator} (active-account:string multiplier:decimal))
    (defun IC|UDC_SmallestCumulator:object{OutputCumulator} (active-account:string))
    (defun IC|UDC_SmallCumulator:object{OutputCumulator} (active-account:string))
    (defun IC|UDC_MediumCumulator:object{OutputCumulator} (active-account:string))
    (defun IC|UDC_BigCumulator:object{OutputCumulator} (active-account:string))
    (defun IC|UDC_BiggestCumulator:object{OutputCumulator} (active-account:string))
        ;;
    (defun IC|UDC_ConstructOutputCumulator:object{OutputCumulator} (price:decimal active-account:string trigger:bool output-lst:list))
    (defun IC|UDC_MakeModularCumulator:object{ModularCumulator} (price:decimal active-account:string trigger:bool))
    (defun IC|UDC_MakeOutputCumulator:object{OutputCumulator} (input-modular-cumulator-chain:[object{ModularCumulator}] output-lst:list))
    (defun IC|UDC_ConcatenateOutputCumulators:object{OutputCumulator} (input-output-cumulator-chain:[object{OutputCumulator}] new-output-lst:list))
    (defun IC|UDC_CompressOutputCumulator:object{CompressedCumulator} (input-output-cumulator:object{OutputCumulator}))
    (defun IC|UDC_PrimeIgnisCumulator:object{PrimedCumulator} (patron:string input:object{CompressedCumulator}))
    ;;
    ;;
    ;;  []C] Functions
    ;;
    ;;
    (defun IC|C_Collect (patron:string input-output-cumulator:object{OutputCumulator}))
)
(interface OuronetDalosV4
    @doc "Interface Exposing DALOS Module Functions \
        \ UR(Utility-Read), URC(Utility-Read-Compute), UEV(Utility-Enforce-Validate) \
        \ are NOT sorted alphabetically \
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
        \ V3 Removes <patron> input variable where it is not needed \
        \ V4 Moves Cumulator Architecture in its own Interface"
    ;;
    ;;
    (defschema DPTF|BalanceSchema
        @doc "Schema that Stores Account Balances for DPTF Tokens (True Fungibles)\
            \ Key for the Table is a string composed of: <DPTF id> + BAR + <account> \
            \ This ensure a single entry per DPTF id per account. \
            \ As an Exception OUROBOROS and IGNIS Account Data is Stored at the DALOS Account Level"
        exist:bool
        balance:decimal
        role-burn:bool
        role-mint:bool
        role-transfer:bool
        role-fee-exemption:bool
        frozen:bool
    )
    ;;
    ;;
    (defun DALOS|SetGovernor (patron:string))
    ;;
    ;;
    (defun GOV|DALOS|SC_KDA-NAME ())
    (defun GOV|DALOS|GUARD ())
    ;;
    (defun GOV|Demiurgoi ())
    (defun GOV|DalosKey ())
    (defun GOV|AutostakeKey ())
    (defun GOV|VestingKey ())
    (defun GOV|LiquidKey ())
    (defun GOV|OuroborosKey ())
    (defun GOV|SwapKey ())
    (defun GOV|DHVKey ())
    ;;
    (defun GOV|DALOS|SC_NAME ())
    (defun GOV|ATS|SC_NAME ())
    (defun GOV|VST|SC_NAME ())
    (defun GOV|LIQUID|SC_NAME ())
    (defun GOV|OUROBOROS|SC_NAME ())
    (defun GOV|SWP|SC_NAME ())
    (defun GOV|DHV1|SC_NAME ())
    (defun GOV|DHV2|SC_NAME ())
    ;;
    (defun GOV|DALOS|PBL ())
    (defun GOV|ATS|PBL ())
    (defun GOV|VST|PBL ())
    (defun GOV|LIQUID|PBL ())
    (defun GOV|OUROBOROS|PBL ())
    (defun GOV|SWP|PBL ())
    (defun GOV|DHV|PBL ())
    ;;
    (defun DALOS|Info ())
    (defun DALOS|VirtualGasData ())
    ;;
    ;;
    (defun UR_KadenaLedger:[string] (kadena:string))
    (defun UR_GAP:bool ())
    (defun UR_DemiurgoiID:[string] ())
    (defun UR_UnityID:string ())
    (defun UR_OuroborosID:string ())
    (defun UR_OuroborosPrice:decimal ())
    (defun UR_IgnisID:string ())
    (defun UR_AurynID:string ())
    (defun UR_EliteAurynID:string ())
    (defun UR_WrappedKadenaID:string ())
    (defun UR_LiquidKadenaID:string ())
    (defun UR_DispoType:integer ())
    (defun UR_DispoTDP:decimal ())
    (defun UR_DispoTDS:decimal ())
    (defun UR_OuroAutoPriceUpdate:bool ())
    (defun UR_Tanker:string ())
    (defun UR_VirtualToggle:bool ())
    (defun UR_VirtualSpent:decimal ())
    (defun UR_NativeToggle:bool ())
    (defun UR_NativeSpent:decimal ())
    (defun UR_AutoFuel:bool ())
    (defun UR_UsagePrice:decimal (action:string))
    (defun UR_AccountPublicKey:string (account:string))
    (defun UR_AccountGuard:guard (account:string))
    (defun UR_AccountKadena:string (account:string))
    (defun UR_AccountSovereign:string (account:string))
    (defun UR_AccountGovernor:guard (account:string))
    (defun UR_AccountProperties:[bool] (account:string))
    (defun UR_AccountType:bool (account:string))
    (defun UR_AccountPayableAs:bool (account:string))
    (defun UR_AccountPayableBy:bool (account:string))
    (defun UR_AccountPayableByMethod:bool (account:string))
    (defun UR_AccountNonce:integer (account:string))
    (defun UR_Elite (account:string))
    (defun UR_Elite-Class (account:string))
    (defun UR_Elite-Name (account:string))
    (defun UR_Elite-Tier (account:string))
    (defun UR_Elite-Tier-Major:integer (account:string))
    (defun UR_Elite-Tier-Minor:integer (account:string))
    (defun UR_Elite-DEB (account:string))
    (defun UR_TrueFungible:object{DPTF|BalanceSchema} (account:string snake-or-gas:bool))
    (defun UR_TF_AccountSupply:decimal (account:string snake-or-gas:bool))
    (defun UR_TF_AccountRoleBurn:bool (account:string snake-or-gas:bool))
    (defun UR_TF_AccountRoleMint:bool (account:string snake-or-gas:bool))
    (defun UR_TF_AccountRoleTransfer:bool (account:string snake-or-gas:bool))
    (defun UR_TF_AccountRoleFeeExemption:bool (account:string snake-or-gas:bool))
    (defun UR_TF_AccountFreezeState:bool (account:string snake-or-gas:bool))
    ;;
    (defun URC_IgnisGasDiscount:decimal (account:string))
    (defun URC_KadenaGasDiscount:decimal (account:string))
    (defun URC_GasDiscount:decimal (account:string native:bool))
    (defun URC_SplitKDAPrices:[decimal] (account:string kda-price:decimal))
    (defun URC_Transferability:bool (sender:string receiver:string method:bool))
    ;;
    (defun UEV_StandardAccOwn (account:string))
    (defun UEV_SmartAccOwn (account:string))
    (defun UEV_Methodic (account:string method:bool))
    (defun UEV_EnforceAccountExists (dalos-account:string))
    (defun UEV_EnforceAccountType (account:string smart:bool))
    (defun UEV_EnforceTransferability (sender:string receiver:string method:bool))
    (defun UEV_SenderWithReceiver (sender:string receiver:string))
    (defun UEV_TwentyFourPrecision (amount:decimal))
    (defun GLYPH|UEV_DalosAccountCheck (account:string))
    (defun GLYPH|UEV_DalosAccount (account:string))
    (defun GLYPH|UEV_MsDc:bool (multi-s:string))
    
    ;;
    ;;
    (defun CAP_EnforceAccountOwnership (account:string))
    ;;
    ;;
    (defun A_MigrateLiquidFunds:decimal (migration-target-kda-account:string))
    (defun A_ToggleOAPU (oapu:bool))
    (defun A_ToggleGAP (gap:bool))
    (defun A_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun A_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun A_IgnisToggle (native:bool toggle:bool))
    (defun A_SetIgnisSourcePrice (price:decimal))
    (defun A_UpdatePublicKey (account:string new-public:string))
    (defun A_UpdateUsagePrice (action:string new-price:decimal))
    ;;
    (defun C_ControlSmartAccount:object{IgnisCollector.OutputCumulator} (account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool))
    (defun C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun C_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun C_RotateGovernor:object{IgnisCollector.OutputCumulator} (account:string governor:guard))
    (defun C_RotateGuard:object{IgnisCollector.OutputCumulator} (account:string new-guard:guard safe:bool))
    (defun C_RotateKadena:object{IgnisCollector.OutputCumulator} (account:string kadena:string))
    (defun C_RotateSovereign:object{IgnisCollector.OutputCumulator} (account:string new-sovereign:string))
    ;;
    (defun C_TransferDalosFuel (sender:string receiver:string amount:decimal))
    (defun KDA|C_Collect (sender:string amount:decimal))
    (defun KDA|C_CollectWT (sender:string amount:decimal trigger:bool))

    (defun XB_UpdateBalance (account:string snake-or-gas:bool new-balance:decimal))
    (defun XB_UpdateOuroPrice (price:decimal))
    ;;
    (defun XE_ClearDispo (account:string))
    (defun XE_UpdateBurnRole (account:string snake-or-gas:bool new-burn:bool))
    (defun XE_UpdateElite (account:string amount:decimal))
    (defun XE_UpdateFeeExemptionRole (account:string snake-or-gas:bool new-fee-exemption:bool))
    (defun XE_UpdateFreeze (account:string snake-or-gas:bool new-freeze:bool))
    (defun XE_UpdateMintRole (account:string snake-or-gas:bool new-mint:bool))
    (defun XE_UpdateTransferRole (account:string snake-or-gas:bool new-transfer:bool))
    (defun XE_UpdateTreasury (type:integer tdp:decimal tds:decimal))
)
(interface OuronetInfoV2
    @doc "Holds Information Schema"
    ;;
    ;;
    ;;  SCHEMAS
    ;;
    (defschema ClientInfo
        pre-text:[string]
        post-text:[string]
        ignis:object{ClientIgnisCosts}
        kadena:object{ClientKadenaCosts}
    )
    (defschema ClientIgnisCosts
        ignis-discount:decimal
        ignis-full:decimal
        ignis-need:decimal
        ignis-text:string
    )
    (defschema ClientKadenaCosts
        kadena-discount:decimal
        kadena-full:decimal
        kadena-need:decimal
        kadena-split:[decimal]
        kadena-targets:[string]
        kadena-text:string
    )
    ;;
    ;;
    ;;  [UC] Functions
    ;;
    (defun OI|UC_IfpFromOutputCumulator:decimal (input:object{IgnisCollector.OutputCumulator}))
    (defun OI|UC_ShortAccount:string (account:string))
    (defun OI|UC_ConvertPrice:string (input-price:decimal))
    (defun OI|UC_FormatIndex:string (index:decimal))
    (defun OI|UC_FormatTokenAmount:string (amount:decimal))
    ;;
    ;;
    ;;  [UR] Functions
    ;;
    (defun OI|UR_KadenaTargets:[string] ())
    ;;
    ;;
    ;;  [UDC] Functions
    ;;
    (defun OI|UDC_ClientInfo:object{ClientInfo} (a:[string] b:[string] c:object{ClientIgnisCosts} d:object{ClientKadenaCosts}))
    (defun OI|UDC_ClientIgnisCosts:object{ClientIgnisCosts} (a:decimal b:decimal c:decimal d:string))
    (defun OI|UDC_ClientKadenaCosts:object{ClientKadenaCosts} (a:decimal b:decimal c:decimal d:[decimal] e:[string] f:string))
        ;;
    (defun OI|UDC_FullKadenaCosts:object{ClientKadenaCosts} (kfp:decimal))
    (defun OI|UDC_KadenaCosts:object{ClientKadenaCosts} (patron:string kfp:decimal))
    (defun OI|UDC_NoKadenaCosts:object{ClientKadenaCosts} ())
    (defun OI|UDC_DynamicKadenaCost:object{ClientKadenaCosts} (patron:string kfp:decimal))
        ;;
    (defun OI|UDC_IgnisCosts:object{ClientIgnisCosts} (patron:string ifp:decimal))
    (defun OI|UDC_NoIgnisCosts:object{ClientIgnisCosts} ())
    (defun OI|UDC_DynamicIgnisCost:object{ClientIgnisCosts} (patron:string ifp:decimal))
)
(interface DalosInfoV2
    @doc "Exposes Information Function for the Dalos Client Functions"
    ;;
    ;;
    ;;  [URC] Functions
    ;;
    (defun DALOS-INFO|URC_ControlSmartAccount:object{OuronetInfoV2.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_DeploySmartAccount:object{OuronetInfoV2.ClientInfo} (account:string))
    (defun DALOS-INFO|URC_DeployStandardAccount:object{OuronetInfoV2.ClientInfo} (account:string))
    (defun DALOS-INFO|URC_RotateGovernor:object{OuronetInfoV2.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_RotateGuard:object{OuronetInfoV2.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_RotateKadena:object{OuronetInfoV2.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_RotateSovereign:object{OuronetInfoV2.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_UpdateEliteAccount:object{OuronetInfoV2.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_UpdateEliteAccountSquared:object{OuronetInfoV2.ClientInfo} (patron:string sender:string receiver:string))
)
;;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
;;  BRANDING Interfaces
;;
(interface Branding
    @doc "Interface Exposing the Branding Functions needed to create the Branding Functionality \
    \ Entities are DPTF DPMF DPSF DPNF ATSPairs SWPairs \
    \ Should Future entities be added, they too can be branded via this module \
    \ UR(Utility-Read), URC(Utility-Read-Compute), UDC(Utility-Data-Composition) \
    \ are NOT sorted alphabetically"
    ;;
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
    ;;
    (defun UR_Branding:object{Schema} (id:string pending:bool))
    (defun UR_Logo:string (id:string pending:bool))
    (defun UR_Description:string (id:string pending:bool))
    (defun UR_Website:string (id:string pending:bool))
    (defun UR_Social:[object{SocialSchema}] (id:string pending:bool))
    (defun UR_Flag:integer (id:string pending:bool))
    (defun UR_Genesis:time (id:string pending:bool))
    (defun UR_PremiumUntil:time (id:string pending:bool))
    ;;
    (defun URC_MaxBluePayment (account:string))
    ;;
    (defun UDC_BrandingLogo:object{Schema} (input:object{Schema} logo:string))
    (defun UDC_BrandingDescription:object{Schema} (input:object{Schema} description:string))
    (defun UDC_BrandingWebsite:object{Schema} (input:object{Schema} website:string))
    (defun UDC_BrandingSocial:object{Schema} (input:object{Schema} social:[object{SocialSchema}]))
    (defun UDC_BrandingFlag:object{Schema} (input:object{Schema} flag:integer))
    (defun UDC_BrandingPremium:object{Schema} (input:object{Schema} premium:time))
    ;;
    (defun A_Live (entity-id:string))
    (defun A_SetFlag (entity-id:string flag:integer))
    ;;
    (defun XE_Issue (entity-id:string))
    (defun XE_UpdatePendingBranding (entity-id:string logo:string description:string website:string social:[object{SocialSchema}]))
    (defun XE_UpgradeBranding:decimal (entity-id:string entity-owner-account:string months:integer))
)
(interface BrandingUsageV7
    @doc "Exposes Branding Functions for True-Fungibles (T), Meta-Fungibles (M), ATS-Pairs (A) and SWP-Pairs (S) \
        \ Uses V2 IgnisCumulatorV2 Architecture (fixed Ignis Collection for Smart Ouronet Accounts) \
        \ V4 Removes <patron> input variable where it is not needed"
    ;;
    (defun C_UpdatePendingBranding:object{IgnisCollector.OutputCumulator} (entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun C_UpgradeBranding (patron:string entity-id:string months:integer))
)
(interface BrandingUsageV8
    @doc "Exposes Branding Functions for True-Fungible LP Tokens \
        \ <entity-pos>: 1 (Native LP), 2 (Freezing LP), 3 (Sleeping LP) \
        \ Uses V2 IgnisCumulatorV2 Architecture (fixed Ignis Collection for Smart Ouronet Accounts) \
        \ V5 Removes <patron> input variable where it is not needed"
    ;;
    (defun C_UpdatePendingBrandingLPs:object{IgnisCollector.OutputCumulator} (swpair:string entity-pos:integer logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun C_UpgradeBrandingLPs (patron:string swpair:string entity-pos:integer months:integer))
)
;;V9 NOT Deployed
;;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
;;  DPTF Interfaces
;;
(interface DemiourgosPactTrueFungibleV5
    @doc "Exposes most of the Functions of the DPTF Module. \
    \ Later deployed modules (ATS and TFT), contain the rest of the DPTF Functions \
    \ UR(Utility-Read), URC(Utility-Read-Compute), UEV(Utility-Enforce-Validate) \
    \ are NOT sorted alphabetically \ 
    \ \
    \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
    \ Removes the 2 Branding Functions from this Interface, since they are in their own interface \
    \ \
    \ V3 Removes <patron> input variable where it is not needed \
    \ V4 Removes <URC_TrFeeMinExc> <UEV_EnforceMinimumAmount> \
    \ V4 Brings support for New Cumulator Architecture"
    ;;
    ;;
    (defun UC_VolumetricTax (id:string amount:decimal))
    (defun UC_TreasuryLowestDispo (ouro-supply:decimal ouro-precision:integer dispo-type:integer tdp:decimal tds:decimal))
    ;;
    (defun UR_P-KEYS:[string] ())
    (defun UR_KEYS:[string] ())
    ;;
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
    (defun UR_Supply:decimal (id:string))
    (defun UR_OriginMint:bool (id:string))
    (defun UR_OriginAmount:decimal (id:string))
    (defun UR_TransferRoleAmount:integer (id:string))
    (defun UR_FeeToggle:bool (id:string))
    (defun UR_MinMove:decimal (id:string))
    (defun UR_FeePromile:decimal (id:string))
    (defun UR_FeeTarget:string (id:string))
    (defun UR_FeeLock:bool (id:string))
    (defun UR_FeeUnlocks:integer (id:string))
    (defun UR_PrimaryFeeVolume:decimal (id:string))
    (defun UR_SecondaryFeeVolume:decimal (id:string))
    (defun UR_RewardToken:[string] (id:string))
    (defun UR_RewardBearingToken:[string] (id:string))
    (defun UR_Vesting:string (id:string))
    (defun UR_Sleeping:string (id:string))
    (defun UR_Frozen:string (id:string))
    (defun UR_Reservation:string (id:string))
    (defun UR_IzReservationOpen:bool (id:string))
    (defun UR_Roles:[string] (id:string rp:integer))
    (defun UR_AccountSupply:decimal (id:string account:string))
    (defun UR_AccountRoleBurn:bool (id:string account:string))
    (defun UR_AccountRoleMint:bool (id:string account:string))
    (defun UR_AccountRoleTransfer:bool (id:string account:string))
    (defun UR_AccountRoleFeeExemption:bool (id:string account:string))
    (defun UR_AccountFrozenState:bool (id:string account:string))
    ;;
    (defun URC_IzRT:bool (reward-token:string))
    (defun URC_IzRTg:bool (atspair:string reward-token:string))
    (defun URC_IzRBT:bool (reward-bearing-token:string))
    (defun URC_IzRBTg:bool (atspair:string reward-bearing-token:string))
    (defun URC_IzCoreDPTF:bool (id:string))
    (defun URC_AccountExist:bool (id:string account:string))
    (defun URC_Fee:[decimal] (id:string amount:decimal))
    (defun URC_HasVesting:bool (id:string))
    (defun URC_HasSleeping:bool (id:string))
    (defun URC_HasFrozen:bool (id:string))
    (defun URC_HasReserved:bool (id:string))
    (defun URC_Parent:string (dptf:string))
    (defun URC_TreasuryLowestDispo:decimal ())
    ;;
    (defun UEV_ParentOwnership (dptf:string))
    (defun UEV_id (id:string))
    (defun UEV_CheckID:bool (id:string))
    (defun UEV_Amount (id:string amount:decimal))
    (defun UEV_CheckAmount:bool (id:string amount:decimal))
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
    (defun UEV_Virgin (id:string))
    (defun UEV_FeeLockState (id:string state:bool))
    (defun UEV_FeeToggleState (id:string state:bool))
    (defun UEV_AccountMintState (id:string account:string state:bool))
    (defun UEV_AccountFeeExemptionState (id:string account:string state:bool))
    (defun UEV_Vesting (id:string existance:bool))
    (defun UEV_Sleeping (id:string existance:bool))
    (defun UEV_Frozen (id:string existance:bool))
    (defun UEV_Reserved (id:string existance:bool))
    ;;
    ;;
    (defun CAP_Owner (id:string))
    ;;
    (defun A_UpdateTreasury (type:integer tdp:decimal tds:decimal))
    (defun A_WipeTreasuryDebt ())
    (defun A_WipeTreasuryDebtPartial (debt-to-be-wiped:decimal))
    ;;
    (defun C_Burn:object{IgnisCollector.OutputCumulator} (id:string account:string amount:decimal))
    (defun C_Control:object{IgnisCollector.OutputCumulator} (id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool))
    (defun C_DeployAccount (id:string account:string))
    (defun C_Issue:object{IgnisCollector.OutputCumulator} (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool]))
    (defun C_Mint:object{IgnisCollector.OutputCumulator} (id:string account:string amount:decimal origin:bool))
    (defun C_RotateOwnership:object{IgnisCollector.OutputCumulator} (id:string new-owner:string))
    (defun C_SetFee:object{IgnisCollector.OutputCumulator} (id:string fee:decimal))
    (defun C_SetFeeTarget:object{IgnisCollector.OutputCumulator} (id:string target:string))
    (defun C_SetMinMove:object{IgnisCollector.OutputCumulator} (id:string min-move-value:decimal))
    (defun C_ToggleFee:object{IgnisCollector.OutputCumulator} (id:string toggle:bool))
    (defun C_ToggleFeeLock:object{IgnisCollector.OutputCumulator} (patron:string id:string toggle:bool))
    (defun C_ToggleFreezeAccount:object{IgnisCollector.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_TogglePause:object{IgnisCollector.OutputCumulator} (id:string toggle:bool))
    (defun C_ToggleReservation:object{IgnisCollector.OutputCumulator} (id:string toggle:bool))
    (defun C_ToggleTransferRole:object{IgnisCollector.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_Wipe:object{IgnisCollector.OutputCumulator} (id:string atbw:string))
    (defun C_WipePartial:object{IgnisCollector.OutputCumulator} (id:string atbw:string amtbw:decimal))
    ;;
    (defun XB_DeployAccountWNE (id:string account:string))
    (defun XB_Credit (id:string account:string amount:decimal))
    (defun XB_DebitStandard (id:string account:string amount:decimal dispo-data:object{UtilityDptf.DispoData}))
    (defun XB_IssueFree:object{IgnisCollector.OutputCumulator} (account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] iz-special:[bool]))
    (defun XB_WriteRoles (id:string account:string rp:integer d:bool))
    ;;
    (defun XE_Burn (id:string account:string amount:decimal))
    (defun XE_IssueLP:object{IgnisCollector.OutputCumulator} (name:string ticker:string))
    (defun XE_ToggleBurnRole (id:string account:string toggle:bool))
    (defun XE_ToggleFeeExemptionRole (id:string account:string toggle:bool))
    (defun XE_ToggleMintRole (id:string account:string toggle:bool))
    (defun XE_UpdateRewardBearingToken (atspair:string id:string))
    (defun XE_UpdateSpecialTrueFungible:object{IgnisCollector.OutputCumulator} (main-dptf:string secondary-dptf:string frozen-or-reserved:bool))
    (defun XE_UpdateVesting (dptf:string dpmf:string))
    (defun XE_UpdateSleeping (dptf:string dpmf:string))
    (defun XE_UpdateFeeVolume (id:string amount:decimal primary:bool))
    (defun XE_UpdateRewardToken (atspair:string id:string direction:bool))
)
(interface TrueFungibleTransferV6
    @doc "Exposes True Fungible Transfer Functions \
    \ V6 brings a revised V5 Architecture for Transfers, MultiTransfers and BulkTransfers. \
    \ For BulkTransfers, it compresses the BulkTransfer Logic in a MultiBulkTransfer Function, \
    \ which can also be used for BulkTransfers. \
    \ V6 Modifications remove a lot of redundant code in the TFT Module."
    ;;
    (defun UC_TransferCumulator:object{IgnisCollector.OutputCumulator} (type:integer id:string sender:string receiver:string))
    (defun UC_BulkRemainders:[decimal] (id:string transfer-amount-lst:[decimal]))
    (defun UC_BulkFees:[decimal] (id:string transfer-amount-lst:[decimal]))
    (defun UC_ContainsEliteAurynz:bool (id-lst:[string]))
    ;;
    (defun DPTF-DPMF-ATS|UR_OwnedTokens (account:string table-to-query:integer))
    (defun DPTF-DPMF-ATS|UR_FilterKeysForInfo:[string] (account-or-token-id:string table-to-query:integer mode:bool))
    (defun DPTF-DPMF-ATS|UR_TableKeys:[string] (position:integer poi:bool))
    ;;
    (defun ATS|URC_RT-Unbonding (atspair:string reward-token:string))
    (defun URC_MinimumOuro:decimal (account:string))
    (defun URC_VirtualOuro:decimal (account:string))
        ;;
    (defun URC_UnityTransferIgnisPrice (transfer-amount:decimal))
    (defun URC_TransferClasses:integer (id:string sender:string receiver:string amount:decimal))
    (defun URC_TransferClassesForBulk:integer (id:string sender:string))
    (defun URC_IzSimpleTransferForBulk:bool (id:string sender:string))
    (defun URC_IzSimpleTransfer:bool (id:string sender:string receiver:string amount:decimal))
    (defun URC_IzTrueFungibleEliteAuryn:bool (id:string))
    (defun URC_IzTrueFungibleUnity:bool (id:string))
    (defun URC_AreTrueFungiblesEliteAurynz:bool (id:string))
    (defun URC_TransferRoleChecker:bool (id:string sender:string))
    ;;
    (defun UEV_IzSimpleTransfer (id:string sender:string receiver:string amount:decimal iz-or-not:bool))
    (defun UEV_IzSimpleTransferForBulk (id:string sender:string iz-or-not:bool))
    (defun UEV_AreTrueFungiblesEliteAurynz (id:string iz-or-not:bool))
    (defun UEV_TrueFungibleAsEliteAuryn:bool (id:string iz-or-not:bool))
    (defun UEV_TrueFungibleAsUnity:bool (id:string iz-or-not:bool))
    (defun UEV_Minimum (id:string amount:decimal))
    (defun UEV_DispoLocker (id:string account:string))
    (defun UEV_VTT (id:string iz-vtt:bool))
    (defun UEV_TransferRolesComplex (id:string sender:string receiver:string))
    (defun UEV_TransferRolesSimple (id:string sender:string receiver:string))
    (defun UEV_TransferRoleChecker (trc:bool s:bool r:bool))
        ;;
    (defun UEV_BulkTransfer (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal]))
    (defun UEV_MinimumMapperForBulk (id:string transfer-amount-lst:[decimal]))
        ;;
    (defun UEV_MultiTransfer (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
    ;;
    (defun UDC_SmallTransmuteCumulator:object{IgnisCollector.OutputCumulator} (id:string transmuter:string))
    (defun UDC_LargeTransmuteCumulator:object{IgnisCollector.OutputCumulator} (id:string transmuter:string))
        ;;
    (defun UDC_UnityTransferCumulator:object{IgnisCollector.OutputCumulator} (sender:string receiver:string amount:decimal))
    (defun UDC_SmallTransferCumulator:object{IgnisCollector.OutputCumulator} (id:string sender:string receiver:string))
    (defun UDC_MediumTransferCumulator:object{IgnisCollector.OutputCumulator} (id:string sender:string receiver:string))
    (defun UDC_LargeTransferCumulator:object{IgnisCollector.OutputCumulator} (sender:string receiver:string))
    (defun UDC_EliteExchangeCumulator:object{IgnisCollector.OutputCumulator} (sender:string smart-intermediary:string amplifier:integer))
    (defun UDC_GetDispoData:object{UtilityDptf.DispoData} (account:string))
        ;;
    (defun UDC_MultiTransferCumulator:object{IgnisCollector.OutputCumulator} (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal]))
        ;;
    (defun UDC_BulkTransferCumulator:object{IgnisCollector.OutputCumulator} (id:string sender:string size:integer price:decimal))
    (defun UDC_UnityBulkTransferCumulator:object{IgnisCollector.OutputCumulator} (sender:string receiver-lst:[string] transfer-amount-lst:[decimal]))
    (defun UDC_SimpleBulkTransferCumulator:object{IgnisCollector.OutputCumulator} (id:string sender:string size:integer))
    (defun UDC_ComplexBulkTransferCumulator:object{IgnisCollector.OutputCumulator} (id:string sender:string size:integer))
    (defun UDC_EliteBulkTransferCumulator:object{IgnisCollector.OutputCumulator} (id:string sender:string size:integer))
    ;;
    ;;
    (defun C_ClearDispo:object{IgnisCollector.OutputCumulator} (account:string))
    (defun C_Transmute:object{IgnisCollector.OutputCumulator} (id:string transmuter:string transmute-amount:decimal))
    (defun C_Transfer:object{IgnisCollector.OutputCumulator} (id:string sender:string receiver:string transfer-amount:decimal method:bool))
    (defun C_MultiTransfer:object{IgnisCollector.OutputCumulator} (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
    (defun C_MultiBulkTransfer:object{IgnisCollector.OutputCumulator} (id-lst:[string] sender:string receiver-array:[[string]] transfer-amount-array:[[decimal]]))
)
(interface TrueFungibleTransferV7
    @doc "Exposes True Fungible Transfer Functions \
    \ V6 brings a revised V5 Architecture for Transfers, MultiTransfers and BulkTransfers. \
    \ For BulkTransfers, it compresses the BulkTransfer Logic in a MultiBulkTransfer Function, \
    \ which can also be used for BulkTransfers. \
    \ V6 Modifications remove a lot of redundant code in the TFT Module. \
    \ V7 Add Cumulator for Bulk and MultiBulk Transfers."
    ;;
    (defun UC_TransferCumulator:object{IgnisCollector.OutputCumulator} (type:integer id:string sender:string receiver:string))
    (defun UC_BulkRemainders:[decimal] (id:string transfer-amount-lst:[decimal]))
    (defun UC_BulkFees:[decimal] (id:string transfer-amount-lst:[decimal]))
    (defun UC_ContainsEliteAurynz:bool (id-lst:[string]))
    ;;
    (defun DPTF-DPMF-ATS|UR_OwnedTokens (account:string table-to-query:integer))
    (defun DPTF-DPMF-ATS|UR_FilterKeysForInfo:[string] (account-or-token-id:string table-to-query:integer mode:bool))
    (defun DPTF-DPMF-ATS|UR_TableKeys:[string] (position:integer poi:bool))
    ;;
    (defun ATS|URC_RT-Unbonding (atspair:string reward-token:string))
    (defun URC_MinimumOuro:decimal (account:string))
    (defun URC_VirtualOuro:decimal (account:string))
        ;;
    (defun URC_ReceiverAmount:decimal (id:string sender:string receiver:string amount:decimal))
    (defun URC_UnityTransferIgnisPrice (transfer-amount:decimal))
    (defun URC_TransferClasses:integer (id:string sender:string receiver:string amount:decimal))
    (defun URC_TransferClassesForBulk:integer (id:string sender:string))
    (defun URC_IzSimpleTransferForBulk:bool (id:string sender:string))
    (defun URC_IzSimpleTransfer:bool (id:string sender:string receiver:string amount:decimal))
    (defun URC_IzTrueFungibleEliteAuryn:bool (id:string))
    (defun URC_IzTrueFungibleUnity:bool (id:string))
    (defun URC_AreTrueFungiblesEliteAurynz:bool (id:string))
    (defun URC_TransferRoleChecker:bool (id:string sender:string))
    ;;
    (defun UEV_IzSimpleTransfer (id:string sender:string receiver:string amount:decimal iz-or-not:bool))
    (defun UEV_IzSimpleTransferForBulk (id:string sender:string iz-or-not:bool))
    (defun UEV_AreTrueFungiblesEliteAurynz (id:string iz-or-not:bool))
    (defun UEV_TrueFungibleAsEliteAuryn:bool (id:string iz-or-not:bool))
    (defun UEV_TrueFungibleAsUnity:bool (id:string iz-or-not:bool))
    (defun UEV_Minimum (id:string amount:decimal))
    (defun UEV_DispoLocker (id:string account:string))
    (defun UEV_VTT (id:string iz-vtt:bool))
    (defun UEV_TransferRolesComplex (id:string sender:string receiver:string))
    (defun UEV_TransferRolesSimple (id:string sender:string receiver:string))
    (defun UEV_TransferRoleChecker (trc:bool s:bool r:bool))
        ;;
    (defun UEV_BulkTransfer (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal]))
    (defun UEV_MinimumMapperForBulk (id:string transfer-amount-lst:[decimal]))
        ;;
    (defun UEV_MultiTransfer (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
    ;;
    (defun UDC_SmallTransmuteCumulator:object{IgnisCollector.OutputCumulator} (id:string transmuter:string))
    (defun UDC_LargeTransmuteCumulator:object{IgnisCollector.OutputCumulator} (id:string transmuter:string))
        ;;
    (defun UDC_UnityTransferCumulator:object{IgnisCollector.OutputCumulator} (sender:string receiver:string amount:decimal))
    (defun UDC_SmallTransferCumulator:object{IgnisCollector.OutputCumulator} (id:string sender:string receiver:string))
    (defun UDC_MediumTransferCumulator:object{IgnisCollector.OutputCumulator} (id:string sender:string receiver:string))
    (defun UDC_LargeTransferCumulator:object{IgnisCollector.OutputCumulator} (sender:string receiver:string))
    (defun UDC_EliteExchangeCumulator:object{IgnisCollector.OutputCumulator} (sender:string smart-intermediary:string amplifier:integer))
    (defun UDC_GetDispoData:object{UtilityDptf.DispoData} (account:string))
        ;;
    (defun UDC_MultiTransferCumulator:object{IgnisCollector.OutputCumulator} (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal]))
    (defun UDC_MultiBulkTransferCumulator:object{IgnisCollector.OutputCumulator} (id-lst:[string] sender:string receiver-array:[[string]] transfer-amount-array:[[decimal]]))
    (defun UDC_BulkTransferCumulator:object{IgnisCollector.OutputCumulator} (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal]))    
        ;;
    (defun UDC_UnityBulkTransferCumulator:object{IgnisCollector.OutputCumulator} (sender:string receiver-lst:[string] transfer-amount-lst:[decimal]))
    (defun UDC_SimpleBulkTransferCumulator:object{IgnisCollector.OutputCumulator} (id:string sender:string size:integer))
    (defun UDC_ComplexBulkTransferCumulator:object{IgnisCollector.OutputCumulator} (id:string sender:string size:integer))
    (defun UDC_EliteBulkTransferCumulator:object{IgnisCollector.OutputCumulator} (id:string sender:string size:integer))
    ;;
    ;;
    (defun C_ClearDispo:object{IgnisCollector.OutputCumulator} (account:string))
    (defun C_Transmute:object{IgnisCollector.OutputCumulator} (id:string transmuter:string transmute-amount:decimal))
    (defun C_Transfer:object{IgnisCollector.OutputCumulator} (id:string sender:string receiver:string transfer-amount:decimal method:bool))
    (defun C_MultiTransfer:object{IgnisCollector.OutputCumulator} (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
    (defun C_MultiBulkTransfer:object{IgnisCollector.OutputCumulator} (id-lst:[string] sender:string receiver-array:[[string]] transfer-amount-array:[[decimal]]))
)
;;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
;;  DPMF Interface
;;
(interface DemiourgosPactMetaFungibleV5
    @doc "Exposes most of the Functions of the DPMF Module. \
    \ The ATS Module contains 3 more DPTF Functions that couldnt be brought here logisticaly \
    \ UR(Utility-Read), URC(Utility-Read-Compute), UEV(Utility-Enforce-Validate) and \
    \ UDC(Utility-Data-Composition) are NOT sorted alphabetically \
    \ \
    \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
    \ Removes the 2 Branding Functions from this Interface, since they are in their own interface. \
    \ \
    \ V3 adds 2 Functions related to single Elite Account Update. \
    \ \
    \ V4 Removes <patron> input variable where it is not needed"
    ;;
    ;;
    (defschema DPMF|Schema
        nonce:integer
        balance:decimal
        meta-data:[object]
    )
    (defschema DPMF|Nonce-Balance
        nonce:integer
        balance:decimal
    )
    ;;
    ;;
    (defun UR_P-KEYS:[string] ())
    (defun UR_KEYS:[string] ())
    ;;
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
    (defun UR_Supply:decimal (id:string))
    (defun UR_TransferRoleAmount:integer (id:string))
    (defun UR_Vesting:string (id:string))
    (defun UR_Sleeping:string (id:string))
    (defun UR_Roles:[string] (id:string rp:integer))
    (defun UR_CanTransferNFTCreateRole:bool (id:string))
    (defun UR_CreateRoleAccount:string (id:string))
    (defun UR_NoncesUsed:integer (id:string))
    (defun UR_RewardBearingToken:string (id:string))
    (defun UR_AccountSupply:decimal (id:string account:string))
    (defun UR_AccountRoleBurn:bool (id:string account:string))
    (defun UR_AccountRoleCreate:bool (id:string account:string))
    (defun UR_AccountRoleNFTAQ:bool (id:string account:string))
    (defun UR_AccountRoleTransfer:bool (id:string account:string))
    (defun UR_AccountFrozenState:bool (id:string account:string))
    ;;
    (defun UR_AccountUnit:[object{DPMF|Schema}] (id:string account:string))
    (defun UR_AccountNonces:[integer] (id:string account:string))
    (defun UR_AccountBalances:[decimal] (id:string account:string))
    (defun UR_AccountMetaDatas:[[object]] (id:string account:string))
        ;;
    (defun UR_AccountNonceBalance:decimal (id:string nonce:integer account:string))
    (defun UR_AccountNonceMetaData:[object] (id:string nonce:integer account:string))
        ;;
    (defun UR_AccountNoncesBalances:[decimal] (id:string nonces:[integer] account:string))
    (defun UR_AccountNoncesMetaDatas:[[object]] (id:string nonces:[integer] account:string))
    ;;
    (defun URC_IzRBT:bool (reward-bearing-token:string))
    (defun URC_IzRBTg:bool (atspair:string reward-bearing-token:string))
    (defun URC_EliteAurynzSupply (account:string))
    (defun URC_AccountExist:bool (id:string account:string))
    (defun URC_HasVesting:bool (id:string))
    (defun URC_HasSleeping:bool (id:string))
    (defun URC_Parent:string (dpmf:string))
    (defun URC_IzIdEA:bool (id:string))
    ;;
    (defun UEV_ParentOwnership (dpmf:string))
    (defun UEV_NoncesToAccount (id:string account:string nonces:[integer]))
    (defun UEV_id (id:string))
    (defun UEV_CheckID:bool (id:string))
    (defun UEV_Amount (id:string amount:decimal))
    (defun UEV_CheckAmount:bool (id:string amount:decimal))
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
    (defun UEV_CanTransferNFTCreateRoleON (id:string))
    (defun UEV_AccountAddQuantityState (id:string account:string state:bool))
    (defun UEV_AccountCreateState (id:string account:string state:bool))
    (defun UEV_Vesting (id:string existance:bool))
    (defun UEV_Sleeping (id:string existance:bool))
    ;;
    (defun UDC_Compose:object{DPMF|Schema} (nonce:integer balance:decimal meta-data:[object]))
    (defun UDC_Nonce-Balance:[object{DPMF|Nonce-Balance}] (nonce-lst:[integer] balance-lst:[decimal]))
    ;;
    ;;
    (defun CAP_Owner (id:string))
    ;;
    (defun C_AddQuantity:object{IgnisCollector.OutputCumulator} (id:string nonce:integer account:string amount:decimal))
    (defun C_Burn:object{IgnisCollector.OutputCumulator} (id:string nonce:integer account:string amount:decimal))
    (defun C_Control:object{IgnisCollector.OutputCumulator} (id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool))
    (defun C_Create:object{IgnisCollector.OutputCumulator} (id:string account:string meta-data:[object]))
    (defun C_DeployAccount (id:string account:string))
    (defun C_Issue:object{IgnisCollector.OutputCumulator} (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool]))
    (defun C_Mint:object{IgnisCollector.OutputCumulator} (id:string account:string amount:decimal meta-data:[object]))
    (defun C_MultiBatchTransfer:object{IgnisCollector.OutputCumulator} (id:string nonces:[integer] sender:string receiver:string method:bool))
    (defun C_RotateOwnership:object{IgnisCollector.OutputCumulator} (id:string new-owner:string))
    (defun C_SingleBatchTransfer:object{IgnisCollector.OutputCumulator} (id:string nonce:integer sender:string receiver:string method:bool))
    (defun C_ToggleFreezeAccount:object{IgnisCollector.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_TogglePause:object{IgnisCollector.OutputCumulator}  (id:string toggle:bool))
    (defun C_ToggleTransferRole:object{IgnisCollector.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_Transfer:object{IgnisCollector.OutputCumulator} (id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool))
    (defun C_Wipe:object{IgnisCollector.OutputCumulator} (id:string atbw:string))
    (defun C_WipePartial:object{IgnisCollector.OutputCumulator} (id:string atbw:string nonces:[integer]))
    ;;
    (defun XB_DeployAccountWNE (id:string account:string))
    (defun XB_IssueFree:object{IgnisCollector.OutputCumulator} (account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool] iz-special:[bool]))
    (defun XB_UpdateEliteSingle (id:string account:string))
    (defun XB_UpdateElite (id:string sender:string receiver:string))
    (defun XB_WriteRoles (id:string account:string rp:integer d:bool))
    ;;
    (defun XE_MoveCreateRole (id:string receiver:string))
    (defun XE_ToggleAddQuantityRole (id:string account:string toggle:bool))
    (defun XE_ToggleBurnRole (id:string account:string toggle:bool))
    (defun XE_UpdateRewardBearingToken (atspair:string id:string))
    (defun XE_UpdateSpecialMetaFungible:object{IgnisCollector.OutputCumulator} (main-dptf:string secondary-dpmf:string vesting-or-sleeping:bool))
)
;;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
;;  ATS Interfaces
;;
(interface AutostakeV4
    @doc "Exposes half of the Autostake Functions, the other Functions existing in the ATSU Module \
    \ Also contains a few DPTF and DPMF Functions \
    \ UR(Utility-Read), URC(Utility-Read-Compute), UEV(Utility-Enforce-Validate) and \
    \ UDC(Utility-Data-Composition) are NOT sorted alphabetically \
    \ \
    \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
    \ Removes the 2 Branding Functions from this Interface, since they are in their own interface.\
    \ \
    \ V3 Removes <patron> input variable where it is not needed"
    ;;
    ;;
    (defschema ATS|RewardTokenSchema
        token:string
        nfr:bool
        resident:decimal
        unbonding:decimal
    )
    (defschema ATS|Hot
        mint-time:time
    )
    ;;
    ;;
    (defun ATS|SetGovernor (patron:string))
    ;;
    ;;
    (defun UR_P-KEYS:[string] ())
    (defun UR_KEYS:[string] ())
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
    (defun UR_ColdNativeFeeRedirection:bool (atspair:string))
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
    (defun UR_RT-Data (atspair:string reward-token:string data:integer))
    (defun UR_RtPrecisions:[integer] (atspair:string))
    (defun UR_P0:[object{UtilityAts.Awo}] (atspair:string account:string))
    (defun UR_P1-7:object{UtilityAts.Awo} (atspair:string account:string position:integer))
    ;;
    (defun URC_PosObjSt:integer (atspair:string input-obj:object{UtilityAts.Awo}))
    (defun URC_MaxSyphon:[decimal] (atspair:string))
    (defun URC_CullValue:[decimal] (atspair:string input:object{UtilityAts.Awo}))
    (defun URC_AccountUnbondingBalance (atspair:string account:string reward-token:string))
    (defun URC_UnstakeObjectUnbondingValue (atspair:string reward-token:string io:object{UtilityAts.Awo}))
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
    ;;
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
    (defun UEV_id (atspair:string))
    (defun UEV_IzTokenUnique (atspair:string reward-token:string))
    (defun UEV_IssueData (atspair:string index-decimals:integer reward-token:string reward-bearing-token:string))
    ;;
    (defun UDC_MakeUnstakeObject:object{UtilityAts.Awo} (atspair:string tm:time))
    (defun UDC_MakeZeroUnstakeObject:object{UtilityAts.Awo} (atspair:string))
    (defun UDC_MakeNegativeUnstakeObject:object{UtilityAts.Awo} (atspair:string))
    (defun UDC_ComposePrimaryRewardToken:object{ATS|RewardTokenSchema} (token:string nfr:bool))
    (defun UDC_RT:object{ATS|RewardTokenSchema} (token:string nfr:bool r:decimal u:decimal))
    ;;
    ;;
    (defun CAP_Owner (id:string))
    ;;
    (defun C_Issue:object{IgnisCollector.OutputCumulator} (patron:string account:string atspair:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string] rbt-nfr:[bool]))
    (defun C_ToggleFeeSettings:object{IgnisCollector.OutputCumulator} (atspair:string toggle:bool fee-switch:integer))
    (defun C_TurnRecoveryOff:object{IgnisCollector.OutputCumulator} (atspair:string cold-or-hot:bool))
    ;;
    (defun DPMF|C_MoveCreateRole:object{IgnisCollector.OutputCumulator} (id:string receiver:string))
    (defun DPMF|C_ToggleAddQuantityRole:object{IgnisCollector.OutputCumulator} (id:string account:string toggle:bool))
    (defun DPMF|C_ToggleBurnRole:object{IgnisCollector.OutputCumulator} (id:string account:string toggle:bool))
    (defun DPTF|C_ToggleBurnRole:object{IgnisCollector.OutputCumulator} (id:string account:string toggle:bool))
    (defun DPTF|C_ToggleFeeExemptionRole:object{IgnisCollector.OutputCumulator} (id:string account:string toggle:bool))
    (defun DPTF|C_ToggleMintRole:object{IgnisCollector.OutputCumulator} (id:string account:string toggle:bool))
    ;;
    (defun XB_EnsureActivationRoles:object{IgnisCollector.OutputCumulator} (atspair:string cold-or-hot:bool))
    ;;
    (defun XE_AddHotRBT (atspair:string hot-rbt:string))
    (defun XE_AddSecondary (atspair:string reward-token:string rt-nfr:bool))
    (defun XE_ChangeOwnership (atspair:string new-owner:string))
    (defun XE_IncrementParameterUnlocks (atspair:string))
    (defun XE_ModifyCanChangeOwner (atspair:string new-boolean:bool))
    (defun XE_RemoveSecondary (atspair:string reward-token:string))
    (defun XE_ReshapeUnstakeAccount (atspair:string account:string rp:integer))
    (defun XE_SetColdFee (atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]]))
    (defun XE_SetCRD (atspair:string soft-or-hard:bool base:integer growth:integer))
    (defun XE_SetHotFee (atspair:string promile:decimal decay:integer))
    (defun XE_SpawnAutostakeAccount (atspair:string account:string))
    (defun XE_ToggleElite (atspair:string toggle:bool))
    (defun XE_ToggleParameterLock:[decimal] (atspair:string toggle:bool))
    (defun XE_ToggleSyphoning (atspair:string toggle:bool))
    (defun XE_TurnRecoveryOn (atspair:string cold-or-hot:bool))
    (defun XE_UpdateRoU (atspair:string reward-token:string rou:bool direction:bool amount:decimal))
    (defun XE_UpdateSyphon (atspair:string syphon:decimal))
    (defun XE_UpP0 (atspair:string account:string obj:[object{UtilityAts.Awo}]))
    (defun XE_UpP1 (atspair:string account:string obj:object{UtilityAts.Awo}))
    (defun XE_UpP2 (atspair:string account:string obj:object{UtilityAts.Awo}))
    (defun XE_UpP3 (atspair:string account:string obj:object{UtilityAts.Awo}))
    (defun XE_UpP4 (atspair:string account:string obj:object{UtilityAts.Awo}))
    (defun XE_UpP5 (atspair:string account:string obj:object{UtilityAts.Awo}))
    (defun XE_UpP6 (atspair:string account:string obj:object{UtilityAts.Awo}))
    (defun XE_UpP7 (atspair:string account:string obj:object{UtilityAts.Awo}))
)
(interface AutostakeUsageV4
    @doc "Exposes the last Batch of Client Autostake Functions \ 
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
        \ \
        \ V3 Removes <patron> input variable where it is not needed"
    ;;
    (defun C_AddHotRBT:object{IgnisCollector.OutputCumulator} (ats:string hot-rbt:string))
    (defun C_AddSecondary:object{IgnisCollector.OutputCumulator} (ats:string reward-token:string rt-nfr:bool))
    (defun C_Coil:object{IgnisCollector.OutputCumulator} (coiler:string ats:string rt:string amount:decimal))
    (defun C_ColdRecovery:object{IgnisCollector.OutputCumulator} (recoverer:string ats:string ra:decimal))
    (defun C_Cull:object{IgnisCollector.OutputCumulator} (culler:string ats:string))
    (defun C_Curl:object{IgnisCollector.OutputCumulator} (curler:string ats1:string ats2:string rt:string amount:decimal))
    (defun C_Fuel:object{IgnisCollector.OutputCumulator} (fueler:string ats:string reward-token:string amount:decimal))
    (defun C_HotRecovery:object{IgnisCollector.OutputCumulator} (recoverer:string ats:string ra:decimal))
    (defun C_KickStart:object{IgnisCollector.OutputCumulator} (kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal))
    (defun C_ModifyCanChangeOwner:object{IgnisCollector.OutputCumulator} (ats:string new-boolean:bool))
    (defun C_RecoverHotRBT:object{IgnisCollector.OutputCumulator} (recoverer:string id:string nonce:integer amount:decimal))
    (defun C_RecoverWholeRBTBatch:object{IgnisCollector.OutputCumulator} (recoverer:string id:string nonce:integer))
    (defun C_Redeem:object{IgnisCollector.OutputCumulator} (redeemer:string id:string nonce:integer))
    (defun C_RemoveSecondary:object{IgnisCollector.OutputCumulator} (remover:string ats:string reward-token:string))
    (defun C_RotateOwnership:object{IgnisCollector.OutputCumulator} (ats:string new-owner:string))
    (defun C_SetColdFee:object{IgnisCollector.OutputCumulator} (ats:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]]))
    (defun C_SetCRD:object{IgnisCollector.OutputCumulator} (ats:string soft-or-hard:bool base:integer growth:integer))
    (defun C_SetHotFee:object{IgnisCollector.OutputCumulator} (ats:string promile:decimal decay:integer))
    (defun C_Syphon:object{IgnisCollector.OutputCumulator} (syphon-target:string ats:string syphon-amounts:[decimal]))
    (defun C_ToggleElite:object{IgnisCollector.OutputCumulator} (ats:string toggle:bool))
    (defun C_ToggleParameterLock:object{IgnisCollector.OutputCumulator} (patron:string ats:string toggle:bool))
    (defun C_ToggleSyphoning:object{IgnisCollector.OutputCumulator} (ats:string toggle:bool))
    (defun C_TurnRecoveryOn:object{IgnisCollector.OutputCumulator} (ats:string cold-or-hot:bool))
    (defun C_UpdateSyphon:object{IgnisCollector.OutputCumulator} (ats:string syphon:decimal))
)
;;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
;;  VST,LIQUID,OUROBOROS Interfaces
;;
;;
(interface VestingV4
    @doc "Exposes Vesting Functions \
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
        \ \
        \ V3 Removes <patron> input variable where it is not needed \
        \ V4 Adds <UEV_StillHasSleeping>"
    ;;
    (defschema VST|MetaDataSchema
        release-amount:decimal
        release-date:time
    )
    ;;
    ;;
    (defun VST|SetGovernor (patron:string))
    ;;
    ;;
    (defun UC_MergeAll:[decimal] (balances:[decimal] seconds-to-unsleep:[decimal]))
    ;;
    (defun URC_CullMetaDataAmountWithObject:list (client:string id:string nonce:integer))
    (defun URC_CullMetaDataAmount:decimal (client:string id:string nonce:integer))
    (defun URC_CullMetaDataObject:[object{VST|MetaDataSchema}] (client:string id:string nonce:integer))
    (defun URC_SecondsToUnlock:[decimal] (dpmf:string account:string nonces:[integer]))
    ;;
    (defun UEV_NoncesForMerging (nonces:[integer]))
    (defun UEV_SpecialTokenRole (dptf:string))
    (defun UEV_StillHasSleeping (account:string sleeping-dpmf:string nonce:integer))
    ;;
    (defun UDC_ComposeVestingMetaData:[object{VST|MetaDataSchema}] (dptf:string amount:decimal offset:integer duration:integer milestones:integer))
    ;;
    ;;
    (defun C_CreateFrozenLink:object{IgnisCollector.OutputCumulator} (patron:string dptf:string))
    (defun C_CreateReservationLink:object{IgnisCollector.OutputCumulator} (patron:string dptf:string))
    (defun C_CreateVestingLink:object{IgnisCollector.OutputCumulator} (patron:string dptf:string))
    (defun C_CreateSleepingLink:object{IgnisCollector.OutputCumulator} (patron:string dptf:string))
    ;;
    ;;
    (defun C_Freeze:object{IgnisCollector.OutputCumulator} (freezer:string freeze-output:string dptf:string amount:decimal))
    (defun C_RepurposeFrozen:object{IgnisCollector.OutputCumulator} (dptf-to-repurpose:string repurpose-from:string repurpose-to:string))
    (defun C_ToggleTransferRoleFrozenDPTF:object{IgnisCollector.OutputCumulator} (s-dptf:string target:string toggle:bool))
    ;;
    (defun C_Reserve:object{IgnisCollector.OutputCumulator} (reserver:string dptf:string amount:decimal))
    (defun C_Unreserve:object{IgnisCollector.OutputCumulator} (unreserver:string r-dptf:string amount:decimal))
    (defun C_RepurposeReserved:object{IgnisCollector.OutputCumulator} (dptf-to-repurpose:string repurpose-from:string repurpose-to:string))
    (defun C_ToggleTransferRoleReservedDPTF:object{IgnisCollector.OutputCumulator} (s-dptf:string target:string toggle:bool))
    ;;
    (defun C_Unvest:object{IgnisCollector.OutputCumulator} (unvester:string dpmf:string nonce:integer))
    (defun C_Vest:object{IgnisCollector.OutputCumulator} (vester:string target-account:string dptf:string amount:decimal offset:integer duration:integer milestones:integer))
    (defun C_RepurposeVested:object{IgnisCollector.OutputCumulator} (dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string))
    ;;
    (defun C_Merge:object{IgnisCollector.OutputCumulator} (merger:string dpmf:string nonces:[integer]))
    (defun C_MergeAll:object{IgnisCollector.OutputCumulator} (merger:string dpmf:string))
    (defun C_Sleep:object{IgnisCollector.OutputCumulator} (sleeper:string target-account:string dptf:string amount:decimal duration:integer))
    (defun C_Unsleep:object{IgnisCollector.OutputCumulator} (unsleeper:string dpmf:string nonce:integer))
    (defun C_RepurposeSleeping:object{IgnisCollector.OutputCumulator} (dpmf-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string))
    (defun C_RepurposeMerge:object{IgnisCollector.OutputCumulator} (dpmf-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string))
    (defun C_RepurposeMergeAll:object{IgnisCollector.OutputCumulator} (dpmf-to-repurpose:string repurpose-from:string repurpose-to:string))
    (defun C_ToggleTransferRoleSleepingDPMF:object{IgnisCollector.OutputCumulator} (s-dpmf:string target:string toggle:bool))
)
(interface KadenaLiquidStakingV4
    @doc "Exposes the two functions needed Liquid Staking Functions, Wrap and Unwrap KDA \
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
        \ \
        \ V3 Removes <patron> input variable where it is not needed"
    ;;
    (defun LIQUID|SetGovernor (patron:string))
    ;;
    ;;
    (defun GOV|LIQUID|SC_KDA-NAME ())
    (defun GOV|LIQUID|GUARD ())
    ;;
    ;;
    (defun UEV_IzLiquidStakingLive ())
    ;;
    ;;
    (defun A_MigrateLiquidFunds:decimal (migration-target-kda-account:string))
    ;;
    (defun C_UnwrapKadena:object{IgnisCollector.OutputCumulator} (unwrapper:string amount:decimal))
    (defun C_WrapKadena:object{IgnisCollector.OutputCumulator} (wrapper:string amount:decimal))
)
(interface OuroborosV4
    @doc "Exposes Functions related to the OUROBOROS Module \
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
        \ \
        \ V3 Removes <patron> input variable where it is not needed and removes <UEV_AccountsAsStandard>"
    ;;
    (defun OUROBOROS|SetGovernor (patron:string))
    ;;
    ;;
    (defun GOV|ORBR|SC_KDA-NAME ())
    (defun GOV|ORBR|GUARD ())
    ;;
    ;;
    (defun URC_ProjectedKdaLiquindex:[decimal] ())
    (defun URC_Compress:[decimal] (ignis-amount:decimal))
    (defun URC_Sublimate:decimal (ouro-amount:decimal))
    ;;
    (defun UEV_Exchange ())
    ;;
    ;;
    (defun C_Compress:object{IgnisCollector.OutputCumulator} (client:string ignis-amount:decimal))
    (defun C_Fuel:object{IgnisCollector.OutputCumulator} ())
    (defun C_Sublimate:object{IgnisCollector.OutputCumulator} (client:string target:string ouro-amount:decimal))
    (defun C_WithdrawFees:object{IgnisCollector.OutputCumulator} (id:string target:string))
)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
;;
;;  SWP Interfaces
;;
(interface SwapTracer
    @doc "Exposes Tracer Functions, needed to compute Paths between Tokens existing on Liquidity Pools"
    ;;
    (defschema Edges
        principal:string
        swpairs:[string]
    )
    ;;
    (defun UC_PSwpairsFTO:[string] (traces:[object{Edges}] id:string principal:string principals-lst:[string]))
    (defun UC_PrincipalsFromTraces:[string] (traces:[object{Edges}]))
    ;;
    (defun UR_PathTrace:[object{Edges}] (id:string))
    ;;
    (defun URC_PathTracer:[object{Edges}] (old-path-tracer:[object{Edges}] id:string swpair:string principals-lst:[string]))
    (defun URC_ContainsPrincipals:bool (swpair:string principals-lst:[string]))
    (defun URC_ComputeGraphPath:[string] (input:string output:string swpairs:[string] principal-lst:[string]))
    (defun URC_AllGraphPaths:[[string]] (input:string output:string swpairs:[string] principal-lst:[string]))
    (defun URC_MakeGraph:[object{BreadthFirstSearch.GraphNode}] (input:string output:string swpairs:[string] principal-lst:[string]))
    (defun URC_TokenNeighbours:[string] (token-id:string principal-lst:[string]))
    (defun URC_TokenSwpairs:[string] (token-id:string principal-lst:[string]))
    (defun URC_PrincipalSwpairs:[string] (id:string principal:string principal-lst:[string]))
    (defun URC_Edges:[string] (t1:string t2:string principal-lst:[string])) ;;1
    ;;
    (defun UEV_IdAsPrincipal (id:string for-trace:bool principals-lst:[string]))
    ;;
    (defun XE_MultiPathTracer (swpair:string principals-lst:[string]))
)
(interface SwapperV4
    @doc "Exposes Swapper Related Functions, except those related to adding and swapping liquidity \
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
        \ Removes the all 4 Branding Functions from this Interface, since they are in their own interface. \
        \ The Branding for LPs moved from the SWP to SWPU Module \
        \ <URC_EntityPosToID> moved to SWPU Module \
        \ \
        \ V3 Removes <patron> input variable where it is not needed \
        \ V4 Adds Asymetric toggle, and global variable for the LKDA-OURO-WKDA Pool"
    ;;
    (defschema PoolTokens
        token-id:string
        token-supply:decimal
    )
    (defschema FeeSplit
        target:string
        value:integer
    )
    (defun SWP|Info ())
    ;;
    ;;
    (defun SWP|SetGovernor (patron:string))
    ;;
    ;;
    (defun UC_ExtractTokens:[string] (input:[object{PoolTokens}]))
    (defun UC_ExtractTokenSupplies:[decimal] (input:[object{PoolTokens}]))
    (defun UC_CustomSpecialFeeTargets:[string] (io:[object{FeeSplit}]))
    (defun UC_CustomSpecialFeeTargetsProportions:[decimal] (io:[object{FeeSplit}]))
    ;;
    (defun UR_Asymetric:bool ())
    (defun UR_Principals:[string] ())
    (defun UR_PrimordialPool:string ())
    (defun UR_LiquidBoost:bool ())
    (defun UR_SpawnLimit:decimal ())
    (defun UR_InactiveLimit:decimal ())
        ;;
    (defun UR_OwnerKonto:string (swpair:string))
    (defun UR_CanChangeOwner:bool (swpair:string))
    (defun UR_CanAdd:bool (swpair:string))
    (defun UR_CanSwap:bool (swpair:string))
    (defun UR_GenesisWeigths:[decimal] (swpair:string))
    (defun UR_Weigths:[decimal] (swpair:string))
    (defun UR_GenesisRatio:[object{PoolTokens}] (swpair:string))
    (defun UR_PoolTokenObject:[object{PoolTokens}] (swpair:string))
    (defun UR_TokenLP:string (swpair:string))
    (defun UR_FeeLP:decimal (swpair:string))
    (defun UR_FeeSP:decimal (swpair:string))
    (defun UR_FeeSPT:[object{FeeSplit}] (swpair:string))
    (defun UR_FeeLock:bool (swpair:string))
    (defun UR_FeeUnlocks:integer (swpair:string))
    (defun UR_Amplifier:decimal (swpair:string))
    (defun UR_Primality:bool (swpair:string))
    (defun UR_IzFrozenLP:bool (swpair:string))
    (defun UR_IzSleepingLP:bool (swpair:string))
    (defun UR_Pools:[string] (pool-category:string))
        ;;
    (defun UR_PoolTokens:[string] (swpair:string))
    (defun UR_PoolTokenSupplies:[decimal] (swpair:string))
    (defun UR_PoolGenesisSupplies:[decimal] (swpair:string))
    (defun UR_PoolTokenPosition:integer (swpair:string id:string))
    (defun UR_PoolTokenSupply:decimal (swpair:string id:string))
    (defun UR_PoolTokenPrecisions:[integer] (swpair:string))
    (defun UR_SpecialFeeTargets:[string] (swpair:string))
    (defun UR_SpecialFeeTargetsProportions:[decimal] (swpair:string))
    ;;
    (defun URC_LpCapacity:decimal (swpair:string))
    (defun URC_CheckID:bool (swpair:string))
    (defun URC_PoolTotalFee:decimal (swpair:string))
    (defun URC_LiquidityFee:decimal (swpair:string))
    (defun URC_Swpairs:[string] ())
    (defun URC_LpComposer:[string] (pool-tokens:[object{PoolTokens}] weights:[decimal] amp:decimal))
    ;;
    (defun UEV_FeeSplit (input:object{FeeSplit}))
    (defun UEV_id (swpair:string))
    (defun UEV_CanChangeOwnerON (swpair:string))
    (defun UEV_FeeLockState (swpair:string state:bool))
    (defun UEV_PoolFee (fee:decimal))
    (defun UEV_New (t-ids:[string] w:[decimal] amp:decimal))
    (defun UEV_CheckTwo (token-ids:[string] w:[decimal] amp:decimal))
    (defun UEV_CheckAgainstMass:bool (token-ids:[string] present-pools:[string]))
    (defun UEV_CheckAgainst:bool (token-ids:[string] pool-tokens:[string]))
    (defun UEV_FrozenLP (swpair:string state:bool))
    (defun UEV_SleepingLP (swpair:string state:bool))
    ;;
    ;;
    (defun A_UpdatePrincipal (principal:string add-or-remove:bool))
    (defun A_UpdateLimit (limit:decimal spawn:bool))
    (defun A_UpdateLiquidBoost (new-boost-variable:bool))
    (defun A_DefinePrimordialPool (primordial-pool:string))
    (defun A_ToggleAsymetricLiquidityAddition (toggle:bool))
    ;;
    (defun C_ChangeOwnership:object{IgnisCollector.OutputCumulator} (swpair:string new-owner:string))
    (defun C_EnableFrozenLP:object{IgnisCollector.OutputCumulator} (patron:string swpair:string))
    (defun C_EnableSleepingLP:object{IgnisCollector.OutputCumulator} (patron:string swpair:string))
    (defun C_ModifyCanChangeOwner:object{IgnisCollector.OutputCumulator} (swpair:string new-boolean:bool))
    (defun C_ModifyWeights:object{IgnisCollector.OutputCumulator} (swpair:string new-weights:[decimal]))
    (defun C_ToggleAddOrSwap:object{IgnisCollector.OutputCumulator} (swpair:string toggle:bool add-or-swap:bool))
    (defun C_ToggleFeeLock:object{IgnisCollector.OutputCumulator} (patron:string swpair:string toggle:bool))
    (defun C_UpdateAmplifier:object{IgnisCollector.OutputCumulator} (swpair:string amp:decimal))
    (defun C_UpdateFee:object{IgnisCollector.OutputCumulator} (swpair:string new-fee:decimal lp-or-special:bool))
    (defun C_UpdateSpecialFeeTargets:object{IgnisCollector.OutputCumulator} (swpair:string targets:[object{FeeSplit}]))
    ;;
    (defun XB_ModifyWeights (swpair:string new-weights:[decimal]))
    ;;
    (defun XE_UpdateSupplies (swpair:string new-supplies:[decimal]))
    (defun XE_UpdateSupply (swpair:string id:string new-supply:decimal))
    (defun XE_Issue:string (account:string pool-tokens:[object{PoolTokens}] token-lp:string fee-lp:decimal weights:[decimal] amp:decimal p:bool))
    (defun XE_CanAddOrSwapToggle (swpair:string toggle:bool add-or-swap:bool))
)
(interface SwapperIssueV2
    @doc "Exposes SWP Issuing Functions. \
    \ Also contains Swap Computation Functions, and the Hopper Function \
    \ V2 Adds OuroPrimordialPrice"
    ;;
    ;;
    ;;  SCHEMAS
    ;;
    (defschema Hopper
        nodes:[string]
        edges:[string]
        output-values:[decimal]    
    )
    ;;
    ;;
    ;;  [UC] Functions
    ;;
    (defun UC_DeviationInValueShares:decimal (pool-reserves:[decimal] asymmetric-liq:[decimal] w:[decimal]))
    (defun UC_DeviatedShares:[decimal] (pool-reserves:[decimal] pool-shares:[decimal] new-total-shares:decimal))
    (defun UC_PoolShares:[decimal] (pool-reserves:[decimal] w:[decimal]))
    (defun UC_VirtualSwap:object{UtilitySwpV2.VirtualSwapEngine} 
        (vse:object{UtilitySwpV2.VirtualSwapEngine} dsid:object{UtilitySwpV2.DirectSwapInputData})
    )
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
    (defun UC_BareboneSwap:decimal (pool-type:string drsi:object{UtilitySwpV2.DirectRawSwapInput}))
    (defun UC_BareboneInverseSwap:decimal (pool-type:string irsi:object{UtilitySwpV2.InverseRawSwapInput}))
    (defun UC_PoolTokenPositions:[integer] (swpair:string input-ids:[string]))
    ;;
    ;;
    ;;  [URC] Functions
    ;;
    (defun URC_EliteFeeReduction:object{UtilitySwpV2.SwapFeez} (account:string fees:object{UtilitySwpV2.SwapFeez}))
    (defun URC_PoolTokenPositions:[integer] (swpair:string input-ids:[string]))
    (defun URC_DirectRawSwapInput:object{UtilitySwpV2.DirectRawSwapInput} (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData}))
    (defun URC_InverseRawSwapInput:object{UtilitySwpV2.InverseRawSwapInput} (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData}))
        ;;
    (defun URC_Swap:decimal (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} validation:bool))
    (defun URC_S-Swap:decimal (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData}))
    (defun URC_W-Swap:decimal (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData}))
    (defun URC_P-Swap:decimal (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData}))
        ;;
    (defun URC_InverseSwap:decimal (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData} validation:bool))
    (defun URC_S-InverseSwap:decimal (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData}))
    (defun URC_W-InverseSwap:decimal (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData}))
    (defun URC_P-InverseSwap (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData}))
        ;;
    (defun URC_Hopper:object{Hopper} (hopper-input-id:string hopper-output-id:string hopper-input-amount:decimal))
    (defun URC_BestEdge:string (ia:decimal i:string o:string))
        ;;
    (defun URC_OuroPrimordialPrice:decimal ())
    (defun URC_TokenDollarPrice (id:string kda-pid:decimal))
    (defun URC_SingleWorthDWK (id:string))
    (defun URC_WorthDWK (id:string amount:decimal))
    (defun URC_PoolValue:[decimal] (swpair:string))
        ;;
    (defun URC_DirectRefillAmounts:[decimal] (swpair:string ids:[string] amounts:[decimal]))
    (defun URC_IndirectRefillAmounts:[decimal] (X:[decimal] positions:[integer] amounts:[decimal]))
    (defun URC_TrimIdsWithZeroAmounts:[string] (swpair:string input-amounts:[decimal]))
    ;;
    ;;
    ;;  [UEV] Functions
    ;;
    (defun UEV_SwapData (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData}))
    (defun UEV_InverseSwapData (swpair:string rsid:object{UtilitySwpV2.ReverseSwapInputData}))
        ;;
    (defun UEV_Issue (account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool))
    ;;
    ;;
    ;;  [UDC] Functions
    ;;
    (defun UDC_DirectRawSwapInput:object{UtilitySwpV2.DirectRawSwapInput} 
        (dsid:object{UtilitySwpV2.DirectSwapInputData} A:decimal X:[decimal] input-positions:[integer] output-position:integer weights:[decimal])
    )
    (defun UDC_InverseRawSwapInput:object{UtilitySwpV2.InverseRawSwapInput} 
        (rsid:object{UtilitySwpV2.ReverseSwapInputData} A:decimal X:[decimal] output-position:integer input-position:integer weights:[decimal])
    )
    (defun UDC_Hopper:object{Hopper} (a:[string] b:[string] c:[decimal]))
    ;;
    ;;
    ;;  []C] Functions
    ;;
    ;;
    (defun C_Issue:object{IgnisCollector.OutputCumulator} (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool))    
)
(interface SwapperLiquidity
    @doc "Exposes Liquidity Functions;"
    ;;
    ;;
    ;;  SCHEMAS
    ;;
    (defschema OutputLP
        primary:decimal
        secondary:decimal
    )
    (defschema LiquiditySplit
        balanced:[decimal]
        asymmetric:[decimal]
    )
    (defschema LiquiditySplitType
        iz-balanced:bool
        iz-asymmetric:bool
    )
    (defschema LiquidityData
        sorted-lq:object{LiquiditySplit}
        sorted-lq-type:object{LiquiditySplitType}
        balanced:decimal
        asymmetric:decimal
        asymmetric-fee:decimal
    )
    (defschema LiquidityComputationData
        li:integer
        pool-type:string
        lp-prec:integer
        current-lp-supply:decimal
        lp-supply:decimal
        pool-token-supplies:[decimal]
    )
    (defschema AsymmetricTax
        tad:decimal                     ;;The value of Token A Deficit
        tad-diff:decimal                ;;Difference between <tad> and Fee Shares
        fuel:decimal                    ;;Token A amount as Fuel
        special:decimal                 ;;Token A amount for Special Targets
        boost:decimal                   ;;Token A amount for Boost
        fuel-to-lp:decimal              ;;Token A amount for Fuel converted to LP amounts
    )
    (defschema CompleteLiquidityAdditionData
        total-input-liquidity:[decimal]
        balanced-liquidity:[decimal]
        asymmetric-liquidity:[decimal]
        asymmetric-deviation:[decimal]
        ;;
        primary-lp:decimal
        secondary-lp:decimal
        ;;
        total-ignis-tax-needed:decimal
        ;;
        gaseous-ignis-fee:decimal
        deficit-ignis-tax:decimal
        special-ignis-tax:decimal
        lqboost-ignis-tax:decimal
        relinquish-lp:decimal
        ;;
        gaseous-text:string
        deficit-text:string
        special-text:string
        lqboost-text:string
        fueling-text:string
        ;;
        clad-op:object{CladOperation}
    )
    (defschema CladOperation
        perfect-ignis-fee:object{IgnisCollector.OutputCumulator}   
                                    ;;Ignis Cumulator for the Operation
                                    ;;Can be used to Collect Fees in Advance
        mt-ids:[string]             ;;IDs the User Moves to swp-sc
        mt-amt:[decimal]            ;;Their Amounts
        lp-mint:bool                ;;True Mints only Primary, false mints both
        bk-ids:[string]             ;;IDs of the special Targets, in case none then BAR
        bk-amt:[decimal]            ;;Amounts for the BulkT, in case none, then 0.0
        ;;
        ppb:[decimal]               ;;Pool Amounts plus balanced-liq
        ppa:[decimal]               ;;Pool Amounts plus all input-lq

    )
    (defschema PoolState
        A:decimal
        F:object{UtilitySwpV2.SwapFeez}
        X:[decimal]
        W:[decimal]
        ;;
        LP:decimal
        FT:[string]
        FTP:[decimal]
    )
    ;;
    ;;
    ;;  [UC] Functions
    ;;
    (defun UC_DetermineLiquidity:object{LiquiditySplitType} (input-lqs:object{LiquiditySplit}))
    ;;
    ;;
    ;;  [URC] Functions
    ;;
    (defun URC|KDA-PID_LpToIgnis:decimal (swpair:string amount:decimal kda-pid:decimal))
    (defun URC|KDA-PID_TokenToIgnis (id:string amount:decimal kda-pid:decimal))
    (defun URC|KDA-PID_CLAD:object{CompleteLiquidityAdditionData}
        (
            account:string swpair:string ld:object{LiquidityData} 
            asymmetric-collection:bool gaseous-collection:bool kda-pid:decimal
        )
    )
    (defun URC_TokenPrecision (id:string))
    (defun URC_IgnisPrecision ())
        ;;
    (defun URC_LD:object{LiquidityData} (swpair:string input-amounts:[decimal]))
    (defun URC_AsymmetricTax:object{AsymmetricTax} (account:string swpair:string ld:object{LiquidityData}))
    (defun URC_SortLiquidity:object{LiquiditySplit} (swpair:string input-amounts:[decimal]))
        ;;
    (defun URC_AreAmountsBalanced:bool (swpair:string input-amounts:[decimal]))
    (defun URC_BalancedLiquidity:[decimal] (swpair:string input-id:string input-amount:decimal with-validation:bool))
    (defun URC_LpBreakAmounts:[decimal] (swpair:string input-lp-amount:decimal))
    (defun URC_CustomLpBreakAmounts:[decimal] (swpair:string swpair-pool-token-supplies:[decimal] swpair-lp-supply:decimal input-lp-amount:decimal))
    ;;
    ;;
    ;;  [UEV] Functions
    ;;
    (defun UEV_Liquidity:[decimal] (swpair:string ld:object{LiquidityData}))
    (defun UEV_BalancedLiquidity (swpair:string input-id:string input-amount:decimal))
    
    ;;
    ;;
    ;;  [UDC] Functions
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
    (defun UDC_OutputLP:object{OutputLP} (a:decimal b:decimal))
    (defun UDC_LiquiditySplit:object{LiquiditySplit} (a:[decimal] b:[decimal]))
    (defun UDC_LiquiditySplitType:object{LiquiditySplitType} (a:bool b:bool))
    (defun UDC_LiquidityData:object{LiquidityData} (a:object{LiquiditySplit} b:object{LiquiditySplitType} c:decimal d:decimal e:decimal))
    (defun UDC_LiquidityComputationData:object{LiquidityComputationData} (a:integer b:string c:integer d:decimal e:decimal f:[decimal]))
    (defun UDC_AsymmetricTax:object{AsymmetricTax} (a:decimal b:decimal c:decimal d:decimal e:decimal f:decimal))
    (defun UDC_CompleteLiquidityAdditionData:object{CompleteLiquidityAdditionData}
        (
            a:[decimal] b:[decimal] c:[decimal] d:[decimal]
            e:decimal f:decimal
            g:decimal
            h:decimal i:decimal j:decimal k:decimal l:decimal
            m:string n:string o:string p:string q:string
            r:object{CladOperation}
        )
    )
    (defun UDC_CladOperation:object{CladOperation} (a:object{IgnisCollector.OutputCumulator} b:[string] c:[decimal] d:bool e:[string] f:[decimal] g:[decimal] h:[decimal]))
    (defun UDC_PoolState:object{PoolState} (a:decimal b:object{UtilitySwpV2.SwapFeez} c:[decimal] d:[decimal] e:decimal f:[string] g:[decimal]))
)
(interface SwapperLiquidityClient
    @doc "Exposes the Client Functions of Swapper Liquidity"
    ;;
    ;;
    ;;  [URC] Functions
    ;;
    (defun URC_EntityPosToID:string (swpair:string entity-pos:integer))
    ;;
    ;;
    ;;  [UEV] Functions
    ;;
    (defun UEV_InputsForLP (swpair:string input-amounts:[decimal]))
    (defun UEV_AddFrozenLiquidity (swpair:string frozen-dptf:string))
    (defun UEV_AddSleepingLiquidity (account:string swpair:string sleeping-dpmf:string nonce:integer))
    (defun UEV_AddDormantLiquidity (swpair:string))
    (defun UEV_AddChilledLiquidity (swpair:string ld:object{SwapperLiquidity.LiquidityData}))
    (defun UEV_AddLiquidity (swpair:string ld:object{SwapperLiquidity.LiquidityData}))
    (defun UEV_RemoveLiquidity (swpair:string lp-amount:decimal))
    ;;
    ;;
    ;;  []C] Functions
    ;;
    ;;
    (defun C_ToggleAddLiquidity:object{IgnisCollector.OutputCumulator} (swpair:string toggle:bool))
    (defun C_Fuel:object{IgnisCollector.OutputCumulator} (account:string swpair:string input-amounts:[decimal] direct-or-indirect:bool validation:bool))
        ;;
    (defun C|KDA-PID_AddStandardLiquidity:object{IgnisCollector.OutputCumulator} (account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun C|KDA-PID_AddIcedLiquidity:object{IgnisCollector.OutputCumulator} (account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun C|KDA-PID_AddGlacialLiquidity:object{IgnisCollector.OutputCumulator} (account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun C|KDA-PID_AddFrozenLiquidity:object{IgnisCollector.OutputCumulator} (account:string swpair:string frozen-dptf:string input-amount:decimal kda-pid:decimal))
    (defun C|KDA-PID_AddSleepingLiquidity:object{IgnisCollector.OutputCumulator} (account:string swpair:string sleeping-dpmf:string nonce:integer kda-pid:decimal))
        ;;
    (defun C_RemoveLiquidity:object{IgnisCollector.OutputCumulator} (account:string swpair:string lp-amount:decimal))
)
(interface SwapperUsageV4
    @doc "Exposes Adding|Removing Liquidty and Swapping Functions of the SWP Module\ 
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
        \ Branding for LP added to the SPWU from SWP Module \
        \ \
        \ V3 Removes <patron> input variable where it is not needed \
        \ V4 Brings SWPU Segregation into SWPI, SWPL and a new SWPU that contains only Swap related Functions \
        \ and improved Swap Logistics"
    ;;
    ;;
    ;;  SCHEMAS
    ;;
    (defschema Slippage
        expected-output-amount:decimal
        output-precision:integer
        slippage-percent:decimal
    )
    ;;
    ;;
    ;;  [UC] Functions
    ;;
    (defun UC_SlippageMinMax:[decimal] (input:object{Slippage}))
    ;;
    ;;
    ;;  [UDC] Functions
    ;;
    (defun UDC_Slippage:object{Slippage} (a:decimal b:integer c:decimal))
    (defun UDC_SlippageObject:object{Slippage} (swpair:string dsid:object{UtilitySwpV2.DirectSwapInputData} slippage-value:decimal))
    ;;
    ;;
    ;;  []C] Functions
    ;;
    ;;
    (defun C_ToggleSwapCapability:object{IgnisCollector.OutputCumulator} (swpair:string toggle:bool))
    (defun C_Swap:object{IgnisCollector.OutputCumulator} (account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:decimal kda-pid:decimal))
)
(interface SwapperMtx
    @doc "Exposes SWP MultiStep (via defpact) Functions."
    ;;
    ;;
    ;;  []C] Functions
    ;;
    ;;
    (defun C_IssueStablePool (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal amp:decimal p:bool))
    (defun C_IssueWeightedPool (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool))
    (defun C_IssueStandardPool (patron:string account:string pool-tokens:[object{SwapperV4.PoolTokens}] fee-lp:decimal p:bool))
    ;;
    (defun C_AddStandardLiquidity (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun C_AddIcedLiquidity (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun C_AddGlacialLiquidity (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun C_AddFrozenLiquidity (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal kda-pid:decimal))
    (defun C_AddSleepingLiquidity (patron:string account:string swpair:string sleeping-dpmf:string nonce:integer kda-pid:decimal))
    ;;
)