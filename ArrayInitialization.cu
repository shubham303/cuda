// cuda program to initialize array elements.

#include <stdio.h> 
#include <cuda.h> 
#define N 100

__global__ void arrayIntialization(int *a) {
    if (threadIdx.x < N)
        a[threadIdx.x] = threadIdx.x;
}
int main() {
    int a[N], *da; 
    int i; 
    cudaMalloc( &da, N * sizeof(int)); 
    arrayIntialization<<<1,1000>>>(da);
    cudaMemcpy(a, da, N * sizeof(int), cudaMemcpyDeviceToHost); 
    for (i = 0; i < N; i++)
        printf("%d ", a[i]); 

    return 0; 

}