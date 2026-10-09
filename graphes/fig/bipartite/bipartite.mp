prologues := 3;
outputtemplate := "%j-%c.%o";
outputformat := "svg";

beginfig(1);

z.a0 = origin;
z.a0 - z.a1 = z.a1 - z.a2 = z.a2 - z.a3 = 1cm * up;
z.b0 - z.b1 = z.b1 - z.b2 = z.b2 - z.b3 = z.b3 - z.b4 = z.b4 - z.b5 = 1cm * up;
0.5[z.a0, z.a3] - 0.5[z.b0, z.b5] = 3cm * left;

for i = 0 upto 3:
    draw z.a[i] withpen pencircle scaled 1.5mm;
endfor
for i = 0 upto 5:
    draw z.b[i] withpen pencircle scaled 1.5mm;
endfor

draw z.a0 -- z.b0;
draw z.a0 -- z.b2;
draw z.a0 -- z.b4;
draw z.a2 -- z.b0;
draw z.a2 -- z.b1;
draw z.a2 -- z.b2;
draw z.a2 -- z.b5;
draw z.a3 -- z.b4;

draw fullcircle
    xscaled 1.5cm yscaled 5cm
    shifted 0.5[z.a0, z.a3]
    dashed evenly;

draw fullcircle
    xscaled 1.5cm yscaled 7cm
    shifted 0.5[z.b0, z.b5]
    dashed evenly;

label(btex $U$ etex, z.a3 shifted (1.5cm * down));
label(btex $V$ etex, z.b5 shifted (1.5cm * down));
currentpicture := currentpicture scaled 2;
endfig;

beginfig(2);

z.a0 = origin;
z.a0 - z.a1 = z.a1 - z.a2 = z.a2 - z.a3 = z.a3- z.a4 = 1cm * up;
z.b0 - z.b1 = z.b1 - z.b2 = z.b2 - z.b3 = z.b3 - z.b4 = 1cm * up;
0.5[z.a0, z.a4] - 0.5[z.b0, z.b4] = 3cm * left;

for i = 0 upto 4:
    draw z.a[i] withpen pencircle scaled 1.5mm;
endfor
for i = 0 upto 4:
    draw z.b[i] withpen pencircle scaled 1.5mm;
endfor

draw z.a0 -- z.b0;
draw z.a0 -- z.b1;
draw z.a1 -- z.b1;
draw z.a2 -- z.b0;
draw z.a2 -- z.b2;
draw z.a2 -- z.b3;
draw z.a3 -- z.b1;
draw z.a3 -- z.b4;
draw z.a4 -- z.b1;
draw z.a4 -- z.b4;

draw fullcircle
    xscaled 1.5cm yscaled 6cm
    shifted 0.5[z.a0, z.a4]
    dashed evenly;

draw fullcircle
    xscaled 1.5cm yscaled 6cm
    shifted 0.5[z.b0, z.b4]
    dashed evenly;

label(btex $U$ etex, z.a4 shifted (1.5cm * down));
label(btex $V$ etex, z.b4 shifted (1.5cm * down));
currentpicture := currentpicture scaled 2;
endfig;

end;
