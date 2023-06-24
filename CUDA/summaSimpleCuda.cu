#include <stdio.h>

//Aqui definimos nuestro kernel, donde el parametro va a ser la referencia de la direccion de la variable dev_sum y el numero que vamos a sumar
//tid representa el identificador unico de cada hilo

/*La expresión threadIdx.x devuelve el índice del hilo dentro de su bloque, mientras que blockIdx.x devuelve el índice del bloque dentro de la cuadrícula.

La multiplicación blockIdx.x * blockDim.x se utiliza para calcular el desplazamiento necesario para asignar un identificador único a cada hilo en la cuadrícula completa.

Sumando threadIdx.x y blockIdx.x * blockDim.x, obtenemos un valor único para cada hilo en la cuadrícula */
__global__ void sumParallel(int *dev_sum, int num)
{
    int tid = threadIdx.x + blockIdx.x * blockDim.x;

	/*stride se puede definir como el paso y se calcula se calcula como el producto entre blockDim.x y gridDim.x Esto permite distribuir uniformemente la
	 carga de trabajo entre los hilos en todos los bloques de la cuadrícula */
    int stride = blockDim.x * gridDim.x;

    while (tid <= num)
    {

	/* se usa la función atomicAdd para realizar la sumatoria y  garantizar que varios hilos no vayan a escribir simultáneamente en la misma ubicación de memoria. */
        atomicAdd(dev_sum, tid);
        tid += stride; //coge el identificado unico de cada hilo y le agrega el paso para pasar al siguiente hilo
    }
}

int main()
{
    int num, sum = 0;
    int *dev_sum; //referencia de la variable que se ubicara en el device

    /*Inicializamos las variables con las cuales tomaremos el tiempo */
    cudaEvent_t start, stop;
    float elapsedTime;


    printf("Enter a positive integer: ");
    scanf("%d", &num);


    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start, 0); //comienza a tomar el tiempo
    
    cudaMalloc((void**)&dev_sum, sizeof(int)); //reservamos espacio de memoria
    cudaMemcpy(dev_sum, &sum, sizeof(int), cudaMemcpyHostToDevice); //copaimos la variable desde el host al sum

    int blockSize = 256;
    int gridSize = (num + blockSize - 1) / blockSize;

    sumParallel<<<gridSize, blockSize>>>(dev_sum, num); //invocamos el kernel sumParallel que es el que se encarga de realizar la suma

    cudaMemcpy(&sum, dev_sum, sizeof(int), cudaMemcpyDeviceToHost); //copiamos el resultado ahora en sentido contrario, es decir desde el device hasta el host
    cudaFree(dev_sum); //liberamos la memoria reservada

    printf("\nSum = %d\n", sum); //imprimimos el resultado de la suma
    
    cudaEventRecord(stop, 0); //para de tomar el tiempo
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&elapsedTime, start, stop);

    printf("Elapsed Time: %.6f segundos\n", elapsedTime/1000); //me imprime el tiempo que demoro

    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    return 0;
}
