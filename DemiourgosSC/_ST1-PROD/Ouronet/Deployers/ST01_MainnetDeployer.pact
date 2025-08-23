(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(length (keys n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.DALOS|AccountTable))
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.GAS_PAYER "" 0 0.0)
;:Disble Ignis Collection
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-A.DALOS|A_IgnisToggle false false)
;;Enable Ignis Collection
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-A.DALOS|A_IgnisToggle false true)
;;
;;Contains Code needed to run when Setting Up Ouronet in Main Kadena Live Net
;;Code is sequenced in Steps, these needed to be run one after another.
;;Once all Steps are run, Ouronet is Live
;;
;;

;;UNWRAP CAPABILITY
(coin.TRANSFER "c:81XjsM008PpbNVk2y91cPt0k7DpWuzWtEE2G8t9VZXY" "k:35d9be77f2a414cd8ce6ed83afd9d53bbdb5ef85723417131225b389a6c9e54f" 1.0)

;;WRAP Capability
(coin.TRANSFER "k:35d9be77f2a414cd8ce6ed83afd9d53bbdb5ef85723417131225b389a6c9e54f" "c:81XjsM008PpbNVk2y91cPt0k7DpWuzWtEE2G8t9VZXY" 35.98973391971)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.LQD|C_WrapKadena 
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    35.98973391971
)

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
(coin.TRANSFER "k:2d4c9cd8d1bd30d9156b65c1259d2be9689f068927d8fee19bfb695619436e01" "c:81XjsM008PpbNVk2y91cPt0k7DpWuzWtEE2G8t9VZXY" 1.0)

"c:81XjsM008PpbNVk2y91cPt0k7DpWuzWtEE2G8t9VZXY"

;;UNWRAP CAPABILITY
(coin.TRANSFER "c:81XjsM008PpbNVk2y91cPt0k7DpWuzWtEE2G8t9VZXY" "k:35d9be77f2a414cd8ce6ed83afd9d53bbdb5ef85723417131225b389a6c9e54f" 1.0)

;;WRAP Capability
(coin.TRANSFER "k:35d9be77f2a414cd8ce6ed83afd9d53bbdb5ef85723417131225b389a6c9e54f" "c:81XjsM008PpbNVk2y91cPt0k7DpWuzWtEE2G8t9VZXY" 35.98973391971)

(coin.TRANSFER "k:2d4c9cd8d1bd30d9156b65c1259d2be9689f068927d8fee19bfb695619436e01" "c:81XjsM008PpbNVk2y91cPt0k7DpWuzWtEE2G8t9VZXY" (n_7d40ccda457e374d8eb07b658fd38c282c545038.MB.URC_TotalMBCost 1))
(coin.TRANSFER "k:2d4c9cd8d1bd30d9156b65c1259d2be9689f068927d8fee19bfb695619436e01" "c:81XjsM008PpbNVk2y91cPt0k7DpWuzWtEE2G8t9VZXY" 10.0)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.GAS_PAYER "" 0 0.0)
;;FIRESTARTER
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.SWP|C_Firestarter
    "Ѻ.ÔlзюĞÞýжůúìЮRПы3эérДÏõÀЬâùèCχżÖtDlÅgБ6яğèιмgnŸŒćçнÎэnÅ5tĐηψìãŮĘΘe¢ЬA₳ΔЛ¢ρЦκĎвÈбe7ÖJΔÏ3șφûηnŤäčúμ£ЧλíĆC₱ëż₳χдYιΔäđAąoĞъØ∇hůτNÔRxgŹŹЫĐ7FςЭ8ΣσвhD3жâó¥ышΨψşψžźëÅôщc"
)


(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038") 
(acquire-module-admin SWP) 
(SWP.P|A_Add 
    "SWPU|RemoteSwpGov"
    (create-capability-guard (SWPU.P|SWPU|REMOTE-GOV)) 
) 
(SWP.SWP|SetGovernor 
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
)
;;==========================
;;
(n_7d40ccda457e374d8eb07b658fd38c282c545038.MB.A_Step01
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
)
;;Payment Capabilities
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.GAS_PAYER "" 0 0.0)
(coin.TRANSFER "k:2d4c9cd8d1bd30d9156b65c1259d2be9689f068927d8fee19bfb695619436e01" "k:2e5ffa38bf42d216f5e5773303250c40ae4a9453cea02bbdb2ae390b0205e2b0" 40.0)
(coin.TRANSFER "k:2d4c9cd8d1bd30d9156b65c1259d2be9689f068927d8fee19bfb695619436e01" "c:EX0XSNfVxsm906AyVouFPXiLZPYObybqBCCtOpbb3HQ"  80.0)
(coin.TRANSFER "k:2d4c9cd8d1bd30d9156b65c1259d2be9689f068927d8fee19bfb695619436e01" "k:1d9909881642d0bdfa39d6ff74165e0e632b6125cb6d772579fb51ac248bf9d8"  120.0)
(coin.TRANSFER "k:2d4c9cd8d1bd30d9156b65c1259d2be9689f068927d8fee19bfb695619436e01" "c:U9gIg2OvVyINjXEGFCkar1OYKLGkdJkOeMtglG4hWeo" 160.0)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.MB.A_ToggleOpenForBusiness true)


(coin.TRANSFER "k:2d4c9cd8d1bd30d9156b65c1259d2be9689f068927d8fee19bfb695619436e01" "c:U9gIg2OvVyINjXEGFCkar1OYKLGkdJkOeMtglG4hWeo" 160.0)
2.573245238404

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
    "Ѻ.0ŤΞAKЛăÁĄαò¥£šÚDΩOg6ρДëΞΓй6QâÞæÇŽÙĐκτãWÊpŘуd6ЫŘØûпσΛЩĐŽÆPςэĂVνпÂLαÜÄÇ₱ψr0ÆáИøÙ$θoŮωIιCĆąPAtNфIÑγÍïξnŠEëpÞLĄÊιÞêWĘuмκпTμisfťÕâýЧδrñWÂ$жщдфœżÊRHδщřηÚĂИ¥€yшѺéŸÔVУæ"
    25500.0    
    false
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "OURO-slLyzPPCo22W"
    "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    65969.926016377959603888   
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


;;Receiver Targets for KDA Transfer Capabilities
(let
    (
        (10p:string (at 2 (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_DemiurgoiID)))
        (20p:string "Σ.W∇ЦwÏξБØnζΦψÕłěîбηжÛśTã∇țâĆã4ЬĚIŽȘØíÕlÛřбΩцμCšιÄиMkλ€УщшàфGřÞыÎäY8È₳BDÏÚmßOozBτòÊŸŹjПкцğ¥щóиś4h4ÑþююqςA9ÆúÛȚβжéÑψéУoЭπÄЩψďşõшżíZtZuψ4ѺËxЖψУÌбЧλüșěđΔjÈt0ΛŽZSÿΞЩŠ")
        (30p:string (at 1 (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_DemiurgoiID)))
        (40p:string "Σ.4M0èÞbøXśαiΠ€NùÇèφqλËãØÓNCнÌπпЬ4γTмыżěуàđЫъмéLUœa₿ĞЬŒѺrËQęíùÅЬ¥τ9£φď6pÙ8ìжôYиșîŻøbğůÞχEшäΞúзêŻöŃЮüŞöućЗßřьяÉżăŹCŸNÅìŸпĐżwüăŞãiÜą1ÃγänğhWg9ĚωG₳R0EùçGΨфχЗLπшhsMτξ")
        (lqs:string "Σ.śκν9₿ŻşYЙΣJΘÊO9jпF₿wŻ¥уPэõΣÑïoγΠθßÙzěŃ∇éÖиțșφΦτşэßιBιśiĘîéòюÚY$êFЬŤØ$868дyβT0ςъëÁwRγПŠτËMĚRПMaäЗэiЪiςΨoÞDŮěŠβLé4čØHπĂŃŻЫΣÀmăĐЗżłÄăiĞ₿йÎEσțłGΛЖΔŞx¥ÁiÙNğÅÌlγ¢ĎwдŃ")
    )
    [
        ;;10% receiver
        (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_AccountKadena 10p)     ;;k:2e5ffa38bf42d216f5e5773303250c40ae4a9453cea02bbdb2ae390b0205e2b0
        ;;20% receiver
        (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_AccountKadena 20p)     ;;c:EX0XSNfVxsm906AyVouFPXiLZPYObybqBCCtOpbb3HQ
        ;;30% receiver
        (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_AccountKadena 30p)     ;;k:1d9909881642d0bdfa39d6ff74165e0e632b6125cb6d772579fb51ac248bf9d8
        ;;40% receiver
        (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_AccountKadena 40p)     ;;c:U9gIg2OvVyINjXEGFCkar1OYKLGkdJkOeMtglG4hWeo
        ;;Wrapping Receiver
        (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_AccountKadena lqs)     ;;c:81XjsM008PpbNVk2y91cPt0k7DpWuzWtEE2G8t9VZXY
    ]
)

;;10%
(coin.TRANSFER 
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_AccountKadena "<Ouronet Standard Account>") 
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_AccountKadena (at 2 (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_DemiurgoiID))) 
    1.0
)
;;20%
(coin.TRANSFER 
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_AccountKadena "<Ouronet Standard Account>") 
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_AccountKadena "Σ.W∇ЦwÏξБØnζΦψÕłěîбηжÛśTã∇țâĆã4ЬĚIŽȘØíÕlÛřбΩцμCšιÄиMkλ€УщшàфGřÞыÎäY8È₳BDÏÚmßOozBτòÊŸŹjПкцğ¥щóиś4h4ÑþююqςA9ÆúÛȚβжéÑψéУoЭπÄЩψďşõшżíZtZuψ4ѺËxЖψУÌбЧλüșěđΔjÈt0ΛŽZSÿΞЩŠ") 
    2.0
)
;;30%
(coin.TRANSFER 
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_AccountKadena "<Ouronet Standard Account>") 
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_AccountKadena (at 1 (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_DemiurgoiID))) 
    3.0
)
;;40%
(coin.TRANSFER 
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_AccountKadena "<Ouronet Standard Account>") 
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS.UR_AccountKadena "Σ.4M0èÞbøXśαiΠ€NùÇèφqλËãØÓNCнÌπпЬ4γTмыżěуàđЫъмéLUœa₿ĞЬŒѺrËQęíùÅЬ¥τ9£φď6pÙ8ìжôYиșîŻøbğůÞχEшäΞúзêŻöŃЮüŞöućЗßřьяÉżăŹCŸNÅìŸпĐżwüăŞãiÜą1ÃγänğhWg9ĚωG₳R0EùçGΨфχЗLπшhsMτξ") 
    4.0
)




