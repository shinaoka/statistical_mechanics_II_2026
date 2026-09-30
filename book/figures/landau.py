"""ランダウ理論の図 (第11回: landau-2nd, landau-thermo, landau-mh. 第12回: landau-1st, landau-1st-m) を作る.

使い方: python3 book/figures/landau.py
係数は a = b = c = 1 などとした模式図である.
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
COLORS = ["#1f4e79", "#b03a2e", "#4d6b2f", "#7a5195"]

# ---- 第11回: 2次転移. F - F0 = a (T - Tc) m^2 + b m^4, a = b = Tc = 1 ----
m = np.linspace(-1.2, 1.2, 400)
fig, ax = plt.subplots(figsize=(4.6, 3.4))
for dt, c, lab in ((0.5, COLORS[0], r"$T > T_\mathrm{c}$"), (0.0, "gray", r"$T = T_\mathrm{c}$"), (-0.5, COLORS[1], r"$T < T_\mathrm{c}$")):
    ax.plot(m, dt * m**2 + m**4, color=c, lw=2, label=lab)
m0 = np.sqrt(0.5 / 2)
ax.plot([m0, -m0], [-0.5 * m0**2 + m0**4] * 2, "o", color=COLORS[1], ms=5)
ax.text(m0, -0.12, r"$m_0$", color=COLORS[1], ha="center", va="top")
ax.text(-m0, -0.12, r"$-m_0$", color=COLORS[1], ha="center", va="top")
ax.axhline(0, color="black", lw=0.6)
ax.set_xlim(-1.2, 1.2)
ax.set_ylim(-0.2, 0.6)
ax.set_xticks([0])
ax.set_yticks([0])
ax.set_xlabel(r"$m$")
ax.set_ylabel(r"$F - F_0$")
ax.legend(frameon=False, fontsize=10, loc="upper center")
fig.tight_layout()
fig.savefig(OUT / "landau-2nd.svg")
plt.close(fig)

# 秩序変数, エントロピー, 比熱の温度変化 (a = b = Tc = 1, F0 の寄与は S0 = 1 + 0.3 T, C0 = 0.3 T)
t = np.linspace(0.2, 1.8, 400)
below = t < 1
m0 = np.where(below, np.sqrt(np.clip((1 - t) / 2, 0, None)), 0)
s = 1 + 0.3 * t - np.where(below, (1 - t) / 2, 0)
c = 0.3 * t + np.where(below, t / 2, 0)
fig, axes = plt.subplots(1, 3, figsize=(9.0, 2.8))
for ax, y, lab in ((axes[0], m0, r"$m_0$"), (axes[1], s, r"$S$"), (axes[2], c, r"$C$")):
    ax.plot(t[below], y[below], color=COLORS[0], lw=2)
    ax.plot(t[~below], y[~below], color=COLORS[0], lw=2)
    ax.axvline(1, color="gray", lw=0.8, ls=":")
    ax.set_xticks([1], [r"$T_\mathrm{c}$"])
    ax.set_yticks([])
    ax.set_xlabel(r"$T$")
    ax.set_title(lab, fontsize=12)
    ax.set_ylim(bottom=0)
axes[2].plot(t, 0.3 * t, color="gray", lw=1, ls="--")
axes[2].text(1.75, 0.3 * 1.75 - 0.08, r"$C_0$", color="gray", ha="right", va="top")
axes[2].annotate("", xy=(1.06, 0.3), xytext=(1.06, 0.8), arrowprops=dict(arrowstyle="<->", color=COLORS[1]))
axes[2].text(1.12, 0.55, r"$\Delta C$", color=COLORS[1], va="center")
fig.tight_layout()
fig.savefig(OUT / "landau-thermo.svg")
plt.close(fig)


def m_of_h(h, dt):
    """2 a (T - Tc) m + 4 b m^3 = h の解 (a = b = 1). 複数あるときは F が最小のもの."""
    roots = np.roots([4, 0, 2 * dt, -h])
    roots = roots[np.abs(roots.imag) < 1e-9].real
    f = dt * roots**2 + roots**4 - h * roots
    return roots[np.argmin(f)]


h = np.linspace(-1, 1, 801)
fig, ax = plt.subplots(figsize=(4.6, 3.4))
for dt, c, lab in ((0.5, COLORS[0], r"$T > T_\mathrm{c}$"), (0.0, "gray", r"$T = T_\mathrm{c}$"), (-0.5, COLORS[1], r"$T < T_\mathrm{c}$")):
    mm = np.array([m_of_h(x, dt) for x in h])
    if dt < 0:
        ax.plot(h[h < 0], mm[h < 0], color=c, lw=2, label=lab)
        ax.plot(h[h > 0], mm[h > 0], color=c, lw=2)
        ax.plot([0, 0], [-0.5, 0.5], color=c, lw=1, ls=":")
    else:
        ax.plot(h, mm, color=c, lw=2, label=lab)
ax.axhline(0, color="black", lw=0.6)
ax.axvline(0, color="black", lw=0.6)
ax.set_xticks([0])
ax.set_yticks([0])
ax.set_xlabel(r"$h$")
ax.set_ylabel(r"$m$")
ax.legend(frameon=False, fontsize=10, loc="upper left")
fig.tight_layout()
fig.savefig(OUT / "landau-mh.svg")
plt.close(fig)

# ---- 第12回: 1次転移. F - F0 = a (T - T0) m^2 - b m^4 + c m^6, a = b = c = 1, T0 = 0 ----
# T** = 1/3, Tc = 1/4.
T_SS, T_C = 1 / 3, 1 / 4


def f1(m, T):
    return T * m**2 - m**4 + m**6


m = np.linspace(-1.1, 1.1, 400)
temps = ((0.45, r"$T > T^{**}$"), (T_SS, r"$T = T^{**}$"), (0.29, r"$T_\mathrm{c} < T < T^{**}$"),
         (T_C, r"$T = T_\mathrm{c}$"), (0.12, r"$T_0 < T < T_\mathrm{c}$"), (0.0, r"$T = T_0$"))
fig, axes = plt.subplots(2, 3, figsize=(8.4, 4.6), sharex=True, sharey=True)
for ax, (T, lab) in zip(axes.flat, temps):
    ax.plot(m, f1(m, T), color=COLORS[0], lw=2)
    ax.axhline(0, color="black", lw=0.6)
    ax.set_title(lab, fontsize=11)
    ax.set_xticks([0])
    ax.set_yticks([0])
    ax.set_xlim(-1.1, 1.1)
    ax.set_ylim(-0.08, 0.12)
for ax in axes[1]:
    ax.set_xlabel(r"$m$")
for ax in axes[:, 0]:
    ax.set_ylabel(r"$F - F_0$")
fig.tight_layout()
fig.savefig(OUT / "landau-1st.svg")
plt.close(fig)

# 秩序変数の温度変化と履歴 (ヒステリシス)
t_ord = np.linspace(-0.15, T_SS, 400)
m_ord = np.sqrt((1 + np.sqrt(np.clip(1 - 3 * t_ord, 0, None))) / 3)
fig, ax = plt.subplots(figsize=(4.8, 3.4))
st = t_ord <= T_C
ax.plot(t_ord[st], m_ord[st], color=COLORS[0], lw=2.5, label="安定")
ax.plot(t_ord[~st], m_ord[~st], color=COLORS[0], lw=2, ls="--", label="準安定")
ax.plot([T_C, 0.5], [0, 0], color=COLORS[0], lw=2.5)
ax.plot([0.0, T_C], [0, 0], color=COLORS[0], lw=2, ls="--")
# 冷やすとき (T0 で跳ぶ) と温めるとき (T** で跳ぶ)
ax.annotate("", xy=(0.0, m_ord[np.searchsorted(t_ord, 0.0)] - 0.02), xytext=(0.0, 0.02),
            arrowprops=dict(arrowstyle="->", color=COLORS[2], lw=1.5))
ax.annotate("", xy=(T_SS, 0.02), xytext=(T_SS, m_ord[-1] - 0.02),
            arrowprops=dict(arrowstyle="->", color=COLORS[1], lw=1.5))
ax.text(0.01, 0.35, "冷やすとき", color=COLORS[2], fontsize=10)
ax.text(T_SS + 0.01, 0.35, "温めるとき", color=COLORS[1], fontsize=10)
for x in (0.0, T_C, T_SS):
    ax.axvline(x, color="gray", lw=0.6, ls=":")
ax.set_xticks([0.0, T_C, T_SS], [r"$T_0$", r"$T_\mathrm{c}$", r"$T^{**}$"])
ax.set_yticks([0])
ax.set_xlim(-0.15, 0.5)
ax.set_ylim(-0.03, 0.95)
ax.set_xlabel(r"$T$")
ax.set_ylabel(r"$m$")
ax.legend(frameon=False, fontsize=10, loc="upper right")
fig.tight_layout()
fig.savefig(OUT / "landau-1st-m.svg")
plt.close(fig)
