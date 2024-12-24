;(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")

;;Step 1
;ah, dalos, dh-master
(let*
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (core-tf:[string]
            (with-capability (DEPLOYER.SUMMONER)
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
        )
    )
    core-tf
)

;;Step 2
;;dalos, dh-master
(let
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (OuroID:string "OURO-dB66U26TF9zc")
        (AurynID:string "AURYN-dB66U26TF9zc")
        (EliteAurynID:string "ELITEAURYN-dB66U26TF9zc")
        (GasID:string "GAS-dB66U26TF9zc")
        (WrappedKadenaID:string "DWK-dB66U26TF9zc")
        (StakedKadenaID:string "DLK-dB66U26TF9zc")
    )
    (update DALOS.DALOS|PropertiesTable DALOS.DALOS|INFO
        { "gas-source-id"           : OuroID
        , "gas-id"                  : GasID
        , "ats-gas-source-id"       : AurynID
        , "elite-ats-gas-source-id" : EliteAurynID
        , "wrapped-kda-id"          : WrappedKadenaID
        , "liquid-kda-id"           : StakedKadenaID
        }
    )
    (TALOS|DPTF.C_DeployAccount AurynID ATS.ATS|SC_NAME)
    (TALOS|DPTF.C_DeployAccount EliteAurynID ATS.ATS|SC_NAME)
    (TALOS|DPTF.C_DeployAccount WrappedKadenaID LIQUID.LIQUID|SC_NAME)
    (TALOS|DPTF.C_DeployAccount StakedKadenaID LIQUID.LIQUID|SC_NAME)
)

;;Step 3
;;dalos, dh-master
(let
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (AurynID:string "AURYN-dB66U26TF9zc")
        (EliteAurynID:string "ELITEAURYN-dB66U26TF9zc")
    )
    (TALOS|DPTF.C_SetFee patron AurynID UTILS.AURYN_FEE)
    (TALOS|DPTF.C_SetFee patron EliteAurynID UTILS.ELITE-AURYN_FEE)
    (TALOS|DPTF.C_ToggleFee patron AurynID true)
    (TALOS|DPTF.C_ToggleFee patron EliteAurynID true)
    (with-capability (DEPLOYER.SUMMONER)
        (BASIS.DPTF|C_ToggleFeeLock patron AurynID true)
        (BASIS.DPTF|C_ToggleFeeLock patron EliteAurynID true)
    )
)

;;Step 4
;;dalos, dh-master
(let
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (OuroID:string "OURO-dB66U26TF9zc")
        (GasID:string "GAS-dB66U26TF9zc")
    )
    (TALOS|DPTF.C_SetMinMove patron GasID 1000.0)
    (TALOS|DPTF.C_SetFee patron GasID -1.0)
    (TALOS|DPTF.C_SetFeeTarget patron GasID DALOS.DALOS|SC_NAME)
    (TALOS|DPTF.C_ToggleFee patron GasID true)
    (with-capability (DEPLOYER.SUMMONER)
        (BASIS.DPTF|C_ToggleFeeLock patron GasID true)
    )
    (TALOS|DPTF.C_ToggleBurnRole patron GasID OUROBOROS.OUROBOROS|SC_NAME true)
    (TALOS|DPTF.C_ToggleBurnRole patron OuroID OUROBOROS.OUROBOROS|SC_NAME true)
    (TALOS|DPTF.C_ToggleMintRole patron GasID OUROBOROS.OUROBOROS|SC_NAME true)
    (TALOS|DPTF.C_ToggleMintRole patron OuroID OUROBOROS.OUROBOROS|SC_NAME true)
)

;;Step 5
;;dalos, dh-master
(let
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (WrappedKadenaID:string "DWK-dB66U26TF9zc")
        (StakedKadenaID:string "DLK-dB66U26TF9zc")
    )
    (TALOS|DPTF.C_SetFee patron StakedKadenaID -1.0)
    (TALOS|DPTF.C_ToggleFee patron StakedKadenaID true)
    (with-capability (DEPLOYER.SUMMONER)
        (BASIS.DPTF|C_ToggleFeeLock patron StakedKadenaID true)
    )
    (TALOS|DPTF.C_ToggleBurnRole patron WrappedKadenaID LIQUID.LIQUID|SC_NAME true)
    (TALOS|DPTF.C_ToggleMintRole patron WrappedKadenaID LIQUID.LIQUID|SC_NAME true)
)

