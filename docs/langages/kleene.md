# Théorème de Kleene

Dans ce chapitre, on fait le lien entre **les langages réguliers**, qu'on peut dénoter par expression régulière, et les **langages reconnaissables** par automate fini. Ce lien a été explicité par *Stephen C. Kleene* en 1956 :

!!! tip "Théorème de Kleene"
    Un langage $L$ est régulier (ou rationnel) si et seulement s'il est reconnaissable par automate fini.

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

On voudrait utiliser la construction de Glushkov pour produire un automate à partir de n'importe quelle expression régulière. Hélas, on a vu que les expressions régulières ne dénotent pas un langage régulier dans tous les cas.

!!!abstract "Définition : expression régulière linéaire"
    Une expression régulière **linéaire** est une expression régulière qui ne contient pas deux fois une même lettre.

!!!tip "Proposition"
    Toute expression régulière *linéaire* dénote un langage *local*.

C'est un peu fastidieux mais on peut le démontrer par induction sur les expressions régulières.

!!!example Algorithme de Berry-Séthi

    1. Linéariser $e$ en numérotant chacune de ses lettres (avec des numéros distincts)
    2. Déterminer les paramètres $P(L')$, $D(L')$ et $T(L')$ à partir de l'expression régulière $e'$
    3. Déterminer à partir de $e'$ si $\varepsilon \in L'$
    4. Construire l'automate de Glushkov $A'$ pour $L'$
    5. Effacer les numéros de lettres sur les **transitions** pour revenir à un automate $A$ qui reconnaît $L$

Remarques :

- L'automate obtenu contient $1 + |e|_{\Sigma}$ états.
- L'automate n'est pas nécessairement déterministe (donc peu pratique d'un point de vue calcul) mais on peut toujours le déterminiser pour obtenir un automate efficace qui reconnaît les mots de $L$ en temps linéaire. C'est coûteux mais on ne le fait qu'une seule fois ($\simeq$ procédé de compilation).

### B. Automates de Thomson

L'algorithme de Thomson se propose de construire un automate $A$ qui reconnaît $\mu(e)$ en procédant par induction sur $e$.

#### Automates normalisés

!!!abstract "Définition : automate normalisé"
    Un automate fini non déterministe ($\varepsilon$-afnd) est dit **normalisé** si :
        - (i) il possède un unique état initial $q_0$
        - (ii) $q_0$ ne possède que des transitions sortantes
        - (iii) il possède un unique état final $q_f \neq q_0$
        - (iv) $q_f$ ne possède que des transitions entrantes

Il est toujours possible de *normaliser* un automate donné en ajoutant une paire d'états initiaux et finaux et des $\varepsilon$-ransitions allant de $q_0$ vers les états initiaux de l'automate et des états finaux vers $q_f$.

#### Automates de Thomson

!!!tip "Proposition"
    Pour toute expression régulière $e$, il existe un automate normalisé qui reconnaît le langage dénoté par $e$.

- **Cas de base**
    - $e = \varnothing$
    - $e = \varepsilon$
    - $e = x (x \in \Sigma)$

- **Cas construits**
    - $e = e_1.e_2$ : on fusionne l'état final de $e_1$ avec l'état initial de $e_2$
    - $e = (e_1 | e_2)$ : on utilise une bifurcation pour séparer les deux cas possibles
    - $e = e_1\star$ : on procède ainsi :

Attention à respecter scrupuleusement la construction précédente... n'improvisez pas sous peine d'écrire des automates faux.

Exemple : $e = a(a|ab)\star$.

#### Suppression des transitions spontanées

On remarque que les automates de Thomson possèdent un grand nombre d'$\epsilon$-transitions. Voici un petit algorithme simple permettant de se débarrasser des transitions instantanées sans avoir besoin de déterminiser l'automate.

1. Marquer comme état initial tous les états de $\eta(q)$ avec $q \in I$.
2. Pour toute transition $(q, x, q')$ avec $x \in Sigma$, on ajoute des transitions $(q, x, q'')$ pour tout $q'' \in \eta(q)$.


## 2. Des automates vers les expressions régulières

### A. Algorithme par élimination des états


