(module TALOS GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (TALOS-ADMIN))
    )
    (defcap TALOS-ADMIN ()
        (enforce-guard G-MD_TALOS)
    )
    (defconst G-MD_TALOS (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst DALOS|SC_NAME DALOS.DALOS|SC_NAME)

    ;;Policies
    (defcap S ()
        true
    )

    (defun DefinePolicies ()
        (DALOS.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (BASIS.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (ATSI.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (ATSM.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (VESTING.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
        (BRANDING.A_AddPolicy
            "TALOS|Summoner"
            (create-capability-guard (S))
        )
    )

    ;;====================================================
    ;;  MODULE || OUROBOROS
    ;;  
    ;;  01] TALOS.OURO|C_FuelLiquidStakingFromReserves  ||  OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves     ||  patron:string
    ;;  02] TALOS.OURO|C_WithdrawFees                   ||  OUROBOROS.OUROBOROS|C_WithdrawFees                      ||  patron:string id:string target:string
    ;;  03] TALOS.OURO|C_Sublimate:decimal              ||  OUROBOROS.IGNIS|C_Sublimate                             ||  patron:string client:string target:string ouro-amount:decimal
    ;;  04] TALOS.OURO|C_Compress:decimal               ||  OUROBOROS.IGNIS|C_Compress                              ||  patron:string client:string ignis-amount:decimal


    ;;====================================================
    ;;  MODULE || DALOS
    ;;
    ;;  01] TALOS.DALOS|A_DeployStandardAccount         ||  DALOS.DALOS|A_DeployStandardAccount                     ||  account:string guard:guard kadena:string public:string
    ;;  02] TALOS.DALOS|A_DeploySmartAccount            ||  DALOS.DALOS|A_DeploySmartAccount                        ||  account:string guard:guard kadena:string sovereign:string public:string
    ;;  03] TALOS.DALOS|A_ToggleGasCollection           ||  DALOS.IGNIS|A_Toggle                                    ||  native:bool toggle:bool
    ;;  04] TALOS.DALOS|A_SetBlockchainOuroPrice        ||  DALOS.IGNIS|A_SetSourcePrice                            ||  price:decimal
    ;;  05] TALOS.DALOS|A_UpdatesUsagePrice             ||  DALOS.DALOS|A_UpdateUsagePrice                          ||  action:string new-price:decimal
    ;;  06] TALOS.DALOS|A_UpdatePublicKey               ||  DALOS.DALOS|A_UpdatePublicKey                           ||  account:string new-public:string
    ;;
    ;;  07] TALOS.DALOS|C_DeployStandardAccount
    (defun DALOS|C_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        @doc "Deploys a Standard DALOS Account"
        (with-capability (S)
            (DALOS.DALOS|C_DeployStandardAccount account guard kadena public)
            (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS.DALOS|SC_NAME)
        )
    )
    ;;  08] TALOS.C_DeploySmartAccount
    (defun DALOS|C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        @doc "Deploys a Smart DALOS Account"
        (with-capability (S)
            (DALOS.DALOS|C_DeploySmartAccount account guard kadena sovereign public)
            (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    ;;  09] TALOS.DALOS|C_RotateGuard                   ||  DALOS.DALOS|C_RotateGuard                               ||  patron:string account:string new-guard:guard safe:bool
    ;;  10] TALOS.DALOS|C_RotateKadena                  ||  DALOS.DALOS|C_RotateKadena                              ||  patron:string account:string kadena:string
    ;;  11] TALOS.DALOS|C_RotateSovereign               ||  DALOS.DALOS|C_RotateSovereign                           ||  patron:string account:string new-sovereign:string
    ;;  12] TALOS.DALOS|C_RotateGovernor                ||  DALOS.DALOS|C_RotateGovernor                            ||  patron:string account:string governor:guard
    ;;  13] TALOS.DALOS|C_ControlSmartAccount           ||  DALOS.DALOS|C_ControlSmartAccount                       ||  patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool


    ;;====================================================
    ;;  MODULE || DPTF
    ;;
    ;;  01] TALOS.DPTF|C_ToggleBurnRole                 ||  ATSI.DPTF-DPMF|C_ToggleBurnRole                         ||  patron:string id:string account:string toggle:bool <TRUE>
    ;;  02] TALOS.DPTF|C_ToggleMintRole                 ||  ATSI.DPTF|C_ToggleMintRole                              ||  patron:string id:string account:string toggle:bool
    ;;  03] TALOS.DPTF|C_ToggleFeeExemptionRole         ||  ATSI.DPTF|C_ToggleFeeExemptionRole                      ||  patron:string id:string account:string toggle:bool
    ;;  04] TALOS.DPTF|C_DeployAccount                  ||  BASIS.DPTF-DPMF|C_DeployAccount                         ||  id:string account:string <TRUE>
    ;;  05] TALOS.DPTF|C_ChangeOwnership                ||  BASIS.DPTF-DPMF|C_ChangeOwnership                       ||  patron:string id:string new-owner:string <TRUE>
    ;;  06] TALOS.DPTF|C_ToggleFreezeAccount            ||  BASIS.DPTF-DPMF|C_ToggleFreezeAccount                   ||  patron:string id:string account:string toggle:bool <TRUE>
    ;;  07] TALOS.DPTF|C_TogglePause                    ||  BASIS.DPTF-DPMF|C_TogglePause                           ||  patron:string id:string toggle:bool <TRUE>
    ;;  08] TALOS.DPTF|C_ToggleTransferRole             ||  BASIS.DPTF-DPMF|C_ToggleTransferRole                    ||  patron:string id:string account:string toggle:bool <TRUE>
    ;;  09] TALOS.DPTF|C_Wipe                           ||  BASIS.DPTF-DPMF|C_Wipe                                  ||  patron:string id:string atbw:string <TRUE>
    ;;  10] TALOS.DPTF|C_Burn                           ||  BASIS.DPTF|C_Burn                                       ||  patron:string id:string account:string amount:decimal
    ;;  11] TALOS.DPTF|C_Control                        ||  BASIS.DPTF|C_Control                                    ||  patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool
    ;;  12] TALOS.DPTF|C_Issue
    (defun DPTF|C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool])
        @doc "Issues Multiple DPTF Tokens at once; can also be used for issuing a single DPTF Token \
        \ Outputs a list with the IDs of the Issued Tokens and creates multiple DPTF Account(s)"
        (with-capability (S)
            (let
                (
                    (output:[string] (BASIS.DPTF|C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause))
                )
                (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS.DALOS|SC_NAME)
                output
            )
        )
    )
    ;;  13] TALOS.DPTF|C_Mint                           ||  BASIS.DPTF|C_Mint                                       ||  patron:string id:string account:string amount:decimal origin:bool
    ;;  14] TALOS.DPTF|C_SetFee                         ||  BASIS.DPTF|C_SetFee                                     ||  patron:string id:string fee:decimal
    ;;  15] TALOS.DPTF|C_SetFeeTarget                   ||  BASIS.DPTF|C_SetFeeTarget                               ||  patron:string id:string target:string
    ;;  16] TALOS.DPTF|C_SetMinMove                     ||  BASIS.DPTF|C_SetMinMove                                 ||  patron:string id:string min-move-value:decimal
    ;;  17] TALOS.DPTF|C_ToggleFee                      ||  BASIS.DPTF|C_ToggleFee                                  ||  patron:string id:string toggle:bool
    ;;  18] TALOS.DPTF|C_ToggleFeeLock
    (defun DPTF|C_ToggleFeeLock (patron:string id:string toggle:bool)
        @doc "Sets the <fee-lock> for DPTF Token <id> to <toggle> \
            \ Unlocking (<toggle> = false) has restrictions: \
            \ - Max 7 unlocks per token \
            \ - Unlock cost: (10000 IGNIS + 100 KDA) * (1+ <fee-unlocks>) \
            \ - Each unlock adds Secondary Fee collected by the <GasTanker> Account \
            \ equal to the VTT * fee-unlocks: <UTILS.DPTF|UC_VolumetricTax>"
        (with-capability (S)
            (BASIS.DPTF|C_ToggleFeeLock patron id toggle)
            (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    ;;  19] TALOS.DPTF|C_UpdateBranding                 ||  BRANDING.DPTF-DPMF|C_UpdateBranding                     ||  patron:string id:string <TRUE> logo:string description:string website:string social:[object{DALOS.SocialSchema}]
    ;;  20] TALOS.DPTF|C_UpgradeBranding
    (defun DPTF|C_UpgradeBranding (patron:string id:string months:integer)
        @doc "Upgrades branding to Blue"
        (with-capability (S)
            (BRANDING.BRD|C_UpgradeBranding patron id true months)
            (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    ;;  21] TALOS.DPTF|C_Transfer                       ||  TFT.DPTF|C_Transfer                                     ||  patron:string id:string sender:string receiver:string transfer-amount:decimal <FALSE>
    ;;  22] TALOS.DPTF|CM_Transfer                      ||  TFT.DPTF|C_Transfer                                     ||  patron:string id:string sender:string receiver:string transfer-amount:decimal <TRUE>
    ;;  23] TALOS.DPTF|C_MultiTransfer                  ||  TFT.DPTF|C_MultiTransfer                                ||  patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] <FALSE>
    ;;  24] TALOS.DPTF|CM_MultiTransfer                 ||  TFT.DPTF|C_MultiTransfer                                ||  patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] <TRUE>
    ;;  25] TALOS.DPTF|C_BulkTransfer                   ||  TFT.DPTF|C_BulkTransfer                                 ||  patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] <FALSE>
    ;;  26] TALOS.DPTF|CM_BulkTransfer                  ||  TFT.DPTF|C_BulkTransfer                                 ||  patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] <TRUE>
    ;;  27] TALOS.DPTF|C_Transmute                      ||  TFT.DPTF|C_Transmute                                    ||  patron:string id:string transmuter:string transmute-amount:decimal


    ;;====================================================
    ;;  MODULE  || DPMF
    ;;
    ;;  01] TALOS.DPMF|C_DeployAccount                  ||  BASIS.DPTF-DPMF|C_DeployAccount                         ||  id:string account:string <FALSE>
    ;;  02] TALOS.DPMF|C_ChangeOwnership                ||  BASIS.DPTF-DPMF|C_ChangeOwnership                       ||  patron:string id:string new-owner:string <FALSE>
    ;;  03] TALOS.DPMF|C_ToggleFreezeAccount            ||  BASIS.DPTF-DPMF|C_ToggleFreezeAccount                   ||  patron:string id:string account:string toggle:bool <FALSE>
    ;;  04] TALOS.DPMF|C_TogglePause                    ||  BASIS.DPTF-DPMF|C_TogglePause                           ||  patron:string id:string toggle:bool <FALSE>
    ;;  05] TALOS.DPMF|C_ToggleTransferRole             ||  BASIS.DPTF-DPMF|C_ToggleTransferRole                    ||  patron:string id:string account:string toggle:bool <FALSE>
    ;;  06] TALOS.DPMF|C_Wipe                           ||  BASIS.DPTF-DPMF|C_Wipe                                  ||  patron:string id:string atbw:string <FALSE>
    ;;  07] TALOS.DPMF|C_MoveCreateRole                 ||  ATSI.DPMF|C_MoveCreateRole                              ||  patron:string id:string receiver:string
    ;;  08] TALOS.DPMF|C_ToggleAddQuantityRole          ||  ATSI.DPMF|C_ToggleAddQuantityRole                       ||  patron:string id:string account:string toggle:bool
    ;;  09] TALOS.DPMF|C_ToggleBurnRole                 ||  ATSI.DPTF-DPMF|C_ToggleBurnRole                         ||  patron:string id:string account:string toggle:bool <FALSE>
    ;;  10] TALOS.DPMF|C_AddQuantity                    ||  BASIS.DPMF|C_AddQuantity                                ||  patron:string id:string nonce:integer account:string amount:decimal
    ;;  11] TALOS.DPMF|C_Burn                           ||  BASIS.DPMF|C_Burn                                       ||  patron:string id:string nonce:integer account:string amount:decimal
    ;;  12] TALOS.DPMF|C_Control                        ||  BASIS.DPMF|C_Control                                    ||  patron:string id:string cco:bool cu:bool casr:bool cf:bool cw:bool cp:bool ctncr:bool
    ;;  13] TALOS.DPMF|C_Create                         ||  BASIS.DPMF|C_Create                                     ||  patron:string id:string account:string meta-data:[object]
    ;;  14] TALOS.DPMF|C_Issue
    (defun DPMF|C_Issue:[string] (patron:string account:string name:[string] ticker:[string] decimals:[integer] can-change-owner:[bool] can-upgrade:[bool] can-add-special-role:[bool] can-freeze:[bool] can-wipe:[bool] can-pause:[bool] can-transfer-nft-create-role:[bool])
        @doc "Similar to <TALOS|DPTF.C_Issue>, but for DPMFs"
        (with-capability (S)
            (let
                (
                    (output:[string] (BASIS.DPMF|C_Issue patron account name ticker decimals can-change-owner can-upgrade can-add-special-role can-freeze can-wipe can-pause can-transfer-nft-create-role))
                )
                (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS.DALOS|SC_NAME)
                output
            )
        )
    )
    ;;  15] TALOS.DPMF|C_Mint:integer                   ||  BASIS.DPMF|C_Mint                                       ||  patron:string id:string account:string amount:decimal meta-data:[object]
    ;;  16] TALOS.DPMF|C_Transfer                       ||  BASIS.DPMF|C_Transfer                                   ||  patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal <FALSE>
    ;;  17] TALOS.DPMF|CM_Transfer                      ||  BASIS.DPMF|C_Transfer                                   ||  patron:string id:string nonce:integer sender:string receiver:string transfer-amount:decimal <TRUE>
    ;;  18] TALOS.DPMF|C_UpdateBranding                 ||  BRANDING.DPTF-DPMF|C_UpdateBranding                     ||  patron:string id:string <FALSE> logo:string description:string website:string social:[object{DALOS.SocialSchema}]
    ;;  19] TALOS.DPMF|C_UpgradeBranding
    (defun DPMF|C_UpgradeBranding (patron:string id:string months:integer)
        @doc "Similar to <TALOS|DPTF.C_UpgradeBranding>, but for DPMFs"
        (with-capability (S)
            (BRANDING.BRD|C_UpgradeBranding patron id false months)
            (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS.DALOS|SC_NAME)
        )
    )
    ;;  20] TALOS.DPMF|C_SingleBatchTransfer            ||  TFT.DPMF|C_SingleBatchTransfer                          ||  patron:string id:string nonce:integer sender:string receiver:string <FALSE>
    ;;  21] TALOS.DPMF|CM_SingleBatchTransfer           ||  TFT.DPMF|C_SingleBatchTransfer                          ||  patron:string id:string nonce:integer sender:string receiver:string <TRUE>
    ;;  23] TALOS.DPMF|C_MultiBatchTransfer             ||  TFT.DPMF|C_MultiBatchTransfer                           ||  patron:string id:string nonces:[integer] sender:string receiver:string <FALSE>
    ;;  24] TALOS.DPMF|CM_MultiBatchTransfer            ||  TFT.DPMF|C_MultiBatchTransfer                           ||  patron:string id:string nonces:[integer] sender:string receiver:string <TRIE>


    ;;====================================================
    ;;  MODULE  || ATS
    ;;
    ;;  01] TALOS.ATS|C_ToggleFeeSettings               ||  ATSI.ATSI|C_ToggleFeeSettings                           ||  patron:string atspair:string toggle:bool fee-switch:integer
    ;;  02] TALOS.ATS|C_TurnRecoveryOff                 ||  ATSI.ATSI|C_TurnRecoveryOff                             ||  patron:string atspair:string cold-or-hot:bool
    ;;  03] TALOS.ATS|C_Issue
    (defun ATS|C_Issue:[string] (patron:string account:string atspair:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string] rbt-nfr:[bool])
        @doc "Issues an Autostake Pair. Price 5000 IGNIS and 100 KDA"
        (with-capability (S)
            (let
                (
                    (output:[string] (ATSI.ATSI|C_Issue patron account atspair index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr))
                )
                (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS.DALOS|SC_NAME)
                output
            )
        )
    )
    ;;  04] TALOS.ATS|C_HotRecovery                     ||  ATSH.ATSH|C_HotRecovery                                 ||  patron:string recoverer:string atspair:string ra:decimal
    ;;  05] TALOS.ATS|C_Redeem                          ||  ATSH.ATSH|C_Redeem                                      ||  patron:string redeemer:string id:string nonce:integer
    ;;  06] TALOS.ATS|C_RecoverWholeRBTBatch            ||  ATSH.ATSH|C_RecoverWholeRBTBatch                        ||  patron:string recoverer:string id:string nonce:integer
    ;;  07] TALOS.ATS|C_RecoverPartialRBTBatch          ||  ATSH.ATSH|C_RecoverHotRBT                               ||  patron:string recoverer:string id:string nonce:integer amount:decimal
    ;;  08] TALOS.ATS|C_ColdRecovery                    ||  ATSC.ATSC|C_ColdRecovery                                ||  patron:string recoverer:string atspair:string ra:decimal
    ;;  09] TALOS.ATS|C_Cull:[decimal]                  ||  ATSC.ATSC|C_Cull                                        ||  patron:string culler:string atspair:string
    ;;  10] TALOS.ATS|C_ChangeOwnership                 ||  ATSM.ATSM|C_ChangeOwnership                             ||  patron:string atspair:string new-owner:string
    ;;  11] TALOS.ATS|C_ToggleParameterLock
    (defun ATS|C_ToggleParameterLock (patron:string atspair:string toggle:bool)
        @doc "Sets the <parameter-lock> for the ATS Pair <atspair> to <toggle> \
            \ Unlocking <parameter-toggle> (setting it to false) comes with specific restrictions: \
            \       As many unlocks can be executed for a ATS Pair as needed \
            \       The Cost for unlock is (1000 IGNIS + 10 KDA )*(1 + <unlocks>)"
        (with-capability (S)
            (ATSM.ATSM|C_ToggleParameterLock patron atspair toggle)
            (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
        )
    )
    ;;  12] TALOS.ATS|C_UpdateSyphon                    ||  ATSM.ATSM|C_UpdateSyphon                                ||  patron:string atspair:string syphon:decimal
    ;;  13] TALOS.ATS|C_ToggleSyphoning                 ||  ATSM.ATSM|C_ToggleSyphoning                             ||  patron:string atspair:string toggle:bool
    ;;  14] TALOS.ATS|C_SetCRD                          ||  ATSM.ATSM|C_SetCRD                                      ||  patron:string atspair:string soft-or-hard:bool base:integer growth:integer
    ;;  15] TALOS.ATS|C_SetColdFee                      ||  ATSM.ATSM|C_SetColdFee                                  ||  patron:string atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]]
    ;;  16] TALOS.ATS|C_SetHotFee                       ||  ATSM.ATSM|C_SetHotFee                                   ||  patron:string atspair:string promile:decimal decay:integer
    ;;  17] TALOS.ATS|C_ToggleElite                     ||  ATSM.ATSM|C_ToggleElite                                 ||  patron:string atspair:string toggle:bool
    ;;  18] TALOS.ATS|C_TurnRecoveryOn                  ||  ATSM.ATSM|C_TurnRecoveryOn                              ||  patron:string atspair:string cold-or-hot:bool
    ;;  19] TALOS.ATS|C_AddSecondary                    ||  ATSM.ATSM|C_AddSecondary                                ||  patron:string atspair:string reward-token:string rt-nfr:bool
    ;;  20] TALOS.ATS|C_RemoveSecondary                 ||  ATSM.ATSM|C_RemoveSecondary                             ||  patron:string remover:string atspair:string reward-token:string
    ;;  21] TALOS.ATS|C_C_AddHotRBT                     ||  ATSM.ATSM|C_AddHotRBT                                   ||  patron:string atspair:string hot-rbt:string
    ;;  22] TALOS.ATS|C_Fuel                            ||  ATSM.ATSM|C_Fuel                                        ||  patron:string fueler:string atspair:string reward-token:string amount:decimal
    ;;  23] TALOS.ATS|C_Coil:Decimal                    ||  ATSM.ATSM|C_Coil                                        ||  patron:string coiler:string atspair:string rt:string amount:decimal
    ;;  24] TALOS.ATS|C_Curl:decimal                    ||  ATSM.ATSM|C_Curl                                        ||  patron:string curler:string atspair1:string atspair2:string rt:string amount:decimal
    ;;  25] TALOS.ATS|C_KickStart:decimal               ||  ATSM.ATSM|C_KickStart                                   ||  patron:string kickstarter:string atspair:string rt-amounts:[decimal] rbt-request-amount:decimal
    ;;  26] TALOS.ATS|C_Syphon                          ||  ATSM.ATSM|C_Syphon                                      ||  patron:string syphon-target:string atspair:string syphon-amounts:[decimal]
    


    ;;====================================================
    ;;  MODULE  || VST
    ;;
    ;;  01] TALOS.VST|C_CreateVestingLink
    (defun VST|C_CreateVestingLink:string (patron:string dptf:string)
        @doc "Creates an immutable Vesting Pair between the input DPTF Token and a DPMF Token that will be created by this function \
            \ Incurrs the necessary costs for issuing a DPMF Token"
        (with-capability (S)
            (let
                (
                    (output:string (VESTING.VST|C_CreateVestingLink patron dptf))
                )
                (OUROBOROS.OUROBOROS|C_FuelLiquidStakingFromReserves DALOS|SC_NAME)
                output
            )
        )
    )
    ;;  02] TALOS.VST|C_Vest                            || VESTING.VST|C_Vest                                       ||  patron:string vester:string target-account:string id:string amount:decimal offset:integer duration:integer milestones:integer
    ;;  03] TALOS.VST|C_CoilAndVest:decimal
    (defun VST|C_CoilAndVest:decimal (patron:string coiler-vester:string atspair:string coil-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        @doc "Autostakes <coil-token> and outputs its vested counterpart, to the <target-account> \
            \ Fails if the <c-rbt> of the <atspair> doesnt have an active vesting counterpart"
        (let
            (
                (c-rbt:string (ATS.ATS|UR_ColdRewardBearingToken atspair))
                (c-rbt-amount:decimal (ATS.ATS|UC_RBT atspair coil-token amount))
            )
            (ATSM.ATSM|C_Coil patron coiler-vester atspair coil-token amount)
            (VESTING.VST|C_Vest patron coiler-vester target-account c-rbt c-rbt-amount offset duration milestones)
            c-rbt-amount
        )
    )
    ;;  04] TALOS.VST|C_CurlAndVest:decimal
    (defun VST|C_CurlAndVest:decimal (patron:string curler-vester:string atspair1:string atspair2:string curl-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        @doc "Autostakes <curl-token> twice and outputs its vested counterpart when it exists, to the <target-account> \
            \ Fails if the <c-rbt> of <atspair2> doesnt have an active vesting counterpart"
        (let*
            (
                (c-rbt1:string (ATS.ATS|UR_ColdRewardBearingToken atspair1))
                (c-rbt1-amount:decimal (ATS.ATS|UC_RBT atspair1 curl-token amount))
                (c-rbt2:string (ATS.ATS|UR_ColdRewardBearingToken atspair2))
                (c-rbt2-amount:decimal (ATS.ATS|UC_RBT atspair2 c-rbt1 c-rbt1-amount))
            )
            (ATSM.ATSM|C_Curl patron curler-vester atspair1 atspair2 curl-token amount)
            (VESTING.VST|C_Vest patron curler-vester target-account c-rbt2 c-rbt2-amount offset duration milestones)
            c-rbt2-amount
        )
    )
    ;;  05] TALOS.VST|C_Cull                            ||  VESTING.VST|C_Cull                                      ||  patron:string culler:string id:string nonce:integer


    ;;====================================================
    ;;  MODULE  || LIQUID
    ;;
    ;;  01] TALOS.LIQUID|C_WrapKadena                   ||  LIQUID.LIQUID|C_WrapKadena                              ||  patron:string wrapper:string amount:decimal
    ;;  02] TALOS.LIQUID|C_UnwrapKadena                 ||  LIQUID.LIQUID|C_UnwrapKadena                            ||  patron:string unwrapper:string amount:decimal
)