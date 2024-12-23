using JSON, OkReadGSheet, DataFrames, CSV, Chain
using Dates
using OkReadGSheet
using BasicProgramming2024

# ARGS = ["Python_for_beginners_5-8", ]
this_test = ARGS[1]
keepthistest = :Test => x -> (x .== this_test)

secrets = JSON.parsefile("local/secrets.json")

score_quiz = @chain readgsheet(secrets["score_quiz"]) begin
    quizscoreprep!
    filter!(:MyEmail => x -> (x in secrets["filler"]), _) # verify who fill the form.
    filter!(keepthistest, _)
    groupby([:Name, :StudentID])
    combine(gd -> gd[argmax(gd.Time), :]) # take the row with the largest time.
end

if isfile("data/quiz_score.csv")
    header = false
    app = true
else
    header = [:Test, :StudentID, :Name, :Score_A, :QuizNum_A, :Score_B, :QuizNum_B, :MyEmail, :Violate, :Note, :Time]
    app = false
end

CSV.write("data/quiz_score.csv", score_quiz, header=header, append=app)
# KEYNOTE: You need to set `persist: true` in dvc.yaml; otherwise, the output will be removed before `dvc repro`.
# E.g.
# ```dvc.yaml
#     outs:
#       - data/quiz_score.csv:
#           persist: true
# ```
# Please refer:
# - DVC add with option `--outs-persist`: https://dvc.org/doc/command-reference/stage/add#--outs-persist
# - https://github.com/iterative/dvc/issues/1214
# - https://github.com/iterative/dvc.org/pull/2029/files/4075dd2834bbcdf8bdd7fa419071933dfdace398
