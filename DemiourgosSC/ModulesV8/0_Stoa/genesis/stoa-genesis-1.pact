;;0]Payload requires
;;  <payload_ns-admin-keyset> 
;;  <payload_ns-genesis-keyset>
;;  <payload_ns-util-users>
;;  <payload_ns-util-admin>
;;
;;
;;1]Define <ns-admin-keyset> and <ns-operate-keyset> conceptually on the <null/root> namespace
(define-keyset "ns-admin-keyset" (read-keyset "payload_ns-admin-keyset"))
(define-keyset "ns-operate-keyset" (read-keyset "payload_ns-genesis-keyset"))
(define-keyset "util-ns-users" (read-keyset "payload_util-ns-users"))
(define-keyset "util-ns-admin" (read-keyset "payload_util-ns-admin"))
;;
;;
;;2]Deploy <ns> module on the <null/root> namespace
(module ns GOVERNANCE
    "Administers definition of new namespaces in Stoa-Chainweb."
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    (defschema reg-entry
        admin-guard:guard
        active:bool
    )
    ;;{2}
    (deftable registry:{reg-entry})
    ;;{3}
    (defconst GUARD_SUCCESS (create-user-guard (success)))
    (defconst GUARD_FAILURE (create-user-guard (failure)))
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;
    (defcap GOVERNANCE ()
        (enforce-keyset "ns-admin-keyset")
    )
    (defcap OPERATE ()
        (enforce-keyset "ns-operate-keyset")
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;
    (defun success () true)
    (defun failure () (enforce false "Disabled"))
    (defun validate-name (name)
        (enforce (!= "" name) "Empty name not allowed")
        (enforce (< (length name) 64) "Name must be less than 64 characters long")
        (enforce (is-charset CHARSET_LATIN1 name) "Name must be in latin1 charset")
    )
    (defun create-principal-namespace:string (g:guard)
        @doc " Format principal namespace as Pact hash (BLAKE2b256) of principal \
            \ in hex truncated to 160 bits (40 characters), prepended with 'n_'. \
            \ Only w: and k: account protocols are supported."
        (let
            (
                (ty (typeof-principal (create-principal g)))
            )
            ;; only w: and k: currently supported
            (if (or (= ty "k:") (= ty "w:"))
                (+ "n_" (take 40 (int-to-str 16 (str-to-int 64 (hash g)))))
                (enforce false (format "Unsupported guard protocol: {}" [ty]))
            )
        )
    )
    (defun validate:bool (ns-name:string ns-admin:guard)
        @doc "Manages namespace install for Chainweb. \
            \ Allows principal namespaces. \
            \ Non-principal namespaces require active row in registry \
            \ for NS-NAME with guard matching NS-ADMIN."
        (if (= (create-principal-namespace ns-admin) ns-name)  
            true ;; allow principal namespaces
            (with-default-read registry ns-name       ;; otherwise enforce registry
                {"admin-guard"  : ns-admin
                ,"active"       : false}
                {"admin-guard"  := ag
                ,"active"       := is-active}
                (enforce is-active "Inactive or unregistered namespace")
                (enforce (= ns-admin ag) "Admin guard must match guard in registry")
                true
            )
        )
    )
    (defun write-registry:string (ns-name:string guard:guard active:bool)
        @doc "Write entry with GUARD and ACTIVE into registry for NAME. \
            \ Guarded by operate keyset. "
        (with-capability (OPERATE)
            (validate-name ns-name)
            (write registry ns-name
                {"admin-guard"  : guard
                ,"active"       : active}
            )
            "Register entry written"
        )
    )
    (defun query:object{reg-entry} (ns-name:string)
        (read registry ns-name)
    )
)
  
(create-table registry)
;;
;;
;;3]Create the initial namespace and rotate the <ns-operate-keyset>
(write-registry "stoa-ns" (keyset-ref-guard "ns-operate-keyset") true)
(write-registry "ouronet-ns" (keyset-ref-guard "ns-operate-keyset") true)
(write-registry "user" GUARD_FAILURE true)
(write-registry "free" GUARD_FAILURE true)
(write-registry "util" (keyset-ref-guard "util-ns-users") true)

(define-namespace "stoa-ns" (keyset-ref-guard "ns-operate-keyset") (keyset-ref-guard "ns-operate-keyset"))
(define-namespace "ouronet-ns" (keyset-ref-guard "ns-operate-keyset") (keyset-ref-guard "ns-operate-keyset"))
(define-namespace "user" GUARD_SUCCESS GUARD_FAILURE)
(define-namespace "free" GUARD_SUCCESS GUARD_FAILURE)
(define-namespace "util" (keyset-ref-guard "util-ns-users") (keyset-ref-guard "util-ns-admin"))
;;
;;