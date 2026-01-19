# Décidabilité et complexité

La *théorie de la complexité* a pour but d'établir une hiérarchie de **difficulté des problèmes** que l'on souhaite résoudre en informatique. Elle ne doit pas être confondue avec l'*analyse de complexité* des algorithmes (vue en première année), bien que les deux notions sont effectivement liées.

Cette étude permet de mieux comprendre les **limites théoriques** de l'informatique et définit en particulier deux classes de problèmes importantes et rencontrés fréquemment en informatique :

- **Les problèmes indécidables** : pour lesquels on sait qu'il ne peut pas exister d'algorithme pour les résoudre
- **Les problèmes NP-complets** : pour lesquels on ignore aujourd'hui s'il existe des algorithmes efficaces pour les résoudre

## 1. Introduction
### A. Problèmes de décision

La premier point que nous abordons est la définition de ce qu'on considère être un problème à résoudre :

!!!abstract "Définition (problème de décision)"
    Un **problème de décision** est une *question* portant sur un ensemble de *données* appelées **instance du problème** et dont la réponse est soit *oui* soit *non*.

Attention, tous les problèmes ne sont pas des problèmes de décision, mais la hiérarchie de difficulté qu'on va établir concerne ce type de problèmes.

!!!example "Exemples"
    Voici des problèmes de décision :

    - **Instance :** un graphe non orienté $G$. **Question :** $G$ est-il connexe ?
    - **Instance :** un graphe orienté $G$ et deux sommets $u$ et $v$. **Question :** existe-t-il un chemin dans $G$ de $u$ à $v$ ?
    - **Instance :** un tableau $T$. **Question :** $T$ est-il trié par ordre croissant ?
    - **Instance :** un tableau $T$ et une valeur $v$. **Question :** la valeur $v$ est-elle présente dans $T$ ?
    - **Instance :** un entier naturel $n$. **Question :** $n$ est-il premier ?
    - **Instance :** une formule propositionnelle $F$. **Question :** $F$ est-elle une tautologie ?
    - ...

Pour pouvoir parler de complexité nous devons également être en mesure de donner une taille aux entrées du problème :

!!!abstract "Définition (taille de l'instance)"
    La **taille** d'une instance d'un problème de décision est l'espace qu'elle occupe en mémoire (en octets par exemple). Pour simplifier, on utilisera les conventions suivantes selon le type d'instance :

    - *un entier $n$ non borné* : $log_2(n)$ (le nombre est écrit en binaire)
    - *un tableau ou une liste de longueur $n$* : $n$ (les cases du tableau occupent un même espace constant)
    - *un graphe de $n$ sommets et $m$ arêtes/arcs* : $n + m$ (listes d'adjacence) ou $n^2$ (matrice d'adjacence)
    - *un arbre* (arbre binaire, formule logique, expression régulière, etc) : la taille de l'arbre (nombre de noeuds et de feuilles)

La manière exacte de compter la taille de l'instance importe peu dans la théorie qui va suivre, à condition de rester raisonnable sur la manière dont l'instance est codée et mesurée. Par exemple on ne va pas coder un entier non borné en base 1...

### B. Modèle de calcul

Maintenant, nous avons besoin de définir ce qu'est un ordinateur et comment on mesure le temps et l'espace consommé pour résoudre un problème. Malheureusement, il y a beaucoup d'ordinateurs différents c'est pourquoi il est nécessaire de se baser sur un *modèle de machine* théorique qui décrit ce qu'un ordinateur est capable de calculer ou non. Le modèle théorique de référence est la *machine de Turing* mais elle n'est pas au programme en MP2I/MPI.

Pour simplifier, nous utiliserons dans ce cours le terme général de *machine* pour parler d'un ordinateur qui prend des données en entrée, réalise un calcul algorithmique et produit un résultat en sortie. **Le calcul effectué sera décrit au choix :**

- par un *algorithme écrit en pseudo-code*
- par un *programme ou une fonction écrite en C*
- par un *programme ou une fonction écrire en OCaml*

