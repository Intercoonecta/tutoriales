#############################################################
#  Haakaton: Aplicación de isótopos estables en ecología (R)    # 
#  Ponente: Jose Canseco 
#  correo electronico: jantonio.canseco@ieo.csic.es

# Introduccion al uso de isotopos estables
# A modo de introduccion simplemente definir un isotopo estable es una forma no radiactiva de los elementos quimicos
# que no se descomponen de manera espontanea. En general, suelen ser menos abundantes que el elemento del que derivan.  
# Para su medida, se utilizan estandares internacionales cuyas proporciones son conocidad y estables.
# Se utiliza la PeeDee Belemite (Roca Calcita) como estandar de carbono y nitrogeno atmosferico para el nitrogeno. 
# El isotopo estable de nitrogeno es el d15N mientras que para el carbono es el d13C. El d15N nos da una idea sobre la parte de la trama trofica donde
# se encuentra nuestro individuo/poblacion mientras que el carbono nos proporciona informacion sobre su fuente de energia. Un aspecto  importante es el 
# denominado factor de discriminacion trofica (FDT) que es la diferencia entre el valor isotopico de una presa/fuente de alimento y el consumidor. Para
# el nitrogeno, el promedio es 3.4 ppm mientras que para el carbono es 1 ppm. El d15N se ve afectado por diferentes procesos como son la nitrificacion/desnitrificacion en suelos
# los fenomenos de afloramiento y descargas en rios en el medio marino mientras que el d13C se afectado por la estrategia fotosintetica de la plantas siendo
# las plantas C3 con valores mas alto de d3C mientras que el fitoplancton marino los valores mas bajos. 

###----------------------------------------------------------------------------------------------------------------------------------------
###########------------------- Comenzamos la sesion --------------------#################
###----------------------------------------------------------------------------------------------------------------------------------------
# Primero que nada, es necesario cargar todas librerias necesarias para el correcto funcionamiento de este script
# 1. Instalamos paquetes utilizando la funcion install.packages
# install.packages(c("tidyverse", "dplyr", "plyr", "reshape2", "ggpubr", "MixSiar", "tRophicPosition", "SIBER")) 
# Cargamos los paquetes en nuestro entorno R
library(tidyverse); library(dplyr); library(plyr); library(reshape2); library(RColorBrewer)
library(ggpubr); library(MixSIAR); library(tRophicPosition)


###----------------------------------------------------------------------------------------------------------------------------------------
###########------- 1.0 Introduccion al analisis exploratorio de datos de isotopoes estables --------------------#################
###----------------------------------------------------------------------------------------------------------------------------------------
# Los datos a utilizar provienen de una campaña antartica llevada a cabo en el año 2019 en donde se obtuvieron muestras de tejido de peces e invertebrados
# para su posterior analisis de isotopos estables de carbono y nitrogeno. La especie objetivo de dicho estudio fue el draco rayado, un pez de hielo
# que en los años 70s y 80s era la especie de mesopelagico mas abundante hasta su colapso a principios de los 90s.

# Nuestros objetivos eran estimar su posicion trofica (lugar en la trama trofica), la contribucion de diferentes presas a su tejido muscular y su uso de recursos.

# Comenzamos leyendo nuestros datos y estimando medidas de centralidad, dispersion y variabilidad
# 1.1 Establecemos  nuestro directorio de trabajo
setwd("G:/Mi unidad/Curso Isotopos/Haakaton/Introduccion")
sp2<-read.csv("Pelagic_foodweb.csv")
sp2
# Comprobemos la estructura de nuestros datos
str(sp2)
# Cambiamos la variable especie (sp) de caracter a factor para facilitar la manipulacion
sp2$sp<-as.factor(sp2$sp)
# Obtenemos la media por especie
m_l<-aggregate(cbind(d15N, d13C)~sp, data=sp2, FUN=mean)
m_l
# Y su desviacion estandar
sd_l<-aggregate(cbind(d15N, d13C)~sp, data=sp2, FUN=sd)
sd_l
# Unimos los dataframes creados 
descriptive_l<-cbind(m_l, sd_l)
# Eliminamos columna repetida
descriptive_l<-descriptive_l[-4]
# Renombramos
colnames(descriptive_l)<-c("Sp", "d15N", "d13C", "sdd15N", "sdd13C")
# Miremos el objeto
descriptive_l
## Ahiora vamos a mirar el rango en el que varian ambos isotopos y el numero de observaciones
range_l<-aggregate(cbind(d15N, d13C)~sp, data=sp2, FUN=range)
range_l
# N (Cuantas observaciones?)
length_l<-aggregate(cbind(d15N, d13C)~sp, data=sp2, FUN=length)
length_l

# Podemos utilizar librerias para hacer esto de forma mas sencilla (menos lineas) pero requiere que dichas librerias esten actualizadas
# Utilizamos plyr
# Cambiamos especie a factor
sp2$sp<-as.factor(sp2$sp)
data_res_lant<- ddply(sp2, c("sp"), summarize, 
                      count = length(sp),
                      mC = mean(d13C, na.rm = TRUE),
                      sdC = sd(d13C, na.rm = TRUE),
                      mN = mean(d15N, na.rm = TRUE),
                      sdN = sd(d15N, na.rm = TRUE))
data_res_lant


