---
icon: fontawesome/solid-code-fork
---

# :fontawesome-solid-code-fork: Programmation concurrente

## 1. Introduction

La **programmation concurrente** consiste à exécuter plusieurs programmes simultanément. Par exemple un programme A commence à s'exécuter mais avant qu'il ne termine un autre programme B commence aussi son exécution. Autrement dit, les intervalles de temps durant lesquels les programmes $A$ et $B$ s'exécutent ont une intersection non vide ! La programmation concurrente s'oppose donc à une programmation *séquentielle* dans laquelle les programmes s'exécutent les uns après les autres.

En pratique, ces programmes peuvent être soit des processus distincts, soit des fils d'exécution (*thread* en anglais) distincts d'un même programme. En MPI, on se concentrera uniquement sur le mécanisme des *threads*.

La programmation concurrente ne doit pas être confondue avec la **programmation parallèle**. Dans un programme parallèle, plusieurs *instructions* s'exécutent simultanément, cela est possible grâce aux progrès technologiques en matière de conception de processeurs : ceux-ci contiennent maintenant généralement plusieurs coeurs permettant des exécutions simultanées d'instructions (par exemple des affectations simultanées). Ainsi le parallélisme est l'une des formes de programmation concurrente mais n'est pas obligatoire.

La forme la plus complexe de programmation concurrente est la **programmation distribuée** dans laquelle différents ordinateurs exécutent des programmes simultanément en s'échangeant des messages à travers un réseau. Nous n'aborderons pas ce sujet difficile ici.

### :bricks: Hypothèses de travail

Dans ce cours on fera les hypothèses suivantes :

- La programmation concurrente s'effectuera à l'aide de *threads* d'exécution
- **Cohérence séquentielle** (sequential consistency): tout se passe comme si l'exécution des threads $A$ et $B$ se déroulait par un même processeur qui alterne entre l'exécution d'instructions de $A$ et d'instructions de $B$. On dit qu'il y a **entrelacement** des exécutions. Il n'y aura donc pas de parallélisme. On ne contrôle pas l'entrelacement.
- Les instructions de **lecture** d'une variable ou d'**écriture** dans une variable sont **atomiques** : on ne change pas de thread au milieu d'une de ces opérations. 

!!! warning "Mise en garde"
    Attention, ces hypothèses de travail ne sont généralement pas valides sur un ordinateur moderne multi-coeurs. C'est pourquoi certains des algorithmes présentés dans ce chapitre (algorithmes de peterson et de Lamport) peuvent ne pas fonctionner en pratique.

Néanmoins, ces hypothèses permettent d'appréhender les principes de la programmtion concurrente et les problématiques en jeu.


### :material-application-cog: Applications

On trouve de nombreux exemples pratiques d'utilisation de la programmation concurrente :

- **Ramasse-miette** : quand un programme Java s'exécute, un thread spécial appelé ramasse-miette est chargé de détecter et libérer la mémoire qui n'est plus utilisée,
- **Interfaces graphiques** : un thread gère le fonctionnement des fenêtres, des boutons, des évenements, etc, un autre thread gère le programme en lui-même
- **Consoles de jeux** : chaque manette est gérée par un thread, l'exécution du jeu est géré par plusieurs threads, ... 
- **Serveurs Web** : chaque requête du serveur par un ordinateur distant est gérée par un thread distinct
- **Calcul "parallèle"** : sur un grand jeu de données, on divise les données en $N$ et chaque partie est traitée par un thread différent (ex: images)

C'est donc un concept important à appréhender car très utilisé en pratique mais qui peuvent conduire aussi à de nombreux bugs difficiles à comprendre et à corriger.

## 2. Fils d'exécution (threads)

Un fil d'exécution (*thread*) est une instance qui exécute du code. Chaque programme est intialement exécuté au sein du thread principal. On peut déclencher l'exécution de nouveaux threads à l'aide de la commande **create**.

Un *thread* est créé à l'aide d'une opération **create**. A partir du moment où il est créé, son exécution concurrente aux autres threads se produit.

