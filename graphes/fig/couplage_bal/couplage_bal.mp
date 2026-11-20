prologues := 3;
outputtemplate := "%j-%c.%o";
outputformat := "svg";

beginfig(1);

z.u0 = origin;
z.u0 - z.u1 = z.u1 - z.u2 = z.u2 - z.u3 = z.u3 - z.u4 = 1cm * up;
z.v0 - z.v1 = z.v1 - z.v2 = z.v2 - z.v3 = z.v3 - z.v4 = z.v4 - z.v5 = 1cm * up;
0.5[z.u0, z.u4] - 0.5[z.v0, z.v5] = 4cm * left;

draw fullcircle
    xscaled 2.5cm yscaled 6cm
    shifted 0.5[z.u0, z.u4]
    dashed evenly;

draw fullcircle
    xscaled 2.5cm yscaled 7cm
    shifted 0.5[z.v0, z.v5]
    dashed evenly;

drawoptions(withcolor red withpen pencircle scaled 1.5mm);
draw z.u0 -- z.v5;
draw z.u1 -- z.v2;
draw z.u3 -- z.v3;
drawoptions();

for i = 0 upto 4:
    draw z.u[i] withpen pencircle scaled 1.5mm;
endfor
for i = 0 upto 5:
    draw z.v[i] withpen pencircle scaled 1.5mm;
endfor

label.lft(btex $u_0$ etex, z.u0);
label.lft(btex $u_1$ etex, z.u1);
label.lft(btex $u_2$ etex, z.u2);
label.lft(btex $u_3$ etex, z.u3);
label.lft(btex $u_4$ etex, z.u4);
label.rt(btex $v_0$ etex, z.v0);
label.rt(btex $v_1$ etex, z.v1);
label.rt(btex $v_2$ etex, z.v2);
label.rt(btex $v_3$ etex, z.v3);
label.rt(btex $v_4$ etex, z.v4);
label.rt(btex $v_5$ etex, z.v5);

draw z.u0 -- z.v0;
draw z.u0 -- z.v2;
draw z.u0 -- z.v3;
draw z.u0 -- z.v4;
draw z.u0 -- z.v5;
draw z.u1 -- z.v1;
draw z.u1 -- z.v2;
draw z.u2 -- z.v4;
draw z.u2 -- z.v5;
draw z.u3 -- z.v3;
draw z.u4 -- z.v5;



label(btex $U$ etex, z.u4 shifted (1.5cm * down));
label(btex $V$ etex, z.v5 shifted (1.5cm * down));
currentpicture := currentpicture scaled 2;
endfig;

end;
