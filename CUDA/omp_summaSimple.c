#include <stdio.h>
#include <omp.h>
int main()
{

    FILE *fp;
    int num, count, sum = 0;

    printf("Enter a positive integer: ");
    scanf("%d", &num);


    //Measure the start of the run time
    double start = omp_get_wtime();



    //Parallelize the for loop using four threads

    #pragma omp parallel for num_threads(4) reduction(+:sum)

    // for loop terminates when num is less than count
    for(count = 1; count <= num; ++count)
    {
        sum += count;
    }


    printf("\nSum = %d\n", sum);

    //Measure the end of the run time

    double end = omp_get_wtime();

    printf("El tiempo que tomo realizar la tarea fue %lf segundos\n",end-start);



    /* Once the program has ended, proceed to place the results
     in a txt file */

    fp = fopen("output_omp_summaSimple.txt","w");

    fprintf(fp,"\nSum = %d\n", sum);

    fprintf(fp, "El tiempo que tomo realizar la tarea fue %lf segundos\n",end-start);

    fclose(fp);


    return 0;
}
