(* On veut maximiser la fonction sur [-6, 6] *)
let f x =
    -2.0 *. x ** 4.0 +. 5.0 *. x ** 3.0 +. 30.0 *. x ** 2.0 +. 5.0
;;

Random.self_init ();;

(* voisin de x dans [a, b] *)
let voisin x a b =
    let delta = 1.0 -. (Random.float 2.0) in
    let y = x +. delta in
    if y < a then
        a
    else if y > b then
        b
    else
        y
;;

let recuit f a b x0 t0 tfinal =
    let t = ref t0 in
    let x = ref x0 in

    while (!t > tfinal) do
        let y = voisin !x a b in
        if f y > f !x then begin
            x := y
        end
        else begin
            let p = exp (-. (f !x -. f y) /. !t) in
            if (Random.float 1.0 < p) then
                x := y
        end;
        t := !t *. 0.999;
        Printf.printf "Temperature = %f \t x = %f \t f(x) = %f\n " !t !x (f !x)
    done;
    !x
;;

recuit f (-6.0) (6.0) 0.0 10.0 1.0 ;;