Le temps d'exécution sera compté en *nombre d'opérations élémentaires* effectuées et l'espace utilisé par le *nombre de cases mémoires* utilisées. Autrement dit on compte le temps et l'espace comme vous avez pris l'habitude de le faire en première année (MP2I).

### C. Problèmes décidables

!!!abstract "Définition (problème décidable)"
    Un problème de décision est **décidable** s'il existe une *machine* qui prend en entrée une instance du problème, **qui termine sur toute entrée**, et qui donne en sortie la bonne réponse *oui* ou *non* pour l'instance donnée.
    ```mermaid
    flowchart LR
        classDef instance fill:lightblue,stroke:transparent,fill:transparent;
        classDef machine fill:pink;
        classDef answer fill:lightblue,stroke:transparent,fill:transparent;
        I[instance] --> M;
        M --> R[oui/non];
        class I instance;
        class M machine;
        class R answer;
    ```

!!!example "Exemple"
    Soit le problème de décision suivant qu'on appellera *MEMTAB* :

    - **Instance :** un tableau $T$ et une valeur $v$
    - **Question :** la valeur $v$ est-elle présente dans $T$ ?

    Montrer que le problème *MEMTAB* est décidable.
    ???note "Solution"
        *MEMTAB* est décidable, voici un exemple d'alogorithme qui décide *MEMTAB* :
        ```
        Entrées : T, v
        n <- longueur(T)
        Pour i allant de 0 à n-1 Faire
            Si T[i] == v Alors
                Répondre OUI
            FinSi
        FinPour
        Répondre NON
        ```
        Cet algorithme répond correctement à la question, de plus **il termine sur toute entrée** (une boucle Pour termine toujours). Donc *MEMTAB* est décidable.

Il est difficile de se l'imaginer pour le moment mais nous verrons que certains problèmes ne sont pas décidables. On dit qu'il alors qu'ils sont indécidables.

### D. Réductions d'un problème à l'autre

Comme annoncé dans l'introduction, un des buts de ce chapitre est de classer les problèmes à traiter selon leur difficulté. Pour cela on va se reposer sur le principe suivant. Supposons qu'on possède un problème $A$ par exemple "Eteindre une bougie" et un problème $B$ par exemple "Eteindre un incendie".

Si je dispose d'une méthode $M$ pour résoudre $B$ (par exemple utiliser une lance à incendie), je peux certainement utiliser cette méthode $M$ pour résoudre $A$. On dira dans ce cas que $B$ est plus difficile que $A$ puisque si je sais résoudre $B$ je sais résoudre $A$.

L'inverse n'est pas vrai : si je dispose d'une méthode pour éteindre une bougie (par exemple souffler dessus), il est peu vraisemblable que cette méthode me permette d'éteindre un incendie. Formalisons cela pour les problèmes de decision.

!!!abstract "Définition (réduction et réduction polynomiale)"
    Soit $A$ et $B$ deux problèmes de décision. On dit que $A$ **se réduit à** $B$ s'il existe une machine $R$ prenant en entrée une instance $I_A$ de $A$ et produisant en sortie une instance $I_B$ de $B$ et vérifiant :

    - (i) La machine $R$ termine sur toute entrée 
    - (ii) $I_A$ est une instance positive $\Leftrightarrow$ $I_B = R(I_A)$ est une instance positive

    Dans ce cas on notera $A \leq B$.

    **Si de plus,** il existe un réel $k > 0$ tel que 

    - (iii) Le temps d'exécution pire cas de $R$ est en $O(|I_A|^k)$

    alors on dit que la **réduction est polynomiale** et on notera alors $A \leq_P B$.

    ```mermaid
    flowchart LR
        classDef instance fill:lightblue,stroke:transparent,fill:transparent;
        classDef machine fill:pink;
        classDef reduction fill:lightgreen,stroke:green;
        classDef answer fill:lightblue,stroke:transparent,fill:transparent;
        I["$$I_A$$"] --> R@{ shape: delay };
        R--> J["$$I_B$$"];
        class I,J instance;
        class R reduction;
    ```

