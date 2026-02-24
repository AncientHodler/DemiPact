(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")


;"Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
;"DHN-vQePGHkCAkR1"
;(n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.GAS_PAYER "" 0 0.0)
;(IGNIS.C_Collect "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî" (IGNIS.UDC_CustomCodeCumulator))
;(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")

(let
    (
        (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
        (KpayID:string "KPAY-8ogtqXeTmcSe")
        (kpay-accounts:[string] (ref-DPTF::URD_ExistingTrueFungibles KpayID))
        (supplies:[decimal]
            (map
                (lambda
                    (account:string)
                    (ref-DPTF::UR_AccountSupply KpayID account)
                )
                kpay-accounts
            )
        )
    )
    (format "Accounts owning KPAY are {}" [kpay-accounts])
    (format "Their Supplies are: {}" [supplies])
)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(let
    (
        (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
        (ref-ELITE:module{EliteV1} ELITE)
        (ref-INFO-ZERO:module{OuronetInfoV1} INFO-ZERO)
        (EaID:string "EliteAuryndex-ds4il5rO7vDC")
        (ea-accounts:[string] (ref-DPTF::URD_ExistingTrueFungibles EaID))
        (supplies:[decimal]
            (map
                (lambda
                    (account:string)
                    (ref-DPTF::UR_AccountSupply EaID account)
                )
                kpay-accounts
            )
        )
    )
    (format "Accounts owning native EliteAuryn are {}" [(map (ref-INFO-ZERO::OI|UC_ShortAccount) ea-accounts)])
    (format "Native EA Supplies of these accounts are: {}" [supplies])
    (format "Total EA Supplies (all variants) of these accounts are: {}" [(map (ref-ELITE::URC_EliteAurynzSupply) ea-accounts)])
)


(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "KPAY-8ogtqXeTmcSe"
    "Ѻ.CЭΞŸNGúůρhãmИΘÛ¢₳šШдìAÚwŚGýηЗПAÊУÔȘřŽÍζЗηmΔφDmcдΛъ₳tĂýăŮsПÞ$öœGθeBŽvąαÃfçл¢ĎĆď$şbsЦэΘNÄëÍĂνуãöž¥àZjÆůšÁœôñχŽâЩåτâн4μфAOçĎΓuЗŮnøЙãĚè6Дżîþż$цÑûρψŻïZÉλûæřΨeèÎígςeL"
    "Ѻ.ÃěqÒřщюãovÊΦиν6žтŃñĐMrî¥ÜNÚфî6WLnëѺąöÙЙÂRжUč7eдiÒöbJŻ₳pĆνÛ¢νΛ∇мęqZβłωõĚЫłзȚdtbΨαÇπЬШź1Õ6νσSъПgúΞáejTÑěδK¥õfäĘ3ęìțã₱8H∇уYêŽvXÍЪÀуyΓШąΘČψxÉψýÈœЖPΓÈăjтüdGãLΠςЛùÈČф"
    51.5
    false
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "KPAY-8ogtqXeTmcSe"
    "Ѻ.ÍăüÙÜЦżΦF₿ÈшÕóñĐĞGюѺλωÇțnθòoйEςк₱0дş3ôPpxŞțqgЖ€šωbэočΞìČ5òżŁdŒИöùЪøŤяжλзÜ2ßżpĄγïčѺöэěτČэεSčDõžЩУЧÀ₳ŚàЪЙĎpЗΣ2ÃлτíČнÙyéÕãďWŹŘĘźσПåbã€éѺι€ΓφŠ₱ŽyWcy5ŘòmČ₿nβÁ¢¥NЙëOι"
    "Ѻ.ĄÀтмωωàŹČлďÜhÍηЛνÙνûĘõțЫåÒÛHážNÍЧψξïžŹЬΛξП¥ЮςĄEйNĄЧ9óпиÃЗ2äÔвœ₿£ČóΩÞдréě7νшDÅЬXтBørŸĂBςąЙęìvÆлμЛáΩγĘЗôåУțτжéδÚνpÍżȘĘï4ąŹȘkφNθþÀωΞÀWžIи5ь€ÊOôΣëñэÔÿνÜw1юÔzźцξńѺfś"
    51.5
    false
)


(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(let
    (
        (ref-U|CT|DIA:module{DiaKdaPidV1} U|CT)
        (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
        ;;
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (swpair:string "W|LKDA-slLyzPPCo22W|OURO-slLyzPPCo22W|WKDA-slLyzPPCo22W")
        (la:[decimal] [0.0 100.0 0.0])
        ;;
        (function-zero:list (TS01-CP.SWP|F0|A_AddStandardLiquidity patron patron swpair la kda-pid))
        ;;
        (yielded-pool-state:object{SwapperLiquidityV1.PoolState} (at "pool-state" (at 1 function-zero)))
        (yielded-ld:object{SwapperLiquidityV1.LiquidityData} (at "ld" (at 1 function-zero)))
        (yielded-clad:object{SwapperLiquidityV1.CompleteLiquidityAdditionData} (at "clad" (at 1 function-zero)))
        ;;
        ;;
        ;;FUNCTION 1
        (function-one:list (TS01-CP.SWP|F1|A_AddStandardLiquidity patron patron swpair la kda-pid yielded-pool-state yielded-ld yielded-clad))
        (yielded-primary-lp-amount:decimal (at "primary-lp-amount" (at 1 function-one)))
        (yielded-secondary-lp-amount:decimal (at "secondary-lp-amount" (at 1 function-one)))
    )
    [
        (at 0 function-zero)
        (at 0 function-one)
        (TS01-CP.SWP|F2|A_AddStandardLiquidity patron patron swpair la  kda-pid yielded-primary-lp-amount yielded-secondary-lp-amount)
        (n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
            "OURO-slLyzPPCo22W"
            "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ"
        )
    ]
)


(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(acquire-module-admin MTX-SWP-V2)
(acquire-module-admin SWPL)
(acquire-module-admin DPTF)
(let
    (
        (ref-U|CT|DIA:module{DiaKdaPidV1} U|CT)
        (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
        ;;
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (swpair:string "W|LKDA-slLyzPPCo22W|OURO-slLyzPPCo22W|WKDA-slLyzPPCo22W")
        (la:[decimal] [0.0 100.0 0.0])
        ;;
        (function-zero:list (TS01-CP.SWP|F0|A_AddStandardLiquidity patron patron swpair la kda-pid))
        ;;
        (yielded-pool-state:object{SwapperLiquidityV1.PoolState} (at "pool-state" (at 1 function-zero)))
        (yielded-ld:object{SwapperLiquidityV1.LiquidityData} (at "ld" (at 1 function-zero)))
        (yielded-clad:object{SwapperLiquidityV1.CompleteLiquidityAdditionData} (at "clad" (at 1 function-zero)))
        ;;
        ;;
        ;;FUNCTION 1
        (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
        (ref-SWPL:module{SwapperLiquidityV1} SWPL)
        (current-pool-state:object{SwapperLiquidityV1.PoolState} (MTX-SWP.UR_PoolState swpair))
        (primary:decimal (at "primary-lp" yielded-clad))
        (secondary:decimal (at "secondary-lp" yielded-clad))
        (sum-lp:decimal (+ primary secondary))
    )
    (enforce 
        (= yielded-pool-state current-pool-state) 
        "Execution Step of Adding Liquidity cannot execute on altered pool state!"
    )
    (ref-IGNIS::C_Collect patron 
        (at "perfect-ignis-fee" (at "clad-op" yielded-clad))
    )
    (with-capability (MTX-SWP-V2.MTX-SWP|C>ADD-STANDARD-LQ swpair yielded-ld)
        ;;<asymmetric-collection=true> <gaseous-collection=true>
        ;;(ref-SWPL::XE|KDA-PID_AddLiqudity 
        ;;    patron swpair true true kda-pid yielded-ld yielded-clad
        ;;)
        (let
            (
                (account:string patron)
                (asymmetric-collection:bool true)
                (gaseous-collection:bool true)
                (ld:object{SwapperLiquidityV1.LiquidityData} yielded-ld)
                (clad:object{SwapperLiquidityV1.CompleteLiquidityAdditionData} yielded-clad)
                (account:string patron)
                ;;
                (ref-SWP:module{SwapperV1} SWP)
                ;;
                (balanced-liquidity:[decimal] (at "balanced" (at "sorted-lq" ld)))
                (asymmetric-liquidity:[decimal] (at "asymmetric" (at "sorted-lq" ld)))
                (iz-balanced:bool (at "iz-balanced" (at "sorted-lq-type" ld)))
                (iz-asymmetric:bool (at "iz-asymmetric" (at "sorted-lq-type" ld)))
                (pt-amounts-with-asymmetric:[decimal] (at "ppa" (at "clad-op" clad)))
                ;;
                (lp-id:string (ref-SWP::UR_TokenLP swpair))
                (gw:[decimal] (ref-SWP::UR_GenesisWeigths swpair))
                (read-lp-supply:decimal (ref-SWP::URC_LpCapacity swpair))
                (primary-lp-amount:decimal (at "primary-lp" clad))
                (secondary-lp-amount:decimal (at "secondary-lp" clad))
                (lp-mint:bool (at "lp-mint" (at "clad-op" clad)))
                (lp-to-mint:decimal (if lp-mint primary-lp-amount (+ primary-lp-amount secondary-lp-amount)))
            )
            (if iz-asymmetric
                (do
                    (if iz-balanced
                        (with-capability (SWPL.SWPL|S>ADD_BALANCED-LQ account swpair balanced-liquidity)
                            (with-capability (SWPL.SWPL|S>ADD_ASYMMETRIC-LQ account swpair asymmetric-liquidity)
                                (ref-SWP::XE_UpdateSupplies swpair pt-amounts-with-asymmetric)
                                (if (= read-lp-supply 0.0)
                                    (ref-SWP::XB_ModifyWeights swpair gw)
                                    true
                                )
                            )
                        )
                        (with-capability (SWPL.SWPL|S>ADD_ASYMMETRIC-LQ account swpair asymmetric-liquidity)
                            (ref-SWP::XE_UpdateSupplies swpair pt-amounts-with-asymmetric)
                        )
                    )
                    (with-capability (SWPL.SWPL|S>ASYMMETRIC-LQ-GASEOUS-TAX (at "gaseous-text" clad)) true)
                    (if asymmetric-collection
                        (let
                            (
                                (ref-U|SWP:module{UtilitySwpV1} U|SWP)
                                (ref-DALOS:module{OuronetDalosV1} DALOS)
                                (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
                                (ref-TFT:module{TrueFungibleTransferV1} TFT)
                                (ref-ORBR:module{OuroborosV1} OUROBOROS)
                                (ref-SWPI:module{SwapperIssueV1} SWPI)
                                ;;
                                (ignis-id:string (ref-DALOS::UR_IgnisID))
                                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                                (lkda-id:string (ref-DALOS::UR_LiquidKadenaID))
                                (primordial-swpair:string (ref-SWP::UR_PrimordialPool))
                                (lqboost-ignis-tax:decimal (at "lqboost-ignis-tax" clad))
                                (primordial-supplies:[decimal] (ref-SWP::UR_PoolTokenSupplies primordial-swpair))
                                ;;
                                ;;Computing the LQ Boost Tax
                                ;;
                                (ouro-mint-amount:decimal 
                                    (if (= lqboost-ignis-tax 0.0)
                                        0.0
                                        (at 0 (ref-ORBR::URC_Compress lqboost-ignis-tax))
                                    )
                                )    
                                (dsid:object{UtilitySwpV1.DirectSwapInputData}
                                    (ref-U|SWP::UDC_DirectSwapInputData
                                        [ouro-id]
                                        [ouro-mint-amount]
                                        lkda-id
                                    )
                                )
                                (lkda-burn-amount:decimal 
                                    (if (= lqboost-ignis-tax 0.0)
                                        0.0
                                        (ref-SWPI::URC_Swap primordial-swpair dsid false)
                                    )
                                )
                                (bk-ids:[string] (at "bk-ids" (at "clad-op" clad)))
                                (bk-amt:[decimal] (at "bk-amt" (at "clad-op" clad)))
                                (BAR:string "|")
                                (SWP|SC_NAME:string "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ")
                            )
                            (with-capability (SWPL.SECURE) (SWPL.XI_AddLiqSendAndMint account lp-id lp-to-mint clad))
                            ;;Handle Special Targets
                            (if (!= bk-ids [BAR])
                                (ref-TFT::C_MultiBulkTransfer
                                    [ignis-id]
                                    SWP|SC_NAME
                                    [bk-ids]
                                    [bk-amt]
                                )
                                true
                            )
                            ;;Handle Liquid Boost
                            (if (!= lqboost-ignis-tax 0.0)
                                (let
                                    (
                                        (id-x:string ignis-id)
                                        (account-x:string SWP|SC_NAME)
                                        (amount-x:decimal lqboost-ignis-tax)
                                    )
                                    (DPTF.UEV_IMC)
                                    (let
                                        (
                                            (ref-U|DPTF:module{UtilityDptfV1} U|DPTF)
                                            (ref-DALOS:module{OuronetDalosV1} DALOS)
                                            (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                                        )
                                        (with-capability (DPTF.DPTF|C>BURN id-x account-x amount-x)
                                            (with-capability (DPTF.SECURE)
                                                (DPTF.UEV_IMC)
                                                (with-capability (DPTF|C>DEBIT account-x id-x amount-x (ref-U|DPTF::EmptyDispo) false)
                                                    (let
                                                        (
                                                            (current-supply:decimal (DPTF.UR_AccountSupply id-x account-x))
                                                        )
                                                        (XI_UpdateBalance id-x account-x (- current-supply amount-x))
                                                    )
                                                )
                                            )
                                        )
                                    )

                                )
                                true
                            )
                        )
                        (with-capability (SWPL.SECURE) (SWPL.XI_AddLiqSendAndMint account lp-id lp-to-mint clad))
                    )
                )
                true
            )
        )
    )
    true
)




(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(acquire-module-admin SWPLC)
(let
    (
        (ref-DPTF:module{DemiourgosPactTrueFungibleV1} DPTF)
        (ref-SWP:module{SwapperV1} SWP)
        (account:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (swpair:string "W|LKDA-slLyzPPCo22W|OURO-slLyzPPCo22W|WKDA-slLyzPPCo22W")
        (lp-id:string (ref-SWP::UR_TokenLP swpair))
        (lp-amount:decimal (ref-DPTF::UR_AccountSupply lp-id account))
        (SWP|SC_NAME:string "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ")
    )
    (with-capability (SWPLC.SWPLC|C>REMOVE_LQ swpair lp-amount)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV1} IGNIS)
                (ref-TFT:module{TrueFungibleTransferV1} TFT)
                (ref-SWPL:module{SwapperLiquidityV1} SWPL)
                ;;
                (pool-token-ids:[string] (ref-SWP::UR_PoolTokens swpair))
                (lp-id:string (ref-SWP::UR_TokenLP swpair))
                (pt-output-amounts:[decimal] (ref-SWPL::URC_LpBreakAmounts swpair lp-amount))
                (pt-current-amounts:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (pt-new-amounts:[decimal] (zip (-) pt-current-amounts pt-output-amounts))
                ;;
                ;;Removing Liquidity requires a flat fee of 10$ in Ignis
                ;;This deincentivizes frequent Liquidity removals
                ;;
                (flat-ignis-lq-rm-fee:decimal 1000.0)
                (trigger:bool (ref-IGNIS::URC_IsVirtualGasZero))
                (ico-flat:object{IgnisCollectorV1.OutputCumulator}
                    (ref-IGNIS::UDC_ConstructOutputCumulator flat-ignis-lq-rm-fee SWP|SC_NAME trigger [])
                )
            )
            ;;Transfers
            (ref-TFT::C_Transfer lp-id account SWP|SC_NAME lp-amount true)
            (ref-DPTF::C_Burn lp-id SWP|SC_NAME lp-amount)
            (ref-TFT::C_MultiTransfer pool-token-ids SWP|SC_NAME account pt-output-amounts true)
            ;;Updates Pool Supplies
            (ref-SWP::XE_UpdateSupplies swpair pt-new-amounts)
            ;;Autonomous Swap Mangement
            (ref-SWPL::XE_AutonomousSwapManagement swpair)
            pt-output-amounts
        )
    )
)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
    "OURO-slLyzPPCo22W"
    "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ"
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
    "WKDA-slLyzPPCo22W"
    "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ"
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
    "LKDA-slLyzPPCo22W"
    "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ"
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.SWP.UR_PoolTokenSupplies
    "W|LKDA-slLyzPPCo22W|OURO-slLyzPPCo22W|WKDA-slLyzPPCo22W"
)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_TF_AccountSupply
    "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ"
    true
)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(acquire-module-admin DPTF)
(read DPTF.DPTF|BalanceTable (DPTF.UC_IdAccount "OURO-slLyzPPCo22W" "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ"))



[(n_7d40ccda457e374d8eb07b658fd38c282c545038.SWP.UR_PoolTokenSupplies
    "W|LKDA-slLyzPPCo22W|OURO-slLyzPPCo22W|WKDA-slLyzPPCo22W"
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
    "OURO-slLyzPPCo22W"
    "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ"
)]



(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(acquire-module-admin DALOS)
(with-capability (DALOS.SECURE)
    (DALOS.XB_UpdateBalance 
        "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ" 
        true
        35496.704584619470534898570204
    )
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
    "OURO-slLyzPPCo22W"
    "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ"
)


;;Check Wrapping Contract
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Mint
    "Ѻ.A0ěьπΨтÎșπЦĐđŽ6ЫêÀεÅĐȘдÞЩ4Ł2ďй5žömiτsλÚÇдěÒaV₱ÏûιЩД₳îJÍşыyÜŹżęìvAЙsÄ¢ÿnΦIťQůЮ7ĄвaèďíoáнõÎLJθÆEáПiXÿÒÀĘ14цU1çΞêSťüIψчèι₱ê9ŽчΓüЦrÀÓμĆ99κQťqPÖшŮ1ÈČSĐŁÌбÝàŞbPσŃĎ8ĄW"
    "WKDA-slLyzPPCo22W"
    "Ѻ.A0ěьπΨтÎșπЦĐđŽ6ЫêÀεÅĐȘдÞЩ4Ł2ďй5žömiτsλÚÇдěÒaV₱ÏûιЩД₳îJÍşыyÜŹżęìvAЙsÄ¢ÿnΦIťQůЮ7ĄвaèďíoáнõÎLJθÆEáПiXÿÒÀĘ14цU1çΞêSťüIψчèι₱ê9ŽчΓüЦrÀÓμĆ99κQťqPÖшŮ1ÈČSĐŁÌбÝàŞbPσŃĎ8ĄW"
    1.0
    false
)



(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(let    
    (
        (ref-P|VST:module{OuronetPolicyV1} VST)
        (ref-P|SWP:module{OuronetPolicyV1} SWP)
        (ref-U|G:module{OuronetGuardsV1} U|G)
        (ref-DALOS:module{OuronetDalosV1} DALOS)
        (ref-P|MTX-SWP:module{OuronetPolicyV1} MTX-SWP-V2)
        (ref-TS01-C1:module{TalosStageOne_ClientOneV1} TS01-C1)
        (ref-P|TS01-CP:module{OuronetPolicyV1} TS01-CP)
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (vst-sc:string (ref-DALOS::GOV|VST|SC_NAME))
        (swp-sc:string (ref-DALOS::GOV|SWP|SC_NAME))
    )
    [
        (ref-P|MTX-SWP::P|A_Define)
        (ref-P|TS01-CP::P|A_Define)
        (ref-TS01-C1::DALOS|C_RotateGovernor patron vst-sc
            (ref-U|G::UEV_GuardOfAny
                [
                    (create-capability-guard (VST.VST|GOV))
                    (ref-P|VST::P|UR "SWPLC|RemoteSwpGov")
                    (ref-P|VST::P|UR "MTX-SWP-V2|RemoteSwpGov")
                ]
            )
        )
        (ref-TS01-C1::DALOS|C_RotateGovernor patron swp-sc
            (ref-U|G::UEV_GuardOfAny
                [
                    (create-capability-guard (SWP.SWP|GOV))
                    (ref-P|SWP::P|UR "SWPU|RemoteSwpGov")
                    (ref-P|SWP::P|UR "SWPI|RemoteSwpGov")
                    (ref-P|SWP::P|UR "SWPLC|RemoteSwpGov")
                    (ref-P|SWP::P|UR "MTX-SWP-V2|RemoteSwpGov")
                ]
            )
        )
    ]
)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS02-DPAD.A_ToggleOpenForBusiness
    "KPAY-8ogtqXeTmcSe" true
)