// 「はじめに」(授業の進め方) の図. 講義ノート (SVG に書き出す) と第1回の予習動画のスライドで共用する.
// スライドは `#import "/statistical_mechanics_II_2026/book/figures/intro-figures.typ": *` で読み込む.
#import "@preview/cetz:0.4.2"

#let c-blue = rgb("#1d4ed8")
#let c-red = rgb("#b91c1c")
#let c-orange = rgb("#c2410c")
#let c-green = rgb("#15803d")
#let c-gray = rgb("#64748b")

// 1週間の流れ: 講義 (小テスト + 解き直し + 解説) と演習 (チームで解く + 発表), 演習から翌週の小テストへ.
#let week-flow-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let u = 0.13        // 1分あたりの長さ
  let bh = 1.4
  let x0 = 3.2
  let seg(x, y, mins, fill, body, size: 15pt) = {
    rect((x, y), (x + mins * u, y + bh), fill: fill, stroke: 1.5pt + white)
    content((x + mins * u / 2, y + bh / 2), align(center, text(size: size, fill: white, body)))
  }
  // 第 k 週
  content((x0 - 0.3, 4.6 + bh / 2), anchor: "east", text(size: 17pt)[講義 (1限)])
  seg(x0, 4.6, 30, c-red, [小テスト\ 30分])
  seg(x0 + 30 * u, 4.6, 10, c-gray, [解き\ 直し], size: 12pt)
  seg(x0 + 40 * u, 4.6, 50, c-blue, [その週の内容の解説\ 50分])
  content((x0 - 0.3, 2.6 + bh / 2), anchor: "east", text(size: 17pt)[演習 (2限)])
  seg(x0, 2.6, 45, c-orange, [チームで解く\ 45分])
  seg(x0 + 45 * u, 2.6, 45, c-green, [発表と講評\ 45分])
  content((x0 + 45 * u, 6.5), text(size: 18pt, weight: "bold")[ある週の金曜日])
  // 翌週
  let x1 = x0 + 90 * u + 1.6
  content((x1 + 15 * u, 6.5), text(size: 18pt, weight: "bold")[翌週])
  seg(x1, 4.6, 30, c-red, [小テスト])
  // 演習 → 翌週の小テスト
  line((x0 + 90 * u + 0.1, 2.6 + bh / 2), (x1 + 15 * u, 2.6 + bh / 2), (x1 + 15 * u, 4.45), mark: (end: "stealth", fill: c-red), stroke: 2.5pt + c-red)
  content((x1 + 15 * u + 0.3, 2.3), anchor: "north", text(size: 16pt, fill: c-red)[同じ型の問題])
  content((x0 + 45 * u, 2.3), anchor: "north", text(size: 15pt, fill: c-gray)[4チームに分かれ, 各チームから毎週2人が発表])
})

// 予習 → 講義 → 演習 → レポート → 小テスト の循環.
#let cycle-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let Rx = 4.4
  let Ry = 2.7
  let nodes = (
    ([*予習*], [ノート・動画], c-blue),
    ([*講義*], [解説で確認], c-blue),
    ([*演習*], [解いて発表], c-orange),
    ([*レポート*], [書いて整理], c-orange),
    ([*小テスト*], [翌週に確認], c-red),
  )
  let ang(i) = 90deg - i * 72deg
  let pos(i) = (Rx * calc.cos(ang(i)), Ry * calc.sin(ang(i)))
  let bw = 3.4
  let bh = 1.5
  let gap = 0.15
  // 箱の中心から方向 (ux, uy) に進んだときの, 箱の縁までの距離
  let edge(ux, uy) = calc.min(if ux == 0 { 1e9 } else { bw / 2 / calc.abs(ux) }, if uy == 0 { 1e9 } else { bh / 2 / calc.abs(uy) }) + gap
  for i in range(5) {
    let (x0, y0) = pos(i)
    let (x1, y1) = pos(calc.rem(i + 1, 5))
    let d = calc.sqrt(calc.pow(x1 - x0, 2) + calc.pow(y1 - y0, 2))
    let (ux, uy) = ((x1 - x0) / d, (y1 - y0) / d)
    let e = edge(ux, uy)
    line((x0 + e * ux, y0 + e * uy), (x1 - e * ux, y1 - e * uy), stroke: 2.5pt + c-gray, mark: (end: "stealth", fill: c-gray))
  }
  for (i, (t, sub, col)) in nodes.enumerate() {
    let p = pos(i)
    rect((p.at(0) - bw / 2, p.at(1) - bh / 2), (p.at(0) + bw / 2, p.at(1) + bh / 2), fill: white, stroke: 2pt + col, radius: 6pt)
    content(p, align(center, text(size: 17pt)[#text(fill: col, t)\ #text(size: 15pt, sub)]))
  }
  content((0, 0), align(center, text(size: 18pt, fill: c-gray)[毎週\ くり返す]))
})
