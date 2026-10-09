(* Arbre préfixe, arbre des suffixes *)

(* On ne travaillera que sur l'alphabet minuscule a-z *)

let liste_lettres mot =
  let n = String.length mot in
  (* construit la liste des lettres du
     mot mot[k..(n-1)] *)
  let rec aux k =
    if k >= n then
      []
    else
      mot.[k] :: (aux (k + 1))
  in
  aux 0
;;

(* Dictionnaire *)
  (* On décide de réaliser la structure abstraite de dictionnaire à l'aide d'une liste associative
     où les clefs sont triées *)

type ('a, 'b) dico = ('a * 'b) list;;


let make_dico () = [];;
  
let rec dexiste dico clef = match dico with
  | [] -> false
  | (c, v)::q ->
     if c = clef then
       true
     else if clef < c then
       false
     else
       dexiste q clef
;;

let rec dajoute dico clef valeur = match dico with
  | [] -> [(clef, valeur)]
  | (c, v)::q ->
     if clef <= c then
       (clef, valeur)::dico
     else
       (c, v)::(dajoute q clef valeur)
;;
  
let rec dtrouve dico clef = match dico with
  | [] -> raise Not_found
  | (c, v)::q ->
     if c = clef then
       v
     else if clef < c then
       raise Not_found
     else
       dtrouve q clef
;;

let rec dchange dico clef valeur = match dico with
  | [] -> raise Not_found
  | (c, v)::q ->
     if c = clef then
       (c, valeur)::q
     else if clef < c then
       raise Not_found
     else
       (c, v)::(change q clef valeur)
;;

let rec dsupprime dico clef = match dico with
  | [] -> raise Not_found
  | (c, v)::q ->
     if c = clef then
       q
     else if clef < c then
       raise Not_found
     else
       (c, v)::(dsupprime q clef)
;;

(* Tests de la structure *)

let d = make_dico ();;
let d1 = dajoute d 'C' 10;;
let d2 = dajoute d1 'A' 20;;
let d3 = dajoute d2 'B' 30;;
dexiste d3 'B';;
dexiste d3 'Z';;    
dtrouve d3 'C';;
let d4 = dchange d3 'C' 40;;    
dtrouve d4 'C';;
let d5 = dsupprime d4 'C';;
dexiste d5 'C'

(* Arbre préfixe *)

type ptree =
  | Feuille of int
  | Noeud of int * (char, ptree) dico
;;

type mot = char list;;

let make_ptree () = Feuille (-1);;
  
let rec ptrouve pt mot = match (pt, mot) with
  | (Feuille n, []) -> n (* on tombe sur une feuille, on a lu toutes les lettres *)
  | (Feuille _, _) -> raise Not_found (* on tombe sur une feuille et il reste des lettres *)
  | (Noeud (n, _), []) -> n (* on tombe sur un noeud, on a lu toutes les lettres *)
  | (Noeud (b, fils), t::q) ->
       let bonfils = dtrouve fils t  in
       ptrouve bonfils q
(* Si le fils etiquete par t n'existe pas Not_found sera declenché*)
;;

let rec pajoute pt mot numero = match (pt, mot) with
  | (Feuille (-1), []) -> Feuille numero
  | (Feuille _, []) -> failwith "le mot existe deja"
  | (Feuille n, t::q) ->
     (* Dans ce cas il faut creer un fils pour la lettre t *)
     let nouveau_fils = Feuille (-1) in
     let nouveau_fils = pajoute nouveau_fils q numero in
     (* La feuille devient noeud donc il faut un nouveau dico *)
     let d = make_dico () in
     let d = dajoute d t nouveau_fils in
     Noeud (n, d)
  | (Noeud ((-1), fils), []) -> Noeud (numero, fils)
  | (Noeud _, []) -> failwith "le mot existe deja"
  | (Noeud (n, fils), t::q) ->
     try (* on essaye de voir si le lien étiqueté par t existe *)
       let bonfils = dtrouve fils t in
       let modfils = pajoute bonfils q numero in
       Noeud (n, dchange fils t modfils)
     with (* si le lien n'existe pas on l'ajoute *) 
     | Not_found ->
	begin
	  let nouveau_fils = Feuille (-1) in
	  let nouveau_fils = pajoute nouveau_fils q numero in
	  let d = dajoute fils t nouveau_fils in
	  Noeud (n, d)
	end
;;
	  
let p1 = make_ptree ();;
let p2 = pajoute p1 (liste_lettres "BANANE") 1;;
let p3 = pajoute p2 (liste_lettres "BABAR") 2;;
let p4 = pajoute p3 (liste_lettres "BABA") 3;;
let p5 = pajoute p4 (liste_lettres "BANC") 4;;

  (* L'arbre des suffixes d'un mot u est l'arbre des prefixes construit à partir de tous les suffixes
     de u$ où $ est une lettre n'existant pas *)

let make_stree mot =
  let rec construction pt liste pos = match liste with
    | [] -> pt
    | t::q ->
       construction (pajoute pt liste pos) q (pos + 1)
  in
  construction (make_ptree ()) (liste_lettres mot) 0
;;


let rec numeros_arbre a = match a with
  | Feuille (-1) -> []
  | Feuille n -> [n]
  | Noeud (-1, fils) -> numeros_liste (List.map (fun (clef, valeur) -> valeur) fils)
  | Noeud (n, fils) -> n::(numeros_liste (List.map (fun (clef, valeur) -> valeur) fils))
and numeros_liste l = match l with
  | a::reste -> (numeros_arbre a) @ (numeros_liste reste)
  | [] -> []
;;

let ananas_sf = make_stree "ANANAS";;

numeros_arbre ananas_sf;;

let occurrences texte_sf motif =

  let rec descendre arbre lettres = match (arbre, lettres) with
    | (a, []) -> numeros_arbre a
    | (Feuille _, t::q) -> [] (* on est au bout de la descente *)
    | (Noeud (_, fils), t::q) ->
       try
	 let bonfils = dtrouve fils t in
	 descendre bonfils q
       with
       | Not_found -> [] (* on est bloqué lors de la descente *)
  in
  descendre texte_sf (liste_lettres motif)
;;

  (* Pour rechercher les occurrences de ANA dans ANANAS *)

  occurrences ananas_sf "ANA";;

  (* autre exemple *)


let adn = "ATTGCATATAGCACTATAGCATATGCTATAGCTAT";;
let adn_sf = make_stree adn;;
  occurrences adn_sf "TATA";;
    occurrences adn_sf "TA";;
