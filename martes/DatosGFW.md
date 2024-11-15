# Trabajando con datos de Global Fishing Watch
Jorge Cornejo-Donoso
November 15, 2024

-   [Global Fishing Watch](#global-fishing-watch)
-   [Datos](#datos)
    -   [Descripción de los datos](#descripción-de-los-datos)
-   [Propuesta de Análisis](#propuesta-de-análisis)
-   [Análisis Paso a paso](#análisis-paso-a-paso)
    -   [Actividad de pesca aparente por país de
        registro](#actividad-de-pesca-aparente-por-país-de-registro)
    -   [Actividad de pesca aparente por arte de
        pesca](#actividad-de-pesca-aparente-por-arte-de-pesca)
    -   [Serie temporal de actividad diaria de pesca
        aparente](#serie-temporal-de-actividad-diaria-de-pesca-aparente)
        -   [Para todos los países](#para-todos-los-países)
        -   [Para los tres países
            principales](#para-los-tres-países-principales)
        -   [Para los tres artes de pesca
            principales](#para-los-tres-artes-de-pesca-principales)
    -   [Análisis espacial de la actividad de pesca
        aparente](#análisis-espacial-de-la-actividad-de-pesca-aparente)
        -   [Zonas con mayor actividad de pesca aparente total
            anual](#zonas-con-mayor-actividad-de-pesca-aparente-total-anual)
        -   [Zonas con mayor actividad de pesca aparente aculada por
            mes](#zonas-con-mayor-actividad-de-pesca-aparente-aculada-por-mes)
        -   [Zonas de actividad de pesca aparente anual por pais de
            registro de la
            embarcación](#zonas-de-actividad-de-pesca-aparente-anual-por-pais-de-registro-de-la-embarcación)

# Global Fishing Watch

Global Fishing Watch (GFW) es una organización no gubernamental (ONG)
que busca avanzar en la gobernanza de los océanos a través de una mayor
transparencia de la actividad humana en el mar. Al crear y compartir
públicamente visualizaciones de mapas, datos y herramientas de análisis,
permiten la investigación científica e impulsan una transformación en la
forma en que gestiona el océano.

Global Fishing Watch genera nuevo conocimiento utilizando tecnología de
punta para convertir big data en información procesable. Comparten esa
información públicamente y de forma gratuita para acelerar la ciencia e
impulsar políticas y prácticas más justas e inteligentes que recompensen
el buen comportamiento y protejan la biodiversidad, la pesca y los
medios de subsistencia.

Para más información http://www.globalfishingwatch.org

Mapa de visualización y acceso a datos
<http://www.globalfishingwatch.org/map>

# Datos

GFW compila una cantidad masiva da datos de posiciones de embarcaciones
(AIS y VMS), de registro de embarcaciones y otra infraestructuras
marinas, y las hace disponibles en sus distintas plataformas. El acceso
a estos datos e información es completamente gratuita y se puede hacer
directamente en sus plataformas
[WEB](http://www.globalfishingwatch.org/map),
[API](https://globalfishingwatch.org/es/nuestras-api/), [paquete de
R](https://github.com/GlobalFishingWatch/gfwr) y de [libreria de
Python](https://pypi.org/project/gfw/).

Si bien la mayoría de los datos de GFW son gratuitos y de libre uso,
para acceder a alguno de ellos es necesario crear una cuenta, esto es
totalmente gratuito. Para esto se va a la página principal de la
plataforma (<http://www.globalfishingwatch.org/map>) y en el extremo
inferior izquierdo se puede hacer click en el icono
([<img src="imagenes/registerIcon.png" width="20" height="22" />](https://gateway.api.globalfishingwatch.org/v3/auth?client=gfw&callback=https%3A%2F%2Fglobalfishingwatch.org%2Fmap%2Findex%3FcallbackUrlStorage%3Dtrue&locale=es&_gl=1*1cgh3pa*_gcl_au*MTI2MzYyNzc4OS4xNzI5NjE3OTg1*_ga*MTkzMzc2NTQwNy4xNzIxODQxMzU4*_ga_5W83X3EYGW*MTczMTY3MjkzOC4xMTMuMS4xNzMxNjczNzY3LjUwLjAuMTAxOTEzNjI4Mw..*_ga_M5J2ZHDZMV*MTczMTY3MjkzOC41My4xLjE3MzE2NzM4NDcuNjAuMC40MDQxOTg0OTQ.)),
se debe seguir el proceso de registro y se tiene acceso a descargar los
datos.

Para este ejercicio, vamos a usar los datos de esfuerzo de pesca
aparente, derivado de los dispositivos AIS, para todo el año 2023, en la
[zona economica exclusiva que rodea las islas
Galápagos](https://globalfishingwatch.org/map/index?start=2024-08-12T00%3A00%3A00.000Z&end=2024-11-12T00%3A00%3A00.000Z&longitude=-87.53436510669711&latitude=-0.1438653714849388&zoom=5.3216383206620534&sbO=true&dvIn%5B0%5D%5Bid%5D=presence&dvIn%5B0%5D%5Bcfg%5D%5Bvis%5D=false&dvIn%5B1%5D%5Bid%5D=context-layer-eez&dvIn%5B1%5D%5Bcfg%5D%5Bvis%5D=true&dvIn%5B2%5D%5Bid%5D=vms&dvIn%5B2%5D%5Bcfg%5D%5Bvis%5D=false&dvIn%5B3%5D%5Bid%5D=ais&dvIn%5B3%5D%5Bcfg%5D%5Bvis%5D=true&tV=heatmap)
de la república del Ecuador, tanto como una serie de tiemporal diaria
por barco y por unidad espacial (0.01°x0.01°) .

Durante la presentación se describirá como acceder a estos datos, sin
embarco en este documento solo se comparte el resultado de este proceso
([descarga de
datos](https://drive.google.com/file/d/1PkXJAQ5HEJNFZQLRI5xNThnvSZmxSObK/view?usp=sharing)).

## Descripción de los datos

Los datos temporales que vamos a utilizar en este ejercicio son las
horas de pesca aparente diaria por embarcación detectada dentro de esta
área de interés.

Estos datos además contienen información acerca de las embarcaciones,
con nombre, numero IMO, bandera, arte de pesca entre otros
(<a href="#tbl-datosTS" class="quarto-xref">Table 1</a>).

<table class="do-not-create-environment cell">
<colgroup>
<col style="width: 5%" />
<col style="width: 2%" />
<col style="width: 6%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 9%" />
<col style="width: 6%" />
<col style="width: 5%" />
<col style="width: 2%" />
<col style="width: 4%" />
<col style="width: 12%" />
<col style="width: 11%" />
<col style="width: 11%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Time.Range</th>
<th style="text-align: left;">Flag</th>
<th style="text-align: left;">Vessel.Name</th>
<th style="text-align: left;">Entry.Timestamp</th>
<th style="text-align: left;">Exit.Timestamp</th>
<th style="text-align: left;">Gear.Type</th>
<th style="text-align: left;">Vessel.Type</th>
<th style="text-align: right;">MMSI</th>
<th style="text-align: right;">IMO</th>
<th style="text-align: left;">CallSign</th>
<th style="text-align: left;">First.Transmission.Date</th>
<th style="text-align: left;">Last.Transmission.Date</th>
<th style="text-align: right;">Apparent.Fishing.Hours</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">2023-01-10</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: left;">DONA ROGE</td>
<td style="text-align: left;">2023-01-10T10:00:00Z</td>
<td style="text-align: left;">2023-10-07T11:00:00Z</td>
<td style="text-align: left;">TUNA_PURSE_SEINES</td>
<td style="text-align: left;">FISHING</td>
<td style="text-align: right;">735057685</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">HC4301</td>
<td style="text-align: left;">2020-09-07T16:27:31Z</td>
<td style="text-align: left;">2024-10-21T03:13:40Z</td>
<td style="text-align: right;">1.49</td>
</tr>
<tr class="even">
<td style="text-align: left;">2023-04-15</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: left;">TINTORERA</td>
<td style="text-align: left;">2023-01-03T13:00:00Z</td>
<td style="text-align: left;">2023-04-15T17:00:00Z</td>
<td style="text-align: left;">FISHING</td>
<td style="text-align: left;">FISHING</td>
<td style="text-align: right;">735059515</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">HC-5964</td>
<td style="text-align: left;">2020-05-31T16:10:36Z</td>
<td style="text-align: left;">2024-03-08T18:17:43Z</td>
<td style="text-align: right;">0.50</td>
</tr>
<tr class="odd">
<td style="text-align: left;">2023-06-13</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: left;">DONA ROGE</td>
<td style="text-align: left;">2023-01-10T10:00:00Z</td>
<td style="text-align: left;">2023-10-07T11:00:00Z</td>
<td style="text-align: left;">TUNA_PURSE_SEINES</td>
<td style="text-align: left;">FISHING</td>
<td style="text-align: right;">735057685</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">HC4301</td>
<td style="text-align: left;">2020-09-07T16:27:31Z</td>
<td style="text-align: left;">2024-10-21T03:13:40Z</td>
<td style="text-align: right;">1.15</td>
</tr>
<tr class="even">
<td style="text-align: left;">2023-07-13</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: left;">GRAND KNIGHT</td>
<td style="text-align: left;">2023-05-25T23:00:00Z</td>
<td style="text-align: left;">2023-07-13T11:00:00Z</td>
<td style="text-align: left;">DRIFTING_LONGLINES</td>
<td style="text-align: left;">FISHING</td>
<td style="text-align: right;">735058937</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">HC5259</td>
<td style="text-align: left;">2022-07-29T23:58:42Z</td>
<td style="text-align: left;">2023-08-06T02:33:27Z</td>
<td style="text-align: right;">11.26</td>
</tr>
<tr class="odd">
<td style="text-align: left;">2023-08-06</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: left;">JOTA JOTA</td>
<td style="text-align: left;">2023-04-07T06:00:00Z</td>
<td style="text-align: left;">2023-10-01T19:00:00Z</td>
<td style="text-align: left;">DRIFTING_LONGLINES</td>
<td style="text-align: left;">FISHING</td>
<td style="text-align: right;">735058780</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">HC2508</td>
<td style="text-align: left;">2022-01-03T17:28:38Z</td>
<td style="text-align: left;">2024-11-12T23:56:26Z</td>
<td style="text-align: right;">8.31</td>
</tr>
<tr class="even">
<td style="text-align: left;">2023-09-12</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: left;">DON F</td>
<td style="text-align: left;">2023-06-19T22:00:00Z</td>
<td style="text-align: left;">2023-10-05T13:00:00Z</td>
<td style="text-align: left;">TUNA_PURSE_SEINES</td>
<td style="text-align: left;">FISHING</td>
<td style="text-align: right;">735060354</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">HC6655</td>
<td style="text-align: left;">2023-05-08T22:41:27Z</td>
<td style="text-align: left;">2024-11-12T23:58:56Z</td>
<td style="text-align: right;">11.88</td>
</tr>
</tbody>
</table>

En relación a los datos espaciales que se van a utilizar en este
ejercicio son las horas de pesca aparente diaria por unidad espacial de
0.01°x0.01° de latitud y longitud
(<a href="#tbl-datosSP" class="quarto-xref">Table 2</a>).

<table class="do-not-create-environment cell">
<thead>
<tr class="header">
<th style="text-align: right;">Lat</th>
<th style="text-align: right;">Lon</th>
<th style="text-align: left;">Time.Range</th>
<th style="text-align: left;">flag</th>
<th style="text-align: right;">Vessel.IDs</th>
<th style="text-align: right;">Apparent.Fishing.Hours</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: right;">4.45</td>
<td style="text-align: right;">-91.19</td>
<td style="text-align: left;">2023-02-23</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.02</td>
</tr>
<tr class="even">
<td style="text-align: right;">3.39</td>
<td style="text-align: right;">-94.24</td>
<td style="text-align: left;">2023-02-20</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">1.12</td>
</tr>
<tr class="odd">
<td style="text-align: right;">3.45</td>
<td style="text-align: right;">-90.77</td>
<td style="text-align: left;">2023-02-23</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.42</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.77</td>
<td style="text-align: right;">-94.29</td>
<td style="text-align: left;">2023-02-18</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">2.53</td>
</tr>
<tr class="odd">
<td style="text-align: right;">3.66</td>
<td style="text-align: right;">-93.88</td>
<td style="text-align: left;">2023-02-03</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.88</td>
</tr>
<tr class="even">
<td style="text-align: right;">3.22</td>
<td style="text-align: right;">-93.74</td>
<td style="text-align: left;">2023-02-17</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.67</td>
</tr>
</tbody>
</table>

# Propuesta de Análisis

Los objetivos de este análisis serán:

1.  Identificar los países con mayor actividad de pesca en la ZEE de las
    islas galápagos.

2.  Conocer los artes de pesca que realizan el mayor esfuerzo de pesca
    dentro de la ZEE de las islas Galápagos.

3.  Obtener una serie temporal diaria de la actividad de pesca.

    1.  Todos los piases combinados.

    2.  Para los 3 países principales.

    3.  Para los 3 artes de pesca principales.

4.  Identificar las zonas con mayor actividad de pesca.

5.  Identificar los periodos (meses) con mayor actividad de pesca.

6.  Visualizar la actividad de pesca anual por pais de registro de la
    embacación.

# Análisis Paso a paso

## Actividad de pesca aparente por país de registro

## Actividad de pesca aparente por arte de pesca

## Serie temporal de actividad diaria de pesca aparente

### Para todos los países

### Para los tres países principales

### Para los tres artes de pesca principales

## Análisis espacial de la actividad de pesca aparente

### Zonas con mayor actividad de pesca aparente total anual

### Zonas con mayor actividad de pesca aparente aculada por mes

### Zonas de actividad de pesca aparente anual por pais de registro de la embarcación
