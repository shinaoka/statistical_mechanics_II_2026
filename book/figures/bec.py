"""ボーズ・アインシュタイン凝縮の図 (bec-fraction.svg, bec-mu.svg, bec-heat.svg) を作る.

使い方: python3 book/figures/bec.py
"""
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import mpmath
import numpy as np
from scipy.optimize import brentq
from scipy.special import zeta

plt.rcParams["font.family"] = "Hiragino Sans"
plt.rcParams["font.size"] = 12
plt.rcParams["axes.unicode_minus"] = True
OUT = Path(__file__).parent
COLORS = ["#1f4e79", "#b03a2e", "#4d6b2f"]
Z32, Z52 = zeta(1.5), zeta(2.5)


def g(s, z):
    """g_s(z) = sum_l z^l / l^s (0 < z <= 1)."""
    return float(mpmath.polylog(s, z))


def fugacity(t):
    """T > T_c で g_{3/2}(z) = ζ(3/2) (T_c/T)^{3/2} を満たす z = e^{βμ}."""
    target = Z32 * t**-1.5
    return brentq(lambda z: g(1.5, z) - target, 1e-12, 1.0)


def energy(t):
    """E / (N k_B T_c) を t = T/T_c の関数として返す."""
    if t <= 1:
        return 1.5 * Z52 / Z32 * t**2.5
    z = fugacity(t)
    return 1.5 * t**2.5 * g(2.5, z) / Z32


# 凝縮した粒子の割合
t = np.linspace(0, 1.6, 400)
frac = np.where(t < 1, 1 - t**1.5, 0.0)
fig, ax = plt.subplots(figsize=(4.6, 3.2))
ax.plot(t, frac, color=COLORS[0], lw=2, label=r"$N_0 / N$ (凝縮)")
ax.plot(t, 1 - frac, color=COLORS[1], lw=2, ls="--",
        label=r"$N_\mathrm{ex} / N$ (励起状態)")
ax.set_xlabel(r"$T / T_\mathrm{c}$")
ax.set_ylabel("粒子の割合")
ax.set_xlim(0, 1.6)
ax.set_ylim(0, 1.05)
ax.legend(frameon=False, fontsize=10, loc="center right")
fig.tight_layout()
fig.savefig(OUT / "bec-fraction.svg")

# 化学ポテンシャル
ta = np.linspace(1.0005, 2.5, 200)
mu = [tt * np.log(fugacity(tt)) for tt in ta]
fig, ax = plt.subplots(figsize=(4.6, 3.2))
ax.plot([0, 1], [0, 0], color=COLORS[0], lw=2)
ax.plot(ta, mu, color=COLORS[0], lw=2)
ax.axvline(1, color="gray", lw=0.8, ls=":")
ax.set_xlabel(r"$T / T_\mathrm{c}$")
ax.set_ylabel(r"$\mu / k_\mathrm{B} T_\mathrm{c}$")
ax.set_xlim(0, 2.5)
ax.set_ylim(-1.2, 0.2)
fig.tight_layout()
fig.savefig(OUT / "bec-mu.svg")

# 比熱
tc = np.concatenate([np.linspace(0.01, 1, 100), np.linspace(1.002, 3, 150)])
e = np.array([energy(tt) for tt in tc])
c = np.gradient(e, tc)
c[tc <= 1] = 15 / 4 * Z52 / Z32 * tc[tc <= 1] ** 1.5
fig, ax = plt.subplots(figsize=(4.6, 3.2))
ax.plot(tc[tc <= 1], c[tc <= 1], color=COLORS[0], lw=2)
ax.plot(tc[tc > 1], c[tc > 1], color=COLORS[0], lw=2)
ax.axhline(1.5, color="gray", lw=0.8, ls="--")
ax.text(2.95, 1.43, "古典理想気体 3/2", ha="right", va="top", fontsize=10, color="gray")
ax.set_xlabel(r"$T / T_\mathrm{c}$")
ax.set_ylabel(r"$C / N k_\mathrm{B}$")
ax.set_xlim(0, 3)
ax.set_ylim(0, 2.1)
fig.tight_layout()
fig.savefig(OUT / "bec-heat.svg")

print("C(Tc)/NkB =", 15 / 4 * Z52 / Z32, " zeta(3/2) =", Z32, " zeta(5/2) =", Z52)
print("C just above Tc:", c[tc > 1][:3])
