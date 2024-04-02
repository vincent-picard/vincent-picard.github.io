# Couplage maximal dans un graphe biparti

## 1. Graphes bipartis

Les **graphes bipartis** sont une classe de graphes utile pour modéliser des situations pratiques.

**Notation :** Si $G = (S, A)$ est un graphe orienté ou non, on notera $xy \in A$ pour dire l'arc $(x, y)$ ou l'arête $\{x, y\}$ est dans $A$.

!!! abstract "Définition"
    Un graphe $G = (S, A)$ orienté ou non est **biparti** s'il existe une **partition** de $S$ en deux ensembles $S = U \sqcup V$ tels que :

    $$ \forall xy \in A, \quad (x \in U \land y \in V) \lor (x \in V \land y \in U)$$

On rappelle que **partition** signifie :

- $S = U \cup V$ : $U$ et $V$ **recouvrent** tout l'ensemble à partitionner
- $U \cap V = \varnothing$ : les parties $U$ et $V$ sont **disjointes**

Souvent, on décrit un graphe biparti en donnant la partition à considérer dans ce cas on pourra écrire : soit $G = (U \sqcup V, A)$ un graphe biparti.

!!! example "Exemple : un graphe biparti"
    <figure>
    ![Un graphe biparti](fig/bipartite/bipartite-1.svg)
    </figure>


!!! example "Exemple : Vocabulaire et textes"
    On peut considérer le graphe non orienté biparti $G = (U \sqcup V, A)$ dans lequel $U$ est un ensemble fini de mots (un vocabulaire) et $V$ un ensemble de textes. On construit alors une arête $mt \in A$ lorsque le mot $m$ apparaît dans le texte $t$.

!!! example "Exemples en biologie, en écologie et en médecine"
    L'image suivante montre plusieurs exemples de modélisations à l'aide de graphes bipartis, en biologie, en écologie et en médecine.
    <figure>
    ![Exemples en biologie](fig/bipartite_biology.jpeg) 
    <figcaption>Extrait de "Bipartite graphs in systems biology and medicine: a survey of methods and applications", Gigascience, Pavlopoulos *et al.*, 2018</figcaption>
    </figure>

D'après la proposition suivante, il existe d'autres manières de parler de graphes bipartis sans les nommer.

!!! tip "Proposition"
    Soit $G = (S, A)$ un graphe non orienté, on a équivalence entre :

    1. $G$ est biparti
    2. $G$ est 2-colorable
    3. $G$ n'admet aucun cycle de longueur impaire

??? note "Démonstration"
    
    - (1) implique (2) : il suffit de colorer tous les sommets de $U$ en bleu et tous les sommets de $V$ en rouge
    - (2) implique (3) : si on considère par l'absurde un cycle de longueur impaire $(x_1, \dots, x_{n-1}, x_n = x_1)$ de $G$ qui est 2-coloré, alors par imparité, la couleur de $x_1$ est égale à celle de $x_{n-1}$ ce qui est absurde.
    - (3) implique (1) : on travaille composante connexe par composante connexe. Dans une composante connexe, on réalise un parcours de graphe en largeur depuis un sommet $x$, tous les sommets situés à distance paire de $x$ sont placés dans $U$ et ceux à distance impaire dans $V$. S'il existe un arc $st \in A$ entre $s \in U$ et $t \in U$ alors $s$ et $t$ font partie d'un cycle de longueur impaire : c'est absurde. 
   
Cette proposition nous fait aussi remarquer que les graphes acycliques (les arbres et les forêts) sont des graphes bipartis.

## 2. Couplages

!!!abstract "Définition (incidence)"
    Soit $G = (S, A)$ un graphe, si $xy \in A$ est une arête (resp. un arc) du graphe alors on dit que $xy$ est incidente au sommet $x$ (et aussi au sommet $y$)

!!!abstract "Définition (couplage)"
    Soit $G = (S, A)$ un graphe, un **couplage** $M$ est une ensemble d'arêtes (ou d'arcs) qui n'ont pas de sommets en commun, c'est-à-dire tel qu'il n'existe pas deux arêtes (ou arcs) incidentes à un même sommet.

### Cas des graphes bipartis

!!!example "Exemple : le bal"
    On considère un bal où il y a $n$ danseuses et $m$ danseurs. On construit le graphe biparti $G = (U \sqcup V, A)$ où $U$ est l'ensemble des danseuses et $V$ l'ensemble des danseurs. Dans ce graphe, il existe une arête $uv \in A$ si $u$ et $v$ sont d'accord pour danser ensemble. On voit sur cet exemple qu'un couplage est une affectation possible danseuses-danseurs où tout le monde est d'accord sur son ou sa partenaire.

