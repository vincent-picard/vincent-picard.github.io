# Les tableaux en langage C

Nous abordons ici la gestion des tableaux en langage C. Bien que les tableaux ne constituent pas un concept difficile en soi, leur mise en oeuvre en langage C se démarque de celle des langages de haut niveau et est souvent source d'erreurs ou d'incompréhensions chez les étudiants.

Une autre source de difficultés est la compréhension du lien entre tableaux et pointeurs. Le fait qu'en langage C on puisse **parfois** remplacer `#!c int t[]` par `#!c int *t` conduit certains étudiants à se méprendre en imaginant qu'un tableau est la même chose qu'un pointeur. Disons-le maintenant haut et fort :

**Les tableaux ne sont pas des pointeurs et les pointeurs ne sont pas des tableaux !**

## 1. Les tableaux en langage C

Les tableaux sont un espace de mémoire contigü. La manière la plus simple d'utiliser un tableau est de déclarer un tableau statique sur la pile :
```c
int t[4];
```
Cette déclaration réserve sur la *pile* un bloc de mémoire permettant de stocker 4 entiers. Sur ma machine, les entiers `#!c int` sont stockés sur 4 octets, ce qui signifie que le bloc de mémoire réservé fera 16 octets en tout.
On peut ensuite accéder en lecture ou en écrtiure à chacun des emplacements par la syntaxe `#!c t[i]`. Nous reviendrons plus tard sur la signification précise de cette syntaxe, mais voyons d'abord un exemple
```c
int t[4];
t[1] = 17;
t[3] = 12;
t[0] = t[1] + t[3];
```

<figure markdown="span">
   ![Déclaration d'un tableau statique](fig/tabexem/tabexem-1.svg)
</figure>

La première case du tableau d'indice 0 contiendra le valeur 29, les cases d'indice 1 et 3 auront pour valeur 17 et 12, et la case d'indice 2 aura une valeur indéfinie.

Remarquons immédiatement qu'un tableau n'est pas un pointeur. Ainsi, écrire :
```c
int *t;
t[1] = 17;
t[3] = 12;
t[0] = t[1] + t[3];
```
ne provoquera pas d'erreur de compilation mais conduira à une exécution au comportant indéfini, très probablement à une erreur de segmentation.
En effet, la déclaration `#!c int *t` réserve sur la pile un espace mémoire pour stocker un pointeur d'entiers, c'est-à-dire une seule valeur d'adresse. Sur ma machine, les adresses ont une taille de 8 octets, on réserve donc 2 fois moins d'espace que lors de la déclaration de tableau. Mais la quantité de mémoire réservée n'est pas la seule raison pour laquelle ce code ne fonctionne pas.

### Comprendre la syntaxe t[i]

Dans le dernier exemple, on est en droit de se demander pourquoi diable le compilateur accepte d'écrire `#!c t[i]` lorsque `t` n'est pas un tableau mais un pointeur... Pour cela il suffit de bien comprendre deux règles essentielles.

La première règle est que lorsque `t` est un tableau alors l'expression `t` peut être implicitement traduite en pointeur de même type que celui des éléments du tableau. La valeur de ce pointeur est alors l'adresse mémoire à laquelle débute le tableau, ou autrement dit, l'adresse de l'élément `t[0]`. 

La seconde règle est que lorsque `p` est un pointeur de type `type`, écrire `p[i]` permet d'accéder à la valeur de type `type` située à l'adresse mémoire `p + i * sizeof(type)`.

Ainsi lorsqu'on écrit `t[i]` il se passe deux choses : `t` est d'abord interprété comme un pointeur contenant l'adresse de début du tableau, on ajoute à cette adresse `i` fois le nombre d'octets occupés par un élément du tableau, puis on accède à la valeur inscrite à cette nouvelle adresse. Ainsi, cette méthode permet bien d'accéder au i-ème élément du tableau ! 

C'est un peu compliqué ? Mettons en pratique ces deux règles sur l'exemple suivant.

On comprend également mieux pourquoi l'exemple :
```c
int *t;
t[1] = 17;
t[3] = 12;
t[0] = t[1] + t[3];
```
ne fonctionne pas du tout. Le pointeur `t` n'est pas initialisé, donc la valeur qu'il contient est indéfinie. Lorsqu'on écrit `t[i]` il y a donc fort à parier que l'on tente d'accéder à une adresse mémoire interdite.
