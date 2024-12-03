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

allgroups = combine(groupby(student_information, :GroupID),
    :Name => (x -> join(x, "、")) => :NameList,
    :Name => (x -> Ref(x)) => :NameVec
) |> (df -> sort!(df, :GroupID))

id2namelist(x) = Dict(allgroups.GroupID .=> allgroups.NameList)[x]

df0 = DataFrame(
    :Name => String[],
    :StudentID => Int[],
    :Link1 => String[],
    :Path1 => String[],
    :Description1 => String[],
    :Link2 => String[],
    :Path2 => String[],
    :Description2 => String[],
    :Link3 => String[],
    :Path3 => String[],
    :Description3 => String[],
    :Link4 => String[],
    :Path4 => String[],
)

# row = eachrow(student_information)[1]
for row in eachrow(student_information)
    othergroups = subset(allgroups, :GroupID => (x -> x .!= row.GroupID))
    mygroup = subset(allgroups, :GroupID => (x -> x .== row.GroupID)) |> eachrow |> only
    @assert nrow(othergroups) == 3

    # g = othergroups |> eachrow  |> first
    qcs = [(
        link = quiz_link(g.GroupID);
        fname = "Link_$(row.StudentID)_$(g.GroupID).png";
        fpath = joinpath(fdir, fname);
        exportqrcode(link, fpath);
        (link=link, file=fpath, description="對$(g.GroupID)組($(g.NameList))評分")
    ) for g in eachrow(othergroups)]

    link4 = quiz_link(filter(x -> row.Name != x, mygroup.NameVec)...)
    file4 = "interGroupFor_$(row.StudentID).png"
    fpath4 = joinpath(fdir, file4)
    exportqrcode(link4, fpath4)

    dfi = DataFrame(
        :Name => row.Name,
        :StudentID => row.StudentID,
        :Link1 => qcs[1].link,
        :Path1 => qcs[1].file,
        :Description1 => qcs[1].description,
        :Link2 => qcs[2].link,
        :Path2 => qcs[2].file,
        :Description2 => qcs[2].description,
        :Link3 => qcs[3].link,
        :Path3 => qcs[3].file,
        :Description3 => qcs[3].description,
        :Link4 => link4,
        :Path4 => fpath4,
    )

    append!(df0, dfi)
end

CSV.write("data/group_qrcode_links.csv", df0)
