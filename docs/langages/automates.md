# Automates finis

Dans le chapitre précédent, nous avons défini les **mots** et les **langages formels**. Nous avons décrit une certaine famille de langages appelée **langages réguliers**, qui sont décrits par un motif appelé **expression régulière**.

Une faiblesse des expressions régulières est qu'il est *a priori* difficile d'énoncer un algorithme général permettant de vérifier si un mot $u$ appartient au langage dénoté par une expression régulière. Le formalisme est expressif, facile à utiliser de notre point de vue, mais difficile à mettre en oeuvre sur une machine.

Dans ce chapitre on introduit la notion d'**automate** est qui une machine simple permettant de reconnaître des mots, et donc des langages. Contrairement aux expressions régulières, ce formalisme s'implémente facilement et efficacement sur un ordinateur.

Les automates sont aussi très importants en informatique car ils constitue un premier exemple de **machine formelle**, c'est-à-dire une représentation abstraite d'une machine capable de calculer. L'exemple le plus célèbre de machine formelle est la **machine de Turing** mais pour bien la comprendre, il faut commencer par comprendre les automates.

Dans tout ce chapitre, on se fixe un alphabet $\Sigma$ sur lequel on travaille.

## 1. Automates finis déterministes

### A. Définition

Commençons par donner une vision intuitive de la machine que nous allons construire :

- un automate est une machine qui se situe à tout moment dans un certain *état*, elle a un nombre
fini d'états possibles;
- un automate prend en entrée un mot qu'elle lit de gauche à droite, lettre par lettre;
- lorsque l'automate est dans un état $q$ et qu'elle lit une lettre $c$, alors il *transitionne* vers un état $\delta(q, c)$ qui ne dépend que de l'état actuel $q$ et de la lettre lue $c$.

Voici la définition formelle de cette machine :

!!! abstract "Définition"
    Un **automate fini déterministe** (afd) est un quadruplet $(Q, q_0, F, \delta)$ où :

    - $Q$ est un ensemble **fini** d'**états**;
    - $q_0 \in Q$ est un état particulier appelé **état initial**;
    - $F \subset Q$ est un ensemble d'**états finaux**;
    - $\delta : Q \times \Sigma \to Q$ est la **fonction de transition** de l'automate.

La fonction de transition $\delta$ n'est pas nécessairement définie sur $Q \times \Sigma$ en entier, autrement dit, pour certains états $q$ et certaines lettres $c$, $\delta(q, c)$ peut ne pas être défini. Dans ce cas, on dit que l'automate **bloque** à la lecture de $c$ dans l'état $q$.

Un automate se représente plus volontier sous forme d'un *graphe orienté*, par exemple :

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

Remarque : dans certains textes, les états finaux peuvent être marqués par une flèche sortante.

### B. Calcul d'un afd

Nous avons défini formellement un automate et il nous reste maintenant à décrire son fonctionnement c'est-à-dire décrire comment cette machine *calcule*.

Un automate est une machine capable de *lire des mots*. Lorsque l'automate est dans un état $q_1$ et que l'on lit une lettre $c$, l'automate transitionne vers l'état $q_2 = \delta(q, c)$ (sauf s'il y a blocage). Pour tout état $q_1$ et $q_2$ et toute lettre $c \in \Sigma$, on notera :

$$
q_1 \longrightarrow^c q_2
$$

lorsque $q_2 = \delta(q_1, c)$.

!!! abstract "Définition (calcul)"
    Un **calcul** d'un automate fini déterministe $A = (Q, q_0, F, \delta)$ est une suite :

    $$
    u_0 \longrightarrow^{w_1} u_1 \longrightarrow^{w_2} u_2 \longrightarrow^{w_3} \cdots \longrightarrow^{w_{n-1}} u_{n-1} \longrightarrow^{w_n} u_n
    $$

    où les $u_i$ sont des états, $w_i$ sont des lettres et qui vérifie :

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

    est un calcul de l'automate qui correspond à la lecture du mot $abbab$ depuis l'état $q_0$ et qui mène $q_1$.

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

### C. Langage reconnu

!!!abstract "Définition (langage reconnaissable)"
    Un langage $L$ est dit **reconnaissable par automate fini** s'il existe un automate fini déterministe $A$ tel que $\mathcal{L}(A) = L$.

### D. Programmation

### E. Accessibilité

### F. Complétion d'un automate

### G. Automate complémentaire

### H. Automate produit
## 2. Automates finis non déterministes

## 3. Automates finis non déterministes à transitions spontanées

## 4. Langages non reconnaissables par automate
