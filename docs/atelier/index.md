# Atelier CPGE : coloration de graphes d'intervalle

!!! warning "Début séance"
    1. Faire l'appel
    2. Spécialités NSI 1ère et/ou terminale ?

## 1. Graphes 

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

!!! example "Les ponts du Konnigsberg"

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
    
    1. Numéroter chaque sommet de 0 à $
```python
G = [[1, 2], [], [0, 3]]
```

```python
def degre(G, i):
    voisins = G[i]
    return len(voisins)
```

### C. Cliques

!!! abstract "Définition (nombre clique)"
    Soit $G$ un graphe, on appelle **nombre clique** de $G$, noté $\alpha(G)$ le *plus grand* entier $k \in \mathbb{N}$ tel qu'il existe une clique de taille $k$ dans $G$.

!!! note "Remarque"
    Un sommet constitue à lui seul une clique de taille 1, donc $\alpha(G) \geq 1$.

## 2. Coloration de graphes

!!! abstract "Définition (nombre chromatique)"
    Soit $G$ un graphe, on appelle **nombre chromatique** de $G$, noté $\chi(G)$ le plus petit entier $k \in \mathbb{N}$ tel qu'il existe une $k$-coloration de $G$.

## 3. Graphes d'intervalle

```python
    def collision(a, b, c, d):
        return True
```

