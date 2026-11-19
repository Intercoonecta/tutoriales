# Aplicación CRUD de Mediciones (Tkinter + SQLite)

Aplicación de escritorio en **Python (Tkinter)** para gestionar mediciones/estaciones mediante un CRUD con base de datos **SQLite**, con visualización gráfica de coordenadas y opciones de importación/exportación de datos desde un **menú**.

## Objetivo y alcance (lo planeado)

Se planificó e implementó una aplicación gráfica que cumple con lo siguiente:

- **CRUD con SQLite** para almacenar los datos:
  - `id` (clave primaria, autoincremental)
  - `id_estacion`
  - `fecha`
  - `latitud`
  - `longitud`
  - `temperatura`
  - `pH`
  - `clorofila`
  - `especie`
- **Interfaz gráfica con Tkinter** y **barra de menú** donde se muestran las opciones.
- **Menú CRUD (Registros)** con opciones para crear, listar/refrescar, editar y eliminar registros.
- **Imagen de coordenadas**: genera una gráfica de dispersión con las coordenadas (`longitud`, `latitud`) de los datos y permite **elegir el campo a mostrar** (codificado por color/leyenda según el campo seleccionado).
- **Exportación de datos** (según los datos de la base) mediante opciones de menú:
  - Exportar a **CSV**
  - Exportar a **JSON**
  - Exportar a **TSV**
- **Importación/alimentación de la base de datos** desde un archivo **CSV** que respete la estructura de la base de datos.

## Estructura del proyecto

```text
captura/
├── app.py         # Interfaz gráfica (Tkinter), barra de menú y lógica de interacción
├── db.py          # Conexión SQLite, creación de tabla y operaciones CRUD
├── io_datos.py    # Importación (CSV) y exportación (CSV, JSON, TSV)
├── grafico.py     # Generación de la imagen/gráfica de coordenadas (matplotlib)
├── mediciones.db  # Base de datos SQLite (se crea automáticamente al iniciar)
├── exports/       # Carpeta sugerida para archivos exportados/imágenes
└── Readme.md      # Este documento (plan y uso)
```

## Base de datos

- Motor: **SQLite** (archivo `mediciones.db` en el directorio de la aplicación).
- La tabla se crea automáticamente al iniciar si no existe.

Esquema de la tabla `mediciones`:

| Campo        | Tipo    | Descripción |
|--------------|---------|-------------|
| `id`         | INTEGER | Clave primaria, autoincremental |
| `id_estacion`| TEXT    | Identificador/código de la estación |
| `fecha`      | TEXT    | Fecha de la medición (p. ej. `YYYY-MM-DD` o `YYYY-MM-DDTHH:MM`) |
| `latitud`    | REAL    | Latitud (coordenada) |
| `longitud`   | REAL    | Longitud (coordenada) |
| `temperatura`| REAL    | Temperatura |
| `pH`         | REAL    | pH |
| `clorofila`  | REAL    | Clorofila |
| `especie`    | TEXT    | Especie |

## Menú de la aplicación

La aplicación presenta una **barra de menú** con las siguientes opciones:

### Archivo
- **Importar desde CSV...**: alimenta la base de datos desde un archivo CSV que respete la estructura de la BD.
- **Exportar a CSV...**: genera un archivo CSV con los datos actuales.
- **Exportar a JSON...**: genera un archivo JSON con los datos actuales.
- **Exportar a TSV...**: genera un archivo TSV con los datos actuales.
- **Salir**: cierra la aplicación.

### Registros (CRUD)
- **Nuevo...**: crea un nuevo registro (formulario con los campos).
- **Editar...**: actualiza el registro seleccionado en la tabla.
- **Eliminar**: elimina el registro seleccionado (con confirmación).
- **Refrescar**: recarga/consulta los registros desde la base de datos y actualiza la tabla.

### Visualización
- **Generar imagen de coordenadas...**: solicita elegir el campo a mostrar y genera la imagen de coordenadas.

