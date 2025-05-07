;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
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
(interface OuronetDalos
    @doc "Interface Exposing DALOS Module Functions \
        \ UR(Utility-Read), URC(Utility-Read-Compute), UEV(Utility-Enforce-Validate) \
        \ are NOT sorted alphabetically"
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
    (defschema IgnisCumulator
        price:decimal
        trigger:bool
        output:list
    )
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
    (defun DALOS|EmptyIgCum:object{IgnisCumulator} ())
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
    (defun IGNIS|URC_Exception (account:string))
    (defun IGNIS|URC_ZeroGAZ:bool (id:string sender:string receiver:string))
    (defun IGNIS|URC_ZeroGAS:bool (id:string sender:string))
    (defun IGNIS|URC_IsVirtualGasZeroAbsolutely:bool (id:string))
    (defun IGNIS|URC_IsVirtualGasZero:bool ())
    (defun IGNIS|URC_IsNativeGasZero:bool ())
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
    (defun IGNIS|UEV_VirtualState (state:bool))
    (defun IGNIS|UEV_VirtualOnCondition ())
    (defun IGNIS|UEV_NativeState (state:bool))
    (defun IGNIS|UEV_Patron (patron:string))
    ;;
    (defun UDC_AddICO:decimal (input:[object{IgnisCumulator}]))
    (defun UDC_CompressICO:object{IgnisCumulator} (chain-ico:[object{IgnisCumulator}] lst-to-be-saved:list))
    (defun UDC_TrueFungibleTransferCumulator:object{IgnisCumulator} (id:string sender:string receiver:string))
    (defun UDC_BigCumulator:object{IgnisCumulator} ())
    (defun UDC_BiggestCumulator:object{IgnisCumulator} ())
    (defun UDC_BrandingCumulator:object{IgnisCumulator} (multiplier:decimal))
    (defun UDC_MediumCumulator:object{IgnisCumulator} ())
    (defun UDC_SmallCumulator:object{IgnisCumulator} ())
    (defun UDC_Cumulator:object{IgnisCumulator} (price:decimal trigger:bool lst:list))
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
    (defun C_ControlSmartAccount:object{IgnisCumulator} (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool))
    (defun C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun C_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun C_RotateGovernor:object{IgnisCumulator} (patron:string account:string governor:guard))
    (defun C_RotateGuard:object{IgnisCumulator} (patron:string account:string new-guard:guard safe:bool))
    (defun C_RotateKadena:object{IgnisCumulator} (patron:string account:string kadena:string))
    (defun C_RotateSovereign:object{IgnisCumulator} (patron:string account:string new-sovereign:string))
    ;;
    (defun C_TransferDalosFuel (sender:string receiver:string amount:decimal))
    (defun IGNIS|C_Collect (patron:string active-account:string amount:decimal))
    (defun IGNIS|C_CollectWT (patron:string active-account:string amount:decimal trigger:bool))
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
(interface OuronetDalosV2
    @doc "Interface Exposing DALOS Module Functions \
        \ UR(Utility-Read), URC(Utility-Read-Compute), UEV(Utility-Enforce-Validate) \
        \ are NOT sorted alphabetically \
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts"
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
    (defschema PrimedCumulatorV2
        primed-cumulator:object{CompressedCumulatorV2}
    )
    (defschema CompressedCumulatorV2
        ignis-prices:[decimal]
        interactors:[string]
    )
    (defschema OutputCumulatorV2
        cumulator-chain:[object{ModularCumulatorV2}]
        output:list
    )
    (defschema ModularCumulatorV2
        ignis:decimal
        interactor:string
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
    (defun IGNIS|URC_Exception (account:string))
    (defun IGNIS|URC_ZeroGAZ:bool (id:string sender:string receiver:string))
    (defun IGNIS|URC_ZeroGAS:bool (id:string sender:string))
    (defun IGNIS|URC_IsVirtualGasZeroAbsolutely:bool (id:string))
    (defun IGNIS|URC_IsVirtualGasZero:bool ())
    (defun IGNIS|URC_IsNativeGasZero:bool ())
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
    (defun IGNIS|UEV_VirtualState (state:bool))
    (defun IGNIS|UEV_VirtualOnCondition ())
    (defun IGNIS|UEV_NativeState (state:bool))
    (defun IGNIS|UEV_Patron (patron:string))
    ;;
    (defun UDC_TFTCumulatorV2:object{OutputCumulatorV2} (id:string sender:string receiver:string dptf-transfer-amount:decimal))
    (defun UDC_BrandingCumulatorV2:object{OutputCumulatorV2} (active-account:string multiplier:decimal))
    (defun UDC_SmallCumulatorV2:object{OutputCumulatorV2} (active-account:string))
    (defun UDC_MediumCumulatorV2:object{OutputCumulatorV2} (active-account:string))
    (defun UDC_BigCumulatorV2:object{OutputCumulatorV2} (active-account:string))
    (defun UDC_BiggestCumulatorV2:object{OutputCumulatorV2} (active-account:string))
    ;;
    (defun UDC_ConstructOutputCumulatorV2:object{OutputCumulatorV2} (price:decimal active-account:string trigger:bool output-lst:list))
    (defun UDC_MakeModularCumulatorV2:object{ModularCumulatorV2} (price:decimal active-account:string trigger:bool))
    (defun UDC_MakeOutputCumulatorV2:object{OutputCumulatorV2} (input-modular-cumulator-chain:[object{ModularCumulatorV2}] output-lst:list))
    (defun UDC_ConcatenateOutputCumulatorsV2:object{OutputCumulatorV2} (input-output-cumulator-chain:[object{OutputCumulatorV2}] new-output-lst:list))
    (defun UDC_CompressOutputCumulator:object{CompressedCumulatorV2} (input-output-cumulator:object{OutputCumulatorV2}))
    (defun UDC_PrimeIgnisCumulatorV2:object{PrimedCumulatorV2} (patron:string input:object{CompressedCumulatorV2}))
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
    (defun C_ControlSmartAccount:object{OutputCumulatorV2} (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool))
    (defun C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun C_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun C_RotateGovernor:object{OutputCumulatorV2} (patron:string account:string governor:guard))
    (defun C_RotateGuard:object{OutputCumulatorV2} (patron:string account:string new-guard:guard safe:bool))
    (defun C_RotateKadena:object{OutputCumulatorV2} (patron:string account:string kadena:string))
    (defun C_RotateSovereign:object{OutputCumulatorV2} (patron:string account:string new-sovereign:string))
    ;;
    (defun C_TransferDalosFuel (sender:string receiver:string amount:decimal))
    (defun IGNIS|C_Collect (patron:string input-output-cumulator:object{OutputCumulatorV2}))
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
(interface OuronetDalosV3
    @doc "Interface Exposing DALOS Module Functions \
        \ UR(Utility-Read), URC(Utility-Read-Compute), UEV(Utility-Enforce-Validate) \
        \ are NOT sorted alphabetically \
        \ \
        \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts \
        \ V3 Removes <patron> input variable where it is not needed"
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
    (defschema PrimedCumulatorV2
        primed-cumulator:object{CompressedCumulatorV2}
    )
    (defschema CompressedCumulatorV2
        ignis-prices:[decimal]
        interactors:[string]
    )
    (defschema OutputCumulatorV2
        cumulator-chain:[object{ModularCumulatorV2}]
        output:list
    )
    (defschema ModularCumulatorV2
        ignis:decimal
        interactor:string
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
    (defun IGNIS|URC_Exception (account:string))
    (defun IGNIS|URC_ZeroGAZ:bool (id:string sender:string receiver:string))
    (defun IGNIS|URC_ZeroGAS:bool (id:string sender:string))
    (defun IGNIS|URC_IsVirtualGasZeroAbsolutely:bool (id:string))
    (defun IGNIS|URC_IsVirtualGasZero:bool ())
    (defun IGNIS|URC_IsNativeGasZero:bool ())
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
    (defun IGNIS|UEV_VirtualState (state:bool))
    (defun IGNIS|UEV_VirtualOnCondition ())
    (defun IGNIS|UEV_NativeState (state:bool))
    (defun IGNIS|UEV_Patron (patron:string))
    ;;
    (defun UDC_TFTCumulatorV2:object{OutputCumulatorV2} (id:string sender:string receiver:string dptf-transfer-amount:decimal))
    (defun UDC_BrandingCumulatorV2:object{OutputCumulatorV2} (active-account:string multiplier:decimal))
    (defun UDC_SmallCumulatorV2:object{OutputCumulatorV2} (active-account:string))
    (defun UDC_MediumCumulatorV2:object{OutputCumulatorV2} (active-account:string))
    (defun UDC_BigCumulatorV2:object{OutputCumulatorV2} (active-account:string))
    (defun UDC_BiggestCumulatorV2:object{OutputCumulatorV2} (active-account:string))
    ;;
    (defun UDC_ConstructOutputCumulatorV2:object{OutputCumulatorV2} (price:decimal active-account:string trigger:bool output-lst:list))
    (defun UDC_MakeModularCumulatorV2:object{ModularCumulatorV2} (price:decimal active-account:string trigger:bool))
    (defun UDC_MakeOutputCumulatorV2:object{OutputCumulatorV2} (input-modular-cumulator-chain:[object{ModularCumulatorV2}] output-lst:list))
    (defun UDC_ConcatenateOutputCumulatorsV2:object{OutputCumulatorV2} (input-output-cumulator-chain:[object{OutputCumulatorV2}] new-output-lst:list))
    (defun UDC_CompressOutputCumulator:object{CompressedCumulatorV2} (input-output-cumulator:object{OutputCumulatorV2}))
    (defun UDC_PrimeIgnisCumulatorV2:object{PrimedCumulatorV2} (patron:string input:object{CompressedCumulatorV2}))
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
    (defun C_ControlSmartAccount:object{OutputCumulatorV2} (account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool))
    (defun C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun C_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun C_RotateGovernor:object{OutputCumulatorV2} (account:string governor:guard))
    (defun C_RotateGuard:object{OutputCumulatorV2} (account:string new-guard:guard safe:bool))
    (defun C_RotateKadena:object{OutputCumulatorV2} (account:string kadena:string))
    (defun C_RotateSovereign:object{OutputCumulatorV2} (account:string new-sovereign:string))
    ;;
    (defun C_TransferDalosFuel (sender:string receiver:string amount:decimal))
    (defun IGNIS|C_Collect (patron:string input-output-cumulator:object{OutputCumulatorV2}))
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
(module DALOS GOV
    ;;
    ;;Ouronet DALOS Gas-Station
    (defcap GAS_PAYER:bool (user:string limit:integer price:decimal)
        (let
            (
                (ref-U|ST:module{OuronetGasStation} U|ST)
                (gas-price (ref-U|ST::UR_chain-gas-price))
            )
            (compose-capability (DALOS|NATIVE-AUTOMATIC))
            (enforce-one
                "Add multiple conditions needed to use Ouronet DALOS Gas-Station"
                [
                    (enforce-guard GOV|MD_DALOS)
                    (enforce-guard (ref-U|ST::UEV_max-gas-notional 0.02))
                ]
            )
            (enforce (= 1 (length (at "exec-code" (read-msg)))) "Tx of only one Pact Function")
            (enforce-one
                "Payable Modules not satisfied"
                [
                    (enforce (= "(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS" (take 46 (at 0 (at "exec-code" (read-msg))))) "Only TALOS or DSP Modules allowed")
                    (enforce (= "(n_7d40ccda457e374d8eb07b658fd38c282c545038.DSP" (take 47 (at 0 (at "exec-code" (read-msg))))) "Only TALOS or DPS Modules allowed")
                ]
            )
        )
    )
    (defun create-gas-payer-guard:guard ()
        GOV|DALOS|GUARD
    )
    ;;
    (implements gas-payer-v1)
    (implements OuronetPolicy)
    (implements OuronetDalosV3)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DALOS                  (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_DALOS                  (keyset-ref-guard DALOS|SC_KEY))
    ;;
    (defconst DALOS|SC_KEY                  (GOV|DalosKey))
    (defconst DALOS|SC_NAME                 (GOV|DALOS|SC_NAME))
    (defconst DALOS|SC_KDA-NAME             (GOV|DALOS|SC_KDA-NAME))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DALOS_ADMIN)))
    (defcap GOV|DALOS_ADMIN ()
        @event
        (enforce-one
            "DALOS Admin not satisfed"
            [
                (enforce-guard GOV|MD_DALOS)
                (enforce-guard GOV|SC_DALOS)
            ]
        )
    )
    (defcap GOV|GAP (gap:bool)
        @event
        (let
            (
                (current-gap:bool (UR_GAP))
            )
            (enforce (!= gap current-gap) (format "GAP is already toggled to {}" [gap]))
            (compose-capability (GOV|DALOS_ADMIN))
        )
    )
    (defcap DALOS|NATIVE-AUTOMATIC  ()
        @doc "Autonomic management of <kadena-konto> of the DALOS Smart Ouronet Account"
        true
    )
    ;;{G3}
    (defun DALOS|SetGovernor (patron:string)
        (with-capability (SECURE)
            (let
                (
                    (ref-U|G:module{OuronetGuards} U|G)
                    (ico:object{OuronetDalosV3.OutputCumulatorV2}
                        (C_RotateGovernor
                            DALOS|SC_NAME
                            (ref-U|G::UEV_GuardOfAny
                                [
                                    (P|UR "TFT|RemoteDalosGov")
                                    (P|UR "SWPU|RemoteDalosGov")
                                    (P|UR "TS01-A|RemoteDalosGov")
                                ]
                            )
                        )
                    )
                )
                (IGNIS|C_Collect patron ico)
            )
        )
    )
    (defun GOV|DALOS|SC_KDA-NAME ()         (create-principal (GOV|DALOS|GUARD)))
    (defun GOV|DALOS|GUARD ()               (create-capability-guard (DALOS|NATIVE-AUTOMATIC)))
    ;;
    ;; [Keys]
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|Demiurgoi ()                 (+ (GOV|NS_Use) ".dh_master-keyset"))
    (defun GOV|DalosKey ()                  (+ (GOV|NS_Use) ".dh_sc_dalos-keyset"))
    (defun GOV|AutostakeKey ()              (+ (GOV|NS_Use) ".dh_sc_autostake-keyset"))
    (defun GOV|VestingKey ()                (+ (GOV|NS_Use) ".dh_sc_vesting-keyset"))
    (defun GOV|LiquidKey ()                 (+ (GOV|NS_Use) ".dh_sc_kadenaliquidstaking-keyset"))
    (defun GOV|OuroborosKey ()              (+ (GOV|NS_Use) ".dh_sc_ouroboros-keyset"))
    (defun GOV|SwapKey ()                   (+ (GOV|NS_Use) ".dh_sc_swapper-keyset"))
    (defun GOV|DHVKey ()                    (+ (GOV|NS_Use) ".dh_sc_dhvault-keyset"))
    ;;
    ;; [SC-Names]
    (defun GOV|DALOS|SC_NAME ()             (at 0 ["Σ.W∇ЦwÏξБØnζΦψÕłěîбηжÛśTã∇țâĆã4ЬĚIŽȘØíÕlÛřбΩцμCšιÄиMkλ€УщшàфGřÞыÎäY8È₳BDÏÚmßOozBτòÊŸŹjПкцğ¥щóиś4h4ÑþююqςA9ÆúÛȚβжéÑψéУoЭπÄЩψďşõшżíZtZuψ4ѺËxЖψУÌбЧλüșěđΔjÈt0ΛŽZSÿΞЩŠ"]))
    (defun GOV|ATS|SC_NAME ()               (at 0 ["Σ.ëŤΦșźUÉM89ŹïuÆÒÕ£żíëцΘЯнŹÿxжöwΨ¥Пууhďíπ₱nιrŹÅöыыidõd7ì₿ипΛДĎĎйĄшΛŁPMȘïõμîμŻIцЖljÃαbäЗŸÖéÂЫèpAДuÿPσ8ÎoŃЮнsŤΞìтČ₿Ñ8üĞÕPșчÌșÄG∇MZĂÒЖь₿ØDCПãńΛЬõŞŤЙšÒŸПĘЛΠws9€ΦуêÈŽŻ"]))
    (defun GOV|VST|SC_NAME ()               (at 0 ["Σ.şZïζhЛßdяźπПЧDΞZülΦпφßΣитœŸ4ó¥ĘкÌЦ₱₱AÚюłćβρèЬÍŠęgĎwтäъνFf9źdûъtJCλúp₿ÌнË₿₱éåÔŽvCOŠŃpÚKюρЙΣΩìsΞτWpÙŠŹЩпÅθÝØpтŮыØșþшу6GтÃêŮĞбžŠΠŞWĆLτЙđнòZЫÏJÿыжU6ŽкЫVσ€ьqθtÙѺSô€χ"]))
    (defun GOV|LIQUID|SC_NAME ()            (at 0 ["Σ.śκν9₿ŻşYЙΣJΘÊO9jпF₿wŻ¥уPэõΣÑïoγΠθßÙzěŃ∇éÖиțșφΦτşэßιBιśiĘîéòюÚY$êFЬŤØ$868дyβT0ςъëÁwRγПŠτËMĚRПMaäЗэiЪiςΨoÞDŮěŠβLé4čØHπĂŃŻЫΣÀmăĐЗżłÄăiĞ₿йÎEσțłGΛЖΔŞx¥ÁiÙNğÅÌlγ¢ĎwдŃ"]))
    (defun GOV|OUROBOROS|SC_NAME ()         (at 0 ["Σ.4M0èÞbøXśαiΠ€NùÇèφqλËãØÓNCнÌπпЬ4γTмыżěуàđЫъмéLUœa₿ĞЬŒѺrËQęíùÅЬ¥τ9£φď6pÙ8ìжôYиșîŻøbğůÞχEшäΞúзêŻöŃЮüŞöućЗßřьяÉżăŹCŸNÅìŸпĐżwüăŞãiÜą1ÃγänğhWg9ĚωG₳R0EùçGΨфχЗLπшhsMτξ"]))
    (defun GOV|SWP|SC_NAME ()               (at 0 ["Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ"]))
    (defun GOV|DHV1|SC_NAME ()              (at 0 ["Ѻ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"]))
    (defun GOV|DHV2|SC_NAME ()              (+ "Σ" (drop 1 (GOV|DHV1|SC_NAME))))
    ;;
    ;; [PBLs]
    (defun GOV|DALOS|PBL ()                 (at 0 ["9G.DwF3imJMCp4ht88DD1vx6pdjEkLM4j7Fvzso8zJF7Ixe1p2oKfGb53a5svtEF0Lz1q4MjvHaMrgqCfjlA1cBj2bzvs86EeLIMg2fmutzwbA5vI4woKoqq0acDHllAonxC4qLBulsLclMGwcw9iGxiw919t4tfD8FpcIc4MJ059ki7giFIAyCghgMwwr199v3qiDfIon426rbz1jMLmCe4jhHwD3sEarwMlmzLJ5li43J70CEDzouh7x8pu4u1GxJHa6Cabrsc147gIlzIdDmCC2j87LFpEdvqLge9o0w4av8mLr0lDAfalpnEabfkl0E6zE9KMG7LH2w7uvBIup3Hxxxu2Giwu29Cqye3fJ5ihcjacop4vtcLsi33ip742uAhGzjHaDLwAh933ntp8tEC1zkt9yi6n89JtsDLk477p80rscbGtsi14nxsMf7y0d7GxzE8FFmljElu5yE3vx25cEvc9574Hw4iIi23FFKfdhGF77LMqaBkDB9hJKmpc1B2rM1a8mfilyvLAdzpj57Ae5FG5vvm1n1nzgau373dBF7CuBAu2zbts09du55"]))
    (defun GOV|ATS|PBL ()                   (at 0 ["9H.9I8veD6Lqmcd5nKlb1vlHkg976FhdtooE3iH73h8i2Gq9tLKdclnpo07sC29i2yvMeuB0ikkKghiIgdAfkfDiM57o2phj2quCD8gutjIgDs6AlecMtw2lG6kMMBxBH4B5d1xqhpzA7AHkgEqF7Hgqwpx6E5aIMAtqxIpMhjyqziDiwLA69dKlhlwpjoze34Bwz6swBjlA880ItKfwxtulKEJG9oI3Gjmwgn6bbAgL7xy4brdbgK5DukMBHc0K1jIs1DjcDzhJz2liKultB67rKaBf3nMHMkbzhwl1hdu2wBCeHMLLphug2kE3tDtpxw6kLcj80qfBxvwmuxbeHjk349Md2B7eB4brt8fldi2CxGltfj41KA7GkgmtMa6szivDl5aCk9ozab9ohrsfBHikGL7GJ5Az4A2a8ufnIAJIz2mAgwGDmsAl7yyavbx12e5KhFFupclbKadmiFx8dvqkqwziu4vtt3AcKDhl96EzhuiKAF49vGoaAMo5vxM4h0t94nscG8IGl33De5MJGCpdf3g23D13eJ9BDi034wECutafzao4zzCe9IyvD3E"]))
    (defun GOV|VST|PBL ()                   (at 0 ["9G.5s5hoiGo96tMqyh3JBklmsvo8Lc3ol9m6zavJcCuqg4mBvkbDfcv5gEorMit8v8Mj9Jc18EI36Gq7cJ1IyA4e4wvl199KuCx3chsDKGDdfsvzk8mo317ulGk00pbxu7MLc2zw7joouaxt3Ax1KnlJz153ko0JtIxz7pqylfis45pDo2vvm1MH2kA2wmE2crxiEo6oEckuGqzz8oEaa9ez8ADLyqnj48lq4jGp4slkKo6a06ElezH619fsihIdmiMdfB036CJAr0rlzA2b5DgvEJcoyIFioru7vynBjLMLv3pvLFnbFeswrlyLjF8ry7kB52cD7bD7xaamCEjgIC2DsKMv5Mrd69BIKn2yKHC86f0hme9zs5dwMekAd6mc4wM4bDAk6Jrsl6s74ykKLF71pk45rIE1xxzFC4EjykBf6G0neBdaExI32HufaE5mEloDtvnC6vJ7HA9akkI3616MnLErA8eMIn7Kr2wI4l9CvGpKcF9HilzJmdqMa4kzJwqzuFc9LhDnrKcu0LvBHqsx2CrCM9EwHqpkkGe7w8eK8x0xK6K8drLaoBKmaB1"]))
    (defun GOV|LIQUID|PBL ()                (at 0 ["9H.b49lfzLzvC25g87fst6MqCkfbuqq39iGu50gDqi9jBEk6Cn86w54b91zDxeGgLdCxIjJDfyi6gBBwA93lyGLcdfggf0LzwKu405piavx0nEnqpzyHK125h2BhECnobmDBAps61c7mGmw5GrczBjvBMLxHwl2avt5jwhKeGxh7Ibm1ui6wI6lpAKBMay4tvEwHK0EibhbeaA2lLqjIwqMKnldp22txeje3DFLautFC798ExbLxG7q3om8l1f9qpMJkw9f5nmHsHGJcrcIF2mou9lmpr3hbz64La6nF9w26h7osABLMLlK9Glp48yrj4h1MkI7xjftytKDnJFyqvoMFqKvA43cJ81bJCvmn63eJ9jx5n3GxFbc9H4v400iFwtyIilmhKymsa1iCnwL29g21DvkaE6JJyxl5eLCiGH3Ml1nb0jkg16zJbf9cfg41KHA0IGFIvLj9LBhj7okL6wspCEBfkc5Aui6DAM7dvAqH54LApEaAzIgyMloEmqvBgt5wF0lyd05xHxz4Mtb3ItGb5fLpzbMGqGKBffi4dElI7Hbs6Id0hCKGaeIg9JL"]))
    (defun GOV|OUROBOROS|PBL ()             (at 0 ["9H.28jB2BBny4op601Cfqz9brFJKAEo67jbEDJi91i00pGjcD1Mpn0y0A1CxcAwGgBu35Ix3bG4e4p56Mu6x7Mmd50nKfmpDGtLy1ywyCjoDD5xiHBb0y5dAjB0fuokrqyx3ula9rtxyEHK1A4gkG4g3GEyysMtgF40IBgKjm7t8ffGshICIypFeF3gA5x0MixA0soiCx9tBnMDzI6G5xC8yIJJ3Bt2sCvJHAp7HAEA3rKK6Bgnx8hK94oDbgrpCkxw3zpo7tbeHhcakzbg0ELG3EJvk19hyd9LC73t2gizl0B6puq3Ljji5EDAhzno7K32x8vCagc5D2GLiMfdzEzsj5KEe1c2p7hxj76lMvp40r9F56vzlK8Kb7mrKt90ILEMqCghLrok7D4uH8h28EGqbK75wiyguimc1jDGxthyBJFfApClymKA57ehqbv2Lyv323w44b0kIItu35fjmhe2DCBMwjn67ffDII97b6AdyG010wvAHf55xFt25Mbm2pflsggL4D5jHtokl7qn6g4ltM5ilvHvsxn7jHe23Cfgoxn1JssdFMBpcDvB2xki7"]))
    (defun GOV|SWP|PBL ()                   (at 0 ["9G.4Bl3bJ5o1eIoBkhynF39lFdvkA3E0n8m5fBr9iG4D6Ahj3xfop72b98rr33vFFLjqaiozE1btl7lgzKcjHwjzu5GuFqvMb43v9CHHe8je3buLbHMkcAyKdEMD85yIHsb9ty58Kzyado3ho1n1mf9GzpeegMrpK9wDFteeKexdL7HHq8GF7ptD2w45IkMf2A8j4pm7E6vJ1ytCckhclD9nd3JzL2j5cyLxawnE76leKmEmFaxqnF76yyJe5Mu6yLkg2yonJa6vx6jd1kr0hdEf81o42Asr8EcCDeeqD4nAehC3w3pFDMwbln4Mbl6t55GHGephx99LJKH1ojhlMlnyC4bbJFAiyD1h6vs0o7mKAaazFG9y0vfbvM9imcs1vCMmpk2cGDAAAqH6iJe32ugHA3AECEgCvxCskw4Mfx6Cc4rx2BkmKMlxeHqyDceI6wa2qjzuyI80vKg6H6tMwEg48H0ywIMDyxteDfHav08eEJE2lljEIAc1jxLlLcosbiknAyxJvu8g7kA4oAlcio2jI8lMxp76vosd5FxpatowuFktILfyCFyHvKfcozy"]))
    (defun GOV|DHV|PBL ()                   (at 0 ["9G.7G3mkhkk34Bg37uslsu3M7psBc40xsKFibE9DL0jb43JcJ7fzDh9cz3Edn8uvlkh0bCeFafFntCKt0HvJsmczx3Lek9d3mqr38BbIwmBrDkd8sordjr4L7tJ5Fnqj39F6s55hD3rEFvMGors4sws3lDcKiEHkMEE7kHuuB31gGe3F5HsI0yHbwsm2IcspsB1ICiD1g73vup127pjLauIc6gxl3sJy0lAml1uA9g18Btcl6prinGmo3uFomeoyvx9oLGlf6ctFsfavKa5vFrvaw2FB1KsAiejqqjaeMu1I1cEey3m55allFm5pg9LaFK307qnmjxfmqv38vvr2wBerI4BnvFKLgpB7e7pCCmarDJq1l6nHEIv6wl3d96iwAqEHxKEwpH7ljzqnsnBpcEFlpKu6xjc5o78DiwzrltiDxa5c9ug7wML3MGqDEH9tzIj2IreF5yEnw4M15yy38z7gqKbd7l3Fb3qc7kvrgHKG8cpq9M54kg6v5a1k7Laqea07ynccK6r2bjwl7L8IkE7EsAep77M1kb4455klFFH2qx2uEuGBlfsu1rztiMa"]))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (at 0 ["InterModulePolicies"]))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|DALOS_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DALOS_ADMIN)
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
        true
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
    (defschema DALOS|KadenaSchema
        dalos:[string]
    )
    (defschema DALOS|PropertiesSchema
        global-administrative-pause:bool    ;;Stores the GAP Boolesn
        demiurgoi:[string]                  ;;Stores Demiurgoi DALOS Accounts
        unity-id:string                     ;;Unity
        gas-source-id:string                ;;OUROBOROS
        gas-source-id-price:decimal         ;;OUROBOROS Price
        gas-id:string                       ;;IGNIS
        ats-gas-source-id:string            ;;AURYN
        elite-ats-gas-source-id:string      ;;ELITE-AURYN
        wrapped-kda-id:string               ;;DWK - Dalos Wrapped Kadena
        liquid-kda-id:string                ;;DLK - Dalos Liquid Kadena

        treasury-dispo-type:integer
        treasury-dynamic-promille:decimal
        treasury-static-tds:decimal

        ouro-auto-price-via-swaps:bool      ;;Determines if Ouro Price Auto Update Via Swaps is on
    )
    (defschema DALOS|GasManagementSchema
        virtual-gas-tank:string             ;;IGNIS|SC_NAME = "GasTanker"
        virtual-gas-toggle:bool             ;;IGNIS collection toggle
        virtual-gas-spent:decimal           ;;IGNIS spent
        native-gas-toggle:bool              ;;KADENA collection toggle
        native-gas-spent:decimal            ;;KADENA spent
        native-gas-pump:bool                ;;controls automatic LiquidStaking fueling
    )
    (defschema DALOS|PricesSchema
        price:decimal                       ;;Stores price for action
    )
    (defschema DALOS|AccountSchema
        @doc "Schema that stores DALOS Account Information"
        public:string
        guard:guard
        kadena-konto:string
        sovereign:string
        governor:guard

        smart-contract:bool
        payable-as-smart-contract:bool
        payable-by-smart-contract:bool
        payable-by-method:bool

        nonce:integer
        elite:object{DALOS|EliteSchema}
        ouroboros:object{OuronetDalosV3.DPTF|BalanceSchema}
        ignis:object{OuronetDalosV3.DPTF|BalanceSchema}
    )
    (defschema DALOS|EliteSchema
        class:string
        name:string
        tier:string
        deb:decimal
    )
    ;;{2}
    (deftable DALOS|KadenaLedger:{DALOS|KadenaSchema})
    (deftable DALOS|PropertiesTable:{DALOS|PropertiesSchema})
    (deftable DALOS|GasManagementTable:{DALOS|GasManagementSchema})
    (deftable DALOS|PricesTable:{DALOS|PricesSchema})
    (deftable DALOS|AccountTable:{DALOS|AccountSchema})
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defun DALOS|Info ()            (at 0 ["DalosInformation"]))
    (defun DALOS|VirtualGasData ()  (at 0 ["VirtualGasData"]))
    (defun DALOS|EmptyOutputCumulatorV2:object{OuronetDalosV3.OutputCumulatorV2} ()
        {"cumulator-chain"      :
            [
                {"ignis"        : 0.0
                ,"interactor"   : BAR}
            ]
        ,"output"               : []}
    )
    (defconst BAR                   (CT_Bar))
    (defconst DALOS|INFO            (DALOS|Info))
    (defconst DALOS|VGD             (DALOS|VirtualGasData))
    (defconst DALOS|CHR_AUX
        [ " " "!" "#" "%" "&" "'" "(" ")" "*" "+" "," "-" "." "/" ":" ";" "<" "=" ">" "?" "@" "[" "]" "^" "_" "`" "{" "|" "}" "~" "‰" ]
    )
    (defconst DALOS|CHR_DIGITS
        ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9"]
    )
    (defconst DALOS|CHR_CURRENCIES
        [ "Ѻ" "₿" "$" "¢" "€" "£" "¥" "₱" "₳" "∇" ]
    )
    (defconst DALOS|CHR_LATIN-B
        [ "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" ]
    )
    (defconst DALOS|CHR_LATIN-S
        [ "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" ]
    )
    (defconst DALOS|CHR_LATIN-EXT-B
        [ "Æ" "Œ" "Á" "Ă" "Â" "Ä" "À" "Ą" "Å" "Ã" "Ć" "Č" "Ç" "Ď" "Đ" "É" "Ě" "Ê" "Ë" "È" "Ę" "Ğ" "Í" "Î" "Ï" "Ì" "Ł" "Ń" "Ñ" "Ó" "Ô" "Ö" "Ò" "Ø" "Õ" "Ř" "Ś" "Š" "Ş" "Ș" "Þ" "Ť" "Ț" "Ú" "Û" "Ü" "Ù" "Ů" "Ý" "Ÿ" "Ź" "Ž" "Ż" ]
    )
    (defconst DALOS|CHR_LATIN-EXT-S
        [ "æ" "œ" "á" "ă" "â" "ä" "à" "ą" "å" "ã" "ć" "č" "ç" "ď" "đ" "é" "ě" "ê" "ë" "è" "ę" "ğ" "í" "î" "ï" "ì" "ł" "ń" "ñ" "ó" "ô" "ö" "ò" "ø" "õ" "ř" "ś" "š" "ş" "ș" "þ" "ť" "ț" "ú" "û" "ü" "ù" "ů" "ý" "ÿ" "ź" "ž" "ż" "ß" ]
    )
    (defconst DALOS|CHR_GREEK-B
        [ "Γ" "Δ" "Θ" "Λ" "Ξ" "Π" "Σ" "Φ" "Ψ" "Ω" ]
    )
    (defconst DALOS|CHR_GREEK-S
        [ "α" "β" "γ" "δ" "ε" "ζ" "η" "θ" "ι" "κ" "λ" "μ" "ν" "ξ" "π" "ρ" "σ" "ς" "τ" "φ" "χ" "ψ" "ω" ]
    )
    (defconst DALOS|CHR_CYRILLIC-B
        [ "Б" "Д" "Ж" "З" "И" "Й" "Л" "П" "У" "Ц" "Ч" "Ш" "Щ" "Ъ" "Ы" "Ь" "Э" "Ю" "Я" ]
    )
    (defconst DALOS|CHR_CYRILLIC-S
        [ "б" "в" "д" "ж" "з" "и" "й" "к" "л" "м" "н" "п" "т" "у" "ф" "ц" "ч" "ш" "щ" "ъ" "ы" "ь" "э" "ю" "я" ]
    )
    (defconst DALOS|CHARSET
        (fold (+) []
            [
                DALOS|CHR_DIGITS
                DALOS|CHR_CURRENCIES
                DALOS|CHR_LATIN-B
                DALOS|CHR_LATIN-S
                DALOS|CHR_LATIN-EXT-B
                DALOS|CHR_LATIN-EXT-S
                DALOS|CHR_GREEK-B
                DALOS|CHR_GREEK-S
                DALOS|CHR_CYRILLIC-B
                DALOS|CHR_CYRILLIC-S
            ]
        )
    )
    (defconst DALOS|EXTENDED        (+ DALOS|CHR_AUX DALOS|CHARSET))
    (defconst GAS_EXCEPTION
        [
            DALOS|SC_NAME
            (GOV|OUROBOROS|SC_NAME)
            (GOV|LIQUID|SC_NAME)
        ]
    )
    (defconst GAS_QUARTER 0.25)
    (defconst DPTF|BLANK
        { "exist"                   : true
        , "balance"                 : 0.0
        , "role-burn"               : false
        , "role-mint"               : false
        , "role-transfer"           : false
        , "role-fee-exemption"      : false
        , "frozen"                  : false }
    )
    (defconst DALOS|PLEB
        { "class" : "NOVICE"
        , "name"  : "Infidel"
        , "tier"  : "0.0"
        , "deb"   : 1.0 }
    )
    (defconst DALOS|VOID
        { "class" : "VOID"
        , "name"  : "Undead"
        , "tier"  : "0.0"
        , "deb"   : 0.0 }
    )
    (defconst EMPTY_CC
        [
            {
                "ignis-prices" : [],
                "interactors" : []
            }
        ]
    )
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap SECURE ()
        true
    )
    (defcap SECURE-ADMIN ()
        (compose-capability (SECURE))
        (compose-capability (GOV|DALOS_ADMIN))
    )
    ;;{C2}
    (defcap IGNIS|C>DC (patron:string)
        (compose-capability (IGNIS|S>DISCOUNT patron (UDC_MakeIDP (URC_IgnisGasDiscount patron))))
    )
    (defcap IGNIS|S>DISCOUNT (patron:string idp:string)
        @event
        true
    )
    (defcap IGNIS|S>FREE ()
        @event
        true
    )
    (defcap DALOS|S>D-ST (account:string guard:guard kadena:string)
        @event
        (let
            (
                (account-validation:bool (GLYPH|UEV_DalosAccount account))
                (first:string (take 1 account))
                (ouroboros:string "Ѻ")
            )
            (enforce account-validation (format "Account {} isn't a valid DALOS Account" [account]))
            (enforce (= first ouroboros) (format "Account {} doesn|t have the corrrect Format for a Standard DALOS Account" [account]))
            (enforce-guard guard)
            (compose-capability (SECURE))
            ;(UTILS.UTILS|UEV_EnforceReserved kadena guard)
        )
    )
    (defcap DALOS|S>D-SM (account:string guard:guard kadena:string sovereign:string)
        @event
        (let
            (
                (account-validation:bool (GLYPH|UEV_DalosAccount account))
                (first:string (take 1 account))
                (sigma:string "Σ")
            )
            (enforce account-validation (format "Account {} isn't a valid DALOS Account" [account]))
            (enforce (= first sigma) (format "Account {} doesn|t have the corrrect Format for a Smart DALOS Account" [account]))
            (UEV_EnforceAccountType sovereign false)
            (enforce-guard guard)
            (compose-capability (SECURE))
            ;(UTILS.UTILS|UEV_EnforceReserved kadena guard)
        )
    )
    ;;{C3}
    (defcap DALOS|F>OWNER (account:string)
        (CAP_EnforceAccountOwnership account)
    )
    (defcap DALOS|F>GOV (account:string)
        (CAP_EnforceAccountOwnership account)
        (UEV_EnforceAccountType account true)
    )
    ;;{C4}
    (defcap GOV|MIGRATE (migration-target-kda-account:string)
        @event
        (let
            (
                (ref-coin:module{fungible-v2} coin)
                (target-balance:decimal (ref-coin::get-balance migration-target-kda-account))
                (gap:bool (UR_GAP))
            )
            (enforce gap (format "Migration can only be executed when Global Administrative Pause is offline"))
            (enforce (= target-balance 0.0) "Migration can only be executed to an empty kda account")
            (compose-capability (GOV|DALOS_ADMIN))
            (compose-capability (DALOS|NATIVE-AUTOMATIC))
        )
    )
    (defcap DALOS|C>RT_ACC (account:string)
        @event
        (compose-capability (SECURE))
        (compose-capability (DALOS|F>OWNER account))
    )
    (defcap DALOS|C>RT_SOV (account:string new-sovereign:string)
        @event
        (CAP_EnforceAccountOwnership account)
        (UEV_EnforceAccountType account true)
        (UEV_EnforceAccountType new-sovereign false)
        (UEV_SenderWithReceiver (UR_AccountSovereign account) new-sovereign)
    )
    (defcap DALOS|C>RT_GOV (account:string)
        @event
        (compose-capability (DALOS|F>GOV account))
    )
    (defcap DALOS|C>CTRL_SM-ACC (account:string pasc:bool pbsc:bool pbm:bool)
        @event
        (compose-capability (DALOS|F>GOV account))
        (enforce (= (or (or pasc pbsc) pbm) true) "At least one Smart DALOS Account parameter must be true")
    )
    (defcap IGNIS|C>COLLECT (patron:string interactor:string amount:decimal)
        @event
        (IGNIS|UEV_Patron patron)
        (let
            (
                (first:string (take 1 interactor))
                (sigma:string "Σ")
                (tanker:string (UR_Tanker))
            )
            (enforce-one
                "Invalid Interactor"
                [
                    (enforce (= interactor BAR) "Interactor is invalid")
                    (enforce (= first sigma) "Invalid Smart Account as interactor")
                ]
            )
            (if (= interactor BAR)
                (compose-capability (IGNIS|C>TRANSFER patron tanker amount))
                (compose-capability (IGNIS|C>TRANSFER patron interactor amount))
            )
            (compose-capability (SECURE))
        )
    )
    (defcap IGNIS|C>TRANSFER (sender:string receiver:string ta:decimal)
        (enforce (!= sender receiver) "Sender and Receiver must be different")
        (UEV_TwentyFourPrecision ta)
        (enforce (> ta 0.0) "Cannot debit|credit 0.0 or negative GAS amounts")
        (compose-capability (IGNIS|C>DEBIT sender ta))
        (compose-capability (IGNIS|C>CREDIT receiver))
    )
    (defcap IGNIS|C>DEBIT (sender:string ta:decimal)
        (let
            (
                (read-gas:decimal (UR_TF_AccountSupply sender false))
            )
            (enforce (<= ta read-gas) "Insufficient GAS for GAS-Debiting")
            (UEV_EnforceAccountExists sender)
            (UEV_EnforceAccountType sender false)
            (compose-capability (SECURE))
        )
    )
    (defcap IGNIS|C>CREDIT (receiver:string)
        (UEV_EnforceAccountExists receiver)
        (compose-capability (SECURE))
    )
    (defcap IGNIS|C>TOGGLE (native:bool toggle:bool)
        (compose-capability (GOV|DALOS_ADMIN))
        (if native
            (IGNIS|UEV_NativeState (not toggle))
            (IGNIS|UEV_VirtualState (not toggle))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_KadenaLedger:[string] (kadena:string)
        (with-default-read DALOS|KadenaLedger kadena
            { "dalos"    : [BAR] }
            { "dalos"    := d }
            d
        )
    )
    (defun UR_GAP:bool ()
        (at "global-administrative-pause" (read DALOS|PropertiesTable DALOS|INFO ["global-administrative-pause"]))
    )
    (defun UR_DemiurgoiID:[string] ()
        (at "demiurgoi" (read DALOS|PropertiesTable DALOS|INFO ["demiurgoi"]))
    )
    (defun UR_UnityID:string ()
        (at "unity-id" (read DALOS|PropertiesTable DALOS|INFO ["unity-id"]))
    )
    (defun UR_OuroborosID:string ()
        (at "gas-source-id" (read DALOS|PropertiesTable DALOS|INFO ["gas-source-id"]))
    )
    (defun UR_OuroborosPrice:decimal ()
        (at "gas-source-id-price" (read DALOS|PropertiesTable DALOS|INFO ["gas-source-id-price"]))
    )
    (defun UR_IgnisID:string ()
        (with-default-read DALOS|PropertiesTable DALOS|INFO
            { "gas-id" :  BAR }
            { "gas-id" := gas-id}
            gas-id
        )
    )
    (defun UR_AurynID:string ()
        (at "ats-gas-source-id" (read DALOS|PropertiesTable DALOS|INFO ["ats-gas-source-id"]))
    )
    (defun UR_EliteAurynID:string ()
        (at "elite-ats-gas-source-id" (read DALOS|PropertiesTable DALOS|INFO ["elite-ats-gas-source-id"]))
    )
    (defun UR_WrappedKadenaID:string ()
        (at "wrapped-kda-id" (read DALOS|PropertiesTable DALOS|INFO ["wrapped-kda-id"]))
    )
    (defun UR_LiquidKadenaID:string ()
        (at "liquid-kda-id" (read DALOS|PropertiesTable DALOS|INFO ["liquid-kda-id"]))
    )
    (defun UR_DispoType:integer ()
        (at "treasury-dispo-type" (read DALOS|PropertiesTable DALOS|INFO ["treasury-dispo-type"]))
    )
    (defun UR_DispoTDP:decimal ()
        (at "treasury-dynamic-promille" (read DALOS|PropertiesTable DALOS|INFO ["treasury-dynamic-promille"]))
    )
    (defun UR_DispoTDS:decimal ()
        (at "treasury-static-tds" (read DALOS|PropertiesTable DALOS|INFO ["treasury-static-tds"]))
    )
    (defun UR_OuroAutoPriceUpdate:bool ()
        (at "ouro-auto-price-via-swaps" (read DALOS|PropertiesTable DALOS|INFO ["ouro-auto-price-via-swaps"]))
    )
    (defun UR_Tanker:string ()
        (at "virtual-gas-tank" (read DALOS|GasManagementTable DALOS|VGD ["virtual-gas-tank"]))
    )
    (defun UR_VirtualToggle:bool ()
        (with-default-read DALOS|GasManagementTable DALOS|VGD
            {"virtual-gas-toggle" : false}
            {"virtual-gas-toggle" := tg}
            tg
        )
    )
    (defun UR_VirtualSpent:decimal ()
        (at "virtual-gas-spent" (read DALOS|GasManagementTable DALOS|VGD ["virtual-gas-spent"]))
    )
    (defun UR_NativeToggle:bool ()
        (with-default-read DALOS|GasManagementTable DALOS|VGD
            {"native-gas-toggle" : false}
            {"native-gas-toggle" := tg}
            tg
        )
    )
    (defun UR_NativeSpent:decimal ()
        (at "native-gas-spent" (read DALOS|GasManagementTable DALOS|VGD ["native-gas-spent"]))
    )
    (defun UR_AutoFuel:bool ()
        (at "native-gas-pump" (read DALOS|GasManagementTable DALOS|VGD ["native-gas-pump"]))
    )
    (defun UR_UsagePrice:decimal (action:string)
        (at "price" (read DALOS|PricesTable action ["price"]))
    )
    (defun UR_AccountPublicKey:string (account:string)
        (at "public" (read DALOS|AccountTable account ["public"]))
    )
    (defun UR_AccountGuard:guard (account:string)
        (at "guard" (read DALOS|AccountTable account ["guard"]))
    )
    (defun UR_AccountKadena:string (account:string)
        (at "kadena-konto" (read DALOS|AccountTable account ["kadena-konto"]))
    )
    (defun UR_AccountSovereign:string (account:string)
        (at "sovereign" (read DALOS|AccountTable account ["sovereign"]))
    )
    (defun UR_AccountGovernor:guard (account:string)
        (at "governor" (read DALOS|AccountTable account ["governor"]))
    )
    (defun UR_AccountProperties:[bool] (account:string)
        (with-default-read DALOS|AccountTable account
            { "smart-contract" : false, "payable-as-smart-contract" : false, "payable-by-smart-contract" : false, "payable-by-method" : false}
            { "smart-contract" := sc, "payable-as-smart-contract" := pasc, "payable-by-smart-contract" := pbsc, "payable-by-method" := pbm }
            [sc pasc pbsc pbm]
        )
    )
    (defun UR_AccountType:bool (account:string)
        (at 0 (UR_AccountProperties account))
    )
    (defun UR_AccountPayableAs:bool (account:string)
        (at 1 (UR_AccountProperties account))
    )
    (defun UR_AccountPayableBy:bool (account:string)
        (at 2 (UR_AccountProperties account))
    )
    (defun UR_AccountPayableByMethod:bool (account:string)
        (at 3 (UR_AccountProperties account))
    )
    (defun UR_AccountNonce:integer (account:string)
        (with-default-read DALOS|AccountTable account
            { "nonce" : 0 }
            { "nonce" := n }
            n
        )
    )
    (defun UR_Elite (account:string)
        (with-default-read DALOS|AccountTable account
            { "elite" : DALOS|PLEB }
            { "elite" := e}
            e
        )
    )
    (defun UR_Elite-Class (account:string)
        (at "class" (UR_Elite account))
    )
    (defun UR_Elite-Name (account:string)
        (at "name" (UR_Elite account))
    )
    (defun UR_Elite-Tier (account:string)
        (at "tier" (UR_Elite account))
    )
    (defun UR_Elite-Tier-Major:integer (account:string)
        (str-to-int (take 1 (UR_Elite-Tier account)))
    )
    (defun UR_Elite-Tier-Minor:integer (account:string)
        (str-to-int (take -1 (UR_Elite-Tier account)))
    )
    (defun UR_Elite-DEB (account:string)
        (at "deb" (UR_Elite account))
    )
    (defun UR_TrueFungible:object{OuronetDalosV3.DPTF|BalanceSchema} (account:string snake-or-gas:bool)
        (if snake-or-gas
            (with-default-read DALOS|AccountTable account
                { "ouroboros" : DPTF|BLANK }
                { "ouroboros" := o}
                o
            )
            (with-default-read DALOS|AccountTable account
                { "ignis" : DPTF|BLANK }
                { "ignis" := i}
                i
            )
        )
    )
    (defun UR_TF_AccountSupply:decimal (account:string snake-or-gas:bool)
        (at "balance" (UR_TrueFungible account snake-or-gas))
    )
    (defun UR_TF_AccountRoleBurn:bool (account:string snake-or-gas:bool)
        (at "role-burn" (UR_TrueFungible account snake-or-gas))
    )
    (defun UR_TF_AccountRoleMint:bool (account:string snake-or-gas:bool)
        (at "role-mint" (UR_TrueFungible account snake-or-gas))
    )
    (defun UR_TF_AccountRoleTransfer:bool (account:string snake-or-gas:bool)
        (at "role-transfer" (UR_TrueFungible account snake-or-gas))
    )
    (defun UR_TF_AccountRoleFeeExemption:bool (account:string snake-or-gas:bool)
        (at "role-fee-exemption" (UR_TrueFungible account snake-or-gas))
    )
    (defun UR_TF_AccountFreezeState:bool (account:string snake-or-gas:bool)
        (at "frozen" (UR_TrueFungible account snake-or-gas))
    )
    ;;{F1}  [URC]
    (defun URC_IgnisGasDiscount:decimal (account:string)
        @doc "Computes the Discount for Ignis Gas Costs. A value of 1.00 means no discount"
        (URC_GasDiscount account false)
    )
    (defun URC_KadenaGasDiscount:decimal (account:string)
        @doc "Computes the Discount for Ignis Gas Costs. A value of 1.00 means no discount"
        (URC_GasDiscount account true)
    )
    (defun URC_GasDiscount:decimal (account:string native:bool)
        @doc "Computes Gas Discount Values, a value of 1.00 means no discount"
        (let
            (
                (ref-U|DALOS:module{UtilityDalosV2} U|DALOS)
                (major:integer (UR_Elite-Tier-Major account))
                (minor:integer (UR_Elite-Tier-Minor account))
            )
            (ref-U|DALOS::UC_GasCost 1.00 major minor native)
        )
    )
    (defun URC_SplitKDAPrices:[decimal] (account:string kda-price:decimal)
        @doc "Computes the KDA Split required for Native Gas Collection \
        \ This is 10% 20% 30% and 40% split, outputed as 4 element list \
        \ Takes in consideration the Discounted KDA for <account>"
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|DALOS:module{UtilityDalosV2} U|DALOS)
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                (kda-discount:decimal (URC_KadenaGasDiscount account))
                (discounted-kda:decimal (floor (* kda-discount kda-price) kda-prec))
                (v1:decimal (* 0.1 discounted-kda))
                (v2:decimal (* 0.2 discounted-kda))
                (v3:decimal (* 0.3 discounted-kda))
                (v4:decimal (- discounted-kda (fold (+) 0.0 [v1 v2 v3])))
            )
            [v1 v2 v3 v4]
        )
    )
    (defun URC_Transferability:bool (sender:string receiver:string method:bool)
        (UEV_SenderWithReceiver sender receiver)
        (let
            (
                (s-sc:bool (UR_AccountType sender))
                (r-sc:bool (UR_AccountType receiver))
                (r-pasc:bool (UR_AccountPayableAs receiver))
                (r-pbsc:bool (UR_AccountPayableBy receiver))
                (r-mt:bool (UR_AccountPayableByMethod receiver))
            )
            (if (= s-sc false)
                (if (= r-sc false)              ;;sender is normal
                    true                        ;;receiver is normal (Normal => Normal | Case 1)
                    (if (= method true)         ;;receiver is smart  (Normal => Smart | Case 3)
                        r-mt
                        r-pasc
                    )
                )
                (if (= r-sc false)              ;;sender is smart
                    true                        ;;receiver is normal (Smart => Normal | Case 4)
                    (if (= method true)         ;;receiver is false (Smart => Smart | Case 2)
                        r-mt
                        r-pbsc
                    )
                )
            )
        )
    )
    (defun IGNIS|URC_Exception (account:string)
        (contains account GAS_EXCEPTION)
    )
    (defun IGNIS|URC_ZeroGAZ:bool (id:string sender:string receiver:string)
        (let
            (
                (t1:bool (IGNIS|URC_ZeroGAS id sender))
                (t2:bool (IGNIS|URC_Exception receiver))
            )
            (or t1 t2)
        )
    )
    (defun IGNIS|URC_ZeroGAS:bool (id:string sender:string)
        (let
            (
                (t1:bool (IGNIS|URC_IsVirtualGasZeroAbsolutely id))
                (t2:bool (IGNIS|URC_Exception sender))
            )
            (or t1 t2)
        )
    )
    (defun IGNIS|URC_IsVirtualGasZeroAbsolutely:bool (id:string)
        (let
            (
                (t1:bool (IGNIS|URC_IsVirtualGasZero))
                (gas-id:string (UR_IgnisID))
                (t2:bool (if (or (= gas-id BAR)(= id gas-id)) true false))
            )
            (or t1 t2)
        )
    )
    (defun IGNIS|URC_IsVirtualGasZero:bool ()
        (if (UR_VirtualToggle)
            false
            true
        )
    )
    (defun IGNIS|URC_IsNativeGasZero:bool ()
        (if (UR_NativeToggle)
            false
            true
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_StandardAccOwn (account:string)
        (let
            (
                (account-guard:guard (UR_AccountGuard account))
                (sovereign:string (UR_AccountSovereign account))
                (governor:guard (UR_AccountGovernor account))
            )
            (enforce (= sovereign account) "Incompatible Sovereign detected for a Standard DALOS Account")
            (enforce (= account-guard governor) "Incompatible Governer Guard detected for Standard DALOS Account")
            (enforce-guard account-guard)
        )
    )
    (defun UEV_SmartAccOwn (account:string)
        (let
            (
                (account-guard:guard (UR_AccountGuard account))
                (sovereign:string (UR_AccountSovereign account))
                (sovereign-guard:guard (UR_AccountGuard sovereign))
                (governor:guard (UR_AccountGovernor account))
            )
            (enforce (!= sovereign account) "Incompatible Sovereign detected for Smart DALOS Account")
            (enforce-one
                "Smart DALOS Account Permissions not satisfied !"
                [
                    (enforce-guard account-guard)
                    (enforce-guard sovereign-guard)
                    (enforce-guard governor)
                ]
            )
        )
    )
    (defun UEV_Methodic (account:string method:bool)
        (if method
            (CAP_EnforceAccountOwnership account)
            true
        )
    )
    (defun UEV_EnforceAccountExists (dalos-account:string)
        (with-default-read DALOS|AccountTable dalos-account
            { "elite" : DALOS|VOID }
            { "elite" := e }
            (let
                (
                    (deb:decimal (at "deb" e))
                )
                (enforce
                    (>= deb 1.0)
                    (format "The {} DALOS Account doesnt exist" [dalos-account])
                )
            )
        )
    )
    (defun UEV_EnforceAccountType (account:string smart:bool)
        (let
            (
                (x:bool (UR_AccountType account))
                (first:string (take 1 account))
                (ouroboros:string "Ѻ")
                (sigma:string "Σ")
            )
            (if smart
                (enforce (and (= first sigma) (= x true)) (format "Operation requires a Smart DALOS Account; Account {} isnt" [account]))
                (enforce (and (= first ouroboros) (= x false)) (format "Operation requires a Standard DALOS Account; Account {} isnt" [account]))
            )
        )
    )
    (defun UEV_EnforceTransferability (sender:string receiver:string method:bool)
        (let
            (
                (x:bool (URC_Transferability sender receiver method))
            )
            (enforce (= x true) (format "Transferability between {} and {} with {} Method is not ensured" [sender receiver method]))
        )
    )
    (defun UEV_SenderWithReceiver (sender:string receiver:string)
        (UEV_EnforceAccountExists sender)
        (UEV_EnforceAccountExists receiver)
        (enforce (!= sender receiver) "Sender and Receiver must be different")
    )
    (defun UEV_TwentyFourPrecision (amount:decimal)
        (enforce
            (= (floor amount 24) amount)
            (format "The GAS Amount of {} is not a valid GAS Amount decimal wise" [amount])
        )
    )
    (defun GLYPH|UEV_DalosAccountCheck (account:string)
        @doc "Checks if a string is a valid DALOS Account, using no enforcements "
        (let
            (
                (account-len:integer (length account))
                (t1:bool (= account-len 162))
                (ouroboros:string "Ѻ")
                (sigma:string "Σ")
                (first:string (take 1 account))
                (t2:bool (or (= first ouroboros)(= first sigma)))
                (t3:bool (and t1 t2))
                (second:string (drop 1 (take 2 account)))
                (point:string ".")
                (t4:bool (= second point))
                (t5:bool (GLYPH|UEV_MsDc (drop 2 account)))
                (t6:bool (and t4 t5))
            )
            (and t3 t6)
        )
    )
    (defun GLYPH|UEV_DalosAccount (account:string)
        @doc "Enforces that a Dalos Account (Address) has the proper format"
        (let
            (
                (account-len:integer (length account))
                (ouroboros:string "Ѻ")
                (sigma:string "Σ")
                (first:string (take 1 account))
                (second:string (drop 1 (take 2 account)))
                (point:string ".")
            )
            (enforce (= account-len 162) "Address|Account does not conform to the DALOS Standard for Addresses|Accounts")
            (enforce-one
                "Address|Account format is invalid"
                [
                    (enforce (= first ouroboros) "Account|Address Identifier is invalid, while checking for a Standard Account|Address")
                    (enforce (= first sigma) "Account|Address Identifier is invalid, while checking for a Smart Account|Address")
                ]
            )
            (enforce (= second point) "Account|Address Format is invalid, second Character must be a <.>")
            (let
                (
                    (checkup:bool (GLYPH|UEV_MsDc (drop 2 account)))
                )
                (enforce checkup "Characters do not conform to the DALOS|CHARSET")
            )
        )
    )
    (defun GLYPH|UEV_MsDc:bool (multi-s:string)
        @doc "Enforce a multistring is part of the DALOS|CHARSET"
        (let
            (
                (str-lst:[string] (str-to-list multi-s))
            )
            (fold
                (lambda
                    (acc:bool idx:integer)
                    (let
                        (
                            (checkup:bool (contains (at idx str-lst) DALOS|CHARSET))
                        )
                        (or acc checkup)
                    )
                )
                false
                (enumerate 0 (- (length str-lst) 1))
            )
        )
    )
    (defun IGNIS|UEV_VirtualState (state:bool)
        (let
            (
                (t:bool (UR_VirtualToggle))
            )
            (enforce (= t state) "Invalid virtual gas collection state!")
            (if (not state)
                (IGNIS|UEV_VirtualOnCondition)
                true
            )
        )
    )
    (defun IGNIS|UEV_VirtualOnCondition ()
        (let
            (
                (ouro-id:string (UR_OuroborosID))
                (gas-id:string (UR_IgnisID))
            )
            (enforce (!= ouro-id BAR) "OURO Id must be set for IGNIS Collection to turn ON!")
            (enforce (!= gas-id BAR) "IGNIS Id must be set for IGNIS Collection to turn ON!")
            (enforce (!= gas-id ouro-id) "OURO and IGNIS id must be different for the IGNIS Collection to turn ON!")
        )
    )
    (defun IGNIS|UEV_NativeState (state:bool)
        (let
            (
                (t:bool (UR_NativeToggle))
            )
            (enforce (= t state) "Invalid native gas collection state!")
        )
    )
    (defun IGNIS|UEV_Patron (patron:string)
        @doc "Capability that ensures a DALOS account can act as gas payer, enforcing all necesarry restrictions"
        (if (UR_AccountType patron)
            (do
                (enforce (= patron DALOS|SC_NAME) "Only the DALOS Account can be a Smart Patron")
                (CAP_EnforceAccountOwnership DALOS|SC_NAME)
            )
            (CAP_EnforceAccountOwnership patron)
        )
    )
    ;;{F3}  [UDC]
    (defun UDC_MakeIDP:string (ignis-discount:decimal)
        (format "{}{}" [(* (- 1.0 ignis-discount) 100.0) "%"])
    )
    (defun UDC_ConstructOutputCumulatorV2:object{OuronetDalosV3.OutputCumulatorV2}
        (price:decimal active-account:string trigger:bool output-lst:list)
        (UDC_MakeOutputCumulatorV2
            [
                (UDC_MakeModularCumulatorV2
                    price
                    active-account
                    trigger
                )
            ]
            output-lst
        )
    )
    (defun UDC_TFTCumulatorV2:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sender:string receiver:string dptf-transfer-amount:decimal)
        (UDC_ConstructOutputCumulatorV2
            (if (not (and (= id (UR_UnityID))(>= dptf-transfer-amount 10.0)))
                (UR_UsagePrice "ignis|smallest")
                0.0
            )
            sender
            (IGNIS|URC_ZeroGAZ id sender receiver)
            []
        )
    )
    (defun UDC_BrandingCumulatorV2:object{OuronetDalosV3.OutputCumulatorV2}
        (active-account:string multiplier:decimal)
        (UDC_ConstructOutputCumulatorV2
            (* multiplier (UR_UsagePrice "ignis|branding"))
            active-account
            (IGNIS|URC_IsVirtualGasZero)
            []
        )
    )
    (defun UDC_SmallCumulatorV2:object{OuronetDalosV3.OutputCumulatorV2}
        (active-account:string)
        (UDC_ConstructOutputCumulatorV2
            (UR_UsagePrice "ignis|small")
            active-account
            (IGNIS|URC_IsVirtualGasZero)
            []
        )
    )
    (defun UDC_MediumCumulatorV2:object{OuronetDalosV3.OutputCumulatorV2}
        (active-account:string)
        (UDC_ConstructOutputCumulatorV2
            (UR_UsagePrice "ignis|medium")
            active-account
            (IGNIS|URC_IsVirtualGasZero)
            []
        )
    )
    (defun UDC_BigCumulatorV2:object{OuronetDalosV3.OutputCumulatorV2}
        (active-account:string)
        (UDC_ConstructOutputCumulatorV2
            (UR_UsagePrice "ignis|big")
            active-account
            (IGNIS|URC_IsVirtualGasZero)
            []
        )
    )
    (defun UDC_BiggestCumulatorV2:object{OuronetDalosV3.OutputCumulatorV2}
        (active-account:string)
        (UDC_ConstructOutputCumulatorV2
            (UR_UsagePrice "ignis|biggest")
            active-account
            (IGNIS|URC_IsVirtualGasZero)
            []
        )
    )
    (defun UDC_MakeModularCumulatorV2:object{OuronetDalosV3.ModularCumulatorV2}
        (price:decimal active-account:string trigger:bool)
        (let
            (
                (interactor:string
                    (if (UR_AccountType active-account)
                        active-account
                        BAR
                    )
                )
            )
            (if trigger
                {"ignis"        : 0.0
                ,"interactor"   : BAR}
                {"ignis"        : price
                ,"interactor"   : interactor}
            )
        )
    )
    (defun UDC_MakeOutputCumulatorV2:object{OuronetDalosV3.OutputCumulatorV2}
        (input-modular-cumulator-chain:[object{OuronetDalosV3.ModularCumulatorV2}] output-lst:list)
        {"cumulator-chain"  : input-modular-cumulator-chain
        ,"output"           : output-lst}
    )
    (defun UDC_ConcatenateOutputCumulatorsV2:object{OuronetDalosV3.OutputCumulatorV2}
        (input-output-cumulator-chain:[object{OuronetDalosV3.OutputCumulatorV2}] new-output-lst:list)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (folded-obj:[[object{OuronetDalosV3.ModularCumulatorV2}]]
                    (fold
                        (lambda
                            (acc:[[object{OuronetDalosV3.ModularCumulatorV2}]] idx:integer)
                            (ref-U|LST::UC_AppL
                                acc
                                (at "cumulator-chain" (at idx input-output-cumulator-chain))
                            )
                        )
                        []
                        (enumerate 0 (- (length input-output-cumulator-chain) 1))
                    )
                )
            )
            {"cumulator-chain"  : (fold (+) [] folded-obj)
            ,"output"           : new-output-lst}
        )
    )
    (defun UDC_CompressOutputCumulator:object{OuronetDalosV3.CompressedCumulatorV2}
        (input-output-cumulator:object{OuronetDalosV3.OutputCumulatorV2})
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (cumulator-chain-input:[object{OuronetDalosV3.ModularCumulatorV2}] 
                    (at "cumulator-chain" input-output-cumulator)
                )
                (folded-obj:[object{OuronetDalosV3.CompressedCumulatorV2}]
                    (fold
                        (lambda
                            (acc:[object{OuronetDalosV3.CompressedCumulatorV2}] idx:integer)
                            (ref-U|LST::UC_ReplaceAt
                                acc
                                0
                                (let
                                    (
                                        (read-ignis-price:decimal (at "ignis" (at idx cumulator-chain-input)))
                                        (read-interactor:string (at "interactor" (at idx cumulator-chain-input)))
                                        (interactor-search:[integer] (ref-U|LST::UC_Search (at "interactors" (at 0 acc)) read-interactor))
                                        (iz-new:bool 
                                            (if (= (length interactor-search) 0)
                                                true
                                                false
                                            )
                                        )
                                    )
                                    (if iz-new
                                        {
                                            "ignis-prices"  : (ref-U|LST::UC_AppL (at "ignis-prices" (at 0 acc)) read-ignis-price),
                                            "interactors"   : (ref-U|LST::UC_AppL (at "interactors" (at 0 acc)) read-interactor)
                                        }
                                        (let
                                            (
                                                (interactor-position-in-acc:integer (at 0 interactor-search))
                                                (ignis-amount-in-acc:decimal (at interactor-position-in-acc (at "ignis-prices" (at 0 acc))))
                                                (updated-ignis-amount:decimal (+ read-ignis-price ignis-amount-in-acc))
                                            )
                                            {
                                                "ignis-prices"  : (ref-U|LST::UC_ReplaceAt (at "ignis-prices" (at 0 acc)) interactor-position-in-acc updated-ignis-amount),
                                                "interactors"   : (at "interactors" (at 0 acc))
                                            }
                                        )
                                    )
                                )
                            )
                        )
                        EMPTY_CC
                        (enumerate 0 (- (length cumulator-chain-input) 1))
                    )
                )
            )
            (at 0 folded-obj)
        )
    )
    (defun UDC_PrimeIgnisCumulatorV2:object{OuronetDalosV3.PrimedCumulatorV2}
        (patron:string input:object{OuronetDalosV3.CompressedCumulatorV2})
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (fll:integer (length (at "ignis-prices" input)))
                (ignis-discount:decimal (URC_IgnisGasDiscount patron))
                (folded-obj:[object{OuronetDalosV3.CompressedCumulatorV2}]
                    (fold
                        (lambda
                            (acc:[object{OuronetDalosV3.CompressedCumulatorV2}] idx:integer)
                            (ref-U|LST::UC_ReplaceAt
                                acc
                                0
                                (let
                                    (
                                        (input-ignis-price:decimal (at idx (at "ignis-prices" input)))
                                        (input-ignis-price-discounted:decimal (* input-ignis-price ignis-discount))
                                        (input-interactor:string (at idx (at "interactors" input)))
                                        (iz-interactor-principal:bool
                                            (if (= input-interactor BAR)
                                                true
                                                false
                                            )
                                        )
                                        (smart-ignis-amount:decimal
                                            (if iz-interactor-principal
                                                0.0
                                                (* GAS_QUARTER input-ignis-price-discounted)
                                            )
                                        )
                                        (prime-ignis-amount:decimal (- input-ignis-price-discounted smart-ignis-amount))

                                        (principal-interactor-search:[integer] (ref-U|LST::UC_Search (at "interactors" (at 0 acc)) BAR))
                                        (principal-interactor-exists:bool 
                                            (if (= (length principal-interactor-search) 0)
                                                false
                                                true
                                            )
                                        )
                                    )
                                    (if principal-interactor-exists
                                        ;;Wen principal interactor already exists
                                        (let
                                            (
                                                (principal-interactor-position:integer (at 0 principal-interactor-search))
                                                (principal-interactor-current-ignis-amount:decimal (at principal-interactor-position (at "ignis-prices" (at 0 acc))))
                                                (updated-interactor-ignis-amount:decimal (+ principal-interactor-current-ignis-amount prime-ignis-amount))
                                            )
                                            (if iz-interactor-principal
                                                ;;Wen interactor is principal
                                                {
                                                    "ignis-prices"  : (ref-U|LST::UC_ReplaceAt (at "ignis-prices" (at 0 acc)) principal-interactor-position updated-interactor-ignis-amount),
                                                    "interactors"   : (ref-U|LST::UC_AppL (at "interactors" (at 0 acc)) input-interactor)
                                                }
                                                ;;Wen interactor is not principal
                                                {
                                                    "ignis-prices"  : (ref-U|LST::UC_AppL (ref-U|LST::UC_ReplaceAt (at "ignis-prices" (at 0 acc)) principal-interactor-position updated-interactor-ignis-amount) smart-ignis-amount),
                                                    "interactors"   : (ref-U|LST::UC_AppL (at "interactors" (at 0 acc)) input-interactor)
                                                }
                                            )
                                        )
                                        ;;Wen principal interactor doesnt exit yet
                                        (if iz-interactor-principal
                                            ;;Wen interactor is principal
                                            {
                                                "ignis-prices"  : (ref-U|LST::UC_AppL (at "ignis-prices" (at 0 acc)) prime-ignis-amount),
                                                "interactors"   : (ref-U|LST::UC_AppL (at "interactors" (at 0 acc)) input-interactor)
                                            }
                                            ;;Wen interactor is not principal
                                            {
                                                "ignis-prices"  : (ref-U|LST::UC_AppL (ref-U|LST::UC_AppL (at "ignis-prices" (at 0 acc)) prime-ignis-amount) smart-ignis-amount),
                                                "interactors"   : (ref-U|LST::UC_AppL (ref-U|LST::UC_AppL (at "interactors" (at 0 acc)) BAR) input-interactor)
                                            }
                                        )
                                    )
                                )
                            )
                        )
                        EMPTY_CC
                        (enumerate 0 (- fll 1))
                    )
                )
            )
            {"primed-cumulator" : (at 0 folded-obj)}
        )
    )
    ;;{F4}  [CAP]
    (defun CAP_EnforceAccountOwnership (account:string)
        @doc "Enforces OuroNet Account Ownership"
        (let
            (
                (type:bool (UR_AccountType account))
            )
            (if type
                (UEV_SmartAccOwn account)
                (UEV_StandardAccOwn account)
            )
        )
    )
    ;;
    ;;{F5}  [A]
    (defun A_MigrateLiquidFunds:decimal (migration-target-kda-account:string)
        (UEV_IMC)
        (with-capability (GOV|MIGRATE migration-target-kda-account)
            (let
                (
                    (ref-coin:module{fungible-v2} coin)
                    (dalos-kda:string DALOS|SC_KDA-NAME)
                    (present-kda-balance:decimal (ref-coin::get-balance dalos-kda))
                )
                (install-capability (ref-coin::TRANSFER dalos-kda migration-target-kda-account present-kda-balance))
                (C_TransferDalosFuel dalos-kda migration-target-kda-account present-kda-balance)
                present-kda-balance
            )
        )
    )
    (defun A_ToggleOAPU (oapu:bool)
        (UEV_IMC)
        (with-capability (GOV|DALOS_ADMIN)
            (XI_UpdateOAPU oapu)
        )
    )
    (defun A_ToggleGAP (gap:bool)
        (UEV_IMC)
        (with-capability (GOV|GAP gap)
            (XI_UpdateGAP gap)
        )
    )
    (defun A_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        (with-capability (SECURE-ADMIN)
            (XI_DeploySmartAccount account guard kadena sovereign public)
        )
    )
    (defun A_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        (with-capability (SECURE-ADMIN)
            (XI_DeployStandardAccount account guard kadena public)
        )
    )
    (defun A_IgnisToggle (native:bool toggle:bool)
        (UEV_IMC)
        (with-capability (IGNIS|C>TOGGLE native toggle)
            (XI_IgnisToggle native toggle)
        )
    )
    (defun A_SetIgnisSourcePrice (price:decimal)
        (UEV_IMC)
        (with-capability (GOV|DALOS_ADMIN)
            (XB_UpdateOuroPrice price)
        )
    )
    (defun A_SetAutoFueling (toggle:bool)
        (UEV_IMC)
        (with-capability (GOV|DALOS_ADMIN)
            (XI_SetAutoFueling toggle)
        )
    )
    (defun A_UpdatePublicKey (account:string new-public:string)
        (UEV_IMC)
        (with-capability (GOV|DALOS_ADMIN)
            (update DALOS|AccountTable account
                {"public"     : new-public}
            )
        )
    )
    (defun A_UpdateUsagePrice (action:string new-price:decimal)
        (UEV_IMC)
        (with-capability (GOV|DALOS_ADMIN)
            (let
                (
                    (ref-U|CT:module{OuronetConstants} U|CT)
                    (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                )
                (write DALOS|PricesTable action
                    {"price"     : (floor new-price kda-prec)}
                )
            )
        )
    )
    ;;{F6}  [C]
    (defun C_ControlSmartAccount:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool)
        (UEV_IMC)
        (with-capability (DALOS|C>CTRL_SM-ACC account payable-as-smart-contract payable-by-smart-contract payable-by-method)
            (XI_UpdateSmartAccountParameters account payable-as-smart-contract payable-by-smart-contract payable-by-method)
            (UDC_SmallCumulatorV2 account)
        )
    )
    (defun C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        (UEV_IMC)
        (with-capability (SECURE)
            (XI_DeploySmartAccount account guard kadena sovereign public)
        )
    )
    (defun C_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        (UEV_IMC)
        (with-capability (SECURE)
            (XI_DeployStandardAccount account guard kadena public)
        )
    )
    (defun C_RotateGovernor:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string governor:guard)
        (UEV_IMC)
        (with-capability (DALOS|C>RT_GOV account)
            (XI_RotateGovernor account governor)
            (UDC_SmallCumulatorV2 account)
        )
    )
    (defun C_RotateGuard:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string new-guard:guard safe:bool)
        (UEV_IMC)
        (with-capability (DALOS|C>RT_ACC account)
            (XI_RotateGuard account new-guard safe)
            (UDC_SmallCumulatorV2 account)
        )
    )
    (defun C_RotateKadena:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string kadena:string)
        (UEV_IMC)
        (with-capability (DALOS|C>RT_ACC account)
            (XI_RotateKadena account kadena)
            (XI_UpdateKadenaLedger (UR_AccountKadena account) account false)
            (XI_UpdateKadenaLedger kadena account true)
            (UDC_SmallCumulatorV2 account)
        )
    )
    (defun C_RotateSovereign:object{OuronetDalosV3.OutputCumulatorV2}
        (account:string new-sovereign:string)
        (UEV_IMC)
        (with-capability (DALOS|C>RT_SOV account new-sovereign)
            (XI_RotateSovereign account new-sovereign)
            (UDC_SmallCumulatorV2 account)
        )
    )
    ;;
    (defun C_TransferDalosFuel (sender:string receiver:string amount:decimal)
        (let
            (
                (ref-coin:module{fungible-v2} coin)
            )
            (ref-coin::transfer sender receiver amount)
        )
    )
    (defun IGNIS|C_Collect
        (patron:string input-output-cumulator:object{OuronetDalosV3.OutputCumulatorV2})
        (let
            (
                (compressed-cumulator:object{OuronetDalosV3.CompressedCumulatorV2}
                    (UDC_CompressOutputCumulator input-output-cumulator)
                )
                (primed-cumulator:object{OuronetDalosV3.PrimedCumulatorV2}
                    (UDC_PrimeIgnisCumulatorV2 patron compressed-cumulator)
                )
                (ignis-prices:[decimal] (at "ignis-prices" (at "primed-cumulator" primed-cumulator)))
                (ignis-sum:decimal (fold (+) 0.0 ignis-prices))
                (iz-gassles-patron:bool (UR_AccountType patron))
            )
            (if (and (!= ignis-sum 0.0) (not iz-gassles-patron))
                (with-capability (IGNIS|C>DC patron)
                    (let
                        (
                            (icl:integer (length ignis-prices))
                            (primed-collector:object{OuronetDalosV3.CompressedCumulatorV2} 
                                (at "primed-cumulator" primed-cumulator)
                            )
                        )
                        (map
                            (lambda
                                (idx:integer)
                                (let
                                    (
                                        (interactor:string (at idx (at "interactors" primed-collector)))
                                        (amount:decimal (at idx (at "ignis-prices" primed-collector)))
                                    )
                                    (with-capability (IGNIS|C>COLLECT patron interactor amount)
                                        (XI_IgnisCollector patron interactor amount)
                                    )
                                )
                            )
                            (enumerate 0 (- icl 1))
                        )
                        (with-read DALOS|AccountTable patron
                            { "nonce" := n }
                            (update DALOS|AccountTable patron { "nonce" : (+ n 1)})
                        )
                    )
                )
                (with-capability (IGNIS|S>FREE)
                    true
                )
            )
        )
    )
    (defun KDA|C_Collect (sender:string amount:decimal)
        (KDA|C_CollectWT sender amount (IGNIS|URC_IsNativeGasZero))
    )
    (defun KDA|C_CollectWT (sender:string amount:decimal trigger:bool)
        (let
            (
                (split-discounted-kda:[decimal] (URC_SplitKDAPrices sender amount))
                (am0:decimal (at 0 split-discounted-kda))
                (am1:decimal (at 1 split-discounted-kda))
                (am2:decimal (at 2 split-discounted-kda))
                (am3:decimal (at 3 split-discounted-kda))
                (kda-sender:string (UR_AccountKadena sender))
                (demiurgoi:[string] (UR_DemiurgoiID))
                (kda-cto:string (UR_AccountKadena (at 1 demiurgoi)))
                (kda-hov:string (UR_AccountKadena (at 2 demiurgoi)))
                (kda-ouroboros:string (UR_AccountKadena (GOV|OUROBOROS|SC_NAME)))
                (kda-dalos:string (UR_AccountKadena DALOS|SC_NAME))
            )
            (if (not trigger)
                (do
                    (C_TransferDalosFuel kda-sender kda-hov am0)          ;;10% to Demiourgos.Holdings
                    (C_TransferDalosFuel kda-sender kda-cto am2)          ;;30% to Ouronet Maintenance
                    (C_TransferDalosFuel kda-sender kda-ouroboros am3)    ;;40% to KDA-Ouroboros (as Pitstop for LiquidKadenaIndex fueling)
                    (C_TransferDalosFuel kda-sender kda-dalos am1)        ;;20% to KDA-Dalos (Ouronet Gas Station)
                )
                (format "While Kadena Collection is {}, the {} KDA could not be collected" [trigger amount])
            )
        )
    )
    ;;{F7}  [X]
    (defun XB_UpdateBalance (account:string snake-or-gas:bool new-balance:decimal)
        (UEV_IMC)
        (let
            (
                (obj:object{OuronetDalosV3.DPTF|BalanceSchema} (UR_TrueFungible account snake-or-gas))
                (new-obj:object{OuronetDalosV3.DPTF|BalanceSchema}
                    {"exist"                : (at "exist" obj)
                    ,"balance"              : new-balance
                    ,"role-burn"            : (at "role-burn" obj)
                    ,"role-mint"            : (at "role-mint" obj)
                    ,"role-transfer"        : (at "role-transfer" obj)
                    ,"role-fee-exemption"   : (at "role-fee-exemption" obj)
                    ,"frozen"               : (at "frozen" obj)}
                )
            )
            (with-capability (SECURE)
                (XI_UpdateTF account snake-or-gas new-obj)
            )
        )
    )
    (defun XB_UpdateOuroPrice (price:decimal)
        (UEV_IMC)
        (update DALOS|PropertiesTable DALOS|INFO
            {"gas-source-id-price" : price}
        )
    )
    ;;
    (defun XE_ClearDispo (account:string)
        (UEV_IMC)
        (with-capability (SECURE)
            (XB_UpdateBalance account true 0.0)
        )
    )
    (defun XE_UpdateBurnRole (account:string snake-or-gas:bool new-burn:bool)
        (UEV_IMC)
        (let
            (
                (obj:object{OuronetDalosV3.DPTF|BalanceSchema} (UR_TrueFungible account snake-or-gas))
                (new-obj:object{OuronetDalosV3.DPTF|BalanceSchema}
                    {"exist"                : (at "exist" obj)
                    ,"balance"              : (at "balance" obj)
                    ,"role-burn"            : new-burn
                    ,"role-mint"            : (at "role-mint" obj)
                    ,"role-transfer"        : (at "role-transfer" obj)
                    ,"role-fee-exemption"   : (at "role-fee-exemption" obj)
                    ,"frozen"               : (at "frozen" obj)}
                )
            )
            (with-capability (SECURE)
                (XI_UpdateTF account snake-or-gas new-obj)
            )
        )
    )
    (defun XE_UpdateElite (account:string amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-U|ATS:module{UtilityAts} U|ATS)
            )
            (if (= (UR_AccountType account) false)
                (update DALOS|AccountTable account
                    { "elite" : (ref-U|ATS::UDC_Elite amount)}
                )
                true
            )
        )
    )
    (defun XE_UpdateFeeExemptionRole (account:string snake-or-gas:bool new-fee-exemption:bool)
        (UEV_IMC)
        (let
            (
                (obj:object{OuronetDalosV3.DPTF|BalanceSchema} (UR_TrueFungible account snake-or-gas))
                (new-obj:object{OuronetDalosV3.DPTF|BalanceSchema}
                    {"exist"                : (at "exist" obj)
                    ,"balance"              : (at "balance" obj)
                    ,"role-burn"            : (at "role-burn" obj)
                    ,"role-mint"            : (at "role-mint" obj)
                    ,"role-transfer"        : (at "role-transfer" obj)
                    ,"role-fee-exemption"   : new-fee-exemption
                    ,"frozen"               : (at "frozen" obj)}
                )
            )
            (with-capability (SECURE)
                (XI_UpdateTF account snake-or-gas new-obj)
            )
        )
    )
    (defun XE_UpdateFreeze (account:string snake-or-gas:bool new-freeze:bool)
        (UEV_IMC)
        (let
            (
                (obj:object{OuronetDalosV3.DPTF|BalanceSchema} (UR_TrueFungible account snake-or-gas))
                (new-obj:object{OuronetDalosV3.DPTF|BalanceSchema}
                    {"exist"                : (at "exist" obj)
                    ,"balance"              : (at "balance" obj)
                    ,"role-burn"            : (at "role-burn" obj)
                    ,"role-mint"            : (at "role-mint" obj)
                    ,"role-transfer"        : (at "role-transfer" obj)
                    ,"role-fee-exemption"   : (at "role-fee-exemption" obj)
                    ,"frozen"               : new-freeze}
                )
            )
            (with-capability (SECURE)
                (XI_UpdateTF account snake-or-gas new-obj)
            )
        )
    )
    (defun XE_UpdateMintRole (account:string snake-or-gas:bool new-mint:bool)
        (UEV_IMC)
        (let
            (
                (obj:object{OuronetDalosV3.DPTF|BalanceSchema} (UR_TrueFungible account snake-or-gas))
                (new-obj:object{OuronetDalosV3.DPTF|BalanceSchema}
                    {"exist"                : (at "exist" obj)
                    ,"balance"              : (at "balance" obj)
                    ,"role-burn"            : (at "role-burn" obj)
                    ,"role-mint"            : new-mint
                    ,"role-transfer"        : (at "role-transfer" obj)
                    ,"role-fee-exemption"   : (at "role-fee-exemption" obj)
                    ,"frozen"               : (at "frozen" obj)}
                )
            )
            (with-capability (SECURE)
                (XI_UpdateTF account snake-or-gas new-obj)
            )
        )
    )
    (defun XE_UpdateTransferRole (account:string snake-or-gas:bool new-transfer:bool)
        (UEV_IMC)
        (let
            (
                (obj:object{OuronetDalosV3.DPTF|BalanceSchema} (UR_TrueFungible account snake-or-gas))
                (new-obj:object{OuronetDalosV3.DPTF|BalanceSchema}
                    {"exist"                : (at "exist" obj)
                    ,"balance"              : (at "balance" obj)
                    ,"role-burn"            : (at "role-burn" obj)
                    ,"role-mint"            : (at "role-mint" obj)
                    ,"role-transfer"        : new-transfer
                    ,"role-fee-exemption"   : (at "role-fee-exemption" obj)
                    ,"frozen"               : (at "frozen" obj)}
                )
            )
            (with-capability (SECURE)
                (XI_UpdateTF account snake-or-gas new-obj)
            )
        )
    )
    (defun XE_UpdateTreasury (type:integer tdp:decimal tds:decimal)
        (UEV_IMC)
        (update DALOS|PropertiesTable DALOS|INFO
            {"treasury-dispo-type"          : type
            ,"treasury-dynamic-promille"    : tdp
            ,"treasury-static-tds"          : tds}

        )
    )
    ;;
    (defun XI_UpdateOAPU (oapu:bool)
        (UEV_IMC)
        (update DALOS|PropertiesTable DALOS|INFO
            {"ouro-auto-price-via-swaps"    : oapu}
        )
    )
    (defun XI_UpdateGAP (gap:bool)
        (UEV_IMC)
        (update DALOS|PropertiesTable DALOS|INFO
            {"global-administrative-pause"  : gap}
        )
    )
    (defun XI_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        (require-capability (SECURE))
        (with-capability (DALOS|S>D-SM account guard kadena sovereign)
            (insert DALOS|AccountTable account
                { "public"                      : public
                , "guard"                       : guard
                , "kadena-konto"                : kadena
                , "sovereign"                   : sovereign
                , "governor"                    : guard

                , "smart-contract"              : true
                , "payable-as-smart-contract"   : false
                , "payable-by-smart-contract"   : false
                , "payable-by-method"           : true

                , "nonce"                       : 0
                , "elite"                       : DALOS|PLEB
                , "ouroboros"                   : DPTF|BLANK
                , "ignis"                       : DPTF|BLANK
                }
            )
            (XI_UpdateKadenaLedger kadena account true)
            (if (not (IGNIS|URC_IsNativeGasZero))
                (KDA|C_Collect account (UR_UsagePrice "smart"))
                true
            )
        )
    )
    (defun XI_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        (require-capability (SECURE))
        (with-capability (DALOS|S>D-ST account guard kadena)
                (insert DALOS|AccountTable account
                    { "public"                      : public
                    , "guard"                       : guard
                    , "kadena-konto"                : kadena
                    , "sovereign"                   : account
                    , "governor"                    : guard

                    , "smart-contract"              : false
                    , "payable-as-smart-contract"   : false
                    , "payable-by-smart-contract"   : false
                    , "payable-by-method"           : false

                    , "nonce"                       : 0
                    , "elite"                       : DALOS|PLEB
                    , "ouroboros"                   : DPTF|BLANK
                    , "ignis"                       : DPTF|BLANK
                    }
                )
                (XI_UpdateKadenaLedger kadena account true)
                (if (not (IGNIS|URC_IsNativeGasZero))
                    (KDA|C_Collect account (UR_UsagePrice "standard"))
                    true
                )
            )
    )
    (defun XI_IgnisCollector (patron:string interactor:string amount:decimal)
        (require-capability (IGNIS|C>COLLECT patron interactor amount))
        (let
            (
                (collector:string
                    (if (= interactor BAR)
                        (UR_Tanker)
                        interactor
                    )
                )
            )
            (with-read DALOS|AccountTable collector
                { "nonce" := n }
                (update DALOS|AccountTable collector { "nonce" : (+ n 1)})
            )
            (XI_IgnisTransfer patron collector amount)
            (XI_IgnisIncrement false amount)
        )
    )
    (defun XI_IgnisCredit (receiver:string ta:decimal)
        (require-capability (IGNIS|C>CREDIT receiver))
        (XB_UpdateBalance receiver false (+ (UR_TF_AccountSupply receiver false) ta))
    )
    (defun XI_IgnisDebit (sender:string ta:decimal)
        (require-capability (IGNIS|C>DEBIT sender ta))
        (XB_UpdateBalance sender false (- (UR_TF_AccountSupply sender false) ta))
    )
    (defun XI_IgnisIncrement (native:bool increment:decimal)
        (require-capability (SECURE))
        (if (= native true)
            (update DALOS|GasManagementTable DALOS|VGD
                {"native-gas-spent" : (+ (UR_NativeSpent) increment)}
            )
            (update DALOS|GasManagementTable DALOS|VGD
                {"virtual-gas-spent" : (+ (UR_VirtualSpent) increment)}
            )
        )
    )
    (defun XI_IgnisToggle (native:bool toggle:bool)
        (require-capability (GOV|DALOS_ADMIN))
        (if (= native true)
            (update DALOS|GasManagementTable DALOS|VGD
                {"native-gas-toggle" : toggle}
            )
            (update DALOS|GasManagementTable DALOS|VGD
                {"virtual-gas-toggle" : toggle}
            )
        )
    )
    (defun XI_SetAutoFueling (toggle:bool)
        (require-capability (GOV|DALOS_ADMIN))
        (update DALOS|GasManagementTable DALOS|VGD
            {"native-gas-pump" : toggle}
        )
    )
    (defun XI_IgnisTransfer (sender:string receiver:string ta:decimal)
        (require-capability (IGNIS|C>TRANSFER sender receiver ta))
        (XI_IgnisDebit sender ta)
        (XI_IgnisCredit receiver ta)
    )
    (defun XI_RotateGovernor (account:string governor:guard)
        (require-capability (DALOS|F>GOV account))
        (update DALOS|AccountTable account
            {"governor" : governor}
        )
    )
    (defun XI_RotateGuard (account:string new-guard:guard safe:bool)
        (require-capability (DALOS|F>OWNER account))
        (if safe
            (enforce-guard new-guard)
            true
        )
        (if (UR_AccountType account)
            (update DALOS|AccountTable account
                {"guard"    : new-guard}
            )
            (update DALOS|AccountTable account
                {"guard"    : new-guard
                ,"governor" : new-guard}
            )
        )
    )
    (defun XI_RotateKadena (account:string kadena:string)
        (require-capability (DALOS|F>OWNER account))
        (update DALOS|AccountTable account
            {"kadena-konto"                  : kadena}
        )
    )
    (defun XI_RotateSovereign (account:string new-sovereign:string)
        (require-capability (DALOS|C>RT_SOV account new-sovereign))
        (update DALOS|AccountTable account
            {"sovereign"                        : new-sovereign}
        )
    )
    (defun XI_UpdateKadenaLedger (kadena:string dalos:string direction:bool)
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (with-default-read DALOS|KadenaLedger kadena
                { "dalos"    : [BAR] }
                { "dalos"    := d }
                (let
                    (
                        (add-lst:[string]
                            (if (= d [BAR])
                                [dalos]
                                (if (contains dalos d)
                                    d
                                    (ref-U|LST::UC_AppL d dalos)
                                )
                            )
                        )
                        (data-len:integer (length d))
                        (first:string (at 0 d))
                        (rmv-lst:[string]
                            (if (and (= data-len 1)(!= first BAR))
                                [BAR]
                                (ref-U|LST::UC_RemoveItem d dalos)
                            )
                        )
                    )
                    (if direction
                        (write DALOS|KadenaLedger kadena
                            { "dalos" : add-lst}
                        )
                        (write DALOS|KadenaLedger kadena
                            { "dalos" : rmv-lst}
                        )
                    )

                )
            )
        )
    )
    (defun XI_UpdateSmartAccountParameters (account:string pasc:bool pbsc:bool pbm:bool)
        (require-capability (DALOS|C>CTRL_SM-ACC account pasc pbsc pbm))
        (update DALOS|AccountTable account
            {"payable-as-smart-contract"    : pasc
            ,"payable-by-smart-contract"    : pbsc
            ,"payable-by-method"            : pbm}
        )
    )
    (defun XI_UpdateTF (account:string snake-or-gas:bool new-obj:object{OuronetDalosV3.DPTF|BalanceSchema})
        (require-capability (SECURE))
        (if snake-or-gas
            (update DALOS|AccountTable account
                {"ouroboros" : new-obj}
            )
            (update DALOS|AccountTable account
                {"ignis" : new-obj}
            )
        )
    )
    ;;
)

(create-table P|T)
(create-table P|MT)
(create-table DALOS|PropertiesTable)
(create-table DALOS|GasManagementTable)
(create-table DALOS|PricesTable)
(create-table DALOS|AccountTable)
(create-table DALOS|KadenaLedger)