dvc checkout && dvc repro
# `dvc checkout` is essential to reset the persistent output (e.g., quiz_score.csv) before `dvc repro`.