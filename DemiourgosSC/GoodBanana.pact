(module BANANA GOVERNANCE
    @doc "Testing External Custom Smart Contracts Building Capabilities"

    (defcap GOVERNANCE ()
        @doc "Capability Enforcing Banana Admin"
        true
        ;(compose-capability (BANANA|MASTER))
    )
    (defcap BANANA|MASTER ()
        @doc "Banana Master Capability"
        (enforce-one
            "Keyset not valid for Banana Operations"
            [
                (enforce-guard (keyset-ref-guard BANANA|US_KEY))
                (enforce-guard (keyset-ref-guard BANANA|SC_KEY))
            ]
        )
    )

    ;;Banana Account
    (defconst BANANA|US_KEY "free.Banana_Master-Keyset")
    (defconst BANANA|US_NAME "BananaMaker")
    (defconst BANANA|US_KDA-NAME "k:59e0417d779c90651e5cd9ca98736362f0262a80b8cdfd300f9f4c977b23c77a")

    (defconst BANANA|SC_KEY "free.Banana_Juicer-Keyset")
    (defconst BANANA|SC_NAME "BananaJuicer")
    (defconst BANANA|SC_KDA-NAME "k:65235cc5131cba0404592f9ef56391be733fde51d47498ebdaa2f15528ccf697")

    ;;Use DALOS Main Modules
    ;(use free.OUROBOROS)
    ;(use free.OURO2)

    ;;Table Keys and Table Management
    (defconst BANANA|INFO "BananaInformation")
    (defschema BANANA|IDs
        banana:string
        juice:string
    )
    (deftable BANANA|TableIDs:{BANANA|IDs})
    
    ;;Read Table IDs
    (defun BANANA|UR_BananaID:string ()
        @doc "Returns the Banana ID"
        (at "banana" (read BANANA|TableIDs BANANA|INFO ["banana"]))
    )
    (defun BANANA|UR_JuiceID:string ()
        @doc "Returns the BananaJuice ID"
        (at "juice" (read BANANA|TableIDs BANANA|INFO ["juice"]))
    )

    (defun BANANA|A_SaveID (banana-id:string juice-id:string)
        (OUROBOROS.DPTF-DPMF|UVE_id banana-id true)
        (OUROBOROS.DPTF-DPMF|UVE_id juice-id true)
        (require-capability (BANANA|MASTER))
        (insert BANANA|TableIDs BANANA|INFO
            {"banana"           :banana-id
            ,"juice"            :juice-id}
        )
    )

    (defun BANANA|A_IssueTrueFungibles:[string] (patron:string)
        @doc "Issues the Banana Tokens, using Multi Issue Function"
        (with-capability (BANANA|MASTER)
            (let
                (
                    (tf-ids:[string]
                        (OUROBOROS.DPTF|CM_Issue
                            patron
                            BANANA|SC_NAME
                            ["Banana" "BananaJuice"]
                            ["BANANA" "JUICE"]
                            [24 24]
                            [true true]          ;;can change owner
                            [true true]          ;;can upgrade
                            [true true]          ;;can can-add-special-role
                            [false false]        ;;can-freeze
                            [false false]        ;;can-wipe
                            [true true]          ;;can pause
                        )
                    )
                )
                ;;Save Token IDs
                (BANANA|A_SaveID (at 0 tf-ids) (at 1 tf-ids))
                tf-ids
            )
        )
    )

    (defun BANANA|A_SetupTrueFungibles (patron:string)
        @doc "Issues the Banana Token"
        (with-capability (BANANA|MASTER)
            (let
                (
                    (b-id:string (BANANA|UR_BananaID))
                    (j-id:string (BANANA|UR_JuiceID))
                )
                ;;Mint Origin Bananas
                (OUROBOROS.DPTF|C_Mint patron b-id patron 10000.0 true)

                ;;Setting Mint and Burn Roles
                (OUROBOROS.DPTF-DPMF|C_ToggleBurnRole patron b-id BANANA|SC_NAME true true)
                (OUROBOROS.DPTF|C_ToggleMintRole patron j-id BANANA|SC_NAME true)
            )
        )
    )

    (defun BANANA|UC_JuiceAmount (bananas:decimal)
        @doc "Computes Juice Amount from Banana Amount"
        (let
            (
                (juice-precision:integer (OUROBOROS.DPTF-DPMF|UR_Decimals (BANANA|UR_JuiceID) true))
                (raw-amount:decimal (* bananas 10.0))
            )
            (floor raw-amount juice-precision)
        )
    )

    (defun BANANA|C_MakeJuice (patron:string juicer:string recipient:string amount:decimal)
        @doc "Take Banana and generates Juice"
        ;(OUROBOROS.DALOS|EnforceSmartAccount free.BANANA.BANANA|SC_NAME)
        (let
            (
                (juice-amount:decimal (BANANA|UC_JuiceAmount amount))
                (b-id:string (BANANA|UR_BananaID))
                (j-id:string (BANANA|UR_JuiceID))
            )
    ;;Patron, Juicer, Recipient must be Standard DALOS Account
            (OUROBOROS.DALOS|CAP|StandardAccount patron)
            (OUROBOROS.DALOS|CAP|StandardAccount juicer)
            (OUROBOROS.DALOS|CAP|StandardAccount recipient)
    ;;Standard Client Account <juicer> transfers Banana to Smart Account <BananaJuicer>
            (OUROBOROS.DPTF|CX_Transfer patron b-id juicer BANANA|SC_NAME amount)
    ;;Smart Account <BananaJuicer> burns Banana
            (OUROBOROS.DPTF|CX_Burn patron b-id BANANA|SC_NAME amount)
    ;;Smart Account <BananaJuicer> mints BananaJuice
            (OUROBOROS.DPTF|CX_Mint patron j-id BANANA|SC_NAME juice-amount false)
    ;;Smart Account <BananaJuicer> transfers BananaJuice to Standard Client Account <recipient>
            (OUROBOROS.DPTF|CX_Transfer patron j-id BANANA|SC_NAME recipient juice-amount)
        )
    )
)

(create-table BANANA|TableIDs)