# Normalmente, y debido a trayectorias metabolicas, el d13C se encuentra en menor proporcion en el musculo debido a que dicho tejido contiene lipidos
# Por lo tanto, es importante determinar si mi mi muestra contiene una concentracion alta de lipidos lo cual podria llevar a sesgos en mis resultados. 
# Existen dos posibilidades, eliminar los lipidos mediante extraccion quimica o a traves de correccion matematica
#  Para determinarlo, hacemos un grafico que tenga mi proporcion de C y N en el eje x y el d13C en el eje y.
# Lo hare solo para el draco rayado
mack=subset(sp2, sp %in% "Champsocephalus gunnari")
ggplot(data=mack, aes(x=CN, y=d13C))+
  geom_smooth(method="lm")+geom_point()+
  facet_grid(sex~., scales="free_y")+
  theme_bw()

### En este caso, tenemos un pequeño problema con los lipidos ya que vemos una tendencia decreciente y algunos valores de RCN estan por encima de 3.5.
# Como regla general, RCN<3.5 no hay problema
# Obtenemos el contenido lipido
mack$L<-with(mack,-20.54+7.24*CN)

mean(mack$d13C);sd(mack$d13C)
mean(mack$CN);sd(mack$CN)

# Para corregirlo matematicamente, utililizamos la ecuacion para peces desarrollada por Kiljunen et al.(2006) # Ojo que esta correcion no es apropiada para invertebrados!!!
# Sin corregir
mack$d13C 
# Aqui aplico la ecuacion
mack$d13Cc<-with(mack,ifelse(CN>3.5, d13C+7.018*(0.048+3.9/(1+287/L)),d13C))
# Corrected
mack$d13Cc 


### Observemos y analicemos el grafico
ggplot(data=mack, aes(x=d13C, y=d13Cc,size=CN))+geom_point()+geom_abline()+theme_bw()
# Observamos que todos los puntos estan por encima del 1:1 y nos dice que cuando se corrigen, se situan por debajo de la linea recta entre las x e y.
# A mayor el circulo, mayor es la correcion!!!


##---------------------------------------------------------------------------------
# Seguomos explorando los datos
### Ahora simmplemente graficaremos nuestros isotopos frente a diferentes variables para empezar a detectar patrones que nos permitan mostrar evidencia en favor de nuestras hipotesis
# Cambiamos sexo a factor
mack$sex<-as.factor(mack$sex)
n1=ggplot()+geom_point(data=mack, aes(y=d15N, x=length, col=sex))+geom_smooth(data=mack, aes(y=d15N, x=length), method="lm")+
  theme_bw()+ylab(expression(paste(delta^15,N)))
c1<-ggplot()+geom_point(data=mack, aes(y=d13Cc, x=length, col=sex))+geom_smooth(data=mack, aes(y=d13C, x=length), method="lm")+
  theme_bw()+ylab(expression(paste(delta^13,C)))

#### Plots together
ggarrange(n1, c1, common.legend = TRUE, ncol=2)








###----------------------------------------------------------------------------------------------------------------------------------------
###########------- 2.0 Graficos utilizando datos de SIA --------------------#################
###----------------------------------------------------------------------------------------------------------------------------------------
# En este segundo apartado veremos como hacer los graficos mas comunes al usar datos de isotopos estables
x11(); ggplot()+geom_point(data=sp2, aes(x=d13C, y=d15N))+ # Al usar geom_point puedo hacer un grafico biplot al computar el d15N como y y d13C como x
  theme_bw() # Con esta funcion pongo el fondo blanco

# Ahora le dare forma y color a las especies de mi comunidad pelagica 
x11();ggplot()+geom_point(data=sp2, aes(x=d13C, d15N, col=sp, shape=sp))+ # He añadido col y shape para usar diferentes colores y formas para cada especie
  theme_bw()

# Grafico mas elegante
# Por especies
ggplot()+geom_point(data=sp2, aes(x=d13C, d15N, col=sp, shape=sp))+ # He añadido col y shape para usar diferentes colores y formas para cada especie
  theme_bw()+
  xlab(expression(paste(delta^13,C)))+ ylab(expression(paste(delta^15,N))) # Cambio los nombres de los ejes x e y

# Observemos y discutamos

# Sigamos explorando al hacer elipses alededor de los datos de cada especie, nos da informacion sobre nicho isotopico (uso de recursos y habitat)
ggplot()+geom_point(data=sp2, aes(x=d13C, d15N, col=sp))+ # He añadido col y shape para usar diferentes colores y formas para cada especie
  stat_ellipse(data=sp2, aes(x=d13C, d15N, col=sp))+
  theme_bw()+
  xlab(expression(paste(delta^13,C)))+ ylab(expression(paste(delta^15,N))) #  Cambio los nombres de los ejes x e y

## Vamos a hacer un subset de datos con las especies de peces
pela<-subset(sp2, sp %in% c("Champsocephalus gunnari", "Electro antartica", "Gymnoscopelus braueri"))
ggplot()+geom_point(data=pela, aes(x=d13C, d15N, col=sp))+ # He añadido col y shape para usar diferentes colores y formas para cada especie
  stat_ellipse(data=pela, aes(x=d13C, d15N, col=sp))+
  theme_bw()+
  xlab(expression(paste(delta^13,C)))+ ylab(expression(paste(delta^15,N))) # Change the y and x labels



