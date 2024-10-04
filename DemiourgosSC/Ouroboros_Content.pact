;;Capabilities Content
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      DALOS: BASIC CAPABILITIES               Description                                                                                         ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DALOS|ACCOUNT_EXIST                     Enforces that a DALOS Account exists                                                                ;;
    ;;      DALOS|ACCOUNT_OWNER                     Enforces DALOS Account Ownership                                                                    ;;
    ;;      DALOS|IZ_ACCOUNT_SMART                  Enforces DALOS Account type to <smart>                                                              ;;
    ;;      DALOS|TRANSFERABILITY                   Enforce correct transferability between DALOS Accounts                                              ;;
    ;;      DALOS|INCREASE-NONCE                    Capability required to increment the DALOS nonce                                                    ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      DALOS: COMPOSED CAPABILITIES            Description                                                                                         ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DALOS|CLIENT                            Enforces DALOS Account ownership if its a Standard DALOC Account                                    ;;
    ;;      DALOS|METHODIC                          Enforces Account is Smart if <method> is true or Account Ownership if <method> is false             ;;
    ;;      DALOS|CONTROL_SMART-ACCOUNT             Capability required to Control a Smart DALOS Account                                                ;;
    ;;      DALOS|CONTROL_SMART-ACCOUNT_CORE        Core Capability required to Control a Smart DALOS Account                                           ;;
    ;;      DALOS|ROTATE_ACCOUNT                    Capability required to rotate(update|change) DALOS Account information (Kadena-Konto and Guard)     ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      DPTF-DPMF: BASIC CAPABILITIES           Description                                                                                         ;;
    ;;---DPTF-DPMF-PROPERTIES-TABLE-MANAGEMENT------                                                                                                    ;;
    ;;      DPTF-DPMF|OWNER                         Enforces DPTF|DPMF Token Ownership                                                                  ;;
    ;;      DPTF-DPMF|CAN-CHANGE-OWNER_ON           Enforces DPTF Token ownership is changeble                                                          ;;
    ;;      DPTF-DPMF|CAN-UPGRADE_ON                Enforces DPTF|DPMF Token is upgradeable                                                             ;;
    ;;      DPTF-DPMF|CAN-ADD-SPECIAL-ROLE_ON       Enforces adding special roles for DPTF|DPMF Token is true                                           ;;
    ;;      DPTF-DPMF|CAN-FREEZE_ON                 Enforces DPTF|DPMF Token can be frozen                                                              ;;
    ;;      DPTF-DPMF|CAN-WIPE_ON                   Enforces DPTF|DPMF Token Property can be wiped                                                      ;;
    ;;      DPTF-DPMF|CAN-PAUSE_ON                  Enforces DPTF|DPMF Token can be paused                                                              ;;
    ;;      DPTF-DPMF|PAUSE_STATE                   Enforces DPTF|DPMF Token <is-paused> to <state>                                                     ;;
    ;;      DPTF-DPMF|UPDATE_SUPPLY                 Capability required to update DPTF Supply                                                           ;;
    ;;      DPTF-DPMF|UPDATE_ROLE-TRANSFER-AMOUNT   Capability required to update DPTF Transfer-Role-Amount                                             ;;
    ;;---DPTF-DPMF-BALANCES-TABLE-MANAGEMENT--------                                                                                                    ;;
    ;;      DPTF-DPMF|ACCOUNT_EXISTANCE             Enforces <existance> Existance for the DPTF|DPMF Token Account <identifier>|<account>               ;;
    ;;      DPTF-DPMF|ACCOUNT_BURN_STATE            Enforces DPTF|DPMF Account <role-burn> to <state>                                                   ;;
    ;;      DPTF-DPMF|ACCOUNT_TRANSFER_STATE        Enforces DPTF Account <role-transfer> to <state>                                                    ;;
    ;;      DPTF-DPMF|ACCOUNT_FREEZE_STATE          Enforces DPTF|DPMF Account <frozen> to <state>                                                      ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      DPTF: COMPOSED CAPABILITIES             Description                                                                                         ;;
    ;;---CONTROL------------------------------------                                                                                                    ;;
    ;;      DPTF-DPMF|OWNERSHIP-CHANGE              Capability required to EXECUTE <DPTF-DPMF|C_ChangeOwnership> Function                               ;;
    ;;      DPTF-DPMF|OWNERSHIP-CHANGE_CORE         Core Capability required for changing DPTF|DPMF Ownership                                           ;;
    ;;      DPTF-DPMF|CONTROL                       Capability required to EXECUTE <DPTF|C_Control>|<DPMF|C_Control> Function                           ;;
    ;;      DPTF-DPMF|CONTROL_CORE                  Core Capability required for managing DPTF|DPMF Properties                                          ;;
    ;;      DPTF-DPMF|TOGGLE_PAUSE                  Capability required to EXECUTE <DPTF-DPMF|C_TogglePause> Function                                   ;;
    ;;      DPTF-DPMF|TOGGLE_PAUSE_CORE             Capability required to toggle pause for a DPTF|DPMF Token                                           ;;
    ;;      DPTF-DPMF|FROZEN-ACCOUNT                Capability required to EXECUTE <DPTF-DPMF|C_ToggleFreezeAccount> Function                           ;;
    ;;      DPTF-DPMF|FROZEN-ACCOUNT_CORE           Core Capability required to toggle freeze for a DPTF|DPMF Account                                   ;;
    ;;---TOKEN-ROLES--------------------------------                                                                                                    ;;
    ;;      DPTF-DPMF|TOGGLE_BURN-ROLE              Capability required to EXECUTE <DPTF-DPMF|C_ToggleBurnRole> Function                                ;;
    ;;      DPTF-DPMF|TOGGLE_BURN-ROLE_CORE         Core Capability required to toggle <role-burn> to a DPTF|DPMF Account for a DPTF|DPMF Token         ;;
    ;;      DPTF-DPMF|TOGGLE_TRANSFER-ROLE          Capability required to EXECUTE <DPTF-DPMF|C_ToggleTransferRole> Function                            ;;
    ;;      DPTF-DPMF|TOGGLE_TRANSFER-ROLE_CORE     Core Capability required to toggle <role-transfer> to a DPTF|DPMF Account for a DPTF|DPMF Token     ;;
    ;;---CREATE-------------------------------------                                                                                                    ;;
    ;;      DPTF-DPMF|ISSUE                         Capability required to EXECUTE a <DPTF-DPMF|C_Issue> Function                                       ;;
    ;;---DESTROY------------------------------------                                                                                                    ;;
    ;;      DPTF-DPMF|BURN                          Capability required to EXECUTE <C|DPTF-DPMF|CX_Burn> Function                                       ;;
    ;;      DPTF-DPMF|BURN_CORE                     Core Capability required to burn a DPTF|DPMF Token                                                  ;;
    ;;      DPTF-DPMF|WIPE                          Capability required to EXECUTE <DPTF-DPMF|C_Wipe> Function                                          ;;
    ;;      DPTF-DPMF|WIPE_CORE                     Core Capability required to Wipe a DPTF|DPMF Token Balance from a DPTF|DPMF Account                 ;;
    ;;---TRANSFER-----------------------------------                                                                                                    ;;
    ;;      DPTF-DPMF|TRANSFER                      Main DPTF-DPMF Transfer Capability                                                                  ;;
    ;;      DPTF-DPMF|TRANSFER_CORE                 Core DPTF-DPMF Transfer Capability                                                                  ;;
    ;;      DPTF-DPMF|CREDIT                        Capability to perform crediting operations with DPTF|DPMF Tokens                                    ;;
    ;;      DPTF-DPMF|DEBIT                         Capability to perform debiting operations on a Normal DALOS Account type for a DPTF|DPMF Token      ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      DPTF: BASIC CAPABILITIES                Description                                                                                         ;;
    ;;---DPTF-PROPERTIES-TABLE-MANAGEMENT-----------                                                                                                    ;;
    ;;      DPTF|VIRGIN                             Enforces Origin Mint hasn't been executed                                                           ;;
    ;;      DPTF|FEE-LOCK_STATE                     Enforces DPTF Token <fee-lock> to <state>                                                           ;;
    ;;      DPTF|FEE-TOGGLE_STATE                   Enforces DPTF Token <fee-toggle> to <state>                                                         ;;
    ;;      DPTF|UPDATE_FEES                        Capability required to update Fee Volumes in the DPTF Properties Schema                             ;;
    ;;---DPTF-BALANCES-TABLE-MANAGEMENT-------------                                                                                                    ;;
    ;;      DPTF|ACCOUNT_MINT_STATE                 Enforces DPTF Account <role-mint> to <state>                                                        ;;
    ;;      DPTF|ACCOUNT_FEE-EXEMPTION_STATE        Enforces DPTF Account <role-fee-exemption> to <state>                                               ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      DPTF: COMPOSED CAPABILITIES             Description                                                                                         ;;
    ;;---CONTROL------------------------------------                                                                                                    ;;
    ;;      DPTF|TOGGLE_FEE                         Capability required to EXECUTE <DPTF|C_ToggleFee> Function                                          ;;
    ;;      DPTF|TOGGLE_FEE_CORE                    Core Capability required to set to <toggle> the <fee-toggle> for a DPTF Token                       ;;
    ;;      DPTF|SET_MIN-MOVE                       Capability required to EXECUTE <DPTF|C_SetMinMove> Function                                         ;;
    ;;      DPTF|SET_MIN-MOVE_CORE                  Core Capability required to set the <min-move> value for a DPTF Token                               ;;
    ;;      DPTF|SET_FEE                            Capability required to EXECUTE <DPTF|C_SetFee> Function                                             ;;
    ;;      DPTF|SET_FEE_CORE                       Core Capability required to set the <fee-promile> for a DPTF Token                                  ;;
    ;;      DPTF|SET_FEE-TARGET                     Capability required to EXECUTE <DPTF|C_SetFeeTarget> Function                                       ;;
    ;;      DPTF|SET_FEE-TARGET_CORE                Core Capability required to set <fee-target> for a DPTF Token                                       ;;
    ;;      DPTF|TOGGLE_FEE-LOCK                    Capability required to EXECUTE <DPTF|C_ToggleFeeLock> Function                                      ;;
    ;;      DPTF|TOGGLE_FEE-LOCK_CORE               Core Capability required to set to <toggle> the <fee-lock> for a DPTF Token                         ;;
    ;;      DPTF|WITHDRAW-FEES                      Capability required to EXECUTE <DPTF|C_WithdrawFees> Function                                       ;;
    ;;      DPTF|WITHDRAW-FEES_CORE                 Core Capability required to withdraw cumulated DPTF Fees from their Standard cumulation Location    ;;
    ;;---TOKEN-ROLES--------------------------------                                                                                                    ;;
    ;;      DPTF|TOGGLE_MINT-ROLE                   Capability required to EXECUTE <DPTF|C_ToggleMintRole> Function                                     ;;
    ;;      DPTF|TOGGLE_MINT-ROLE_CORE              Core Capability required to toggle <role-mint> to a DPTF Account for a DPTF Token                   ;;
    ;;      DPTF|TOGGLE_FEE-EXEMPTION-ROLE          Capability required to toggle the <role-fee-exemption> Role                                         ;;
    ;;      DPTF|TOGGLE_FEE-EXEMPTION-ROLE_CORE     Core Capability required to toggle the <role-fee-exemption> Role                                    ;;
    ;;---CREATE-------------------------------------                                                                                                    ;;
    ;;      DPTF|MINT                               Capability required to EXECUTE <DPTF|C_Mint>|<DPTF|CX_Mint> Function                                ;;
    ;;      DPTF|MINT-ORIGIN                        Capability required to mint the Origin DPTF Mint Supply                                             ;;
    ;;      DPTF|MINT-ORIGIN_CORE                   Core Capability required to mint the Origin DPTF Mint Supply                                        ;;
    ;;      DPTF|MINT-STANDARD                      Capability required to mint a DPTF Token                                                            ;;
    ;;      DPTF|MINT-STANDARD_CORE                 Core Capability required to mint a DPTF Token                                                       ;;
    ;;---TRANSFER-----------------------------------                                                                                                    ;;
    ;;      DPTF|TRANSFER_GAS                       Capability required for moving GAS                                                                  ;;
    ;;      DPTF|TRANSFER_MIN                       Enforces the minimum transfer amount for the DPTF Token                                             ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      DPMF: BASIC CAPABILITIES                Description                                                                                         ;;
    ;;---DPMF-PROPERTIES-TABLE-MANAGEMENT-----------                                                                                                    ;;
    ;;      DPMF|CAN-TRANSFER-NFT-CREATE-ROLE_ON    Enforces DPMF Token Property as true                                                                ;;
    ;;      DPMF|INCREASE_NONCE                     Capability required to update |nonce| in the DPMF|PropertiesTable                                   ;;
    ;;---DPMF-BALANCES-TABLE-MANAGEMENT-------------                                                                                                    ;;
    ;;      DPMF|ACCOUNT_ADD-QUANTITY_STATE         Enforces DPMF Account <role-nft-add-quantity> to <state>                                            ;;
    ;;      DPMF|ACCOUNT_CREATE_STATE               Enforces DPMF Account <role-nft-create> to <state>                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      DPMF: COMPOSED CAPABILITIES             Description                                                                                         ;;
    ;;---TOKEN-ROLES--------------------------------                                                                                                    ;;
    ;;      DPMF|MOVE_CREATE-ROLE                   Capability required to EXECUTE <DPMF|C_MoveCreateRole> Function                                     ;;
    ;;      DPMF|MOVE_CREATE-ROLE_CORE              Core Capability required to set <role-nft-create> for a DPMF Account of a DPMF Token                ;;
    ;;      DPMF|TOGGLE_ADD-QUANTITY-ROLE           Capability required to EXECUTE <DPMF|C_ToggleAddQuantityRole> Function                              ;;
    ;;      DPMF|TOGGLE_ADD-QUANTITY-ROLE_CORE      Core Capability required to toggle <role-nft-add-quantity> for a DPMF Account                       ;;
    ;;---CREATE-------------------------------------                                                                                                    ;;
    ;;      DPMF|MINT                               Capability required to EXECUTE <DPMF|C_Mint>|<DPMF|CX_Mint> Function                                ;;
    ;;      DPMF|MINT_CORE                          Core Capability required to mint a DPMF Token                                                       ;;
    ;;      DPMF|CREATE                             Capability that allows creation of a new MetaFungilbe nonce                                         ;;
    ;;      DPMF|CREATE_CORE                        Core Capability that allows creation of a new MetaFungilbe nonce                                    ;;
    ;;      DPMF|ADD-QUANTITY                       Capability required to add-quantity for a DPMF Token                                                ;;
    ;;      DPMF|ADD-QUANTITY_CORE                  Core Capability required to add-quantity for a DPMF Token                                           ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      GAS: BASIC CAPABILITIES                 Description                                                                                         ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      GAS|VIRTUAL_STATE                       Enforces <virtual-gas-toggle> to <state>                                                            ;;
    ;;      GAS|NATIVE_STATE                        Enforces <native-gas-toggle> to <state>                                                             ;;
    ;;      GAS|COLLECT_KDA                         Capability needed to Collect KDA Fees                                                               ;;
    ;;      GAS|INCREMENT                           Capability required to increment Gas Spent                                                          ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      GAS: COMPOSED CAPABILITIES              Description                                                                                         ;;
    ;;---GAS-CONTROL--------------------------------                                                                                                    ;;
    ;;      GAS|INITIALIZE_SET-ROLES                Capability needed when setting Roles within the GAS Initialisation Function                         ;;
    ;;      GAS|UPDATE_IDS                          Capability Required to update GAS id                                                                ;;
    ;;      GAS|TOGGLE                              Capability required to toggle virtual or native GAS to either on or off                             ;;
    ;;---GAS-HANDLING-------------------------------                                                                                                    ;;
    ;;      GAS|MATRON_SOFT                         Capability needed to be a gas payer for a patron with a sender                                      ;;
    ;;      GAS|MATRON_STRONG                       Capability needed to be a gas payer for a patron with a sender and receiver                         ;;
    ;;      GAS|PATRON                              Capability that ensures a DALOS account can act as gas payer, also enforcing its Guard              ;;
    ;;      GAS|MAKE                                Capability required to produce GAS                                                                  ;;
    ;;      GAS|COMPRESS                            Capability required to compress GAS                                                                 ;;
    ;;      GAS|COLLECTION                          Capability required to collect GAS                                                                  ;;
    ;;      GAS|COLLECTER_STANDARD                  Capability required to collect GAS when Normal DALOS accounts are involved as clients               ;;
    ;;      GAS|COLLECTER_SMART                     Capability required to collect GAS when Smart DALOS accounts are involved as clients                ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    








    ;;Functions CONTENT
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      DALOS: UTILITY FUNCTIONS                 Description                                                                                        ;;
    ;;---ACCOUNT-INFO-------------------------------                                                                                                    ;;
    ;;      DALOS|UR_AccountGuard                   Returns DALOS Account <account> Guard                                                               ;;
    ;;      DALOS|UR_AccountProperties              Returns a boolean list with DALOS Account Type Properties                                           ;;
    ;;      DALOS|UR_AccountType                    Returns DALOS Account <account> Boolean type                                                        ;;
    ;;      DALOS|UR_AccountPayableAs               Returns DALOS Account <account> Boolean payables-as-smart-contract                                  ;;
    ;;      DALOS|UR_AccountPayableBy               Returns DALOS Account <account> Boolean payables-by-smart-contract                                  ;;
    ;;      DALOS|UR_AccountNonce                   Returns DALOS Account <account> nonce value                                                         ;;
    ;;      DALOS|UR_AccountKadena                  Returns DALOS Account <kadena-konto> Account                                                        ;;
    ;;      DALOS|UP_AccountProperties              Prints DALOS Account <account> Properties                                                           ;;
    ;;---DALOS-PRICE-INFO---------------------------                                                                                                    ;;
    ;;      DALOS|UR_Standard                       Returns the KDA price to deploy a Standard DALOS Account                                            ;;
    ;;      DALOS|UR_Smart                          Returns the KDA price to deploy a Smart DALOS Account                                               ;;
    ;;      DALOS|UR_True                           Returns the KDA price to issue a True Fungible Token                                                ;;
    ;;      DALOS|UR_Meta                           Returns the KDA price to issue a Meta Fungible Token                                                ;;
    ;;      DALOS|UR_Semi                           Returns the KDA price to issue a Semi Fungible Token                                                ;;
    ;;      DALOS|UR_Non                            Returns the KDA price to issue a Non Fungible Token                                                 ;;
    ;;      DALOS|UR_Blue                           Returns the KDA price for a Blue Check                                                              ;;
    ;;---COMPUTING----------------------------------                                                                                                    ;;
    ;;      DALOS|UC_AccountsTransferability        Computes transferability between 2 DALOS Accounts, <sender> and <receiver>                          ;;
    ;;      DALOS|UC_FilterIdentifier               Helper Function needed for returning DALOS identifiers for Account <account>                        ;;
    ;;      DALOS|UC_MakeIdentifier                 Creates a DALOS Identifier                                                                          ;;
    ;;---VALIDATIONS--------------------------------                                                                                                    ;;
    ;;      DALOS|UV_SenderWithReceiver             Validates Account <sender> with Account <receiver> for Transfer                                     ;;
    ;;      DALOS|UV_Account                        Enforces that Account <account> ID meets charset and length requirements                            ;;
    ;;      DALOS|UV_Account_Two                    Validates 2 DALOS Accounts                                                                          ;;
    ;;      DALOS|UV_Account_Three                  Validates 3 DALOS Accounts                                                                          ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      DALOS: ADMINISTRATION FUNCTIONS         Description                                                                                         ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DALOS|A_Initialise                      Main administrative function that initialises the DALOS Virtual Blockchain                          ;;
    ;;      DALOS|A_UpdateStandard                  Updates DALOS Kadena Cost for deploying a Standard DALOS Account                                    ;;
    ;;      DALOS|A_UpdateSmart                     Updates DALOS Kadena Cost for deploying a Smart DALOS Account                                       ;;
    ;;      DALOS|A_UpdateTrue                      Updates DALOS Kadena Cost for issuing a DPTF Token                                                  ;;
    ;;      DALOS|A_UpdateMeta                      Updates DALOS Kadena Cost for issuing a DPMF Token                                                  ;;
    ;;      DALOS|A_UpdateSemi                      Updates DALOS Kadena Cost for issuing a DPSF Token                                                  ;;
    ;;      DALOS|A_UpdateNon                       Updates DALOS Kadena Cost for issuing a DPNF Token                                                  ;;
    ;;      DALOS|A_UpdateBlue                      Updates DALOS Kadena Cost for the Blue Checker                                                      ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      DALOS: CLIENT FUNCTIONS                 Description                                                                                         ;;
    ;;---CONTROL------------------------------------                                                                                                    ;;
