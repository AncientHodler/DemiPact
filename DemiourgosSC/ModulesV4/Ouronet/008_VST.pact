;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module VST GOV
    ;;
    (implements OuronetPolicy)
    (implements Vesting)
    ;;{G1}
    (defconst GOV|MD_VST            (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_VST            (keyset-ref-guard VST|SC_KEY))
    ;;
    (defconst VST|SC_KEY            (GOV|VestingKey))
    (defconst VST|SC_NAME           (GOV|VST|SC_NAME))
    (defconst VST|SC_KDA-NAME       (GOV|VST|SC_KDA-NAME))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|VESTING_ADMIN)))
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
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|VestingKey ()        (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|VestingKey)))
    (defun GOV|VST|SC_NAME ()       (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|VST|SC_NAME)))
    (defun GOV|VST|SC_KDA-NAME ()   (at 0 ["k:4728327e1b4790cb5eb4c3b3c531ba1aed00e86cd9f6252bfb78f71c44822d6d"]))
    (defun VST|SetGovernor (patron:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
            )
            (with-capability (P|VST|CALLER)
                (ref-DALOS::C_RotateGovernor
                    patron
                    VST|SC_NAME
                    (create-capability-guard (VST|GOV))
                )
            )
        ) 
    )
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    ;;{P3}
    (defcap P|VST|CALLER ()
        true
    )
    (defcap P|VST|UPDATE ()
        true
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
        (let
            (
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|TFT:module{OuronetPolicy} TFT)
            )
            (ref-P|DALOS::P|A_Add 
                "VST|Caller"
                (create-capability-guard (P|VST|CALLER))
            )
            (ref-P|DPTF::P|A_Add
                "VST|Caller"
                (create-capability-guard (P|VST|CALLER))
            )
            (ref-P|DPMF::P|A_Add
                "VST|UpdateVesting"
                (create-capability-guard (P|VST|UPDATE))
            )
            (ref-P|DPMF::P|A_Add
                "VST|Caller"
                (create-capability-guard (P|VST|CALLER))
            )
            (ref-P|ATS::P|A_Add
                "VST|Caller"
                (create-capability-guard (P|VST|CALLER))
            )
            (ref-P|TFT::P|A_Add
                "VST|Caller"
                (create-capability-guard (P|VST|CALLER))
            )
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    ;;
    ;;{C1}
    (defcap VST|DEFINE ()
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap VST|C>LINK ()
        @event
        (compose-capability (VST|DEFINE))
        (compose-capability (P|VST|CALLER))
    )
    (defcap VST|C>VEST (vester:string target-account:string id:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DALOS::UEV_EnforceAccountType vester false)
            (ref-DALOS::UEV_EnforceAccountType target-account false)
            (ref-DPTF::CAP_Owner id)
            (ref-DPTF::UEV_Vesting id true)
            (UEV_Active id (ref-DPTF::UR_Vesting id))
            (compose-capability (VST|GOV))
            (compose-capability (P|VST|CALLER))
        )
        
    )
    (defcap VST|C>CULL (culler:string id:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (ref-DALOS::UEV_EnforceAccountType culler false)
            (ref-DPMF::UEV_Vesting id true)
            (UEV_Active (ref-DPMF::UR_Vesting id) id)
            (compose-capability (VST|GOV))
            (compose-capability (P|VST|CALLER))
        )
    )
    (defcap VST|C>UPDATE (dptf:string dpmf:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (tf-vesting-id:string (ref-DPTF::UR_Vesting dptf))
                (mf-vesting-id:string (ref-DPMF::UR_Vesting dpmf))
                (iz-hot-rbt:bool (ref-DPMF::URC_IzRBT dpmf))
            )
            (ref-DPTF::UEV_id dptf)
            (ref-DPMF::UEV_id dpmf)
            (ref-DPTF::CAP_Owner dptf)
            (ref-DPMF::CAP_Owner dpmf)
            (UEV_Active dptf dpmf)
            (enforce 
                (and (= tf-vesting-id BAR) (= mf-vesting-id BAR) )
                "Vesting Pairs are immutable !"
            )
            (enforce (= iz-hot-rbt false) "A DPMF defined as a hot-rbt cannot be used as Vesting Token in Vesting pair")
            (compose-capability (P|VST|UPDATE))
        )
    )
    ;;
    ;;{F0}
    ;;{F1}
    (defun URC_CullMetaDataAmount:decimal (client:string id:string nonce:integer)
        (let
            (
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (meta-data:[object{Vesting.VST|MetaDataSchema}] (ref-DPMF::UR_AccountBatchMetaData id nonce client))
                (culled-amount:decimal
                    (fold
                        (lambda
                            (acc:decimal item:object{Vesting.VST|MetaDataSchema})
                            (let
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
    (defun URC_CullMetaDataObject:[object{Vesting.VST|MetaDataSchema}] (client:string id:string nonce:integer)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (meta-data:[object{Vesting.VST|MetaDataSchema}] (ref-DPMF::UR_AccountBatchMetaData id nonce client))
            )
            (fold
                (lambda
                    (acc:[object{Vesting.VST|MetaDataSchema}] item:object{Vesting.VST|MetaDataSchema})
                    (let
                        (
                            (date:time (at "release-date" item))
                            (present-time:time (at "block-time" (chain-data)))
                            (t:decimal (diff-time present-time date))
                        )
                        (if (< t 0.0)
                            (ref-U|LST::UC_AppL acc item)
                            acc
                        )
                    )
                )
                []
                meta-data
            )
        )
    )
    ;;{F2}
    (defun UEV_Active (dptf:string dpmf:string)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (dptf-fee-exemption:bool (ref-DPTF::UR_AccountRoleFeeExemption dptf VST|SC_NAME))
                (create-role:bool (ref-DPMF::UR_AccountRoleCreate dpmf VST|SC_NAME))
                (add-q-role:bool (ref-DPMF::UR_AccountRoleNFTAQ dpmf VST|SC_NAME))
                (burn-role:bool (ref-DPMF::UR_AccountRoleBurn dpmf VST|SC_NAME))
                (transfer-role:bool (ref-DPMF::UR_AccountRoleTransfer dpmf VST|SC_NAME))
            )
            (enforce (= dptf-fee-exemption true) "<role-fee-exemption> needed on DalosVesting")
            (enforce (= create-role true) "<role-nft-create> needed on DalosVesting")
            (enforce (= add-q-role true) "<role-nft-add-quantity> needed on DalosVesting")
            (enforce (= burn-role true) "<role-nft-burn> needed on DalosVesting")
            (enforce (= transfer-role true) "<role-transfer> needed on DalosVesting")
        )
    )
    ;;{F3}
    (defun UDC_ComposeVestingMetaData:[object{Vesting.VST|MetaDataSchema}] (id:string amount:decimal offset:integer duration:integer milestones:integer)
        (let
            (
                (ref-U|VST:module{UtilityVst} U|VST)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (amount-lst:[decimal] (ref-U|VST::UC_SplitBalanceForVesting (ref-DPTF::UR_Decimals id) amount milestones))
                (date-lst:[time] (ref-U|VST::UC_MakeVestingDateList offset duration milestones))
                (meta-data:[object{Vesting.VST|MetaDataSchema}] (zip (lambda (x:decimal y:time) { "release-amount": x, "release-date": y }) amount-lst date-lst))
            )
            (ref-DPTF::UEV_Amount id amount)
            (ref-U|VST::UEV_MilestoneWithTime offset duration milestones)
            meta-data
        )
    )
    ;;{F4}
    ;;
    ;;{F5}
    ;;{F6}
    (defun C_CreateVestingLink:string (patron:string dptf:string)
        @doc "Creates a Vested Link; \
        \ A Vested Link, means, issuing a DPMF as a vested counterpart for a DPTF \
        \ The Vested Link is immutable, meaning, this DPMF will always act as a vested counterpart for the DPTF Token, \
        \ and will be recorded as such in both the DPTF and DPMF Token Properties."
        (enforce-guard (P|UR "TALOS|Summoner"))
        (with-capability (VST|C>LINK)
            (let
                (
                    (ref-U|VST:module{UtilityVst} U|VST)
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (ref-ATS:module{Autostake} ATS)
                    (vst-sc:string VST|SC_NAME)
                    (dptf-owner:string (ref-DPTF::UR_Konto dptf))
                    (dptf-name:string (ref-DPTF::UR_Name dptf))
                    (dptf-ticker:string (ref-DPTF::UR_Ticker dptf))
                    (dptf-decimals:integer (ref-DPTF::UR_Decimals dptf))
                    (vesting-id:[string] (ref-U|VST::UC_VestingID dptf-name dptf-ticker))
                    (dpmf-name:string (at 0 vesting-id))
                    (dpmf-ticker:string (at 1 vesting-id))
                    (dpmf-l:[string]
                        (ref-DPMF::X_IssueFree
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
                    (kda-costs:decimal (ref-DALOS::UR_UsagePrice "dpmf"))
                )
                ;;Create DPTF Account and Set Roles
                (ref-DPTF::C_DeployAccount dptf vst-sc)
                (ref-ATS::DPTF|C_ToggleFeeExemptionRole patron dptf vst-sc true)
                ;;Create DPMF Account and Set Roles
                (ref-DPMF::C_DeployAccount dpmf vst-sc)
                (ref-DPMF::C_C_ToggleTransferRole patron dpmf vst-sc true)
                (ref-ATS::DPMF|C_ToggleBurnRole patron dpmf vst-sc true)
                (ref-ATS::DPMF|C_MoveCreateRole patron dpmf vst-sc)
                (ref-ATS::DPMF|C_ToggleAddQuantityRole patron dpmf vst-sc true)
                ;;Define Vesting Pair and Collect KDA (for DPMF Issue)
                (X_DefineVestingPair patron dptf dpmf)
                (ref-DALOS::KDA|C_Collect patron kda-costs)
                dpmf
            )
        )
    )
    (defun C_Vest (patron:string vester:string target-account:string id:string amount:decimal offset:integer duration:integer milestones:integer)
        @doc "Vests a DPTF Token, issuing a Vested Token"
        (with-capability (VST|C>VEST vester target-account id)
            (let
                (
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (vst-sc:string VST|SC_NAME)

                    (dpmf-id:string (ref-DPTF::UR_Vesting id))
                    (meta-data:string (UDC_ComposeVestingMetaData id amount offset duration milestones))
                    (nonce:integer (+ (ref-DPMF::UR_NoncesUsed id) 1))
                )
                (ref-DPMF::C_Mint patron dpmf-id vst-sc amount meta-data)
                (ref-TFT::C_Transfer patron id vester vst-sc amount true)
                (ref-DPMF::C_Transfer patron dpmf-id nonce vst-sc target-account amount true)
            )
        )
    )
    (defun C_Cull (patron:string culler:string id:string nonce:integer)
        @doc "Culls the Vested Token, recovering its original non vested DPTF counterpart."
        (with-capability (VST|C>CULL culler id)
            (let
                (
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (vst-sc:string VST|SC_NAME)

                    (dptf-id:string (ref-DPMF::UR_Vesting id))
                    (initial-amount:decimal (ref-DPMF::UR_AccountBatchSupply id nonce culler))
                    (culled-amount:decimal (URC_CullMetaDataAmount culler id nonce))
                    (return-amount:decimal (- initial-amount culled-amount))
                )
                (if (= return-amount 0.0)
                    (ref-TFT::C_Transfer patron dptf-id vst-sc culler initial-amount true)
                    (let
                        (
                            (remaining-vesting-meta-data:[object{Vesting.VST|MetaDataSchema}] (URC_CullMetaDataObject culler id nonce))
                            (new-nonce:integer (+ (ref-DPMF::UR_NoncesUsed id) 1))
                        )
                        (ref-DPMF::C_Mint patron id vst-sc return-amount remaining-vesting-meta-data)
                        (ref-TFT::C_Transfer patron dptf-id vst-sc culler culled-amount true)
                        (ref-DPMF::C_Transfer patron id new-nonce vst-sc culler return-amount true)
                    )
                )
                (ref-DPMF::C_Transfer patron id nonce culler vst-sc initial-amount true)
                (ref-DPMF::C_Burn patron id nonce vst-sc initial-amount)
            )
        )
    )
    ;;{F7}
    (defun X_DefineVestingPair (patron:string dptf:string dpmf:string)
        (require-capability (VST|DEFINE))
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
            )
            (with-capability (VST|C>UPDATE dptf dpmf)
                (ref-DPMF::X_UpdateVesting dptf dpmf)
                (ref-DALOS::IGNIS|C_Collect patron (ref-DPTF::UR_Konto dptf) (ref-DALOS::UR_UsagePrice "ignis|biggest"))
            )
        )
    )
)

(create-table P|T)