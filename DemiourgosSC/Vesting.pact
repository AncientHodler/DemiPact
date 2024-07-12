(module DH_SC_Vesting GOVERNANCE
    @doc "DH_SC_Vesting is the Demiourgos.Holdings Smart-Contract for Vesting of Snake Tokens, namely \
    \ Ouroboros to Vested-Ouroboros, Auryn to Vested-Auryn and Elite-Auryn to Vested-Elite-Auryn \
    \ Responsible for managing Vested Tokens (vest, unvest, vested-transfers etc"

    ;;CONSTANTS
    ;;Smart-Contract Key and Name Definitions
    (defconst SC_KEY "free.DH_SC_Vesting_Key")
    (defconst SC_NAME "Snake_Vesting")

    (defconst BAR DPTS.BAR)

    ;;SCHEMA for Vesting-Pair
    (defconst VKEY1 "release-amount")       ;;decimal
    (defconst VKEY2 "release-date")         ;;time
    (defconst VKEYS [VKEY1 VKEY2 ])
    (defconst VTYP1 "decimal")
    (defconst VTYP2 "time")

    ;;TABLE-KEYS
    (defconst TRINITY "TrinityIDs")

    ;;SCHEMAS Definitions
    (defschema TrinitySchema
        ouro-id:string
        auryn-id:string
        elite-auryn-id:string
        v-ouro-id:string
        v-auryn-id:string
        v-elite-auryn-id:string
    )
    ;;TABLES Definitions
    (deftable TrinityTable:{TrinitySchema})
    ;;
    ;;      U_ValidateObjectListAsVestingPairList
    ;;
    ;;=======================================================================================================
    ;;
    ;;Governance and Administration CAPABILITIES
    ;;
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
        \ Set to DPTF_ADMIN so that only Module Key can enact an upgrade"
        false
    )
    (defcap VESTING_ADMIN ()
        (enforce-guard (keyset-ref-guard SC_KEY))
    )
    ;;=======================================================================================================
    (defun U_ValidateObjectListAsVestingPairList:bool (vplst:[object])
        @doc "Validates that a list of Objects contains Objects conform to the Vesting Pair SCHEMA"
        (let 
            (
                (result 
                    (fold
                        (lambda 
                            (acc:bool item:object)
                            (let
                                (
                                    (iz-vesting-pair:bool (U_ValidateObjectAsVestingPair item))
                                )
                                (enforce (= iz-vesting-pair true) "Item is not of Vesting-Pair type")
                                (and acc iz-vesting-pair)
                            )
                        )
                        true
                        vplst
                    )
                )
            )
            result
        )
    )
    ;;
    ;;      U_ValidateObjectAsVestingPair
    ;;
    (defun U_ValidateObjectAsVestingPair:bool (obj:object)
        (let
            (
                (object-validation:bool (DPTS.U_ValidateObject obj (length VKEYS) VKEYS))
                (release-amount-val:decimal (at VKEY1 obj))
                (release-date-val:time (at VKEY2 obj))
            )
            (enforce (= object-validation true) "Object is of incorect format to be a Vesting Pair")
            (enforce (= (typeof release-amount-val) VTYP1) "Invalid release-amount type")
            (enforce (= (typeof release-date-val) VTYP2) "Invalid release-date type")
        )
    )
    ;;
    ;;      U_OuroborosID
    ;;
    (defun U_OuroborosID:string ()
        @doc "Returns as string the Ouroboros id"
        (at "ouro-id" (read TrinityTable TRINITY ["ouro-id"]))
    )
    ;;
    ;;      U_AurynID
    ;;
    (defun U_AurynID:string ()
        @doc "Returns as string the Auryn id"
        (at "auryn-id" (read TrinityTable TRINITY ["auryn-id"]))
    )
    ;;
    ;;      U_EliteAurynID
    ;;
    (defun U_EliteAurynID:string ()
        @doc "Returns as string the Elite-Auryn id"
        (at "elite-auryn-id" (read TrinityTable TRINITY ["elite-auryn-id"]))
    )
        ;;
    ;;      U_OuroborosID
    ;;
    (defun U_VOuroborosID:string ()
        @doc "Returns as string the Vested Ouroboros id"
        (at "v-ouro-id" (read TrinityTable TRINITY ["v-ouro-id"]))
    )
    ;;
    ;;      U_AurynID
    ;;
    (defun U_VAurynID:string ()
        @doc "Returns as string the Vested Auryn id"
        (at "v-auryn-id" (read TrinityTable TRINITY ["v-auryn-id"]))
    )
    ;;
    ;;      U_EliteAurynID
    ;;
    (defun U_VEliteAurynID:string ()
        @doc "Returns as string the Vested Elite-Auryn id"
        (at "v-elite-auryn-id" (read TrinityTable TRINITY ["v-elite-auryn-id"]))
    )


    (defun U_ValidateMilestone:bool (milestone:integer)
        (enforce (and (>= milestone 1) (<= milestone 365)) (format "The number {} is not conform with the allowed milestones for vesting"[milestone]))
    )
    (defun U_ValidateMilestoneWithTime:bool (offset:integer duration:integer milestone:integer)
        (U_ValidateMilestone milestone)
        (enforce (<= (+ (* milestone duration ) offset) 788400000) "Total Vesting Time cannot be greater than 25 years")
    )

    (defun U_SplitBalanceForVesting:[decimal] (identifier:string amount:decimal milestone:integer)
        (let*
            (

                (d:integer (DPTF.U_GetTrueFungibleDecimals identifier))
                (split:decimal (floor (/ amount (dec milestone)) d))
                (multiply:integer (- milestone 1))
            )
            (enforce (> split 0.0) (format "Amount {} to small to split into {} milestones" [amount milestone]))
            (let*
                (
                    (big-chunk:decimal (floor (* split (dec multiply)) d))
                    (last-split:decimal (floor (- amount big-chunk) d))
                )
                (enforce (= (+ big-chunk last-split) amount) (format "Amount of {} could not be split into {} milestones succesfully" [amount milestone]))
                (+ (make-list multiply split) [last-split])
            )
        )
    )

    (defun U_MakeVestingDateList:[time] (offset:integer duration:integer milestones:integer)
        (let*
            (
                (present-time:time (at "block-time" (chain-data)))
                (first-time:time (add-time present-time offset))
                (times:[time] [first-time])
            )
            (fold
                (lambda
                    (acc:[time] idx:integer)
                    (let*
                        (
                            (to-add:integer (* idx duration))
                            (new-time:time (add-time first-time to-add))
                        )
                        (+ acc [new-time])
                    )
                )
                times
                (enumerate 1 (- milestones 1))
            )
        )
    )

    (defun CheckType (identifier:string amount:decimal offset:integer duration:integer milestone:integer)
        (let
            (
                (tipul (typeof (U_MakeVestingMetaData identifier amount offset duration milestone)))
            )
            tipul
        )
    )

    (defun U_MakeVestingMetaData:[object] (identifier:string amount:decimal offset:integer duration:integer milestone:integer)
        (DPTF.U_ValidateTrueFungibleAmount identifier amount)
        (U_ValidateMilestoneWithTime offset duration milestone)

        (let*
            (
                (amount-lst:[decimal] (U_SplitBalanceForVesting identifier amount milestone))
                (date-lst:[time] (U_MakeVestingDateList offset duration milestone))
                (meta-data:[object] (zip (lambda (x:decimal y:time) { "release-amount": x, "release-date": y }) amount-lst date-lst))
                (validity:bool (U_ValidateObjectListAsVestingPairList meta-data))
            )
            (enforce (= validity true) "Invalid Meta-Data created")
            meta-data
        )

    )

    (defun A_InitialiseVesting ()
        @doc "Initialises the Vesting Smart-Contract"

        ;;Initialise the Vesting DPTS Account as a Smart Account
        ;;Necesary because it needs to operate as a MultiverX Smart Contract
        (DPTS.C_DeploySmartDPTSAccount SC_NAME (keyset-ref-guard SC_KEY))

        (with-capability (VESTING_ADMIN)
            ;;Issue Vesting Tokens below

            (let
                (
                    (ouro-id:string (DH_SC_Autostake.U_OuroborosID))
                    (auryn-id:string (DH_SC_Autostake.U_AurynID))
                    (elite-auryn-id:string (DH_SC_Autostake.U_EliteAurynID))
                    (vested-ouro-id:string 
                        (DPMF.C_IssueMetaFungible
                            SC_NAME
                            (keyset-ref-guard SC_KEY)
                            "VestedOuroboros"
                            "VOURO"
                            24
                            true    ;;can-change-owner
                            true    ;;can-upgrade
                            true    ;;can-add-special-role
                            true    ;;can-freeze
                            false   ;;can-wipe
                            false   ;;can-pause
                            false   ;;can-transfer-nft-create-role
                        )
                    )
                    (vested-auryn-id:string 
                        (DPMF.C_IssueMetaFungible
                            SC_NAME
                            (keyset-ref-guard SC_KEY)
                            "VestedAuryn"
                            "VAURYN"
                            24
                            true    ;;can-change-owner
                            true    ;;can-upgrade
                            true    ;;can-add-special-role
                            true    ;;can-freeze
                            false   ;;can-wipe
                            false   ;;can-pause
                            false   ;;can-transfer-nft-create-role
                        )
                    )
                    (vested-elite-auryn-id:string 
                        (DPMF.C_IssueMetaFungible
                            SC_NAME
                            (keyset-ref-guard SC_KEY)
                            "VestedEliteAuryn"
                            "VEAURYN"
                            24
                            true    ;;can-change-owner
                            true    ;;can-upgrade
                            true    ;;can-add-special-role
                            true    ;;can-freeze
                            false   ;;can-wipe
                            false   ;;can-pause
                            false   ;;can-transfer-nft-create-role
                        )
                    )
                )
                ;;Issue OURO/AURYN/ELITEAURYN DPTF Account for the Vesting SC
                (DPTF.C_DeployTrueFungibleAccount ouro-id SC_NAME (keyset-ref-guard SC_KEY))
                (DPTF.C_DeployTrueFungibleAccount auryn-id SC_NAME (keyset-ref-guard SC_KEY))
                (DPTF.C_DeployTrueFungibleAccount elite-auryn-id SC_NAME (keyset-ref-guard SC_KEY))
                ;;SetTrinityTable
                (insert TrinityTable TRINITY
                    {"ouro-id"                      : ouro-id
                    ,"auryn-id"                     : auryn-id
                    ,"elite-auryn-id"               : elite-auryn-id
                    ,"v-ouro-id"                      : vested-ouro-id
                    ,"v-auryn-id"                     : vested-auryn-id
                    ,"v-elite-auryn-id"               : vested-elite-auryn-id}
                )
                ;;SetTokenRoles
                (DPMF.C_SetAddQuantityRole vested-ouro-id SC_NAME)
                (DPMF.C_SetAddQuantityRole vested-auryn-id SC_NAME)
                (DPMF.C_SetAddQuantityRole vested-elite-auryn-id SC_NAME)

                (DPMF.C_SetBurnRole vested-ouro-id SC_NAME)
                (DPMF.C_SetBurnRole vested-auryn-id SC_NAME)
                (DPMF.C_SetBurnRole vested-elite-auryn-id SC_NAME)

                (DPMF.C_SetTransferRole vested-ouro-id SC_NAME)
                (DPMF.C_SetTransferRole vested-auryn-id SC_NAME)
                (DPMF.C_SetTransferRole vested-elite-auryn-id SC_NAME)
            )
        )
    )

    (defun A_VestOuroborosToVestedOuroboros (client:string target-account:string target-account-guard:guard amount:decimal offset:integer duration:integer milestone:integer)
        @doc "Vests Ouroboros, sending it to target account. Client has to present Vesting keys\
        \ which is why this is an admin function. Vesting can be done from any Account so long Vesting keys are presented"
    
        (with-capability (VEST_OURO_OURO client target-account amount)
            ;;Vesting Account generates Vested Ouro
            (let*
                (
                    (vesting-meta-data:[object] (U_MakeVestingMetaData (U_OuroborosID) amount offset duration milestone))
                    (new-nonce:integer (DPMF.C_Mint (U_VOuroborosID) SC_NAME amount vesting-meta-data))
                )
                ;;Client transfers OURO to the Vesting Account
                (DPTF.X_MethodicTransferTrueFungible (U_OuroborosID) client SC_NAME amount)
                ;;Vesting Account transfers Vested Ouro to target-account
                (DPMF.X_MethodicTransferMetaFungibleAnew (U_VOuroborosID) new-nonce SC_NAME target-account target-account-guard amount)
            )

        )
    )

    (defcap VEST_OURO_OURO (client:string target-account:string ouro-input-amount:decimal)
    ;;Client transfers OURO to the Vesting Account
        (compose-capability (DPTF.TRANSFER_DPTF (U_OuroborosID) client SC_NAME ouro-input-amount true))
    ;;Vesting Account creates Vested Ouro
        (compose-capability (DPMF.DPMF_MINT (U_VOuroborosID) SC_NAME ouro-input-amount))
    ;;Vesting Account transfers Vested Ouro to target-account
        (compose-capability (DPMF.TRANSFER_DPMF (U_VOuroborosID) SC_NAME target-account ouro-input-amount true))
    )

)

(create-table TrinityTable)