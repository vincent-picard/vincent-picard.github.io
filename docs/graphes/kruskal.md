# Arbres couvrants de poids minimal 

## 1. Structure de donnée Union-Find

### A. Implémentation favorisant `find`
### B. Implémentation favorisant `union`
#### i) Fusion améliorée
#### ii) Compression des chemins

## 2. Arbres couvrants

### A. Rappels

!!!abstract "Définition : cycle"
    Soit $G = (S, A)$ un graphe non orienté, un **cycle** est un chemin $(s_0, s_1, \dots, s_p)$ ($p > 0$) vérifiant :
    
    1. $\forall i \in [|0, p-1|], s_i s_{i+1} \in A$
    2. $s_0 = s_p$
    3. une arête apparaît au plus une fois dans le chemin

L'entier $p$ est appelé la *longueur du cycle*. Par définition $p \geq 2$.

!!!abstract "Définitions : arbre et forêt"
    - Un **arbre** est un graphe acyclique et connexe.
    - Une **forêt** est un graphe acyclique.

Dans une forêt chaque composante connexe est donc un arbre, d'où la terminologie.

Dans un arbre on peut, si on le souhaite, choisir un sommet particulier qu'on appelle **racine**. Ses voisins sont alors ses enfants, et ainsi de suite. Dans ce cas, ont dit que l'arbre est **enraciné**. 

!!!tip "Proposition"
    Tout arbre de taille au moins 2 possède au moins un sommet de dégré 1.

!!!tip "Proposition"
    Tout arbre de taille $n > 0$ possède $n-1$ arêtes.

### B. Arbres couvrants

!!!abstract "Définition : arbre couvrant"
    Soit $G = (S, A)$ un graphe connexe. Un **arbre couvrant** de $G$ est un sous-graphe $H$ contenant *tous les sommets* de $G$ et qui est un arbre, c'est-à-dire :

    1. $H = (S, A')$ avec $A' \subset A$
    2. $H$ est un arbre (connexe et acyclique)

On remarque que si $G$ n'est pas connexe, cette définition n'a aucun sens...

!!!note "Remarque"
    Pour décrire un arbre couvrant de $G = (S, A)$ il suffit de lister ses arêtes $A'$.

!!!tip "Proposition"
    Soit $G = (S, A)$ un graphe connexe et $H$ un sous-graphe de $G$ alors on a équivalence entre :

    1. $H$ est un arbre couvrant de $G$
    2. $H$ est acyclique et possède $n-1$ arêtes.

Le sens $(1) \Rightarrow (2)$ est évident avec ce qui précède. Pour le sens $(2) \Rightarrow (1)$ on remarque qu'à chaque fois qu'on ajoute une arête sans créer de cycle, on diminue le nombre de composantes de 1. Donc en en prenant $n-1$ il n'y a plus qu'une seule composante connexe, $H$ est un arbre et possède donc les $n$ sommets de $G$.

Algorithme général pour construire un arbre couvrant $H = (S, A')$ de $G = (S, A)$ :

1. Initialiser $A' \gets \varnothing$
2. Initialiser une structure union find avec pour singletons les sommets de $G$
3. Ajouter un arc $xy$ arbitraire mais qui ne créé pas de cycle $find(x) \neq find(y)$
4. Fusionner les composantes connexes de $x$ et $y$ : $union(x, y)$
5. Si $H$ n'est pas connexe, aller en 3.

## 3. Algorithme de Kruskal

!!!abstract "Définition : arbre couvrant de poids minimal"
    Soit $G = (S, A, p)$ un graphe non orienté pondéré. Un **arbre couvrant de poids minimal** (ACM) est :

    1. Un arbre couvrant de $G$...
    2. ... de poids minimal parmi tous les arbres couvrants de $G$.

Il y a un nombre fini d'arbres couvrants dans un graphe $G$, donc un tel arbre existe nécessairement. Il peut cependant il y en avoir plusieurs qui sont de poids minimal.

Algorithme de Kruskal

1. Initialiser $A' \gets \varnothing$
2. Initialiser une structure union find avec pour singletons les sommets de $G$
3. **Trier par ordre de poids croissant les arêtes de G**
4. Pour tout arc $xy$ dans *l'ordre obtenu* :
    - Si $find(x) = find(y)$ ne rien faire (l'arête créé un cycle)
    - Sinon $A' \gets A' \cup \{xy\}$
    - Et $fusion(x, y)$

Complexité

!!!tip "Proposition"
    L'algorithme de Kruskal construit un arbre couvrant de poids minimal.

Démonstration : on a déjà vu qu'un tel algorithme construit un arbre couvrant, il reste à montrer qu'il est minimal. À chaque itération, l'invariant suivant est vérifié : il existe un ACM T tel que $H \subset T$.

