;;STEP 001 - Namespace Deployment
(define-namespace 
    (ns.create-principal-namespace (read-keyset "dh_master-keyset"))
    (read-keyset "dh_master-keyset" )
    (read-keyset "dh_master-keyset" )
)

;;STEP 002 - Define all necesary keys on the created namespace
(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_master-keyset"                  (read-keyset "dh_master-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_dalos-keyset"                (read-keyset "dh_sc_dalos-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_autostake-keyset"            (read-keyset "dh_sc_autostake-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_vesting-keyset"              (read-keyset "dh_sc_vesting-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_kadenaliquidstaking-keyset"  (read-keyset "dh_sc_kadenaliquidstaking-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_ouroboros-keyset"            (read-keyset "dh_sc_ouroboros-keyset"))

(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.dh_ah-keyset"                      (read-keyset "dh_ah-keyset"))
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.dh_cto-keyset"                     (read-keyset "dh_cto-keyset"))
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.dh_hov-keyset"                     (read-keyset "dh_hov-keyset"))

(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.us-0000_aozt-keyset"               (read-keyset "0000_aozt-keyset"))
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.us-0001_emma-keyset"               (read-keyset "0001_emma-keyset"))
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.us-0002_lumy-keyset"               (read-keyset "0002_lumy-keyset"))


;;dh_master-keyset                      ||  dada
;;dh_sc_dalos-keyset                    ||
;;dh_sc_autostake-keyset                ||
;;dh_sc_vesting-keyset                  ||
;;dh_sc_kadenaliquidstaking-keyset      ||
;;dh_sc_ouroboros-keyset                ||

;;dh_ah-keyset                          ||
;;dh_cto-keyset                         ||
;;dh_hov-keyset                         ||

;;us-0000_aozt-keyset                   ||
;;us-0001_emma-keyset                   ||
;;us-0002_lumy-keyset                   ||


;;STEP 003 - Modify the KDA Accounts in the modules to be deployed to accounts defined via chainweaver for easier manipulation
;;ATS.ATS|SC_KDA-NAME || VST.VST|SC_KDA-NAME || DEPLOYER.DEMIURGOI|AH_KDA-NAME ||
;;DEPLOYER.DEMIURGOI|CTO_KDA-NAME || DEPLOYER.DEMIURGOI|HOV_KDA-NAME ||
;;AOZ.AOZ|SC_KDA-NAME

;;STEP 004 - Deploy Modules in the namespace you made

;;STEP 005 - Spawn AH, CTO and HOV Dalos Accounts as well as user accounts
(DALOS.DALOS|A_DeployStandardAccount
    DEPLOYER.DEMIURGOI|AH_NAME
    (keyset-ref-guard DEPLOYER.DEMIURGOI|AH_KEY)
    DEPLOYER.DEMIURGOI|AH_KDA-NAME
    DEPLOYER.DEMIURGOI|AH_PBL
)
(DALOS.DALOS|A_DeployStandardAccount
    DEPLOYER.DEMIURGOI|CTO_NAME
    (keyset-ref-guard DEPLOYER.DEMIURGOI|CTO_KEY)
    DEPLOYER.DEMIURGOI|CTO_KDA-NAME
    DEPLOYER.DEMIURGOI|CTO_PBL
)
(DALOS.DALOS|A_DeployStandardAccount
    DEPLOYER.DEMIURGOI|HOV_NAME
    (keyset-ref-guard DEPLOYER.DEMIURGOI|HOV_KEY)
    DEPLOYER.DEMIURGOI|HOV_KDA-NAME
    DEPLOYER.DEMIURGOI|HOV_PBL
)
;;AOZT Emma Lumy 
(let
    (
        (acc1:string "Ѻ.ÅτhGźνΣhςвiàÁĘĚДÏWÉΨTěCÃŒnæi9цéŘQí¢лΞÛIчмfÓeżÜýЯàDÖ5αȚÞVđσγ₱0ęЬÔĄsĄLлKùvåH£ΞMFУûÊyđÜqdŽŚЖsĘъsПÂÔØŹÞŮγŚΣЧ6Ïж¢чPyòлБ14ÚęŃĄåîêтηΛbΦđkûÇĂζsБúĎdŸUЛзÙÂÚJηXťćж¥zщòÁŸRĘ")
        (key1:string "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.us-0000_aozt-keyset")
        (kda1:string "")
        (pbl1:string "9G.29k17uqiwBF7mbc3rzr5gz228lxepz7a0fwrja2Bgzk1czjCLja3wg9q1ey10ftFhxIAiFBHCtvotkmKIIxFisMni8EA6esncL3lg2uLLH2u89Er9sgbeGmK0k7b63xujf1nAIf5GB583fcE6pzFak2CwhEi1dHzI0F14tvtxv4H8r1ABk5weoJ7HfCoadMm1h8MjIwjzbDKo80H25AJL8I1JiFF66Iwjcj3sFrD9xaqz1ziEEBJICF2k81pG9ABpDk2rK4ooglCK3kmC0h7yvvakjIvMpGp00jnw2Cpg1HoxjK0HoqzuKciIIczGsEzCjoB43x7lKsxkzAm7op2urv0I85Kon7uIBmg328cuKMc8driw8boAFnrdqHEFhx4sFjm8DM44FutCykKGx7GGLnoeJLaC707lot9tM51krmp6KDG8Ii318fIc1L5iuzqEwDnkro35JthzlDD1GkJaGgze3kDApAckn3uMcBypdz4LxbDGrg5K2GdiFBdFHqdpHyssrH8t694BkBtM9EB3yI3ojbnrbKrEM8fMaHAH2zl4x5gdkHnpjAeo8nz")
        
        (acc2:string "Ѻ.A0ěьπΨтÎșπЦĐđŽ6ЫêÀεÅĐȘдÞЩ4Ł2ďй5žömiτsλÚÇдěÒaV₱ÏûιЩД₳îJÍşыyÜŹżęìvAЙsÄ¢ÿnΦIťQůЮ7ĄвaèďíoáнõÎLJθÆEáПiXÿÒÀĘ14цU1çΞêSťüIψчèι₱ê9ŽчΓüЦrÀÓμĆ99κQťqPÖшŮ1ÈČSĐŁÌбÝàŞbPσŃĎ8ĄW")
        (key2:string "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.us-0001_emma-keyset")
        (kda2:string "")
        (pbl2:string "9G.39tf0E26stf4Dxiows9kidajrJGCjDighDd4jltItj9js3n8dFiiin5yphml1u0uAltxumFngoogIv8jypw4LlehiEbmuzxtwkdajn7j3M0s3s7g6aALwbbGt6uGjeuFw1ovxf769AzklLxke2MKfobAbDyIH2a6zwKC79eypy1tfdF2plELbfMq9KxtF1GvIri0y4c4Ll3rK0FqICktqmJEakeC4GadmsAatJzIa8vHj82uC0A3KrtkhLsz9cGmsC0Lmzi6GFvv0Cola8g1A4k2neFEAoCsHyepILCgCz6ftlLmsjwgBMfLLL0n3Iwa4lzsn0w2qHwqmvckCtEIeHfwd5m9MKg8AA51uaBDm76j9GnMpecaabqELMm2Fc1h4DhgmzJIIndmwj0vxKmqjnxfg891HKezsCJxIDmMvxC7JbGGbaLip7JaJ6kuuBmreFm3GyLIz1KKlIeBG6Ck8ftgpaGum2BrEFF45jom87uhba7lzfpq6ihG8H4MCAGyyrz9q3ben4yLv4Keqq9tt1q0F5AdC4s4Eox0ebLwLiCtgkrfp5qCohHBH8E8")

        (acc3:string "Ѻ.œâσzüştŒhłσćØTöõúoвþçЧлρËШđюλ2ÙPeжŘťȚŤtθËûrólþŘß₿øuŁdáNÎČȘřΦĘbχλΩĄ¢ц2ŹθõĐLcÑÁäăå₿ξЭжулxòΘηĂœŞÝUËcω∇ß$ωoñД7θÁяЯéEU¢CЮxÃэJĘčÎΠ£αöŮЖбlćшbăÙЦÎAдŃЭб$ĞцFδŃËúHãjÁÝàĘSt")
        (key3:string "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.us-0002_lumy-keyset")
        (kda3:string "")
        (pbl3:string "9G.1CAv9Fq0mmrgALMafmEv46lkzHj7yib75pCbDdtojimK8KHiBMqcMMj4002t612H5HaKD6yBDo556n2Jsc7CvxFlo0knLpoLMs331kCgur71s7tHbc20iAx5IvCdaektlscciwLAH8bKIprgBmJubk12xKGfw2FbdjH8Hgygs5g2LJKsf11sh6croly7w8G6E2LLHsf1D5HImE3K7Jd5wMkjcCHsu2khw6wpmxotBf1l1jMxedypoyGh5GHzy15hKafx4cL97ttq8jEvnioLshycFct228L6xsIIadmcodbyyyDhA2H7yqe2C5rwAvqirFHy5d40Mo2mFyJhG4D3HvwphdCuGCkM9yv3vdDFo4HHGDAllz2Ig6B1y8lf9Dmg9kk3fIFI5m7f8p01Hejq30JsA4av0cruGEIIB94AbyJvec09u2DA9gi7t4qDurc8pxw8qgs8v4IFoB2k1vwint9z2JAc82kw5t4frwip3Isx7zk3za2qdi5M6ifiFokdzidA0A0u3eho6goh5x8nn3llBDz6E9uDKedyApF1nzDkJefAIbigke32psym")

        
    )
    (DALOS.DALOS|A_DeployStandardAccount acc1 (keyset-ref-guard key1) kda1 pbl1)
    (DALOS.DALOS|A_DeployStandardAccount acc2 (keyset-ref-guard key2) kda2 pbl2)
    (DALOS.DALOS|A_DeployStandardAccount acc3 (keyset-ref-guard key2) kda3 pbl3)
)

;;STEP 006 - Define Policies for intermodule communication
(BASIS.DefinePolicies)
(ATS.DefinePolicies)

(ATSI.DefinePolicies)
(TFT.DefinePolicies)

(ATSC.DefinePolicies)
(ATSH.DefinePolicies)

(ATSM.DefinePolicies)
(VESTING.DefinePolicies)

(BRANDING.DefinePolicies)
(SWPM.DefinePolicies)

(TALOS-01.DefinePolicies)
(TALOS-02.DefinePolicies)

;(DEPLOYER.DefinePolicies)  || EMPTY
;(LIQUID.DefinePolicies)    || EMPTY
;(OUROBOROS.DefinePolicies) || EMPTY

;;STEP 007 - Set Up Virtual Blockhain KDA Prices; Live prices are 1000x these values
;;Kadena Prices
(DALOS.DALOS|A_UpdateUsagePrice "standard"      0.01)
(DALOS.DALOS|A_UpdateUsagePrice "smart"         0.02)
(DALOS.DALOS|A_UpdateUsagePrice "ats"            0.1)
(DALOS.DALOS|A_UpdateUsagePrice "swp"           0.15)
(DALOS.DALOS|A_UpdateUsagePrice "dptf"           0.2)
(DALOS.DALOS|A_UpdateUsagePrice "dpmf"           0.3)
(DALOS.DALOS|A_UpdateUsagePrice "dpsf"           0.4)
(DALOS.DALOS|A_UpdateUsagePrice "dpnf"           0.5)
(DALOS.DALOS|A_UpdateUsagePrice "blue"         0.025)

;;Ignis Prices
(DALOS.DALOS|A_UpdateUsagePrice "ignis|smallest"            1.0)
(DALOS.DALOS|A_UpdateUsagePrice "ignis|small"               2.0)
(DALOS.DALOS|A_UpdateUsagePrice "ignis|medium"              3.0)
(DALOS.DALOS|A_UpdateUsagePrice "ignis|big"                 4.0)
(DALOS.DALOS|A_UpdateUsagePrice "ignis|biggest"             5.0)
(DALOS.DALOS|A_UpdateUsagePrice "ignis|branding"          100.0)
(DALOS.DALOS|A_UpdateUsagePrice "ignis|token-issue"       500.0)
(DALOS.DALOS|A_UpdateUsagePrice "ignis|ats-issue"        5000.0)
(DALOS.DALOS|A_UpdateUsagePrice "ignis|swp-issue"        4000.0)

;:STEP 008 - Initialise the DALOS Properties Table with empty values and the Dalos Gas Management Table with initial values
(insert DALOS.DALOS|PropertiesTable DALOS.DALOS|INFO
    {"demiurgoi"                : 
        [
            DEPLOYER.DEMIURGOI|CTO_NAME
            DEPLOYER.DEMIURGOI|HOV_NAME
        ]
    ,"unity-id"                 : UTILS.BAR
    ,"gas-source-id"            : UTILS.BAR
    ,"gas-source-id-price"      : 0.0
    ,"gas-id"                   : UTILS.BAR
    ,"ats-gas-source-id"        : UTILS.BAR
    ,"elite-ats-gas-source-id"  : UTILS.BAR
    ,"wrapped-kda-id"           : UTILS.BAR
    ,"liquid-kda-id"            : UTILS.BAR}
)
(insert DALOS.DALOS|GasManagementTable DALOS.DALOS|VGD
    {"virtual-gas-tank"         : DALOS.DALOS|SC_NAME
    ,"virtual-gas-toggle"       : false
    ,"virtual-gas-spent"        : 0.0
    ,"native-gas-toggle"        : false
    ,"native-gas-spent"         : 0.0}
)

;:STEP 009 - Create the Smart DALOS Accounts needed for running the Virtual Blockchain with AH as patron
(let
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
    )
    (DALOS.DALOS|A_DeploySmartAccount DEPLOYER.DALOS|SC_NAME (keyset-ref-guard DEPLOYER.DALOS|SC_KEY) DEPLOYER.DALOS|SC_KDA-NAME patron DEPLOYER.DALOS|PBL)
    ;; 
    (DALOS.DALOS|A_DeploySmartAccount DEPLOYER.ATS|SC_NAME (keyset-ref-guard DEPLOYER.ATS|SC_KEY) DEPLOYER.ATS|SC_KDA-NAME patron DEPLOYER.ATS|PBL)
    (ATS.ATS|SetGovernor patron)
    ;;
    (DALOS.DALOS|A_DeploySmartAccount DEPLOYER.VST|SC_NAME (keyset-ref-guard DEPLOYER.VST|SC_KEY) DEPLOYER.VST|SC_KDA-NAME patron DEPLOYER.VST|PBL)
    (VESTING.VST|SetGovernor patron)
    ;;    
    (DALOS.DALOS|A_DeploySmartAccount DEPLOYER.LIQUID|SC_NAME (keyset-ref-guard DEPLOYER.LIQUID|SC_KEY) DEPLOYER.LIQUID|SC_KDA-NAME patron DEPLOYER.LIQUID|PBL)
    (LIQUID.LIQUID|SetGovernor patron)
    ;;
    (DALOS.DALOS|A_DeploySmartAccount DEPLOYER.OUROBOROS|SC_NAME (keyset-ref-guard DEPLOYER.OUROBOROS|SC_KEY) DEPLOYER.OUROBOROS|SC_KDA-NAME patron DEPLOYER.OUROBOROS|PBL)
    (OUROBOROS.OUROBOROS|SetGovernor patron)
    ;;
    (DALOS.DALOS|A_DeploySmartAccount DEPLOYER.SWAPPER|SC_NAME (keyset-ref-guard DEPLOYER.SWAPPER|SC_KEY) DEPLOYER.SWAPPER|SC_KDA-NAME patron DEPLOYER.SWAPPER|PBL)
    (SWP.SWP|SetGovernor patron)
)

;;STEP 010 - Create Autonomous Accounts
(coin.create-account DALOS.DALOS|SC_KDA-NAME DALOS.DALOS|GUARD) 
(coin.create-account OUROBOROS.OUROBOROS|SC_KDA-NAME OUROBOROS.OUROBOROS|GUARD) 
(coin.create-account LIQUID.LIQUID|SC_KDA-NAME LIQUID.LIQUID|GUARD)

;;STEP 011 - Create the needed initial True Fungibles
;;AH, Dalos key needed, DALOS is owner of the created tokens.
(TALOS-01.DPTF|C_Issue
    DEPLOYER.DEMIURGOI|AH_NAME
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

;:STEP 012 - Update DALOS Properties table with Token IDs and deploy DPTF Accounts
;;Proper Token ID must be inputed, as outputs from running the code in STEP 010.
(let
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
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
    (BASIS.DPTF-DPMF|C_DeployAccount AurynID ATS.ATS|SC_NAME true)
    (BASIS.DPTF-DPMF|C_DeployAccount EliteAurynID ATS.ATS|SC_NAME true)
    (BASIS.DPTF-DPMF|C_DeployAccount WrappedKadenaID LIQUID.LIQUID|SC_NAME true)
    (BASIS.DPTF-DPMF|C_DeployAccount StakedKadenaID LIQUID.LIQUID|SC_NAME true)
)

;;STEP 013 - Setup Elite Auryns
(let
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
        (AurynID:string (DALOS.DALOS|UR_AurynID))
        (EliteAurynID:string (DALOS.DALOS|UR_EliteAurynID))
    )
    (BASIS.DPTF|C_SetFee patron AurynID UTILS.AURYN_FEE)
    (BASIS.DPTF|C_SetFee patron EliteAurynID UTILS.ELITE-AURYN_FEE)
    (BASIS.DPTF|C_ToggleFee patron AurynID true)
    (BASIS.DPTF|C_ToggleFee patron EliteAurynID true)
    (TALOS-01.DPTF|C_ToggleFeeLock patron AurynID true)
    (TALOS-01.DPTF|C_ToggleFeeLock patron EliteAurynID true)
)

;;STEP 014 - Setup OURO and IGNIS
(let
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
        (OuroID:string (DALOS.DALOS|UR_OuroborosID))
        (GasID:string (DALOS.DALOS|UR_IgnisID))
    )
    (BASIS.DPTF|C_SetMinMove patron GasID 1000.0)
    (BASIS.DPTF|C_SetFee patron GasID -1.0)
    (BASIS.DPTF|C_SetFeeTarget patron GasID DALOS.DALOS|SC_NAME)
    (BASIS.DPTF|C_ToggleFee patron GasID true)
    (TALOS-01.DPTF|C_ToggleFeeLock patron GasID true)
    (ATSI.DPTF-DPMF|C_ToggleBurnRole patron GasID OUROBOROS.OUROBOROS|SC_NAME true true)
    (ATSI.DPTF-DPMF|C_ToggleBurnRole patron OuroID OUROBOROS.OUROBOROS|SC_NAME true true)
    (ATSI.DPTF|C_ToggleMintRole patron GasID OUROBOROS.OUROBOROS|SC_NAME true)
    (ATSI.DPTF|C_ToggleMintRole patron OuroID OUROBOROS.OUROBOROS|SC_NAME true)
)

;:STEP 015 - Setup Wrapped and Liquid Kadena
(let
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
        (WrappedKadenaID:string (DALOS.DALOS|UR_WrappedKadenaID))
        (StakedKadenaID:string (DALOS.DALOS|UR_LiquidKadenaID))
    )
    (BASIS.DPTF|C_SetFee patron StakedKadenaID -1.0)
    (BASIS.DPTF|C_ToggleFee patron StakedKadenaID true)
    (TALOS-01.DPTF|C_ToggleFeeLock patron StakedKadenaID true)
    (ATSI.DPTF-DPMF|C_ToggleBurnRole patron WrappedKadenaID LIQUID.LIQUID|SC_NAME true true)
    (ATSI.DPTF|C_ToggleMintRole patron WrappedKadenaID LIQUID.LIQUID|SC_NAME true)
)

