# :material-dice-5::material-dice-3: Projet en C : construction d'une chaîne de dominos par backtracking

Inspiré de [Sujet 0 CCINP](https://www.concours-commun-inp.fr/_resource/annales%20%C3%A9crits/MPI/Sujet_0_final_MPI.pdf?download=true)

## :material-strategy: 1. Introduction

Le but est d'écrire un programme en C qui prend en entrée un fichier texte contenant une liste de dominos, par exemple :

```title="exemple_small.txt"
2, 2
3, 6
1, 5
6, 4
6, 6
2, 5
1, 5
2, 4

```

et qui produit une chaîne de dominos à partir de cette liste :
```sh
    vincent@kimchi:~/domino : ./chainedom exemple_small.txt
    Liste initiale :
    [2;2][3;6][1;5][6;4][6;6][2;5][1;5][2;4]

    Construction réussie :
    [5;1][1;5][5;2][2;2][2;4][4;6][6;6][6;3]
```

Remarquer que lors de cette construction, les dominos peuvent être retournés (on parlera de rotation) : par exemple ici le domino `[3;6]` a été retourné en `[6;3]` pour aboutir à cette solution.

Je vous donne ici une archive contenant un squelette du projet accompagné d'un fichier *Makefile* :
[:link: **LE PROJET A TELECHARGER ICI**](projet_domino.zip)

- pour compiler le projet on tape : `make`
- pour exécuter son programme on tape : `./chainedom exemple_small.txt` (avec le fichier que vous voulez !)
- pour nettoyer le répertoire (fichiers compilés) : `make clean`

Les options de compilation peuvent être modifiées dans la variable `FLAGS` du fichier *Makefile* si vous le souhaitez.

Le projet est organisé en 4 unités :

- L'unité `domino`: gère la représentation d'un domino
- L'unité `liste`: représente un ensemble de dominos sous forme de liste doublement chaînée
- L'unité `backtracking` : implémente l'algorithme de construction d'une chaîne de dominos
- L'unité `parser` : implémente la lecture du fichier texte d'entrée, j'ai codé cette partie pour vous il n'y a rien à faire... Mais cela ne doit pas vous empêcher d'aller voir comment j'ai fait.
- Il y a aussi un fichier `main.c` qui contient la fonction d'entrée de votre programme


## :material-dice-2: 2. Gestion des dominos

Les dominos seront représentés à l'aide du type suivant (défini dans `domino.h`) :
```c title="domino.h (extrait)"
struct domino_s {
    int x; // Partie gauche
    int y; // Partie droite
};
typedef struct domino_s Domino;

```

On vous donne également une fonction :
```c
Domino domino(int x, int y);
```
permettant de construire un domino à partir de deux entiers.

!!!example "Question 1"
    Dans le fichier `domino.c`, implémenter la fonction
    ```c
    bool domino_possible(Domino a, Domino b)
    ```
    testant si l'enchainement des deux dominos `a` suivi de `b` est valide. On n'autorise pas pour l'instant les rotations. Par exemple `[3; 6][6; 4]` est un enchaînement valide mais `[1; 5][4; 5]` ne l'est pas.

!!!example "Question 2"
    Dans le fichier `domino.c`, implémenter la fonction
    ```c
    bool domino_possible_avec_rotation(Domino a, Domino *b)
    ```
    qui teste si on peut enchaîner les dominos `a` suivi de `b`. Cette fois-ci on s'autorise la rotation du domino `b`. La fonction aura le comportement suivant :

    - S'il est possible d'enchaîner `a` puis `b` sans rotation, on renvoie `true` et on ne modifie pas `b`
    - S'il est possible d'enchaîner `a` puis `b` en tournant `b` alors on **modifie** b et on renvoie `true`
    - Sinon on renvoie `false` sans rien modifier


## :link: 3. Listes doublement chaînées

Dans ce sujet on utilisera des listes doublement chaînées de dominos. Pour cela on définit dans `liste.h` les types suivants.

```c title="liste.h (extrait)"
struct maillon_s {
    Domino d;
    struct maillon_s *suivant;
    struct maillon_s *precedent;
};
typedef struct maillon_s Maillon;

struct liste_s {
    Maillon *premier;
    Maillon *dernier;
};
typedef struct liste_s Liste;

```

Chaque maillon contient une valeur de type `Domino` ainsi qu'un pointeur sur le maillon suivant et le maillon précédent. Dans le cas des maillons aux extrémités, ces pointeurs pourront avoir la valeur spéciale `NULL`.

Une liste est une structure qui contient un lien vers le premier et vers le dernier maillon (éventuellement égaux) de la liste. Dans le cas de la liste vide, ces deux liens auront pour valeur `NULL`.

On vous donne (dans `liste.c`) l'implémentation de la fonction :
```c
Liste nouvelle_liste();
```
qui renvoie une nouvelle liste vide.

### :broken_chain: A. Ajout et suppression d'une valeur 

!!!example "Question 3"
    Dans cette question on souhaite ajouter un nouveau domino à l'extrémité droite d'une liste de dominos (sans tenir compte si l'enchaînement est valide ou non). Cette fonction aura pour prototype :
    ```c title="liste.h (extrait)"
    void append(Liste *l, Domino d)
    ```
    Cette fonction devra donc **modifier** la liste passée en argument. Il faudra bien sûr allouer de l'espace mémoire dans le tas pour stocker le nouveau maillon.

    1. Identifier tous les cas limites pour la valeur `l`. Réfléchir à quels tests on pourrait écrire pour les identifier dans un programme C.
    2. Dans le fichier `liste.c`, implémenter la fonction `append`.

!!!example "Question 4"
    Dans cette question, on veut supprimer le maillon le plus à droite d'une liste doublement chaînée **non vide**. Cette fonction aura pour prototype :
    ```c title="liste.h (extrait)"
    Domino pop(Liste *l)
    ```
    Cette fonction renvoie la valeur de domino qui était stockée dans le maillon supprimé.

    1. Identifier tous les cas limites pour la valeur `l`. Réfléchir à quels tests on pourrait écrire pour les identifier dans un programme C.
    2. Dans le fichier `liste.c`, implémenter la fonction `pop`.
    3. Si cela n'a pas été fait, ajouter une *assertion* pour s'assurer de la précondition : la liste est non vide.
    4. Si cela n'a pas été fait, libérer la mémoire occupée par maillon supprimé.

On vous donne (dans `liste.c`) l'implémentation de la fonction :
```c
void free_liste(Liste *l);
```
qui effectue une série d'appels à votre fonction `pop` pour libérer entièrement de la mémoire une liste.

### :dancer: B. Utilisation des liens dansants

Dans cette partie on va utiliser une petite astuce de programmation proposée par [Donald Knuth](https://fr.wikipedia.org/wiki/Donald_Knuth) dans son algorithme des [liens dansants](https://en.wikipedia.org/wiki/Dancing_links) et qui est particulièrement utile dans le cas des algorithmes de backtracking.

Knuth fait la remarque suivante : si on dispose d'une liste doublement chaînée $L$ et que $m$ est un maillon de cette liste alors l'algorithme :
```
suivant(precedent(m)) <- suivant(m)
precedent(suivant(m)) <- precedent(m)
```
supprime le maillon $m$ de la liste $L$. Jusque là rien de révolutionnaire...

Il ajoute ensuite : maintenant si le maillon $m$ a été gardé intact (non supprimé de la mémoire) :
```
suivant(precedent(m)) <- m
precedent(suivant(m)) <- m
```
remet la liste exactement dans son état précedent.

Autrement dit, ces deux mini-algos permettent de supprimer un maillon donné, puis d'annuler cette suppression (un peu comme un *undo* ou Ctrl-Z). C'est particulièrement utile dans les algorithmes de backtracking où on effectue une action et si la suite échoue on annule l'action et on en essaye une autre.

!!!example "Question 5"
    Dans cette question, enlever provisoirement un maillon d'une liste avec la méthode des liens dansants. Cette fonction aura pour prototype :
    ```c title="liste.h (extrait)"
    void enlever_maillon(Liste *l, Maillon *m)
    ```
    Les paramètres sont une liste `l` et un pointeur `m` vers l'un des maillons de la liste.
    Cette fonction **modifiera** la liste `l`, par contre elle **ne modifiera pas** le maillon `m`. De surcroît, elle ne libérera pas la mémoire allouée pour `m` car on souhaite pouvoir le remettre dans la liste ultérieurement.

    1. Identifier tous les cas particulier en fonction de `l` et de `m`. J'en ai personnellement identifié trois... Réfléchir à quels tests on pourrait écrire pour les identifier dans un programme C.
    2. Dans le fichier `liste.c`, implémenter la fonction `enlever_maillon`.

!!!example "Question 6"
    Dans cette question, on souhaite programmer *l'annulation* de la suppression d'un maillon (effectuée en question 5) toujours d'après la méthode des liens dansants. Cette fonction aura pour prototype :
    ```c title="liste.h (extrait)"
    void remettre_maillon(Liste *l, Maillon *m)
    ```
    Les paramètres sont une liste `l` et un pointeur `m` vers le maillon `m` qui a été supprimé de la liste (mais conservé intact en mémoire). 
    Cette fonction **modifiera** la liste `l`, par contre elle **ne modifiera pas** le maillon `m`. 

    1. Identifier tous les cas particulier en fonction de `l` et de `m`. J'en ai personnellement identifié trois... Réfléchir à quels tests on pourrait écrire pour les identifier dans un programme C.
    2. Dans le fichier `liste.c`, implémenter la fonction `remettre_maillon`.


## :simple-sitepoint: 4. Implémentation du backtracking

On s'attaque maintenant à la programmation du backtracking (retour sur trace) en lui-même. Pour cela on maintiendra en mémoire deux listes doublement chaînées :

- une liste `sac` : qui contient tous les dominos encore disponibles pour former la chaîne de dominos
- une liste `chaine` : qui représente la chaîne de domino actuellement en cours de construction, les dominos de cette liste auront des enchainements valides

L'algorithme est le suivant :

- Si le sac est vide : c'est gagné
- Sinon, on parcourt les maillons `m` du `sac`
- Pour chaque maillon `m` :
    * S'il est valide d'ajouter le maillon correspondant à droite de la `chaine` (éventuellement après rotation) : on supprime (temporairement) `m` du `sac`, on ajoute le domino à droite de la `chaine` et on recommence récursivement avec ce nouveau sac et cette nouvelle chaîne.
    * Si l'appel récursif a échoué on replace `m` dans le sac avec la méthode des liens dansants, on enleve le domino correspondant de la `chaine` et on continue le parcours.
    * Si l'appel récursif réussit, on renvoie `true` sans rien changer à `chaine` (c'est gagné)
- Si on arrive à la fin du parcours du sac sans jamais avoir réussi le backtracking alors on renvoie `false`. 


Le prototype de la fonction correspondante sera :
```c title="backtracking.h (extrait)"
bool bt_chaine(Liste *sac, Liste *chaine)
```

!!!example "Question 7"
    Implémenter dans `backtracking.c` la fonction `bt_chaine`. Pour vous aider un squelette vous est fourni.

!!!example "Question 8"
    Tester votre programme sur les différents jeux de tests (fichiers `.txt`). Combien de dominos réussissez-vous à enchainer ? Réfléchir à la complexité de l'approche par backtracking.

!!!abstract "Remarque"
    Il existe une méthode beaucoup plus efficace que le backtracking, reposant sur les circuits eulériens dans les multi-graphes, pour résoudre ce problème.
