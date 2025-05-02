(namespace "n_7d40ccda457e374d8eb07b658fd38c282c545038")
(interface Branding
    @doc "Interface Exposing the Branding Functions needed to create the Branding Functionality \
    \ Entities are DPTF DPMF DPSF DPNF ATSPairs SWPairs \
    \ Should Future entities be added, they too can be branded via this module"
    ;;
    (defschema Schema
        logo:string
        description:string
        website:string
        social:[object{SocialSchema}]
        flag:integer
        genesis:time
        premium-until:time
    )
    (defschema SocialSchema
        social-media-name:string
        social-media-link:string
    )
    ;;
    (defun UR_Branding:object{Schema} (id:string pending:bool))
    (defun UR_Logo:string (id:string pending:bool))
    (defun UR_Description:string (id:string pending:bool))
    (defun UR_Website:string (id:string pending:bool))
    (defun UR_Social:[object{SocialSchema}] (id:string pending:bool))
    (defun UR_Flag:integer (id:string pending:bool))
    (defun UR_Genesis:time (id:string pending:bool))
    (defun UR_PremiumUntil:time (id:string pending:bool))
    ;;
    (defun URC_MaxBluePayment (account:string))
    ;;
    (defun UDC_BrandingLogo:object{Schema} (input:object{Schema} logo:string))
    (defun UDC_BrandingDescription:object{Schema} (input:object{Schema} description:string))
    (defun UDC_BrandingWebsite:object{Schema} (input:object{Schema} website:string))
    (defun UDC_BrandingSocial:object{Schema} (input:object{Schema} social:[object{SocialSchema}]))
    (defun UDC_BrandingFlag:object{Schema} (input:object{Schema} flag:integer))
    (defun UDC_BrandingPremium:object{Schema} (input:object{Schema} premium:time))
    ;;
    (defun A_Live (entity-id:string))
    (defun A_SetFlag (entity-id:string flag:integer))
    ;;
    (defun XE_Issue (entity-id:string))
    (defun XE_UpdatePendingBranding (entity-id:string logo:string description:string website:string social:[object{SocialSchema}]))
    (defun XE_UpgradeBranding:decimal (entity-id:string entity-owner-account:string months:integer))
)
(interface BrandingUsage
    @doc "Interface Exposing the Actual Branding Functions, that must exist within each Entitys main Module \
    \ such that said Entity can benefit from Branding. \
    \ Stage 1 deployment launches following entities: DPTF, DPMF, ATSPairs, SWPairs"
    ;;
    (defun C_UpdatePendingBranding:object{OuronetDalos.IgnisCumulator} (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])) ;;4
    (defun C_UpgradeBranding (patron:string entity-id:string months:integer)) ;;4
)
(interface BrandingUsageV2
    @doc "Interface Exposing the Actual Branding Functions, that must exist within each Entitys main Module \
    \ such that said Entity can benefit from Branding. \
    \ Stage 1 deployment launches following entities: DPTF, DPMF, ATSPairs, SWPairs \
    \ \
    \ V2 switches to IgnisCumulatorV2 Architecture repairing the collection of Ignis for Smart Ouronet Accounts"
    ;;
    (defun C_UpdatePendingBranding:object{OuronetDalosV2.OutputCumulatorV2} (patron:string entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun C_UpgradeBranding (patron:string entity-id:string months:integer))
)
(interface BrandingUsageV3
    @doc "Interface Exposing the Branding Functions for DPTF LP Tokens \
    \ Using the IgnisCUmulatorV2 Architecture which repairs the collection of Ignis for Smart Ouronet Accounts"
    ;;
    (defun C_UpdatePendingBrandingLPs:object{OuronetDalosV2.OutputCumulatorV2} (patron:string swpair:string entity-pos:integer logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun C_UpgradeBrandingLPs (patron:string swpair:string entity-pos:integer months:integer))
)
;;
(interface BrandingUsageV4
    @doc "Exposes Branding Functions for True-Fungibles (T), Meta-Fungibles (M), ATS-Pairs (A) and SWP-Pairs (S) \
        \ Uses V2 IgnisCumulatorV2 Architecture (fixed Ignis Collection for Smart Ouronet Accounts) \
        \ V4 Removes <patron> input variable where it is not needed"
    ;;
    (defun C_UpdatePendingBranding:object{OuronetDalosV3.OutputCumulatorV2} (entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun C_UpgradeBranding (patron:string entity-id:string months:integer))
)
(interface BrandingUsageV5
    @doc "Exposes Branding Functions for True-Fungible LP Tokens \
        \ <entity-pos>: 1 (Native LP), 2 (Freezing LP), 3 (Sleeping LP) \
        \ Uses V2 IgnisCumulatorV2 Architecture (fixed Ignis Collection for Smart Ouronet Accounts) \
        \ V5 Removes <patron> input variable where it is not needed"
    ;;
    (defun C_UpdatePendingBrandingLPs:object{OuronetDalosV3.OutputCumulatorV2} (swpair:string entity-pos:integer logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun C_UpgradeBrandingLPs (patron:string swpair:string entity-pos:integer months:integer))
)
(interface BrandingUsageV6
    @doc "Exposes Branding Functions for Semi-Fungibles (S) and Non-Fungibles (N) \
        \ Uses V2 IgnisCumulatorV2 Architecture (fixed Ignis Collection for Smart Ouronet Accounts)"
    ;;
    (defun C_UpdatePendingBranding:object{OuronetDalosV3.OutputCumulatorV2} (entity-id:string sft-or-nft:bool logo:string description:string website:string social:[object{Branding.SocialSchema}]))
    (defun C_UpgradeBranding (patron:string entity-id:string sft-or-nft:bool  months:integer))
)

(module BRD GOV
    ;;
    (implements OuronetPolicy)
    (implements Branding)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DPTF           (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|BRD_ADMIN)))
    (defcap GOV|BRD_ADMIN ()        (enforce-guard GOV|MD_DPTF))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|BRD|CALLER ()
        true
    )
    ;;{P4}
    (defconst P|I                   (P|Info))
    (defun P|Info ()                (let ((ref-DALOS:module{OuronetDalosV3} DALOS)) (ref-DALOS::P|Info)))
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|UR_IMP:[guard] ()
        (at "m-policies" (read P|MT P|I ["m-policies"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|BRD_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|BRD_ADMIN)
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
                (mg:guard (create-capability-guard (P|BRD|CALLER)))
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
    (defschema BRD|PropertiesSchema
        branding:object{Branding.Schema}
        branding-pending:object{Branding.Schema}
    )
    ;;{2}
    (deftable BRD|BrandingTable:{BRD|PropertiesSchema})
    ;;{3}
    (defun CT_Bar ()                (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_BAR)))
    (defconst BAR                   (CT_Bar))
    (defconst BRD|DEFAULT
        {"logo"                 : BAR
        ,"description"          : BAR
        ,"website"              : BAR
        ,"social"               : [SOCIAL|EMPTY]
        ,"flag"                 : 3
        ,"genesis"              : (at "block-time" (chain-data))
        ,"premium-until"        : (at "block-time" (chain-data))}
    )
    (defconst SOCIAL|EMPTY
        {"social-media-name"    : BAR
        ,"social-media-link"    : BAR}
    )
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
    (defcap BRD|C>ADMIN_SET (flag:integer)
        @event
        (enforce (contains flag (enumerate 0 4)) "Invalid Integer Flag")
        (compose-capability (GOV|BRD_ADMIN))
        (compose-capability (SECURE))
    )
    (defcap BRD|C>LIVE ()
        @event
        (compose-capability (GOV|BRD_ADMIN))
        (compose-capability (SECURE))
    )
    (defcap BRD|C>UPGRADE (entity-id:string entity-owner-account:string months:integer)
        @event
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (mp:integer (URC_MaxBluePayment entity-owner-account))
                (flag:integer (UR_Flag entity-id false))
                (premium:time (UR_PremiumUntil entity-id false))
                (current:time (at "block-time" (chain-data)))
                (remaining:decimal (diff-time premium current))
            )
        ;;1] Enforces <entity-id> ownership
            (ref-DALOS::CAP_EnforceAccountOwnership entity-owner-account)
        ;;2] Flags 0 and 4 cannot be upgraded
            (enforce (!= flag 0) "Golden Flag cannot be upgraded")
            (enforce (!= flag 4) "Red Flag cannot be upgraded")
        ;;3] Max Payments in months depends on <entity-owner-account> Elite Account Level
            (enforce (<= months mp) "Invalid Months Integer")
        ;;4] Upgrading can only be done if premium time is less than 15 days. Also works when no premium time is available.
            (enforce (< remaining 1296000.0) "Blue Flag has more than 15 days remainig!")
        ;;5] Capability needed for accesing <XI_UpdateBrandingData>
            (compose-capability (SECURE))
        )
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    ;;{F0}  [UR]
    (defun UR_Branding:object{Branding.Schema} (id:string pending:bool)
        (if pending
            (with-read BRD|BrandingTable id
                { "branding-pending" := b }
                b
            )
            (with-read BRD|BrandingTable id
                { "branding" := b }
                b
            )
        )
    )
    (defun UR_Logo:string (id:string pending:bool)
        (at "logo" (UR_Branding id pending))
    )
    (defun UR_Description:string (id:string pending:bool)
        (at "description" (UR_Branding id pending))
    )
    (defun UR_Website:string (id:string pending:bool)
        (at "website" (UR_Branding id pending))
    )
    (defun UR_Social:[object{Branding.SocialSchema}] (id:string pending:bool)
        (at "social" (UR_Branding id pending))
    )
    (defun UR_Flag:integer (id:string pending:bool)
        (at "flag" (UR_Branding id pending))
    )
    (defun UR_Genesis:time (id:string pending:bool)
        (at "genesis" (UR_Branding id pending))
    )
    (defun UR_PremiumUntil:time (id:string pending:bool)
        (at "premium-until" (UR_Branding id pending))
    )
    ;;{F1}  [URC]
    (defun URC_MaxBluePayment (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalosV3} DALOS)
                (mt:integer (ref-DALOS::UR_Elite-Tier-Major account))
            )
            (if (<= mt 2)
                1
                (if (and (> mt 2)(< mt 5))
                    2
                    3
                )
            )
        )
    )
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    (defun UDC_BrandingLogo:object{Branding.Schema} (input:object{Branding.Schema} logo:string)
        {"logo"             : logo
        ,"description"      : (at "description" input)
        ,"website"          : (at "website" input)
        ,"social"           : (at "social" input)
        ,"flag"             : (at "flag" input)
        ,"genesis"          : (at "genesis" input)
        ,"premium-until"    : (at "premium-until" input)}
    )
    (defun UDC_BrandingDescription:object{Branding.Schema} (input:object{Branding.Schema} description:string)
        {"logo"             : (at "logo" input)
        ,"description"      : description
        ,"website"          : (at "website" input)
        ,"social"           : (at "social" input)
        ,"flag"             : (at "flag" input)
        ,"genesis"          : (at "genesis" input)
        ,"premium-until"    : (at "premium-until" input)}
    )
    (defun UDC_BrandingWebsite:object{Branding.Schema} (input:object{Branding.Schema} website:string)
        {"logo"             : (at "logo" input)
        ,"description"      : (at "description" input)
        ,"website"          : website
        ,"social"           : (at "social" input)
        ,"flag"             : (at "flag" input)
        ,"genesis"          : (at "genesis" input)
        ,"premium-until"    : (at "premium-until" input)}
    )
    (defun UDC_BrandingSocial:object{Branding.Schema} (input:object{Branding.Schema} social:[object{Branding.SocialSchema}])
        {"logo"             : (at "logo" input)
        ,"description"      : (at "description" input)
        ,"website"          : (at "website" input)
        ,"social"           : social
        ,"flag"             : (at "flag" input)
        ,"genesis"          : (at "genesis" input)
        ,"premium-until"    : (at "premium-until" input)}
    )
    (defun UDC_BrandingFlag:object{Branding.Schema} (input:object{Branding.Schema} flag:integer)
        (enforce (contains flag (enumerate 0 4)) "Invalid Flag Integer")
        {"logo"             : (at "logo" input)
        ,"description"      : (at "description" input)
        ,"website"          : (at "website" input)
        ,"social"           : (at "social" input)
        ,"flag"             : flag
        ,"genesis"          : (at "genesis" input)
        ,"premium-until"    : (at "premium-until" input)}
    )
    (defun UDC_BrandingPremium:object{Branding.Schema} (input:object{Branding.Schema} premium:time)
        {"logo"             : (at "logo" input)
        ,"description"      : (at "description" input)
        ,"website"          : (at "website" input)
        ,"social"           : (at "social" input)
        ,"flag"             : (at "flag" input)
        ,"genesis"          : (at "genesis" input)
        ,"premium-until"    : premium}
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    (defun A_Live (entity-id:string)
        (UEV_IMC)
        (with-capability (BRD|C>LIVE)
            (let
                (
                    (branding-pending:object{Branding.Schema} (UR_Branding entity-id true))
                    (flag:integer (UR_Flag entity-id false))
                    (updated-flag:integer (if (<= flag 1) flag 2))
                    (updated-branding:object{Branding.Schema} (UDC_BrandingFlag branding-pending updated-flag))
                    (np1:object{Branding.Schema} (UDC_BrandingLogo branding-pending BAR))
                    (np2:object{Branding.Schema} (UDC_BrandingDescription np1 BAR))
                    (np3:object{Branding.Schema} (UDC_BrandingWebsite np2 BAR))
                    (np4:object{Branding.Schema} (UDC_BrandingSocial np3 [SOCIAL|EMPTY]))
                )
                (XI_UpdateBrandingData entity-id false updated-branding)
                (XI_UpdateBrandingData entity-id true np4)
            )
        )
    )
    (defun A_SetFlag (entity-id:string flag:integer)
        (UEV_IMC)
        (with-capability (BRD|C>ADMIN_SET flag)
            (let
                (
                    (existing-branding:object{Branding.Schema} (UR_Branding entity-id false))
                    (modified-branding:object{Branding.Schema} (UDC_BrandingFlag existing-branding flag))
                )
                (XI_UpdateBrandingData entity-id false modified-branding)
            )
        )
    )
    ;;{F6}  [C]
    ;;{F7}  [X]
    (defun XE_Issue (entity-id:string)
        (UEV_IMC)
        (insert BRD|BrandingTable entity-id
            {"branding"                 : BRD|DEFAULT
            ,"branding-pending"         : BRD|DEFAULT}
        )
    )
    (defun XE_UpdatePendingBranding (entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> with new branding data. \
            \ This is done by <entity-id> owners to brand their <entity-id> \
            \ Branding Administrator must afterwards set this <pending-branding> data to live, \
            \ in order to activate the actual branding for the <entity-id>"
        (UEV_IMC)
        (let
            (
                (pending:object{Branding.Schema} (UR_Branding entity-id true))
                (p1:object{Branding.Schema} (UDC_BrandingLogo pending logo))
                (p2:object{Branding.Schema} (UDC_BrandingDescription p1 description))
                (p3:object{Branding.Schema} (UDC_BrandingWebsite p2 website))
                (p4:object{Branding.Schema} (UDC_BrandingSocial p3 social))
            )
            (with-capability (SECURE)
                (XI_UpdateBrandingData entity-id true p4)
            )
        )
    )
    (defun XE_UpgradeBranding:decimal (entity-id:string entity-owner-account:string months:integer)
        @doc "Upgrades Branding for <entity-id> to Blue Flag; Initial Cost set at 25 KDA per Month \
            \ KDA Cost may be adjusted in the future reflecting KDA Value \
            \ Number of months can be 1, 2 or 3, depending on <entity-owner-account> Major Elite Tier \
            \ Returns the value in KDA that is due to be collected \
            \ \
            \ \
            \ Upgrading a <4> Red Flag is not possible \
            \ \
            \ Upgrading a <3> Gray Flag, converts it to a <1> Blue Flag, and moves <pending-branding> to <live-branding> \
            \       essentialy setting the branding to live; Usefull when you dont need to wait for Branding Administrator \
            \       to manualy set the branding to live \
            \   When upgrading from a <3> Gray Flag, it is recommended to upgrade the <pending-branding> Data First \
            \       so as to benefit from the autonomic moving of the branding to live \
            \ \
            \ Upgrading a <2> Green Flag, converts it to a <1> Blue Flag \
            \       Keeps branding Data as is for both <branding> and <branding-pending> \
            \ \
            \ Upgrading a <1> Blue Flag is allowed if the <entity-id> remaining premium time is less than 15 days \
            \       This Extends the Premium Time \
            \       Keeps branding Data as is for both <branding> and <branding-pending> \
            \ \
            \ Upgrading a <0> Golden Flag is restricted, as Golden Flags are higher in hierachy than Blue Flags"
        (UEV_IMC)
        (with-capability (BRD|C>UPGRADE entity-id entity-owner-account months)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV3} DALOS)
                    (blue:decimal (ref-DALOS::UR_UsagePrice "blue"))
                    (branding:object{Branding.Schema} (UR_Branding entity-id false))
                    (branding-pending:object{Branding.Schema} (UR_Branding entity-id true))
                    (flag:integer (UR_Flag entity-id false))
                    (premium:time (UR_PremiumUntil entity-id false))
                    (seconds:decimal (fold (*) 1.0 [86400.0 30.0 (dec months)]))
                    (payment:decimal (* (dec months) blue))
                    (premium-until:time (add-time premium seconds))

                    (as-is1:object{Branding.Schema} (UDC_BrandingFlag branding 1))
                    (as-is2:object{Branding.Schema} (UDC_BrandingPremium as-is1 premium-until))

                    (from-pending1:object{Branding.Schema} (UDC_BrandingFlag branding-pending 1))
                    (from-pending2:object{Branding.Schema} (UDC_BrandingPremium from-pending1 premium-until))

                    (np1:object{Branding.Schema} (UDC_BrandingLogo branding-pending BAR))
                    (np2:object{Branding.Schema} (UDC_BrandingDescription np1 BAR))
                    (np3:object{Branding.Schema} (UDC_BrandingWebsite np2 BAR))
                    (np4:object{Branding.Schema} (UDC_BrandingSocial np3 [SOCIAL|EMPTY]))
                )
                (if (= flag 3)
                    (do
                        (XI_UpdateBrandingData entity-id false from-pending2)
                        (XI_UpdateBrandingData entity-id true np4)
                    )
                    (XI_UpdateBrandingData entity-id false as-is2)
                )
                payment
            )
        )
    )
    ;;
    (defun XI_UpdateBrandingData (entity-id:string pending:bool branding:object{Branding.Schema})
        (require-capability (SECURE))
        (if pending
            (update BRD|BrandingTable entity-id
                {"branding-pending" : branding}
            )
            (update BRD|BrandingTable entity-id
                {"branding" : branding}
            )
        )
    )
    ;;
)
(create-table P|T)
(create-table P|MT)
(create-table BRD|BrandingTable)