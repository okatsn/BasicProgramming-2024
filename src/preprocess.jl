

function quizscoreprep!(df)
    @chain df begin
        transform!(
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
        transform!(:Time => ByRow(s -> replace(s, "上午" => "AM")); renamecols=false)
        transform!(:Time => ByRow(s -> replace(s, "下午" => "PM")); renamecols=false)
        transform!(:Time => ByRow(t -> DateTime(t, dateformat"yyyy/mm/dd p II:MM:SS")); renamecols=false)
        select!(Not(r"[\u4e00-\u9fff]")) # remove all the columns with ZH characters
    end
end
