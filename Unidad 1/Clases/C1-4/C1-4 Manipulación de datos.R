####################################
###       Curso R - UCE          ###
###          Clase 04            ###
####################################



# Manipulación de datos ---------------------------------------------------

# Prerrequisitos

packages <- c('tidyverse','readxl','car')
# install.packages(packages)

library(easypackages) #easypackages me permite cargar varios paquetes a la vez
libraries(packages)

bdd_1 <- read_excel("Datasets/data_sociodemografica.xlsx")
glimpse(bdd_1)
summary(bdd_1)

bdd_1$egresos <- as.numeric(bdd_1$egresos)
bdd_1$origen.fondos <- NULL


# 1. Recodificación de variales -------------------------------------------


bdd_1$estado.civil <- ifelse(bdd_1$estado.civil == '-','SINF',bdd_1$estado.civil)
bdd_1$cargas <- ifelse(bdd_1$numero.cargas>0,"Si","No")

## 1.1. Función recode

bdd_1$sexo <- recode(bdd_1$genero,"'MASCULINO' = 1; 'FEMENINO' = 2; '-' = NA")
bdd_1$sexo <- as.integer(bdd_1$sexo)

## 1.2. Discretización
# Discretice la variable edad en los rangos "menor a 18",
# "De 18 a 40", "De 40 a 65", "mayor a 65".

summary(bdd_1$edad)
bdd_1$grupos.edad <- cut(bdd_1$edad,breaks = c(0,18,40,65,112),
                         labels = c('menor a 18','De 18 a 40',
                                    'De 40 a 65','mayor a 65'))


# 2. Paquete tidyverse (dplyr) --------------------------------------------


bdd_1 <- tibble::as_tibble(bdd_1) 
bdd_1

## 2.1. Los verbos de dplyr

### 2.1.1. Función select

data("storms")
storms %>% select(day,hour) # solo las filas seleccionadas
storms %>% select(-year, -wind) # todas excepto la indicada
storms %>% select(name:hour)
storms %>% select(-(name:hour))
storms %>% select(starts_with("l"))

### 2.1.2. Función filter

storms %>% filter(wind >= 50)
storms %>% filter(wind >= 50, name %in% c("Alberto", "Alex", "Allison"))
storms %>% filter(wind>=50 & pressure<1010)

### 2.1.3. Función arrange

storms %>% arrange(wind)
storms %>% arrange(desc(wind)) # de forma descendente
storms %>% arrange(wind, year) # más de una variable

### 2.1.3. Función rename

names(storms)
storms %>% rename(estado = status, viento = wind, presion = pressure, año = year)

### 2.1.3. Función mutate

storms %>% mutate(ratio = pressure/wind)
storms %>% mutate(ratio=pressure/wind, inverse=ratio^-1)
storms %>% mutate(freq.acumulative = cumsum(wind)) 

### 2.1.3. Función summarise

data("Salaries")

Salaries %>% summarise(mediana = median(salary), varianza = var(salary))

### 2.1.3. Función group_by

Salaries %>% group_by(sex)

Salaries %>%  group_by(sex) %>% 
              summarise(media = mean(salary), sum = sum(salary), n = n())


# FUENTES ADICIONALES -----------------------------------------------------

browseURL(url= "https://dplyr.tidyverse.org/",browser = getOption("browser"))
