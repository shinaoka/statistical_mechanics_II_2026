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
        let (a, b) = if up { (0.06, 0.48) } else { (0.48, 0.06) }
        line((x, y + a), (x, y + b), mark: (end: "stealth", fill: c-red, scale: 0.7), stroke: 1.5pt + c-red)
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

// 金属の模式図: 正イオンが格子をつくり, 伝導電子はその間を自由に動く.
#let metal-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let d = 1.1
  rect((-0.6, -0.6), (4 * d + 0.6, 3 * d + 0.6), fill: rgb("#f8fafc"), stroke: 1pt + c-gray, radius: 0.15)
  for i in range(5) {
    for j in range(4) {
      circle((i * d, j * d), radius: 0.3, fill: rgb("#fed7aa"), stroke: 1pt + c-orange)
      content((i * d, j * d), text(size: 12pt, fill: c-orange, weight: "bold")[+])
    }
  }
  // 電子は格子の間に散らばる (位置は決めうち)
  let es = ((0.45, 0.6), (1.7, 0.5), (2.8, 0.65), (3.9, 0.45), (0.6, 1.7), (1.6, 1.55), (2.7, 1.75),
            (3.8, 1.6), (0.5, 2.8), (1.75, 2.7), (2.85, 2.85), (3.95, 2.7))
  for e in es {
    circle(e, radius: 0.1, fill: c-blue, stroke: none)
  }
  for (a, b) in (((1.7, 0.5), (1.65, 0.95)), ((2.85, 2.85), (3.3, 2.75)), ((0.6, 1.7), (0.5, 2.15))) {
    line(a, b, mark: (end: "stealth", fill: c-blue, scale: 0.5), stroke: 0.8pt + c-blue)
  }
  content((2 * d, -0.95), anchor: "north", text(size: 11pt)[
    #text(fill: c-orange)[●] 正イオン (格子をつくる) #h(0.6em) #text(fill: c-blue)[●] 伝導電子 (自由に動く)
  ])
})

// 白色矮星の模式図: 炭素と酸素の原子核と縮退した電子. 重力 (内向き) と電子の縮退圧 (外向き) がつり合う.
#let white-dwarf-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let r = 2.0
  circle((0, 0), radius: r, fill: rgb("#eef2ff"), stroke: 1.5pt + c-gray)
  let nuclei = (((-0.9, 0.8), [C]), ((0.4, 1.1), [O]), ((1.1, 0.1), [C]), ((-0.3, -0.2), [O]),
                ((-1.2, -0.6), [C]), ((0.6, -1.0), [C]), ((-0.4, -1.3), [O]), ((-0.2, 0.5), [C]))
  for (p, lab) in nuclei {
    circle(p, radius: 0.24, fill: rgb("#fed7aa"), stroke: 1pt + c-orange)
    content(p, text(size: 9pt, fill: c-orange, weight: "bold")[#lab])
  }
  let es = ((-0.5, 1.4), (0.9, 0.7), (-1.4, 0.2), (0.2, -0.6), (1.3, -0.6), (-0.8, -1.0), (0.1, 0.0),
            (-0.6, 0.15), (0.9, 1.4), (0.2, -1.6), (-1.6, -0.2), (1.5, 0.5), (-0.1, 1.6), (1.0, -1.4))
  for e in es { circle(e, radius: 0.08, fill: c-blue, stroke: none) }
  // 左: 重力 (内向き), 右: 電子の縮退圧 (外向き)
  for a in (150deg, 180deg, 210deg) {
    let (c, s) = (calc.cos(a), calc.sin(a))
    line((c * (r + 1.0), s * (r + 1.0)), (c * (r + 0.1), s * (r + 0.1)), mark: (end: "stealth", fill: c-gray), stroke: 1.8pt + c-gray)
  }
  for a in (-30deg, 0deg, 30deg) {
    let (c, s) = (calc.cos(a), calc.sin(a))
    line((c * (r + 0.1), s * (r + 0.1)), (c * (r + 1.0), s * (r + 1.0)), mark: (end: "stealth", fill: c-red), stroke: 1.8pt + c-red)
  }
  content((-r - 0.6, -r + 0.2), anchor: "north", text(size: 11pt, fill: c-gray)[重力\ (内向き)])
  content((r + 0.6, -r + 0.2), anchor: "north", text(size: 11pt, fill: c-red)[電子の縮退圧\ (外向き)])
  content((0, -r - 1.0), anchor: "north", text(size: 11pt)[
    #text(fill: c-orange)[●] 炭素 (C), 酸素 (O) の原子核 #h(0.6em) #text(fill: c-blue)[●] 電子
  ])
})
