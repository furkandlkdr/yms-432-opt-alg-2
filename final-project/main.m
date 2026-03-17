%% =========================================================================
% CLONALG Hiperparametre Optimizasyonu Sistemi
% =========================================================================
% Bu script, CLONALG (Klonlama Seçilimi Algoritması) kullanarak 
% 3 farklı makine öğrenmesi modelinin hiperparametrelerini optimize eder.
% 
% Modeller:
%   1. Destek Vektör Makineleri (SVM)
%   2. Rastgele Orman (Random Forest)
%   3. Çok Katmanlı Algılayıcı (MLP)
%
% Veri Seti: Breast Cancer Wisconsin
% =========================================================================

clear all; close all; clc;

% Global parametreler (gerekli olursa)
global X_train y_train;

fprintf('\n');
fprintf('╔══════════════════════════════════════════════════════════╗\n');
fprintf('║  CLONALG HIPERPARAMETRESİ OPTİMİZASYON SİSTEMİ          ║\n');
fprintf('║  Breast Cancer Wisconsin Veri Seti                     ║\n');
fprintf('╚══════════════════════════════════════════════════════════╝\n\n');

% ==================== ADİM 1: VERİ HAZIRLAMA ====================
fprintf('--- Veri Hazırlama ---\n');

% Veri setini yükle
[X, y] = veri_yukle();

% Normalizasyon yap
X_normalized = normalize_veriler(X);

% Eğitim ve test verisi ayır (%80-%20)
n_samples = size(X_normalized, 1);
train_idx = randperm(n_samples, floor(n_samples * 0.8));
test_idx = setdiff(1:n_samples, train_idx);

X_train = X_normalized(train_idx, :);
y_train = y(train_idx, :);
X_test = X_normalized(test_idx, :);
y_test = y(test_idx, :);

fprintf('Eğitim Seti: %d örnek\n', size(X_train, 1));
fprintf('Test Seti: %d örnek\n\n', size(X_test, 1));

% ==================== ADİM 2: CLONALG PARAMETRELERI ====================
% CLONALG için genel parametreler
pop_buyut = 30;        % Popülasyon büyüklüğü
n_secilecek = 12;      % Seçilecek antikor sayısı
beta = 1.0;            % Klon çarpanı
rho = 0.5;             % Mutasyon sabiti
d = 5;                 % Çeşitlilik koruma (değiştirilecek antikor sayısı)
max_iterasyon = 30;    % Maksimum iterasyon sayısı

% Sonuçların tutulacağı yerde
sonuclar = struct();
surej_baslangic = tic;

% ==================== ADİM 3: SVM OPTIMIZASYONU ====================
fprintf('--- SVM Hiperparametre Optimizasyonu Başlatıldı ---\n');
fprintf('Parametreler:\n');
fprintf('  BoxConstraint (C): [0.01, 100] (logaritmik)\n');
fprintf('  KernelFunction: {linear, rbf, polynomial}\n');
fprintf('  KernelScale (Gamma): [0.001, 10]\n\n');

surej_svm_baslangic = tic;
[svm_en_iyi, svm_en_iyi_afinite, svm_afinite_gecmisi] = clonalg_algoritma(...
    X_train, y_train, 'svm', pop_buyut, n_secilecek, beta, rho, d, max_iterasyon);
surej_svm = toc(surej_svm_baslangic);

sonuclar.svm.en_iyi_hiperparametre = svm_en_iyi;
sonuclar.svm.en_iyi_afinite = svm_en_iyi_afinite;
sonuclar.svm.afinite_gecmisi = svm_afinite_gecmisi;
sonuclar.svm.sure = surej_svm;

fprintf('SVM Optimizasyonu Tamamlandı - Süre: %.2f saniye\n', surej_svm);
fprintf('En İyi Afinite: %.4f\n\n', svm_en_iyi_afinite);

% ==================== ADİM 4: RANDOM FOREST OPTIMIZASYONU ====================
fprintf('--- Random Forest Hiperparametre Optimizasyonu Başlatıldı ---\n');
fprintf('Parametreler:\n');
fprintf('  NumTrees: [10, 200]\n');
fprintf('  MinLeafSize: [1, 20]\n\n');

surej_rf_baslangic = tic;
[rf_en_iyi, rf_en_iyi_afinite, rf_afinite_gecmisi] = clonalg_algoritma(...
    X_train, y_train, 'rf', pop_buyut, n_secilecek, beta, rho, d, max_iterasyon);
