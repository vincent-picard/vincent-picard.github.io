# Les instructions immédiates

**Nouveaux fichiers :** `immediate.h` `immediate.c`

**Fichiers modifiés :** `instr.h`


Les instructions immédiates sont des instructions qui réalisent leur tache en traitant des données codées dans l'instruction elle-même. Ces données sont donc *immédiatement* disponibles. Typiquement, ce sont des instructions sur 2 ou 3 octets : le premier octet décrit l'opération à effectuer et l'octet ou les octets suivants sont les données à traiter.

Parmi ces instructions, on trouve :

- **LXI** (*load register pair immediate*) sur 3 octets : permet de charger une valeur 16-bit dans une paire de registre. Le premier octet indique que l'opération est **LXI** et donne la paire de registres. Les deux autres octets sont la valeur à charger.
- **MVI** (*move immediate data *) sur 2 octets : permet de charger une valeur dans un registre ou dans la mémoire. Le premier octet indique que l'opération est **MVI** et précise le registre. Le second octet est la valeur à charger.
- Les opérations arithmétiques et logiques (**ADI**, **ACI**, **SUI**, **SBI**, **ANI**, **ORI**, **XRI**, **CPI**), sur deux octets : le premier octet décrit l'opération à effectuer, le second octet décrit la valeur à utiliser. Par exemple **ADI** ajoute la valeur donnée à l'accumulateur (c'est l'équivalent d'un `+=` en C).

Bien sûr, pour implémenter les opérations arithmétiques et logiques, nous nous servirons de nos fonctions `op_XXX` codées dans l'unité `alu`. Cela permettra également de mettre à jour correctement les flags.

On ajoute le fichier d'en-tête suivant :
```c title="immediate.c"
#ifndef IMMEDIATE_H
#define IMMEDIATE_H

#include "computer.h"
#include <stdint.h>

void instr_lxi(Computer *comp, uint8_t instr, uint8_t low_data, uint8_t high_data);
void instr_mvi(Computer *comp, uint8_t instr, uint8_t data);
void instr_adi(Computer *comp, uint8_t data);
void instr_aci(Computer *comp, uint8_t data);
void instr_sui(Computer *comp, uint8_t data);
void instr_sbi(Computer *comp, uint8_t data);
void instr_ani(Computer *comp, uint8_t data);
void instr_ori(Computer *comp, uint8_t data);
void instr_xri(Computer *comp, uint8_t data);
void instr_cpi(Computer *comp, uint8_t data);

#endif

```

## 1. Instruction **LXI**

L'instruction **LXI** est codée sur trois octets, sert à enregistrer une valeur donnée dans une paire de registres. Elle a le format suivant :
```
00RR0001    low_data(8 bits)    high_data(8 bits)
```
où les deux bits `RR` servent à préciser la paire de registre avec les conventions suivantes :

| `RR` | Paire de registres (ou registre) |
| :-: | :-: |
| `00` | BC |
| `01` | DE |
| `10` | HL |
| `11` | SP |

Remarquer que dans le dernier cas, il ne s'agit pas d'une paire de registres mais simplement du registre **SP** (*Stack pointer*). En effet, rappelez-vous que c'est un des deux seuls registres 16-bits du processeur et qu'il faut donc lui fournir une donnée sur 16 bits.

Pour éviter d'écrire à la main dans le code ces constantes arbitraire, nous allons proprement ajouter les constantes adéquates dans le fichier `instr.h` existant :

```c title="instr.h"
// Constantes pour les paires de registres 

#define PAIR_BC 0b00
#define PAIR_DE 0b01
#define PAIR_HL 0b10
#define PAIR_SP Ob11
```

Enfin concernant la donnée 16 bits à enregistrer dans la paire de registres (ou SP), elle est codée sur les 2 octets `low_data` et `high_data`. `low_data` représente les 8 bits de poids faible de la valeur et `high_data` les 8 bits de poids fort.

!!!example "Exercice"
    Dans un nouveau fichier `immediate.c`, implémenter la fonction `instr_lxi`. Pour cela il faudra :

    1. Décoder l'argument `instr` pour déterminer la paire de registre (ou SP) à modifier
    2. Enregistrer la valeur donnée par `low_data` et `high_data` dans la paire de registres désignée (ou SP)

    Remarquer que dans le cas de SP, il sera nécessaire de reformer un entier 16 bits à partir des deux entiers 8 bits donnés.

## 2. Instruction **MVI**

L'instruction **MVI** est comparable à l'instruction **LXI** sauf qu'elle enregistre une valeur sur 8 bits au lieu d'une valeur sur 16 bits. Elle a pour forme :
```
00RRR110    data(8 bits)
```
Dans le premier octet, `RRR` désigne le registre à modifier avec exactement les mêmes conventions que pour [l'instruction `MOV`](../datatransfer/#1-linstruction-mov-move) déjà traitée. On rappelle tout de même les conventions :

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

Dans le cas de la valeur `110`, la donnée ne sera pas enregistrée dans un registre mais dans la mémoire de l'ordinateur. L'adresse mémoire à utiliser sera alors celle précisée par la paire de registres HL.

Nous rappelons également que toutes ces constantes sont déjà définies dans `instr.h` (`REGA`, ..., `REGL`, `MEM`).

La donnée à enregistrer est tout simplement le second octet (`data`) de l'instruction.

!!!example "Exercice"
    Dans le fichier `immediate.c`, implémenter la fonction `instr_mvi`. Pour cela il faudra :

    1. Décoder l'argument `instr` pour déterminer le registre à modifier
    2. Dans le cas de `MEM` : récupérer l'adresse stockée dans HL.
    3. Enregistrer la valeur `data` au bon endroit.

## 3. Les instructions arithmétiques et logiques immédiates

Ce sont des instructions sur 2 octets ayant pour format :
```
code instruction(8 bits)    data(8 bits)
```
Le code d'instruction ne contient aucune donnée donc nous n'auront pas besoin de le manipuler ici. Il sert simplement à décrire l'opération à effectuer.
Toutes ces opérations *s'accumulent* dans le registre A (d'où son nom). Par exemple, **ADI** ajoute la valeur *data* dans le registre A. Ce sera donc le seul registre modifié par les opérations ci-dessous.

Décrivons maintenant chacune des opérations. Dans le tableau ci-dessous je note $d$ la valeur sur 8 bits à manipuler et $A$ le registre A.

| Instruction | Effet | Description |
| :-: | :-: | :- |
| **ADI** | $A \gets A + d$ | Ajoute $d$ dans l'accumulateur |
| **ACI** | $A \gets A + d + 1$ | Ajoute $d$ dans l'accumulateur avec une retenue d'entrée |
| **SUI** | $A \gets A - d$ | Soustrait $d$ de l'accumulateur |
| **SBI** | $A \gets A - d - 1$ | Soustrait $d$ de l'accumulateur avec une retenue d'entrée (emprunt) |
| **ANI** | $A \gets A \text{ AND } d$ | Réalise le ET bit à bit de $A$ et $d$|
| **ORI** | $A \gets A \text{ OR } d$ | Réalise le OU bit à bit de $A$ et $d$|
| **XRI** | $A \gets A \text{ XOR } d$ | Réalise le OU exclusif bit à bit de $A$ et $d$|
| **CPI** | $\varnothing \gets A - d$ | Réalise en interne la soustraction de $A$ par $d$ sans changer $A$ (permet de comparer) |

La dernière opération mérite une explication. Lorsqu'on exécute `CPI d` aucun registre n'est modifié, cependant l'opération $A - d$ est réalisée
en interne et **les drapeaux sont modifiés** par cette soustraction. On peut alors regarder ensuite :

- Le flag **Z** (*Zero*) : s'il est **set** les deux valeurs sont égales, s'il est **reset** elles sont différentes
- Le flag **CY** (*Carry*) : s'il est **set** c'est que $d > A$, s'il est **reset** c'est que $d \leq A$.

On comprend maintenant le but de cette opération qui est de comparer deux valeurs.

!!!bug "Attention"
    Ce n'est plus à vous de modifier les flags ici, ils se modifieront automatiquement par l'appel à la fonction `op_sub`

!!!example "Exercice"
    Implémenter dans `immediate.c` les instructions `instr_adi`, `instr_aci`, ..., `instr_cpi`. Pour cela :

    - Chaque instruction fera **un seul appel** à l'une des fonctions `op_XXX` de l'unité `alu`. Il faudra utiliser correctement les paramètres *carry* et *borrow* de `op_add` et `op_sub`
    - Enregistrer le résultat dans le registre A (sauf pour `CPI` bien sûr)

!!!warning "Remarque"
    Les appels de fonction `op_XXX` mettront correctement les drapeaux à jour, on n'a pas à s'en préoccuper ici.


