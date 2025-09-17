(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(TS01-A.SWP|A_UpdateLiquidBoost false)
(let
    (
        (ref-IGNIS:module{IgnisCollector} DALOS)
        (ref-DALOS:module{OuronetDalosV4} DALOS)
        (ref-TFT:module{TrueFungibleTransferV7} TFT)
        (ref-U|LST:module{StringProcessor} U|LST)
        (ref-SWPI:module{SwapperIssueV2} SWPI)
        (ref-SWP:module{SwapperV4} SWP)
        (swp-sc:string (ref-DALOS::GOV|SWP|SC_NAME))
        (ignis-id:string (ref-DALOS::UR_IgnisID))
        (account "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (pool:string "W|LKDA-slLyzPPCo22W|OURO-slLyzPPCo22W|WKDA-slLyzPPCo22W")
        (ld:object{SwapperLiquidity.LiquidityData}
            (SWPL.URC_LD
                pool
                [0.0 10.0 0.0]
            )
        )
        (clad:object{SwapperLiquidity.CompleteLiquidityAdditionData}
            (SWPL.URC|KDA-PID_CLAD
                account
                pool
                ld
                true
                true
                (U|CT.UR|KDA-PID)
            )
        )
        (bk-ids:[string] (at "bk-ids" (at "clad-op" clad)))
        (bk-amt:[decimal] (at "bk-amt" (at "clad-op" clad)))
        (iz-balanced:bool (at "iz-balanced" (at "sorted-lq-type" ld)))
        (iz-asymmetric:bool (at "iz-asymmetric" (at "sorted-lq-type" ld)))
        (balanced-liquidity:[decimal] (at "balanced" (at "sorted-lq" ld)))
        (asymmetric-liquidity:[decimal] (at "asymmetric" (at "sorted-lq" ld)))
        (total-input-liquidity:[decimal] (zip (+) balanced-liquidity asymmetric-liquidity))
    )
    (ref-IGNIS::IC|UDC_ConstructOutputCumulator 
        (ref-DALOS::UR_UsagePrice "ignis|small") 
        swp-sc
        (ref-IGNIS::IC|URC_ZeroGAS ignis-id account) []
    )
    (ref-TFT::UDC_BulkTransferCumulator ignis-id swp-sc bk-ids bk-amt)
    (ref-IGNIS::IC|UDC_SmallCumulator swp-sc)
    (ref-TFT::UDC_MultiTransferCumulator 
        (ref-U|LST::UC_InsertFirst 
            (if (and (not iz-balanced) iz-asymmetric)
                (ref-SWPI::URC_TrimIdsWithZeroAmounts pool total-input-liquidity)
                (ref-SWP::UR_PoolTokens pool)
            )
            ignis-id
        )
        account 
        swp-sc
        (ref-U|LST::UC_InsertFirst 
            (if (and (not iz-balanced) iz-asymmetric)
                (ref-U|LST::UC_RemoveItem total-input-liquidity 0.0)
                total-input-liquidity
            )
            300.0
        )
    )
)

(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(let
    (
        (ref-DALOS:module{OuronetDalosV4} DALOS)
        (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        (lp-id:string "W|LKDA-OURO-WKDA|LP-jxrD_V4ts9Ht")
        (swpair:string "W|LKDA-slLyzPPCo22W|OURO-slLyzPPCo22W|WKDA-slLyzPPCo22W")
        (dptf:decimal (ref-DALOS::UR_UsagePrice "dptf"))
        (split-kda:[decimal] 
            (ref-DALOS::URC_SplitKDAPrices
                patron
                dptf
            )
        )
        (patron-kda:string (ref-DALOS::UR_AccountKadena patron))
        (local-kda:string "k:35d7f82a7754d10fc1128d199aadb51cb1461f0eb52f4fa89790a44434f12ed8")
        (original-kda:string "k:35d9be77f2a414cd8ce6ed83afd9d53bbdb5ef85723417131225b389a6c9e54f")
    )
    ;;Rotate to Local KDA
    (TS01-C1.DALOS|C_RotateKadena patron patron local-kda)
    (TS01-C2.VST|C_CreateFrozenLink patron lp-id)
    (TS01-C2.SWP|C_EnableFrozenLP patron swpair)
    ;;(TS01-C1.DALOS|C_RotateKadena patron patron original-kda)
    ;(TS01-C2.VST|C_CreateFrozenLink patron lp-id)
)