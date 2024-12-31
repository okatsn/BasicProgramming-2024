using JSON, OkReadGSheet, DataFrames, CSV, Chain
using Dates
using OkReadGSheet
using BasicProgramming2024

# ARGS = ["Python_for_beginners_5-8", ]
path_target = "data/quiz_score.csv"

secrets = JSON.parsefile("local/secrets.json")

header0 = [:Test, :StudentID, :Name, :Score_A, :QuizNum_A, :Score_B, :QuizNum_B, :MyEmail, :Violate, :Note, :Time]

score_quiz = @chain readgsheet(secrets["score_quiz"]) begin
    quizscoreprep!
    filter!(:MyEmail => x -> (x in secrets["filler"]), _) # verify who fill the form.
    groupby([:Test, :Name, :StudentID])
    takelast
end

CSV.write(path_target,
    select(score_quiz, header0), # Select is critical to assure the appended rows corresponds the the correct column header.
) # This is designed to write to a non-persistent data, so there is no append.

# KEYNOTE: By default, the output (`dir_quiz_score`) will be removed before `dvc repro` unless `persist` is `true`.
# However, `persist: true` could be dangerous, for example, you might run a script of "experimental" version manually which append rows to the data for testing, and later after this script is OK, you run `dvc repro` which call the "released" version this script. In this case, since the output data is persist, appended "experimental" rows will be kept in the locked version after `dvc repro`.
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
