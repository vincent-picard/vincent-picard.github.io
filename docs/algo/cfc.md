# Composantes fortement connexes

## 1. Rappels sur la connexité

### A. Composantes connexes

On notera $x \Rightarrow^* y$ la relation binaire : il existe un chemin du sommet $x$ vers le sommet $y$ dans un graphe donné.

!!! tip "Proposition"
    Dans un graphe $G = (S, A)$ **non orienté**, la relation binaire $\Rightarrow^{*}$   est une **relation d'équivalence**.


!!! abstract "Définition (composantes connexes)"
    Dans un graphe non orienté, les classes d'équivalence de $R$ sont appelées **composantes connexes** du graphe.

!!! note "Remarque"
    On peut étendre la définition de composante connexe dans un graphe orienté en oubliant l'orientation des arcs.

#### Algorithmes : les parcours de graphes
Les parcours de graphes, peu importe lequel, permettent de déterminer les composantes connexes d'un graphe. Revoir le cours de 1ère année et le chapitre 3 si besoin.

### B. Composantes fortement connexes

!!! tip "Proposition"
    Dans un graphe $G = (S, A)$ **orienté**, la relation binaire  $xRy <=> (x \Rightarrow^* y \land y \Rightarrow^* x)$ est une relation d'équivalence.

!!! abstract "Définition (composantes fortement connexes)"
    Dans un graphe **orienté**, Les classes d'équivalences de $R$ sont appelées **composantes fortement connexes** (CFC) du graphe.

!!! note "Remarque"
    Dans le cas des graphes non orientés, les notions de composantes connexes et de composantes fortement connexes coïncident, l'étude des composantes fortement connexes n'est donc intéressante que dans le contexte des graphes orientés.


!!! tip "Proposition"
    Soit $G = (S, A)$ un graphe, une partie $X$ de $S$ est une CFC si et seulement si :

    1. $\forall x, y \in X, xRy$ c'est-à-dire qu'il existe un chemin de $x$ vers $y$ et réciproquement. 
    2. $X$ est *saturée*, c'est-à-dire qu'il n'existe pas de partie $Y$ telle que $X \subset Y$ strictement et $Y$ vérifie 1. Autrement dit, $X$ est une partie maximale pour l'inclusion qui vérifie 1.

Le programme de 1ère année ne nous dit pas comment calculer les composantes fortement connexes d'un graphe.

## 2. Tri topologique

On se place maintenant dans le cadre d'un graphe $G = (S, A)$ orienté.

Le parcours en profondeur (DFS) récursif d'un graphe $G = (S, A)$ permet d'obtenir un ordonnancement des sommets d'un graphe posséndant des propriétés intéressantes.

Commençons par rappeler l'algorithme récursif de parcours en profondeur.
On utilisera le système de couleurs suivant pour marquer les sommets :

- vert : sommet non exploré
- orange : sommet en cours d'exploration
- rouge : sommet dont l'exploration est terminée

```
Variables globales : 
    un tableau de couleur c[x] pour chaque sommet x
    une variable entiere t representant le temps logique

Initialisation :
    c[x] <- vert pour tout sommet x
    t <- 0

fonction EXPLORE(x: sommet) :
    Si c[x] == vert Alors
        c[x] <- orange
        d[x] <- t
        t <- t + 1
        Pour tout y dans Voisins(x) Faire
            EXPLORE(y)
        FinPour
        f[x] <- t
        t <- t + 1
    Fin Si
```

Ainsi, nous avons ajouter quelques instructions pour enregistrer à quels instants le parcours d'un sommet débute et finit.


!!! tip "Proposition"
    Les paires d'évenements $d(x) / f(x)$ ordonnées par le temps logique d'exécution forment une expression bien parenthésée.

!!! note "Démonstration"
    On procède par récurrence forte le nombre de sommets verts dans $G$ restants dans le graphe.

    - $P(0)$ : ne produit aucun événement : on produit alors $u = \varepsilon$
    - $(\forall k \in [| 1, n |], P(k)) \Rightarrow P(n+1)$ : On suppose qu'il reste $n+1$ sommets à explorer. On explore le sommet $x$. Si $x$ est vert (sinon la séquence produite est $\varepsilon$) il passe orange et on déclenche une suite de $p$ EXPLORE(y). Par hypothèse de récurrence forte, les séquences produites $v_1, \dots, v_p$ sont bien parenthésées. Ainsi la séquence produite au final sera : $d(x) v_1 \dots v_p f(x)$ qui est bien parenthésée.