;;Step 6
;;dalos, dh-master
(let*
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (OuroID:string "OURO-dB66U26TF9zc")
        (AurynID:string "AURYN-dB66U26TF9zc")
        (EliteAurynID:string "ELITEAURYN-dB66U26TF9zc")
        (VestedOuroID:string 
            (with-capability (DEPLOYER.SUMMONER)
                (VESTING.VST|C_CreateVestingLink patron OuroID)
            )
        )
        (VestedAurynID:string 
            (with-capability (DEPLOYER.SUMMONER)
                (VESTING.VST|C_CreateVestingLink patron AurynID)
            )
        )
        (VestedEliteAurynID:string 
            (with-capability (DEPLOYER.SUMMONER)
                (VESTING.VST|C_CreateVestingLink patron EliteAurynID)
            )
        )
    )
    [VestedOuroID VestedAurynID VestedEliteAurynID]
)

;;Step 7
;;dalos, dh-master
(let*
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (OuroID:string "OURO-dB66U26TF9zc")
        (AurynID:string "AURYN-dB66U26TF9zc")
        (EliteAurynID:string "ELITEAURYN-dB66U26TF9zc")
        (WrappedKadenaID:string "DWK-dB66U26TF9zc")
        (StakedKadenaID:string "DLK-dB66U26TF9zc")
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
    )
    [Auryndex Elite-Auryndex Kadena-Liquid-Index]
)

;;Step 8
;;dalos, dh-master
(let
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (Auryndex:string "Auryndex-pQb0GtIJJngS")
        (Elite-Auryndex:string "EliteAuryndex-pQb0GtIJJngS")
        (Kadena-Liquid-Index:string "Kadindex-pQb0GtIJJngS")
    )
    (TALOS|ATS3.C_SetColdFee patron Auryndex
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
    (TALOS|ATS3.C_TurnRecoveryOn patron Auryndex true)
;;STEP 3.2 - Set Up <EliteAuryndex> Autostake-Pair
    (TALOS|ATS3.C_SetColdFee patron Elite-Auryndex 7 [0.0] [[0.0]])
    (TALOS|ATS3.C_SetCRD patron Elite-Auryndex false 360 24)
    (TALOS|ATS3.C_ToggleElite patron Elite-Auryndex true)
    (TALOS|ATS3.C_TurnRecoveryOn patron Elite-Auryndex true)
;;STEP 3.3 - Set Up <Kadindex> Autostake-Pair
    (TALOS|ATS3.C_SetColdFee patron Kadena-Liquid-Index -1 [0.0] [[0.0]])
    (TALOS|ATS3.C_SetCRD patron Kadena-Liquid-Index false 12 6)
    (TALOS|ATS3.C_TurnRecoveryOn patron Kadena-Liquid-Index true)
)

;;Step  9 - Create Principal Accounts 
;;  DALOS       (collected of 75% of fuel to be used by the gas station)
;;  OUROBOROS   (collecter of 15% fuel to be used for liquid staking)
;;  LIQUID      (keeper of native KDA - returning DWK)
(coin.create-account DALOS.DALOS|SC_KDA-NAME DALOS.DALOS|GUARD)                         ;;"c:G2mlrnV81JaMIrEJMan74nS3yQBlJD0BuSbUMzX1Tlg"
(coin.create-account OUROBOROS.OUROBOROS|SC_KDA-NAME OUROBOROS.OUROBOROS|GUARD)         ;;"c:KHlbLdqlcH6zmWdqZdFGHsCh9Nb0cqXf8WOKQijstJ8"
(coin.create-account LIQUID.LIQUID|SC_KDA-NAME LIQUID.LIQUID|GUARD)                     ;;"c:P31THC-NCoLEI5Kj7agNGMtVqT7v0keBi-bSrLb9eMs"


;Step 10 - Liquid Wrap 1 KDA
(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(let
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
    )
    (TALOS|LIQUID.C_WrapKadena patron patron 1.0)
)
;;with capability
(coin.TRANSFER "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb" "c:P31THC-NCoLEI5Kj7agNGMtVqT7v0keBi-bSrLb9eMs" 1.0 )
(coin.TRANSFER (DALOS|UR_AccountKadena patron) LIQUID.LIQUID|SC_KDA-NAME 1.0 ) ;;doesnt work


;Step 11 - Coil 1 DWK to 1 DLK to initialise the LiquidIndex ATS Pair.
(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(let
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
    )
    (TALOS|ATS3.C_Coil
        patron
        patron
        (at 0 (BASIS.DPTF|UR_RewardBearingToken (DALOS.DALOS|UR_LiquidKadenaID)))
        (DALOS.DALOS|UR_WrappedKadenaID)
        1.0
    )
)

;;Step 12 - Mint 10 million OURO
(let
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
    )
    (TALOS|DPTF.C_Mint
        patron
        "OURO-dB66U26TF9zc"
        patron
        10000000.0
        true
    )
)

