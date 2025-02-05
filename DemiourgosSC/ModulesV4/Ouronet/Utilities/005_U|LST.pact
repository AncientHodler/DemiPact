(module U|LST GOV
    ;;
    (implements StringProcessor)
    ;;{G1}
    ;;{G2}
    (defcap GOV ()
        (compose-capability (GOV|U|LST_ADMIN))
    )
    (defcap GOV|U|LST_ADMIN ()
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
    ;;{1}
    ;;{2}
    ;;{3}
    ;;
    ;;{F-UC}
    (defun UC_SplitString:[string] (splitter:string splitee:string)
        @doc "Splits a string using a single string as splitter"
        (if (= 0 (length splitee))
            [] ;If the string is empty return a zero length list
            (let* 
                (
                    (sep-pos (UC_Search (str-to-list splitee) splitter))
                    (substart (map (+ 1) (UC_InsertFirst sep-pos -1)))
                    (sublen  (zip (-) (UC_AppL sep-pos 10000000) substart))
                    (cut (lambda (start len) (take len (drop start splitee))))
                )
                (zip (cut) substart sublen)
            )
        )
    )
    (defun UC_Search:[integer] (searchee:list item)
        @doc "Search an item into the list and returns a list of index"
        (if (contains item searchee)
            (let 
                (
                    (indexes (enumerate 0 (length searchee)))
                    (match (lambda (v i) (if (= item v) i -1)))
                )
                (UC_RemoveItem (zip (match) searchee indexes) -1)
            )
            []
        )
    )
    (defun UC_KeepEndMatch:[string] (in:[string] match:string)
        @doc "From a list of strings, keep only those that match at the end"
        (let
            (
                (l:integer (length match))
                (t:integer (- 0 l))
            )
            (fold 
                (lambda 
                    (acc:[string] item:string)
                    (if (= (take t item) match)
                        (UC_AppL acc item)
                        acc
                    )
                )
                [] 
                in
            )
        )
    )
    (defun UC_ReplaceItem:list (in:list old-item new-item)
        @doc "Replace each occurrence of old-item by new-item"
        (map (lambda (x) (if (= x old-item) new-item x)) in)
    )
    (defun UC_ReplaceAt:list (in:list idx:integer item)
        @doc "Replace the item at position idx"
        (enforce (and? (<= 0) (> (length in)) idx) "Index out of bounds")
        (UC_Chain 
            [
                (take idx in),
                [item],
                (drop (+ 1 idx) in)
            ]
        )
    )
    (defun UC_RemoveItem:list (in:list item)
        @doc "Remove an item from a list"
        (filter (!= item) in)
    )
    (defun UC_RemoveItemAt:list (in:list position:integer)
        @doc "Removes and item from a list existing at a given position"
        (enforce (and (>= position 0) (< position (length in))) "Position must be non-negative and within the bounds of the list")
        (let
            (
                (before (take position in))
                (after (drop (+ position 1) in))
            )
            (+ before after)
        )
    )
    (defun UC_IzUnique (lst:[string])
        @doc "Ensures List is composed of unique elements"
        (let
            (
                (unique-set 
                    (fold 
                        (lambda 
                            (acc:[string] item:string)
                            (enforce 
                                (not (contains item acc)) 
                                (format "Unique Items Required, duplicate item found: {}" [item])
                            )
                            (UC_AppL acc item)
                        )
                        [] 
                        lst
                    )
                )
            )
            true  ; If all items are unique, the function returns true
        )
    )
    (defun UC_FE (in:list)
        @doc "Returns the first item of a list"
        (UEV_NotEmpty in)
        (at 0 in)
    )
    (defun UC_SecondListElement (in:list)
        @doc "Returns the second item of a list"
        (UEV_NotEmpty in)
        (at 1 in)
    )
    (defun UC_LE (in:list)
        @doc "Returns the last item of the list"
        (UEV_NotEmpty in)
        (at (- (length in) 1) in)
    )
    (defun UC_InsertFirst:list (in:list item)
        @doc "Insert an item at the left of the list"
        (+ [item] in)
    )
    (defun UC_AppL:list (in:list item)
        @doc "Append an item at the end of the list"
        (+ in [item])
    )
    (defun UC_IsNotEmpty:bool (x:list)
        @doc "Return true if the list is not empty"
        (< 0 (length x))
    )
    (defun UC_Chain:list (in:list)
        @doc "Chain list of lists"
        (fold (+) [] in)
    )
    ;;{F_UR}
    ;;{F-UEV}
    (defun UEV_NotEmpty:bool (x:list)
        @doc "Verify and Enforces that a list is not empty"
        (enforce (UC_IsNotEmpty x) "List cannot be empty")
    )
    (defun UEV_StringPresence (item:string item-lst:[string])
        (let
            (
                (ref-U|CT:module{OuronetConstants} U|CT)
                (bar:string (ref-U|CT::CT_BAR))
                (iz-present:bool (contains item item-lst))
            )
            (enforce (!= item-lst [bar]) "Empty List detected!")
            (enforce iz-present (format "String {} is not present in list {}." [item item-lst]))
        )
    )
    ;;{F-UDC}
)