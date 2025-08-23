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
    ;;
    (defun URC_0001_Header (account:string))
    (defun URC_0002_Primordials (account:string))
    ;;
    (defun URC_0003_SWPairGeneralInfo ())
    (defun URC_0004_SWPairDashboardInfo (swpair:string))
    (defun URC_0005_SWPairMultiDashboardInfo (swpairs:[string]))
    ;;
    (defun DALOS|URC_DeployStandardAccount:list ())
    (defun DALOS|URC_DeploySmartAccount:list ())
)
(interface DeployerReadsV3
    ;;
    (defun UC_TrimDecimalTrailingZeros:string (number:decimal))
    (defun UC_ConvertPrice:string (input-price:decimal))
    (defun UC_FormatIndex:string (index:decimal))
    (defun UC_FormatTokenAmount:string (amount:decimal))
    (defun UC_LpFuelToLpStrings:[string] (input-ids:[string] lp-fuel:[decimal]))
    ;;
    (defun URC_PrimordialIDs:[string] ())
    (defun URC_PrimordialPrices:[decimal] ())
    (defun URC_KadenaCollectionReceivers:[string] ())
    (defun URC_SplitKdaPriceForReceivers (price:decimal))
    (defun URC_ReverseSwapOutputAmount:decimal (swpair:string output-id:string promille:decimal))
    ;;
    ;;
    (defun URC_0001_Header (account:string))
    (defun URC_0002_Primordials (account:string))
    ;;
    (defun URC_0003_SWPairGeneralInfo ())
    (defun URC_0004_SWPairDashboardInfo (swpair:string))
    (defun URC_0005_SWPairMultiDashboardInfo (swpairs:[string]))
    (defun URC_0006_Swap (account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string))
    (defun URC_0007_InverseSwap (account:string swpair:string output-id:string output-amount:decimal input-id:string))
    (defun URC_0008_CappedInverse:decimal (swpair:string output-id:string))
    (defun URC_0009_MaxInverse:decimal (swpair:string output-id:string))
    ;;
    (defun DALOS|URC_DeployStandardAccount:list ())
    (defun DALOS|URC_DeploySmartAccount:list ())
)
(interface DeployerReadsV4
    ;;
    (defun UC_TrimDecimalTrailingZeros:string (number:decimal))
    (defun UC_ConvertPrice:string (input-price:decimal))
    (defun UC_FormatIndex:string (index:decimal))
    (defun UC_FormatTokenAmount:string (amount:decimal))
    (defun UC_LpFuelToLpStrings:[string] (input-ids:[string] lp-fuel:[decimal]))
    (defun UC_FormatDecimals:[string] (input:[decimal]))
    (defun UC_FormatAccountsShort:[string] (input-accounts:[string]))
    ;;
    (defun URC_PrimordialIDs:[string] ())
    (defun URC_PrimordialPrices:[decimal] ())
    (defun URC_KadenaCollectionReceivers:[string] ())
    (defun URC_SplitKdaPriceForReceivers (price:decimal))
    (defun URC_ReverseSwapOutputAmount:decimal (swpair:string output-id:string promille:decimal))
    (defun URC_SWPairCoreRead (swpair:string))
    ;;
    ;;
    (defun URC_0001_Header (account:string))
    (defun URC_0002_Primordials (account:string))
    ;;
    (defun URC_0003_SWPairGeneralInfo ())
    (defun URC_0004_SWPairDashboardInfo (swpair:string))
    (defun URC_0005_SWPairMultiDashboardInfo (swpairs:[string]))
    (defun URC_0006_Swap (account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string))
    (defun URC_0007_InverseSwap (account:string swpair:string output-id:string output-amount:decimal input-id:string))
    (defun URC_0008_CappedInverse:decimal (swpair:string output-id:string))
    (defun URC_0009_MaxInverse:decimal (swpair:string output-id:string))
    (defun URC_0010_SwpairInternalDashboard (swpair:string))
    ;;
    (defun DALOS|URC_DeployStandardAccount:list ())
    (defun DALOS|URC_DeploySmartAccount:list ())
)

