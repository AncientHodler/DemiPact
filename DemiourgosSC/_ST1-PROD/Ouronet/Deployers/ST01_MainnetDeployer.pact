;;Contains Code needed to run when Setting Up Ouronet in Main Kadena Live Net
;;Code is sequenced in Steps, these needed to be run one after another.
;;Once all Steps are run, Ouronet is Live
;;
;;
;;STEP 001 - Namespace Deployment
(define-namespace
    (ns.create-principal-namespace (read-keyset "dh_master-keyset"))
    (read-keyset "dh_master-keyset" )
    (read-keyset "dh_master-keyset" )
)
;;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
(print "BEGIN STEP 002")
;;STEP 002 - Define all Necesary Keys on the Deployed Namespace
;;Replace the Namespace with the ACTUAL NAMEPACE created. This will be the namespace where Ouronet resides.
(let
    (
        ;;n_7d40ccda457e374d8eb07b658fd38c282c545038
        (ons:string "n_7d40ccda457e374d8eb07b658fd38c282c545038.")
        (k00:string "dh_master-keyset")
        (k01:string "dh_sc_dalos-keyset")
        (k02:string "dh_sc_autostake-keyset")
        (k03:string "dh_sc_vesting-keyset")
        (k04:string "dh_sc_kadenaliquidstaking-keyset")
        (k05:string "dh_sc_ouroboros-keyset")
        (k06:string "dh_sc_swapper-keyset")
        (k07:string "dh_sc_dhvault-keyset")
        (k08:string "dh_sc_custodians-keyset")
        (k09:string "dh_sc_dispenser-keyset")
        ;;Demiurgoi Keys
        (k10:string "dh_ah-keyset")
        (k11:string "dh_cto-keyset")
        (k12:string "dh_hov-keyset")
        ;;User Keys
        (k13:string "us-0000_aozt-keyset")
        (k14:string "us-0001_emma-keyset")
        (k15:string "us-0002_lumy-keyset")

    )
    (namespace (drop -1 ons))
    ;;Ouronet Keys
    (define-keyset (+ ons k00) (read-keyset k00))
    (define-keyset (+ ons k01) (read-keyset k01))
    (define-keyset (+ ons k02) (read-keyset k02))
    (define-keyset (+ ons k03) (read-keyset k03))
    (define-keyset (+ ons k04) (read-keyset k04))
    (define-keyset (+ ons k05) (read-keyset k05))
    (define-keyset (+ ons k06) (read-keyset k06))
    (define-keyset (+ ons k07) (read-keyset k07))
    (define-keyset (+ ons k08) (read-keyset k08))
    (define-keyset (+ ons k09) (read-keyset k09))

    (define-keyset (+ ons k10) (read-keyset k10))
    (define-keyset (+ ons k11) (read-keyset k11))
    (define-keyset (+ ons k12) (read-keyset k12))

    (define-keyset (+ ons k13) (read-keyset k13))
    (define-keyset (+ ons k14) (read-keyset k14))
    (define-keyset (+ ons k15) (read-keyset k15))
)
;;ENTER KDA Accounts associated with each keyset below for ease of use:
;;[0]   dh_master-keyset                      ||    k:35d7f82a7754d10fc1128d199aadb51cb1461f0eb52f4fa89790a44434f12ed8
;;[1]   dh_sc_dalos-keyset                    ||    k:10b998049806491ec3e26f7507020554441e6b9271cfee1779d85230139c92df
;;[2]   dh_sc_autostake-keyset                ||    k:725d6ad18c7e4ef6e2773f6bb315bde13437872d0235f6404c0c99d9d900bbb4
;;[3]   dh_sc_vesting-keyset                  ||    k:5047d039d1d918e3489f42a52a46b54cb5b3b259e42dd2e43c071fe2b77863f2
;;[4]   dh_sc_kadenaliquidstaking-keyset      ||    k:6a084a59d1485b4b41661ec05be6ebe9475f1fe1a19ba77018b9d176927611c9
;;[5]   dh_sc_ouroboros-keyset                ||    k:428a0ed942d266d84e6bf995d1612c009777eda858e92c0c9bc3ef8932d4e44d
;;[6]   dh_sc_swapper-keyset                  ||    k:572bd2e1a7e126c1072d328bbac3064ffadf96cc20fd0752f1c5875d549c2b31
;;[7]   dh_sc_dhvault-keyset                  ||    k:013b30abebdae21d5afd6e2d5b6486f6fae2b5aa6d8495a2aa3131ab8d292836
;;[8]   dh_sc_custodians-keyset               ||    k:5a082d160fd3fcb61f168ccfd78b19443880fb9d1952bc9bd6d289db1ad4075d
;;[9]   dh_sc_dispenser-keyset                ||    k:05654aee733a30bfdc2fd36461276c74e3a8a52b9065cc01bc2f1c947d3d8fab