### Vamos a crear un biplot con medias y sd para cada especie, este grafico es el que se podria poner en una publicacion
brewer.pal(n = 8, name = "Dark2")
colorBlindBlack8  <- c("#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E", "#E6AB02", "#A6761D", "#666666")
# Obtenemos las medias
m_by_sp<-aggregate(cbind(d15N, d13C)~sp, data=sp2, FUN=mean)
# Now the standard deviaion
sd_by_sp<-aggregate(cbind(d15N, d13C)~sp, data=sp2, FUN=sd)
# Merging df
my_data_means<-cbind(m_by_sp, sd_by_sp)
my_data_means<-my_data_means[-4]
colnames(my_data_means)<-c("Sp", "d15N", "d13C", "sdd15N", "sdd13C")
x11();ggplot()+ geom_errorbar(data=my_data_means, aes(x=d13C, y=d15N, ymin = d15N-sdd15N,ymax = d15N+sdd15N, col=Sp)) + 
  geom_errorbarh(data=my_data_means, aes(x=d13C, y=d15N, xmin = d13C+sdd13C,xmax = d13C-sdd13C, col=Sp))+
  scale_colour_manual("", values=colorBlindBlack8)+ #1:nlevels(sources$prey))+
  scale_fill_manual("", values=1:nlevels(my_data_means$sp))+
  theme_bw()+xlab(delta^"13"~"C (\u2030)")+ylab(delta^"15"~"N (\u2030)")+theme(
    text = element_text(size = 16),
    legend.position="bottom",
    legend.text = element_text(color = "black", size=7, face="italic"),
    #legend.key.size = unit(0.1, 'cm'),
    strip.background = element_rect(colour="black", fill="white"))









###----------------------------------------------------------------------------------------------------------------------------------------
###########------- 3.0 Estimacion de la posicion trofica --------------------#################
###----------------------------------------------------------------------------------------------------------------------------------------
# Para la estimacion de la posicion trofica, utilizaremos dos de la sespecies de peces de nuestro set de datos de la Antartica: pez de hielo y pez linterna
# Como muchas especies habitando el ecositema antartico, su principal especie de presa es el krill, o no?
setwd("G:/Mi unidad/Curso Isotopos/Haakaton/Posicion trofica") # Establecemos nuestro WD (folder que esta en sus computadores)
pel<-read.csv("Pelagic foodweb.csv")
# Borramos la primera columna
pel<-pel[,-1]
# Checamos los datos en la consola
pel 
# Vemos la dimension de nuestro df
dim(pel) 
# Vamos a mirar las 5 primeras filas de nuestros datos
head(pel)   
# Vamos a ver los nombres de nuestras variables (columnss)
names(pel)   
# Podemos editar nuestro data frame utilizando la funcion fix pero hay que tener cuidado ya que guarda los cambio en el archivo csv.
# Precaucion!!!! Cambia los datos permanentemente
fix(pel)
# Miramos la estructura de los datos
str(pel)
#### 2.0 Vamos a hacer un grafico para ver los datos ##########
# A traves de ggplot
x11(); ggplot()+geom_point(subset(pel, FG=="icefish"), mapping=aes(x=d13C, y=d15N, col=FG, shape=FG))+
  geom_point(subset(pel, FG=="lanternfish 1"),  mapping=aes(x=d13C, y=d15N, col=FG, shape=FG))+
  geom_point(subset(pel, FG=="krill"),  mapping=aes(x=d13C, y=d15N, col=FG, shape=FG))+
  geom_point(subset(pel, FG=="amphipod"),  mapping=aes(x=d13C, y=d15N, col=FG, shape=FG))+
  theme_bw()+ylab(expression(paste(delta^15,N)))+xlab(expression(paste(delta^13,C)))



# Calcularemos la posicion trofica media y su rango usando un FDT de 2.9 y el krill como PT=2 bajo un enfoque frecuentista!!! 
# Utilizaremos la ecuacion propuesta por Cabanna and Rasmunsen (1996) aplicada posteriormente por Post in 2002
#-----------------------------------------------------------------------------------------------------------------------------
#NT = NTbaseline + (d15N consumer - d15N baseline)/DELTA15N
#############################################
# Pez de hielo (icefish)
# Estimamos PT y su rango
NTpt<-2 +(( subset(pel$d15N,pel$FG=="icefish") - 
              mean(subset(pel$d15N,pel$FG=="krill"))) / 2.9)
# Observar los resultados
NTpt
NTpt<-na.omit(NTpt)
# Media
mt_pt<-mean(NTpt)
mt_pt
# Rnago
rt_pt1<-range(NTpt)
rt_pt1
# Pez linterna (lanternfish 1)
NTpr<-2 +(( subset(pel$d15N,pel$FG=="lanternfish 1") - 
              mean(subset(pel$d15N,pel$FG=="krill"))) / 2.9)
# Media
mp1<-mean(NTpr)
mp1
# Rango
rp1<-range(NTpr)
rp1
## Ahora crearemos un objeto que contenga la media, el minimo, el maximo y el rango de PTs
NT_a<-data.frame(c(mt_pt,rt_pt1),c(mp1,rp1))
colnames(NT_a)<-c("icefish","lanternfish 1")
rownames(NT_a)<-c("mean","min","max")
NT_a




