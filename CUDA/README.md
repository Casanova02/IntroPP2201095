# Parcial 3 - procesamiento memoria híbrida CPU-GPU

## Integrantes del grupo: 
* Anderson Yeseth Acuña Vargas - 2191965
* Cristhian Ivan Tristancho Corzo - 2192532
* Santiago Leal Casanova - 2201095

### Datos a tener en cuenta:

En la presenta carpeta se encuentran los archivos correspondientes al tercer parcial que coresponde al uso de la programación en gpus usando CUDA.

En esta carpeta no solo se encuentran los codigos en CUDA con sus respectivos resultados, sino que también se encuentran los códigos y los resultados de los códigos en OMP y 
MPI(aunque para OMP y MPI solo se trajeron los códigos de la suma simple para evitar cargar el respositorio con demasiados archivos y que despues la tarea ed encontrar un
archivo en especifco se vuelva un poco engorrosa),esto con el motivo de comparar los resultados de las tres alternativas, OMP, MPI Y GPU.

Tambien cabe recalcar que cada codigo de cuda cuenta con su respectivo sbatch para su ejecución en el cluster, y para ejecutarlo en maquinas locales se realiza de manera manual compilando el codigo con el comando nvcc codigoCuda.cu -o ejecutable con lo que se genera el binario y se ejecuta usando la instrucción ./ejecutable.

Adicionalmente es bueno tener en cuenta que el codigo del trapecio en CUDA no cuenta con un archivo txt donde me muestra los resultados sino que al ejecutar el sbatch es cuando obtengo la lista de resultados.

### Resultados comparando únicamente los códigos de CUDA:

Ahora bien, pasando a los resultados, cabe mencionar que entre los dos codigos,es decir entre la suma simple y el trapecio, en su implementación en CUDA el que tuvo mejor rendimiento es el de suma simple.
siendo el que menos se demoraba en ejecutar de ambos, además cabe mencionar que la escalabilidad de los codigos de CUDA  es muy buena, pues apesar de aumentar el número de sumatorias en el caso de summa
simple o del limite    de la integral y sus particiones en el caso del codigo del trapecio, los tiempos de ejecución tenian tiempos bastantes similares, lo que deja ver el potencial de CUDA en el sentido
que el proposito de programar en gpus es poder tratar una gran cantidad de datos debido a la gran cantidad de unidades arimeticas logicas que contienen las gpus y que por ende puedo paralelizar muchas
tareas al mismo tiempo, y esta gran capacidad de computo se deja ver en la gran escalabilidad que tienen los codigos en CUDA.

### Resultado comparando OMP, MPI Y CUDA

Por último, comparando los resultados obtenidos usando codigo serial,omp, mpi y CUDA, podemos decir que el mejor de todos es sin el código serial, teniendo los tiempos de ejcución más reducidos, sin embargo
esto se debe a la poca capacidad de computo que representa la ejecución de los programas que ejecutamos, despues del codigo serial sigue omp,mpi y por último CUDA, lo cual tiene todo el sentido del mundo 
porque en las tecnologias de paralelización estan diseñadas para ejecutar una gran embergadura de datos y el sobrecoste que implica coordinar los diferentes hilos de ejecución conlleva sobrecargas
que no se ven compensadas al ejecutar codigos con una carga de computo tan pequeña como los de suma simple y trapecio, además de que algo curioso es que en terminos de escalabilidad el orden seria
CUDA, MPI,OMP y el codigo serial porque CUDA es la tecnologia que esta diseñada para trabajar con más datos, luego MPI, OMP y al final el codigo serial, dandonos un resultado curioso, viendo como para codigos
con poca necesidad de computo entre mayor capacidad de procesar gran cantidad de datos me ofrezca la tecnologia pues la capacidad de paralelización es mayor, peor va a ser el rendimiento al menos es lo que
se evidencio en estos ejercicios.