(coin.TRANSFER "k:1dacecf4d6fb57c68385b1da961f463e8b35275a13dd484f592a8a5a722224ca" "c:EX0XSNfVxsm906AyVouFPXiLZPYObybqBCCtOpbb3HQ" 400.0)                         ;;20%
(coin.TRANSFER "k:1dacecf4d6fb57c68385b1da961f463e8b35275a13dd484f592a8a5a722224ca" "k:1d9909881642d0bdfa39d6ff74165e0e632b6125cb6d772579fb51ac248bf9d8" 600.0)    ;;30%
(coin.TRANSFER "k:1dacecf4d6fb57c68385b1da961f463e8b35275a13dd484f592a8a5a722224ca" "c:U9gIg2OvVyINjXEGFCkar1OYKLGkdJkOeMtglG4hWeo" 800.0)                         ;;40%

(TS01-C2.SWP|C_AddLiquidity
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "W|LKDA-slLyzPPCo22W|OURO-slLyzPPCo22W|WKDA-slLyzPPCo22W"
    [3600.0 0.0 2800.0]
)
(DPL-UR.URC_0001_Header
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
)


(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(let
    (
        (ouro-a:decimal 0.699654373570670287)
        (auryn-a:decimal 2128.371735198974273291)
        (e-auryn-a:decimal (+ 2000.163661810516387693 3255.991405487361316048068883))
        (ignis-bonus-a:decimal 1000.0)
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (client:string "Ѻ.ÙÉlgЖ2ЦζGČŃчΔ7ÈehĂpУΨΛжXчNøÒäεИbôłξ6σæ₱þğÕнwŸêτńsιφÏþfÏŘÿQθкшμΦgiЗΣωõásŒΦ€ýюĄBнчěþЧαsČÅyȘИöSŁÁVSłßДgNЩиřβÅMΦöÞXšÞbQЫбzĎŮe₿ñÔŚďæğЖžCDìÿ7ÒÆB2knΩúÓcíŮłŸnκΓÒΩBÅĄÂБΣ")
        (standard-treasury:string "Ѻ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ")
        (smart-treasury:string "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ")
        (ouro:string "OURO-slLyzPPCo22W")
        (auryn:string "AURYN-slLyzPPCo22W")
        (e-auryn:string "ELITEAURYN-slLyzPPCo22W")
        (ignis:string "IGNIS-slLyzPPCo22W")
    )
    ;;
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer patron ignis patron smart-treasury ignis-bonus-a true)
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer patron ignis smart-treasury client ignis-bonus-a true)
    ;;
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer patron auryn standard-treasury smart-treasury auryn-a true)
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer patron auryn smart-treasury client auryn-a true)
    ;;
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer patron e-auryn standard-treasury smart-treasury e-auryn-a true)
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer patron e-auryn smart-treasury client e-auryn-a true)
    ;;
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer patron ouro smart-treasury client ouro-a false)
)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")

(let
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (standard-treasury:string "Ѻ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ")
        (smart-treasury:string "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ")
        (auryn:string "AURYN-slLyzPPCo22W")
        (e-auryn:string "ELITEAURYN-slLyzPPCo22W")
        (standard-auryn-amount:decimal (DPTF.UR_AccountSupply auryn standard-treasury))
        (standard-e-auryn-amount:decimal (DPTF.UR_AccountSupply e-auryn standard-treasury))
    )
    ;;
    (DPTF|C_Transfer patron auryn standard-treasury smart-treasury standard-auryn-amount true)
    (DPTF|C_Transfer patron e-auryn standard-treasury smart-treasury standard-e-auryn-amount true)
)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(let
    (
        (ouro-a:decimal (fold (+) 0.0 [1.118369268944905688 1.118]))
        (auryn-a:decimal (fold (+) 0.0 [0.532609777201760467 3.148]))
        (e-auryn-a:decimal (fold (+) 0.0 [11683.71345623554649896 14788.048811860500400586262034 130.618455594495381960865678 515.148232028355659524220165]))
        (ignis-bonus-a:decimal 1000.0)
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (client:string "Ѻ.ÛęфΨÍßø5IиεжѺđΔďÈшηłJńαśΦFeŘŽЫákpçbéŹ4Чă8тĞÁγÎăQιПσÓ∇VÕαCęłÔβΨжxăŹΦßğşpTяуЦÛhBTÇgÆзšü5çêŽÌŤèфȚюÁůqéÊ0RЬЪŤŃZĞøĄŁПł₳Đœ£řXmQSHeßûĄŚÞŒàïîщVвÜkβЖYš9cдБuô45kàkQэИξпβæ")
        ;(standard-treasury:string "Ѻ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ")
        (smart-treasury:string "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ")
        (ouro:string "OURO-slLyzPPCo22W")
        (auryn:string "AURYN-slLyzPPCo22W")
        (e-auryn:string "ELITEAURYN-slLyzPPCo22W")
        (ignis:string "IGNIS-slLyzPPCo22W")
    )
    ;;
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer patron ignis patron smart-treasury ignis-bonus-a true)
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer patron ignis smart-treasury client ignis-bonus-a true)
    ;;
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer patron ouro smart-treasury client ouro-a true)
    ;;
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer patron auryn smart-treasury client auryn-a true)
    ;;
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer patron e-auryn smart-treasury client e-auryn-a true)
    ;;
)

