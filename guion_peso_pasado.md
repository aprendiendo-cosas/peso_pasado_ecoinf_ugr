# Sesión sobre caracterización de la importancia de los usos del suelo pasados en la regeneración de encinas bajo pinar de repoblación


> + **_Versión_**: 2019-2020
> + **_Asignatura (titulación)_**: Ciclo de gestión del dato: ecoinformática (máster conservación, gestión y restauración de la biodiversidad. UGR). Curso 2019-2020
> + **_Autora_**: María Suárez Muñoz (maria.suarez.munoz@gmail.com)



## Objetivos del ejercicio

Esta actividad tiene los siguientes objetivos de aprendizaje:

+ Incorporar una nueva variable al análisis multicriterio sobre selección de lugares adecuados en los que reducir la densidad del pinar de repoblación. 
+ Tomar conciencia del interés que tiene proyectar un modelo estadístico existente para generar mapas que muestren la probabilidad de presencia de una variable determinada.
+ Generar una capa que muestre la probabilidad de regeneración de encina bajo el encinar en función de los usos del suelo del pasado.

## Contenido

Toda esta sesión se basa en [este](https://github.com/aprendiendo-cosas/peso_pasado_ecoinf_ugr/raw/main/biblio/articulo_JRC_2013_weight_past.pdf) artículo titulado "*The weight of the past: land-use legacies and recolonization of pine plantations by oak trees*". Su objetivo es determinar en qué medida la regeneración de la encina bajo pinar de repoblación está condicionada por los usos del suelo que había en el territorio antes de la implantación de los pinares. 



Esta sesión se basa en el artículo anterior pero simplifica un poco el problema. La idea es generar un mapa de probabilidad de regeneración de la encina usando únicamente como variables predictivas la densidad del pinar en la actualidad y los usos del suelo del pasado (1956). 



La sesión completa se puede ver en el siguiente vídeo.

<iframe width="560" height="315" src="https://www.youtube.com/embed/YaBwNRQw7JA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>



Las fuentes de datos y de código necesarios son los siguientes:

+ [Mapa de densidad del pinar](https://github.com/aprendiendo-cosas/peso_pasado_ecoinf_ugr/raw/main/geoinfo/density_kriging.asc). En este caso se usa el archivo creado mediante la técnica de kriging. Pero seguramente quedará mejor si se usa el mapa de densidad obtenido por teledetección (busca esta capa en el resto de guiones).
+ [Mapa de usos del suelo en 1956](https://github.com/aprendiendo-cosas/peso_pasado_ecoinf_ugr/raw/main/geoinfo/uso_pasado_pinos.tif). Ya está en formato raster y está codificado para poder realizar el análisis.
+ [Código de R](https://github.com/aprendiendo-cosas/peso_pasado_ecoinf_ugr/raw/main/geoinfo/proyeccion_el_peso_pasado.R.zip) para realizar la "proyección" del modelo estadístico a los datos anteriores. El código está muy bien documentado, así que es autoexplicativo.





