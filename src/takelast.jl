"""
Combine groupDataframe `gdf` taking only the row in each `gdf` that has the largest `:Time`.
"""
function takelast(gdf)
    @chain gdf begin
        combine(gd -> gd[argmax(gd.Time), :]) # take the row with the largest time.
    end
end
