# Sesión sobre caracterización de la importancia de los usos del suelo pasados en la regeneración de encinas bajo pinar de repoblación


> + **_Versión_**: 2023-2024
> + **_Asignatura (titulación)_**: Ciclo de gestión del dato: ecoinformática (máster conservación, gestión y restauración de la biodiversidad. UGR). Curso 2019-2020
> + **_Autora_**: María Suárez Muñoz (bv2sumum@uco.es)
> + **_Duración_**: Dos horas (una sesión de dos horas)

## Objetivos del ejercicio

Esta sesión tiene como objetivo generar un mapa de probabilidad de regeneración de la encina en pinar
es de repoblación en función del uso del suelo pasado. Así, se pretende incorporar una nueva variable al análisis sobre selección de lugares adecuados en los que reducir la densidad del pinar de repoblación. A partir de este objetivo trabajaremos otros objetivos específicos:

+ Disciplinares (relacionados con la ecología):
	+ Conocer la influencia del uso del suelo pasado sobre la regeneración y sucesión actual observada en un ecosistema, como un ejemplo de legado ecológico.
	+ Profundizar en los diversos métodos analíticos usados en ecología. Concretamente, tomar conciencia del interés que tiene proyectar un modelo estadístico existente para generar mapas

+ Instrumentales (relacionado con el manejo de herramientas):
	+ Familiarizarse con el acceso, lectura y uso de la bibliografía científica para resolver problemas o cuestiones.
	+ Practicar con lenguajes de programación para usos científicos (R).
	+ Reflexionar sobre los modelos estadísticos: diferencias entre describir y predecir un proceso ecológico, diferencias entre interpolar, imputar y predecir.
	
## Hilo argumental

+ En esta sesión recordaremos el concepto de los legados ecológicos que ya vimos al inicio de la asignatura. Sabemos que los pinares de repoblación se plantaron en distintos sitios, muchos en zonas más o menos degradadas de quercíneas.

+ Alguien se ha planteado si esto (el uso del suelo anterior a las repoblaciones) podría influir en la regeneración actual de la encina... Y para investigarlo ha planteado un experimento para testar esta hipótesis y ha publicado sus resultados en [este](https://doi.org/10.1890/12-0459.1) artículo. u objetivo es determinar en qué medida la regeneración de la encina bajo pinar de repoblación está condicionada por los usos del suelo que había en el territorio antes de la implantación de los pinares.

+ De esta manera han producido un modelo estadístico -algo complejo- que relaciona la regeneración de la encina en el presente con el uso del suelo, la densidad actual del pinar y otras variables. En nuestro caso queremos generar un mapa de probabilidad de regeneración de la encina usando únicamente como variables predictivas la densidad del pinar en la actualidad y los usos del suelo del pasado (1956).

+ Esta presentación describe el hilo argumental anterior y muestra el artículo de referencia:

<p><iframe src="https://prezi.com/view/A5DDq3DWEGJFXsv3Giw6/embed" width="900" height="600"> </iframe></p>

+ Considerando los resultados del artículo podríamos aplicar el modelo estadístico publicado para generar un mapa de probabilidad de regeneración y con ello seguir avanzando en responder a nuestra pregunta: ¿En qué pinares debemos intervenir para maximizar la probabilidad de regeneración de encinas bajo el pinar?

+	Para ello primero necesitaremos reproducir el modelo estadístico que se obtuvo en el estudio, generarlo como un objeto o herramienta que podamos aplicar. 

+	Así podremos, en una segunda fase, aplicarlo sobre un nuevo conjunto de datos, en este caso los valores de densidad y uso del suelo pasado en el resto del territorio, donde se ha muestreado.

+	Al hacer esto generaremos un mapa de regeneración estimada, y reflexionaremos sobre su valor y utilidad.
	

Las fuentes de datos y de código necesarios para realizar la sesión son los siguientes:

+ [Mapa de densidad del pinar](https://github.com/aprendiendo-cosas/peso_pasado_ecoinf_ugr/raw/2023-2024/geoinfo/densidad_pinar_interpolada.tif). En este caso se usa el archivo creado mediante la técnica de interpolación espacial. También se podría usar el mapa de densidad obtenido por teledetección (busca esta capa en el resto de guiones).
+ [Mapa de usos del suelo en 1956](https://github.com/aprendiendo-cosas/peso_pasado_ecoinf_ugr/raw/2023-2024/geoinfo/usos_pasado_2024.tif). Ya está en formato raster, codificado para poder realizar el análisis y generado con la misma extensión y resolución que el mapa de densidad interpolada. Si usas el generado por teledetección y tienes problemas con R, contáctanos.
+ [Código de R](https://github.com/aprendiendo-cosas/peso_pasado_ecoinf_ugr/raw/2023-2024/geoinfo/proyeccion_el_peso_pasado.R.zip) para realizar la "proyección" del modelo estadístico a los datos anteriores. El código está muy bien documentado, así que es autoexplicativo.


Parte de la sesión de un curso anterior se puede ver en el siguiente vídeo.

<iframe width="560" height="315" src="https://www.youtube.com/embed/YaBwNRQw7JA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

