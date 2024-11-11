#import "@preview/gentle-clues:1.0.0": *

// #let KEY(term) = highlight(
//   fill: rgb("f0e2a4"),
//   top-edge: "x-height",
//   extent: 1pt,
//   text(fill: color.cmyk(28%, 38%, 50%, 28%), weight: "black")[#term],
// )
// #let KEY2(term) = highlight(fill: rgb("ff99ff"), top-edge: "x-height", extent: 1pt, text(weight: "black")[#term])

// #let KEY2(term) = text(weight: "bold")[#term]
#let KEY2(term) = text()[#term]
#let KEY1(term) = text()[#term]
#let FIRE(term) = text(fill: rgb("990000"), weight: "bold", term)

#set text( // Set main text: https://typst.app/docs/reference/text/text/
  font: "New Computer Modern",
  size: 10pt
)

#set page( // Set page: https://typst.app/docs/reference/layout/page/
  paper: "a4",
  margin: (x: 1.5cm, y: 2.1cm),
  header: align(right)[
    基礎程式語言第二部分(陳建志老師)上機測驗須知 (草案)
  ],
  numbering: "1", // numbering the page
)

#set par( // Set paragraph: https://typst.app/docs/reference/layout/par/
  justify: true, // Hyphenation will be enabled for justified paragraphs
  leading: 0.52em, // The spacing between lines
)

#set heading(numbering: "1.a.") // Numbering heading: https://typst.app/docs/reference/model/heading/

// https://typst.app/docs/tutorial/advanced-styling/
#show: rest => columns(2, rest)

#place(
  top + left,
  float: true,
  clearance: 2em,
)[
  #align(left)[
    上課時間：週一 15:00-17:00

    測驗內容：詳見 @test_how

    次數與時間：共四次隨堂上機測驗。詳細時間見 @workflow。

    聯絡助教：詳見 @contact_ta
  ]
]


= 測驗與計分方式 <test_how>

- 測驗題目將從 #link("https://simplelearn.tw/python-for-beginners/")[Python for beginners (https://simplelearn.tw/python-for-beginners/)] 在指定範圍內抽選。
- 每次測驗將包含#KEY2[2個]由助教指定的測驗頁面 (@test_page) 項目；測驗分數為這兩個頁面上的分數平均。
- 上機測驗的學期成績為這四次測驗的平均；缺考將以零分下去平均，詳見 @test_leave 。

= 測驗時間、範圍與流程 <workflow>

測驗時間與範圍如下：

#table(
  columns: 3,
  [日期], [範圍 (測驗頁面編號)], [附註],
  [11/18], [Python for beginners (1) - (4)], [(4 抽 2)],
  [12/02], [Python for beginners (5) - (8)], [(4 抽 2)],
  [12/23], [Python for beginners (9) - (12)], [(4 抽 2)],
  [12/30], [Python for beginners (13) - (16)], [(4 抽 2)],
)


每次測驗為30分鐘，包含以下流程：

- 說明與分發測驗回條，上面會有：測驗頁面編號、分數欄與簽名欄 (5分鐘)
- 上機考試 (20分鐘)
- 準備與緩衝時間 (5分鐘)
- 測驗開始預設為 15：00
- 測驗結束預設為 15：30
- 若上述流程因非個人因素有所延誤，測驗結束時間將延後至總作答時間足 20分。

#info[
  - 作答完畢後，在回條上#KEY2[簽名、註記分數，再舉手請助教過去核對]。
]

#warning[
  - 作答完畢後，請務必把上述#KEY2[回條交給助教確認後，才能關閉測驗頁面]。
  - 作答完畢繳交回條後，請離開教室。#KEY1[考試期間不得在教室從事任何考試活動以外的行為] (滑手機、看書或任何紙本文件、聊天等)。
  - 若提早作答完畢#KEY2[先行離開教室者，預設 15:30 回到座位上]。
  - 違規事項與處理詳見 @test_regulation
]

#colbreak()

= 測驗規定 <test_regulation>

== 測驗中

- #KEY1[測驗中不能開啟測驗頁面 (@test_page) 以外的分頁或視窗]。以下為範例但不限於：
  - 不能使用Google、ChatGPT尋找答案
  - 測驗開始後，不能再回去課程教學頁面。
- 其他未經允許事項一律預設為不行。
- #KEY2[測驗頁面開啟後，一離座就算考試結束]。請在上機前上完廁所。
- 因緊急與不可抗力事件無法參加或完成測驗，得視情況安排補考。

== 作弊與違規 <test_cheat>

- 若發現作弊屬實，則當天之測驗分數將全部計為零分，並送學務處處理。
- 若發生#KEY1[任何違規事項將註記次數]，而且助教有權要求您當日課後至助教研究室重考。
- 設 $n$ 為學期總違規次數，小考總成績(即平均後的結果)將扣 $n times 2^n$ 分。



== 請假與補考 <test_leave>

- 因故無法參與考試，請在#KEY2[考試3天前]寄信或找助教完成請假程序。聯絡方式詳見 @contact_ta。
- 未經請假而缺席，則當次測驗計為零分。
- 除非突發、來不及反應之事件，否則#KEY2[不接受事後請假]。
- 事後請假需附證明文件。


= 附註 <ref>

== 測驗頁面 <test_page>

- 測驗頁面指 #link("https://simplelearn.tw/python-for-beginners/")[Python for beginners (https://simplelearn.tw/python-for-beginners/)] 的 1-16個課程最後的 "Python 練習" (點選 Quiz 按鈕後進入)。

= 助教與問題回報 <contact_ta>

助教是吳宗羲，你可以在科學一館 S113 找到助教，或經電子郵件聯絡 (tjvwe025q\@mozmail.com)。