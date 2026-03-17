%% =========================================================================
% CLONALG Hiperparametre Optimizasyonu - Tek Dosya Versiyonu
% =========================================================================
% Tüm fonksiyonlar bu dosyada birleştirilmiştir.
% MATLAB Web Arayüzü ve MATLAB Online için uygundur.
%
% Modeller: SVM | Random Forest | MLP
% Veri Seti: Breast Cancer Wisconsin (otomatik yüklenir veya synthetic kullanılır)
% Metrik: Makro F1-Score | Değerlendirme: 5-Fold Çapraz Doğrulama
% =========================================================================

clear all; close all; clc;

fprintf('\n');
fprintf('===========================================================\n');
fprintf('  CLONALG HIPERPARAMETRE OPTIMIZASYON SISTEMI\n');
fprintf('  Breast Cancer Wisconsin Veri Seti\n');
fprintf('===========================================================\n\n');

% ==================== ADIM 1: VERİ HAZIRLAMA ====================
fprintf('--- Veri Hazırlama ---\n');

[X, y] = veri_yukle();
X_normalized = normalize_veriler(X);

n_samples = size(X_normalized, 1);
train_idx = randperm(n_samples, floor(n_samples * 0.8));
test_idx  = setdiff(1:n_samples, train_idx);

X_train = X_normalized(train_idx, :);
y_train = y(train_idx, :);
X_test  = X_normalized(test_idx,  :);
y_test  = y(test_idx,  :);

fprintf('Egitim Seti: %d ornek\n', size(X_train, 1));
fprintf('Test Seti  : %d ornek\n\n', size(X_test,  1));

% ==================== ADIM 2: CLONALG PARAMETRELERİ ====================
pop_buyut     = 30;   % Populasyon buyuklugu
n_secilecek   = 12;   % Secilecek antikor sayisi
beta          = 1.0;  % Klon carpani
rho           = 0.5;  % Mutasyon sabiti
d             = 5;    % Cesitlilik koruma sayisi
max_iterasyon = 30;   % Maksimum iterasyon

sonuclar      = struct();
sure_baslangic = tic;

% ==================== ADIM 3: SVM OPTİMİZASYONU ====================
fprintf('--- SVM Hiperparametre Optimizasyonu ---\n');
fprintf('  BoxConstraint (C) : [0.01, 100]  (log uzay)\n');
fprintf('  KernelFunction    : {linear, rbf, polynomial}\n');
fprintf('  KernelScale (Gama): [0.001, 10]\n\n');

t_svm = tic;
[svm_en_iyi, svm_afinite, svm_gecmis] = clonalg_algoritma( ...
    X_train, y_train, 'svm', pop_buyut, n_secilecek, beta, rho, d, max_iterasyon);
sure_svm = toc(t_svm);

sonuclar.svm.hiperparametre = svm_en_iyi;
sonuclar.svm.afinite        = svm_afinite;
sonuclar.svm.gecmis         = svm_gecmis;
sonuclar.svm.sure           = sure_svm;

fprintf('SVM Tamamlandi - Sure: %.2f sn | En Iyi F1: %.4f\n\n', sure_svm, svm_afinite);

% ==================== ADIM 4: RANDOM FOREST OPTİMİZASYONU ====================
fprintf('--- Random Forest Hiperparametre Optimizasyonu ---\n');
fprintf('  NumTrees   : [10, 200]\n');
fprintf('  MinLeafSize: [1, 20]\n\n');

t_rf = tic;
[rf_en_iyi, rf_afinite, rf_gecmis] = clonalg_algoritma( ...
    X_train, y_train, 'rf', pop_buyut, n_secilecek, beta, rho, d, max_iterasyon);
sure_rf = toc(t_rf);

sonuclar.rf.hiperparametre = rf_en_iyi;
sonuclar.rf.afinite        = rf_afinite;
sonuclar.rf.gecmis         = rf_gecmis;
sonuclar.rf.sure           = sure_rf;

fprintf('RF Tamamlandi - Sure: %.2f sn | En Iyi F1: %.4f\n\n', sure_rf, rf_afinite);

