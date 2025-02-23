;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(interface Vesting
    @doc "Exposes Vesting Functions"
    ;;
    (defschema VST|MetaDataSchema
        release-amount:decimal
        release-date:time
    )
    ;;
    (defun GOV|VST|SC_KDA-NAME ())
    ;;
    (defun URC_CullMetaDataAmount:decimal (client:string id:string nonce:integer))
    (defun URC_CullMetaDataObject:[object{VST|MetaDataSchema}] (client:string id:string nonce:integer))

    (defun UEV_Active (dptf:string dpmf:string))

    (defun UDC_ComposeVestingMetaData:[object{VST|MetaDataSchema}] (id:string amount:decimal offset:integer duration:integer milestones:integer))

    (defun C_CreateVestingLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string))
    (defun C_Cull:object{OuronetDalos.IgnisCumulator} (patron:string culler:string id:string nonce:integer))
    (defun C_Vest:object{OuronetDalos.IgnisCumulator} (patron:string vester:string target-account:string id:string amount:decimal offset:integer duration:integer milestones:integer))
)
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
    (defcap P|DT ()
        (compose-capability (VST|GOV))
        (compose-capability (P|VST|CALLER))
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|VST|CALLER))
        (compose-capability (SECURE))
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
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|DPMF:module{OuronetPolicy} DPMF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (ref-P|ATSU:module{OuronetPolicy} ATSU)
            )
            (ref-P|DALOS::P|A_Add 
                "VST|<"
                (create-capability-guard (P|VST|CALLER))
            )
            (ref-P|BRD::P|A_Add 
                "VST|<"
                (create-capability-guard (P|VST|CALLER))
            )
            (ref-P|DPTF::P|A_Add 
                "VST|<"
                (create-capability-guard (P|VST|CALLER))
            )
            (ref-P|DPMF::P|A_Add 
                "VST|<"
                (create-capability-guard (P|VST|CALLER))
            )
            (ref-P|ATS::P|A_Add 
                "VST|<"
                (create-capability-guard (P|VST|CALLER))
            )
            (ref-P|TFT::P|A_Add 
                "VST|<"
                (create-capability-guard (P|VST|CALLER))
            )
            (ref-P|ATSU::P|A_Add 
                "VST|<"
                (create-capability-guard (P|VST|CALLER))
            )
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defun CT_EmptyIgnisCumulator ()(let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::DALOS|EmptyIgCum)))
    (defconst BAR                   (CT_Bar))
    (defconst EIC                   (CT_EmptyIgnisCumulator))
    ;;
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap VST|C>FROZEN-LINK ()
        @event
        (compose-capability (P|SECURE-CALLER))
    )
    (defcap VST|C>RESERVATION-LINK ()
        @event
        (compose-capability (P|SECURE-CALLER))
    )
    (defcap VST|C>VESTING-LINK ()
        @event
        (compose-capability (P|SECURE-CALLER))
    )
    (defcap VST|C>SLEEPING-LINK ()
        @event
        (compose-capability (P|SECURE-CALLER))
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
            (compose-capability (P|DT))
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
            (compose-capability (P|DT))
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
            (compose-capability (SECURE))
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
    (defun C_CreateFrozenLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (VST|C>FROZEN-LINK)
            (XI_CreateSpecialTrueFungibleLink patron dptf true)
        )
    )
    (defun C_CreateReservationLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (VST|C>RESERVATION-LINK)
            (XI_CreateSpecialTrueFungibleLink patron dptf false)
        )
    )
    (defun C_CreateVestingLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (VST|C>VESTING-LINK)
            (XI_CreateSpecialMetaFungibleLink patron dptf true)
        )
    )
    (defun C_CreateSleepingLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (VST|C>SLEEPING-LINK)
            (XI_CreateSpecialMetaFungibleLink patron dptf false)
        )
    )
    ;;Frozen Token Actions
    ;;Reserve Token Actions
    ;;Vesting Token Actions
    (defun C_Cull:object{OuronetDalos.IgnisCumulator} (patron:string culler:string id:string nonce:integer)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (VST|C>CULL culler id)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (vst-sc:string VST|SC_NAME)
                    (dptf-id:string (ref-DPMF::UR_Vesting id))
                    (initial-amount:decimal (ref-DPMF::UR_AccountBatchSupply id nonce culler))
                    (culled-amount:decimal (URC_CullMetaDataAmount culler id nonce))
                    (return-amount:decimal (- initial-amount culled-amount))
                    (ico1:[object{OuronetDalos.IgnisCumulator}]
                        (if (= return-amount 0.0)
                            [
                                (ref-TFT::XB_FeelesTransfer patron dptf-id vst-sc culler initial-amount true)
                            ]
                            [
                                (ref-DPMF::C_Mint patron id vst-sc return-amount (URC_CullMetaDataObject culler id nonce))
                                (ref-TFT::XB_FeelesTransfer patron dptf-id vst-sc culler culled-amount true)
                                (ref-DPMF::C_Transfer patron id (+ (ref-DPMF::UR_NoncesUsed id) 1) vst-sc culler return-amount true)
                            ]
                        )
                    )
                    (ico2:object{OuronetDalos.IgnisCumulator}
                        (ref-DPMF::C_Transfer patron id nonce culler vst-sc initial-amount true)
                    )
                    (ico3:object{OuronetDalos.IgnisCumulator}
                        (ref-DPMF::C_Burn patron id nonce vst-sc initial-amount)
                    )
                )
                (ref-DALOS::UDC_CompressICO (fold (+) [] [ico1 [ico2] [ico3]]) [])
            )
        )
    )
    (defun C_Vest:object{OuronetDalos.IgnisCumulator} (patron:string vester:string target-account:string id:string amount:decimal offset:integer duration:integer milestones:integer)
        @doc "Vests a DPTF Token, issuing a Vested Token"
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (VST|C>VEST vester target-account id)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (vst-sc:string VST|SC_NAME)
                    (dpmf-id:string (ref-DPTF::UR_Vesting id))
                    (meta-data:string (UDC_ComposeVestingMetaData id amount offset duration milestones))
                    (nonce:integer (+ (ref-DPMF::UR_NoncesUsed id) 1))
                    (ico1:object{OuronetDalos.IgnisCumulator}
                        (ref-DPMF::C_Mint patron dpmf-id vst-sc amount meta-data)
                    )
                    (ico2:object{OuronetDalos.IgnisCumulator}
                        (ref-TFT::XB_FeelesTransfer patron id vester vst-sc amount true)
                    )
                    (ico3:object{OuronetDalos.IgnisCumulator}
                        (ref-DPMF::C_Transfer patron dpmf-id nonce vst-sc target-account amount true)
                    )
                )
                (ref-DALOS::UDC_CompressICO (fold (+) [] [[ico1] [ico2] [ico3]]) [])
            )
        )
    )
    ;;Sleeping Token Actions
    ;;{F7}
    (defun XI_CreateSpecialTrueFungibleLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string frozen-or-reserved:bool)
        (require-capability (SECURE))
        (let
            (
                (ref-U|VST:module{UtilityVst} U|VST)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)

                (vst-sc:string VST|SC_NAME)
                (dptf-owner:string (ref-DPTF::UR_Konto dptf))
                (dptf-name:string (ref-DPTF::UR_Name dptf))
                (dptf-ticker:string (ref-DPTF::UR_Ticker dptf))
                (dptf-decimals:integer (ref-DPTF::UR_Decimals dptf))
                (special-tf-id:[string]
                    (if frozen-or-reserved
                        (ref-U|VST::UC_FrozenID dptf-name dptf-ticker)
                        (ref-U|VST::UC_ReservedID dptf-name dptf-ticker)
                    )
                )
                (special-tf-name:string (at 0 special-tf-id))
                (special-tf-ticker:string (at 1 special-tf-id))
                (ico0:object{OuronetDalos.IgnisCumulator}
                    (ref-DPTF::XB_IssueFree
                        patron
                        dptf-owner
                        [special-tf-name]
                        [special-tf-ticker]
                        [dptf-decimals]
                        [false] ;;<can-change-owner>
                        [false] ;;<can-upgrade>
                        [true]  ;;<can-add-special-role>
                        [false] ;;<can-freeze>
                        [false] ;;<can-wipe>
                        [false] ;;<can-pause>
                        [true]  ;;<iz-special>
                    )
                )
                (special-dptf:string (at 0 (at "output" ico0)))
                (kda-costs:decimal (ref-DALOS::UR_UsagePrice "dptf"))
            )
            ;;Create DPTF and Special-DPTF Account and Set Required Roles below.
            ;;For the Special DPTFs to function as intended, these roles must be kept on the VST|SC_NAME
            (ref-DPTF::C_DeployAccount dptf vst-sc)
            (ref-DPTF::C_DeployAccount special-dptf vst-sc)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                    (dptf-fer:bool (ref-DPTF::UR_AccountRoleFeeExemption dptf vst-sc))
                    ;;DPTF Roles
                    (ico1:[object{OuronetDalos.IgnisCumulator}]
                        (if (not dptf-fer)
                            (ref-ATS::DPTF|C_ToggleFeeExemptionRole patron dptf vst-sc true)
                            [EIC]
                        )
                    )
                    ;;Special-DPTF Roles
                    (ico2:object{OuronetDalos.IgnisCumulator}
                        (ref-DPTF::C_ToggleTransferRole patron special-dptf vst-sc true)
                        ;;Further Transfer Roles can be set to external Smart Ouronet Accounts as needed to implement Special DPTF Functionality
                        ;;Lifting the Transfer Role for the special DPTF from VST|SC_NAME, disables its functionality as Frozen or Reserved Special DPTF
                    )
                    (ico3:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPTF|C_ToggleFeeExemptionRole patron special-dptf vst-sc true)
                        ;;Further Transfer Roles can be set to external Smart Ouronet Accounts as needed to implement Special DPTF Functionality
                    )
                    (ico4:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPTF|C_ToggleBurnRole patron special-dptf vst-sc true)
                        ;;Even if the Burn Role can be given to external Smart Ouronet Accounts, 
                        ;;it is highly recomended to keep the Burn Role only on the VST|SC_NAME, such that only this Account is allowed to burn the Special-DPTF
                        ;;as was intended by its design, that is, only the the VST|SC_NAME to be allowed to mint burn the Special Token.
                        ;;Giving other Smart Dalos Accounts the Burn Role for a Special Token, will raise a Red Flag for the Parent DPTF Token
                    )
                    (ico5:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPTF|C_ToggleMintRole patron special-dptf vst-sc true)
                        ;;Same as Burn Role, see above.
                    )
                    (ico6:object{OuronetDalos.IgnisCumulator}
                        (ref-DPTF::XE_UpdateSpecialTrueFungible dptf special-dptf frozen-or-reserved)
                    )
                )
                (ref-DALOS::KDA|C_Collect patron kda-costs)
                (ref-DALOS::UDC_CompressICO (fold (+) [] [[ico0] ico1 [ico2] ico3 ico4 ico5 [ico6]]) [special-dptf])
            )
        )
    )
    (defun XI_CreateSpecialMetaFungibleLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string vesting-or-sleeping:bool)
        (require-capability (SECURE))
        (let
            (
                (ref-U|VST:module{UtilityVst} U|VST)
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)

                (vst-sc:string VST|SC_NAME)
                (dptf-owner:string (ref-DPTF::UR_Konto dptf))
                (dptf-name:string (ref-DPTF::UR_Name dptf))
                (dptf-ticker:string (ref-DPTF::UR_Ticker dptf))
                (dptf-decimals:integer (ref-DPTF::UR_Decimals dptf))
                (special-mf-id:[string]
                    (if vesting-or-sleeping
                        (ref-U|VST::UC_VestingID dptf-name dptf-ticker)
                        (ref-U|VST::UC_SleepingID dptf-name dptf-ticker)
                    )
                )
                (special-mf-name:string (at 0 special-mf-id))
                (special-mf-ticker:string (at 1 special-mf-id))
                (ico0:object{OuronetDalos.IgnisCumulator}
                    (ref-DPMF::XB_IssueFree
                        patron
                        dptf-owner
                        [special-mf-name]
                        [special-mf-ticker]
                        [dptf-decimals]
                        [false] ;;<can-change-owner>
                        [true]  ;;<can-upgrade>; after <create-role-account> is set to VST|SC_NAME, this will be set to false, 
                        [true]  ;;<can-add-special-role>
                        [false] ;;<can-freeze>
                        [false] ;;<can-wipe>
                        [false] ;;<can-pause>
                        [true]  ;;<can-transfer-nft-create-role>; must be moved to VST|SC_NAME, then set to false
                        [true]  ;;<iz-special>
                    )
                )
                (special-dpmf:string (at 0 (at "output" ico0)))
                (kda-costs:decimal (ref-DALOS::UR_UsagePrice "dpmf"))
            )
            ;;Create DPTF and Special-DPMF Account and Set Required Roles below.
            ;;For the Special DPTFs to function as intended, these roles must be kept on the VST|SC_NAME
            (ref-DPTF::C_DeployAccount dptf vst-sc)
            (ref-DPMF::C_DeployAccount special-dpmf vst-sc)
            (let
                (
                    (ref-ATS:module{Autostake} ATS)
                    (trigger:bool (ref-DALOS::IGNIS|URC_IsVirtualGasZero))
                    (dptf-fer:bool (ref-DPTF::UR_AccountRoleFeeExemption dptf vst-sc))
                    ;;DPTF Roles
                    (ico1:[object{OuronetDalos.IgnisCumulator}]
                        (if (not dptf-fer)
                            (ref-ATS::DPTF|C_ToggleFeeExemptionRole patron dptf vst-sc true)
                            [EIC]
                        )
                    )
                    ;;Special-DPMF Roles
                    (ico2:object{OuronetDalos.IgnisCumulator}
                        (ref-DPMF::C_ToggleTransferRole patron special-dpmf vst-sc true)
                        ;;Further Transfer Roles can be set to external Smart Ouronet Accounts as needed to implement Special DPTF Functionality
                        ;;Lifting the Transfer Role for the special DPMF from VST|SC_NAME, disables its functionality as Vested or Sleeping Special DPMF
                    )
                    (ico3:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPMF|C_ToggleBurnRole patron special-dpmf vst-sc true)
                        ;;Same as Burn Role for Special DPTFs, see above
                    )
                    (ico4:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPMF|C_MoveCreateRole patron special-dpmf vst-sc)
                        ;;After setting <role-nft-create> to VST|SC_NAME, the <can-transfer-nft-create-role> will be set to false,
                        ;;and <can-upgrade> will also be set to false, to lock settings in place via <ico7>
                    )
                    (ico5:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPMF|C_ToggleAddQuantityRole patron special-dpmf vst-sc true)
                        ;;Same as Mint Role for Special DPTFs, see above
                    )
                    (ico6:object{OuronetDalos.IgnisCumulator}
                        (ref-DPMF::C_Control patron special-dpmf false false true false false false false)
                        ;;Control changes locked in place, and <role-nft-create> permanently locked to VST|SC_NAME
                    )
                    (ico7:object{OuronetDalos.IgnisCumulator}
                        (ref-DPMF::XE_UpdateSpecialMetaFungible dptf special-dpmf vesting-or-sleeping)
                    )
                )
                (ref-DALOS::KDA|C_Collect patron kda-costs)
                (ref-DALOS::UDC_CompressICO (fold (+) [] [[ico0] ico1 [ico2] ico3 ico4 ico5 [ico6] [ico7]]) [special-dpmf])
            )
        )
    )
)

(create-table P|T)