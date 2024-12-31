using JSON, OkReadGSheet, DataFrames, CSV, Chain
using Dates
using OkReadGSheet
using BasicProgramming2024
using Statistics
using OkHypertextTools
using SMTPClient, HypertextLiteral

do_send_email = false # SETME
student_information = CSV.read("student_information.csv", DataFrame)

note_inner = @chain CSV.read("data/innergroup_with_note.csv", DataFrame) begin
    dropmissing(:Note)
    groupby(:Name)
    combine(:Note => Ref => :note_summary)
end
innernote(name) = get(Dict(note_inner.Name .=> note_inner.note_summary), name, "無")


note_inter = @chain CSV.read("data/intergroup_with_note.csv", DataFrame) begin
    dropmissing(:Note)
    groupby(:Group)
    combine(:Note => Ref => :note_summary)
end
internote(gid) = get(Dict(note_inter.Group .=> note_inter.note_summary), gid, "無")


score_inter = CSV.read("data/intergroup_score.csv", DataFrame)
interscore(gid) = Dict(score_inter.GroupID .=> score_inter.score_mean)[gid]

score_inner = CSV.read("data/innergroup_score.csv", DataFrame)
innerscore(name) = Dict(score_inner.Name .=> score_inner.score_mean)[name]

score_quiz = CSV.read("data/quiz_score.csv", DataFrame)
quizscore(test, sid) = groupby(score_quiz, [:Test, :StudentID])[(Test=test, StudentID=sid)]
quizdetail(sid) = groupby(score_quiz, [:StudentID])[(; StudentID=sid)]
selectquizdetail(sid) = select(
    quizdetail(sid),
    :Test => "測驗名稱",
    :QuizNum_A => "測驗一",
    :Score_A => "分數一",
    :QuizNum_B => "測驗二",
    :Score_B => "分數二"
)

score_final = CSV.read("data/score_ccc.csv", DataFrame)
finalscore(sid) = Dict(score_final.var"學號" .=> score_final.var"總分")[sid]
# quizscore("Python_for_beginners_13-16", 110605002)
# quizdetail(110605002) |> render_table








# # Send Email After the scores are all registered.
secrets = JSON.parsefile("local/secrets.json")
sender_key = secrets["sender_key"]
sender = secrets["sender"]

url = "smtps://smtp.gmail.com:465"
from = "<$sender>"

opt = SendOptions(
    isSSL=true,
    username=sender,
    passwd=sender_key,
)





# row = eachrow(student_information)[1]
for row in eachrow(student_information)
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
                以下是您本學期的成績一覽：
                <p>
                    $(render_table(selectquizdetail(row.StudentID)))
                </p>

                <p>
                這是您的組別報告的得分：
                    $(interscore(row.GroupID))
                評語：
                    $(render_list(internote(row.GroupID)))
                </p>

                <p>
                這是您的組員對您的評分(原始平均)：
                    $(innerscore(row.Name))
                評語：
                    $(render_list(innernote(row.Name)))
                </p>

                <p>
                學期總分 (陳建志老師的部分滿分 50)：
                $(finalscore(row.StudentID))

                </p>
                <br>
                若有任何疑問，請回信 $sender 或至科一館 S113 找助教。
            </p>
        </body>
    </html>
    """)


    recipients = []
    in_rcpt_list = false
    if do_send_email
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
end
