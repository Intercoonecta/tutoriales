Visualización en R
================
Héctor Villalobos
23/2/23

- <a href="#gráficas-tradicionales"
  id="toc-gráficas-tradicionales">Gráficas tradicionales</a>
  - <a href="#histogramas" id="toc-histogramas">Histogramas</a>
  - <a href="#gráficas-de-dispersión"
    id="toc-gráficas-de-dispersión">Gráficas de dispersión</a>
  - <a href="#combinando-gráficas" id="toc-combinando-gráficas">Combinando
    gráficas</a>
  - <a href="#gráficos-especializados"
    id="toc-gráficos-especializados">Gráficos especializados</a>
- <a href="#gráficas-grid" id="toc-gráficas-grid">Gráficas grid</a>
  - <a href="#lattice" id="toc-lattice">Lattice</a>
  - <a href="#ggplot2" id="toc-ggplot2">ggplot2</a>

En R existen dos sistemas gráficos principales, el tradicional o básico
(*base graphics*), similar al original del lenguaje S y un sistema único
de R, denominado *grid graphics* en el que se basan paquetes como
`lattice` y `ggplot2`. Aquí haremos énfasis en el sistema tradicional,
aunque se presentarán algunos ejemplos de los paquetes mencionados.

## Gráficas tradicionales

Las gráficas tradicionales, constan de funciones que producen gráficas
estadísticas completas (p. ej. histogramas, diagramas de dispersión,
etc.) o que permiten agregar diversos elementos a estas.

Para ilustrar algunas ejemplos usaremos datos disponibles en el paquete
`palmerpenguins`.

``` r
# Datos de pingüinos del archipiélago Palmer
library(palmerpenguins)
data(penguins)
head(penguins)
```

    # A tibble: 6 × 8
      species island    bill_length_mm bill_depth_mm flipper_l…¹ body_…² sex    year
      <fct>   <fct>              <dbl>         <dbl>       <int>   <int> <fct> <int>
    1 Adelie  Torgersen           39.1          18.7         181    3750 male   2007
    2 Adelie  Torgersen           39.5          17.4         186    3800 fema…  2007
    3 Adelie  Torgersen           40.3          18           195    3250 fema…  2007
    4 Adelie  Torgersen           NA            NA            NA      NA <NA>   2007
    5 Adelie  Torgersen           36.7          19.3         193    3450 fema…  2007
    6 Adelie  Torgersen           39.3          20.6         190    3650 male   2007
    # … with abbreviated variable names ¹​flipper_length_mm, ²​body_mass_g

Con la instrucción `?palmerpenguins` se pueden consultar los detalles de
esta base de datos.

### Histogramas

Los histogramas permiten ver la distribución de una variable numérica.
La función `hist()` requiere especificar únicamente el nombre de la
variable de interés, mientras que el número y límites de los intervalos
son determinados de manera automática, al igual que las escalas de los
ejes y sus etiquetas, y título principal.

``` r
hist(penguins$bill_length_mm)
```

![](Visualizacion_en_R_files/figure-commonmark/unnamed-chunk-3-1.png)

Muchos de estos elementos se pueden personalizar a través de argumentos
de la función `hist()`. Por ejemplo el título (`main`), los nombres de
los ejes (`xlab`, `ylab`), y los límites de los intervalos (`breaks`).

``` r
hist(penguins$bill_length_mm, xlab = "longitud del pico (mm)", ylab = "Frecuencia",
     main = "Histograma para 3 especies de pingüino", 
     breaks = c(seq(32, 52, 4), 60))
```

![](Visualizacion_en_R_files/figure-commonmark/unnamed-chunk-4-1.png)

Como puede verse, la formación de los intervalos es muy flexible (ver el
valor del argumento `breaks`).

### Gráficas de dispersión

En el caso de dos variables se pueden crear gráficas de dispersión
especificando en que eje va cada una. Si esto no se indica, la primera
se considera como la variable `x`.

``` r
plot(x = penguins$bill_length_mm, y = penguins$bill_depth_mm)
```

![](Visualizacion_en_R_files/figure-commonmark/unnamed-chunk-5-1.png)

Existen muchas maneras de personalizar una gráfica como la anterior. Por
ejemplo, sabiendo que se tienen datos de tres especies, podemos utilizar
colores diferentes para cada una.

