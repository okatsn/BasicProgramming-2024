# KEYNOTE:
# - This script is not in dvc pipeline. Run it after `dvc repro` (update all scores).
# - This script load and modify `issent.csv`.
# - `issent.csv` should be generated at the first place. See `generate_issent.jl`.
using JSON, DataFrames, CSV, Chain, SMTPClient, HypertextLiteral
using Dates
using BasicProgramming2024

# SETME:
do_send_email = false
secrets = JSON.parsefile("local/secrets.json")

# ARGS = ["Python_for_beginners_5-8", ]

score_quiz = CSV.read("data/quiz_score.csv", DataFrame)
issent_ref = CSV.read("data/issent.csv", DataFrame)

df = rightjoin(score_quiz, issent_ref, on=[:StudentID, :Test], order=:right)
# The row indices is stick to the `issent_ref` (`order=:right`).

sender_key = secrets["sender_key"]
sender = secrets["sender"]

student_information = CSV.read("student_information.csv", DataFrame)
contact = Dict(student_information.StudentID .=> student_information.gmail)


# # Send Email After the scores are all registered.

url = "smtps://smtp.gmail.com:465"
from = "<$sender>"

opt = SendOptions(
    isSSL=true,
    username=sender,
    passwd=sender_key,
)

# row = eachrow(df) |> first
for (i, row) in enumerate(eachrow(df))
    if ismissing(row.Name)
        continue
    end # Since `df` is `rightjoin`ed, its row is the same as `issent_ref`, and there might be missing values in `:Name` (as well as any of the scores). The reason of not using `dropmissing!` is to ensure the index `i` consistent with `issent_ref`.
    subject = replace(row.Test, "_" => " ") * " 成績摘要"
    keynote1 = ifelse(ismissing(row.Note), "", "**備註**:$(row.Note)")
    keynote2 = ifelse(ismissing(row.Violate), "", "**違規註記**:$(row.Violate)")
    msg0 = @htl("""
    <html>
        <head>
            <style>
            h1 {
                font-size: 24px;
                font-weight: bold;
            }

            h2 {
                font-size: 18px;
                font-weight: bold;
            }

            table {
                border-collapse: collapse;
                width: 100%;
            }

            table, th, td {
                border: 1px solid black;
            }
            </style>
        </head>

        <body>
            <p>
                $(row.StudentID) $(row.Name)同學您好，
                <br>
                您本次的成績登記如下
                <p>
                    <ul>
                        <li>測驗A：$(row.Score_A)</li>
                        <li>測驗B：$(row.Score_B)</li>
                    </ul>
                </p>

                <p>
                $keynote1
                <br>
                $keynote2
                </p>

                <br>
                若有任何疑問，請回信 $sender 或至科一館 S113 找助教。
            </p>
        </body>
    </html>
    """)

    recipients = []
    in_rcpt_list = false
    if !row.issent && do_send_email
        push!(recipients, contact[row.StudentID])
        in_rcpt_list = true
    else
        push!(recipients, "tsung.hsi@g.ncu.edu.tw")
    end # only when not sent yet, this student will be push into the recipient list.

    rcpt = to = ["<$(strip(recipient))>" for recipient in recipients]

    io = IOBuffer()
    print(io, msg0)

    message = get_mime_msg(HTML(String(take!(io)))) # do this if message is HTML
    body = get_body(
        to,
        from,
        subject,
        message
        # ; attachments=["Slide_TrafficInfo/Fig_publicTransport.png", "Slide_TrafficInfo/greenbreeze_map.jpg"]
    ) # cc, replyto)
    # Preview the body: String(take!(body))

    resp = send(url, rcpt, from, body, opt)
    issent_ref.issent[i] = true
    CSV.write("data/issent.csv", issent_ref)

end