En ce qui concerne la mémoire, on peut supposer que chaque *thread* possède sa pile d'exécution qui lui est propre, par contre le tas est partagé entre tous les threads.

Tout thread créé par le programme doit être détruit par une opération appelée **join**. L'opération **join** attend que le fil d'exécution termine sa tâche, puis le détruit.

Toute opération **create** doit être associée à un **join** de destruction, à l'image d'un **malloc** qui est toujours associé à un **free**.

!!! example "Illustration d'un programme s'exécutant avec 3 threads"
    ```mermaid
    sequenceDiagram
        create participant Thread A
        Main->>Thread A: create(f) 
        create participant Thread B
        Main->>Thread B: create(g)
        destroy Thread A
        Thread A-->>Main: join()
        destroy Thread B
        Thread B-->>Main: join()
    ```

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

### Les difficultés de la programmation concurrente

La programmation concurrente est bien plus difficile que la programmation classique : de nombreux bugs peuvent être écrits si on considère mal les scénarios d'exécution possibles. Étudions un exemple.

!!! example "Un compteur partagé"
    On souhaite écrire un programme qui compte les nombres premiers entre $2$ et $1000$. Dans un esprit de parallélisation du calcul, on décide d'effectuer ce calcul avec deux threads : l'un qui compte les nombres premiers entre $2$ et $500$ et l'autre entre $501$ et $1000$. Ces deux threads ont pour effet d'incrémenter un **compteur partagé** lorsqu'ils détectent un nombre premier.

    1. Implémenter la fonction `compte_premiers`, cette fonction prend en argument un pointeur vers un `struct args_s`.
    2. Compléter la fonction `main` pour qu'elle créé les deux threads destinés à compter les nombres premiers.
    3. Observer le résultat sur plusieurs exécutions.

    ```c
    #include <stdio.h>
    #include <stdlib.h>
    #include <pthread.h>
    #include <stdbool.h>
    #include <assert.h>

    // Teste si un entier est premier
    bool est_premier(int n) {
        assert(n >= 2);
        for (int k = 2; k < n; k++) {
            if (n % k == 0) {
                return false;
            }
        }
        return true;
    }

    // Une structure pour les parametres du thread
    struct args_s {
        int debut; // [debut, fin] est l'intervalle de recherche
        int fin;
        int* compteur; // adresse du compteur partagé
    };

    void* compte_premiers(void* args) {
        // A COMPLETER
        return NULL;
    }

    int main() {
        int* c = malloc(sizeof(int)); // Le compteur partagé est alloué sur le tas
        *c = 0;
        // A COMPLETER
        printf("Il y a %d nombres premiers\n", *c);
        free(c);
        return EXIT_SUCCESS;
    }
    ```

!!! danger "Le problème est la *race condition* (spoiler)"
    Sur certaines exécutions le résultat est faux. Cela vient du fait que l'instruction `*c = *c + 1` n'est pas atomique : entre la lecture de `c` et l'écriture de `c` il est possible qu'un autre thread effectue des opérations... Cela pose problème quand les deux threads décident de manipuler le compteur à des instants proches (race condition). Voici un exemple de scénario qui produit le bug :
    ```mermaid
    sequenceDiagram
        participant Thread A
        participant Compteur
        participant Thread B
        Note over Compteur: c vaut 4
        Compteur->>Thread A: lire c 
        Note over Thread A: c vaut 4
        Note over Thread A: calculer c+1
        Compteur->>Thread B: lire c 
        Note over Thread B: c vaut 4
        Note over Thread B: calculer c+1
        Thread A->>Compteur: ecrire c
        Note over Compteur: c vaut 5
        Thread B->>Compteur: ecrire c
        Note over Compteur: c vaut 5
    ```
    Au final chacun des threads a provoqué une incrémentation mais le compteur partagé n'a été augmenté que d'une seule unité.

Ainsi, la programmation concurrente nécessite l'utilisation de méthodes permettant de contraindre l'entrelacement des processus afin d'éviter ce type de bugs.

