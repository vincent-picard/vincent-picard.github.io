prologues := 3;
outputtemplate := "%j-%c.%o";
outputformat := "svg";

input graph.mp;

% Exemple d'automate
% ------------------
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
edge_label.bot(btex $a$ etex, t[0][0]);
edge_label.top(btex $b$ etex, t[0][1]);
edge_label.bot(btex $a$ etex, t[1][0]);
edge_label.top(btex $b$ etex, t[1][2]);
edge_label.top(btex $a$ etex, t[2][0]);

mark_init(n0, angle(left));
mark_final(n1);
mark_final(n2);

currentpicture := currentpicture scaled 2;
endfig;


% Automates de Thomson
beginfig(2);

z0 = origin;
z1 - z0 = 3cm * right;

pickup pencircle scaled 1pt;

path n[], t[][];

for i = 0 upto 1:
    n[i] := circle_node(z[i]);
    draw n[i];
endfor

mark_init(n0, angle(left));
mark_final(n1);

currentpicture := currentpicture scaled 2;
endfig;


beginfig(3);

z0 = origin;
z1 - z0 = 3cm * right;

pickup pencircle scaled 1pt;

path n[], t[][];

for i = 0 upto 1:
    n[i] := circle_node(z[i]);
    draw n[i];
endfor

t[0][1] := direct_edge(n0, n1); drawarrow t[0][1];
edge_label.top(btex $\varepsilon$ etex, t[0][1]);

mark_init(n0, angle(left));
mark_final(n1);

currentpicture := currentpicture scaled 2;
endfig;

beginfig(4);

z0 = origin;
z1 - z0 = 3cm * right;

pickup pencircle scaled 1pt;

path n[], t[][];

for i = 0 upto 1:
    n[i] := circle_node(z[i]);
    draw n[i];
endfor

t[0][1] := direct_edge(n0, n1); drawarrow t[0][1];
edge_label.top(btex $a$ etex, t[0][1]);

mark_init(n0, angle(left));
mark_final(n1);

currentpicture := currentpicture scaled 2;
endfig;

vardef auto_diamond(expr src, dst, h) =
    pair haut, bas;
    haut := 0.5[src, dst] + h * up;
    bas := 0.5[src, dst] + h * down;
    src -- haut -- dst -- bas -- cycle
enddef;

beginfig(5);

z0 = origin;
z1 - z0 = z2 - z1 = 3cm * right;

pickup pencircle scaled 1pt;

path n[], t[][];

path a[];
a1 := auto_diamond(z0, z1, 1cm);
a2 := auto_diamond(z1, z2, 1cm);

draw a1;
draw a2;

for i = 0 upto 2:
    n[i] := circle_node(z[i]);
    fill n[i] withcolor white;
    draw n[i];
endfor

%t[0][1] := direct_edge(n0, n1); drawarrow t[0][1];
%edge_label.top(btex $a$ etex, t[0][1]);

label(btex $A_1$ etex, center a1);
label(btex $A_2$ etex, center a2);
label(btex $\tilde{q}$ etex, z1);
label(btex $q_0^1$ etex, z0);
label(btex $q_f^2$ etex, z2);

mark_init(n0, angle(left));
mark_final(n2);

currentpicture := currentpicture scaled 2;
endfig;

beginfig(6);

z0 = origin;
z2 - z1 = z4 - z3 = 3cm * right;
z1 - z3 = 3cm * up;
x1 - x0 = 3cm;
y1 + y3 = 2y0;
x5 - x4 = 3cm;
y2 + y4 = 2y5;

pickup pencircle scaled 1pt;

path n[], t[][];

path a[];
a1 := auto_diamond(z1, z2, 1cm);
a2 := auto_diamond(z3, z4, 1cm);

draw a1;
draw a2;

for i = 1 upto 4:
    n[i] := circle_node(z[i]);
    fill n[i] withcolor white;
    draw n[i];
endfor
n[0] := circle_node(z[0]);
fill n[0] withcolor white;
draw n[0] withcolor blue;
n[5] := circle_node(z[5]);
fill n[5] withcolor white;
draw n[5] withcolor blue;

%t[0][1] := direct_edge(n0, n1); drawarrow t[0][1];
%edge_label.top(btex $a$ etex, t[0][1]);

label(btex $A_1$ etex, center a1);
label(btex $A_2$ etex, center a2);

label(btex $q_0^1$ etex, z1);
label(btex $q_f^1$ etex, z2);
label(btex $q_0^2$ etex, z3);
label(btex $q_f^2$ etex, z4);

drawoptions(withcolor blue);
label(btex $q_0$ etex, z0);
label(btex $q_f$ etex, z5);
t[0][1] := direct_edge(n0, n1); drawarrow t[0][1];
edge_label.ulft(btex $\varepsilon$ etex, t[0][1]);
t[0][3] := direct_edge(n0, n3); drawarrow t[0][3];
edge_label.llft(btex $\varepsilon$ etex, t[0][3]);
t[2][5] := direct_edge(n2, n5); drawarrow t[2][5];
edge_label.urt(btex $\varepsilon$ etex, t[2][5]);
t[4][5] := direct_edge(n4, n5); drawarrow t[4][5];
edge_label.lrt(btex $\varepsilon$ etex, t[4][5]);
mark_init(n0, angle(left));
mark_final(n5);

currentpicture := currentpicture scaled 2;
endfig;

beginfig(7);

z0 = origin;
z1 - z0 = z2 - z1 = z3 - z2 = 3cm * right;

pickup pencircle scaled 1pt;

path n[], t[][];

path a[];
a1 := auto_diamond(z1, z2, 1cm);

draw a1;

for i = 1 upto 2:
    n[i] := circle_node(z[i]);
    fill n[i] withcolor white;
    draw n[i];
endfor

n[0] := circle_node(z[0]);
fill n[0] withcolor white;
draw n[0] withcolor blue;
n[3] := circle_node(z[3]);
fill n[3] withcolor white;
draw n[3] withcolor blue;

%t[0][1] := direct_edge(n0, n1); drawarrow t[0][1];
%edge_label.top(btex $a$ etex, t[0][1]);

label(btex $A_1$ etex, center a1);

label(btex $q_0^1$ etex, z1);
label(btex $q_f^1$ etex, z2);

drawoptions(withcolor blue);
label(btex $q_0$ etex, z0);
label(btex $q_f$ etex, z3);
t[0][1] := direct_edge(n0, n1); drawarrow t[0][1];
edge_label.top(btex $\varepsilon$ etex, t[0][1]);
t[2][3] := direct_edge(n2, n3); drawarrow t[2][3];
edge_label.top(btex $\varepsilon$ etex, t[2][3]);
t[2][1] := bended_edge(n2, n1, -100); drawarrow t[2][1];
edge_label.top(btex $\varepsilon$ etex, t[2][1]);
t[0][3] := bended_edge(n0, n3, -45); drawarrow t[0][3];
edge_label.bot(btex $\varepsilon$ etex, t[0][3]);

mark_init(n0, angle(left));
mark_final(n3);

currentpicture := currentpicture scaled 2;
endfig;



end;
