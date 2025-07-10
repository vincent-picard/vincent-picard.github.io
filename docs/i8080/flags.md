# Les flags

Dans la section précédente, nous avons expliqué que le processeur garde en mémoire 5 états binaires appelés flags. Ces flags sont :

- *Sign (S)* : signe
- *Zero (Z)* : zéro
- *Auxiliary carry (AC)* : retenue auxiliaire
- *Parity (P)* : parité
- *Carry (CY)* : retenue

Chaque flag possède une valeur binaire 0 ou 1. Selon la terminologie Intel, l'opération **set** sur un flag consiste à mettre sa valeur à 1, tandis que l'opération **reset** consiste à mettre sa valeur à 0. Nous allons implémenter ici ces opérations ce qui nous permettra de nous familiariser en douceur avec les opérations bit à bit.

Dans notre implémentation, nous avons décidé d'enregistrer la valeur de ces 5 flags dans un seul octet (champ `flag` de la structure `Cpu`). Les bits de cet octet seront définis selon le format suivant :

| 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
| :-: |  :-: |  :-: |  :-: |  :-: |  :-: |  :-: |  :-: | 
| S | Z | 0 | AC | 0 | P | 1 | CY |

Noter que les bits 1, 3 et 5 seront toujours fixés à des valeurs précises (1, 0 et 0 respectivement). Pourquoi ce format ? Tout simplement car certaines opérations du processeur permettent de lire l'ensemble des flags sous forme d'un octet avec ce format précisément. En adoptant la même convention que le processeur, on s'économise du travail par la suite. 

!!!example "Exercice (à faire !)"
    Compléter la fonction `comp_init` définie à la partie précédente pour qu'elle initialise correctement la valeur de `flags`. On considérera qu'initialement tous les flags sont à la valeur 0.


## 1. Fonctions d'accès aux flags

Nous allons maintenant programmer les fonctions **set** et **reset** qui permettent la manipulation des flags, ainsi qu'une opération **get** qui nous permet de lire la valeur d'un flag.

Nous programmons les fonctions qui concernent les flags, dans une unité de compilation spécifique. On créé donc le fichier `flags.h` que je donne dans son intégralité :

???example "Fichier d'en-tête `flags.h`"
    ```c title="flags.h"
    #ifndef FLAGS_H
    #define FLAGS_H

    #include <stdbool.h>
    #include "computer.h"

    /* Format du pseudo-registre flags :
     * S Z 0 AC 0 P 1 CY
     *
     * S = Sign
     * Z = Zero
     * AC = Auxiliary carry
     * P = Parity
     * CY = Carry
     */

    /* Fonction d'accès aux flags */

    extern void set_flag_s(Computer *comp);
    extern void reset_flag_s(Computer *comp);
    extern bool get_flag_s(Computer *comp);

    extern void set_flag_z(Computer *comp);
    extern void reset_flag_z(Computer *comp);
    extern bool get_flag_z(Computer *comp);

    extern void set_flag_ac(Computer *comp);
    extern void reset_flag_ac(Computer *comp);
    extern bool get_flag_ac(Computer *comp);

    extern void set_flag_p(Computer *comp);
    extern void reset_flag_p(Computer *comp);
    extern bool get_flag_p(Computer *comp);

    extern void set_flag_cy(Computer *comp);
    extern void reset_flag_cy(Computer *comp);
    extern bool get_flag_cy(Computer *comp);

    /* Fonctions pratiques pour définir correctement
     * les flags S, Z, et P */

    extern void update_flag_s(Computer *comp, uint8_t val);
    extern void update_flag_z(Computer *comp, uint8_t val);
    extern void update_flag_p(Computer *comp, uint8_t val);
    extern void update_flags_szp(Computer *comp, uint8_t val);

    #endif

    ```

Implémentons maintenant ensemble les fonctions **set**, **reset** et **get** pour le flag AC (*auxiliary carry*) :

