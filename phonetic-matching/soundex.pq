// Generates a four-character Soundex-style key from text.
// Variant implementation; validate against your target Soundex system.
// Power Query name: soundex | Dependencies: none
// Copyright (c) 2026 Kael Dowdy
// SPDX-License-Identifier: MIT
// Source: https://github.com/kael-dowdy/power-query-toolkit

let Soundex = (string as text) =>

    /* Soundex algorithm:
        1. Save the first letter. Remove all occurrences of 'h' and 'w' except first letter.
        2. Replace all consonants (include the first letter) with digits.
        3. Replace all adjacent same digits with one digit.
        4. Remove all occurrences of a, e, i, o, u, y except first letter.
        5. If first symbol is a digit replace it with letter saved on step 1.
        6. Append 3 zeros if result contains less than 3 digits. Remove all except first letter 
            and 3 digits after it.
    */

    let
        /* Uppercase and clean string of non-alpha chars */
        #"Cleaned String" = 
            Text.Upper(
                /* V2: Replaces Text.Remove approach */
                Text.Select(string,{"a".."z","A".."Z","0".."9"}) 
            ),
        
        /* Save first letter */
        #"First Character" = Text.Start(#"Cleaned String", 1)

    in

    /*  If we have nothing after cleansing then return null */
    if Text.Length(#"Cleaned String") < 1 or #"Cleaned String" = null
        then
            let

                #"Soundex Code" = null

            in #"Soundex Code"

    /*  If we have a single character after cleansing, just return it and the padded zeroes */
    else if Text.Length(#"Cleaned String") = 1
        then
            let

                #"Soundex Code" = #"First Character" & "000"

            in #"Soundex Code"

    else 
        let

            /*  Produce a table, which is the remaining characters split into rows. We'll also create
            an empty column to store mapped soundex digits. To allow us to look at the previous 
            row for consecutive character checking we also create an index column. */
            #"Split Character List" =
                Table.FromList(
                    Text.ToList(Text.Range(#"Cleaned String", 1)),
                    Splitter.SplitByNothing(),
                    {"Character"}
                ),
            #"Character Index Column" = 
                Table.AddIndexColumn(
                    #"Split Character List",
                    "Index", 
                    0, 
                    1
                ),
            #"Soundex Code Column" = 
                Table.AddColumn(
                    #"Character Index Column", 
                    "Soundex", 
                    each null,
                    type text
                ),

        /*  Now, we need to process the table of characters, one row at a time. We set the value
            of the {Soundex} column to either the numeric representation, or a null if it's not 
            in the list of valid characters, or it's a valid character but the previous character 
            was the same.
        */
        #"Processed Characters" = Table.FromRecords(
            Table.TransformRows(
                #"Soundex Code Column",
                each
                    Record.TransformFields(
                        _,
                        {"Soundex", (f)=>
                            let 
                                /*  Set flag to true if consecutive characters found */
                                omitChar = (
                                    if [Index] <> 0
                                        and #"Soundex Code Column"
                                            {[Index] - 1}[Character] = [Character]
                                        then true
                                    else false
                                ),
                                /*  Check for character in list and assign a numeric value, 
                                    if not eligible for omission */
                                soundexChar = (
                                    if omitChar = false
                                        then
                                            if      List.Contains(
                                                        {"B", "P", "F", "V"},
                                                        [Character]
                                                    ) 
                                                    then "1"
                                            else if List.Contains(
                                                        {"C", "G", "J", "K", "Q", "S", "X", "Z"},
                                                        [Character]
                                                    )
                                                    then "2"
                                            else if List.Contains(
                                                        {"D", "T"},
                                                        [Character]
                                                    )
                                                    then "3"
                                            else if List.Contains(
                                                        {"L"},
                                                        [Character]
                                                    )
                                                    then "4"
                                            else if List.Contains(
                                                        {"M", "N"},
                                                        [Character]
                                                    )
                                                    then "5"
                                            else if List.Contains(
                                                        {"R"},
                                                        [Character]
                                                    ) 
                                                    then "6"
                                            else null
                                    else null                           
                                )
                            in
                                soundexChar
                        }
                    )
            )
        ),

        /*  Now, we remove the placeholder characters by filtering them out of the table. */
        #"Removed Placeholders" = 
            Table.SelectRows(
                #"Processed Characters",
                each [Soundex] <> null
            ),

        /*  Last bit! We join the numerics from the {Soundex} column and get the first three
            characters, padding with zeros if shorter. Then, we glue on the first character 
            from earlier to get our full soundex code. */
        #"Soundex Digit Combiner" = Combiner.CombineTextByDelimiter(""),
        #"Soundex Digits" = 
            Text.PadEnd(
                Text.Start(
                    #"Soundex Digit Combiner"(
                        Table.ToList(
                            Table.SelectColumns(#"Removed Placeholders", {"Soundex"})
                        )
                    ),
                    3
                ),
                3,
                "0"
            ),
        #"Soundex Code" = #"First Character" & #"Soundex Digits"

    in
        #"Soundex Code"

in Soundex
