(interface DemiourgosPactSemiFungible
    @doc "Exposes most of the Functions of the DPSF Module"
    ;;
    (defschema DPSF|Schema
        nonce:integer
        balance:integer
    )
    (defschema DPSF|DataSchema
        nonce:integer
        supply:integer
        royalty:decimal
        ignis:decimal
        description:string
        meta-data:[object]
        asset-type:object{URI|Type}
        uri-primary:object{URI|Schema}
        uri-secondary:object{URI|Schema}
        uri-tertiary:object{URI|Schema}
    )
    (defschema URI|Schema
        image:string
        audio:string
        video:string
        document:string
        archive:string
        model:string
        exotic:string
    )
    (defschema URI|Type
        image:bool
        audio:bool
        video:bool
        document:bool
        archive:bool
        model:bool
        exotic:bool
    )
)

(module DPSF GOV
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPSF           (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|DPSF_ADMIN)))
    (defcap GOV|DPSF_ADMIN ()       (enforce-guard GOV|MD_DPSF))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|DPSF|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|DPSF|CALLER))
        (compose-capability (SECURE))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|DPSF_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DPSF_ADMIN)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (dg:guard (create-capability-guard (SECURE)))
                )
                (with-default-read P|MT P|I
                    {"m-policies" : [dg]}
                    {"m-policies" := mp}
                    (write P|MT P|I
                        {"m-policies" : (ref-U|LST::UC_AppL mp policy-guard)}
                    )
                )
            )
        )
    )
    (defun P|A_Define ()
        (let
            (
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (mg:guard (create-capability-guard (P|DPSF|CALLER)))
            )
            ;(ref-P|DALOS::P|A_AddIMP mg)
            ;(ref-P|BRD::P|A_AddIMP mg)
            ;(ref-P|DPTF::P|A_AddIMP mg)
        )
    )
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
            )
            (ref-U|G::UEV_Any (P|UR_IMP))
        )
    )
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    (defschema DPSF|PropertiesSchema
        sft:[object{DemiourgosPactSemiFungible.DPSF|DataSchema}]
        owner-konto:string
        creator-konto:string
        name:string
        ticker:string

        can-upgrade:bool
        can-change-owner:bool
        can-change-creator:bool
        can-add-special-role:bool
        can-transfer-nft-create-role:bool
        can-freeze:bool
        can-wipe:bool
        can-pause:bool

        create-role-account:string
        is-paused:bool
        nonces-used:integer
    )
    (defschema DPSF|BalanceSchema
        @doc "Key = <DPSF id> + BAR + <account>"
        exist:bool
        unit:[object{DemiourgosPactSemiFungible.DPSF|Schema}]
        frozen:bool
        role-nft-add-quantity:bool
        role-nft-burn:bool
        role-nft-create:bool
        role-nft-recreate:bool
        role-nft-update:bool
        role-modify-creator:bool
        role-modify-royalties:bool
        role-set-new-uri:bool
        role-transfer:bool
    )
    (defschema DPSF|RoleSchema
        a-frozen:[string]
        r-nft-add-quantity:[string]
        r-nft-burn:[string]
        r-nft-create:[string]
        r-nft-recreate:[string]
        r-nft-update:[string]
        r-modify-creator:[string]
        r-modify-royalties:[string]
        r-set-new-uri:[string]
        r-transfer:[string]
    )
)