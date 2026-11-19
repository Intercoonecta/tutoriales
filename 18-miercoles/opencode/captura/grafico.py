import os
from matplotlib.figure import Figure

CAMPOS_ELEGIBLES = [
    "temperatura",
    "pH",
    "clorofila",
    "especie",
    "id_estacion",
    "fecha",
    "latitud",
    "longitud",
]

CAMPOS_NUMERICOS = {"temperatura", "pH", "clorofila", "latitud", "longitud"}


def _es_numerico(campo, valores):
    if campo in CAMPOS_NUMERICOS:
        return True
    # Heurística: si todos los valores no nulos son int/float
    vals = [v for v in valores if v is not None and v != ""]
    if not vals:
        return False
    return all(isinstance(v, (int, float)) and not isinstance(v, bool) for v in vals)


def crear_figura_coordenadas(registros, campo):
    fig = Figure(figsize=(8, 6), dpi=100)
    ax = fig.add_subplot(111)

    puntos = [
        r for r in registros
        if r.get("latitud") is not None and r.get("longitud") is not None
    ]

    ax.set_xlabel("Longitud")
    ax.set_ylabel("Latitud")
    ax.set_title(f"Coordenadas de mediciones - campo: {campo}")
    ax.grid(True, linestyle="--", alpha=0.3)

    if not puntos:
        ax.text(
            0.5, 0.5,
            "No hay datos con coordenadas válidas (latitud/longitud).",
            ha="center", va="center", transform=ax.transAxes,
        )
        fig.tight_layout()
        return fig

    lons = [float(p["longitud"]) for p in puntos]
    lats = [float(p["latitud"]) for p in puntos]
    valores = [p.get(campo) for p in puntos]

    if _es_numerico(campo, valores):
        # Separar puntos con y sin valor
        con_valor_idx = [i for i, v in enumerate(valores) if v is not None and v != ""]
        sin_valor_idx = [i for i, v in enumerate(valores) if v is None or v == ""]

        if sin_valor_idx:
            ax.scatter(
                [lons[i] for i in sin_valor_idx],
                [lats[i] for i in sin_valor_idx],
                c="lightgray", edgecolors="gray", s=40, label="Sin dato", alpha=0.7,
            )
        if con_valor_idx:
            x = [lons[i] for i in con_valor_idx]
            y = [lats[i] for i in con_valor_idx]
            c = [float(valores[i]) for i in con_valor_idx]
            sc = ax.scatter(x, y, c=c, cmap="viridis", s=60, edgecolors="black", linewidths=0.3)
            cbar = fig.colorbar(sc, ax=ax)
            cbar.set_label(campo)
        if sin_valor_idx and con_valor_idx:
            ax.legend(loc="best")
        if not con_valor_idx and sin_valor_idx:
            ax.text(
                0.5, 0.02,
                f"Todos los registros tienen '{campo}' sin dato.",
                ha="center", va="bottom", transform=ax.transAxes, fontsize=9, color="gray",
            )
    else:
        # Categórico
        categorias = {}
        for lon, lat, val in zip(lons, lats, valores):
            key = "(sin dato)" if val is None or val == "" else str(val)
            categorias.setdefault(key, {"lon": [], "lat": []})
            categorias[key]["lon"].append(lon)
            categorias[key]["lat"].append(lat)

        cmap = None
        try:
            import matplotlib.cm as cm
            cmap = cm.get_cmap("tab20", max(len(categorias), 1))
        except Exception:
            cmap = None

        for i, (cat, coords) in enumerate(sorted(categorias.items(), key=lambda x: str(x[0]))):
            color = cmap(i) if cmap is not None else None
            ax.scatter(
                coords["lon"], coords["lat"],
                s=60, edgecolors="black", linewidths=0.3,
                label=str(cat), color=color, alpha=0.85,
            )
        # Leyenda (limitar si hay muchas categorías)
        if len(categorias) <= 20:
            ax.legend(loc="best", fontsize=8, title=campo)
        else:
            ax.text(
                0.99, 0.01,
                f"{len(categorias)} categorías (leyenda omitida)",
                ha="right", va="bottom", transform=ax.transAxes, fontsize=8, color="gray",
            )

    fig.tight_layout()
    return fig


def guardar_figura(fig, ruta):
    os.makedirs(os.path.dirname(ruta) or ".", exist_ok=True)
    fig.savefig(ruta, dpi=150, bbox_inches="tight")
    return ruta
