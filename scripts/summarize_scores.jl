using CSV, DataFrames
df_inter = CSV.read("data/intergroup_score.csv", DataFrame)
df_inner = CSV.read("data/innergroup_score.csv", DataFrame)
df_quiz = CSV.read("data/quiz_score.csv", DataFrame)
