# Grammaires algébriques

Nous avons déjà étudié les expressions régulières et les automates finis qui permettent de décrire certains langages appelés langages réguliers. Nous avons aussi vu que tous les langages ne sont pas réguliers, en particulier certains langages utiles en informatique comme les langages de mots bien parenthésés ne sont pas régulier.

On s'intéresse donc dans ce chapitre à une nouvelle manière de décrire des langages à l'aide de grammaires.

## 1. Grammaires algébriques

Dans ce cours on notera en général :

- $\Sigma$ un alphabet fini de symboles appelés **symboles terminaux**
- $V$ un alphabet fini de symboles appelés **variables** ou **symboles non terminaux**

!!! definition "Définition"
    Une **grammaire algébrique** est un quadruplet $(\Sigma, V, S, \mathcal{R})$ dans lequel :

    * $\Sigma$ est l'alphabet des ** symboles terminaux**
    * $V$ est l'alphabet des **symboles non terminaux** ou **variables**
    * $S \in V$ est un non terminal spécial appelé **axiome** ou **symbole de départ**
    * $\mathcal{R}$ est un ensemble _fini_ de **règles de production** : une règle de production est un couple $(X, u)$ où $X$ est une variable et $u$ un mot sur $\Sigma \cup V$.

Une règle de production $(X, u)$ sera notée $X \to u$. $X$ est le **membre gauche** de la règle et $u$ le **membre droit**.

Lorsqu'une grammaire possède plusieurs règles avec même membre gauche on peut condenser l'écriture de ces règles ainsi : $X \to u \ | \ v \ | \ w$ signifie qu'il existe trois règles de production $X \to u$, $X \to v$ et $X \to w$.

!!! note "Remarque"
    Les grammaires algébriques sont aussi appelées **grammaires hors contexte** ou encore ** grammaires non contextuelles**

!!! example "Exemple (grammaire en langage naturel)"
    Voici une grammaire algébrique pour décrire ceraines phrases en français : 
    ```
    Phrase -> Sujet Verbe Complement
    Sujet -> je | elle
    Verbe -> programme | mange
    Complément -> Article | Nom
    Article -> un | une | le | la
    Nom -> ordinateur | pomme | arbre 
    ```
On remarque que pour donner une grammaire il suffit souvent de lister les règles de production. Une convention souvent utilisée est que la première règle de production correspond à l'axiome, les variables commencent par une majuscule et les terminaux sont en minuscules. En cas de doute, préciser la nature des symboles utilisés.

Cette grammaire permet de générer les phrases suivantes :

* elle programme un ordinateur
* je mange une pomme
* je programme un arbre
* elle programme le pomme

!!! example "Exemple (langage de balises)"
    Voici une grammaire permettant de representer un langage balisé
    ```
    Texte -> epsilon | lettre Texte | < ident > Texte < /ident > Texte
    lettre -> a | b | ... | z (26 règles)
    ident -> gras | italique
    ```
    Ici, `epsilon` désigne le mot vide. Il n'y a qu'un seul non terminal $V = \{\mathrm{Texte}\}$ et les symboles terminaux sont $\Sigma = \{<, >, /, a, ..., z\}$.

Cette grammaire permet par exemple de réprésenter le texte balisé suivant : `< gras > < italique > texte < /italique > < /gras > généré par notre < gras > grammaire algébrique < /gras >`.

!!! warning "Attention"
    Cette grammaire ne génère pas nécessairement de textes **correctement** balisés : par exemple il est tout a fait possible d'écrire `<gras> vanille bourbon </italique>` avec les règles de cette grammaire. *Comment modifier cette grammaire pour obtenir des balises correctes ?*

??? example "Exemple (langage de balises correct)"
    Pour avoir un parenthésage correct des balises 'gras' et 'italique' on peut utiliser la grammaire suivante :
    ```
    Texte -> epsilon | lettre Texte
    Texte -> < gras > Texte < /gras > Texte
    Texte -> < italique > Texte < /italique > Texte
    lettre -> a | b | ... | z (26 règles)
    ```

