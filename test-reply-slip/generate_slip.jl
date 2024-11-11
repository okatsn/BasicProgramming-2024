using JSON, OkReadGSheet, DataFrames, CSV, QRCoders, Chain
using OkReadGSheet

secrets = JSON.parsefile("local/secrets.json")

form_quiz = secrets["form_quiz"] # please load from secrets.json
sender_key = secrets["sender_key"]

student_table = CSV.read("student_information.csv", DataFrame)

quiz_link(score_A, score_B, violation_num, note, my_name, stud_ID, test_name) = "$(form_quiz)?usp=pp_url&entry.482342201=$(score_A)&entry.1809338332=$(score_B)&entry.2125071475=$(violation_num)&entry.1825598537=$(note)&entry.1529579107=$(my_name)&entry.838829525=$(stud_ID)&entry.658137221=$(test_name)"

quiz_link(my_name, stud_ID, test_name) = "$(form_quiz)?usp=pp_url&entry.1529579107=$(my_name)&entry.838829525=$(stud_ID)&entry.658137221=$(test_name)"


this_test = "11/18 上機測試 (範圍 1-4)"

# row = eachrow(student_table)[2]
links = [quiz_link(row.Name, row.StudentID, this_test) for row in eachrow(student_table)]
