#include <stdio.h>
#include <time.h>
#include <stdlib.h>

void echanger(int t[], int a, int b) {
    int tmp = t[a];
    t[a] = t[b];
    t[b] = tmp;
}

//Pivote le sous-tableau t[a:b] avec p le choix d'indice de pivot
//Retourne la position finale du pivot
//
int pivoter(int t[], int a, int b, int p) {
    echanger(t, a, p); // On place le pivot au début
    int q = a; // position actuelle du pivot
    for (int k = a; k <= b; k += 1) {
        if (t[k] < t[q]) {
            echanger(t, k, q+1);
            echanger(t, q, q+1);
            q += 1;
        }
    }
    return q;
}

// Retourne la k-ième plus grande valeur du sous-tableau t[a:b]
// Attention : modifie le tableau
int quickselect(int t[], int a, int b, int k) {
   int p = a + rand() % (b - a + 1);
   fprintf(stderr, "Pivot choisi en pos %d\n", p);
   p = pivoter(t, a, b, p);
   if (p == a + k-1) {
       return t[p];
   } else if (p > a + k-1) {
       return quickselect(t, a, p-1, k);
   } else {
       return quickselect(t, p+1, b, k - (p - a + 1));
   }
}

int main() {
    srand(time(NULL));
    int t[] = {5, 8, 3, 11, 4, 9, 1, 2, 10, 6, 7};
    printf("Valeur mediane %d\n", quickselect(t, 0, 10, 6));
}

