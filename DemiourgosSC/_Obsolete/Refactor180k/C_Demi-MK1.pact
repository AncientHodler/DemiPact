(module COMMENTED_DEMIOURGOS_MK1 GOVERNANCE
    (defcap GOVERNANCE ()
        (compose-capability (DEMIURGOI))
    )
    (defcap DEMIURGOI ()
        (enforce-guard G_DEMIURGOI)
    )
    (defconst G_DEMIURGOI   (keyset-ref-guard DALOS|DEMIURGOI))
    (defconst DALOS|DEMIURGOI "free.DH_Master-Keyset")


    ;;SCHEMAS COMMENTED
    (defschema DALOS|PropertiesSchema
        ;;Stores the UNITY Token ID
        unity-id:string

        ;;Stores the Gas-Source-ID
        ;;The Gas-Source is the DPTF Token that is used to generate GAS
        ;;In this case the token is OUROBOROS
        gas-source-id:string

        ;;Stores OUROBOROS price
        gas-source-id-price:decimal

        ;;Stores the GAS ID, the GAS token being IGNIS
        gas-id:string

        ;;Stores the Reward-Bearing Token that exists in the Atspair, that has OUROBOROS as Reward Token
        ;;This Token is AURYN
        ats-gas-source-id:string

        ;;Stores the Elite-Reward Bearing Token that exists in the Atspair, that has Auryn as Reward Token
        ;;This Token is ELITE-AURYN
        elite-ats-gas-source-id:string

        ;;Stores the Wrapped Kadena ID
        wrapped-kda-id:string

        ;:Stores the Liquid Kadena ID
        liquid-kda-id:string
    )

    (defschema DALOS|PricesSchema
        @doc "Schema for storing the DALOS Prices.
        Certain Actions on the DALOS Virtual Blockchain command certain prices in KDA.
        This Schema and its subsequent Table, store these prices."

        ;;The Price for deploying a Standard DALOS Account
        standard:decimal

        ;;The Price for deploying a Smart DALOS Account
        smart:decimal

        ;;The Price for issuing a DPTF (true fungible) Token
        dptf:decimal

        ;;The Price for issuing a DPMF (meta fungible) Token
        dpmf:decimal

        ;;The Price for issuing a DPSF (semi fungible) Token
        dpsf:decimal

        ;;The Price for issuing a DPNF (non fungible) Token
        dpnf:decimal

        ;;The Price for setting up a Blueticker for a Token
        blue:decimal
    )
)