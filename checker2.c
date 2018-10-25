#include "blas_sparse.h"
#include <stdio.h>
#include <sim_api.h>

double val[100],val2[100];
int indx1[100],jndx1[100],indx2[100],jndx2[100];
double B[100];
double prime(int);
int main()
{
	const int N = 128;
	/*const int nz;*/
	int i,j,k=0,l=0;
	for(i=0;i<N;i++)
	{
	for(j=0;j<N;j++)
	{
		if(prime(i+j))
		{
		val[k]=prime(i+j);
		indx1[k]=i;
		jndx1[k]=j;
		k++;
		}
	}
	}
	for(i=0;i<N;i++)
	{
	for(j=0;j<N;j++)
	{
		if(prime(i-j))
		{
		B[l]=prime(i-j);
		indx2[l]=i;
		jndx2[l]=j;
		l++;
		}
	}
	}
	
	blas_sparse_matrix A;
	double alpha=1.0;
	double c[128];
	for(i=0;i<128;i++)
	c[i]=1.0;
	
	A=BLAS_duscr_begin(N,N);
	
	for(i=0;i<k;i++)
	BLAS_duscr_insert_entry(A,val[i],indx1[i],jndx1[i]);;
	
	/*BLAS_uscr_end(A);*/
	SimRoiStart();
	BLAS_dusmm(128,blas_no_trans,1, alpha, A, B, 1,c,1);
	SimRoiEnd();
	BLAS_usds(A);
	return 0;
}
double prime(int a)
{
int flag=0,i;
for(i=0;i<a;i++)
{
if(a%i==0)
flag++;
}
if(flag==2)
return (double)a;
else
return 0.0;
}
