clc; clear all; close all;

global GA_VERI_GIRIS GA_VERI_CIKIS GA_SINIR

%% Veri Okuma
veri = readmatrix('veri_y.xlsx');
GA_VERI_GIRIS = veri(:, 1:2);
GA_VERI_CIKIS = veri(:, 3);

%% Arama Uzayı ve GA Parametreleri
GA_SINIR.input1 = [52, 77];
GA_SINIR.input2 = [3.72, 21.74];
GA_SINIR.cikis = [0.8, 3];

parametre.populasyon_boyutu = 20;
parametre.nesil_sayisi = 25;
parametre.caprazlama_olasiligi = 0.85;
parametre.mutasyon_olasiligi = 0.12;
parametre.elit_birey_sayisi = 2;
parametre.turnuva_boyutu = 3;
parametre.mutasyon_sigma = 0.75;
parametre.iyilesme_tol = 1e-5;
parametre.erken_durdurma_sabir = 8;

%% Kural Önceleri (IF tarafı sabit), Çıkış sınıfı GA ile optimize edilir
sabit_kural_onculleri = [ ...
    1 1
    1 3
    2 2
    3 2
    3 3];

kural_sayisi = size(sabit_kural_onculleri, 1);
kural_gen_baslangic = 22;

%% Başlangıç Popülasyonu
populasyon = ga_populasyon_baslat(parametre.populasyon_boyutu, kural_sayisi);

en_iyi_hata = inf;
en_iyi_fis = [];
en_iyi_kromozom = [];
en_iyi_kural_listesi = [];
en_iyi_tahmin = [];
durgun_nesil_sayisi = 0;

%% Genetik Algoritma Döngüsü
for nesil = 1:parametre.nesil_sayisi
    nesil_tic = tic;
    uygunluk = zeros(parametre.populasyon_boyutu, 1);
    fis_pop = cell(parametre.populasyon_boyutu, 1);
    kural_pop = cell(parametre.populasyon_boyutu, 1);
    tahmin_pop = cell(parametre.populasyon_boyutu, 1);

    for i = 1:parametre.populasyon_boyutu
        [uygunluk(i), fis_pop{i}, kural_pop{i}, tahmin_pop{i}] = ga_uygunluk_hesapla(populasyon(i, :), sabit_kural_onculleri);
    end

    [nesil_en_iyi_hata, nesil_en_iyi_indis] = min(uygunluk);
    onceki_en_iyi_hata = en_iyi_hata;
    if nesil_en_iyi_hata < en_iyi_hata
        en_iyi_hata = nesil_en_iyi_hata;
        en_iyi_fis = fis_pop{nesil_en_iyi_indis};
        en_iyi_kromozom = populasyon(nesil_en_iyi_indis, :);
        en_iyi_kural_listesi = kural_pop{nesil_en_iyi_indis};
        en_iyi_tahmin = tahmin_pop{nesil_en_iyi_indis};
    end

    iyilesme_miktari = onceki_en_iyi_hata - en_iyi_hata;
    if iyilesme_miktari > parametre.iyilesme_tol
        durgun_nesil_sayisi = 0;
    else
        durgun_nesil_sayisi = durgun_nesil_sayisi + 1;
    end

    fprintf('Nesil %d/%d -> En iyi MAE: %.6f | Sure: %.2f sn | Durgun: %d\n', ...
        nesil, parametre.nesil_sayisi, en_iyi_hata, toc(nesil_tic), durgun_nesil_sayisi);

    yeni_populasyon = zeros(size(populasyon));
    [~, sirali_indis] = sort(uygunluk, 'ascend');

    for e = 1:parametre.elit_birey_sayisi
        yeni_populasyon(e, :) = populasyon(sirali_indis(e), :);
    end

    yazma_indisi = parametre.elit_birey_sayisi + 1;
    while yazma_indisi <= parametre.populasyon_boyutu
        ebeveyn1 = populasyon(ga_secim_turnuva(uygunluk, parametre.turnuva_boyutu), :);
        ebeveyn2 = populasyon(ga_secim_turnuva(uygunluk, parametre.turnuva_boyutu), :);

        [cocuk1, cocuk2] = ga_caprazlama(ebeveyn1, ebeveyn2, parametre.caprazlama_olasiligi, kural_gen_baslangic);

        cocuk1 = ga_mutasyon(cocuk1, parametre.mutasyon_olasiligi, parametre.mutasyon_sigma, kural_gen_baslangic);
        cocuk2 = ga_mutasyon(cocuk2, parametre.mutasyon_olasiligi, parametre.mutasyon_sigma, kural_gen_baslangic);

        cocuk1 = ga_kromozom_duzelt(cocuk1, kural_gen_baslangic);
        cocuk2 = ga_kromozom_duzelt(cocuk2, kural_gen_baslangic);

        yeni_populasyon(yazma_indisi, :) = cocuk1;
        if yazma_indisi + 1 <= parametre.populasyon_boyutu
            yeni_populasyon(yazma_indisi + 1, :) = cocuk2;
        end
        yazma_indisi = yazma_indisi + 2;
    end

    populasyon = yeni_populasyon;

    if durgun_nesil_sayisi >= parametre.erken_durdurma_sabir
        fprintf('Erken durdurma: %d nesildir anlamli iyilesme yok.\n', parametre.erken_durdurma_sabir);
        break;
    end
