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
        ;;Namespace must be changed with the created Namespace
        (ons:string "n_e096dec549c18b706547e425df9ac0571ebd00b0.")
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

        (k10:string "dh_ah-keyset")
        (k11:string "dh_cto-keyset")
        (k12:string "dh_hov-keyset")

        (k13:string "us-0000_aozt-keyset")
        (k14:string "us-0001_emma-keyset")
        (k15:string "us-0002_lumy-keyset")

    )
    (namespace ons)
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
;;[0]   dh_master-keyset                      ||    k:
;;[1]   dh_sc_dalos-keyset                    ||    k:
;;[2]   dh_sc_autostake-keyset                ||    k:
;;[3]   dh_sc_vesting-keyset                  ||    k:
;;[4]   dh_sc_kadenaliquidstaking-keyset      ||    k:
;;[5]   dh_sc_ouroboros-keyset                ||    k:
;;[6]   dh_sc_swapper-keyset                  ||    k:
;;[7]   dh_sc_dhvault-keyset                  ||    k:
;;[8]   dh_sc_custodians-keyset               ||    k:
;;[9]   dh_sc_dispenser-keyset                ||    k:

;;[10]  dh_ah-keyset                          ||    k:
;;[11]  dh_cto-keyset                         ||    k:
;;[12]  dh_hov-keyset                         ||    k:

;;[13]  us-0000_aozt-keyset                   ||    k:
;;[14]  us-0001_emma-keyset                   ||    k:
;;[15]  us-0002_lumy-keyset                   ||    k:
(print "END STEP 002")
;;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;
(print "BEGIN STEP 003")
;;
;;STEP 003 - Modify the KDA Accounts DPL-DALOS
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


;;Replace A_Step005 with up to 22
(let
    (
        (ref-DPL|DALOS:module{DeployerDalos} DPL-DALOS)
    )
    (ref-DPL|DALOS::A_Step005)
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

;;Replace A_Step001 with up to 20
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