#let qrcode_table = csv("qrcode_Python_for_beginners_1-4.csv")
#let (name, id, quiznum_A, quiznum_B, title, qrcode) = range(qrcode_table.first().len())


#set page( // Set page: https://typst.app/docs/reference/layout/page/
  paper: "a4",
  margin: (left:1.5cm, right: 1.5cm, top: 2cm, bottom: 2cm),
  numbering: "1", // numbering the page
)

#let oneblock(name, id, quiznum_A, quiznum_B, title, qrcode) = grid(
  columns: (60mm, 35mm, 35mm, 20mm, 40mm),
  rows: (7mm, 15mm, 20mm),
  gutter: 5pt
)

#for (n, r) in qrcode_table.enumerate() {
  oneblock(r.at(name), r.at(id), r.at(quiznum_A), r.at(quiznum_B), r.at(title), r.at(qrcode))
}