;;STEP 016 - Created Vested Snake Tokens
(let*
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
        (OuroID:string (DALOS.DALOS|UR_OuroborosID))
        (AurynID:string (DALOS.DALOS|UR_AurynID))
        (EliteAurynID:string (DALOS.DALOS|UR_EliteAurynID))

        (VestedOuroID:string (TALOS-01.VST|C_CreateVestingLink patron OuroID))
        (VestedAurynID:string (TALOS-01.VST|C_CreateVestingLink patron AurynID))
        (VestedEliteAurynID:string (TALOS-01.VST|C_CreateVestingLink patron EliteAurynID))
    )
    [VestedOuroID VestedAurynID VestedEliteAurynID]
)

;;STEP 017 - Create Snake and Liquid Kadena Autostake Pairs
(let*
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
        (OuroID:string (DALOS.DALOS|UR_OuroborosID))
        (AurynID:string (DALOS.DALOS|UR_AurynID))
        (EliteAurynID:string (DALOS.DALOS|UR_EliteAurynID))
        (WrappedKadenaID:string (DALOS.DALOS|UR_WrappedKadenaID))
        (StakedKadenaID:string (DALOS.DALOS|UR_LiquidKadenaID))
        (ats-ids:[string]
            (TALOS-01.ATS|C_Issue
                patron
                patron
                ["Auryndex" "EliteAuryndex" "KdaLiquindex"]
                [24 24 24]
                [OuroID AurynID WrappedKadenaID]
                [true true false]
                [AurynID EliteAurynID StakedKadenaID]
                [false true true]
            )    
        )
    )
    ats-ids
)