;;Step 12 - Create another Standard DALOS Account for testing purposes, the Emma Account
;;Since no GAS collection is activated yet, this is going to be done without incurring DALOS Blockchain Gas Costs.
(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.us-0000_emma-keyset" (read-keyset "0000_emma-keyset"))
(TALOS|DALOS.C_DeployStandardAccount
    "Ѻ.A0ěьπΨтÎșπЦĐđŽ6ЫêÀεÅĐȘдÞЩ4Ł2ďй5žömiτsλÚÇдěÒaV₱ÏûιЩД₳îJÍşыyÜŹżęìvAЙsÄ¢ÿnΦIťQůЮ7ĄвaèďíoáнõÎLJθÆEáПiXÿÒÀĘ14цU1çΞêSťüIψчèι₱ê9ŽчΓüЦrÀÓμĆ99κQťqPÖшŮ1ÈČSĐŁÌбÝàŞbPσŃĎ8ĄW"
    (keyset-ref-guard "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.us-0000_emma-keyset")
    "k:6f152d5f5253892f37ce5ce1d6d5f2e0333a08e4cbbb183234273f8cc1563c27"
    "9G.39tf0E26stf4Dxiows9kidajrJGCjDighDd4jltItj9js3n8dFiiin5yphml1u0uAltxumFngoogIv8jypw4LlehiEbmuzxtwkdajn7j3M0s3s7g6aALwbbGt6uGjeuFw1ovxf769AzklLxke2MKfobAbDyIH2a6zwKC79eypy1tfdF2plELbfMq9KxtF1GvIri0y4c4Ll3rK0FqICktqmJEakeC4GadmsAatJzIa8vHj82uC0A3KrtkhLsz9cGmsC0Lmzi6GFvv0Cola8g1A4k2neFEAoCsHyepILCgCz6ftlLmsjwgBMfLLL0n3Iwa4lzsn0w2qHwqmvckCtEIeHfwd5m9MKg8AA51uaBDm76j9GnMpecaabqELMm2Fc1h4DhgmzJIIndmwj0vxKmqjnxfg891HKezsCJxIDmMvxC7JbGGbaLip7JaJ6kuuBmreFm3GyLIz1KKlIeBG6Ck8ftgpaGum2BrEFF45jom87uhba7lzfpq6ihG8H4MCAGyyrz9q3ben4yLv4Keqq9tt1q0F5AdC4s4Eox0ebLwLiCtgkrfp5qCohHBH8E8"
)

;;Step 13 - Check
(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(let
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (atspair:string  "Auryndex-pQb0GtIJJngS")
        (rt-amounts:[decimal] [376708.41507192753463272])
        (rbt-request-amount:decimal 143918.0)
    )
    (TALOS|ATS3.C_KickStart patron patron atspair rt-amounts rbt-request-amount)
)















;;STEP Check - this works
(DALOS.DALOS|C_TransferDalosFuel
    "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb"
    "c:P31THC-NCoLEI5Kj7agNGMtVqT7v0keBi-bSrLb9eMs"
    0.01
)
;;with
(coin.TRANSFER "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb" "c:P31THC-NCoLEI5Kj7agNGMtVqT7v0keBi-bSrLb9eMs" 0.01)

(DALOS.DALOS|C_TransferRawDalosFuel
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    0.1
)

;;STEP Check - works
(let
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
    )
    (TALOS|DPTF.C_Mint
        patron
        "OURO-dB66U26TF9zc"
        patron
        10000000.0
        true
    )
)


(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(DALOS.DALOS|C_TransferDalosFuel
    "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb"
    "k:2d67bbab17f774acbe430483642dcbec50432fb5f4527ee3dc57890f9b8b23bc"
    0.01
)

(coin.TRANSFER "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb" "k:2d67bbab17f774acbe430483642dcbec50432fb5f4527ee3dc57890f9b8b23bc" 0.005 )
(coin.TRANSFER "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb" "k:ebc59434f2f91b6e0daf1a3201328cf182301996db5304d75537062414c136f7" 0.005 )
(coin.TRANSFER "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb" "c:KHlbLdqlcH6zmWdqZdFGHsCh9Nb0cqXf8WOKQijstJ8" 0.015 )
(coin.TRANSFER "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb" "c:G2mlrnV81JaMIrEJMan74nS3yQBlJD0BuSbUMzX1Tlg" 0.075 )


(coin.transfer
    "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb"
    "k:2d67bbab17f774acbe430483642dcbec50432fb5f4527ee3dc57890f9b8b23bc"
    0.005
)

"k:ebc59434f2f91b6e0daf1a3201328cf182301996db5304d75537062414c136f7"





