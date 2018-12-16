#include <stdio.h>
#include <iostream>
#include <sim_api.h>
#include <fstream>
#include <cstring>

int main() {
   int n = 261;
   int row, col;
   double val;

   double mat[n][n];
   double res[n][n];
   std::memset(mat, 0, sizeof(mat[0][0] * n * n));
   std::memset(res, 0, sizeof(res[0][0] * n * n));
   std::ifstream rowfile("row_261.txt");
   std::ifstream colfile("col_261.txt");
   std::ifstream valfile("val_261.txt");

   if (rowfile.is_open() && colfile.is_open() && valfile.is_open()) {
      while (rowfile >> row) {
         colfile >> col;
         valfile >> val;
         mat[row][col] = val;         
      }
   }

   rowfile.close();
   colfile.close();
   valfile.close();

   double r;

   SimRoiStart();


   double start_clock = clock();

   for (int k=0; k<n; k++) {
      for (int i=0; i<n; i++) { 
         r = mat[i][k];
         for (int j=0; j<n; j++)
            res[i][j] += r * mat[k][j];
      }
   }

   double end_clock = clock();
   printf("%.10f second(s)\n", (end_clock-start_clock)/CLOCKS_PER_SEC);


   SimRoiEnd();
}
