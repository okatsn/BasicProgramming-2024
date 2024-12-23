function takelast(df)
    @chain df begin
        groupby([:Name, :StudentID])
        combine(gd -> gd[argmax(gd.Time), :]) # take the row with the largest time.
    end
end
