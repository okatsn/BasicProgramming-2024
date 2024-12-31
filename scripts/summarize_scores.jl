using CSV, DataFrames, JSON, Chain, Statistics
using BasicProgramming2024
BP = BasicProgramming2024

secrets = JSON.parsefile("local/secrets.json")
df_inter = CSV.read("data/intergroup_score.csv", DataFrame)
df_inner = CSV.read("data/innergroup_score.csv", DataFrame)
df_quiz = CSV.read("data/quiz_score.csv", DataFrame)
df_plan = CSV.read("data/plan_score_by_ccc.csv", DataFrame)
student_information = CSV.read("student_information.csv", DataFrame)

summary_of_quiz = @chain df_quiz begin
    stack(Cols(r"Score\_"))
    groupby(:Name)
    combine(:value => mean => :score_mean)
    # transform(AsTable(Cols(r"Score\_")) => ByRow(mean) => :score_mean)
    # select(:Name, )
end


final_sheet = @chain student_information begin
    leftjoin(df_inner; on=[:Name, :gmail], renamecols="" => "_inner") # The column names appended on the right is suffixed by "_inner". The "left" columns are suffixed by nothing.
    transform(:score_mean_inner => ByRow(x -> x * BP.inner_score_weight); renamecols=false)

    leftjoin(df_inter; on=:GroupID, renamecols="" => "_inter")
    transform(:score_mean_inter => ByRow(x -> x * BP.inter_score_weight); renamecols=false)

    leftjoin(summary_of_quiz; on=:Name, renamecols="" => "_quiz")
    transform(:score_mean_quiz => ByRow(x -> x * BP.quiz_score_weight); renamecols=false)

    leftjoin(df_plan; on=:GroupID, renamecols="" => "_plan")
    transform(:Score_plan => ByRow(x -> x * BP.plan_score_weight); renamecols=false)
    rename(:Score_plan => :score_plan)

    select(Not(r"who_did_not_score"))

    transform(AsTable(r"score") => ByRow(sum) => :score_overall)

    transform(Cols(r"score\_") .=> ByRow(x -> round(x; digits=2)); renamecols=false)
    select(:Number, :Department, :StudentID, :Name, :Gender, :score_mean_quiz, :score_mean_inner, :score_mean_inter, :score_overall)
    sort(:Number)
    rename(:score_plan => "計畫書")
    rename(:score_mean_inner => "組內評分")
    rename(:score_mean_inter => "組間互評")
    rename(:score_mean_quiz => "上機測驗")
    rename(:score_overall => "總分")
    rename(:Number => "編號")
    rename(:Name => "姓名")
    rename(:Gender => "性別")
    rename(:Department => "系所別")
    rename(:StudentID => "學號")

    sort(:Number)

end

CSV.write("data/final_score.csv", final_sheet)