``` r
plot(penguins$bill_length_mm, penguins$bill_depth_mm,
     xlab = "longitud del pico (mm)", ylab = "profundidad del pico (mm)",
     las = 1, pch = 16, col = penguins$species)
```

![](Visualizacion_en_R_files/figure-commonmark/unnamed-chunk-6-1.png)

El uso de `col = penguins$species` permite definir los colores porque la
especie esta codificada como un factor (ver el resultado de evaluar
`class(penguins$species)`). Otros argumentos usados en el ejemplo
anterior son el tipo de símbolo (`pch = 16`), que en este caso es un
círculo relleno. En la ayuda de la función `points()` se pueden ver
otros símbolos disponibles. Por último, el argumento `las = 1` opera en
las etiquetas de los ejes, mostrándolas de manera horizontal en este
caso.

Otra forma de personalizar la figura podría ser incorporando
transparencias a los colores y símbolos diferentes por especie. Para
ello el ejemplo de abajo hace uso de la función `rgb()` que requiere
especificar 3 valores correspondientes al rojo, verde y azul, así como
un cuarto valor para la transparencia (todos entre 0 y 1).

``` r
sp <- levels(penguins$species)
rojo <- c(0, 1, 0); verde <- c(0, 0, 1); azul <- c(0, 0, 0); alfa <- 0.4

plot(penguins$bill_length_mm, penguins$bill_depth_mm, type = "n", las = 1,
     xlab = "longitud del pico (mm)", ylab = "profundidad del pico (mm)")
 for (i in 1:3) {
  points(penguins$bill_length_mm[penguins$species == sp[i]],
         penguins$bill_depth_mm[penguins$species == sp[i]], pch = i + 14, 
         col = rgb(rojo[i], verde[i], azul[i], alfa))  
 }
```

![](Visualizacion_en_R_files/figure-commonmark/unnamed-chunk-7-1.png)

En el código previo, el llamado a la función `plot()` solo genera el
marco del gráfico y los ejes, pero no dibuja ningún punto
(`type = "n"`), puesto que de ello se encarga la función `points()` en
donde se especifican la especie, colores y símbolos a utilizar. Este
ejemplo también hace uso de un bucle para dibujar sucesivamente los
puntos de cada especie, así como el tipo de símbolo y los diferentes
niveles de rojo, verde y azul en estos.

Un ejemplo más para ilustrar como podemos agregar otros elementos como
líneas de tendencia y anotaciones (texto) en la gráfico es el siguiente:

``` r
chin <- subset(penguins, species == "Chinstrap")
plot(chin$bill_length_mm, chin$bill_depth_mm, las = 1, pch = 16,
     xlab = "longitud del pico (mm)", ylab = "profundidad del pico (mm)",
     col = rgb(0, 0, 1, 0.4))
  abline(lm(bill_depth_mm ~ bill_length_mm, data = chin))
  text(x = 41, y = 20.5, "y = 7.5 + 0.22 x", pos = 4)
  text(x = 41, y = 20, pos = 4, expression(paste(R^2, "=0.42")))
```

![](Visualizacion_en_R_files/figure-commonmark/unnamed-chunk-8-1.png)

Aquí utilizamos un subconjunto de los datos para la especie “Chinstrap”,
para la cual dibujamos la línea de regresión entre ambas variables
(`lm(bill_depth_mm ~ bill_length_mm)`) e incluimos el modelo resultante
con su correspondiente valor de R<sup>2</sup>. Nótese que para esto
último se hace uso de la función `expression()` que permite representar
el exponente.

### Combinando gráficas

La manera más simple de organizar varias gráficas en una misma figura
(ventana gráfica) es con la función `par()`, cuyo argumento `mfrow` (o
`mfcol`) permite dividir la ventana gráfica en una matriz (en el
ejemplo, de 2 renglones $\times$ 2 columnas). Ahora podemos explorar el
comportamiento de las cuatro variables numéricas disponibles por
especie.

``` r
par(mfrow = c(2, 2), mar = c(3, 4, 1, 1))
plot(bill_length_mm ~ species, data = penguins, xlab = "")
plot(bill_depth_mm ~ species, data = penguins, xlab = "")
plot(flipper_length_mm ~ species, data = penguins, xlab = "")
plot(body_mass_g ~ species, data = penguins, xlab = "")
```

![](Visualizacion_en_R_files/figure-commonmark/unnamed-chunk-9-1.png)

