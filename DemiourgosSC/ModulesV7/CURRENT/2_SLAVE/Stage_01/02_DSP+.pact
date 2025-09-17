(interface Dispenser
    ;;
    ;;  [UC]
    ;;
    (defun UC_KosonicAutostakeSplit:[decimal] (input:decimal ip:integer))
    ;;
    ;;  [URC]
    ;;
    (defun URC_DailyOURO ())
    (defun URC_DailyKOSON (iz-game-live:bool))
    ;;
    ;;  [A]
    ;;
    (defun A_OuroMinterStageOne:[decimal] ())
    (defun A_KosonMinterStageOne_1of3 ())
    (defun A_KosonMinterStageOne_2of3 ())
    (defun A_KosonMinterStageOne_3of3 ())
)

(module DSP GOV
    ;;
    (implements OuronetPolicy)
    (implements Dispenser)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    (defconst GOV|MD_DSP                    (keyset-ref-guard (GOV|Demiurgoi)))
    (defconst GOV|SC_DSP                    (keyset-ref-guard DSP|SC_KEY))
    ;;
    ;; KDA Accounts
    (defconst DSP|SC_KDA-NAME               "k:78567097b68c98bf0c86a1938e60111a3bfc0ccadb858cc7f3630bc9da9dad99")
    (defconst CST|SC_KDA-NAME               "k:309a1052856018a954d9692560934a3b8bb6fd0f283ab6eee5fc192b61c119a7")
    ;;
    ;;  Dispenser
    (defconst DSP|SC_KEY                    (GOV|DSPKey))
    (defconst DSP1|SC_NAME                  (GOV|DSP1|SC_NAME))
    (defconst DSP2|SC_NAME                  (GOV|DSP2|SC_NAME))
    (defconst DSP|PBL                       (GOV|DSP|PBL))
    ;;
    ;;  Custodians
    (defconst CST|SC_KEY                    (GOV|CSTKey))
    (defconst CST1|SC_NAME                  (GOV|CST1|SC_NAME))
    (defconst CST2|SC_NAME                  (GOV|CST2|SC_NAME))
    (defconst CST|PBL                       (GOV|CST|PBL))
    ;;
    ;;{G2}
    (defcap GOV ()                          (compose-capability (GOV|DSP_ADMIN)))
    (defcap GOV|DSP_ADMIN ()
        (enforce-one
            "DSP Dispencer Admin not satisfed"
            [
                (enforce-guard GOV|MD_DSP)
                (enforce-guard GOV|SC_DSP)
            ]
        )
    )
    (defcap DSP|GOV ()
        @doc "Governor Capability for the Dispenser Smart DALOS Account"
        true
    )
    ;;{G3}
    (defun GOV|NS_Use ()                    (let ((ref-U|CT:module{OuronetConstants} U|CT)) (ref-U|CT::CT_NS_USE)))
    (defun GOV|Demiurgoi ()                 (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|Demiurgoi)))
    ;;
    ;;  [Keys]
    (defun GOV|DSPKey ()                    (+ (GOV|NS_Use) ".dh_sc_dispenser-keyset"))
    (defun GOV|CSTKey ()                    (+ (GOV|NS_Use) ".dh_sc_custodians-keyset"))
    ;;
    ;;  [SC-Names]
    (defun GOV|DSP1|SC_NAME ()              (at 0 ["Ѻ.hÜ5ĞÊÜεŞΓõè1Ă₳äàÄìãÓЦφLÕзЯŮμĞ₿мK6àŘуVćχδдзηφыβэÎχUHRêγBğΛ∇VŒižďЬШ£îOÜøE4ÖFSõЩЩAłκè1ččΨΦŻЖэч6Iчη₱ØćнúŒψУćÀyпãЗцÚäδÏÍtςřïçγț6γÎęôigFzÝûηы₿ÏЬüБэΞčмŃт₳ŘчjζsŠȚHъĘïЦ0"]))
    (defun GOV|CST1|SC_NAME ()              (at 0 ["Ѻ.Щę7ãŽÓλ4ěПîЭđЮЫAďбQOχnиИДχѺNŽł6ПžιéИąĞuπЙůÞ1ęrПΔżæÍžăζàïαŮŘDzΘ€ЦBGÝŁЭЭςșúÜđŻõËŻκΩÎzŁÇÉΠмłÔÝÖθσ7₱в£μŻzéΘÚĂИüyćťξюWc2И7кςαTnÿЩE3MVTÀεPβafÖôoъBσÂбýжõÞ7ßzŁŞε0âłXâÃЛ"]))
    (defun GOV|DSP2|SC_NAME ()              (+ "Σ" (drop 1 (GOV|DSP1|SC_NAME))))
    (defun GOV|CST2|SC_NAME ()              (+ "Σ" (drop 1 (GOV|CST1|SC_NAME))))
    ;;
    ;;  [PBLs]
    (defun GOV|DSP|PBL ()                   (at 0 ["9G.o0n0iHmGhkch5aEqr0wcpEKpuqgGt5uvFapDLb94GwCbJvBga5H4xrFAx41CbMMH0M7AHmqFnrafceFmaHBfjsH51ggCxJmu5DMpK4jGg0rpogpD26r4yiykAIkaqDz61sHGewpxl1tly780ahKxbEB7uD8FlvA1nGppsttz3AhIhbxlhJ3BpI3Hehf5tCM6bfqF9o6ryb3bErqJwEDJmMGFC9HEeDiLKAtMgqaajzK2b0yg2sE0lJMp2K8I6sjfwnyhyL5vnycpMpeCgagdlnbMMMaA9trHLx4FxLym6KqCFAxCFwFHohfbcolG3u5wGo06M1fMBKpC64Mgm4584tH93Hpmop4tLpD7157GLo7mejJk8ryrA229K07D2hbhtanzCgdtjziBs9yqvHLq78EFEsD1fpEeD0pMhJeLEMEsqu8zf816cLErk4aDC22GnsC9774C59iaLFKkzKzh11xnAEalcpGcLf7aecGBHu5IABIGq8sEFa9Ahi5inermzrys3HcLpz2degMmAEy8hKsI83zvaCta8Ksimgn3qmv4r4jocMsIAwDeEfzE"]))
    (defun GOV|CST|PBL ()                   (at 0 ["9H.abeq3vvcwJp9gl2Kdt5xb7djJwdB35bCgkIaF3r0k38kBF6La1M6ci0ma2e5exMehsmwe1x3d6EpsIjxv95hAvc3uJweirnitcAAryxn9HaHJ1f0ya36BDfsrfaIBL4moIF3B8glb5pDBhta7pyxigEdt13ccEIKtCdyC6krMhB5iyqfEyB70zf5tjqn2xpDDzg9nA7auzzjxxtwLH80Lmdp4wAEcnqprGishhMLLefMnzDv9dFyM0n31fAcziHogCIM4kktFgydhHah7hmJurs3xCrGrs5qAEtjid0zioLHM58l8wogL2j0L9LIH21wI4lD1BlKq4445nos849CEzcm3DC9t67IH1r63pkgc9xFEGr8K6H3CCfg9aqDcApxaDuEomaKjEj6ft71gtEwbEJJmrAzfDolHrFfubcertjF2rE2wMywhv7HqIoHMCKEznMFCy2C6eyGyh1mIMeKJDDhwqIDIA5a2wvtt0HedKxmgDldafrrGdn5yDGHMexLFCrGv9aG50G82zIlE5z7cksfplf5taeiz8vlydDKmLaCcMgA7ne77hsbGHuu"]))
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    (deftable P|T:{OuronetPolicy.P|S})
    (deftable P|MT:{OuronetPolicy.P|MS})
    ;;{P3}
    (defcap P|DSP|CALLER ()
        true
    )
    (defcap P|DRG ()
        @doc "Dispenser Remote Governor Capability"
        true
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
        (with-capability (GOV|DSP_ADMIN)
            (write P|T policy-name
                {"policy" : policy-guard}
            )
        )
    )
    (defun P|A_AddIMP (policy-guard:guard)
        (with-capability (GOV|DSP_ADMIN)
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
                (mg:guard (create-capability-guard (P|DSP|CALLER)))
            )
            (ref-P|DALOS::P|A_Add
                "DSP|RemoteDalosGov"
                (create-capability-guard (P|DRG))
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
    ;;{2}
    ;;{3}
    (defun TALOS|Gassless ()                (let ((ref-DALOS:module{OuronetDalosV4} DALOS)) (ref-DALOS::GOV|DALOS|SC_NAME)))
    (defconst GASLESS-PATRON                (TALOS|Gassless))
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
    (defcap DSP|STAGE-ONE-MINTER ()
        @event
        (compose-capability (GOV|DSP_ADMIN))
        (compose-capability (P|DRG))
    )
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_KosonicAutostakeSplit:[decimal] (input:decimal ip:integer)
        (let
            (
                (one:decimal 0.0625)
                (ps:decimal (floor (* one input) ip))
                (cc:decimal (* ps 2.0))
                (pp:decimal (* ps 2.5))
                (tt:decimal (* ps 3.0))
                (sv:decimal (* ps 3.5))
                (aa:decimal (- input (fold (+) 0.0 [ps cc pp tt sv])))
            )
            [ps cc pp tt sv aa]
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    (defun URC_DailyOURO ()
        (let
            (
                (ref-DALOS:module{OuronetDalosV4} DALOS)
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ouro:string (ref-DALOS::UR_OuroborosID))
                (current-ouro-supply:decimal (ref-DPTF::UR_Supply ouro))
                (op:integer (ref-DPTF::UR_Decimals ouro))
                (maximum-theorethical-supply:decimal 10000000.0)
                (speed:decimal 10000.0)
            )
            (floor (/ (- maximum-theorethical-supply current-ouro-supply) speed) op)
        )
    )
    ;;
    (defun URC_DailyKOSON (iz-game-live:bool)
        (let
            (
                (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                (ref-AOZ:module{AgeOfZalmoxis} AOZ)
                ;;
                (PrimordialKosonID:string       (ref-AOZ::UR_PrimalTrueFungible 1))
                (op0:integer                    (ref-DPTF::UR_Decimals PrimordialKosonID))
                ;;
                (EsothericKosonID:string        (ref-AOZ::UR_PrimalTrueFungible 2))
                (current-EK-supply:decimal      (ref-DPTF::UR_Supply EsothericKosonID))
                (op1:integer                    (ref-DPTF::UR_Decimals EsothericKosonID))
                ;;
                (AncientKosonID:string          (ref-AOZ::UR_PrimalTrueFungible 3))
                (current-AK-supply:decimal      (ref-DPTF::UR_Supply AncientKosonID))
                (op2:integer                    (ref-DPTF::UR_Decimals AncientKosonID))
                ;;
                (esoteric-mts:decimal 16180339.887498948482045868343656)
                (esoteric-speed:decimal 7000.0)
                (ancient-mts:decimal 31415926.535897932384626433832795)
                (ancient-speed:decimal 8000.0)
                ;;
                (esoteric:decimal (floor (/ (- esoteric-mts current-EK-supply) esoteric-speed) op1))
                (ancient:decimal (floor (/ (- ancient-mts current-AK-supply) ancient-speed) op2))
                (primordial:decimal
                    (if iz-game-live
                        (floor (/ (+ esoteric ancient) 5.0) op0)
                        (floor (/ esoteric 5.0) op0)
                    )
                )
            )
            (if iz-game-live
                [primordial esoteric ancient]
                [primordial esoteric]
            )
        )
    )
    ;;{F2}  [UEV]
    ;;{F3}  [UDC]
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;
    (defun A_OuroMinterStageOne:[decimal] ()
        @doc "Mints the Stage One Daily OURO Emission"
        (with-capability (DSP|STAGE-ONE-MINTER)
            (let
                (
                    (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (ref-ATS:module{AutostakeV4} ATS)
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                    (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                    (ouro:string (ref-DALOS::UR_OuroborosID))
                    (op:integer (ref-DPTF::UR_Decimals ouro))
                    (daily:decimal (URC_DailyOURO))
                    ;;
                    (split:[decimal] (ref-U|DALOS::UC_TenTwentyThirtyFourtySplit daily op))
                    (s1-10p:decimal (at 0 split))
                    (s1-20p:decimal (at 1 split))
                    (s1-30p:decimal (at 2 split))
                    (s1-40p:decimal (at 3 split))
                    ;;
                    (treasury:string (ref-DALOS::GOV|DHV1|SC_NAME))
                    (validators:string CST1|SC_NAME)
                    (dispenser:string DSP1|SC_NAME)
                    ;;
                    (auryn:string (ref-DALOS::UR_AurynID))
                    (elite-auryn:string (ref-DALOS::UR_EliteAurynID))
                    (auryndex:string (at 0 (ref-DPTF::UR_RewardBearingToken auryn)))
                    (elite-auryndex:string (at 0 (ref-DPTF::UR_RewardBearingToken elite-auryn)))
                )
                ;;Mints whole daily on Dispencer
                (ref-TS01-C1::DPTF|C_Mint GASLESS-PATRON ouro dispenser daily false)
                ;;Moves 10% To Treasury and 20% to Validators
                (ref-TS01-C1::DPTF|C_BulkTransfer GASLESS-PATRON ouro dispenser [treasury validators] [s1-10p s1-20p])
                ;;Uses 30% to Fuel the Auryndex
                (ref-TS01-C2::ATS|C_Fuel GASLESS-PATRON dispenser auryndex ouro s1-30p)
                ;;Uses 40% to Coil to Auryn and then use Auryn to Fuel Elite-Auryndex
                (let
                    (
                        (c-rbt-amount:decimal (ref-ATS::URC_RBT auryndex ouro s1-40p))
                    )
                    (ref-TS01-C2::ATS|C_Coil GASLESS-PATRON dispenser auryndex ouro s1-40p)
                    (ref-TS01-C2::ATS|C_Fuel GASLESS-PATRON dispenser elite-auryndex auryn c-rbt-amount)
                    [daily s1-10p s1-20p s1-30p s1-40p]
                )
            )
        )
    )
    ;;
    (defun A_KosonMinterStageOne_1of3 ()
        @doc "Executes Stage One Daily Koson Emission, Part 1 of 3"
        (with-capability (DSP|STAGE-ONE-MINTER)
            (let
                (
                    (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (ref-TS01-C1:module{TalosStageOne_ClientOneV4} TS01-C1)
                    (ref-AOZ:module{AgeOfZalmoxis} AOZ)
                    ;;
                    (PrimordialKosonID:string      (ref-AOZ::UR_PrimalTrueFungible 1))
                    (EsothericKosonID:string       (ref-AOZ::UR_PrimalTrueFungible 2))
                    (op0:integer (ref-DPTF::UR_Decimals PrimordialKosonID))
                    ;;
                    (daily:[decimal] (URC_DailyKOSON false))
                    (ps:[decimal] (ref-U|DALOS::UC_TenTwentyThirtyFourtySplit (at 0 daily) op0))
                    (ps10:decimal (at 0 ps))
                    (ps20:decimal (at 1 ps))
                    (ps40:decimal (at 3 ps))
                    ;;
                    (standard-treasury:string (ref-DALOS::GOV|DHV1|SC_NAME))
                    (smart-treasury:string (ref-DALOS::GOV|DHV2|SC_NAME))
                    (validators:string CST1|SC_NAME)
                    (dispenser:string DSP1|SC_NAME)
                )
                ;;Mints Primordial Koson and Esoteric Koson Amounts
                (ref-TS01-C1::DPTF|C_Mint GASLESS-PATRON PrimordialKosonID dispenser (at 0 daily) false)
                (ref-TS01-C1::DPTF|C_Mint GASLESS-PATRON EsothericKosonID dispenser (at 1 daily) false)
                ;;Moves Primordial Kosons: 10% To Standard-Treasury, 20% to Smart-Treasury, 40% to Custodians(Validators)
                (ref-TS01-C1::DPTF|C_BulkTransfer GASLESS-PATRON PrimordialKosonID dispenser [standard-treasury validators] [ps10 ps40])
                (ref-TS01-C1::DPTF|C_Transfer GASLESS-PATRON PrimordialKosonID dispenser smart-treasury ps20 true)
            )
        )
    )
    (defun A_KosonMinterStageOne_2of3 ()
        @doc "Continues Stage One Daily Koson Emission, Part 2 of 3"
        (with-capability (DSP|STAGE-ONE-MINTER)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                    (ref-AOZ:module{AgeOfZalmoxis} AOZ)
                    ;;
                    (PrimordialKosonID:string       (ref-AOZ::UR_PrimalTrueFungible 1))
                    (PlebeicStrengthID:string       (ref-AOZ::UR_AutostakePair 1))
                    (ComatiCommandID:string         (ref-AOZ::UR_AutostakePair 2))
                    (PileatiPowerID:string          (ref-AOZ::UR_AutostakePair 3))
                    (TarabostesTenacityID:string    (ref-AOZ::UR_AutostakePair 4))
                    (StrategonVigorID:string        (ref-AOZ::UR_AutostakePair 5))
                    (AsAuthorityID:string           (ref-AOZ::UR_AutostakePair 6))
                    ;;
                    (op0:integer (ref-DPTF::UR_Decimals PrimordialKosonID))
                    (dispenser:string DSP1|SC_NAME)
                    ;;
                    (daily-primordial-left:decimal (ref-DPTF::UR_AccountSupply PrimordialKosonID dispenser))
                    (primordial-split-for-ats:[decimal] (UC_KosonicAutostakeSplit daily-primordial-left op0))
                )
                ;;Fuel the 6 ATS Pools, using Primordial Kosons
                (ref-TS01-C2::ATS|C_Fuel GASLESS-PATRON dispenser PlebeicStrengthID     PrimordialKosonID (at 0 primordial-split-for-ats))
                (ref-TS01-C2::ATS|C_Fuel GASLESS-PATRON dispenser ComatiCommandID       PrimordialKosonID (at 1 primordial-split-for-ats))
                (ref-TS01-C2::ATS|C_Fuel GASLESS-PATRON dispenser PileatiPowerID        PrimordialKosonID (at 2 primordial-split-for-ats))
                (ref-TS01-C2::ATS|C_Fuel GASLESS-PATRON dispenser TarabostesTenacityID  PrimordialKosonID (at 3 primordial-split-for-ats))
                (ref-TS01-C2::ATS|C_Fuel GASLESS-PATRON dispenser StrategonVigorID      PrimordialKosonID (at 4 primordial-split-for-ats))
                (ref-TS01-C2::ATS|C_Fuel GASLESS-PATRON dispenser AsAuthorityID         PrimordialKosonID (at 5 primordial-split-for-ats))
            )
        )
    )
    (defun A_KosonMinterStageOne_3of3 ()
        @doc "Finalizes Stage One Daily Koson Emission, Part 3 of 3"
        (with-capability (DSP|STAGE-ONE-MINTER)
            (let
                (
                    (ref-DALOS:module{OuronetDalosV4} DALOS)
                    (ref-DPTF:module{DemiourgosPactTrueFungibleV5} DPTF)
                    (ref-TS01-C2:module{TalosStageOne_ClientTwoV4} TS01-C2)
                    (ref-AOZ:module{AgeOfZalmoxis} AOZ)
                    ;;
                    (EsothericKosonID:string        (ref-AOZ::UR_PrimalTrueFungible 2))
                    (PlebeicStrengthID:string       (ref-AOZ::UR_AutostakePair 1))
                    (ComatiCommandID:string         (ref-AOZ::UR_AutostakePair 2))
                    (PileatiPowerID:string          (ref-AOZ::UR_AutostakePair 3))
                    (TarabostesTenacityID:string    (ref-AOZ::UR_AutostakePair 4))
                    (StrategonVigorID:string        (ref-AOZ::UR_AutostakePair 5))
                    (AsAuthorityID:string           (ref-AOZ::UR_AutostakePair 6))
                    ;;
                    (op1:integer (ref-DPTF::UR_Decimals EsothericKosonID))
                    (dispenser:string DSP1|SC_NAME)
                    ;;
                    (daily-esoteric:decimal (ref-DPTF::UR_AccountSupply EsothericKosonID dispenser))
                    (esoteric-split-for-ats:[decimal] (UC_KosonicAutostakeSplit daily-esoteric op1))
                )
                ;;Fuel the 6 ATS Pools, using Esoteric Kosons
                (ref-TS01-C2::ATS|C_Fuel GASLESS-PATRON dispenser PlebeicStrengthID     EsothericKosonID (at 0 esoteric-split-for-ats))
                (ref-TS01-C2::ATS|C_Fuel GASLESS-PATRON dispenser ComatiCommandID       EsothericKosonID (at 1 esoteric-split-for-ats))
                (ref-TS01-C2::ATS|C_Fuel GASLESS-PATRON dispenser PileatiPowerID        EsothericKosonID (at 2 esoteric-split-for-ats))
                (ref-TS01-C2::ATS|C_Fuel GASLESS-PATRON dispenser TarabostesTenacityID  EsothericKosonID (at 3 esoteric-split-for-ats))
                (ref-TS01-C2::ATS|C_Fuel GASLESS-PATRON dispenser StrategonVigorID      EsothericKosonID (at 4 esoteric-split-for-ats))
                (ref-TS01-C2::ATS|C_Fuel GASLESS-PATRON dispenser AsAuthorityID         EsothericKosonID (at 5 esoteric-split-for-ats))
            )
        )
    )
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)

(create-table P|T)
(create-table P|MT)