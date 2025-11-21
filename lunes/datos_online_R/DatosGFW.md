# Trabajando con datos de Global Fishing Watch

Jorge Cornejo-Donoso November 21, 2025

-   [Global Fishing Watch](#global-fishing-watch)
-   [Datos](#datos)
    -   [Descripción de los datos](#descripción-de-los-datos)
-   [Propuesta de Análisis](#propuesta-de-análisis)
-   [Análisis Paso a paso](#análisis-paso-a-paso)
    -   [Actividad de pesca aparente por país de registro](#actividad-de-pesca-aparente-por-país-de-registro)
    -   [Actividad de pesca aparente por arte de pesca](#actividad-de-pesca-aparente-por-arte-de-pesca)
    -   [Serie temporal de actividad diaria de pesca aparente](#serie-temporal-de-actividad-diaria-de-pesca-aparente)
        -   [Para todos los países](#para-todos-los-países)
        -   [Para los países principales](#para-los-países-principales)
        -   [Para los tres artes de pesca principales](#para-los-tres-artes-de-pesca-principales)
    -   [Análisis espacial de la actividad de pesca aparente](#análisis-espacial-de-la-actividad-de-pesca-aparente)
        -   [Zonas con mayor actividad de pesca aparente total anual](#zonas-con-mayor-actividad-de-pesca-aparente-total-anual)
        -   [Zonas con mayor actividad de pesca aparente aculada por mes](#zonas-con-mayor-actividad-de-pesca-aparente-aculada-por-mes)
-   [Usando gfwR](#usando-gfwr)

# Global Fishing Watch {#global-fishing-watch}

```{=html}
<img src="images/GFW-fishingmap.png" data-fig-align="center"
data-fig-pos="H" width="805" />
```

Global Fishing Watch (GFW) es una organización no gubernamental (ONG) que busca avanzar en la gobernanza de los océanos a través de una mayor transparencia de la actividad humana en el mar. Al crear y compartir públicamente visualizaciones de mapas, datos y herramientas de análisis, permiten la investigación científica e impulsan una transformación en la forma en que gestiona el océano.

Global Fishing Watch genera nuevo conocimiento utilizando tecnología de punta para convertir big data en información procesable. Comparten esa información públicamente y de forma gratuita para acelerar la ciencia e impulsar políticas y prácticas más justas e inteligentes que recompensen el buen comportamiento y protejan la biodiversidad, la pesca y los medios de subsistencia.

Para más información <http://www.globalfishingwatch.org>

Mapa de visualización y acceso a datos <http://www.globalfishingwatch.org/map>

# Datos {#datos}

GFW compila una cantidad masiva da datos de posiciones de embarcaciones (AIS y VMS), de registro de embarcaciones y otra infraestructuras marinas, y las hace disponibles en sus distintas plataformas. El acceso a estos datos e información es completamente gratuita y se puede hacer directamente en sus plataformas [WEB](http://www.globalfishingwatch.org/map), [API](https://globalfishingwatch.org/es/nuestras-api/), [paquete de R](https://github.com/GlobalFishingWatch/gfwr) y de [libreria de Python](https://pypi.org/project/gfw/).

Si bien la mayoría de los datos de GFW son gratuitos y de libre uso, para acceder a alguno de ellos es necesario crear una cuenta, esto es totalmente gratuito. Para esto se va a la página principal de la plataforma (<http://www.globalfishingwatch.org/map>) y en el extremo inferior izquierdo se puede hacer click en el icono (<img src="images/registerIcon.png" width="20" height="22"/>), se debe seguir el proceso de registro y se tiene acceso a descargar los datos.

Para este ejercicio, vamos a usar los datos de esfuerzo de pesca aparente, derivado de los dispositivos AIS, para todo el año 2023, en la [zona economica exclusiva que rodea las islas Galápagos](https://globalfishingwatch.org/map/index?start=2024-08-12T00%3A00%3A00.000Z&end=2024-11-12T00%3A00%3A00.000Z&longitude=-87.53436510669711&latitude=-0.1438653714849388&zoom=5.3216383206620534&sbO=true&dvIn%5B0%5D%5Bid%5D=presence&dvIn%5B0%5D%5Bcfg%5D%5Bvis%5D=false&dvIn%5B1%5D%5Bid%5D=context-layer-eez&dvIn%5B1%5D%5Bcfg%5D%5Bvis%5D=true&dvIn%5B2%5D%5Bid%5D=vms&dvIn%5B2%5D%5Bcfg%5D%5Bvis%5D=false&dvIn%5B3%5D%5Bid%5D=ais&dvIn%5B3%5D%5Bcfg%5D%5Bvis%5D=true&tV=heatmap) de la república del Ecuador, tanto como una serie de tiemporal diaria por barco y por unidad espacial (0.01°x0.01°) .

Durante la presentación se describirá como acceder a estos datos, sin embarco en este documento solo se comparte el resultado de este proceso ([descarga de datos](https://drive.google.com/file/d/1cyZmiR8MJyGAETPqnnN9mRBOjm8VqSXA/view?usp=sharing)).

## Descripción de los datos {#descripción-de-los-datos}

Los datos temporales que vamos a utilizar en este ejercicio son las horas de pesca aparente diaria por embarcación detectada dentro de esta área de interés.

Estos datos además contienen información acerca de las embarcaciones, con nombre, numero IMO, bandera, arte de pesca entre otros (<a href="#tbl-datosTS" class="quarto-xref">Table 1</a>).

``` r
data <- read.csv("datos/Temporal_Ecuadorian Exclusive Economic Zone (Galapagos) - 2023-01-01T00_00_00.000Z,2024-01-01T00_00_00.000Z/layer-activity-data-0/public-global-fishing-effort-v3.0.csv")

knitr::kable(head(data))
```

<table>
<thead>
<tr>
<th style="text-align: left;"><p>Time.Range</p></th>
<th style="text-align: left;"><p>Flag</p></th>
<th style="text-align: left;"><p>Vessel.Name</p></th>
<th style="text-align: left;"><p>Entry.Timestamp</p></th>
<th style="text-align: left;"><p>Exit.Timestamp</p></th>
<th style="text-align: left;"><p>Gear.Type</p></th>
<th style="text-align: left;"><p>Vessel.Type</p></th>
<th style="text-align: right;"><p>MMSI</p></th>
<th style="text-align: right;"><p>IMO</p></th>
<th style="text-align: left;"><p>CallSign</p></th>
<th style="text-align: left;"><p>First.Transmission.Date</p></th>
<th style="text-align: left;"><p>Last.Transmission.Date</p></th>
<th style="text-align: right;"><p>Apparent.Fishing.Hours</p></th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>2023-01-10</p></td>
<td style="text-align: left;"><p>ECU</p></td>
<td style="text-align: left;"><p>DONA ROGE</p></td>
<td style="text-align: left;"><p>2023-01-10T10:00:00Z</p></td>
<td style="text-align: left;"><p>2023-10-07T11:00:00Z</p></td>
<td style="text-align: left;"><p>TUNA_PURSE_SEINES</p></td>
<td style="text-align: left;"><p>FISHING</p></td>
<td style="text-align: right;"><p>735057685</p></td>
<td style="text-align: right;"><p>NA</p></td>
<td style="text-align: left;"><p>HC4301</p></td>
<td style="text-align: left;"><p>2020-09-07T16:27:31Z</p></td>
<td style="text-align: left;"><p>2024-10-21T03:13:40Z</p></td>
<td style="text-align: right;"><p>1.49</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>2023-04-15</p></td>
<td style="text-align: left;"><p>ECU</p></td>
<td style="text-align: left;"><p>TINTORERA</p></td>
<td style="text-align: left;"><p>2023-01-03T13:00:00Z</p></td>
<td style="text-align: left;"><p>2023-04-15T17:00:00Z</p></td>
<td style="text-align: left;"><p>FISHING</p></td>
<td style="text-align: left;"><p>FISHING</p></td>
<td style="text-align: right;"><p>735059515</p></td>
<td style="text-align: right;"><p>NA</p></td>
<td style="text-align: left;"><p>HC-5964</p></td>
<td style="text-align: left;"><p>2020-05-31T16:10:36Z</p></td>
<td style="text-align: left;"><p>2024-03-08T18:17:43Z</p></td>
<td style="text-align: right;"><p>0.50</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>2023-06-13</p></td>
<td style="text-align: left;"><p>ECU</p></td>
<td style="text-align: left;"><p>DONA ROGE</p></td>
<td style="text-align: left;"><p>2023-01-10T10:00:00Z</p></td>
<td style="text-align: left;"><p>2023-10-07T11:00:00Z</p></td>
<td style="text-align: left;"><p>TUNA_PURSE_SEINES</p></td>
<td style="text-align: left;"><p>FISHING</p></td>
<td style="text-align: right;"><p>735057685</p></td>
<td style="text-align: right;"><p>NA</p></td>
<td style="text-align: left;"><p>HC4301</p></td>
<td style="text-align: left;"><p>2020-09-07T16:27:31Z</p></td>
<td style="text-align: left;"><p>2024-10-21T03:13:40Z</p></td>
<td style="text-align: right;"><p>1.15</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>2023-07-13</p></td>
<td style="text-align: left;"><p>ECU</p></td>
<td style="text-align: left;"><p>GRAND KNIGHT</p></td>
<td style="text-align: left;"><p>2023-05-25T23:00:00Z</p></td>
<td style="text-align: left;"><p>2023-07-13T11:00:00Z</p></td>
<td style="text-align: left;"><p>DRIFTING_LONGLINES</p></td>
<td style="text-align: left;"><p>FISHING</p></td>
<td style="text-align: right;"><p>735058937</p></td>
<td style="text-align: right;"><p>NA</p></td>
<td style="text-align: left;"><p>HC5259</p></td>
<td style="text-align: left;"><p>2022-07-29T23:58:42Z</p></td>
<td style="text-align: left;"><p>2023-08-06T02:33:27Z</p></td>
<td style="text-align: right;"><p>11.26</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>2023-08-06</p></td>
<td style="text-align: left;"><p>ECU</p></td>
<td style="text-align: left;"><p>JOTA JOTA</p></td>
<td style="text-align: left;"><p>2023-04-07T06:00:00Z</p></td>
<td style="text-align: left;"><p>2023-10-01T19:00:00Z</p></td>
<td style="text-align: left;"><p>DRIFTING_LONGLINES</p></td>
<td style="text-align: left;"><p>FISHING</p></td>
<td style="text-align: right;"><p>735058780</p></td>
<td style="text-align: right;"><p>NA</p></td>
<td style="text-align: left;"><p>HC2508</p></td>
<td style="text-align: left;"><p>2022-01-03T17:28:38Z</p></td>
<td style="text-align: left;"><p>2024-11-12T23:56:26Z</p></td>
<td style="text-align: right;"><p>8.31</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>2023-09-12</p></td>
<td style="text-align: left;"><p>ECU</p></td>
<td style="text-align: left;"><p>DON F</p></td>
<td style="text-align: left;"><p>2023-06-19T22:00:00Z</p></td>
<td style="text-align: left;"><p>2023-10-05T13:00:00Z</p></td>
<td style="text-align: left;"><p>TUNA_PURSE_SEINES</p></td>
<td style="text-align: left;"><p>FISHING</p></td>
<td style="text-align: right;"><p>735060354</p></td>
<td style="text-align: right;"><p>NA</p></td>
<td style="text-align: left;"><p>HC6655</p></td>
<td style="text-align: left;"><p>2023-05-08T22:41:27Z</p></td>
<td style="text-align: left;"><p>2024-11-12T23:58:56Z</p></td>
<td style="text-align: right;"><p>11.88</p></td>
</tr>
</tbody>
</table>

En relación a los datos espaciales que se van a utilizar en este ejercicio son las horas de pesca aparente diaria por unidad espacial de 0.01°x0.01° de latitud y longitud (<a href="#tbl-datosSP" class="quarto-xref">Table 2</a>).

``` r
dataSP <- read.csv("datos/Espacial_Ecuadorian Exclusive Economic Zone (Galapagos) - 2023-01-01T00_00_00.000Z,2024-01-01T00_00_00.000Z/layer-activity-data-0/public-global-fishing-effort-v3.0.csv")

knitr::kable(head(dataSP))
```

+------+--------+------------+------+------------+------------------------+
| Lat  | Lon    | Time.Range | flag | Vessel.IDs | Apparent.Fishing.Hours |
+=====:+=======:+:===========+:=====+===========:+=======================:+
| 4.45 | -91.19 | 2023-02-23 | ECU  | 1          | 0.02                   |
+------+--------+------------+------+------------+------------------------+
| 3.39 | -94.24 | 2023-02-20 | ECU  | 1          | 1.12                   |
+------+--------+------------+------+------------+------------------------+
| 3.45 | -90.77 | 2023-02-23 | ECU  | 1          | 0.42                   |
+------+--------+------------+------+------------+------------------------+
| 2.77 | -94.29 | 2023-02-18 | ECU  | 1          | 2.53                   |
+------+--------+------------+------+------------+------------------------+
| 3.66 | -93.88 | 2023-02-03 | ECU  | 1          | 0.88                   |
+------+--------+------------+------+------------+------------------------+
| 3.22 | -93.74 | 2023-02-17 | ECU  | 1          | 0.67                   |
+------+--------+------------+------+------------+------------------------+

# Propuesta de Análisis {#propuesta-de-análisis}

Los objetivos de este análisis serán:

1.  Identificar los países con mayor actividad de pesca en la ZEE de las islas galápagos.

2.  Conocer los artes de pesca que realizan el mayor esfuerzo de pesca dentro de la ZEE de las islas Galápagos.

3.  Obtener una serie temporal diaria de la actividad de pesca.

    1.  Todos los países combinados.

    2.  Para los países principales.

    3.  Para los artes de pesca.

4.  Identificar las zonas con mayor actividad de pesca.

5.  Identificar los periodos (meses) con mayor actividad de pesca.

# Análisis Paso a paso {#análisis-paso-a-paso}

## Actividad de pesca aparente por país de registro {#actividad-de-pesca-aparente-por-país-de-registro}

Para analizar los datos de pesca aparente por país de registro, tenemos que agrupar los datos por país y sumar las horas de pesca aparente para cada uno de ellos.

Esto lo vamos a hacer en dos pasos:

1.  Actividad acumulada de pesca aparente para todo el año por país, esto lo presentaremos en un gráfico.\
    Para esto primero agrupamos todas las embarcaciones que pertenecen al mismo país (`Flag`) y que son del mismo tipo (`Vessel.Type`), para luego sumar las horas de pesca aparente (`Apparent.Fishing.Hours`).

``` r
hpAnual <- data %>%
  group_by(Flag, Vessel.Type) %>% 
  summarise(hp = sum(Apparent.Fishing.Hours, na.rm=T))
```

Ahora que tenemos el número acumulado de horas podemos crear un gráfico usando **ggplot**.

``` r
ggplot(hpAnual) +
  geom_col(aes(x=Flag, y=hp, colour = Vessel.Type, fill=Vessel.Type)) +
  xlab("País") +
  ylab("Horas de pesca aparente (Hrs)") +
  scale_fill_discrete(name = "Tipo") +
  scale_colour_discrete(name = "Tipo") +
  ggthemes::theme_few() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 
```

```{=html}
<img
src="DatosGFW.markdown_strict_files/figure-markdown_strict/unnamed-chunk-2-1.png"
data-fig-align="center" data-fig-pos="H" />
```

1.  Actividad mensual de pesca aparente por de pesca por país y lo presentaremos en un gráfico.

    El proceso en este caso es similar, pero se debe ahora agrupar también por el `mes`. Para esto es necesario crear la columna **mes**, esto lo hacemos usando la funcion `dplr::mutate` y `lubridate::month`.

``` r
hpMes <- data %>%
  mutate(mes = month(Time.Range)) %>%  ## <- Obtenemos el mes desde la columna de la fecha
  group_by(mes, Flag, Vessel.Type) %>% ## Incluimos el mes en el grouping
  summarise(hp = sum(Apparent.Fishing.Hours, na.rm=T))

ggplot(hpMes) +
  geom_col(aes(x=Flag, y=hp, colour = Vessel.Type, fill=Vessel.Type)) +
  xlab("País") +
  ylab("Horas de pesca aparente (Hrs)") +
  scale_fill_discrete(name = "Tipo") +
  scale_colour_discrete(name = "Tipo") +
  ggthemes::theme_few() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  facet_wrap(~mes) ## <- Esto permite crear el grafico separando los meses
```

```{=html}
<img
src="DatosGFW.markdown_strict_files/figure-markdown_strict/unnamed-chunk-3-1.png"
data-fig-align="center" data-fig-pos="H" />
```

## Actividad de pesca aparente por arte de pesca {#actividad-de-pesca-aparente-por-arte-de-pesca}

Ahora podemos hacer exactamente el mismo proceso, pero esta vez en vez de usar el pais como variable de agrupación usamos el arte de pesca.

En esta ocasión, generamos dos data.frames en el mismo chunk de R, el anual y el mensual.

``` r
arteAnual <- data %>%
  group_by(Gear.Type, Vessel.Type) %>% 
  summarise(hp = sum(Apparent.Fishing.Hours, na.rm=T))
  

arteMensual <- data %>%
  mutate(mes = month(Time.Range)) %>%
  group_by(mes, Gear.Type, Vessel.Type) %>% 
  summarise(hp = sum(Apparent.Fishing.Hours, na.rm=T))
```

Y ahora presentamos los gráficos por arte de pesca.

``` r
ggplot(arteAnual) +
  geom_col(aes(x=Gear.Type, y=hp), fill ="darkorange") +
  xlab("Arte de Pesca") +
  ylab("Horas de pesca aparente (Hrs)") +
  scale_fill_discrete(name = "Tipo") +
  scale_colour_discrete(name = "Tipo") +
  ggthemes::theme_few() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 
```

```{=html}
<img
src="DatosGFW.markdown_strict_files/figure-markdown_strict/unnamed-chunk-5-1.png"
data-fig-align="center" data-fig-pos="H" />
```

Ahora presente el mismo tipo de gráficos, pero usamos `facet_wrap` para separar los artes de pesca, de esto forma motramos las horas de pesca aparente para cada mes, separando por el arte de pesca.

``` r
ggplot(arteMensual) +
  geom_col(aes(x=Gear.Type, y=hp), fill="darkorange") +
  xlab("Arte de Pesca") +
  ylab("Horas de pesca aparente (Hrs)") +
  scale_fill_discrete(name = "Tipo") +
  scale_colour_discrete(name = "Tipo") +
  ggthemes::theme_few() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  facet_wrap(~mes) ## <- Esto permite crear el grafico separando los meses
```

```{=html}
<img
src="DatosGFW.markdown_strict_files/figure-markdown_strict/unnamed-chunk-6-1.png"
data-fig-align="center" data-fig-pos="H" />
```

## Serie temporal de actividad diaria de pesca aparente {#serie-temporal-de-actividad-diaria-de-pesca-aparente}

### Para todos los países {#para-todos-los-países}

Ahora vamos a ver como es el esfuerzo de pesca aparente diario, para esto copararemos la actitividad total y luego por paises.

En este caso, lo que tenemos que hacer es agrupar el esfuerzo de pesca aparente por día (sumando el esfuerzo individual de cada barco), esto luego lo podemos hacer separando por país y/o arte de pesca.

En los gráficos anteriores vimos que Ecuador es el pías que realiza el mayor esfuerzo en esta área. Es por esto que solo usaremos los barcos ecuatorianos para este ejemplo. De esta forma es necesario filtrar los datos y para esto usamos la función `dplyr::filter` .

``` r
hpDiaEcu <- data %>%
  filter(Flag == "ECU") %>%  ## Aqui es donde filtramos para barcos de ecuador
  group_by(Time.Range) %>% ## Incluimos el mes en el grouping
  summarise(hp = sum(Apparent.Fishing.Hours, na.rm=T))
```

Y ahora vemos la serie temporal.

``` r
ggplot(hpDiaEcu) +
  geom_line(aes(x=as.Date(Time.Range), y=hp), col="darkorange") +
  xlab("Fecha") +
  ylab("Horas de pesca aparente (Hrs)") +
  ggthemes::theme_few() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

```{=html}
<img
src="DatosGFW.markdown_strict_files/figure-markdown_strict/unnamed-chunk-8-1.png"
data-fig-align="center" data-fig-pos="H" />
```

### Para los países principales {#para-los-países-principales}

Ahora haremos este gráfico temporal para los tres países (excluido Ecuador) que realizan el mayor esfuerzo de pesca aparente en la ZEE de las islas Galápagos.

Para esto entonces necesitamos excluir los barcos con bandera de ecuador (`filter != "ECU"`) y aquellas sin bandera conocida (`!is.na(Flag)`).

Con esto ahora, calculamos el total de horas de esfuerzo de pesca aparente por pías.

``` r
porPais <- data %>%
  filter(Flag != "ECU", Flag != "",
         !is.na(Flag)) %>%  ## Eliminamos embarcaciones de Ecuador y aquellas sin bandera
  group_by(Flag) %>% ## Incluimos el mes en el grouping
  summarise(hp = sum(Apparent.Fishing.Hours, na.rm=T)) %>% 
  arrange(desc(hp))

knitr::kable(porPais)
```

+------+--------+
| Flag | hp     |
+:=====+=======:+
| PAN  | 521.05 |
+------+--------+
| NIC  | 20.35  |
+------+--------+
| ESP  | 19.43  |
+------+--------+
| VEN  | 14.66  |
+------+--------+
| USA  | 6.11   |
+------+--------+
| VUT  | 0.34   |
+------+--------+
| COL  | 0.21   |
+------+--------+

En la tabla <a href="#tbl-hpXPais" class="quarto-xref">Table 3</a> que vamos que las horas de pesca de Vunuatu (VUT) y Colombia (COL) son insignificantes y pueden corresponder a falsos positivos, es por esto que tambien los eliminaremos del análisis.

``` r
diaNoEcu <- data %>%
  filter(Flag == c("PAN", "NIC" ,"ESP", "VEN", "USA")) %>%
  group_by(Flag, Time.Range) %>% ## Incluimos el mes en el grouping
  summarise(hp = sum(Apparent.Fishing.Hours, na.rm=T))
```

``` r
ggplot(diaNoEcu) +
  geom_point(aes(x=as.Date(Time.Range), y=hp, col = Flag)) +
  geom_line(aes(x=as.Date(Time.Range), y=hp, col = Flag)) +
  xlab("Fecha") +
  ylab("Horas de pesca aparente (Hrs)") +
  ggthemes::theme_few() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  facet_wrap(~Flag)
```

```{=html}
<img
src="DatosGFW.markdown_strict_files/figure-markdown_strict/unnamed-chunk-10-1.png"
data-fig-align="center" data-fig-pos="H" />
```

### Para los tres artes de pesca principales {#para-los-tres-artes-de-pesca-principales}

Ahora hacemos lo mismo para los artes de pesca.

``` r
arteDia <- data %>% 
  filter(Gear.Type != "INCONCLUSIVE",
         Gear.Type != "OTHER",
         Gear.Type != "PASSENGER"
         ) %>% 
  group_by(Gear.Type, Time.Range) %>% ## Incluimos el mes en el grouping
  summarise(hp = sum(Apparent.Fishing.Hours, na.rm=T))


data %>% 
  filter(Gear.Type != "INCONCLUSIVE",
         Gear.Type != "OTHER",
         Gear.Type != "PASSENGER"
         ) %>% 
  group_by(Gear.Type) %>% ## Incluimos el mes en el grouping
  summarise(hp = sum(Apparent.Fishing.Hours, na.rm=T)) %>% 
  arrange(desc(hp)) %>% 
  knitr::kable()
```

+--------------------+----------+
| Gear.Type          | hp       |
+:===================+=========:+
| DRIFTING_LONGLINES | 13356.48 |
+--------------------+----------+
| FISHING            | 7703.03  |
+--------------------+----------+
| TUNA_PURSE_SEINES  | 4262.67  |
+--------------------+----------+
| SET_LONGLINES      | 1863.25  |
+--------------------+----------+
| POLE_AND_LINE      | 40.45    |
+--------------------+----------+
| OTHER_PURSE_SEINES | 25.17    |
+--------------------+----------+

Ahora podemos presentar estos resultados.

``` r
ggplot(arteDia) +
  geom_point(aes(x=as.Date(Time.Range), y=hp, col = Gear.Type), size=.4) +
  geom_line(aes(x=as.Date(Time.Range), y=hp, col = Gear.Type), size=.4) +
  xlab("Fecha") +
  ylab("Horas de pesca aparente (Hrs)") +
  ggthemes::theme_few() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
    strip.text = element_text(size = 8)  # Adjust the facet title size
    )+
  facet_wrap(~Gear.Type)
```

```{=html}
<img
src="DatosGFW.markdown_strict_files/figure-markdown_strict/unnamed-chunk-11-1.png"
data-fig-align="center" data-fig-pos="H" />
```

## Análisis espacial de la actividad de pesca aparente {#análisis-espacial-de-la-actividad-de-pesca-aparente}

Ahora trabajamos con los datos espacialesomamos los datos espaciales

### Zonas con mayor actividad de pesca aparente total anual {#zonas-con-mayor-actividad-de-pesca-aparente-total-anual}

Aqui agrupamos los datos espaciales, sumando las horas de pesca aparente para todo el año, en cada una de las celdas y luego lo presentamos.

``` r
spAnual <- dataSP %>% 
  group_by(Lat, Lon) %>% 
  summarise(hp = sum(Apparent.Fishing.Hours, na.rm=T))
```

Ahora hacemos el mapa

``` r
ggplot(spAnual) +
  geom_tile(aes(x=Lon, y=Lat, z=hp))
```

```{=html}
<img
src="DatosGFW.markdown_strict_files/figure-markdown_strict/unnamed-chunk-13-1.png"
data-fig-align="center" data-fig-pos="H" />
```

Esta imágen se ve bastante mal, es necestio agregarlos las islas y mejor la presentación en términos generales.

``` r
# Get Galapagos land data

spAnual_sf <- st_as_sf(spAnual, coords = c("Lon", "Lat"), crs = 4326) # Lo transforma a un                                                              objeto geográfico

galapagos_land <- ne_countries(scale = "medium", returnclass = "sf") %>%
  filter(name == "Ecuador")  # Filter for Ecuador, as Galapagos belongs to Ecuador

ggplot() +
  # Add base map
  geom_sf(data = galapagos_land, fill = "grey50", color = "black") +
  # Add fishing data
  geom_tile(data = spAnual, aes(x = Lon, y = Lat, fill = hp, col=hp)) +
  # Define color gradient
  scale_color_gradient(low = "darkblue", high = "red", name = "Fishing Hours", limits = c(0, 50)) +
  scale_fill_gradient(low = "darkblue", high = "red", name = "Fishing Hours", limits = c(0, 50)) +
  scale_size_continuous(name = "Horas de Pesca Aparente") +
  labs(
    title = "Actividad de Aparente en Galapagos EEZ",
    x = "Longitud",
    y = "Latitud"
  ) +
  theme_minimal() +
  coord_sf(xlim = c(-95.5, -85), ylim = c(-4.5, 4.5))  # Adjust limits to Galapagos region
```

```{=html}
<img
src="DatosGFW.markdown_strict_files/figure-markdown_strict/unnamed-chunk-14-1.png"
data-fig-align="center" data-fig-pos="H" />
```

### Zonas con mayor actividad de pesca aparente aculada por mes {#zonas-con-mayor-actividad-de-pesca-aparente-aculada-por-mes}

Ahora haremos el mismo gráfico, pero separados por mes.

``` r
spMensual <- dataSP %>% 
  mutate(mes = month(Time.Range)) %>% 
  group_by(mes, Lat, Lon) %>% 
  summarise(hp = sum(Apparent.Fishing.Hours, na.rm=T))

ggplot() +
  geom_sf(data = galapagos_land, fill = "grey50", color = "black") +
  geom_tile(data = spMensual, aes(x = Lon, y = Lat, fill = hp, col=hp)) +
  scale_color_gradient(low = "darkblue", high = "red", name = "Fishing Hours", limits = c(0, 50)) +
  scale_fill_gradient(low = "darkblue", high = "red", name = "Fishing Hours", limits = c(0, 50)) +
  scale_size_continuous(name = "Horas de Pesca Aparente") +
  labs(
    title = "Actividad de Aparente en Galapagos EEZ",
    x = "Longitud", y = "Latitud" ) +
  theme_minimal() +
  coord_sf(xlim = c(-95.5, -85), ylim = c(-4.5, 4.5))  +# Adjust limits to Galapagos region
  facet_wrap(~mes)
```

```{=html}
<img
src="DatosGFW.markdown_strict_files/figure-markdown_strict/unnamed-chunk-15-1.png"
data-fig-align="center" data-fig-pos="H" />
```

# Usando gfwR {#usando-gfwr}

Si se cuenta con el tiempo suficiente, se presentará el uso del paquete `gfwR` para la descarga de los datos en forma directa desde R.

``` r
# Check/install remotes

#if (!require("remotes"))
#  install.packages("remotes")

#remotes::install_github("GlobalFishingWatch/gfwr",
#                        dependencies = TRUE)


require(gfwr)


## https://globalfishingwatch.org/our-apis/tokens
## usethis::edit_r_environ()
#GFW_TOKEN="PASTE_YOUR_TOKEN_HERE"


#key <- gfw_auth()
#key <- Sys.getenv("GFW_TOKEN")


espacial <- gfw_ais_presence(
    spatial_resolution = "HIGH",
    temporal_resolution = "DAILY",
    group_by = "VESSEL_ID",
    start_date = "2023-01-01",
    end_date = "2024-01-01",
    region = 8403, ##   MRGID para Galapagos
    region_source = "EEZ") 
```