!!! abstract "Définition"
    Après l'exploration complète d'un graphe $G$ par parcours en profondeur, on pose $x \leq_T y$ lorsque $f(x) \geq f(y)$. Autrement dit, on ordonne les sommets par date de fin d'exploration : de celui qui termine en dernier à celui qui termine en premier.

La relation $\leq_T$ est une relation d'ordre total sur l'ensemble des sommets.

!!! example "Exemple"
    Soit le graphe :
    ```
    A -> B
       / |
      L  v
    D <- C -> E
    ```
    Un exemple d'exécution du parcours en profondeur depuis $A$ est :
    ```
    d(A) d(B) d(C) d(D) f(D) d(E) f(E) f(C) f(B) f(A)
    ```
    L'ordre $\leq_T$ obtenu est donc : $A \leq_T B \leq_T C \leq_T E \leq_T D$

<!--
L'ordre $\leq_T$ possède la bonne propriété suivante :

!!! tip "Proposition"
    Si $x \leq_T y$ et qu'il existe un chemin de y à x (chemin retour) alors il existe un chemin de x à y.

!!! note "Démonstration"
    On suppose $x$ différent de $y$ (sinon la propriété est évidente), on procède par distinction de cas sur tous les parenthésages possibles des événements liés à $x$ et $y$ :

    - Cas 1 : d(y) f(y) d(x) f(x)
    Impossible car $y \Rightarrow^* x$ donc l'exploration de $y$ va rencontrer $x$ avant de terminer. Remarque : si des sommets sur le chemin de y à x ont déjà été exploré c'est que x a déjà été exploré auparavant.
    - Cas 2 : d(x) d(y) f(y) f(x)
    Cela signifie que l'exploration de x a conduit à trouver y donc on a un chemin de x -> y
    - Cas 3 : d(y) d(x) f(x) f(y)
    on aurait alors $y \leq_T x$ et donc x = y. Ce cas est exclus.
    - Cas 4 : d(x) f(x) d(y) f(y)
    on aurait alors $y \leq_T x$ et donc x = y. Ce cas est exclus.
-->

#### A. Conséquence dans le cas d'un DAG

On rappelle qu'un DAG est un graphe orienté sans cycle (directed acyclic graph).

!!! abstract "Définition (ordre topologique)"
    Soit $G = (S, A)$ un graphe et $\leq$ un ordre total sur ses sommets. On dit qu'un tel ordre est un **ordre topologue** lorsque :

    $$
    (x,y) \in A \quad \Rightarrow (x \leq y)
    $$

Autrement dit, si on dessine le graphe linéairement avec les sommets de gauche à droite dans l'ordre $\leq$, alors tous les arcs vont de la gauche vers la droite.

Cela est très important pour résoudre les **problèmes de dépendances** : si l'arc $x \to y$ matérialise le fait que $y$ dépend de $x$, alors un ordre topologique est un ordre pour lequel on peut traiter les sommets en respectant les dépendances.

!!! tip "Proposition"
    Si $G = (S, A)$ est un DAG alors l'ordre $\leq_T$ est un ordre topologique. C'est-à-dire :

    $$
    (x,y) \in A \quad \Rightarrow (x \leq_T y)
    $$


!!! note "Démonstration"
    Soit $xy \in A$ une arête. On procède par disjonction de cas sur tous les parenthésages corrects possibles des événements liés à $x$ et $y$ :

    - Cas 1 : d(y) f(y) d(x) f(x) :
    Dans ce cas $x \leq_T y$
    - Cas 2 : d(x) d(y) f(y) f(x) :
    Dans ce cas $x \leq_T y$
    - Cas 3 : d(y) d(x) f(x) f(y) :
    Ce cas est impossible : cela signifie qu'il existe un chemin de $y$ vers $x$, mais comme $xy \in A$ on aurait un cycle.
    - Cas 4 : d(x) f(x) d(y) f(y)
    Ce cas est impossible : cela voudrait dire que le DFS depuis $x$ s'est terminé sans que $y$ ne soit exploré mais $xy \in A$.

### B. Conséquence dans le cas général 

