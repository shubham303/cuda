// program to print n Numbers


#include<stdio.h>
#include<cuda.h>

#define N 100

__global__ void print(){
    if(threadIdx.x<N)
        printf("%d ",threadIdx.x*threadIdx.x);

}
int main(){
    int i;

    printf("numbers printing by CPU \n ");

    for( i=0;i<N ;i++){
        printf("%d ",i*i);
    }
    printf("\n numbers printing by GPU\n");

    print<<<1,N>>>();
    cudaDeviceSynchronize();


    return 0;

}