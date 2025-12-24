# :bug: Débugguer son programme C avec *gdb*

Rien de plus énervant que de compiler un programme C, l'exécuter et se prendre la fameuse erreur :
```sh
    segmentation fault (core dumped)
```

Dans ce mini-tuto, je vous explique comment utiliser le programme *GNU Debugger* (*gdb*) pour savoir exactement quelle ligne
de votre code a provoqué le problème, et aussi avoir des informations supplémentaires pour enquêter sur votre bug.

## 1. Installation de *gdb*

Si jamais le programme *gdb* n'est pas installé sur votre Linux, la simple commande d'installation classique vous sauvera :
=== "Debian / Ubuntu"

    ```sh
       >>> sudo apt install gdb 
    ```

=== "Arch Linux"

    ```sh
       >>> sudo pacman -S gdb 
    ```

!!!warning
    Cette commande doit s'exécuter en mode administrateur d'où la présence de sudo. Ca sera la seule commande ici à utiliser avec sudo.

## 2. Notre programme test

Dans le but de comprendre comment *gdb* fonctionne, on considère ce petit programme très simple contenant un bug grossier et évident :

```c title="somme.c"
    #include <stdio.h>
    #include <stdlib.h>

    int somme(int tab[], int longueur) {
        int s = 0;
        for (int i = 0; i < longueur; i++) {
            s += tab[i];
        }
        return s;
    }

    void ajoute_un(int tab[], int longueur) {
        for (int i = 0; i <= longueur * 1000; i++) {
            tab[i] += 1;
        }
    }

    int main() {
        int t[] = {1, 4, 5, 8, 10};
        ajoute_un(t, 5);
        printf("Somme = %d \n", somme(t, 5));
        return 0;
    }
```

Ce programme comporte deux fonctions :

- `somme` : qui calcule la somme des valeurs dans un tableau
- `ajoute_un` : qui ajoute un à chacune des valeurs d'un tableau

Evidemment la présence du `longueur * 1000` dans `ajoute_un` provoque un dépassement de tableau et une erreur de segmentation...

## 3. Compiler avec les bonnes options

Pour que *gdb* puisse vous donner les informations utiles, il faut d'abord demander au compilateur *gcc* de *conserver* un maximum d'informations utiles dans le programme compilé. On va donc lui passer deux options :

- `-g` : pour qu'il ajoute des informations supplémentaires au programme compilé comme par exemple les noms de fonctions ou de variables (dans un programme compilé les fonctions sont repérées par des adresses mémoires donc de simples numéros, on aimerait avoir plus d'infos...).
- `-O0` (lettre O et chiffre 0) : pour qu'il n'optimise rien du tout. Optimiser peut conduire à réorganiser et modifier notre code pour qu'il soit plus efficace, c'est bien mais ça complique la tache quand on veut débugguer.

Au final on tape :
```sh
    gcc -g -O0 somme.c -o somme
```

Bien sur une fois qu'on a un programme qui marche : on enlève ces options pour avoir un programme compilé plus performant.

## 4. Exécuter son programme avec gdb

Ensuite on exécute notre programme mais au travers de l'outil *gdb*, comme ceci :
```sh
    gdb ./somme
```

*gdb* est un programme interactif qui attend que vous lui disiez quoi faire: 
```sh
    Copyright (C) 2024 Free Software Foundation, Inc.
    License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.
    Type "show copying" and "show warranty" for details.
    This GDB was configured as "x86_64-pc-linux-gnu".
    Type "show configuration" for configuration details.
    For bug reporting instructions, please see:
    <https://www.gnu.org/software/gdb/bugs/>.
    Find the GDB manual and other documentation resources online at:
        <http://www.gnu.org/software/gdb/documentation/>.

    For help, type "help".
    Type "apropos word" to search for commands related to "word"...
    Reading symbols from ./somme...
    (gdb) 
```

La première chose qu'on va lui demander c'est d'exécuter le programme avec la commande `run` (puis touche entrée) :
```sh
    (gdb) run
    Starting program: /home/vincent/cours/mpi/c/gdb/somme 

    [Thread debugging using libthread_db enabled]
    Using host libthread_db library "/usr/lib/libthread_db.so.1".

    Program received signal SIGSEGV, Segmentation fault.
    0x00005555555551b6 in ajoute_un (tab=0x7fffffffe3e0, longueur=5) at somme.c:14
    14	        tab[i] += 1;
    (gdb) 
```

Et voilà on a beaucoup plus d'information. On peut ainsi lire :

- `Program received signal SIGSEGV, Segmentation fault.` qui signifie qu'une erreur de segmentation s'est produite
- `0x00005555555551b6 in ajoute_un (tab=0x7fffffffe3e0, longueur=5) at somme.c:14` : nous indique que le problème est survenu dans la fonction `ajoute_un` avec comme paramètres un tableau donné par son adresse (illisible pour nous) et la valeur `longueur=5`. Plus précisément, c'est arrivé à la ligne 14 du fichier `somme.c` : génial je sais maintenant où chercher.
- `14	        tab[i] += 1;` : *gdb* a même eu la gentillesse de nous réécrire la ligne de code concernée.

## :detective: Mode détective !

Encore mieux, imagions que je ne comprenne toujours pas bien pourquoi cela a provoqué une erreur de segmentation, je peux demander à *gdb* de m'afficher l'état actuel des variables au moment du bug avec la commande `print`, par exemple :
```sh
    (gdb) print i
    $1 = 776
```

Et voilà il m'indique donc qu'au moment du bug la variable `i` vaut `776`, et puisque le tableau est de longueur 5 on comprend qu'on a écrit un bug de dépassement de tableau !

Il n'y a plus qu'à quitter *gdb* avec la commande `quit` et aller corriger son code :
```sh
    (gdb) quit
    A debugging session is active.

        Inferior 1 [process 49338] will be killed.

    Quit anyway? (y or n) y
```