Dans le cas où le graphe contient des cycles un ordre topologique ne peut pas exister (pourquoi ?).

On possède toutefois la propriété suivante :

!!!tip "Proposition"
    Soit $G = (S, A)$ un graphe. Soit $x$ et $y$ appartenant à des composantes fortement connexes **distinctes** tels que $x \leq_T y$ alors il ne peut exister de chemin de $y$ vers $x$.

!!! note "Démonstration"
    Supposons par l'absurde l'existence d'un tel chemin de $y$ vers $x$ et raisonnons ensuite par disjonction de cas sur tous les parenthésages corrects possibles des événements liés à $x$ et $y$ :

    - Cas 1 : d(y) f(y) d(x) f(x) :
    On a un chemin de $y$ vers $x$ mais quand on explore $y$ on ne trouve pas $x$ : c'est absurde.
    - Cas 2 : d(x) d(y) f(y) f(x) :
    Dans ce cas cela signifie qu'il y a un chemin de $x$ vers $y$ donc $x$ et $y$ seraient dans la même CFC : c'est absurde.
    - Cas 3 : d(y) d(x) f(x) f(y) :
    Exclu car $f[y] < f[x]$.
    - Cas 4 : d(x) f(x) d(y) f(y)
    Exclu car $f[y] < f[x]$.


<!--
On peut toutefois raisonner sur le *graphe des composantes fortement connexes* aussi appelé *graphe quotient* :

!!!abstract "Définition (graphe des CFC)"
    Soit $G = (S, A)$ un graphe non orienté. Le *graphe des composantes fortement connexes* de $G$ noté $G_{CFC}$ est le graphe dans lequel :

    - Les sommets sont les CFC de $G$
    - Il existe un arc $C_1 \to C_2$ si et seulement si il existe $x \in C_1$ et $y \in C_2$ tels que $(x, y) \in A$.

