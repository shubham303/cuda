/*
 * memory locality effect of GPU computation efficiency
 */

#include <cuda.h>
#include <stdio.h>
#include <sys/time.h>

#define N 1000000
#define BLOCKSIZE 1024

struct nodeAOS {
  int a;
  double b;

  char c;
} * allNodesAOS;

struct nodeSOA {
  int *a;
  double *b;
  char *c;
} soaNode;

__global__ void aosKernel(struct nodeAOS *allnodes) {
  unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
  allnodes[id].a = id;
  allnodes[id].b = id * 1.1;
  allnodes[id].c = 'c';
}

__global__ void soaKernel(int *a, double *b, char *c) {
  unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
  a[id] = id;
  b[id] = 1.1;
  c[id] = 'c';
}

double rtclock() {
  struct timezone Tzp;
  struct timeval Tp;
  int stat;
  stat = gettimeofday(&Tp, &Tzp);
  if (stat != 0)
    printf("Error return from gettimeofday: %d", stat);
  return (Tp.tv_sec + Tp.tv_usec * 1.0e-6);
}

void printtime(const char *str, double starttime, double endtime) {
  printf("%s%3f seconds\n", str, endtime - starttime);
}

int main() {
  cudaMalloc(&allNodesAOS, N * sizeof(struct nodeAOS));
  // cudaMalloc(&soaNode, N * (sizeof(int) + sizeof(double) + sizeof(char)));

  cudaMalloc(&soaNode.a, N * sizeof(int));
  cudaMalloc(&soaNode.b, N * sizeof(double));
  cudaMalloc(&soaNode.c, N * sizeof(char));

  int blocks = ceil((float)N / BLOCKSIZE);

  double startTime = rtclock();
  aosKernel<<<blocks, BLOCKSIZE>>>(allNodesAOS);
  cudaDeviceSynchronize();
  double endTime = rtclock();
  printtime("AOS time", startTime, endTime);

  startTime = rtclock();
  soaKernel<<<blocks, BLOCKSIZE>>>(soaNode.a, soaNode.b, soaNode.c);
  cudaDeviceSynchronize();
  endTime = rtclock();
  printtime("SOA time", startTime, endTime);
}
