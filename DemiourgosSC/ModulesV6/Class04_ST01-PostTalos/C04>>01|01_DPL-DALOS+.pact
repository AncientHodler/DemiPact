(interface DeployerDalos
    @doc "Exposes DALOS Deployer Functions"
    ;;
    (defun A_Step005 ())
    (defun A_Step006 ())
    (defun A_Step007 ())
    (defun A_Step008:list ())
    (defun A_Step009 ())
    (defun A_Step010:list ())
    (defun A_Step011 ())
    (defun A_Step012 ())
    (defun A_Step013 ())
    (defun A_Step014 ())
    (defun A_Step015 ())
    (defun A_Step016 ())
    (defun A_Step017 ())
    (defun A_Step018 ())
    (defun A_Step019 ())
    (defun A_Step020:list ())
    (defun A_Step021 ())
    (defun A_Step022 ())
)
(module DPL-DALOS GOV
    ;;
    (implements DeployerDalos)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPL-DALOS              (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    ;;  [KDA Accounts]
    (defconst DALOS|SC_KDA-NAME             (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|DALOS|SC_KDA-NAME)))
    (defconst ATS|SC_KDA-NAME               "k:89faf537ec7282d55488de28c454448a20659607adc52f875da30a4fd4ed2d12")
    (defconst VST|SC_KDA-NAME               "k:4728327e1b4790cb5eb4c3b3c531ba1aed00e86cd9f6252bfb78f71c44822d6d")
    (defconst LQD|SC_KDA-NAME               (let ((ref-LIQUID:module{KadenaLiquidStakingV4} LIQUID)) (ref-LIQUID::GOV|LIQUID|SC_KDA-NAME)))
    (defconst OUROBOROS|SC_KDA-NAME         (let ((ref-ORBR:module{OuroborosV4} OUROBOROS)) (ref-ORBR::GOV|ORBR|SC_KDA-NAME)))
    (defconst SWP|SC_KDA-NAME               "k:89faf537ec7282d55488de28c454448a20659607adc52f875da30a4fd4ed2d12")
    (defconst DHV|SC_KDA-NAME               "k:1ca97db36aa87fd6fd7be81a263811469bf8b79d6b21ef3a215653bdcf7af55a")
    ;;
    (defconst DEMIURGOI|AH_KDA-NAME         "k:6fa1d9c3e5078a54038159c9a6bd7182301e16d6f280615eddb18b8bd2d6c263")
    (defconst DEMIURGOI|CTO_KDA-NAME        "k:50d6c59b21e5e6e55baecaa75a1007de37576bde12d8230dc82459cc01b9484b")
    (defconst DEMIURGOI|HOV_KDA-NAME        "k:0cb30c0121ff919266121a99ff9359871818932211df94dae4137c29bc0e8f7e")
    (defconst PLEB|AOZT_KDA-NAME            "k:95a59029029524ebb250b2fafe6826ff88bb59c527d661cba3279d09a51d3bdf")
    (defconst PLEB|EMMA_KDA-NAME            "k:ecaeae048b6e4b1d4cd9b5ba41041b39e05ac3a7b32f495a12823cb1c5ad0f48")
    (defconst PLEB|LUMY_KDA-NAME            "k:163320715f95957d1a15ea664fa6bd46f4c59dbb804f793ae93662a4c90b3189")
    ;;
    ;;  [Autonomic Guards]
    (defconst DALOS|GUARD                   (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|DALOS|GUARD)))
    (defconst OUROBOROS|GUARD               (let ((ref-ORBR:module{OuroborosV4} OUROBOROS)) (ref-ORBR::GOV|ORBR|GUARD)))
    (defconst LQD|GUARD                     (let ((ref-LIQUID:module{KadenaLiquidStakingV4} LIQUID)) (ref-LIQUID::GOV|LIQUID|GUARD)))
    ;;
    ;;  [DALOS]
    (defconst DALOS|SC_KEY                  (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|DalosKey)))
    (defconst DALOS|SC_NAME                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|DALOS|SC_NAME)))
    (defconst DALOS|PBL                     (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|DALOS|PBL)))
    ;;  [AUTOSTAKE]
    (defconst ATS|SC_KEY                    (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|AutostakeKey)))
    (defconst ATS|SC_NAME                   (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|ATS|SC_NAME)))
    (defconst ATS|PBL                       (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|ATS|PBL)))
    ;;  [VESTING]
    (defconst VST|SC_KEY                    (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|VestingKey)))
    (defconst VST|SC_NAME                   (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|VST|SC_NAME)))
    (defconst VST|PBL                       (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|VST|PBL)))
    ;;  LIQUID-STAKING
    (defconst LQD|SC_KEY                    (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|LiquidKey)))
    (defconst LQD|SC_NAME                   (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|LIQUID|SC_NAME)))
    (defconst LQD|PBL                       (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|LIQUID|PBL)))
    ;;  [OUROBOROS]
    (defconst OUROBOROS|SC_KEY              (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|OuroborosKey)))
    (defconst OUROBOROS|SC_NAME             (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|OUROBOROS|SC_NAME)))
    (defconst OUROBOROS|PBL                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|OUROBOROS|PBL)))
    ;;  [SWAPPER]
    (defconst SWP|SC_KEY                    (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|SwapKey)))
    (defconst SWP|SC_NAME                   (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|SWP|SC_NAME)))
    (defconst SWP|PBL                       (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|SWP|PBL)))
    ;;  [DHVault]
    (defconst DHV|SC_KEY                    (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|DHVKey)))
    (defconst DHV1|SC_NAME                  (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|DHV1|SC_NAME)))
    (defconst DHV2|SC_NAME                  (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|DHV2|SC_NAME)))
    (defconst DHV|PBL                       (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|DHV|PBL)))
    ;;
    ;;  [Demiurgoi]
    (defconst DEMIURGOI|AH_KEY              (+ (GOV|NS_Use) ".dh_ah-keyset"))
    (defconst DEMIURGOI|AH_NAME             "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
    (defconst DEMIURGOI|AH_PBL              "9G.CgcAjiI89ICnk45mxx63hwkBe5G71sIqfEta0ugkzF7EB6cy55BtzlFa27jDGE7Kn7ChljCmkcIsrDw9JwzJECieGLB5Jlkz9Blo6iJct6uxIA1u64Hr7HKa93EAiCwJJBBKAojJtwupEsvspH1jjGxKyFsb8fbfnJm1rAKxcIzcFILmmdHFaICfFpnbJG6tJu0HM9JCJ7MBCE7C2LiqvE6Fc1hqCeAdGHxDp7sGquI0wl2l08aa6wlKvwu44jgqF8mqDnCyjpxHuttEqjs4h9IJ28kmB53ppwoznt16rjzeMl21n3rwfI2es56rp5xavCabDacyCuonniz72L5d7dq3ptIEiuggEyLIIGe9sadH6eaMyitcmKaH7orgFz6d9kL9FKorBr06owFg328wFhCIlCFpwIzokmo47xKKt5kBzhyodBAjhCqayuHBue4oDhoA21A2H9ut9gApMuxokcmsi7Bd1kitrfJAy1GkrGiBK5dvlhgshcnGaG3vhkCm6dI5idCGjDEodivvDbgyI6zaajHvIMdBtrGvuKnxvsBulkbaDbk2wIdKwrK")
    ;;
    (defconst DEMIURGOI|CTO_KEY             (+ (GOV|NS_Use) ".dh_cto-keyset"))
    (defconst DEMIURGOI|CTO_NAME            "Ѻ.CЭΞŸNGúůρhãmИΘÛ¢₳šШдìAÚwŚGýηЗПAÊУÔȘřŽÍζЗηmΔφDmcдΛъ₳tĂýăŮsПÞ$öœGθeBŽvąαÃfçл¢ĎĆď$şbsЦэΘNÄëÍĂνуãöž¥àZjÆůšÁœôñχŽâЩåτâн4μфAOçĎΓuЗŮnøЙãĚè6Дżîþż$цÑûρψŻïZÉλûæřΨeèÎígςeL")
    (defconst DEMIURGOI|CTO_PBL             "9G.7si93iImtrM53Jl9C7pIojCAmq04gHyk8d1lle6x07Hfh57idcrqEznFM7ousiC14d16dlIbwAE2K7MBK79ApIMgb405svepvaz7azIIHGLulbIqBefscnsmydqD1pCHAKlH3xu6tJk6ejJk5fMlvtrvu2gc0lnz7knipdqvE6huvywrFt925E9Ci5bkspirF8GDA03Iorf5zdg1ad6tFG9uMBHL2aqsu0JcoicuoHcCnLHE6dBoignL7DiJrFGxgimrmrF5cLoqDjrjhb3GwFD4wfnMDbIqmq3MMrBJm96Ggve7worr5z5oLh5bhhrjHzf0fLH77ho1zv04kEM8odz6254H4JewC4sw9cxA1Aa9vaggj5owFK332Fff41lCi75otEhdzoheln2Czli46tcKv35o1ftkHLgrjAtMoIFDKuFjzv4d3kbqJ4Crzgtn63o95FMqFF91MbLGMLEBjis3sjJiGB0yLJzdBetdECclzxFo5cAve8o08Hifng4kEgExDzqFhKGdK9lCmyu4E9vo6k3jHjhH96KlvGDCjwMFcpkqyMB2gtlurlst")
    ;;
    (defconst DEMIURGOI|HOV_KEY             (+ (GOV|NS_Use) ".dh_hov-keyset"))
    (defconst DEMIURGOI|HOV_NAME            "Ѻ.ÍăüÙÜЦżΦF₿ÈшÕóñĐĞGюѺλωÇțnθòoйEςк₱0дş3ôPpxŞțqgЖ€šωbэočΞìČ5òżŁdŒИöùЪøŤяжλзÜ2ßżpĄγïčѺöэěτČэεSčDõžЩУЧÀ₳ŚàЪЙĎpЗΣ2ÃлτíČнÙyéÕãďWŹŘĘźσПåbã€éѺι€ΓφŠ₱ŽyWcy5ŘòmČ₿nβÁ¢¥NЙëOι")
    (defconst DEMIURGOI|HOV_PBL             "9H.268Bnvp307DmbIcEltbEkpeHuK3C3qsD615ml5qefsA4HErwbqDhy6K1IvqxMeoCBh9mfieMj72jbzzI6a6nDtGhmf2nbHyE6M3zceog4o3bEkqcyvLsBdsGLt7Fu6Ei0Da6iej0n2z5M3bFsAk6iitosvzemff0B18kpeh5ocj5zb7DebFiLgAhIElsgg05Lh5CpyF5LqyKtlFvAay6wtCzsi2cM19BMB29nrfcIgKkaIkh2sjtAE5giM6th727eDekACBvMexk74wxgD2pJegzjuCqIe3BwozG5Fa29DqpcKM5zL1x78h7JKMj1ek2aanqnCtG33Dr3w2mzcIcLjlsDtMD1CG02CFlrCCAzMmlLmFgsBiIpt3Blj1uaxJG67xB2jwKj45s4LIDhzLea24m1AzFh6FD4MsF4Ay35i2Cvbmzdff6nuJbKM5tw5C31xapoqwEIeKkCC9zsiIk8GCMhis557p7Hk9H3aM059D24ar7KLmlr8cydi9n4u2rwH02rb8l1ixDbgoqn2jlCHDBxbCnf3A4GyI4FpaqJuBf1IwdI85Bq6qzcJIiK")
    ;;  [Plebs]
    (defconst PLEB|AOZT_KEY                 (+ (GOV|NS_Use) ".us-0000_aozt-keyset"))
    (defconst PLEB|AOZT_NAME                "Ѻ.ÅτhGźνΣhςвiàÁĘĚДÏWÉΨTěCÃŒnæi9цéŘQí¢лΞÛIчмfÓeżÜýЯàDÖ5αȚÞVđσγ₱0ęЬÔĄsĄLлKùvåH£ΞMFУûÊyđÜqdŽŚЖsĘъsПÂÔØŹÞŮγŚΣЧ6Ïж¢чPyòлБ14ÚęŃĄåîêтηΛbΦđkûÇĂζsБúĎdŸUЛзÙÂÚJηXťćж¥zщòÁŸRĘ")
    (defconst PLEB|AOZT_PBL                 "9G.29k17uqiwBF7mbc3rzr5gz228lxepz7a0fwrja2Bgzk1czjCLja3wg9q1ey10ftFhxIAiFBHCtvotkmKIIxFisMni8EA6esncL3lg2uLLH2u89Er9sgbeGmK0k7b63xujf1nAIf5GB583fcE6pzFak2CwhEi1dHzI0F14tvtxv4H8r1ABk5weoJ7HfCoadMm1h8MjIwjzbDKo80H25AJL8I1JiFF66Iwjcj3sFrD9xaqz1ziEEBJICF2k81pG9ABpDk2rK4ooglCK3kmC0h7yvvakjIvMpGp00jnw2Cpg1HoxjK0HoqzuKciIIczGsEzCjoB43x7lKsxkzAm7op2urv0I85Kon7uIBmg328cuKMc8driw8boAFnrdqHEFhx4sFjm8DM44FutCykKGx7GGLnoeJLaC707lot9tM51krmp6KDG8Ii318fIc1L5iuzqEwDnkro35JthzlDD1GkJaGgze3kDApAckn3uMcBypdz4LxbDGrg5K2GdiFBdFHqdpHyssrH8t694BkBtM9EB3yI3ojbnrbKrEM8fMaHAH2zl4x5gdkHnpjAeo8nz")
    ;;
    (defconst PLEB|EMMA_KEY                 (+ (GOV|NS_Use) ".us-0001_emma-keyset"))
    (defconst PLEB|EMMA_NAME                "Ѻ.A0ěьπΨтÎșπЦĐđŽ6ЫêÀεÅĐȘдÞЩ4Ł2ďй5žömiτsλÚÇдěÒaV₱ÏûιЩД₳îJÍşыyÜŹżęìvAЙsÄ¢ÿnΦIťQůЮ7ĄвaèďíoáнõÎLJθÆEáПiXÿÒÀĘ14цU1çΞêSťüIψчèι₱ê9ŽчΓüЦrÀÓμĆ99κQťqPÖшŮ1ÈČSĐŁÌбÝàŞbPσŃĎ8ĄW")
    (defconst PLEB|EMMA_PBL                 "9G.39tf0E26stf4Dxiows9kidajrJGCjDighDd4jltItj9js3n8dFiiin5yphml1u0uAltxumFngoogIv8jypw4LlehiEbmuzxtwkdajn7j3M0s3s7g6aALwbbGt6uGjeuFw1ovxf769AzklLxke2MKfobAbDyIH2a6zwKC79eypy1tfdF2plELbfMq9KxtF1GvIri0y4c4Ll3rK0FqICktqmJEakeC4GadmsAatJzIa8vHj82uC0A3KrtkhLsz9cGmsC0Lmzi6GFvv0Cola8g1A4k2neFEAoCsHyepILCgCz6ftlLmsjwgBMfLLL0n3Iwa4lzsn0w2qHwqmvckCtEIeHfwd5m9MKg8AA51uaBDm76j9GnMpecaabqELMm2Fc1h4DhgmzJIIndmwj0vxKmqjnxfg891HKezsCJxIDmMvxC7JbGGbaLip7JaJ6kuuBmreFm3GyLIz1KKlIeBG6Ck8ftgpaGum2BrEFF45jom87uhba7lzfpq6ihG8H4MCAGyyrz9q3ben4yLv4Keqq9tt1q0F5AdC4s4Eox0ebLwLiCtgkrfp5qCohHBH8E8")
    ;;
    (defconst PLEB|LUMY_KEY                 (+ (GOV|NS_Use) ".us-0002_lumy-keyset"))
    (defconst PLEB|LUMY_NAME                "Ѻ.œâσzüştŒhłσćØTöõúoвþçЧлρËШđюλ2ÙPeжŘťȚŤtθËûrólþŘß₿øuŁdáNÎČȘřΦĘbχλΩĄ¢ц2ŹθõĐLcÑÁäăå₿ξЭжулxòΘηĂœŞÝUËcω∇ß$ωoñД7θÁяЯéEU¢CЮxÃэJĘčÎΠ£αöŮЖбlćшbăÙЦÎAдŃЭб$ĞцFδŃËúHãjÁÝàĘSt")
    (defconst PLEB|LUMY_PBL                 "9G.1CAv9Fq0mmrgALMafmEv46lkzHj7yib75pCbDdtojimK8KHiBMqcMMj4002t612H5HaKD6yBDo556n2Jsc7CvxFlo0knLpoLMs331kCgur71s7tHbc20iAx5IvCdaektlscciwLAH8bKIprgBmJubk12xKGfw2FbdjH8Hgygs5g2LJKsf11sh6croly7w8G6E2LLHsf1D5HImE3K7Jd5wMkjcCHsu2khw6wpmxotBf1l1jMxedypoyGh5GHzy15hKafx4cL97ttq8jEvnioLshycFct228L6xsIIadmcodbyyyDhA2H7yqe2C5rwAvqirFHy5d40Mo2mFyJhG4D3HvwphdCuGCkM9yv3vdDFo4HHGDAllz2Ig6B1y8lf9Dmg9kk3fIFI5m7f8p01Hejq30JsA4av0cruGEIIB94AbyJvec09u2DA9gi7t4qDurc8pxw8qgs8v4IFoB2k1vwint9z2JAc82kw5t4frwip3Isx7zk3za2qdi5M6ifiFokdzidA0A0u3eho6goh5x8nn3llBDz6E9uDKedyApF1nzDkJefAIbigke32psym")
    ;;
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPL_DALOS_ADMIN)))
    (defcap GOV|DPL_DALOS_ADMIN ()          (enforce-guard GOV|MD_DPL-DALOS))
    ;;{G3}
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    ;;{P3}
    ;;{P4}
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                        (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                           (CT_Bar))
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    ;;{C2}
    ;;{C3}
    ;;{C4}
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;  [DEPLOY]
    (defun A_Step005 ()
        (let
            (
                (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
            )
            (ref-TS01-A::DALOS|A_DeployStandardAccount
                DEMIURGOI|AH_NAME
                (keyset-ref-guard DEMIURGOI|AH_KEY)
                DEMIURGOI|AH_KDA-NAME
                DEMIURGOI|AH_PBL
            )
            (ref-TS01-A::DALOS|A_DeployStandardAccount
                DEMIURGOI|CTO_NAME
                (keyset-ref-guard DEMIURGOI|CTO_KEY)
                DEMIURGOI|CTO_KDA-NAME
                DEMIURGOI|CTO_PBL
            )
            (ref-TS01-A::DALOS|A_DeployStandardAccount
                DEMIURGOI|HOV_NAME
                (keyset-ref-guard DEMIURGOI|HOV_KEY)
                DEMIURGOI|HOV_KDA-NAME
                DEMIURGOI|HOV_PBL
            )
            ;;PLEB Accounts
            (ref-TS01-A::DALOS|A_DeployStandardAccount
                PLEB|AOZT_NAME
                (keyset-ref-guard PLEB|AOZT_KEY)
                PLEB|AOZT_KDA-NAME
                PLEB|AOZT_PBL
            )
            (ref-TS01-A::DALOS|A_DeployStandardAccount
                PLEB|EMMA_NAME
                (keyset-ref-guard PLEB|EMMA_KEY)
                PLEB|EMMA_KDA-NAME
                PLEB|EMMA_PBL
            )
            (ref-TS01-A::DALOS|A_DeployStandardAccount
                PLEB|LUMY_NAME
                (keyset-ref-guard PLEB|LUMY_KEY)
                PLEB|LUMY_KDA-NAME
                PLEB|LUMY_PBL
            )
        )
    )
    (defun A_Step006 ()
        (acquire-module-admin free.DALOS)
        (let
            (
                ;(ref-P|IGNIS:module{OuronetPolicy} IGNIS)
                ;(ref-P|INFO-ZERO:module{OuronetPolicy} INFO-ZERO)

                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
                ;(ref-P|DPOF:module{OuronetPolicy} DPOF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|ATSU:module{OuronetPolicy} ATSU)
                (ref-P|VST:module{OuronetPolicy} VST)
                (ref-P|LIQUID:module{OuronetPolicy} LIQUID)
                (ref-P|ORBR:module{OuronetPolicy} OUROBOROS)
                ;;
                (ref-P|SWPT:module{OuronetPolicy} SWPT)
                (ref-P|SWP:module{OuronetPolicy} SWP)
                (ref-P|SWPI:module{OuronetPolicy} SWPI)
                (ref-P|SWPL:module{OuronetPolicy} SWPL)
                (ref-P|SWPLC:module{OuronetPolicy} SWPLC)
                (ref-P|SWPU:module{OuronetPolicy} SWPU)
                (ref-P|MTX-SWP:module{OuronetPolicy} MTX-SWP)
                ;;
                (ref-P|TS01-A:module{OuronetPolicy} TS01-A)
                (ref-P|TS01-C1:module{OuronetPolicy} TS01-C1)
                (ref-P|TS01-C2:module{OuronetPolicy} TS01-C2)
                (ref-P|TS01-CP:module{OuronetPolicy} TS01-CP)
                ;;
                (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (bar:string (ref-U|CT::CT_BAR))
                (info:string (ref-DALOS::DALOS|Info))
                (vgd:string (ref-DALOS::DALOS|VirtualGasData))
            )
            ;;(ref-P|IGNIS::P|A_Define)
            ;(ref-P|INFO-ZERO::P|A_Define)

            (ref-P|BRD::P|A_Define)
            (ref-P|DPTF::P|A_Define)
            (ref-P|DPMF::P|A_Define)
            ;(ref-P|DPOF::P|A_Define)
            (ref-P|ATS::P|A_Define)
            (ref-P|TFT::P|A_Define)
            (ref-P|ATSU::P|A_Define)
            (ref-P|VST::P|A_Define)
            (ref-P|LIQUID::P|A_Define)
            (ref-P|ORBR::P|A_Define)
            ;;
            (ref-P|SWPT::P|A_Define)
            (ref-P|SWP::P|A_Define)
            (ref-P|SWPI::P|A_Define)
            (ref-P|SWPL::P|A_Define)
            (ref-P|SWPLC::P|A_Define)
            (ref-P|SWPU::P|A_Define)
            (ref-P|MTX-SWP::P|A_Define)
            ;;
            (ref-P|TS01-A::P|A_Define)
            (ref-P|TS01-C1::P|A_Define)
            (ref-P|TS01-C2::P|A_Define)
            (ref-P|TS01-CP::P|A_Define)
            ;;
            ;;Kadena Prices
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "standard"      0.01)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "smart"         0.02)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "ats"            0.1)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "swp"           0.15)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "dptf"           0.2)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "dpmf"           0.3)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "dpsf"           0.4)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "dpnf"           0.5)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "blue"         0.025)

            ;;Ignis Prices
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "ignis|smallest"            1.0)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "ignis|small"               2.0)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "ignis|medium"              3.0)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "ignis|big"                 4.0)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "ignis|biggest"             5.0)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "ignis|branding"          100.0)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "ignis|token-issue"       500.0)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "ignis|ats-issue"        5000.0)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "ignis|swp-issue"        4000.0)
            (ref-TS01-A::DALOS|A_UpdateUsagePrice "ignis|swp-liquidity"      20.0)
            ;;
            (insert ref-DALOS::DALOS|PropertiesTable info
                {"global-administrative-pause"  : false
                ,"demiurgoi"                    :
                    [
                        DHV2|SC_NAME
                        DEMIURGOI|CTO_NAME
                        DEMIURGOI|HOV_NAME
                    ]
                ,"unity-id"                     : bar
                ,"gas-source-id"                : bar
                ,"gas-source-id-price"          : 0.0
                ,"gas-id"                       : bar
                ,"ats-gas-source-id"            : bar
                ,"elite-ats-gas-source-id"      : bar
                ,"wrapped-kda-id"               : bar
                ,"liquid-kda-id"                : bar
                ,"treasury-dispo-type"          : 3
                ,"treasury-dynamic-promille"    : 320.0
                ,"treasury-static-tds"          : 250.0
                ,"ouro-auto-price-via-swaps"    : false
            }
            )
            (insert ref-DALOS::DALOS|GasManagementTable vgd
                {"virtual-gas-tank"             : DALOS|SC_NAME
                ,"virtual-gas-toggle"           : false
                ,"virtual-gas-spent"            : 0.0
                ,"native-gas-toggle"            : false
                ,"native-gas-spent"             : 0.0
                ,"native-gas-pump"              : false}
            )
        )
    )
    (defun A_Step007 ()
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|VST:module{OuronetPolicy} VST)
                (ref-P|SWP:module{OuronetPolicy} SWP)
                ;;
                (ref-coin:module{fungible-v2} coin)
                ;;
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-ATS:module{AutostakeV4} ATS)
                (ref-VST:module{VestingV4} VST)
                (ref-LIQUID:module{KadenaLiquidStakingV4} LIQUID)
                (ref-ORBR:module{OuroborosV4} OUROBOROS)
                (ref-SWP:module{SwapperV4} SWP)
                (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                (patron:string DEMIURGOI|AH_NAME)
            )
            ;;
            ;;Genesis Account Deploying
            (ref-TS01-A::DALOS|A_DeploySmartAccount DALOS|SC_NAME (keyset-ref-guard DALOS|SC_KEY) DALOS|SC_KDA-NAME patron DALOS|PBL)
            (ref-TS01-A::DALOS|A_DeploySmartAccount ATS|SC_NAME (keyset-ref-guard ATS|SC_KEY) ATS|SC_KDA-NAME patron ATS|PBL)
            (ref-TS01-A::DALOS|A_DeploySmartAccount VST|SC_NAME (keyset-ref-guard VST|SC_KEY) VST|SC_KDA-NAME patron VST|PBL)
            (ref-TS01-A::DALOS|A_DeploySmartAccount LQD|SC_NAME (keyset-ref-guard LQD|SC_KEY) LQD|SC_KDA-NAME patron LQD|PBL)
            (ref-TS01-A::DALOS|A_DeploySmartAccount OUROBOROS|SC_NAME (keyset-ref-guard OUROBOROS|SC_KEY) OUROBOROS|SC_KDA-NAME patron OUROBOROS|PBL)
            (ref-TS01-A::DALOS|A_DeploySmartAccount SWP|SC_NAME (keyset-ref-guard SWP|SC_KEY) SWP|SC_KDA-NAME patron SWP|PBL)
            (ref-TS01-A::DALOS|A_DeployStandardAccount DHV1|SC_NAME (keyset-ref-guard DHV|SC_KEY) DHV|SC_KDA-NAME DHV|PBL)
            (ref-TS01-A::DALOS|A_DeploySmartAccount DHV2|SC_NAME (keyset-ref-guard DHV|SC_KEY) DHV|SC_KDA-NAME DHV1|SC_NAME DHV|PBL)
            ;;
            ;;Genesis Governer Setups
            ;;1]DALOS|SC_NAME
            (ref-DALOS::DALOS|SetGovernor patron)
            (ref-ATS::ATS|SetGovernor patron)
            (ref-VST::VST|SetGovernor patron)
            (ref-LIQUID::LIQUID|SetGovernor patron)
            (ref-ORBR::OUROBOROS|SetGovernor patron)
            (ref-SWP::SWP|SetGovernor patron)
            ;;
            ;;Deploy Kadena Accounts
            (ref-coin::create-account DALOS|SC_KDA-NAME DALOS|GUARD)
            (ref-coin::create-account OUROBOROS|SC_KDA-NAME OUROBOROS|GUARD)
            (ref-coin::create-account LQD|SC_KDA-NAME LQD|GUARD)
        )
    )
    (defun A_Step008:list ()
        (acquire-module-admin free.DALOS)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                (patron:string DEMIURGOI|AH_NAME)
                (info:string (ref-DALOS::DALOS|Info))
                (ids:list
                    (ref-TS01-C1::DPTF|C_Issue
                        DEMIURGOI|AH_NAME
                        DALOS|SC_NAME
                        ["Ouroboros" "Auryn" "EliteAuryn" "Ignis" "DalosWrappedKadena" "DalosLiquidKadena"]
                        ["OURO" "AURYN" "ELITEAURYN" "GAS" "DWK" "DLK"]
                        [24 24 24 24 24 24]
                        [true true true true true true]         ;;can change owner
                        [true true true true true true]         ;;can upgrade
                        [true true true true true true]         ;;can can-add-special-role
                        [true false true true false false]      ;;can-freeze
                        [true false true false false false]     ;;can-wipe
                        [true false false true false false]     ;;can pause
                    )
                )
                (OuroID:string (at 0 ids))
                (AurynID:string (at 1 ids))
                (EliteAurynID:string (at 2 ids))
                (GasID:string (at 3 ids))
                (WrappedKadenaID:string (at 4 ids))
                (StakedKadenaID:string (at 5 ids))
                ;;
                (treasury-sc:string DHV2|SC_NAME)
            )
            (update ref-DALOS::DALOS|PropertiesTable info
                { "gas-source-id"           : OuroID
                , "gas-id"                  : GasID
                , "ats-gas-source-id"       : AurynID
                , "elite-ats-gas-source-id" : EliteAurynID
                , "wrapped-kda-id"          : WrappedKadenaID
                , "liquid-kda-id"           : StakedKadenaID
                }
            )
            ;;
            ;;Set Token Roles Part I
            (ref-TS01-C1::DPTF|C_SetFee patron AurynID 50.0)
            (ref-TS01-C1::DPTF|C_SetFee patron EliteAurynID 100.0)
            (ref-TS01-C1::DPTF|C_ToggleFee patron AurynID true)
            (ref-TS01-C1::DPTF|C_ToggleFee patron EliteAurynID true)
            (ref-TS01-C1::DPTF|C_ToggleFeeLock patron AurynID true)
            (ref-TS01-C1::DPTF|C_ToggleFeeLock patron EliteAurynID true)
            ;;
            ;;Set Token Roles Part II
            (ref-TS01-C1::DPTF|C_SetMinMove patron GasID 1000.0)
            (ref-TS01-C1::DPTF|C_SetFee patron GasID -1.0)
            (ref-TS01-C1::DPTF|C_SetFeeTarget patron GasID DALOS|SC_NAME)
            (ref-TS01-C1::DPTF|C_ToggleFee patron GasID true)
            (ref-TS01-C1::DPTF|C_ToggleFeeLock patron GasID true)
            (ref-TS01-C1::DPTF|C_ToggleBurnRole patron GasID OUROBOROS|SC_NAME true)
            (ref-TS01-C1::DPTF|C_ToggleBurnRole patron OuroID OUROBOROS|SC_NAME true)
            (ref-TS01-C1::DPTF|C_ToggleMintRole patron GasID OUROBOROS|SC_NAME true)
            (ref-TS01-C1::DPTF|C_ToggleMintRole patron OuroID OUROBOROS|SC_NAME true)
            (ref-TS01-C1::DPTF|C_ToggleMintRole patron OuroID treasury-sc true)
            ;;
            ids
        )
    )
    (defun A_Step009 ()
        (let*
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                (patron:string DEMIURGOI|AH_NAME)
                (OuroID:string (ref-DALOS::UR_OuroborosID))
                (AurynID:string (ref-DALOS::UR_AurynID))
                (EliteAurynID:string (ref-DALOS::UR_EliteAurynID))

                (VestedOuroID:string (ref-TS01-C2::VST|C_CreateVestingLink patron OuroID))
                (VestedAurynID:string (ref-TS01-C2::VST|C_CreateVestingLink patron AurynID))
                (VestedEliteAurynID:string (ref-TS01-C2::VST|C_CreateVestingLink patron EliteAurynID))
            )
            [VestedOuroID VestedAurynID VestedEliteAurynID]
        )
    )
    (defun A_Step010:list ()
        (let*
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                (patron:string DEMIURGOI|AH_NAME)
                (OuroID:string (ref-DALOS::UR_OuroborosID))
                (AurynID:string (ref-DALOS::UR_AurynID))
                (EliteAurynID:string (ref-DALOS::UR_EliteAurynID))
                (WrappedKadenaID:string (ref-DALOS::UR_WrappedKadenaID))
                (StakedKadenaID:string (ref-DALOS::UR_LiquidKadenaID))
                (ats-ids:list
                    (ref-TS01-C2::ATS|C_Issue
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
                (Auryndex:string (at 0 ats-ids))
                (Elite-Auryndex:string (at 1 ats-ids))
                (Kadena-Liquid-Index:string (at 2 ats-ids))
            )
            ;;Set Up <Auryndex> 4795
            (ref-TS01-C2::ATS|C_SetColdFee patron Auryndex
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
            (ref-TS01-C2::ATS|C_TurnRecoveryOn patron Auryndex true)
            ;;Set Up <EliteAuryndex>
            (ref-TS01-C2::ATS|C_SetColdFee patron Elite-Auryndex 7 [0.0] [[0.0]])
            (ref-TS01-C2::ATS|C_SetCRD patron Elite-Auryndex false 360 24)
            (ref-TS01-C2::ATS|C_ToggleElite patron Elite-Auryndex true)
            (ref-TS01-C2::ATS|C_TurnRecoveryOn patron Elite-Auryndex true)
            ;;Set Up <KdaLiquindex>
            (ref-TS01-C2::ATS|C_SetColdFee patron Kadena-Liquid-Index -1 [0.0] [[0.0]])
            (ref-TS01-C2::ATS|C_SetCRD patron Kadena-Liquid-Index false 12 6)
            (ref-TS01-C2::ATS|C_TurnRecoveryOn patron Kadena-Liquid-Index true)
            ats-ids
        )
    )
    (defun A_Step011 ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                (patron:string DEMIURGOI|AH_NAME)
                (ouro-amount:decimal 2000000.0)
            )
            (ref-TS01-C1::DPTF|C_Mint
                patron
                (ref-DALOS::UR_OuroborosID)
                patron
                ouro-amount
                true
            )
        )
    )
    (defun A_Step012 ()
        (let
            (
                (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                (patron:string DEMIURGOI|AH_NAME)
                (aozt:string PLEB|AOZT_NAME)
                (emma:string PLEB|EMMA_NAME)
            )
            (ref-TS01-C2::ORBR|C_Sublimate patron patron 10000.0)
            (ref-TS01-C2::ORBR|C_Sublimate patron aozt 750.0)
            (ref-TS01-C2::ORBR|C_Sublimate patron emma 10.0)
        )
    )
    (defun A_Step013 ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                (patron:string DEMIURGOI|AH_NAME)
                (AurynID:string (ref-DALOS::UR_AurynID))
                (EliteAurynID:string (ref-DALOS::UR_EliteAurynID))
                (WrappedKadenaID:string (ref-DALOS::UR_WrappedKadenaID))
                (StakedKadenaID:string (ref-DALOS::UR_LiquidKadenaID))
            )
            (ref-TS01-A::DALOS|A_IgnisToggle false true)
            (ref-TS01-A::DALOS|A_IgnisToggle true true)
            ;;
            (ref-TS01-C1::DPTF|C_DeployAccount patron AurynID ATS|SC_NAME)
            (ref-TS01-C1::DPTF|C_DeployAccount patron EliteAurynID ATS|SC_NAME)
            (ref-TS01-C1::DPTF|C_DeployAccount patron WrappedKadenaID LQD|SC_NAME)
            (ref-TS01-C1::DPTF|C_DeployAccount patron StakedKadenaID LQD|SC_NAME)
            ;;Set Token Roles Part III
            (ref-TS01-C1::DPTF|C_SetFee patron StakedKadenaID -1.0)
            (ref-TS01-C1::DPTF|C_ToggleFee patron StakedKadenaID true)
            (ref-TS01-C1::DPTF|C_ToggleFeeLock patron StakedKadenaID true)
            (ref-TS01-C1::DPTF|C_ToggleBurnRole patron WrappedKadenaID LQD|SC_NAME true)
            (ref-TS01-C1::DPTF|C_ToggleMintRole patron WrappedKadenaID LQD|SC_NAME true)
        )
    )
    (defun A_Step014 ()
        (let
            (
                (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                (patron:string DEMIURGOI|AH_NAME)
            )
            (ref-TS01-C2::LQD|C_WrapKadena patron patron 1.0)
        )
    )
    (defun A_Step015 ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                (patron:string DEMIURGOI|AH_NAME)
            )
            (ref-TS01-C2::ATS|C_Coil
                patron
                patron
                (at 0 (ref-DPTF::UR_RewardBearingToken (ref-DALOS::UR_LiquidKadenaID)))
                (ref-DALOS::UR_WrappedKadenaID)
                1.0
            )
        )
    )
    (defun A_Step016 ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                (patron:string DEMIURGOI|AH_NAME)
                (atspair:string  (at 0 (ref-DPTF::UR_RewardBearingToken (ref-DALOS::UR_AurynID))))
                (rt-amounts:[decimal] [418414.8824])
                (rbt-request-amount:decimal 159016.8713)
            )
            (ref-TS01-C2::ATS|C_KickStart patron patron atspair rt-amounts rbt-request-amount)
        )
    )
    (defun A_Step017 ()
        (let*
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                (patron:string DEMIURGOI|AH_NAME)
                (atspair:string  (at 0 (ref-DPTF::UR_RewardBearingToken (ref-DALOS::UR_EliteAurynID))))
                (rt-amounts:[decimal] [114907.2904])
                (rbt-request-amount:decimal (at 0 rt-amounts))
            )
            (ref-TS01-C2::ATS|C_KickStart patron patron atspair rt-amounts rbt-request-amount)
        )
    )
    (defun A_Step018 ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                (patron:string DEMIURGOI|AH_NAME)
                (ouro-id:string (ref-DALOS::UR_OuroborosID))

            )
            (ref-TS01-C1::DPTF|C_Transmute patron ouro-id patron 10.0)
        )
    )
    (defun A_Step019 ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                (OuroID:string (ref-DALOS::UR_OuroborosID))
            )
            (ref-TS01-C1::DPTF|C_Transfer
                DEMIURGOI|AH_NAME
                OuroID
                DEMIURGOI|AH_NAME
                PLEB|EMMA_NAME
                2.0
                false
            )
        )
    )
    (defun A_Step020:list ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                (patron:string DEMIURGOI|AH_NAME)
                (OuroID:string (ref-DALOS::UR_OuroborosID))
                (ids:list
                    (ref-TS01-C1::DPTF|C_Issue
                        patron
                        patron
                        ["Vesta"]
                        ["VST"]
                        [24]
                        [true]
                        [true]
                        [true]
                        [true]
                        [true]
                        [true]
                    )
                )
                (VestaID:string (at 0 ids))
                (FrozenVestaID:string (ref-TS01-C2::VST|C_CreateFrozenLink patron VestaID))
                (SleepingVestaID:string (ref-TS01-C2::VST|C_CreateSleepingLink patron VestaID))
                (ReservedOuroID:string (ref-TS01-C2::VST|C_CreateReservationLink patron OuroID))
            )
            [VestaID FrozenVestaID SleepingVestaID ReservedOuroID]
        )
    )
    (defun A_Step021 ()
        (acquire-module-admin free.SWP)
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                (u:[string] [BAR])
            )
            (insert ref-SWP::SWP|Asymmetry ref-SWP::SWP|INFO
                {"asymmetric"           : false}
            )
            (insert ref-SWP::SWP|Properties ref-SWP::SWP|INFO
                {"principals"           : u
                ,"primordial-pool"      : BAR
                ,"liquid-boost"         : false
                ,"spawn-limit"          : 1000.0
                ,"inactive-limit"       : 100.0}
            )
            (insert ref-SWP::SWP|Pools "P2"
                {"pools"                : u}
            )
            (insert ref-SWP::SWP|Pools "P3"
                {"pools"                : u}
            )
            (insert ref-SWP::SWP|Pools "P4"
                {"pools"                : u}
            )
            (insert ref-SWP::SWP|Pools "P5"
                {"pools"                : u}
            )
            (insert ref-SWP::SWP|Pools "P6"
                {"pools"                : u}
            )
            (insert ref-SWP::SWP|Pools "P7"
                {"pools"                : u}
            )
            (insert ref-SWP::SWP|Pools "S2"
                {"pools"                : u}
            )
            (insert ref-SWP::SWP|Pools "S3"
                {"pools"                : u}
            )
            (insert ref-SWP::SWP|Pools "S4"
                {"pools"                : u}
            )
            (insert ref-SWP::SWP|Pools "S5"
                {"pools"                : u}
            )
            (insert ref-SWP::SWP|Pools "S6"
                {"pools"                : u}
            )
            (insert ref-SWP::SWP|Pools "S7"
                {"pools"                : u}
            )
        )
    )
    (defun A_Step022 ()
        (let
            (
                (patron:string DEMIURGOI|AH_NAME)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                (ref-TS01-A:module{TalosStageOne_AdminV4} TS01-A)
                (p1:string (ref-DALOS::UR_LiquidKadenaID))
                (p2:string (ref-DALOS::UR_OuroborosID))
            )
            (ref-TS01-A::SWP|A_UpdatePrincipal p1 true)
            (ref-TS01-A::SWP|A_UpdatePrincipal p2 true)

            (ref-TS01-C1::DPTF|C_DeployAccount patron p1 SWP|SC_NAME)
            (ref-TS01-C1::DPTF|C_ToggleFeeExemptionRole patron p1 SWP|SC_NAME true)
            (ref-TS01-C1::DPTF|C_ToggleBurnRole patron p1 SWP.SWP|SC_NAME true)

            (ref-TS01-C1::DPTF|C_DeployAccount patron p2 SWP|SC_NAME)
            (ref-TS01-C1::DPTF|C_ToggleFeeExemptionRole patron p2 SWP|SC_NAME true)
        )
    )
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)