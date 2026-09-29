// フェルミ気体の章の図. 講義ノート (SVG に書き出す) と予習動画のスライドで共用する.
// スライドは `#import "/statistical_mechanics_II_2026/book/figures/fg-figures.typ": *` で読み込む.
// SVG は同じディレクトリの fig-*.typ から書き出す (make-figures.sh).
#import "@preview/cetz:0.4.2"

#let c-blue = rgb("#1d4ed8")
#let c-red = rgb("#b91c1c")
#let c-orange = rgb("#c2410c")
#let c-gray = rgb("#64748b")

// T = 0 では, エネルギーの低い状態から順に, 1つの k に ↑ と ↓ の2個ずつ詰まる.
#let filling-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let levels = 7
  let filled = 4
  line((-0.6, -0.2), (-0.6, levels * 0.7), mark: (end: "stealth", fill: black), stroke: 1pt)
  content((-0.6, levels * 0.7 + 0.1), anchor: "south", text(size: 11pt)[エネルギー])
  for i in range(levels) {
    let y = i * 0.7
    line((0, y), (2.4, y), stroke: 1.2pt + black)
    if i < filled {
      for (x, up) in ((0.8, true), (1.6, false)) {
        circle((x, y + 0.22), radius: 0.18, fill: c-blue, stroke: none)
        let (a, b) = if up { (0.02, 0.5) } else { (0.5, 0.02) }
        line((x + 0.3, y + a), (x + 0.3, y + b), mark: (end: "stealth", fill: c-red, scale: 0.5), stroke: 1pt + c-red)
      }
    }
  }
  let yf = (filled - 1) * 0.7 + 0.62
  line((-0.2, yf), (3.0, yf), stroke: (paint: c-orange, thickness: 1.5pt, dash: "dashed"))
  content((3.1, yf), anchor: "west", text(size: 13pt, fill: c-orange)[$epsilon_"F"$])
  content((3.1, (filled + 1.2) * 0.7), anchor: "west", text(size: 11pt, fill: c-gray)[空いている])
  content((3.1, 1.0), anchor: "west", text(size: 11pt, fill: c-gray)[詰まっている])
})

// 波数空間のフェルミ球 (k_z = 0 の断面).
#let fermi-sphere-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let d = 0.45
  let r = 3.3 * d
  circle((0, 0), radius: r, fill: rgb("#dbeafe"), stroke: 1.8pt + c-blue)
  for i in range(-5, 6) {
    for j in range(-4, 5) {
      let inside = i * i + j * j <= 3.3 * 3.3
      circle((i * d, j * d), radius: if inside { 0.08 } else { 0.05 },
        fill: if inside { c-blue } else { c-gray }, stroke: none)
    }
  }
  line((-2.8, 0), (2.9, 0), mark: (end: "stealth", fill: black), stroke: 0.8pt)
  line((0, -2.2), (0, 2.3), mark: (end: "stealth", fill: black), stroke: 0.8pt)
  content((3.0, 0), anchor: "west", text(size: 13pt)[$k_x$])
  content((0, 2.4), anchor: "south", text(size: 13pt)[$k_y$])
  line((0, 0), (r * 0.8, r * 0.6), mark: (end: "stealth", fill: c-red), stroke: 1.5pt + c-red)
  content((r * 0.4 - 0.05, r * 0.3 + 0.1), anchor: "south-east", box(fill: rgb("#dbeafe"), inset: 2pt, text(size: 13pt, fill: c-red)[$k_"F"$]))
  line((r * 0.71, -r * 0.71), (2.6, -1.9), stroke: 0.8pt + c-blue)
  content((2.65, -1.9), anchor: "west", text(size: 11pt, fill: c-blue)[フェルミ面 ($epsilon_bold(k) = epsilon_"F"$)])
})
