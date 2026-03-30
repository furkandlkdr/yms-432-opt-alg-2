function duzeltilmis = ga_kromozom_duzelt(kromozom, kural_gen_baslangic)

global GA_SINIR

duzeltilmis = kromozom;

% INPUT1 genlerini sinirlayip sirala
x = duzeltilmis(1:7);
x = min(GA_SINIR.input1(2), max(GA_SINIR.input1(1), x));
duzeltilmis(1:7) = sort(x);

% INPUT2 genlerini sinirlayip sirala
y = duzeltilmis(8:14);
y = min(GA_SINIR.input2(2), max(GA_SINIR.input2(1), y));
duzeltilmis(8:14) = sort(y);

% CIKIS genlerini sinirlayip sirala
z = duzeltilmis(15:21);
z = min(GA_SINIR.cikis(2), max(GA_SINIR.cikis(1), z));
duzeltilmis(15:21) = sort(z);

% Kural cikislarini [1, 3] tamsayisina zorla
kural_genleri = round(duzeltilmis(kural_gen_baslangic:end));
kural_genleri = min(3, max(1, kural_genleri));
duzeltilmis(kural_gen_baslangic:end) = kural_genleri;

end
