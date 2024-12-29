prologues := 3;
outputtemplate := "%j-%c.%o";
outputformat := "svg";

input graph.mp;

beginfig(1);

z0 = origin;
z1 - z0 = z2 - z1 = 3cm * right;

pickup pencircle scaled 1pt;

path n[], t[][];

for i = 0 upto 2:
    n[i] := circle_node(z[i]);
    draw n[i];
endfor

t[0][0] := loop_edge(n0, angle(down)); drawarrow t[0][0];
t[0][1] := bended_edge(n0, n1, 35); drawarrow t[0][1];
t[1][2] := direct_edge(n1, n2); drawarrow t[1][2];
t[1][0] := bended_edge(n1, n0, 35); drawarrow t[1][0];
t[2][0] := bended_edge(n2, n0, -50); drawarrow t[2][0];

label(btex $q_0$ etex, z0);
label(btex $q_1$ etex, z1);
label(btex $q_2$ etex, z2);

mark_init(n0, angle(left));
mark_final(n1);
mark_final(n2);

currentpicture := currentpicture scaled 2;
endfig;

end;
