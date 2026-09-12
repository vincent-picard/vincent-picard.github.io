% Macros pour dessiner des graphes et des automates
% Auteur : Vincent Picard

numeric graph_node_size; graph_node_size := 1cm;

% Construit un noeud circulaire
vardef circle_node(expr pos) =
    fullcircle scaled graph_node_size shifted pos
enddef;

% Construit un arc entre deux noeuds suivant le chemin p
vardef edge(expr src, dest, p) =
    p cutbefore src cutafter dest
enddef;

% Construit un arc droit entre deux noeuds
vardef direct_edge(expr src, dest) =
    edge(src, dest, (center src) -- (center dest))
enddef;

% Construit un arc courbé entre deux noeuds
vardef bended_edge(expr src, dest, theta) =
    save p, d;
    path p;
    numeric d;
    d := angle ((center dest) - (center src));
    p := (center src) {dir (d + theta)} .. {dir(d - theta)} (center dest);
    edge(src, dest, p)
enddef;

% Construit une boucle sur un noeud
vardef loop_edge(expr n, theta) =
    save p, a;
    path p;
    pair a; a := (center n) shifted (dir(theta) * 0.20 * graph_node_size);
    %p := ((center n) ... ((center n) shifted ( 1.1cm * dir(theta))) ... (center n));
    p := (a ... (a shifted ( 0.8graph_node_size * dir(theta))) ... a);
    edge(n, n, p)
enddef;

% Ajoute une étiquette à un arc
vardef edge_label@#(expr t, p) =
    label@#(t, point (length p / 2) of p);
enddef;

% double le noeud pour le marquer final
vardef mark_final(expr p) =
    draw p shifted -(center p) scaled 0.8 shifted (center p);
enddef;

% ajoute une fleche entrante pour marquer un noeud initial
vardef mark_init(expr p, theta) = 
    drawarrow (((center p) shifted (1.5cm * dir(theta))) -- (center p)) cutafter p;
enddef;
