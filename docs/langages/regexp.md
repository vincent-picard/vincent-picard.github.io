# Langages réguliers, expressions régulières

Dans ce chapitre on introduit les notions de **mots** et de **langages formels** en informatique. Il est important d'acquérir une bonne maîtrise des concepts présentés ici car ils seront utilisés tout au long de l'année de MPI.

On présente également une classe particulière de langages dits **réguliers** qui ont une grande importance théorique et pratique en informatique. Les **expressions régulières** permettent de décrire facilement ces langages.

## 1. Alphabets et mots 

!!! abstract "Définition (alphabet)"
    Un **alphabet** est un ensemble *fini* de symboles appelés *lettres*.

!!! example "Exemples"
    
    - $\Sigma = \{a, b, c\}$ est un alphabet de 3 lettres
    - $\Sigma = \{a, b, \dots, z\}$ est l'alphabet qu'on apprend à l'école
    - $\Sigma = \{0, 1\}$ est un alphabet binaire
    - $\Sigma = \{\text{caractères ASCII}\}$ est un alphabet permettant d'écrire des textes en informatique

!!! abstract "Définition (mot)"
    Un **mot**  $m$ sur un alphabet $\Sigma$ est une suite *finie* de lettres de $\Sigma$ : $m = m_1m_2\dots m_n$. Le nombre de lettres $n$ de la suite est appelé **longueur** du mot. Le seul mot de longueur 0 est appelé **mot vide** et noté $\varepsilon$.

!!! example "Exemples"
    
    - $aabbaa$ est un mot sur $\Sigma = \{a, b\}$ mais aussi un mot sur $\Sigma = \{a, b, c\}$
    - $1101$ est un mot sur $\Sigma = \{0, 1\}$
    - $\varepsilon$ est un mot


**Notations**
On notera :

- $|m|$ la longueur du mot $m$
- $|m|_{a}$ le nombre d'occurrences de la lettre $a$ dans le mot $m$

!!! abstract "Notations"
    Soit $\Sigma$ un alphabet.

    - L'ensemble de tous les mots de longueur exactement $p \in \mathbb{N}$ sur $\Sigma$ est noté $\Sigma^p$
    - L'ensemble de tous les mots sur $\Sigma$ est noté $\Sigma^*$

### Concaténation de mots

!!! abstract "Définition (concaténation)"
    Soit $\Sigma$ un alphabet. Soit $u = u_1 \dots u_p \in \Sigma^p$ un mot de longueur $p$ et $v = v_1 \dots v_q \in \Sigma^q$ un mot de longueur $q$. La **concaténation** de $u$ et $v$, notée $u.v$, est le mot $u.v = u_1 \dots u_p v_1 \dots v_q$ de longueur $p + q$.

!!! tip "Proposition"
    La concaténation $.$ est une loi de composition interne sur $\Sigma^*$ admettant les proriétés suivantes :

    - Le mot vide $\varepsilon$ est **neutre** pour la concaténation : $\forall u \in \Sigma^*, \varepsilon . u = u . \varepsilon = u$. 
    - La concaténation est **associative** : $\forall u \in \Sigma^*, \forall v \in \Sigma^*, \forall w \in \Sigma^*,(u.v).w = u.(v.w)$. 
    - La concaténation n'est pas commutative en général.

    On dit que $\left(\Sigma^*, .\right)$ possède la structure algébrique de **monoïde**.

!!! abstract "Notations"
    On adopte les mêmes conventions que pour la structure de groupe en mathématiques :
    
    - On peut ommettre l'opérateur $.$ et écrire simplement $uv$
    - On peut écrire $uvw$ au lieu de $(u.v).w$    
    - On définit la **puissance** d'un mot comme l'itéré de la concaténation :

        * $u^0 = \varepsilon$
        * $u^p = \underbrace{u.\cdots.u}_{p \text{ fois}}$

Ces conventions nous permettent d'écrire les mots de façon compacte par exemple :

- $aaaaaab = a^6b$
- $aabbaabbaabb = (a^2b^2)^3$

!!! example "Exercice"
    On définit en OCaml le type suivant permettant de décrire un mot :
    ```OCaml
    type mot =
        | Epsilon
        | Lettre of char
        | Puissance of mot * int
        | Concat of mot * mot
    ```
    **Questions**

    1. Écrire une expression OCaml pour définir le mot $aaabbbaaabbb$
    2. Écrire la fonction `#!OCaml longueur : mot -> int`
    3. Écrire la fonction `#!OCaml occ : char -> mot -> int` qui compte le nombre d'occurrences d'une lettre dans un mot

