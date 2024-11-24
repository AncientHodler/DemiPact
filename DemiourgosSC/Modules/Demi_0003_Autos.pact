(module AUTOSTAKE GOVERNANCE
    @doc "Demiourgos 0003 Module - AUTOS (Autostake Module) \
    \ Module 3 contains the Autostake Functionality built on top of DPTF and DPMF Tokens \
    \ Contains the transfer Functions for DPTF and DPMF, as these must be located here, \
    \ due to their interaction with the Autostake Mechanisms. \
    \ Vesting Functions are also located here, due to their interaction with the Autostake Module \
    \ \
    \ \
    \ Smart DALOS Accounts governed by the Module (2) \
    \ \
    \ 1)Autostake Smart Account (Autostake and DPTF|DPMF Transfer Functions)\
    \ 2)Vesting Smart Account (Vesting Functions)"

    ;;Module Governance
    (defcap GOVERNANCE ()
        (compose-capability (AUTOS-ADMIN))
        (compose-capability (VESTG-ADMIN))
    )
    (defcap AUTOS-ADMIN ()
        (enforce-guard G_AUTOS)
    )
    (defcap VESTG-ADMIN ()
        (enforce-guard G_VESTG)
    )
    ;;Module Guard
    (defconst G_AUTOS   (keyset-ref-guard AUTOS|DEMIURGOI))
    (defconst G_VESTG   (keyset-ref-guard VESTG|DEMIURGOI))
    ;;Module Keys
    (defconst AUTOS|DEMIURGOI "free.DH_SC_Autostake-Keyset")
    (defconst VESTG|DEMIURGOI "free.DH_SC_Vesting-Keyset")
    ;;Module Accounts Information
        ;;[A] Autostake Account ids for ATS Submodule
    (defconst ATS|SC_KEY "free.DH_SC_Autostake-Keyset")
    (defconst ATS|SC_NAME "Σ.ëŤΦșźUÉM89ŹïuÆÒÕ£żíëцΘЯнŹÿxжöwΨ¥Пууhďíπ₱nιrŹÅöыыidõd7ì₿ипΛДĎĎйĄшΛŁPMȘïõμîμŻIцЖljÃαbäЗŸÖéÂЫèpAДuÿPσ8ÎoŃЮнsŤΞìтČ₿Ñ8üĞÕPșчÌșÄG∇MZĂÒЖь₿ØDCПãńΛЬõŞŤЙšÒŸПĘЛΠws9€ΦуêÈŽŻ")     ;;Former DalosAutostake
    (defconst ATS|SC_KDA-NAME "k:89faf537ec7282d55488de28c454448a20659607adc52f875da30a4fd4ed2d12")
        ;;[V] Vesting Account ids for Vesting Submodule
    (defconst VST|SC_KEY "free.DH_SC_Vesting-Keyset")
    (defconst VST|SC_NAME "Σ.şZïζhЛßdяźπПЧDΞZülΦпφßΣитœŸ4ó¥ĘкÌЦ₱₱AÚюłćβρèЬÍŠęgĎwтäъνFf9źdûъtJCλúp₿ÌнË₿₱éåÔŽvCOŠŃpÚKюρЙΣΩìsΞτWpÙŠŹЩпÅθÝØpтŮыØșþшу6GтÃêŮĞбžŠΠŞWĆLτЙđнòZЫÏJÿыжU6ŽкЫVσ€ьqθtÙѺSô€χ")       ;;Former DalosVesting
    (defconst VST|SC_KDA-NAME "k:4728327e1b4790cb5eb4c3b3c531ba1aed00e86cd9f6252bfb78f71c44822d6d")
    ;;External Module Usage
    (use free.UTILS)
    (use free.DALOS)
    (use free.BASIS)

    ;;
    ;;
    ;;


    ;;Simple True Capabilities (?)
    (defcap COMPOSE ()
        @doc "Usage: composing multiple functions in an IF statement"
        true
    )
    ;;
    (defcap ATS|RESHAPE ()
        @doc "Usage: Unstake Account reshaping"
        true
    )
    (defcap ATS|RM_SECONDARY_RT ()
        @doc "Usage: pure update for removing RT from an ATS-Pair"
        true
    )
    (defcap ATS|UPDATE_ROU ()
        @doc "Usage: update Resident and|or Unbonding Values for RT of any ATS-Pair"
        true
    )
    (defcap ATS|UPDATE_ROU_PUR ()
        @doc "Usage: pure update Resident and|or Unbonding Values for RT of any ATS-Pair"
        true
    )
    (defcap ATS|INCREMENT-LOCKS ()
        @doc "Capability required to increment ATS lock amounts: <unlocks>"
        true
    )
    (defcap ATS|UPDATE_LEDGER ()
        @doc "Cap required to update entries in the ATS|Ledger"
        true
    )
    (defcap DALOS|EXECUTOR ()
        @doc "Capability Required to Execute Module Functions that have methodic counterparts"
        true
    )
    (defcap DPTF|CPF_CREDIT-FEE ()
        @doc "Credit-Primary-Fees Credit Capability"
        true
    )
    (defcap DPTF|CPF_STILL-FEE ()
        @doc "Credit-Primary-Fees Still Capability"
        true
    )
    (defcap DPTF|CPF_BURN-FEE ()
        @doc "Credit-Primary-Fees Burn Capability"
        true
    )
    (defcap VST|DEFINE ()
        @doc "Capability needed to define a vesting pair"
        true
    )
    ;; POLICY Capabilities
    (defcap P|DALOS|INCREMENT_NONCE ()
        @doc "Policy allowing usage of <DALOS.DALOS|X_IncrementNonce>"
        true
    )
    (defcap P|DALOS|UPDATE_ELITE ()
        @doc "Policy allowing usage of <DALOS.DALOS|X_UpdateElite>"
        true
    )
    (defcap P|IGNIS|COLLECTER ()
        @doc "Policy allowing usage of <DALOS.IGNIS|X_Collect>"
        true
    )
    (defcap P|ATS|UPDATE_RBT ()
        @doc "Policy allowing usage of <BASIS.DPTF-DPMF|XO_UpdateRewardBearingToken>"
        true
    )
    (defcap P|ATS|UPDATE_RT ()
        @doc "Policy allowing usage of <BASIS.DPTF|XO_UpdateRewardToken>"
        true
    )
    (defcap P|DPTF-DPMF|TOGGLE_BURN_ROLE ()
        @doc "Policy allowing usage of <BASIS.DPTF-DPMF|XO_ToggleBurnRole>"
        true
    )
    (defcap P|DPMF|MOVE_CREATE_ROLE ()
        @doc "Policy allowing usage of <BASIS.DPMF|XO_MoveCreateRole>"
        true
    )
    (defcap P|DPMF|TOGGLE_ADD_QUANTITY_ROLE ()
        @doc "Policy allowing usage of <BASIS.DPMF|XO_ToggleAddQuantityRole>"
        true
    )
    (defcap P|DPTF|BURN ()
        @doc "Policy allowing usage of <BASIS.DPTF|XO_Burn>"
        true
    )
    (defcap P|DPTF|CREDIT ()
        @doc "Policy allowing usage of <BASIS.DPTF|XO_Credit>"
        true
    )
    (defcap P|DPTF|DEBIT ()
        @doc "Policy allowing usage of <BASIS.DPTF|XO_DebitStandard>"
        true
    )
    (defcap P|DPTF|TOGGLE_FEE_EXEMPTION_ROLE ()
        @doc "Policy allowing usage of <BASIS.DPTF|XO_ToggleFeeExemptionRole>"
        true
    )
    (defcap P|DPTF|TOGGLE_MINT_ROLE ()
        @doc "Policy allowing usage of <BASIS.DPTF|XO_ToggleMintRole>"
        true
    )
    (defcap P|DPTF|UPDATE_FEES ()
        @doc "Policy allowing usage of <BASIS.DPTF|XO_UpdateFeeVolume>"
        true
    )
    (defcap P|VST|UPDATE ()
        @doc "Policy allowing usage of <BASIS.DPTF-DPMF|XO_UpdateVesting>"
        true
    )
    ;;Combined Policy Capabilities
    (defcap P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER ()
        @doc "Dual Capability for simple usage"
        (compose-capability (P|DALOS|INCREMENT_NONCE))
        (compose-capability (P|IGNIS|COLLECTER))
    )
    (defcap DPTF-DPMF|TOGGLE-BURN-ROLE ()
        @doc "Needed for <DPTF|C_ToggleMintRole>"
        (compose-capability (P|DPTF-DPMF|TOGGLE_BURN_ROLE))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap DPTF|TOGGLE-MINT-ROLE ()
        @doc "Needed for <DPTF|C_ToggleMintRole>"
        (compose-capability (P|DPTF|TOGGLE_MINT_ROLE))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap DPTF|TOGGLE-FEE-EXEMPTION-ROLE ()
        @doc "Needed for <DPTF|C_ToggleFeeExemptionRole>"
        (compose-capability (P|DPTF|TOGGLE_FEE_EXEMPTION_ROLE))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap DPMF|MOVE-CREATE-ROLE ()
        @doc "Needed for <DPMF|C_MoveCreateRole>"
        (compose-capability (P|DPMF|MOVE_CREATE_ROLE))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap DPMF|TOGGLE-ADD-QUANTITY-ROLE ()
        @doc "Needed for <DPMF|C_ToggleAddQuantityRole>"
        (compose-capability (P|DPMF|TOGGLE_ADD_QUANTITY_ROLE))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )

    ;;Policies

    (defun ATS|A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (AUTOS-ADMIN)
            (write ATS|PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun ATS|C_ReadPolicy:guard (policy-name:string)
        @doc "Reads the guard of a stored policy"
        (at "policy" (read ATS|PoliciesTable policy-name ["policy"]))
    )

    (defun ATS|DefinePolicies ()
        @doc "Add the Policy that allows running external Functions from this Module"                
        (DALOS.DALOS|A_AddPolicy     ;DALOS|DALOS
            "AUTOSTAKE|IncrementDalosNonce"
            (create-capability-guard (P|DALOS|INCREMENT_NONCE))           ;;  DALOS.DALOS|X_IncrementNonce
        )
        (DALOS.DALOS|A_AddPolicy 
            "AUTOSTAKE|UpdateElite"
            (create-capability-guard (P|DALOS|UPDATE_ELITE))              ;;  DALOS.DALOS|X_UpdateElite
        )
        (DALOS.DALOS|A_AddPolicy     ;DALOS|IGNIS
            "AUTOSTAKE|GasCollection"
            (create-capability-guard (P|IGNIS|COLLECTER))                 ;;  DALOS.IGNIS|X_Collect
        )
        (BASIS.BASIS|A_AddPolicy     ;BASIS|ATS
            "AUTOSTAKE|UpdateRewardBearingToken"
            (create-capability-guard (P|ATS|UPDATE_RBT))                  ;;  BASIS.DPTF-DPMF|XO_UpdateRewardBearingToken
        )
        (BASIS.BASIS|A_AddPolicy 
            "AUTOSTAKE|UpdateRewardToken"
            (create-capability-guard (P|ATS|UPDATE_RT))                   ;;  BASIS.DPTF|XO_UpdateRewardToken
        )
        (BASIS.BASIS|A_AddPolicy     ;BASIS|DPTF-DPMF
            "AUTOSTAKE|ToggleBurnRole"
            (create-capability-guard (P|DPTF-DPMF|TOGGLE_BURN_ROLE))      ;;  BASIS.DPTF-DPMF|XO_ToggleBurnRole
        )
        (BASIS.BASIS|A_AddPolicy     ;BASIS|DPMF
            "AUTOSTAKE|MoveCreateRole"
            (create-capability-guard (P|DPMF|MOVE_CREATE_ROLE))           ;;  BASIS.DPMF|XO_MoveCreateRole
        )
        (BASIS.BASIS|A_AddPolicy 
            "AUTOSTAKE|ToggleAddQuantityRole"
            (create-capability-guard (P|DPMF|TOGGLE_ADD_QUANTITY_ROLE))   ;;  BASIS.DPMF|XO_ToggleAddQuantityRole
        )
        (BASIS.BASIS|A_AddPolicy     ;BASIS|DPTF
            "AUTOSTAKE|BurnTrueFungible"
            (create-capability-guard (P|DPTF|BURN))                       ;;  BASIS.DPTF|XO_Burn
        )
        (BASIS.BASIS|A_AddPolicy 
            "AUTOSTAKE|CreditTrueFungible"
            (create-capability-guard (P|DPTF|CREDIT))                     ;;  BASIS.DPTF|XO_Credit
        )
        (BASIS.BASIS|A_AddPolicy 
            "AUTOSTAKE|DebitTrueFungible"
            (create-capability-guard (P|DPTF|DEBIT))                      ;;  BASIS.DPTF|XO_DebitStandard
        )
        (BASIS.BASIS|A_AddPolicy 
            "AUTOSTAKE|ToggleFeeExemptionRole"
            (create-capability-guard (P|DPTF|TOGGLE_FEE_EXEMPTION_ROLE))  ;;  BASIS.DPTF|XO_ToggleFeeExemptionRole
        )
        (BASIS.BASIS|A_AddPolicy
            "AUTOSTAKE|ToggleMintRole"
            (create-capability-guard (P|DPTF|TOGGLE_MINT_ROLE))           ;;  BASIS.DPTF|XO_ToggleMintRole
        )
        (BASIS.BASIS|A_AddPolicy 
            "AUTOSTAKE|UpdateFees"
            (create-capability-guard (P|DPTF|UPDATE_FEES))                ;;  BASIS.DPTF|XO_UpdateFeeVolume
        )
        (BASIS.BASIS|A_AddPolicy     ;BASIS|VST
            "AUTOSTAKE|UpdateVesting"
            (create-capability-guard (P|VST|UPDATE))                      ;;  BASIS.DPTF-DPMF|XO_UpdateVesting
        )
    )

    ;;Modules Governor
    (defcap ATS|GOV ()
        @doc "Autostake Governor Capability for local Handling"
        true
    )
    (defun ATS|SetGovernor (patron:string)
        (DALOS.DALOS|C_RotateGovernor
            patron
            ATS|SC_NAME
            (UTILS.GUARD|UEV_Any
                [
                    (create-capability-guard (ATS|GOV))
                    (ATS|C_ReadPolicy "OUROBOROS|RemoteAutostakeGovernor")
                ]
            )
        )
    )
    (defcap VST|GOV ()
        @doc "Vesting Module Governor Capability for its Smart DALOS Account"
        true
    )
    (defun VST|SetGovernor (patron:string)
        (DALOS.DALOS|C_RotateGovernor
            patron
            VST|SC_NAME
            (create-capability-guard (VST|GOV))
        )
    )


;;  1]CONSTANTS Definitions
    ;;[A] ATS Constant
    (defconst NULLTIME (time "1984-10-11T11:10:00Z"))
    (defconst ANTITIME (time "1983-08-07T11:10:00Z"))
;;  2]SCHEMAS Definitions
    ;;[A] ATS Schemas
    (defschema ATS|PolicySchema
        @doc "Schema that stores external policies, that are able to operate within this module"
        policy:guard
    )
    (defschema ATS|PropertiesSchema
        owner-konto:string                              ;;Flexible
        can-change-owner:bool                           ;;Flexible
        parameter-lock:bool                             ;;PROTECTION
        unlocks:integer
        ;;Index
        pair-index-name:string                          ;;IMUTABLE
        index-decimals:integer                          ;;IMUTABLE
        syphon:decimal                                  ;;Flexible
        syphoning:bool                                  ;;Flexible [PROTECTED] x
        ;;Reward Tokens
        reward-tokens:[object{ATS|RewardTokenSchema}]   ;;Semi-Flexible (1st RT is immutable, rest are flexible) [PROTECTED] x
        ;;Cold Reward Bearing Token Info
        c-rbt:string                                    ;;IMUTABLE
        c-nfr:bool                                      ;;Flexible [PROTECTED] x
        c-positions:integer                             ;;Flexible [PROTECTED] x
        c-limits:[decimal]                              ;;Flexible [PROTECTED] x
        c-array:[[decimal]]                             ;;Flexible [PROTECTED] x
        c-fr:bool                                       ;;Flexible [PROTECTED] x
        c-duration:[integer]                            ;;Flexible [PROTECTED] x
        c-elite-mode:bool                               ;;Flexible [PROTECTED] x
        ;;Hot Reward Bearing Token Info
        h-rbt:string                                    ;;Once Set, is IMMUTABLE [PROTECTED] 
        h-promile:decimal                               ;;Flexible [PROTECTED] x
        h-decay:integer                                 ;;Flexible [PROTECTED] x
        h-fr:bool                                       ;;Flexible [PROTECTED] x
        ;; Activation Toggles
        cold-recovery:bool                              ;;Flexible
        hot-recovery:bool                               ;;Flexible
    )
    (defschema ATS|RewardTokenSchema
        token:string
        nfr:bool
        resident:decimal
        unbonding:decimal
    )
    ;;==
    (defschema ATS|BalanceSchema
        @doc "Schema that Stores ATS Unstake Information for ATS Pairs (True Fungibles)\
            \ Key for the Table is a string composed of: <ATS-Pair> + UTILS.BAR + <account> \
            \ This ensure a single entry per ATS Pair per account."
        P0:[object{ATS|Unstake}]
        P1:object{ATS|Unstake}
        P2:object{ATS|Unstake}
        P3:object{ATS|Unstake}
        P4:object{ATS|Unstake}
        P5:object{ATS|Unstake}
        P6:object{ATS|Unstake}
        P7:object{ATS|Unstake}
    )
    (defschema ATS|Unstake
        reward-tokens:[decimal]
        cull-time:time
    )
    (defschema ATS|Hot
        mint-time:time
    )
    ;;[V] VST Schemas
    (defschema VST|MetaDataSchema
        release-amount:decimal
        release-date:time
    )
