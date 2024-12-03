#set page( // Set page: https://typst.app/docs/reference/layout/page/
  paper: "a4",
  margin: (left:1.2cm, right: 1.2cm, top: 1.5cm, bottom: 1.5cm),
  numbering: "1", // numbering the page
)

#let oneblock(
  name,
  id,
  link1,
  path1,
  desc1,
  link2,
  path2,
  desc2,
  link3,
  path3,
  desc3,
  link4,
  path4,
) = [

  == 評分者：#name (#id)
  *注意!*：您必須使用您在本課程登錄的 gmail 帳號登入填單
  #table(
    columns: (10mm, 3fr, 4fr, 15mm, 40mm), // or simply `3`
    gutter: 0pt, // Default space between cells
    inset: 10pt,
    align: horizon,
    table.header(
      [],
      [評分項目],
      [說明],
      [自我檢核],
      [掃 QRCode 填表單],
    ), // this is optional
    // See https://typst.app/docs/reference/model/table/
    table.cell(rowspan: 3)[組間互評],
    table.cell(rowspan: 3)[
      注意事項：

      對*其他組*的報告進行評分
      ],
    [#desc1], // FIXME: populate content via data in csv.
    [☐],
    image(path1), // FIXME: populate content via data in csv.
    [#desc2], // FIXME: populate content via data in csv.
    [☐],
    image(path2), // FIXME: populate content via data in csv.
    [#desc3], // FIXME: populate content via data in csv.
    [☐],
    image(path3), // FIXME: populate content via data in csv.
    [組員互評],
    table.cell(colspan:2 )[說明：對*同組*組員互評],
    [☐],
    image(path4) // FIXME: populate content via data in csv.
)

  - 請掃描QRCode，並自行於「自我檢核」欄位打勾。
  - 所有*表單都要填*
  - 這一份紙本*不需要*交回給助教。
  - 請務必使用您的 Gmail (會收到助教信的那個信箱) 填單，否則無效。
  - 請在 12/30 (周一) 下課前填好表單，助教感謝您。

]

#let qrcode_table = csv("data/group_qrcode_links.csv")

#let (name, id, link1, path1, desc1, link2, path2, desc2, link3, path3, desc3, link4, path4) = range(
  qrcode_table.first().len(),
)

#let removefirst(x) = {
  x.remove(0)
  return x
}

#for (n, r) in removefirst(qrcode_table.enumerate()) {
  oneblock(
    r.at(name),
    r.at(id),
    r.at(link1),
    r.at(path1),
    r.at(desc1),
    r.at(link2),
    r.at(path2),
    r.at(desc2),
    r.at(link3),
    r.at(path3),
    r.at(desc3),
    r.at(link4),
    r.at(path4),
  )
  colbreak()
}

