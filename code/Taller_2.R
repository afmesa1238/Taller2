#Taller de R: Estadística y Programación.
#nombre: Diana Cano, código.
#Versión de R:4.2.1
#Versión de RStudio:RStudio 2022.12.0+353 "Elsbeth Geranium" Release (7d165dcfc1b6d300eb247738db2c7076234f6ef0, 2022-12-03) for Windows
#Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) RStudio/2022.12.0+353 Chrome/102.0.5005.167 Electron/19.1.3 Safari/537.36


# Pasos Iniciales ---------------------------------------------------------

#Se define la ruta donde se encuentran nuestras bases de datos.

setwd('c:/Users/andre/Desktop/Taller_2/')

#Se cargan las librerias necesarias para procesar las bases de datos.
#Si alguno de los paquetes a usar no está instalado usar install.packages("Nombre del paquete")

library(pacman)
library(rio)
library(data.table)
library(tidyverse)


# Problem-set -------------------------------------------------------------


# 2.1 Importar

#Con la función read.csv() se importan los datos teniendo en cuenta que tienen encabezados y están separador por punto y coma (;)
#Hay que incluir la codificación UTF-8 para que las palabras con tilde se manejen adecuadamente.

identification <- read.csv('input/Modulo de identificacion.csv', header = T, sep = ';', encoding = "UTF-8")

location <- read.csv('input/Modulo de sitio o ubicacion.csv', header = T, sep = ';', encoding = "UTF-8")


# 2.2 Exportar

# Se usa la función de saveRDS que recibe el nombre del objeto a exportar,
# el nombre de la carpeta donde se guardará el objeto exportar y el nombre de
# este último, con la extensión.rds

saveRDS(object = identification, file = file.path("output", "identification.rds"))

saveRDS(object = location, file = file.path("output", "location.rds"))


# 3. Generar variables

# Se crea y agrega a la base de datos "identification" la variable "bussines_type", 
# de acuerdo con la columna (variable) GRUPOS4, que tiene la rama de actividad agrupada en los 4 grupos de interés.

identification <- identification %>% 
  mutate(bussiness_type = case_when(
    GRUPOS4 == 1 ~ "Agricultura",
    GRUPOS4 == 2 ~ "Industria Manufacturera",
    GRUPOS4 == 3 ~ "Comercio",
    GRUPOS4 == 4 ~ "Servicios",
  ))

# Se crea y agrega a la base de datos "location" la variable "local", 
# de acuerdo con las condiciones dadas.

location <- location %>%
  mutate(local = case_when(
    P3053 == 6 ~ 1,
    P3053 == 7 ~ 1
  ))


# 4. Eliminar filas/columnas de un conjunto de datos

# 4.1 Creación del objeto "identification_sub" de acuerdo con las condiciones dadas.

identification_sub <- identification %>%
  filter(bussiness_type == "Industria Manufacturera")

# 4.2 Creación del objeto "location_sub" de acuerdo con la selección de variables de interés,
# del objeto "location".

location_sub <- location %>% 
  select(DIRECTORIO, SECUENCIA_P, SECUENCIA_ENCUESTA, P3054, P469, COD_DEPTO, F_EXP)

# 4.3 Creación del objeto "identification_sub" de acuerdo  on la selección de variables de interés,
# del objeto "identification_sub".

identification_sub <- identification_sub %>% 
  select(DIRECTORIO, SECUENCIA_P, SECUENCIA_ENCUESTA, P35, P241, P3032_1, P3032_2, P3032_3, P3033, P3034)


# 5. Combinar bases de datos.

# Se verifica primero que "locabtion_sub" y "identification_sub" sean objetos de tipo dataframe

str(location_sub) 
str(identification_sub)

# Se unen ambos dataframe por medio de la función merge,
# en función de las columnas (variables) DIRECTORIO, SECUENCIA_P Y SECUENCIA_ENCUESTAS.

# A continuación, seleccionar la opción que corresponda según el interés que se tenga sobre las dos bases de datos.

# inner_join(): Genera nueva base de datos (dataframe) que resulta de unir 
# sólo las filas que tienen coincidencias en ambas bases de datos originales.

base_datos_final <- inner_join(location_sub, identification_sub, by = c("DIRECTORIO","SECUENCIA_P", "SECUENCIA_ENCUESTA")) 
str(base_datos_final)

# full_join (): Genera nueva base de datos (dataframe) que resulta de unir 
# TODAS las filas de ambas bases de datos originales, rellenando los valores faltantes con NA,
# en caso de no haber coincidencias

base_datos_final_1 <- full_join(location_sub, identification_sub, by = c("DIRECTORIO","SECUENCIA_P", "SECUENCIA_ENCUESTA")) 
str(base_datos_final1)

# left_join(): Genera nueva base de datos (dataframe) que resulta de unir 
# TODAS las filas del primer dataframe con los valores del segundo dataframe.

base_datos_final_2 <- left_join(location_sub, identification_sub, by = c("DIRECTORIO","SECUENCIA_P", "SECUENCIA_ENCUESTA")) 
str(base_datos_final_2)

# rigth_join():

base_datos_final_3 <- right_join(location_sub, identification_sub, by = c("DIRECTORIO","SECUENCIA_P", "SECUENCIA_ENCUESTA")) 
str(base_datos_final_3)
