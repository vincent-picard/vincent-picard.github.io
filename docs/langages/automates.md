# Automates finis

Dans le chapitre sur les [langages réguliers](/langages/regexp), nous avons défini les **mots** et les **langages formels**. Nous avons décrit une certaine famille de langages appelée **langages réguliers**, qui sont décrits par un motif appelé **expression régulière**.

Une faiblesse des expressions régulières est qu'il est *a priori* difficile d'énoncer un algorithme général permettant de vérifier si un mot $u$ appartient au langage dénoté par une expression régulière. Le formalisme est expressif, facile à utiliser de notre point de vue, mais difficile à mettre en oeuvre sur une machine.

Dans ce chapitre on introduit la notion d'**automate** est qui une machine simple permettant de reconnaître des mots, et donc des langages. Contrairement aux expressions régulières, ce formalisme s'implémente facilement et efficacement sur un ordinateur.

Les automates sont aussi très importants en informatique car ils constitue un premier exemple de **machine formelle**, c'est-à-dire une représentation abstraite d'une machine capable de calculer. L'exemple le plus célèbre de machine formelle est la **machine de Turing** mais pour bien la comprendre, il faut commencer par comprendre les automates.

Dans tout ce chapitre, on se fixe un alphabet $\Sigma$ sur lequel on travaille.

## 1. Automates finis déterministes

### A. Définition

Commençons par donner une vision intuitive de la machine que nous allons construire :

- un automate est une machine qui se situe à tout moment dans un certain *état*; elle a un nombre
fini d'états possibles;
- un automate prend en entrée un mot qu'elle lit de gauche à droite, lettre par lettre;
- lorsque l'automate est dans un état $q$ et qu'il lit une lettre $c$, alors il *transite* vers un état $\delta(q, c)$ qui ne dépend que de l'état actuel $q$ et de la lettre lue $c$.

Voici la définition formelle de cette machine :

!!! abstract "Définition"
    Un **automate fini déterministe** (afd) est un quadruplet $A = (Q, q_0, F, \delta)$ où :

    - $Q$ est un ensemble **fini** d'**états**;
    - $q_0 \in Q$ est un état particulier appelé **état initial**;
    - $F \subset Q$ est un ensemble d'**états finaux**;
    - $\delta : Q \times \Sigma \to Q$ est la **fonction de transition** de l'automate.

La fonction de transition $\delta$ n'est pas nécessairement définie sur $Q \times \Sigma$ en entier, autrement dit, pour certains états $q$ et certaines lettres $c$, $\delta(q, c)$ peut ne pas être défini. Dans ce cas, on dit que l'automate **bloque** à la lecture de $c$ dans l'état $q$.

Un automate se représente plus volontier sous forme d'un *graphe orienté*, par exemple ainsi :

