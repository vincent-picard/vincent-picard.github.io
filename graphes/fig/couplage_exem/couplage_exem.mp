prologues := 3;
outputtemplate := "%j-%c.%o";
outputformat := "svg";

beginfig(1);

z.H = origin shifted (2cm * up);
z.G = z.H rotated -60;
z.F = z.G rotated -60;
z.E = z.F rotated -60;
z.D = z.E rotated -60;
z.C = z.D rotated -60;
z.B shifted -z.C = z.D shifted -z.C rotated -90;
z.A - z.B = z.D - z.C;

drawoptions(withpen pencircle scaled 1.5mm withcolor (red + white) /2);
draw z.B -- z.H;
draw z.C -- z.D;
draw z.G -- z.E;
drawoptions();

drawoptions(withpen pencircle scaled 1.5mm);
draw z.H; draw z.G; draw z.F; draw z.E; draw z.D; draw z.C;
draw z.A; draw z.B;
drawoptions();

label.llft(btex $A$ etex, z.A);
label.ulft(btex $B$ etex, z.B);
label.ulft(btex $C$ etex, z.C);
label.llft(btex $D$ etex, z.D);
label.bot(btex $E$ etex, z.E);
label.rt(btex $F$ etex, z.F);
label.rt(btex $G$ etex, z.G);
label.top(btex $H$ etex, z.H);


draw z.A -- z.B -- z.C -- z.D -- cycle;
draw z.C -- z.H -- z.G -- z.G -- z.F -- z.E -- z.D;
draw z.B -- z.D;
draw z.A -- z.C -- z.H;
draw z.D -- z.G;
draw z.E -- z.G;
draw z.B -- z.H;

currentpicture := currentpicture scaled 2;
endfig;
end;
