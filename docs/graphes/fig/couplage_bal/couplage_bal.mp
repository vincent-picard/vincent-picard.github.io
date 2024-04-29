prologues := 3;
outputtemplate := "%j-%c.%o";
outputformat := "svg";

beginfig(1);

z0 = origin;
z0 - z1 = z1 - z2 = z2 - z3 = z3 - z4 = 1cm * up;
z5 - z6 = z6 - z7 = z7 - z8 = z8 - z9 = z9 - z10 = 1cm * up;
0.5[z0, z4] - 0.5[z5, z10] = 4cm * left;

drawoptions(withcolor red withpen pencircle scaled 1.5mm);
draw z[0] -- z[10];
draw z[1] -- z[7];
draw z[3] -- z[8];
drawoptions();

for i = 0 upto 10:
    draw z[i] withpen pencircle scaled 1.5mm;
endfor

for i = 0 upto 4:
    string lab;
    lab = "u" & decimal(i);
    label.lft(lab, z[i]);
endfor

for j = 0 upto 5:
    string lab;
    lab = "v" & decimal(j);
    label.rt(lab, z[j+5]);
endfor


draw z[0] -- z[5];
draw z[0] -- z[7];
draw z[0] -- z[8];
draw z[0] -- z[9];
draw z[0] -- z[10];
draw z[1] -- z[6];
draw z[1] -- z[7];
draw z[2] -- z[9];
draw z[2] -- z[10];
draw z[3] -- z[8];
draw z[4] -- z[10];


draw fullcircle
    xscaled 2.5cm yscaled 6cm
    shifted 0.5[z0, z4]
    dashed evenly;

draw fullcircle
    xscaled 2.5cm yscaled 7cm
    shifted 0.5[z5, z10]
    dashed evenly;

label(btex $U$ etex, z4 shifted (1.5cm * down));
label(btex $V$ etex, z10 shifted (1.5cm * down));
currentpicture := currentpicture scaled 2;
endfig;

end;
