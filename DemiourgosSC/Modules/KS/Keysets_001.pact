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
(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_master-keyset"                    (read-keyset "dh_master-keyset")                    ;;8ce9  [1] UTILS DALOS BASIS ATS ATSI TFT ATSC ATSM VST LIQUID OUROBOROS BRANDING
)                                                                                                                                                   ;;          TALOS|OUROBOROS TALOS|DALOS TALOS|DPTF TALOS|DPMF TALOS|ATS1 TALOS|ATS2 TALOS|VST TALOS|LIQUID DEPLOYER

;;4
(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_dalos-keyset"                  (read-keyset "dh_sc_dalos-keyset"))                 ;;51ac  [2] DALOS
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_autostake-keyset"              (read-keyset "dh_sc_autostake-keyset"))             ;;de10  [3] ATS ATSI ATSC ATSM
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_vesting-keyset"                (read-keyset "dh_sc_vesting-keyset"))               ;;899c  [4] VST 
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_kadenaliquidstaking-keyset"    (read-keyset "dh_sc_kadenaliquidstaking-keyset"))   ;;178c  [5] LIQUID
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_ouroboros-keyset"              (read-keyset "dh_sc_ouroboros-keyset"))             ;;0502  [6] OUROBOROS

(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_ah-keyset"                        (read-keyset "dh_ah-keyset"))                       ;;1f0d  [7]
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_cto-keyset"                       (read-keyset "dh_cto-keyset"))                      ;;d703  [8]
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_hov-keyset"                       (read-keyset "dh_hov-keyset"))                      ;;57b3  [9]

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
