# Récurrence et induction

## 1. Ensembles définis par induction
Soit $E$ un ensemble.

!!! abstract "Définition"
    On peut définir une partie $X$ de $E$ par **induction** en se donnant

    - un ensemble $X_0 \subset E$ d'élements de base appelés **axiomes**;
    - un ensemble de **règles d'inférence** : une règle $R$ est une fonction de construction qui prend en entrée un nombre $n_R$ d'élements de $E$ déjà construits et en construit un nouveau. La valeur $n_R$ s'appelle *arité* de la règle d'inférence.

    La partie $X$ est alors **la plus petite partie** de $E$ qui contient $X_0$ et qui est *stable* par l'application des règles d'inférence (tout élément construit à partir d'éléments de $X$ est dans $X$).

!!! example "Exemples"

    - Les entiers naturels impairs $\mathcal{I}$ peuvent être définis par induction par : $E = \mathbb{R}$, $X_0 = \{1\}$ et la règle $n \mapsto n + 2$.
    - Les **arbres binaires stricts** sont définis par $X_0 = \{ \text{Feuille} \}$ et la règle d'inférence d'arité 2 : $(g, d) \mapsto \text{Noeud}(g, d)$ qui créé un noeud à partir de deux sous-arbres qui seront ses fils. 
    - Les **formules propositionnelles** : les cas de bases sont les variables propositionnelles et les formules $\bot$ et $\top$. Il y a une règle d'arité $1$ : $F \mapsto \neg F$ et 4 règles d'arité 2 : $(F, G) \mapsto (F \land G)$ ,$(F, G) \mapsto (F \lor G)$, $(F, G) \mapsto (F \rightarrow G)$, $(F, G) \mapsto (F \leftrightarrow G)$.

En informatique, très souvent on ne précise pas l'ensemble $E$ qui est implicite. Dans l'exemple des arbres binaires $E$ pourrait être par exemple l'ensemble des chaînes de caractères, mais on ne le précise pas.
 
### Définition constructive
   
Lorsqu'un ensemble $X$ est défini par induction, on peut aussi voir sa construction à l'aide de la suite d'ensembles $(X_i)_{i \in \mathbb N}$ définie par par :

$$ X_{i+1} = X_i \cup \{ \text{nouveaux éléments que l'on peut construire en appliquant 1 règle d'inférence sur des éléments de $X_i$} \} $$

!!! tip "Proposition"
    La partie $X$ définie par induction vérifie alors :

    $$ X = \bigcup_{i \in \mathbb N} X_i $$

La preuve de cette proposition peut s'obtenir par double inclusion. D'une part, on peut montrer par récurrence simple que chaque $X_i \subset X$, ce qui montre une inclusion. D'autre part on vérifie que $\bigcup_{i \in \mathbb N} X_i$ contient $X_0$ et est stable par l'application des règles d'inférence, donc par définition de $X$ qui est la plus petite partie vérifiant cela, on obtient l'autre inclusion.

## 2. Preuves par récurrence

Nous faisons ici quelques rappels sur le principe de démonstration par récurrence, très utilisé en informatique.

Une preuve par récurrence consiste à démontrer une propriété pour tout entier $n$ une proporiété $P(n)$. **La propriété $P$ dépend donc d'un entier**.

### A. Récurrence simple

!!! tip "Preuve par récurrence simple"
    S'il existe un entier $n_0 \in \mathbb{N}$ tel que :

    - **Initialisation**: $P(n_0)$ est vraie
    - **Hérédité**:  Pour tout entier $n \geq n_0$ : $P(n) \Rightarrow P(n+1)$

    alors par récurrence simple $P(n)$ est vraie pour tout $n \geq n_0$.

!!! note "Point méthode"
    Pour rédiger une récurrence on écrira **systématiquement** la propriété à démontrer:
    
    $$ P(n) : \text{"} \dots \text{"} $$
    
    puis on prouve l'initialisation et l'hérédité. Enfin on conclut.

!!! example "Exercice"
    Démontrer que pour tout graphe non orienté $G = (S, A)$, la somme des degrés de tous les sommets vaut $2m$ où $m = |A|$.

!!! warning "Attention"
    Une erreur de raisonnement fréquente dans ce genre d'exercice est de montrer l'hérédité en partant d'un graphe à $m$ arêtes et en lui ajoutant une arête... C'est bien dans l'autre sens qu'il faut procéder : on veut montrer $P(m + 1)$ à partir de $P(m)$ donc il faut prendre un graphe *quelconque* à $m + 1$ arêtes et lui enlever une arête pour utiliser l'hypothèse de récurrence.


### B. Récurrence double

!!! tip "Preuve par récurrence double"
    S'il existe un entier $n_0 \in \mathbb{N}$ tel que :

    - **Initialisation**: $P(n_0)$ et $P(n_0 + 1)$ sont vraies
    - **Hérédité**:  Pour tout entier $n \geq n_0$ : $(P(n) \land P(n+1)) \Rightarrow P(n+2)$

    alors par récurrence double $P(n)$ est vraie pour tout $n \geq n_0$.

!!! note "Point méthode"
    Pour rédiger une récurrence double on écrira **systématiquement** la propriété à démontrer
    
    $$ P(n) : \text{"} \dots \text{"} $$
    
    puis **on précisera très clairement** que l'on procède par récurrence **double**. On montre les deux points de l'initialisation et l'hérédité. Enfin on conclut.

!!! example "Exercice"
    On construit la suite $(A_n)_{n \in \mathbb{N}}$ d'arbres binaires stricts suivante :

    - $A_0 = \text{Feuille}$
    - $A_1 = \text{Noeud}(\text{Feuille}, \text{Feuille})$
    - $\forall n \geq 2, A_n = \text{Noeud}(A_{n-1}, A_{n-2})$
    
    Démontrer que le nombre de noeuds+feuilles de $A_n$ vaut $3 F_n + L_n - 1$ où :
    
    - $(F_n)_{n \in \mathbb{N}}$ sont les nombres de Fibonnacci : $F_0 = 0, \quad F_1 = 1, \quad F_{n+2} = F_{n+1} + F_n$
    - $(L_n)_{n \in \mathbb{N}}$ sont les nombres de Lucas : $L_0 = 2, \quad L_1 = 1, \quad L_{n+2} = L_{n+1} + L_n$
    
    
    
### C. Récurrence forte

!!! tip "Preuve par récurrence forte"
    S'il existe un entier $n_0 \in \mathbb{N}$ tel que :

    - **Initialisation**: $P(n_0)$ est vraie
    - **Hérédité**:  Pour tout entier $n \geq n_0$ : $\left(\forall k \in [| n_0, n|], \,  P(k)\right) \Rightarrow P(n+1)$

    alors par récurrence forte $P(n)$ est vraie pour tout $n \geq n_0$.

!!! note "Point méthode"
    Pour rédiger une récurrence forte on écrira **systématiquement** la propriété à démontrer
    
    $$ P(n) : \text{"} \dots \text{"} $$
    
    puis **on précisera très clairement** que l'on procède par récurrence **forte**. On montre l'initialisation et l'hérédité. Enfin on conclut.

!!! example "Exercice"
    Démontrer par récurrence forte que tout arbre binaire à $n$ noeuds internes possède $n + 1$ feuilles (noeuds externes).

## 3. Preuves par induction

On dit aussi parfois **preuve par induction structurelle**.

Le schéma de preuve par induction ressemble à une récurrence, la différence est que la propriété $P(x)$ dépend cette fois d'un élement $x \in X$ d'une ensemble $X$ défini par induction. Le but d'une telle preuve est de démontrer que la propriété est vraie pour **tous** les élements $x \in X$.

!!! tip "Preuve par induction"

    - **Initialisation**: La propriété est vraie pour tous les éléments de base (axiomes) : $\forall x \in X_0, \, P(x)$ est vraie
    - **Hérédité**:  Pour **chaque règle d'inférence** $R$ d'arité $n_R$, et **pour tous** éléments $x_1, \dots, x_{n_R} \in X$, on a  : 

    $$ \left(P(x_1) \land P(x_2) \land \dots \land P(x_{n_R}) \right) \Rightarrow P\left(R(x_1, \dots, x_{n_R})\right) $$

    alors par induction structurelle $P(x)$ est vraie pour tout $x \in X$.

La formulation générale de ce princpe de preuve peut paraître intimidante, mais savoir l'appliquer en pratique est essentiel.

!!! example "Exercice"
    Démontrer par induction structurelle que tout arbre binaire à $n$ noeuds internes possède $n + 1$ feuilles (noeuds externes).

!!! example "Exercice"
    Un arbre binaire de recherche est soit une ${\tt Feuille(n)}$ étiquetée par un entier $n$, soit construit à partir de deux arbres binaires de recherche $g$ et $d$ par la règle ${\tt Noeud(x, g, d)}$ qui n'est valide que lorsque $\forall y \in \text{Etiquettes}(g), \, y \leq x$ et $\forall y \in \text{Etiquettes}(d), \, x < y$.

    Démontrer que la liste des étiquettes d'un arbre binaire de recherche, énumérées dans l'ordre du parcours en profondeur infixe est une liste triée par ordre croissant.

!!! note "Point méthode"
    Pour rédiger une preuve par induction on écrira **systématiquement** la propriété à démontrer
    
    $$ P(x) : \text{"} \dots \text{"} $$
    
    dépendant d'éléments $x$ d'un ensemble construit par induction (arbres, formules logiques, etc). **On précisera très clairement** que l'on procède par **induction structurelle**. On montre l'initialisation et l'hérédité. Enfin on conclut.

## Exercices

!!! example "Un exemple très facile"
    En utilisant la construction inductive des entiers impairs $\mathcal{I}$ démontrer que tout entier impair est supérieur ou égal à 1.

!!! example "Hauteur minimale"
    Démontrer qu'un arbre binaire possédant $2^n$ noeuds ou plus a une hauteur au moins égale à $n$.

!!! example "Arbres 2-3"
    Un arbre 2-3 de hauteur 0 est une feuille. Un arbre 2-3 de hauteur $h > 0$ possède une racine ayant 2 ou 3 fils qui sont tous des arbres 2-3 de hauteur $h - 1$. 

    1. Démontrer que le nombre de feuilles $n$ d'un arbre 2-3 vérifie $2^h \leq n \leq 3^h$.
    2. Pour quelles familles d'arbres ces bornes sont-elles atteintes ?

!!! example "Crayons de couleur"
    Montrons par récurrence simple que dans toute boîte de $n \in \mathbb{N}^*$ crayons de couleurs, tous les crayons sont de la même couleur.

    - **Initialisation :**Le résultat est vrai pour une boîte ne contenant qu'un seul crayon
    - **Hérédité :** Considérons une boîte $\{c_1, \dots, c_{n+1}\}$ contenant $n+1$ crayons de couleurs et enlevons lui le premier crayon. Par hypothèse de récurrence les $n$ crayons restants $c_2, \dots, c_{n+1}$ sont de la même couleur. Si on enlève maintenant le dernier crayon de la boîte initiale, on en déduit encore par hypothèse de récurrence que les $n$ crayons restants $c_1, \dots, c_n$, sont de la même couleur. Conclusion : tous les $n+1$ crayons sont de la même couleur.

    Par récurrence on a démontré que tous les crayons d'une boîte quelconque de $n$ crayons de couleurs sont de la même couleur.

    Ce résultat est évidemment absurde : trouver l'erreur de raisonnement qui a été faite.

!!! example "Listes infinies (Mines 2024)"
    On définit par induction l'ensemble $\mathcal{L}$ des listes d'éléments de $E$ ainsi :

    - une liste est soit la liste vide notée `[]`
    - soit construite à partir d'un élement $t \in E$ et d'une liste $q$, on la note alors $t::q$
   
    **Questions**
 
    1. Définir un type en langage OCaml pour représenter ces listes.
    2. Définir un type en langage C pour représenter ces listes (sur les entiers).
    3. On définit intuitivement l'ensemble $\mathcal{L}_{\infty}$ des listes finies ou infinies de valeurs. Est-ce que $\mathcal{L}_\infty$ est stable par la règle d'induction. A-t-on $\mathcal{L} = \mathcal{L}_\infty$ ?
    4. Démontrer que toute liste de $\mathcal{L}$ possède un nombre fini d'éléments.
    5. Le type proposé en langage C permet-il de construire une liste infinie ?


!!! example "Arbres ET/OU"
    Un arbre binaire ET/OU est un arbre binaire dans lequel : 

    - une feuille est soit la variable $x$, soit une constante $0$ représentant le faux, soit une constante $1$ représentant le vrai. 
    - il existe deux types de noeuds, les noeuds $\land$ représantant la conjonction logique et les noeuds $\lor$ représentant la disjonction logique. 

    À tout arbre binaire ET/OU $A$ on associe une fonction $f_A : \{0, 1\} \to \{0, 1\}$ où $f_A(t)$ vaut le résultat de l'évaluation de l'arbre $A$ en replaçant les feuilles $x$ par la valeur $t$.
    
    Démontrer qu'il est impossible de produire la fonction booléenne de négation : $f : x \mapsto 1 - x$ à l'aide d'un tel arbre.

!!! example "$\star$ Compacité de la logique propositionnelle $\star$"
    On considère un ensemble dénombrable de variables propositionnelles $\mathbb{V} = \{x_1, \dots, x_n, \dots \}$.
    
    Une théorie $T$ est un ensemble fini ou non de formules propositionnelles sur $\mathbb{V}$. 

    Une théorie est dite **satisfiable** s'il existe une valuation qui rend toutes ses formules vraies.
    Une théorie est dite **finiment satisfiable** si toute sous-théorie $T' \subset T$ finie est satisfiable.

    **Questions**

    1. Donner un exemple de théorie à 3 formules satisfiable.
    2. Donner un exemple de théorie à 3 formules non satisfiable
    3. Donner un exemple de théorie infinie satisfiable.
    4. Démontrer que si une théorie $T$ est satisfiable alors toute sous-théorie $T'$ finie est satisfiable.
    5. Démontrer que si toute les sous-théories finies $T'$ d'une théorie $T$ sont satisfiables alors $T$ est satifiable.
    (Indication : construire par récurrence une valuation qui convient, on suppose que les valeurs de vérité de $x_1, \dots, x_n$ sont fixées correctement, montrer qu'il est possible de fixer la valeur de vérité de $x_{n+1}$ de telle manière à ce que pour toute sous-théorie finie $T'$ il existe une valuation qui la satisfait et qui a précisément précisément ces valeurs choisies sur $x_1, \dots, x_{n+1}$)

    On obtient le théorème de compacité qui énonce qu'une théorie est satisfiable si et seulement si toutes ses sous-théories finies le sont. Une autre façon de le dire est qu'une théorie n'est pas satisifiable si et seulement si elle admet une sous-théorie finie qui ne l'est pas. Autrement dit la non satisfiabilité d'une théorie infinie n'est jamais due à son caractère infini : elle provient d'un sous-ensemble fini de formules qui n'est pas satisfiable.
