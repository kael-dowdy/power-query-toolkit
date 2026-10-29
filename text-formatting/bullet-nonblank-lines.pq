// Adds a bullet to each nonblank line; trims lines and removes blank lines.
// Null input returns an empty string.
// Power Query name: bullet-nonblank-lines | Dependencies: none
// Copyright (c) 2026 Kael Dowdy
// SPDX-License-Identifier: MIT
// Source: https://github.com/kael-dowdy/power-query-toolkit

/*
    The TextValue input parameter is left as an undefined datatype in case a NULL value is passed in.
    NULL inputs will be returned as a blank/empty string.
*/

let
    Source = (TextValue) as text =>
let
    // 1) Replace NULLs in TextValue with Blanks 
    Step1 = if TextValue <> null then TextValue else "",

    // 2) Trim TextValue
    Step2 = Text.Trim(Step1),

    // 3) Convert TextValue to List Delimited by LineFeed (to handle multi-lined TextValues)
    Step3 = Text.Split(Step2, "#(lf)"),

    // 4) Trim List Items (Rows) in List
    Step4 = List.Transform(Step3, Text.Trim),

    // 5) Select non-blank List Items (Rows) from List
    Step5 = List.Select(Step4, each _ <> ""),

    // 6) Recombine List Items to Single Value
    Step6 = Text.Combine(Step5, "#(lf)"),

    // 7) Add Bullet to TextValue
    Step7 = 
        if Step6 <> null and Text.Length(Step6) > 0 
        then "• " & Text.Replace(Step6, "#(lf)", "#(lf)• ")
        else Step6
in
    Step7
in
    Source
