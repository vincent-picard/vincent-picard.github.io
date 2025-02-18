# Programmation concurrente

## 1. Introduction

La **programmation concurrente** consiste à exécuter plusieurs programmes simultanément. Par exemple un programme A commence à s'exécuter mais avant qu'il ne termine un autre programme B commence aussi son exécution. Autrement dit, les intervalles de temps durant lesquels les programmes $A$ et $B$ s'exécutent ont une intersection non vide ! La programmation concurrente s'oppose donc à une programmation *séquentielle* dans laquelle les programmes s'exécutent les uns après les autres.

En pratique, ces programmes peuvent être soit des processus distincts, soit des fils d'exécution (*thread* en anglais) distincts d'un même programme. En MPI, on se concentrera uniquement sur le mécanisme des *threads*.

La programmation concurrente ne doit pas être confondue avec la **programmation parallèle**. Dans un programme parallèle, plusieurs *instructions* s'exécutent simultanément, cela est possible grâce aux progrès technologiques en matière de conception de processeurs : ceux-ci contiennent maintenant généralement plusieurs coeurs permettant des exécutions simultanées d'instructions (par exemple des affectations simultanées). Ainsi le parallélisme est l'une des formes de programmation concurrente mais n'est pas obligatoire.

La forme la plus complexe de programmation concurrente est la **programmation distribuée** dans laquelle différents ordinateurs exécutent des programmes simultanément en s'échangeant des messages à travers un réseau. Nous n'aborderons pas ce sujet difficile ici.

### Hypothèses de travail

Dans ce cours on fera les hypothèses suivantes :

- La programmation concurrente s'effectuera à l'aide de *threads* d'exécution
- **Cohérence séquentielle** (sequential consistency): tout se passe comme si l'exécution des threads $A$ et $B$ se déroulait par un même processeur qui alterne entre l'exécution d'instructions de $A$ et d'instructions de $B$. On dit qu'il y a **entrelacement** des exécutions. Il n'y aura donc pas de parallélisme. On ne contrôle pas l'entrelacement.
- Les instructions de **lecture** d'une variable ou d'**écriture** dans une variable sont **atomiques** : on ne change pas de thread au milieu d'une de ces opérations. 

!!! warning "Mise en garde"
    Attention, ces hypothèses de travail ne sont généralement pas valides sur un ordinateur moderne multi-coeurs. C'est pourquoi certains des algorithmes présentés dans ce chapitre (algorithmes de peterson et de Lamport) peuvent ne pas fonctionner en pratique.

Néanmoins, ces hypothèses permettent d'appréhender les principes de la programmtion concurrente et les problématiques en jeu.


### Applications

On trouve de nombreux exemples pratiques d'utilisation de la programmation concurrente :

- Rammasse-miette : quand un programme Java s'exécute, un thread spécial appelé ramasse-miette est chargé de détecter et libérer la mémoire qui n'est plus utilisée,
- Interfaces graphiques : un thread gère le fonctionnement des fenêtres, des boutons, des évenements, etc, un autre thread gère le programme en lui-même
- Consoles de jeux : chaque manette est gérée par un thread, l'exécution du jeu est géré par plusieurs threads, ... 
- Serveurs Web : chaque requête du serveur par un ordinateur distant est gérée par un thread distinct
- Calcul "parallèle" : sur un grand jeu de données, on divise les données en $N$ et chaque partie est traitée par un thread différent (ex: images)

C'est donc un concept important à appréhender car très utilisé en pratique mais qui peuvent conduire aussi à de nombreux bugs difficiles à comprendre et à corriger.

## 2. Fils d'exécution (threads)

Un fil d'exécution (*thread*) est une instance qui exécute du code. Chaque programme est intialement exécuté au sein du thread principal. On peut déclencher l'exécution de nouveaux threads à l'aide de la commande **create**.

Un *thread* est créé à l'aide d'une opération **create**. A partir du moment où il est créé, son exécution concurrente aux autres threads se produit.

En ce qui concerne la mémoire, on peut supposer que chaque *thread* possède sa pile d'exécution qui lui est propre, par contre le tas est partagé entre tous les threads.

Tout thread créé par le programme doit être détruit par une opération appelée **join**. L'opération **join** attend que le fil d'exécution termine sa tâche, puis le détruit.

Toute opération **create** doit être associée à un **join** de destruction, à l'image d'un **malloc** qui est toujours associé à un **free**.

### En langage C


