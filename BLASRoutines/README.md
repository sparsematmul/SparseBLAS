#SparseBLAS

Sparse Matrix Multiplication through BLAS

We are trying to implement Sparse Matrix Multiplication with existing algorithms, like the Basic Linear Algebra SubPrograms (BLAS) that helps to run the codes.

We use the libraries obtained from BLAS at https://math.nist.gov/spblas/ and use the checker.c file to implement a simple matrix multiplication algorithm. The corresponding header and C files are present as follows. We then simulate it on SniperSim/McPAT to get the power readings on the Intel Gainestown architecture.

checker.c is used to implement a matrix-vector multiplication.

checker2.c is used to implement a matrix-matrix multiplication.

matrix_sparse.c is used to implement matrix-matrix multiplication but using a simple innitialization procedure.

The run-sniper.sh file is used to calculate the power patterns in the Gainestown architecture as set up.
