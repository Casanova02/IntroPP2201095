#include <stdio.h>
#include <mpi.h>

int main(int argc,char* argv[])
{
        int num, count, sum = 0;
        int rank, size;
        int local_sum = 0;


        //Variables para el tiempo
        double start_time, end_time;

        //Iniciamos MPI
        MPI_Init(&argc,&argv);

        //Get the identifier or rank of actual process
        MPI_Comm_rank(MPI_COMM_WORLD, &rank);

        //Number of processes
        MPI_Comm_size(MPI_COMM_WORLD, &size);


        //When we are in the main process we enter a integer
        if (rank == 0)
        {
                printf("Enter a positive integer: ");
                scanf("%d",&num);
        }


        //Transfer the value of the variable num to each process
        //the number 1 indicates that we are only transfering one value, the value
        //of the variable num
        MPI_Bcast(&num, 1,MPI_INT,0,MPI_COMM_WORLD);


        //We start measuring the time
        start_time = MPI_Wtime();

        //To calculate the number of iterations for each process we divide
        //num in size

        //then we multiply by the rank and add one to calculate the
        //beginning value for each process
        int start = rank * (num/size) +1;

        //We calculate the end of each process, if the process is the last, it means
        //that is the size - 1 process, we assign value, otherwise we calculate the
        //end of the process by adding rank plus 1 and the multiplying by the number
        //of iterations for each process
        int end = (rank == size - 1) ? num : (rank + 1) * (num/size);


        //All processes make the for loop in their respective range
        for (count = start; count <= end; ++count)
        {
                local_sum += count;
        }


        //We reunited the result of all the processes and storage it in the variable sum
        MPI_Reduce(&local_sum, &sum, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);


        //We end the measuring of the time
        end_time = MPI_Wtime();

        //If we are in the main process
        if (rank == 0)
        {
                //Print the result of the sum
                printf("\n Sum = %d \n", sum);

                //print the time
                printf("Elapsed time = %f seconds\n", end_time - start_time);

                //The rest of the code it's to create and allocate the results into a txt file
                FILE *file = fopen("output_mpi_summaSimple.txt","w");

                if(file != NULL)
                {
                        fprintf(file,"La suma es igual a: %d \n",sum);
                        fprintf(file, "El tiempo de ejecucion es: %f segundos \n", end_time - start_time);

                        fclose(file);
                }

        }



        MPI_Finalize();

        return 0;
}