(module DPL-UR GOV
    ;;
    (implements DeployerReadsV4)
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
    (defun UC_TrimDecimalTrailingZeros:string (number:decimal)
        @doc "Trims trailing zeros from a decimal number"
        (let* 
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (number-as-string:string (format "{}" [number]))
                (split-nas:[string] (ref-U|LST::UC_SplitString "." number-as-string))
                (integer-part:string (at 0 split-nas))
                (decimal-part:string (at 1 split-nas))
                (ldp:integer (length decimal-part))
                ;;
                (trimmed-decimal-part:string
                    (fold
                        (lambda
                            (acc:string idx:integer)
                            (if (= (take -1 acc) "0")
                                (drop -1 acc)
                                acc
                            )    
                        )
                        decimal-part
                        (enumerate 0 (- ldp 1))
                    )
                )
                (resulted-string:string
                    (if (= trimmed-decimal-part "")
                        (+ integer-part ".0")
                        (concat [integer-part "." trimmed-decimal-part])
                    )
                )
            )
            resulted-string
        )
    )
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
        (let
            (
                (formated-value:string (format "{}" [(floor amount 4)]))
            )
            (if (= formated-value 0.0)
                "<0.0001"
                formated-value
            )
        )
    )
    (defun UC_LpFuelToLpStrings:[string] (input-ids:[string] lp-fuel:[decimal])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (l1:integer (length input-ids))
                (l2:integer (length lp-fuel))
            )
            (enforce (= l1 l2) "Invalid Input Data for making LP Strings")
            (fold
                (lambda
                    (acc:[string] idx:integer)
                    (if (!= (at idx lp-fuel) 0.0) 
                        (ref-U|LST::UC_AppL acc 
                            (format "{} from Input to Liquidity Providers: {}" 
                                [
                                    (at idx input-ids) 
                                    (UC_TrimDecimalTrailingZeros (at idx lp-fuel))
                                ]
                            )
                        )
                        acc
                    )
                )
                []
                (enumerate 0 (- (length input-ids) 1))
            )
        )
    )
    (defun UC_FormatDecimals:[string] (input:[decimal])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[string] idx:integer)
                    (ref-U|LST::UC_AppL acc (UC_FormatTokenAmount (at idx input)))
                )
                []
                (enumerate 0 (- (length input) 1))
            )
        )
    )
    (defun UC_FormatAccountsShort:[string] (input-accounts:[string])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-I|OURONET:module{OuronetInfoV2} DALOS)
            )
            (fold
                (lambda
                    (acc:[string] idx:integer)
                    (ref-U|LST::UC_AppL acc (ref-I|OURONET::OI|UC_ShortAccount (at idx input-accounts)))
                )
                []
                (enumerate 0 (- (length input-accounts) 1))
            )
        )
    )
    ;;{F0}  [UR]
    (defun URC_TrueFungibleAmountPrice:decimal (id:string amount:decimal price:decimal)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-ATS:module{AutostakeV4} ATS)
                (ref-DSP:module{DeployerDispenserV6} DSP)
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
                (dollar-ouro:decimal (ref-DSP::URC_OuroPrimordialPrice))
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
    (defun URC_ReverseSwapOutputAmount:decimal (swpair:string output-id:string promille:decimal)
        @doc "Computes an UI allowed <output-id> amount as a <promille> relative to its total <swpair> supply"
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (output-id-supply:decimal (ref-SWP::UR_PoolTokenSupply swpair output-id))
                (output-id-prec:integer (ref-DPTF::UR_Decimals output-id))
            )
            (floor (* (/ promille 1000.0) output-id-supply) output-id-prec)
        )
    )
    (defun URC_SWPairCoreRead (swpair:string)
        (let
            (
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPI:module{SwapperIssueV2} SWPI)
                ;;
                (ptp:[string] (UC_PoolTypeWord swpair))
                (glsb:bool (ref-SWP::UR_LiquidBoost))
                (lp-fee:decimal (ref-SWP::UR_FeeLP swpair))
                (pool-value:[decimal] (ref-SWPI::URC_PoolValue swpair))
                (pool-value-in-dwk:decimal (at 0 pool-value))
                (lp-value-in-dwk:decimal (at 1 pool-value))
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
            )
            {"pool-type"                        : (at 0 ptp)
            ,"pool-type-word"                   : (at 1 ptp)
            ,"pool-token-supplies"              : (ref-SWP::UR_PoolTokenSupplies swpair)
            ,"lp-supply"                        : (ref-SWP::URC_LpCapacity swpair)
            ,"lp-fee"                           : lp-fee
            ,"liquid-fee"                       : (if glsb lp-fee 0.0)
            ,"special-fee-targets"              : (ref-SWP::UR_SpecialFeeTargets swpair)
            ,"pool-value-in-dwk"                : pool-value-in-dwk
            ,"lp-value-in-dwk"                  : lp-value-in-dwk
            ,"pool-value-pid"                   : (UC_ConvertPrice (* pool-value-in-dwk kda-pid))
            ,"lp-value-pid"                     : (UC_ConvertPrice (* lp-value-in-dwk kda-pid))
            }
        )
    )
    ;;
    (defun URC_0001_Header (account:string)
        (let
            (
                (ref-coin:module{fungible-v2} coin)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-ATS:module{AutostakeV4} ATS)
                (ref-TFT:module{TrueFungibleTransferV7} TFT)
                (ref-ORBR:module{OuroborosV4} OUROBOROS)
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-ATS:module{AutostakeV4} ATS)
                (ref-TFT:module{TrueFungibleTransferV7} TFT)
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
    (defun URC_0003_SWPairGeneralInfo ()
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                (glsb:bool (ref-SWP::UR_LiquidBoost))
                (glsb-word:string (if glsb "ON" "OFF"))
                (asm:bool (ref-SWP::UR_Asymetric))
                (asm-word:string (if asm "ON" "OFF"))
                (pools:[string] (ref-SWP::URC_Swpairs))
                (number-of-pools:integer (length pools))
            )   
            {"global-liquid-staking-boost"      : glsb
            ,"global-liquid-staking-boost-word" : glsb-word
            ,"asymmetric"                       : asm
            ,"asymmetric-word"                  : asm-word
            ;;
            ,"pools"                            : pools
            ,"number-of-pools"                  : number-of-pools
            }
        )
    )
    (defun UC_PoolTypeWord:[string] (swpair:string)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (pool-type:string (ref-U|SWP::UC_PoolType swpair))
                (pool-type-word:string
                    (if (= pool-type "S")
                        "Stable"
                        (if (= pool-type "W")
                            "Weigthed"
                            "Product"
                        )
                    )
                )
            )
            [pool-type pool-type-word]
        )
    )
    
    (defun URC_0004_SWPairDashboardInfo (swpair:string)
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (core:object (URC_SWPairCoreRead swpair))
                (pool-token-supplies:[decimal] (at "pool-token-supplies" core))
                (lp-supply:decimal (at "lp-supply" core))
                (special-fee-targets:[string] (at "special-fee-targets" core))
                (pool-value-in-dwk:decimal (at "pool-value-in-dwk" core))
                (lp-value-in-dwk:decimal (at "lp-value-in-dwk" core))
            )
            ;;Dollar Values
            {"tvl-in-$"                         : (at "pool-value-pid" core)
            ,"lp-value-in-$"                    : (at "lp-value-pid" core)
            ;;Values and Token Values
            ,"pool-token-supplies"              : pool-token-supplies
            ,"lp-supply"                        : lp-supply
            ,"pool-value-in-dwk"                : pool-value-in-dwk
            ,"lp-value-in-dwk"                  : lp-value-in-dwk
            ,"weigths"                          : (ref-SWP::UR_Weigths swpair)
            ,"special-fee-targets-proportions"  : (ref-SWP::UR_SpecialFeeTargetsProportions swpair)
            ,"total-fee"                        : (ref-SWP::URC_PoolTotalFee swpair)
            ,"lp-fee"                           : (at "lp-fee" core)
            ,"liquid-fee"                       : (at "liquid-fee" core)
            ,"special-fee"                      : (ref-SWP::UR_FeeSP swpair)
            ;;Formated Token Values
            ,"ft-pool-token-supplies"           : (UC_FormatDecimals pool-token-supplies)
            ,"ft-lp-supply"                     : (UC_FormatTokenAmount lp-supply)
            ,"ft-pool-value-in-dwk"             : (UC_FormatTokenAmount pool-value-in-dwk)
            ,"ft-lp-value-in-dwk"               : (UC_FormatTokenAmount lp-value-in-dwk)
            ;;String Values
            ,"pool-tokens"                      : (ref-SWP::UR_PoolTokens swpair)
            ,"pool-type"                        : (at "pool-type" core)
            ,"pool-type-word"                   : (at "pool-type-word" core)
            ,"special-fee-targets"              : special-fee-targets
            ,"special-fee-targets-short"        : (UC_FormatAccountsShort special-fee-targets)
            }
        )
    )
    (defun URC_0005_SWPairMultiDashboardInfo (swpairs:[string])
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[object] idx:integer)
                    (ref-U|LST::UC_AppL
                        acc
                        (URC_0004_SWPairDashboardInfo (at idx swpairs))
                    )
                )
                []
                (enumerate 0 (- (length swpairs) 1))
            )
        )
    )
    (defun URC_0006_Swap (account:string swpair:string input-ids:[string] input-amounts:[decimal] output-id:string)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPI:module{SwapperIssueV2} SWPI)
                (ref-SWPL:module{SwapperLiquidity} SWPL)
                ;;
                (dsid:object{UtilitySwpV2.DirectSwapInputData}
                    (ref-U|SWP::UDC_DirectSwapInputData input-ids input-amounts output-id)
                )
                ;;
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (pool-type:string (ref-U|SWP::UC_PoolType swpair))
                (fees:object{UtilitySwpV2.SwapFeez} (ref-SWPL::UDC_PoolFees swpair))
                (A:decimal (ref-SWP::UR_Amplifier swpair))
                (X:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (X-prec:[integer] (ref-SWP::UR_PoolTokenPrecisions swpair))
                (input-positions:[integer] (ref-SWPI::URC_PoolTokenPositions swpair input-ids))
                (output-position:integer (ref-SWP::UR_PoolTokenPosition swpair output-id))
                (W:[decimal] (ref-SWP::UR_Weigths swpair))
                ;;
                ;;Do Swap Computation and Unwrap Object Data
                (dtso:object{UtilitySwpV2.DirectTaxedSwapOutput}
                    (ref-SWPI::UC_BareboneSwapWithFeez account pool-type dsid fees A X X-prec input-positions output-position W)
                )
                (lp-fuel:[decimal] (at "lp-fuel" dtso))
                (o-id-special:decimal (at "o-id-special" dtso))
                (o-id-liquid:decimal (at "o-id-liquid" dtso))
                (o-id-netto:decimal (at "o-id-netto" dtso))
                ;;
                (lp-strings:[string] (UC_LpFuelToLpStrings pool-tokens lp-fuel))
            )
            {"to-liquidity-providers"           : lp-strings
            ,"output-amount"                    : (format "{} Output: {}" [output-id o-id-netto])
            ,"to-special-targets"               : (format "{} from Raw Output to Special Targets: {}" [output-id o-id-special])
            ,"to-liquid-boost"                  : (format "{} from Raw Output to Liquid Boost: {}" [output-id o-id-liquid])
            }
        )
    )
    (defun URC_0007_InverseSwap (account:string swpair:string output-id:string output-amount:decimal input-id:string)
        (let
            (
                (ref-U|SWP:module{UtilitySwpV2} U|SWP)
                (ref-SWP:module{SwapperV4} SWP)
                (ref-SWPI:module{SwapperIssueV2} SWPI)
                (ref-SWPL:module{SwapperLiquidity} SWPL)
                ;;
                (rsid:object{UtilitySwpV2.ReverseSwapInputData}
                    (ref-U|SWP::UDC_ReverseSwapInputData
                        output-id output-amount input-id
                    )
                )
                ;;
                (pool-tokens:[string] (ref-SWP::UR_PoolTokens swpair))
                (pool-type:string (ref-U|SWP::UC_PoolType swpair))
                (fees:object{UtilitySwpV2.SwapFeez} (ref-SWPL::UDC_PoolFees swpair))
                (A:decimal (ref-SWP::UR_Amplifier swpair))
                (X:[decimal] (ref-SWP::UR_PoolTokenSupplies swpair))
                (X-prec:[integer] (ref-SWP::UR_PoolTokenPrecisions swpair))
                (input-position:integer (ref-SWP::UR_PoolTokenPosition swpair input-id))
                (output-position:integer (ref-SWP::UR_PoolTokenPosition swpair output-id))
                (W:[decimal] (ref-SWP::UR_Weigths swpair))
                ;;
                ;;Do Inverse Swap Computation and Unwrap Object Data
                (itso:object{UtilitySwpV2.InverseTaxedSwapOutput}
                    (ref-SWPI::UC_InverseBareboneSwapWithFeez
                        account pool-type rsid fees A X X-prec output-position input-position W
                    )
                )
                (lp-fuel:[decimal] (at "lp-fuel" itso))
                (o-id-special:decimal (at "o-id-special" itso))
                (o-id-liquid:decimal (at "o-id-liquid" itso))
                (i-id-brutto:decimal (at "i-id-brutto" itso))
                ;;
                (lp-strings:[string] (UC_LpFuelToLpStrings pool-tokens lp-fuel))
            )
            {"to-liquidity-providers"           : lp-strings
            ,"output-amount"                    : (format "{} Output: {}" [output-id output-amount])
            ,"to-special-targets"               : (format "{} from Raw Output to Special Targets: {}" [output-id o-id-special])
            ,"to-liquid-boost"                  : (format "{} from Raw Output to Liquid Boost: {}" [output-id o-id-liquid])
            ,"input-brutto"                     : i-id-brutto
            }
        )
    )
    (defun URC_0008_CappedInverse:decimal (swpair:string output-id:string)
        @doc "Computes the <Capped UI Output Amount for Inverse Swap> for the <output-id> \
            \ Capped at 75% supply of <output-id> in <swpair>, in order to protect from spending to much Input Token"
        (URC_ReverseSwapOutputAmount swpair output-id 750.0)
    )
    (defun URC_0009_MaxInverse:decimal (swpair:string output-id:string)
        @doc "Computes the <Max UI Allowed Output Amount for Inverse Swap> for the <output-id> \
            \ Capped at 95% supply of <output-id> in <swpair>, as a maximum before input amounts raise to ridiculous values"
        (URC_ReverseSwapOutputAmount swpair output-id 950.0)
    )
    (defun URC_0010_SwpairInternalDashboard (swpair:string)
        (let
            (
                (ref-SWP:module{SwapperV4} SWP)
                ;;
                (core:object (URC_SWPairCoreRead swpair))
                (pool-token-supplies:[decimal] (at "pool-token-supplies" core))
                (lp-supply:decimal (at "lp-supply" core))
                (special-fee-targets:[string] (at "special-fee-targets" core))
                (pool-value-in-dwk:decimal (at "pool-value-in-dwk" core))
                (lp-value-in-dwk:decimal (at "lp-value-in-dwk" core))
                ;;
                (genesis-supplies:[decimal] (ref-SWP::UR_PoolGenesisSupplies swpair))
            )
            ;;Dollar Values
            {"tvl-in-$"                         : (at "pool-value-pid" core)
            ,"lp-value-in-$"                    : (at "lp-value-pid" core)
            ;;Values and Token Values
            ,"genesis-supplies"                 : genesis-supplies
            ,"pool-token-supplies"              : pool-token-supplies
            ,"lp-supply"                        : lp-supply
            ,"pool-value-in-dwk"                : pool-value-in-dwk
            ,"lp-value-in-dwk"                  : lp-value-in-dwk
            ,"weigths"                          : (ref-SWP::UR_Weigths swpair)
            ,"genesis-weights"                  : (ref-SWP::UR_GenesisWeigths swpair)
            ,"amplifier"                        : (ref-SWP::UR_Amplifier swpair)
            ,"fee-unlocks"                      : (ref-SWP::UR_FeeUnlocks swpair)
            ,"special-fee-target-proportions"   : (ref-SWP::UR_SpecialFeeTargetsProportions swpair)
            ,"total-fee"                        : (ref-SWP::URC_PoolTotalFee swpair)
            ,"lp-fee"                           : (at "lp-fee" core)
            ,"liquid-fee"                       : (at "liquid-fee" core)
            ,"special-fee"                      : (ref-SWP::UR_FeeSP swpair)
            ;;Formated Token Values
            ,"ft-genesis-supplies"              : (UC_FormatDecimals genesis-supplies)
            ,"ft-pool-token-supplies"           : (UC_FormatDecimals pool-token-supplies)
            ,"ft-lp-supply"                     : (UC_FormatTokenAmount lp-supply)
            ,"ft-pool-value-in-dwk"             : (UC_FormatTokenAmount pool-value-in-dwk)
            ,"ft-lp-value-in-dwk"               : (UC_FormatTokenAmount lp-value-in-dwk)
            ;;String Values
            ,"pool-tokens"                      : (ref-SWP::UR_PoolTokens swpair)
            ,"pool-type"                        : (at "pool-type" core)
            ,"pool-type-word"                   : (at "pool-type-word" core)
            ,"primality"                        : (if (ref-SWP::UR_Primality swpair) "Primal" "Standard")
            ,"swapping-enabled"                 : (if (ref-SWP::UR_CanSwap swpair) "ON" "OFF")
            ,"liquidity-enabled"                : (if (ref-SWP::UR_CanAdd swpair) "ON" "OFF")
            ,"frozen-and-sleeping"              : (format "{} | {}" [(if (ref-SWP::UR_IzFrozenLP swpair) "ON" "OFF") (if (ref-SWP::UR_IzSleepingLP swpair) "ON" "OFF")])
            ,"fee-lockup"                       : (if (ref-SWP::UR_FeeLock swpair) "Locked" "Unlocked")
            ,"special-fee-targets"              : special-fee-targets
            ,"special-fee-targets-short"        : (UC_FormatAccountsShort special-fee-targets)
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
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-ORBR:module{OuroborosV4} OUROBOROS)
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
                (ref-ORBR:module{OuroborosV4} OUROBOROS)
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
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)