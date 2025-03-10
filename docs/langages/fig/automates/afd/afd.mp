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

% Mots commençant par aba
% -----------------------
beginfig(2);

z0 = origin;
z1 - z0 = z2 - z1 = z3 - z2 = 3cm * right;

pickup pencircle scaled 1pt;

path q[], t[][];

for i = 0 upto 3:
    q[i] := circle_node(z[i]);
    draw q[i];
endfor
label(btex $q_0$ etex, z0);
label(btex $q_1$ etex, z1);
label(btex $q_2$ etex, z2);
label(btex $q_3$ etex, z3);

t[0][1] := direct_edge(q0, q1); drawarrow t[0][1];
edge_label.top(btex $a$ etex, t[0][1]);
t[1][2] := direct_edge(q1, q2); drawarrow t[1][2];
edge_label.top(btex $b$ etex, t[1][2]);
t[2][3] := direct_edge(q2, q3); drawarrow t[2][3];
edge_label.top(btex $a$ etex, t[2][3]);
t[3][3] := loop_edge(q3, angle(right)); drawarrow t[3][3];
edge_label.rt(btex $a, b$ etex, t[3][3]);

mark_init(q0, angle(left));
mark_final(q3);

currentpicture := currentpicture scaled 2;
endfig;

% Mots commençant contenant un nombre impair de a
% -----------------------------------------------
beginfig(3);

z0 = origin;
z1 - z0 = 3cm * right;

pickup pencircle scaled 1pt;

path q[], t[][];

for i = 0 upto 1:
    q[i] := circle_node(z[i]);
    draw q[i];
endfor
label(btex $q_0$ etex, z0);
label(btex $q_1$ etex, z1);

t[0][1] := bended_edge(q0, q1, 40); drawarrow t[0][1];
edge_label.top(btex $a$ etex, t[0][1]);
t[0][0] := loop_edge(q0, angle(up)); drawarrow t[0][0];
edge_label.top(btex $b$ etex, t[0][0]);
t[1][0] := bended_edge(q1, q0, 40); drawarrow t[1][0];
edge_label.bot(btex $a$ etex, t[1][0]);
t[1][1] := loop_edge(q1, angle(up)); drawarrow t[1][1];
edge_label.top(btex $b$ etex, t[1][1]);

mark_init(q0, angle(left));
mark_final(q1);

currentpicture := currentpicture scaled 2;
endfig;


% Accessibilite et co-accessibilite commençant par aba
% -----------------------
beginfig(4);

z0 = origin;
z1 - z0 = z2 - z1 = z3 - z2 = 3cm * right;
z4 - 0.5[z1, z2] = 2cm * down;
z5 - z2 = 2cm * up;

pickup pencircle scaled 1pt;

path q[], t[][];

for i = 0 upto 5:
    q[i] := circle_node(z[i]);
    draw q[i];
endfor
label(btex $q_0$ etex, z0);
label(btex $q_1$ etex, z1);
label(btex $q_2$ etex, z2);
label(btex $q_3$ etex, z3);
label(btex $q_4$ etex, z4);
label(btex $q_5$ etex, z5);

t[0][1] := direct_edge(q0, q1); drawarrow t[0][1];
edge_label.top(btex $a$ etex, t[0][1]);
t[1][2] := direct_edge(q1, q2); drawarrow t[1][2];
edge_label.top(btex $b$ etex, t[1][2]);
t[2][3] := direct_edge(q2, q3); drawarrow t[2][3];
edge_label.top(btex $a$ etex, t[2][3]);
t[3][3] := loop_edge(q3, angle(right)); drawarrow t[3][3];
edge_label.rt(btex $a, b$ etex, t[3][3]);

t[1][4] := direct_edge(q1, q4); drawarrow t[1][4];
edge_label.lft(btex $a$ etex, t[1][4]);
t[2][4] := direct_edge(q2, q4); drawarrow t[2][4];
edge_label.rt(btex $b$ etex, t[2][4]);
t[4][4] := loop_edge(q4, angle(down)); drawarrow t[4][4];
edge_label.bot(btex $a,b$ etex, t[4][4]);
t[5][2] := direct_edge(q5, q2); drawarrow t[5][2];
edge_label.rt(btex $b$ etex, t[5][2]);


mark_init(q0, angle(left));
mark_final(q3);

currentpicture := currentpicture scaled 2;
endfig;


% Mots commençant par aba
% -----------------------
beginfig(5);

z0 = origin;
z1 - z0 = z2 - z1 = z3 - z2 = 3cm * right;
z4 - z1 = 2cm * down;

pickup pencircle scaled 1pt;

path q[], t[][];

for i = 0 upto 3:
    q[i] := circle_node(z[i]);
    draw q[i];
endfor
label(btex $q_0$ etex, z0);
label(btex $q_1$ etex, z1);
label(btex $q_2$ etex, z2);
label(btex $q_3$ etex, z3);

t[0][1] := direct_edge(q0, q1); drawarrow t[0][1];
edge_label.top(btex $a$ etex, t[0][1]);
t[1][2] := direct_edge(q1, q2); drawarrow t[1][2];
edge_label.top(btex $b$ etex, t[1][2]);
t[2][3] := direct_edge(q2, q3); drawarrow t[2][3];
edge_label.top(btex $a$ etex, t[2][3]);
t[3][3] := loop_edge(q3, angle(right)); drawarrow t[3][3];
edge_label.rt(btex $a, b$ etex, t[3][3]);

mark_init(q0, angle(left));
mark_final(q3);

drawoptions(withcolor blue);
q4 := circle_node(z4); draw q4;
label(btex $q_\infty$ etex, z4);
t[0][4] := direct_edge(q0, q4); drawarrow t[0][4];
edge_label.llft(btex $b$ etex, t[0][4]);
t[1][4] := direct_edge(q1, q4); drawarrow t[1][4];
edge_label.rt(btex $a$ etex, t[1][4]);
t[2][4] := direct_edge(q2, q4); drawarrow t[2][4];
edge_label.lrt(btex $b$ etex, t[2][4]);
t[4][4] := loop_edge(q4, angle(down)); drawarrow t[4][4];
edge_label.bot(btex $a, b$ etex, t[4][4]);


currentpicture := currentpicture scaled 2;
endfig;

end;
