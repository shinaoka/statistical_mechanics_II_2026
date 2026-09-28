// 化学ポテンシャルを水位にたとえる図.
// 同じプール (系) の水位を合わせる2つの方法を上下に並べる.
// (a) 孤立したプールに水を直接出し入れする (N を決める, カノニカル).
// (b) プールを水路で巨大な貯水池につなぎ, 貯水池の水位を上げ下げして間接的に合わせる (μ を決める, グランドカノニカル).
#import "@preview/cetz:0.4.2"
#set page(width: auto, height: auto, margin: 0pt)
#set text(lang: "ja", font: ("Hiragino Sans",), size: 11pt)

#let wall = (paint: rgb("#333333"), thickness: 2pt)
#let water = rgb("#9cc3e6")
#let accent = rgb("#b03a2e")
#let arrow-stroke = (paint: accent, thickness: 1.6pt)
#let arrow-mark = (start: ">", end: ">", fill: accent)

// 寸法 (cm)
#let H = 3.0        // プールの壁の高さ
#let L = 1.9        // 水位
#let pw = 2.2       // プールの幅 (a と b で同じ)
#let rw = 7.0       // 貯水池の幅
#let rh = 3.6       // 貯水池の壁の高さ
#let gap = 1.4      // プールと貯水池の間 (管の長さ)
#let t0 = 0.25      // 管の下の高さ
#let t1 = 0.65      // 管の上の高さ
#let row = 5.2      // (a) と (b) の縦の間隔

// プール (x = 0 から pw). piped: true なら右の壁の下に管の口を開ける.
#let pool(y0, piped: false) = {
  import cetz.draw: *
  rect((0, y0), (pw, y0 + L), fill: water, stroke: none)
  if piped {
    line((pw, y0 + t0), (pw, y0), (0, y0), (0, y0 + H), stroke: wall)
    line((pw, y0 + t1), (pw, y0 + H), stroke: wall)
  } else {
    line((0, y0 + H), (0, y0), (pw, y0), (pw, y0 + H), stroke: wall)
  }
  content((pw / 2, y0 + L / 2), align(center)[プール \ (系)])
}

#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  // ---------- (a) 孤立したプール ----------
  let ya = row
  pool(ya)
  line((pw / 2, ya + H + 0.9), (pw / 2, ya + L + 0.15), stroke: arrow-stroke, mark: arrow-mark)
  content((pw / 2 + 0.3, ya + H + 0.6), anchor: "west", text(fill: accent)[水を直接出し入れする])
  content((pw + 1.2, ya + L / 2 + 0.2), anchor: "west", box(width: 7.5cm)[
    *(a) カノニカル: 水の量 $N$ を決める* \
    孤立したプールに, 水を直接入れたり抜いたりして水位を合わせる.
  ])

  // ---------- (b) 同じプールを巨大な貯水池につなぐ ----------
  let yb = 0
  let rx = pw + gap              // 貯水池の左の壁
  pool(yb, piped: true)
  // 管 (水で満ちている)
  rect((pw, yb + t0), (rx, yb + t1), fill: water, stroke: none)
  line((pw, yb + t0), (rx, yb + t0), stroke: wall)
  line((pw, yb + t1), (rx, yb + t1), stroke: wall)
  content((pw + gap / 2, yb + t1 + 0.1), anchor: "south", text(size: 9pt)[水路])
  // 貯水池
  rect((rx, yb), (rx + rw, yb + L), fill: water, stroke: none)
  line((rx, yb + t1), (rx, yb + rh), stroke: wall)
  line((rx, yb + t0), (rx, yb), (rx + rw, yb), (rx + rw, yb + rh), stroke: wall)
  content((rx + rw / 2 + 1.0, yb + L / 2), [巨大な貯水池 (熱・粒子浴)])
  // 貯水池の水位を上げ下げする矢印
  line((rx + 1.3, yb + L - 0.7), (rx + 1.3, yb + L + 0.7), stroke: arrow-stroke, mark: arrow-mark)
  content((rx + 1.6, yb + L + 0.55), anchor: "west", text(fill: accent)[貯水池の水位を上げ下げする])
  // 共通の水位
  line((-0.3, yb + L), (rx + rw + 0.3, yb + L),
    stroke: (paint: accent, thickness: 1.2pt, dash: "dashed"))
  content((rx + rw + 0.4, yb + L), anchor: "west", text(fill: accent)[水位 $mu$])
  content((0, yb - 0.3), anchor: "north-west", box(width: 10.5cm)[
    *(b) グランドカノニカル: 水位 $mu$ を決める* \
    同じプールを水路で巨大な貯水池につなぎ, 貯水池の水位を合わせる. プールの水位は, 貯水池の水位にそろう.
  ])
})
