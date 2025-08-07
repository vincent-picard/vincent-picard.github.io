# Les instructions registre vers accumulateur

**Nouveaux fichiers :** `regtoacc.h` `regtoacc.c`

Les instructions registre vers accumulateur sont similaires aux instructions arithmétiques et logiques immédiates. La différence est que la donnée à utiliser est cette fois localisée dans un registre (ou la mémoire). Les opérations sont les mêmes.

## 1. Descrition des instructions

Les instructions de cette section mesurent un seul octet qui a pour forme :
```
01XXXRRR
```
où `XXX` est un code désignant le type d'opération (inutile dans cette section du tutoriel) et `RRR` est le code précisant le registre (ou la mémoire) dans lequel on lit la donnée. On utilise les conventions habituelles déjà définies dans `instr.h` à savoir :

| Registre (ou mémoire) | Code |
| :-: | :-: |
| Registre B | `000` |
| Registre C | `001` |
| Registre D | `010` |
| Registre E | `011` |
| Registre H | `100` |
| Registre L | `101` |
| Mémoire    | `110` |
| Registre A | `111` |

Dans le cas de la valeur `110`, la donnée ne sera pas lue depuis un registre mais depuis la mémoire de l'ordinateur. L'adresse mémoire à utiliser sera alors celle précisée par la paire de registres HL.

Voici la liste des 8 instructions *registre vers accumulateur* et leur description. On constate que ce sont les mêmes opérations que les opérations immédiates sauf que la donnée $d$ est celle lue depuis le registre source (ou la mémoire).

| Instruction | Effet | Description |
| :-: | :-: | :- |
| **ADD** | $A \gets A + d$ | Ajoute $d$ dans l'accumulateur |
| **ADC** | $A \gets A + d + 1$ | Ajoute $d$ dans l'accumulateur avec une retenue d'entrée |
| **SUB** | $A \gets A - d$ | Soustrait $d$ de l'accumulateur |
| **SBB** | $A \gets A - d - 1$ | Soustrait $d$ de l'accumulateur avec une retenue d'entrée (emprunt) |
| **ANA** | $A \gets A \text{ AND } d$ | Réalise le ET bit à bit de $A$ et $d$|
| **ORA** | $A \gets A \text{ OR } d$ | Réalise le OU bit à bit de $A$ et $d$|
| **XRA** | $A \gets A \text{ XOR } d$ | Réalise le OU exclusif bit à bit de $A$ et $d$|
| **CMP** | $\varnothing \gets A - d$ | Réalise en interne la soustraction de $A$ par $d$ sans changer $A$ (permet de comparer) |

Ainsi **CMP** permet de comparer l'accumulateur avec n'importe quel autre registre (ou la mémoire). Il s'utilise comme **CPI**.

## 2. Implémentation

Pour l'implémentation on ajoute le fichier d'en-tête suivant :
```c title="regtoacc.c"
#ifndef REGTOACC_H
#define REGTOACC_H

#include "computer.h"
#include <stdint.h>

void instr_add(Computer *comp, uint8_t instr);
void instr_adc(Computer *comp, uint8_t instr);
void instr_sub(Computer *comp, uint8_t instr);
void instr_sbb(Computer *comp, uint8_t instr);
void instr_ana(Computer *comp, uint8_t instr);
void instr_ora(Computer *comp, uint8_t instr);
void instr_xra(Computer *comp, uint8_t instr);
void instr_cmp(Computer *comp, uint8_t instr);

#endif

```
Remarquons que contrairement aux instructions immédiates, nous avons ajouté le paramètre `instr` qui est nécessaire pour décoder le registre source (ou la mémoire).

!!!example "Exercice"
    Implémenter dans un nouveau fichier `regtoacc.c` les instructions `instr_add`, `instr_adc`, ..., `instr_cmp`. Pour cela :

    - Commencer par décoder `instr` pour déterminer la donnée $d$ à utiliser
    - Chaque instruction fera **un seul appel** à l'une des fonctions `op_XXX` de l'unité `alu`. Il faudra utiliser correctement les paramètres *carry* et *borrow* de `op_add` et `op_sub`
    - Enregistrer le résultat dans le registre A (sauf pour `CMP` bien sûr)

!!!warning "Remarque"
    Les appels de fonction `op_XXX` mettront correctement les drapeaux à jour, on n'a pas à s'en préoccuper ici.