Las gráficas de cajas y bigotes (*box and whisker plots*) también se
pueden obtener llamando directamente a la función `boxplot()`, pero al
incluir la tilde o virgulilla (`~`) y siendo la variable `species` una
variable factorial, se obtiene el mismo resultado. En el primer caso,
esto se lee “longitud del pico **en función** de la especie”.
Adicionalmente, se hace uso del argumento `data` que permite especificar
en donde están las variables a graficar.

Mayor flexibilidad en el acomodo de varias gráficas en una sola figura
se logra con la función `layout()`, esta también acepta una matriz que
define el número y acomodo de las gráficas, además de su tamaño. En el
ejemplo que sigue, se usa la función `hist()` para obtener las
frecuencias por intervalo, pero el graficado se hace a través de la
función `barplot()` que permite dibujar uno de los histogramas de manera
horizontal.

``` r
xhist <- hist(penguins$bill_length_mm, plot = FALSE)
yhist <- hist(penguins$bill_depth_mm, plot = FALSE)

layout(matrix(c(1, 0, 2, 3), ncol = 2, byrow = TRUE), 
       heights = c(0.2, 1), widths = c(1, 0.2))
par(mar = c(0, 4, 0, 0))
barplot(xhist$density, space = 0, axes = FALSE)
par(mar = c(4, 4, 0, 0))
plot(penguins$bill_length_mm, penguins$bill_depth_mm,
     xlab = "longitud del pico (mm)", ylab = "profundidad del pico (mm)",
     las = 1, pch = 16, col = penguins$species)
par(mar = c(4, 0, 0, 0))
barplot(yhist$density, space = 0, axes = FALSE, horiz = TRUE)
```

![](Visualizacion_en_R_files/figure-commonmark/unnamed-chunk-10-1.png)

Nótese que en `layout()` se incluye un 0 en la matriz, para evitar que
se dibuje una gráfica en esa posición. Además se especifican las alturas
y anchos de las diferentes gráficas.

Las figuras anteriores son solo una muestra de las posibilidades del
sistema tradicional de gráficas en R. Se recomienda consultar la ayuda
de la función `par()`, donde se describe una amplia gama de parámetros
gráficos que pueden ser modificados por el usuario. Adicionalmente, para
más ejemplos se pueden ejecutar las funciones `demo(graphics)` y
`demo(persp)`.

### Gráficos especializados

La función `plot()` es una función genérica, lo que significa que puede
producir gráficos diferentes dependiendo del tipo de datos (clase del
objeto) que se le pase. Esto por supuesto requiere que exista un
“método” registrado para esa clase. Esto se vio antes cuando se obtuvo
una gráfica de cajas y bigotes con:
`plot(bill_length_mm ~ species, data = penguins)`.

#### Mapas

