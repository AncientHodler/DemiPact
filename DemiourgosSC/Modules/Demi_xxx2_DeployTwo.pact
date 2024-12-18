;(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")

;;A_InitialiseDALOS-04
(with-capability (DEPLOYER.SUMMONER||DEPLOYER-ADMIN)
    (let*
        (
            (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
            (core-tf:[string]
                (BASIS.DPTF|C_Issue
                    patron
                    DALOS.DALOS|SC_NAME
                    ["Ouroboros" "Auryn" "EliteAuryn" "Ignis" "DalosWrappedKadena" "DalosLiquidKadena"]
                    ["OURO" "AURYN" "ELITEAURYN" "GAS" "DWK" "DLK"]
                    [24 24 24 24 24 24]
                    [true true true true true true]         ;;can change owner
                    [true true true true true true]         ;;can upgrade
                    [true true true true true true]         ;;can can-add-special-role
                    [true false false true false false]     ;;can-freeze
                    [true false false false false false]    ;;can-wipe
                    [true false false true false false]     ;;can pause
                )
            )
            (OuroID:string (at 0 core-tf))
            (AurynID:string (at 1 core-tf))
            (EliteAurynID:string (at 2 core-tf))
            (GasID:string (at 3 core-tf))
            (WrappedKadenaID:string (at 4 core-tf))
            (StakedKadenaID:string (at 5 core-tf))
        )
    ;;STEP 2.1 - Update DALOS|PropertiesTable with new Data
        (update DALOS.DALOS|PropertiesTable DALOS.DALOS|INFO
            { "gas-source-id"           : OuroID
            , "gas-id"                  : GasID
            , "ats-gas-source-id"       : AurynID
            , "elite-ats-gas-source-id" : EliteAurynID
            , "wrapped-kda-id"          : WrappedKadenaID
            , "liquid-kda-id"           : StakedKadenaID
            }
        )
    ;;STEP 2.2 - Issue needed DPTF Accounts
        (TALOS|DPTF.C_DeployAccount AurynID ATS.ATS|SC_NAME)
        (TALOS|DPTF.C_DeployAccount EliteAurynID ATS.ATS|SC_NAME)
        (TALOS|DPTF.C_DeployAccount WrappedKadenaID LIQUID.LIQUID|SC_NAME)
        (TALOS|DPTF.C_DeployAccount StakedKadenaID LIQUID.LIQUID|SC_NAME)
    ;;STEP 2.3 - Set Up Auryn and Elite-Auryn
        (TALOS|DPTF.C_SetFee patron AurynID UTILS.AURYN_FEE)
        (TALOS|DPTF.C_SetFee patron EliteAurynID UTILS.ELITE-AURYN_FEE)
        (TALOS|DPTF.C_ToggleFee patron AurynID true)
        (TALOS|DPTF.C_ToggleFee patron EliteAurynID true)
        (BASIS.DPTF|C_ToggleFeeLock patron AurynID true)
        (BASIS.DPTF|C_ToggleFeeLock patron EliteAurynID true)
    ;;STEP 2.4 - Set Up Ignis
        ;;Setting Up Ignis Parameters
        (TALOS|DPTF.C_SetMinMove patron GasID 1000.0)
        (TALOS|DPTF.C_SetFee patron GasID -1.0)
        (TALOS|DPTF.C_SetFeeTarget patron GasID DALOS.DALOS|SC_NAME)
        (TALOS|DPTF.C_ToggleFee patron GasID true)
        (BASIS.DPTF|C_ToggleFeeLock patron GasID true)
        ;;Setting Up Compression|Sublimation Permissions
        (TALOS|DPTF.C_ToggleBurnRole patron GasID OUROBOROS.OUROBOROS|SC_NAME true)
        (TALOS|DPTF.C_ToggleBurnRole patron OuroID OUROBOROS.OUROBOROS|SC_NAME true)
        (TALOS|DPTF.C_ToggleMintRole patron GasID OUROBOROS.OUROBOROS|SC_NAME true)
        (TALOS|DPTF.C_ToggleMintRole patron OuroID OUROBOROS.OUROBOROS|SC_NAME true)
    ;;STEP 2.5 - Set Up Liquid-Staking System
        ;;Setting Liquid Staking Tokens Parameters
        (TALOS|DPTF.C_SetFee patron StakedKadenaID -1.0)
        (TALOS|DPTF.C_ToggleFee patron StakedKadenaID true)
        (BASIS.DPTF|C_ToggleFeeLock patron StakedKadenaID true)
        ;;Setting Liquid Staking Tokens Roles
        (TALOS|DPTF.C_ToggleBurnRole patron WrappedKadenaID LIQUID.LIQUID|SC_NAME true)
        (TALOS|DPTF.C_ToggleMintRole patron WrappedKadenaID LIQUID.LIQUID|SC_NAME true)
    ;;STEP 2.6 - Create Vesting Pairs
        (VESTING.VST|C_CreateVestingLink patron OuroID)
        (VESTING.VST|C_CreateVestingLink patron AurynID)
        (VESTING.VST|C_CreateVestingLink patron EliteAurynID)

    ;:STEP 3 - Initialises Autostake Pairs
        (let*
            (
                (Auryndex:string
                    (TALOS|ATS1.C_Issue
                        patron
                        patron
                        "Auryndex"
                        24
                        OuroID
                        true
                        AurynID
                        false
                    )
                )
                (Elite-Auryndex:string
                    (TALOS|ATS1.C_Issue
                        patron
                        patron
                        "EliteAuryndex"
                        24
                        AurynID
                        true
                        EliteAurynID
                        true
                    )
                )
                (Kadena-Liquid-Index:string
                    (TALOS|ATS1.C_Issue
                        patron
                        patron
                        "Kadindex"
                        24
                        WrappedKadenaID
                        false
                        StakedKadenaID
                        true
                    )
                )
                (core-idx:[string] [Auryndex Elite-Auryndex Kadena-Liquid-Index])
            )
    ;;STEP 3.1 - Set Up <Auryndex> Autostake-Pair
            (TALOS|ATS2.C_SetColdFee patron Auryndex
                7
                [50.0 100.0 200.0 350.0 550.0 800.0]
                [
                    [8.0 7.0 6.0 5.0 4.0 3.0 2.0]
                    [9.0 8.0 7.0 6.0 5.0 4.0 3.0]
                    [10.0 9.0 8.0 7.0 6.0 5.0 4.0]
                    [11.0 10.0 9.0 8.0 7.0 6.0 5.0]
                    [12.0 11.0 10.0 9.0 8.0 7.0 6.0]
                    [13.0 12.0 11.0 10.0 9.0 8.0 7.0]
                    [14.0 13.0 12.0 11.0 10.0 9.0 8.0]
                ]
            )
            (TALOS|ATS2.C_TurnRecoveryOn patron Auryndex true)
    ;;STEP 3.2 - Set Up <EliteAuryndex> Autostake-Pair
            (TALOS|ATS2.C_SetColdFee patron Elite-Auryndex 7 [0.0] [[0.0]])
            (TALOS|ATS2.C_SetCRD patron Elite-Auryndex false 360 24)
            (TALOS|ATS2.C_ToggleElite patron Elite-Auryndex true)
            (TALOS|ATS2.C_TurnRecoveryOn patron Elite-Auryndex true)
    ;;STEP 3.3 - Set Up <Kadindex> Autostake-Pair
            (TALOS|ATS2.C_SetColdFee patron Kadena-Liquid-Index -1 [0.0] [[0.0]])
            (TALOS|ATS2.C_SetCRD patron Kadena-Liquid-Index false 12 6)
            (TALOS|ATS2.C_TurnRecoveryOn patron Kadena-Liquid-Index true)
    ;;STEP 4 - Return Token Ownership to their respective Smart DALOS Accounts
            ;(DPTF|C_ChangeOwnership patron AurynID ATS.ATS|SC_NAME)
            ;(DPTF|C_ChangeOwnership patron EliteAurynID ATS.ATS|SC_NAME)
            ;(DPTF|C_ChangeOwnership patron WrappedKadenaID LIQUID.LIQUID|SC_NAME)
            ;(DPTF|C_ChangeOwnership patron StakedKadenaID LIQUID.LIQUID|SC_NAME)
    ;;STEP 5 - Return as Output a list of all Token-IDs and ATS-Pair IDs that were created
            (+ core-tf core-idx)
        )
    )
)