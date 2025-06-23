#ifndef SERPENT_H
#define SERPENT_H

#include <stdbool.h>
#include "main.h"

struct maillon_s {
    /* Coordonnées du bloc */
    int x;
    int y;

    /* Maillon suivant (de la queue vers la tête) */
    struct maillon_s *suivant;
};
typedef struct maillon_s Maillon;

/* Sens de déplacement */
#define RIGHT 0
#define UP 1
#define DOWN 2
#define LEFT 3

struct serpent_s {
    Maillon *queue; /* Premier maillon : fin du serpent */
    Maillon *tete; /* Dernier maillon : tête du serpent */
    int direction; /* Sens de déplacement */
};
typedef struct serpent_s Serpent;

/* Coordonnées du bloc vers lequel va le serpent */
extern int prochain_x(const Serpent *s);
extern int prochain_y(const Serpent *s);

/* Teste si la case est occupée par le serpent */
extern bool appartient(const Serpent *s, int x, int y);

/* Fait avancer le serpent */
extern void avancer(Serpent *s);

/* Fait grandir le serpent */
extern void grandir(Serpent *s);

/* Créer un serpent de longueur 1 positionné en (x, y) et
   se déplacant dans la direction dir */
Serpent *creer_serpent(int x, int y, int dir);

/* Marque dans l'arene mat les cases occupees par le serpent */
extern void place_serpent(const Serpent *s, Arena mat);

#endif
