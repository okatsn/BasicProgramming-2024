
#let dscp(str) = text(size: 10pt, color.cmyk(0%, 0%, 0%, 60%), str)
#let HEAD(str) = text(size: 15pt, weight: 900, str)
#let dscp8(str) = text(size: 8pt, color.cmyk(0%, 0%, 0%, 60%), str)

#set page( // Set page: https://typst.app/docs/reference/layout/page/
  paper: "a4",
  margin: (left:1.2cm, right: 1.2cm, top: 1.5cm, bottom: 1.5cm),
  numbering: "1", // numbering the page
)

#let oneblock(name, id, quiznum_A, quiznum_B, title, qrcode) = table(
  columns: (60mm, 35mm, 35mm, 20mm, 40mm),
  rows: (7mm, 7mm, 26mm),
  table.cell(colspan: 4)[#HEAD(title)], table.cell(rowspan: 3, image(qrcode)),
  [#name (#id)], [測驗A: #quiznum_A], [測驗B: #quiznum_B], [違規註記],
  dscp[(請簽名)], dscp[(請登記分數)], dscp[(請登記分數)], dscp8[(由助教填寫)],
)


#let removefirst(x) = {
  x.remove(0)
  return x
}


#for p in (
  "qrcode_Python_for_beginners_1-4.csv",
  "qrcode_Python_for_beginners_5-8.csv",
  "qrcode_Python_for_beginners_9-12.csv",
  "qrcode_Python_for_beginners_13-16.csv",
) {

  let qrcode_table = csv(p)
  let (name, id, quiznum_A, quiznum_B, title, qrcode) = range(qrcode_table.first().len())

  for (n, r) in removefirst(qrcode_table.enumerate()) {
    oneblock(r.at(name), r.at(id), r.at(quiznum_A), r.at(quiznum_B), r.at(title), r.at(qrcode))
  }

  colbreak()
}

