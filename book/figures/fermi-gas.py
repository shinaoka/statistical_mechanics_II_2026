"""フェルミ気体の図 (fermi-dos.svg, fermi-smear.svg, fermi-window.svg) を作る.

使い方: python3 book/figures/fermi-gas.py
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

# T = 0 では D(ε) の下を ε_F まで埋める
e = np.linspace(0, 1.6, 400)
dos = np.sqrt(e)
fig, ax = plt.subplots(figsize=(4.6, 3.2))
ax.plot(e, dos, color=COLORS[0], lw=2, label=r"$D(\varepsilon)$")
ax.fill_between(e, 0, np.where(e <= 1, dos, 0), color=COLORS[0], alpha=0.25,
                lw=0, label=r"$D(\varepsilon) f(\varepsilon)$ ($T = 0$)")
ax.axvline(1, color=COLORS[1], lw=1, ls="--")
ax.text(1.02, 0.1, r"$\varepsilon_\mathrm{F}$", color=COLORS[1])
ax.set_xlabel(r"$\varepsilon / \varepsilon_\mathrm{F}$")
ax.set_ylabel(r"$D(\varepsilon) / D(\varepsilon_\mathrm{F})$")
ax.set_xlim(0, 1.6)
ax.set_ylim(0, 1.4)
ax.legend(frameon=False, fontsize=10, loc="upper left")
fig.tight_layout()
fig.savefig(OUT / "fermi-dos.svg")

# 有限温度: フェルミ面の近く (幅 k_B T 程度) だけが変わる
t = 0.08
mu = 1 - np.pi**2 / 12 * t**2
f = 1 / (np.exp((e - mu) / t) + 1)
fig, ax = plt.subplots(figsize=(4.6, 3.2))
ax.plot(e, dos, color="gray", lw=1)
ax.fill_between(e, 0, np.where(e <= 1, dos, 0), color="gray", alpha=0.15, lw=0,
                label=r"$T = 0$")
ax.plot(e, dos * f, color=COLORS[0], lw=2, label=rf"$k_\mathrm{{B}} T = {t}\,\varepsilon_\mathrm{{F}}$")
ax.annotate("", xy=(1 + 2 * t, 0.55), xytext=(1 - 2 * t, 0.55),
            arrowprops=dict(arrowstyle="<->", color=COLORS[1]))
ax.text(1, 0.6, r"幅 $\sim k_\mathrm{B} T$", color=COLORS[1], ha="center", va="bottom", fontsize=10)
ax.set_xlabel(r"$\varepsilon / \varepsilon_\mathrm{F}$")
ax.set_ylabel(r"$D(\varepsilon) f(\varepsilon) / D(\varepsilon_\mathrm{F})$")
ax.set_xlim(0, 1.6)
ax.set_ylim(0, 1.4)
ax.legend(frameon=False, fontsize=10, loc="upper left")
fig.tight_layout()
fig.savefig(OUT / "fermi-smear.svg")

# -∂f/∂ε: ε = μ のまわりの幅 k_B T 程度にだけ値を持つ
x = np.linspace(-8, 8, 400)
fig, ax = plt.subplots(figsize=(4.6, 3.2))
ax.plot(x, np.exp(x) / (np.exp(x) + 1) ** 2, color=COLORS[0], lw=2)
ax.set_xlabel(r"$(\varepsilon - \mu) / k_\mathrm{B} T$")
ax.set_ylabel(r"$-k_\mathrm{B} T \, \partial f / \partial \varepsilon$")
ax.set_xlim(-8, 8)
ax.set_ylim(0, 0.3)
fig.tight_layout()
fig.savefig(OUT / "fermi-window.svg")
