clc; clear all;
%% Veri Okuma
veri = readmatrix('veri_y.xlsx');
% Sütunları görevlerine göre ayır
input_data = veri(:, 1:2);
output_gercek = veri(:, 3);
% Veri sayısını otomatik belirle
veri_sayisi = size(input_data, 1);

%% Parametreler ve Popülasyon Başlangıcı
n=20; m=7;
sinir_alt1=52; sinir_ust1=77;
sinir_alt2=3.72;  sinir_ust2=21.74;
sinir_alt3=0.8;  sinir_ust3=3;

% Popülasyon oluşturma
for i=1:n
    x(i,:) = sort(unifrnd(sinir_alt1, sinir_ust1, 1, m));
    y(i,:) = sort(unifrnd(sinir_alt2, sinir_ust2, 1, m));
    z(i,:) = sort(unifrnd(sinir_alt3, sinir_ust3, 1, m));
end

% Oluşturulan FIS objelerini saklamak için hücre dizisi (Cell Array)
fis_populasyonu = cell(n, 1);
tahmin_sonuc = zeros(n, veri_sayisi);
fitness = zeros(n, 1);

%% Popülasyonu FIS'e yerleştirme döngüsü
for i=1:n
    % 1. FIS Objesini Oluştur
    a = mamfis('Name', 'bulanik');
    
    % 2. INPUT 1 Ekle (addInput)
    a = addInput(a, [sinir_alt1 sinir_ust1], 'Name', 'INPUT1');
    a = addMF(a, 'INPUT1', 'trimf', [sinir_alt1, x(i,1), x(i,3)], 'Name', 'Düşük');
    a = addMF(a, 'INPUT1', 'trimf', [x(i,2), x(i,4), x(i,6)], 'Name', 'Orta');
    a = addMF(a, 'INPUT1', 'trimf', [x(i,5), x(i,7), sinir_ust1], 'Name', 'Yüksek');
    
    % 3. INPUT 2 Ekle (addInput)
    a = addInput(a, [sinir_alt2 sinir_ust2], 'Name', 'INPUT2');
    a = addMF(a, 'INPUT2', 'trimf', [sinir_alt2, y(i,1), y(i,3)], 'Name', 'Düşük');
    a = addMF(a, 'INPUT2', 'trimf', [y(i,2), y(i,4), y(i,6)], 'Name', 'Orta');
    a = addMF(a, 'INPUT2', 'trimf', [y(i,5), y(i,7), sinir_ust2], 'Name', 'Yüksek');
    
    % 4. CİKİS Ekle (addOutput)
    a = addOutput(a, [sinir_alt3 sinir_ust3], 'Name', 'CİKİS');
    a = addMF(a, 'CİKİS', 'trimf', [sinir_alt3, z(i,1), z(i,3)], 'Name', 'Düşük');
    a = addMF(a, 'CİKİS', 'trimf', [z(i,2), z(i,4), z(i,6)], 'Name', 'Orta');
    a = addMF(a, 'CİKİS', 'trimf', [z(i,5), z(i,7), sinir_ust3], 'Name', 'Yüksek');
    
    % 5. Kuralları Ekle (addRule)
    ruleList=[ ...
    1 1 1 1 1
    1 3 3 1 1
    2 2 1 1 1
    3 2 3 1 1
    3 3 2 1 1];
    a = addRule(a, ruleList);
    
    % FIS objesini hafızaya kaydet
    fis_populasyonu{i} = a;
    
    % 6. Tahmin Hesaplama
    for k = 1:veri_sayisi 
        tahmin_sonuc(i, k) = evalfis(a, input_data(k, :));
    end
    
    % 7. Bireyin hatasını hesapla (MSE)
    hata_vektoru = abs(output_gercek' - tahmin_sonuc(i, :));
    fitness(i) = sum(hata_vektoru); % Bu değer ne kadar küçükse birey o kadar iyi
end

%% En İyi Bireyi Bulma ve Görselleştirme
[en_iyi_hata, en_iyi_indis] = min(fitness);
fprintf('En başarılı birey: %d. birey\n', en_iyi_indis);
fprintf('Minimum Hata (MSE): %.4f\n', en_iyi_hata);

% En iyi FIS objesini çek
en_iyi_fis = fis_populasyonu{en_iyi_indis};

% Grafikleri Çizdir (subplot ile 3 grafiği alt alta gösterelim)
figure('Name', 'En İyi Bireyin Üyelik Fonksiyonları', 'Position', [100, 100, 800, 600]);

subplot(3, 1, 1);
plotmf(en_iyi_fis, 'input', 1);
title(sprintf('INPUT 1 (En İyi %d. Birey)', en_iyi_indis));

subplot(3, 1, 2);
plotmf(en_iyi_fis, 'input', 2);
title(sprintf('INPUT 2 (En İyi %d. Birey)', en_iyi_indis));

subplot(3, 1, 3);
plotmf(en_iyi_fis, 'output', 1);
title(sprintf('ÇIKIŞ (En İyi %d. Birey)', en_iyi_indis));

%% Seleksiyon

%% Çaprazlama

%% Mutasyon