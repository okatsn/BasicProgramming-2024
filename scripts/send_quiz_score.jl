using JSON, DataFrames, CSV, Chain, SMTPClient, HypertextLiteral
using Dates
using BasicProgramming2024

# SETME:
do_send_email = false
secrets = JSON.parsefile("local/secrets.json")

# ARGS = ["Python_for_beginners_5-8", ]
this_test = ARGS[1]
keepthistest = :Test => x -> (x .== this_test)

score_quiz = CSV.read("data/quiz_score.csv", DataFrame)
issent_ref = CSV.read("data/issent.csv", DataFrame)
issent_this = subset(issent_ref, keepthistest; view=true)


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

# row = eachrow(score_quiz) |> first
for row in eachrow(score_quiz)
    id_sent = subset(issent_this, :StudentID => (x -> x .== row.StudentID); view=true).issent
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
    if !only(id_sent) && do_send_email
        push!(recipients, contact[row.StudentID])
        in_rcpt_list = true
    end # only when `id_sent[1]` is `false` (not sent yet), this student will be push into the recipient list.

    if isempty(recipients)
        push!(recipients, "tsung.hsi@g.ncu.edu.tw")
    end # Send otherwise mail to the sender itself.

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
    if do_send_email && in_rcpt_list
        id_sent[1] = true # Noted that `id_sent` is a view that linked to `issent_ref`
        CSV.write("data/issent.csv", issent_ref)
    end

end
