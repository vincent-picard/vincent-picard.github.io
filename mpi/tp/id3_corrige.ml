type 'a abd =
  | Feuille of 'a
  | Noeud of int * ('a abd) * ('a abd)
;;

let rec classer a x = match a with
  | Feuille f -> f
  | Noeud (k, g, d) ->
     if x.(k) then
       classer g x
     else
       classer d x
;;

(* On implémente ID3 en se limitant au cas où les attributs y compris l'attribut cible sont des booléens *)

let touslesmemes exemples cible =
  (assert (not (exemples = [])));
  let b = (List.hd exemples).(cible) in (* on recupere la premiere valeur de l'attribut cible *)
  let rec verifie l = match l with (* la fonction verifie si toutes les valeurs d'attribut cible valent b *)
    | [] -> true
    | t::q -> (t.(cible) = b) && verifie q
  in verifie exemples
;;

let compte_vrai_faux exemples k =
  let nb_false = ref 0 in
  let nb_true = ref 0 in
  let rec compte l = match l with
    | [] -> ()
    | t::q -> (if t.(k) then incr nb_true else incr nb_false;
	       compte q)
  in compte exemples; (!nb_false, !nb_true)
;;
  
let majoritaire exemples cible =
  (assert (not (exemples = [])));
  let (nb_false, nb_true) = compte_vrai_faux exemples cible in
  nb_true >= nb_false
;;

let log2 x = log x /. log 2.0;;
  
let entropie exemples cible =
  (assert (not (exemples = [])));
  let (nb_false, nb_true) = compte_vrai_faux exemples cible in
  let n = List.length exemples in
  if (nb_false = 0) || (nb_true = 0) then
    0.0
  else
    let p_false = (float nb_false) /. (float n) in
    let p_true = (float nb_true) /. (float n) in
    -. (p_false *. log2 p_false +. p_true *. log2 p_true)
;;

let rec separe l k = match l with
  | [] -> ([], [])
  | t::q -> let (l1, l2) = separe q k in
	    if t.(k) then
	      (l1, t::l2)
	    else
	      (t::l1, l2)
;;
  
let gain exemples attribut cible =
  (assert (not (exemples = [])));
  let (nb_false, nb_true) = compte_vrai_faux exemples attribut in
  let (s_false, s_true) = separe exemples attribut in
  let n = List.length exemples in
  let h = entropie exemples cible in
  let p_false = (float nb_false) /. (float n) in
  let p_true = (float nb_true) /. (float n) in
  h -. (p_false) *. (entropie s_false cible) -. (p_true) *. (entropie s_true cible)
;;

let plus_discriminant exemples attributs cible =
  let gmax = ref Float.neg_infinity in
  let nmax = ref (-1) in
  let rec compare l = match l with
    | [] -> ()
    | t::q ->
       let g =  gain exemples t cible in
       print_float g;
       print_newline ();
       if g > !gmax then (
	 gmax := g;
	 nmax := t;
	 compare q)
       else
	 compare q
  in compare attributs; !nmax
;;

let enleve l x =
  List.filter (fun y -> not (y = x)) l
;;
  
(* Construit un arbre de decision à l'aide de l'algorithme id3 *)
(* exemples : liste de tableaux représentant les exemples d'apprentissage *)
(* attributs : liste des numéros d'attributs non cibles disponibles *)
(* cible : numéro d'attribut cible *)

let rec id3 exemples attributs cible =
  if exemples = [] then
    failwith "Pas d'exemples"
  else if touslesmemes exemples cible then
    Feuille (List.hd exemples).(cible)
  else if attributs = [] then
    let m = majoritaire exemples cible in
    Feuille m
  else
    let k = plus_discriminant exemples attributs cible in
    let (exg, exd) = separe exemples k in
    let g = 
        match exg with
        | [] -> Feuille (majoritaire exemples cible)
        | _ -> id3 exg (enleve attributs k) cible 
    in
    let d = 
        match exd with
        | [] -> Feuille (majoritaire exemples cibles)
        | _ -> id3 exd (enleve attributs k) cible 
    in
    Noeud (k, g, d)
 ;;


 let exemple_ds = [
   [| false; true ; true  |];
   [| true ; true ; true  |];
   [| false; true ; false |];
   [| false; false; false |];
   [| true ; true ; true  |];
   [| true ; true ; true  |];
   [| false; true ; false |];
   [| false; false; false |]
 ];;

 gain exemple_ds 0 2;;
 gain exemple_ds 1 2;;
     
 let a = id3 exemple_ds [0; 1] 2;;

 1.0 -.  (-5. /. 8. *. (1. /. 5. *. log2 (1. /. 5.) +. 4. /. 5. *. log2 (4. /. 5.)));;
 1.0 -.  (-6. /. 8. *. (4. /. 6. *. log2 (4. /. 6.) +. 2. /. 6. *. log2 (2. /. 6.)));;

   0.72 *. 5. /. 8.;;
