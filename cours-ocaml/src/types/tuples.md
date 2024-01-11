# Les tuples

Voyons maintenant comment on peut composer à partir des types de bases des types plus complexes appelés *types composés*. Parmi ces types les **tuples** ou en français les **n-uplets** sont les plus simples.

Un *tuple* consiste simplement à regrouper des valeurs entre elles en les séparant par des virgules. Voici quelques exemples de tuples définis dans l'interprète `OCaml` :

```ocaml
# let couple = (3, 5);;
val couple : int * int = (3, 5)
# let coord = (1.5, 3.7);;
val coord : float * float = (1.5, 3.7)
# let triplet = (3, 4, 5);;
val triplet : int * int * int = (3, 4, 5)
# let date = (11, "janvier", 2014);;
val date : int * string * int = (11, "janvier", 2014)
# let etablissement = ("Leconte de Lisle", 974);;
val etablissement : string * int = ("Leconte de Lisle", 974)
```

On constate que `OCaml` note les types couples `type_1 * type_2 * ... * type_n` où les types des valeurs de chaque composante sont séparés par une étoile `*`, à l'image d'un produit cartésien d'ensembles.

On voit également qu'il est possible de réaliser des tuples de valeurs de types différents.
 
## Définir de nouveaux types

En `OCaml`, comme en `C`, il est possible de donner un nom à des types. Cela est très utile car, à force de compositions, les types obtenus deviennent compliqués à écrire et à lire. De plus, l'utilisation de noms de types personnalisés augmente grandement la lisibilité des programmes. Par exemple, imaginons qu'on représente un point de l'espace par ses coordonnées cartésiennes; il est plus simple de lire qu'une valeur est de type `point3D` plutôt que `float * float * float`, d'autant plus que des triplets de flottants pourraient être utilisés à d'autres endroits du programme sans qu'il s'agisse nécessairement de points.

Ainsi, si on veut définir le type `point3D` on peut écrire :
```ocaml
type point3D = float * float * float;;
```

Voici un autre exemple où une personne est représentée par son nom, son prénom et son âge :
```ocaml
type personne = string * string * int;;
```

## Lecture des composantes d'un tuple

Lorsqu'un programme manipule une valeur d'un type tuple, il est nécessaire de pouvoir récupérer les composantes de ce typle. Pour cela, `OCaml` permet d'écrire des définitions `let` sur les tuples :
```ocaml
(* On suppose que p est une valeur du type personne *)
let (nom, prenom, age) = p in
let message = "Bonjour " ^ nom ^ " " ^ prenom;;
```

Voici un autre exemple dans lequel une fonction prend en entrée deux tuples :
```ocaml
(* Calcule la distance entre deux points de l'espace *)
let dist p q =
    let (x, y, z) = p in
    let (u, v, w) = q in
    sqrt ((x -. u) ** 2.0 +. (y -. v) ** 2.0 +. (z -. w) ** 2.0)
;;
```
Nous verrons plus tard que cette possibilité est en fait la conséquence d'un mécanisme plus général appelé *filtrage par motifs*.

Il y a un cas particulier qui est celui des **couples** de valeurs pour lesquels `OCaml` nous fournit déjà une fonction `fst` (*first*)  et `snd` (*second*) pour accéder à chacune des composantes du couple.

```ocaml
(* Dimensions d'un rectangle au format (longueur, largeur) *)
type rect_dim = int * int;;

let perimetre rect =
    2 * (fst rect + snd rect)
;;
```

