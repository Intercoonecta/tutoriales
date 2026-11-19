# Resolución de ecuaciones de segundo grado

Programa en Python para resolver la ecuación:

\[
Ax^2 + Bx + C = 0
\]

a partir de sus coeficientes `A`, `B` y `C`, disponible en dos modalidades:

- **Consola (CLI):** [`ecuacion_segundo_grado.py`](ecuacion_segundo_grado.py)
- **Interfaz gráfica (Tkinter):** [`gui_ecuacion_segundo_grado.py`](gui_ecuacion_segundo_grado.py)

## Descripción

La lógica de resolución está implementada en la función `resolver_ecuacion_segundo_grado(a, b, c)`, que analiza los coeficientes recibidos y determina el tipo de ecuación y sus soluciones, contemplando todos los casos posibles. La interfaz gráfica reutiliza esta misma lógica para mostrar los resultados.

## Casos contemplados

### 1. Caso no cuadrático (`A == 0`)

Cuando `A` es igual a `0`, la ecuación no es de segundo grado y se evalúan las siguientes situaciones:

- **`B == 0` y `C == 0`**: la ecuación se reduce a `0 = 0`.
  - **Resultado:** infinitas soluciones.
- **`B == 0` y `C != 0`**: la ecuación es inconsistente (por ejemplo, `5 = 0`).
  - **Resultado:** sin solución.
- **`B != 0`**: la ecuación es lineal (`Bx + C = 0`).
  - **Resultado:** una solución única: \(x = -C/B\).

### 2. Caso cuadrático (`A != 0`)

Cuando `A` es distinto de `0`, se calcula el discriminante:

\[
D = B^2 - 4AC
\]

Según el valor de `D`, se distinguen tres casos:

- **`D > 0`**: dos soluciones reales distintas.
  - \(x_1 = \frac{-B + \sqrt{D}}{2A}\)
  - \(x_2 = \frac{-B - \sqrt{D}}{2A}\)
- **`D == 0`**: una solución real doble.
  - \(x = \frac{-B}{2A}\)
- **`D < 0`**: dos soluciones complejas conjugadas.
  - \(x_{1,2} = \frac{-B}{2A} \pm i\frac{\sqrt{-D}}{2A}\)

## Estructura del programa

- [`ecuacion_segundo_grado.py`](ecuacion_segundo_grado.py): módulo con la lógica de resolución y la interfaz de consola.
  - `resolver_ecuacion_segundo_grado(a, b, c)`: recibe los coeficientes y devuelve un diccionario con:
    - `tipo`: clasificación del caso.
    - `mensaje`: descripción del resultado.
    - `soluciones`: tupla con las raíces, o `None` si no hay solución única/finita.
    - `discriminante`: incluido en los casos cuadráticos.
  - `mostrar_resultado(resultado)`: imprime el resultado de forma legible.
  - `formatear_numero(valor)`: formatea números reales y complejos para su visualización.
  - `leer_coeficiente(nombre)`: solicita y valida un coeficiente desde la entrada estándar.
  - `main()`: punto de entrada para la ejecución interactiva en consola.
- [`gui_ecuacion_segundo_grado.py`](gui_ecuacion_segundo_grado.py): aplicación gráfica con Tkinter.
  - Campos de entrada para los coeficientes `A`, `B` y `C` (acepta punto o coma decimal).
  - Botones **Resolver** y **Limpiar** (también permite resolver con `Enter`).
  - Visualización de la ecuación ingresada, tipo de caso, mensaje, discriminante y soluciones.
  - Validación de entradas con mensajes de error cuando los coeficientes no son numéricos.

### Valores posibles de `tipo`

- `degenerada`: infinitas soluciones (`A = 0`, `B = 0`, `C = 0`).
- `incompatible`: sin solución (`A = 0`, `B = 0`, `C != 0`).
- `lineal`: ecuación lineal con una solución (`A = 0`, `B != 0`).
- `cuadratica_dos_reales`: dos soluciones reales distintas (`A != 0`, `D > 0`).
- `cuadratica_real_doble`: una solución real doble (`A != 0`, `D == 0`).
- `cuadratica_complejas`: dos soluciones complejas conjugadas (`A != 0`, `D < 0`).

## Requisitos

- Python 3.x
- Módulos estándar: `math` y `cmath` (incluidos en Python)
- Para la interfaz gráfica: `tkinter`
  - En algunas distribuciones Linux puede ser necesario instalar el paquete del sistema, por ejemplo: `python3-tk`

## Uso

### Ejecución en consola (CLI)

Desde el directorio `rx`:

```bash
python3 ecuacion_segundo_grado.py
```

El programa solicitará los coeficientes `A`, `B` y `C` y mostrará el resultado.

### Ejecución en modo gráfico (Tkinter)

Desde el directorio `rx`:

```bash
python3 gui_ecuacion_segundo_grado.py
```

Se abrirá una ventana donde podrás ingresar `A`, `B` y `C`, resolver la ecuación y ver el tipo de solución, el discriminante (cuando aplique) y las raíces.

### Uso programático

También puedes importar la función y pasarle los coeficientes directamente:

```python
from ecuacion_segundo_grado import resolver_ecuacion_segundo_grado, mostrar_resultado

resultado = resolver_ecuacion_segundo_grado(1, -3, 2)  # A=1, B=-3, C=2
mostrar_resultado(resultado)

# Acceso directo a los datos devueltos
print(resultado["tipo"])
print(resultado["mensaje"])
print(resultado.get("discriminante"))
print(resultado["soluciones"])
```

## Ejemplos

| Ecuación | Coeficientes (A, B, C) | Resultado |
|---|---:|---|
| \(x^2 - 3x + 2 = 0\) | (1, -3, 2) | Dos soluciones reales: `x1 = 2`, `x2 = 1` |
| \(x^2 + 2x + 1 = 0\) | (1, 2, 1) | Solución real doble: `x = -1` |
| \(x^2 + 1 = 0\) | (1, 0, 1) | Dos soluciones complejas: `0 + 1i`, `0 - 1i` |
| \(2x - 4 = 0\) | (0, 2, -4) | Ecuación lineal: `x = 2` |
| \(0 = 0\) | (0, 0, 0) | Infinitas soluciones |
| \(5 = 0\) | (0, 0, 5) | Sin solución |
