# # This is the script for group presentation scores.
# General
# - A-D (total four group)
# - 12/16 explain in class. (all should be prepared).
#
# (1) `A` scores other groups (`B`, `C`, `D`):
# - 5% (absolute score 1 to 5)
# - 12/23 `A` and `B` present
# - 12/30 `C` and `D` present
#
# (2) Member `one` scores others:
# - 10% (absolute score 1 to 10)
#
#
# Shortnote:
# - (1): Three QRCodes for each student (for the other three groups), fill into Google form (a).
# - (2): Three QRCodes for each student (for the other 3 team members), fill into Google form (b).
# - (a): 評分者、被評組別、分數
# - (b): 評分者、被評組員、分數
#
#
# Verification:
# - (a): one 評分者 should have exactly three answers where 被評組別 is the other three.
# - (b): one 評分者 should have exactly three answers where 被評組員 is the other three.

using JSON, QRCoders, CSV, DataFrames
using StatsBase
using BasicProgramming2024

fdir = "img/QRCode/InterGroupLinks"
mkpath(fdir)

secrets = JSON.parsefile("local/secrets.json")
form_innerg = secrets["form_innerGroup"]
form_interg = secrets["form_interGroup"]

student_information = CSV.read("student_information.csv", DataFrame)

quiz_link(MEMBER1, MEMBER2, MEMBER3) = "$(form_innerg)?usp=pp_url&entry.1959851903=$MEMBER1&entry.1626041384=$MEMBER2&entry.143075096=$MEMBER3"
quiz_link(GROUP) = "$(form_interg)?usp=pp_url&entry.143075096=$GROUP"

quiz_link("Tim", "Tom", "Terry")

quiz_link("A")

allgroups = combine(groupby(student_information, :GroupID), :Name => (x -> join(x, "、")) => :NameList) |> (df -> sort!(df, :GroupID))

id2namelist(x) = Dict(allgroups.GroupID .=> allgroups.NameList)[x]

# row = eachrow(student_information)[1]
for row in student_information
    othergroups = subset(allgroups, :GroupID => (x -> x .!= row.GroupID))
    # g = othergroups |> eachrow  |> first
    for g in eachrow(othergroups)
        link = quiz_link(g.GroupID * "($(g.NameList))")
        fpath = "Link_$(row.StudentID)_$(g.GroupID)"
        exportqrcode(link, fpath)
    end
end
