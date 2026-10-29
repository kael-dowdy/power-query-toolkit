// Generates a custom phonetic key using ordered text replacements.
// Experimental Metaphone-style rules; not verified standard or Double Metaphone.
// Power Query name: metaphone-style-key | Dependencies: none
// Copyright (c) 2026 Kael Dowdy
// SPDX-License-Identifier: MIT
// Source: https://github.com/kael-dowdy/power-query-toolkit

let
    Metaphone = (inputText as text) as text =>
    let
        // Convert input to uppercase and remove non-alphabetic characters
        processedText = Text.Select(Text.Upper(inputText), {"A".."Z"}),

        // Define transformations
        transformations = {
            {"KN", "N"}, {"GN", "N"}, {"PN", "N"}, {"AE", "A"}, {"WR", "R"},
            {"CK", "K"}, {"PH", "F"}, {"Q", "K"}, {"V", "F"}, {"Z", "S"}, 

            // not sure about these
            {"WH", "W"},  {"GH", "H"}, {"X", "S"}, {"SCH", "S"},
            {"TH", "T"}, {"TCH", "CH"}
        },

        // Apply transformations
        step1 = List.Accumulate(transformations, processedText, (state, transform) =>
            Text.Replace(state, transform{0}, transform{1})),

        // Remove vowels except the first character if it's a vowel
        step2 = Text.Start(step1, 1) & 
            Text.Select(
                Text.Middle(
                    step1, 
                    1, 
                    if (Text.Length(step1) - 1) < 0 then 0 else Text.Length(step1) - 1
                ), 
                {"B".."Z"}
            ),

        // Remove duplicate adjacent characters
        step3 = List.Accumulate({1..Text.Length(step2)-1}, Text.Start(step2, 1), (state, current) =>
            if Text.Middle(step2, current - 1, 1) <> Text.Middle(step2, current, 1) then state & Text.Middle(step2, current, 1) else state)

    in
        step3
in
    Metaphone
