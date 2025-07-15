# Les instructions du *carry bit*

**Nouveaux fichiers :** `carry.h` `carry.c`

On s'attaque maintenant à la programmation des instructions du i8080. Pour chaque instruction du jeu d'instruction, on écrira dans le projet une fonction `void instr_XXX(Computer *comp)` où `XXX` est le nom de l'instruction programmée. Cette fonction mettra à jour `comp` en exécutant l'instruction `XXX`.

!!!warning "Et le *program counter* ?"
    Sauf mention du contraire, les fonctions `instr_XXX` ne s'occuperont pas de mettre à jour le registre *program counter* (PC).

Dans le manuel Intel, ces fonctions sont regroupées par catégories :

- Les instructions du *carry bit*
- Les instructions à registre unique : *single register*
- Les instructions de transfert de données : *data transfer*
- Les instructions *registre vers accumulateur*
- Les instructions de décalage : *rotate*
- Les instructions travaillant sur les *paires de registres*
- Les instructions *immédiates*
- Les instructions à *adressage direct*
- Les instructions de *sauts*, d'*appels de routines* et de *retour*
- Les instructions d'*entrées / sorties*
- Les *interruptions*

Je fais le choix de suivre le même regroupement (donc le plus souvent une unité de compilation pour chaque catégorie), ce qui vous permettra aussi de vous référer plus facilement à la section de manuel concernée, si besoin.

## 1. Instructions du *carry bit*

Ici, on fait référence au drapeau *carry* (CY) qui sert à indiquer une retenue dans un calcul.

Le processeur i8080 propose 2 instructions pour le manipuler :

- **STC** (*set carry*) : **set** le flag *CY*
- **CMC** (*complement carry*) : complémente le flag CY, c'est-à-dire que s'il vaut 0 alors on le **set**, s'il vaut 1 alors on le **reset**.

## 2. Implémentation

Ajoutez le fichier d'en-tête suivant dans votre projet :

```c title="carry.h"
#ifndef CARRY_H
#define CARRY_H

#include "computer.h"

extern void instr_cmc(Computer *comp);
extern void instr_stc(Computer *comp);

#endif
```

!!!example "Exercice"
    Écrire dans un nouveau fichier `carry.c` les des deux fonctions :

    1. `void instr_stc(Computer *comp)`
    2. `void instr_cmc(Computer *comp)`

    qui implémentent STC et CMC respectivement.

    NB : Il vous faudra déterminer les instructions `#include` à utiliser, je ne les indiquerai plus systématiquement.


!!!example "Exercice"
    1. Mettre à jour le `Makefile` avec la nouvelle unité `carry`.
    2. Ajouter dans `main.c` quelques tests unitaires.
    3. Re-compiler l'ensemble du projet.

Voilà ça fait 2 instructions de faites, plus que 73...


