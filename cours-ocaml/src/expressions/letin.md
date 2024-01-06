# Définitions locales

Lorsqu'on donne un nom à une valeur, celle-ci est en général utilisée dans une petite partie de code et non pas dans le programme en entier. L'utilisation de **définitions locales** permet d'éviter de surcharger l'environnement global. De plus, on évite aussi de masquer involontairement une valeur globale qui pourrait être utilisée dans la suite du programme. C'est donc une bonne pratique de programmation d'utiliser des **définitions locales** dès que cela s'avère possible.

Pour définir une valeur localement on utilise les mots clefs **let** et **in$$ ainsi :
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
produira l'erreur `unbound value x` à la deuxième ligne car `x` a été uniquement défini **localement** à l'expression `2 * x + 1`.

Il est également possible de définir plusieurs valeurs locales en enchaînant les **let .. in** :

```ocaml
let longueur = 3 in
let largeur = 5 in
longueur * largeur;;
```

## L'environnement vu comme une pile

Pour bien comprendre les définitions globales et locales il est utile de voir l'environnement comme une **pile** d'associations nom-valeur. Chaque définition globale ajoute une association dans la pile d'environnement. Il en est de même pour définitions locales avec la différence que l'association d'une variable locale est **dépilée** lorsqu'on quitte l'expression où elle a été localement définie.

## let ... in est une expression

En plus des valeurs *littérales* telles que `4242`, un expression peut faire intervenir des valeurs possédant un *nom* comme par exemple `2 * x + 5` ou `largeur * longueur`.

Bien évidemment, si on demande à OCaml d'évaluer une telle expression, on obtient une erreur :
```
# 2 * x + 5;;
Error: Unbound value x
```

qui signifie que la valeur de nom `x` n'est pas liée dans l'environnement, autrement dit, `OCaml` ne connaît pas la valeur de `x`. L'environnement est le contexte d'évaluation des expressions qui associe à chaque *nom* sa valeur littérale. Pour pouvoir évaluer cette expression, il faut d'abord définir sa valeur dans l'envionnement à l'aide du mot clé `let` :
```ocaml
let x = 3;;
```
l'interprète OCaml répond alors :
```
val x : int = 3
```
signfiant que l'expression a été évaluée à `3`, est de type `int` et que cette valeur a été ajoutée à l'énvironnement sous le nom `x`.

Il est maintenant possible d'évaluer l'expression précédente :
```
# 2 * x + 5;;
- : int = 11
```

## Définitions globales

Plus généralement, la syntaxe d'une **définition globale** est 
```ocaml
let nom = expression;;
```
où le résultat de l'évaluation de l'expression sera lié dans la suite du programme à l'environnement global sous le nom `nom`.

La syntaxe OCaml spécifie qu'un *nom* de valeur doit commencer par une lettre minuscule ou `_`, et ne contenir que des lettres, des chiffres et des caractères `_`. Typiquement, un nom de variable s'écrit donc avec la convention *snake case* par exemple :  `nom_de_valeur`.

## Il n'y a pas de variables en OCaml
 
Vous remarquerez, que je n'ai pas utilisé le terme de **variable** pour la simple et bonne raison qu'il n'existe pas de variables dans le langage `OCaml`. Il n'existe donc pas non plus d'affectation. L'expression
```ocaml
x = 7;;
```
n'affecte pas 7 à la variable `x` mais constitue un test d'égalité : c'est une expression de type `bool` dont la valeur (pour notre environnement) sera `false`.

Ainsi, en OCaml, une valeur nommée ne change jamais de valeur. Il n'y a donc pas de mot clé **const** comme en C. On pourrait toutefois écrire :
```ocaml
let x = 2;;
let x = 12;;
```
à l'issu de ces deux lignes, `x` vaut effectivement 12 mais en réalité on a créé un deuxième nom `x` qui **masque** la valeur `x` précédente.

L'absence de variables est une permière difficulté pour celles et ceux qui ont commencé par programmer avec un langage impératif comme le C mais elle est importante à comprendre.

