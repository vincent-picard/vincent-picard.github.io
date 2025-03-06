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
end;
