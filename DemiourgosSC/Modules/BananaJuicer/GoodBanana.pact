(module BANANA GOVERNANCE
    @doc "The Banana Module demonstrates how to use the DALOS Token Infrastructure \
    \ to create custom smart contracts for performing specific token operations. \
    \ These operations interact with the SMART DALOS Account linked to this module \
    \ and work because they are explicitly defined here. \
    \ \
    \ The system is designed to restrict SMART DALOS Account interactions \
    \solely to the module that defines its Governor Guard \
    \ \
    \ \
    \ Ownership of a SMART DALOS Account is controlled by one of three guards: \
    \ \
    \ 1]Its own guard. \
    \ 2]Its sovereign guard (The Soverein represents the the Standard DALOS Account that owns the SMART DALOS Account) \
    \ 3]The Governor Guard. \
    \ \
    \ \
    \ The Governor Guard is automatically derived from a capability provided exclusively by this module. \
    \ As a result, automated interactions with the SMART DALOS Account are only possible \
    \ because this module defines and grants the necessary Governor Guard."

    ;;Module Governance
    (defcap GOVERNANCE ()
        @doc "Capability Enforcing Banana Admin"
        (compose-capability (BANANA|MASTER))
    )
    (defcap BANANA|MASTER ()
        @doc "Banana Master Capability"
        (compose-capability (BANANA-ADMIN))
    )
    (defcap BANANA-ADMIN ()
        (enforce-guard G_BANANA)
    )
    ;;Module Guard
    (defconst G_BANANA   (keyset-ref-guard BANANA|DEMIURGOI))
    ;;Module Keys
    (defconst BANANA|DEMIURGOI BANANA|US_KEY)

    ;;Module Accounts Information
    ;;      STANDARD DALOS Account - The Aser Account
    (defconst BANANA|US_KEY "free.Banana_Master-Keyset")
    (defconst BANANA|US_NAME "Ѻ.üĘИĞαλźĚ₿5ûŤgÂБšΦяĞηчĚłæõЭwъμŞщЯžŠЦэÒËfχтĞx₳UÁùИ6ÄŚЦ¢ЫřзÍэЗ₳Nλțí₱ΘθΞÁŠлτâΓЧЙéλŞк9ЧEř2Ș4ÿp∇REДyEчé¥2rþÉJQełc2þ₱doиãKóйšщÑΔπÊOκïΨЩψÏŞ1vìQÊнз$èČtÄë₿FИΔÚțΔOșчÑĘşнÌ¢")
    (defconst BANANA|US_KDA-NAME "k:59e0417d779c90651e5cd9ca98736362f0262a80b8cdfd300f9f4c977b23c77a")

    ;;      SMART DALOS Account - The Automatic Account
    (defconst BANANA|SC_KEY "free.Banana_Juicer-Keyset")
    (defconst BANANA|SC_NAME "Σ.üĘИĞαλźĚ₿5ûŤgÂБšΦяĞηчĚłæõЭwъμŞщЯžŠЦэÒËfχтĞx₳UÁùИ6ÄŚЦ¢ЫřзÍэЗ₳Nλțí₱ΘθΞÁŠлτâΓЧЙéλŞк9ЧEř2Ș4ÿp∇REДyEчé¥2rþÉJQełc2þ₱doиãKóйšщÑΔπÊOκïΨЩψÏŞ1vìQÊнз$èČtÄë₿FИΔÚțΔOșчÑĘşнÌ¢")
    ;(defconst BANANA|SC_KDA-NAME "k:65235cc5131cba0404592f9ef56391be733fde51d47498ebdaa2f15528ccf697")
    (defconst BANANA|SC_KDA-NAME (create-principal BANANA|GUARD))

    ;;External Module Usage
    (use free.DALOS)
    (use free.BASIS)
    (use free.AUTOSTAKE)

    ;;
    ;;
    ;;


    ;;Simple True Capabilities - NONE
    ;;
    ;;Policies - NONE
    ;;
    ;;Module GOVERNOR
    ;;Setting up the governor allows interaction with the BANANA|SC_NAME only from functions
    ;;      executed from within this module, if they receive
    ;;      (compose-capability (BANANA|GOV))
    (defcap BANANA|GOV ()
        @doc "Banana Module Governor Capability for its Smart DALOS Account"
        true
    )
    (defun BANANA|SetGovernor (patron:string)
        (DALOS.DALOS|C_RotateGovernor
            patron
            BANANA|SC_NAME
            (create-capability-guard (BANANA|GOV))
        )
    )
    ;;Setting up Smart DALOS Account associated KDA address automation usage, in case required
    (defcap BANANA|NATIVE-AUTOMATIC ()
        @doc "Capability needed for auto management of the <kadena-konto> \
            \ associated with the <Banana-Juicer> Smart DALOS Account"
        true
    )
    (defconst BANANA|GUARD (create-capability-guard (BANANA|NATIVE-AUTOMATIC)))
    ;;
    ;;
    ;; START
    ;;
    ;;
    ;;Table Keys and Table Management
;;  1]CONSTANTS Definitions
    (defconst BANANA|INFO "BananaInformation")
;;  2]SCHEMAS Definitions
    (defschema BANANA|IDs
        banana:string
        juice:string
    )