```c title="flags.c"
#include <stdbool.h>
#include "computer.h"

void set_flag_ac(Computer *comp) {
    comp->cpu.flags = comp->cpu.flags | 0b00010000;
}

void reset_flag_ac(Computer *comp) {
    comp->cpu.flags = comp->cpu.flags & 0b11101111;
}

bool get_flag_ac(Computer *comp) {
    return ((comp->cpu.flags & 0b00010000) > 0);
}

```
Comprenez-vous ce code ? Pour **set** le flag AC, j'ai utilisé un OU bit à bit. Comme la valeur `0b00010000` contient un 1 au bit 4, et que x OU 1 vaut toujours 1, le bit 4 aura pour valeur 1 dans le résultat. C'est parfait car cela correspond au bit pour coder AC. Comme 0 est neutre pour le OU cela ne change pas les autres bits de `flags`.

Pour le **reset** j'ai utilisé une logique similaire mais cette fois-ci j'utilise un ET bit à bit.

Enfin pour le **get**, j'utilise un masque binaire pour observer uniquement le bit d'intéret et je teste si le résultat est nul ou non.

!!!example "Exercice"
    En suivant la même méthode, implémenter les fonctions d'accès aux autres flags : S, Z, P et CY

!!!info "Remarque"
    Comme les opérations bit à bit se font à coût constant $O(1)$, toutes les opérations **set**, **reset** et **get** définies ainsi auront aussi un coût constant.

## 2. Mise à jour des flags

Nous allons maintenant nous intéresser à la signification précise des flags Z, S et P.

### A. Le flag *zero* (Z)

Lorsque le processeur exécute certaines instructions, si le résultat du calcul est 0 alors le flag Z est **set**, sinon il est **reset**. Pour mettre à jour le flag zero en fonction d'une *valeur* (`val`) de résultat de calcul on ajoute donc la fonction suivante dans `flags.c` :

```c title="flags.c"
(...)

void update_flag_z(Computer *comp, uint8_t val) {
    if (val == 0) {
        set_flag_z(comp);
    } else {
        reset_flag_z(comp);
    }
}
```

### B. Le flag *sign* (S)

Le flag sign fait référence au bit de signe dans la représentation par complément à 2. En effet, vous savez qu'une valeur sur 8-bit peut être utilisée pour coder un entier signé représentant une valeur entre $-128$ et $127$ à l'aide de la méthode du complément à 2.

!!!abstract "Rappel sur le complément à 2"
    Pour coder une valeur $x$ comprise entre $-128$ et $127$ sur un octet.

    - **Si x est positif ou nul** : on le code normalement : par exemple $x = 70 = 64 + 4 + 2$ sera codé `0b01000110`

    - **Si x est strictement négatif** : par exemple $x = -3$, on commence par coder 3 normalement (`0b00000011`), puis on inverse les bits (`0b11111100`), enfin on ajoute 1 au résultat et on obtient `0b11111101`

    Cette représentation, permet d'utiliser les mêmes circuits que l'addition pour calculer une soustraction. En effet, pour calculer $70 - 3$, on calcule simplement $70 + (-3)$, ce qui fonctionne avec cette représentation : `0b01000110 + 0b11111101 = 0b01000011` qui vaut bien 67 !

    De plus on remarque que dans le premier cas ($x \geq 0$), le bit de poids fort (bit 7) vaut toujours 0, et dans le second cas ($x < 0$) il vaut toujours 1. Cet bit est donc appelé **bit de signe**, il permet immédiatement de savoir si la valeur signée codée est positive ou négative. 

Pour résumer, le flag S doit être **reset** si le bit de poids fort du résultat est 0 et il doit être **set** si le bit de poids de fort est 1.

!!!example "Exercice"
    Écrire l'implémentation de la fonction `update_flag_s`

### C. Le flag *parity* (P)

Le flag *parity* (P) est **set** s'il y a un nombre pair de bits ayant pour valeur 1 dans le résultat, sinon il **reset**. Par exemple si la valeur du résultat est 5 qui se code `0b00000101` en binaire, parity vaudra 1 car il y a 2 bit 1 dans le résultat.

!!!bug "Piège"
    Attention, le nom du flag est trompeur. **Ce flag ne teste pas si le résultat d'un calcul est pair**.

!!!example "Exercice"
    Écrire l'implémentation de la fonction `update_flag_p`

!!!example "Exercice"
    Écrire l'implémentation de la fonction `update_flag_szp` qui met à jour simultanément les flags S, Z et P en fonction d'un résultat de calcul.

### D. Les autres

Les autres flags (CY et AC) sont des bits de retenues utilisés dans les calculs d'addition et de soustraction. Nous les verrons à ce moment là.
