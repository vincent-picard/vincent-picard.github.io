type grille = int array array;;

Random.self_init ();;

let creer_grille n m k =
    let g = Array.make_matrix n m 0 in
    let rec placer_obstacles o =
        if o > 0 then begin
            let a = Random.int n in
            let b = Random.int m in
            if (not ((a, b) = (0, 0)) &&
                not ((a, b) = (n-1,m-1)) &&
                g.(a).(b) = 0)
            then begin
                g.(a).(b) <- 9;
                placer_obstacles (o - 1)
            end else
                placer_obstacles o
         end
    in
    placer_obstacles k;
    g
;;

let print_grille g = 
    let n = Array.length g in
    let m = Array.length g.(0) in
    for i = 0 to n-1 do 
        for j = 0 to m-1 do
            match g.(i).(j) with
            | 0 -> print_char ' '
            | 9 -> print_char '#'
            | 1 -> print_char '.'
            | 2 -> print_char ':'
            | 5 -> print_char '@'
            | _ -> ()
        done;
        print_newline ()
    done
;;


(* retourne les coordonnées des 4 cases adjacentes potentielles *)
let autour (i, j) =
    [(i-1, j); (i+1,j); (i,j-1); (i,j+1)]
;;

(* prend une liste de cases et retourne la liste des cases valides
   et franchissables *)
let filtre g l = 
    let n = Array.length g in
    let m = Array.length g.(0) in
    let rec aux l = match l with
        | [] -> []
        | (a, b)::q when (0 <= a && a < n && 0 <= b && b < m) ->
                if not (g.(a).(b) = 9) then
                    (a, b)::(aux q)
                else
                    aux q
        | _::q -> aux q
    in aux l
;;

let voisins g c =
    filtre g (autour c)
;;

(* PARTIE 2 : File de priorité *)

type 'a fileprio = ('a * int) list ref;;

let creer_file () =
    let r = ref [] in
    r
;;

let est_vide f = (!f = []);;

(* inserer la clef x de valeur v dans f *)
let inserer x v f =
    let rec aux l = match l with
    | [] -> [(x, v)]
    | (a, b)::q ->
            if v < b then
                (x, v)::l
            else
                (a, b)::(aux q)
    in
    f := aux !f
;;

let extraire f =
    match !f with
    | [] -> failwith "File vide"
    | (x, v)::q -> begin (f := q) ; (x, v) end
;;

let supprime clef file =
    let rec aux l = match l with
    | [] -> failwith "Fileprio : clef absente"
    | (x, v)::q -> 
            if x = clef then
                q
            else
                (x, v)::(aux q)
    in
    file := aux !file
;;

let diminuer clef nvaleur file =
    begin
        supprime clef file;
        inserer clef nvaleur file
    end
;;

(* Partie 3 : Algorithme A* *)

let (blanc, gris, noir) = (0, 1, 2);;

(* Marche seulement avec Ocaml > 4.08 *)
(* let infini = Int.max_int;; *)

let infini = 1000000000;;

let manhattan (a, b) (x, y) =
    abs (a - x) + abs (b - y)
;;

type predecesseur = Gauche | Droite | Bas | Haut | Aucun;;

let direction (a, b) (u, v) =
    assert(manhattan (a, b) (u, v) = 1);
    if a = u then
        if b < v then Droite else Gauche
    else
        if a < u then Bas else Haut
;;
    

let astar grille =
    let n = Array.length grille in
    let m = Array.length grille.(0) in
    let pred = Array.make_matrix n m Aucun in
    let g = Array.make_matrix n m infini in
    let f = Array.make_matrix n m infini in
    let file = creer_file () in
    let h = manhattan (n-1, m-1) in 
    g.(0).(0) <- 0;
    f.(0).(0) <- h (0, 0);
    inserer (0, 0) f.(0).(0) file;
    while (not (est_vide file)) && 
          (not (grille.(n-1).(m-1) = noir))
    do
        let ((x, y), v) = extraire file in
        grille.(x).(y) <- noir;
        let vois = voisins grille (x, y) in
        let rec parcours l = match l with
            | [] -> ()
            | (i, j)::q when grille.(i).(j) = blanc -> 
                begin
                    grille.(i).(j) <- gris;
                    g.(i).(j) <- g.(x).(y) + 1;
                    f.(i).(j) <- g.(i).(j) + h (i, j);
                    pred.(i).(j) <- direction (i, j) (x, y);
                    inserer (i, j) f.(i).(j) file;
                    parcours q
                end
            | (i, j)::q when
                (grille.(i).(j) = gris &&
                 g.(x).(y) + 1 < g.(i).(j)) ->
                 begin
                    g.(i).(j) <- g.(x).(y) + 1;
                    f.(i).(j) <- g.(i).(j) + h (i, j);
                    pred.(i).(j) <- direction (i, j) (x, y);
                    diminuer (i, j) f.(i).(j) file;
                    parcours q
                 end
            | (i, j)::q when
                (grille.(i).(j) = noir &&
                 g.(x).(y) + 1 < g.(i).(j)) ->
                 begin (* Réouverture *)
                    grille.(i).(j) <- gris;
                    g.(i).(j) <- g.(x).(y) + 1;
                    f.(i).(j) <- g.(i).(j) + h (i, j);
                    pred.(i).(j) <- direction (i, j) (x, y);
                    inserer (i, j) f.(i).(j) file;
                    parcours q
                 end
            | _::q -> parcours q
        in parcours vois
    done;
    pred
