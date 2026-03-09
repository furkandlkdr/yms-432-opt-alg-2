%% Genetik Algoritma ile Ozellik Secimi (sifirdan)
% Veri kumesi: MATLAB yerlesik 'ionosphere'
% Amac: Secilen ozelliklerle lineer regresyon kullanarak test MSE'sini en aza indirmek

clear;
clc;
close all;

rng(42); % Tekrarlanabilirlik

%% Asama 1: Veri Hazirlama
load ionosphere; % Beklenen degiskenler: X (ornek x 34), Y etiketleri ('g'/'b')

if ~exist('X', 'var') || ~exist('Y', 'var')
    error('Ionosphere veri kumesi dogru yuklenemedi. X ve Y degiskenleri bekleniyor.');
end

y = labels_to_numeric(Y); % Etiketleri sayisala cevir: g->1, b->0

ornekSayisi = size(X, 1);
ozellikSayisi = size(X, 2);

% Egitim/Test bolmesi: 70/30
karisikIndeksler = randperm(ornekSayisi);
egitimOrnekSayisi = round(0.70 * ornekSayisi);
egitimIndeksleri = karisikIndeksler(1:egitimOrnekSayisi);
testIndeksleri = karisikIndeksler(egitimOrnekSayisi + 1:end);

XEgitim = X(egitimIndeksleri, :);
yEgitim = y(egitimIndeksleri);
XTest = X(testIndeksleri, :);
yTest = y(testIndeksleri);

%% Asama 2: GA Cekirdek Ayarlari
populasyonBoyutu = 60;
maksimumNesil = 100;
caprazlamaOrani = 0.85;
mutasyonOrani = 0.03;

populasyon = initialize_population(populasyonBoyutu, ozellikSayisi);

enIyiMSE = inf;
enIyiKromozom = populasyon(1, :);
enIyiMSEGecmisi = zeros(maksimumNesil, 1);

%% Asama 3-4: Ana GA Dongusu (Secim, Caprazlama, Mutasyon, Elitizm)
for nesil = 1:maksimumNesil
    % Her kromozomu secilen ozelliklerle egitip/tahmin ederek degerlendir
    mseDegerleri = evaluate_population(populasyon, XEgitim, yEgitim, XTest, yTest);

    % O nesildeki en iyi sonucu takip et
    [nesilEnIyiMSE, nesilEnIyiIndeks] = min(mseDegerleri);
    if nesilEnIyiMSE < enIyiMSE
        enIyiMSE = nesilEnIyiMSE;
        enIyiKromozom = populasyon(nesilEnIyiIndeks, :);
    end
    enIyiMSEGecmisi(nesil) = enIyiMSE;

    fprintf('Nesil %3d/%3d | En Iyi MSE: %.6f | Secili Ozellik Sayisi: %d\n', ...
        nesil, maksimumNesil, enIyiMSE, sum(enIyiKromozom));

    % Minimizasyon icin ters MSE ile rulet secim olasiliklari
    tersMSE = 1 ./ (mseDegerleri + eps);
    toplamUygunluk = sum(tersMSE);
    if ~isfinite(toplamUygunluk) || toplamUygunluk <= 0
        secimOlasiliklari = ones(populasyonBoyutu, 1) / populasyonBoyutu;
    else
        secimOlasiliklari = tersMSE / toplamUygunluk;
    end

    % Elitizm: mevcut neslin en iyi kromozomunu aynen tasi
    yeniPopulasyon = zeros(size(populasyon));
    yeniPopulasyon(1, :) = populasyon(nesilEnIyiIndeks, :);

    % Kalan bireyleri uret
    for k = 2:2:populasyonBoyutu
        ebeveyn1 = populasyon(roulette_wheel_selection(secimOlasiliklari), :);
        ebeveyn2 = populasyon(roulette_wheel_selection(secimOlasiliklari), :);

        % Tek nokta / iki nokta caprazlama
        if rand < caprazlamaOrani
            [cocuk1, cocuk2] = crossover_operator(ebeveyn1, ebeveyn2);
        else
            cocuk1 = ebeveyn1;
            cocuk2 = ebeveyn2;
        end

        % Bit cevirme mutasyonu
        cocuk1 = mutate_operator(cocuk1, mutasyonOrani);
        cocuk2 = mutate_operator(cocuk2, mutasyonOrani);

        % Gecerli kromozom garanti et (en az bir ozellik secili olsun)
        cocuk1 = enforce_nonempty(cocuk1);
        cocuk2 = enforce_nonempty(cocuk2);

        yeniPopulasyon(k, :) = cocuk1;
        if k + 1 <= populasyonBoyutu
            yeniPopulasyon(k + 1, :) = cocuk2;
        end
    end

    populasyon = yeniPopulasyon;
end

%% Nihai Sonuclar
secilenOzellikler = find(enIyiKromozom == 1);
fprintf('\nNihai En Iyi MSE: %.6f\n', enIyiMSE);
fprintf('Secilen ozellik sayisi: %d\n', numel(secilenOzellikler));
fprintf('Secilen ozellik indeksleri: ');
disp(secilenOzellikler);

%% Yakinsama Grafigi
figure('Color', 'w');
plot(1:maksimumNesil, enIyiMSEGecmisi, 'b-', 'LineWidth', 2);
xlabel('Nesil');
ylabel('En Iyi MSE (simdiye kadarki en iyi)');
title('GA Yakinsama - Ionosphere Ozellik Secimi');
grid on;


