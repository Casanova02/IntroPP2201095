En la presente carpeta se encuentran los archivos del parcial 1 de memoria compartida.

El codigo se trata de un algoritmo de suma simple donde se suman acumulativamente los indice de una iteracion o ciclo for, es decir que si el es un ciclo for de 1 a 4, se realiza una suma
de la siguiente manera: 1+2+3+4.

EL codigo de omp paraleliza el ciclo for, para ello se usan 4 hilos, y al final con reduction(+:sum) sumamos el resultado de todos los hilos y quedan almacenados en la variable sum.

Para ejecutar el codigo en mi maquina local hago us de gcc y utilizo el comando: gcc -fopenmp omp_summaSimple.c -o omp_summaSimple

Para ejecutar el codigo en el cluster GUANE hago uso de la reserva interactiva usando el comando: srun -n4 --pty /bin/bash ,y despues compilo con: gcc -fopenmp omp_summaSimple.c -o omp_summaSimple -lm
aunque tambien se puede usar el archivo bash usando el comando: ./summaSimple.sbatch