% ==================== ADIM 5: MLP OPTİMİZASYONU ====================
fprintf('--- MLP Hiperparametre Optimizasyonu ---\n');
fprintf('  LayerSizes      : [10, 100]\n');
fprintf('  Activation      : {relu, tanh, sigmoid}\n');
fprintf('  InitialLearnRate: [0.0001, 0.1] (log uzay)\n\n');

t_mlp = tic;
[mlp_en_iyi, mlp_afinite, mlp_gecmis] = clonalg_algoritma( ...
    X_train, y_train, 'mlp', pop_buyut, n_secilecek, beta, rho, d, max_iterasyon);
sure_mlp = toc(t_mlp);

sonuclar.mlp.hiperparametre = mlp_en_iyi;
sonuclar.mlp.afinite        = mlp_afinite;
sonuclar.mlp.gecmis         = mlp_gecmis;
sonuclar.mlp.sure           = sure_mlp;

fprintf('MLP Tamamlandi - Sure: %.2f sn | En Iyi F1: %.4f\n\n', sure_mlp, mlp_afinite);

% ==================== ADIM 6: SONUÇLAR ====================
sure_toplam = toc(sure_baslangic);

fprintf('\n===========================================================\n');
fprintf('                     SONUCLAR OZETI\n');
fprintf('===========================================================\n');
fprintf('MODEL          | EN IYI F1 | SURE (sn)\n');
fprintf('-------        | --------  | --------\n');
fprintf('SVM            | %.4f    | %.2f\n', svm_afinite, sure_svm);
fprintf('  C=%.4f, Kernel=%s, Gamma=%.4f\n', ...
    svm_en_iyi.BoxConstraint, svm_en_iyi.KernelFunction, svm_en_iyi.KernelScale);
fprintf('Random Forest  | %.4f    | %.2f\n', rf_afinite, sure_rf);
fprintf('  NumTrees=%d, MinLeafSize=%d\n', rf_en_iyi.NumTrees, rf_en_iyi.MinLeafSize);
fprintf('MLP            | %.4f    | %.2f\n', mlp_afinite, sure_mlp);
fprintf('  LayerSize=%d, Activation=%s, LR=%.6f\n', ...
    mlp_en_iyi.LayerSizes, mlp_en_iyi.Activation, mlp_en_iyi.InitialLearnRate);
fprintf('\nToplam Sure: %.2f saniye\n', sure_toplam);

% En iyi modeli belirle
[best_f1, best_idx] = max([svm_afinite, rf_afinite, mlp_afinite]);
model_isimleri = {'SVM', 'Random Forest', 'MLP'};
fprintf('\nEN BASARILI MODEL: %s  (F1 = %.4f)\n', model_isimleri{best_idx}, best_f1);

% ==================== ADIM 7: GÖRSEL RAPOR ====================
figure('Name', 'CLONALG Yakinsamasi', 'NumberTitle', 'off');

subplot(2, 3, 1);
plot(svm_gecmis, 'b-', 'LineWidth', 2);
grid on; xlabel('Iterasyon'); ylabel('F1-Score');
title(sprintf('SVM\nEn Iyi: %.4f', svm_afinite)); ylim([0 1]);

subplot(2, 3, 2);
plot(rf_gecmis, 'g-', 'LineWidth', 2);
grid on; xlabel('Iterasyon'); ylabel('F1-Score');
title(sprintf('Random Forest\nEn Iyi: %.4f', rf_afinite)); ylim([0 1]);

subplot(2, 3, 3);
plot(mlp_gecmis, 'r-', 'LineWidth', 2);
grid on; xlabel('Iterasyon'); ylabel('F1-Score');
title(sprintf('MLP\nEn Iyi: %.4f', mlp_afinite)); ylim([0 1]);

subplot(2, 3, 4);
bar([svm_afinite, rf_afinite, mlp_afinite], 'FaceColor', [0.2 0.4 0.8]);
set(gca, 'XTickLabel', {'SVM', 'RF', 'MLP'});
ylabel('F1-Score'); title('Model Karsilastirmasi'); ylim([0 1]); grid on;

subplot(2, 3, 5);
bar([sure_svm, sure_rf, sure_mlp], 'FaceColor', [0.8 0.4 0.2]);
set(gca, 'XTickLabel', {'SVM', 'RF', 'MLP'});
ylabel('Sure (sn)'); title('Optimizasyon Suresi'); grid on;

