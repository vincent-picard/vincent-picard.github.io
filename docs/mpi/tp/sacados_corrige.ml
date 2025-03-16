(* Type représentant une instance du problème du sac a dos *)
type sacados = {
    poids : int list;
    valeur : int list;
    capacite : int
};;

let s1 = {
    poids = [200; 314; 198; 500; 300];
    valeur = [40; 50; 100; 95; 30];
    capacite = 1000
};;

(* sommeprod prend deux listes l1 et l2 de meme longeur
   et retourne la somme des l1[i]l2[i] *)
let rec sommeprod l1 l2 = match (l1, l2) with
    | ([], []) -> 0
    | (t1::q1, t2::q2) -> (t1 * t2) + sommeprod q1 q2
    | _ -> failwith "sommeprod : longueurs des listes"
;;

let verifie s l =
    let poids_total = sommeprod s.poids l in
    poids_total <= s.capacite
;;

let cout s l = sommeprod s.valeur l;;

(* enleve k l retourne un couple (x, l2) où x est l'element de l d'indice
   k et l2 la liste l privée de cet élement *)
let rec enleve k l = match (k, l) with
    | (_, []) -> failwith "enleve : indice faux"
    | (0, t::q) -> (t, q)
    | (k, t::q) -> let (x, l2) = enleve (k-1) q in
                    (x, t::l2)
;;

let range s k =
    let (p, poids_reste) = enleve k s.poids in
    let (_, valeur_reste) = enleve k s.valeur in
    {
        poids = poids_reste;
        valeur = valeur_reste;
        capacite = s.capacite - p
    }
;;

let rec majorer s =
    if s.capacite = 0 || List.length s.poids = 0 then 0 else (
        let rec aux l1 l2 = match (l1, l2) with
        | ([x], [y])-> (0, x, y)
        | (t1::q1, t2::q2) ->
                let (k, u, v) = aux q1 q2 in
                let r1 = float t1 /. float t2 in
                let r2 = float u /. float v in
                if r1 >= r2 then
                    (0, t1, t2)
                else
                    (k+1, u, v)
	| [], [] -> failwith "majorer : listes vides"
        | _ -> failwith "majorer"
        in
        (* on calcule i l'indice d'objet de meilleur rapport,
           v sa valeur et p son poids *)
        let (i, v, p) =  aux s.valeur s.poids in
        if p <= s.capacite then
            (* s'il y a de la place pour l'objet de meilleur
               rapport, on le compte et on le range dans le sac *)
            v + majorer (range s i)
        else
            (* sinon on ajoute la fraction de cet objet dans l'espace
               restant *)
            let fraction = float s.capacite /. float p in
            int_of_float (ceil ((float v) *. fraction))
    )
;;

majorer s1;;

let rec branchbound s vmax vactuelle =
    match s with
    | {valeur = []; poids = []; capacite = _} -> (vactuelle, [])
    | {valeur = tv::qv; poids = tp::qp; capacite = c} -> (
        if majorer s + vactuelle <= vmax then
            (print_string "elagage\n"; (-1, [])) (* si on ne peut pas ameliorer, on elague *)
        else (
            let sg = {valeur = qv; poids = qp; capacite = c} in
            let (vg, lg) = branchbound sg vmax vactuelle in
            let vmax = max vmax vg in
            if tp <= c then (* si on peut prendre l'objet *)
                let sd = {valeur = qv; poids = qp; capacite = c - tp} in
                let (vd, ld) = branchbound sd vmax (vactuelle + tv) in
                if vg > vd then
                    (vg, 0::lg)
                else
                    (vd, 1::ld)
            else
                (vg, 0::lg)
        ))
    | _ -> failwith "branchbound : longueurs listes"
;;

let resoudre s = branchbound s (-1) 0;;
  
let (best, solution) = resoudre s1;;
