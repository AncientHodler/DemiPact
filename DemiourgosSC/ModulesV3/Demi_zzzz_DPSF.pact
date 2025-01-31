(module DPSF GOVERNANCE
    @doc "Demiourgos 0006 Module - DPSF Module \
    \ Contains All the Semi Fungible Functionality \
    \ \
    \ \
    \ Smart DALOS Accounts governed by the Module (0) \
    \ \
    \ 0)NONE \
    \ Submodules: \
    \ \
    \ DPSF"

    ;;Module Governance
    (defcap GOVERNANCE ()
        (compose-capability (DPSF-ADMIN))
    )
    (defcap DPSF-ADMIN ()
        (enforce-guard G_BASIS)
    )
    ;;Module Guards
    (defconst G_DPSF   (keyset-ref-guard DPSF|DEMIURGOI))
    ;;Module Keys
    (defconst DPSF|DEMIURGOI DALOS.DALOS|DEMIURGOI)
    ;;Module Accounts Information - NONE
    ;;External Module Usage
    (use free.UTILS)
    (use free.DALOS)

    ;;
    ;;
    ;;


    ;;Simple True Capabilities (10+1)
    (defcap COMPOSE ()
        @doc "Usage: composing multiple functions in an IF statement"
        true
    )

    ;;Policies

    (defun DPSF|A_AddPolicy (policy-name:string policy-guard:guard)
        (with-capability (BASIS-ADMIN)
            (write DPSF|PoliciesTable policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun DPSF|C_ReadPolicy:guard (policy-name:string)
        @doc "Reads the guard of a stored policy"
        (at "policy" (read DPSF|PoliciesTable policy-name ["policy"]))
    )

;;  1]CONSTANTS Definitions - NONE
;;  2]SCHEMAS Definitions
    (defschema DPSF|PolicySchema
        @doc "Schema that stores external policies, that are able to operate within this module"
        policy:guard
    )
    ;;[S] DPMF Schemas
    (defschema DPSF|PropertiesSchema
        @doc "Schema for DPSF Token (Semi Fungibles) Properties \
        \ Key for Table is DPSF Token id. This ensure a unique entry per Token id"
        branding:object{BASIS.BrandingSchema}
        branding-pending:object{BASIS.BrandingSchema}
        owner-konto:string
        name:string
        ticker:string
        ;;TM=Token Manager
        can-change-owner:bool                  
        can-upgrade:bool
        can-add-special-role:bool
        can-freeze:bool
        can-wipe:bool
        can-pause:bool
        is-paused:bool
        can-transfer-nft-create-role:bool
        ;;Supply
        supply:integer
        ;;Roles
        create-role-account:string
        role-transfer-amount:integer
        ;;Units
        nonces-used:integer
    )
    (defschema DPSF|BalanceSchema
        @doc "Schema that Stores Account Balances for DPSF Tokens (Semi Fungibles)\
            \ Key for the Table is a string composed of: <DPSF id> + UTILS.BAR + <account> \
            \ This ensure a single entry per DPSF id per account."

        unit:[object{DPSF|Schema}]
        ;;Special Roles
        role-nft-add-quantity:bool      ;;add quantity for a specific SFT
        role-nft-burn:bool              ;;burn qunatity for a specific SFT
        role-nft-create:bool            ;;create a new SFT (just create, with no quantity)
        role-nft-update:bool            ;;allows update of Metadata of SFT
        role-nft-recreate:bool          ;;allows to recreate the whole SFT (meta-data and attributes)
        role-modify-royalties:bool      ;;allows to modify royalty value for the whole a specific SFT
        role-set-new-uri:bool           ;;allows to set new URIs of specific SFTs
        role-modify-creator:bool        ;;allows to modify the creator of a specific SFT
        role-transfer:bool              ;;allows to modify the transfer role of a specific SFT
        ;;States
        frozen:bool                     ;;stores if the account is frozen for this specific Collection
    )
    (defschema DPSF|Schema
        nonce:integer
        balance:integer
        meta-data:[object]
        attributes:[object]
    )
    ;;Used for non existing SemiFungible Account
    (defconst DPMF|NEGATIVE
        { "nonce": -1
        , "balance": -1
        , "meta-data": [{}]
        , "attributes": [{}] }
    )
;;  3]TABLES Definitions
    (deftable DPSF|PoliciesTable:{DPSF|PolicySchema})
    ;;[S] DPMF Tables
    (deftable DPSF|PropertiesTable:{DPSF|PropertiesSchema})
    (deftable DPSF|BalanceTable:{DPSF|BalanceSchema})

)

;;Policies Table
(create-table DPSF|PoliciesTable)
;;[S] DPSF Tables
(create-table DPSF|PropertiesTable)
(create-table DPSF|BalanceTable)