using JSON, OkReadGSheet, DataFrames, CSV, QRCoders, Chain, SMTPClient, HypertextLiteral
using Dates
using OkReadGSheet

do_send_email = false

secrets = JSON.parsefile("local/secrets.json")

score_quiz = @chain readgsheet(secrets["score_quiz"]) begin
    transform!(
        "測驗名稱" => :Test,
        "學號" => :StudentID,
        "姓名" => :Name,
        "測驗A" => :Score_A,
        "測驗B" => :Score_B,
        "電子郵件地址" => :MyEmail,
        "違規註記" => :Violate,
        "備註" => :Note,
        "時間戳記" => :Time
    )
    transform!(:Time => ByRow(s -> replace(s, "上午" => "AM")); renamecols=false)
    transform!(:Time => ByRow(s -> replace(s, "下午" => "PM")); renamecols=false)
    transform!(:Time => ByRow(t -> DateTime(t, dateformat"yyyy/mm/dd p II:MM:SS")); renamecols=false)
    select(Not(r"[\u4e00-\u9fff]")) # remove all the columns with ZH characters
    # filter!()
    insertcols!(:sent => false)
end



form_quiz = secrets["form_quiz"] # please load from secrets.json
sender_key = secrets["sender_key"]
sender = secrets["sender"]

student_information = CSV.read("student_information.csv", DataFrame)
contact = Dict(student_information.StudentID .=> student_information.gmail)


quiz_link(score_A, score_B, violation_num, note, my_name, stud_ID, test_name) = "$(form_quiz)?usp=pp_url&entry.482342201=$(score_A)&entry.1809338332=$(score_B)&entry.2125071475=$(violation_num)&entry.1825598537=$(note)&entry.1529579107=$(my_name)&entry.838829525=$(stud_ID)&entry.658137221=$(test_name)"

quiz_link(my_name, stud_ID, test_name) = "$(form_quiz)?usp=pp_url&entry.1529579107=$(my_name)&entry.838829525=$(stud_ID)&entry.658137221=$(test_name)"


this_test = "11/18_上機測試_(範圍1-4)" # SETME

links = [quiz_link(row.Name, row.StudentID, this_test) for row in eachrow(student_information)]

# row = eachrow(score_quiz)[1]
url = "smtps://smtp.gmail.com:465"
from = "<$sender>"

opt = SendOptions(
    isSSL=true,
    username=sender,
    passwd=sender_key,
)

for row in eachrow(score_quiz)
    if row.sent
        continue
    end
    subject = replace(row.Test, "_" => " ") * " 成績摘要"
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
                <br>
                若有任何疑問，請回信 $sender 或至科一館 S113 找助教。
            </p>
        </body>
    </html>
    """)

    recipients = []
    if do_send_email
        push!(recipients, contact[row.StudentID])
    end

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
    row.sent = true
end