Soit $G = (U \sqcup V, A)$ un graphe biparti, on suppose que les sommets de $U$ et $V$ sont numérotés : $U = \{a_0, a_1, \dots, a_{n-1}$ et $V = \{b_0, b_1, \dots, b_{m-1}$. Informatiquement un couplage $M$ peut se représenter par un tableau $T$ de longueur $n$ dans lequel :

- Si $(u_i, v_j) \in M$ alors $T[i] = j$
- Sinon $T[i] = -1$

!!!exercise "Exercice"
    Écrire une fonction en langage C vérifiant si un couplage est correct :
    ```c
    bool verifie(bool adj[MAX][MAX], int T[MAX], int n, int m)
    ```
    Dans ce prototype `NMAX` designe une constante supérieure à $n$ et $m$ et `adj` est un tableau bi-dimensionnel stockant la *matrice d'adjacence* du graphe. On suppose que les sommets de $U$ sont les sommets numérotés de $0$ à $n-1$ et les sommets de $V$ les sommets de $n$ à $n-m-1$.

## 3. Couplages maximaux

Je donne la définition générale d'un couplage maximal mais le programme précise qu'on se place dans le cadre des graphes bipartis.

!!!abstract "Définition (couplage maximal)"
    Soit $G = (S, A)$ un graphe, un couplage $M$ est un **couplage maximal** si $\mathrm{Card}(M)$ est maximal parmi tous les couplages possibles.

On dira que $\mathrm{Card}(M)$ est la **taille du couplage**. Un couplage maximal est donc un couplage de taille maximale.

!!!example "Exemple : crise médicale"
    Une crise médicale surgit dans laquelle $n$ patients ont besoin de soins urgents et $m$ médecins sont disponibles. On construit un graphe biparti $G = (U \sqcup V, A)$ où $U$ est l'ensemble des patients, $V$ l'ensemble des médecins, et il existe un arête $(u, v) \in A$ ssi le médecin $v$ peut traiter le patient $u$. Avec cet exemple, on constate qu'un couplage est une affectation possible d'un médecin à un un patient. Un couplage **maximal** correspondra à une affectation de médecins qui maximise le nombre de patients traités.

!!!bug "Attention !"
    Un couplage peut être maximal au sens de l'inclusion sans être un couplage maximal.
    
### A - Recherche exhaustive

Soit $G = (S, A)$ un graphe.
La méthode exhaustive peut être employée pour déterminer un couplage maximal. Par exemple, on construit un arbre binaire de hauteur $|A|$ chaque profondeur représente le choix de prendre ou de ne pas prendre l'arête numéro $i$ dans le couplage. Chaque feuille de l'arbre correspond donc à une partie de $A$ : on vérifie s'il s'agit d'un couplage et conserve celui de cardinal maximum.

Cette méthode est très coûteuse : $O(2^{|A|})$.

On peut l'améliorer en :

- vérifiant à chaque arête s'il est possible de la prendre dans le couplage en cours de construction (et donc élaguer le choix 'oui' dans le cas où c'est impossible)
- utiliser la méthode de *séparation et évaluation* (*Branch and bound*) : on peut au fur et a mesure de la recherche éliminer les arêtes incidentes à un sommet déjà choisi, le nombre d'arêtes restantes nous permet alors de majorer la taille du couplage que l'on pourra former.

Dans tous les cas, cette méthode est coûteuse.

### B - Chemins augmentants

Les chemins augmentants permettent d'obtenir une méthode efficace pour la recherche d'un couplage maximal.

!!!abstract "Définition (chemin alternant)"
    Soit $G = (S, A)$ un graphe et $M$ un couplage pour ce graphe. Un chemin est dit **alternant relativement à $M$**, s'il alterne entre une arête dans $M$ et une arête n'appartenant pas à $M$.

!!!note "Remarque"
    L'alternance peut commencer ou non par une arête dans $M$.

!!!abstract "Définition"
    Soit $G = (S, A)$ un graphe, $M$ un couplage et $C$ un chemin dans $G$. Le chemin $C$ est dit **augmentant** pour notre couplage $M$ si :

    1. $C$ est un chemin alternant relativement à $M$
    2. $C$ commence et termine par un sommet qui n'est pas aparié dans le couplage $M$ (il n'existe pas d'arête du couplage incidente à ce sommet).


Un chemin est augmentant si il commence et finit par un sommet non apparié.

Dans la suite on utilisera l'opérateur de **différence symétrique** entre deux ensembles :

$$X \Delta Y = (X \cup Y) \setminus (X \cap Y)$$

Pour simplifier les notations, on confondra par abus un chemin avec son ensemble d'arêtes ce qui permettra aussi d'appliquer cet opérateur sur les chemins.

!!!tip "Proposition"
    Soit $G = (S, A)$ un graphe, $M$ un couplage de cardinal $k$ et $C$ un chemin augmentant, alors $M \Delta C$ est un couplage de cardinal $k + 1$.

!!!note "Démonstration"
    - Comme les sommets de départ et d'arrivée ne sont pas appariés et que $C$ est alternant, on voit que $M' = M \Delta C$ contiendra une arete de plus que $M$, d'ou le cardinal $k + 1$. 
    - Il faut maintenant vérifier que c'est bien un couplage. Soit $(x,y)$ une arete dans $M' = M \Delta C$. Dans le chemin $C$, il apparaît le sous-chemin $(a, x, y, b)$ tel que $(a, x) \in M$,  $(x, y) \not \in M$ et $(y, b) \in M$. Comme $M$ est un couplage $(a, x)$ est la seule arete incidente à $x$ donc si on l'enleve $x$ n'est touché par plus personne donc (x, y) est la seule arête incidente à $x$ dans $M'$. Il en va de meme pour $y$. Donc $M'$ est bien un couplage.

Cette proposition est intéressante car elle donne une méthode pour améliorer un couplage $M$ : rechercher un chemin augmentant. On ne sait toutefois pas encore si un couplage qui n'admet pas de chemin augmentant est bien maximal. C'est l'objet du théorème suivant.

!!!tip "Théorème (Berge)"
    Un couplage $M$ est maximal si et seulement s'il n'admet pas de chemin augmentant.

!!!note "Démonstration"
    - La proposition précédente montre le sens direct par contraposition
    - Montrons le sens réciproque : soit $G = (S, A)$ un graphe et $M$ un couplage n'admettant pas de chemin augmentant. Supposons par l'absurde que $M$ ne soit pas maximal et notons $M'$ un meilleur couplage. On considère alors $H$ le sous-graphe de $G$ induit par les arêtes de l'ensemble $M \Delta M'$. Dans ce graphe un sommet ne peut être incident qu'à au plus deux arêtes : une de $M$ et une de $M'$, les composantes connexes de $H$ sont donc de trois types possibles :
        1. Un sommet isolé
        2. Un cycle alternant entre des arêtes de $M$ et de $M'$
        3. Un chemin alternant entre des arêtes de $M$ et de $M'$ de longueur impaire. 
    - Puisque $M'$ est plus grand que $M$, il en découle que $H$ contient une composante connexe possédant plus d'arêtes de $M'$ que d'arêtes de $M$. Cette composante ne peut être que du troisième type : un chemin alternant qui commence par un sommet non apparié dans $M$ et qui termine par un sommet non apparié dans $M$. Donc c'est un chemin augmentant, c'est absurde.

On obtient donc une méthode algorithmique pour construire un couplage de cardinal maximal :

1. Initialiser avec le couplage vide $M = \varnothing$
2. Tant qu'il existe un chemin augmentant $C$, faire $M \gets M \Delta C$
3. Retourner $M$

Dans le cas d'un graphe biparti, la recherche d'un chemin augmentant peut s'obtenir facilement à l'aide d'un parcours de graphe en faisant les quelques remarques suivantes :
- Le chemin est alterné, donc dans le parcours on prend garde à alternativement prendre un arc pas dans $M$ et un arc dans $M$. 
- Le chemin doit commencer et terminer par un sommet non apparié. On peut arrêter le parcours dès que l'on a trouvé un chemin augmentant, c'est-à-dire quand on tombe sur un sommet non apparié.
- Il est de longueur impaire donc commence par un sommet de $U$ (resp. V) et termine par un sommet de $V$ (resp. U)$. On peut donc se restreindre par symétrie aux sommets de $U$ comme point de départ.

Ainsi la recherche de chemin augmentant s'effectue avec une complexité $O(|U| + |V| + |A|)$. Cette recherche est répétée au plus $k$ fois où $k \leq \min(|U|, |V|)$ est la taille d'un couplage maximal.
