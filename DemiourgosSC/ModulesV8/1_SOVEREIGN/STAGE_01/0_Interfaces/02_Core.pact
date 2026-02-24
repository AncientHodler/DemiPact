;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
;;  [DALOS]
;;
(interface OuronetPolicyV1
    @doc "Interface exposing OuronetPolicyV1 Functions, which are needed for intermodule communication \
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
(interface IgnisCollectorV1
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
    ;;  [URC]
    ;;
    (defun URC_Exception (account:string))
    (defun URC_ZeroEliteGAZ (sender:string receiver:string))
    (defun URC_ZeroGAZ:bool (id:string sender:string receiver:string))
    (defun URC_ZeroGAS:bool (id:string sender:string))
    (defun URC_IsVirtualGasZeroAbsolutely:bool (id:string))
    (defun URC_IsVirtualGasZero:bool ())
    (defun URC_IsNativeGasZero:bool ())
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_TwentyFourPrecision (amount:decimal))
    (defun UEV_Patron (patron:string))
    ;;
    ;;  [UDC]
    ;;
    (defun UDC_MakeIDP:string (ignis-discount:decimal))
    (defun UDC_ConstructOutputCumulator:object{OutputCumulator} (price:decimal active-account:string trigger:bool output-lst:list))
    (defun UDC_BrandingCumulator:object{OutputCumulator} (active-account:string multiplier:decimal))
    (defun UDC_SmallestCumulator:object{OutputCumulator} (active-account:string))
    (defun UDC_SmallCumulator:object{OutputCumulator} (active-account:string))
    (defun UDC_MediumCumulator:object{OutputCumulator} (active-account:string))
    (defun UDC_BigCumulator:object{OutputCumulator} (active-account:string))
    (defun UDC_BiggestCumulator:object{OutputCumulator} (active-account:string))
    (defun UDC_CustomCodeCumulator:object{OutputCumulator} ())
        ;;
    (defun UDC_MakeModularCumulator:object{ModularCumulator} (price:decimal active-account:string trigger:bool))
    (defun UDC_MakeOutputCumulator:object{OutputCumulator} (input-modular-cumulator-chain:[object{ModularCumulator}] output-lst:list))
    (defun UDC_ConcatenateOutputCumulators:object{OutputCumulator} (input-output-cumulator-chain:[object{OutputCumulator}] new-output-lst:list))
    (defun UDC_CompressOutputCumulator:object{CompressedCumulator} (input-output-cumulator:object{OutputCumulator}))
    (defun UDC_PrimeIgnisCumulator:object{PrimedCumulator} (patron:string input:object{CompressedCumulator}))
    ;;
    ;;  [C]
    ;;
    (defun C_TransferDalosFuel (sender:string receiver:string amount:decimal))
    (defun C_Collect  (patron:string input-output-cumulator:object{OutputCumulator}))
    (defun KDA|C_Collect (sender:string amount:decimal))
    (defun KDA|C_CollectWT (sender:string amount:decimal trigger:bool))
    ;;
)
(interface OuronetDalosV1
    ;;
    ;;  SCHEMAS
    ;;
    (defschema DPTF|BalanceSchema
        @doc "Schema that Stores Account Balances for DPTF Tokens (True Fungibles)\
            \ Key for the Table is a string composed of: <DPTF id> + BAR + <account> \
            \ This ensure a single entry per DPTF id per account. \
            \ As an Exception OUROBOROS and IGNIS Account Data is Stored at the DALOS Account Level"
        balance:decimal
        frozen:bool
        role-burn:bool
        role-mint:bool
        role-fee-exemption:bool
        role-transfer:bool
        ;;
        ;;ForSelect, store Key Make-up
        id:string
        account:string
    )
    ;;
    ;;  [GOV]
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
    ;;  [UR]
    ;;
    ;;  [0]     DALOS|KadenaLedger:{DALOS|KadenaSchema}
    (defun UR_KadenaLedger:[string] (kadena:string))
    ;;  [1]     DALOS|PropertiesTable:{DALOS|PropertiesSchema}
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
    ;;  [2]     DALOS|GasManagementTable:{DALOS|GasManagementSchema}
    (defun UR_Tanker:string ())
    (defun UR_VirtualToggle:bool ())
    (defun UR_VirtualSpent:decimal ())
    (defun UR_NativeToggle:bool ())
    (defun UR_NativeSpent:decimal ())
    (defun UR_AutoFuel:bool ())
    ;; [3]      DALOS|PricesTable:{DALOS|PricesSchema}
    (defun UR_UsagePrice:decimal (action:string))
    ;; [4]      DALOS|AccountTable:{DALOS|AccountSchema}
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
    ;;  [4.1]   ELITE Info
    (defun UR_Elite-Class (account:string))
    (defun UR_Elite-Name (account:string))
    (defun UR_Elite-Tier (account:string))
    (defun UR_Elite-Tier-Major:integer (account:string))
    (defun UR_Elite-Tier-Minor:integer (account:string))
    (defun UR_Elite-DEB (account:string))
    ;;  [4.2]   TrueFungible INFO
    (defun UR_TrueFungible:object{DPTF|BalanceSchema} (account:string snake-or-gas:bool))
    (defun UR_TF_AccountSupply:decimal (account:string snake-or-gas:bool))
    (defun UR_TF_AccountRoleBurn:bool (account:string snake-or-gas:bool))
    (defun UR_TF_AccountRoleMint:bool (account:string snake-or-gas:bool))
    (defun UR_TF_AccountRoleTransfer:bool (account:string snake-or-gas:bool))
    (defun UR_TF_AccountRoleFeeExemption:bool (account:string snake-or-gas:bool))
    (defun UR_TF_AccountFreezeState:bool (account:string snake-or-gas:bool))
    (defun UR_AutonomicRoles:bool (account:string))
    ;;
    ;;  [URC]
    ;;
    (defun URC_IgnisGasDiscount:decimal (account:string))
    (defun URC_KadenaGasDiscount:decimal (account:string))
    (defun URC_GasDiscount:decimal (account:string native:bool))
    (defun URC_SplitKDAPrices:[decimal] (account:string kda-price:decimal))
    (defun URC_Transferability:bool (sender:string receiver:string method:bool))
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_NotSmartOuronetAccount (account:string))
    (defun UEV_StandardAccOwn (account:string))
    (defun UEV_SmartAccOwn (account:string))
    (defun UEV_EnforceAccountExists (dalos-account:string))
    (defun UEV_EnforceAccountType (account:string smart:bool))
    (defun UEV_EnforceTransferability (sender:string receiver:string method:bool))
    (defun UEV_SenderWithReceiver (sender:string receiver:string))
        ;;
    (defun UEV_KadenaCollectionState (state:bool))
    (defun UEV_IgnisCollectionState (state:bool))
    (defun UEV_IgnisCollectionRequirements ())
        ;;
    (defun UEV_Glyph (account:string))
    ;;
    ;;  [UDC]
    ;;
    (defun UDC_TrueFungibleAccount:object{DPTF|BalanceSchema}
        (a:decimal b:bool c:bool d:bool e:bool f:bool g:string h:string)
    )
    (defun UDC_BlankTrueFungible:object{DPTF|BalanceSchema} (account:string))
    ;;
    ;;  [CAP]
    ;;
    (defun CAP_EnforceAccountOwnership (account:string))
    ;;
    ;;  [A]
    ;;
    (defun A_MigrateLiquidFunds:decimal (migration-target-kda-account:string))
    (defun A_ToggleOAPU (oapu:bool))
    (defun A_ToggleGAP (gap:bool))
    (defun A_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun A_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun A_ToggleGasCollection (native:bool toggle:bool))
    (defun A_SetIgnisSourcePrice (price:decimal))
    (defun A_SetAutoFueling (toggle:bool))
    (defun A_UpdatePublicKey (account:string new-public:string))
    (defun A_UpdateUsagePrice (action:string new-price:decimal))
    ;;
    ;;  [C]
    ;;
    (defun C_ControlSmartAccount
        (account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool)
    )
    (defun C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun C_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun C_RotateGovernor (account:string governor:guard))
    (defun C_RotateGuard (account:string new-guard:guard safe:bool))
    (defun C_RotateKadena (account:string kadena:string))
    (defun C_RotateSovereign (account:string new-sovereign:string))
    ;;
    ;;  [X]
    ;;
    (defun XB_UpdateOuroPrice (price:decimal))
    (defun XE_UpdateTreasury (type:integer tdp:decimal tds:decimal))
    (defun XE_IgnisIncrement (native:bool increment:decimal))
    (defun XE_IncrementOuronetAccountNonce (account:string))
    (defun XE_UpdateElite (account:string amount:decimal))
    (defun XB_UpdateBalance (account:string snake-or-gas:bool new-balance:decimal))
    (defun XE_UpdateFreeze (account:string snake-or-gas:bool new-freeze:bool))
    (defun XE_UpdateBurnRole (account:string snake-or-gas:bool new-burn:bool))
    (defun XE_UpdateMintRole (account:string snake-or-gas:bool new-mint:bool))
    (defun XE_UpdateFeeExemptionRole (account:string snake-or-gas:bool new-fee-exemption:bool))
    (defun XE_UpdateTransferRole (account:string snake-or-gas:bool new-transfer:bool))
)
(interface OuronetInfoV1
    @doc "Holds Information Schemas"
    ;;
    ;;  SCHEMAS
    ;;
    (defschema ClientInfo
        pre-text:[string]
        post-text:[string]
        ignis:object{ClientIgnisCosts}
        kadena:object{ClientKadenaCosts}
        output:list
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
    (defun OI|UC_IfpFromOutputCumulator:decimal (input:object{IgnisCollectorV1.OutputCumulator}))
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
    (defun OI|UDC_ClientInfo:object{ClientInfo} (a:[string] b:[string] c:object{ClientIgnisCosts} d:object{ClientKadenaCosts} e:list))
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
(interface DalosInfoV1
    @doc "Exposes Information Function for the Dalos Client Functions"
    ;;
    ;;
    ;;  [URC] Functions
    ;;
    (defun DALOS-INFO|URC_ControlSmartAccount:object{OuronetInfoV1.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_DeploySmartAccount:object{OuronetInfoV1.ClientInfo} (account:string))
    (defun DALOS-INFO|URC_DeployStandardAccount:object{OuronetInfoV1.ClientInfo} (account:string))
    (defun DALOS-INFO|URC_RotateGovernor:object{OuronetInfoV1.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_RotateGuard:object{OuronetInfoV1.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_RotateKadena:object{OuronetInfoV1.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_RotateSovereign:object{OuronetInfoV1.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_UpdateEliteAccount:object{OuronetInfoV1.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_UpdateEliteAccountSquared:object{OuronetInfoV1.ClientInfo} (patron:string sender:string receiver:string))
)
;;
;;  [Branding]
;;
(interface BrandingV1
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
(interface BrandingUsagePrimaryV1
    @doc "Exposes Branding Functions for True-Fungibles (T), Orto-Fungibles (M), ATS-Pairs (A) and SWP-Pairs (S)"
    ;;
    (defun C_UpdatePendingBranding:object{IgnisCollectorV1.OutputCumulator} (entity-id:string logo:string description:string website:string social:[object{BrandingV1.SocialSchema}]))
    (defun C_UpgradeBranding (patron:string entity-id:string months:integer))
)
(interface BrandingUsageSecondaryV1
    @doc "Exposes Branding Functions for True-Fungible LP Tokens \
        \ <entity-pos>: 1 (Native LP), 2 (Freezing LP), 3 (Sleeping LP)"
    ;;
    (defun C_UpdatePendingBrandingLPs:object{IgnisCollectorV1.OutputCumulator} (swpair:string entity-pos:integer logo:string description:string website:string social:[object{BrandingV1.SocialSchema}]))
    (defun C_UpgradeBrandingLPs (patron:string swpair:string entity-pos:integer months:integer))
)
(interface BrandingUsageTertiaryV1
    @doc "Exposes Branding Functions for Semi-Fungibles (S) and Non-Fungibles (N)"
    ;;
    (defun C_UpdatePendingBranding:object{IgnisCollectorV1.OutputCumulator} (entity-id:string son:bool logo:string description:string website:string social:[object{BrandingV1.SocialSchema}]))
    (defun C_UpgradeBranding (patron:string entity-id:string son:bool  months:integer))
)
;;
;;  [True Fungibles]
;;
(interface DemiourgosPactTrueFungibleV1
    @doc "Exposes most of the Functions related to True-Fungibles"
    ;;
    ;;  [UC]
    ;;
    (defun URU_UpgradeTruefungibleToV2 (ids:[string]))
    (defun UC_IdAccount:string (id:string account:string))
    (defun UC_VolumetricTax (id:string amount:decimal))
    (defun UC_TreasuryLowestDispo (ouro-supply:decimal ouro-precision:integer dispo-type:integer tdp:decimal tds:decimal))
    ;;
    ;;  [UR]
    ;;
    (defun UR_P-KEYS:[string] ())
    (defun UR_KEYS:[string] ())
    ;;
    ;;  [0] DPTF|PropertiesTable:{DPTF|PropertiesSchemaV3}
    (defun UR_Konto:string (id:string))
    (defun UR_Name:string (id:string))
    (defun UR_Ticker:string (id:string))
    (defun UR_Decimals:integer (id:string))
    (defun UR_CanUpgrade:bool (id:string))
    (defun UR_CanChangeOwner:bool (id:string))
    (defun UR_CanAddSpecialRole:bool (id:string))
    (defun UR_CanFreeze:bool (id:string))
    (defun UR_CanWipe:bool (id:string))
    (defun UR_CanPause:bool (id:string))
    (defun UR_Paused:bool (id:string))
    (defun UR_Supply:decimal (id:string))
    (defun UR_OriginMint:bool (id:string))
    (defun UR_OriginAmount:decimal (id:string))
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
    (defun UR_Hibernation:string (id:string))
    (defun UR_Frozen:string (id:string))
    (defun UR_Reservation:string (id:string))
    (defun UR_IzReservationOpen:bool (id:string))
    (defun UR_IzId:bool (id:string))
    ;;  [1]     DPTF|RoleTable:{DPTF|RoleSchema}
    (defun UR_Verum1:[string] (id:string))
    (defun UR_Verum2:[string] (id:string))
    (defun UR_Verum3:[string] (id:string))
    (defun UR_Verum4:[string] (id:string))
    (defun UR_Verum5:[string] (id:string))
    ;;  [2]     DPTF|BalanceTable:{OuronetDalosV1.DPTF|BalanceSchema}
    (defun UR_IzAccount:bool (id:string account:string))
    (defun UR_AccountSupply:decimal (id:string account:string))
    (defun UR_AccountFrozenState:bool (id:string account:string))
    (defun UR_AccountRoleBurn:bool (id:string account:string))
    (defun UR_AccountRoleMint:bool (id:string account:string))
    (defun UR_AccountRoleTransfer:bool (id:string account:string))
    (defun UR_AccountRoleFeeExemption:bool (id:string account:string))
    ;;
    ;;  [URC]
    ;;
    (defun URC_IzRT:bool (reward-token:string))
    (defun URC_IzRTg:bool (atspair:string reward-token:string))
    (defun URC_IzRBT:bool (reward-bearing-token:string))
    (defun URC_IzRBTg:bool (atspair:string reward-bearing-token:string))
    (defun URC_IzCoreDPTF:bool (id:string))
    (defun URC_Fee:[decimal] (id:string amount:decimal))
        ;;
    (defun URC_HasVesting:bool (id:string))
    (defun URC_HasSleeping:bool (id:string))
    (defun URC_HasHibernation:bool (id:string))
    (defun URC_HasFrozen:bool (id:string))
    (defun URC_HasReserved:bool (id:string))
    (defun URC_Parent:string (dptf:string))
    (defun URC_TreasuryLowestDispo:decimal ())
    ;;
    ;;  [URD]
    ;;
    (defun URD_HeldTrueFungibles:[string] (account:string))
    (defun URD_ExistingTrueFungibles:[string] (dptf:string))
    (defun URD_OwnedTrueFungibles:[string] (account:string))
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_ParentOwnership (dptf:string))
    (defun UEV_id (id:string))
    (defun UEV_CheckID:bool (id:string))
    (defun UEV_Amount (id:string amount:decimal))
    (defun UEV_CheckAmount:bool (id:string amount:decimal))
        ;;
    (defun UEV_CanChangeOwnerON (id:string))
    (defun UEV_CanUpgradeON (id:string))
    (defun UEV_CanAddSpecialRoleON (id:string))
    (defun UEV_CanFreezeON (id:string))
    (defun UEV_CanWipeON (id:string))
    (defun UEV_CanPauseON (id:string))
        ;;
    (defun UEV_PauseState (id:string state:bool))
    (defun UEV_ReservationState (id:string state:bool))
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
    (defun UEV_Hibernation (id:string existance:bool))
    (defun UEV_Frozen (id:string existance:bool))
    (defun UEV_Reserved (id:string existance:bool))
    ;;
    ;;  [UDC]
    ;;
    (defun UDC_TrueFungibleAccount:object{OuronetDalosV1.DPTF|BalanceSchema} (a:decimal b:bool c:bool d:bool e:bool f:bool g:string h:string))
    ;;
    ;;  [CAP]
    ;;
    (defun CAP_Owner (id:string))
    ;;
    ;;  [A]
    ;;
    (defun A_UpdateTreasury (type:integer tdp:decimal tds:decimal))
    (defun A_WipeTreasuryDebt ())
    (defun A_WipeTreasuryDebtPartial (debt-to-be-wiped:decimal))
    ;;
    ;;  [C]
    ;;
    (defun C_Issue:object{IgnisCollectorV1.OutputCumulator}
        (
            patron:string account:string 
            name:[string] ticker:[string] decimals:[integer] 
            can-upgrade:[bool] can-change-owner:[bool] can-add-special-role:[bool] 
            can-freeze:[bool] can-wipe:[bool] can-pause:[bool]
        )
    )
    (defun C_RotateOwnership:object{IgnisCollectorV1.OutputCumulator} (id:string new-owner:string))
    (defun C_Control:object{IgnisCollectorV1.OutputCumulator} (id:string cu:bool cco:bool casr:bool cf:bool cw:bool cp:bool))
    (defun C_TogglePause:object{IgnisCollectorV1.OutputCumulator} (id:string toggle:bool))
    (defun C_ToggleReservation:object{IgnisCollectorV1.OutputCumulator} (id:string toggle:bool))
        ;;
    (defun C_ToggleFee:object{IgnisCollectorV1.OutputCumulator} (id:string toggle:bool))
    (defun C_SetMinMove:object{IgnisCollectorV1.OutputCumulator} (id:string min-move-value:decimal))
    (defun C_SetFee:object{IgnisCollectorV1.OutputCumulator} (id:string fee:decimal))
    (defun C_SetFeeTarget:object{IgnisCollectorV1.OutputCumulator} (id:string target:string))
    (defun C_ToggleFeeLock:object{IgnisCollectorV1.OutputCumulator} (patron:string id:string toggle:bool))
        ;;
    (defun C_DeployAccount (id:string account:string))
    (defun C_ToggleFreezeAccount:object{IgnisCollectorV1.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_ToggleBurnRole:object{IgnisCollectorV1.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_ToggleMintRole:object{IgnisCollectorV1.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_ToggleFeeExemptionRole:object{IgnisCollectorV1.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_ToggleTransferRole:object{IgnisCollectorV1.OutputCumulator} (id:string account:string toggle:bool))
        ;;
    (defun C_Burn:object{IgnisCollectorV1.OutputCumulator} (id:string account:string amount:decimal))
    (defun C_Mint:object{IgnisCollectorV1.OutputCumulator} (id:string account:string amount:decimal origin:bool))
    (defun C_WipeSlim:object{IgnisCollectorV1.OutputCumulator} (id:string account-to-be-wiped:string amount-to-be-wiped:decimal))
    (defun C_Wipe:object{IgnisCollectorV1.OutputCumulator} (id:string account-to-be-wiped:string))
    ;;
    ;;  [X]
    ;;
    (defun XE_IssueLP:object{IgnisCollectorV1.OutputCumulator} (name:string ticker:string))
    (defun XB_IssueFree:object{IgnisCollectorV1.OutputCumulator}
        (
            account:string
            name:[string]
            ticker:[string]
            decimals:[integer]
            ;;
            can-upgrade:[bool]
            can-change-owner:[bool]
            can-add-special-role:[bool]
            ;;
            can-freeze:[bool]
            can-wipe:[bool]
            can-pause:[bool]
            ;;
            iz-special:[bool]
        )
    )
    (defun XB_DeployAccountWNE (account:string id:string))
    (defun XB_UpdateSupply (id:string amount:decimal direction:bool))
    (defun XE_UpdateFeeVolume (id:string amount:decimal primary:bool))
    (defun XE_UpdateRewardToken (atspair:string id:string direction:bool))
    (defun XE_UpdateRewardBearingToken (atspair:string id:string))
    (defun XE_UpdateVesting (dptf:string dpof:string))
    (defun XE_UpdateSleeping (dptf:string dpof:string))
    (defun XE_UpdateHibernation (dptf:string dpof:string))
    (defun XE_UpdateSpecialTrueFungible:object{IgnisCollectorV1.OutputCumulator}
        (main-dptf:string secondary-dptf:string fr-tag:integer)
    )
    (defun XB_DebitTrueFungible (id:string account:string amount:decimal dispo-data:object{UtilityDptfV1.DispoData} wipe-mode:bool))
    (defun XB_CreditTrueFungible (id:string account:string amount:decimal))
)
(interface TrueFungibleTransferV1
    @doc "Exposes True Fungible Transfer Functions"
    ;;
    ;;  SCHEMAS
    ;;
    (defschema TransferClass
        type:integer
        iz-it-simple:bool
    )
    ;;
    ;;  [UC]
    ;;
    (defun UC_ContainsEliteAurynz:bool (id-lst:[string]))
    (defun UC_BulkRemainders:[decimal] (id:string transfer-amount-lst:[decimal]))
    (defun UC_BulkFees:[decimal] (id:string transfer-amount-lst:[decimal]))
    ;;
    ;;  [URC]
    ;;
    (defun URC_MinimumOuro:decimal (account:string))
    (defun URC_VirtualOuro:decimal (account:string))
    (defun URC_ReceiverAmount:decimal (id:string sender:string receiver:string amount:decimal))
    (defun URC_UnityTransferIgnisPrice (transfer-amount:decimal))
        ;;
    (defun URC_TransferClasses:object{TransferClass} (id:string sender:string receiver:string amount:decimal))
    (defun URC_IzSimpleTransfer:bool (id:string sender:string receiver:string amount:decimal))
    (defun URC_TransferClassesForBulk:object{TransferClass} (id:string sender:string transfer-amount-lst:[decimal]))
    (defun URC_IzSimpleTransferForBulk:bool (id:string sender:string transfer-amount-lst:[decimal]))
        ;;
    (defun URC_IzTrueFungibleEliteAuryn:bool (id:string))
    (defun URC_IzTrueFungibleUnity:bool (id:string))
    (defun URC_AreTrueFungiblesEliteAurynz:bool (id:string))
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_MinimumMapperForBulk (id:string transfer-amount-lst:[decimal]))
    (defun UEV_Minimum (id:string amount:decimal))
    (defun UEV_DispoLocker (id:string account:string))
    (defun UEV_MoveRoleCheck (id:string sender:string receiver:string))
    ;;
    ;;  [UDC]
    ;;
    (defun UDC_GetDispoData:object{UtilityDptfV1.DispoData} (account:string))
    (defun UDC_SmallTransmuteCumulator:object{IgnisCollectorV1.OutputCumulator} (id:string transmuter:string))
    (defun UDC_LargeTransmuteCumulator:object{IgnisCollectorV1.OutputCumulator} (id:string transmuter:string))
    (defun UDC_UnityTransferCumulator:object{IgnisCollectorV1.OutputCumulator} (sender:string receiver:string amount:decimal))
        ;;
    (defun UDC_TransferCumulator:object{IgnisCollectorV1.OutputCumulator} (type:integer id:string sender:string receiver:string))
    (defun UDC_SmallTransferCumulator:object{IgnisCollectorV1.OutputCumulator} (id:string sender:string receiver:string))
    (defun UDC_MediumTransferCumulator:object{IgnisCollectorV1.OutputCumulator} (id:string sender:string receiver:string))
    (defun UDC_LargeTransferCumulator:object{IgnisCollectorV1.OutputCumulator} (sender:string receiver:string))
        ;;
    (defun UDC_MultiTransferCumulator:object{IgnisCollectorV1.OutputCumulator} (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal]))
        ;;
    (defun UDC_MultiBulkTransferCumulator:object{IgnisCollectorV1.OutputCumulator} (id-lst:[string] sender:string receiver-array:[[string]] transfer-amount-array:[[decimal]]))
    (defun UDC_BulkTransferCumulator:object{IgnisCollectorV1.OutputCumulator} (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal]))
    (defun UDC_UnityBulkTransferCumulator:object{IgnisCollectorV1.OutputCumulator} (sender:string receiver-lst:[string] transfer-amount-lst:[decimal]))
    (defun UDC_SimpleBulkTransferCumulator:object{IgnisCollectorV1.OutputCumulator} (id:string sender:string size:integer))
    (defun UDC_ComplexBulkTransferCumulator:object{IgnisCollectorV1.OutputCumulator} (id:string sender:string size:integer))
    (defun UDC_EliteBulkTransferCumulator:object{IgnisCollectorV1.OutputCumulator} (id:string sender:string size:integer))
    ;;
    ;;  [C]
    ;;
    (defun C_ClearDispo:object{IgnisCollectorV1.OutputCumulator} (account:string))
    (defun C_Transmute:object{IgnisCollectorV1.OutputCumulator} (id:string transmuter:string transmute-amount:decimal))
    (defun C_Transfer:object{IgnisCollectorV1.OutputCumulator} (id:string sender:string receiver:string transfer-amount:decimal method:bool))
    (defun C_MultiTransfer:object{IgnisCollectorV1.OutputCumulator} (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
    (defun C_MultiBulkTransfer:object{IgnisCollectorV1.OutputCumulator} (id-lst:[string] sender:string receiver-array:[[string]] transfer-amount-array:[[decimal]]))
    ;;
)
;;
;;  [Meta-Fungible]
;;
(interface DemiourgosPactMetaFungibleV6
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
    (defun C_AddQuantity:object{IgnisCollectorV1.OutputCumulator} (id:string nonce:integer account:string amount:decimal))
    (defun C_Burn:object{IgnisCollectorV1.OutputCumulator} (id:string nonce:integer account:string amount:decimal))
    (defun C_Control:object{IgnisCollectorV1.OutputCumulator} (id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool))
    (defun C_Create:object{IgnisCollectorV1.OutputCumulator} (id:string account:string meta-data:[object]))
    (defun C_DeployAccount (id:string account:string))
    (defun C_Issue:object{IgnisCollectorV1.OutputCumulator} (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool]))
    (defun C_Mint:object{IgnisCollectorV1.OutputCumulator} (id:string account:string amount:decimal meta-data:[object]))
    (defun C_MultiBatchTransfer:object{IgnisCollectorV1.OutputCumulator} (id:string nonces:[integer] sender:string receiver:string method:bool))
    (defun C_RotateOwnership:object{IgnisCollectorV1.OutputCumulator} (id:string new-owner:string))
    (defun C_SingleBatchTransfer:object{IgnisCollectorV1.OutputCumulator} (id:string nonce:integer sender:string receiver:string method:bool))
    (defun C_ToggleFreezeAccount:object{IgnisCollectorV1.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_TogglePause:object{IgnisCollectorV1.OutputCumulator}  (id:string toggle:bool))
    (defun C_ToggleTransferRole:object{IgnisCollectorV1.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_Transfer:object{IgnisCollectorV1.OutputCumulator} (id:string nonce:integer sender:string receiver:string transfer-amount:decimal method:bool))
    (defun C_Wipe:object{IgnisCollectorV1.OutputCumulator} (id:string atbw:string))
    (defun C_WipePartial:object{IgnisCollectorV1.OutputCumulator} (id:string atbw:string nonces:[integer]))
    ;;
    (defun XB_DeployAccountWNE (id:string account:string))
    (defun XB_IssueFree:object{IgnisCollectorV1.OutputCumulator} (account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool] iz-special:[bool]))
    (defun XB_UpdateEliteSingle (id:string account:string))
    (defun XB_UpdateElite (id:string sender:string receiver:string))
    (defun XB_WriteRoles (id:string account:string rp:integer d:bool))
    ;;
    (defun XE_MoveCreateRole (id:string receiver:string))
    (defun XE_ToggleAddQuantityRole (id:string account:string toggle:bool))
    (defun XE_ToggleBurnRole (id:string account:string toggle:bool))
    (defun XE_UpdateRewardBearingToken (atspair:string id:string))
    (defun XE_UpdateSpecialMetaFungible:object{IgnisCollectorV1.OutputCumulator} (main-dptf:string secondary-dpmf:string vesting-or-sleeping:bool))
)
;;
;;  [Orto Fungibles]
;;
(interface DpofUdcV1
    @doc "Exposes DPOF UDC Constructors"
    ;;
    ;;  SCHEMAS
    ;;
    (defschema DPOF|Properties
        id:string
        owner-konto:string
        name:string
        ticker:string
        decimals:integer
        ;;
        can-upgrade:bool
        can-change-owner:bool
        can-add-special-role:bool
        can-transfer-oft-create-role:bool
        can-freeze:bool
        can-wipe:bool
        can-pause:bool
        segmentation:bool
        ;;
        is-paused:bool
        nonces-used:integer
        nonces-excluded:integer
        ;;
        supply:decimal
        ;;
        reward-bearing-token:string
        vesting-link:string
        sleeping-link:string
        hibernation-link:string
        ;;
    )
    ;;Nonces cant be separated. A Ortofungible Nonce has one unique holder.
    (defschema DPOF|NonceElement
        holder:string                       ;;Stores the <OuronetAccount> holding the nonce - mutable
        id:string                           ;;ID of the Ortofungible - immutable.
        value:integer                       ;;Stores the Nonce value itself - immutable.
        supply:decimal                      ;;Nonce Supply - mutable
        meta-data-chain:[object]            ;;Stores Nonce Metadata - immutable
    )
    (defschema DPOF|VerumRoles
        a-frozen:[string]
        r-oft-add-quantity:[string]
        r-oft-burn:[string]
        r-oft-create:string
        r-transfer:[string]
    )
    (defschema DPOF|AccountRoles
        total-account-supply:decimal        ;; Holds the Total Account Supply for id
        frozen:bool                         ;; multiple
        role-oft-add-quantity:bool          ;; multiple
        role-oft-burn:bool                  ;; multiple
        role-oft-create:bool                ;; single
        role-transfer:bool                  ;; multiple
        ;;
        ;;ForSelect, store Key Make-up
        id:string
        account:string
    )
    (defschema RemovableNonces
        @doc "Removable Nonces are Class 0 Nonces held by a given Account with greater than 0 supply \
        \ Given an <account>, a dpdc <id>, and a list of <nonces>, they can be filtered to Removable Nonces"
        r-nonces:[integer]
        r-amounts:[decimal]
    )
)

(interface DemiourgosPactOrtoFungibleV1
    @doc "Exposes Functions related to Orto-Fungibles \
    \ Orto-Fungibles are the next Evoloution of the Meta-Fungibles \
    \ using a newer and more efficient Architecture, and fixing discovered bugs \
    \ \
    \ The most important functionality is the ability for an Ouronet Account to own \
    \ as many Nonces (Elements) as needed without any limitations \
    \ which was the main reason Orto-Fungible was created \
    \ \
    \ Existing Meta-Fungible <id> and <accounts> will have to be migrated to Orto-Fungibles \
    \ Luckily Meta-Fungible usage hasnt properly started at the time of Orto-Fungible Deployment"
    ;;
    ;;  [UC]
    ;;
    (defun UC_IdNonce:string (id:string nonce:integer))
    (defun UC_IdAccount:string (id:string account:string))
    (defun UC_IzSingular:bool (id:string nonces:[integer]))
    (defun UC_IzConsecutive:bool (id:string nonces:[integer]))
    (defun UC_TakePureWipe:object{DpofUdcV1.RemovableNonces} (input:object{DpofUdcV1.RemovableNonces} size:integer))
    (defun UC_MoveCumulator:object{IgnisCollectorV1.OutputCumulator} (id:string nonces:[integer] transmit-or-transfer:bool))
    (defun UC_WipeCumulator:object{IgnisCollectorV1.OutputCumulator} (id:string removable-nonces-obj:object{DpofUdcV1.RemovableNonces}))
    ;;
    ;;  [UR]
    ;;
    (defun UR_P-KEYS:[string] ())
    (defun UR_N-KEYS:[string] ())
    (defun UR_V-KEYS:[string] ())
    (defun UR_KEYS:[string] ())
    ;;
    ;;  [0] DPOF|T|Properties:{DpofUdcV1.DPOF|Properties}
    (defun UR_Konto:string (id:string))
    (defun UR_Name:string (id:string))
    (defun UR_Ticker:string (id:string))
    (defun UR_Decimals:integer (id:string))
    (defun UR_CanUpgrade:bool (id:string))
    (defun UR_CanChangeOwner:bool (id:string))
    (defun UR_CanAddSpecialRole:bool (id:string))
    (defun UR_CanTransferOftCreateRole:bool (id:string))
    (defun UR_CanFreeze:bool (id:string))
    (defun UR_CanWipe:bool (id:string))
    (defun UR_CanPause:bool (id:string))
    (defun UR_IsPaused:bool (id:string))
    (defun UR_Segmentation:bool (id:string))
    (defun UR_NoncesUsed:integer (id:string))
    (defun UR_NoncesExcluded:integer (id:string))
    (defun UR_Supply:decimal (id:string))
    (defun UR_RewardBearingToken:string (id:string))
    (defun UR_Vesting:string (id:string))
    (defun UR_Sleeping:string (id:string))
    (defun UR_Hibernation:string (id:string))
    (defun UR_IzId:bool (id:string))
    ;;
    ;;  [1] DPOF|T|Nonces:{DpofUdcV1.DPOF|NonceElement}
    (defun UR_NonceHolder:string (id:string nonce:integer))
    (defun UR_NonceID:string (id:string nonce:integer))
    (defun UR_NonceValue:integer (id:string nonce:integer))
    (defun UR_NonceSupply:decimal (id:string nonce:integer))
    (defun UR_NonceMetaData:[object] (id:string nonce:integer))
    (defun UR_NoncesSupplies:[decimal] (id:string nonces:[integer]))
    (defun UR_NoncesMetaDatas:[[object]] (id:string nonces:[integer]))
    (defun UR_IzNonce:bool (id:string nonce:integer))
    ;;
    ;;  [2] DPOF|T|VerumRoles:{DpofUdcV1.DPOF|VerumRoles}
    (defun UR_Verum1:[string] (id:string))
    (defun UR_Verum2:[string] (id:string))
    (defun UR_Verum3:[string] (id:string))
    (defun UR_Verum4:string (id:string))
    (defun UR_Verum5:[string] (id:string))
    ;;
    ;;  [3] DPOF|T|AccountRoles:{DpofUdcV1.DPOF|AccountRoles}
    (defun UR_R-Frozen:bool (id:string account:string))
    (defun UR_R-AddQuantity:bool (id:string account:string))
    (defun UR_R-Burn:bool (id:string account:string))
    (defun UR_R-Create:bool (id:string account:string))
    (defun UR_R-Transfer:bool (id:string account:string))
    (defun UR_AccountSupply:decimal (id:string account:string))
    (defun UR_IzAccount:bool (id:string account:string))
    ;;
    ;;  [URC]
    ;;
    (defun URDC_WipePure:object{DpofUdcV1.RemovableNonces} (account:string id:string))
    (defun URC_IzRBT:bool (reward-bearing-token:string))
    (defun URC_IzRBTg:bool (atspair:string reward-bearing-token:string))
        ;;
    (defun URC_HasVesting:bool (id:string))
    (defun URC_HasSleeping:bool (id:string))
    (defun URC_HasHibernation:bool (id:string))
    (defun URC_Parent:string (dpof:string))
    ;;
    ;;  [URD]
    ;;
    (defun URD_HeldOrtoFungibles:[string] (account:string))
    (defun URD_ExistingOrtoFungibles:[string] (dotf:string))
    (defun URD_OwnedOrtoFungibles:[string] (account:string))
    (defun URD_AccountNonces:[integer] (account:string dpof-id:string))
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_id (id:string))
    (defun UEV_NoncesCirculating (id:string nonces:[integer]))
    (defun UEV_ParentOwnership (id:string))
    (defun UEV_NoncesToAccount (id:string account:string nonces:[integer]))
    (defun UEV_Amount (id:string amount:decimal))
        ;;
    (defun UEV_UpdateRewardBearingToken (id:string))
    (defun UEV_CanUpgradeON (id:string))
    (defun UEV_CanChangeOwnerON (id:string))
    (defun UEV_CanAddSpecialRoleON (id:string))
    (defun UEV_CanTransferOftCreateRoleON (id:string))
    (defun UEV_CanFreezeON (id:string))
    (defun UEV_CanWipeON (id:string))
    (defun UEV_CanPauseON (id:string))
    (defun UEV_PauseState (id:string state:bool))
        ;;
    (defun UEV_SegmentationState (id:string state:bool))
    (defun UEV_AccountFreezeState (id:string account:string state:bool))
    (defun UEV_AccountAddQuantityState (id:string account:string state:bool))
    (defun UEV_AccountBurnState (id:string account:string state:bool))
    (defun UEV_AccountCreateState (id:string account:string state:bool))
    (defun UEV_AccountTransferState (id:string account:string state:bool))
        ;;
    (defun UEV_Vesting (id:string existance:bool))
    (defun UEV_Sleeping (id:string existance:bool))
    (defun UEV_Hibernation (id:string existance:bool))
    (defun UEV_MoveRoleCheck (id:string sender:string receiver:string))
    ;;
    ;;  [UDC]
    ;;
    (defun UDC_NonceElement:object{DpofUdcV1.DPOF|NonceElement}
        (a:string b:string c:integer d:decimal e:[object])
    )
    (defun UDC_VerumRoles:object{DpofUdcV1.DPOF|VerumRoles}
        (a:[string] b:[string] c:[string] d:string e:[string])
    )
    (defun UDC_AccountRoles:object{DpofUdcV1.DPOF|AccountRoles}
        (a:decimal b:bool c:bool d:bool e:bool f:bool g:string h:string)
    )
    (defun UDC_RemovableNonces:object{DpofUdcV1.RemovableNonces}
        (a:[integer] b:[decimal])
    )
    ;;
    ;;  [CAP]
    ;;
    (defun CAP_Owner (id:string))
    ;;
    ;;  [C]
    ;;
    (defun C_Issue:object{IgnisCollectorV1.OutputCumulator}
        (
            patron:string account:string 
            name:[string] ticker:[string] decimals:[integer]
            can-upgrade:[bool] can-change-owner:[bool] can-add-special-role:[bool] can-transfer-oft-create-role:[bool]
            can-freeze:[bool] can-wipe:[bool] can-pause:[bool]
        )
    )
    (defun C_RotateOwnership:object{IgnisCollectorV1.OutputCumulator} (id:string new-owner:string))
    (defun C_Control:object{IgnisCollectorV1.OutputCumulator} (id:string cu:bool cco:bool casr:bool ctocr:bool cf:bool cw:bool cp:bool sg:bool))
    (defun C_TogglePause:object{IgnisCollectorV1.OutputCumulator} (id:string toggle:bool))
        ;;
    (defun C_DeployAccount (id:string account:string))
    (defun C_ToggleFreezeAccount:object{IgnisCollectorV1.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_ToggleAddQuantityRole:object{IgnisCollectorV1.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_ToggleBurnRole:object{IgnisCollectorV1.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_MoveCreateRole:object{IgnisCollectorV1.OutputCumulator} (id:string receiver:string))
    (defun C_ToggleTransferRole:object{IgnisCollectorV1.OutputCumulator} (id:string account:string toggle:bool))
        ;;
    (defun C_AddQuantity:object{IgnisCollectorV1.OutputCumulator} (id:string account:string nonce:integer amount:decimal))
    (defun C_Burn:object{IgnisCollectorV1.OutputCumulator} (id:string account:string nonce:integer amount:decimal))
    (defun C_Mint:object{IgnisCollectorV1.OutputCumulator} (id:string account:string amount:decimal meta-data-chain:[object]))
        ;;
    (defun C_WipeSlim:object{IgnisCollectorV1.OutputCumulator} (id:string account:string nonce:integer amount:decimal))
    (defun C_WipeHeavy:object{IgnisCollectorV1.OutputCumulator} (id:string account:string))
    (defun C_WipePure:object{IgnisCollectorV1.OutputCumulator} (id:string account:string removable-nonces-obj:object{DpofUdcV1.RemovableNonces}))
    (defun C_WipeClean:object{IgnisCollectorV1.OutputCumulator} (id:string account:string nonces:[integer]))
        ;;
    (defun C_Transmit:object{IgnisCollectorV1.OutputCumulator} (id:string nonces:[integer] amounts:[decimal] sender:string receiver:string method:bool))
    (defun C_Transfer:object{IgnisCollectorV1.OutputCumulator} (id:string nonces:[integer] sender:string receiver:string method:bool))
    ;;
    ;;  [X]
    ;;
    (defun XB_IssueFree:object{IgnisCollectorV1.OutputCumulator}
        (
            account:string
            ;;
            name:[string]
            ticker:[string]
            decimals:[integer]
            ;;
            can-upgrade:[bool]
            can-change-owner:[bool]
            can-add-special-role:[bool]
            can-transfer-oft-create-role:[bool]
            ;;
            can-freeze:[bool]
            can-wipe:[bool]
            can-pause:[bool]
            ;;
            iz-special:[bool]
        )
    )
    (defun XB_DeployAccountWNE (account:string id:string))
    (defun XB_InsertNewNonce (nonce-owner:string id:string nonce:integer amount:decimal meta-data-chain:[object]))
    (defun XE_UpdateRewardBearingToken (atspair:string hot-rbt:string))
    (defun XE_UpdateSpecialOrtoFungible:object{IgnisCollectorV1.OutputCumulator}
        (main-dptf:string secondary-dpof:string vzh-tag:integer)
    )
    (defun XB_W|AccountRoles (id:string account:string account-data:object{DpofUdcV1.DPOF|AccountRoles}))

)
;;
;;  [ELITE]
;;
(interface EliteV1
    @doc "Exposes Elite Account Related Functions"
    ;;
    ;;  [URC]
    ;;
    (defun URC_EliteAurynzSupply (account:string))
    (defun URC_IzIdEA:bool (id:string))
    ;;
    ;;  [X]
    ;;
    (defun XE_UpdateEliteSingle (id:string account:string))
    (defun XE_UpdateElite (id:string sender:string receiver:string))

)
(interface AutostakeV6
    @doc "Brings not only Improved Autostake Architecture but also added Functionality: \
        \ \
        \ \
        \ 1]Autostake Pools can be configured with a Royalty on deposit. This remains in the ATS|SC-NAME \
        \ and can be withdrawn by Pool Owner \
        \ \
        \ 2]Third Recovery Method added, the Direct Recovery, where the RBT is realeased immediatly. \
        \ This option has its own Fee system. This fee ALWAYS increases Pool Index \
        \ \
        \ 3]Adds a new Mode, <Hibernation> Mode, \
        \ Using this mode, the RT is coiled directly into the Hibernating Counterpart of the Output RBT \
        \ Allows Participation into Autostake Pools to generate directly locked-tokens. \
        \ \
        \ 4]At most, the Autostake Pools can be configured with 7 Reward Tokens (RTs) \
        \ \
        \ 5]Position 0, instead of unlimited uncoil Positions, has an upper limitd number of positions \
        \ This is due to increase gas costs as the used positions increase in number \
        \ This number will be increased in the future to reflect the Max Gas per TX available.\
        \ \
        \ 6]Updated code such that Autostake Pools use Orto Fungibles instead of Meta Fungibles. \
        \ \
        \ \
        \ 7]PERMISSION ROLES \
        \ for DPTF and DPMF (now DPOF) that used to exist in this module, are moved \
        \ in their respective Modules. Instead a new mechanics is used in the Autostake Code, \
        \ such that these functions dont need to be here any more. \
        \ This was related to how the Autostake ATS|SC_NAME needed Token Permissions to function \
        \ Now the ATS|SC_NAME is granted the required permissions to function in a different manner \
        \ \
        \ \
        \ For DPTFs \
        \ ATS|SC_NAME hat innate <role-burn> <role-mint> <role-fee-exemption> for any DPTF and cannot be frozen \
        \ This is to allow its unrestricted operation with any DPTFs \
        \ \
        \ For DPOFs \
        \ The DPOF in relation to an ATS-Pair is its Hot-RBT \
        \ While the DPMF had a single <role-nft-create> and this had to be given to the ATS-Pair in  \
        \ order for it to function as the ATS-Pair Hot RBT, now a different functionality is used: \
        \ The DPOF can have up to 2 distinct <role-oft-create> Roles, first by its owner as innate, \
        \ the 2nd one given to a distinct designated account. Now the ATS-Pair must be the owner of the DPOF \
        \ designated as the Hot-RBT, solving the issue of this permission. \
        \ Also, while a DPOF is owned by the ATS|SC_NAME, its second <role-oft-create> if given to another account \
        \ isnt taken into consideration, making the ATS|SC_NAME the only account allowed to mint its Hot-RBT DPOF \
        \ \
        \ Also, similar as for DPTFs, the ATS|SC_NAME has innate <role-burn> <role-mint> for any DPOF \
        \ completly solving the Permission Issues for its functioning, which allows discarding of complex Logic \
        \ that was used prior to DPOFs \
        \ \
        \ \
        \ \
        \ V6 brings table optimisations for use with <select>"
    ;;
    ;;  SCHEMAS
    ;;
    (defschema ATS|RewardTokenSchemaV2
        token:string
        nfr:bool
        resident:decimal
        unbonding:decimal
        royalty:decimal
    )
    (defschema ATS|Hot
        mint-time:time
    )
    (defschema CoilData
        primal-input-amount:decimal
        first-input-amount:decimal
        royalty-fee:decimal
        last-input-amount:decimal
        hibernation-fee:decimal
        rbt-amount:decimal
        rbt-id:string
    )
    ;;
    ;;  [UC]
    ;;
    (defun URU_UpgradeAtspairToV2 (atspairs:[string]))
    (defun UC_AtspairAccount:string (atspair:string account:string))
    ;;
    ;;  [UR]
    ;;
    (defun UR_P-KEYS:[string] ())
    (defun UR_KEYS:[string] ())
    ;;
    ;;  [UR]
    ;;
    ;;  [0    ATS|Pairs:{ATS|PropertiesSchema}
    (defun UR_OwnerKonto:string (atspair:string))
    (defun UR_CanUpgrade:bool (atspair:string))
    (defun UR_CanChangeOwner:bool (atspair:string))
    (defun UR_Syphoning:bool (atspair:string))
    (defun UR_Hibernate:bool (atspair:string))
    (defun UR_IndexName:string (atspair:string))
    (defun UR_IndexDecimals:integer (atspair:string))
    (defun UR_Royalty:decimal (atspair:string))
    (defun UR_Syphon:decimal (atspair:string))
        ;;
    (defun UR_PeakHibernatePromile:decimal (atspair:string))
    (defun UR_HibernateDecay:decimal (atspair:string))
        ;;
    (defun UR_Lock:bool (atspair:string))
    (defun UR_Unlocks:integer (atspair:string))
        ;;
    (defun UR_RewardTokens:[object{ATS|RewardTokenSchemaV2}] (atspair:string))
    (defun UR_RewardTokenList:[string] (atspair:string))
    (defun UR_RewardTokenNFR:[bool] (atspair:string))
    (defun UR_RewardTokenRUR:[decimal] (atspair:string rur:integer))
    (defun UR_SingleRewardTokenNFR:bool (atspair:string rt:string))
    (defun UR_SingleRewardTokenRUR:decimal (atspair:string rt:string rur:integer))
        ;;
    (defun UR_ColdRewardBearingToken:string (atspair:string))
    (defun UR_ColdNativeFeeRedirection:bool (atspair:string))
    (defun UR_ColdRecoveryPositions:integer (atspair:string))
    (defun UR_ColdRecoveryFeeThresholds:[decimal] (atspair:string))
    (defun UR_ColdRecoveryFeeTable:[[decimal]] (atspair:string))
    (defun UR_ColdRecoveryFeeRedirection:bool (atspair:string))
    (defun UR_ColdRecoveryDuration:[integer] (atspair:string))
    (defun UR_EliteMode:bool (atspair:string))
        ;;
    (defun UR_HotRewardBearingToken:string (atspair:string))
    (defun UR_HotRecoveryStartingFeePromile:decimal (atspair:string))
    (defun UR_HotRecoveryDecayPeriod:integer (atspair:string))
    (defun UR_HotRecoveryFeeRedirection:bool (atspair:string))
        ;;
    (defun UR_DirectRecoveryFee:decimal (atspair:string))
        ;;
    (defun UR_ToggleColdRecovery:bool (atspair:string))
    (defun UR_ToggleHotRecovery:bool (atspair:string))
    (defun UR_ToggleDirectRecovery:bool (atspair:string))
    ;;
    (defun UR_RtPrecisions:[integer] (atspair:string))
    (defun UR_P0:[object{UtilityAtsV1.Awo}] (atspair:string account:string))
    (defun UR_P1-7:object{UtilityAtsV1.Awo} (atspair:string account:string position:integer))
    ;;
    ;;  [URC]
    ;;
    (defun URC_Index (atspair:string))
    (defun URC_ResidentSum:decimal (atspair:string))
    (defun URC_PairRBTSupply:decimal (atspair:string))
    (defun URC_RBT:decimal (atspair:string rt:string rt-amount:decimal))
    (defun URC_RTSplitAmounts:[decimal] (atspair:string rbt-amount:decimal))
    (defun URC_MaxSyphon:[decimal] (atspair:string))
        ;;
    (defun URC_RewardTokenPosition:integer (atspair:string reward-token:string))
        ;;
    (defun URC_AccountUnbondingBalance:decimal (atspair:string account:string reward-token:string))
    (defun URC_CullValue:[decimal] (atspair:string input:object{UtilityAtsV1.Awo}))
    (defun URC_WhichPosition:integer (atspair:string c-rbt-amount:decimal account:string))
    (defun URC_ColdRecoveryFee (atspair:string c-rbt-amount:decimal input-position:integer))
    (defun URC_CullColdRecoveryTime:time (atspair:string account:string))
    (defun URC_IzPresentHotRBT:bool (atspair:string))
        ;;
    (defun URC_RewardBearingTokenAmounts:object{CoilData} (ats:string rt:string amount:decimal))
    (defun URC_RewardBearingTokenAmountsWithHibernation:object{CoilData} (ats:string rt:string amount:decimal hibernation-dayz:integer))
    ;;
    ;;  [URD]
    ;;
    (defun URD_HeldAutostakePairs:[string] (account:string))
    (defun URD_ExistingAutostakePairs:[string] (ats:string))
    (defun URD_OwnedAutostakePairs:[string] (account:string))
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_id (atspair:string))
    (defun UEV_CanUpgradeON (atspair:string))
    (defun UEV_CanChangeOwnerON (atspair:string))
    (defun UEV_RewardTokenExistance (atspair:string reward-token:string existance:bool))
    (defun UEV_RewardBearingTokenExistance (atspair:string reward-bearing-token:string existance:bool cold-or-hot:bool))
    (defun UEV_ParameterLockState (atspair:string state:bool))
    (defun UEV_EliteState (atspair:string state:bool))
    (defun UEV_ColdRecoveryState (atspair:string state:bool))
    (defun UEV_HotRecoveryState (atspair:string state:bool))
    (defun UEV_DirectRecoveryState (atspair:string state:bool))
    (defun UEV_IssueData (atspair:string index-decimals:integer reward-token:string reward-bearing-token:string))
    ;;
    ;;  [UDC]
    ;;
    (defun UDC_MakeUnstakeObject:object{UtilityAtsV1.Awo} (atspair:string tm:time))
    (defun UDC_MakeZeroUnstakeObject:object{UtilityAtsV1.Awo} (atspair:string))
    (defun UDC_MakeNegativeUnstakeObject:object{UtilityAtsV1.Awo} (atspair:string))
    (defun UDC_ComposePrimaryRewardToken:object{ATS|RewardTokenSchemaV2} (token:string nfr:bool))
    (defun UDC_RT:object{ATS|RewardTokenSchemaV2} (a:string b:bool c:decimal d:decimal e:decimal))
    (defun UDC_CoilData:object{CoilData} (a:decimal b:decimal c:decimal d:decimal e:decimal f:decimal g:string))
    ;;
    ;;  [CAP]
    ;;
    (defun CAP_Owner (id:string))
    ;;
    ;;  [C]
    ;;
    (defun C_HOT-RBT|UpdatePendingBranding:object{IgnisCollectorV1.OutputCumulator} (entity-id:string logo:string description:string website:string social:[object{BrandingV1.SocialSchema}]))
    (defun C_HOT-RBT|UpgradeBranding (patron:string entity-id:string months:integer))
    (defun C_HOT-RBT|Repurpose:object{IgnisCollectorV1.OutputCumulator} (hot-rbt:string nonce:integer repurpose-to:string))
        ;;
    (defun C_Issue:object{IgnisCollectorV1.OutputCumulator}
        (
            patron:string
            account:string
            atspair:[string]
            index-decimals:[integer]
            reward-token:[string]
            rt-nfr:[bool]
            reward-bearing-token:[string]
            rbt-nfr:[bool]
        )
    )
    (defun C_RotateOwnership:object{IgnisCollectorV1.OutputCumulator} (atspair:string new-owner:string))
    (defun C_Control:object{IgnisCollectorV1.OutputCumulator} (atspair:string can-change-owner:bool syphoning:bool hibernate:bool))
    (defun C_UpdateRoyalty:object{IgnisCollectorV1.OutputCumulator} (atspair:string royalty:decimal))
    (defun C_UpdateSyphon:object{IgnisCollectorV1.OutputCumulator} (atspair:string syphon:decimal))
    (defun C_SetHibernationFees:object{IgnisCollectorV1.OutputCumulator} (atspair:string peak:decimal decay:decimal))
        ;;
    (defun C_ToggleParameterLock:object{IgnisCollectorV1.OutputCumulator} (patron:string atspair:string toggle:bool))
    (defun C_AddSecondary:object{IgnisCollectorV1.OutputCumulator} (atspair:string reward-token:string rt-nfr:bool))
        ;;
    (defun C_ControlColdRecoveryFees:object{IgnisCollectorV1.OutputCumulator} (atspair:string c-nfr:bool c-fr:bool))
    (defun C_SetColdRecoveryFees:object{IgnisCollectorV1.OutputCumulator} (atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]]))
    (defun C_SetColdRecoveryDuration:object{IgnisCollectorV1.OutputCumulator} (atspair:string soft-or-hard:bool base:integer growth:integer))
    (defun C_ToggleElite:object{IgnisCollectorV1.OutputCumulator} (atspair:string toggle:bool))
    (defun C_SwitchColdRecovery:object{IgnisCollectorV1.OutputCumulator} (atspair:string toggle:bool))
        ;;
    (defun C_AddHotRBT:object{IgnisCollectorV1.OutputCumulator} (atspair:string hot-rbt:string))
    (defun C_ControlHotRecoveryFee:object{IgnisCollectorV1.OutputCumulator} (atspair:string h-fr:bool))
    (defun C_SetHotRecoveryFees:object{IgnisCollectorV1.OutputCumulator} (atspair:string promile:decimal decay:integer))
    (defun C_SwitchHotRecovery:object{IgnisCollectorV1.OutputCumulator} (atspair:string toggle:bool))
        ;;
    (defun C_SetDirectRecoveryFee:object{IgnisCollectorV1.OutputCumulator} (atspair:string promile:decimal))
    (defun C_SwitchDirectRecovery:object{IgnisCollectorV1.OutputCumulator} (atspair:string toggle:bool))
    ;;
    ;;  [X]
    ;;
    (defun XE_RemoveSecondary (atspair:string reward-token:string))
    (defun XE_UpdateRUR (atspair:string reward-token:string rur:integer direction:bool amount:decimal))
    (defun XE_SpawnAutostakeAccount (atspair:string account:string))
    (defun XE_ReshapeUnstakeAccount (atspair:string account:string rp:integer))
    (defun XE_UpP0 (atspair:string account:string obj:[object{UtilityAtsV1.Awo}]))
    (defun XE_UpP1 (atspair:string account:string obj:object{UtilityAtsV1.Awo}))
    (defun XE_UpP2 (atspair:string account:string obj:object{UtilityAtsV1.Awo}))
    (defun XE_UpP3 (atspair:string account:string obj:object{UtilityAtsV1.Awo}))
    (defun XE_UpP4 (atspair:string account:string obj:object{UtilityAtsV1.Awo}))
    (defun XE_UpP5 (atspair:string account:string obj:object{UtilityAtsV1.Awo}))
    (defun XE_UpP6 (atspair:string account:string obj:object{UtilityAtsV1.Awo}))
    (defun XE_UpP7 (atspair:string account:string obj:object{UtilityAtsV1.Awo}))
    ;;
)

(interface AutostakeUsageV1
    @doc "Exposes Autostake Usage Functions, which involve Token Transfers"
    ;;
    ;;  [URC]
    ;;
    (defun URC_MultiCull:object (ats:string acc:string))
    (defun URC_SingleCull:[decimal] (ats:string acc:string position:integer))
    ;;
    ;;  [UDC]
    ;;
    (defun UDC_UnlimitedUncoilCumulator:object{IgnisCollectorV1.OutputCumulator} (ats:string account:string))
    ;;
    ;;  [A]
    ;;
    (defun A_RemoveSecondary:object{IgnisCollectorV1.OutputCumulator}
        (remover:string ats:string reward-token:string accounts-with-ats-data:[string])
    )
    ;;
    ;;  [C]
    ;;
    (defun C_RemoveSecondary:object{IgnisCollectorV1.OutputCumulator}
        (remover:string ats:string reward-token:string)
    )
    (defun C_WithdrawRoyalties:object{IgnisCollectorV1.OutputCumulator}(ats:string target:string))
        ;;
    (defun C_KickStart:object{IgnisCollectorV1.OutputCumulator} (kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal))
    (defun C_Fuel:object{IgnisCollectorV1.OutputCumulator} (fueler:string ats:string reward-token:string amount:decimal))
    (defun C_Coil:object{IgnisCollectorV1.OutputCumulator} (coiler:string ats:string rt:string amount:decimal))
    (defun C_Curl:object{IgnisCollectorV1.OutputCumulator} (curler:string ats1:string ats2:string rt:string amount:decimal))
        ;;
    (defun C_ColdRecovery:object{IgnisCollectorV1.OutputCumulator} (recoverer:string ats:string ra:decimal))
    (defun C_Cull:object{IgnisCollectorV1.OutputCumulator}(culler:string ats:string))
        ;;
    (defun C_HotRecovery:object{IgnisCollectorV1.OutputCumulator} (recoverer:string ats:string ra:decimal))
    (defun C_Recover:object{IgnisCollectorV1.OutputCumulator} (recoverer:string id:string nonce:integer))
    (defun C_Redeem:object{IgnisCollectorV1.OutputCumulator} (redeemer:string id:string nonce:integer))
        ;;
    (defun C_DirectRecovery:object{IgnisCollectorV1.OutputCumulator} (recoverer:string ats:string ra:decimal))
        ;;
    (defun C_Syphon:object{IgnisCollectorV1.OutputCumulator} (syphon-target:string ats:string syphon-amounts:[decimal]))
    ;;
)
;;
;;  [VESTING]
;;
(interface VestingV1
    @doc "Exposes Vesting Functions"
    ;;
    ;;  SCHEMAS
    ;;
    (defschema VST|MetaDataSchema
        release-amount:decimal
        release-date:time
    )
    (defschema VST|HibernatingSchema
        mint-time:time
        release-date:time
    )
    ;;
    ;;  [UC]
    ;;
    (defun UC_MergeAll:[decimal] (balances:[decimal] seconds-to-unsleep:[decimal]))
    ;;
    ;;  [URC]
    ;;
    (defun URC_CullMetaDataAmountWithObject:list (id:string nonce:integer))
    (defun URC_SecondsToUnlock:[decimal] (id:string nonces:[integer]))
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_NoncesForMerging (nonces:[integer]))
    (defun UEV_StillHasSleeping (sleeping-dpof:string nonce:integer))
    ;;
    ;;  [UDC]
    ;;
    (defun UDC_ComposeVestingMetaData:[object{VST|MetaDataSchema}]
        (dptf:string amount:decimal offset:integer duration:integer milestones:integer)
    )
    ;;
    ;;  [C]
    ;;
    (defun C_CreateFrozenLink:object{IgnisCollectorV1.OutputCumulator} (patron:string dptf:string))
    (defun C_CreateReservationLink:object{IgnisCollectorV1.OutputCumulator} (patron:string dptf:string))
    (defun C_CreateVestingLink:object{IgnisCollectorV1.OutputCumulator} (patron:string dptf:string))
    (defun C_CreateSleepingLink:object{IgnisCollectorV1.OutputCumulator} (patron:string dptf:string))
    (defun C_CreateHibernatingLink:object{IgnisCollectorV1.OutputCumulator} (patron:string dptf:string))
        ;;
    (defun C_Freeze:object{IgnisCollectorV1.OutputCumulator} (freezer:string freeze-output:string dptf:string amount:decimal))
    (defun C_RepurposeFrozen:object{IgnisCollectorV1.OutputCumulator} (dptf-to-repurpose:string repurpose-from:string repurpose-to:string))
    (defun C_ToggleTransferRoleFrozenDPTF:object{IgnisCollectorV1.OutputCumulator} (s-dptf:string target:string toggle:bool))
        ;;
    (defun C_Reserve:object{IgnisCollectorV1.OutputCumulator} (reserver:string dptf:string amount:decimal))
    (defun C_Unreserve:object{IgnisCollectorV1.OutputCumulator} (unreserver:string r-dptf:string amount:decimal))
    (defun C_RepurposeReserved:object{IgnisCollectorV1.OutputCumulator} (dptf-to-repurpose:string repurpose-from:string repurpose-to:string))
    (defun C_ToggleTransferRoleReservedDPTF:object{IgnisCollectorV1.OutputCumulator} (s-dptf:string target:string toggle:bool))
        ;;
    (defun C_Vest:object{IgnisCollectorV1.OutputCumulator} (vester:string target-account:string dptf:string amount:decimal offset:integer duration:integer milestones:integer))
    (defun C_Unvest:object{IgnisCollectorV1.OutputCumulator} (unvester:string dpof:string nonce:integer))
    (defun C_RepurposeVested:object{IgnisCollectorV1.OutputCumulator} (dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string))
        ;;
    (defun C_Sleep:object{IgnisCollectorV1.OutputCumulator} (sleeper:string target-account:string dptf:string amount:decimal duration:integer))
    (defun C_Unsleep:object{IgnisCollectorV1.OutputCumulator} (unsleeper:string dpof:string nonce:integer))
    (defun C_Merge:object{IgnisCollectorV1.OutputCumulator} (merger:string dpof:string nonces:[integer]))
    (defun C_RepurposeMerge:object{IgnisCollectorV1.OutputCumulator} (dpof-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string))
    (defun C_RepurposeSleeping:object{IgnisCollectorV1.OutputCumulator} (dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string))
    (defun C_ToggleTransferRoleSleepingDPOF:object{IgnisCollectorV1.OutputCumulator} (s-dpof:string target:string toggle:bool))
    ;;
    (defun C_Hibernate:object{IgnisCollectorV1.OutputCumulator} (hibernator:string target-account:string dptf:string amount:decimal dayz:integer))
    (defun C_Awake:object{IgnisCollectorV1.OutputCumulator} (awaker:string dpof:string nonce:integer))
    (defun C_Slumber:object{IgnisCollectorV1.OutputCumulator} (merger:string dpof:string nonces:[integer]))
    (defun C_RepurposeSlumber:object{IgnisCollectorV1.OutputCumulator} (dpof-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string))
    (defun C_RepurposeHibernating:object{IgnisCollectorV1.OutputCumulator} (dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string))
    (defun C_ToggleTransferRoleHibernatingDPOF:object{IgnisCollectorV1.OutputCumulator} (s-dpof:string target:string toggle:bool))
    ;;
    (defun C_Constrict:object{IgnisCollectorV1.OutputCumulator} (constricter:string ats:string rt:string amount:decimal dayz:integer))
    (defun C_Brumate:object{IgnisCollectorV1.OutputCumulator} (brumator:string ats1:string ats2:string rt:string amount:decimal dayz:integer))
    ;;
)
;;
;;  [LIQUID]
;;
(interface StoaLiquidStakingV1
    @doc "Exposes the two functions needed Liquid Staking Functions, Wrap and Unwrap STOA and URSTOA"
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
    (defun C_UnwrapStoa:object{IgnisCollectorV1.OutputCumulator} (unwrapper:string amount:decimal))
    (defun C_WrapStoa:object{IgnisCollectorV1.OutputCumulator} (wrapper:string amount:decimal))
)
;;
;;  [OUROBOROS]
;;
(interface OuroborosV1
    @doc "Exposes Functions related to the OUROBOROS Module"
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
    (defun C_Compress:object{IgnisCollectorV1.OutputCumulator} (client:string ignis-amount:decimal))
    (defun C_Fuel:object{IgnisCollectorV1.OutputCumulator} ())
    (defun C_Sublimate:object{IgnisCollectorV1.OutputCumulator} (client:string target:string ouro-amount:decimal))
    (defun C_WithdrawFees:object{IgnisCollectorV1.OutputCumulator} (id:string target:string))
)
;;
;;  [SWP]
;;
(interface SwapTracerV1
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
    (defun URC_MakeGraph:[object{BreadthFirstSearchV1.GraphNode}] (input:string output:string swpairs:[string] principal-lst:[string]))
    (defun URC_TokenNeighbours:[string] (token-id:string principal-lst:[string]))
    (defun URC_TokenSwpairs:[string] (token-id:string principal-lst:[string]))
    (defun URC_PrincipalSwpairs:[string] (id:string principal:string principal-lst:[string]))
    (defun URC_Edges:[string] (t1:string t2:string principal-lst:[string])) ;;1
    ;;
    (defun UEV_IdAsPrincipal (id:string for-trace:bool principals-lst:[string]))
    ;;
    (defun XE_MultiPathTracer (swpair:string principals-lst:[string]))
)
(interface SwapperV1
    @doc "Exposes Swapper Related Functions, except those related to adding and swapping liquidity"
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
    (defun URD_OwnedSwapPairs:[string] (account:string))
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
    (defun C_ChangeOwnership:object{IgnisCollectorV1.OutputCumulator} (swpair:string new-owner:string))
    (defun C_EnableFrozenLP:object{IgnisCollectorV1.OutputCumulator} (patron:string swpair:string))
    (defun C_EnableSleepingLP:object{IgnisCollectorV1.OutputCumulator} (patron:string swpair:string))
    (defun C_ModifyCanChangeOwner:object{IgnisCollectorV1.OutputCumulator} (swpair:string new-boolean:bool))
    (defun C_ModifyWeights:object{IgnisCollectorV1.OutputCumulator} (swpair:string new-weights:[decimal]))
    (defun C_ToggleAddOrSwap:object{IgnisCollectorV1.OutputCumulator} (swpair:string toggle:bool add-or-swap:bool))
    (defun C_ToggleFeeLock:object{IgnisCollectorV1.OutputCumulator} (patron:string swpair:string toggle:bool))
    (defun C_UpdateAmplifier:object{IgnisCollectorV1.OutputCumulator} (swpair:string amp:decimal))
    (defun C_UpdateFee:object{IgnisCollectorV1.OutputCumulator} (swpair:string new-fee:decimal lp-or-special:bool))
    (defun C_UpdateSpecialFeeTargets:object{IgnisCollectorV1.OutputCumulator} (swpair:string targets:[object{FeeSplit}]))
    ;;
    (defun XB_ModifyWeights (swpair:string new-weights:[decimal]))
    ;;
    (defun XE_UpdateSupplies (swpair:string new-supplies:[decimal]))
    (defun XE_UpdateSupply (swpair:string id:string new-supply:decimal))
    (defun XE_Issue:string (account:string pool-tokens:[object{PoolTokens}] token-lp:string fee-lp:decimal weights:[decimal] amp:decimal p:bool))
    (defun XE_CanAddOrSwapToggle (swpair:string toggle:bool add-or-swap:bool))
    ;;
)
(interface SwapperIssueV1
    @doc "Exposes SWP Issuing Functions. \
    \ Also contains Swap Computation Functions, and the Hopper Function"
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
    (defun UC_VirtualSwap:object{UtilitySwpV1.VirtualSwapEngine} 
        (vse:object{UtilitySwpV1.VirtualSwapEngine} dsid:object{UtilitySwpV1.DirectSwapInputData})
    )
    (defun UC_BareboneSwapWithFeez:object{UtilitySwpV1.DirectTaxedSwapOutput}
        (
            account:string pool-type:string 
            dsid:object{UtilitySwpV1.DirectSwapInputData} fees:object{UtilitySwpV1.SwapFeez}
            A:decimal X:[decimal] X-prec:[integer] input-positions:[integer] output-position:integer weights:[decimal]
        )
    )
    (defun UC_InverseBareboneSwapWithFeez:object{UtilitySwpV1.InverseTaxedSwapOutput}
        (
            account:string pool-type:string 
            rsid:object{UtilitySwpV1.ReverseSwapInputData} fees:object{UtilitySwpV1.SwapFeez}
            A:decimal X:[decimal] X-prec:[integer] output-position:integer input-position:integer weights:[decimal]
        )
    )
    (defun UC_BareboneSwap:decimal (pool-type:string drsi:object{UtilitySwpV1.DirectRawSwapInput}))
    (defun UC_BareboneInverseSwap:decimal (pool-type:string irsi:object{UtilitySwpV1.InverseRawSwapInput}))
    (defun UC_PoolTokenPositions:[integer] (swpair:string input-ids:[string]))
    ;;
    ;;
    ;;  [URC] Functions
    ;;
    (defun URC_EliteFeeReduction:object{UtilitySwpV1.SwapFeez} (account:string fees:object{UtilitySwpV1.SwapFeez}))
    (defun URC_PoolTokenPositions:[integer] (swpair:string input-ids:[string]))
    (defun URC_DirectRawSwapInput:object{UtilitySwpV1.DirectRawSwapInput} (swpair:string dsid:object{UtilitySwpV1.DirectSwapInputData}))
    (defun URC_InverseRawSwapInput:object{UtilitySwpV1.InverseRawSwapInput} (swpair:string rsid:object{UtilitySwpV1.ReverseSwapInputData}))
        ;;
    (defun URC_Swap:decimal (swpair:string dsid:object{UtilitySwpV1.DirectSwapInputData} validation:bool))
    (defun URC_S-Swap:decimal (swpair:string dsid:object{UtilitySwpV1.DirectSwapInputData}))
    (defun URC_W-Swap:decimal (swpair:string dsid:object{UtilitySwpV1.DirectSwapInputData}))
    (defun URC_P-Swap:decimal (swpair:string dsid:object{UtilitySwpV1.DirectSwapInputData}))
        ;;
    (defun URC_InverseSwap:decimal (swpair:string rsid:object{UtilitySwpV1.ReverseSwapInputData} validation:bool))
    (defun URC_S-InverseSwap:decimal (swpair:string rsid:object{UtilitySwpV1.ReverseSwapInputData}))
    (defun URC_W-InverseSwap:decimal (swpair:string rsid:object{UtilitySwpV1.ReverseSwapInputData}))
    (defun URC_P-InverseSwap (swpair:string rsid:object{UtilitySwpV1.ReverseSwapInputData}))
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
    (defun UEV_SwapData (swpair:string dsid:object{UtilitySwpV1.DirectSwapInputData}))
    (defun UEV_InverseSwapData (swpair:string rsid:object{UtilitySwpV1.ReverseSwapInputData}))
        ;;
    (defun UEV_Issue (account:string pool-tokens:[object{SwapperV1.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool))
    ;;
    ;;
    ;;  [UDC] Functions
    ;;
    (defun UDC_DirectRawSwapInput:object{UtilitySwpV1.DirectRawSwapInput} 
        (dsid:object{UtilitySwpV1.DirectSwapInputData} A:decimal X:[decimal] input-positions:[integer] output-position:integer weights:[decimal])
    )
    (defun UDC_InverseRawSwapInput:object{UtilitySwpV1.InverseRawSwapInput} 
        (rsid:object{UtilitySwpV1.ReverseSwapInputData} A:decimal X:[decimal] output-position:integer input-position:integer weights:[decimal])
    )
    (defun UDC_Hopper:object{Hopper} (a:[string] b:[string] c:[decimal]))
    ;;
    ;;
    ;;  []C] Functions
    ;;
    ;;
    (defun C_Issue:object{IgnisCollectorV1.OutputCumulator} (patron:string account:string pool-tokens:[object{SwapperV1.PoolTokens}] fee-lp:decimal weights:[decimal] amp:decimal p:bool))    
)
(interface SwapperLiquidityV1
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
        perfect-ignis-fee:object{IgnisCollectorV1.OutputCumulator}   
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
        F:object{UtilitySwpV1.SwapFeez}
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
    (defun UDC_VirtualSwapEngineSwpair:object{UtilitySwpV1.VirtualSwapEngine} (account:string account-liq:[decimal] swpair:string pool-liq:[decimal]))
    (defun UDC_VirtualSwapEngine:object{UtilitySwpV1.VirtualSwapEngine}
        (
            account:string account-liq:[decimal] swpair:string starting-liq:[decimal]
            A:decimal W:[decimal] F:object{UtilitySwpV1.SwapFeez}
        )
    )
    (defun UDC_PoolFees:object{UtilitySwpV1.SwapFeez} (swpair:string))
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
    (defun UDC_CladOperation:object{CladOperation} (a:object{IgnisCollectorV1.OutputCumulator} b:[string] c:[decimal] d:bool e:[string] f:[decimal] g:[decimal] h:[decimal]))
    (defun UDC_PoolState:object{PoolState} (a:decimal b:object{UtilitySwpV1.SwapFeez} c:[decimal] d:[decimal] e:decimal f:[string] g:[decimal]))
    ;;
)
(interface SwapperLiquidityClientV1
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
    (defun UEV_AddSleepingLiquidity (account:string swpair:string sleeping-dpof:string nonce:integer))
    (defun UEV_AddDormantLiquidity (swpair:string))
    (defun UEV_AddChilledLiquidity (swpair:string ld:object{SwapperLiquidityV1.LiquidityData}))
    (defun UEV_AddLiquidity (swpair:string ld:object{SwapperLiquidityV1.LiquidityData}))
    (defun UEV_RemoveLiquidity (swpair:string lp-amount:decimal))
    ;;
    ;;
    ;;  []C] Functions
    ;;
    ;;
    (defun C_ToggleAddLiquidity:object{IgnisCollectorV1.OutputCumulator} (swpair:string toggle:bool))
    (defun C_Fuel:object{IgnisCollectorV1.OutputCumulator} (account:string swpair:string input-amounts:[decimal] direct-or-indirect:bool validation:bool))
        ;;
    (defun C|KDA-PID_AddStandardLiquidity:object{IgnisCollectorV1.OutputCumulator} (account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun C|KDA-PID_AddIcedLiquidity:object{IgnisCollectorV1.OutputCumulator} (account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun C|KDA-PID_AddGlacialLiquidity:object{IgnisCollectorV1.OutputCumulator} (account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun C|KDA-PID_AddFrozenLiquidity:object{IgnisCollectorV1.OutputCumulator} (account:string swpair:string frozen-dptf:string input-amount:decimal kda-pid:decimal))
    (defun C|KDA-PID_AddSleepingLiquidity:object{IgnisCollectorV1.OutputCumulator} (account:string swpair:string sleeping-dpof:string nonce:integer kda-pid:decimal))
        ;;
    (defun C_RemoveLiquidity:object{IgnisCollectorV1.OutputCumulator} (account:string swpair:string lp-amount:decimal))
)
(interface SwapperUsageV1
    @doc "Exposes Adding|Removing Liquidty and Swapping Functions of the SWP Module"
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
    (defun UDC_SlippageObject:object{Slippage} (swpair:string dsid:object{UtilitySwpV1.DirectSwapInputData} slippage-value:decimal))
    ;;
    ;;
    ;;  []C] Functions
    ;;
    ;;
    (defun C_ToggleSwapCapability:object{IgnisCollectorV1.OutputCumulator} (swpair:string toggle:bool))
    (defun C_Swap:object{IgnisCollectorV1.OutputCumulator} (account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string slippage:decimal kda-pid:decimal))
)
(interface SwapperMtxV1
    @doc "Exposes SWP MultiStep (via defpact) Functions."
    ;;
    ;;
    ;;  []C] Functions
    ;;
    ;;
    (defun C_IssueStablePool (patron:string account:string pool-tokens:[object{SwapperV1.PoolTokens}] fee-lp:decimal amp:decimal p:bool))
    (defun C_IssueWeightedPool (patron:string account:string pool-tokens:[object{SwapperV1.PoolTokens}] fee-lp:decimal weights:[decimal] p:bool))
    (defun C_IssueStandardPool (patron:string account:string pool-tokens:[object{SwapperV1.PoolTokens}] fee-lp:decimal p:bool))
    ;;
    (defun C_AddStandardLiquidity (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun C_AddIcedLiquidity (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun C_AddGlacialLiquidity (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun C_AddFrozenLiquidity (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal kda-pid:decimal))
    (defun C_AddSleepingLiquidity (patron:string account:string swpair:string sleeping-dpof:string nonce:integer kda-pid:decimal))
    ;;
)