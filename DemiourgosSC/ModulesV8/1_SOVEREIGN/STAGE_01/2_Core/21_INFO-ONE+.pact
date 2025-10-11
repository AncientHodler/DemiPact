(interface InfoOneV4
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
    (defun SKP|URC_Issue (name:[string] dptf-or-dpof:bool))
    (defun SKP|URC_ToggleFeeLock (id:string toggle:bool fee-unlocks:integer))
    ;;
    ;;
    ;;  [INFO] Functions
    ;;
    (defun DPTF|INFO_UpdatePendingBranding:object{OuronetInfoV3.ClientInfo} (patron:string entity-id:string))
    (defun DPTF|INFO_UpgradeBranding:object{OuronetInfoV3.ClientInfo} (patron:string entity-id:string months:integer))
    (defun DPTF|INFO_Burn:object{OuronetInfoV3.ClientInfo} (patron:string id:string account:string amount:decimal))
    (defun DPTF|INFO_Control:object{OuronetInfoV3.ClientInfo} (patron:string id:string))
    (defun DPTF|INFO_DeployAccount:object{OuronetInfoV3.ClientInfo} (patron:string id:string account:string))
    (defun DPTF|INFO_DonateFees:object{OuronetInfoV3.ClientInfo} (patron:string id:string))
    (defun DPTF|INFO_Issue:object{OuronetInfoV3.ClientInfo} (patron:string account:string name:[string]))
    (defun DPTF|INFO_Mint:object{OuronetInfoV3.ClientInfo} (patron:string id:string account:string amount:decimal origin:bool))
    (defun DPTF|INFO_ResetFeeTarget:object{OuronetInfoV3.ClientInfo} (patron:string id:string))
    (defun DPTF|INFO_RotateOwnership:object{OuronetInfoV3.ClientInfo} (patron:string id:string new-owner:string))
    (defun DPTF|INFO_SetFee:object{OuronetInfoV3.ClientInfo} (patron:string id:string fee:decimal))
    (defun DPTF|INFO_SetFeeTarget:object{OuronetInfoV3.ClientInfo} (patron:string id:string target:string))
    (defun DPTF|INFO_SetMinMove:object{OuronetInfoV3.ClientInfo} (patron:string id:string min-move-value:decimal))
    (defun DPTF|INFO_ToggleFee:object{OuronetInfoV3.ClientInfo} (patron:string id:string toggle:bool))
    (defun DPTF|INFO_ToggleFeeLock:object{OuronetInfoV3.ClientInfo} (patron:string id:string toggle:bool fee-unlocks:integer))
    (defun DPTF|INFO_ToggleFreezeAccount:object{OuronetInfoV3.ClientInfo} (patron:string id:string account:string toggle:bool))
    (defun DPTF|INFO_TogglePause:object{OuronetInfoV3.ClientInfo} (patron:string id:string toggle:bool))
    (defun DPTF|INFO_ToggleReservation:object{OuronetInfoV3.ClientInfo} (patron:string id:string toggle:bool))
    (defun DPTF|INFO_ToggleTransferRole:object{OuronetInfoV3.ClientInfo} (patron:string id:string account:string toggle:bool))
    (defun DPTF|INFO_Wipe:object{OuronetInfoV3.ClientInfo} (patron:string id:string atbw:string))
    (defun DPTF|INFO_WipePartial:object{OuronetInfoV3.ClientInfo} (patron:string id:string atbw:string amtbw:decimal))
    (defun DPTF|INFO_Transfer:object{OuronetInfoV3.ClientInfo} (patron:string id:string sender:string receiver:string transfer-amount:decimal))
    (defun DPTF|INFO_MultiTransfer:object{OuronetInfoV3.ClientInfo} (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal]))
    (defun DPTF|INFO_BulkTransfer:object{OuronetInfoV3.ClientInfo} (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal]))
    (defun DPTF|INFO_MultiBulkTransfer:object{OuronetInfoV3.ClientInfo} (patron:string id-lst:[string] sender:string receiver-array:[[string]] transfer-amount-array:[[decimal]]))
    ;;
    (defun DPOF|INFO_UpdatePendingBranding:object{OuronetInfoV3.ClientInfo} (patron:string entity-id:string))
    (defun DPOF|INFO_UpgradeBranding:object{OuronetInfoV3.ClientInfo} (patron:string entity-id:string months:integer))
    (defun DPOF|INFO_AddQuantity:object{OuronetInfoV3.ClientInfo} (patron:string id:string nonce:integer account:string amount:decimal))
    (defun DPOF|INFO_Burn:object{OuronetInfoV3.ClientInfo} (patron:string id:string nonce:integer account:string amount:decimal))
    (defun DPOF|INFO_Control:object{OuronetInfoV3.ClientInfo} (patron:string id:string))
    (defun DPOF|INFO_Create:object{OuronetInfoV3.ClientInfo} (patron:string id:string account:string))
    (defun DPOF|INFO_DeployAccount:object{OuronetInfoV3.ClientInfo} (patron:string id:string account:string))
    (defun DPOF|INFO_Issue:object{OuronetInfoV3.ClientInfo} (patron:string account:string name:[string]))
    (defun DPOF|INFO_Mint:object{OuronetInfoV3.ClientInfo} (patron:string id:string account:string amount:decimal))
    ;;
    (defun VST|INFO_Hibernate:object{OuronetInfoV3.ClientInfo} (patron:string hibernator:string target-account:string dptf:string amount:decimal dayz:integer))
    ;;
    (defun ATS|INFO_Coil:object{OuronetInfoV3.ClientInfo} (patron:string coiler:string ats:string rt:string amount:decimal))
    (defun ATS|INFO_Constrict:object{OuronetInfoV3.ClientInfo}(patron:string constricter:string ats:string rt:string amount:decimal dayz:integer))
    (defun ATS|INFO_Curl:object{OuronetInfoV3.ClientInfo} (patron:string curler:string ats1:string ats2:string rt:string amount:decimal))
    (defun ATS|INFO_Brumate:object{OuronetInfoV3.ClientInfo} (patron:string brumator:string ats1:string ats2:string rt:string amount:decimal dayz:integer))
    (defun ATS|INFO_ColdRecovery:object{OuronetInfoV3.ClientInfo} (patron:string recoverer:string ats:string ra:decimal))
    (defun ATS|INFO_Cull:object{OuronetInfoV3.ClientInfo} (patron:string culler:string ats:string))
    (defun ATS|INFO_DirectRecovery:object{OuronetInfoV3.ClientInfo} (patron:string recoverer:string ats:string ra:decimal))
    ;;
    (defun SWP|INFO_AddLiquidity:object{OuronetInfoV3.ClientInfo} (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun SWP|INFO_IcedLiquidity:object{OuronetInfoV3.ClientInfo} (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun SWP|INFO_GlacialLiquidity:object{OuronetInfoV3.ClientInfo} (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal))
    (defun SWP|INFO_FrozenLiquidity:object{OuronetInfoV3.ClientInfo} (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal kda-pid:decimal))
    (defun SWP|INFO_SleepingLiquidity:object{OuronetInfoV3.ClientInfo} (patron:string account:string swpair:string sleeping-dpof:string nonce:integer kda-pid:decimal))
)
(module INFO-ONE GOV
    ;;
    (implements InfoOneV4)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_INFO|DPTF      (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|INFO|DPTF_ADMIN)))
    (defcap GOV|INFO|DPTF_ADMIN ()  (enforce-guard GOV|MD_INFO|DPTF))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
    (defun CT_EmptyCumulator ()     (let ((ref-IGNIS:module{IgnisCollectorV2} IGNIS)) (ref-IGNIS::DALOS|EmptyOutputCumulatorV2)))
    (defun GOV|SWP|SC_NAME ()       (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|SWP|SC_NAME)))
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
    (defun UCX_AddLiquidity:object{OuronetInfoV3.ClientInfo} 
        (
            patron:string account:string swpair:string input-amounts:[decimal]
            asymmetric-collection:bool gaseous-collection:bool kda-pid:decimal
        )
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-SWPL:module{SwapperLiquidityV2} SWPL)
                (ld:object{SwapperLiquidityV2.LiquidityData}
                    (ref-SWPL::URC_LD swpair input-amounts)
                )
                ;;
                ;;Compute Liquidity Addition Data
                (clad:object{SwapperLiquidityV2.CompleteLiquidityAdditionData}
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
            clad:object{SwapperLiquidityV2.CompleteLiquidityAdditionData}
            asymmetric-collection:bool iz-for-sleeping:bool iz-for-frozen:bool
        )
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
            \ <DPOF|C_AddQuantity> \
            \ <DPOF|C_Burn> \
            \ <DPOF|C_DeployAccount>"
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
            )
            (UC|GasPrice 
                (ref-DALOS::UR_UsagePrice "ignis|small")
                (ref-IGNIS::URC_IsVirtualGasZero)
            )
        )
    )
    (defun SIP|URC_Medium ()
        @doc "<DPTF|C_TogglePause> \
            \ <DPTF|C_ToggleReservation>\
            \ <DPOF|C_Control> \
            \ <DPOF|C_Mint>"
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
            )
            (UC|GasPrice 
                (ref-DALOS::UR_UsagePrice "ignis|medium")
                (ref-IGNIS::URC_IsVirtualGasZero)
            )
        )
    )
    (defun SIP|URC_Big:decimal ()
        @doc "<DPTF|C_RotateOwnership>"
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
            )
            (UC|GasPrice 
                (ref-DALOS::UR_UsagePrice "ignis|big")
                (ref-IGNIS::URC_IsVirtualGasZero)
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
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
            )
            (UC|GasPrice 
                (ref-DALOS::UR_UsagePrice "ignis|biggest")
                (ref-IGNIS::URC_IsVirtualGasZero)
            )
        )
    )
    (defun SIP|URC_UpdatePendingBranding:decimal (m:decimal)
        @doc "<DPTF|C_UpdatePendingBranding> >> m = 1"
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
            )
            (UC|GasPrice 
                (* m (ref-DALOS::UR_UsagePrice "ignis|branding"))
                (ref-IGNIS::URC_IsVirtualGasZero)
            )
        )
    )
    (defun SIP|URC_Burn:decimal (id:string account:string)
        @doc "<DPTF|C_Burn>"
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
            )
            (UC|GasPrice 
                (ref-DALOS::UR_UsagePrice "ignis|small")
                (ref-IGNIS::URC_ZeroGAS id account)
            )
        )
    )
    (defun SIP|URC_Issue:decimal (name:[string])
        @doc "<DPTF|C_Issue"
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
            )
            (UC|GasPrice 
                (* (dec (length name)) (ref-DALOS::UR_UsagePrice "ignis|token-issue"))
                (ref-IGNIS::URC_IsVirtualGasZero)
            )
        )
    )
    (defun SIP|URC_Mint:decimal (id:string account:string origin:bool)
        @doc "<DPTF|C_Mint>"
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
            )
            (UC|GasPrice 
                (if origin (ref-DALOS::UR_UsagePrice "ignis|biggest") (ref-DALOS::UR_UsagePrice "ignis|small"))
                (ref-IGNIS::URC_ZeroGAS id account)
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
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (blue:decimal (ref-DALOS::UR_UsagePrice "blue"))
            )
            (* (dec months) blue)
        )
    )
    (defun SKP|URC_Issue (name:[string] dptf-or-dpof:bool)
        @doc "<DPTF|C_Issue> \
            \ <DPOF|C_Issue>"                
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (l1:integer (length name))
                (dptf:decimal (ref-DALOS::UR_UsagePrice "dptf"))
                (dpof:decimal (ref-DALOS::UR_UsagePrice "dpmf"))
                (kfp:decimal (if dptf-or-dpof dptf dpof))
            )
            (UC|GasPrice
                (* (dec l1) kfp)
                (ref-IGNIS::URC_IsNativeGasZero)
            )
        )
    )
    (defun SKP|URC_ToggleFeeLock (id:string toggle:bool fee-unlocks:integer)
        @doc "<DPTF|ToggleFeeLock>"
        (let
            (
                (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (prices:[decimal]
                    (if toggle
                        [0.0 0.0]
                        (ref-U|DPTF::UC_UnlockPrice fee-unlocks)
                    )
                )
            )
            (UC|GasPrice
                (at 1 prices)
                (ref-IGNIS::URC_IsNativeGasZero)
            )
        )
    )
    ;;
    ;;  [INFO] - Informational URC Functions
    ;;
    ;;  [DPTF]
    (defun DPTF|INFO_UpdatePendingBranding:object{OuronetInfoV3.ClientInfo}
        (patron:string entity-id:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Update Pending Branding for {} DPTF" [entity-id])]
                [(format "Pending Branding for DPTF {} updated succesfully" [entity-id])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_UpdatePendingBranding 1.0))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_UpgradeBranding:object{OuronetInfoV3.ClientInfo}
        (patron:string entity-id:string months:integer)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Upgrade Branding for {} DPTF for {} month(s)" [entity-id months])]
                [(format "DPTF {} succesfully upgraded for {} months(s)!" [entity-id months])]
                (ref-I|OURONET::OI|UDC_NoIgnisCosts)
                (ref-I|OURONET::OI|UDC_DynamicKadenaCost patron (SKP|URC_UpgradeBranding months))
            )
        )
    )
    (defun DPTF|INFO_Burn:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string account:string amount:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_Control:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Control DPTF {} Boolean Properties" [id])]
                [(format "Succesfully controlled Properties of {}" [id])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_DeployAccount:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string account:string)
        (let
            (
                
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_DonateFees:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_Issue:object{OuronetInfoV3.ClientInfo}
        (patron:string account:string name:[string])
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_Mint:object{OuronetInfoV3.ClientInfo} 
        (patron:string id:string account:string amount:decimal origin:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_ResetFeeTarget:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_RotateOwnership:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string new-owner:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_SetFee:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string fee:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Sets fee for {} to {} Promille" [id fee])]
                [(format "Fee Promille succesfully set to {} Promille for {}" [fee id])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_SetFeeTarget:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string target:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_SetMinMove:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string min-move-value:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Sets MinMove Value target for {} to {} " [id min-move-value])]
                [(format "MinMove Value succesfully set for {} to {}" [id min-move-value])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|INFO_ToggleFee:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string toggle:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_ToggleFeeLock:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string toggle:bool fee-unlocks:integer)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_ToggleFreezeAccount:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string account:string toggle:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_TogglePause:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string toggle:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_ToggleReservation:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string toggle:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_ToggleTransferRole:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string account:string toggle:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_Wipe:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string atbw:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_WipePartial:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string atbw:string amtbw:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
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
    (defun DPTF|INFO_Transfer:object{OuronetInfoV3.ClientInfo} 
        (patron:string id:string sender:string receiver:string transfer-amount:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                ;;
                (what-type:integer (at "type" (ref-TFT::URC_TransferClasses id sender receiver transfer-amount)))
                (ico:object{IgnisCollectorV2.OutputCumulator}
                    (ref-TFT::UDC_TransferCumulator what-type id sender receiver)
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
    (defun DPTF|INFO_MultiTransfer:object{OuronetInfoV3.ClientInfo} 
        (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal])
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                (ico:object{IgnisCollectorV2.OutputCumulator}
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
    (defun DPTF|INFO_BulkTransfer:object{OuronetInfoV3.ClientInfo} 
        (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                ;;
                (ico:object{IgnisCollectorV2.OutputCumulator}
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
    (defun DPTF|INFO_MultiBulkTransfer:object{OuronetInfoV3.ClientInfo} 
        (patron:string id-lst:[string] sender:string receiver-array:[[string]] transfer-amount-array:[[decimal]])
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                ;;
                (ico:object{IgnisCollectorV2.OutputCumulator}
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
    ;;  [DPOF]
    (defun DPOF|INFO_UpdatePendingBranding:object{OuronetInfoV3.ClientInfo}
        (patron:string entity-id:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Update Pending Branding for {} DPOF" [entity-id])]
                [(format "Pending Branding for DPOF {} updated succesfully" [entity-id])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_UpdatePendingBranding 1.5))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPOF|INFO_UpgradeBranding:object{OuronetInfoV3.ClientInfo}
        (patron:string entity-id:string months:integer)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Upgrade Branding for {} DPOF for {} month(s)" [entity-id months])]
                [(format "DPOF {} succesfully upgraded for {} months(s)!" [entity-id months])]
                (ref-I|OURONET::OI|UDC_NoIgnisCosts)
                (ref-I|OURONET::OI|OI|UDC_DynamicKadenaCost patron (SKP|URC_UpgradeBranding months))
            )
        )
    )
    (defun DPOF|INFO_AddQuantity:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string nonce:integer account:string amount:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Adds {} to DPOF {} Nonce {} on Account {}" [amount id nonce sa])]
                [(format "Succesfully increased DPOF {} nonce {} quantity on Account {} by {}" [id nonce sa amount])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPOF|INFO_Burn:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string nonce:integer account:string amount:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Burns {} Units of DPOF {} Nonce {} on Account {}" [amount id nonce sa])]
                [(format "Succesfully burned {} Units of DPOF {} Nonce {} on Account {}" [amount id nonce sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPOF|INFO_Control:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Controls DPOF {} Boolean Properties" [id])]
                [(format "Succesfully controlled DPOF {} Boolean Properties" [id])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Medium))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPOF|INFO_Create:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string account:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Creates a new Batch for the DPOF {} without quantity on Account {}" [id sa])]
                [(format "Succesfully created a new Batch for DPOF {} on Account {}" [id sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Medium))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPOF|INFO_DeployAccount:object{OuronetInfoV3.ClientInfo}
        (patron:string id:string account:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Deploy a DPOF Account for DPOF {} on Ouronet Account {}" [id sa])]
                [(format "Succesfully deployed a New DPOF Account for DPOF {} on Ouronet Account {}" [id sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPOF|INFO_Issue:object{OuronetInfoV3.ClientInfo}
        (patron:string account:string name:[string])
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Issues {} DPOF(s)" [name])
                    (format "Also issues DPTF Accounts on {} Account" [sa])
                ]
                [(format "DPOF Issuance of {} succesfully completed" [name])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Issue name))
                (ref-I|OURONET::OI|UDC_DynamicKadenaCost patron (SKP|URC_Issue name false))
            )
        )
    )
    (defun DPOF|INFO_Mint:object{OuronetInfoV3.ClientInfo} 
        (patron:string id:string account:string amount:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                ;;
                (medium:decimal (SIP|URC_Medium))
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Mint {} {} on Account {}, on a new Nonce" [amount id sa])]
                [(format "Succesfully minted {} {} on Account {}, on a new Nonce" [amount id sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron medium)
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    ;;  [ATS]
    (defun VST|INFO_Hibernate:object{OuronetInfoV3.ClientInfo}
        (patron:string hibernator:string target-account:string dptf:string amount:decimal dayz:integer)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                (ref-VST:module{VestingV5} VST)
                (vst-sc:string (ref-VST::GOV|VST|SC_NAME))
                ;;
                ;;Operation 1 Mint DPOF
                (ifp1:decimal (SIP|URC_Medium))
                ;;Operation 2 Transfer DPTF
                (wt2:integer (at "type" (ref-TFT::URC_TransferClasses dptf hibernator vst-sc amount)))
                (ico2:object{IgnisCollectorV2.OutputCumulator}
                    (ref-TFT::UDC_TransferCumulator wt2 dptf hibernator vst-sc)
                )
                (ifp2:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico2))
                ;;Operation 3 Transfer DPOF
                (ifp3:decimal (SIP|URC_Small))
                (ifp:decimal (fold (+) 0.0 [ifp1 ifp2 ifp3]))
                ;;
                (sa-hibernator:string (ref-I|OURONET::OI|UC_ShortAccount hibernator))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Hibernates {} {} for {} Days" [amount dptf dayz])
                ]
                [
                    (format "Sucesfully hibernated {} {} on Account {} for a Duration of {} days." [amount dptf sa-hibernator dayz])
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron ifp)
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun ATS|INFO_Coil:object{OuronetInfoV3.ClientInfo}
        (patron:string coiler:string ats:string rt:string amount:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-ATS:module{AutostakeV6} ATS)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                ;;
                (coil-data:object{AutostakeV6.CoilData}
                    (ref-ATS::URC_RewardBearingTokenAmounts ats rt amount)
                )
                (input-amount:decimal (at "first-input-amount" coil-data))
                (royalty-fee:decimal (at "royalty-fee" coil-data))
                (c-rbt:string (at "rbt-id" coil-data))
                (c-rbt-amount (at "rbt-amount" coil-data))
                ;;
                ;;Operation 1 - Transfer
                (wt1:integer (at "type" (ref-TFT::URC_TransferClasses rt coiler ats-sc amount)))
                (ico1:object{IgnisCollectorV2.OutputCumulator}
                    (ref-TFT::UDC_TransferCumulator wt1 rt coiler ats-sc)
                )
                (ifp1:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico1))
                ;;Operation 2 - Mint
                (ifp2:decimal (SIP|URC_Mint c-rbt ats-sc false))
                ;;Operation 3 - Transfer
                (wt3:integer (at "type" (ref-TFT::URC_TransferClasses c-rbt ats-sc coiler c-rbt-amount)))
                (ico3:object{IgnisCollectorV2.OutputCumulator}
                    (ref-TFT::UDC_TransferCumulator wt3 rt coiler ats-sc)
                )
                (ifp3:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico3))
                (ifp:decimal (fold (+) 0.0 [ifp1 ifp2 ifp3]))
                ;;
                (sa-coiler:string (ref-I|OURONET::OI|UC_ShortAccount coiler))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    ;;<ATS1>
                    (format "Operation: Autostakes {} {} on the {} ATS-Pair." [amount rt ats])
                    (if (= royalty-fee 0.0)
                        (format "Deposit will be executed without any {} Royalty." [rt])
                        (format "{} {} will be retained as Royalty on the Autostake Pool." [royalty-fee rt])
                    )
                    (format "Coil will generate {} {} as final output." [c-rbt-amount c-rbt])
                ]
                [
                    (format "Succesfully coiled {} {} on ATS-Pair {} generating {} {} on {} Account." [amount rt ats c-rbt-amount c-rbt sa-coiler])
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron ifp)
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun ATS|INFO_Constrict:object{OuronetInfoV3.ClientInfo}
        (patron:string constricter:string ats:string rt:string amount:decimal dayz:integer)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-ATS:module{AutostakeV6} ATS)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                ;;
                (coil-data:object{AutostakeV6.CoilData} 
                    (ref-ATS::URC_RewardBearingTokenAmountsWithHibernation ats rt amount dayz)
                )
                (input-amount:decimal (at "first-input-amount" coil-data))
                (royalty-fee:decimal (at "royalty-fee" coil-data))
                (c-rbt:string (at "rbt-id" coil-data))
                (c-rbt-amount (at "rbt-amount" coil-data))
                ;;
                (peak:decimal (ref-ATS::UR_PeakHibernatePromile ats))
                (decay:decimal (ref-ATS::UR_HibernateDecay ats))
                (dec-dayz:decimal (dec dayz))
                (v1:decimal (* dec-dayz decay))
                (v2:decimal (- peak v1))
                (fee-promile:decimal 
                    (if (<= v2 0.0)
                        0.0
                        v2
                    )
                )
                (hibernate-entry-percent:string (format "{}%" [(/ fee-promile 10.0)]))
                ;;
                ;;Operation 1 - Transfer
                (wt1:integer (at "type" (ref-TFT::URC_TransferClasses rt constricter ats-sc amount)))
                (ico1:object{IgnisCollectorV2.OutputCumulator}
                    (ref-TFT::UDC_TransferCumulator wt1 rt constricter ats-sc)
                )
                (ifp1:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico1))
                ;;Operation 2 - Mint
                (ifp2:decimal (SIP|URC_Mint c-rbt ats-sc false))
                ;;Operation 3 - Hibernate
                (ifp3:decimal (at "ignis-full" (at "ignis" (VST|INFO_Hibernate patron ats-sc constricter c-rbt c-rbt-amount dayz))))
                (ifp:decimal (fold (+) 0.0 [ifp1 ifp2 ifp3]))
                ;;
                (sa-constricter:string (ref-I|OURONET::OI|UC_ShortAccount constricter))
                (ht:string (ref-DPTF::UR_Hibernation c-rbt))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    ;;<ATS1>
                    (format "Operation: Autostakes {} {} on the {} ATS-Pair." [amount rt ats])
                    (if (= royalty-fee 0.0)
                        (format "Deposit will be executed without any {} Royalty." [rt])
                        (format "{} {} will be retained as Royalty on the Autostake Pool." [royalty-fee rt])
                    )
                    (format "Constricting for {} Days will incurr a hibernation fee of {} on the Input {} after Royalty" [dayz hibernate-entry-percent c-rbt])
                    (format "Constricting will generate {} {} as final output." [c-rbt-amount ht])
                ]
                [
                    (format "Succesfully constricted {} {} on ATS-Pair {} generating {} {} on {} Account." [amount rt ats c-rbt-amount ht sa-constricter])
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron ifp)
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun ATS|INFO_Curl:object{OuronetInfoV3.ClientInfo}
        (patron:string curler:string ats1:string ats2:string rt:string amount:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-ATS:module{AutostakeV6} ATS)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                ;;
                ;;<ats1>
                (coil1-data:object{AutostakeV6.CoilData} 
                    (ref-ATS::URC_RewardBearingTokenAmounts ats1 rt amount)
                )
                (input1-amount:decimal (at "first-input-amount" coil1-data))
                (royalty1-fee:decimal (at "royalty-fee" coil1-data))
                (c-rbt1:string (at "rbt-id" coil1-data))
                (c-rbt1-amount (at "rbt-amount" coil1-data))
                ;;
                ;;<ats2>
                (coil2-data:object{AutostakeV6.CoilData} 
                    (ref-ATS::URC_RewardBearingTokenAmounts ats2 c-rbt1 c-rbt1-amount)
                )
                (input2-amount:decimal (at "first-input-amount" coil2-data))
                (royalty2-fee:decimal (at "royalty-fee" coil2-data))
                (c-rbt2:string (at "rbt-id" coil2-data))
                (c-rbt2-amount (at "rbt-amount" coil2-data))
                ;;
                ;;Operation 1 - Transfer
                (wt1:integer (at "type" (ref-TFT::URC_TransferClasses rt curler ats-sc amount)))
                (ico1:object{IgnisCollectorV2.OutputCumulator}
                    (ref-TFT::UDC_TransferCumulator wt1 rt curler ats-sc)
                )
                (ifp1:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico1))
                ;;Operation 2 - Mint
                (ifp2:decimal (SIP|URC_Mint c-rbt1 ats-sc false))
                ;;Operation 3 - Mint
                (ifp3:decimal (SIP|URC_Mint c-rbt2 ats-sc false))
                ;;Operation 4 - Transfer
                (wt4:integer (at "type" (ref-TFT::URC_TransferClasses c-rbt2 ats-sc curler c-rbt2-amount)))
                (ico4:object{IgnisCollectorV2.OutputCumulator}
                    (ref-TFT::UDC_TransferCumulator wt4 c-rbt2 ats-sc curler)
                )
                (ifp4:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico4))
                (ifp:decimal (fold (+) 0.0 [ifp1 ifp2 ifp3 ifp4]))
                ;;
                (sa-curler:string (ref-I|OURONET::OI|UC_ShortAccount curler))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    ;;<ATS1>
                    (format "Operation: Autostakes {} {} on the {} ATS-Pair." [amount rt ats1])
                    (if (= royalty1-fee 0.0)
                        (format "Deposit in the first Autostake Pool will be executed without any {} Royalty." [rt])
                        (format "{} {} will be retained as Royalty on the First Autostake Pool." [royalty1-fee rt])
                    )
                    (format "An Intermediary Output of {} {} will be generated" [c-rbt1-amount c-rbt1])
                    ;;<ATS2>
                    (format "The Output {} will then be further autostaked on the second ATS-Pair, the {}." [c-rbt1 ats2])
                    (if (= royalty2-fee 0.0)
                        (format "Deposit in the second Autostake Pool will be executed without any {} Royalty." [c-rbt1])
                        (format "{} {} will be retained as Royalty on the Second Autostake Pool." [royalty2-fee c-rbt1])
                    )
                    (format "Curl will generate {} {} as final output." [c-rbt2-amount c-rbt2])
                ]
                [
                    (format "Succesfully curled {} {} on ATS-Pairs {} and {} generating {} {} on {} Account." [amount rt ats1 ats2 c-rbt2-amount c-rbt2 sa-curler])
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron ifp)
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun ATS|INFO_Brumate:object{OuronetInfoV3.ClientInfo}
        (patron:string brumator:string ats1:string ats2:string rt:string amount:decimal dayz:integer)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-ATS:module{AutostakeV6} ATS)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                ;;
                ;;<ats1>
                (coil1-data:object{AutostakeV6.CoilData} 
                    (ref-ATS::URC_RewardBearingTokenAmounts ats1 rt amount)
                )
                (input1-amount:decimal (at "first-input-amount" coil1-data))
                (royalty1-fee:decimal (at "royalty-fee" coil1-data))
                (c-rbt1:string (at "rbt-id" coil1-data))
                (c-rbt1-amount:decimal (at "rbt-amount" coil1-data))
                ;;
                ;;<ats2>
                (coil2-data:object{AutostakeV6.CoilData} 
                    (ref-ATS::URC_RewardBearingTokenAmountsWithHibernation ats2 c-rbt1 c-rbt1-amount dayz)
                )
                (input2-amount:decimal (at "first-input-amount" coil2-data))
                (royalty2-fee:decimal (at "royalty-fee" coil2-data))
                (c-rbt2:string (at "rbt-id" coil2-data))
                (c-rbt2-amount:decimal (at "rbt-amount" coil2-data))
                ;;
                (peak:decimal (ref-ATS::UR_PeakHibernatePromile ats2))
                (decay:decimal (ref-ATS::UR_HibernateDecay ats2))
                (dec-dayz:decimal (dec dayz))
                (v1:decimal (* dec-dayz decay))
                (v2:decimal (- peak v1))
                (fee-promile:decimal 
                    (if (<= v2 0.0)
                        0.0
                        v2
                    )
                )
                (hibernate-entry-percent:string (format "{}%" [(/ fee-promile 10.0)]))
                ;;
                ;;Operation 1 - Transfer
                (wt1:integer (at "type" (ref-TFT::URC_TransferClasses rt brumator ats-sc amount)))
                (ico1:object{IgnisCollectorV2.OutputCumulator}
                    (ref-TFT::UDC_TransferCumulator wt1 rt brumator ats-sc)
                )
                (ifp1:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico1))
                ;;Operation 2 - Mint
                (ifp2:decimal (SIP|URC_Mint c-rbt1 ats-sc false))
                ;;Operation 3 - Mint
                (ifp3:decimal (SIP|URC_Mint c-rbt2 ats-sc false))
                ;;Operation 4 - Hibernate
                (ifp4:decimal (at "ignis-full" (at "ignis" (VST|INFO_Hibernate patron ats-sc brumator c-rbt2 c-rbt2-amount dayz))))
                (ifp:decimal (fold (+) 0.0 [ifp1 ifp2 ifp3 ifp4]))
                ;;
                (sa-brumator:string (ref-I|OURONET::OI|UC_ShortAccount brumator))
                (ht:string (ref-DPTF::UR_Hibernation c-rbt2))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    ;;<ATS1>
                    (format "Operation: Autostakes {} {} on the {} ATS-Pair." [amount rt ats1])
                    (if (= royalty1-fee 0.0)
                        (format "Deposit in the first Autostake Pool will be executed without any {} Royalty." [rt])
                        (format "{} {} will be retained as Royalty on the First Autostake Pool." [royalty1-fee rt])
                    )
                    (format "An Intermediary Output of {} {} will be generated" [c-rbt1-amount c-rbt1])
                    ;;<ATS2>
                    (format "The Output {} will then be further autostaked on the second ATS-Pair, the {}." [c-rbt1 ats2])
                    (if (= royalty2-fee 0.0)
                        (format "Deposit in the second Autostake Pool will be executed without any {} Royalty." [c-rbt1])
                        (format "{} {} will be retained as Royalty on the Second Autostake Pool." [royalty2-fee c-rbt1])
                    )
                    (format "Brumating for {} Days will incurr a hibernation fee of {} on the Input {} after Royalty" [dayz hibernate-entry-percent c-rbt1])
                    (format "Brumating will generate {} {} as final output." [c-rbt2-amount ht])
                ]
                [
                    (format "Succesfully brumated {} {} on ATS-Pairs {} and {} generating {} {} on {} Account." [amount rt ats1 ats2 c-rbt2-amount ht sa-brumator])
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron ifp)
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun ATS|INFO_ColdRecovery:object{OuronetInfoV3.ClientInfo}
        (patron:string recoverer:string ats:string ra:decimal)
        (let
            (
                (ref-U|ATS:module{UtilityAtsV2} U|ATS)
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-ATS:module{AutostakeV6} ATS)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                (ref-ATSU:module{AutostakeUsageV6} ATSU)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                ;;
                (index-name:string (ref-ATS::UR_IndexName ats))
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                (c-fr:bool (ref-ATS::UR_ColdRecoveryFeeRedirection ats))
                (elite:bool (ref-ATS::UR_EliteMode ats))
                ;;
                (c-rbt-precision:integer (ref-DPTF::UR_Decimals c-rbt))
                (usable-cold-recovery-position:integer (ref-ATS::URC_WhichPosition ats ra recoverer))
                (fee-promile:decimal (ref-ATS::URC_ColdRecoveryFee ats ra usable-cold-recovery-position))
                (c-rbt-fee-split:[decimal] (ref-U|ATS::UC_PromilleSplit fee-promile ra c-rbt-precision))
                (c-rbt-remainder:decimal (at 0 c-rbt-fee-split))
                (c-rbt-fee:decimal (at 1 c-rbt-fee-split))
                ;;
                ;;Time Computation for Cold Recovery
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (major:integer (ref-DALOS::UR_Elite-Tier-Major recoverer))
                (minor:integer (ref-DALOS::UR_Elite-Tier-Minor recoverer))
                (position:integer
                    (if (= major 0)
                        0
                        (+ (* (- major 1) 7) minor)
                    )
                )
                (crd:[integer] (ref-ATS::UR_ColdRecoveryDuration ats))
                (h:integer (at position crd))
                ;;
                ;;IGNIS Costs
                ;;Operation 1 10 IGNIS Flat Fee for Cold Recovery
                (ifp1:decimal 10.0)
                ;;Operation 2 - 1 IGNIS per existing used Recovery Positions when in unlimited Mode
                (ico2:object{IgnisCollectorV2.OutputCumulator}
                    (if (!= usable-cold-recovery-position -1)
                        EOC
                        (ref-ATSU::UDC_UnlimitedUncoilCumulator ats recoverer)
                    )
                )
                (ifp2:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico2))
                ;;Operation 3 - Transfer
                (wt3:integer (at "type" (ref-TFT::URC_TransferClasses c-rbt recoverer ats-sc ra)))
                (ico3:object{IgnisCollectorV2.OutputCumulator}
                    (ref-TFT::UDC_TransferCumulator wt3 c-rbt recoverer ats-sc)
                )
                (ifp3:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico3))
                ;;Operation 3 - Burn
                (ifp3:decimal (SIP|URC_Burn c-rbt ats-sc))
                (ifp4:decimal
                    (if (= c-rbt-fee 0.0)
                        0.0
                        (if c-fr
                            0.0
                            (* (dec (length rt-lst)) ifp3)
                        )
                    )
                )
                (ifp:decimal (fold (+) 0.0 [ifp1 ifp2 ifp3 ifp4]))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Places {} {} into Cold Recovery" [ra c-rbt])
                    (if (= usable-cold-recovery-position -1)
                        (format "You have 250 Recovery Slots")
                        (if elite
                            (format "You have up to 7 Recovery Slots")
                            (format "You have 7 Recovery Slots ")
                        )
                    )
                    (if (!= c-rbt-fee 0.0)
                        (format "{}\n{}\n{}"
                            [
                                (format "Cold Recovery will incurr a Col-Recovery-Fee of {}‰ (promile)" [fee-promile])
                                (if c-fr
                                    (format "This Fee is collected by strengthening the {}" [index-name])
                                    (format "This Fee is collected by burning the Reward Tokens {}" [rt-lst])
                                )
                                (format "And Amounts to {} {}" [(ref-ATS::URC_RTSplitAmounts ats c-rbt-fee) rt-lst])
                            ]
                        )
                        (format "Cold Recovery will be executed without any Cold-Recovery-Fee")
                    )
                    (format "{} {} will be recovarable after {} hour(s)" [(ref-ATS::URC_RTSplitAmounts ats c-rbt-remainder) rt-lst h])
                ]
                [
                    (format "Succesfully placed {} {} ATS-Pair RBT into Cold Recovery" [ra ats])
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron ifp)
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )

        )
    )
    (defun ATS|INFO_Cull:object{OuronetInfoV3.ClientInfo}
        (patron:string culler:string ats:string)
        (let
            (
                (ref-U|DEC:module{OuronetDecimals} U|DEC)
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-ATS:module{AutostakeV6} ATS)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                (ref-ATSU:module{AutostakeUsageV6} ATSU)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                ;;
                (c0:[decimal] (at "summed-culled-values" (ref-ATSU::URC_MultiCull ats culler)))
                (c1:[decimal] (ref-ATSU::URC_SingleCull ats culler 1))
                (c2:[decimal] (ref-ATSU::URC_SingleCull ats culler 2))
                (c3:[decimal] (ref-ATSU::URC_SingleCull ats culler 3))
                (c4:[decimal] (ref-ATSU::URC_SingleCull ats culler 4))
                (c5:[decimal] (ref-ATSU::URC_SingleCull ats culler 5))
                (c6:[decimal] (ref-ATSU::URC_SingleCull ats culler 6))
                (c7:[decimal] (ref-ATSU::URC_SingleCull ats culler 7))
                (ca:[[decimal]] [c0 c1 c2 c3 c4 c5 c6 c7])
                (cw:[decimal] (ref-U|DEC::UC_AddHybridArray ca))
                ;;
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                (how-many-tokens:integer (length rt-lst))
                (empty:[decimal] (make-list how-many-tokens 0.0))
                ;;
                (ico1:object{IgnisCollectorV2.OutputCumulator}
                    (if (= cw empty)
                        EOC
                        (ref-TFT::UDC_MultiTransferCumulator rt-lst ats-sc culler cw)
                    )
                )
                (ifp1:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico1))
                (ifp2:decimal (* 2.0 (ref-DALOS::UR_UsagePrice "ignis|biggest")))
                (ifp:decimal (+ ifp1 ifp2))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Culls the Cold Recovery Positions, recovering RTs")
                    (if (= cw empty)
                        "Currently no RTs can be collected"
                        (format "Currently RTs {} can be recovered with amounts of: {}" [rt-lst cw])
                    )
                ]
                [
                    (format "Succesfully Culled {} RT(s) Tokens with amounts of {} from ATS-Pair {}" [how-many-tokens cw ats])
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron ifp)
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun ATS|INFO_DirectRecovery:object{OuronetInfoV3.ClientInfo}
        (patron:string recoverer:string ats:string ra:decimal)
        (let
            (
                (ref-U|ATS:module{UtilityAtsV2} U|ATS)
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-ATS:module{AutostakeV6} ATS)
                (ref-TFT:module{TrueFungibleTransferV9} TFT)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                ;;
                (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                (fee:decimal (ref-ATS::UR_DirectRecoveryFee ats))
                (c-rbt-remainder:decimal
                    (if (= fee 0.0)
                        ra
                        (at 0 (ref-U|ATS::UC_PromilleSplit fee ra (ref-DPTF::UR_Decimals c-rbt)))
                    )
                )
                (reward-tokens:[string] (ref-ATS::UR_RewardTokenList ats))
                (release-amounts:[decimal] (ref-ATS::URC_RTSplitAmounts ats c-rbt-remainder))
                ;;
                ;;Operation 1 Transfer
                (wt1:integer (at "type" (ref-TFT::URC_TransferClasses c-rbt recoverer ats-sc ra)))
                (ico1:object{IgnisCollectorV2.OutputCumulator}
                    (ref-TFT::UDC_TransferCumulator c-rbt recoverer ats-sc)
                )
                (ifp1:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico1))
                ;;Operation 2 Burn DPTF
                (ifp2:decimal (SIP|URC_Burn c-rbt ats-sc))
                ;;Operation 3 Multi Transfer
                (ico3:object{IgnisCollectorV2.OutputCumulator}
                    (ref-TFT::UDC_MultiTransferCumulator reward-tokens ats-sc recoverer release-amounts)
                )
                (ifp3:decimal (ref-I|OURONET::OI|UC_IfpFromOutputCumulator ico3))
                (ifp:decimal (fold (+) 0.0 [ifp1 ifp2 ifp3]))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [
                    (format "Operation: Directly Recovers {} {}" [ra c-rbt])
                    (if (= fee 0.0)
                        "Direct Recovery will be executed without any Direct-Recovery Fee"
                        (format "Direct Recovery will be executed with {}‰ (promile) Direct Recovery Fee" [fee])
                    )
                    (format "Direct Recovery will yield {} {} Tokens" [release-amounts reward-tokens])
                ]
                [
                    (format "Succesfully recovered directly {} RBT Token on ATS-Pair" [ra ats])
                ]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron ifp)
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    ;;  [SWP]
    (defun SWP|INFO_AddLiquidity:object{OuronetInfoV3.ClientInfo}
        (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UCX_AddLiquidity patron account swpair input-amounts true true kda-pid)
    )
    (defun SWP|INFO_IcedLiquidity:object{OuronetInfoV3.ClientInfo}
        (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UCX_AddLiquidity patron account swpair input-amounts false true kda-pid)
    )
    (defun SWP|INFO_GlacialLiquidity:object{OuronetInfoV3.ClientInfo}
        (patron:string account:string swpair:string input-amounts:[decimal] kda-pid:decimal)
        (UCX_AddLiquidity patron account swpair input-amounts false false kda-pid)
    )
    (defun SWP|INFO_FrozenLiquidity:object{OuronetInfoV3.ClientInfo}
        (patron:string account:string swpair:string frozen-dptf:string input-amount:decimal kda-pid:decimal)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-SWP:module{SwapperV6} SWP)
                (ref-SWPL:module{SwapperLiquidityV2} SWPL)
                ;;
                (dptf:string (ref-DPTF::UR_Frozen frozen-dptf))
                (ptp:integer (ref-SWP::UR_PoolTokenPosition swpair dptf))
                (lq-lst:[decimal] (ref-U|SWP::UC_MakeLiquidityList swpair ptp input-amount))
                (ld:object{SwapperLiquidityV2.LiquidityData}
                    (ref-SWPL::URC_LD swpair lq-lst)
                )
                ;;
                ;;Compute Liquidity Addition Data
                (clad:object{SwapperLiquidityV2.CompleteLiquidityAdditionData}
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
    (defun SWP|INFO_SleepingLiquidity:object{OuronetInfoV3.ClientInfo}
        (patron:string account:string swpair:string sleeping-dpof:string nonce:integer kda-pid:decimal)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                (ref-DPOF:module{DemiourgosPactOrtoFungibleV3} DPOF)
                (ref-SWP:module{SwapperV6} SWP)
                (ref-SWPL:module{SwapperLiquidityV2} SWPL)
                ;;
                (dptf:string (ref-DPOF::UR_Sleeping sleeping-dpof))
                (ptp:integer (ref-SWP::UR_PoolTokenPosition swpair dptf))
                (batch-amount:decimal (ref-DPOF::UR_NonceSupply sleeping-dpof nonce))
                (lq-lst:[decimal] (ref-U|SWP::UC_MakeLiquidityList swpair ptp batch-amount))
                (ld:object{SwapperLiquidityV2.LiquidityData}
                    (ref-SWPL::URC_LD swpair lq-lst)
                )
                ;;
                ;;Compute Liquidity Addition Data
                (clad:object{SwapperLiquidityV2.CompleteLiquidityAdditionData}
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