!!!tip "Proposition"
    $G_{CFC}$ est acyclique (c'est un DAG).

Ceci découle du fait qu'un cycle entre CFC signifieraient que tous les sommets des CFC de ce cycle sont en fait équivalents (il existe un chemin de l'un vers l'autre dans les deux sens). C'est absurde.

De plus on peut étendre les notions de dates de début et fin d'exploration ainsi :

$$ d[C] = \min_{x \in C} d[x] $$

$$ f[C] = \max_{x \in C} f[y] $$

On a alors la propriété que $\leq_T$ ordonne les composantes fortement connexes selon un ordre topologique par rapport à $G_{CFC}$ :

!!!abstract "Proposition"
    Soit $G = (S, A)$ un graphe et $G_{CFC} = (S_{CFC}, A_{CFC})$ son graphe des CFC alors : 

    $$
    (C_1,C_2) \in A_{CFC} \quad \Rightarrow f[C_2] \leq_T f[C_1]
    $$
-->
## 3. Algorithme de Kosaraju

L'algorithme de Kosaraju est un algorithme efficace pour calculer les composantes fortement connexes d'un graphe orienté.
```
KOSARAJU(G = (S,A))
    Gbar <- transpose(G)
    ordre <- tri_topo(G)
    composante <- 0
    Pour tout x dans S selon ordre :
        EXPLORER(x) par DFS dans Gbar en étiquettant tout somme exploré par composante 
        composante <- composante + 1
    Fin Pour
```

!!! note "Démonstration"
    Remarquons déjà que les CFC de $G$ et de $G^t$ sont les mêmes.
    On procède par récurrence sur le nombre de composantes connexes produites :
    P(k) : les k premiers arbres d'exploration obtenus lors du parcours de $G^t$ sont des CFC

    - $P(0)$ est évidemment vraie il n'y a aucun arbre
    - $P(k) \Rightarrow P(k+1)$ :  
    On note $u_{k+1}$ la racine de l'arbre d'exploration $T_{k+1}$ et $C_{k+1}$ la CFC de $u_{k+1}$. Montrons que $T_{k+1} = C_{k+1}$.

        - **Tous les sommets de la composante $C_{k+1}$ sont atteints par $T_{k+1}$** : en effet par hypothèse de récurrence, aucun sommet de $C_{k+1}$ n'est actuellement exploré, donc l'exploration par parcours en profondeur depuis $u_{k+1}$ va tous les découvrir c'est-à-dire que $C_{k+1} \subset T_{k+1}$.
        - **Si un sommet $y$ est atteint par $T_{k+1}$ alors il est dans $C_{k+1}$**. Supposons qu'il ne le soit pas c'est-à-dire que $y$ appartient à une CFC différente de $x$. On a de plus $x \leq_T y$ car on explore les sommets dans l'ordre $\leq_T$. Donc d'après la proposition précédente, il n'existe pas de chemin de $y$ vers $x$ dans $G$, ce qui signifie qu'il n'existe pas de chemin de $x$ vers $y$ dans $G^t$ c'est absurde. Donc $T_{k+1} \subset C_{k+1}$.
**Remarque :** Cela ne change rien si on avait effecuté le tri topologique sur $G^t$, puis le parcours dans $G$. 

**Complexité :** Notons $n$ le nombre de sommets et $m$ le nombre d'arcs; on suppose le graphe représenté par liste d'adjacences. Le tri topologique est un parcours de graphe donc de complexité $O(n + m)$ de complexité linéaire, le calcul de transposée est aussi linéaire $O(n + m)$, enfin le second parcours en profondeur est de complexité linéaire $O(n+m)$. Conclusion : **l'algorithme de Kosaraju est de complexité linéaire par rapport à la taille du graphe $O(n + m)$**
## 4. 2-SAT est dans P

On sait que 3-SAT est NP-complet d'après le théorème de Cook, mais qu'en est-il de 2-SAT ?

Si a est un litteral on notera bar(a) le litteral contraire :
bar(x) = non(x)
bar(non(x)) = x

Pour toute formule F de 2-SAT, on peut construire le graphe d'implications G_F =(S, A)
où S est l'ensemble des littéraux qu'on peut former avec toutes les variables de S

(a ou b) <=> (non(non(a)) ou b) <=> (non(a) -> b)
donc pour toute clause de la formule F on ajoute deux arcs : non(a) -> b et non(b) -> a, c'est graphe représentent les implications existant entre littéraux.

Exemple : (x ou non(y)) et (x ou z) et (non(y) ou non(z)) et (z ou non(x))

#### Remarque 1
S'il existe une valuation de phi satisfaisant F alors phi est constante sur chaque CFC de G_F.

#### Remarque 2
S'il existe une valuation de phi et C une CFC, alors phi(bar(C)) et phi(C) ont des valeurs booléennes contraires.
En effet, le tiers exclu est une tautologie.

#### Remarque 3
Le graphe possède une certaine forme de symétrie : si a->b est un arc de G alors non(b) -> non(a) est un arc de G.

#### Proposition
F est satisfiable ssi il n'existe pas de CFC dans G_F contenant un litteral et son contraire

Dem :
=> on raisonne par contraposée supposons qu'il existe une CFC contenant un litteral et son contraire, soit phi une valuation satisfaisant F, alors d'après la remarque 1, phi est constante sur C donc vaut faux pour tous les littéraux de C ou vrai... c'est absurde. Donc F n'est pas satisfiable
<= donnons un algorithme pour construire une valuation qui satisfait F
on construit H le graphe des CFC de GF, c'est un DAG
On prend une CFC C qui n'a pas de predecesseur et on la pose vrai (tous ses litteraux sont vrais). C'est possible car il n'y a pas un llitteral et son contraire dans la clause. Donc toutes les implications dans C sont vraies.
On pose donc necessairement bar(C) à vrai. Toutes les implications dans C sont vraies aussi( faux -> faux) 
En raison de la remarque 3 on a que bar(C) n'a pas de successeur.
enfin toutes les implications sortantes de C sont vraies (car faux -> ?? est toujours vrai) et toutes les implications entrantes dans bar(C) sont vraies (car ?? -> vrai est toujours vrai). En itérant ainsi on construit G tel que toutes les implications sont vraies donc F est vrai.

Remarque : c'est équivalent de dire on va faire le tri topo de H et ensuite considérer les cfc de H dans cet ordre. Les CFC non marquées sont marquées faux (et en meme temps on marque l'autre vrai).

D'après cette proposition : pour vérfier si F est satisfisable il suffit de construire son graphe d'implication, calculer ses CFC, et regarder si elles ne contiennent pas un littéral et son contraire (temps linéaire). Donc 2-SAT est dans P.

De plus, la démonstration donne un algorithme pour calculer une valuation qui satisfait F. 