## Funcionalidades

### CRUD
- **Crear**: alta de registros mediante formulario.
- **Leer**: listado de todos los registros en una tabla dentro de la ventana principal.
- **Actualizar**: edición del registro seleccionado (doble clic o menú *Editar...*).
- **Eliminar**: borrado del registro seleccionado con confirmación.
- Validaciones básicas: campos obligatorios (`ID Estación`, `Fecha`, `Latitud`, `Longitud`), valores numéricos válidos y rangos de coordenadas (latitud −90 a 90, longitud −180 a 180).

### Imagen de coordenadas (campo elegible)
- Se grafica una **dispersión** con:
  - Eje X: `longitud`
  - Eje Y: `latitud`
- El usuario **elige el campo a mostrar** (p. ej. `temperatura`, `pH`, `clorofila`, `especie`, `id_estacion`, `fecha`, `latitud`, `longitud`).
  - Campos numéricos: se representan mediante **color** con barra de color (escala).
  - Campos categóricos/texto: se representan mediante **colores y leyenda por categoría**.
- La imagen se muestra en una ventana dentro de la aplicación y puede **guardarse** como archivo PNG.

### Exportación (CSV, JSON, TSV)
- Exporta los registros actuales de la base de datos a la ruta elegida por el usuario.
- **CSV**: encabezados y valores separados por comas.
- **TSV**: encabezados y valores separados por tabulaciones.
- **JSON**: lista de objetos con la estructura de los campos.
- Columnas/estructura exportada: `id, id_estacion, fecha, latitud, longitud, temperatura, pH, clorofila, especie`.

### Importación desde CSV
- Permite seleccionar un archivo CSV para **alimentar la base de datos**.
- El archivo debe **respetar la estructura** de la base de datos, incluyendo la fila de encabezados con las columnas:
  - `id,id_estacion,fecha,latitud,longitud,temperatura,pH,clorofila,especie`
- Comportamiento:
  - Valida que los encabezados coincidan con la estructura esperada.
  - Convierte valores numéricos y acepta celdas vacías como `NULL` en campos numéricos/texto opcionales.
  - Si la columna `id` viene con valor, se inserta/reemplaza respetando ese `id` (`INSERT OR REPLACE`); si viene vacía, se genera un `id` autoincremental.
  - Muestra un resumen con cantidad de registros importados y errores por fila (si los hubiera).

## Supuestos adoptados

Dado que algunos detalles no se especificaron, se adoptaron los siguientes supuestos razonables:

- **Tipo de campos**: `id_estacion`, `fecha` y `especie` como texto; mediciones y coordenadas como numéricos (`REAL`).
- **Obligatorios**: `id_estacion`, `fecha`, `latitud`, `longitud`. El resto (`temperatura`, `pH`, `clorofila`, `especie`) pueden quedar vacíos.
- **Fecha**: almacenada como texto flexible (recomendado `YYYY-MM-DD`).
- **Exportación**: el usuario elige nombre y ubicación del archivo en cada exportación.
- **Imagen**: se genera como dispersión longitud/latitud coloreada por el campo elegido; se puede visualizar y guardar como PNG.
- **Importación**: CSV con encabezados obligatorios iguales a la estructura de la BD; filas inválidas se reportan y no detienen la importación del resto.

## Requisitos

- **Python 3.x** con **Tkinter** (`tkinter`, `ttk`) disponible.
- Módulos estándar: `sqlite3`, `csv`, `json`, `os`.
- **matplotlib** (para la generación de la imagen de coordenadas). En entornos gráficos permite incrustar y guardar la figura.
- Entorno con soporte de interfaz gráfica (display) para mostrar las ventanas de Tkinter.

## Ejecución

Desde el directorio del proyecto:

```bash
cd captura
python app.py
```

(o `python3 app.py` según el entorno).

Al iniciar, se crea automáticamente `mediciones.db` (si no existe) y se abre la ventana principal con la barra de menú y el listado de registros.
