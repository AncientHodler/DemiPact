(module DPMF GOVERNANCE
    @doc "Core_DPMF is the Demiourgos.Holdings Module for the management of DPMF Tokens \
    \ DPMF-Tokens = Demiourgos Pact Meta Fungible Tokens \
    \ DPMF-Tokens mimic the functionality of the Meta-ESDT Token introduced by MultiversX (former Elrond) Blockchain"

    ;;CONSTANTS
    ;;Smart-Contract Key and Name Definitions
    (defconst SC_KEY "free.DH-Master-Keyset")
    (defconst SC_NAME "Demiourgos-Pact-Meta-Fungible")

    ;;Schema Definitions
    ;;Demiourgos Pact META Fungible Token Standard - DPTF
    (defschema DPMF-BalanceSchema
        @doc "Schema that Stores Account Balances for DPMF Tokens (Meta-Fungibles)\
        \ Key for the Table is a string composed of: \
        \ <DPTS Identifier> + IASPLITTER <Nonce> + IASPLITTER + <account> \
        \ This ensure a single entry per DPMF Identifier-and-Nonce per account."

        balance:decimal                     ;;Stores DPMF token balance for Account
        meta-data:object                    ;;Stores DPMF token meta-data as Object
        guard:guard                         ;;Stores Guard for DPFS Account
        ;;Special Roles
        role-nft-add-quantity:bool          ;;when true, Account can add quantity for the specific DPMF Token
        role-nft-burn:bool                  ;;when true, Account can burn DPMF Tokens locally
        role-nft-create:bool                ;;when true, Account can create DPMF Tokens locally
        role-transfer:bool                  ;;when true, Transfer is restricted. Only accounts with true Transfer Role
                                            ;;can transfer token, while all other accounts can only transfer to such accounts
        ;;States
        frozen:bool                         ;;Determines wheter Account is frozen for DPTF Token Identifier
    )

)