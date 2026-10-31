#include <stdio.h>
#include <assert.h>
#include <stdbool.h>

const int VIDE = 0;
const int A = 1;
const int B = 2;

void print_grille(int grille[6][7]) {
    for (int i = 0; i < 6; i++) {
        for (int j = 0; i < 7; j++) {
            if (grille[i][j] == VIDE) {
                printf(". ");
            } else if (grille[i][j] == A) {
                printf("o ");
            } else if (grille[i][j] == B) {
                printf("x ");
            } else {
                printf("? ");
            }
        }
        printf("\n");
    }
}

void init_grille(int grille[6][7]) {
    for (int i = 0; i < 6; i++)
        for (int j = 0; j < 7; j++)
            grille[i][j] = VIDE;
}

bool est_libre(int grille[6][7], int j) {
    assert(0 <= j && j < 7);

    return grille[0][j] == VIDE;
}

int coups_possibles(int grille[6][7], int res[8]) {
    int nb = 0; // nb de coups possibles
    for (int j = 0; j < 7; j++) {
        if (est_libre(grille, j)) {
            res[nb] = j;
            nb += 1;
        }
    }
    return nb;
}

int est_plein(int grille[6][7]) {
    int inutile[8];
    int n = coups_possibles(grille, inutile);
    return (n == 0);
}

void jouer 



int eval(int grille[6][7], int j, int p) {
    if (est_final(grille) || p == 0 || gagne(grille, A) || gagne(grille, B)) {
        return heuristique(grille);
    } else if (j == A) { // On cherche à maximiser
        e = -INF;
        int coups[8];
        int nb;
        nb = coups_possibles(grille, coups);
        for (int k = 0; k < nb; k += 1) {
            int grille2[6][7];
            copie(grille2, grille);
            jouer(grille2, j, coups[k]);
            int f = eval(grille2, B, p-1);
            if (f > e) {
                e = f;
            }
        }
        return e;
    } else { // CAS SYMETRIQUE
