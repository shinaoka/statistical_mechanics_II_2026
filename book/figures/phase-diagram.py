"""水の相図 (模式図, 第9回: water-phase) を作る.

使い方: python3 book/figures/phase-diagram.py
三重点と臨界点は実際の値. 境界線はクラウジウス・クラペイロンの式で近似した模式的なもの.
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

TT, PT = 273.16, 611.657  # 三重点 (K, Pa)
TC, PC = 647.1, 22.064e6  # 臨界点
ATM = 101325.0

# 蒸発曲線: 臨界点を通るように ln P = ln PT - A (1/T - 1/TT) とする
A = np.log(PC / PT) / (1 / TT - 1 / TC)
t_vap = np.linspace(TT, TC, 300)
p_vap = PT * np.exp(-A * (1 / t_vap - 1 / TT))
# 昇華曲線 (L/R = 6140 K)
t_sub = np.linspace(200, TT, 100)
p_sub = PT * np.exp(-6140 * (1 / t_sub - 1 / TT))
# 融解曲線: 傾きが負 (dP/dT = -13.5 MPa/K)
p_mel = np.logspace(np.log10(PT), np.log10(2e8), 100)
t_mel = TT - (p_mel - PT) / 13.5e6

fig, ax = plt.subplots(figsize=(5.6, 4.2))
for x, y in ((t_vap, p_vap), (t_sub, p_sub), (t_mel, p_mel)):
    ax.plot(x, y, color=COLORS[0], lw=2)
ax.plot([TT], [PT], "o", color=COLORS[0], ms=6)
ax.plot([TC], [PC], "o", color=COLORS[1], ms=7)
ax.annotate("三重点", (TT, PT), xytext=(300, 60), fontsize=10,
            arrowprops=dict(arrowstyle="-", color="gray", lw=0.8))
ax.annotate("臨界点", (TC, PC), xytext=(560, 2e8), fontsize=10, color=COLORS[1],
            arrowprops=dict(arrowstyle="-", color="gray", lw=0.8))
ax.axhline(ATM, color="gray", lw=0.8, ls=":")
ax.text(205, ATM * 1.3, "1 気圧", color="gray", fontsize=10)
for x, lab in ((273.15, r"$0\ {}^\circ\mathrm{C}$"), (373.15, r"$100\ {}^\circ\mathrm{C}$")):
    ax.plot([x], [ATM], "s", color="gray", ms=4)
    ax.text(x + 5, ATM / 2.2, lab, color="gray", fontsize=9)
ax.text(225, 3e6, "固体 (氷)", fontsize=12)
ax.text(390, 1.5e6, "液体 (水)", fontsize=12)
ax.text(400, 1e3, "気体 (水蒸気)", fontsize=12)
# 臨界点を回り込む経路 (液体 → 臨界点より高温 → 気体)
path_t = [480, 700, 700, 575]
path_p = [3e7, 3e7, 2e5, 2e5]
ax.plot(path_t[:-1], path_p[:-1], color=COLORS[2], lw=1.8, ls="--")
ax.annotate("", xy=(path_t[-1], path_p[-1]), xytext=(path_t[-2], path_p[-2]),
            arrowprops=dict(arrowstyle="->", color=COLORS[2], lw=1.8, ls="--"))
ax.text(555, 1.5e3, "臨界点を回り込むと\n相転移なしに\n液体から気体へ", color=COLORS[2], fontsize=9)
ax.set_yscale("log")
ax.set_xlim(200, 720)
ax.set_ylim(10, 1e9)
ax.set_xlabel(r"温度 $T$ (K)")
ax.set_ylabel(r"圧力 $P$ (Pa)")
fig.tight_layout()
fig.savefig(OUT / "water-phase.svg")
plt.close(fig)