surej_rf = toc(surej_rf_baslangic);

sonuclar.rf.en_iyi_hiperparametre = rf_en_iyi;
sonuclar.rf.en_iyi_afinite = rf_en_iyi_afinite;
sonuclar.rf.afinite_gecmisi = rf_afinite_gecmisi;
sonuclar.rf.sure = surej_rf;

fprintf('Random Forest Optimizasyonu Tamamlandı - Süre: %.2f saniye\n', surej_rf);
fprintf('En İyi Afinite: %.4f\n\n', rf_en_iyi_afinite);

% ==================== ADİM 5: MLP OPTIMIZASYONU ====================
fprintf('--- MLP Hiperparametre Optimizasyonu Başlatıldı ---\n');
fprintf('Parametreler:\n');
fprintf('  LayerSizes: [10, 100]\n');
fprintf('  Activation: {relu, tanh, sigmoid}\n');
fprintf('  InitialLearnRate: [0.0001, 0.1] (logaritmik)\n\n');

surej_mlp_baslangic = tic;
[mlp_en_iyi, mlp_en_iyi_afinite, mlp_afinite_gecmisi] = clonalg_algoritma(...
    X_train, y_train, 'mlp', pop_buyut, n_secilecek, beta, rho, d, max_iterasyon);
surej_mlp = toc(surej_mlp_baslangic);

sonuclar.mlp.en_iyi_hiperparametre = mlp_en_iyi;
sonuclar.mlp.en_iyi_afinite = mlp_en_iyi_afinite;
sonuclar.mlp.afinite_gecmisi = mlp_afinite_gecmisi;
sonuclar.mlp.sure = surej_mlp;

fprintf('MLP Optimizasyonu Tamamlandı - Süre: %.2f saniye\n', surej_mlp);
fprintf('En İyi Afinite: %.4f\n\n', mlp_en_iyi_afinite);

% ==================== ADİM 6: SONUÇLAR ====================
surej_toplam = toc(surej_baslangic);

fprintf('\n');
fprintf('╔══════════════════════════════════════════════════════════╗\n');
fprintf('║                    SONUÇLAR ÖZETI                        ║\n');
fprintf('╚══════════════════════════════════════════════════════════╝\n\n');

fprintf('MODEL          | EN İYİ AFFİNİTE | SURE (sn) | EN İYİ PARAMETRE\n');
fprintf('---            | ---              | ---       | ---\n');
fprintf('SVM            | %.4f            | %.2f     | \n', svm_en_iyi_afinite, surej_svm);
fprintf('               | C=%.4f, K=%s, G=%.4f\n', ...
    svm_en_iyi.BoxConstraint, svm_en_iyi.KernelFunction, svm_en_iyi.KernelScale);
fprintf('Random Forest  | %.4f            | %.2f     | \n', rf_en_iyi_afinite, surej_rf);
fprintf('               | Trees=%d, MinLeaf=%d\n', rf_en_iyi.NumTrees, rf_en_iyi.MinLeafSize);
fprintf('MLP            | %.4f            | %.2f     | \n', mlp_en_iyi_afinite, surej_mlp);
fprintf('               | LS=%d, A=%s, LR=%.6f\n', ...
    mlp_en_iyi.LayerSizes, mlp_en_iyi.Activation, mlp_en_iyi.InitialLearnRate);
fprintf('\nToplam Süre: %.2f saniye\n\n', surej_toplam);

% ==================== ADİM 7: GÖRSEL RAPOR ====================
figure('Name', 'CLONALG Yakınsama Analizi', 'NumberTitle', 'off', 'Position', [100 100 1000 800]);

% SVM Yakınsama
subplot(2, 3, 1);
plot(svm_afinite_gecmisi, 'b-', 'LineWidth', 2);
grid on;
xlabel('İterasyon');
ylabel('Afinite (F1-Score)');
title(sprintf('SVM Yakınsama\nEn İyi: %.4f', svm_en_iyi_afinite));
ylim([0 1]);

% Random Forest Yakınsama
subplot(2, 3, 2);
plot(rf_afinite_gecmisi, 'g-', 'LineWidth', 2);
grid on;
xlabel('İterasyon');
ylabel('Afinite (F1-Score)');
title(sprintf('Random Forest Yakınsama\nEn İyi: %.4f', rf_en_iyi_afinite));
ylim([0 1]);

