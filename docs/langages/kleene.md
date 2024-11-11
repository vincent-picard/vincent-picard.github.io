# Théorème de Kleene

Dans ce chapitre, on fait le lien entre **les langages réguliers**, qu'on peut dénoter par expression régulière, et les **langages reconnaissables** par automate fini. Ce lien a été explicité par *Stephen C. Kleene* en 1956 :

!!! tip "Théorème de Kleene"
    Un langage $L$ est régulier (ou rationnel) si et seulement s'il est reconnaissable automate fini.

Ainsi il y a **égalité** entre la **classe des langages réguliers**  $\def\rat#1{{\text{RAT}(#1)}} \rat{\Sigma}$  
et la **classe des langages reconnaissables**  par automate fini $\def\rec#1{{\text{REC}(#1)}} \rec{\Sigma}$ sur un alphabet $\Sigma$.

$$ \rat{\Sigma} = \rec{\Sigma} $$

Nous allons démontrer ce théorème de manière constructive :

- on présente deux algorithmes pour construire un automate reconnaissant le langage dénoté par une expression régulière donnée
- on présente un algorithme pour construire une expression régulière qui dénote le langage reconnu par un automate fini donné

Nous verrons ensuite quelques conséquences importantes.

## 1. Des expressions régulières vers les automates

### A. Algorithme de Berry-Séthi

#### Langages locaux

Soit $L$ un langage sur l'alphabet $\Sigma$, on définit les ensembles suivants :

- $P(L) = \{ a \in \Sigma \ /\ a\Sigma^* \cap L \neq \varnothing\}$
- $D(L) = \{ a \in \Sigma \ /\ \Sigma^*a \cap L \neq \varnothing\}$
- $T(L) = \{ u \in \Sigma^2 \ /\ \Sigma^* u \Sigma^* \cap L \neq \varnothing\}$

Autrement dit $P(L)$ est l'ensemble des lettres qui sont au début d'un des mots de $L$, $D(L)$ est l'ensemble des lettres qui terminent l'un des mots de $L$, et $T(L)$ est l'ensemble des facteurs de longueur 2 qui apparaissent dans l'un des mots de $L$.

!!! example "Exemples"
    - $L_1 = \{a, abb, aabbb\}$
        - $P(L_1) = \{a\}$
        - $D(L_1) = \{a, b\}$
        - $T(L_1) = \{aa, ab, bb\}$
    - $L_2 = \{u \in \{a,b\}^* \ /\ |u|_a \text{ est pair}\}$
        - $P(L_2) = \{a, b\}$
        - $D(L_2) = \{a, b\}$
        - $T(L_2) = \{aa, ab, ba, bb\}$
    - $L_3 = \{ \text{mots sur } \{a,b\} \text{ où tout } b \text{ est suivi d'un } a\}$
        - $P(L_3) = \{a, b\}$
        - $D(L_3) = \{a\}$
        - $T(L_3) = \{aa, ab, ba\}$

!!! abstract "Définition (langage local)"
    Un langage $L$ sur l'alphabet $\Sigma$ est dit **local** lorsque

    $$ L \setminus \{\varepsilon \} = \left(P(L)\Sigma^* \cap \Sigma^*D(L)\right) \setminus \left( \Sigma^*\left( \Sigma^2 \setminus T(L) \right) \Sigma^* \right)$$

Cette expression mathématique peut paraître un peu barbare mais elle signifie simplement qu'un langage local est un langage dont l'ensemble des mots peuvent être décrits exactement en donnant :

- les premières lettres autorisées,
- les dernières lettres autorisées,
- les paires de lettres consécutives autorisées;
- et en précisant si $\varepsilon \in L$

Ainsi pour savoir si un mot appartient à un langage local il suffit de l'observer *localement*.

Remarquons que pour tout langage l'inclusion :

$$ L \setminus \{\varepsilon \} \subset \left(P(L)\Sigma^* \cap \Sigma^*D(L)\right) \setminus \left( \Sigma^*\left( \Sigma^2 \setminus T(L) \right) \Sigma^* \right)$$

est vraie. En effet, un mot de $L$ non vide commence bien par une lettre qui est nécessairement dans $P(L)$, termine par une lettre qui doit être dans $D(L)$ et ne contient aucun facteur de longueur 2 qui ne serait pas dans $T(L)$. **C'est donc l'inclusion réciproque qui caractérise les langages locaux**.

!!! example "Exemples"
    - $L_1$ n'est pas local car par exemple $ab$ commence par $a \in P(L_1)$ finit par $b \in D(L_1)$ et possède pour seul facteur de longueur 2 $ab \in T(L_1)$, mais pourtant $ab \not \in L_1$. 
    - $L_2$ n'est pas local car par exemple $a$ commence par $a \in P(L_2)$ finit par $a \in D(L_2)$ et ne possède pas de facteur de longueur 2, mais pourtant $a \not \in L_2$. 
    - $L_3$ est local : soit en effet un mot $u$ dans $\left(P(L)\Sigma^* \cap \Sigma^*D(L)\right) \setminus \left( \Sigma^*\left( \Sigma^2 \setminus T(L) \right) \Sigma^* \right)$ alors si $b$ apparaît dans $u$ il ne peut apparaître à la dernière place car $b \not \in D(L_3)$, donc il est suivi par une lettre qui ne peut pas être un $b$ car $bb \not \in T(L_3)$, donc il est nécessairement suivi d'un $a$. Ainsi $u \in L_3$ l'inclusion réciproque est vraie. 

#### Automate de Glushkov

Une propriété bien sympathique d'un langage local est qu'il est très facile de concevoir un automate fini qui le reconnait. En effet, il suffit d'imaginer un automate qui *mémorise* à tout instant la dernière lettre lue, pour savoir si la prochaine lettre est autorisée ou non. On appelle cette construction **automate de Glushkov**.

!!! abstract "Définition (automate de Glushkov)"
    Soit $L$ un langage **local** sur $\Sigma$, on définit l'**automate de Glushkov** comme l'automate fini déterministe $A = (Q, q_0, F, \delta)$ suivant :
    
    - $Q = \Sigma \cup \{ q_0 \}$
    - $q_0 = q_0$
    - $F = D(L) \cup \{q_0\}$ si $\varepsilon \in L$, $F = D(L)$ sinon
    - $\delta : Q \times \Sigma \to Q$ est définie ainsi :
        - $\forall x \in \Sigma, \delta(q_0, x) = x$ si $x \in P(L)$, bloque sinon
        - $\forall x,y \in \Sigma, \delta(x, y) = y$ si $xy \in T(L)$, bloque sinon 

Voici un exemple pour le langage $L_3$.

#### Algorithme de Berry-Séthi

### B. Automates de Thomson

#### Automates normalisés

#### Automates de Thomson

#### Suppression des transitions spontanées

## 2. Des automates vers les expressions régulières

### A. Algorithme par élimination des états


