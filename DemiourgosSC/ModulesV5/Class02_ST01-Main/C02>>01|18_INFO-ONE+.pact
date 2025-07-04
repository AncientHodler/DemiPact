(interface InfoOneV2
    @doc "Exposes Functions from Information One Module"
    ;;
    ;;
    ;;  [UC] Functions
    ;;
    (defun UC|GasPrice:decimal (full-price:decimal trigger:bool))
    ;;
    ;;
    ;;  [SIP|URC] Functions
    ;;
    (defun SIP|URC_Small:decimal ())
    (defun SIP|URC_Medium ())
    (defun SIP|URC_Big:decimal ())
    (defun SIP|URC_Biggest ())
    (defun SIP|URC_UpdatePendingBranding:decimal (m:decimal))
    (defun SIP|URC_Burn:decimal (id:string account:string))
    (defun SIP|URC_Issue:decimal (name:[string]))
    (defun SIP|URC_Mint:decimal (id:string account:string origin:bool))
    ;;
    ;;
    ;;  [SKP|URC] Functions
    ;;
    (defun SKP|URC_UpgradeBranding (months:integer))
    (defun SKP|URC_Issue (name:[string] dptf-or-dpmf:bool))
    (defun SKP|URC_ToggleFeeLock (id:string toggle:bool fee-unlocks:integer))
    ;;
    ;;
    ;;  [INFO] Functions
    ;;
    (defun DPTF|INFO_UpdatePendingBranding:object{OuronetInfoV2.ClientInfo} (patron:string entity-id:string))
    (defun DPTF|INFO_UpgradeBranding:object{OuronetInfoV2.ClientInfo} (patron:string entity-id:string months:integer))
    (defun DPTF|INFO_Burn:object{OuronetInfoV2.ClientInfo} (patron:string id:string account:string amount:decimal))
    (defun DPTF|INFO_Control:object{OuronetInfoV2.ClientInfo} (patron:string id:string))
    (defun DPTF|INFO_DeployAccount:object{OuronetInfoV2.ClientInfo} (patron:string id:string account:string))
    (defun DPTF|INFO_DonateFees:object{OuronetInfoV2.ClientInfo} (patron:string id:string))
    (defun DPTF|INFO_Issue:object{OuronetInfoV2.ClientInfo} (patron:string account:string name:[string]))
    (defun DPTF|INFO_Mint:object{OuronetInfoV2.ClientInfo} (patron:string id:string account:string amount:decimal origin:bool))
    (defun DPTF|INFO_ResetFeeTarget:object{OuronetInfoV2.ClientInfo} (patron:string id:string))
    (defun DPTF|INFO_RotateOwnership:object{OuronetInfoV2.ClientInfo} (patron:string id:string new-owner:string))
    (defun DPTF|INFO_SetFee:object{OuronetInfoV2.ClientInfo} (patron:string id:string fee:decimal))
    (defun DPTF|INFO_SetFeeTarget:object{OuronetInfoV2.ClientInfo} (patron:string id:string target:string))
    (defun DPTF|INFO_SetMinMove:object{OuronetInfoV2.ClientInfo} (patron:string id:string min-move-value:decimal))
    (defun DPTF|INFO_ToggleFee:object{OuronetInfoV2.ClientInfo} (patron:string id:string toggle:bool))
    (defun DPTF|INFO_ToggleFeeLock:object{OuronetInfoV2.ClientInfo} (patron:string id:string toggle:bool fee-unlocks:integer))
    (defun DPTF|INFO_ToggleFreezeAccount:object{OuronetInfoV2.ClientInfo} (patron:string id:string account:string toggle:bool))
    (defun DPTF|INFO_TogglePause:object{OuronetInfoV2.ClientInfo} (patron:string id:string toggle:bool))
    (defun DPTF|INFO_ToggleReservation:object{OuronetInfoV2.ClientInfo} (patron:string id:string toggle:bool))
    (defun DPTF|INFO_ToggleTransferRole:object{OuronetInfoV2.ClientInfo} (patron:string id:string account:string toggle:bool))
    (defun DPTF|INFO_Wipe:object{OuronetInfoV2.ClientInfo} (patron:string id:string atbw:string))
    (defun DPTF|INFO_WipePartial:object{OuronetInfoV2.ClientInfo} (patron:string id:string atbw:string amtbw:decimal))
    (defun DPTF|INFO_Transfer:object{OuronetInfoV2.ClientInfo} (patron:string id:string sender:string receiver:string transfer-amount:decimal))
    (defun DPTF|INFO_MultiTransfer:object{OuronetInfoV2.ClientInfo} (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal]))
    (defun DPTF|INFO_BulkTransfer:object{OuronetInfoV2.ClientInfo} (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal]))
    (defun DPTF|INFO_MultiBulkTransfer:object{OuronetInfoV2.ClientInfo} (patron:string id-lst:[string] sender:string receiver-array:[[string]] transfer-amount-array:[[decimal]]))
    ;;
    (defun DPMF|INFO_UpdatePendingBranding:object{OuronetInfoV2.ClientInfo} (patron:string entity-id:string))
    (defun DPMF|INFO_UpgradeBranding:object{OuronetInfoV2.ClientInfo} (patron:string entity-id:string months:integer))
    (defun DPMF|INFO_AddQuantity:object{OuronetInfoV2.ClientInfo} (patron:string id:string nonce:integer account:string amount:decimal))
    (defun DPMF|INFO_Burn:object{OuronetInfoV2.ClientInfo} (patron:string id:string nonce:integer account:string amount:decimal))
    (defun DPMF|INFO_Control:object{OuronetInfoV2.ClientInfo} (patron:string id:string))
    (defun DPMF|INFO_Create:object{OuronetInfoV2.ClientInfo} (patron:string id:string account:string))
    (defun DPMF|INFO_DeployAccount:object{OuronetInfoV2.ClientInfo} (patron:string id:string account:string))
    (defun DPMF|INFO_Issue:object{OuronetInfoV2.ClientInfo} (patron:string account:string name:[string]))
    (defun DPMF|INFO_Mint:object{OuronetInfoV2.ClientInfo} (patron:string id:string account:string amount:decimal))
    ;;
    (defun ATS|INFO_Coil:object{OuronetInfoV2.ClientInfo} (patron:string coiler:string ats:string rt:string amount:decimal))
    ;;
    (defun SWP|INFO_AddLiquidity:object{OuronetInfoV2.ClientInfo} (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun SWP|INFO_IcedLiquidity:object{OuronetInfoV2.ClientInfo} (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun SWP|INFO_GlacialLiquidity:object{OuronetInfoV2.ClientInfo} (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun SWP|INFO_FrozenLiquidity:object{OuronetInfoV2.ClientInfo} (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal kda-pid:decimal))
    (defun SWP|INFO_SleepingLiquidity:object{OuronetInfoV2.ClientInfo} (patron:string account:string swpair:string sleeping-dpmf:string nonce:integer kda-pid:decimal))
)
(module INFO-ONE GOV
    ;;
    (implements InfoOneV2)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_INFO|DPTF      (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|INFO|DPTF_ADMIN)))
    (defcap GOV|INFO|DPTF_ADMIN ()  (enforce-guard GOV|MD_INFO|DPTF))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
    (defun CT_EmptyCumulator        ()(let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::DALOS|EmptyOutputCumulatorV2)))
    (defun GOV|SWP|SC_NAME ()       (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|SWP|SC_NAME)))
    (defconst BAR                   (CT_Bar))
    (defconst EOC                   (CT_EmptyCumulator))
    (defconst SWP|SC_NAME           (GOV|SWP|SC_NAME))
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
    (defun UC|GasPrice:decimal (full-price:decimal trigger:bool)
        (if trigger 0.0 full-price)
    )
    (defun UCX_AddLiquidity:object{OuronetInfoV2.ClientInfo} 
        (
            patron:string account:string swpair:string input-amounts:[decimal]
            asymmetric-collection:bool gaseous-collection:bool kda-pid:decimal
        )
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                (ref-SWPL:module{SwapperLiquidity} SWPL)
                (ld:object{SwapperLiquidity.LiquidityData}
                    (ref-SWPL::URC_LD swpair input-amounts)
                )
                ;;
                ;;Compute Liquidity Addition Data
                (clad:object{SwapperLiquidity.CompleteLiquidityAdditionData}
                    (ref-SWPL::URC|KDA-PID_CLAD account swpair ld asymmetric-collection gaseous-collection kda-pid)
                )
                (ifp:decimal 
                    (ref-I|OURONET::OI|UC_IfpFromOutputCumulator 
                        (at "perfect-ignis-fee" (at "clad-op" clad))
                    )
                )
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (UCXX_AddLiquidityClientInfo patron ifp swpair (ref-DALOS::UR_IgnisID) clad asymmetric-collection false false)
        )
    )
    (defun UCXX_AddLiquidityClientInfo
        (
            patron:string ifp:decimal swpair:string ignis-id:string 
            clad:object{SwapperLiquidity.CompleteLiquidityAdditionData}
            asymmetric-collection:bool iz-for-sleeping:bool iz-for-frozen:bool
        )
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                (primary:decimal (at "primary-lp" clad))
                (secondary:decimal (at "secondary-lp" clad))
                (sum:decimal (+ primary secondary))
                (ignis-discount:decimal (ref-DALOS::URC_IgnisGasDiscount patron))
                (discount-percent:string (format "{}%" [(* 100.0 (- 1.0 ignis-discount))]))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Adding Liquidity with the following Parameters and {} costs:" [ignis-id])
                    (format "Fees are discounted by {} - your IGNIS discount, Taxes are paid in Full." [discount-percent])
                    (format "{}" [(at "gaseous-text" clad)])
                    (format "{}" [(at "deficit-text" clad)])
                    (format "{}" [(at "special-text" clad)])
                    (format "{}" [(at "lqboost-text" clad)])
                    (format "{}" [(at "fueling-text" clad)])
                    (format "Fitting Operation in a single TX is {} IGNIS cheaper" [100.0])
                ]
                [
                    (if (not asymmetric-collection)
                        (if iz-for-frozen
                            (format "Succesfully added Liquidity and generated {} Frozen LP." [secondary])
                            (format "Succesfully added Liquidity and generated {} Native LP and {} Frozen LP." [primary secondary])
                        )
                        (if iz-for-sleeping
                            (format "Succesfully added Liquidity and generated {} Sleeping LP" [primary])
                            (format "Succesfully added Liquidity and generated {} Native LP" [primary])
                        )
                    )
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron ifp)
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;
    ;;  [SIP|URC] - Simple Ignis Price >> dependent on a single trigger
    ;;
    (defun SIP|URC_Small:decimal ()
        @doc "<DPTF|C_Control> \
            \ <DPTF|C_DeployAccount> \
            \ <DPTF|C_SetFee> \
            \ <DPTF|C_SetFeeTarget> \
            \ <DPTF|C_SetMinMove> \
            \ <DPTF|C_ToggleFee> \
            \ <DPTF|C_ToggleFeeLock> \
            \ <DPMF|C_AddQuantity> \
            \ <DPMF|C_Burn> \
            \ <DPMF|C_DeployAccount>"
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (UC|GasPrice 
                (ref-DALOS::UR_UsagePrice "ignis|small")
                (ref-IGNIS::IC|URC_IsVirtualGasZero)
            )
        )
    )
    (defun SIP|URC_Medium ()
        @doc "<DPTF|C_TogglePause> \
            \ <DPTF|C_ToggleReservation>\
            \ <DPMF|C_Control> \
            \ <DPMF|C_Create>"
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (UC|GasPrice 
                (ref-DALOS::UR_UsagePrice "ignis|medium")
                (ref-IGNIS::IC|URC_IsVirtualGasZero)
            )
        )
    )
    (defun SIP|URC_Big:decimal ()
        @doc "<DPTF|C_RotateOwnership>"
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (UC|GasPrice 
                (ref-DALOS::UR_UsagePrice "ignis|big")
                (ref-IGNIS::IC|URC_IsVirtualGasZero)
            )
        )
    )
    (defun SIP|URC_Biggest ()
        @doc "<DPTF|C_ToggleFreezeAccount> \
            \ <DPTF|C_ToggleTransferRole> \
            \ <DPTF|C_Wipe> \
            \ <DPTF|C_WipePartial>"
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (UC|GasPrice 
                (ref-DALOS::UR_UsagePrice "ignis|biggest")
                (ref-IGNIS::IC|URC_IsVirtualGasZero)
            )
        )
    )
    (defun SIP|URC_UpdatePendingBranding:decimal (m:decimal)
        @doc "<DPTF|C_UpdatePendingBranding> >> m = 1"
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (UC|GasPrice 
                (* m (ref-DALOS::UR_UsagePrice "ignis|branding"))
                (ref-IGNIS::IC|URC_IsVirtualGasZero)
            )
        )
    )
    (defun SIP|URC_Burn:decimal (id:string account:string)
        @doc "<DPTF|C_Burn>"
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (UC|GasPrice 
                (ref-DALOS::UR_UsagePrice "ignis|small")
                (ref-IGNIS::IC|URC_ZeroGAS id account)
            )
        )
    )
    (defun SIP|URC_Issue:decimal (name:[string])
        @doc "<DPTF|C_Issue"
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (UC|GasPrice 
                (* (dec (length name)) (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                (ref-IGNIS::IC|URC_IsVirtualGasZero)
            )
        )
    )
    (defun SIP|URC_Mint:decimal (id:string account:string origin:bool)
        @doc "<DPTF|C_Mint>"
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (UC|GasPrice 
                (if origin (ref-DALOS::UR_UsagePrice "ignis|biggest") (ref-DALOS::UR_UsagePrice "ignis|small"))
                (ref-IGNIS::IC|URC_ZeroGAS id account)
            )
        )
    )
    ;;
    ;;  [SKP|URC] - Simple Kadena Price 
    ;;
    (defun SKP|URC_UpgradeBranding (months:integer)
        @doc "<DPTF|C_UpgradeBranding>"
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (blue:decimal (ref-DALOS::UR_UsagePrice "blue"))
            )
            (* (dec months) blue)
        )
    )
    (defun SKP|URC_Issue (name:[string] dptf-or-dpmf:bool)
        @doc "<DPTF|C_Issue> \
            \ <DPMF|C_Issue>"                
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (l1:integer (length name))
                (dptf:decimal (ref-DALOS::UR_UsagePrice "dptf"))
                (dpmf:decimal (ref-DALOS::UR_UsagePrice "dpmf"))
                (kfp:decimal (if dptf-or-dpmf dptf dpmf))
            )
            (UC|GasPrice
                (* (dec l1) kfp)
                (ref-IGNIS::IC|URC_IsNativeGasZero)
            )
        )
    )
    (defun SKP|URC_ToggleFeeLock (id:string toggle:bool fee-unlocks:integer)
        @doc "<DPTF|ToggleFeeLock>"
        (let
            (
                (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (prices:[decimal]
                    (if toggle
                        [0.0 0.0]
                        (ref-U|DPTF::UC_UnlockPrice fee-unlocks)
                    )
                )
            )
            (UC|GasPrice
                (at 1 prices)
                (ref-IGNIS::IC|URC_IsNativeGasZero)
            )
        )
    )
    ;;
    ;;  [INFO] - Informational URC Functions
    ;;
    ;;  [DPTF]
    (defun DPTF|INFO_UpdatePendingBranding:object{OuronetInfoV2.ClientInfo}
        (patron:string entity-id:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Update Pending Branding for {} DPTF" [entity-id])]
                [(format "Pending Branding for DPTF {} updated succesfully" [entity-id])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_UpdatePendingBranding 1.0))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_UpgradeBranding:object{OuronetInfoV2.ClientInfo}
        (patron:string entity-id:string months:integer)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Upgrade Branding for {} DPTF for {} month(s)" [entity-id months])]
                [(format "DPTF {} succesfully upgraded for {} months(s)!" [entity-id months])]
                (ref-I|OURONET::OI|UDC_NoIgnisCosts)
                (ref-I|OURONET::OI|UDC_DynamicKadenaCost patron (SKP|URC_UpgradeBranding months))
            )
        )
    )
    (defun DPTF|INFO_Burn:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string account:string amount:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Burn {} {} on Account {}" [amount id sa])]
                [(format "Succesfully burned {} {} on Account {}" [amount id sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Burn id account))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_Control:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Control DPTF {} Boolean Properties" [id])]
                [(format "Succesfully controlled Properties of {}" [id])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_DeployAccount:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string account:string)
        (let
            (
                
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Deploys a new {} DPTF Account." [id])
                    (format "Deploys Token {} on the Ouronet Account {}" [id sa])
                ]
                [(format "DPTF {} added to {} Ouronet Account succesfully!" [id sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_DonateFees:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount (ref-DALOS::GOV|DALOS|SC_NAME)))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Donates {} collected Fees" [id])
                    (format "Collection Location: Ouronet Gas Station: {}" [sa])
                ]
                [(format "Fee Collection succesfully set to {}" [sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_Issue:object{OuronetInfoV2.ClientInfo}
        (patron:string account:string name:[string])
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Issues {} DPTF(s)" [name])
                    (format "Also issues DPTF Accounts on {} Account" [sa])
                ]
                [(format "DPTF Issuance of {} succesfully completed" [name])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Issue name))
                (ref-I|OURONET::OI|UDC_DynamicKadenaCost patron (SKP|URC_Issue name true))
            )
        )
    )
    (defun DPTF|INFO_Mint:object{OuronetInfoV2.ClientInfo} 
        (patron:string id:string account:string amount:decimal origin:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (if origin
                        (format "Operation: Premine {} {} on Account {}" [amount id sa])
                        (format "Operation: Mint {} {} on Account {}" [amount id sa])
                    )
                ]
                [
                    (if origin
                        (format "Succesfully premined {} {} on Account {}" [amount id sa])
                        (format "Succesfully minted {} {} on Account {}" [amount id sa])
                    )
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Mint id account origin))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_ResetFeeTarget:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount (ref-DALOS::GOV|OUROBOROS|SC_NAME)))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Resets Collection of Fees for {}" [id])
                    (format "Collection Location: Ouroboros Smart Ouronet Account {}" [sa])
                ]
                [(format "Fee Collection succesfully set to {}" [sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_RotateOwnership:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string new-owner:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount new-owner))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Changes Ownership for {} to {}" [id sa])]
                [(format "ID {} Ownership succesfully set to {}" [id sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Medium))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_SetFee:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string fee:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Sets fee for {} to {} Promille" [id fee])]
                [(format "Fee Promille succesfully set to {} Promille for {}" [fee id])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_SetFeeTarget:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string target:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount target))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Sets fee target for {} to {} " [id sa])]
                [(format "Fee Target succesfully set for {} to {}" [id sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_SetMinMove:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string min-move-value:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Sets MinMove Value target for {} to {} " [id min-move-value])]
                [(format "MinMove Value succesfully set for {} to {}" [id min-move-value])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_ToggleFee:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string toggle:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (if toggle
                        (format "Operation: Activates Fee Collection for {}" [id])
                        (format "Operation: Deactivates Fee Collection for {}" [id])
                    )
                ]
                [
                    (if toggle
                        (format "Fee Collection activated succesfully for {}" [id])
                        (format "Fee Collection deactivated succesfully for {}" [id])
                    )
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_ToggleFeeLock:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string toggle:bool fee-unlocks:integer)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (if toggle
                        (format "Operation: Locks Fee Settings for {}" [id])
                        (format "Operation: Unlocks Fee Collection for {}" [id])
                    )
                ]
                [
                    (if toggle
                        (format "Fee Settings succesfully locked for {}" [id])
                        (format "Fee Settings succesfully unlocked  for {}" [id])
                    )
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_DynamicKadenaCost patron (SKP|URC_ToggleFeeLock id toggle fee-unlocks))
            )
        )
    )
    (defun DPTF|INFO_ToggleFreezeAccount:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string account:string toggle:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (if toggle
                        (format "Operation: Freezes ID {} on Account" [id sa])
                        (format "Operation: Unfreezes ID {} on Account" [id sa])
                    )
                ]
                [
                    (if toggle
                        (format "Account {} succesfully frozen for {}" [sa id])
                        (format "Account {} succesfuly unfrozen for {}" [sa id])
                    )
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Biggest))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_TogglePause:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string toggle:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (if toggle
                        (format "Operation: Pauses ID {}" [id])
                        (format "Operation: Unpauses ID {}" [id])
                    )
                ]
                [
                    (if toggle
                        (format "ID {} succesfully pauses" [id])
                        (format "ID {} succesfully unpauses" [id])
                    )
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Medium))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_ToggleReservation:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string toggle:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (if toggle
                        (format "Operation: Opens Reservations for {}" [id])
                        (format "Operation: Closes Reservations for {}" [id])
                    )
                ]
                [
                    (if toggle
                        (format "Reservations succesfully opened for {}" [id])
                        (format "Reservations succesfully closed for {}" [id])
                    )
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Medium))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_ToggleTransferRole:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string account:string toggle:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (if toggle
                        (format "Operation: Adds Transfer Role for {} to {}" [id sa])
                        (format "Operation: Removes Transfer Role for {} to {}" [id sa])
                    )
                ]
                [
                    (if toggle
                        (format "Transfer Role succesfuly added for {} to {}" [id sa])
                        (format "Transfer Role succesfuly removed for {} to {}" [id sa])
                    )
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Biggest))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_Wipe:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string atbw:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount atbw))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Wipes all {} from account {}" [id sa])]
                [(format "Succesfully wiped all {} from account {}" [id sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Biggest))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_WipePartial:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string atbw:string amtbw:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount atbw))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Wipes {} {} from account {}" [amtbw id sa])]
                [(format "Succesfully wiped {} {} from account {}" [amtbw id sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Biggest))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_Transfer:object{OuronetInfoV2.ClientInfo} 
        (patron:string id:string sender:string receiver:string transfer-amount:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                (ref-TFT:module{TrueFungibleTransferV7} TFT)
                ;;
                (what-type:integer (ref-TFT::URC_TransferClasses id sender receiver transfer-amount))
                (ico:object{IgnisCollector.OutputCumulator}
                    (ref-TFT::UC_TransferCumulator what-type id sender receiver)
                )
                (receiver-amount:decimal (ref-TFT::URC_ReceiverAmount id sender receiver transfer-amount))
                (ifp:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico))
                ;;
                (sa-s:string (ref-I|OURONET::OI|UC_ShortAccount sender))
                (sa-r:string (ref-I|OURONET::OI|UC_ShortAccount receiver))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Transfers {} {} from {} to {}" [transfer-amount id sa-s sa-r])
                    (if (= receiver-amount transfer-amount)
                        (format "Receiver will receiver the full amount of {} {}" [transfer-amount id])
                        (format "Due to Fee Settings, Receiver will receive only {} {}" [receiver-amount id])
                    )
                ]
                [
                    (if (= receiver-amount transfer-amount)
                        (format "Succesfully transfered {} {} from {} to {}, moving the Full Amount to the Receiver" [transfer-amount id sa-s sa-r])
                        (format "Succesfully transfered {} {} from {} to {}, moving only {} to the Receiver due to DPTF Fee Settings" [transfer-amount id sa-s sa-r receiver-amount])
                    )
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron ifp)
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_MultiTransfer:object{OuronetInfoV2.ClientInfo} 
        (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal])
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                (ref-TFT:module{TrueFungibleTransferV7} TFT)
                (ico:object{IgnisCollector.OutputCumulator}
                    (ref-TFT::UDC_MultiTransferCumulator id-lst sender receiver transfer-amount-lst)
                )
                (ifp:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico))
                ;;
                (sa-s:string (ref-I|OURONET::OI|UC_ShortAccount sender))
                (sa-r:string (ref-I|OURONET::OI|UC_ShortAccount receiver))

            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Transfers {} DPTFs as a Multi-Transfer" [(length id-lst)])
                    (format "DPTFs are: {}" [id-lst])
                    (format "Amounts are in their order: {}" [transfer-amount-lst])
                    (format "Movement occurs from {} to {}" [sa-s sa-r])
                ]
                [(format "Succesfully multi-transfered {} DPTFs from {} to {}" [(length id-lst) sa-s sa-r])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron ifp)
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_BulkTransfer:object{OuronetInfoV2.ClientInfo} 
        (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                (ref-TFT:module{TrueFungibleTransferV7} TFT)
                ;;
                (ico:object{IgnisCollector.OutputCumulator}
                    (ref-TFT::UDC_BulkTransferCumulator id sender receiver-lst transfer-amount-lst)
                )
                (ifp:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico))
                (sa-s:string (ref-I|OURONET::OI|UC_ShortAccount sender))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Transfers {} DPTF in Bulk" [id])
                    (format "Bulk Transfer means from one Sender, {} to multiple receivers" [sa-s])
                ]
                [(format "Succesfully bulk-transfered {} DPTF from {} to {} Receivers" [id sa-s (length receiver-lst)])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron ifp)
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_MultiBulkTransfer:object{OuronetInfoV2.ClientInfo} 
        (patron:string id-lst:[string] sender:string receiver-array:[[string]] transfer-amount-array:[[decimal]])
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                (ref-TFT:module{TrueFungibleTransferV7} TFT)
                ;;
                (ico:object{IgnisCollector.OutputCumulator}
                    (ref-TFT::UDC_MultiBulkTransferCumulator id-lst sender receiver-array transfer-amount-array)
                )
                (ifp:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico))
                (sa-s:string (ref-I|OURONET::OI|UC_ShortAccount sender))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Transfers {} DPTFs in Bulk at once" [(length id-lst)])
                    (format "Transfer occurs from Sender, {} to multiple receivers, specific for each DPTF" [sa-s])
                    (format "Bulk Transfer DPTFs are {}" [id-lst])
                ]
                [(format "Succesfully multi-bulk-transfered {} DPTFs from Sender {} to {} Individual Receiver Lists" [(length id-lst) sa-s (length receiver-array)])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron ifp)
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    ;;  [DPMF]
    (defun DPMF|INFO_UpdatePendingBranding:object{OuronetInfoV2.ClientInfo}
        (patron:string entity-id:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Update Pending Branding for {} DPMF" [entity-id])]
                [(format "Pending Branding for DPMF {} updated succesfully" [entity-id])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_UpdatePendingBranding 1.5))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPMF|INFO_UpgradeBranding:object{OuronetInfoV2.ClientInfo}
        (patron:string entity-id:string months:integer)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Upgrade Branding for {} DPMF for {} month(s)" [entity-id months])]
                [(format "DPMF {} succesfully upgraded for {} months(s)!" [entity-id months])]
                (ref-I|OURONET::OI|UDC_NoIgnisCosts)
                (ref-I|OURONET::OI|OI|UDC_DynamicKadenaCost patron (SKP|URC_UpgradeBranding months))
            )
        )
    )
    (defun DPMF|INFO_AddQuantity:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string nonce:integer account:string amount:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Adds {} to DPMF {} Nonce {} on Account {}" [amount id nonce sa])]
                [(format "Succesfully increased DPMF {} nonce {} quantity on Account {} by {}" [id nonce sa amount])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPMF|INFO_Burn:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string nonce:integer account:string amount:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Burns {} Units of DPMF {} Nonce {} on Account {}" [amount id nonce sa])]
                [(format "Succesfully burned {} Units of DPMF {} Nonce {} on Account {}" [amount id nonce sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPMF|INFO_Control:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Controls DPMF {} Boolean Properties" [id])]
                [(format "Succesfully controlled DPMF {} Boolean Properties" [id])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Medium))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPMF|INFO_Create:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string account:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Creates a new Batch for the DPMF {} without quantity on Account {}" [id sa])]
                [(format "Succesfully created a new Batch for DPMF {} on Account {}" [id sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Medium))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPMF|INFO_DeployAccount:object{OuronetInfoV2.ClientInfo}
        (patron:string id:string account:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Deploy a DPMF Account for DPMF {} on Ouronet Account {}" [id sa])]
                [(format "Succesfully deployed a New DPMF Account for DPMF {} on Ouronet Account {}" [id sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPMF|INFO_Issue:object{OuronetInfoV2.ClientInfo}
        (patron:string account:string name:[string])
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Issues {} DPMF(s)" [name])
                    (format "Also issues DPTF Accounts on {} Account" [sa])
                ]
                [(format "DPMF Issuance of {} succesfully completed" [name])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Issue name))
                (ref-I|OURONET::OI|UDC_DynamicKadenaCost patron (SKP|URC_Issue name false))
            )
        )
    )
    (defun DPMF|INFO_Mint:object{OuronetInfoV2.ClientInfo} 
        (patron:string id:string account:string amount:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                ;;
                (small:decimal (SIP|URC_Small))
                (medium:decimal (SIP|URC_Medium))
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Mint {} {} on Account {}, on a new Nonce" [amount id sa])]
                [(format "Succesfully minted {} {} on Account {}, on a new Nonce" [amount id sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (+ small medium))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    ;;  [ATS]
    (defun ATS|INFO_Coil:object{OuronetInfoV2.ClientInfo}
        (patron:string coiler:string ats:string rt:string amount:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                (ref-ATS:module{AutostakeV4} ATS)
                (ref-TFT:module{TrueFungibleTransferV7} TFT)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                (c-rbt-amount:decimal (ref-ATS::URC_RBT ats rt amount))
                ;;
                ;;Operation 1 - Transfer
                (wt1:integer (ref-TFT::URC_TransferClasses rt coiler ats-sc amount))
                (ico1:object{IgnisCollector.OutputCumulator}
                    (ref-TFT::UC_TransferCumulator wt1 rt coiler ats-sc)
                )
                (ifp1:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico1))
                ;;Operation 2 - Mint
                (ifp2:decimal (SIP|URC_Mint c-rbt ats-sc false))
                ;;Operation 3 - Transfer
                (wt3:integer (ref-TFT::URC_TransferClasses c-rbt ats-sc coiler c-rbt-amount))
                (ico3:object{IgnisCollector.OutputCumulator}
                    (ref-TFT::UC_TransferCumulator wt3 rt coiler ats-sc)
                )
                (ifp3:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico3))
                (ifp:decimal (fold (+) 0.0 [ifp1 ifp2 ifp3]))
                ;;
                (sa-coiler:string (ref-I|OURONET::OI|UC_ShortAccount coiler))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Coils (autostakes) {} on the {} ATS-Pair" [rt ats])
                    (format "Generates {} {}" [c-rbt-amount c-rbt])
                ]
                [
                    (format "Succesfuly autostaked {} {} on ATS-Pair {} generating {} {} on {} Account" [amount rt ats c-rbt-amount c-rbt sa-coiler])
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron ifp)
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    ;;  [SWP]
    (defun SWP|INFO_AddLiquidity:object{OuronetInfoV2.ClientInfo}
        (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UCX_AddLiquidity patron account swpair input-amounts true true kda-pid)
    )
    (defun SWP|INFO_IcedLiquidity:object{OuronetInfoV2.ClientInfo}
        (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UCX_AddLiquidity patron account swpair input-amounts false true kda-pid)
    )
    (defun SWP|INFO_GlacialLiquidity:object{OuronetInfoV2.ClientInfo}
        (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UCX_AddLiquidity patron account swpair input-amounts false false kda-pid)
    )
    (defun SWP|INFO_FrozenLiquidity:object{OuronetInfoV2.ClientInfo}
        (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal kda-pid:decimal)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPL:module{SwapperLiquidity} SWPL)
                ;;
                (dptf:string (ref-DPTF::UR_Frozen frozen-dptf))
                (ptp:integer (ref-SWP::UR_PoolTokenPosition swpair dptf))
                (lq-lst:[decimal] (ref-U|SWP::UC_MakeLiquidityList swpair ptp input-amount))
                (ld:object{SwapperLiquidity.LiquidityData}
                    (ref-SWPL::URC_LD swpair lq-lst)
                )
                ;;
                ;;Compute Liquidity Addition Data
                (clad:object{SwapperLiquidity.CompleteLiquidityAdditionData}
                    (ref-SWPL::URC|KDA-PID_CLAD account swpair ld false false kda-pid)
                )
                (ifp:decimal 
                    (ref-I|OURONET::OI|UC_IfpFromOutputCumulator 
                        (at "perfect-ignis-fee" (at "clad-op" clad))
                    )
                )
            )
            (UCXX_AddLiquidityClientInfo patron ifp swpair (ref-DALOS::UR_IgnisID) clad false false true)
        )
    )
    (defun SWP|INFO_SleepingLiquidity:object{OuronetInfoV2.ClientInfo}
        (patron:string account:string swpair:string sleeping-dpmf:string nonce:integer kda-pid:decimal)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV5} DPMF)
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPL:module{SwapperLiquidity} SWPL)
                ;;
                (dptf:string (ref-DPMF::UR_Sleeping sleeping-dpmf))
                (ptp:integer (ref-SWP::UR_PoolTokenPosition swpair dptf))
                (batch-amount:decimal (ref-DPMF::UR_AccountNonceBalance sleeping-dpmf nonce account))
                (lq-lst:[decimal] (ref-U|SWP::UC_MakeLiquidityList swpair ptp batch-amount))
                (ld:object{SwapperLiquidity.LiquidityData}
                    (ref-SWPL::URC_LD swpair lq-lst)
                )
                ;;
                ;;Compute Liquidity Addition Data
                (clad:object{SwapperLiquidity.CompleteLiquidityAdditionData}
                    (ref-SWPL::URC|KDA-PID_CLAD account swpair ld true true kda-pid)
                )
                (ifp:decimal 
                    (ref-I|OURONET::OI|UC_IfpFromOutputCumulator 
                        (at "perfect-ignis-fee" (at "clad-op" clad))
                    )
                )
            )
            (UCXX_AddLiquidityClientInfo patron ifp swpair (ref-DALOS::UR_IgnisID) clad true true false)
        )
    )
    ;;
    
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)