;;[10]  dh_ah-keyset                          ||    k:2dd5ae3dd78493f468d2f99e36fe4e1a39002cd26196e472ff47f50adb577cb5      AH
;;[11]  dh_cto-keyset                         ||    k:1d9909881642d0bdfa39d6ff74165e0e632b6125cb6d772579fb51ac248bf9d8
;;[12]  dh_hov-keyset                         ||    k:2e5ffa38bf42d216f5e5773303250c40ae4a9453cea02bbdb2ae390b0205e2b0

;;[13]  us-0000_aozt-keyset                   ||    k:ad620c6759112c10a26519cc4e9a440721c04f1684f3c123f670d1c51f4bb4df
;;[14]  us-0001_emma-keyset                   ||    k:08786a657018b620ffce173a2071f85135ed9f4d7a67938a34b8d72f5c0763b1
;;[15]  us-0002_lumy-keyset                   ||    k:2df04179bfcddf22dd3d79c7d4afd9651e5f8e2a9dfbb8ba6fd9e77e2b432710


(print "END STEP 002")
;;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
(print "BEGIN STEP 003")
;;
;;STEP 003 - Before DEPLOY of Mainnet MODULES, you must check:
;;
;;1] Switch in U|CT the NameSpace to the Live Namespace, which is the namespace created above
;;
;;2] Modify the KDA Accounts saved in the DPL-DALOS (10), DPL-AOZ (1), and DSP (2), with ones above
;;
;;3] Add at the begining of each module, the line:
(namespace "...") ;;replacing ... with the Mainnetnamespace, to deploy the modules on the created namespace

;;4] In the DALOS Deployer, mind the
;;      KDA Costs to be inserted in the Table of Costs, values 1000 times bigger
;;      minted OURO Token amounts and Kickstart amounts,
;;      minted IGNIS amounts via sublimation to whom
;;      minted AOZ Token Amounts
;;      Step 15 - 20 in AOZ Deploy, input parameter, how many Kosons are to be coiled in each pool 250x3 Tokens x 6 ATSPairs, for example.


;;
;;[2]   ATS|SC_KDA-NAME                             k:
;;[3]   VST|SC_KDA-NAME                             k:
;;[6]   SWP|SC_KDA-NAME                             k:
;;[7]   DHV|SC_KDA-NAME                             k:
;;[8]   CST|SC_KDA-NAME                             k:
;;[9]   DSP|SC_KDA-NAME                             k:
;;
;;
;;[10]  DEMIURGOI|AH_KDA-NAME                       k:
;;[11]  DEMIURGOI|CTO_KDA-NAME                      k:1d9909881642d0bdfa39d6ff74165e0e632b6125cb6d772579fb51ac248bf9d8
;;[12]  DEMIURGOI|HOV_KDA-NAME                      k:2e5ffa38bf42d216f5e5773303250c40ae4a9453cea02bbdb2ae390b0205e2b0
;;[13]  PLEB|AOZT_KDA-NAME                          k:
;;[14]  PLEB|EMMA_KDA-NAME                          k:
;;[15]  PLEB|LUMY_KDA-NAME                          k:

;;Principal Accounts are
;;OUROBOROS Principal                               c:U9gIg2OvVyINjXEGFCkar1OYKLGkdJkOeMtglG4hWeo
;;DALOS Principal (Gas Station)                     c:EX0XSNfVxsm906AyVouFPXiLZPYObybqBCCtOpbb3HQ
;;LIQUID Principal (Holding Liquid Staking Funds)   c:81XjsM008PpbNVk2y91cPt0k7DpWuzWtEE2G8t9VZXY

