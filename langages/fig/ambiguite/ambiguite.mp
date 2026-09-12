prologues := 3;
outputtemplate := "%j-%c.%o";
outputformat := "svg";

beginfig(1);
v := 1cm;
h := 1cm;

z0 = origin;

% Profondeur 1
z2 - z1 = z3 - z2 = h * right;
z0 - z2 = v * up;

% Profondeur 2
z5 - z4 = z6 - z5 = h * right;
z3 - z5 = v * up;

% Constantes
z1 - z7 = z4 - z8 = z6 - z9 = v * up;

% Feuilles
z7 - z10 = z8 - z11 = z9 - z12 = v * up;

draw z0 -- z1;
draw z0 -- z2;
draw z0 -- z3;

draw z3 -- z4;
draw z3 -- z5;
draw z3 -- z6;

draw z1 -- z7 -- z10;
draw z4 -- z8 -- z11;
draw z6 -- z9 -- z12;

for i = 0 upto 12:
    fill fullcircle scaled 0.5cm shifted z[i] withcolor white;
    unfill fullcircle scaled 0.5cm shifted z[i];
endfor;

label(btex $S$ etex, z0);

label(btex $S$ etex, z1);
label(btex $\lor$ etex, z2);
label(btex $S$ etex, z3);

label(btex $S$ etex, z4);
label(btex $\land$ etex, z5);
label(btex $S$ etex, z6);

label(btex $C$ etex, z7);
label(btex $C$ etex, z8);
label(btex $C$ etex, z9);

label(btex $x$ etex, z10);
label(btex $y$ etex, z11);
label(btex $z$ etex, z12);

currentpicture := currentpicture scaled 2;
endfig;

beginfig(2);
v := 1cm;
h := 1cm;

z0 = origin;

% Profondeur 1
z2 - z1 = z3 - z2 = h * right;
z0 - z2 = v * up;

% Profondeur 2
z5 - z4 = z6 - z5 = h * right;
z1 - z5 = v * up;

% Constantes
z3 - z7 = z4 - z8 = z6 - z9 = v * up;

% Feuilles
z7 - z10 = z8 - z11 = z9 - z12 = v * up;

draw z0 -- z1;
draw z0 -- z2;
draw z0 -- z3;

draw z1 -- z4;
draw z1 -- z5;
draw z1 -- z6;

draw z3 -- z7 -- z10;
draw z4 -- z8 -- z11;
draw z6 -- z9 -- z12;

for i = 0 upto 12:
    fill fullcircle scaled 0.5cm shifted z[i] withcolor white;
    unfill fullcircle scaled 0.5cm shifted z[i];
endfor;

label(btex $S$ etex, z0);

label(btex $S$ etex, z1);
label(btex $\land$ etex, z2);
label(btex $S$ etex, z3);

label(btex $S$ etex, z4);
label(btex $\lor$ etex, z5);
label(btex $S$ etex, z6);

label(btex $C$ etex, z7);
label(btex $C$ etex, z8);
label(btex $C$ etex, z9);

label(btex $z$ etex, z10);
label(btex $x$ etex, z11);
label(btex $y$ etex, z12);

currentpicture := currentpicture scaled 2;
endfig;

end;
