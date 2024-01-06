# Définitions locales

Lorsqu'on donne un nom à une valeur, celle-ci est en général utilisée dans une petite partie de code et non pas dans le programme en entier. De manière générale lorqu'on programme, on se concentre sur une très petite portion de code et on ignore quels noms de valeurs ont été ou seront utilisés ailleurs dans le programme.

 L'utilisation de **définitions locales** permet d'éviter de surcharger l'environnement global. De plus, on évite aussi de masquer involontairement une valeur globale ou d'utiliser un nom qui pourrait être masqué par une autre définition globale. C'est donc une bonne pratique de programmation d'utiliser des **définitions locales** dès que cela s'avère possible.

Pour définir une valeur localement on utilise les mots clefs **let** et **in** ainsi :
```ocaml
let x = 5 in 2 * x + 1;;
```
l'interprète répond alors :
```
- : int = 11
```
A première vue, tout semble se passer comme pour une définition globale mais ce n'est pas le cas :
```ocaml
let x = 4 in 2 * x + 1;;
x * x + 2;;
```
produira l'erreur `Unbound value x` à la deuxième ligne car `x` a été uniquement défini **localement** à l'expression `2 * x + 1`.

Il est également possible de définir plusieurs valeurs locales en enchaînant les **let .. in** :

```ocaml
let longueur = 3 in
let largeur = 5 in
longueur * largeur;;
```

## Pile d'environnement : empilements et dépilements

Pour bien comprendre le `let ... in` revenons à la représentation sous forme de pile de l'environnement. Lorsqu'on utilise `let x = expr1 in expr2` la valeur de `expr1` sera temporairement liée au nom `x` lors de l'évaluation de `expr2`. Concrètement, cela signifie qu'on **empilera** la valeur `x` dans l'environnement avant d'évaluer `expr2`, puis immédiatement, cette valeur sera **dépilée** de l'environnement.

Etudions cela sur un exemple :
```ocaml
let a = 5;;
let b = 3 + 4;;
let a = 17 in a + b;;
a * b;;
```

Après l'évaluation des deux premières expressions, la pile d'environnement vaut :

| Environnement |
|---------------|
| b = 7 |
| a = 5 |

Ensuite, l'évaluation de la troisième expression se fait dans un environnement où `a = 17` a été temporairement empilée :

| Environnement |
|---------------|
| a = 17 |
| b = 7 |
| a = 5 |

C'est pourquoi le résultat de l'évaluation de la 3e expression donnera 24. La valeur précédente de `a` est temporairement **masquée**.

Puis, l'association `a = 17` est dépilée pour l'évaluation de la dernière expression et `a` *retrouve* sa valeur prédente. Le résultat sera donc 35.

## let ... in est une expression

Il existe une dernière différence importante entre le `let` et le `let .. in` : le `let .. in` est une **expression**, ce qui signifie :
- qu'elle possède un type
- qu'elle possède une valeur
- qu'elle peut être utilisée au sein d'une autre expression

Par exemple, imagions qu'un gateau coûte habituellement 18 euros, et qu'une promotion exceptionnelle réduise le prix de 5 euros, alors on peut calculer le prix de l'achat de 15 gateâux par :
```ocaml
15 * (let prix_base = 18 in prix_base - 5)
```
L'expression entre parenthèses est une expression `let ... in` de type entier et de valeur 13. 

C'est aussi pour cette raison qu'il est possible d'utiliser consécutivement plusieurs `let ... in` :
```ocaml
let longueur = 3 in
let largeur = 5 in
longueur * largeur;;
```
Ici, `longueur` est en fait définie localement dans l'expression `let largeur in longueur * largeur`.

## `let` ou `let ... in` ?

Comment choisir s'il faut définir une valeur localement ou globalement ?
La réponse est simple : si la valeur définie est destinée à être utilisée dans l'ensemble du programme, par exemple s'il s'agit d'une définition de fonction, alors la définition devra être globale.

Dans tous les autres cas, on préférera une définition locale. En particulier, les définitions de valeurs internes à une fonction seront toujours locales.
