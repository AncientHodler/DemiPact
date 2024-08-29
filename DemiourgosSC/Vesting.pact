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
                (compose-capability (OUROBOROS.OUROBOROS_ADMIN))
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

    (defconst BAR OUROBOROS.BAR)

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

    ;;Vesting Meta-Data Schema
    (defschema VestingMetaDataSchema
        release-amount:decimal
        release-date:time
    )
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
    ;;==================CULLING=====================                                                                                                    ;;
    ;;      CULL_EXECUTOR                           Capability enforcing identifier is a vested snake token identifier                                  ;;
    ;;      CULL_VESTED_SNAKES                      Capability required for Culling Vested Snake Tokens                                                 ;;
    ;;      IZ_SNAKE-NONCE-CULLABLE                 Capability enforcing Snake Nonce is cullable                                                        ;;
    ;;      CULL_VESTED_SNAKES_TOTALLY              Capability required for total culling of a vested Snake Token                                       ;;
    ;;      CULL_VESTED_SNAKES_PARTIALLY            Capability required for partial culling of a vested Snake Token                                     ;;
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
    (defcap VEST_OURO_VOURO (patron:string vester:string target-account:string ouro-input-amount:decimal)
        (let
            (
                (ouro-id:string (UR_OuroborosID))
                (v-ouro-id:string (UR_VOuroborosID))
            )
        ;;0]Only the Master Vesters can perform Vesting
            (compose-capability (VESTING_MASTER))
        ;;1]Client transfers <OURO|Ouroboros> to the <Snake_Vesting> Account
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF ouro-id client SC_NAME ouro-input-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron ouro-id vester SC_NAME ouro-input-amount true))
        ;;2]Vesting Account creates <VOURO|Vested-Ouroboros>
            (compose-capability (DPMF.DPMF_MINT patron v-ouro-id SC_NAME ouro-input-amount true))
        ;;3]Vesting Account transfers <VOURO|Vested-Ouroboros> to target-account
            ;;old: (compose-capability (DPMF.TRANSFER_DPMF v-ouro-id SC_NAME target-account ouro-input-amount true))
            (compose-capability (DPMF.TRANSFER_DPMF patron v-ouro-id SC_NAME target-account ouro-input-amount true))
        )
    )
    (defcap VEST_OURO_VAURYN (patron:string vester:string target-account:string ouro-input-amount:decimal)
        (let
            (
                (ouro-id:string (UR_OuroborosID))
                (v-auryn-id:string (UR_VAurynID))
                (auryn-output-amount:decimal (DH_SC_Autostake.UC_OuroCoil ouro-input-amount))
            )
        ;;0]Only the Master Vesters can perform Vesting
            (compose-capability (VESTING_MASTER))
        ;;1]Client transfers <OURO|Ouroboros> to the <Snake_Vesting> Account
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF ouro-id client SC_NAME ouro-input-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron ouro-id vester SC_NAME ouro-input-amount true))
        ;;2]Vesting Account coils <OURO|Ouroboros>, generating AURYN|Auryn:
            ;;uses <true> boolean since the coiler is a Smart DPTS Account, the Snake_Vesting Account
            (compose-capability (DH_SC_Autostake.COIL_OUROBOROS patron SC_NAME ouro-input-amount))
        ;;3]Vesting Account creates <VAURYN|Vested-Auryn>
            (compose-capability (DPMF.DPMF_MINT patron v-auryn-id SC_NAME auryn-output-amount true))
        ;;4]Vesting Account transfers <VAURYN|Vested-Auryn> to target-account
            ;;old: (compose-capability (DPMF.TRANSFER_DPMF v-auryn-id SC_NAME target-account auryn-output-amount true))
            (compose-capability (DPMF.TRANSFER_DPMF patron v-auryn-id SC_NAME target-account auryn-output-amount true))
        )
    )
    (defcap VEST_OURO_VEAURYN (patron:string vester:string target-account:string ouro-input-amount:decimal)
        (let
            (
                (ouro-id:string (UR_OuroborosID))
                (v-eauryn-id:string (UR_VEliteAurynID))
                (auryn-output-amount:decimal (DH_SC_Autostake.UC_OuroCoil ouro-input-amount))
            )
        ;;0]Only the Master Vesters can perform Vesting
            (compose-capability (VESTING_MASTER))
        ;;1]Client transfers <OURO|Ouroboros> to the <Snake_Vesting> Account
            ;;old (compose-capability (OUROBOROS.TRANSFER_DPTF ouro-id client SC_NAME ouro-input-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron ouro-id vester SC_NAME ouro-input-amount true))
        ;;2]Vesting Account curls <OURO|Ouroboros>, generating <EAURYN|Elite-Auryn>
            (compose-capability (DH_SC_Autostake.CURL_OUROBOROS patron SC_NAME ouro-input-amount))
        ;;3]Vesting Account creates <VEAURYN|Vested-Elite-Auryn>
            (compose-capability (DPMF.DPMF_MINT patron v-eauryn-id SC_NAME auryn-output-amount true))
        ;;4]Vesting Account transfers <VEAURYN|Vested-Elite-Auryn> to target-account
            ;;old: (compose-capability (DPMF.TRANSFER_DPMF v-eauryn-id SC_NAME target-account auryn-output-amount true))
            (compose-capability (DPMF.TRANSFER_DPMF patron v-eauryn-id SC_NAME target-account auryn-output-amount true))
        )
    )
    (defcap VEST_AURYN_VAURYN (patron:string vester:string target-account:string auryn-input-amount:decimal)
        (let
            (
                (auryn-id:string (UR_AurynID))
                (v-auryn-id:string (UR_VAurynID))
            )
        ;;0]Only the Master Vesters can perform Vesting
            (compose-capability (VESTING_MASTER))
        ;;1]Client transfers <AURYN|Auryn> to the <Snake_Vesting> Account
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF auryn-id client SC_NAME auryn-input-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron auryn-id vester SC_NAME auryn-input-amount true))
        ;;2]Vesting Account creates <VAURYN|Vested-Auryn>
            (compose-capability (DPMF.DPMF_MINT patron v-auryn-id SC_NAME auryn-input-amount true))
        ;;3]Vesting Account transfers <VAURYN|Vested-Auryn> to target-account
            ;;old: (compose-capability (DPMF.TRANSFER_DPMF v-auryn-id SC_NAME target-account auryn-input-amount true))
            (compose-capability (DPMF.TRANSFER_DPMF patron v-auryn-id SC_NAME target-account auryn-input-amount true))
        )
    )
    (defcap VEST_AURYN_VEAURYN (patron:string vester:string target-account:string auryn-input-amount:decimal)
        (let
            (
                (auryn-id:string (UR_AurynID))
                (v-eauryn-id:string (UR_VEliteAurynID))
            )
        ;;0]Only the Master Vesters can perform Vesting
        (compose-capability (VESTING_MASTER))
        ;;1]Client transfers <AURYN|Auryn> to the <Snake_Vesting> Account
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF auryn-id client SC_NAME auryn-input-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron auryn-id vester SC_NAME auryn-input-amount true))
        ;;2]Vesting Account coils <AURYN|Auryn>, generating EAURYN|Elite-Auryn
            (compose-capability (DH_SC_Autostake.COIL_AURYN patron SC_NAME auryn-input-amount))
        ;;3]Vesting Account creates <VEAURYN|Vested-Elite-Auryn>
            (compose-capability (DPMF.DPMF_MINT patron v-eauryn-id SC_NAME auryn-input-amount true))
        ;;4]Vesting Account transfers <VEAURYN|Vested-Elite-Auryn> to target-account
            ;;old: (compose-capability (DPMF.TRANSFER_DPMF v-eauryn-id SC_NAME target-account auryn-input-amount true))
            (compose-capability (DPMF.TRANSFER_DPMF patron v-eauryn-id SC_NAME target-account auryn-input-amount true))
        )
    )
    (defcap VEST_EAURYN_VEAURYN (patron:string vester:string target-account:string elite-auryn-input-amount:decimal)
        (let
            (
                (eauryn-id:string (UR_EliteAurynID))
                (v-eauryn-id:string (UR_VEliteAurynID))
            )
        ;;0]Only the Master Vesters can perform Vesting
            (compose-capability (VESTING_MASTER))
        ;;1]Client transfers <EAURYN|Elite-Auryn> to the <Snake_Vesting> Account
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF eauryn-id client SC_NAME elite-auryn-input-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron eauryn-id vester SC_NAME elite-auryn-input-amount true))
        ;;2]Vesting Account creates <VEAURYN|Vested-Elite-Auryn>
            (compose-capability (DPMF.DPMF_MINT patron v-eauryn-id SC_NAME elite-auryn-input-amount true))
        ;;3]Vesting Account transfers <VEAURYN|Vested-Elite-Auryn> to target-account
            ;;old: (compose-capability (DPMF.TRANSFER_DPMF v-eauryn-id SC_NAME target-account elite-auryn-input-amount true))
            (compose-capability (DPMF.TRANSFER_DPMF patron v-eauryn-id SC_NAME target-account elite-auryn-input-amount true))
        )
    )
    ;;==================CULLING===================== 
    ;;
    ;;      CULL_EXECUTOR|CULL_VESTED_SNAKES|IZ_SNAKE-NONCE-CULLABLE
    ;;      CULL_VESTED_SNAKES_TOTALLY|CULL_VESTED_SNAKES_PARTIALY
    ;;
    (defcap CULL_EXECUTOR ()
        true
    )
    (defcap CULL_VESTED_SNAKES (patron:string culler:string identifier:string nonce:integer)
        (let*
            (
                (initial-amount:decimal (DPMF.UR_AccountMetaFungibleBalance identifier nonce culler))
                (culled-amount:decimal (UC_CullVestingMetaDataAmount culler identifier nonce))
                (return-amount:decimal (- initial-amount culled-amount))
            )
        ;;0]Any Client can perform <C_CullVestedSnakes>; Smart DPTS Accounts arent required to provide their guards
            (compose-capability (DPMF.DPMF_CLIENT identifier patron))
        ;;1]Enforces that the MetaFungible <identifier>-<nonce> held by the <Client> Account is Cullable
            (compose-capability (IZ_SNAKE-NONCE-CULLABLE culler identifier nonce))
        ;;2]<Snake_Vesting> Account returns culled amount and remaining vested Meta-Token, if any, to client
            ;;This happens prior to <client> transferring his Vested Tokens to the <Snake_Vesting> Account
            ;;because the next functions assume client still has the Vested Tokens.
            (if (= return-amount 0.0)
                (compose-capability (CULL_VESTED_SNAKES_TOTALLY patron culler identifier nonce))
                (compose-capability (CULL_VESTED_SNAKES_PARTIALY patron culler identifier nonce))
            )
        ;;3]Client transfers as method the Vested Token|Nonce <identifier>|<nonce> to the <Snake_Vesting> Account for burning
            ;;old: (compose-capability (DPMF.TRANSFER_DPMF identifier culler SC_NAME initial-amount true))
            (compose-capability (DPMF.TRANSFER_DPMF patron identifier culler SC_NAME initial-amount true))
        ;;4]<Snake_Vesting> Account burns the Vested-MetaFungible transferred
            (compose-capability (DPMF.DPMF_BURN patron identifier SC_NAME initial-amount true))
        )
    )
    (defcap IZ_SNAKE-NONCE-CULLABLE (culler:string identifier:string nonce:integer)
        (let
            (
                (meta-data:[object{VestingMetaDataSchema}] (DPMF.UR_AccountMetaFungibleMetaData identifier nonce culler))
                (culled-meta-data:[object{VestingMetaDataSchema}] (UC_CullVestingMetaDataObject culler identifier nonce))
            )
            (enforce (!= meta-data culled-meta-data) (format "Vested MetaFungible {}-{} is not yet cullabe" [identifier nonce]))
        )
    )
    (defcap CULL_VESTED_SNAKES_TOTALLY (patron:string culler:string identifier:string nonce:integer)
        ;;4.1]<Snake_Vesting> Account transfers to <Client> Account the whole vested amount of <amount> as DPTF Token
        (let
            (
                (amount:decimal (DPMF.UR_AccountMetaFungibleBalance identifier nonce culler))
                (return-id:string (UC_OriginalCounterpart identifier))
            )
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF return-id SC_NAME client amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron return-id SC_NAME culler amount true))
        )
    )
    (defcap CULL_VESTED_SNAKES_PARTIALY (patron:string culler:string identifier:string nonce:integer)
        ;;4.1]<Snake_Vesting> Account transfers to <Client> Account the a partial vested amount of <culled-amount> as DPTF Token
        (let*
            (
                (initial-amount:decimal (DPMF.UR_AccountMetaFungibleBalance identifier nonce culler))
                (culled-amount:decimal (UC_CullVestingMetaDataAmount culler identifier nonce))
                (return-amount:decimal (- initial-amount culled-amount))
                (return-id:string (UC_OriginalCounterpart identifier))
            )
            ;;old: (compose-capability (OUROBOROS.TRANSFER_DPTF return-id SC_NAME client culled-amount true))
            (compose-capability (OUROBOROS.TRANSFER_DPTF patron return-id SC_NAME culler culled-amount true))
            (compose-capability (DPMF.DPMF_MINT patron identifier SC_NAME return-amount true))
            ;;old: (compose-capability (DPMF.TRANSFER_DPMF identifier SC_NAME culler return-amount true))
            (compose-capability (DPMF.TRANSFER_DPMF patron identifier SC_NAME culler return-amount true))

        )
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
    ;;      UC_OriginalCounterpart                  Returns the non-vested Snake Token Identifier for the input identifier                              ;;
    ;;      UC_CullVestingMetaDataAmount            Returns the amount that a cull on a vested Snake Token would produce                                ;;
    ;;      UC_CullVestingMetaDataObject            Returns the meta-data that a cull on a vested Snake Token would produce                             ;;
    ;;==================VALIDATIONS=================                                                                                                    ;;
    ;;      UV_Milestone                            Restrict Milestone integer between 1 and 365 Milestones                                             ;;
    ;;      UV_MilestoneWithTime                    Validates Milestone duration to be lower than 25 years                                              ;;
    ;;      UV_ObjectAsVestingPair                  Validates an Object as a Vesting Pair                                                               ;;
    ;;      UV_ObjectListAsVestingPairList          Validates an Object List as a List of Vesting Pairs                                                 ;;
    ;;      UV_VestedIdentifier                     Validates a Token Identifier as being one of the 3 Vested Snake Tokens Identifiers on record        ;;
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
    ;;      C_CullVestedOuroboros                   Culls Vested Ouroboros of Nonce <nonce >for <client> Account                                        ;;
    ;;      C_CullVestedAuryn                       Culls Vested Auryn of Nonce <nonce >for <client> Account                                            ;;
    ;;      C_CullVestedEliteAuryn                  Culls Vested Elite-Auryn of Nonce <nonce >for <client> Accoun                                       ;;
    ;;                                                                                                                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;                                                                                                                                                  ;;
    ;;      AUXILIARY FUNCTIONS                                                                                                                         ;;
    ;;                                                                                                                                                  ;;
    ;;      X_CullVestedSnakes                      Culls the Vested Snake Token of Nonce <nonce>, for <client> Account                                 ;;
    ;;      X_CullVestedSnakesTotally               Returns results of a total Cull                                                                     ;;
    ;;      X_CullVestedSnakesPartially             Returns results of a partial Cull                                                                   ;;
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
    ;;      UC_ComposeVestingMetaData|UC_OriginalCounterpart
    ;;      UC_CullVestingMetaDataAmount|UC_CullVestingMetaDataObject
    ;;
    (defun UC_SplitBalanceForVesting:[decimal] (identifier:string amount:decimal milestone:integer)
        @doc "Splits an Amount according to vesting parameters"
        (let*
            (

                (d:integer (OUROBOROS.UR_TrueFungibleDecimals identifier))
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
    (defun UC_ComposeVestingMetaData:[object{VestingMetaDataSchema}] (identifier:string amount:decimal offset:integer duration:integer milestone:integer)
        @doc "Creates Vesting MetaData"
        (OUROBOROS.UV_TrueFungibleAmount identifier amount)
        (UV_MilestoneWithTime offset duration milestone)

        (let*
            (
                (amount-lst:[decimal] (UC_SplitBalanceForVesting identifier amount milestone))
                (date-lst:[time] (UC_MakeVestingDateList offset duration milestone))
                (meta-data:[object{VestingMetaDataSchema}] (zip (lambda (x:decimal y:time) { "release-amount": x, "release-date": y }) amount-lst date-lst))
                
            )
            ;;(validity:bool (UV_ObjectListAsVestingPairList meta-data))
            ;;(enforce (= validity true) "Invalid Meta-Data created")
            meta-data
        )
    )
    (defun UC_OriginalCounterpart:string (identifier:string)
        @doc "Returns the non-vested Snake Token Identifier for the input identifier"

        (UV_VestedIdentifier identifier)
        (let
            (
                (vo:string (UR_VOuroborosID))
                (va:string (UR_VAurynID))
                (vea:string (UR_VEliteAurynID))
            )
            (if (= identifier vo)
                (UR_OuroborosID)
                (if (= identifier va)
                    (UR_AurynID)
                    (UR_EliteAurynID)
                )
            )
        )
    )
    (defun UC_CullVestingMetaDataAmount:decimal (client:string identifier:string nonce:integer)
        @doc "Returns the amount that a cull on a vested Snake Token would produce"
        (UV_VestedIdentifier identifier)
        (let*
            (
                (meta-data:[object{VestingMetaDataSchema}] (DPMF.UR_AccountMetaFungibleMetaData identifier nonce client))
                (culled-amount:decimal
                    (fold
                        (lambda
                            (acc:decimal item:object{VestingMetaDataSchema})
                            (let*
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
    (defun UC_CullVestingMetaDataObject:[object{VestingMetaDataSchema}] (client:string identifier:string nonce:integer)
        @doc "Returns the meta-data that a cull on a vested Snake Token would produce"
        (UV_VestedIdentifier identifier)
        (let*
            (
                (meta-data:[object{VestingMetaDataSchema}] (DPMF.UR_AccountMetaFungibleMetaData identifier nonce client))
                (culled-object:[object{VestingMetaDataSchema}]
                    (fold
                        (lambda
                            (acc:[object{VestingMetaDataSchema}] item:object{VestingMetaDataSchema})
                            (let*
                                (
                                    (date:time (at "release-date" item))
                                    (present-time:time (at "block-time" (chain-data)))
                                    (t:decimal (diff-time present-time date))
                                )
                                (if (< t 0.0)
                                    (OUROBOROS.UC_AppendLast acc item)
                                    acc
                                )
                            )
                        )
                        []
                        meta-data
                    )
                )
            )
            culled-object
        )
    )
    ;;
    ;;==================VALIDATIONS=================
    ;;
    ;;      UV_Milestone|UV_MilestoneWithTime
    ;;      UV_VestedIdentifier
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
    (defun UV_VestedIdentifier (identifier:string)
        @doc "Validates a Token Identifier as being one of the 3 Vested Snake Tokens Identifiers on record"
        (let
            (
                (vo:string (UR_VOuroborosID))
                (va:string (UR_VAurynID))
                (vea:string (UR_VEliteAurynID))
            )
            (enforce-one
                (format "{} is not a valid Vested Snake Token identifier" [identifier])
                [
                    (enforce (= identifier vo) "Identifier is not Vested Ouroborod Identifier")
                    (enforce (= identifier va) "Identifier is not Vested Auryn Identifier")
                    (enforce (= identifier vea) "Identifier is not Vested Elite-Auryn Identifier")
                ]
            )
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
    (defun A_InitialiseVesting (patron:string)
        @doc "Initialises the Vesting Module"
        ;;Initialise the Vesting DPTS Account as a Smart Account
        ;;Necesary because it needs to operate as a MultiverX Smart Contract
        (OUROBOROS.C_DeploySmartDPTSAccount SC_NAME (keyset-ref-guard SC_KEY))

        (with-capability (VESTING_INIT)
            ;;Issue Vesting Tokens below

            (let
                (
                    (ouro-id:string (DH_SC_Autostake.UR_OuroborosID))
                    (auryn-id:string (DH_SC_Autostake.UR_AurynID))
                    (elite-auryn-id:string (DH_SC_Autostake.UR_EliteAurynID))
                    (vested-ouro-id:string 
                        (DPMF.C_IssueMetaFungible
                            patron
                            SC_NAME
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
                            patron
                            SC_NAME
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
                            patron
                            SC_NAME
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
                (OUROBOROS.C_DeployTrueFungibleAccount ouro-id SC_NAME)
                (OUROBOROS.C_DeployTrueFungibleAccount auryn-id SC_NAME)
                (OUROBOROS.C_DeployTrueFungibleAccount elite-auryn-id SC_NAME)
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
                (DPMF.C_ToggleAddQuantityRole patron vested-ouro-id SC_NAME true)
                (DPMF.C_ToggleAddQuantityRole patron vested-auryn-id SC_NAME true)
                (DPMF.C_ToggleAddQuantityRole patron vested-elite-auryn-id SC_NAME true)

                (DPMF.C_ToggleBurnRole patron vested-ouro-id SC_NAME true)
                (DPMF.C_ToggleBurnRole patron vested-auryn-id SC_NAME true)
                (DPMF.C_ToggleBurnRole patron vested-elite-auryn-id SC_NAME true)

                (DPMF.C_ToggleTransferRole patron vested-ouro-id SC_NAME true)
                (DPMF.C_ToggleTransferRole patron vested-auryn-id SC_NAME true)
                (DPMF.C_ToggleTransferRole patron vested-elite-auryn-id SC_NAME true)
            )
        )
    )
    (defun A_VestOuroVOuro (patron:string vester:string target-account:string amount:decimal offset:integer duration:integer milestone:integer)
        @doc "Vests Ouroboros, sending it to target account as Vested Ouroboros \
            \ Client must present administrator keys for this to work, which is why this is not a client function"
    
        ;;0]Only the Master Vesters can perform Vesting
        (with-capability (VEST_OURO_VOURO patron vester target-account amount)
            (let
                (
                    (ouro-id:string (UR_OuroborosID))
                    (v-ouro-id:string (UR_VOuroborosID))
                )
        ;;1]Client transfers <OURO|Ouroboros> to the <Snake_Vesting> Account
                (OUROBOROS.CX_TransferTrueFungible patron ouro-id vester SC_NAME amount)
        ;;2]Vesting Account creates <VOURO|Vested-Ouroboros>
                (let*
                    (
                        (vesting-meta-data:[object{VestingMetaDataSchema}] (UC_ComposeVestingMetaData ouro-id amount offset duration milestone))
                        (new-nonce:integer (DPMF.CX_Mint patron v-ouro-id SC_NAME amount vesting-meta-data))
                    )    
        ;;3]Vesting Account transfers <VOURO|Vested-Ouroboros> to target-account
                    (DPMF.CX_TransferMetaFungible patron v-ouro-id new-nonce SC_NAME target-account amount)
                )
            )
        )
    )
    (defun A_VestOuroVAuryn (patron:string vester:string target-account:string amount:decimal offset:integer duration:integer milestone:integer)
        @doc "Vests Ouroboros, sending it to target account as Vested Auryn \
            \ Client must present administrator keys for this to work, which is why this is not a client function"
    
        ;;0]Only the Master Vesters can perform Vesting
        (with-capability (VEST_OURO_VAURYN patron vester target-account amount)
            (let
                (
                    (ouro-id:string (UR_OuroborosID))
                    (auryn-id:string (UR_AurynID))
                    (v-auryn-id:string (UR_VAurynID))
                )
        ;;1]Client transfers <OURO|Ouroboros> to the <Snake_Vesting> Account
                (OUROBOROS.CX_TransferTrueFungible patron ouro-id vester SC_NAME amount)
        ;;2]Vesting Account coils <OURO|Ouroboros>, generating AURYN|Auryn; this outputs the auryn-amount
        ;;3]Vesting Account creates <VAURYN|Vested-Auryn>; knowing the auryn-amount
                (let*
                    (
                        (auryn-amount:decimal (DH_SC_Autostake.XC_CoilOuroboros patron SC_NAME amount))
                        (vesting-meta-data:[object{VestingMetaDataSchema}] (UC_ComposeVestingMetaData auryn-id auryn-amount offset duration milestone))
                        (new-nonce:integer (DPMF.CX_Mint patron v-auryn-id SC_NAME auryn-amount vesting-meta-data))
                    )
        ;;4]Vesting Account transfers <VAURYN|Vested-Auryn> to target-account; since auryn-amount and new-nonce are now known
                    (DPMF.CX_TransferMetaFungible patron v-auryn-id new-nonce SC_NAME target-account auryn-amount)
                )
            )
        )
    )
    (defun A_VestOuroVEAuryn (patron:string vester:string target-account:string amount:decimal offset:integer duration:integer milestone:integer)
        @doc "Vests Ouroboros, sending it to target account as Vested Elite-Auryn \
            \ Client must present administrator keys for this to work, which is why this is not a client function"
    
        ;;0]Only the Master Vesters can perform Vesting
        (with-capability (VEST_OURO_VEAURYN patron vester target-account amount)
            (let
                (
                    (ouro-id:string (UR_OuroborosID))
                    (auryn-id:string (UR_AurynID))
                    (v-eauryn-id:string (UR_VEliteAurynID))
                )
        ;;1]Client transfers <OURO|Ouroboros> to the <Snake_Vesting> Account
                (OUROBOROS.CX_TransferTrueFungible patron ouro-id vester SC_NAME amount)
        ;;2]Vesting Account curls <OURO|Ouroboros>, generating <EAURYN|Elite-Auryn>; this outputs elite-auryn-amount
        ;;3]Vesting Account creates <VEAURYN|Vested-Elite-Auryn>; knowing the elite-auryn-amount
                (let*
                    (
                        (elite-auryn-amount:decimal (DH_SC_Autostake.C_CurlOuroboros patron SC_NAME amount))
                        (vesting-meta-data:[object{VestingMetaDataSchema}] (UC_ComposeVestingMetaData auryn-id elite-auryn-amount offset duration milestone))
                        (new-nonce:integer (DPMF.CX_Mint patron v-eauryn-id SC_NAME elite-auryn-amount vesting-meta-data))
                    )
        ;;4]Vesting Account transfers <VEAURYN|Vested-Elite-Auryn> to target-account; since elite-auryn-amount and new-nonce are now known
                    (DPMF.CX_TransferMetaFungible patron v-eauryn-id new-nonce SC_NAME target-account elite-auryn-amount)
                )
            )
        )
    )
    (defun A_VestAurynVAuryn(patron:string vester:string target-account:string amount:decimal offset:integer duration:integer milestone:integer)
        @doc "Vests Auryn, sending it to target account as Vested Auryn \
            \ Client must present administrator keys for this to work, which is why this is not a client function"
    
        ;;0]Only the Master Vesters can perform Vesting
        (with-capability (VEST_AURYN_VAURYN patron vester target-account amount)
            (let
                (
                    (auryn-id:string (UR_AurynID))
                    (v-auryn-id:string (UR_VAurynID))
                )
        ;;1]Client transfers <AURYN|Auryn> to the <Snake_Vesting> Account
                (OUROBOROS.CX_TransferTrueFungible patron auryn-id vester SC_NAME amount)
        ;;2]Vesting Account creates <VAURYN|Vested-Auryn>
                (let*
                    (
                        (vesting-meta-data:[object{VestingMetaDataSchema}] (UC_ComposeVestingMetaData auryn-id amount offset duration milestone))
                        (new-nonce:integer (DPMF.CX_Mint patron v-auryn-id SC_NAME amount vesting-meta-data))
                    )
                    true
        ;;3]Vesting Account transfers <VAURYN|Vested-Auryn> to target-account
                    (DPMF.CX_TransferMetaFungible patron v-auryn-id new-nonce SC_NAME target-account amount)
                )
            )
        
        )
    )
    (defun A_VestAurynVEAuryn (patron:string vester:string target-account:string amount:decimal offset:integer duration:integer milestone:integer)
        @doc "Vests Auryn, sending it to target account as Vested Elite-Auryn \
            \ Client must present administrator keys for this to work, which is why this is not a client function"

        ;;0]Only the Master Vesters can perform Vesting
        (with-capability (VEST_AURYN_VEAURYN patron vester target-account amount)
            (let
                (
                    (auryn-id:string (UR_AurynID))
                    (v-eauryn-id:string (UR_VEliteAurynID))
                )
        ;;1]Client transfers <AURYN|Auryn> to the <Snake_Vesting> Account
                (OUROBOROS.CX_TransferTrueFungible patron auryn-id vester SC_NAME amount)
        ;;2]Vesting Account coils <AURYN|Auryn>, generating EAURYN|Elite-Auryn
                (DH_SC_Autostake.C_CoilAuryn patron SC_NAME amount)
        ;3]Vesting Account creates <VEAURYN|Vested-Elite-Auryn>
                (let*
                    (
                        (vesting-meta-data:[object{VestingMetaDataSchema}] (UC_ComposeVestingMetaData auryn-id amount offset duration milestone))
                        (new-nonce:integer (DPMF.CX_Mint patron v-eauryn-id SC_NAME amount vesting-meta-data))
                    )
        ;;4]Vesting Account transfers <VEAURYN|Vested-Elite-Auryn> to target-account
                    (DPMF.CX_TransferMetaFungible patron v-eauryn-id new-nonce SC_NAME target-account amount)
                )
            )
        )
    )
    (defun A_VestEAurynVEAuryn (patron:string vester:string target-account:string amount:decimal offset:integer duration:integer milestone:integer)
        @doc "Vests Elite-Auryn, sending it to target account as Vested Elite-Auryn \
            \ Client must present administrator keys for this to work, which is why this is not a client function"
    
        ;;0]Only the Master Vesters can perform Vesting
        (with-capability (VEST_EAURYN_VEAURYN patron vester target-account amount)
            (let
                (
                    (eauryn-id:string (UR_EliteAurynID))
                    (v-eauryn-id:string (UR_VEliteAurynID))
                )
        ;;1]Client transfers <EAURYN|Elite-Auryn> to the <Snake_Vesting> Account
                (OUROBOROS.CX_TransferTrueFungible patron eauryn-id vester SC_NAME amount)
        ;;2]Vesting Account creates <VEAURYN|Vested-Elite-Auryn>
                (let*
                    (
                        (vesting-meta-data:[object{VestingMetaDataSchema}] (UC_ComposeVestingMetaData eauryn-id amount offset duration milestone))
                        (new-nonce:integer (DPMF.CX_Mint patron v-eauryn-id SC_NAME amount vesting-meta-data))
                    )
        ;;3]Vesting Account transfers <VEAURYN|Vested-Elite-Auryn> to target-account
                    (DPMF.CX_TransferMetaFungible patron v-eauryn-id new-nonce SC_NAME target-account amount)
                )
            ) 
        )
    )
    ;;--------------------------------------------;;
    ;;                                            ;;
    ;;      CLIENT FUNCTIONS                      ;;
    ;;                                            ;;
    ;;--------------------------------------------;;
    ;;
    ;;      C_CullVestedOuroboros|C_CullVestedAuryn|C_CullVestedEliteAuryn
    ;;
    (defun C_CullVestedOuroboros (patron:string culler:string nonce:integer)
        @doc "Culls Vested Ouroboros of Nonce <nonce >for <client> Account"
        (with-capability (CULL_EXECUTOR)
            (X_CullVestedSnakes patron culler (UR_VOuroborosID) nonce)
        )
    )
    (defun C_CullVestedAuryn (patron:string culler:string nonce:integer)
        @doc "Culls Vested Auryn of Nonce <nonce >for <client> Account"
        (with-capability (CULL_EXECUTOR)
            (X_CullVestedSnakes patron culler (UR_VAurynID) nonce)
        )
    )
    (defun C_CullVestedEliteAuryn (patron:string culler:string nonce:integer)
        @doc "Culls Vested Elite-Auryn of Nonce <nonce >for <client> Account"
        (with-capability (CULL_EXECUTOR)
            (X_CullVestedSnakes patron culler (UR_VEliteAurynID) nonce)
        )
    )
    ;;--------------------------------------------;;
    ;;                                            ;;
    ;;      AUXILIARY FUNCTIONS                   ;;
    ;;                                            ;;
    ;;--------------------------------------------;;
    ;;
    ;;      C_CullVestedOuroboros|C_CullVestedAuryn|C_CullVestedEliteAuryn
    ;;
    (defun X_CullVestedSnakes (patron:string culler:string identifier:string nonce:integer)
        @doc "Culls the Vested Snake Token of Nonce <nonce>, for <client> Account"
        (require-capability (CULL_EXECUTOR))
        (let*
            (
                (initial-amount:decimal (DPMF.UR_AccountMetaFungibleBalance identifier nonce culler))
                (culled-amount:decimal (UC_CullVestingMetaDataAmount culler identifier nonce))
                (return-amount:decimal (- initial-amount culled-amount))
            )
        ;;0]Any Client can perform <C_CullVestedSnakes>; Smart DPTS Accounts arent required to provide their guards
        ;;1]Enforces that the MetaFungible <identifier>-<nonce> held by the <Client> Account is Cullable
            (with-capability (CULL_VESTED_SNAKES patron culler identifier nonce)
        ;;2]<Snake_Vesting> Account returns culled amount and remaining vested Meta-Token, if any, to client
        ;;This happens prior to <client> transferring his Vested Tokens to the <Snake_Vesting> Account
        ;;because the next functions assume client still has the Vested Tokens.
                (if (= return-amount 0.0)
                    (X_CullVestedSnakesTotally patron culler identifier nonce)
                    (X_CullVestedSnakesPartially patron culler identifier nonce)
                )
        ;;3]Client transfers as method the Vested Token|Nonce <identifier>|<nonce> to the <Snake_Vesting> Account for burning
                (DPMF.CX_TransferMetaFungible patron identifier nonce culler SC_NAME initial-amount)
        ;;4]<Snake_Vesting> Account burns the Vested-MetaFungible transferred
                (DPMF.CX_Burn patron identifier nonce SC_NAME initial-amount)
            )
        )
    )
    (defun X_CullVestedSnakesTotally (patron:string culler:string identifier:string nonce:integer)
        @doc "Returns results of a total Cull"
        (require-capability (CULL_VESTED_SNAKES_TOTALLY patron culler identifier nonce))
        (let
            (
                (amount:decimal (DPMF.UR_AccountMetaFungibleBalance identifier nonce culler))
                (return-id:string (UC_OriginalCounterpart identifier))
            )
            (OUROBOROS.CX_TransferTrueFungible patron return-id SC_NAME culler amount)
        )
    )
    (defun X_CullVestedSnakesPartially (patron:string culler:string identifier:string nonce:integer)
        @doc "Returns results of a partial Cull"
        (require-capability (CULL_VESTED_SNAKES_PARTIALY patron culler identifier nonce))
        (let*
            (
                (initial-amount:decimal (DPMF.UR_AccountMetaFungibleBalance identifier nonce culler))
                (culled-amount:decimal (UC_CullVestingMetaDataAmount culler identifier nonce))
                (return-amount:decimal (- initial-amount culled-amount))
                (remaining-vesting-meta-data:[object{VestingMetaDataSchema}] (UC_CullVestingMetaDataObject culler identifier nonce))
                (return-id:string (UC_OriginalCounterpart identifier))
            )
            (OUROBOROS.CX_TransferTrueFungible patron return-id SC_NAME culler culled-amount)
            (let
                (
                    (new-nonce:integer (DPMF.CX_Mint patron identifier SC_NAME return-amount remaining-vesting-meta-data))
                )
                (DPMF.CX_TransferMetaFungible patron identifier new-nonce SC_NAME culler return-amount)
            )
        )
    )
)

(create-table TrinityTable)