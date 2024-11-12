using JSON, QRCoders, CSV, DataFrames
using StatsBase


secrets = JSON.parsefile("local/secrets.json")
form_quiz = secrets["form_quiz"] # please load from secrets.json


student_information = CSV.read("student_information.csv", DataFrame)

quiz_link(score_A, score_B, violation_num, note, my_name, stud_ID, test_name) = "$(form_quiz)?usp=pp_url&entry.482342201=$(score_A)&entry.1809338332=$(score_B)&entry.2125071475=$(violation_num)&entry.1825598537=$(note)&entry.1529579107=$(my_name)&entry.838829525=$(stud_ID)&entry.658137221=$(test_name)"

quiz_link(my_name, stud_ID, test_name, quiznum_A, quiznum_B) = "$(form_quiz)?usp=pp_url&entry.1529579107=$(my_name)&entry.838829525=$(stud_ID)&entry.658137221=$(test_name)&entry.1632268405=$(quiznum_A)&entry.1132409593=$(quiznum_B)"


# # Generate QRCode


all_tests = [
    "Python for beginners 1-4", # 11/18
    "Python for beginners 5-8", # 12/02
    "Python for beginners 9-12", # 12/23
    "Python for beginners 13-16", # 12/30
]
# this_test = all_tests[1]
for this_test0 in all_tests
    this_test = replace(this_test0, " " => "_")
    # The QRCode/QuizNum table for `this_test`.
    qrcode_table = DataFrame()

    # row = eachrow(student_information)[1]
    for row in eachrow(student_information)
        # Shuffle the test number on the level of each student

        two_numbers = parse.(Int, split(match(r"\d+-\d+", this_test).match, "-"))
        picked_two = sample(range(two_numbers...), 2, replace=false) |> sort

        link = quiz_link(row.Name, row.StudentID, this_test, picked_two[1], picked_two[2])

        fdir = "img/QRCode/$this_test"
        mkpath(fdir)

        fpath = "$fdir/QR_$(row.StudentID).png"

        exportqrcode(link, fpath)

        dfi = DataFrame(
            :Name => row.Name,
            :StudentID => row.StudentID,
            :QuizNum_A => picked_two[1],
            :QuizNum_B => picked_two[2],
            :Test => this_test0,
            :QRCode => fpath
        )
        append!(qrcode_table, dfi)
    end
    CSV.write("data/QRCode/qrcode_$this_test.csv", qrcode_table)

end