Autrement dit une réduction d'un problème $A$ vers un problème $B$ est une *traduction* des instances d'un problème à l'autre qui préserve la réponse oui/non. Ainsi pour résoudre une instance du problème $A$ on peut considérer sa traduction en problème $B$ est résoudre ce nouveau problème. Donc si on sait résoudre $B$, on sait résoudre $A$ : $B$ est **plus difficile** que $A$.

La réduction est polynomiale lorsque le temps de calcul de la traduction est polynomial en fonction de la taille de l'instance $I_A$.

!!!tip "Proposition"
    Soit $A$ et $B$ deux problèmes de décision. Si $B$ est décidable et si $A \leq B$ alors $A$ est décidable.
    
!!!note "Démonstration"
    Soit $A$ et $B$ deux problèmes de décision vérifiant les hyptohèses de départ :

    - $B$ est décidable : il existe donc une machine $M$ qui décide $B$.
    - $A \leq B$ : il existe donc une machine $R$ qui transforme correctement les instances de $A$ en instances de $B$.

    On **pose** la machine suivante :

    ```mermaid
    flowchart LR
        classDef instance fill:lightblue,stroke:transparent,fill:transparent;
        classDef machine fill:pink;
        classDef reduction fill:lightgreen,stroke:green;
        classDef answer fill:lightblue,stroke:transparent,fill:transparent;

        subgraph MM["$$M'$$"]
        R--> J["$$I_B$$"];
        J--> M["$$M$$"];
        end

        I["$$I_A$$"] --> R@{ shape: delay };
        M--> X["oui/non"];
        class I,J instance;
        class R reduction;
        class M machine;
        class X answer;
    ```

    Cette machine prend donc en entrée une instance de $A$ et répond oui/non. De plus :

    1. $M'$ termine sur toute entrée, car $R$ termine et $M$ termine par définition.
    2. $I_A$ est une instance positive $\Leftrightarrow$ $I_B$ est une instance positive $\Leftrightarrow$ $M(I_B) = oui$ $\Leftrightarrow$ $M'(I_A) = oui$.

    Donc $M'$ décide $A$, donc $A$ est décidable.

!!!note "Remarque"
    Dans la démonstration précédente, la machine $M'$ a été introduite par un schéma mais on aurait tout aussi bien pu la donner sous d'algorithme en pseudo-code :
    ```
    Entrée : I_A
    I_B <- R(I_A)
    rep <- M(I_B)
    Répondre rep
    ```
    ou même de fonction pseudo-code :
    ```
    MPRIME(I_A)
        I_B <- R(I_A)
        return M(I_B)
    ```
    ou encore de fonction C ou OCaml :
    ```c
    bool Mprime(Instance ia) {
        Instance ib = R(ia);
        return M(ib);
    }
    ```
    Je trouve la représentation schématique plus claire mais toutes ces propositions sont valides

## 2. La classe **P**

Le fait qu'un problème soit décidable ne suffit pas à dire qu'on sait le traiter en pratique. En effet, il se peut que les algorithmes qu'on conait pour le résoudre soit de complexité trop élevés pour pouvoir être utilisés en pratique. Nous allons donc maintenant ajouter une condition sur la complexité de la machine qui résout le problème.

La classe **P** est la classe des problèmes pour lesquels il existe un algorithme de complexité polynomiale pour les résoudre.

!!!abstract "Définition (classe **P**)"
    Un problème de décision est dans la **classe P**, s'il existe un nombre réel $k > 0$ et une machine $M$ prenant en entrée une instance $I$ telle que :

    1. $M$ donne en sortie la bonne réponse *oui* ou *non* pour l'instance $I$
    2. Dans le pire cas, le temps d'exécution de la machine est $O(n^k)$ avec $n$ la taille de l'instance $I$

    ```mermaid
    flowchart LR
        classDef instance fill:lightblue,stroke:transparent,fill:transparent;
        classDef machine fill:pink;
        classDef answer fill:lightblue,stroke:transparent,fill:transparent;
        I["instance I"] --> M;
        M --> R[oui/non];
        class I instance;
        class M machine;
        class R answer;
    ```