[
    (DPTF.UR_AccountSupply ouro standard-treasury)
    (DPTF.UR_AccountSupply ouro smart-treasury)
    (DPTF.UR_AccountSupply auryn standard-treasury)
    (DPTF.UR_AccountSupply auryn smart-treasury)
    (DPTF.UR_AccountSupply e-auryn standard-treasury)
    (DPTF.UR_AccountSupply e-auryn smart-treasury)
]

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_BulkTransfer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî" 
    "OURO-slLyzPPCo22W"
    "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    [
        
    ]
    (make-list 15 1.0)
)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_MultiBulkTransfer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    [
        "OURO-slLyzPPCo22W"
        "AURYN-slLyzPPCo22W"
        "ELITEAURYN-slLyzPPCo22W"
    ]
    "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    [
        [
        "Ѻ.Áуžж02ÔğyεØγăŻвŤεцćsŹу0Ú€òΨÖΨĂjŃПYnмkšρÁÜΦωwφΦÔ¥юüĄÔíëçîζŒFνCÍlЬмζízłŒGêòPτčjdÍПЦTцÈyBЖj€ÿDЮlȘęŮŽДwĆЮòÒÅ2f1η7ЦËĆëzìчÅτóýGéзĄвîbşкĆÑÕÌЪΞ¢БЗ0μQýěэgŽGŠклЪĄč₿uiΨÆΓÍ"
        "Ѻ.ȚÁ$òßôñПWšπÙvçÉcXЙщjDуłвțfËѺÏeRбдêûüÄuЗ∇Ö₳₱Ж3ΘÞóΔÛЪφэУSØлÈΣβȚцCзμązιDťÈĂτЛмŽRšxy¢WÄťåNβœфÑÌyЧ2sθβŞŸЫĚδČgÓ$RMиUЪźMËÀя9ÙγwØнÂцąя7BŮÂ9χHΘDιžβ3ПÝÍąÜÖжεìςKëδïȘmýEЮżм"
        "Ѻ.VIлáпøàğβÇáÕζ₱ßŸvĞaŁλŠȚæŠßĄñ¥ΦvîÿЧÊ7юΘŸдĆÁÔYлk8ûCÖΣЫÕŚкÃÒPČΞńźΣΦ9ÅĄȚΦń3QØcÃÉRđÚKůшûžßДâTΓ0ÀÜядCoČżòφ5œ5σòÇĎÇĎwвцzùпйтSγдřńÜЯÜxYтŹÜëqЙÑŒÒмςÞμÄÛPèŁ5ŮtkAiPoП2ΦřÈЗ3"
        "Ѻ.ůćSØťξçřVÎЙïИW₿YeHйťçкÌÿнŃηèŽЪ¥лfđЧÁÕ3ęЛöц₿ΘИÆĐâЫAř€łιÈŻ∇τŘNΩď¢øöÁťLЮWqŞ0₱đЖ₳tчĚaμЫÞŽÅÒęëzČśçõÖыÏŻЪю30qpΔZσĆÖÀχcôσU₱şÿšTΨjÀωHцĚШΔØÖuŤÍ¢ÆèŤþÁĞńεÈÏŁŸaXêÃφôΣVjşßgA"
        "Ѻ.yaCДψζνкΠфXżoдĂærIœđóÓøRČsΩÖRșědșθQдÞ7ÅțŁαUÛfтЭůццòŸĆÊΔcЪkTBčaHЭ£LĄ∇FcбùσăünΠåö8JeÖaЛ¢ИŘÞćåœюûȚДζÁš5TĞξ6ρÔЮØã£â8úйthĂŚďşZѺэШвиTřŘvЮQûńУôцwЧSââ8ζчùπćèîRèřiъfлЪÈă"
        "Ѻ.ÇñLŁ€pmœöĐWĂΓБñвíûζαβçŸ¢ETΛĆUтȚΛrFĆØĆξЪп1HěńÚяŹĂ7ζoãЦЩЭЯ₳îÀýJξÙу5юĘȘĂγ9ΩżδéÅęŘЬŽÕĄrëĎЮ₱ÂЦĞψИďâOuć0CżîιIđrÉĄςτYъ$1ìíΣJъjÖğлιÀÄνЧdËЬ$FìÀÅřνòÙфUöÄqEZЩ¢ßØÝÑÆè1õιйñΓ"
        "Ѻ.łfЮêγωćgMŠЧbτЧuÁwмÇńŮыÛИđŸφãЖŤčvĐØLD£ΩńOÔηȚÑпŮťSэbЧgaJëĘRлσöEOв$ŁÔfșË$жNЪЗŸληćVIй$8nΣξń₱ŞŮyB$ÂρgliÇΛ7ŚmüγεвÀÎțRΦуэÞΩáVEяÿŠ$șòтΠpĚΛÁàPŤζFИЬΓâбğœhtmÛΘλιÌΘåБwÞ∇Δcą"
        "Ѻ.ъбąRдqμζøþśĘĐÅДьöщн4ÚÔFòŞå2α£mhΦÁ6ZȘfČZρэЩΘιЗJ7ЖŁ₳69£ânğΩÊÏïñŚvÉtgБBÃșЩБìììфλëΩAïWmaFFVþ$źźSêρQQкѺæρĞюεGîGşđдПȘșψEźβΩT3ìтŚкř£жÖП8ăąźÎξů4ŸЮΩB₳šÝЙ∇řÇwíčăb4₱ďĚOςÉм"
        ]
        [
        "Ѻ.VIлáпøàğβÇáÕζ₱ßŸvĞaŁλŠȚæŠßĄñ¥ΦvîÿЧÊ7юΘŸдĆÁÔYлk8ûCÖΣЫÕŚкÃÒPČΞńźΣΦ9ÅĄȚΦń3QØcÃÉRđÚKůшûžßДâTΓ0ÀÜядCoČżòφ5œ5σòÇĎÇĎwвцzùпйтSγдřńÜЯÜxYтŹÜëqЙÑŒÒмςÞμÄÛPèŁ5ŮtkAiPoП2ΦřÈЗ3"
        "Ѻ.ůćSØťξçřVÎЙïИW₿YeHйťçкÌÿнŃηèŽЪ¥лfđЧÁÕ3ęЛöц₿ΘИÆĐâЫAř€łιÈŻ∇τŘNΩď¢øöÁťLЮWqŞ0₱đЖ₳tчĚaμЫÞŽÅÒęëzČśçõÖыÏŻЪю30qpΔZσĆÖÀχcôσU₱şÿšTΨjÀωHцĚШΔØÖuŤÍ¢ÆèŤþÁĞńεÈÏŁŸaXêÃφôΣVjşßgA"
        "Ѻ.yaCДψζνкΠфXżoдĂærIœđóÓøRČsΩÖRșědșθQдÞ7ÅțŁαUÛfтЭůццòŸĆÊΔcЪkTBčaHЭ£LĄ∇FcбùσăünΠåö8JeÖaЛ¢ИŘÞćåœюûȚДζÁš5TĞξ6ρÔЮØã£â8úйthĂŚďşZѺэШвиTřŘvЮQûńУôцwЧSââ8ζчùπćèîRèřiъfлЪÈă"
        "Ѻ.ÇñLŁ€pmœöĐWĂΓБñвíûζαβçŸ¢ETΛĆUтȚΛrFĆØĆξЪп1HěńÚяŹĂ7ζoãЦЩЭЯ₳îÀýJξÙу5юĘȘĂγ9ΩżδéÅęŘЬŽÕĄrëĎЮ₱ÂЦĞψИďâOuć0CżîιIđrÉĄςτYъ$1ìíΣJъjÖğлιÀÄνЧdËЬ$FìÀÅřνòÙфUöÄqEZЩ¢ßØÝÑÆè1õιйñΓ"
        "Ѻ.ъбąRдqμζøþśĘĐÅДьöщн4ÚÔFòŞå2α£mhΦÁ6ZȘfČZρэЩΘιЗJ7ЖŁ₳69£ânğΩÊÏïñŚvÉtgБBÃșЩБìììфλëΩAïWmaFFVþ$źźSêρQQкѺæρĞюεGîGşđдПȘșψEźβΩT3ìтŚкř£жÖП8ăąźÎξů4ŸЮΩB₳šÝЙ∇řÇwíčăb4₱ďĚOςÉм"
        "Ѻ.âΛλШXρлÿИτüĄĎÍòπLRœnÍβîroяqbцjÀxłйœЮuÊУhÅпуçвbΓρȚжyčIĐáùH7íšьyτйÄκмΓQxŮγè0ÍΨΠúpdŒúcØП0ЫшûfȚѺęđnteòźŁμüηoΨ€ÀъÛÿ1ÌöÛùÁc∇ПźщΓÙKэĄйĐğÈÔÄĐěì5зäÆsQćŚμлÒη₳đ8νБŞŞ9ÁìĚΨZ"
        ]
        [
        "Ѻ.yaCДψζνкΠфXżoдĂærIœđóÓøRČsΩÖRșědșθQдÞ7ÅțŁαUÛfтЭůццòŸĆÊΔcЪkTBčaHЭ£LĄ∇FcбùσăünΠåö8JeÖaЛ¢ИŘÞćåœюûȚДζÁš5TĞξ6ρÔЮØã£â8úйthĂŚďşZѺэШвиTřŘvЮQûńУôцwЧSââ8ζчùπćèîRèřiъfлЪÈă"    
        "Ѻ.ÇñLŁ€pmœöĐWĂΓБñвíûζαβçŸ¢ETΛĆUтȚΛrFĆØĆξЪп1HěńÚяŹĂ7ζoãЦЩЭЯ₳îÀýJξÙу5юĘȘĂγ9ΩżδéÅęŘЬŽÕĄrëĎЮ₱ÂЦĞψИďâOuć0CżîιIđrÉĄςτYъ$1ìíΣJъjÖğлιÀÄνЧdËЬ$FìÀÅřνòÙфUöÄqEZЩ¢ßØÝÑÆè1õιйñΓ"
        "Ѻ.łfЮêγωćgMŠЧbτЧuÁwмÇńŮыÛИđŸφãЖŤčvĐØLD£ΩńOÔηȚÑпŮťSэbЧgaJëĘRлσöEOв$ŁÔfșË$жNЪЗŸληćVIй$8nΣξń₱ŞŮyB$ÂρgliÇΛ7ŚmüγεвÀÎțRΦуэÞΩáVEяÿŠ$șòтΠpĚΛÁàPŤζFИЬΓâбğœhtmÛΘλιÌΘåБwÞ∇Δcą"
        ]
    ]
    [
        (make-list 8 1.0)
        (make-list 6 1.0)
        (make-list 3 1.0)
    ]
)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_MultiBulkTransfer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    [
        "OURO-slLyzPPCo22W"
        "AURYN-slLyzPPCo22W"
        "ELITEAURYN-slLyzPPCo22W"
    ]
    "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    [
        [
        "Ѻ.ч0ĂãÝŤÑîšβ6çĄŻůcÃÒUу0ÚYŹŁèźιOÞHЫëùpŃñÏбэBκыvęäИđýωïαщЭÀřjΘŁЮкĆIßÊπŮдĞbÏΛÖИΓůIяБĂŤÆþΨŞøЮđγșr7iÂìÅlôŚÝŚÀØmπ∇¥УmŁэΩÎЛЗβфÌ₿Ş4aνOÍàцÆ¥БЙagÓïшpđэŤЫùЗςŚЧÙæ∇oqžQθьřłĄιw"
        ]
        [
        "Ѻ.ч0ĂãÝŤÑîšβ6çĄŻůcÃÒUу0ÚYŹŁèźιOÞHЫëùpŃñÏбэBκыvęäИđýωïαщЭÀřjΘŁЮкĆIßÊπŮдĞbÏΛÖИΓůIяБĂŤÆþΨŞøЮđγșr7iÂìÅlôŚÝŚÀØmπ∇¥УmŁэΩÎЛЗβфÌ₿Ş4aνOÍàцÆ¥БЙagÓïшpđэŤЫùЗςŚЧÙæ∇oqžQθьřłĄιw"
        ]
        [
        "Ѻ.ч0ĂãÝŤÑîšβ6çĄŻůcÃÒUу0ÚYŹŁèźιOÞHЫëùpŃñÏбэBκыvęäИđýωïαщЭÀřjΘŁЮкĆIßÊπŮдĞbÏΛÖИΓůIяБĂŤÆþΨŞøЮđγșr7iÂìÅlôŚÝŚÀØmπ∇¥УmŁэΩÎЛЗβфÌ₿Ş4aνOÍàцÆ¥БЙagÓïшpđэŤЫùЗςŚЧÙæ∇oqžQθьřłĄιw"
        ]
    ]
    [
        150.0
        250.0
        500.0
    ]
)

[
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
        "OURO-slLyzPPCo22W"
        "Ѻ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    )
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
        "OURO-slLyzPPCo22W"
        "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    )
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
        "AURYN-slLyzPPCo22W"
        "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    )
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.DPTF.UR_AccountSupply
        "ELITEAURYN-slLyzPPCo22W"
        "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    )
]


