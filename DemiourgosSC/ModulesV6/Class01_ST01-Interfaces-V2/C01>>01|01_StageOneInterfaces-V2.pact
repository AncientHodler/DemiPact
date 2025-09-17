;;Ouronet Policy Remains as is
;;
;;  [DALOS]
;;
(interface OuronetDalosV5
    ;;
    ;;  SCHEMAS
    ;;
    (defschema DPTF|BalanceSchemaV2
        @doc "Schema that Stores Account Balances for DPTF Tokens (True Fungibles)\
            \ Key for the Table is a string composed of: <DPTF id> + BAR + <account> \
            \ This ensure a single entry per DPTF id per account. \
            \ As an Exception OUROBOROS and IGNIS Account Data is Stored at the DALOS Account Level"
        ;;exist:bool                [x]Removed at V2
        balance:decimal
        frozen:bool
        role-burn:bool
        role-mint:bool
        role-fee-exemption:bool
        role-transfer:bool
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
    (defun UR_TrueFungible:object{DPTF|BalanceSchemaV2} (account:string snake-or-gas:bool))
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

(interface IgnisCollectorV2
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

(interface OuronetInfoV3
    @doc "Holds Information Schema"
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
    (defun OI|UC_IfpFromOutputCumulator:decimal (input:object{IgnisCollectorV2.OutputCumulator}))
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

(interface DalosInfoV3
    @doc "Exposes Information Function for the Dalos Client Functions"
    ;;
    ;;
    ;;  [URC] Functions
    ;;
    (defun DALOS-INFO|URC_ControlSmartAccount:object{OuronetInfoV3.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_DeploySmartAccount:object{OuronetInfoV3.ClientInfo} (account:string))
    (defun DALOS-INFO|URC_DeployStandardAccount:object{OuronetInfoV3.ClientInfo} (account:string))
    (defun DALOS-INFO|URC_RotateGovernor:object{OuronetInfoV3.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_RotateGuard:object{OuronetInfoV3.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_RotateKadena:object{OuronetInfoV3.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_RotateSovereign:object{OuronetInfoV3.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_UpdateEliteAccount:object{OuronetInfoV3.ClientInfo} (patron:string account:string))
    (defun DALOS-INFO|URC_UpdateEliteAccountSquared:object{OuronetInfoV3.ClientInfo} (patron:string sender:string receiver:string))
)
;;
;;  [Branding]
;;
(interface BrandingUsageV9
    @doc "Exposes Branding Functions for True-Fungibles (T), Meta-Fungibles (M), ATS-Pairs (A) and SWP-Pairs (S) \
        \ Uses V2 IgnisCumulatorV2 Architecture (fixed Ignis Collection for Smart Ouronet Accounts) \
        \ V4 Removes <patron> input variable where it is not needed"
    ;;
    (defun C_UpdatePendingBranding:object{IgnisCollectorV2.OutputCumulator} (entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun C_UpgradeBranding (patron:string entity-id:string months:integer))
)
(interface BrandingUsageV10
    @doc "Exposes Branding Functions for True-Fungible LP Tokens \
        \ <entity-pos>: 1 (Native LP), 2 (Freezing LP), 3 (Sleeping LP) \
        \ Uses V2 IgnisCumulatorV2 Architecture (fixed Ignis Collection for Smart Ouronet Accounts) \
        \ V5 Removes <patron> input variable where it is not needed"
    ;;
    (defun C_UpdatePendingBrandingLPs:object{IgnisCollectorV2.OutputCumulator} (swpair:string entity-pos:integer logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun C_UpgradeBrandingLPs (patron:string swpair:string entity-pos:integer months:integer))
)
(interface BrandingUsageV11
    @doc "Exposes Branding Functions for Semi-Fungibles (S) and Non-Fungibles (N) \
        \ Uses V2 IgnisCumulatorV2 Architecture (fixed Ignis Collection for Smart Ouronet Accounts)"
    ;;
    (defun C_UpdatePendingBranding:object{IgnisCollectorV2.OutputCumulator} (entity-id:string son:bool logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun C_UpgradeBranding (patron:string entity-id:string son:bool  months:integer))
)
;;
;;  [True Fungibles]
;;
(interface DemiourgosPactTrueFungibleV6
    @doc "Exposes most of the Functions related to True-Fungibles \
    \ \
    \ V6 moves to a more improved efficient architecture while adding support for Hibernating Tokens"
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
    ;;  [0] DPTF|PropertiesTable:{DPTF|PropertiesSchemaV2}
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
    ;;  [2]     DPTF|BalanceTable:{OuronetDalosV5.DPTF|BalanceSchemaV2}
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
    (defun UDC_TrueFungibleAccount:object{OuronetDalosV5.DPTF|BalanceSchemaV2} (a:decimal b:bool c:bool d:bool e:bool f:bool))
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
    (defun C_Issue:object{IgnisCollectorV2.OutputCumulator}
        (
            patron:string account:string 
            name:[string] ticker:[string] decimals:[integer] 
            can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] 
            can-freeze:[bool] can-wipe:[bool] can-pause:[bool]
        )
    )
    (defun C_RotateOwnership:object{IgnisCollectorV2.OutputCumulator} (id:string new-owner:string))
    (defun C_Control:object{IgnisCollectorV2.OutputCumulator} (id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool))
    (defun C_TogglePause:object{IgnisCollectorV2.OutputCumulator} (id:string toggle:bool))
    (defun C_ToggleReservation:object{IgnisCollectorV2.OutputCumulator} (id:string toggle:bool))
        ;;
    (defun C_ToggleFee:object{IgnisCollectorV2.OutputCumulator} (id:string toggle:bool))
    (defun C_SetMinMove:object{IgnisCollectorV2.OutputCumulator} (id:string min-move-value:decimal))
    (defun C_SetFee:object{IgnisCollectorV2.OutputCumulator} (id:string fee:decimal))
    (defun C_SetFeeTarget:object{IgnisCollectorV2.OutputCumulator} (id:string target:string))
    (defun C_ToggleFeeLock:object{IgnisCollectorV2.OutputCumulator} (patron:string id:string toggle:bool))
        ;;
    (defun C_DeployAccount (id:string account:string))
    (defun C_ToggleFreezeAccount:object{IgnisCollectorV2.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_ToggleBurnRole:object{IgnisCollectorV2.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_ToggleMintRole:object{IgnisCollectorV2.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_ToggleFeeExemptionRole:object{IgnisCollectorV2.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_ToggleTransferRole:object{IgnisCollectorV2.OutputCumulator} (id:string account:string toggle:bool))
        ;;
    (defun C_Burn:object{IgnisCollectorV2.OutputCumulator} (id:string account:string amount:decimal))
    (defun C_Mint:object{IgnisCollectorV2.OutputCumulator} (id:string account:string amount:decimal origin:bool))
    (defun C_WipeSlim:object{IgnisCollectorV2.OutputCumulator} (id:string account-to-be-wiped:string amount-to-be-wiped:decimal))
    (defun C_Wipe:object{IgnisCollectorV2.OutputCumulator} (id:string account-to-be-wiped:string))
    ;;
    ;;  [X]
    ;;
    (defun XE_IssueLP:object{IgnisCollectorV2.OutputCumulator} (name:string ticker:string))
    (defun XB_IssueFree:object{IgnisCollectorV2.OutputCumulator}
        (
            account:string
            name:[string]
            ticker:[string]
            decimals:[integer]
            can-change-owner:[bool]
            can-upgrade:[bool]
            can-add-special-role:[bool]
            can-freeze:[bool]
            can-wipe:[bool]
            can-pause:[bool]
            iz-special:[bool]
        )
    )
    (defun XB_DeployAccountWNE (account:string id:string))
    (defun XE_UpdateFeeVolume (id:string amount:decimal primary:bool))
    (defun XE_UpdateRewardToken (atspair:string id:string direction:bool))
    (defun XE_UpdateRewardBearingToken (atspair:string id:string))
    (defun XE_UpdateVesting (dptf:string dpof:string))
    (defun XE_UpdateSleeping (dptf:string dpof:string))
    (defun XE_UpdateHibernation (dptf:string dpof:string))
)

(interface TrueFungibleTransferV8
    @doc "Exposes True Fungible Transfer Functions \
    \ V8 brings more gas optimisations"
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
    ;;  [UR]
    ;;
    (defun DPTF-DPOF-ATS|UR_OwnedTokens (account:string table-to-query:integer))
    (defun DPTF-DPOF-ATS|UR_FilterKeysForInfo:[string] (account-or-token-id:string table-to-query:integer mode:bool))
    (defun DPTF-DPOF-ATS|UR_TableKeys:[string] (position:integer poi:bool))
    (defun DPTF|URC_GetOwnedSupplies:[decimal] (id:string))
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
    (defun UDC_GetDispoData:object{UtilityDptf.DispoData} (account:string))
    (defun UDC_SmallTransmuteCumulator:object{IgnisCollectorV2.OutputCumulator} (id:string transmuter:string))
    (defun UDC_LargeTransmuteCumulator:object{IgnisCollectorV2.OutputCumulator} (id:string transmuter:string))
    (defun UDC_UnityTransferCumulator:object{IgnisCollectorV2.OutputCumulator} (sender:string receiver:string amount:decimal))
        ;;
    (defun UDC_TransferCumulator:object{IgnisCollectorV2.OutputCumulator} (type:integer id:string sender:string receiver:string))
    (defun UDC_SmallTransferCumulator:object{IgnisCollectorV2.OutputCumulator} (id:string sender:string receiver:string))
    (defun UDC_MediumTransferCumulator:object{IgnisCollectorV2.OutputCumulator} (id:string sender:string receiver:string))
    (defun UDC_LargeTransferCumulator:object{IgnisCollectorV2.OutputCumulator} (sender:string receiver:string))
        ;;
    (defun UDC_MultiTransferCumulator:object{IgnisCollectorV2.OutputCumulator} (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal]))
        ;;
    (defun UDC_MultiBulkTransferCumulator:object{IgnisCollectorV2.OutputCumulator} (id-lst:[string] sender:string receiver-array:[[string]] transfer-amount-array:[[decimal]]))
    (defun UDC_BulkTransferCumulator:object{IgnisCollectorV2.OutputCumulator} (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal]))
    (defun UDC_UnityBulkTransferCumulator:object{IgnisCollectorV2.OutputCumulator} (sender:string receiver-lst:[string] transfer-amount-lst:[decimal]))
    (defun UDC_SimpleBulkTransferCumulator:object{IgnisCollectorV2.OutputCumulator} (id:string sender:string size:integer))
    (defun UDC_ComplexBulkTransferCumulator:object{IgnisCollectorV2.OutputCumulator} (id:string sender:string size:integer))
    (defun UDC_EliteBulkTransferCumulator:object{IgnisCollectorV2.OutputCumulator} (id:string sender:string size:integer))
    ;;
    ;;  [C]
    ;;
    (defun C_ClearDispo:object{IgnisCollectorV2.OutputCumulator} (account:string))
    (defun C_Transmute:object{IgnisCollectorV2.OutputCumulator} (id:string transmuter:string transmute-amount:decimal))
    (defun C_Transfer:object{IgnisCollectorV2.OutputCumulator} (id:string sender:string receiver:string transfer-amount:decimal method:bool))
    (defun C_MultiTransfer:object{IgnisCollectorV2.OutputCumulator} (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool))
    (defun C_MultiBulkTransfer:object{IgnisCollectorV2.OutputCumulator} (id-lst:[string] sender:string receiver-array:[[string]] transfer-amount-array:[[decimal]]))
    ;;
)
;;
;;  [Orto Fungibles]
;;
(interface DpofUdc
    ;;
    ;;  SCHEMAS
    ;;
    (defschema DPOF|Properties
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
    )
    (defschema RemovableNonces
        @doc "Removable Nonces are Class 0 Nonces held by a given Account with greater than 0 supply \
        \ Given an <account>, a dpdc <id>, and a list of <nonces>, they can be filtered to Removable Nonces"
        r-nonces:[integer]
        r-amounts:[decimal]
    )
)

(interface DemiourgosPactOrtoFungible
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
    (defun UC_TakePureWipe:object{DpofUdc.RemovableNonces} (input:object{DpofUdc.RemovableNonces} size:integer))
    (defun UC_MoveCumulator:object{IgnisCollectorV2.OutputCumulator} (id:string nonces:[integer] transmit-or-transfer:bool))
    (defun UC_WipeCumulator:object{IgnisCollectorV2.OutputCumulator} (id:string removable-nonces-obj:object{DpofUdc.RemovableNonces}))
    ;;
    ;;  [UR]
    ;;
    (defun UR_P-KEYS:[string] ())
    (defun UR_N-KEYS:[string] ())
    (defun UR_V-KEYS:[string] ())
    (defun UR_KEYS:[string] ())
    ;;
    ;;  [0] DPOF|T|Properties:{DpofUdc.DPOF|Properties}
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
    ;;  [1] DPOF|T|Nonces:{DpofUdc.DPOF|NonceElement}
    (defun UR_NonceHolder:string (id:string nonce:integer))
    (defun UR_NonceID:string (id:string nonce:integer))
    (defun UR_NonceValue:integer (id:string nonce:integer))
    (defun UR_NonceSupply:decimal (id:string nonce:integer))
    (defun UR_NonceMetaData:[object] (id:string nonce:integer))
    (defun UR_NoncesSupplies:[decimal] (id:string nonces:[integer]))
    (defun UR_NoncesMetaDatas:[[object]] (id:string nonces:[integer]))
    (defun UR_IzNonce:bool (id:string nonce:integer))
    ;;
    ;;  [2] DPOF|T|VerumRoles:{DpofUdc.DPOF|VerumRoles}
    (defun UR_Verum1:[string] (id:string))
    (defun UR_Verum2:[string] (id:string))
    (defun UR_Verum3:[string] (id:string))
    (defun UR_Verum4:string (id:string))
    (defun UR_Verum5:[string] (id:string))
    ;;
    ;;  [3] DPOF|T|AccountRoles:{DpofUdc.DPOF|AccountRoles}
    (defun UR_R-Frozen:bool (id:string account:string))
    (defun UR_R-AddQuantity:bool (id:string account:string))
    (defun UR_R-Burn:bool (id:string account:string))
    (defun UR_R-Create:bool (id:string account:string))
    (defun UR_R-Transfer:bool (id:string account:string))
    (defun UR_AccountSupply:decimal (id:string account:string))
    (defun UR_IzAccount:bool (id:string account:string))
        ;;
    (defun URD_AccountNonces:[integer] (account:string dpof-id:string))
    ;;
    ;;  [URC]
    ;;
    (defun URDC_WipePure:object{DpofUdc.RemovableNonces} (account:string id:string))
    (defun URC_IzRBT:bool (reward-bearing-token:string))
    (defun URC_IzRBTg:bool (atspair:string reward-bearing-token:string))
        ;;
    (defun URC_HasVesting:bool (id:string))
    (defun URC_HasSleeping:bool (id:string))
    (defun URC_HasHibernation:bool (id:string))
    (defun URC_Parent:string (dpof:string))
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
    (defun UDC_NonceElement:object{DpofUdc.DPOF|NonceElement}
        (a:string b:string c:integer d:decimal e:[object])
    )
    (defun UDC_VerumRoles:object{DpofUdc.DPOF|VerumRoles}
        (a:[string] b:[string] c:[string] d:string e:[string])
    )
    (defun UDC_AccountRoles:object{DpofUdc.DPOF|AccountRoles}
        (a:decimal b:bool c:bool d:bool e:bool f:bool)
    )
    (defun UDC_RemovableNonces:object{DpofUdc.RemovableNonces}
        (a:[integer] b:[decimal])
    )
    ;;
    ;;  [CAP]
    ;;
    (defun CAP_Owner (id:string))
    ;;
    ;;  [C]
    ;;
    (defun C_Issue:object{IgnisCollectorV2.OutputCumulator}
        (
            patron:string account:string 
            name:[string] ticker:[string] decimals:[integer]
            can-upgrade:[bool] can-change-owner:[bool] can-add-special-role:[bool] can-transfer-oft-create-role:[bool]
            can-freeze:[bool] can-wipe:[bool] can-pause:[bool]
        )
    )
    (defun C_RotateOwnership:object{IgnisCollectorV2.OutputCumulator} (id:string new-owner:string))
    (defun C_Control:object{IgnisCollectorV2.OutputCumulator} (id:string cu:bool cco:bool casr:bool ctocr:bool cf:bool cw:bool cp:bool sg:bool))
    (defun C_TogglePause:object{IgnisCollectorV2.OutputCumulator} (id:string toggle:bool))
        ;;
    (defun C_DeployAccount (id:string account:string))
    (defun C_ToggleFreezeAccount:object{IgnisCollectorV2.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_ToggleAddQuantityRole:object{IgnisCollectorV2.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_ToggleBurnRole:object{IgnisCollectorV2.OutputCumulator} (id:string account:string toggle:bool))
    (defun C_MoveCreateRole:object{IgnisCollectorV2.OutputCumulator} (id:string receiver:string))
    (defun C_ToggleTransferRole:object{IgnisCollectorV2.OutputCumulator} (id:string account:string toggle:bool))
        ;;
    (defun C_AddQuantity:object{IgnisCollectorV2.OutputCumulator} (id:string account:string nonce:integer amount:decimal))
    (defun C_Burn:object{IgnisCollectorV2.OutputCumulator} (id:string account:string nonce:integer amount:decimal))
    (defun C_Mint:object{IgnisCollectorV2.OutputCumulator} (id:string account:string amount:decimal meta-data-chain:[object]))
        ;;
    (defun C_WipeSlim:object{IgnisCollectorV2.OutputCumulator} (id:string account:string nonce:integer amount:decimal))
    (defun C_WipeHeavy:object{IgnisCollectorV2.OutputCumulator} (id:string account:string))
    (defun C_WipePure:object{IgnisCollectorV2.OutputCumulator} (id:string account:string removable-nonces-obj:object{DpofUdc.RemovableNonces}))
    (defun C_WipeClean:object{IgnisCollectorV2.OutputCumulator} (id:string account:string nonces:[integer]))
        ;;
    (defun C_Transmit:object{IgnisCollectorV2.OutputCumulator} (id:string nonces:[integer] amounts:[decimal] sender:string receiver:string method:bool))
    (defun C_Transfer:object{IgnisCollectorV2.OutputCumulator} (id:string nonces:[integer] sender:string receiver:string method:bool))
    ;;
    ;;  [X]
    ;;
    (defun XB_IssueFree:object{IgnisCollectorV2.OutputCumulator}
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
    (defun XB_W|AccountRoles (id:string account:string account-data:object{DpofUdc.DPOF|AccountRoles}))

)
;;
;;  [ELITE]
;;
(interface Elite
    @doc "Exposes Elite Account Related Functions \
    \ As well as Migration Functions from Meta to OrtoFungible"
    ;;
    ;;  [URC]
    ;;
    (defun URC_EliteAurynzSupply (account:string))
    (defun URC_IzIdEA:bool (id:string))
    ;;
    ;;  [A]
    ;;
    (defun A_MigrateMetaToOrtoFungibleId (id:string))
    (defun A_MigrateMetaToOrtoFungibleAccount (id:string account:string))
    ;;
    ;;  [X]
    ;;
    (defun XE_UpdateEliteSingle (id:string account:string))
    (defun XE_UpdateElite (id:string sender:string receiver:string))

)
;;
;;  [AUTOSTAKE]
;;
(interface AutostakeV5
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
        \ that was used prior to DPOFs"
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
    (defun UR_P0:[object{UtilityAtsV2.Awo}] (atspair:string account:string))
    (defun UR_P1-7:object{UtilityAtsV2.Awo} (atspair:string account:string position:integer))
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
    (defun URC_CullValue:[decimal] (atspair:string input:object{UtilityAtsV2.Awo}))
    (defun URC_WhichPosition:integer (atspair:string c-rbt-amount:decimal account:string))
    (defun URC_ColdRecoveryFee (atspair:string c-rbt-amount:decimal input-position:integer))
    (defun URC_CullColdRecoveryTime:time (atspair:string account:string))
    (defun URC_IzPresentHotRBT:bool (atspair:string))
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
    (defun UDC_MakeUnstakeObject:object{UtilityAtsV2.Awo} (atspair:string tm:time))
    (defun UDC_MakeZeroUnstakeObject:object{UtilityAtsV2.Awo} (atspair:string))
    (defun UDC_MakeNegativeUnstakeObject:object{UtilityAtsV2.Awo} (atspair:string))
    (defun UDC_ComposePrimaryRewardToken:object{ATS|RewardTokenSchemaV2} (token:string nfr:bool))
    (defun UDC_RT:object{ATS|RewardTokenSchemaV2} (a:string b:bool c:decimal d:decimal e:decimal))
    ;;
    ;;  [CAP]
    ;;
    (defun CAP_Owner (id:string))
    ;;
    ;;  [C]
    ;;
    (defun C_HOT-RBT|UpdatePendingBranding:object{IgnisCollectorV2.OutputCumulator} (entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun C_HOT-RBT|UpgradeBranding (patron:string entity-id:string months:integer))
    (defun C_HOT-RBT|Repurpose:object{IgnisCollectorV2.OutputCumulator} (hot-rbt:string nonce:integer repurpose-to:string))
        ;;
    (defun C_Issue:object{IgnisCollectorV2.OutputCumulator}
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
    (defun C_RotateOwnership:object{IgnisCollectorV2.OutputCumulator} (atspair:string new-owner:string))
    (defun C_Control:object{IgnisCollectorV2.OutputCumulator} (atspair:string can-change-owner:bool syphoning:bool hibernate:bool))
    (defun C_UpdateRoyalty:object{IgnisCollectorV2.OutputCumulator} (atspair:string royalty:decimal))
    (defun C_UpdateSyphon:object{IgnisCollectorV2.OutputCumulator} (atspair:string syphon:decimal))
    (defun C_SetHibernationFees:object{IgnisCollectorV2.OutputCumulator} (atspair:string peak:decimal decay:decimal))
        ;;
    (defun C_ToggleParameterLock:object{IgnisCollectorV2.OutputCumulator} (patron:string atspair:string toggle:bool))
    (defun C_AddSecondary:object{IgnisCollectorV2.OutputCumulator} (atspair:string reward-token:string rt-nfr:bool))
        ;;
    (defun C_ControlColdRecoveryFees:object{IgnisCollectorV2.OutputCumulator} (atspair:string c-nfr:bool c-fr:bool))
    (defun C_SetColdRecoveryFees:object{IgnisCollectorV2.OutputCumulator} (atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]]))
    (defun C_SetColdRecoveryDuration:object{IgnisCollectorV2.OutputCumulator} (atspair:string soft-or-hard:bool base:integer growth:integer))
    (defun C_ToggleElite:object{IgnisCollectorV2.OutputCumulator} (atspair:string toggle:bool))
    (defun C_SwitchColdRecovery:object{IgnisCollectorV2.OutputCumulator} (atspair:string toggle:bool))
        ;;
    (defun C_AddHotRBT:object{IgnisCollectorV2.OutputCumulator} (atspair:string hot-rbt:string))
    (defun C_ControlHotRecoveryFee:object{IgnisCollectorV2.OutputCumulator} (atspair:string h-fr:bool))
    (defun C_SetHotRecoveryFees:object{IgnisCollectorV2.OutputCumulator} (atspair:string promile:decimal decay:integer))
    (defun C_SwitchHotRecovery:object{IgnisCollectorV2.OutputCumulator} (atspair:string toggle:bool))
        ;;
    (defun C_SetDirectRecoveryFee:object{IgnisCollectorV2.OutputCumulator} (atspair:string promile:decimal))
    (defun C_SwitchDirectRecovery:object{IgnisCollectorV2.OutputCumulator} (atspair:string toggle:bool))
    ;;
    ;;  [X]
    ;;
    (defun XE_RemoveSecondary (atspair:string reward-token:string))
    (defun XE_Update_RUR (atspair:string reward-token:string rur:integer direction:bool amount:decimal))
    (defun XE_SpawnAutostakeAccount (atspair:string account:string))
    (defun XE_ReshapeUnstakeAccount (atspair:string account:string rp:integer))
    (defun XE_UpP0 (atspair:string account:string obj:[object{UtilityAtsV2.Awo}]))
    (defun XE_UpP1 (atspair:string account:string obj:object{UtilityAtsV2.Awo}))
    (defun XE_UpP2 (atspair:string account:string obj:object{UtilityAtsV2.Awo}))
    (defun XE_UpP3 (atspair:string account:string obj:object{UtilityAtsV2.Awo}))
    (defun XE_UpP4 (atspair:string account:string obj:object{UtilityAtsV2.Awo}))
    (defun XE_UpP5 (atspair:string account:string obj:object{UtilityAtsV2.Awo}))
    (defun XE_UpP6 (atspair:string account:string obj:object{UtilityAtsV2.Awo}))
    (defun XE_UpP7 (atspair:string account:string obj:object{UtilityAtsV2.Awo}))
    ;;
)

(interface AutostakeUsageV5
    @doc "Exposes Autostake Usage Functions, which involve Token Transfers \
    \ V5 comes with new Autostake Features such as Hibernation, Royalty, and Direct Recovery"
    ;;
    ;;  [A]
    ;;
    (defun A_RemoveSecondary:object{IgnisCollectorV2.OutputCumulator}
        (remover:string ats:string reward-token:string accounts-with-ats-data:[string])
    )
    ;;
    ;;  [C]
    ;;
    (defun C_RemoveSecondary:object{IgnisCollectorV2.OutputCumulator}
        (remover:string ats:string reward-token:string)
    )
    (defun C_WithdrawRoyalties:object{IgnisCollectorV2.OutputCumulator}(ats:string target:string))
        ;;
    (defun C_KickStart:object{IgnisCollectorV2.OutputCumulator} (kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal))
    (defun C_Fuel:object{IgnisCollectorV2.OutputCumulator} (fueler:string ats:string reward-token:string amount:decimal))
    (defun C_Coil:object{IgnisCollectorV2.OutputCumulator} (coiler:string ats:string rt:string amount:decimal))
    (defun C_Curl:object{IgnisCollectorV2.OutputCumulator} (curler:string ats1:string ats2:string rt:string amount:decimal))
        ;;
    (defun C_ColdRecovery:object{IgnisCollectorV2.OutputCumulator} (recoverer:string ats:string ra:decimal))
    (defun C_Cull:object{IgnisCollectorV2.OutputCumulator}(culler:string ats:string))
        ;;
    (defun C_HotRecovery:object{IgnisCollectorV2.OutputCumulator} (recoverer:string ats:string ra:decimal))
    (defun C_Recover:object{IgnisCollectorV2.OutputCumulator} (recoverer:string id:string nonce:integer amount:decimal))
    (defun C_Redeem:object{IgnisCollectorV2.OutputCumulator} (redeemer:string id:string nonce:integer))
        ;;
    (defun C_DirectRecovery:object{IgnisCollectorV2.OutputCumulator} (recoverer:string ats:string ra:decimal))
        ;;
    (defun C_Syphon:object{IgnisCollectorV2.OutputCumulator} (syphon-target:string ats:string syphon-amounts:[decimal]))
    ;;
)
;;
;;  [VESTING]
;;
(interface VestingV5
    @doc "Exposes Vesting Functions \
    \ V5 brings Hibernated Special Orto-Fungible, and migrates from Meta to Orto Fungible Usage"
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
    (defun C_CreateFrozenLink:object{IgnisCollectorV2.OutputCumulator} (patron:string dptf:string))
    (defun C_CreateReservationLink:object{IgnisCollectorV2.OutputCumulator} (patron:string dptf:string))
    (defun C_CreateVestingLink:object{IgnisCollectorV2.OutputCumulator} (patron:string dptf:string))
    (defun C_CreateSleepingLink:object{IgnisCollectorV2.OutputCumulator} (patron:string dptf:string))
    (defun C_CreateHibernatingLink:object{IgnisCollectorV2.OutputCumulator} (patron:string dptf:string))
        ;;
    (defun C_Freeze:object{IgnisCollectorV2.OutputCumulator} (freezer:string freeze-output:string dptf:string amount:decimal))
    (defun C_RepurposeFrozen:object{IgnisCollectorV2.OutputCumulator} (dptf-to-repurpose:string repurpose-from:string repurpose-to:string))
    (defun C_ToggleTransferRoleFrozenDPTF:object{IgnisCollectorV2.OutputCumulator} (s-dptf:string target:string toggle:bool))
        ;;
    (defun C_Reserve:object{IgnisCollectorV2.OutputCumulator} (reserver:string dptf:string amount:decimal))
    (defun C_Unreserve:object{IgnisCollectorV2.OutputCumulator} (unreserver:string r-dptf:string amount:decimal))
    (defun C_RepurposeReserved:object{IgnisCollectorV2.OutputCumulator} (dptf-to-repurpose:string repurpose-from:string repurpose-to:string))
    (defun C_ToggleTransferRoleReservedDPTF:object{IgnisCollectorV2.OutputCumulator} (s-dptf:string target:string toggle:bool))
        ;;
    (defun C_Vest:object{IgnisCollectorV2.OutputCumulator} (vester:string target-account:string dptf:string amount:decimal offset:integer duration:integer milestones:integer))
    (defun C_Unvest:object{IgnisCollectorV2.OutputCumulator} (unvester:string dpof:string nonce:integer))
    (defun C_RepurposeVested:object{IgnisCollectorV2.OutputCumulator} (dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string))
        ;;
    (defun C_Sleep:object{IgnisCollectorV2.OutputCumulator} (sleeper:string target-account:string dptf:string amount:decimal duration:integer))
    (defun C_Unsleep:object{IgnisCollectorV2.OutputCumulator} (unsleeper:string dpof:string nonce:integer))
    (defun C_Merge:object{IgnisCollectorV2.OutputCumulator} (merger:string dpof:string nonces:[integer]))
    (defun C_RepurposeMerge:object{IgnisCollectorV2.OutputCumulator} (dpof-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string))
    (defun C_RepurposeSleeping:object{IgnisCollectorV2.OutputCumulator} (dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string))
    (defun C_ToggleTransferRoleSleepingDPOF:object{IgnisCollectorV2.OutputCumulator} (s-dpof:string target:string toggle:bool))
    ;;
    (defun C_Hibernate:object{IgnisCollectorV2.OutputCumulator} (hibernator:string target-account:string dptf:string amount:decimal dayz:integer))
    (defun C_Awake:object{IgnisCollectorV2.OutputCumulator} (awaker:string dpof:string nonce:integer))
    (defun C_Slumber:object{IgnisCollectorV2.OutputCumulator} (merger:string dpof:string nonces:[integer]))
    (defun C_RepurposeSlumber:object{IgnisCollectorV2.OutputCumulator} (dpof-to-repurpose:string nonces:[integer] repurpose-from:string repurpose-to:string))
    (defun C_RepurposeHibernating:object{IgnisCollectorV2.OutputCumulator} (dpof-to-repurpose:string nonce:integer repurpose-from:string repurpose-to:string))
    (defun C_ToggleTransferRoleHibernatingDPOF:object{IgnisCollectorV2.OutputCumulator} (s-dpof:string target:string toggle:bool))
    ;;
)