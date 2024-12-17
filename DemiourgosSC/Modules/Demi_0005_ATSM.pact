;(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")
(module AUTOSTAKE-MANAGER GOVERNANCE
    ;(use n_e096dec549c18b706547e425df9ac0571ebd00b0.DALOS)
    ;(use n_e096dec549c18b706547e425df9ac0571ebd00b0.ATS)
    (use DALOS)
    (use ATS)

    (defcap GOVERNANCE ()
        (compose-capability (ATSM-ADMIN))
    )
    (defcap ATSM-ADMIN ()
        (enforce-one
            "Autostake Admin not satisfed"
            [
                (enforce-guard G-MD_AUTOS)
                (enforce-guard G-SC_AUTOS)
            ]
        )
    )

    (defconst G-MD_AUTOS   (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst G-SC_AUTOS   (keyset-ref-guard ATS.ATS|SC_KEY))

    (defcap COMPOSE ()
        true
    )
    (defcap SECURE ()
        true
    )

    (defun A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (ATSM-ADMIN)
            (write PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun C_ReadPolicy:guard (policy-name:string)
        (at "policy" (read PoliciesTable policy-name ["policy"]))
    )
    (defcap P|ATSM|REMOTE-GOV ()
        true
    )
    (defcap P|ATSM|UPDATE_ROU ()
        true
    )
    (defcap P|ATSM|CALLER ()
        true
    )
    (defcap P|DIN ()
        true
    )
    (defcap P|IC ()
        true
    )
    (defcap P|ATSM ()
        (compose-capability (P|ATSM|CALLER))
        (compose-capability (P|DIN))
        (compose-capability (P|IC))
    )

    (defun ATSM|DefinePolicies ()
        (DALOS.A_AddPolicy
            "ATSM|PlusDalosNonce"
            (create-capability-guard (P|DIN))
        )
        (DALOS.A_AddPolicy
            "ATSM|GasCol"
            (create-capability-guard (P|IC))
        )
        (BASIS.A_AddPolicy
            "ATSM|Caller"
            (create-capability-guard (P|ATSM|CALLER))
        )
        (ATS.A_AddPolicy
            "ATSM|Caller"
            (create-capability-guard (P|ATSM|CALLER))
        )
        (ATS.A_AddPolicy
            "ATSM|RemoteAutostakeGovernor"
            (create-capability-guard (P|ATSM|REMOTE-GOV))
        )
        (ATS.A_AddPolicy
            "ATSM|UpdateROU"
            (create-capability-guard (P|ATSM|UPDATE_ROU))
        )
    )

    (deftable PoliciesTable:{DALOS.PolicySchema})
    ;;
    (defun ATSM|C_ChangeOwnership (patron:string atspair:string new-owner:string)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (P|ATSM)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS|UR_OwnerKonto atspair) DALOS.GAS_BIGGEST)
                true
            )
            (ATS.ATS|X_ChangeOwnership atspair new-owner)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATSM|C_ToggleParameterLock (patron:string atspair:string toggle:bool)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (let
            (
                (ZG:bool (DALOS.IGNIS|URC_IsVirtualGasZero))
                (NZG:bool (DALOS.IGNIS|URC_IsNativeGasZero))
                (atspair-owner:string (ATS.ATS|UR_OwnerKonto atspair))
            )
            (with-capability (P|ATSM)
                (if (not ZG)
                    (DALOS.IGNIS|X_Collect patron atspair-owner DALOS.GAS_SMALL)
                    true
                )
                (let*
                    (
                        (toggle-costs:[decimal] (ATS.ATS|X_ToggleParameterLock atspair toggle))
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
    (defun ATSM|C_UpdateSyphon (patron:string atspair:string syphon:decimal)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (P|ATSM)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS.ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS.ATS|X_UpdateSyphon atspair syphon)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATSM|C_ToggleSyphoning (patron:string atspair:string toggle:bool)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (P|ATSM)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS.ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS.ATS|X_ToggleSyphoning atspair toggle)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATSM|C_ToggleFeeSettings (patron:string atspair:string toggle:bool fee-switch:integer)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (P|ATSM)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS.ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS.ATS|X_ToggleFeeSettings atspair toggle fee-switch)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATSM|C_SetCRD (patron:string atspair:string soft-or-hard:bool base:integer growth:integer)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (P|ATSM)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS.ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS.ATS|X_SetCRD atspair soft-or-hard base growth)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATSM|C_SetColdFee (patron:string atspair:string fee-positions:integer fee-thresholds:[decimal] fee-array:[[decimal]])
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (P|ATSM)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS.ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS.ATS|X_SetColdFee atspair fee-positions fee-thresholds fee-array)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATSM|C_SetHotFee (patron:string atspair:string promile:decimal decay:integer)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (P|ATSM)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS.ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS.ATS|X_SetHotFee atspair promile decay)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATSM|C_ToggleElite (patron:string atspair:string toggle:bool)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (P|ATSM)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS.ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS.ATS|X_ToggleElite atspair toggle)
            (DALOS.DALOS|X_IncrementNonce patron)
        )
    )
    (defun ATSM|C_TurnRecoveryOn (patron:string atspair:string cold-or-hot:bool)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (P|ATSM)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS.ATS|UR_OwnerKonto atspair) DALOS.GAS_SMALL)
                true
            )
            (ATS.ATS|X_TurnRecoveryOn atspair cold-or-hot)
            (DALOS.DALOS|X_IncrementNonce patron)
            (ATS.ATS|XC_EnsureActivationRoles patron atspair cold-or-hot)
        )
    )
    (defun ATSM|C_AddSecondary (patron:string atspair:string reward-token:string rt-nfr:bool)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (P|ATSM)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS.ATS|UR_OwnerKonto atspair) DALOS.GAS_ISSUE)
                true
            )
            (BASIS.DPTF-DPMF|C_DeployAccount reward-token ATS.ATS|SC_NAME true)
            (ATS.ATS|X_AddSecondary atspair reward-token rt-nfr)
            (DALOS.DALOS|X_IncrementNonce patron)
            (BASIS.DPTF|XO_UpdateRewardToken atspair reward-token true)      
            (ATS.ATS|XC_EnsureActivationRoles patron atspair true)
            (if (= (ATS.ATS|UC_IzPresentHotRBT atspair) true)
                (ATS.ATS|XC_EnsureActivationRoles patron atspair false)
                true
            )
        )
    )
    (defun ATSM|C_AddHotRBT (patron:string atspair:string hot-rbt:string)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (P|ATSM)
            (if (not (DALOS.IGNIS|URC_IsVirtualGasZero))
                (DALOS.IGNIS|X_Collect patron (ATS.ATS|UR_OwnerKonto atspair) DALOS.GAS_ISSUE)
                true
            )
            (BASIS.DPTF-DPMF|C_DeployAccount hot-rbt ATS|SC_NAME false)
            (ATS.ATS|X_AddHotRBT atspair hot-rbt)
            (DALOS.DALOS|X_IncrementNonce patron)
            (BASIS.DPTF-DPMF|XO_UpdateRewardBearingToken hot-rbt atspair false)
            (ATS.ATS|XC_EnsureActivationRoles patron atspair false)
        )
    )
    ;;Usage
    (defcap ATSM|FCC (atspair:string fcc-token:string)
        (ATS.ATS|UEV_RewardTokenExistance atspair fcc-token true)
        (compose-capability (P|ATSM|REMOTE-GOV))
        (compose-capability (P|ATSM|UPDATE_ROU))
        (compose-capability (P|ATSM|CALLER))
    )
    (defcap ATSM|FUEL (atspair:string reward-token:string)
        @event
        (compose-capability (ATSM|FCC atspair reward-token))
        (let
            (
                (index:decimal (ATS.ATS|UC_Index atspair))
            )
            (enforce (>= index 0.1) "Fueling cannot take place on a negative Index")
        )
    )
    (defcap ATSM|COIL_OR_CURL (atspair:string coil-token:string)
        @event
        (compose-capability (ATSM|FCC atspair coil-token))
    )
    (defun ATSM|C_Fuel (patron:string fueler:string atspair:string reward-token:string amount:decimal)
        (enforce-one
            "Fueling not allowed"
            [
                (enforce-guard (C_ReadPolicy "OUROBOROS|Summoner"))
                (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
            ]
        )
        (with-capability (ATSM|FUEL atspair reward-token)
            (ATS.DPTF|C_Transfer patron reward-token fueler ATS.ATS|SC_NAME amount true)
            (ATS.ATS|XO_UpdateRoU atspair reward-token true true amount)
        )
    )
    
    (defun ATSM|C_Coil:decimal (patron:string coiler:string atspair:string rt:string amount:decimal)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (ATSM|COIL_OR_CURL atspair rt)
            (let
                (
                    (c-rbt:string (ATS.ATS|UR_ColdRewardBearingToken atspair))
                    (c-rbt-amount:decimal (ATS.ATS|UC_RBT atspair rt amount))
                )
                (ATS.DPTF|C_Transfer patron rt coiler ATS.ATS|SC_NAME amount true)
                (ATS.ATS|XO_UpdateRoU atspair rt true true amount)
                (BASIS.DPTF|C_Mint patron c-rbt ATS.ATS|SC_NAME c-rbt-amount false)
                (ATS.DPTF|C_Transfer patron c-rbt ATS.ATS|SC_NAME coiler c-rbt-amount true)
                c-rbt-amount
            )
        )
    )
    (defun ATSM|C_Curl:decimal (patron:string curler:string atspair1:string atspair2:string rt:string amount:decimal)
        (enforce-guard (C_ReadPolicy "TALOS|Summoner"))
        (with-capability (ATSM|COIL_OR_CURL atspair1 rt)
            (let*
                (
                    (c-rbt1:string (ATS|UR_ColdRewardBearingToken atspair1))
                    (c-rbt1-amount:decimal (ATS|UC_RBT atspair1 rt amount))
                    (c-rbt2:string (ATS|UR_ColdRewardBearingToken atspair2))
                    (c-rbt2-amount:decimal (ATS|UC_RBT atspair2 c-rbt1 c-rbt1-amount))
                )
                (ATS.DPTF|C_Transfer patron rt curler ATS.ATS|SC_NAME amount true)
                (ATS.ATS|XO_UpdateRoU atspair1 rt true true amount)
                (BASIS.DPTF|C_Mint patron c-rbt1 ATS.ATS|SC_NAME c-rbt1-amount false)
                (ATS.ATS|XO_UpdateRoU atspair2 c-rbt1 true true c-rbt1-amount)
                (BASIS.DPTF|C_Mint patron c-rbt2 ATS.ATS|SC_NAME c-rbt2-amount false)
                (ATS.DPTF|C_Transfer patron c-rbt2 ATS.ATS|SC_NAME curler c-rbt2-amount true)
                c-rbt2-amount
            )
        )
    )
)

(create-table PoliciesTable)