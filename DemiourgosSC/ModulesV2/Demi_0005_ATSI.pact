;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module ATSI GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_ATSI           (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_ATSI           (keyset-ref-guard ATS.ATS|SC_KEY))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|ATSI_ADMIN))
    )
    (defcap GOV|ATSI_ADMIN ()
        (enforce-one
            "ATSI Autostake Admin not satisfed"
            [
                (enforce-guard GOV|MD_ATSI)
                (enforce-guard GOV|SC_ATSI)
            ]
        )
    )
    ;;{G3}
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    (defcap P|WR ()
        true
    )
    (defcap P|ATSI|CALLER ()
        true
    )
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
    (defcap DPTF-DPMF|TOGGLE-BURN-ROLE ()
        (compose-capability (P|TM|TBR))
        (compose-capability (P|WR))
    )
    (defcap DPTF|TOGGLE-FEE-EXEMPTION-ROLE ()
        (compose-capability (P|T|TFER))
        (compose-capability (P|WR))
    )
    (defcap DPTF|TOGGLE-MINT-ROLE ()
        (compose-capability (P|T|TMR))
        (compose-capability (P|WR))
    )
    (defcap DPMF|MOVE-CREATE-ROLE ()
        (compose-capability (P|M|MCR))
        (compose-capability (P|WR))
    )
    (defcap DPMF|TOGGLE-ADD-QUANTITY-ROLE ()
        (compose-capability (P|M|TAQR))
        (compose-capability (P|WR))
    )
    ;;{P4}
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|ATSI_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Define ()
        (DPTF.P|A_Add
            "ATSI|Caller"
            (create-capability-guard (P|ATSI|CALLER))
        )
        (DPTF.P|A_Add
            "ATSI|WR"
            (create-capability-guard (P|WR))
        )
        (DPTF.P|A_Add
            "ATSI|TgBrRl"
            (create-capability-guard (P|TM|TBR))
        )
        (DPTF.P|A_Add 
            "ATSI|TgFeRl"
            (create-capability-guard (P|T|TFER))
        )
        (DPTF.P|A_Add
            "ATSI|TgMnRl"
            (create-capability-guard (P|T|TMR))
        )

        (DPMF.P|A_Add
            "ATSI|Caller"
            (create-capability-guard (P|ATSI|CALLER))
        )
        (DPMF.P|A_Add
            "ATSI|WR"
            (create-capability-guard (P|WR))
        )
        (DPMF.P|A_Add
            "ATSI|TgBrRl"
            (create-capability-guard (P|TM|TBR))
        )
        (DPMF.P|A_Add
            "ATSI|MCRl"
            (create-capability-guard (P|M|MCR))
        )
        (DPMF.P|A_Add 
            "ATSI|TgAqRl"
            (create-capability-guard (P|M|TAQR))
        )
        
        (ATS.P|A_Add
            "ATSI|Caller"
            (create-capability-guard (P|ATSI|CALLER))
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
    (defcap COMPOSE ()
        true
    )
    ;;{5}
    ;;{6}
    ;;{7}
    (defcap ATSI|C>ISSUE (account:string atspair:[string] index-decimals:[integer] reward-token:[string] rt-nfr:[bool] reward-bearing-token:[string]rbt-nfr:[bool])
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
                    (ATSI|UEV_IssueData (UTILS.DALOS|UDC_Makeid (at index atspair)) (at index index-decimals) (at index reward-token) (at index reward-bearing-token))

                )
                (enumerate 0 (- l1 1))
            )
            (compose-capability (P|ATSI|CALLER))
        )
    )
    ;;
    ;;{8}
    ;;{9}
    ;;{10}
    (defun ATSI|UEV_IssueData (atspair:string index-decimals:integer reward-token:string reward-bearing-token:string)
        (enforce (!= reward-token reward-bearing-token) "RT must be different from RBT")    
        (UTILS.DALOS|UEV_Decimals index-decimals)
        (DPTF.DPTF|CAP_Owner reward-token)
        (DPTF.DPTF|CAP_Owner reward-bearing-token)
        (DPTF.DPTF|UEV_id reward-token)
        (DPTF.DPTF|UEV_id reward-bearing-token)
        (ATS.ATS|UEV_RewardTokenExistance atspair reward-token false)
        (ATS.ATS|UEV_RewardBearingTokenExistance atspair reward-bearing-token false true)
    )
    ;;{11}
    ;;{12}
    ;;{13}
    ;;
    ;;{14}
    ;;{15}
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
        (enforce-guard (P|UR "TALOS|Summoner"))
        (with-capability (ATSI|C>ISSUE account atspair index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr)
            (let*
                (
                    (l1:integer (length atspair))
                    (ats-cost:decimal (DALOS.DALOS|UR_UsagePrice "ats"))
                    (gas-costs:decimal (* (dec l1) (DALOS.DALOS|UR_UsagePrice "ignis|ats-issue")))
                    (kda-costs:decimal (* (dec l1) ats-cost))
                    (folded-lst:[string]
                        (fold
                            (lambda
                                (acc:[string] index:integer)
                                (let
                                    (
                                        (ats-id:string
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
                                    )
                                    (DPTF.DPTF|X_UpdateRewardToken ats-id (at index reward-token) true)
                                    (DPTF.DPTF|X_UpdateRewardBearingToken ats-id (at index reward-bearing-token))
                                    (ATSI|XC_EnsureActivationRoles patron ats-id true)
                                    (UTILS.LIST|UC_AppendLast acc ats-id)
                                )
                            )
                            []
                            (enumerate 0 (- l1 1))
                        )
                    )
                )
                (DALOS.IGNIS|C_Collect patron account gas-costs)
                (DALOS.KDA|C_Collect patron kda-costs)
                folded-lst
            )
        )
    )
    ;(ats-idd:string (UTILS.DALOS|UDC_Makeid (at index atspair)))
    (defun ATSI|C_ToggleFeeSettings (patron:string atspair:string toggle:bool fee-switch:integer)
        (with-capability (P|ATSI|CALLER)
            (ATS.ATS|X_ToggleFeeSettings atspair toggle fee-switch)
            (DALOS.IGNIS|C_Collect patron (ATS.ATS|UR_OwnerKonto atspair) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun ATSI|C_TurnRecoveryOff (patron:string atspair:string cold-or-hot:bool)
        (with-capability (P|ATSI|CALLER)
            (ATS.ATS|X_TurnRecoveryOff atspair cold-or-hot)
            (DALOS.IGNIS|C_Collect patron (ATS.ATS|UR_OwnerKonto atspair) (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun DPTF|C_TgBurnR (patron:string id:string account:string toggle:bool)
        (with-capability (DPTF-DPMF|TOGGLE-BURN-ROLE)
            (DPTF.DPTF|X_ToggleBurnRole id account toggle)
            (DPTF.DPTF|X_WriteRoles id account 1 toggle)
            (if (and (= account ATS.ATS|SC_NAME) (= toggle false))
                (ATS|XC_RevokeBurn patron id true)
                true
            )
            (DALOS.IGNIS|C_Collect patron account (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun DPTF|C_TgFeeExemptionR (patron:string id:string account:string toggle:bool)
        (with-capability (DPTF|TOGGLE-FEE-EXEMPTION-ROLE)
            (DPTF.DPTF|X_ToggleFeeExemptionRole id account toggle)
            (DPTF.DPTF|X_WriteRoles id account 3 toggle)
            (if (and (= account ATS.ATS|SC_NAME) (= toggle false))
                (ATSI|XC_RevokeFeeExemption patron id)
                true
            )
            (DALOS.IGNIS|C_Collect patron account (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun DPTF|C_TgMintR (patron:string id:string account:string toggle:bool)
        (with-capability (DPTF|TOGGLE-MINT-ROLE)
            (DPTF.DPTF|X_ToggleMintRole id account toggle)
            (DPTF.DPTF|X_WriteRoles id account 2 toggle)
            (if (and (= account ATS.ATS|SC_NAME) (= toggle false))
                (ATS|XC_RevokeMint patron id)
                true
            )
            (DALOS.IGNIS|C_Collect patron account (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun DPMF|C_TgBurnR (patron:string id:string account:string toggle:bool)
        (with-capability (DPTF-DPMF|TOGGLE-BURN-ROLE)
            (DPMF.DPMF|X_ToggleBurnRole id account toggle)
            (DPMF.DPMF|X_WriteRoles id account 1 toggle)
            (if (and (= account ATS.ATS|SC_NAME) (= toggle false))
                (ATS|XC_RevokeBurn patron id false)
                true
            )
            (DALOS.IGNIS|C_Collect patron account (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    (defun DPMF|C_MoveCreateRole (patron:string id:string receiver:string)
        (with-capability (DPMF|MOVE-CREATE-ROLE)
            (DPMF.DPMF|X_MoveCreateRole id receiver)
            (DPMF.DPMF|X_WriteRoles id (DPMF.DPMF|UR_CreateRoleAccount id) 2 false)
            (DPMF.DPMF|X_WriteRoles id receiver 2 true)
            (if (!= (DPMF.DPMF|UR_CreateRoleAccount id) ATS.ATS|SC_NAME)
                (ATS|XC_RevokeCreateOrAddQ patron id)
                true
            )
            (DALOS.IGNIS|C_Collect patron (DPMF.DPMF|UR_Konto id) (DALOS.DALOS|UR_UsagePrice "ignis|biggest"))
        )
    )
    (defun DPMF|C_TgAddQuantityR (patron:string id:string account:string toggle:bool)
        (with-capability (DPMF|TOGGLE-ADD-QUANTITY-ROLE)
            (DPMF.DPMF|X_ToggleAddQuantityRole id account toggle)
            (DPMF.DPMF|X_WriteRoles id account 3 toggle )
            (if (and (= account ATS.ATS|SC_NAME) (= toggle false))
                (ATS|XC_RevokeCreateOrAddQ patron id)
                true
            )
            (DALOS.IGNIS|C_Collect patron account (DALOS.DALOS|UR_UsagePrice "ignis|small"))
        )
    )
    ;;{16}
    (defun ATSI|X_Issue:string (account:string atspair:string index-decimals:integer reward-token:string rt-nfr:bool reward-bearing-token:string rbt-nfr:bool)
        (ATS.ATS|X_InsertNewATSPair account atspair index-decimals reward-token rt-nfr reward-bearing-token rbt-nfr)
        (DPTF.DPTF|C_DeployAccount reward-token account)
        (DPTF.DPTF|C_DeployAccount reward-bearing-token account)
        (DPTF.DPTF|C_DeployAccount reward-token ATS.ATS|SC_NAME)
        (DPTF.DPTF|C_DeployAccount reward-bearing-token ATS.ATS|SC_NAME)
        (UTILS.DALOS|UDC_Makeid atspair)
    )
    (defun ATSI|XC_EnsureActivationRoles (patron:string atspair:string cold-or-hot:bool)
        (let*
            (
                (rt-lst:[string] (ATS.ATS|UR_RewardTokenList atspair))
                (c-rbt:string (ATS.ATS|UR_ColdRewardBearingToken atspair))
                (c-rbt-fer:bool (DPTF.DPTF|UR_AccountRoleFeeExemption c-rbt ATS.ATS|SC_NAME))
                (c-fr:bool (ATS.ATS|UR_ColdRecoveryFeeRedirection atspair))
                
            )
            (ATSI|XC_SetMassRole patron atspair false)
            (if cold-or-hot
                (let
                    (
                        (c-rbt-burn-role:bool (DPTF.DPTF|UR_AccountRoleBurn c-rbt ATS.ATS|SC_NAME))
                        (c-rbt-mint-role:bool (DPTF.DPTF|UR_AccountRoleMint c-rbt ATS.ATS|SC_NAME))
                    )
                    (if (not c-fr)
                        (ATSI|XC_SetMassRole patron atspair true)
                        true
                    )
                    (if (not c-rbt-burn-role)
                        (DPTF|C_TgBurnR patron c-rbt ATS.ATS|SC_NAME true)
                        true
                    )
                    (if (not c-rbt-fer)
                        (DPTF|C_TgFeeExemptionR patron c-rbt ATS.ATS|SC_NAME true)
                        true
                    )
                    (if (not c-rbt-mint-role)
                        (DPTF|C_TgMintR patron c-rbt ATS.ATS|SC_NAME true)
                        true
                    )
                )
                (let*
                    (
                        (h-rbt:string (ATS.ATS|UR_HotRewardBearingToken atspair))
                        (h-fr:bool (ATS.ATS|UR_HotRecoveryFeeRedirection atspair))
                        (h-rbt-burn-role:bool (DPMF.DPMF|UR_AccountRoleBurn h-rbt ATS.ATS|SC_NAME))
                        (h-rbt-create-role:bool (DPMF.DPMF|UR_AccountRoleCreate h-rbt ATS.ATS|SC_NAME))
                        (h-rbt-add-q-role:bool (DPMF.DPMF|UR_AccountRoleNFTAQ h-rbt ATS.ATS|SC_NAME))
                    )
                    (if (not h-fr)
                        (ATSI|XC_SetMassRole patron atspair true)
                        true
                    )
                    (if (not h-rbt-burn-role)
                        (DPMF|C_TgBurnR patron h-rbt ATS.ATS|SC_NAME true)
                        true
                    )
                    (if (not h-rbt-create-role)
                        (DPMF|C_MoveCreateRole patron h-rbt ATS.ATS|SC_NAME)
                        true
                    )
                    (if (not h-rbt-add-q-role)
                        (DPMF|C_TgAddQuantityR patron h-rbt ATS.ATS|SC_NAME true)
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
                        (rt-br:bool (DPTF.DPTF|UR_AccountRoleBurn reward-token ATS.ATS|SC_NAME))
                        (rt-fer:bool (DPTF.DPTF|UR_AccountRoleFeeExemption reward-token ATS.ATS|SC_NAME))
                    )
                    (if (and (= rt-br false) burn-or-exemption)
                        (DPTF|C_TgBurnR patron reward-token ATS.ATS|SC_NAME true)        
                        (if (and (= rt-fer false) (= burn-or-exemption false))
                            (DPTF|C_TgFeeExemptionR patron reward-token ATS.ATS|SC_NAME true)
                            true
                        )
                    )
                )
            )
            (ATS.ATS|UR_RewardTokenList atspair)
        )
    )
    (defun ATS|XC_RevokeBurn (patron:string id:string cold-or-hot:bool)
        (if (DPTF.DPTF|URC_IzRT id)
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
                (DPTF.DPTF|UR_RewardToken id)
            )
            (let
                (
                    (iz-rbt:bool (if cold-or-hot (DPTF.DPTF|URC_IzRBT id) (DPMF.DPMF|URC_IzRBT id)))
                )
                (if iz-rbt
                    (if cold-or-hot
                        (ATSI|X_MassTurnColdRecoveryOff patron id)
                        (if (ATS.ATS|UR_ToggleHotRecovery (DPMF.DPMF|UR_RewardBearingToken id))
                            (ATSI|C_TurnRecoveryOff patron (DPMF.DPMF|UR_RewardBearingToken id) false)
                            true
                        )
                    )
                )
            )
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
            (DPTF.DPTF|UR_RewardBearingToken id)
        )
    )
    (defun ATSI|XC_RevokeFeeExemption (patron:string id:string)
        (if (DPTF.DPTF|URC_IzRT id)
            (ATSI|X_MassTurnColdRecoveryOff patron id)
            true
        )
    )
    (defun ATS|XC_RevokeMint (patron:string id:string)
        (if (DPTF.DPTF|URC_IzRBT id)
            (ATSI|X_MassTurnColdRecoveryOff patron id)
            true        
        )
    )
    (defun ATS|XC_RevokeCreateOrAddQ (patron:string id:string)
        (if (DPMF.DPMF|URC_IzRBT id)
            (ATSI|C_TurnRecoveryOff patron (DPMF.DPMF|UR_RewardBearingToken id) false)
            true
        )
    )
)

(create-table P|T)