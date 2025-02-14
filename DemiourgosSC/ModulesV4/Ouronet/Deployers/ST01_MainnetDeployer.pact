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


;;STEP 002 - Define all Necesary Keys on the Deployed Namespace
;;Replace the Namespace with the ACTUAL NAMEPACE created. This will be the namespace where Ouronet resides.
(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_master-keyset"                  (read-keyset "dh_master-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_dalos-keyset"                (read-keyset "dh_sc_dalos-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_autostake-keyset"            (read-keyset "dh_sc_autostake-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_vesting-keyset"              (read-keyset "dh_sc_vesting-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_kadenaliquidstaking-keyset"  (read-keyset "dh_sc_kadenaliquidstaking-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_ouroboros-keyset"            (read-keyset "dh_sc_ouroboros-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_swapper-keyset"              (read-keyset "dh_sc_swapper-keyset"))

(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.dh_ah-keyset"                      (read-keyset "dh_ah-keyset"))
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.dh_cto-keyset"                     (read-keyset "dh_cto-keyset"))
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.dh_hov-keyset"                     (read-keyset "dh_hov-keyset"))

(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.us-0000_aozt-keyset"               (read-keyset "0000_aozt-keyset"))
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.us-0001_emma-keyset"               (read-keyset "0001_emma-keyset"))
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.us-0002_lumy-keyset"               (read-keyset "0002_lumy-keyset"))

;;ENTER KDA Accounts associated with each keyset below for ease of use:
;;[0]   dh_master-keyset                      ||    k:
;;[1]   dh_sc_dalos-keyset                    ||    w:
;;[2]   dh_sc_autostake-keyset                ||    k:
;;[3]   dh_sc_vesting-keyset                  ||    k:
;;[4]   dh_sc_kadenaliquidstaking-keyset      ||    w:
;;[5]   dh_sc_ouroboros-keyset                ||    w:
;;[6]   dh_sc_swapper-keyset                  ||    w:

;;[7]   dh_ah-keyset                          ||    w:
;;[8]   dh_cto-keyset                         ||    w:
;;[9]   dh_hov-keyset                         ||    w:

;;[10]  us-0000_aozt-keyset                   ||    w:
;;[11]  us-0001_emma-keyset                   ||    w:
;;[12]  us-0002_lumy-keyset                   ||    w:


;;STEP 003 - Modify the KDA Accounts in the modules to be deployed to accounts defined via chainweaver for easier manipulation:
;;Easier Manipulations, means i dont have to change the accounts afterwards
;;                                          Line
;;
;;
;;DALOS.DALOS|SC_KDA-NAME                   205     c:
;;ATS.ATS|SC_KDA-NAME                       178     k:
;;VST.VST|SC_KDA-NAME                       56      k:
;;LIQUID.LIQUID|SC_KDA-NAME                 46      c:
;;OUROBOROS.ORBR|SC_KDA-NAME                52      c:
;;SWP.SWP|SC_KDA-NAME                       144     c:
;;
;;DALOS-DPL.DEMIURGOI|AH_KDA-NAME
;;DALOS-DPL.DEMIURGOI|CTO_KDA-NAME
;;DALOS-DPL.DEMIURGOI|HOV_KDA-NAME

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
