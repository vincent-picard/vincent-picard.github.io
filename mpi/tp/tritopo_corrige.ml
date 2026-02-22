(* PARTIE 1 - Tri topologique d'un graphe orienté acyclique (DAG) *)

(* Les sommets sont numérotés de 0 à g.taille - 1 *)
type graphe = {taille: int; succ: int list array};;

let g_exemple = {
    taille = 8;
    succ = [|
             [1];
             [3; 4];
             [0];
             [];
             [5];
             [];
             [5];
             [1]
           |]
  };;

let tri_topo g =
  let n = g.taille in
  let visite = Array.make n false in
  let pile = ref [] in
  (* parcours en profondeur depuis s. On ajoutera
     chaque sommet dans la pile une fois tous ses successeurs
     visités (ordre postfixe)
   *)
  let rec parcours_profondeur s =
    if not visite.(s) then
      begin
        visite.(s) <- true;
        List.iter parcours_profondeur (g.succ.(s));
        pile := s::(!pile)
      end
  in
  for k = 0 to n - 1 do
    parcours_profondeur k
  done;
  !pile
;;

tri_topo g_exemple;;

(* PARTIE 2 - Calcul du graphe transposé *)

let transpose g =
  let n = g.taille in
  let succ = Array.make n [] in
  for k = 0 to n - 1 do
    let rec traite_voisins x l = match l with
      | [] -> ()
      | y::q ->
         begin
           succ.(y) <- x :: succ.(y);
           traite_voisins x q
         end
    in
    traite_voisins k g.succ.(k)
  done;
  {taille = n; succ = succ}
;;

transpose g_exemple;;

(* PARTIE 3 - Algorithme de Kosaraju *)

let g_exemple2 = {
    taille = 8;
    succ = [|
             [1];
             [3; 4];
             [0];
             [0];
             [5];
             [6];
             [5];
             [1]
           |]
  };;

tri_topo g_exemple2;;

let kosaraju g =
  let n = g.taille in
  let gbar = transpose g in
  let ordre = tri_topo g in
  let composante = Array.make n (-1) in
  let composante_actuelle = ref 0 in
  (* realise le parcours en profondeur 
   * depuis s dans g bar des sommets
   * non visites et les marque avec composante_actuelle *)
  let rec parcours_profondeur s =
    if composante.(s) = -1 then
      begin
        composante.(s) <- !composante_actuelle;
        List.iter parcours_profondeur gbar.succ.(s);
      end
  in
  (* prend une liste de sommets à traiter. Pour chaque sommet
     si le sommet n'a pas été visité déclencher le parcours
     en profondeur depuis ce sommet, puis incrémenter le
     numéro de composante_actuelle
   *)
  let rec traite_sommets l = match l with
    | [] -> ()
    | t::q ->
       if composante.(t) = -1 then
         begin
           parcours_profondeur t;
           incr composante_actuelle
         end;
       traite_sommets q
  in
  traite_sommets ordre;
  composante
;;
        
kosaraju g_exemple2;;

(* On pourra remarquer que Kosaraju numérote les CFC dans un ordre topologique du graphe réduit où les sommets seraient des CFC*)
