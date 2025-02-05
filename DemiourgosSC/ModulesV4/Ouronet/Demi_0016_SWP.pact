;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module SWP GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_SWP            (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_SWP            (keyset-ref-guard SWP|SC_KEY))

    (defconst SWP|SC_KEY            (+ UTILS.NS_USE ".dh_sc_swapper-keyset"))
    (defconst SWP|SC_NAME           "Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ")
    (defconst SWP|SC_KDA-NAME       (create-principal SWP|GUARD))
    (defconst SWP|GUARD             (create-capability-guard (SWP|NATIVE-AUTOMATIC)))
    (defconst SWP|PBL               "9G.4Bl3bJ5o1eIoBkhynF39lFdvkA3E0n8m5fBr9iG4D6Ahj3xfop72b98rr33vFFLjqaiozE1btl7lgzKcjHwjzu5GuFqvMb43v9CHHe8je3buLbHMkcAyKdEMD85yIHsb9ty58Kzyado3ho1n1mf9GzpeegMrpK9wDFteeKexdL7HHq8GF7ptD2w45IkMf2A8j4pm7E6vJ1ytCckhclD9nd3JzL2j5cyLxawnE76leKmEmFaxqnF76yyJe5Mu6yLkg2yonJa6vx6jd1kr0hdEf81o42Asr8EcCDeeqD4nAehC3w3pFDMwbln4Mbl6t55GHGephx99LJKH1ojhlMlnyC4bbJFAiyD1h6vs0o7mKAaazFG9y0vfbvM9imcs1vCMmpk2cGDAAAqH6iJe32ugHA3AECEgCvxCskw4Mfx6Cc4rx2BkmKMlxeHqyDceI6wa2qjzuyI80vKg6H6tMwEg48H0ywIMDyxteDfHav08eEJE2lljEIAc1jxLlLcosbiknAyxJvu8g7kA4oAlcio2jI8lMxp76vosd5FxpatowuFktILfyCFyHvKfcozy")
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|SWP_ADMIN))
    )
    (defcap GOV|SWP_ADMIN ()
        (enforce-one
            "SWP Swapper Admin not satisfed"
            [
                (enforce-guard GOV|MD_SWP)
                (enforce-guard GOV|SC_SWP)
            ]
        )
    )
    (defcap SWP|GOV ()
        @doc "Governor Capability for the Autostake Smart DALOS Account"
        true
    )
    (defcap SWP|NATIVE-AUTOMATIC ()
        @doc "Autonomic management of <kadena-konto> of SWAPPER Smart Account"
        true
    )
    ;;{G3}
    (defun SWP|SetGovernor (patron:string)
        (DALOS.DALOS|C_RotateGovernor
            patron
            SWP|SC_NAME
            (UTILS.GUARD|UEV_Any
                [
                    (create-capability-guard (SWP|GOV))
                    (P|UR "SWPI|RemoteSwapGovernor")
                    (P|UR "SWPL|RemoteSwapGovernor")
                    (P|UR "SWPS|RemoteSwapGovernor")
                ]
            )
        )
    )
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|SWP_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()              
        true
    )
    ;;
    ;;{1}
    (defschema SWP|PropertiesSchema
        principals:[string]
        liquid-boost:bool
        spawn-limit:decimal
        inactive-limit:decimal
    )
    (defschema SWP|PairsSchema
        @doc "Key = <token-a-id> + UTILS.BAR + <token-b-id>"
        owner-konto:string
        can-change-owner:bool
        can-add:bool
        can-swap:bool
        genesis-weights:[decimal]
        weights:[decimal]
        genesis-ratio:[object{SWP|PoolTokens}]
        pool-tokens:[object{SWP|PoolTokens}]
        token-lp:string
        token-lps:[string]
        fee-lp:decimal
        fee-special:decimal
        fee-special-targets:[object{SWP|FeeSplit}]
        fee-lock:bool
        unlocks:integer
        special:bool
        governor:guard
        amplifier:decimal
        primality:bool
    )
    (defschema SWP|PoolTokens
        token-id:string
        token-supply:decimal
    )
    (defschema SWP|FeeSplit
        target:string
        value:integer
    )
    (defschema SWP|PoolsSchema
        pools:[string]
    )
    ;;{2}
    (deftable SWP|Properties:{SWP|PropertiesSchema})
    (deftable SWP|Pairs:{SWP|PairsSchema})
    (deftable SWP|Pools:{SWP|PoolsSchema})
    ;;{3}
    (defconst SWP|INFO "SwapperInformation")
    (defconst P2 "P2")
    (defconst P3 "P3")
    (defconst P4 "P4")
    (defconst P5 "P5")
    (defconst P6 "P6")
    (defconst P7 "P7")
    (defconst S2 "S2")
    (defconst S3 "S3")
    (defconst S4 "S4")
    (defconst S5 "S5")
    (defconst S6 "S6")
    (defconst S7 "S7")
    (defconst SWP|EMPTY-TARGET
        { "target": UTILS.BAR
        , "value": 1 }
    )
    ;;
    ;;{4}
    
    ;;{5}
    
    
    ;;{6}
    (defcap SWP|F>OWNER (swpair:string)
        (CAP_Owner swpair)
    )
    ;;{7}
    
    
    ;;
    ;;{8}
    (defun CAP_Owner (swpair:string)
        (DALOS.DALOS|CAP_EnforceAccountOwnership (UR_OwnerKonto swpair))
    )
    ;;{9}
    ;;{10}
    
    ;;{11}
    (defun SWP|UC_SplitTokenIDs:[string] (swpair:string)
        (drop 1 (UTILS.LIST|UC_SplitString UTILS.BAR swpair))
    )
    
    (defun SWP|UC_Variables (n:integer what:bool)
        (let
            (
                (p2:[string] (UR_Pools P2))
                (p3:[string] (UR_Pools P3))
                (p4:[string] (UR_Pools P4))
                (p5:[string] (UR_Pools P5))
                (p6:[string] (UR_Pools P6))
                (p7:[string] (UR_Pools P7))
                (s2:[string] (UR_Pools S2))
                (s3:[string] (UR_Pools S3))
                (s4:[string] (UR_Pools S4))
                (s5:[string] (UR_Pools S5))
                (s6:[string] (UR_Pools S6))
                (s7:[string] (UR_Pools S7))
            )
            (cond
                ((= n 2) (if what [(UR_Pools P2) P2] [(UR_Pools S2) S2]))
                ((= n 3) (if what [(UR_Pools P3) P3] [(UR_Pools S3) S3]))
                ((= n 4) (if what [(UR_Pools P4) P4] [(UR_Pools S4) S4]))
                ((= n 5) (if what [(UR_Pools P5) P5] [(UR_Pools S5) S5]))
                ((= n 6) (if what [(UR_Pools P6) P6] [(UR_Pools S6) S6]))
                ((= n 7) (if what [(UR_Pools P7) P7] [(UR_Pools S7) S7]))
                true
            )
            (if (= n 2)
                (if what
                    [p2 P2]
                    [s2 S2]
                )
                (if (= n 3)
                    (if what
                        [p3 P3]
                        [s3 S3]
                    )
                    (if (= n 4)
                        (if what
                            [p4 P4]
                            [s4 S4]
                        )
                        (if (= n 5)
                            (if what
                                [p5 P5]
                                [s5 S5]
                            )
                            (if (= n 6)
                                (if what
                                    [p6 P6]
                                    [s6 S6]
                                )
                                (if what
                                    [p7 P7]
                                    [s7 S7]
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    ;;{12}
    
    
    ;;{13}
    
    ;;
    ;;{14}
    
    ;;{15}
    ;;{16}
    
)

(create-table P|T)
(create-table SWP|Properties)
(create-table SWP|Pairs)
(create-table SWP|Pools)
