# Crear un entorno de conda con nuestro paquete

Podemos crear un entorno de conda (un "entorno virtual") que incluye nuestro paquete de conversión de vectores de velocidad. Este entorno lo podemos de una manera muy flexible, sin importar el directorio.

```bash
cd ~/tutoriales/10-martes/python_codigo_reusable
```

Este entorno va a desaparecer de nuestra cuenta del hub al cerrar la sesión. Para crear entornos persistentes, que pueden ser útiles para los proyectos del hackatón, [ver nuestras instrucciones](https://intercoonecta.github.io/JupyterHub.html#crear-entornos-de-conda-persistentes-pero-accesibles-solo-en-tu-cuenta).

```bash
conda create -n codigo-reusable python=3.12 ipykernel
pip install -e ./paquete
```

- `ipykernel` permite que el entorno sea accesible a los cuadernos de jupyter. 
- El `-e` en `pip install` instale el paquete en modo editable. Cambiamos que hagamos en el paquete se reflejaran en el entorno de conda.

Luego de crear el entorno, ¡probémoslo!