L'accès aux fonctions de multi-threading se fait par l'inclusion du fichier d'en-tête `pthread.h`. Le type des fils est `pthread_t`, la fonction *create* est `pthread_create`, la fonction *join* est `pthread_join`.

La fonction `pthread_create` possède 4 paramètres :

1. l'adresse de la variable du type `pthread_t` qui contiendra le thread
2. un paramètre qu'on n'utilisera pas : argument `NULL`
3. l'adresse de la fonction à exécuter : celle-ci doit impérativement être de type `void*` vers `void*`
4. l'adresse du paramètre de la fonction associé


La fonction `pthread_join` possède 2 paramètres :

1. le thread de type `phtread_t` à détruire (pas son adresse)
2. un paramètre qu'on n'utilisera pas : argument `NULL`

!!! example "Un premier exemple"
    Compléter le programme suivant pour qu'il exécute un thread `thread2` supplémentaire qui affiche des caractères `b`. Observer l'entrelacement des threads.
    ```c
    #include <stdio.h>
    #include <pthread.h>
    #include <time.h>

    // Une fonction pour attendre une durée en secondes
    void attendre(int sec) {
        const time_t t_debut = time(NULL);
        time_t t_actuel = time(NULL);
        while (t_actuel - t_debut < sec) { // attente active
            t_actuel = time(NULL);
        }    
        return;
    }

    // Une fonction qui affiche 10 fois un caractère
    void* afficher_caracteres(void* args) {
        char* c = (char*) args;
        for (int i = 0; i < 10; i++) {
            fputc(*c, stderr);
            attendre(1);
        }

        return NULL;
    }

    int main() {
        pthread_t thread1;
        char c1 = 'a';
        pthread_create(&thread1, NULL, &afficher_caracteres, &c1);
        pthread_join(thread1, NULL);
        printf("\n Programme terminé \n");
        return 0;
    }
    ```
Voilà ce qu'on peut par exemple obtenir pour 3 exécutions de l'exemple précédent :
```
abbaabbaabbaabbaabba
abababbababababaabab
ababbabaababbaababab
```

On remarque donc que **l'exécution d'un programme à threads concurrents est non déterministe**. Cela complexifie nettement la programmation, par exemple un cas de bug pourrait survenir 1 exécution sur 100...


!!! info "Remarque"
    Pour mettre en évidence l'entrelacement, on a utilisé la fonction `attendre` afin d'éviter que l'exécution d'un fil ne se termine avant même que l'autre ne commence. On a également utilisé exceptionnellement l'affichage sur le canal `stderr` pour obtenir les résultats du programme *en direct* (la sortie d'erreur n'étant pas bufférisée).


!!! example "Exercice : affichage de la progression d'un calcul"
    Ci-dessous se trouve un programme qui construit un grand tableau d'entiers aléatoires, puis le trie par ordre croissant selon l'algorithme du tri par insertion.

    1. Complétez la fonction `progress` qui a pour but d'afficher en boucle toutes les 1 seconde le pourcentage d'avancement $i/N$ sur le canal `stderr`. La fonction quitte la boucle lorsque `i == N`.
    2. Dans la fonction `main`, ajouter du code pour la création d'un thread pour exécuter la fonction `progress` de manière concurrente au thread principal.

    ```c
    #include <stdio.h>
    #include <stdlib.h>
    #include <time.h>
    #include <pthread.h>

    #define N (1 << 17)

    void attendre(int sec) {
        const time_t t_debut = time(NULL);
        time_t t_actuel = time(NULL);
        while (t_actuel - t_debut < sec) {
            t_actuel = time(NULL);
        }    
        return;
    }

    void* progress(void* i) {
        // A COMPLETER
        return NULL;
    }

    int main() {
        // Initialisation d'un tableau aléatoire
        int t[N];
        for (int i = 0; i < N; i++) {
            t[i] = (int) random();
        }

        // Tri par insertion
        int i = 0;

        for (i = 1; i < N; i++) {
            int k = i;
            while (k > 0 && t[k-1] < t[k]) {
                int tmp = t[k-1];
                t[k-1] = t[k];
                t[k] = tmp;
                k -= 1;
            }
        }
    }
    ```


!!! info "Remarque : cas des fonctions à plusieurs paramètres"
    Si l'on souhaite exécuter une fonction ayant plusieurs paramètres dans un thread, c'est plus compliqué. La fonction à fournir à *create* ne doit comporter qu'un seul paramètre, il faut donc créer un type struct dédié pour regrouper les paramètres au sein d'une seule structure.

