prologues := 3;
outputtemplate := "%j-%c.%o";
outputformat := "svg";

beginfig(1);
v := 1cm;
h := 1cm;

z0 = origin;

% Profondeur 1
y0 - y1 = y0 - y2 = y0 - y3 = y0 - y4 = v;
(x2 + x3) / 2 = x0;
x2 - x1 = x3 - x2 = x4 - x3 = 1.8h;
% Profondeur 2
for i = 5 upto 12:
    y1 - y[i] = v;
endfor;
x6 - x5 = x7 - x6 = x8 - x7 = h;
(x7 + x6)/2 = x2;

x10 - x9 = x11 - x10 = x12 - x11 = h;
(x10 + x11)/2 = x4;

% Feuilles epsilon
z13 = z6 shifted (v * down);
z14 = z8 shifted (v * down);
z15 = z10 shifted (v * down);
z16 = z12 shifted (v * down);

draw z0 -- z1;
draw z0 -- z2;
draw z0 -- z3;
draw z0 -- z4;

draw z2 -- z5;
draw z2 -- z6;
draw z2 -- z7;
draw z2 -- z8;

draw z4 -- z9;
draw z4 -- z10;
draw z4 -- z11;
draw z4 -- z12;

draw z6 -- z13;
draw z8 -- z14;
draw z10 -- z15;
draw z12 -- z16;

for i = 0 upto 16:
    fill fullcircle scaled 0.5cm shifted z[i] withcolor white;
    unfill fullcircle scaled 0.5cm shifted z[i];
endfor;

label(btex $S$ etex, z0);

label(btex $a$ etex, z1);
label(btex $S$ etex, z2);
label(btex $b$ etex, z3);
label(btex $S$ etex, z4);

label(btex $a$ etex, z5);
label(btex $S$ etex, z6);
label(btex $b$ etex, z7);
label(btex $S$ etex, z8);

label(btex $a$ etex, z9);
label(btex $S$ etex, z10);
label(btex $b$ etex, z11);
label(btex $S$ etex, z12);

label(btex $\varepsilon$ etex, z13);
label(btex $\varepsilon$ etex, z14);
label(btex $\varepsilon$ etex, z15);
label(btex $\varepsilon$ etex, z16);

currentpicture := currentpicture scaled 2;
endfig;

end;