;;Payload Data
{
    "dh_ah-keyset": {
        "keys": [
            "35d9be77f2a414cd8ce6ed83afd9d53bbdb5ef85723417131225b389a6c9e54f",
            "2dd5ae3dd78493f468d2f99e36fe4e1a39002cd26196e472ff47f50adb577cb5"
        ],
        "pred": "keys-any"
    },
    "dh_master-keyset": {
        "keys": [
            "35d7f82a7754d10fc1128d199aadb51cb1461f0eb52f4fa89790a44434f12ed8",
            "625ad78ab8c1df826d69e1f0e6457334b8e085b7d256d10be41726ced17fdf74"
        ],
        "pred": "keys-any"
    },
    "dh_sc_dhvault-keyset": {
        "keys": [
            "013b30abebdae21d5afd6e2d5b6486f6fae2b5aa6d8495a2aa3131ab8d292836",
            "d80ff2efd92ebbf9ca367b4985952c2955e85f9e706bcb0745b2e0492dfe3af3"
        ],
        "pred": "keys-any"
    },
    "dh_sc_dispenser-keyset": {
        "keys": [
            "05654aee733a30bfdc2fd36461276c74e3a8a52b9065cc01bc2f1c947d3d8fab",
            "263202ccaad0b917426286afa15f258143a904512139a970257ed4a5d24c1394",
            "ca3cff28ea3c3d80a0ac2801ecab0320b7dbf6545ea0ab5b6e8dcacc72787af8",
            "c2ccc05fa2eab6c6c32b01a0a110aff600bebb16392926a4cfffcb5dfb126ee9",
            "d303cd666c3a1105958c1e0d35c48c20c928d5e45c7d0a2d16a6ba839a40ef23",
            "b48fdcbe39294fd6d97eb548689b28588ea1ad6fae3f19f6327164ef21e68645",
            "1b440c72007c81f3b2659067d61f95035c53a60dc2ae7a5ea8979d6b6d9fa009",
            "bca20d83e88ea7918b2b8b3244da50c7020d612e3c52a28fa808656f66a290e1",
            "e4243cba743d86521fbd292ede863d7e866bd90e00d35e6188c38a26127d1254",
            "60bb284698c72e0be439b2a125dc7566408ac80a342f0f36342ba06f3897e719",
            "86d2e874d76099adec26ec87b954d5ca30b147df236c785840bfebd7506c70d1",
            "fdbaf985f034e13961fc48c54849040d586225dac1889e6041d1847442b50e7c",
            "9cd8abd3beae75e9b8f9a8913b5bebefed0dddc96e4eb8aafe3054225e243ede"
        ],
        "pred": "keys-any"
    },
    "dh_sc_ouroboros-keyset": {
        "keys": [
            "1f6398b1f501992a470efc27707c1b3980f55e602d79755ccdd87afc2b7f03ee",
            "428a0ed942d266d84e6bf995d1612c009777eda858e92c0c9bc3ef8932d4e44d"
        ],
        "pred": "keys-any"
    },
    "us-0000_aozt-keyset": {
        "keys": [
            "2cdc20de30022f52756a6077077eb2e5cb23fd942d4107f8845345d510ca25df",
            "ad620c6759112c10a26519cc4e9a440721c04f1684f3c123f670d1c51f4bb4df"
        ],
        "pred": "keys-any"
    },
    "dh_ah-pleb-keyset": {
        "keys": [
            "45b2f2b7088264e432a42a57e27ec11a17fa33e5c3637c4911f312a74386a0c9",
            "3a7c4c0fe8d2bfa68497f569cc33ef821511ec017c151c35f046ed504649d477"
        ],
        "pred": "keys-any"
    },
    "dh_sc_dpdc-keyset": {
        "keys": [
            "6c95ec3c3c30cb1c1842955c17f7d3a80c454c8cddb588e154e0166f90f354f1",
            "5329770bb45912546454852cea64d468e60460a69cdea83e9f4cc0e2b368fa20"
        ],
        "pred": "keys-any"
    },
    "dh_sc_vesting-keyset": {
        "keys": [
            "10e05871c5a2ef3f0f7dca9edd8e96e4ef0952175a4a2621895d2c4402a7b56a",
            "5047d039d1d918e3489f42a52a46b54cb5b3b259e42dd2e43c071fe2b77863f2"
        ],
        "pred": "keys-any"
    },
    "dh_sc_custodians-keyset": {
        "keys": [
            "45b2f2b7088264e432a42a57e27ec11a17fa33e5c3637c4911f312a74386a0c9",
            "5a082d160fd3fcb61f168ccfd78b19443880fb9d1952bc9bd6d289db1ad4075d"
        ],
        "pred": "keys-any"
    },
    "dh_sc_autostake-keyset": {
        "keys": [
            "1a4e15d3c51e0b73e92644600487ba8eaae312e1a178b91801d54e13c1b350a5",
            "725d6ad18c7e4ef6e2773f6bb315bde13437872d0235f6404c0c99d9d900bbb4"
        ],
        "pred": "keys-any"
    },
    "us-0002_lumy-keyset": {
        "keys": [
            "c4f10bb533db3690ce86e27102dc9b98907c8a83786ca16a727c9a8ebfbe716c",
            "2df04179bfcddf22dd3d79c7d4afd9651e5f8e2a9dfbb8ba6fd9e77e2b432710"
        ],
        "pred": "keys-any"
    },
    "dh_sc_swapper-keyset": {
        "keys": [
            "d80ff2efd92ebbf9ca367b4985952c2955e85f9e706bcb0745b2e0492dfe3af3",
            "572bd2e1a7e126c1072d328bbac3064ffadf96cc20fd0752f1c5875d549c2b31"
        ],
        "pred": "keys-any"
    },
    "dh_sc_dalos-keyset": {
        "keys": [
            "625ad78ab8c1df826d69e1f0e6457334b8e085b7d256d10be41726ced17fdf74",
            "10b998049806491ec3e26f7507020554441e6b9271cfee1779d85230139c92df"
        ],
        "pred": "keys-any"
    },
    "us-0001_emma-keyset": {
        "keys": [
            "9ea91a7a6af95159274f7950763b3bc2f82c00e79d41b94063a8ef1f42327246",
            "08786a657018b620ffce173a2071f85135ed9f4d7a67938a34b8d72f5c0763b1"
        ],
        "pred": "keys-any"
    },
    "dh_sc_kadenaliquidstaking-keyset": {
        "keys": [
            "b836c5c6b989d97737c954934c24686b876b78082bd03475878c245794d6ef80",
            "6a084a59d1485b4b41661ec05be6ebe9475f1fe1a19ba77018b9d176927611c9"
        ],
        "pred": "keys-any"
    }
}