#### Ahora calcularemos las PTs utilizando tRophicPosition (Enfoque Bayesiano) #### 
### Primero seleccionamos los  valores de FDT que vamos a utilizar
TDF_values <- TDF(author = "McCutchan", element = "both", type = "muscle")
# Tambien podemos usar los propuestos por Post et al 2002
#TDF_values <- TDF(author = "Post", element = "both", type = "muscle")

# Primero lo haremos utilizando  una linea base (One baseline)
#Creamos un objeto del tipo de tRophicPosition con los individuos del pez de hielo y el krill como linea base
consumer <- loadIsotopeData(pel, consumer = "icefish", consumerColumn = "FG", b1 = "krill", baselineColumn = "FG")
consumer

# Para estimar la posicion trofica necesitamos un factor de discrminacion trofica (FDT), la funcion loadIsotopeData() usa el de post 2002,N (3.4 ? 0.98 sd)  and C (0.39 ? 1.3 sd) by default, but you can change that
# Vamos a graficar los datos
x11()
plot(consumer, b1 = "Pelagic baseline")
# Aqui incluimos las etiquetas para una linea base, uno puede cambiar la leyenda para el consumidor (consumer = "new_label"), o la posicion de la leyenda (legend = c(1.15, 1.15))

# El paquete tRophicPosition permite ajustar tres tipos de modelos:
#1) One baseline (jagsOneBaseline()) (una linea base)
#2) Two baselines, No FDT para el carbono (jagsTwoBaselines) (Dos lineas bases)
#3) Two baselines full, incluye FDT para el carbono (jagsTwoBaselinesFull())(dos lineas bases completo)
# El modelo puede definirse con cualqueir de las funciones de arriba o con la nueva funcion jagsBayesianModel(), de la version 0.6.8 del tRophicPosition.
# El usuario tiene o puede cambiar los prior de cualquiera de los parametros si se tiene suficiente informacion a prior o las constantes (lamda=PT de la linea base)

model.string <- jagsOneBaseline(model = "oneBaseline") # Aqui estableceriamos la distribucion de priors de cada parametro (FDT, TP, lambda, d15N, d13C), en este caso, dejamos los default. 

# El siguiente paso es iniciar el modelo usando la funcion TPmodel(). Deinifmos dos argumentos: los datos y el model  string, el primero son los datos de isotopos
# el segundo es el modelo Bayesiano previamente definido. Los otros argumentos son opcionales. Esta fase es necesaria para que los muestreadores adapten las cadenas para maximizar su eficiencia.

model <- TPmodel(data = consumer, model.string = model.string, n.adapt = 20000, n.chains = 2)

# Una vez que el modelo se ha iniciado, las iteraciones MCMC comienzan las cuales son ejectutadas con la funcion "posteriorTP"

posterior.samples <- posteriorTP(model = model, n.iter = 20000, variable.names = c("TP","muDeltaN"))

# Estableceremos las cadenas markovianas a 20,000 iteraciones y monitorizaremos "TP"  "muDeltaN" (por default). TP es la posicion trofica y muDeltaN es la media del FDT del d15N
# Ahora hemos estimado la TP mediante inferencia Bayesiana!! La funcion "posteriorTP()" nos proporciona un objeto de la clase "mcmc.list", asi que podemos usar funciones genericas para obtener resumenes.
# Comparamos con el uso frecuentista
summary(posterior.samples)
NT_a

# Combinamos las cademas para determinar convergencia
posterior.combined <- coda::mcmc(do.call(rbind, posterior.samples))

# Obtenemos la moda
mtBay<-as.numeric(getPosteriorMode(posterior.combined)[1])

# Comprobamos graficamente (para revisar convergencia!!)
# install.packages("MCMCvis")
# MCMCvis grafica rastreo y densidad de las muestras a posterior
x11();MCMCvis::MCMCtrace(posterior.samples, pdf = FALSE)
# El valor del muDeltaN15 corresponde al FDT 
# Graficamos con SIBER
x11();plotTP(posterior.combined)

#### 4. Dos baselines ####
# Creamos un objeto tRophicPosition con el pez de hielo lanternfish y dos baselinees
consumer_tb <- loadIsotopeData(pel, consumer = "icefish", consumerColumn = "FG", b1 = "krill", b2="amphipod", baselineColumn = "FG")
consumer_tb

# Graficamos los datos
x11()
plot(consumer_tb, b1 = "Pelagic baseline", b2="Demersal baseline")

# Definimos el modelo de dos baseline con el FDT del carbono y priors para los diferentes parametros.
model.string_tb <- jagsTwoBaselinesFull(model = "twoBaselinesFull") #  TP="dnorm(3, 0.1)", muDeltaN = "dnorm(3, 2)" TP = "dnorm(5, 1)" u otra familia

# Iniciamos el modelo
model_tb <- TPmodel(data = consumer_tb, model.string = model.string_tb, n.adapt = 20000, n.chains = 2)

# Comenzamos las iteraciones MCMC 
posterior.samples_tb <- posteriorTP(model = model_tb, n.iter = 20000, variable.names = c("TP","muDeltaN", "alpha"))

# Comparamos resultados con una y dos baselines
summary(posterior.samples_tb)
summary(posterior.samples)

# Combinamos las cadenas
posterior.combined_tb <- coda::mcmc(do.call(rbind, posterior.samples_tb))

# Obtenemos las modas
mtBay_tb<-as.numeric(getPosteriorMode(posterior.combined_tb)[1])

