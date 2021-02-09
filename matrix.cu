__global__ void init(int ** matrix, int N, int M){
    unsigned id=threadIdx.x * blockDim.y + threadIdx.y;
    if (id< N*M){
        matrix[id]=id;
    }
}