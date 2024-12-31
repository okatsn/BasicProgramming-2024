# README

## Rule

Go to info.typ

## Sending emails

Scripts of sending emails are not included in the DVC pipeline.
The reason for not include the process of sending email is that, this process not only depends on summarized scores but also relies on `issent.csv`. The dependency of `issent.csv` is the key problem. Saying there is a stage in DVC pipeline called `sending_quiz_score`, this stage will has the dependency of `issent.csv`, and also output `issent.csv`.
We can manage `issent.csv` by git, or set it persistent; however, both makes the workflow vulnerable to bugs and makes debugging hard since we very likely may need to test the script out of the `dvc repro`, and persistent output leads to bug if you forgot to reset the output manually (the modification in the testing phase will be persistent that `dvc repro` will run the same scripts upon the changes made in the testing phase).

Imaging a scenario: the score is the same, but I modify the `params.yaml` to send emails of only specific test, before the official run, I may test this script to send emails to my personal accounts. In this scenario, the version of `issent.csv` and the stage of sending email is separately managed, which is not robust and in fact, very buggy and make it hard to figure out what's wrong.

Another issue is that we often need some freedom to manually do something, for example, to send emails of specific students, or send emails of only specific test; which requires parametric inputs then. In this case, using `params.yaml` is not only superfluous and also a kind of a hack that beyond the scope of DVC pipeline.

In summary, DVC pipeline is not designed as an interface to run an application where the application relies on a variable that is saved in an external storage (saying `issent.csv`), and also not for doing jobs that has recursive input/output.
Although you make the use above come true by setting outs of the previous stage to be persistent with no outs of this stage, you should note that this is some sort of hacking the use of DVC pipeline.

## Update scores

Scripts of update and summarizing scores are part of dvc pipeline.

## Generate QRCodes

There are two types of sheets: 
1. The sheets that have test number for each student with the QRCode for me to submit score. (Referring: `generate_qrcode.jl`)
2. The sheets that have QRCodes to submit scores for their classmate for each student. (Referring: `generate_qrcode_group_score.jl`)


These are all managed in the dvc pipeline.
To run these stages, you have to prepare `student_information.csv` that has Number,StudentID,Name,gmail,GroupID.

See also constants in `BasicProgramming2024.jl`.