# Comprobamos que haya convergencia!
x11();MCMCvis::MCMCtrace(posterior.samples_tb, pdf = FALSE, params = "all")









###----------------------------------------------------------------------------------------------------------------------------------------
###########------- 4.0 Estimacion de dieta (contribucion al musculo) --------------------#################
###----------------------------------------------------------------------------------------------------------------------------------------
# Para correr este ejemplo, favor de modificar el directorio de trabajo.
# Los modelos de mezcla aplicados utilizando dastos de isotopos estables nos permiten cuantificar la contribucion de diferentes fuentes (presas) a una mezcla (consumidor) mediante el uso de
# uno o dos isotopos (tracers). La regla general establece que sean 1 tracer y 2 fuentes o 2 tracers y 3 fuentes. Se pueden utilizar mas fuentes (y tracers) pero los resultados generalmente son 
# poco realistas e incongurentes. En este ejemplo seguiremos utilizando los datos del pez de hielo y cuantificaremos que especie de presa contribuye mas a su tejido muscular.
library(MixSIAR)
setwd("G:/Mi unidad/Curso Isotopos/Haakaton/Modelos de mezcla")
getwd()     # Verifamos wd

#-------------------------------------------------------------------
###### 4.1 Leemos los datos #####
#-------------------------------------------------------------------
# El paquete MixSIAR requiere que los datos tengan una determinada estructura para poder leerlos y llevar a cabo los modelos de mezcla
# Primero cargaremos los datos del consumidor.
# Consumidores; nombre del fichero
mix.filename <- "Icefish.csv"
# Load mixture data
mix <- load_mix_data(filename=mix.filename,        # Nombre del archivo
                     iso_names=c("d13C","d15N"),   # Nombres de las columnas con los datos de SIA
                     factors=c("IDLANCE","SEXO"),  # En el caso de MixSIAR, podemos incluir efectos fijos como factores para probar diferentes modelos
                     fac_random=c(TRUE,FALSE),     # Podemos incluir variables aleatorias
                     fac_nested=c(FALSE,FALSE),    # Efectos anidados
                     cont_effects=NULL)            # Efectos fijos continuos

# Datos de la presas
# Nombre del ficher
source.filename <- "Sources icefish.csv"
# # Cargamos los datos fuente
source<- load_source_data(filename=source.filename, # Nombre del ficher
                          source_factors=NULL,      # Factores
                          conc_dep=FALSE,           # Dependencia de concentracion
                          data_type="means",        # Tipo de datos
                          mix)


# Factor de discrminacion trofica
discr.filename <- "TDF icefish.csv"
# Cargamos datos de FDT
discr.df<-load_discr_data(filename=discr.filename, mix)


# Hacemos biplot corregido por FDT
# Con esto podemos ver si los datos se han cargado  bien
# Esta mi mezcla dentro de mi poligono isotopico?
# Algunas de las fuentes se confunden o se tapan unas a otras?

# 'filename' - nombre con el que queremos que MixSIAR salve el plot del  espacio isotopico 
#              (Se añadira automaticamente)
# 'plot_save_pdf' - TRUE o FALSE, deberia MixSIAR salvar la grafica como .pdf?
# 'plot_save_png' - TRUE o FALSE, deberia MixSIAR salvar la grafica como .png?

plot_data(filename="isospace_plotn",
          plot_save_pdf=FALSE,
          plot_save_png=FALSE,
          mix,source,discr.df)

# Podemos calcular el area de las fuentes
calc_area(source, mix, discr.df)

### Estimamos priors informativos basados en Stock et al 2018
# Priors
# Priors no informativos
plot_prior(alpha.prior=1,source)
# Priors de analisis de contenido estomacal
plot_prior(alpha.prior=c(5,10, 80,5) , source)
# Prior estimados siguiendo a Stock et al 2018
plot_prior(alpha.prior=c(0.2, 0.4, 3.2, 0.2), source)

# Este paquete nos permite incorporar diferentes estructura de error
# 1) Si no se establece estructura de error se assume que las variaciones isotopicas en el consumidor pueden ser 
# explicadas totalmente por variacion en las proporciones de las fuentes;
# 2) La estructura de solo error de proceso considera las variaciones isotopicas de las fuentes; 
# 3) La estructura de error residual considera las variaciones isotopicas en el consumidor y;
# 3) La estructura conjunta de error residual y error de proceso consiudera tanto las variaciones en las fuentes como en los consumidores

#Escribimos el model 
# Nombre del modelo
model_filename <- "MixSIAR_model.txt"
# Incluimos error residual: apropiada para situaciones, por ejemplo, en el que cada punto de la mezcla fue generado a traves de la combinacion de muchas muestras de la poblacion
resid_err <- TRUE
# Inlcuimos error de proces; derivado de la suposicion sobre el proceso de mezcla. 
# Los resultados de laboratorio de analisis proporcionan solo un valor de mezcla para cada uno de los j tracers considerados
process_err <- TRUE
# Salvamos
write_JAGS_model(model_filename, resid_err, process_err, mix, source)

# Corremos el modelo
# El output del JAGS sera guardado como 'jags.1'

