# Fonctions

Comme dans la plupart des langages de programmation, `OCaml` permet d'écrire des fonctions, c'est-à-dire un sous-programme dont le résultat dépend de valeurs passées en **paramètres**.

Dans cette section, vous apprendrez à utiliser puis définir vos propres fonctions.

## Appel d'une fonction

En `OCaml` l'appel d'une fonction `f` s'écrit `f arg1 arg2 ... argn`, avec des espaces séparant les paramètres, contrairement à la notation plus classique `f(arg1, ..., argn)`. Il y a une bonne raison à cela qu'on expliquera plus tard.

Regardons par exemple l'utilisation de la fonction racine carrée `sqrt`:
```ocaml
let x = sqrt 16.0;;
```
l'interprète répond
```
val x : float = 4.0
```

L'appel d'une fonction constitue une expression donc on peut évidemment l'utiliser au sein d'une autre expression :
```ocaml
let y = sqrt 25.0 -. sqrt 9.0;;
```
Ici, nous avons écrit 2 appels à la fonction `sqrt` puis on a calculé la différence des deux résultats flottants à l'aide de l'opérateur `-.` qui calcule la soustraction de deux flottants.

Attention toutefois à bien utiliser des parenthèses lorsqu'un argument est lui-même donné sous forme d'expression :
```ocaml
let hyp = sqrt (25.0 -. 16.0);;
```
Si on avait écrit `sqrt 25.0 -. 16.0` on aurait obtenu la valeur `-11.0` car la racine ne s'applique qu'au `25.0`.

## Les fonctions sont des citoyens de première classe

Dans les langages fonctionnels, les fonctions sont des valeurs au même titre que les entiers, les flottants, les caractères, *etc*. Regardons ce qui se passe lorsqu'on évalue simplement `sqrt`.

```
# sqrt;;
- : float -> float = <fun>
```

On découvre que le type de `sqrt` est `float -> float` ce qui signifie que cette valeur est une fonction prenant en entré un paramètre de type flottant et retournant en sortie une valeur de type flottant. Comme la *valeur* d'une fonction ne peut être affichée simplement sur le terminal, `OCaml` dit que la valeur est `<fun>` signifiant que c'est une fonction.

Que se passe-t-il alors si on évalue `sqrt 16` ?
```
# sqrt 16;;
Error: This expression has type int but an expression was expected of type
         float
  Hint: Did you mean `16.'?
```
`OCaml` étant un langage fortement typé, il déclenche une erreur car `sqrt` attend une valeur de type `float` en entrée et qu'une valeur de type `int` a été incorrectement utilisée.

Cela peut paraître contraignant au premier abord mais le typage fort permet d'éliminer un grand nombre de bugs dès la compilation. On peut retenir les deux points suivants sur le système de typage de `OCaml`:
- `OCaml` n'effectuera jamais de conversion de type implicite à votre place
- Chaque fonction a une signature unique qui doit être respectée à chaque appel : il n'y a pas de surcharges de fonctions en `OCaml`

Cela explique aussi pourquoi nous avons utilisé l'opérateur `-.` pour soustraire les deux flottants et non pas l'opérateur `-` qui soustrait deux entiers.

## Définition d'une fonction

Pour définir une fonction, on utilise aussi le mot clef `let` comme pour toute autre valeur :
```ocaml
let f arg1 arg2 arg3 ... argn =
    expr
;;
```
Ici `expr` est le résultat de l'appel de la fonction, cette expression peut (et devrait) utiliser les valeurs des paramètres. Il n'y a pas de mot clé `return` en `OCaml`.

Par exemple,
```ocaml
let decupler n =
    10 * n
;;
```
produit la réponse :
```
val decupler : int -> int = <fun>
```

Regardons ce qui se passe lorsqu'on définit une fonction à deux paramètres :
```
# let aire_rectangle longueur largeur =
    longueur * largeur
;;
val aire_rectangle : int -> int -> int = <fun>
```

Le type de cette fonction est `int -> int -> int` ce qui signifie qu'elle attend un premier paramètre de type `int`, un second de type `int` également, et que le résultat sera lui aussi de type `int`. Il n'est pas nécessaire de comprendre immédiatement pourquoi le type s'écrit ainsi, on peut se contenter de savoir lire un tel type pour le moment. (Voir Curryfication pour comprendre).

Voici un exemple complet, utilisant les concepts présentés dans cette section :
```ocaml
(* Fonction appliquant une promotion a un prix *)
let reduction prix pourcentage =
    prix -. (prix *. pourcentage)
;;

(* Fonction calculant le prix d'un panier de pommes en promotion *)
let prix_panier nb_pommes =
    let prix_pomme = 2.5 in
    let promo = 0.15 in
    let prix_reduit = reduction prix_pomme promo in
    (float_of_int nb_pomme) *. prix_reduit
;;
```
Notez qu'il a été nécessaire d'utiliser explicitement la fonction de conversion `float_ot_int` pour convertir la valeur entière `nb_pommes` en valeur flottante.
 