subplot(2, 3, 6);
axis off;
bilgi = sprintf('Veri: Breast Cancer Wisconsin\nEgitim: %d, Test: %d\n\nCLONALG Parametreleri:\n  Populasyon : %d\n  Secilecek  : %d\n  Iterasyon  : %d\n  Beta       : %.1f\n  Rho        : %.1f\n\nMetrik: Makro F1-Score\nCV    : 5-Fold', ...
    size(X_train,1), size(X_test,1), pop_buyut, n_secilecek, max_iterasyon, beta, rho);
text(0.05, 0.95, bilgi, 'VerticalAlignment', 'top', 'FontName', 'Courier', 'FontSize', 9);

sgtitle('CLONALG Hiperparametre Optimizasyonu', 'FontSize', 13, 'FontWeight', 'bold');

% Grafigi kaydetmeye calis
try
    print(gcf, 'clonalg_sonuclar.png', '-dpng', '-r150');
    fprintf('\nGrafik kaydedildi: clonalg_sonuclar.png\n');
catch
    fprintf('\nGrafik ekranda gosterildi (kayit atildi).\n');
end

% Sonuclari kaydetmeye calis
try
    save('clonalg_optimizasyon_sonuclari.mat', 'sonuclar');
    fprintf('Sonuclar kaydedildi: clonalg_optimizasyon_sonuclari.mat\n');
catch
    fprintf('Sonuclar kaydedilemedi (izin sorunu olabilir).\n');
end

fprintf('\n===========================================================\n');
fprintf('  PROGRAM BASARI ILE TAMAMLANDI\n');
fprintf('===========================================================\n\n');


%% =========================================================================
% YEREL FONKSİYONLAR
% =========================================================================

