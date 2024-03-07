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

!!! example "Exemple : Vocabulaire et textes"
    On peut considérer le graphe non orienté biparti $G = (U \sqcup V, A)$ dans lequel $U$ est un ensemble fini de mots (un vocabulaire) et $V$ un ensemble de textes. On construit alors une arête $mt \in A$ lorsque le mot $m$ apparaît dans le texte $t$.

!!! example "Exemples en biologie, en écologie et en médecine"
    L'image suivante montre 4  

## 2. Couplages

## 3. Couplages maximaux

I - Définitions

Définition : graphe biparti
Définition : graphe biparti équilibré
Définition : arêtes incidentes
Définition : couplage
Définition : couplage maximum

Exemple : le bal
Un ensemble de n danceuses et de n danseurs.
Une arête existe si les deux personnes sont d'accord pour danser ensemble.
On cherche à maximiser le nombre de danseurs sur scène.

Exemple 2 : crise medicale
un ensemble de patients blessés
un ensemble de medecins à l'hopital
une arete : un medecin est apte à soigné un malade

Exemple : illustration qu'un couplage maximal au sens de l'inclusion n'est pas un couplage de cardinal maximal.

II - Représentation

Un couplage sur un graphe de taille 2n peut être représenté par un tableau C où C[i] vaut j si (Ai,Bj) est dans le couplage et C[i] = -1 sinon.

Exercice : écrire une fonction en C vérifiant si un tableau est bien un couplage. 

III - Recherche exhaustive

On prend l'arête 1, on la choisit dans le couplage et on estime le max
On ne prend pas l'arete 1, on l'enleve et on est estime le max.

Complexité : 2^|aretes|

IV - Chemins augmentants

Définition
Soit G un graphe biparti et C un couplage de ce graphe. Un chemin est dit alternant si il alterne entre une arête dans C et une arête n'appartenant pas à C.

Définition
Un chemin est augmentant si il commence et finit par un sommet non apparié.

Propriete
Si G est un graphe biparti, C un couplage et u un chemin augmentant alors C delta u est aussi un couplage de cardinal +1.

Preuve :
Comme le sommet de départ et d'arrivée ne sont pas appariés, on voit que C delta u contiendra une arete de plus que C, d'ou le cardinal. Il faut maintenant vérifier que c'est bien un couplage.
Soit (x,y) une arete dans C delta u.
le chemin u contenait un sous-chemin (a, x, y, b) tel que (a, x) etait dans C (x, y) n'était pas dans C et (y, b) était dans C. Comme C était un couplage (a, x) etait la seule arete qui touchait x donc si on l'enleve x n'est touché par plus personne donc (x, y) est la seule a toucher x dans C'. Il en va de meme pour y. Donc C' est bien un couplage.

Theoreme (Berge)
Un couplage C est maximum si et seulement si il n'admet pas de chemin augmentant.

Preuve :
Supposons que C n'est pas maximum et soit C' un couplage de meilleure cardinalité. Soit H le sous-graphe de G induit par les aretes C delta C'.
On regarde les composantes connexes de H :
1) sommet isolé
2) un cycle alternant entre des aretes de M et M' de longueur paire
3) une chaine alternante entre M et M' de longueur impaire
Preuve : chaque sommet dans ce graphe est touché par 2 aretes au plus (une dans C et une dans C')

Puisque C' est plus grand que C, alors H contient une composante connexe possédant plus d'arcs de C' que de C. Donc ca ne peut être qu'une chaine. qui commence par un sommet de C' et qui termine par un sommet de C' non apparié dans C. Donc c'est un chemin augmentant.


Algorithme :
Considérer un couplage, rechercher un chemin augmentant. Si on en trouve un ou augmente. On recommence jusqu'à ce qu'il n'y ait plus de chemin augmentant.

La complexité est en O(nm)
