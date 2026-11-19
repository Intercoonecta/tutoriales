import csv
import json
import os

from db import COLUMNAS, insertar_o_reemplazar

NUMERICOS = {"latitud", "longitud", "temperatura", "pH", "clorofila"}


def _a_float(valor, campo):
    if valor is None:
        return None
    if isinstance(valor, (int, float)):
        return float(valor)
    v = str(valor).strip()
    if v == "":
        return None
    v = v.replace(",", ".")
    try:
        return float(v)
    except ValueError:
        raise ValueError(f"El campo '{campo}' debe ser numérico (valor recibido: {valor!r})")


def _a_int(valor, campo):
    if valor is None:
        return None
    if isinstance(valor, int):
        return valor
    v = str(valor).strip()
    if v == "":
        return None
    try:
        return int(float(v))
    except ValueError:
        raise ValueError(f"El campo '{campo}' debe ser entero (valor recibido: {valor!r})")


def _a_texto(valor):
    if valor is None:
        return None
    v = str(valor).strip()
    return v if v != "" else None


def normalizar_registro(raw):
    data = {}
    # id
    if "id" in raw:
        data["id"] = _a_int(raw.get("id"), "id")
    else:
        data["id"] = None
    # texto
    for campo in ("id_estacion", "fecha", "especie"):
        data[campo] = _a_texto(raw.get(campo))
    # numéricos
    for campo in ("latitud", "longitud", "temperatura", "pH", "clorofila"):
        data[campo] = _a_float(raw.get(campo), campo)
    return data


def exportar_csv(registros, ruta):
    os.makedirs(os.path.dirname(ruta) or ".", exist_ok=True)
    with open(ruta, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=COLUMNAS)
        writer.writeheader()
        for r in registros:
            writer.writerow({c: ("" if r.get(c) is None else r.get(c)) for c in COLUMNAS})


def exportar_tsv(registros, ruta):
    os.makedirs(os.path.dirname(ruta) or ".", exist_ok=True)
    with open(ruta, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=COLUMNAS, delimiter="\t")
        writer.writeheader()
        for r in registros:
            writer.writerow({c: ("" if r.get(c) is None else r.get(c)) for c in COLUMNAS})


def exportar_json(registros, ruta):
    os.makedirs(os.path.dirname(ruta) or ".", exist_ok=True)
    with open(ruta, "w", encoding="utf-8") as f:
        json.dump(registros, f, ensure_ascii=False, indent=2)


def importar_csv(ruta):
    importados = 0
    errores = []
    with open(ruta, "r", newline="", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        encabezados = reader.fieldnames or []
        # Normalizar encabezados (quitar espacios)
        encabezados_norm = [h.strip() for h in encabezados]
        esperados = set(COLUMNAS)
        recibidos = set(encabezados_norm)
        faltantes = esperados - recibidos
        extras = recibidos - esperados
        if faltantes or extras:
            msg = "La estructura del CSV no coincide con la base de datos."
            if faltantes:
                msg += f" Faltan columnas: {', '.join(sorted(faltantes))}."
            if extras:
                msg += f" Columnas no reconocidas: {', '.join(sorted(extras))}."
            msg += f" Se esperan: {', '.join(COLUMNAS)}."
            raise ValueError(msg)

        # Re-mapear filas con encabezados normalizados
        for idx, row in enumerate(reader, start=2):  # 1 es encabezado
            # limpiar claves
            row_limpia = { (k.strip() if k else k): v for k, v in row.items() }
            try:
                data = normalizar_registro(row_limpia)
                insertar_o_reemplazar(data)
                importados += 1
            except Exception as e:
                errores.append(f"Fila {idx}: {e}")
    return importados, errores
