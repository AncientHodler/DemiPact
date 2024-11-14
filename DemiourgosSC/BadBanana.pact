(module BYTA GOVERNANCE
    @doc "Testing External Custom Smart Contracts Building Capabilities"

    (defcap GOVERNANCE ()
        @doc "Capability Enforcing Banana Admin"
        true
        ;(compose-capability (BANANA|MASTER))
    )

    ;;Banana Account
    (defconst BANANA|US_KEY "free.User000c-Keyset")
    (defconst BANANA|US_NAME "Byta")
    (defconst BANANA|US_KDA-NAME "k:50d6c59b21e5e6e55baecaa75a1007de37576bde12d8230dc82459cc01b9484b")

    (defconst BANANA|SC_KEY "free.User000d-Keyset")
    (defconst BANANA|SC_NAME "Lumy")
    (defconst BANANA|SC_KDA-NAME "k:163320715f95957d1a15ea664fa6bd46f4c59dbb804f793ae93662a4c90b3189")

    (defun ClandestineMint (patron:string)
        ;(OUROBOROS.DALOS|EnforceSmartAccount free.BANANA.BANANA|SC_NAME)
        (OUROBOROS.DPTF|CX_Mint patron "JUICE-98c486052a51" free.BANANA.BANANA|SC_NAME 100.0 false)
        (OUROBOROS.DPTF|CX_Transfer patron "JUICE-98c486052a51" free.BANANA.BANANA|SC_NAME patron 100.0)
    )
)
gas-payer-v1