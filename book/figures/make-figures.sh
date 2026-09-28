#!/bin/sh
# fig-*.typ から講義ノート用の SVG を書き出す (fig-bath-heat.typ → bath-heat.svg).
cd "$(dirname "$0")" || exit 1
for f in fig-*.typ; do
  n=${f#fig-}
  typst compile "$f" "${n%.typ}.svg"
done
