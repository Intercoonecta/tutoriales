import os
import tkinter as tk
from tkinter import ttk, messagebox, filedialog

import db
import io_datos
import grafico

BASE_DIR = os.path.dirname(os.path.abspath(__file__))


def _parse_texto(valor, obligatorio=False, nombre="campo"):
    v = (valor or "").strip()
    if v == "":
        if obligatorio:
            raise ValueError(f"El campo '{nombre}' es obligatorio.")
        return None
    return v


def _parse_float(valor, obligatorio=False, nombre="campo"):
    v = (valor or "").strip()
    if v == "":
        if obligatorio:
            raise ValueError(f"El campo '{nombre}' es obligatorio.")
        return None
    v = v.replace(",", ".")
    try:
        return float(v)
    except ValueError:
        raise ValueError(f"El campo '{nombre}' debe ser un número válido.")


class FormularioRegistro(tk.Toplevel):
    CAMPOS = [
        ("ID Estación", "id_estacion", "texto", True),
        ("Fecha", "fecha", "texto", True),
        ("Latitud", "latitud", "float", True),
        ("Longitud", "longitud", "float", True),
        ("Temperatura", "temperatura", "float", False),
        ("pH", "pH", "float", False),
        ("Clorofila", "clorofila", "float", False),
        ("Especie", "especie", "texto", False),
    ]

    def __init__(self, parent, titulo, on_save, registro=None):
        super().__init__(parent)
        self.title(titulo)
        self.resizable(False, False)
        self.transient(parent)
        self.grab_set()
        self.on_save = on_save
        self.vars = {}

        frm = ttk.Frame(self, padding=12)
        frm.grid(row=0, column=0, sticky="nsew")

        for i, (etiqueta, key, _tipo, obligatorio) in enumerate(self.CAMPOS):
            suf = " *" if obligatorio else ""
            ttk.Label(frm, text=f"{etiqueta}{suf}:").grid(row=i, column=0, sticky="w", padx=4, pady=4)
            var = tk.StringVar()
            if registro is not None:
                val = registro.get(key)
                var.set("" if val is None else str(val))
            self.vars[key] = var
            ttk.Entry(frm, textvariable=var, width=32).grid(row=i, column=1, sticky="ew", padx=4, pady=4)

        nota = ttk.Label(frm, text="* Campos obligatorios. Use punto o coma decimal.", foreground="gray")
        nota.grid(row=len(self.CAMPOS), column=0, columnspan=2, sticky="w", padx=4, pady=(4, 8))

        btns = ttk.Frame(frm)
        btns.grid(row=len(self.CAMPOS) + 1, column=0, columnspan=2, sticky="e")
        ttk.Button(btns, text="Guardar", command=self._guardar).pack(side="left", padx=4)
        ttk.Button(btns, text="Cancelar", command=self.destroy).pack(side="left", padx=4)

        self.bind("<Return>", lambda e: self._guardar())
        self.bind("<Escape>", lambda e: self.destroy())
        self.protocol("WM_DELETE_WINDOW", self.destroy)

    def _guardar(self):
        try:
            data = {}
            for _etiqueta, key, tipo, obligatorio in self.CAMPOS:
                nombre = _etiqueta
                if tipo == "texto":
                    data[key] = _parse_texto(self.vars[key].get(), obligatorio, nombre)
                else:
                    data[key] = _parse_float(self.vars[key].get(), obligatorio, nombre)

            # Validaciones adicionales
            if data["latitud"] is not None and not (-90 <= data["latitud"] <= 90):
                raise ValueError("La latitud debe estar entre -90 y 90.")
            if data["longitud"] is not None and not (-180 <= data["longitud"] <= 180):
                raise ValueError("La longitud debe estar entre -180 y 180.")
        except ValueError as e:
            messagebox.showerror("Validación", str(e), parent=self)
            return

        try:
            self.on_save(data)
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo guardar el registro:\n{e}", parent=self)
            return
        self.destroy()


