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
    !!! note "Fausse solution"

    ```c
    #include <stdio.h>
    #include <pthread.h>
    #include <stdbool.h>
    #include <stdlib.h>
    #include <assert.h>

    struct args_t {
        int debut;
        int fin;
        int* compteur;
    };

    bool est_premier(int n) {
        assert(n >= 2);
        for (int k = 2; k < n; k++) {
            if (n % k == 0) {
                return false;
            }
        }
        return true;
    }

    void* compte_premiers(void* args) {
        struct args_t* param = (struct args_t*) args;
        for (int n = param->debut; n <= param->fin; n++) {
            if (est_premier(n)) {
                *(param->compteur) = *(param->compteur) + 1;
            }
        }
        return NULL;
    }

    int main() {
        pthread_t t1, t2;
        int c = 0;
        struct args_t arg1 = {.debut = 2, .fin = 500, .compteur = &c};
        struct args_t arg2 = {.debut = 501, .fin = 1000, .compteur = &c};
        pthread_create(&t1, NULL, &compte_premiers, &arg1);
        pthread_create(&t2, NULL, &compte_premiers, &arg2);
        pthread_join(t1, NULL);
        pthread_join(t2, NULL);
        printf("Il y a %d nombre premiers\n", c);
        return 0;
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
- L'**absence de famine** (*starvation*): une famine survient lorsqu'un processus souhaite accéder à une ressource mais n'obtient jamais la main à un moment où il peut y accéder. 

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

Les sémaphores sont une méthode de synchronisation inventée par Dijkstra. Un sémaphore peut être vu comme une variable entière $S$, sur laquelle il existe deux opérations :

- $P(S)$ (*Proberen*) (mnémotechnique : *Puis-je ?*) :
    - Attendre que $S$ devienne **strictement positif**
    - Décrémenter $S$ d'une unité et continuer
- $V(S)$ (*Verhogen*) (mnémotechnique : *Vas-y*) :
    - Incrémenter $S$ d'une unité

!!! note "Nota Bene"
    Les opérations $P(S)$ et $V(S)$ sont **atomiques**, elles ne posent donc pas de problème d'accès simultané.

#### Utilisation comme verrou

Un sémaphore peut-être utilisé comme un verrou. Dans ce cas il doit être initialisé à 1 et alors l'opération $P(S)$ peut-être vue comme un **lock**, trandis que $V(S)$ est un **unlock**. La seule différence avec un **mutex** est que le thread qui vérouille et le thread qui déverouille peuvent éventuellement être différents.

Ainsi, sauf dans ce dernier cas bien précis, il est inutile de s'embêter avec un sémaphore pour créer une zone d'exclusion mutuelle et on préferera utiliser un *mutex* qui a été conçu dans ce but.

#### Utilisation comme jauge limite

Une généralisation du verrou est d'utiliser un sémaphore initialisé à $N$ afin qu'au plus $N$ processus ne puissent exécuter une certaine zone de code. Voici un exemple en exercice :

!!! example "Exercice : Le dîner des philosophes"
    Quatre philosophes sont assis autour d'une table carrée pour manger. Par souci d'économie (et par clair manque d'hygiène), ils décident de n'utiliser que quatre baguettes en tout pour manger : chaque philosophe a à sa gauche (resp. à sa droite) une baguette qu'il partage avec son voisin de gauche (resp. de droite). Un philosophe fonctionne avec l'algorithme suivant :
    ```
    PHILOSOPHE(x):
        Tant que (vrai) Faire
            PENSER()
            PRENDRE(baguette_gauche(x))
            PRENDRE(baguette_droite(x))
            MANGER()
            POSER(baguette_gauche(x))
            POSER(baguette_droite(x))
        Fin Tant que
    ```

    1. On suppose que les 4 philosophes sont exécutés chacun dans un thread. Implémenter un mécanisme de synchronisation pour empêcher qu'une baguette ne soit prise en même temps par deux philosophes.
    2. Avec cette solution, décrire un scenario qui conduit à un interblocage des 4 philosophes.
    3. On remarque que la situation précédente ne peut se produire lorsque 3 philosophes au plus décident de manger en même temps. En utilisant un sémaphore, résoudre le problème de l'interblocage.

#### Utilisation comme moyen de signalisation

Les sémaphores permettent surtout à des processus de se syncrhoniser en s'envoyant des signaux de type "tu peux poursuivre". Pour réaliser cela, on initialise le sémaphore à $S = 0$. L'opération $P(S)$ consiste alors à se placer en attente de réception du signal. A l'inverse l'opération $V(S)$.
En langage C, cela est rendu encore plus explicite par le nom des choix de fonction : l'opération $P$ est appelée `sem_wait` tandis que l'opération $V$ est appelée `sem_post`.

!!! example "Exemple : Synchronisation Ping-Pong"
    On écrit le programme C suivant qui exécute deux threads :
    
    - `ping` : qui affiche des `PING` à l'écran
    - `pong` : qui affiche des `PONG` à l'écran

    Voici un extrait de code :
    ```c
    void* ping(void* args) {
        for (int i = 0; i < N; i++) {
            fprintf(stderr, "PING\n");
            attendre(1);
        }
        return NULL;
    }

    void* pong(void* args) {
        for (int i = 0; i < N; i++) {
            fprintf(stderr, "pong\n");
            attendre(1);
        }
        return NULL;
    }

    int main() {
        pthread_t tping, tpong;
        pthread_create(&tping, NULL, &ping, NULL);
        pthread_create(&tpong, NULL, &pong, NULL);
        pthread_join(tping, NULL);
        pthread_join(tpong, NULL);

        return EXIT_SUCCESS;
    }
    ```

    D'après ce qu'on a vu, ces deux threads vont s'entrelacer de manière non détermiste : ce qu'on ne souhaite pas. On voudrait qu'un PONG ne soit produit qu'après un PING et réciproquement.

    Une solution est d'utiliser des signaux implémentés à l'aide de sémaphores :

    - Un signal `envoi` qui est est déclenché par `ping` lorsqu'il envoie la balle
    - Un signal `retour` qui rest déclenché par `pong` lorsqu'il renvoie la balle

    ??? note "Solution"
        Voici corriger le programme précédent :
        ```c
        #include <semaphore.h>
        (...)

        struct param_s {
            sem_t *envoi;
            sem_t *retour;
        };
        typedef struct param_s param;

        void* ping(void* args) {
            param* p = (param*) args;
            for (int i = 0; i < N; i++) {
                fprintf(stderr, "PING\n");
                sem_post(p->envoi);
                attendre(1);
                sem_wait(p->retour);
            }
            return NULL;
        }

        void* pong(void* args) {
            param* p = (param*) args;
            for (int i = 0; i < N; i++) {
                sem_wait(p->envoi);
                fprintf(stderr, "pong\n");
                sem_post(p->retour);
                attendre(1);
            }
            return NULL;
        }

        int main() {
            pthread_t tping, tpong;

            sem_t envoi, retour;
            sem_init(&envoi, 0, 0);
            sem_init(&retour, 0, 0);

            param a = {.envoi = &envoi, .retour = &retour};

            pthread_create(&tping, NULL, &ping, &a);
            pthread_create(&tpong, NULL, &pong, &a);
            pthread_join(tping, NULL);
            pthread_join(tpong, NULL);

            sem_destroy(&envoi);
            sem_destroy(&retour);

            return EXIT_SUCCESS;
        }
        ```
### C. Algorithme de Peterson

Les verrous et les sémaphores utilisent des instructions spéciales du processeur telles que **test-and-set** pour fonctionner. Ces instructions sont disponibles sur les architectures récentes.

Historiquement, les ordinateurs travaillaient séquentiellement et ne disposaient pas de telles instructions. Il a alors fallu trouver des solutions algorithmiques pour synchroniser des processus en se basant sur l'**attente active**.


L'algorithme de Peterson permet de créer une zone d'exclusion mutuelle de manière algorithmique pour **deux processus uniquement**.

```c
// ALGORITHME DE PETERSON

