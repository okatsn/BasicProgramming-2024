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

final_sheet = @chain leftjoin(student_information, select(df_inner, Not(:who_did_not_score)); on=[:Name, :gmail]) begin
    sort(:Number)
    transform(:score_mean => ByRow(x -> x * BP.inner_score_weight); renamecols=false)
    rename(:score_mean => :score_mean_inner)

    leftjoin(select(df_inter, Not(:who_did_not_score)); on=:GroupID)
    transform(:score_mean => ByRow(x -> x * BP.inter_score_weight); renamecols=false)
    rename(:score_mean => :score_mean_inter)

    leftjoin(summary_of_quiz; on=:Name)
    transform(:score_mean => ByRow(x -> x * BP.quiz_score_weight); renamecols=false)
    rename(:score_mean => :score_mean_quiz)

    transform(AsTable([:score_mean_quiz, :score_mean_inner, :score_mean_inter]) => ByRow(sum) => :score_overall)


    select(:Number, :Department, :StudentID, :Name, :Gender, :score_mean_quiz, :score_mean_inner, :score_mean_inter, :score_overall)
    rename(:score_mean_inner => "組內評分")
    rename(:score_mean_inter => "組間互評")
    rename(:score_mean_quiz => "上機測驗")
    rename(:score_overall => "總分")
    rename(:Number => "編號")
    rename(:Name => "姓名")
    rename(:Gender => "性別")
    rename(:Department => "系所別")
    rename(:StudentID => "學號")
end

CSV.write("data/score_ccc.csv", final_sheet)