(n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_AccountKadena
    "Σ.W∇ЦwÏξБØnζΦψÕłěîбηжÛśTã∇țâĆã4ЬĚIŽȘØíÕlÛřбΩцμCšιÄиMkλ€УщшàфGřÞыÎäY8È₳BDÏÚmßOozBτòÊŸŹjПкцğ¥щóиś4h4ÑþююqςA9ÆúÛȚβжéÑψéУoЭπÄЩψďşõшżíZtZuψ4ѺËxЖψУÌбЧλüșěđΔjÈt0ΛŽZSÿΞЩŠ"
)

;;Liquid Staking
(coin.TRANSFER "k:2dd5ae3dd78493f468d2f99e36fe4e1a39002cd26196e472ff47f50adb577cb5" "c:81XjsM008PpbNVk2y91cPt0k7DpWuzWtEE2G8t9VZXY" 10.0)
(coin.TRANSFER "k:1dacecf4d6fb57c68385b1da961f463e8b35275a13dd484f592a8a5a722224ca" "c:81XjsM008PpbNVk2y91cPt0k7DpWuzWtEE2G8t9VZXY" 5.0)


(coin.TRANSFER "c:81XjsM008PpbNVk2y91cPt0k7DpWuzWtEE2G8t9VZXY" "k:2dd5ae3dd78493f468d2f99e36fe4e1a39002cd26196e472ff47f50adb577cb5" 1.0)
;;KDA Collection for 900 KDA with 0.76 Rabat
(coin.TRANSFER "k:2dd5ae3dd78493f468d2f99e36fe4e1a39002cd26196e472ff47f50adb577cb5" "k:2e5ffa38bf42d216f5e5773303250c40ae4a9453cea02bbdb2ae390b0205e2b0" 68.4)
(coin.TRANSFER "k:2dd5ae3dd78493f468d2f99e36fe4e1a39002cd26196e472ff47f50adb577cb5" "k:1d9909881642d0bdfa39d6ff74165e0e632b6125cb6d772579fb51ac248bf9d8" 136.8)
(coin.TRANSFER "k:2dd5ae3dd78493f468d2f99e36fe4e1a39002cd26196e472ff47f50adb577cb5" "c:U9gIg2OvVyINjXEGFCkar1OYKLGkdJkOeMtglG4hWeo" 205.2)
(coin.TRANSFER "k:2dd5ae3dd78493f468d2f99e36fe4e1a39002cd26196e472ff47f50adb577cb5" "c:EX0XSNfVxsm906AyVouFPXiLZPYObybqBCCtOpbb3HQ" 273.6)

;;Paying 20 KDA for initialisation - 9500 left.
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.KDA|C_CollectWT
    "Ѻ.ÔlзюĞÞýжůúìЮRПы3эérДÏõÀЬâùèCχżÖtDlÅgБ6яğèιмgnŸŒćçнÎэnÅ5tĐηψìãŮĘΘe¢ЬA₳ΔЛ¢ρЦκĎвÈбe7ÖJΔÏ3șφûηnŤäčúμ£ЧλíĆC₱ëż₳χдYιΔäđAąoĞъØ∇hůτNÔRxgŹŹЫĐ7FςЭ8ΣσвhD3жâó¥ышΨψşψžźëÅôщc"
    2000.0
    false
)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.GAS_PAYER "" 0 0.0)
(coin.TRANSFER "k:1dacecf4d6fb57c68385b1da961f463e8b35275a13dd484f592a8a5a722224ca" "k:2e5ffa38bf42d216f5e5773303250c40ae4a9453cea02bbdb2ae390b0205e2b0" 200.0)    ;;10%
(coin.TRANSFER "k:1dacecf4d6fb57c68385b1da961f463e8b35275a13dd484f592a8a5a722224ca" "c:EX0XSNfVxsm906AyVouFPXiLZPYObybqBCCtOpbb3HQ" 400.0)                         ;;20%
(coin.TRANSFER "k:1dacecf4d6fb57c68385b1da961f463e8b35275a13dd484f592a8a5a722224ca" "k:1d9909881642d0bdfa39d6ff74165e0e632b6125cb6d772579fb51ac248bf9d8" 600.0)    ;;30%
(coin.TRANSFER "k:1dacecf4d6fb57c68385b1da961f463e8b35275a13dd484f592a8a5a722224ca" "c:U9gIg2OvVyINjXEGFCkar1OYKLGkdJkOeMtglG4hWeo" 800.0)                         ;;40%