;;STEP 018 - Setup Autostake Pairs
(let
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
        (Auryndex:string (at 0 (BASIS.DPTF|UR_RewardBearingToken (DALOS.DALOS|UR_AurynID))))
        (Elite-Auryndex:string (at 0 (BASIS.DPTF|UR_RewardBearingToken (DALOS.DALOS|UR_EliteAurynID))))
        (Kadena-Liquid-Index:string (at 0 (BASIS.DPTF|UR_RewardBearingToken (DALOS.DALOS|UR_LiquidKadenaID))))
    )
    (ATSM.ATSM|C_SetColdFee patron Auryndex
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
    (ATSM.ATSM|C_TurnRecoveryOn patron Auryndex true)
;;STEP 3.2 - Set Up <EliteAuryndex> Autostake-Pair
    (ATSM.ATSM|C_SetColdFee patron Elite-Auryndex 7 [0.0] [[0.0]])
    (ATSM.ATSM|C_SetCRD patron Elite-Auryndex false 360 24)
    (ATSM.ATSM|C_ToggleElite patron Elite-Auryndex true)
    (ATSM.ATSM|C_TurnRecoveryOn patron Elite-Auryndex true)
;;STEP 3.3 - Set Up <Kadindex> Autostake-Pair
    (ATSM.ATSM|C_SetColdFee patron Kadena-Liquid-Index -1 [0.0] [[0.0]])
    (ATSM.ATSM|C_SetCRD patron Kadena-Liquid-Index false 12 6)
    (ATSM.ATSM|C_TurnRecoveryOn patron Kadena-Liquid-Index true)
)

