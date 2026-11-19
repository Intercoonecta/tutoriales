import os
import sqlite3

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(BASE_DIR, "mediciones.db")

COLUMNAS = [
    "id",
    "id_estacion",
    "fecha",
    "latitud",
    "longitud",
    "temperatura",
    "pH",
    "clorofila",
    "especie",
]

CAMPOS_DATOS = [c for c in COLUMNAS if c != "id"]


def get_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db():
    conn = get_connection()
    try:
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS mediciones (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                id_estacion TEXT,
                fecha TEXT,
                latitud REAL,
                longitud REAL,
                temperatura REAL,
                "pH" REAL,
                clorofila REAL,
                especie TEXT
            )
            """
        )
        conn.commit()
    finally:
        conn.close()


def _row_to_dict(row):
    if row is None:
        return None
    return {k: row[k] for k in COLUMNAS}


def obtener_todos():
    conn = get_connection()
    try:
        rows = conn.execute(
            "SELECT id, id_estacion, fecha, latitud, longitud, temperatura, \"pH\", clorofila, especie "
            "FROM mediciones ORDER BY id"
        ).fetchall()
        return [_row_to_dict(r) for r in rows]
    finally:
        conn.close()


def obtener_por_id(registro_id):
    conn = get_connection()
    try:
        row = conn.execute(
            "SELECT id, id_estacion, fecha, latitud, longitud, temperatura, \"pH\", clorofila, especie "
            "FROM mediciones WHERE id = ?",
            (registro_id,),
        ).fetchone()
        return _row_to_dict(row)
    finally:
        conn.close()


def crear_registro(data):
    conn = get_connection()
    try:
        cur = conn.execute(
            """
            INSERT INTO mediciones (id_estacion, fecha, latitud, longitud, temperatura, "pH", clorofila, especie)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                data.get("id_estacion"),
                data.get("fecha"),
                data.get("latitud"),
                data.get("longitud"),
                data.get("temperatura"),
                data.get("pH"),
                data.get("clorofila"),
                data.get("especie"),
            ),
        )
        conn.commit()
        return cur.lastrowid
    finally:
        conn.close()


def actualizar_registro(registro_id, data):
    conn = get_connection()
    try:
        cur = conn.execute(
            """
            UPDATE mediciones
            SET id_estacion = ?, fecha = ?, latitud = ?, longitud = ?,
                temperatura = ?, "pH" = ?, clorofila = ?, especie = ?
            WHERE id = ?
            """,
            (
                data.get("id_estacion"),
                data.get("fecha"),
                data.get("latitud"),
                data.get("longitud"),
                data.get("temperatura"),
                data.get("pH"),
                data.get("clorofila"),
                data.get("especie"),
                registro_id,
            ),
        )
        conn.commit()
        return cur.rowcount
    finally:
        conn.close()


def eliminar_registro(registro_id):
    conn = get_connection()
    try:
        cur = conn.execute("DELETE FROM mediciones WHERE id = ?", (registro_id,))
        conn.commit()
        return cur.rowcount
    finally:
        conn.close()


def insertar_o_reemplazar(data):
    """Inserta un registro. Si 'id' viene informado, hace INSERT OR REPLACE."""
    conn = get_connection()
    try:
        reg_id = data.get("id")
        if reg_id is None or reg_id == "":
            cur = conn.execute(
                """
                INSERT INTO mediciones (id_estacion, fecha, latitud, longitud, temperatura, "pH", clorofila, especie)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    data.get("id_estacion"),
                    data.get("fecha"),
                    data.get("latitud"),
                    data.get("longitud"),
                    data.get("temperatura"),
                    data.get("pH"),
                    data.get("clorofila"),
                    data.get("especie"),
                ),
            )
        else:
            cur = conn.execute(
                """
                INSERT OR REPLACE INTO mediciones (id, id_estacion, fecha, latitud, longitud, temperatura, "pH", clorofila, especie)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    int(reg_id),
                    data.get("id_estacion"),
                    data.get("fecha"),
                    data.get("latitud"),
                    data.get("longitud"),
                    data.get("temperatura"),
                    data.get("pH"),
                    data.get("clorofila"),
                    data.get("especie"),
                ),
            )
        conn.commit()
        return cur.lastrowid
    finally:
        conn.close()