;;LiquidStaking Projection
(let
    (
        (values:[decimal] (n_7d40ccda457e374d8eb07b658fd38c282c545038.OUROBOROS.URC_ProjectedKdaLiquindex))
        (v1:decimal (at 0 values))
        (v2:decimal (at 1 values))
        (v3:decimal (at 2 values))
    )
    (format "Current KadenaLiquidIndex is {}; Projected Index is {}, and LiquidStaking holds {} KDA"
        [v1 v2 v3]
    )
)

(print "END STEP 003")
;;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;

;;STEP 004 - Deploy Modules

;; U|CT             ;; 11.134
;; U|G              ;;  2.296
;; U|ST             ;;  4.167
;; U|RS             ;;  1.899
;; U|LST            ;;  7.113
;; U|INT            ;;  3.036
;; U|DEC            ;;  4.584
;; U|DALOS          ;;  8.877
;; U|ATS            ;; 38.152
;; U|DPTF           ;; 10.107
;; U|VST            ;;  6.840
;; TS01-A           ;; 33.202
;; TS01-C1          ;; 80.778
;; TS01-C2          ;;127.604
;; TS01-P           ;; 21.944

;; DPL-DALOS        ;;125.403

;;DALOS INIT
;;STEP 05           ;; 21.069
;;STEP 06           ;; 21.615
;;STEP 07           ;; 40.915
;;STEP 08           ;; 74.180
;;STEP 09           ;; 67.129
;;STEP 10           ;;123.966
;;STEP 11           ;; 23.376
;;STEP 12           ;; 40.302
;;STEP 13           ;; 10.094
;;STEP 14           ;; 46.020
;;STEP 15           ;; 43.686
;;STEP 16           ;;136.822
;;STEP 17           ;;  6.424
;;STEP 18           ;; 25.340
;;STEP 19           ;; 26.898
;;STEP 20           ;; 99.763
;;STEP 21           ;;  6.169
;;STEP 22           ;; 38.739

;;Put GAP on, after Deploy, set to false to set to offline
(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
n_7d40ccda457e374d8eb07b658fd38c282c545038
1234567890123456789012345678901234567890
(let
    (
        (ref-TS01-A:module{TalosStageOne_Admin} TS01-A)
    )
    (ref-TS01-A::DALOS|A_ToggleGAP true)
)

;;Replace A_Step005 with up to 22, and be carefull where input parameters are needed

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(let
    (
        (ref-DPL|DALOS:module{DeployerDalos} DPL-DALOS)
    )
    (ref-DPL|DALOS::A_Step005)
)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(let
    (
        (ref-TS01-C1:module{TalosStageOne_ClientOne} TS01-C1)
        (patron:string "PatronString")
        (account:string "AccountString")
    )
    (ref-TS01-C1::DPTF|C_ClearDispo patron account)
)

;; DPL-AOZ          ;; 61.841

;;AOZ INIT
;;STEP 01           ;;  1.334
;;STEP 02           ;; 30.729
;;STEP 03           ;;111.968
;;STEP 04           ;; 25.986
;;STEP 05           ;; 62.656
;;STEP 06           ;; 57.089
;;STEP 07           ;; 57.290
;;STEP 08           ;;100.915 (less than)
;;STEP 09           ;; 81.113
;;STEP 10           ;; 81.259
;;STEP 11           ;; 81.488
;;STEP 12           ;; 81.615
;;STEP 13           ;; 81.728
;;STEP 14           ;; 25.769
;;STEP 15           ;;121.629
;;STEP 16           ;;121.319
;;STEP 17           ;;121.224
;;STEP 18           ;;122.120
;;STEP 19           ;;121.557
;;STEP 20           ;;121.117

;;Replace A_Step001 with up to 20, and be carefull where input parameters are needed

;;Step 15 to 20, additional input of 250.0
(let
    (
        (ref-DPL|DSP:module{DeployerDispenser} DSP)
    )
    (ref-DPL|DSP::A_Step001)
)

;; DSP              ;; 44.497
;:DISPENSER
;;STEP 01           ;;  3.458
;;STEP 02           ;; 28.495
;;STEP 03           ;; 11.568

;;DailyEmission Stage1
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DSP.A_OuroMinterStageOne)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DSP.A_KosonMinterStageOne_1of3)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DSP.A_KosonMinterStageOne_2of3)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DSP.A_KosonMinterStageOne_3of3)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.GAS_PAYER "" 0 0.0)

