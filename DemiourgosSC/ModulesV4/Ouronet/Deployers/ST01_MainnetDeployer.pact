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

;; U|CT             ;; 11.125
;; U|G              ;;  2.294
;; U|ST             ;;  4.163
;; U|RS             ;;  1.897
;; U|LST            ;;  7.686
;; U|INT            ;;  3.041
;; U|DEC            ;;  4.583
;; U|DALOS          ;; 10.845
;; U|ATS            ;; 38.170
;; U|DPTF           ;;  4.686
;; U|VST            ;;  5.145
;; U|SWP            ;; 22.882
;; U|BFS            ;; 15.234

;; DALOS            ;; 86.821
;; BRD              ;; 32.989
;; DPTF             ;;107.114
;; DPMF             ;;106.832
;; ATS              ;;129.167
;; TFT              ;; 57.540
;; ATSU             ;; 87.903
;; VST              ;; 37.203
;; LIQUID           ;; 25.121
;; OUROBOROS        ;; 36.589

;; SWPT             ;; 36.964
;; SWP              ;; 99.956
;; SWPU             ;;112.924

;; TS01             ;;109.350
;; DPL-DALOS        ;;109.097
;; DPL-AOZ          ;;


;;DALOS INIT
;;STEP 05           ;; 19.287
;;STEP 06           ;;  9.478
;;STEP 07           ;; 30.984
;;STEP 08           ;; 68.147
;;STEP 09           ;; 82.614
;;STEP 10           ;;104.320
;;STEP 11           ;; 21.629
;;STEP 12           ;; 38.086
;;STEP 13           ;;  8.776
;;STEP 14           ;; 44.015
;;STEP 15           ;; 41.949
;;STEP 16           ;;132.723
;;STEP 17           ;;  4.900
;;STEP 18           ;; 22.019
;;STEP 19           ;; 26.503
;;STEP 20           ;; 53.498
;;STEP 21           ;;  4.962
;;STEP 22           ;; 31.110

;;Replace A_Step005 with up to 22
(let
    (
        (ref-DPL|DALOS:module{DeployerDalos} DPL-DALOS)
    )
    (ref-DPL|DALOS::A_Step005)
)

;;AOZ INIT
;;STEP 01           ;;  1.111
;;STEP 02           ;; 59.547
;;STEP 03           ;; 94.406
;;STEP 04           ;; 55.664
;;STEP 05           ;;118.409
;;STEP 06           ;;111.180
;;STEP 07           ;;111.358
;;STEP 08           ;; 93.470
;;STEP 09           ;; 74.382
;;STEP 10           ;; 74.482
;;STEP 11           ;; 74.658
;;STEP 12           ;; 74.735
;;STEP 13           ;; 74.803
;;STEP 14           ;; 21.898
;;STEP 15           ;;142.905
;;STEP 16           ;;142.606
;;STEP 17           ;;142.523
;;STEP 18           ;;143.342
;;STEP 19           ;;142.821
;;STEP 20           ;;142.370

;;Replace A_Step001 with up to 20
;;Step 15 to 20, additional input of 250.0
(let
    (
        (ref-DPL|AOZ:module{DeployerAoz} DPL-AOZ)
    )
    (ref-DPL|AOZ::A_Step001)
)
