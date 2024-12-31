
"""
You may save something like `Set{String31}()` in CSV. When you want to take these stuff out, use `ByRow(evalmetaparse)` with `select` or `transform`.
"""
evalmetaparse(x) = eval(Meta.parse(x))
