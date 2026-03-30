function populasyon = ga_populasyon_baslat(populasyon_boyutu, kural_sayisi)

global GA_SINIR

% Her birey: 7 (input1) + 7 (input2) + 7 (cikis) + kural_sayisi (kural cikislari)
gen_sayisi = 21 + kural_sayisi;
populasyon = zeros(populasyon_boyutu, gen_sayisi);

for i = 1:populasyon_boyutu
    x = sort(GA_SINIR.input1(1) + rand(1, 7) * (GA_SINIR.input1(2) - GA_SINIR.input1(1)));
    y = sort(GA_SINIR.input2(1) + rand(1, 7) * (GA_SINIR.input2(2) - GA_SINIR.input2(1)));
    z = sort(GA_SINIR.cikis(1) + rand(1, 7) * (GA_SINIR.cikis(2) - GA_SINIR.cikis(1)));
    kural_cikislari = randi([1, 3], 1, kural_sayisi);

    populasyon(i, :) = [x, y, z, kural_cikislari];
end

end