## 2. Langages

!!! abstract "Définition (langage)"
    Un **langage** sur l'aphabet $\Sigma$ est un ensemble (fini ou non) de mots sur $\Sigma$

Une autre manière de le dire est que les langages sur $\Sigma$ sont les parties de $\Sigma^*$.

!!! example "Exemples"

    - $\varnothing$ : le langage vide
    - $\Sigma^*$ : langage contenant tous les mots possibles sur $\Sigma$, 
    - $\{a, ab, baba\}$ : un langage fini sur $\Sigma=\{a, b\}$ 
    - $\{\varepsilon, a, a^2, a^3, a^4, \dots \}$ : mots ne contenant que des $a$. 
    - On peut aussi définir un langage par une propriété sur les mots qui lui appartiennent : langage des mots finissant par $ababa$, langage des mots contenant autant de $a$ que de $b$, etc.

!!! bug "Erreur fréquente"
    Attention à ne pas confondre :

    - Le mot vide $\varepsilon$
    - Le langage vide $\varnothing$
    - Le langage ne contenant que le mot vide $\{ \varepsilon \}$

!!! info "Les langages sont des ensembles"
    Les langages étant des ensembles, on peut les manipuler en tant que tels, en particulier on peut utiliser les outils ensemblistes classiques :

    - L'**union** $L_1 \cup L_2$ est le langage des mots qui sont dans $L_1$ ou dans $L_2$. 
    - L'**intersection** $L_1 \cap L_2$ est le langage des mots qui sont dans $L_1$ et dans $L_2$. 
    - L'**inclusion** : on dit que $L_1 \subseteq L_2$ si tout mot de $L_1$ est un mot de $L_2$.
    - La **différence** $L_1 \setminus L_2$ est le langage des mots qui sont dans $L_1$ mais pas dans $L_2$.
    - Le **complémentaire** $\overline{L_1} = \Sigma^* \setminus L_1$ est l'ensemble des mots sur $\Sigma$ qui ne sont pas dans $L_1$. 
    
L'ensemble de tous les langages sur $\Sigma$ est $\mathfrak P(\Sigma^*)$ (ensemble des parties de $\Sigma^*$), il est partiellement ordonné par $\subseteq$, le plus petit des langages est $\varnothing$, le plus grand des langages est $\Sigma^*$. 

Exemple sur $\Sigma =\{a, b\}$ : 

$$\varnothing \subseteq \{a\} \subseteq \{a, aba\} \subseteq \{ \text{mots finissant par $a$}\} \subseteq \Sigma^*.$$

### Concaténation, puissance, étoile de langages

!!! abstract "Définition (concaténation)"
    Soit $L_1$ et $L_2$ deux langages sur $\Sigma$. La **concaténation** de $L_1$ et $L_2$ est 

    $$L_1.L_2 = \{ u.v, \, u \in L_1 \text{ et } v \in L_2. \}$$
    
    C'est le langage des mots obtenus en prenant un mot de $L_1$, un mot de $L_2$, et en les concaténant *dans cet ordre*. 

Attention à ne pas confondre concaténation de mots et concaténation de langages. On remarque que c'est le même type de définition que l'on a en mathématiques lorsqu'on définit, par exemple, la somme de deux sous-espaces vectoriels.

!!! abstract "Définition (puissance)"
    Soit $L$ un langage et $p \in \mathbb{N}$ on définit les **puissances** de $L$ par :

    - $L^0 = \{ \varepsilon \}$
    - $L^p = \underbrace{L.\cdots.L}_{p \text{ fois}}$

!!! example "Exercice"
    Soit $L = \{a, ab\}$ un langage sur $\{a, b\}$. Comparer $L_1 = L^3$ et $L_2 = \{u^3, \, u \in L\}$

!!! abstract "Définition (étoile)"
    L'**étoile** d'un langage $L$ est définie par 

    $$L^* = \bigcup_{p \in \mathbb N} L^p = \{\varepsilon\} \cup L \cup L^2 \cup \dots$$

    Intuituivement $L^*$ est le langage des mots qu'on peut former en prenant des mots de $L$ et en les concaténants.

On pourra remarquer que cette définition est cohérente avec la notation $\Sigma^*$ définie précédemment.