;;  3]TABLES Definitions
    ;;[A] ATS Tables
    (deftable ATS|PoliciesTable:{ATS|PolicySchema})
    (deftable ATS|Pairs:{ATS|PropertiesSchema})
    (deftable ATS|Ledger:{ATS|BalanceSchema})
    ;;
    ;;
    ;;            BASIS             Submodule
    ;;
    ;;            CAPABILITIES      <7>
    ;;            FUNCTIONS         [16]
    ;;========[D] RESTRICTIONS=================================================;;
    ;;            Capabilities FUNCTIONS                [CAP]
    ;;            Function Based CAPABILITIES           [CF](have this tag)
    ;;            Enforcements & Validations FUNCTIONS  [UEV]
    ;;        <7> Composed CAPABILITIES                 [CC](dont have this tag)
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;            Data Read FUNCTIONS                   [UR]
    ;;            Data Read and Computation FUNCTIONS   [URC] and [UC]
    ;;            Data Creation|Composition FUNCTIONS   [UCC]
    ;;            Administrative Usage FUNCTIONS        [A]
    ;;        [8] Client Usage FUNCTIONS                [C]
    ;;        [8] Auxiliary Usage FUNCTIONS             [X]
    ;;=========================================================================;;
    ;;
    ;;            START
    ;;
    ;;========[D] RESTRICTIONS=================================================;;
    ;;     (NONE) Capabilities FUNCTIONS                [CAP]
    ;;     (NONE) Function Based CAPABILITIES           [CF](have this tag)
    ;;     (NONE) Enforcements & Validations FUNCTIONS  [UEV]
    ;;        <7> Composed CAPABILITIES                 [CC](dont have this tag)
    (defcap IGNIS|MATRON_STRONG (id:string client:string target:string)
        @doc "Capability needed to be a gas payer for a patron with a sender and receiver"
        (if (DALOS.IGNIS|URC_ZeroGAZ id client target)
            true
            (compose-capability (P|IGNIS|COLLECTER))
        )
    )
    (defcap DPTF|TRANSFER (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Allows Transfers of DPTF Tokens from <sender> to <receiver>"
        (compose-capability (DPTF|X_TRANSFER id sender receiver transfer-amount method))
        (compose-capability (IGNIS|MATRON_STRONG id sender receiver))
        (compose-capability (P|DALOS|INCREMENT_NONCE))
        (compose-capability (DALOS|EXECUTOR))
    )
    (defcap DPTF|X_TRANSFER (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Core DPTF Transfer Capability"
        ;;Sender Method Check
        (DALOS.DALOS|CAP_EnforceAccountOwnership sender)
        (if (and method (DALOS.DALOS|UR_AccountType receiver))
            (DALOS.DALOS|CAP_EnforceAccountOwnership receiver)
            true
        )
        ;;Token and Amount check
        (BASIS.DPTF-DPMF|UEV_Amount id transfer-amount true)
        (if (not (BASIS.DPTF|UC_TransferFeeAndMinException id sender receiver))
            (BASIS.DPTF|UEV_EnforceMinimumAmount id transfer-amount)
            true
        )
        ;;Transferability check
        (DALOS.DALOS|UEV_EnforceTransferability sender receiver method)
        ;;Pause State Check
        (BASIS.DPTF-DPMF|UEV_PauseState id false true)
        ;;Freeze State Check
        (BASIS.DPTF-DPMF|UEV_AccountFreezeState id sender false true)
        (BASIS.DPTF-DPMF|UEV_AccountFreezeState id receiver false true)
        ;;Transfer Role Check
        (if 
            (and 
                (> (BASIS.DPTF-DPMF|UR_TransferRoleAmount id true) 0) 
                (not (or (= sender DALOS.OUROBOROS|SC_NAME)(= sender DALOS.DALOS|SC_NAME)))
            )
            (let
                (
                    (s:bool (BASIS.DPTF-DPMF|UR_AccountRoleTransfer id sender true))
                    (r:bool (BASIS.DPTF-DPMF|UR_AccountRoleTransfer id receiver true))
                )
                (enforce-one
                    (format "Neither the sender {} nor the receiver {} have an active transfer role" [sender receiver])
                    [
                        (enforce (= s true) (format "Transfer-Role doesnt check for sender {}" [sender]))
                        (enforce (= r true) (format "Transfer-Role doesnt check for sender {}" [sender]))
                    ]

                )
            )
            (format "No transfer restrictions exist when transfering {} from {} to {}" [id sender receiver])
        )
        ;;Debit and Credit Capabilities
        (compose-capability (P|DPTF|DEBIT))
        (compose-capability (P|DPTF|CREDIT))
        ;;Capability needed in case an Elite Account Update is required
        (compose-capability (P|DALOS|UPDATE_ELITE))
        ;;Since this is a DPTF Transfer Capability, also compose this:
        (compose-capability (P|DPTF|UPDATE_FEES))
        (compose-capability (DPTF|CREDIT_PRIMARY-FEE))
    )
    (defcap DPTF|CREDIT_PRIMARY-FEE ()
        @doc "Capability needed to Credit Primary Fees"
        (compose-capability (DPTF|CPF_CREDIT-FEE))
        (compose-capability (DPTF|CPF_STILL-FEE))
        (compose-capability (DPTF|CPF_BURN-FEE))
        (compose-capability (ATS|UPDATE_ROU))
        (compose-capability (P|DPTF|CREDIT))
        (compose-capability (P|DPTF|BURN))
    )
    (defcap DPTF|TRANSMUTE ()
        @doc "Core Capabity needed for transmuting a DPTF Token"
        (compose-capability (DALOS|EXECUTOR))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
        (compose-capability (DPTF|X_TRANSMUTE))
    )
    (defcap DPTF|X_TRANSMUTE ()
        @doc "Helper Capability required for <DPTF|TRANSMUTE>"
        (compose-capability (P|DPTF|DEBIT))
        (compose-capability (DPTF|CREDIT_PRIMARY-FEE))
    )
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;     (NONE) Data Read FUNCTIONS                   [UR]
    ;;     (NONE) Data Read and Computation FUNCTIONS   [URC] and [UC]
    ;;     (NONE) Data Creation|Composition FUNCTIONS   [UCC]
    ;;     (NONE) Administrative Usage FUNCTIONS        [A]
    ;;        [8] Client Usage FUNCTIONS                [C]
    (defun DPTF-DPMF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool token-type:bool)
        @doc "Sets |role-burn| to <toggle> for True|Meta-Fungible <id> and DPTF|DPMF Account <account>. \
            \ This determines if Account <account> can burn existing True|Meta-Fungibles."
        (with-capability (DPTF-DPMF|TOGGLE-BURN-ROLE)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_SMALL)
                true
            )
            (BASIS.DPTF-DPMF|XO_ToggleBurnRole id account toggle token-type)
            (DALOS.DALOS|X_IncrementNonce patron)
            (if (and (= account ATS|SC_NAME) (= toggle false))
                (ATS|C_RevokeBurn patron id token-type)
                true
            )
        )
    )
    (defun DPTF|C_ToggleMintRole (patron:string id:string account:string toggle:bool)
        @doc "Sets |role-mint| to <toggle> for TrueFungible <id> and DPTF Account <account>, \
            \ allowing or revoking minting rights"
        (with-capability (DPTF|TOGGLE-MINT-ROLE)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_SMALL)
                true
            )
            (BASIS.DPTF|XO_ToggleMintRole id account toggle)
            (DALOS.DALOS|X_IncrementNonce patron)
            (if (and (= account ATS|SC_NAME) (= toggle false))
                (ATS|C_RevokeMint patron id)
                true
            )
        )
    )
    (defun DPTF|C_ToggleFeeExemptionRole (patron:string id:string account:string toggle:bool)
        @doc "Sets |role-fee-exemption| to <toggle> for TrueFungible <id> and DPTF Account <account> \
            \ Accounts with this role true are exempt from fees when sending or receiving the token, if fee settings are active"
        (with-capability (DPTF|TOGGLE-FEE-EXEMPTION-ROLE)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_SMALL)
                true
            )
            (BASIS.DPTF|XO_ToggleFeeExemptionRole id account toggle)
            (DALOS.DALOS|X_IncrementNonce patron)
            (if (and (= account ATS|SC_NAME) (= toggle false))
                (ATS|C_RevokeFeeExemption patron id)
                true
            )
        )
    )
    (defun DPTF|C_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal)
        @doc "Client DPTF Transfer Function"
        (with-capability (DPTF|TRANSFER patron id sender receiver transfer-amount false)
            (DPTF|XK_Transfer patron id sender receiver transfer-amount false)
        )
    )
    (defun DPTF|CM_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal)
        @doc "Client DPTF Transfer Methodic Function"
        (with-capability (DPTF|TRANSFER patron id sender receiver transfer-amount true)
            (DPTF|XK_Transfer patron id sender receiver transfer-amount true)
        )
    )
    (defun DPTF|C_Transmute (patron:string id:string transmuter:string transmute-amount:decimal)
        @doc "Client DPTF Transmute Function"
        (with-capability (DPTF|TRANSMUTE)
            (DPTF|XK_Transmute patron id transmuter transmute-amount)
        )
    )
    (defun DPMF|C_MoveCreateRole (patron:string id:string receiver:string)
        @doc "Moves |role-nft-create| from <sender> to <receiver> DPMF Account for MetaFungible <id> \
            \ Only a single DPMF Account can have the |role-nft-create| \
            \ Afterwards the receiver DPMF Account can crete new Meta Fungibles \ 
            \ Fails if the target DPMF Account doesnt exist"
        (with-capability (DPMF|MOVE-CREATE-ROLE)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (BASIS.DPTF-DPMF|UR_Konto id false) DALOS.GAS_BIGGEST)
                true
            )
            (BASIS.DPMF|XO_MoveCreateRole id receiver)
            (DALOS.DALOS|X_IncrementNonce patron)
            (if (!= (BASIS.DPMF|UR_CreateRoleAccount id) ATS|SC_NAME)
                (ATS|C_RevokeCreateOrAddQ patron id)
                true
            )
        )
    )
    (defun DPMF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool)
        @doc "Sets |role-nft-add-quantity| to <toggle> boolean for MetaFungible <id> and DPMF Account <account> \
            \ Afterwards Account <account> can either add quantity or no longer add quantity to existing MetaFungible"
        (with-capability (DPMF|TOGGLE-ADD-QUANTITY-ROLE)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_SMALL)
                true
            )
            (BASIS.DPMF|XO_ToggleAddQuantityRole id account toggle)
            (DALOS.DALOS|X_IncrementNonce patron)
            (if (and (= account ATS|SC_NAME) (= toggle false))
                (ATS|C_RevokeCreateOrAddQ patron id)
                true
            )
        )
    )
    ;;        [8] Auxiliary Usage FUNCTIONS             [X]
    (defun DPTF|XK_Transmute (patron:string id:string transmuter:string transmute-amount:decimal)
        @doc "Kore DPTF Transmute Function"
        (require-capability (DALOS|EXECUTOR))
        (if (not (and (= id (DALOS|UR_UnityID))(>= transmute-amount 10)))
            (if (not (DALOS.IGNIS|URC_ZeroGAS id transmuter))
                (DALOS.IGNIS|X_Collect patron transmuter DALOS.GAS_SMALLEST)
                true
            )
            true
        )    
        (DPTF|X_Transmute id transmuter transmute-amount)
        (DALOS.DALOS|X_IncrementNonce transmuter)
    )
    (defun DPTF|X_Transmute (id:string transmuter:string transmute-amount:decimal)
        @doc "Transmutes a DPTF Token; only specific functions can use transmutation\
            \ Transmutation behaves as a DPTF Fee (without actually counting towards Native DPTF Fee Volume), \
            \ when the DPTF Token is not part of any ATS-Pair; \
            \ If the Token is part one or multiple ATS Pairs, \
            \ the input amount will be used to strengthen those ATS-Pairs Indices"
        (require-capability (DPTF|X_TRANSMUTE))
        (BASIS.DPTF|XO_DebitStandard id transmuter transmute-amount)
        (DPTF|X_CreditPrimaryFee id transmute-amount false)
    )
    (defun DPTF|XK_Transfer (patron:string id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Kore DPTF Transfer Function"
        (require-capability (DALOS|EXECUTOR))
        (if (not (and (= id (DALOS|UR_UnityID))(>= transfer-amount 10)))
            (if (not (DALOS.IGNIS|URC_ZeroGAZ id sender receiver))
                (DALOS.IGNIS|X_Collect patron sender DALOS.GAS_SMALLEST)
                true
            )
            true
        )
        (DPTF|X_Transfer id sender receiver transfer-amount method)
        (DALOS.DALOS|X_IncrementNonce sender)
    )
    (defun DPTF|X_Transfer (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @doc "Transfers <id> TrueFungible from <sender> to <receiver> DPTF Account without GAS"
        (require-capability (DPTF|X_TRANSFER id sender receiver transfer-amount method))
        (BASIS.DPTF|XO_DebitStandard id sender transfer-amount)
        (let*
            (
                (ea-id:string (DALOS.DALOS|UR_EliteAurynID))
                (fee-toggle:bool (BASIS.DPTF|UR_FeeToggle id))
                (iz-exception:bool (BASIS.DPTF|UC_TransferFeeAndMinException id sender receiver))
                (fees:[decimal] (BASIS.DPTF|UC_Fee id transfer-amount))
                (primary-fee:decimal (at 0 fees))
                (secondary-fee:decimal (at 1 fees))
                (remainder:decimal (at 2 fees))
                (iz-full-credit:bool 
                    (or 
                        (or 
                            (= fee-toggle false) 
                            (= iz-exception true)
                        ) 
                        (= primary-fee 0.0)
                    )
                )
            )
            (if iz-full-credit
                (BASIS.DPTF|XO_Credit id receiver transfer-amount)
                (if (= secondary-fee 0.0)
                    (with-capability (COMPOSE)
                        (DPTF|X_CreditPrimaryFee id primary-fee true)
                        (BASIS.DPTF|XO_Credit id receiver remainder)
                    )
                    (with-capability (COMPOSE)
                        (DPTF|X_CreditPrimaryFee id primary-fee true)
                        (BASIS.DPTF|XO_Credit id DALOS.DALOS|SC_NAME secondary-fee)
                        (BASIS.DPTF|XO_UpdateFeeVolume id secondary-fee false)
                        (BASIS.DPTF|XO_Credit id receiver remainder)
                    )
                )
            )
            (BASIS.DPTF-DPMF|X_UpdateElite id sender receiver)
        )
    )
    (defun DPTF|X_CreditPrimaryFee (id:string pf:decimal native:bool)
        @doc "Function used within <DPTF|X_Transfer> to credit Primary Fee; \
        \ Depends on specific ATS Parameters if <id> is part of an ATS-Pair"
        (let
            (
                (rt:bool (BASIS.ATS|UC_IzRT id))
                (rbt:bool (BASIS.ATS|UC_IzRBT id true))
                (target:string (BASIS.DPTF|UR_FeeTarget id))
            )
            (if (and rt rbt)
                (let*
                    (
                        (v:[decimal] (ATS|CPF_RT-RBT id pf))
                        (v1:decimal (at 0 v))
                        (v2:decimal (at 1 v))
                        (v3:decimal (at 2 v))
                    )
                    (DPTF|X_CPF_StillFee id target v1)
                    (DPTF|X_CPF_CreditFee id target v2)
                    (DPTF|X_CPF_BurnFee id target v3)
                )
                (if rt
                    (let*
                        (
                            (v1:decimal (ATS|CPF_RT id pf))
                            (v2:decimal (- pf v1))
                        )
                        (DPTF|X_CPF_StillFee id target v1)
                        (DPTF|X_CPF_CreditFee id target v2)
                    )
                    (if rbt
                        (let*
                            (
                                (v1:decimal (ATS|CPF_RBT id pf))
                                (v2:decimal (- pf v1))
                            )
                            (DPTF|X_CPF_StillFee id target v1)
                            (DPTF|X_CPF_BurnFee id target v2)
                        )
                        (BASIS.DPTF|XO_Credit id target pf false)
                    )
                )
            )
        )
        (if native
            (BASIS.DPTF|XO_UpdateFeeVolume id pf true)
            true
        )
    )
    (defun DPTF|X_CPF_StillFee (id:string target:string still-fee:decimal)
        @doc "Helper Function needed for <DPTF|X_CreditPrimaryFee>"
        (require-capability (DPTF|CPF_STILL-FEE))
        (if (!= still-fee 0.0)
            (BASIS.DPTF|XO_Credit id target still-fee false)
            true
        )
    )
    (defun DPTF|X_CPF_BurnFee (id:string target:string burn-fee:decimal)
        @doc "Helper Function needed for <DPTF|X_CreditPrimaryFee>"
        (require-capability (DPTF|CPF_BURN-FEE))
        (if (!= burn-fee 0.0)
            (with-capability (COMPOSE)
                (BASIS.DPTF|XO_Credit id ATS|SC_NAME burn-fee)
                (BASIS.DPTF|XO_Burn id ATS|SC_NAME burn-fee)
            )
            true
        )
    )
    (defun DPTF|X_CPF_CreditFee (id:string target:string credit-fee:decimal)
        @doc "Helper Function needed for <DPTF|X_CreditPrimaryFee>"
        (require-capability (DPTF|CPF_CREDIT-FEE))
        (if (!= credit-fee 0.0)
            (BASIS.DPTF|XO_Credit id ATS|SC_NAME credit-fee)
            true
        )
    )
    ;;            VESTING           Submodule
    ;;
    ;;            CAPABILITIES      <4>
    ;;            FUNCTIONS         [15]
    ;;========[D] RESTRICTIONS=================================================;;
    ;;            Capabilities FUNCTIONS                [CAP]
    ;;            Function Based CAPABILITIES           [CF](have this tag)
    ;;        [2] Enforcements & Validations FUNCTIONS  [UEV]
    ;;        <4> Composed CAPABILITIES                 [CC](dont have this tag)
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;            Data Read FUNCTIONS                   [UR]
    ;;        [5] Data Read and Computation FUNCTIONS   [URC] and [UC]
    ;;        [1] Data Creation|Composition FUNCTIONS   [UCC]
    ;;            Administrative Usage FUNCTIONS        [A]
    ;;        [5] Client Usage FUNCTIONS                [C]
    ;;        [2] Auxiliary Usage FUNCTIONS             [X]
    ;;=========================================================================;;
    ;;
    ;;            START
    ;;
    ;;========[D] RESTRICTIONS=================================================;;
    ;;     (NONE) Capabilities FUNCTIONS                [CAP]
    ;;     (NONE) Function Based CAPABILITIES           [CF](have this tag)
    ;;        [2] Enforcements & Validations FUNCTIONS  [UEV]
    (defun VST|UEV_Active (dptf:string dpmf:string)
        @doc "Enforces Conditions for a Vesting Pair to be active"
        (let
            (
                (dptf-fee-exemption:bool (BASIS.DPTF|UR_AccountRoleFeeExemption dptf VST|SC_NAME))
                (create-role:bool (BASIS.DPMF|UR_AccountRoleCreate dpmf VST|SC_NAME))
                (add-q-role:bool (BASIS.DPMF|UR_AccountRoleNFTAQ dpmf VST|SC_NAME))
                (burn-role:bool (BASIS.DPTF-DPMF|UR_AccountRoleBurn dpmf VST|SC_NAME false))
                (transfer-role:bool (BASIS.DPTF-DPMF|UR_AccountRoleTransfer dpmf VST|SC_NAME false))
            )
            (enforce (= dptf-fee-exemption true) "Vesting needs <role-fee-exemption> for the DPTF Token on the DalosVesting Smart DALOS Account")
            (enforce (= create-role true) "Vesting needs <role-nft-create> for the DPMF Token on the DalosVesting Smart DALOS Account")
            (enforce (= add-q-role true) "Vesting needs <role-nft-add-quantity> for the DPMF Token on the DalosVesting Smart DALOS Account")
            (enforce (= burn-role true) "Vesting needs <role-nft-burn> for the DPMF Token on the DalosVesting Smart DALOS Account")
            (enforce (= transfer-role true) "Vesting needs <role-transfer> for the DPMF Token on the DalosVesting Smart DALOS Account")
        )
    )
    (defun VST|UEV_Existance (id:string token-type:bool existance:bool)
        @doc "Enforce that a DPTF|DPMF has a vesting counterpart or not"
        (let
            (
                (has-vesting:bool (VST|UC_HasVesting id token-type))
            )
            (enforce (= has-vesting existance) (format "Vesting for the Token {} is not satisfied with existance {}" [id existance]))
        )
    )
    ;;        [2] Composed CAPABILITIES                 [CC](dont have this tag)
    (defcap VST|VEST (vester:string target-account:string id:string)
        @doc "Capability needed for vesting DPTF Tokens"
        (compose-capability (VST|GOV))

        (BASIS.DPTF-DPMF|CAP_Owner id true)
        (DALOS.DALOS|UEV_EnforceAccountType vester false)
        (DALOS.DALOS|UEV_EnforceAccountType target-account false)
        (VST|UEV_Existance id true true)
        (VST|UEV_Active id (BASIS.DPTF-DPMF|UR_Vesting id true))
    )
    (defcap VST|CULL (culler:string id:string)
        @doc "Capability needed for culling DPMF Tokens that are vested counterparts of DPTF Tokens"
        (compose-capability (VST|GOV))

        (DALOS.DALOS|UEV_EnforceAccountType culler false)
        (VST|UEV_Existance id false true)
        (VST|UEV_Active (BASIS.DPTF-DPMF|UR_Vesting id false) id)
    )
    (defcap VST|UPDATE_VESTING (dptf:string dpmf:string)
        @doc "Capability required to Update Vesting Data"
        (compose-capability (VST|X_UPDATE_VESTING dptf dpmf))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap VST|X_UPDATE_VESTING (dptf:string dpmf:string)
        @doc "Core Capability required to Update Vesting Data"
        (BASIS.DPTF-DPMF|UEV_id dptf true)
        (BASIS.DPTF-DPMF|UEV_id dpmf false)
        (BASIS.DPTF-DPMF|CAP_Owner dptf true)
        (BASIS.DPTF-DPMF|CAP_Owner dpmf false)
        (VST|UEV_Active dptf dpmf)
        (let
            (
                (tf-vesting-id:string (BASIS.DPTF-DPMF|UR_Vesting dptf true))
                (mf-vesting-id:string (BASIS.DPTF-DPMF|UR_Vesting dpmf false))
                (iz-hot-rbt:bool (BASIS.ATS|UC_IzRBT dpmf false))
            )
            (enforce 
                (and (= tf-vesting-id UTILS.BAR) (= mf-vesting-id UTILS.BAR) )
                "Vesting Pairs are immutable !"
            )
            (enforce (= iz-hot-rbt false) "A DPMF defined as a hot-rbt cannot be used as Vesting Token in Vesting pair")
        )
    )
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;     (NONE) Data Read FUNCTIONS                   [UR]
    ;;        [5] Data Read and Computation FUNCTIONS   [URC] and [UC]
    (defun VST|UC_HasVesting:bool (id:string token-type:bool)
        @doc "Checks if a DPTF|DPMF Token has a vesting counterpart"
        (if (= (BASIS.DPTF-DPMF|UR_Vesting id token-type) UTILS.BAR)
            false
            true
        )
    )
    (defun VST|UC_SplitBalanceForVesting:[decimal] (id:string amount:decimal milestones:integer)
        @doc "Splits an Amount according to vesting parameters"
        (UTILS.VST|UC_SplitBalanceForVesting (BASIS.DPTF-DPMF|UR_Decimals id true) amount milestones)
    )
    (defun VST|UC_MakeVestingDateList:[time] (offset:integer duration:integer milestones:integer)
        @doc "Makes a Times list with unvesting milestones according to vesting parameters"
        (UTILS.VST|UC_MakeVestingDateList offset duration milestones)
    )
    (defun VST|UC_CullMetaDataAmount:decimal (client:string id:string nonce:integer)
        @doc "Returns the amount that a cull on a Vested Token would produce"
        (VST|UC_HasVesting id false)
        (let*
            (
                (meta-data:[object{VST|MetaDataSchema}] (BASIS.DPMF|UR_AccountBatchMetaData id nonce client))
                (culled-amount:decimal
                    (fold
                        (lambda
                            (acc:decimal item:object{VST|MetaDataSchema})
                            (let*
                                (
                                    (balance:decimal (at "release-amount" item))
                                    (date:time (at "release-date" item))
                                    (present-time:time (at "block-time" (chain-data)))
                                    (t:decimal (diff-time present-time date))
                                )
                                (if (>= t 0.0)
                                    (+ acc balance)
                                    acc
                                )
                            )
                        )
                        0.0
                        meta-data
                    )
                )
            )
            culled-amount
        )
    )
    (defun VST|UC_CullMetaDataObject:[object{VST|MetaDataSchema}] (client:string id:string nonce:integer)
        @doc "Returns the meta-data that a cull on a Vested Token would produce"
        (VST|UC_HasVesting id false)
        (let*
            (
                (meta-data:[object{VST|MetaDataSchema}] (BASIS.DPMF|UR_AccountBatchMetaData id nonce client))
                (culled-object:[object{VST|MetaDataSchema}]
                    (fold
                        (lambda
                            (acc:[object{VST|MetaDataSchema}] item:object{VST|MetaDataSchema})
                            (let*
                                (
                                    (date:time (at "release-date" item))
                                    (present-time:time (at "block-time" (chain-data)))
                                    (t:decimal (diff-time present-time date))
                                )
                                (if (< t 0.0)
                                    (UTILS.LIST|UC_AppendLast acc item)
                                    acc
                                )
                            )
                        )
                        []
                        meta-data
                    )
                )
            )
            culled-object
        )
    )
    ;;        [1] Data Creation|Composition FUNCTIONS   [UCC]
    (defun VST|UCC_ComposeVestingMetaData:[object{VST|MetaDataSchema}] (id:string amount:decimal offset:integer duration:integer milestones:integer)
        @doc "Creates Vesting MetaData"
        (BASIS.DPTF-DPMF|UEV_Amount id amount true)
        (UTILS.VST|UEV_MilestoneWithTime offset duration milestones)
        (let*
            (
                (amount-lst:[decimal] (VST|UC_SplitBalanceForVesting id amount milestones))
                (date-lst:[time] (VST|UC_MakeVestingDateList offset duration milestones))
                (meta-data:[object{VST|MetaDataSchema}] (zip (lambda (x:decimal y:time) { "release-amount": x, "release-date": y }) amount-lst date-lst))
            )
            meta-data
        )
    )
    ;;     (NONE) Administrative Usage FUNCTIONS        [A]
    ;;        [5] Client Usage FUNCTIONS                [C]
    (defun VST|C_CreateVestingLink (patron:string dptf:string)
        @doc "Creates a Vesting Pair using the Input DPTF Token"
        (with-capability (VST|DEFINE)
            (let*
                (
                    (ZG:bool (DALOS.IGNIS|URC_IsVirtualGasZero))
                    (dptf-owner:string (BASIS.DPTF-DPMF|UR_Konto dptf true))
                    (dptf-name:string (BASIS.DPTF-DPMF|UR_Name dptf true))
                    (dptf-ticker:string (BASIS.DPTF-DPMF|UR_Ticker dptf true))
                    (dptf-decimals:integer (BASIS.DPTF-DPMF|UR_Decimals dptf true))
                    (dpmf-name:string (+ "Vested" (take 44 dptf-name)))
                    (dpmf-ticker:string (+ "Z" (take 19 dptf-ticker)))
                    (dpmf-l:[string]
                        (DPMF|C_Issue
                            patron
                            dptf-owner
                            [dpmf-name]
                            [dpmf-ticker]
                            [dptf-decimals]
                            [false]
                            [false]
                            [true]
                            [false]
                            [false]
                            [false]
                            [true]
                        )
                    )
                    (dpmf:string (at 0 dpmf-l))
                )
                (BASIS.DPTF-DPMF|C_DeployAccount dptf VST|SC_NAME true)
                (BASIS.DPTF-DPMF|C_DeployAccount dpmf VST|SC_NAME false)
                (DPTF|C_ToggleFeeExemptionRole patron dptf VST|SC_NAME true)
                (DPMF|C_MoveCreateRole patron dpmf VST|SC_NAME)
                (DPMF|C_ToggleAddQuantityRole patron dpmf VST|SC_NAME true)
                (DPTF-DPMF|C_ToggleBurnRole patron dpmf VST|SC_NAME true false)
                (BASIS.DPTF-DPMF|C_ToggleTransferRole patron dpmf VST|SC_NAME true false)
                (VST|X_DefineVestingPair patron dptf dpmf)
                dpmf
            )
        )
    )
    (defun VST|C_Vest (patron:string vester:string target-account:string id:string amount:decimal offset:integer duration:integer milestones:integer)
        @doc "Vests <id> given input parameters to its DPMF Vesting Counterpart to <target-account>"
        (with-capability (VST|VEST vester target-account id)
            (let*
                (
                    (dpmf-id:string (BASIS.DPTF-DPMF|UR_Vesting id true))
                    (meta-data:string (VST|UCC_ComposeVestingMetaData id amount offset duration milestones))
                    (nonce:integer (+ (BASIS.DPMF|UR_NoncesUsed id) 1))
                )
            ;;1]VST|SC_NAME mints the DPMF Vesting Token according to input data
                (BASIS.DPMF|C_Mint patron dpmf-id VST|SC_NAME amount meta-data)
            ;;2]Vester transfer the DPTF Token to the VST|SC_NAME for safe keeping
                (AUTOSTAKE.DPTF|CM_Transfer patron id vester VST|SC_NAME amount)
            ;;3]VST|SC_NAME transfer the minted DPMF to the target-account
                (BASIS.DPMF|CM_Transfer patron dpmf-id nonce VST|SC_NAME target-account amount)
            )
        )
    )
    (defun VST|C_CoilAndVest:decimal (patron:string coiler-vester:string atspair:string coil-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        @doc "Autostakes <coil-token> and outputs its vested counterpart when it exists, to the <target-account> \
        \ Fails if the c-rbt doesnt have an active vesting counterpart"
        (let
            (
                (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                (c-rbt-amount:decimal (ATS|UC_RBT atspair coil-token amount))
            )
        ;;1]Coiler-Vester coils <coil-token> with <atspair>
            (ATS|C_Coil patron coiler-vester atspair coil-token amount)
        ;;2]Upon receiving the <c-rbt>, it then vests it to target-account
            (VST|C_Vest patron coiler-vester target-account c-rbt c-rbt-amount offset duration milestones)
            c-rbt-amount
        )
    )
    (defun VST|C_CurlAndVest:decimal (patron:string curler-vester:string atspair1:string atspair2:string curl-token:string amount:decimal target-account:string offset:integer duration:integer milestones:integer)
        @doc "Autostakes <curl-token> twice and outputs its vested counterpart when it exists, to the <target-account> \
        \ Fails if the c-rbt of <atspair2> doesnt have an active vesting counterpart"
        (let*
            (
                (c-rbt1:string (ATS|UR_ColdRewardBearingToken atspair1))
                (c-rbt1-amount:decimal (ATS|UC_RBT atspair1 curl-token amount))
                (c-rbt2:string (ATS|UR_ColdRewardBearingToken atspair2))
                (c-rbt2-amount:decimal (ATS|UC_RBT atspair2 c-rbt1 c-rbt1-amount))
            )
        ;;1]Curler-Vester curls <curl-token> with <atspair1> and <atspair2>
            (ATS|C_Curl patron curler-vester atspair1 atspair2 curl-token amount)
        ;;2]Upon receiving the <c-rbt2>, it then vests it to target-account
            (VST|C_Vest patron curler-vester target-account c-rbt2 c-rbt2-amount offset duration milestones)
            c-rbt2-amount
        )
    )
    (defun VST|C_Cull (patron:string culler:string id:string nonce:integer)
        @doc "Client Function that culls a Vested Token"
        (with-capability (VST|CULL culler id)
            (let*
                (
                    (dptf-id:string (BASIS.DPTF-DPMF|UR_Vesting id false))
                    (initial-amount:decimal (BASIS.DPMF|UR_AccountBatchSupply id nonce culler))
                    (culled-amount:decimal (VST|UC_CullMetaDataAmount culler id nonce))
                    (return-amount:decimal (- initial-amount culled-amount))
                )
                (if (= return-amount 0.0)
                ;;1]When <return-amount> is 0.0, the whole amount is returned as DPTF Token
                    (AUTOSTAKE.DPTF|CM_Transfer patron dptf-id VST|SC_NAME culler initial-amount)
                ;;2]Otherwise, a portion is returned as DPTF, and the remaining amount as a new DPMF with the remaining vesting meta-data
                    (let*
                        (
                            (remaining-vesting-meta-data:[object{VST|MetaDataSchema}] (VST|UC_CullMetaDataObject culler id nonce))
                            (new-nonce:integer (+ (BASIS.DPMF|UR_NoncesUsed id) 1))
                        )
                ;;3]The portion to be returned as a new DPMF is being minted
                        (BASIS.DPMF|C_Mint patron id VST|SC_NAME return-amount remaining-vesting-meta-data)
                ;;4]The portion of DPTF is returned to the culler
                        (AUTOSTAKE.DPTF|CM_Transfer patron dptf-id VST|SC_NAME culler culled-amount)
                ;;5]The newly minted DPMF representing the remainder of the vested tokens is returned to the culler
                        (BASIS.DPMF|C_Transfer patron id new-nonce VST|SC_NAME culler return-amount)
                    )
                )
                ;;6]Only now the culler sends the input DPMF Token to the VST|SC_NAME to be burned
                ;;    The operation is done at the end because the let function must probe the DPMF Token while it still exists
                (BASIS.DPMF|CM_Transfer patron id nonce culler VST|SC_NAME initial-amount)
                (BASIS.DPMF|C_Burn patron id nonce VST|SC_NAME initial-amount)
            )
        )
    )
    ;;        [2] Auxiliary Usage FUNCTIONS             [X]
    (defun VST|X_DefineVestingPair (patron:string dptf:string dpmf:string)
        @doc "Defines an immutable vesting connection between a DPTF and a DPMF Token"
        (require-capability (VST|DEFINE))
        (let
            (
                (ZG:bool (DALOS.IGNIS|URC_IsVirtualGasZero))
                (dptf-owner:string (BASIS.DPTF-DPMF|UR_Konto dptf true))
            )
            (with-capability (VST|UPDATE_VESTING dptf dpmf)
                (if (= ZG false)
                    (DALOS.IGNIS|X_Collect patron dptf-owner DALOS.GAS_BIGGEST)
                    true
                )
                (VST|X_UpdateVesting dptf dpmf)
                (DALOS.DALOS|X_IncrementNonce patron)
            )
        )
    )
    (defun VST|X_UpdateVesting (dptf:string dpmf:string)
        @doc "Updates Vesting Data for DPTF|DPMF Token Pair"
        (require-capability (VST|X_UPDATE_VESTING dptf dpmf))
        (with-capability (P|VST|UPDATE)
            (BASIS.DPTF-DPMF|XO_UpdateVesting dptf dpmf)
        )
    )
    ;;
    ;;
    ;;            AUTOSTAKE         Submodule
    ;;
    ;;            CAPABILITIES      <48>
    ;;            FUNCTIONS         [158]
    ;;========[D] RESTRICTIONS=================================================;;
    ;;        [1] Capabilities FUNCTIONS                [CAP]
    ;;        <1> Function Based & CAPABILITIES         [CF](have this tag)
    ;;       [22] Enforcements & Validations FUNCTIONS  [UEV]
    ;;       <47> Composed CAPABILITIES                 [CC](dont have this tag)
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;       [43] Data Read FUNCTIONS                   [UR]
    ;;       [10] Data Read and Computation FUNCTIONS   [URC] and [UC]
    ;;        [2] Data Creation|Composition Functions   [UCC]
    ;;            Administrative Usage Functions        [A]
    ;;       [23] Client Usage FUNCTIONS                [C]
    ;;       [57] Auxiliary Usage Functions             [X]
    ;;=========================================================================;;
    ;;
    ;;            START
    ;;
    ;;========[D] RESTRICTIONS=================================================;;
    ;;        [1] Capabilities FUNCTIONS                [CAP]
    (defun ATS|CAP_Owner (atspair:string)
        @doc "Enforces ATS Pair Ownership"
        (DALOS.DALOS|CAP_EnforceAccountOwnership (ATS|UR_OwnerKonto atspair))
    )
    ;;        <1> Function Based & CAPABILITIES         [CF](have this tag)
    (defcap ATS|CF|OWNER (atspair:string)
        @doc "Capability that enforces ATS Pair Ownership"
        (ATS|CAP_Owner atspair)
    )
    ;;         [] Enforcements & Validations FUNCTIONS  [UEV]
    (defun ATS|UEV_CanChangeOwnerON (atspair:string)
        @doc "Enforces ATS Pair ownership is changeble"
        (ATS|UEV_id atspair)
        (let
            (
                (x:bool (ATS|UR_CanChangeOwner atspair))
            )
            (enforce (= x true) (format "ATS Pair {} ownership cannot be changed" [atspair]))
        )
    )
    (defun ATS|UEV_RewardTokenExistance (atspair:string reward-token:string existance:bool)
        @doc "Enforces DPTF <reward-token> <existance> for given <atspair>"
        (let
            (
                (existance-check:bool (BASIS.ATS|UC_IzRTg atspair reward-token))
            )
            (enforce (= existance-check existance) (format "{} Existance isnt verified for Token {} as RT with ATS Pair {}" [existance reward-token atspair]))
        )
    )
    (defun ATS|UEV_RewardBearingTokenExistance (atspair:string reward-bearing-token:string existance:bool cold-or-hot:bool)
        @doc "Enforces DPTF|DPMF cold or hot Reward-Bearing-Token <existance> for given <atspair> \
            \ <true> existance means the Token is registered to an ATS Pair"
        (let
            (
                (existance-check:bool (BASIS.ATS|UC_IzRBTg atspair reward-bearing-token cold-or-hot))
            )
            (enforce (= existance-check existance) (format "{} Existance isnt verified for Token {} as RBT with ATS Pair {}" [existance reward-bearing-token atspair]))
        )
    )
    (defun ATS|UEV_HotRewardBearingTokenPresence (atspair:string enforced-presence:bool)
        @doc "Enforces that an ATS Pair has or not a registerd DPMF Token as a Hot RBT"
        (let
            (
                (presence-check:bool (ATS|UC_IzPresentHotRBT atspair))
            )
            (enforce (= presence-check enforced-presence) (format "ATS Pair {} cant verfiy {} presence for a Hot RBT Token" [atspair enforced-presence]))
        )
    )
    (defun ATS|UEV_ParameterLockState (atspair:string state:bool)
        @doc "Enforces ATS Pair <parameter-lock> to <state>"
        (let
            (
                (x:bool (ATS|UR_Lock atspair))
            )
            (enforce (= x state) (format "Parameter-lock for ATS Pair {} must be set to {} for this operation" [atspair state]))
        )
    )
    (defun ATS|UEV_SyphoningState (atspair:string state:bool)
        @doc "Enforces ATS Pair <syphoning> to <state>"
        (let
            (
                (x:bool (ATS|UR_Syphoning atspair))
            )
            (enforce (= x state) (format "Syphoning for ATS Pair {} must be set to {} for this operation" [atspair state]))
        )
    )
    (defun ATS|UEV_FeeState (atspair:string state:bool fee-switch:integer)
        @doc "Enforcers one of the 4 ATS fee bool parameters to <state> \
            \ The parameters are: \
            \ <c-nfr> or <h-nfr> \
            \ <c-fr> or <h-fr> "
        (let
            (
                (x:bool (ATS|UR_ColdNativeFeeRedirection atspair))
                (y:bool (ATS|UR_ColdRecoveryFeeRedirection atspair))
                (z:bool (ATS|UR_HotRecoveryFeeRedirection atspair))
            )
            (if (= fee-switch 0)
                (enforce (= x state) (format "Cold-NFR for ATS Pair {} must be set to {} for this operation" [atspair state]))
                (if (= fee-switch 1)
                    (enforce (= y state) (format "Cold-RFR for ATS Pair {} must be set to {} for this operation" [atspair state]))
                    (enforce (= z state) (format "Hot-RFR for ATS Pair {} must be set to {} for this operation" [atspair state]))
                )
            )
        )
    )
    (defun ATS|UEV_EliteState (atspair:string state:bool)
        @doc "Enforces ATS Pair <c-elite-mode> to <state>"
        (let
            (
                (x:bool (ATS|UR_EliteMode atspair))
            )
            (enforce (= x state) (format "Elite-Mode for ATS Pair {} must be set to {} for this operation" [atspair state]))
        )
    )
    (defun ATS|UEV_RecoveryState (atspair:string state:bool cold-or-hot:bool)
        @doc "Enforces ATS Pair <cold-recovery> or <hot-recovery> to <state>"
        (let
            (
                (x:bool (ATS|UR_ToggleColdRecovery atspair))
                (y:bool (ATS|UR_ToggleHotRecovery atspair))
            )
            (if cold-or-hot
                (enforce (= x state) (format "Cold-recovery for ATS Pair {} must be set to {} for this operation" [atspair state]))
                (enforce (= y state) (format "Hot-recovery for ATS Pair {} must be set to {} for this operation" [atspair state]))
            )
        )
    )
    (defun ATS|UEV_UpdateColdOrHot (atspair:string cold-or-hot:bool)
        @doc "Req for updating Cold or Hot ATS Parameters"
        (ATS|UEV_ParameterLockState atspair false)
        (if cold-or-hot
            (ATS|UEV_RecoveryState atspair false true)
            (ATS|UEV_RecoveryState atspair false false)
        )
    )
    (defun ATS|UEV_UpdateColdAndHot (atspair:string)
        @doc "Req for updating Cold and Hot ATS Parameters"
        (ATS|UEV_ParameterLockState atspair false)
        (ATS|UEV_RecoveryState atspair false true)
        (ATS|UEV_RecoveryState atspair false false)
    )
    (defun ATS|UEV_id (atspair:string)
        @doc "Enforces ATS Pair <atspair> exists"
        (UTILS.DALOS|UEV_UniqueAtspair atspair)
        (with-default-read ATS|Pairs atspair
            { "unlocks" : -1 }
            { "unlocks" := u }
            (enforce
                (>= u 0)
                (format "ATS-Pair {} does not exist." [atspair])
            )
        )
    )
    (defun ATS|UEV_IzTokenUnique (atspair:string reward-token:string)
        @doc "Enforces that the <reward-token> doesnt exist as reward token for the ATS Pair <atspair>"
        (DPTF-DPMF|UEV_id reward-token true)
        (let
            (
                (rtl:[string] (ATS|UR_RewardTokenList atspair))
            )
            (enforce 
                (= (contains reward-token rtl) false) 
                (format "Token {} already exists as Reward Token for the ATS Pair {}" [reward-token atspair]))     
        )
    )
    ;;       <xx> Composed CAPABILITIES                 [CC](dont have this tag)
    (defcap ATS|DEPLOY (atspair:string account:string)
        @doc "Capability required to deploy a new ATS-Pair"
        (DALOS.DALOS|UEV_EnforceAccountExists account)
        (ATS|UEV_id atspair)
        (compose-capability (ATS|NORMALIZE_LEDGER atspair account))
    )
    (defcap ATS|NORMALIZE_LEDGER (atspair:string account:string)
        @doc "Capability needed to normalize an ATS|Ledger Account \
        \ Normalizing an ATS|Ledger Account updates it \
        \ according to the <atspair> <c-positions> and <c-elite-mode> parameters \
        \ Existing entries are left as they are."
        (ATS|UEV_id atspair)
        (let*
            (
                (admin:guard DALOS.G_DALOS)
                (account-g:guard (DALOS|UR_AccountGuard account))
                (sov:string (DALOS|UR_AccountSovereign account))
                (sov-g:guard (DALOS|UR_AccountGuard sov))
                (gov-g:guard (DALOS|UR_AccountGovernor account))
            )
            (enforce-one
                "Invalid permission for normalizing ATS|Ledger Account Operations"
                [
                    (enforce-guard admin)
                    (enforce-guard account-g)
                    (enforce-guard sov-g)
                    (enforce-guard gov-g)
                ]
            )
        )
    )
    (defcap ATS|HOT_RECOVERY (recoverer:string atspair:string ra:decimal)
        @doc "Capability required to execute hot recovery"
        (compose-capability (ATS|GOV))

        (DALOS|CAP_EnforceAccountOwnership recoverer)
        (ATS|UEV_id atspair)
        (ATS|UEV_RecoveryState atspair true false)
    )
    (defcap ATS|COLD_RECOVERY (recoverer:string atspair:string ra:decimal)
        @doc "Capability required to execute cold recovery"
        (compose-capability (ATS|GOV))

        (DALOS|CAP_EnforceAccountOwnership recoverer)
        (ATS|UEV_RecoveryState atspair true true)
        (compose-capability (ATS|DEPLOY atspair recoverer))
        (compose-capability (ATS|UPDATE_LEDGER))
        (compose-capability (ATS|UPDATE_ROU))
    )
    (defcap ATS|CULL (culler:string atspair:string)
        @doc "Capability required to execute culling"
        (compose-capability (ATS|GOV))

        (DALOS|CAP_EnforceAccountOwnership culler)
        (ATS|UEV_id atspair)
        (compose-capability (ATS|UPDATE_ROU))
        (compose-capability (ATS|NORMALIZE_LEDGER atspair culler))
        (compose-capability (ATS|UPDATE_LEDGER))
    )
    (defcap ATS|OWNERSHIP_CHANGE (atspair:string new-owner:string)
        @doc "Req to change ATS Ownership"
        (compose-capability (ATS|X_OWNERSHIP_CHANGE atspair new-owner))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap ATS|X_OWNERSHIP_CHANGE (atspair:string new-owner:string)
        @doc "Core Capability required for ATS-Pair Ownership"
        (DALOS.DALOS|UEV_SenderWithReceiver (ATS|UR_OwnerKonto atspair) new-owner)
        (DALOS.DALOS|UEV_EnforceAccountExists new-owner)
        (ATS|CAP_Owner atspair)
        (ATS|UEV_CanChangeOwnerON atspair)
    )
    (defcap ATS|TOGGLE_PARAMETER-LOCK (atspair:string toggle:bool)
        @doc "Capability required to EXECUTE <ATS|C_ToggleParameterLock> Function"
        (compose-capability (ATS|X_TOGGLE_PARAMETER-LOCK atspair toggle))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
        (compose-capability (ATS|INCREMENT-LOCKS))
    )
    (defcap ATS|X_TOGGLE_PARAMETER-LOCK (atspair:string toggle:bool)
        @doc "Core Capability required to set to <toggle> the <parameter-lock> for a ATS Pair"
        (ATS|CAP_Owner atspair)
        (ATS|UEV_ParameterLockState atspair (not toggle))
        (let
            (
                (x:bool (ATS|UR_ToggleColdRecovery atspair))
                (y:bool (ATS|UR_ToggleHotRecovery atspair))
            )
            (enforce-one
                (format "ATS <parameter-lock> cannot be toggled when both <cold-recovery> and <hot-recovery> are set to false")
                [
                    (enforce (= x true) (format "Cold-recovery for ATS Pair {} must be set to <true> for this operation" [atspair]))
                    (enforce (= y true) (format "Hot-recovery for ATS Pair {} must be set to <true> for this operation" [atspair]))
                ]
            )
        )
    )
    (defcap ATS|SYPHON (atspair:string syphon:decimal)
        @doc "Cap required for setting the Syphon value"
        (compose-capability (ATS|X_SYPHON atspair syphon))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap ATS|X_SYPHON (atspair:string syphon:decimal)
        @doc "Core cap required for setting the Syphon value"
        (enforce (>= syphon 0.1) "Syphon cannot be set lower than 0.1")
        (ATS|CAP_Owner atspair)
        (let
            (
                (precision:integer (ATS|UR_IndexDecimals atspair))
            )
            (enforce
                (= (floor syphon precision) syphon)
                (format "The syphon value of {} is not a valid Index Value for the {} ATS Pair" [syphon atspair])
            )
        )
    )
    (defcap ATS|SYPHONING (atspair:string toggle:bool)
        @doc "Cap required for toggling syphoning"
        (compose-capability (ATS|X_SYPHONING atspair toggle))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap ATS|X_SYPHONING (atspair:string toggle:bool)
        @doc "Core cap required for toggling syphoning"
        (ATS|CAP_Owner atspair)
        (ATS|UEV_SyphoningState atspair (not toggle))
        (ATS|UEV_ParameterLockState atspair false)
    )
    (defcap ATS|TOGGLE_FEE (atspair:string toggle:bool fee-switch:integer)
        @doc "Req for updating <c-nfr>, <c-fr>, <h-fer>"
        (compose-capability (ATS|X_TOGGLE_FEE atspair toggle fee-switch))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap ATS|X_TOGGLE_FEE (atspair:string toggle:bool fee-switch:integer)
        @doc "Core cap req for updating <c-nfr>, <c-fr>, <h-fer>"
        (enforce (contains fee-switch (enumerate 0 2)) "Integer not a valid fee-switch integer")
        (ATS|CAP_Owner atspair)
        (ATS|UEV_FeeState atspair (not toggle) fee-switch)
        (ATS|UEV_ParameterLockState atspair false)
        (if (or (= fee-switch 0)(= fee-switch 1))
            (ATS|UEV_UpdateColdOrHot atspair true)
            (ATS|UEV_UpdateColdOrHot atspair false)
        )
    )
    (defcap ATS|SET_CRD (atspair:string soft-or-hard:bool base:integer growth:integer)
        @doc "Req for setting Cold Recovery Duration"
        (compose-capability (ATS|X_SET_CRD atspair soft-or-hard base growth))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap ATS|X_SET_CRD (atspair:string soft-or-hard:bool base:integer growth:integer)
        @doc "Core cap req for setting Cold Recovery Duration"
        (ATS|CAP_Owner atspair)
        (ATS|UEV_UpdateColdOrHot atspair true)
        (ATS|UEV_ParameterLockState atspair false)
        (if (= soft-or-hard true)
            (enforce 
                (and 
                    (= (mod base growth) 0)
                    (= (mod growth 3) 0)
                ) 
                (format "{} as base and {} as growth are incompatible with the Soft Method for generation of CRD" [base growth])
            )
            (enforce 
                (= (mod base growth) 0)
                (format "{} as base and {} as growth are incompatible with the Hard Method for generation of CRD" [base growth])    
            )
        )
    )
    (defcap ATS|SET_COLD_FEE (atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        @doc "Req for setting Cold Recovery Fee"
        (compose-capability (ATS|X_SET_COLD_FEE atspair fee-positions fee-thresholds fee-array))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap ATS|X_SET_COLD_FEE (atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        @doc "Core cap req for setting Cold Recovery Fee"
        (ATS|CAP_Owner atspair)
        (ATS|UEV_UpdateColdOrHot atspair true)
        (ATS|UEV_ParameterLockState atspair false)
        ;;<fee-positions> validation
        (enforce 
            (or 
                (= fee-positions -1)
                (contains fee-positions (enumerate 1 7))
            )
            "The Number of Fee Positions must be either -1 or between 1 and 7"
        )
        ;;<fee-threhsolds> validation (number)
        (enforce 
            (and
                (>= (length fee-thresholds) 1)
                (<= (length fee-thresholds) 100)
            )
            "No More than 100 Fee Threhsolds can be set"
        )
        ;;<fee-threhsold> validation (value as threshold)
        (fold
            (lambda
                (acc:bool idx:integer)
                (let*
                    (
                        (current:decimal (at idx fee-thresholds))
                        (precision:integer (BASIS.DPTF-DPMF|UR_Decimals (ATS|UR_ColdRewardBearingToken atspair) true))
                    )
                    (if (<= idx (- (length fee-thresholds) 2))
                        (let
                            (
                                (next:decimal (at (+ idx 1) fee-thresholds))
                            )
                            (enforce 
                                (< current next)
                                (format "Current Amount {} must be smaller than the next Amount in the Threhsold List" [current next])
                            )
                        )
                        true
                    )
                    (enforce
                        (= (floor current precision) current)
                        (format "The Amount of {} does not conform with the CRBT decimals number" [current])
                    )
                    acc
                )
            )
            true
            (enumerate 0 (- (length fee-thresholds) 1))
        )
        ;;<fee-array> validation
        (if (= (ATS|UC_ZeroColdFeeExceptionBoolean fee-thresholds fee-array) true)
            (if (= fee-positions -1)
                (enforce (= (length fee-array) 1) "The input <fee-array> must be of length 1")
                (enforce (= (length fee-array) fee-positions) (format "The input <fee-array> must be of length {}" [fee-positions]))
            )
            true
        )
        ;;<fee-array> validation; inner lists - equal length
        (UTILS.UTILS|UEV_DecimalArray fee-array)
        ;;<fee-array> validation: inner lists = (length <fee-threshold> +1)
        (if (= (ATS|UC_ZeroColdFeeExceptionBoolean fee-thresholds fee-array) true)
            (enforce
                (= (length (at 0 fee-array)) (+ (length fee-thresholds) 1))
                "Inner Lists of the <fee-array> are incompatible with the <fee-thresholds> length"
            )
            true
        )
        ;;<fee-array>: value validation
        (map
            (lambda 
                (inner-lst:[decimal])
                (map
                    (lambda 
                        (fee:decimal)
                        (UTILS.DALOS|UEV_Fee fee)
                    )
                    inner-lst
                )
            )
            fee-array
        )
    )
    (defcap ATS|SET_HOT_FEE (atspair:string promile:decimal decay:integer)
        @doc "Req for setting Cold Recovery Fee"
        (compose-capability (ATS|X_SET_HOT_FEE atspair promile decay))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap ATS|X_SET_HOT_FEE (atspair:string promile:decimal decay:integer)
        @doc "Core cap req for setting Cold Recovery Fee"
        (ATS|CAP_Owner atspair)
        (ATS|UEV_UpdateColdOrHot atspair false)
        (ATS|UEV_ParameterLockState atspair false)
        (UTILS.DALOS|UEV_Fee promile)
        (enforce 
            (and
                (>= decay 1)
                (<= decay 9125)
            )
            "No More than 25 years (9125 days) can be set for Decay Period"
        )
    )
    (defcap ATS|TOGGLE_ELITE (atspair:string toggle:bool)
        @doc "Req for toggling Elite Mode for an ATS Pair"
        (compose-capability (ATS|X_TOGGLE_ELITE atspair toggle))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap ATS|X_TOGGLE_ELITE (atspair:string toggle:bool)
        @doc "Core cap req for toggling Elite Mode for an ATS Pair"
        (ATS|CAP_Owner atspair)
        (ATS|UEV_UpdateColdOrHot atspair true)
        (ATS|UEV_EliteState atspair (not toggle))
        (ATS|UEV_ParameterLockState atspair false)
        (if (= toggle true)
            (let
                (
                    (x:integer (ATS|UR_ColdRecoveryPositions atspair))
                )
                (enforce (= x 7) (format "Cold Recovery Positions for ATS Pair {} must be set to 7 for this operation" [atspair]))
            )
            true
        )
    )
    (defcap ATS|TOGGLE_RECOVERY (atspair:string toggle:bool cold-or-hot:bool)
        @doc "Cap req for toggling ATS-Pair Cold or Hot Recovery"
        (if toggle
            (compose-capability (ATS|X_RECOVERY-ON atspair cold-or-hot))
            (compose-capability (ATS|X_RECOVERY-OFF atspair cold-or-hot))
        )
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap ATS|X_RECOVERY-ON (atspair:string cold-or-hot:bool)
        @doc "Core cap req for turning on ATS Recovery"
        (ATS|CAP_Owner atspair)
        (ATS|UEV_ParameterLockState atspair false)
        (ATS|UEV_RecoveryState atspair false cold-or-hot)
    )
    (defcap ATS|X_RECOVERY-OFF (atspair:string cold-or-hot:bool)
        @doc "Core cap req for turning off ATS Recovery"
        (ATS|CAP_Owner atspair)
        (ATS|UEV_ParameterLockState atspair false)
        (ATS|UEV_RecoveryState atspair true cold-or-hot)
    )
    (defcap ATS|ISSUE (atspair:string issuer:string reward-token:string reward-bearing-token:string)
        @doc "Capability required to EXECUTE <ATS|C_IssueAutostakePair> Function"
        (compose-capability (ATS|X_ISSUE atspair issuer reward-token reward-bearing-token))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap ATS|X_ISSUE (atspair:string issuer:string reward-token:string reward-bearing-token:string)
        @doc "Core Capability required to Issued a ATS Pair"
        (enforce (!= reward-token reward-bearing-token) "Reward Token must be different from Reward-Bearing Token")
        (DALOS.DALOS|CAP_EnforceAccountOwnership issuer)
        (DALOS.DALOS|UEV_EnforceAccountType issuer false)
        (BASIS.DPTF-DPMF|CAP_Owner reward-token true)
        (BASIS.DPTF-DPMF|CAP_Owner reward-bearing-token true)
        (ATS|UEV_RewardTokenExistance atspair reward-token false)
        (ATS|UEV_RewardBearingTokenExistance atspair reward-bearing-token false true)
        (compose-capability (P|ATS|UPDATE_RT))
        (compose-capability (P|ATS|UPDATE_RBT))
    )
    (defcap ATS|ADD_SECONDARY (atspair:string reward-token:string token-type:bool)
        @doc "Capability required to EXECUTE <ATS|C_AddSecondary> Function"
        (compose-capability (ATS|X_ADD_SECONDARY atspair reward-token token-type))
        (compose-capability (P|DALOS|INCREMENT_NONCE||P|IGNIS|COLLECTER))
    )
    (defcap ATS|X_ADD_SECONDARY (atspair:string reward-token:string token-type:bool)
        (BASIS.DPTF-DPMF|CAP_Owner reward-token token-type)
        (ATS|CAP_Owner atspair)
        (ATS|UEV_UpdateColdAndHot atspair)
        (ATS|UEV_ParameterLockState atspair false)
        (if (= token-type true)
            (compose-capability (ATS|ADD_SECONDARY_RT atspair reward-token))
            (compose-capability (ATS|ADD_SECONDARY_RBT atspair reward-token))
        )
    )
    (defcap ATS|ADD_SECONDARY_RT (atspair:string reward-token:string)
        @doc "Cap req for subsequent adding as secondary as RT"
        (ATS|UEV_IzTokenUnique atspair reward-token)
        (ATS|UEV_RewardTokenExistance atspair reward-token false)
        (compose-capability (P|ATS|UPDATE_RT))
    )
    (defcap ATS|ADD_SECONDARY_RBT (atspair:string hot-rbt:string)
        @doc "Cap req for subsequent adding as secondary as Hot-RBT"
        (ATS|UEV_HotRewardBearingTokenPresence atspair false)   
        (compose-capability (P|ATS|UPDATE_RBT))
        (VST|UEV_Existance hot-rbt false false)
    )
    (defcap ATS|FUEL (atspair:string reward-token:string)
        @doc "Req for <ATS|C_Fuel>"
        (compose-capability (ATS|GOV))

        (ATS|UEV_RewardTokenExistance atspair reward-token true)
        (compose-capability (ATS|UPDATE_ROU))
        (let
            (
                (index:decimal (ATS|UC_Index atspair))
            )
            (enforce (>= index 1.0) "Fueling cannot take place on a negative Index")
        )
    )
    (defcap ATS|COIL_OR_CURL (atspair:string coil-token:string)
        @doc "Req for coiling and curling"
        (compose-capability (ATS|GOV))

        (ATS|UEV_RewardTokenExistance atspair coil-token true)
        (compose-capability (ATS|UPDATE_ROU))
    )
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;       [43] Data Read FUNCTIONS                   [UR]
    (defun ATS|KEYS:[string] ()
        (keys ATS|Ledger)
    )
    (defun ATS|UR_OwnerKonto:string (atspair:string)
        (at "owner-konto" (read ATS|Pairs atspair ["owner-konto"]))
    )
    (defun ATS|UR_CanChangeOwner:bool (atspair:string)
        (at "can-change-owner" (read ATS|Pairs atspair ["can-change-owner"]))
    )
    (defun ATS|UR_Lock:bool (atspair:string)
        (at "parameter-lock" (read ATS|Pairs atspair ["parameter-lock"]))
    )
    (defun ATS|UR_Unlocks:integer (atspair:string)
        (at "unlocks" (read ATS|Pairs atspair ["unlocks"]))
    )
    (defun ATS|UR_IndexName:string (atspair:string)
        (at "pair-index-name" (read ATS|Pairs atspair ["pair-index-name"]))
    )
    (defun ATS|UR_IndexDecimals:integer (atspair:string)
        (at "index-decimals" (read ATS|Pairs atspair ["index-decimals"]))
    )
    (defun ATS|UR_Syphon:decimal (atspair:string)
        (at "syphon" (read ATS|Pairs atspair ["syphon"]))
    )
    (defun ATS|UR_Syphoning:bool (atspair:string)
        (at "syphoning" (read ATS|Pairs atspair ["syphoning"]))
    )
    (defun ATS|UR_RewardTokens:[object{ATS|RewardTokenSchema}] (atspair:string)
        (at "reward-tokens" (read ATS|Pairs atspair ["reward-tokens"]))
    )
    (defun ATS|UR_ColdRewardBearingToken:string (atspair:string)
        (at "c-rbt" (read ATS|Pairs atspair ["c-rbt"]))
    )
    (defun ATS|UR_ColdNativeFeeRedirection:bool (atspair:string)
        (at "c-nfr" (read ATS|Pairs atspair ["c-nfr"]))
    )
    (defun ATS|UR_ColdRecoveryPositions:integer (atspair:string)
        (at "c-positions" (read ATS|Pairs atspair ["c-positions"]))
    )
    (defun ATS|UR_ColdRecoveryFeeThresholds:[decimal] (atspair:string)
        (at "c-limits" (read ATS|Pairs atspair ["c-limits"]))
    )
    (defun ATS|UR_ColdRecoveryFeeTable:[[decimal]] (atspair:string)
        (at "c-array" (read ATS|Pairs atspair ["c-array"]))
    )
    (defun ATS|UR_ColdRecoveryFeeRedirection:bool (atspair:string)
        (at "c-fr" (read ATS|Pairs atspair ["c-fr"]))
    )
    (defun ATS|UR_ColdRecoveryDuration:[integer] (atspair:string)
        (at "c-duration" (read ATS|Pairs atspair ["c-duration"]))
    )
    (defun ATS|UR_EliteMode:bool (atspair:string)
        (at "c-elite-mode" (read ATS|Pairs atspair ["c-elite-mode"]))
    )
    (defun ATS|UR_HotRewardBearingToken:string (atspair:string)
        (at "h-rbt" (read ATS|Pairs atspair ["h-rbt"]))
    )
    (defun ATS|UR_HotRecoveryStartingFeePromile:decimal (atspair:string)
        (at "h-promile" (read ATS|Pairs atspair ["h-promile"]))
    )
    (defun ATS|UR_HotRecoveryDecayPeriod:integer (atspair:string)
        (at "h-decay" (read ATS|Pairs atspair ["h-decay"]))
    )
    (defun ATS|UR_HotRecoveryFeeRedirection:bool (atspair:string)
        (at "h-fr" (read ATS|Pairs atspair ["h-fr"]))
    )
    (defun ATS|UR_ToggleColdRecovery:bool (atspair:string)
        (at "cold-recovery" (read ATS|Pairs atspair ["cold-recovery"]))
    )
    (defun ATS|UR_ToggleHotRecovery:bool (atspair:string)
        (at "hot-recovery" (read ATS|Pairs atspair ["hot-recovery"]))
    )
    (defun ATS|UR_RewardTokenList:[string] (atspair:string)
        @doc "Returns the list of Reward Tokens for an ATS Pair."
        (fold
            (lambda
                (acc:[string] item:object{ATS|RewardTokenSchema})
                (UTILS.LIST|UC_AppendLast acc (at "token" item))
            )
            []
            (ATS|UR_RewardTokens atspair)
        )
    )
    (defun ATS|UR_RoUAmountList:[decimal] (atspair:string rou:bool)
        @doc "Returns the list of Reward Tokens Resident Amounts for an ATS Pair."
        (fold
            (lambda
                (acc:[decimal] item:object{ATS|RewardTokenSchema})
                (if rou
                    (UTILS.LIST|UC_AppendLast acc (at "resident" item))
                    (UTILS.LIST|UC_AppendLast acc (at "unbonding" item))
                )
            )
            []
            (ATS|UR_RewardTokens atspair)
        )
    )
    (defun ATS|UR_RT-Data (atspair:string reward-token:string data:integer)
        @doc "Returns RT Data for a given <reward-token> of a given <atspair>"
        (ATS|UEV_id atspair)
        (UTILS.UTILS|UEV_PositionalVariable data 3 "Invalid Data Integer")
        (let*
            (
                (rt:[object{ATS|RewardTokenSchema}] (ATS|UR_RewardTokens atspair))
                (rtp:integer (ATS|UC_RewardTokenPosition atspair reward-token))
                (rto:object{ATS|RewardTokenSchema} (at rtp rt))
            )
            (cond
                ((= data 1) (at "nfr" rto))
                ((= data 2) (at "resident" rto))
                ((= data 3) (at "unbonding" rto))
                true
            )
        )
    )
    (defun ATS|UR_RtPrecisions:[integer] (atspair:string)
        @doc "Returns a list of integers representing precisions of RBT Tokens of <atspair>"
        (fold
            (lambda
                (acc:[integer] rt:string)
                (UTILS.LIST|UC_AppendLast acc (BASIS.DPTF-DPMF|UR_Decimals rt true))
            )
            []
            (ATS|UR_RewardTokenList atspair)
        )
    )
    (defun ATS|UR_P0:[object{ATS|Unstake}] (atspair:string account:string)
        @doc "Returns the <P0> of an ATS-UnstakingAccount"
        (at "P0" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P0"]))
    )
    (defun ATS|UR_P1-7:object{ATS|Unstake} (atspair:string account:string position:integer)
        @doc "Returns the <P1> through <P7> of an ATS-UnstakingAccount"
        (UTILS.UTILS|UEV_PositionalVariable position 7 "Invalid Position Number")
        (cond
            ((= position 1) (at "P1" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P1"])))
            ((= position 2) (at "P2" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P2"])))
            ((= position 3) (at "P3" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P3"])))
            ((= position 4) (at "P4" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P4"])))
            ((= position 5) (at "P5" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P5"])))
            ((= position 6) (at "P6" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P6"])))
            ((= position 7) (at "P7" (read ATS|Ledger (concat [atspair UTILS.BAR account]) ["P7"])))
            true
        )
    )
    ;;       [xx] Data Read and Computation FUNCTIONS   [URC] and [UC]
    (defun ATS|URC_MaxSyphon:[decimal] (atspair:string)
        @doc "Computes the maximum amount of Reward Tokens that can be syphoned"
        (let*
            (
                (index:decimal (ATS|UC_Index atspair))
                (syphon:decimal (ATS|UR_Syphon atspair))
                (resident-rt-amounts:[decimal] (ATS|UR_RoUAmountList atspair true))
                (precisions:[integer] (ATS|UR_RtPrecisions atspair))
                (max-precision:integer (UTILS|UC_MaxInteger precisions))
                (max-pp:integer (at 0 (LIST|UC_Search precisions max-precision)))
                (pair-rbt-supply:decimal (ATS|UCX_PairRBTSupply atspair))
            )
            (if (<= index syphon)
                (make-list (length precisions) 0.0)
                (let*
                    (
                        (index-diff:decimal (- index syphon))
                        (rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                        (rbt-precision:integer (BASIS.DPTF-DPMF|UR_Decimals rbt true))
                        (max-sum:decimal (floor (* pair-rbt-supply index-diff) rbt-precision))
                        (prelim:[decimal]
                            (fold
                                (lambda
                                    (acc:[decimal] idx:integer)
                                    (UTILS.LIST|UC_AppendLast acc 
                                        (floor (/ (* (- index syphon) (at idx resident-rt-amounts)) index) (at idx precisions))
                                    )
                                )
                                []
                                (enumerate 0 (- (length precisions) 1))
                            )
                        )
                        (prelim-sum:decimal (fold (+) 0.0 prelim))
                        (diff:decimal (- max-sum prelim-sum))
                    )
                    (if (= diff 0.0)
                        prelim
                        (UTILS.LIST|UC_ReplaceAt prelim max-pp (+ diff (at max-pp prelim)))
                    )
                )
            )
        )
    )
    (defun ATS|UC_IzCullable:bool (input:object{ATS|Unstake})
        @doc "Computes if Unstake Object is cullable"
        (let*
            (
                (present-time:time (at "block-time" (chain-data)))
                (stored-time:time (at "cull-time" input))
                (diff:decimal (diff-time present-time stored-time))
            )
            (if (>= diff 0.0)
                true
                false
            )
        )
    )
    (defun ATS|UC_CullValue:[decimal] (input:object{ATS|Unstake})
        @doc "Returns the value of a cull object"
        (let*
            (
                (rt-amounts:[decimal] (at "reward-tokens" input))
                (l:integer (length rt-amounts))
                (iz:bool (ATS|UC_IzCullable input))
            )
            (if iz
                rt-amounts
                (make-list l 0.0)
            )
        )
    )
    (defun ATS|UC_AccountUnbondingBalance (atspair:string account:string reward-token:string)
        @doc "Returns by computation the Total Unbonding value tied to an ATS-UnstakeAccount (defined with <atspair> and <account>) \
            \ for a given Reward-Token (which is a Reward-Token of the given <atspair>)"
        (+
            (fold
                (lambda
                    (acc:decimal item:object{ATS|Unstake})
                    (+ acc (ATS|UCX_UnstakeObjectUnbondingValue atspair reward-token item))
                )
                0.0
                (ATS|UR_P0 atspair account)
            )
            (fold
                (lambda
                    (acc:decimal item:integer)
                    (+ acc (ATS|UCX_UnstakeObjectUnbondingValue atspair reward-token (ATS|UR_P1-7 atspair account item)))
                )
                0.0
                (enumerate 1 7)
            )
        )
    )
    (defun ATS|UCX_UnstakeObjectUnbondingValue (atspair:string reward-token:string io:object{ATS|Unstake})
        @doc "Special Helper Function needed for <ATS|UC_AccountUnbondingBalance>"
        (let*
            (
                (rtp:integer (ATS|UC_RewardTokenPosition atspair reward-token))
                (rt:[decimal] (at "reward-tokens" io))
                (rb:decimal (at rtp rt))
            )
            (if (= rb -1.0)
                0.0
                rb
            )
        )
    )
    (defun ATS|UC_WhichPosition:integer (atspair:string c-rbt-amount:decimal account:string)
        @doc "Computes which position can be used for Cold Recovery, given input parameters. \
            \ Returning 0 means no position is available for cold recovery"
        (let
            (
                (elite:bool (ATS|UR_EliteMode atspair))
            )
            (if elite
                (ATS|UC_ElitePosition atspair c-rbt-amount account)
                (ATS|UC_NonElitePosition atspair account)
            )
        )
    )
    (defun ATS|UC_ElitePosition:integer (atspair:string c-rbt-amount:decimal account:string)
        @doc "Computes which position can be used for cold recovery when <c-elite-mode> is true"
        (let
            (
                (positions:integer (ATS|UR_ColdRecoveryPositions atspair))
                (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                (ea-id:string (DALOS.DALOS|UR_EliteAurynID))
            )
            (if (!= ea-id UTILS.BAR)
                ;elite auryn is defind
                (let*
                    (
                        (iz-ea-id:bool (if (= ea-id c-rbt) true false))
                        (pstate:[integer] (ATS|UC_PSL atspair account))
                        (met:integer (DALOS.DALOS|UR_Elite-Tier-Major account))
                        (ea-supply:decimal (BASIS.DPTF-DPMF|UR_AccountSupply ea-id account true))
                        (t-ea-supply:decimal (BASIS.DALOS|URC_EliteAurynzSupply account))
                        (virtual-met:integer (str-to-int (take 1 (at "tier" (UTILS.ATS|UCC_Elite (- t-ea-supply c-rbt-amount))))))
                        (available:[integer] (if iz-ea-id (take virtual-met pstate) (take met pstate)))
                        (search-res:[integer] (UTILS.LIST|UC_Search available 1))
                    )
                    (if iz-ea-id
                        (enforce (<= c-rbt-amount ea-supply) "Amount of EA used for Cold Recovery cannot be greater than what exists on Account")
                        true
                    )
                    (if (= (length search-res) 0)
                        0
                        (+ (at 0 search-res) 1)
                    )
                )
                ;elite-auryn is not defined
                (ATS|UC_NonElitePosition atspair account)
            )
        )
    )
    (defun ATS|UC_NonElitePosition:integer (atspair:string account:string)
        @doc "Computes which position can be used for cold recovery when <c-elite-mode> is false"
        (let
            (
                (positions:integer (ATS|UR_ColdRecoveryPositions atspair))
            )
            (if (= positions -1)
                -1
                (let*
                    (
                        (pstate:[integer] (ATS|UC_PSL atspair account))
                        (available:[integer] (take positions pstate))
                        (search-res:[integer] (UTILS.LIST|UC_Search available 1))
                    )
                    (if (= (length search-res) 0)
                        0
                        (+ (at 0 search-res) 1)
                    )
                )
            )
        )
    )
    (defun ATS|UC_PSL:[integer] (atspair:string account:string)
        @doc "Creates a list of position states"
        (let
            (
                (p1s:integer (ATS|UC_PositionState atspair account 1))
                (p2s:integer (ATS|UC_PositionState atspair account 2))
                (p3s:integer (ATS|UC_PositionState atspair account 3))
                (p4s:integer (ATS|UC_PositionState atspair account 4))
                (p5s:integer (ATS|UC_PositionState atspair account 5))
                (p6s:integer (ATS|UC_PositionState atspair account 6))
                (p7s:integer (ATS|UC_PositionState atspair account 7))
            )
            [p1s p2s p3s p4s p5s p6s p7s]
        )
    )
    (defun ATS|UC_PositionState:integer (atspair:string account:string position:integer)
        (UTILS.UTILS|UEV_PositionalVariable position 7 "Input Position out of bounds")
        (with-read ATS|Ledger (concat [atspair UTILS.BAR account])
            { "P1"  := p1 , "P2"  := p2 , "P3"  := p3, "P4"  := p4, "P5"  := p5, "P6"  := p6, "P7"  := p7 }
            (let
                (
                    (ps1:integer (ATS|UC_PositionalObjectState atspair p1))
                    (ps2:integer (ATS|UC_PositionalObjectState atspair p2))
                    (ps3:integer (ATS|UC_PositionalObjectState atspair p3))
                    (ps4:integer (ATS|UC_PositionalObjectState atspair p4))
                    (ps5:integer (ATS|UC_PositionalObjectState atspair p5))
                    (ps6:integer (ATS|UC_PositionalObjectState atspair p6))
                    (ps7:integer (ATS|UC_PositionalObjectState atspair p7))
                )
                (cond
                    ((= position 1) ps1)
                    ((= position 2) ps2)
                    ((= position 3) ps3)
                    ((= position 4) ps4)
                    ((= position 5) ps5)
                    ((= position 6) ps6)
                    ps7
                )
            )
        )
    )
    (defun ATS|UC_PositionalObjectState:integer (atspair:string input-obj:object{ATS|Unstake})
        @doc "Checks cold recovery position object state: \
        \ occupied(0), opened(1), closed (-1)"
        (let
            (
                (zero:object{ATS|Unstake} (ATS|UCC_MakeZeroUnstakeObject atspair))
                (negative:object{ATS|Unstake} (ATS|UCC_MakeNegativeUnstakeObject atspair))
            )
            (if (= input-obj zero)
                1
                (if (= input-obj negative)
                    -1
                    0
                )
            )
        )
    )
    (defun ATS|UC_ColdRecoveryFee (atspair:string c-rbt-amount:decimal input-position:integer)
        @doc "Computes the Cold Recovery fee of an <atspair>, given an input <c-rbt-amount> of Cold-Reward-Bearing-Token \
        \ and an input position <input-position> on which the cold recovery takes place."
        (let*
            (
                (ats-positions:integer (ATS|UR_ColdRecoveryPositions atspair))
                (ats-limit-values:[decimal] (ATS|UR_ColdRecoveryFeeThresholds atspair))
                (ats-limits:integer (length ats-limit-values))
                (ats-fee-array:[[decimal]] (ATS|UR_ColdRecoveryFeeTable atspair))
                (ats-fee-array-length:integer (length ats-fee-array))
                (ats-fee-array-length-length:integer (length (at 0 ats-fee-array)))
                (zc1:bool (if (= ats-limits 1) true false))
                (zc2:bool (if (= (at 0 ats-limit-values) 0.0) true false))
                (zc3:bool (and zc1 zc2))
                (zc4:bool (if (= ats-fee-array-length 1) true false))
                (zc5:bool (if (= ats-fee-array-length-length 1) true false))
                (zc6:bool (and zc4 zc5))
                (zc7:bool (if (= (at 0 (at 0 ats-fee-array)) 0.0) true false))
                (zc8:bool (and zc6 zc7))
                (zc9:bool (and zc3 zc8))
            )
            (enforce (<= input-position ats-positions) "Input position out of bounds")
            (if zc9
                0.0
                (let
                    (
                        (limit:integer
                            (fold
                                (lambda
                                    (acc:integer tv:decimal)
                                    (if (< c-rbt-amount tv)
                                        acc
                                        (+ acc 1)
                                    )
                                )
                                0
                                ats-limit-values
                            )
                        )
                        (qlst:[decimal] 
                            (if (= input-position -1)
                                (at 0 ats-fee-array)
                                (at (- input-position 1) ats-fee-array)
                            )
                        )
                    )
                    (at limit qlst)
                )
            )
        )
    )
    (defun ATS|UC_CullColdRecoveryTime:time (atspair:string account:string)
        @doc "Computes the Cull Time for the <atspair> and <account> \
        \ The Cull Time is the unavoidable time that must elapse in order to complete a Cold Recovery in any ATS-Pair \
        \ The Cull Time depends on ATS-Pair parameters, and DALOS Elite Account Tier"
        (let*
            (
                (major:integer (DALOS.DALOS|UR_Elite-Tier-Major account))
                (minor:integer (DALOS.DALOS|UR_Elite-Tier-Minor account))
                (position:integer 
                    (if (= major 0)
                        0
                        (+ (* (- major 1) 7) minor)
                    )
                )
                (crd:[integer] (ATS|UR_ColdRecoveryDuration atspair))
                (h:integer (at position crd))
                (present-time:time (at "block-time" (chain-data)))
            )
            (add-time present-time (hours h))
        )
    )
    (defun ATS|UC_RTSplitAmounts:[decimal] (atspair:string rbt-amount:decimal)
        @doc "Splits a RBT value, the <rbt-amount>, using following inputs: \
            \ Reward-Bearing-Token supply <rbt-supply> of an <atspair> (read below) \
            \ The <index> of the <atspair> (read below) \
            \ A list <resident-amounts> respresenting amounts of resident Reward-Tokens of the <atpsair> \
            \ A list <rt-precision-lst> representing the precision of these Reward-Tokens \
            \ \
            \ Resulting a decimal list of Reward-Token Values coresponding to the input <rbt-amount> \
            \ The Actual computation takes place in the UTILITY Module in the <UC_SplitByIndexedRBT> Function"
        (let
            (
                (rbt-supply:decimal (ATS|UCX_PairRBTSupply atspair))
                (index:decimal (ATS|UC_Index atspair))
                (resident-amounts:[decimal] (ATS|UR_RoUAmountList atspair true))
                (rt-precision-lst:[integer] (ATS|UR_RtPrecisions atspair))
            )
            (enforce (<= rbt-amount rbt-supply) "Cannot compute for amounts greater than the pairs rbt supply")
            (UTILS.ATS|UC_SplitByIndexedRBT rbt-amount rbt-supply index resident-amounts rt-precision-lst)
        )
    )
    (defun ATS|UC_Index (atspair:string)
        @doc "Returns the ATS-Pair Index Value"
        (let
            (
                (p:integer (ATS|UR_IndexDecimals atspair))
                (rs:decimal (ATS|UC_ResidentSum atspair))
                (rbt-supply:decimal (ATS|UCX_PairRBTSupply atspair))
            )
            (if
                (= rbt-supply 0.0)
                -1.0
                (floor (/ rs rbt-supply) p)
            )
        )
    )
    (defun ATS|UCX_PairRBTSupply:decimal (atspair:string)
        @doc "Helper Function needed for <ATS|UC_Index>"
        (let*
            (
                (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                (c-rbt-supply:decimal (DPTF-DPMF|UR_Supply c-rbt true))
            )
            (if (= (ATS|UC_IzPresentHotRBT atspair) false)
                c-rbt-supply
                (let*
                    (
                        (h-rbt:string (ATS|UR_HotRewardBearingToken atspair))
                        (h-rbt-supply:decimal (BASIS.DPTF-DPMF|UR_Supply h-rbt false))
                    )
                    (+ c-rbt-supply h-rbt-supply)
                )
            )
        )
    )
    (defun ATS|UC_RBT:decimal (atspair:string rt:string rt-amount:decimal)
        @doc "Computes the RBT amount that can be created from an input rt-amount which is part of an ATS-Pair"
        (let*
            (
                (index:decimal (abs (ATS|UC_Index atspair)))
                (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                (p-rbt:integer (BASIS.DPTF-DPMF|UR_Decimals c-rbt true))
            )
            ;;Ensures the input rt-amount is a number with at most the maximum decimals the c-rbt token has
            (enforce
                (= (floor rt-amount p-rbt) rt-amount)
                (format "The entered amount of {} must have at most, the precision c-rbt token {} which is {}" [rt-amount c-rbt p-rbt])
            )
            (floor (/ rt-amount index) p-rbt)
        )
    )
    (defun ATS|UC_ResidentSum:decimal (atspair:string)
        @doc "Returns the sum of all Resident Reward-Token Amounts for the ATS-Pair"
        (fold (+) 0.0 (ATS|UR_RoUAmountList atspair true)) 
    )
    (defun ATS|UC_IzPresentHotRBT:bool (atspair:string)
        @doc "Checks if an ATS Pair has registered a Hot-RBT"
        (if (= (ATS|UR_HotRewardBearingToken atspair) UTILS.BAR)
            false
            true
        )
    )
    (defun ATS|UC_RewardTokenPosition:integer (atspair:string reward-token:string)
        @doc "Returns the <reward-token> position when its part of an <atspair>"
        (let
            (
                (existance-check:bool (ATS|UC_IzRTg atspair reward-token))
            )
            (enforce (= existance-check true) (format "{} Existance isnt verified for Token {} as RT with ATS Pair {}" [true reward-token atspair]))
            (at 0 (UTILS.LIST|UC_Search (ATS|UR_RewardTokenList atspair) reward-token))
        )
    )
    (defun ATS|UC_ZeroColdFeeExceptionBoolean:bool (fee-thresholds:[decimal] fee-array:[[decimal]])
        @doc "Computes a Boolean representing the Zero Fee Exceptions for Cold ATS Fees."
        (not 
            (UTILS.UTILS|UC_TripleAnd
                (= (length fee-thresholds) 1)
                (= (at 0 fee-thresholds) 0.0)
                (UTILS.UTILS|UC_TripleAnd
                    (= (length fee-array) 1)
                    (= (length (at 0 fee-array)) 1)
                    (= (at 0 (at 0 fee-array)) 0.0)
                )
            )
        )
    )
    ;;CPF Computers
    (defun ATS|CPF_RT-RBT:[decimal] (id:string native-fee-amount:decimal)
        @doc "Used in the CPF - Credit Primary Fee, within <DPTF|X_Transfer> function \
            \ Computes how much of the Primarly Fee is used for strenghtening which ATS Index \
            \ when a token is both RT and RBT for an ATS Pair. \
            \ Returns 3 values: \
            \       [0] <still> amount which must still be used as native transfer fee; \
            \       [1] <credit> amount to be credited to ATS|SC_NAME to strengthen ATS Pair Index\
            \       [2] <burn> amount which has to be burned to strengthen ATS Pair Index"
        (let*
            (
                (rt-ats-pairs:[string] (BASIS.DPTF|UR_RewardToken id))
                (rbt-ats-pairs:[string] (BASIS.DPTF|UR_RewardBearingToken id))
                (length-rt:integer (length rt-ats-pairs))
                (length-rbt:integer (length rbt-ats-pairs))
                (rt-boolean:[bool] (ATS|NFR-Boolean_RT-RBT id rt-ats-pairs true))
                (rbt-boolean:[bool] (ATS|NFR-Boolean_RT-RBT id rbt-ats-pairs false))
                (rt-milestones:integer (length (UTILS.LIST|UC_Search rt-boolean true)))
                (rbt-milestones:integer (length (UTILS.LIST|UC_Search rbt-boolean true)))
                (milestones:integer (+ rt-milestones rbt-milestones))
            )
            (if (!= milestones 0)
                (let*
                    (
                        (truths:[bool] (+ rt-boolean rbt-boolean))
                        (split-with-truths:[decimal] (ATS|UC_BooleanDecimalCombiner id native-fee-amount milestones truths))
                    )
                    (if (!= rt-milestones 0)
                        (let
                            (
                                (credit-sum:decimal
                                    (fold
                                        (lambda
                                            (acc:decimal index:integer)
                                            (if (at index rt-boolean)
                                                (with-capability (COMPOSE)
                                                    (ATS|XO_UpdateRoU (at index rt-ats-pairs) id true true (at index split-with-truths))
                                                    (+ acc (at index split-with-truths))
                                                )
                                                acc
                                            )
                                        )
                                        0.0
                                        (enumerate 0 (- (length rt-ats-pairs) 1))
                                    )
                                )
                            )
                            (if (= credit-sum 0.0)
                                [0.0 0.0 native-fee-amount]
                                [0.0 credit-sum (- native-fee-amount credit-sum)]
                            )
                        )
                        [0.0 0.0 native-fee-amount]
                    )
                )
                [native-fee-amount 0.0 0.0]
            )
        )
    )
    (defun ATS|CPF_RBT:decimal (id:string native-fee-amount:decimal)
        @doc "Used in the CPF - Credit Primary Fee, within <DPTF|X_Transfer> function \
            \ Computes the <still> amount of Primary Fee when a token is only a RBT token as part of ATS Pairs \
            \ The remaining amount is the <burn> amount."
        (let*
            (
                (ats-pairs:[string] (BASIS.DPTF|UR_RewardBearingToken id))
                (ats-pairs-bool:[bool] (ATS|NFR-Boolean_RT-RBT id ats-pairs false))
                (milestones:integer (length (UTILS.LIST|UC_Search ats-pairs-bool true)))
            )
            (if (!= milestones 0)
                0.0
                native-fee-amount
            )
        )
    )
    (defun ATS|CPF_RT:decimal (id:string native-fee-amount:decimal)
        @doc "Used in the CPF - Credit Primary Fee, within <DPTF|X_Transfer> function \
            \ Computes the <still> amount of Primary Fee when a token is only a RT token as part of ATS Pairs \
            \ The remaining amount is the <credit> amount."
        (let*
            (
                (ats-pairs:[string] (BASIS.DPTF|UR_RewardToken id))
                (ats-pairs-bool:[bool] (ATS|NFR-Boolean_RT-RBT id ats-pairs true))
                (milestones:integer (length (UTILS.LIST|UC_Search ats-pairs-bool true)))  
            )
            (if (!= milestones 0)
                (let*
                    (
                        (rt-split-with-boolean:[decimal] (ATS|UC_BooleanDecimalCombiner id native-fee-amount milestones ats-pairs-bool))
                        (number-of-zeroes:integer (length (UTILS.LIST|UC_Search rt-split-with-boolean 0.0)))
                    )
                    (map
                        (lambda
                            (index:integer)
                            (if (at index ats-pairs-bool)
                                (ATS|XO_UpdateRoU (at index ats-pairs) id true true (at index rt-split-with-boolean))
                                true
                            )
                        )
                        (enumerate 0 (- (length ats-pairs) 1))
                    )
                    0.0
                )
                native-fee-amount
            )
        )
    )
    (defun ATS|NFR-Boolean_RT-RBT:[bool] (id:string ats-pairs:[string] rt-or-rbt:bool)
        @doc "Helper function used in the ATS|CPF Functions \
        \ Makes a [bool] using RT or RBT <nfr> values from a list of ATS Pair"
        (fold
            (lambda
                (acc:[bool] index:integer)
                (if rt-or-rbt
                    (if (ATS|UR_RT-Data (at index ats-pairs) id 1)
                        (UTILS.LIST|UC_AppendLast acc true)
                        (UTILS.LIST|UC_AppendLast acc false)
                    )
                    (if (ATS|UR_ColdNativeFeeRedirection (at index ats-pairs))
                        (UTILS.LIST|UC_AppendLast acc true)
                        (UTILS.LIST|UC_AppendLast acc false)
                    )
                )
            )
            []
            (enumerate 0 (- (length ats-pairs) 1))
        )
    )
    (defun ATS|UC_BooleanDecimalCombiner:[decimal] (id:string amount:decimal milestones:integer boolean:[bool])
        @doc "Helper function used in the ATS|CPF Functions"
        (UTILS.ATS|UC_SplitBalanceWithBooleans (BASIS.DPTF-DPMF|UR_Decimals id true) amount milestones boolean)
    )
    (defun ATS|UC_SolidifyUO:object{ATS|Unstake} (input:object{ATS|Unstake} remove-position:integer)
        @doc "Solidifies an ATS|Unstake Objects, by removing an RT and add the removed amount to its primal RT \
        \ Only does object computation, does not actualy modify Table Data"
        (let*
            (
                (values:[decimal] (at "reward-tokens" input))
                (cull-time:time (at "cull-time" input))
                (how-many-rts:integer (length values))
            )
            (enforce (and (> remove-position 0) (< remove-position how-many-rts)) "Invalid <remove-position>")
            (let*
                (
                    (primal:decimal (at 0 (at "reward-tokens" input)))
                    (removee:decimal (at remove-position (at "reward-tokens" input)))
                    (remove-lst:[decimal] (UTILS.LIST|UC_RemoveItemAt values remove-position))
                    (new-values:[decimal] (UTILS.LIST|UC_ReplaceAt remove-lst 0 (+ primal removee)))
                )
                { "reward-tokens"   : new-values
                , "cull-time"       : cull-time}
            )
        )
    )
    (defun ATS|UC_IzUnstakeObjectValid:bool (input:object{ATS|Unstake})
        @doc "Checks if an unstake Object is valid, meaning if it stores valid unstake Data"
        (let*
            (
                (values:[decimal] (at "reward-tokens" input))
                (sum-values:decimal (fold (+) 0.0 values))
            )
            (if (> sum-values 0.0)
                true
                false
            )
        )
    )
    (defun ATS|UC_ReshapeUO:object{ATS|Unstake} (input:object{ATS|Unstake} remove-position:integer)
        @doc "Reshapes Unstake Object, used in the Remove RT Functions."
        (let
            (
                (is-valid:bool (ATS|UC_IzUnstakeObjectValid input))
            )
            (if is-valid
                (ATS|UC_SolidifyUO input remove-position)
                input
            )
        )
    )
    (defun ATS|UC_MultiReshapeUO:[object{ATS|Unstake}] (input:[object{ATS|Unstake}] remove-position:integer)
        @doc "Reshapes an Unstake Object List"
        (fold
            (lambda
                (acc:[object{ATS|Unstake}] item:object{ATS|Unstake})
                (UTILS.LIST|UC_AppendLast acc (ATS|UC_ReshapeUO item remove-position))
            )
            []
            input
        )
    )
    ;;        [X] Data Creation|Composition Functions   [UCC]
    (defun ATS|UCC_MakeUnstakeObject:object{ATS|Unstake} (atspair:string time:time)
        @doc "Creates an unstake object"
        { "reward-tokens"   : (make-list (length (ATS|UR_RewardTokenList atspair)) 0.0)
        , "cull-time"       : time}
    )
    (defun ATS|UCC_MakeZeroUnstakeObject:object{ATS|Unstake} (atspair:string)
        @doc "Generates an Empty Unstake Object. Empty means position is opened for use"
        (ATS|UCC_MakeUnstakeObject atspair NULLTIME)
    )
    (defun ATS|UCC_MakeNegativeUnstakeObject:object{ATS|Unstake} (atspair:string)
        @doc "Generates a Nmpty Unstake Object. Negative means position is closed and cannot be used for unstaking"
        (ATS|UCC_MakeUnstakeObject atspair ANTITIME)
    )
    (defun ATS|UCC_ComposePrimaryRewardToken:object{ATS|RewardTokenSchema} (token:string nfr:bool)
        @doc "Composes a brand-new Reward Token object from input parameters"
        (ATS|UCC_RT token nfr 0.0 0.0)
    )
    (defun ATS|UCC_RT:object{ATS|RewardTokenSchema} (token:string nfr:bool r:decimal u:decimal)
        @doc "Composes a Reward Token object from input parameters"
        (enforce (>= r 0.0) "Negative Resident not allowed")
        (enforce (>= u 0.0) "Negative Unbonding not allowed")
        {"token"                    : token
        ,"nfr"                      : nfr
        ,"resident"                 : r
        ,"unbonding"                : u}
    )
    ;;            Administrative Usage Functions        [A]
    ;;       [xx] Client Usage FUNCTIONS                [C]
    (defun ATS|C_ChangeOwnership (patron:string atspair:string new-owner:string)
        @doc "Moves ATS <atspair> Ownership to <new-owner> DALOS Account"
        (with-capability (ATS|OWNERSHIP_CHANGE atspair new-owner)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS|UR_OwnerKonto atspair) DALOS.GAS_BIGGEST)
                true
            )
            (ATS|X_ChangeOwnership atspair new-owner)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_ToggleParameterLock (patron:string atspair:string toggle:bool)
        @doc "Sets the <parameter-lock> for the ATS Pair <atspair> to <toggle> \
            \ Unlocking <parameter-toggle> (setting it to false) comes with specific restrictions: \
            \       As many unlocks can be executed for a ATS Pair as needed \
            \       The Cost for unlock is (1000 IGNIS + 10 KDA )*(0 + <unlocks>)"
        (let
            (
                (ZG:bool (DALOS.IGNIS|URC_IsVirtualGasZero))
                (NZG:bool (DALOS.IGNIS|URC_IsNativeGasZero))
                (atspair-owner:string (ATS|UR_OwnerKonto atspair))
            )
            (with-capability (ATS|TOGGLE_PARAMETER-LOCK atspair toggle)
                (if (not ZG)
                    (DALOS.IGNIS|X_Collect patron atspair-owner DALOS.GAS_SMALL)
                    true
                )
                (let*
                    (
                        (toggle-costs:[decimal] (ATS|X_ToggleParameterLock atspair toggle))
                        (gas-costs:decimal (at 0 toggle-costs))
                        (kda-costs:decimal (at 1 toggle-costs))
                    )
                    (if (> gas-costs 0.0)
                        (with-capability (COMPOSE)
                            (if (not ZG)
                                (DALOS.IGNIS|X_Collect patron atspair-owner gas-costs)
                                true
                            )
                            (if (not NZG)
                                (DALOS.DALOS|C_TransferRawDalosFuel patron kda-costs)
                                true
                            )
                            (ATS|X_IncrementParameterUnlocks atspair)
                        )
                        true
                    )
                )
                (DALOS.DALOS|X_IncrementNonce patron)
            )
        )
    )
    (defun ATS|C_UpdateSyphon (patron:string atspair:string syphon:decimal)
        @doc "Updates the Syphon threshold"
        (with-capability (ATS|SYPHON atspair syphon)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS|X_UpdateSyphon atspair syphon)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_ToggleSyphoning (patron:string atspair:string toggle:bool)
        @doc "Toggles syphoning, which allows or disallows syphoning mechanic"
        (with-capability (ATS|SYPHONING atspair toggle)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS|X_ToggleSyphoning atspair toggle)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_ToggleFeeSettings (patron:string atspair:string toggle:bool fee-switch:integer)
        @doc "Toggles ATS Boolean Fee Parameters to <toggle> : \
        \ fee-switch = 0 : cold-native-fee-redirection (c-nfr) \
        \ fee-switch = 1 : cold-fee-redirection (c-fr) \ 
        \ fee-switch = 2 : hot-fee-redirection (h-fr) "
        (with-capability (ATS|TOGGLE_FEE atspair toggle fee-switch)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS|X_ToggleFeeSettings atspair toggle fee-switch)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_SetCRD (patron:string atspair:string soft-or-hard:bool base:integer growth:integer)
        @doc "Sets the Cold Recovery Duration based on input parameters"
        (with-capability (ATS|SET_CRD atspair soft-or-hard base growth)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS|X_SetCRD atspair soft-or-hard base growth)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_SetColdFee (patron:string atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        @doc "Sets Cold Recovery fee parameters"
        (with-capability (ATS|SET_COLD_FEE atspair fee-positions fee-thresholds fee-array)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS|X_SetColdFee atspair fee-positions fee-thresholds fee-array)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_SetHotFee (patron:string atspair:string promile:decimal decay:integer)
        @doc "Sets Cold Recovery fee parameters"
        (with-capability (ATS|SET_HOT_FEE atspair promile decay)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS|X_SetHotFee atspair promile decay)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_ToggleElite (patron:string atspair:string toggle:bool)
        @doc "Toggles <c-elite-mode> to <toggle>"
        (with-capability (ATS|TOGGLE_ELITE atspair toggle)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS|X_ToggleElite atspair toggle)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_TurnRecoveryOn (patron:string atspair:string cold-or-hot:bool)
        @doc "Turns <cold-recovery> or <hot-recovery> on"
        (with-capability (ATS|TOGGLE_RECOVERY atspair true cold-or-hot)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS|X_TurnRecoveryOn atspair cold-or-hot)
            (DALOS.DALOS|X_IncrementNonce patron)
            (ATS|C_EnsureActivationRoles patron atspair cold-or-hot)
        )
    )
    (defun ATS|C_TurnRecoveryOff (patron:string atspair:string cold-or-hot:bool)
        @doc "Turns <cold-recovery> or <hot-recovery> off"
        (with-capability (ATS|TOGGLE_RECOVERY atspair false cold-or-hot)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS|X_TurnRecoveryOff atspair cold-or-hot)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATS|C_EnsureActivationRoles (patron:string atspair:string cold-or-hot:bool)
        @doc "Ensure proper roles are being set up that can allow Cold or Hot Recovery Activation \
        \ Can be used by anyone which has ownership for the required Tokens"
        (let*
            (
                (rt-lst:[string] (ATS|UR_RewardTokenList atspair))
                (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                (c-rbt-fer:bool (BASIS.DPTF|UR_AccountRoleFeeExemption c-rbt ATS|SC_NAME))
                (c-fr:bool (ATS|UR_ColdRecoveryFeeRedirection atspair))
                
            )
            ;;Exemption Roles for all defined Reward Tokens - applies in both cases
            (ATS|C_SetMassRole patron atspair false)
            
            (if cold-or-hot
                (let
                    (
                        (c-rbt-burn-role:bool (BASIS.DPTF-DPMF|UR_AccountRoleBurn c-rbt ATS|SC_NAME true))
                        (c-rbt-mint-role:bool (BASIS.DPTF|UR_AccountRoleMint c-rbt ATS|SC_NAME))
                    )
                    ;;Exemption Role for the c-rbt, if it is <false>
                    (if (not c-rbt-fer)
                        (DPTF|C_ToggleFeeExemptionRole patron c-rbt ATS|SC_NAME true)
                        true
                    )
                    (if (not c-fr)
                        ;;Burn Roles for all defined Reward-Tokens if c-fr is set to false
                        (ATS|C_SetMassRole patron atspair true)
                        true
                    )
                    (if (not c-rbt-burn-role)
                        ;;Burn Role for the C-RBT
                        (DPTF-DPMF|C_ToggleBurnRole patron c-rbt ATS|SC_NAME true true)
                        true
                    )
                    (if (not c-rbt-mint-role)
                        ;;Mint Role for the C-RBT
                        (DPTF|C_ToggleMintRole patron c-rbt ATS|SC_NAME true)
                        true
                    )
                )
                (let*
                    (
                        (h-rbt:string (ATS|UR_HotRewardBearingToken atspair))
                        (h-fr:bool (ATS|UR_HotRecoveryFeeRedirection atspair))
                        (h-rbt-burn-role:bool (BASIS.DPTF-DPMF|UR_AccountRoleBurn h-rbt ATS|SC_NAME false))
                        (h-rbt-create-role:bool (BASIS.DPMF|UR_AccountRoleCreate h-rbt ATS|SC_NAME))
                        (h-rbt-add-q-role:bool (BASIS.DPMF|UR_AccountRoleNFTAQ h-rbt ATS|SC_NAME))
                    )
                    (if (not h-fr)
                        ;;Burn Roles for all defined Reward-Tokens if h-fr is set to false
                        (ATS|C_SetMassRole patron atspair true)
                        true
                    )
                    (if (not h-rbt-burn-role)
                        ;Burn Role for the H-RBT
                        (DPTF-DPMF|C_ToggleBurnRole patron h-rbt ATS|SC_NAME true false)
                        true
                    )
                    (if (not h-rbt-create-role)
                        ;;Create Role for the H-RBT
                        (DPMF|C_MoveCreateRole patron h-rbt ATS|SC_NAME)
                        true
                    )
                    (if (not h-rbt-add-q-role)
                        ;;Add-Quantity Role for the H-RBT
                        (DPMF|C_ToggleAddQuantityRole patron h-rbt ATS|SC_NAME true)
                        true
                    )
                )
            )
        )
    )
    (defun ATS|C_SetMassRole (patron:string atspair:string burn-or-exemption:bool)
        @doc "Ensures all RTs have either burn or fee-exemption role for ATS|SC_NAME"
        (map
            (lambda
                (reward-token:string)
                (let
                    (
                        (rt-br:bool (BASIS.DPTF-DPMF|UR_AccountRoleBurn reward-token ATS|SC_NAME true))
                        (rt-fer:bool (BASIS.DPTF|UR_AccountRoleFeeExemption reward-token ATS|SC_NAME))
                    )
                    (if (and (= rt-br false) burn-or-exemption)
                        (DPTF-DPMF|C_ToggleBurnRole patron reward-token ATS|SC_NAME true true)        
                        (if (and (= rt-fer false) (= burn-or-exemption false))
                            (DPTF|C_ToggleFeeExemptionRole patron reward-token ATS|SC_NAME true)
                            true
                        )
                    )
                )
            )
            (ATS|UR_RewardTokenList atspair)
        )
    )
    (defun ATS|C_Issue:string
        (
            patron:string
            account:string
            atspair:string
            index-decimals:integer
            reward-token:string
            rt-nfr:bool
            reward-bearing-token:string
            rbt-nfr:bool
        )
        @doc "Issue a new ATS-Pair"
        (with-capability (ATS|ISSUE (UTILS.DALOS|UCC_Makeid atspair) account reward-token reward-bearing-token)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_HUGE)
                true
            )
            (ATS|X_Issue account atspair index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr)
            (DALOS.DALOS|X_IncrementNonce patron)
            (BASIS.DPTF|XO_UpdateRewardToken (UTILS.DALOS|UCC_Makeid atspair) reward-token true)
            (BASIS.DPTF-DPMF|XO_UpdateRewardBearingToken reward-bearing-token (UTILS.DALOS|UCC_Makeid atspair) true)
            (ATS|C_EnsureActivationRoles patron (UTILS.DALOS|UCC_Makeid atspair) true)
            (UTILS.DALOS|UCC_Makeid atspair)
        )
    )
    (defun ATS|C_AddSecondary (patron:string atspair:string reward-token:string rt-nfr:bool)
        @doc "Add a secondary Reward Token for the ATS Pair <atspair>"
        (with-capability (ATS|ADD_SECONDARY atspair reward-token true)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS|UR_OwnerKonto atspair) DALOS.GAS_ISSUE)
                true
            )
            (BASIS.DPTF-DPMF|C_DeployAccount reward-token ATS|SC_NAME true)
            (ATS|X_AddSecondary atspair reward-token rt-nfr)
            (DALOS.DALOS|X_IncrementNonce patron)
            (BASIS.DPTF|XO_UpdateRewardToken atspair reward-token true)      
            (ATS|C_EnsureActivationRoles patron atspair true)
            (if (= (ATS|UC_IzPresentHotRBT atspair) true)
                (ATS|C_EnsureActivationRoles patron atspair false)
                true
            )
        )
    )
    (defun ATS|C_AddHotRBT (patron:string atspair:string hot-rbt:string)
        @doc "Add a DPMF as <h-rbt> for the ATS Pair <atspair>"
        (with-capability (ATS|ADD_SECONDARY atspair hot-rbt false)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS|UR_OwnerKonto atspair) DALOS.GAS_ISSUE)
                true
            )
            (BASIS.DPTF-DPMF|C_DeployAccount hot-rbt ATS|SC_NAME false)
            (ATS|X_AddHotRBT atspair hot-rbt)
            (DALOS.DALOS|X_IncrementNonce patron)
            (BASIS.DPTF-DPMF|XO_UpdateRewardBearingToken hot-rbt atspair false)
            (ATS|C_EnsureActivationRoles patron atspair false)
        )
    )
    (defun ATS|C_Fuel (patron:string fueler:string atspair:string reward-token:string amount:decimal)
        @doc "Client Function for fueling an ATS Pair"
        (with-capability (ATS|FUEL atspair reward-token)
            ;;1]Fueler transfer the reward-token to ATS|SC_NAME and an update of Resident Amounts is performed
            (DPTF|CM_Transfer patron reward-token fueler ATS|SC_NAME amount)
            (ATS|XO_UpdateRoU atspair reward-token true true amount)
        )
    )
    (defun ATS|C_Coil:decimal (patron:string coiler:string atspair:string coil-token:string amount:decimal)
        @doc "Autostakes <coil-token> to the <atspair> ATS-Pair, receiving RBT"
        (with-capability (ATS|COIL_OR_CURL atspair coil-token)
            (let
                (
                    (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                    (c-rbt-amount:decimal (ATS|UC_RBT atspair coil-token amount))
                )
            ;;1]Coiler transfers coil-token to ATS|SC_NAME and the Resident Amounts are updated
                (DPTF|CM_Transfer patron coil-token coiler ATS|SC_NAME amount)
                (ATS|XO_UpdateRoU atspair coil-token true true amount)
            ;;2]ATS|SC_NAME mints c-rbt
                (BASIS.DPTF|C_Mint patron c-rbt ATS|SC_NAME c-rbt-amount false)
            ;;4]ATS|SC_NAME transfers the minted c-rbt to coiler
                (DPTF|CM_Transfer patron c-rbt ATS|SC_NAME coiler c-rbt-amount)
                ;;Function returns the c-rbt minted amount
                c-rbt-amount
            )
        )
    )
    (defun ATS|C_Curl:decimal (patron:string curler:string atspair1:string atspair2:string rt:string amount:decimal)
        @doc "Autostakes <rt> token twice using <atspair1> and <atspair2> \
        \ <rt> must be RBT in <atspair1> and RT in <atspair2> for this to work"
        (with-capability (ATS|COIL_OR_CURL atspair1 rt)
            (let*
                (
                    (c-rbt1:string (ATS|UR_ColdRewardBearingToken atspair1))
                    (c-rbt1-amount:decimal (ATS|UC_RBT atspair1 rt amount))
                    (c-rbt2:string (ATS|UR_ColdRewardBearingToken atspair2))
                    (c-rbt2-amount:decimal (ATS|UC_RBT atspair2 c-rbt1 c-rbt1-amount))
                )
            ;;1]Curler transfers rt to ATS|SC_NAME and the Resident Amounts are updated
                (DPTF|CM_Transfer patron rt curler ATS|SC_NAME amount)
                (ATS|XO_UpdateRoU atspair1 rt true true amount)
            ;;2]ATS|SC_NAME mints and retains the c-rbt1 and updates the Resident Amounts
                (BASIS.DPTF|C_Mint patron c-rbt1 ATS|SC_NAME c-rbt1-amount false)
                (ATS|XO_UpdateRoU atspair2 c-rbt1 true true c-rbt1-amount)
            ;;3]ATS|SC_NAME mints c-rbt2
                (BASIS.DPTF|C_Mint patron c-rbt2 ATS|SC_NAME c-rbt2-amount false)
            ;;4]ATS|SC_NAME transfers the minted c-rbt2 to curler
                (DPTF|CM_Transfer patron c-rbt2 ATS|SC_NAME curler c-rbt2-amount)
                ;;Function returns the c-rbt-2 minted amount
                c-rbt2-amount
            )
        )
    )
    (defun ATS|C_HotRecovery (patron:string recoverer:string atspair:string ra:decimal)
        @doc "Executes Hot Recovery for <ats-pair> by <recoverer> with the <ra> amount of Cold-Reward-Bearing-Token"
        (with-capability (ATS|HOT_RECOVERY recoverer atspair ra)
            (let*
                (
                    (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                    (h-rbt:string (ATS|UR_HotRewardBearingToken atspair))
                    (present-time:time (at "block-time" (chain-data)))
                    (meta-data-obj:object{ATS|Hot} { "mint-time" : present-time})
                    (meta-data:[object] [meta-data-obj])
                    (new-nonce:integer (+ (BASIS.DPMF|UR_NoncesUsed h-rbt) 1))
                )
            ;;1]Recoverer transfers c-rbt to the ATS|SC_NAME
                (DPTF|CM_Transfer patron c-rbt recoverer ATS|SC_NAME ra)
            ;;2]ATS|SC_NAME burns c-rbt
                (BASIS.DPTF|C_Burn patron c-rbt ATS|SC_NAME ra)
            ;;3]ATS|SC_NAME mints h-rbt
                (BASIS.DPMF|C_Mint patron h-rbt ATS|SC_NAME ra meta-data)
            ;;4]ATS|SC_NAME transfers h-rbt to recoverer
                (DPMF|CM_Transfer patron h-rbt new-nonce ATS|SC_NAME recoverer ra)
            )
        )
    )
    (defun ATS|C_ColdRecovery (patron:string recoverer:string atspair:string ra:decimal)
        @doc "Executes Cold Recovery for <ats-pair> by <recoverer> with the <ra> amount of Cold-Reward-Bearing-Token"
        (with-capability (ATS|COLD_RECOVERY recoverer atspair ra)
            (ATS|X_DeployAccount atspair recoverer)
            (let*
                (
                    (rt-lst:[string] (ATS|UR_RewardTokenList atspair))
                    (c-rbt:string (ATS|UR_ColdRewardBearingToken atspair))
                    (c-rbt-precision:integer (BASIS.DPTF-DPMF|UR_Decimals c-rbt true))
                    (usable-position:integer (ATS|UC_WhichPosition atspair ra recoverer))
                    (fee-promile:decimal (ATS|UC_ColdRecoveryFee atspair ra usable-position))
                    (c-rbt-fee-split:[decimal] (UTILS.ATS|UC_PromilleSplit fee-promile ra c-rbt-precision))

                    (c-fr:bool (ATS|UR_ColdRecoveryFeeRedirection atspair))
                    (cull-time:time (ATS|UC_CullColdRecoveryTime atspair recoverer))

                    ;;for false
                    (negative-c-fr:[decimal] (ATS|UC_RTSplitAmounts atspair (at 1 c-rbt-fee-split)))    ;;feeul

                    ;;for true
                    (positive-c-fr:[decimal] (ATS|UC_RTSplitAmounts atspair (at 0 c-rbt-fee-split)))    ;;remainderu
                )
            ;;1]Recoverer transfers c-rbt to the ATS|SC_NAME
                (DPTF|CM_Transfer patron c-rbt recoverer ATS|SC_NAME ra)
            ;;2]ATS|SC_NAME burns c-rbt and handles c-fr
                (BASIS.DPTF|C_Burn patron c-rbt ATS|SC_NAME ra)
            ;;3]ATS|Pairs is updated with the proper information (unbonding RTs), while burning any fee RTs if needed
                (map
                    (lambda
                        (index:integer)
                        (ATS|XO_UpdateRoU atspair (at index rt-lst) false true (at index positive-c-fr))
                        (ATS|XO_UpdateRoU atspair (at index rt-lst) true false (at index positive-c-fr))
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
                (if (not c-fr)
                    (map
                        (lambda
                            (index:integer)
                            (BASIS.DPTF|C_Burn patron (at index rt-lst) ATS|SC_NAME (at index negative-c-fr))
                        )
                        (enumerate 0 (- (length rt-lst) 1))
                    )
                    true
                )
            ;;4]ATS|Ledger is updated with the proper information
                (ATS|X_StoreUnstakeObject atspair recoverer usable-position 
                    { "reward-tokens"   : positive-c-fr 
                    , "cull-time"       : cull-time}
                )
            )
            ;;5]At last, a Normalisation takes place for the recoverer
            (ATS|X_Normalize atspair recoverer)
        )
    )
    (defun ATS|C_Cull:[decimal] (patron:string culler:string atspair:string)
        @doc "Culls <atspair> for <culler>. Culling returns all elapsed past Cold-Recoveries executed by <culler> \
        \ Returns culled values. If no cullable values exists, returns a list of zeros, since nothing has been culled"
        (with-capability (ATS|CULL culler atspair)
            (let*
                (
                    (rt-lst:[string] (ATS|UR_RewardTokenList atspair))
                    (c0:[decimal] (ATS|X_MultiCull atspair culler))
                    (c1:[decimal] (ATS|X_SingleCull atspair culler 1))
                    (c2:[decimal] (ATS|X_SingleCull atspair culler 2))
                    (c3:[decimal] (ATS|X_SingleCull atspair culler 3))
                    (c4:[decimal] (ATS|X_SingleCull atspair culler 4))
                    (c5:[decimal] (ATS|X_SingleCull atspair culler 5))
                    (c6:[decimal] (ATS|X_SingleCull atspair culler 6))
                    (c7:[decimal] (ATS|X_SingleCull atspair culler 7))
                    (ca:[[decimal]] [c0 c1 c2 c3 c4 c5 c6 c7])
                    (cw:[decimal] (UTILS.UTILS|UC_AddArray ca))
                )
                (map
                    (lambda
                        (idx:integer)
                        (if (!= (at idx cw) 0.0)
                            (with-capability (COMPOSE)
                                (ATS|XO_UpdateRoU atspair (at idx rt-lst) false false (at idx cw))
                                (DPTF|CM_Transfer patron (at idx rt-lst) ATS|SC_NAME culler (at idx cw))
                            )
                            true
                        )
                    )
                    (enumerate 0 (- (length rt-lst) 1))
                )
                (ATS|X_Normalize atspair culler)
                cw
            )
        )
    )
    
    (defun ATS|C_RevokeMint (patron:string id:string)
        @doc "Used when revoking <role-mint> from ATS|SC_NAME \
        \ and <id> is a Cold-RBT for any ATS-Pair"
        (if (BASIS.ATS|UC_IzRBT id true)
            (ATS|C_MassTurnColdRecoveryOff patron id)  
            true        
        )
    )
    (defun ATS|C_RevokeFeeExemption (patron:string id:string)
        @doc "Used when revoking <role-fee-exemption> from ATS|SC_NAME \
        \ and <id> is a RT for any ATS-Pair"
        (if (BASIS.ATS|UC_IzRT id)
            (ATS|C_MassTurnColdRecoveryOff patron id)  
            true
        )
    )
    (defun ATS|C_RevokeCreateOrAddQ (patron:string id:string)
        @doc "Used when revoking either <role-nft-add-quantity> or <role-nft-create> from ATS|SC_NAME \
        \ and <id> is a Hot-RBT for any ATS-Pair"
        (if (BASIS.ATS|UC_IzRBT id false)
            (ATS|C_TurnRecoveryOff patron (BASIS.DPMF|UR_RewardBearingToken id) false)
            true
        )
    )
    (defun ATS|C_RevokeBurn (patron:string id:string cold-or-hot:bool)
        @doc "Used when revoking either <role-burn> or <role-nft-burn> from ATS|SC_NAME \
        \ and <id> is either RT, Cold-RBT or Hot-RBT in any ATS-Pair \
        \       <id> is RT: if <c-fr> is false, set to true for all ATS-Pairs the RT is part of \
        \       <id> is RT: if <h-fr> is false, set to true for all ATS-Pairs the RT is part of \
        \       <id> is Cold-RBT: stops Cold Recovery \
        \       <id> is Hot-RBT: stops Hot Recovery"
        (if (BASIS.ATS|UC_IzRT id)
            (map
                (lambda
                    (atspair:string)
                    (with-capability (COMPOSE)
                        (if (not (ATS|UR_ColdRecoveryFeeRedirection atspair))
                            (ATS|C_ToggleFeeSettings patron atspair true 1)
                            true
                        )
                        (if (not (ATS|UR_HotRecoveryFeeRedirection atspair))
                            (ATS|C_ToggleFeeSettings patron atspair true 2)
                            true
                        )
                    )
                )
                (BASIS.DPTF|UR_RewardToken id)
            )
            (if (ATS|UC_IzRBT id cold-or-hot)
                (if (= cold-or-hot true)
                    (ATS|C_MassTurnColdRecoveryOff patron id)
                    (if (= (ATS|UR_ToggleHotRecovery (BASIS.DPMF|UR_RewardBearingToken id)) true)
                        (ATS|C_TurnRecoveryOff patron (BASIS.DPMF|UR_RewardBearingToken id) false)
                        true
                    )
                )
            )
        )
    )
    (defun ATS|C_MassTurnColdRecoveryOff (patron:string id:string)
        @doc "Turns Cold Recovery off for all ATS-Pairs that have <id> as Cold-RBT"
        (map
            (lambda
                (atspair:string)
                (if (= (ATS|UR_ToggleColdRecovery atspair) true)
                    (ATS|C_TurnRecoveryOff patron atspair true)
                    true
                )
            )
            (BASIS.DPTF|UR_RewardBearingToken id)
        )
    )
    ;;       [xx] Auxiliary Usage Functions             [X]
    (defun ATS|X_ChangeOwnership (atspair:string new-owner:string)
        (require-capability (ATS|X_OWNERSHIP_CHANGE atspair new-owner))
        (update ATS|Pairs atspair
            {"owner-konto"                      : new-owner}
        )
    )
    (defun ATS|X_ToggleParameterLock:[decimal] (atspair:string toggle:bool)
        (require-capability (ATS|X_TOGGLE_PARAMETER-LOCK atspair toggle))
        (update ATS|Pairs atspair
            { "parameter-lock" : toggle}
        )
        (if (= toggle true)
            [0.0 0.0]
            (UTILS.ATS|UC_UnlockPrice (ATS|UR_Unlocks atspair))
        )
    )
    (defun ATS|X_IncrementParameterUnlocks (atspair:string)
        (require-capability (ATS|INCREMENT-LOCKS))
        (with-read ATS|Pairs atspair
            { "unlocks" := u }
            (update ATS|Pairs atspair
                {"unlocks" : (+ u 1)}
            )
        )
    )
    (defun ATS|X_UpdateSyphon (atspair:string syphon:decimal)
        (require-capability (ATS|X_SYPHON atspair syphon))
        (update ATS|Pairs atspair
            {"syphon"                           : syphon}
        )
    )
    (defun ATS|X_ToggleSyphoning (atspair:string toggle:bool)
        (require-capability (ATS|X_SYPHONING atspair toggle))
        (update ATS|Pairs atspair
            {"syphoning"                        : toggle}
        )
    )
    (defun ATS|X_ToggleFeeSettings (atspair:string toggle:bool fee-switch:integer)
        (require-capability (ATS|X_TOGGLE_FEE atspair toggle fee-switch))
        (if (= fee-switch 0)
            (update ATS|Pairs atspair
                { "c-nfr" : toggle}
            )
            (if (= fee-switch 1)
                (update ATS|Pairs atspair
                    { "c-fr" : toggle}
                )
                (update ATS|Pairs atspair
                    { "h-fr" : toggle}
                )
            )
        )
    )
    (defun ATS|X_SetCRD (atspair:string soft-or-hard:bool base:integer growth:integer)
        (require-capability (ATS|X_SET_CRD atspair soft-or-hard base growth))
        (if (= soft-or-hard true)
            (update ATS|Pairs atspair
                { "c-duration" : (UTILS.ATS|UC_MakeSoftIntervals base growth)}
            )
            (update ATS|Pairs atspair
                { "c-duration" : (UTILS.ATS|UC_MakeHardIntervals base growth)}
            )
        )
    )
    (defun ATS|X_SetColdFee (atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        (require-capability (ATS|X_SET_COLD_FEE atspair fee-positions fee-thresholds fee-array))
        (update ATS|Pairs atspair
            { "c-positions"     : fee-positions
            , "c-limits"        : fee-thresholds 
            , "c-array"         : fee-array}
        )
    )
    (defun ATS|X_SetHotFee (atspair:string promile:decimal decay:integer)
        (require-capability (ATS|X_SET_HOT_FEE atspair promile decay))
        (update ATS|Pairs atspair
            { "h-promile"       : promile
            , "h-decay"         : decay}
        )
    )
    (defun ATS|X_ToggleElite (atspair:string toggle:bool)
        (require-capability (ATS|X_TOGGLE_ELITE atspair toggle))
        (update ATS|Pairs atspair
            { "c-elite-mode" : toggle}
        )
    )
    (defun ATS|X_TurnRecoveryOn (atspair:string cold-or-hot:bool)
        (require-capability (ATS|X_RECOVERY-ON atspair cold-or-hot))
        (if (= cold-or-hot true)
            (update ATS|Pairs atspair
                { "cold-recovery" : true}
            )
            (update ATS|Pairs atspair
                { "hot-recovery" : true}
            )
        )
    )
    (defun ATS|X_TurnRecoveryOff (atspair:string cold-or-hot:bool)
        (require-capability (ATS|X_RECOVERY-OFF atspair cold-or-hot))
        (if (= cold-or-hot true)
            (update ATS|Pairs atspair
                { "cold-recovery" : false}
            )
            (update ATS|Pairs atspair
                { "hot-recovery" : false}
            )
        )
    )
    (defun ATS|X_Issue
        (
            account:string
            atspair:string
            index-decimals:integer
            reward-token:string
            rt-nfr:bool
            reward-bearing-token:string
            rbt-nfr:bool
        )
        (UTILS.DALOS|UEV_Decimals index-decimals)
        (UTILS.DALOS|UEV_TokenName atspair)
        (BASIS.DPTF-DPMF|UEV_id reward-token true)
        (BASIS.DPTF-DPMF|UEV_id reward-bearing-token true)
        (require-capability (ATS|X_ISSUE (UTILS.DALOS|UCC_Makeid atspair) account reward-token reward-bearing-token))
        (insert ATS|Pairs (UTILS.DALOS|UCC_Makeid atspair)
            {"owner-konto"                          : account
            ,"can-change-owner"                     : true
            ,"parameter-lock"                       : false
            ,"unlocks"                              : 0
            ;;Index
            ,"pair-index-name"                      : atspair
            ,"index-decimals"                       : index-decimals
            ,"syphon"                               : 1.0
            ,"syphoning"                            : false
            ;;Reward Tokens
            ,"reward-tokens"                        : [(ATS|UCC_ComposePrimaryRewardToken reward-token rt-nfr)]
            ;;Cold Reward Bearing Token Info
            ,"c-rbt"                                : reward-bearing-token
            ,"c-nfr"                                : rbt-nfr
            ,"c-positions"                          : -1
            ,"c-limits"                             : [0.0]
            ,"c-array"                              : [[0.0]]
            ,"c-fr"                                 : true
            ,"c-duration"                           : (UTILS.ATS|UC_MakeSoftIntervals 300 6)
            ,"c-elite-mode"                         : false
            ;;Hot Reward Bearing Token Info
            ,"h-rbt"                                : UTILS.BAR
            ,"h-promile"                            : 100.0
            ,"h-decay"                              : 1
            ,"h-fr"                                 : true
            ;; Activation Toggles
            ,"cold-recovery"                        : false
            ,"hot-recovery"                         : false
            }
        )
        (BASIS.DPTF-DPMF|C_DeployAccount reward-token account true)
        (BASIS.DPTF-DPMF|C_DeployAccount reward-bearing-token account true)
        (BASIS.DPTF-DPMF|C_DeployAccount reward-token ATS|SC_NAME true)
        (BASIS.DPTF-DPMF|C_DeployAccount reward-bearing-token ATS|SC_NAME true)
    )
    (defun ATS|X_AddSecondary (atspair:string reward-token:string rt-nfr:bool)
        (require-capability (ATS|X_ADD_SECONDARY atspair reward-token true))
        (with-read ATS|Pairs atspair
            { "reward-tokens" := rt }
            (update ATS|Pairs atspair
                {"reward-tokens" : (UTILS.LIST|UC_AppendLast rt (ATS|UCC_ComposePrimaryRewardToken reward-token rt-nfr))}
            )
        )
    )
    (defun ATS|X_AddHotRBT (atspair:string hot-rbt:string)
        (require-capability (ATS|X_ADD_SECONDARY atspair hot-rbt false))
        (update ATS|Pairs atspair
            {"h-rbt" : hot-rbt}
        )
    )
    (defun ATS|XO_ReshapeUnstakeAccount (atspair:string account:string rp:integer)
        (enforce-guard (ATS|C_ReadPolicy "OUROBOROS|ReshapeUnstakeAccount"))
        (with-capability (ATS|RESHAPE)
            (ATS|XP_ReshapeUnstakeAccount atspair account rp)
        )
    )
    (defun ATS|XP_ReshapeUnstakeAccount (atspair:string account:string rp:integer)
        @doc "Reshapes an Unstake Account"
        (require-capability (ATS|RESHAPE))
        (with-read ATS|Ledger (concat [atspair UTILS.BAR account])
            { "P0"      := p0 
            , "P1"      := p1
            , "P2"      := p2
            , "P3"      := p3
            , "P4"      := p4
            , "P5"      := p5
            , "P6"      := p6
            , "P7"      := p7}
            (update ATS|Ledger (concat [atspair UTILS.BAR account])
                { "P0"  : (ATS|UC_MultiReshapeUO p0 rp)
                , "P1"  : (ATS|UC_ReshapeUO p1 rp)
                , "P2"  : (ATS|UC_ReshapeUO p2 rp)
                , "P3"  : (ATS|UC_ReshapeUO p3 rp)
                , "P4"  : (ATS|UC_ReshapeUO p4 rp)
                , "P5"  : (ATS|UC_ReshapeUO p5 rp)
                , "P6"  : (ATS|UC_ReshapeUO p6 rp)
                , "P7"  : (ATS|UC_ReshapeUO p7 rp)}
            )
        )
    )
    (defun ATS|XO_RemoveSecondary (atspair:string reward-token:string)
        (enforce-guard (ATS|C_ReadPolicy "OUROBOROS|RemoveSecondaryRT"))
        (with-capability (ATS|RM_SECONDARY_RT)
            (ATS|XP_RemoveSecondary atspair reward-token)
        )
        
    )
    (defun ATS|XP_RemoveSecondary (atspair:string reward-token:string)
        (require-capability (ATS|RM_SECONDARY_RT))
        (with-read ATS|Pairs atspair
            { "reward-tokens" := rt }
            (update ATS|Pairs atspair
                {"reward-tokens" : 
                    (UTILS.LIST|UC_RemoveItem  rt (at (ATS|UC_RewardTokenPosition atspair reward-token) rt))
                }
            )
        )
    )
    (defun ATS|XO_UpdateRoU (atspair:string reward-token:string rou:bool direction:bool amount:decimal)
        (enforce-one
            "Update Resident and/or Amounts in the ATS-Pair not allowed"
            [
                (enforce-guard (create-capability-guard (ATS|UPDATE_ROU)))
                (enforce-guard (ATS|C_ReadPolicy "OUROBOROS|UpdateROU"))
            ]
        )
        (with-capability (ATS|UPDATE_ROU_PUR)
            (ATS|XP_UpdateRoU atspair reward-token rou direction amount)
        )
    )
    (defun ATS|XP_UpdateRoU (atspair:string reward-token:string rou:bool direction:bool amount:decimal)
        (require-capability (ATS|UPDATE_ROU_PUR))
        (let*
            (
                (rtp:integer (ATS|UC_RewardTokenPosition atspair reward-token))
                (nfr:bool (ATS|UR_RT-Data atspair reward-token 1))
                (resident:decimal (ATS|UR_RT-Data atspair reward-token 2))
                (unbonding:decimal (ATS|UR_RT-Data atspair reward-token 3))
                (new-rt:object{ATS|RewardTokenSchema} 
                    (if (= rou true)
                        (if (= direction true)
                            (ATS|UCC_RT reward-token nfr (+ resident amount) unbonding)
                            (ATS|UCC_RT reward-token nfr (- resident amount) unbonding)
                        )
                        (if (= direction true)
                            (ATS|UCC_RT reward-token nfr resident (+ unbonding amount))
                            (ATS|UCC_RT reward-token nfr resident (- unbonding amount))
                        )
                    )
                )
            )
            (with-read ATS|Pairs atspair
                { "reward-tokens" := rt }
                (update ATS|Pairs atspair
                    { "reward-tokens" : (UTILS.LIST|UC_ReplaceItem rt (at rtp rt) new-rt)}
                )
            )
        )
    )
    (defun ATS|X_StoreUnstakeObjectList (atspair:string account:string obj:[object{ATS|Unstake}])
        (require-capability (ATS|UPDATE_LEDGER))
        (update ATS|Ledger (concat [atspair UTILS.BAR account])
            { "P0" : obj}
        )
    )
    (defun ATS|X_StoreUnstakeObject (atspair:string account:string position:integer obj:object{ATS|Unstake})
        (require-capability (ATS|UPDATE_LEDGER))
        (with-read ATS|Ledger (concat [atspair UTILS.BAR account])
            { "P0"  := p0 , "P1"  := p1 , "P2"  := p2 , "P3"  := p3, "P4"  := p4, "P5"  := p5, "P6"  := p6, "P7"  := p7 }
            (if (= position -1)
                (if (and 
                        (= (length p0) 1)
                        (= 
                            (at 0 p0) 
                            (ATS|UCC_MakeZeroUnstakeObject atspair)
                        )
                    )
                    (update ATS|Ledger (concat [atspair UTILS.BAR account])
                        { "P0"  : [obj]}
                    )
                    (update ATS|Ledger (concat [atspair UTILS.BAR account])
                        { "P0"  : (UTILS.LIST|UC_AppendLast p0 obj)}
                    )
                )
                (if (= position 1)
                    (update ATS|Ledger (concat [atspair UTILS.BAR account])
                        { "P1"  : obj}
                    )
                    (if (= position 2)
                        (update ATS|Ledger (concat [atspair UTILS.BAR account])
                            { "P2"  : obj}
                        )
                        (if (= position 3)
                            (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                { "P3"  : obj}
                            )
                            (if (= position 4)
                                (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                    { "P4"  : obj}
                                )
                                (if (= position 5)
                                    (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                        { "P5"  : obj}
                                    )
                                    (if (= position 6)
                                        (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                            { "P6"  : obj}
                                        )
                                        (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                            { "P7"  : obj}
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    (defun ATS|X_DeployAccount (atspair:string account:string)
        (require-capability (ATS|DEPLOY atspair account))
        (let
            (
                (zero:object{ATS|Unstake} (ATS|UCC_MakeZeroUnstakeObject atspair))
                (negative:object{ATS|Unstake} (ATS|UCC_MakeNegativeUnstakeObject atspair))
            )
            (with-default-read ATS|Ledger (concat [atspair UTILS.BAR account])
                { "P0"  : [zero]
                , "P1"  : negative
                , "P2"  : negative
                , "P3"  : negative
                , "P4"  : negative
                , "P5"  : negative
                , "P6"  : negative
                , "P7"  : negative
                }
                { "P0"  := p0
                , "P1"  := p1
                , "P2"  := p2
                , "P3"  := p3
                , "P4"  := p4
                , "P5"  := p5
                , "P6"  := p6
                , "P7"  := p7
                }
                (write ATS|Ledger (concat [atspair UTILS.BAR account])
                    { "P0"  : p0
                    , "P1"  : p1
                    , "P2"  : p2
                    , "P3"  : p3
                    , "P4"  : p4
                    , "P5"  : p5
                    , "P6"  : p6
                    , "P7"  : p7
                    }
                )
            )
        )
        (ATS|X_Normalize atspair account)
    )
    (defun ATS|X_Normalize (atspair:string account:string)
        (require-capability (ATS|NORMALIZE_LEDGER atspair account))
        (with-read ATS|Ledger (concat [atspair UTILS.BAR account])
            { "P0"  := p0 , "P1"  := p1 , "P2"  := p2 , "P3"  := p3, "P4"  := p4, "P5"  := p5, "P6"  := p6, "P7"  := p7 }
            (let
                (
                    (zero:object{ATS|Unstake} (ATS|UCC_MakeZeroUnstakeObject atspair))
                    (negative:object{ATS|Unstake} (ATS|UCC_MakeNegativeUnstakeObject atspair))
                    (positions:integer (ATS|UR_ColdRecoveryPositions atspair))
                    (elite:bool (ATS|UR_EliteMode atspair))
                    (major-tier:integer (DALOS.DALOS|UR_Elite-Tier-Major account))
                )
                (if (= positions -1)
                    (update ATS|Ledger (concat [atspair UTILS.BAR account])
                        {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [zero] )
                        ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 negative)
                        ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 negative)
                        ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 negative)
                        ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 negative)
                        ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 negative)
                        ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                        ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                        }
                    )
                    (if (= positions 1)
                        (update ATS|Ledger (concat [atspair UTILS.BAR account])
                            {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                            ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                            ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 negative)
                            ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 negative)
                            ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 negative)
                            ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 negative)
                            ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                            ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                            }
                        )
                        (if (= positions 2)
                            (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 negative)
                                ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 negative)
                                ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 negative)
                                ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                                ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                                }
                            )
                            (if (= positions 3)
                                (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                    {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                    ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                    ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                    ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 zero)
                                    ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 negative)
                                    ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 negative)
                                    ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                                    ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                                    }
                                )
                                (if (= positions 4)
                                    (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                        {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                        ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                        ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                        ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 zero)
                                        ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 zero)
                                        ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 negative)
                                        ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                                        ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                                        }
                                    )
                                    (if (= positions 5)
                                        (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                            {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                            ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                            ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                            ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 zero)
                                            ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 zero)
                                            ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 zero)
                                            ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 negative)
                                            ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                                            }
                                        )
                                        (if (= positions 6)
                                            (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                                {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                                ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                                ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                                ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 zero)
                                                ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 zero)
                                                ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 zero)
                                                ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 zero)
                                                ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 negative)
                                                }
                                            )
                                            (if (not elite)
                                                (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                                    {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                                    ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                                    ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 zero)
                                                    ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 zero)
                                                    ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 zero)
                                                    ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 zero)
                                                    ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 zero)
                                                    ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 zero)
                                                    }
                                                )
                                                (update ATS|Ledger (concat [atspair UTILS.BAR account])
                                                    {"P0"       : (if (and (!= p0 [zero]) (!= p0 [negative])) p0 [negative] )
                                                    ,"P1"       : (if (and (!= p1 zero) (!= p1 negative)) p1 zero)
                                                    ,"P2"       : (if (and (!= p2 zero) (!= p2 negative)) p2 (if (>= major-tier 2) zero negative))
                                                    ,"P3"       : (if (and (!= p3 zero) (!= p3 negative)) p3 (if (>= major-tier 3) zero negative))
                                                    ,"P4"       : (if (and (!= p4 zero) (!= p4 negative)) p4 (if (>= major-tier 4) zero negative))
                                                    ,"P5"       : (if (and (!= p5 zero) (!= p5 negative)) p5 (if (>= major-tier 5) zero negative))
                                                    ,"P6"       : (if (and (!= p6 zero) (!= p6 negative)) p6 (if (>= major-tier 6) zero negative))
                                                    ,"P7"       : (if (and (!= p7 zero) (!= p7 negative)) p7 (if (>= major-tier 7) zero negative))
                                                    }
                                                )
                                            ) 
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            ) 
        )
    )
    (defun ATS|X_SingleCull:[decimal] (atspair:string account:string position:integer)
        (let*
            (
                (zero:object{ATS|Unstake} (ATS|UCC_MakeZeroUnstakeObject atspair))
                (unstake-obj:object{ATS|Unstake} (ATS|UR_P1-7 atspair account position))
                (rt-amounts:[decimal] (at "reward-tokens" unstake-obj))
                (l:integer (length rt-amounts))
                (empty:[decimal] (make-list l 0.0))
                (cull-output:[decimal] (ATS|UC_CullValue unstake-obj))
            )
            (if (!= cull-output empty)
                (ATS|X_StoreUnstakeObject atspair account position zero)
                true
            )
            cull-output
        )
    )
    (defun ATS|X_MultiCull:[decimal] (atspair:string account:string)
        (let*
            (
                (zero:object{ATS|Unstake} (ATS|UCC_MakeZeroUnstakeObject atspair))
                (negative:object{ATS|Unstake} (ATS|UCC_MakeNegativeUnstakeObject atspair))
                (p0:[object{ATS|Unstake}] (ATS|UR_P0 atspair account))
                (p0l:integer (length p0))
                (bl:[bool]
                    (fold
                        (lambda
                            (acc:[bool] item:object{ATS|Unstake})
                            (UTILS.LIST|UC_AppendLast acc (ATS|UC_IzCullable item))
                        )
                        []
                        p0
                    )
                )
                (zero-output:[decimal] (make-list (length (ATS|UR_RewardTokenList atspair)) 0.0))
                (cullables:[integer] (UTILS.LIST|UC_Search bl true))
                (immutables:[integer] (UTILS.LIST|UC_Search bl false))
                (how-many-cullables:integer (length cullables))
            )
            (if (= how-many-cullables 0)
                zero-output
                (let*
                    (
                        (after-cull:[object{ATS|Unstake}]
                            (if (< how-many-cullables p0l)
                                (fold
                                    (lambda
                                        (acc:[object{ATS|Unstake}] idx:integer)
                                        (UTILS.LIST|UC_AppendLast acc (at (at idx immutables) p0))
                                    )
                                    []
                                    (enumerate 0 (- (length immutables) 1))
                                )
                                [zero]
                            )
                        )
                        (to-be-culled:[object{ATS|Unstake}]
                            (fold
                                (lambda
                                    (acc:[object{ATS|Unstake}] idx:integer)
                                    (UTILS.LIST|UC_AppendLast acc (at (at idx cullables) p0))
                                )
                                []
                                (enumerate 0 (- (length cullables) 1))
                            )
                        )
                        (culled-values:[[decimal]]
                            (fold
                                (lambda
                                    (acc:[[decimal]] idx:integer)
                                    (UTILS.LIST|UC_AppendLast acc (ATS|UC_CullValue (at idx to-be-culled)))
                                )
                                []
                                (enumerate 0 (- (length to-be-culled) 1))
                            )
                        )
                        (summed-culled-values:[decimal] (UTILS.UTILS|UC_AddArray culled-values))
                    )
                    (ATS|X_StoreUnstakeObjectList atspair account after-cull)
                    summed-culled-values
                )
            )
        )
    )
)
;;Policies Table
(create-table ATS|PoliciesTable)
;;[A] ATS Tables
(create-table ATS|Pairs)
(create-table ATS|Ledger)