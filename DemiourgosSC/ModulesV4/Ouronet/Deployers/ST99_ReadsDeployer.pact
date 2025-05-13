(interface DeployerReadsV1
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
    (implements DeployerReadsV1)
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
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
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
    (defun URC_PrimordialIDs:[string] ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
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
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
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
                (ref-DALOS:module{OuronetDalosV3} DALOS)
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
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
                (ref-ATS:module{AutostakeV3} ATS)
                (ref-TFT:module{TrueFungibleTransferV4} TFT)
                (ref-ORBR:module{OuroborosV3} OUROBOROS)
                ;;
                (payment-key:string (ref-DALOS::UR_AccountKadena account))
                (payment-key-kda:decimal (ref-coin::get-balance payment-key))
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
            ,"global-lkda-supply-display"       : (UC_FormatTokenAmount global-wkda-supply)
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
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV3} DPTF)
                (ref-ATS:module{AutostakeV3} ATS)
                (ref-TFT:module{TrueFungibleTransferV4} TFT)
                ;;
                (p-ids:[string] (URC_PrimordialIDs))
                (ouro:string (at 0 p-ids))
                (ignis:string (at 1 p-ids))
                (auryn:string (at 2 p-ids))
                (elite-auryn:string (at 3 p-ids))
                (wkda:string (at 4 p-ids))
                (lkda:string (at 5 p-ids))
                ;;
                (ouro-supply:decimal (ref-DPTF::UR_Supply ouro))
                (wallet-ouro:decimal (ref-DPTF::UR_AccountSupply ouro account))
                (wallet-vouro:decimal (ref-TFT::URC_VirtualOuro account))
                ;;
                (ignis-supply:decimal (ref-DPTF::UR_Supply ignis))
                (wallet-ignis:decimal (ref-DPTF::UR_AccountSupply ignis account))
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
                ;;
                (eauryn-supply:decimal (ref-DPTF::UR_Supply elite-auryn))
                (wallet-eauryn:decimal (ref-DPTF::UR_AccountSupply elite-auryn account))
                ;;
                (wkda-supply:decimal (ref-DPTF::UR_Supply wkda))
                (wallet-wkda:decimal (ref-DPTF::UR_AccountSupply wkda account))
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
                (lkda-index:string (at 0 (ref-DPTF::UR_RewardToken wkda)))
                (wkda-in-ls:decimal (ref-ATS::URC_ResidentSum lkda-index))
            )
            {"ouro-supply-display"              : (UC_FormatTokenAmount ouro-supply)
            ,"wallet-ouro-display"              : (UC_FormatTokenAmount wallet-ouro)
            ,"wallet-vouro-display"             : (UC_FormatTokenAmount wallet-vouro)
            ,"ouro-id"                          : ouro
            ,"ouro-name"                        : (ref-DPTF::UR_Name ouro)
            ;;
            ,"ignis-supply-display"             : (UC_FormatTokenAmount ignis-supply)
            ,"wallet-ignis-display"             : (UC_FormatTokenAmount wallet-ignis)
            ,"ignis-id"                         : ignis
            ,"ignis-name"                       : (ref-DPTF::UR_Name ignis)
            ,"ignis-text"                       : ignis-discount-text
            ;;
            ,"auryn-supply-display"             : (UC_FormatTokenAmount auryn-supply)
            ,"wallet-auryn-display"             : (UC_FormatTokenAmount wallet-auryn)
            ,"auryn-id"                         : auryn
            ,"auryn-name"                       : (ref-DPTF::UR_Name auryn)
            ;;
            ,"eauryn-supply-display"            : (UC_FormatTokenAmount eauryn-supply)
            ,"wallet-eauryn-display"            : (UC_FormatTokenAmount wallet-eauryn)
            ,"eauryn-id"                        : elite-auryn
            ,"eauryn-name"                      : (ref-DPTF::UR_Name elite-auryn)
            ;;
            ,"wkda-supply-display"              : (UC_FormatTokenAmount wkda-supply)
            ,"wallet-wkda-display"              : (UC_FormatTokenAmount wallet-wkda)
            ,"wkda-id"                          : wkda
            ,"wkda-name"                        : (ref-DPTF::UR_Name wkda)
            ,"wkda-text"                        : kadena-discount-text
            ;;
            ,"lkda-supply-display"              : (UC_FormatTokenAmount lkda-supply)
            ,"wallet-wkda-display"              : (UC_FormatTokenAmount wallet-lkda)
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
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (price:decimal (ref-DALOS::UR_UsagePrice "standard"))
            )
            (URC_SplitKdaPriceForReceivers price)
        )
    )
    (defun DALOS|URC_DeploySmartAccount:list ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (price:decimal (ref-DALOS::UR_UsagePrice "smart"))
            )
            (URC_SplitKdaPriceForReceivers price)
        )
    )
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)