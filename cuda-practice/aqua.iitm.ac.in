#include<stdio.h>

#include<cuda.h>

__global__ void shubham(){
    printf("shubham");
}
__global__ void dkernel(){
    printf("hello ");
}
int main(){
    dkernel<<<1,1>>>();
    shubham<<<1,1>>>();
    cudaDeviceSynchronize();
    return 0;
}