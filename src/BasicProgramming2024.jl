module BasicProgramming2024

# Write your package code here.

using Chain, DataFrames, Dates
include("preprocess.jl")
export quizscoreprep!, innerscoreprep!, interscoreprep!

include("takelast.jl")
export takelast

include("parsemeta.jl")
export evalmetaparse

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

const gformheaders_innergroupscore = (
    "時間戳記" => :Time,
    "電子郵件地址" => :ReplierEmail,
    "我的組員1" => :Member_1,
    "組員1的表現" => :Score_1,
    "我的組員2" => :Member_2,
    "組員2的表現" => :Score_2,
    "我的組員3" => :Member_3,
    "組員3的表現" => :Score_3,
    "附註" => :Note,
)

const gformheaders_intergroupscore = (
    "時間戳記" => :Time,
    "電子郵件地址" => :ReplierEmail,
    "報告組別" => :Group,
    "報告與內容綜合表現" => :Score,
    "附註" => :Note,
)

const inner_score_weight = 1.0 # Max 10 * 1.0
const inter_score_weight = 0.5 # Max 10 * 0.5
const quiz_score_weight = 0.3 # Max 100 * 0.3
const plan_score_weight = 1.0 # Max 5 * 1.0
end
