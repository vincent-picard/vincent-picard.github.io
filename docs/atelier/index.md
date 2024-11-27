# Atelier CPGE : coloration de graphes d'intervalles

!!! warning "Début séance"
    1. Faire l'appel
    2. Spécialités NSI 1ère et/ou terminale ?

## 1. Graphes (30 min) 

### A. Définitions et exemples

!!! abstract "Définition (graphe)"
    Un **graphe** $G$ est un couple $(S, A)$ dans lequel :
    
    - $S$ est un ensemble fini de sommets
    - $A$ est un ensemble de **paires** de sommets $\{x, y\}$ avec $x \neq y$

Les graphes interviennent dans la modélisation de nombreux problèmes :

- Calcul d'itinéraires GPS
- Construction d'un emploi du temps
- Optimisation du transport d'un flot de marchandises
- Construction d'un réseau de transport optimal
- Résolution du Rubik's cube
- etc.

!!! example "Les 7 ponts de Königsberg (Euler 1735)"

!!! abstract "Définitions"
    Soit $G = (S, A)$ un graphe connexe (= en une seule partie)

    - deux sommets sont dits **adjacents** lorsque $\{x, y\} \in A$.
    - dans ce cas on dit que $y$ est un **voisin** de $x$ (et aussi $y$ est un voisin de $x$).
    - le **degré** d'un sommet $x \in S$, noté $d(x)$ est le nombre de voisins de $x$.

!!! example "Théorème d'Euler"
    Un graphe possède un chemin Eulérien dans ces deux cas seulement :

    1. Tous les degrés sont pairs
    2. Il y a exactement 2 sommets de dégré impair

!!! example "Problème du loup, de la chèvre et du chou"
    Un fermier souhaite possédant *un chou*, *une chèvre* et *un loup* souhaite traverser une rivière à l'aide d'une barque. Le problème est que la barque est petite et que le fermier ne peut emporter qu'une seule chose avec lui. De plus, il ne peut laisser seuls sans surveillance ni le loup et la chèvre, ni la chèvre et le chou. Comment traverse-t-il la rivière ?
 
    1. Construire un graphe modélisant le problème.
    2. Combien possède-t-il de sommets ? d'arêtes ?
    3. À quoi correspond le degré d'un sommet ?
    4. Combien y a-t-il de solutions à ce problème ?

### B. Représentation informatique d'un graphe

!!! abstract "Définition (listes d'adjacence)"
    Soit $G$ un graphe, on appelle **listes d'adjacence** du graphe l'ensemble des listes de voisins de chaque sommet.

!!! abstract "Représentation d'un graphe par listes d'adjacence"
    Pour représenter un informatiquement un graphe de taille $n$, on peut :
    
    1. Numéroter chaque sommet de 0 à $n-1$
    2. Déterminer la liste des voisins de chaque sommet.
    3. Enregistrer dans un tableau $G$ de taille $n$ chaque liste de voisins, de telle sorte que {\tt G[i]} est lla liste des voisins du sommet d'indice $i$.

```python
G = [[1, 2], [], [0, 3]]
```

!!! example "Calcul du degré d'un sommet" 
    ```python
    def degre(G, i):
        voisins = G[i]
        return len(voisins)
    ```

!!! example "Vérification de chemin"
    Ecrire une fonction qui vérifie qu'une liste de sommets est un chemin du graphe.


### C. Cliques

!!! abstract "Définition (nombre clique)"
    Soit $G$ un graphe, on appelle **nombre clique** de $G$, noté $\alpha(G)$ le *plus grand* entier $k \in \mathbb{N}$ tel qu'il existe une clique de taille $k$ dans $G$.

!!! note "Remarque"
    Un sommet constitue à lui seul une clique de taille 1, donc $\alpha(G) \geq 1$.

## 2. Coloration de graphes (30 min)

!!! abstract "Définition (coloration)"
    Soit $G = (S, A)$ un graphe. Soit $k \in \mathbb{N}^*$ un entier naturel non nul. On appelle $k$-coloration d'un graphe une fonction de coloration $c : S \to \{0, 1, 2, ..., k-1\}$ qui a tout sommet $x$ associe une couleur $c(x)$ et qui vérifie pour tous sommets $x$, $y$, $\{x, y\} \in A \Rightarrow c(x) \neq c(y)$.

Les couleurs sont définies mathématiquement comme des entiers, mais peuvent être vues comme des vraies couleurs. La définition dit que deux sommets adjacents doivent avoir une couleur différente.

!!! abstract "Définition (nombre chromatique)"
    Soit $G$ un graphe, on appelle **nombre chromatique** de $G$, noté $\chi(G)$ le plus petit entier $k \in \mathbb{N}$ tel qu'il existe une $k$-coloration de $G$.

!!! abstract "Définition (coloration optimale)"
    Une coloration est optimale si elle est utilise un nombre minimal de couleur, c'est-à-dire si elle est une k-coloration avec $k = \chi(G)$.

```python
    def verifie_coloration(G, c):
        ...
```

!!! tip "Proposition"
    Soit $G$ un graphe quelconque alors $\alpha(G) \leq \chi(G)$

On remarque sur des exemples que l'égalité n'est pas toujours vraie.

## 3. Graphes d'intervalle (30 min)

!!! abstract "Définition (graphe d'intervalle)"
    Soit $I_0, I_1, ..., I_{n-1}$ $n$ intervalles de la forme $[a, b]$. On appelle graphe d'intervalle de cet ensemble d'intervalle le graphe $G = (S, A)$ défini par :
    
    - $S$ est l'ensemble des intervalles
    - $I$ est adjacent à $J$ lorsque $I \cap J \neq \varnothing$

!!! example "Réservation de camping"
    Prendre l'exemple du TD

### Construction informatique du graphe d'intervalle

```python
    def collision(a, b, c, d):
        test1 = b <= c # [a, b] avant [c, d]
        test2 = d <= a # [c, d] avant [a, b]
        col = not(test1 or test2)
        return col
```

```python
    def construire_graphe(intervalles):
        n = len(intervalles)
        G = [ [] for i in range(n) ]
        for i in range(0, n):
            for j in range(i+1, n):
                if collision(intervalles[i][0], intervalles[i][1], intervalles[j][0], intervalles[j][1]):
                    G[i].append(j)
                    G[j].append(i)
        return G
```

## 4. Coloration des graphes d'intervalle (30 min)

### A. Un algorithme glouton

```python
    def couleur_disponible(G, c, i):
        k = 0
        while (not(compatible(G, c, i, k))):
            k = k + 1ère
        return k
```

```python
    def coloration_glouton(G):
        n = len(G)
        c = [ -1 for i in range(0, n) ] # init : couleur -1 pour tous
        for i in range(0, n):
            c[i] = couleur_disponible(G, c, i)
        return c
```

### B. Coloration optimale 

Remarquer sur des exemples que l'algorithme Glouton ne fournit pas nécessairement une coloration optimale.

Montrer qu'on peut en obtenir une en triant les intervalles.

Activités complémentaires :

- Programmer le tri des intervalles
- Démontrer mathématiquement que le tri est optimal (difficile pour des lycéens ?)