Un ejemplo de lo anterior son los mapas. En R existen varios paquetes
para este propósito, incluso algunos que incluyen su propia base de
datos. En este ejemplo usaremos un mapa obtenido de
[GSHHG](https://www.soest.hawaii.edu/pwessel/gshhg/), acrónimo de *A
Global Self-consistent, Hierarchical, High-resolution Geography
Database*, disponible gratuitamente. Esta base de datos incluye líneas
de costa, ríos y fronteras de todo el planeta. Los detalles y
características de la base se pueden consultar en el enlace anterior.

El mapa que usaremos fue extraído y guardado previamente como un archivo
“rds”, lo que preserva la clase y estructura del objeto R original.

``` r
mapa <- readRDS("./Data/mapa.rds")
class(mapa)
```

    [1] "SpatialPolygons"
    attr(,"package")
    [1] "sp"

Para poder graficar este objeto de clase “SpatialPolygons” se requiere
el paquete `sp`, que es el que contiene el método para dicha clase.

``` r
library(sp)
plot(mapa)
```

![](Visualizacion_en_R_files/figure-commonmark/unnamed-chunk-12-1.png)

Podemos personalizar este mapa usando muchos de los argumentos
presentados antes, además de que existen otros propios de la clase.

``` r
plot(mapa, xlim = c(-120, -105), ylim = c(20, 35), las = 1, 
     col = "grey90", border = "grey", axes = TRUE)
box()
```

![](Visualizacion_en_R_files/figure-commonmark/unnamed-chunk-13-1.png)

En el mapa anterior es posible agregar múltiples elementos, desde texto
(función `text()`), hasta transectos (función `lines()`), localidades de
colecta de muestras o lances de pesca (función `points()`), por
mencionar algunos ejemplos.

#### Gráficos con datos de sensores remotos

Un ejemplo más sería la representación de variables oceánicas obtenidas
por satélites, resultantes de modelos oceanográficos, o una combinación
de ambos.

El paquete `satin` tiene funciones para este propósito e incluye datos
de ejemplo que podemos utilizar para ilustrar este caso.

``` r
library(satin)
```


    Attaching package: 'satin'

    The following object is masked from 'package:sp':

        imageScale

``` r
data("dsst")
dsst
```

    Object of class satin

     Title: HMODISA Level-3 Standard Mapped Image 
     Long name: 4um Sea Surface Temperature 
     Name: sst4 
     Units: degree_C 
     Temporal range: 8-day 
     Spatial resolution: 4.64 km 

    Data dimensions:
     360 360 1 

    Data ranges:
              lon      lat   sst4     period
    min -118.9792 20.02083  9.670 2013-03-29
    max -104.0208 34.97917 27.435 2013-04-06

Esta estructura de datos de clase “satin” se puede graficar también con
la función `plot()` que llama a la función propia de la clase
(`plot.satin()`) definida completamente en el sistema de gráfico
tradicional.

``` r
plot(dsst)
```

![](Visualizacion_en_R_files/figure-commonmark/unnamed-chunk-15-1.png)

Los argumentos de la función que permiten un control fino de los
elementos de la figura se pueden ver con la función `args()` y su
explicación se puede consultar en la ayuda de la misma
(`help(plot.satin)`.

``` r
args(plot.satin)
```

    function (x, period = 1, depth = 1, xlim = NULL, ylim = NULL, 
        zlim = NULL, map = NULL, map.col = "grey", map.outline = "black", 
        scheme = "default", col.sep = 0.1, colbar = TRUE, main = NULL, 
        main.pos = "topright", log = FALSE, units = NULL, xaxt = "s", 
        yaxt = "s", atx = NULL, aty = NULL, restore.par = TRUE, ...) 
    NULL

#### Ecogramas

Los ecogramas digitales producidos por ecosondas científicas también
pueden considerarse como datos de sensores remotos. El paquete
`echogram` permite procesar archivos en formato HAC y RAW, de los que se
darán mayores detalles en un tutorial posterior. Aquí únicamente
mostraremos algunos ejemplos de visualización.

Para ello utilizaremos primero un archivo en formato RAW obtenido con
una ecosonda científica EK60 y guardado en la carpeta “Data”. Este
archivo contiene datos para dos frecuencias (38 y 120 kHz), pero nos
concentraremos en la primera.

``` r
library(echogram)
ekraw <- read.EK60_raw("./Data/mango1402-D20140223-T172151.raw")
eco <- ek2echogram(ekraw)
str(eco)
```

    List of 3
     $ depth: num [1:3093] 0.097 0.194 0.291 0.388 0.485 ...
     $ Sv   : num [1:3093, 1:628] -12.29 5.14 9.56 12.18 6.1 ...
      ..- attr(*, "frequency")= chr "38 kHz"
      ..- attr(*, "variable")= chr "Sv"
     $ pings:'data.frame':  628 obs. of  4 variables:
      ..$ pingTime : POSIXct[1:628], format: "2014-02-23 17:21:51" "2014-02-23 17:21:52" ...
      ..$ detBottom: logi [1:628] NA NA NA NA NA NA ...
      ..$ speed    : logi [1:628] NA NA NA NA NA NA ...
      ..$ cumdist  : logi [1:628] NA NA NA NA NA NA ...
     - attr(*, "class")= chr "echogram"

El ecograma por defecto correspondiente se obtendría de la siguiente
manera.

``` r
echogram(eco)
```

![](Visualizacion_en_R_files/figure-commonmark/unnamed-chunk-18-1.png)

La función `echogram()` tiene una serie de argumentos que permiten
personalizar la figura anterior. La descripción de su significado se
puede consultar en la ayuda de la misma.

``` r
args(echogram)
```

    function (echogram, Svthr = -70, Svmax = 0, col.sep = NULL, col.nb = NULL, 
        scheme = NULL, depth.grid = NULL, x.grid = NULL, x.ref = c("pings", 
            "nmi", "seconds"), seabed = FALSE, depth.max = NULL, 
        ping.ini = NULL, ping.max = NULL, colbar = TRUE, main = NULL, 
        tformat = "%H:%M", ...) 
    NULL

Vamos a ejemplificar el uso de algunos de estos argumentos, para lo que
aprovechando que se cuenta con el fondo detectado en el archivo \*.bot
correspondiente, también lo incluiremos en el ecograma.

``` r
# leer datos del fondo detectado
bot <- read.EK_bot("./Data/mango1402-D20140223-T172151.bot")
head(bot)
```

                 pingTime depth.tr1 depth.tr2
    1 2014-02-23 17:21:51    0.0000    0.0000
    2 2014-02-23 17:21:52    0.0000    0.0000
    3 2014-02-23 17:21:53  239.6742  239.6005
    4 2014-02-23 17:21:54  239.6008  239.5643
    5 2014-02-23 17:21:55  239.5258  239.4356
    6 2014-02-23 17:21:56  239.3911  239.4244

Además del `pingTime`, hay dos columnas con el fondo detectado para cada
frecuencia. Guardaremos la primera en `eco`.

``` r
eco$pings$detBottom <- bot$depth.tr1
```

Ahora, dado que durante la adquisición de los datos acústicos la hora de
la computadora se configura en horario UTC (Coordinated *Universal
Time*), vamos a cambiarlo a la hora local del sitio de colecta.

``` r
library(lubridate)
```


    Attaching package: 'lubridate'

    The following objects are masked from 'package:base':

        date, intersect, setdiff, union

``` r
eco$pings$pingTime <- with_tz(eco$pings$pingTime, tzone = "America/Hermosillo")
```

Por último, vamos a eliminar datos a partir de 20 m por debajo del fondo
que no nos interesa mostrar.

``` r
eco <- mask.echogram(eco, bott.off = -20)
```

En nuestro ecograma final, cambiaremos la paleta de colores de “parula”
a “EK500” (`scheme = "EK500"`) y los límites de visualización de los
datos (`Svthr` y `Svmax`). También, la referencia del eje horizontal se
cambiará de *pings* a tiempo local (segundos; `x.ref = "s"`) y la
profundidad máxima mostrada (`depth.max = 265`).

``` r
echogram(eco, Svthr = -65, Svmax = -15, scheme = "EK500", x.ref = "s", depth.max = 265, seabed = TRUE)
```

![](Visualizacion_en_R_files/figure-commonmark/unnamed-chunk-24-1.png)

La función `echogram()` también esta creada con el sistema gráfico
tradicional de R. Como se ha visto, este sistema es bastante útil, ya
que permite el control fino de muchos elementos gráficos.

## Gráficas grid

Como se mencionó antes, paquetes como `lattice` y `ggplot2` aprovechan
funciones de bajo nivel para producir líneas, polígonos, texto,
símbolos, etc. proporcionadas por el sistema `grid` y producen
resultados completos con poco código. Estos paquetes representan muy
buenas opciones, aunque la filosofía subyacente, y por lo tanto
sintaxis, cambia considerablemente (sobre todo en `ggplot2`).

En este tutorial nos limitaremos a unos cuantos ejemplos.

### Lattice

Un gráfico de dispersión de una de las variables de la base de datos
`penguins` por especie se puede generar con la función `xyplot()`.
Nótese el uso de “\|” para indicar la creación de varios páneles de
acuerdo a la variable `species`.

``` r
library(lattice)
xyplot(bill_length_mm ~ bill_depth_mm | species, data = penguins)
```

![](Visualizacion_en_R_files/figure-commonmark/unnamed-chunk-25-1.png)

### ggplot2

Este paquete genera gráficos visualmente atractivos y muchas veces
resulta muy conveniente porque no requiere escribir demasiado código.
Forma parte de lo que se ha llamado el “tidyverse”, que es un conjunto
de paquetes impulsado por los desarrolladores de RStudio.

Este ejemplo genera el gráfico de dispersión equivalente a uno que
realizamos antes con la función `plot()`.

``` r
library(ggplot2)
p <- ggplot(data = penguins, 
            aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) +
     geom_point()
p
```

    Warning: Removed 2 rows containing missing values (`geom_point()`).

![](Visualizacion_en_R_files/figure-commonmark/unnamed-chunk-26-1.png)
