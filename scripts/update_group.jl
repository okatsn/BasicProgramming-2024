using JSON, OkReadGSheet, DataFrames, CSV, Chain
using Dates
using OkReadGSheet
using BasicProgramming2024


secrets = JSON.parsefile("local/secrets.json")
student_information = CSV.read("student_information.csv", DataFrame)

gid_gmails = @chain student_information begin
    groupby(:GroupID)
    combine(:gmail => Ref => :gmails)
end

gid_gmails = gid_gmails |> (x -> Dict(x.GroupID .=> x.gmails))

@chain student_information begin
    transform!(:GroupID => ByRow(i -> Set(gid_gmails[i])) => :AllMembers)
    transform!([:gmail, :AllMembers] => ByRow((r, a) -> Set(setdiff(a, [r]))) => :NotMe) # noted that the argument order in setdiff is critical.
end

gmail_notme = Dict(student_information.gmail .=> student_information.NotMe)
gmail_name = Dict(student_information.gmail .=> student_information.Name)
name_gmail = Dict(student_information.Name .=> student_information.gmail)
gmail_gid = Dict(student_information.gmail .=> student_information.GroupID)

# # Authenticate

inner_score0 = readgsheet(secrets["score_innerGroup"])
inner_score = @chain inner_score0 begin
    innerscoreprep!
    transform!(:ReplierEmail => ByRow(x -> gmail_gid[x]) => :GID)
    transform!(:ReplierEmail => ByRow(i -> gmail_notme[i]) => :NotMe)

    # Authentication
    filter!(:ReplierEmail => in(student_information.gmail), _) # remove alien replier
    filter!(AsTable(:) => nt -> !in(nt.ReplierEmail, nt.NotMe), _) # replier cannot score him/herself
end

inter_score0 = readgsheet(secrets["score_interGroup"])
inter_score = @chain inter_score0 begin
    interscoreprep!
    transform!(:ReplierEmail => ByRow(x -> gmail_gid[x]) => :GID)

    # Authentication
    filter!(:ReplierEmail => in(student_information.gmail), _) # remove alien replier
    filter!(AsTable(:) => (nt -> !isequal(nt.GID, nt.Group) && length(nt.Group) == 1), _) # replier's group (GID) cannot be the score's group; additional check of nt.Group's string length.
end

if nrow(inner_score) != nrow(inner_score0)
    @warn "Some reply do not pass authentication (Inner score)."
end
if nrow(inter_score) != nrow(inter_score0)
    @warn "Some reply do not pass authentication (Inner score)."
end


# # Calculate
inner_score_stacked = @chain inner_score begin
    select(Not(r"Member"), [:Member_1, :Member_2, :Member_3,] => ByRow((x, y, z) -> (x, y, z)) => :Members)
    stack(Cols(r"^Score_"); variable_name=:score_tag, value_name=:score)
    transform(:score_tag => ByRow(x -> parse(Int, match(r"\d+", x).match)) => :MemberID)
    transform([:Members, :MemberID] => ByRow((m, i) -> m[i]) => :name)
    select(:Time, :name, :score, :ReplierEmail => :scored_by)
    groupby([:name, :scored_by])
    takelast
end


if nrow(inner_score_stacked) != 3 * nrow(inner_score)
    @warn "Some replies of the same replier that has earlier time was discarded."
end
