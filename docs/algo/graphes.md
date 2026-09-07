# Graphes, généralités et parcours 

## 1. Rappels sur les graphes

Nous avons rappelé en cours :

- Définition d'un graphe orienté ou non
- Représentation d'un graphe par matrice d'adjacence ou listes d'adjacence
- Définition de chemin dans un graphe
- Graphe pondérés : poids d'un chemin, distance entre deux sommets, notion de chemin optimal pour aller d'un sommet à un autre.


## 2. Rappels sur les parcours de graphes

Les différents algorithmes sont écrits ici :

- [Parcours : tous les algorithmes](/pdf/parcours_algo.pdf)

et on trouve des animations de parcours ici :

- [Parcours : illustrations](/pdf/parcours_exemples.pdf)

Nous avons rappelé en cours :

- ALGO 1 : Parcours de graphe générique : il est nécessaire de marquer les sommets explorés pour éviter qu'ils soient ré-explorés.
- ALGO 2 : Parcours en profondeur avec une pile 
- ALGO 3 : Parcours en profondeur avec la récursivité
- ALGO 4 : Parcours en largeur avec une file
- ALGO 5 : Parcours en largeur simplifié
- ALGOS 6, 7, 8 : Construction de l'arborescence dans les différents algorithmes de parcours

## 3. Algorithme de Dijkstra

Dans l'algorithme de Dijkstra on suppose que le graphe est **pondéré par des poids positifs**.

L'algorithme est décrit ici (ALGO 9) :


- [Parcours : tous les algorithmes](/pdf/parcours_algo.pdf)

et on trouve une animation ici :

- [Parcours : illustrations](/pdf/parcours_exemples.pdf)

Dans l'algorithme de Dijkstra on distingue trois types de sommets :

- les sommets **fermés** (noirs) qui ont déjà été explorés
- les sommets **ouverts** (gris) qui ont été rencontrés mais pas encore traités
- les autres sommets (blancs)

On maintient également pour chaque sommet $x$ une valeur $g[x]$ qui est le coût du chemin de $x_d$ à $x$ dans l'arboresence du parcours en cours de counstruction.

L'idée consiste alors à chaque étape à choisir le sommet ouvert qui minimise la valeur de $g[x]$ comme prochain sommet à traiter.

!!!tip "Proposition (preuve de correction partielle)"
    L'algorithme de Dijkstra vérifie *l'invariant* suivant :

    $$
    \text{ Si } x \text{ est fermé alors } g[x] = \delta(x_d, x)
    $$
En particulier comme $g[x]$ est le coût du chemin de $x_d$ à $x$ dans l'arborescence du parcours, on en déduit que l'algorithme de Dijkstra construit une arborescence de chemins optimaux depuis $x_d$ vers tout sommet exploré lors du parcours.