On remarque que la condition (2) implique nécessairement que la machine termine sur toute entrée et qu'un problème dans la classe **P** est toujours un problème décidable.

Dans la définition, on aurait pu remplacer le réel $k$ par l'existence d'un polynôme $Q$ tel que le temps d'exécution pire cas est en $O(Q(n))$. Cela est totalement équivalent à la définition donnée et c'est aussi pour cela que la classe s'appelle **P** comme *polynome*.

!!!example "Exemple"
    Soit le problème de décision suivant qu'on appellera *TABTRIE* :

    - **Instance :** un tableau $T$ d'entiers
    - **Question :** le tableau $T$ est-il trié par ordre croissant ? 

    Montrer que le problème *TABTRIE* appartient à **P**.
    ???note "Solution"
        On considère l'algorithme en pseudo-code suivant :
        ```
        Entrées : T
        n <- longueur(T)
        Pour i allant de 0 à n-2 Faire
            Si T[i] > T[i+1] Alors
                Répondre NON
            FinSi
        FinPour
        Répondre OUI
        ```
        Cet algorithme répond correctement à la question.
        Dans le pire cas sa complexité est $O(n)$ qui est bien polynomiale en fonction de la taille de l'instance ($n$). Donc *TABTRIE* $\in$ **P**.

        Remarquer que cela implique forcément que *TABTRIE* est décidable...


