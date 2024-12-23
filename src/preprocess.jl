convdatetime!(df) = @chain df begin
    transform!(:Time => ByRow(s -> replace(s, "上午" => "AM")); renamecols=false)
    transform!(:Time => ByRow(s -> replace(s, "下午" => "PM")); renamecols=false)
    transform!(:Time => ByRow(t -> DateTime(t, dateformat"yyyy/mm/dd p II:MM:SS")); renamecols=false)
end

function quizscoreprep!(df)
    @chain df begin
        transform!(
            gformheaders_quizscore...
        )
        convdatetime!
        select!(Not(r"[\u4e00-\u9fff]")) # remove all the columns with ZH characters
    end
end

function innerscoreprep!(df)
    @chain df begin
        transform!(
            gformheaders_innergroupscore...
        )
        convdatetime!
        select!(Not(r"[\u4e00-\u9fff]")) # remove all the columns with ZH characters
    end
end

function interscoreprep!(df)
    @chain df begin
        transform!(
            gformheaders_intergroupscore...
        )
        convdatetime!
        select!(Not(r"[\u4e00-\u9fff]")) # remove all the columns with ZH characters
    end
end