# Opciones de MCMC:
# run <- "test"       # chainLength=1000, burn=500, thin=1, chains=3, calcDIC=TRUE
# run <- "very short" # chainLength=10000, burn=5000, thin=5, chains=3, calcDIC=TRUE
# run <- "short"      # chainLength=50000, burn=25000, thin=25, chains=3, calcDIC=TRUE
# run <- "normal"     # chainLength=100000, burn=50000, thin=50, chains=3, calcDIC=TRUE
# run <- "long"       # chainLength=300000, burn=200000, thin=100, chains=3, calcDIC=TRUE
# run <- "very long"  # chainLength=1000000, burn=500000, thin=500, chains=3, calcDIC=TRUE
# run <- "extreme"    # chainLength=3000000, burn=1500000, thin=500, chains=3, calcDIC=TRUE

# Tambien podemos establecer nuestras propios parametros de MCMC 
# run <- list(chainLength=200000, burn=150000, thin=50, chains=3, calcDIC=TRUE)


# Corremos el modelo sin priors
# Utilizamos priors no informativos 
jags.ice<- run_model(run="test",      # Numero de cadenas y de iteraciones
                     mix,             # Mezcla
                     source,          # Fuentes
                     discr.df,        # Valores de FDT
                     model_filename,  # Nombre del archivo
                     alpha.prior = 1) # Aqui ponemos el tipo de prior, puede utilizar tambein esta notacion c(0.01, 0.01, 0.01, 0.93, 0.03, 0.01)) 
# Extraemos datos de proporciones estimadas o a posteriori
Ice_no_priors<-data.frame(jags.ice[["BUGSoutput"]][["sims.list"]][["p.global"]]) # p. global es la contribucion global de cada especie
# Extraemos nombres de columna
colnames(Ice_no_priors)<- source[["source_names"]] 
# Extraemos el WAIC si vamos a comparar entre modelos
WAIC_ice<-loo::waic(jags.ice$BUGSoutput$sims.list$loglik)

# Estas opciones son para establecer lo que se va a observar y guardar como output
output_options_ice <- list(summary_save = TRUE,                  # Guardamos resumen
                           summary_name = "summary_ice",         # Nombre del resumen
                           sup_post = TRUE,                      # Suprime el grafico de densidad
                           plot_post_save_pdf = TRUE,            # TRUE crea y salva graficos de la distribution a posteriori
                           plot_post_name = "posterior_density", # Nombre del grafico de distribucion a posterior
                           sup_pairs = TRUE,                     # TRUE suprime graficos por pares
                           plot_pairs_save_pdf = TRUE,           # TRUE salva graficos por pares
                           plot_pairs_name = "pairs_plot",       # Nombre graficos por pares
                           sup_xy = TRUE,                        # Suprime grafico de rastreo
                           plot_xy_save_pdf = TRUE,              # Salva grafico de rastreo
                           plot_xy_name = "xy_plot",             # Nombre grafico de rastreo
                           gelman = TRUE,                        # Calcula diagnostico Gelman-Rubin
                           heidel = TRUE,                        # Calcula diagnostico Heidel
                           geweke = TRUE,                        # Calcula diagnostico Geweke
                           diag_save = TRUE,                     # Guarda diagnostico
                           diag_name = "diagnostics",            # Nombre archivo diagnostico
                           indiv_effect=FALSE,
                           plot_post_save_png = TRUE,            # Guarda plots a posteriori como png
                           plot_pairs_save_png = TRUE,           # Guarda plots por  pares como png
                           plot_xy_save_png = TRUE,              # Guarda plots por  rastreo como png
                           diag_save_ggmcmc = TRUE)              # Guarda diagnostico ggMCMC
# 
# # # Creamos diagnostivos, resumen estadisticos y graficos a posteriori
output_JAGS(jags.ice, mix, source, output_options_ice)




