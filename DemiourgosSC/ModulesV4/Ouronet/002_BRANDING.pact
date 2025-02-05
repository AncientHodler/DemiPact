(module BRD GOV
    ;;
    (implements OuronetPolicy)
    (implements Branding)
    ;;{G1}
    (defconst GOV|MD_DPTF           (keyset-ref-guard (GOV|Demiurgoi)))
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|BRD_ADMIN)))
    (defcap GOV|BRD_ADMIN ()        (enforce-guard GOV|MD_DPTF))
    ;;{G3}
    (defun GOV|Demiurgoi ()         (let ((ref-DALOS:module{OuronetDalos} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S}) 
    ;;{P3}
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|BRD_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        true
    )
    ;;
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
                (ref-DALOS:module{OuronetDalos} DALOS)
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
        ;;5] Capability needed for accesing <X_UpdateBrandingData>
            (compose-capability (SECURE))
        )
    )
    ;;
    ;;{F0}
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
    ;;{F1}
    (defun URC_MaxBluePayment (account:string)
        (let
            (
                (ref-DALOS:module{OuronetDalos} DALOS)
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
    ;;{F2}
    (defun UEV_SpecificPolicy (match:string)
        @doc "Enforces one of matching policies that end in <match>"
        (let
            (
                (ref-U|G:module{OuronetGuards} U|G)
                (ref-U|LST:module{StringProcessor} U|LST)
                (keyz:[string] BRD|BrandingTable)
                (acces-keyz:[string] (ref-U|LST::UC_KeepEndMatch keyz match))
                (guards:[guard]
                    (fold
                        (lambda
                            (acc:[guard] idx:integer)
                            (ref-U|LST::UC_AppL
                                acc
                                (P|UR (at idx acces-keyz))
                            )
                        )
                        []
                        (enumerate 0 (- (length acces-keyz) 1))
                    )
                )
                (branding-acces:guard (ref-U|G::UEV_GuardOfAny guards))
            )
            (enforce-guard branding-acces)
        )
    )
    ;;{F3}
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
    ;;{F4}
    ;;{F5}
    (defun A_SetFlag (entity-id:string flag:integer)
        @doc "Forcibly (in administrator mode) sets a Branding Flag for <entity-id> \
        \ <0> Flag = Golden Flag        Premium Flag reserved for Demiourgos Entity IDs \
        \ <1> Flag = Blue Flag          Premium Flag for Entity IDs (non-Demiourgos); \
        \                               Premium Flags are paid live branded Entity-IDs that are not labeled as problematic \
        \                               Paid live branded Entity IDs can still be flaged Red by the Branding Administrator \
        \ <2> Flag = Green Flag         Standard Flag for Entity IDs (non-Demiourgos) that have their Branding set to Live \
        \ <3> Flag = Gray Flag          Default Flag for newly-issued Entity-IDs (non-Demiourgos) that dont have their Branding Live yet \
        \ <4> Flag = Red Flag           Problem Flag for Entity IDs, marking potential dangerous or scam Entity IDs"
        (with-capability (BRD|C>ADMIN_SET flag)
            (let
                (
                    (existing-branding:object{Branding.Schema} (UR_Branding entity-id false))
                    (modified-branding:object{Branding.Schema} (UDC_BrandingFlag existing-branding flag))
                )
                (X_UpdateBrandingData entity-id false modified-branding)
            )
        )
    )
    (defun A_Live (entity-id:string)
        @doc "Sets <pending-branding> for an <entity-id> to <live-branding>, reseting <pending-branding> data \
        \ Resetting <pending-branding> data does not reset its last 3 keys \
        \ Can only be done by Branding Administrator"
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
                (X_UpdateBrandingData entity-id false updated-branding)
                (X_UpdateBrandingData entity-id true np4)
            )
        )
    )
    ;;{F6}
    ;;{F7}
    (defun X_Issue (entity-id:string)
        (UEV_SpecificPolicy "Branding")
        (insert BRD|BrandingTable entity-id
            {"branding"                 : BRD|DEFAULT
            ,"branding-pending"         : BRD|DEFAULT}
        )
    )
    (defun X_UpdateBrandingData (entity-id:string pending:bool branding:object{Branding.Schema})
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
    (defun X_UpdatePendingBranding (entity-id:string logo:string description:string website:string social:[object{Branding.SocialSchema}])
        @doc "Updates <pending-branding> with new branding data. \
            \ This is done by <entity-id> owners to brand their <entity-id> \
            \ Branding Administrator must afterwards set this <pending-branding> data to live, \
            \ in order to activate the actual branding for the <entity-id>"
        (UEV_SpecificPolicy "Caller")
        (let
            (
                (pending:object{Branding.Schema} (UR_Branding entity-id true))
                (p1:object{Branding.Schema} (UDC_BrandingLogo pending logo))
                (p2:object{Branding.Schema} (UDC_BrandingDescription p1 description))
                (p3:object{Branding.Schema} (UDC_BrandingWebsite p2 website))
                (p4:object{Branding.Schema} (UDC_BrandingSocial p3 social))
            )
            (with-capability (SECURE)
                (X_UpdateBrandingData entity-id true p4)
            )
        )
    )
    (defun X_UpgradeBranding:decimal (entity-id:string entity-owner-account:string months:integer)
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
        (UEV_SpecificPolicy "Caller")
        (with-capability (BRD|C>UPGRADE entity-id entity-owner-account months)
            (let
                (
                    (ref-DALOS:module{OuronetDalos} DALOS)
                    (blue:decimal (ref-DALOS::UR_UsagePrice "blue"))
                    (branding:object{Branding.Schema} (UR_Branding entity-id false))
                    (branding-pending:object{Branding.Schema} (UR_Branding entity-id true))
                    (flag:integer (UR_Flag entity-id false))
                    (premium:time (UR_PremiumUntil entity-id false))
                    (mdec:decimal (dec months))
                    (days:decimal (* 30.0 mdec))
                    (seconds:decimal (* 86400.0 days))
                    (payment:decimal (* mdec blue))
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
                        (X_UpdateBrandingData entity-id false from-pending2)
                        (X_UpdateBrandingData entity-id true np4)
                    )
                    (X_UpdateBrandingData entity-id false as-is2)
                )
                payment
            )
        )
    )
)

(create-table P|T)
(create-table BRD|BrandingTable)