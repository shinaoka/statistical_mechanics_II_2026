// 同種粒子の章の図. 講義ノート (SVG に書き出す) と予習動画のスライドで共用する.
// スライドは `#import "/statistical_mechanics_II_2026/book/figures/ip-figures.typ": *` で読み込む.
// SVG は同じディレクトリの fig-*.typ から書き出す (make-figures.sh).
#import "@preview/cetz:0.4.2"

#let c-blue = rgb("#1d4ed8")
#let c-red = rgb("#b91c1c")
#let c-orange = rgb("#c2410c")
#let c-green = rgb("#15803d")
#let c-gray = rgb("#64748b")
#let c-light = rgb("#e2e8f0")

// 波数空間の格子点 (k_x, k_y 平面の断面). 格子点1つが1粒子状態1つ.
#let k-lattice-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let d = 0.55
  let r = 3.4 * d
  circle((0, 0), radius: r, fill: rgb("#eff6ff"), stroke: 1.5pt + c-blue)
  rect((2 * d - d / 2, -3 * d - d / 2), (2 * d + d / 2, -3 * d + d / 2),
    fill: rgb("#fde68a"), stroke: 1pt + c-orange)
  for i in range(-5, 6) {
    for j in range(-4, 5) {
      circle((i * d, j * d), radius: 0.06, fill: black, stroke: none)
    }
  }
  line((-3.3, 0), (3.4, 0), mark: (end: "stealth", fill: black), stroke: 0.8pt)
  line((0, -2.6), (0, 2.7), mark: (end: "stealth", fill: black), stroke: 0.8pt)
  content((3.5, 0), anchor: "west", text(size: 14pt)[$k_x$])
  content((0, 2.8), anchor: "south", text(size: 14pt)[$k_y$])
  // 間隔
  line((-5 * d, -4 * d - 0.35), (-4 * d, -4 * d - 0.35), mark: (start: "stealth", end: "stealth", fill: c-red, scale: 0.6), stroke: 1pt + c-red)
  content((-4.5 * d, -4 * d - 0.45), anchor: "north", text(size: 11pt, fill: c-red)[$2 pi \/ L$])
  // 1つの状態が占める体積
  line((2 * d + d / 2, -3 * d), (3.8, -2.3), stroke: 0.8pt + c-orange)
  content((3.85, -2.3), anchor: "west", text(size: 11pt, fill: c-orange)[1つの状態が占める体積 $(2 pi \/ L)^3$])
  // ε ≤ k_B T の球
  line((r * 0.71, r * 0.71), (3.3, 2.3), stroke: 0.8pt + c-blue)
  content((3.35, 2.3), anchor: "west", text(size: 11pt, fill: c-blue)[$epsilon_bold(k) <= k_"B" T$ の球 (半径 $k_T$)])
})

