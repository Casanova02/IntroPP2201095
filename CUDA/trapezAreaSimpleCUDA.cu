/*
 * Algoritmo para solucionar integrales por la regla del trapecio. Esta algoritmo se ejecuta en 
 * paralelo, usando la plataforma CUDA.
 *
 * Autor: ThesplumCoder.
 * Hecho: 23/06/2023.
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cuda_runtime.h>
 
/* Define la funcion que va a ser integrada aqui */
double f(double x){
  return x*x;
}

/*
 * subInt: numero de sub-intervalos.
 * limIni: limite inicial.
 * tamIntr: tamaño del intervalo.
 * sum: suma acumulada.
 */
__global__ void sumReglaTrapecio (int* subInt, double* limIni, double* tamIntr, double* sum) {
    // idx: Indice del hilo
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    int x;
    if (idx >= 1 && idx <= (*subInt - 1)) {
       x = *limIni + idx * (*tamIntr);
       *sum += (x * x);
    }
    __syncthreads();
}
 
/* Algoritmo empieza */
int main(int argc, char* argv[]) {
    /* n: numero de subintervalos.
     * i:
     * a: limite inicial.
     * b: limite final.
     * h: tamahno del intervalo.
     */
    cudaError_t errorDevice = cudaSuccess;
    int n,i;
    double a,b,h,x,sum=0,integral;

    // Captura de datos pasados por consola.
    n = (int) atoi(argv[1]);
    a = (double) atof(argv[2]);
    b = (double) atof(argv[3]);
    h = (b - a) / (double)n;

    printf("Enter the no. of sub-intervals: %i\n", n);
    printf("Enter the initial limit: %lf\n", a);
    printf("Enter the final limit: %lf\n", b);

    // Hacemos punteros para cada variable del host.
    int* host_n = &n;
    double* host_a = &a;
    double* host_h = &h;
    double* host_sum = &sum;
    if (host_n == NULL || host_a == NULL|| host_h == NULL|| host_sum == NULL) {
        printf("Ocurrio un error con los punteros del host");
        exit(-1);
    }

    // Reservamos memoria para cada variable en el device.
    int* device_n = NULL;
    errorDevice = cudaMalloc((void**)&device_n, sizeof(int));
    if (errorDevice != cudaSuccess) {
        printf("Ocurrio un error reservando memoria del device");
        exit(-1);
    }
    double* device_a = NULL;
    errorDevice = cudaMalloc((void**)&device_a, sizeof(double));
    if (errorDevice != cudaSuccess) {
        printf("Ocurrio un error reservando memoria del device");
        exit(-1);
    }
    double* device_h = NULL;
    errorDevice = cudaMalloc((void**)&device_h, sizeof(double));
    if (errorDevice != cudaSuccess) {
        printf("Ocurrio un error reservando memoria del device");
        exit(-1);
    }
    double* device_sum = NULL;
    errorDevice = cudaMalloc((void**)&device_sum, sizeof(double));
    if (errorDevice != cudaSuccess) {
        printf("Ocurrio un error reservando memoria del device");
        exit(-1);
    }

    // Copiamos los datos del host al device.
    errorDevice = cudaMemcpy(device_n, host_n, sizeof(int), cudaMemcpyHostToDevice);
    if (errorDevice != cudaSuccess) {
        printf("Ocurrio un error copiando del host al device");
        exit(-1);
    }
    errorDevice = cudaMemcpy(device_a, host_a, sizeof(double), cudaMemcpyHostToDevice);
    if (errorDevice != cudaSuccess) {
        printf("Ocurrio un error copiando del host al device");
        exit(-1);
    }
    errorDevice = cudaMemcpy(device_h, host_h, sizeof(double), cudaMemcpyHostToDevice);
    if (errorDevice != cudaSuccess) {
        printf("Ocurrio un error copiando del host al device");
        exit(-1);
    }
    errorDevice = cudaMemcpy(device_sum, host_sum, sizeof(double), cudaMemcpyHostToDevice);
    if (errorDevice != cudaSuccess) {
        printf("Ocurrio un error copiando del host al device");
        exit(-1);
    }

    // Ejecutamos el kernel.
    int hilosPorBloque = 256;
    int bloquesPorRed = 1;
    sumReglaTrapecio<<<bloquesPorRed, hilosPorBloque>>>(device_n, device_a, device_h, device_sum);
    errorDevice = cudaGetLastError();

    // Nos tremos el resultado de la suma.
    errorDevice = cudaMemcpy(host_sum, device_sum, sizeof(double), cudaMemcpyDeviceToHost);
    if (errorDevice != cudaSuccess) {
        printf("Ocurrio un error copiando del device al host\n");
        //printf("%s\n", cudaGetErrorString(errorDevice));
        printf("%s\n", errorDevice);
        exit(-1);
    }

    // Liberamos la memoria en el device.
    errorDevice = cudaFree(device_n);
    if (errorDevice != cudaSuccess) {
        printf("Ocurrio un error liberando memoria del device\n");
        printf("%s\n", errorDevice);
        exit(-1);
    }
    errorDevice = cudaFree(device_a);
    if (errorDevice != cudaSuccess) {
        printf("Ocurrio un error liberando memoria del device\n");
        printf("%s\n", errorDevice);
        exit(-1);
    }
    errorDevice = cudaFree(device_h);
    if (errorDevice != cudaSuccess) {
        printf("Ocurrio un error liberando memoria del device\n");
        printf("%s\n", errorDevice);
        exit(-1);
    }
    errorDevice = cudaFree(device_sum);
    if (errorDevice != cudaSuccess) {
        printf("Ocurrio un error liberando memoria del device\n");
        printf("%s\n", errorDevice);
        exit(-1);
    }
    
    // Reseteamos el device.
    errorDevice = cudaDeviceReset();

    // Imprimimos la suma.
    //printf("Suma del kernel: %lf", *host_sum);
    integral = h * (((f(a) - f(b)) / 2) + *host_sum);
    printf("Integral: %lf", integral);

    // Liberamos la memoria del host.
    /*
    free(host_n);
    free(host_a);
    free(host_h);
    free(host_sum);
    */
}

