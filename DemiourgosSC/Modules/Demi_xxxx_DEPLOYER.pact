;(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")
(module DEPLOYER GOVERNANCE

    (defcap GOVERNANCE ()
        (compose-capability (DEPLOYER-ADMIN))
    )

    (defcap DEPLOYER-ADMIN ()
        (enforce-guard G-MD_DEPLOYER)
    )

    ;;Module Guards
    (defconst G-MD_DEPLOYER (keyset-ref-guard DALOS.DALOS|DEMIURGOI))

    ;;Module Accounts Information
    ;;  DALOS
    (defconst DALOS|SC_KEY                  DALOS.DALOS|SC_KEY)
    (defconst DALOS|SC_NAME                 DALOS.DALOS|SC_NAME)
    (defconst DALOS|SC_KDA-NAME             DALOS.DALOS|SC_KDA-NAME)
    (defconst DALOS|PBL                     "9G.DwF3imJMCp4ht88DD1vx6pdjEkLM4j7Fvzso8zJF7Ixe1p2oKfGb53a5svtEF0Lz1q4MjvHaMrgqCfjlA1cBj2bzvs86EeLIMg2fmutzwbA5vI4woKoqq0acDHllAonxC4qLBulsLclMGwcw9iGxiw919t4tfD8FpcIc4MJ059ki7giFIAyCghgMwwr199v3qiDfIon426rbz1jMLmCe4jhHwD3sEarwMlmzLJ5li43J70CEDzouh7x8pu4u1GxJHa6Cabrsc147gIlzIdDmCC2j87LFpEdvqLge9o0w4av8mLr0lDAfalpnEabfkl0E6zE9KMG7LH2w7uvBIup3Hxxxu2Giwu29Cqye3fJ5ihcjacop4vtcLsi33ip742uAhGzjHaDLwAh933ntp8tEC1zkt9yi6n89JtsDLk477p80rscbGtsi14nxsMf7y0d7GxzE8FFmljElu5yE3vx25cEvc9574Hw4iIi23FFKfdhGF77LMqaBkDB9hJKmpc1B2rM1a8mfilyvLAdzpj57Ae5FG5vvm1n1nzgau373dBF7CuBAu2zbts09du55")
    ;;  AUTOSTAKE
    (defconst ATS|SC_KEY                    ATS.ATS|SC_KEY)
    (defconst ATS|SC_NAME                   ATS.ATS|SC_NAME)
    (defconst ATS|SC_KDA-NAME               ATS.ATS|SC_KDA-NAME)
    (defconst ATS|PBL                       "9H.9I8veD6Lqmcd5nKlb1vlHkg976FhdtooE3iH73h8i2Gq9tLKdclnpo07sC29i2yvMeuB0ikkKghiIgdAfkfDiM57o2phj2quCD8gutjIgDs6AlecMtw2lG6kMMBxBH4B5d1xqhpzA7AHkgEqF7Hgqwpx6E5aIMAtqxIpMhjyqziDiwLA69dKlhlwpjoze34Bwz6swBjlA880ItKfwxtulKEJG9oI3Gjmwgn6bbAgL7xy4brdbgK5DukMBHc0K1jIs1DjcDzhJz2liKultB67rKaBf3nMHMkbzhwl1hdu2wBCeHMLLphug2kE3tDtpxw6kLcj80qfBxvwmuxbeHjk349Md2B7eB4brt8fldi2CxGltfj41KA7GkgmtMa6szivDl5aCk9ozab9ohrsfBHikGL7GJ5Az4A2a8ufnIAJIz2mAgwGDmsAl7yyavbx12e5KhFFupclbKadmiFx8dvqkqwziu4vtt3AcKDhl96EzhuiKAF49vGoaAMo5vxM4h0t94nscG8IGl33De5MJGCpdf3g23D13eJ9BDi034wECutafzao4zzCe9IyvD3E")
    ;;  VESTING
    (defconst VST|SC_KEY                    VESTING.VST|SC_KEY)
    (defconst VST|SC_NAME                   VESTING.VST|SC_NAME)
    (defconst VST|SC_KDA-NAME               VESTING.VST|SC_KDA-NAME)
    (defconst VST|PBL                       "9G.5s5hoiGo96tMqyh3JBklmsvo8Lc3ol9m6zavJcCuqg4mBvkbDfcv5gEorMit8v8Mj9Jc18EI36Gq7cJ1IyA4e4wvl199KuCx3chsDKGDdfsvzk8mo317ulGk00pbxu7MLc2zw7joouaxt3Ax1KnlJz153ko0JtIxz7pqylfis45pDo2vvm1MH2kA2wmE2crxiEo6oEckuGqzz8oEaa9ez8ADLyqnj48lq4jGp4slkKo6a06ElezH619fsihIdmiMdfB036CJAr0rlzA2b5DgvEJcoyIFioru7vynBjLMLv3pvLFnbFeswrlyLjF8ry7kB52cD7bD7xaamCEjgIC2DsKMv5Mrd69BIKn2yKHC86f0hme9zs5dwMekAd6mc4wM4bDAk6Jrsl6s74ykKLF71pk45rIE1xxzFC4EjykBf6G0neBdaExI32HufaE5mEloDtvnC6vJ7HA9akkI3616MnLErA8eMIn7Kr2wI4l9CvGpKcF9HilzJmdqMa4kzJwqzuFc9LhDnrKcu0LvBHqsx2CrCM9EwHqpkkGe7w8eK8x0xK6K8drLaoBKmaB1")
    ;;  LIQUID-STAKING
    (defconst LIQUID|SC_KEY                 LIQUID.LIQUID|SC_KEY)
    (defconst LIQUID|SC_NAME                DALOS.LIQUID|SC_NAME)
    (defconst LIQUID|SC_KDA-NAME            LIQUID.LIQUID|SC_KDA-NAME)
    (defconst LIQUID|PBL                    "9H.b49lfzLzvC25g87fst6MqCkfbuqq39iGu50gDqi9jBEk6Cn86w54b91zDxeGgLdCxIjJDfyi6gBBwA93lyGLcdfggf0LzwKu405piavx0nEnqpzyHK125h2BhECnobmDBAps61c7mGmw5GrczBjvBMLxHwl2avt5jwhKeGxh7Ibm1ui6wI6lpAKBMay4tvEwHK0EibhbeaA2lLqjIwqMKnldp22txeje3DFLautFC798ExbLxG7q3om8l1f9qpMJkw9f5nmHsHGJcrcIF2mou9lmpr3hbz64La6nF9w26h7osABLMLlK9Glp48yrj4h1MkI7xjftytKDnJFyqvoMFqKvA43cJ81bJCvmn63eJ9jx5n3GxFbc9H4v400iFwtyIilmhKymsa1iCnwL29g21DvkaE6JJyxl5eLCiGH3Ml1nb0jkg16zJbf9cfg41KHA0IGFIvLj9LBhj7okL6wspCEBfkc5Aui6DAM7dvAqH54LApEaAzIgyMloEmqvBgt5wF0lyd05xHxz4Mtb3ItGb5fLpzbMGqGKBffi4dElI7Hbs6Id0hCKGaeIg9JL")
    ;;  OUROBOROS
    (defconst OUROBOROS|SC_KEY              OUROBOROS.OUROBOROS|SC_KEY)
    (defconst OUROBOROS|SC_NAME             DALOS.OUROBOROS|SC_NAME)
    (defconst OUROBOROS|SC_KDA-NAME         OUROBOROS.OUROBOROS|SC_KDA-NAME)
    (defconst OUROBOROS|PBL                 "9H.28jB2BBny4op601Cfqz9brFJKAEo67jbEDJi91i00pGjcD1Mpn0y0A1CxcAwGgBu35Ix3bG4e4p56Mu6x7Mmd50nKfmpDGtLy1ywyCjoDD5xiHBb0y5dAjB0fuokrqyx3ula9rtxyEHK1A4gkG4g3GEyysMtgF40IBgKjm7t8ffGshICIypFeF3gA5x0MixA0soiCx9tBnMDzI6G5xC8yIJJ3Bt2sCvJHAp7HAEA3rKK6Bgnx8hK94oDbgrpCkxw3zpo7tbeHhcakzbg0ELG3EJvk19hyd9LC73t2gizl0B6puq3Ljji5EDAhzno7K32x8vCagc5D2GLiMfdzEzsj5KEe1c2p7hxj76lMvp40r9F56vzlK8Kb7mrKt90ILEMqCghLrok7D4uH8h28EGqbK75wiyguimc1jDGxthyBJFfApClymKA57ehqbv2Lyv323w44b0kIItu35fjmhe2DCBMwjn67ffDII97b6AdyG010wvAHf55xFt25Mbm2pflsggL4D5jHtokl7qn6g4ltM5ilvHvsxn7jHe23Cfgoxn1JssdFMBpcDvB2xki7")

    ;; Demiurgoi
    (defconst DEMIURGOI|AH_KEY
        (+ UTILS.NS_USE ".dh_ah-keyset")
    )
    (defconst DEMIURGOI|AH_NAME "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
    (defconst DEMIURGOI|AH_KDA-NAME "k:6fa1d9c3e5078a54038159c9a6bd7182301e16d6f280615eddb18b8bd2d6c263")
    (defconst DEMIURGOI|AH_PBL "9G.CgcAjiI89ICnk45mxx63hwkBe5G71sIqfEta0ugkzF7EB6cy55BtzlFa27jDGE7Kn7ChljCmkcIsrDw9JwzJECieGLB5Jlkz9Blo6iJct6uxIA1u64Hr7HKa93EAiCwJJBBKAojJtwupEsvspH1jjGxKyFsb8fbfnJm1rAKxcIzcFILmmdHFaICfFpnbJG6tJu0HM9JCJ7MBCE7C2LiqvE6Fc1hqCeAdGHxDp7sGquI0wl2l08aa6wlKvwu44jgqF8mqDnCyjpxHuttEqjs4h9IJ28kmB53ppwoznt16rjzeMl21n3rwfI2es56rp5xavCabDacyCuonniz72L5d7dq3ptIEiuggEyLIIGe9sadH6eaMyitcmKaH7orgFz6d9kL9FKorBr06owFg328wFhCIlCFpwIzokmo47xKKt5kBzhyodBAjhCqayuHBue4oDhoA21A2H9ut9gApMuxokcmsi7Bd1kitrfJAy1GkrGiBK5dvlhgshcnGaG3vhkCm6dI5idCGjDEodivvDbgyI6zaajHvIMdBtrGvuKnxvsBulkbaDbk2wIdKwrK")

    (defconst DEMIURGOI|CTO_KEY
        (+ UTILS.NS_USE ".dh_cto-keyset")
    )
    (defconst DEMIURGOI|CTO_NAME "Ѻ.CЭΞŸNGúůρhãmИΘÛ¢₳šШдìAÚwŚGýηЗПAÊУÔȘřŽÍζЗηmΔφDmcдΛъ₳tĂýăŮsПÞ$öœGθeBŽvąαÃfçл¢ĎĆď$şbsЦэΘNÄëÍĂνуãöž¥àZjÆůšÁœôñχŽâЩåτâн4μфAOçĎΓuЗŮnøЙãĚè6Дżîþż$цÑûρψŻïZÉλûæřΨeèÎígςeL")
    (defconst DEMIURGOI|CTO_KDA-NAME "k:50d6c59b21e5e6e55baecaa75a1007de37576bde12d8230dc82459cc01b9484b")
    (defconst DEMIURGOI|CTO_PBL "9G.7si93iImtrM53Jl9C7pIojCAmq04gHyk8d1lle6x07Hfh57idcrqEznFM7ousiC14d16dlIbwAE2K7MBK79ApIMgb405svepvaz7azIIHGLulbIqBefscnsmydqD1pCHAKlH3xu6tJk6ejJk5fMlvtrvu2gc0lnz7knipdqvE6huvywrFt925E9Ci5bkspirF8GDA03Iorf5zdg1ad6tFG9uMBHL2aqsu0JcoicuoHcCnLHE6dBoignL7DiJrFGxgimrmrF5cLoqDjrjhb3GwFD4wfnMDbIqmq3MMrBJm96Ggve7worr5z5oLh5bhhrjHzf0fLH77ho1zv04kEM8odz6254H4JewC4sw9cxA1Aa9vaggj5owFK332Fff41lCi75otEhdzoheln2Czli46tcKv35o1ftkHLgrjAtMoIFDKuFjzv4d3kbqJ4Crzgtn63o95FMqFF91MbLGMLEBjis3sjJiGB0yLJzdBetdECclzxFo5cAve8o08Hifng4kEgExDzqFhKGdK9lCmyu4E9vo6k3jHjhH96KlvGDCjwMFcpkqyMB2gtlurlst")

    (defconst DEMIURGOI|HOV_KEY
        (+ UTILS.NS_USE ".dh_hov-keyset")
    )
    (defconst DEMIURGOI|HOV_NAME "Ѻ.ÍăüÙÜЦżΦF₿ÈшÕóñĐĞGюѺλωÇțnθòoйEςк₱0дş3ôPpxŞțqgЖ€šωbэočΞìČ5òżŁdŒИöùЪøŤяжλзÜ2ßżpĄγïčѺöэěτČэεSčDõžЩУЧÀ₳ŚàЪЙĎpЗΣ2ÃлτíČнÙyéÕãďWŹŘĘźσПåbã€éѺι€ΓφŠ₱ŽyWcy5ŘòmČ₿nβÁ¢¥NЙëOι")
    (defconst DEMIURGOI|HOV_KDA-NAME "k:0cb30c0121ff919266121a99ff9359871818932211df94dae4137c29bc0e8f7e")
    (defconst DEMIURGOI|HOV_PBL "9H.268Bnvp307DmbIcEltbEkpeHuK3C3qsD615ml5qefsA4HErwbqDhy6K1IvqxMeoCBh9mfieMj72jbzzI6a6nDtGhmf2nbHyE6M3zceog4o3bEkqcyvLsBdsGLt7Fu6Ei0Da6iej0n2z5M3bFsAk6iitosvzemff0B18kpeh5ocj5zb7DebFiLgAhIElsgg05Lh5CpyF5LqyKtlFvAay6wtCzsi2cM19BMB29nrfcIgKkaIkh2sjtAE5giM6th727eDekACBvMexk74wxgD2pJegzjuCqIe3BwozG5Fa29DqpcKM5zL1x78h7JKMj1ek2aanqnCtG33Dr3w2mzcIcLjlsDtMD1CG02CFlrCCAzMmlLmFgsBiIpt3Blj1uaxJG67xB2jwKj45s4LIDhzLea24m1AzFh6FD4MsF4Ay35i2Cvbmzdff6nuJbKM5tw5C31xapoqwEIeKkCC9zsiIk8GCMhis557p7Hk9H3aM059D24ar7KLmlr8cydi9n4u2rwH02rb8l1ixDbgoqn2jlCHDBxbCnf3A4GyI4FpaqJuBf1IwdI85Bq6qzcJIiK")

    ;; POLICY Capabilities
    (defcap SUMMONER ()
        @doc "Policy that allows accesing Client Functions from all prior modules"
        true
    )
    ;;Combined Policy Capabilities
    (defcap SUMMONER||DEPLOYER-ADMIN ()
        @doc "Dual Capability for simple usage"
        (compose-capability (SUMMONER))
        (compose-capability (DEPLOYER-ADMIN))
    )

    ;;Policies
    (defun DefinePolicies ()
        @doc "Add the Policies that allows running external Functions from this Module"
        (BASIS.A_AddPolicy
            "DEPLOYER|Summoner"
            (create-capability-guard (SUMMONER))
        )
        (VESTING.A_AddPolicy
            "DEPLOYER|Summoner"
            (create-capability-guard (SUMMONER))
        )
    )
    ;;
    ;;            FUNCTIONS         [17]
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;            Administrative Usage Functions        [A]
    (defun A_SpawnAncientHodler ()
        (TALOS|DALOS.A_DeployStandardAccount
            DEMIURGOI|AH_NAME
            (keyset-ref-guard DEMIURGOI|AH_KEY)
            DEMIURGOI|AH_KDA-NAME
            DEMIURGOI|AH_PBL
        )
    )
    (defun A_SpawnCTO ()
        (TALOS|DALOS.A_DeployStandardAccount
            DEMIURGOI|CTO_NAME
            (keyset-ref-guard DEMIURGOI|CTO_KEY)
            DEMIURGOI|CTO_KDA-NAME
            DEMIURGOI|CTO_PBL
        )
    )
    (defun A_SpawnHOV ()
        (TALOS|DALOS.A_DeployStandardAccount
            DEMIURGOI|HOV_NAME
            (keyset-ref-guard DEMIURGOI|HOV_KEY)
            DEMIURGOI|HOV_KDA-NAME
            DEMIURGOI|HOV_PBL
        )
    )
    (defun A_InitialiseVirtualBlockchain (patron:string)
        @doc "Main initialisation function for the DALOS Virtual Blockchain"
        ;;STEP 0.1
        (with-capability (SUMMONER||DEPLOYER-ADMIN)
            (DALOS|X_DefinePolicies)
            (DALOS|X_Initialise patron)
        )
    )
    ;;       [1]  Auxiliary Usage Functions             [X]
    (defun DALOS|X_DefinePolicies ()
        @doc "Setting Up Policies for Inter-Module Communication"
        (BASIS.DefinePolicies)
        (ATS.DefinePolicies)
        (ATSI.DefinePolicies)
        (TFT.DefinePolicies)
        (ATSC.DefinePolicies)
        (ATSH.DefinePolicies)
        (ATSM.DefinePolicies)
        (VESTING.DefinePolicies)
        (LIQUID.DefinePolicies)
        (OUROBOROS.DefinePolicies)
        (BRANDING.DefinePolicies)
        ;;
        (TALOS|DALOS.DefinePolicies)
        (TALOS|DPTF.DefinePolicies)
        (TALOS|DPMF.DefinePolicies)
        (TALOS|ATS1.DefinePolicies)
        (TALOS|ATS2.DefinePolicies)
        (TALOS|VST.DefinePolicies)
        (TALOS|LIQUID.DefinePolicies)
        (TALOS|OUROBOROS.DefinePolicies)
        ;;
        (DEPLOYER.DefinePolicies)
    )
    (defun DALOS|X_Initialise (patron:string)
        @doc "Main administrative function that initialises the DALOS Virtual Blockchain"
        (require-capability (DEPLOYER-ADMIN))
        ;;STEP 0
        ;;Deploy the <Dalos> Smart DALOS Account
            (TALOS|DALOS.A_DeploySmartAccount DALOS|SC_NAME (keyset-ref-guard DALOS|SC_KEY) DALOS|SC_KDA-NAME patron DALOS|PBL)
        ;;Deploy the <Autostake> Smart DALOS Account
            (TALOS|DALOS.A_DeploySmartAccount ATS|SC_NAME (keyset-ref-guard ATS|SC_KEY) ATS|SC_KDA-NAME patron ATS|PBL)
            (ATS.ATS|SetGovernor patron)
        ;;Deploy the <Vesting> Smart DALOS Account
            (TALOS|DALOS.A_DeploySmartAccount VST|SC_NAME (keyset-ref-guard VST|SC_KEY) VST|SC_KDA-NAME patron VST|PBL)
            (VESTING.VST|SetGovernor patron)
        ;;Deploy the <Liquidizer> Smart DALOS Account
            (TALOS|DALOS.A_DeploySmartAccount LIQUID|SC_NAME (keyset-ref-guard LIQUID|SC_KEY) LIQUID|SC_KDA-NAME patron LIQUID|PBL)
            (LIQUID.LIQUID|SetGovernor patron)
        ;;Deploy the <Ouroboros> Smart DALOS Account
            (TALOS|DALOS.A_DeploySmartAccount OUROBOROS|SC_NAME (keyset-ref-guard OUROBOROS|SC_KEY) OUROBOROS|SC_KDA-NAME patron OUROBOROS|PBL)
            (OUROBOROS.OUROBOROS|SetGovernor patron)

        ;;STEP 1
        ;;Insert Blank Info in the DALOS|PropertiesTable (so that it can be updated afterwards)
            (insert DALOS.DALOS|PropertiesTable DALOS.DALOS|INFO
                {"demiurgoi"                : 
                    [
                        DEMIURGOI|CTO_NAME
                        DEMIURGOI|HOV_NAME
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
        ;;Set Virtual Blockchain KDA Prices
            (DALOS.DALOS|A_UpdateUsagePrice "standard"      10.0)
            (DALOS.DALOS|A_UpdateUsagePrice "smart"         20.0)
            (DALOS.DALOS|A_UpdateUsagePrice "dptf"         200.0)
            (DALOS.DALOS|A_UpdateUsagePrice "dpmf"         300.0)
            (DALOS.DALOS|A_UpdateUsagePrice "dpsf"         400.0)
            (DALOS.DALOS|A_UpdateUsagePrice "dpnf"         500.0)
            (DALOS.DALOS|A_UpdateUsagePrice "blue"          25.0)
        ;;Set Information in the DALOS|GasManagementTable
            (insert DALOS.DALOS|GasManagementTable DALOS.DALOS|VGD
                {"virtual-gas-tank"         : DALOS.DALOS|SC_NAME
                ,"virtual-gas-toggle"       : false
                ,"virtual-gas-spent"        : 0.0
                ,"native-gas-toggle"        : false
                ,"native-gas-spent"         : 0.0}
            )

        ;;STEP 2
        (let*
            (
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
    ;;========[P] PRINT-FUNCTIONS==============================================;;
    (defun DALOS|UP_AccountProperties (account:string)
        (let* 
            (
                (p:[bool] (DALOS.DALOS|UR_AccountProperties account))
                (a:bool (at 0 p))
                (b:bool (at 1 p))
                (c:bool (at 2 p))
            )
            (if (= a true)
                (format "Account {} is a Smart Account: Payable: {}; Payable by Smart Account: {}." [account b c])
                (format "Account {} is a Normal Account" [account])
            )
        )
    )
    (defun ATS|UP_P0 (atspair:string account:string)
        (format "{}|{} P0: {}" [atspair account (ATS.ATS|UR_P0 atspair account)])
    )
    (defun ATS|UP_P1 (atspair:string account:string)
        (format "{}|{} P1: {}" [atspair account (ATS.ATS|UR_P1-7 atspair account 1)])
    )
    (defun ATS|UP_P2 (atspair:string account:string)
        (format "{}|{} P2: {}" [atspair account (ATS.ATS|UR_P1-7 atspair account 2)])
    )
    (defun ATS|UP_P3 (atspair:string account:string)
        (format "{}|{} P3: {}" [atspair account (ATS.ATS|UR_P1-7 atspair account 3)])
    )
    (defun ATS|UP_P4 (atspair:string account:string)
        (format "{}|{} P4: {}" [atspair account (ATS.ATS|UR_P1-7 atspair account 4)])
    )
    (defun ATS|UP_P5 (atspair:string account:string)
        (format "{}|{} P5: {}" [atspair account (ATS.ATS|UR_P1-7 atspair account 5)])
    )
    (defun ATS|UP_P6 (atspair:string account:string)
        (format "{}|{} P6: {}" [atspair account (ATS.ATS|UR_P1-7 atspair account 6)])
    )
    (defun ATS|UP_P7 (atspair:string account:string)
        (format "{}|{} P7: {}" [atspair account (ATS.ATS|UR_P1-7 atspair account 7)])
    )
)