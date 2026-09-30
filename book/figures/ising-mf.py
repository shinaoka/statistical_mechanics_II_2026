"""イジングモデルの平均場近似の図 (第9回: transition-order, mf-graphical, mf-magnetization. 第10回: mf-free-energy, mf-asymptotics, mf-heat, mf-chi) を作る.

使い方: python3 book/figures/ising-mf.py
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
    """B = 0 の自己無撞着方程式 m = tanh(m/t) の正の解 (t = T/T_c)."""
    if t >= 1:
        return 0.0
    return brentq(lambda m: m - np.tanh(m / t), 1e-12, 1.0)


def entropy_per_spin(m):
    """1スピンあたりのエントロピー S/(N k_B). 上向きの割合 (1+m)/2 から求める."""
    p, q = (1 + m) / 2, (1 - m) / 2
    return -sum(x * np.log(x) for x in (p, q) if x > 0)


# 1次転移と2次転移: 秩序変数とエントロピー (模式図)
t = np.linspace(0.02, 1.6, 400)
m2 = np.array([m_mf(x) for x in t])
s2 = np.array([entropy_per_spin(m) for m in m2]) + 0.08 * t  # 格子振動などの寄与 (模式的)
tc1 = 1.0
m1 = np.where(t < tc1, np.array([m_mf(x / 1.35) for x in t]), 0.0)
s1 = np.array([entropy_per_spin(m) for m in m1]) + 0.08 * t
fig, axes = plt.subplots(1, 2, figsize=(8.4, 3.2))
for ax, y1, y2, label in (
    (axes[0], m1, m2, "秩序変数 (磁化など)"),
    (axes[1], s1, s2, "エントロピー"),
):
    below = t < tc1
    ax.plot(t[below], y1[below], color=COLORS[1], lw=2, label="1次転移")
    ax.plot(t[~below], y1[~below], color=COLORS[1], lw=2)
    ax.plot(t, y2, color=COLORS[0], lw=2, ls="--", label="2次転移")
    ax.axvline(tc1, color="gray", lw=0.8, ls=":")
    ax.set_xticks([tc1], [r"$T_\mathrm{c}$"])
    ax.set_yticks([])
    ax.set_xlabel(r"$T$")
    ax.set_title(label, fontsize=12)
    ax.set_xlim(0, 1.6)
    ax.set_ylim(bottom=0)
axes[0].legend(frameon=False, fontsize=10)
i = np.searchsorted(t, tc1)
axes[1].annotate("", xy=(tc1 + 0.03, s1[i]), xytext=(tc1 + 0.03, s1[i - 1]),
                 arrowprops=dict(arrowstyle="<->", color=COLORS[1]))
axes[1].text(tc1 + 0.07, (s1[i] + s1[i - 1]) / 2, r"$\Delta S$ (潜熱 $T_\mathrm{c} \Delta S$)",
             color=COLORS[1], fontsize=10, va="center")
fig.tight_layout()
fig.savefig(OUT / "transition-order.svg")
plt.close(fig)

# 自己無撞着方程式のグラフ解法 (B = 0)
m = np.linspace(-1.6, 1.6, 400)
fig, ax = plt.subplots(figsize=(4.8, 3.8))
ax.plot(m, m, color="black", lw=1.2, label=r"$y = m$")
for tt, c in ((0.6, COLORS[1]), (1.0, "gray"), (1.6, COLORS[0])):
    lab = r"$T = T_\mathrm{c}$" if tt == 1 else rf"$T = {tt:g}\,T_\mathrm{{c}}$"
    ax.plot(m, np.tanh(m / tt), color=c, lw=2, label=lab)
m0 = m_mf(0.6)
ax.plot([m0, -m0, 0], [m0, -m0, 0], "o", color=COLORS[1], ms=6)
ax.axhline(0, color="black", lw=0.6)
ax.axvline(0, color="black", lw=0.6)
ax.set_xlim(-1.6, 1.6)
ax.set_ylim(-1.3, 1.3)
ax.set_xlabel(r"$m$")
ax.set_ylabel(r"$y$")
ax.legend(frameon=False, fontsize=10, loc="lower right")
ax.text(-1.5, 1.1, r"曲線: $y = \tanh(m\, T_\mathrm{c}/T)$", fontsize=10)
fig.tight_layout()
fig.savefig(OUT / "mf-graphical.svg")
plt.close(fig)

# 自発磁化の温度変化 (平均場近似)
t = np.linspace(0.001, 1.4, 500)
fig, ax = plt.subplots(figsize=(4.6, 3.4))
ax.plot(t, [m_mf(x) for x in t], color=COLORS[0], lw=2)
ax.set_xlabel(r"$T / T_\mathrm{c}$")
ax.set_ylabel(r"$m$")
ax.set_xlim(0, 1.4)
ax.set_ylim(0, 1.05)
fig.tight_layout()
fig.savefig(OUT / "mf-magnetization.svg")
plt.close(fig)


# ---- 第10回 ----
def f_mf(m, t):
    """1スピンあたりの平均場の自由エネルギー F(m)/(N k_B T_c) (B = 0). 定数 -t ln 2 は除く."""
    p, q = (1 + m) / 2, (1 - m) / 2
    with np.errstate(divide="ignore", invalid="ignore"):
        ent = np.where(p > 0, p * np.log(p), 0) + np.where(q > 0, q * np.log(q), 0)
    return -m**2 / 2 + t * (ent + np.log(2))


# 自由エネルギーの m 依存性
m = np.linspace(-0.999, 0.999, 500)
fig, ax = plt.subplots(figsize=(4.8, 3.6))
for tt, c in ((1.3, COLORS[0]), (1.0, "gray"), (0.8, COLORS[2]), (0.6, COLORS[1])):
    lab = r"$T = T_\mathrm{c}$" if tt == 1 else rf"$T = {tt:g}\,T_\mathrm{{c}}$"
    ax.plot(m, f_mf(m, tt), color=c, lw=2, label=lab)
    if tt < 1:
        m0 = m_mf(tt)
        ax.plot([m0, -m0], [f_mf(m0, tt)] * 2, "o", color=c, ms=5)
ax.axhline(0, color="black", lw=0.6)
ax.set_xlim(-1, 1)
ax.set_ylim(-0.2, 0.3)
ax.set_xlabel(r"$m$")
ax.set_ylabel(r"$[F(m) - F(0)] / (N k_\mathrm{B} T_\mathrm{c})$")
ax.legend(frameon=False, fontsize=10, loc="upper center", ncol=2)
fig.tight_layout()
fig.savefig(OUT / "mf-free-energy.svg")
plt.close(fig)

# 自発磁化と近似式
t = np.linspace(0.02, 1.0, 400)
m0 = np.array([m_mf(x) for x in t])
fig, ax = plt.subplots(figsize=(4.8, 3.4))
ax.plot(t, m0, color=COLORS[0], lw=2.5, label="数値解")
tn = np.linspace(0.6, 1.0, 100)
ax.plot(tn, np.sqrt(3 * (1 - tn)), color=COLORS[1], lw=1.5, ls="--", label=r"$\sqrt{3(1 - T/T_\mathrm{c})}$")
tl = np.linspace(0.02, 0.6, 100)
ax.plot(tl, 1 - 2 * np.exp(-2 / tl), color=COLORS[2], lw=1.5, ls="--", label=r"$1 - 2 e^{-2 T_\mathrm{c}/T}$")
ax.set_xlabel(r"$T / T_\mathrm{c}$")
ax.set_ylabel(r"$m_0$")
ax.set_xlim(0, 1.1)
ax.set_ylim(0, 1.1)
ax.legend(frameon=False, fontsize=10, loc="lower left")
fig.tight_layout()
fig.savefig(OUT / "mf-asymptotics.svg")
plt.close(fig)

# 比熱: E/N = -z J m^2 / 2 より C/(N k_B) = -d(m^2/2)/dt
# dm/dt は m = tanh(m/t) を微分して求める.
t = np.concatenate([np.linspace(0.02, 0.9999, 1000), np.linspace(1.0001, 1.5, 200)])
m0 = np.array([m_mf(x) for x in t])
g = 1 - m0**2
c = g * m0**2 / t**2 / (1 - g / t)
fig, ax = plt.subplots(figsize=(4.6, 3.4))
below = t <= 1
ax.plot(t[below], c[below], color=COLORS[0], lw=2)
ax.plot(t[~below], c[~below], color=COLORS[0], lw=2)
ax.axhline(1.5, color="gray", lw=0.8, ls=":")
ax.text(0.05, 1.53, r"$\frac{3}{2}$", color="gray", va="bottom")
ax.set_xlabel(r"$T / T_\mathrm{c}$")
ax.set_ylabel(r"$C / (N k_\mathrm{B})$")
ax.set_xlim(0, 1.5)
ax.set_ylim(0, 1.8)
fig.tight_layout()
fig.savefig(OUT / "mf-heat.svg")
plt.close(fig)

# 磁化率の逆数: chi k_B T_c / (N mu_B^2) = (1 - m0^2) / (t - (1 - m0^2))
t = np.linspace(0.3, 2.0, 600)
m0 = np.array([m_mf(x) for x in t])
g = 1 - m0**2
inv = (t - g) / g
fig, ax = plt.subplots(figsize=(4.6, 3.4))
ax.plot(t, inv, color=COLORS[0], lw=2)
ax.plot(t, t, color="gray", lw=1.2, ls="--", label=r"$J = 0$ (キュリーの法則)")
ax.set_xticks([0.5, 1, 1.5, 2], ["0.5", r"$T_\mathrm{c}$", "1.5", "2"])
ax.set_xlabel(r"$T / T_\mathrm{c}$")
ax.set_ylabel(r"$N \mu_\mathrm{B}^2 / (\chi\, k_\mathrm{B} T_\mathrm{c})$")
ax.set_xlim(0.3, 2.0)
ax.set_ylim(0, 1.5)
ax.legend(frameon=False, fontsize=10, loc="upper center")
fig.tight_layout()
fig.savefig(OUT / "mf-chi.svg")
plt.close(fig)
