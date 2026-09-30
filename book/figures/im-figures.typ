// イジングモデルの章の図. 講義ノート (SVG に書き出す) と予習動画のスライドで共用する.
// スライドは `#import "/statistical_mechanics_II_2026/book/figures/im-figures.typ": *` で読み込む.
// SVG は同じディレクトリの fig-*.typ から書き出す (make-figures.sh).
#import "@preview/cetz:0.4.2"

#let c-blue = rgb("#1d4ed8")
#let c-red = rgb("#b91c1c")
#let c-orange = rgb("#c2410c")
#let c-gray = rgb("#64748b")
#let c-light = rgb("#e2e8f0")

// 上向き (s = 1) か下向き (s = -1) の矢印を (x, y) に描く.
#let spin-arrow(p, s, color: black, len: 0.5, width: 1.4pt) = {
  import cetz.draw: *
  let (x, y) = p
  line((x, y - s * len / 2), (x, y + s * len / 2),
    mark: (end: "stealth", fill: color, scale: 0.7), stroke: width + color)
}

// 正方格子のイジングモデル. 中央のスピン i と, その最近接の4個を強調する.
#let ising-lattice-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let d = 1.0
  let spins = (
    (1, 1, -1, 1, 1),
    (1, -1, 1, 1, -1),
    (-1, 1, 1, -1, 1),
    (1, 1, -1, 1, 1),
    (1, -1, 1, 1, -1),
  )
  for i in range(5) {
    line((i * d, -0.4), (i * d, 4 * d + 0.4), stroke: 0.6pt + c-light)
    line((-0.4, i * d), (4 * d + 0.4, i * d), stroke: 0.6pt + c-light)
  }
  // スピン i と最近接の間のボンド
  for (dx, dy) in ((1, 0), (-1, 0), (0, 1), (0, -1)) {
    line((2 * d, 2 * d), ((2 + dx) * d, (2 + dy) * d), stroke: 2.5pt + rgb("#fdba74"))
  }
  content((2.5 * d, 2.18 * d), anchor: "south", text(size: 11pt, fill: c-orange)[$J$])
  for i in range(5) {
    for j in range(5) {
      let near = calc.abs(i - 2) + calc.abs(j - 2) == 1
      let color = if i == 2 and j == 2 { c-red } else if near { c-blue } else { black }
      spin-arrow((i * d, (4 - j) * d), spins.at(j).at(i), color: color)
    }
  }
  content((2 * d - 0.2, 2 * d - 0.25), anchor: "north-east", text(size: 11pt, fill: c-red)[$i$])
  content((5.0, 3.2), anchor: "west", text(size: 11pt, fill: c-red)[スピン $i$])
  content((5.0, 2.5), anchor: "west", text(size: 11pt, fill: c-blue)[最近接のスピン ($z = 4$ 個)])
  content((5.0, 1.8), anchor: "west", text(size: 11pt, fill: c-orange)[相互作用 $-J s_i s_j$])
})

// 平均場近似. 最近接のスピンの配置はさまざまに揺らぐ (左の3枚). 平均場近似では,
// それを平均値 m に置き換え, スピン i は一定の有効磁場を感じる (右).
#let mean-field-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let r = 0.85
  let dirs = ((1, 0), (0, 1), (-1, 0), (0, -1))
  let panel(x0, spins, avg, label) = {
    rect((x0 - 1.3, -1.3), (x0 + 1.3, 1.3), fill: rgb("#f8fafc"), stroke: 1pt + c-gray, radius: 0.15)
    for (dx, dy) in dirs {
      line((x0, 0), (x0 + r * dx, r * dy), stroke: 1pt + c-light)
    }
    for k in range(4) {
      let (dx, dy) = dirs.at(k)
      if avg {
        circle((x0 + r * dx, r * dy), radius: 0.26, fill: c-light, stroke: 1pt + c-blue)
        content((x0 + r * dx, r * dy), text(size: 10pt, fill: c-blue)[$m$])
      } else {
        spin-arrow((x0 + r * dx, r * dy), spins.at(k), color: c-blue, len: 0.42)
      }
    }
    spin-arrow((x0, 0), 1, color: c-red, len: 0.42)
    content((x0, -1.7), text(size: 10pt, fill: c-orange)[#label])
  }
  content((3.0, 1.85), text(size: 11pt)[もとの問題: 周りの配置は時々刻々変わる])
  panel(0, (1, 1, 1, 1), false, [$J sum_j s_j = 4 J$])
  panel(3.0, (1, -1, 1, 1), false, [$2 J$])
  panel(6.0, (-1, 1, -1, 1), false, [$0$])
  content((7.65, 0), text(size: 14pt)[$dots.c$])
  line((8.2, 0), (9.4, 0), mark: (end: "stealth", fill: c-red), stroke: 1.5pt + c-red)
  content((8.8, 0.35), text(size: 10pt, fill: c-red)[$s_j arrow.r m$])
  content((10.9, 1.85), text(size: 11pt)[平均場近似])
  panel(10.9, none, true, [$z J m$ (一定)])
  content((5.45, -2.55), text(size: 10pt)[周りから受ける磁場 $J sum_j s_j$ は配置ごとに違う (揺らぎ) $arrow.r$ 平均値 $z J m$ で置き換え, スピン $i$ 1個の問題にする])
})