!!! example "Exemple (expressions arithmétiques)"
    Les expressions arithmétiques avec des constantes littérales binaires peuvent être obtenues par une grammaire telle que :
    ```
    S -> C
    S -> S + S
    S -> S x S
    C -> 0D | 1D
    D -> epsilon | 0D | 1D
    ```
    Par exemple on peut générer le texte : `111 + 10 x 1101` avec cette grammaire.

!!! example "Exemple (grammaire d'un langage de programmation)"
    La lecture du [manuel OCaml](https://v2.ocaml.org/releases/5.1/htmlman/language.html) permet de s'apercevoir que la syntaxe des programmes `OCaml` est décrite par une grammaire algébrique. Une grammaire permet donc la spécification formelle de la syntaxe d'un langage de programmation ou d'un format de données (html, xml, yaml, toml, json...)

## 2. Dérivations et langages engendrés

Nous allons maintenant définir formellement ce qu'est le **langage engendré** par une grammaire. Pour cela, il nous faudra d'abord expliquer la notion de **dérivation**.

### A. Dérivations

#### Définition
Soit G = (Sigma, V, S, RR) une grammaire algébrique, soit R = A->alpha une règle de production de G. On dit que u se **dérive immédiatement** en v par la règle R s'il existe deux mots x et y tels que
u = x A y
v = x alpha y

**Notation :** u => v

#### Définition
Soit G = (Sigma, V, S, RR) une grammaire algébrique. On dit que u se **dérive** en v s'il existe une suite _finie_ de mots (eventuellement vide) tels que 
u => w1 => w2 => ... => wn => v
 
**Notation :** u =>* v

### Proposition
La relation =>* est reflexive et transitive 

#### Définition
On dit qu'une dérivation immédiate xAy => x alpha y est une **dérivation gauche immédiate** (resp. **dérivation droite immédiate**) lorsque x (resp. y) ne contient pas de symbole non terminal.

**Notation:** u =>g* v

Autrement dit, une dérivation gauche est une dérivation dans laquelle on applique une règle de production associée à un symbole non terminal le plus à gauche du mot. 

#### Définition
On dit que u se dérive en v par **dérivation gauches** si on peut dériver u en v par une suite finie de dérivation immédiates gauches.

### B. Langage engendré par une grammaire


#### Définition
Soit G = (Sigma, V, S, R) une grammaire algébrique, on appelle **langage engendré** par G le langage des mots sur Sigma qu'on peut obtenir par dérivation de l'axiome :
```
L(G) = { u \in \Sigma^* tels que S =>* u }
```

#### Définition
Un langage L sur Sigma tel qu'il existe une grammaire G telle que L(G) = L est dit **langage algébrique**, aussi appelé **langage non contextuel**.

#### Exemple : langage de Dyck
Soit la G la grammaire
```
S -> epsilon | aSbS
```
Démontrer que L(G) est le langage des mots bien parenthésés sur {a, b}.

Dem :
    1. Par récurrence sur la longueur de u. Soit u un mot bien parenthésé non vide, il commence nécessairement par une parenthèse ouvrante a. On décompose alors u en u = a v b w où la lettre b de la décomposition correspond à la parenthèse fermante associée à la première parenthèse. v et w sont alors aussi bien parenthésés. Par hypothèse de récurrence forte il S =>* v et S =>* w. Il vient alors : S => aSbS => avbS => avbw = u 
    2. Par récurrence sur la longueur d'une dérivation. Si la dérivation est de longueur 0 alors elle ne peut pas générer de mot c'est gagné. Si la dérivation est de longueur k > 0. Alors soit elle commence par S => epsilon qui est bien parenthésé, soit elle commence par S => aSbS. Donc nécessairement u est de la forme a v b w avec S =>* v et S =>* w. Par hypothese de recurrence forte, v et w sont bien parenthésés. On en déduit que avb est bien parenthésé et que u = avb w est bien parenthésé par concaténation de deux mots bien parenthésés.

On remarque qu'il n'est pas toujours agréable de travailler avec les dérivations, de plus la notion de mot bien parenthésé n'est pas formellement définie. On fera quelque chose de plus carré en TD. 

#### Définition
Deux grammaires sont **faiblement équivalents** lorsqu'elles engendrent le même langage : L(G_1) = L(G_2).

#### Proposition
Les langages rationnels (=réguliers) sont non contextuels

Dem : par induction sur les langages rationnels on montre la propriété
P(L) : "Il existe une grammaire algébrique G telle que L(G) = L"

#### Exemple
La Grammaire
```
S -> SS | epsilon
S -> aSb
```
engendre aussi le langage de Dyck

### C. Non contextualité des langages réguliers

## 3. Arbres de dérivation et ambuiguité

### A. Arbres de dérivation

#### Définition
Soit G = (Sigma, V, S, R) une grammaire algébrique. Soit A un symbole non terminal. Un **arbre de dérivation** de A est un arbre étiqueté dans Sigma union V union epsilon où :
    1. Les noeuds internes sont étiquetés par des variables
    2. La racine est étiquetée par A
    3. Si une feuille est étiquetée par epsilon, elle n'a pas de soeurs, et si X est son père alors X -> epsilon est une règle de production
    4. Pour tout noeud interne X ayant pour fils des noeuds et feuilles étiquetées de gauche à droite par alpha_1 ... alpha_n, alors X -> alpha_1 ... alpha_n est une règle de production de G
Lorsque les feuilles de l'arbre contiennent encore des non terminaux on dit que c'est un ** arbre de dérivation partielle **.

Les arbres de dérivation sont une manière plus commode de représenter une suite de dérivations :
### Exemple
S -> abSaT | a
T -> bT | epsilon

Donner un exemple d'arbre de dérivation de S

#### Définition (hors programme)
Soit un arbre de dérivation, on appelle **frontière** de l'arbre la concaténation de gauche à droite de toutes ses feuilles.

#### Proposition
Soit G = (Sigma, V, S, R) une grammaire algébrique, u un mot sur Sigma union V, et X un symbole non terminal alors
X =>* u ssi il existe un arbre de dérivation de racine X dont la frontière est u

Demonstration
    1. Par récurrence sur la longueur de la dérivation : si la dérivation est de longueur 0, alors l'arbre-feuille X convient. Sinon la dérivation se décompose en X =>k v => u. Par hypothèse de récurrence, il existe un arbre de dérivation A1 de racine X dont la frontière est V. Puisque v => u, v se décompose en v = alpha Y beta et u en alpha u_1 ... u_n beta où Y -> u_1 ... u_n est une règle de production. Il suffit alors de remplacer la feuille Y dans A1 par un noeud étiquetté par Y et ayant des feuilles étiquetées de gauche à droite par u_1 ... u_n. A2 est bien un arbre de dérivation dont la frontière est alpha u_1 ... u_n beta c'est à dire u.
    2. Par induction sur les arbres :
        P(A) : "Si A est un arbre derivation de racine X et de frontière u alors X =>* u"
        A. Si l'arbre est une feuille alors on a bien X =>* X
        B. Sinon l'arbre est un noeud X et on a deux cas, soit il a pour fils epsilon uniquement et alors X -> epsilon est une règle et X =>* epsilon = frontière (A). Sinon il possède des fils A_1 ... A_n de racines respectives a_1 ... a_n qui ne sont pas epsilon. On a alors Fr(A) = Fr(A_1)...Fr(A_n) = u. Et on veut montrer que X =>* u. 
Comme X est un noeud on sait qu'il existe une règle X -> a_1 ... a_n
Si A_i est un feuille etiquetée par un non terminal on a a_i =>* a_i. Si A_i est un noeud alors a_i est un non terminal et A_i est un arbre de dérivation de racine a_i par hypothèese de recurrence forte, a_i =>* Fr(A_i) on en deduit : 
X => a_1 ... a_n =>* Fr(a_1) a_2 ... a_n =>* Fr(a_1) Fr(a_2) a_3 ... a_n =>* ... =>* Fr(a_1) Fr(a_2) ... Fr(a_n) = u

#### Savoir passer de suites de dérivations immédiates à arbre
Le sens <= de la preuve donne un algorithme pour reconstuire la suite derivation associée à un arbre : c'est un parcours en profondeur de gauche à droite. (On obtient alors que des dérivations gauche)
Pour le sens => de la preuve, on peut aussi construire par étapes l'arbre de dérivation en *développant* une feuille non terminale à chaque occurrence d'une dérivation immédiate. 

#### Proposition (corollaire)
Soit G = (Sigma, V, S, R) une grammaire algébrique alors, u un mot sur Sigma alors
u appartient à L(G) ssi il existe un arbre de dérivation (non partielle) de racine S dont la frontière est u

### Proposition
u =>* v ssi u =>g* v ssi u =>d* v
Dem :
(2) => (1) et (3) => (1) sont évidents.

(1) => (2)
On décompose u en u_1 V_1 u_2 V_2 ... u_n V_n u_n+1 où les u_1 sont des mots sur Sigma, on a alors que v = u_1 w_1 ... où V_i =>* w_i.
D'après la proposition il existe donc des arbres de dérivations de racines respectives V_i et de frontières respecives w_i. Donc toujours d'après la proposition (sens réciproque avec parcours), V_i =>g* w_i. Il suffit ensuite dériver chacun des V_i de gauche à droite.

(1) => (3)
idem

L'intéret de cette proproposition est de faciliter les preuves : lorsqu'on a une dérivation u =>* v on peut toujours considérer que ce sont des dérivations gauches (ou droites) sans nuire à la généralité.

### B. Ambiguité

#### Définition
Une grammaire $G$ est dite **ambiguë** si elle possède un mot u dans L(G) telle qu'il existe deux arbres de dérivation distincts de racine S et de frontière u.

### Exemple
S -> CST | S + S | S x S
CST -> 1 | 2 | ... | 9

### Exemple Dyck
S -> SS | aSb | epsilon

Remarque : la grammaire faiblement équivalente vue précédemment n'est pas ambiguë. Il existe des langages algébriques inhéremment ambigus : on ne peut pas les décrire par une grammaire non ambiguë.

### Exemple Dangling else (sinon pendant)
I -> si B alors I
    | si B alors I sinon I
    | a
B -> b
1) Montrer que G est ambiguë
2) Imaginons un programme proche du C, sans accolades, dans lequel on pourrait écrire :
```
int a = 5;
int b = 2;
if (a == 1)
    if (b == 1)
        a = 42;
else
    b = 42;
print(a, b)
```
Comment se traduit ici le résultat de la question 1) ?
3) En OCaml
```
let a = 7;;
let b = 1;;
if a = 1 then
    print_string "UN";
    if b = 1 then
        print_string "DEUX"
else
    print_string "TROIS"
;;
``` 

### C. Analyse syntaxique (parsing)

En général, les noeuds des arbres de dérivation d'une expression vont servir à effectuer des actions pour produire une donnée. On utilise souvent le schéma suivant :

donnée =>(analyse syntaxique) arbre =>(actions) résultat 

par exemple pour une expression arithmétique

expression (texte) =>(analyse syntaxique) arbre arithémtique =>(actions) résultat numérique

par exemple dans le cadre de la compilation d'un programme :

langage A =>(analyse syntaxique) arbre =>(actions) langage B

Si G est une grammaire non ambiguë décrivant un langage, le processus de construction de l'arbre de dérivation produisant un mot s'appelle **analyse syntaxique**.

L'analyse syntaxique est hors programme mais il faut savoir écrire à la main un programme reconstruisant un arbre de dérivation d'un mot sur Sigma pour des grammaires très symples.
