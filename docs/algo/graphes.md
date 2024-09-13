# Graphes, généralités et parcours 

## 1. Rappels
### A. Représentations en machine
### B. Parcours de graphe en général

!!! abstract "Algorithme : parcours générique"
    <figure>
    ![Un graphe biparti](algo/pgenerique/pgenerique.svg)
    </figure>
    

Ce parcours générique intervient fréquemment en algorithmique :

- Si le sac est une **pile (LIFO)** on obtient un **parcours en profondeur**
- Si le sac est une **file (FIFO)** on obtient un **parcours en largeur**
- Si le sac est une file de priorité avec les poids d'arêtes on obtient l'algorithme de Prim (hors programme)

Une version simplifiée de ce parcours ne tient compte que de deux "couleurs" : Visité (noir) ou non (blanc/gris). Dans ce cas le changement de couleur du blanc au gris est inutile.

#### Arborescence du parcours

!!! abstract "Algorithme : parcours générique avec arborescence"

    $c[x_d] \gets$ Gris

    Mettre $(\varnothing, x_d)$ dans le sac

    **Tant que** le sac n'est pas vide **faire**

    - prendre un couple $(pred, x)$ du sac

    - **Si** $c[x] \neq$ Noir **alors**

        - $c[x] \gets$ Noir
        - $parent[x] \gets pred$
        - **Pour tout** $xy \in A$ :

            - **Si** $c[y] =$ Blanc **alors** $c[y] \gets$ Gris
            - Mettre $(x, y)$ dans le sac
        - **Fin Pour**

    - **Fin Si**

    **Fin Tant que**

On remarque qu'un même sommet peut apparaître plusieurs fois dans le sac avec des prédecesseurs différents. La première occurrence à être extraite du sac, désignera le prédécesseur qui sera son parent dans l'arborescence du parcours.

## 2. Parcours en profondeur (DFS)

## 3. Parcours en largeur (BFS)

## 4. Algorithme de Dijkstra

## 5. Algorithme A*
