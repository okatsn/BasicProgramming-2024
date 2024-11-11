using JSON, OkReadGSheet, DataFrames, CSV, QRCoders, Chain, SMTPClient
using OkReadGSheet

do_send_email = false

secrets = JSON.parsefile("local/secrets.json")

form_quiz = secrets["form_quiz"] # please load from secrets.json
sender_key = secrets["sender_key"]

student_table = CSV.read("student_information.csv", DataFrame)

quiz_link(score_A, score_B, violation_num, note, my_name, stud_ID, test_name) = "$(form_quiz)?usp=pp_url&entry.482342201=$(score_A)&entry.1809338332=$(score_B)&entry.2125071475=$(violation_num)&entry.1825598537=$(note)&entry.1529579107=$(my_name)&entry.838829525=$(stud_ID)&entry.658137221=$(test_name)"

quiz_link(my_name, stud_ID, test_name) = "$(form_quiz)?usp=pp_url&entry.1529579107=$(my_name)&entry.838829525=$(stud_ID)&entry.658137221=$(test_name)"


this_test = "11/18_上機測試_(範圍1-4)" # SETME

# row = eachrow(student_table)[2]
links = [quiz_link(row.Name, row.StudentID, this_test) for row in eachrow(student_table)]


if do_send_email
    for row in eachrow(student_table)
        if row.sent # FIXME: there is no row.sent yet
            continue
        end
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
                    親愛的<b> $(row.prefix) $(row.Name)</b> 同學您好，
                    <br>
                    您本次的成績登記如下
                    <p>
                        <ul>
                            <li>測驗A：</li>
                            <li>測驗B：</li>
                        </ul>
                    </p>
                </p>
            </body>
        </html>
        """) # TODO: the score table is not merged yet.

        recipients = []
        if do_send_email_to_participant
            push!(recipients, row.gmail)
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
end
