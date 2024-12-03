#set page( // Set page: https://typst.app/docs/reference/layout/page/
  paper: "a4",
  margin: (left:1.2cm, right: 1.2cm, top: 1.5cm, bottom: 1.5cm),
  numbering: "1", // numbering the page
)

#let oneblock() = [

  == 評分者：XXX
  *注意!*：您必須使用您在本課程登錄的 gmail 帳號登入填單
  #table(
    columns: (10mm, 1fr, 1fr, 15mm, 40mm), // or simply `3`
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
    [對 A 組評分], // FIXME: populate content via data in csv.
    [☐],
    [QRCode A], // FIXME: populate content via data in csv.
    [對 B 組評分], // FIXME: populate content via data in csv.
    [☐],
    [QRCode B], // FIXME: populate content via data in csv.
    [對 C 組評分], // FIXME: populate content via data in csv.
    [☐],
    [QRCode C], // FIXME: populate content via data in csv.
    [組員互評],
    table.cell(colspan:2 )[說明：對*同組*組員互評],
    [☐],
    [QRCode] // FIXME: populate content via data in csv.
)

  - 請掃描QRCode，並自行於「自我檢核」欄位打勾。
  - 所有*表單都要填*
  - 這一份紙本*不需要*交回給助教。
  - 請務必使用您的 Gmail (會收到助教信的那個信箱) 填單，否則無效。
  - 若需修改填答結果，請掃描相同的QRCode 再重複填一次即可。

]

#for n in (1, 2, 3, 4, 5) {
  oneblock()
}