;;

let reconstruire grille pred =
    let n = Array.length grille in
    let m = Array.length grille.(0) in
    let rec aux i j =
        grille.(i).(j) <- 5;
        match pred.(i).(j) with
            | Gauche -> aux i (j - 1)
            | Droite -> aux i (j + 1)
            | Haut -> aux (i-1) j
            | Bas -> aux (i+1) j
            | Aucun -> ()
    in
    aux (n - 1) (m - 1)
;;


(* Export de la grille vers un fichier metapost *)

(* Pour compiler le metapost en pdf : mptopdf fichier.mp*)

(* dimension : string representant la dimension d'une case
   en metapost par exemple "1cm", de même width est l'epaisseur
   des traits *)

let export_mp grille dimension width filename =
    let n = Array.length grille in
    let m = Array.length grille.(0) in
    try
        let oc = open_out filename in
        Printf.fprintf oc "beginfig(1)\n";
        Printf.fprintf oc "dim := %s ; \n" dimension;
        Printf.fprintf oc "w := %s ; \n" width;
        Printf.fprintf oc "n := %d ; \n" n;
        Printf.fprintf oc "m := %d ; \n" m;
        Printf.fprintf oc "color coulg; coulg := (black + 2white)/3 ; \n";
        Printf.fprintf oc "color coulo; coulo := black ; \n";
        Printf.fprintf oc "color coulsol; coulsol := (2green + black)/3 ; \n";
        Printf.fprintf oc "color coulnodes; coulnodes := blue ; \n";
        Printf.fprintf oc "pickup pencircle scaled w ; \n";
        
        Printf.fprintf oc "for i = 0 upto n : \n";
        Printf.fprintf oc "draw (0, i * dim) -- (m * dim, i * dim) withcolor coulg ; \n";
        Printf.fprintf oc "endfor \n";
        Printf.fprintf oc "for j = 0 upto m : \n";
        Printf.fprintf oc "draw (j * dim, 0) -- (j * dim, n * dim) withcolor coulg ; \n";
        Printf.fprintf oc "endfor \n";
        for i = 0 to n-1 do 
            for j = 0 to m-1 do
                match grille.(i).(j) with
                | 9 ->
                        begin
                            Printf.fprintf oc "fill unitsquare scaled dim shifted (%d * dim, (n - 1 - %d) * dim) withcolor coulo ; \n" j i
                        end
                | 1 ->  
                        begin
                            Printf.fprintf oc "draw fullcircle scaled 0.5dim shifted ((%d + 0.5) * dim, (n - 1 - %d + 0.5) * dim) withcolor coulnodes ; \n" j i
                        end 
                | 2 -> 
                        begin
                            Printf.fprintf oc "fill fullcircle scaled 0.5dim shifted ((%d + 0.5) * dim, (n - 1 - %d + 0.5) * dim) withcolor coulnodes ; \n" j i
                        end 
                | 5 ->
                        begin
                            Printf.fprintf oc "fill unitsquare scaled dim shifted (%d * dim, (n - 1 - %d) * dim) withcolor coulsol ; \n" j i
                        end
                | _ -> ()
            done;
        done;

        Printf.fprintf oc "endfig; \n";
        Printf.fprintf oc "end; \n";
        close_out oc
    with
    _ -> failwith "Erreur exportmp"
;;

let g = creer_grille 40 40 500;;

let p = (astar g);;
reconstruire g p;;

(* Sortie console *)
print_grille g;;
(* Sortie fichier *)
export_mp g "0.4cm" "1pt" "grille.mp";;