(DALOS|C_RotateKadena)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(acquire-module-admin n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS)
(let
    (
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
        (k10:string "dh_sc_dpdc-keyset")
        ;;Demiurgoi Keys
        (k11:string "dh_ah-keyset")
        (k12:string "dh_ah-pleb-keyset")
        ;;User Keys
        (k13:string "us-0000_aozt-keyset")
        (k14:string "us-0001_emma-keyset")
        (k15:string "us-0002_lumy-keyset")
        ;;
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (ats:string "Σ.ëŤΦșźUÉM89ŹïuÆÒÕ£żíëцΘЯнŹÿxжöwΨ¥Пууhďíπ₱nιrŹÅöыыidõd7ì₿ипΛДĎĎйĄшΛŁPMȘïõμîμŻIцЖljÃαbäЗŸÖéÂЫèpAДuÿPσ8ÎoŃЮнsŤΞìтČ₿Ñ8üĞÕPșчÌșÄG∇MZĂÒЖь₿ØDCПãńΛЬõŞŤЙšÒŸПĘЛΠws9€ΦуêÈŽŻ")
        (vst:string "Σ.şZïζhЛßdяźπПЧDΞZülΦпφßΣитœŸ4ó¥ĘкÌЦ₱₱AÚюłćβρèЬÍŠęgĎwтäъνFf9źdûъtJCλúp₿ÌнË₿₱éåÔŽvCOŠŃpÚKюρЙΣΩìsΞτWpÙŠŹЩпÅθÝØpтŮыØșþшу6GтÃêŮĞбžŠΠŞWĆLτЙđнòZЫÏJÿыжU6ŽкЫVσ€ьqθtÙѺSô€χ")
        (swp:string "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ")
        (dhvault:string "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ")
        (custodians:string "Σ.Щę7ãŽÓλ4ěПîЭđЮЫAďбQOχnиИДχѺNŽł6ПžιéИąĞuπЙůÞ1ęrПΔżæÍžăζàïαŮŘDzΘ€ЦBGÝŁЭЭςșúÜđŻõËŻκΩÎzŁÇÉΠмłÔÝÖθσ7₱в£μŻzéΘÚĂИüyćťξюWc2И7кςαTnÿЩE3MVTÀεPβafÖôoъBσÂбýжõÞ7ßzŁŞε0âłXâÃЛ")
        (dsp:string "Σ.hÜ5ĞÊÜεŞΓõè1Ă₳äàÄìãÓЦφLÕзЯŮμĞ₿мK6àŘуVćχδдзηφыβэÎχUHRêγBğΛ∇VŒižďЬШ£îOÜøE4ÖFSõЩЩAłκè1ččΨΦŻЖэч6Iчη₱ØćнúŒψУćÀyпãЗцÚäδÏÍtςřïçγț6γÎęôigFzÝûηы₿ÏЬüБэΞčмŃт₳ŘчjζsŠȚHъĘïЦ0")
        (dpdc:string "Σ.μЖâAáпδÃàźфнMAŸôIÌjȘЛδεЬÍБЮoзξ4κΩøΠÒçѺłœщÌĘчoãueUøVlßHšδLτε£σž£ЙLÛòCÎcďьčfğÅηвČïnÊвÞIwÇÝмÉŠвRмWć5íЮzGWYвьżΨπûEÃdйdGЫŁŤČçПχĘŚślьЙŤğLУ0SýЭψȘÔÜнìÆkČѺȘÍÍΛ4шεнÄtИςȘ4")
        (dhvault-n:string (+ "Ѻ" (drop 1 dhvault)))
        (custodians-n:string (+ "Ѻ" (drop 1 custodians)))
        (dsp-n:string (+ "Ѻ" (drop 1 dsp)))
        (ah-pleb:string "Ѻ.ÔlзюĞÞýжůúìЮRПы3эérДÏõÀЬâùèCχżÖtDlÅgБ6яğèιмgnŸŒćçнÎэnÅ5tĐηψìãŮĘΘe¢ЬA₳ΔЛ¢ρЦκĎвÈбe7ÖJΔÏ3șφûηnŤäčúμ£ЧλíĆC₱ëż₳χдYιΔäđAąoĞъØ∇hůτNÔRxgŹŹЫĐ7FςЭ8ΣσвhD3жâó¥ышΨψşψžźëÅôщc")
        (aoz:string "Ѻ.ÅτhGźνΣhςвiàÁĘĚДÏWÉΨTěCÃŒnæi9цéŘQí¢лΞÛIчмfÓeżÜýЯàDÖ5αȚÞVđσγ₱0ęЬÔĄsĄLлKùvåH£ΞMFУûÊyđÜqdŽŚЖsĘъsПÂÔØŹÞŮγŚΣЧ6Ïж¢чPyòлБ14ÚęŃĄåîêтηΛbΦđkûÇĂζsБúĎdŸUЛзÙÂÚJηXťćж¥zщòÁŸRĘ")
        (emma:string "Ѻ.A0ěьπΨтÎșπЦĐđŽ6ЫêÀεÅĐȘдÞЩ4Ł2ďй5žömiτsλÚÇдěÒaV₱ÏûιЩД₳îJÍşыyÜŹżęìvAЙsÄ¢ÿnΦIťQůЮ7ĄвaèďíoáнõÎLJθÆEáПiXÿÒÀĘ14цU1çΞêSťüIψчèι₱ê9ŽчΓüЦrÀÓμĆ99κQťqPÖшŮ1ÈČSĐŁÌбÝàŞbPσŃĎ8ĄW")
        (lumy:string "Ѻ.œâσzüştŒhłσćØTöõúoвþçЧлρËШđюλ2ÙPeжŘťȚŤtθËûrólþŘß₿øuŁdáNÎČȘřΦĘbχλΩĄ¢ц2ŹθõĐLcÑÁäăå₿ξЭжулxòΘηĂœŞÝUËcω∇ß$ωoñД7θÁяЯéEU¢CЮxÃэJĘčÎΠ£αöŮЖбlćшbăÙЦÎAдŃЭб$ĞцFδŃËúHãjÁÝàĘSt")
    )
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
    ;;
    (define-keyset (+ ons k11) (read-keyset k11))
    (define-keyset (+ ons k12) (read-keyset k12))

    (define-keyset (+ ons k13) (read-keyset k13))
    (define-keyset (+ ons k14) (read-keyset k14))
    (define-keyset (+ ons k15) (read-keyset k15))
    ;;
    (with-capability (DALOS.SECURE)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ico0:object{OuronetDalosV3.OutputCumulatorV2}
                    (ref-DALOS::C_RotateKadena ats "k:10e05871c5a2ef3f0f7dca9edd8e96e4ef0952175a4a2621895d2c4402a7b56a")
                )
                (ico1:object{OuronetDalosV3.OutputCumulatorV2}
                    (ref-DALOS::C_RotateKadena patron vst "k:1a4e15d3c51e0b73e92644600487ba8eaae312e1a178b91801d54e13c1b350a5")
                )
                (ico2:object{OuronetDalosV3.OutputCumulatorV2}
                    (ref-DALOS::C_RotateKadena swp "k:1f6398b1f501992a470efc27707c1b3980f55e602d79755ccdd87afc2b7f03ee")
                )
                (ico3:object{OuronetDalosV3.OutputCumulatorV2}
                    (ref-DALOS::C_RotateKadena dhvault "k:d80ff2efd92ebbf9ca367b4985952c2955e85f9e706bcb0745b2e0492dfe3af3")
                )
                (ico4:object{OuronetDalosV3.OutputCumulatorV2}
                    (ref-DALOS::C_RotateKadena custodians "k:41cf258202856ffd66858e13c9bda0e1399ed6b40f67140c975d44b6afa3a039")
                )
                (ico5:object{OuronetDalosV3.OutputCumulatorV2}
                    (ref-DALOS::C_RotateKadena dsp "k:45b2f2b7088264e432a42a57e27ec11a17fa33e5c3637c4911f312a74386a0c9")
                )
                (ico6:object{OuronetDalosV3.OutputCumulatorV2}
                    (ref-DALOS::C_RotateKadena dpdc "k:b836c5c6b989d97737c954934c24686b876b78082bd03475878c245794d6ef80")
                )
                (ico7:object{OuronetDalosV3.OutputCumulatorV2}
                    (ref-DALOS::C_RotateKadena dhvault-n "k:d80ff2efd92ebbf9ca367b4985952c2955e85f9e706bcb0745b2e0492dfe3af3")
                )
                (ico8:object{OuronetDalosV3.OutputCumulatorV2}
                    (ref-DALOS::C_RotateKadena custodians-n "k:41cf258202856ffd66858e13c9bda0e1399ed6b40f67140c975d44b6afa3a039")
                )
                (ico9:object{OuronetDalosV3.OutputCumulatorV2}
                    (ref-DALOS::C_RotateKadena dsp-n "k:45b2f2b7088264e432a42a57e27ec11a17fa33e5c3637c4911f312a74386a0c9")
                )
                (ico10:object{OuronetDalosV3.OutputCumulatorV2}
                    (ref-DALOS::C_RotateKadena ah-pleb "k:11cd20672e0b414864b3b55f81f3980a74a021928c80b607d9e678043b34da80")
                )
                (ico11:object{OuronetDalosV3.OutputCumulatorV2}
                    (ref-DALOS::C_RotateKadena patron "k:35d9be77f2a414cd8ce6ed83afd9d53bbdb5ef85723417131225b389a6c9e54f")
                )
                (ico12:object{OuronetDalosV3.OutputCumulatorV2}
                    (ref-DALOS::C_RotateKadena aoz "k:cc68ca8410bf580323937b323b389ad5664e304e7aabb3df4a2ecd7cab40c38d")
                )
                (ico13:object{OuronetDalosV3.OutputCumulatorV2}
                    (ref-DALOS::C_RotateKadena emma "k:2cc72ef06136150f52c01dcc3a135dbd03e5328fafd71442a933619b9337456c")
                )
                (ico14:object{OuronetDalosV3.OutputCumulatorV2}
                    (ref-DALOS::C_RotateKadena lumy "k:afa4d5ec4f1070e58badaac237fbf16c19c0b08dd4b981b3e91937943714138d")
                )
            )
            (ref-DALOS::IGNIS|C_Collect patron
                (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 
                    [ico0 ico1 ico2 ico3 ico4 ico5 ico6 ico7 ico8 ico9 ico10 ico11 ico12 ico13 ico14] []
                )
            )
        )
    )
)
(with-capability (DALOS.SECURE)
    (DALOS.IGNIS|C_Collect 
        "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
        (DALOS.UDC_ConcatenateOutputCumulatorsV2 
            [
                (DALOS.C_RotateKadena "Σ.ëŤΦșźUÉM89ŹïuÆÒÕ£żíëцΘЯнŹÿxжöwΨ¥Пууhďíπ₱nιrŹÅöыыidõd7ì₿ипΛДĎĎйĄшΛŁPMȘïõμîμŻIцЖljÃαbäЗŸÖéÂЫèpAДuÿPσ8ÎoŃЮнsŤΞìтČ₿Ñ8üĞÕPșчÌșÄG∇MZĂÒЖь₿ØDCПãńΛЬõŞŤЙšÒŸПĘЛΠws9€ΦуêÈŽŻ" "k:10e05871c5a2ef3f0f7dca9edd8e96e4ef0952175a4a2621895d2c4402a7b56a")
            ]
            []
        )
    )
)
(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(acquire-module-admin n_7d40ccda457e374d8eb07b658fd38c282c545038.DALOS)
(with-capability (DALOS.SECURE)
    (let
        (
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
            (k10:string "dh_sc_dpdc-keyset")
            ;;Demiurgoi Keys
            (k11:string "dh_ah-keyset")
            (k12:string "dh_ah-pleb-keyset")
            ;;User Keys
            (k13:string "us-0000_aozt-keyset")
            (k14:string "us-0001_emma-keyset")
            (k15:string "us-0002_lumy-keyset")
            ;;
            (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
            (ats:string "Σ.ëŤΦșźUÉM89ŹïuÆÒÕ£żíëцΘЯнŹÿxжöwΨ¥Пууhďíπ₱nιrŹÅöыыidõd7ì₿ипΛДĎĎйĄшΛŁPMȘïõμîμŻIцЖljÃαbäЗŸÖéÂЫèpAДuÿPσ8ÎoŃЮнsŤΞìтČ₿Ñ8üĞÕPșчÌșÄG∇MZĂÒЖь₿ØDCПãńΛЬõŞŤЙšÒŸПĘЛΠws9€ΦуêÈŽŻ")
            (vst:string "Σ.şZïζhЛßdяźπПЧDΞZülΦпφßΣитœŸ4ó¥ĘкÌЦ₱₱AÚюłćβρèЬÍŠęgĎwтäъνFf9źdûъtJCλúp₿ÌнË₿₱éåÔŽvCOŠŃpÚKюρЙΣΩìsΞτWpÙŠŹЩпÅθÝØpтŮыØșþшу6GтÃêŮĞбžŠΠŞWĆLτЙđнòZЫÏJÿыжU6ŽкЫVσ€ьqθtÙѺSô€χ")
            (swp:string "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ")
            (dhvault:string "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ")
            (custodians:string "Σ.Щę7ãŽÓλ4ěПîЭđЮЫAďбQOχnиИДχѺNŽł6ПžιéИąĞuπЙůÞ1ęrПΔżæÍžăζàïαŮŘDzΘ€ЦBGÝŁЭЭςșúÜđŻõËŻκΩÎzŁÇÉΠмłÔÝÖθσ7₱в£μŻzéΘÚĂИüyćťξюWc2И7кςαTnÿЩE3MVTÀεPβafÖôoъBσÂбýжõÞ7ßzŁŞε0âłXâÃЛ")
            (dsp:string "Σ.hÜ5ĞÊÜεŞΓõè1Ă₳äàÄìãÓЦφLÕзЯŮμĞ₿мK6àŘуVćχδдзηφыβэÎχUHRêγBğΛ∇VŒižďЬШ£îOÜøE4ÖFSõЩЩAłκè1ččΨΦŻЖэч6Iчη₱ØćнúŒψУćÀyпãЗцÚäδÏÍtςřïçγț6γÎęôigFzÝûηы₿ÏЬüБэΞčмŃт₳ŘчjζsŠȚHъĘïЦ0")
            (dpdc:string "Σ.μЖâAáпδÃàźфнMAŸôIÌjȘЛδεЬÍБЮoзξ4κΩøΠÒçѺłœщÌĘчoãueUøVlßHšδLτε£σž£ЙLÛòCÎcďьčfğÅηвČïnÊвÞIwÇÝмÉŠвRмWć5íЮzGWYвьżΨπûEÃdйdGЫŁŤČçПχĘŚślьЙŤğLУ0SýЭψȘÔÜнìÆkČѺȘÍÍΛ4шεнÄtИςȘ4")
            (dhvault-n:string (+ "Ѻ" (drop 1 dhvault)))
            (custodians-n:string (+ "Ѻ" (drop 1 custodians)))
            (dsp-n:string (+ "Ѻ" (drop 1 dsp)))
            (ah-pleb:string "Ѻ.ÔlзюĞÞýжůúìЮRПы3эérДÏõÀЬâùèCχżÖtDlÅgБ6яğèιмgnŸŒćçнÎэnÅ5tĐηψìãŮĘΘe¢ЬA₳ΔЛ¢ρЦκĎвÈбe7ÖJΔÏ3șφûηnŤäčúμ£ЧλíĆC₱ëż₳χдYιΔäđAąoĞъØ∇hůτNÔRxgŹŹЫĐ7FςЭ8ΣσвhD3жâó¥ышΨψşψžźëÅôщc")
            (aoz:string "Ѻ.ÅτhGźνΣhςвiàÁĘĚДÏWÉΨTěCÃŒnæi9цéŘQí¢лΞÛIчмfÓeżÜýЯàDÖ5αȚÞVđσγ₱0ęЬÔĄsĄLлKùvåH£ΞMFУûÊyđÜqdŽŚЖsĘъsПÂÔØŹÞŮγŚΣЧ6Ïж¢чPyòлБ14ÚęŃĄåîêтηΛbΦđkûÇĂζsБúĎdŸUЛзÙÂÚJηXťćж¥zщòÁŸRĘ")
            (emma:string "Ѻ.A0ěьπΨтÎșπЦĐđŽ6ЫêÀεÅĐȘдÞЩ4Ł2ďй5žömiτsλÚÇдěÒaV₱ÏûιЩД₳îJÍşыyÜŹżęìvAЙsÄ¢ÿnΦIťQůЮ7ĄвaèďíoáнõÎLJθÆEáПiXÿÒÀĘ14цU1çΞêSťüIψчèι₱ê9ŽчΓüЦrÀÓμĆ99κQťqPÖшŮ1ÈČSĐŁÌбÝàŞbPσŃĎ8ĄW")
            (lumy:string "Ѻ.œâσzüştŒhłσćØTöõúoвþçЧлρËШđюλ2ÙPeжŘťȚŤtθËûrólþŘß₿øuŁdáNÎČȘřΦĘbχλΩĄ¢ц2ŹθõĐLcÑÁäăå₿ξЭжулxòΘηĂœŞÝUËcω∇ß$ωoñД7θÁяЯéEU¢CЮxÃэJĘčÎΠ£αöŮЖбlćшbăÙЦÎAдŃЭб$ĞцFδŃËúHãjÁÝàĘSt")
            ;;
            (ico0:object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.C_RotateKadena ats "k:10e05871c5a2ef3f0f7dca9edd8e96e4ef0952175a4a2621895d2c4402a7b56a")
            )
            (ico1:object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.C_RotateKadena  vst "k:1a4e15d3c51e0b73e92644600487ba8eaae312e1a178b91801d54e13c1b350a5")
            )
            (ico2:object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.C_RotateKadena swp "k:1f6398b1f501992a470efc27707c1b3980f55e602d79755ccdd87afc2b7f03ee")
            )
            (ico3:object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.C_RotateKadena dhvault "k:d80ff2efd92ebbf9ca367b4985952c2955e85f9e706bcb0745b2e0492dfe3af3")
            )
            (ico4:object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.C_RotateKadena custodians "k:41cf258202856ffd66858e13c9bda0e1399ed6b40f67140c975d44b6afa3a039")
            )
            (ico5:object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.C_RotateKadena dsp "k:45b2f2b7088264e432a42a57e27ec11a17fa33e5c3637c4911f312a74386a0c9")
            )
            (ico6:object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.C_RotateKadena dpdc "k:b836c5c6b989d97737c954934c24686b876b78082bd03475878c245794d6ef80")
            )
            (ico7:object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.C_RotateKadena dhvault-n "k:d80ff2efd92ebbf9ca367b4985952c2955e85f9e706bcb0745b2e0492dfe3af3")
            )
            (ico8:object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.C_RotateKadena custodians-n "k:41cf258202856ffd66858e13c9bda0e1399ed6b40f67140c975d44b6afa3a039")
            )
            (ico9:object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.C_RotateKadena dsp-n "k:45b2f2b7088264e432a42a57e27ec11a17fa33e5c3637c4911f312a74386a0c9")
            )
            (ico10:object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.C_RotateKadena ah-pleb "k:11cd20672e0b414864b3b55f81f3980a74a021928c80b607d9e678043b34da80")
            )
            (ico11:object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.C_RotateKadena patron "k:35d9be77f2a414cd8ce6ed83afd9d53bbdb5ef85723417131225b389a6c9e54f")
            )
            (ico12:object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.C_RotateKadena aoz "k:cc68ca8410bf580323937b323b389ad5664e304e7aabb3df4a2ecd7cab40c38d")
            )
            (ico13:object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.C_RotateKadena emma "k:2cc72ef06136150f52c01dcc3a135dbd03e5328fafd71442a933619b9337456c")
            )
            (ico14:object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.C_RotateKadena lumy "k:afa4d5ec4f1070e58badaac237fbf16c19c0b08dd4b981b3e91937943714138d")
            )
            (final-ico::object{OuronetDalosV3.OutputCumulatorV2}
                (DALOS.UDC_ConcatenateOutputCumulatorsV2 
                    [ico0 ico1 ico2 ico3 ico4 ico5 ico6 ico7 ico8 ico9 ico10 ico11 ico12 ico13 ico14] []
                )
            )
        )
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
        ;;
        (define-keyset (+ ons k11) (read-keyset k11))
        (define-keyset (+ ons k12) (read-keyset k12))
    
        (define-keyset (+ ons k13) (read-keyset k13))
        (define-keyset (+ ons k14) (read-keyset k14))
        (define-keyset (+ ons k15) (read-keyset k15))
        (DALOS.IGNIS|C_Collect patron final-ico)
    )
)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.LQD|C_UnwrapKadena patron unwrapper amount)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_MultiBulkTransfer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    [
        "OURO-slLyzPPCo22W"
        "AURYN-slLyzPPCo22W"
        "ELITEAURYN-slLyzPPCo22W"
        "IGNIS-slLyzPPCo22W"
    ]
    "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    [
        [
            "Ѻ.БqßtgЙAиßÎиYБЭJпÖ₿éΦ9θ∇ȚЦČČ0íNΓ¥ÞWÃ7цнfãбUь€Ñßî₳ÈÃĎÚ¥εÉЪЯVьŠйÃИțчNĆďířGЙьЬÑiMşщďθk₳UĘйχæíbą₳đьñ2ěйŁνÀxżкШιЗвtæ£HYYœ¥şщÖλλCШŘinìpЖθÀŠφqпjфđZ$ÆÊдΘΩP8àψЫЙъψĐÛщfфěш"
            "Ѻ.BĆÊăvμЬñĎÆΓŹ₱sμмыжmçK91AЫåûBPșдåΘуwЗęQåÎžNπЩ2ЯБлпωúÞнŘńŚĄИУщgѺăřΩÉøĄαÞȚвŚLÈдŹν5ΘMŒлťôДÒQ€ÝŒЭÊпγĎŠмЗzΞGMĐщкøù¥пăмÒΔQзđÑиßÒÂÒXvŘȚдř6ΨιÕΘлŤżд8źTΠȚδÿWM9ČŒuśИ"
            "Ѻ.χHåăRT2ÌΠшđςöñÄůыmтÌЛθωΣ5uβΞĚFXςÏFmĎχДqsи1îмoĘIžиωżáλÊlşiνÒdř₿лčιяRPЩшMΞuT9ÉφwюжÏUщéκâZΓшãЫИÎãù43ΞçďνYşкѺĄóqRCкđÕЙфк¢ĄěэõμæõCŤиЬÆzbđ3ŚdöÏĚ∇ÅŽËшЭÈяdÞGș2áaO3£ΩöGh"
        ]
        [
            "Ѻ.БqßtgЙAиßÎиYБЭJпÖ₿éΦ9θ∇ȚЦČČ0íNΓ¥ÞWÃ7цнfãбUь€Ñßî₳ÈÃĎÚ¥εÉЪЯVьŠйÃИțчNĆďířGЙьЬÑiMşщďθk₳UĘйχæíbą₳đьñ2ěйŁνÀxżкШιЗвtæ£HYYœ¥şщÖλλCШŘinìpЖθÀŠφqпjфđZ$ÆÊдΘΩP8àψЫЙъψĐÛщfфěш"
            "Ѻ.BĆÊăvμЬñĎÆΓŹ₱sμмыжmçK91AЫåûBPșдåΘуwЗęQåÎžNπЩ2ЯБлпωúÞнŘńŚĄИУщgѺăřΩÉøĄαÞȚвŚLÈдŹν5ΘMŒлťôДÒQ€ÝŒЭÊпγĎŠмЗzΞGMĐщкøù¥пăмÒΔQзđÑиßÒÂÒXvŘȚдř6ΨιÕΘлŤżд8źTΠȚδÿWM9ČŒuśИ"
        ]
        [
            "Ѻ.БqßtgЙAиßÎиYБЭJпÖ₿éΦ9θ∇ȚЦČČ0íNΓ¥ÞWÃ7цнfãбUь€Ñßî₳ÈÃĎÚ¥εÉЪЯVьŠйÃИțчNĆďířGЙьЬÑiMşщďθk₳UĘйχæíbą₳đьñ2ěйŁνÀxżкШιЗвtæ£HYYœ¥şщÖλλCШŘinìpЖθÀŠφqпjфđZ$ÆÊдΘΩP8àψЫЙъψĐÛщfфěш"
        ]
        [
            "Ѻ.BĆÊăvμЬñĎÆΓŹ₱sμмыжmçK91AЫåûBPșдåΘуwЗęQåÎžNπЩ2ЯБлпωúÞнŘńŚĄИУщgѺăřΩÉøĄαÞȚвŚLÈдŹν5ΘMŒлťôДÒQ€ÝŒЭÊпγĎŠмЗzΞGMĐщкøù¥пăмÒΔQзđÑиßÒÂÒXvŘȚдř6ΨιÕΘлŤżд8źTΠȚδÿWM9ČŒuśИ"
        ]
    ]
    [
        [
            4443.144703341228115265
            (fold (+) 0.0 [365.1477041017586597 1.288949440690679121 18.22 0.003394166909684005])
            779.812704444130899739
        ]
        [
            87.979277897548063757
            (fold (+) 0.0 [13.588173133664337363 0.48563340155397279 0.3215130745112429061 1.113])
        ]
        [
            25.715738928979436092
        ]
        [
            6241.0
        ]
    ]
)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_MultiBulkTransfer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    [
        "WKDA-slLyzPPCo22W"
    ]
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    [
        [
        "Ѻ.ŠÿůŘŃBUsŤòΨżЦΛmŘ7aιÍσ$ș₳ȚfE1ζŹñИЩAœüЙjЯΘШÛÇм£ΠηZUùbÈфцδSĞlUβ€εtFŃρìÇfuelØLȚюø$å₳ąĚiЭЧÈzПLŹЫÁgÙьщOsÎôΛΨâłЦôaпôкÓ1èÛOyłÇęζȚÜďßÝÎΘbиìÕäFÀÑ$àЙcövŁжαÂχЧ£Á2þäæWBíЦČŁŮ"
        "Ѻ.ÇñLŁ€pmœöĐWĂΓБñвíûζαβçŸ¢ETΛĆUтȚΛrFĆØĆξЪп1HěńÚяŹĂ7ζoãЦЩЭЯ₳îÀýJξÙу5юĘȘĂγ9ΩżδéÅęŘЬŽÕĄrëĎЮ₱ÂЦĞψИďâOuć0CżîιIđrÉĄςτYъ$1ìíΣJъjÖğлιÀÄνЧdËЬ$FìÀÅřνòÙфUöÄqEZЩ¢ßØÝÑÆè1õιйñΓ"
        "Ѻ.шÖЮíэTѺåãΣШËşčÌòS€чpΩιшЧЦťЭιîgΣÅôéÄξνнœяVłĆэviźüжÙw₱UςУэ₱иУÂΣπà7ъюßáYüÓIьÙăANйÏжĘЧdąÈØπ£ςWșLhëDŸщιO4ñŮЗÒÒ3ÌÎĎA9a₿S8Ÿ¢ÈχGëźrćcaGśïŤ¢WRñõγ8žÁš2ЫÏžШÿцДςsŹ6ÑζUдkÁĐζ"
        ]
    ]
    [
        [
        ]
    ]
)



