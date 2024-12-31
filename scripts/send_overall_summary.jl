using JSON, OkReadGSheet, DataFrames, CSV, Chain
using Dates
using OkReadGSheet
using BasicProgramming2024
using Statistics
using OkHypertextTools

do_send_email = false
student_information = CSV.read("student_information.csv", DataFrame)

note_inner = @chain CSV.read("data/innergroup_with_note.csv", DataFrame) begin
    dropmissing(:Note)
    groupby(:Name)
    combine(:Note => (x -> join(x, "\n- ")) => :note_summary)
end
innernote(name) = Dict(note_inner.Name .=> note_inner.note_summary)[name]


note_inter = @chain CSV.read("data/intergroup_with_note.csv", DataFrame) begin
    dropmissing(:Note)
    groupby(:Group)
    combine(:Note => (x -> join(x, "\n- ")) => :note_summary)
end
internote(gid) = Dict(note_inter.Group .=> note_inter.note_summary)[gid]


score_inter = CSV.read("data/intergroup_score.csv", DataFrame)
interscore(gid) = Dict(score_inter.GroupID .=> score_inter.score_mean)[gid]

score_inner = CSV.read("data/innergroup_score.csv", DataFrame)
innerscore(name) = Dict(score_inner.Name .=> score_inner.score_mean)[name]

score_quiz = CSV.read("data/quiz_score.csv", DataFrame)
quizscore(test, sid) = groupby(score_quiz, [:Test, :StudentID])[(Test=test, StudentID=sid)]
quizdetail(sid) = groupby(score_quiz, [:StudentID])[(; StudentID=sid)]

# quizscore("Python_for_beginners_13-16", 110605002)
# quizdetail(110605002) |> render_table
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
                    $(render_table(quizdetail(row.StudentID)))
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
end
