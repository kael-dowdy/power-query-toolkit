// Removes each listed character or text fragment using sequential, case-sensitive replacements.
// Usage: #"remove-text-fragments"("A[B]", {"[", "]"}) returns "AB".
// Power Query name: remove-text-fragments | Dependencies: none
// Copyright (c) 2026 Kael Dowdy
// SPDX-License-Identifier: MIT
// Source: https://github.com/kael-dowdy/power-query-toolkit

let 
    Source = (inputText as any, charactersToRemove as list) as any =>
let
    RemoveChars = List.Accumulate(charactersToRemove, inputText, (state, current) => Text.Replace(state, current, ""))
in
    RemoveChars
in
    Source
