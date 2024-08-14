(module GAS GOVERNANCE
    @doc "GAS is the the Demiourgos.Holdings Smart-Contract for the management of GAS on the DPTS Virtual Blockchain"

    ;;0]GOVERNANCE-ADMIN
    ;;
    ;;      GOVERNANCE|DPTS_ADMIN
    ;;
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
        \ Set to DPTS_ADMIN so that only Module Key can enact an upgrade"
        false
    )
    (defcap GAS_ADMIN ()
        (enforce-guard (keyset-ref-guard SC_KEY))
    )

    ;;1]CONSTANTS Definitions
    ;;Smart-Contract Key and Name Definitions
    (defconst SC_KEY "free.DH-Master-Keyset")
    (defconst SC_NAME "GasMaker")

    ;;TABLE-KEYS
    (defconst VGD "VirtualGasData")

    ;;2]SCHEMAS Definitions
    (defschema DPTS-vGAS
        @doc "Schema that stores DPTF Identifier for the Gas Token of the Virtual Blockchain \
        \ The boolean <vgastg> toggles wheter or not the virtual gas is enabled or not"

        vgasid:string
        vgastg:bool
    )

    ;;3]TABLES Definitions
    (deftable VGASTable:{DPTS-vGAS})

    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      CAPABILITIES                                                                                                                                ;;
    ;;                                                                                                                                                  ;;
    ;;      CORE                                    Module Core Capabilities                                                                            ;;
    ;;      BASIC                                   Basic Capabilities represent singular capability Definitions                                        ;;
    ;;      COMPOSED                                Composed Capabilities are made of one or multiple Basic Capabilities                                ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      BASIC                                                                                                                                       ;;
    ;;                                                                                                                                                  ;;
    ;;      GAS_TOGGLE                              Enforces Gas is turned either ON or OFF                                                             ;;
    ;;      GAS_ID_OFF                              Enforces that GAS ID is not set                                                                     ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;


    (defcap GAS_TOGGLE (toggle:bool)
        @doc "Enforces Gas is turned either ON or OFF"
        (let
            (
                (x:bool (UR_GasToggle))
            )
            (if (= toggle true)
                (enforce (= x toggle) "Gas is not turned on !")
                (enforce (= x toggle) "Gas is not turned off !")
            )
        )
    )
    (defcap GAS_ID_OFF ()
        @doc "Enforces that GAS ID is not set"
        (let
            (
                (x:string (UR_GasID))
            )
            (enforce (= x "") "Gas ID is already set")
        )
    )

    (defcap GAS_ID_ON ()
        @doc "Enforces that GAS ID is already set"
        (let
            (
                (x:string (UR_GasID))
            )
            (enforce (!= x "") "Gas ID isnt set yet")
        )
    )

    (defcap GAS_SET_ID (identifier:string)
        (DPTF.UV_TrueFungibleIdentifier identifier)
        (compose-capability (GAS_ADMIN))
        (compose-capability (GAS_ID_OFF))
    )

    (defcap GAS_SET_NEWID (identifier:string)
        (DPTF.UV_TrueFungibleIdentifier identifier)
        (compose-capability (GAS_ADMIN))
        (compose-capability (GAS_ID_ON))
    )

    (defcap GAS_TURN_ON ()
        (compose-capability (GAS_ADMIN))
        (compose-capability (GAS_TOGGLE false))
    )

    (defcap GAS_TURN_OFF ()
        (compose-capability (GAS_ADMIN))
        (compose-capability (GAS_TOGGLE true))
    )


    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      PRIMARY Functions                       Stand-Alone Functions                                                                               ;;
    ;;                                                                                                                                                  ;;
    ;;      0)UTILITY                               Free Functions: can can be called by anyone. (Compute|Print|Read|Validate Functions)                ;;
    ;;                                                  No Key|Guard required.                                                                          ;;
    ;;      1)ADMINISTRATOR                         Administrator Functions: can only be called by module administrator.                                ;;
    ;;                                                  DPTF_ADMIN Capability Required.                                                                 ;;
    ;;      2)CLIENT                                Client Functions: can be called by any DPMF Account.                                                ;;
    ;;                                                  DPTF_CLIENT Capability Required.                                                                ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      SECONDARY Functions                     Auxiliary Functions: cannot be called on their own                                                  ;;
    ;;                                                                                                                                                  ;;
    ;;      3)AUXILIARY                             Are Part of Client Function                                                                         ;;
    ;;                                                  Capabilities are required to use auxiliary Functions                                            ;;
    ;;                                                                                                                                                  ;;      
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      Functions Names are prefixed, so that they may be better visualised and understood.                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;      UTILITY-COMPUTE                         UC_FunctionName                                                                                     ;;
    ;;      UTILITY-PRINT                           UP_FunctionName                                                                                     ;;
    ;;      UTILITY-READ                            UR_FunctionName                                                                                     ;;
    ;;      UTILITY-VALIDATE                        UV_FunctionName                                                                                     ;;
    ;;      ADMINISTRATION                          A_FunctionName                                                                                      ;;
    ;;      CLIENT                                  C_FunctionName                                                                                      ;;
    ;;      AUXILIARY                               X_FunctionName                                                                                      ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      UTILITY FUNCTIONS                                                                                                                           ;;
    ;;                                                                                                                                                  ;;
    (defun UR_GasID:string ()
        @doc "Returns as string the Gas Identifier"
        (at "vgasid" (read DPTS-VGASTable VGD ["vgasid"]))
    )
    (defun UR_GasToggle:bool ()
        @doc "Returns as boolean the Gas Toggle State"
        (at "vgastg" (read DPTS-VGASTable VGD ["vgastg"]))
    )

    (defun A_InitialiseGAS ()
    @doc "Initialises the VGAS Table"
        (with-capability (GAS_ADMIN)
            (insert VGASTable VGD
                {"vgasid"           : ""
                ,"vgastg"           : false}
            )
        )
    )

    (defun A_SetVGasID (identifier:string)
        @doc "Sets the Gas Identifier for the Virtual Blockchain for the first time"
        (with-capability (GAS_SET_ID identifier)
            (with-read VGASTable VGD
                {"vgasid"           : id
                ,"vgastg"           : tg}
                (write VGASTable VGD
                    {"vgasid"           : identifier
                    ,"vgastg"           : tg}
                )
            )
        )
    )

    (defun A_ChangeVGasID (identifier:string)
        @doc "Changes the Gas Identifier for the Virtual Blockchain"
        (with-capability (GAS_SET_NEWID identifier)
            (let
                (
                    (current-gas-id:string (UR_GasID))
                )
                (enforce (!= current-gas-id identifier))
                (with-read VGASTable VGD
                    {"vgasid"           : id
                    ,"vgastg"           : tg}
                    (write VGASTable VGD
                        {"vgasid"           : identifier
                        ,"vgastg"           : tg}
                    )
                )
            )
        )
    )

    (defun A_TurnGasOn ()
        @doc "Turns Gas collection ON"
        (with-capability (GAS_TURN_ON)
            (with-read VGASTable VGD
                {"vgasid"           : id
                ,"vgastg"           : tg}
                (write VGASTable VGD
                    {"vgasid"           : id
                    ,"vgastg"           : (not tg)}
                )
            )
        )
    )

    (defun A_TurnGasOff ()
        @doc "Turns Gas collection OFF"
        (with-capability (GAS_TURN_OFF)
            (with-read VGASTable VGD
                {"vgasid"           : id
                ,"vgastg"           : tg}
                (write VGASTable VGD
                    {"vgasid"           : id
                    ,"vgastg"           : (not tg)}
                )
            )
        )
    )

)

(create-table VGASTable)