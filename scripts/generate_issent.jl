using CSV, DataFrames
using BasicProgramming2024



student_information = CSV.read("student_information.csv", DataFrame)

df = DataFrame()

for this_test0 in BasicProgramming2024.all_tests
    this_test = replace(this_test0, " " => "_")
    dfi = select(student_information, :StudentID)
    insertcols!(dfi, :Test => this_test)  # please refer `gformheaders_quizscore` for header names
    append!(df, dfi)
end

insertcols!(df, :issent => false)

# CSV.write("data/issent.csv", df) # Only do this ONCE.
