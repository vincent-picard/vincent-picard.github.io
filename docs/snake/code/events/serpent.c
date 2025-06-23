#include "serpent.h"
#include <assert.h>
#include <stdlib.h>

int prochain_x(const Serpent* s) {
    assert (s != NULL);    
    int x_act = s->tete->x;
    switch (s->direction) {
        case LEFT:
            return x_act-1;
        case RIGHT:
            return x_act+1;
        default:
            return x_act;
    }
}

int prochain_y(const Serpent* s) {
    assert (s != NULL);
    int y_act = s->tete->y;
    switch (s->direction) {
        case UP:
            return y_act-1;
        case DOWN:
            return y_act+1;
        default:
            return y_act;
    }
}

Serpent* creer_serpent(int x, int y, int dir) {
    Maillon *m = malloc(sizeof(Maillon));
    m->x = x;
    m->y = y;
    m->suivant = NULL;

    Serpent *s = malloc(sizeof(Serpent));
    s->tete = m;
    s->queue = m;
    s->direction = dir;

    return s;
}

bool appartient(const Serpent* s, int x, int y) {
    Maillon* actuel = s->queue;
    while (actuel != NULL) {
        if (actuel->x == x && actuel->y == y) {
            return true;
        }
        actuel = actuel->suivant;
    }
    return false;
}

void avancer(Serpent *s) {
    int x = prochain_x(s);
    int y = prochain_y(s);

    /* ajouter le nouveau maillon de tete */
    Maillon *m = malloc(sizeof(Maillon));
    m->x = x;
    m->y = y;
    m->suivant = NULL;

    s->tete->suivant = m;
    s->tete = m;

    /* supprimer le premier maillon */
    Maillon *deuxieme = s->queue->suivant;
    free(s->queue);
    s->queue = deuxieme;
    /* rmq : avec cet ordre, cela marche
     * pour la liste de taille 1 aussi */
}

void grandir(Serpent *s) {
    int x = prochain_x(s);
    int y = prochain_y(s);

    /* ajouter le nouveau maillon de tete */
    Maillon *m = malloc(sizeof(Maillon));
    m->x = x;
    m->y = y;
    m->suivant = NULL;

    s->tete->suivant = m;
    s->tete = m;
}

void place_serpent(const Serpent *s, Arena mat) {
    Maillon *actuel = s->queue;
    while (actuel != NULL) {
        mat[actuel->x][actuel->y] = SNAKE;
        actuel = actuel -> suivant;
    }
}

void destroy_serpent(Serpent *s) {
    Maillon *actuel = s->queue;
    while (actuel != NULL) {
        Maillon *suivant = actuel->suivant;
        free(actuel);
        actuel = suivant;
    }
    free(s);
}

