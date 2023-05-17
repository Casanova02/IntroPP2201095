En la presente carpeta se encuentran los archivos del parcial 2 de memoria distribuida.

El codigo se trata de un algoritmo de suma simple donde se suman acumulativamente los indice de una iteracion o ciclo for, es decir que si el es un ciclo for de 1 a 4, se realiza una suma
de la siguiente manera: 1+2+3+4.

EL codigo de mpi_summaSimple.c nos muestra como se paraleliza el código original llamado summaSimple.c, adicionalmente el codigo se encuentra documentado explicando los pasos 
realizados para la correcta paralelización del código usando MPI.

Para ejecutar el codigo en mi maquina local hago uso de gcc y utilizo los siguientes comandos comando: 

Para C normal:
  gcc summaSimple.c -o summaSimpleSerial y despues se usa el comando ./summaSimpleSerial

Para openMP: 
  gcc -fopenmp omp_summaSimple.c -o omp_summaSimple  y despues se usa el comando ./omp_summaSimple

Para MPI:
  mpicc mpi_summaSimple.c -o mpi_summaSimple y despues se usa el comando mpirun -n "numeroDeCores" ./mpi_summaSimple

Para ejecutar el codigo en el cluster GUANE hago uso de la reserva interactiva usando el comando: srun -n4 --pty /bin/bash ,y despues compilo con: 

Para C normal:
  gcc summaSimple.c -o summaSimpleSerial -lm y despues se ejecuta el ejecutable con el comando ./omp_summaSimple

Para OpenMP:
  gcc -fopenmp omp_summaSimple.c -o omp_summaSimple -lm y despues se ejecuta el ejecutable con el comando ./omp_summaSimple

Para MPI:
  mpicc mpi_summaSimple.c -o mpi_summaSimple y despues se ejecuta el ejecutable con el comando mpirun -np "numeroDeCores" mpi_summaSimple
  
  Realmente los códigos se ejecutan de una manera muy similar tanto en la maquina local como en GUANE, la principal diferencia es que en GUANE toca realizar la reserva interactiva.
  
  En este caso no se incluyo el archivo bash debido a que toca seleccionar introducir el n+umero al cual se le quiere realizar la sumatoria en mitad de la ejecucción.
  
  También cabe mencionar que en el código de MPI huboun error y no se muestra el mensaje de "inserte un número", simplemente se salta la impresión de esas palabras y la consola se
  se pone a esperar a que le insertemos un número, pero despues de realizar la sumatoria la consola si muestra el respectivo mensaje. Menciono esto simplemente para que  se este al tanto de ese     error.
  
  Cabe mencionar que se subieron los resultados de los códigos estar en archivos txt, 3 archivos en total, uno para código serial, otro para openMP y otro para MPI.
  
  Por último las conclusiones, una vez realizado el experimento se pudo evidenciar que el más rapido de todos fue el codigo serial, lo cual realmente tiene bastante sentido, debido a que
  el proceso al ser tan sencillo, la carga computacional no es demasiado grande, razón po la cual no hay significativas sino incluso perdidas a la hora de paralelizar el codigo, pues al demorarse
  tan poco en el proceso de compilación, la sobrecarga que conlleva el hecho de crear los hilos, coordinarlos y juntarlos o el tiempo entre comuncicaciones entre nodos y coordinacio de procesos
  hace que en paralelo el proceso se demore más que lo que se demoraria en código serial, sin emabrgo cabe recalcar que entre las dos opciones de paralelización es decir en openMP y MPI 
  respectivaemnte o mejor dicho, memoria compartida y memoria distribuida, la que obtuve mejores resultados fue la opción de memoria distribuida o MPI para todas las veces 
  que se realizo el experimento, realizando la sumatoria con diferentes números con un número reducido de cores o nods por ejemplo 2, pero a meedida que se aumentaban los nodos
  en la memoria distribuida, el rendimiento tendía a empeorar, por lo que para número de cores elevado como por ejemplo 8, la memoria compartida solia tener un mejor rendimiento que
  el código en memoria distribuida, por último cabe aclarar que el código en OpenMP o de memoria compartida siempre se compilo y ejecuto con un número fijo de hilos, en este caso 4 hilos.
  
  Cabe agregar que aparte los codigos no solo se encuentran en el github sino también en mi usuario de guane salealc en una carpeta llamada igual que en el github es decir llamada MPI