class VentanaImagen(tk.Toplevel):
    def __init__(self, parent, fig, titulo="Imagen de coordenadas"):
        super().__init__(parent)
        self.title(titulo)
        self.geometry("900x650")
        self.fig = fig

        cont = ttk.Frame(self)
        cont.pack(fill="both", expand=True)

        try:
            from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk
            canvas = FigureCanvasTkAgg(fig, master=cont)
            canvas.draw()
            toolbar = NavigationToolbar2Tk(canvas, cont, pack_toolbar=False)
            toolbar.update()
            toolbar.pack(side="bottom", fill="x")
            canvas.get_tk_widget().pack(side="top", fill="both", expand=True)
            self._canvas = canvas
        except Exception as e:
            ttk.Label(cont, text=f"No se pudo mostrar la imagen embebida:\n{e}").pack(padx=10, pady=10)

        btns = ttk.Frame(self, padding=6)
        btns.pack(fill="x")
        ttk.Button(btns, text="Guardar imagen...", command=self._guardar).pack(side="left", padx=4)
        ttk.Button(btns, text="Cerrar", command=self.destroy).pack(side="right", padx=4)

    def _guardar(self):
        ruta = filedialog.asksaveasfilename(
            parent=self,
            title="Guardar imagen",
            defaultextension=".png",
            initialdir=os.path.join(BASE_DIR, "exports"),
            initialfile="coordenadas.png",
            filetypes=[("Imagen PNG", "*.png"), ("Todos los archivos", "*.*")],
        )
        if not ruta:
            return
        try:
            grafico.guardar_figura(self.fig, ruta)
            messagebox.showinfo("Imagen guardada", f"Imagen guardada en:\n{ruta}", parent=self)
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo guardar la imagen:\n{e}", parent=self)


