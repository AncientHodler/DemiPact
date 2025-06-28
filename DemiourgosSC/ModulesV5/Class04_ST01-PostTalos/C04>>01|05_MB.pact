(interface MovieBoosterV2
    (defun A_Step01 (patron:string))
    (defun A_Step02 (patron:string mint-amount:decimal))
    (defun A_UpdateBoostePromile (boost-promille:decimal))
    (defun A_ToggleOpenForBusiness (toggle:bool))
    (defun A_FuelMB (patron:string amount:integer))
    ;;
    ;;  [URC]
    ;;
    (defun URC_TotalMBCost:decimal (mb-amount:integer))
    (defun URC_MBCost:decimal ())
    (defun URC_MBRedemptionCost:decimal ())
    (defun URC_AccountRedemptionAmount:decimal (account:string))
    (defun URC_GetMaxBuy:integer (account:string native:bool))
    ;;
    ;;  [UEV]
    ;;
    (defun UEV_OpenedBusiness ())
    ;;
    ;;  [C]
    ;;
    (defun C_MovieBoosterBuyer (patron:string buyer:string mb-amount:integer iz-native:bool))
    (defun C_RedeemMovieBooster (patron:string target:string))
)
(module MB GOV
    ;;
    (implements OuronetPolicy)
    (implements MovieBoosterV2)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_MB                     (keyset-ref-guard (GOV|Demiurgoi)))
    ;;
    (defconst MB|SC_KEY                     (GOV|MovieBoosterKey))
    (defconst MB|SC_NAME                    (GOV|MB|SC_NAME))
    (defconst MB|SC_KDA-NAME                "k:35d7f82a7754d10fc1128d199aadb51cb1461f0eb52f4fa89790a44434f12ed8")
    ;;Mainenet ==>                           k:2d4c9cd8d1bd30d9156b65c1259d2be9689f068927d8fee19bfb695619436e01
    
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|MB_ADMIN)))
    (defcap GOV|MB_ADMIN ()                 (enforce-guard GOV|MD_MB))
    (defcap MB|GOV ()
        @doc "Governor Capability for the Swapper Smart DALOS Account"
        true
    )
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;; [Keys]
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|MovieBoosterKey ()           (+ (GOV|NS_Use) ".dh_sc_mb-keyset"))
    ;;
    ;; [SC-Names]
    (defun GOV|MB|SC_NAME ()                (at 0 ["Σ.Îäć$ЬчýφVεÎÿůпΨÖůηüηŞйnюŽXΣşpЩß5ςĂκ£RäbE₳èËłŹŘYшÆgлoюýRαѺÑÏρζt∇ŹÏýжIŒațэVÞÛщŹЭδźvëȘĂтPЖÃÇЭiërđÈÝДÖšжzČđзUĚĂsкιnãñOÔIKпŞΛI₳zÄû$ρśθ6ΨЬпYпĞHöÝйÏюşí2ćщÞΔΔŻTж€₿ŞhTțŽ"]))
    (defun MB|SetGovernor (patron:string)
        (let
            (
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
            )
            (ref-TS01-C1::DALOS|C_RotateGovernor
                patron MB|SC_NAME (create-capability-guard (MB|GOV))
            )
        )
    )
    ;;
    ;; [PBLs]
    (defun GOV|MB|PBL ()                    (at 0 ["9F.gGCkuc2wMAnFAjuFphikftLdl6qFqBD4yfeMEe9u65yMqf4r340Jd6dphh1d7E1cE20btMwl4HJ2cBEMvp209GA1eD4syB96hu4nmpFbB7dKnJEMz4p8fGLcmhvrBCfDmM0axnGin8qedl5vDtwbgL3l1aK5BsmjkEEJartqCH8qG8ialtjxwCcIMf50t2lkeww6Dct5LlmmLG25FmfpcgnwMMnkJl4Gfn9gwoA6vm0jKebjhodeJLjxnh9L11ss8f26866dqv1tEphxFFqutGetH4Itj3rHkrcrGsnlqpf4gfJp94b0gBwIBe4vCj6ha8jm6kd3f8B6pEaJtkJ3fbs6rCcGibltz1BAMn0vvKME5ddFyGBnzssk1s2s0vFzwxs6vjC61Ma2l1xDxqdg1thAk2u01hDiGndLhzK73HAfgtk7bxscn0qKhymG6JAqnEFt282pyHAq5nIthK9bA8nH76x7FEpLz4eK9tLIBsyjb8M5DxaeEei6pEnLxFCAg7ulacgtjjpjMiAaqhpmM1jEHqjt4G85q4L33zrME7whgIkIpIgwnF2qKd4"]))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|MB|CALLER ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|MB|CALLER))
        (compose-capability (SECURE))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|MB_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|MB_ADMIN)
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
                (mg:guard (create-capability-guard (P|MB|CALLER)))
            )
            (ref-P|DALOS::P|A_AddIMP mg)
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
    (defschema MB|PropertiesSchema
        mb-id:string
        boost-promille:decimal
        open-for-business:bool
    )
    ;;{2}
    (deftable MB|PropertiesTable:{MB|PropertiesSchema})
    ;;{3}
    (defun MB|Info ()                       (at 0 ["MovieBoosterInformation"]))
    (defconst MB|INFO                       (MB|Info))
    (defun CT_Bar ()                        (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                           (CT_Bar))
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
    (defcap MB|C>BUY (mb-amount:integer)
        @event
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (mb-id:string (UR_MovieBoosterID))
                (remaining-supply:decimal (ref-DPTF::UR_AccountSupply mb-id MB|SC_NAME))
                (amount:decimal (dec mb-amount))
            )
            (enforce (<= amount remaining-supply) "Remaining Amount surpassed!")
            (UEV_OpenedBusiness)
            (compose-capability (MB|GOV))
        )
    )
    (defcap MB|C>REDEEM (target:string)
        @event
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (mb-id:string (UR_MovieBoosterID))
                (supply:decimal (ref-DPTF::UR_AccountSupply mb-id target))
            )
            (enforce (>= supply 1.0) "Quantities greater than or equal to 1 can be redeemed.")
            (compose-capability (MB|GOV))
            (compose-capability (GOV|MB_ADMIN))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_MovieBoosterID:string ()
        (at "mb-id" (read MB|PropertiesTable MB|INFO ["mb-id"]))
    )
    (defun UR_BoostPromille:decimal ()
        (at "boost-promille" (read MB|PropertiesTable MB|INFO ["boost-promille"]))
    )
    (defun UR_IzOpenForBusiness:bool ()
        (at "open-for-business" (read MB|PropertiesTable MB|INFO ["open-for-business"]))
    )
    (defun UR_FrozenSparkID:string ()
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
            )
            (ref-DPTF::UR_Frozen (UR_MovieBoosterID))
        )
    )
    (defun UR_Sparks (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (spark-id:string (UR_MovieBoosterID))
                (f-spark-id:string (UR_FrozenSparkID))
            )
            {"spark-id"         : spark-id
            ,"f-spark-id"       : f-spark-id
            ,"spark-supply"     : (ref-DPTF::UR_AccountSupply spark-id account)
            ,"f-spark-supply"   : (ref-DPTF::UR_AccountSupply f-spark-id account)
            ;;
            ,"iz-sale"          : (UR_IzOpenForBusiness)
            ,"boost-promile"    : (UR_BoostPromille)
            ;;
            ,"left-for-sale"    : (ref-DPTF::UR_AccountSupply spark-id MB|SC_NAME)
            ,"sparks-supply"    : (ref-DPTF::UR_Supply spark-id)
            ,"f-sparks-supply"  : (ref-DPTF::UR_Supply f-spark-id)
            ;;
            ,"kda-spark-cost"   : (URC_MBCost)
            ,"redemption-value" : (URC_MBRedemptionCost)
            ;;
            ,"native-max"       : (URC_GetMaxBuy account true)
            ,"wkda-max"         : (URC_GetMaxBuy account false)
            ;;
            ,"account-ignis"    : (ref-DPTF::UR_AccountSupply (ref-DALOS::UR_IgnisID) account)
            ,"ignis-collection" : (ref-DALOS::UR_VirtualToggle)}
        )
    )
    ;;{F1}  [URC]
    (defun URC_TotalMBCost:decimal (mb-amount:integer)
        @doc "Returns the amount of KDA that is needed to pay for the input amount of Tokens"
        (let
            (
                (amount:decimal (dec mb-amount))
                (cost-per-token:decimal (URC_MBCost))
            )
            (* cost-per-token amount)
        ) 
    )
    (defun URC_MBCost:decimal ()
        @doc "Returns the amount of KDA that is needed to pay for one Token"
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
            )
            (floor (* 1.015 (/ 1.0 kda-pid)) kda-prec)
        )
    )
    (defun URC_MBRedemptionCost:decimal ()
        @doc "Returns the amount of KDA|WKDA a single Token can be redeemed for."
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|CT|DIA:module{DiaKdaPid} U|CT)
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                (kda-pid:decimal (ref-U|CT|DIA::UR|KDA-PID))
                (boost:decimal (UR_BoostPromille))
            )
            (floor (/ (+ 1.0 (/ boost 1000.0)) kda-pid) kda-prec)
        )
    )
    (defun URC_AccountRedemptionAmount:decimal (account:string)
        @doc "Returns Account Redemption Amount"
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (mb-id:string (UR_MovieBoosterID))
                (supply:decimal (ref-DPTF::UR_AccountSupply mb-id account))
                (kda-prec:integer (ref-U|CT::CT_KDA_PRECISION))
                (rc:decimal (URC_MBRedemptionCost))
            )
            (floor (* supply rc) kda-prec)
        )
    )
    (defun URC_GetMaxBuy:integer (account:string native:bool)
        @doc "Returns the maximum amount of Tokens that can still be bought \
        \ Conisdering the amount left, and the User Funds"
        (let
            (
                (ref-coin:module{fungible-v2} coin)
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (k-account:string (ref-DALOS::UR_AccountKadena account))
                (wkda:string (ref-DALOS::UR_WrappedKadenaID))
                (spark:string (UR_MovieBoosterID))
                (client-supply:decimal
                    (if native
                        (ref-coin::get-balance k-account)
                        (ref-DPTF::UR_AccountSupply wkda account)
                    )
                )
                (as:decimal (ref-DPTF::UR_AccountSupply spark MB|SC_NAME))
                (token-cost:decimal (URC_MBCost))
                (cb:integer (floor (/ client-supply token-cost)))
            )
            (floor (if (<= (dec cb) as) (dec cb) as))
        )
    )
    ;;{F2}  [UEV]
    (defun UEV_OpenedBusiness ()
        (let
            (
                (ofb:bool (UR_IzOpenForBusiness))
            )
            (enforce ofb "Spark acquisition is offline!")
        )
    )
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun A_Step01 (patron:string)
        (let
            (
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
            )
            (ref-TS01-C1::DALOS|C_DeploySmartAccount
                MB|SC_NAME
                (keyset-ref-guard MB|SC_KEY)
                MB|SC_KDA-NAME
                patron
                (GOV|MB|PBL)
            )
            (MB|SetGovernor patron)
        )
    )
    (defun A_Step02 (patron:string mint-amount:decimal)
        (acquire-module-admin MB)
        (let
            (
                (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                (ref-TS01-C2:module{TalosStageOne_ClientTwoV3} TS01-C2)
                (ids:list
                    (ref-TS01-C1::DPTF|C_Issue
                        patron
                        patron
                        ["Spark"]
                        ["SPARK"]
                        [6]
                        [true]
                        [true]
                        [true]
                        [true]
                        [true]
                        [true]
                    )
                )
                (SparkID:string (at 0 ids))
                (FrozenSparkID:string (ref-TS01-C2::VST|C_CreateFrozenLink patron SparkID))
            )
            (ref-TS01-C1::DPTF|C_Mint patron SparkID MB|SC_NAME 35000.0 true)
            (ref-TS01-C1::DPTF|C_ToggleMintRole patron SparkID MB|SC_NAME true)
            (ref-TS01-C1::DPTF|C_ToggleBurnRole patron SparkID MB|SC_NAME true)
            (insert MB|PropertiesTable MB|INFO
                {"mb-id"            : SparkID
                ,"boost-promille"   : 400.0
                ,"open-for-business": false}
            )
            (format "Succefully Issued Spark with ID {}, FrozenSpark with ID {} and Minted {} in Genesis Mode" [SparkID FrozenSparkID mint-amount])
        )
    )
    (defun A_UpdateBoostePromile (boost-promille:decimal)
        (with-capability (GOV|MB_ADMIN)
            (update MB|PropertiesTable MB|INFO
                {"boost-promille"   : boost-promille}
            )
        )
    )
    (defun A_ToggleOpenForBusiness (toggle:bool)
        (with-capability (GOV|MB_ADMIN)
            (update MB|PropertiesTable MB|INFO
                {"open-for-business": toggle}
            )
        )
    )
    (defun A_FuelMB (patron:string amount:integer)
        (with-capability (GOV|MB_ADMIN)
            (let
                (
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                    (mb-id:string (UR_MovieBoosterID))
                )
                (ref-TS01-C1::DPTF|C_Mint patron mb-id MB|SC_NAME (dec amount) false)
            )
        )
    )
    ;;{F6}  [C]
    (defun C_MovieBoosterBuyer (patron:string buyer:string mb-amount:integer iz-native:bool)
        (with-capability (MB|C>BUY mb-amount)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                    (ref-TS01-C2:module{TalosStageOne_ClientTwoV3} TS01-C2)
                    ;;
                    (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                    (mb-id:string (UR_MovieBoosterID))
                    (total-kadena-amount:decimal (URC_TotalMBCost mb-amount))
                )
                ;;1]Wrap the needed Kadena Amount if <iz-native> tag is <true>
                (if iz-native
                    (ref-TS01-C2::LQD|C_WrapKadena patron buyer total-kadena-amount)
                    true
                )
                ;;2]Move the Wrapped Kadena to MB|SC_NAME
                (ref-TS01-C1::DPTF|C_Transfer patron wkda-id buyer MB|SC_NAME total-kadena-amount true)
                ;;3]Move MB Tokens to buyer.
                (ref-TS01-C1::DPTF|C_Transfer patron mb-id MB|SC_NAME buyer (dec mb-amount) true)
                (format "User {} succesfuly acquired {} {} Tokens" [buyer mb-amount mb-id])
            )
        )
    )
    (defun C_RedeemMovieBooster (patron:string target:string)
        (with-capability (MB|C>REDEEM target)
            (let
                (
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                    (ref-TS01-C2:module{TalosStageOne_ClientTwoV3} TS01-C2)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    ;;
                    (mb-id:string (UR_MovieBoosterID))
                    (wkda-id:string (ref-DALOS::UR_WrappedKadenaID))
                    (supply:decimal (ref-DPTF::UR_AccountSupply mb-id target))
                    (earn-amount:decimal (URC_AccountRedemptionAmount target))
                )
                ;;1]Move Wrapped Kadena to Target
                (ref-TS01-C1::DPTF|C_Transfer patron wkda-id MB|SC_NAME target earn-amount true)
                ;;2]Freeze Target for <mb-id>
                (ref-TS01-C1::DPTF|C_ToggleFreezeAccount patron mb-id target true)
                ;;3]Wipe Target of <mb-id>
                (ref-TS01-C1::DPTF|C_Wipe patron mb-id target)
                ;;4]Unfreeze Target for <mb-id>
                (ref-TS01-C1::DPTF|C_ToggleFreezeAccount patron mb-id target false)
                ;;5]Remint same amount of Spark and Freeze it to Client.
                (ref-TS01-C1::DPTF|C_Mint patron mb-id MB|SC_NAME supply false)
                (ref-TS01-C2::VST|C_Freeze patron MB|SC_NAME target mb-id supply)
                (format "Succesfully Redeemed {} {} for {} {} on Account {}"
                    [supply mb-id earn-amount wkda-id target]
                )
            )
        )
    )
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)
(create-table MB|PropertiesTable)