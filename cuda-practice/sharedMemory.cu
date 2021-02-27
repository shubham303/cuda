#include<stdio.h>
#include<cuda.h>

__global__ void dkernel(){
    __shared__ int s;
    if(threadIdx.x==0) s=0;

    if(threadIdx.x==1)s+=1;
   // __syncthreads();

    if(threadIdx.x==122) s+=2;
    __syncthreads();
    if(threadIdx.x==0) printf("%d",s);
}

int main(){
    int i;
    for(i=0;i<100;i++){
        dkernel<<<2,1024>>>();
        cudaDeviceSynchronize();
    }
}