!!! example "Exercice"
    Soit $L = \{M, P, I\}$, lister les premiers mots de $L^* = \{M, P, I\}^*$ dans l'ordre lexicographique.

!!! example "Exercice"
    Soit $L$ un langage quelconque. Comparer $L^*$ et $(L^*)^*$.

## 3. Langages réguliers

Les langages réguliers sont une **classe** particulière de langages, c'est-à-dire un ensemble de langages. Elle est définie par induction.

!!! abstract "Définition (langages réguliers)"
    Soit $\Sigma$ un alphabet. L'ensemble des **langages réguliers** sur $\Sigma$, aussi appelés **langages rationnels**, noté $\def\rat#1{{\text{RAT}(#1)}} \rat{\Sigma}$, est défini inductivement par

    * **Axiomes** :

        - $\varnothing \in \rat{\Sigma}$
        - $\{\varepsilon\} \in \rat{\Sigma}$
        - Pour tout $x \in \Sigma$, $\{x\} \in \rat{\Sigma}$
    * **Règles d'inférence** :

        - Si $L_1 \in \rat{\Sigma}$ et $L_2 \in \rat{\Sigma}$ alors $L_1.L_2 \in \rat{\Sigma}$
        - Si $L_1 \in \rat{\Sigma}$ et $L_2 \in \rat{\Sigma}$ alors $L_1 \cup L_2 \in \rat{\Sigma}$
        - Si $L \in \rat{\Sigma}$ alors $L^* \in \rat{\Sigma}$

Autrement dit, $\rat{\Sigma}$ est la plus petite classe de langages contenant le langage vide, le langage contenant uniquement le mot vide, les langages contenant uniquement un mot d'une lettre, et stable par concaténation, union finie et étoile.

Comme toute définition inductive, cela signifie que les langages réguliers peuvent se représenter sous forme d'arbres où les feuilles sont des axiomes et où les noeuds (ici binaires pour $\cup$ et $.$ et unaires pour $*$) représentent l'application d'une règle d'inférence.

!!! example "Exemples"
    
    1. Montrer que $L = \{a, aba\}$ est un langage régulier.
    2. Montrer que le langage des mots non vides sur $\{a, b\}$ ne contenant que des $a$ est régulier. 
    3. Montrer que le langage des mots sur $\{a, b\}$ finissant par $ba$ est régulier. 
    4. Montrer que le langage des mots sur $\{0, 1\}$ contenant deux $1$ consécutifs est régulier.
    5. Montrer que le langage des mots sur $\{a, b\}$ dans lesquels tout $a$ est suivi d'un $b$ est régulier.
     
!!! tip "Proposition"

    - L'union d'une famille **finie** de langages réguliers est régulier.
    - La concaténation d'une suite finie de langages réguliers est régulier.
    - *(admis)* L'intersection d'une famille **finie** de langages réguliers est régulier.
    - *(admis)* Le complémentaire d'un langage régulier est régulier.

Nous verrons plus tard que l'union/intersection d'une famille infinie de langages réguliers n'est pas nécessairement un langage régulier, même lorsqu'elle est supposée dénombrable.

Les deux propriétés pour le moment admises sont la conséquence du théorème de Kleene que nous étudierons plus tard.

!!! tip "Proposition"
    Tout langage fini est régulier.

Pour rappel, nous avons donné des exemples de langages réguliers infinis ci-dessus.

## 4. Expressions régulières

Nous introduisons ici un formalisme qui permet de décrire simplement les langages réguliers comme les langages des mots qui correspondent à un certain **motif**. Voici un exemple d'un tel motif qui pourrait correspondre au langage des numéros de téléphone portable à la Réunion

$$ 069(2|3) (0|1|2|3|4|5|6|7|8|9)^6$$

Ce formalisme est d'autant plus important qu'il est largement utilisé en informatique pour les documentations (spécifications) et dans la manipulation de certains programmes (*shell*, *grep*, etc).

!!! abstract "Définition (expressions régulières)"
    Soit $\Sigma$ un alphabet. L'ensemble des \notion{expressions régulières} sur $\Sigma$, noté $\def\regexp#1{{\text{REGEXP}(#1)}} \regexp{\Sigma}$, est défini inductivement par

    - **Axiomes :**

        * $\varnothing \in \regexp{\Sigma}$
        * $\varepsilon \in \regexp{\Sigma}$
        * Pour tout $x \in \Sigma$, $x \in \regexp{\Sigma}$
    - **Règles d'inférence :**
        
        * Si $e_1 \in \regexp{\Sigma}$ et $e_2 \in \regexp{\Sigma}$ alors $(e_1.e_2) \in \regexp{\Sigma}$
        * Si $e_1 \in \regexp{\Sigma}$ et $e_2 \in \regexp{\Sigma}$ alors $(e_1|e_2) \in \regexp{\Sigma}$
        * Si $e \in \regexp{\Sigma}$ alors $e* \in \regexp{\Sigma}$
   