[
(n_7d40ccda457e374d8eb07b658fd38c282c545038.ATS.URC_Index "LiquidKadenaIndex-ds4il5rO7vDC")
(n_7d40ccda457e374d8eb07b658fd38c282c545038.ATS.URC_Index "Auryndex-ds4il5rO7vDC")
(n_7d40ccda457e374d8eb07b658fd38c282c545038.ATS.URC_Index "EliteAuryndex-ds4il5rO7vDC")
]

;;Curl
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.ATS|C_Curl
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"    
    "Auryndex-ds4il5rO7vDC"
    "EliteAuryndex-ds4il5rO7vDC"
    "OURO-slLyzPPCo22W"
    8697.0
)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.ATS|C_Curl
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"    
    "Auryndex-ds4il5rO7vDC"
    "EliteAuryndex-ds4il5rO7vDC"
    "OURO-slLyzPPCo22W"
    57527.0
)

;;Transfer
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "OURO-slLyzPPCo22W"
    "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    "Ѻ.Щę7ãŽÓλ4ěПîЭđЮЫAďбQOχnиИДχѺNŽł6ПžιéИąĞuπЙůÞ1ęrПΔżæÍžăζàïαŮŘDzΘ€ЦBGÝŁЭЭςșúÜđŻõËŻκΩÎzŁÇÉΠмłÔÝÖθσ7₱в£μŻzéΘÚĂИüyćťξюWc2И7кςαTnÿЩE3MVTÀεPβafÖôoъBσÂбýжõÞ7ßzŁŞε0âłXâÃЛ"
    25500.0    
    false
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "OURO-slLyzPPCo22W"
    "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    15000.0    
    true
)

;;Treasury Supplz
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
    "ELITEAURYN-slLyzPPCo22W"
    "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
    "AURYN-slLyzPPCo22W"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
)



;Ignis in Tanker (Dalos Account)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
    "IGNIS-slLyzPPCo22W"
    "Σ.W∇ЦwÏξБØnζΦψÕłěîбηжÛśTã∇țâĆã4ЬĚIŽȘØíÕlÛřбΩцμCšιÄиMkλ€УщшàфGřÞыÎäY8È₳BDÏÚmßOozBτòÊŸŹjПкцğ¥щóиś4h4ÑþююqςA9ÆúÛȚβжéÑψéУoЭπÄЩψďşõшżíZtZuψ4ѺËxЖψУÌбЧλüșěđΔjÈt0ΛŽZSÿΞЩŠ"
)

;;Ouro Supply
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_Supply
    "OURO-slLyzPPCo22W"
)

(-
    (floor
        (fold (*) 1.0 
            [
                512.153184167725684759544467
                (n_7d40ccda457e374d8eb07b658fd38c282c545038.ATS.URC_Index "Auryndex-ds4il5rO7vDC")
                (n_7d40ccda457e374d8eb07b658fd38c282c545038.ATS.URC_Index "EliteAuryndex-ds4il5rO7vDC")
            ]
        )
        24
    )
    1368
)

;(n_7d40ccda457e374d8eb07b658fd38c282c545038.DSP.A_OuroMinterStageOne)


(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "OURO-slLyzPPCo22W"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    259479.9656  
    true
)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "OURO-slLyzPPCo22W"
    "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    57517.0
    true
)

;;Vest
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.VST|C_Vest
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    "AURYN-slLyzPPCo22W"
    1.0
    0
    0
    1
)

;;Unvest
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.VST|C_Unvest
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    "V|AURYN-FPqVjgTGl4N8"
    1
)

