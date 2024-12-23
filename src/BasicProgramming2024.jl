module BasicProgramming2024

# Write your package code here.

using Chain, DataFrames, Dates
include("preprocess.jl")
export quizscoreprep!

include("takelast.jl")
export takelast

# # Constants

# Titles for test names

const all_tests = [
    "Python for beginners 1-4", # 11/18
    "Python for beginners 5-8", # 12/02
    "Python for beginners 9-12", # 12/23
    "Python for beginners 13-16", # 12/30
]

# References for Google form headers
const gformheaders_quizscore = (
    "測驗名稱" => :Test,
    "學號" => :StudentID,
    "姓名" => :Name,
    "測驗A分數" => :Score_A,
    "頁面編號A" => :QuizNum_A,
    "測驗B分數 " => :Score_B,
    "頁面編號B" => :QuizNum_B,
    "電子郵件地址" => :MyEmail,
    "違規註記" => :Violate,
    "備註" => :Note,
    "時間戳記" => :Time
)
end
