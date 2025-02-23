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
    ;;
    (defun UEV_SpecialTrueFungibleRoles (dptf:string frozen-or-reserved:bool))
    (defun UEV_SpecialMetaFungibleRoles (dptf:string vesting-or-sleeping:bool))
    ;;
    (defun UDC_ComposeVestingMetaData:[object{VST|MetaDataSchema}] (id:string amount:decimal offset:integer duration:integer milestones:integer))
    ;;
    (defun C_CreateFrozenLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string))
    (defun C_CreateReservationLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string))
    (defun C_CreateVestingLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string))
    (defun C_CreateSleepingLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string))
    ;;
    (defun C_Reserve:[object{OuronetDalos.IgnisCumulator}] (patron:string reserver:string dptf:string amount:decimal))
    (defun C_Unreserve:[object{OuronetDalos.IgnisCumulator}] (patron:string unreserver:string r-dptf:string amount:decimal))
    ;;
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
    ;;
    (defcap VST|C>RESERVATION-LINK ()
        @event
        (compose-capability (P|SECURE-CALLER))
    )
    (defcap VST|C>RESERVE (reserver:string dptf:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (iz-reservation:bool (ref-DPTF::UR_IzReservationOpen dptf))
            )
            (ref-DALOS::UEV_EnforceAccountType reserver false)
            (ref-DPTF::UEV_Amount dptf amount)
            (ref-DPTF::UEV_Reserved dptf true)
            (UEV_SpecialTrueFungibleRoles dptf false)
            (enforce iz-reservation (format "Reservation is not opened for Token {}" [dptf]))
            (compose-capability (P|DT))
        )
    )
    (defcap VST|C>UNRESERVE (unreserver:string r-dptf:string amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
            )
            (ref-DALOS::UEV_EnforceAccountType unreserver true)
            (ref-DPTF::UEV_Amount r-dptf amount)
            (ref-DPTF::CAP_Owner r-dptf)
            (ref-DPTF::UEV_Reserved r-dptf true)
            (UEV_SpecialTrueFungibleRoles (ref-DPTF::UR_Reservation r-dptf) false)
            (compose-capability (P|DT))
        )
    )
    ;;
    (defcap VST|C>VESTING-LINK ()
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
            (UEV_SpecialMetaFungibleRoles id true)
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
            (UEV_SpecialMetaFungibleRoles (ref-DPMF::UR_Vesting id) true)
            (compose-capability (P|DT))
        )
    )
    ;;
    (defcap VST|C>SLEEPING-LINK ()
        @event
        (compose-capability (P|SECURE-CALLER))
    )
    ;;
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
    (defun UEV_SpecialTrueFungibleRoles (dptf:string frozen-or-reserved:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (special:string (if frozen-or-reserved "Frozen" "Reserved"))
                (s-dptf:string 
                    (if frozen-or-reserved
                        (ref-DPTF::UR_Frozen dptf)
                        (ref-DPTF::UR_Reservation dptf)
                    )
                )
                (vst-sc:string VST|SC_NAME)
                (t1:bool (ref-DPTF::UR_AccountRoleFeeExemption dptf vst-sc))
                (r-burn:bool (ref-DPTF::UR_AccountRoleBurn s-dptf vst-sc))
                (r-mint:bool (ref-DPTF::UR_AccountRoleMint s-dptf vst-sc))
                (r-trns:bool (ref-DPTF::UR_AccountRoleTransfer s-dptf vst-sc))
                (r-fexm:bool (ref-DPTF::UR_AccountRoleFeeExemption s-dptf vst-sc))
                (t2:bool (and (and r-burn r-mint) (and r-trns r-fexm)))
                (truth:bool (and t1 t2))
            )
            (enforce truth (format "Needed Roles for {} Functionality for the {} Id arent properly set; Special Functionality offline" [special dptf]))
        )
    )
    (defun UEV_SpecialMetaFungibleRoles (dptf:string vesting-or-sleeping:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungible} DPMF)
                (special:string (if vesting-or-sleeping "Vesting" "Sleeping"))
                (s-dpmf:string 
                    (if vesting-or-sleeping
                        (ref-DPTF::UR_Vesting dptf)
                        (ref-DPTF::UR_Sleeping dptf)
                    )
                )
                (vst-sc:string VST|SC_NAME)
                (t1:bool (ref-DPTF::UR_AccountRoleFeeExemption dptf vst-sc))
                (r-burn:bool (ref-DPMF::UR_AccountRoleBurn s-dpmf vst-sc))
                (r-crea:bool (ref-DPMF::UR_AccountRoleCreate s-dpmf vst-sc))
                (r-nadq:bool (ref-DPMF::UR_AccountRoleNFTAQ s-dpmf vst-sc))
                (r-trns:bool (ref-DPMF::UR_AccountRoleTransfer s-dpmf vst-sc))
                (t2:bool (and (and r-burn r-crea) (and r-nadq r-trns)))
                (truth:bool (and t1 t2))
            )
            (enforce truth (format "Needed Roles for {} Functionality for the {} Id arent properly set; Special Functionality offline" [special dptf]))
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
        @doc "Creates a Frozen Link, issuing a Special-DPTF as a frozen counterpart for another DPTF \
            \ A Frozen Link is immutable, and noted in the Token Properties of both DPTFs \
            \ A Special DPTF of the Frozen variety, is used for implementing the FROZEN Functionality for a DPTF Token \
            \ So called FROZEN Tokens are meant to be frozen on the account holding them, and only be used by that account, \
            \ for specific purposes only, defined by the <dptf> owner, which is also the owner of the Frozen Token. \
            \ Frozen Tokens can never be converted back to the original <dptf> Token they were created from \
            \ \
            \ Only the <dptf> owner can create Frozen Tokens to Target Accounts, \
            \ or designate other Smart Ouronet Accounts to create them \
            \ \
            \ Frozen Tokens can be used to add Swpair Liquidity, as if they were the initial <dptf> token \
            \ This can be done, when this functionality is turned on for the Swpair, and using a Frozen Token for adding Liquidity \
            \ generates a Frozen LP Token, which behaves similarly to the Frozen Token \
            \ that is, it can never be converted back to the SWPairs native LP, locking liquidity in place \
            \ Existing LPs can also be frozen, permanently locking liquidity \
            \ \
            \ VESTA will be the first Token that will be making use of this functionality"
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (VST|C>FROZEN-LINK)
            (XI_CreateSpecialTrueFungibleLink patron dptf true)
        )
    )
    (defun C_CreateReservationLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string)
        @doc "Creates a Reservation Link, issuing a Special-DPTF as a reserved counterpart for another DPTF \
            \ A Reservation Link is immutable, and noted in the Token Properties of both DPTFs \
            \ A Special DPTF of the Reserved variety, is used for implementing the RESERVED Functionality for a DPTF Token \
            \ So called RESERVED Tokens are meant to be frozen on the account holding them, and only be used by that account, \
            \ for specific purposes only, defined by the <dptf> owner, which is also the owner of the Reserved Token. \
            \ Reserved Tokens can never be converted back to the original <dptf> Token they were created from \
            \ \
            \ As opposed to frozen tokens, where only the <dptf> owner can generate them or designated Ouronet Accounts, \
            \ Reserved Tokens can be generated by clients, using as input the <dptf> Token, only when reservations are open by the <dptf> owner \
            \ That is, the <dptf> owner dictates when clients can generate reserved tokens from the input <dptf>, \
            \ and as such, reserved tokens can be used for special discounts when sales are planned with the main <dptf> Token, \
            \ as if they were the main <dptf> token. \
            \ \
            \ Reserved Tokens cannot be used to add liquidty on any Swpair. \
            \ \
            \ OURO will be the first Token that will be making use of this functionality"
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (VST|C>RESERVATION-LINK)
            (XI_CreateSpecialTrueFungibleLink patron dptf false)
        )
    )
    (defun C_CreateVestingLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string)
        @doc "Creates a Vesting Link, issuing a Special-DPMF as a vested counterpart for another DPTF \
            \ A Vesting Link is immutable, and noted in the Token Properties of both the DPTF and the Special DPMF \
            \ A Special DPMF of the Vested variety, is used for implementing the Vesting Functionality for a DPTF Token \
            \ The <dptf> owner has the ability to vest its <dptf> token into a vested counterpart \
            \ specifying a target account, an offset, a duration and a number of milestones as vesting parameters \
            \ \
            \ The Target account receives the vested token, and according to its input vested parameters, \
            \ can revert it back to the <dptf> counterpart, as vesting intervals expire \
            \ \
            \ Vested Tokens cannot be used to add liquidity on any Swpair \
            \ \
            \ If a Vested Counterpart is created for a Token that is a Cold-RBT in an ATS Pair, \
            \ the RT owner of that ATS Pair can <coil>|<curl> the RT Token, and subsequently <vest> the output Hot-RBT token, \
            \ thus creating an additional layer of locking, for the input <RT> token, by converting it in a Vested Hot-RBT \
            \ OURO, AURYN and ELITE-AURYN will be the first Tokens that will make use of this functionality"
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (VST|C>VESTING-LINK)
            (XI_CreateSpecialMetaFungibleLink patron dptf true)
        )
    )
    (defun C_CreateSleepingLink:object{OuronetDalos.IgnisCumulator} (patron:string dptf:string)
        @doc "Creates a Sleeping Link, issuing a Special-DPMF as a sleeping counterpart for another DPTF \
            \ A Sleeping Link is immutable, and noted in the Token Properties of both the DPTF and the Special DPMF \
            \ A Special DPMF of the Sleeping variety, is used for implementing the Sleeping Functionality for a DPTF Token \
            \ A Sleeping DPMF is similar to a vested Token, however it has a single period after which it can be converted \
            \ in its entirety, at once, into the initial <dptf> \
            \ As opposed to Vested DPMF Tokens, multiple Sleeping DPMF Tokens, can be unified into a single Sleeping Token \
            \ using a weigthed mean to determine the final time when it can be converted back to the initial <dptf> \
            \ \
            \ As oposed to Vested Tokens, Sleeping Tokens can be used to add Swpair Liquidity, as if they were the initial <dptf> token \
            \ This can be done, when this functionality is turned on for the Swpair, and using a Sleeping Token for adding Liquidity \
            \ generates a Sleeping LP Token, which behaves similarly to the Sleeping Token, inheriting its sleeping date, \
            \ that is, it can be converted back to the SWPairs native LP, when its sleeping interval expires \
            \ Existing LPs can also be put to sleep, locking liquidity for a given period \
            \ \
            \ VESTA will be the first Token that will be making use of this functionality"
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (VST|C>SLEEPING-LINK)
            (XI_CreateSpecialMetaFungibleLink patron dptf false)
        )
    )
    ;;Frozen Token Actions
    ;;Reserve Token Actions
    (defun C_Reserve:[object{OuronetDalos.IgnisCumulator}] (patron:string reserver:string dptf:string amount:decimal)
        ;(enforce-guard (P|UR "TALOS-01"))
        (with-capability (VST|C>RESERVE reserver dptf amount)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (vst-sc:string VST|SC_NAME)
                    (r-dptf:string (ref-DPTF::UR_Reservation dptf))
                    
                )
                [
                    ;;1]Reserver sends dptf to VST|SC_NAME
                    (ref-TFT::XB_FeelesTransfer patron dptf reserver vst-sc amount true) 
                    ;;2]VST|SC_NAME mint R|dptf
                    (ref-DPTF::C_Mint patron r-dptf vst-sc amount false)
                    ;;3]VST|SC_NAME sends R|dptf to reserver
                    (ref-TFT::XB_FeelesTransfer patron r-dptf vst-sc reserver amount true)
                ]
            )
        )
    )
    (defun C_Unreserve:[object{OuronetDalos.IgnisCumulator}] (patron:string unreserver:string r-dptf:string amount:decimal)
        (enforce-guard (P|UR "TALOS-01"))
        (with-capability (VST|C>UNRESERVE unreserver r-dptf amount)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungible} DPTF)
                    (ref-TFT:module{TrueFungibleTransfer} TFT)
                    (vst-sc:string VST|SC_NAME)
                    (dptf:string (ref-DPTF::UR_Reservation r-dptf))
                )
                [
                    ;;1]Unreserver sends R|dptf to VST|SC_NAME
                    (ref-TFT::XB_FeelesTransfer patron r-dptf unreserver vst-sc amount true)
                    ;;2]VST|SC_NAME burns R|dptf
                    (ref-DPTF::C_Burn patron r-dptf vst-sc amount)
                    ;;3]VST|SC_NAME sends dptf back to unreserver
                    (ref-TFT::XB_FeelesTransfer patron dptf vst-sc unreserver amount true)
                ]
            )
        )
    )
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
                        [true]  ;;<can-freeze>
                        [true]  ;;<can-wipe>
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
                    (ico2:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPTF|C_ToggleBurnRole patron special-dptf vst-sc true)
                        ;;Even if the Burn Role can be given to external Smart Ouronet Accounts, 
                        ;;it is highly recomended to keep the Burn Role only on the VST|SC_NAME, such that only this Account is allowed to burn the Special-DPTF
                        ;;as was intended by its design, that is, only the the VST|SC_NAME to be allowed to mint burn the Special Token.
                        ;;Giving other Smart Dalos Accounts the Burn Role for a Special Token, will raise a Red Flag for the Parent DPTF Token
                    )
                    (ico3:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPTF|C_ToggleMintRole patron special-dptf vst-sc true)
                        ;;Same as Burn Role, see above.
                    )
                    (ico4:object{OuronetDalos.IgnisCumulator}
                        (ref-DPTF::C_ToggleTransferRole patron special-dptf vst-sc true)
                        ;;Further Transfer Roles can be set to external Smart Ouronet Accounts as needed to implement Special DPTF Functionality
                        ;;Lifting the Transfer Role for the special DPTF from VST|SC_NAME, disables its functionality as Frozen or Reserved Special DPTF
                    )
                    (ico5:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPTF|C_ToggleFeeExemptionRole patron special-dptf vst-sc true)
                        ;;Further Fee Exemption Roles can be set to external Smart Ouronet Accounts as needed to implement Special DPTF Functionality
                    )
                    (ico6:object{OuronetDalos.IgnisCumulator}
                        (ref-DPTF::XE_UpdateSpecialTrueFungible dptf special-dptf frozen-or-reserved)
                    )
                )
                (ref-DALOS::KDA|C_Collect patron kda-costs)
                (ref-DALOS::UDC_CompressICO (fold (+) [] [[ico0] ico1 ico2 ico3 [ico4] ico5 [ico6]]) [special-dptf])
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
                        [true] ;;<can-freeze>
                        [true] ;;<can-wipe>
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
                    (ico2:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPMF|C_ToggleBurnRole patron special-dpmf vst-sc true)
                        ;;Same as Burn Role for Special DPTFs, see above
                    )
                    (ico3:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPMF|C_MoveCreateRole patron special-dpmf vst-sc)
                        ;;After setting <role-nft-create> to VST|SC_NAME, the <can-transfer-nft-create-role> will be set to false,
                        ;;and <can-upgrade> will also be set to false, to lock settings in place via <ico7>
                    )
                    (ico4:[object{OuronetDalos.IgnisCumulator}]
                        (ref-ATS::DPMF|C_ToggleAddQuantityRole patron special-dpmf vst-sc true)
                        ;;Same as Mint Role for Special DPTFs, see above
                    )
                    (ico5:object{OuronetDalos.IgnisCumulator}
                        (ref-DPMF::C_ToggleTransferRole patron special-dpmf vst-sc true)
                        ;;Further Transfer Roles can be set to external Smart Ouronet Accounts as needed to implement Special DPTF Functionality
                        ;;Lifting the Transfer Role for the special DPMF from VST|SC_NAME, disables its functionality as Vested or Sleeping Special DPMF
                    )
                    (ico6:object{OuronetDalos.IgnisCumulator}
                        (ref-DPMF::C_Control patron special-dpmf false false true true true false false)
                        ;;Control changes locked in place, and <role-nft-create> permanently locked to VST|SC_NAME
                    )
                    (ico7:object{OuronetDalos.IgnisCumulator}
                        (ref-DPMF::XE_UpdateSpecialMetaFungible dptf special-dpmf vesting-or-sleeping)
                    )
                )
                (ref-DALOS::KDA|C_Collect patron kda-costs)
                (ref-DALOS::UDC_CompressICO (fold (+) [] [[ico0] ico1 ico2 ico3 ico4 [ico5] [ico6] [ico7]]) [special-dpmf])
            )
        )
    )
)

(create-table P|T)