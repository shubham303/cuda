#include <bits/stdc++.h>
#include <cuda.h>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
using namespace std;

struct edgepairs {
	int x;
	int y;
};

int main(int argc, char **argv) {

	int m, n;
	int number;
	int numofquery;
	int op;
	vector<double> kerneltime;

	// File pointer declaration
	FILE *filePointer;

	// File Opening for read
	char *filename = argv[1];
	filePointer = fopen(filename, "r");

	// checking if file ptr is NULL
	if (filePointer == NULL) {
		printf("input.txt file failed to open.");
		return 0;
	}

	fscanf(filePointer, "%d", &n); // scaning the number of vertices
	fscanf(filePointer, "%d", &m); // scaning the number of edges

	// D.S to store the input graph in COO format
	vector<edgepairs> COO(m);

	// Reading from file and populate the COO
	for (int i = 0; i < m; i++) {
		for (int j = 0; j < 2; j++) {
			if (fscanf(filePointer, "%d", &number) != 1)
				break;
			if (j % 2 == 0) {
				if (number >= 1 && number <= 10000)
					COO[i].x = number;
			} else {
				if (number >= 1 && number <= 10000)
					COO[i].y = number;
			}
		}
	}
	// COO done...

	int *initlocalvals = (int *) malloc(n * sizeof(int));
	;
	for (int i = 0; i < n; i++) {
		if (fscanf(filePointer, "%d", &number) != 1)
			break;

		initlocalvals[i] = number;
	}

	int *currentupdate = (int *) malloc(n * sizeof(int));

	char *fname = argv[2];
	FILE *fptr;
	fptr = fopen(fname, "w");
	fscanf(filePointer, "%d", &numofquery);
	for (int i = 0; i < numofquery; i++) {

		// read the operator
		fscanf(filePointer, "%d", &op);

		if (op != 3) { // if operator is other then enumerate (i.e. +,min,max)

			// read the current updates in the array
			for (int j = 0; j < n; j++) {
				if (fscanf(filePointer, "%d", &number) != 1)
					break;
				currentupdate[j] = number;
			}

			if (op == 0) {
				for (int i = 0; i < m; i++) {
					int x = COO[i].x;
					int y = COO[i].y;

					initlocalvals[y - 1] += currentupdate[x - 1];

				}
			}
			if (op == 1) {
				for (int i = 0; i < m; i++) {
					int x = COO[i].x;
					int y = COO[i].y;

					initlocalvals[y - 1] = min(initlocalvals[y - 1],
							currentupdate[x - 1]);

				}
			}
			if (op == 2) {
				int x = COO[i].x;
				int y = COO[i].y;

				initlocalvals[y - 1] = max(initlocalvals[y - 1],
						currentupdate[x - 1]);
			}
		}

		else { // if operator is enumnerate then store the results to file
			   // print local values of each vertices.

			for (int j = 0; j < n; j++) {
				fprintf(fptr, "%d ", initlocalvals[j]);
			}
			fprintf(fptr, "\n");
		}
	}

}
