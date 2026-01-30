(module STOAICO GOV
    ;;
    (implements OuronetPolicy)
    ;(implements DemiourgosPactDigitalCollectibles-UtilityPrototype)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_STOAICO                (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst DEMIPAD|SC_NAME               (GOV|DEMIPAD|SC_NAME))
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|STOAICO_ADMIN)))
    (defcap GOV|STOAICO_ADMIN ()            (enforce-guard GOV|MD_STOAICO))
    ;;{G3}
    ;;{G3}
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;; [Keys]
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|LaunchpadKey ()              (+ (GOV|NS_Use) ".dh_sc_mb-keyset"))
    ;;
    ;; [SC-Names]
    (defun GOV|DEMIPAD|SC_NAME ()           (at 0 ["Σ.Îäć$ЬчýφVεÎÿůпΨÖůηüηŞйnюŽXΣşpЩß5ςĂκ£RäbE₳èËłŹŘYшÆgлoюýRαѺÑÏρζt∇ŹÏýжIŒațэVÞÛщŹЭδźvëȘĂтPЖÃÇЭiërđÈÝДÖšжzČđзUĚĂsкιnãñOÔIKпŞΛI₳zÄû$ρśθ6ΨЬпYпĞHöÝйÏюşí2ćщÞΔΔŻTж€₿ŞhTțŽ"]))
    ;;
    ;; [PBLs]
    (defun GOV|DEMIPAD|PBL ()               (at 0 ["9F.gGCkuc2wMAnFAjuFphikftLdl6qFqBD4yfeMEe9u65yMqf4r340Jd6dphh1d7E1cE20btMwl4HJ2cBEMvp209GA1eD4syB96hu4nmpFbB7dKnJEMz4p8fGLcmhvrBCfDmM0axnGin8qedl5vDtwbgL3l1aK5BsmjkEEJartqCH8qG8ialtjxwCcIMf50t2lkeww6Dct5LlmmLG25FmfpcgnwMMnkJl4Gfn9gwoA6vm0jKebjhodeJLjxnh9L11ss8f26866dqv1tEphxFFqutGetH4Itj3rHkrcrGsnlqpf4gfJp94b0gBwIBe4vCj6ha8jm6kd3f8B6pEaJtkJ3fbs6rCcGibltz1BAMn0vvKME5ddFyGBnzssk1s2s0vFzwxs6vjC61Ma2l1xDxqdg1thAk2u01hDiGndLhzK73HAfgtk7bxscn0qKhymG6JAqnEFt282pyHAq5nIthK9bA8nH76x7FEpLz4eK9tLIBsyjb8M5DxaeEei6pEnLxFCAg7ulacgtjjpjMiAaqhpmM1jEHqjt4G85q4L33zrME7whgIkIpIgwnF2qKd4"]))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|STOAICO|CALLER ()
        true
    )
    (defcap P|PAD-STOAICO|REMOTE-GOV ()
        true
    )
    (defcap P|SECURE-CALLER ()
        (compose-capability (P|STOAICO|CALLER))
        (compose-capability (SECURE))
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|STOAICO_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|STOAICO_ADMIN)
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
                (ref-P|DPAD:module{OuronetPolicy} DEMIPAD)
                (mg:guard (create-capability-guard (P|STOAICO|CALLER)))
            )
            (ref-P|DPAD::P|A_Add
                "STOAICO|RemoteGov"
                (create-capability-guard (P|PAD-STOAICO|REMOTE-GOV))
            )
            (ref-P|DPAD::P|A_AddIMP mg)
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
    (defschema UserContributionSchema
        dollarz:decimal             ;;Adds dollars contributed
        urstoa-earned:integer       ;;Adds Urstoa earned (WURSTOA bought with 5$ Contributions)
        ;;
        ;;Distribution-Vault-Data
        ;;v-dollarz                 ;;Stores the amount of Dollarz Contributed by Account; same as <dollarz>
        last-rps:decimal            ;;Value of the Users last RPS
        pending-rewards:decimal     ;;Amount of pending rewards the user can claim (amount of WSTOA user can still claim)
        ;;
        ;;Select Keyz
        owner-id:string             ;;Ouronet Account
    )
    (defschema GeneralContributionSchema
        dollarz:decimal             ;;Adds dollars contributed
        urstoa-left:integer         ;;Subtracts, storing UrStoa left
        users:integer               ;;Stores number of participants
        ;;
        ;;Distribution-Vault-Data
        ;;v-dollarz-supply          ;;Stores the total amount of Virtual Dollars in the Vault; same as <dollarz>; Functions as global score
        wstoa-supply:decimal        ;;Stores the total WSTOA held by the distribution Vault (10 mil wSTOA of ICO sale)
        nzs-count:integer           ;;Stores the number of users with non zero score.
        current-rps:decimal         ;;Stores current RPS decimal
        unclaimed-count:integer     ;;Stores the total number of user with unclaimed Rewards.
        ;;
        ;;IDs
        wstoa:string
        wurstoa:string
        vusd:string
    )
    ;;{2}
    (deftable STOAICO|T|User:{UserContributionSchema})          ;;Key = <Ouronet-Account>
    (deftable STOAICO|T|General:{GeneralContributionSchema})    ;;Key = <STOAICO|INFO>
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    (defun STOAICO|Info ()          (at 0 ["StoaIcoInformation"]))
    (defconst STOAICO|INFO          (STOAICO|Info))
    (defconst STOA_PREC             12)
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
    (defcap INIT-ICO-DISTRIBUTION ()
        @event
        (compose-capability (SECURE))
        (compose-capability (GOV))
    )
    (defcap STOAICO|INJECT (account:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
            )
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (compose-capability (STOAICO|ADMIN))
        )
    )
    (defcap STOAICO|ADD-CONTRIBUTION (account:string v-usd-amount:decimal)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (v-usd-id:string (UR_Global10))
            )
            (ref-DALOS::UEV_EnforceAccountExists account)
            (ref-DPTF::UEV_Amount v-usd-id v-usd-amount)
            (compose-capability (STOAICO|ADMIN))
        )
    )
    (defcap STOAICO|REMOVE-CONTRIBUTION (account:string v-usd-amount:decimal)
        @event
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV8} DPTF)
                (v-usd-id:string (UR_Global10))
                (user-score:decimal (UR_User1 account))
            )
            (ref-DPTF::UEV_Amount v-usd-id v-usd-amount)
            (enforce 
                (<= v-usd-amount user-score) 
                (format "Removing {} from Account {} exceeds its existing balance" [v-usd-amount account])
            )
            (compose-capability (STOAICO|ADMIN))
        )
    )
    (defcap STOAICO|REDEEM-CONTRIBUTION (account:string)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (iz-account:bool (UR_IzAccount account))
            )
            (ref-DALOS::CAP_EnforceAccountOwnership account)
            (enforce iz-account (format "Account {} cannot be redeemed" [account]))
            (compose-capability (SECURE))
            (compose-capability (P|PAD-STOAICO|REMOTE-GOV))
        )
    )
    (defcap STOAICO|ADMIN ()
        (compose-capability (GOV))
        (compose-capability (SECURE))
        (compose-capability (P|PAD-STOAICO|REMOTE-GOV))
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_User0:object{UserContributionSchema} (account:string)
        (let
            (
                (current-rps:decimal (UR_Global6))
            )
            (with-default-read STOAICO|T|User account
                (UDC_UserData 0.0 0 current-rps 0.0 account)
                {"dollarz":= d, "urstoa-earned" := ue, "last-rps" := lrps, "pending-rewards" := pr, "owner-id" := id}
                (UDC_UserData d ue lrps pr id)
            )
        )   
    )
    (defun UR_User1:decimal (account:string)
        (with-default-read STOAICO|T|User account
            {"dollarz" : 0.0}
            {"dollarz" := d}
            d
        )
    )
    (defun UR_User2:integer (account:string)
        (with-default-read STOAICO|T|User account
            {"urstoa-earned" : 0}
            {"urstoa-earned" := ue}
            ue
        )
    )
    (defun UR_User3:decimal (account:string)
        (let
            (
                (current-rps:decimal (UR_Global6))
            )
            (with-default-read STOAICO|T|User account
                {"last-rps" : current-rps}
                {"last-rps" := l-rps}
                l-rps
            )
        )
    )
    (defun UR_User4:decimal (account:string)
        (with-default-read STOAICO|T|User account
            {"pending-rewards" : 0.0}
            {"pending-rewards" := pr}
            pr
        )
    )
    ;;
    (defun UR_Global0:object{GeneralContributionSchema} ()
        (read STOAICO|T|General STOAICO|INFO)
    )
    (defun UR_Global1:decimal ()
        (at "dollarz" (read STOAICO|T|General STOAICO|INFO ["dollarz"]))
    )
    (defun UR_Global2:integer ()
        (at "urstoa-left" (read STOAICO|T|General STOAICO|INFO ["urstoa-left"]))
    )
    (defun UR_Global3:integer ()
        (at "users" (read STOAICO|T|General STOAICO|INFO ["users"]))
    )
    (defun UR_Global4:decimal ()
        (at "wstoa-supply" (read STOAICO|T|General STOAICO|INFO ["wstoa-supply"]))
    )
    (defun UR_Global5:integer ()
        (at "nzs-count" (read STOAICO|T|General STOAICO|INFO ["nzs-count"]))
    )
    (defun UR_Global6:decimal ()
        (at "current-rps" (read STOAICO|T|General STOAICO|INFO ["current-rps"]))
    )
    (defun UR_Global7:integer ()
        (at "unclaimed-count" (read STOAICO|T|General STOAICO|INFO ["unclaimed-count"]))
    )
    (defun UR_Global8:string ()
        (at "wstoa" (read STOAICO|T|General STOAICO|INFO ["wstoa"]))
    )
    (defun UR_Global9:string ()
        (at "wurstoa" (read STOAICO|T|General STOAICO|INFO ["wurstoa"]))
    )
    (defun UR_Global10:string ()
        (at "vusd" (read STOAICO|T|General STOAICO|INFO ["vusd"]))
    )
    ;;
    (defun UR_IzAccount:bool (account:string)
        @doc "Checks if an account exists"
        (let
            (
                (trial (try false (read STOAICO|T|User account)))
            )
            (if (= (typeof trial) "bool") false true)
        )
    )
    ;;{F1}  [URC]
    (defun URC_ClaimableRewards (account:string)
        @doc "Computes Claimable Reward of Account"
        (if (= (UR_Global7) 1)
            (UR_Global4)
            (URC_AvailableRewards account)
        )
    )
    (defun URC_AvailableRewards (account:string)
        (let
            (
                (current-pending-rewards:decimal (UR_User4 account))
                (current-score:decimal (UR_User1 account))
                (last-rps:decimal (UR_User3 account))
                (current-rps:decimal (UR_Global6))
                ;;
                (diff-rps:decimal (- current-rps last-rps))
                (gained-pending-rewards:decimal (floor (* current-score diff-rps) STOA_PREC))
            )
            (+ current-pending-rewards gained-pending-rewards)
        )
    )

    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    (defun UDC_UserData:object{UserContributionSchema}
        (a:decimal b:integer c:decimal d:decimal e:string)
        {"dollarz"          : a
        ,"urstoa-earned"    : b
        ,"last-rps"         : c
        ,"pending-rewards"  : d
        ,"owner-id"         : e}
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun A_InitialiseDistributionVault (account:string)
        @doc "Initialises the Distribuition Vault by creating and filling all necesary prerequisites"
        (with-capability (INIT-ICO-DISTRIBUTION)
            (let
                (
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV6} TS01-C1)
                    (ref-P|DPAD:module{OuronetPolicy} DEMIPAD)
                    (dptf-ids:list 
                        (ref-TS01-C1::DPTF|C_Issue account account
                            ["WrappedStoa" "WrappedUrStoa" "VirtualIcoDollars"]
                            ["WSTOA" "WURSTOA" "VUSDC"]
                            [STOA_PREC 3 2]
                            [true true true]
                            [true true true]
                            [true true true]
                            [false false false]
                            [false false false]
                            [false false false]
                        )
                    )
                    (wstoa-id:string (at 0 dptf-ids))
                    (wurstoa-id:string (at 1 dptf-ids))
                    (vusd-id:string (at 2 dptf-ids))
                )
                ;;1]Issue wSTOA as a DPTF
                ;;2]Issue wURSTOA as DPTF
                ;;3]Issue vUSD as mockup virtual Dollarz
                ;;4]Toggle mint and burn roles
                (ref-TS01-C1::DPTF|C_ToggleMintRole account vusd-id DEMIPAD|SC_NAME true)
                (ref-TS01-C1::DPTF|C_ToggleBurnRole account vusd-id DEMIPAD|SC_NAME true)
                (ref-TS01-C1::DPTF|C_ToggleMintRole account wstoa-id account true)
                (ref-TS01-C1::DPTF|C_ToggleMintRole account wurstoa-id DEMIPAD|SC_NAME true)
                ;;5]Mint 10 mil wSTOA (injection will follow after ICO concludes)    
                (ref-TS01-C1::DPTF|C_Mint account wstoa-id account 10000000.0 true)
                ;;6]Initialises the distribution Vault
                (XI_InitialiseDistributionVault dptf-ids)
                ;;7]Output Message
                (format 
                    "StoaICO Distribution Vault initialise correctly, with Token IDs {} {} {}" 
                    [wstoa-id wurstoa-id vusd-id]
                )
            )
        )
    )
    (defun A_Inject (patron:string account:string wstoa-amount:decimal)
        @doc "Injects the ICO wSTOA amount into the Distribution-Vault (D-Vault); \
            \ the 10 mil from the ICO sale, from <account> \
            \ Can only be done by the ADMIN"
        (with-capability (STOAICO|INJECT account)
            (let
                (
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV6} TS01-C1)
                    (wSTOA-ID:string (UR_Global8))
                    ;;
                    (vault-score:decimal (UR_Global1))
                    (gained-rps:decimal (floor (/ wstoa-amount vault-score) STOA_PREC))
                    (current-rps:decimal (UR_Global6))
                    (new-rps:decimal (+ current-rps gained-rps))
                )
                ;;0]Move wSTOA from <account> to the D-Vault
                (ref-TS01-C1::DPTF|C_Transfer patron wSTOA-ID account DEMIPAD|SC_NAME wstoa-amount true)
                ;;1]Update D-Vault <current-rps> with new value gained form injecting <wstoa-amount>
                (XI_UpdateVaultRPS new-rps)
                ;;2]Update D-Vault <wstoa-supply> with <wstoa-amount>
                (XI_UpdateVaultSupply wstoa-amount true)
                ;;3]Reset <unclaimed-count> (set it to <nzs-count>)
                (XI_ResetUnclaimedCount)
            )
        )
    )
    (defun A_Stake (patron:string account:string v-usd-amount:decimal)
        @doc "Adds a contribution in virtual $ to the Distribution Vault \
        \ Contributing with v-dollars allows for a piece of the 10 mil wSTOA \
        \ placed for distribution in this Vault.\
        \ Also earns urSTOA (up to 300k) \
        \ Can only be done by the Admin"
        (with-capability (STOAICO|ADD-CONTRIBUTION account v-usd-amount)
            (let
                (
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV6} TS01-C1)
                    (v-usd-id:string (UR_Global10))
                    (user-score:decimal (UR_User1 account))
                )
                ;;0]Mint the v-USD amount to the <DEMIPAD|SC_NAME>
                (ref-TS01-C1::DPTF|C_Mint patron v-usd-id DEMIPAD|SC_NAME v-usd-amount false)
                ;;0.1]If New Account
                (if (not (UR_IzAccount account))
                    (do
                        (insert STOAICO|T|User account
                            (UDC_UserData 0.0 0 (UR_Global6) 0.0 account)
                        )
                        ;;Increment Users by one
                        (update STOAICO|T|General STOAICO|INFO
                            {"users" : (+ 1 (UR_Global3))}
                        )
                    )                
                    true
                )
                ;;1.1]Update Pending Rewards
                (XI_UpdatePendingRewards account)
                ;;1.2]If initial <user-score> was 0, increment <nzs-count>
                (if (= user-score 0.0)
                    (XI_UpdateNZS true)
                    true
                )
                ;;1.3]Update <last-rps> with D-Vault <current-rps>
                (XI_UpdateUserRPS account (UR_Global6))
                ;;1.4]Update <urstoa-earned>
                (XI_UpdateUrstoaEarned account v-usd-amount true)
                ;;1.5]Update Vault Score and User Score
                (XI_UpdateVaultScore v-usd-amount true)
                (XI_UpdateUserScore account v-usd-amount true)
            )
        )
    )
    (defun A_Unstake (patron:string account:string v-usd-amount:decimal)
        @doc "Removes a contribution of virtual $ from the Distribution Vault for an <account> \
        \ Can only be done by the ADMIN"
        (with-capability (STOAICO|REMOVE-CONTRIBUTION account v-usd-amount)
            (let
                (
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV6} TS01-C1)
                    (v-usd-id:string (UR_Global10))
                    (user-score:decimal (UR_User1 account))
                    (remaining:decimal (- user-score v-usd-amount))
                )
                ;;0]Burn the v-USD amount from the <DEMIPAD|SC_NAME> that is to be removed
                (ref-TS01-C1::DPTF|C_Burn patron v-usd-id DEMIPAD|SC_NAME v-usd-amount)
                ;;1.1]Update Pending Rewards
                (XI_UpdatePendingRewards account)
                ;;1.2]If remaining <user-score> becomes 0, decrement <nzs-count>
                (if (= remaining 0.0)
                    (XI_UpdateNZS false)
                    true
                )
                ;;1.3]Update <last-rps> with D-Vault <current-rps>
                (XI_UpdateUserRPS account (UR_Global6))
                ;;1.4]Update <urstoa-earned>
                (XI_UpdateUrstoaEarned account v-usd-amount false)
                ;;1.5]Update Vault Score and User Score
                (XI_UpdateVaultScore v-usd-amount false)
                (XI_UpdateUserScore account v-usd-amount false)
            )
        )
    )
    ;;{F6}  [C]
    (defun C_Collect (patron:string account:string)
        @doc "Collects from the distribution Vault \
        \ Can only be done once, after the ICO has concluded. \
        \ Can only be done by <account> owner."
        (with-capability (STOAICO|REDEEM-CONTRIBUTION account)
            (let
                (
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV6} TS01-C1)
                    (wSTOA-supply:decimal (URC_ClaimableRewards account))
                    (urSTOA-supply:decimal (dec (UR_User2 account)))
                    (wSTOA-id:string (UR_Global8))
                    (urSTOA-id:string (UR_Global9))
                )
                ;;1]Collect wSTOA and URSTOA Rewards
                (ref-TS01-C1::DPTF|C_Mint patron urSTOA-id DEMIPAD|SC_NAME urSTOA-supply false)
                (if (!= urSTOA-supply 0.0)
                    (ref-TS01-C1::DPTF|C_MultiTransfer patron
                        [wSTOA-id urSTOA-id] DEMIPAD|SC_NAME account 
                        [wSTOA-supply urSTOA-supply] true
                    )
                    (ref-TS01-C1::DPTF|C_Transfer patron wSTOA-id DEMIPAD|SC_NAME account wSTOA-supply true)
                )
                ;;2]Reset <pending-rewards> to 0
                (XI_ResetPendingRewards account)
                ;;3]Decrement <unclaimed-count>
                (XI_UpdateUnclaimedCount false)
                ;;4]Update <last-rps> with the D-Vault <current-rps>
                (XI_UpdateUserRPS account (UR_Global6))
                ;;5]Update Vault Supply
                (XI_UpdateVaultSupply wSTOA-supply false)
                (XI_ResetUrstoaEarned account)
                ;;6]Return claimed amounts
                (if (!= urSTOA-supply 0.0)
                    (format 
                        "Account {} succesfully claimed {} {} and {} {}"
                        [account wSTOA-supply wSTOA-id urSTOA-supply urSTOA-id]
                    )
                    (format 
                        "Account {} succesfully claimed {} {} and no {}"
                        [account wSTOA-supply wSTOA-id urSTOA-id]
                    )
                )
                
            )
        )
    )
    (defun XI_ResetPendingRewards (account:string)
        (require-capability (SECURE))
        (update STOAICO|T|User account
            {"pending-rewards" : 0.0}
        )
    )
    (defun XI_UpdateUnclaimedCount (direction:bool)
        (require-capability (SECURE))
        (let
            (
                (uc:integer (UR_Global7))
                (new-uc:integer
                    (if direction
                        (+ uc 1)
                        (- uc 1)
                    )
                )
            )
            (update STOAICO|T|General STOAICO|INFO
                {"unclaimed-count" : new-uc}
            )
        )
    )
    ;;{F7}  [X]
    ;;Admin
    (defun XI_InitialiseDistributionVault (dptf-ids:[string])
        (require-capability (SECURE))
        (insert STOAICO|T|General STOAICO|INFO
            {"dollarz"          : 0.0
            ,"urstoa-left"      : 300000
            ,"users"            : 0
            ,"wstoa-supply"     : 0.0
            ,"nzs-count"        : 0
            ,"current-rps"      : 0.0
            ,"unclaimed-count"  : 0
            ,"wstoa"            : (at 0 dptf-ids)
            ,"wurstoa"          : (at 1 dptf-ids)
            ,"vusd"             : (at 2 dptf-ids)
            }
        )
    )
    ;;User
    (defun XI_UpdateUserScore (account:string amount:decimal direction:bool)
        (require-capability (SECURE))
        (let
            (
                (user-score:decimal (UR_User1 account))
                (new-user-score:decimal
                    (if direction
                        (+ user-score amount)
                        (- user-score amount)
                    )
                )
            )
            (update STOAICO|T|User account
                {"dollarz" : new-user-score}
            )
        )
    )
    (defun XI_UpdateUserRPS (account:string new-rps:decimal)
        (require-capability (SECURE))
        (update STOAICO|T|User account
            {"last-rps" : new-rps}
        )
    )
    (defun XI_UpdatePendingRewards (account:string)
        (require-capability (SECURE))
        (update STOAICO|T|User account
            {"pending-rewards" : (URC_AvailableRewards account)}
        )
    )
    ;;D-Vault
    (defun XI_UpdateVaultScore (amount:decimal direction:bool)
        (require-capability (SECURE))
        (let
            (
                (vault-score:decimal (UR_Global1))
                (new-vault-score:decimal
                    (if direction
                        (+ vault-score amount)
                        (- vault-score amount)
                    )
                )
            )
            (update STOAICO|T|General STOAICO|INFO
                {"dollarz" : new-vault-score}
            )
        )
    )
    (defun XI_UpdateVaultSupply (amount:decimal direction:bool)
        (require-capability (SECURE))
        (let
            (
                (vault-supply:decimal (UR_Global4))
                (new-vault-supply:decimal
                    (if direction
                        (+ vault-supply amount)
                        (- vault-supply amount)
                    )
                )
            )
            (update STOAICO|T|General STOAICO|INFO
                {"wstoa-supply" : new-vault-supply}
            )
        )
    )
    (defun XI_UpdateNZS (direction:bool)
        (require-capability (SECURE))
        (let
            (
                (nzs:integer (UR_Global5))
                (new-nzs:integer
                    (if direction
                        (+ nzs 1)
                        (- nzs 1)
                    )
                )
            )
            (update STOAICO|T|General STOAICO|INFO
                {"nzs-count" : new-nzs}
            )
        )
    )
    (defun XI_UpdateVaultRPS (new-rps:decimal)
        (require-capability (SECURE))
        (update STOAICO|T|General STOAICO|INFO
            {"current-rps" : new-rps}
        )
    )
    (defun XI_ResetUnclaimedCount ()
        (require-capability (SECURE))
        (update STOAICO|T|General STOAICO|INFO
            {"unclaimed-count" : (UR_Global5)}
        )
    )
    ;;
    (defun XI_ResetUrstoaEarned (account:string)
        (require-capability (SECURE))
        (update STOAICO|T|User account
            {"urstoa-earned"    : 0}
        )
    )
    (defun XI_UpdateUrstoaEarned (account:string v-usd-amount:decimal direction:bool)
        (require-capability (SECURE))
        (let
            (
                (user-score:decimal (UR_User1 account))
                (new-user-score:decimal
                    (if direction
                        (+ user-score v-usd-amount)
                        (- user-score v-usd-amount)
                    )
                )
                (vault-score:decimal (UR_Global1))
                (new-vault-score:decimal
                    (if direction
                        (+ vault-score v-usd-amount)
                        (- vault-score v-usd-amount)
                    )
                )
                (urstoa-left:integer (UR_Global2))
                (present-urstoa-earned:integer (UR_User2 account))
                (new-urstoa-earned:integer (floor (/ new-user-score 5.0)))
                (diff-urstoa:integer (- new-urstoa-earned present-urstoa-earned))
            )
            (if (= diff-urstoa 0)
                ;;do nothing
                true
                (let
                    (
                        (final-urstoa-earned:integer
                            (if (< urstoa-left diff-urstoa)
                                (+ present-urstoa-earned urstoa-left)
                                new-urstoa-earned
                            )


                        )
                        (final-urstoa-left:integer
                            (if (< urstoa-left diff-urstoa)
                                0
                                (- urstoa-left diff-urstoa)
                            )
                        )
                    )
                    (update STOAICO|T|User account
                        {"urstoa-earned"    : final-urstoa-earned}
                    )
                    (update STOAICO|T|General STOAICO|INFO
                        {"urstoa-left"      : final-urstoa-left}
                    )
                )
            )
        )
    )
)

(create-table P|T)
(create-table P|MT)
(create-table STOAICO|T|User)
(create-table STOAICO|T|General)