!!! example "Exemples"
    Voici quelques exemples d'expressions régulières suivies de leur signification intuitive :

    - $(a|b)*$ : mots ne contenant que des $a$ ou des $b$.
    - $(a|b)*baba$ : mots sur $\Sigma = \{a, b\}$ finissant par $baba$.
    - $bac(a|b|c)*$ : mots sur $\Sigma = \{a, b, c\}$ commençant par $bac$.
    - $(+|-|\varepsilon)(1|\dots|9)(0|\dots|9)*$ : mots représentant une constante littérale entière

**Écritures simplifiées :** pour simplifier les écritures, on pourra 

* s'abstenir d'écrire certaines parenthèses, par exemple écrire $(a|b|c)$ au lieu de $((a|b)|c)$, 
* ommettre le $.$ de la concaténation : par exemple écrire $baba$ à la place de $(b.(a.(b.a)))$.
* utiliser les puissances : par exemple, écrire $(a|b)^3$ pour $(a|b)(a|b)(a|b)$

###A. Dénotation
Nous remarquons sur les exemples précédents que les expressions régulières sont des motifs qui correspondent (match) à un ensemble de mots. Le langage des mots qui correspondent à une expression régulière est appelé **langage dénoté** par l'expression régulière. En voici une définition formelle : 

!!! abstract "Définition (langage dénoté)"
    Le **langage dénoté** par une expression régulière $e \in \regexp{\Sigma}$ est noté $\mu(e)$ et est défini inductivement par :

    - **Axiomes :**

        * $\mu(\varnothing) = \varnothing$
        * $\mu(\varepsilon) = \{ \varepsilon \}$
        * Pour tout $x \in \Sigma$, $\mu(x) = \{ x \}$
    - **Règles d'inférence :**

        * Si $e_1 \in \regexp{\Sigma}$ et $e_2 \in \regexp{\Sigma}$ alors $\mu(e_1.e_2) = \mu(e_1).\mu(e_2)$
        * Si $e_1 \in \regexp{\Sigma}$ et $e_2 \in \regexp{\Sigma}$ alors $\mu(e_1|e_2) = \mu(e_1) \cup \mu(e_2)$
        * $e \in \regexp{\Sigma}$ alors $\mu(e*) = \mu(e)^*$

!!! example "Exemple"
    Le langage dénoté par $e = (a|b)*ba$ est le langage des mots sur $\Sigma = \{a, b\}$ qui finissent par $ba$.

!!! tip "Proposition"
    Un langage $L$ est régulier si et seulement s'il existe une expression régulière $e$ qui dénote $L$, c'est-à-dire telle que $L = \mu(e)$. On peut l'écrire :

    $$ \forall L \subseteq \Sigma^*, \quad L \in \rat{\Sigma} \Leftrightarrow \exists e \in \regexp{\Sigma} : \mu(e) = L$$

Cette proposition nous éclaire sur la classe des langages réguliers : il s'agit en fait des langages qu'on peut dénoter par expression régulière, nous verrons que ce n'est pas le cas de tous les langages.

!!! note "Point méthode"
    Pour résumer, nous avons vu pour l'instant ces 3 méthodes pour démontrer qu'un langage est régulier :
    
    - s'il s'obtient comme application des règles d'inférence sur les axiomes, il est régulier
    - s'il est fini, il est régulier
    - s'il est dénoté par une expression régulière, il est régulier

###B. Équivalence

On peut remarquer qu'il n'y a pas unicité de l'expression régulière permettant de dénoter un langage régulier. Par exemple $e_1 = b(ab)*$ et $e_2 = (ba)*b$ dénotent le même langage : celui des mots commençant et finissant par $b$ et qui alternent entre $a$ et $b$. Dans ce cas $\mu(e_1) = \mu(e_2)$ et on dira que les expressions régulières sont équivalentes.

!!! abstract "Définition"
    Deux expressions régulières $e_1$ et $e_2$ sont dites **équivalentes** si elles dénotent le même langage c'est-à-dire lorsque $\mu(e_1) = \mu(e_2)$. On notera $e_1 \equiv e_2$.

