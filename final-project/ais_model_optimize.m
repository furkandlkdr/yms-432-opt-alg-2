function sonuc = ais_model_optimize(X, y, baseline, iterasyon_sayisi)
    % Tek bir model icin tek parametreli AIS optimizasyonu yapar
    % Giriş:
    %   X, y: Veri seti
    %   baseline: ais_baseline_olustur cikisi
    %   iterasyon_sayisi: Deneme sayisi
    % Çıkış:
    %   sonuc: En iyi parametreler, afiniteler ve gecmis

    en_iyi_parametreler = baseline.parametreler;
    en_iyi_afinite = ais_model_degerlendir(X, y, baseline.model_tipi, en_iyi_parametreler);
    afinite_gecmisi = zeros(iterasyon_sayisi, 1);

    fprintf('Baseline afinitesi: %.4f\n', en_iyi_afinite);

    for iterasyon = 1:iterasyon_sayisi
        alan_adi = baseline.aranacak_alanlar{randi(numel(baseline.aranacak_alanlar))};
        aday_parametreler = ais_parametre_mutasyonu(baseline, en_iyi_parametreler, alan_adi);
        aday_afinite = ais_model_degerlendir(X, y, baseline.model_tipi, aday_parametreler);

        if aday_afinite >= en_iyi_afinite
            en_iyi_afinite = aday_afinite;
            en_iyi_parametreler = aday_parametreler;
        end

        afinite_gecmisi(iterasyon) = en_iyi_afinite;

        if mod(iterasyon, 5) == 0 || iterasyon == 1
            fprintf('  Iterasyon %3d | Alan: %-18s | En iyi: %.4f\n', iterasyon, alan_adi, en_iyi_afinite);
        end
    end

    sonuc = struct();
    sonuc.model_adi = baseline.model_adi;
    sonuc.model_tipi = baseline.model_tipi;
    sonuc.baseline = baseline.parametreler;
    sonuc.en_iyi_parametreler = en_iyi_parametreler;
    sonuc.en_iyi_afinite = en_iyi_afinite;
    sonuc.afinite_gecmisi = afinite_gecmisi;
end

function afinite = ais_model_degerlendir(X, y, model_tipi, parametreler)
    % 5-fold CV ile makro F1 hesaplar
    n_ornek = size(X, 1);
    fold_sayisi = 5;
    fold_boyutu = floor(n_ornek / fold_sayisi);
    siralama = randperm(n_ornek);
    X = X(siralama, :);
    y = y(siralama, :);
    class_names = unique(y);

    fold_sonuclari = zeros(fold_sayisi, 1);

    for fold = 1:fold_sayisi
        baslangic = (fold - 1) * fold_boyutu + 1;
        bitis = fold * fold_boyutu;
        if fold == fold_sayisi
            bitis = n_ornek;
        end

        test_idx = baslangic:bitis;
        train_idx = [1:baslangic-1, bitis+1:n_ornek];

        X_train = X(train_idx, :);
        y_train = y(train_idx, :);
        X_test = X(test_idx, :);
        y_test = y(test_idx, :);

        try
            switch lower(model_tipi)
                case 'svm'
                    mdl = fitcsvm(X_train, y_train, ...
                        'KernelFunction', parametreler.KernelFunction, ...
                        'KernelScale', max(0.001, parametreler.KernelScale), ...
                        'BoxConstraint', max(0.01, parametreler.BoxConstraint), ...
                        'Standardize', true, ...
                        'ClassNames', class_names);
                    y_pred = predict(mdl, X_test);

                case 'ensemble'
                    mdl = fitcensemble(X_train, y_train, ...
                        'Method', 'Subspace', ...
                        'NumLearningCycles', max(10, round(parametreler.NumLearningCycles)), ...
                        'Learners', 'knn', ...
                        'NPredToSample', max(1, round(parametreler.NPredToSample)), ...
                        'ClassNames', class_names);
                    y_pred = predict(mdl, X_test);

                case 'mlp'
                    mdl = fitcnet(X_train, y_train, ...
                        'LayerSizes', max(10, min(100, round(parametreler.LayerSizes))), ...
                        'Activations', parametreler.Activations, ...
                        'Lambda', max(0, parametreler.Lambda), ...
                        'IterationLimit', max(200, round(parametreler.IterationLimit)), ...
                        'Standardize', true, ...
                        'ClassNames', class_names);
                    y_pred = predict(mdl, X_test);

                case 'knn'
                    mdl = fitcknn(X_train, y_train, ...
                        'Distance', parametreler.Distance, ...
                        'NumNeighbors', max(1, round(parametreler.NumNeighbors)), ...
                        'DistanceWeight', parametreler.DistanceWeight, ...
                        'Standardize', true, ...
                        'ClassNames', class_names);
                    y_pred = predict(mdl, X_test);

                otherwise
                    y_pred = zeros(size(y_test));
            end

            fold_sonuclari(fold) = ais_makro_f1(y_test, y_pred);
        catch
            fold_sonuclari(fold) = 0;
        end
    end

    afinite = mean(fold_sonuclari);