<figure markdown="span">
![Exemple d'automate fini déterministe](fig/automates/afd/afd-1.svg)
</figure>

Dans cette représentation :

- les sommets du graphe représentent les états de l'automate
- les arcs représentent les transitions, l'étiquette d'un arc est la lettre lue
- une flèche entrante marque l'état initial
- un trait double entoure les états finaux

Ainsi, dans cet exemple, l'automate représenté est $A = (Q, q_0, F, \delta)$ où :

- $Q = \{q_0, q_1, q_2\}$
- $q_0 = q_0$
- $F = \{q_1, q_2\}$
- $\delta$ est la fonction de transition que l'on peut représenter sous forme de **table de transition** de l'automate :

|état $q$ | lettre $c$ | arrivée $\delta(q, c)$ |
|:-:|:-:|:-:|
| $q_0$ | $a$ | $q_0$ |
| $q_0$ | $b$ | $q_1$ |
| $q_1$ | $a$ | $q_0$ |
| $q_1$ | $b$ | $q_2$ |
| $q_2$ | $a$ | $q_0$ |

!!! info "Remarque"
    Dans certains textes, les états finaux peuvent être marqués par une flèche sortante plutôt qu'un trait double.

### B. Calcul d'un automate

Nous avons défini formellement un automate et il nous reste maintenant à décrire son fonctionnement c'est-à-dire décrire comment cette machine *calcule*.

Un automate est une machine capable de *lire des mots*. Lorsque l'automate est dans un état $q_1$ et que l'on lit une lettre $c$, l'automate transitionne vers l'état $q_2 = \delta(q, c)$ (sauf s'il y a blocage). Pour tout état $q_1$ et $q_2$ et toute lettre $c \in \Sigma$, on notera :

$$
q_1 \longrightarrow^c q_2
$$

lorsque $q_2 = \delta(q_1, c)$.

!!! info "Notation alternative"
    Il est aussi possible de noter $q_1.c = q_2$ lorsque $\delta(q_1, c) = q_2$.

!!! abstract "Définition (calcul)"
    Un **calcul** d'un automate fini déterministe $A = (Q, q_0, F, \delta)$ est un chemin dans l'automate, c'est-à-dire une suite d'états :

    $$
    u_0 \longrightarrow^{w_1} u_1 \longrightarrow^{w_2} u_2 \longrightarrow^{w_3} \cdots \longrightarrow^{w_{n-1}} u_{n-1} \longrightarrow^{w_n} u_n
    $$

    où les $w_i$ sont des lettres lues et qui vérifie bien :

    $$
    \forall k \in \{0, \dots, n-1\}, u_{k+1} = \delta(u_k, w_k).
    $$

!!! example "Exemple (calcul d'un automate)"
    Dans l'automate :
    <figure>
    ![Exemple d'automate fini déterministe](fig/automates/afd/afd-1.svg)
    </figure>
    
    $$
    q_0 \longrightarrow^a q_0 \longrightarrow^b q_1 \longrightarrow^b q_2 \longrightarrow^a q_0 \longrightarrow^b q_1
    $$

    est un calcul de l'automate qui correspond à la lecture du mot $abbab$ depuis l'état $q_0$ et qui mène en $q_1$.

On remarque que pour un état de départ $q$, et un mot $u$ donné, il ne peut exister qu'un seul calcul depuis cet état, c'est pour cette raison que l'on dit que l'automate est **déterministe** : il n'a qu'un seul comportement possible à la lecture d'un mot en entrée. Cela peut être rendu explicite par la définition de la *fonction de transition étendue* :

!!! abstract "Définition (fonction de transition étendue)"
    Soit $A = (Q, q_0, F, \delta)$ un automate fini déterministe. On définit la **fonction de transition étendue** $\delta^* : Q \times \Sigma^* \to Q$ par :

    $$
    \begin{cases}
    \forall q \in Q,\ \delta^*(q, \varepsilon) = q  \\
    \forall q \in Q, \ \forall u \in \Sigma^*, \ \forall c \in \Sigma, \ \delta^*(q, uc) = \delta(\delta^*(q, u), c) \\
    \end{cases}
    $$

Ainsi, la fonction $\delta^*$ étend la fonction $\delta$ aux mots. Tout comme la fonction $\delta$, elle n'est pas forcément définie sur $Q \times \Sigma^*$ : la lecture d'un mot peut provoquer un blocage.

!!! info "Notation alternative"
    Il est aussi possible de noter $q_1.u = q_2$ lorsque $\delta^*(q_1, u) = q_2$. Cette notation plus mathématique montre qu'on peut faire *agir* le monoïde $\Sigma^*$ sur l'ensemble d'états $Q$.



### C. Langage reconnu

!!!abstract "Définition (mot reconnu)"
    Soit $A = (Q, q_0, F, \delta)$ un automate fini déterministe. Un mot $u \in \Sigma^*$ est **reconnu** (on dit aussi **accepté**) par $A$ lorsque $\delta^*(q_0, u) \in F$.

Autrement dit, un mot est reconnu est par un automate si sa lecture à partir l'état initial $q_0$ :

1. ne provoque pas de blocage 
2. mène l'automate dans un de ses états finaux

!!!abstract "Définition (langage reconnu)"
    Soit $A = (Q, q_0, F, \delta)$ un automate fini déterministe. Le **langage reconnu** (aussi appelé **langage accepté**) par l'automate $A$, noté $\mathcal{L}(A)$ est :

    $$
    \mathcal{L}(A) = \{ u \in \Sigma^*, \delta^*(q, u) \in F \}
    $$

Autrement dit, le langage reconnu est l'ensemble des mots reconnus par l'automate.

!!!abstract "Définition (langage reconnaissable)"
    - Un langage $L$ est dit **reconnaissable par automate fini** s'il existe un automate fini déterministe $A$ tel que $\mathcal{L}(A) = L$.
    - L'ensemble des langages sur $\Sigma$ reconnaissables par automate fini est appelé **classe des langages reconnaissables**. Elle sera notéee $\def\rec#1{{\text{REC}(#1)}} \rec{\Sigma}$ dans ce cours.

Étudions maintenant quelques exemples de langages pouvant être reconnus par automate fini déterministe.

!!!example "Exemple : mots commençant par ..."
    On souhaite reconnaître par automate le langage des mots sur $\Sigma = \{a, b\}$ qui commencent par $aba$, c'est-à-dire ayant $aba$ pour préfixe. Pour cela, on peut proposer l'automate suivant :
    <figure>
    ![Automate reconnaissant les mots qui commencent par aba](fig/automates/afd/afd-2.svg)
    </figure>
    La dernière flèche, tout à droite, est étiquetée par $a, b$, ce qui signifie qu'il y a en réalité 2 transitions. On utilise souvent cette notation pour alléger les figures.
    L'automate peut se lire en deux parties :

    - Une première phase où on lit le préfixe $aba$, remarquer comme on utilise le **blocage** pour rejeter les mots qui ne commencent pas par $aba$
    - Une seconde phase où on boucle sur l'état final, ce qui signifie qu'on accepte maintenant toute suite de lettres

!!!example "Exemple : mots contenant un nombre impair de $a$"
   On souhaite reconnaître par automate le langage des mots sur $\Sigma = \{a, b\}$ contenant un nombre impair de $a$. Pour cela, on peut proposer l'automate suivant :

!!!example "Exercice"
    En vous inspirant de l'exemple précédent, proposer un automate pour reconnaître les mots sur $\Sigma = \{a, b\}$ dont le nombre de $b$ est de la forme $3k + 1$ avec $k \in \mathbb{N}$.

### D. Programmation


## 2. Opérations classiques sur les automates

### A. Accessibilité et émondage

### B. Complétion d'un automate

### C. Automate complémentaire

### D. Automate produit

## 3. Automates finis non déterministes

## 4. Automates finis non déterministes à transitions spontanées

## 5. Langages non reconnaissables par automate
