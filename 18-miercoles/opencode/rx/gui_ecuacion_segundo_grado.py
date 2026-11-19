import sys
import tkinter as tk
from pathlib import Path
from tkinter import messagebox

# Permite importar el módulo desde el mismo directorio del script.
sys.path.insert(0, str(Path(__file__).resolve().parent))

from ecuacion_segundo_grado import formatear_numero, resolver_ecuacion_segundo_grado


def parsear_coeficiente(texto):
    """Convierte un texto a float, aceptando coma como separador decimal."""
    texto = texto.strip().replace(",", ".")
    if texto == "":
        raise ValueError("vacío")
    return float(texto)


def formatear_termino(coeficiente, variable, es_primero=False):
    """Formatea un término de un polinomio para mostrarlo en la ecuación."""
    if abs(coeficiente) < 1e-12:
        return ""

    signo = "-" if coeficiente < 0 else "+"
    valor_abs = abs(coeficiente)

    # Evita mostrar 1 como coeficiente (excepto término independiente)
    if variable and abs(valor_abs - 1.0) < 1e-12:
        coef_texto = ""
    else:
        coef_texto = formatear_numero(valor_abs)

    termino = f"{coef_texto}{variable}"

    if es_primero:
        return f"-{termino}" if signo == "-" else termino
    return f" {signo} {termino}"


def formatear_ecuacion(a, b, c):
    """Construye una representación legible de la ecuación Ax^2 + Bx + C = 0."""
    partes = []
    partes.append(formatear_termino(a, "x²", es_primero=True))
    partes.append(formatear_termino(b, "x", es_primero=(len(partes[0]) == 0)))
    partes.append(formatear_termino(c, "", es_primero=(all(p == "" for p in partes))))

    ecuacion = "".join(partes).strip()
    if ecuacion == "":
        ecuacion = "0"
    return f"{ecuacion} = 0"


class AplicacionEcuacionSegundoGrado:
    def __init__(self, root):
        self.root = root
        self.root.title("Resolución de ecuación de segundo grado")
        self.root.resizable(False, False)

        self._construir_interfaz()

    def _construir_interfaz(self):
        padding = {"padx": 10, "pady": 6}

        titulo = tk.Label(
            self.root,
            text="Resolución de la ecuación Ax² + Bx + C = 0",
            font=("TkDefaultFont", 11, "bold"),
        )
        titulo.grid(row=0, column=0, columnspan=2, padx=10, pady=(12, 8))

        frame_entrada = tk.LabelFrame(self.root, text="Coeficientes")
        frame_entrada.grid(row=1, column=0, columnspan=2, sticky="ew", **padding)

        self.entrada_a = self._crear_campo(frame_entrada, "A (x²):", 0)
        self.entrada_b = self._crear_campo(frame_entrada, "B (x):", 1)
        self.entrada_c = self._crear_campo(frame_entrada, "C:", 2)

        frame_botones = tk.Frame(self.root)
        frame_botones.grid(row=2, column=0, columnspan=2, pady=(4, 8))

        btn_resolver = tk.Button(frame_botones, text="Resolver", width=12, command=self.resolver)
        btn_resolver.grid(row=0, column=0, padx=6)

        btn_limpiar = tk.Button(frame_botones, text="Limpiar", width=12, command=self.limpiar)
        btn_limpiar.grid(row=0, column=1, padx=6)

        frame_resultado = tk.LabelFrame(self.root, text="Resultado")
        frame_resultado.grid(row=3, column=0, columnspan=2, sticky="ew", padx=10, pady=(0, 12))

        self.var_ecuacion = tk.StringVar(value="-")
        self.var_tipo = tk.StringVar(value="-")
        self.var_mensaje = tk.StringVar(value="-")
        self.var_discriminante = tk.StringVar(value="-")
        self.var_soluciones = tk.StringVar(value="-")

        self._crear_fila_resultado(frame_resultado, "Ecuación:", self.var_ecuacion, 0)
        self._crear_fila_resultado(frame_resultado, "Tipo:", self.var_tipo, 1)
        self._crear_fila_resultado(frame_resultado, "Mensaje:", self.var_mensaje, 2)
        self._crear_fila_resultado(frame_resultado, "Discriminante:", self.var_discriminante, 3)
        self._crear_fila_resultado(frame_resultado, "Soluciones:", self.var_soluciones, 4)

        self.root.bind("<Return>", lambda _event: self.resolver())
        self.entrada_a.focus_set()

    def _crear_campo(self, parent, etiqueta, fila):
        tk.Label(parent, text=etiqueta, width=10, anchor="w").grid(
            row=fila, column=0, padx=8, pady=4, sticky="w"
        )
        entrada = tk.Entry(parent, width=20)
        entrada.grid(row=fila, column=1, padx=8, pady=4, sticky="w")
        return entrada

    def _crear_fila_resultado(self, parent, etiqueta, variable, fila):
        tk.Label(parent, text=etiqueta, width=14, anchor="w").grid(
            row=fila, column=0, padx=8, pady=3, sticky="nw"
        )
        tk.Label(
            parent,
            textvariable=variable,
            anchor="w",
            justify="left",
            wraplength=320,
        ).grid(row=fila, column=1, padx=8, pady=3, sticky="w")

    def resolver(self):
        try:
            a = parsear_coeficiente(self.entrada_a.get())
            b = parsear_coeficiente(self.entrada_b.get())
            c = parsear_coeficiente(self.entrada_c.get())
        except ValueError:
            messagebox.showerror(
                "Entrada no válida",
                "Por favor, ingrese valores numéricos válidos para A, B y C.\n"
                "Puede usar punto o coma como separador decimal.",
            )
            return

        resultado = resolver_ecuacion_segundo_grado(a, b, c)

        self.var_ecuacion.set(formatear_ecuacion(a, b, c))
        self.var_tipo.set(resultado.get("tipo", "-"))
        self.var_mensaje.set(resultado.get("mensaje", "-"))

        if "discriminante" in resultado:
            self.var_discriminante.set(formatear_numero(resultado["discriminante"]))
        else:
            self.var_discriminante.set("No aplica")

        soluciones = resultado.get("soluciones")
        if soluciones is None:
            self.var_soluciones.set("No hay solución única/finita")
        elif len(soluciones) == 1:
            self.var_soluciones.set(f"x = {formatear_numero(soluciones[0])}")
        else:
            self.var_soluciones.set(
                f"x₁ = {formatear_numero(soluciones[0])}\n"
                f"x₂ = {formatear_numero(soluciones[1])}"
            )

    def limpiar(self):
        self.entrada_a.delete(0, tk.END)
        self.entrada_b.delete(0, tk.END)
        self.entrada_c.delete(0, tk.END)

        self.var_ecuacion.set("-")
        self.var_tipo.set("-")
        self.var_mensaje.set("-")
        self.var_discriminante.set("-")
        self.var_soluciones.set("-")

        self.entrada_a.focus_set()


def main():
    root = tk.Tk()
    AplicacionEcuacionSegundoGrado(root)
    root.mainloop()


if __name__ == "__main__":
    main()