;;  3]TABLES Definitions
    (deftable BANANA|TableIDs:{BANANA|IDs})
    ;;
    ;;
    ;;            BANANA            Submodule
    ;;
    ;;            CAPABILITIES      <>
    ;;            FUNCTIONS         [6]
    ;;========[D] RESTRICTIONS=================================================;;
    ;;            Capabilities FUNCTIONS                [CAP]
    ;;            Function Based CAPABILITIES           [CF](have this tag)
    ;;            Enforcements & Validations FUNCTIONS  [UEV]
    ;;            Composed CAPABILITIES                 [CC](dont have this tag)
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;            Data Read FUNCTIONS                   [UR]
    ;;            Data Read and Computation FUNCTIONS   [URC] and [UC]
    ;;            Data Creation|Composition FUNCTIONS   [UCC]
    ;;        [3] Administrative Usage FUNCTIONS        [A]
    ;;        [1] Client Usage FUNCTIONS                [C]
    ;;        [1] Auxiliary Usage FUNCTIONS             [X]
    ;;=========================================================================;;
    ;;
    ;;            START
    ;;
    ;;========[D] RESTRICTIONS=================================================;;
    ;;     (NONE) Capabilities FUNCTIONS                [CAP]
    ;;     (NONE) Function Based CAPABILITIES           [CF](have this tag)
    ;;     (NONE) Enforcements & Validations FUNCTIONS  [UEV]
    ;;     (NONE) Composed CAPABILITIES                 [CC](dont have this tag)
    (defcap BANANA|JUICER ()
        (compose-capability (BANANA|GOV))
    )
    ;;========[D] DATA FUNCTIONS===============================================;;
    ;;        [2] Data Read FUNCTIONS                   [UR]
    (defun BANANA|UR_BananaID:string ()
        @doc "Returns the Banana ID"
        (at "banana" (read BANANA|TableIDs BANANA|INFO ["banana"]))
    )
    (defun BANANA|UR_JuiceID:string ()
        @doc "Returns the BananaJuice ID"
        (at "juice" (read BANANA|TableIDs BANANA|INFO ["juice"]))
    )
    ;;        [1] Data Read and Computation FUNCTIONS   [URC] and [UC]
    (defun BANANA|UC_JuiceAmount (bananas:decimal)
        @doc "Computes Juice Amount from Banana Amount"
        (let
            (
                (juice-precision:integer (BASIS.DPTF-DPMF|UR_Decimals (BANANA|UR_JuiceID) true))
                (raw-amount:decimal (* bananas 10.0))
            )
            (floor raw-amount juice-precision)
        )
    )
    ;;     (NONE) Data Creation|Composition FUNCTIONS   [UCC]
    ;;        [3] Administrative Usage FUNCTIONS        [A]
    (defun BANANA|A_Init (patron:string)
        @doc "Initialises the Module by setting up its Governor"
        (BANANA|SetGovernor patron)
        (DALOS.DALOS|C_RotateKadena patron BANANA|SC_NAME BANANA|SC_KDA-NAME)
    )
    (defun BANANA|A_IssueTrueFungibles:[string] (patron:string)
        @doc "Issues the Banana Tokens, using Multi Issue Function"
        (with-capability (BANANA|MASTER)
            (let
                (
                    (tf-ids:[string]
                        (BASIS.DPTF|C_Issue
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
                (BANANA|X_SaveID (at 0 tf-ids) (at 1 tf-ids))
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
                (BASIS.DPTF|C_Mint patron b-id patron 10000.0 true)

                ;;Setting Mint and Burn Roles
                (AUTOSTAKE.DPTF-DPMF|C_ToggleBurnRole patron b-id BANANA|SC_NAME true true)
                (AUTOSTAKE.DPTF|C_ToggleMintRole patron j-id BANANA|SC_NAME true)
            )
        )
    )
    ;;        [1] Client Usage FUNCTIONS                [C]
    (defun BANANA|C_MakeJuice (patron:string juicer:string recipient:string amount:decimal)
        @doc "Take Banana and generates Juice"
        ;;Because BANANA|JUICER composes BANANA|GOV, the functions below will pass, 
        ;;because an enforcement of BANANA|SC_NAME is in place due to how the functions are constructed.
        (with-capability (BANANA|JUICER)
            (let
                (
                    (juice-amount:decimal (BANANA|UC_JuiceAmount amount))
                    (b-id:string (BANANA|UR_BananaID))
                    (j-id:string (BANANA|UR_JuiceID))
                )
        ;;Juicer, Recipient must be Standard DALOS Account
                (DALOS.DALOS|UEV_EnforceAccountType juicer false)
                (DALOS.DALOS|UEV_EnforceAccountType recipient false)
        ;;By default the system enforces that the Patron is also a Standard DALOS account

        ;;Standard Client Account <juicer> transfers Banana to Smart Account <BananaJuicer>
                (AUTOSTAKE.DPTF|CM_Transfer patron b-id juicer BANANA|SC_NAME amount)
        ;;Smart Account <BananaJuicer> burns Banana
                (BASIS.DPTF|C_Burn patron b-id BANANA|SC_NAME amount)
        ;;Smart Account <BananaJuicer> mints BananaJuice
                (BASIS.DPTF|C_Mint patron j-id BANANA|SC_NAME juice-amount false)
        ;;Smart Account <BananaJuicer> transfers BananaJuice to Standard Client Account <recipient>
                (AUTOSTAKE.DPTF|CM_Transfer patron j-id BANANA|SC_NAME recipient juice-amount)
            )
        )
        
    )
    ;;        [1] Auxiliary Usage FUNCTIONS             [X]
    (defun BANANA|X_SaveID (banana-id:string juice-id:string)
        (BASIS.DPTF-DPMF|UEV_id banana-id true)
        (BASIS.DPTF-DPMF|UEV_id juice-id true)
        (require-capability (BANANA|MASTER))
        (insert BANANA|TableIDs BANANA|INFO
            {"banana"           :banana-id
            ,"juice"            :juice-id}
        )
    )
    ;;=========================================================================;;
)

(create-table BANANA|TableIDs)