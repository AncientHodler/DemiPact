;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module ATSI GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (ATSI-ADMIN))
    )
    (defcap ATSI-ADMIN ()
        (enforce-one
            "ATSI Autostake Admin not satisfed"
            [
                (enforce-guard G-MD_ATSI)
                (enforce-guard G-SC_ATSI)
            ]
        )
    )

    (defconst G-MD_ATSI   (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_ATSI   (keyset-ref-guard ATS.ATS|SC_KEY))

    (defcap COMPOSE ()
        true
    )
    (defcap SECURE ()
        true
    )
    (defcap P|WR ()
        true
    )
    (defcap P|IC ()
        true
    )
    (defcap P|DIN ()
        true
    )
    (defcap P|ATSI|CALLER ()
        true
    )
    ;;Roles
    (defcap P|TM|TBR ()
        true
    )
    (defcap P|T|TFER ()
        true
    )
    (defcap P|T|TMR ()
        true
    )
    (defcap P|M|MCR ()
        true
    )
    (defcap P|M|TAQR ()
        true
    )

    (defcap P|DINIC ()
        (compose-capability (P|DIN))
        (compose-capability (P|IC))
    )
    (defcap ATS|ISSUE ()
        (compose-capability (P|DINIC))
        (compose-capability (P|ATSI|CALLER))
    )
    (defcap DPTF-DPMF|TOGGLE-BURN-ROLE ()
        (compose-capability (P|TM|TBR))
        (compose-capability (P|WR))
        (compose-capability (P|DINIC))
        (compose-capability (SECURE))
    )
    (defcap DPTF|TOGGLE-FEE-EXEMPTION-ROLE ()
        (compose-capability (P|T|TFER))
        (compose-capability (P|WR))
        (compose-capability (P|DINIC))
    )
    (defcap DPTF|TOGGLE-MINT-ROLE ()
        (compose-capability (P|T|TMR))
        (compose-capability (P|WR))
        (compose-capability (P|DINIC))
    )
    (defcap DPMF|MOVE-CREATE-ROLE ()
        (compose-capability (P|M|MCR))
        (compose-capability (P|WR))
        (compose-capability (P|DINIC))
    )
    (defcap DPMF|TOGGLE-ADD-QUANTITY-ROLE ()
        (compose-capability (P|M|TAQR))
        (compose-capability (P|WR))
        (compose-capability (P|DINIC))
    )
    (defcap P|ATSI ()
        (compose-capability (P|ATSI|CALLER))
        (compose-capability (P|DINIC))
    )

    (defun A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (ATSI-ADMIN)
            (write PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun C_ReadPolicy:guard (policy-name:string)
        (at "policy" (read PoliciesTable policy-name ["policy"]))
    )

    (defun DefinePolicies ()
        (DALOS.A_AddPolicy
            "ATSI|GasCol"
            (create-capability-guard (P|IC))
        )
        (DALOS.A_AddPolicy
            "ATSI|PlusDalosNonce"
            (create-capability-guard (P|DIN))
        )
        (BASIS.A_AddPolicy
            "ATSI|Caller"
            (create-capability-guard (P|ATSI|CALLER))
        )
        (BASIS.A_AddPolicy
            "ATSI|TgBrRl"
            (create-capability-guard (P|TM|TBR))
        )
        (BASIS.A_AddPolicy 
            "ATSI|TgFeRl"
            (create-capability-guard (P|T|TFER))
        )
        (BASIS.A_AddPolicy
            "ATSI|TgMnRl"
            (create-capability-guard (P|T|TMR))
        )
        (BASIS.A_AddPolicy
            "ATSI|MCRl"
            (create-capability-guard (P|M|MCR))
        )
        (BASIS.A_AddPolicy 
            "ATSI|TgAqRl"
            (create-capability-guard (P|M|TAQR))
        )
        (BASIS.A_AddPolicy
            "ATSI|WR"
            (create-capability-guard (P|WR))
        )
        (ATS.A_AddPolicy
            "ATSI|Caller"
            (create-capability-guard (P|ATSI|CALLER))
        )
    )

    (deftable PoliciesTable:{DALOS.PolicySchema})
    ;;ATS
    (defcap ATSI|ISSUE (account:string atspair:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string]rbt-nfr:[bool])
        @event
        (let*
            (
                (l1:integer (length atspair))
                (l2:integer (length index-decimals))
                (l3:integer (length reward-token))
                (l4:integer (length rt-nfr))
                (l5:integer (length reward-bearing-token))
                (l6:integer (length rbt-nfr))
                (lengths:[integer] [l1 l2 l3 l4 l5 l6])
            )
            (UTILS.UTILS|UEV_EnforceUniformIntegerList lengths)
            (UTILS.LIST|UC_IzUnique atspair)
            (DALOS.DALOS|CAP_EnforceAccountOwnership account)
            (map
                (lambda
                    (index:integer)
                    (ATSI|UEV_IssueData (UTILS.DALOS|UCC_Makeid (at index atspair)) (at index index-decimals) (at index reward-token) (at index reward-bearing-token))

                )
                (enumerate 0 (- l1 1))
            )
        )
    )
    (defun ATSI|UEV_IssueData (atspair:string index-decimals:integer reward-token:string reward-bearing-token:string)
        (enforce (!= reward-token reward-bearing-token) "RT must be different from RBT")    
        (UTILS.DALOS|UEV_Decimals index-decimals)
        (BASIS.DPTF-DPMF|CAP_Owner reward-token true)
        (BASIS.DPTF-DPMF|CAP_Owner reward-bearing-token true)
        (BASIS.DPTF-DPMF|UEV_id reward-token true)
        (BASIS.DPTF-DPMF|UEV_id reward-bearing-token true)
        (ATS.ATS|UEV_RewardTokenExistance atspair reward-token false)
        (ATS.ATS|UEV_RewardBearingTokenExistance atspair reward-bearing-token false true)
    )
    (defun ATSI|C_Issue:[string] 
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
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (ATSI|ISSUE account atspair index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr)
            (let*
                (
                    (l1:integer (length atspair))
                    (ats-cost:decimal (DALOS.DALOS|UR_UsagePrice "ats"))
                    (gas-costs:decimal (* (dec l1) DALOS.GAS_ATS))
                    (kda-costs:decimal (* (dec l1) ats-cost))
                )
                (with-capability (ATS|ISSUE)
                    (let
                        (
                            (folded-lst:[string]
                                (fold
                                    (lambda
                                        (acc:[string] index:integer)
                                        (let
                                            (
                                                (id:string
                                                    (ATSI|X_Issue
                                                        account 
                                                        (at index atspair)
                                                        (at index index-decimals)
                                                        (at index reward-token)
                                                        (at index rt-nfr)
                                                        (at index reward-bearing-token)
                                                        (at index rbt-nfr)
                                                    )
                                                )
                                                (ats-id:string (UTILS.DALOS|UCC_Makeid (at index atspair)))
                                            )
                                            (DALOS.DALOS|X_IncrementNonce patron)
                                            (BASIS.DPTF|XO_UpdateRewardToken ats-id (at index reward-token) true)
                                            (BASIS.DPTF-DPMF|XO_UpdateRewardBearingToken (at index reward-bearing-token) ats-id true)
                                            (UTILS.LIST|UC_AppendLast acc id)
                                            (ATSI|XC_EnsureActivationRoles patron ats-id true)
                                            (UTILS.LIST|UC_AppendLast acc id)
                                        )
                                    )
                                    []
                                    (enumerate 0 (- l1 1))
                                )
                            )
                        )
                        (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                            (DALOS.IGNIS|X_Collect patron account gas-costs)
                            true
                        )
                        (if (not (DALOS.IGNIS|URC_IsNativeGasZero))
                            (DALOS.DALOS|C_TransferRawDalosFuel patron kda-costs)
                            true
                        )
                        folded-lst
                    )
                )
            )
        )
    )
    ;;
    (defun ATSI|X_Issue:string (account:string atspair:string index-decimals:integer reward-token:string rt-nfr:bool reward-bearing-token:string rbt-nfr:bool)
        (require-capability (ATS|ISSUE))
        (ATS.ATS|X_InsertNewATSPair account atspair index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr)
        (BASIS.DPTF-DPMF|C_DeployAccount reward-token account true)
        (BASIS.DPTF-DPMF|C_DeployAccount reward-bearing-token account true)
        (BASIS.DPTF-DPMF|C_DeployAccount reward-token ATS.ATS|SC_NAME true)
        (BASIS.DPTF-DPMF|C_DeployAccount reward-bearing-token ATS.ATS|SC_NAME true)
        (UTILS.DALOS|UCC_Makeid atspair)
    )
    (defun ATSI|XC_EnsureActivationRoles (patron:string atspair:string cold-or-hot:bool)
        (let*
            (
                (rt-lst:[string] (ATS.ATS|UR_RewardTokenList atspair))
                (c-rbt:string (ATS.ATS|UR_ColdRewardBearingToken atspair))
                (c-rbt-fer:bool (BASIS.DPTF|UR_AccountRoleFeeExemption c-rbt ATS.ATS|SC_NAME))
                (c-fr:bool (ATS.ATS|UR_ColdRecoveryFeeRedirection atspair))
                
            )
            (ATSI|XC_SetMassRole patron atspair false)
            (if cold-or-hot
                (let
                    (
                        (c-rbt-burn-role:bool (BASIS.DPTF-DPMF|UR_AccountRoleBurn c-rbt ATS.ATS|SC_NAME true))
                        (c-rbt-mint-role:bool (BASIS.DPTF|UR_AccountRoleMint c-rbt ATS.ATS|SC_NAME))
                    )
                    (if (not c-fr)
                        (ATSI|XC_SetMassRole patron atspair true)
                        true
                    )
                    (if (not c-rbt-burn-role)
                        (DPTF-DPMF|C_ToggleBurnRole patron c-rbt ATS.ATS|SC_NAME true true)
                        true
                    )
                    (if (not c-rbt-fer)
                        (DPTF|C_ToggleFeeExemptionRole patron c-rbt ATS.ATS|SC_NAME true)
                        true
                    )
                    (if (not c-rbt-mint-role)
                        (DPTF|C_ToggleMintRole patron c-rbt ATS.ATS|SC_NAME true)
                        true
                    )
                )
                (let*
                    (
                        (h-rbt:string (ATS.ATS|UR_HotRewardBearingToken atspair))
                        (h-fr:bool (ATS.ATS|UR_HotRecoveryFeeRedirection atspair))
                        (h-rbt-burn-role:bool (BASIS.DPTF-DPMF|UR_AccountRoleBurn h-rbt ATS.ATS|SC_NAME false))
                        (h-rbt-create-role:bool (BASIS.DPMF|UR_AccountRoleCreate h-rbt ATS.ATS|SC_NAME))
                        (h-rbt-add-q-role:bool (BASIS.DPMF|UR_AccountRoleNFTAQ h-rbt ATS.ATS|SC_NAME))
                    )
                    (if (not h-fr)
                        (ATSI|XC_SetMassRole patron atspair true)
                        true
                    )
                    (if (not h-rbt-burn-role)
                        (DPTF-DPMF|C_ToggleBurnRole patron h-rbt ATS.ATS|SC_NAME true false)
                        true
                    )
                    (if (not h-rbt-create-role)
                        (DPMF|C_MoveCreateRole patron h-rbt ATS.ATS|SC_NAME)
                        true
                    )
                    (if (not h-rbt-add-q-role)
                        (DPMF|C_ToggleAddQuantityRole patron h-rbt ATS.ATS|SC_NAME true)
                        true
                    )
                )
            )
        )
    )
    (defun ATSI|XC_SetMassRole (patron:string atspair:string burn-or-exemption:bool)
        (map
            (lambda
                (reward-token:string)
                (let
                    (
                        (rt-br:bool (BASIS.DPTF-DPMF|UR_AccountRoleBurn reward-token ATS.ATS|SC_NAME true))
                        (rt-fer:bool (BASIS.DPTF|UR_AccountRoleFeeExemption reward-token ATS.ATS|SC_NAME))
                    )
                    (if (and (= rt-br false) burn-or-exemption)
                        (DPTF-DPMF|C_ToggleBurnRole patron reward-token ATS.ATS|SC_NAME true true)        
                        (if (and (= rt-fer false) (= burn-or-exemption false))
                            (DPTF|C_ToggleFeeExemptionRole patron reward-token ATS.ATS|SC_NAME true)
                            true
                        )
                    )
                )
            )
            (ATS.ATS|UR_RewardTokenList atspair)
        )
    )
    ;;True-Fungible Roles
    (defun DPTF-DPMF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool token-type:bool)
        (with-capability (DPTF-DPMF|TOGGLE-BURN-ROLE)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_SMALL)
                true
            )
            (BASIS.DPTF-DPMF|XO_ToggleBurnRole id account toggle token-type)
            (BASIS.DPTF-DPMF|XO_WriteRoles id account 1 toggle token-type)
            (DALOS.DALOS|X_IncrementNonce patron)
            (if (and (= account ATS.ATS|SC_NAME) (= toggle false))
                (ATS|XC_RevokeBurn patron id token-type)
                true
            )
        )
    )
    (defun DPTF|C_ToggleFeeExemptionRole (patron:string id:string account:string toggle:bool)
        (with-capability (DPTF|TOGGLE-FEE-EXEMPTION-ROLE)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_SMALL)
                true
            )
            (BASIS.DPTF|XO_ToggleFeeExemptionRole id account toggle)
            (BASIS.DPTF-DPMF|XO_WriteRoles id account 3 toggle true)
            (DALOS.DALOS|X_IncrementNonce patron)
            (if (and (= account ATS.ATS|SC_NAME) (= toggle false))
                (ATSI|XC_RevokeFeeExemption patron id)
                true
            )
        )
    )
    (defun DPTF|C_ToggleMintRole (patron:string id:string account:string toggle:bool)
        (with-capability (DPTF|TOGGLE-MINT-ROLE)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_SMALL)
                true
            )
            (BASIS.DPTF|XO_ToggleMintRole id account toggle)
            (BASIS.DPTF-DPMF|XO_WriteRoles id account 2 toggle true)
            (DALOS.DALOS|X_IncrementNonce patron)
            (if (and (= account ATS.ATS|SC_NAME) (= toggle false))
                (ATS|XC_RevokeMint patron id)
                true
            )
        )
    )
    (defun DPMF|C_MoveCreateRole (patron:string id:string receiver:string)
        (with-capability (DPMF|MOVE-CREATE-ROLE)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (BASIS.DPTF-DPMF|UR_Konto id false) DALOS.GAS_BIGGEST)
                true
            )
            (BASIS.DPMF|XO_MoveCreateRole id receiver)
            (BASIS.DPTF-DPMF|XO_WriteRoles id (BASIS.DPMF|UR_CreateRoleAccount id) 2 false false)
            (BASIS.DPTF-DPMF|XO_WriteRoles id receiver 2 true false)
            (DALOS.DALOS|X_IncrementNonce patron)
            (if (!= (BASIS.DPMF|UR_CreateRoleAccount id) ATS.ATS|SC_NAME)
                (ATS|XC_RevokeCreateOrAddQ patron id)
                true
            )
        )
    )
    (defun DPMF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool)
        (with-capability (DPMF|TOGGLE-ADD-QUANTITY-ROLE)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron account DALOS.GAS_SMALL)
                true
            )
            (BASIS.DPMF|XO_ToggleAddQuantityRole id account toggle)
            (BASIS.DPTF-DPMF|XO_WriteRoles id account 3 toggle false)
            (DALOS.DALOS|X_IncrementNonce patron)
            (if (and (= account ATS.ATS|SC_NAME) (= toggle false))
                (ATS|XC_RevokeCreateOrAddQ patron id)
                true
            )
        )
    )
    ;;Revokes
    (defun ATS|XC_RevokeBurn (patron:string id:string cold-or-hot:bool)
        (if (BASIS.ATS|UC_IzRT id)
            (map
                (lambda
                    (atspair:string)
                    (with-capability (COMPOSE)
                        (if (not (ATS.ATS|UR_ColdRecoveryFeeRedirection atspair))
                            (ATSI|C_ToggleFeeSettings patron atspair true 1)
                            true
                        )
                        (if (not (ATS.ATS|UR_HotRecoveryFeeRedirection atspair))
                            (ATSI|C_ToggleFeeSettings patron atspair true 2)
                            true
                        )
                    )
                )
                (BASIS.DPTF|UR_RewardToken id)
            )
            (if (BASIS.ATS|UC_IzRBT id cold-or-hot)
                (if (= cold-or-hot true)
                    (ATSI|X_MassTurnColdRecoveryOff patron id)
                    (if (= (ATS.ATS|UR_ToggleHotRecovery (BASIS.DPMF|UR_RewardBearingToken id)) true)
                        (ATSI|C_TurnRecoveryOff patron (BASIS.DPMF|UR_RewardBearingToken id) false)
                        true
                    )
                )
            )
        )
    )
    (defun ATSI|XC_RevokeFeeExemption (patron:string id:string)
        (if (BASIS.ATS|UC_IzRT id)
            (ATSI|X_MassTurnColdRecoveryOff patron id)     ;;to get
            true
        )
    )
    (defun ATS|XC_RevokeMint (patron:string id:string)
        (if (BASIS.ATS|UC_IzRBT id true)
            (ATSI|X_MassTurnColdRecoveryOff patron id)      ;;to get
            true        
        )
    )
    (defun ATS|XC_RevokeCreateOrAddQ (patron:string id:string)
        (if (BASIS.ATS|UC_IzRBT id false)
            (ATSI|C_TurnRecoveryOff patron (BASIS.DPMF|UR_RewardBearingToken id) false)
            true
        )
    )
    ;;Recoveries and Fee Settings
    (defun ATSI|C_ToggleFeeSettings (patron:string atspair:string toggle:bool fee-switch:integer)
        (with-capability (P|ATSI)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS.ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS.ATS|X_ToggleFeeSettings atspair toggle fee-switch)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATSI|C_TurnRecoveryOff (patron:string atspair:string cold-or-hot:bool)
        (with-capability (P|ATSI)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS.ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS.ATS|X_TurnRecoveryOff atspair cold-or-hot)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATSI|X_MassTurnColdRecoveryOff (patron:string id:string)
        (map
            (lambda
                (atspair:string)
                (if (= (ATS.ATS|UR_ToggleColdRecovery atspair) true)
                    (ATSI|C_TurnRecoveryOff patron atspair true)
                    true
                )
            )
            (BASIS.DPTF|UR_RewardBearingToken id)
        )
    )
)

(create-table PoliciesTable)