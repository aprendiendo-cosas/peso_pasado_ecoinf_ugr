### Caracterización del efecto de la densidad y el uso del suelo del pasado en la regeneración de *Quercus ilex* bajo pinar en Sierra Nevada

## PARTE I: Reproducir modelo estadístico

# Descargar datos
# - Acceso al artículo: https://esajournals.onlinelibrary.wiley.com/doi/abs/10.1890/12-0459.1
# - Material suplementario del artículo: http://www.esapubs.org/archive/appl/A023/065/
# - Descargar archivo "data.txt" 
# - Guardarlo en una subcarpeta "datos" donde tengamos el código

# Cargar paquetes y configurar carpetas
# install.packages("dplyr")
library(dplyr)
# install.packages("pscl")
library(pscl)
# install.packages("raster")
library(raster)

# ¿Dónde estamos trabajando?
getwd()

# Leer datos y renombrar variables
datos <- read.table("datos/data.txt", sep = "\t", header = TRUE)
names(datos) <- c("ID_parcela_articulo", "UTM_X", "UTM_Y", "Reclutamiento_5mplot", "Uso_suelo", "Distancia_media_m", "Densidad_pies_ha")

# Codificar la variable *Uso_suelo*
datos <- datos %>%
  mutate(Cod_Uso = ifelse(Uso_suelo == "Crops", 5,
                          ifelse(Uso_suelo == "Pasture", 3,
                                 ifelse(Uso_suelo == "Mid-mountain shrubland", 2, 1))))

datos$Cod_Uso <- as.factor(datos$Cod_Uso) # ¡El código de uso es un factor, no un número!
View(datos)

# Generar el modelo estadístico y explorarlo
help(zeroinfl)

modelo_completo <- zeroinfl(Reclutamiento_5mplot ~ Densidad_pies_ha + Cod_Uso + Distancia_media_m, 
                            data = datos, dist = "poisson", link = "logit")
modelo_densidad <- zeroinfl(Reclutamiento_5mplot ~ Densidad_pies_ha, 
                            data = datos, dist = "poisson", link = "logit")
modelo_reducido <- zeroinfl(Reclutamiento_5mplot ~ Densidad_pies_ha + Cod_Uso, 
                            data = datos, dist = "poisson", link = "logit")

# Exploramos los modelos
modelo_reducido
summary(modelo_reducido)

## PARTE II: Generar predicciones

# Cargar mapa de densidad sobre el que queremos generar predicciones: valores de densidad generado en sesiones anteriores
mapa_densidad_ha <- raster("datos/density_kriging.asc")

# Explorar mapa
mapa_densidad_ha
plot(mapa_densidad_ha)

# ¿Cómo se midió la densidad en las parcelas del muestreo? ¿Tenemos que hacer alguna transformación?
names(mapa_densidad_ha) <- c("Densidad_pies_ha")

# Cargar mapa de uso del suelo sobre el que queremos generar predicciones
uso <- raster("datos/uso_pasado_pinos.tif")

# Explorar mapa
uso
names(uso) <- c("Cod_uso")
uso

# Crear brick con ambas variables: densidad y uso
mi_brick <- brick(mapa_densidad_ha, uso)
mi_brick

# Generar predicciones
help(predict) # ¿Qué hace esta función?
predicciones <- predict(mi_brick, modelo_reducido)
predicciones <- predict(mapa_densidad_ha, modelo_densidad)
predicciones

# Tenemos que generar una tabla con densidad y uso para cada celda, predecir y entoncer transformar a raster de nuevo

# Generar una tabla con densidad y uso para cada celda
mi_tabla <- data.frame(Densidad_pies_ha = values(mapa_densidad_ha$Densidad_pies_ha),
                       Cod_Uso = as.factor(values(uso$Cod_uso))) 
View(mi_tabla)

# Predecir
mi_tabla$response <- stats::predict(modelo_reducido, mi_tabla, type = "response")
mi_tabla$probability <- stats::predict(modelo_reducido, mi_tabla, type = "prob")
View(mi_tabla)

# Transformar mi_tabla a raster
predicciones <- raster(nrows = nrow(mapa_densidad_ha), 
                       ncols = ncol(mapa_densidad_ha), 
                       xmn = xmin(mapa_densidad_ha),
                       xmx = xmax(mapa_densidad_ha),
                       ymn = ymin(mapa_densidad_ha),
                       ymx = ymax(mapa_densidad_ha),
                       vals = mi_tabla$response)
plot(predicciones)

# ¿Cómo se midió la regeneración en las parcelas del muestreo?
area_regeneracion <- pi * (5^2)
predicciones_ha <- predicciones * 10000 / area_regeneracion

# Explorar resultado
predicciones
predicciones_ha
plot(predicciones_ha)

# Configurar mapa resultante y exportar
names(predicciones_ha) <- c("Regeneracion_estimada")

# Exportar mapa
help(writeRaster) # ¿Qué hace esta función?
writeRaster(x = predicciones_ha, 
            filename = "datos/Regeneracion_estimada",
            format = "GTiff",
            overwrite = TRUE) # CUIDADO!
