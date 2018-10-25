#include <stdio.h>
#include <math.h>
#include <time.h>
#define N_MAX 216


int A[N_MAX][N_MAX], B[N_MAX][N_MAX], C[N_MAX][N_MAX];
int min(int,int);
int prime(int);

int main()
{
	double msec=0.0;
  int i,j,k,t=4,i1,j1,k1;
  /* tile size=4*/
  /*printf("Initializing...\n");*/
  for (i=0; i<N_MAX; i++)
     for (j=0; j<N_MAX; j++)
        {
          A[i][j] =prime(i + j);
          B[i][j] =prime(i - j);
        }
 
  clock_t before=clock();
  for (i1=0; i1<N_MAX; i1+=t)
   {
     /*printf("Computing line %d\n", i);*/
     for (j1=0; j1<N_MAX; j1+=t)
        {
          
          for (k1=0; k1<N_MAX; k1+=t)
	  {
            for(i=i1;i<min(i1+t,N_MAX);i++)
	    {
		for(j=j1;j<min(j1+t,N_MAX);j++)
		{
		  
		   for(k=k1;k<min(k1+t,N_MAX);k++) /*tiling using sizes of 4x4*/
			C[i][j]+=A[i][k]*B[k][j];
		}
             }
  	  }
	}
	}
	clock_t after=clock()-before;
	msec=after*1000.0/CLOCKS_PER_SEC;
	
	printf("%.10f ",msec);
 

  return 0;
}

int min(int a,int b)
{
	return a<b?a:b;
}
int prime(int a)
{
int f=0,i;
for(i=1;i<=a;i++)
{
if(a%i==0)
f++;
}
if(f==2)
return a;
else
return 0;
}


