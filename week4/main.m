%% Genetik Algoritma ile Özellik Seçimi (sıfırdan)
% Veri kümesi: MATLAB yerleşik 'ionosphere'
% Amaç: Seçilen özelliklerle lineer regresyon kullanarak test MSE'sini en aza indirmek

clear;
clc;
close all;

rng(42); % Tekrarlanabilirlik

% Week3 ile aynı yazım yaklaşımı için gerekli değişkenler global taşınıyor.
global X Y y ornekSayisi ozellikSayisi egitimOrnekSayisi egitimIndeksleri testIndeksleri
global XEgitim yEgitim XTest yTest populasyonBoyutu maksimumNesil caprazlamaOrani mutasyonOrani
global populasyon enIyiMSE enIyiKromozom enIyiMSEGecmisi secimOlasiliklari

%% Aşama 1: Veri Hazırlama
load ionosphere; % Beklenen değişkenler: X (örnek x 34), Y etiketleri ('g'/'b')

if ~exist('X', 'var') || ~exist('Y', 'var')
    error('Ionosphere veri kümesi doğru yüklenemedi. X ve Y değişkenleri bekleniyor.');
end

y = etiketleri_sayisala_cevir; % Etiketleri sayısala çevir: g->1, b->0

ornekSayisi = size(X, 1);
ozellikSayisi = size(X, 2);

% Eğitim/Test bölmesi: 70/30
karisikIndeksler = randperm(ornekSayisi);
egitimOrnekSayisi = round(0.70 * ornekSayisi);
egitimIndeksleri = karisikIndeksler(1:egitimOrnekSayisi);
testIndeksleri = karisikIndeksler(egitimOrnekSayisi + 1:end);

XEgitim = X(egitimIndeksleri, :);
yEgitim = y(egitimIndeksleri);
XTest = X(testIndeksleri, :);
yTest = y(testIndeksleri);

%% Aşama 2: GA Çekirdek Ayarları
populasyonBoyutu = 60;
maksimumNesil = 100;
caprazlamaOrani = 0.85;
mutasyonOrani = 0.03;

populasyon = populasyon_baslat;

enIyiMSE = inf;
enIyiKromozom = populasyon(1, :);
enIyiMSEGecmisi = zeros(maksimumNesil, 1);

%% Aşama 3-4: Ana GA Döngüsü (Seçim, Çaprazlama, Mutasyon, Elitizm)
for nesil = 1:maksimumNesil
    % Her kromozomu seçilen özelliklerle eğitip/tahmin ederek değerlendir
    mseDegerleri = populasyonu_degerlendir;

    % O nesildeki en iyi sonucu takip et
    [nesilEnIyiMSE, nesilEnIyiIndeks] = min(mseDegerleri);
    if nesilEnIyiMSE < enIyiMSE
        enIyiMSE = nesilEnIyiMSE;
        enIyiKromozom = populasyon(nesilEnIyiIndeks, :);
    end
    enIyiMSEGecmisi(nesil) = enIyiMSE;

    fprintf('Nesil %3d/%3d | En İyi MSE: %.6f | Seçili Özellik Sayısı: %d\n', ...
        nesil, maksimumNesil, enIyiMSE, sum(enIyiKromozom));

    % Minimizasyon için ters MSE ile rulet seçim olasılıkları
    tersMSE = 1 ./ (mseDegerleri + eps);
    toplamUygunluk = sum(tersMSE);
    if ~isfinite(toplamUygunluk) || toplamUygunluk <= 0
        secimOlasiliklari = ones(populasyonBoyutu, 1) / populasyonBoyutu;
    else
        secimOlasiliklari = tersMSE / toplamUygunluk;
    end

    % Elitizm: mevcut neslin en iyi kromozomunu aynen taşı
    yeniPopulasyon = zeros(size(populasyon));
    yeniPopulasyon(1, :) = populasyon(nesilEnIyiIndeks, :);

    % Kalan bireyleri üret
    for k = 2:2:populasyonBoyutu
        ebeveyn1 = populasyon(rulet_secimi, :);
        ebeveyn2 = populasyon(rulet_secimi, :);

        % Tek nokta / iki nokta çaprazlama
        if rand < caprazlamaOrani
            [cocuk1, cocuk2] = caprazlama_operatoru(ebeveyn1, ebeveyn2);
        else
            cocuk1 = ebeveyn1;
            cocuk2 = ebeveyn2;
        end

        % Bit çevirme mutasyonu
        cocuk1 = mutasyon_operatoru(cocuk1);
        cocuk2 = mutasyon_operatoru(cocuk2);

        % Geçerli kromozom garanti et (en az bir özellik seçili olsun)
        cocuk1 = bos_olmayan_kromozom(cocuk1);
        cocuk2 = bos_olmayan_kromozom(cocuk2);

        yeniPopulasyon(k, :) = cocuk1;
        if k + 1 <= populasyonBoyutu
            yeniPopulasyon(k + 1, :) = cocuk2;
        end
    end

    populasyon = yeniPopulasyon;
end

%% Nihai Sonuçlar
secilenOzellikler = find(enIyiKromozom == 1);
fprintf('\nNihai En İyi MSE: %.6f\n', enIyiMSE);
fprintf('Seçilen özellik sayısı: %d\n', numel(secilenOzellikler));
fprintf('Seçilen özellik indeksleri: ');
disp(secilenOzellikler);

%% Yakınsama Grafiği
figure('Color', 'w');
plot(1:maksimumNesil, enIyiMSEGecmisi, 'b-', 'LineWidth', 2);
xlabel('Nesil');
ylabel('En İyi MSE (şimdiye kadarki en iyi)');
title('GA Yakınsama - Ionosphere Özellik Seçimi');
grid on;
