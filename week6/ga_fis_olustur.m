function [fis, kural_listesi, siniflar] = ga_fis_olustur(kromozom, sabit_kural_onculleri)

global GA_SINIR

x = sort(kromozom(1:7));
y = sort(kromozom(8:14));
z = sort(kromozom(15:21));

kural_cikislari = round(kromozom(22:end));
kural_cikislari = min(3, max(1, kural_cikislari));

siniflar.input1 = [
    GA_SINIR.input1(1), x(1), x(3)
    x(2), x(4), x(6)
    x(5), x(7), GA_SINIR.input1(2)
];

siniflar.input2 = [
    GA_SINIR.input2(1), y(1), y(3)
    y(2), y(4), y(6)
    y(5), y(7), GA_SINIR.input2(2)
];

siniflar.cikis = [
    GA_SINIR.cikis(1), z(1), z(3)
    z(2), z(4), z(6)
    z(5), z(7), GA_SINIR.cikis(2)
];

fis = mamfis('Name', 'bulanik_ga');

fis = addInput(fis, GA_SINIR.input1, 'Name', 'INPUT1');
fis = addMF(fis, 'INPUT1', 'trimf', siniflar.input1(1, :), 'Name', 'Dusuk');
fis = addMF(fis, 'INPUT1', 'trimf', siniflar.input1(2, :), 'Name', 'Orta');
fis = addMF(fis, 'INPUT1', 'trimf', siniflar.input1(3, :), 'Name', 'Yuksek');

fis = addInput(fis, GA_SINIR.input2, 'Name', 'INPUT2');
fis = addMF(fis, 'INPUT2', 'trimf', siniflar.input2(1, :), 'Name', 'Dusuk');
fis = addMF(fis, 'INPUT2', 'trimf', siniflar.input2(2, :), 'Name', 'Orta');
fis = addMF(fis, 'INPUT2', 'trimf', siniflar.input2(3, :), 'Name', 'Yuksek');

fis = addOutput(fis, GA_SINIR.cikis, 'Name', 'CIKIS');
fis = addMF(fis, 'CIKIS', 'trimf', siniflar.cikis(1, :), 'Name', 'Dusuk');
fis = addMF(fis, 'CIKIS', 'trimf', siniflar.cikis(2, :), 'Name', 'Orta');
fis = addMF(fis, 'CIKIS', 'trimf', siniflar.cikis(3, :), 'Name', 'Yuksek');

kural_listesi = [sabit_kural_onculleri, kural_cikislari(:), ones(size(sabit_kural_onculleri, 1), 2)];
fis = addRule(fis, kural_listesi);

end
