
(module U|ATS GOV
    ;;
    (implements UtilityAts)
    ;;
    ;;<========>
    ;;GOVERNANCE
    ;;{G1}
    ;;{G2}
    (defcap GOV ()                  (compose-capability (GOV|U|ATS_ADMIN)))
    (defcap GOV|U|ATS_ADMIN ()
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (g:guard (ref-U|CT::CT_GOV|UTILS))
            )
            (enforce-guard g)
        )
    )
    ;;{G3}
    ;;
    ;;<====>
    ;;POLICY
    ;;{P1}
    ;;{P2}
    ;;{P3}
    ;;{P4}
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
    ;;{C2}
    ;;{C3}
    ;;{C4}
    ;;
    ;;<=======>
    ;;FUNCTIONS
    (defun UC_IzCullable:bool (input:object{UtilityAts.Awo})
        (let*
            (
                (present-time:time (at "block-time" (chain-data)))
                (stored-time:time (at "cull-time" input))
                (diff:decimal (diff-time present-time stored-time))
            )
            (if (>= diff 0.0)
                true
                false
            )
        )
    )
    (defun UC_IzUnstakeObjectValid:bool (input:object{UtilityAts.Awo})
        (let*
            (
                (values:[decimal] (at "reward-tokens" input))
                (sum-values:decimal (fold (+) 0.0 values))
            )
            (if (> sum-values 0.0)
                true
                false
            )
        )
    )
    (defun UC_MakeHardIntervals:[integer] (start:integer growth:integer)
        @doc "Creates a Soft Interval List"
        (enforce (= (mod start growth) 0) (format "{} must be divisible by {} and it is not" [start growth]))
        (let*
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (chain:[integer]
                    (fold
                        (lambda
                            (acc:[integer] item:integer)
                            (ref-U|LST::UC_AppL acc (+ (ref-U|LST::UC_LE acc) item))
                        )
                        [start]
                        (make-list 48 growth)
                    )
                )
                (big:integer (* 7 growth))
                (last:integer (ref-U|LST::UC_LE chain))
                (very-last:integer (+ last big))
                (final-lst:[integer] (ref-U|LST::UC_AppL chain very-last))
            )
            (reverse final-lst)
        )
    )
    (defun UC_MakeSoftIntervals:[integer] (start:integer growth:integer)
        @doc "Creates a Soft Interval List of Integers \
        \ Used when creating|setting-up an Autostake Pair"
        (enforce (= (mod start growth) 0) (format "{} must be divisible by {} and it is not" [start growth]))
        (enforce (= (mod growth 3) 0) (format "{} must be divisible by 3 and it is not" [growth]))
        (let*
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (small:integer (/ growth 3))
                (medium:integer (* small 2))
                (chain1:[integer] (fold (lambda (acc:[integer] item:integer) (ref-U|LST::UC_AppL acc (+ (ref-U|LST::UC_LE acc) item))) [start] (make-list 6 growth)))
                (chain2:[integer] (fold (lambda (acc:[integer] item:integer) (ref-U|LST::UC_AppL acc (+ (ref-U|LST::UC_LE acc) item))) chain1 (+ (make-list 5 medium) (make-list 2 small))))
                (chain3:[integer] (fold (lambda (acc:[integer] item:integer) (ref-U|LST::UC_AppL acc (+ (ref-U|LST::UC_LE acc) item))) chain2 (+ (make-list 5 medium) (make-list 2 small))))
                (chain4:[integer] (fold (lambda (acc:[integer] item:integer) (ref-U|LST::UC_AppL acc (+ (ref-U|LST::UC_LE acc) item))) chain3 (+ (make-list 5 medium) (make-list 2 small))))
                (chain5:[integer] (fold (lambda (acc:[integer] item:integer) (ref-U|LST::UC_AppL acc (+ (ref-U|LST::UC_LE acc) item))) chain4 (+ (make-list 5 medium) (make-list 2 small))))
                (chain6:[integer] (fold (lambda (acc:[integer] item:integer) (ref-U|LST::UC_AppL acc (+ (ref-U|LST::UC_LE acc) item))) chain5 (+ (make-list 5 medium) (make-list 2 small))))
                (chain7:[integer] (fold (lambda (acc:[integer] item:integer) (ref-U|LST::UC_AppL acc (+ (ref-U|LST::UC_LE acc) item))) chain6 (+ (make-list 5 medium) (make-list 2 small))))
                (last:integer (ref-U|LST::UC_LE chain7))
                (very-last:integer (+ last 24))
                (final-lst:[integer] (ref-U|LST::UC_AppL chain7 very-last))
            )
            (reverse final-lst)
        )
    )
    (defun UC_MultiReshapeUnstakeObject:[object{UtilityAts.Awo}] (input:[object{UtilityAts.Awo}] remove-position:integer)
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
            )
            (fold
                (lambda
                    (acc:[object{UtilityAts.Awo}] item:object{UtilityAts.Awo})
                    (ref-U|LST::UC_AppL
                        acc
                        (UC_ReshapeUnstakeObject item remove-position)
                    )
                )
                []
                input
            )
        )
    )
    (defun UC_PromilleSplit:[decimal] (promille:decimal input:decimal input-precision:integer)
        @doc "Helper Function used in the <ATS|C_ColdRecovery> Function"
        (let*
            (
                (ref-U|DEC:module{OuronetDecimals} U|DEC)
                (fee:decimal (ref-U|DEC::UC_Promille input promille input-precision))
                (remainder:decimal (- input fee))
            )
            [remainder fee]
        )
    )
    (defun UC_QuadAnd:bool (b1:bool b2:bool b3:bool b4:bool)
        (and (and b1 b2) (and b3 b4))
    )
    (defun UC_ReshapeUnstakeObject:object{UtilityAts.Awo} (input:object{UtilityAts.Awo} remove-position:integer)
        (let
            (
                (is-valid:bool (UC_IzUnstakeObjectValid input))
            )
            (if is-valid
                (UC_SolidifyUnstakeObject input remove-position)
                input
            )
        )
    )
    (defun UC_SolidifyUnstakeObject:object{UtilityAts.Awo} (input:object{UtilityAts.Awo} remove-position:integer)
        (let*
            (
                (values:[decimal] (at "reward-tokens" input))
                (cull-time:time (at "cull-time" input))
                (how-many-rts:integer (length values))
            )
            (enforce (and (> remove-position 0) (< remove-position how-many-rts)) "Invalid <remove-position>")
            (let*
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (primal:decimal (at 0 (at "reward-tokens" input)))
                    (removee:decimal (at remove-position (at "reward-tokens" input)))
                    (remove-lst:[decimal] (ref-U|LST::UC_RemoveItemAt values remove-position))
                    (new-values:[decimal] (ref-U|LST::UC_ReplaceAt remove-lst 0 (+ primal removee)))
                )
                { "reward-tokens"   : new-values
                , "cull-time"       : cull-time}
            )
        )
    )
    (defun UC_SplitBalanceWithBooleans:[decimal] (precision:integer amount:decimal milestones:integer boolean:[bool])
        @doc "Splits an Amount according to specific ATS-Pair Parameters related to the list of Reward Tokens \
        \ Helper function used in the Autostake Module"
        (enforce (> milestones 0) "Cannot split with zero milestones")
        (let
            (
                (ref-U|LST:module{StringProcessor} U|LST)
                (split:decimal (floor (/ amount (dec milestones)) precision))
                (tr-nr:integer (length (ref-U|LST::UC_Search boolean true)))
                (multiply:integer (- milestones 1))
            )
            (enforce (> split 0.0) (format "Amount {} to small to split into {} milestones" [amount milestones]))
            (enforce (= milestones tr-nr) "Input Lists do not sync")
            (let*
                (
                    (big-chunk:decimal (floor (* split (dec multiply)) precision))
                    (last-split:decimal (floor (- amount big-chunk) precision))
                )
                (enforce (= (+ big-chunk last-split) amount) (format "Amount of {} could not be split into {} milestones succesfully" [amount milestones]))
                (let*
                    (
                        (output-without-last:[decimal]
                            (fold
                                (lambda
                                    (acc:[decimal] truth:bool)
                                    (if truth
                                        (ref-U|LST::UC_AppL acc split)
                                        (ref-U|LST::UC_AppL acc 0.0)
                                    )
                                )
                                []
                                boolean
                            )
                        )
                        (positions-lst:[integer] (ref-U|LST::UC_Search output-without-last split))
                        (last-element-value-position:integer (at (- (length positions-lst) 1) positions-lst) )
                        (output:[decimal] (ref-U|LST::UC_ReplaceAt output-without-last last-element-value-position last-split))
                    )
                    output
                )
            )
        )
    )
    (defun UC_SplitByIndexedRBT:[decimal]
        (
            rbt-amount:decimal
            pair-rbt-supply:decimal
            index:decimal
            resident-amounts:[decimal]
            rt-precisions:[integer]
        )
        @doc "Called from ATS.ATS|UC_RTSplitAmounts: Splits a RBT value, the <rbt-amount>, using following inputs: \
            \ Reward-Bearing-Token supply <rbt-supply> of an <atspair> (read below) \
            \ The <index> of the <atspair> (read below) \
            \ A list <resident-amounts> respresenting amounts of resident Reward-Tokens of the <atpsair> \
            \ A list <rt-precision-lst> representing the precision of these Reward-Tokens \
            \ \
            \ Resulting a decimal list of Reward-Token Values coresponding to the input <rbt-amount> \
            \ The Actual computation takes place in the UTILITY Module in the <UC_SplitByIndexedRBT> Function"
        (if (= rbt-amount pair-rbt-supply)
            resident-amounts
            (let*
                (
                    (ref-U|LST:module{StringProcessor} U|LST)
                    (ref-U|INT:module{OuronetIntegersV2} U|INT)
                    (max-precision:integer (ref-U|INT::UC_MaxInteger rt-precisions))
                    (max-pp:integer (at 0 (ref-U|LST::UC_Search rt-precisions max-precision)))
                    (indexed-rbt:decimal (floor (* rbt-amount index) max-precision))
                    (resident-sum:decimal (fold (+) 0.0 resident-amounts))
                    (preliminary-output:[decimal]
                        (fold
                            (lambda
                                (acc:[decimal] index:integer)
                                (ref-U|LST::UC_AppL acc (floor (* (/ (at index resident-amounts) resident-sum) indexed-rbt) (at index rt-precisions)))
                            )
                            []
                            (enumerate 0 (- (length resident-amounts) 1))
                        )
                    )
                    (po-sum:decimal (fold (+) 0.0 preliminary-output))
                    (black-sheep:decimal (at max-pp preliminary-output))
                    (white-sheep:decimal (- indexed-rbt (- po-sum black-sheep)))
                    (output:[decimal] (ref-U|LST::UC_ReplaceAt preliminary-output max-pp white-sheep))
                )
                output
            )
        )
    )
    (defun UC_TripleAnd:bool (b1:bool b2:bool b3:bool)
        (and (and b1 b2) b3)
    )
    (defun UC_UnlockPrice:[decimal] (unlocks:integer)
        @doc "Computes  ATS unlock price \
            \ Outputs [virtual-gas-costs (IGNIS) native-gas-cost(KDA)]"
        (let
            (
                (ref-U|DEC:module{OuronetDecimals} U|DEC)
            )
            (ref-U|DEC::UC_UnlockPrice unlocks false)
        )
    )
    (defun UC_ZeroColdFeeExceptionBoolean:bool (fee-thresholds:[decimal] fee-array:[[decimal]])
        (not
            (UC_TripleAnd
                (= (length fee-thresholds) 1)
                (= (at 0 fee-thresholds) 0.0)
                (UC_TripleAnd
                    (= (length fee-array) 1)
                    (= (length (at 0 fee-array)) 1)
                    (= (at 0 (at 0 fee-array)) 0.0)
                )
            )
        )
    )
    ;;{F0}  [UR]
    ;;{F1}  [URC]
    ;;{F2}  [UEV]
    (defun UEV_AutostakeIndex (ats:string)
        @doc "Enforces that ATS Index Name <account> ID meets charset and length requirements"
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (ref-U|DALOS:module{UtilityDalosV3} U|DALOS)
                (aipc:[string] (ref-U|CT::CT_ACCOUNT_ID_PROH-CHAR))
                (min:integer (ref-U|CT::CT_MIN_DESIGNATION_LENGTH))
                (max:integer (ref-U|CT::CT_ACCOUNT_ID_MAX_LENGTH))
                (al:integer (length ats))
            )
            (enforce
                (is-charset 0 ats)
                (format "Account ID does not conform to the required charset: {}" [ats])
            )
            (enforce
                (not (contains ats aipc))
                (format "Account ID contained a prohibited character: {}" [ats])
            )
            (enforce
                (ref-U|DALOS::UC_IzStringANC ats false false)
                "Atspair does not conform character-wise (Alphanumeric)"
            )
            (enforce
                (and
                    (>= al min)
                    (<= al max)
                )
                "Atspair does not conform to the ATS-Pair Standards for Size!"
            )
        )
    )
    (defun UEV_UniqueAtspair (ats:string)
        @doc "Enforces that an Unique Account designating an <ats> ID meets charset and length requirements \
        \ Unique Accounts are ATS-IDs (composed of the Index Name - Unique Identifier)"
        (UEV_AutostakeIndex (take (- (length ats) 13) ats))
    )
    ;;{F3}  [UDC]
    (defun UDC_Elite (x:decimal)
        @doc "Returns an Object following DALOS|EliteSchema given a decimal input amount"
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (et:[decimal] (ref-U|CT::CT_ET))
                (deb:[decimal] (ref-U|CT::CT_DEB))

                (c1:string (ref-U|CT::CT_C1))
                (c2:string (ref-U|CT::CT_C2))
                (c3:string (ref-U|CT::CT_C3))
                (c4:string (ref-U|CT::CT_C4))
                (c5:string (ref-U|CT::CT_C5))
                (c6:string (ref-U|CT::CT_C6))
                (c7:string (ref-U|CT::CT_C7))

                (n00:string (ref-U|CT::CT_N00))
                (n01:string (ref-U|CT::CT_N01))

                (n11:string (ref-U|CT::CT_N11))
                (n12:string (ref-U|CT::CT_N12))
                (n13:string (ref-U|CT::CT_N13))
                (n14:string (ref-U|CT::CT_N14))
                (n15:string (ref-U|CT::CT_N15))
                (n16:string (ref-U|CT::CT_N16))
                (n17:string (ref-U|CT::CT_N17))

                (n21:string (ref-U|CT::CT_N21))
                (n22:string (ref-U|CT::CT_N22))
                (n23:string (ref-U|CT::CT_N23))
                (n24:string (ref-U|CT::CT_N24))
                (n25:string (ref-U|CT::CT_N25))
                (n26:string (ref-U|CT::CT_N26))
                (n27:string (ref-U|CT::CT_N27))

                (n31:string (ref-U|CT::CT_N31))
                (n32:string (ref-U|CT::CT_N32))
                (n33:string (ref-U|CT::CT_N33))
                (n34:string (ref-U|CT::CT_N34))
                (n35:string (ref-U|CT::CT_N35))
                (n36:string (ref-U|CT::CT_N36))
                (n37:string (ref-U|CT::CT_N37))

                (n41:string (ref-U|CT::CT_N41))
                (n42:string (ref-U|CT::CT_N42))
                (n43:string (ref-U|CT::CT_N43))
                (n44:string (ref-U|CT::CT_N44))
                (n45:string (ref-U|CT::CT_N45))
                (n46:string (ref-U|CT::CT_N46))
                (n47:string (ref-U|CT::CT_N47))

                (n51:string (ref-U|CT::CT_N51))
                (n52:string (ref-U|CT::CT_N52))
                (n53:string (ref-U|CT::CT_N53))
                (n54:string (ref-U|CT::CT_N54))
                (n55:string (ref-U|CT::CT_N55))
                (n56:string (ref-U|CT::CT_N56))
                (n57:string (ref-U|CT::CT_N57))

                (n61:string (ref-U|CT::CT_N61))
                (n62:string (ref-U|CT::CT_N62))
                (n63:string (ref-U|CT::CT_N63))
                (n64:string (ref-U|CT::CT_N64))
                (n65:string (ref-U|CT::CT_N65))
                (n66:string (ref-U|CT::CT_N66))
                (n67:string (ref-U|CT::CT_N67))

                (n71:string (ref-U|CT::CT_N71))
                (n72:string (ref-U|CT::CT_N72))
                (n73:string (ref-U|CT::CT_N73))
                (n74:string (ref-U|CT::CT_N74))
                (n75:string (ref-U|CT::CT_N75))
                (n76:string (ref-U|CT::CT_N76))
                (n77:string (ref-U|CT::CT_N77))
            )
            (cond
                ;;Class Novice
                ((<= x (at 0 et)) { "class": c1, "name": n00, "tier": "0.0", "deb": (at 0 deb)})
                ((and (> x (at 0 et))(< x (at 1 et))) { "class": c1, "name": n01, "tier": "0.1", "deb": (at 0 deb)})
                ((and (>= x (at 1 et))(< x (at 2 et))) { "class": c1, "name": n11, "tier": "1.1", "deb": (at 1 deb)})
                ((and (>= x (at 2 et))(< x (at 3 et))) { "class": c1, "name": n12, "tier": "1.2", "deb": (at 2 deb)})
                ((and (>= x (at 3 et))(< x (at 4 et))) { "class": c1, "name": n13, "tier": "1.3", "deb": (at 3 deb)})
                ((and (>= x (at 4 et))(< x (at 5 et))) { "class": c1, "name": n14, "tier": "1.4", "deb": (at 4 deb)})
                ((and (>= x (at 5 et))(< x (at 6 et))) { "class": c1, "name": n15, "tier": "1.5", "deb": (at 5 deb)})
                ((and (>= x (at 6 et))(< x (at 7 et))) { "class": c1, "name": n16, "tier": "1.6", "deb": (at 6 deb)})
                ((and (>= x (at 7 et))(< x (at 8 et))) { "class": c1, "name": n17, "tier": "1.7", "deb": (at 7 deb)})
                ;;Class INVESTOR
                ((and (>= x (at 8 et))(< x (at 9 et))) { "class": c2, "name": n21, "tier": "2.1", "deb": (at 8 deb)})
                ((and (>= x (at 9 et))(< x (at 10 et))) { "class": c2, "name": n22, "tier": "2.2", "deb": (at 9 deb)})
                ((and (>= x (at 10 et))(< x (at 11 et))) { "class": c2, "name": n23, "tier": "2.3", "deb": (at 10 deb)})
                ((and (>= x (at 11 et))(< x (at 12 et))) { "class": c2, "name": n24, "tier": "2.4", "deb": (at 11 deb)})
                ((and (>= x (at 12 et))(< x (at 13 et))) { "class": c2, "name": n25, "tier": "2.5", "deb": (at 12 deb)})
                ((and (>= x (at 13 et))(< x (at 14 et))) { "class": c2, "name": n26, "tier": "2.6", "deb": (at 13 deb)})
                ((and (>= x (at 14 et))(< x (at 15 et))) { "class": c2, "name": n27, "tier": "2.7", "deb": (at 14 deb)})
                ;;Class ENTREPRENEUR
                ((and (>= x (at 15 et))(< x (at 16 et))) { "class": c3, "name": n31, "tier": "3.1", "deb": (at 15 deb)})
                ((and (>= x (at 16 et))(< x (at 17 et))) { "class": c3, "name": n32, "tier": "3.2", "deb": (at 16 deb)})
                ((and (>= x (at 17 et))(< x (at 18 et))) { "class": c3, "name": n33, "tier": "3.3", "deb": (at 17 deb)})
                ((and (>= x (at 18 et))(< x (at 19 et))) { "class": c3, "name": n34, "tier": "3.4", "deb": (at 18 deb)})
                ((and (>= x (at 19 et))(< x (at 20 et))) { "class": c3, "name": n35, "tier": "3.5", "deb": (at 19 deb)})
                ((and (>= x (at 20 et))(< x (at 21 et))) { "class": c3, "name": n36, "tier": "3.6", "deb": (at 20 deb)})
                ((and (>= x (at 21 et))(< x (at 22 et))) { "class": c3, "name": n37, "tier": "3.7", "deb": (at 21 deb)})
                ;;Class MOGUL
                ((and (>= x (at 22 et))(< x (at 23 et))) { "class": c4, "name": n41, "tier": "4.1", "deb": (at 22 deb)})
                ((and (>= x (at 23 et))(< x (at 24 et))) { "class": c4, "name": n42, "tier": "4.2", "deb": (at 23 deb)})
                ((and (>= x (at 24 et))(< x (at 25 et))) { "class": c4, "name": n43, "tier": "4.3", "deb": (at 24 deb)})
                ((and (>= x (at 25 et))(< x (at 26 et))) { "class": c4, "name": n44, "tier": "4.4", "deb": (at 25 deb)})
                ((and (>= x (at 26 et))(< x (at 27 et))) { "class": c4, "name": n45, "tier": "4.5", "deb": (at 26 deb)})
                ((and (>= x (at 27 et))(< x (at 28 et))) { "class": c4, "name": n46, "tier": "4.6", "deb": (at 27 deb)})
                ((and (>= x (at 28 et))(< x (at 29 et))) { "class": c4, "name": n47, "tier": "4.7", "deb": (at 28 deb)})
                ;;Class MAGNATE
                ((and (>= x (at 29 et))(< x (at 30 et))) { "class": c5, "name": n51, "tier": "5.1", "deb": (at 29 deb)})
                ((and (>= x (at 30 et))(< x (at 31 et))) { "class": c5, "name": n52, "tier": "5.2", "deb": (at 30 deb)})
                ((and (>= x (at 31 et))(< x (at 32 et))) { "class": c5, "name": n53, "tier": "5.3", "deb": (at 31 deb)})
                ((and (>= x (at 32 et))(< x (at 33 et))) { "class": c5, "name": n54, "tier": "5.4", "deb": (at 32 deb)})
                ((and (>= x (at 33 et))(< x (at 34 et))) { "class": c5, "name": n55, "tier": "5.5", "deb": (at 33 deb)})
                ((and (>= x (at 34 et))(< x (at 35 et))) { "class": c5, "name": n56, "tier": "5.6", "deb": (at 34 deb)})
                ((and (>= x (at 35 et))(< x (at 36 et))) { "class": c5, "name": n57, "tier": "5.7", "deb": (at 35 deb)})
                ;;Class TYCOON
                ((and (>= x (at 36 et))(< x (at 37 et))) { "class": c6, "name": n61, "tier": "6.1", "deb": (at 36 deb)})
                ((and (>= x (at 37 et))(< x (at 38 et))) { "class": c6, "name": n62, "tier": "6.2", "deb": (at 37 deb)})
                ((and (>= x (at 38 et))(< x (at 39 et))) { "class": c6, "name": n63, "tier": "6.3", "deb": (at 38 deb)})
                ((and (>= x (at 39 et))(< x (at 40 et))) { "class": c6, "name": n64, "tier": "6.4", "deb": (at 39 deb)})
                ((and (>= x (at 40 et))(< x (at 41 et))) { "class": c6, "name": n65, "tier": "6.5", "deb": (at 40 deb)})
                ((and (>= x (at 41 et))(< x (at 42 et))) { "class": c6, "name": n66, "tier": "6.6", "deb": (at 41 deb)})
                ((and (>= x (at 42 et))(< x (at 43 et))) { "class": c6, "name": n67, "tier": "6.7", "deb": (at 42 deb)})
                ;;Class DEMIURG
                ((and (>= x (at 43 et))(< x (at 44 et))) { "class": c7, "name": n71, "tier": "7.1", "deb": (at 43 deb)})
                ((and (>= x (at 44 et))(< x (at 45 et))) { "class": c7, "name": n72, "tier": "7.2", "deb": (at 44 deb)})
                ((and (>= x (at 45 et))(< x (at 46 et))) { "class": c7, "name": n73, "tier": "7.3", "deb": (at 45 deb)})
                ((and (>= x (at 46 et))(< x (at 47 et))) { "class": c7, "name": n74, "tier": "7.4", "deb": (at 46 deb)})
                ((and (>= x (at 47 et))(< x (at 48 et))) { "class": c7, "name": n75, "tier": "7.5", "deb": (at 47 deb)})
                ((and (>= x (at 48 et))(< x (at 49 et))) { "class": c7, "name": n76, "tier": "7.6", "deb": (at 48 deb)})
                { "class": c7, "name": n77, "tier": "7.7", "deb": (at 49 deb)}
            )
        )
    )
    ;;{F4}  [CAP]
    ;;
    ;;{F5}  [A]
    ;;{F6}  [C]
    ;;{F7}  [X]
    ;;
)