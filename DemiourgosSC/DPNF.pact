(module DPMF GOVERNANCE
    @doc "Core_DPNF is the Demiourgos.Holdings Module for the management of DPNF Tokens \
    \ DPNF-Tokens = Demiourgos Pact Meta Fungible Tokens \
    \ DPNF-Tokens mimic the functionality of the NFTs introduced by MultiversX (former Elrond) Blockchain"

    ;;CONSTANTS
    ;;Smart-Contract Key and Name Definitions
    (defconst SC_KEY "free.DH-Master-Keyset")
    (defconst SC_NAME "Demiourgos-Pact-Non-Fungible")

    ;;Schema Definitions
    ;;Demiourgos Pact NON Fungible Token Standard - DPNF
    (defschema DPNF-BalanceSchema
        @doc "Schema that Stores Account Balances for DPNF Tokens (Non-Fungibles)\
        \ Key for the Table is a string composed of: \
        \ <DPTS Identifier> + IASPLITTER <Nonce> + IASPLITTER + <account> \
        \ This ensure a single entry per DPSF Identifier-and-Nonce per account."

        meta-data:object                    ;;Stores DPSF token meta-data as Object
        guard:guard                         ;;Stores Guard for DPFS Account
        ;;Special Roles
        role-nft-add-uri:bool               ;;when true, Account can add uri-s for a specific DPNF Token.
        role-nft-burn:bool                  ;;when true, Account can burn DPNF Tokens locally
        role-nft-create:bool                ;;when true, Account can create DPNF Tokens locally
        role-nft-update-attributes:bool     ;;when true, Account can change the attributes of a speicific DPNF Token
        role-transfer:bool                  ;;when true, Transfer is restricted. Only accounts with true Transfer Role
                                            ;;can transfer token, while all other accounts can only transfer to such accounts
        ;;States
        frozen:bool                         ;;Determines wheter Account is frozen for DPTF Token Identifier
    )

)