;;STEP 019 - Liquid Wrap 1 KDA
(let
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
    )
    (LIQUID.LIQUID|C_WrapKadena patron patron 1.0)
)
;;using signature capability from <DEMIURGOI|AH_KDA-NAME> to <LIQUID.LIQUID|SC_KDA-NAME>
(coin.TRANSFER "" "" 1.0 )

;;STEP 020 - Coil 1 DWK to 1 DLK to initialise the LiquidIndex ATS Pair.
(let
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
    )
    (ATSM.ATSM|C_Coil
        patron
        patron
        (at 0 (BASIS.DPTF|UR_RewardBearingToken (DALOS.DALOS|UR_LiquidKadenaID)))
        (DALOS.DALOS|UR_WrappedKadenaID)
        1.0
    )
)

;;STEP 021 - Mint required OURO Amount by AH Account
;;Replace <ouro-amount> wtih MVX current OURO Supply
(let
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
        (ouro-amount:decimal 10000000.0)
    )
    (BASIS.DPTF|C_Mint
        patron
        (DALOS.DALOS|UR_OuroborosID)
        patron
        ouro-amount
        true
    )
)

;;STEP 022 - Kickstart Auryndex to the MVX values.
;;Replace <[rt-amounts]> with OURO Amount existing in the ATS Pair on MVX
;;Replace <rbt-request-amount> with the total existing supply of AURYN on MVX
(let
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
        (atspair:string  (at 0 (BASIS.DPTF|UR_RewardBearingToken (DALOS.DALOS|UR_AurynID))))
        (rt-amounts:[decimal] [372911.1318])
        (rbt-request-amount:decimal 144412.0)
    )
    (ATSM.ATSM|C_KickStart patron patron atspair rt-amounts rbt-request-amount)
)

;;STEP 023 - Kickstart EliteAuryndex to the MVX values
;;Replace <[rt-amounts]> with AURYN Amount existing in the ATS Pair on MVX
;;Replace <rbt-request-amount> with the total existing supply of ELITEAURYN on MVX
;;The two values must be equal.
(let*
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
        (atspair:string  (at 0 (BASIS.DPTF|UR_RewardBearingToken (DALOS.DALOS|UR_EliteAurynID))))
        (rt-amounts:[decimal] [102929.0])
        (rbt-request-amount:decimal (at 0 rt-amounts))
    )
    (ATSM.ATSM|C_KickStart patron patron atspair rt-amounts rbt-request-amount)
)