%% Yerel fonksiyonlar
function populasyon = initialize_population(populasyonBoyutu, ozellikSayisi)
% Rastgele ikili populasyon; her satir bir kromozomu temsil eder.
    populasyon = double(rand(populasyonBoyutu, ozellikSayisi) > 0.5);

    % Bos kromozom olmasini engelle
    bosSatirlar = find(sum(populasyon, 2) == 0);
    for i = 1:numel(bosSatirlar)
        populasyon(bosSatirlar(i), randi(ozellikSayisi)) = 1;
    end
end


function mseDegerleri = evaluate_population(populasyon, XEgitim, yEgitim, XTest, yTest)
% Populasyondaki her kromozom icin test MSE degerini hesapla.
    populasyonBoyutu = size(populasyon, 1);
    mseDegerleri = zeros(populasyonBoyutu, 1);

    for i = 1:populasyonBoyutu
        mseDegerleri(i) = fitness_function(populasyon(i, :), XEgitim, yEgitim, XTest, yTest);
    end
end


function mse = fitness_function(kromozom, XEgitim, yEgitim, XTest, yTest)
% Secilen ozelliklerle lineer regresyon egit ve test MSE degerini don.
    secili = logical(kromozom);
    if ~any(secili)
        mse = 1e6;
        return;
    end

    XEgitimSecili = XEgitim(:, secili);
    XTestSecili = XTest(:, secili);

    XEgitimArtirilmis = [ones(size(XEgitimSecili, 1), 1), XEgitimSecili];
    XTestArtirilmis = [ones(size(XTestSecili, 1), 1), XTestSecili];

    % Secili ozellikler dogrusal bagimli oldugunda rank-deficient
    % uyarisini onlemek icin kucuk bir ridge terimi kullan.
    ridgeKatsayisi = 1e-6;
    gramMatrisi = XEgitimArtirilmis' * XEgitimArtirilmis;
    sagTaraf = XEgitimArtirilmis' * yEgitim;
    katsayilar = (gramMatrisi + ridgeKatsayisi * eye(size(gramMatrisi))) \ sagTaraf;
    yTahmin = XTestArtirilmis * katsayilar;

    % Etiket tutarliligi icin tahminleri [0,1] araliginda tut
    yTahmin = min(max(yTahmin, 0), 1);

    hata = yTest - yTahmin;
    mse = mean(hata .^ 2);

    if ~isfinite(mse)
        mse = 1e6;
    end
end


function indeks = roulette_wheel_selection(olasiliklar)
% Rulet tekeri olasiliklarina gore bir indeks sec.
    birikimliOlasilik = cumsum(olasiliklar(:));
    rastgeleDeger = rand;
    indeks = find(birikimliOlasilik >= rastgeleDeger, 1, 'first');
    if isempty(indeks)
        indeks = numel(olasiliklar);
    end
end


function [cocuk1, cocuk2] = crossover_operator(ebeveyn1, ebeveyn2)
% Indeks tutarliligi ile tek nokta veya iki nokta caprazlama.
    genSayisi = numel(ebeveyn1);

    if genSayisi < 2
        cocuk1 = ebeveyn1;
        cocuk2 = ebeveyn2;
        return;
    end

    if genSayisi < 3 || rand < 0.5
        % Tek nokta caprazlama
        caprazlamaNoktasi = randi([1, genSayisi - 1]);
        cocuk1 = [ebeveyn1(1:caprazlamaNoktasi), ebeveyn2(caprazlamaNoktasi + 1:end)];
        cocuk2 = [ebeveyn2(1:caprazlamaNoktasi), ebeveyn1(caprazlamaNoktasi + 1:end)];
    else
        % Iki nokta caprazlama
        caprazlamaNoktalari = sort(randperm(genSayisi - 1, 2));
        nokta1 = caprazlamaNoktalari(1);
        nokta2 = caprazlamaNoktalari(2);
        cocuk1 = [ebeveyn1(1:nokta1), ebeveyn2(nokta1 + 1:nokta2), ebeveyn1(nokta2 + 1:end)];
        cocuk2 = [ebeveyn2(1:nokta1), ebeveyn1(nokta1 + 1:nokta2), ebeveyn2(nokta2 + 1:end)];
    end
end


function mutasyonaUgramis = mutate_operator(kromozom, mutasyonOrani)
% Her gen icin mutasyonOrani olasilikla bit cevirme mutasyonu uygula.
    mutasyonMaskesi = rand(size(kromozom)) < mutasyonOrani;
    mutasyonaUgramis = double(xor(logical(kromozom), mutasyonMaskesi));
end


function kromozom = enforce_nonempty(kromozom)
% Kromozomda en az bir ozellik secili olmasini garanti et.
    if ~any(kromozom)
        kromozom(randi(numel(kromozom))) = 1;
    end
end


function y = labels_to_numeric(etiketler)
% Etiketleri ikili sayisal degere cevir: g -> 1, b -> 0.
    if isnumeric(etiketler) || islogical(etiketler)
        y = double(etiketler(:));
        if ~all(ismember(unique(y), [0, 1]))
            y = double(y == max(y));
        end
        return;
    end

    if iscell(etiketler)
        etiketMetni = string(etiketler(:));
    elseif isstring(etiketler)
        etiketMetni = etiketler(:);
    elseif ischar(etiketler)
        etiketMetni = string(cellstr(etiketler));
    elseif iscategorical(etiketler)
        etiketMetni = string(etiketler(:));
    else
        error('Y icin desteklenmeyen etiket turu.');
    end

    y = double(strcmpi(etiketMetni, "g"));
end
