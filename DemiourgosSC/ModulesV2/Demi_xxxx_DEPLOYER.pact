;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
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
    (defconst DEMIURGOI|AH_KDA-NAME "k:6fa1d9c3e5078a54038159c9a6bd7182301e16d6f280615eddb18b8bd2d6c263")   ;;change to what is needed.
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
    ;;
    ;;            FUNCTIONS
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;            Administrative Usage Functions        [A]
    (defun A_Step005a ()
        (DALOS.DALOS|A_DeployStandardAccount
            DEMIURGOI|AH_NAME
            (keyset-ref-guard DEMIURGOI|AH_KEY)
            DEMIURGOI|AH_KDA-NAME
            DEMIURGOI|AH_PBL
        )
        (DALOS.DALOS|A_DeployStandardAccount
            DEMIURGOI|CTO_NAME
            (keyset-ref-guard DEMIURGOI|CTO_KEY)
            DEMIURGOI|CTO_KDA-NAME
            DEMIURGOI|CTO_PBL
        )
        (DALOS.DALOS|A_DeployStandardAccount
            DEMIURGOI|HOV_NAME
            (keyset-ref-guard DEMIURGOI|HOV_KEY)
            DEMIURGOI|HOV_KDA-NAME
            DEMIURGOI|HOV_PBL
        )
    )
    (defun A_Step005b ()
        (let
            (
                (acc1:string "Ѻ.ÅτhGźνΣhςвiàÁĘĚДÏWÉΨTěCÃŒnæi9цéŘQí¢лΞÛIчмfÓeżÜýЯàDÖ5αȚÞVđσγ₱0ęЬÔĄsĄLлKùvåH£ΞMFУûÊyđÜqdŽŚЖsĘъsПÂÔØŹÞŮγŚΣЧ6Ïж¢чPyòлБ14ÚęŃĄåîêтηΛbΦđkûÇĂζsБúĎdŸUЛзÙÂÚJηXťćж¥zщòÁŸRĘ")
                (key1:string "free.us-0000_aozt-keyset")
                (kda1:string "k:95a59029029524ebb250b2fafe6826ff88bb59c527d661cba3279d09a51d3bdf")
                (pbl1:string "9G.29k17uqiwBF7mbc3rzr5gz228lxepz7a0fwrja2Bgzk1czjCLja3wg9q1ey10ftFhxIAiFBHCtvotkmKIIxFisMni8EA6esncL3lg2uLLH2u89Er9sgbeGmK0k7b63xujf1nAIf5GB583fcE6pzFak2CwhEi1dHzI0F14tvtxv4H8r1ABk5weoJ7HfCoadMm1h8MjIwjzbDKo80H25AJL8I1JiFF66Iwjcj3sFrD9xaqz1ziEEBJICF2k81pG9ABpDk2rK4ooglCK3kmC0h7yvvakjIvMpGp00jnw2Cpg1HoxjK0HoqzuKciIIczGsEzCjoB43x7lKsxkzAm7op2urv0I85Kon7uIBmg328cuKMc8driw8boAFnrdqHEFhx4sFjm8DM44FutCykKGx7GGLnoeJLaC707lot9tM51krmp6KDG8Ii318fIc1L5iuzqEwDnkro35JthzlDD1GkJaGgze3kDApAckn3uMcBypdz4LxbDGrg5K2GdiFBdFHqdpHyssrH8t694BkBtM9EB3yI3ojbnrbKrEM8fMaHAH2zl4x5gdkHnpjAeo8nz")
                
                (acc2:string "Ѻ.A0ěьπΨтÎșπЦĐđŽ6ЫêÀεÅĐȘдÞЩ4Ł2ďй5žömiτsλÚÇдěÒaV₱ÏûιЩД₳îJÍşыyÜŹżęìvAЙsÄ¢ÿnΦIťQůЮ7ĄвaèďíoáнõÎLJθÆEáПiXÿÒÀĘ14цU1çΞêSťüIψчèι₱ê9ŽчΓüЦrÀÓμĆ99κQťqPÖшŮ1ÈČSĐŁÌбÝàŞbPσŃĎ8ĄW")
                (key2:string "free.us-0001_emma-keyset")
                (kda2:string "k:ecaeae048b6e4b1d4cd9b5ba41041b39e05ac3a7b32f495a12823cb1c5ad0f48")
                (pbl2:string "9G.39tf0E26stf4Dxiows9kidajrJGCjDighDd4jltItj9js3n8dFiiin5yphml1u0uAltxumFngoogIv8jypw4LlehiEbmuzxtwkdajn7j3M0s3s7g6aALwbbGt6uGjeuFw1ovxf769AzklLxke2MKfobAbDyIH2a6zwKC79eypy1tfdF2plELbfMq9KxtF1GvIri0y4c4Ll3rK0FqICktqmJEakeC4GadmsAatJzIa8vHj82uC0A3KrtkhLsz9cGmsC0Lmzi6GFvv0Cola8g1A4k2neFEAoCsHyepILCgCz6ftlLmsjwgBMfLLL0n3Iwa4lzsn0w2qHwqmvckCtEIeHfwd5m9MKg8AA51uaBDm76j9GnMpecaabqELMm2Fc1h4DhgmzJIIndmwj0vxKmqjnxfg891HKezsCJxIDmMvxC7JbGGbaLip7JaJ6kuuBmreFm3GyLIz1KKlIeBG6Ck8ftgpaGum2BrEFF45jom87uhba7lzfpq6ihG8H4MCAGyyrz9q3ben4yLv4Keqq9tt1q0F5AdC4s4Eox0ebLwLiCtgkrfp5qCohHBH8E8")
        
                (acc3:string "Ѻ.œâσzüştŒhłσćØTöõúoвþçЧлρËШđюλ2ÙPeжŘťȚŤtθËûrólþŘß₿øuŁdáNÎČȘřΦĘbχλΩĄ¢ц2ŹθõĐLcÑÁäăå₿ξЭжулxòΘηĂœŞÝUËcω∇ß$ωoñД7θÁяЯéEU¢CЮxÃэJĘčÎΠ£αöŮЖбlćшbăÙЦÎAдŃЭб$ĞцFδŃËúHãjÁÝàĘSt")
                (key3:string "free.us-0002_lumy-keyset")
                (kda3:string "k:163320715f95957d1a15ea664fa6bd46f4c59dbb804f793ae93662a4c90b3189")
                (pbl3:string "9G.1CAv9Fq0mmrgALMafmEv46lkzHj7yib75pCbDdtojimK8KHiBMqcMMj4002t612H5HaKD6yBDo556n2Jsc7CvxFlo0knLpoLMs331kCgur71s7tHbc20iAx5IvCdaektlscciwLAH8bKIprgBmJubk12xKGfw2FbdjH8Hgygs5g2LJKsf11sh6croly7w8G6E2LLHsf1D5HImE3K7Jd5wMkjcCHsu2khw6wpmxotBf1l1jMxedypoyGh5GHzy15hKafx4cL97ttq8jEvnioLshycFct228L6xsIIadmcodbyyyDhA2H7yqe2C5rwAvqirFHy5d40Mo2mFyJhG4D3HvwphdCuGCkM9yv3vdDFo4HHGDAllz2Ig6B1y8lf9Dmg9kk3fIFI5m7f8p01Hejq30JsA4av0cruGEIIB94AbyJvec09u2DA9gi7t4qDurc8pxw8qgs8v4IFoB2k1vwint9z2JAc82kw5t4frwip3Isx7zk3za2qdi5M6ifiFokdzidA0A0u3eho6goh5x8nn3llBDz6E9uDKedyApF1nzDkJefAIbigke32psym")
        
                
            )
            (DALOS.DALOS|A_DeployStandardAccount acc1 (keyset-ref-guard key1) kda1 pbl1)
            (DALOS.DALOS|A_DeployStandardAccount acc2 (keyset-ref-guard key2) kda2 pbl2)
            (DALOS.DALOS|A_DeployStandardAccount acc3 (keyset-ref-guard key2) kda3 pbl3)
        )
    )
    (defun A_Step006 ()
        (BASIS.DefinePolicies)
        (ATS.DefinePolicies)

        (ATSI.DefinePolicies)
        (TFT.DefinePolicies)

        (ATSC.DefinePolicies)
        (ATSH.DefinePolicies)

        (ATSM.DefinePolicies)
        (VESTING.DefinePolicies)

        (BRANDING.DefinePolicies)
        (TALOS-01.DefinePolicies)
        (TALOS-02.DefinePolicies)
    )
    (defun A_Step007 ()
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
    )
    (defun A_Step008 ()
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
        (insert DALOS.DALOS|GasManagementTable DALOS.DALOS|VGD
            {"virtual-gas-tank"         : DALOS.DALOS|SC_NAME
            ,"virtual-gas-toggle"       : false
            ,"virtual-gas-spent"        : 0.0
            ,"native-gas-toggle"        : false
            ,"native-gas-spent"         : 0.0}
        )
    )
    (defun A_Step009 ()
        (let
            (
                (patron:string DEMIURGOI|AH_NAME)
            )
            (DALOS.DALOS|A_DeploySmartAccount DALOS|SC_NAME (keyset-ref-guard DALOS|SC_KEY) DALOS|SC_KDA-NAME patron DALOS|PBL)
            ;; 
            (DALOS.DALOS|A_DeploySmartAccount ATS|SC_NAME (keyset-ref-guard ATS|SC_KEY) ATS|SC_KDA-NAME patron ATS|PBL)
            (ATS.ATS|SetGovernor patron)
            ;;
            (DALOS.DALOS|A_DeploySmartAccount VST|SC_NAME (keyset-ref-guard VST|SC_KEY) VST|SC_KDA-NAME patron VST|PBL)
            (VESTING.VST|SetGovernor patron)
            ;;    
            (DALOS.DALOS|A_DeploySmartAccount LIQUID|SC_NAME (keyset-ref-guard LIQUID|SC_KEY) LIQUID|SC_KDA-NAME patron LIQUID|PBL)
            (LIQUID.LIQUID|SetGovernor patron)
            ;;
            (DALOS.DALOS|A_DeploySmartAccount OUROBOROS|SC_NAME (keyset-ref-guard OUROBOROS|SC_KEY) OUROBOROS|SC_KDA-NAME patron OUROBOROS|PBL)
            (OUROBOROS.OUROBOROS|SetGovernor patron)
        )     
    )
    (defun A_Step010 ()
        (coin.create-account DALOS.DALOS|SC_KDA-NAME DALOS.DALOS|GUARD) 
        (coin.create-account OUROBOROS.OUROBOROS|SC_KDA-NAME OUROBOROS.OUROBOROS|GUARD) 
        (coin.create-account LIQUID.LIQUID|SC_KDA-NAME LIQUID.LIQUID|GUARD)
    )
    (defun A_Step011 ()
        (TALOS-01.DPTF|C_Issue
            DEMIURGOI|AH_NAME
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
    (defun A_Step012 ()
        (let
            (
                (patron:string DEMIURGOI|AH_NAME)
                (OuroID:string "OURO-98c486052a51")
                (AurynID:string "AURYN-98c486052a51")
                (EliteAurynID:string "ELITEAURYN-98c486052a51")
                (GasID:string "GAS-98c486052a51")
                (WrappedKadenaID:string "DWK-98c486052a51")
                (StakedKadenaID:string "DLK-98c486052a51")
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
    )
    (defun A_Step013 ()
        (let
            (
                (patron:string DEMIURGOI|AH_NAME)
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
    )
    (defun A_Step014 ()
        (let
            (
                (patron:string DEMIURGOI|AH_NAME)
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
    )
    (defun A_Step015 ()
        (let
            (
                (patron:string DEMIURGOI|AH_NAME)
                (WrappedKadenaID:string (DALOS.DALOS|UR_WrappedKadenaID))
                (StakedKadenaID:string (DALOS.DALOS|UR_LiquidKadenaID))
            )
            (BASIS.DPTF|C_SetFee patron StakedKadenaID -1.0)
            (BASIS.DPTF|C_ToggleFee patron StakedKadenaID true)
            (TALOS-01.DPTF|C_ToggleFeeLock patron StakedKadenaID true)
            (ATSI.DPTF-DPMF|C_ToggleBurnRole patron WrappedKadenaID LIQUID.LIQUID|SC_NAME true true)
            (ATSI.DPTF|C_ToggleMintRole patron WrappedKadenaID LIQUID.LIQUID|SC_NAME true)
        )
    )
    (defun A_Step016 ()
        (let*
            (
                (patron:string DEMIURGOI|AH_NAME)
                (OuroID:string (DALOS.DALOS|UR_OuroborosID))
                (AurynID:string (DALOS.DALOS|UR_AurynID))
                (EliteAurynID:string (DALOS.DALOS|UR_EliteAurynID))
        
                (VestedOuroID:string (TALOS-01.VST|C_CreateVestingLink patron OuroID))
                (VestedAurynID:string (TALOS-01.VST|C_CreateVestingLink patron AurynID))
                (VestedEliteAurynID:string (TALOS-01.VST|C_CreateVestingLink patron EliteAurynID))
            )
            [VestedOuroID VestedAurynID VestedEliteAurynID]
        )
    )
    (defun A_Step017 ()
        (let*
            (
                (patron:string DEMIURGOI|AH_NAME)
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
    )
    (defun A_Step018 ()
        (let
            (
                (patron:string DEMIURGOI|AH_NAME)
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
    )
    (defun A_Step019 ()
        (let
            (
                (patron:string DEMIURGOI|AH_NAME)
            )
            (LIQUID.LIQUID|C_WrapKadena patron patron 1.0)
        )
    )
    (defun A_Step020 ()
        (let
            (
                (patron:string DEMIURGOI|AH_NAME)
            )
            (ATSM.ATSM|C_Coil
                patron
                patron
                (at 0 (BASIS.DPTF|UR_RewardBearingToken (DALOS.DALOS|UR_LiquidKadenaID)))
                (DALOS.DALOS|UR_WrappedKadenaID)
                1.0
            )
        )
    )
    (defun A_Step021 ()
        (let
            (
                (patron:string DEMIURGOI|AH_NAME)
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
    )
    (defun A_Step022 ()
        (let
            (
                (patron:string DEMIURGOI|AH_NAME)
                (atspair:string  (at 0 (BASIS.DPTF|UR_RewardBearingToken (DALOS.DALOS|UR_AurynID))))
                (rt-amounts:[decimal] [372911.1318])
                (rbt-request-amount:decimal 144412.0)
            )
            (ATSM.ATSM|C_KickStart patron patron atspair rt-amounts rbt-request-amount)
        )
    )
    (defun A_Step023 ()
        (let*
            (
                (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
                (atspair:string  (at 0 (BASIS.DPTF|UR_RewardBearingToken (DALOS.DALOS|UR_EliteAurynID))))
                (rt-amounts:[decimal] [102929.0])
                (rbt-request-amount:decimal (at 0 rt-amounts))
            )
            (ATSM.ATSM|C_KickStart patron patron atspair rt-amounts rbt-request-amount)
        )
    )
    (defun A_Step024 ()
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
    )
    (defun A_Step025a ()
        (DALOS.IGNIS|A_Toggle false true)
    )
    (defun A_Step025b ()
        (DALOS.IGNIS|A_Toggle true true)
    )
    (defun A_Step026 ()
        (let
            (
                (patron:string DEPLOYER.DEMIURGOI|AH_NAME)
                (emma:string "Ѻ.A0ěьπΨтÎșπЦĐđŽ6ЫêÀεÅĐȘдÞЩ4Ł2ďй5žömiτsλÚÇдěÒaV₱ÏûιЩД₳îJÍşыyÜŹżęìvAЙsÄ¢ÿnΦIťQůЮ7ĄвaèďíoáнõÎLJθÆEáПiXÿÒÀĘ14цU1çΞêSťüIψчèι₱ê9ŽчΓüЦrÀÓμĆ99κQťqPÖшŮ1ÈČSĐŁÌбÝàŞbPσŃĎ8ĄW")
                (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
        
            )
            (TFT.DPTF|C_Transfer patron ouro-id patron emma 2.0 false)
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