;;Vest Kosons
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.VST|C_Vest
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.ÅτhGźνΣhςвiàÁĘĚДÏWÉΨTěCÃŒnæi9цéŘQí¢лΞÛIчмfÓeżÜýЯàDÖ5αȚÞVđσγ₱0ęЬÔĄsĄLлKùvåH£ΞMFУûÊyđÜqdŽŚЖsĘъsПÂÔØŹÞŮγŚΣЧ6Ïж¢чPyòлБ14ÚęŃĄåîêтηΛbΦđkûÇĂζsБúĎdŸUЛзÙÂÚJηXťćж¥zщòÁŸRĘ"
    "Ѻ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    "PDKOSON-bmI_Ga4lW_X2"
    50000.0
    0
    157680000
    50
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.VST|C_Vest
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.ÅτhGźνΣhςвiàÁĘĚДÏWÉΨTěCÃŒnæi9цéŘQí¢лΞÛIчмfÓeżÜýЯàDÖ5αȚÞVđσγ₱0ęЬÔĄsĄLлKùvåH£ΞMFУûÊyđÜqdŽŚЖsĘъsПÂÔØŹÞŮγŚΣЧ6Ïж¢чPyòлБ14ÚęŃĄåîêтηΛbΦđkûÇĂζsБúĎdŸUЛзÙÂÚJηXťćж¥zщòÁŸRĘ"
    "Ѻ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    "CAKOSON-bmI_Ga4lW_X2"
    50000.0
    0
    157680000
    50
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.VST|C_Vest
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.ÅτhGźνΣhςвiàÁĘĚДÏWÉΨTěCÃŒnæi9цéŘQí¢лΞÛIчмfÓeżÜýЯàDÖ5αȚÞVđσγ₱0ęЬÔĄsĄLлKùvåH£ΞMFУûÊyđÜqdŽŚЖsĘъsПÂÔØŹÞŮγŚΣЧ6Ïж¢чPyòлБ14ÚęŃĄåîêтηΛbΦđkûÇĂζsБúĎdŸUЛзÙÂÚJηXťćж¥zщòÁŸRĘ"
    "Ѻ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    "PSKOSON-bmI_Ga4lW_X2"
    50000.0
    0
    157680000
    50
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.VST|C_Vest
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.ÅτhGźνΣhςвiàÁĘĚДÏWÉΨTěCÃŒnæi9цéŘQí¢лΞÛIчмfÓeżÜýЯàDÖ5αȚÞVđσγ₱0ęЬÔĄsĄLлKùvåH£ΞMFУûÊyđÜqdŽŚЖsĘъsПÂÔØŹÞŮγŚΣЧ6Ïж¢чPyòлБ14ÚęŃĄåîêтηΛbΦđkûÇĂζsБúĎdŸUЛзÙÂÚJηXťćж¥zщòÁŸRĘ"
    "Ѻ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    "TSKOSON-bmI_Ga4lW_X2"
    50000.0
    0
    157680000
    50
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.VST|C_Vest
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.ÅτhGźνΣhςвiàÁĘĚДÏWÉΨTěCÃŒnæi9цéŘQí¢лΞÛIчмfÓeżÜýЯàDÖ5αȚÞVđσγ₱0ęЬÔĄsĄLлKùvåH£ΞMFУûÊyđÜqdŽŚЖsĘъsПÂÔØŹÞŮγŚΣЧ6Ïж¢чPyòлБ14ÚęŃĄåîêтηΛbΦđkûÇĂζsБúĎdŸUЛзÙÂÚJηXťćж¥zщòÁŸRĘ"
    "Ѻ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    "SDKOSON-bmI_Ga4lW_X2"
    50000.0
    0
    157680000
    50
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.VST|C_Vest
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.ÅτhGźνΣhςвiàÁĘĚДÏWÉΨTěCÃŒnæi9цéŘQí¢лΞÛIчмfÓeżÜýЯàDÖ5αȚÞVđσγ₱0ęЬÔĄsĄLлKùvåH£ΞMFУûÊyđÜqdŽŚЖsĘъsПÂÔØŹÞŮγŚΣЧ6Ïж¢чPyòлБ14ÚęŃĄåîêтηΛbΦđkûÇĂζsБúĎdŸUЛзÙÂÚJηXťćж¥zщòÁŸRĘ"
    "Ѻ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    "BAKOSON-bmI_Ga4lW_X2"
    50000.0
    0
    157680000
    50
)
;;Vest last 3
(n_7d40ccda457e374d8eb07b658fd38c282c545038.ATS.URC_Index "Auryndex-ds4il5rO7vDC")
(n_7d40ccda457e374d8eb07b658fd38c282c545038.ATS.URC_Index "EliteAuryndex-ds4il5rO7vDC")