% MLP Yakınsama
subplot(2, 3, 3);
plot(mlp_afinite_gecmisi, 'r-', 'LineWidth', 2);
grid on;
xlabel('İterasyon');
ylabel('Afinite (F1-Score)');
title(sprintf('MLP Yakınsama\nEn İyi: %.4f', mlp_en_iyi_afinite));
ylim([0 1]);

% Karşılaştırmalı Grafik
subplot(2, 3, 4);
en_iyi_afniteler = [svm_en_iyi_afinite, rf_en_iyi_afinite, mlp_en_iyi_afinite];
bar(en_iyi_afniteler, 'FaceColor', [0.2 0.4 0.8], 'EdgeColor', 'black');
set(gca, 'XTickLabel', {'SVM', 'RF', 'MLP'});
ylabel('Afinite (F1-Score)');
title('Model Performans Karşılaştırması');
ylim([0 1]);
grid on;

% Hesaplama Süresi
subplot(2, 3, 5);
sureler = [surej_svm, surej_rf, surej_mlp];
bar(sureler, 'FaceColor', [0.8 0.4 0.2], 'EdgeColor', 'black');
set(gca, 'XTickLabel', {'SVM', 'RF', 'MLP'});
ylabel('Süre (saniye)');
title('Optimizasyon Süresi Karşılaştırması');
grid on;

% Bilgi Paneli
subplot(2, 3, 6);
axis off;
info_text = sprintf([...
    'CLONALG Hiperparametre Optimizasyonu\n'...
    '=====================================\n\n'...
    'Veri Seti: Breast Cancer Wisconsin\n'...
    'Eğitim Seti: %d örnek\n'...
    'Test Seti: %d örnek\n\n'...
    'CLONALG Parametreleri:\n'...
    '  Popülasyon: %d\n'...
    '  Seçilecek: %d\n'...
    '  İterasyon: %d\n'...
    '  β (Klon Çarpanı): %.1f\n'...
    '  ρ (Mutasyon): %.1f\n\n'...
    'Değerlendirme: 5-Fold CV\n'...
    'Metrik: Makro F1-Score\n'], ...
    size(X_train, 1), size(X_test, 1), pop_buyut, n_secilecek, max_iterasyon, beta, rho);
text(0.05, 0.95, info_text, 'VerticalAlignment', 'top', 'FontFamily', 'monospace', ...
    'FontSize', 10, 'FontWeight', 'bold');

sgtitle('CLONALG Hiperparametre Optimizasyonu Sonuçları', 'FontSize', 14, 'FontWeight', 'bold');

% Grafiği kaydet
print(gcf, 'clonalg_sonuclar.png', '-dpng', '-r150');
fprintf('Grafik kaydedildi: clonalg_sonuclar.png\n\n');

% ==================== ADİM 8: DEĞERLENDİRİLEBİLİR UYARI ====================
fprintf('\n--- OPTİMİZASYON TERCİH ÖNERISI ---\n');

% En iyi modeli belirle
[~, en_iyi_model_idx] = max([svm_en_iyi_afinite, rf_en_iyi_afinite, mlp_en_iyi_afinite]);
model_isimleri = {'SVM', 'Random Forest', 'MLP'};
fprintf('En başarılı model: %s (F1 = %.4f)\n\n', model_isimleri{en_iyi_model_idx}, ...
    max([svm_en_iyi_afinite, rf_en_iyi_afinite, mlp_en_iyi_afinite]));

fprintf('Sistem Önerileri:\n');
fprintf('  1. Hiperparametre otimizasyonu başarıyla tamamlandı.\n');
fprintf('  2. Bulunun en iyi parametreler test seti üzerinde değerlendirilmelidir.\n');
fprintf('  3. Çeşitlilik sağlanması için tüm modeller birlikte ensemble kullanılabilir.\n');
fprintf('  4. Daha fazla iterasyon veya daha geniş parametre alanı denenenebilir.\n\n');

fprintf('╔══════════════════════════════════════════════════════════╗\n');
fprintf('║                 PROGRAM BAŞARI İLE TERMAMSıNDI           ║\n');
fprintf('╚══════════════════════════════════════════════════════════╝\n\n');

% ==================== DEBUG/SAVE ====================
% Sonuçları kaydet
save('clonalg_optimizasyon_sonuclari.mat', 'sonuclar', '-v7.3');
fprintf('Sonuçlar kaydedildi: clonalg_optimizasyon_sonuclari.mat\n');
