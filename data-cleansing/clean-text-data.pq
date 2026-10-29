// Trims and cleans text; replaces null or blank input.
// Power Query name: clean-text-data | Dependencies: none
// Copyright (c) 2026 Kael Dowdy
// SPDX-License-Identifier: MIT
// Source: https://github.com/kael-dowdy/power-query-toolkit

let
    // TextValue can be any string or null value (including empty strings)
    // Optional ReplacementValue is a string.  Default is an empty string
    Source = (TextValue as any, optional ReplacementValue as text) as text =>
let
    // set text value variables and perform datatype test to cast numerics to text
    _TextValue_Step1 = 
        if 
            Value.Type(TextValue) = Number.Type
        then
            Number.ToText(TextValue)
        else
            TextValue,

    _ReplacementValue_Step1 = 
        if 
            Value.Type(ReplacementValue) = Number.Type
        then
            Number.ToText(ReplacementValue)
        else
            ReplacementValue,


    // pre-processing data cleansing
    _TextValue_Step2 = Text.Trim(Text.Clean(_TextValue_Step1)),
    _ReplacementValue_Step2 = Text.Trim(Text.Clean(_ReplacementValue_Step1)),

    // perform null checks and set vars to empty strings
    _TextValue = if _TextValue_Step2 = null then "" else _TextValue_Step2,
    _ReplacementValue = if _ReplacementValue_Step2 = null then "" else _ReplacementValue_Step2,

    // if cleansed TextValue is blank, then return ReplacementValue (defaults to blank if not supplied).
    // otherwise, return the cleansed TextValue
    ReturnedTextValue = if Text.Length(_TextValue) = 0 then _ReplacementValue else _TextValue
in
    ReturnedTextValue
in
    Source
