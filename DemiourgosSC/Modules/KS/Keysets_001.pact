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
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_master-keyset"
    (read-keyset "dh_master-keyset")
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

;;4
(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_dalos-keyset"                (read-keyset "dh_sc_dalos-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_autostake-keyset"            (read-keyset "dh_sc_autostake-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_vesting-keyset"              (read-keyset "dh_sc_vesting-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_kadenaliquidstaking-keyset"  (read-keyset "dh_sc_kadenaliquidstaking-keyset"))
(define-keyset "n_e096dec549c18b706547e425df9ac0571ebd00b0.dh_sc_ouroboros-keyset"            (read-keyset "dh_sc_ouroboros-keyset"))

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