# Nicho isotopico
# library(ggplot2); library(SIBER)
# # Isotopic niche, nicheRover and RINI
# # Bayesian elipses developed by Jackson et al 2011 to compare isotopic niche between populations within or between species 
# # In the present example we will use data from different fish species that inhabit one community.
# # We are interested in their isotopic niche and overlap 
# 
# # More information in https://github.com/AndrewLJackson/SIBER
# #Remuevo cualquier objeto que pueda haber do de otros scripts
# rm(list = ls())
# graphics.off()
# # Working directory
# # Rememeber! "/" y NO "\"
# setwd("G:/Mi unidad/Curso Isotopos/SIBER")
# consumers <- read.table("siberdata.csv",sep=",",header=T)
# # conusmers <-read.table("consumers_SIBER.csv",sep=",",header=T)
# # Glimpse of the first rows
# head (consumers)
# str(consumers)
# summary(consumers)
# 
# # load in the included demonstration dataset
# # The data base has 4 columns, the two isotopes, a column for group and another for the community. 
# # All levels have a 1 because its 23 species within a same community 
# 
# 
# # Hago un plot para ver que forma tiene el espacio isot?pico
# x11()
# par(mar= c(5, 5, 4, 2)+0.1)
# plot(consumers$iso1,consumers$iso2, col=consumers$group, pch = 15, xlab=expression(paste(delta^13,C)), ylab=expression(paste(delta^15,N)))
# 
# #
# # Ggplot
# consumers$group=as.factor(consumers$group)
# consumers$Species=as.factor(consumers$Species)
# ggplot(data=consumers, aes(x=iso1, y=iso2, col=Species, shape=Species))+geom_point()+
#   stat_ellipse(level = 0.40)+
#   theme_bw()+
#   xlab(expression(delta^"13"~C))+ylab(expression(delta^"15"~N))
# 
# table(consumers$Species)
# # Set seed
# set.seed(1)
# #Load SIBER, if you havent downloaded the packages, run 
# #install.packages ("SIBER")
# library(SIBER)
# 
# # create siber object
# consumers<-consumers[,c(2,1,3,4)]
# consumers$community<-1
# colnames(consumers)<-c("iso1", "iso2", "group", "community")
# siber.example <- createSiberObject(consumers)
# #Look at the object
# class(siber.example)
# 
# siber.example
# 
# # Several functions to visualize the data and perform some data calculations can be applied now we have the siber object 
# # First we create lists with the arguments to produce the figures that we are going to use with the function "plotSiberObject"
# 
# 
# community.hulls.args <- list(col = 1, lty = 1, lwd = 1) # col: column indexes; lty: line type; lwd=line width
# group.ellipses.args  <- list(n = 100, p.interval = .68, lty = 1, lwd = 2) 
# group.hull.args      <- list(lty = 2, col = "grey20")
# 
# 
# x11()
# par(mfrow=c(1,1))
# plotSiberObject(siber.example,
#                 ax.pad = 2, 
#                 hulls = T, community.hulls.args,  # draw hulls based on mean values
#                 ellipses = T, group.ellipses.args, # draw ellipse
#                 group.hulls = T, group.hull.args, # draw hulls around each group
#                 bty = "L",
#                 iso.order = c(1,2), xlab=expression(delta^"13"~C), ylab=expression(delta^"15"~N)
# )
# legend(x="topright", legend = c("Diplodus spp.", "Pagellus spp."), fill = c("red", "black"), 
#        col = c("red", "black"), cex=0.8)
# #The following are some of the parameters of the function:
# #   p.interval = proportion of points within the ellipse (for the standard ellipse is 0.4)
# #   ax.pad is used to determine the free space around the data
# #   iso.order I can establish the order in which isotopes are plotted
# #   hulls = with this we can plot Convex hulls between the the center of each group
# #   Ellipses = T plots ellipses for each group
# #   n= number of points used to plot the ellipse. It is used to smooth lines
# #group.hulls = T to plot the convex hull for each group
# 
# # Question: What is the convex hull shape? any thoughts on why it has that shape? 
# # Lets see what happens if I increase or decrease the proportion point within each ellipse? Change the p.interval and observe.
# 
# # Calculation of some basic statistics
# # Later on we will use bayesian methods to compare the statistical comparisons we have performed 
# 
# 
# # Lets calculate some basic statistics of each ellipse (Remember Jackson 2011): TA, SEA and SEAc. 
# # We have to keep in mind that the standard ellipse has around 40% of the data
# 
# group.ML <- groupMetricsML(siber.example)  
# print(group.ML)
# 
# # Remember we are not comparing between two communities because we have three species of the same community. 
# # However, the script can be adapted to perform a comparison between communities 
# 
# # Question: What is the difference between  SEA and la SEAc? and between ellipses and convex hull?
# 
# # #Here we estimate LAYMAN metrics (2007) in the community. This is done using loops over each community, determinig the centroid of each one and from this on, Layman six metrics. As in the example, we work with one community and therefore we only get one measure per variable.
# 
# community.ML <- communityMetricsML(siber.example) # Calculate the point estimates of the Layman metrics for each community
# print(community.ML)
# 
# # These are Layman (2007) metrics: Can stable isotope ratios provide for community-wide measures of trophic structure? Ecology, 88, 42-48.
# 
# # The measures are):
# 
# # 1) NR (dY_range en el output): range of N between more enriched species and less enriched 
# # 2) CR(dX_range of the output): range of C. idem (1).
# # 3) TA: Total area. Total extent of trophic diversity
# # 4) CD: euclidean distance to the centroid. Gives us a clue of the mean degree of trophic diversity. Average degree of trophic diversity
# # 5) MNND: Mean euclidean distance to nearest neighbor of each species. 
# # 6) SDNND: stdandard deviation of NND. A measure of the grouping uniformity, less affected by N than NND.
# 
# #----------------------------------------------
# # Until now, all the measures we have explores are frequentist measures, LETS FIT BAYESIAN MODELS
# 
# # The first thing we are going to do is fit normal bayesian ,ultivariate distributions to each group within the data frame. We will do that using the software JAGS
# # and the r package rjags (JAGS-4.2.0, you must install it in the data workshop folder, if you cannot download it, try herei https://sourceforge.net/projects/mcmc-jags/files/JAGS/4.x/Windows/). 
# # For the people whose people works at 32 bit, they have to install  JAGS-4.2.0- Rtools33. 
# 
# # Here we define two listis: "parms" defines the sampling algorithm parameters and "priors" that pose information about the dustributions of the of the parameters that want to be estimated 
# 
# # OPtions to run JAGS
# parms <- list()
# parms$n.iter <- 2 * 10^4 # Number of iterwations
# parms$n.burnin <- 1 * 10^3# NUmber of discarded iterations fromthe first simulations
# parms$n.thin <- 10 # NUmber of iterations that have to pass to get a subsample
# parms$n.chains <- 2# NUmber of chains
# 
# # Define the priors
# priors <- list()
# priors$R <- 1 * diag(2)
# priors$k <- 2
# priors$tau.mu <- 1.0E-3
# 
# # Fitting the elipses using JAGS; Loops over each group
# ellipses.posterior <- siberMVN(siber.example, parms, priors) #Fit Bayesian bivariate normal distributions to each group in each community
# 
# # Compare between groups using the standard ellipse surface (SEA)
# # SEA is recommended to compare within a community and between communities given that each 
# # group multivariate distributions are already fit. Now we just need to estimate the covariance matrix of the a posterioi distributions
# 
# # Samples from the Posterior distribution can be used to calculate  SEA.B for each group 
# SEA.B <- siberEllipses(ellipses.posterior) # Standard deviation of the elipse
# 
# # Now we can do a boxplot to compare the surface of each elipse
# x11();
# siberDensityPlot(SEA.B, xticklabels = c("", ""), 
#                  xlab = c("Group"),
#                  ylab =  expression("Standard density area " ('\u2030' ^2) ),
#                  bty = "L",
#                  las = 1,
#                  main = "SIBER elipses for each group"
# )#(esta funcion es la misma que siardensityplot()del SIAR)
# 
# # Adding red crossess to the mean values for SEA-c in the plot
# points(1:ncol(SEA.B), group.ML[3,], col="red", pch = "x", lwd = 2)
# axis(1, at=c(1,2), labels= c("Pagellus spp.", "Diplodus spp."))
# # Credible intervals estimation using the functuon hdr from hdrcde poackage.
# 
# cr.p <- c(0.95, 0.99) # we create the quntile vector
# 
# # Call lapply()
# SEA.B.credibles <- lapply(as.data.frame(SEA.B),function(x,...){tmp<-hdrcde::hdr(x)$hdr},prob = cr.p) # gives us 99-95-50%  credible intervals for SEA for the three groups.
# 
# SEA.B.credibles
# # Comparing with frequentist means
# print(group.ML)
# 
# # Obtain mathematical modes
# SEA.B.modes <- lapply(as.data.frame(SEA.B),function(x,...){tmp<-hdrcde::hdr(x)$mode},
#                       prob = cr.p, all.modes=T)
# print(SEA.B.modes)
# 
# #Comparing ellipse areas from the a posteriori distribution
# # For example, to assess if the area of sp1 ellipse is smaller than sp2 we need to calculate
# # the proportion of sp1 that are smaller than  sp2. Its considered a direct proxy of the probability that the aposteriori 
# # distribution of group 1 is lower than the other group. For example, the probability that SEA.B of group 1 was lower than group 2
# 
# Pg1.lt.g2 <- sum(SEA.B[,1] < SEA.B[,2] ) / nrow(SEA.B)
# print(Pg1.lt.g2)
# 
# # In this example, the probability of observing a smaller niche for group 1 is less than 0.96,
# # Lets take a look at the boxplot
# 
# 
# # Finally we can compare the overlap between ellipses. 
# # This is simply the surface measured in parts per mille squared of the overlapping regions.
# # We calculate the overlap based on their a posteriori disributions
# ellipse1 <- "1.1" 
# ellipse2 <- "1.2"
# 
# # Adjusted standard ellipse overlap can be computed by maximum likelihoods:
# 
# sea.overlap <- maxLikOverlap(ellipse1, ellipse2, siber.example,  p.interval = 0.99, n = 100)
# 
# # The overlap at 95% credibility interval prediction would be:
# ellipse95.overlap <- maxLikOverlap(ellipse1, ellipse2, siber.example,  p.interval = 0.95, n = 100)
# 
# # Then the proportion of overlapping area to non overlapping areas would be:
# 
# prop.95.over <- ellipse95.overlap[3] / (ellipse95.overlap[2] +  ellipse95.overlap[1] - ellipse95.overlap[3]) # Overlap between species
# 
# # The function bayesianOverlap gives us several values for this three parameter, each one is the output of the a posteriori estimates. We can look at the shape of the overlap distribution. 
# # In this case we only estimates 100 overlaps because it can be time consuming. Ideally, we should perform 10000s of estimates.
# 
# bayes95.overlap <- bayesianOverlap(ellipse1, ellipse2, ellipses.posterior,draws = 100, p.interval = 0.95, n = 100)
# 
# # Lets check out the overlap histogram
# 
# hist(bayes95.overlap[,3], 10) 
# 
# # Just like before, we can express the non overlapping area to the total area 
# 
# bayes.prop.95.over <- (bayes95.overlap[,3] / (bayes95.overlap[,2] + bayes95.overlap[,1] -bayes95.overlap[,3]))
# 
# # What distribution does it havee
# x11();hist(bayes.prop.95.over, 10)
# 
# #----------------------------------------------------------------
# # Comparisons using Layman metrics
# # Communities can be compared as a function of uncertainty around the centroid. 
# # To do it, we need to extract the mean values of aposteriori values
# 
# mu.post <- extractPosteriorMeans(siber.example, ellipses.posterior)
# 
# # and calculae Layman metrics distributions
# layman.B <- bayesianLayman(mu.post)
# 
# # Lets do a boxplot with the Layman metrics of the studied copmmunities (just one in this case)
# x11()
# siberDensityPlot(layman.B[[1]], xticklabels = colnames(layman.B[[1]]), bty="L", ylim = c(0,20))