## 3. La synchronisation

Lorsqu'on utilise la programmation concurrente, on cherche à garantir les bonnes propriétés suivantes :

- L'**exclusion mutuelle** : l'exclusion mutuelle consiste à empêcher deux processus d'accéder simultanément à une ressource partagée, en particulier d'exécuter simultanément une **section critique** de code 
- L'**absence d'interblocage** (*deadlock*): un interblocage survient lorsque l'ensemble des processus s'attendent mutuellement 
- L'**absence de famine** (*starvation*): une famine survient lorsqu'un processus doit éternellement attendre pour accéder à une ressource, par exemple lorsque les autres processus passent toujours avant lui.  

!!! info "Remarque"
    Par définition, l'absence de famine implique l'absence d'interblocage

La synchronisation est l'ensemble des méthodes utilisées pour contrôler l'entrelacement des processus afin de garantir ces bonnes propriétés.

### A. :lock: Les verrous (mutex)

Les **verrous**, souvent appelés **mutex**, sont le mécanisme le plus simple de synchronisation. Un mutex sert à créer une zone d'exclusion mutuelle. Il sert donc à protéger les **sections critiques** du code (celles où on veut éviter un accès simultané à une ressource partagée).

Un verrou est un objet sur lequel on peut effectuer deux opérations :

- **Vérouiller** (**lock**) : cette opération place le thread courant en attente jusqu'à ce que que le verrou soit libre. Lorsque le verrou est libre, il le verouille et poursuit à l'instruction suivante.
- **Dévérouiller** (**unlock**) : cette opération libère le verrou

Ainsi la section de code située entre l'instruction **lock** et l'instruction **unlock** est protégée : un seul thread à la fois peut exécuter cette section de cote.

Une image mentale que vous pouvez vous faire est celui d'un vestiaire. Verouiller correspond à attendre que le vestiaire soit libre puis entrer et le verouiller. Déverouiller consiste à déverouiller le vestiaire en sortant. Si tout le monde utilise cet algorithme alors personne ne peut être dans le vestiaire en même temps que vous.

!!! note "Remarque"
    Si plusieurs processus sont en attente de libération d'un verrou, alors au moment où il est libéré le prochain procesus qui va acquérir le verrou est indéterminé. Il n'y a pas possibilité de contrôler quel processus va passer avant l'autre.

!!! note "Remarque importante"
    Pour faire fonctionner ce mécanisme, il faut que les threads concernés puissent accéder au même verrou. Le verrou doit donc être une ressource partagée entre les deux processus.

#### En langage C

En langage C, les mutex sont définis dans `pthread.h`. Le type des mutex est `pthread_mutex_t`. L'utilisation des *mutex* se fait à l'aide de 4 opérations :

- `pthread_mutex_init(&mutex, NULL)` permet de créer un verrou qui sera enregistré dans la variable `mutex`
- `pthread_mutex_lock(&mutex)` vérouille le verrou enregistré dans la variable `mutex`
- `pthread_mutex_unlock(&mutex)` même chose mais dévérouille `mutex`
- `pthread_mutex_destroy(&mutex)` détruit le mutex (doit être utilisé pour libérer les ressources)

!!! example "Exercice"
    Reprendre le programme du compteur partagé mais en le corrigeant à l'aide d'une zone d'exclusion mutuelle mise en oeuvre à l'aide d'un mutex.

### B. :triangular_flag_on_post: Les sémaphores

Les sémaphores permettent à des processus de communiquer en s'envoyant des signaux de type "tu peux continuer".

### C. Algorithme de Peterson

Les verrous et les sémaphores utilisent des instructions spéciales du processeur telles que **test-and-set** pour fonctionner. Ces instructions sont disponibles. Historiquement, les ordinateurs travaillaient séquentiellement et ne disposaient pas de telles instructions. Il fallait alors trouver des solutions algorithmiques pour synchroniser des processus.

### D. Algorithme de la boulangerie de Lamport

