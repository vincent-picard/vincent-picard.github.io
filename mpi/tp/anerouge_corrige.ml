type piece =
    | Ane
    | Recth
    | Rectv
    | Carre
;;

type coord = int * int;;

type config = (piece * coord) list;;

let tri_config (c:config) =
    let compare e1 e2 = match (e1, e2) with
    | (_, (x1, y1)), (_, (x2, y2)) -> (x1 - x2) * 16 + (y1 - y2)
    in
    (List.sort compare c : config)
;;

(* Une configuration est valide si :
    1) les coordonnées de chaque pièce sont valides (la piece est en jeu)
    2) les pieces n'entrent pas en collision
*)

(* Question 1 *)
let config_init =
    tri_config
    [(Ane, (0, 1));
     (Recth, (2, 1));
     (Rectv, (0, 0));
     (Rectv, (0, 3));
     (Rectv, (3, 0));
     (Rectv, (3, 3));
     (Carre, (3, 1));
     (Carre, (3, 2));
     (Carre, (4, 1));
     (Carre, (4, 2))]
;;

let print_config c =
    let m = Array.make_matrix 5 4 '.' in
    let affiche piece = match piece with
        | (Ane, (i, j)) -> begin
            m.(i).(j) <- '#';
            m.(i).(j+1) <- '#';
            m.(i+1).(j) <- '#';
            m.(i+1).(j+1) <- '#'
        end
        | (Recth, (i, j)) -> begin
            m.(i).(j) <- '=';
            m.(i).(j+1) <- '='
        end
        | (Rectv, (i, j)) -> begin
            m.(i).(j) <- '$';
            m.(i+1).(j) <- '$'
        end
        | (Carre, (i, j)) -> m.(i).(j) <- 'o'
    in
    List.iter affiche c;
    for i = 0 to 4 do
        for j = 0 to 3 do
            print_char m.(i).(j)
        done;
        print_newline ()
    done
;;

(* test
print_newline();;
print_config config_init;;
print_newline();;

*)

(* Question 2 *)
let config_finale c =
    List.mem (Ane, (3, 1)) c
;;

(* Question 3 *)
exception Configuration_invalide;;
let config_valide c =
    let m = Array.make_matrix 5 4 false in

    let marquer i j =
        if m.(i).(j) then
            raise Configuration_invalide
        else
            m.(i).(j) <- true
    in

    let verifie piece = match piece with
        | (Ane, (i, j)) -> begin
            if (i < 0) || (i > 3) || (j < 0) || (j > 2) then
                raise Configuration_invalide
            ;
            marquer i j;
            marquer i (j + 1);
            marquer (i + 1) j;
            marquer (i + 1) (j + 1);
        end
        | (Recth, (i, j)) -> begin
            if (i < 0) || (i > 4) || (j < 0) || (j > 2) then
                raise Configuration_invalide
            ;
            marquer i j;
            marquer i (j + 1);
            end
        | (Rectv, (i, j)) -> begin
            if (i < 0) || (i > 3) || (j < 0) || (j > 3) then
                raise Configuration_invalide
            ;
            marquer i j;
            marquer (i + 1) j
            end
        | (Carre, (i, j)) -> begin
            if (i < 0) || (i > 4) || (j < 0) || (j > 3) then
                raise Configuration_invalide
            ;
            marquer i j
        end
    in

    try
        List.iter verifie c;
        true
    with
        | Configuration_invalide -> false
;;

type direction = N | S | E | W;;

let move (i, j) direction = match direction with
    | N -> (i-1, j)
    | E -> (i, j+1)
    | S -> (i+1, j)
    | W -> (i, j-1)
;;

let voisins c = 
   let v = ref [] in
   let t = Array.of_list c in
   for i = 0 to 9 do
       let t2 = Array.copy t in
       let piece, coord = t.(i) in
       t2.(i) <- piece, move coord N;
       let l = Array.to_list t2 in
       if config_valide l then v := (tri_config l) :: !v;
       t2.(i) <- piece, move coord E;
       let l = Array.to_list t2 in
       if config_valide l then v := (tri_config l) :: !v;
       t2.(i) <- piece, move coord S;
       let l = Array.to_list t2 in
       if config_valide l then v := (tri_config l) :: !v;
       t2.(i) <- piece, move coord W;
       let l = Array.to_list t2 in
       if config_valide l then v := (tri_config l) :: !v
   done;
   !v
;;
   

(* Test : affichage des voisins de la configuration intiale *)
(* let l = voisins config_init;;
List.iter (fun c -> print_config c; print_newline ()) l;;
*)

exception Solution of (config * (config, config) Hashtbl.t);;

let parcours_bfs c0 =
    let ouverts = Hashtbl.create 100000 in
    let fermes = Hashtbl.create 100000 in
    let parent = Hashtbl.create 100000 in
    let file = Queue.create () in
    Hashtbl.add parent c0 c0;
    Hashtbl.add ouverts c0 ();
    Queue.push c0 file;
    while not (Queue.is_empty file) do
        let x = Queue.pop file in
        if config_finale x then raise (Solution(x, parent));
        Hashtbl.remove ouverts x;
        Hashtbl.add fermes x ();
        let rec parcours v = match v with
        | [] -> ()
        | y::q -> 
                begin
                    if not (Hashtbl.mem ouverts y || Hashtbl.mem fermes y) then (
                        Hashtbl.add parent y x;
                        Hashtbl.add ouverts y ();
                        Queue.push y file
                    );
                    parcours q
                end
        in parcours (voisins x)
    done;
;;


let reconstruction xfinal parent =
    let rec reconstruit x =
        if x = config_init then
            [x]
        else
            x::(reconstruit (Hashtbl.find parent x))
    in
    List.rev (reconstruit xfinal)
;;

try 
    parcours_bfs config_init
with
    | Solution (xfinal, parent) -> let chemin = reconstruction xfinal parent in
                                    print_string "La solution possede ";
                                    print_int (List.length chemin - 1);
                                    print_string "deplacements.\n"; 
                                    List.iter (fun x -> print_config x; print_newline ()) chemin
;;

