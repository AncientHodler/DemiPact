(module TS02-C1 GOV
    @doc "TALOS Stage 2 Client Functiones Part 1 - SFT Functions"
    ;;
    (implements OuronetPolicy)
    (implements TalosStageTwo_ClientOneV8)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_TS02-C1        (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|TS02-C1_ADMIN)))
    (defcap GOV|TS02-C1_ADMIN ()    (enforce-guard GOV|MD_TS02-C1))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV6} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|TS ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV6} DALOS)
                (gap:bool (ref-DALOS::UR_GAP))
            )
            (enforce (not gap) "While Global Administrative Pause is online, no client Functions can be executed")
            (compose-capability (P|TALOS-SUMMONER))
        )
    )
    (defcap P|TALOS-SUMMONER ()
        @doc "Talos Summoner Capability"
        true
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
        (with-capability (GOV|TS02-C1_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|TS02-C1_ADMIN)
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
                (ref-P|TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                (ref-P|DPDC:module{OuronetPolicy} DPDC)
                (ref-P|DPDC-C:module{OuronetPolicy} DPDC-C)
                (ref-P|DPDC-I:module{OuronetPolicy} DPDC-I)
                (ref-P|DPDC-R:module{OuronetPolicy} DPDC-R)
                (ref-P|DPDC-MNG:module{OuronetPolicy} DPDC-MNG)
                (ref-P|DPDC-T:module{OuronetPolicy} DPDC-T)
                (ref-P|DPDC-F:module{OuronetPolicy} DPDC-F)
                (ref-P|DPDC-S:module{OuronetPolicy} DPDC-S)
                (ref-P|DPDC-N:module{OuronetPolicy} DPDC-N)
                (ref-P|EQUITY:module{OuronetPolicy} EQUITY)
                (mg:guard (create-capability-guard (P|TALOS-SUMMONER)))
            )
            (ref-P|TS01-A::P|A_AddIMP mg)
            (ref-P|DPDC::P|A_AddIMP mg)
            (ref-P|DPDC-C::P|A_AddIMP mg)
            (ref-P|DPDC-I::P|A_AddIMP mg)
            (ref-P|DPDC-R::P|A_AddIMP mg)
            (ref-P|DPDC-MNG::P|A_AddIMP mg)
            (ref-P|DPDC-T::P|A_AddIMP mg)
            (ref-P|DPDC-F::P|A_AddIMP mg)
            (ref-P|DPDC-S::P|A_AddIMP mg)
            (ref-P|DPDC-N::P|A_AddIMP mg)
            (ref-P|EQUITY::P|A_AddIMP mg)
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
    ;;{2}
    ;;{3}
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
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_ShortAccount:string (account:string)
        (let
            (
                (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
            )
            (ref-I|OURONET::OI|UC_ShortAccount account)
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;
    ;;  [2] DPDC
    ;;
    (defun DPDC|C_MultiTransfer (patron:string ids:[string] sons:[bool] sender:string receiver:string nonces-array:[[integer]] amounts-array:[[integer]] method:bool)
        @doc "Transfer multiple SFT <ids> from <sender> to <receiver>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-DPDC-T:module{DpdcTransferV4} DPDC-T)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount sender))
                    (ra:string (ref-I|OURONET::OI|UC_ShortAccount receiver))
                    (hm:integer (length ids))
                    ;;
                    (irs:object{DpdcTransferV4.AggregatedRoyalties}
                        (ref-DPDC-T::C_IgnisRoyaltyCollector patron sender ids sons nonces-array amounts-array)
                    )
                    (c:[string] (at "creators" irs))
                    (r:[decimal] (at "ignis-royalties" irs))
                    (s:decimal (fold (+) 0.0 r))
                    (l:integer (length c))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-T::C_Transfer ids sons sender receiver nonces-array amounts-array method)
                )
                [
                    (format "Successfully transfered DPDC(s) {} Nonce-Array {} using Amount-Array {} from {} to {}" [ids nonces-array amounts-array sa ra])
                    (if (= s 0.0)
                        (format "Transfer executed without collecting any IGNIS Royalties for the Collectable(s) {}" [ids])
                        (format "Transfer executed while collecting {} IGNIS Royalty to {} Collectable Creator(s)" [s l])
                    )
                ]
            )
        )
    )
    (defun DPSF|C_UpdatePendingBranding (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> for DPSF Token <entity-id> costing 400 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC:module{DpdcV4} DPDC)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC::C_UpdatePendingBranding patron entity-id true logo description website social)
                )
            )
        )
    )
    (defun DPSF|C_UpgradeBranding (patron:string entity-id:string months:integer)
        @doc "Upgrades Branding for DPSF Token, making it a premium Branding. \
            \ Also sets pending-branding to live branding if its branding is not live yet"
        (with-capability (P|TS)
            (let
                (
                    (ref-DPDC:module{DpdcV4} DPDC)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                )
                (ref-DPDC::C_UpgradeBranding patron entity-id true months)
                (ref-TS01-A::XB_DynamicFuelKDA)
            )
        )
    )
    ;;
    ;;  [3] DPDC-C
    ;;
    (defun DPSF|C_Create:string
        (
            patron:string id:string amount:[integer]
            input-nonce-data:[object{DpdcUdcV3.DPDC|NonceData}]
        )
        @doc "Creates a new SFT Collection Element(s), having a new nonce, \
            \ of amount <amount>, on the Account that has <r-nft-create> \
            \ As this account is the only Account that is allowed to create new SFTs in the Collection"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-C:module{DpdcCreateV4} DPDC-C)
                    (l:integer (length input-nonce-data))
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (if (= l 1)
                            (ref-DPDC-C::C_CreateNewNonce
                                id true 0 (at 0 amount) (at 0 input-nonce-data) false
                            )
                            (ref-DPDC-C::C_CreateNewNonces
                                id true amount input-nonce-data
                            )
                        )
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (format "Created {} Clas 0 SemiFungible(s) within the {} DPSF Collection"
                    [(at "output" ico) id]
                )
            )
        )
    )
    ;;
    ;;  [4] DPDC-I
    ;;
    (defun DPSF|C_DeployAccount (patron:string account:string id:string)
        @doc "Deploys a DPSF Account. Stand Alone Deployment costs 2 IGNIS"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-I:module{DpdcIssue} DPDC-I)
                )
                (ref-DPDC-I::C_DeployAccountSFT account id)
                (ref-IGNIS::C_Collect patron
                    (ref-IGNIS::UDC_SmallCumulator account)
                )
            )
        )
    )
    (defun DPSF|C_Issue:string
        (
            patron:string 
            owner-account:string creator-account:string collection-name:string collection-ticker:string
            can-upgrade:bool can-change-owner:bool can-change-creator:bool can-add-special-role:bool
            can-transfer-nft-create-role:bool can-freeze:bool can-wipe:bool can-pause:bool
        )
        @doc "Issues a new DPSF (Demiourgos Pact Semi-Fungible) Digital Collection: <SFT> \
            \ Costs 5x<ignis|token-issue> = 2500 IGNIS and 400 KDA"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-I:module{DpdcIssue} DPDC-I)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-DPDC-I::C_IssueDigitalCollection
                            patron true 
                            owner-account creator-account collection-name collection-ticker
                            can-upgrade can-change-owner can-change-creator can-add-special-role
                            can-transfer-nft-create-role can-freeze can-wipe can-pause
                            false
                        )
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    ;;
    ;;  [5] DPDC-R
    ;;
    (defun DPSF|C_ToggleAddQuantityRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles the add quantity role for a DPTF Token on a given Ouronet Account"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-R::C_ToggleAddQuantityRole id account toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleFreezeAccount (patron:string id:string account:string toggle:bool)
        @doc "Freezes a given account for a given DPSF Token. Frozen Accounts can no longer send or receive that DPSF Token"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-R::C_ToggleFreezeAccount id true account toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleExemptionRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles exemption Role for a given DPSF on a given Smart Ouronet Account (Only Smart Ouronet Accounts can accept this role) \
            \ When sending to or receiving from such Accounts, the flat IGNIS Royalty fee must not be paid."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-R::C_ToggleExemptionRole id true account toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleBurnRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles burn Role for a given DPSF on any Ouronet Account. \
            \ Such Accounts can then burn the DPSF"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-R::C_ToggleBurnRole id true account toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleUpdateRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles update Role for a given DPSF on any Ouronet Account. \
            \ Such Accounts can then update (modify) the Metadata on any DPSF nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-R::C_ToggleUpdateRole id true account toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleModifyCreatorRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles Modify Creator Role for a given DPSF on any Ouronet Account. \
            \ Such Accounts can proceed to modify the Creator of the DPSF Collection"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-R::C_ToggleModifyCreatorRole id true account toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleModifyRoyaltiesRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles Modify Royalties Role for a given DPSF on any Ouronet Account. \
            \ Such Accounts can proceed to modify the Permille Royalty of any nonce in the  DPSF Collection"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-R::C_ToggleModifyRoyaltiesRole id true account toggle)
                )
            )
        )
    )
    (defun DPSF|C_ToggleTransferRole (patron:string id:string account:string toggle:bool)
        @doc "Toggles Transfer Role for a given DPSF on any Ouronet Account. \
            \ Transfers for any Nonce in the DPSF Collection are then restricted only to and from these accounts"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-R::C_ToggleTransferRole id true account toggle)
                )
            )
        )
    )
    (defun DPSF|C_MoveCreateRole (patron:string id:string new-account:string)
        @doc "Moves the Create Role to another Ouronet Account. A single Account may have this Role \
            \ This is the only account that can issue new SFTs in the Collection"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-R::C_MoveCreateRole id true new-account)
                )
            )
        )
    )
    (defun DPSF|C_MoveRecreateRole (patron:string id:string new-account:string)
        @doc "Moves the Recreate Role to another Ouronet Account. A single Account may have this Role \
            \ This is the only account that can recreate any existing SFT in the Collection \
            \ Recreation reffers to a complete update (modification) of all SFT properties of a given nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-R::C_MoveRecreateRole id true new-account)
                )
            )
        )
    )
    (defun DPSF|C_MoveSetUriRole (patron:string id:string new-account:string)
        @doc "Moves the Set URI Role to another Ouronet Account. A single Account may have this Role \
            \ This is the only account that can modify the URIs of any nonce in the SFT Collection"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-R:module{DpdcRoles} DPDC-R)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-R::C_MoveSetUriRole id true new-account)
                )
            )
        )
    )
    ;;
    ;;  [6] DPDC-MNG
    ;;
    (defun DPSF|C_Control (patron:string id:string cu:bool cco:bool ccc:bool casr:bool ctncr:bool cf:bool cw:bool cp:bool)
        @doc "Controls DPSF Properties"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG) 
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-MNG::C_Control id true cu cco ccc casr ctncr cf cw cp)
                )
            )
        )
    )
    (defun DPSF|C_TogglePause (patron:string id:string toggle:bool)
        @doc "Pauses a DPSF Collection. Paused Collections can no longer be transfered"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG) 
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-MNG::C_TogglePause id true toggle)
                )
            )
        )
    )
    (defun DPSF|C_AddQuantity (patron:string id:string account:string nonce:integer amount:integer)
        @doc "Increases the Quantity for SFT <id> <nonce> by <amount> on <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG) 
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-MNG::C_AddQuantity account id nonce amount)
                )
                (format "Successfully added {} Units for SFT {} Nonce {} on Account {}" [amount id nonce (UC_ShortAccount account)])
            )
        )
    )
    (defun DPSF|C_Burn (patron:string id:string account:string nonce:integer amount:integer)
        @doc "Decreases the Quantity for SFT <id> <nonce> by <amount> on <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG) 
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-MNG::C_BurnSFT account id nonce amount)
                )
                (format "Successfully burned {} Units for SFT {} Nonce {} on Account {}" [amount id nonce (UC_ShortAccount account)])
            )
        )
    )
    (defun DPSF|C_WipeNoncePartialy (patron:string id:string account:string nonce:integer amount:integer)
        @doc "Wipes a partial <amount> of SFT <id> <nonce> from <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG) 
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-MNG::C_WipeSlim account id nonce amount)
                )
                (format "Successfully wiped {} Units for SFT {} Nonce {} from Account {}" [amount id nonce (UC_ShortAccount account)])
            )
        )
    )
    (defun DPSF|C_WipeNonce (patron:string id:string account:string nonce:integer)
        @doc "Wipes the SFT <id> <nonce> from <account>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-MNG::C_WipeNonce account id true nonce)
                )
                (format "Successfully wiped SFT {} Nonce {} from Account {}" [id nonce (UC_ShortAccount account)])
            )
        )
    )
    (defun DPSF|C_WipeHeavy (patron:string account:string id:string)
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-DPDC-MNG::C_WipeHeavy account id true)
                    )
                    (no-of-nonces:integer (length (at "r-nonces" (at 0 (at "output" ico)))))
                    (total-nonces-supplies:integer (fold (+) 0 (at "r-amounts" (at 0 (at "output" ico)))))
                )
                (ref-IGNIS::C_Collect patron ico)
                (format 
                    "Successfully executed Heavy Wipe of SFT {} on Account {}, wiping {} Nonces With a Total Supply of {}" 
                    [id (UC_ShortAccount account) no-of-nonces total-nonces-supplies]
                )
            )
        )
    )
    (defun DPSF|C_WipePure (patron:string account:string id:string removable-nonces-obj:object{DpdcManagement.RemovableNonces})
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-DPDC-MNG::C_WipePure account id true removable-nonces-obj) 
                    )
                    (no-of-nonces:integer (length (at "r-nonces" (at 0 (at "output" ico)))))
                    (total-nonces-supplies:integer (fold (+) 0 (at "r-amounts" (at 0 (at "output" ico)))))
                )
                (ref-IGNIS::C_Collect patron ico)
                (format 
                    "Successfully executed Pure Wipe of SFT {} on Account {}, wiping {} Nonces With a Total Supply of {}" 
                    [id (UC_ShortAccount account) no-of-nonces total-nonces-supplies]
                )
            )
        )
    )
    (defun DPSF|C_WipeClean (patron:string account:string id:string nonces:[integer])
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-DPDC-MNG::C_WipeClean account id true nonces) 
                    )
                    (no-of-nonces:integer (length (at "r-nonces" (at 0 (at "output" ico)))))
                    (total-nonces-supplies:integer (fold (+) 0 (at "r-amounts" (at 0 (at "output" ico)))))
                )
                (ref-IGNIS::C_Collect patron ico)
                (format 
                    "Successfully executed Clean Wipe of SFT {} on Account {}, wiping {} Nonces With a Total Supply of {}" 
                    [id (UC_ShortAccount account) no-of-nonces total-nonces-supplies]
                )
            )
        )
    )
    (defun DPSF|C_WipeDirty (patron:string account:string id:string nonces:[integer])
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-MNG:module{DpdcManagement} DPDC-MNG)
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-DPDC-MNG::C_WipeDirty account id true nonces)
                    )
                    (no-of-nonces:integer (length (at "r-nonces" (at 0 (at "output" ico)))))
                    (total-nonces-supplies:integer (fold (+) 0 (at "r-amounts" (at 0 (at "output" ico)))))
                )
                (ref-IGNIS::C_Collect patron ico)
                (format 
                    "Successfully executed Dirty Wipe of SFT {} on Account {}, wiping {} Nonces With a Total Supply of {}" 
                    [id (UC_ShortAccount account) no-of-nonces total-nonces-supplies]
                )
            )
        )
    )
    ;;
    ;;  [7] DPDC-T
    ;;
    (defun DPSF|C_Repurpose (patron:string id:string repurpose-from:string repurpose-to:string nonces:[integer] amounts:[integer])
        @doc "Repurpose SFT(s) from <repurpose-from> to <repurpose-to>. Requires <id> ownerhsip"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-DPDC-T:module{DpdcTransferV4} DPDC-T)
                    (sf:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-from))
                    (st:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-to))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-T::C_RepurposeCollectable id true repurpose-from repurpose-to nonces amounts)
                )
                (format "Successfully repurposed SFT {} Nonces {} with Amounts {} from {} to {}" [id nonces amounts sf st])
            )
        )
    )
    (defun DPSF|C_TransferNonce (patron:string id:string sender:string receiver:string nonce:integer amount:integer method:bool)
        @doc "Transfer an SFT <nonce> of <amount> from <sender> to <receiver> using <method>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-DPDC-T:module{DpdcTransferV4} DPDC-T)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount sender))
                    (ra:string (ref-I|OURONET::OI|UC_ShortAccount receiver))
                    ;;
                    (irs:object{DpdcTransferV4.AggregatedRoyalties}
                        (ref-DPDC-T::C_IgnisRoyaltyCollector patron sender [id] [true] [[nonce]] [[amount]])
                    )
                    (r:[decimal] (at "ignis-royalties" irs))
                    (s:decimal (fold (+) 0.0 r))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-T::C_Transfer [id] [true] sender receiver [[nonce]] [[amount]] method)
                )
                [
                    (format "Successfully transfered SFT {} Nonce {} and Amount {} from {} to {}" [id nonce amount sa ra])
                    (if (= s 0.0)
                        (format "Transfer executed without collecting any IGNIS Royalties for the Collectable {}" [id])
                        (format "Transfer executed while collecting {} IGNIS Royalty to the Collectable {} Creator" [s id])
                    )
                ]
            )
        )
    )
    (defun DPSF|C_TransferNonces (patron:string id:string sender:string receiver:string nonces:[integer] amounts:[integer] method:bool)
        @doc "Transfer an SFT <nonce> of <amount> from <sender> to <receiver> using <method>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-DPDC-T:module{DpdcTransferV4} DPDC-T)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount sender))
                    (ra:string (ref-I|OURONET::OI|UC_ShortAccount receiver))
                    ;;
                    (irs:object{DpdcTransferV4.AggregatedRoyalties}
                        (ref-DPDC-T::C_IgnisRoyaltyCollector patron sender [id] [true] [nonces] [amounts])
                    )
                    (c:[string] (at "creators" irs))
                    (r:[decimal] (at "ignis-royalties" irs))
                    (s:decimal (fold (+) 0.0 r))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-T::C_Transfer [id] [true] sender receiver [nonces] [amounts] method)
                )
                [
                    (format "Successfully transfered SFT {} Nonces {} with Amounts {} from {} to {}" [id nonces amounts sa ra])
                    (if (= s 0.0)
                        (format "Transfer executed without collecting any IGNIS Royalties for the Collectable {}" [id])
                        (format "Transfer executed while collecting {} IGNIS Royalty to the Collectable {} Creator" [s id])
                    )
                ]
            )
        )
    )
    ;;
    ;;  [8] DPDC-S
    ;;
    (defun DPSF|C_Make
        (patron:string account:string id:string nonces:[integer] set-class:integer how-many-sets:integer)
        @doc "Makes a Set SFT of Class <set-class>"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-DPDC-S:module{DpdcSetsV4} DPDC-S)
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
                    (nonce:integer (ref-DPDC-S::UR_NonceOfSet id set-class))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-S::C_MakeSemiFungibleSet account id nonces set-class how-many-sets)
                )
                (format "Successfully generated {} Class {} Sets (Nonce {}) of SFT Collection {} on Account {}" [how-many-sets set-class nonce id sa])
            )
        )
    )
    (defun DPSF|C_Break
        (patron:string account:string id:string nonce:integer how-many-sets:integer)
        @doc "Brakes an SFT Nonce representing an SFT Set"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-DPDC:module{DpdcV4} DPDC)
                    (ref-DPDC-S:module{DpdcSetsV4} DPDC-S)
                    (set-class:integer (ref-DPDC::UR_NonceClass id true nonce))
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-S::C_BreakSemiFungibleSet account id nonce how-many-sets)
                )
                (format "Successfully broken {} Class {} Sets (Nonce {}) of SFT Collection {} on Account {}" [how-many-sets set-class nonce id sa])
            )
        )
    )
    (defun DPSF|C_DefinePrimordialSet
        (
            patron:string id:string set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdcV3.DPDC|AllowedNonceForSetPosition}]
            ind:object{DpdcUdcV3.DPDC|NonceData}
        )
        @doc "Defines a New Primordial SFT Set. Primordial Sets are composed of Class 0 Nonces"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-S:module{DpdcSetsV4} DPDC-S)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-S::C_DefinePrimordialSet id true set-name score-multiplier set-definition ind)
                )
                (format "Primordial Set <{}> for SFT Collection {} defined succesfully" [set-name id])
            )
        )
    )
    (defun DPSF|C_DefineCompositeSet
        (
            patron:string id:string set-name:string score-multiplier:decimal
            set-definition:[object{DpdcUdcV3.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdcV3.DPDC|NonceData}
        )
        @doc "Defines a New Composite SFT Set. Composite Sets are composed of Class (!=0) Nonces"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-S:module{DpdcSetsV4} DPDC-S)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-S::C_DefineCompositeSet id true set-name score-multiplier set-definition ind)
                )
                (format "Composite Set <{}> for SFT Collection {} defined succesfully" [set-name id])
            )
        )
    )
    (defun DPSF|C_DefineHybridSet
        (
            patron:string id:string set-name:string score-multiplier:decimal
            primordial-sd:[object{DpdcUdcV3.DPDC|AllowedNonceForSetPosition}]
            composite-sd:[object{DpdcUdcV3.DPDC|AllowedClassForSetPosition}]
            ind:object{DpdcUdcV3.DPDC|NonceData}
        )
        @doc "Defines a New Hybrid SFT Set. Hybrid Sets are composed of both Class 0 and Non-0 Nonces"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-S:module{DpdcSetsV4} DPDC-S)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-S::C_DefineHybridSet id true set-name score-multiplier primordial-sd composite-sd ind)
                )
                (format "Hybrid Set <{}> for SFT Collection {} defined succesfully" [set-name id])
            )
        )
    )
    (defun DPSF|C_EnableSetClassFragmentation
        (
            patron:string id:string set-class:integer
            fragmentation-ind:object{DpdcUdcV3.DPDC|NonceData}
        )
        @doc "Enables Fragmentation for a given Set Class. This allows all SFTs of the given Set Class to be Fragmented"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-S:module{DpdcSetsV4} DPDC-S)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-S::C_EnableSetClassFragmentation id true set-class fragmentation-ind)
                )
                (format "Set Class {} for SFT {} succesfully fragmented" [set-class id])
            )
        )
    )
    (defun DPSF|C_ToggleSet (patron:string id:string set-class:integer toggle:bool)
        @doc "Enables or Disables a Set. A disabled Set allows only for decomposition of Set Elements, but not for composition"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-S:module{DpdcSetsV4} DPDC-S)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-S::C_ToggleSet id true set-class toggle)
                )
                (format "SFT {} Set Class {} succesfully turned {}" [id set-class (if toggle "ON" "OFF")])
            )
        )
    )
    (defun DPSF|C_RenameSet (patron:string id:string set-class:integer new-name:string)
        @doc "Renames an SFT Set"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-S:module{DpdcSetsV4} DPDC-S)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-S::C_RenameSet id true set-class new-name)
                )
                (format "SFT {} Set Class {} succesfuly renamed to <{}>" [id set-class new-name])
            )
        )
    )
    (defun DPSF|C_UpdateSetMultiplier (patron:string id:string set-class:integer new-multiplier:decimal)
        @doc "Updates an SFT Set Multiplier"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-S:module{DpdcSetsV4} DPDC-S)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-S::C_UpdateSetMultiplier id true set-class new-multiplier)
                )
                (format "SFT {} Set Score Multiplier {} succesfuly updated to <{}>" [id set-class new-multiplier])
            )
        )
    )
    ;;
    (defun DPSF|C_UpdateSetNonce 
        (patron:string id:string account:string set-class:integer nos:bool new-nonce-data:object{DpdcUdcV3.DPDC|NonceData})
        @doc "[0] Updates Full Set Nonce Data, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonces id true account [set-class] nos false [new-nonce-data])
                )
            )
        )
    )
    (defun DPSF|C_UpdateSetNonces
        (patron:string id:string account:string set-classes:[integer] nos:bool new-nonces-data:[object{DpdcUdcV3.DPDC|NonceData}])
        @doc "[0] Updates Full Set Nonce Data, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonces id true account set-classes nos false new-nonces-data)
                )
            )
        )
    )
    (defun DPSF|C_UpdateSetNonceRoyalty
        (patron:string id:string account:string set-class:integer nos:bool royalty-value:decimal)
        @doc "[1] Updates Set Nonce Native Royalty Value, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceRoyalty id true account set-class nos false royalty-value)
                )
            )
        )
    )
    (defun DPSF|C_UpdateSetNonceIgnisRoyalty
        (patron:string id:string account:string set-class:integer nos:bool royalty-value:decimal)
        @doc "[2] Updates Set Nonce IGNIS Royalty Value, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceIgnisRoyalty id true account set-class nos false royalty-value)
                )
            )
        )
    )
    (defun DPSF|C_UpdateSetNonceName
        (patron:string id:string account:string set-class:integer nos:bool name:string)
        @doc "[3] Updates Set Nonce Name, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceName id true account set-class nos false name)
                )
            )
        )
    )
    (defun DPSF|C_UpdateSetNonceDescription
        (patron:string id:string account:string set-class:integer nos:bool description:string)
        @doc "[4] Updates Set Nonce Description, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceDescription id true account set-class nos false description)
                )
            )
        )
    )
    (defun DPSF|C_UpdateSetNonceScore
        (patron:string id:string account:string set-class:integer nos:bool score:decimal)
        @doc "[5] Updates Set Nonce Score, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceScore id true account set-class nos false score)
                )
            )
        )
    )
    (defun DPSF|C_RemoveSetNonceScore (patron:string id:string account:string set-class:integer nos:bool)
        @doc "[5b] Removes Set Nonce Score, setting it to -1.0, either Native or Split, for an SFT"
        (DPSF|C_UpdateNonceScore patron id account set-class nos -1.0)
    )
    (defun DPSF|C_UpdateSetNonceMetaData
        (patron:string id:string account:string set-class:integer nos:bool meta-data:object)
        @doc "[6] Updates Set Nonce Meta-Data, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceMetaData id true account set-class nos false meta-data)
                )
            )
        )
    )
    (defun DPSF|C_UpdateSetNonceURI
        (
            patron:string id:string account:string set-class:integer nos:bool
            ay:object{DpdcUdcV3.URI|Type} u1:object{DpdcUdcV3.URI|Data} u2:object{DpdcUdcV3.URI|Data} u3:object{DpdcUdcV3.URI|Data}
        )
        @doc "[7] Updates Set Nonce URI, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceURI id true account set-class nos false ay u1 u2 u3)
                )
            )
        )
    )
    ;;
    ;;  [9] DPDC-F
    ;;
    (defun DPSF|C_RepurposeFragments (patron:string id:string repurpose-from:string repurpose-to:string nonces:[integer] amounts:[integer])
        @doc "Repurpose SFT Fragment(s) from <repurpose-from> to <repurpose-to>. Requires <id> ownerhsip"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-DPDC-F:module{DpdcFragmentsV4} DPDC-F)
                    (sf:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-from))
                    (st:string (ref-I|OURONET::OI|UC_ShortAccount repurpose-to))
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-F::C_RepurposeCollectableFragments id true repurpose-from repurpose-to nonces amounts)
                )
                (format "Successfully repurposed SFT {} Fragment-Nonces {} with Amounts {} from {} to {}" [id nonces amounts sf st])
            )
        )
    )
    (defun DPSF|C_MakeFragments (patron:string account:string id:string nonce:integer amount:integer)
        @doc "Fragments SFT nonce of the given amount into its respective Fragments."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-F:module{DpdcFragmentsV4} DPDC-F)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-F::C_MakeFragments account id true nonce amount)
                )
                (format "Successfully Fragmented {} SFT(s) {} of Nonce {}" [amount id nonce])
            )
        )
    )
    (defun DPSF|C_MergeFragments (patron:string account:string id:string nonce:integer amount:integer)
        @doc "MErges SFT Fragments nonces of the given amount into the original SFT nonce."
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-F:module{DpdcFragmentsV4} DPDC-F)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-F::C_MergeFragments account id true nonce amount)
                )
                (format "Successfully merged {} {} SFT(s) Fragments of Nonce {}" [amount id nonce])
            )
        )
    )
    (defun DPSF|C_EnableNonceFragmentation (patron:string id:string nonce:integer fragmentation-ind:object{DpdcUdcV3.DPDC|NonceData})
        @doc "Enables Fragmentation for a given SFT Nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-F:module{DpdcFragmentsV4} DPDC-F)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-F::C_EnableNonceFragmentation id true nonce fragmentation-ind)
                )
                (format "Fragmentation for SFT {} Nonce {} enabled succesfully" [id nonce])
            )
        )
    )
    ;;
    ;;  [10] DPDC-N
    ;;
    (defun DPSF|C_UpdateNonce
        (patron:string id:string account:string nonce:integer nos:bool new-nonce-data:object{DpdcUdcV3.DPDC|NonceData})
        @doc "[0] Updates Full Nonce Data, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonces id true account [nonce] nos true [new-nonce-data])
                )
            )
        )
    )
    (defun DPSF|C_UpdateNonces
        (patron:string id:string account:string nonces:[integer] nos:bool new-nonces-data:[object{DpdcUdcV3.DPDC|NonceData}])
        @doc "[0] Updates Full Nonce Data, either Native or Split, for an SFT, for multiple Nonces at a time"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonces id true account nonces nos true new-nonces-data)
                )
            )
        )
    )
    (defun DPSF|C_UpdateNonceRoyalty
        (patron:string id:string account:string nonce:integer nos:bool royalty-value:decimal)
        @doc "[1] Updates Nonce Native Royalty Value, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceRoyalty id true account nonce nos true royalty-value)
                )
            )
        )
    )
    (defun DPSF|C_UpdateNonceIgnisRoyalty
        (patron:string id:string account:string nonce:integer nos:bool royalty-value:decimal)
        @doc "[2] Updates Nonce IGNIS Royalty Value, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceIgnisRoyalty id true account nonce nos true royalty-value)
                )
            )
        )
    )
    (defun DPSF|C_UpdateNonceName
        (patron:string id:string account:string nonce:integer nos:bool name:string)
        @doc "[3] Updates Nonce Name, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceName id true account nonce nos true name)
                )
            )
        )
    )
    (defun DPSF|C_UpdateNonceDescription
        (patron:string id:string account:string nonce:integer nos:bool description:string)
        @doc "[4] Updates Nonce Description, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceDescription id true account nonce nos true description)
                )
            )
        )
    )
    (defun DPSF|C_UpdateNonceScore
        (patron:string id:string account:string nonce:integer nos:bool score:decimal)
        @doc "[5] Updates Nonce Score, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceScore id true account nonce nos true score)
                )
            )
        )
    )
    (defun DPSF|C_RemoveNonceScore (patron:string id:string account:string nonce:integer nos:bool)
        @doc "[5b] Removes Nonce Score, setting it to -1.0, either Native or Split, for an SFT"
        (DPSF|C_UpdateNonceScore patron id account nonce nos -1.0)
    )
    (defun DPSF|C_UpdateNonceMetaData
        (patron:string id:string account:string nonce:integer nos:bool meta-data:object)
        @doc "[6] Updates Nonce Meta-Data, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceMetaData id true account nonce nos true meta-data)
                )
            )
        )
    )
    (defun DPSF|C_UpdateNonceURI
        (
            patron:string id:string account:string nonce:integer nos:bool
            ay:object{DpdcUdcV3.URI|Type} u1:object{DpdcUdcV3.URI|Data} u2:object{DpdcUdcV3.URI|Data} u3:object{DpdcUdcV3.URI|Data}
        )
        @doc "[7] Updates Nonce URI, either Native or Split, for an SFT"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-DPDC-N:module{DpdcNonceV4} DPDC-N)
                )
                (ref-IGNIS::C_Collect patron
                    (ref-DPDC-N::C_UpdateNonceURI id true account nonce nos true ay u1 u2 u3)
                )
            )
        )
    )
    ;;
    ;;  [11] EQUITY
    ;;
    (defun DPSF|C_IssueCompany:string
        (
            patron:string creator-account:string collection-name:string collection-ticker:string
            royalty:decimal ignis-royalty:decimal ipfs-links:[string]
        )
        @doc "Issues an SFT Equity Collection to tokenize Company Shares on Ouronet. \
            \ Royalty is the standard Royalty for the Whole Collection \
            \ While <ignis-royalty> is the ignis Royalty for 1% of Company Shares \
            \ This makes the value of <ignis-royalty> in $ the Price to transfer All Existing Shares as Package Shares \
            \ \
            \ <ipfs-links> must be 8 elements long.\
            \ The Collection is an Image SFT Collection, automanaged by the <dpdc> Smart Ouronet Account as Collection Owner \
            \ Only 8 Elements can exist in this Collection, and no more can be added. \
            \ \
            \ Equity Collections Costs 0.001 IGNIS per Share for Pure Share Transfers as GAS Fees. \
            \ Package Share cost the normal <ignis|small> price per unit as GAS Fees, as for all SFTs.\
            \ \
            \ <ipfs-links> must contain a 24 string list, 8 links for each element in the primary secondarz and tertiary uri list"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-TS01-A:module{TalosStageOne_AdminV5} TS01-A)
                    (ref-EQUITY:module{Equity} EQUITY)
                    ;;
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-EQUITY::C_IssueShareholderCollection 
                            patron creator-account collection-name collection-ticker
                            royalty ignis-royalty ipfs-links
                        )
                    )
                )
                (ref-IGNIS::C_Collect patron ico)
                (ref-TS01-A::XB_DynamicFuelKDA)
                (at 0 (at "output" ico))
            )
        )
    )
    (defun DPSF|C_MorphEquity
        (patron:string account:string id:string input-nonce:integer input-amount:integer output-nonce:integer)
        @doc "Converts any Nonce to [1 2 3 4 5 6 7 8] to any Nonce [1 2 3 4 5 6 7 8] \
            \ Input-Nonce must be different from Output-Nonce"
        (with-capability (P|TS)
            (let
                (
                    (ref-IGNIS:module{IgnisCollectorV2} IGNIS)
                    (ref-I|OURONET:module{OuronetInfoV3} INFO-ZERO)
                    (ref-DPDC-T:module{DpdcTransferV4} DPDC-T)
                    (ref-EQUITY:module{Equity} EQUITY)
                    ;;
                    (ico:object{IgnisCollectorV2.OutputCumulator}
                        (ref-EQUITY::C_MorphPackageShares
                            account id input-nonce input-amount output-nonce
                        )
                    )
                    (output:list (at "output" ico))
                    (ir-nonces:[integer] (at 0 output))
                    (ir-amounts:[integer] (at 1 output))
                    (sa:string (ref-I|OURONET::OI|UC_ShortAccount account))
                    ;;
                    (irs:object{DpdcTransferV4.AggregatedRoyalties}
                        (ref-DPDC-T::C_IgnisRoyaltyCollector patron account [id] [true] [ir-nonces] [ir-amounts])
                    )
                    (c:[string] (at "creators" irs))
                    (r:[decimal] (at "ignis-royalties" irs))
                    (s:decimal (fold (+) 0.0 r))
                )
                (ref-IGNIS::C_Collect patron ico)
                (if (= input-nonce 1)
                    [
                        ;;Make Package Shares
                        (format "Successfully combined {} Shares to Tier {} Package Share on Account {}" [input-amount (- output-nonce 1) sa])
                        (if (= s 0.0)
                            (format "Combining Shares executed witout collecting any IGNIS Royalties for the Collectable {}" [id])
                            (format "Combining Shares executed while collecting {} IGNIS Royalty to the Collectable {} Creator" [s id])
                        )
                    ]
                    (if (= output-nonce 1)
                        [
                            ;;Brake Package Shares
                            (format "Successfully broke {} Tier {} Package Share to {} Shares on Account {}" [input-amount (- input-nonce 1) (at 1 ir-amounts) sa])
                            (if (= s 0.0)
                                (format "Breaking Package Shares executed witout collecting any IGNIS Royalties for the Collectable {}" [id])
                                (format "Breaking Package Shares executed while collecting {} IGNIS Royalty to the Collectable {} Creator" [s id])
                            )
                        ]
                        [
                            ;;Convert Package Shares
                            (format "Successfully Converter Tier {} to Tier {} Package Shares on Account {}" [(- input-nonce 1) (- output-nonce 1) sa])
                            (if (= s 0.0)
                                (format "Converting Package Shares executed witout collecting any IGNIS Royalties for the Collectable {}" [id])
                                (format "Converting Package Shares executed while collecting {} IGNIS Royalty to the Collectable {} Creator" [s id])
                            )
                        ]
                        
                        
                    )
                )
            )
        )
    )
    ;;
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)