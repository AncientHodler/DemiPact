(module OUTSIDER GOVERNANCE
    @doc "Testing External Custom Smart Contracts Building Capabilities"

    (defcap GOVERNANCE ()
        @doc "Capability Enforcing Banana Admin"
        ;true
        (compose-capability (BANANA|MASTER))
    )
    (defcap BANANA|MASTER ()
        @doc "Banana Master Capability"
        (enforce-one
            "Keyset not valid for Banana Operations"
            [
                (enforce-guard (keyset-ref-guard OUTSIDER|US_KEY))
                (enforce-guard (keyset-ref-guard OUTSIDER|SC_KEY))
            ]
        )
    )

    ;;Banana Account
    (defconst OUTSIDER|US_KEY "free.Banana_Master-Keyset")
    (defconst OUTSIDER|US_NAME "BananaMaker")
    (defconst OUTSIDER|US_KDA-NAME "k:59e0417d779c90651e5cd9ca98736362f0262a80b8cdfd300f9f4c977b23c77a")

    (defconst OUTSIDER|SC_KEY "free.Banana_Juicer-Keyset")
    (defconst OUTSIDER|SC_NAME "BananaJuicer")
    (defconst OUTSIDER|SC_KDA-NAME "k:65235cc5131cba0404592f9ef56391be733fde51d47498ebdaa2f15528ccf697")

    (defun OUTSIDER|IssueTokenDPTF (patron:string)
        (OUROBOROS.DPTF|C_Issue
            OUTSIDER|US_NAME
            patron
            "Talos"
            "TALOS"
            18
            true
            true
            true
            true
            true
            true
        )
    )
)