;;Tried but already exists
(define-keyset "n_7d40ccda457e374d8eb07b658fd38c282c545038.dh_ah-pleb-keyset" (read-keyset "dh_ah-pleb-keyset"))
(describe-keyset "n_7d40ccda457e374d8eb07b658fd38c282c545038.dh_ah-pleb-keyset")

(read-keyset "ks") 

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DALOS|C_DeployStandardAccount
    "Ѻ.ÔlзюĞÞýжůúìЮRПы3эérДÏõÀЬâùèCχżÖtDlÅgБ6яğèιмgnŸŒćçнÎэnÅ5tĐηψìãŮĘΘe¢ЬA₳ΔЛ¢ρЦκĎвÈбe7ÖJΔÏ3șφûηnŤäčúμ£ЧλíĆC₱ëż₳χдYιΔäđAąoĞъØ∇hůτNÔRxgŹŹЫĐ7FςЭ8ΣσвhD3жâó¥ышΨψşψžźëÅôщc"
    (keyset-ref-guard "n_7d40ccda457e374d8eb07b658fd38c282c545038.dh_ah-pleb-keyset")
    "k:1dacecf4d6fb57c68385b1da961f463e8b35275a13dd484f592a8a5a722224ca"
    "9G.5CcaAB1scxhx5BcbpsChFhf9xhlGws8F9jh5axgCJrmve8xdfaaBn14HffLKzFb6uBcKaB8g6phvhgvCgtkmysA8ApxF6kqKwK4Fu2Efx2neannhB66Lf89rsyAHwj5B6Ic6bz1cmCKpzhnuG0j2b9mstlg7yBnfmzIpFKbd0t2h0FE2M8bLDAsgEyiBsbMG0ADJcC2mx1KqLyreBH6pHB1cwcIxvJqr5jkv601ipsw32mnfoyd84M97yxB6v0q8MlBn9m9G3AocfokCHwbkCs20x8cKwKoxFjA8Hh5dDa8iwicmJeABvGD6xylvB6IJnsyknGqcDmFuGCtrDyqD3JmxvcKAwbz32a48MuIaiJad1IFtIs1kGqBIA7gudnl8nA9iE4lq4n15wAjqdLbEfa9zthzHbc52I7ezwHyxxqmEwnuyBmd2HpFiadm6qrl14K0fouo24Ioacab4xq7g03AFEr4KCy9jrb4eDdao1cJocm8y9buAC40iAILs85H8i2cbKoECnjHpK5KmMKfGknIqDf5DkEMEvEKDs4jsn39Bn86e8jIg7e0v62dp"
)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DALOS|C_DeployStandardAccount
    "Ѻ.UřØЭŻíεÇÔĂЪÝξæȘöźѺßXõÕчPŻț7$мαßуeÅEÒÝàSιpbψσ9₳JЧË9иΦpμчЙçκъЦmŻíъEαÒgы43ż2AWR0ńφżi₿íĄψMлæIĘÈĄдÂeиśrЩΓвĆЫo$ΨyЩΔ9żIwSщýкъщфŚ4ΔłÚřŻřůεğćβэDЪÂÉÂ9чøΨΠćýôyíśζыςΓp1αДεЬ"
    (read-keyset "ouronet") 
    "k:af0657cc6cbf6c19ac1c435a9e77f052c26dbb9fd7e746010e11a96b52f7c9ac"
    "9G.6oKnsbgnxjfy4a6u2nBz8jLMll4eB59afrdwFwvElrC92h1D1Iuey627EHJK76DvJ3oL9BjqGLoe84DzMA86n7p03LDjMynp51w9GjHh11i8fCfKtb4av4Le2Jiyfn85mD6rIiLI7cAawjbuoAnytEj7uCtm5KEpx5HIEBvELAmk1kptdtpjdxMrL2LuIv4lhdhq1LJJ3ig9eg15qIJqHwqw3eo5fCssymLoao0b8uiKcooetrDCFjxC2qgfaoshMJw5ql3dMf7MMBEh7cCo1t8M9w7d5piM0Ci29r3nupE1yaiHppfjbhkI9zGdE6D9iAMIC4riisa2382uwc5gFE8regddHnuJw6qn5E2Hf1ymMHds9iCfqd90B2BgmH64Cesg0ywwLxajlKnisCi6cCo4ICL03JIkKBDkM4H0rudyjL0HMFd8t8urlBhMpzyAAEBvhvwcfnxJ7HtbrvgchLMe8LijDA2b2btpxJxGdC1hlDsf42ofxnqnGEfM8phn1z6LiHdMp2diI7hG2hnAIGpE82burFyx9d4E7yskA0Ijxp1wd9sIynzsiano"
)

