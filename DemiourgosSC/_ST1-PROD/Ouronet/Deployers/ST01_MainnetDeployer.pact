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

;;[10]  dh_ah-keyset                          ||    k:2dd5ae3dd78493f468d2f99e36fe4e1a39002cd26196e472ff47f50adb577cb5
;;[11]  dh_cto-keyset                         ||    k:1d9909881642d0bdfa39d6ff74165e0e632b6125cb6d772579fb51ac248bf9d8
;;[12]  dh_hov-keyset                         ||    k:2e5ffa38bf42d216f5e5773303250c40ae4a9453cea02bbdb2ae390b0205e2b0

;;[13]  us-0000_aozt-keyset                   ||    k:ad620c6759112c10a26519cc4e9a440721c04f1684f3c123f670d1c51f4bb4df
;;[14]  us-0001_emma-keyset                   ||    k:08786a657018b620ffce173a2071f85135ed9f4d7a67938a34b8d72f5c0763b1
;;[15]  us-0002_lumy-keyset                   ||    k:2df04179bfcddf22dd3d79c7d4afd9651e5f8e2a9dfbb8ba6fd9e77e2b432710

;;[16]  dh_sc_dispenser-keyset                ||    k:3a7c4c0fe8d2bfa68497f569cc33ef821511ec017c151c35f046ed504649d477
;;[17]  dh_sc_custodians-keyset               ||    k:1dacecf4d6fb57c68385b1da961f463e8b35275a13dd484f592a8a5a722224ca


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
;;[11]  DEMIURGOI|CTO_KDA-NAME                      k:
;;[12]  DEMIURGOI|HOV_KDA-NAME                      k:
;;[13]  PLEB|AOZT_KDA-NAME                          k:
;;[14]  PLEB|EMMA_KDA-NAME                          k:
;;[15]  PLEB|LUMY_KDA-NAME                          k:
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
;; U|SWP            ;; 23.622
;; U|BFS            ;; 15.710

;; DALOS            ;;103.365
;; BRD              ;; 35.136
;; DPTF             ;;130.142
;; DPMF             ;;124.830
;; ATS              ;;140.018
;; TFT              ;;120.721
;; ATSU             ;;106.934
;; VST              ;; 94.482
;; LIQUID           ;; 37.528
;; OUROBOROS        ;; 50.706

;; SWPT             ;; 46.723
;; SWP              ;;106.917
;; SWPU             ;;140.506

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