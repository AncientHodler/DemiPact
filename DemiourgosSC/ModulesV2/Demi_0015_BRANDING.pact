;(namespace "n_9d612bcfe2320d6ecbbaa99b47aab60138a2adea")
(module BRANDING GOV
    ;;  
    ;;{G1}
    (defconst GOV|MD_BRANDING       (keyset-ref-guard DALOS.DALOS|DEMIURGOI))
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|BRANDING_ADMIN))
    )
    (defcap GOV|BRANDING_ADMIN ()
        (enforce-guard GOV|MD_BRANDING)
    )
    ;;{G3}
    ;;
    ;;{P1}
    (deftable P|T:{DALOS.P|S})
    ;;{P2}
    ;;{P3}
    (defcap P|BU ()
        true
    )
    ;;{P4}
    (defun P|UR:guard (policy-name:string)
        (at "policy" (read P|T policy-name ["policy"]))
    )
    (defun P|A_Add (policy-name:string policy-guard:guard)
        (with-capability (GOV|BRANDING_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_Define ()
        (DPTF.P|A_Add
            "BRD|Update"
            (create-capability-guard (P|BU))
        )
        (DPMF.P|A_Add
            "BRD|Update"
            (create-capability-guard (P|BU))
        )
    )
    ;;
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{4}
    (defcap COMPOSE ()
        true
    )
    ;;{5}
    ;;{6}
    ;;{7}
    (defcap BRD|C>ADMIN_EXT ()
        (compose-capability (GOV|BRANDING_ADMIN))
        (compose-capability (P|BU))
    )
    (defcap BRD|C>ADMIN_SET ()
        @event
        (compose-capability (BRD|C>ADMIN_EXT))
    )
    (defcap BRD|C>LIVE ()
        @event
        (compose-capability (BRD|C>ADMIN_EXT))
    )
    (defcap BRD|C>UPGRADE (id:string tt:bool)
        @event
        (BRD|CAP_Vieo id tt)
        (let
            (
                (cf:integer
                    (if tt
                        (DPTF.DPTF|URB_Flag id false)
                        (DPTF.DPTF|URB_Flag id false)
                    )
                )
            )
            (enforce (>= cf 1) "Golden Flag cannot be upgraded")
            (let*
                (
                    (premium:time 
                        (if tt
                            (DPTF.DPTF|URB_PremiumUntil id false)
                            (DPMF.DPMF|URB_PremiumUntil id false)
                        )
                    )
                    (current:time (at "block-time" (chain-data)))
                    (remaining:decimal (diff-time premium current))
                )
                (enforce (< remaining 1296000.0) "Blue Flag has more than 15 days remainig!")
            )
        )
        (compose-capability (P|BU))
    )
    (defcap BRD|C>BRANDING (id:string tt:bool)
        @event
        (BRD|CAP_Vieo id tt)
        (compose-capability (P|BU))
    )
    ;;
    ;;{8}
    (defun BRD|CAP_Vieo (id:string tt:bool)
        (if tt
            (BRD|CAP_VieoDPTF id)
            (BRD|CAP_VieoDPMF id)
        )
    )
    (defun BRD|CAP_VieoDPTF (id:string)
        (DPTF.DPTF|UEV_id id)
        (DPTF.DPTF|CAP_Owner id)
    )
    (defun BRD|CAP_VieoDPMF (id:string)
        (DPMF.DPMF|UEV_id id)
        (DPMF.DPMF|CAP_Owner id)
    )
    ;;{9}
    ;;{10}
    ;;{11}
    (defun BRD|UC_BrandingLogo:object{DALOS.BrandingSchema} (input:object{DALOS.BrandingSchema} logo:string)
        {"logo"             : logo
        ,"description"      : (at "description" input)
        ,"website"          : (at "website" input)
        ,"social"           : (at "social" input)
        ,"flag"             : (at "flag" input)
        ,"genesis"          : (at "genesis" input)
        ,"premium-until"    : (at "premium-until" input)}
    )
    (defun BRD|UC_BrandingDescription:object{DALOS.BrandingSchema} (input:object{DALOS.BrandingSchema} description:string)
        {"logo"             : (at "logo" input)
        ,"description"      : description
        ,"website"          : (at "website" input)
        ,"social"           : (at "social" input)
        ,"flag"             : (at "flag" input)
        ,"genesis"          : (at "genesis" input)
        ,"premium-until"    : (at "premium-until" input)}
    )
    (defun BRD|UC_BrandingWebsite:object{DALOS.BrandingSchema} (input:object{DALOS.BrandingSchema} website:string)
        {"logo"             : (at "logo" input)
        ,"description"      : (at "description" input)
        ,"website"          : website
        ,"social"           : (at "social" input)
        ,"flag"             : (at "flag" input)
        ,"genesis"          : (at "genesis" input)
        ,"premium-until"    : (at "premium-until" input)}
    )
    (defun BRD|UC_BrandingSocial:object{DALOS.BrandingSchema} (input:object{DALOS.BrandingSchema} social:[object{DALOS.SocialSchema}])
        {"logo"             : (at "logo" input)
        ,"description"      : (at "description" input)
        ,"website"          : (at "website" input)
        ,"social"           : social
        ,"flag"             : (at "flag" input)
        ,"genesis"          : (at "genesis" input)
        ,"premium-until"    : (at "premium-until" input)}
    )
    (defun BRD|UC_BrandingFlag:object{DALOS.BrandingSchema} (input:object{DALOS.BrandingSchema} flag:integer)
        (enforce (contains flag (enumerate 0 4)) "Invalid Flag Integer")
        {"logo"             : (at "logo" input)
        ,"description"      : (at "description" input)
        ,"website"          : (at "website" input)
        ,"social"           : (at "social" input)
        ,"flag"             : flag
        ,"genesis"          : (at "genesis" input)
        ,"premium-until"    : (at "premium-until" input)}
    )
    (defun BRD|UC_BrandingPremium:object{DALOS.BrandingSchema} (input:object{DALOS.BrandingSchema} premium:time)
        {"logo"             : (at "logo" input)
        ,"description"      : (at "description" input)
        ,"website"          : (at "website" input)
        ,"social"           : (at "social" input)
        ,"flag"             : (at "flag" input)
        ,"genesis"          : (at "genesis" input)
        ,"premium-until"    : premium}
    )
    ;;{12}
    ;;{13}
    (defun BRD|URC_MaxBluePayment (account:string)
        (let
            (
                (mt:integer (DALOS.DALOS|UR_Elite-Tier-Major account))
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
    ;;
    ;;{14}
    (defun BRD|A_Set (id:string tt:bool flag:integer)
        (with-capability (BRD|C>ADMIN_SET)
            (if tt
                (DPTF.DPTF|UEV_id id)
                (DPMF.DPMF|UEV_id id)
            )
            (enforce (contains flag (enumerate 0 4)) "Invalid Integer Flag")
            (let*
                (
                    (existing-branding:object{DALOS.BrandingSchema} 
                        (if tt
                            (DPTF.DPTF|UR_Branding id false)
                            (DPMF.DPMF|UR_Branding id false)
                        )
                    )
                    (modified-branding:object{DALOS.BrandingSchema} (BRD|UC_BrandingFlag existing-branding flag))
                )
                (if tt
                    (DPTF.DPTF|X_UpdateBranding id false modified-branding)
                    (DPMF.DPMF|X_UpdateBranding id false modified-branding)
                )
            )
        )
    )
    (defun BRD|A_Live (id:string tt:bool)
        (with-capability (BRD|C>LIVE)
            (let*
                (
                    (pending:object{DALOS.BrandingSchema} (if tt (DPTF.DPTF|UR_Branding id true) (DPMF.DPMF|UR_Branding id true)))
                    (flag:integer (if tt (DPTF.DPTF|URB_Flag id false) (DPMF.DPMF|URB_Flag id false)))
                    (updated-flag:integer (if (<= flag 1) flag 2))
                    (updated-branding:object{DALOS.BrandingSchema} (BRD|UC_BrandingFlag pending updated-flag))
                    (np1:object{DALOS.BrandingSchema} (BRD|UC_BrandingLogo pending UTILS.BAR))
                    (np2:object{DALOS.BrandingSchema} (BRD|UC_BrandingDescription np1 UTILS.BAR))
                    (np3:object{DALOS.BrandingSchema} (BRD|UC_BrandingWebsite np2 UTILS.BAR))
                    (np4:object{DALOS.BrandingSchema} (BRD|UC_BrandingSocial np3 [DALOS.SOCIAL|EMPTY]))
                )
                (if tt
                    (with-capability (COMPOSE)
                        (DPTF.DPTF|X_UpdateBranding id false updated-branding)
                        (DPTF.DPTF|X_UpdateBranding id true np4)
                    )
                    (with-capability (COMPOSE)
                        (DPMF.DPMF|X_UpdateBranding id false updated-branding)
                        (DPMF.DPMF|X_UpdateBranding id true np4)
                    )
                )
            )
        )
    )
    ;;{15}
    (defun BRD|C_Upgrade (patron:string id:string tt:bool months:integer)
        (enforce-guard (P|UR "TALOS|Summoner"))
        (with-capability (BRD|C>UPGRADE id tt)
            (let*
                (
                    (owner:string (if tt (DPTF.DPTF|UR_Konto id) (DPMF.DPMF|UR_Konto id)))
                    (mp:integer (BRD|URC_MaxBluePayment owner))
                    (blue:decimal (DALOS.DALOS|UR_UsagePrice "blue"))
                    (current-branding:object{DALOS.BrandingSchema} (if tt (DPTF.DPTF|UR_Branding id false) (DPMF.DPMF|UR_Branding id false)))
                    (premium:time (if tt (DPTF.DPTF|URB_PremiumUntil id false) (DPMF.DPMF|URB_PremiumUntil id false)))
                )
                (enforce (<= months mp) "Invalid Months Integer")
                (let*
                    (
                        (mdec:decimal (dec months))
                        (days:decimal (* 30.0 mdec))
                        (seconds:decimal (* 86400.0 days))
                        (payment:decimal (* mdec blue))
                        (premium-until:time (add-time premium seconds))
                        (ub1:object{DALOS.BrandingSchema} (BRD|UC_BrandingFlag current-branding 1))
                        (ub2:object{DALOS.BrandingSchema} (BRD|UC_BrandingPremium ub1 premium-until))
                    )
                    (if tt
                        (DPTF.DPTF|X_UpdateBranding id false ub2)
                        (DPMF.DPMF|X_UpdateBranding id false ub2)
                    )
                    (DALOS.KDA|C_CollectWT patron payment false)
                )
            )
        )
    )
    (defun BRD|C_Update (patron:string id:string tt:bool logo:string description:string website:string social:[object{DALOS.SocialSchema}])
        (with-capability (BRD|C>BRANDING id tt)
            (BRD|X_UpdatePendingBranding id tt logo description website social)
            (DALOS.IGNIS|C_Collect patron (if tt (DPTF.DPTF|UR_Konto id) (DPMF.DPMF|UR_Konto id)) (DALOS.DALOS|UR_UsagePrice "ignis|branding"))
        )
    )
    ;;{16}
    (defun BRD|X_UpdatePendingBranding (id:string tt:bool logo:string description:string website:string social:[object{DALOS.SocialSchema}])
        (require-capability (BRD|C>BRANDING id tt))
        (let*
            (
                (pending:object{DALOS.BrandingSchema} (if tt (DPTF.DPTF|UR_Branding id true) (DPMF.DPMF|UR_Branding id true)))
                (p1:object{DALOS.BrandingSchema} (BRD|UC_BrandingLogo pending logo))
                (p2:object{DALOS.BrandingSchema} (BRD|UC_BrandingDescription p1 description))
                (p3:object{DALOS.BrandingSchema} (BRD|UC_BrandingWebsite p2 website))
                (p4:object{DALOS.BrandingSchema} (BRD|UC_BrandingSocial p3 social))
            )
            (if tt
                (DPTF.DPTF|X_UpdateBranding id true p4)
                (DPMF.DPMF|X_UpdateBranding id true p4)
            )
            
        )
    )
)

(create-table P|T)