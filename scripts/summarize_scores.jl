using CSV, DataFrames, JSON, Chain, Statistics
using BasicProgramming2024
BP = BasicProgramming2024

secrets = JSON.parsefile("local/secrets.json")
df_inter = CSV.read("data/intergroup_score.csv", DataFrame)
df_inner = CSV.read("data/innergroup_score.csv", DataFrame)
df_quiz = CSV.read("data/quiz_score.csv", DataFrame)
student_information = CSV.read("student_information.csv", DataFrame)

summary_of_quiz = @chain df_quiz begin
    stack(Cols(r"Score\_"))
    groupby(:Name)
    combine(:value => mean => :score_mean)
    # transform(AsTable(Cols(r"Score\_")) => ByRow(mean) => :score_mean)
    # select(:Name, )
end

@chain leftjoin(student_information, df_inner; on=[:Name, :gmail]) begin
    select(Not(:who_did_not_score))
    sort(:Number)
    transform(:score_mean => ByRow(x -> x * BP.inner_score_weight); renamecols=false)
    rename(:score_mean => "組內評分")

    leftjoin(df_inter; on=:GroupID)
    transform(:score_mean => ByRow(x -> x * BP.inter_score_weight); renamecols=false)
    rename(:score_mean => "組間互評")
    select(Not(:score_mean, :who_did_not_score))

    leftjoin(summary_of_quiz; on=:Name)
    transform(:score_mean => ByRow(x => x * BP.quiz_score_weight); renamecols=false)
    rename(:score_mean => "上機測驗")

end
