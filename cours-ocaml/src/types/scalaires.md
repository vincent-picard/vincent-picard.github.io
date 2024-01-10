# Types scalaires

Les types **scalaires** sont les types de base du langage. Ils servent généralement à représenter une donnée manipulable directement par le processeur tel qu'une valeur entière, une valeur flottante, *etc*.

En `OCaml` les types scalaires sont :
* Les entiers : `int`
* Les flottants : `float`
* Les booléens : `bool`
* Les caractères : `char`
* Le type unit : `unit`

Les types scalaires sont ensuite utilisés comme briques de base pour construire de nouveaux types appelés types composés et qui permettent la représentation de données complexes.

Le type `unit` sera expliqué dans le chapitre sur la programmation impérative.

## Les entiers

Les entiers de `OCaml` sont codés sur 30 bits et peuvent prendre les valeurs de -2^30 à 2^30 - 1 (environ 1 milliard). 

Remarque : si on veut utiliser des entiers plus grands il faudra utiliser d'autres types, par exemple `int64`, au détriment des performances du programme.

Les valeurs littérales entières s'écrivent normalement, par exemple `123` ou `-198`. Il est possible d'ajouter des tirets bas pour écrire une valeur plus lisiblement, par exemple `6_023_456`. Il est aussi possible d'écrire les valeurs dans d'autres base à l'aide d'un préfixe :

| Base | Préfixe |
| :--: | :-----: |
| 10 | aucun |
| 2 | `0b` ou `0B` |
| 16 | `0x` ou `0X` |
| 8 | `0o` ou `0O` |

Par exemple pour définir la valeur entière `cafe974` (notée en base hexadécimale) on pourra écrire :

```ocaml
let n = 0xCAFE974;;
```

Pour calculer avec les valeurs entières, on utilise les opérateurs arithmétiques classiques `+`, `-`, `*`. Le **quotient** de la division de *a* par *b* s'obtient avec `a / b`, et le **reste** de la division s'obtient avec `a mod b`.

** Il n'y a pas d'opérateur de puissance sur les entiers ** : la raison est que la puissance n'est pas une opération de base du processeur, il faut utiliser un algorithme pour faire ce calcul. `OCaml` vous laisse donc le soin de choisir l'algorithme d'exponentiation qui vous convient.

## Les flottants

Le type des nombres à virgule flottantes en `OCaml` est `float`. Ils sont codés sur 64 bits selon la norme IEEE754.

Les valeurs flottantes littérales se distinguent des valeurs entières par la présence d'une virgule `.` ou des caractères `e` ou `E` pour écrire le nombre en **notation scientifique**.

Voici quelques exemples :
```ocaml
let pi = 3.141592;;
let avogadro = 6.02e23;;  (* signifie 6.02 x 10^23 `*) 
let quatre = 4. ;; (* 4. signifie 4.0 *)
let mille = 1E3;;
```

Pour calculer avec les flottants, on utilise les opérateurs arithmétiques `+.`, `-.`, `*.`, `/.`. L'opérateur de puissance existe sur les flottants et est noté `**`.

Il est possible de convertir un entier en flottant à l'aide de la fonction `float : int -> float` (aussi nommée `float_of_int`). Et convertir un flottant en entier (en l'approximant) à l'aide la fonction `int_of_float : float -> int`.

Il est bon de rappeler ici que le calcul flottant n'est pas exact et peut produire nombre d'étrangetés. Il est donc à manipuler avec précaution. L'utilisation de `float` pour faire du calcul entier est à proscrire.

## Les booléens

Les type `bool` sert à représenter une valeur de vérité et n'a que deux valeurs possibles : `true` (vrai) ou `false` (faux). Ce type sert le plus souvent (mais pas uniquement) à écrire des expressions boolénnes qui sont des tests pour les `if` et les `while`.

Le calcul booléen se fait au travers des opérateurs logiques `||` (ou), `&&` (et) ainsi que de la fonction de négation `not : bool -> bool`. Par exemple:

```ocaml
let x = (true || false) && true;;
let y = (not x) &&;;
let impl a b =
    b || (not a)
;;
```

L'évaluation de `||` et `&&` est **paresseuse**, c'est-à-dire que pour évaluer `expr1 || expr2`, `OCaml` évalue d'abord `expr1` et si le résultat est `true` retourne directement `true` sans évaluer `expr2`. De même, pour évaluer `expr1 && expr2`, `OCaml` évalue d'abord `expr1` et si le résultat est `false` retourne directement `false` sans évaluer `expr2`.

## Les caractères

Le type des caractères en `OCaml` est `char`. Une valeur littérale de type `char` s'écrit entre **simples apostrophes** : `'a'`, `'b'`, ...

Ces caractères sont codés sous forme d'un octet (8 bits). Les valeurs entre 0 et 127 correspondent aux caractères de la norme ASCII. Les valeurs entre 128 et 255 respectent le standard ISO 8859-1. Autrement dit, on peut utiliser la plupart des caractères habituels (y compris les caractères accentués) ainsi que certains symboles, mais on n'aura pas autant de libertés qu'un codage unicode.

Notons l'existence de caractères spéciaux utiles tels que `'\n'` (retour à la ligne) et `'\t'` (tabulation).

On ne peut pas faire grand chose sur le type `char` à part : le convertir en entier avec `int_of_char : char -> int` ou convertir un entier en `char` avec `char_of_int : int -> char`. Toutefois, ce type sera très utilisé car il sert de brique de base pour la construction des chaînes de caractères.

