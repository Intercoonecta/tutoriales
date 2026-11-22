# Archivo de prompts para [opencode](https://opencode.ai)

**Un prompt es una instrucción, pregunta o texto que se escribe para interactuar con un sistema de inteligencia artificial (IA) y pedirle que realice una tarea concreta.**

## Instrucciones

En el JupyterHub de OceanHackWeek en Español, abre una terminal desde el Lanzador (Launcher) de JupyterLab. En la terminal, accede a `opencode` corriendo el comando `/tmp/opencodeai/opencode`

Algunas de estas prompts crean aplicaciones gráficas de Desktop. Para poder ejecutar estas aplicaciones, opencode tiene que ser corrido desde una terminal en el Desktop de Linux. Lanza este Desktop desde el Lanzador en Jupyter, y luego abre una terminal ya en ese Desktop.

## Prompts

### Prompt #0

Hacer un programa en Python para resolver una ecuación de segundo grado solo pasándole los coeficientes de la ecuación a resolver, tomar en cuenta  todas las opciones para resolver la ecuación Ax^2+Bx+C=0


### Prompt #1

Hacer un programa en Python para multiplicación de matrices con dimensiones de m x n y  n x p, validar que las matrices tengan las dimensiones adecuadas para poder  realizar la operación , el programa tendrá que proporcionar las funciones de captura para los datos .


### Prompt #2

Hacer un programa en Python para resolver sistemas de ecuaciones de n incógnitas utilizando la matriz inversa por el método de Gauss-Jordán para resolver el Sistema ecuaciones


### Prompt #3

Hacer un crud utilizando SQLite como base de datos, los datos que queremos almacenar son id, id\_estación, fecha, latitud, longitud, temperatura ,pH, clorofila, especie
Elaborar una imagen que muestre las coordenadas de los datos y poder elegir el campo que requiramos mostrar , agregar opciones en el menú para generar de acuerdo a los datos un archivo csv, en otra opción generar un archivo con estructura json de los datos y por ultimo otra opción para  un archivo tsv
Mostrar las opciones en el menú del crud.

Agregar una opción para alimentar la base de datos a través de  un archivo csv , que respete la estructura de nuestra base de datos.


### Prompt #5

Bajar dataset de iris flower utilizando Python sin utilizar librerías: https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data

Requiero hacer una red neuronal con el conjunto de datos de iris el archivo es iris.csv, utilizar 80% para entrenamiento y 20%, para pruebas , limpiar los datos para ver si hay inconsistencias en el archivo, mezclar los datos para seleccionar 80% para entrenamiento y 20% para pruebas, una vez entrenada la red probar los datos y ver el % de aciertos que tenemos de acuerdo al entrenamiento de nuestra red neuronal.