Comme en logique, l'équivalence des expressions régulières nous permet de *calculer* sur les expressions régulières sans changer leur sens c'est-à-dire sans changer le langage dénoté. Voici quelques équivalences usuelles (liste non exhaustive) :

- $\forall e \in \regexp{\Sigma}, \ \varepsilon.e \equiv e.\varepsilon \equiv e$
- $\forall e \in \regexp{\Sigma}, \ e** \equiv e*$
- $\forall e, f, g \in \regexp{\Sigma}^3, \  e.(f | g) \equiv (e.f | e.g)$
- $\forall e \in \regexp{\Sigma}, \ \varnothing.e \equiv e.\varnothing \equiv \varnothing$ 
- $\forall e \in \regexp{\Sigma}, \ e* | ee* \equiv (\varepsilon | e)e* \equiv e*$

On remarquera que *décider l'équivalence de deux expressions régulières* ou *simplifier une expression régulière* sont des problèmes difficiles en général.

## 5. Applications pratiques

Les *expressions régulières* sont largement utilisées en informatique, voici quelques exemples concrets :

- Les interprètes de commande (*shells*) dans les systèmes d'exploitation de type *Unix* acceptent certains paramètres sous forme d'expressions régulières ayant une syntaxe propre. Par exemple :

    * `#!sh ls *.ml` : affiche la liste de tous les fichiers source Caml dans le répertoire courant
    * `#!sh rm jeu*.o` : supprime les fichiers compilés commençant par `jeu`
    * `#!sh rm *.(c\|h)` : supprime tous les fichiers sources et d'en-tête du répertoire actuel (idéal pour perdre tout son travail).

- L'utilitaire **grep** permet de lire un fichier ligne par ligne et d'afficher toutes les lignes qui correspondent à un motif donné sous forme d'expression régulière :

    * `#!sh grep -E 'L_(1|2)' regexp.md` trouve toutes les lignes de ce résumé de cours contenant $L_1$ ou $L_2$.

- Le langage **Awk** permet d'écrire des programmes qui lisent les fichiers ligne par ligne et d'effectuer certaines actions si la ligne correspond à un motif dénoté par expression régulière étendue. Il a inspiré en partie le langage **Perl** dans lequel les expressions régulières ont une place importante.
- Pour **spécifier** un langage de programmation il faut commencer par définir sa syntaxe : quels sont mots-clefs du langage, à quoi ressemble une variable, une constante littérale flottante ? Ces définitions se font à l'aide d'expressions régulières. C'est la première étape pour définir un langage de programmation et permet ensuite de faciliter la conception des compilateurs et interprètes pour ce langage.

    * Par exemple le [manuel OCaml](https://ocaml.org/manual/5.2/lex.html#integer-literal) décrit les constantes littérales entières à l'aide d'expressions régulières.

### Expressions régulières étendues POSIX

Malheureusement il n'existe pas de syntaxe *unifiée* pour les expressions régulières et chaque logiciel a tendance à utiliser ses propres conventions syntaxiques. La **norme POSIX** tente d'uniformiser ces notations, on parle alores d'expressions régulières étendues POSIX. Voici par exemple ce qu'on peut utiliser dans les expressions régulières étendues :

| Motif | Signification |
| ----- | ------------- |
| `m*` | $m$ répété 0 ou plusieurs fois |
| `m+` | $m$ répété 1 ou plusieurs fois |
| `m?` | $m$  0 ou 1 fois |
| `m{5}` | $m$ exactement 5 fois |
| `m{3,7}` | $m$ entre 3 et 7 fois |
| `m{3,}` | $m$ au moins 3 fois |
| `.` | 1 caractère |
| `(a\|b)` | $a$ ou $b$ |
| `[abc]` | $a$,$b$ ou $c$ |
| `[a-z]` | un caractère entre $a$ et $z$ |
| `\w` | un caractère alphanumérique |

Il est important de comprendre que chacune de ces règles peut s'obtenir sous forme d'une expression régulière vue dans notre cours, elles n'apportent donc techniquement rien de plus si ce n'est un plus grand confort dans l'écriture des motifs.

Par exemple, le langage des numéros de téléphone portable réunionnais peut être décrit avec l'expression regulière POSIX :

$$ (06-9)(2\backslash|3)(-[0-9]\{2\})\{3\} $$
