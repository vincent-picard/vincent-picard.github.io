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


(* Question 1 *)
let config_init =
    ()
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

(* test *)
(*
print_newline();;
print_config config_init;;
print_newline();;
*)

(* Question 2 *)
let config_finale c =
    ()
;;

(* Question 3 *)
exception Configuration_invalide;;
let config_valide c =
    let m = Array.make_matrix 5 4 false in

    let marquer i j =
        (* a completer *)
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
            (* a completer *)
            end
        | (Rectv, (i, j)) -> begin
            (* a completer *)
        | (Carre, (i, j)) -> begin
            (* a completer *)
    in

    try
        List.iter verifie c;
        true
    with
        | Configuration_invalide -> false
;;

type direction = N | S | E | W;;

let move (i, j) direction = 
    ()
    (* completer *)
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
   


exception Solution of (config * (config, config) Hashtbl.t);;

let parcours_bfs c0 =
    ()
    (* a completer *)
;;


let reconstruction xfinal parent =
    ()
    (* a completer *)
;;

