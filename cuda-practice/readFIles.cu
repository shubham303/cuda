/*
Read a sequence of integers from a file.
● Square each number.
● Read another sequence of integers from
another file.
● Cube each number.
● Sum the two sequences element-wise, store in
the third sequence.
● Print the computed sequence.
*/

#include<stdio.h>
#include<cuda.h>

#define N 2
#define M 32


__global__ void square(int* da, int length){
    unsigned id=blockIdx.x*blockDim.x+threadIdx.x;
    if(id<length){
        da[id]=da[id]*da[id];
       
    }
}

__global__  void cube(int *da, int length){
    unsigned id=blockIdx.x*blockDim.x+threadIdx.x;
    if(id<length){
        da[id]=da[id]*da[id]*da[id];
    }
}

__global__ void add(int* a, int *b, int length){
    unsigned id=blockIdx.x*blockDim.x+threadIdx.x;
    if(id<length){
        a[id]+=b[id];
    }
}

int main(){
    FILE *f;
    int array[1024];
    int *a,*b;

   int length=0;
    int data;
    char aux;
    
    f=fopen("numbers1.txt","r");

    while(EOF!=fscanf(f,"%d%c",&data,&aux)){
        array[length]=data;
        length++;
    }


    
    cudaMalloc(&a, length*sizeof(int));
    cudaMemcpy(a,array,length*sizeof(int), cudaMemcpyHostToDevice);
    square<<<N,M>>>(a, length);

    length=0; 
    f=fopen("numbers2.txt","r");
    while(EOF!=fscanf(f,"%d%c",&data,&aux)){
        array[length]=data;
        length++;
    }
    cudaMalloc(&b, length*sizeof(int));
    cudaMemcpy(b,array, length*sizeof(int), cudaMemcpyHostToDevice);
    cube<<<N,M>>>(b,length);
    add<<<N,M>>>(a,b,length);

    cudaMemcpy(array, a, length*sizeof(int),cudaMemcpyDeviceToHost);

    for(int i=0;i<length;i++){
        printf("%d ",array[i]);
    }
    
}