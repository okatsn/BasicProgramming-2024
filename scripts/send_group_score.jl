using JSON, OkReadGSheet, DataFrames, CSV, Chain
using Dates
using OkReadGSheet
using BasicProgramming2024
using Statistics

secrets = JSON.parsefile("local/secrets.json")

df = @chain CSV.read("data/innergroup_with_note.csv", DataFrame) begin
    dropmissing(:Note)
    groupby(:Name)
    combine(:Note => (x -> join(x, "\n- ")))
end



df2 = @chain CSV.read("data/intergroup_with_note.csv", DataFrame) begin
    dropmissing(:Note)
    groupby(:Group)
    combine(:Note => (x -> join(x, "\n- ")))
end
