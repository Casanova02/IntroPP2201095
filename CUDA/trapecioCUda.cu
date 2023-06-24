#include <stdio.h>
#include <math.h>

// Define the function to be integrated here:
__host__ __device__ double f(double x){
  return x*x;
}

__device__ void atomicAddDouble(double* address, double val){
  unsigned long long int* address_as_ull = (unsigned long long int*)address;
  unsigned long long int old = *address_as_ull, assumed;

  do {
    assumed = old;
    old = atomicCAS(address_as_ull, assumed, __double_as_longlong(val + __longlong_as_double(assumed)));
  } while (assumed != old);
}

__global__ void trapezoidalRule(int n, double a, double b, double h, double* integral){
  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  double x, sum = 0.0;

  for(int i = tid + 1; i < n; i += blockDim.x * gridDim.x){
    x = a + i * h;
    sum += f(x);
  }

  atomicAddDouble(integral, sum);
}

int main(){
  int n;
  double a, b, h, integral = 0.0;
  double *d_integral;

  // Ask the user for necessary input
  printf("\nEnter the no. of sub-intervals: ");
  scanf("%d", &n);
  printf("\nEnter the initial limit: ");
  scanf("%lf", &a);
  printf("\nEnter the final limit: ");
  scanf("%lf", &b);

  // Calculate step size
  h = fabs(b - a) / n;

  // Allocate memory on the device for the integral
  cudaMalloc((void**)&d_integral, sizeof(double));
  cudaMemcpy(d_integral, &integral, sizeof(double), cudaMemcpyHostToDevice);

  // Set grid and block dimensions
  int blockSize = 256;
  int gridSize = (n + blockSize - 1) / blockSize;

  // Launch kernel to perform trapezoidal rule
  trapezoidalRule<<<gridSize, blockSize>>>(n, a, b, h, d_integral);

  // Copy the result back to the host
  cudaMemcpy(&integral, d_integral, sizeof(double), cudaMemcpyDeviceToHost);

  // Free device memory
  cudaFree(d_integral);

  // Multiply by h/2 and add the first and last terms
  integral = (h/2) * (f(a) + f(b) + 2 * integral);

  // Print the answer
  printf("\nThe integral is: %lf\n", integral);
}


