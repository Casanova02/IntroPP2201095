#include <stdio.h>
#include <cuda.h>

__global__ void sumParallel(int *dev_sum, int num)
{
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    int stride = blockDim.x * gridDim.x;
    int localSum = 0;

    while (tid <= num)
    {
        localSum += tid;
        tid += stride;
    }

    atomicAdd(dev_sum, localSum);
}

int main()
{
    int num, sum = 0;
    int *dev_sum;

    printf("Enter a positive integer: ");
    scanf("%d", &num);

    cudaMalloc((void**)&dev_sum, sizeof(int));
    cudaMemcpy(dev_sum, &sum, sizeof(int), cudaMemcpyHostToDevice);

    int blockSize = 256;
    int gridSize = (num + blockSize - 1) / blockSize;

    sumParallel<<<gridSize, blockSize>>>(dev_sum, num);

    cudaMemcpy(&sum, dev_sum, sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(dev_sum);

    printf("\nSum = %d\n", sum);

    return 0;
}