// 同種粒子の入れ替え. 2回入れ替えると元に戻る.
#let exchange-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let panel(x0, left, right, label) = {
    rect((x0, 0), (x0 + 3, 2.2), fill: rgb("#f8fafc"), stroke: 1pt + c-gray, radius: 0.15)
    circle((x0 + 0.8, 1.2), radius: 0.32, fill: c-light, stroke: 1pt + c-gray)
    circle((x0 + 2.2, 1.2), radius: 0.32, fill: c-light, stroke: 1pt + c-gray)
    content((x0 + 0.8, 1.2), text(size: 11pt)[#left])
    content((x0 + 2.2, 1.2), text(size: 11pt)[#right])
    content((x0 + 0.8, 0.5), text(size: 10pt, fill: c-gray)[$bold(r)_1$])
    content((x0 + 2.2, 0.5), text(size: 10pt, fill: c-gray)[$bold(r)_2$])
    content((x0 + 1.5, -0.45), text(size: 13pt)[#label])
  }
  panel(0, [1], [2], $Psi(bold(r)_1, bold(r)_2)$)
  panel(4.6, [2], [1], $Psi(bold(r)_2, bold(r)_1) = lambda Psi(bold(r)_1, bold(r)_2)$)
  panel(9.2, [1], [2], $lambda^2 Psi(bold(r)_1, bold(r)_2)$)
  for x0 in (3.1, 7.7) {
    line((x0, 1.2), (x0 + 1.4, 1.2), mark: (end: "stealth", fill: c-red), stroke: 1.5pt + c-red)
    content((x0 + 0.7, 1.55), text(size: 11pt, fill: c-red)[入れ替え])
  }
  content((6.1, -1.25), text(size: 13pt)[元の状態と同じなので $lambda^2 = 1$, つまり $lambda = plus.minus 1$])
})

// 2個の粒子を2つの状態 a, b に入れる方法.
#let two-state-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let w = 1.7
  // 1つの配置. occ-a, occ-b は各状態の粒子のラベル (none なら番号なし).
  let config(x0, y0, occ-a, occ-b, color) = {
    for (lv, occ) in ((0, occ-a), (1, occ-b)) {
      let y = y0 + lv * 0.8
      line((x0, y), (x0 + w - 0.3, y), stroke: 1.2pt + black)
      let n = occ.len()
      for (i, lab) in occ.enumerate() {
        let x = x0 + (w - 0.3) / 2 + (i - (n - 1) / 2) * 0.5
        circle((x, y + 0.24), radius: 0.22, fill: color, stroke: none)
        if lab != none { content((x, y + 0.24), text(size: 9pt, fill: white)[#lab]) }
      }
    }
  }
  let rows = (
    ([区別できる粒子], 4, c-gray, ((([1], [2]), ()), (([1],), ([2],)), (([2],), ([1],)), ((), ([1], [2])))),
    ([ボーズ粒子], 3, c-blue, (((none, none), ()), ((none,), (none,)), ((), (none, none)))),
    ([フェルミ粒子], 1, c-red, (((none,), (none,)),)),
  )
  for (r, (name, count, color, cfgs)) in rows.enumerate() {
    let y0 = -r * 1.9
    content((0, y0 + 0.5), anchor: "east", text(size: 12pt)[#name])
    for (j, (oa, ob)) in cfgs.enumerate() {
      config(0.4 + j * w, y0, oa, ob, color)
    }
    content((0.4 + 4 * w + 0.3, y0 + 0.5), anchor: "west", text(size: 12pt)[#count 通り])
  }
  content((0.4 + 0.2, 1.35), anchor: "east", text(size: 10pt, fill: c-gray)[b])
  content((0.4 + 0.2, 0.55), anchor: "east", text(size: 10pt, fill: c-gray)[a])
})

// 占有数表示. 各1粒子状態に何個いるかだけで, 多粒子の状態が決まる.
#let occupation-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let ladder(x0, occ, color, title) = {
    content((x0 + 1.4, 4.6), text(size: 13pt)[#title])
    for (i, n) in occ.enumerate() {
      let y = i * 0.9
      line((x0, y), (x0 + 2.8, y), stroke: 1.2pt + black)
      for m in range(n) {
        circle((x0 + 1.4 + (m - (n - 1) / 2) * 0.5, y + 0.24), radius: 0.2, fill: color, stroke: none)
      }
      content((x0 + 3.0, y + 0.1), anchor: "west", text(size: 11pt)[$n_#(i + 1) = #n$])
    }
  }
  line((-0.9, -0.2), (-0.9, 4.2), mark: (end: "stealth", fill: black), stroke: 1pt)
  content((-0.9, 4.3), anchor: "south", text(size: 11pt)[エネルギー])
  ladder(0, (3, 1, 0, 2, 0), c-blue, [ボーズ粒子])
  ladder(5.2, (1, 1, 0, 1, 0), c-red, [フェルミ粒子])
  content((1.4, -0.7), text(size: 11pt)[$n_bold(k) = 0, 1, 2, dots$])
  content((6.6, -0.7), text(size: 11pt)[$n_bold(k) = 0, 1$])
})

// 粒子の間隔と熱的ド・ブロイ波長. 波が重なると量子効果が現れる.
#let overlap-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let wave = c-blue.transparentize(75%)
  let box(x0, pts, rad, label) = {
    rect((x0, 0), (x0 + 4, 4), stroke: 1.5pt + black)
    for (x, y) in pts {
      circle((x0 + x, y), radius: rad, fill: wave, stroke: 0.6pt + c-blue.transparentize(40%))
      circle((x0 + x, y), radius: 0.07, fill: c-blue, stroke: none)
    }
    content((x0 + 2, -0.75), align(center, text(size: 12pt)[#label]))
  }
  box(0, ((0.8, 0.9), (2.9, 0.7), (1.6, 2.4), (3.3, 2.6), (0.7, 3.3), (2.4, 3.5)), 0.28,
    [$n lambda^3 << 1$ \ 古典的な扱いでよい])
  box(6, ((0.5, 0.6), (1.4, 0.5), (2.4, 0.7), (3.4, 0.5), (0.8, 1.5), (1.9, 1.4), (2.9, 1.6),
    (0.4, 2.4), (1.4, 2.4), (2.4, 2.5), (3.5, 2.3), (0.9, 3.4), (1.9, 3.3), (3.0, 3.4)), 0.6,
    [$n lambda^3 gt.tilde 1$ \ 量子効果が現れる])
  // 左の箱に λ と間隔を書き込む
  line((1.6 - 0.28, 2.4), (1.6 + 0.28, 2.4), mark: (start: "stealth", end: "stealth", fill: c-red, scale: 0.5), stroke: 0.8pt + c-red)
  content((1.6, 2.0), text(size: 10pt, fill: c-red)[$lambda$])
  line((0.8, 0.9), (2.9, 0.7), stroke: (paint: c-green, thickness: 0.8pt, dash: "dashed"))
  content((1.85, 1.15), text(size: 10pt, fill: c-green)[$n^(-1\/3)$])
})
