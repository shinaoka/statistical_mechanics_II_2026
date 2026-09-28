// グランドカノニカル分布の章の図. 講義ノート (SVG に書き出す) と予習動画のスライドで共用する.
// スライドは `#import "/statistical_mechanics_II_2026/book/figures/gc-figures.typ": *` で読み込む.
// SVG は同じディレクトリの fig-*.typ から書き出す (make-figures.sh).
#import "@preview/cetz:0.4.2"

#let c-blue = rgb("#1d4ed8")
#let c-red = rgb("#b91c1c")
#let c-orange = rgb("#c2410c")
#let c-green = rgb("#15803d")
#let c-gray = rgb("#64748b")
#let c-light = rgb("#e2e8f0")
#let c-water = rgb("#93c5fd")

// 系と浴. particles: false ならエネルギーだけをやりとりする (熱浴).
#let bath-figure(particles: true) = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  rect((0, 0), (9, 5), fill: rgb("#ffedd5"), stroke: 2pt + c-orange)
  let label = if particles [熱・粒子浴 ($T$, $mu$)] else [熱浴 (温度 $T$)]
  content((4.5, 4.4), text(size: 16pt, fill: c-orange, label))
  rect((1.2, 0.8), (3.8, 3.4), fill: rgb("#eff6ff"), stroke: 2pt + c-blue)
  content((2.5, 2.1), text(size: 22pt)[系])
  let ax = 4.0
  line((ax, 2.9), (ax + 1.2, 2.9), mark: (end: "stealth", fill: c-red), stroke: 2pt + c-red)
  line((ax + 1.2, 2.4), (ax, 2.4), mark: (end: "stealth", fill: c-red), stroke: 2pt + c-red)
  content((ax + 1.4, 2.65), anchor: "west", text(size: 15pt, fill: c-red)[エネルギー])
  if particles {
    line((ax, 1.7), (ax + 1.2, 1.7), mark: (end: "stealth", fill: c-green), stroke: 2pt + c-green)
    line((ax + 1.2, 1.2), (ax, 1.2), mark: (end: "stealth", fill: c-green), stroke: 2pt + c-green)
    content((ax + 1.4, 1.45), anchor: "west", text(size: 15pt, fill: c-green)[粒子])
  }
})

// 粒子は μ の高い系から低い系へ移る.
#let mu-flow-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  rect((0, 0), (4, 3), fill: rgb("#eff6ff"), stroke: 2pt + c-blue)
  content((2, 1.5), text(size: 24pt)[$mu_1$])
  rect((8, 0), (12, 3), fill: rgb("#eff6ff"), stroke: 2pt + c-blue)
  content((10, 1.5), text(size: 24pt)[$mu_2$])
  line((4.4, 1.5), (7.6, 1.5), mark: (end: "stealth", fill: c-green), stroke: 3pt + c-green)
  content((6, 2.1), text(size: 17pt, fill: c-green)[粒子 $d N$])
})

// 形の違うプール. 水位 (μ) は同じでも, 水の量 (N) は違う.
#let pools-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let lv = 2.2
  rect((0, 0), (1.5, lv), fill: c-water, stroke: none)
  line((0, 3.2), (0, 0), (1.5, 0), (1.5, 3.2), stroke: 2.5pt + black)
  rect((3, 0), (7.5, lv), fill: c-water, stroke: none)
  line((3, 3.2), (3, 0), (7.5, 0), (7.5, 3.2), stroke: 2.5pt + black)
  line((-0.4, lv), (8.2, lv), stroke: (paint: c-red, thickness: 1.5pt, dash: "dashed"))
  content((8.3, lv), anchor: "west", text(size: 17pt, fill: c-red)[水位 $mu$])
  content((0.75, -0.6), text(size: 16pt)[水は少ない])
  content((5.25, -0.6), text(size: 16pt)[水は多い])
})

// 固体表面の吸着点と, 周りの気体.
#let adsorption-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  rect((0, 0), (8, 1), fill: c-light, stroke: 1.5pt + c-gray)
  content((4, 0.5), text(size: 16pt, fill: c-gray)[固体の表面])
  let filled = (true, false, true, false, false, true, true)
  for (j, f) in filled.enumerate() {
    let x = 0.6 + j * 1.1
    rect((x - 0.35, 1), (x + 0.35, 1.25), fill: c-gray, stroke: none)
    if f { circle((x, 1.65), radius: 0.35, fill: c-blue, stroke: none) }
  }
  for (x, y) in ((1.2, 3.8), (3.0, 4.4), (4.6, 3.6), (6.4, 4.2), (7.4, 3.3)) {
    circle((x, y), radius: 0.3, fill: rgb("#bfdbfe"), stroke: 1pt + c-blue)
  }
  content((4, 5.1), text(size: 16pt)[気体 (圧力 $P$)])
})
