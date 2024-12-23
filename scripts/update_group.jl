using JSON, OkReadGSheet, DataFrames, CSV, Chain
using Dates
using OkReadGSheet
using BasicProgramming2024


secrets = JSON.parsefile("local/secrets.json")
student_information = CSV.read("student_information.csv", DataFrame)

gmail_name = Dict(student_information.gmail .=> student_information.Name)
gmail_gid = Dict(student_information.gmail .=> student_information.GroupID)

inner_score = @chain readgsheet(secrets["score_innerGroup"]) begin
    innerscoreprep!
    transform!(Cols(r"Member_\d+") => ByRow((args...) -> Set(args)) => :NotMe)

    # Authentication
    filter!(:TheirEmail => in(student_information.gmail), _) # remove alien filler
    filter!(AsTable(:) => nt -> !in(gmail_name[nt.TheirEmail], nt.NotMe), _) # Filler cannot score him/herself
end
inter_score = @chain readgsheet(secrets["score_interGroup"]) begin
    interscoreprep!
    transform!(:TheirEmail => ByRow(x -> gmail_gid[x]) => :GID)

    # Authentication
    filter!(:TheirEmail => in(student_information.gmail), _) # remove alien filler
    filter!(AsTable(:) => (nt -> !isequal(nt.GID, nt.Group) && length(nt.Group) == 1), _) # Filler's group (GID) cannot be the score's group; additional check of nt.Group's string length.
end
