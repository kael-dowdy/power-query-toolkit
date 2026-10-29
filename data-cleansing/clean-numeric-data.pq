// Checks cleaned input for numeric validity; otherwise uses the replacement.
// Returns cleaned text, not a guaranteed number.
// Dependency: import clean-text-data.pq as a query named clean-text-data.
// Copyright (c) 2026 Kael Dowdy
// SPDX-License-Identifier: MIT
// Source: https://github.com/kael-dowdy/power-query-toolkit

let
    // NumericValue can be any number (whole or decimal), empty string, or null value.
    // Optional ReplacementValue is a nullable number; no explicit default is assigned.
    Source = (NumericValue as any, optional ReplacementValue as nullable number) as any =>

let
    // Helper function to check if the value is numeric and not null or empty
    IsNumericAndNotNullOrEmpty = (value) => 
        if value = null then 
            false
        else 
            if value = "" then 
                false
            else 
                let
                    TryConvert = try Number.From(value) otherwise null
                in
                    TryConvert <> null,

    _NumericValue_Clean     = #"clean-text-data"(NumericValue),
    _ReplacementValue_Clean = #"clean-text-data"(ReplacementValue),

    // Check if NumericValue is numeric; if not, attempt to use ReplacementValue
    _NumericValue_Step1 =
        if IsNumericAndNotNullOrEmpty(_NumericValue_Clean) then
            _NumericValue_Clean
        else
            null,

    _ReplacementValue_Step1 = 
        if
            Value.Is(Number.From(_ReplacementValue_Clean), type number) 
        then
            _ReplacementValue_Clean
        else
            null,

    // perform null checks and set vars to empty strings
    _ReplacementValue = if _ReplacementValue_Step1 = null then null                    else _ReplacementValue_Step1,
    _NumericValue     = if _NumericValue_Step1     = null then _ReplacementValue_Step1 else _NumericValue_Step1,

    ReturnedNumericValue = _NumericValue
in
    ReturnedNumericValue
in
    Source