// Init
bool veut_entrer[2] = {false, false};
int tour;

// Dans le thread 0 :
T0: veut_entrer[0] = true;
    tour = 1;
    while (veut_entrer[1] && tour == 1) {} // attente active
    // Début de la section critique
    ...
    // fin de la section critique
    veut_entrer[0] = false;

// Dans le thread 1 :
T1: veut_entrer[1] = true;
    tour = 0;
    while (veut_entrer[0] && tour == 0) {} // attente active
    // Début de la section critique
    ...
    // fin de la section critique
    veut_entrer[1] = false;
```


!!! tip "Proposition"
    L'algorithme de Peterson garantit l'exclusion mutuelle pour deux processus dans la zone critique associée.

Supposons par l'absurde qu'il y a violation de l'exclusion mutuelle et que $0$ est le dernier thread à avoir écrit dans tour (donc tour vaut 1). Cela signifie que `veut_entrer` vaut vrai pour les deux processus (car fixé avant le tour). Donc le thread 0 n'a pas pu franchir le test du `while`, c'est absurde.


!!! tip "Proposition"
    L'algorithme de Peterson garantit l'absence de famine pour chacun des processus. En particulier, il n'y a pas d'interblocage.

Supposons par l'absurde que le thread 0 est en famine, cela signifie qu'à chaque fois qu'il obtient la main, et qu'il effectue le test du while, le test vaux `true`. Remarquons déjà, que comme le thread 1 ne modifie `tour` que pour le mettre à `0`, cette situation ne peut se produire que si `veut_entrer[1]` est toujours à vrai quand le thread 0 obtient la main. Alors regardons la situation du thread 1 juste au moment où il va rendre la main:

- S'il se situe après sa zone critique, il a placé `veut_entrer[1]` à false, donc un retour à thread 0 le débloque : absurde
- S'il se situe dans sa zone critique : il finira par en sortir et on est ramené au cas précédent
- S'il sort de sa zone critique mais revient (boucle, ...) et tente de réacceder à la zone critique : il va placer `tour` à 0 et comme `veut_entrer[1]` est à true, il entre dans une boucle potentiellement infinie, le retour au thread 0 débloque alors ce dernier : absurde

Donc il n'y pas de famine.

!!! warning "Attention"
    L'algorithme est bien précis et doit être respecté à la lettre. Par exemple, l'absence de drapeaux `veut_entrer` rend l'algorithme faux.

### D. Algorithme de la boulangerie de Lamport

L'algorithme de la boulangerie de Lamport permet de créer une zone d'exclusion mutuelle de manière algorithmique pour **un nombre fini de processus**.

Son principe de fonctionnement est le suivant :

- chaque thread voulant accéder à la ressource tire un ticket (plus grand que les tickets déjà tirés)
- lorsqu'un processus veut accéder à la section critique :
    - il vérifie que les autres threads qui aient fini de tirer leur ticket
    - il vérifie s'il a bien le plus petit numéro par rapport aux autres
    - en cas d'égalité, s'il a le plus petit **numéro de thread** alors il passe en premier
- lorsqu'il a terminé, il jette son ticket

```c
    // ALGORITHME DE LA BOULANGERIE DE LAMPORT 

    // Variables globales :

    // Numéro de ticket tiré (0 = pas de ticket)
    int num[N] = {0, ..., 0};

    // Drapeau pour dire qu'on est en train de prendre un ticket
    bool prends_ticket[N] = {false, ..., false};

    // Le thread i demande la ressource :
    void lock(int i) {
        prends_ticket[i] = true;
        num[i] = MAX(num[0], ..., num[n-1]) + 1;
        prends_ticket[i] = false;
        for (int p = 0; p < N; p++) {
            while (prends_ticket[p]) // On attends que p ait terminé de prendre son ticket
            while (num[p] != 0 && (num[p] < num[i] || (num[p] == num[i] && p < i)) {}
    // En cas d'egalite de ticket, le thread de plus petit numero passe en premier
        }
    }

    // Le thread i libère la ressource :
    void unlock(int i) {
        num[i] = 0;
    }
```

!!! abstract "Proposition"
    L'algorithme de Lamport garantit l'exclusion mutuelle (entre `lock` et `unlock`) ainsi que l'absence de famine.

!!! warning "Attention"
    L'algorithme est bien précis et doit être respecté à la lettre. Par exemple, l'absence de drapeaux `prends_ticket` ou de traitement du cas d'égalité rend l'algorithme faux.

!!! bug "Attention"
    Comme mentionné au début de ce chapitre, les algorithmes de *Peterson* et de la *boulangerie de Lamport* sont faux écrits comme tels dans le cadre de la programmation sur une machine moderne multi-coeurs (absence de cohérence séquentielle). Vous pouvez essayer de les programmer en langage C et vous verrez que l'exécution l'exclusion mutuelle n'est pas vérifiée...

!!! note "Remarque importante"
    Les algorithmes de *Peterson* et de la *boulangerie de Lamport* ont surtout un intérêt historique et pédagagogique. Sauf si l'énoncé le demande explicitement, préférez l'utilisation des **mutex** pour créer une zone d'exclusion mutuelle en pratique.
