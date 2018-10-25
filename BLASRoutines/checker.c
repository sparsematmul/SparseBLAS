#include "blas_sparse.h"
#include <stdio.h>
#include <conio.h>

int main()
{
	const int N = 4;
	const int nz = 6;
	double val[]={1.1,2.2,2.4,3.3,4.1,4.4};
	int indx[]={0,1,1,2,3,3};
	int jndx[]={0,1,3,2,0,3};
	double x[]={1.0,1.0,1.0,1.0};
	double y[]={0.0,0.0,0.0,0.0};
	
	blas_sparse_matrix A;
	int i;
	double alpha=1.0;
	
	A=BLAS_duscr_begin(N,N);
	
	for(i=0;i<nz;i++)
	BLAS_duscr_insert_entry(A,val[i],indx[i],jndx[i]);
	
	BLAS_uscr_end(A);
	
	BLAS_dusmv(blas_no_trans, alpha, A, x, 1, y, 1);
	
	BLAS_usds(A);
	return 0;
}