!!!note "Démonstration"
    L'invariant est évidemment vrai au départ car il n'y a aucun sommet fermé.

    Supposons l'invariant vérifié à une étape et considérons $x$ le sommet choisi pour être exploré à l'étape suivante. Montrons que $g[x] = \delta(x_d, x)$. On procède par double inégalités.

    - Comme $g[x]$ est le coût d'un chemin de $x_d$ à $x$ (celui donné par l'arborescence du parcours), on en déduit que $\delta(x_d, x) \leq g[x]$ par définition de $\delta$
    - Considérons un chemin optimal $C$ menant de $x_d$ à $x$. Si ce chemin est de longueur nulle c'est que $x = x_d$ et comme on a posé initialement $g[x_d] = 0$, on a bien $g[x_d] = 0 = \delta(x_d, x_d)$. Sinon le chemin comporte au moins 2 sommets et on note $y$ le premier sommet non fermé sur ce chemin et $z$ son prédécesseur. On a donc $y$ ouvert et $z$ fermé. Ainsi le chemin s'écrit $C = \underbrace{x_d \dots z}_{C_1}\underbrace{y \dots x}_{C_2}$.

    $$
    \begin{align*}
    \delta(x_d, x) &= \text{coût}(C) \\
    &= \text{coût}(C_1) + p(z, y) + \text{coût}(C_2) \\
    &= \delta(x_d, z) + p(z, y) + \text{coût}(C_2) \qquad \text{ car $C$ est optimal donc $C_1$ aussi} \\
    &\geq \delta(x_d, z) + p(z, y) \qquad \text{ car les poids sont positifs} \\
    &\geq g[z] + p(z, y) \qquad \text{ car $z$ est fermé et d'après l'hypothèse d'invariant }\\
    &\geq g[y] \qquad \text { d'après le traitement de l'arc $zy$ lors de l'exploration de $z$ et que les valeurs de $g$ sont décroissantes} \\
    &\geq g[x] \qquad \text{ car $y$ est ouvert et que $x$ est minimise $g$ sur les sommets ouverts}
    \end{align*}
    $$
    
    Conclusion, par double inégalité on a $\delta(x, x_d) = g[x]$.


## 4. Algorithme A*

!!!tip "Proposition (preuve de correction partielle)"
    L'algorithme A étoile vérifie *l'invariant* suivant : Si $x_t$ n'est pas fermé alors il existe un noeud témoin $n$ ouvert, situé sur un chemin optimal de $x_d$ à $x_t$, tel que $g[n] = \delta(x_d, n)$ 

!!!note "Démonstration"
    L'invariant est vrai au départ car on peut prendre $n = x_d$ comme témoin. On a alors bien $g[n] = 0$ d'après l'initialisation de l'algorithme et $\delta(x_d, x_d) = 0$.

    Supposons l'invariant et montrons qu'il se conserve. Considérons $x$ le sommet choisi pour être exploré à l'étape suivante, si $x \not = n$ alors on peut conserver $n$ comme témoin et l'invariant reste vrai. Si $x = n$, on rappelle que $n$ est situé sur un chemin optimal $C$ de $x_d$ à $x_t$, on pose donc $n'$ le noeud successeur de $n$ sur le chemin $C$.

    On a d'une part $g[n'] \geq \delta(x_d, n')$ car $g[n']$ est le poids du chemin actuellement construit de $x_d$ vers $n'$.

    D'autre part on a

    $$
    \begin{align*}
    \delta(x_d, n') &= \text{coût}(C_1) + p(n, n') \\
    &= \delta(x_d, n) + p(n, n') \qquad \text{ car $C$ est optimal donc $C_1$ aussi} \\
    &= g[n] + p(n, n') \qquad \text{ par hypothèse d'invariant} \\
    &\geq g[n'] \qquad \text { d'après le traitement de l'arc $nn'$ lors de l'exploration de $n$ et que les valeurs de $g$ sont décroissantes} \\
    \end{align*}
    $$
    
    Conclusion, par double inégalité on a $\delta(x_d, n') = g[n']$.
    Il reste à justifier que $n'$ est bien ouvert, en fait cela n'est pas toujours le cas. Il y a 4 cas :
    
    - Si $n'$ n'était ni ouvert ni fermé alors il devient ouvert et peut servir de témoin.
    - Si $n'$ était ouvert alors il reste ouvert et peut servir de témoin.
    - Si $n'$ était fermé et qu'on a amélioré sa valeur alors il a été ré-ouvert donc il peut servir de témoin (d'où la nécessité de réouvrir les sommets)
    - Si $n'$ était fermé et qu'on n'a pas amélioré sa valeur c'est que sa valeur est déjà $g[n'] = \delta(x_d, n')$. On recommence alors le même raisonnement avec $n''$ le successeur de $n'$ sur le chemin. Ce processus se termine nécessairement car $x_t$ n'est pas fermé par hypothèse.

Le corollaire est le suivant : lorsqu'on choisit en fin d'alogrithme $x_t$ pour le fermer, on a $f(x_t) = g[x_t]$ car $h(x_t) = 0$ et de plus
$f(x_t) \leq f(n')$ car $x_t$ est choisi comme le noeud qui minimise $f$ sur les sommets ouverts. Donc
$g[x_t] \leq f(n') = g[n'] + h(n')  = \delta(x_d, n') + h(n') \leq \delta(x_d, n') + \delta(n', x_t)$ car l'heuristique est admissible.
mais comme $n'$ est sur le chemin optimal $C$ on a $\delta(x_d, n') + \delta(n', x_t) = \delta(x_d, x_t)$, donc $g[x_t] \leq \delta(x_d, x_t)$. 
Ainsi l'algorithme a bien construit un chemin optimal de $x_d$ à $x_t$.
