(interface DeployerReadsV2
    ;;
    (defun UC_ConvertPrice:string (input-price:decimal))
    (defun UC_FormatIndex:string (index:decimal))
    (defun UC_FormatTokenAmount:string (amount:decimal))
    ;;
    (defun URC_PrimordialIDs:[string] ())
    (defun URC_PrimordialPrices:[decimal] ())
    (defun URC_KadenaCollectionReceivers:[string] ())
    (defun URC_SplitKdaPriceForReceivers (price:decimal))
    ;;
    (defun URC_0001_Header (account:string))
    (defun URC_0002_Primordials (account:string))
    ;;
    (defun DALOS|URC_DeployStandardAccount:list ())
    (defun DALOS|URC_DeploySmartAccount:list ())
)
(module DPL-UR GOV
    ;;
    (implements DeployerReadsV2)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPL-UR                 (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DPL_UR_ADMIN)))
    (defcap GOV|DPL_UR_ADMIN ()             (enforce-guard GOV|MD_DPL-UR))
    ;;{G3}
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    ;;{P3}
    ;;{P4}
    ;;
    ;;<======================>
    ;;SCHEMAS-TABLES-CONSTANTS
    ;;{1}
    

    ;;{2}
    ;;{3}
    (defun CT_Bar ()                        (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                           (CT_Bar))
    ;;
    ;;<==========>
    ;;CAPABILITIES
    ;;{C1}
    ;;{C2}
    ;;{C3}
    ;;{C4}
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_ConvertPrice:string (input-price:decimal)
        (let
            (
                (number-of-decimals:integer (if (<= input-price 1.00) 3 2))
                (converted:decimal
                    (if (< input-price 1.00)
                        (floor (* input-price 100.0) 3)
                        (floor input-price 2)
                    )
                )
                (s:string
                    (if (< input-price 1.00)
                        "¢"
                        "$"
                    )
                )
                (ss:string "<0.001¢")
            )
            (if (< input-price 0.00001)
                (format "{}" [ss])
                (format "{}{}" [converted s])    
            )
        )
    )
    (defun UC_FormatIndex:string (index:decimal)
        (let
            (
                (fi:decimal (floor index 12))
                (fis:string (format "{}" [fi]))
                (l1:string (take -3 fis))
                (l2:string (take -3 (drop -3 fis)))
                (l3:string (take -3 (drop -6 fis)))
                (l4:string (take -3 (drop -9 fis)))
                (whole:string (drop -13 fis))
            )
            (concat
                [whole ",[" l4 "." l3 "." l2 "." l1 "]"]
            )
        )
    )
    (defun UC_FormatTokenAmount:string (amount:decimal)
        (format "{}" [(floor amount 4)])
    )
    ;;{F0}  [UR]
    (defun URC_TrueFungibleAmountPrice:decimal (id:string amount:decimal price:decimal)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (idp:integer (ref-DPTF::UR_Decimals id))
            )
            (floor (* amount price) idp)
        )
    )
    (defun URC_PrimordialIDs:[string] ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ouro:string (ref-DALOS::UR_OuroborosID))
                (ignis:string (ref-DALOS::UR_IgnisID))
                (auryn:string (ref-DALOS::UR_AurynID))
                (elite-auryn:string (ref-DALOS::UR_EliteAurynID))
                (wkda:string (ref-DALOS::UR_WrappedKadenaID))
                (lkda:string (ref-DALOS::UR_LiquidKadenaID))
            )
            [ouro ignis auryn elite-auryn wkda lkda]
        )
    )
    (defun URC_PrimordialPrices:[decimal] ()
        @doc "Returns the Prices for Ouronet Primordial Tokens \
        \ [WKDA LKDA OURO AURYN ELITEAURYN]"
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-ATS:module{AutostakeV3} ATS)
                (ref-DSP:module{DeployerDispenserV4} DSP)
                ;;
                (p-ids:[string] (URC_PrimordialIDs))
                (ouro:string (at 0 p-ids))
                (ignis:string (at 1 p-ids))
                (auryn:string (at 2 p-ids))
                (elite-auryn:string (at 3 p-ids))
                (wkda:string (at 4 p-ids))
                (lkda:string (at 5 p-ids))
                ;;

                (wkda:string (ref-DALOS::UR_WrappedKadenaID))
                (lkda:string (ref-DALOS::UR_LiquidKadenaID))
                (ouro:string (ref-DALOS::UR_OuroborosID))
                (auryn:string (ref-DALOS::UR_AurynID))
                (elite-auryn:string (ref-DALOS::UR_EliteAurynID))

                (auryndex:string (at 0 (ref-DPTF::UR_RewardBearingToken auryn)))
                (elite-auryndex:string (at 0 (ref-DPTF::UR_RewardBearingToken elite-auryn)))
                (auryndex-value:decimal (ref-ATS::URC_Index auryndex))
                (elite-auryndex-value:decimal (ref-ATS::URC_Index elite-auryndex))
                ;;
                (dollar-ouro:decimal (ref-DSP::URC_TokenDollarPrice ouro))
                (dollar-ignis:decimal 0.01)
                (dollar-auryn:decimal (floor (* auryndex-value dollar-ouro) 24))
                (dollar-elite-auryn:decimal (floor (* elite-auryndex-value dollar-auryn) 24))
                (dollar-wkda:decimal (ref-DSP::URC_TokenDollarPrice wkda))
                (dollar-lkda:decimal (ref-DSP::URC_TokenDollarPrice lkda))
            )
            [dollar-ouro dollar-ignis dollar-auryn dollar-elite-auryn dollar-wkda dollar-lkda]
        )
    )
    (defun URC_KadenaCollectionReceivers:[string] ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (r1:string (ref-DALOS::UR_AccountKadena (at 2 (ref-DALOS::UR_DemiurgoiID))))
                (r2:string (ref-DALOS::UR_AccountKadena (ref-DALOS::GOV|DALOS|SC_NAME)))
                (r3:string (ref-DALOS::UR_AccountKadena (at 1 (ref-DALOS::UR_DemiurgoiID))))
                (r4:string (ref-DALOS::UR_AccountKadena (ref-DALOS::GOV|OUROBOROS|SC_NAME)))
            )
            [r1 r2 r3 r4]
        )
    )
    (defun URC_SplitKdaPriceForReceivers (price:decimal)
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (kp:integer (ref-U|CT::CT_KDA_PRECISION))
                (receivers:[string] (URC_KadenaCollectionReceivers))
                (prices:[decimal] (ref-U|DALOS::UC_TenTwentyThirtyFourtySplit price kp))
            )
            {"10%-r"    : (at 0 receivers)
            ,"20%-r"    : (at 1 receivers)
            ,"30%-r"    : (at 2 receivers)
            ,"40%-r"    : (at 3 receivers)
            ,"10%-p"    : (at 0 prices)
            ,"20%-p"    : (at 1 prices)
            ,"30%-p"    : (at 2 prices)
            ,"40%-p"    : (at 3 prices)}
        )
    )
    ;;
    (defun URC_0001_Header (account:string)
        (let
            (
                (ref-coin:module{fungible-v2} coin)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-ATS:module{AutostakeV3} ATS)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                (ref-ORBR:module{OuroborosV3} OUROBOROS)
                ;;
                (payment-key:string (ref-DALOS::UR_AccountKadena account))
                (payment-key-kda:decimal (try 0.0 (ref-coin::get-balance payment-key)))
                ;;
                (pp:[decimal] (URC_PrimordialPrices))
                (p-ids:[string] (URC_PrimordialIDs))
                (ouro:string (at 0 p-ids))
                (ignis:string (at 1 p-ids))
                (auryn:string (at 2 p-ids))
                (elite-auryn:string (at 3 p-ids))
                (wkda:string (at 4 p-ids))
                (lkda:string (at 5 p-ids))
                ;;
                (p0:decimal (at 0 pp))
                (p1:decimal (at 1 pp))
                (p2:decimal (at 2 pp))
                (p3:decimal (at 3 pp))
                (p4:decimal (at 4 pp))
                (p5:decimal (at 5 pp))
                ;;
                (wallet-wkda-supply:decimal (ref-DPTF::UR_AccountSupply wkda account))
                (wallet-lkda-supply:decimal (ref-DPTF::UR_AccountSupply lkda account))
                (global-wkda-supply:decimal (ref-DPTF::UR_Supply wkda))
                (global-lkda-supply:decimal (ref-DPTF::UR_Supply lkda))
                ;;
                (wallet-ouro:decimal (ref-DPTF::UR_AccountSupply ouro account))
                (wallet-vouro:decimal (ref-TFT::URC_VirtualOuro account))
                (wallet-ignis:decimal (ref-DPTF::UR_AccountSupply ignis account))
                ;;
                (auryndex:string (at 0 (ref-DPTF::UR_RewardBearingToken auryn)))
                (elite-auryndex:string (at 0 (ref-DPTF::UR_RewardBearingToken elite-auryn)))
                ;;
                (auryndex-value:decimal (ref-ATS::URC_Index auryndex))
                (elite-auryndex-value:decimal (ref-ATS::URC_Index elite-auryndex))
                (projected-kda:[decimal] (ref-ORBR::URC_ProjectedKdaLiquindex))

            )
            {"ouro-price-display"               : (UC_ConvertPrice p0)
            ,"ignis-price-display"              : (UC_ConvertPrice p1)
            ,"auryn-price-display"              : (UC_ConvertPrice p2)
            ,"elite-auryn-price-display"        : (UC_ConvertPrice p3)
            ,"wkda-price-display"               : (UC_ConvertPrice p4)
            ,"lkda-price-display"               : (UC_ConvertPrice p5)
            ;;
            ,"wallet-wkda-supply-display"       : (UC_FormatTokenAmount wallet-wkda-supply)
            ,"wallet-lkda-supply-display"       : (UC_FormatTokenAmount wallet-lkda-supply)
            ,"global-wkda-supply-display"       : (UC_FormatTokenAmount global-wkda-supply)
            ,"global-lkda-supply-display"       : (UC_FormatTokenAmount global-lkda-supply)
            ;;
            ,"auryndex-display"                 : (UC_FormatIndex auryndex-value)
            ,"eauryndex-display"                : (UC_FormatIndex elite-auryndex-value)
            ,"liquid-display"                   : (UC_FormatIndex (at 0 projected-kda))
            ,"projected-liquid-display"         : (UC_FormatIndex (at 1 projected-kda))
            ,"standby-index-kda-display"        : (UC_FormatTokenAmount (at 2 projected-kda))
            ;;
            ,"wallet-ouro-display"              : (UC_FormatTokenAmount wallet-ouro)
            ,"wallet-vouro-display"             : (UC_FormatTokenAmount wallet-vouro)
            ,"wallet-ignis-display"             : (UC_FormatTokenAmount wallet-ignis)
            ;;
            ,"elite-name"                       : (ref-DALOS::UR_Elite-Name account)
            ,"elite-tier"                       : (ref-DALOS::UR_Elite-Tier account)
            ,"kda"                              : (UC_FormatTokenAmount payment-key-kda)
            ,"kda-hover"                        : payment-key-kda
            ;;
            ;;
            ,"ouro-price-hover"                 : p0
            ,"ignis-price-hover"                : p1
            ,"auryn-price-hover"                : p2
            ,"elite-auryn-price-hover"          : p3
            ,"wkda-price-hover"                 : p4
            ,"lkda-price-hover"                 : p5
            ;;
            ,"wallet-wkda-supply-hover"         : wallet-wkda-supply
            ,"wallet-lkda-supply-hover"         : wallet-lkda-supply
            ,"global-wkda-supply-hover"         : global-wkda-supply
            ,"global-wkda-supply-hover"         : global-wkda-supply
            ;;
            ,"auryndex-hover"                   : auryndex-value
            ,"eauryndex-hover"                  : elite-auryndex-value
            ,"liquid-hover"                     : (at 0 projected-kda)
            ,"projected-liquid-hover"           : (at 1 projected-kda)
            ,"standby-index-kda-hover"          : (at 2 projected-kda)
            ;;
            ,"wallet-ouro-hover"                : (UC_FormatTokenAmount wallet-ouro)
            ,"wallet-vouro-hover"               : (UC_FormatTokenAmount wallet-vouro)
            ,"wallet-ignis-hover"               : (UC_FormatTokenAmount wallet-ignis)
            }
        )
    )
    (defun URC_0002_Primordials (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-ATS:module{AutostakeV3} ATS)
                (ref-TFT:module{TrueFungibleTransferV6} TFT)
                ;;
                (p-ids:[string] (URC_PrimordialIDs))
                (ouro:string (at 0 p-ids))
                (ignis:string (at 1 p-ids))
                (auryn:string (at 2 p-ids))
                (elite-auryn:string (at 3 p-ids))
                (wkda:string (at 4 p-ids))
                (lkda:string (at 5 p-ids))
                ;;
                (pp:[decimal] (URC_PrimordialPrices))
                (p0:decimal (at 0 pp))
                (p1:decimal (at 1 pp))
                (p2:decimal (at 2 pp))
                (p3:decimal (at 3 pp))
                (p4:decimal (at 4 pp))
                (p5:decimal (at 5 pp))
                ;;
                (ouro-supply:decimal (ref-DPTF::UR_Supply ouro))
                (wallet-ouro:decimal (ref-DPTF::UR_AccountSupply ouro account))
                (wallet-ouro-value:decimal (URC_TrueFungibleAmountPrice ouro wallet-ouro p0))
                (wallet-vouro:decimal (ref-TFT::URC_VirtualOuro account))
                (wallet-vouro-value:decimal (URC_TrueFungibleAmountPrice ouro wallet-vouro p0))
                ;;
                (ignis-supply:decimal (ref-DPTF::UR_Supply ignis))
                (wallet-ignis:decimal (ref-DPTF::UR_AccountSupply ignis account))
                (wallet-ignis-value:decimal (URC_TrueFungibleAmountPrice ignis wallet-ignis p1))
                (ignis-discount:decimal (ref-DALOS::URC_IgnisGasDiscount account))
                (ignis-discount-text:string
                    (format 
                        "IGNIS Discount {}% (You pay only {}% of IGNIS costs)"
                        [(* (- 1.0 ignis-discount) 100.0) (* ignis-discount 100.0)]
                    )
                )
                ;;
                (auryn-supply:decimal (ref-DPTF::UR_Supply auryn))
                (wallet-auryn:decimal (ref-DPTF::UR_AccountSupply auryn account))
                (wallet-auryn-value:decimal (URC_TrueFungibleAmountPrice auryn wallet-auryn p2))
                ;;
                (eauryn-supply:decimal (ref-DPTF::UR_Supply elite-auryn))
                (wallet-eauryn:decimal (ref-DPTF::UR_AccountSupply elite-auryn account))
                (wallet-eauryn-value:decimal (URC_TrueFungibleAmountPrice elite-auryn wallet-eauryn p3))
                ;;
                (wkda-supply:decimal (ref-DPTF::UR_Supply wkda))
                (wallet-wkda:decimal (ref-DPTF::UR_AccountSupply wkda account))
                (wallet-wkda-value:decimal (URC_TrueFungibleAmountPrice wkda wallet-wkda p4))
                (kadena-discount:decimal (ref-DALOS::URC_KadenaGasDiscount account))
                (kadena-discount-text:string
                    (format 
                        "KADENA Discount {}% (You pay only {}% of KADENA costs)"
                        [(* (- 1.0 kadena-discount) 100.0) (* kadena-discount 100.0)]
                    )
                )
                ;;
                (lkda-supply:decimal (ref-DPTF::UR_Supply lkda))
                (wallet-lkda:decimal (ref-DPTF::UR_AccountSupply lkda account))
                (wallet-lkda-value:decimal (URC_TrueFungibleAmountPrice lkda wallet-lkda p5))
                (lkda-index:string (at 0 (ref-DPTF::UR_RewardToken wkda)))
                (wkda-in-ls:decimal (ref-ATS::URC_ResidentSum lkda-index))
                (total-value:decimal (fold (+) 0.0 [wallet-ouro-value wallet-ignis-value wallet-auryn-value wallet-eauryn-value wallet-wkda-value wallet-lkda-value]))
                (total-value-with-vouro:decimal (fold (+) 0.0 [wallet-vouro-value wallet-ignis-value wallet-auryn-value wallet-eauryn-value wallet-wkda-value wallet-lkda-value]))
            )
            {"total-value-display"              : (UC_ConvertPrice total-value)
            ,"total-value-with-vouro-display"   : (UC_ConvertPrice total-value-with-vouro)
            ;;
            ,"ouro-supply-display"              : (UC_FormatTokenAmount ouro-supply)
            ,"wallet-ouro-display"              : (UC_FormatTokenAmount wallet-ouro)
            ,"wallet-vouro-display"             : (UC_FormatTokenAmount wallet-vouro)
            ,"ouro-price-display"               : (UC_ConvertPrice p0)
            ,"wallet-ouro-value-display"        : (UC_ConvertPrice wallet-ouro-value)
            ,"wallet-vouro-value-display"       : (UC_ConvertPrice wallet-vouro-value)
            ,"ouro-id"                          : ouro
            ,"ouro-name"                        : (ref-DPTF::UR_Name ouro)
            ;;
            ,"ignis-supply-display"             : (UC_FormatTokenAmount ignis-supply)
            ,"wallet-ignis-display"             : (UC_FormatTokenAmount wallet-ignis)
            ,"ignis-price-display"              : (UC_ConvertPrice p1)
            ,"wallet-ignis-value-display"       : (UC_ConvertPrice wallet-ignis-value)
            ,"ignis-id"                         : ignis
            ,"ignis-name"                       : (ref-DPTF::UR_Name ignis)
            ,"ignis-text"                       : ignis-discount-text
            ;;
            ,"auryn-supply-display"             : (UC_FormatTokenAmount auryn-supply)
            ,"wallet-auryn-display"             : (UC_FormatTokenAmount wallet-auryn)
            ,"auryn-price-display"              : (UC_ConvertPrice p2)
            ,"wallet-auryn-value-display"       : (UC_ConvertPrice wallet-auryn-value)
            ,"auryn-id"                         : auryn
            ,"auryn-name"                       : (ref-DPTF::UR_Name auryn)
            ;;
            ,"eauryn-supply-display"            : (UC_FormatTokenAmount eauryn-supply)
            ,"wallet-eauryn-display"            : (UC_FormatTokenAmount wallet-eauryn)
            ,"eauryn-price-display"             : (UC_ConvertPrice p3)
            ,"wallet-eauryn-value-display"      : (UC_ConvertPrice wallet-eauryn-value)
            ,"eauryn-id"                        : elite-auryn
            ,"eauryn-name"                      : (ref-DPTF::UR_Name elite-auryn)
            ;;
            ,"wkda-supply-display"              : (UC_FormatTokenAmount wkda-supply)
            ,"wallet-wkda-display"              : (UC_FormatTokenAmount wallet-wkda)
            ,"wkda-price-display"               : (UC_ConvertPrice p4)
            ,"wallet-wkda-value-display"        : (UC_ConvertPrice wallet-wkda-value)
            ,"wkda-id"                          : wkda
            ,"wkda-name"                        : (ref-DPTF::UR_Name wkda)
            ,"wkda-text"                        : kadena-discount-text
            ;;
            ,"lkda-supply-display"              : (UC_FormatTokenAmount lkda-supply)
            ,"wallet-lkda-display"              : (UC_FormatTokenAmount wallet-lkda)
            ,"lkda-price-display"               : (UC_ConvertPrice p5)
            ,"wallet-lkda-value-display"        : (UC_ConvertPrice wallet-lkda-value)
            ,"lkda-id"                          : lkda
            ,"lkda-name"                        : (ref-DPTF::UR_Name lkda)
            ,"wkda-in-ls"                       : wkda-in-ls
            ;;
            ;;
            ,"ouro-supply-hover"                : ouro-supply
            ,"wallet-ouro-hover"                : wallet-ouro
            ,"wallet-vouro-hover"               : wallet-vouro
            ;;
            ,"ignis-supply-hover"               : ignis-supply
            ,"wallet-ignis-hover"               : wallet-ignis
            ;;
            ,"auryn-supply-hover"               : auryn-supply
            ,"wallet-auryn-hover"               : wallet-auryn
            ;;
            ,"eauryn-supply-hover"              : eauryn-supply
            ,"wallet-eauryn-hover"              : wallet-eauryn
            ;;
            ,"wkda-supply-hover"                : wkda-supply
            ,"wallet-wkda-hover"                : wallet-wkda
            ;;
            ,"lkda-supply-hover"                : lkda-supply
            ,"wallet-lkda-hover"                : wallet-lkda
            }
        )
    )
    ;;
    (defun DALOS|URC_DeployStandardAccount:list ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (price:decimal (ref-DALOS::UR_UsagePrice "standard"))
            )
            (URC_SplitKdaPriceForReceivers price)
        )
    )
    (defun DALOS|URC_DeploySmartAccount:list ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (price:decimal (ref-DALOS::UR_UsagePrice "smart"))
            )
            (URC_SplitKdaPriceForReceivers price)
        )
    )
    ;;
    (defun OUROBOROS|Sublimate (ouro-amount:decimal)
        (let
            (
                (ref-U|ATS:module{UtilityAts} U|ATS)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV4} DPTF)
                (ref-ORBR:module{OuroborosV3} OUROBOROS)
                ;;
                (ouro-id:string (ref-DALOS::UR_OuroborosID))
                (ouro-precision:integer (ref-DPTF::UR_Decimals ouro-id))
                ;;
                (ouro-split:[decimal] (ref-U|ATS::UC_PromilleSplit 10.0 ouro-amount ouro-precision))
                (ouro-remainder-amount:decimal (at 0 ouro-split))
            )
            (ref-ORBR::URC_Sublimate ouro-remainder-amount)
        )
    )
    (defun OUROBOROS|Compress (ignis-amount:decimal)
        (let
            (
                (ref-ORBR:module{OuroborosV3} OUROBOROS)
            )
            (at 0 (ref-ORBR::URC_Compress ignis-amount))
        )
    )
    ;;{F1}  [URC]
    (defun URC_KadenaDiscount (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-DALOS::URC_GasDiscount account true)
        )
    )
    (defun URC_IgnisDiscount (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
            )
            (ref-DALOS::URC_GasDiscount account false)
        )
    )
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    
    (defun UDC_KadenaCosts:object{ClientKadenaCosts} (account:string kda-full-price:decimal)
        (let
            (
                (kadena-discount:decimal (URC_KadenaDiscount account))
                (kadena-need:decimal (floor () KDAPREC))
            )
        )
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)