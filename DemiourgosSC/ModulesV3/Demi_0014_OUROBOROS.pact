;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module OUROBOROS GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_OUROBOROS      (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_OUROBOROS      (keyset-ref-guard LIQUIDFUEL.OUROBOROS|SC_KEY))
    (defconst OUROBOROS|SC_NAME     DALOS.OUROBOROS|SC_NAME)
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|OUROBOROS_ADMIN))
    )
    (defcap GOV|OUROBOROS_ADMIN ()
        (enforce-one
            "OUROBOROS Admin not satisfed"
            [
                (enforce-guard GOV|MD_OUROBOROS)
                (enforce-guard GOV|SC_OUROBOROS)
            ]
        )
    )
    (defcap OUROBOROS|GOV ()
        @doc "Governor Capability for the Ouroboros Smart DALOS Account"
        true
    )
    ;;{G3}
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
        (with-capability (GOV|OUROBOROS_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        (LIQUIDFUEL.P|A_Add
            "OUROBOROS|RemoteGovernor"
            (create-capability-guard (OUROBOROS|GOV))
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
    ;;{5}
    ;;{6}
    ;;{7}
    (defcap IGNIS|C>SUBLIMATE (patron:string client:string target:string)
        @event
        (DALOS.DALOS|UEV_EnforceAccountType patron false)
        (DALOS.DALOS|UEV_EnforceAccountType client false)
        (DALOS.DALOS|UEV_EnforceAccountType target false)
        (IGNIS|UEV_Exchange)
        (compose-capability (OUROBOROS|GOV))
    )
    (defcap IGNIS|C>COMPRESS (patron:string client:string)
        @event
        (DALOS.DALOS|UEV_EnforceAccountType patron false)
        (DALOS.DALOS|UEV_EnforceAccountType client false)
        (IGNIS|UEV_Exchange)
        (compose-capability (OUROBOROS|GOV))
    )
    (defcap OUROBOROS|C>WITHDRAW (patron:string id:string target:string)
        @event
        (DALOS.DALOS|UEV_EnforceAccountType target false)
        (DPTF.DPTF|CAP_Owner id)
        (compose-capability (OUROBOROS|GOV))
    )
    ;;
    ;;{8}
    ;;{9}
    ;;{10}
    (defun DALOS|UEV_Live ()
        (let
            (
                (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                (gas-id:string (DALOS.DALOS|UR_IgnisID))
            )
            (enforce (!= ouro-id UTILS.BAR) "Ouroboros is not set")
            (enforce (!= gas-id UTILS.BAR) "Ignis is not set")
        )
    )
    (defun IGNIS|UEV_Exchange ()
        (DALOS|UEV_Live)
        (let*
            (
                (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                (gas-id:string (DALOS.DALOS|UR_IgnisID))
                (o-rm:bool (DPTF.DPTF|UR_AccountRoleMint ouro-id OUROBOROS|SC_NAME))
                (o-rb:bool (DPTF.DPTF|UR_AccountRoleBurn ouro-id OUROBOROS|SC_NAME))
                (t1:bool (and o-rm o-rb))
                (g-rm:bool (DPTF.DPTF|UR_AccountRoleMint gas-id OUROBOROS|SC_NAME))
                (g-rb:bool (DPTF.DPTF|UR_AccountRoleBurn gas-id OUROBOROS|SC_NAME))
                (t2:bool (and g-rm g-rb))
                (t3:bool (and t1 t2))
            )
            (enforce t3 "Permission invalid for Ignis Exchange")
        )
    )
    ;;{11}
    ;;{12}
    (defun DPTF-DPMF-ATS|UR_OwnedTokens (account:string table-to-query:integer)
        (UTILS.UTILS|UEV_PositionalVariable table-to-query 3 "Invalid Ownership Position")
        (let*
            (
                (keyz:[string] (TFT.DPTF-DPMF-ATS|UR_TableKeys table-to-query true))
                (owners-lst:[string]
                    (fold
                        (lambda
                            (acc:[string] item:string)
                            (UTILS.LIST|UC_AppendLast 
                                acc
                                (if (= table-to-query 1)
                                    (DPTF.DPTF|UR_Konto item)
                                    (if (= table-to-query 2)
                                        (DPMF.DPMF|UR_Konto item)
                                        (ATS.ATS|UR_OwnerKonto item)
                                    )
                                )
                            )
                        )
                        []
                        keyz
                    )
                )
                (owner-pos:[integer] (UTILS.LIST|UC_Search owners-lst account))
            )
            (fold
                (lambda
                    (acc:[string] idx:integer)
                    (UTILS.LIST|UC_AppendLast acc (at (at idx owner-pos) keyz))
                )
                []
                (enumerate 0 (- (length owner-pos) 1))
            )
            
        )
    )
    ;;{13}
    (defun ATS|URC_RT-Unbonding (atspair:string reward-token:string)
        (ATS.ATS|UEV_RewardTokenExistance atspair reward-token true)
        (fold
            (lambda
                (acc:decimal account:string)
                (+ acc (ATS.ATS|URC_AccountUnbondingBalance atspair account reward-token))
            )
            0.0
            (TFT.DPTF-DPMF-ATS|UR_FilterKeysForInfo atspair 3 false)
        )
    )
    (defun IGNIS|URC_Sublimate:decimal (ouro-amount:decimal)
        (enforce (>= ouro-amount 1.00) "Only amounts greater than or equal to 1.0 can be used to make gas!")
        (DPTF.DPTF|UEV_Amount (DALOS.DALOS|UR_OuroborosID) ouro-amount)
        (let*
            (
                (ouro-price:decimal (DALOS.DALOS|UR_OuroborosPrice))
                (ouro-price-used:decimal (if (<= ouro-price 1.00) 1.00 ouro-price))
                (ignis-id:string (DALOS.DALOS|UR_IgnisID))
            )
            (enforce (!= ignis-id UTILS.BAR) "Gas Token isnt properly set")
            (let*
                (
                    (ignis-precision:integer (DPTF.DPTF|UR_Decimals ignis-id))
                    (raw-ignis-amount-per-unit:decimal (floor (* ouro-price-used 100.0) ignis-precision))
                    (raw-ignis-amount:decimal (floor (* raw-ignis-amount-per-unit ouro-amount) ignis-precision))
                    (output-ignis-amount:decimal (floor raw-ignis-amount 0))
                )
                output-ignis-amount
            )
        )
    )
    (defun IGNIS|URC_Compress:[decimal] (ignis-amount:decimal)
        (enforce (= (floor ignis-amount 0) ignis-amount) "Only whole Units of GAS(Ignis) can be compressed")
        (enforce (>= ignis-amount 1.00) "Only amounts greater than or equal to 1.0 can be used to compress gas")
        (DPTF.DPTF|UEV_Amount (DALOS.DALOS|UR_IgnisID) ignis-amount)
        (let*
            (
                (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                (ouro-price:decimal (DALOS.DALOS|UR_OuroborosPrice))
                (ouro-price-used:decimal (if (<= ouro-price 1.00) 1.00 ouro-price))
                (ouro-precision:integer (DPTF.DPTF|UR_Decimals ouro-id))
                (raw-ouro-amount:decimal (floor (/ ignis-amount (* ouro-price-used 100.0)) ouro-precision))
                (promile-split:[decimal] (UTILS.ATS|UC_PromilleSplit 15.0 raw-ouro-amount ouro-precision))
                (ouro-remainder-amount:decimal (floor (at 0 promile-split) ouro-precision))
                (ouro-fee-amount:decimal (at 1 promile-split))
            )
            [ouro-remainder-amount ouro-fee-amount]
        )
    )
    ;;
    ;;{14}
    ;;{15}
    (defun IGNIS|C_Sublimate:decimal (patron:string client:string target:string ouro-amount:decimal)
        (with-capability (IGNIS|C>SUBLIMATE patron client target)
            (let*
                (
                    (ignis-id:string (DALOS.DALOS|UR_IgnisID))
                    (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                    (ouro-precision:integer (DPTF.DPTF|UR_Decimals ouro-id))
                    (ouro-split:[decimal] (UTILS.ATS|UC_PromilleSplit 10.0 ouro-amount ouro-precision))
                    (ouro-remainder-amount:decimal (at 0 ouro-split))
                    (ouro-fee-amount:decimal (at 1 ouro-split))
                    (ignis-amount:decimal (IGNIS|URC_Sublimate ouro-remainder-amount))
                )
            ;;01]Client sends OURO <ouro-amount> to the Ouroboros Smart DALOS Account
                (TFT.DPTF|C_Transfer patron ouro-id client OUROBOROS|SC_NAME ouro-amount true)
            ;;02]Ouroboros burns OURO <ouro-remainder-amount>
                (DPTF.DPTF|C_Burn patron ouro-id OUROBOROS|SC_NAME ouro-remainder-amount)
            ;;03]Ouroboros mints GAS(Ignis) <ignis-amount>
                (DPTF.DPTF|C_Mint patron ignis-id OUROBOROS|SC_NAME ignis-amount false)
            ;;04]Ouroboros transfers GAS(Ignis) <ignis-amount> to <target>
                (TFT.DPTF|C_Transfer patron ignis-id OUROBOROS|SC_NAME target ignis-amount true)
            ;;05]Ouroboros transmutes OURO <ouro-fee-amount>
                (TFT.DPTF|C_Transmute patron ouro-id OUROBOROS|SC_NAME ouro-fee-amount)
                ignis-amount
            )
        )
    )
    (defun IGNIS|C_Compress:decimal (patron:string client:string ignis-amount:decimal)
        (with-capability (IGNIS|C>COMPRESS patron client)
            (let*
                (
                    (ouro-id:string (DALOS.DALOS|UR_OuroborosID))
                    (ignis-id:string (DALOS.DALOS|UR_IgnisID))
                    (ignis-to-ouro:[decimal] (IGNIS|URC_Compress ignis-amount))
                    (ouro-remainder-amount:decimal (at 0 ignis-to-ouro))
                    (ouro-fee-amount:decimal (at 1 ignis-to-ouro))
                    (total-ouro:decimal (+ ouro-remainder-amount ouro-fee-amount))
                )
            ;;01]Client sends GAS(Ignis) <ignis-amount> to the Ouroboros Smart DALOS Account
                (TFT.DPTF|C_Transfer patron ignis-id client OUROBOROS|SC_NAME ignis-amount true)
            ;;02]Ouroboros burns GAS(Ignis) <ignis-amount>
                (DPTF.DPTF|C_Burn patron ignis-id OUROBOROS|SC_NAME ignis-amount)
            ;;03]Ouroboros mints OURO <total-ouro>
                (DPTF.DPTF|C_Mint patron ouro-id OUROBOROS|SC_NAME total-ouro false)
            ;;04]Ouroboros transfers OURO <ouro-remainder-amount> to <client>
                (TFT.DPTF|C_Transfer patron ouro-id OUROBOROS|SC_NAME client ouro-remainder-amount true)
            ;;05]Ouroboros transmutes OURO <ouro-fee-amount>
                (TFT.DPTF|C_Transmute patron ouro-id OUROBOROS|SC_NAME ouro-fee-amount)
                ouro-remainder-amount
            )
        )
    )
    (defun OUROBOROS|C_WithdrawFees (patron:string id:string target:string)
        (with-capability (OUROBOROS|C>WITHDRAW patron id target)
            (let
                (
                    (withdraw-amount:decimal (DPTF.DPTF|UR_AccountSupply id OUROBOROS|SC_NAME))
                )
                (enforce (> withdraw-amount 0.0) (format "There are no {} fees to be withdrawn from {}" [id OUROBOROS|SC_NAME]))
            ;;1]Patron withdraws Fees from Ouroboros Smart DALOS Account to a target Normal DALOS Account
                (TFT.DPTF|C_Transfer patron id OUROBOROS|SC_NAME target withdraw-amount true)
            )
        )
    )
    ;;{16}
)

(create-table P|T)