# Makefile et tests unitaires

**Fichiers :** `Makefile` `main.c`

Le projet avance bien et comporte déjà plusieurs fichiers source. Le projet final en comportera bien davantage, il est donc temps de regrouper tous les fichiers `computer.c`, `computer.h`, `flags.h`, `flags.c` dans un même répertoire (si ce n'est pas déjà fait) et d'y ajouter un fichier nommé `Makefile`. Le but de ce fichier est de permettre à un outil nommé `make` de réaliser en une seule commande la compilation ou la re-compilation du projet.

## 1. Le fichier Makefile

Je vous donne une version de base du fichier `Makefile`, à placer dans votre répertoire :

```make title="Makefile"
# Nom du compilateur
CC=gcc
# Options du compilateur
CFLAGS= -Wall -O2

# Liste des unités de compilation :
OBJ= computer.o flags.o

.PHONY: clean # cibles fictives (ne correspond pas à un fichier réel)

# cible principale (doit être placée en premier dans le Makefile)
i8080: $(OBJ) main.c
	$(CC) $(CFLAGS) -o i8080 $(OBJ) main.c

# cibles pour compiler les objets
# la commande est toujours la même, seules les dépendances
# sont à définir. 
# NB: Le fichier source .c doit être indiqué en dernier.

computer.o: computer.h computer.c
	$(CC) $(CFLAGS) -c $<

flags.o: computer.h flags.h flags.c
	$(CC) $(CFLAGS) -c $<

# règle pour nettoyer et ne garder que les sources
clean:
	rm -f *.o
	rm -f i8080
```

Le format général d'un Makefile est le suivant : le fichier contient une liste de *cibles* qui sont des fichiers à produire. Les cibles sont suivies d'un deux points `:`. Ici, les cibles sont `computer.o`, `flags.o` et `i8080`. Comme cette dernière cible est placée en premier dans le fichier c'est ce fichier qui sera compilé par défaut.

Une cible est suivie après les `:` de la liste de ses dépendances, c'est-à-dire des fichiers qui sont utilisés dans la compilation pour produire la cible. Sous la cible, indentée par une tabulation, on trouve la commande de compilation à exécuter pour produire la cible. Par exemple, j'ai indiqué que le programme principal `i8080` a besoin de tous les fichiers objets `.o` (regroupés dans une variable `OBJ`) et du fichier `main.c`. De même, j'ai précisé que la compilation de `flags` dépend de `computers.h` et `flags.h` car on fait des `#include` de ces en-têtes, mais aussi du fichier `flags.c` évidemment.

La cible `clean` est une fausse cible car elle ne produit aucun fichier. C'est pourquoi elle est marquée comme `.PHONY`. 

!!!note "Utilisation de la commande Make"
    Si le fichier `Makefile` est présent dans le répertoire alors la commande `make` compile ou recompile l'ensemble du projet. De plus la commande `make clean` permet de *nettoyer* le répertoire en supprimant tous les fichiers compilés et en ne gardant que les sources.

## 2. Tests unitaires

Normalement, si vous tapez maintenant `make`, vous obtiendrez une erreur : `make: don't know how to make main.c. Stop`. Le programme `make` se plaint de ne pas pouvoir compiler le projet car il ne sait pas comment produire le fichier `main.c`. Pas étonnant : c'est à nous de produire ce fichier, il n'existe pas encore.

Écrivons le fichier `main.c` qui contiendra la fonction `main` (point d'entrée de tout programme C). Pour l'instant on se contentera d'exécuter quelques **tests unitaires**. Le but d'un test unitaire est de tester le bon fonctionnement d'une fonction ou d'un petit ensemble de fonctions, indépendemment de tout le reste du projet. 

```c title="main.c"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include "computer.h"
#include "flags.h"

void test_flags() {
    Computer comp;
    comp_init(&comp);

    assert(get_flag_z(&comp) == false);
    assert(get_flag_s(&comp) == false);
    assert(get_flag_p(&comp) == false);
    assert(get_flag_cy(&comp) == false);
    assert(get_flag_ac(&comp) == false);

    update_flags_szp(&comp, 0b10011001);
    assert(get_flag_z(&comp) == false);
    assert(get_flag_s(&comp) == true);
    assert(get_flag_p(&comp) == true);

    // A COMPLETER AVEC D'AUTRES TESTS
}

void test_all() {
    printf("Tests du module flags...\n");
    test_flags();

    // A COMPLETER AVEC D'AUTRES TESTS
}

int main(int argc, char *argv[]) {
    test_all();
    return EXIT_SUCCESS;
}
```

Voilà, maintenant `make` devrait fonctionner et produire un exécutable `i8080`. Si cet exécutable ne produit aucune erreur `assert` alors tous les tests ont fonctionné !

!!!warning "Écrivez des tests !"
    Dans toute la suite, je n'écrirai pas forcément des tests unitaires pour les fonctions proposées. Cependant, je vous encourage vivement à le faire ! En particulier, si vous constatez que votre programme ne compile pas ou ne marche pas correctement et que vous n'arrivez pas à savoir pourquoi, alors écrivez et exécutez des tests unitaires !

## 3. Faire croître le projet

Dans la suite, on fera petit à petit croître le projet en y ajoutant des unités de compilation. À chaque fois que ça sera le cas, il faudra :

1. Ajouter le fichier objet `fichier.o` dans la liste `OBJ`
2. Ajouter une cible `fichier.o : dépendances fichier.c`
3. Sous la règle indiquer la commande de compilation (c'est la même pour toutes les unités) : `$(CC) $(CFLAGS) -c $<` (on n'oublie pas la tabulation devant la commande).

En procédant ainsi, les compilations et recompilations seront nettement facilitées. En particulier `make` détermine automatiquement quel(s) fichier(s) doivent être recompilés et dans quel ordre.