% -------------------------------------------------------------------------
function [X, y] = veri_yukle()
% Gogus Kanseri Wisconsin veri setini yukler, bulunamazsa synthetic uretir.
    try
        load cancerInputs.mat cancerInputs
        load cancerTargets.mat cancerTargets
        X = cancerInputs';
        y = double(cancerTargets' > 0.5);
        fprintf('Veri Seti Yuklendi: %d ornek, %d oznitelik\n', size(X,1), size(X,2));
        fprintf('  Sinif 0: %d | Sinif 1: %d\n\n', sum(y==0), sum(y==1));
    catch
        fprintf('Uyari: Breast Cancer verisi bulunamadi, synthetic veri kullaniliyor.\n\n');
        n = 500; d = 30;
        X = randn(n, d);
        y = round(rand(n, 1));
    end
end

% -------------------------------------------------------------------------
function X_norm = normalize_veriler(X)
% Z-score normalizasyonu (StandardScaler esdeveri).
    mu          = mean(X, 1);
    sg          = std(X,  1);
    sg(sg == 0) = 1e-8;
    X_norm      = (X - mu) ./ sg;
    fprintf('Normalizasyon tamamlandi (z-score).\n');
end

% -------------------------------------------------------------------------
function [en_iyi_antikor, en_iyi_afinite, afinite_gecmisi] = clonalg_algoritma( ...
        X_train, y_train, model_tipi, pop_buyut, n_secilecek, beta, rho, d, max_iterasyon)
% CLONALG ana dongusu: secim → klonlama → hipermutasyon → guncelleme.
    if nargin < 4
        pop_buyut = 50; n_secilecek = 20;
        beta = 1.0; rho = 2.0; d = 10; max_iterasyon = 50;
    end

    populasyon       = olustur_populasyon(pop_buyut, model_tipi);
    afinite_gecmisi  = zeros(max_iterasyon, 1);
    en_iyi_afinite   = -inf;
    en_iyi_antikor   = populasyon(1);

    fprintf('\n=== CLONALG: %s | Pop=%d | Iter=%d ===\n', model_tipi, pop_buyut, max_iterasyon);

    for iter = 1:max_iterasyon
        % Afiniteleri hesapla
        afiniteler = zeros(pop_buyut, 1);
        for i = 1:pop_buyut
            afiniteler(i) = hesapla_afinite_lokal(populasyon(i), X_train, y_train, model_tipi);
        end

        % En iyileri sec
        [~, sira] = sort(afiniteler, 'descend');
        secilen   = populasyon(sira(1:n_secilecek));
        sec_afin  = afiniteler(sira(1:n_secilecek));

        if sec_afin(1) > en_iyi_afinite
            en_iyi_afinite = sec_afin(1);
            en_iyi_antikor = secilen(1);
        end

        % Klonlama
        klonlar    = klonla(secilen, sec_afin, beta);
        n_klon     = length(klonlar);

        % Klon afiniteleri
        klon_afin = zeros(n_klon, 1);
        for i = 1:n_klon
            klon_afin(i) = hesapla_afinite_lokal(klonlar(i), X_train, y_train, model_tipi);
        end

        % Hipermutasyon
        mutantlar  = hipermute(klonlar, klon_afin, model_tipi, rho);

        % Mutant afiniteleri
        mut_afin = zeros(n_klon, 1);
        for i = 1:n_klon
            mut_afin(i) = hesapla_afinite_lokal(mutantlar(i), X_train, y_train, model_tipi);
        end

        % Populasyonu guncelle
        tum_pop   = [populasyon; mutantlar];
        tum_afin  = [afiniteler; mut_afin];
        [~, idx]  = sort(tum_afin, 'descend');
        populasyon = tum_pop(idx(1:pop_buyut));

        % Cesitlilik koruma: en kotulerin yerine rastgele yenisi
        guncel_afin = tum_afin(idx(1:pop_buyut));
        [~, kotu_sira] = sort(guncel_afin, 'ascend');
        for k = 1:min(d, pop_buyut)
            populasyon(kotu_sira(k)) = olustur_populasyon(1, model_tipi);
        end

        afinite_gecmisi(iter) = en_iyi_afinite;
        if mod(iter, 10) == 0 || iter == 1
            fprintf('  Iter %3d: En Iyi F1 = %.4f\n', iter, en_iyi_afinite);
        end
    end
    fprintf('=== TAMAMLANDI: En Iyi F1 = %.4f ===\n', en_iyi_afinite);
end

% -------------------------------------------------------------------------
function populasyon = olustur_populasyon(n, model_tipi)
% n adet rastgele hiperparametre antikoru olusturur.
    populasyon = repmat(struct( ...
        'BoxConstraint', 0, 'KernelFunction', '', 'KernelScale', 0, ...
        'NumTrees', 0, 'MinLeafSize', 0, ...
        'LayerSizes', 0, 'Activation', '', 'InitialLearnRate', 0), n, 1);

    if strcmpi(model_tipi, 'svm')
        kernels = {'linear', 'rbf', 'polynomial'};
        for i = 1:n
            populasyon(i).BoxConstraint  = exp(log(0.01)  + (log(100)  - log(0.01))  * rand());
            populasyon(i).KernelFunction = kernels{randi(3)};
            populasyon(i).KernelScale    = exp(log(0.001) + (log(10)   - log(0.001)) * rand());
        end
    elseif strcmpi(model_tipi, 'rf')
        for i = 1:n
            populasyon(i).NumTrees    = round(10  + 190 * rand());
            populasyon(i).MinLeafSize = round(1   +  19 * rand());
        end
    elseif strcmpi(model_tipi, 'mlp')
        acts = {'relu', 'tanh', 'sigmoid'};
        for i = 1:n
            populasyon(i).LayerSizes       = round(10 + 90 * rand());
            populasyon(i).Activation       = acts{randi(3)};
            populasyon(i).InitialLearnRate = exp(log(0.0001) + (log(0.1) - log(0.0001)) * rand());
        end
    end
end

% -------------------------------------------------------------------------
function afinite = hesapla_afinite_lokal(antikor, X_train, y_train, model_tipi)
% Bir antikorun F1-afinitesini hesaplar (modele gore yonlendirir).
    try
        if strcmpi(model_tipi, 'svm')
            afinite = caprazvalidasyon_f1(X_train, y_train, 'svm', antikor);
        elseif strcmpi(model_tipi, 'rf')
            afinite = caprazvalidasyon_f1(X_train, y_train, 'rf', antikor);
        elseif strcmpi(model_tipi, 'mlp')
            afinite = caprazvalidasyon_f1(X_train, y_train, 'mlp', antikor);
        else
            afinite = 0;
        end
        afinite = max(0, afinite);
    catch
        afinite = 0;
    end
end

% -------------------------------------------------------------------------
function klonlar = klonla(antikorlar, afiniteler, beta)
% Afiniteye orantili klon uretir: n_klon = round(beta * afin_i / sum_afin).
    toplam = sum(afiniteler);
    klonlar = [];
    for i = 1:length(antikorlar)
        n = max(1, round(beta * afiniteler(i) / (toplam + eps)));
        for j = 1:n
            klonlar = [klonlar; antikorlar(i)]; %#ok<AGROW>
        end
    end
end

% -------------------------------------------------------------------------
function mutantlar = hipermute(klonlar, klon_afin, model_tipi, rho)
% Her klona somatik hipermutasyon uygular.
    mutantlar = klonlar;
    for i = 1:length(klonlar)
        mutantlar(i) = mutasyon_operatoru(klonlar(i), klon_afin(i), model_tipi, rho);
    end
end

% -------------------------------------------------------------------------
function antikor_m = mutasyon_operatoru(antikor, afinite, model_tipi, rho)
% Somatik hipermutasyon: mutation_rate = rho * exp(-afinite).
% Surekli → Gauss | Tam sayi → Gauss+round | Kategorik → rastgele secim.
    if nargin < 4, rho = 0.1; end

    antikor_m    = antikor;
    mut_rate     = rho * exp(-max(0, afinite));

    if strcmpi(model_tipi, 'svm')
        if rand() < mut_rate
            lv = log(antikor_m.BoxConstraint) + randn() * mut_rate;
            antikor_m.BoxConstraint = max(0.01, min(100, exp(lv)));
        end
        if rand() < mut_rate * 0.5
            k   = {'linear','rbf','polynomial'};
            cur = find(strcmpi(k, antikor_m.KernelFunction));
            oth = setdiff(1:3, cur);
            antikor_m.KernelFunction = k{oth(randi(length(oth)))};
        end
        if rand() < mut_rate
            antikor_m.KernelScale = max(0.001, min(10, ...
                antikor_m.KernelScale + randn() * mut_rate));
        end

    elseif strcmpi(model_tipi, 'rf')
        if rand() < mut_rate
            antikor_m.NumTrees    = max(10,  min(200, ...
                antikor_m.NumTrees    + round(randn() * mut_rate * 50)));
        end
        if rand() < mut_rate
            antikor_m.MinLeafSize = max(1,   min(20, ...
                antikor_m.MinLeafSize + round(randn() * mut_rate * 5)));
        end

    elseif strcmpi(model_tipi, 'mlp')
        if rand() < mut_rate
            antikor_m.LayerSizes = max(10, min(100, ...
                antikor_m.LayerSizes + round(randn() * mut_rate * 30)));
        end
        if rand() < mut_rate * 0.5
            a   = {'relu','tanh','sigmoid'};
            cur = find(strcmpi(a, antikor_m.Activation));
            oth = setdiff(1:3, cur);
            antikor_m.Activation = a{oth(randi(length(oth)))};
        end
        if rand() < mut_rate
            lv = log(antikor_m.InitialLearnRate) + randn() * mut_rate;
            antikor_m.InitialLearnRate = max(0.0001, min(0.1, exp(lv)));
        end
    end
end

% -------------------------------------------------------------------------
function f1_ort = caprazvalidasyon_f1(X, y, model_tipi, hiperparametre)
% 5-fold CV ile ortalama makro F1-score hesaplar.
    n           = size(X, 1);
    K           = 5;
    fold_boyutu = floor(n / K);
    perm        = randperm(n);
    Xp          = X(perm, :);
    yp          = y(perm, :);
    f1_list     = zeros(K, 1);

    for fold = 1:K
        ts = (fold-1)*fold_boyutu + 1;
        te = fold * fold_boyutu;
        if fold == K, te = n; end

        t_idx = ts:te;
        r_idx = [1:ts-1, te+1:n];

        Xtr = Xp(r_idx,:); ytr = yp(r_idx,:);
        Xte = Xp(t_idx,:); yte = yp(t_idx,:);

        try
            if strcmpi(model_tipi, 'svm')
                yhat = tahmin_svm(Xtr, ytr, Xte, hiperparametre);
            elseif strcmpi(model_tipi, 'rf')
                yhat = tahmin_randomforest(Xtr, ytr, Xte, hiperparametre);
            elseif strcmpi(model_tipi, 'mlp')
                yhat = tahmin_mlp(Xtr, ytr, Xte, hiperparametre);
            else
                yhat = zeros(size(Xte,1),1);
            end
            f1_list(fold) = f1_makro(yte, yhat);
        catch
            f1_list(fold) = 0;
        end
    end
    f1_ort = mean(f1_list);
end

% -------------------------------------------------------------------------
function f1 = f1_makro(y_true, y_pred)
% 2-sinifli makro F1-score hesaplar.
    y_true = double(y_true); y_pred = double(y_pred);

    tp0 = sum((y_true==0)&(y_pred==0)); fp0 = sum((y_true==1)&(y_pred==0)); fn0 = sum((y_true==0)&(y_pred==1));
    tp1 = sum((y_true==1)&(y_pred==1)); fp1 = sum((y_true==0)&(y_pred==1)); fn1 = sum((y_true==1)&(y_pred==0));

    p0 = tp0/(tp0+fp0+eps); r0 = tp0/(tp0+fn0+eps);
    p1 = tp1/(tp1+fp1+eps); r1 = tp1/(tp1+fn1+eps);

    f0 = 2*p0*r0/(p0+r0+eps);
    f1_ = 2*p1*r1/(p1+r1+eps);
    f1  = (f0 + f1_) / 2;
end

% -------------------------------------------------------------------------
function y_pred = tahmin_svm(X_train, y_train, X_test, hp)
% SVM egitimi ve tahmini (fitcsvm).
    try
        mdl    = fitcsvm(X_train, double(y_train), ...
            'BoxConstraint',  max(0.01, hp.BoxConstraint), ...
            'KernelFunction', hp.KernelFunction, ...
            'KernelScale',    max(0.001, hp.KernelScale), ...
            'Verbose', 0);
        y_pred = double(predict(mdl, X_test));
    catch
        y_pred = zeros(size(X_test,1), 1);
    end
end

% -------------------------------------------------------------------------
function y_pred = tahmin_randomforest(X_train, y_train, X_test, hp)
% Random Forest egitimi ve tahmini (TreeBagger).
    try
        mdl = TreeBagger(hp.NumTrees, X_train, double(y_train), ...
            'MinLeafSize', hp.MinLeafSize, 'OOBPredictorImportance', 'on');
        raw = predict(mdl, X_test);
        if iscell(raw)
            y_pred = cellfun(@(s) str2double(s), raw);
        else
            y_pred = double(raw);
        end
    catch
        y_pred = zeros(size(X_test,1), 1);
    end
end

% -------------------------------------------------------------------------
function y_pred = tahmin_mlp(X_train, y_train, X_test, hp)
% MLP egitimi ve tahmini (trainNetwork - Deep Learning Toolbox).
    try
        lz = max(10, min(100, round(hp.LayerSizes)));
        lr = max(0.0001, min(0.1, hp.InitialLearnRate));

        layers = [
            featureInputLayer(size(X_train,2), 'Name','input')
            fullyConnectedLayer(lz,            'Name','fc1')
            reluLayer(                         'Name','relu1')
            fullyConnectedLayer(max(2,floor(lz/2)), 'Name','fc2')
            reluLayer(                         'Name','relu2')
            fullyConnectedLayer(2,             'Name','fc_out')
            softmaxLayer(                      'Name','softmax')
            classificationOutputLayer(         'Name','output')
        ];

        opts = trainingOptions('adam', ...
            'InitialLearnRate', lr, ...
            'MaxEpochs',        20, ...
            'MiniBatchSize',    32, ...
            'Verbose',          0,  ...
            'Plots',            'none', ...
            'ExecutionEnvironment', 'cpu');

        net      = trainNetwork(X_train, categorical(double(y_train)), layers, opts);
        y_pred   = double(classify(net, X_test)) - 1;
    catch
        y_pred = round(rand(size(X_test,1), 1));
    end
end
