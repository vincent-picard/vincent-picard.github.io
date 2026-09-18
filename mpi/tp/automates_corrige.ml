type etat = int;;

type alphabet = char list;;

type auto = {
    taille : int;
    init : etat;
    final : etat list;
    trans : (char * etat) list array
};;

let rec mem x l = match l with
    | [] -> false
    | t::q -> (t = x) || (mem x q)
;;

let rec assoc clef liste = match liste with
    | [] -> raise Not_found
    | (c, v)::_ when c = clef -> v
    | _::q -> assoc clef q
;;

let lecture_afd a q u =
    let etat = ref q in
    let n = String.length u in
    for i = 0 to n-1 do
        let nouvel_etat = assoc u.[i] a.trans.(!etat) in
        etat := nouvel_etat
    done;
    !etat
;;

let a_tableau = {
    taille = 2;
    init = 0;
    final = [1];
    trans = [|
        [('a', 0); ('b', 1)];
        [('a', 0); ('b', 1)]
    |]
};;

let recon_afd a u =
    try
        let q = lecture_afd a a.init u in
        mem q a.final
    with
        | Not_found -> false
;;

recon_afd a_tableau "abbbba";;

(* parcours_alphabet prend en entree une liste de
    lettres et pour chaque lettre x où il n'y
    a pas de transition sortante etiquetee x
    alors on rajoute un couple (x, puits) à l
*)

let ajoute_fleches sigma puits l =
    let lettres_presentes = List.map fst l in
    let rec parcours_alphabet s = match s with
    | [] -> l
    | x::q -> 
            if mem x lettres_presentes then
                parcours_alphabet q    
            else    
                (x, puits)::(parcours_alphabet q)
    in parcours_alphabet sigma
;;

let completion sigma a = 
    let n = a.taille in
    let t = Array.make (n + 1) [] in
    (* remplir le tableau ici *)
    for i = 0 to n-1 do
        t.(i) <- ajoute_fleches sigma n a.trans.(i)
    done;
    t.(n) <- ajoute_fleches sigma n [];
    {
        taille = n + 1 ;
        init = a.init ;
        final = a.final ;
        trans = t
    }
;;

let comp_int n l =
    (* aux k construit la liste des entiers entre
       k et n (inclus) qui ne sont pas dans l *)
    let rec aux k =
        if k > n then
            [] 
        else if mem k l then
            aux (k + 1)
        else
            k::(aux (k + 1))
    in aux 0
;;

(* OU *)
let comp_int n l =
    let res = ref [] in
    for k = 0 to n do
        if not (mem k l) then
            res := k :: (!res)
    done;
    !res
;;

let comp sigma a =
    let a1 = completion sigma a in
    {
        taille = a1.taille;
        init = a1.init;
        final = comp_int (a1.taille - 1) a1.final;
        trans = Array.copy a1.trans
    }
;;

let rec produit_cartesien l1 l2 = match (l1, l2) with
    | ([], _) -> []
    | (_, []) -> []
    | ([x], t::q) -> (x, t)::(produit_cartesien [x] q)
    | (t::q, l2) -> (produit_cartesien [t] l2)@
                    (produit_cartesien q l2)
;;
































































let lecture_afd a q u =
    let etat_actuel = ref q in
    let n = String.length u in
    for i = 0 to n-1 do
        let nouvel_etat = assoc u.[i] a.trans.(!etat_actuel) in
        etat_actuel := nouvel_etat
    done;
    !etat_actuel
;;

let recon_afd a u =
    try
        let q = lecture_afd a a.init u in
        mem q a.final
    with
        | Not_found -> false (* Si blocage le mot n'est pas reconnu *)
;;

let a_tableau = {
    taille = 2;
    init = 0;
    final = [1];
    trans = [|
        [ ('a', 0); ('b', 1)];
        [ ('a', 0); ('b', 1)]
    |]
};;

(*
ajoute prend une liste de lettres,
et pour chaque lettre manquante x ajoute
une transition (x, puits) dans la liste l
*)
let ajoute_fleches sigma puits l =
    let lettres_presentes = List.map fst l in
    let rec ajoute s = match s with
        | [] -> l
        | x::q -> 
                if mem x lettres_presentes then
                    ajoute q
                else
                    (x, puits)::(ajoute q)
    in ajoute sigma
;;

ajoute_fleches 
    ['a'; 'b'; 'c'; 'd'] 
    13
    [('a', 5); ('c', 2)]
;; 

let completion sigma a =
    let n = a.taille + 1 in
    let t = Array.make n [] in
    (* pour tous les anciens états *)
    for i = 0 to a.taille - 1 do
        t.(i) <- ajoute_fleches sigma (n-1) a.trans.(i)
    done;
    (* on ajoute les boucles sur l'état puits *)
    t.(n-1) <- ajoute_fleches sigma (n-1) [];
    {
        taille = a.taille + 1;
        init = a.init;
        final = a.final;
        trans = t
    }
;;








   