;;STEP 024 - Generate some IGNIS for AH, AOZT, EMMA and LUMY accounts before turning on Gas Collection
(let
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
        (aozt:string "Ѻ.ÅτhGźνΣhςвiàÁĘĚДÏWÉΨTěCÃŒnæi9цéŘQí¢лΞÛIчмfÓeżÜýЯàDÖ5αȚÞVđσγ₱0ęЬÔĄsĄLлKùvåH£ΞMFУûÊyđÜqdŽŚЖsĘъsПÂÔØŹÞŮγŚΣЧ6Ïж¢чPyòлБ14ÚęŃĄåîêтηΛbΦđkûÇĂζsБúĎdŸUЛзÙÂÚJηXťćж¥zщòÁŸRĘ")
        (emma:string "Ѻ.A0ěьπΨтÎșπЦĐđŽ6ЫêÀεÅĐȘдÞЩ4Ł2ďй5žömiτsλÚÇдěÒaV₱ÏûιЩД₳îJÍşыyÜŹżęìvAЙsÄ¢ÿnΦIťQůЮ7ĄвaèďíoáнõÎLJθÆEáПiXÿÒÀĘ14цU1çΞêSťüIψчèι₱ê9ŽчΓüЦrÀÓμĆ99κQťqPÖшŮ1ÈČSĐŁÌбÝàŞbPσŃĎ8ĄW")
        (lumy:string "Ѻ.œâσzüştŒhłσćØTöõúoвþçЧлρËШđюλ2ÙPeжŘťȚŤtθËûrólþŘß₿øuŁdáNÎČȘřΦĘbχλΩĄ¢ц2ŹθõĐLcÑÁäăå₿ξЭжулxòΘηĂœŞÝUËcω∇ß$ωoñД7θÁяЯéEU¢CЮxÃэJĘčÎΠ£αöŮЖбlćшbăÙЦÎAдŃЭб$ĞцFδŃËúHãjÁÝàĘSt")
    )
    (OUROBOROS.IGNIS|C_Sublimate patron patron patron 10.0)
    (OUROBOROS.IGNIS|C_Sublimate patron patron aozt 750.0)
    (OUROBOROS.IGNIS|C_Sublimate patron patron emma 10.0)
    (OUROBOROS.IGNIS|C_Sublimate patron patron lumy 10.0)
)

;;STEP 025 - Turn Virtual (IGNIS) and Native (KDA Blockchain Costs) gas collection to on.
(DALOS.IGNIS|A_Toggle false true)
(DALOS.IGNIS|A_Toggle true true)

;;STEP 026 - Execute a simple 2.0 OURO Transfer (non-methodic, false as last input parameter) from AH to Emma, to observe IGNIS collection
(let
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
        (emma:string "Ѻ.A0ěьπΨтÎșπЦĐđŽ6ЫêÀεÅĐȘдÞЩ4Ł2ďй5žömiτsλÚÇдěÒaV₱ÏûιЩД₳îJÍşыyÜŹżęìvAЙsÄ¢ÿnΦIťQůЮ7ĄвaèďíoáнõÎLJθÆEáПiXÿÒÀĘ14цU1çΞêSťüIψчèι₱ê9ŽчΓüЦrÀÓμĆ99κQťqPÖшŮ1ÈČSĐŁÌбÝàŞbPσŃĎ8ĄW")
        (ouro-id:string (DALOS.DALOS|UR_OuroborosID))

    )
    (TFT.DPTF|C_Transfer patron ouro-id patron emma 2.0 false)
)

;;Swapper Module Initialisations
;;STEP 027
(let
    (
        (u:[string] [UTILS.BAR])
    )
    (insert SWP.SWP|Properties SWP.SWP|INFO
        {"principals"           : u
        ,"liquid-boost"         : true}
    )
    (insert SWP.SWP|Pools SWP.P2
        {"pools"                : u}
    )
    (insert SWP.SWP|Pools SWP.P3
        {"pools"                : u}
    )
    (insert SWP.SWP|Pools SWP.P4
        {"pools"                : u}
    )
    (insert SWP.SWP|Pools SWP.P5
        {"pools"                : u}
    )
    (insert SWP.SWP|Pools SWP.P6
        {"pools"                : u}
    )
    (insert SWP.SWP|Pools SWP.P7
        {"pools"                : u}
    )
    (insert SWP.SWP|Pools SWP.S2
        {"pools"                : u}
    )
    (insert SWP.SWP|Pools SWP.S3
        {"pools"                : u}
    )
    (insert SWP.SWP|Pools SWP.S4
        {"pools"                : u}
    )
    (insert SWP.SWP|Pools SWP.S5
        {"pools"                : u}
    )
    (insert SWP.SWP|Pools SWP.S6
        {"pools"                : u}
    )
    (insert SWP.SWP|Pools SWP.S7
        {"pools"                : u}
    )
)

;;STEP 028
(SWP.SWP|A_UpdatePrincipal (DALOS.DALOS|UR_LiquidKadenaID) true)
(SWP.SWP|A_UpdatePrincipal (DALOS.DALOS|UR_OuroborosID) true)

