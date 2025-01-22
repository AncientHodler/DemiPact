;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module VESTING GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_VST            (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    (defconst GOV|SC_VST            (keyset-ref-guard VST|SC_KEY))

    (defconst VST|SC_KEY            (+ UTILS.NS_USE ".dh_sc_vesting-keyset"))
    (defconst VST|SC_NAME           "Σ.şZïζhЛßdяźπПЧDΞZülΦпφßΣитœŸ4ó¥ĘкÌЦ₱₱AÚюłćβρèЬÍŠęgĎwтäъνFf9źdûъtJCλúp₿ÌнË₿₱éåÔŽvCOŠŃpÚKюρЙΣΩìsΞτWpÙŠŹЩпÅθÝØpтŮыØșþшу6GтÃêŮĞбžŠΠŞWĆLτЙđнòZЫÏJÿыжU6ŽкЫVσ€ьqθtÙѺSô€χ")       ;;Former DalosVesting
    (defconst VST|SC_KDA-NAME       "k:4728327e1b4790cb5eb4c3b3c531ba1aed00e86cd9f6252bfb78f71c44822d6d")
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|VESTING_ADMIN))
    )
    (defcap GOV|VESTING_ADMIN ()
        (enforce-one
            "VESTING Admin not satisfed"
            [
                (enforce-guard GOV|MD_VST)
                (enforce-guard GOV|SC_VST)
            ]
        )
    )
    (defcap VST|GOV ()
        @doc "Governor Capability for the Vesting Smart DALOS Account"
        true
    )
    ;;{G3}
    (defun VST|SetGovernor (patron:string)
        (DALOS.DALOS|C_RotateGovernor
            patron
            VST|SC_NAME
            (create-capability-guard (VST|GOV))
        )
    )
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{DALOS.P|S})
    ;;{P3}
    (defcap P|VST|CALLER ()
        true
    )
    (defcap P|VST|UPDATE ()
        true
    )
    (defcap P|VST|LINK ()
        @event
        (compose-capability (P|VST|CALLER))
        (compose-capability (VST|DEFINE))
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|VESTING_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        (DPMF.P|A_Add
            "VST|UpVes"
            (create-capability-guard (P|VST|UPDATE))
        )
        (DPMF.P|A_Add
            "VST|Caller"
            (create-capability-guard (P|VST|CALLER))
        )
    )
    ;;
    ;;{1}
    (defschema VST|MetaDataSchema
        release-amount:decimal
        release-date:time
    )
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
    (defcap VST|DEFINE ()
        true
    )
    ;;{5}
    ;;{6}
    ;;{7}
    (defcap VST|C>VEST (vester:string target-account:string id:string)
        @event
        (DALOS.DALOS|UEV_EnforceAccountType vester false)
        (DALOS.DALOS|UEV_EnforceAccountType target-account false)
        (DPTF.DPTF|CAP_Owner id)
        (DPTF.DPTF|UEV_Vesting id true)
        (VST|UEV_Active id (DPTF.DPTF|UR_Vesting id))
        (compose-capability (VST|GOV))
    )
    (defcap VST|C>CULL (culler:string id:string)
        @event
        (DALOS.DALOS|UEV_EnforceAccountType culler false)
        (DPMF.DPMF|UEV_Vesting id true)
        (VST|UEV_Active (DPMF.DPMF|UR_Vesting id) id)
        (compose-capability (VST|GOV))
    )
    (defcap VST|C>UPDATE (dptf:string dpmf:string)
        (DPTF.DPTF|UEV_id dptf)
        (DPMF.DPMF|UEV_id dpmf)
        (DPTF.DPTF|CAP_Owner dptf)
        (DPMF.DPMF|CAP_Owner dpmf)
        (VST|UEV_Active dptf dpmf)
        (let
            (
                (tf-vesting-id:string (DPTF.DPTF|UR_Vesting dptf))
                (mf-vesting-id:string (DPMF.DPMF|UR_Vesting dpmf))
                (iz-hot-rbt:bool (DPMF.DPMF|URC_IzRBT dpmf))
            )
            (enforce 
                (and (= tf-vesting-id UTILS.BAR) (= mf-vesting-id UTILS.BAR) )
                "Vesting Pairs are immutable !"
            )
            (enforce (= iz-hot-rbt false) "A DPMF defined as a hot-rbt cannot be used as Vesting Token in Vesting pair")
        )
        (compose-capability (P|VST|UPDATE))
    )
    ;;
    ;;{8}
    ;;{9}
    (defun VST|UDC_ComposeVestingMetaData:[object{VST|MetaDataSchema}] (id:string amount:decimal offset:integer duration:integer milestones:integer)
        (DPTF.DPTF|UEV_Amount id amount)
        (UTILS.VST|UEV_MilestoneWithTime offset duration milestones)
        (let*
            (
                (amount-lst:[decimal] (VST|UC_SplitBalanceForVesting id amount milestones))
                (date-lst:[time] (VST|UC_MakeVestingDateList offset duration milestones))
                (meta-data:[object{VST|MetaDataSchema}] (zip (lambda (x:decimal y:time) { "release-amount": x, "release-date": y }) amount-lst date-lst))
            )
            meta-data
        )
    )
    ;;{10}
    (defun VST|UEV_Active (dptf:string dpmf:string)
        (let
            (
                (dptf-fee-exemption:bool (DPTF.DPTF|UR_AccountRoleFeeExemption dptf VST|SC_NAME))
                (create-role:bool (DPMF.DPMF|UR_AccountRoleCreate dpmf VST|SC_NAME))
                (add-q-role:bool (DPMF.DPMF|UR_AccountRoleNFTAQ dpmf VST|SC_NAME))
                (burn-role:bool (DPMF.DPMF|UR_AccountRoleBurn dpmf VST|SC_NAME))
                (transfer-role:bool (DPMF.DPMF|UR_AccountRoleTransfer dpmf VST|SC_NAME))
            )
            (enforce (= dptf-fee-exemption true) "<role-fee-exemption> needed on DalosVesting")
            (enforce (= create-role true) "<role-nft-create> needed on DalosVesting")
            (enforce (= add-q-role true) "<role-nft-add-quantity> needed on DalosVesting")
            (enforce (= burn-role true) "<role-nft-burn> needed on DalosVesting")
            (enforce (= transfer-role true) "<role-transfer> needed on DalosVesting")
        )
    )
    ;;{11}
    (defun VST|UC_SplitBalanceForVesting:[decimal] (id:string amount:decimal milestones:integer)
        (UTILS.VST|UC_SplitBalanceForVesting (DPTF.DPTF|UR_Decimals id) amount milestones)
    )
    (defun VST|UC_MakeVestingDateList:[time] (offset:integer duration:integer milestones:integer)
        (UTILS.VST|UC_MakeVestingDateList offset duration milestones)
    )
    ;;{12}
    ;;{13}
    (defun VST|URC_CullMetaDataAmount:decimal (client:string id:string nonce:integer)
        (let*
            (
                (meta-data:[object{VST|MetaDataSchema}] (DPMF.DPMF|UR_AccountBatchMetaData id nonce client))
                (culled-amount:decimal
                    (fold
                        (lambda
                            (acc:decimal item:object{VST|MetaDataSchema})
                            (let*
                                (
                                    (balance:decimal (at "release-amount" item))
                                    (date:time (at "release-date" item))
                                    (present-time:time (at "block-time" (chain-data)))
                                    (t:decimal (diff-time present-time date))
                                )
                                (if (>= t 0.0)
                                    (+ acc balance)
                                    acc
                                )
                            )
                        )
                        0.0
                        meta-data
                    )
                )
            )
            culled-amount
        )
    )
    (defun VST|URC_CullMetaDataObject:[object{VST|MetaDataSchema}] (client:string id:string nonce:integer)
        (fold
            (lambda
                (acc:[object{VST|MetaDataSchema}] item:object{VST|MetaDataSchema})
                (let*
                    (
                        (date:time (at "release-date" item))
                        (present-time:time (at "block-time" (chain-data)))
                        (t:decimal (diff-time present-time date))
                    )
                    (if (< t 0.0)
                        (UTILS.LIST|UC_AppendLast acc item)
                        acc
                    )
                )
            )
            []
            (DPMF.DPMF|UR_AccountBatchMetaData id nonce client)
        )
    )
    ;;
    ;;{14}
    ;;{15}
    (defun VST|C_CreateVestingLink:string (patron:string dptf:string)
        (enforce-guard (P|UR "TALOS|Summoner"))
        (with-capability (P|VST|LINK)
            (let*
                (
                    (dptf-owner:string (DPTF.DPTF|UR_Konto dptf))
                    (dptf-name:string (DPTF.DPTF|UR_Name dptf))
                    (dptf-ticker:string (DPTF.DPTF|UR_Ticker dptf))
                    (dptf-decimals:integer (DPTF.DPTF|UR_Decimals dptf))
                    (s1:string "Vested")
                    (s2:string "W")
                    (l1:integer (- UTILS.MAX_TOKEN_NAME_LENGTH (length s1)))
                    (l2:integer (- UTILS.MAX_TOKEN_TICKER_LENGTH (length s2)))
                    (dpmf-name:string (concat [s1 (take l1 dptf-name)]))
                    (dpmf-ticker:string (concat [s2 (take l2 dptf-ticker)]))
                    (dpmf-l:[string]
                        (DPMF.DPMF|X_IssueFree
                            patron
                            dptf-owner
                            [dpmf-name]
                            [dpmf-ticker]
                            [dptf-decimals]
                            [false]
                            [false]
                            [true]
                            [false]
                            [false]
                            [false]
                            [true]
                        )
                    )
                    (dpmf:string (at 0 dpmf-l))
                    (kda-costs:decimal (DALOS.DALOS|UR_UsagePrice "dpmf"))
                )
                (DPTF.DPTF|C_DeployAccount dptf VST|SC_NAME)
                (ATSI.DPTF|C_TgFeeExemptionR patron dptf VST|SC_NAME true)
                (DPMF.DPMF|C_DeployAccount dpmf VST|SC_NAME)
                (DPMF.DPMF|C_TgTransferR patron dpmf VST|SC_NAME true)
                (ATSI.DPMF|C_TgBurnR patron dpmf VST|SC_NAME true)
                (ATSI.DPMF|C_MoveCreateRole patron dpmf VST|SC_NAME)
                (ATSI.DPMF|C_TgAddQuantityR patron dpmf VST|SC_NAME true)
                (VST|X_DefineVestingPair patron dptf dpmf)
                (DALOS.KDA|C_Collect patron kda-costs)
                dpmf
            )
        )
    )
    (defun VST|C_Vest (patron:string vester:string target-account:string id:string amount:decimal offset:integer duration:integer milestones:integer)
        (with-capability (VST|C>VEST vester target-account id)
            (let*
                (
                    (dpmf-id:string (DPTF.DPTF|UR_Vesting id))
                    (meta-data:string (VST|UDC_ComposeVestingMetaData id amount offset duration milestones))
                    (nonce:integer (+ (DPMF.DPMF|UR_NoncesUsed id) 1))
                )
                (DPMF.DPMF|C_Mint patron dpmf-id VST|SC_NAME amount meta-data)
                (TFT.DPTF|C_Transfer patron id vester VST|SC_NAME amount true)
                (DPMF.DPMF|C_Transfer patron dpmf-id nonce VST|SC_NAME target-account amount true)
            )
        )
    )
    (defun VST|C_Cull (patron:string culler:string id:string nonce:integer)
        (with-capability (VST|C>CULL culler id)
            (let*
                (
                    (dptf-id:string (DPMF.DPMF|UR_Vesting id))
                    (initial-amount:decimal (DPMF.DPMF|UR_AccountBatchSupply id nonce culler))
                    (culled-amount:decimal (VST|URC_CullMetaDataAmount culler id nonce))
                    (return-amount:decimal (- initial-amount culled-amount))
                )
                (if (= return-amount 0.0)
                    (TFT.DPTF|C_Transfer patron dptf-id VST|SC_NAME culler initial-amount true)
                    (let*
                        (
                            (remaining-vesting-meta-data:[object{VST|MetaDataSchema}] (VST|URC_CullMetaDataObject culler id nonce))
                            (new-nonce:integer (+ (DPMF.DPMF|UR_NoncesUsed id) 1))
                        )
                        (DPMF.DPMF|C_Mint patron id VST|SC_NAME return-amount remaining-vesting-meta-data)
                        (TFT.DPTF|C_Transfer patron dptf-id VST|SC_NAME culler culled-amount true)
                        (DPMF.DPMF|C_Transfer patron id new-nonce VST|SC_NAME culler return-amount true)
                    )
                )
                (DPMF.DPMF|C_Transfer patron id nonce culler VST|SC_NAME initial-amount true)
                (DPMF.DPMF|C_Burn patron id nonce VST|SC_NAME initial-amount)
            )
        )
    )
    ;;{16}
    (defun VST|X_DefineVestingPair (patron:string dptf:string dpmf:string)
        (require-capability (VST|DEFINE))
        (with-capability (VST|C>UPDATE dptf dpmf)
            (DPMF.BASIS|X_UpdateVesting dptf dpmf)
            (DALOS.IGNIS|C_Collect patron (DPTF.DPTF|UR_Konto dptf) (DALOS.DALOS|UR_UsagePrice "ignis|biggest"))
        )
    )
)

(create-table P|T)