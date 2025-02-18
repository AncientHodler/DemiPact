;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface OuronetPolicy
    @doc "Interface exposing OuronetPolicy Functions, which are needed for intermodule communication \
    \ Each Module must have these Functions for these Purposes"
    (defschema P|S
        policy:guard
    )
    (defun P|UR:guard (policy-name:string)
        @doc "Reads a Policy from the local module Policy Table"
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        @doc "Adds a Policy in the local module Policy Table"
    )
    (defun P|A_Define ()
        @doc "Defines in each module the policies that are needed for intermodule communication"
    )
)
(interface OuronetDalos
    @doc "Interface Exposing DALOS Module Functions \
    \ UR(Utility-Read), URC(Utility-Read-Compute), UEV(Utility-Enforce-Validate) \
    \ are NOT sorted alphabetically"
    (defschema DPTF|BalanceSchema
        @doc "Schema that Stores Account Balances for DPTF Tokens (True Fungibles)\
            \ Key for the Table is a string composed of: <DPTF id> + BAR + <account> \
            \ This ensure a single entry per DPTF id per account. \
            \ As an Exception OUROBOROS and IGNIS Account Data is Stored at the DALOS Account Level"
        exist:bool
        balance:decimal
        role-burn:bool
        role-mint:bool
        role-transfer:bool
        role-fee-exemption:bool
        frozen:bool
    )
    (defschema IgnisCumulator
        price:decimal
        trigger:bool
        output:list
    )
    ;;
    (defun GOV|Demiurgoi ())
    (defun GOV|DalosKey ())
    (defun GOV|AutostakeKey ())
    (defun GOV|VestingKey ())
    (defun GOV|LiquidKey ())
    (defun GOV|OuroborosKey ())
    (defun GOV|SwapKey ())
    ;;
    (defun GOV|DALOS|SC_KDA-NAME ())
    (defun GOV|DALOS|GUARD ())
    (defun GOV|DALOS|SC_NAME ())
    (defun GOV|ATS|SC_NAME ())
    (defun GOV|VST|SC_NAME ())
    (defun GOV|LIQUID|SC_NAME ())
    (defun GOV|OUROBOROS|SC_NAME ())
    ;;
    (defun GOV|DALOS|PBL ())
    (defun GOV|ATS|PBL ())
    (defun GOV|VST|PBL ())
    (defun GOV|LIQUID|PBL ())
    (defun GOV|OUROBOROS|PBL ())
    (defun GOV|SWP|PBL ())
    ;;
    (defun DALOS|Info ())
    (defun DALOS|VirtualGasData ())
    (defun DALOS|EmptyIgCum:object{IgnisCumulator} ())
    ;;
    ;;
    (defun UR_KadenaLedger:[string] (kadena:string))
    (defun UR_DemiurgoiID:[string] ())
    (defun UR_UnityID:string ())
    (defun UR_OuroborosID:string ())
    (defun UR_OuroborosPrice:decimal ())
    (defun UR_IgnisID:string ())
    (defun UR_AurynID:string ())
    (defun UR_EliteAurynID:string ())
    (defun UR_WrappedKadenaID:string ())
    (defun UR_LiquidKadenaID:string ())
    (defun UR_Tanker:string ())
    (defun UR_VirtualToggle:bool ())
    (defun UR_VirtualSpent:decimal ())
    (defun UR_NativeToggle:bool ())
    (defun UR_NativeSpent:decimal ())
    (defun UR_UsagePrice:decimal (action:string))
    (defun UR_AccountPublicKey:string (account:string))
    (defun UR_AccountGuard:guard (account:string))
    (defun UR_AccountKadena:string (account:string))
    (defun UR_AccountSovereign:string (account:string))
    (defun UR_AccountGovernor:guard (account:string))
    (defun UR_AccountProperties:[bool] (account:string))
    (defun UR_AccountType:bool (account:string))
    (defun UR_AccountPayableAs:bool (account:string))
    (defun UR_AccountPayableBy:bool (account:string))
    (defun UR_AccountPayableByMethod:bool (account:string))
    (defun UR_AccountNonce:integer (account:string))
    (defun UR_Elite (account:string))
    (defun UR_Elite-Class (account:string))
    (defun UR_Elite-Name (account:string))
    (defun UR_Elite-Tier (account:string))
    (defun UR_Elite-Tier-Major:integer (account:string))
    (defun UR_Elite-Tier-Minor:integer (account:string))
    (defun UR_Elite-DEB (account:string))
    (defun UR_TrueFungible:object{DPTF|BalanceSchema} (account:string snake-or-gas:bool))
    (defun UR_TF_AccountSupply:decimal (account:string snake-or-gas:bool))
    (defun UR_TF_AccountRoleBurn:bool (account:string snake-or-gas:bool))
    (defun UR_TF_AccountRoleMint:bool (account:string snake-or-gas:bool))
    (defun UR_TF_AccountRoleTransfer:bool (account:string snake-or-gas:bool))
    (defun UR_TF_AccountRoleFeeExemption:bool (account:string snake-or-gas:bool))
    (defun UR_TF_AccountFreezeState:bool (account:string snake-or-gas:bool))
    ;;
    (defun URC_IgnisGasDiscount:decimal (account:string))
    (defun URC_KadenaGasDiscount:decimal (account:string))
    (defun URC_GasDiscount:decimal (account:string native:bool))
    (defun URC_SplitKDAPrices:[decimal] (account:string kda-price:decimal))
    (defun URC_Transferability:bool (sender:string receiver:string method:bool))
    (defun IGNIS|URC_Exception (account:string))
    (defun IGNIS|URC_ZeroGAZ:bool (id:string sender:string receiver:string))
    (defun IGNIS|URC_ZeroGAS:bool (id:string sender:string))
    (defun IGNIS|URC_IsVirtualGasZeroAbsolutely:bool (id:string))
    (defun IGNIS|URC_IsVirtualGasZero:bool ())
    (defun IGNIS|URC_IsNativeGasZero:bool ())
    ;;
    (defun UEV_DalosAdminOrTalosSummoner ())
    (defun UEV_StandardAccOwn (account:string))
    (defun UEV_SmartAccOwn (account:string))
    (defun UEV_Methodic (account:string method:bool))
    (defun UEV_EnforceAccountExists (dalos-account:string))
    (defun UEV_EnforceAccountType (account:string smart:bool))
    (defun UEV_EnforceTransferability (sender:string receiver:string method:bool))
    (defun UEV_SenderWithReceiver (sender:string receiver:string))
    (defun UEV_TwentyFourPrecision (amount:decimal))
    (defun GLYPH|UEV_DalosAccountCheck (account:string))
    (defun GLYPH|UEV_DalosAccount (account:string))
    (defun GLYPH|UEV_MsDc:bool (multi-s:string))
    (defun IGNIS|UEV_VirtualState (state:bool))
    (defun IGNIS|UEV_VirtualOnCondition ())
    (defun IGNIS|UEV_NativeState (state:bool))
    (defun IGNIS|UEV_Patron (patron:string))
    ;;
    (defun UDC_AddICO:decimal (input:[object{IgnisCumulator}]))
    (defun UDC_CompressICO:object{IgnisCumulator} (chain-ico:[object{IgnisCumulator}] lst-to-be-saved:list))
    (defun UDC_Cumulator:object{IgnisCumulator} (price:decimal trigger:bool lst:list))
    ;;
    (defun CAP_EnforceAccountOwnership (account:string))
    ;;
    ;;
    (defun A_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun A_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun A_IgnisToggle (native:bool toggle:bool))
    (defun A_SetIgnisSourcePrice (price:decimal))
    (defun A_UpdatePublicKey (account:string new-public:string))
    (defun A_UpdateUsagePrice (action:string new-price:decimal))
    ;;
    (defun C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool))
    (defun C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string))
    (defun C_DeployStandardAccount (account:string guard:guard kadena:string public:string))
    (defun C_RotateGuard (patron:string account:string new-guard:guard safe:bool))
    (defun C_RotateGovernor (patron:string account:string governor:guard))
    (defun C_RotateKadena (patron:string account:string kadena:string))
    (defun C_RotateSovereign (patron:string account:string new-sovereign:string))
    ;;
    (defun C_TransferDalosFuel (sender:string receiver:string amount:decimal))
    (defun IGNIS|C_Collect (patron:string active-account:string amount:decimal))
    (defun IGNIS|C_CollectWT (patron:string active-account:string amount:decimal trigger:bool))
    (defun KDA|C_Collect (sender:string amount:decimal))
    (defun KDA|C_CollectWT (sender:string amount:decimal trigger:bool))

    (defun XB_UpdateBalance (account:string snake-or-gas:bool new-balance:decimal))
    (defun XB_UpdateOuroPrice (price:decimal))
    ;;
    (defun XE_ClearDispo (account:string))
    (defun XE_UpdateBurnRole (account:string snake-or-gas:bool new-burn:bool))
    (defun XE_UpdateElite (account:string amount:decimal))
    (defun XE_UpdateFeeExemptionRole (account:string snake-or-gas:bool new-fee-exemption:bool))
    (defun XE_UpdateFreeze (account:string snake-or-gas:bool new-freeze:bool))
    (defun XE_UpdateMintRole (account:string snake-or-gas:bool new-mint:bool))
    (defun XE_UpdateTransferRole (account:string snake-or-gas:bool new-transfer:bool))
)
(module DALOS GOV
    ;;
    (implements OuronetPolicy)
    (implements OuronetDalos)
    ;;{G1}
    (defconst GOV|MD_DALOS          (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_DALOS          (keyset-ref-guard DALOS|SC_KEY))

    (defconst DALOS|SC_KEY          (GOV|DalosKey)) 
    (defconst DALOS|SC_NAME         (GOV|DALOS|SC_NAME))
    (defconst DALOS|SC_KDA-NAME     (GOV|DALOS|SC_KDA-NAME))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|DALOS_ADMIN)))
    (defcap GOV|DALOS_ADMIN ()
        (enforce-one
            "DALOS Admin not satisfed"
            [
                (enforce-guard GOV|MD_DALOS)
                (enforce-guard GOV|SC_DALOS)
            ]
        )
    )
    (defcap DALOS|NATIVE-AUTOMATIC  ()
        @doc "Autonomic management of <kadena-konto> of DALOS Smart Account"
        true
    )
    ;;{G3}
    (defun DALOS|SetGovernor (patron:string)
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
            )
            (with-capability (SECURE)
                (C_RotateGovernor
                    patron
                    DALOS|SC_NAME
                    (ref-U|G::UEV_GuardOfAny
                        [
                            (P|UR "TFT|RemoteDalosGov")
                            (P|UR "TALOS-01|RemoteDalosGov")
                        ]
                    )
                )
            )
        )
    )
    (defun GOV|DALOS|SC_KDA-NAME () (create-principal (GOV|DALOS|GUARD)))
    (defun GOV|DALOS|GUARD ()       (create-capability-guard (DALOS|NATIVE-AUTOMATIC)))
    ;;
    (defun GOV|NS_Use ()            (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|Demiurgoi ()         (+ (GOV|NS_Use) ".dh_master-keyset"))
    (defun GOV|DalosKey ()          (+ (GOV|NS_Use) ".dh_sc_dalos-keyset"))
    (defun GOV|AutostakeKey ()      (+ (GOV|NS_Use) ".dh_sc_autostake-keyset"))
    (defun GOV|VestingKey ()        (+ (GOV|NS_Use) ".dh_sc_vesting-keyset"))
    (defun GOV|LiquidKey ()         (+ (GOV|NS_Use) ".dh_sc_kadenaliquidstaking-keyset"))
    (defun GOV|OuroborosKey ()      (+ (GOV|NS_Use) ".dh_sc_ouroboros-keyset"))
    (defun GOV|SwapKey ()           (+ (GOV|NS_Use) ".dh_sc_swapper-keyset"))
    ;;
    (defun GOV|DALOS|SC_NAME ()     (at 0 ["Σ.W∇ЦwÏξБØnζΦψÕłěîбηжÛśTã∇țâĆã4ЬĚIŽȘØíÕlÛřбΩцμCšιÄиMkλ€УщшàфGřÞыÎäY8È₳BDÏÚmßOozBτòÊŸŹjПкцğ¥щóиś4h4ÑþююqςA9ÆúÛȚβжéÑψéУoЭπÄЩψďşõшżíZtZuψ4ѺËxЖψУÌбЧλüșěđΔjÈt0ΛŽZSÿΞЩŠ"]))
    (defun GOV|ATS|SC_NAME ()       (at 0 ["Σ.ëŤΦșźUÉM89ŹïuÆÒÕ£żíëцΘЯнŹÿxжöwΨ¥Пууhďíπ₱nιrŹÅöыыidõd7ì₿ипΛДĎĎйĄшΛŁPMȘïõμîμŻIцЖljÃαbäЗŸÖéÂЫèpAДuÿPσ8ÎoŃЮнsŤΞìтČ₿Ñ8üĞÕPșчÌșÄG∇MZĂÒЖь₿ØDCПãńΛЬõŞŤЙšÒŸПĘЛΠws9€ΦуêÈŽŻ"]))
    (defun GOV|VST|SC_NAME ()       (at 0 ["Σ.şZïζhЛßdяźπПЧDΞZülΦпφßΣитœŸ4ó¥ĘкÌЦ₱₱AÚюłćβρèЬÍŠęgĎwтäъνFf9źdûъtJCλúp₿ÌнË₿₱éåÔŽvCOŠŃpÚKюρЙΣΩìsΞτWpÙŠŹЩпÅθÝØpтŮыØșþшу6GтÃêŮĞбžŠΠŞWĆLτЙđнòZЫÏJÿыжU6ŽкЫVσ€ьqθtÙѺSô€χ"]))
    (defun GOV|LIQUID|SC_NAME ()    (at 0 ["Σ.śκν9₿ŻşYЙΣJΘÊO9jпF₿wŻ¥уPэõΣÑïoγΠθßÙzěŃ∇éÖиțșφΦτşэßιBιśiĘîéòюÚY$êFЬŤØ$868дyβT0ςъëÁwRγПŠτËMĚRПMaäЗэiЪiςΨoÞDŮěŠβLé4čØHπĂŃŻЫΣÀmăĐЗżłÄăiĞ₿йÎEσțłGΛЖΔŞx¥ÁiÙNğÅÌlγ¢ĎwдŃ"]))
    (defun GOV|OUROBOROS|SC_NAME () (at 0 ["Σ.4M0èÞbøXśαiΠ€NùÇèφqλËãØÓNCнÌπпЬ4γTмыżěуàđЫъмéLUœa₿ĞЬŒѺrËQęíùÅЬ¥τ9£φď6pÙ8ìжôYиșîŻøbğůÞχEшäΞúзêŻöŃЮüŞöućЗßřьяÉżăŹCŸNÅìŸпĐżwüăŞãiÜą1ÃγänğhWg9ĚωG₳R0EùçGΨфχЗLπшhsMτξ"]))
    (defun GOV|SWP|SC_NAME ()       (at 0 ["Σ.fĘĐżØиmΞüȚÓ0âGœȘйцań₿ѺĐЦãúα0šwř4QąйZЛgãŽ₿ßÇöđ2zFtмÄäþťûκpíČX₳ĂBÞãÅhλÚțqýвáêйâ₳ЫDżfÙŃλыêąйíâβPЫůjыáaπÕpnýOĄåęümÚJηğȘôρ8şnνEβęůйΛÑćλòxЧUdÑĎÈčVΞÌFAx£Ы2τżŻzДŽYуRČñÜ"]))
    ;;
    (defun GOV|DALOS|PBL ()         (at 0 ["9G.DwF3imJMCp4ht88DD1vx6pdjEkLM4j7Fvzso8zJF7Ixe1p2oKfGb53a5svtEF0Lz1q4MjvHaMrgqCfjlA1cBj2bzvs86EeLIMg2fmutzwbA5vI4woKoqq0acDHllAonxC4qLBulsLclMGwcw9iGxiw919t4tfD8FpcIc4MJ059ki7giFIAyCghgMwwr199v3qiDfIon426rbz1jMLmCe4jhHwD3sEarwMlmzLJ5li43J70CEDzouh7x8pu4u1GxJHa6Cabrsc147gIlzIdDmCC2j87LFpEdvqLge9o0w4av8mLr0lDAfalpnEabfkl0E6zE9KMG7LH2w7uvBIup3Hxxxu2Giwu29Cqye3fJ5ihcjacop4vtcLsi33ip742uAhGzjHaDLwAh933ntp8tEC1zkt9yi6n89JtsDLk477p80rscbGtsi14nxsMf7y0d7GxzE8FFmljElu5yE3vx25cEvc9574Hw4iIi23FFKfdhGF77LMqaBkDB9hJKmpc1B2rM1a8mfilyvLAdzpj57Ae5FG5vvm1n1nzgau373dBF7CuBAu2zbts09du55"]))
    (defun GOV|ATS|PBL ()           (at 0 ["9H.9I8veD6Lqmcd5nKlb1vlHkg976FhdtooE3iH73h8i2Gq9tLKdclnpo07sC29i2yvMeuB0ikkKghiIgdAfkfDiM57o2phj2quCD8gutjIgDs6AlecMtw2lG6kMMBxBH4B5d1xqhpzA7AHkgEqF7Hgqwpx6E5aIMAtqxIpMhjyqziDiwLA69dKlhlwpjoze34Bwz6swBjlA880ItKfwxtulKEJG9oI3Gjmwgn6bbAgL7xy4brdbgK5DukMBHc0K1jIs1DjcDzhJz2liKultB67rKaBf3nMHMkbzhwl1hdu2wBCeHMLLphug2kE3tDtpxw6kLcj80qfBxvwmuxbeHjk349Md2B7eB4brt8fldi2CxGltfj41KA7GkgmtMa6szivDl5aCk9ozab9ohrsfBHikGL7GJ5Az4A2a8ufnIAJIz2mAgwGDmsAl7yyavbx12e5KhFFupclbKadmiFx8dvqkqwziu4vtt3AcKDhl96EzhuiKAF49vGoaAMo5vxM4h0t94nscG8IGl33De5MJGCpdf3g23D13eJ9BDi034wECutafzao4zzCe9IyvD3E"]))
    (defun GOV|VST|PBL ()           (at 0 ["9G.5s5hoiGo96tMqyh3JBklmsvo8Lc3ol9m6zavJcCuqg4mBvkbDfcv5gEorMit8v8Mj9Jc18EI36Gq7cJ1IyA4e4wvl199KuCx3chsDKGDdfsvzk8mo317ulGk00pbxu7MLc2zw7joouaxt3Ax1KnlJz153ko0JtIxz7pqylfis45pDo2vvm1MH2kA2wmE2crxiEo6oEckuGqzz8oEaa9ez8ADLyqnj48lq4jGp4slkKo6a06ElezH619fsihIdmiMdfB036CJAr0rlzA2b5DgvEJcoyIFioru7vynBjLMLv3pvLFnbFeswrlyLjF8ry7kB52cD7bD7xaamCEjgIC2DsKMv5Mrd69BIKn2yKHC86f0hme9zs5dwMekAd6mc4wM4bDAk6Jrsl6s74ykKLF71pk45rIE1xxzFC4EjykBf6G0neBdaExI32HufaE5mEloDtvnC6vJ7HA9akkI3616MnLErA8eMIn7Kr2wI4l9CvGpKcF9HilzJmdqMa4kzJwqzuFc9LhDnrKcu0LvBHqsx2CrCM9EwHqpkkGe7w8eK8x0xK6K8drLaoBKmaB1"]))
    (defun GOV|LIQUID|PBL ()        (at 0 ["9H.b49lfzLzvC25g87fst6MqCkfbuqq39iGu50gDqi9jBEk6Cn86w54b91zDxeGgLdCxIjJDfyi6gBBwA93lyGLcdfggf0LzwKu405piavx0nEnqpzyHK125h2BhECnobmDBAps61c7mGmw5GrczBjvBMLxHwl2avt5jwhKeGxh7Ibm1ui6wI6lpAKBMay4tvEwHK0EibhbeaA2lLqjIwqMKnldp22txeje3DFLautFC798ExbLxG7q3om8l1f9qpMJkw9f5nmHsHGJcrcIF2mou9lmpr3hbz64La6nF9w26h7osABLMLlK9Glp48yrj4h1MkI7xjftytKDnJFyqvoMFqKvA43cJ81bJCvmn63eJ9jx5n3GxFbc9H4v400iFwtyIilmhKymsa1iCnwL29g21DvkaE6JJyxl5eLCiGH3Ml1nb0jkg16zJbf9cfg41KHA0IGFIvLj9LBhj7okL6wspCEBfkc5Aui6DAM7dvAqH54LApEaAzIgyMloEmqvBgt5wF0lyd05xHxz4Mtb3ItGb5fLpzbMGqGKBffi4dElI7Hbs6Id0hCKGaeIg9JL"]))
    (defun GOV|OUROBOROS|PBL ()     (at 0 ["9H.28jB2BBny4op601Cfqz9brFJKAEo67jbEDJi91i00pGjcD1Mpn0y0A1CxcAwGgBu35Ix3bG4e4p56Mu6x7Mmd50nKfmpDGtLy1ywyCjoDD5xiHBb0y5dAjB0fuokrqyx3ula9rtxyEHK1A4gkG4g3GEyysMtgF40IBgKjm7t8ffGshICIypFeF3gA5x0MixA0soiCx9tBnMDzI6G5xC8yIJJ3Bt2sCvJHAp7HAEA3rKK6Bgnx8hK94oDbgrpCkxw3zpo7tbeHhcakzbg0ELG3EJvk19hyd9LC73t2gizl0B6puq3Ljji5EDAhzno7K32x8vCagc5D2GLiMfdzEzsj5KEe1c2p7hxj76lMvp40r9F56vzlK8Kb7mrKt90ILEMqCghLrok7D4uH8h28EGqbK75wiyguimc1jDGxthyBJFfApClymKA57ehqbv2Lyv323w44b0kIItu35fjmhe2DCBMwjn67ffDII97b6AdyG010wvAHf55xFt25Mbm2pflsggL4D5jHtokl7qn6g4ltM5ilvHvsxn7jHe23Cfgoxn1JssdFMBpcDvB2xki7"]))
    (defun GOV|SWP|PBL ()           (at 0 ["9G.4Bl3bJ5o1eIoBkhynF39lFdvkA3E0n8m5fBr9iG4D6Ahj3xfop72b98rr33vFFLjqaiozE1btl7lgzKcjHwjzu5GuFqvMb43v9CHHe8je3buLbHMkcAyKdEMD85yIHsb9ty58Kzyado3ho1n1mf9GzpeegMrpK9wDFteeKexdL7HHq8GF7ptD2w45IkMf2A8j4pm7E6vJ1ytCckhclD9nd3JzL2j5cyLxawnE76leKmEmFaxqnF76yyJe5Mu6yLkg2yonJa6vx6jd1kr0hdEf81o42Asr8EcCDeeqD4nAehC3w3pFDMwbln4Mbl6t55GHGephx99LJKH1ojhlMlnyC4bbJFAiyD1h6vs0o7mKAaazFG9y0vfbvM9imcs1vCMmpk2cGDAAAqH6iJe32ugHA3AECEgCvxCskw4Mfx6Cc4rx2BkmKMlxeHqyDceI6wa2qjzuyI80vKg6H6tMwEg48H0ywIMDyxteDfHav08eEJE2lljEIAc1jxLlLcosbiknAyxJvu8g7kA4oAlcio2jI8lMxp76vosd5FxpatowuFktILfyCFyHvKfcozy"]))
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    ;;{P3}
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|DALOS_ADMIN)
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
    (defschema DALOS|KadenaSchema
        dalos:[string]
    )
    (defschema DALOS|PropertiesSchema
        demiurgoi:[string]                  ;;Stores Demiurgoi DALOS Accounts
        unity-id:string                     ;;Unity
        gas-source-id:string                ;;OUROBOROS
        gas-source-id-price:decimal         ;;OUROBOROS Price
        gas-id:string                       ;;IGNIS
        ats-gas-source-id:string            ;;AURYN
        elite-ats-gas-source-id:string      ;;ELITE-AURYN
        wrapped-kda-id:string               ;;DWK - Dalos Wrapped Kadena
        liquid-kda-id:string                ;;DLK - Dalos Liquid Kadena
    )
    (defschema DALOS|GasManagementSchema
        virtual-gas-tank:string             ;;IGNIS|SC_NAME = "GasTanker"
        virtual-gas-toggle:bool             ;;IGNIS collection toggle
        virtual-gas-spent:decimal           ;;IGNIS spent
        native-gas-toggle:bool              ;;KADENA collection toggle
        native-gas-spent:decimal            ;;KADENA spent
    )
    (defschema DALOS|PricesSchema
        price:decimal                       ;;Stores price for action
    )
    (defschema DALOS|AccountSchema
        @doc "Schema that stores DALOS Account Information"
        public:string
        guard:guard
        kadena-konto:string
        sovereign:string
        governor:guard

        smart-contract:bool
        payable-as-smart-contract:bool
        payable-by-smart-contract:bool
        payable-by-method:bool

        nonce:integer
        elite:object{DALOS|EliteSchema}
        ouroboros:object{OuronetDalos.DPTF|BalanceSchema}
        ignis:object{OuronetDalos.DPTF|BalanceSchema}
    )
    (defschema DALOS|EliteSchema
        class:string
        name:string
        tier:string
        deb:decimal
    )
    ;;{2}
    (deftable DALOS|KadenaLedger:{DALOS|KadenaSchema})
    (deftable DALOS|PropertiesTable:{DALOS|PropertiesSchema})
    (deftable DALOS|GasManagementTable:{DALOS|GasManagementSchema})
    (deftable DALOS|PricesTable:{DALOS|PricesSchema})
    (deftable DALOS|AccountTable:{DALOS|AccountSchema})
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defun DALOS|Info ()            (at 0 ["DalosInformation"]))
    (defun DALOS|VirtualGasData ()  (at 0 ["VirtualGasData"]))
    (defun DALOS|EmptyIgCum:object{OuronetDalos.IgnisCumulator} ()
        { "price"                   : 0.0
        , "trigger"                 : false
        , "output"                  : [] }
    )
    (defconst BAR                   (CT_Bar))
    (defconst DALOS|INFO            (DALOS|Info))
    (defconst DALOS|VGD             (DALOS|VirtualGasData))
    (defconst DALOS|CHR_AUX
        [ " " "!" "#" "%" "&" "'" "(" ")" "*" "+" "," "-" "." "/" ":" ";" "<" "=" ">" "?" "@" "[" "]" "^" "_" "`" "{" "|" "}" "~" "‰" ]
    )
    (defconst DALOS|CHR_DIGITS
        ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9"]
    )
    (defconst DALOS|CHR_CURRENCIES 
        [ "Ѻ" "₿" "$" "¢" "€" "£" "¥" "₱" "₳" "∇" ]
    )
    (defconst DALOS|CHR_LATIN-B
        [ "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" ]
    )
    (defconst DALOS|CHR_LATIN-S
        [ "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" ]
    )
    (defconst DALOS|CHR_LATIN-EXT-B
        [ "Æ" "Œ" "Á" "Ă" "Â" "Ä" "À" "Ą" "Å" "Ã" "Ć" "Č" "Ç" "Ď" "Đ" "É" "Ě" "Ê" "Ë" "È" "Ę" "Ğ" "Í" "Î" "Ï" "Ì" "Ł" "Ń" "Ñ" "Ó" "Ô" "Ö" "Ò" "Ø" "Õ" "Ř" "Ś" "Š" "Ş" "Ș" "Þ" "Ť" "Ț" "Ú" "Û" "Ü" "Ù" "Ů" "Ý" "Ÿ" "Ź" "Ž" "Ż" ]
    )
    (defconst DALOS|CHR_LATIN-EXT-S
        [ "æ" "œ" "á" "ă" "â" "ä" "à" "ą" "å" "ã" "ć" "č" "ç" "ď" "đ" "é" "ě" "ê" "ë" "è" "ę" "ğ" "í" "î" "ï" "ì" "ł" "ń" "ñ" "ó" "ô" "ö" "ò" "ø" "õ" "ř" "ś" "š" "ş" "ș" "þ" "ť" "ț" "ú" "û" "ü" "ù" "ů" "ý" "ÿ" "ź" "ž" "ż" "ß" ]
    )
    (defconst DALOS|CHR_GREEK-B
        [ "Γ" "Δ" "Θ" "Λ" "Ξ" "Π" "Σ" "Φ" "Ψ" "Ω" ]
    )
    (defconst DALOS|CHR_GREEK-S
        [ "α" "β" "γ" "δ" "ε" "ζ" "η" "θ" "ι" "κ" "λ" "μ" "ν" "ξ" "π" "ρ" "σ" "ς" "τ" "φ" "χ" "ψ" "ω" ]
    )
    (defconst DALOS|CHR_CYRILLIC-B
        [ "Б" "Д" "Ж" "З" "И" "Й" "Л" "П" "У" "Ц" "Ч" "Ш" "Щ" "Ъ" "Ы" "Ь" "Э" "Ю" "Я" ]
    )
    (defconst DALOS|CHR_CYRILLIC-S
        [ "б" "в" "д" "ж" "з" "и" "й" "к" "л" "м" "н" "п" "т" "у" "ф" "ц" "ч" "ш" "щ" "ъ" "ы" "ь" "э" "ю" "я" ]
    )
    (defconst DALOS|CHARSET
        (fold (+) [] 
            [
                DALOS|CHR_DIGITS 
                DALOS|CHR_CURRENCIES
                DALOS|CHR_LATIN-B
                DALOS|CHR_LATIN-S
                DALOS|CHR_LATIN-EXT-B
                DALOS|CHR_LATIN-EXT-S
                DALOS|CHR_GREEK-B
                DALOS|CHR_GREEK-S
                DALOS|CHR_CYRILLIC-B
                DALOS|CHR_CYRILLIC-S
            ]
        )
    )
    (defconst DALOS|EXTENDED        (+ DALOS|CHR_AUX DALOS|CHARSET))
    (defconst GAS_EXCEPTION 
        [
            DALOS|SC_NAME
            (GOV|OUROBOROS|SC_NAME)
            (GOV|LIQUID|SC_NAME)
        ]
    )
    (defconst GAS_QUARTER 0.25)
    (defconst DPTF|BLANK
        { "exist"                   : true
        , "balance"                 : 0.0
        , "role-burn"               : false
        , "role-mint"               : false
        , "role-transfer"           : false
        , "role-fee-exemption"      : false
        , "frozen"                  : false }
    )
    (defconst DALOS|PLEB
        { "class" : "NOVICE"
        , "name"  : "Infidel"
        , "tier"  : "0.0"
        , "deb"   : 1.0 }
    )
    (defconst DALOS|VOID
        { "class" : "VOID"
        , "name"  : "Undead"
        , "tier"  : "0.0"
        , "deb"   : 0.0 }
    )
    ;;
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    (defcap DALOS|S>D-ST (account:string guard:guard kadena:string)
        @event
        (let
            (
                (account-validation:bool (GLYPH|UEV_DalosAccount account))
                (first:string (take 1 account))
                (ouroboros:string "Ѻ")
            )
            (enforce account-validation (format "Account {} isn't a valid DALOS Account" [account]))
            (enforce (= first ouroboros) (format "Account {} doesn|t have the corrrect Format for a Standard DALOS Account" [account]))
            (enforce-guard guard)
            (compose-capability (SECURE))
            ;(UTILS.UTILS|UEV_EnforceReserved kadena guard)
        )
    )
    (defcap DALOS|S>D-SM (account:string guard:guard kadena:string sovereign:string)
        @event
        (let
            (
                (account-validation:bool (GLYPH|UEV_DalosAccount account))
                (first:string (take 1 account))
                (sigma:string "Σ")
            )
            (enforce account-validation (format "Account {} isn't a valid DALOS Account" [account]))
            (enforce (= first sigma) (format "Account {} doesn|t have the corrrect Format for a Smart DALOS Account" [account]))
            (UEV_EnforceAccountType sovereign false)
            (enforce-guard guard)
            (compose-capability (SECURE))
            ;(UTILS.UTILS|UEV_EnforceReserved kadena guard)
        )
    )
    ;;{C3}
    (defcap DALOS|F>OWNER (account:string)
        (CAP_EnforceAccountOwnership account)
    )
    (defcap DALOS|F>GOV (account:string)
        (CAP_EnforceAccountOwnership account)
        (UEV_EnforceAccountType account true)
    )
    ;;{C4}
    (defcap DALOS|C>RT_ACC (account:string)
        @event
        (compose-capability (SECURE))
        (compose-capability (DALOS|F>OWNER account))
    )
    (defcap DALOS|C>RT_SOV (account:string new-sovereign:string)
        @event
        (CAP_EnforceAccountOwnership account)
        (UEV_EnforceAccountType account true)
        (UEV_EnforceAccountType new-sovereign false)
        (UEV_SenderWithReceiver (UR_AccountSovereign account) new-sovereign)
    )
    (defcap DALOS|C>RT_GOV (account:string)
        @event
        (compose-capability (DALOS|F>GOV account))
    )
    (defcap DALOS|C>CTRL_SM-ACC (account:string pasc:bool pbsc:bool pbm:bool)
        @event
        (compose-capability (DALOS|F>GOV account))
        (enforce (= (or (or pasc pbsc) pbm) true) "At least one Smart DALOS Account parameter must be true")
    )
    (defcap IGNIS|C>CLT (patron:string active-account:string amount:decimal)
        (IGNIS|UEV_Patron patron)
        (let
            (
                (sender-type:bool (UR_AccountType active-account))
            )
            (if sender-type
                (compose-capability (IGNIS|C>CLT_SM patron active-account amount))
                (compose-capability (IGNIS|C>CLT_ST patron amount))
            )
        )
    )
    (defcap IGNIS|C>CLT_SM (patron:string active-account:string amount:decimal)
        (let
            (
                (gas-id:string (UR_IgnisID))
            )
            (if (!= gas-id BAR)
                (let
                    (
                        (gas-pot:string (UR_Tanker))
                        (quarter:decimal (* amount GAS_QUARTER))
                        (rest:decimal (- amount quarter))
                    )
                    (compose-capability (IGNIS|C>TRANSFER patron gas-pot rest))
                    (compose-capability (IGNIS|C>TRANSFER patron active-account quarter))
                    (compose-capability (SECURE))
                )
                true
            )
        )
    )
    (defcap IGNIS|C>CLT_ST (patron:string amount:decimal)
        (let
            (
                (gas-id:string (UR_IgnisID))
            )
            (if (!= gas-id BAR)
                (compose-capability (IGNIS|C>CLT_STX patron amount))
                true
            )
        )
    )
    (defcap IGNIS|C>CLT_STX (patron:string amount:decimal)
        (compose-capability (IGNIS|C>TRANSFER patron (UR_Tanker) amount))
        (compose-capability (SECURE))
    )
    (defcap IGNIS|C>TRANSFER (sender:string receiver:string ta:decimal)
        (enforce (!= sender receiver) "Sender and Receiver must be different")
        (UEV_TwentyFourPrecision ta)
        (enforce (> ta 0.0) "Cannot debit|credit 0.0 or negative GAS amounts")
        (compose-capability (IGNIS|C>DEBIT sender ta))
        (compose-capability (IGNIS|C>CREDIT receiver))
    )
    (defcap IGNIS|C>DEBIT (sender:string ta:decimal)
        (let
            (
                (read-gas:decimal (UR_TF_AccountSupply sender false))
            )
            (enforce (<= ta read-gas) "Insufficient GAS for GAS-Debiting")
            (UEV_EnforceAccountExists sender)
            (UEV_EnforceAccountType sender false)
            (compose-capability (SECURE))
        )
    )
    (defcap IGNIS|C>CREDIT (receiver:string)
        (UEV_EnforceAccountExists receiver)
        (compose-capability (SECURE))
    )
    (defcap IGNIS|C>TOGGLE (native:bool toggle:bool)
        (compose-capability (GOV|DALOS_ADMIN))
        (if native
            (IGNIS|UEV_NativeState (not toggle))
            (IGNIS|UEV_VirtualState (not toggle))
        )
    )
    ;;
    ;)
    ;;{F0}
    (defun UR_KadenaLedger:[string] (kadena:string)
        (with-default-read DALOS|KadenaLedger kadena
            { "dalos"    : [BAR] }
            { "dalos"    := d }
            d
        )
    )
    (defun UR_DemiurgoiID:[string] ()
        (at "demiurgoi" (read DALOS|PropertiesTable DALOS|INFO ["demiurgoi"]))
    )
    (defun UR_UnityID:string ()
        (at "unity-id" (read DALOS|PropertiesTable DALOS|INFO ["unity-id"]))
    )
    (defun UR_OuroborosID:string ()
        (at "gas-source-id" (read DALOS|PropertiesTable DALOS|INFO ["gas-source-id"]))
    )
    (defun UR_OuroborosPrice:decimal ()
        (at "gas-source-id-price" (read DALOS|PropertiesTable DALOS|INFO ["gas-source-id-price"]))
    )
    (defun UR_IgnisID:string ()
        (with-default-read DALOS|PropertiesTable DALOS|INFO 
            { "gas-id" :  BAR }
            { "gas-id" := gas-id}
            gas-id
        )
    )
    (defun UR_AurynID:string ()
        (at "ats-gas-source-id" (read DALOS|PropertiesTable DALOS|INFO ["ats-gas-source-id"]))
    )
    (defun UR_EliteAurynID:string ()
        (at "elite-ats-gas-source-id" (read DALOS|PropertiesTable DALOS|INFO ["elite-ats-gas-source-id"]))
    )
    (defun UR_WrappedKadenaID:string ()
        (at "wrapped-kda-id" (read DALOS|PropertiesTable DALOS|INFO ["wrapped-kda-id"]))
    )
    (defun UR_LiquidKadenaID:string ()
        (at "liquid-kda-id" (read DALOS|PropertiesTable DALOS|INFO ["liquid-kda-id"]))
    )
    (defun UR_Tanker:string ()
        (at "virtual-gas-tank" (read DALOS|GasManagementTable DALOS|VGD ["virtual-gas-tank"]))
    )
    (defun UR_VirtualToggle:bool ()
        (with-default-read DALOS|GasManagementTable DALOS|VGD
            {"virtual-gas-toggle" : false}
            {"virtual-gas-toggle" := tg}
            tg
        )
    )
    (defun UR_VirtualSpent:decimal ()
        (at "virtual-gas-spent" (read DALOS|GasManagementTable DALOS|VGD ["virtual-gas-spent"]))
    )
    (defun UR_NativeToggle:bool ()
        (with-default-read DALOS|GasManagementTable DALOS|VGD
            {"native-gas-toggle" : false}
            {"native-gas-toggle" := tg}
            tg
        )
    )
    (defun UR_NativeSpent:decimal ()
        (at "native-gas-spent" (read DALOS|GasManagementTable DALOS|VGD ["native-gas-spent"]))
    )
    (defun UR_UsagePrice:decimal (action:string)
        (at "price" (read DALOS|PricesTable action ["price"]))
    )
    (defun UR_AccountPublicKey:string (account:string)
        (at "public" (read DALOS|AccountTable account ["public"]))
    )
    (defun UR_AccountGuard:guard (account:string)
        (at "guard" (read DALOS|AccountTable account ["guard"]))
    )
    (defun UR_AccountKadena:string (account:string)
        (at "kadena-konto" (read DALOS|AccountTable account ["kadena-konto"]))
    )
    (defun UR_AccountSovereign:string (account:string)
        (at "sovereign" (read DALOS|AccountTable account ["sovereign"]))
    )
    (defun UR_AccountGovernor:guard (account:string)
        (at "governor" (read DALOS|AccountTable account ["governor"]))
    )
    (defun UR_AccountProperties:[bool] (account:string)
        (with-default-read DALOS|AccountTable account
            { "smart-contract" : false, "payable-as-smart-contract" : false, "payable-by-smart-contract" : false, "payable-by-method" : false}
            { "smart-contract" := sc, "payable-as-smart-contract" := pasc, "payable-by-smart-contract" := pbsc, "payable-by-method" := pbm }
            [sc pasc pbsc pbm]
        )
    )
    (defun UR_AccountType:bool (account:string)
        (at 0 (UR_AccountProperties account))
    )
    (defun UR_AccountPayableAs:bool (account:string)
        (at 1 (UR_AccountProperties account))
    )
    (defun UR_AccountPayableBy:bool (account:string)
        (at 2 (UR_AccountProperties account))
    )
    (defun UR_AccountPayableByMethod:bool (account:string)
        (at 3 (UR_AccountProperties account))
    )
    (defun UR_AccountNonce:integer (account:string)
        (with-default-read DALOS|AccountTable account
            { "nonce" : 0 }
            { "nonce" := n }
            n
        )
    )
    (defun UR_Elite (account:string)
        (with-default-read DALOS|AccountTable account
            { "elite" : DALOS|PLEB }
            { "elite" := e}
            e
        )
    )
    (defun UR_Elite-Class (account:string)
        (at "class" (UR_Elite account))
    )
    (defun UR_Elite-Name (account:string)
        (at "name" (UR_Elite account))
    )
    (defun UR_Elite-Tier (account:string)
        (at "tier" (UR_Elite account))
    )
    (defun UR_Elite-Tier-Major:integer (account:string)
        (str-to-int (take 1 (UR_Elite-Tier account)))
    )
    (defun UR_Elite-Tier-Minor:integer (account:string)
        (str-to-int (take -1 (UR_Elite-Tier account)))
    )
    (defun UR_Elite-DEB (account:string)
        (at "deb" (UR_Elite account))
    )
    (defun UR_TrueFungible:object{OuronetDalos.DPTF|BalanceSchema} (account:string snake-or-gas:bool)
        (if snake-or-gas
            (with-default-read DALOS|AccountTable account
                { "ouroboros" : DPTF|BLANK }
                { "ouroboros" := o}
                o
            )
            (with-default-read DALOS|AccountTable account
                { "ignis" : DPTF|BLANK }
                { "ignis" := i}
                i
            )
        )
    )
    (defun UR_TF_AccountSupply:decimal (account:string snake-or-gas:bool)
        (at "balance" (UR_TrueFungible account snake-or-gas))
    )
    (defun UR_TF_AccountRoleBurn:bool (account:string snake-or-gas:bool)
        (at "role-burn" (UR_TrueFungible account snake-or-gas))
    )
    (defun UR_TF_AccountRoleMint:bool (account:string snake-or-gas:bool)
        (at "role-mint" (UR_TrueFungible account snake-or-gas))
    )
    (defun UR_TF_AccountRoleTransfer:bool (account:string snake-or-gas:bool)
        (at "role-transfer" (UR_TrueFungible account snake-or-gas))
    )
    (defun UR_TF_AccountRoleFeeExemption:bool (account:string snake-or-gas:bool)
        (at "role-fee-exemption" (UR_TrueFungible account snake-or-gas))
    )
    (defun UR_TF_AccountFreezeState:bool (account:string snake-or-gas:bool)
        (at "frozen" (UR_TrueFungible account snake-or-gas))
    )
    ;;{F1}
    (defun URC_IgnisGasDiscount:decimal (account:string)
        @doc "Computes the Discount for Ignis Gas Costs. A value of 1.00 means no discount"
        (URC_GasDiscount account false)
    )
    (defun URC_KadenaGasDiscount:decimal (account:string)
        @doc "Computes the Discount for Ignis Gas Costs. A value of 1.00 means no discount"
        (URC_GasDiscount account true)
    )
    (defun URC_GasDiscount:decimal (account:string native:bool)
        @doc "Computes Gas Discount Values, a value of 1.00 means no discount"
        (let
            (
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                (major:integer (UR_Elite-Tier-Major account))
                (minor:integer (UR_Elite-Tier-Minor account))
            )
            (ref-U|DALOS::UC_GasCost 1.00 major minor native)
        )
    )
    (defun URC_SplitKDAPrices:[decimal] (account:string kda-price:decimal)
        @doc "Computes the KDA Split required for Native Gas Collection \
        \ This is 5% 5% 15% and 75% split, outputed as 5% 15% 75% in a list \
        \ Takes in consideration the Discounted KDA for <account>"
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|DALOS:module{UtilityDalos} U|DALOS)
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                (kda-discount:decimal (URC_KadenaGasDiscount account))
                (discounted-kda:decimal (floor (* kda-discount kda-price) kda-prec))
                (v1:decimal (* 0.05 discounted-kda))
                (v2:decimal (* 0.15 discounted-kda))
                (v3:decimal (- discounted-kda (fold (+) 0.0 [v1 v1 v2])))
            )
            [v1 v2 v3]
        )
    )
    (defun URC_Transferability:bool (sender:string receiver:string method:bool)
        (UEV_SenderWithReceiver sender receiver)
        (let
            (
                (s-sc:bool (UR_AccountType sender))
                (r-sc:bool (UR_AccountType receiver))
                (r-pasc:bool (UR_AccountPayableAs receiver))
                (r-pbsc:bool (UR_AccountPayableBy receiver))
                (r-mt:bool (UR_AccountPayableByMethod receiver))
            )
            (if (= s-sc false)
                (if (= r-sc false)              ;;sender is normal
                    true                        ;;receiver is normal (Normal => Normal | Case 1)
                    (if (= method true)         ;;receiver is smart  (Normal => Smart | Case 3)
                        r-mt
                        r-pasc
                    )
                )
                (if (= r-sc false)              ;;sender is smart
                    true                        ;;receiver is normal (Smart => Normal | Case 4)
                    (if (= method true)         ;;receiver is false (Smart => Smart | Case 2)
                        r-mt
                        r-pbsc
                    )
                )
            )
        )
    )
    (defun IGNIS|URC_Exception (account:string)
        (contains account GAS_EXCEPTION)
    )
    (defun IGNIS|URC_ZeroGAZ:bool (id:string sender:string receiver:string)
        (let
            (
                (t1:bool (IGNIS|URC_ZeroGAS id sender))
                (t2:bool (IGNIS|URC_Exception receiver))
            )
            (or t1 t2)
        )
    )
    (defun IGNIS|URC_ZeroGAS:bool (id:string sender:string)
        (let
            (
                (t1:bool (IGNIS|URC_IsVirtualGasZeroAbsolutely id))
                (t2:bool (IGNIS|URC_Exception sender))
            )
            (or t1 t2)
        )
    )
    (defun IGNIS|URC_IsVirtualGasZeroAbsolutely:bool (id:string)
        (let
            (
                (t1:bool (IGNIS|URC_IsVirtualGasZero))
                (gas-id:string (UR_IgnisID))
                (t2:bool (if (or (= gas-id BAR)(= id gas-id)) true false))
            )
            (or t1 t2)
        )
    )
    (defun IGNIS|URC_IsVirtualGasZero:bool ()
        (if (UR_VirtualToggle)
            false
            true
        )
    )
    (defun IGNIS|URC_IsNativeGasZero:bool ()
        (if (UR_NativeToggle)
            false
            true
        )
    )
    ;;{F2}
    (defun UEV_DalosAdminOrTalosSummoner ()
        (enforce-one
            "Account Deployment not permitted"
            [
                (enforce-guard (create-capability-guard (GOV|DALOS_ADMIN)))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
    )
    (defun UEV_StandardAccOwn (account:string)
        (let
            (
                (account-guard:guard (UR_AccountGuard account))
                (sovereign:string (UR_AccountSovereign account))
                (governor:guard (UR_AccountGovernor account))
            )
            (enforce (= sovereign account) "Incompatible Sovereign detected for a Standard DALOS Account")
            (enforce (= account-guard governor) "Incompatible Governer Guard detected for Standard DALOS Account")
            (enforce-guard account-guard)
        )
    )
    (defun UEV_SmartAccOwn (account:string)
        (let
            (
                (account-guard:guard (UR_AccountGuard account))
                (sovereign:string (UR_AccountSovereign account))
                (sovereign-guard:guard (UR_AccountGuard sovereign))
                (governor:guard (UR_AccountGovernor account))
            )
            (enforce (!= sovereign account) "Incompatible Sovereign detected for Smart DALOS Account")
            (enforce-one
                "Smart DALOS Account Permissions not satisfied !"
                [
                    (enforce-guard account-guard)
                    (enforce-guard sovereign-guard)
                    (enforce-guard governor)
                ]
            )
        )
    )
    (defun UEV_Methodic (account:string method:bool)
        (if method
            (CAP_EnforceAccountOwnership account)
            true
        )
    )
    (defun UEV_EnforceAccountExists (dalos-account:string)
        (with-default-read DALOS|AccountTable dalos-account
            { "elite" : DALOS|VOID }
            { "elite" := e }
            (let
                (
                    (deb:decimal (at "deb" e))
                )
                (enforce 
                    (>= deb 1.0)
                    (format "The {} DALOS Account doesnt exist" [dalos-account])
                )
            )
        )
    )
    (defun UEV_EnforceAccountType (account:string smart:bool)
        (let
            (
                (x:bool (UR_AccountType account))
                (first:string (take 1 account))
                (ouroboros:string "Ѻ")
                (sigma:string "Σ")
            )
            (if smart 
                (enforce (and (= first sigma) (= x true)) (format "Operation requires a Smart DALOS Account; Account {} isnt" [account]))
                (enforce (and (= first ouroboros) (= x false)) (format "Operation requires a Standard DALOS Account; Account {} isnt" [account]))
            )
        )
    )
    (defun UEV_EnforceTransferability (sender:string receiver:string method:bool)
        (let
            (
                (x:bool (URC_Transferability sender receiver method))
            )
            (enforce (= x true) (format "Transferability between {} and {} with {} Method is not ensured" [sender receiver method]))
        )
    )
    (defun UEV_SenderWithReceiver (sender:string receiver:string)
        (UEV_EnforceAccountExists sender)
        (UEV_EnforceAccountExists receiver)
        (enforce (!= sender receiver) "Sender and Receiver must be different")
    )
    (defun UEV_TwentyFourPrecision (amount:decimal)
        (enforce
            (= (floor amount 24) amount)
            (format "The GAS Amount of {} is not a valid GAS Amount decimal wise" [amount])
        )
    )
    (defun GLYPH|UEV_DalosAccountCheck (account:string)
        @doc "Checks if a string is a valid DALOS Account, using no enforcements "
        (let
            (
                (account-len:integer (length account))
                (t1:bool (= account-len 162))
                (ouroboros:string "Ѻ")
                (sigma:string "Σ")
                (first:string (take 1 account))
                (t2:bool (or (= first ouroboros)(= first sigma)))
                (t3:bool (and t1 t2))
                (second:string (drop 1 (take 2 account)))
                (point:string ".")
                (t4:bool (= second point))
                (t5:bool (GLYPH|UEV_MsDc (drop 2 account)))
                (t6:bool (and t4 t5))
            )
            (and t3 t6)
        )
    )
    (defun GLYPH|UEV_DalosAccount (account:string)
        @doc "Enforces that a Dalos Account (Address) has the proper format"
        (let
            (
                (account-len:integer (length account))
                (ouroboros:string "Ѻ")
                (sigma:string "Σ")
                (first:string (take 1 account))
                (second:string (drop 1 (take 2 account)))
                (point:string ".")
            )
            (enforce (= account-len 162) "Address|Account does not conform to the DALOS Standard for Addresses|Accounts")
            (enforce-one 
                "Address|Account format is invalid"
                [
                    (enforce (= first ouroboros) "Account|Address Identifier is invalid, while checking for a Standard Account|Address")
                    (enforce (= first sigma) "Account|Address Identifier is invalid, while checking for a Smart Account|Address")
                ]
            )
            (enforce (= second point) "Account|Address Format is invalid, second Character must be a <.>")
            (let
                (
                    (checkup:bool (GLYPH|UEV_MsDc (drop 2 account)))
                )
                (enforce checkup "Characters do not conform to the DALOS|CHARSET")
            )
        )
    )
    (defun GLYPH|UEV_MsDc:bool (multi-s:string)
        @doc "Enforce a multistring is part of the DALOS|CHARSET"
        (let
            (
                (str-lst:[string] (str-to-list multi-s))
            )
            (fold
                (lambda
                    (acc:bool idx:integer)
                    (let
                        (
                            (checkup:bool (contains (at idx str-lst) DALOS|CHARSET))
                        )
                        (or acc checkup)
                    )
                )
                false
                (enumerate 0 (- (length str-lst) 1))
            )
        )
    )
    (defun IGNIS|UEV_VirtualState (state:bool)
        (let
            (
                (t:bool (UR_VirtualToggle))
            )
            (enforce (= t state) "Invalid virtual gas collection state!")
            (if (not state)
                (IGNIS|UEV_VirtualOnCondition)
                true
            )
        )
    )
    (defun IGNIS|UEV_VirtualOnCondition ()
        (let
            (
                (ouro-id:string (UR_OuroborosID))
                (gas-id:string (UR_IgnisID))
            )
            (enforce (!= ouro-id BAR) "OURO Id must be set for IGNIS Collection to turn ON!")
            (enforce (!= gas-id BAR) "IGNIS Id must be set for IGNIS Collection to turn ON!")
            (enforce (!= gas-id ouro-id) "OURO and IGNIS id must be different for the IGNIS Collection to turn ON!")
        )
    )
    (defun IGNIS|UEV_NativeState (state:bool)
        (let
            (
                (t:bool (UR_NativeToggle))
            )
            (enforce (= t state) "Invalid native gas collection state!")
        )
    )
    (defun IGNIS|UEV_Patron (patron:string)
        @doc "Capability that ensures a DALOS account can act as gas payer, enforcing all necesarry restrictions"
        (if (UR_AccountType patron)
            (do
                (enforce (= patron DALOS|SC_NAME) "Only the DALOS Account can be a Smart Patron")
                (CAP_EnforceAccountOwnership DALOS|SC_NAME)
            )
            (CAP_EnforceAccountOwnership patron)
        )
    )
    ;;{F3}
    (defun UDC_AddICO:decimal (input:[object{OuronetDalos.IgnisCumulator}])
        @doc "Computes the Ignis Price from a Chain of IgnisCumulator Objects"
        (fold
            (lambda
                (acc:decimal item:object{OuronetDalos.IgnisCumulator})
                (let
                    (
                        (amount:decimal (at "price" item))
                        (tg:bool (at "trigger" item))
                    )
                    (if (not tg)
                        (+ acc amount)
                        acc
                    )
                )
            )
            0.0
            input
        )
    )
    (defun UDC_CompressICO:object{OuronetDalos.IgnisCumulator} (chain-ico:[object{OuronetDalos.IgnisCumulator}] lst-to-be-saved:list)
        (let
            (
                (price:decimal (UDC_AddICO chain-ico))
                (standard-trigger:bool (IGNIS|URC_IsVirtualGasZero))
            )
            (UDC_Cumulator price standard-trigger lst-to-be-saved)
        )
    )
    (defun UDC_Cumulator:object{OuronetDalos.IgnisCumulator} (price:decimal trigger:bool lst:list)
        @doc "Composes an IgnisCumulator Object"
        { "price":price, "trigger":trigger, "output":lst}
    )
    ;;{F4}
    (defun CAP_EnforceAccountOwnership (account:string)
        @doc "Enforces OuroNet Account Ownership"
        (let
            (
                (type:bool (UR_AccountType account))
            )
            (if type
                (UEV_SmartAccOwn account)
                (UEV_StandardAccOwn account)
            )
        )
    )
    ;;{F5}
    (defun A_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        (with-capability (GOV|DALOS_ADMIN)
            (C_DeploySmartAccount account guard kadena sovereign public)
        )
    )
    (defun A_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        (with-capability (GOV|DALOS_ADMIN)
            (C_DeployStandardAccount account guard kadena public)
        )
    )
    (defun A_IgnisToggle (native:bool toggle:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (IGNIS|C>TOGGLE native toggle)
            (XI_IgnisToggle native toggle)
        )
    )
    (defun A_SetIgnisSourcePrice (price:decimal)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (GOV|DALOS_ADMIN)
            (XB_UpdateOuroPrice price)
        )
    )
    (defun A_UpdatePublicKey (account:string new-public:string)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (GOV|DALOS_ADMIN)
            (write DALOS|AccountTable account
                {"public"     : new-public}
            )
        )
    )
    (defun A_UpdateUsagePrice (action:string new-price:decimal)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (GOV|DALOS_ADMIN)
            (let
                (
                    (ref-U|CT:module{OuronetConstants} U|CT)
                    (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                )
                (write DALOS|PricesTable action
                    {"price"     : (floor new-price kda-prec)}
                )
            )
        )
    )
    ;;{F6}
    (defun C_ControlSmartAccount (patron:string account:string payable-as-smart-contract:bool payable-by-smart-contract:bool payable-by-method:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (DALOS|C>CTRL_SM-ACC patron account payable-as-smart-contract payable-by-smart-contract)
            (XI_UpdateSmartAccountParameters account payable-as-smart-contract payable-by-smart-contract payable-by-method)
            (IGNIS|C_Collect patron account (UR_UsagePrice "ignis|small"))
        )
    )
    (defun C_DeploySmartAccount (account:string guard:guard kadena:string sovereign:string public:string)
        (UEV_DalosAdminOrTalosSummoner)
        (with-capability (DALOS|S>D-SM account guard kadena sovereign)
            (insert DALOS|AccountTable account
                { "public"                      : public
                , "guard"                       : guard
                , "kadena-konto"                : kadena
                , "sovereign"                   : sovereign
                , "governor"                    : guard

                , "smart-contract"              : true
                , "payable-as-smart-contract"   : false
                , "payable-by-smart-contract"   : false
                , "payable-by-method"           : true
                
                , "nonce"                       : 0
                , "elite"                       : DALOS|PLEB
                , "ouroboros"                   : DPTF|BLANK
                , "ignis"                       : DPTF|BLANK
                }  
            )
            (XI_UpdateKadenaLedger kadena account true)
            (if (not (IGNIS|URC_IsNativeGasZero))
                (KDA|C_Collect account (UR_UsagePrice "smart"))
                true
            )
        )
    )
    (defun C_DeployStandardAccount (account:string guard:guard kadena:string public:string)
        (UEV_DalosAdminOrTalosSummoner)
        (with-capability (DALOS|S>D-ST account guard kadena)
                (insert DALOS|AccountTable account
                    { "public"                      : public
                    , "guard"                       : guard
                    , "kadena-konto"                : kadena
                    , "sovereign"                   : account
                    , "governor"                    : guard
    
                    , "smart-contract"              : false
                    , "payable-as-smart-contract"   : false
                    , "payable-by-smart-contract"   : false
                    , "payable-by-method"           : false
                    
                    , "nonce"                       : 0
                    , "elite"                       : DALOS|PLEB
                    , "ouroboros"                   : DPTF|BLANK
                    , "ignis"                       : DPTF|BLANK
                    }  
                )
                (XI_UpdateKadenaLedger kadena account true)
                (if (not (IGNIS|URC_IsNativeGasZero))
                    (KDA|C_Collect account (UR_UsagePrice "standard"))
                    true
                )
            )
    )
    (defun C_RotateGuard (patron:string account:string new-guard:guard safe:bool)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (DALOS|C>RT_ACC account)
            (XI_RotateGuard account new-guard safe)
            (IGNIS|C_Collect patron account (UR_UsagePrice "ignis|small"))
        )
    )
    (defun C_RotateGovernor (patron:string account:string governor:guard)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "ATS|<"))
                (enforce-guard (P|UR "VST|<"))
                (enforce-guard (P|UR "LIQUID|<"))
                (enforce-guard (P|UR "OUROBOROS|<"))
                (enforce-guard (P|UR "SWP|<"))
                (enforce-guard (P|UR "TALOS-01"))
            ]
        )
        (with-capability (DALOS|C>RT_GOV account)
            (XI_RotateGovernor account governor)
            (IGNIS|C_Collect patron account (UR_UsagePrice "ignis|small"))
        )
    )
    (defun C_RotateKadena (patron:string account:string kadena:string)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (DALOS|C>RT_ACC account)
            (XI_RotateKadena account kadena)
            (XI_UpdateKadenaLedger (UR_AccountKadena account) account false)
            (XI_UpdateKadenaLedger kadena account true)
            (IGNIS|C_Collect patron account (UR_UsagePrice "ignis|small"))
        )
    )
    (defun C_RotateSovereign (patron:string account:string new-sovereign:string)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (DALOS|C>RT_SOV account new-sovereign)
            (XI_RotateSovereign account new-sovereign)
            (IGNIS|C_Collect patron account (UR_UsagePrice "ignis|small"))
        )
    )
    (defun C_TransferDalosFuel (sender:string receiver:string amount:decimal)
        (let
            (
                (ref-coin:module{fungible-v2} coin)
            )
            (ref-coin::transfer sender receiver amount)
        )
    )
    (defun IGNIS|C_Collect (patron:string active-account:string amount:decimal)
        (IGNIS|C_CollectWT patron active-account amount (IGNIS|URC_IsVirtualGasZero))
    )
    (defun IGNIS|C_CollectWT (patron:string active-account:string amount:decimal trigger:bool)
        (let
            (
                (ignis-discount:decimal (URC_IgnisGasDiscount patron))
                (discounted-ignis:decimal (* amount ignis-discount))
            )
            (enforce (>= amount 1.0) "Minimum Base Ignis Base that can be collected is 1.0")
            (if (not trigger)
                (with-capability (IGNIS|C>CLT patron active-account discounted-ignis)
                    (XI_IgnisCollect patron active-account discounted-ignis)
                )
                true
            )
            (with-read DALOS|AccountTable patron
                { "nonce" := n }
                (update DALOS|AccountTable patron { "nonce" : (+ n 1)})
            )
            (with-read DALOS|AccountTable active-account
                { "nonce" := n }
                (update DALOS|AccountTable active-account { "nonce" : (+ n 1)})
            )
        )
    )
    (defun KDA|C_Collect (sender:string amount:decimal)
        (KDA|C_CollectWT sender amount (IGNIS|URC_IsNativeGasZero))
    )
    (defun KDA|C_CollectWT (sender:string amount:decimal trigger:bool)
        (let
            (
                (split-discounted-kda:[decimal] (URC_SplitKDAPrices sender amount))
                (am0:decimal (at 0 split-discounted-kda))
                (am1:decimal (at 1 split-discounted-kda))
                (am2:decimal (at 2 split-discounted-kda))
                (kda-sender:string (UR_AccountKadena sender))
                (demiurgoi:[string] (UR_DemiurgoiID))
                (kda-cto:string (UR_AccountKadena (at 0 demiurgoi)))
                (kda-hov:string (UR_AccountKadena (at 1 demiurgoi)))
                (kda-ouroboros:string (UR_AccountKadena (GOV|OUROBOROS|SC_NAME)))
                (kda-dalos:string (UR_AccountKadena DALOS|SC_NAME))
            )
            (if (not trigger)
                (do
                    (C_TransferDalosFuel kda-sender kda-cto am0)          ;; 5% to KDA-CTO
                    (C_TransferDalosFuel kda-sender kda-hov am0)          ;; 5% to KDA-HOV
                    (C_TransferDalosFuel kda-sender kda-ouroboros am1)    ;;15% to KDA-Ouroboros (to be used for Liquid Kadena Protocol Fueling)
                    (C_TransferDalosFuel kda-sender kda-dalos am2)        ;;75% to KDA-Dalos (to be used for DALOS Gas Station)
                )
                (format "While Kadena Collection is {}, the {} KDA could not be collected" [trigger amount])
            )  
        )
    )
    ;;{F7}
    (defun XB_UpdateBalance (account:string snake-or-gas:bool new-balance:decimal)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "DPTF|<"))
            ]
        )
        (let
            (
                (obj:object{OuronetDalos.DPTF|BalanceSchema} (UR_TrueFungible account snake-or-gas))
                (new-obj:object{OuronetDalos.DPTF|BalanceSchema}
                    {"exist"                : (at "exist" obj)
                    ,"balance"              : new-balance
                    ,"role-burn"            : (at "role-burn" obj)
                    ,"role-mint"            : (at "role-mint" obj)
                    ,"role-transfer"        : (at "role-transfer" obj)
                    ,"role-fee-exemption"   : (at "role-fee-exemption" obj)
                    ,"frozen"               : (at "frozen" obj)}
                )
            )
            (with-capability (SECURE)
                (XI_UpdateTF account snake-or-gas new-obj)
            )
        )
    )
    (defun XB_UpdateOuroPrice (price:decimal)
        (enforce-one
            "Unallowed"
            [
                (enforce-guard (create-capability-guard (SECURE)))
                (enforce-guard (P|UR "SWP|<"))
                (enforce-guard (P|UR "SWPU|<"))
            ]
        )
        (update DALOS|GasManagementTable DALOS|VGD
            {"gas-source-price" : price}
        )
    )
    ;;
    (defun XE_ClearDispo (account:string)
        (enforce-guard (P|UR "TFT|<"))
        (with-capability (SECURE)
            (XB_UpdateBalance account true 0.0)
        )
    )
    (defun XE_UpdateBurnRole (account:string snake-or-gas:bool new-burn:bool)
        (enforce-guard (P|UR "DPTF|<"))
        (let
            (
                (obj:object{OuronetDalos.DPTF|BalanceSchema} (UR_TrueFungible account snake-or-gas))
                (new-obj:object{OuronetDalos.DPTF|BalanceSchema}
                    {"exist"                : (at "exist" obj)
                    ,"balance"              : (at "balance" obj)
                    ,"role-burn"            : new-burn
                    ,"role-mint"            : (at "role-mint" obj)
                    ,"role-transfer"        : (at "role-transfer" obj)
                    ,"role-fee-exemption"   : (at "role-fee-exemption" obj)
                    ,"frozen"               : (at "frozen" obj)}
                )
            )
            (with-capability (SECURE)
                (XI_UpdateTF account snake-or-gas new-obj)
            )
        )
    )
    (defun XE_UpdateElite (account:string amount:decimal)
        (enforce-guard (P|UR "DPMF|<"))
        (let
            (
                (ref-U|ATS:module{UtilityAts} U|ATS)
            )
            (if (= (UR_AccountType account) false)
                (update DALOS|AccountTable account
                    { "elite" : (ref-U|ATS::UDC_Elite amount)}
                )
                true
            )
        )
    )
    (defun XE_UpdateFeeExemptionRole (account:string snake-or-gas:bool new-fee-exemption:bool)
        (enforce-guard (P|UR "DPTF|<"))
        (let
            (
                (obj:object{OuronetDalos.DPTF|BalanceSchema} (UR_TrueFungible account snake-or-gas))
                (new-obj:object{OuronetDalos.DPTF|BalanceSchema}
                    {"exist"                : (at "exist" obj)
                    ,"balance"              : (at "balance" obj)
                    ,"role-burn"            : (at "role-burn" obj)
                    ,"role-mint"            : (at "role-mint" obj)
                    ,"role-transfer"        : (at "role-transfer" obj)
                    ,"role-fee-exemption"   : new-fee-exemption
                    ,"frozen"               : (at "frozen" obj)}
                )
            )
            (with-capability (SECURE)
                (XI_UpdateTF account snake-or-gas new-obj)
            )
        )
    )
    (defun XE_UpdateFreeze (account:string snake-or-gas:bool new-freeze:bool)
        (enforce-guard (P|UR "DPTF|<"))
        (let
            (
                (obj:object{OuronetDalos.DPTF|BalanceSchema} (UR_TrueFungible account snake-or-gas))
                (new-obj:object{OuronetDalos.DPTF|BalanceSchema}
                    {"exist"                : (at "exist" obj)
                    ,"balance"              : (at "balance" obj)
                    ,"role-burn"            : (at "role-burn" obj)
                    ,"role-mint"            : (at "role-mint" obj)
                    ,"role-transfer"        : (at "role-transfer" obj)
                    ,"role-fee-exemption"   : (at "role-fee-exemption" obj)
                    ,"frozen"               : new-freeze}
                )
            )
            (with-capability (SECURE)
                (XI_UpdateTF account snake-or-gas new-obj)
            )
        )
    )
    (defun XE_UpdateMintRole (account:string snake-or-gas:bool new-mint:bool)
        (enforce-guard (P|UR "DPTF|<"))
        (let
            (
                (obj:object{OuronetDalos.DPTF|BalanceSchema} (UR_TrueFungible account snake-or-gas))
                (new-obj:object{OuronetDalos.DPTF|BalanceSchema}
                    {"exist"                : (at "exist" obj)
                    ,"balance"              : (at "balance" obj)
                    ,"role-burn"            : (at "role-burn" obj)
                    ,"role-mint"            : new-mint
                    ,"role-transfer"        : (at "role-transfer" obj)
                    ,"role-fee-exemption"   : (at "role-fee-exemption" obj)
                    ,"frozen"               : (at "frozen" obj)}
                )
            )
            (with-capability (SECURE)
                (XI_UpdateTF account snake-or-gas new-obj)
            )
        )
    )
    (defun XE_UpdateTransferRole (account:string snake-or-gas:bool new-transfer:bool)
        (enforce-guard (P|UR "DPTF|<"))
        (let
            (
                (obj:object{OuronetDalos.DPTF|BalanceSchema} (UR_TrueFungible account snake-or-gas))
                (new-obj:object{OuronetDalos.DPTF|BalanceSchema}
                    {"exist"                : (at "exist" obj)
                    ,"balance"              : (at "balance" obj)
                    ,"role-burn"            : (at "role-burn" obj)
                    ,"role-mint"            : (at "role-mint" obj)
                    ,"role-transfer"        : new-transfer
                    ,"role-fee-exemption"   : (at "role-fee-exemption" obj)
                    ,"frozen"               : (at "frozen" obj)}
                )
            )
            (with-capability (SECURE)
                (XI_UpdateTF account snake-or-gas new-obj)
            )
        )
    )
    ;;
    (defun XI_IgnisCollect (patron:string active-account:string amount:decimal)
        (require-capability (IGNIS|C>CLT patron active-account amount))
        (let
            (
                (sender-type:bool (UR_AccountType active-account))
                (account-type:bool (UR_AccountType patron))
            )
            (if (not account-type)
                (if (= sender-type false)
                    (XI_IgnisCollectST patron amount)
                    (XI_IgnisCollectSM patron active-account amount)
                )
                true
            )
        )
    )
    (defun XI_IgnisCollectSM (patron:string active-account:string amount:decimal)
        @doc "Collects GAS when the <active-account> is a Smart DALOS Account"
        (require-capability (IGNIS|C>CLT_SM patron active-account amount))
        (let
            (
                (gas-pot:string (UR_Tanker))
                (quarter:decimal (* amount GAS_QUARTER))
                (rest:decimal (- amount quarter))                
            )
            (XI_IgnisTransfer patron gas-pot rest)              ;;3/4 to defined Gas-Tanker Account
            (XI_IgnisTransfer patron active-account quarter)    ;;1/4 to <Active-Account> because its a Smart DALOS Account
            (XI_IgnisIncrement false amount)                    ;;Increment the amount of Virtual Gas Spent
        )
    )
    (defun XI_IgnisCollectST (patron:string amount:decimal)
        (require-capability (IGNIS|C>CLT_ST patron amount))
        (XI_IgnisTransfer patron (UR_Tanker) amount)
        (XI_IgnisIncrement false amount)
    )
    (defun XI_IgnisCredit (receiver:string ta:decimal)
        (require-capability (IGNIS|C>CREDIT receiver))
        (XB_UpdateBalance receiver false (+ (UR_TF_AccountSupply receiver false) ta))
    )
    (defun XI_IgnisDebit (sender:string ta:decimal)
        (require-capability (IGNIS|C>DEBIT sender ta))
        (XB_UpdateBalance sender false (- (UR_TF_AccountSupply sender false) ta))
    )
    (defun XI_IgnisIncrement (native:bool increment:decimal)
        (require-capability (SECURE))
        (if (= native true)
            (update DALOS|GasManagementTable DALOS|VGD
                {"native-gas-spent" : (+ (UR_NativeSpent) increment)}
            )
            (update DALOS|GasManagementTable DALOS|VGD
                {"virtual-gas-spent" : (+ (UR_VirtualSpent) increment)}
            )
        )
    )
    (defun XI_IgnisToggle (native:bool toggle:bool)
        (require-capability (GOV|DALOS_ADMIN))
        (if (= native true)
            (update DALOS|GasManagementTable DALOS|VGD
                {"native-gas-toggle" : toggle}
            )
            (update DALOS|GasManagementTable DALOS|VGD
                {"virtual-gas-toggle" : toggle}
            )
        )
    )
    (defun XI_IgnisTransfer (sender:string receiver:string ta:decimal)
        (require-capability (IGNIS|C>TRANSFER sender receiver ta))
        (XI_IgnisDebit sender ta)
        (XI_IgnisCredit receiver ta)
    )
    (defun XI_RotateGovernor (account:string governor:guard)
        (require-capability (DALOS|F>GOV account))
        (update DALOS|AccountTable account
            {"governor"                        : governor}
        )
    )
    (defun XI_RotateGuard (account:string new-guard:guard safe:bool)
        (require-capability (DALOS|F>OWNER account))
        (if safe
            (enforce-guard new-guard)
            true
        )
        (update DALOS|AccountTable account
            {"guard"                        : new-guard}
        )
    )
    (defun XI_RotateKadena (account:string kadena:string)
        (require-capability (DALOS|F>OWNER account))
        (update DALOS|AccountTable account
            {"kadena-konto"                  : kadena}
        )
    )
    (defun XI_RotateSovereign (account:string new-sovereign:string)
        (require-capability (DALOS|C>RT_SOV account new-sovereign))
        (update DALOS|AccountTable account
            {"sovereign"                        : new-sovereign}
        )
    )
    (defun XI_UpdateKadenaLedger (kadena:string dalos:string direction:bool)
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (with-default-read DALOS|KadenaLedger kadena
                { "dalos"    : [BAR] }
                { "dalos"    := d }
                (let
                    (
                        (add-lst:[string]
                            (if (= d [BAR])
                                [dalos]
                                (if (contains dalos d)
                                    d
                                    (ref-U|LST::UC_AppL d dalos)
                                )
                            )
                        )
                        (data-len:integer (length d))
                        (first:string (at 0 d))
                        (rmv-lst:[string]
                            (if (and (= data-len 1)(!= first BAR))
                                [BAR]
                                (ref-U|LST::UC_RemoveItem d dalos)
                            )
                        )
                    )
                    (if direction
                        (write DALOS|KadenaLedger kadena
                            { "dalos" : add-lst}
                        )
                        (write DALOS|KadenaLedger kadena
                            { "dalos" : rmv-lst}
                        )
                    )
                    
                )
            )
        )
    )
    (defun XI_UpdateSmartAccountParameters (account:string pasc:bool pbsc:bool pbm:bool)
        (require-capability (DALOS|C>CTRL_SM-ACC account pasc pbsc pbm))
        (update DALOS|AccountTable account
            {"payable-as-smart-contract"    : pasc
            ,"payable-by-smart-contract"    : pbsc
            ,"payable-by-method"            : pbm}
        )
    )
    (defun XI_UpdateTF (account:string snake-or-gas:bool new-obj:object{OuronetDalos.DPTF|BalanceSchema})
        (require-capability (SECURE))
        (if snake-or-gas
            (update DALOS|AccountTable account
                {"ouroboros" : new-obj}
            )
            (update DALOS|AccountTable account
                {"ignis" : new-obj}
            )
        )
    )
)

(create-table P|T)
(create-table DALOS|PropertiesTable)
(create-table DALOS|GasManagementTable)
(create-table DALOS|PricesTable)
(create-table DALOS|AccountTable)
(create-table DALOS|KadenaLedger)