(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(let
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
    )
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.MB.A_ToggleOpenForBusiness true)
    (TS01-C1.DALOS|C_RotateKadena 
        patron patron 
        "k:2d4c9cd8d1bd30d9156b65c1259d2be9689f068927d8fee19bfb695619436e01"
    )
    (install-capability 
        (coin.TRANSFER 
            lq-kda
            kadena-patron 
            amount
        )
    )
    
    (TS01-C1.DALOS|C_RotateKadena 
        patron patron 
        "k:35d9be77f2a414cd8ce6ed83afd9d53bbdb5ef85723417131225b389a6c9e54f"
    )
    
)


(n_7d40ccda457e374d8eb07b658fd38c282c545038.MB.C_MovieBoosterBuyer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    1
    false
)



(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(let
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (chainweaver-sender:string "k:2d4c9cd8d1bd30d9156b65c1259d2be9689f068927d8fee19bfb695619436e01")
        (koala-sender:string "k:35d9be77f2a414cd8ce6ed83afd9d53bbdb5ef85723417131225b389a6c9e54f")
        (liquid-recipient:string LIQUID.LIQUID|SC_KDA-NAME)
        (spark-amount:integer 1)
        (kda-amount:decimal (MB.URC_TotalMBCost spark-amount))
    )
    (TS01-C1.DALOS|C_RotateKadena patron patron chainweaver-sender)
    (install-capability 
        (coin.TRANSFER 
            chainweaver-sender
            liquid-recipient
            kda-amount
        )
    )
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.MB.C_MovieBoosterBuyer
        patron
        patron
        spark-amount
        false
    )
    (TS01-C1.DALOS|C_RotateKadena patron patron koala-sender)
)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(TS01-C1.DALOS|C_RotateKadena 
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "k:2d4c9cd8d1bd30d9156b65c1259d2be9689f068927d8fee19bfb695619436e01"
)
(TS01-C1.DALOS|C_RotateKadena 
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "k:35d9be77f2a414cd8ce6ed83afd9d53bbdb5ef85723417131225b389a6c9e54f"
)

