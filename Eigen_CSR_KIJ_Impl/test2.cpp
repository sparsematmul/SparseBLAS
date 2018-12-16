#include <iostream>
#include <Eigen/Sparse>
#include <vector>
#include <sim_api.h>
#include <fstream>
#include <ctime>
#include <stdio.h>

int main() {

   int n = 261;
   int row, col;
   double val;

   Eigen::SparseMatrix<double> mat(n,n);
   Eigen::SparseMatrix<double> mat1(n,n);
   
   mat.reserve(Eigen::VectorXi::Constant(n,2));
   std::ifstream rowfile("row_261.txt");
   std::ifstream colfile("col_261.txt");
   std::ifstream valfile("val_261.txt");

   if (rowfile.is_open() && colfile.is_open() && valfile.is_open()) {
      while (rowfile >> row) {
         colfile >> col;
         valfile >> val;
         mat.insert(row,col) = val;         
      }
   }
   rowfile.close();
   colfile.close();
   valfile.close();
   
   //for(int i=0; i<1000; i++) {
   //    mat.insert(100, i) = 5;
   //}   
   mat.makeCompressed();
   SimRoiStart();

   double start_clock = clock();

   mat1 = mat * mat;

   double end_clock = clock();
   printf("%.10f second(s)\n", (end_clock-start_clock)/CLOCKS_PER_SEC);

   SimRoiEnd();
}
