#include<stdio.h>
#include<cuda.h>

__global__ void per_row_kernel(int m, int n, int *A, int *B, int *C) {
	int id = blockDim.x * blockIdx.x + threadIdx.x;

	if (id < m) {
		for (int i = 0; i < n; i++) {
			C[id * n + i] = A[id * n + i] + B[id * n + i];
		}

	}
}

__global__ void per_column_kernel(int m, int n, int *A, int *B, int *C) {

	int id = threadIdx.x + (blockDim.x * threadIdx.y)
			+ (blockDim.x * blockDim.y * blockIdx.x);

	if (id < n) {
		for (int i = 0; i < m; i++) {
			C[i * n + id] = A[i * n + id] + B[i * n + id];
		}
	}
}

__global__ void per_element_kernel(int m, int n, int *A, int *B, int *C) {
	int blockId = (gridDim.x * blockIdx.y) + blockIdx.x;

	int id = (blockId * blockDim.x * blockDim.y) + (threadIdx.y * blockDim.x)
			+ threadIdx.x;

	if (id < m * n) {
		C[id] = A[id] + B[id];
	}
}