; 10;;      DALOS|C_DeployStandardAccount           Deploys a Standard DALOS Account                                                                    ;;
; 20;;      DALOS|C_DeploySmartAccount              Deploys a Smart DALOS Account                                                                       ;;
    ;;2     DALOS|C_RotateGuard                     Updates the Guard stored in the DALOS|AccountTable                                                  ;;
    ;;2     DALOS|C_ControlSmartAccount             Manages a Smart DALOS Account                                                                       ;;
    ;;2     DALOS|C_RotateKadena                    Updates the Kadena Account stored in the DALOS|AccountTable                                         ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      DALOS: AUXILIARY FUNCTIONS              Description                                                                                         ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DALOS|X_IncrementNonce                  Increments <identifier> DALOS Account nonce                                                         ;;
    ;;      DALOS|X_RotateGuard                     Updates DALOS Account Parameters                                                                    ;;
    ;;      DALOS|X_UpdateSmartAccountParameters    Updates DALOS Account Parameters                                                                    ;;
    ;;      DALOS|X_RotateKadena                    Updates DALOS Account Parameters                                                                    ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      DPTF-DPMF: UTILITY FUNCTIONS            Description                                                                                         ;;
    ;;---ACCOUNT-INFO-------------------------------                                                                                                    ;;
    ;;      DPTF-DPMF|UR_AccountExist               Checks if DPTF|DPMF Account <account> exists for DPTF|DPMF Token id <identifier>                    ;;
    ;;      DPTF-DPMF-ATS|UR_FilterKeysForInfo      Returns a List of either True- or Meta-Fungible Identifiers held by DPTF Accounts <account>         ;;
    ;;      DPTF-DPMF|UR_AccountSupply              Returns Account <account> True or MEta Fungible <identifier> Supply                                 ;;
    ;;      DPTF-DPMF|UR_AccountRoleBurn            Returns Account <account> True or Meta Fungible <identifier> Burn Role                              ;;
    ;;      DPTF-DPMF|UR_AccountRoleTransfer        Returns Account <account> True or Meta Fungible <identifier> Transfer Role                          ;;
    ;;---TRUE-META-FUNGIBLE-INFO--------------------                                                                                                    ;;
    ;;      DPTF-DPMF|UR_Konto                      Returns <owner-konto> for the DPTF|DPMF <identifier>                                                ;;
    ;;      DPTF-DPMF|UR_Name                       Returns <name> for the DPTF|DPMF <identifier>                                                       ;;
    ;;      DPTF-DPMF|UR_Ticker                     Returns <ticker> for the DPTF|DPMF <identifier>                                                     ;;
    ;;      DPTF-DPMF|UR_Decimals                   Returns <decimals> for the DPTF|DPMF <identifier>                                                   ;;
    ;;      DPTF-DPMF|UR_CanChangeOwner             Returns <can-change-owner> for the DPTF|DPMF <identifier>                                           ;;
    ;;      DPTF-DPMF|UR_CanUpgrade                 Returns <can-upgrade> for the DPTF|DPMF <identifier>                                                ;;
    ;;      DPTF-DPMF|UR_CanAddSpecialRole          Returns <can-add-special-role> for the DPTF|DPMF <identifier>                                       ;;
    ;;      DPTF-DPMF|UR_CanFreeze                  Returns <can-freeze> for the DPTF|DPMF <identifier>                                                 ;;
    ;;      DPTF-DPMF|UR_CanWipe                    Returns <can-wipe> for the DPTF|DPMF <identifier>                                                   ;;
    ;;      DPTF-DPMF|UR_CanPause                   Returns <can-pause> for the DPTF|DPMF <identifier>                                                  ;;
    ;;      DPTF-DPMF|UR_Paused                     Returns <is-paused> for the DPTF|DPMF <identifier>                                                  ;;
    ;;      DPTF-DPMF|UR_Supply                     Returns <supply> for the DPTF|DPMF <identifier>                                                     ;;
    ;;      DPTF-DPMF|UR_TransferRoleAmount         Returns <role-transfer-amount> for the DPTF|DPMF <identifier>                                       ;;
    ;;---VALIDATIONS--------------------------------                                                                                                    ;;
    ;;      DPTF-DPMF|UV_Amount                     Enforce the minimum denomination for a specific DPTF|DPMF identifier                                ;;
    ;;      DPTF-DPMF|UC_AmountCheck                Checks if the supplied amount is valid with the decimal denomination of the identifier              ;;
    ;;      DPTF-DPMF|UV_Identifier                 Enforces the True or MetaFungible <identifier> exists                                               ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      DPTF: CLIENT FUNCTIONS                  Description                                                                                         ;;
    ;;---CONTROL------------------------------------                                                                                                    ;;
    ;;5     DPTF-DPMF|C_ChangeOwnership             Moves DPTF|DPMF <identifier> Token Ownership to <new-owner> DPTF|DPMF Account                       ;;
    ;;3     DPTF-DPMF|C_TogglePause                 Pause/Unpause True|Meta-Fungible <identifier> via the boolean <toggle>                              ;;
    ;;4     DPTF-DPMF|C_ToggleFreezeAccount         Freeze/Unfreeze via boolean <toggle> True|Meta-Fungile <identifier> on DPTF Account <account>       ;;
    ;;---TOKEN-ROLES--------------------------------                                                                                                    ;;
    ;;2     DPTF-DPMF|C_ToggleBurnRole              Sets |role-burn| to <toggle> bool for T|M-Fungible <identifier> and DPTF|DPMF Account <account>     ;;
    ;;2     DPTF-DPMF|C_ToggleTransferRole          Sets |role-transfer| to <toggle> bool for T|M-Fungible <identifier> and DPTF|DPMF Account <account> ;;
    ;;---CREATE-------------------------------------                                                                                                    ;;
    ;;      DPTF-DPMF|C_DeployAccount               Creates a new DPTF|DPMF Account for True|Meta-Fungible <identifier> and Account <account>           ;;
    ;;---DESTROY------------------------------------                                                                                                    ;;
    ;;5     DPTF-DPMF|C_Wipe                        Wipes the whole supply of <identifier> True|Meta-Fungible of a frozen DPTF|DPMF Account <account>   ;;
    ;;---UPDATE-------------------------------------                                                                                                    ;;
    ;;      DPTF-DPMF|X_UpdateSupply                Updates <identifier> True|Meta-Fungible supply. Boolean <direction> used for increase|decrease      ;;
    ;;      DPTF-DPMF|X_UpdateRoleTransferAmount    Updates <role-transfer-amount> for Token <identifier>                                               ;;
    ;;---AUX----------------------------------------                                                                                                    ;;
    ;;      DPTF-DPMF|X_ChangeOwnership                                                                                                                 ;;
    ;;      DPTF-DPMF|X_TogglePause                                                                                                                     ;;
    ;;      DPTF-DPMF|X_ToggleFreezeAccount                                                                                                             ;;
    ;;      DPTF-DPMF|X_ToggleBurnRole                                                                                                                  ;;
    ;;      DPTF-DPMF|X_ToggleTransferRole                                                                                                              ;;
    ;;      DPTF-DPMF|X_Wipe                                                                                                                            ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      DPTF: UTILITY FUNCTIONS                 Description                                                                                         ;;
    ;;---ACCOUNT-INFO-------------------------------                                                                                                    ;;
    ;;      DPTF|UR_AccountRoleMint                 Returns Account <account> True Fungible <identifier> Mint Role                                      ;;
    ;;      DPTF|UR_AccountRoleFeeExemption         Returns Account <account> True Fungible <identifier> Fee Exemption Role                             ;;
    ;;      DPTF-DPMF|UR_AccountFrozenState         Returns Account <account> True or Meta Fungible <identifier> Frozen State                           ;;
    ;;---TRUE-FUNGIBLE-INFO-------------------------                                                                                                    ;;
    ;;      DPTF|UR_OriginMint                      Returns <origin-mint> for the DPTF <identifier>                                                     ;;
    ;;      DPTF|UR_OriginAmount                    Returns <origin-mint-amount> for the DPTF <identifier>                                              ;;
    ;;      DPTF|UR_FeeToggle                       Returns <fee-toggle> for the DPTF <identifier>                                                      ;;
    ;;      DPTF|UR_MinMove                         Returns <min-move> for the DPTF <identifier>                                                        ;;
    ;;      DPTF|UR_FeePromile                      Returns <fee-promile> for the DPTF <identifier>                                                     ;;
    ;;      DPTF|UR_FeeTarget                       Returns <fee-target> for the DPTF <identifier>                                                      ;;
    ;;      DPTF|UR_FeeLock                         Returns <fee-lock> for the DPTF <identifier>                                                        ;;
    ;;      DPTF|UR_FeeUnlocks                      Returns <fee-unlocks> for the DPTF <identifier>                                                     ;;
    ;;      DPTF|UR_PrimaryFeeVolume                Returns <primary-fee-volume> for the DPTF <identifier>                                              ;;
    ;;      DPTF|UR_SecondaryFeeVolume              Returns <secondary-fee-volume> for the DPTF <identifier>                                            ;;
    ;;---COMPUTING----------------------------------                                                                                                    ;;
    ;;      DPTF|UC_VolumetricTax                   Computes the Volumetric-Transaction-Tax (VTT), given an DTPF <identifier> and <amount>              ;;
    ;;      DPTF|UC_Fee                             Computes Fee values for a DPTF Token <identifier> and <amount>                                      ;;
    ;;      DPTF|UC_UnlockPrice                     Computes the <fee-lock> unlock price for a DPTF <identifier>                                        ;;
    ;;      DPTF|UC_TransferFeeAndMinException      Computes if there is a DPTF Fee or Min Transfer Amount Exception                                    ;;
    ;;---COMPOSING----------------------------------                                                                                                    ;;
    ;;      DPTF|UC_Pair_ID-Amount                  Creates an ID-Amount Pair (used in Multi DPTF Transfer)                                             ;;
    ;;      DPTF|UC_Pair_Receiver-Amount            Create a Receiver-Amount Pair (used in Bulk DPTF Transfer)                                          ;;
    ;;---VALIDATIONS--------------------------------                                                                                                    ;;
    ;;      DPTF|UV_Pair_ID-Amount                  Checks an ID-Amount Pair to be conform so that a Multi DPTF Transfer can properly take place        ;;
    ;;      DPTF|UV_Pair_Receiver-Amount            Checks an Receiver-Amount pair to be conform with a token identifier for Bulk Transfer purposes     ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      DPTF: ADMINISTRATION FUNCTIONS          Description                                                                                         ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      DPTF|AX_InitialiseOuroboros             Initialises the OUROBOROS Smart DALOS Account                                                       ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      DPTF: CLIENT FUNCTIONS                  Description                                                                                         ;;
    ;;---CONTROL------------------------------------                                                                                                    ;;
    ;;2     DPTF|C_Control                          Controls TrueFungible <identifier> Properties using 6 boolean control triggers                      ;;
    ;;2     DPTF|C_ToggleFee                        Toggles <fee-toggle> for the DPTF Token <identifier> to <toggle>                                    ;;
    ;;2     DPTF|C_SetMinMove                       Sets the <min-move> for the DPTF Token <identifier> to <min-move-value>                             ;;
    ;;2     DPTF|C_SetFee                           Sets the <fee-promile> for the DPTF Token <identifier> to <fee>                                     ;;
    ;;2     DPTF|C_SetFeeTarget                     Sets the <fee-target> for the DPTF Token <identifier> to <target>                                   ;;
    ;;2     DPTF|C_ToggleFeeLock                    Sets the <fee-lock> for the DPTF Token <identifier> to <toggle>                                     ;;
    ;;2     DPTF|C_WithdrawFees                     Withdraws cumulated Primary Fees from the Fee Carrier Account (Ouroboros Smart DALOS Account)       ;;
    ;;---TOKEN-ROLES--------------------------------                                                                                                    ;;
    ;;2     DPTF|C_ToggleMintRole                   Sets |role-mint| to <toggle> bool for TrueFungible <identifier> and DPTF Account <account>          ;;
    ;;2     DPTF|C_ToggleFeeExemptionRole           Sets |role-fee-exemption| to <toggle> bool for TrueFungible <identifier> and DPTF Account <account> ;;
    ;;---CREATE-------------------------------------                                                                                                    ;;
    ;;15    DPTF|C_Issue                            Issue a new DALOS TrueFungible Token                                                                ;;
    ;;5|2   DPTF|CM_Mint
    ;;5|2   DPTF|C_Mint                             Mints <amount> <identifier> TrueFungible for DPTF Account <account>                                 ;;
    ;;5|2   DPTF|CX_Mint                            Methodic, similar to |DPTF|C_Mint| for Smart-DALOS Account type operation                           ;;
    ;;---DESTROY------------------------------------                                                                                                    ;;
    ;;2     DPTF|CM_Burn
    ;;2     DPTF|C_Burn                             Burns <amount> <identifier> True-Fungible on DPTF Account <account>                                 ;;
    ;;2     DPTF|CX_Burn                            Methodic, similar to |DPTF|C_Burn| for Smart-DALOS Account type operation                           ;;
    ;;---TRANSFER-----------------------------------                                                                                                    ;;
    ;;1     DPTF|CM_Transfer
    ;;1     DPTF|C_Transfer                         Transfers <identifier> TrueFungible from <sender> to <receiver> DPTF Account                        ;;
    ;;1     DPTF|CX_Transfer                        Methodic, Similar to |DPTF|C_Transfer| for Smart-DALOS Account type operation                       ;;
    ;;x     DPTF|C_MultiTransfer                    Executes a Multi DPTF transfer using 2 lists of multiple IDs and multiple transfer amounts          ;;
    ;;x     DPTF|C_BulkTransfer                     Executes a Bulk DPTF transfer using 2 lists of multiple Receivers and multiple transfer amounts     ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      DPTF: AUXILIARY FUNCTIONS               Description                                                                                         ;;
    ;;---TRANSFER-----------------------------------                                                                                                    ;;
    ;;      DPTF|X_Transfer                         Transfers <identifier> TrueFungible from <sender> to <receiver> DPTF Account without GAS            ;;
    ;;      DPTF|X_MultiTransferPaired              Helper Function needed for making a Multi DPTF Transfer possible                                    ;;
    ;;      DPTF|X_BulkTransferPaired               Helper Function needed for making a Bulk DPTF Transfer possible                                     ;;
    ;;      DPTF|X_Credit                           Auxiliary Function that credits a TrueFungible to a DPTF Account                                    ;;
    ;;      DPTF|X_Debit                            Auxiliary Function that debits a TrueFungible from a DPTF Account                                   ;;
    ;;---UPDATE-------------------------------------                                                                                                    ;;
    ;;      DPTF|X_UpdateFeeVolume                  Updates Primrary Fee Volume for DPTF <identifier> with <amount>                                     ;;
    ;;---AUX----------------------------------------                                                                                                    ;;
    ;;      DPTF|X_Control                                                                                                                              ;;
    ;;      DPTF|X_ToggleFee                                                                                                                            ;;
    ;;      DPTF|X_SetMinMove                                                                                                                           ;;
    ;;      DPTF|X_SetFee                                                                                                                               ;;
    ;;      DPTF|X_SetFeeTarget                                                                                                                         ;;
    ;;      DPTF|X_ToggleFeeLock                                                                                                                        ;;
    ;;      DPTF|X_WithdrawFees                                                                                                                         ;;
    ;;      DPTF|X_ToggleMintRole                                                                                                                       ;;
    ;;      DPTF|X_ToggleFeeExemptionRole                                                                                                               ;;
    ;;      DPTF|X_Issue                                                                                                                                ;;
    ;;      DPTF|X_Mint                                                                                                                                 ;;
    ;;      DPTF|X_Burn                                                                                                                                 ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      DPMF: UTILITY FUNCTIONS                 Description                                                                                         ;;
    ;;---ACCOUNT-INFO-------------------------------                                                                                                    ;;
    ;;      DPMF|UR_AccountUnit                     Returns Account <account> Meta Fungible <identifier> Unit                                           ;;
    ;;      DPMF|UR_AccountRoleNFTAQ                Returns Account <account> Meta Fungible <identifier> NFT Add Quantity Role                          ;;
    ;;      DPMF|UR_AccountRoleCreate               Returns Account <account> Meta Fungible <identifier> Create Role                                    ;;
    ;;---NONCE--------------------------------------                                                                                                    ;;
    ;;      DPMF|UR_AccountBalances                 Returns a list of Balances that exist for MetaFungible <identifier> on DPMF Account <account>       ;;
    ;;      DPMF|UR_AccountNonces                   Returns a list of Nonces that exist for MetaFungible <identifier> held by DPMF Account <account>    ;;
    ;;      DPMF|UR_AccountBatchSupply              Returns the supply of a MetaFungible Batch (<identifier> & <nonce>) held by DPMF Account <account>  ;;
    ;;      DPMF|UR_AccountBatchMetaData            Returns the Meta-Data of a MetaFungible Batch (<identifier> & <nonce>) held by DPMF Account <account>;
    ;;---META-FUNGIBLE-INFO-------------------------                                                                                                    ;;
    ;;      DPMF|UR_CanTransferNFTCreateRole        Returns <can-transfer-nft-create-role> for the DPMF <identifier>                                    ;;
    ;;      DPMF|UR_CreateRoleAccount               Returns <create-role-account> for the DPMF <identifier>                                             ;;
    ;;      DPMF|UR_NoncesUsed                      Returns <nonces-used> for the DPMF <identifier>                                                     ;;
    ;;---COMPOSING----------------------------------                                                                                                    ;;
    ;;      DPMF|UC_Compose                         Composes a Meta-Fungible object from <nonce>, <balance> and <meta-data>                             ;;
    ;;      DPMF|UC_Pair_Nonce-Balance              Composes a Nonce-Balance object from a <nonce-lst> list and <balance-lst> list                      ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      DPTF: CLIENT FUNCTIONS                  Description                                                                                         ;;
    ;;---CONTROL------------------------------------                                                                                                    ;;
    ;;2     DPMF|C_Control                          Controls MetaFungible <identifier> Properties using 7 boolean control triggers                      ;;
    ;;---TOKEN-ROLES--------------------------------                                                                                                    ;;
    ;;5     DPMF|C_MoveCreateRole                   Moves |role-nft-create| from <sender> to <receiver> DPMF Account for MetaFungible <identifier>      ;;
    ;;2     DPMF|C_ToggleAddQuantityRole            Sets |role-nft-add-quantity| to <toggle> bool for MetaFung. <identifier> and DPMF Account <account> ;;
    ;;---CREATE-------------------------------------                                                                                                    ;;
    ;;15    DPMF|C_Issue                            Issue a new DALOS MetaFungible                                                                      ;;
    ;;3     DPMF|CM_Mint
    ;;3     DPMF|C_Mint                             Mints <amount> <identifier> MetaFungibles with <meta-data> meta-data for DPMF Account <account>     ;;
    ;;3     DPMF|CX_Mint                            Methodic, similar to |C_Mint| for Smart-DPTS Account type operation                                 ;;
    ;;2     DPMF|CM_Create
    ;;2     DPMF|C_Create                           Creates a 0.0 balance <identifier> MetaFung. with <meta-data> meta-data for DPMF Account <account>  ;;
    ;;2     DPMF|CX_Create                          Methodic, similar to |C_Create| for Smart-DPTS Account type operation                               ;;
    ;;2     DPMF|CM_AddQuantity
    ;;2     DPMF|C_AddQuantity                      Adds <amount> quantity to existing Metafungible <identifer> and <nonce> for DPMF Account <account>  ;;
    ;;2     DPMF|CX_AddQuantity                     Methodic, similar to |C_AddQuantity| for Smart-DPTS Account type operation                          ;;
    ;;---DESTROY------------------------------------                                                                                                    ;;
    ;;2     DPMF|CM_Burn
    ;;2     DPMF|C_Burn                             Burns <amount> <identifier> Meta-Fungible on DPMF Account <account>                                 ;;
    ;;2     DPMF|CX_Burn                            Methodic, similar to |DPMF|C_Burn| for Smart-DALOS Account type operation                           ;;
    ;;---TRANSFER-----------------------------------                                                                                                    ;;
    ;;1     DPMF|CM_Tranfer
    ;;1     DPMF|C_Transfer                         Transfers <identifier> MetaFungible with Nonce <nonce> from <sender> to <receiver> DPMF Account     ;;
    ;;1     DPMF|CX_Transfer                        Methodic, Similar to |DPMF|C_Transfer| for Smart-DPTS Account type operation                        ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      DPTF: AUXILIARY FUNCTIONS               Description                                                                                         ;;
    ;;---TRANSFER-----------------------------------                                                                                                    ;;
    ;;      DPMF|X_Transfer                         Transfers <identifier> MetaFungible from <sender> to <receiver> DPMF Account without GAS            ;;
    ;;      DPMF|X_Credit                           Auxiliary Function that credit a MetaFungible to a DPMF Account                                     ;;
    ;;      DPMF|X_Debit                            Auxiliary Function that debits a MetaFungible from a DPMF Account                                   ;;
    ;;      DPMF|X_DebitMultiple                    Auxiliary Function needed for Wiping                                                                ;;
    ;;      DPMF|X_DebitPaired                      Helper Function designed for making |X_DebitMultiple| possible, which is needed for Wiping          ;;
    ;;---UPDATE-------------------------------------                                                                                                    ;;
    ;;      DPMF|X_IncrementNonce                   Increments <identifier> MetaFungible nonce                                                          ;;
    ;;---AUX----------------------------------------                                                                                                    ;;
    ;;      DPMF|X_Control                                                                                                                              ;;
    ;;      DPMF|X_MoveCreateRole                                                                                                                       ;;
    ;;      DPMF|X_ToggleAddQuantityRole                                                                                                                ;;
    ;;      DPMF|X_Issue                                                                                                                                ;;
    ;;      DPMF|X_Mint                                                                                                                                 ;;
    ;;      DPMF|X_Create                                                                                                                               ;;
    ;;      DPMF|X_AddQuantity                                                                                                                          ;;
    ;;      DPMF|X_Burn                                                                                                                                 ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;
    ;;                                                                                                                                                  ;;
    ;;      GAS: UTILITY FUNCTIONS                  Description                                                                                         ;;
    ;;---Virtual-GAS-INFO---------------------------                                                                                                    ;;
    ;;      GAS|UR_SourceID                         Returns the <gas-source-id> DPTF Token identifier saved in the GAS|PropertiesTable                  ;;
    ;;      GAS|UR_SourcePrice                      Returns the <gas-source-price> saved in the GAS|PropertiesTable                                     ;;
    ;;      GAS|UR_ID                               Returns <virtual-gas-id> DPTF Token identifier saved in the GAS|PropertiesTable                     ;;
    ;;      GAS|UR_VirtualToggle                    Returns the <virtual-gas-toggle> saved in the GAS|PropertiesTable                                   ;;
    ;;      GAS|UR_Tanker                           Returns the <virtual-gas-tank> Smart DALOS Account saved in the GAS|PropertiesTable                 ;;
    ;;      GAS|UR_VirtualSpent                     Returns the <virtual-gas-spent> saved in the GAS|PropertiesTable                                    ;;
    ;;      GAS|UR_NativeSpent                      Returns the <native-gas-spent> saved in the GAS|PropertiesTable                                     ;;
    ;;---COMPUTING---------------------------------                                                                                                     ;;
    ;;      GAS|UC_Make                             Computes amount of GAS that can be made from the input <gas-source-amount>                          ;;
    ;;      GAS|UC_Compress                         Computes amount of Gas-Source that can be created from an input amount <gas-amount> of GAS          ;;
    ;;      GAS|UC_ZeroGAZ                          Returns true if Virtual GAS cost is Zero (not yet toggled), otherwise returns false (s + r)         ;;
    ;;      GAS|UC_ZeroGAS                          Returns true if Virtual GAS cost is Zero (not yet toggled), otherwise returns false (s only)        ;;
    ;;      GAS|UC_Zero                             Function needed for <GAS|UC_ZeroGAS>                                                                ;;
    ;;      GAS|UC_SubZero                          Function needed for <GAS|UC_Zero>                                                                   ;;
    ;;      GAS|UC_NativeSubZero                    Returns true if Native GAS cost is Zero (not yet toggled), otherwise returns false                  ;;
    ;;      GAS|UC_KadenaSplit                      Computes the KDA Split required for Native Gas Collection                                           ;;                                                                                                                                               ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      GAS: ADMINISTRATION FUNCTIONS           Description                                                                                         ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      GAS|AX_InitialiseGasTanker              Initialises the GAS Table                                                                           ;;
    ;;      GAS|A_SetIDs                            Sets the Gas-Source|Gas Identifier for the Virtual Blockchain                                       ;;
    ;;      GAS|A_SetSourcePrice                    Sets the Gas Source Price, which determines how much GAS can be created from Gas Source Token       ;;
    ;;      GAS|A_Toggle                            Turns Native or Virtual Gas collection to <toggle>                                                  ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      GAS: CLIENT FUNCTIONS                   Description                                                                                         ;;
    ;;----------------------------------------------                                                                                                    ;;
    ;;      GAS|C_Make                              Generates GAS from GAS Source Token via GAS Making|Creation                                         ;;
    ;;      GAS|C_Compress                          Generates Gas-Source from GAS Token via GAS Compression                                             ;;
    ;;--------------------------------------------------------------------------------------------------------------------------------------------------;;
    ;;      GAS: AUXILIARY FUNCTIONS                Description                                                                                         ;;
    ;;---GAS-TABLE-UPDATES--------------------------                                                                                                    ;;
    ;;      GAS|X_UpdateSourceID                    Updates <gas-source-id> existing in the GAS|PropertiesTable                                         ;;
    ;;      GAS|X_UpdateSourcePrice                 Updates <gas-source-price> existing in the GAS|PropertiesTable                                      ;;
    ;;      GAS|X_UpdateID                          Updates <virtual-gas-id> existing in the GAS|PropertiesTable                                        ;;
    ;;      GAS|X_Toggle                            Updates <native-gas-toggle> or <virtual-gas-toggle> existing in the GAS|PropertiesTable to <toggle> ;;
    ;;      GAS|X_UpdatePot                         Updates <virtual-gas-tank> existing in the GAS|PropertiesTable                                      ;;
    ;;      GAS|X_Increment                         Incr. <native-gas-spent> or <virtual-gas-spent> existing in the GAS|PropertiesTable to <increment>  ;;
    ;;---Virtual-GAS-COLLECTION---------------------                                                                                                    ;;
    ;;      GAS|X_Collect                           Collects GAS                                                                                        ;;
    ;;      GAS|X_CollectStandard                   Collects GAS when a Standard DALOS Account is involved                                              ;;
    ;;      GAS|X_CollectSmart                      Collects GAS when a Smart DALOS Account is involved                                                 ;;
    ;;      GAS|X_Transfer                          Transfers <gas-amount> GAS from <gas-sender> to <gas-receiver>                                      ;;
    ;;---Native-GAS-COLLECTION----------------------                                                                                                    ;;
    ;;      GAS|X_CollectDalosFuel                  Collects Native Gas (Kadena)                                                                        ;;
    ;;      GAS|XC_TransferDalosFuel                Auxiliary Client function required for the <GAS|X_CollectDalosFuel>                                 ;;
    ;;                                                                                                                                                  ;;
    ;;==================================================================================================================================================;;



    ;;========[D] CAPABILITIES=================================================;;
    ;;1.1]    [D] DALOS Capabilities
    ;;1.1.1]  [D]   DALOS Basic Capabilities
    ;;1.1.2]  [D]   DALOS Composed Capabilities
    ;;========[D] FUNCTIONS====================================================;;
    ;;1.2]    [D] DALOS Functions
    ;;1.2.1]  [D]   DALOS Utility Functions
    ;;1.2.1.1][D]           Account Info
    ;;1.2.1.2][D]           Dalos Price Info
    ;;1.2.1.3][D]           Computing
    ;;1.2.1.4][D]           Validations
    ;;1.2.2]  [D]   DALOS Administration Functions
    ;;1.2.3]  [D]   DALOS Client Functions
    ;;1.2.3.1][D]           Control
    ;;1.2.4]  [D]   DALOS Auxiliary Functions
    ;;========[D] =============================================================;;
    ;;
    ;;++++++++
    ;;
    ;;========[TM] CAPABILITIES================================================;;
    ;;2.1]    [TM]DPTF-DPMF Capabilities
    ;;2.1.1]  [TM]  DPTF-DPMF Basic Capabilities
    ;;2.1.1.1][TM]          DPTF-DPMF <DPTF|PropertiesTable>|<DPMF|PropertiesTable> Table Management
    ;;2.1.1.2][TM]          DPTF-DPMF <DPTF|BalanceTable>|<DPTF|BalanceTable> Table Management
    ;;2.1.2]  [TM]  DPTF-DPMF Composed Capabilities
    ;;2.1.2.1][TM]          Control
    ;;2.1.2.2][TM]          Token Roles
    ;;2.1.2.3][TM]          Create
    ;;2.1.2.4][TM]          Destroy
    ;;2.1.2.4][TM]          Transfer
    ;;========[TM] FUNCTIONS===================================================;;
    ;;2.2]    [TM]DPTF-DPMF Functions
    ;;2.2.1]  [TM]  DPTF-DPMF Utility Functions
    ;;2.2.1.1][TM]          Account Info
    ;;2.2.1.2][TM]          True|Meta-Fungible Info
    ;;2.2.1.3][TM]          Validations
    ;;2.2.2]  [TM]  DPTF-DPMF Client Functions
    ;;2.2.2.1][TM]          Control
    ;;2.2.2.2][TM]          Token Roles
    ;;2.2.2.3][TM]          Create
    ;;2.2.2.4][TM]          Destroy
    ;;2.2.3]  [TM]  DPTF Auxiliary Functions
    ;;2.2.3.1][TM]          Update
    ;;2.2.3.2][TM]          Remainder-Aux
    ;;========[TM] ============================================================;;
    ;;
    ;;++++++++
    ;;
    ;;========[T] CAPABILITIES=================================================;;
    ;;3.1]    [T] DPTF Capabilities
    ;;3.1.1]  [T]   DPTF Basic Capabilities
    ;;3.1.1.1][T]           DPTF <DPTF|PropertiesTable> Table Management
    ;;3.1.1.2][T]           DPTF <DPTF|BalanceTable> Table Management
    ;;3.1.2]  [T]   DPTF Composed Capabilities
    ;;3.1.2.1][T]           Control
    ;;3.1.2.2][T]           Token Roles
    ;;3.1.2.3][T]           Create
    ;;3.1.2.4][T]           Transfer
    ;;========[T] FUNCTIONS====================================================;;
    ;;3.2]    [T] DPTF Functions
    ;;3.2.1]  [T]   DPTF Utility Functions
    ;;3.2.1.1][T]           Account Info
    ;;3.2.1.2][T]           True-Fungible Info
    ;;3.2.1.3][T]           Computing
    ;;3.2.1.4][T]           Composition
    ;;3.2.1.5][T]           Validations
    ;;3.2.2]  [T]   DPTF Administration Functions
    ;;3.2.3]  [T]   DPTF Client Functions
    ;;3.2.3.1][T]           Control
    ;;3.2.3.2][T]           Token Roles
    ;;3.2.3.3][T]           Create
    ;;3.2.3.4][T]           Destroy
    ;;3.2.3.5][T]           Transfer
    ;;3.2.4]  [T]   DPTF Auxiliary Functions
    ;;3.2.4.1][T]           Transfer
    ;;3.2.4.2][T]           Update
    ;;3.2.4.3][T]           Remainder-Aux
    ;;========[T] =============================================================;;
    ;;
    ;;++++++++
    ;;
    ;;========[M] CAPABILITIES=================================================;;
    ;;4.1]    [M] DPMF Capabilities
    ;;4.1.1]  [M]   DPMF Basic Capabilities
    ;;4.1.1.1][M]           DPMF <DPMF|PropertiesTable> Table Management
    ;;4.1.1.2][M]           DPMF <DPMF|BalanceTable> Table Management
    ;;4.1.2]  [M]  DPMF Composed Capabilities
    ;;4.1.2.1][M]           Token Roles
    ;;4.1.2.2][M]           Create
    ;;========[M] FUNCTIONS====================================================;;
    ;;4.2]    [M] DPMF Functions
    ;;4.2.1]  [M]   DPMF Utility Functions
    ;;4.2.1.1][M]           Account Info
    ;;4.2.1.2][M]           Account Nonce
    ;;4.2.1.3][M]           Meta-Fungible Info
    ;;4.2.1.4][M]           Composition
    ;;4.2.2]  [M]   DPTM Client Functions
    ;;4.2.2.1][M]           Control
    ;;4.2.2.2][M]           Token Roles
    ;;4.2.2.3][M]           Create
    ;;4.2.2.4][M]           Destroy
    ;;4.2.2.5][M]           Transfer
    ;;4.2.3]  [M]   DPTM Auxiliary Functions
    ;;4.2.3.1][M]           Transfer
    ;;4.2.3.2][M]           Update
    ;;4.2.3.3][M]           Remainder-Aux
    ;;========[M] =============================================================;;
    ;;
    ;;++++++++
    ;;
    ;;========[G] CAPABILITIES=================================================;;
    ;;5.1]    [G] GAS Capabilities
    ;;5.1.1]  [G]   GAS Basic Capabilities
    ;;5.1.2]  [G]   GAS Composed Capabilities
    ;;5.1.2.1][G]           GAS Control
    ;;5.1.2.2][G]           GAS Handling
    ;;========[G] FUNCTIONS====================================================;;
    ;;5.2]    [G] GAS Functions
    ;;5.2.1]  [G]   GAS Utility Functions
    ;;5.2.1.1][G]           Gas Info
    ;;5.2.1.2][G]           Computing
    ;;5.2.2]  [G]   GAS Administration Functions
    ;;5.2.3]  [G]   GAS Client Functions
    ;;5.2.4]  [G]   GAS Auxiliary Functions
    ;;5.2.4.1][G]           GAS|PropertiesTable Update
    ;;5.2.4.2][G]           Virtual Gas Collection
    ;;5.2.4.2][G]           Native Gas Collection
    ;;========[G] =============================================================;;
    ;;
    ;;++++++++
    ;;
    ;;========[A] CAPABILITIES=================================================;;
    ;;6.1]    [A] ATS Capabilities
    ;;6.1.1]  [A]   ATS Basic Capabilities
    ;;6.1.1.1][A]           ATS|Pairs> Table Management
    ;;6.1.1.2][A]           ATS|Ledger> Table Management
    ;;6.1.2]  [A]   ATS Composed Capabilities
    ;;6.1.2.1][A]           Control
    ;;6.1.2.2][A]           Create
    ;;6.1.2.3][A]           Destroy
    ;;6.1.2.4][A]           Client Capabilities
    ;;========[A] FUNCTIONS====================================================;;
    ;;6.2]    [A] ATS Functions
    ;;6.2.1]  [A]   ATS Utility Functions
    ;;6.2.1.1][A]           ATS|Pairs Info
    ;;6.2.1.2][A]           ATS|Ledger Info
    ;;6.2.1.3][A]           Computing|Composing
    ;;6.2.1.4][A]           CPF Computers
    ;;6.2.1.5][A]           Validations
    ;;6.2.2]  [A]   ATS Administration Functions
    ;;6.2.3]  [A]   ATS Client Functions
    ;;6.2.3.1][A]           Control
    ;;6.2.3.2][A]           Create
    ;;6.2.3.3][A]           Destroy
    ;;6.2.3.4][A]           Use
    ;;6.2.3.5][A]           Revoke
    ;;6.2.4]  [A]   ATS Utility Functions
    ;;========[A] =============================================================;;
    ;;
    ;;++++++++
    ;;
    ;;========[L] CAPABILITIES=================================================;;
    ;;7.1]    [L] LIQUID Capabilities
    ;;7.1.1]  [L]   LIQUID Composed Capabilities
    ;;========[L] FUNCTIONS====================================================;;
    ;;7.2.1]  [L]   LIQUID Administration Functions
    ;;7.2.2]  [L]   LIQUID Client Functions
    ;;========[L] =============================================================;;
    ;;
    ;;++++++++
    ;;
    ;;========[V] CAPABILITIES=================================================;;
    ;;8.1]    [V] VST Capabilities
    ;;8.1.1]  [V]   VST Basic Capabilities
    ;;8.1.2]  [V]   VST Composed Capabilities
    ;;========[V] FUNCTIONS====================================================;;
    ;;8.2]    [V] VST Functions
    ;;8.2.1]  [V]   VST Utility Functions
    ;;8.2.1.1][V]           Computing|Composing
    ;;8.2.2]  [V]   Administration Functions
    ;;8.2.3]  [V]   Client Functions
    ;;8.2.4]  [V]   Auxiliary Functions
    ;;=========================================================================;;