;;STEP 029
(let
    (
        (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
    )
    (SWP.SWP|A_EnsurePrincipalRoles patron (DALOS.DALOS|UR_LiquidKadenaID))
    (SWP.SWP|A_EnsurePrincipalRoles patron (DALOS.DALOS|UR_OuroborosID))
)

;;AGE OF ZALMOXIS Deploy
;;STEP 01 - Initialise AOZ Assets Table
(insert AOZ.AOZ|Assets AOZ.AOZ|INFO
    {"primal-tf-ids"            : [""]
    ,"primal-mf-ids"            : [""]
    ,"atspair-ids"              : [""]
    ,"tf-game-assets"           : [""]
    ,"mf-game-assets"           : [""]
    ,"sf-game-assets"           : [""]
    ,"nf-game-assets"           : [""]}
)

;;STEP 02 - Issue AOZ True Fungibles, and update their ID in the AOZ|Assets Table
(let*
    (
        (patron:string AOZ.AOZ|SC_NAME)
        (tf-ids:[string]
            (TALOS-01.DPTF|C_Issue
                patron
                patron
                ["PrimordialKoson" "EsothericKoson" "AncientKoson" "PlebiumDenarius" "ComatusAureus" "PileatusSolidus" "TarabostesStater" "StrategonDrachma" "BasileonAs"]
                ["PKOSON" "EKOSON" "AKOSON" "PDKOSON" "CAKOSON" "PSKOSON" "TSKOSON" "SDKOSON" "BAKOSON"]
                [24 24 24 24 24 24 24 24 24]
                [true true true true true true true true true]          ;;can change owner
                [true true true true true true true true true]          ;;can upgrade
                [true true true true true true true true true]          ;;can can-add-special-role
                [false false false false false false false false false] ;;can-freeze
                [false false false false false false false false false] ;;can-wipe
                [true true true true true true true true true]          ;;can pause
            )
        )
    )
    (with-capability (AOZ.ADD_ASSET)
        (map
            (lambda
                (idx:integer)
                (AOZ.AOZ|A_AddPrimalTrueFungible (at idx tf-ids))
            )
            (enumerate 0 8)
        )
    )
    tf-ids
)

;:STEP 03 - Setup AOZ True Fungibles
(let
    (
        (patron:string AOZ.AOZ|SC_NAME)
        (PlebiumDenariusID:string (AOZ.AOZ|UR_Assets 1 3))
        (ComatusAureusID:string (AOZ.AOZ|UR_Assets 1 4))
        (PileatusSolidusID:string (AOZ.AOZ|UR_Assets 1 5))
        (TarabostesStaterID:string (AOZ.AOZ|UR_Assets 1 6))
        (StrategonDrachmaID:string (AOZ.AOZ|UR_Assets 1 7))
        (BasileonAsID:string (AOZ.AOZ|UR_Assets 1 8))
    )
    
    (BASIS.DPTF|C_SetFee patron PlebiumDenariusID 10.0)
    (BASIS.DPTF|C_ToggleFee patron PlebiumDenariusID true)
    (TALOS-01.DPTF|C_ToggleFeeLock patron PlebiumDenariusID true)

    (BASIS.DPTF|C_SetFee patron ComatusAureusID 20.0)
    (BASIS.DPTF|C_ToggleFee patron ComatusAureusID true)
    (TALOS-01.DPTF|C_ToggleFeeLock patron ComatusAureusID true)

    (BASIS.DPTF|C_SetFee patron PileatusSolidusID 30.0)
    (BASIS.DPTF|C_ToggleFee patron PileatusSolidusID true)
    (TALOS-01.DPTF|C_ToggleFeeLock patron PileatusSolidusID true)

    (BASIS.DPTF|C_SetFee patron TarabostesStaterID 40.0)
    (BASIS.DPTF|C_ToggleFee patron TarabostesStaterID true)
    (TALOS-01.DPTF|C_ToggleFeeLock patron TarabostesStaterID true)

    (BASIS.DPTF|C_SetFee patron StrategonDrachmaID 50.0)
    (BASIS.DPTF|C_ToggleFee patron StrategonDrachmaID true)
    (TALOS-01.DPTF|C_ToggleFeeLock patron StrategonDrachmaID true)

    (BASIS.DPTF|C_SetFee patron BasileonAsID 60.0)
    (BASIS.DPTF|C_ToggleFee patron BasileonAsID true)
    (TALOS-01.DPTF|C_ToggleFeeLock patron BasileonAsID true)
)

;;STEP 04 - Issue AOZ Meta Fungibles, and update their ID in the AOZ|Assets Table
(let*
    (
        (patron:string AOZ.AOZ|SC_NAME)
        (mf-ids:[string]
            (TALOS-01.DPMF|C_Issue
                patron
                patron
                ["DenariusDebilis" "AureusFragilis" "SolidusFractus" "StaterTenuulus" "DrachmaMinima" "AsInfinimus"]
                ["DDKOSON" "AFKOSON" "SFKOSON" "STKOSON" "DMKOSON" "AIKOSON"]
                [24 24 24 24 24 24]
                [true true true true true true]                         ;;can change owner
                [true true true true true true]                         ;;can upgrade
                [true true true true true true]                         ;;can can-add-special-role
                [false false false false false false]                   ;;can-freeze
                [false false false false false false]                   ;;can-wipe
                [true true true true true true]                         ;;can pause
                [true true true true true true]                         ;;can-transfer-nft-create-role
            )
        )
    )
    (with-capability (AOZ.ADD_ASSET)
        (map
            (lambda
                (idx:integer)
                (AOZ.AOZ|A_AddPrimalMetaFungible (at idx mf-ids))
            )
            (enumerate 0 5)
        )
    )
    mf-ids
)

;;STEP 05 - Issue AOZ ATS Pairs
(let*
    (
        (patron:string AOZ.AOZ|SC_NAME)
        (PrimordialKosonID:string (AOZ.AOZ|UR_Assets 1 0))
        (EsothericKosonID:string (AOZ.AOZ|UR_Assets 1 1))
        (AncientKosonID:string (AOZ.AOZ|UR_Assets 1 2))

        (PlebiumDenariusID:string (AOZ.AOZ|UR_Assets 1 3))
        (ComatusAureusID:string (AOZ.AOZ|UR_Assets 1 4))
        (PileatusSolidusID:string (AOZ.AOZ|UR_Assets 1 5))
        (TarabostesStaterID:string (AOZ.AOZ|UR_Assets 1 6))
        (StrategonDrachmaID:string (AOZ.AOZ|UR_Assets 1 7))
        (BasileonAsID:string (AOZ.AOZ|UR_Assets 1 8))

        (DenariusDebilisID:string (AOZ.AOZ|UR_Assets 2 0))
        (AureusFragilisID:string (AOZ.AOZ|UR_Assets 2 1))
        (SolidusFractusID:string (AOZ.AOZ|UR_Assets 2 2))
        (StaterTenuulusID:string (AOZ.AOZ|UR_Assets 2 3))
        (DrachmaMinimaID:string (AOZ.AOZ|UR_Assets 2 4))
        (AsInfinimusID:string (AOZ.AOZ|UR_Assets 2 5))

        (ats-ids:[string]
            (TALOS-01.ATS|C_Issue
                patron
                patron
                ["PlebeicStrength" "ComatiCommand" "PileatiPower" "TarabostesTenacity" "StrategonVigor" "AsAuthority"]
                [24 24 24 24 24 24]
                [PrimordialKosonID PrimordialKosonID PrimordialKosonID PrimordialKosonID PrimordialKosonID PrimordialKosonID]
                [false false false false false false]
                [PlebiumDenariusID ComatusAureusID PileatusSolidusID TarabostesStaterID StrategonDrachmaID BasileonAsID]
                [true true true true true true]
            )    
        )
    )
    (with-capability (AOZ.ADD_ASSET)
        (map
            (lambda
                (idx:integer)
                (AOZ.AOZ|A_AddATSPair (at idx ats-ids))
            )
            (enumerate 0 (- (length ats-ids) 1))
        )
    )
    ats-ids
)

;;STEP 06 - Setup AOZ ATS Pairs
(let
    (
        (patron:string AOZ.AOZ|SC_NAME)
        (PrimordialKosonID:string (AOZ.AOZ|UR_Assets 1 0))
        (EsothericKosonID:string (AOZ.AOZ|UR_Assets 1 1))
        (AncientKosonID:string (AOZ.AOZ|UR_Assets 1 2))

        (PlebiumDenariusID:string (AOZ.AOZ|UR_Assets 1 3))
        (ComatusAureusID:string (AOZ.AOZ|UR_Assets 1 4))
        (PileatusSolidusID:string (AOZ.AOZ|UR_Assets 1 5))

        (DenariusDebilisID:string (AOZ.AOZ|UR_Assets 2 0))
        (AureusFragilisID:string (AOZ.AOZ|UR_Assets 2 1))
        (SolidusFractusID:string (AOZ.AOZ|UR_Assets 2 2))

        (PlebeicStrengthID:string (AOZ.AOZ|UR_Assets 3 0))
        (ComatiCommandID:string (AOZ.AOZ|UR_Assets 3 1))
        (PileatiPowerID:string (AOZ.AOZ|UR_Assets 3 2))
    )
    ;;Plebeic Strength
    (ATSM.ATSM|C_AddSecondary patron PlebeicStrengthID EsothericKosonID false)
    (ATSM.ATSM|C_AddSecondary patron PlebeicStrengthID AncientKosonID false)
    (ATSM.ATSM|C_AddHotRBT patron PlebeicStrengthID DenariusDebilisID)
    (ATSM.ATSM|C_TurnRecoveryOn patron PlebeicStrengthID false)
    (ATSM.ATSM|C_TurnRecoveryOn patron PlebeicStrengthID true) ;;When deploying on mainnet must be removed
    ;;Comati Command
    (ATSM.ATSM|C_AddSecondary patron ComatiCommandID EsothericKosonID false)
    (ATSM.ATSM|C_AddSecondary patron ComatiCommandID AncientKosonID false)
    (ATSM.ATSM|C_AddHotRBT patron ComatiCommandID AureusFragilisID)
    (ATSM.ATSM|C_SetHotFee patron ComatiCommandID 900.0 90)
    (ATSM.ATSM|C_TurnRecoveryOn patron ComatiCommandID false)
    ;;Pileati Power
    (ATSM.ATSM|C_AddSecondary patron PileatiPowerID EsothericKosonID false)
    (ATSM.ATSM|C_AddSecondary patron PileatiPowerID AncientKosonID false)
    (ATSM.ATSM|C_AddHotRBT patron PileatiPowerID SolidusFractusID)
    (ATSM.ATSM|C_SetHotFee patron PileatiPowerID 900.0 180)
    (ATSM.ATSM|C_TurnRecoveryOn patron PileatiPowerID false)
)

;;STEP 07 - Setup AOZ ATS Pairs
(let
    (
        (patron:string AOZ.AOZ|SC_NAME)
        (PrimordialKosonID:string (AOZ.AOZ|UR_Assets 1 0))
        (EsothericKosonID:string (AOZ.AOZ|UR_Assets 1 1))
        (AncientKosonID:string (AOZ.AOZ|UR_Assets 1 2))

        (TarabostesStaterID:string (AOZ.AOZ|UR_Assets 1 6))
        (StrategonDrachmaID:string (AOZ.AOZ|UR_Assets 1 7))
        (BasileonAsID:string (AOZ.AOZ|UR_Assets 1 8))

        (StaterTenuulusID:string (AOZ.AOZ|UR_Assets 2 3))
        (DrachmaMinimaID:string (AOZ.AOZ|UR_Assets 2 4))
        (AsInfinimusID:string (AOZ.AOZ|UR_Assets 2 5))

        (TarabostesTenacityID:string (AOZ.AOZ|UR_Assets 3 3))
        (StrategonVigorID:string (AOZ.AOZ|UR_Assets 3 4))
        (AsAuthorityID:string (AOZ.AOZ|UR_Assets 3 5))
    )
    ;;Tarabostes Tenacity
    (ATSM.ATSM|C_AddSecondary patron TarabostesTenacityID EsothericKosonID false)
    (ATSM.ATSM|C_AddSecondary patron TarabostesTenacityID AncientKosonID false)
    (ATSM.ATSM|C_AddHotRBT patron TarabostesTenacityID StaterTenuulusID)
    (ATSM.ATSM|C_SetHotFee patron TarabostesTenacityID 900.0 360)
    (ATSM.ATSM|C_TurnRecoveryOn patron TarabostesTenacityID false)
    ;;Strategon Vigor
    (ATSM.ATSM|C_AddSecondary patron StrategonVigorID EsothericKosonID false)
    (ATSM.ATSM|C_AddSecondary patron StrategonVigorID AncientKosonID false)
    (ATSM.ATSM|C_AddHotRBT patron StrategonVigorID DrachmaMinimaID)
    (ATSM.ATSM|C_SetHotFee patron StrategonVigorID 900.0 720)
    (ATSM.ATSM|C_TurnRecoveryOn patron StrategonVigorID false)
    ;;As Authority
    (ATSM.ATSM|C_AddSecondary patron AsAuthorityID EsothericKosonID false)
    (ATSM.ATSM|C_AddSecondary patron AsAuthorityID AncientKosonID false)
    (ATSM.ATSM|C_AddHotRBT patron AsAuthorityID AsInfinimusID)
    (ATSM.ATSM|C_SetHotFee patron AsAuthorityID 900.0 1440)
    (ATSM.ATSM|C_TurnRecoveryOn patron AsAuthorityID false)
)

;;STEP 08 - Mint initial Koson Amounts
(let
    (
        (patron:string AOZ.AOZ|SC_NAME)
        (PrimordialKosonID:string (AOZ.AOZ|UR_Assets 1 0))
        (EsothericKosonID:string (AOZ.AOZ|UR_Assets 1 1))
        (AncientKosonID:string (AOZ.AOZ|UR_Assets 1 2))
    )
    (BASIS.DPTF|C_Mint
        patron
        PrimordialKosonID
        patron
        10000.0
        true
    )
    (BASIS.DPTF|C_Mint
        patron
        EsothericKosonID
        patron
        10000.0
        true
    )
    (BASIS.DPTF|C_Mint
        patron
        AncientKosonID
        patron
        10000.0
        true
    )
)

;;STEP 09 - Kickstart AOZ ATS Pool 1
(let
    (
        (patron:string AOZ|SC_NAME)
        (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
        (EsothericKosonID:string (AOZ|UR_Assets 1 1))
        (AncientKosonID:string (AOZ|UR_Assets 1 2))

        (PlebeicStrengthID:string (AOZ|UR_Assets 3 0))
        (am:decimal 250.0)
    )
    ;;Stake 250 250 250 PKOSON, EKOSON, AKOSON in PlebeicStrength to kickstart it.
    (ATSM.ATSM|C_Coil patron patron PlebeicStrengthID PrimordialKosonID am)
    (ATSM.ATSM|C_Coil patron patron PlebeicStrengthID EsothericKosonID am)
    (ATSM.ATSM|C_Coil patron patron PlebeicStrengthID AncientKosonID am)
)

;;STEP 10 - Kickstart AOZ ATS Pool 2
(let
    (
        (patron:string AOZ|SC_NAME)
        (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
        (EsothericKosonID:string (AOZ|UR_Assets 1 1))
        (AncientKosonID:string (AOZ|UR_Assets 1 2))

        (ComatiCommandID:string (AOZ|UR_Assets 3 1))
        (am:decimal 250.0)
    )
    ;;Stake 250 250 250 PKOSON, EKOSON, AKOSON in ComatiCommand to kickstart it.
    (ATSM.ATSM|C_Coil patron patron ComatiCommandID PrimordialKosonID am)
    (ATSM.ATSM|C_Coil patron patron ComatiCommandID EsothericKosonID am)
    (ATSM.ATSM|C_Coil patron patron ComatiCommandID AncientKosonID am)
)

;;STEP 11 - Kickstart AOZ ATS Pool 3
(let
    (
        (patron:string AOZ|SC_NAME)
        (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
        (EsothericKosonID:string (AOZ|UR_Assets 1 1))
        (AncientKosonID:string (AOZ|UR_Assets 1 2))

        (PileatiPowerID:string (AOZ|UR_Assets 3 2))
        (am:decimal 250.0)
    )
    ;;Stake 250 250 250 PKOSON, EKOSON, AKOSON in PileatiPower to kickstart it.
    (ATSM.ATSM|C_Coil patron patron PileatiPowerID PrimordialKosonID am)
    (ATSM.ATSM|C_Coil patron patron PileatiPowerID EsothericKosonID am)
    (ATSM.ATSM|C_Coil patron patron PileatiPowerID AncientKosonID am)
)

;;STEP 12 - Kickstart AOZ ATS Pool 4
(let
    (
        (patron:string AOZ|SC_NAME)
        (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
        (EsothericKosonID:string (AOZ|UR_Assets 1 1))
        (AncientKosonID:string (AOZ|UR_Assets 1 2))

        (TarabostesTenacityID:string (AOZ|UR_Assets 3 3))
        (am:decimal 250.0)
    )
    ;;Stake 250 250 250 PKOSON, EKOSON, AKOSON in TarabostesTenacity to kickstart it.
    (ATSM.ATSM|C_Coil patron patron TarabostesTenacityID PrimordialKosonID am)
    (ATSM.ATSM|C_Coil patron patron TarabostesTenacityID EsothericKosonID am)
    (ATSM.ATSM|C_Coil patron patron TarabostesTenacityID AncientKosonID am)
)

;;STEP 13 - Kickstart AOZ ATS Pool 5
(let
    (
        (patron:string AOZ|SC_NAME)
        (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
        (EsothericKosonID:string (AOZ|UR_Assets 1 1))
        (AncientKosonID:string (AOZ|UR_Assets 1 2))

        (StrategonVigorID:string (AOZ|UR_Assets 3 4))
        (am:decimal 250.0)
    )
    ;;Stake 250 250 250 PKOSON, EKOSON, AKOSON in StrategonVigor to kickstart it.
    (ATSM.ATSM|C_Coil patron patron StrategonVigorID PrimordialKosonID am)
    (ATSM.ATSM|C_Coil patron patron StrategonVigorID EsothericKosonID am)
    (ATSM.ATSM|C_Coil patron patron StrategonVigorID AncientKosonID am)
)

;;STEP 14 - Kickstart AOZ ATS Pool 6
(let
    (
        (patron:string AOZ|SC_NAME)
        (PrimordialKosonID:string (AOZ|UR_Assets 1 0))
        (EsothericKosonID:string (AOZ|UR_Assets 1 1))
        (AncientKosonID:string (AOZ|UR_Assets 1 2))

        (AsAuthorityID:string (AOZ|UR_Assets 3 5))
        (am:decimal 250.0)
    )
    ;;Stake 250 250 250 PKOSON, EKOSON, AKOSON in AsAuthority to kickstart it.
    (ATSM.ATSM|C_Coil patron patron AsAuthorityID PrimordialKosonID am)
    (ATSM.ATSM|C_Coil patron patron AsAuthorityID EsothericKosonID am)
    (ATSM.ATSM|C_Coil patron patron AsAuthorityID AncientKosonID am)
)
;;===========================================================================================


(let
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
    )
    (DALOS.DALOS|CAP_EnforceAccountOwnership patron)
    (DALOS.DALOS|C_TransferRawDalosFuel patron 0.05)
)

(coin.TRANSFER "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb" "k:2d67bbab17f774acbe430483642dcbec50432fb5f4527ee3dc57890f9b8b23bc" 0.0025)
(coin.TRANSFER "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb" "k:ebc59434f2f91b6e0daf1a3201328cf182301996db5304d75537062414c136f7" 0.0025)
(coin.TRANSFER "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb" "c:KHlbLdqlcH6zmWdqZdFGHsCh9Nb0cqXf8WOKQijstJ8" 0.0075)
(coin.TRANSFER "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb" "c:G2mlrnV81JaMIrEJMan74nS3yQBlJD0BuSbUMzX1Tlg" 0.0375)

(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(let*
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
    )
    ;;(DALOS.DALOS|CAP_EnforceAccountOwnership patron)
    ;;(DALOS.DALOS|C_TransferRawDalosFuel patron 0.05)
    (DALOS.DALOS|C_TransferDalosFuel
        "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb"
        "k:2d67bbab17f774acbe430483642dcbec50432fb5f4527ee3dc57890f9b8b23bc"
        0.025
    )
    (DALOS.DALOS|C_TransferDalosFuel
        "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb"
        "k:ebc59434f2f91b6e0daf1a3201328cf182301996db5304d75537062414c136f7"
        0.025
    )
    (DALOS.DALOS|C_TransferDalosFuel
        "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb"
        "c:KHlbLdqlcH6zmWdqZdFGHsCh9Nb0cqXf8WOKQijstJ8"
        0.075
    )
    (DALOS.DALOS|C_TransferDalosFuel
        "k:89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb"
        "c:G2mlrnV81JaMIrEJMan74nS3yQBlJD0BuSbUMzX1Tlg"
        0.0375
    )
)