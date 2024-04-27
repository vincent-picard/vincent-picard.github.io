prologues := 3;
outputtemplate := "%j-%c.%o";
outputformat := "svg";

beginfig(1);

z0 = origin;
z0 - z1 = z1 - z2 = z2 - z3 = 1cm * up;
z4 - z5 = z5 - z6 = z6 - z7 = z7 - z8 = z8 - z9 = 1cm * up;
0.5[z0, z3] - 0.5[z4, z9] = 3cm * left;

for i = 0 upto 9:
    draw z[i] withpen pencircle scaled 1.5mm;
endfor

draw z[0] -- z[4];
draw z[0] -- z[6];
draw z[0] -- z[8];
draw z[2] -- z[4];
draw z[2] -- z[5];
draw z[2] -- z[6];
draw z[2] -- z[9];
draw z[3] -- z[8];

draw fullcircle
    xscaled 1.5cm yscaled 5cm
    shifted 0.5[z0, z3]
    dashed evenly;

draw fullcircle
    xscaled 1.5cm yscaled 7cm
    shifted 0.5[z4, z9]
    dashed evenly;

label(btex $U$ etex, z3 shifted (1.5cm * down));
label(btex $V$ etex, z9 shifted (1.5cm * down));
currentpicture := currentpicture scaled 2;
endfig;

end;
