(module DalosKeys GOVERNANCE

    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability"
        false
    )

    (defschema DalosCommand
        role:string
        public-key:string
    )
    (deftable DalosLedger:{DalosCommand})

    (defconst CTO "k:50d6c59b21e5e6e55baecaa75a1007de37576bde12d8230dc82459cc01b9484b")
    (defconst HOV "k:0cb30c0121ff919266121a99ff9359871818932211df94dae4137c29bc0e8f7e")

    (defconst KY_DEMIOURGOI "free.DH_Master-Keyset")
    (defconst NM_DEMIOURGOI (create-principal (keyset-ref-guard SC_KEY)))

    ;;Smart Contracts
    (defconst KY_SC001 "free.DH_SC_Ouroboros-Keyset")
    (defconst NM_SC001 "Ouroboros")
    (defconst PB_SC001 "7c9cd45184af5f61b55178898e00404ec04f795e10fff14b1ea86f4c35ff3a1e")

    (defconst KY_SC002 "free.DH_SC_GAS-Keyset")
    (defconst NM_SC002 "GasTanker")
    (defconst PB_SC002 "e0eab7eda0754b0927cb496616a7ab153bfd5928aa18d19018712db9c5c5c0b9")

    (defconst KY_SC003 "free.DH_SC_KadenaLiquidStaking-Keyset")
    (defconst NM_SC003 "KadenaLiquidStaking")
    (defconst PB_SC003 "a3506391811789fe88c4b8507069016eeb9946f3cb6d0b6214e700c343187c98")

    (defconst KY_SC003 "free.DH_SC_Autostake-Keyset")
    (defconst NM_SC003 "SnakeAutostake")
    (defconst PB_SC003 "89faf537ec7282d55488de28c454448a20659607adc52f875da30a4fd4ed2d12")

    (defconst KY_SC004 "free.DH_SC_Vesting-Keyset")
    (defconst NM_SC005 "SnakeVesting")
    (defconst PB_SC006 "4728327e1b4790cb5eb4c3b3c531ba1aed00e86cd9f6252bfb78f71c44822d6d")

    (defun QuadKeys:bool (k1:keyset k2:keyset k3:keyset k4:keyset)
        (enforce-one
            "Checking 3 of 4 for matching"
            [
                (with-capability (COMPOSE)
                    (enforce-guard k1)
                    (enforce-guard k2)
                    (enforce-guard k3)
                )
                (with-capability (COMPOSE)
                    (enforce-guard k1)
                    (enforce-guard k2)
                    (enforce-guard k4)
                )
                (with-capability (COMPOSE)
                    (enforce-guard k1)
                    (enforce-guard k3)
                    (enforce-guard k4)
                )
                (with-capability (COMPOSE)
                    (enforce-guard k2)
                    (enforce-guard k3)
                    (enforce-guard k4)
                )
            ]
        )
    )
)

(create-table DalosLedger)