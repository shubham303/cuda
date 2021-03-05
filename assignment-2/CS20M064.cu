#include<stdio.h>
#include<cuda.h>

#define N 10000

void addition(int *graph, int v){

}
int main(){
	int v, e;

	scanf("%d %d", &v, &e);
	int graph[v*v]={0};


	int a,b;
	for(int i=0;i<e;i++){
		scanf("%d, %d", &a, &b);
		graph[(a-1)*v+(b-1)]=1;
	}

	for(int i=0;i<v;i++){
		scanf("%d",&a);
		graph[i*v+i]=a;
	}

	int q;
	scanf("%d", &q);

	while(q>0){
		q--;
		scanf("%d",&a);
		if(a==0){
			addition(graph,v);
		}
		if(a==1){
			minimum(graph,v);
		}
		if(a==2){
			maximum(graph,v);
		}
		if(a==3){
			enumerate(graph,v);
		}
	}
}
