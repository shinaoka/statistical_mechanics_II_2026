"""1次元イジングモデルの厳密解の図 (第13回: ising1d-heat, ising1d-m, ising1d-corr) を作る.

使い方: python3 book/figures/ising1d.py
"""
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
from scipy.optimize import brentq

plt.rcParams["font.family"] = "Hiragino Sans"
plt.rcParams["font.size"] = 12
plt.rcParams["axes.unicode_minus"] = True
OUT = Path(__file__).parent
COLORS = ["#1f4e79", "#b03a2e", "#4d6b2f"]


def m_mf(t):
    """平均場近似の m = tanh(m/t) の正の解 (t = T/T_c)."""
    if t >= 1:
        return 0.0
    return brentq(lambda m: m - np.tanh(m / t), 1e-12, 1.0)


# 比熱: 厳密解と平均場近似 (z = 2, T_c = 2J/k_B). 横軸 k_B T / J.
t = np.linspace(0.02, 4.0, 800)
c_exact = (1 / t) ** 2 / np.cosh(1 / t) ** 2
tm = t / 2
m0 = np.array([m_mf(x) if abs(x - 1) > 1e-4 else 0.0 for x in tm])
g = 1 - m0**2
c_mf = np.where(tm < 1, g * m0**2 / tm**2 / (1 - g / tm + 1e-300), 0.0)
fig, ax = plt.subplots(figsize=(4.8, 3.4))
ax.plot(t, c_exact, color=COLORS[0], lw=2.5, label="厳密解")
# T_c での跳びも線でつなぐ (見やすさのため)
ax.plot(t, c_mf, color=COLORS[1], lw=2.5, ls="--", label="平均場近似")
ax.set_xlabel(r"$k_\mathrm{B} T / J$")
ax.set_ylabel(r"$C / (N k_\mathrm{B})$")
ax.set_xlim(0, 4)
ax.set_ylim(-0.05, 1.7)
ax.legend(frameon=False, fontsize=10, loc="upper right")
fig.tight_layout()
fig.savefig(OUT / "ising1d-heat.svg")
plt.close(fig)

# 磁化の磁場依存性. 横軸 mu_B B / J.
h = np.linspace(-2, 2, 801)
fig, ax = plt.subplots(figsize=(4.8, 3.4))
for tt, c in ((0.5, COLORS[1]), (1.0, COLORS[2]), (2.0, COLORS[0])):
    bh, bj = h / tt, 1 / tt
    m = np.sinh(bh) / np.sqrt(np.sinh(bh) ** 2 + np.exp(-4 * bj))
    ax.plot(h, m, color=c, lw=2, label=rf"$k_\mathrm{{B}} T = {tt:g}\,J$")
ax.axhline(0, color="black", lw=0.6)
ax.axvline(0, color="black", lw=0.6)
ax.set_xlabel(r"$\mu_\mathrm{B} B / J$")
ax.set_ylabel(r"$m$")
ax.set_xlim(-2, 2)
ax.set_ylim(-1.05, 1.05)
ax.legend(frameon=False, fontsize=10, loc="lower right")
fig.tight_layout()
fig.savefig(OUT / "ising1d-m.svg")
plt.close(fig)

# スピン相関 <s_0 s_r> = (tanh(J/k_B T))^r
r = np.arange(0, 31)
fig, ax = plt.subplots(figsize=(4.8, 3.4))
for tt, c in ((0.5, COLORS[1]), (1.0, COLORS[2]), (2.0, COLORS[0])):
    ax.plot(r, np.tanh(1 / tt) ** r, "o-", color=c, ms=3.5, lw=1.2, label=rf"$k_\mathrm{{B}} T = {tt:g}\,J$")
ax.set_xlabel(r"$r$")
ax.set_ylabel(r"$\langle s_0 s_r \rangle$")
ax.set_xlim(0, 30)
ax.set_ylim(0, 1.05)
ax.legend(frameon=False, fontsize=10, loc="upper right")
fig.tight_layout()
fig.savefig(OUT / "ising1d-corr.svg")
plt.close(fig)
