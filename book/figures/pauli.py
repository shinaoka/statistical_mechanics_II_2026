"""パウリ常磁性の図 (pauli-dos.svg, pauli-chi.svg) を作る.

使い方: python3 book/figures/pauli.py
"""
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
from scipy.integrate import quad
from scipy.optimize import brentq

plt.rcParams["font.family"] = "Hiragino Sans"
plt.rcParams["font.size"] = 12
plt.rcParams["axes.unicode_minus"] = True
OUT = Path(__file__).parent
COLORS = ["#1f4e79", "#b03a2e", "#4d6b2f"]

# 磁場の中の状態密度 (T = 0). 左が磁気モーメントが磁場と逆向き, 右が同じ向き.
h = 0.15  # μ_B B / ε_F (見やすくするため大きくとる)
e = np.linspace(-0.3, 1.5, 500)
d_par = 0.5 * np.sqrt(np.clip(e + h, 0, None))   # エネルギー ε_k - μ_B B
d_anti = 0.5 * np.sqrt(np.clip(e - h, 0, None))  # エネルギー ε_k + μ_B B
fig, ax = plt.subplots(figsize=(4.6, 3.6))
ax.plot(d_par, e, color=COLORS[0], lw=2)
ax.plot(-d_anti, e, color=COLORS[1], lw=2)
ax.fill_betweenx(e, 0, np.where(e <= 1, d_par, 0), color=COLORS[0], alpha=0.25, lw=0)
ax.fill_betweenx(e, 0, np.where(e <= 1, -d_anti, 0), color=COLORS[1], alpha=0.25, lw=0)
# B = 0 の状態密度 (両方の向きで同じ)
d0 = 0.5 * np.sqrt(np.clip(e, 0, None))
ax.plot(d0, e, color="black", lw=1, ls=":", label=r"$B = 0$")
ax.plot(-d0, e, color="black", lw=1, ls=":")
ax.axhline(1, color="gray", lw=1, ls="--")
ax.axvline(0, color="black", lw=0.8)
ax.text(0.62, 1.03, r"$\mu$", color="gray", va="bottom")
ax.text(0.33, 1.35, "磁場と同じ向き", color=COLORS[0], ha="center", fontsize=10)
ax.text(-0.33, 1.35, "磁場と逆向き", color=COLORS[1], ha="center", fontsize=10)
ax.annotate("", xy=(0.12, -h), xytext=(0.12, 0), arrowprops=dict(arrowstyle="->", color=COLORS[0]))
ax.annotate("", xy=(-0.12, h), xytext=(-0.12, 0), arrowprops=dict(arrowstyle="->", color=COLORS[1]))
ax.text(0.15, -0.2, r"$-\mu_\mathrm{B} B$", color=COLORS[0], fontsize=10, va="center")
ax.text(-0.15, 0.08, r"$+\mu_\mathrm{B} B$", color=COLORS[1], fontsize=10, ha="right", va="center")
ax.set_xlabel("状態密度")
ax.set_ylabel(r"$\varepsilon / \varepsilon_\mathrm{F}$")
ax.set_xlim(-0.7, 0.7)
ax.set_ylim(-0.3, 1.5)
ax.set_xticks([])
ax.legend(frameon=False, fontsize=10, loc="lower left")
fig.tight_layout()
fig.savefig(OUT / "pauli-dos.svg")


# 磁化率の温度変化. χ = V μ_B^2 ∫ D(ε) (-∂f/∂ε) dε を, n を一定にして計算する.
# 単位: ε_F = 1, D(ε) = (3/2) ε^{1/2} (n = 1), χ は N μ_B^2 / ε_F を単位とする.
def fermi(x):
    return 0.5 * (1 - np.tanh(x / 2))


def density(mu, t):
    return quad(lambda e: 1.5 * np.sqrt(e) * fermi((e - mu) / t), 0, max(mu, 0) + 60 * t,
                limit=200, points=[max(mu, 0)])[0]


def chi(t):
    mu = brentq(lambda m: density(m, t) - 1, -60 * t - 5, 2)
    w = lambda e: 1.5 * np.sqrt(e) / (4 * t * np.cosh((e - mu) / (2 * t)) ** 2)
    return quad(w, 0, max(mu, 0) + 60 * t, limit=200, points=[max(mu, 0)])[0]


ts = np.linspace(0.02, 3, 120)
chis = [chi(t) for t in ts]
fig, ax = plt.subplots(figsize=(4.6, 3.2))
ax.plot(ts, chis, color=COLORS[0], lw=2, label="フェルミ気体")
tc = np.linspace(0.25, 3, 100)
ax.plot(tc, 1 / tc, color=COLORS[1], lw=1.5, ls="--", label=r"キュリーの法則 $1/T$")
ax.axhline(1.5, color="gray", lw=0.8, ls=":")
ax.text(2.95, 1.55, r"$T = 0$ の値 $\frac{3}{2}$", ha="right", va="bottom", fontsize=10, color="gray")
ax.set_xlabel(r"$T / T_\mathrm{F}$")
ax.set_ylabel(r"$\chi \, / \, (N \mu_\mathrm{B}^2 / \varepsilon_\mathrm{F})$")
ax.set_xlim(0, 3)
ax.set_ylim(0, 2.5)
ax.legend(frameon=False, fontsize=10, loc="upper right")
fig.tight_layout()
fig.savefig(OUT / "pauli-chi.svg")
print("chi(0.02) =", chis[0], " chi(3) * 3 =", chis[-1] * 3)
