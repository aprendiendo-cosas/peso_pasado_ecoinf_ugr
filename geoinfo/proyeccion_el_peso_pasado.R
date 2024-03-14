### Caracterización del efecto de la densidad y el uso del suelo del pasado en la regeneración de *Quercus ilex* bajo pinar en Sierra Nevada

## PARTE I: Reproducir modelo estadístico

# Descargar datos
# Acceso al artículo: https://esajournals.onlinelibrary.wiley.com/doi/abs/10.1890/12-0459.1
# Material suplementario del artículo: http://www.esapubs.org/archive/appl/A023/065/
# Descargar archivo "data.txt" 
# Guardarlo en una carpeta "datos" donde tengamos este código
# Descargar mapas de densidad interpolada y uso de suelo y guardarlos también la subcarpeta "datos"

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
dic_uso_suelo <- data.frame(Cod_Uso = as.factor(c(1:5)), # El código de uso es un factor, no un número
                            Uso_suelo = c("Oak formation", "Mid-mountain shrubland", "Pasture", NA, "Crops"))

datos <- datos %>%
  left_join(dic_uso_suelo)
View(datos)

# Generar el modelo estadístico y explorarlo
help(zeroinfl)

modelo_completo <- zeroinfl(Reclutamiento_5mplot ~ Densidad_pies_ha + Cod_Uso + Distancia_media_m, 
                            data = datos, dist = "poisson", link = "logit")

modelo_densidad <- zeroinfl(Reclutamiento_5mplot ~ Densidad_pies_ha, 
                            data = datos, dist = "poisson", link = "logit")

modelo_densidad_uso <- zeroinfl(Reclutamiento_5mplot ~ Densidad_pies_ha + Cod_Uso, 
                            data = datos, dist = "poisson", link = "logit")

# Exploramos los modelos
modelo_densidad_uso
summary(modelo_densidad_uso)

## PARTE II: Generar predicciones

# Cargar mapa de densidad sobre el que queremos generar predicciones: valores de densidad generado en sesiones anteriores
mapa_densidad_ha <- raster("datos/densidad_pinar_interpolada.tif")
# mapa_densidad_ha <- raster("datos/density_kriging.asc")

# Explorar mapa
mapa_densidad_ha
plot(mapa_densidad_ha)

# ¿Cómo se midió la densidad en las parcelas del muestreo? ¿Tenemos que hacer alguna transformación?
names(mapa_densidad_ha) <- c("Densidad_pies_ha")

# Cargar mapa de uso del suelo sobre el que queremos generar predicciones
uso <- raster("datos/uso_pasado_pinos.tif")
uso <- raster("usos_pasado_2024.tif")

# Explorar mapa
uso
names(uso) <- c("Cod_Uso")
uso
plot(uso)

# Crear brick con ambas variables: densidad y uso
mi_brick <- brick(mapa_densidad_ha, uso)
mi_brick

# Generar predicciones
help(predict) # ¿Qué hace esta función?
predicciones_segun_densidad <- predict(mapa_densidad_ha, modelo_densidad)
predicciones_segun_densidad

predicciones_segun_densidad_uso <- predict(mi_brick, modelo_densidad_uso)
# No funciona (no podemos incluir la variable Cod_Uso como factor cuando es un), tenemos que generar una tabla con densidad y uso para cada celda, predecir y entoncer transformar a raster de nuevo

# Generar una tabla con densidad y uso para cada celda
mi_tabla <- data.frame(Densidad_pies_ha = values(mapa_densidad_ha$Densidad_pies_ha),
                       Cod_Uso = as.factor(values(uso$Cod_Uso))) 
View(mi_tabla)

# Predecir
mi_tabla$response <- stats::predict(modelo_densidad_uso, mi_tabla, type = "response")
mi_tabla$probability <- stats::predict(modelo_densidad_uso, mi_tabla, type = "prob")
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
area_regeneracion <- pi * (5^2) # subparcelas de 5 m de radio
predicciones_ha <- predicciones * 10000 / area_regeneracion # m2 a ha

# Explorar resultado
predicciones
predicciones_ha
plot(predicciones_ha)

# Configurar mapa resultante y exportar
names(predicciones_ha) <- c("Regeneracion_estimada_recruits_ha")
crs(predicciones_ha) <- crs(uso)

# Exportar mapa
help(writeRaster) # ¿Qué hace esta función?
writeRaster(x = predicciones_ha, 
            filename = "datos/Regeneracion_estimada_recruits_ha",
            format = "GTiff",
            overwrite = TRUE) # CUIDADO!
