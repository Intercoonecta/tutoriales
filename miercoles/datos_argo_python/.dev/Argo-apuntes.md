# Apuntes para tutorial Argo

## Outline, temas y capacidades que cubrir

### 1. notebook sobre Argo, boyas

- motivacion de Argo
  - vs satelites (solo superficie del mar)
  - vs barcos
- plataforma (boyas perfiladoras)
  - caracteristicas, sensores
  - ciclos de perfilacion, en general
- Red Argo
  - Mapa global, cantidad de boyas activas
  - Ciclo de perfilacion estandarizado
  - Sensores, calidad de los datos
  - Integracion a red de transmision de datos, disponibilidad gratuita de datos
  - Screenshots de algunos sitios web y visualizaciones
  - Visitar un par de esos sitios
  - Argo Core vs BGC, DEEP
- Diferentes opciones para obtener los datos
  - ArgoPy, ArgoVis, downloads, ftp, ERDDAP, ...

### 2. notebook de argopy

- Presentación del área y preguntas que he escojido
  - Afloramiento (surgencia) de Golfo de Papagayo
  - Usar algunas imagenes de publicaciones

- argopy
  - capacidades
  - recursos en linea
    - Manual de usuario
    - Argopy School

  - ~~alternativas? O mejor las cubro en el primer notebook~~

- Acceso a datos a través de DataFetcher().region
  - Breve descripción de las diferentes opciones de fuentes de datos, tipo de usuarios, tipo de plataforma Argo, cache
  - Puntos vs perfiles
  - Descripcion de los datos obtenidos
  - Guardar datos en archivo netcdf local?
  - Otras maneras de acceder a los datos por argopy, que no abordaré (ArgoFloat, index)

- Filtración de datos??
  - descenso vs ascenso
  - real-time vs delayed vs qc'd

- Breve presentación del argopy Dashboard
- Examinar datos obtenidos
  - Mapa
  - resumenes de los datos (conteos, etc)

- Convertir a perfiles
  - resumenes de los datos
  - Plots de perfiles
    - individuales
    - julio vs enero

- Calcular MLD
  - Computaciones
  - Mapas

- Oxigeno, Argo BGC
  - Obtener datos con oxigeno
  - Presentar un mapa, algunos perfiles



## miscelaneo

- Red Argo nacio en 2001. Impulsado por WMO, IOC, ICSU, PNUMA. Pero las contribuciones son basadas en el lanzamiento de boyas por parte de cada pais o entidad cientifica
- ~ 4000 boyas activas en cualquier momento dado
- cada ciclo dura ~ 10 dias
- deriva a 1000m y descenso hasta 2000m
- datos disponables libremente al publico en un plazo inferior a 12 horas
- vida media ~ 4 años (aunque perfiladores nuevos cada vez duran más)
- tipos de datos
  - real-time v delayed mode / qc'd (verificar esto)
  - Core vs BGC vs DEEP
- Boyas que son parte de Red Argo vs boyas del mismo tipo actuando independientemente, sin coneccion a la red o adherencia a sus requisitos


## Terminologia, vocabulario

- https://www.argoespana.es/
- boyas a la deriva
- perfiladores, boyas perfiladoras
- derivando (drifting); profundidad de deriva
- descenso y ascenso
- sumergir, superficie
- Sistema de Observación Global del Océano
