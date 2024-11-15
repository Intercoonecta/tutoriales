# Trabajando con datos de Global Fishing Watch
Jorge Cornejo-Donoso
November 15, 2024

-   [Global Fishing Watch](#global-fishing-watch)
-   [Datos](#datos)
    -   [Descripción de los datos](#descripción-de-los-datos)
-   [Análisis](#análisis)

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
aparente, derivado de los dispositivos AIS, para el mes de octubre de
2024, en la [zona economica exclusiva que rodea las islas
Galápagos](https://globalfishingwatch.org/map/index?start=2024-08-12T00%3A00%3A00.000Z&end=2024-11-12T00%3A00%3A00.000Z&longitude=-87.53436510669711&latitude=-0.1438653714849388&zoom=5.3216383206620534&sbO=true&dvIn%5B0%5D%5Bid%5D=presence&dvIn%5B0%5D%5Bcfg%5D%5Bvis%5D=false&dvIn%5B1%5D%5Bid%5D=context-layer-eez&dvIn%5B1%5D%5Bcfg%5D%5Bvis%5D=true&dvIn%5B2%5D%5Bid%5D=vms&dvIn%5B2%5D%5Bcfg%5D%5Bvis%5D=false&dvIn%5B3%5D%5Bid%5D=ais&dvIn%5B3%5D%5Bcfg%5D%5Bvis%5D=true&tV=heatmap)
de la república del Ecuador.

Durante la presentación se describirá como acceder a estos datos, sin
embarco en este documento solo se comparte el resultado de este proceso
([descarga de
datos](https://drive.google.com/file/d/1I2qQ1kEcobrC7svPkXzICL3pEukLFv8F/view?usp=sharing)).

## Descripción de los datos

Los datos descargados que vamos a utilizar en este ejercicio son las
horas de pesca aparente diaria por embarcación detectada dentro de esta
área de interés.

Estos datos además contienen información acerca de las embarcaciones,
con nombre, numero IMO, bandera, arte de pesca entre otros
(<a href="#tbl-datos" class="quarto-xref">Table 1</a>).

<table class="do-not-create-environment cell">
<colgroup>
<col style="width: 5%" />
<col style="width: 2%" />
<col style="width: 8%" />
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
<td style="text-align: left;">2024-10-14</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: left;">ROLTON</td>
<td style="text-align: left;">2024-10-10T03:00:00Z</td>
<td style="text-align: left;">2024-10-17T18:00:00Z</td>
<td style="text-align: left;">DRIFTING_LONGLINES</td>
<td style="text-align: left;">FISHING</td>
<td style="text-align: right;">735060449</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">HC6736</td>
<td style="text-align: left;">2024-04-11T22:56:07Z</td>
<td style="text-align: left;">2024-11-12T23:53:51Z</td>
<td style="text-align: right;">20.47</td>
</tr>
<tr class="even">
<td style="text-align: left;">2024-10-30</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: left;">AMBAR</td>
<td style="text-align: left;">2024-10-28T00:00:00Z</td>
<td style="text-align: left;">2024-10-30T22:00:00Z</td>
<td style="text-align: left;">DRIFTING_LONGLINES</td>
<td style="text-align: left;">FISHING</td>
<td style="text-align: right;">735059903</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">HC6330</td>
<td style="text-align: left;">2023-06-14T14:11:03Z</td>
<td style="text-align: left;">2024-11-12T21:57:40Z</td>
<td style="text-align: right;">23.42</td>
</tr>
<tr class="odd">
<td style="text-align: left;">2024-10-29</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: left;">MARIA TATIANA II</td>
<td style="text-align: left;">2024-10-27T11:00:00Z</td>
<td style="text-align: left;">2024-10-30T22:00:00Z</td>
<td style="text-align: left;">DRIFTING_LONGLINES</td>
<td style="text-align: left;">FISHING</td>
<td style="text-align: right;">735057853</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">HC4344</td>
<td style="text-align: left;">2021-11-02T20:20:01Z</td>
<td style="text-align: left;">2024-11-12T21:59:42Z</td>
<td style="text-align: right;">23.84</td>
</tr>
<tr class="even">
<td style="text-align: left;">2024-10-10</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: left;">ROLTON</td>
<td style="text-align: left;">2024-10-10T03:00:00Z</td>
<td style="text-align: left;">2024-10-17T18:00:00Z</td>
<td style="text-align: left;">DRIFTING_LONGLINES</td>
<td style="text-align: left;">FISHING</td>
<td style="text-align: right;">735060449</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">HC6736</td>
<td style="text-align: left;">2024-04-11T22:56:07Z</td>
<td style="text-align: left;">2024-11-12T23:53:51Z</td>
<td style="text-align: right;">15.88</td>
</tr>
<tr class="odd">
<td style="text-align: left;">2024-10-28</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: left;">AMBAR</td>
<td style="text-align: left;">2024-10-28T00:00:00Z</td>
<td style="text-align: left;">2024-10-30T22:00:00Z</td>
<td style="text-align: left;">DRIFTING_LONGLINES</td>
<td style="text-align: left;">FISHING</td>
<td style="text-align: right;">735059903</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">HC6330</td>
<td style="text-align: left;">2023-06-14T14:11:03Z</td>
<td style="text-align: left;">2024-11-12T21:57:40Z</td>
<td style="text-align: right;">20.70</td>
</tr>
<tr class="even">
<td style="text-align: left;">2024-10-27</td>
<td style="text-align: left;">ECU</td>
<td style="text-align: left;">MARIA TATIANA II</td>
<td style="text-align: left;">2024-10-27T11:00:00Z</td>
<td style="text-align: left;">2024-10-30T22:00:00Z</td>
<td style="text-align: left;">DRIFTING_LONGLINES</td>
<td style="text-align: left;">FISHING</td>
<td style="text-align: right;">735057853</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">HC4344</td>
<td style="text-align: left;">2021-11-02T20:20:01Z</td>
<td style="text-align: left;">2024-11-12T21:59:42Z</td>
<td style="text-align: right;">10.94</td>
</tr>
</tbody>
</table>

# Análisis

Los objetivos de este análisis serán:

1.  Identificar los países con mayor actividad de pesca en la ZEE de las
    islas galápagos.

2.  Conocer los artes de pesca que realizan el mayor esfuerzo de pesca
    dentro de la ZEE de las islas Galápagos.

3.  Obtener una serie temporal diaria de la actividad de pesca.

    1.  Todos los paises combinados.

    2.  Para los 3 países principales.

    3.  Para los 3 artes de pesca principales.
