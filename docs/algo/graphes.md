# Graphes, généralités et parcours 

## 1. Rappels

### A. Définitions 

Nous avons revu en cours :

- Définition d'un graphe orienté ou non
- Rappels sur l'accessibilité : définition de chemin, de composante connexe

### B. Représentations en machine

Nous avons revu en cours :

- Représentation par matrice d'adjacence
- Représentation par listes d'adjacence
- Représentation implicite

## 2. Parcours de graphe générique

Les parcours de graphes permettent de répondre à la question de l'accessibilité entre deux sommets d'un graphe. Leur étude est fondamentale car ils sont d'une part efficaces et d'autre part constituent souvent un excellent point de départ pour résoudre des problèmes sur les graphes. (exemples : calcul des composantes connexes, existence de cycles, 2-colorabilité, etc)

Un parcours de graphe consiste à explorer les sommets d'un graphe de proche en proche en partant d'un sommet choisi $x_d$. Lors de ce parcours, un certain **marquage** des sommets doit être maintenu afin d'éviter de ré-explorer les sommets qui ont déjà été explorés. Nous distinguerons 3 types sommets :

- Les **sommets non découverts**, qu'on marquera avec la couleur **blanche**
- Les **sommets ouverts**, qu'on marquera avec la couleur **grise** : ces sommets ont été découverts comme voisin d'un sommet exploré, mais ils sont en attente d'être explorés
- Les **sommets fermés**, qu'on marquera avec la couleur **noire** : ces sommets ont été explorés

De plus, on va mémoriser des sommets ouverts, en attente d'être explorés, dans une **structure de données** générique appelée **sac** qui supporte les opérations d'insertion et d'extraction.

!!! abstract "Algorithme : parcours générique"
    <figure>
    ![Parcours de graphe générique](algo/pgenerique/pgenerique.svg)
    </figure>
    
On remarque lors de l'exécution du parcours sur des exemples, qu'un même sommet est en général placé plusieurs fois dans le sac, car il a été découvert séparément par chacun de ses voisins.


Selon la structure de données utilisée pour implémenter concrètement le graphe, on obtient les algorithmes classiques suivants :

- Si le sac est une **pile (LIFO)** on obtient un **parcours en profondeur**
- Si le sac est une **file (FIFO)** on obtient un **parcours en largeur**
- Si le sac est une file de priorité avec les poids d'arêtes on obtient l'algorithme de Prim (hors programme)

Une version simplifiée de ce parcours ne tient compte que de deux "couleurs" : Visité (noir) ou non (blanc/gris). Dans ce cas le changement de couleur du blanc au gris est inutile. Nous verrons qu'il est toutefois utile de faire le distingo surtout lors de l'étude des algorithmes de Dijkstra et de A*.

#### Arborescence du parcours

Il est important de comprendre que tout parcours a pour résultat la construction d'une **arborescence** qui est un arbre représentant les chemins utilisés lors du parcours depuis le sommet $x_d$.

Cet arborescence s'obtient en notant pour chaque sommet exploré son **parent** qui est le sommet qui a permis sa découverte. Plus précisément le **parent** est défini ainsi :

!!! abstract "Algorithme : parcours générique avec arborescence"
    <figure>
    ![Parcours avec arborescence](algo/pgenerique_parent/pgenerique_parent.svg)
    </figure>

Puisqu'un même sommet peut apparaître plusieurs fois dans le sac depuis des sommets différents. La première occurrence à être extraite du sac, désignera le sommet qui sera son parent dans l'arborescence du parcours.

!!! tip "Proposition"
    
    1. À la fin de l'algorithme du parcours, tout sommet $x$ fermé (noir) est accessible depuis $x_d$ par un chemin provenant du sommet $parent[x]$. 
    2. Si un sommet $x$ est accessible depuis $x_d$ alors à la fin du parcours, il sera fermé (de couleur noire).

!!! note "Démonstration"

    1. On fait une preuve par invariant. On pose

    $$ I : \quad \ll \forall x \in S, \  c[x] = Noir \quad \Longrightarrow \quad x_d \leadsto x \text{ (provenant de parent[x])} \gg $$

    2. Se démontre par récurrence sur la longueur du chemin permettant d'atteindre $x$ depuis $x_d$.

    $$ P(n) : \quad \ll \exists u_0 \rightarrow u_1 \rightarrow \dots \rightarrow u_n \text{ avec }\gg $$

 
## 2. Parcours en profondeur (DFS)

## 3. Parcours en largeur (BFS)

## 4. Algorithme de Dijkstra

## 5. Algorithme A*
