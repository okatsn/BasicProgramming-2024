using JSON, OkReadGSheet, DataFrames, CSV, Chain
using Dates
using OkReadGSheet
using BasicProgramming2024
using Statistics

do_send_email = false
student_information = CSV.read("student_information.csv", DataFrame)

note_inner = @chain CSV.read("data/innergroup_with_note.csv", DataFrame) begin
    dropmissing(:Note)
    groupby(:Name)
    combine(:Note => (x -> join(x, "\n- ")) => :note_summary)
end
innernote(name) = Dict(note_inner.Name .=> note_inner.note_summary)[name]


note_inter = @chain CSV.read("data/intergroup_with_note.csv", DataFrame) begin
    dropmissing(:Note)
    groupby(:Group)
    combine(:Note => (x -> join(x, "\n- ")) => :note_summary)
end
internote(gid) = Dict(note_inter.Group .=> note_inter.note_summary)[gid]


score_inter = CSV.read("data/intergroup_score.csv", DataFrame)
interscore(gid) = Dict(score_inter.GroupID .=> score_inter.score_mean)[gid]

score_inner = CSV.read("data/innergroup_score.csv", DataFrame)
innerscore(name) = Dict(score_inner.Name .=> score_inner.score_mean)[name]