;;Issue weigthed Pools
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.SWP|C_IssueWeighted
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    [
        { "token-id": "LKDA-slLyzPPCo22W", "token-supply": 4500.0}
        { "token-id": "OURO-slLyzPPCo22W", "token-supply": 60000.0}
        { "token-id": "WKDA-slLyzPPCo22W", "token-supply": 3500.0}
    ]
    2.5
    [0.3 0.5 0.2]
    true
)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.SWP|C_UpdateFee
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "W|LKDA-slLyzPPCo22W|OURO-slLyzPPCo22W|WKDA-slLyzPPCo22W"
    7.5
    false
)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.SWP|C_UpdateSpecialFeeTargets
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "W|LKDA-slLyzPPCo22W|OURO-slLyzPPCo22W|WKDA-slLyzPPCo22W"
    [
        {"target": "Ѻ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ", "value":16}
        {"target": "Ѻ.Щę7ãŽÓλ4ěПîЭđЮЫAďбQOχnиИДχѺNŽł6ПžιéИąĞuπЙůÞ1ęrПΔżæÍžăζàïαŮŘDzΘ€ЦBGÝŁЭЭςșúÜđŻõËŻκΩÎzŁÇÉΠмłÔÝÖθσ7₱в£μŻzéΘÚĂИüyćťξюWc2И7кςαTnÿЩE3MVTÀεPβafÖôoъBσÂбýжõÞ7ßzŁŞε0âłXâÃЛ", "value":32}
        {"target": "Ѻ.CЭΞŸNGúůρhãmИΘÛ¢₳šШдìAÚwŚGýηЗПAÊУÔȘřŽÍζЗηmΔφDmcдΛъ₳tĂýăŮsПÞ$öœGθeBŽvąαÃfçл¢ĎĆď$şbsЦэΘNÄëÍĂνуãöž¥àZjÆůšÁœôñχŽâЩåτâн4μфAOçĎΓuЗŮnøЙãĚè6Дżîþż$цÑûρψŻïZÉλûæřΨeèÎígςeL", "value":16}
    ]
)

(let
    (
        (ea:decimal
            (n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
                "ELITEAURYN-slLyzPPCo22W"
                "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"    
            )
        )
        (ouro:decimal 0.0)
        (ai:decimal (n_7d40ccda457e374d8eb07b658fd38c282c545038.ATS.URC_Index "Auryndex-ds4il5rO7vDC"))
        (eai:decimal (n_7d40ccda457e374d8eb07b658fd38c282c545038.ATS.URC_Index "EliteAuryndex-ds4il5rO7vDC"))
        (pr:decimal (floor (fold (*) 1.0 [ea ai eai]) 24))
        
    )
    (format "Bytales has from {} EA {} Ouro and in total {} OURO"
        [ea pr (+ pr ouro)]
    )
)

[
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
        "OURO-slLyzPPCo22W"
        "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    )
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
        "ELITEAURYN-slLyzPPCo22W"
        "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    )
]

[
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.ATS|C_Curl
        "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
        "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"    
        "Auryndex-ds4il5rO7vDC"
        "EliteAuryndex-ds4il5rO7vDC"
        "OURO-slLyzPPCo22W"
        62000.0
    )
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
        "ELITEAURYN-slLyzPPCo22W"
        "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    )
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
        "OURO-slLyzPPCo22W"
        "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    )
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TFT.URC_MinimumOuro
        "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    )
]

[
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
        "ELITEAURYN-slLyzPPCo22W"
        "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    )
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
        "OURO-slLyzPPCo22W"
        "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    )
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TFT.URC_MinimumOuro
        "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    )
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TFT.URC_VirtualOuro
        "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    )
]

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TFT.URC_VirtualOuro
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
)