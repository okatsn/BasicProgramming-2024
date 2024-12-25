using DataFrames, CSV, Chain

inner = @chain CSV.read("data/intergroup_score.csv", DataFrame) begin
    transform(:who_did_not_score => ByRow(x -> eval(Meta.parse(x))); renamecols=false)
end
inter = @chain CSV.read("data/innergroup_score.csv", DataFrame) begin
    transform(:who_did_not_score => ByRow(x -> eval(Meta.parse(x))); renamecols=false)
end
