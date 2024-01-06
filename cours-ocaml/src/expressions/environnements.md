# Définitions globales

En plus des valeurs *littérales* telles que `4242`, un expression peut faire intervenir des valeurs possédant un *nom* comme par exemple `2 * x + 5` ou `largeur * longueur`.

Bien évidemment, si on demande à OCaml d'évaluer tout de suite une telle expression, on obtient une erreur :
```
# 2 * x + 5;;
Error: Unbound value x
```

qui signifie que le nom `x` n'est lié à aucune valeur dans l'environnement, autrement dit, `OCaml` ne connaît pas la valeur de `x`. 

L'**environnement** est le contexte d'évaluation des expressions qui associe à chaque *nom* sa valeur littérale. Pour pouvoir évaluer cette expression, il faut d'abord définir sa valeur dans l'environnement à l'aide du mot clé `let` :
```ocaml
let x = 3;;
```
l'interprète OCaml répond alors :
```
val x : int = 3
```
signfiant que l'expression est de type `int`, son évaluation donne la valeur `3` qui est ajoutée à l'énvironnement sous le nom `x`.

Il est maintenant possible d'évaluer l'expression précédente :
```
# 2 * x + 5;;
- : int = 11
```

## Syntaxe

Plus généralement, la syntaxe d'une **définition globale** est 
```ocaml
let nom = expression;;
```
où le résultat de l'évaluation de l'expression sera lié dans la suite du programme à l'environnement global sous le nom `nom`. Par exemple :
```ocaml
let longueur = 5;;
let largeur = 12;;
let perimetre = (longueur + largeur) * 2;;
let aire = longueur * largeur;;
```
La syntaxe OCaml spécifie qu'un *nom* de valeur doit commencer par une lettre minuscule ou `_`, et ne contenir que des lettres, des chiffres et des caractères `_`. Typiquement, un nom de variable s'écrit donc avec la convention *snake case* par exemple :  `nom_de_valeur`.

## La pile d'environnement

Il est utile de voir l'environnemement comme une **pile d'associations**.
L'exécution de plusieurs `let` comme dans le programme précédent, empile une à une les définitions globales ainsi :

| Environnement |
|---------------|
| aire = 60 |
| perimetre = 34 |
| largeur = 12 |
| longueur = 5 |

Dans cet environnement si on exécute le programme suivant :
```ocaml
let largeur = 42
```
On obtiendra le nouvel environnement :

| Environnement |
|---------------|
| largeur = 42 |
| aire = 60 |
| perimetre = 34 |
| largeur = 12 |
| longueur = 5 |

Notez bien que la valeur de `largeur` n'a pas été modifiée ! Autrement dit `let` ne sert pas à faire une affectation. Le résultat est qu'une deuxième valeur `largeur` existe et qu'elle **masque** la valeur de même nom située plus bas qu'elle dans la pile. Ainsi, `largeur` vaudra bien `42` dans la suite du programme.

Remarquez aussi que cela ne modifie en aucun cas les autres valeurs telles que `perimetre` ou `aire`.

## Il n'y a pas de variables en OCaml

Une conclusion importante à comprendre dans cette section est que les concepts de **variable** et d'**affectation** n'existent pas en `OCaml`. Le but d'un programme `OCaml` est d'évaluer une suite d'expressions et on peut, si on le souhaite, donner des noms aux valeurs obtenues avec `let`. Ces noms seront empilés dans l'environnement pour pouvoir être utilisés dans les expressions suivantes.
