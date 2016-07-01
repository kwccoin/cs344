#include <stdio.h>
#include <myVectorCube.cuh>

__global__ void cube(float * d_out, float * d_in){
	// Todo: Fill in this function

	int i = threadIdx.x;

	float f = d_in[i];

	d_out[i] = f * f * f;

}

int mainCube() {
	const int ARRAY_SIZE = 128;
	const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);

	// generate the input array on the host
	float h_in3[ARRAY_SIZE];
	for (int i = 0; i < ARRAY_SIZE; i++) {
		h_in3[i] = float(i);
	}
	float h_out3[ARRAY_SIZE];

	// declare GPU memory pointers
	float * d_in;
	float * d_out;

	// allocate GPU memory
	cudaMalloc((void**)&d_in, ARRAY_BYTES);
	cudaMalloc((void**)&d_out, ARRAY_BYTES);

	// transfer the array to the GPU
	cudaMemcpy(d_in, h_in3, ARRAY_BYTES, cudaMemcpyHostToDevice);

	// launch the kernel
	cube << <1, ARRAY_SIZE >> >(d_out, d_in);

	// copy back the result array to the CPU
	cudaMemcpy(h_out3, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);

	// print out the resulting array
	for (int i = 0; i < ARRAY_SIZE; i++) {
		printf("%f", h_out3[i]);
		printf(((i % 4) != 3) ? "\t" : "\n");
	}

	cudaFree(d_in);
	cudaFree(d_out);

	return 0;
}