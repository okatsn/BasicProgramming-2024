#set page( // Set page: https://typst.app/docs/reference/layout/page/
  paper: "a4",
  margin: (left:1.2cm, right: 1.2cm, top: 1.5cm, bottom: 1.5cm),
  numbering: "1", // numbering the page
)

#table(
    columns: (10mm, auto, auto, auto), // or simply `3`
    gutter: 0pt, // Default space between cells
    inset: 10pt,
    align: horizon,
    table.header(
      [],
      [評分項目],
      [說明],
      [掃 QRCode 填表單],
    ), // this is optional
    // See https://typst.app/docs/reference/model/table/
    table.cell(rowspan: 3)[組間互評 (對其他組評分)],
    table.cell(rowspan: 3)[
      注意事項：
      ],
    [對 A 組評分], // FIXME: populate content via data in csv.
    [QRCode A], // FIXME: populate content via data in csv.
    [對 B 組評分], // FIXME: populate content via data in csv.
    [QRCode B], // FIXME: populate content via data in csv.
    [對 C 組評分], // FIXME: populate content via data in csv.
    [QRCode C], // FIXME: populate content via data in csv.
    [組員互評],
    table.cell(colspan:2 )[說明：對*同組*組員互評],
    [QRCode] // FIXME: populate content via data in csv.
)

