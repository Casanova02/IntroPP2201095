// From https://www.programiz.com/c-programming/c-for-loop
// Modified by C. Barrios for training purposes 2023
// Simple Program to calculate the sum of first n natural numbers
// Positive integers 1,2,3...n are known as natural numbers

#include <stdio.h>
#include <time.h>
int main()
{
    int num, count, sum = 0;
    clock_t start_time, end_time;
    double total_time;

    printf("Enter a positive integer: ");
    scanf("%d", &num);

    start_time = clock();
    // for loop terminates when num is less than count
    for(count = 1; count <= num; ++count)
    {
        sum += count;
    }


    end_time = clock();

    total_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;

    printf("\nSum = %d\n", sum);
    printf("Tiempo de ejecucion: %.8f segundos \n", total_time);


    FILE *archivo = fopen("output_summaSimpleSerial.txt","w");

    fprintf(archivo,"\n El resultado de la suma es: %d\n",sum);   
    fprintf(archivo, "Tiempo de ejecucion: %.8f segundos", total_time);

    return 0;
}
