type 'a pile = 'a list ref;;

let creer_pile () = ref [];;

let pile_vide p = (!p = []);;

let inserer x p = 
    p := x::(!p)
;;

let enlever p = match !p with
    | [] -> failwith "enlever : pile vide"
    | t::q -> p := q
;;

let premier p = match !p with
    | [] -> failwith "premier : pile vide"
    | t::q -> t
;;

let deuxieme p = match !p with
    | a::b::q -> b
    | _ -> failwith "deuxieme : pas assez d'elements"
;;

let listepile p = !p;;

let exemple =
    let z0 = (10, 3) in
    let z1 = (4, 4) in
    let z2 = (3, 3) in
    let z3 = (1, 0) in
    let z4 = (9, 1) in
    let z5 = (2, 5) in
    let z6 = (8, 2) in
    let z7 = (8, 6) in
    let z8 = (10, 5) in
    let z9 = (0, 3) in
    [z0; z1; z2; z3; z4; z5; z6; z7; z8; z9]
;;

(* retourne true ssi le point A est "plus petit" que le point B
 * c'est-à-dire qu'il est strictement plus bas, ou alors a la
 * meme ordonnee mais a gauche *)
let compare (xa, ya) (xb, yb) =
    (ya < yb) || (ya = yb && xa <= xb)
;;
(* Rq : c'est un ordre lexicographique sur les couples *)

let rec trouve_pivot l = match l with
    | [] -> failwith "trouve_pivot : liste vide"
    | [p] -> (p, [])
    | t::q -> let (minq, resteq) = trouve_pivot q in
        if compare t minq then (* si t est plus petit que minq *)
            (t, q)
        else
            (minq, t::resteq)
;;

trouve_pivot exemple;;

let vect (xa, ya) (xb, yb) = (xb - xa, yb - ya);;

let det (ux, uy) (vx, vy) = ux * vy - vx * uy;;

let compare2 p a b =
    (det (vect p a) (vect p b) >= 0)
;;

(* separe une liste en un couple de listes *)
let rec separe l = match l with
    | [] -> ([], [])
    | [x] -> ([x], [])
    | x::y::q -> let (l1, l2) = separe q in
        (x::l1, y::l2)
;;

(* fusionne deux listes déjà triées *)
let rec fusion p l1 l2 = match (l1, l2) with
    | ([], l2) -> l2
    | (l1, []) -> l1
    | (t1::q1, t2::q2) -> 
            if compare2 p t1 t2 then
                t1::(fusion p q1 l2)
            else
                t2::(fusion p l1 q2)
;;

let rec tri_fusion p l = match l with
    | [] -> []
    | [x] -> [x]
    | l -> let (l1, l2) = separe l in
    fusion p (tri_fusion p l1) (tri_fusion p l2)
;;

let (pivot, reste) = trouve_pivot exemple;;
tri_fusion pivot reste;;

let graham l =
    let (p, reste) = trouve_pivot l in
    let l2 = tri_fusion p reste in
    let pile = creer_pile () in
    let rec parcours l = match l with
    | [] -> listepile pile
    | t::q ->
            let a = deuxieme pile in
            let b = premier pile in
            (* on teste si les 2 sommets precedents + q font
             * un virage à gauche ? *)
            if det (vect a b) (vect b t) >= 0 then
                (* si oui ajouter t dans la pile et continuer *)
                (inserer t pile; parcours q)
            else
                (* sinon enlever le sommet de la pile et reessayer *)
                (enlever pile; parcours (t::q))
    in match l2 with
    | [] -> failwith "pas assez de points"
    | t::q-> (inserer p pile; inserer t pile; parcours q)
;;

graham exemple;;



