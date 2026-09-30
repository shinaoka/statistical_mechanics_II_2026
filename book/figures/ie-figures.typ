// イジングモデルの厳密解の章の図. 講義ノート (SVG に書き出す) と予習動画のスライドで共用する.
// スライドは `#import "/statistical_mechanics_II_2026/book/figures/ie-figures.typ": *` で読み込む.
// SVG は同じディレクトリの fig-*.typ から書き出す (make-figures.sh).
#import "@preview/cetz:0.4.2"
#import "im-figures.typ": spin-arrow, c-blue, c-red, c-orange, c-gray, c-light

// 1次元の鎖の磁壁. 全部上向きの状態と, 途中で向きが反転した状態.
#let domain-wall-1d-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let n = 12
  let row(y, spins, title) = {
    content((-0.6, y), anchor: "east", text(size: 11pt)[#title])
    line((0, y), ((n - 1) * 0.7, y), stroke: 0.6pt + c-light)
    for i in range(n) {
      let s = spins.at(i)
      spin-arrow((i * 0.7, y), s, color: if s > 0 { c-blue } else { c-red })
    }
  }
  row(1.6, range(n).map(i => 1), [基底状態])
  row(0, range(n).map(i => if i < 5 { 1 } else { -1 }), [磁壁が1個])
  // 磁壁
  let xw = 4.5 * 0.7
  line((xw, -0.6), (xw, 0.6), stroke: (paint: c-orange, thickness: 1.8pt, dash: "dashed"))
  content((xw, -0.8), anchor: "north", text(size: 10pt, fill: c-orange)[磁壁: エネルギー $2J$ 増])
  content(((n - 1) * 0.7 + 0.4, 0), anchor: "west", text(size: 10pt)[置き場所 $N - 1$ 通り])
})

// 2次元の磁壁. 上向きの中に下向きの領域 (大きさ L) があると, 境界の長さは L に比例する.
#let droplet-2d-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let n = 9
  let d = 0.5
  let inside(i, j) = i >= 3 and i <= 6 and j >= 2 and j <= 5
  rect((3 * d - d / 2, 2 * d - d / 2), (6 * d + d / 2, 5 * d + d / 2),
    stroke: (paint: c-orange, thickness: 1.8pt, dash: "dashed"))
  for i in range(n) {
    for j in range(n - 1) {
      let s = if inside(i, j) { -1 } else { 1 }
      spin-arrow((i * d, j * d), s, color: if s > 0 { c-blue } else { c-red }, len: 0.32, width: 1.1pt)
    }
  }
  content((4.5 * d, -0.6), anchor: "north", text(size: 10pt, fill: c-orange)[境界の長さ $prop L$ $arrow.r$ エネルギー $prop J L$])
})
