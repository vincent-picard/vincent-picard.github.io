# Les instructions de transfert

**Nouveaux fichiers :** `datatransfer.h` `datatransfer.c` `instr.h`

**Fichiers modifiés :** `computer.h` `computer.c`

Les instructions de transfert de données servent à copier une donnée sur 8 bits depuis un registre (ou la mémoire) vers un autre registre (ou la mémoire).

!!!note Remarque
    Les instructions de cette section ne modifient aucun flag.

## 1. L'instruction **MOV** (*move*)

L'instruction **MOV** est une instruction sur 1 octet qui a pour forme :
```
    01DDDSSS
```
Les trois bits `DDD` désignent la destination et les trois bits `SSS` désignent la source. Les sources et les destinations sont désignées selon les conventions suivantes :

| Source / Destination | Code |
| :-: | :-: |
| Registre B | `000` |
| Registre C | `001` |
| Registre D | `010` |
| Registre E | `011` |
| Registre H | `100` |
| Registre L | `101` |
| Mémoire    | `110` |
| Registre A | `111` |

Il y a donc possiblement 64 valeurs d'octet du langage machine qui correspondent à une instruction **MOV**, c'est d'ailleurs pourquoi le [tableau du jeu d'instructions](pastraiser.com/cpu/i8080/i8080_opcodes.html) est fourni en instructions **MOV**. Par exemple, l'instruction `0x6A = 0b 0110 1010 = 0b 01 110 010` correspond à lire la donnée située dans le registre D et à la copier (en écrasant) dans le registre L, ce que l'on notera plus précisément **MOV L,D**.

!!!bug "Attention"
    Il est interdit d'avoir MEM à la fois comme source et destination. Le code `0b01110110` est reservée pour une autre instruction (l'instruction HLT). Par contre tous les autres cas sont valides, même si la source et la destination sont les mêmes.

### Les paires de registres

Lorsque la source ou la destination est la mémoire, l'adresse mémoire concernée est celle indiquée par la paire de registres HL. Le registre H contient les 8 bits de poids fort de l'adresse (d'où son nom HIGH), tandis que le registre L contient les 8 bits de poids faible (d'où son nom LOW). Par exemple si H contient `0x4A` et L contient `0xB3`, l'adresse mémoire désignée est `0x4AB3`.

Ce processeur fonctionnera souvent ainsi, lorsqu'il veut représenter certaines valeurs sur 16 bits il utilise une paire de registres 8 bits pour la mémoriser. Les paires de registres utilisées sont :

- Paire de registres HL : registre H + registre L
- Paire de registres BC : registre B + registre C
- Paire de registres DE : registre D + registre E
- *Program status word* PSW : registre A + flags

Dans le dernier cas, `flags` désigne l'octet qui représente l'état des flags, dans le format que nous avons utilisé.

Pour nous faciliter le travail dans ce projet, nous écrivons dès à présent des petites fonctions pour lire la valeur 16 bit codée sur une paire de registres. Ajoutez les prototypes suivants à `computer.h`

```c title="computer.h"
extern uint16_t read_HL(Computer *comp);
extern uint16_t read_BC(Computer *comp);
extern uint16_t read_DE(Computer *comp);
extern uint16_t read_PSW(Computer *comp);
```

!!!example "Exercice"
    Implémentez ces quatre fonctions dans `computer.c`


### Implémentation de l'instruction 

Nous remarquons donc que contrairement aux instructions STC et CMC, nous avons cette fois besoin pour implémenter MOV de connaître l'octet de l'instruction en cours d'exécution afin d'en décoder la source et la destination. Il faudra adapter notre prototype de fonction dans ce sens.

Créer le fichier d'en-tête :
```c title="datatransfer.h"
#ifndef DATATRANSFER_H
#define DATATRANSFER_H

/* Exécute l'instruction MOV sur l'ordinateur comp.
 * instr est la valeur d'octet de l'instruction */
extern void instr_mov(Computer *comp, uint8_t instr);

#endif
```
Nous ne voulons surtout pas non plus écrire directement dans notre programme les valeurs de codes registres du tableau ci-dessus. Cela nuirait grandement à la lisibilité du programme et serait source d'erreurs. Nous allons plutôt définir des constantes dans un fichier `instr.h`. Ce fichier d'en-tête nous servira à définir toutes les constantes qui concernent le jeu d'instructions i8080.

```c title="instr.h"
#ifndef INSTR_H
#define INSTR_H

// Constantes pour désigner les registres ou la mémoire
#define REGB 0b000
#define REGC 0b001
#define REGD 0b010
#define REGE 0b011
#define REGH 0b100
#define REGL 0b101
#define MEM  0b110
#define REGA 0b111

#endif
```

!!!example "Exercice"
    Dans un nouveau fichier `datatransfer.c`, écrire l'implémentation de la fonction `instr_mov`. Je vous conseille de procéder ainsi :

    1. Décoder `instr` pour récupérer les codes de source et de destination.
    2. En distinguant selon le cas du code de source, lire la valeur à copier.
    3. En distinguant selon le cas du code de destination, écrire la valeur au bon emplacement.
    
    Il faudra aussi refuser le cas source = destination = MEM, par exemple avec un `assert`.


## 2. Les instructions **LDAX** (*load accumulator*) et **STAX** (*store accumulator*)

Comme leur nom l'indique, les instructions **LDAX** et **STAX** servent à charger ou sauvegarder la valeur de l'accumulateur (registre A) dans la mémoire. Ces instructions ont le format suivant :

```
LDAX : 000X1010
STAX : 000X0010
```

Lorsque `X` vaut 0, l'adresse mémoire concernée est donnée par la paire de registres BC, sinon lorsque `X` vaut 1, l'adresse mémoire concernée est donnée par la paire de registres DE.

Ajouter au fichier `datatransfer.h` les prototypes suivants :
```c title="datatransfer.h"
extern void instr_ldax(Computer *comp, uint8_t instr);
extern void instr_stax(Computer *comp, uint8_t instr);
```
Remarquer encore une fois que le paramètre `instr` est utilisé pour pouvoir récupérer la valeur de `X`.

!!!example "Exercice"
    Dans le fichier `datatransfer.c` implémentez les fonctions `instr_ldax` et `instr_stax`.

Je vais le dire une dernière fois (cela doit faire partie de votre boucle de travail) :

1. Mettre à jour le `Makefile` pour compiler `datatransfer.o`
2. Ajouter quelques tests dans `main.c`
3. Recompiler le projet et tester


