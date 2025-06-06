(interface InfoOne
    @doc "Exposes Functions from Information One Module"
    ;;
    ;;
    ;;  [UC] Functions
    ;;
    (defun UC|GasPrice:decimal (full-price:decimal trigger:bool))
)
(module INFO-ONE GOV
    ;;
    (implements InfoOne)
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
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun UC|GasPrice:decimal (full-price:decimal trigger:bool)
        (if trigger 0.0 full-price)
    )
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
            \ <DPTF|C_ToggleFeeLock>"
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
            \ <DPTF|C_ToggleReservation> "
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
    (defun SIP|URC_UpdatePendingBranding:decimal (m:integer)
        @doc "<DPTF|C_UpdatePendingBranding> >> m = 1"
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (UC|GasPrice 
                (* (dec m) (ref-DALOS::UR_UsagePrice "ignis|branding"))
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
    (defun SKP|URC_Issue (name:[string])
        @doc "<DPTF|C_Issue>"                
        (let
            (
                (ref-IGNIS:module{IgnisCollector} DALOS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (l1:integer (length name))
                (dptf:decimal (ref-DALOS::UR_UsagePrice "dptf"))
            )
            (UC|GasPrice
                (* (dec l1) dptf)
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
    ;;  [IURC] - Informational URC Functions
    ;;
    (defun DPTF|URC_UpdatePendingBranding:object{OuronetInfo.ClientInfo}
        (patron:string entity-id:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Update Pending Branding for {} DPTF" [entity-id])]
                [(format "Pending Branding for DPTF {} updated succesfully" [entity-id])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_UpdatePendingBranding 1))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|URC_UpgradeBranding:object{OuronetInfo.ClientInfo}
        (patron:string entity-id:string months:integer)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Upgrade Branding for {} DPTF for {} month(s)" [entity-id months])]
                [(format "DPTF {} succesfully upgraded for {} months(s)!" [entity-id months])]
                (ref-I|OURONET::OI|UDC_NoIgnisCosts)
                (ref-I|OURONET::OI|OI|UDC_DynamicKadenaCost patron (SKP|URC_UpgradeBranding months))
            )
        )
    )
    (defun DPTF|URC_Burn:object{OuronetInfo.ClientInfo} 
        (patron:string id:string account:string amount:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
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
    (defun DPTF|URC_Control:object{OuronetInfo.ClientInfo}
        (patron:string id:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Control Properties of {}" [id])]
                [(format "Succesfully controlled Properties of {}." [id])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|URC_DeployAccount:object{OuronetInfo.ClientInfo}
        (patron:string id:string account:string)
        (let
            (
                
                (ref-I|OURONET:module{OuronetInfo} DALOS)
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
    (defun DPTF|URC_DonateFees:object{OuronetInfo.ClientInfo}
        (patron:string id:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-I|OURONET:module{OuronetInfo} DALOS)
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
    (defun DPTF|URC_Issue:object{OuronetInfo.ClientInfo}
        (patron:string account:string name:[string])
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
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
                (ref-I|OURONET::OI|UDC_DynamicKadenaCost patron (SKP|URC_Issue name))
            )
        )
    )
    (defun DPTF|URC_Mint:object{OuronetInfo.ClientInfo} 
        (patron:string id:string account:string amount:decimal origin:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
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
    (defun DPTF|URC_ResetFeeTarget:object{OuronetInfo.ClientInfo}
        (patron:string id:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-I|OURONET:module{OuronetInfo} DALOS)
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
    (defun DPTF|URC_RotateOwnership:object{OuronetInfo.ClientInfo}
        (patron:string id:string new-owner:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount new-owner))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Changes Ownership for {} to {}" [id sa])]
                [(format "Ownership succesfully set to {}" [sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Medium))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|URC_SetFee:object{OuronetInfo.ClientInfo}
        (patron:string id:string fee:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Sets fee for {} to {} Promille" [id fee])]
                [(format "Fee Promille succesfully set to {} Promille for {}" [fee id])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|URC_SetFeeTarget:object{OuronetInfo.ClientInfo}
        (patron:string id:string target:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
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
    (defun DPTF|URC_SetMinMove:object{OuronetInfo.ClientInfo}
        (patron:string id:string min-move-value:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Sets MinMove Value target for {} to {} " [id min-move-value])]
                [(format "MinMove Value succesfully set for {} to {}" [id min-move-value])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Small))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )
    (defun DPTF|URC_ToggleFee:object{OuronetInfo.ClientInfo}
        (patron:string id:string toggle:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
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
    (defun DPTF|URC_ToggleFeeLock:object{OuronetInfo.ClientInfo}
        (patron:string id:string toggle:bool fee-unlocks:integer)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
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
    (defun DPTF|URC_ToggleFreezeAccount:object{OuronetInfo.ClientInfo}
        (patron:string id:string account:string toggle:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
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
    (defun DPTF|URC_TogglePause:object{OuronetInfo.ClientInfo}
        (patron:string id:string toggle:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
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
    (defun DPTF|URC_ToggleReservation:object{OuronetInfo.ClientInfo}
        (patron:string id:string toggle:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
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
    (defun DPTF|URC_ToggleTransferRole:object{OuronetInfo.ClientInfo}
        (patron:string id:string account:string toggle:bool)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
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
    (defun DPTF|URC_Wipe:object{OuronetInfo.ClientInfo}
        (patron:string id:string atbw:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
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
    (defun DPTF|URC_WipePartial:object{OuronetInfo.ClientInfo}
        (patron:string id:string atbw:string amtbw:decimal)
        (let
            (
                (ref-I|OURONET:module{OuronetInfo} DALOS)
                ;;
                (sa:string (ref-I|OURONET::OI|UC_ShortAccount atbw))
            )
            (ref-I|OURONET::OI|UDC_ClientInfo
                [(format "Operation: Wipes {} {} from account {}" [amtbw id sa])]
                [(format "Succesfully wiped {}zzz {} from account {}" [amtbw id sa])]
                (ref-I|OURONET::OI|UDC_DynamicIgnisCost patron (SIP|URC_Biggest))
                (ref-I|OURONET::OI|UDC_NoKadenaCosts)
            )
        )
    )




















    
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)