end

%% Sonuçları Yazdırma
[~, ~, siniflar] = ga_fis_olustur(en_iyi_kromozom, sabit_kural_onculleri);

fprintf('\n=== GENETIK ALGORITMA SONUCU ===\n');
fprintf('En iyi MAE: %.6f\n', en_iyi_hata);
fprintf('Optimize edilmiş kural listesi [INPUT1 INPUT2 CIKIS AGIRLIK VE]:\n');
disp(en_iyi_kural_listesi);

fprintf('INPUT1 - Dusuk MF [a b c]: [%.4f %.4f %.4f]\n', siniflar.input1(1, :));
fprintf('INPUT1 - Orta  MF [a b c]: [%.4f %.4f %.4f]\n', siniflar.input1(2, :));
fprintf('INPUT1 - Yuksek MF [a b c]: [%.4f %.4f %.4f]\n', siniflar.input1(3, :));

fprintf('INPUT2 - Dusuk MF [a b c]: [%.4f %.4f %.4f]\n', siniflar.input2(1, :));
fprintf('INPUT2 - Orta  MF [a b c]: [%.4f %.4f %.4f]\n', siniflar.input2(2, :));
fprintf('INPUT2 - Yuksek MF [a b c]: [%.4f %.4f %.4f]\n', siniflar.input2(3, :));

fprintf('CIKIS  - Dusuk MF [a b c]: [%.4f %.4f %.4f]\n', siniflar.cikis(1, :));
fprintf('CIKIS  - Orta  MF [a b c]: [%.4f %.4f %.4f]\n', siniflar.cikis(2, :));
fprintf('CIKIS  - Yuksek MF [a b c]: [%.4f %.4f %.4f]\n', siniflar.cikis(3, :));

%% Görselleştirme
figure('Name', 'GA ile Optimize Edilmiş FIS', 'Position', [100, 100, 850, 650]);

subplot(4, 1, 1);
plotmf(en_iyi_fis, 'input', 1);
title('INPUT1 - Dusuk / Orta / Yuksek');

subplot(4, 1, 2);
plotmf(en_iyi_fis, 'input', 2);
title('INPUT2 - Dusuk / Orta / Yuksek');

subplot(4, 1, 3);
plotmf(en_iyi_fis, 'output', 1);
title('CIKIS - Dusuk / Orta / Yuksek');

subplot(4, 1, 4);
plot(GA_VERI_CIKIS, 'b', 'LineWidth', 1.1); hold on;
plot(en_iyi_tahmin, 'r--', 'LineWidth', 1.1);
grid on;
legend('Gercek', 'Tahmin', 'Location', 'best');
title('Gercek ve Tahmin Cikis Degerleri');
xlabel('Ornek No');
ylabel('Cikis');