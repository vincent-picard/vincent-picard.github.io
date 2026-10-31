#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

const int VIDE = 0;
const int A = 1;
const int B = 2;

void initialiser_grille(int g[6][7]) {
    for (int i = 0; i < 6; i += 1) {
        for (int j = 0; j < 7; j += 1) {
            g[i][j] = VIDE;
        }
    }
}

void copy_grille(int src[6][7], int dest[6][7]) {
   for (int i = 0; i < 6; i += 1) {
      for (int j = 0; j < 7; j += 1) {
         dest[i][j] = src[i][j];
      }
   }
}

void print_grille(int g[6][7]) {
    for (int i = 0; i < 6; i += 1) {
        for (int j = 0; j < 7; j += 1) {
            if (g[i][j] == VIDE) {
                printf(". ");
            } else if (g[i][j] == A) {
                printf("o ");
            } else if (g[i][j] == B) {
                printf("x ");
            } else {
                printf("?");
            }
        }
        printf("\n");
    }
    printf("-------------\n");
    for (int j = 0; j < 7; j += 1) {
        printf("%d ", j);
    }
    printf("\n");
}

int main() {
    int grille[6][7];
    initialiser_grille(grille);
    grille[5][2] = A;
    grille[5][3] = B;
    print_grille(grille);

    return EXIT_SUCCESS;
}


