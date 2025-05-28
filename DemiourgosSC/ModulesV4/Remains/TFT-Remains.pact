;;Elite Exchanges
(defun C_EliteExchangeTFTF:object{OuronetDalosV3.OutputCumulatorV2}
    (tf1-id:string tf2-id:string sender:string smart-intermediary:string exchanged-amount:decimal)
    (UEV_IMC)
    (with-capability (DPTF|C>ELITE-EXCHANGE-TFTF tf1-id tf2-id sender smart-intermediary exchanged-amount)
        (XI_SimpleTransfer tf1-id sender smart-intermediary exchanged-amount true)
        (XI_SimpleTransfer tf2-id smart-intermediary sender exchanged-amount true)
        (UDC_EliteExchangeCumulator sender smart-intermediary 2)
    )
)
(defcap DPTF|C>ELITE-EXCHANGE-TFTF 
    (tf1-id:string tf2-id:string sender:string smart-intermediary:string exchanged-amount:decimal)
    @event
    (let
        (
            (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
            (sife1:bool (ref-DPTF::UR_AccountRoleFeeExemption tf1-id smart-intermediary))
            (sife2:bool (ref-DPTF::UR_AccountRoleFeeExemption tf2-id smart-intermediary))
        )
        ;;This enforcement encompasses the fact that the Smart Intermediary is a Smart Ouronet Account
        ;;Because only Smart Ouronet Accounts can have a <true> fee exception role
        (enforce-one
            "The Smart Intermediary must have TFE for at least one the TF-IDs"
            [
                (enforce sife1 (format "{} doesnt have Fee Exception Role for {}" [smart-intermediary tf1-id]))
                (enforce sife2 (format "{} doesnt have Fee Exception Role for {}" [smart-intermediary tf2-id]))
            ]
            
        )
        (UEV_DispoLocker tf1-id sender)
        (UEV_AreTrueFungiblesEliteAurynz tf1-id true)
        (UEV_AreTrueFungiblesEliteAurynz tf2-id true)
        (compose-capability (DPTF|C>X-TRANSFER tf1-id sender smart-intermediary exchanged-amount true))
        (compose-capability (DPTF|C>X-TRANSFER tf2-id smart-intermediary sender exchanged-amount true))
    )
)


;;OLD ARCHITECTURE
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    
    ;;{C2}
    ;;To REMOVE
    (defun UDCX_Pair_Receiver-Amount:[object{DPTF|Receiver-Amount}] 
        (receiver-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (receiver-length:integer (length receiver-lst))
                (amount-length:integer (length transfer-amount-lst))
            )
            (enforce (= receiver-length amount-length) "Receiver and Transfer-Amount Lists are not of equal length")
            (zip 
                (lambda 
                    (x:string y:decimal) 
                    { "receiver": x, "amount": y }
                ) 
                receiver-lst 
                transfer-amount-lst
            )
        )
    )
    ;;Multi
    (defun UDCX_Pair_ID-Amount:[object{DPTF|ID-Amount}]
        (id-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (id-length:integer (length id-lst))
                (amount-length:integer (length transfer-amount-lst))
            )
            (enforce (= id-length amount-length) "ID and Transfer-Amount Lists are not of equal length")
            (zip 
                (lambda 
                    (x:string y:decimal) 
                    { "id": x, "amount": y }
                ) 
                id-lst 
                transfer-amount-lst
            )
            (zip 
                (lambda 
                    (x:decimal y:decimal) 
                    { "id": x, "amount": y }
                ) 
                id-lst 
                transfer-amount-lst
            )
        )
    )
    (defcap DPTF|S>EA-DISPO-LOCKER (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ouro-amount:decimal (ref-DALOS::UR_TF_AccountSupply account true))
            )
            (enforce (not (< ouro-amount 0.0)) "When Account has negative OURO, Elite-Auryn is dispo-locked and cannot be moved")
        )
    )
    ;;{C3}
    ;;{C4}
    
    ;;
    (defcap DPTF|C>OLD-TRANSMUTE (id:string transmuter:string)
        @event
        (compose-capability (DPTF|C>X_TRANSMUTE id transmuter))
    )
    (defcap DPTF|C>X_TRANSMUTE (id:string transmuter:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
            )
            (if (= id ea-id)
                (compose-capability (DPTF|S>EA-DISPO-LOCKER transmuter))
                true
            )
            (compose-capability (P|SECURE-CALLER))
        )
    )
    ;;===============
    (defcap DPTF|C>TRANSFER (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
                (ats-sc:string (ref-DALOS::GOV|ATS|SC_NAME))
            )
            (ref-DALOS::CAP_EnforceAccountOwnership sender)
            (if (and method (ref-DALOS::UR_AccountType receiver))
                (ref-DALOS::CAP_EnforceAccountOwnership receiver)
                true
            )
            (ref-DPTF::UEV_Amount id transfer-amount)
            (if (not (ref-DPTF::URC_TrFeeMinExc id sender receiver))
                (ref-DPTF::UEV_EnforceMinimumAmount id transfer-amount)
                true
            )
            (ref-DALOS::UEV_EnforceTransferability sender receiver method)
            (ref-DPTF::UEV_PauseState id false)
            (ref-DPTF::UEV_AccountFreezeState id sender false)
            (ref-DPTF::UEV_AccountFreezeState id receiver false)
            (if
                (and
                    (> (ref-DPTF::UR_TransferRoleAmount id) 0)
                    (not (or (= sender ouroboros)(= sender dalos)))
                )
                (let
                    (
                        (s:bool (ref-DPTF::UR_AccountRoleTransfer id sender))
                        (r:bool (ref-DPTF::UR_AccountRoleTransfer id receiver))
                    )
                    (enforce-one
                        (format "Neither the sender {} nor the receiver {} have an active transfer role" [sender receiver])
                        [
                            (enforce (= s true) (format "TR doesnt check for sender {}" [sender]))
                            (enforce (= r true) (format "TR doesnt check for receiver {}" [receiver]))
                        ]

                    )
                )
                (format "No transfer restrictions for {} from {} to {}" [id sender receiver])
            )
            (compose-capability (DPTF|C>X_TRANSMUTE id sender))
        )
    )
    ;;  [Bulk-Transfer]
    (defcap DPTF|PACT|C>BULK-TRANSFER (id:string sender:string)
        @event
        (compose-capability (DPTF|C>X_TRANSMUTE id sender))
    )
    (defcap DPTF|C>BULK-TRANSFER (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @event
        (UEV_OLD_BulkTransfer id sender receiver-lst transfer-amount-lst method)
        (compose-capability (DPTF|C>X_TRANSMUTE id sender))
    )
    ;;  [Multi-Transfer]
    (defcap DPTF|PACT|C>MULTI-TRANSFER (id-lst:[string] sender:string)
        @event
        (compose-capability (DPTF|C>X_MULTI-TRANSFER id-lst sender))
    )
    (defcap DPTF|C>OLD-MULTI-TRANSFER (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @event
        (UEV_OLD_MultiTransfer id-lst sender receiver transfer-amount-lst method)
        (compose-capability (DPTF|C>X_MULTI-TRANSFER id-lst sender))
    )
    (defcap DPTF|C>X_MULTI-TRANSFER (id-lst:[string] sender:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ea-id:string (ref-DALOS::UR_EliteAurynID))
            )
            (map
                (lambda
                    (idx:integer)
                    (if (!= (at idx id-lst) ea-id)
                        (compose-capability (DPTF|S>EA-DISPO-LOCKER sender))
                        true
                    )
                )
                (enumerate 0 (- (length id-lst) 1))
            )
            (compose-capability (P|SECURE-CALLER))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    
    ;;{F1}  [URC]
    
    
    ;;{F2}  [UEV]
    ;;  [Bulk-Transfer]
    (defun UEV_OLD_BulkTransfer (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Complete Bulk Transfer Validations"
        (UEV_OLD_BulkTransferSingleData id sender)
        (UEV_OLD_BulkTransferMultiData id sender receiver-lst transfer-amount-lst method)
    )
    (defun UEV_OLD_BulkTransferSingleData (id:string sender:string)
        @doc "Bulk Transfer Validation for single Data"
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership sender)
            (ref-DPTF::UEV_PauseState id false)
            (ref-DPTF::UEV_AccountFreezeState id sender false)
        )
    )
    (defun UEV_OLD_BulkTransferMultiData (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        @doc "Bulk Transfer Validation for Multi Data"
        (UEVX_BulkTransferMapper (UDCX_Pair_Receiver-Amount receiver-lst transfer-amount-lst) sender id method)
    )
    (defun UEVX_BulkTransferMapper (ra-obj:[object{DPTF|Receiver-Amount}] sender:string id:string method:bool)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
                (tra:integer (ref-DPTF::UR_TransferRoleAmount id))
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
                (s:bool (ref-DPTF::UR_AccountRoleTransfer id sender))
                (l:integer (length ra-obj))
            )
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (receiver:string (at "receiver" (at idx ra-obj)))
                            (ta:decimal (at "amount" (at idx ra-obj)))
                            (r:bool (ref-DPTF::UR_AccountRoleTransfer id receiver))
                            (r-type:bool (ref-DALOS::UR_AccountType receiver))
                        )
                        (if
                            (and
                                (> tra 0)
                                (not (or (= sender ouroboros)(= sender dalos)))
                            )
                            (enforce-one
                                (format "Neither the sender {} nor the receiver {} have an active transfer role" [sender receiver])
                                [
                                    (enforce (= s true) (format "TR doesnt check for sender {}" [sender]))
                                    (enforce (= r true) (format "TR doesnt check for receiver {}" [receiver]))
                                ]

                            )
                            (format "No transfer restrictions for {} from {} to {}" [id sender receiver])
                        )
                        (ref-DALOS::UEV_EnforceTransferability sender receiver method)
                        (ref-DPTF::UEV_Amount id ta)
                        (ref-DPTF::UEV_AccountFreezeState id receiver false)
                        (ref-DPTF::UEV_EnforceMinimumAmount id ta)
                        (enforce (not r-type) "Bulk Transfer does not work to target Smart Dalos Account")
                    )
                )
                (enumerate 0 (- l 1))
            )
        )
    )
    ;;  [Multi-Transfer]
    (defun UEV_OLD_MultiTransfer (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        @doc "Complete Multi Transfer Validations"
        (UEV_OLD_MultiTransferSingleData sender receiver method)
        (UEV_OLD_MultiTransferMultiData id-lst sender receiver transfer-amount-lst)
    )
    (defun UEV_OLD_MultiTransferSingleData (sender:string receiver:string method:bool)
        @doc "Multi Transfer Validation for single Data"
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
                (r-type:bool (ref-DALOS::UR_AccountType receiver))
            )
            (ref-DALOS::CAP_EnforceAccountOwnership sender)
            (if (and method r-type)
                (ref-DALOS::CAP_EnforceAccountOwnership receiver)
                true
            )
            (ref-DALOS::UEV_EnforceTransferability sender receiver method)
        )
    )
    (defun UEV_OLD_MultiTransferMultiData (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal])
        @doc "Multi Transfer Validation for Multi Data"
        (UEVX_MultiTransferMapper (UDCX_Pair_ID-Amount id-lst transfer-amount-lst) sender receiver)
    )
    (defun UEVX_MultiTransferMapper (pid-obj:[object{DPTF|ID-Amount}] sender:string receiver:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
                (l:integer (length pid-obj))
                (ouroboros:string (ref-DALOS::GOV|OUROBOROS|SC_NAME))
                (dalos:string (ref-DALOS::GOV|DALOS|SC_NAME))
            )
            (map
                (lambda
                    (idx:integer)
                    (let
                        (
                            (id:string (at "id" (at idx pid-obj)))
                            (ta:decimal (at "amount" (at idx pid-obj)))
                            (tra:integer (ref-DPTF::UR_TransferRoleAmount id))
                            (s:bool (ref-DPTF::UR_AccountRoleTransfer id sender))
                            (r:bool (ref-DPTF::UR_AccountRoleTransfer id receiver))
                            (iz-exception:bool (ref-DPTF::URC_TrFeeMinExc id sender receiver))
                        )
                        (if
                            (and
                                (> tra 0)
                                (not (or (= sender ouroboros)(= sender dalos)))
                            )
                            (enforce-one
                                (format "Neither the sender {} nor the receiver {} have an active transfer role" [sender receiver])
                                [
                                    (enforce s (format "TR doesnt check for sender {}" [sender]))
                                    (enforce r (format "TR doesnt check for receiver {}" [receiver]))
                                ]
                            )
                            (format "No transfer restrictions for {} from {} to {}" [id sender receiver])
                        )
                        (if (not iz-exception)
                            (ref-DPTF::UEV_EnforceMinimumAmount id ta)
                            true
                        )
                        (ref-DPTF::UEV_Amount id ta)
                        (ref-DPTF::UEV_PauseState id false)
                        (ref-DPTF::UEV_AccountFreezeState id sender false)
                        (ref-DPTF::UEV_AccountFreezeState id receiver false)
                    )
                )
                (enumerate 0 (- l 1))
            )
        )
    )
    ;;{F3}  [UDC]
    
    
    
    (defun UDC_BulkTransferICO:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string transfer-amount-lst:[decimal] sender:string receiver-lst:[string])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (l:integer (length transfer-amount-lst))
                (folded-obj:[object{OuronetDalosV3.OutputCumulatorV2}]
                    (fold
                        (lambda
                            (acc:[object{OuronetDalosV3.OutputCumulatorV2}] idx:integer)
                            (let
                                (
                                    (transfer-amount:decimal (at idx transfer-amount-lst))
                                    (receiver:string (at idx receiver-lst))
                                    (ico:object{OuronetDalosV3.OutputCumulatorV2}
                                        (ref-DALOS::UDC_TFTCumulatorV2 id sender receiver transfer-amount)
                                    )
                                )
                                (ref-U|LST::UC_AppL acc ico)
                            )
                        )
                        []
                        (enumerate 0 (- l 1))
                    )
                )
            )
            (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 folded-obj [])
        )
    )
    (defun UDC_MultiTransferICO:object{OuronetDalosV3.OutputCumulatorV2}
        (id-lst:[string] transfer-amount-lst:[decimal] sender:string receiver:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (l:integer (length transfer-amount-lst))
                (folded-obj:[object{OuronetDalosV3.OutputCumulatorV2}]
                    (fold
                        (lambda
                            (acc:[object{OuronetDalosV3.OutputCumulatorV2}] idx:integer)
                            (let
                                (
                                    (id:string (at idx id-lst))
                                    (transfer-amount:decimal (at idx transfer-amount-lst))
                                    (ico:object{OuronetDalosV3.OutputCumulatorV2}
                                        (ref-DALOS::UDC_TFTCumulatorV2 id sender receiver transfer-amount)
                                    )
                                )
                                (ref-U|LST::UC_AppL acc ico)
                            )
                        )
                        []
                        (enumerate 0 (- l 1))
                    )
                )
            )
            (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 folded-obj [])
        )
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    
    ;;  [Transmute]
    (defun C_OLD_Transmute:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string transmuter:string transmute-amount:decimal)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
            )
            (with-capability (DPTF|C>OLD-TRANSMUTE id transmuter)
                (XI_OLD_Transmute id transmuter transmute-amount)
                (ref-DPMF::XB_UpdateEliteSingle id transmuter)
                (ref-DALOS::UDC_ConstructOutputCumulatorV2 
                    (ref-DALOS::UR_UsagePrice "ignis|smallest")
                    transmuter
                    (ref-DALOS::IGNIS|URC_ZeroGAS id transmuter)
                    []
                )
            )
        )
    )
    ;;  [Transfer]
    (defun C_OLD_Transfer:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
            )
            (with-capability (DPTF|C>TRANSFER id sender receiver transfer-amount method)
                (XI_Transfer id sender receiver transfer-amount method)
                (ref-DALOS::UDC_TFTCumulatorV2 id sender receiver transfer-amount)
            )
        )
    )
    (defun C_ExemptionTransfer:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
            )
            (with-capability (DPTF|C>TRANSFER id sender receiver transfer-amount method)
                (XI_ExemptionTransfer id sender receiver transfer-amount method)
                (ref-DALOS::UDC_TFTCumulatorV2 id sender receiver transfer-amount)
            )
        )
    )
    (defun XB_FeelesTransfer:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (UEV_IMC)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
            )
            (with-capability (DPTF|C>TRANSFER id sender receiver transfer-amount method)
                (XI_OLD_SimpleTransfer id sender receiver transfer-amount method)
                (ref-DALOS::UDC_TFTCumulatorV2 id sender receiver transfer-amount)
            )
        )
    )
    ;;  [Multi-Transfer]
    (defun C_MultiTransferAsPactStep (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        (require-capability (SECURE))
        (with-capability (DPTF|PACT|C>MULTI-TRANSFER id-lst sender)
            (map (lambda (x:object{DPTF|ID-Amount}) (XIH_MultiTransfer sender receiver x method)) (UDCX_Pair_ID-Amount id-lst transfer-amount-lst))
        )
    )
    (defun C_OLD_MultiTransfer:object{OuronetDalosV3.OutputCumulatorV2}
        (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        (UEV_IMC)
        (with-capability (DPTF|C>OLD-MULTI-TRANSFER id-lst sender receiver transfer-amount-lst method)
            (map (lambda (x:object{DPTF|ID-Amount}) (XIH_MultiTransfer sender receiver x method)) (UDCX_Pair_ID-Amount id-lst transfer-amount-lst))
            (UDC_MultiTransferICO id-lst transfer-amount-lst sender receiver)
        )
    )
    (defun C_ExemptionMultiTransfer:object{OuronetDalosV3.OutputCumulatorV2}
        (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        (UEV_IMC)
        (with-capability (DPTF|C>OLD-MULTI-TRANSFER id-lst sender receiver transfer-amount-lst method)
            (map (lambda (x:object{DPTF|ID-Amount}) (XIH_ExemptionMultiTransfer sender receiver x method)) (UDCX_Pair_ID-Amount id-lst transfer-amount-lst))
            (UDC_MultiTransferICO id-lst transfer-amount-lst sender receiver)
        )
    )
    (defun XE_FeelesMultiTransfer:object{OuronetDalosV3.OutputCumulatorV2}
        (id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        (UEV_IMC)
        (with-capability (DPTF|C>OLD-MULTI-TRANSFER id-lst sender receiver transfer-amount-lst method)
            (map (lambda (x:object{DPTF|ID-Amount}) (XIH_FeelesMultiTransfer sender receiver x method)) (UDCX_Pair_ID-Amount id-lst transfer-amount-lst))
            (UDC_MultiTransferICO id-lst transfer-amount-lst sender receiver)
        )
    )
    ;;  [Bulk-Transfer]
    (defun C_BulkTransferAsPactStep (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        (require-capability (SECURE))
        (with-capability (DPTF|PACT|C>BULK-TRANSFER id sender)
            (map (lambda (x:object{DPTF|Receiver-Amount}) (XIH_BulkTransfer id sender x method)) (UDCX_Pair_Receiver-Amount receiver-lst transfer-amount-lst))
        )
    )
    (defun C_OLD_BulkTransfer:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        (UEV_IMC)
        (with-capability (DPTF|C>BULK-TRANSFER id sender receiver-lst transfer-amount-lst method)
            (map (lambda (x:object{DPTF|Receiver-Amount}) (XIH_BulkTransfer id sender x method)) (UDCX_Pair_Receiver-Amount receiver-lst transfer-amount-lst))
            (UDC_BulkTransferICO id transfer-amount-lst sender receiver-lst)
        )
    )
    (defun C_ExemptionBulkTransfer:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        (UEV_IMC)
        (with-capability (DPTF|C>BULK-TRANSFER id sender receiver-lst transfer-amount-lst method)
            (map (lambda (x:object{DPTF|Receiver-Amount}) (XIH_ExemptionBulkTransfer id sender x method)) (UDCX_Pair_Receiver-Amount receiver-lst transfer-amount-lst))
            (UDC_BulkTransferICO id transfer-amount-lst sender receiver-lst)
        )
    )
    (defun XE_FeelesBulkTransfer:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        (UEV_IMC)
        (with-capability (DPTF|C>BULK-TRANSFER id sender receiver-lst transfer-amount-lst method)
            (map (lambda (x:object{DPTF|Receiver-Amount}) (XIH_FeelesBulkTransfer id sender x method)) (UDCX_Pair_Receiver-Amount receiver-lst transfer-amount-lst))
            (UDC_BulkTransferICO id transfer-amount-lst sender receiver-lst)
        )
    )
    ;;
    (defun PS|C_BulkTransfer81-160
        (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        (UEV_IMC)
        (C_BulkTransfer81-160 patron id sender receiver-lst transfer-amount-lst method)
    )
    (defun PS|C_BulkTransfer41-80
        (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        (UEV_IMC)
        (C_BulkTransfer41-80 patron id sender receiver-lst transfer-amount-lst method)
    )
    (defun PS|C_BulkTransfer13-40
        (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        (UEV_IMC)
        (C_BulkTransfer13-40 patron id sender receiver-lst transfer-amount-lst method)
    )
    (defun PS|C_MultiTransfer41-80
        (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        (UEV_IMC)
        (C_MultiTransfer41-80 patron id-lst sender receiver transfer-amount-lst method)
    )
    (defun PS|C_MultiTransfer13-40
        (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        (UEV_IMC)
        (C_MultiTransfer13-40 patron id-lst sender receiver transfer-amount-lst method)
    )
    ;;{F7}  [X]
    (defun XI_OLD_Transmute (id:string transmuter:string transmute-amount:decimal)
        (require-capability (DPTF|C>OLD-TRANSMUTE id transmuter))
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
                (dispo-data:object{UtilityDptf.DispoData} (UDC_GetDispoData transmuter))
            )
            (ref-DPTF::XB_DebitStandard id transmuter transmute-amount dispo-data)
            (XI_CreditPrimaryFee id transmute-amount false)
        )
    )
    (defun XI_Transfer (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
                (fee-toggle:bool (ref-DPTF::UR_FeeToggle id))
                (iz-exception:bool (ref-DPTF::URC_TrFeeMinExc id sender receiver))
                (iz-full-credit:bool
                    (or
                        (= fee-toggle false)
                        (= iz-exception true)
                    )
                )
            )
            (if iz-full-credit
                (XI_OLD_SimpleTransfer id sender receiver transfer-amount method)
                ( XI_OLD_ComplexTransfer id sender receiver transfer-amount method)
            )
        )
    )
    (defun XI_ExemptionTransfer (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
                (sender-fee-exemption:bool (ref-DPTF::UR_AccountRoleFeeExemption id sender))
                (receiver-fee-exemption:bool (ref-DPTF::UR_AccountRoleFeeExemption id receiver))
                (iz-exception:bool (or sender-fee-exemption receiver-fee-exemption))
            )
            (if iz-exception
                (XI_OLD_SimpleTransfer id sender receiver transfer-amount method)
                true
            )
        )
    )
    (defun XI_OLD_SimpleTransfer (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (dispo-data:object{UtilityDptf.DispoData} (UDC_GetDispoData sender))
            )
            (ref-DPTF::XB_DebitStandard id sender transfer-amount dispo-data)
            (ref-DPTF::XB_Credit id receiver transfer-amount)
            (ref-DPMF::XB_UpdateElite id sender receiver)
        )
    )
    (defun  XI_OLD_ComplexTransfer (id:string sender:string receiver:string transfer-amount:decimal method:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
                (ref-DPMF:module{DemiourgosPactMetaFungibleV4} DPMF)
                (dispo-data:object{UtilityDptf.DispoData} (UDC_GetDispoData sender))
            )
            (ref-DPTF::XB_DebitStandard id sender transfer-amount dispo-data)
            (XI_ComplexCredit id receiver transfer-amount)
            (ref-DPMF::XB_UpdateElite id sender receiver)
        )
    )
    ;;TransferV2

    ;;  [Aux Multi-Transfer]
    (defun XIH_MultiTransfer (sender:string receiver:string id-amount-pair:object{DPTF|ID-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (id:string (at "id" id-amount-pair))
                (amount:decimal (at "amount" id-amount-pair))
            )
            (XI_Transfer id sender receiver amount method)
        )
    )
    (defun XIH_ExemptionMultiTransfer (sender:string receiver:string id-amount-pair:object{DPTF|ID-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (id:string (at "id" id-amount-pair))
                (amount:decimal (at "amount" id-amount-pair))
            )
            (XI_ExemptionTransfer id sender receiver amount method)
        )
    )
    (defun XIH_FeelesMultiTransfer (sender:string receiver:string id-amount-pair:object{DPTF|ID-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (id:string (at "id" id-amount-pair))
                (amount:decimal (at "amount" id-amount-pair))
            )
            (XI_OLD_SimpleTransfer id sender receiver amount method)
        )
    )
    ;;  [Aux Bulk-Transfer]
    (defun XIH_BulkTransfer (id:string sender:string receiver-amount-pair:object{DPTF|Receiver-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (receiver:string (at "receiver" receiver-amount-pair))
                (amount:decimal (at "amount" receiver-amount-pair))
            )
            (XI_Transfer id sender receiver amount method)
        )
    )
    (defun XIH_ExemptionBulkTransfer (id:string sender:string receiver-amount-pair:object{DPTF|Receiver-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (receiver:string (at "receiver" receiver-amount-pair))
                (amount:decimal (at "amount" receiver-amount-pair))
            )
            (XI_ExemptionTransfer id sender receiver amount method)
        )
    )
    (defun XIH_FeelesBulkTransfer (id:string sender:string receiver-amount-pair:object{DPTF|Receiver-Amount} method:bool)
        (require-capability (SECURE))
        (let
            (
                (receiver:string (at "receiver" receiver-amount-pair))
                (amount:decimal (at "amount" receiver-amount-pair))
            )
            (XI_OLD_SimpleTransfer id sender receiver amount method)
        )
    )
    
    ;;{F8}  [P]
    ;;  [Extended Bulk-Transfer]
    (defun P_BulkTransferIgnisCollecter
        (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
            )
            (ref-DALOS::IGNIS|C_Collect patron
                (UDC_BulkTransferICO id transfer-amount-lst sender receiver-lst)
            )
        )
    )
    (defpact C_BulkTransfer81-160
        (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        ;;Steps 0|1|2|3 Validation in 4 Steps
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (UEV_OLD_BulkTransfer
                    id sender
                    (take v0 receiver-lst)
                    (take v0 transfer-amount-lst)
                    method
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                )
                (UEV_OLD_BulkTransfer
                    id sender
                    (take v1 (drop v0 receiver-lst))
                    (take v1 (drop v0 transfer-amount-lst))
                    method
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (+ v0 v1))
                )
                (UEV_OLD_BulkTransfer
                    id sender
                    (take v2 (drop v3 receiver-lst))
                    (take v2 (drop v3 transfer-amount-lst))
                    method
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v:integer (fold (+) 0 (drop -1 matrix)))
                )
                (UEV_OLD_BulkTransfer
                    id sender
                    (drop v receiver-lst)
                    (drop v transfer-amount-lst)
                    method
                )
            )
        )
        ;;Step 4 Collects the required IGNIS
        (step
            (P_BulkTransferIgnisCollecter patron id sender receiver-lst transfer-amount-lst)
        )
        ;;Step 5|6|7|8|9|10|11|12 BulkTransfer
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep
                        id sender
                        (take v0 receiver-lst)
                        (take v0 transfer-amount-lst)
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep
                        id sender
                        (take v1 (drop v0 receiver-lst))
                        (take v1 (drop v0 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (+ v0 v1))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep
                        id sender
                        (take v2 (drop v3 receiver-lst))
                        (take v2 (drop v3 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (at 3 matrix))
                    (v4:integer (fold (+) 0 [v0 v1 v2]))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep
                        id sender
                        (take v3 (drop v4 receiver-lst))
                        (take v3 (drop v4 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (at 3 matrix))
                    (v4:integer (at 4 matrix))
                    (v5:integer (fold (+) 0 [v0 v1 v2 v3]))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep
                        id sender
                        (take v4 (drop v5 receiver-lst))
                        (take v4 (drop v5 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (at 3 matrix))
                    (v4:integer (at 4 matrix))
                    (v5:integer (at 5 matrix))
                    (v6:integer (fold (+) 0 [v0 v1 v2 v3 v4]))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep
                        id sender
                        (take v5 (drop v6 receiver-lst))
                        (take v5 (drop v6 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (at 3 matrix))
                    (v4:integer (at 4 matrix))
                    (v5:integer (at 5 matrix))
                    (v6:integer (at 6 matrix))
                    (v7:integer (fold (+) 0 [v0 v1 v2 v3 v4 v5]))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep
                        id sender
                        (take v6 (drop v7 receiver-lst))
                        (take v6 (drop v7 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_EightSplitter l))
                    (v:integer (fold (+) 0 (drop -1 matrix)))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep
                        id sender
                        (drop v receiver-lst)
                        (drop v transfer-amount-lst)
                        method
                    )
                )
            )
        )
    )
    (defpact C_BulkTransfer41-80
        (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        ;;Steps 0|1 Validation in 2 Steps
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (UEV_OLD_BulkTransfer
                    id sender
                    (take v0 receiver-lst)
                    (take v0 transfer-amount-lst)
                    method
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v1:integer (at 1 matrix))
                )
                (UEV_OLD_BulkTransfer
                    id sender
                    (drop v1 receiver-lst)
                    (drop v1 transfer-amount-lst)
                    method
                )
            )
        )
        ;;Step 2 Collects the required IGNIS
        (step
            (P_BulkTransferIgnisCollecter patron id sender receiver-lst transfer-amount-lst)
        )
        ;;Step 3|4|5|6 BulkTransfer
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep
                        id sender
                        (take v0 receiver-lst)
                        (take v0 transfer-amount-lst)
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep
                        id sender
                        (take v1 (drop v0 receiver-lst))
                        (take v1 (drop v0 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (+ v0 v1))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep
                        id sender
                        (take v2 (drop v3 receiver-lst))
                        (take v2 (drop v3 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v:integer (fold (+) 0 (drop -1 matrix)))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep
                        id sender
                        (drop v receiver-lst)
                        (drop v transfer-amount-lst)
                        method
                    )
                )
            )
        )
    )
    (defpact C_BulkTransfer13-40
        (patron:string id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal] method:bool)
        ;;Steps 0 Validation in 1 Step
        (step
            (UEV_OLD_BulkTransfer id sender receiver-lst transfer-amount-lst method)
        )
        ;;Step 1 Collects the required IGNIS
        (step
            (P_BulkTransferIgnisCollecter patron id sender receiver-lst transfer-amount-lst)
        )
        ;;Step 2|3 BulkTransfer
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep
                        id sender
                        (take v0 receiver-lst)
                        (take v0 transfer-amount-lst)
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v1:integer (at 1 matrix))
                )
                (with-capability (SECURE)
                    (C_BulkTransferAsPactStep
                        id sender
                        (drop v1 receiver-lst)
                        (drop v1 transfer-amount-lst)
                        method
                    )
                )
            )
        )
    )
    ;;  [Extended Multi-Transfer]
    (defun P_MultiTransferIgnisCollecter
        (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal])
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
            )
            (ref-DALOS::IGNIS|C_Collect patron
                (UDC_MultiTransferICO id-lst transfer-amount-lst sender receiver)
            )
        )
    )
    (defpact C_MultiTransfer41-80
        (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        ;;Steps 0|1 Validation in 2 Steps
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (UEV_OLD_MultiTransfer
                    (take v0 id-lst)
                    sender receiver
                    (take v0 transfer-amount-lst)
                    method
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v1:integer (at 1 matrix))
                )
                (UEV_OLD_MultiTransfer
                    (drop v1 id-lst)
                    sender receiver
                    (drop v1 transfer-amount-lst)
                    method
                )
            )
        )
        ;;Step 2 Collects the required IGNIS
        (step
            (P_MultiTransferIgnisCollecter patron id-lst sender receiver transfer-amount-lst)
        )
        ;;Step 3|4|5|6 BulkTransfer
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (with-capability (SECURE)
                    (C_MultiTransferAsPactStep
                        (take v0 id-lst)
                        sender receiver
                        (take v0 transfer-amount-lst)
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                )
                (with-capability (SECURE)
                    (C_MultiTransferAsPactStep
                        (take v1 (drop v0 id-lst))
                        sender receiver
                        (take v1 (drop v0 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v0:integer (at 0 matrix))
                    (v1:integer (at 1 matrix))
                    (v2:integer (at 2 matrix))
                    (v3:integer (+ v0 v1))
                )
                (with-capability (SECURE)
                    (C_MultiTransferAsPactStep
                        (take v2 (drop v3 id-lst))
                        sender receiver
                        (take v2 (drop v3 transfer-amount-lst))
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_FourSplitter l))
                    (v:integer (fold (+) 0 (drop -1 matrix)))
                )
                (with-capability (SECURE)
                    (C_MultiTransferAsPactStep
                        (drop v id-lst)
                        sender receiver
                        (drop v transfer-amount-lst)
                        method

                    )
                )
            )
        )
    )
    (defpact C_MultiTransfer13-40
        (patron:string id-lst:[string] sender:string receiver:string transfer-amount-lst:[decimal] method:bool)
        ;;Steps 0 Validation in 1 Step
        (step
            (UEV_OLD_MultiTransfer id-lst sender receiver transfer-amount-lst method)
        )
        ;;Step 1 Collects the required IGNIS
        (step
            (P_MultiTransferIgnisCollecter patron id-lst sender receiver transfer-amount-lst)
        )
        ;;Step 2|3 BulkTransfer
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v0:integer (at 0 matrix))
                )
                (with-capability (SECURE)
                    (C_MultiTransferAsPactStep
                        (take v0 id-lst)
                        sender receiver
                        (take v0 transfer-amount-lst)
                        method
                    )
                )
            )
        )
        (step
            (let
                (
                    (ref-U|DPTF:module{UtilityDptf} U|DPTF)
                    (l:integer (length transfer-amount-lst))
                    (matrix:[integer] (ref-U|DPTF::UC_TwoSplitter l))
                    (v1:integer (at 1 matrix))
                )
                (with-capability (SECURE)
                    (C_MultiTransferAsPactStep
                        (drop v1 id-lst)
                        sender receiver
                        (drop v1 transfer-amount-lst)
                        method
                    )
                )
            )
        )
    )
    ;;
    (defun UDC_UnityBulkTransferCumulator:object{OuronetDalosV3.OutputCumulatorV2}
        (id:string sender:string receiver-lst:[string] transfer-amount-lst:[decimal])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (l:integer (length receiver-lst))
                (folded-obj:[object{OuronetDalosV3.OutputCumulatorV2}]
                    (fold
                        (lambda
                            (acc:[object{OuronetDalosV3.OutputCumulatorV2}] idx:integer)
                            (let
                                (
                                    (transfer-amount:decimal (at idx transfer-amount-lst))
                                    (receiver:string (at idx receiver-lst))
                                    (ico:object{OuronetDalosV3.OutputCumulatorV2}
                                        (UDC_UnityTransferCumulator id sender receiver transfer-amount)
                                    )
                                )
                                (ref-U|LST::UC_AppL acc ico)
                            )
                        )
                        []
                        (enumerate 0 (- l 1))
                    )
                )
            )
            (ref-DALOS::UDC_ConcatenateOutputCumulatorsV2 folded-obj [])
        )
    )