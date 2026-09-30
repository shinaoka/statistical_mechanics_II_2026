// 相転移と自発的対称性の破れの図. 講義ノート (SVG に書き出す) と予習動画のスライドで共用する.
// スライドは `#import "/statistical_mechanics_II_2026/book/figures/pt-figures.typ": *` で読み込む.
// SVG は同じディレクトリの fig-*.typ から書き出す (make-figures.sh).
#import "@preview/cetz:0.4.2"
#import "im-figures.typ": spin-arrow, c-blue, c-red, c-orange, c-gray, c-light

// 人のアイコン (頭と胴体).
#let person(p, color) = {
  import cetz.draw: *
  let (x, y) = p
  circle((x, y + 0.13), radius: 0.09, fill: color, stroke: none)
  arc((x - 0.15, y - 0.12), start: 180deg, stop: 0deg, radius: 0.15, mode: "CLOSE", fill: color, stroke: none)
}

// 意見の同調. 同調しなければほぼ半々, 同調すればどちらかに偏る.
#let opinion-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let nx = 7
  let ny = 5
  let d = 0.5
  // 0: 賛成 (青), 1: 反対 (赤). 決まったパターンで並べる.
  let mixed(i, j) = calc.rem(i * 5 + j * 3 + calc.rem(i * j, 4), 7) < 3
  let few(i, j) = (i, j) in ((1, 3), (5, 1), (3, 0), (6, 4))
  let panel(x0, title, sub, is-red) = {
    rect((x0 - 0.35, -0.4), (x0 + (nx - 1) * d + 0.35, (ny - 1) * d + 0.45),
      fill: rgb("#f8fafc"), stroke: 0.8pt + c-gray, radius: 0.1)
    content((x0 + (nx - 1) * d / 2, (ny - 1) * d + 0.85), text(size: 11pt)[#title])
    content((x0 + (nx - 1) * d / 2, -0.8), text(size: 10pt, fill: c-gray)[#sub])
    for i in range(nx) {
      for j in range(ny) {
        person((x0 + i * d, j * d), if is-red(i, j) { c-red } else { c-blue })
      }
    }
  }
  panel(0, [同調しない], [賛成と反対がほぼ半々], mixed)
  panel(4.3, [同調する], [賛成に偏る], few)
  panel(8.6, [同調する], [反対に偏る], (i, j) => not few(i, j))
  content((7.3, -1.45), text(size: 10pt)[賛成 (青) と反対 (赤) は対等. どちらに偏るかは, ちょっとしたきっかけで決まる.])
})

// 液体と固体. 上: ある瞬間の原子の配置. 下: 熱平衡で平均した密度 <ρ(x)> (y 方向にも平均).
#let liquid-solid-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let liquid = ((1.29, 1.83), (1.90, 2.01), (3.08, 0.40), (0.26, 2.71), (1.39, 0.90), (4.78, 1.61), (4.05, 1.63), (3.12, 2.80), (2.61, 2.42), (1.59, 0.29), (2.02, 2.60), (4.24, 0.49), (0.83, 0.85), (3.08, 1.10), (2.53, 1.36), (4.14, 3.17), (2.09, 0.65), (2.52, 3.20), (1.64, 3.08), (3.16, 1.99), (0.29, 2.05), (0.30, 0.38), (1.87, 1.14), (3.75, 0.28), (3.90, 0.92), (2.64, 0.77), (4.36, 2.28), (0.99, 2.58), (4.68, 2.76), (0.53, 1.47), (3.65, 3.00), (0.86, 3.17), (3.75, 2.47), (4.49, 1.10), (0.98, 0.31), (0.83, 2.07), (4.79, 0.63), (2.42, 1.90), (0.26, 1.02), (3.53, 1.40), (1.50, 2.35), (2.46, 0.26), (1.07, 1.32))
  let a = 0.72
  let W = 5.0
  let H = 3.4
  let box(x0, title) = {
    rect((x0, 0), (x0 + W, H), fill: rgb("#f8fafc"), stroke: 0.8pt + c-gray)
    content((x0 + W / 2, H + 0.4), text(size: 12pt)[#title])
  }
  let atom(p) = circle(p, radius: 0.2, fill: rgb("#93c5fd"), stroke: 0.8pt + c-blue)
  // 液体
  box(0, [液体 (ある瞬間の配置)])
  for (x, y) in liquid { atom((x, y)) }
  // 固体
  let x1 = 6.2
  box(x1, [固体 (ある瞬間の配置)])
  let xs = range(7).map(i => x1 + 0.34 + i * a)
  // ある瞬間には, 原子は格子点のまわりで少しずれている
  for (i, x) in xs.enumerate() {
    for j in range(5) {
      let dx = 0.07 * calc.sin(12.9898 * i + 78.233 * j)
      let dy = 0.07 * calc.cos(39.346 * i + 11.135 * j)
      atom((x + dx, 0.3 + j * a + dy))
    }
  }
  // 平均の密度
  let y0 = -2.6
  let hgt = 1.3
  for x0 in (0, x1) {
    line((x0, y0), (x0 + W + 0.2, y0), mark: (end: "stealth", fill: black, scale: 0.6), stroke: 0.8pt)
    line((x0, y0), (x0, y0 + hgt + 0.3), mark: (end: "stealth", fill: black, scale: 0.6), stroke: 0.8pt)
    content((x0 + W + 0.3, y0), anchor: "west", text(size: 10pt)[$x$])
    content((x0 - 0.1, y0 + hgt + 0.3), anchor: "east", text(size: 10pt)[$chevron.l rho(x) chevron.r$])
  }
  content(((x1 + W) / 2, y0 + hgt + 0.75), text(size: 11pt)[熱平衡で平均した密度 $chevron.l rho(x) chevron.r$ ($y$ 方向にも平均)])
  line((0, y0 + 0.5), (W, y0 + 0.5), stroke: 1.8pt + c-blue)
  let pts = range(201).map(k => {
    let x = x1 + k * W / 200
    let r = xs.map(c => calc.exp(-calc.pow((x - c) / 0.09, 2))).sum()
    (x, y0 + 0.05 + hgt * 0.95 * r)
  })
  line(..pts, stroke: 1.8pt + c-blue)
  // 平行移動の矢印
  line((xs.at(2), y0 - 0.35), (xs.at(3), y0 - 0.35), mark: (start: "stealth", end: "stealth", fill: c-orange, scale: 0.5), stroke: 1.2pt + c-orange)
  content(((xs.at(2) + xs.at(3)) / 2, y0 - 0.5), anchor: "north", text(size: 10pt, fill: c-orange)[$a$])
  content((W / 2, y0 - 1.1), text(size: 10pt)[どれだけずらしても同じ])
  content((x1 + W / 2, y0 - 1.1), text(size: 10pt)[格子の間隔 $a$ の整数倍ずらしたときだけ同じ])
})

// 有限の系での反転. 上向きの状態と下向きの状態の間に, 系の大きさ N に比例する障壁がある.
// 山の頂上は, 上向きと下向きがほぼ半々に混じった状態.
#let flip-barrier-figure() = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  // F(m) = -2 m^2 + m^4 を横に 2.2 倍, 縦に 1.3 倍して描く
  let f(m) = 1.3 * (-2 * m * m + m * m * m * m)
  let pts = range(121).map(k => { let m = -1.5 + k * 3.0 / 120; (2.2 * m, f(m)) })
  line((-3.8, 0), (3.8, 0), mark: (end: "stealth", fill: black, scale: 0.6), stroke: 0.8pt)
  content((3.9, 0), anchor: "west", text(size: 11pt)[磁化])
  line((-3.8, -1.8), (-3.8, 1.9), mark: (end: "stealth", fill: black, scale: 0.6), stroke: 0.8pt)
  content((-3.7, 1.9), anchor: "west", text(size: 11pt)[自由エネルギー])
  line(..pts, stroke: 1.8pt + c-blue)
  // 3つの状態. 矢印の向きの並び (1 が上向き).
  let block(cx, cy, ss) = {
    for (k, s) in ss.enumerate() {
      let i = calc.rem(k, 4)
      let j = calc.quo(k, 4)
      spin-arrow((cx - 0.54 + i * 0.36, cy + 0.25 - j * 0.5), s, color: if s > 0 { c-blue } else { c-red }, len: 0.36, width: 1.1pt)
    }
  }
  block(-2.2, -3.0, (1,) * 8)
  block(2.2, -3.0, (-1,) * 8)
  block(0, 0.75, (1, -1, 1, 1, -1, -1, 1, -1))
  content((-2.2, -3.75), text(size: 10pt)[上向きにそろった状態])
  content((2.2, -3.75), text(size: 10pt)[下向きにそろった状態])
  content((0, 1.35), anchor: "south", text(size: 10pt)[山の頂上: 上と下がほぼ半々])
  // 障壁
  line((-2.2, f(1)), (2.2, f(1)), stroke: (paint: c-gray, dash: "dotted"))
  line((0, f(1) + 0.05), (0, -0.05), mark: (start: "stealth", end: "stealth", fill: c-orange, scale: 0.5), stroke: 1.2pt + c-orange)
  content((0, f(1) - 0.08), anchor: "north", text(size: 10pt, fill: c-orange)[$Delta F = O(N)$])
  // 反転の矢印
  bezier((-1.4, -2.55), (1.4, -2.55), (0, -2.15), mark: (end: "stealth", fill: c-gray, scale: 0.6), stroke: (paint: c-gray, dash: "dashed"))
  content((0, -2.5), anchor: "north", text(size: 9pt, fill: c-gray)[反転の時間\ $prop e^(Delta F slash k_upright(B) T)$])
})
