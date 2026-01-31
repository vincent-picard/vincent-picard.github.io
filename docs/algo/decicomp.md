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

La proposition suivante établit que la réduction (polynomiale) se comporte presque comme un ordre (il manque l'antisymétrie) sur les problèmes de décision.

!!!tip "Proposition"
    Soit $A$, $B$, $C$ trois problèmes de décision alors :

    1. $A \leq A$
    2. $A \leq_P A$
    3. $A \leq B$ et $B \leq C \Rightarrow A \leq C$
    4. $A \leq_p B$ et $B \leq_P C \Rightarrow A \leq_P C$

!!!note "Démonstration"
    - Les points (1) et (2) sont évidents, il suffit de prendre la *machine identité* (recopie l'entrée sur la sortie) pour établir la réduction. 
    - Montrons (3) : soit $R_1$ la machine qui réduit de $A$ à $B$ et $R_2$ la machine qui réduit de $A$ à $C$. On construit la machine $R$ suivante :
    ```mermaid
    flowchart LR
        classDef instance fill:lightblue,stroke:transparent,fill:transparent;
        classDef machine fill:pink;
        classDef reduction fill:lightgreen,stroke:green;
        classDef answer fill:lightblue,stroke:transparent,fill:transparent;

        subgraph R["$$R$$"]
        RA["$$R_1$$"]--> J["$$I_B$$"];
        J--> RB["$$R_2$$"];
        end

        I["$$I_A$$"] --> RA@{ shape: delay };
        RB@{ shape: delay } --> K["$$I_C$$"];
        class I,J,K instance;
        class RA,RB reduction;
    ```
    Cette machine termine sur toute entrée (car $R_1$ et $R_2$ terminent). De plus, $I_A$ est positive ssi $I_B$ est positive (d'après la réduction 1) ssi $I_C$ est positive (d'après la réduction 2). $R$ est donc bien une réduction de $A$ vers $C$.
    - Montrons (4) : on reprend la même preuve que (3) mais il faut également montrer que la réduction est polynomiale, en supposant que $R_1$ et $R_2$ le sont. Il existe donc des réels $k_1 > 0$ et $k_2 > 0$ tels que $R_1$ est de complexité $O(|I_A|^{k_1})$ et $R_2$ de complexité $O(|I_B|^{k_2})$. Une autre façon de le dire est qu'il existe des constantes $C_1$ et $C_2$ tels que les temps de calcul de $R_1$ et $R_2$ vérifient : $T_1 \leq C_1 |I_A|^{k_1}$ et $T_2 \leq C_2 |I_B|^{k_2}$. Maintenant, voici le point délicat de la preuve : $R_1$ ne peut pas produire une sortie plus grande que sont temps de calcul, car écrire sur la sortie consomme justement du temps de calcul de $R_1$, donc $|I_B| \leq T_1$. On obtient alors que le temps de calcul de $R$ vérifie : $T = T_1 + T_2 \leq C_1 |I_A|^{k_1} + C_2 |I_B|^{k_2} \leq C_1 |I_A|^{k_1} + C_2 C_1^{k_2} |I_A|^{k_1k_2} \leq C |I_A|^{\max(k_1,k_1k_2)}$ avec $C = \max(C_1, C_2C_2^{k_2})$ qui est une constante. Donc $R$ est bien de complexité polynomiale.
    
!!!example "Exercice"
    Pour vérifier que vous avez bien compris : écrire la machine $R$ de la démonstration sous forme d'algorithme en pseudo-code; puis de fonction en langage C

## 2. La classe **P**

Le fait qu'un problème soit décidable ne suffit pas à dire qu'on sait le traiter en pratique. En effet, il se peut que les algorithmes qu'on connaisse pour le résoudre soient de complexité trop élevée pour pouvoir être utilisés en pratique. Nous allons donc maintenant ajouter une condition sur la complexité de la machine qui résout le problème.

La classe **P** est l'ensemble des problèmes de décision pour lesquels il existe un algorithme de complexité polynomiale pour les résoudre.

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

Dans la définition, on aurait pu remplacer le réel $k$ par l'existence d'un polynôme $Q$ tel que le temps d'exécution pire cas est en $O(Q(n))$. Cela est totalement équivalent à la définition donnée et c'est aussi pour cela que la classe s'appelle **P** comme *polynôme*.

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

!!!tip "Proposition"
    Soit $A$ et $B$ deux problèmes de décision. Si
    
    1. $A \leq_P B$
    2. $B \in \mathbf{P}$

    Alors $A \in \mathbf{P}$
Cette proposition pourrait se reformuler : *si on est plus facile qu'un problème facile alors on est facile*.

!!!note "Démonstration"
    Soit $A$ et $B$ deux problèmes de décision vérifiant (1) et (2). D'après (1), il existe une machine $R$ qui réduit $A$ vers $B$ en temps polynomial. D'après (2), il existe une machine $M$ qui décide $B$ en temps polynomial. On construit donc la machine suivante $M'$ suivante :
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
    Alors on bien :
    
    - $I_A$ est positive $\Leftrightarrow$ $I_B$ est positive $\Leftrightarrow$ $M(I_B) = oui$ $\Leftrightarrow M'(I_A) = oui$
    - $M'$ fonctionne en temps polynomial dans le pire cas (même preuve que pour la composition des réductions $R_1$ et $R_2$ ci-dessus).


## 3. La classe **NP**

!!!danger "Spoiler"
    **NP** ne signifie pas *non polynomial*

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


Cette notion de problème facile à vérifier correspond à la classe de problèmes appelée **NP**.

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

!!!note "Démonstration"
    Soit $A$ un problème dans **P**. Il existe donc un réel $k > 0$ et une machine $M$ qui décide $A$ en temps $O(n^k)$ avec $n$ la taille de l'instance. On **pose** la machine $V$ définie par $V(I, C) = M(I)$. On a alors :

    - La machine $V$ s'exécute en pire cas en temps $O(n^k)$.
    - Si la réponse à $I$ est oui, alors en prenant n'importe quel certificat, par exemple le certficat vide $C = \varnothing$, on a $V(I, C) = M(I) = oui$.
    - Réciproquement, s'il existe $C$ tel que $V(I, C) = oui$ alors $M(I) = V(I, C) = oui$ donc $I$ est positive.
    ```mermaid
    %%{init: { "flowchart": { "curve": "stepAfter" } }}%%
    flowchart LR
        classDef instance fill:lightblue,stroke:transparent,fill:transparent;
        classDef machine fill:pink;
        classDef answer fill:lightblue,stroke:transparent,fill:transparent;

        subgraph V
        X@{ shape: stop };
        M["$$M$$"];
        end
        I["instance I"] --> M;
        M --> R[oui/non]
        C["certificat C"] --> X;
        class I,C instance;
        class M machine;
        class R answer;
    ```
    **Conclusion :** on a bien construit un vérificateur en temps polynomial pour le problème $A$, donc $A \in \mathbf{NP}$


J'espère que ce théorème chassera en vous l'idée que **NP** signifierait "non polynomial"...

!!!tip "Problème ouvert depuis 1971"
    On ne sait pas aujourd'hui si **P** = **NP** ou si **P** $\neq$ **NP**.

## 4. La classe NP-complet

On s'intéresse ici à certains problèmes de **NP** qui combinent deux aspects :

- on les rencontre assez fréquemment en informatique
- ils sont particulièrement coriaces à résoudre

!!!abstract "Définition (problème NP-complet)"
    Un problème de décision $A$ est **NP**-complet s'il vérifie :

    1. $A \in \mathbf{NP}$
    2. $A$ est **NP**-difficile, ce qui signifie : $\forall B \in \mathbf{NP}, B \leq_P A$

Attention à ne pas oublier l'hypothèse 1. L'hypothèse 2 signifie que les problèmes de **NP**-difficiles sont des *majorants* de **NP**, autrement dit les problèmes **NP**-complets sont les problèmes les plus difficiles de **NP**.

Bien sûr, la première question que l'on se pose est *existe-t-il de tels problèmes ?*, la réponse est *oui* d'après le théorème (admis) suivant :

!!!tip "Théorème de Cook-Levin (1971)"
    Le problème *SAT* est **NP**-complet

Nous avons déjà montré ci-dessus que *SAT* $\in$ **NP**, la partie difficile et admise de ce théorème est que *SAT* est aussi **NP**-difficile.

Pour se convaincre de la difficulté des problèmes **NP**-complets on peut aussi considérer la proposition suivante.

!!!tip "Proposition"
    Soit $A$ un problème $NP$-complet. 

    1. S'il existe une machine $M$ qui décide $A$ en temps polynomial alors $\mathbf{P} = \mathbf{NP}$.
    2. Si $\mathbf{P} \neq \mathbf{NP}$ alors il n'existe pas de machine pour décider $A$ en temps polynomial.

Autrement dit (1) dit que trouver un algorithme polynomial pour résoudre un problème **NP**-complet revient à résoudre le célèbre problème ouvert. La reformulation (2) dit que si on admet que $\mathbf{P} \neq \mathbf{NP}$  alors il est impossible de trouver un algorithme de complexité raisonnable pour résoudre $A$...

Ceci explique aussi pourquoi on s'intéresse tant à la question $P = NP$ ?

!!!note "Démonstration"
    - (2) est la contraposée de (1) donc il suffit de montrer (1)
    - Supposons qu'il existe une machine $M$ pour résoudre $A$ en temps polynomial, donc $A \in \mathbf{P}$. On sait déjà que $\mathbf{P} \subset \mathbf{NP}$, il reste à montrer l'inclusion inverse. Soit $B \in \mathbf{NP}$, comme $A$ est **NP**-difficile, $B \leq_P A$. Mais d'après la proposition de la partie 2, on en déduit que $B \in \mathbf{P}$. Conclusion $\mathbf{NP} \subset \mathbf{P}$.

### Exemples de problèmes NP-complets

Il existe une multitude d'autres problèmes **NP**-complets. Pour démontrer la **NP**-complétude, on utilise en général la proposition suivante :

!!!tip "Proposition"
    Soit $A$ un problème de décision **NP**-complet et $B$ un problème de décision. Si
    
    1. $B \in \mathbf{NP}$
    2. $A \leq_P B$

    Alors $B$ est **NP**-complet.

!!!note "Démonstration"
    D'après (1), $B \in \mathbf{NP}$, il reste donc à montrer que $B$ est **NP**-difficile. Soit $C$ un problème de **NP**, comme $A$ est **NP**-complet, on a $C \leq_P A$. De plus, $A \leq_P B$ d'après (2), donc par transitivité de $\leq_P$, on a $C \leq_P B$. Ainsi $B$ est bien **NP**-difficile. Conclusion : $B$ est **NP**-complet.

Autrement dit pour montrer qu'un problème est **NP**-complet, il suffit de montrer qu'il est dans **NP** puis de montrer qu'il est plus difficile qu'un problème dont on sait déjà qu'il est **NP**-complet. Cette méthode par réduction permet de montrer à partir de *SAT* que de nombreux autres problèmes sont **NP**-complets. Étudions quelques exemples.

#### Réduction de SAT à 3-SAT

Le problème 3-SAT est similaire à SAT mais on se restreint aux formules sour formes normales conjonctives avec 3 littéraux par clause au plus.

- **Instance :** une formule $F$ de la logique propositionnelle sous forme normale conjonctive (CNF) avec 3 littéraux par clause au plus.
- **Question :** $F$ est elle satisfiable ?

Il est facile de montrer que 3-SAT $\in$ **NP** : on peut utiliser exactement le même vérificateur que pour *SAT*.

Montrons que SAT $\leq_P$ 3-SAT. On décrit l'algorithme de réduction à l'aide d'un exemple :
$F = x_1 \to \neg(x_2 \leftrightarrow (x_1 \land x_4))$

##### Étape 1

On voit la formule comme un arbre et on *descend* les négations aux feuilles à l'aide des équivalences suivantes :

- $\neg(A \land B) \equiv (\neg A \lor \neg B)$
- $\neg(A \lor B) \equiv (\neg A \land \neg B)$
- $\neg(A \to B) \equiv (A \land \neg B)$
- $\neg(A \leftrightarrow B) \equiv (A \leftrightarrow \neg B)$

On obtient ainsi un arbre équivalent, où les feuilles sont des littéraux, et les noeuds sont des connecteurs parmi $\land, \lor, \to, \leftrightarrow$. Dans notre exemple on obtient :
$F \equiv (x_1 \to (x_2 \leftrightarrow (\neg x_1 \lor \neg x_4)))$

Ce qui se représente sous forme d'arbre binaire :
    ```mermaid
    graph TD
        A("$$\to$$") --> B[$$x_1$$];
        A --> C("$$\leftrightarrow$$");
        C --> D["$$x_2$$"];
        C --> E("$$\lor$$");
        E --> F["$$\neg x_1$$"];
        E --> G["$$\neg x_4$$"];
    ```

##### Étape 2

On introduit des nouvelles variables $y_1, y_2, \dots$ pour chaque noeud de l'arbre binaire obtenu (chaque sous formule en fait) :
    ```mermaid
    graph TD
        A("$$y_1$$") --> B[$$x_1$$];
        A --> C("$$y_2$$");
        C --> D["$$x_2$$"];
        C --> E("$$y_3$$");
        E --> F["$$\neg x_1$$"];
        E --> G["$$\neg x_4$$"];
    ```
On va considérer que $y_1$ est la variable associée à la racine de l'arbre.

##### Étape 3

On va contraindre chaque variables $y_i$ à prendre pour valeur *l'évaluation* de la sous-formule à laquelle est elle est associée. On introduit pour cela des formules propositionnelles $N_1, N_2, \dots$ ainsi :

- $N_1 = (y_1 \leftrightarrow (x_1 \to y_2)$
- $N_2 = (y_2 \leftrightarrow (x_2 \leftrightarrow y_3))$
- $N_3 = (y_3 \leftrightarrow (\neg x_1 \leftrightarrow \neg x_4))$

Plus généralement, la formule $N_i$ a pour forme $N_i = (y_i \leftrightarrow (g \bowtie d)$ avec $g$ et $d$ les variables (ou littéraux) correspondant aux fils gauche et droit et $\bowtie$ le connecteur logique du noeud.

##### Étape 4

On remarque alors que chaque formule $N_i$ fait intervenir au plus 3 variables. On peut donc lui trouver une formule équivalente sous forme normale conjonctive avec des clauses contenant 3 littéraux au plus. On utilise par exemple sa table de vérité qui fait 8 lignes au plus (donc 8 clauses dans le pire cas pour la FNC).

Notons $C_i$ la formule sous forme 3-CNF associée à cahque $N_i$

##### Étape 5

Au final on pose la formule $G = y_1 \land C_1 \land \dots \land C_m$, qui est bien sous forme normale conjonctive avec au plus 3 littéraux dans chaque clause. De plus, par construction $F$ est satisfiable si et seulement si $G$ est satisfiable. On remarque enfin que la réduction est bien polynomiale :

- étape 1 : descendre les négations est un parcours récursif de l'arbre binaire, donc de complexité linéaire 
- étape 2 : on introduit $m$ variables $y_i$ qui sont en même quantité que les noeuds internes de l'arbre binaire. Mais on sait que dans un arbre binaire: $f = m + 1$ avec $f$ le nombre de feuilles dans un arbre binaire. Donc $|F| = m + f = 2m + 1$ donc $m$ est linéaire en la taille de $F$ : $m = O(|F|)$.
- étape 3 : $O(m)$ donc $O(|F|)$
- étape 4 : la construction de chaque $C_i$ prend un temps constant (en fonction de |F|), donc encore une fois cette étape prend un temps $O(m)$
- étape 5 : la formule $G$ construite a donc pour taille $O(m) = O(|F|)$.

La réduction est bien polynomiale (et même linéaire en fait !)


Conclusion : on a montré que 3-SAT est **NP** et que SAT $\leq_P$ 3-SAT, donc 3-SAT est **NP**-complet.

#### Réduction de 3-SAT à CNF-SAT

Cette réduction est beaucoup plus simple que la précédente !

On considère cette fois le problème CNF-SAT :

- **Instance :** une formule $F$ de la logique propositionnelle sous forme normale conjonctive (CNF).
- **Question :** $F$ est elle satisfiable ?

On montre d'abord que CNF-SAT est dans NP, en utilisant le même vérificateur que pour SAT.

Ensuite on remarque que la fonction identité est une réduction valide pour montrer 3-SAT $\leq_P$ CNF-SAT. En effet, chaque formule au format 3-CNF est bien une formule CNF en particulier.

Ainsi CNF-SAT est **NP**-complet.

Au final on a démontré que 2 variantes du problème SAT sont **NP**-complet.

#### Réduction de 3-SAT à CLIQUE

Attaquons-nous maintenant à une réduction entre deux problèmes qui n'ont a priori rien à voir. On considère le problème *CLIQUE* :

- **Instance :** un graphe non orienté $G$ et un entier $K$. 
- **Question :** existe-t-il une clique de taille $K$ dans le graphe $G$ ?

Montrons que *CLIQUE* est **NP**-complet.

Tout d'abord *CLIQUE* est bien dans **NP**. En effet un certificat est par exemple, une liste $L$ de $K$ sommets qui forme une clique dans $G$. Il est alors facile d'écrire un algorithme de complexité polynomiale, qui prend en entrée $(G, K)$ d'une part (l'instance) et $L$ d'autre part (le certificat) et qui vérifie que les sommets de $L$ forment bien une clique de taille $K$. 

Montrons maintenant que 3-SAT $\leq_P$ CLIQUE.

La réduction doit partir d'une formule propositionnelle sous forme normale conjonctive qui contient 3 littéraux au plus par clause. Le but est de construire un graphe $G$ et de choisir un entier $K$ tel que $F$ est satisfiable si et seulement si $G$ contient une $K$-clique.

On explique la réduction à l'aide de l'exemple suivant :
$F = (\neg x \lor y \lor z) \land (x \lor \neg y) \land (x \lor \neg z)$

On construit alors un graphe qui contient un noeud pour chaque **occurence** de littéral de $F$. Dans ce graphe il existe un arc entre le littéral $\ell$ et le littéral $\ell'$ si et seulement si les deux conditions suivante sont vérifiées :

1. Les occurrences $\ell$ et $\ell'$ n'appartiennent pas à la même clause
2. $\ell$ et $\ell'$ sont compatibles c'est-à-dire qu'il n'existe pas de variable telle que $\ell = x$ et $\ell' = \neg x$ (ou l'inverse).

Voici le graphe $G$ qu'on obtient sur l'exemple :
    ```mermaid
    graph TD
        subgraph X["$$C_1$$"]
        A("$$\neg x$$");
        B("$$y$$");
        C("$$z$$");
        end;
        subgraph Z["$$C_3$$"]
        D("$$\neg z$$");
        E("$$x$$");
        end;
        subgraph Y["$$C_2$$"]
        F("$$\neg y$$");
        G("$$x$$");
        end;
        A---F;
        A---D;
        B---G;
        B---E;
        B---D;
        C---G;
        C---F;
        C---E;
        D---G;
        D---F;
        E---G;
        E---F;
    ```
On choisit également $K = 3$ car il y a 3 clauses dans la formule $F$.

Vérifions que la réduction est correcte :

- Si une valuation satisfait $F$, par exemple $(x,y,z) = (true, true, false)$, alors cette valuation satisfait au moins un littéral par clause. Si on choisit pour chaque clause, l'un de ces littéraux alors on obtient $K$ sommets au total qui forment une clique :
    ```mermaid
    graph TD
        classDef true fill:lightgreen;
        subgraph X["$$C_1$$"]
        A("$$\neg x$$");
        B("$$y$$");
        C("$$z$$");
        end;
        subgraph Z["$$C_3$$"]
        D("$$\neg z$$");
        E("$$x$$");
        end;
        subgraph Y["$$C_2$$"]
        F("$$\neg y$$");
        G("$$x$$");
        end;
        A---F;
        A---D;
        B---G;
        B---E;
        B---D;
        C---G;
        C---F;
        C---E;
        D---G;
        D---F;
        E---G;
        E---F;
        class B,G,D true;
    ```
    En effet, les littéraux sont forcément deux à deux compatibles car ils sont vrais simultanément.

- Réciproquement, si le graphe $G$ admet une $K$ clique alors il y a exactement 1 sommet par clause car les sommets d'une même clause ne sont pas reliés. On pose alors une valuation $\varphi$ qui rend vrai tous les littéraux correspondants (ceci est possible car on n'a pas une variable et sa négation car les littéraux sont 2 à 2 compatibles). Cette valuation rend alors vrai au moins un littéral par clause donc elle satisfait $F$.

Cette réduction est donc correcte, de plus elle est bien polynomiale : le nombre de sommets de $G$ est majoré par $|F|$ donc le graphe s'il est par exemple représenté par matrice d'adjacence a pour taille $O(|F|^2)$.

!!!note "Culture"
    En 1972, Richard Karp (Prix Turing 1985) utilise ce procédé pour montrer que 21 problèmes fréquents en informatique sont NP-complets, on y trouve par exemple :

    - couverture par sommets d'un graphe
    - problème du sac à dos
    - existence de circuits Hamiltoniens dans un graphe
    - partition d'un ensemble d'entiers en deux sous-ensembles de même somme
    - ...


## 5. Les problèmes indécidables

Pour conclure ce chapitre nous considérons maintenant les problèmes de décision qui sont impossibles à résoudre. Un problème est **indécidable** s'il n'est pas décidable, autrement dit s'il n'existe pas de machine (i.e. d'algorithme) qui termine toujours et qui répond oui/non correctement par rapport à l'instance donnée.

L'existence de tels problèmes est surprenante et est la conséquence de deux faits :

- les machines $M$ peuvent être traitées comme des données : toute machine possède un codage qu'on notera $<M>$
- les machines sont capables d'exécuter une machine à partir de son code $<M>$.

!!!abstract "Définition (Machine universelle)"
    Une machine $U$ est universelle si elle est capable d'effectuer le calcul de $M(x)$ si elle possède pour données le code de la machine $<M>$ et l'entrée $x$.

Nous admettons que le modèle de calcul qu'on considère possède cette propriété. En effet : il est possible de voir un algorithme ou un programme C/OCaml comme une donnée (par exemple le fichier source du programme). Il est également possible d'écrire un programme capable d'exécuter cet algorithme ou ce programme à partir de sa description (par exemple un interprète ou un programme qui compile et exécute le code). Autrement dit, nos ordinateurs sont assez puissants pour être capable d'exécuter un programme qu'on lui donne en entrée.

Le fait de pouvoir voir les algorithmes et les programmes comme des données peut sembler être une propriété souhaitée, mais cela va malheureusement entrainer l'existence de problèmes indécidables. Le plus célèbre est le problème **HALT** :

- **Instance** : le code d'une machine $<M>$ et une entrée $x$ pour la machine $M$
- **Question** : le calcul $M(x)$ termine-t-il ?

!!!tip "Proposition"
    **HALT** est indécidable.

!!!note "Démonstration"
    Supposons par l'absurde qu'il existe une telle machine qu'on appelle $H$ qui termine sur toute entrée et qui vérifie $H(<M>, x) = oui$ si et seulement si $M(x)$ termine.
    On considère la machine *diagonale* $D$ prenant en entrée un code de machine $<M>$ et qui fait le calcul suivant, donné en pseudo-code :
    ```
    def D(<M>):
        b <- H(<M>, <M>) // <M> est une suite de 1/0 donc on peut prendre cette information comme x
        if b = true then
            while (true) do {} // boucle infinie
        else
            return true
    ```
    On obtient la contractiction suivante $D(<D>)$ termine si et seulement si $H(<D>, <D>) = false$ si et seulement si $D(<D>)$ ne termine pas. C'est absurde.

Le fait que HALT soit indécidable permet de montrer que beaucoup d'autres problèmes le sont, voici un exemple :

!!!example "Exercice"
    Soit le problème de décision **HW** suivant :

    - **Instance** : le code d'une machine $<M>$ ne prenant pas d'entrée.
    - **Question** : est-ce que la machine $M$ produit en sortie le texte *Hello World!* ?

    Montrer que **HW** est indécidable.

    ???note "Solution"
        Supposons par l'absurde qu'il existe une telle machine $HW$. On va construire une machine $H$ prenant en entrée le code d'une machine $<M>$ et une entrée $x$ pour M et dont voici la description :

        - elle écrit la description d'une machine $<P>$ exécutant le programme suivant : calculer $M(x)$ (machine universelle) puis produire en sorie *Hello World!*
        - elle calcule $HW(<P>)$ et renvoie la réponse oui/non

        Alors si $H(<M>, x) = oui$ c'est que $HW(<P>) = oui$ donc P affiche *Hello world!* et donc le calcul de $M(x)$ s'est terminé. Si $H(<M>, x) = non$ c'est que $HW(<P>) = non$, c'est que P n'affiche pas *Hello world!*, cela n'est possible que si $M(x)$ ne termine pas. Conclusion HW décide HALT c'est absurde. Donc HW n'est pas décidable.

Plus généralement, il existe un théorème (Rice) qui exprime que toute propriété sémantique non triviale sur un programme est indécidable par exemple :

- Est-ce que le programme peut renvoyer la valeur nulle ?
- Est-ce que le programme calcule la fonction "carrée" ? Est-ce que le programme implémente une fonction donnée ?
- Est-ce que le programme envoie un message sur internet ?
- etc...