end

function y = ais_makro_f1(y_true, y_pred)
    % Iki sinifli makro F1 hesaplar
    y_true = double(y_true);
    y_pred = double(y_pred);

    tp0 = sum((y_true == 0) & (y_pred == 0));
    fp0 = sum((y_true == 1) & (y_pred == 0));
    fn0 = sum((y_true == 0) & (y_pred == 1));

    tp1 = sum((y_true == 1) & (y_pred == 1));
    fp1 = sum((y_true == 0) & (y_pred == 1));
    fn1 = sum((y_true == 1) & (y_pred == 0));

    precision0 = tp0 / (tp0 + fp0 + eps);
    recall0 = tp0 / (tp0 + fn0 + eps);
    precision1 = tp1 / (tp1 + fp1 + eps);
    recall1 = tp1 / (tp1 + fn1 + eps);

    f1_0 = 2 * (precision0 * recall0) / (precision0 + recall0 + eps);
    f1_1 = 2 * (precision1 * recall1) / (precision1 + recall1 + eps);

    y = (f1_0 + f1_1) / 2;
end

function aday = ais_parametre_mutasyonu(baseline, mevcut, alan_adi)
    % Tek bir parametreyi mutasyona ugratarak aday uretir
    aday = mevcut;
    alt = lower(baseline.model_tipi);

    switch alt
        case 'svm'
            switch alan_adi
                case 'BoxConstraint'
                    aday.BoxConstraint = max(baseline.sinirlar.BoxConstraint(1), ...
                        min(baseline.sinirlar.BoxConstraint(2), mevcut.BoxConstraint * 10^(0.25 * randn())));
                case 'KernelFunction'
                    secenekler = {'linear', 'rbf', 'polynomial'};
                    aday.KernelFunction = secenekler{randi(numel(secenekler))};
                case 'KernelScale'
                    aday.KernelScale = max(baseline.sinirlar.KernelScale(1), ...
                        min(baseline.sinirlar.KernelScale(2), mevcut.KernelScale * 10^(0.25 * randn())));
            end

        case 'ensemble'
            switch alan_adi
                case 'NumLearningCycles'
                    aday.NumLearningCycles = max(baseline.sinirlar.NumLearningCycles(1), ...
                        min(baseline.sinirlar.NumLearningCycles(2), mevcut.NumLearningCycles + randi([-10 10])));
                case 'NPredToSample'
                    aday.NPredToSample = max(baseline.sinirlar.NPredToSample(1), ...
                        min(baseline.sinirlar.NPredToSample(2), mevcut.NPredToSample + randi([-3 3])));
            end

        case 'mlp'
            switch alan_adi
                case 'LayerSizes'
                    aday.LayerSizes = max(baseline.sinirlar.LayerSizes(1), ...
                        min(baseline.sinirlar.LayerSizes(2), mevcut.LayerSizes + randi([-20 20])));
                case 'Activations'
                    secenekler = {'relu', 'tanh', 'sigmoid'};
                    aday.Activations = secenekler{randi(numel(secenekler))};
                case 'Lambda'
                    if mevcut.Lambda <= 0
                        aday.Lambda = 10^(-4 + 3 * rand());
                    else
                        aday.Lambda = max(baseline.sinirlar.Lambda(1), min(baseline.sinirlar.Lambda(2), mevcut.Lambda * 10^(0.5 * randn())));
                    end
                case 'IterationLimit'
                    aday.IterationLimit = max(baseline.sinirlar.IterationLimit(1), ...
                        min(baseline.sinirlar.IterationLimit(2), mevcut.IterationLimit + randi([-200 200])));
            end

        case 'knn'
            switch alan_adi
                case 'NumNeighbors'
                    aday.NumNeighbors = max(baseline.sinirlar.NumNeighbors(1), ...
                        min(baseline.sinirlar.NumNeighbors(2), mevcut.NumNeighbors + randi([-4 4])));
                case 'Distance'
                    secenekler = {'euclidean', 'cityblock', 'chebychev'};
                    aday.Distance = secenekler{randi(numel(secenekler))};
                case 'DistanceWeight'
                    secenekler = {'squaredinverse', 'inverse', 'equal'};
                    aday.DistanceWeight = secenekler{randi(numel(secenekler))};
            end
    end
end