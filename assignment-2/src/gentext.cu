#include<bits/stdc++.h>

using namespace std;

int main() {
	FILE *ptr = fopen("input.txt", "w");
	srand(time(NULL));
	int numberOfVertices = 10000, numberOfQueries = 40, numberOfAddQ = 10,
			numberOfMiinQ = 10, numberOfMaxQ = 10, numberOfPrintQ = 10;


	scanf("%d", &numberOfVertices);

	scanf("%d", &numberOfQueries);

	scanf("%d", &numberOfAddQ);

	scanf("%d", &numberOfMiinQ);

	scanf("%d", &numberOfMaxQ);

	int *edge = (int*) malloc(
			(numberOfVertices) * (numberOfVertices) * sizeof(int));

	memset(edge, 0, numberOfVertices * numberOfVertices * sizeof(int));
	int numberOfEdges = numberOfVertices * (numberOfVertices - 1) / 2;

	fprintf(ptr, "%d %d\n", numberOfVertices, numberOfEdges);

	for (long long i = 1; i <= numberOfEdges; i++) {
		int e1 = rand() % numberOfVertices;
		int e2 = rand() % numberOfVertices;
		while (edge[e1 * numberOfVertices + e2] == 1) {
			e1 = rand() % numberOfVertices;
			e2 = rand() % numberOfVertices;

		}
		fprintf(ptr, "%d %d\n", e1 + 1, e2 + 1);
		edge[e1 * numberOfVertices + e2] = 1;

	}

	for (int i = 0; i < numberOfVertices; i++) {
		int val = rand() % 1000;
		fprintf(ptr, "%d ", val);
	}
	fprintf(ptr, "\n");

	fprintf(ptr, "%d\n", numberOfQueries+1);

	while (numberOfQueries) {

		int q = rand() % 3;

		if (q == 1 && numberOfMiinQ) {
			fprintf(ptr, "1 ");
			for (int i = 0; i < numberOfVertices; i++) {
				int m = 0;
				while (m == 0)
					m = rand() % 1000;
				int val = rand() % m;
				fprintf(ptr, "%d ", val);
			}
			fprintf(ptr, "\n");
			numberOfMiinQ--;
			numberOfQueries--;
		}

		if (q == 2 && numberOfMaxQ) {
			fprintf(ptr, "2 ");
			for (int i = 0; i < numberOfVertices; i++) {
				int m = 0;
				while (m == 0)
					m = rand() % 1000;
				int val = rand() % m;
				fprintf(ptr, "%d ", val);
			}
			fprintf(ptr, "\n");
			numberOfMaxQ--;
			numberOfQueries--;
		}

		if (q == 0 && numberOfAddQ) {
			fprintf(ptr, "0 ");
			for (int i = 0; i < numberOfVertices; i++) {
				int m = 0;
				while (m == 0)
					m = rand() % 1000;
				int val = rand() % m;
				fprintf(ptr, "%d ", val);
			}
			fprintf(ptr, "\n");
			numberOfAddQ--;
			numberOfQueries--;
		}

	}

	fprintf(ptr, "3\n");
	numberOfPrintQ--;
	printf("\nCheck input.txt file\n");
	return 0;
}

