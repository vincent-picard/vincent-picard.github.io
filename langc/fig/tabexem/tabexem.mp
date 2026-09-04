prologues := 3;
outputtemplate := "%j-%c.%o";
outputformat := "svg";

beginfig(1);
u := 0.75cm;

path fullsquare; fullsquare := unitsquare shifted -(center unitsquare);
pair t[];
for i = 0 upto 3:
    t[i] := right * u * i;
    draw fullsquare scaled u shifted t[i];
endfor;

label("29", t[0]);
label("17", t[1]);
label("?", t[2]);
label("12", t[3]);

currentpicture := currentpicture scaled 2;
endfig;

end;
