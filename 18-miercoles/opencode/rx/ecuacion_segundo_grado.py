import math
import cmath


def resolver_ecuacion_segundo_grado(a, b, c):
    """
    Resuelve la ecuación Ax^2 + Bx + C = 0 a partir de sus coeficientes.

    Parámetros:
        a (float): Coeficiente de x^2.
        b (float): Coeficiente de x.
        c (float): Término independiente.

    Retorna:
        dict: Un diccionario con el tipo de ecuación/solución y las raíces o mensaje.
    """
    # Caso 1: No es una ecuación de segundo grado (A == 0)
    if a == 0:
        if b == 0:
            if c == 0:
                return {
                    "tipo": "degenerada",
                    "mensaje": "Infinitas soluciones (0 = 0).",
                    "soluciones": None,
                }
            else:
                return {
                    "tipo": "incompatible",
                    "mensaje": "Sin solución (la ecuación es inconsistente).",
                    "soluciones": None,
                }
        else:
            # Ecuación lineal: Bx + C = 0 -> x = -C/B
            x = -c / b
            return {
                "tipo": "lineal",
                "mensaje": "Ecuación lineal (A = 0).",
                "soluciones": (x,),
            }

    # Caso 2: Ecuación de segundo grado (A != 0)
    discriminante = b**2 - 4 * a * c

    if discriminante > 0:
        # Dos raíces reales distintas
        raiz_discriminante = math.sqrt(discriminante)
        x1 = (-b + raiz_discriminante) / (2 * a)
        x2 = (-b - raiz_discriminante) / (2 * a)
        return {
            "tipo": "cuadratica_dos_reales",
            "mensaje": "Dos soluciones reales distintas.",
            "discriminante": discriminante,
            "soluciones": (x1, x2),
        }

    elif discriminante == 0:
        # Una raíz real doble
        x = -b / (2 * a)
        return {
            "tipo": "cuadratica_real_doble",
            "mensaje": "Una solución real doble.",
            "discriminante": discriminante,
            "soluciones": (x, x),
        }

    else:
        # Dos raíces complejas conjugadas
        parte_real = -b / (2 * a)
        parte_imaginaria = math.sqrt(-discriminante) / (2 * a)
        x1 = complex(parte_real, parte_imaginaria)
        x2 = complex(parte_real, -parte_imaginaria)
        return {
            "tipo": "cuadratica_complejas",
            "mensaje": "Dos soluciones complejas conjugadas.",
            "discriminante": discriminante,
            "soluciones": (x1, x2),
        }


def formatear_numero(valor):
    """Formatea un número para mostrarlo de forma legible."""
    if isinstance(valor, complex):
        real = valor.real
        imag = valor.imag
        signo = "+" if imag >= 0 else "-"
        return f"{real:.6g} {signo} {abs(imag):.6g}i"
    if isinstance(valor, float):
        # Evita mostrar -0.0
        if abs(valor) < 1e-12:
            valor = 0.0
        return f"{valor:.6g}"
    return str(valor)


def mostrar_resultado(resultado):
    """Imprime el resultado de la resolución de forma clara."""
    print(f"Tipo: {resultado['tipo']}")
    print(f"Mensaje: {resultado['mensaje']}")

    if "discriminante" in resultado:
        print(f"Discriminante: {formatear_numero(resultado['discriminante'])}")

    soluciones = resultado.get("soluciones")
    if soluciones is None:
        return

    if len(soluciones) == 1:
        print(f"Solución: x = {formatear_numero(soluciones[0])}")
    else:
        print(f"Solución 1: x1 = {formatear_numero(soluciones[0])}")
        print(f"Solución 2: x2 = {formatear_numero(soluciones[1])}")


def leer_coeficiente(nombre):
    """Lee un coeficiente numérico desde la entrada estándar."""
    while True:
        entrada = input(f"Ingrese el coeficiente {nombre}: ").strip().replace(",", ".")
        try:
            return float(entrada)
        except ValueError:
            print("Entrada no válida. Por favor, ingrese un número (ejemplo: 2, -3.5).")


def main():
    print("Resolución de la ecuación Ax^2 + Bx + C = 0")
    print("-" * 45)

    a = leer_coeficiente("A")
    b = leer_coeficiente("B")
    c = leer_coeficiente("C")

    print()
    resultado = resolver_ecuacion_segundo_grado(a, b, c)
    mostrar_resultado(resultado)


if __name__ == "__main__":
    main()