!!!warning "Attention à la taille de l'instance !"
    Soit le problème de décision suivant appelé *PRIME* :

    - **Instance :** un entier naturel $n$ 
    - **Question :** $n$ est-il premier ? 

    Montrer que *PRIME* est dans **P**.
    ???bug "Solution fausse"
        On considère l'algorithme en pseudo-code suivant :
        ```
        Entrées : n
        Pour k allant de 2 à n-1 Faire
            Si n mod k == 0 Alors // si k divise n
                Répondre NON
            FinSi
        FinPour
        Répondre OUI
        ```
        Cet algorithme répond correctement à la question. Dans le pire cas sa complexité est $O(n)$ **MAIS ATTENTION** dans ce cas $n$ n'est pas la **TALLE DE L'INSTANCE** donc on ne peut pas conclure que *PRIME* $\in P$.

        En effet, ici dans ce problème $n$ est un entier quelconque aussi grand qu'on veut et sa taille en octets (si on l'écrit en binaire) est de l'ordre de $p = \log_2(n)$. Il fallait donc exprimer la complexité en fonction de $p$ (la taille de l'instance) et non de $n$. Avec notre algorithme on trouve donc que la complexité est $O(2^p)$ (exponentielle) ce qui ne permet pas de conclure que *PRIME* $\in$ **P**.

    En réalité *PRIME* est bien un problème dans **P** mais la démonstration de ce résultat est très difficile et n'a été résolue qu'en 2002 par 3 chercheurs indiens qui ont mis au point l['algorithme AKS](https://en.wikipedia.org/wiki/AKS_primality_test). Bien que cet algorithme soit de complexité polynomiale, il n'est pas adapté à l'usage pratique...

Bien évidemment il y a beaucoup d'autres exemples de problèmes qui sont dans **P**. Si on y réfléchit bien, la grande majorité des algorithmes que vous avez étudiés jusqu'à présent ont des complexités polynomiales et permettent donc de répondre en temps polynomial à des problèmes de décision.

En informatique théorique, on considère donc que la classe **P** est l'ensemble des problèmes qu'on peut résoudre sur ordinateur *en temps raisonnable* (bien que cela soit une simplification très grossière).

## 3. La classe **NP**

Certains problèmes que l'on rencontre en informatique sont difficiles à résoudre efficacement. Cependant si on vous donne une solution au problème, il est facile de vérifier que cette solution est la bonne.

Un exemple important est celui du problème appelé *SAT* :

- **Instance :** une formule $F$ de la logique propositionnelle
- **Question :** $F$ est elle satisfiable ?

Il est difficile de concevoir un algorithme qui permette de répondre à cette question en temps polynomial par rapport à la taille de la formule. Vous connaissez bien quelques algorithmes pour le résoudre (dresser la table de vérité de la formule, algorithme de Quine) mais ils sont tous de complexité exponentielle.

Par contre, si on vous donne une valuation $\varphi$ qui satisfait $F$, alors il est très facile de **vérifier** que cette valuation convient bien, c'est-à-dire que $⟦F⟧_\varphi = true$.
Autrement dit, on peut facilement écrire un algorithme à **deux entrées** une pour une formule et l'autre pour une valuation et qui vérifie si la valuation donnée satisfait bien la formule, tout cela en temps polynomial par rapport à la la taille de la formule. On peut par exemple procéder par récurrence en OCaml, comme ceci:

```ocaml title="Vérificateur pour SAT"
    type formule = Var of int | Not of formule | Et of formule | Ou of formule;;

    let rec verificateur f phi = match f with
    | Var(i) -> phi.(i) (* valuation donnée sous forme d'un bool array *)
    | Not g -> not (verificateur g phi)
    | Et(g, h) -> (verificateur g phi) && (verificateur h phi)
    | Ou(g, h) -> (verificateur g phi) || (verificateur h phi)
    ;;
```


Cette notion correspond à la classe de problèmes appelée **NP**.

!!!abstract "Définition (classe **NP**)"
    Un problème de décision $A$ est dans la **classe NP**, s'il existe un nombre réel $k > 0$ et une machine $V$ appelée *vérificateur* ayant deux entrées :

    - une entrée $I$ : pour une instance du problème de décision
    - une entrée $C$ : appelée **certificat**

    et qui répond oui/non avec le comportement suivant :
    
    1. $V(I, C)$ s'exécute dans le pire cas en temps $O(n^k)$ avec $n = |I|$ la taille de l'instance.
    2. $I$ est une instance positive de $A$ $\Leftrightarrow$ il existe une entrée $C$ telle que $V(I, C) = oui$.

    ```mermaid
    %%{init: { "flowchart": { "curve": "stepAfter" } }}%%
    flowchart LR
        classDef instance fill:lightblue,stroke:transparent,fill:transparent;
        classDef machine fill:pink;
        classDef answer fill:lightblue,stroke:transparent,fill:transparent;
        I["instance I"] --> V["vérificateur V"];
        C["certificat C"] --> V;
        V --> R[oui/non];
        class I,C instance;
        class M machine;
        class R answer;
    ```

Informellement, la classe **NP** est la classe des probèmes pour lesquels les instances *positives* admettent une *preuve de positivité* $C$ qui peut être *vérifiée* en temps polynomial par un algorithme. Dans le cas de *SAT* par exemple, un certificat est une valuation qui satisfait la formule F donnée.

!!!tip "Théorème"
    **P** $\subset$ **NP**

???note "Démonstration"
    Soit $A$ un problème dans **P**. Il existe donc un réel $k > 0$ et une machine $M$ qui décide $A$ en temps $O(n^k)$ avec $n$ la taille de l'instance. On **pose** la machine $V$ définie par $V(I, C) = M(I)$. On a alors :

    - La machine $V$ s'exécute en pire cas en temps $O(n^k)$.
    - Si la réponse à $I$ est oui, alors en prenant n'importe quel certificat, par exemple le certficat vide $C = \varnothing$, on a $V(I, C) = M(I) = oui$.
    - Réciproquement, s'il existe $C$ tel que $V(I, C) = oui$ alors $M(I) = V(I, C) = oui$ donc $I$ est positive.


J'espère que ce théorème chassera en vous l'idée que **NP** signifierait "non polynomial"...

!!!tip "Problème ouvert depuis 1971"
    On ne sait pas aujourd'hui si **P** = **NP** ou si **P** $\neq$ **NP**.

## La classe NP-complet

!!!tip "Théorème de Cook-Levin"
    Le problème SAT est NP-complet

### Exemples de problèmes NP-complets

Réduction de SAT à 3-SAT
Réduction de 3-SAT à CNF-SAT
Réduction de 3-SAT à CLIQUE
Réduction de 3-SAT à HAMILTON-PATH

## Les problèmes indécidables

