# Les instructions à adressage direct 

**Nouveaux fichiers :** `direct.h` `direct.c`

Une instruction à *adressage direct* manipule une case mémoire dont l'adresse est donnée directement dans l'instruction elle même. C'est donc une instruction longue sur 3 octets :

- Le premier octet représente le code d'instruction (utilisé par le décodeur d'instructions)
- Le deuxième octet représente les 8 bits de poids faible de l'adresse concernée
- Le troisième octet reperésente les 8 bits de poids fort de l'adresse concernée

Il y a 4 instructions à adressage direct :

- **LDA** (*load accumlator direct*) et **STA** (*store accumulator direct*) : charge ou sauvegarde une donnée dans l'accumulateur
- **LHLD** (*load HL direct*) et **SHLD** (*store HL direct*) : charge ou sauvegarde une donnée dans la paire de registres HL

Par exemple :
```
Instruction : 00110010     10011001      11110000
              Code de STA  low_adr       high_adr

Interprétation : sauvegarder la valeur de l'accumulateur à l'adresse : 0b 11110000 10011001 = 0xF099
```

!!!bug "Attention"
    Attention à ne pas confondre avec **LDAX** et **STAX** que nous avons déjà définies dans `datatransfer`.

Pour les instructions **LHLD** et **SHLD**, lorsqu'on sauvegarde ou restaure depuis la mémoire à l'adresse *adr* (= high_adr.low_adr), on commence par traiter les bits de poids faibles (c'est-à-dire **L**) à l'adresse *adr*, puis les bits de poids forts (c'est-à-dire **H**) à l'adresse *adr+1*.

## 1. Implémentation

Tout cela se traduit par le fichier d'en-tête suivant :
```c title="direct.h"
#ifndef DIRECT_H
#define DIRECT_H

#include "computer.h"
#include <stdint.h>

extern void instr_lda(Computer *comp, uint8_t low_adr, uint8_t high_adr);
extern void instr_sta(Computer *comp, uint8_t low_adr, uint8_t high_adr);
extern void instr_lhld(Computer *comp, uint8_t low_adr, uint8_t high_adr);
extern void instr_shld(Computer *comp, uint8_t low_adr, uint8_t high_adr);

#endif
```

!!!example "Exercice"
    Dans un nouveau fichier **direct.c**, proposez une implémentation de ces 4 instructions.


!!!warning "Attention"
    Aucun flag n'est modifié par ces instructions.

