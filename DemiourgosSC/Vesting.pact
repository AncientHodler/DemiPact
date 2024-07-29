(module DH_SC_Vesting GOVERNANCE
    @doc "DH_SC_Vesting is the Demiourgos.Holdings Smart-Contract for Vesting of Snake Tokens, namely \
    \ Ouroboros to Vested-Ouroboros, Auryn to Vested-Auryn and Elite-Auryn to Vested-Elite-Auryn \
    \ Responsible for managing Vested Tokens (vest, unvest, vested-transfers etc"

    ;;0]GOVERNANCE-ADMIN
    ;;
    ;;      GOVERNANCE|VESTING_ADMIN|VESTING_MASTER
    ;;      VESTING_INIT
    ;;
    (defcap GOVERNANCE ()
        @doc "Set to false for non-upgradeability; \
        \ Set to DPTF_ADMIN so that only Module Key can enact an upgrade"
        false
    )
    (defcap VESTING_ADMIN ()
        (enforce-guard (keyset-ref-guard SC_KEY))
    )
    (defcap VESTING_MASTER ()
        (enforce-one
            "Either Demiourgos Trinity or Vesting Key can perform Vesting"
            [
                (compose-capability (VESTING_ADMIN))
                (compose-capability (DPTS.DPTS_ADMIN))
            ]
        )
    )
    (defcap VESTING_INIT ()
        (compose-capability (VESTING_MASTER))
    )

    ;;1]CONSTANTS Definitions
    ;;Smart-Contract Key and Name Definitions
    (defconst SC_KEY "free.DH_SC_Vesting_Key")
    (defconst SC_NAME "Snake_Vesting")

    (defconst BAR DPTS.BAR)

    ;;TABLE-KEYS
    (defconst TRINITY "TrinityIDs")

    ;;2]SCHEMA Definitions
    (defschema TrinitySchema
        ouro-id:string
        auryn-id:string
        elite-auryn-id:string
        v-ouro-id:string
        v-auryn-id:string
        v-elite-auryn-id:string
    )

    ;;Vesting-Pair schematic
    (defconst VKEY1 "release-amount")       ;;decimal
    (defconst VKEY2 "release-date")         ;;time
    (defconst VKEYS [VKEY1 VKEY2 ])
    (defconst VTYP1 "decimal")
    (defconst VTYP2 "time")

    ;;3]TABLES Definitions
    (deftable TrinityTable:{TrinitySchema})
    

    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      CAPABILITIES                                                                                                                                ;;
    ;;                                                                                                                                                  ;;
    ;;      CORE                                    Module Core Capabilities                                                                            ;;
    ;;      COMPOSED                                Composed Capabilities are made of one or multiple Basic Capabilities                                ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      CORE                                                                                                                                       ;;
    ;;                                                                                                                                                  ;;
    ;;      GOVERNANCE                              Modules Governance Capability                                                                       ;;
    ;;      VESTING_ADMIN                           Capability denoting the module administrator                                                        ;;
    ;;      VESTING_MASTER                          Capability required to execute vesting operations                                                   ;;
    ;;      VESTING_INIT                            Capability required to initialise the Vesting Module                                                ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      COMPOSED                                                                                                                                    ;;
    ;;                                                                                                                                                  ;;
    ;;==================VESTING=====================                                                                                                    ;;
    ;;      VEST_OURO_VOURO                         Capability required to Vest Ouroboros into Vested Ouroboros                                         ;;
    ;;      VEST_OURO_VAURYN                        Capability required to Vest Ouroboros into Vested Auryn                                             ;;
    ;;      VEST_OURO_VEAURYN                       Capability required to Vest Ouroboros into Vested Elite-Auryn                                       ;;
    ;;      VEST_AURYN_VAURYN                       Capability required to Vest Auryn into Vested Auryn                                                 ;;
    ;;      VEST_AURYN_VEAURYN                      Capability required to Vest Auryn into Vested Elite Auryn                                           ;;
    ;;      VEST_EAURYN_VEAURYN                     Capability required to Vest Elite Auryn into Vested Elite Auryn                                     ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    

    ;;==============================================
    ;;                                            ;;
    ;;      CAPABILITIES                          ;;
    ;;                                            ;;
    ;;      COMPOSED                              ;;
    ;;                                            ;;
    ;;==================VESTING=====================
    ;;
    ;;      VEST_OURO_VOURO|VEST_OURO_VAURYN|VEST_OURO_VEAURYN
    ;;      VEST_AURYN_VAURYN|VEST_AURYN_VEAURYN|VEST_EAURYN_VEAURYN
    ;;
    (defcap VEST_OURO_VOURO (client:string target-account:string ouro-input-amount:decimal)
    ;;0]Only the Master Vesters can perform Vesting
        (compose-capability (VESTING_MASTER))
    ;;1]Client transfers <OURO|Ouroboros> to the <Snake_Vesting> Account
        (compose-capability (DPTF.TRANSFER_DPTF (UR_OuroborosID) client SC_NAME ouro-input-amount true))
    ;;2]Vesting Account creates <VOURO|Vested-Ouroboros>
        (compose-capability (DPMF.DPMF_MINT (UR_VOuroborosID) SC_NAME ouro-input-amount))
    ;;3]Vesting Account transfers <VOURO|Vested-Ouroboros> to target-account
        (compose-capability (DPMF.TRANSFER_DPMF (UR_VOuroborosID) SC_NAME target-account ouro-input-amount true))
    )
    (defcap VEST_OURO_VAURYN (client:string target-account:string ouro-input-amount:decimal)
        (let
            (
                (auryn-output-amount:decimal (DH_SC_Autostake.UC_OuroCoil ouro-input-amount))
            )
        ;;0]Only the Master Vesters can perform Vesting
            (compose-capability (VESTING_MASTER))
        ;;1]Client transfers <OURO|Ouroboros> to the <Snake_Vesting> Account
            (compose-capability (DPTF.TRANSFER_DPTF (UR_OuroborosID) client SC_NAME ouro-input-amount true))
        ;;2]Vesting Account coils <OURO|Ouroboros>, generating AURYN|Auryn
            (compose-capability (DH_SC_Autostake.COIL_OUROBOROS SC_NAME ouro-input-amount))
        ;;3]Vesting Account creates <VAURYN|Vested-Auryn>
            (compose-capability (DPMF.DPMF_MINT (UR_VAurynID) SC_NAME auryn-output-amount))
        ;;4]Vesting Account transfers <VAURYN|Vested-Auryn> to target-account
            (compose-capability (DPMF.TRANSFER_DPMF (UR_VAurynID) SC_NAME target-account auryn-output-amount true))
        )
    )
    (defcap VEST_OURO_VEAURYN (client:string target-account:string ouro-input-amount:decimal)
        (let
            (
                (auryn-output-amount:decimal (DH_SC_Autostake.UC_OuroCoil ouro-input-amount))
            )
        ;;0]Only the Master Vesters can perform Vesting
            (compose-capability (VESTING_MASTER))
        ;;1]Client transfers <OURO|Ouroboros> to the <Snake_Vesting> Account
            (compose-capability (DPTF.TRANSFER_DPTF (UR_OuroborosID) client SC_NAME ouro-input-amount true))
        ;;2]Vesting Account curls <OURO|Ouroboros>, generating <EAURYN|Elite-Auryn>
            (compose-capability (DH_SC_Autostake.CURL_OUROBOROS SC_NAME ouro-input-amount))
        ;;3]Vesting Account creates <VEAURYN|Vested-Elite-Auryn>
            (compose-capability (DPMF.DPMF_MINT (UR_VEliteAurynID) SC_NAME auryn-output-amount))
        ;;4]Vesting Account transfers <VEAURYN|Vested-Elite-Auryn> to target-account
            (compose-capability (DPMF.TRANSFER_DPMF (UR_VEliteAurynID) SC_NAME target-account auryn-output-amount true))
        )
    )
    (defcap VEST_AURYN_VAURYN (client:string target-account:string auryn-input-amount:decimal)
    ;;0]Only the Master Vesters can perform Vesting
        (compose-capability (VESTING_MASTER))
    ;;1]Client transfers <AURYN|Auryn> to the <Snake_Vesting> Account
        (compose-capability (DPTF.TRANSFER_DPTF (UR_AurynID) client SC_NAME auryn-input-amount true))
    ;;2]Vesting Account creates <VAURYN|Vested-Auryn>
        (compose-capability (DPMF.DPMF_MINT (UR_VAurynID) SC_NAME auryn-input-amount))
    ;;3]Vesting Account transfers <VAURYN|Vested-Auryn> to target-account
        (compose-capability (DPMF.TRANSFER_DPMF (UR_VAurynID) SC_NAME target-account auryn-input-amount true))
    )
    (defcap VEST_AURYN_VEAURYN (client:string target-account:string auryn-input-amount:decimal)
    ;;0]Only the Master Vesters can perform Vesting
        (compose-capability (VESTING_MASTER))
    ;;1]Client transfers <AURYN|Auryn> to the <Snake_Vesting> Account
        (compose-capability (DPTF.TRANSFER_DPTF (UR_AurynID) client SC_NAME auryn-input-amount true))
    ;;2]Vesting Account coils <AURYN|Auryn>, generating EAURYN|Elite-Auryn
        (compose-capability (DH_SC_Autostake.COIL_AURYN SC_NAME auryn-input-amount))
    ;;3]Vesting Account creates <VEAURYN|Vested-Elite-Auryn>
        (compose-capability (DPMF.DPMF_MINT (UR_VEliteAurynID) SC_NAME auryn-input-amount))
    ;;4]Vesting Account transfers <VEAURYN|Vested-Elite-Auryn> to target-account
        (compose-capability (DPMF.TRANSFER_DPMF (UR_VEliteAurynID) SC_NAME target-account auryn-input-amount true))
    )
    (defcap VEST_EAURYN_VEAURYN (client:string target-account:string elite-auryn-input-amount:decimal)
    ;;0]Only the Master Vesters can perform Vesting
        (compose-capability (VESTING_MASTER))
    ;;1]Client transfers <EAURYN|Elite-Auryn> to the <Snake_Vesting> Account
        (compose-capability (DPTF.TRANSFER_DPTF (UR_EliteAurynID) client SC_NAME elite-auryn-input-amount true))
    ;;2]Vesting Account creates <VEAURYN|Vested-Elite-Auryn>
        (compose-capability (DPMF.DPMF_MINT (UR_VEliteAurynID) SC_NAME elite-auryn-input-amount))
    ;;3]Vesting Account transfers <VEAURYN|Vested-Elite-Auryn> to target-account
        (compose-capability (DPMF.TRANSFER_DPMF (UR_VEliteAurynID) SC_NAME target-account elite-auryn-input-amount true))
    )


    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      PRIMARY Functions                       Stand-Alone Functions                                                                               ;;
    ;;                                                                                                                                                  ;;
    ;;      0)UTILITY                               Free Functions: can can be called by anyone. (Compute|Print|Read|Validate Functions)                ;;
    ;;                                                  No Key|Guard required.                                                                          ;;
    ;;      1)ADMINISTRATOR                         Administrator Functions: can only be called by module administrator.                                ;;
    ;;                                                  DPTF_ADMIN Capability Required.                                                                 ;;
    ;;      2)CLIENT                                Client Functions: can be called by any DPMF Account.                                                ;;
    ;;                                                  DPTF_CLIENT Capability Required.                                                                ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      SECONDARY Functions                     Auxiliary Functions: cannot be called on their own                                                  ;;
    ;;                                                                                                                                                  ;;
    ;;      3)AUXILIARY                             Are Part of Client Function                                                                         ;;
    ;;                                                  Capabilities are required to use auxiliary Functions                                            ;;
    ;;                                                                                                                                                  ;;      
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      Functions Names are prefixed, so that they may be better visualised and understood.                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;      UTILITY-COMPUTE                         UC_FunctionName                                                                                     ;;
    ;;      UTILITY-PRINT                           UP_FunctionName                                                                                     ;;
    ;;      UTILITY-READ                            UR_FunctionName                                                                                     ;;
    ;;      UTILITY-VALIDATE                        UV_FunctionName                                                                                     ;;
    ;;      ADMINISTRATION                          A_FunctionName                                                                                      ;;
    ;;      CLIENT                                  C_FunctionName                                                                                      ;;
    ;;      AUXILIARY                               X_FunctionName                                                                                      ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      UTILITY FUNCTIONS                                                                                                                           ;;
    ;;                                                                                                                                                  ;;
    ;;                                                                                                                                                  ;;
    ;;==================IDENTIFIERS=================                                                                                                    ;;
    ;;      UR_OuroborosID                          Returns the Ouroboros identifier saved in the module Trinity Table                                  ;;
    ;;      UR_AurynID                              Returns the Ouroboros identifier saved in the module Trinity Table                                  ;;
    ;;      UR_EliteAurynID                         Returns the Ouroboros identifier saved in the module Trinity Table                                  ;;
    ;;      UR_VOuroborosID                         Returns the Ouroboros identifier saved in the module Trinity Table                                  ;;
    ;;      UR_VAurynID                             Returns the Ouroboros identifier saved in the module Trinity Table                                  ;;
    ;;      UR_VEliteAurynID                        Returns the Ouroboros identifier saved in the module Trinity Table                                  ;;
    ;;==================MATH-&-COMPOSITION==========                                                                                                    ;;
    ;;      UC_SplitBalanceForVesting               Splits an Amount according to vesting parameters                                                    ;;
    ;;      UC_MakeVestingDateList                  Makes a Times list with unvesting milestones according to vesting parameters                        ;;
    ;;      UC_ComposeVestingMetaData               Creates Vesting MetaData                                                                            ;;
    ;;==================VALIDATIONS=================                                                                                                    ;;
    ;;      UV_Milestone                            Restrict Milestone integer between 1 and 365 Milestones                                             ;;
    ;;      UV_MilestoneWithTime                    Validates Milestone duration to be lower than 25 years                                              ;;
    ;;      UV_ObjectAsVestingPair                  Validates an Object as a Vesting Pair                                                               ;;
    ;;      UV_ObjectListAsVestingPairList          Validates an Object List as a List of Vesting Pairs                                                 ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      ADMINISTRATION FUNCTIONS                                                                                                                    ;;
    ;;                                                                                                                                                  ;;
    ;;      A_InitialiseVesting                     Initialises the Vesting Module                                                                      ;;
    ;;      A_VestOuroVOuro                         Vests Ouroboros, sending it to target account as Vested Ouroboros                                   ;;
    ;;      A_VestOuroVAuryn                        Vests Ouroboros, sending it to target account as Vested Auryn                                       ;;
    ;;      A_VestOuroVEAuryn                       Vests Ouroboros, sending it to target account as Vested Elite-Auryn                                 ;;
    ;;      A_VestAurynVAuryn                       Vests Auryn, sending it to target account as Vested Auryn                                           ;;
    ;;      A_VestAurynVEAuryn                      Vests Auryn, sending it to target account as Vested Elite-Auryn                                     ;;
    ;;      A_VestEAurynVEAuryn                     Vests Elite-Auryn, sending it to target account as Vested Elite-Auryn                               ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      CLIENT FUNCTIONS                                                                                                                            ;;
    ;;                                                                                                                                                  ;;
    ;;      NO CLIENT FUNCTIONS                                                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      AUXILIARY FUNCTIONS                                                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;      NO AUXILIARY FUNCTIONS                                                                                                                      ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;


    ;;==============================================
    ;;                                            ;;
    ;;      UTILITY FUNCTIONS                     ;;
    ;;                                            ;;
    ;;==================IDENTIFIERS=================  
    ;;
    ;;      UR_OuroborosID|UR_AurynID|UR_EliteAurynID
    ;;      UR_VOuroborosID|UR_VAurynID|UR_VEliteAurynID
    ;;
    (defun UR_OuroborosID:string ()
        @doc "Returns as string the Ouroboros id"
        (at "ouro-id" (read TrinityTable TRINITY ["ouro-id"]))
    )
    (defun UR_AurynID:string ()
        @doc "Returns as string the Auryn id"
        (at "auryn-id" (read TrinityTable TRINITY ["auryn-id"]))
    )
    (defun UR_EliteAurynID:string ()
        @doc "Returns as string the Elite-Auryn id"
        (at "elite-auryn-id" (read TrinityTable TRINITY ["elite-auryn-id"]))
    )
    (defun UR_VOuroborosID:string ()
        @doc "Returns as string the Vested Ouroboros id"
        (at "v-ouro-id" (read TrinityTable TRINITY ["v-ouro-id"]))
    )
    (defun UR_VAurynID:string ()
        @doc "Returns as string the Vested Auryn id"
        (at "v-auryn-id" (read TrinityTable TRINITY ["v-auryn-id"]))
    )
    (defun UR_VEliteAurynID:string ()
        @doc "Returns as string the Vested Elite-Auryn id"
        (at "v-elite-auryn-id" (read TrinityTable TRINITY ["v-elite-auryn-id"]))
    )
    ;;
    ;;==================MATH-&-COMPOSITION==========
    ;;
    ;;      UC_SplitBalanceForVesting|UC_MakeVestingDateList
    ;;      UC_ComposeVestingMetaData
    ;;
    (defun UC_SplitBalanceForVesting:[decimal] (identifier:string amount:decimal milestone:integer)
        @doc "Splits an Amount according to vesting parameters"

        (let*
            (

                (d:integer (DPTF.UR_TrueFungibleDecimals identifier))
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
    (defun UC_MakeVestingDateList:[time] (offset:integer duration:integer milestones:integer)
        @doc "Makes a Times list with unvesting milestones according to vesting parameters"

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
    (defun UC_ComposeVestingMetaData:[object] (identifier:string amount:decimal offset:integer duration:integer milestone:integer)
        @doc "Creates Vesting MetaData"

        (DPTF.UV_TrueFungibleAmount identifier amount)
        (UV_MilestoneWithTime offset duration milestone)

        (let*
            (
                (amount-lst:[decimal] (UC_SplitBalanceForVesting identifier amount milestone))
                (date-lst:[time] (UC_MakeVestingDateList offset duration milestone))
                (meta-data:[object] (zip (lambda (x:decimal y:time) { "release-amount": x, "release-date": y }) amount-lst date-lst))
                (validity:bool (UV_ObjectListAsVestingPairList meta-data))
            )
            (enforce (= validity true) "Invalid Meta-Data created")
            meta-data
        )
    )
    ;;
    ;;==================VALIDATIONS=================
    ;;
    ;;      UV_Milestone|UV_MilestoneWithTime
    ;;      UV_ObjectAsVestingPair|UV_ObjectListAsVestingPairList
    ;;
    (defun UV_Milestone:bool (milestone:integer)
        @doc "Restrict Milestone integer between 1 and 365 Milestones"

        (enforce 
            (and (>= milestone 1) (<= milestone 365)) 
            (format "The number {} is not conform with the allowed milestones for vesting"[milestone])
        )
    )
    (defun UV_MilestoneWithTime:bool (offset:integer duration:integer milestone:integer)
        @doc "Validates Milestone duration to be lower than 25 years"

        (UV_Milestone milestone)
        (enforce 
            (<= (+ (* milestone duration ) offset) 788400000) 
            "Total Vesting Time cannot be greater than 25 years"
        )
    )
    (defun UV_ObjectAsVestingPair:bool (obj:object)
        @doc "Validates an Object as a Vesting Pair"

        (let
            (
                (object-validation:bool (DPTS.UV_Object obj (length VKEYS) VKEYS))
                (release-amount-val:decimal (at VKEY1 obj))
                (release-date-val:time (at VKEY2 obj))
            )
            (enforce (= object-validation true) "Object is of incorect format to be a Vesting Pair")
            (enforce (= (typeof release-amount-val) VTYP1) "Invalid release-amount type")
            (enforce (= (typeof release-date-val) VTYP2) "Invalid release-date type")
        )
    )
    (defun UV_ObjectListAsVestingPairList:bool (vplst:[object])
        @doc "Validates an Object List as a List of Vesting Pairs"

        (let 
            (
                (result 
                    (fold
                        (lambda 
                            (acc:bool item:object)
                            (let
                                (
                                    (iz-vesting-pair:bool (UV_ObjectAsVestingPair item))
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
    ;;--------------------------------------------;;
    ;;                                            ;;
    ;;      ADMINISTRATION FUNCTIONS              ;;
    ;;                                            ;;
    ;;--------------------------------------------;;
    ;;
    ;;      A_InitialiseVesting
    ;;      A_VestOuroVOuro|A_VestOuroVAuryn|A_VestOuroVEAuryn
    ;;      A_VestAurynVAuryn|A_VestAurynVEAuryn|A_VestEAurynVEAuryn
    ;;
    (defun A_InitialiseVesting ()
        @doc "Initialises the Vesting Module"

        ;;Initialise the Vesting DPTS Account as a Smart Account
        ;;Necesary because it needs to operate as a MultiverX Smart Contract
        (DPTS.C_DeploySmartDPTSAccount SC_NAME (keyset-ref-guard SC_KEY))

        (with-capability (VESTING_INIT)
            ;;Issue Vesting Tokens below

            (let
                (
                    (ouro-id:string (DH_SC_Autostake.UR_OuroborosID))
                    (auryn-id:string (DH_SC_Autostake.UR_AurynID))
                    (elite-auryn-id:string (DH_SC_Autostake.UR_EliteAurynID))
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
    (defun A_VestOuroVOuro (client:string target-account:string target-account-guard:guard amount:decimal offset:integer duration:integer milestone:integer)
        @doc "Vests Ouroboros, sending it to target account as Vested Ouroboros \
            \ Client must present administrator keys for this to work, which is why this is not a client function"
    
        ;;0]Only the Master Vesters can perform Vesting
        (with-capability (VEST_OURO_VOURO client target-account amount)
            ;;1]Client transfers <OURO|Ouroboros> to the <Snake_Vesting> Account
            (DPTF.X_MethodicTransferTrueFungible (UR_OuroborosID) client SC_NAME amount)
            ;;2]Vesting Account creates <VOURO|Vested-Ouroboros>
            (let*
                (
                    (vesting-meta-data:[object] (UC_ComposeVestingMetaData (UR_OuroborosID) amount offset duration milestone))
                    (new-nonce:integer (DPMF.C_Mint (UR_VOuroborosID) SC_NAME amount vesting-meta-data))
                )    
                ;;3]Vesting Account transfers <VOURO|Vested-Ouroboros> to target-account
                (DPMF.X_MethodicTransferMetaFungibleAnew (UR_VOuroborosID) new-nonce SC_NAME target-account target-account-guard amount)
            )
        )
    )
    (defun A_VestOuroVAuryn (client:string target-account:string target-account-guard:guard amount:decimal offset:integer duration:integer milestone:integer)
        @doc "Vests Ouroboros, sending it to target account as Vested Auryn \
            \ Client must present administrator keys for this to work, which is why this is not a client function"
    
        ;;0]Only the Master Vesters can perform Vesting
        (with-capability (VEST_OURO_VAURYN client target-account amount)
            ;;1]Client transfers <OURO|Ouroboros> to the <Snake_Vesting> Account
            (DPTF.X_MethodicTransferTrueFungible (UR_OuroborosID) client SC_NAME amount)
            ;;2]Vesting Account coils <OURO|Ouroboros>, generating AURYN|Auryn; this outputs the auryn-amount
            ;;3]Vesting Account creates <VAURYN|Vested-Auryn>; knowing the auryn-amount
            (let*
                (
                    (auryn-amount:decimal (DH_SC_Autostake.C_CoilOuroboros SC_NAME amount))
                    (vesting-meta-data:[object] (UC_ComposeVestingMetaData (UR_AurynID) auryn-amount offset duration milestone))
                    (new-nonce:integer (DPMF.C_Mint (UR_VAurynID) SC_NAME auryn-amount vesting-meta-data))
                )
                ;;4]Vesting Account transfers <VAURYN|Vested-Auryn> to target-account; since auryn-amount and new-nonce are now known
                (DPMF.X_MethodicTransferMetaFungibleAnew (UR_VAurynID) new-nonce SC_NAME target-account target-account-guard auryn-amount)
            )
        )
    )
    (defun A_VestOuroVEAuryn (client:string target-account:string target-account-guard:guard amount:decimal offset:integer duration:integer milestone:integer)
        @doc "Vests Ouroboros, sending it to target account as Vested Elite-Auryn \
            \ Client must present administrator keys for this to work, which is why this is not a client function"
    
        ;;0]Only the Master Vesters can perform Vesting
        (with-capability (VEST_OURO_VEAURYN client target-account amount)
            ;;1]Client transfers <OURO|Ouroboros> to the <Snake_Vesting> Account
            (DPTF.X_MethodicTransferTrueFungible (UR_OuroborosID) client SC_NAME amount)
            ;;2]Vesting Account curls <OURO|Ouroboros>, generating <EAURYN|Elite-Auryn>; this outputs elite-auryn-amount
            ;;3]Vesting Account creates <VEAURYN|Vested-Elite-Auryn>; knowing the elite-auryn-amount
            (let*
                (
                    (elite-auryn-amount:decimal (DH_SC_Autostake.C_CurlOuroboros SC_NAME amount))
                    (vesting-meta-data:[object] (UC_ComposeVestingMetaData (UR_AurynID) elite-auryn-amount offset duration milestone))
                    (new-nonce:integer (DPMF.C_Mint (UR_VEliteAurynID) SC_NAME elite-auryn-amount vesting-meta-data))
                )
                ;;4]Vesting Account transfers <VEAURYN|Vested-Elite-Auryn> to target-account; since elite-auryn-amount and new-nonce are now known
                (DPMF.X_MethodicTransferMetaFungibleAnew (UR_VEliteAurynID) new-nonce SC_NAME target-account target-account-guard elite-auryn-amount)
            )
        )
    )
    (defun A_VestAurynVAuryn(client:string target-account:string target-account-guard:guard amount:decimal offset:integer duration:integer milestone:integer)
        @doc "Vests Auryn, sending it to target account as Vested Auryn \
            \ Client must present administrator keys for this to work, which is why this is not a client function"
    
        ;;0]Only the Master Vesters can perform Vesting
        (with-capability (VEST_AURYN_VAURYN client target-account amount)
            ;;1]Client transfers <AURYN|Auryn> to the <Snake_Vesting> Account
            (DPTF.X_MethodicTransferTrueFungible (UR_AurynID) client SC_NAME amount)
            ;;2]Vesting Account creates <VAURYN|Vested-Auryn>
            (let*
                (
                    (vesting-meta-data:[object] (UC_ComposeVestingMetaData (UR_AurynID) amount offset duration milestone))
                    (new-nonce:integer (DPMF.C_Mint (UR_VAurynID) SC_NAME amount vesting-meta-data))
                )
                true
                ;;3]Vesting Account transfers <VAURYN|Vested-Auryn> to target-account
                (DPMF.X_MethodicTransferMetaFungibleAnew (UR_VAurynID) new-nonce SC_NAME target-account target-account-guard amount)
            )
        )
    )
    (defun A_VestAurynVEAuryn (client:string target-account:string target-account-guard:guard amount:decimal offset:integer duration:integer milestone:integer)
        @doc "Vests Auryn, sending it to target account as Vested Elite-Auryn \
            \ Client must present administrator keys for this to work, which is why this is not a client function"

        ;;0]Only the Master Vesters can perform Vesting
        (with-capability (VEST_AURYN_VEAURYN client target-account amount)
            ;;1]Client transfers <AURYN|Auryn> to the <Snake_Vesting> Account
            (DPTF.X_MethodicTransferTrueFungible (UR_AurynID) client SC_NAME amount)
            ;;2]Vesting Account coils <AURYN|Auryn>, generating EAURYN|Elite-Auryn
            (DH_SC_Autostake.C_CoilAuryn SC_NAME amount)
            ;3]Vesting Account creates <VEAURYN|Vested-Elite-Auryn>
            (let*
                (
                    (vesting-meta-data:[object] (UC_ComposeVestingMetaData (UR_AurynID) amount offset duration milestone))
                    (new-nonce:integer (DPMF.C_Mint (UR_VEliteAurynID) SC_NAME amount vesting-meta-data))
                )
                ;;4]Vesting Account transfers <VEAURYN|Vested-Elite-Auryn> to target-account
                (DPMF.X_MethodicTransferMetaFungibleAnew (UR_VEliteAurynID) new-nonce SC_NAME target-account target-account-guard amount)
            )
        )
    )
    (defun A_VestEAurynVEAuryn (client:string target-account:string target-account-guard:guard amount:decimal offset:integer duration:integer milestone:integer)
        @doc "Vests Elite-Auryn, sending it to target account as Vested Elite-Auryn \
            \ Client must present administrator keys for this to work, which is why this is not a client function"
    
        ;;0]Only the Master Vesters can perform Vesting
        (with-capability (VEST_EAURYN_VEAURYN client target-account amount)
            ;;1]Client transfers <EAURYN|Elite-Auryn> to the <Snake_Vesting> Account
            (DPTF.X_MethodicTransferTrueFungible (UR_EliteAurynID) client SC_NAME amount)
            ;;2]Vesting Account creates <VEAURYN|Vested-Elite-Auryn>
            (let*
                (
                    (vesting-meta-data:[object] (UC_ComposeVestingMetaData (UR_EliteAurynID) amount offset duration milestone))
                    (new-nonce:integer (DPMF.C_Mint (UR_VEliteAurynID) SC_NAME amount vesting-meta-data))
                )
                ;;3]Vesting Account transfers <VEAURYN|Vested-Elite-Auryn> to target-account
                (DPMF.X_MethodicTransferMetaFungibleAnew (UR_VEliteAurynID) new-nonce SC_NAME target-account target-account-guard amount)
            )
        )
    )

    ;;--------------------------------------------;;
    ;;                                            ;;
    ;;      CLIENT FUNCTIONS                      ;;
    ;;                                            ;;
    ;;      NO CLIENT FUNCTIONS                   ;;
    ;;--------------------------------------------;;
    ;;                                            ;;
    ;;      AUXILIARY FUNCTIONS                   ;;
    ;;                                            ;;
    ;;      NO AUXILIARY FUNCTIONS                ;;
    ;;--------------------------------------------;;

)

(create-table TrinityTable)