(TS01-C1.DALOS|C_RotateKadena 
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.ÔlзюĞÞýжůúìЮRПы3эérДÏõÀЬâùèCχżÖtDlÅgБ6яğèιмgnŸŒćçнÎэnÅ5tĐηψìãŮĘΘe¢ЬA₳ΔЛ¢ρЦκĎвÈбe7ÖJΔÏ3șφûηnŤäčúμ£ЧλíĆC₱ëż₳χдYιΔäđAąoĞъØ∇hůτNÔRxgŹŹЫĐ7FςЭ8ΣσвhD3жâó¥ышΨψşψžźëÅôщc"
    "k:2d4c9cd8d1bd30d9156b65c1259d2be9689f068927d8fee19bfb695619436e01"
)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
[
(DALOS.UR_AccountGovernor
    (DALOS.GOV|DALOS|SC_NAME)
)
(DALOS.UR_AccountGovernor
    (DALOS.GOV|VST|SC_NAME)
)
(DALOS.UR_AccountGovernor
    (DALOS.GOV|SWP|SC_NAME)
)]

(acquire-module-admin TS01-C2)
(with-capability (TS01-C2.P|TS)
    (let
        (
            (fire-starter:string "Ѻ.ÔlзюĞÞýжůúìЮRПы3эérДÏõÀЬâùèCχżÖtDlÅgБ6яğèιмgnŸŒćçнÎэnÅ5tĐηψìãŮĘΘe¢ЬA₳ΔЛ¢ρЦκĎвÈбe7ÖJΔÏ3șφûηnŤäčúμ£ЧλíĆC₱ëż₳χдYιΔäđAąoĞъØ∇hůτNÔRxgŹŹЫĐ7FςЭ8ΣσвhD3жâó¥ышΨψşψžźëÅôщc")
            (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
            (ref-DALOS:module{OuronetDalosV4} DALOS)
            (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
            (ref-LIQUID:module{KadenaLiquidStakingV4} LIQUID)
            (ref-ORBR:module{OuroborosV4} OUROBOROS)
            (ref-SWP:module{SwapperV4} SWP)
            (ref-SWPU:module{SwapperUsageV4} SWPU)
            ;;
            (ouro:string (ref-DALOS::UR_OuroborosID))
            (ignis:string (ref-DALOS::UR_IgnisID))
            (primordial:string (ref-SWP::UR_PrimordialPool))
            (fire-starter-ignis:decimal (ref-DPTF::UR_AccountSupply ignis fire-starter))
            (fire-starter-ouro:decimal (ref-DPTF::UR_AccountSupply ouro fire-starter))
        )
        (enforce (and (< fire-starter-ouro 1.0) (= fire-starter-ignis 0.0)) 
            "Only Virgin Ouronet Accounts allowed for firestarting"
        )
        (let
            (
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                (wkda:string (ref-DALOS::UR_WrappedKadenaID))
                (ico1:object{IgnisCollector.OutputCumulator}
                    (ref-LIQUID::C_WrapKadena fire-starter 10.0)
                )
                (ico2:object{IgnisCollector.OutputCumulator}
                    (ref-SWPU::C_Swap fire-starter primordial [wkda] [10.0] ouro -1.0 kda-pid)
                )
                (ico3:object{IgnisCollector.OutputCumulator}
                    (ref-ORBR::C_SublimateV2 fire-starter fire-starter (at 0 (at "output" ico2)))
                )
            )
            ;(format "Used 10 KDA to generate {} IGNIS to client minus Gas fees" [(at 0 (at "output" ico3))])              
            (format "Used 10 KDA to generate {} IGNIS to client minus Gas fees" [7.0])              
        )
    )
)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "OURO-slLyzPPCo22W"
    "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    "Ѻ.àИĂ2hΓźя£ØXJq∇ЗзbȚþĄZcpeĎóмØAσë£Ю8LěĎÛ¢ÁŤѺîžśbWUrδΩεγЮăΛîÉýѺTIoЪκœ₳ÿÆğğφбì5qvąПς0ЬTźÃíЗ¢MrÄůù₱яqγяиЭвÁïrκF8MÛÿĘи₳ρQĚПιú59óÕôŮÝéäуuäŹV₳ì5Ir₳đДb1ÑыrlŻăŞațÂθO5vкУŠ"
    10.255095190075491485
    false
)


(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DALOS|C_DeployStandardAccount 
    "Ѻ.þódýSå∇θœŻθäЮânΦěÂCÉΛŠĚыćжŃУфÑíтσÈŸüÓÿÂи₳áìĚàŘhÃѺuΔuțŒЭěвžsÊ¢tWÛěbtõ₿1LΔмëøÆŚøξѺŮŤÒÚτцoDêžńęQvNTжÚž∇9ÂKуŞşи0ΛкДżεŽбÎбεÀÆãчvĚЫбçrЭKãwÿŽΨáÕЦê1мòğćZЮĞÉø1Î$mДMѺπďRЫ" 
    (read-keyset "ks") 
    "k:be554d8fbee9a24f6dd533d0aaff7f0642c677c5dbadc61422cc4043b3b3785f" 
    "9F.8Kd1nxv7iFyoF0L8mIBMFEri4aMGKcwHhd2LrzgeiCHleps2u0BC0dt3sMtLA6bne216JHGsfoq3pM19vjGswBDavbg4FBI39FhjuDqMlk8K1ahlKH8nbEDhybBwKKGstgthzGahbaH6rdnwk777gkhmmy4qejrIfelLHj8BE9wtxGbEoEyFpJdgkn2DofM9m1Ja98v69i59KuAHyuh6uJAxFelfaxp5JkJ06ElMJlIlAzjuz1nu4DmpIG0mtK5okFomLkvulr3w5EtrJpn4tsJpaMHK0fHJf4KDj8zplDtBfk87CewJ7ebw17KCj099Ha0jMErID2GwjgtpDI5tjljiCfeGq6J4bnw5j3gB7ACb4oxe3e6joHCgqwlp7q7aqpDmdnkkKfgguojmLi4rpkcJyJxwjeqqakqilgpBegI1rv3Dlvns9eieCKttaIH1Iuyn4JBpEhqxy79KojsLtvuAnb6seuF2MMp06g2e2inI0f1hBFIpf5g2pLequ143vbb6KFrwAr1tMk7FmjEDki3GKHB8qA9cAIHeAtirxqlaxH3CyKwFj4v5Ma0"
)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(let
    (
        (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (spark-sc:string "Σ.Îäć$ЬчýφVεÎÿůпΨÖůηüηŞйnюŽXΣşpЩß5ςĂκ£RäbE₳èËłŹŘYшÆgлoюýRαѺÑÏρζt∇ŹÏýжIŒațэVÞÛщŹЭδźvëȘĂтPЖÃÇЭiërđÈÝДÖšжzČđзUĚĂsкιnãñOÔIKпŞΛI₳zÄû$ρśθ6ΨЬпYпĞHöÝйÏюşí2ćщÞΔΔŻTж€₿ŞhTțŽ")
        (spark:string "SPARK-zE_O6meVEL3X")
        (wkda:string "WKDA-slLyzPPCo22W")
        (supply:decimal (ref-DPTF::UR_AccountSupply wkda spark-sc))
    )
    supply
    (n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer
        patron
        wkda
        spark-sc
        patron
        supply
        true
    )
)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(ALA.URC_ValueToKadenaz
    (ALA.URC_ExtraValueNeeded
        (ALA.UC_CDP
            (SWPI.URC_OuroPrimordialPrice)
            10.0
            365
        )
    )
)

;;650 +143.52 183.34
;;78% value added, X/78*100 for total amount

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(let
    (
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (amount:decimal 650.0)
        (target:string "k:35d7f82a7754d10fc1128d199aadb51cb1461f0eb52f4fa89790a44434f12ed8")
        (original:string "k:35d9be77f2a414cd8ce6ed83afd9d53bbdb5ef85723417131225b389a6c9e54f")
    )
    (TS01-C1.DALOS|C_RotateKadena patron patron target)
    (DALOS.KDA|C_CollectWT patron amount false)
    (TS01-C1.DALOS|C_RotateKadena patron patron original)
)

(coin.TRANSFER "k:35d7f82a7754d10fc1128d199aadb51cb1461f0eb52f4fa89790a44434f12ed8" "k:2e5ffa38bf42d216f5e5773303250c40ae4a9453cea02bbdb2ae390b0205e2b0" 65.0)
(coin.TRANSFER "k:35d7f82a7754d10fc1128d199aadb51cb1461f0eb52f4fa89790a44434f12ed8" "c:EX0XSNfVxsm906AyVouFPXiLZPYObybqBCCtOpbb3HQ"  130.0)
(coin.TRANSFER "k:35d7f82a7754d10fc1128d199aadb51cb1461f0eb52f4fa89790a44434f12ed8" "k:1d9909881642d0bdfa39d6ff74165e0e632b6125cb6d772579fb51ac248bf9d8"  195.0)
(coin.TRANSFER "k:35d7f82a7754d10fc1128d199aadb51cb1461f0eb52f4fa89790a44434f12ed8" "c:U9gIg2OvVyINjXEGFCkar1OYKLGkdJkOeMtglG4hWeo" 260.0)

;;Get Owned Supplies Example
(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(let
    (
        (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
        (ref-TFT:module{TrueFungibleTransferV7} TFT)
        (ref-U|LST:module{StringProcessor} U|LST)
        (id:string "WKDA-slLyzPPCo22W")
        (accounts:[string] (ref-TFT::DPTF-DPMF-ATS|UR_FilterKeysForInfo id 1 false))
        (l:integer (length accounts))
    )
    (fold
        (lambda
            (acc:[decimal] idx:integer)
            (ref-U|LST::UC_AppL acc (ref-DPTF::UR_AccountSupply id (at idx accounts)))
        )
        []
        (enumerate 0 (- l 1))
    )
)

;;"Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ"
[(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.ATS|C_Curl
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Auryndex-ds4il5rO7vDC"
    "EliteAuryndex-ds4il5rO7vDC"
    "OURO-slLyzPPCo22W"
    5425.0
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "AURYN-slLyzPPCo22W"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    1850.388359199942705190510454
    true
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C1.DPTF|C_Transfer
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "ELITEAURYN-slLyzPPCo22W"
    "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ"
    "Ѻ.ъбąRдqμζøþśĘĐÅДьöщн4ÚÔFòŞå2α£mhΦÁ6ZȘfČZρэЩΘιЗJ7ЖŁ₳69£ânğΩÊÏïñŚvÉtgБBÃșЩБìììфλëΩAïWmaFFVþ$źźSêρQQкѺæρĞюεGîGşđдПȘșψEźβΩT3ìтŚкř£жÖП8ăąźÎξů4ŸЮΩB₳šÝЙ∇řÇwíčăb4₱ďĚOςÉм"
    1850.388359199942705190510454
    true
)]


(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")

(let
    (
        (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (treasury:string "Σ.ъΦĞρλξäFφVПÉЫÍЬÙGěЭыц¥ĄïsKзŤ8£ΞδĚãlÍŃÝþáΩĘΞȘĎĄЛδůÖîĎĄΠДÈrЪqyςkѺδKłĄρțØänÀŚxчtÍςÃΩ₳9ť7ÇяŠΛδÓdťЗΞŻÛπΩ∇цжuлiØłÛáYπOкæáYoùχmŒуŞËЛΞьPĘáÛÝaBÑБžя₳țςhrĚë₱dÑLÞЛεñeîÓУłëΦ")
        (client:string "Ѻ.ъбąRдqμζøþśĘĐÅДьöщн4ÚÔFòŞå2α£mhΦÁ6ZȘfČZρэЩΘιЗJ7ЖŁ₳69£ânğΩÊÏïñŚvÉtgБBÃșЩБìììфλëΩAïWmaFFVþ$źźSêρQQкѺæρĞюεGîGşđдПȘșψEźβΩT3ìтŚкř£жÖП8ăąźÎξů4ŸЮΩB₳šÝЙ∇řÇwíčăb4₱ďĚOςÉм")
        (auryn:string "AURYN-slLyzPPCo22W")
        (elite-auryn:string "ELITEAURYN-slLyzPPCo22W")
        (eauryndex:string "EliteAuryndex-ds4il5rO7vDC")
        (patron-auryn-supply:decimal (ref-DPTF::UR_AccountSupply auryn patron))
        (amount:decimal 764.0)
        ;;
        (t1:string (TS01-C1.DPTF|C_Transfer patron auryn patron treasury patron-auryn-supply true))
        (coil-amount:decimal (TS01-C2.ATS|C_Coil patron treasury eauryndex auryn amount))
    )
    [
        t1
        (format "Coiling {} Auryn yielded {} Elite-Auryn" [patron-auryn-supply coil-amount])
        (TS01-C1.DPTF|C_Transfer patron elite-auryn treasury client coil-amount true)
    ]
)

6300.606415594161000000000000
(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.ATS|C_Coil
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Auryndex-ds4il5rO7vDC"
    "EliteAuryndex-ds4il5rO7vDC"
    "OURO-slLyzPPCo22W"
    10.0
)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.ATS|C_ColdRecovery
    "Ѻ.ÙÉlgЖ2ЦζGČŃчΔ7ÈehĂpУΨΛжXчNøÒäεИbôłξ6σæ₱þğÕнwŸêτńsιφÏþfÏŘÿQθкшμΦgiЗΣωõásŒΦ€ýюĄBнчěþЧαsČÅyȘИöSŁÁVSłßДgNЩиřβÅMΦöÞXšÞbQЫбzĎŮe₿ñÔŚďæğЖžCDìÿ7ÒÆB2knΩúÓcíŮłŸnκΓÒΩBÅĄÂБΣ"
    "Ѻ.ÙÉlgЖ2ЦζGČŃчΔ7ÈehĂpУΨΛжXчNøÒäεИbôłξ6σæ₱þğÕнwŸêτńsιφÏþfÏŘÿQθкшμΦgiЗΣωõásŒΦ€ýюĄBнчěþЧαsČÅyȘИöSŁÁVSłßДgNЩиřβÅMΦöÞXšÞbQЫбzĎŮe₿ñÔŚďæğЖžCDìÿ7ÒÆB2knΩúÓcíŮłŸnκΓÒΩBÅĄÂБΣ"
    "Auryndex-ds4il5rO7vDC"
    10.0
)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(DALOS.IC|C_Collect "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî" (DALOS.IC|UDC_CustomCodeCumulator))
(let
    (
        ;;variables or commands that outputs values here
        ;;(variable:decimal (Function that outputs decimal))
    )
    ;;commands here
)

(n_7d40ccda457e374d8eb07b658fd38c282c545038.TS01-C2.ATS|C_Coil
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "LiquidKadenaIndex-ds4il5rO7vDC"
    "WKDA-slLyzPPCo22W"
    0.606415594161
)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038") 
(acquire-module-admin DPTF) 
(let 
    ( 
        (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF) 
        (id:string "WKDA-slLyzPPCo22W") 
        (account:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî") 
        (prev-amount:decimal (ref-DPTF::UR_AccountSupply id account)) 
        (new-amount:decimal 6300.0) 
    ) 
    (update DPTF.DPTF|BalanceTable (concat [id b account]) {"balance" : new-amount} )  
    (format "Previous Amount of {} {} on account {} has been manualy set to {} in Admin-Mode; Amount thus remains unchanged;" [prev-amount id account new-amount] ) 
)

[(n_7d40ccda457e374d8eb07b658fd38c282c545038.DPL-UR.URC_0006_Swap
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "W|LKDA-slLyzPPCo22W|OURO-slLyzPPCo22W|WKDA-slLyzPPCo22W"
    ["LKDA-slLyzPPCo22W" "OURO-slLyzPPCo22W"]
    [10.0 20.0]
    "WKDA-slLyzPPCo22W"
)
(n_7d40ccda457e374d8eb07b658fd38c282c545038.DPL-UR.URC_0007_InverseSwap
    "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî"
    "W|LKDA-slLyzPPCo22W|OURO-slLyzPPCo22W|WKDA-slLyzPPCo22W"
    "WKDA-slLyzPPCo22W"
    25.0
    "OURO-slLyzPPCo22W"
)]