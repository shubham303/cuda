// cuda program to initialize array elements.

#include <stdio.h> 
#include <cuda.h> 
#define N 8000

__global__ void arrayIntialization(int *a) {
    unsigned int tid=blockIdx.x*blockDim.x+threadIdx.x;
    if ( tid < N)
        a[tid] = 0;
}

__global__ void initializeArrayToNumber(int *a){
    unsigned int tid=(blockIdx.x*blockDim.x)+threadIdx.x;
    if ( tid < N)
        a[tid]+=tid;
   
}
int main() {
    int a[N], *da; 
    int i; 
    cudaMalloc( &da, N * sizeof(int)); 
    arrayIntialization<<<8,1024>>>(da);
    cudaMemcpy(a, da, N * sizeof(int), cudaMemcpyDeviceToHost); 
   
    //for (i = 0; i < N; i++)
//        printf("%d ", a[i]); 

    printf("\n \n");
    initializeArrayToNumber<<<8,1024>>>(da);
    cudaDeviceSynchronize();
    cudaMemcpy(a, da, N*sizeof(int), cudaMemcpyDeviceToHost);


    for (i = 0; i < N; i++)
        printf("%d ", a[i]); 

                    return 0; 

}