class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Captura de mediciones - CRUD (SQLite)")
        self.geometry("1100x520")
        self.minsize(900, 420)

        self._crear_menu()
        self._crear_tabla()
        self._crear_barra_estado()

        self.refrescar()

    # -------------------- UI --------------------
    def _crear_menu(self):
        menubar = tk.Menu(self)

        # Archivo
        menu_archivo = tk.Menu(menubar, tearoff=0)
        menu_archivo.add_command(label="Importar desde CSV...", command=self.importar_csv)
        menu_archivo.add_separator()
        menu_archivo.add_command(label="Exportar a CSV...", command=self.exportar_csv)
        menu_archivo.add_command(label="Exportar a JSON...", command=self.exportar_json)
        menu_archivo.add_command(label="Exportar a TSV...", command=self.exportar_tsv)
        menu_archivo.add_separator()
        menu_archivo.add_command(label="Salir", command=self.destroy)
        menubar.add_cascade(label="Archivo", menu=menu_archivo)

        # Registros (CRUD)
        menu_reg = tk.Menu(menubar, tearoff=0)
        menu_reg.add_command(label="Nuevo...", command=self.nuevo_registro)
        menu_reg.add_command(label="Editar...", command=self.editar_registro)
        menu_reg.add_command(label="Eliminar", command=self.eliminar_registro)
        menu_reg.add_separator()
        menu_reg.add_command(label="Refrescar", command=self.refrescar)
        menubar.add_cascade(label="Registros", menu=menu_reg)

        # Visualización
        menu_vis = tk.Menu(menubar, tearoff=0)
        menu_vis.add_command(label="Generar imagen de coordenadas...", command=self.generar_imagen)
        menubar.add_cascade(label="Visualización", menu=menu_vis)

        self.config(menu=menubar)

    def _crear_tabla(self):
        cont = ttk.Frame(self, padding=8)
        cont.pack(fill="both", expand=True)

        columnas = db.COLUMNAS
        self.tree = ttk.Treeview(cont, columns=columnas, show="headings", selectmode="browse")
        encabezados = {
            "id": ("ID", 50),
            "id_estacion": ("ID Estación", 110),
            "fecha": ("Fecha", 110),
            "latitud": ("Latitud", 90),
            "longitud": ("Longitud", 90),
            "temperatura": ("Temperatura", 100),
            "pH": ("pH", 70),
            "clorofila": ("Clorofila", 90),
            "especie": ("Especie", 140),
        }
        for col in columnas:
            texto, ancho = encabezados.get(col, (col, 90))
            self.tree.heading(col, text=texto)
            self.tree.column(col, width=ancho, anchor="center", stretch=True)

        vsb = ttk.Scrollbar(cont, orient="vertical", command=self.tree.yview)
        hsb = ttk.Scrollbar(cont, orient="horizontal", command=self.tree.xview)
        self.tree.configure(yscrollcommand=vsb.set, xscrollcommand=hsb.set)

        self.tree.grid(row=0, column=0, sticky="nsew")
        vsb.grid(row=0, column=1, sticky="ns")
        hsb.grid(row=1, column=0, sticky="ew")
        cont.rowconfigure(0, weight=1)
        cont.columnconfigure(0, weight=1)

        self.tree.bind("<Double-1>", lambda e: self.editar_registro())

    def _crear_barra_estado(self):
        self.estado_var = tk.StringVar(value="Listo.")
        barra = ttk.Label(self, textvariable=self.estado_var, relief="sunken", anchor="w", padding=(6, 2))
        barra.pack(side="bottom", fill="x")

    def _set_estado(self, msg):
        self.estado_var.set(msg)

    # -------------------- Utilidades --------------------
    def _id_seleccionado(self):
        sel = self.tree.selection()
        if not sel:
            messagebox.showwarning("Selección requerida", "Seleccione un registro de la tabla.", parent=self)
            return None
        try:
            return int(sel[0])
        except Exception:
            return None

    def refrescar(self):
        for item in self.tree.get_children():
            self.tree.delete(item)
        try:
            registros = db.obtener_todos()
        except Exception as e:
            messagebox.showerror("Error", f"No se pudieron leer los registros:\n{e}", parent=self)
            return
        for r in registros:
            valores = [("" if r.get(c) is None else r.get(c)) for c in db.COLUMNAS]
            self.tree.insert("", "end", iid=str(r["id"]), values=valores)
        self._set_estado(f"Registros cargados: {len(registros)}")

    # -------------------- CRUD --------------------
    def nuevo_registro(self):
        def on_save(data):
            nuevo_id = db.crear_registro(data)
            self.refrescar()
            self._set_estado(f"Registro creado (id={nuevo_id}).")
        FormularioRegistro(self, "Nuevo registro", on_save)

    def editar_registro(self):
        rid = self._id_seleccionado()
        if rid is None:
            return
        registro = db.obtener_por_id(rid)
        if not registro:
            messagebox.showerror("Error", "El registro seleccionado no existe.", parent=self)
            self.refrescar()
            return

        def on_save(data):
            db.actualizar_registro(rid, data)
            self.refrescar()
            self._set_estado(f"Registro actualizado (id={rid}).")

        FormularioRegistro(self, f"Editar registro (id={rid})", on_save, registro=registro)

    def eliminar_registro(self):
        rid = self._id_seleccionado()
        if rid is None:
            return
        if not messagebox.askyesno("Confirmar eliminación", f"¿Eliminar el registro con id={rid}?", parent=self):
            return
        try:
            db.eliminar_registro(rid)
            self.refrescar()
            self._set_estado(f"Registro eliminado (id={rid}).")
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo eliminar el registro:\n{e}", parent=self)

    # -------------------- Importar / Exportar --------------------
    def importar_csv(self):
        ruta = filedialog.askopenfilename(
            parent=self,
            title="Importar datos desde CSV",
            initialdir=BASE_DIR,
            filetypes=[("Archivos CSV", "*.csv"), ("Todos los archivos", "*.*")],
        )
        if not ruta:
            return
        try:
            importados, errores = io_datos.importar_csv(ruta)
        except Exception as e:
            messagebox.showerror("Error de importación", f"No se pudo importar el archivo:\n{e}", parent=self)
            return

        self.refrescar()
        msg = f"Importación finalizada.\n\nRegistros importados: {importados}\nErrores: {len(errores)}"
        if errores:
            detalle = "\n".join(errores[:15])
            if len(errores) > 15:
                detalle += f"\n... y {len(errores) - 15} errores más."
            msg += "\n\nDetalle de errores:\n" + detalle
            messagebox.showwarning("Importación con observaciones", msg, parent=self)
        else:
            messagebox.showinfo("Importación completada", msg, parent=self)
        self._set_estado(f"Importados: {importados}, errores: {len(errores)}.")

    def _exportar(self, tipo):
        registros = db.obtener_todos()
        if not registros:
            if not messagebox.askyesno(
                "Sin datos",
                "No hay registros en la base de datos. ¿Desea exportar un archivo vacío con encabezados?",
                parent=self,
            ):
                return
        ext = tipo.lower()
        if tipo == "CSV":
            filtro = [("Archivos CSV", "*.csv"), ("Todos", "*.*")]
            defaccion = ".csv"
            funcion = io_datos.exportar_csv
        elif tipo == "TSV":
            filtro = [("Archivos TSV", "*.tsv"), ("Archivos de texto", "*.txt"), ("Todos", "*.*")]
            defaccion = ".tsv"
            funcion = io_datos.exportar_tsv
        else:
            filtro = [("Archivos JSON", "*.json"), ("Todos", "*.*")]
            defaccion = ".json"
            funcion = io_datos.exportar_json

        ruta = filedialog.asksaveasfilename(
            parent=self,
            title=f"Exportar a {tipo}",
            defaultextension=defaccion,
            initialdir=os.path.join(BASE_DIR, "exports"),
            initialfile=f"datos{defaccion}",
            filetypes=filtro,
        )
        if not ruta:
            return
        try:
            funcion(registros, ruta)
            messagebox.showinfo("Exportación completada", f"Datos exportados a {tipo}:\n{ruta}", parent=self)
            self._set_estado(f"Exportado {len(registros)} registros a {tipo}: {ruta}")
        except Exception as e:
            messagebox.showerror("Error de exportación", f"No se pudo exportar a {tipo}:\n{e}", parent=self)

    def exportar_csv(self):
        self._exportar("CSV")

    def exportar_json(self):
        self._exportar("JSON")

    def exportar_tsv(self):
        self._exportar("TSV")

    # -------------------- Visualización --------------------
    def generar_imagen(self):
        registros = db.obtener_todos()
        if not registros:
            messagebox.showwarning("Sin datos", "No hay registros en la base de datos para graficar.", parent=self)
            return

        dialog = tk.Toplevel(self)
        dialog.title("Generar imagen de coordenadas")
        dialog.resizable(False, False)
        dialog.transient(self)
        dialog.grab_set()

        frm = ttk.Frame(dialog, padding=12)
        frm.pack(fill="both", expand=True)

        ttk.Label(frm, text="Seleccione el campo a mostrar:").grid(row=0, column=0, sticky="w", pady=(0, 6))
        campo_var = tk.StringVar(value="temperatura")
        combo = ttk.Combobox(frm, textvariable=campo_var, values=grafico.CAMPOS_ELEGIBLES, state="readonly", width=28)
        combo.grid(row=1, column=0, sticky="ew")
        ttk.Label(
            frm,
            text="Se graficarán latitud/longitud y el valor del campo elegido\n(color numérico o categorías).",
            foreground="gray", justify="left",
        ).grid(row=2, column=0, sticky="w", pady=(8, 10))

        btns = ttk.Frame(frm)
        btns.grid(row=3, column=0, sticky="e")

        def aceptar():
            campo = campo_var.get().strip()
            if not campo:
                messagebox.showwarning("Selección requerida", "Debe seleccionar un campo.", parent=dialog)
                return
            dialog.destroy()
            try:
                fig = grafico.crear_figura_coordenadas(registros, campo)
                VentanaImagen(self, fig, titulo=f"Coordenadas - {campo}")
                self._set_estado(f"Imagen generada para el campo '{campo}'.")
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo generar la imagen:\n{e}", parent=self)

        ttk.Button(btns, text="Generar", command=aceptar).pack(side="left", padx=4)
        ttk.Button(btns, text="Cancelar", command=dialog.destroy).pack(side="left", padx=4)

        dialog.bind("<Return>", lambda e: aceptar())
        dialog.bind("<Escape>", lambda e: dialog.destroy())


def main():
    db.init_db()
    app = App()
    app.mainloop()


if __name__ == "__main__":
    main()
