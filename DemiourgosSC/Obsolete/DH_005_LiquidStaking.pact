(module DH_SC_LiquidStaking GOVERNANCE
    
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability"
        false
    )

    (defcap LIQUID-STAKING ()
        @doc "Capability enforcing the KadenaLiquidStaking Administrator"
        (enforce-one
            "Keyset not valid for KadenaLiquidStaking Smart DPTS Account Operations"
            [
                (enforce-guard (keyset-ref-guard DALOS.DEMIURGOI))
                (enforce-guard (keyset-ref-guard SC_KEY_LIQUID))
            ]
        )
    )

    ;;1]CONSTANTS Definitions
    ;;Smart-Contract Key and Name Definitions

        (defconst SC_KEY "free.DH_SC_KadenaLiquidStaking-Keyset");;DPTS Account 3 Management - KadenaLiquidStaking DPTS Account
        (defconst SC_NAME "KadenaLiquidStaking")
        (defconst SC_KDA-NAME "k:a3506391811789fe88c4b8507069016eeb9946f3cb6d0b6214e700c343187c98")
    
    ;;Table KEYS
    (defconst LLV "LiquidLedgerValues")
    (defconst LKID "LiquidKadenaIDs")

    ;;2]SCHEMAS Definitions
    (defschema DemiourgosLiquidKadenaIDs
        dalos-wrapped-kadena:string
        dalos-liquid-kadena:string
    )
    (defschema LiquidLedgerSchema
        resident-dwk:decimal
        unbonding-dwk:decimal
    )
    ;;3]SCHEMAS Definitions
    (deftable KadenaIDs:{DemiourgosLiquidKadenaIDs})
    (deftable LiquidLedger:{LiquidLedgerSchema})
    
    ;;==================IDENTIFIERS=================
    ;;      UR_DalosWrappedKadenaID|UR_DalosLiquidKadenaID
    ;;
    (defun UR_DalosWrappedKadenaID:string ()
        @doc "Returns as string the Dalos-Wrapped-Kadena ID"
        (at "dalos-wrapped-kadena" (read KadenaIDs LKID ["dalos-wrapped-kadena"]))
    )
    (defun UR_DalosLiquidKadenaID:string ()
        @doc "Returns as string the Dalos-Liquid-Kadena ID"
        (at "dalos-liquid-kadena" (read KadenaIDs LKID ["dalos-liquid-kadena"]))
    )
    ;;==================LIQUID-LEDGER===============
    ;;      UR_ResidentDWK|UR_UnbondingDWK
    ;;
    (defun UR_ResidentDWK:decimal ()
        @doc "Returns as decimal the amount of Resident Dalos-Wrapped-Kadena"
        (at "resident-dwk" (read LiquidLedger LLV ["resident-ouro"]))
    )
    (defun UR_UnbondingDWK:decimal ()
        @doc "Returns as decimal the amount of Unbonding Dalos-Wrapped-Kadena"
        (at "unbonding-dwk" (read LiquidLedger LLV ["unbonding-dwk"]))
    )
    (defun UR_LiquidIndex:decimal ()
        @doc "Returns the value of the LiquidIndex with 24 decimals"
        (let
            (
                (dalos-liquid-kadena-supply:decimal (OUROBOROS.UR_TrueFungibleSupply (UR_DalosLiquidKadenaID)))
                (r-dwk-supply:decimal (UR_ResidentDWK))
            )
            (if
                (= dalos-liquid-kadena-supply 0.0)
                (floor 0.0 24)
                (floor (/ r-dwk-supply dalos-liquid-kadena-supply) 24)
            )
        )
    )

    (defun AX_InitialiseKadenaLiquidStaking:[string] (patron:string)
        @doc "Initialises the DALOS Kadena Liquid Staking"

        (require-capability (LIQUID-STAKING))
        ;:Deploy the <KadenaLiquidStaking> Smart DPTS Account
        (C_DeploySmartDPTSAccount SC_NAME (keyset-ref-guard SC_KEY) SC_KDA-NAME)
        (let
            (
                (WrappedKadenaID:string
                    (C_IssueTrueFungible
                        patron
                        SC_NAME
                        "DalosWrappedKadena"
                        "DWK"
                        12
                        false    ;;can-change-owner
                        false    ;;can-upgrade
                        true     ;;can-add-special-role
                        false    ;;can-freeze
                        false    ;;can-wipe
                        false    ;;can-pause
                    )
                )
                (StakedKadenaID:string
                    (C_IssueTrueFungible
                        patron
                        SC_NAME
                        "DalosLiquidKadena"
                        "DLK"
                        12
                        false    ;;can-change-owner
                        false    ;;can-upgrade
                        true     ;;can-add-special-role
                        false    ;;can-freeze
                        false    ;;can-wipe
                        false    ;;can-pause
                    )
                )
            )
            ;;SetTrinityTable
            (insert KadenaIDs LKID
                {"dalos-wrapped-kadena"         : WrappedKadenaID
                ,"dalos-liquid-kadena"          : StakedKadenaID}
            )
            ;;SetAutostakeTable
            (insert AutostakeLedger AUTOSTAKEHOLDINGS
                {"resident-dwk"                 : 0.0
                ,"unbonding-dwk"                : 0.0}  
            )
            [WrappedKadenaID StakedKadenaID]
        )
    )
)

(create-table LiquidLedger)
(create-table KadenaIDs)