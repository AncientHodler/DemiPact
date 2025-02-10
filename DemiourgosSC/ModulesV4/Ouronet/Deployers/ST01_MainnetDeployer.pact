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