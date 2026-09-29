"""フェルミ分布とボーズ分布の図 (distributions.svg, fermi-temperature.svg) を作る.

使い方: python3 book/figures/distributions.py
"""
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

plt.rcParams["font.family"] = "Hiragino Sans"
plt.rcParams["font.size"] = 12
plt.rcParams["axes.unicode_minus"] = True
OUT = Path(__file__).parent
COLORS = ["#1f4e79", "#b03a2e", "#4d6b2f"]

# 3つの分布を x = β(ε − μ) の関数として比べる
x = np.linspace(-4, 5, 600)
xb = x[x > 0.05]
fig, ax = plt.subplots(figsize=(4.6, 3.2))
ax.plot(x, 1 / (np.exp(x) + 1), color=COLORS[0], lw=2, label="フェルミ分布")
ax.plot(xb, 1 / (np.exp(xb) - 1), color=COLORS[1], lw=2, label="ボーズ分布")
ax.plot(x, np.exp(-x), color=COLORS[2], lw=1.5, ls="--", label="古典 (ボルツマン)")
ax.axvline(0, color="gray", lw=0.8, ls=":")
# ε < μ ではボーズ分布は定義されない (その状態に粒子がいくらでも入り込む)
ax.axvspan(-4, 0, color=COLORS[1], alpha=0.08, lw=0)
ax.text(-2, 1.55, "ボーズ分布は\n定義されない\n" + r"($\varepsilon < \mu$)",
        ha="center", va="center", color=COLORS[1], fontsize=10)
ax.set_xlabel(r"$(\varepsilon - \mu) / k_\mathrm{B} T$")
ax.set_ylabel(r"平均の粒子数 $\langle n \rangle$")
ax.set_xlim(-4, 5)
ax.set_ylim(0, 2)
ax.legend(frameon=False, fontsize=10, loc="upper right")
fig.tight_layout()
fig.savefig(OUT / "distributions.svg")

# フェルミ分布の温度変化 (μ を一定とする)
e = np.linspace(0, 2, 600)
fig, ax = plt.subplots(figsize=(4.6, 3.2))
ax.plot(e, np.where(e < 1, 1.0, 0.0), color="black", lw=1.5, label=r"$T = 0$")
for t, c in zip([0.03, 0.1, 0.25], COLORS):
    ax.plot(e, 1 / (np.exp((e - 1) / t) + 1), color=c, lw=2,
            label=rf"$k_\mathrm{{B}} T = {t}\,\mu$")
ax.set_xlabel(r"$\varepsilon / \mu$")
ax.set_ylabel(r"$f(\varepsilon)$")
ax.set_xlim(0, 2)
ax.set_ylim(0, 1.1)
ax.legend(frameon=False, fontsize=10)
fig.tight_layout()
fig.savefig(OUT / "fermi-temperature.svg")
