function f1_ortalama = caprazvalidasyon_f1(X, y, model_tipi, hiperparametre)
    % 5-fold çapraz validasyonla F1-score hesaplar
    % Giriş:
    %   X: Öznitelik matrixi
    %   y: Hedef etiketi
    %   model_tipi: 'svm', 'rf', 'mlp'
    %   hiperparametre: Model parametreleri (struct)
    % Çıkış:
    %   f1_ortalama: 5 fold'un ortalama makro F1-skoru
    
    % 5-fold çapraz validasyon bölme yap
    n = size(X, 1);
    fold_sayisi = 5;
    fold_boyutu = floor(n / fold_sayisi);
    
    % Rastgele permütasyon
    idx_permute = randperm(n);
    X_permute = X(idx_permute, :);
    y_permute = y(idx_permute, :);
    
    f1_scoreleri = zeros(fold_sayisi, 1);
    
    % Her fold için eğit-test yap
    for fold = 1:fold_sayisi
        % Test indexleri
        test_baslangic = (fold - 1) * fold_boyutu + 1;
        test_son = fold * fold_boyutu;
        if fold == fold_sayisi
            test_son = n;
        end
        
        test_idx = test_baslangic:test_son;
        train_idx = [1:test_baslangic-1, test_son+1:n];
        
        % Eğitim ve test verisi ayır
        X_train = X_permute(train_idx, :);
        y_train = y_permute(train_idx, :);
        X_test = X_permute(test_idx, :);
        y_test = y_permute(test_idx, :);
        
        % Model eğitimi ve tahmin
        y_pred = [];
        try
            if strcmpi(model_tipi, 'svm')
                y_pred = tahmin_svm(X_train, y_train, X_test, hiperparametre);
            elseif strcmpi(model_tipi, 'rf')
                y_pred = tahmin_randomforest(X_train, y_train, X_test, hiperparametre);
            elseif strcmpi(model_tipi, 'mlp')
                y_pred = tahmin_mlp(X_train, y_train, X_test, hiperparametre);
            end
            
            % F1-score hesapla (makro)
            f1_scoreleri(fold) = hesapla_f1_makro(y_test, y_pred);
        catch
            % Hata durumunda F1 = 0 ata
            f1_scoreleri(fold) = 0;
        end
    end
    
    % Ortalama F1-score döndür
    f1_ortalama = mean(f1_scoreleri);
end

function f1_makro = hesapla_f1_makro(y_true, y_pred)
    % Makro F1-score hesapla
    % Sınıf 0 için F1 ve Sınıf 1 için F1'in ortalaması
    
    y_true = double(y_true);
    y_pred = double(y_pred);
    
    % Sınıf 0 için TP, FP, FN
    tp0 = sum((y_true == 0) & (y_pred == 0));
    fp0 = sum((y_true == 1) & (y_pred == 0));
    fn0 = sum((y_true == 0) & (y_pred == 1));
    
    % Sınıf 1 için TP, FP, FN
    tp1 = sum((y_true == 1) & (y_pred == 1));
    fp1 = sum((y_true == 0) & (y_pred == 1));
    fn1 = sum((y_true == 1) & (y_pred == 0));
    
    % Precision ve Recall hesapla
    precision0 = tp0 / (tp0 + fp0 + eps);
    recall0 = tp0 / (tp0 + fn0 + eps);
    
    precision1 = tp1 / (tp1 + fp1 + eps);
    recall1 = tp1 / (tp1 + fn1 + eps);
    
    % F1-score hesapla
    f1_0 = 2 * (precision0 * recall0) / (precision0 + recall0 + eps);
    f1_1 = 2 * (precision1 * recall1) / (precision1 + recall1 + eps);
    
    % Makro F1
    f1_makro = (f1_0 + f1_1) / 2;
end

function y_pred = tahmin_svm(X_train, y_train, X_test, hiperparametre)
    % SVM modeli eğit ve tahmin yap
    try
        % Giriş parametrelerini double'a çevir
        y_train = double(y_train);
        
        % SVM modeli oluştur ve eğit
        mdl = fitcsvm(X_train, y_train, ...
            'BoxConstraint', max(0.01, hiperparametre.BoxConstraint), ...
            'KernelFunction', hiperparametre.KernelFunction, ...
            'KernelScale', max(0.001, hiperparametre.KernelScale), ...
            'Verbose', 0);
        
        % Tahmin yap
        y_pred = predict(mdl, X_test);
        y_pred = double(y_pred);
    catch ME
        % Hata durumunda sıfırlarla doldur
        y_pred = zeros(size(X_test, 1), 1);
    end
end

function y_pred = tahmin_randomforest(X_train, y_train, X_test, hiperparametre)
    % Random Forest modeli eğit ve tahmin yap
    try
        % TreeBagger binary classification için kullanılır
        y_train = double(y_train);
        mdl = TreeBagger(hiperparametre.NumTrees, X_train, y_train, ...
            'MinLeafSize', hiperparametre.MinLeafSize, ...
            'OOBPredictorImportance', 'on');
        
        % Tahmin yap
        [y_pred, ~] = predict(mdl, X_test);
        
        % String çıktısını sayıya çevir
        if iscellstr(y_pred) || isstring(y_pred)
            % String ise sayıya çevir
            y_pred = cellfun(@(x) str2double(x), y_pred);
        end
        y_pred = double(y_pred);
    catch
        y_pred = zeros(size(X_test, 1), 1);
    end
end

function y_pred = tahmin_mlp(X_train, y_train, X_test, hiperparametre)
    % MLP (Neural Network) modeli eğit ve tahmin yap
    % MATLAB R2020b+ önerilir, R2019b+ da çalışabilir
    try
        % Sınıfları kategorik hale getir
        y_train = double(y_train);
        y_train_cat = categorical(y_train);
        
        % Layer size parametresini al ve round et
        layer_size = max(10, min(100, round(hiperparametre.LayerSizes)));
        
        % Simple fully connected network
        layers = [
            featureInputLayer(size(X_train, 2), 'Name', 'input')
            fullyConnectedLayer(layer_size, 'Name', 'fc1')
            reluLayer('Name', 'relu')
            fullyConnectedLayer(layer_size/2, 'Name', 'fc2')
            reluLayer('Name', 'relu2')
            fullyConnectedLayer(2, 'Name', 'fc3')
            softmaxLayer('Name', 'softmax')
            classificationOutputLayer('Name', 'output')
            ];
        
        % Learning rate parametresini al
        learn_rate = max(0.0001, min(0.1, hiperparametre.InitialLearnRate));
        
        % Eğitim seçenekleri (minimal)
        options = trainingOptions('adam', ...
            'InitialLearnRate', learn_rate, ...
            'MaxEpochs', 20, ...
            'MiniBatchSize', 32, ...
            'Verbose', 0, ...
            'Plots', 'none', ...
            'ExecutionEnvironment', 'cpu');
        
        % Modeli eğit
        net = trainNetwork(X_train, y_train_cat, layers, options);
        
        % Test seti üzerinde tahmin yap
        y_pred_cat = classify(net, X_test);
        
        % Categorical sonuçları numeric'e çevir (1,2 -> 0,1)
        y_pred = double(y_pred_cat) - 1;
    catch ME
        % Hata durumunda rastgele tahmin yap (fallback)
        y_pred = round(rand(size(X_test, 1), 1));
    end
end
