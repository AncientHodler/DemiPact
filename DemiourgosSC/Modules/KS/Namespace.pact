(namespace "free")

(module DHNS GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (DHNS-ADMIN))
    )

    (defcap DHNS-ADMIN ()
        (enforce-guard G-MD_DHNS)
    )
    (defconst G-MD_DHNS   (keyset-ref-guard DHNS|DEMIURGOI))
    (defconst DHNS|DEMIURGOI "free.dh_master-keyset")

    (defun DHNS|CreateNamespace ()
        (define-namespace "Demiourgos" G-MD_DHNS G-MD_DHNS)
    )

)