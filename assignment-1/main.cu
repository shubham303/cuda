#include"kernels.h"
#include<stdio.h>
#include<cuda.h>
#include <bits/stdc++.h>
#include <stdlib.h>

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

void per_element_cpu(int m, int n, int *A, int *B, int *C) {

	for (int id = 0; id < (m * n); id++) {
		C[id] = A[id] + B[id];
	}
}

void readInput(FILE* f, int m, int n, int * A, int *B) {

	for (int i = 0; i < m; i++) {
		for (int j = 0; j < n; j++) {
			fscanf(f, "%d", A + (i * n + j));
		}
	}

	for (int i = 0; i < m; i++) {
		for (int j = 0; j < n; j++) {
			fscanf(f, "%d", B + (i * n + j));
		}
	}
}

void perRowAddition(int m, int n, int* A, int* B, int *C, int* D) {
	int threads = 0;
	int blocks = 1;
	if (m < 1024) {
		threads = m;
	} else {
		threads = 1024;
		blocks = m / 1024;
	}

	int * gpuA;
	int * gpuB;
	int * gpuC;

	cudaMalloc(&gpuA, m * n * sizeof(int));
	cudaMemcpy(gpuA, A, m * n * sizeof(int), cudaMemcpyHostToDevice);

	cudaMalloc(&gpuB, m * n * sizeof(int));
	cudaMemcpy(gpuB, B, m * n * sizeof(int), cudaMemcpyHostToDevice);

	cudaMalloc(&gpuC, m * n * sizeof(int));

	time_t start, end;
	time(&start);
	per_row_kernel<<<blocks, threads>>>(m, n, gpuA, gpuB, gpuC);
	cudaDeviceSynchronize();

	time(&end);

	printf("%lf \n", double(end - start));

	cudaMemcpy(C, gpuC, m * n * sizeof(int), cudaMemcpyDeviceToHost);

	for (int i = 0; i < m * n; i++) {
		if (C[i] != D[i]) {
			//	printf("error");
		}
	}
}

void perColumnAddition(int m, int n, int *A, int*B, int *C, int* D) {
	dim3 threads(32, 32);
	int blocks = 10;

	int * gpuA;
	int * gpuB;
	int * gpuC;

	cudaMalloc(&gpuA, m * n * sizeof(int));
	cudaMemcpy(gpuA, A, m * n * sizeof(int), cudaMemcpyHostToDevice);

	cudaMalloc(&gpuB, m * n * sizeof(int));
	cudaMemcpy(gpuB, B, m * n * sizeof(int), cudaMemcpyHostToDevice);

	cudaMalloc(&gpuC, m * n * sizeof(int));

	time_t start, end;
	time(&start);
	per_column_kernel<<<blocks, threads>>>(m, n, gpuA, gpuB, gpuC);
	cudaDeviceSynchronize();

	time(&end);

	printf("%lf \n", double(end - start));

	cudaMemcpy(C, gpuC, m * n * sizeof(int), cudaMemcpyDeviceToHost);

	cudaDeviceSynchronize();

	for (int i = 0; i < m * n; i++) {
		if (C[i] != D[i]) {
			//	printf("error");
		}
	}
}

void perElementAddition(int m, int n, int *A, int*B, int *C, int* D) {
	dim3 threads(32, 32);

	int x = ((m * n) / 1024) / 3;

	dim3 blocks(x, 4);

	int * gpuA;
	int * gpuB;
	int * gpuC;

	cudaMalloc(&gpuA, m * n * sizeof(int));
	cudaMemcpy(gpuA, A, m * n * sizeof(int), cudaMemcpyHostToDevice);

	cudaMalloc(&gpuB, m * n * sizeof(int));
	cudaMemcpy(gpuB, B, m * n * sizeof(int), cudaMemcpyHostToDevice);

	cudaMalloc(&gpuC, m * n * sizeof(int));

	time_t start, end;
	time(&start);
	per_element_kernel<<<blocks, threads>>>(m, n, gpuA, gpuB, gpuC);
	cudaDeviceSynchronize();

	time(&end);

	printf("%lf \n", double(end - start));

	cudaMemcpy(C, gpuC, m * n * sizeof(int), cudaMemcpyDeviceToHost);

	cudaDeviceSynchronize();

	for (int i = 0; i < m * n; i++) {
		if (C[i] != D[i]) {
			//printf("%d %d %d \n", C[i], D[i], i);
		}
	}
}
int main() {
	int m, n;
	int * A;
	int * B;

	int * C;
	time_t start, end;
	FILE * f = fopen("testcases/input/input3.txt", "r");
	fscanf(f, "%d %d", &m, &n);

	int *D = (int *) malloc(m * n * sizeof(int));
	FILE *w = fopen("testcases/output/output3.txt", "r");
	for (int i = 0; i < m; i++) {
		for (int j = 0; j < n; j++) {
			fscanf(w, "%d", D + (i * n + j));
		}
	}

	m = 2;
	n = 67108864;

	A = (int *) malloc(m * n * sizeof(int));
	B = (int *) malloc(m * n * sizeof(int));
	C = (int *) malloc(m * n * sizeof(int));

	//readInput(f, m, n, A, B);

	for (int i = 0; i < m * n; i++) {
		A[i] = rand();
		B[i] = rand();
	}

	perRowAddition(m, n, A, B, C, D);
	perColumnAddition(m, n, A, B, C, D);
	perElementAddition(m, n, A, B, C, D);

	time (&start);
	per_element_cpu(m, n, A, B, C);
	time (&end);
	printf("%lf \n", double(end - start));
}
