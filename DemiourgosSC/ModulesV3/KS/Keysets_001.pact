;;First Deploy
(namespace "free")
(define-keyset "free.dh_master-keyset"                  (read-keyset "dh_master-keyset"))
(define-keyset "free.dh_sc_dalos-keyset"                (read-keyset "dh_sc_dalos-keyset"))
(define-keyset "free.dh_sc_autostake-keyset"            (read-keyset "dh_sc_autostake-keyset"))
(define-keyset "free.dh_sc_vesting-keyset"              (read-keyset "dh_sc_vesting-keyset"))
(define-keyset "free.dh_sc_kadenaliquidstaking-keyset"  (read-keyset "dh_sc_kadenaliquidstaking-keyset"))
(define-keyset "free.dh_sc_ouroboros-keyset"            (read-keyset "dh_sc_ouroboros-keyset"))

;;Second Deploy
(define-namespace 
    (ns.create-principal-namespace (read-keyset "dh_master-keyset"))
    (read-keyset "dh_master-keyset" )
    (read-keyset "dh_master-keyset" )
)

;;"Namespace defined: n_fe5586c4766b85407c6a0c977114e898e070fbd3"
;;Third Deploy
(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_master-keyset"                  (read-keyset "dh_master-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_dalos-keyset"                (read-keyset "dh_sc_dalos-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_autostake-keyset"            (read-keyset "dh_sc_autostake-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_vesting-keyset"              (read-keyset "dh_sc_vesting-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_kadenaliquidstaking-keyset"  (read-keyset "dh_sc_kadenaliquidstaking-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_ouroboros-keyset"            (read-keyset "dh_sc_ouroboros-keyset"))




;;1
(define-namespace 
    (ns.create-principal-namespace (read-keyset "dh_master-keyset"))
    (read-keyset "dh_master-keyset" )
    (read-keyset "dh_master-keyset" )
)

;;2
(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.dh_master-keyset"                    (read-keyset "dh_master-keyset")                    ;;ffe5460291905ab4f2ea67f2262ccbb5aee2c14ccc556109f8c5fe686fced3f9  
)                                                                                                                                                   ;;          ;[1] UTILS DALOS BASIS ATS ATSI TFT ATSC ATSM VST LIQUID OUROBOROS BRANDING
;                                                                                                                                                   ;;          TALOS|OUROBOROS TALOS|DALOS TALOS|DPTF TALOS|DPMF TALOS|ATS1 TALOS|ATS2 TALOS|VST TALOS|LIQUID DEPLOYER

;;4
(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.dh_sc_dalos-keyset"                  (read-keyset "dh_sc_dalos-keyset"))                 ;;273fa376dd0649ed1a1e77b760251a17a07db01f737a202ac00d2a302e50774f  [2] DALOS
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.dh_sc_autostake-keyset"              (read-keyset "dh_sc_autostake-keyset"))             ;;cd76cc2c93283bfbb5eadde2a2083ed79285624a03389d687c0ca23c52824634  [3] ATS ATSI ATSC ATSM
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.dh_sc_vesting-keyset"                (read-keyset "dh_sc_vesting-keyset"))               ;;45d5985807ebf2cdeb29b002428453a25e5d2bc0a5dbb062d581983b34b13680  [4] VST 
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.dh_sc_kadenaliquidstaking-keyset"    (read-keyset "dh_sc_kadenaliquidstaking-keyset"))   ;;8224d81359b2bea6e668ecc2749a4abdeff5332aec7b474df7de272e1c3c554e  [5] LIQUID
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.dh_sc_ouroboros-keyset"              (read-keyset "dh_sc_ouroboros-keyset"))             ;;eec6a8b7d6a2ac069cf7ea6ee871f737d900157f978b88deca59e5461ef36d54  [6] OUROBOROS

(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.dh_ah-keyset"                        (read-keyset "dh_ah-keyset"))                       ;;89c5b3a37d2976a8d2bf6be245a4418bc1f37f287b94ee2f6ed0907bf065e8eb  [7]
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.dh_cto-keyset"                       (read-keyset "dh_cto-keyset"))                      ;;2d67bbab17f774acbe430483642dcbec50432fb5f4527ee3dc57890f9b8b23bc  [8]
(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.dh_hov-keyset"                       (read-keyset "dh_hov-keyset"))                      ;;ebc59434f2f91b6e0daf1a3201328cf182301996db5304d75537062414c136f7  [9]

(define-keyset "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea.us-0000_emma-keyset"                 (read-keyset "0000_emma-keyset"))                   ;;6f152d5f5253892f37ce5ce1d6d5f2e0333a08e4cbbb183234273f8cc1563c27  [10]

;;DALOS Principal
;"c:G2mlrnV81JaMIrEJMan74nS3yQBlJD0BuSbUMzX1Tlg"
;;OUROBOROS Principal
;;"c:KHlbLdqlcH6zmWdqZdFGHsCh9Nb0cqXf8WOKQijstJ8"


;;Create Principal Accounts 
;;  DALOS       (collected of 75% of fuel to be used by the gas station)
;;  "c:G2mlrnV81JaMIrEJMan74nS3yQBlJD0BuSbUMzX1Tlg"

;;  OUROBOROS   (collecter of 15% fuel to be used for liquid staking)
;;  "c:KHlbLdqlcH6zmWdqZdFGHsCh9Nb0cqXf8WOKQijstJ8"

;;  LIQUID      (keeper of native KDA - returning DWK)
;;  "c:P31THC-NCoLEI5Kj7agNGMtVqT7v0keBi-bSrLb9eMs"


(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")

(module SUBBER G
    ;; Define governance keyset
    (defconst SUBBER-KEY "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_master-keyset")
    (defconst G-MD_SUBBER (keyset-ref-guard SUBBER-KEY))
    (defcap G ()
        (enforce-guard G-MD_SUBBER)
    )

    ;; Add two decimal numbers
    (defun Sub (x:decimal y:decimal)
      "Adds two decimal numbers and returns the result."
      (- x y)
    )
)
;;3
(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")
(module ADDER G
    ;; Define governance keyset
    (defconst ADDER-KEY "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_master-keyset")
    (defconst G-MD_ADDER (keyset-ref-guard ADDER-KEY))
    (defcap G ()
        (enforce-guard G-MD_ADDER)
    )

    ;; Add two decimal numbers
    (defun Add (x:decimal y:decimal)
      "Adds two decimal numbers and returns the result."
      (+ x y)
    )
)
