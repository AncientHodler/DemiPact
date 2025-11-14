(interface KadenaPay
    ;;
    ;;  [UR]
    ;;
    (defun UR_KpayID:string ())
    (defun UR_KpayLeft:decimal ())
    (defun UR_KpayPID:decimal (offset:decimal))
    (defun UR_Kpay (account:string))
    ;)
    ;;  [URC]
    ;;
    (defun URC_KpayAmountCosts:object{DemiourgosLaunchpadV2.Costs} (amount:integer offset:decimal))
    (defun URC_Acquire:[string] (buyer:string amount:integer iz-native:bool))
    (defun URC_GetMaxBuy:integer (account:string native:bool))
    ;;
    ;;  [C]
    ;;
    (defun C_BuyKpay (patron:string buyer:string kpay-amount:integer iz-native:bool))

)
(module DEMIPAD-KPAY GOV
    @doc "Module defining the Sale Mechanics for Kadena Pay Token"
    ;;
    (implements OuronetPolicy)
    (implements KadenaPay)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_KPAY                       (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    (defconst DEMIPAD|SC_NAME                   (GOV|DEMIPAD|SC_NAME))
    ;;{G2}
    (defcap GOV ()                              (compose-capability (GOV|KPAY_ADMIN)))
    (defcap GOV|KPAY_ADMIN ()                   (enforce-guard GOV|MD_KPAY))
    ;;{G3}
    (defun GOV|Demiurgoi ()                     (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|DEMIPAD|SC_NAME ()               (let ((ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)) (ref-DEMIPAD::GOV|DEMIPAD|SC_NAME)))
    ;;
    ;;Repl
    (defun GOV|COMPANY ()                       (at 0 ["Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"]))
    (defun GOV|PRIVATE ()                       (at 0 ["Ѻ.CЭΞŸNGúůρhãmИΘÛ¢₳šШдìAÚwŚGýηЗПAÊУÔȘřŽÍζЗηmΔφDmcдΛъ₳tĂýăŮsПÞ$öœGθeBŽvąαÃfçл¢ĎĆď$şbsЦэΘNÄëÍĂνуãöž¥àZjÆůšÁœôñχŽâЩåτâн4μфAOçĎΓuЗŮnøЙãĚè6Дżîþż$цÑûρψŻïZÉλûæřΨeèÎígςeL"]))
    (defun GOV|VENTURE ()                       (at 0 ["Ѻ.ÍăüÙÜЦżΦF₿ÈшÕóñĐĞGюѺλωÇțnθòoйEςк₱0дş3ôPpxŞțqgЖ€šωbэočΞìČ5òżŁdŒИöùЪøŤяжλзÜ2ßżpĄγïčѺöэěτČэεSčDõžЩУЧÀ₳ŚàЪЙĎpЗΣ2ÃлτíČнÙyéÕãďWŹŘĘźσПåbã€éѺι€ΓφŠ₱ŽyWcy5ŘòmČ₿nβÁ¢¥NЙëOι"]))
    ;;Deploy
    ;(defun GOV|COMPANY ()                       (at 0 ["Ѻ.ĄÀтмωωàŹČлďÜhÍηЛνÙνûĘõțЫåÒÛHážNÍЧψξïžŹЬΛξП¥ЮςĄEйNĄЧ9óпиÃЗ2äÔвœ₿£ČóΩÞдréě7νшDÅЬXтBørŸĂBςąЙęìvÆлμЛáΩγĘЗôåУțτжéδÚνpÍżȘĘï4ąŹȘkφNθþÀωΞÀWžIи5ь€ÊOôΣëñэÔÿνÜw1юÔzźцξńѺfś"]))
    ;(defun GOV|PRIVATE ()                       (at 0 ["Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"]))
    ;(defun GOV|VENTURE ()                       (at 0 ["Ѻ.ÃěqÒřщюãovÊΦиν6žтŃñĐMrî¥ÜNÚфî6WLnëѺąöÙЙÂRжUč7eдiÒöbJŻ₳pĆνÛ¢νΛ∇мęqZβłωõĚЫłзȚdtbΨαÇπЬШź1Õ6νσSъПgúΞáejTÑěδK¥õfäĘ3ęìțã₱8H∇уYêŽvXÍЪÀуyΓШąΘČψxÉψýÈœЖPΓÈăjтüdGãLΠςЛùÈČф"]))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|KPAY|CALLER ()
        true
    )
    (defcap P|PAD-KPAY|REMOTE-GOV ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|KPAY|CALLER))
        (compose-capability (SECURE))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|KPAY_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|KPAY_ADMIN)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (dg:guard (create-capability-guard (SECURE)))
                )
                (with-default-read P|MT P|I
                    {"m-policies" : [dg]}
                    {"m-policies" := mp}
                    (write P|MT P|I
                        {"m-policies" : (ref-U|LST::UC_AppL mp policy-guard)}
                    )
                )
            )
        )
    )
    (defun P|A_Define ()
        (let
            (
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|DPAD:module{OuronetPolicy} DEMIPAD)
                (mg:guard (create-capability-guard (P|KPAY|CALLER)))
            )
            (ref-P|DPAD::P|A_Add
                "KPAY|RemoteGov"
                (create-capability-guard (P|PAD-KPAY|REMOTE-GOV))
            )
            (ref-P|TFT::P|A_AddIMP mg)
            (ref-P|DPAD::P|A_AddIMP mg)
        )
    )
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
            )
            (ref-U|G::UEV_Any (P|UR_IMP))
        )
    )
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    (defschema KPAY|PropertiesSchema
        asset-id:string
    )
    ;;{2}
    (deftable KPAY|T|Properties:{KPAY|PropertiesSchema})
    ;;{3}
    (defun KPAY|Info ()                     (at 0 ["KadenaPay"]))
    (defconst KPAY|INFO                     (KPAY|Info))
    (defun CT_Bar ()                        (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                           (CT_Bar))
    
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap KPAY|C>BUY (kpay-amount:integer)
        @event
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (KpayID:string (UR_KpayID))
                (remaining-supply:decimal (UR_KpayLeft))
                (amount:decimal (dec kpay-amount))
                (future-ten-minute-price:decimal (UR_KpayPID 600.0))
                (kpay-price:decimal
                    (if (= future-ten-minute-price -1.0)
                        (UR_KpayPID 0.0)
                        (UR_KpayPID 600.0)
                    )
                )
            )
            (enforce (<= amount remaining-supply) "Remaining Amount surpassed!")
            (enforce (> kpay-price 0.0) "Kpay Sale has Concluded!")
            (compose-capability (P|PAD-KPAY|REMOTE-GOV))
            (compose-capability (P|KPAY|CALLER))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_KpayID:string ()
        (at "asset-id" (read KPAY|T|Properties KPAY|INFO ["asset-id"]))
    )
    (defun UR_GetPeriod:integer ()
        (let
            (
                (ref-DPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                ;;
                (KpayID:string (UR_KpayID))
                (starting-tm:time (at "starting-time" (ref-DPAD::UR_Price KpayID)))
                (present-tm:time (at "block-time" (chain-data)))
                (three-years:decimal 94608000.0)
                (period-length:decimal (/ three-years 25.0))  ; 3,784,320 seconds
                (elapsed:decimal (diff-time present-tm starting-tm))  ; Seconds between present and start
            )
            (if (< elapsed 0.0)
                -1 ;;Before Starting Time
                (if (>= elapsed three-years)
                    0 ;;After three years
                    (if (= elapsed 0.0)
                        1
                        (let
                            (
                                (p:integer (ceiling (/ elapsed period-length)))
                            )
                            (if (> p 25)
                                25
                                p
                            )
                        )
                    )
                )
            )
        )
    )
    (defun UR_PeriodAllocation:decimal (period:integer)
        (enforce (and (>= period -1) (<= period 25)) "Invalid Period")
        (if (or (= period -1) (= period 0))
            0.0
            (let
                (
                    (a1:decimal 4.4)
                    (ak:decimal (- 4.5 (* 0.1 (dec period))))
                    (sk:decimal (* (/ (dec period) 2.0)(+ a1 ak)))
                )
                (+ 20000000 (* sk 1000000.0))
            )
        )
    )
    (defun UR_KpayLeft:decimal ()
        @doc "Computes how much KPAY can still be bought this Period"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                ;;
                (KpayID:string (UR_KpayID))
                (resident-amount:decimal (ref-DPTF::UR_AccountSupply KpayID DEMIPAD|SC_NAME))
                (left-for-sale:decimal (* 0.4 resident-amount))
                (sold:decimal (- 100000000.0 left-for-sale))
                ;;
                (period:integer (UR_GetPeriod))
                (period-allocation:decimal (UR_PeriodAllocation period))
            )
            (if (or (= period -1)(= period 0))
                0.0
                (- period-allocation sold)
            )
        )
    )
    (defun UR_KpayPID:decimal (offset:decimal)
        @doc "Offset is used to compute the time with a future offset in seconds"
        (let
            (
                (ref-DPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                (KpayID:string (UR_KpayID))
                (starting-tm:time (at "starting-time" (ref-DPAD::UR_Price KpayID)))
                (present-tm:time (add-time (at "block-time" (chain-data)) offset))
                (elapsed-tm:decimal (diff-time present-tm starting-tm))
                (three-years:decimal 94608000.0)
            )
            (if (<= elapsed-tm 0.0)
                0.01
                (if (> elapsed-tm three-years)
                    1.0
                    (floor (+ 0.01 (* 0.99 (/ elapsed-tm three-years))) 24)
                )
            )
        )
    )
    (defun UR_Kpay (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-DPL-UR:module{DeployerReadsV4} DPL-UR)
                (ref-DPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                ;;
                (KpayID:string (UR_KpayID))
                (resident-amount:decimal (ref-DPTF::UR_AccountSupply KpayID DEMIPAD|SC_NAME))
                (left-for-sale:decimal (* 0.4 resident-amount))
                (sold:decimal (- 100000000.0 left-for-sale))
                (period:integer (UR_GetPeriod))
                (period-ceiling:decimal (UR_PeriodAllocation period))
                (remaining:decimal (UR_KpayLeft))
                (bought:decimal 
                    (if (or (= period -1)(= period 0))
                        sold
                        (- period-ceiling remaining)
                    )
                )    
                (circulating:decimal (* 2.5 bought))
                ;;
                (starting-tm:time (at "starting-time" (ref-DPAD::UR_Price KpayID)))
                ;;
                (single-costs:object{DemiourgosLaunchpadV2.Costs} (URC_KpayAmountCosts 1 0.0))
                (stage-text:string
                    (if (= period -1)
                        "Stage 1 Starts in:"
                        (if (= period 0)
                            (format "KPay Sale has concluded")
                            (format "Stage {}/25" [period])
                        )
                        
                    )
                )
                (next-stage-text:string
                    (if (= period -1)
                        (format "Genesis Period Ceiling: {} KPAY" [(UR_PeriodAllocation 1)])
                        (if (= period 0)
                            (format "KPAY Circulating supply is {}" [circulating])
                            (if (!= period 25)
                                (format "Next  Stage Ceiling: {} KPAY" [(UR_PeriodAllocation (+ 1 period))])
                                (format "Final Stage Ceiling: {} KPAY" [period-ceiling])
                            )
                        )
                    )
                )
                (percent-value:string 
                    (if (or (= period -1) (= period 0))
                        (ref-DPL-UR::UC_FormatTokenAmount 0.0)
                        (ref-DPL-UR::UC_FormatTokenAmount (* (/ bought period-ceiling) 100.0))
                    )
                )
                (percent-text:string 
                    (if (= period -1)
                        "Sale hasn't started yet."
                        (if (= period 0)
                            (format "Sale has Concluded: {}% has been sold." [percent-value])
                            (format "Sale Progress: {}% of Current Ceiling." [percent-value])
                        )
                    )
                )
                (ceiling-text:string 
                    (if (= period -1)
                        "Sale hasn't started yet."
                        (if (= period 0)
                            "Kpay Sale has concluded"
                            (format "Stage {} Celing: {} KPAY" [period period-ceiling])
                        )
                    )
                )   
            )
            {"stage-text"           : stage-text
            ,"next-stage-text"      : next-stage-text
            ;;
            ,"sale-progress"        : percent-text
            ,"ceiling-text"         : ceiling-text
            ,"sold-text"            : (format "{} KPAY Sold" [bought])
            ,"remaining-text"       : (format "{} KPAY left for Sale" [(if (= period -1) left-for-sale remaining)])
            ;;
            ,"your-balance"         : (ref-DPTF::UR_AccountSupply KpayID account)
            ,"circulating-supply"   : circulating
            ;;
            ;;Single Costs
            ,"kpay-pid"             : (at "pid" single-costs)
            ,"kpay-wkda"            : (at "wkda" single-costs)
            ;;
            ;;Native Buy Maxes
            ,"native-buy-max"       : (URC_GetMaxBuy account true)      ;; using 10 minutes in the future price to determine max
            ,"wkda-buy-max"         : (URC_GetMaxBuy account false)
            ;;
            ;;Misc and Direct Values
            ,"kpay-id"              : KpayID
            ,"remaining-for-mint"   : remaining
            ,"minted"               : bought
            ,"start-date"           : starting-tm
            ,"period"               : period
            ,"period-ceiling"       : period-ceiling
            ,"account-kpay"         : (ref-DPTF::UR_AccountSupply KpayID account)
            ,"account-ignis"        : (ref-DPTF::UR_AccountSupply (ref-DALOS::UR_IgnisID) account)
            ,"ignis-collection"     : (ref-DALOS::UR_VirtualToggle)
            ,"open-for-business"    : (ref-DPAD::UR_OpenForBusiness KpayID)
            }
        )
    )
    ;;{F1}  [URC]
    (defun URC_KpayAmountCosts:object{DemiourgosLaunchpadV2.Costs} (amount:integer offset:decimal)
        @doc "Computes Prices;"
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                ;;
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                ;;
                (KpayID:string (UR_KpayID))
                (Kpay-price:decimal (UR_KpayPID offset))
            )
            (ref-DEMIPAD::UDC_Costs
                (* (dec amount) Kpay-price)
                (floor (* (/ Kpay-price kda-pid) (dec amount)) kda-prec)
            )
        )
    )
    (defun URC_Acquire:[string]
        (buyer:string amount:integer iz-native:bool)
        @doc "An offset of 15 minutes (900.0 seconds) is used to compute values for the Coin.Transfer Capabilities"
        (let
            (
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                (KpayID:string (UR_KpayID))
                (type:integer (if iz-native 0 1))
                (pid:decimal (at "pid" (URC_KpayAmountCosts amount 900.0)))
            )
            (ref-DEMIPAD::URC_Acquire buyer KpayID pid type)
        )
    )
    (defun URC_GetMaxBuy:integer (account:string native:bool)
        @doc "Returns the maximum amount of Tokens that can still be bought \
            \ Considering the amount left, and the User Funds \
            \ A price of 10 minutes in the future is used to compute price.\
            \ If there are less than 10 minutes left, the present price is used."
        (let
            (
                (ref-coin:module{fungible-v2} coin)
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                ;;
                ;;
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                ;;
                (k-account:string (ref-DALOS::UR_AccountKadena account))
                (wkda:string (ref-DALOS::UR_WrappedKadenaID))
                (KpayID:string (UR_KpayID))
                (future-ten-minute-price:decimal (UR_KpayPID 600.0))
                (present-price:decimal (UR_KpayPID 0.0))
                (kpay-price:decimal
                    (if (= present-price future-ten-minute-price)
                        present-price
                        future-ten-minute-price
                    )
                )
                (still-for-sale:integer (floor (UR_KpayLeft)))
                ;;
                (client-kadena-supply:decimal
                    (if native
                        (ref-coin::get-balance k-account)
                        (ref-DPTF::UR_AccountSupply wkda account)
                    )
                )
                (client-kadena-value-in-dollarz:decimal (floor (* client-kadena-supply kda-pid) 2))
                (can-buy-with-client-supply:integer 
                    (if (= kpay-price -1.0)
                        0
                        (floor (/ client-kadena-value-in-dollarz kpay-price))
                    )
                )
                (period:integer (UR_GetPeriod))
            )
            (if (or (= period -1) (= period 0))
                0
                (if (<= can-buy-with-client-supply still-for-sale)
                    can-buy-with-client-supply
                    still-for-sale
                )
            )
        )
    )
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    (defun C_BuyKpay (patron:string buyer:string kpay-amount:integer iz-native:bool)
        (UEV_IMC)
        (with-capability (KPAY|C>BUY kpay-amount)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV4} INFO-ZERO)
                    (ref-TFT:module{TrueFungibleTransferV9} TFT)
                    (ref-DEMIPAD:module{DemiourgosLaunchpadV2} DEMIPAD)
                    ;;
                    (KpayID:string (UR_KpayID))
                    (costs:object{DemiourgosLaunchpadV2.Costs} (URC_KpayAmountCosts kpay-amount 0.0))
                    (pid:decimal (at "pid" costs))
                    (type:integer (if iz-native 0 1))
                    (ico1:object{IgnisCollectorV2.OutputCumulator}
                        (ref-DEMIPAD::C_Deposit buyer KpayID pid type false)
                    )
                    (ico2:object{IgnisCollectorV2.OutputCumulator}
                        (ref-TFT::C_Transfer KpayID DEMIPAD|SC_NAME buyer (dec kpay-amount) true)
                    )
                    (twenty-p:decimal (* 0.5 (dec kpay-amount)))
                    (ico3:object{IgnisCollectorV2.OutputCumulator}
                        (ref-TFT::C_MultiBulkTransfer [KpayID] DEMIPAD|SC_NAME
                            [[(GOV|COMPANY) (GOV|PRIVATE) (GOV|VENTURE)]]
                            [[twenty-p twenty-p twenty-p]]
                        )
                    )
                    (sb:string (ref-I|OURONET::OI|UC_ShortAccount buyer))
                    (present-kpay-price:decimal (UR_KpayPID 0.0))
                    (paid:decimal (at "wkda" costs))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2 ico3] [])
                )
                (if iz-native
                    (format "Account {} succesfully acquired {} KPAY at {} $ per Unit with {} Native KADENA"
                        [sb kpay-amount present-kpay-price paid]
                    )
                    (format "Account {} succesfully acquired {} KPAY at {} $ per Unit with {} WKDA"
                        [sb kpay-amount present-kpay-price paid]
                    )
                )
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)
(create-table KPAY|T|Properties)