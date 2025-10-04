;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module ATSU GOV
    ;;
    (implements OuronetPolicy)
    (implements AutostakeUsageV5)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_ATSU           (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_ATSU           (keyset-ref-guard (GOV|AutostakeKey)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|ATSU_ADMIN)))
    (defcap GOV|ATSU_ADMIN ()
        (enforce-one
            "ATSU Autostake Admin not satisfed"
            [
                (enforce-guard GOV|MD_ATSU)
                (enforce-guard GOV|SC_ATSU)
            ]
        )
    )
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    (defun GOV|AutostakeKey ()      (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|AutostakeKey)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|ATSU|CALLER ()
        true
    )
    (defcap P|ATSU|REMOTE-GOV ()
        true
    )
    (defcap P|TT ()
        (compose-capability (P|ATSU|REMOTE-GOV))
        (compose-capability (P|ATSU|CALLER))
        (compose-capability (SECURE))
    )
    (defcap P|DT1 ()
        (compose-capability (P|ATSU|REMOTE-GOV))
        (compose-capability (SECURE))
    )
    (defcap P|DT2 ()
        (compose-capability (P|ATSU|REMOTE-GOV))
        (compose-capability (P|ATSU|CALLER))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|ATSU_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|ATSU_ADMIN)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (dg:guard (create-capability-guard (SECURE)))
                )
                (with-default-read P|MT P|I
                    {"m-policies" : [dg]}
                    {"m-policies" := mp}
                    (write P|MT P|I
                        {"m-policies" : (ref-U|LST::UC_AppL mp policy-guard)}
                    )
                )
            )
        )
    )
    (defun P|A_Define ()
        (let
            (
                (ref-P|DALOS:module{OuronetPolicy} DALOS)
                (ref-P|BRD:module{OuronetPolicy} BRD)
                (ref-P|DPTF:module{OuronetPolicy} DPTF)
                (ref-P|DPOF:module{OuronetPolicy} DPOF)
                (ref-P|ATS:module{OuronetPolicy} ATS)
                (ref-P|TFT:module{OuronetPolicy} TFT)
                (mg:guard (create-capability-guard (P|ATSU|CALLER)))
            )
            (ref-P|ATS::P|A_Add
                "ATSU|RemoteAtsGov"
                (create-capability-guard (P|ATSU|REMOTE-GOV))
            )

            (ref-P|DALOS::P|A_AddIMP mg)
            (ref-P|BRD::P|A_AddIMP mg)
            (ref-P|DPTF::P|A_AddIMP mg)
            (ref-P|DPOF::P|A_AddIMP mg)
            (ref-P|ATS::P|A_AddIMP mg)
            (ref-P|TFT::P|A_AddIMP mg)
        )
    )
    (defun UEV_IMC ()
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
            )
            (ref-U|G::UEV_Any (P|UR_IMP))
        )
    )
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    ;;{2}
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defun CT_EmptyCumulator ()     (let ((ref-IGNIS:module{IgnisCollectorV2} IGNIS)) (ref-IGNIS::DALOS|EmptyOutputCumulatorV2)))
    (defconst BAR                   (CT_Bar))
    (defconst EOC                   (CT_EmptyCumulator))
    (defconst ATS|SC_NAME           (let ((ref-DALOS:module{OuronetDalosV5} DALOS)) (ref-DALOS::GOV|ATS|SC_NAME)))
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    (defcap SECURE ()
        true
    )
    ;;{C2}
    ;;{C3}
    ;;{C4}
    (defcap ATSU|C>ADMINISTRATIVE-REMOVE-SECONDARY (ats:string reward-token:string)
        @event
        (let
            (
                (ref-ATS:module{AutostakeV5} ATS)
            )
            (compose-capability (GOV|ATSU_ADMIN))
            (compose-capability (ATSU|C>X_REMOVE-SECONDARY ats reward-token))
        )
    )
    (defcap ATSU|C>REMOVE-SECONDARY (ats:string reward-token:string)
        @event
        (let
            (
                (ref-ATS:module{AutostakeV5} ATS)
            )
            (ref-ATS::CAP_Owner ats)
            (compose-capability (ATSU|C>X_REMOVE-SECONDARY ats reward-token))
        )
    )
    (defcap ATSU|C>X_REMOVE-SECONDARY (ats:string reward-token:string)
        (let
            (
                (ref-ATS:module{AutostakeV5} ATS)
                (rt-position:integer (ref-ATS::URC_RewardTokenPosition ats reward-token))
            )
            (enforce (> rt-position 0) "Primal RT cannot be removed")
            (ref-ATS::UEV_ParameterLockState ats false)
            (ref-ATS::UEV_ColdRecoveryState ats false)
            (ref-ATS::UEV_HotRecoveryState ats false)
            (ref-ATS::UEV_DirectRecoveryState ats false)
            (compose-capability (P|TT))
        )
    )
    (defcap ATSU|C>WITHDRAW-ROYALTIES (ats:string target:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-ATS:module{AutostakeV5} ATS)
                (royalties:[decimal] (ref-ATS::UR_RewardTokenRUR ats 3))
                (sum:decimal (fold (+) 0.0 royalties))
            )
            (ref-DALOS::UEV_EnforceAccountType target false)
            (ref-ATS::CAP_Owner ats)
            (enforce (!= sum 0.0) (format "No Royalties to withdraw for ATS-Pair {}" [ats]))
            (compose-capability (P|DT2))
        )
    )
    ;;
    (defcap ATSU|C>KICKSTART (kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-ATS:module{AutostakeV5} ATS)
                (index:decimal (ref-ATS::URC_Index ats))
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                (l1:integer (length rt-amounts))
                (l2:integer (length rt-lst))
            )
            (ref-ATS::CAP_Owner ats)
            (ref-DALOS::UEV_EnforceAccountType kickstarter false)
            (enforce (= index -1.0) "Kickstarting can only be done on ATS-Pairs with -1 Index")
            (enforce (= l1 l2) "RT-Amounts list does not correspond with the Number of the ATS-Pair Reward Tokens")
            (enforce (> rbt-request-amount 0.0) "RBT Request Amount must be greater than zero!")
            (compose-capability (P|TT))
        )
    )
    (defcap ATSU|C>FUEL (ats:string reward-token:string)
        @event
        (let
            (
                (ref-ATS:module{AutostakeV5} ATS)
                (index:decimal (ref-ATS::URC_Index ats))
            )
            (ref-ATS::UEV_RewardTokenExistance ats reward-token true)
            (enforce (>= index 0.1) "Fueling cannot take place on a negative Index")
            (compose-capability (P|TT))
        )
    )
    (defcap ATSU|C>COIL (ats:string coil-token:string)
        @event
        (let
            (
                (ref-ATS:module{AutostakeV5} ATS)
                (h:bool (ref-ATS::UR_Hibernate ats))
            )
            (ref-ATS::UEV_RewardTokenExistance ats coil-token true)
            (enforce (not h) (format "Cannot Coil when {} has Hibernation turned on" [ats]))
            (compose-capability (P|TT))
        )
    )
    (defcap ATSU|C>CURL (ats1:string ats2:string curl-token:string)
        @event
        (let
            (
                (ref-ATS:module{AutostakeV5} ATS)
                (h1:bool (ref-ATS::UR_Hibernate ats1))
                (h2:bool (ref-ATS::UR_Hibernate ats2))
            )
            (ref-ATS::UEV_RewardTokenExistance ats1 curl-token true)
            (enforce (and (not h1) (not h2)) (format "Curl requires both {} and {} to have Hibernation set to off" [ats1 ats2]))
            (compose-capability (P|TT))
        )
    )
    (defcap ATSU|C>COLD_RECOVERY (recoverer:string ats:string ra:decimal usable-cold-recovery-position:integer)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-ATS:module{AutostakeV5} ATS)
                (cold-recovery-positions:integer (ref-ATS::UR_ColdRecoveryPositions ats))
            )
            (enforce (<= usable-cold-recovery-position cold-recovery-positions) 
                "Unavailable Positions for Cold Recovery!"
            )
            (ref-DALOS::CAP_EnforceAccountOwnership recoverer)
            (ref-ATS::UEV_ColdRecoveryState ats true)
            (compose-capability (ATSU|C>DEPLOY ats recoverer))
            (compose-capability (P|TT))
        )
    )
    (defcap ATSU|C>DEPLOY (ats:string acc:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::UEV_EnforceAccountExists acc)
            (compose-capability (ATSU|C>NORMALIZE_LEDGER ats acc))
        )
    )
    (defcap ATSU|C>NORMALIZE_LEDGER (ats:string acc:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-ATS:module{AutostakeV5} ATS)
                (dalos-admin:guard GOV|MD_ATSU)
                (autos-admin:guard GOV|SC_ATSU)
                (acc-g:guard (ref-DALOS::UR_AccountGuard acc))
                (sov:string (ref-DALOS::UR_AccountSovereign acc))
                (sov-g:guard (ref-DALOS::UR_AccountGuard sov))
                (gov-g:guard (ref-DALOS::UR_AccountGovernor acc))
            )
            (ref-ATS::UEV_id ats)
            (enforce-one
                "Invalid permission for normalizing ATS|Ledger Account Operations"
                [
                    (enforce-guard dalos-admin)
                    (enforce-guard autos-admin)
                    (enforce-guard acc-g)
                    (enforce-guard sov-g)
                    (enforce-guard gov-g)
                ]
            )
            (compose-capability (P|ATSU|CALLER))
        )
    )
    (defcap ATSU|C>CULL (culler:string ats:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership culler)
            (compose-capability (ATSU|C>NORMALIZE_LEDGER ats culler))
            (compose-capability (P|TT))
        )
    )
    ;;
    (defcap ATS|C>HOT_RECOVERY (recoverer:string ats:string ra:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-ATS:module{AutostakeV5} ATS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership recoverer)
            (ref-ATS::UEV_HotRecoveryState ats true)
            (compose-capability (P|TT))
        )
    )
    (defcap ATS|C>RECOVER (recoverer:string id:string nonce:integer amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                (iz-rbt:bool (ref-DPOF::URC_IzRBT id))
                
            )
            (ref-DALOS::UEV_EnforceAccountType recoverer false)
            (enforce iz-rbt "Invalid Hot-RBT")
            (compose-capability (P|TT))
        )
    )
    (defcap ATSU|C>REDEEM (redeemer:string id:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                (iz-rbt:bool (ref-DPOF::URC_IzRBT id))
            )
            (ref-DALOS::UEV_EnforceAccountType redeemer false)
            (enforce iz-rbt "Invalid Hot-RBT")
            (compose-capability (P|TT))
        )
    )
    ;;
    (defcap ATS|C>DIRECT_RECOVERY (recoverer:string ats:string ra:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-ATS:module{AutostakeV5} ATS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership recoverer)
            (ref-ATS::UEV_DirectRecoveryState ats true)
            (compose-capability (P|TT))
        )
    )
    ;;
    (defcap ATSU|C>SYPHON (ats:string syphon-amounts:[decimal])
        @event
        (let
            (
                (ref-ATS:module{AutostakeV5} ATS)
                (ref-U|LST:module{StringProcessor} U|LST)
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                (l0:integer (length syphon-amounts))
                (l1:integer (length rt-lst))
                (max-syphon:[decimal] (ref-ATS::URC_MaxSyphon ats))
                (max-syphon-sum:decimal (fold (+) 0.0 max-syphon))
                (input-syphon-sum:decimal (fold (+) 0.0 syphon-amounts))

                (resident-amounts:[decimal] (ref-ATS::UR_RewardTokenRUR ats 1))
                (supply-check:[bool] (zip (lambda (x:decimal y:decimal) (<= x y)) syphon-amounts resident-amounts))
                (tr-nr:integer (length (ref-U|LST::UC_Search supply-check true)))
            )
            (ref-ATS::CAP_Owner ats)
            (ref-ATS::UEV_SyphoningState ats true)
            (enforce (= l0 l1) "Invalid Amounts of Syphon Values")
            (enforce (> input-syphon-sum 0.0) "Invalid Syphon Amounts")
            (map
                (lambda
                    (sv:decimal)
                    (enforce (>= sv 0.0) "Unallowed Negative Syphon Values Detected !")
                )
                syphon-amounts
            )
            (enforce (<= input-syphon-sum max-syphon-sum) "Syphon Amounts surpassing pairs Syphon-Index")
            (enforce (= l0 tr-nr) "Invalid syphon amounts surpassing present resident Amounts")
            (compose-capability (P|TT))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun A_RemoveSecondary:object{IgnisCollectorV2.OutputCumulator}
        (remover:string ats:string reward-token:string accounts-with-ats-data:[string])
        @doc "Administrative Variant, queries <accounts-with-ats-data> via <DPTF-DPOF-ATS|UR_FilterKeysForInfo>"
        (UEV_IMC)
        (with-capability (ATSU|C>ADMINISTRATIVE-REMOVE-SECONDARY ats reward-token)
            (X_RemoveSecondary remover ats reward-token accounts-with-ats-data)
        )
    )
    ;;{F6}  [C]
    (defun C_RemoveSecondary:object{IgnisCollectorV2.OutputCumulator}
        (remover:string ats:string reward-token:string)
        @doc "Client Variant if <DPTF-DPOF-ATS|UR_FilterKeysForInfo> is cheap enough \
            \ for the whole function to fit inside one Transaction. \
            \ In case it isnt, the Administrative Variant Must be used, with pre-read Data."
        (UEV_IMC)
        (let
            (
                (ref-TFT:module{TrueFungibleTransferV8} TFT)
                (accounts-with-ats-data:[string] (ref-TFT::DPTF-DPOF-ATS|UR_FilterKeysForInfo ats 3 false))
            )
            (with-capability (ATSU|C>REMOVE-SECONDARY ats reward-token)
                (X_RemoveSecondary remover ats reward-token accounts-with-ats-data)
            )
        )
    )
    (defun C_WithdrawRoyalties:object{IgnisCollectorV2.OutputCumulator}
        (ats:string target:string)
        (UEV_IMC)
        (with-capability (ATSU|C>WITHDRAW-ROYALTIES ats target)
            (let
                (
                    (ref-ATS:module{AutostakeV5} ATS)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    (reward-tokens:[string] (ref-ATS::UR_RewardTokenList ats))
                    (royalties:[decimal] (ref-ATS::UR_RewardTokenRUR ats 3))
                )
                ;;1]Set Royalties Values back to 0.0 for all RTs
                (map
                    (lambda
                        (index:integer)
                        (ref-ATS::XE_UpdateRUR ats (at index reward-tokens) 3 false (at index royalties))
                    )
                    (enumerate 0 (- (length reward-tokens) 1))
                )
                ;;2]Withdraw Royalties to Target
                (ref-TFT::C_MultiTransfer reward-tokens ATS|SC_NAME target royalties true)
            )
        )
    )
    (defun C_KickStart:object{IgnisCollectorV2.OutputCumulator}
        (kickstarter:string ats:string rt-amounts:[decimal] rbt-request-amount:decimal)
        (UEV_IMC)
        (with-capability (ATSU|C>KICKSTART kickstarter ats rt-amounts rbt-request-amount)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    ;;
                    (rbt-id:string (ref-ATS::UR_ColdRewardBearingToken ats))
                    (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                    ;;
                    (folded-obj:[object{IgnisCollectorV2.OutputCumulator}]
                        (fold
                            (lambda
                                (acc:[object{IgnisCollectorV2.OutputCumulator}] idx:integer)
                                (do
                                    (ref-ATS::XE_UpdateRUR ats (at idx rt-lst) 1 true (at idx rt-amounts))
                                    (ref-U|LST::UC_AppL acc 
                                        (ref-TFT::C_Transfer (at idx rt-lst) kickstarter ATS|SC_NAME (at idx rt-amounts) true)
                                    )
                                )
                            )
                            []
                            (enumerate 0 (- (length rt-lst) 1))
                        )
                    )
                    (ico1:object{IgnisCollectorV2.OutputCumulator}
                        (ref-IGNIS::UDC_ConcatenateOutputCumulators folded-obj [])      
                    )
                    (ico2:object{IgnisCollectorV2.OutputCumulator}
                        (ref-DPTF::C_Mint rbt-id ATS|SC_NAME rbt-request-amount false)
                    )
                    (ico3:object{IgnisCollectorV2.OutputCumulator}
                        (ref-TFT::C_Transfer rbt-id ATS|SC_NAME kickstarter rbt-request-amount true)
                    )
                    (index:decimal (ref-ATS::URC_Index ats))
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2 ico3] [index])  
            )
        )
    )
    (defun C_Fuel:object{IgnisCollectorV2.OutputCumulator}
        (fueler:string ats:string reward-token:string amount:decimal)
        @doc "Fuels an <ats> ATS-Pair, increasing it Index."
        (UEV_IMC)
        (let
            (
                (ref-ATS:module{AutostakeV5} ATS)
                (ref-TFT:module{TrueFungibleTransferV8} TFT)
            )
            (with-capability (ATSU|C>FUEL ats reward-token)
                (ref-ATS::XE_UpdateRUR ats reward-token 1 true amount)
                (ref-TFT::C_Transfer reward-token fueler ATS|SC_NAME amount true)
            )
        )
    )
    (defun C_Coil:object{IgnisCollectorV2.OutputCumulator}
        (coiler:string ats:string rt:string amount:decimal)
        @doc "Autostakes an <rt> Token on <ats> ATS-Pair. \
            \ If Hibernate is on, retains the <c-rbt-amount>, which will then be hibernated \
            \ from the TALOS module, and sent as Hibernated H| Token to the <coiler>"
        (UEV_IMC)
        (with-capability (ATSU|C>COIL ats rt)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    ;;
                    ;;<ats>
                    (coil-data:object{AutostakeV5.CoilData} 
                        (ref-ATS::URC_RewardBearingTokenAmounts ats rt amount)
                    )
                    (input-amount:decimal (at "first-input-amount" coil-data))
                    (royalty-fee:decimal (at "royalty-fee" coil-data))
                    (c-rbt:string (at "rbt-id" coil-data))
                    (c-rbt-amount (at "rbt-amount" coil-data))
                    ;;
                    (ico1:object{IgnisCollectorV2.OutputCumulator}
                        (ref-TFT::C_Transfer rt coiler ATS|SC_NAME amount true)
                    )
                    (ico2:object{IgnisCollectorV2.OutputCumulator}
                        (ref-DPTF::C_Mint c-rbt ATS|SC_NAME c-rbt-amount false)
                    )
                    (ico3:object{IgnisCollectorV2.OutputCumulator}
                        (ref-TFT::C_Transfer c-rbt ATS|SC_NAME coiler c-rbt-amount true)
                    )
                )
                (ref-ATS::XE_UpdateRUR ats rt 1 true input-amount)
                (if (!= royalty-fee 0.0)
                    (ref-ATS::XE_UpdateRUR ats rt 3 true royalty-fee)
                    true
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2 ico3] [c-rbt-amount])
            )  
        )
    )
    (defun C_Curl:object{IgnisCollectorV2.OutputCumulator}
        (curler:string ats1:string ats2:string rt:string amount:decimal)
        @doc "Coils through 2 ATS-Pairs, outputting the <c-rbt2> to the <curler> \
            \ Both <ats1> and <ats2> must have <hibernation> off"
        (UEV_IMC)
        (with-capability (ATSU|C>CURL ats1 ats2 rt)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    ;;
                    ;;<ats1>
                    (coil1-data:object{AutostakeV5.CoilData} 
                        (ref-ATS::URC_RewardBearingTokenAmounts ats1 rt amount)
                    )
                    (input1-amount:decimal (at "first-input-amount" coil1-data))
                    (royalty1-fee:decimal (at "royalty-fee" coil1-data))
                    (c-rbt1:string (at "rbt-id" coil1-data))
                    (c-rbt1-amount (at "rbt-amount" coil1-data))
                    ;;
                    ;;<ats2>
                    (coil2-data:object{AutostakeV5.CoilData} 
                        (ref-ATS::URC_RewardBearingTokenAmounts ats2 c-rbt1 c-rbt1-amount)
                    )
                    (input2-amount:decimal (at "first-input-amount" coil2-data))
                    (royalty2-fee:decimal (at "royalty-fee" coil2-data))
                    (c-rbt2:string (at "rbt-id" coil2-data))
                    (c-rbt2-amount (at "rbt-amount" coil2-data))
                    ;;
                    (ico1:object{IgnisCollectorV2.OutputCumulator}
                        (ref-TFT::C_Transfer rt curler ATS|SC_NAME amount true)
                    )
                    (ico2:object{IgnisCollectorV2.OutputCumulator}
                        (ref-DPTF::C_Mint c-rbt1 ATS|SC_NAME c-rbt1-amount false)
                    )
                    (ico3:object{IgnisCollectorV2.OutputCumulator}
                        (ref-DPTF::C_Mint c-rbt2 ATS|SC_NAME c-rbt2-amount false)
                    )
                    (ico4:object{IgnisCollectorV2.OutputCumulator}
                        (ref-TFT::C_Transfer c-rbt2 ATS|SC_NAME curler c-rbt2-amount true)
                    )
                )
                (ref-ATS::XE_UpdateRUR ats1 rt 1 true input1-amount)
                (ref-ATS::XE_UpdateRUR ats2 c-rbt1 1 true input2-amount)
                (if (!= royalty1-fee 0.0)
                    (ref-ATS::XE_UpdateRUR ats1 rt 3 true royalty1-fee)
                    true
                )
                (if (!= royalty2-fee 0.0)
                    (ref-ATS::XE_UpdateRUR ats2 c-rbt1 3 true royalty2-fee)
                    true
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2 ico3 ico4] [c-rbt2-amount])
            )
        )
    )
    ;;
    (defun C_ColdRecovery:object{IgnisCollectorV2.OutputCumulator}
        (recoverer:string ats:string ra:decimal)
        (UEV_IMC)
        (let
            (
                (ref-ATS:module{AutostakeV5} ATS)
                (usable-cold-recovery-position:integer (ref-ATS::URC_WhichPosition ats ra recoverer))
            )
            (enforce (!= usable-cold-recovery-position 0) "Cold Recovery Unavailable! All existing Positions are used!")
            (with-capability (ATSU|C>COLD_RECOVERY recoverer ats ra usable-cold-recovery-position)
                (XI_DeployAccount ats recoverer)
                (let
                    (
                        (ref-U|LST:module{StringProcessor} U|LST)
                        (ref-U|ATS:module{UtilityAtsV2} U|ATS)
                        (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                        (ref-DALOS:module{OuronetDalosV5} DALOS)
                        (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                        (ref-TFT:module{TrueFungibleTransferV8} TFT)
                        ;;
                        (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                        (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                        (c-rbt-precision:integer (ref-DPTF::UR_Decimals c-rbt))
                        (fee-promile:decimal (ref-ATS::URC_ColdRecoveryFee ats ra usable-cold-recovery-position))
                        (c-rbt-fee-split:[decimal] (ref-U|ATS::UC_PromilleSplit fee-promile ra c-rbt-precision))
                        ;;
                        (biggest:decimal (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                        (price:decimal (* 2.0 biggest))
                        (trigger:bool (ref-IGNIS::URC_IsVirtualGasZero))
                        (ico0:object{IgnisCollectorV2.OutputCumulator}
                            ;;10 Flat IGNIS cost for Cold Recovery
                            (ref-IGNIS::UDC_ConstructOutputCumulator price ATS|SC_NAME trigger [])
                        )
                        (ico1:object{IgnisCollectorV2.OutputCumulator}
                            (ref-TFT::C_Transfer c-rbt recoverer ATS|SC_NAME ra true)
                        )
                        (ico2:object{IgnisCollectorV2.OutputCumulator}
                            (ref-DPTF::C_Burn c-rbt ATS|SC_NAME ra)
                        )
                        ;;
                        (c-fr:bool (ref-ATS::UR_ColdRecoveryFeeRedirection ats))
                        (cull-time:time (ref-ATS::URC_CullColdRecoveryTime ats recoverer))
                        (c-rbt-remainder:decimal (at 0 c-rbt-fee-split))
                        (c-rbt-fee:decimal (at 1 c-rbt-fee-split))
                        ;;
                        (positive-c-fr:[decimal]
                            ;;For true <c-fr>
                            ;:Remainder
                            (ref-ATS::URC_RTSplitAmounts ats c-rbt-remainder)
                        )
                        (ico3:object{IgnisCollectorV2.OutputCumulator}
                            ;;Handle the Fee Part
                            (if (= c-rbt-fee 0.0)
                                EOC
                                (if c-fr
                                    EOC
                                    (let
                                        (
                                            (ng-c-fr:[decimal]
                                                ;For false <c-fre>
                                                ;Fee-Part
                                                (ref-ATS::URC_RTSplitAmounts ats c-rbt-fee)
                                            )
                                        )
                                        (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                                            (fold
                                                (lambda
                                                    (acc:[object{IgnisCollectorV2.OutputCumulator}] idx:integer)
                                                    (do
                                                        (ref-ATS::XE_UpdateRUR ats (at idx rt-lst) 1 false (at idx ng-c-fr))
                                                        (ref-U|LST::UC_AppL acc 
                                                            (ref-DPTF::C_Burn (at idx rt-lst) ATS|SC_NAME (at idx ng-c-fr))
                                                        )
                                                    )
                                                )
                                                []
                                                (enumerate 0 (- (length rt-lst) 1))
                                            )
                                            []
                                        )
                                    )
                                )
                            )
                        )
                    )
                    ;;Handle The Remainder
                    (map
                        (lambda
                            (index:integer)
                            (ref-ATS::XE_UpdateRUR ats (at index rt-lst) 2 true (at index positive-c-fr))
                            (ref-ATS::XE_UpdateRUR ats (at index rt-lst) 1 false (at index positive-c-fr))
                        )
                        (enumerate 0 (- (length rt-lst) 1))
                    )
                    (XI_StoreUnstakeObject ats recoverer usable-cold-recovery-position
                        { "reward-tokens"   : positive-c-fr
                        , "cull-time"       : cull-time}
                    )
                    (XI_Normalize ats recoverer)
                    (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico0 ico1 ico2 ico3] [])
                )
            )
        )
    )
    (defun C_Cull:object{IgnisCollectorV2.OutputCumulator}
        (culler:string ats:string)
        (UEV_IMC)
        (with-capability (ATSU|C>CULL culler ats)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-U|DEC:module{OuronetDecimals} U|DEC)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DALOS:module{OuronetDalosV5} DALOS)
                    (ref-ATS:module{AutostakeV5} ATS)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    ;;
                    (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                    (c0:[decimal] (XI_MultiCull ats culler))
                    (c1:[decimal] (XI_SingleCull ats culler 1))
                    (c2:[decimal] (XI_SingleCull ats culler 2))
                    (c3:[decimal] (XI_SingleCull ats culler 3))
                    (c4:[decimal] (XI_SingleCull ats culler 4))
                    (c5:[decimal] (XI_SingleCull ats culler 5))
                    (c6:[decimal] (XI_SingleCull ats culler 6))
                    (c7:[decimal] (XI_SingleCull ats culler 7))
                    (ca:[[decimal]] [c0 c1 c2 c3 c4 c5 c6 c7])
                    (cw:[decimal] (ref-U|DEC::UC_AddHybridArray ca))
                    ;;
                    (biggest:decimal (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                    (price:decimal (* 2.0 biggest))
                    (trigger:bool (ref-IGNIS::URC_IsVirtualGasZero))
                    ;;
                    (ico1:object{IgnisCollectorV2.OutputCumulator}
                        (ref-IGNIS::UDC_ConstructOutputCumulator price ATS|SC_NAME trigger [])
                    )
                    (folded-obj:[object{IgnisCollectorV2.OutputCumulator}]
                        (fold
                            (lambda
                                (acc:[object{IgnisCollectorV2.OutputCumulator}] idx:integer)
                                (ref-U|LST::UC_AppL acc
                                    (if (!= (at idx cw) 0.0)
                                        (do
                                            (ref-ATS::XE_UpdateRUR ats (at idx rt-lst) 2 false (at idx cw))
                                            (ref-TFT::C_Transfer (at idx rt-lst) ATS|SC_NAME culler (at idx cw) true)
                                        )
                                        EOC
                                    )
                                )
                            )
                            []
                            (enumerate 0 (- (length rt-lst) 1))
                        )
                    )
                    (ico2:object{IgnisCollectorV2.OutputCumulator}
                        (ref-IGNIS::UDC_ConcatenateOutputCumulators folded-obj [])
                    )
                )
                (XI_Normalize ats culler)
                (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2] cw)
            )
        )
    )
    ;;
    (defun C_HotRecovery:object{IgnisCollectorV2.OutputCumulator}
        (recoverer:string ats:string ra:decimal)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                (ref-ATS:module{AutostakeV5} ATS)
                (ref-TFT:module{TrueFungibleTransferV8} TFT)
                ;;
                (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                (h-rbt:string (ref-ATS::UR_HotRewardBearingToken ats))
                (present-time:time (at "block-time" (chain-data)))
                (meta-data-obj:object{AutostakeV5.ATS|Hot} {"mint-time" : present-time})
                (new-nonce:integer (+ (ref-DPOF::UR_NoncesUsed h-rbt) 1))
                ;;
            )
            (with-capability (ATS|C>HOT_RECOVERY recoverer ats ra)
                (let
                    (
                        (ico1:object{IgnisCollectorV2.OutputCumulator}
                            (ref-IGNIS::UDC_ConstructOutputCumulator 
                                (* 3.0 (ref-DALOS::UR_UsagePrice "ignis|biggest"))
                                ATS|SC_NAME
                                (ref-IGNIS::URC_IsVirtualGasZero)
                                []
                            )
                        )
                        (ico2:object{IgnisCollectorV2.OutputCumulator}
                            (ref-TFT::C_Transfer c-rbt recoverer ATS|SC_NAME ra true)
                        )
                        (ico3:object{IgnisCollectorV2.OutputCumulator}
                            (ref-DPTF::C_Burn c-rbt ATS|SC_NAME ra)
                        )
                        (ico4:object{IgnisCollectorV2.OutputCumulator}
                            (ref-DPOF::C_Mint h-rbt ATS|SC_NAME ra [meta-data-obj])
                        )
                        (ico5:object{IgnisCollectorV2.OutputCumulator}
                            (ref-DPOF::C_Transfer h-rbt [new-nonce] ATS|SC_NAME recoverer true)
                        )
                    )
                    (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2 ico3 ico4 ico5] [])
                )
            )
        )
    )
    (defun C_Recover:object{IgnisCollectorV2.OutputCumulator}
        (recoverer:string id:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                (ref-ATS:module{AutostakeV5} ATS)
                (ref-TFT:module{TrueFungibleTransferV8} TFT)
                ;;
                (ats:string (ref-DPOF::UR_RewardBearingToken id))
                (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                (nonce-supply:decimal (ref-DPOF::UR_NonceSupply id nonce))
            )
            (with-capability (ATS|C>RECOVER recoverer id nonce)
                (let
                    (
                        (ico1:object{IgnisCollectorV2.OutputCumulator}
                            (ref-DPOF::C_Transfer id [nonce] recoverer ATS|SC_NAME true)
                        )
                        (ico2:object{IgnisCollectorV2.OutputCumulator}
                            (ref-DPOF::C_Burn id ATS|SC_NAME nonce nonce-supply)
                        )
                        (ico3:object{IgnisCollectorV2.OutputCumulator}
                            (ref-DPTF::C_Mint c-rbt ATS|SC_NAME nonce-supply false)
                        )
                        (ico4:object{IgnisCollectorV2.OutputCumulator}
                            (ref-TFT::C_Transfer c-rbt ATS|SC_NAME recoverer nonce-supply true)
                        )
                    )
                    (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2 ico3 ico4] [])
                )
            )
        )
    )
    (defun C_Redeem:object{IgnisCollectorV2.OutputCumulator}
        (redeemer:string id:string nonce:integer)
        (UEV_IMC)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (ref-DPOF:module{DemiourgosPactOrtoFungible} DPOF)
                (ref-ATS:module{AutostakeV5} ATS)
                (ref-TFT:module{TrueFungibleTransferV8} TFT)
                ;;
                (precision:integer (ref-DPOF::UR_Decimals id))
                (nonce-supply:decimal (ref-DPOF::UR_NonceSupply id nonce))
                (meta-data-chain:[object] (ref-DPOF::UR_NonceMetaData id nonce))
                ;;
                (birth-date:time (at "mint-time" (at 0 meta-data-chain)))
                (present-time:time (at "block-time" (chain-data)))
                (elapsed-time:decimal (diff-time present-time birth-date))
                ;;
                (ats:string (ref-DPOF::UR_RewardBearingToken id))
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                (h-promile:decimal (ref-ATS::UR_HotRecoveryStartingFeePromile ats))
                (h-decay:integer (ref-ATS::UR_HotRecoveryDecayPeriod ats))
                (h-fr:bool (ref-ATS::UR_HotRecoveryFeeRedirection ats))
                ;;
                (total-time:decimal (* 86400.0 (dec h-decay)))
                (end-time:time (add-time birth-date (hours (* 24 h-decay))))
                (earned-rbt:decimal
                    (if (>= elapsed-time total-time)
                        nonce-supply
                        (floor (* nonce-supply (/ (- 1000.0 (* h-promile (- 1.0 (/ elapsed-time total-time)))) 1000.0)) precision)
                    )
                )
                (total-rts:[decimal] (ref-ATS::URC_RTSplitAmounts ats nonce-supply))
                (earned-rts:[decimal] (ref-ATS::URC_RTSplitAmounts ats earned-rbt))
                (fee-rts:[decimal] (zip (lambda (x:decimal y:decimal) (- x y)) total-rts earned-rts))
                (are-fee-rts:decimal (fold (+) 0.0 fee-rts))
            )
            (with-capability (ATSU|C>REDEEM redeemer id)
                (let
                    (
                        (ico1:object{IgnisCollectorV2.OutputCumulator}
                            (ref-DPOF::C_Transfer id [nonce] redeemer ATS|SC_NAME true)
                        )
                        (ico2:object{IgnisCollectorV2.OutputCumulator}
                            (ref-DPOF::C_Burn id ATS|SC_NAME nonce nonce-supply)
                        )
                        (ico3:object{IgnisCollectorV2.OutputCumulator}
                            (ref-TFT::C_MultiTransfer rt-lst ATS|SC_NAME redeemer earned-rts true)
                        )
                        (folded-obj:[object{IgnisCollectorV2.OutputCumulator}]
                            (if are-fee-rts
                                (fold
                                    (lambda
                                        (acc:[object{IgnisCollectorV2.OutputCumulator}] idx:integer)
                                        (do
                                            (ref-ATS::XE_UpdateRUR ats (at idx rt-lst) 1 false (at idx fee-rts))
                                            (ref-U|LST::UC_AppL acc
                                                (ref-DPTF::C_Burn (at idx rt-lst) ATS|SC_NAME (at idx fee-rts))
                                            )
                                        )
                                    )
                                    []
                                    (enumerate 0 (- (length rt-lst) 1))
                                )
                                [EOC]
                            )
                        )
                        (ico4:object{IgnisCollectorV2.OutputCumulator}
                            (if (and (not h-fr) (!= earned-rbt nonce-supply))
                                (ref-IGNIS::UDC_ConcatenateOutputCumulators folded-obj [])
                                EOC
                            )
                        )
                    )
                    (map
                        (lambda
                            (idx:integer)
                            (ref-ATS::XE_UpdateRUR ats (at idx rt-lst) 1 false (at idx earned-rts))
                        )
                        (enumerate 0 (- (length rt-lst) 1))
                    )
                    (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2 ico3 ico4] [])
                )
            )
        )
    )
    ;;
    (defun C_DirectRecovery:object{IgnisCollectorV2.OutputCumulator}
        (recoverer:string ats:string ra:decimal)
        (UEV_IMC)
        (with-capability (ATS|C>DIRECT_RECOVERY recoverer ats ra)
            (let
                (
                    (ref-U|ATS:module{UtilityAtsV2} U|ATS)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                    (ref-ATS:module{AutostakeV5} ATS)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    ;;
                    (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                    (c-rbt:string (ref-ATS::UR_ColdRewardBearingToken ats))
                    (c-rbt-precision:integer (ref-DPTF::UR_Decimals c-rbt))
                    (fee:decimal (ref-ATS::UR_DirectRecoveryFee ats))
                    (c-rbt-remainder:decimal
                        (if (= fee 0.0)
                            ra
                            (at 0 (ref-U|ATS::UC_PromilleSplit fee ra (ref-DPTF::UR_Decimals c-rbt)))
                        )
                    )
                    (reward-tokens:[string] (ref-ATS::UR_RewardTokenList ats))
                    (release-amounts:[decimal] (ref-ATS::URC_RTSplitAmounts ats c-rbt-remainder))
                )
                ;;0]Update ATS Data
                (map
                    (lambda
                        (index:integer)
                        (ref-ATS::XE_UpdateRUR ats (at index rt-lst) 1 false (at index release-amounts))
                    )
                    (enumerate 0 (- (length reward-tokens) 1))
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators 
                    [
                        ;;1]Transfer c-rbt to ATS|SC_NAME
                        (ref-TFT::C_Transfer c-rbt recoverer ATS|SC_NAME ra true)
                        ;;2]Burn it
                        (ref-DPTF::C_Burn c-rbt ATS|SC_NAME ra)
                        ;;3]Release equivalnet RTs (minus fee)
                        (ref-TFT::C_MultiTransfer reward-tokens ATS|SC_NAME recoverer release-amounts true)
                    ] 
                    []
                )
            )
        )
    )
    ;;
    (defun C_Syphon:object{IgnisCollectorV2.OutputCumulator}
        (syphon-target:string ats:string syphon-amounts:[decimal])
        (UEV_IMC)
        (with-capability (ATSU|C>SYPHON ats syphon-amounts)
            (let
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-ATS:module{AutostakeV5} ATS)
                    (ref-TFT:module{TrueFungibleTransferV8} TFT)
                    ;;
                    (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                    (folded-obj:[object{IgnisCollectorV2.OutputCumulator}]
                        (fold
                            (lambda
                                (acc:[object{IgnisCollectorV2.OutputCumulator}] idx:integer)
                                (ref-U|LST::UC_AppL acc
                                    (if (> (at idx syphon-amounts) 0.0)
                                        (do
                                            (ref-ATS::XE_UpdateRUR ats (at idx rt-lst) 1 false (at idx syphon-amounts))
                                            (ref-TFT::C_Transfer (at idx rt-lst) ATS|SC_NAME syphon-target (at idx syphon-amounts) true)
                                        )
                                        EOC
                                    )

                                )
                            )
                            []
                            (enumerate 0 (- (length rt-lst) 1))
                        )
                    )
                )
                (ref-IGNIS::UDC_ConcatenateOutputCumulators folded-obj [])
            )
        )
    )
    ;;{F7}  [X]
    (defun XI_DeployAccount (ats:string acc:string)
        (require-capability (ATSU|C>DEPLOY ats acc))
        (let
            (
                (ref-ATS:module{AutostakeV5} ATS)
            )
            (ref-ATS::XE_SpawnAutostakeAccount ats acc)
            (XI_Normalize ats acc)
        )
    )
    (defun XI_Normalize (ats:string acc:string)
        (require-capability (ATSU|C>NORMALIZE_LEDGER ats acc))
        (let
            (
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-ATS:module{AutostakeV5} ATS)
                (p0:[object{UtilityAtsV2.Awo}] (ref-ATS::UR_P0 ats acc))
                (p1:object{UtilityAtsV2.Awo} (ref-ATS::UR_P1-7 ats acc 1))
                (p2:object{UtilityAtsV2.Awo} (ref-ATS::UR_P1-7 ats acc 2))
                (p3:object{UtilityAtsV2.Awo} (ref-ATS::UR_P1-7 ats acc 3))
                (p4:object{UtilityAtsV2.Awo} (ref-ATS::UR_P1-7 ats acc 4))
                (p5:object{UtilityAtsV2.Awo} (ref-ATS::UR_P1-7 ats acc 5))
                (p6:object{UtilityAtsV2.Awo} (ref-ATS::UR_P1-7 ats acc 6))
                (p7:object{UtilityAtsV2.Awo} (ref-ATS::UR_P1-7 ats acc 7))
                (zr:object{UtilityAtsV2.Awo} (ref-ATS::UDC_MakeZeroUnstakeObject ats))
                (ng:object{UtilityAtsV2.Awo} (ref-ATS::UDC_MakeNegativeUnstakeObject ats))
                (positions:integer (ref-ATS::UR_ColdRecoveryPositions ats))
                (elite:bool (ref-ATS::UR_EliteMode ats))
                (major-tier:integer (ref-DALOS::UR_Elite-Tier-Major acc))
                ;;
                (p0-znn:[object{UtilityAtsV2.Awo}] (if (and (!= p0 [zr]) (!= p0 [ng])) p0 [ng]))
                (p0-znz:[object{UtilityAtsV2.Awo}] (if (and (!= p0 [zr]) (!= p0 [ng])) p0 [zr]))
                (p1-znn:object{UtilityAtsV2.Awo} (if (and (!= p1 zr) (!= p1 ng)) p1 ng))
                (p1-znz:object{UtilityAtsV2.Awo} (if (and (!= p1 zr) (!= p1 ng)) p1 zr))
                (p2-znn:object{UtilityAtsV2.Awo} (if (and (!= p2 zr) (!= p2 ng)) p2 ng))
                (p2-znz:object{UtilityAtsV2.Awo} (if (and (!= p2 zr) (!= p2 ng)) p2 zr))
                (p3-znn:object{UtilityAtsV2.Awo} (if (and (!= p3 zr) (!= p3 ng)) p3 ng))
                (p3-znz:object{UtilityAtsV2.Awo} (if (and (!= p3 zr) (!= p3 ng)) p3 zr))
                (p4-znn:object{UtilityAtsV2.Awo} (if (and (!= p4 zr) (!= p4 ng)) p4 ng))
                (p4-znz:object{UtilityAtsV2.Awo} (if (and (!= p4 zr) (!= p4 ng)) p4 zr))
                (p5-znn:object{UtilityAtsV2.Awo} (if (and (!= p5 zr) (!= p5 ng)) p5 ng))
                (p5-znz:object{UtilityAtsV2.Awo} (if (and (!= p5 zr) (!= p5 ng)) p5 zr))
                (p6-znn:object{UtilityAtsV2.Awo} (if (and (!= p6 zr) (!= p6 ng)) p6 ng))
                (p6-znz:object{UtilityAtsV2.Awo} (if (and (!= p6 zr) (!= p6 ng)) p6 zr))
                (p7-znn:object{UtilityAtsV2.Awo} (if (and (!= p7 zr) (!= p7 ng)) p7 ng))
                (p7-znz:object{UtilityAtsV2.Awo} (if (and (!= p7 zr) (!= p7 ng)) p7 zr))
                (p2-zne:object{UtilityAtsV2.Awo} (if (and (!= p2 zr) (!= p2 ng)) p2 (if (>= major-tier 2) zr ng)))
                (p3-zne:object{UtilityAtsV2.Awo} (if (and (!= p3 zr) (!= p3 ng)) p3 (if (>= major-tier 3) zr ng)))
                (p4-zne:object{UtilityAtsV2.Awo} (if (and (!= p4 zr) (!= p4 ng)) p4 (if (>= major-tier 4) zr ng)))
                (p5-zne:object{UtilityAtsV2.Awo} (if (and (!= p5 zr) (!= p5 ng)) p5 (if (>= major-tier 5) zr ng)))
                (p6-zne:object{UtilityAtsV2.Awo} (if (and (!= p6 zr) (!= p6 ng)) p6 (if (>= major-tier 6) zr ng)))
                (p7-zne:object{UtilityAtsV2.Awo} (if (and (!= p7 zr) (!= p7 ng)) p7 (if (>= major-tier 7) zr ng)))
                ;;
                (c-pm1:[object{UtilityAtsV2.Awo}] (fold (+) [] [p0-znz [p1-znn] [p2-znn] [p3-znn] [p4-znn] [p5-znn] [p6-znn] [p7-znn]]))
                (c-p1:[object{UtilityAtsV2.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-znn] [p3-znn] [p4-znn] [p5-znn] [p6-znn] [p7-znn]]))
                (c-p2:[object{UtilityAtsV2.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-znz] [p3-znn] [p4-znn] [p5-znn] [p6-znn] [p7-znn]]))
                (c-p3:[object{UtilityAtsV2.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-znz] [p3-znz] [p4-znn] [p5-znn] [p6-znn] [p7-znn]]))
                (c-p4:[object{UtilityAtsV2.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-znz] [p3-znz] [p4-znz] [p5-znn] [p6-znn] [p7-znn]]))
                (c-p5:[object{UtilityAtsV2.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-znz] [p3-znz] [p4-znz] [p5-znz] [p6-znn] [p7-znn]]))
                (c-p6:[object{UtilityAtsV2.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-znz] [p3-znz] [p4-znz] [p5-znz] [p6-znz] [p7-znn]]))
                (c-ne:[object{UtilityAtsV2.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-znz] [p3-znz] [p4-znz] [p5-znz] [p6-znz] [p7-znz]]))
                (c-el:[object{UtilityAtsV2.Awo}] (fold (+) [] [p0-znn [p1-znz] [p2-zne] [p3-zne] [p4-zne] [p5-zne] [p6-zne] [p7-zne]]))

            )
            (cond
                ((= positions -1) (XI_UUP ats acc c-pm1))
                ((= positions 1) (XI_UUP ats acc c-p1))
                ((= positions 2) (XI_UUP ats acc c-p2))
                ((= positions 3) (XI_UUP ats acc c-p3))
                ((= positions 4) (XI_UUP ats acc c-p4))
                ((= positions 5) (XI_UUP ats acc c-p5))
                ((= positions 6) (XI_UUP ats acc c-p6))
                ((not elite) (XI_UUP ats acc c-ne))
                (elite (XI_UUP ats acc c-el))
                true
            )
        )
    )
    (defun XI_UUP (ats:string acc:string data:[object{UtilityAtsV2.Awo}])
        (let
            (
                (ref-ATS:module{AutostakeV5} ATS)
            )
            (ref-ATS::XE_UpP0 ats acc (drop -7 data))
            (ref-ATS::XE_UpP1 ats acc (at 0 (take 1 (take -7 data))))
            (ref-ATS::XE_UpP2 ats acc (at 0 (take 1 (take -6 data))))
            (ref-ATS::XE_UpP3 ats acc (at 0 (take 1 (take -5 data))))
            (ref-ATS::XE_UpP4 ats acc (at 0 (take 1 (take -4 data))))
            (ref-ATS::XE_UpP5 ats acc (at 0 (take 1 (take -3 data))))
            (ref-ATS::XE_UpP6 ats acc (at 0 (take 1 (take -2 data))))
            (ref-ATS::XE_UpP7 ats acc (at 0 (take -1 data)))
        )
    )
    (defun XI_StoreUnstakeObject (ats:string acc:string position:integer obj:object{UtilityAtsV2.Awo})
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-ATS:module{AutostakeV5} ATS)
                (p0:[object{UtilityAtsV2.Awo}] (ref-ATS::UR_P0 ats acc))
            )
            (if (= position -1)
                (if (and
                        (= (length p0) 1)
                        (=
                            (at 0 p0)
                            (ref-ATS::UDC_MakeZeroUnstakeObject ats)
                        )
                    )
                    (ref-ATS::XE_UpP0 ats acc [obj])
                    (ref-ATS::XE_UpP0 ats acc (ref-U|LST::UC_AppL p0 obj))
                )
                (cond
                    ((= position 1) (ref-ATS::XE_UpP1 ats acc obj))
                    ((= position 2) (ref-ATS::XE_UpP2 ats acc obj))
                    ((= position 3) (ref-ATS::XE_UpP3 ats acc obj))
                    ((= position 4) (ref-ATS::XE_UpP4 ats acc obj))
                    ((= position 5) (ref-ATS::XE_UpP5 ats acc obj))
                    ((= position 6) (ref-ATS::XE_UpP6 ats acc obj))
                    ((= position 7) (ref-ATS::XE_UpP7 ats acc obj))
                    true
                )
            )
        )
    )
    (defun XI_MultiCull:[decimal] (ats:string acc:string)
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|DEC:module{OuronetDecimals} U|DEC)
                (ref-U|ATS:module{UtilityAtsV2} U|ATS)
                (ref-ATS:module{AutostakeV5} ATS)
                ;;
                (zr:object{UtilityAtsV2.Awo} (ref-ATS::UDC_MakeZeroUnstakeObject ats))
                (ng:object{UtilityAtsV2.Awo} (ref-ATS::UDC_MakeNegativeUnstakeObject ats))
                (p0:[object{UtilityAtsV2.Awo}] (ref-ATS::UR_P0 ats acc))
                (p0l:integer (length p0))
                (boolean-lst:[bool]
                    (fold
                        (lambda
                            (acc:[bool] item:object{UtilityAtsV2.Awo})
                            (ref-U|LST::UC_AppL acc (ref-U|ATS::UC_IzCullable item))
                        )
                        []
                        p0
                    )
                )
                (zr-output:[decimal] (make-list (length (ref-ATS::UR_RewardTokens ats)) 0.0))
                (cullables:[integer] (ref-U|LST::UC_Search boolean-lst true))
                (immutables:[integer] (ref-U|LST::UC_Search boolean-lst false))
                (how-many-cullables:integer (length cullables))
            )
            (if (= how-many-cullables 0)
                zr-output
                (let
                    (
                        (after-cull:[object{UtilityAtsV2.Awo}]
                            (if (< how-many-cullables p0l)
                                (fold
                                    (lambda
                                        (acc:[object{UtilityAtsV2.Awo}] idx:integer)
                                        (ref-U|LST::UC_AppL acc (at (at idx immutables) p0))
                                    )
                                    []
                                    (enumerate 0 (- (length immutables) 1))
                                )
                                [zr]
                            )
                        )
                        (to-be-culled:[object{UtilityAtsV2.Awo}]
                            (fold
                                (lambda
                                    (acc:[object{UtilityAtsV2.Awo}] idx:integer)
                                    (ref-U|LST::UC_AppL acc (at (at idx cullables) p0))
                                )
                                []
                                (enumerate 0 (- (length cullables) 1))
                            )
                        )
                        (culled-values:[[decimal]]
                            (fold
                                (lambda
                                    (acc:[[decimal]] idx:integer)
                                    (ref-U|LST::UC_AppL acc (ref-ATS::URC_CullValue ats (at idx to-be-culled)))
                                )
                                []
                                (enumerate 0 (- (length to-be-culled) 1))
                            )
                        )
                        (summed-culled-values:[decimal] (ref-U|DEC::UC_AddHybridArray culled-values))
                    )
                    (ref-ATS::XE_UpP0 ats acc after-cull)
                    summed-culled-values
                )
            )
        )
    )
    (defun XI_SingleCull:[decimal] (ats:string acc:string position:integer)
        (let
            (
                (ref-ATS:module{AutostakeV5} ATS)
                ;;
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                (l:integer (length rt-lst))
                (empty:[decimal] (make-list l 0.0))
                (zr:object{UtilityAtsV2.Awo} (ref-ATS::UDC_MakeZeroUnstakeObject ats))
                (unstake-obj:object{UtilityAtsV2.Awo} (ref-ATS::UR_P1-7 ats acc position))
                (rt-amounts:[decimal] (at "reward-tokens" unstake-obj))
                (cull-output:[decimal] (ref-ATS::URC_CullValue ats unstake-obj))
            )
            (if (!= cull-output empty)
                (XI_StoreUnstakeObject ats acc position zr)
                true
            )
            cull-output
        )
    )
    (defun X_RemoveSecondary:object{IgnisCollectorV2.OutputCumulator}
        (remover:string ats:string reward-token:string accounts-with-ats-data:[string])
        (require-capability (SECURE))
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                (ref-DALOS:module{OuronetDalosV5} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV6} DPTF)
                (ref-ATS:module{AutostakeV5} ATS)
                (ref-TFT:module{TrueFungibleTransferV8} TFT)
                (ats-sc:string (ref-ATS::GOV|ATS|SC_NAME))
                ;;
                (rt-lst:[string] (ref-ATS::UR_RewardTokenList ats))
                (remove-position:integer (at 0 (ref-U|LST::UC_Search rt-lst reward-token)))
                (primal-rt:string (at 0 rt-lst))
                (resident-sum:decimal (at remove-position (ref-ATS::UR_RewardTokenRUR ats 1)))
                (unbound-sum:decimal (at remove-position (ref-ATS::UR_RewardTokenRUR ats 2)))
                (remove-sum:decimal (+ resident-sum unbound-sum))
                ;;
                (ico1:object{IgnisCollectorV2.OutputCumulator}
                    (ref-IGNIS::UDC_ConstructOutputCumulator 
                        (ref-DALOS::UR_UsagePrice "ignis|token-issue") 
                        ATS|SC_NAME
                        (ref-IGNIS::URC_IsVirtualGasZero) 
                        []
                    )
                )
                (ico2:object{IgnisCollectorV2.OutputCumulator}
                    (ref-TFT::C_Transfer reward-token ATS|SC_NAME remover remove-sum true)
                )
                (ico3:object{IgnisCollectorV2.OutputCumulator}
                    (ref-TFT::C_Transfer primal-rt remover ATS|SC_NAME remove-sum true)
                )
            )
            ;;1]The RT to be removed, is transfered to the remover, from the ATS|SC_NAME
                ;via ico2
            ;;2]The amount removed is added back as Primal-RT
                ;via ico3
            ;;3]ROU Table is updated with the new DATA, now as primal RT
            (ref-ATS::XE_UpdateRUR ats primal-rt 1 true resident-sum)
            (ref-ATS::XE_UpdateRUR ats primal-rt 2 true unbound-sum)
            ;;4]Client Accounts are modified to remove the RT Token and update balances with Primal RT
            (map
                (lambda
                    (kontos:string)
                    (ref-ATS::XE_ReshapeUnstakeAccount ats kontos remove-position)
                )
                accounts-with-ats-data
            )
            ;;5]Actually Remove the RT from the ATS-Pair
            (ref-ATS::XE_RemoveSecondary ats reward-token)
            ;;6]Update Data in the DPTF Token Properties
            (ref-DPTF::XE_UpdateRewardToken ats reward-token false)
            ;;7]Output ICO
            (ref-IGNIS::UDC_ConcatenateOutputCumulators [ico1 ico2 ico3] [])
        )
    )
    ;;
)

;(create-table P|T)
;(create-table P|MT)