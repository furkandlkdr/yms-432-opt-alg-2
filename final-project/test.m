%% TEST SCRIPT - CLONALG SISTEM DOĞRULAMASI
% Bu script temel fonksiyonların çalışıp çalışmadığını kontrol eder

clear all; close all; clc;

fprintf('\n=== CLONALG SISTEM TEST ===\n\n');

% Test 1: Veri Yükleme
fprintf('Test 1: Veri Yükleme...');
try
    [X, y] = veri_yukle();
    fprintf(' BAŞARILI\n');
    fprintf('  X boyutu: %d x %d\n', size(X, 1), size(X, 2));
    fprintf('  y boyutu: %d x %d\n', size(y, 1), size(y, 2));
catch ME
    fprintf(' HATA\n');
    fprintf('  %s\n', ME.message);
end

% Test 2: Normalizasyon
fprintf('Test 2: Normalizasyon...');
try
    X_norm = normalize_veriler(X);
    fprintf(' BAŞARILI\n');
    fprintf('  Ortalama: %.6f, Std: %.6f\n', mean(X_norm(:)), std(X_norm(:)));
catch ME
    fprintf(' HATA\n');
    fprintf('  %s\n', ME.message);
end

% Test 3: SVM Hiperparametre Oluşturma
fprintf('Test 3: SVM Hiperparametre Oluşturma...');
try
    svm_hip = struct();
    svm_hip.BoxConstraint = 1.5;
    svm_hip.KernelFunction = 'rbf';
    svm_hip.KernelScale = 0.5;
    fprintf(' BAŞARILI\n');
    fprintf('  C = %.4f\n', svm_hip.BoxConstraint);
    fprintf('  Kernel = %s\n', svm_hip.KernelFunction);
    fprintf('  Gamma = %.4f\n', svm_hip.KernelScale);
catch ME
    fprintf(' HATA\n');
    fprintf('  %s\n', ME.message);
end

% Test 4: RF Hiperparametre Oluşturma
fprintf('Test 4: RF Hiperparametre Oluşturma...');
try
    rf_hip = struct();
    rf_hip.NumTrees = 50;
    rf_hip.MinLeafSize = 5;
    fprintf(' BAŞARILI\n');
    fprintf('  NumTrees = %d\n', rf_hip.NumTrees);
    fprintf('  MinLeafSize = %d\n', rf_hip.MinLeafSize);
catch ME
    fprintf(' HATA\n');
    fprintf('  %s\n', ME.message);
end

% Test 5: MLP Hiperparametre Oluşturma
fprintf('Test 5: MLP Hiperparametre Oluşturma...');
try
    mlp_hip = struct();
    mlp_hip.LayerSizes = 64;
    mlp_hip.Activation = 'relu';
    mlp_hip.InitialLearnRate = 0.001;
    fprintf(' BAŞARILI\n');
    fprintf('  LayerSizes = %d\n', mlp_hip.LayerSizes);
    fprintf('  Activation = %s\n', mlp_hip.Activation);
    fprintf('  InitialLearnRate = %.6f\n', mlp_hip.InitialLearnRate);
catch ME
    fprintf(' HATA\n');
    fprintf('  %s\n', ME.message);
end

% Test 6: Mutasyon Operatörü
fprintf('Test 6: Mutasyon (SVM)...');
try
    svm_mutant = mutasyon_operatoru(svm_hip, 0.5, 'svm', 0.1);
    fprintf(' BAŞARILI\n');
    fprintf('  Orijinal C: %.4f, Mutant C: %.4f\n', svm_hip.BoxConstraint, svm_mutant.BoxConstraint);
catch ME
    fprintf(' HATA\n');
    fprintf('  %s\n', ME.message);
end

% Test 7: Veri Bölme
fprintf('Test 7: Veri Bölme (80-20)...');
try
    n = size(X_norm, 1);
    train_idx = randperm(n, floor(n * 0.8));
    test_idx = setdiff(1:n, train_idx);
    X_train = X_norm(train_idx, :);
    y_train = y(train_idx, :);
    X_test = X_norm(test_idx, :);
    y_test = y(test_idx, :);
    fprintf(' BAŞARILI\n');
    fprintf('  Train: %d, Test: %d\n', size(X_train, 1), size(X_test, 1));
catch ME
    fprintf(' HATA\n');
    fprintf('  %s\n', ME.message);
end

% Test 8: F1-Score Hesaplama (basit test)
fprintf('Test 8: F1-Score Hesaplama...');
try
    y_true = [0; 1; 0; 1; 1];
    y_pred = [0; 1; 1; 1; 0];
    f1 = hesapla_f1_makro(y_true, y_pred);
    fprintf(' BAŞARILI\n');
    fprintf('  Örnek F1-Score: %.4f\n', f1);
catch ME
    fprintf(' HATA\n');
    fprintf('  %s\n', ME.message);
end

fprintf('\n=== TEST TAMAMLANDI ===\n\n');
fprintf('NOT: Tüm testler başarılı ise sistem çalışmaya hazırdır.\n');
fprintf('     main.m dosyasını çalıştırarak tam optimizasyonu başlatın.\n\n');

% Ek: Popülasyon oluşturma testi
fprintf('Test 9: SVM Popülasyonu Oluşturma (n=5)...');
try
    pop_svm = olustur_populasyon(5, 'svm');
    fprintf(' BAŞARILI\n');
    fprintf('  Popülasyon boyutu: %d\n', length(pop_svm));
    fprintf('  Örnek, ilk antikorun C: %.4f\n', pop_svm(1).BoxConstraint);
catch ME
    fprintf(' HATA\n');
    fprintf('  %s\n', ME.message);
end
