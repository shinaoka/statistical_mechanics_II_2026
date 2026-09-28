"""ラングミュアの等温吸着式の図 (langmuir-pressure.svg) を作る.

使い方: python3 book/figures/langmuir.py
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

# 温度一定: θ = P/(P + P0)
x = np.linspace(0, 10, 400)
fig, ax = plt.subplots(figsize=(4.2, 3.0))
ax.plot(x, x / (1 + x), color=COLORS[0], lw=2)
ax.axhline(1, color="gray", lw=0.8, ls="--")
ax.set_xlabel(r"$P / P_0(T)$")
ax.set_ylabel(r"被覆率 $\theta$")
ax.set_xlim(0, 10)
ax.set_ylim(0, 1.05)
fig.tight_layout()
fig.savefig(OUT / "langmuir-pressure.svg")
