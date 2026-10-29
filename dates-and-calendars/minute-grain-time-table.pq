// Builds a 24-hour time dimension with 1,440 rows, one per minute.
// Includes hour, quarter-hour, half-hour, and period-of-day attributes.
// Paste into a blank query; returns a table, not a function.
// Suggested Power Query name: minute-grain-time-table | Dependencies: none
// Copyright (c) 2026 Kael Dowdy
// SPDX-License-Identifier: MIT
// Source: https://github.com/kael-dowdy/power-query-toolkit

let
  Source = List.Times(#time(0, 0, 0), 24*60, #duration(0,0,1,0)),
  // Turn that list into a one column table
  #"Convert Time List to Table" = Table.FromList(Source, Splitter.SplitByNothing()),
  #"Renamed TimeKey" = Table.RenameColumns(#"Convert Time List to Table",{{"Column1", "TimeKey"}}), 
  // Change that table's one column to type Time
  #"Changed TimeKey Type" = Table.TransformColumnTypes(#"Renamed TimeKey",{{"TimeKey", type time}}),
    #"Added TimeStr" = Table.AddColumn(#"Changed TimeKey Type", "TimeStr", each Time.ToText([TimeKey], "HHmm"), type text),
  #"Added Hour" = Table.AddColumn(#"Added TimeStr", "Hour", each Time.Hour([TimeKey]), Int64.Type),
  #"Added Minute" = Table.AddColumn(#"Added Hour", "Minute", each Time.Minute([TimeKey]), Int64.Type),
    // Start inserting columns for each unit of time to represent in the dimension
    #"Added Top of Hour" = Table.AddColumn(#"Added Minute", "Top of Hour", each Time.StartOfHour([TimeKey]), Time.Type),
    #"Added Next Hour" = Table.AddColumn(#"Added Top of Hour", "Next Hour", each Value.Add([Top of Hour],#duration(0,1,0, 0)), Time.Type),
  // Creating levels in the hierarchy that might be useful for reporting. Omit if not useful to yours
  #"Added Quarter Hour" = Table.AddColumn(#"Added Next Hour", "Quarter Hour", each 
      if 
        [Minute] < 15 
      then 
        [Top of Hour] 
      else if 
        [Minute] < 30 
      then 
        Value.Add([Top of Hour],#duration(0,0,15, 0)) 
      else if 
        [Minute] < 45 
      then 
        Value.Add([Top of Hour],#duration(0,0,30, 0)) 
      else 
        Value.Add([Top of Hour],#duration(0,0,45, 0)), Time.Type),
    #"Added Next Quarter Hour" = Table.AddColumn(#"Added Quarter Hour", "Next Quarter Hour", each Value.Add([Quarter Hour], #duration(0,0,15,0)), Time.Type),

    #"Added Half Hour" = Table.AddColumn(#"Added Next Quarter Hour", "Half Hour", each 
      if 
        [Minute] < 30 
      then 
        [Top of Hour] 
      else
        Value.Add([Top of Hour],#duration(0,0,30, 0)), Time.Type),

  #"Added Period of Day" = Table.AddColumn(#"Added Half Hour", "Period of Day", each 
      if 
        [Hour] >= 0 and [Hour] < 4 
      then 
        "After Midnight" 
      else if 
        [Hour] >= 4 and [Hour] < 8 
      then 
        "Early Morning" 
      else if
        [Hour] >= 8 and [Hour] < 12 
      then 
        "Late Morning" 
      else if 
        [Hour] >= 12 and [Hour] < 16 
      then 
        "Afternoon" 
      else if 
        [Hour] >= 16 and [Hour] < 20 
      then 
        "Evening" 
      else 
        "Late Night", Text.Type),

  #"Added Period of Day Sort" = Table.AddColumn(#"Added Period of Day", "Period of Day Sort", each if 
        [Hour] >= 0 and [Hour] < 4 
      then 
        1
      else if 
        [Hour] >= 4 and [Hour] < 8 
      then 
        2
      else if
        [Hour] >= 8 and [Hour] < 12 
      then 
        3
      else if 
        [Hour] >= 12 and [Hour] < 16 
      then 
        4
      else if 
        [Hour] >= 16 and [Hour] < 20 
      then 
        5
      else 
        6, Int64.Type)
in
    #"Added Period of Day Sort"
