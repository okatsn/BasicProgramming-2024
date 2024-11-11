using JSON, OkReadGSheet, DataFrames, CSV, QRCoders, Chain
using OkReadGSheet

secrets = JSON.parsefile("local/secrets.json")

form_quiz = secrets["form_quiz"] # please load from secrets.json
sender_key = secrets["sender_key"]

student_table = CSV.read("student_information.csv", DataFrame)

quiz_link(score_A, score_B, violation_num, note, my_name, stud_ID, test_name) = "$(form_quiz)/viewform?usp=pp_url&entry.482342201=$(score_A)&entry.1809338332=$(score_B)&entry.2125071475=$(violation_num)&entry.1825598537=$(note)&entry.1529579107=$(my_name)&entry.838829525=$(stud_ID)&entry.658137221=$(test_name)"
